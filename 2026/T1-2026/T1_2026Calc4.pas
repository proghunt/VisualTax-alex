unit T1_2026Calc4;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls, T1_2026Declare, T1_2026common,
  T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns, T1_2026T1Rtns2;

  //20231207
  Procedure T4FHSA(RetNo: integer; FName: String; FNo: integer);
  Procedure S15(RetNo: integer; FName: String; FNo: integer);
  Procedure S11PRVYT(RetNo: integer; FName: string; FNo: integer);
  Procedure S12(RetNo: integer; FName: string; FNo: integer);
  //Procedure ONS12(RetNo: integer; FName: string; FNo: integer);
  Procedure S12BC(RetNo: integer; FName: string; FNo: integer);
  Procedure S12SK(RetNo: integer; FName: string; FNo: integer);
  Procedure S12NB(RetNo: integer; FName: string; FNo: integer); // 20151102
  Procedure HOMEBuy(RetNo: integer; FName: string; FNo: integer);
  Function GetTotACBUnits(RetNo: integer; FNo: integer; UpTo: integer): Real;
  Function GetTotACB(RetNo: integer; FNo: integer; UpTo: integer): Real;
  Procedure T1275(RetNo: integer; FName: string; FNo: integer);
  Procedure T1273(RetNo: integer; FName: string; FNo: integer);
  Procedure T1273A1(RetNo: integer; FName: string; FNo: integer);
  Procedure T1273A2(RetNo: integer; FName: string; FNo: integer);
  Procedure T1273ALI(RetNo: integer; FName: string; FNo: integer);
  Procedure T1273OTH(RetNo: integer; FName: string; FNo: integer);
  Function NisaNIAfterAdj(RetNo, FNo: integer; BusUseOfHome, Percent: Real): Real;
  Procedure S11PRV(RetNo: integer; FName: string; FNo: integer);
  Function BlankIfZero(x: Real): String;
  Function GetKSRuleAmount(RetNo: integer; sRule: String): Real;
  procedure T1ADJ(RetNo: integer; FName: String; FNo: integer);
  Procedure T4RSP(RetNo: integer; FName: String; FNo: integer);
  Procedure T1135(RetNo: integer; FName: string; FNo: integer);
  Procedure CCA2000(RetNo: integer; FName: string; FNo: integer);
  procedure ACBFrm(RetNo: integer; FName: String; FNo: integer);
  procedure PORTFL(RetNo: integer; FName: String; FNo: integer);
  Procedure CAREGVR(RetNo: integer; FName: string; FNo: integer);
  // Procedure CAREPRV(RetNo:integer;FName:string;FNo:integer); //20180318
  Procedure S13(RetNo: integer; FName: string; FNo: integer);
  Procedure T2205(RetNo: integer; FName: String; FNo: integer);
  procedure CFR(RetNo: integer; FName: String; FNo: integer);
  procedure OLDLOSS(RetNo: integer; FName: String; FNo: integer);
  Procedure T1M(RetNo: integer; FName: string; FNo: integer);
  Procedure T1033(RetNo: integer; FName: string; FNo: integer);
  Procedure GST370(RetNo: integer; FName: string; FNo: integer);
  Procedure S9(RetNo: integer; FName: string; FNo: integer);
  Procedure MEDREF(RetNo: integer; FName: string; FNo: integer);
  Procedure S11(RetNo: integer; FName: string; FNo: integer);
  Procedure SNRESA(RetNo: integer; FName: string; FNo: integer);
  Procedure SNRESB(RetNo: integer; FName: string; FNo: integer);
  Procedure SNRC(RetNo: integer; FName: string; FNo: integer);
  Procedure T1153(RetNo: integer; FName: string; FNo: integer);
  Procedure T1170(RetNo: integer; FName: string; FNo: integer);
  Procedure T1172(RetNo: integer; FName: string; FNo: integer);
  procedure CLAW(RetNo: integer; FName: String; FNo: integer);
  Procedure CopyFromT777(RetNo, FNo: integer);
  Procedure CopyFromT777Multiple(RetNo, FNo: integer);
  //Procedure CopyFromT777S(RetNo: integer);  //20210325
  //Procedure CopyFromT777SMultiple(RetNo: integer);  //20210325
  procedure T1163(RetNo: integer; FName: String; FNo: integer);
  procedure T1175(RetNo: integer; FName: String; FNo: integer);
  procedure T1175H(RetNo: integer; FName: String; FNo: integer);
  procedure T2200(RetNo: integer; FName: String; FNo: integer);
  procedure T5008(RetNo: integer; FName: String; FNo: integer);
  Function Get6153(RetNo: integer): Real;
  Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo: integer);
  // 20160124 //20160202 Igor
  Procedure T2048(RetNo: integer; FName: String; FNo: integer);
  Procedure T24EOT(RetNo: integer; FName: String; FNo: integer);


implementation

uses
  vtCommon, T1_2026, T1_2026Calc, T1_2026EFRules, vtDynData, vtTrimStr, vtShared;

procedure S9(RetNo: Integer; FName: string; FNo: Integer);
const
  IncThreshHold = 253414; //246752; //20241123  4235675; //20231219 ///221708; //216511; //214368; //20220118  //20221126

var
  i, DonFNo: Integer;
  x, y: Real;
  IncrBy, TotTaxPayable, OptimumDonationsAmount: Real;
begin
  DonFNo:= GetFormNo('DON');
  //if Ret[RetNo].FrmHasData[DonFNo] = false  then exit; //20210311 experiment to retain value 38
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[39]:= Vl(FetchElmFNo(RetNo, DonFNo, 179)); //20210227
    Tv[16]:= Vl(FetchElmFNo(RetNo, DonFNo, 180)) + Vl(FetchElmFNo(RetNo, DonFNo, 181)) + Vl(FetchElmFNo(RetNo, DonFNo, 177)) + Vl(FetchElmFNo(RetNo, DonFNo, 178));
    //Tv[16]:=MaxR(0,TV[16]-Vl(FetchElmFNo(RetNo, DonFNo, 106))); //Experimental //20210312
    Tv[22]:= Vl(FetchElmFNo(RetNo, DonFNo, 136)) + Vl(FetchElmFNo(RetNo, DonFNo, 141)) + Vl(FetchElmFNo(RetNo, DonFNo,90)) + Vl(FetchElmFNo(RetNo, DonFNo, 95)) + Vl(FetchElmFNo(RetNo, DonFNo, 100));
    Tv[18]:= Vl(FetchElmFNo(RetNo, DonFNo, 186)) + Vl(FetchElmFNo(RetNo, DonFNo, 188)); //20210315 FNo
    Tv[19]:= Vl(FetchElmFNo(RetNo, DonFNo, 7)) + Vl(FetchElmFNo(RetNo, DonFNo, 189)); //20210315

    Tv[20]:=Vl(FetchElmFNo(RetNo, DonFNo, 187)) + Vl(FetchElmFNo(RetNo, DonFNo, 190)); //20210315

    Tv[1]:=(Tv[16] + Tv[18] + Tv[19] + Tv[20]) * Tv[39]/100; //  //20260405 //20260209;CZ Must ue the % on the top
      //(Tv[16] + Tv[22] + Tv[18] + Tv[19] + Tv[20]) * Tv[39]/100; //  //20260209;CZ Must ue the % on the top

    Tv[40]:= Tv[1] * Tv[39] / 100; //20210227
     // Experiment Vl(FetchElmFNo(RetNo, DonFNo, 110)) * Tv[39]/100;

    Tv[2]:= Lnn[23600];

    if not IsDeceased(RetNo) then
      Tv[3]:= Tv[2] * 0.75
    else
      Tv[3]:= Tv[2];

    Tv[4]:=Tv[26];  //20260328
      // Vl(FetchElmFNo(RetNo, DonFNo, 150)); // Vl(FetchElm(RetNo,'DON',165)); //20210315  DonFno
    Tv[5]:=Tv[36]; //20260406
      // MaxR(0, Vl(FetchElmFNo(RetNo, DonFNo, 153)) - Vl(FetchElmFNo(RetNo, DonFNo, 156)));
    Tv[6]:= Tv[4] + Tv[5];
    Tv[7]:= Tv[6] * 0.25;
    Tv[21]:= Tv[3] + Tv[7]; // 20210219
    Tv[8]:= Tv[21]; // 20210219

    if (Tv[8] > Tv[2]) then Tv[8]:= Tv[2]; // net income

    if UpperCase(FetchElm(RetNo, DonFNo, 134)).Equals('Y') then //20210315 //override claim from DONATIONS form
      Tv[9]:= Vl(FetchElm(RetNo, DonFNo, 110)) //Vl(FetchElm(RetNo,DonFNo,191))
    else
    begin
      Tv[9]:= MinR(Tv[1], Tv[8]); //MinR(Tv[40], Tv[8]);  //20250107
      //Tv[9]:= MinR(Tv[9], CalcMaxDonations(RetNo)); //20210301 //questionable???
    end;



    if (Vl(FetchElm(RetNo, 'DON', 172)) > 0) then // gifts on don sch
      Tv[10]:= Vl(FetchElm(RetNo, 'DON', 173))
    else
      Tv[10]:= 0;

    Tv[11]:= Tv[9] + Tv[10];
    Tv[13]:= MinR(200, Tv[11]);
    Tv[15]:= MaxR(0, Tv[11] - Tv[13]); // ??
    //Tv[23]:= Tv[15];   //20260319
    Tv[25]:=MaxR(0, Tv[15] - Tv[24]); //20260328  // MaxR(0, Tv[23] - Tv[24]);
    Tv[36]:= MinR(Tv[13], Tv[24]);
    Tv[26]:= Tv[25] + Tv[36];
    Tv[27]:= ret[RetNo].Lnn[26000];
    Tv[28]:= IncThreshHold;
    Tv[29]:= MaxR(0, Tv[27] - Tv[28]);

    //Page 2
    Tv[30]:= MinR(Tv[25], Tv[29]); //20211212 //MinR(Tv[26], Tv[29]);

    if (Ret[RetNo].Lnn[26000] < IncThreshHold) then
      Tv[30]:= 0;

    Tv[31]:= Tv[30] * 0.33;
    Tv[14]:= Tv[15];
    Tv[17]:= Tv[30]; // Tv[29];  //20210217
    Tv[32]:= MaxR(0, Tv[14] - Tv[17]); // 20210216
    Tv[33]:= Tv[32] * 0.29;
    Tv[34]:= Tv[13];
    Tv[35]:= Tv[34] * 0.145;
    Tv[12]:= Tv[31] + Tv[33] + Tv[35]; // 20180122

    //-------------------------------
    //20260405
    if Tv[44]=0 then
    Begin
     for i:=45 to 48 do Begin Tv[i]:=0;end;
    End
    Else
    Begin
     Tv[47]:=MinR(Tv[45],Tv[46]);
     Tv[48]:=MinR(Tv[44],Tv[47]);
    End;

    if Tv[50]=0 then
    Begin
     for i:=53 to 54 do Begin Tv[i]:=0;end;
    End
    Else
    Begin
     Tv[53]:=MinR(Tv[51],Tv[52]);
     Tv[54]:=MinR(Tv[50],Tv[53]);
    End;

    if Tv[56]=0 then
    Begin
     for i:=57 to 60 do Begin Tv[i]:=0;end;
    End
    Else
    Begin
     Tv[59]:=MinR(Tv[57],Tv[58]);
     Tv[60]:=MinR(Tv[56],Tv[59]);
    end;
    //------------------
    Tv[17]:=Tv[48]+Tv[54]+Tv[60];
    Tv[26]:=Tv[17]+Tv[23];

    Tv[36]:=MaxR(0,Tv[41]-Tv[42]);  //20260405

  end;

  SaveTv(RetNo, FName, FNo);
end;

//20250929 Igor <<<
(* //20210312
Procedure S9(RetNo: integer; FName: string; FNo: integer);
Const
  IncThreshHold = 214368; // 20200216  //210371;
Var
  DonFNo: integer;
  x, y: Real;
Begin
  DonFNo := GetFormNo('DON');
  //if Ret[RetNo].FrmHasData[DonFNo] = false  then exit; //20210311 experiment to retain value 38


  LoadTv(RetNo, FName, FNo);
  With ret[RetNo] do
  begin
    Tv[39]:=Vl(FetchElmFNo(RetNo, DonFNo, 179));  //20210227
    // 20190504
    Tv[16] := Vl(FetchElmFNo(RetNo, DonFNo, 180)) +
      Vl(FetchElmFNo(RetNo, DonFNo, 181)) + Vl(FetchElmFNo(RetNo, DonFNo, 177))
      + Vl(FetchElmFNo(RetNo, DonFNo, 178));
    //Tv[16]:=MaxR(0,TV[16]-Vl(FetchElmFNo(RetNo, DonFNo, 106))); //Experimental //20210312

    Tv[22] := Vl(FetchElmFNo(RetNo, DonFNo, 118)); // 2021020 C/F
    // Tv[16] := Vl(FetchElm(RetNo,'DON',180))+Tv[181]+Tv[177]+Tv[178];  //177 instead if 117 //20180408

    Tv[18] := Vl(FetchElm(RetNo, 'DON', 186)) + Vl(FetchElm(RetNo, 'DON', 188));
    // 20191212   // Tv[18]:= Vl(FetchElm(RetNo,'DON',183))+Vl(FetchElm(RetNo,'DON',188)); //20191212

    Tv[19] := Vl(FetchElm(RetNo, 'DON', 7)) + Vl(FetchElm(RetNo, 'DON', 189));
    Tv[20] := Vl(FetchElm(RetNo, 'DON', 187)) + Vl(FetchElm(RetNo, 'DON', 190));
    // ------------------------------
    Tv[1] := Tv[16] + Tv[22] + Tv[18] + Tv[19] + Tv[20];
    Tv[40]:=Tv[1] * Tv[39]/100;    //20210227

    Tv[2] := Lnn[23600];
    If IsDeceased(RetNo) = False then // 20131215
      Tv[3] := Tv[2] * 0.75
    else
      Tv[3] := Tv[2];

    Tv[4] := Vl(FetchElm(RetNo, 'DON', 150)); // Vl(FetchElm(RetNo,'DON',165));
    Tv[5] := MaxR(0, Vl(FetchElm(RetNo, 'DON', 153)) -
      Vl(FetchElm(RetNo, 'DON', 156)));
    Tv[6] := Tv[4] + Tv[5];
    Tv[7] := Tv[6] * 0.25;
    Tv[21] := Tv[3] + Tv[7]; // 20210219
    Tv[8] := Tv[21]; // 20210219
    If Tv[8] > Tv[2] then
      Tv[8] := Tv[2]; // net income
    // ------------------------------------
    // Tv[9] := CalcMaxDonations(RetNo);
    // MinR(Tv[1],Tv[8]); //Tv[9] := MinR(Tv[1],Tv[8]);  //20210221

    if UpperCase(Frm[FNo].Strings[37]) = 'Y' then
    Begin
     if Tv[38]>Tv[40] then Tv[38]:=Tv[40];
     if Tv[38]>Tv[8] then Tv[38]:=Tv[8];
     Tv[9]:=Tv[38];
    End
    Else
    Begin
     Tv[38]:=0; //20210311   //if blank of N, override amount s/b zero
     x:=CalcMaxDonations(RetNo); //20210311
     Tv[9] := MinR(Tv[40], Tv[8]);   //20210227
     Tv[9]:=MinR(Tv[9],CalcMaxDonations(RetNo));  //20210301
     {
      x:=CalcMaxDonations(RetNo);
      Tv[9] := MinR(Tv[9],x);  //20210228
     y:=Ret[RetNo].Lnn[42900];
     Tv[9]:=MinR(Tv[9],y);
    }
    End;


    // -------------------------------------------------------------

    If Vl(FetchElm(RetNo, 'DON', 172)) > 0 then // gifts on don sch
      Tv[10] := Vl(FetchElm(RetNo, 'DON', 173))
    Else
      Tv[10] := 0; // 20130303
    Tv[11] := Tv[9] + Tv[10];
    Tv[13] := MinR(200, Tv[11]);
    Tv[15] := MaxR(0, Tv[11] - Tv[13]); // ??
    Tv[23] := Tv[15];
    Tv[25] := MaxR(0, Tv[23] - Tv[24]);
    Tv[36] := MinR(Tv[13], Tv[24]);
    Tv[26] := Tv[25] + Tv[36];
    Tv[27] := ret[RetNo].Lnn[26000];
    Tv[28] := IncThreshHold;
    Tv[29] := MaxR(0, Tv[27] - Tv[28]);
    Tv[30] := MinR(Tv[26], Tv[29]);
    if ret[RetNo].Lnn[26000] < IncThreshHold then
      Tv[30] := 0; // 20161204
    Tv[31] := Tv[30] * 33 / 100;
    // 20210216
    Tv[14] := Tv[15];
    Tv[17] := Tv[30]; // Tv[29];  //20210217
    Tv[32] := MaxR(0, Tv[14] - Tv[17]); // 20210216
    Tv[33] := Tv[32] * 29 / 100;
    Tv[34] := Tv[13];
    Tv[35] := Tv[34] * 15 / 100;
    Tv[12] := Tv[31] + Tv[33] + Tv[35]; // 20180122

    // 20210216
    {
      Tv[14]:=Tv[12];  //20210216
      Tv[21]:=Vl(FetchElm(RetNo,'DON',186)) * Vl(FetchElm(RetNo,'DON',179))/100;//20130822;
      Tv[22]:=Tv[21]*25/100; //20130822;
      Tv[17] := Tv[14]+Tv[22]; //20180122 //Tv[31]+Tv[33]+Tv[35]+Tv[22]; //20161119 //Tv[13]+Tv[15]+Tv[22]; //20130822;
    }
  end;
  SaveTv(RetNo, FName, FNo);
end;
*)

//20250217
Procedure MEDREF(RetNo: integer; FName: string; FNo: integer);
Const MaxAdjustedFamNetInc=63374;
var
  x1, x2: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Tv[3] :=SelectNetIncomeAmount(RetNo); //20250222  //Lnn[23600];  //jz//20250221 //selectNetIncomeAmount(RetNo); doesnt explicitly say
    if TosiInEffect(RetNo) then
      Tv[3] := GetTosiNetIncome(RetNo); // 20181221

    Tv[4] := CalcMortgageForeclosure(ret[RetNo].Lnn[12700],
      Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 122)),
      Vl(FetchElmFNo(RetNo, GetFormNo('S3'), 72)));
    Tv[11] := MaxR(0, Tv[3] - Tv[4]);

    //Tv[5] := Vl(FetchElmFNo(RetNo,InfoFNo,19));
    Tv[5] := selectSpouseNetIncomeAmount(RetNo); //jz//20250224

    Tv[6] := Vl(FetchElm(RetNo, 'FORECLO', 4));
    Tv[12] := MaxR(0, Tv[5] - Tv[6]);
    Tv[13] := Tv[11] + Tv[12];

    Tv[19] := ret[RetNo].Lnn[11700] + GetSpouseUCCB(RetNo);
    Tv[20] := ret[RetNo].Lnn[12500] + GetSpouseRDSP(RetNo);
    Tv[25] := Vl(FetchElm(RetNo, 'INFO', 168)); // 20101220  //20170126

    Tv[7] := Tv[19] + Tv[20] + Tv[25];

    Tv[21] := MaxR(0, Tv[13] - Tv[7]);
    Tv[23] := ret[RetNo].Lnn[21300] + Vl(FetchElm(RetNo, 'INFO', 162));
    Tv[24] := Vl(FetchElm(RetNo, 'OTHDED', 60)) + Vl(FetchElm(RetNo, 'S2', 34));
    Tv[22] := Tv[23] + Tv[24];
    Tv[18] := Tv[21] + Tv[22];
    Tv[14] := Constant[RY].MedicalRefundBase;
    Tv[15] := MaxR(0, Tv[18] - Tv[14]);
    Tv[1] := Lnn[21500];
    Tv[8] := Lnn[33200];
    Tv[2] := Tv[1] + Tv[8];
    Tv[9] := Tv[2] * 0.25;
    Tv[10] := MinR(Constant[RY].MedicalRefundSupplement, Tv[9]);
    Tv[16] := Tv[15] * 0.05;
    Tv[17] := MaxR(0, Tv[10] - Tv[16]);

    x1 := MaxR(0, Lnn[10100] + Lnn[10400] - Lnn[20700] - Lnn[21200] - Lnn[22900]
      - Lnn[23100] - TotMultiple(RetNo, 'T4A', 35)); // 20110309
    // -Vl(FetchElm(RetNo,'OTHEMPL',2)));  //march 20 2008 wage loss repl plans
    x2 := 0;
    If Lnn[13500] > 0 then
     x2 := x2 + Lnn[13500];
    If Lnn[13700] > 0 then
      x2 := x2 + Lnn[13700];
    If Lnn[13900] > 0 then
      x2 := x2 + Lnn[13900];
    If Lnn[14100] > 0 then
      x2 := x2 + Lnn[14100];
    If Lnn[14300] > 0 then
      x2 := x2 + Lnn[14300];

    If (CalcDaysInCan(RetNo) < Constant[RY].FullYear) or (Age < 18) or
      (x1 + x2 < Constant[RY].MedicalRefundMinThreshHold) then
    begin
      Tv[17] := 0; // March 20 2008
    end;
    if (Tv[18]>=MaxAdjustedFamNetInc)
    or (Lnn[21500]=0) and (Lnn[33200]=0)
    Or (ret[retno].age<18)
    or (IsPrebankruptcyReturn(RetNo))
    then
     Tv[17]:=0;//20251125
  end;
  SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor >>>
procedure S11(RetNo: Integer; FName: string; FNo: Integer);
var
  T2202FNo: Integer;
begin
  T2202FNo:= GetFormNo('T2202');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    Tv[1]:= Vl(FetchElmFNo(RetNo, T2202FNo, 65));
    Ret[RetNo].Lnn[32000]:= Tv[1]; //20240125
    Tv[3]:= Tv[1]; // 20201215
    // ctc  //20201206
    Tv[12]:= Tv[3] / 2;
    Tv[15]:= MinR(Tv[12], Tv[14]);

    if (Tv[27] > Tv[15]) then Tv[27]:= Tv[15]; //If Tv[27]=0 then Tv[27]:=MinR(Tv[12],Tv[14]); //20211123

    Ret[RetNo].Lnn[45350]:= Tv[27]; //Tv[15];
    Tv[37]:= MaxR(0,Tv[1] - Tv[27]); //20230419 Tv[15]);
    Tv[2]:= Vl(FetchElm(RetNo, 'T2202', 71)); // 20200319
    Tv[33]:= Tv[37] + Tv[2];
    //Tv[33] := Tv[32];
    Tv[4]:= Tv[33] + Tv[13]; //20231124 //Tv[13] + Tv[33];

    // 20201206
    if (Ret[RetNo].Lnn[26000] <= Constant[RY].Bracket1) then
      Tv[5]:= Ret[RetNo].Lnn[26000]
    else
    begin
      Tv[34]:= Vl(FetchElm(RetNo, 'T1', 150)); // 20201215
      Tv[5]:= Tv[34] / 0.145;
    end;

    if TosiInEffect(RetNo) then
      Tv[5]:= Tv[5] + GetTosiFedTaxableIncome(RetNo); // 20181221

    Tv[6]:= Vl(FetchElm(RetNo, 'T1', 62)) + Vl(FetchElm(RetNo, 'RC269', 51));//2025036
     //20211120line 99 L300ToL318(RetNo); // 20171113
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[16]:= MinR(Tv[13], Tv[7]); //20231124
    Tv[39]:= Tv[16]; //20231124
    //Tv[18]:= Tv[17];
    Tv[19]:= MaxR(0, Tv[7] - Tv[39]); //20231124
    Tv[8]:= MinR(Tv[33], Tv[19]);
   // If UpperCase(Frm[FNo].Strings[28]) = 'Y' then Tv[8] := Tv[29]; //20211120 NO such elm ??
    Tv[21]:= Tv[39] + Tv[8];

    // warning?
    Frm[FNo].Strings[35]:= FetchElm(RetNo, 'T2202', 66);
    Frm[FNo].Strings[42]:= FetchElm(RetNo, 'T2202', 67);
    Tv[22]:= Tv[4];
    Tv[23]:= Tv[21];
    Tv[24]:= MaxR(0, Tv[22] - Tv[23]);
    // Tv[35]:= 5000;      //??

    Tv[9]:= MinR(5000, Tv[33]);  //20240224   // Tv[9] :=MinR(5000, Tv[13]);  //20231124
    Tv[20]:= Tv[8];
    Tv[30]:= MaxR(0, Tv[9] - Tv[20]);

    if UpperCase(Frm[FNo].Strings[36]).Equals('Y') and not UpperCase(Frm[FNo].Strings[38]).Equals('N') then Tv[10]:= Tv[30];
    if (Tv[10] > Tv[30]) then Tv[10]:= Tv[30];
    if UpperCase(Frm[FNo].Strings[36]).Equals('Y') then
    begin
      if not UpperCase(Frm[FNo].Strings[38]).Equals('N') then Tv[10]:= Tv[30];
      if not Frm[FNo].Strings[26].Equals('') then Frm[FNo].Strings[25]:= 'N';
    end else
    begin
      Tv[10]:= 0;
      Frm[FNo].Strings[25]:= 'N';
      Frm[FNo].Strings[26]:= '';
    end;

    if UpperCase(Frm[FNo].Strings[25]).Equals('Y') then Frm[FNo].Strings[26]:= '';

    Tv[11]:= MaxR(0, Tv[24] - Tv[10]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor <<<
Procedure HOMEBuy(RetNo: integer; FName: string; FNo: integer);
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If (ret[RetNo].MarStatus > 2) or (Tv[1] =100) then Strings[2] := 'N';

    If ret[RetNo].MarStatus > 2 then
    begin
      If Tv[1] = 0 then Tv[1] := 100;
     // If Strings[2] > '' then Strings[1] := 'N'; //20220304
    end;

    If Tv[1] > 100 then Tv[1] := 100;
    If Tv[3] > 10000 then Tv[3] := 10000; //20221127
    //If Tv[3] > 5000 then Tv[3] := 5000;
    Tv[4] := Tv[3] * Tv[1] / 100;
  end;
  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 67, FormatFloat('###.##', ret[RetNo].Frm[FNo].Tv[1]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 68,
      FormatFloat('###.##', 100 - ret[RetNo].Frm[FNo].Tv[1]));
  end;

end;

(*
  //20200217
  Procedure S11QC(RetNo:integer;FName:string;FNo:integer);
  var i,S11FNo,PrvTaxFNo,T2202FNo: integer;
  Begin
  Exit;
  InitPrvConstants(ret[RetNo].Province);
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  Begin
  if Ret[RetNo].Province <> 'QC' then
  Begin
  for i:=1 to 42 do
  Begin
  Strings[i]:='';
  Tv[i]:=0;
  End;
  SaveTv(RetNo,FName,FNo);
  Exit;
  End;

  for i:=1 to 42 do
  Begin
  Strings[i]:=FetchElmFNo(RetNo,S11FNo,i);
  Tv[i]:=Vl(FetchElmFNo(RetNo,S11FNo,i));
  End;
  End;
  SaveTv(RetNo,FName,FNo);
  End;
*)

//20220220
Procedure S11PRVYT(RetNo: integer; FName: string; FNo: integer);
var
  i,S11FNo: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    S11FNo := GetFormNo('S11');
    Tv[31]:=Vl(FetchElm(RetNo,S11FNo,1));
    Tv[32]:=Vl(FetchElm(RetNo,S11FNo,2));
    Tv[1]:=Tv[31]+Tv[32];
    Tv[2]:=Tv[1];
    Tv[4]:=Tv[13]+Tv[2];
  End;
end;

// 20180202
Procedure S11PRV(RetNo: integer; FName: string; FNo: integer);
var
  i, Elm1, Elm2, S11FNo, PrvTaxFNo, T2202FNo: integer;
  TxblIncome, ThresholdAmount, RatePercent: Real;
  TaxTableElm, PartialNonRefElm: integer;
Begin
  InitPrvConstants(ret[RetNo].Province);

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo] do
  begin
    // Copy from federal  20091121
    S11FNo := GetFormNo('S11');
    T2202FNo := GetFormNo('T2202'); // 20180227
  End;

  // 20171125
  With ret[RetNo].Frm[FNo] do
  Begin
    Strings[31] := PrvLong[GetPrvIndex(ret[RetNo].Province)];
    Strings[32] := GetS11PrvHeader(RetNo);

    Strings[15] := FetchElmFNo(RetNo, S11FNo, 35); // 20191202
    Strings[12] := FetchElmFNo(RetNo, S11FNo, 42); // 20191202

    Tv[1] := Vl(FetchElmFNo(RetNo, S11FNo, 33));
    If ret[RetNo].Province = 'YT' then
      Tv[1] := Vl(FetchElmFNo(RetNo, S11FNo, 1)) +
        Vl(FetchElmFNo(RetNo, S11FNo, 2)); // 20201231

    if ret[RetNo].Province = 'AB' then
      Tv[1] := 0; // 20201228
    if ret[RetNo].Province = 'ON' then
      Tv[1] := 0;
    if ret[RetNo].Province = 'SK' then
      Tv[1] := 0;
    // if Ret[RetNo].Province='NU' then Tv[1]:=0;  //20210101
    // if Ret[RetNo].Province<>'NB' then Tv[48]:=0;  //20201228

    Strings[40] := '';
    Strings[33] := AllTrim(IntToStr(PrvConstant[RY].PrvPartEducPerMonth));
    If ret[RetNo].Province = 'NU' then
      Strings[33] := '120';
    if FetchElm(RetNo, S11FNo, 31) > '' then
      Strings[15] := ''; // makeit full time //20189211

    // 20201229
    if (ret[RetNo].Province = 'MB') or (ret[RetNo].Province = 'NL') Or
      (ret[RetNo].Province = 'NS') or (ret[RetNo].Province = 'NT') Or
      (ret[RetNo].Province = 'NU') or (ret[RetNo].Province = 'PE') then
      // ok alloed to claim the Educations
    Else
    Begin
      Strings[33] := '';
      Strings[40] := '';
      Strings[34] := '';
      Strings[43] := '';
    End;

   // Tv[49] := Tv[1] + Tv[48]; //20211216 // 20191208
   // see below [49] for each province

    Tv[37] := MyStrToInt(Strings[15]) * (MyStrToInt(Strings[33]));
    If ret[RetNo].Province = 'NU' then
    begin
      Strings[39] := Strings[15];
      Strings[40] := '20';
    end; // 20180211
    Tv[41] := MyStrToInt(Strings[39]) * (MyStrToInt(Strings[40]));
    Tv[42] := Tv[37] + Tv[41];
    Tv[14] := Tv[42];

    If MyStrToInt(Strings[15]) > 12 then
      Strings[15] := '12';
    If MyStrToInt(Strings[12]) > 12 then
      Strings[12] := '12';
    Strings[34] := AllTrim(IntToStr(PrvConstant[RY].PrvEducPerMonth));
    If ret[RetNo].Province = 'NU' then  Strings[34] := '400';
    // ----------------------------------------------------------
    //
    if FetchElm(RetNo, S11FNo, 31) > '' then     // could not attend full time so parttime becomes full time
    begin
      //20211208
      Strings[12] := IntToStr(MystrToInt(FetchElmFNo(RetNo, S11FNo, 35))
                    +MystrToInt(FetchElmFNo(RetNo, S11FNo, 42)));
      if Strings[12]>'12' then Strings[12]:='12';
      //Strings[12] := FetchElmFNo(RetNo, S11FNo, 35);
    end;
    // prt time months to full time //20180211
    // again //20200601
    if ret[RetNo].Province = 'AB' then
    begin
      Strings[15] := '';
      Strings[12] := '';
    end; // 20190413
    if ret[RetNo].Province = 'ON' then
    begin
      Strings[15] := '';
      Strings[12] := '';
    end; // 20190413
    if ret[RetNo].Province = 'BC' then
    begin
      Strings[15] := '';
      Strings[12] := '';
    end; // 20190413
    if ret[RetNo].Province = 'SK' then
    Begin
      Strings[15] := '';
      Strings[12] := '';
    end; // 20191203
    If ret[RetNo].Province = 'NB' then
    Begin
      Strings[15] := '';
      Strings[12] := '';
    end;
    If ret[RetNo].Province = 'YT' then
    begin
      Strings[15] := '';
      Strings[12] := '';
    end;
    If ret[RetNo].Province <> 'NU' then
    begin
      Strings[39] := '';
      Strings[44] := '';
    end; // textbook amounts
    // ----------------------------------------------------------

    Tv[45] := MyStrToInt(Strings[12]) * (MyStrToInt(Strings[34]));
    Strings[44] := '';
    Strings[43] := '';
    If ret[RetNo].Province = 'NU' then
    begin
      Strings[44] := Strings[12];
      Strings[43] := '65';
    end; // 20180211
    // if Ret[RetNo].Province <>'NB' then Tv[48]:=0;  //only for NB

    Tv[46] := MyStrToInt(Strings[44]) * (MyStrToInt(Strings[43]));
    Tv[47] := Tv[45] + Tv[46];
    Tv[2] := Tv[47];

    Strings[26] := FetchElmFNo(RetNo, S11FNo, 26); // 20120204    //sin?
    // end;

    Tv[3] := Tv[1] + Tv[14] + Tv[2]; // - Tv[48];  //20201228
    Tv[16] := Tv[3];
    Tv[4] := Tv[13] + Tv[16];

    PrvTaxFNo := GetFormNo(WhichTaxForm(RetNo, ret[RetNo].Province));

    //THRESHOLDS OF TAXABLE INCOME BY PROVINCE
    // Thresholds 20201229
    // Example:Strings[50] has the Box number. Elm1 has the Elm of that box, The amount would be etchElm(PrvTaxFNo,Elm1
    // Tv[elm1=8] has the tax on taxable income  Tv[Elm2]= has intermediate Non refundble credits

    //20221220 updated the threshilds Tv[49]
    if ret[RetNo].Province = 'AB' then
    begin
      Tv[49] := 148269; //134438;//131220;
      Strings[50] := '8';
      Tv[51] := 10;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '32';
    end;
    if ret[RetNo].Province = 'BC' then
    begin
      Tv[49] := 47937; //43070; //42184; // 41725;
      Strings[50] := '8';
      Tv[51] := 5.06;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '33';
    end; // 20210101
    If ret[RetNo].Province = 'MB' then
    begin
      Tv[49] := 47000; //34431; //33723; //33389;
      Strings[50] := '8';
      Tv[51] := 10.8;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '36';
    end;
    If ret[RetNo].Province = 'NB' then
    Begin
      Tv[49] := 49958; //44887; //43835; //43401;
      Strings[50] := '8';
      Tv[51] := 9.40; //9.68;  //20221220
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '31';
    end;
    If ret[RetNo].Province = 'NL' then
    begin
      Tv[49] := 43198; //8081; //37929;
      Strings[50] := '8';
      Tv[51] := 8.7;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '35';
    end;
    If ret[RetNo].Province = 'NS' then
    begin
      Tv[49] := 29590;
      Strings[50] := '8';
      Tv[51] := 8.79;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '27';
    end;
    If ret[RetNo].Province = 'NT' then
    begin
      Tv[49] := 50597; //45462; //44396; //43957;
      Strings[50] := '8';
      Tv[51] := 5.9;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '31';
    end;
    If ret[RetNo].Province = 'NU' then
    begin
      Tv[49] := 53268; //47862; //46740; //46277;
      Strings[50] := '8';
      Tv[51] := 4;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '32';
    end;
    if ret[RetNo].Province = 'ON' then
    begin
      Tv[49] := 51446; //46226; //45142; //44740;
      Strings[50] := '8';
      Tv[51] := 5.05;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '31';
    end;
    if ret[RetNo].Province = 'PE' then
    begin
      Tv[49] := 32656; //31984;
      Strings[50] := '8';
      Tv[51] := 9.65; //9.8;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '33';
    end;
    if ret[RetNo].Province = 'SK' then
    Begin
      Tv[49] := 52057; //47773; //45677; //45225;
      Strings[50] := '8';
      Tv[51] := 10.5;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '37';
    end;
    If ret[RetNo].Province = 'YT' then
    begin
      Tv[49] := 55867; //50197; //49020; //48535;
      Strings[50] := '8';
      Tv[51] := 6.4;
      Strings[52] := IntToStr(TaxTableElm);
      Strings[53] := '28';
    end;

    if ret[RetNo].Province = 'AB' then
    begin
      TaxTableElm := 19;
      PartialNonRefElm := 58;
    end; // box 8 and box 32 elms
    if ret[RetNo].Province = 'BC' then
    begin
      TaxTableElm := 132;
      PartialNonRefElm := 57;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'MB' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 81;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NB' then
    Begin
      TaxTableElm := 101;
      PartialNonRefElm := 110;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NL' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 117;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NS' then
    begin
      TaxTableElm := 130;
      PartialNonRefElm := 175;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NT' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 83;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'NU' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 88;
    end; // box 8 and box 3? elms
    if ret[RetNo].Province = 'ON' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 169;
    end; // box 8 and box 3? elms
    if ret[RetNo].Province = 'PE' then
    begin
      TaxTableElm := 101;
      PartialNonRefElm := 98;
    end; // box 8 and box 3? elms
    if ret[RetNo].Province = 'SK' then
    Begin
      TaxTableElm := 101;
      PartialNonRefElm := 93;
    end; // box 8 and box 3? elms
    If ret[RetNo].Province = 'YT' then
    begin
      TaxTableElm := 134;
      PartialNonRefElm := 74;
    end; // box 8 and box 3? elms

    Tv[48] := ret[RetNo].Lnn[26000];
    TxblIncome := ret[RetNo].Lnn[26000]; // 20210109  //Tv[48];
    ThresholdAmount := Tv[49];
    RatePercent := Vl(Strings[51]);

    // 20210109
    if TxblIncome <= ThresholdAmount then
      Tv[5] := TxblIncome + Vl(FetchElm(RetNo, 'T1206', 64)) // 20201229 + TOSI
    Else
      Tv[5] := Vl(FetchElmFNo(RetNo, PrvTaxFNo, TaxTableElm)) /
        (RatePercent / 100) + Vl(FetchElm(RetNo, 'T1206', 64));
    // 20201229 + TOSI;


    Tv[6] := Vl(FetchElmFNo(RetNo, PrvTaxFNo, PartialNonRefElm));
    Tv[7] := MaxR(0, Tv[5] - Tv[6]);
    Tv[17] := MinR(Tv[13], Tv[7]);
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, Tv[7] - Tv[17]);
    Tv[8] := MinR(Tv[16], Tv[19]); // 20201229

    If UpperCase(Strings[28]) = 'Y' then
      Tv[8] := Tv[29]; // 20201229
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

    // 20200406
    Strings[36] := FetchElmFNo(RetNo, S11FNo, 36);
    Strings[26] := FetchElmFNo(RetNo, S11FNo, 26);
    // --------------
    If UpperCase(Strings[36]) = 'Y' then  //means transfer
    begin
      If UpperCase(Strings[38]) <> 'N' then
        Tv[10] := Tv[30];
      If Strings[26] > '' then Strings[25] := 'N';      //trnsf to spouse
    end
    else
    begin
      Tv[10] := 0;
      Strings[25] := 'N';
      Strings[26] := '';
    end;

    Tv[11] := MaxR(0, Tv[24] - Tv[10]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1153(RetNo: integer; FName: string; FNo: integer);
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(FetchElm(RetNo, 'INFO', 38)) = 'X' then
      Strings[28] := 'X'
    else
      Strings[28] := '';

    { disc info }
    Strings[1] := OptRec.Prp_Name;
    Strings[2] := OptRec.Prp_Street;
    Strings[3] := OptRec.Prp_DiscNo;
    // Strings[29]:= CfgRec.Ef_PrepNo;
    Strings[29] := GetEOLAgentNo;
    If Strings[29] = '' then
      Strings[29] := GetEOLPAgentNo;
    Strings[4] := OptRec.Prp_City;
    Strings[5] := OptRec.Prp_Prov;
    Strings[6] := OptRec.Prp_Postal;
    { client info }
    Strings[7] := GetFirstName(RetNo) + ', ' + GetLastName(RetNo);
    Strings[8] := GetSinNo(RetNo);
    Strings[10] := FetchElm(RetNo, 'INFO', 9); { birthdate }
    Strings[9] := FetchElm(RetNo, 'INFO', 6) + ' ' + Strings[22]; { str }
    Strings[11] := FetchElm(RetNo, 'INFO', 10); { city }
    Strings[12] := FetchElm(RetNo, 'INFO', 14); { prov }
    Strings[13] := FetchElm(RetNo, 'INFO', 15); { postal }
    If Strings[16] = '' then
      Strings[16] := FormatDateTime('yyyy-mm-dd', Date); // 2014
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1170(RetNo: integer; FName: string; FNo: integer);
var
  i: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    //shares
    i := 4;
    Tv[31] := 0;
    Tv[32] := 0;
    Tv[33] := 0;
    repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      If Tv[i] > 0 then
        Tv[i + 5] := Tv[i + 3] * Tv[i + 4] / Tv[i]
      else
        Tv[i + 5] := 0;
      Tv[i + 6] := MaxR(0, Tv[i + 3] - Tv[i + 5]);
      Tv[31] := Tv[31] + Tv[i];
      Tv[32] := Tv[32] + Tv[i + 5];
      Tv[33] := Tv[33] + Tv[i + 6];
      inc(i, 10);
    until i > 24;

    //Bonds
    i := 38;
    Tv[76] := 0;
    Tv[77] := 0;
    Tv[78] := 0;
    repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      If Tv[i] > 0 then
        Tv[i + 5] := Tv[i + 3] * Tv[i + 4] / Tv[i]
      else
        Tv[i + 5] := 0;

      Tv[i + 6] := MaxR(0, Tv[i + 3] - Tv[i + 5]);
      Tv[76] := Tv[76] + Tv[i];
      Tv[77] := Tv[77] + Tv[i + 5];
      Tv[78] := Tv[78] + Tv[i + 6];
      inc(i, 11);
    until i > 60;

    // 20231127  Ecological land
    i := 82;
    Tv[116] := 0;
    Tv[118] := 0;
    Tv[119]:=0;
    repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      If Tv[i] > 0 then
        Tv[i + 5] := Tv[i + 3] * Tv[i + 4] / Tv[i]
      else
        Tv[i + 5] := 0;

      Tv[i + 6] := MaxR(0, Tv[i + 3] - Tv[i + 5]);
      Tv[116] := Tv[116] + Tv[i];
      Tv[118] := Tv[118] + Tv[i + 5];
      Tv[119] := Tv[119] + Tv[i + 6];
      inc(i, 9);
    until i > 109;

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1172(RetNo: integer; FName: string; FNo: integer);
var
  i: integer; InfoFNo:Integer;
Begin
  InfoFNo:=GetFormNo('INFO');
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
   Strings[116]:=FetchElmFNo(RetNo,InfoFNo,6);
   Strings[2]:=FetchElmFNo(RetNo,InfoFNo,10);
   Strings[3]:=FetchElmFNo(RetNo,InfoFNo,14);
   Strings[4]:=FetchElmFNo(RetNo,InfoFNo,15);
  end;
  // PG 2
  With ret[RetNo].Frm[FNo] do
  begin

    Tv[110] := 20;
    Tv[113] := 20;
    Tv[122] := 60;

    Strings[101] := GetLastName(RetNo);
    Strings[102] := GetFirstName(RetNo);
    Strings[103] := GetSinNo(RetNo);
    If OptRec.Prp_Dates then
      Strings[115] := DateToMonthDayYear(Date);

    Tv[104] := MaxR(0, ret[RetNo].T4AResp - ret[RetNo].T4AResp22); // 20151207
    Tv[106] := MinR(Tv[104], Tv[105]);
    Tv[107] := 50000;
    Tv[121] := MaxR(0, Tv[107] - Tv[120]);
    Tv[108] := MinR(Tv[106], Tv[121]);
    Tv[109] := MaxR(0, Tv[104] - Tv[108]);
    Tv[110] := 20;
    Tv[111] := Tv[109] * Tv[110] / 100;

    Tv[112] := ret[RetNo].T4AResp22;

    Tv[114] := Tv[112] * Tv[113] / 100;
    // end;
    If ret[RetNo].Province = 'QC' then
    begin
      Tv[118] := Tv[111] + Tv[114]; // 20151207
      Tv[119] := Tv[118] * 0.60;
      // Ret[RetNo].Lnn[41800] := Tv[119];
    end
    Else
    Begin
      Tv[118] := 0;
      Tv[119] := Tv[118] * 0.60;
      // Ret[RetNo]^.Lnn[41800] := Tv[119];
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure CLAW(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    For i := 24 to 41 do
      Tv[i] := 0;
    Tv[26] := 0; { add two slips }
    If (Vl(FetchElm(RetNo, 'T4E#1', 7)) = 30) then
    begin
      If Vl(FetchElm(RetNo, 'T4E#1', 8)) > 0 then
        Tv[26] := Tv[26] + Vl(FetchElm(RetNo, 'T4E#1', 8));
    end;

    If GetFormNo('T4E#2') > 0 then
    Begin
      If (Vl(FetchElm(RetNo, 'T4E#2', 7)) = 30) then
      begin
        If Vl(FetchElm(RetNo, 'T4E#2', 8)) > 0 then
          Tv[26] := Tv[26] + Vl(FetchElm(RetNo, 'T4E#2', 8));
      end;
    end;

    Tv[24] := Vl(FetchElm(RetNo, 'T4E#1', 10));
    // +Vl(FetchElm(RetNo,'T4E#2',10));  //20101219
    If GetFormNo('T4E#2') > 0 then
      Tv[24] := Tv[24] + Vl(FetchElm(RetNo, 'T4E#2', 10));

    Tv[28] := MaxR(0, Tv[26] - Tv[24]);
    Tv[31] := Lnn[21300] + Lnn[23400] + Vl(FetchElm(RetNo, 'OTHDED', 60)) - Lnn[11700] - Lnn[12500];
    // if TosiInEffect(RetNo) then Tv[31]:=Lnn[21300]+GetTosiNetIncome(RetNo)+Vl(FetchElm(RetNo,'OTHDED',60))-Lnn[11700]-Lnn[12500];

    Tv[32] := Constant[RY].UIBaseRep;
    Tv[33] := MaxR(0, Tv[31] - Tv[32]);
    Tv[40] := MinR(Tv[28], Tv[33]);
    Tv[41] := Tv[40] * 0.30;

    { OAS }
    Tv[8] := Lnn[11300];
    Tv[9] := Lnn[14600];
    Tv[10] := Tv[8] + Tv[9];
    Tv[1] := TotMultiple(RetNo, 'T4AOAS', 7);
    Tv[12] := MaxR(0, Tv[10] - Tv[1]);

    Tv[13] := Lnn[23400];
    if TosiInEffect(RetNo) then
      Tv[13] := Tv[13] + Vl(FetchElm(RetNo, 'T1206', 3));
    // GetTosiNetIncome(RetNo); //20181222

    Tv[14] := Tv[41];
    Tv[4] := ret[RetNo].Lnn[11700];
    Tv[15] := ret[RetNo].Lnn[12500];
    Tv[5] := Tv[14] + Tv[4] + Tv[15]; // +Tv[17];  //20170417
    Tv[6] := Tv[5];
    Tv[7] := MaxR(0, Tv[13] - Tv[6]);
    Tv[2] := ret[RetNo].Lnn[21300];
    Tv[3] := Vl(FetchElm(RetNo, 'OTHDED', 60));
    Tv[11] := Tv[2] + Tv[3];
    Tv[23] := Tv[11];
    Tv[25] := Tv[7] + Tv[23];
    Tv[16] := Constant[RY].OASBaseRep;
    //Tv[27] := MaxR(0, Tv[13] - Tv[14]);  ??
    Tv[29] := MaxR(0, Tv[25] - Tv[16]);
    Tv[48]:=Tv[29];   //20211223
    Tv[18] := Tv[48] * 0.15;
    Tv[21] := MinR(Tv[12], Tv[18]);
    Tv[20] := Tv[14];
    Tv[17] := Tv[21] + Tv[20];

    // --  //20201125
    Tv[27] := Tv[25];
    Tv[30] := Tv[14];
    Tv[34] := Tv[27] + Tv[30];
    {??? these lines not on the form //20221208
    //20211223
    Tv[35] := TotMultiple(RetNo, 'T4A', 90); // 20201129
    Tv[45] := Tv[35]-Tv[44];  //allow negative
    Tv[46] := Tv[45];
    Tv[36] := Tv[34] - Tv[46];
    Tv[37] := 38000;
    Tv[38] := MaxR(0, Tv[36] - Tv[37]);
    Tv[47]:= Tv[38];
    Tv[39] := Tv[47] * 50 / 100;
    Tv[42] := MinR(Tv[46], Tv[39]);
    Tv[43] := Tv[42];
   }
    // --------------------------------

    //20221208  Tv[22] := Tv[17] + Tv[43]; // Tv[21] + Tv[20];
    Tv[22] := Tv[21]+Tv[20];  //20221208
    If UpperCase(Frm[FNo].Strings[19]) = 'Y' then Tv[22] := 0; // 20150209
    Lnn[23500] := Tv[22];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure SNRESA(RetNo: integer; FName: string; FNo: integer);
var
  i: integer;
Begin

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If IsDeemedResident(RetNo) then  //20240325
    Begin
      For i := 1 to 18 do begin Tv[i]:=0;end;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;

    If (Province <> 'ZZ') and (AllowSaSb(RetNo) = False) // 20150412
    then
    begin
      For i := 1 to 18 do
      begin
        Frm[FNo].Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end; // 20150512


    // else
    // begin
    Tv[1] := Lnn[23600];
    Tv[5] := Tv[1] + Tv[2] + Tv[3] + Tv[4];
    Tv[6] := Tv[5];
    Tv[14] := 0;
    For i := 7 to 13 do
      Tv[14] := Tv[14] + Tv[i];
    Tv[15] := Tv[14];
    Tv[16] := Tv[6] + Tv[15];
    Tv[18] := MaxR(0, Tv[16] - Tv[17]);
    Lnn[16700] := Tv[16];
    Lnn[16900] := Tv[18];
    // end;
  end;
  SaveTv(RetNo, FName, FNo);
  // do the following  //20150412
  SNRESB(RetNo, 'SNRESB', GetFormNo('SNRESB'));
  INFO(RetNo, 'INFO', GetFormNo('INFO'));
end;

// 202203M1
Procedure SNRESB(RetNo: integer; FName: string; FNo: integer);
var
  i: integer; Disab,x:Real; //20240423
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If (AllowSaSb(RetNo) = False) // 20150412
    then
    begin
      For i := 1 to 24 do  //12
      begin
        Frm[FNo].Strings[i] := '';
        Tv[i] := 0;
      end;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    For i := 1 to 24 do begin Tv[i] := 0;end; //20220401
    //If Frm[FNo].Strings[10] = '' then Frm[FNo].Strings[10] := 'N';
    If IsSection217(RetNo) then  //[10] s/b Y
    Begin
      Frm[FNo].Strings[10] := 'Y';
      Frm[FNo].Strings[4]  := 'N';
    End

    else //all others
    begin
      Frm[FNo].Strings[10] := 'N';
      Frm[FNo].Strings[4]  := 'Y'; //section 216(1)  //20240419
    end;


    Tv[1] := Lnn[23600];
    Tv[6] := Vl(FetchElm(RetNo, 'SNRESA', 16));
    If Tv[6] <> 0 then
      Tv[23] := (Tv[1] / Tv[6])
    else
      Tv[23] := 0;
    Tv[2]:=Tv[23]*100;

     //Part A
     If IsSection217(RetNo)=False then
     Begin
       If ret[RetNo].Age >= 18 then  //20240423
        Disab := vl(FetchElm(RetNo, 'DISAB18', 1))
       else
        Disab := vl(FetchElm(RetNo, 'DISAB18', 11));

       Tv[3] :=Lnn[30800]+Lnn[31200]+Lnn[31217]+Lnn[31600]+Lnn[31900]+Lnn[32300];//20251205
       //20251205 //Disab+Lnn[31900]+Lnn[32300];  //20240423 T1[91] instad of Lnn[31600]
       Tv[14]:=Tv[3]*14.5/100; //20251205 //Tv[3]*5/100;  //20220401 //Tv[3]*15/100; //Tv[3]*5/100;  //20220401
       Tv[15]:=Vl(FetchElm(RetNo,'S9',12)); //Lnn[34900];  //20240424
       Tv[16]:=Tv[14]+Tv[15];  //20220401
     end
     Else
     Begin     //section 217 pensions
       Tv[17]:=Lnn[35000];
       Tv[8] := Lnn[31220] + Lnn[31240] + Lnn[31270] + Lnn[31285] + Lnn[31300] + Lnn[31350]
         +Lnn[31900];  //20251205
       Tv[18]:=Tv[8]*14.5/100; //Tv[8]*15/100; //20251205
       Tv[21]:=Tv[18];
       Tv[22]:=MaxR(0,Tv[17]-Tv[21]);
       Tv[5] := Vl(FetchElm(RetNo, 'SNRC', 14));    //20220411
       Tv[9]:=Tv[5]*14.5/100; //Tv[5]*15/100;
       Tv[11]:=MinR(Tv[22],Tv[9]);
     End;
  end; //with
  SaveTv(RetNo, FName, FNo);
end;

//20260301
Procedure GST370(RetNo: integer; FName: string; FNo: integer);
var
  i, j, jj, k, k1: integer;
Begin
  LoadTv(RetNo, FName, FNo);

  With ret[RetNo].Frm[FNo] do
  begin
    Tv[415] := 0;

    Strings[1] := GetLastName(RetNo);
    Strings[3] := AppYear;
    Strings[2] := GetFirstName(RetNo);
    Strings[4] := GetSinNo(RetNo);

    // test for k1:=101 to  500 do begin Tv[k1]:=i*10;end; SaveTv(RetNo,FName,FNo); EXIT;

    // gst370 pg2
    If (UpperCase(Strings[51]) = 'Y')   //clear first losing all manual entries
    then
    begin
      // clear it 20110311
      For i := 101 to 344 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end; // 20130510
      For i := 61 to 72 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

      Strings[12] := 'X'; // 20210403 Multiple statements only
      CopyFromT777(RetNo, FNo); // 20200530  //Statement not used
      // on=13, ns,nl,nb,pe=15%, all others=5%
      k := 0;
      If (ret[RetNo].Province = 'BC') then
        k := 0 // bc also at 5%  //at 5% second column  //20150228
      Else If (ret[RetNo].Province = 'ON') then
        k := 2 // at 13% third column
      else If (ret[RetNo].Province = 'NS') Or (ret[RetNo].Province = 'NL') Or
        (ret[RetNo].Province = 'NB') Or (ret[RetNo].Province = 'PE') // 20180203
      Then
        k := 3; // then k:=3;  //at 15% 4th column  //20180203
      Tv[317 + k] := GetTL2ForGst370(RetNo);
    end;

    // horizontal //M4
    i := 101; // 5%
    j := 357; // 14% tot
    jj := 380; // 14% non elig
    k := 403; // Elig 14%
    repeat
      Tv[i + 8] := MaxR(0, Tv[i] - Tv[i + 4]); // 5%   Tv[109]-[101 ]-[105]
      Tv[i + 10] := MaxR(0, Tv[i + 2] - Tv[i + 6]); // 13%
      If k <> 420 then
        Tv[k] := MaxR(0, Tv[j] - Tv[jj]); // 14%  //20190316
      Tv[i + 11] := MaxR(0, Tv[i + 3] - Tv[i + 7]); // 15%

      inc(i, 12);
      inc(j, 1);
      inc(jj, 1);
      inc(k, 1);
    until i > 329;

    // m4
    // 20190316
    Tv[342] := MaxR(0, AddColumns(109, 337, 12) - Tv[350]); // 20190316
    Tv[343] := MaxR(0, AddColumns(111, 339, 12) - Tv[351]);
    Tv[344] := MaxR(0, AddColumns(112, 340, 12) - Tv[352]);
    Tv[425] := MaxR(0, AddColumns(403, 414, 1) + AddColumns(416, 419, 1) +
      AddColumns(421, 424, 1) - Tv[420]); // no 415 //20190323

    // cca horiz
    i := 61;
    // 20130510
    Tv[69] := MaxR(0, Tv[61] - Tv[65] - Tv[354]); // 5%
    Tv[71] := MaxR(0, Tv[63] - Tv[67] - Tv[355]); // 13%
    Tv[86] := MaxR(0, Tv[87] - Tv[88] - Tv[85]); // 14%
    Tv[72] := MaxR(0, Tv[64] - Tv[68] - Tv[356]); // 15%

    // pg 3
    Tv[42] := Tv[15] + Tv[16];
    Tv[43] := Tv[38] + Tv[40];
    Tv[44] := Tv[39] + Tv[41];
    Tv[58] := Tv[45] + Tv[34];
    Tv[59] := Tv[49] + Tv[56];

    Tv[73] := Tv[42] + Tv[43] + Tv[44] + Tv[58] + Tv[59];
    // +Tv[83]+Tv[60]; //pe 20140106
    Tv[74] := Tv[42] * 1 / 101;
    Tv[75] := Tv[43] * 2 / 102;
    Tv[76] := Tv[44] * 8 / 108;
    Tv[46] := Tv[58] * 9 / 109;
    Tv[47] := Tv[59] * 10 / 110;

    Tv[18] := Tv[74] + Tv[75] + Tv[76] + Tv[46] + Tv[47];
    // +Tv[84]+Tv[48];  //20140106
    // pg 1
    Tv[7] := Tv[342];
    Tv[8] := Tv[69];
    Tv[9] := Tv[7] + Tv[8];

    // 20161117 SAME
    Tv[10] := Tv[9] * 5 / 105;
    If RY > 0 then
      Tv[10] := Tv[9] * 5 / 105;

    //20260301
    Tv[27] := Tv[343];
  //  Tv[77] := Tv[425]; // 20140106 //20260301CZ??
    Tv[28] := Tv[425];
    Tv[81] := Tv[344]; //20260301

    // motot veh
      //20260301
    Tv[29] := Tv[71];
    Tv[82] := Tv[72]; // 20140106
    Tv[30] := Tv[86]; //72];

    Tv[32] := Tv[27] + Tv[29];
    Tv[33] := Tv[28] + Tv[30];
    Tv[83]:=Tv[81]+Tv[82]; //20260301
    Tv[79] := Tv[77] + Tv[78]; // 14%

    //20250301
    Tv[13] := Tv[32] + Tv[33] + Tv[83]; // 20260301

    Tv[36] := Tv[32] * 13 / 113;
    Tv[37] := Tv[33] * 14 / 114;
    Tv[84] := Tv[83] * 15 / 115;

    Tv[80]:=Tv[36]+Tv[37]+Tv[84];  //20260302

    Tv[14] := Tv[73];  //line 4 in part 3   Tv[36] + Tv[80] + Tv[37]; // 20190429
    Tv[17] := Tv[18];  //line 10 in part 3

    //Tv[26] := Tv[18];
    Tv[26] := Tv[10] + Tv[80] + Tv[17];

  end;
  SaveTv(RetNo, FName, FNo);
end;

//20260301
Procedure CopyFromT777(RetNo, FNo: integer);
// T777statement not used in simple method
Var
  T777FNo, i, j, k: integer;
  MotorPercent, PersonalMotorPercent, HomePercent: Real; // divided by 100
begin
  // 2320200526
  if UpperCase(FetchElm(RetNo, 'GST370', 12)) > '' then // multiple
  Begin
    CopyFromT777Multiple(RetNo, FNo);
    exit;
  End;

  T777FNo := GetFormNo('T777'); // 20200511
  //20260301
  k := 0; // default at 5% except as below
  If (ret[RetNo].Province = 'BC')  or (ret[RetNo].Province = 'MB')
      or (ret[RetNo].Province = 'NU')  or (ret[RetNo].Province = 'SK')
      or (ret[RetNo].Province = 'YT')
      // or (ret[RetNo].Province = 'QC')
  then  k := 0 // 20150228 //k:=1  //at 12% second column
  Else If (ret[RetNo].Province = 'ON') then  k := 2 // at 13% third column //20180203
  else if (ret[RetNo].Province = 'NS')then K:=3
  else If (ret[RetNo].Province = 'NB') or (ret[RetNo].Province = 'NL')
    or (ret[RetNo].Province = 'PE') then k:=4;

  with ret[RetNo].Frm[FNo] do
  begin
    // normal old method
    Tv[101 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 3));
    Tv[113 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 4));
    Tv[125 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 11));
    Tv[137 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 12));
    Tv[149 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 13));
    Tv[161 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 14));
    Tv[173 + k] := +Vl(FetchElmFNo(RetNo, T777FNo, 16)) +
      Vl(FetchElmFNo(RetNo, T777FNo, 18));
    Tv[185 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 65));
    Tv[197 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 58));
    Tv[249 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 65)); // tradesperson
    Tv[209 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 19));
    Tv[221 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 21));
    // motor home
    Tv[245 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 27)); // fuel
    Tv[249 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 27)) * PersonalMotorPercent;
    // personal
    Tv[257 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 28)); // mainenance
    Tv[261 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 28)) * PersonalMotorPercent;
    // personal
    Tv[269 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 33)); // leasing
    Tv[273 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 33)) * PersonalMotorPercent;
    // personal
    Tv[281 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 35)); // othe exp
    Tv[285 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 35)) * PersonalMotorPercent;
    //===========================================================
    // workspace at home   //20210401
    if UpperCase(FetchElmFNo(RetNo,T777FNo,62))='Y' then
     begin
         //HEAT ETC
         Tv[293 + k] :=  Tv[293 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 47));
         Tv[297 + k] :=  Tv[297 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 55));
         Tv[301 + k] :=  Tv[301 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 88));
         ///MAINTENANCE
         Tv[305 + k] := Tv[305 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 50)); // home maintenance
         Tv[309 + k] := Tv[309 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 57)); // home maintenance
         Tv[313 + k] := Tv[313 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 101)); // home maintenance
     end
     Else
     begin
         Tv[293 + k] :=  Tv[293 + k] + 0;
         Tv[297 + k] :=  Tv[297 + k] + 0;
         Tv[301 + k] :=  Tv[301 + k] + 0;
         ///MAINENANCE
         Tv[305 + k] := Tv[305 + k] + 0;
         Tv[309 + k] := Tv[309 + k] + 0;
         Tv[313 + k] := Tv[313 + k] + 0;
     end;
    //========================================================================
    Tv[61 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 20)) +
      Vl(FetchElmFNo(RetNo, T777FNo, 31)); // cca
    Tv[65 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 31)) * PersonalMotorPercent;  // personal
  end;
end;



(* Dummied ot 20260301
// 20190304
Procedure GST370(RetNo: integer; FName: string; FNo: integer);
var
  i, j, jj, k, k1: integer;
Begin
  LoadTv(RetNo, FName, FNo);

  With ret[RetNo].Frm[FNo] do
  begin
    Tv[415] := 0;

    Strings[1] := GetLastName(RetNo);
    Strings[3] := AppYear;
    Strings[2] := GetFirstName(RetNo);
    Strings[4] := GetSinNo(RetNo);

    // test for k1:=101 to  500 do begin Tv[k1]:=i*10;end; SaveTv(RetNo,FName,FNo); EXIT;

    // gst370 pg2
    If (UpperCase(Strings[51]) = 'Y')   //clear first losing all manual entries
    then
    begin
      // clear it 20110311
      For i := 101 to 344 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end; // 20130510
      For i := 61 to 72 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

      Strings[12] := 'X'; // 20210403 Multiple statements only
      CopyFromT777(RetNo, FNo); // 20200530  //Statement not used
      // on=13, ns,nl,nb,pe=15%, all others=5%
      k := 0;
      If (ret[RetNo].Province = 'BC') then
        k := 0 // bc also at 5%  //at 5% second column  //20150228
      Else If (ret[RetNo].Province = 'ON') then
        k := 2 // at 13% third column
      else If (ret[RetNo].Province = 'NS') Or (ret[RetNo].Province = 'NL') Or
        (ret[RetNo].Province = 'NB') Or (ret[RetNo].Province = 'PE') // 20180203
      Then
        k := 3; // then k:=3;  //at 15% 4th column  //20180203
      Tv[317 + k] := GetTL2ForGst370(RetNo);
    end;

    // horizontal //M4
    i := 101; // 5%
    j := 357; // 14% tot
    jj := 380; // 14% non elig
    k := 403; // Elig 14%
    repeat
      Tv[i + 8] := MaxR(0, Tv[i] - Tv[i + 4]); // 5%   Tv[109]-[101 ]-[105]
      Tv[i + 10] := MaxR(0, Tv[i + 2] - Tv[i + 6]); // 13%
      tv
      If k <> 420 then
        Tv[k] := MaxR(0, Tv[j] - Tv[jj]); // 14%  //20190316
      Tv[i + 11] := MaxR(0, Tv[i + 3] - Tv[i + 7]); // 15%

      inc(i, 12);
      inc(j, 1);
      inc(jj, 1);
      inc(k, 1);
    until i > 329;

    // m4
    // 20190316
    Tv[342] := MaxR(0, AddColumns(109, 337, 12) - Tv[350]); // 20190316
    Tv[343] := MaxR(0, AddColumns(111, 339, 12) - Tv[351]);
    Tv[344] := MaxR(0, AddColumns(112, 340, 12) - Tv[352]);
    Tv[425] := MaxR(0, AddColumns(403, 414, 1) + AddColumns(416, 419, 1) +
      AddColumns(421, 424, 1) - Tv[420]); // no 415 //20190323

    // cca horiz
    i := 61;
    // 20130510
    Tv[69] := MaxR(0, Tv[61] - Tv[65] - Tv[354]); // 5%
    Tv[71] := MaxR(0, Tv[63] - Tv[67] - Tv[355]); // 13%
    Tv[86] := MaxR(0, Tv[87] - Tv[88] - Tv[85]); // 14%
    Tv[72] := MaxR(0, Tv[64] - Tv[68] - Tv[356]); // 15%

    // pg 3
    Tv[42] := Tv[15] + Tv[16];
    Tv[43] := Tv[38] + Tv[40];
    Tv[44] := Tv[39] + Tv[41];
    Tv[58] := Tv[45] + Tv[34];
    Tv[59] := Tv[49] + Tv[56];

    Tv[73] := Tv[42] + Tv[43] + Tv[44] + Tv[58] + Tv[59];
    // +Tv[83]+Tv[60]; //pe 20140106
    Tv[74] := Tv[42] * 1 / 101;
    Tv[75] := Tv[43] * 2 / 102;
    Tv[76] := Tv[44] * 8 / 108;
    Tv[46] := Tv[58] * 9 / 109;
    Tv[47] := Tv[59] * 10 / 110;

    Tv[18] := Tv[74] + Tv[75] + Tv[76] + Tv[46] + Tv[47];
    // +Tv[84]+Tv[48];  //20140106
    // pg 1
    Tv[7] := Tv[342];
    Tv[8] := Tv[69];
    Tv[9] := Tv[7] + Tv[8];

    // 20161117 SAME
    Tv[10] := Tv[9] * 5 / 105;
    If RY > 0 then
      Tv[10] := Tv[9] * 5 / 105;

    Tv[27] := Tv[343];
    Tv[77] := Tv[425]; // 20140106
    Tv[28] := Tv[344];
    // motot veh
    Tv[29] := Tv[71];
    Tv[78] := Tv[86]; // 20140106
    Tv[30] := Tv[72];

    Tv[32] := Tv[27] + Tv[29];
    Tv[33] := Tv[28] + Tv[30];
    Tv[79] := Tv[77] + Tv[78]; // 14%

    Tv[13] := Tv[32] + Tv[79] + Tv[33]; // 20140106  //Tv[31]+  //20190316
    Tv[36] := Tv[32] * 13 / 113;
    Tv[80] := Tv[79] * 14 / 114; // at 14%
    Tv[37] := Tv[33] * 15 / 115;
    Tv[14] := Tv[36] + Tv[80] + Tv[37]; // 20190429

    Tv[17] := Tv[73];
    Tv[26] := Tv[18];
    Tv[19] := Tv[10] + Tv[14] + Tv[26];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure CopyFromT777(RetNo, FNo: integer);
// T777statement not used in simple method
Var
  T777FNo, i, j, k: integer;
  MotorPercent, PersonalMotorPercent, HomePercent: Real; // divided by 100
begin
  // 2320200526
  if UpperCase(FetchElm(RetNo, 'GST370', 12)) > '' then // multiple
  Begin
    CopyFromT777Multiple(RetNo, FNo);
    exit;
  End;

  T777FNo := GetFormNo('T777'); // 20200511

  k := 0; // default at 5% except as below
  If (ret[RetNo].Province = 'BC') then  k := 0 // 20150228 //k:=1  //at 12% second column
  Else If (ret[RetNo].Province = 'ON') then  k := 2 // at 13% third column //20180203
  else If (ret[RetNo].Province = 'NB') or (ret[RetNo].Province = 'NL') or
    (ret[RetNo].Province = 'NS') or (ret[RetNo].Province = 'PE') then
    k := 3; // 20180203  then k:=3;  //at 15% 4th column

  with ret[RetNo].Frm[FNo] do
  begin
    // normal old method
    Tv[101 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 3));
    Tv[113 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 4));
    Tv[125 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 11));
    Tv[137 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 12));
    Tv[149 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 13));
    Tv[161 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 14));
    Tv[173 + k] := +Vl(FetchElmFNo(RetNo, T777FNo, 16)) +
      Vl(FetchElmFNo(RetNo, T777FNo, 18));
    Tv[185 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 65));
    Tv[197 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 58));
    Tv[249 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 65)); // tradesperson
    Tv[209 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 19));
    Tv[221 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 21));
    // motor home
    Tv[245 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 27)); // fuel
    Tv[249 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 27)) * PersonalMotorPercent;
    // personal
    Tv[257 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 28)); // mainenance
    Tv[261 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 28)) * PersonalMotorPercent;
    // personal
    Tv[269 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 33)); // leasing
    Tv[273 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 33)) * PersonalMotorPercent;
    // personal
    Tv[281 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 35)); // othe exp
    Tv[285 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 35)) * PersonalMotorPercent;
    //===========================================================
    // workspace at home   //20210401
    if UpperCase(FetchElmFNo(RetNo,T777FNo,62))='Y' then
     begin
         //HEAT ETC
         Tv[293 + k] :=  Tv[293 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 47));
         Tv[297 + k] :=  Tv[297 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 55));
         Tv[301 + k] :=  Tv[301 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 88));
         ///MAINTENANCE
         Tv[305 + k] := Tv[305 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 50)); // home maintenance
         Tv[309 + k] := Tv[309 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 57)); // home maintenance
         Tv[313 + k] := Tv[313 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 101)); // home maintenance
     end
     Else
     begin
         Tv[293 + k] :=  Tv[293 + k] + 0;
         Tv[297 + k] :=  Tv[297 + k] + 0;
         Tv[301 + k] :=  Tv[301 + k] + 0;
         ///MAINENANCE
         Tv[305 + k] := Tv[305 + k] + 0;
         Tv[309 + k] := Tv[309 + k] + 0;
         Tv[313 + k] := Tv[313 + k] + 0;
     end;
    //========================================================================
    Tv[61 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 20)) +
      Vl(FetchElmFNo(RetNo, T777FNo, 31)); // cca
    Tv[65 + k] := Vl(FetchElmFNo(RetNo, T777FNo, 31)) * PersonalMotorPercent;  // personal
  end;
end;
*)

Procedure T1163(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  FInst: String[4];
  TermLossAmount, RecaptAmount, AutoCCAForStmt, CCAForStmt, x: Real;
  NormalLoss, AllowedLoss, RestrictedLoss: Real;
  MIA, OIA: Real;

Begin
  RestrictedLoss := 0;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If FInst > '#1' then
    begin
    end;
    Strings[1] := FetchElm(RetNo, 'INFO', 54);
    Strings[2] := FetchElm(RetNo, 'INFO', 55);
    Strings[5] := GetFirstName(RetNo);
    Strings[6] := GetLastName(RetNo);
    Strings[7] := GetSinNo(RetNo);

    // 20130224
    If Length(OptRec.Bus_Disclm) > 0 then
      Strings[29] := OptRec.Bus_Disclm
    else
      Strings[29] := '';

    // Contact
    If UpperCase(Strings[63]) = 'Y' then // 20120404
    begin
      Strings[10] := OptRec.Prp_FirstName;
      Strings[11] := OptRec.Prp_LastName;
      Strings[12] := OptRec.Prp_Street;
      Strings[13] := OptRec.Prp_City;
      Strings[14] := OptRec.Prp_Prov;
      Strings[15] := OptRec.Prp_Postal;
      Strings[16] := OptRec.Prp_Area;
      Strings[17] := OptRec.Prp_Tel;
      Strings[18] := OptRec.Prp_FxArea;
      Strings[19] := OptRec.Prp_Fax;
    end;

    If Strings[23] = '' then
    begin
      For i := 10 to 19 do
        Strings[i] := '';
      Strings[8] := '';
    end;

    If Strings[37] + Strings[38] + Strings[39] = '' then
      Strings[39] := 'X';
    If Strings[35] + Strings[36] = '' then
      Strings[35] := 'X';
    If Strings[34] = '' then
      Strings[34] := '115110';
    If Strings[33] = '' then
      Strings[33] := '1';
    // 20170530
    If Strings[32] = '' then
      Strings[32] := ret[RetNo].Province; // 20170530
    If Strings[35] + Strings[36] = '' then
      Strings[36] := 'X';
    If Strings[36] > '' then
    begin
      If Strings[25] + Strings[26] = '' then
        Strings[26] := 'X';
    end
    else
    begin
      Strings[25] := '';
      Strings[26] := '';
    end;
    If Strings[9] + Strings[24] = '' then
      Strings[24] := 'X'; // 20140101
  end;

  // pg 2
  With ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[101] := AppYear + ' Statement A'
    else
      Strings[101] := AppYear + ' Statement B';
    Strings[103] := MidStr(FInst, 2, 2);
    Strings[104] := IntToStr(CountT1163(RetNo));
    // header cunters //20180210
    Strings[105] := Strings[104];
    Strings[106] := Strings[104];
    Strings[107] := Strings[104];
  end;

  // pg 3
  With ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[353] := AppYear + ' Statement A'
    else
      Strings[353] := AppYear + ' Statement B';
    Strings[354] := MidStr(FInst, 2, 2);
    If Strings[207] + Strings[208] = '' then
      Strings[207] := 'X'; // 20100901
    If Strings[212] = '' then
      Strings[212] := '2';
    If Strings[213] = '' then
      Strings[213] := AppYear + '-01-01';
    If Strings[214] = '' then
      Strings[214] := AppYear + '-12-31';
    // 20111208
    If Strings[210] = '' then
      Strings[210] := '100.0000';
    If Vl(Strings[210]) > 100 then
      Strings[210] := '100.0000';
    Tv[210] := Vl(Strings[210]);
    Strings[210] := FormatFloat('##0.0000', Vl(Strings[210]));
    // If Tv[210]=0 then Tv[210]:=100;
    // If Tv[210]>100 then Tv[210]:=100;
    If Strings[211] = '' then
      Strings[211] := 'N'; { restr farm loss }
    // Strings[218]:='Point of Sale Adjustments';  //20120227
    // Strings[219]:='575';
    i := 220;
    Repeat
      Strings[i - 1] := LeftStr(Strings[i - 1], 3);
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      inc(i, 3);
    until i > 304;

    // Feb 24 2008
    // recapt
    ExtractCCA(RetNo, 'T1163', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    Tv[356] := RecaptAmount;
    ExtractAutos(RetNo, 'T1163', FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    Tv[356] := Tv[356] + RecaptAmount; // 20110412
    // Tv[356]:=Tv[156]+RecaptAmount;

    Tv[309] := Tv[355] + Tv[356];
    Tv[305] := AddColumns(220, 304, 3);
    x := AddColumns(321, 348, 3); //20230107 //+Tv[137]; //20220424
    Tv[318] := x;
    Tv[349] := AddColumns(306, 318, 1);
    Tv[350] := Tv[305];
    Tv[351] := Tv[349];
    Tv[352] := Tv[350] + Tv[351];
  end;
  // pg 4
  With ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[595] := AppYear + ' Statement A'
    else
      Strings[595] := AppYear + ' Statement B';
    Strings[591] := MidStr(FInst, 2, 2);

    // get autoexpenses
    ExtractAutos(RetNo, 'T1163', FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    Tv[527] := 0;
    For i := 0 to ExtractedAutoList.count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];
      Tv[527] := Tv[527] + ExtractedAutoRec.ExpensesClaimed;
    end;

    // CCA
    ExtractCCA(RetNo, 'T1163', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    Tv[537] := CCAForStmt; // 20101205
    ExtractAutos(RetNo, 'T1163', FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    Tv[537] := Tv[537] + AutoCCAForStmt; // 20101205

    Strings[402] := '575'; // 20100901
    Strings[401] := 'Point of sale adjustments';

    i := 403; // 20100901
    Repeat
      Strings[i - 1] := LeftStr(Strings[i - 1], 3);
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      inc(i, 3);
    until i > 457;

    Tv[458] := AddColumns(403, 457, 3); // 20100901
    Tv[512] := AddColumns(459, 470, 1) + Tv[473] + AddColumns(478, 511, 3);
    // AddColumns(59,73,1)+AddColumns(78,111,3);
    Tv[586] := AddColumns(542, 584, 3);
    Tv[585] := AddColumns(513, 535, 1) + AddColumns(537, 539, 1) + Tv[586];
    // exclude 536 cec //20171119
    // Tv[585]:=AddColumns(513,539,1)+Tv[586];

    Tv[587] := Tv[458];
    Tv[588] := Tv[512];
    Tv[589] := Tv[585];
    Tv[590] := Tv[587] + Tv[588] + Tv[589];
  end;

  // pg 5
  With ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[617] := AppYear + ' Statement A'
    else
      Strings[617] := AppYear + ' Statement B';
    Strings[604] := MidStr(FInst, 2, 2);
    Strings[678] := 'Double click for MIA Worksheet';
    Tv[601] := Vl(FetchElm(RetNo, 'T1163' + FInst, 352));
    Tv[602] := Vl(FetchElm(RetNo, 'T1163' + FInst, 590));
    Tv[603] := Tv[601] - Tv[602];
    // Tv[605] := Tv[603];  //202001121

    Tv[628] := Vl(FetchElm(RetNo, 'T1175' + FInst, 165));
    // 20090411
    (*
      If Tv[5]>0 then   //ni
      Tv[28]:=MinR(Tv[28],Tv[5])
      else
      Tv[28]:=0;
    *)
    Tv[606] := Tv[628] + Tv[633];
    Tv[607] := Tv[603] - Tv[606]; // Tv[605] - Tv[606];
    If UpperCase(Strings[677]) = 'Y' then // 20110216
    begin
      GetMIAAmount(RetNo, FName, MIA, OIA);
      Tv[608] := OIA;
      Tv[610] := MIA;
    end;

    Tv[612] := Tv[608] + Tv[610];
    Tv[609] := Tv[612];
    Tv[611] := Tv[607] + Tv[609];
    { partnsh info }
    Strings[625] := GetFirstName(RetNo);
    Strings[626] := GetLastName(RetNo);
    Strings[629] := FetchElm(RetNo, 'T1163' + FInst, 20);
    // Tv[627] := Vl(FetchElm(RetNo,'T1163'+FInst,210)); //20120222
    Strings[627] := FetchElm(RetNo, 'T1163' + FInst, 210);
    Strings[630] := GetSpouseFirstName(RetNo);
    Strings[631] := GetSpouseLastName(RetNo);

    Tv[615] := Tv[611] * Vl(FetchElm(RetNo, 'T1163' + FInst, 210)) / 100;
    //20220116
    Tv[153]:=Tv[615]+Tv[152];  //20220116
    Tv[613] := Tv[611];
    If Vl(FetchElm(RetNo, 'T1163' + FInst,210))<100 Then
      Tv[613]:=Tv[153];

    {//20220116
    If Strings[618] <> 'Y' then
    begin
      If FetchElm(RetNo, 'T1163' + FInst, 207) = 'X' then
      begin
        If Tv[613] < 0 then
          Tv[614] := MinR(Abs(Tv[613]), Tv[628])
        else
          Tv[614] := 0;
      end
      else
        Tv[614] := 0;
    end;
    }

    // 20200121
    // Tv[680]:=Tv[613]+Tv[614];
    Tv[675] := Tv[613] + Tv[614] + Tv[679]; // Tv[680]+Tv[679];

    If (UpperCase(FetchElm(RetNo, 'T1163' + FInst, 211)) = 'Y') and (Tv[675] < 0)
    then
    { restricted farm loss }
    begin
      NormalLoss := Abs(Tv[675]);
      If NormalLoss > 32500 then // 20140316
        AllowedLoss := 17500
        // If NormalLoss>15000 then AllowedLoss := 8750
      else
        AllowedLoss := MinR(NormalLoss,
          2500 + MaxR(0, (NormalLoss - 2500) / 2));

      RestrictedLoss := NormalLoss - AllowedLoss;
      Tv[676] := RestrictedLoss;
      Tv[616] := Tv[675] - (-RestrictedLoss);
    end
    else
    begin
      RestrictedLoss := 0;
      Tv[676] := 0;
      Tv[616] := Tv[675];
    end;
    i := 627;
    Repeat
      Tv[i] := Vl(Strings[i]);
      Strings[i] := FormatFloat('##0.0000', Tv[i]);
      If Tv[i] = 0 then
        Strings[i] := '';
      inc(i, 5);
    until i > 657;
    // Tv[619]:=Tv[627]+Tv[632]+Tv[637]+Tv[642]+Tv[647]+Tv[652]+Tv[657];  //20120222
    Strings[619] := FormatFloat('###.0000', Tv[627] + Tv[632] + Tv[637] +
      Tv[642] + Tv[647] + Tv[652] + Tv[657]); // 20120222
    // FormatFloat('##0.0000',Tv[619]);
    Tv[620] := SpouseIncome(RetNo);
  end;
  SaveTv(RetNo, FName, FNo);
  // after save
  If Vl(FetchElm(RetNo, 'T1175' + FInst, 165)) > 0 then
    Calc(RetNo, 'T1175' + FInst);
end;

Procedure T2200(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetLastName(RetNo);
    Strings[2] := GetFirstName(RetNo);
    If Strings[47] = '' then
      Strings[47] := AppYear;
    {employee sin and address
    Strings[3] := GetSinNo(RetNo);
    Strings[4] := FetchElm(RetNo, 'INFO', 6) + ',' + FetchElm(RetNo, 'INFO', 22);
    Strings[5] := FetchElm(RetNo, 'INFO', 10);
    Strings[6] := FetchElm(RetNo, 'INFO', 14);
    Strings[7] := FetchElm(RetNo, 'INFO', 15);
    }
    If Strings[12] + Strings[13] = '' then
      Strings[12] := 'X';
    If Strings[14] + Strings[15] = '' then
      Strings[14] := 'X';
    If Strings[19] + Strings[20] = '' then
      Strings[20] := 'X';
    If Strings[23] + Strings[24] = '' then
      Strings[24] := 'X';
    If Strings[27] + Strings[28] = '' then
      Strings[27] := 'X';

    //20220212
    Strings[60]:=GetFirstName(RetNo)+' '+GetLastName(Retno);
    Strings[58] := GetSinNo(RetNo);
    if Strings[59]='' then Strings[59]:=FormatDateTime('yyyy-mm-dd', Now);

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T5008(RetNo: integer; FName: string; FNo: integer);
var
  i,j: integer;
Begin
  if NOT fileExists(AppDir + '\' + 'FCurrencies.Txt') then
  Begin
    CopyFile(AppDir + '\' + 'FCurrencies.d', AppDir + '\' + 'FCurrencies.txt');
    {
      ForeignCurrencyList:=TStringList.create;
      ForeignCurrencyList.Add('Enter below the currency name and average exchange rate, as shown below');
      //ForeignCurrencyList.Add('???'+Space(27)+'??.??????');
      ForeignCurrencyList.SaveToFile(AppDir+'\'+'FCurrencies.d');
    }
  End;

  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If Strings[208] = '' then
      Strings[208] := MkTddFileName(RetNo, GetSinNo(RetNo)); // 20200526
    xxstring:=Strings[215];  //debugging to see a string

   // if Strings[215] = '' then  Strings[215] := 'N';  //???
    Strings[ 183]:='Total Auto-fill My Return T5008 slips'; //20260215

    Tv[197] := Tv[193] - Tv[194] - Tv[195] - Tv[196];
    Tv[202] := Tv[198] - Tv[199] - Tv[200] - Tv[201];
    Tv[213] := Tv[209] - Tv[210] - Tv[211] - Tv[212];

    Tv[203] := Tv[193] + Tv[209];
    Tv[204] := Tv[194] + Tv[210];
    Tv[205] := Tv[195] + Tv[211];
    Tv[206] := Tv[196] + Tv[212];
    Tv[207] := Tv[197] + Tv[213];

    if (UpperCase(Strings[215]) = 'Y') and (Tv[207] <> 0) and
      (Strings[214] = '') // use and thre is amount and no missing rates
    then
    Begin
      Strings[1] := 'Miscellaneous';
      Strings[2] := 'C';
      Tv[3] := Tv[203];
      Tv[4] := Tv[204];
      Tv[5] := Tv[205];
      Tv[7] := Tv[207];
    End;

    Tv[190] := 0;
    Tv[191] := 0;
    Tv[192] := 0; // 20150129  Cap disp
    Tv[269]:=0; //20250113
    Tv[270]:=0; //20250113

    i:=3;
    j:=198;  //period 2
    Repeat
      xxstring:=Strings[215];  //debugging to see a string
      //20250410 If (Strings[i-2]>'') and    //description i-2 optional  (only desposition counts
      If (Strings[i - 1] = '') then Strings[i - 1] := 'C'; // 'I'; //20180424

      If UpperCase(Strings[i - 1]) = 'I' then
      begin
        Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
        Tv[i + 4] := 0;
        Tv[190] := Tv[190] + Tv[i + 3];
      end
      else
      begin
        Tv[i + 3] := 0;
        Tv[i + 4] := Tv[i] - Tv[i + 1] - Tv[i + 2];
        //20240113
        If UpperCase(Strings[i - 1]) = 'C' then
        Begin
         //dispositions
         if Uppercase(Strings[j])='Y' then    //period 2
           Tv[269] := Tv[269] + Tv[i]
         else
           Tv[192] := Tv[192] + Tv[i];
         //gains
         if Uppercase(Strings[j])='Y' then
           Tv[270] := Tv[270] + Tv[i + 4]
         else
           Tv[191] := Tv[191] + Tv[i + 4];
        End;
      end;
      inc(i, 7);
      Inc(j,1);  //20250113
    until i > 185;
  end;
  SaveTv(RetNo, FName, FNo);
end;

(* 20200523  To be used in 2020 with T5008 from T1forms/Keep-for 2020
  Procedure T5008(RetNo:integer;FName:string;FNo:integer);
  var i,j: integer;
  Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  Tv[190] :=0;
  Tv[192]:=0;  //20150129  Cap disp
  Tv[191]:=0;
  Tv[247]:=0;
  Tv[248]:=0;

  i:= 3;
  j:=193;
  Repeat
  Strings[249]:='Y'; //This works in coupling   //if Strings[249]='' then Strings[249]:='N';
  If Strings[i-1] = '' then strings[i-1] := 'C'; // 'I'; //20180424
  if Tv[j]+Tv[j+1]=0 then Tv[j]:=100;  //20200522
  if Tv[j+1]>100 then Tv[J+1]:=100;
  if Uppercase(Strings[249])<>'Y' then Tv[j+1]:=0; //remove spouse %
  Tv[j]:=100-Tv[j+1];

  If UpperCase(Strings[i-1]) = 'I' then
  begin
  Tv[i+3] := (MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2])) * Tv[j]/100; //20200522
  Tv[i+4] :=0;
  Tv[190] := Tv[190]+Tv[i+3];
  Tv[247] := Tv[247]+(MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2])) * Tv[j+1]/100;
  end
  else
  begin
  Tv[i+3] :=0;
  Tv[i+4] := (Tv[i]-Tv[i+1]-Tv[i+2])* Tv[j]/100;  //20200522
  Tv[192]:=Tv[192]+Tv[i];  //20150128
  Tv[191] := Tv[191]+Tv[i+4];
  Tv[248] := Tv[248]+(Tv[i]-Tv[i+1]-Tv[i+2])* Tv[j+1]/100;
  end;
  //if (Tv[i+5]=0) and (Tv[i+6]=0) then begin Tv[j]:=0;Tv[j+1]:=0;End; //% remove if no invststm or cap gain
  Inc(i,7);
  Inc(j,2);
  until i> 185;
  end;
  {
  i:= 6; //invest income and cap gain
  j:=193;
  Repeat
  if (Tv[i]=0) and (Tv[i+1]=0) then begin Tv[j]:=0;Tv[j+1]:=0;End; //% remove if no invststm or cap gain
  Inc(i,7);
  Inc(j,2);
  Until i>188;
  }
  SaveTv(RetNo,FName,FNo);
  end;
*)
Procedure T1033(RetNo: integer; FName: string; FNo: integer);
Var
  i, YrNdx: integer;
  SelfInc: Real;
  ThreshHold: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  If ret[RetNo].Province <> 'QC' then
    ThreshHold := 3000
  else
    ThreshHold := 1800;
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Frm[FNo].Strings[37] := AppYear;
    Frm[FNo].Strings[38] := IntToStr(MyStrToInt(AppYear) + 1);
    Frm[FNo].Strings[39] := IntToStr(MyStrToInt(AppYear) - 1);
    Frm[FNo].Strings[40] := AppYear;
    Frm[FNo].Strings[41] := IntToStr(StrToInt(AppYear) + 1);

    Frm[FNo].Strings[1] := GetSinNo(RetNo);
    If Frm[FNo].Strings[30] + Frm[FNo].Strings[31] = '' then
      Frm[FNo].Strings[30] := 'X';

    SelfInc := Lnn[12200] + Lnn[13500] + Lnn[13700] + Lnn[13900] + Lnn[14100] +
      Lnn[14300];
    If UpperCase(Frm[FNo].Strings[30]) = 'X' then { actual }
    begin
      If Frm[FNo].Strings[37] > '' then
        Frm[FNo].Strings[33] := AppYear
      else
        Frm[FNo].Strings[33] := IntToStr(StrToInt(AppYear) + 1);
      Tv[2] := Lnn[42000];
      Tv[42] := Lnn[42200];
      Tv[3] := Lnn[42800];
      Tv[47] := Lnn[43200];
      Tv[48] := Lnn[45300];
      Tv[5] := Lnn[43700];
      If ret[RetNo].Province <> 'QC' then
        Tv[5] := Lnn[43850]; //Lnn[43900];  //20230218
      Tv[6] := Lnn[44000] + Lnn[44100];
      Tv[50] := Lnn[45110]; // 20200313
      Tv[46] := Lnn[45200];
      Tv[44] := Lnn[45400];
      // Tv[50]:=Lnn[45900];  //20160510 //20160505 Igor //20200313
      Tv[7] := Lnn[45600];
      Tv[9] := Lnn[47900];
      { cpp }
      Tv[13] := SelfInc;
      Tv[21] := Lnn[30800];
      Tv[49] := Lnn[43000]; // 20140614
    end { end actual }
    else { estimates }
    begin
      Frm[FNo].Strings[33] := IntToStr(StrToInt(AppYear) + 1);
    end;
    Tv[4] := Tv[2] + Tv[42] + Tv[3] + Tv[47];
    Tv[43] := Tv[4];
    Tv[10] := Tv[5] + Tv[6] + Tv[46] + Tv[50] + Tv[48] + Tv[44] + Tv[7] + Tv[9];
    // 20160410 //20160505 Igor //20200313 added Climate [50]
    Tv[11] := Tv[10];
    Tv[12] := MaxR(0, Tv[43] - Tv[11]);

    If UpperCase(Frm[FNo].Strings[30]) = 'X' then
      YrNdx := 0
    else
      YrNdx := 1;
    Tv[14] := Constant[YrNdx].BasicCppExemption;
    Tv[15] := Tv[14];
    Tv[16] := Constant[YrNdx].MaxCppEarnings;
    Tv[17] := Tv[16];
    Tv[18] := Tv[13] - Tv[15];
    Tv[18] := MinR(Tv[17], Tv[18]);
    Tv[18] := MaxR(0, Tv[18]);
    Tv[19] := 2 * Constant[YrNdx].CppRate * 100;
    Tv[20] := Tv[19] * Tv[18] / 100;
    Tv[22] := Tv[21] * 2;
    Tv[23] := MaxR(0, Tv[20] - Tv[22]);
    If SelfInc = 0 then
      for i := 13 to 22 do
        Tv[i] := 0;

    If (Age + 1 > 70) or (Vl(FetchElm(RetNo, 'T4AP#1', 11)) > 0) { Retirement }
      or (Vl(FetchElm(RetNo, 'T4AP#1', 13)) > 0) { disability }
    then
    begin
      for i := 13 to 22 do
        Tv[i] := 0;
      Tv[23] := 0;
    end;
    If UpperCase(Frm[FNo].Strings[8]) <> 'Y' then
    begin
      Tv[24] := Tv[12] + Tv[23] + Tv[49];
      If UpperCase(Frm[FNo].Strings[32]) = 'X' then
      begin
        Tv[29] := Tv[24] * 2 / 3; // Tv[29]:=Tv[24] /3;
        For i := 25 to 28 do
          Tv[i] := 0;
      end
      else
      begin
        Tv[25] := Tv[24] / 4;
        Tv[26] := Tv[25];
        Tv[27] := Tv[25];
        Tv[28] := Tv[25];
        Tv[45] := Tv[24];
        Tv[29] := 0;
      end;
    end // override
    else
      Tv[45] := Tv[25] + Tv[26] + Tv[27] + Tv[28];
    If UpperCase(Frm[FNo].Strings[30]) = 'X' then
    begin
      If Tv[24] > ThreshHold then
        Frm[FNo].Strings[35] := 'X'
      else
        Frm[FNo].Strings[35] := '';
    end
    else
    begin
      If Tv[24] > ThreshHold then
        Frm[FNo].Strings[36] := 'X'
      else
        Frm[FNo].Strings[36] := '';
    end;
    If Frm[FNo].Strings[34] + Frm[FNo].Strings[35] + Frm[FNo].Strings[36] = ''
    then { no instalments }
    begin
      Tv[45] := 0;
      for i := 25 to 29 do
        Tv[i] := 0;
    end;
  end; { with }

  (*
    //pg2
    With ret[RetNo].Frm[FNo] do
    begin
    Strings[101]:=AppYear;
    end;
  *)
  If ret[RetNo].Deceased = True then
    for i := 1 to 45 do
      ret[RetNo].Frm[FNo].Tv[i] := 0;

  SaveTv(RetNo, FName, FNo);
End;

Procedure CCA2000(RetNo: integer; FName: string; FNo: integer);
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo] do
  begin
    { no calcs }
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1M(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  FInst: String;
Begin
  FInst := ExtractFormInst(FName); // 20110326
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    Strings[2] := GetFirstName(RetNo); // 20200331
    Strings[3] := GetLastName(RetNo);
    Strings[4] := GetSinNo(RetNo);
    Tv[24] := MaxR(0, Tv[22] - Tv[23]);
  end;

  // pg2  //https://www.canada.ca/en/revenue-agency/services/tax/individuals/topics/about-your-tax-return/tax-return/completing-a-tax-return/deductions-credits-expenses/line-255-northern-residents-deductions/meal-vehicle-rates-used-calculate-travel-expenses.html
  With ret[RetNo].Frm[FNo] do
  begin
    If (Strings[135] > '') then
    begin
      If Strings[137] = '' then
        Strings[137] := ret[RetNo].Province;
      Strings[138] := '';
      // 20260801
      If Strings[137] = 'AB'      then Strings[138] := '56.5'  //49.0?
      else If Strings[137] = 'BC' then Strings[138] := '59.5' //'52.0'
      else If Strings[137] = 'MB' then Strings[138] := '56.0' //'49.5'
      else If Strings[137] = 'NB' then Strings[138] := '59.5' //'50.5'
      else If Strings[137] = 'NL' then Strings[138] := '61.5' //'54.5'
      else If Strings[137] = 'NT' then Strings[138] := '70.0' //'59.5'
      else If Strings[137] = 'NS' then Strings[138] := '59.5' //'51.0'
      else If Strings[137] = 'NU' then Strings[138] := '70.5' //'59.0'
      else If Strings[137] = 'ON' then Strings[138] := '62.0' //'55.0'
      else If Strings[137] = 'PE' then Strings[138] := '58.5' //'49.0'
      else If Strings[137] = 'QC' then Strings[138] := '60.5' //'52.0'
      else If Strings[137] = 'SK' then Strings[138] := '55.5' //'49.0'
      else If Strings[137] = 'YT' then Strings[138] := '70.5'; //'58.0';

      // 20190313
      if Strings[112] > '15' then
        Strings[112] := '15';
      if Strings[114] > '15' then
        Strings[114] := '15';
      If UpperCase(Strings[139]) = 'Y' then
      begin
        Tv[103] := Vl(Strings[106]) * Vl(Strings[138]) / 100;
        If Tv[109] > MyStrToInt(Strings[104]) * MyStrToInt(Strings[110]) * 69
        then
          Tv[109] := MyStrToInt(Strings[104]) * MyStrToInt(Strings[110]) * 69;
        If Tv[113] > MyStrToInt(Strings[104]) * MyStrToInt(Strings[114]) * 69
        then
          Tv[113] := MyStrToInt(Strings[104]) * MyStrToInt(Strings[114]) * 69;
      end;
    end;

    If Tv[133] > 5000 then Tv[133] := 5000;
    //20220130
    Tv[28]:=Tv[103]+Tv[107]+Tv[109];
    Tv[29]:=Tv[28];

    Tv[30]:=Tv[111]+Tv[113];
    Tv[31]:=Tv[30];

    Tv[32]:=Tv[115]+Tv[132]+Tv[133];
    Tv[33]:=Tv[32];

    Tv[34]:=Tv[117]+Tv[118]+Tv[119]+Tv[120];
    Tv[35]:=Tv[34];

    Tv[36]:=Tv[122]+Tv[123];
    Tv[37]:=Tv[36];


    If FInst = '#1' then { c/f only to first moving statement ? }
    begin
      If Tv[130] = 0 then
        Tv[130] := Vl(FetchElm(RetNo, 'CFR', 38));
    end;

    Tv[124] := Tv[101]+Tv[29]+Tv[31]+Tv[33]+Tv[35]+Tv[37]; //20220130
    Tv[124] := Tv[124] + Tv[130];  //c/f
    {
    Tv[124] := Tv[101] + Tv[103] + Tv[107] + Tv[109] + Tv[111] + Tv[113];
    Tv[124] := Tv[124] + Tv[115] + Tv[132] + Tv[133] + Tv[117] + Tv[118] +
      Tv[119] + Tv[120] + Tv[122] + Tv[123];

    }
    Tv[126] := MaxR(0, Tv[124] - Tv[125]);
    Tv[38]:=Tv[126];  //20220130

    Tv[129] := MaxR(0, Tv[126] - Tv[127]);
    Tv[128] := MinR(Tv[38], Tv[127]);  //20220130
    If Tv[24] < 40 then
    begin
      Tv[128] := 0;
      Tv[129] := 0;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure OLDLOSS(RetNo: integer; FName: String; FNo: integer);
Var
  i, Yr: integer;
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo] do
  begin
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

//20251008 Igor >>>
procedure CFR(RetNo: Integer; FName: string; FNo: Integer);
var
  i, Yr: Integer;
  CurrentInclRate, AdjFact, TxblGains, RemGains, NetApplied, TotalApplied,
  Adjusted, PriorInclRate, TxblIncome, FarmIncome: Real;
  AutoSw: boolean;
  IR, AdjFactor1, AdjFactor2, MaxLimit: Real;
begin
  LoadTv(RetNo, FName, FNo);

  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Frm[FNo].Strings[58]:= 'Donations';
    Frm[FNo].Strings[59]:= 'T657';
    Frm[FNo].Strings[60]:= 'Loss Continuity';

    i:= 6;
    repeat
      Tv[i + 10] := Tv[i] + Tv[i + 5];
      inc(i);
    until i > 10;

    if Frm[FNo].Strings[40].Equals('') then Frm[FNo].Strings[40]:= '75'; // IR inclusdion Rate in 2000  //20181202

    Tv[36]:= Tv[34] + Tv[35];
    Tv[44]:= Tv[42] + Tv[43];
    Tv[49]:= Tv[47] + Tv[48];
    Tv[56]:= Tv[54] + Tv[55];
    Tv[62]:= Tv[64] + Tv[63];
    Tv[69]:= Tv[67] + Tv[68];
    Tv[60]:= Tv[32] + Tv[59];
    Tv[80]:= Tv[78] + Tv[79];
    Tv[86]:= Tv[84] + Tv[85];
    Tv[91]:= Tv[89] + Tv[90];
    Tv[96]:= Tv[94] + Tv[95];
    Tv[266]:= Tv[264] + Tv[265];
    Tv[271]:= Tv[269] + Tv[270]; // 20130822
    Tv[276]:= Tv[274] + Tv[275]; // 20140813
    Tv[281]:= Tv[279] + Tv[280]; // 20151016
    Tv[286]:= Tv[284] + Tv[285]; // 20161118
    Tv[291]:= Tv[289] + Tv[290]; // 20171119
    Tv[296]:= Tv[294] + Tv[295]; // 20181112
    Tv[301]:= Tv[299] + Tv[300]; // 20190921
    Tv[306]:= Tv[304] + Tv[305]; // 20190921
    Tv[311]:= Tv[309] + Tv[310]; // 20211214
    Tv[316]:= Tv[314] + Tv[315]; // 20221204
    Tv[321]:= Tv[319] + Tv[320]; // 20231111
    Tv[326]:= Tv[324] + Tv[325]; // 20250419
    Tv[330]:= Tv[328] + Tv[329]; //20251008 Igor
    // limited partn
    Tv[75]:= MinR(Tv[75], MinR(Tv[73], Tv[74]));
    Tv[77]:= MaxR(0, Tv[73] - Tv[75]) + Tv[76];
  end; { End with }

  // pg 2
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    if Frm[FNo].Strings[99].Equals('') then Frm[FNo].Strings[99] := 'Y'; // 20201017
    // If Frm[FNo].Strings[304] = '' then Frm[FNo].Strings[304]:='Y';
    AutoSw:= (UpperCase(Frm[FNo].Strings[99]) = 'Y'); // 20201017
    { Enter years in non cap loss }
    Yr:= MyStrToInt(AppYear) - 7;
    i:= 101;
    Repeat
      Frm[FNo].Strings[i]:= IntToStr(Yr);
      inc(i, 5);
      Yr:= Yr + 1;
    until i > 136;
    { Enter years in non farm loss }
    Yr:= MyStrToInt(AppYear) - 10;
    i:= 145;
    Repeat
      Frm[FNo].Strings[i]:= IntToStr(Yr);
      inc(i, 5);
      Yr:= Yr + 1;
    until i > 195;
    { Enter years in restr farm loss }
    Yr:= MyStrToInt(AppYear) - 10;
    i:= 204;
    Repeat
      Frm[FNo].Strings[i]:= IntToStr(Yr);
      inc(i, 5);
      Yr:= Yr + 1;
    until i > 254;

    { current year loss }
    Tv[137]:= Vl(FetchElm(RetNo, 'T1A', 43)); { other non-cap }
    Tv[196]:= Vl(FetchElm(RetNo, 'T1A', 104)); { farming/fish }
    Tv[255]:= Vl(FetchElm(RetNo, 'T1A', 139)); { Restr farm }
    { Loss C/B }
    Tv[138]:= Vl(FetchElm(RetNo, 'T1A', 48)); { other non-cap }
    Tv[197]:= Vl(FetchElm(RetNo, 'T1A', 117)); { farming/fish c/b }
    Tv[256]:= Vl(FetchElm(RetNo, 'T1A', 147)); { Restr farm c/b }

    { calc txbl income against wich to apply non cap/farm losses }
    TxblIncome:= GetTxblIncBfrLosses(RetNo);
    { apply restricted farm losses }
    FarmIncome:= ret[RetNo].Lnn[14100];
    if FarmIncome < 0 then FarmIncome:= 0; { apply only if positive farm income }
    if AutoSw then
    begin
      i:= 205;
      Repeat
        Tv[i + 1]:= MinR(Tv[i], FarmIncome);
        FarmIncome:= MaxR(0, FarmIncome - Tv[i + 1]);
        inc(i, 5);
      until i > 250;
    end;

    { apply farm losses }
    if AutoSw then
    begin
      i:= 146;
      Repeat
        Tv[i + 1]:= MinR(Tv[i], TxblIncome);
        TxblIncome:= MaxR(0, TxblIncome - Tv[i + 1]);
        inc(i, 5);
      until i > 191;
    end;
    { apply non cap losses }
    if AutoSw then
    begin
      i:= 102;
      Repeat
        Tv[i + 1]:= MinR(Tv[i], TxblIncome);
        TxblIncome:= MaxR(0, TxblIncome - Tv[i + 1]);
        inc(i, 5);
      until i > 132;
    end;
    { calc section non cap losses }
    i:= 102;
    repeat
      // If i=102 then Tv[i+2]:=MaxR(0,Tv[i]-Tv[i+1]);  //20130406
      Tv[i + 3]:= MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      inc(i, 5);
    until i > 137;

    Tv[141]:= AddColumns(102, 137, 5);
    Tv[142]:= AddColumns(103, 138, 5);
    Tv[143]:= AddColumns(104, 139, 5);
    Tv[144]:= AddColumns(105, 140, 5);

    { calc section farm losses }
    i:= 146;
    repeat
      if (i = 146) then Tv[i + 2]:= MaxR(0, Tv[i] - Tv[i + 1]);

      Tv[i + 3]:= MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      inc(i, 5);
    until i > 196;

    Tv[200]:= AddColumns(146, 196, 5);
    Tv[201]:= AddColumns(147, 197, 5);
    Tv[202]:= AddColumns(148, 198, 5);
    Tv[203]:= AddColumns(149, 199, 5);

    { calc section restr farm losses }
    i:= 205;
    repeat
      if i = 205 then Tv[i + 2]:= MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[i + 3]:= MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      inc(i, 5);
    until i > 255;

    Tv[259]:= AddColumns(205, 255, 5);
    Tv[260]:= AddColumns(206, 256, 5);
    Tv[261]:= AddColumns(207, 257, 5);
    Tv[262]:= AddColumns(208, 258, 5);
  end;

  // -------- CFR pg3    NET CAPITAL LOSSES
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[401].Equals('') then Strings[401]:= 'Y';
    Tv[410]:= Vl(FetchElm(RetNo, 'CFR', 40));
    IR:= Tv[410]; // Vl(Strings[10]);
    if (IR = 0) then IR:= 50; // 0.50;

     // Get unupplied adjusted losses
    i:= 465;
    Tv[407]:= 0;
    Repeat
      AdjFactor1:= 1;
      AdjFactor2:= 1;

      // 20200519
      if i = 475 then
      begin
        AdjFactor1:= 2 / 3;
        AdjFactor2:= 3 / 2;
      end;
      if i = 480 then
      begin
        AdjFactor1:= 3 / 4;
        AdjFactor2:= 4 / 3;
      end;
      if i = 485 then
      begin // yr 2000
        IR:= IR / 100;
        AdjFactor1:= 1 / (2 * IR);
        AdjFactor2:= 2 * IR;
      end;
      Tv[i + 1]:= Tv[i] * AdjFactor1; // c
      Tv[407]:= Tv[407] + Tv[i + 1];
      inc(i, 5);
    until i > 605; //20251020 Igor //600     595; //20231111 590; //20221204 //585; //580; // 20201017 575;  //20190921

    TxblGains:= MaxR(0, Vl(FetchElm(RetNo, 'S3', 339))); //202500411
        //MaxR(0, Vl(FetchElm(RetNo, 'S3', 97))); // 20170308
    MaxLimit:= MinR(Tv[407], TxblGains);
    if (GetTxblIncBeforeLine253(RetNo) <= Vl(FetchElm(RetNo, 'T1', 98))) then MaxLimit:= 0; // 20190922
    // if GetTxblIncBeforeLine253(RetNo)<=Vl(FetchElm(RetNo,'S1',23)) then MaxLimit:=0;
    RemGains:= MaxLimit;
    NetApplied:= 0;
    TotalApplied:= 0;
    // Apply
    i:= 465;
    Tv[408]:= 0;
    Tv[433]:= 0;
    Tv[399]:= 0;
    Tv[398]:= 0;
    Repeat
      AdjFactor2:= 1;
      // 20200519
      if i = 475 then AdjFactor2:= 3 / 2;
      if i = 480 then AdjFactor2:= 4 / 3;

      if i = 485 then
      begin // yr 2000
        IR:= Tv[410];
        AdjFactor2:= (2 * IR) / 100;
      end;
      If UpperCase(Strings[401]) = 'Y' then // 20101210 401 vs 1
        Tv[i + 2]:= MinR(RemGains, Tv[i + 1])
      else
        Tv[i + 2]:= MinR(Tv[i + 2], Tv[i + 1]);
      NetApplied:= Tv[i + 2];
      Tv[i + 3]:= MaxR(0, Tv[i + 1] - Tv[i + 2]); // e
      Tv[i + 4]:= Tv[i + 3] * AdjFactor2; // NetApplied /AdjFact;
      Tv[433]:= Tv[433] + Tv[i + 4];
      TotalApplied:= TotalApplied + NetApplied;
      RemGains:= MaxR(0, MaxLimit - TotalApplied);
      Tv[408]:= Tv[408] + Tv[i + 2];
      Tv[399]:= Tv[399] + Tv[i + 3];
      Tv[398]:= Tv[398] + Tv[i + 4]; // 20111104
      inc(i, 5);
    until i > 605; //20251020 Igor //600; //20250406595; //20231111 590; //585; //580; // 20201017 575; //20190921 //20221204

      //20260326
    Tv[402]:=Vl(FetchElm(RetNo,'T1A',63));  // Tot current loss
    Tv[403]:=Tv[402]; //Vl(FetchElm(RetNo,'T1A',63));  //20260326 C/Bt
    Tv[404]:=Vl(FetchElm(RetNo,'T1A',105)); //C/B
    Tv[405]:=Vl(FetchElm(RetNo,'T1A',128)); //c/F in T1A
    // current year
    //Tv[402]:= Vl(FetchElm(RetNo, 'T1A', 119));
    //Tv[403]:= Tv[402];
    //Tv[404]:= Vl(FetchElm(RetNo, 'T1A', 105));
    //Tv[405]:= MaxR(0, Tv[403] - Tv[404]);
    Tv[406]:= Tv[405];
    Tv[434]:= Tv[398] + Tv[406]; // Tv[433]+Tv[406];     //20171119

    // last section
    Tv[411]:= Tv[465];
    Tv[412]:= Tv[16];
    Tv[417]:= Tv[17];
    Tv[418]:= Tv[18] + Tv[19] + Tv[20];
    Tv[419]:= Tv[36];
    Tv[416]:= Tv[44] + Tv[49] + Tv[56] + Tv[62] + Tv[69] + Tv[60] + Tv[80] + Tv[86] + Tv[91] + Tv[96] +
              Tv[266] + Tv[271] + Tv[276] + Tv[281] + Tv[286] + Tv[291] + Tv[296] + Tv[301] + Tv[306] + Tv[311] + Tv[316] + Tv[321] + Tv[326] + Tv[330]; //20251020 Igor

    // 20201017
    i:= 266;
    Repeat
      Tv[416]:= Tv[416] + Tv[i];
      inc(i, 5);
    Until i > 306; // 20201017 i>301; //286;     //20190921
    // ----------------------

    // 20200519
    Tv[413]:= Tv[417] * 2 / 3;
    Tv[414]:= Tv[418] * 3 / 4;

    if (IR = 0) then IR:= 50;

    Tv[415]:= Tv[419] * (1 / (2 * IR)) * 100;
    Tv[420]:= AddColumns(412, 416, 1);
    Tv[421]:= Tv[420];
    Tv[422]:= MaxR(0, Tv[411] - Tv[421]);

    Tv[423]:= Tv[407];
    Tv[424]:= MaxR(0, Vl(FetchElm(RetNo, 'S3', 339))); //202500411
        //MaxR(0, Vl(FetchElm(RetNo, 'S3', 97)));
    Tv[425]:= MinR(Tv[423], Tv[424]);
    Tv[426]:= Tv[408];
    Tv[427]:= MaxR(0, Tv[423] - Tv[426]);
    Tv[428]:= Tv[427];
    Tv[429]:= Tv[422];
    Tv[430]:= MinR(2000,Tv[422]); //2000; //20250412
    Tv[431]:= MinR(MinR(Tv[428], Tv[429]), Tv[430]);
    Tv[432]:= Tv[426] + Tv[431];

    if IsDeceased(RetNo) then
    begin
      i:= 469;
      Repeat
        Tv[i]:= 0;
        inc(i, 5);
      until i > 594; //589; //579; //20211214 //20221204

      Tv[433]:= 0;
      Tv[406]:= 0;
      Tv[434]:= 0;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251008 Igor <<<

Procedure T2205(RetNo: integer; FName: String; FNo: integer); { slip }
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  Begin
    Strings[1] := AppYear;
    Strings[2] := AllTrim(GetFirstName(RetNo)) + ', ' + GetLastName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[4] := AllTrim(GetSpouseFirstName(RetNo)) + ', ' +
      GetSpouseLastName(RetNo);
    Strings[5] := GetSpouseSin(RetNo);

    Tv[6] := ret[RetNo].T4RspSpBox20 + ret[RetNo].T4RspSpBox22 + ret[RetNo]
      .T4RspSpBox26;
    Tv[8] := MaxR(0, Tv[6] + Tv[7]);  //20250407
    Tv[9] := Tv[8];
    Tv[32]:=MaxR(0,Tv[9]-Tv[10]);
    Tv[31]:=Tv[32];

    Tv[12] := MaxR(0, Tv[33] - Tv[11]);
    Tv[13] := Tv[12];
    Tv[14] := Tv[9];

    Tv[15] := MinR(Tv[31], Tv[13]);     //line 10
    Tv[16] := MaxR(0, Tv[14] - Tv[15]);

    { T4rif }
    Tv[17] := ret[RetNo].T4RifSpBox20;
    Tv[18] := ret[RetNo].T4RifSpBox24;
    Tv[20] := MaxR(0, Tv[18] - Tv[19]);
    Tv[21] := Tv[20];
    Tv[22] := Tv[17] + Tv[21];
    Tv[23] := Tv[22];
    //Tv[27] := Tv[26];
    Tv[26] := MaxR(0, Tv[24] - Tv[27]);
    Tv[25]:=Tv[26];

    Tv[28] := ret[RetNo].T4RifSpBox16 + ret[RetNo].T4RifSpBox20;
    Tv[29] := MinR(Tv[23], Tv[25]);
    Tv[30] := MaxR(0, Tv[28] - Tv[29]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure CAREGVR(RetNo: integer; FName: string; FNo: integer);
var
  i, j, k, L, DFNo: integer;
  Sw305: boolean;
Begin
  // 20170510
  if IsMultJurisdiction(RetNo) = False then
    InitPrvConstants(ret[RetNo].Province) // 20110310
  Else
    InitPrvConstants(T2203Prov); // 20110310

  Sw305 := False;
  // 20130510
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[67] := 'CAREPRV';
    For i := 1 to 66 do
    begin
      Strings[i] := '';
      Tv[i] := 0;
    end;
    { bring from DEPEND }
    i := 5; { index to depend elm }
    j := 1; { index to CAREGVR elm }
    k := 141; { index to depend caregiver elm }
    L := 62;
    DFNo := GetFormNo('DEPEND');
    Repeat
      If UpperCase(FetchElmFNo(RetNo, DFNo, k)) = 'Y' then
      begin
        Strings[j] := FetchElmFNo(RetNo, DFNo, i + 1); { Last nm }
        Strings[j + 1] := FetchElmFNo(RetNo, DFNo, i); { First nm }
        Strings[j + 2] := FetchElmFNo(RetNo, DFNo, i + 5); { birthdate }
        Strings[j + 3] := FetchElmFNo(RetNo, DFNo, i + 6); { relationship }
        Tv[j + 4] := Vl(FetchElmFNo(RetNo, DFNo, i + 8)); { ni }
        Strings[j + 5] := FetchElmFNo(RetNo, DFNo, i + 7); { infirmity }
        Strings[j + 6] := FetchElmFNo(RetNo, DFNo, i + 9) { str }
          + ',' + FetchElmFNo(RetNo, DFNo, i + 10) { city }
          + ' ' + FetchElmFNo(RetNo, DFNo, i + 12) { prov }
          + ' ' + FetchElmFNo(RetNo, DFNo, i + 13); { postal }
        { copy % claim }
        Strings[L] := FetchElmFNo(RetNo, DFNo, i + 11);
        inc(j, 12);
        inc(L, 1);
      end;
      inc(i, 15);
      inc(k, 1);
    until (j > 49) or (i > 125);

    i := 0;
    Tv[61] := 0;
    k := 62;
    repeat
      If Strings[1 + i] > '' then // name present
      begin
        Tv[8 + i] := Constant[RY].CaregvrBase;
        Tv[9 + i] := Tv[5 + i];
        Tv[10 + i] := MaxR(0, Tv[8 + i] - Tv[9 + i]);
        If Tv[10 + i] > Constant[RY].MaxCaregvr then
          Tv[10 + i] := Constant[RY].MaxCaregvr * ret[RetNo].PartYear;
        If (Sw305 = False) and (Strings[i + 3] = FetchElm(RetNo, 'S5', 13))
        { birthdate }
          and (UpperCase(Strings[i + 4]) = UpperCase(FetchElm(RetNo, 'S5', 14)))
        then { relationship }
        begin
          Tv[11 + i] := ret[RetNo].Lnn[30425];
          Sw305 := True;
        end;

        Tv[12 + i] := MaxR(0, Tv[10 + i] - Tv[11 + i]);
        If Vl(Strings[k]) > 0 then
          Tv[12 + i] := Tv[12 + i] * Vl(Strings[k]) / 100
        else
          Tv[12 + i] := 0;
        Tv[61] := Tv[61] + Tv[12 + i];
      end
      else
        Tv[12 + i] := 0;
      inc(i, 12);
      inc(k, 1);
    until i > 48; { i starts with 0 }
  end;
  SaveTv(RetNo, FName, FNo);
  // T2203Prov:='';  //20180323
end;

(*
  Procedure CAREPRV(RetNo:integer;FName:string;FNo:integer);
  var i,j,K,L,M,DFNo,FedCareFno: integer; Sw305:boolean;
  Begin
  Sw305:=False;
  //20170509
  if IsMultJurisdiction(RetNo) = false then
  InitPrvConstants(ret[RetNo].Province)  //20110310
  Else
  InitPrvConstants(T2203Prov);  //20110310
  // InitPrvConstants(ret[RetNo].Province);

  LoadTv(RetNo,FName,FNo);
  FedCareFNo:= GetFormNo('CAREGVR');
  {Copy from federal}
  For i:=1 to 61 do StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FedCareFNo,i));
  {Calculate}
  With ret[RetNo].Frm[FNo] do
  begin
  Strings[70]:='CAREGVR';
  Strings[67]:=GetCarePrvHeader(RetNo);
  Tv[68]:=PrvConstant[RY].PrvCaregvrBase;
  Tv[69]:=PrvConstant[RY].PrvCaregvrBase;
  For i:=1 to 61 do begin Strings[i] :='';Tv[i] :=0;end;
  {bring from DEPEND}
  i:=5; {index to depend elm}
  j:=1; {index to CAREGVR elm}
  k:=191; //20180113 //141; {index to depend caregiver elm}
  L := 62;
  M:=263; //indx to Elig dep
  DFNo := GetFormNo('DEPEND');
  Repeat
  //20171128
  If (UpperCase(FetchElmFNo(RetNo,DFNo,k)) = 'Y')  //caregivr claim
  //and (FetchElmFNo(RetNo,DFNo,i+14)<>'Y')  //NOT elig depenant (other than ONT
  and (Vl(FetchElmFNo(RetNo,DFNo,M))>=18)  //age >=18
  then
  begin
  if (Ret[RetNo].Province<>'ON')  //20180113
  {
  if (Ret[RetNo].Province='ON')  //elig or not elig
  Or ((Ret[RetNo].Province<>'ON') and (FetchElmFNo(RetNo,DFNo,i+14)<>'Y')) //not elig dependant
  }
  then
  Begin
  Strings[j] := FetchElmFNo(RetNo,DFNo,i+1); {Last nm}
  Strings[j+1] := FetchElmFNo(RetNo,DFNo,i); {First nm}
  Strings[j+2] := FetchElmFNo(RetNo,DFNo,i+5); {birthdate}
  Strings[j+3] := FetchElmFNo(RetNo,DFNo,i+6); {relationship}
  Tv[j+4] := Vl(FetchElmFNo(RetNo,DFNo,i+8)); {ni}
  Strings[j+5] := FetchElmFNo(RetNo,DFNo,i+7); {infirmity}
  Strings[j+6] := FetchElmFNo(RetNo,DFNo,i+9)  {str}
  +','+FetchElmFNo(RetNo,DFNo,i+10) {city}
  +' '+FetchElmFNo(RetNo,DFNo,i+12)  {prov}
  +' '+FetchElmFNo(RetNo,DFNo,i+13);  {postal}
  {copy % claim}
  Strings[L]  := FetchElmFNo(RetNo,DFNo,i+11);
  end;

  Inc(j,12);
  Inc(L,1);
  Inc(m,1);
  end;
  Inc(i,15);
  Inc(K,1);
  until (j>49) or (i>125);

  i:=0;Tv[61] :=0;k:=62;
  repeat
  If Strings[1+i]>'' then
  begin
  Tv[8+i] := PrvConstant[RY].PrvCaregvrBase;
  Tv[9+i] := Tv[5+i];
  Tv[10+i] := MaxR(0,Tv[8+i]-Tv[9+i]);

  If Tv[10+i]>PrvConstant[RY].PrvMaxCaregvr then
  Tv[10+i] := PrvConstant[RY].PrvMaxCaregvr;

  If (Sw305 = false)
  and (Strings[I+3]= FetchElm(RetNo,'S5PRV',6)) {birthdate}
  and (UpperCase(Strings[I+4])= UpperCase(FetchElm(RetNo,'S5PRV',7))) {relationship}
  then
  begin
  If FullToniProvince(RetNo) then
  Tv[11+i] := Vl(FetchElm(RetNo,GetTax1FormName(RetNo),29));
  Sw305 := True;
  end;
  Tv[12+i] := MaxR(0,Tv[10+i] - Tv[11+i]);
  If (Vl(Strings[k]) >0) and (Vl(Strings[k]) <100) then
  Tv[12+i] := Tv[12+i] * Vl(Strings[k]) /100;

  Tv[61] := Tv[61]+Tv[12+i];
  end
  else
  Tv[12+i] :=0;
  Inc(i,12);
  Inc(k,1);
  until i>48;  {i starts with 0}
  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)
//20250929 Igor >>>
procedure S13(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    if Strings[11].Equals('') then
    begin
      for i:= 1 to 10 do Tv[i]:= 0;
      //20260312
      Ret[RetNo].Lnn[31217]:= 0; //Tv[10]; //jz//20260312 - why Tv[10], just 0 so there is no confusion
      Ret[RetNo].Lnn[42120]:= 0; //jz//20260312 - also should set to zero as otherwise as could cause issues if it has some remnant amount

      Strings[12]:= '';
      //ret[RetNo].Lnn[31217]:= Tv[10];

      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    with Ret[RetNo] do
      if not UpperCase(Strings[12]).Equals('Y') then
        Tv[1]:= Lnn[12200] + Lnn[13500] + Lnn[13700] + Lnn[13900] + Lnn[14100] + Lnn[14300];

    if (Tv[1] < 0) then Tv[1]:= 0; // 20110204

    Tv[4]:= Tv[1] + Tv[2] + Tv[3];

    //Page 2
    Tv[5]:= Constant[RY].MaxUIEarn52;
    Tv[13]:= ret[RetNo].T4UIEarnings;
    Tv[6]:= Tv[13] + Tv[14];
    Tv[7]:= MaxR(0, Tv[5] - Tv[6]);
    Tv[8]:= MinR(Tv[4], Tv[7]);

    //20211
    if not Ret[RetNo].Province.Equals('QC') then
    begin
      Tv[15]:= Tv[8];
      Tv[16]:= Tv[15] * Constant[RY].UIRate;
      Tv[16]:= MinR(Tv[16], Constant[RY].MaxUI52);
      Ret[RetNo].Lnn[31217]:= Tv[16];
      Ret[RetNo].Lnn[42120]:= Tv[16];
      Tv[17]:= 0;
      Tv[10]:= 0;
    end else
    begin
      Tv[17]:= Tv[8];
      Tv[10]:= Tv[17] * Constant[RY].QCUIRate;
      Tv[10]:= MinR(Tv[10],Constant[RY].QCMaxUI52);
      Ret[RetNo].Lnn[31217]:= Tv[10];
      Ret[RetNo].Lnn[42120]:= Tv[10];
      Tv[15]:= 0;
      Tv[16]:= 0;
    end;

    (*20211120
    // 20140216
    Tv[9] := Constant[RY].UIRate * 100; // 20140216
    If ret[RetNo].Province = 'QC' then
      Tv[9] := Constant[RY].QCUIRate * 100;

    Tv[10] := Tv[8] * Tv[9] / 100; // Constant[RY].UIRate *100;


    If ret[RetNo].Province <> 'QC' then
    begin
      If Tv[10] > Constant[RY].MaxUI52 then
        Tv[10] := Constant[RY].MaxUI52;
    end
    Else // qc
    begin
      If Tv[10] > Constant[RY].QCMaxUI52 then
        Tv[10] := Constant[RY].QCMaxUI52; // QCMaxUI52;  //20140614
    end;
    ret[RetNo].Lnn[31217] := Tv[10];
   *)
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor <<<
procedure ACBFrm(RetNo: integer; FName: String; FNo: integer);
Var
  i, ii, iii, iiii, j, jj, k: integer;
  BegUnits, BegAvgCost, BegValue, ExchRate, OriginalAmount: Real;
  TotUnits, TotValue, TotAcb: Real;
  FinalTotUnits, FinalTotAcb: Real;
  TransUnits, TransAmt, TransUnitCost, TransAvgCost, TransAcb,
    TransGainLoss: Real;
  Transaction: String;
  ContFNo: integer;
begin
  FormatSettings.DecimalSeparator := '.'; // 20160119 Igor
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    If Strings[1] = '' then
      Strings[1] := 'N';
    If Tv[5] > 100 then
      Tv[5] := 100;
    If Tv[5] < 0 then
      Tv[5] := 0;
    If Tv[5] + Tv[6] = 0 then
      Tv[5] := 100;
    BegUnits := Vl(Strings[8]);
    BegAvgCost := Vl(Strings[9]);
    BegValue := Vl(FormatFloat('########.##', BegUnits * BegAvgCost));
    Tv[10] := BegValue;
    TotUnits := BegUnits;
    TotValue := BegValue;
    TotAcb := BegValue;

    If Vl(Strings[567]) > 0 then
    begin
      ContFNo := GetFormNo('ACBFRM#' + Strings[567]);
      If ContFNo > 0 then
      begin
        If ret[RetNo].FormHasData[GetFormName(RetNo, ContFNo)] then
        begin // copy from prev form
          For i := 1 to 7 do
            Strings[i] := FetchElmFNo(RetNo, ContFNo, i);
          Strings[11] := FetchElmFNo(RetNo, ContFNo, 11); // notes
          Strings[8] := FetchElmFNo(RetNo, ContFNo, 12); // beg units
          Strings[9] := FetchElmFNo(RetNo, ContFNo, 13); // avg cost
          Strings[10] := FetchElmFNo(RetNo, ContFNo, 14); // beg bal
          Tv[10] := Vl(Strings[10]);
          // init current balance
          Strings[12] := Strings[8];
          Strings[13] := Strings[9];
          Tv[14] := Tv[10];
          StoreElm(RetNo, ContFNo, 568,
            RemoveChar(ExtractFormInst(FName), '#'));
        end;
      end;;
    end;

    i := 17;
    ii := 429;
    iii := 475;
    iiii := 521;
    repeat
      Transaction := UpperCase(Strings[i - 1]);
      If Transaction = '' then
        for j := i + 1 to i + 6 do
        begin
          Strings[j] := '';
          Tv[j] := 0;
          Strings[ii] := '';
          Strings[iii] := '';
          Strings[iiii] := '';
        end;
      OriginalAmount := Vl(Strings[iiii]);
      If IsRealValue(Strings[i]) = False then
        Strings[i] := '';
      If (Transaction > '') and (Strings[iii] = '') then
      begin
        Strings[iii] := 'CAN';
        Strings[ii] := '1.0';
      end;
      If Length(Strings[iii]) > 3 then
        Strings[iii] := LeftStr(Strings[iii], 3); // Jule 5 2008
      If UpperCase(Strings[iii]) = 'CAN' then
        Strings[ii] := '1.0';
      ExchRate := Vl(Strings[ii]);
      If (Transaction = 'BUY') or (Transaction = 'REINVEST DISTR') or
        (Transaction = 'STOCK SPLIT') then
      begin
        If Transaction <> 'STOCK SPLIT' then
          TransUnits := Abs(Vl(Strings[i]))
        else
          TransUnits := Vl(Strings[i]);
        If Transaction = 'STOCK SPLIT' then
        begin
          Strings[i + 1] := '';
          Strings[ii] := '1';
          Strings[iii] := 'CAN';
        end;

        If OriginalAmount <> 0 then
        begin
          If TransUnits > 0 then
            Strings[i + 1] := FormatFloat('######.0000',
              (OriginalAmount / TransUnits) * ExchRate);
        end;
        TransUnitCost := Vl(Strings[i + 1]);
        TransAmt := Vl(FormatFloat('#########.##', TransUnits * TransUnitCost));

        TotUnits := TotUnits + TransUnits;
        TotValue := TotValue + TransAmt;

        If TotUnits > 0 then
          TransAvgCost := Vl(FormatFloat('#######.####', TotValue / TotUnits))
        else
          TransAvgCost := 0;

        Strings[i + 2] := FormatFloat('######0.0000', TransAvgCost);
        Tv[i + 3] := 0;
        Tv[i + 4] := TransAmt;
        Tv[i + 5] := 0;
        Tv[i + 6] := 0;
        TotAcb := TotAcb + Vl(FormatFloat('########.##',
          Vl(FetchElmFNo(RetNo, FNo, i + 4))));
      end; // buy

      If ((Transaction = 'ROC') or (Transaction = 'COST ADJUSTMENT')) then
      begin
        TransAmt := Tv[i + 4];
        TotValue := TotValue + TransAmt;
        if i = 17 then
          TransAvgCost := BegAvgCost // begining
        else
        begin
          If TotUnits > 0 then
            TransAvgCost := Vl(FormatFloat('#######.####', TotValue / TotUnits))
          else
            TransAvgCost := 0;
        end;
        Strings[i] := '';
        Strings[i + 1] := '';
        Strings[i + 2] := FormatFloat('######0.0000', TransAvgCost);
        Tv[i + 3] := 0;
        Tv[i + 5] := 0;
        Tv[i + 6] := 0;
        Strings[ii] := '1';
        Strings[iii] := 'CAN';

        If Vl(FetchElmFNo(RetNo, FNo, i + 6)) > 0 then
          // TotACB:=0 //zero out if roc has cap gain
        else
          TotAcb := TotAcb +
            Vl(FormatFloat('########.##', Vl(FetchElmFNo(RetNo, FNo, i + 4))));

      end; // roc

      If (Transaction = 'SELL') or (Transaction = 'WRITE-OFF') then
      begin
        // cannot sell more than on hand}
        If Abs(MyStrToInt(Strings[i])) > TotUnits then
          Strings[i] := FormatFloat('#######.####', TotUnits);
        If Transaction = 'WRITE-OFF' then
        begin
          Strings[ii] := '1';
          Strings[iii] := 'CAN';
        end;
        If Vl(Strings[i]) > 0 then
          Strings[i] := FormatFloat('#######.####', -Vl((Strings[i])));
        TransUnits := Vl(Strings[i]);
        If OriginalAmount <> 0 then
        begin
          If TransUnits <> 0 then
            Strings[i + 1] := FormatFloat('######.0000',
              Abs(OriginalAmount / TransUnits) * ExchRate);
        end;

        TransUnitCost := Vl(Strings[i + 1]);
        If Transaction = 'WRITE-OFF' then
        begin
          TransUnitCost := 0;
          Strings[i + 1] := '';
        end;
        TotUnits := Vl(FormatFloat('#######.####', TotUnits + TransUnits));
        // units are negative
        // Get avrg cost just before sale
        if i = 17 then
          TransAvgCost := BegAvgCost // begining
        else
          TransAvgCost := Vl(Strings[i - 7]); // previous entry
        TransAmt := Vl(FormatFloat('#########.##', TransUnits * TransAvgCost));
        // negative
        TotValue := TotValue + TransAmt; // leave it in
        Strings[i + 2] := FormatFloat('######0.0000', TransAvgCost);
        Tv[i + 3] := Abs(TransUnits) * TransUnitCost; // proceeds
        If Transaction = 'WRITE-OFF' then
          Tv[i + 3] := 0;
        Tv[i + 4] := Abs(TransAmt); // TransAmount
        Tv[i + 6] := Tv[i + 3] - Tv[i + 4] - Tv[i + 5];

        TotAcb := TotAcb - Vl(FormatFloat('########.##',
          Vl(FetchElmFNo(RetNo, FNo, i + 4))))
      end; // sell
      // update the top
      If Transaction > '' then
      begin
        If TotAcb < 0 then
          TotAcb := 0;
        If TotUnits > 0 then
        begin
          Strings[12] := FormatFloat('#####,###.####', TotUnits);
          Tv[14] := TotAcb;
          Strings[13] := FormatFloat('#####,###.####', TotAcb / TotUnits)
        end
        else
        begin
          Strings[12] := '';
          Strings[13] := FormatFloat('#####,###.####', 0);
          Tv[14] := 0;
        end;
      end;
      inc(i, 9); // i := i+9;
      inc(ii, 1);
      inc(iii, 1);
      inc(iiii, 1);
    until i > 422;
    (*
      //do it again
      //get tot units from form just in case thre are roc causing totutints to be aeroed out
      FinalTotUnits:=GetTotAcbUnits(RetNo,FNo,423);
      FinalTotACB:=GetTotACB(RetNo,FNo,423);
      If FinalTotACB< 0 then FinalTotACB:=0;

      If FinalTotUnits>0 then
      begin
      Strings[12]:= FormatFloat('#####,###.####',FinalTotUnits);
      Strings[13] := FormatFloat('#####,###.####',FinalTotACB/FinalTotUnits);
      Tv[14]:=FinalTotACB;
      end
      else
      begin
      Strings[12]:='';
      Strings[13] :='';
      Tv[14]:=0;
      end;
    *)
  end; { End with }
  SaveTv(RetNo, FName, FNo);

  Calc(RetNo, 'S3ACB#1');
  // Calc(RetNo,'S3ACB#2');
end;

(* for negative
  procedure ACBFrm(RetNo: integer; FName: String;FNo: integer);
  Var I,j:Integer;
  BegUnits,BegAvgCost,BegACB:Real;
  TotUnits,TotACB:Real;
  TransUnits,TransACB,TransUnitCost,TransAvgCost,{TransAcb,}TransGainLoss:Real;
  Transaction:String;
  begin
  DecimalSeparator := '.';
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
  If Strings[1]='' then Strings[1]:='N';

  If Tv[5]>100 then Tv[5]:=100;
  If Tv[5]<0 then Tv[5]:=0;
  If Tv[5]+Tv[6]=0 then Tv[5]:=100;
  BegUnits:=Vl(Strings[8]);
  BegAvgCost:=Vl(Strings[9]);
  BegACB:=BegUnits * BegAvgCost;
  Tv[10]:=BegACB;
  TotUnits:=BegUnits;
  TotACB:=BegACB;

  i:=17;
  repeat
  Transaction:=UpperCase(Strings[i-1]);
  If Transaction='' then
  for j:=i+1 to i+6 do
  begin
  Strings[j]:='';
  Tv[j]:=0;
  end;
  If IsRealValue(Strings[i])=False then Strings[i]:='';
  If (Transaction ='BUY')
  or (Transaction ='REINVEST DISTR')
  or (Transaction ='STOCK SPLIT') then
  begin
  If Transaction <> 'STOCK SPLIT' then
  TransUnits:=Abs(Vl(Strings[i]))
  else
  TransUnits:=Vl(Strings[i]);
  If Transaction ='STOCK SPLIT' then Strings[i+1]:='';
  TransUnitCost:=Vl(Strings[i+1]);
  TransACB:=TransUnits * TransUnitCost;

  TotUnits := TotUnits+TransUnits;
  TotACB := TotACB + TransACB;

  If TotUnits>0 then
  TransAvgCost := TotACB/TotUnits
  else
  TransAvgCost:=0;

  Strings[i+2]:=FormatFloat('######0.0000',TransAvgCost);
  Tv[i+3]:=0;
  Tv[i+4]:=TransACB;
  Tv[i+5]:=0;
  Tv[i+6]:=0;
  end;

  If ((Transaction ='ROC') or (Transaction ='COST ADJUSTMENT')) then
  begin
  TransACB:=Tv[i+4];
  TotACB:=TotACB + TransACB;
  if i=17 then
  TransAvgCost:=BegAvgCost  //begining
  else
  begin
  If TotUnits>0 then
  TransAvgCost:=TotACB / TotUnits
  else
  TransAvgCost:=0;
  end;

  Strings[i]:='';
  Strings[i+1]:='';
  Strings[i+2]:=FormatFloat('######0.0000',TransAvgCost);
  Tv[i+3]:=0;
  Tv[i+5]:=0;
  Tv[i+6]:=0;

  If TotACB<0 then  //NEGATIVE ACB
  begin
  Tv[i+6]:=ABS(TotACB);   //gain
  TotACB:=0;
  TransAvgCost:=0; Strings[i+2]:='';TV[i+2]:=0;
  TotUnits:=0;
  end;
  end;

  If (Transaction='SELL') or (Transaction ='WRITE-OFF') then
  begin
  {cannot sell more than on hand at that moment}
  {
  If Abs(MyStrToInt(strings[I])) > TotUnits then
  Strings[I] := FormatFloat('#######.####',-TotUnits);
  }

  If Abs(MyStrToInt(strings[I])) > GetTotACBUnits(RetNo,FNo,i-1) then //TotUnits then
  Strings[I] := FormatFloat('#######.####',-GetTotACBUnits(RetNo,FNo,i-1)); //-TotUnits);

  If Vl(Strings[i])>0 then
  Strings[i]:=FormatFloat('#######.####',-Vl((Strings[i])));
  TransUnits:=Vl(Strings[i]);
  TransUnitCost:=Vl(Strings[i+1]);
  If Transaction ='WRITE-OFF' then begin TransUnitCost:=0;Strings[i+1]:='';end;
  //Get avrg cost just before sale
  if i=17 then
  TransAvgCost:=BegAvgCost  //begining
  else
  begin
  TransAvgCost:=Vl(Strings[i-7]);  //previous entry was roc with cap gain
  //If TotUnits<GetTotACBUnits(RetNo,FNo,i-1) then TransAvgCost:=TransUnitCost;
  //If TransAvgCost=0 then TransAvgCost:=0;  //TransUnitCost;       //new...
  end;
  TotUnits:= TotUnits + TransUnits;  //units are negative
  TransACB:=TransUnits * TransAvgCost;   //negative
  If TransAvgCost=0 then TransACB:=0;  //TransUnitCost;       //new...
  TotACB:=TotACB+TransACB;
  Strings[i+2]:=FormatFloat('######0.0000',TransAvgCost);
  Tv[i+3]:=Abs(TransUnits) * TransUnitCost; //proceeds
  If Transaction ='WRITE-OFF' then Tv[i+3]:=0;
  Tv[i+4]:=Abs(TransACB);
  Tv[i+6]:=Tv[i+3]-Tv[i+4]-Tv[i+5];
  end;

  {
  Strings[12]:= FormatFloat('#####,###.####',TotUnits);
  Tv[14]:=TotACB;
  If TotUnits>0 then
  Strings[13] := FormatFloat('#####,###.####',TotACB/TotUnits)
  else
  Strings[13] := FormatFloat('#####,###.####',0);
  }
  i := i+9;
  until i > 422;

  //get tot units from form just in case thre are roc causing totutints to be aeroed out
  TotUnits:=GetTotAcbUnits(RetNo,FNo,423);
  TotACB:=GetTotACB(RetNo,FNo,423);
  Strings[12]:= FormatFloat('#####,###.####',TotUnits);
  Tv[14]:=TotACB;
  If TotUnits>0 then
  Strings[13] := FormatFloat('#####,###.####',TotACB/TotUnits)
  else
  Strings[13] := FormatFloat('#####,###.####',0);
  end; {End with}
  SaveTv(RetNo,FName,FNo);

  Calc(RetNo,'S3ACB#1');
  //Calc(RetNo,'S3ACB#2');
  end;
*)

Function GetTotACBUnits(RetNo: integer; FNo: integer; UpTo: integer): Real;
Var
  i: integer;
  TotUnits: Real;
begin
  TotUnits := Vl(FetchElmFNo(RetNo, FNo, 8)); // beg balance
  i := 17;
  repeat
    TotUnits := TotUnits + Vl(FetchElmFNo(RetNo, FNo, i));
    inc(i, 9);
  until (i > 422) or (i > UpTo);
  Result := Vl(FormatFloat('########.####', TotUnits));
end;

Function GetTotACB(RetNo: integer; FNo: integer; UpTo: integer): Real;
Var
  i: integer;
  TotAcb: Real;
begin
  TotAcb := Vl(FetchElmFNo(RetNo, FNo, 10)); // beg balance
  i := 17;
  repeat
    If ((LeftStr(FetchElmFNo(RetNo, FNo, i - 1), 3) = 'ROC') or
      (UpperCase(LeftStr(FetchElmFNo(RetNo, FNo, i - 1), 4)) = 'COST')) then
    begin
      If Vl(FetchElmFNo(RetNo, FNo, i + 6)) > 0 then
        TotAcb := 0 // zero out if roc has cap gain
      else
        TotAcb := TotAcb + Vl(FormatFloat('########.##',
          Vl(FetchElmFNo(RetNo, FNo, i + 4))));
    end
    else // all other transactions that do not have gain/loss
    begin
      If UpperCase(LeftStr(FetchElmFNo(RetNo, FNo, i - 1), 4)) = 'SELL' then
        TotAcb := TotAcb - Vl(FormatFloat('########.##',
          Vl(FetchElmFNo(RetNo, FNo, i + 4))))
      else
        TotAcb := TotAcb + Vl(FormatFloat('########.##',
          Vl(FetchElmFNo(RetNo, FNo, i + 4))));
    end;
    inc(i, 9);
  until (i > 422) or (i > UpTo);
  Result := Vl(FormatFloat('########.##', TotAcb));
end;

procedure PORTFL(RetNo: integer; FName: String; FNo: integer);
Var
  j, i: integer;
  UnitsAtHand, TotPurchUnits: Real;
  TotPurchCost, ValueAtHand, AvgCostAtHand: Real;
  CurrentAvgCost, CurrentUnits: Real;
begin
  exit;
  (*
    LoadTv(RetNo,FName,FNo);
    with ret[RetNo].Frm[Fno] do
    begin
    j:=9;
    TotPurchCost:=0;TotPurchUnits:=0;AvgCostAtHand :=0;
    repeat
    i :=j;
    If IsRealValue(Strings[j-7]) =  false then Strings[j-7]:='';
    Tv[j-5] := Vl(Strings[j-7]) * vl(strings[j-6]);
    ValueAtHand := Tv[j-5];
    UnitsAtHand := vl(strings[j-7]);
    AvgCostAtHand := Tv[j-6];
    repeat
    If IsRealValue(Strings[i])=False then Strings[i]:='';
    If Vl(strings[i]) >=0 then
    begin
    UnitsAtHand := UnitsAtHand+Vl(strings[I]);
    ValueAtHand := ValueAtHand +Tv[i+1];

    TotPurchUnits :=TotPurchUnits+MyStrToInt(strings[I]);
    TotPurchCost:= TotPurchCost+Tv[i+1];
    If TotPurchUnits>0 then
    AvgCostAtHand := TotPurchCost/TotPurchUnits;

    Tv[i+2]:=0;Tv[i+3]:=0;Tv[i+4]:=0;
    end
    else
    begin
    If Abs(MyStrToInt(strings[I])) > UnitsAtHand then {cannot sell more than on hand}
    Strings[I] := FormatFloat('######,###.####',UnitsAtHand);
    UnitsAtHand := UnitsAtHand-Abs(Vl(strings[I]));
    Tv[i+3] := Abs(Vl(Strings[i]) * AvgCostAtHand);
    Tv[i+4] := Tv[i+2] - Tv[i+3];    {gain}
    TotPurchUnits :=UnitsAtHand;  {initialize after each disposal}
    TotPurchCost:= TotPurchUnits * AvgCostAtHand;

    end;

    i := i+6;
    until i > j+42;
    Strings[j-4] := FormatFloat('######,###.####',UnitsAtHand);
    Tv[j-3] := AvgCostAtHand;
    Tv[j-2] := UnitsAtHand * AvgCostAtHand;

    J :=J+55; {next group}
    until j>119;

    end; {End with}
    SaveTv(RetNo,FName,FNo);
  *)
end;

// 20130720
Procedure T1135(RetNo: integer; FName: String; FNo: integer); // 20160202 Igor
Var
  i, j, Elm, ArrayNo: integer;
  BoxesPerRow: integer;
  s: String;
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    With ret[RetNo].Frm[FNo] do
    begin
      Strings[21] := '';
      // If Strings[21]='' then Strings[21]:='CAD';  //20150204
      // 20140507
      if Strings[23] + Strings[24] = '' then // 20180201
      Begin
        If (IsSelfEmployed(RetNo) = False) and
          (FetchElm(RetNo, 'INFO', 36) = '') // both NOT self-employed
        then
        Begin
          Strings[23] := '';
          Strings[24] := 'X';
        end
        Else
        Begin
          Strings[23] := 'X';
          Strings[24] := '';
        end;
      End;

      Strings[1] := 'X';
      // 20180222 remove initial
      s := GetFirstName(RetNo);
      j := Pos(' ', s);
      If j > 0 then
        s := LeftStr(s, j);
      Strings[2] := s; // GetFirstName(RetNo);
      Strings[3] := GetLastName(RetNo);
      Strings[5] := GetSinNo(RetNo);
      // 20150209
      Strings[8] := '';
      Strings[14] := '';;
      // 20150125
      Strings[19] := AppYear + '-' + '01-01';
      Strings[20] := AppYear + '-' + '12-31';
      If IsDeceased(RetNo) then
        Strings[20] := FetchElm(RetNo, 'INFO', 24); // 20160307 //20160505 Igor
      // street
      Strings[15] := AllTrim(GetStreetAddress(RetNo)); // 20160126
      // FetchElm(RetNo,'INFO',6);  //20150207

      // 20160124
      If Strings[60] > '' then
      begin
        Strings[60] := FormatFloat('########0', Round(Vl(Strings[60])));
        If Vl(Strings[60]) = 0 then
          Strings[60] := '0';
      end;
      If Strings[64] > '' then
      Begin
        Strings[64] := FormatFloat('########0', Round(Vl(Strings[64])));
        If Vl(Strings[64]) = 0 then
          Strings[64] := '0';
      end;

      // 20150208
      If FetchElm(RetNo, 'INFO', 68) > '' then
        Strings[15] := FetchElm(RetNo, 'INFO', 6) + ' ' +
          FetchElm(RetNo, 'INFO', 68); // 20171215
      If FetchElm(RetNo, 'INFO', 163) > '' then
        Strings[15] := FetchElm(RetNo, 'INFO', 6) + ' ' + 'RR ' +
          FetchElm(RetNo, 'INFO', 163); // 20140330

      If Strings[28] = '' then
      Begin
        if FetchElmFNo(RetNo,InfoFNo,179)>'' then  //NCA 20220218
          Strings[28]:=LeftStr(FetchElmFNo(RetNo,InfoFNo,179),3)
        Else
          Strings[28] := 'CAN'; // 20150208
      end;

      // A or B
      if (Strings[36] = '') or (Strings[42] > '') then
      begin
        Strings[86] := '';
      end; // 20200208 //strings[34]:='';
      if (Strings[42] > '') then
      begin
        Strings[36] := '';
        Strings[86] := '';
      end; // 20200208  //Strings[34]:='';
      // if (Strings[36]>'') and (strings[34]='') and (Strings[86]='') then begin Strings[34]:='X';Strings[86]:='';end; //20200208
      // if  Strings[86]>'' then Strings[34]:='';//20200208
      // if  Strings[34]>'' then Strings[86]:='';//20200208

      // If Strings[29]='' then Strings[29]:='N';  //20200208  see below
      Strings[17] := FetchElm(RetNo, 'INFO', 10);
      Strings[63] := FetchElm(RetNo, 'INFO', 14);
      Strings[16] := FetchElm(RetNo, 'INFO', 15);
      Strings[18] := AppYear;
      Strings[70] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
      If Strings[72] = '' then
        Strings[72] := '(' + FetchElm(RetNo, 'INFO', 54) + ')' +
          FetchElm(RetNo, 'INFO', 55) + LeftStr(FetchElm(RetNo, 'INFO', 113),6); // 20150207
      // Strings[72]:=
      If Strings[73] = '' then
        Strings[73] := FormatDateTime('yyyy-mm-dd', Now);
      Strings[73] := ReplaceChar(Strings[73], '/', '-'); // 20200603
      { DateToStr(Date); }
      // certification
      If Strings[29] = '' then
        Strings[29] := 'N'; // 20200208 from above  //certification
      If UpperCase(Strings[29]) = 'Y' then // certification
      Begin
        Strings[74] := OptRec.Prp_Name;
        Strings[75] := OptRec.Prp_Street;
        Strings[78] := OptRec.Prp_City;
        Strings[79] := OptRec.Prp_Prov;
        Strings[76] := OptRec.Prp_Postal;
        If Strings[77] = '' then
          Strings[77] := '1' + '(' + OptRec.Prp_Area + ')' + OptRec.Prp_Tel;
        // 20150209
      end
      Else // 20200505
      Begin
        Strings[74] := '';
        Strings[75] := '';
        Strings[78] := '';
        Strings[79] := '';
        Strings[76] := '';
        Strings[77] := '';
      End;

      Tv[69] := Trunc(Tv[69]);
      //20260225 Igor >>>
      ArrayNo := 1;
      BoxesPerRow := 5;
      T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo); // 20160124
      Tv[18]:= 0;
      Tv[31]:= 0;
      Elm:= ArrayNo * 10000 + StrToInt('3');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('4');
      for i := 0 to MaxDynamicElmsPerForm do
      begin
        // If Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))=0 then StoreElmDynamic(RetNo,FNo,elm,FormatFloat('########0',Round(Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))))); //??  20160124
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[18]:= Tv[18] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm:= ArrayNo * 10000 + StrToInt('5');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[31]:= Tv[31] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= Elm + BoxesPerRow;
      end;

      ArrayNo := 2;
      BoxesPerRow := 6;
      // GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
      T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo); // 20160124
      Tv[32] := 0;
      Tv[33] := 0;
      Tv[43] := 0;
      Elm:= ArrayNo * 10000 + StrToInt('3');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('4');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[32]:= Tv[32] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('5');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[33]:= Tv[33] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('6');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[43]:= Tv[43] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      ArrayNo := 3;
      BoxesPerRow := 6;
      T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo);
      Tv[40] := 0;
      Tv[41] := 0;
      Tv[45] := 0;
      Elm:= ArrayNo * 10000 + StrToInt('3');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('4');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[40]:= Tv[40] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('5');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[41]:= Tv[41] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('6');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[45]:= Tv[45] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      ArrayNo := 4;
      BoxesPerRow := 7;
      T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo);// 20160124
      Tv[51] := 0;
      Tv[52] := 0;
      Tv[54] := 0;
      Tv[56] := 0;
      Elm:= ArrayNo * 10000 + StrToInt('3');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('4');
      // for field id 10003 on the first row i form
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[51]:= Tv[51] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('5');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[52]:= Tv[52] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('6');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[54]:= Tv[54] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('7');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[56]:= Tv[56] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      ArrayNo := 5;
      BoxesPerRow := 6;
      // GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
      T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo);
      Tv[61] := 0;
      Tv[62] := 0;
      Tv[68] := 0;
      Elm:= ArrayNo * 10000 + StrToInt('3');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('4');
      // for field id 10003 on the first row i form
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[61]:= Tv[61] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('5');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[62]:= Tv[62] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('6');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[68]:= Tv[68] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      ArrayNo := 6;
      BoxesPerRow := 6;
      T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo);
      Tv[81] := 0;
      Tv[82] := 0;
      Tv[85] := 0;
      Elm:= ArrayNo * 10000 + StrToInt('3');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('4');
      // for field id 10003 on the first row i form
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[81]:= Tv[81] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('5');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[82]:= Tv[82] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('6');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[85]:= Tv[85] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      // 20150103
      ArrayNo := 7;
      BoxesPerRow := 6;
      T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo);
      Tv[37] := 0;
      Tv[38] := 0;
      Tv[44] := 0;
      Elm:= ArrayNo * 10000 + StrToInt('3');
      for i:= 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Elm:= Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('4');
      // for field id 10003 on the first row i form
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[37]:= Tv[37] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('5');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[38]:= Tv[38] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;

      Elm := ArrayNo * 10000 + StrToInt('6');
      For i := 0 to MaxDynamicElmsPerForm do
      begin
        if (Vl(FetchElmFNo(RetNo, FNo, Elm)) <> 0) then StoreElm(RetNo, FNo, Elm, FormatFloat('###', Round(Vl(FetchElmFNo(RetNo, FNo, Elm)))));
        Tv[44]:= Tv[44] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := Elm + BoxesPerRow;
      end;
      //20260225 Igor <<<
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
  Procedure T1135(RetNo:integer;FName:string;FNo:integer);
  var i: integer;
  Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  Strings[1] := 'X';
  Strings[2] := GetFirstName(RetNo);
  Strings[3] := GetLastName(RetNo);
  Strings[5] := GetSinNo(RetNo);
  Strings[15] := FetchElm(RetNo,'INFO',6);
  Strings[17] := FetchElm(RetNo,'INFO',10);
  Strings[63] := FetchElm(RetNo,'INFO',14);
  Strings[16] := FetchElm(RetNo,'INFO',15);
  Strings[18] := AppYear;
  Strings[70] := GetFirstName(RetNo)+' '+GetLastName(RetNo);
  Strings[72] := FetchElm(RetNo,'INFO',54)+ ' '+
  FetchElm(RetNo,'INFO',55);
  If Strings[73] = '' then Strings[73] := FormatDateTime('yyyy-mm-dd',Now);
  {DateToStr(Date);}

  Strings[74] := OptRec.Prp_Name;
  Strings[75] := OptRec.Prp_Street;
  Strings[78] := OptRec.Prp_City;
  Strings[79] := OptRec.Prp_Prov;
  Strings[76] := OptRec.Prp_Postal;
  Strings[77] := OptRec.Prp_Area+' '+OptRec.Prp_Tel;
  Tv[69] := Trunc(Tv[69]);
  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)
Function NisaNIAfterAdj(RetNo, FNo: integer; BusUseOfHome, Percent: Real): Real;
Var
  x: Real;
begin
  x := Vl(FetchElmFNo(RetNo, FNo, 5)) - BusUseOfHome -
    Vl(FetchElmFNo(RetNo, FNo, 33)) + Vl(FetchElmFNo(RetNo, FNo, 9));
  Result := x * Percent / 100 - Vl(FetchElmFNo(RetNo, FNo, 18));
end;

Function CAISNIAfterAdj(RetNo, FNo: integer; BusUseOfHome, Percent: Real): Real;
Var
  x: Real;
begin
  x := Vl(FetchElmFNo(RetNo, FNo, 5)) - BusUseOfHome -
    Vl(FetchElmFNo(RetNo, FNo, 33)) + Vl(FetchElmFNo(RetNo, FNo, 9));
  Result := x * Percent / 100 - Vl(FetchElmFNo(RetNo, FNo, 18));
end;



 //2022 routine
//20210327
Procedure T1175(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
  FInst: String[4];
  Stmt: String;
  RemainingAmount: Real;
  MaxCCA: Real;
  TermLossAmount, RecaptAmount: Real;
  AutoCCAForStmt: Real;
Begin
  If FNo = 0 then
    exit;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  //Clear some CCA table Col7, 10, 12 //20230426
  //for i:=5 to 75 by 10 do begin Tv[i]:=0;end;  //col 7
  for i:=396 to 403 do begin ret[RetNo].Frm[FNo].Tv[i]:=0;end;  //col 10
  for i:=404 to 411 do begin ret[RetNo].Frm[FNo].Tv[i]:=0;end;  //col 12


  ret[RetNo].Frm[FNo].Tv[215] := 0;
  ret[RetNo].Frm[FNo].Tv[216] := 0;  //20210328

   //pg 5 CCA table
  Stmt:='T1163'; //LeftStr(FName,5); //20210328
  with ret[RetNo].Frm[Fno] do
  begin
   If PostCCaFromAssetsB(RetNo) then
   begin
    PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,1,71,10,80,81,82);  //20130408 looks ok
   end
   Else  //20090101
    For i:=1 to 82 do begin Strings[i]:='';Tv[i]:=0;end;

   //column 6 //202010331
   i:=0;
   Repeat
    Tv[i+5]:=Tv[i+2]+Tv[3+i]-Tv[4+i];
    Inc(i,10);
   Until i>70;

   {cca - motor veh}
   //20230428 Igor >>>
   PostAutoCCA(RetNo,FName,Stmt,FInst,FNo,123,124);


    //20230525
    Tv[366]:=0;
    i:=388;
    Repeat
      Tv[366]:=Tv[366]+Tv[i];
      Inc(i,1)
    Until i>395;

    //20230525
    Tv[473]:=0;
    i:=424;
    Repeat
      Tv[473]:=Tv[473]+Tv[i];
      Inc(i,1)
    Until i>427;

   Tv[361]:=Tv[366]+Tv[473];  //20230525 CON

   Tv[362] := Tv[82] + Tv[124]; //20230525 Igor

    //20230428 Igor <<<
    { CCA XVII }
    Tv[147] := 0;
    i := 128;
    Repeat
      Tv[i + 2] := Tv[i] * Tv[i + 1] / 100;
      Tv[147] := Tv[147] + Tv[i + 2];
      i := i + 7;
    until i > 142; //139;  //20230523
    Tv[147] := Tv[147] + Tv[146];
   // Tv[148] := Tv[124] + Tv[147]; // Tv[82] + //20230523
   // Tv[217] := Tv[148];   //20230523

    { home exp };
    // 20200118
    Tv[358] := Tv[156] + Tv[158];
    Tv[359] := Tv[358];
    Tv[159] := AddColumns(149, 154, 1) + Tv[168] + Tv[359]; // 20200118
    Tv[161] := Tv[159] * Tv[160] / 100;
    Tv[162] := MaxR(0, Tv[159] - Tv[161]);
    Tv[170] := Tv[162] + Tv[169];
    If Tv[164] = 0 then
      Tv[164] := 100;
    Tv[165] := Tv[170] * Tv[164] / 100;

    Tv[171] := MaxR(0, Vl(FetchElm(RetNo, 'T1163' + FInst, 605))); // ni
    Tv[166] := Vl(FetchElm(RetNo, 'T1163' + FInst, 628));
    Tv[167] := Vl(FetchElm(RetNo, 'T1163' + FInst, 614));
    Tv[360]:=Tv[170]+Tv[166];   //20220116
    // 20090411
    Tv[172] := Vl(FetchElm(RetNo, 'T1163' + FInst, 614));
  end; { End with }

  with ret[RetNo].Frm[Fno] do
  begin
  //20230521
   FInst := ExtractFormInst(FName);
   Stmt := LeftStr('T1163', 5);
   //20230521  t1175
   PostAutosAdditions(RetNo,FName,Stmt,FInst,FNo,221,226,5,231,233,232);     //20230519
   I := 223; Tv[232] := 0;
   Tv[233]:=0; //not on form
   Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[232] := Tv[232] + Tv[I+2];
       i := i + 5;
    Until i > 228;
    Tv[245] := Tv[244] + Tv[243];

    Stmt := LeftStr('T1163', 5);
    PostAutosDispositions(RetNo,FName,Stmt,FInst,FNo,285,290,5,295,298,296);     //20230522
    I := 287; Tv[296] := 0;
    Tv[298]:=0; //not on form
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[296] := Tv[296] + Tv[I+2];
       i := i + 5;
     Until i > 292;
     Tv[296] := Tv[296]+Tv[295]; //20230523 CON
  end; //with


  //==================
  with ret[RetNo].Frm[Fno] do
  begin
    // Non Build additions
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 201, 216, 5,
          220, 336, 232);
    end;
    i := 203;
    Tv[232] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[232] := Tv[232] + Tv[i + 2];
      inc(i, 5);
    until i > 228;
    Tv[232] := Tv[232] + Tv[336] + Tv[231];

    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 233, 258, 5,
          262, 263, 264);
    end;
    i := 235;
    Tv[264] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[264] := Tv[264] + Tv[i + 2];
      inc(i, 5);
    until i > 260;
    Tv[264] := Tv[264] + Tv[263];

    // equip disp
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 265, 280, 5,
          284, 337, 296); // 20110109
      // If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,265,280,5,234,337,296);
    end;

    //20230525
    Tv[366]:=0;
    i:=388;
    Repeat
      Tv[366]:=Tv[366]+Tv[i];
      Inc(i,1)
    Until i>395;

    //20230525
    Tv[473]:=0;
    i:=424;
    Repeat
      Tv[473]:=Tv[473]+Tv[i];
      Inc(i,1);
    Until i>427;

    i := 267;
    Tv[296] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[296] := Tv[196] + Tv[i + 2];
      inc(i, 5);
    until i > 292;
    Tv[296] := Tv[296] + Tv[337] + Tv[295];

    Tv[366]:=0; for i:=388 to 395 do Tv[366]:=Tv[366]+Tv[i]; //20230426
    // build disp
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 297, 322, 5,
          326, 327, 328);
    end;
    i := 299;
    Tv[328] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[328] := Tv[328] + Tv[i + 2];
      inc(i, 5);
    until i > 324;
    Tv[328] := Tv[328] + Tv[327];

  end;
  SaveTv(RetNo, FName, FNo);
End;


Procedure T1175H(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
  FInst: String[4];
  Stmt: String;
  RemainingAmount: Real;
  MaxCCA: Real;
  TermLossAmount, RecaptAmount: Real;
  AutoCCAForStmt: Real;
Begin
  If FNo = 0 then
    exit;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  //Clear some CCA table Col7, 10, 12 //20230426
  //for i:=5 to 75 by 10 do begin Tv[i]:=0;end;  //col 7
  for i:=396 to 403 do begin ret[RetNo].Frm[FNo].Tv[i]:=0;end;  //col 10
  for i:=404 to 411 do begin ret[RetNo].Frm[FNo].Tv[i]:=0;end;  //col 12


  ret[RetNo].Frm[FNo].Tv[215] := 0;
  ret[RetNo].Frm[FNo].Tv[216] := 0;  //20210328

   //pg 5 CCA table
  Stmt:='T1273'; //LeftStr(FName,5); //20210328
  with ret[RetNo].Frm[Fno] do
  begin
   If PostCCaFromAssetsB(RetNo) then
   begin
    PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,1,71,10,80,81,82);  //20130408 looks ok
   end
   Else  //20090101
    For i:=1 to 82 do begin Strings[i]:='';Tv[i]:=0;end;

   //column 6 //202010331
   i:=0;
   Repeat
    Tv[i+5]:=Tv[i+2]+Tv[3+i]-Tv[4+i];
    Inc(i,10);
   Until i>70;

   {cca - motor veh}
   //20230428 Igor >>>
   PostAutoCCA(RetNo,FName,Stmt,FInst,FNo,123,124);

   //20230525
   Tv[473]:=0;
   i:=424;
   Repeat
     Tv[473]:=Tv[473]+Tv[i];
     Inc(i,1)
   Until i>427;

   Tv[361]:=Tv[366]+Tv[473];  //20230525 CON

   Tv[362] := Tv[82] + Tv[124]; //20230525 Igor

    //20230428 Igor <<<
    { CCA XVII }
    Tv[147] := 0;
    i := 128;
    Repeat
      Tv[i + 2] := Tv[i] * Tv[i + 1] / 100;
      Tv[147] := Tv[147] + Tv[i + 2];
      i := i + 7;
    until i > 142; //139;  //20230523
    Tv[147] := Tv[147] + Tv[146];
   // Tv[148] := Tv[124] + Tv[147]; // Tv[82] + //20230523
   // Tv[217] := Tv[148];   //20230523

    { home exp };
    // 20200118
    Tv[358] := Tv[156] + Tv[158];
    Tv[359] := Tv[358];
    Tv[159] := AddColumns(149, 154, 1) + Tv[168] + Tv[359]; // 20200118
    Tv[161] := Tv[159] * Tv[160] / 100;
    Tv[162] := MaxR(0, Tv[159] - Tv[161]);
    Tv[170] := Tv[162] + Tv[169];
    If Tv[164] = 0 then
      Tv[164] := 100;
    Tv[165] := Tv[170] * Tv[164] / 100;

    Tv[171] := MaxR(0, Vl(FetchElm(RetNo, 'T1163' + FInst, 605))); // ni
    Tv[166] := Vl(FetchElm(RetNo, 'T1163' + FInst, 628));
    Tv[167] := Vl(FetchElm(RetNo, 'T1163' + FInst, 614));
    Tv[360]:=Tv[170]+Tv[166];   //20220116
    // 20090411
    Tv[172] := Vl(FetchElm(RetNo, 'T1273' + FInst, 614));
  end; { End with }

  with ret[RetNo].Frm[Fno] do
  begin
  //20230521
   FInst := ExtractFormInst(FName);
   Stmt := LeftStr('T1163', 5);
   //20230521  t1175
   PostAutosAdditions(RetNo,FName,Stmt,FInst,FNo,221,226,5,231,233,232);     //20230519
   I := 223; Tv[232] := 0;
   Tv[233]:=0; //not on form
   Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[232] := Tv[232] + Tv[I+2];
       i := i + 5;
    Until i > 228;
    Tv[245] := Tv[244] + Tv[243];

    Stmt := LeftStr('T1273', 5);
    PostAutosDispositions(RetNo,FName,Stmt,FInst,FNo,285,290,5,295,298,296);     //20230522
    I := 287; Tv[296] := 0;
    Tv[298]:=0; //not on form
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[296] := Tv[296] + Tv[I+2];
       i := i + 5;
     Until i > 292;
     Tv[296] := Tv[296]+Tv[295]; //20230523 CON
  end; //with


  //==================
  with ret[RetNo].Frm[Fno] do
  begin
    // Non Build additions
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 201, 216, 5,
          220, 336, 232);
    end;
    i := 203;
    Tv[232] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[232] := Tv[232] + Tv[i + 2];
      inc(i, 5);
    until i > 228;
    Tv[232] := Tv[232] + Tv[336] + Tv[231];

    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 233, 258, 5,
          262, 263, 264);
    end;
    i := 235;
    Tv[264] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[264] := Tv[264] + Tv[i + 2];
      inc(i, 5);
    until i > 260;
    Tv[264] := Tv[264] + Tv[263];

    // equip disp
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 265, 280, 5,
          284, 337, 296); // 20110109
      // If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,265,280,5,234,337,296);
    end;
    i := 267;
    Tv[296] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[296] := Tv[196] + Tv[i + 2];
      inc(i, 5);
    until i > 292;
    Tv[296] := Tv[296] + Tv[337] + Tv[295];

    Tv[366]:=0; for i:=388 to 395 do Tv[366]:=Tv[366]+Tv[i]; //20230426
    // build disp
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 297, 322, 5,
          326, 327, 328);
    end;
    //20230525
    Tv[473]:=0;
    i:=424;
    Repeat
      Tv[473]:=Tv[473]+Tv[i];
      Inc(i,1);
    Until i>427;


    i := 299;
    Tv[328] := 0;
    repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[328] := Tv[328] + Tv[i + 2];
      inc(i, 5);
    until i > 324;
    Tv[328] := Tv[328] + Tv[327];

  end;
  SaveTv(RetNo, FName, FNo);
End;

Procedure SNRC(RetNo: integer; FName: string; FNo: integer);
var
  i, j: integer;
  Rate: String;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    If IsSection217(RetNo) = False then
    begin
      For i := 1 to 138 do
      begin
        Tv[i] := 0;
        Frm[FNo].Strings[i] := '';
      end; // 20110124
      for i:=30 to 31 do begin Tv[i]:=0;end; //20240204
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    // If Frm[FNo].Strings[37]+Frm[FNo].Strings[38]='' then Frm[FNo].Strings[38]:='X';

    If Frm[FNo].Strings[17] = '' then
      Frm[FNo].Strings[17] := '25';

    Tv[30]:=Ret[RetNo].LNN[10400];
    Tv[1] := Lnn[11300];
    Tv[2] := Lnn[11400];
    Tv[3] := Lnn[11500];
    Tv[4] := Lnn[12900]; // rrsp payments
    // death benefits
    Tv[6] := TotMultiple(RetNo, 'T4A', 34) + TotMultiple(RetNo, 'T3MULT', 142);
    Tv[7] := Lnn[11900]; // ei benefits

    // retiring allowances
    Tv[8] := TotMultiple(RetNo, 'T4A', 6) + TotMultiple(RetNo, 'T4A', 42); // +
    Tv[10] := TotMultiple(RetNo, 'T4', 31); // Deferred DPSP ?
    Tv[11] := TotMultiple(RetNo, 'T4', 33); // retirement compens arrangement

    Tv[14] := 0;
    i := 1;
    Repeat
      Tv[14] := Tv[14] + Tv[i];
      inc(i);
    until i > 13;
    Tv[14] := Tv[14] + Tv[18]; // 20190209
    Tv[14]:=Tv[14]+Tv[30];  //20250204

    Tv[24]:=Tv[14];
    {
    Tv[15]:=RetNo.LNN[20700]+RetNo.LNN[28005]+RetNo.LNN[23200]
      +RetNo.LNN[25000]+RetNo.LNN[25600];
    }
    Tv[16] := MaxR(0, Tv[14] - Tv[15]);


    Rate := Frm[FNo].Strings[17];

    //20250204
    If (Frm[FNo].Strings[31] = '') and (Tv[30] > 0) then
        Frm[FNo].Strings[31] := Rate;

    Tv[32]:=Tv[30]*Vl(Strings[31])/100;
    i := 1;
    j := 111;
    Tv[138] := 0;
    Repeat
      If (Frm[FNo].Strings[j] = '') and (Tv[i] > 0) then
        Frm[FNo].Strings[j] := Rate; // 20120229
      Tv[j + 1] := Tv[i] * Vl(Frm[FNo].Strings[j]) / 100; // 20120229
      Tv[138] := Tv[138] + Tv[j + 1];
      inc(i, 1);
      inc(j, 2);
    Until i > 13;
    Tv[138]:=Tv[138]+Tv[32];  //20250204

    i := 18;
    j := 19;
    If (Frm[FNo].Strings[j] = '') and (Tv[i] > 0) then
      Frm[FNo].Strings[j] := Rate; // 20120229
    Tv[j + 1] := Tv[i] * Vl(Frm[FNo].Strings[j]) / 100; // 20120229
    Tv[138] := Tv[138] + Tv[j + 1];

    // part 2
    With ret[RetNo] do
    begin
      If (IsSection217(RetNo) = False) or
        (Vl(FetchElm(RetNo, 'T1', 88)) <> Vl(FetchElm(RetNo, 'SNRESA', 18)))
      // (Vl(FetchElm(RetNo,'S1',1)) <> Vl(FetchElm(RetNo,'SNRESA',18)))
      then
      begin
        For i := 101 to 107 do
        begin
          Tv[i] := 0;
          Frm[FNo].Strings[i] := '';
        end;
        SaveTv(RetNo, FName, FNo);
        exit;
      end;

      Tv[101] := Vl(FetchElm(RetNo, 'SNRESA', 18));
      Tv[102] := Lnn[26000];
      Tv[103] := MaxR(0, Tv[101] - Tv[102]);
      Tv[104] := Lnn[41700];
      // 20200215
      Tv[21] := TotMultiple(RetNo, 'T5013', 9);
      Tv[22] := MaxR(0, Tv[104] - Tv[21]);
      //20230123
      Tv[25]:=Lnn[47556]; //fuel
      Tv[26]:=MaxR(0,Tv[22]-Tv[25]);
      Tv[27]:=Lnn[47557];  //air
      Tv[28]:=MaxR(0,Tv[26]-Tv[27]);
      Tv[23]:=Tv[28];
      Tv[29] := Tv[103] * Tv[23];
      //Tv[23] := Tv[22];
      Tv[105] := Tv[101];
      If Tv[105] > 0 then
        Tv[107] := Tv[29] / Tv[105]
      else
        Tv[107] := 0;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T4RSP(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[15] := FetchElm(RetNo, 'INFO', 3);
    Strings[18] := FetchElm(RetNo, 'INFO', 5);
    Strings[19] := FetchElm(RetNo, 'INFO', 2);
    Strings[17] := AppYear;
    If ShowUnconvertedLastYear(RetNo) then
      Strings[17] := GetLastYearTaxYear;
    Strings[22] := 'Jump to T2205';
  end;
end;

procedure T1ADJ(RetNo: integer; FName: String; FNo: integer);
Var
  i, j: integer;
  FInst: String[4];
  s, SnapShotDir, FileNm, ln: String;
  PrevAmount, RevisedAmount: Real;
  BeforeList: TStringList;
  // LnList,AmtList,BeforeList,AfterList,NetList:TStringList;
  LnDescrList: TStringList;
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := UpperCase(AllTrim(GetLastName(RetNo))) + ' ' +
      UpperCase(AllTrim(GetFirstName(RetNo))); // 20150410
    If Strings[2] + Strings[4] = '' then
      Strings[2] := 'X';
    // teleph
    // If Strings[20]='' then Strings[20]:='Y';  //20140128
    If UpperCase(Strings[20]) = 'Y' then
    begin
      Strings[19] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
      Strings[16] := '';
    end
    Else
    Begin
      Strings[16] := FetchElm(RetNo, 'INFO', 54) + ' ' +
        FetchElm(RetNo, 'INFO', 55);
      Strings[19] := FetchElm(RetNo, 'INFO', 71) + ' ' +
        FetchElm(RetNo, 'INFO', 72);
    end;

    If Strings[3] = '' then
    begin
      Strings[17] := '';
      Strings[18] := '';
    end; // 20140128

    If FInst > '#1' then
    begin
      Strings[2] := FetchElm(RetNo, 'T1ADJ#1', 2);
      Strings[4] := FetchElm(RetNo, 'T1ADJ#1', 4);
      Strings[5] := FetchElm(RetNo, 'T1ADJ#1', 5);
      Strings[7] := FetchElm(RetNo, 'T1ADJ#1', 7);
      Strings[9] := FetchElm(RetNo, 'T1ADJ#1', 9);
      Strings[11] := FetchElm(RetNo, 'T1ADJ#1', 11);
      Strings[17] := FetchElm(RetNo, 'T1ADJ#1', 17);
      Strings[18] := FetchElm(RetNo, 'T1ADJ#1', 18);
      Strings[21] := FetchElm(RetNo, 'T1ADJ#1', 21);
    end;
    If Strings[2] > '' then
    begin
      Strings[5] := '';
      Strings[7] := '';
      Strings[9] := '';
      Strings[11] := '';
    end;
    If Strings[13] = '' then
      Strings[13] := AppYear;

    // 20140128
    If UpperCase(Strings[20]) = 'Y' then
    begin
      Strings[3] := OptRec.Prp_Name;
      Strings[6] := OptRec.Prp_Street;
      Strings[8] := OptRec.Prp_City;
      Strings[10] := OptRec.Prp_Prov;
      Strings[12] := OptRec.Prp_Postal;
    end;


    Strings[14] := FetchElm(RetNo, 'INFO', 3);
    If Strings[15] = '' then
      Strings[15] := DateToMonthDayYear(Date);

    // Revised amounts only
    If UpperCase(Strings[21]) = 'Y' then
    begin
      // Get pre-adj values
      If fileExists(GetSnapShotFileName(RetNo)) then
      Begin
        BeforeList := TStringList.Create;
        BeforeList.LoadFromFile(GetSnapShotFileName(RetNo));
        i := 25;
        Repeat
          Tv[i] := 0;
          If AllTrim(Strings[i - 2]) > '' then
            Tv[i] := GetPreAdjValue(RetNo, AllTrim(Strings[i - 2]), BeforeList);
          i := i + 5;
        until i > 110;
        BeforeList.Free;
      end; // file exists
    end; // manual Y

    // get descriptions
    LnDescrList := TStringList.Create;
    LnDescrList.LoadFromFile(AppDir + '\' + 'T1Tls.d');
    i := 23;
    repeat
      If (Strings[i] > '') and (Strings[i + 1] = '') then
        Strings[i + 1] := GetLineDescription(MyStrToInt(Strings[i]),
          LnDescrList);
      Tv[i + 3] := Tv[i + 4] - Tv[i + 2];
      Strings[i] := LeftStr(Strings[i], 5); //LeftStr(Strings[i], 4); //20250516
      Strings[i] := RemoveChar(Strings[i], '*');
      inc(i, 5);
    until i > 108;
    LnDescrList.Free;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Function GetKSRuleAmount(RetNo: integer; sRule: String): Real;
Var
  LAmount: Real;
  LSAmount: String;
  FNo: integer;
  Rule: integer;
begin
  Rule := MyStrToInt(AllTrim(MidStr(sRule, 2, 5)));
  Result := DoRules(RetNo, Rule); { RETURNS LAMOUNT }
end;

Function BlankIfZero(x: Real): String;
begin
  Result := FloatToStr(x);
  If Result = '0' then
    Result := '';
end;

Function Get6153(RetNo: integer): Real;
Var
  Prv: String;
begin
  Result := 0;
  Prv := ret[RetNo].Province;
  If Prv = 'ON' then
    Result := Vl(FetchElm(RetNo, 'ON428', 138))
  else If Prv = 'AB' then
    Result := Vl(FetchElm(RetNo, 'AB428', 105))
  else If Prv = 'BC' then
    Result := Vl(FetchElm(RetNo, 'BC428', 140))
  else If Prv = 'MB' then
    Result := Vl(FetchElm(RetNo, 'MB428', 62))
  else If Prv = 'NL' then
    Result := Vl(FetchElm(RetNo, 'NL428', 116))
  else If Prv = 'NB' then
    Result := Vl(FetchElm(RetNo, 'NB428', 38))
  else If Prv = 'NS' then
    Result := Vl(FetchElm(RetNo, 'NS428', 138))
  else If Prv = 'NT' then
    Result := Vl(FetchElm(RetNo, 'NT428', 110))
  else If Prv = 'NU' then
    Result := Vl(FetchElm(RetNo, 'NU428', 110))
  else If Prv = 'PE' then
    Result := Vl(FetchElm(RetNo, 'PE428', 117))
  else If Prv = 'SK' then
    Result := Vl(FetchElm(RetNo, 'SK428', 111))
  else If Prv = 'YT' then
    Result := Vl(FetchElm(RetNo, 'YT428', 38));
end;

Procedure T1275(RetNo: integer; FName: string; FNo: integer);
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    //
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1273(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  FInst: String[4];
  AFNo: integer;
  x: Real;
  TermLossAmount, RecaptAmount, AutoCCAForStmt, CCAForStmt: Real;
  NormalLoss, AllowedLoss, RestrictedLoss: Real;
  MIA, OIA: Real;

Begin
  RestrictedLoss := 0;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin

    // section 1 participant
    If Strings[1] = '' then
      Strings[1] := FetchElm(RetNo, 'INFO', 54);
    If Strings[2] = '' then
      Strings[2] := FetchElm(RetNo, 'INFO', 55);
    Strings[5] := GetFirstName(RetNo);
    Strings[6] := GetLastName(RetNo);
    // 20130224
    If Length(OptRec.Bus_Disclm) > 0 then
      Strings[8] := OptRec.Bus_Disclm
    else
      Strings[8] := '';

    // 20110320
    If Strings[64] = '' then
    begin
      Strings[50] := '';
      Strings[51] := '';
      For i := 10 to 19 do
        Strings[i] := '';
      Strings[65] := '';
    end;
    // If Strings[66]+Strings[67]+Strings[68] = '' then strings[68] := 'X';
    If Strings[69] + Strings[70] = '' then
      Strings[69] := 'X';
    If Strings[70] > '' then
    begin
      If Strings[71] + Strings[72] = '' then
        Strings[72] := 'X';
    end
    else
    begin
      Strings[71] := '';
      Strings[72] := '';
    end;

    // Contact
    If UpperCase(Strings[63]) = 'Y' then
    begin
      Strings[10] := OptRec.Prp_FirstName;
      Strings[11] := OptRec.Prp_LastName;
      Strings[12] := OptRec.Prp_Street;
      Strings[13] := OptRec.Prp_City;
      Strings[14] := OptRec.Prp_Prov;
      Strings[15] := OptRec.Prp_Postal;
      Strings[16] := OptRec.Prp_Area;
      Strings[17] := OptRec.Prp_Tel;
      Strings[18] := OptRec.Prp_FxArea;
      Strings[19] := OptRec.Prp_Fax;
    end;
    // 20130312
    If Length(Strings[16]) > 3 then
      Strings[16] := LeftStr(Strings[16], 3);
    If Length(Strings[18]) > 3 then
      Strings[18] := LeftStr(Strings[18], 3);
    // section 2
    Strings[7] := GetSinNo(RetNo);
    If Strings[33] = '' then
      Strings[33] := '1';
    If Strings[34] = '' then
      Strings[34] := '115110';
    If Strings[35] + Strings[36] = '' then
      Strings[36] := 'X';
    If Strings[32] = '' then
      Strings[32] := ret[RetNo].Province;

    // If Strings[24]+Strings[23] = '' then strings[23] := 'X';  //20090312
    // 20090312
    If Strings[26] + Strings[25] = '' then
      Strings[25] := 'X';
    Strings[28] := AddLeadingZeros(Strings[28], 3);
    If Strings[28] = '000' then
      Strings[28] := '';
    If Strings[40] + Strings[39] = '' then
      Strings[39] := 'X';
    If Strings[41] = '' then
    begin
      Strings[56] := '';
      Strings[55] := '';
    end;
    If Strings[52] = '' then
    begin
      Strings[58] := '';
      Strings[57] := '';
    end;
    If Strings[53] = '' then
    begin
      Strings[60] := '';
      Strings[59] := '';
    end;
    If Strings[54] = '' then
    begin
      Strings[62] := '';
      Strings[61] := '';
    end;
    If Length(Strings[46]) > 50 then
      Strings[46] := LeftStr(Strings[46], 50);
  end;

  // pg 2
  // With ret[RetNo].Frm[Fno] do
  // begin
  ret[RetNo].Frm[FNo].Strings[101] := FetchElm(RetNo, 'T1273' + FInst, 20);
  // 20120115
  If MidStr(FInst, 2, 2) = '1' then
    ret[RetNo].Frm[FNo].Strings[102] := AppYear + ' Statement A'
  else
    ret[RetNo].Frm[FNo].Strings[102] := AppYear + ' Statement B';
  ret[RetNo].Frm[FNo].Strings[103] := MidStr(FInst, 2, 2);
  ret[RetNo].Frm[FNo].Strings[104] := IntToStr(CountT1273(RetNo));
  // end;

  // pg 3
  x := 0;
  With ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[353] := AppYear + ' Statement A'
    else
      Strings[353] := AppYear + ' Statement B';
    Strings[354] := MidStr(FInst, 2, 2);
    Strings[358] := IntToStr(CountT1273(RetNo));
    If Strings[201] = '' then
      Strings[201] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    Strings[202] := Strings[20]; // FetchElm(RetNo,'T1273'+FInst,20);
    // 20170215
    // If Strings[204]='' then Strings[204]:=FetchElm(RetNo,'INFO',6);
    // If Strings[205]='' then Strings[205]:=FetchElm(RetNo,'INFO',10)+','+FetchElm(RetNo,'INFO',14);
    // If Strings[206]='' then Strings[206]:=FetchElm(RetNo,'INFO',15);

    If Strings[207] + Strings[208] = '' then
      Strings[207] := 'X';
    If AllTrim(Strings[212]) = '' then
      Strings[212] := '2';
    If Strings[213] = '' then
      Strings[213] := AppYear + '-01-01';
    If Strings[214] = '' then
      Strings[214] := AppYear + '-12-31';
    If Strings[210] = '' then
      Strings[210] := '100.0000';
    If Vl(Strings[210]) > 100 then
      Strings[210] := '100.0000';
    Strings[210] := FormatFloat('##0.0000', Vl(Strings[210]));
    Tv[210] := Vl(Strings[210]);
    If Strings[211] = '' then
      Strings[211] := 'N'; { restr farm loss }
    i := 220;
    Repeat
      Tv[i] := Round(Tv[i]); // 20120130
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      inc(i, 3);
    until i > 304;

    // Feb 24 2008
    // recapt
    ExtractCCA(RetNo, 'T1273', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    Tv[356] := RecaptAmount;
    ExtractAutos(RetNo, 'T1273', FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    Tv[356] := Tv[356] + RecaptAmount;
    For i := 306 to 318 do
      Tv[i] := Round(Tv[i]); // 20120130
    Tv[309] := Tv[355] + Tv[356];
    Tv[305] := AddColumns(220, 304, 3);
    x := AddColumns(321, 348, 3)+Tv[137]; //20220424;
    Tv[318] := x;
    Tv[349] := AddColumns(306, 318, 1);
    Tv[350] := Tv[305];
    Tv[351] := Tv[349];
    Tv[352] := Tv[350] + Tv[351];
  end;
  ret[RetNo].Frm[FNo].Strings[402] := '575'; // point of sale adj //20101204
  // pg 4
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[474] := FetchElm(RetNo, 'T1273' + FInst, 20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[595] := AppYear + ' Statement A'
    else
      Strings[595] := AppYear + ' Statement B';
    Strings[591] := MidStr(FInst, 2, 2);
    Strings[592] := IntToStr(CountT1273(RetNo));

    // get autoexpenses
    ExtractAutos(RetNo, 'T1273', FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    Tv[527] := 0;
    For i := 0 to ExtractedAutoList.count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];
      Tv[527] := Tv[527] + ExtractedAutoRec.ExpensesClaimed;
    end;

    // CCA
    ExtractCCA(RetNo, 'T1273', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    Tv[537] := CCAForStmt;
    ExtractAutos(RetNo, 'T1273', FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    Tv[537] := Tv[537] + AutoCCAForStmt;

    Strings[401] := 'Point of sale adjustments';
    Strings[402] := '575';
    i := 403;
    Repeat
      Tv[i] := Round(Tv[i]); // 20120130
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      inc(i, 3);
    until i > 457;
    Tv[458] := AddColumns(403, 457, 3);

    i := 459; // 20120130
    Repeat
      Tv[i] := Round(Tv[i]);
      inc(i);
    until i > 470;
    i := 478;
    Repeat
      Tv[i] := Round(Tv[i]);
      inc(i);
    until i > 511;
    i := 413;
    Repeat
      Tv[i] := Round(Tv[i]);
      inc(i);
    until i > 539;
    Tv[586] := Round(Tv[586]);
    Tv[512] := AddColumns(459, 470, 1) + Tv[473] + AddColumns(478, 511, 3);
    Tv[586] := AddColumns(542, 584, 3);

    Tv[585] := AddColumns(513, 535, 1) + AddColumns(537, 539, 1) + Tv[586];
    // exclude 536 cec //20171119
    // Tv[585]:=AddColumns(513,539,1)+Tv[586]; //539 to 398?? //20111107

    Tv[587] := Tv[458];
    Tv[588] := Tv[512];
    Tv[589] := Tv[585];
    Tv[590] := Tv[587] + Tv[588] + Tv[589];
  end;

  // pg 5
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[619] := Strings[20]; // FetchElm(RetNo,'T1273'+FInst,20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[617] := AppYear + ' Statement A'
    else
      Strings[617] := AppYear + ' Statement B';
    Strings[604] := MidStr(FInst, 2, 2);
    Strings[620] := Strings[104];
    // FetchElm(RetNo,'T1273'+Finst,104);//IntToStr(CountT1273(RetNo));

    Strings[658] := 'Double click for MIA Worksheet';
    Tv[601] := Tv[352]; // Vl(FetchElm(RetNo,'T1273'+FInst,352));
    Tv[602] := Tv[590]; // Vl(FetchElm(RetNo,'T1273'+FInst,590));

    Tv[603] := Tv[601] - Tv[602];
    // 20090411
    Tv[621] := Vl(FetchElm(RetNo, 'T1175H' + FInst, 165));
    Tv[606] := Tv[621] + Tv[622];
    // 20200116
    // Tv[605] := Tv[603]; //+Tv[4];
    Tv[607] := Tv[603] - Tv[606];
    If UpperCase(Strings[657]) = 'Y' then
    begin
      GetMIAAmount(RetNo, FName, MIA, OIA);
      Tv[608] := OIA;
      Tv[610] := MIA;
    end;

    Tv[612] := Tv[608] + Tv[610];
    Tv[609] := Tv[612];
    Tv[611] := Tv[607] + Tv[609];
    { partnsh info }
    Strings[625] := GetFirstName(RetNo);
    Strings[626] := GetLastName(RetNo);
    Strings[629] := Strings[20]; // FetchElm(RetNo,'T1273'+FInst,20);
    // Tv[627] := Tv[210]; //Vl(FetchElm(RetNo,'T1273'+FInst,210));  //20120222
    Strings[627] := Strings[210]; // 20120222
    // If Tv[627]=100 then Strings[629]:='';  //20120222

    If Vl(Strings[632]) = 0 then
    begin
      Strings[630] := '';
      Strings[631] := '';
      Strings[634] := '';
    end
    else
    begin
      Strings[630] := GetSpouseFirstName(RetNo);
      Strings[631] := GetSpouseLastName(RetNo);
    end;

    Tv[615] := Tv[611] * Vl(FetchElm(RetNo, 'T1273' + FInst, 210)) / 100;
    //20220116
    Tv[153]:=Tv[615]+Tv[152];  //20220116
    Tv[613] := Tv[611];
    If Vl(FetchElm(RetNo, 'T1273' + FInst,210))<100 Then
      Tv[613]:=Tv[153];

    {
    Tv[615] := Tv[611] * Tv[210] / 100;
    Tv[153]:=Tv[615]+Tv[152];  //20220116
    Tv[613] := Tv[615];
    }

    {//20220116
    If Strings[618] <> 'Y' then
    begin
      If Strings[207] = 'X' then
      begin
        If Tv[613] < 0 then
          Tv[614] := MinR(Abs(Tv[613]), Tv[621])
        else
          Tv[614] := 0;
      end
      else
        Tv[614] := 0;
    end;
    }
    // 20101204
    Tv[967] := Tv[613] + Tv[614];
    Tv[655] := Tv[967] + Tv[966];
    If (UpperCase(Strings[211]) = 'Y') and (Tv[655] < 0) then
    { restricted farm loss }
    begin
      NormalLoss := Abs(Tv[655]);
      If NormalLoss > 32500 then
        AllowedLoss := 17500
        // If NormalLoss>15000 then AllowedLoss := 8750
      else
        AllowedLoss := MinR(NormalLoss,
          2500 + MaxR(0, (NormalLoss - 2500) / 2));

      RestrictedLoss := NormalLoss - AllowedLoss;
      Tv[656] := RestrictedLoss;
      Tv[616] := Tv[655] - (-RestrictedLoss);
    end
    else
    begin
      RestrictedLoss := 0;
      Tv[656] := 0;
      Tv[616] := Tv[655];
    end;
    Tv[620] := SpouseIncome(RetNo);

    i := 627; // 20111208
    Repeat
      Strings[i] := FormatFloat('##0.0000', Vl(Strings[i]));
      Tv[i] := Vl(Strings[i]);
      If Tv[i] = 0 then
        Strings[i] := '';
      inc(i, 5);
    until i > 652;
    // Tv[659]:=Tv[627]+Tv[632]+Tv[637]+Tv[642]+Tv[647]+Tv[652];  //20110402  +Tv[657];
    Strings[659] := FormatFloat('####.0000', Tv[627] + Tv[632] + Tv[637] +
      Tv[642] + Tv[647] + Tv[652]); // 20120222 //20110402  +Tv[657];
  end;

  // pg 6
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[701] := Strings[20]; // FetchElm(RetNo,'T1273'+FInst,20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[702] := AppYear + ' Statement A'
    else
      Strings[702] := AppYear + ' Statement B';
    Strings[703] := MidStr(FInst, 2, 2);
    Strings[704] := Strings[104]; // FetchElm(RetNo,'T1273'+Finst,104);
  end;

  // pg 7
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[801] := Strings[20]; // FetchElm(RetNo,'T1273'+FInst,20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[802] := AppYear + ' Statement A'
    else
      Strings[802] := AppYear + ' Statement B';
    Strings[803] := MidStr(FInst, 2, 2);
    Strings[804] := Strings[104]; // FetchElm(RetNo,'T1273'+Finst,104);
    If Strings[805] + Strings[806] = '' then
      Strings[806] := 'X';
    If Strings[950] + Strings[951] = '' then
      Strings[951] := 'X';
    If FetchElm(RetNo, 'T1273A1#1', 7) > '' then
      Strings[962] := 'See supplementary sheet'
    else
      Strings[962] := '';

    If FetchElm(RetNo, 'T1273A1#1', 859) > '' then
      Strings[963] := 'See supplementary sheet'
    else
      Strings[963] := '';

    i := 809;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      inc(i, 4);
    until i > 857;

    i := 862;
    Repeat
      Strings[i - 1] := LeftStr(Strings[i - 1], 2);
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Not RealNumeric(Strings[i + 1]) then
        Strings[i + 1] := '';
      If Strings[i + 1] > '' then
        Strings[i + 1] := FormatT1273Decimals(Strings[i + 1]);
      If Not RealNumeric(Strings[i + 2]) then
        Strings[i + 2] := '';
      If Strings[i + 2] > '' then
        Strings[i + 2] := FormatT1273Decimals(Strings[i + 2]);

      inc(i, 7);
    until i > 946;

    // 20160201
    i := 76;
    Repeat
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      inc(i, 1);
    until i > 88;

    // unfarmable
    // For i:=959 to 961 do
    begin
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Vl(Strings[i]) = 0 then
        Strings[i] := '';
    end;
  end;

  // pg 8
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[1029] := '4020'; // 20151226  //20130119  //20140404
    Strings[1030] := 'Expected grains and oilseeds pool payments'; // 20180110

    Strings[1001] := FetchElm(RetNo, 'T1273' + FInst, 20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[1002] := AppYear + ' Statement A'
    else
      Strings[1002] := AppYear + ' Statement B';
    Strings[1003] := MidStr(FInst, 2, 2);
    Strings[1004] := Strings[104]; // FetchElm(RetNo,'T1273'+Finst,104);

    If ret[RetNo].FormHasData['T1273A2#1'] then
      Strings[1112] := 'Continued on supplementary sheet at the end of the form'
    else
      Strings[1112] := '';

    For i := 1077 to 1111 do
    begin
      If (Strings[i] > '') then
        Strings[1113] := '';
    end;

    (*
      //20120123
      i:=1007;
      Repeat
      Tv[i]:=vl(AllTrim(NoDecimal(Strings[i])));
      Inc(i,3);
      until i>1028;
    *)
    (*
      i:=1031;
      Repeat
      Tv[i]:=vl(NoDecimalFormatAmount(Strings[i]));
      Inc(i,3);
      until i>1052;

      i:=1055;
      Repeat
      Tv[i]:=vl(NoDecimalFormatAmount(Strings[i]));
      Inc(i,3);
      until i>1076;
      // -------------------
    *)
    i := 1077;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      inc(i, 1);
    until i > 1091;

    If Strings[1113] > '' then
    begin
      For i := 1077 to 1111 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
    end;

    i := 1095;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      inc(i, 4);
    until i > 1111;

    // for i:=1 to 1240 do Tv[i]:=Trunc(Tv[i]);  //20120123 it does not work

    // 20160201
    For i := 162 to 174 do // 20151226 For i:=158 to 161 do
    begin
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
    end;

  end;

  SaveTv(RetNo, FName, FNo);
end;

Procedure T1273A1(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  x: Real;
  FInst: String[4];
Begin
  FormatSettings.DecimalSeparator := '.'; // 20160119 Igor
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := FetchElm(RetNo, 'T1273' + FInst, 20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[2] := AppYear + ' Statement A'
    else
      Strings[2] := AppYear + ' Statement B';
    Strings[3] := MidStr(FInst, 2, 2);
    Strings[4] := FetchElm(RetNo, 'T1273' + FInst, 104);
    // 20130119
    If ret[RetNo].FormHasData['T1273#2'] = False then
    begin
      Strings[1] := FetchElm(RetNo, 'T1273#1', 20);
      Strings[2] := AppYear + ' Statement A';
      Strings[3] := '1';
      Strings[4] := '1';
    end;

    i := 9;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      inc(i, 4);
    until i > 57;

    i := 62;
    Repeat
      Strings[i - 1] := LeftStr(Strings[i - 1], 2);
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Not RealNumeric(Strings[i + 1]) then
        Strings[i + 1] := '';
      If Strings[i + 1] > '' then
        Strings[i + 1] := FormatT1273Decimals(Strings[i + 1]);
      If Not RealNumeric(Strings[i + 2]) then
        Strings[i + 2] := '';
      If Strings[i + 2] > '' then
        Strings[i + 2] := FormatT1273Decimals(Strings[i + 2]);
      inc(i, 7);
    until i > 146;

    // unfarmable
    For i := 159 to 161 do // 20151226 For i:=158 to 161 do
    begin
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Vl(Strings[i]) = 0 then
        Strings[i] := '';
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1273A2(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  x: Real;
  FInst: String[4];
Begin
  FormatSettings.DecimalSeparator := '.'; // 20160119 Igor
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := FetchElm(RetNo, 'T1273' + FInst, 20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[2] := AppYear + ' Statement A'
    else
      Strings[2] := AppYear + ' Statement B';
    Strings[3] := MidStr(FInst, 2, 2);
    Strings[4] := FetchElm(RetNo, 'T1273' + FInst, 104);

    i := 95;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      inc(i, 4);
    until i > 111;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1273ALI(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  x: Real;
  FInst: String[4];
Begin
  FormatSettings.DecimalSeparator := '.'; // 20160119 Igor
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If Strings[3] = '' then
      Strings[3] := '1'; // MidStr(Finst,2,2);
    If Strings[3] = '1' then
      Strings[2] := AppYear + ' Statement A'
    else
      Strings[2] := AppYear + ' Statement B';
    i := 8;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      inc(i, 4);
    until i > 132;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1273OTH(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  x: Real;
  FInst: String[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If Strings[3] = '' then
      Strings[3] := '1'; // MidStr(Finst,2,2);
    If Strings[3] = '1' then
      Strings[2] := AppYear + ' Statement A'
    else
      Strings[2] := AppYear + ' Statement B';
    // If Strings[3]='' then Strings[3]:=MidStr(Finst,2,2);
    i := 5;
    Repeat
      Strings[i] := LeftStr(Strings[i], 4);
      Tv[i + 2] := Round(Tv[i + 2]);
      Tv[i + 3] := Round(Tv[i + 3]);
      inc(i, 4);
    until i > 45;

    i := 54;
    Repeat
      Strings[i] := LeftStr(Strings[i], 4);
      Tv[i + 2] := Round(Tv[i + 2]);
      Tv[i + 3] := Round(Tv[i + 3]);
      inc(i, 4);
    until i > 86;

    i := 95;
    Repeat
      Strings[i] := LeftStr(Strings[i], 4);
      Tv[i + 2] := Round(Tv[i + 2]);
      Tv[i + 3] := Round(Tv[i + 3]);
      inc(i, 4);
    until i > 127;

    Tv[51] := AddColumns(7, 47, 4) + Tv[49];
    Tv[52] := AddColumns(8, 48, 4) + Tv[50];
    Tv[53] := Tv[52] - Tv[51];

    Tv[92] := AddColumns(56, 88, 4) + Tv[90];
    Tv[93] := AddColumns(57, 89, 4) + Tv[91];
    Tv[94] := Tv[93] - Tv[92];

    Tv[133] := AddColumns(97, 129, 4) + Tv[131];
    Tv[134] := AddColumns(98, 130, 4) + Tv[132];
    Tv[135] := Tv[133] - Tv[134];
  end;
  SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor >>>
procedure S12(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j: Integer;
  x1, x2: Real;
  FInst: string;
begin
  Finst:=ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);

  with ret[RetNo].Frm[FNo] do
  begin
    // Strings[172]:='Y';
    if (Ret[RetNo].MarStatus > 2) then
    begin
      if (Tv[171] = 0) then Tv[171]:= 100;

      Tv[172]:= 0;
      // If Strings[172]>'' then Strings[172]:='N';
    end;

    if (Tv[171] > 100) then Tv[171]:= 100;
    if (Tv[171] + Tv[172] > 100) then Tv[172]:= 0;
    if (Ret[RetNo].MarStatus < 3) then Tv[172]:= 100 - Tv[171];

    // ditto handling
    i:= 7;
    repeat
      if IsDitto(Strings[i]) then Strings[i]:= Strings[i - 5];
      if IsDitto(Strings[succ(i)]) then Strings[succ(i)]:= Strings[i + 1 - 5];

      inc(i, 5);
    until (i > 157);

    Tv[161]:= 0;
    i:= 5;
    repeat
      Tv[161]:= Tv[161] + Tv[i];

      inc(i, 5);
    until (i > 160);

    // Tv[162]:=TotMultiple(RetNo,'S12SUP',161);  //20161127
    Tv[161]:= Tv[161] + Tv[162]; // *(100 - Tv[171] / 100);
    Tv[161]:= Tv[161] * (Tv[171]) / 100;
    Tv[164]:= MinR(50000, Tv[161] - Tv[163]);
    Tv[165]:= 50000;
    Tv[167]:= MaxR(0, Tv[165] - Tv[166]);
    Tv[168]:= MinR(Tv[164], Tv[167]);
   //step 2
    Tv[169]:= TV[168]; //TotMultiple(RetNo,'S12',168); //toall instances
    Tv[170]:= MinR(7250, Tv[169] * 0.145);
  end;

  SaveTv(RetNo, FName, FNo);
  {//20231209
  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 64, FormatFloat('###.##', ret[RetNo].Frm[FNo].Tv[171]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 65,
      FormatFloat('###.##', 100 - ret[RetNo].Frm[FNo].Tv[171]));
  end;}
end;
//20250929 Igor <<<

Procedure S12BC(RetNo: integer; FName: string; FNo: integer);
var
  i, j: integer;
  x1, x2: Real;
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
    If Tv[171] + Tv[172] > 100 then
      Tv[172] := 0;
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
      inc(i, 5);
    until i > 160;
    Tv[162] := TotMultiple(RetNo, 'S12SUP', 161);
    Tv[161] := Tv[161] + Tv[162];
    // Tv[164]:=Tv[162]+Tv[163];
    // Tv[165]:=Tv[164];
    Tv[166] := MinR(10000, MaxR(0, Tv[161] - Tv[165]));
    // Tv[167]:=1000;
    // Tv[168]:=MaxR(0,Tv[166]-Tv[167]);
    Tv[167] := Tv[166] * (MaxR(0, (100 - Tv[171]) / 100));
    Tv[170] := MaxR(0, Tv[166] - Tv[167]);
  end;
  SaveTv(RetNo, FName, FNo);

  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 64, FormatFloat('###.##', ret[RetNo].Frm[FNo].Tv[171]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 65,
      FormatFloat('###.##', 100 - ret[RetNo].Frm[FNo].Tv[171]));
  end;

end;

(*Procedure S12SK(RetNo: integer; FName: string; FNo: integer); //20220225
var
  i, j: integer;
  x1, x2: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
    If ret[RetNo].MarStatus > 2 then
    begin
      If Tv[171] = 0 then
        Tv[171] := 100;
      Tv[172] := 0;
      // If Strings[172]>'' then Strings[172]:='N';
    end;
    If Tv[171] > 100 then
      Tv[171] := 100;
    If Tv[171] + Tv[172] > 100 then
      Tv[172] := 0;
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
      inc(i, 5);
    until i > 160;
   // Tv[162] := TotMultiple(RetNo, 'S12SUP', 161);
    Tv[161] := Tv[161] + Tv[162];
    if Tv[161]>10000 then Tv[161]:=10000;   //20230119
    // Tv[164]:=Tv[162]+Tv[163];
    Tv[165]:=1000;

     Tv[166] :=MaxR(0,Tv[161]-Tv[165]);// MaxR(12000, Tv[161] - Tv[165])); //20220225
    // Tv[167]:=1000;
    // Tv[168]:=MaxR(0,Tv[166]-Tv[167]);
    Tv[167] := Tv[166] * (MaxR(0, (100 - Tv[171]) / 100));
    Tv[170] := MaxR(0, Tv[166] - Tv[167]);
  end;
  SaveTv(RetNo, FName, FNo);

  {
  If (ret[RetNo].CouplingSw) and (OptimizeBtnClicked = False) then
  begin
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 64, FormatFloat('###.##', Tv[171]));
    StoreElm(RetNo, GetFormNo('OPTIMIZE'), 65,
      FormatFloat('###.##', 100 - Tv[171]));
  end;
  }
end;

*)


Procedure S12NB(RetNo: integer; FName: string; FNo: integer);
var
  i, j: integer;
  x1, x2: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
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
      inc(i, 5);
    until i > 160;
    Tv[161] := Tv[161] + Tv[162];
    Tv[166] := MinR(10000, MaxR(0, Tv[161] - Tv[165]));
    Tv[174] := MaxR(0, Tv[166] - Tv[167]);
    Tv[175] := 10;
    Tv[170] := Tv[174] * 10 / 100;
    ret[RetNo].Lnn[47900] := Tv[170]; // 20191223
  end;
  SaveTv(RetNo, FName, FNo);

end;

(*
  Procedure S12SUP(RetNo:integer;FName:string;FNo:integer);
  var i,j: integer; x1,x2:Real;
  Begin
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo].Frm[FNo] do
  begin
  Strings[172]:=FetchElm(RetNo,'S12',172);
  Tv[171]:=Vl(FetchElm(RetNo,'S12',171));
  //ditto handling
  i:=7;
  repeat
  If IsDitto(Strings[i]) then Strings[i]:=Strings[i-5];
  If IsDitto(Strings[i+1]) then Strings[i+1]:=Strings[i+1-5];
  Inc(i,5);
  until i>157;

  Tv[161]:=0;
  i:=5;
  Repeat
  Tv[161]:=Tv[161]+Tv[i];
  Inc(i,5);
  until i>160;
  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo, FNo, ArrayNo: integer);
// 20160124 //20160202 Igor
Var
  j, Elm: integer;
Begin
  Elm := ArrayNo * 10000 + StrToInt('1'); // firstColumn
  If FetchElmFNo(RetNo, FNo, Elm) = '' then
  begin
    For j := 1 to 4 do
    Begin
      StoreElm(RetNo, FNo, Elm + j, '');
    end;
  end;
end;

// 20200603
Procedure CopyFromT777Multiple(RetNo, FNo: integer);
Var
  T777FNo, Auto777FNo, i, j, k: integer;
  FName: String;
  KmPercent, MotorPercent, AllocPercent, PersonalMotorPercent,
    HomePercent: Real; // divided by 100

begin
  k := 0; // default at 5%
  If (ret[RetNo].Province = 'BC') then
    k := 0 // 20150228 //k:=1  //at 12% second column
  Else If (ret[RetNo].Province = 'ON') then
    k := 2 // at 13% third column //20180203
  else If (ret[RetNo].Province = 'NB') or (ret[RetNo].Province = 'NL') or
    (ret[RetNo].Province = 'NS') or (ret[RetNo].Province = 'PE') then
    k := 3; // 20180203  then k:=3;  //at 15% 4th column

  with ret[RetNo].Frm[FNo] do
  begin
    // initialize
    Tv[101 + k] := 0;
    Tv[113 + k] := 0;
    Tv[125 + k] := 0;
    Tv[137 + k] := 0;
    Tv[149 + k] := 0;
    Tv[161 + k] := 0;
    Tv[173 + k] := 0;
    Tv[185 + k] := 0;
    Tv[197 + k] := 0;
    Tv[249 + k] := 0;
    Tv[209 + k] := 0;
    Tv[221 + k] := 0;
    // motor home
    Tv[245 + k] := 0;
    Tv[249 + k] := 0;
    Tv[257 + k] := 0;
    Tv[261 + k] := 0;
    Tv[269 + k] := 0;
    Tv[273 + k] := 0;
    Tv[281 + k] := 0;
    Tv[285 + k] := 0;
    // work in home space
    Tv[293 + k] := 0;
    Tv[297 + k] := 0;

    Tv[305 + k] := 0;
    Tv[309 + k] := 0;

    Tv[61 + k] := 0;
    Tv[65 + k] := 0;

    //------------------------------
    for i := 0 to (FList.count - 1) do
    begin
      FRec := FList.Items[i];
      If FRec.FormName = 'T777' then
      begin
        T777FNo := FRec.FormNo;
        FName := FRec.FormName; // 20200525
        KmPercent := Vl(FetchElmFNo(RetNo, T777FNo, 6)) /
          Vl(FetchElmFNo(RetNo, T777FNo, 7));
        AllocPercent := Vl(FetchElmFNo(RetNo, T777FNo, 216)) / 100;
       // HomePercent := Vl(FetchElmFNo(RetNo, T777FNo, 57)) / 100;  //20210323

        Tv[101 + k] := Tv[101 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 3));
        Tv[113 + k] := Tv[113 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 4));
        Tv[125 + k] := Tv[125 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 11));
        Tv[137 + k] := Tv[137 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 12));
        Tv[149 + k] := Tv[149 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 13));
        Tv[161 + k] := Tv[161 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 14));
        Tv[173 + k] := Tv[173 + k] + (Vl(FetchElmFNo(RetNo, T777FNo, 16)) +
          Vl(FetchElmFNo(RetNo, T777FNo, 18)));
        Tv[185 + k] := Tv[185 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 65));
        Tv[197 + k] := Tv[197 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 58));
        Tv[249 + k] := Tv[249 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 65));
        // tradesperson

        Tv[209 + k] := Tv[209 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 19));
        Tv[221 + k] := Tv[221 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 21));


       //===========================================================
       // workspace at home
       if (UpperCase(FetchElm(RetNo,'GST370',51))='Y') //copy from schedules   //20210401
       and (UpperCase(FetchElmFno(RetNo,T777FNo,86))='Y') then      //20210401 detail workspace
       //if UpperCase(FetchElm(RetNo,'GST370',31))='Y' then      //20210401
       //if UpperCase(FetchElmFNo(RetNo,T777FNo,62))='Y' then      //20210401
       begin
         //HEAT ETC
         Tv[293 + k] :=  Tv[293 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 47));
         Tv[297 + k] :=  Tv[297 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 55));
         Tv[301 + k] :=  Tv[301 + k]+ Vl(FetchElmFNo(RetNo, T777FNo, 88));
         ///MAINTENANCE
         Tv[305 + k] := Tv[305 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 50)); // home maintenance
         Tv[309 + k] := Tv[309 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 57)); // home maintenance
         Tv[313 + k] := Tv[313 + k] + Vl(FetchElmFNo(RetNo, T777FNo, 101)); // home maintenance
       end
       Else
       begin
         Tv[293 + k] :=  Tv[293 + k] + 0;
         Tv[297 + k] :=  Tv[297 + k] + 0;
         Tv[301 + k] :=  Tv[301 + k] + 0;
         ///MAINtENANCE
         Tv[305 + k] := Tv[305 + k] + 0;
         Tv[309 + k] := Tv[309 + k] + 0;
         Tv[313 + k] := Tv[313 + k] + 0;
       end;

    //========================================================================
      end;
    end; // i

    for i := 0 to (FList.count - 1) do
    begin
      FRec := FList.Items[i];
      If (FRec.FormName = 'AUTO777') then
      begin
        Auto777FNo := FRec.FormNo;
        KmPercent := Vl(FetchElmFNo(RetNo, Auto777FNo, 4)) /
          Vl(FetchElmFNo(RetNo, Auto777FNo, 7));
        AllocPercent := Vl(FetchElmFNo(RetNo, Auto777FNo, 216)) / 100;
        // 20200406
        // motor vehicle expenses
        Tv[245 + k] := Tv[245 + k] + Vl(FetchElmFNo(RetNo, Auto777FNo, 10)) *
          AllocPercent; // fuel  //20200530
        Tv[249 + k] := Tv[249 + k] + Vl(FetchElmFNo(RetNo, Auto777FNo, 10)) *
          (1 - KmPercent) * AllocPercent; // fuel  //20200530

        Tv[257 + k] := Tv[257 + k] + Vl(FetchElmFNo(RetNo, Auto777FNo, 13)) *
          AllocPercent; // maintenance //20200530
        Tv[261 + k] := Tv[261 + k] + Vl(FetchElmFNo(RetNo, Auto777FNo, 13)) *
          (1 - KmPercent) * AllocPercent; // maintenance //20200530

        Tv[269 + k] := Tv[269 + k] + Vl(FetchElmFNo(RetNo, Auto777FNo, 16)) *
          AllocPercent; // leasing   //20200530
        Tv[273 + k] := Tv[273 + k] + Vl(FetchElmFNo(RetNo, Auto777FNo, 16)) *
          (1 - KmPercent) * AllocPercent; // leasing   //20200530

        Tv[281 + k] := Tv[281 + k] + (Vl(FetchElmFNo(RetNo, Auto777FNo, 32)) +
          Vl(FetchElmFNo(RetNo, Auto777FNo, 36))) * AllocPercent;
        // Other     //20200530
        Tv[285 + k] := Tv[285 + k] + (Vl(FetchElmFNo(RetNo, Auto777FNo, 32)) +
          Vl(FetchElmFNo(RetNo, Auto777FNo, 36))) * (1 - KmPercent) *
          AllocPercent; // Other     //20200530

        // cca related
        Tv[61 + k] := Tv[61 + k] + (Vl(FetchElmFNo(RetNo, Auto777FNo, 173))) *
          AllocPercent; // 20200530;
        Tv[65 + k] := Tv[65 + k] + (Vl(FetchElmFNo(RetNo, Auto777FNo, 173))) *
          (1 - KmPercent) * AllocPercent; // 20200530;
      end;
    end; // i
  end;
end;

Procedure T4FHSA(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := AppYear;
    //20240214
    Strings[18]:=FetchElmFNo(RetNo,InfoFNo,5);
    Strings[19]:=FetchElmFNo(RetNo,InfoFNo,2);
    Strings[13]:=FetchElmFNo(RetNo,InfoFNo,3);
    //If ShowUnconvertedLastYear(RetNo) then Strings[1] := GetLastYearTaxYear;
  end;
  SaveTv(RetNo, FName, FNo);
end;

//20260217
procedure S15(RetNo: Integer; FName: string; FNo: Integer);
var i:integer;
begin
 LoadTv(RetNo, FName, FNo);

 with Ret[RetNo].Frm[FNo] do
 Begin
  if Strings[67]='' then Strings[67]:='Y'; //20250217
  
  if UpperCase(Strings[67]) <> 'N' then  //blank or Y)
  begin
    //Page 2
    Tv[1]:= TotMultiple(RetNo, 'T4FHSA', 2);  //box 18
    Tv[4]:= Tv[1] - Tv[3];  //20231215
    //tv[7] from noa or t1028
    Tv[48]:= Tv[4] + Tv[7];
    Tv[5]:= TotMultiple(RetNo, 'T4FHSA', 12); //box 12
    Tv[61]:= Tv[59] - Tv[60]; //20251218 Igor
    Tv[62]:= Tv[3]; //20251218 Igor
    Tv[63]:= Tv[61] + Tv[62]; //20251218 Igor
    Tv[64]:= Tv[63]; //20251218 Igor
    Tv[65]:= MaxR(0, Tv[5] - Tv[64]); //20251218 Igor
    Tv[66]:= Tv[65]; //20251218 Igor
    Tv[9]:= MaxR(0, Tv[48] - Tv[66]); //20251218 Igor
    Tv[49]:= 8000;
    //CF Tv[6]:=
    Tv[25]:= Tv[49] + Tv[6];
    //Tv[11]:=  c/f
    Tv[8]:= TotMultiple(RetNo, 'T4FHSA', 9) + TotMultiple(RetNo, 'T4FHSA', 10); //box 32 and 34
    Tv[26]:= Tv[11] + Tv[8];
    Tv[27]:= Tv[26];
    // tv[28] cf
    Tv[10]:= TotMultiple(RetNo, 'T4FHSA', 11); //20241207
    Tv[29]:= Tv[28] + Tv[10];
    Tv[30]:= Tv[29];
    Tv[31]:= MaxR(0,Tv[27] - Tv[30]);  //20260217

    //step 3
    //Page 3
    Tv[50]:= Tv[31];
    Tv[32]:= Tv[11];
    Tv[33]:= Tv[28];
    Tv[34]:= Tv[32] - Tv[33];
    Tv[52]:= Tv[34] - Tv[51];
    Tv[53]:= 8000;
    Tv[55]:= Tv[53] + Tv[54];
    Tv[56]:= MinR(Tv[52], Tv[55]);
    Tv[58]:= Tv[56] + Tv[57];
    Tv[35]:= Tv[58];//2025//MinR(Tv[34], Tv[49]);
    //Tv[34]:= Tv[32] - Tv[44];
    //Tv[35]:= MinR(Tv[34], Tv[49]); //8000
    Tv[36]:= Tv[50] - Tv[35];
    Tv[37]:= Tv[25];
    Tv[38]:= Tv[36];
    Tv[39]:= MaxR(0, Tv[37] - Tv[38]);
    Tv[12]:= MinR(Tv[9], Tv[39]);
    Tv[13]:= Tv[12];
    //cf //Tv[15]:= Tv[8];
    Tv[16]:= Tv[13] + Tv[15];
    //Tv[17]:=CF
    Tv[18]:= Tv[16] - Tv[17];
    Tv[14]:= 40000;
    Tv[40]:= Tv[17];
    Tv[41]:= Tv[14] - Tv[40];
    Tv[42]:= Tv[31];
    Tv[43]:= MaxR(0, Tv[41] - tv[42]);
    Tv[19]:= MinR(Tv[18], Tv[43]);
  end
  Else
  Begin
    Tv[1]:=0;
    Tv[4]:=0;
    Tv[48]:=0;
    Tv[5]:=0;
    for i:=61 to 66 do Tv[i]:=0;
    Tv[9]:=0;
    Tv[49]:=0;
    Tv[25]:=0;
    Tv[8]:=0;
    Tv[26]:=0;
    Tv[27]:=0;
    Tv[10]:=0;
    Tv[29]:=0;
    Tv[30]:=0;
    Tv[31]:=0;
    //-----------------
    Tv[50]:= Tv[31];
    Tv[32]:=0;
    Tv[33]:=0;
    Tv[34]:=0;
    Tv[52]:=0;
    Tv[53]:=0;
    Tv[55]:=0;
    Tv[56]:=0;
    Tv[58]:=0;

    Tv[35]:=0;
    Tv[36]:=0;
    Tv[37]:=0;
    Tv[38]:=0;
    Tv[39]:=0;
    Tv[12]:=0;
    Tv[13]:=0;
    Tv[16]:=0;
    Tv[18]:=0;
    Tv[14]:=0;
    Tv[40]:=0;
    Tv[41]:=0;
    Tv[42]:=0;
    Tv[43]:=0;
    Tv[19]:=0;
  end;
  //Page 4
  Tv[20]:= Tv[4];
  Tv[45]:= Tv[44] + Tv[20];  //20241207
  Tv[46]:= Tv[66];           //jz//20260130 - form change as per email - Amount from line 12 of page 2 [66] instead of line 6 [5]
  Tv[47]:= MaxR(0,Tv[45] - Tv[46]);
  Tv[21]:= Tv[19];
  Tv[22]:= MaxR(0,Tv[47] - Tv[21]); //20260511
  Tv[23]:= TotMultiple(RetNo, 'T4FHSA', 3);  //20240317
 end;
 SaveTv(RetNo, FName, FNo);
end;
//20250929 Igor <<<

//20260122 Igor >>>
procedure T2048(RetNo: Integer; FName: string; FNo: Integer);
  var i:integer;

        //jz//20260205
        function getPrevStatementAmt(prevStatementAmtElmNum:integer):real;
        var
          i:integer;
          prevStatementAmt:real;
        begin
          prevStatementAmt := 0;
          if (CountMultipleInstances(RetNo,ExtractNonInstFormName(FName)) > 1) and (ExtractFormInstNo(FName) > 1) then
          begin
            for i := ExtractFormInstNo(FName) downto 2 do
              prevStatementAmt:= prevStatementAmt + vl(FetchElm(RetNo, 'T2048#'+inttostr(i-1),prevStatementAmtElmNum));
          end;
          result := prevStatementAmt;
        end;


        procedure calcT2048ChartA();
        begin
          with Ret[RetNo].Frm[FNo] do
          begin

            //Page 4
            Tv[79]:= Ret[RetNo].lnn[22100];
            Tv[80]:= Ret[RetNo].lnn[12600];
            Tv[81]:= Ret[RetNo].lnn[12200];
            Tv[82]:= Ret[RetNo].lnn[25100];
            Tv[83]:= Ret[RetNo].lnn[22400] * 0.50;
            Tv[85]:= Tv[17];
            Tv[86]:= Tv[30];
            Tv[87]:= MaxR(0, Tv[85] - Tv[86]); //jz//20260128 - maxr not minr for if neg then 0
            Tv[88]:= Tv[87];
            Tv[89]:= Tv[79] + Tv[80] + Tv[81] + Tv[82] + Tv[83] + Tv[84] + Tv[88];
            Tv[90]:= Tv[89];
            Tv[91]:= Ret[RetNo].lnn[12000] + Ret[RetNo].lnn[12100];
            Tv[92]:= Ret[RetNo].lnn[12600];
            Tv[93]:= Ret[RetNo].lnn[12200];
            Tv[95]:= Ret[RetNo].lnn[13000] * 0.50;
            Tv[96]:= Tv[10];
            Tv[97]:= Tv[25];
            Tv[98]:= Tv[96] - Tv[97];
            Tv[99]:= Tv[98];
            Tv[100]:= Tv[91] + Tv[92] + Tv[93] + Tv[94] + Tv[95] + Tv[99];
            Tv[101]:= Tv[100];
            Tv[102]:= MaxR(0, Tv[90] - Tv[101]); //jz//20260128 - maxr not minr for if neg then 0
            //note: (3) If you have more than one QBT or QCC, subtract the sum of all previous amounts from line 42 of Part 4.
            Tv[102]:= Tv[102] - getPrevStatementAmt(52);

          end;
        end;

begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    //Tv[4]:= vtUser
    Tv[5]:= MinR(100, MaxR(0, Tv[5])); //20250401 CZ Needs a proper statement
    Tv[6]:= Tv[4] * (Tv[5] / 100);
    Tv[7]:= 50;
    Tv[19]:= Tv[6] * (Tv[7] / 100);
    //Tv[20]:= Ret[RetNo].lnn[25395]; // FetchElm(RetNo, 'T1', 536); //jz//20260128 - make vtUser as asking for prior yrs
    Tv[8]:= Tv[19] - Tv[20];

    //Tv[9]:= Tv[8]; //jz//20260128 - there is no elm [9]

    //note: (1) If you have more than one QBT or QCC, subtract the sum of all previous amounts from line 32 of the next page.
    Tv[10]:= Ret[RetNo].lnn[12700] - getPrevStatementAmt(40);

    //Tv[11]:= vtUser
    //Tv[12]:= vtUser
    Tv[22]:= Tv[11] + Tv[21];

    //Page 2
    Tv[24]:= Tv[22];
    Tv[13]:= Tv[24] - Tv[12];
    Tv[14]:= 50;
    Tv[15]:= Tv[13] * (Tv[14] / 100);
    Tv[25]:= MinR(Tv[10], Tv[15]);

    Tv[17]:= Ret[RetNo].lnn[25300];
    Tv[26]:= Tv[10];
    Tv[27]:= Tv[25];
    Tv[28]:= maxR(0, Tv[26] - Tv[27]); //jz//20260128 - maxr not minr for if neg then 0
    Tv[29]:= Tv[28];
    Tv[30]:= maxR(0, Tv[17] - Tv[29]); //jz//20260128 - maxr not minr for if neg then 0
    //note: (2) If you have more than one QBT or QCC, subtract the sum of all previous amounts from line 41 above.
    Tv[31]:= Ret[RetNo].lnn[21700] - getPrevStatementAmt(51);

    calcT2048ChartA();
    Tv[32]:= Tv[102];  //jz//20260128 was correct, why use fetch? but need to do the chartA above//Vl(FetchElm(RetNo, 'T2048', 102)); //Tv[102];
    Tv[33]:= Tv[30] + Tv[31] + Tv[32];
    Tv[34]:= Tv[33];
    Tv[35]:= Tv[25] - Tv[34];
    Tv[18]:= MinR(Tv[8], Tv[35]);

    Tv[36]:= MinR(Tv[8], Tv[25]);
    Tv[37]:= Tv[18];
    Tv[38]:= Tv[36] - Tv[37];

    Tv[39]:= tv[18]; //Ret[RetNo].lnn[25395]; //jz//20260205 - from THIS one, not the total, so should be tv[18]
    Tv[40]:= Tv[38] + Tv[39];
    Tv[41]:= Tv[31];
    Tv[42]:= Tv[32];
    Tv[43]:= Tv[41] + Tv[42];
    Tv[44]:= MinR(Tv[38], Tv[43]);
    Tv[45]:= Tv[44];

    if Tv[45] = 0 then //jz//20260130 - condition moved from line 30 to line 36 as per email //jz//20260128 - add condition as per form
    begin
      Tv[51]:= 0;
      Tv[52]:= 0;
      for i:=46 to 50 do Tv[i]:= 0; //jz//20260130 clear the other fields also [46][47][48][49][50]
    end
    else
    begin
      Tv[46]:= Tv[45]; //jz//20260128 - change to [45] to keep it striclty to the form
      Tv[47]:= Tv[43];
      if (Tv[47] <> 0) then
        Tv[48]:= Tv[46] / Tv[47]
      else
        Tv[48]:= Tv[46] / 1;
      Tv[49]:= Tv[41];
      Tv[50]:= Tv[48] * Tv[49];
      Tv[51]:= Tv[50];
      Tv[52]:= Tv[45] - Tv[51];
    end;

    //Page 3
    if FName = 'T2048#1' then
    begin

    //A.
    if FetchElm(RetNo, 'T2048#1',104) > '' then Tv[53]:= Vl(FetchElm(RetNo, 'T2048#1',8));
    if FetchElm(RetNo, 'T2048#2',104) > '' then Tv[54]:= Vl(FetchElm(RetNo, 'T2048#2',8));
    if FetchElm(RetNo, 'T2048#3',104) > '' then Tv[55]:= Vl(FetchElm(RetNo, 'T2048#3',8));
    Tv[56]:= TotMultiple(RetNo, 'T2048', 53) + TotMultiple(RetNo, 'T2048', 54) + TotMultiple(RetNo, 'T2048', 55);

    //B.
    if FetchElm(RetNo, 'T2048#1',103) > '' then Tv[57]:= Vl(FetchElm(RetNo, 'T2048#1',8));
    if FetchElm(RetNo, 'T2048#2',103) > '' then Tv[58]:= Vl(FetchElm(RetNo, 'T2048#2',8));
    if FetchElm(RetNo, 'T2048#3',103) > '' then Tv[59]:= Vl(FetchElm(RetNo, 'T2048#3',8));
    Tv[9] := TotMultiple(RetNo, 'T2048', 57) + TotMultiple(RetNo, 'T2048', 58) + TotMultiple(RetNo, 'T2048', 59);

    //C.
    Tv[60]:= Vl(FetchElm(RetNo, 'T2048#1',15));
    Tv[61]:= Vl(FetchElm(RetNo, 'T2048#2',15));
    Tv[62]:= Vl(FetchElm(RetNo, 'T2048#3',15));
    Tv[16]:= TotMultiple(RetNo, 'T2048', 60) + TotMultiple(RetNo, 'T2048', 61) + TotMultiple(RetNo, 'T2048', 62);

    //D.
    //vtUser??
    //Tv[64]:= Vl(FetchElm(RetNo, 'T2048#1',39)) + Vl(FetchElm(RetNo, 'T2048#1', 45));
    //Tv[65]:= Vl(FetchElm(RetNo, 'T2048#2',39)) + Vl(FetchElm(RetNo, 'T2048#2', 45));
    //Tv[66]:= Vl(FetchElm(RetNo, 'T2048#3',39)) + Vl(FetchElm(RetNo, 'T2048#3', 45));
    Tv[63]:= TotMultiple(RetNo, 'T2048', 64) + TotMultiple(RetNo, 'T2048', 65) + TotMultiple(RetNo, 'T2048', 66);

    //E.
    //vtUser??
    //Tv[67]:= Vl(FetchElm(RetNo, 'T2048#1',67));
    //Tv[68]:= Vl(FetchElm(RetNo, 'T2048#2',68));
    //Tv[69]:= Vl(FetchElm(RetNo, 'T2048#3',69));
    Tv[70]:= TotMultiple(RetNo, 'T2048', 67) + TotMultiple(RetNo, 'T2048', 68) + TotMultiple(RetNo, 'T2048', 69);

    //F.
    Tv[71]:= Vl(FetchElm(RetNo, 'T2048#1',51));
    Tv[72]:= Vl(FetchElm(RetNo, 'T2048#2',51));
    Tv[73]:= Vl(FetchElm(RetNo, 'T2048#3',51));
    Tv[74]:= TotMultiple(RetNo, 'T2048', 71) + TotMultiple(RetNo, 'T2048', 72) + TotMultiple(RetNo, 'T2048', 73);

    //G.
    Tv[75]:= Vl(FetchElm(RetNo, 'T2048#1',52));
    Tv[76]:= Vl(FetchElm(RetNo, 'T2048#2',52));
    Tv[77]:= Vl(FetchElm(RetNo, 'T2048#3',52));
    Tv[78]:= TotMultiple(RetNo, 'T2048', 75) + TotMultiple(RetNo, 'T2048', 76) + TotMultiple(RetNo, 'T2048', 77);

    end;

    {
    //Page 3
    Tv[53]:= 0;Tv[57]:=0;       //jz//20260128 - clear amounts
    if strings[104] > '' then   //jz//20260128 - add condition from newly added checkboxes  //??? How to understend this is a QCC or QBT?
      Tv[53]:= Tv[8]
    else if strings[103] > '' then
      Tv[57]:= Tv[8];

    Tv[56]:= Tv[53] + Tv[54] + Tv[55];
    Tv[9]:= Tv[57] + Tv[58] + Tv[59];

    Tv[60]:= Tv[15];
    Tv[16]:= Tv[60] + Tv[61] + Tv[62];

    Tv[64]:= Tv[39] + Tv[45];
    Tv[63]:= Tv[64] + Tv[65] + Tv[66];

    Tv[70]:= Tv[67] + Tv[68] + Tv[69];
    Tv[71]:= Tv[51];
    Tv[74]:= Tv[71] + Tv[72] + Tv[73];
    Tv[75]:= Tv[52];
    Tv[78]:= Tv[75] + Tv[76] + Tv[77];
    }
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260122 Igor <<<


//20250401
Procedure T24EOT(RetNo: integer; FName: String; FNo: integer);
begin

end;

Procedure S12SK(RetNo: integer; FName: string; FNo: integer); //20260103
var
  i, j: integer;
  x1, x2: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  With ret[RetNo].Frm[FNo] do
  begin
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
      inc(i, 5);
    until i > 160;
    Tv[161] := minr(5000,Tv[161] + Tv[162]);
    if Ret[RetNo].Age >65 then Tv[161] := Minr(6000,Tv[161] + Tv[162]);

    Tv[165]:=1000;
    Tv[166] := MaxR(0, Tv[161] - Tv[165]);
    Tv[174] := MaxR(0, Tv[166] - Tv[167]);
    Tv[175] := 10;
    Tv[170] := Tv[174] * 10 / 100;
    ret[RetNo].Lnn[47900] := Tv[170]; // 20191223
  end;
  SaveTv(RetNo, FName, FNo);
end;



end.
