Unit T1_2026CalcMJ2;
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



  procedure ABMJ(RetNo: integer; FName: String;FNo: integer);
  procedure ONMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NLMJ(RetNo: integer; FName: String;FNo: integer);
  procedure PEMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NSMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NBMJ(RetNo: integer; FName: String;FNo: integer);
  procedure MBMJ(RetNo: integer; FName: String;FNo: integer);
  procedure SKMJ(RetNo: integer; FName: String;FNo: integer);
  procedure BCMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NTMJ(RetNo: integer; FName: String;FNo: integer);
  procedure NUMJ(RetNo: integer; FName: String;FNo: integer);
  procedure YTMJ(RetNo: integer; FName: String;FNo: integer);  //202411222 duplicate









{
  procedure ABMJ(RetNo: integer; FName: String; FNo: integer);
  procedure BCMJ(RetNo: integer; FName: String; FNo: integer);
  procedure MBMJ(RetNo: integer; FName: String; FNo: integer);
  //   Procedure NBMJ(RetNo: integer; FName: String; FNo: integer); //20250425
  procedure NLMJ(RetNo: integer; FName: String; FNo: integer);
  procedure ONMJ(RetNo: integer; FName: String; FNo: integer);

  procedure NSMJ(RetNo: integer; FName: String; FNo: integer);
  procedure NTMJ(RetNo: integer; FName: String; FNo: integer);
  procedure NUMJ(RetNo: integer; FName: String; FNo: integer);
  procedure PEMJ(RetNo: integer; FName: String; FNo: integer);
  procedure SKMJ(RetNo: integer; FName: String; FNo: integer);
  // Procedure YTMJ(RetNo: integer; FName: String; FNo: integer);  //duplicate 20241122
}
implementation

Uses vtCommon, T1_2026, T1_2026Calc, T1_2026Calc3, T1_2026Calc1, T1_2026Calc2,
  // 20160119 Igor
  vtTrimStr, vtShared;



//20251125 Igor >>>
procedure ABMJ(RetNo: Integer; FName: String; FNo: Integer);
var
  i, TaxFNo1: Integer;
  x, y, z: Real;
  T2203FNo: Integer;
begin
  InitPrvConstants('AB');
  TaxFNo1:= GetFormNo('AB428');
  T2203FNo:= GetFormNo('T2203');

  for i:= 131 to 165 do Ret[RetNo].Frm[Fno].Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, i);

  Ret[RetNo].Frm[Fno].Strings[39]:= FetchElmFNo(RetNo, TaxFNo1, 77);
  Ret[RetNo].Frm[Fno].Strings[4]:= FetchElmFNo(RetNo, TaxFNo1, 76);
  Ret[RetNo].Frm[Fno].Strings[41]:= FetchElmFNo(RetNo, TaxFNo1, 75);
  Ret[RetNo].Frm[Fno].Strings[40]:= FetchElmFNo(RetNo, TaxFNo1, 74);
  Ret[RetNo].Frm[Fno].Strings[17]:= FetchElmFNo(RetNo, TaxFNo1, 73);
  Ret[RetNo].Frm[Fno].Strings[15]:= FetchElmFNo(RetNo, TaxFNo1, 72);
  Ret[RetNo].Frm[Fno].Strings[16]:= FetchElmFNo(RetNo, TaxFNo1, 71);

  LoadTv(RetNo, FName, FNo);

  if not IsMultJurisdiction(RetNo) or (Vl(GetMjAlloc(RetNo, 'AB')) = 0) then
  begin
    for i:= 1 to 165 do Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    SaveTv(RetNo, FName, FNo);
    Exit;
  end;

  with Ret[RetNo].Frm[Fno] do
  begin
    Tv[2]:= Ret[RetNo].Lnn[26000];

    //20160322
    //Tv[23]:=Ret[RetNo]^.Lnn[26000];
    // Strings[24]:=PrvConstant[RY].PrvRate1;
    // Strings[28]:=PrvConstant[RY].PrvRate1;

    Tv[25]:= MaxR(MaxR(Tv[161], Tv[162]), MaxR(Tv[16], Tv[163]));
    Tv[25]:= MaxR(MaxR(Tv[25], Tv[164]), Tv[165]);

    if Ret[RetNo].Province.Equals('AB') then Tv[26]:= Vl(FetchElmFNo(RetNo, TaxFNo1, 8)) else Tv[26]:= 0;

    Tv[27]:= Tv[25] + Tv[26];
    Tv[29]:= Vl(FetchElm(RetNo, 'T2203', 679));

    if ret[RetNo].Province.Equals('AB') then Tv[3]:= Vl(FetchElm(RetNo, 'DTC', 9)) else Tv[3]:= 0;
    {If ret[RetNo].Province = 'AB' then    Tv[4] := ret[RetNo].Lnn[426] else Tv[4]:=0;
    Tv[19]:= PrvConstant[RY].PrvOverseasRate;
    Tv[5]:= Tv[4] * Tv[19]/100;   }
    Tv[6]:= ret[RetNo].Lnn[40427];
    Tv[20]:= PrvConstant[RY].PrvAmtCarryOverRate;
    Tv[7]:= Tv[6] * Tv[20] / 100;
    Tv[8]:= Tv[29] + Tv[3] + Tv[7];
    Tv[9]:= Tv[8];
    Tv[1]:= MaxR(0, Tv[27] - Tv[9]);
    Tv[44]:= Vl(FetchElm(RetNo, 'T1219', 119));
    Tv[21]:= Tv[1] + Tv[44];
    Strings[22]:= GetMjAlloc(RetNo, 'AB');
    Tv[10]:= Tv[21] * Vl(Strings[22]) / 100;
    Tv[67]:= Tv[10];

    if Ret[RetNo].Province.Equals('AB') then
    begin
      Tv[30]:= Vl(FetchElmFNo(RetNo, T2203FNo, 680)) + Vl(FetchElmFNo(RetNo, T2203FNo, 662));
      {pattern
      //20180403
      Tv[yy]:=Vl(FetchElmFNo(RetNo,T2203FNo,XXX))+Vl(FetchElmFNo(RetNo,T2203FNo,XXX))+Vl(FetchElmFNo(RetNo,T2203FNo,XXX))
           +Vl(FetchElmFNo(RetNo,T2203FNo,XXX))+Vl(FetchElmFNo(RetNo,T2203FNo,XXX))
           +Vl(FetchElmFNo(RetNo,T2203FNo,XXX));  }

      Tv[31]:= Tv[30] * 0.08;
      Tv[32]:= Tv[3];
      //Tv[33]:= Tv[5];
      Tv[34]:= Tv[31] + Tv[32];
      Strings[5]:= '100.00';
      Strings[18]:= Strings[22];
      Strings[19]:= FormatFloat('###.0000', Vl(Strings[5]) - Vl(Strings[18]));
      Strings[35]:= Strings[19];
      Tv[36]:= Tv[34] * vl(strings[35]) / 100;
      Tv[37]:= Tv[36];
      //Tv[38]:= MaxR(0, Tv[10] - Tv[37]);
      //Tv[39]:= Tv[26];
      //strings[40]:= strings[35];
      //Tv[41]:= Tv[39] * vl(strings[40]) / 100;
      Tv[42]:=0;      //20260426  ??? NEEDS revision from where?
      Tv[46]:= MaxR(0, Tv[38] - Tv[42]); //20260426
      //Tv[43]:= MaxR(0, Tv[67] - Tv[37]); //20260426
      Tv[11]:= GetPrvForTaxCredit(RetNo, 'AB');
      Tv[12]:= MaxR(0, Tv[43] - Tv[11]);

    end else
    begin
      //jz//20260331//MJCERT2025 - was a mistake on the form, update so continue on line 38 not 43
      //If you were not a resident of Alberta, enter the amount from line 27 on line 38 on the next page.
      for i:= 30 to 32 do Tv[i]:= 0; //for i:= 30 to 32 do Tv[i]:= 0;
      for i:= 34 to 37 do Tv[i]:= 0; //for i:= 35 to 43 do Tv[i]:= 0;

      Tv[43]:= 0;
      Tv[11]:= 0;
      Tv[12]:= Tv[10];

      //Tv[30]:= 0;
      //Tv[31]:= 0;
      //Tv[32]:= 0;
      //Tv[34]:= 0;
      //Tv[35]:= 0;
      //Tv[36]:= 0;
      //Tv[37]:= 0;
      //Tv[43]:= 0;
      //Tv[11]:= 0;
      //Tv[12]:= 0;//Tv[10];
      //Tv[13]:= 0;
      //Tv[14]:= 0;
      //Tv[38]:= 0;
      //Tv[42]:= Tv[10];
    end;

    Tv[13]:= GetPrvPolit(RetNo, 'AB');  //20240411
    //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
    //if IsMultJurisdiction(RetNo) then Tv[13]:= Vl(FetchElm(RetNo, 'POLIT', 45)); //20240410

    if (Tv[13] <= 200) then Tv[14]:= Tv[13] * 0.75 else
    if (Tv[13] > 200) and (Tv[13] <= 1100) then Tv[14]:= (Tv[13] - 200) * 0.50 + 150 else
    if (Tv[13] > 1100) and (Tv[13] <= 2300) then Tv[14]:= (Tv[13] - 1100) * 0.3333 + 600;
    if (Tv[13] > 2300) then Tv[14]:= 1000;

    Tv[38]:= MaxR(0, Tv[12] - Tv[14]);

    Tv[42]:=0; //20260426
    //Tv[42]:= Vl(FetchElm(RetNo, 'AB428WS', 16)); //We have not AB428WS in using // On current time Tv[42] can be filled by the user

    Tv[46]:= MaxR(0, Tv[38] - Tv[42]);
    //Tv[48]:=Tv[14]+Tv[47];
    //Tv[49]:=Tv[48];
    //Tv[15] := MaxR(0,Tv[12]-Tv[49]);
    // Tv[17] :=MaxR(0,Tv[67]-Tv[49]); //20150312 // MaxR(0,Tv[15]-Tv[16]);
    //20200331
    //Tv[4]:= Vl(FetchElm(RetNo, 'AB428', 16));//Vl(FetchElm(RetNo,'AB428',6)); //20220501
    // Tv[5]:= 0; //Vl(FetchElm(RetNo,'AB428',7));  //20220501
    //Tv[17]:= Vl(FetchElm(RetNo, 'AB428', 56)); //20220501 //Vl(FetchElm(RetNo,'AB428',16)); //20200331
    //Tv[16]:= Tv[4] + Tv[17];  //20220501 //Tv[16]:=Tv[15];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure ONMJ(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, k, TaxFno1: Integer;
  T2203FNo: Integer;

  procedure FillTableFromON428(aJ, aFromI, aToI: integer);
  var
    jfor, ifor: Integer;
  begin
    jfor:= aJ;
    with Ret[RetNo].Frm[FNo] do
      for ifor:= aFromI to aToI do
      begin
        Strings[ifor]:= FetchElmFNo(RetNo, TaxFNo1, jfor);
        Tv[ifor]:= Vl(FetchElmFNo(RetNo, TaxFNo1, jfor));
        Inc(jfor);
      end;
  end;

begin
  with Ret[RetNo].Frm[FNo] do
  begin
    for i:= 12 to 23 do Tv[i]:= 0;
    for i:= 46 to 54 do Tv[i]:= 0;
    for i:= 156 to 162 do Tv[i]:= 0;
    for i:= 117 to 121 do Tv[i]:= 0;
    for i:= 123 to 124 do Tv[i]:= 0;

    InitPrvConstants('ON');
    TaxFNo1:= GetFormNo('ON428');
    T2203FNo:= GetFormNo('T2203');
    LoadTv(RetNo, FName, FNo);

    if not IsMultJurisdiction(RetNo) or (Vl(GetMjAlloc(RetNo,'ON')) = 0) then
    begin
      for i:= 1 to 124 do Tv[i]:= 0;
      SaveTv(RetNo, FName, FNo);
      Exit;
    end;
    //Page 1
    Tv[1]:= Vl(FetchElmFNo(RetNo, TaxFNo1, 1));

    FillTableFromON428(2, 12, 23);
    FillTableFromON428(14, 46, 54);
    FillTableFromON428(156, 156, 162);
    FillTableFromON428(117, 117, 124);

    Tv[30]:= MaxR(Tv[124], MaxR(Tv[162], MaxR(Tv[52], MaxR(Tv[53], Tv[54]))));
    Tv[33]:= Vl(FetchElmFno(RetNo, T2203FNo, 527));
    Tv[83]:= MaxR(0, Tv[30] - Tv[33]);
    Strings[24]:= GetMjAlloc(RetNo, 'ON');
    Tv[55]:= Tv[83] * Vl(Strings[24]) / 100;
    //adjustments
    Tv[5]:= Vl(FetchElmFNo(RetNo, T2203FNo, 592)) + Vl(FetchElmFNo(RetNo, T2203FNo, 510));
    Tv[6]:= 5.05; //20251125 Igor
    Tv[7]:= Tv[5] * Tv[6] / 100;
    Strings[78]:= '100.0000';
    Strings[80]:= Strings[24];
    Strings[81]:= FormatFloat('###.0000', Vl(Strings[78]) - Vl(Strings[80]));
    Strings[84]:= Strings[81];
    Tv[28]:= Tv[7] * vl(strings[84]) / 100;
    Tv[60]:= Tv[28];
    Tv[43]:= MaxR(0, Tv[55] - Tv[60]);

    if (SplitIncome(RetNo)) and (Ret[RetNo].Province = 'ON') then Tv[31]:= Vl(FetchElm(RetNo, 'T1206', 18)) else Tv[31]:= 0;

    Tv[32]:= Tv[43] + Tv[31];

    if not Ret[RetNo].Province.Equals('ON') then
    begin
      for i:= 5 to 7 do Tv[i]:= 0;

      Tv[84]:= 0;
      Tv[28]:= 0;
      Tv[60]:= 0;
      Tv[43]:= 0;
      Tv[31]:= 0;
      Tv[32]:= Tv[55];
    end;

    TV[64]:= Tv[43];

    if Ret[RetNo].Province.Equals('ON') then Tv[65]:= Vl(FetchElm(RetNo, 'DTC', 9)) else Tv[65]:= 0;

    Tv[66]:= MaxR(0, Tv[64] - Tv[65]);
    Tv[26]:= Ret[RetNo].Lnn[40427];
    Tv[35]:= 24.63; //33.67; //20251125 Igor
    Tv[25]:= Tv[26] * Tv[35] / 100;
    Strings[85]:= Strings[24];
    Tv[44]:= Tv[25] * Vl(Strings[85]) / 100;
    Tv[67]:= MinR(Tv[66], Tv[44]);
    Tv[68]:= MaxR(0, Tv[32] - Tv[67]);

    //Page 2 //Surtax
    Tv[88]:= Tv[68];
    Tv[27]:= Tv[83];
    Tv[89]:= Tv[83];
    Tv[90]:= Tv[65];
    Tv[91]:= MaxR(0, Tv[89] - Tv[90]);
    Tv[86]:= Tv[25];
    Tv[87]:= MinR(Tv[91], Tv[86]);
    Tv[101]:= MaxR(0, Tv[27] - Tv[87]);

    //surtax
    Tv[2]:= Tv[101];
    Tv[3]:= MaxR(0, Tv[2] - 5710) * 0.20; //20251125 Igor
    Tv[8]:= Tv[101];
    Tv[9]:= MaxR(0, Tv[8] - 7307) * 0.36; //20251125 Igor
    Tv[11]:= Tv[3] + Tv[9];
    Tv[37]:= Tv[11];
    strings[38]:= strings[24];
    Tv[34]:= Tv[37] * Vl(Strings[38]) / 100;
    Tv[61]:= Tv[88] + Tv[34];

    if Ret[RetNo].Province.Equals('ON') then Tv[36]:= Vl(FetchElm(RetNo, 'DTC', 9)) else Tv[36]:= 0;

    Tv[10]:= MaxR(0, Tv[61] - Tv[36]);
    Tv[41]:= Vl(FetchElm(RetNo, 'T691', 249));
    Strings[42]:= Strings[24];
    Tv[40]:= Tv[41] * Vl(Strings[42]) / 100;
    Tv[4]:= Tv[10] + Tv[40];

    {tax reduction}
    Tv[70]:= 294; //20251125 Igor

    if (Tv[4] <= 0) then
    begin
      for i:= 103 to 113 do
      begin
        Strings[i]:= '';
        Tv[i]:= 0;
      end;

      Tv[71]:= 0;
      Tv[72]:= 0;
      Tv[56]:= 0;
      Tv[57]:= 0;
      Tv[62]:= 0;
      Tv[69]:= 0;
    end else
    begin
      strings[71]:= strings[24];
      Tv[102]:= Tv[70] * vl(strings[71]) / 100;

      if (GetPrvNetIncome(RetNo, 'ON') > SpouseIncome(RetNo)) then
      begin
        Strings[103]:= FetchElm(RetNo, 'DEPEND', 8);
        k:= MystrToInt(FetchElm(RetNo, 'DEPEND', 9));

        if (Vl(FetchElm(RetNo, 'S2', 5)) > 0) and (Ret[RetNo].Lnn[32600] > 0) then Inc(K); {disabil xferd from spouse}

        Strings[105]:= IntToStr(k);
      end else
      begin
        Strings[103]:= '';
        Strings[105]:= '';
      end;

      Tv[104]:= Vl(Strings[103]) * 544; //20251125 Igor
      Strings[39]:= Strings[24];
      Tv[56]:= Tv[104] * Vl(Strings[39]) / 100;
      Tv[57]:= Tv[56];
      Tv[106]:= Vl(Strings[105]) * 544; //20251125 Igor
      Strings[62]:= Strings[24];
      Tv[69]:= Tv[106] * Vl(Strings[62]) / 100;
      Tv[72]:= Tv[69];
      Tv[107]:= Tv[102] + Tv[57] + Tv[72];
      Tv[108]:= Tv[107];
      Tv[109]:= Tv[108] * 2;
      Tv[110]:= Tv[4];
      Tv[111]:= MaxR(0, Tv[109] - Tv[110]);
      Tv[112]:= Tv[111];

      if not Ret[RetNo].Province.Equals('ON') then for i:= 102 to 112 do Tv[i]:= 0;

      Tv[113]:= MaxR(0, Tv[4] - Tv[112]);
    end;

    //Page 3
    Tv[82]:= Tv[113];

    if Ret[RetNo].Province.Equals('ON') then Tv[153]:= GetPrvForTaxCredit(RetNo, 'ON') else Tv[153]:= 0;

    Tv[154]:= MaxR(0, Tv[113] - Tv[153]);
    Tv[74]:= Vl(FetchElm(RetNo, 'ON428A', 41));
    Strings[75]:= Strings[24];
    Tv[76]:= Tv[74] * Vl(Strings[75]) / 100;
    Tv[77]:= Tv[76];
    Tv[79]:= MaxR(0, Tv[154] - Tv[77]);
    Tv[58]:= Tv[63] * 0.25;
    Tv[59]:= MaxR(0, Tv[79] - Tv[58]);

    if Ret[RetNo].Province.Equals('ON') then Tv[127]:= Vl(FetchElm(RetNo, 'ON428', 134)) else Tv[127]:= 0;

    Tv[122]:= Tv[59] + Tv[127];
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure NLMJ(RetNo: integer; FName: String;FNo: integer);
Var
i,j,TaxFNo:Integer;
x:Real;
T2203FNo:Integer;
Begin
 InitPrvConstants('NL');
 TaxFNo:=GetFormNo('NL428');
 T2203FNo:=GetFormNo('T2203');
 //revised 20170604
 If (IsMultJurisdiction(RetNo) = False)
 Or (Vl(GetMjAlloc(RetNo,'NL')) =0) then
 begin
   For i:=1 to 199 do ret[RetNo].Frm[FNo].Tv[i]:=0;   //20230506 not 177 //20160322 //20160505 Igor
   SaveTv(RetNo,FName,FNo);
   Exit;
 end;

 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
   Tv[39]:=Vl(FetchElmFNo(RetNo,TaxFNo,1));
   J:=2;
   For i:=40 to 60 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(j);
   end;

   //20160322
   For i:=161 to 167 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo,i);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,i)); //
    // Inc(j);
   end;
   For i:=171 to 177 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo,i);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,i));   //
    // Inc(j);
   end;

   For i:=179 to 199 do       //20230506
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo,i);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,i));   //
   end;
   //20240503
   Tv[1] := MaxR(Tv[58],MaxR(Tv[59],Tv[60]));
   Tv[1]:=MaxR(Tv[1],MaxR(Tv[167],Tv[177])); //20170409
   Tv[1]:=MaxR(Tv[1],MaxR(Tv[185],Tv[192])); //20170409
   Tv[1]:=MaxR(Tv[1],Tv[199]); //20170409
   {
   Tv[1] := MaxR(Tv[58],MaxR(Tv[59],Tv[60]));
   Tv[1]:=MaxR(Tv[1],MaxR(Tv[167],Tv[177])); //20170409
   }
    If SplitIncome(RetNo) then
     Tv[2] := Vl(FetchElm(RetNo,'T1206',103))
    else
     Tv[2] :=0;
    Tv[3] := Tv[1]+Tv[2];

    Tv[5] :=Vl(FetchElm(RetNo,'T2203',327));

    If Ret[RetNo].Province = 'NL' then
     Tv[7] := Vl(FetchElm(RetNo,'DTC',9)) //Tv[6] * Tv[4]/100;
    else
     Tv[7]:=0;

     //20180402
   // If Ret[RetNo].Province = 'NL' then  //20190329
   // Begin   //leave calcs here
     Tv[19] := ret[RetNo].Lnn[40427];
     Tv[22] := PrvConstant[RY].PrvAMTCarryOverRate;
     Tv[23] := Tv[19] * Tv[22]/100;
     Tv[24] := Tv[5]+Tv[7]+Tv[23];
     Tv[25] := Tv[24];
     Tv[26] := MaxR(0,Tv[3] - Tv[25]);
  //  end;
     Tv[8]:=Vl(FetchElm(RetNo,'T691',316));
     Tv[10]:=58; //51.3; //20180325
     Tv[27] := Tv[8] * Tv[10]/100;
     Tv[37] := Tv[26]+Tv[27];
     Strings[38]:=GetMjAlloc(RetNo,'NL');
     Tv[28] := Tv[37]*Vl(Strings[38])/100;

     Tv[127]:=Tv[28];  //20230508

    If Ret[RetNo].Province <> 'NL' then
    begin
     Tv[9]:=0;
     Tv[11]:=0;Tv[14]:=0;Tv[15]:=0;Tv[18]:=0;Tv[20]:=0;Tv[21]:=0;Tv[29]:=0;
    end
    else
    begin
     //20220404
      Tv[9]:=
        Vl(FetchElmFNo(RetNo,T2203FNo,16))   //58315
       +Vl(FetchElmFNo(RetNo,T2203FNo,112))  //58316
       +Vl(FetchElmFNo(RetNo,T2203FNo,23))   //58320
       +Vl(FetchElmFNo(RetNo,T2203FNo,410))  //58330
       +Vl(FetchElmFNo(RetNo,T2203FNo,313)); //58360

      Tv[11]:=Tv[49];
      Tv[14]:=Tv[9]*Tv[11]/100;
      Tv[18]:=Tv[14]+Tv[15];  //+Tv[17];  //20210411

      Strings[16]:='100.0000';
      Strings[12]:=Strings[38];
      Strings[13]:=FormatFloat('###.0000',Vl(Strings[16])-Vl(Strings[12]));
      Strings[20]:= Strings[13];
      //strings[20] := FormatFloat('0.0000', MaxR(0,100-Vl( GetMjAlloc(RetNo,'NL') )) ); //jz 20190212 //Tv[20]:=100-Vl(GetMjAlloc(RetNo,'NL'));
      Tv[21]:=Tv[18]*vl(strings[20])/100; //jz 20190212  //Tv[21]:=Tv[18]*Tv[20]/100;

      Tv[29]:=Tv[21];
    end;

    Tv[30]:=MaxR(0,Tv[28]-Tv[29]);
 end;

//NLMJ Page 2-------------------------------------------------------------------
 with ret[RetNo].Frm[Fno] do
 begin
  Tv[101]:=Tv[30];
  If Ret[RetNo].Province = 'NL' then
     Tv[131] := GetPrvForTaxCredit(RetNo,'NL')
  Else
     Tv[131]:=0;
  Tv[132] := MaxR(0,Tv[101] - Tv[131]);

  Tv[107] := GetPrvPolit(RetNo,'NL');
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //  if IsMultJurisdiction(RetNo) then Tv[107]:=Vl(FetchElm(RetNo,'POLIT',50)); //20240510
  If Tv[107] <=100 then x:= Tv[107] * 0.75
  Else if ((Tv[107] >100) and (Tv[107] <=550)) then
        x := (Tv[107]-100) * 0.50 + 75
  Else if Tv[107] >550 then x := (Tv[107]-550) * 0.3333 + 300;
  If x >500 then x :=500;
  //Tv[108]:=x;   //20180325
  Tv[110]:=x;  //Tv[108];  //20180325
  Tv[109]:=MaxR(0,Tv[132]-Tv[110]);
  {20160322 //20160505 Igor
  If Tv[112]>750 then Tv[112]:=750;
  Tv[115]:=MaxR(0,Tv[109]-Tv[112]);
  }
  Tv[117]:=Vl(FetchElm(RetNo,'T1272',107));
  Tv[114]:=MaxR(0,Tv[109]-Tv[117]); //20160505 Igor

  Tv[4]:=Vl(FetchElm(RetNo,'T1297',6));
  Tv[6]:= MaxR(0,Tv[114] - Tv[4]);

  //20160322 //20160505 Igor
  Tv[70]:=Tv[71]+Tv[65];
  Tv[73]:=Tv[70];
  Tv[72]:=MaxR(0,Tv[6]-Tv[73]);  //20160322

  TaxFNo:=GetFormNo('NL428');
  //Tv[102]:=vl(FetchElmFNo(RetNo,TaxFNo,34));  ?? unused
  Tv[103]:=MaxR(0,Tv[72]-Tv[102]);//MaxR(0,Tv[6]-Tv[102]);

//NLMJ Page 3-------------------------------------------------------------------
    Tv[36]:=Tv[103];
    If Strings[121]+Strings[122]= '' then  Strings[121]:= 'X';
    If Strings[121] >'' then
    begin
     //adjusted family income calc
     Tv[151]:=CalcMortgageForeclosure(ret[RetNo].Lnn[12700],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
     Tv[152]:=Vl(FetchElm(RetNo,'FORECLO',4));
     //SELF
     Tv[31] := ret[RetNo].Lnn[23600];
     Tv[32] := ret[RetNo].Lnn[21300];
     Tv[33] := Tv[31]+Tv[32];
     Tv[119] := ret[RetNo].Lnn[11700];//GetTotalUCCB(RetNo);
     Tv[120] := MaxR(0,Tv[33]-Tv[119]);
     //SPOUSE
     Tv[66]:=MaxR(0,Vl(FetchElm(RetNo,'INFO',19))-(Tv[152]));  //spnetincome
     Tv[34]:=Vl(FetchElm(RetNo,'INFO',162));
     Tv[35]:=Tv[66]+Tv[34]; //Vl(FetchElm(RetNo,'INFO',131));
     Tv[67]:=Vl(FetchElm(RetNo,'INFO',131));
     Tv[68]:=MaxR(0,Tv[35]-Tv[67]);
     Tv[69] :=Tv[120]+Tv[68];

     Tv[36]  := Tv[103];

     //20170530
     if Ret[RetNo].Province = 'NL' then
     Begin
      Tv[104]:=vl(FetchElmFNo(RetNo,TaxFNo,140));
      Tv[105]:=vl(FetchElmFNo(RetNo,TaxFNo,141));
      Tv[106]:=vl(FetchElmFNo(RetNo,TaxFNo,142));
     End
     Else
     begin
      Tv[104]:=0;
      Tv[105]:=0;
      Tv[106]:=0;
     end;
     //20200131
     Tv[125]:=Tv[104]+Tv[105]+Tv[106];
     If Tv[125]>1518 then Tv[125]:=1518; //20230423
     Tv[124] := Tv[125]; //needed?

     //20180403
     if Ret[RetNo].Province = 'NL' then
     Begin
      //adjusted family income
      Tv[61]  := Tv[69];

      //jz//20260327//MJCERT2025v2 - add elms, adjust amounts
      Tv[74]:= 40460;
      Tv[75]:= 23928;

      //20220404
      if Tv[105]+Tv[106]>0 then
       Tv[139]:=Tv[74]   //jz//20260327//MJCERT2025v2 - get amount from elm
      Else
       Tv[139]:=Tv[75];  //jz//20260327//MJCERT2025v2 - get amount from elm

      Tv[140]:=MaxR(0,Tv[61]-Tv[139]); //vl(FetchElmFNo(RetNo,TaxFNo,152));
      Tv[141]:=16; //vl(FetchElmFNo(RetNo,TaxFNo,153));
      Tv[142]:=Tv[140]*Tv[141]/100; //vl(FetchElmFNo(RetNo,TaxFNo,154));
      Tv[143]:=Tv[142]; //vl(FetchElmFNo(RetNo,TaxFNo,155));
      Tv[144]:=MaxR(0,Tv[125]-Tv[143]);
      Tv[145]:=Tv[144];
    end
    else
    begin
      Tv[61]  :=0;
      Tv[139]:=0;
      Tv[140]:=0;
      Tv[141]:=0;
      Tv[142]:=0;
      Tv[143]:=0;
      Tv[144]:=0;
      Tv[145]:=0;
    end;
  End;
  Tv[118]:=MaxR(0,Tv[36]-Tv[145]);

  Tv[62] := Tv[145];
  Tv[63] := TV[103]; //?? Tv[6];  /20160322 //20160505 Igor
  Tv[64] := MaxR(0, Tv[62] - Tv[63]);

  { 20230508
  //20170409
  // temp reduction
  If ret[RetNo].Province = 'NL' then
  Begin
   //20180325
   Tv[113]:= Vl(FetchElm(RetNo,'NL428',113)); //Tv[183]:= Vl(FetchElm(RetNo,'NL428',113));
  End;
  Tv[186]:=Tv[118]+Tv[113];//Tv[118]+Tv[183]; //20180307 Tv[185]+Tv[183];  //201
  }
 end;

 SaveTv(RetNo,FName,FNo);
end;

procedure PEMJ(RetNo: integer; FName: String;FNo: integer);
Var
i,j,TaxFNo:Integer;
x,y,z:Real;
T2203FNo:Integer;
Begin
 InitPrvConstants('PE');
 TaxFNo:=GetFormNo('PE428');
 T2203FNo:=GetFormNo('T2203');
 LoadTv(RetNo,FName,FNo);

 If (IsMultJurisdiction(RetNo) = False)
 Or (Vl(GetMjAlloc(RetNo,'PE')) =0) then
 begin
   For i:=1 to 181 do ret[RetNo].Frm[FNo].Tv[i]:=0;
   SaveTv(RetNo,FName,FNo);
   Exit;
 end;

 with ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
   Tv[6]:=Lnn[26000];
   //jz//MJCERT2024//20250506 - FILL BRACKETS

   {
   For i:=36 to 56 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(j,3);
   end;
   }

   //col 1
   i:=200;j:=2;
   while i <= 212 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(i,2);Inc(j,3);
   end;
   //col 2
   i:=201;j:=3;
   while i <= 213 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(i,2);Inc(j,3);
   end;
   //col 3
   i:=36;j:=4;
   while i <= 54 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(i,3);Inc(j,3);
   end;

   //col 4 - NO PATTERN FOR pe428??
   i:=37;j:=116;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=40;j:=117;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=43;j:=121;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=46;j:=159;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=49;j:=164;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=52;j:=169;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=55;j:=174;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));

   //col 5 - NO PATTERN FOR pe428??
   i:=38;j:=179;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=41;j:=182;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=44;j:=183;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=47;j:=184;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=50;j:=185;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=53;j:=186;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
   i:=56;j:=187;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));

   {
   //col 4 - NO PATTERN FOR pe428??
   i:=37;j:=116;
   while i <= 55 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(i,3);Inc(j,3);
   end;

   {
   //col 5 - NO PATTERN FOR pe428??
   i:=38;j:=179;
   while i <= 56 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(i,3);Inc(j,3);
   end;
   }

   Tv[1] := MaxR(Tv[212],MaxR(Tv[213],MaxR(Tv[54],MaxR(Tv[55],Tv[56])))); //jz//20260327//MJCERT2025v2 - add maxr for col 1 and 2
   If SplitIncome(RetNo) then
     Tv[2] := Vl(FetchElm(RetNo,'T1206',103))
   else
     Tv[2] :=0;
   Tv[3] := Tv[1]+Tv[2];

   Tv[4] := Vl(FetchElm(RetNo,'T2203',353));
   If ret[RetNo].Province = 'PE' then
     Tv[8] := Vl(FetchElm(RetNo,'DTC',9))
   else
     Tv[8]:=0;
   Tv[20] := ret[RetNo].Lnn[40427];
   Tv[21] := PrvConstant[RY].PrvAmtCarryOverRate;
   Tv[22] := Tv[20] * Tv[21]/100;
   Tv[23] := Tv[4]+Tv[8]+Tv[22];
   Tv[24] := Tv[23];
   Tv[25] := MaxR(0,Tv[3] - Tv[24]);

   Tv[33] := Vl(FetchElm(RetNo,'T691',316));
   Tv[34]:=57.5;
   Tv[26] := Tv[33] * Tv[34]/100;
   Tv[18] := Tv[25]+Tv[26];


   Frm[FNo].strings[10]:= GetMjAlloc(RetNo,'PE'); //jz 20190212 //Tv[10]:= Vl(GetMjAlloc(RetNo,'PE'));
   Tv[11]:= Tv[18] * vl(Frm[FNo].strings[10])/100; //jz 20190212 //Tv[11]:= Tv[18]*Tv[10] /100;

//PEMJ PAGE 2-------------------------------------------------------------------
   //Tv[7] := Vl(PrvConstant[RY].PrvDivRate);  //20161130 ???
   //Adjustments
   Tv[62]:=Vl(FetchElmFNo(RetNo,T2203FNo,413))+Vl(FetchElmFNo(RetNo,T2203FNo,336))+Vl(FetchElmFNo(RetNo,T2203FNo,422));
   //Tv[62]:=Vl(FetchElm(RetNo,'PE428',68))+Vl(FetchElm(RetNo,'PE428',34))+Vl(FetchElm(RetNo,'PE428',75));
   Tv[63]:=9.8; //Tv[45];
   Tv[12]:= Tv[62] * Tv[63]/100;
   Tv[13]:=Tv[8];

   Tv[15]:=Tv[12]+Tv[13]; //+Tv[14];

    //20210405
   Frm[FNo].Strings[9]:='100.0000';
   Frm[FNo].Strings[14]:=Frm[FNo].Strings[10];
   Frm[FNo].Strings[16]:=FormatFloat('###.0000',Vl(Frm[FNo].Strings[9])-Vl(Frm[FNo].Strings[14]));
   Frm[FNo].Strings[19]:= Frm[FNo].Strings[16];
   Tv[27]:= Tv[15] * vl(Frm[FNo].strings[19])/100;
  // Frm[FNo].strings[19] := FormatFloat('0.0000', MaxR(0,100-Vl(Frm[FNo].strings[10])) ); //jz 20190212 //Tv[19]:=100-Tv[10];
  // Tv[27]:=Tv[15]*vl(Frm[FNo].strings[19])/100; //jz 20190212 //Tv[27]:=Tv[15]*Tv[19]/100;

   Tv[28]:=Tv[27];

   //20180403
  If ret[RetNo].Province <> 'PE' then
  begin
    For i:=12 to 15 do tv[i]:=0;
    Tv[62]:=0;
    Tv[63]:=0;
    Tv[19]:=0;
    Tv[27]:=0;
    Tv[28]:=0;
  end;

   Tv[29]:=MaxR(0,Tv[11]-Tv[28]);

   //jz//20250506//MJCERT2024 - section removed
   {
   //Tv[112]:=Tv[29];
   //PE Island surtax
   Tv[30] := Tv[18];
   Tv[31]:=12500; //5200;
   Tv[32]:=MaxR(0,Tv[30]-Tv[31]);
   Tv[35]:=10;
   Tv[57]:=Tv[32] * Tv[35]/100;

   Frm[FNo].strings[58]:= Frm[FNo].strings[10]; //jz 20190212 //Tv[58]:= Tv[10];
   Tv[59] :=Tv[57] * vl(Frm[FNo].strings[58])/100; //jz 20190212 //Tv[59] :=Tv[57] * Tv[58]/100;

   Tv[60]:=Tv[59];
   Tv[61]:=Tv[112]+Tv[60];
   }

   //Tv[132] := ??? //change to user???

   //Low income tax reduction
   If Frm[FNo].Strings[101]+Frm[FNo].Strings[102] = '' then
      Frm[FNo].Strings[101] := 'X';

   If Frm[FNo].Strings[101] >'' then
   begin
     //adjusted family income calc

     //gains due to mortage foreclosures
     Tv[5]:=CalcMortgageForeclosure(ret[RetNo].Lnn[12700],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
     Tv[7]:=Vl(FetchElm(RetNo,'FORECLO',4));

     //SELF
     Tv[64] := Lnn[23600];
     Tv[65] := ret[RetNo].Lnn[21300];
     Tv[108] := Tv[64]+Tv[65];
     Tv[66] := ret[RetNo].Lnn[11700];//GetTotalUCCB(RetNo);
     Tv[67] := MaxR(0,Tv[108]-Tv[66]);

     //SPOUSE
     Tv[68]:=MaxR(0,Vl(FetchElm(RetNo,'INFO',19))-(Tv[7]));  //spnetincome
     Tv[69]:=Vl(FetchElm(RetNo,'INFO',162));
     Tv[70]:=Tv[68]+Tv[69]; //Vl(FetchElm(RetNo,'INFO',131));
     Tv[71]:=Vl(FetchElm(RetNo,'INFO',131));
     Tv[72]:=MaxR(0,Tv[70]-Tv[71]);

     //Adjusted family income
     Tv[73] :=Tv[67]+Tv[72];
   end;
//PEMJ PAGE 3-------------------------------------------------------------------

   Tv[74] := Tv[29]; //jz//MJCERT2025v1 - pointing to wrong elm //Tv[61];

   If UpperCase(Frm[FNo].Strings[1]) = 'X' then
   begin
     Tv[109] := 250;
     If ret[RetNo].MarStatus < 3 then
      Tv[114] := 250
     else
      Tv[114] :=0;

     If ret[RetNo].Lnn[30425]>0 then
      Tv[115] := 250
     else
      Tv[115] :=0;

     Tv[84]:=MinR(500,Tv[109]+Tv[114]+Tv[115]); //20150314

     Frm[FNo].Strings[118] := IntToStr(MystrToInt(FetchElm(RetNo,'DEPEND',1))
                           -MystrToInt(FetchElm(RetNo,'DEPEND',3))) ;
                           //tot less eqiv to spouse
     Tv[119] := Vl(ret[RetNo].Frm[FNo].Strings[118]) * 200;
   //  Tv[120] := Tv[109] + Tv[114] + Tv[115] + Tv[119];
     Tv[121] := Tv[109]+Tv[89]+Tv[114]+Tv[88]+Tv[115]+Tv[119]; //20170408 //Tv[84]+Tv[119];

     //Adjusted Family income

     Tv[105] := Tv[73];
     Tv[125] := 15000;
     Tv[126] := MaxR(0,(Tv[105] - Tv[125]));
     Tv[127] := 5;
     Tv[128] := Tv[126] * Tv[127] /100;
     Tv[129] := Tv[128];
     Tv[139] := MaxR(0,(Tv[121] - Tv[129]));
     If Tv[132]>0 then
      Tv[134]:=Tv[132]
     else
      Tv[134]:=Tv[139];

     Frm[FNo].strings[140]:= Frm[FNo].strings[10]; //jz 20190212 //[140]:= Tv[10];    //Vl(GetMjAlloc(RetNo,'PE'));
     Tv[130]:=Tv[134] * vl(Frm[FNo].strings[140])/100; //jz 20190212 //Tv[130]:=Tv[134] * Tv[140]/100;

    end
    else
    begin
      Tv[109]:=0;
      For i:=114 to 115 do Tv[i]:=0;
      For i:=118 to 121 do Tv[i]:=0;
      Tv[105]:=0;
      For i:=125 to 129 do Tv[i]:=0;
      Tv[139]:=0; Tv[134]:=0; Tv[140]:=0; Tv[107]:=0; Tv[140]:=0; Tv[130]:=0;
    end;
   If ret[RetNo].Province <> 'PE' then
   begin
    Tv[109]:=0;
    For i:=114 to 115 do Tv[i]:=0;
    For i:=118 to 130 do Tv[i]:=0;
    Tv[130]:=0;
    Tv[139]:=0;
   end;
   Tv[131] :=MaxR(0,Tv[74]-Tv[130]);
   If ret[RetNo].Province = 'PE' then
    Tv[138] := GetPrvForTaxCredit(RetNo,'PE')
   else
    Tv[138]:=0;
   Tv[133] := MaxR(0,Tv[131]-Tv[138]);

   If ret[RetNo].Province = 'PE' then
   begin
         //Polit
         //Tv[106] := GetPrvPolit(RetNo,'PE');
         x := MinR(100,Tv[106]) * 0.75;
         y := MaxR(0,MinR(450,(Tv[106] - 100)) * 0.50);
         z := MaxR(0,(Tv[106] - 550)) * 0.3333;
         Tv[110] := MinR(500,x+y+z);
   end;
   Tv[103]:=MaxR(0,Tv[133]-Tv[110]);
   Tv[81]:=MinR(7000,Tv[78]+Tv[80]);
   Tv[82]:=Tv[81];  //20130317
   Tv[79]:=MaxR(0,Tv[103]-Tv[82]); //20130317 //MaxR(0,Tv[103]-Tv[78]);

   If Tv[83]>1000 then Tv[83]:=1000; //20140504

   Tv[75]:= Tv[139];
   Tv[76]:= Tv[74];
   Tv[77]:= MaxR(0, Tv[75]-Tv[76]);

   TaxFNo:=GetFormNo('PE428');
   For i:=156 to 181 do
   begin
    //jz//MJCERT2024//20250506 - 'claim' elms do not have matching PE428 'claim' elms
    if not( (i=159) or (i=164) or (i=169) or (i=174) or (i=179) ) then
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,i);
   end;
  end;

  SaveTv(RetNo,FName,FNo);
end;


procedure NSMJ(RetNo: integer; FName: String;FNo: integer);
Var
i,j,TaxFNo:Integer;
T2203FNo:Integer;
Begin
  InitPrvConstants('NS');
  TaxFNo:=GetFormNo('NS428');
  T2203FNo:=GetFormNo('T2203');
  LoadTv(RetNo,FName,FNo);

  If (IsMultJurisdiction(RetNo) = False)
  Or (Vl(GetMjAlloc(RetNo,'NS')) =0) then
  begin
    For i:=1 to 172 do ret[RetNo].Frm[FNo].Tv[i]:=0; //20110313
    SaveTv(RetNo,FName,FNo);
    Exit;
  end;

  with ret[RetNo].Frm[Fno] do
  begin
   Tv[22]:=Vl(FetchElmFNo(RetNo,TaxFNo,1));
   J:=2;
   For i:=51 to 71 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,j));
     Inc(j);
   end;
   Tv[72]:=Vl(FetchElmFNo(RetNo,TaxFNo,66));
   Tv[73]:=Vl(FetchElmFNo(RetNo,TaxFNo,68));
   Tv[74]:=Vl(FetchElmFNo(RetNo,TaxFNo,69));
   Tv[75]:=Vl(FetchElmFNo(RetNo,TaxFNo,70));
   Tv[76]:=Vl(FetchElmFNo(RetNo,TaxFNo,71));
   Tv[77]:=Vl(FetchElmFNo(RetNo,TaxFNo,72));
   Tv[78]:=Vl(FetchElmFNo(RetNo,TaxFNo,67));

   For i:=166 to 172 do Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo,i)); //last column

   Tv[30] := MaxR(Tv[172],MaxR(Tv[78],MaxR(Tv[69],MaxR(Tv[70],Tv[71]))));
   If SplitIncome(RetNo) then
     Tv[31] := Vl(FetchElm(RetNo,'T1206',103))
   else
     Tv[31] :=0;
   Tv[32] := Tv[30]+Tv[31];

   //Tv[4] := PrvConstant[RY].PrvDivRate;

   Tv[33] := Vl(FetchElm(RetNo,'T2203',379));
   If ret[RetNo].Province = 'NS' then
     Tv[36] := Vl(FetchElm(RetNo,'DTC',9)) //Tv[35] * Tv[4]/100
   else
     Tv[36]:=0;
   Tv[6] := PrvConstant[RY].PrvAmtCarryOverRate;
   Tv[39] := ret[RetNo].Lnn[40427];
   Tv[40] := Tv[39] * Tv[6]/100;
   Tv[41] := Tv[33]+Tv[36]+Tv[40];
   Tv[42] := Tv[41];
   Tv[43] := MaxR(0,Tv[32] - Tv[42]);
  // Tv[5] := PrvConstant[RY].PrvOverseasRate;

   Tv[1] := Vl(FetchElm(RetNo,'T691',316));
   Tv[25]:=57.5;
   Tv[44] := Tv[1] * Tv[25]/100;
   Tv[12] := Tv[43]+Tv[44];
   Strings[20]:=GetMjAlloc(RetNo,'NS');
   Tv[45] := Tv[12]*Vl(Strings[20])/100;

  // Tv[2]:=Vl(FetchElm(RetNo,'NS428',34));
  //20180403
   Tv[2]:=+Vl(FetchElmFNo(RetNo,T2203FNo,414))+Vl(FetchElmFNo(RetNo,T2203FNo,362));
   Tv[3]:=Tv[2] * Tv[60]/100;
   Tv[7]:=Tv[36];
   Tv[8]:=Tv[38];
   Tv[9]:=Tv[3]+Tv[7]; //+Tv[8];  //20170604

   Strings[38]:='100.0000';
   Strings[80]:=Strings[20];
   Strings[81]:=FormatFloat('###.0000',Vl(Strings[38])-Vl(Strings[80]));
   Strings[10]:= Strings[81];
   //strings[10] := FormatFloat('0.0000', MaxR(0,100-Vl(strings[20])) ); //jz 20190212 // Tv[10]:=100-Vl(Strings[20]);
   Tv[11]      := Tv[9]*vl(strings[10])/100;                            //jz 20190212  //Tv[11]:=Tv[9]*Tv[10]/100;
   Tv[13]:=Tv[11];

   If ret[RetNo].Province <> 'NS' then
   begin
     For i:=2 to 3 do Tv[i]:=0;
     For i:=7 to 11 do Tv[i]:=0;
     Tv[13]:=0;
   end;


   Tv[14]:=MaxR(0,Tv[45]-Tv[13]);

  end;

//NSMJ PAGE 2-------------------------------------------------------------------
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   Tv[101]:=Tv[14]; //Vl(FetchElm(RetNo,'NSMJ',15));

   If ret[RetNo].Province = 'NS' then
    Tv[149] := GetPrvForTaxCredit(RetNo,'NS')
   else
    Tv[149] := 0;

   Tv[150] := MaxR(0,Tv[101] - Tv[149]);
   Tv[127]:=Tv[150]+Tv[126];

   If Frm[FNo].Strings[102]+Frm[FNo].Strings[103]= '' then Frm[FNo].Strings[102] := 'X';

   If UpperCase(Frm[FNo].Strings[102]) = 'X' then //reduction claimed
    begin
     Tv[23]:=Lnn[23600];
     Tv[24]:=Lnn[21300];
     Tv[26]:=Tv[23]+Tv[24];
     Tv[27]:=Lnn[11700];
     Tv[28]:=MaxR(0,Tv[26]-Tv[27]);
     Tv[29]:=Vl(FetchElm(RetNo,'INFO',19));
     Tv[34]:=Vl(FetchElm(RetNo,'INFO',162));
     Tv[35]:=Tv[29]+Tv[34];
     Tv[46]:=Vl(FetchElm(RetNo,'INFO',131));
     Tv[47]:=MaxR(0,Tv[35]-Tv[46]);
     Tv[49]:=Tv[28]+Tv[47];
     Tv[50]:=Tv[127];

     Tv[107] := 300;
     If ret[RetNo].MarStatus < 3 then Tv[108] := 300 else Tv[108] :=0;
     Tv[109]:=Vl(FetchElm(RetNo,'NS428',109)); //20200406 //If ret[RetNo].Lnn[30425]>0 then Tv[109] := 300 else Tv[109] :=0;
     Tv[16]:=MinR(Tv[107]+Tv[108]+Tv[109],600);


     Frm[FNo].Strings[121] :=FetchElm(RetNo,'NS428',121); //20180327
     //?NSTAX  above should exclude if kids were eqiv to spouse
     Tv[110] := Vl(ret[RetNo].Frm[FNo].Strings[121]) * 165;
     Tv[111] := Tv[16]+ Tv[110];  //20150314
    end
    else
    begin
     for i:=107 to 111 do TV[i] :=0;
     Frm[FNo].Strings[121] :='';
     Tv[84]:=0;
    end;

    Tv[48]:=Tv[49];
    Tv[116] := 15000;  //Tv[15];
    Tv[106]:=MaxR(0,Tv[48]-Tv[116]);
    Tv[119]:=5;
    Tv[130]:=Tv[106] * Tv[119]/100;
    Tv[117]:=Tv[130];  //Tv[25] * Tv[19]/100;
    Tv[128]:=MaxR(0,Tv[111]-Tv[117]);
    Tv[84]:=Tv[128];

    If ret[RetNo].Province <> 'NS' then
    begin
     For i:=107 to 111 do Tv[i]:=0;
     For i:=113 to 119 do Tv[i]:=0;
     For i:=125 to 125 do Tv[i]:=0;
     For i:=128 to 128 do Tv[i]:=0;
     Tv[84]:=0;
     Tv[130]:=0;
    end;

    Tv[129]:=Tv[127];
    Tv[124]:=Tv[128];
    Tv[120]:=MaxR(0,Tv[50]-Tv[84]);

    Tv[79]:=Tv[120];
    Tv[85]:= GetPrvPolit(RetNo,'NS');  //20240510
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //if IsMultJurisdiction(RetNo) then Tv[85]:=Vl(FetchElm(RetNo,'POLIT',49)); //20240510
    Tv[105] := Tv[85]*0.75;
    If Tv[105]>750 then Tv[105]:=750;
    Tv[135]:=MaxR(0,Tv[79]-Tv[105]);


    Tv[5]:=Vl(FetchElm(RetNo,'NS428',75));  //20190328
    Tv[8]:=Tv[5]*25/100;
    Tv[17]:=MaxR(0,Tv[135]-Tv[8]);
    TaxFNo:=GetFormNo('NS428');
    Tv[152]:=MinR(2000,Tv[151] * 20/100);
    Tv[153]:=MaxR(0,Tv[17]-Tv[152]);  //Tv[153]:=MaxR(0,Tv[135]-Tv[152]);  //20170530
   // Tv[162]:=MaxR(0,Tv[153]-Tv[164]);
   // Tv[15]:=MaxR(0,Tv[162]-Tv[4]);   //20120324
    Tv[156]:=Vl(FetchElm(RetNo,'T1285',6));
    Tv[15]:=MaxR(0,Tv[153]-Tv[156]);

    Tv[18]:=Vl(FetchElmFNo(RetNo,TaxFNo,155));
    Tv[19]:=MaxR(0,Tv[15]-Tv[18]);

    Tv[21]:=Vl(FetchElmFNo(RetNo,TaxFNo,162));
    Tv[37]:=MaxR(0,Tv[19]-Tv[21]);
    //20150314
    If (ret[RetNo].Age>=65) and (ret[RetNo].Province='NS')
    and (ret[RetNo].Lnn[26000]<24000) then Tv[4]:=1000;

    Tv[123]:=MaxR(0,Tv[37]-Tv[4]);
    Tv[83]:=Vl(FetchElm(RetNo,'NS428',83));   //20210421
    //20190402
    for i:=86 to 100 do begin Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo,i);end;
    Frm[FNo].Strings[157]:=FetchElmFNo(RetNo,TaxFNo,101);
    Frm[FNo].Strings[158]:=FetchElmFNo(RetNo,TaxFNo,158);
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure NBMJ(RetNo: integer; FName: String;FNo: integer);
Var
i, j, TaxFno1:Integer;
x:Real;
T2203FNo:Integer;
Begin
 InitPrvConstants('NB');
 TaxFNo1:=GetFormNo('NB428');
 T2203FNo:=GetFormNo('T2203');

 LoadTv(RetNo,FName,FNo);

 If (IsMultJurisdiction(RetNo) = False)
 Or (Vl(GetMjAlloc(RetNo,'NB')) =0) then
 begin
   For i:=1 to 141 do ret[RetNo].Frm[FNo].Tv[i]:=0;
   SaveTv(RetNo,FName,FNo);
   Exit;
 end;

 with ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:=ret[RetNo].Lnn[26000];
   //jz//MJCERT2024//20250506 - fill brackets
   //col 1,2,3
   j:=2;
   For i:=2 to 22 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;
   //jz//MJCERT2024//20250506 - col 4 - NB428 bracket 4 elms have no pattern
   i:=87;j:=66;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
   i:=88;j:=68;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
   i:=89;j:=69;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
   i:=90;j:=70;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
   i:=91;j:=71;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
   i:=92;j:=72;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
   i:=93;j:=67;Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));

   //jz//MJCERT2024//20250506 - col 4 - NB428 bracket 4 elms have no pattern
   {
   //need for last column here  //20180408
   For i:=87 to 93 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,i);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,i));
   end;
   }

   //jz//MJCERT2024//20250506 - removed
   {
   Tv[55]:=Vl(FetchElmFNo(RetNo,TaxFNo1,66));
   Tv[57]:=Vl(FetchElmFNo(RetNo,TaxFNo1,68));
   Tv[58]:=Vl(FetchElmFNo(RetNo,TaxFNo1,69));
   Frm[FNo].Strings[59]:=FetchElmFNo(RetNo,TaxFNo1,70);
   Tv[60]:=Vl(FetchElmFNo(RetNo,TaxFNo1,71));
   Tv[61]:=Vl(FetchElmFNo(RetNo,TaxFNo1,72));
   Tv[56]:=Vl(FetchElmFNo(RetNo,TaxFNo1,67));
   }




  Tv[30] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[56]));
  Tv[30]:=MaxR(Tv[30],Tv[93]);  //20180408

  If SplitIncome(RetNo) then
    Tv[31] := Vl(FetchElm(RetNo,'T1206',103))
   else
   Tv[31] :=0;
  Tv[32] := Tv[30]+Tv[31];

  Tv[33] := Vl(FetchElm(RetNo,'T2203',553));
  If Province = 'NB' then
    Tv[36] := Vl(FetchElm(RetNo,'DTC',9))
  else
    Tv[36]:=0;
//  Tv[53] := PrvConstant[RY].PrvOverseasRate;
  //If Province = 'NB' then Tv[35] := ret[RetNo].Lnn[12000] else Tv[35]:=0;
  //If Province = 'NB' then Tv[37] := ret[RetNo].Lnn[426] else Tv[37]:=0;
  Tv[39] := ret[RetNo].Lnn[40427];
  Tv[54] := PrvConstant[RY].PrvAMTCarryOverRate;
    //Tv[35] * Tv[52]/100;
  //Tv[38] := Tv[37] * Tv[53]/100;
  Tv[40] := Tv[39] * Tv[54]/100;
  Tv[41] := Tv[33]+Tv[36]+Tv[40];
  Tv[42] := Tv[41];
  Tv[46] := MaxR(0,Tv[32]-Tv[42]);

  //If SubjectToMinTax(RetNo) then
  Tv[64] := MaxR(0,Vl(FetchElm(RetNo,'T691',307))-Vl(FetchElm(RetNo,'T691',308))); //20210206 304 to 307
  Tv[65]:=57;
  Tv[34] := Tv[64] * Tv[65]/100;
  Tv[63]:= Tv[46]+Tv[34];

  Frm[FNo].Strings[62]:=GetMjAlloc(RetNo,'NB');

  Tv[43] := Tv[63]*Vl(Frm[FNo].Strings[62])/100;

  //Tv[23]:=Vl(FetchElm(RetNo,'NB428',34));
     //20180403
  Tv[23]:=Vl(FetchElmFNo(RetNo,T2203FNo,536));

  Tv[24]:=Tv[23] * 9.68/100; //Vl(Frm[FNo].Strings[11])/100;   //20150312
  Tv[25]:=Tv[36];
 // Tv[26]:=Tv[38];
  Tv[27]:=Tv[24]+Tv[25]; //+Tv[26];

 //20210405
  Frm[FNo].Strings[26]:='100.0000';
  Frm[FNo].Strings[37]:=Frm[FNo].Strings[62];
  Frm[FNo].Strings[38]:=FormatFloat('###.0000',Vl(Frm[FNo].Strings[26])-Vl(Frm[FNo].Strings[37]));
  Frm[FNo].Strings[28]:= Frm[FNo].Strings[38];
  Tv[29]:= Tv[27] * vl(Frm[FNo].strings[28])/100;

  Tv[44]:=Tv[29];
  If Province <> 'NB' then
  begin
    For i:=23 to 25 do Tv[i]:=0;
    For i:=27 to 29 do Tv[i]:=0;
    Tv[44]:=0;
  end;
  Tv[45]:=MaxR(0,Tv[43]-Tv[44]);

  If Province = 'NB' then
   Tv[47] := GetPrvForTaxCredit(RetNo,'NB')
  else
   Tv[47] :=0;
  Tv[48] := MaxR(0,Tv[45]-Tv[47]);
 end;


//NBMJ PAGE 2 ------------------------------------------------------------------
  With ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Tv[115]:=vl(FetchElm(RetNo,'NBMJ',48));
    Tv[35] := MaxR(0, Tv[115] - Tv[116]);

    If Frm[FNo].Strings[121]+Frm[FNo].Strings[122]= '' then
             Frm[FNo].Strings[121]:= 'X';
    If Frm[FNo].Strings[121] >'' then
    begin
     //adjusted family income calc
     Tv[151]:=CalcMortgageForeclosure(ret[RetNo].Lnn[12700],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
     Tv[152]:=Vl(FetchElm(RetNo,'FORECLO',4));
     //SELF
     Tv[106] := ret[RetNo].Lnn[23600];
     Tv[107] := ret[RetNo].Lnn[21300]+Vl(FetchElm(RetNo,'OTHDED',60));;
     Tv[108] := Tv[106]+Tv[107];
     Tv[119] := ret[RetNo].Lnn[11700]+ret[RetNo].Lnn[12500];//GetTotalUCCB(RetNo);
     Tv[120] := MaxR(0,Tv[108]-Tv[119]);
     //SPOUSE
     Tv[66]:=MaxR(0,Vl(FetchElm(RetNo,'INFO',19))-(Tv[152]));
     Tv[52]:=Vl(FetchElm(RetNo,'INFO',162));
     Tv[51]:=Tv[66]+Tv[52];
     Tv[67]:=Vl(FetchElm(RetNo,'INFO',131));
     Tv[68]:=MaxR(0,Tv[51]-Tv[67]);
     Tv[69] :=Tv[120]+Tv[68];

     Tv[49]:=Tv[35];

     //20230423
     //701 t o 746 //20240504
     Tv[101] := 781; //684; //678; //665; //651; //641;  //20200131
     If MarStatus <3 then Tv[102] := 781 else Tv[102]:=0;
     If Lnn[30425]>0 then Tv[103] := 781; //684;
     Tv[104] := MinR(1562,Tv[101]+Tv[102]+Tv[103]); //20220404
     //-------------
     Tv[105] := Tv[104];
     //adjusted family income
     Tv[50]  := Tv[69];
     Tv[109] := 21343; //19177; //20240504
     Tv[110] := MaxR(0,Tv[50]-Tv[109]);
     Tv[111] := 3;
     Tv[112] := Tv[110] * Tv[111]/100;
     Tv[113] := Tv[112];
     Tv[118] := MaxR(0,Tv[105]-Tv[113]);
     Tv[114] := Tv[118];
   end
   else
   begin
    Tv[114]:=0;//For i:=101 to 114 do Tv[i]:=0;
    Tv[50]:=0;Tv[118]:=0;
   end;

   If Province <> 'NB' then begin
    Tv[114]:=0;
    For i:=101 to 114 do Tv[i]:=0;
    Tv[50]:=0;Tv[118]:=0;
   end;

   Tv[117] := MaxR(0,Tv[49] - Tv[114]);

//NBMJ Page 3-------------------------------------------------------------------
   Tv[73]:=Tv[117];
   //political contribution
   Tv[124] := GetPrvPolit(RetNo,'NB');   //20240510
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //   if IsMultJurisdiction(RetNo) then Tv[124]:=Vl(FetchElm(RetNo,'POLIT',49)); //20240510

   If Tv[124] <=200 then x:= Tv[124] * 0.75
   Else if ((Tv[124] >200) and (Tv[124] <=550)) then
        x := (Tv[124]-200) * 0.50 + 150
   Else if Tv[124] >550 then x := (Tv[124]-550) * 0.3333 + 325;
   If x >500 then x :=500;
   Tv[129]:=x;
   Tv[132]:=MaxR(0,Tv[73]-Tv[129]);

   //venture capital fund tax credit
   If Tv[135]>2000 then Tv[135]:=2000;
   Tv[123]:=MaxR(0,Tv[132]-Tv[135]);

   //Small business inverstor tax credit
   If Tv[138]>125000 then Tv[138]:=125000; //15000 then Tv[138]:=15000;
   Tv[141]:= MaxR(0,Tv[123]-Tv[138]);

   //unused low-income tax reduction
   Tv[70]:= Tv[114];
   Tv[71]:= Tv[49];
   Tv[72]:= maxR(0, Tv[70] - Tv[71]);
  end;

 SaveTv(RetNo,FName,FNo);
end;

procedure MBMJ(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,TaxFNo1:Integer; x,y,z:Real;
T2203FNo:Integer;
Begin
 InitPrvConstants('MB');
 TaxFNo1:=GetFormNo('MB428');
 T2203FNo:=GetFormNo('T2203');
  LoadTv(RetNo,FName,FNo);
  //20180331
  If (IsMultJurisdiction(RetNo) = False)
  Or (Vl(GetMjAlloc(RetNo,'MB')) =0)
 // Or (Ret[RetNo].Province<>'MB')  //20180331
  then
  begin
   For i:=1 to 130 do ret[RetNo].Frm[FNo].Tv[i]:=0;  //20110313
   SaveTv(RetNo,FName,FNo);
   Exit;
  end;

  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   Tv[1]:=ret[RetNo].Lnn[26000];
   J:=2;
   For i:=6 to 14 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;
   j:=11;
   For i:=20 to 25 do
   begin
     Frm[FNo].Strings[i]:=Alltrim(FetchElmFNo(RetNo,TaxFNo1,j));
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   J:=17;
   For i:=44 to 49 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   Tv[62]:=MaxR(Tv[47],MaxR(Tv[48],Tv[49]));

   //we are in MJrorine
   If SplitIncome(RetNo)=True then  //20230507  //tosi
   Begin
     If (Ret[RetNo].Province = 'MB') then
      Tv[63] := Vl(FetchElm(RetNo,'T1206',119));  //20230507
   end;

   Tv[64]:=Tv[62]+Tv[63];

   Tv[65]:= Vl(FetchElm(RetNo,'T2203',579));
   //Tv[76] := PrvConstant[RY].PrvOverseasRate;

  // If Ret[RetNo].Province = 'MB' then Tv[68] := ret[RetNo].Lnn[426] else Tv[68]:=0;
   If Ret[RetNo].Province = 'MB' then
     Tv[67] := Vl(FetchElm(RetNo,'DTC',9)) //Tv[66] * Tv[75]/100;
   else
     Tv[67]:=0;
   //20170408
   Tv[70] := ret[RetNo].Lnn[40427];
   Tv[77] := PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[71] := Tv[70] * Tv[77]/100;
   Tv[72] := Tv[65]+Tv[67]+Tv[71];
   Tv[73] := Tv[72];
   Tv[74] := MaxR(0,Tv[64]-Tv[73]);
  // Tv[69] := Tv[68] * Tv[76]/100;

   Tv[2]:=MaxR(0,Vl(FetchElm(RetNo,'T691',307))-Vl(FetchElm(RetNo,'T691',308)));  //202106206
   Tv[16]:=50;

   Tv[19]:=Tv[2]*Tv[16]/100;

   Tv[26]:=Tv[74]+Tv[19];

   Frm[FNo].Strings[27]:= GetMjAlloc(RetNo,'MB'); //20190206

   Tv[33]:=Tv[26] * Vl(Frm[FNo].Strings[27])/100;   //20190205
   //Tv[33]:=Tv[26] * Tv[27]/100;

   //Tv[15]:=Vl(FetchElm(RetNo,'MB428',51))+Vl(FetchElm(RetNo,'MB428',67))+Vl(FetchElm(RetNo,'MB428',34))+Vl(FetchElm(RetNo,'MB428',74)); //20120324
   //20180403
   Tv[15]:=Vl(FetchElmFNo(RetNo,T2203FNo,115))+Vl(FetchElmFNo(RetNo,T2203FNo,116))+Vl(FetchElmFNo(RetNo,T2203FNo,580))
           +Vl(FetchElmFNo(RetNo,T2203FNo,65))+Vl(FetchElmFNo(RetNo,T2203FNo,593))
           +Vl(FetchElmFNo(RetNo,T2203FNo,562));

   Tv[50]:=Tv[15] * 10.8/100;
   TV[51]:=Tv[67];
  // TV[52]:=Tv[69];
   Tv[53]:=Tv[50]+Tv[51]+Tv[52];
    //20210405
   Frm[FNo].Strings[17]:='100.0000';
   Frm[FNo].Strings[28]:=Frm[FNo].Strings[27];
   Frm[FNo].Strings[29]:=FormatFloat('###.0000',Vl(Frm[FNo].Strings[17])-Vl(Frm[FNo].Strings[28]));
   Frm[FNo].Strings[54]:= Frm[FNo].Strings[29];
   Tv[3]:= Tv[53] * vl(Frm[FNo].strings[54])/100;

   //Frm[FNo].Strings[54] := FormatFloat('0.0000', 100 - vl(GetMjAlloc(RetNo,'MB'))) ; //Tv[54]:=100-Vl(GetMjAlloc(RetNo,'MB'));
   //Tv[3]:=Tv[53] * Vl(Frm[FNo].Strings[54])/100;    //20190327
   //Tv[3]:=Tv[53] * Tv[54]/100;
   Tv[5]:=Tv[3];
   If Ret[RetNo].Province <> 'MB' then
   begin
     For i:=50 to 54 do Tv[i]:=0;
     Tv[15]:=0;
     Tv[3]:=0;
     Tv[5]:=0;
   end;
   Tv[4]:= MaxR(0,Tv[33]-Tv[5]);
  end;
  //mbmj pg2
    with ret[RetNo].Frm[Fno] do
  begin
     Tv[101] := Vl(FetchElm(RetNo,'MBMJ',4));

     Tv[102] := GetPrvPolit(RetNo,'MB');   //20230422
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //     if IsMultJurisdiction(RetNo)=True then Tv[102]:= Vl(FetchElm(RetNo,'POLIT',47));  //20240510

     x := MinR(100,Tv[102]) * 0.75;
     y := MaxR(0,MinR(450,(Tv[102] - 100)) * 0.50);
     z := MaxR(0,(Tv[102] - 550)) * 0.3333;
     Tv[103] := MinR(500,x+y+z);
     Tv[165]:=Vl(FetchElm(RetNo,'MB428',168)); //20220413
     Tv[104] := MaxR(0,Tv[101]-Tv[103]);

     {lab sp}
     Tv[105] := MinR(750,Vl(FetchElm(RetNo,'T5006',4)));

     Tv[109] := MaxR(0,Tv[104] -Tv[105]);

     If ret[RetNo].Province ='MB' then
      Tv[110] := GetPrvForTaxCredit(RetNo,'MB')
     Else
      Tv[110]:=0;
     Tv[146]:=MaxR(0,Tv[109]-Tv[110]);

     If Tv[165]>9000 then Tv[165]:=9000;
     Tv[164]:=MaxR(0,Tv[146]-Tv[165]);
     Tv[112]:=Vl(FetchElm(RetNo,'T12561',4));  //jz//20260329//MJCERT2025 - wrong elm, changed from 6
     If Tv[112]>120000 then Tv[112]:=120000;   //20220404
     //If Tv[112]>67500 then Tv[112]:=67500;   //20150312
     Tv[113]:=MaxR(0,Tv[164]-Tv[112]);
     TV[148]:=Vl(FetchElm(RetNo,'T12562',20));//20150312
     Tv[129] := MaxR(0,Tv[113] - Tv[148]);
     Tv[147]:=Vl(FetchElm(RetNo,'T1241',6));
     Tv[138]:=MaxR(0,Tv[129]-Tv[147]);
     Tv[130] := Vl(FetchElm(RetNo,'T1005',11));

     Tv[111] := MaxR(0,Tv[138]-Tv[130]);   //20150312
  end;
  SaveTv(RetNo,FName,FNo);
end;

procedure SKMJ(RetNo: integer; FName: String;FNo: integer);
Var i,j,TaxFNo1:Integer;DepFNo:Integer;
T2203FNo:Integer;
Begin
 InitPrvConstants('SK');
 TaxFNo1:=GetFormNo('SK428');
 T2203FNo:=GetFormNo('T2203');
 LoadTv(RetNo,FName,FNo);

 If (IsMultJurisdiction(RetNo) = False)
 Or (Vl(GetMjAlloc(RetNo,'SK')) =0) then
 begin
   For i:=1 to 166 do ret[RetNo].Frm[FNo].Tv[i]:=0;  //20100313
   SaveTv(RetNo,FName,FNo);
   Exit;
 end;


  with ret[RetNo].Frm[Fno] do
  begin
   Tv[43]:=ret[RetNo].Lnn[26000];
   J:=2;
   For i:=30 to 38 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   J:=11;
   For i:=46 to 57 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   Tv[1] := MaxR(Tv[55],MaxR(Tv[56],Tv[57]));
   Tv[39]:=MaxR(0,Tv[1]-Tv[5]);

   If SplitIncome(RetNo) then
     Tv[2] := Vl(FetchElm(RetNo,'T1206',103))
    else
     Tv[2] :=0;
    Tv[3] := Tv[39]+Tv[2];

    Tv[4] :=Vl(FetchElm(RetNo,'T2203',653));

    Tv[7] := Vl(PrvConstant[RY].PrvDivRate); //20161130
    //   Tv[10] := PrvConstant[RY].PrvOverseasRate;
      //If ret[RetNo].Province = 'SK' then Tv[6] := ret[RetNo].Lnn[12000] else Tv[6]:=0;
   //    If ret[RetNo].Province = 'SK' then Tv[9] := ret[RetNo].Lnn[426] else Tv[9]:=0;
    If ret[RetNo].Province = 'SK' then
      Tv[8] := Vl(FetchElm(RetNo,'DTC',9)) //Tv[6] * Tv[7]/100;
    else
      Tv[8]:=0;
    Tv[12] := ret[RetNo].Lnn[40427];
    Tv[13] := PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[14] := Tv[12] * Tv[13]/100;
    Tv[15] := Tv[4]+Tv[8]+Tv[14]; //20180325
    Tv[16] := Tv[15];
    Tv[40]:=MaxR(0,Tv[3]-Tv[16]);

    If SubjectToMinTax(RetNo) then
     Tv[41] := Vl(FetchElm(RetNo,'T1219',111))
    else
     Tv[41] :=0; //MaxR(0,Tv[3]-Tv[16]);
    Tv[44]:=Tv[40]+Tv[41];
    Strings[42]:=GetMjAlloc(RetNo,'SK');
    Tv[17] := Tv[44]*Vl(Strings[42])/100;

   // Tv[20]:= Vl(FetchElm(RetNo,'SK428',34));
   //20180403
    Tv[20]:=Vl(FetchElmFNo(RetNo,T2203FNo,636));

    Tv[21]:= Tv[20]* 10.75/100; //+Tv[46]/100; //20180325
    Tv[22]:=Tv[8];
   // Tv[23]:=Tv[11];
    Tv[24]:=Tv[21]+Tv[22]; //+Tv[23]; //20180325

    //20210405
   Strings[6]:='100.0000';
   Strings[7]:=Strings[42];
   Strings[9]:=FormatFloat('###.0000',Vl(Strings[6])-Vl(Strings[7]));
   Strings[25]:= Strings[9];
   Tv[26]:= Tv[24] * vl(strings[25])/100;

   //strings[25] := FormatFloat('0.0000', MaxR(0,100-Vl(strings[42])) ); //jz 20190212 //Tv[25]:=100-Vl(Strings[42]);
   // Tv[26]:=Tv[24]*vl(strings[25])/100; //jz 20190212 //Tv[26]:=Tv[24]*Tv[25]/100;

    Tv[27]:=Tv[26];
    If ret[RetNo].Province<>'SK' then
    begin
     For i:=20 to 27 do Tv[i]:=0;
    end;
    Tv[18] := MaxR(0,Tv[17]-Tv[27]);


    If ret[RetNo].Province='SK' then
     Tv[19] := GetPrvForTaxCredit(RetNo,'SK')
    else
     Tv[19]:=0;

    Tv[28] := MaxR(0,Tv[18]-Tv[19]);
    //Tv[58]:=MaxR(0,Tv[28]-Tv[29]);
  end;
  //pg 2
  with ret[RetNo].Frm[Fno] do
  begin
    Tv[111] := Tv[28];

    Tv[106] := GetPrvPolit(RetNo,'SK'); //20240510
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //    if IsMultJurisdiction(RetNo) then Tv[106]:=Vl(FetchElm(RetNo,'POLIT',56)); //20240510

    //Tv[107]:=0;  //20110128
    If Tv[106] <=200 then Tv[107]:= Tv[120] * 0.75
    else If (Tv[106] >200) and (Tv[106] <=550) then
      Tv[107]:= (Tv[106]-200) * 0.50 + 150
    else  If (Tv[106] >550) and (Tv[106] <=1075) then
      Tv[107]:= (Tv[106]-550) * 0.3333 + 325
    else If (Tv[106] >1075) then Tv[107]:= 500;
    Tv[108] := MaxR(0,Tv[111]-Tv[107]);

    If Tv[109]>1000 then Tv[109]:=1000; //MinR(1000,Tv[109]);  //20110128
    If Tv[110]>1000 then Tv[110]:=1000;  //   Tv[110] := MinR(525,Tv[110]);  //20110128
    Tv[113] := MinR(1000,Tv[109]+Tv[110]);
    Tv[112] := Tv[113];
    If ret[RetNo].Province <> 'SK' then
      begin Tv[109]:=0;Tv[110]:=0;Tv[113]:=0;Tv[112]:=0; end;

    //TV[10]:= ???
    Tv[114]:=MaxR(0,Tv[108]-Tv[112]);
    //20230408
   // Tv[115]:=Vl(FetchElm(RetNo,'SK428',106)); //20180325
   // Tv[103]:=MaxR(0,Tv[114]-Tv[115]);  //20180325
    //20180325

    Tv[10]:=Vl(FetchElm(RetNo,'SK428',106)); //20230408
    Tv[117]:=Tv[10]*10/100; //Vl(FetchElm(RetNo,'SK428',106));  //20180325
    Tv[124]:=Vl(FetchElm(RetNo,'SK428',134));  //20180325

    Tv[118]:=Tv[117]+Tv[124];
    Tv[120]:=Tv[118];
    Tv[101]:=MaxR(0,Tv[114]-Tv[120]);  // 20230422 //MaxR(0,Tv[103]-Tv[120]);

    Tv[168]:=Vl(FetchElm(RetNo,'RC360',20));  //20150314
    Tv[169]:=MaxR(0,Tv[101]-Tv[168]);
    Tv[102]:=Vl(FetchElm(RetNo,'SK428',134));  //20180325

    Tv[127] := MaxR(0,Tv[169]-Tv[102]); //20150314

    {carry back}
    Tv[121]:=Tv[120];
    Tv[123]:=Tv[103]; //Tv[166]; //20180325
    Tv[125]:=MaxR(0,Tv[121]-Tv[123]);

    Tv[126]:=Vl(FetchElm(RetNo,'SK428',80));  //20180325
    Tv[128]:=Vl(FetchElm(RetNo,'SK428',81));  //20180325
    Tv[129]:=Vl(FetchElm(RetNo,'SK428',82));  //20180325

    For i:=131 to 146 do Strings[i]:='';
    If (ret[RetNo].Province='SK')
     and (GetPrvNetIncome(RetNo,'SK')< SpouseIncome(RetNo)) then
    begin
     i:=131;j:=5; {j:index to depend}
     DepFNo:=GetFormNo('DEPEND');
     repeat
      If (FetchElmFNo(RetNo,DepFNo,j) >'')
      and (CalcAge(FetchElmFNo(RetNo,DepFNo,j+5)) <=18)
      and (
            (FetchElmFNo(RetNo,DepFNo,j+6) ='Child')
         or (FetchElmFNo(RetNo,DepFNo,j+6) ='Daughter')
         or (FetchElmFNo(RetNo,DepFNo,j+6) ='Son')
          )
      then
      begin
       Strings[i]:=FetchElmFNo(RetNo,DepFNo,j)
            +' '+FetchElmFNo(RetNo,DepFNo,j+1); {Nm}
       Strings[i+1]:=FetchElmFNo(RetNo,DepFNo,j+6); {Relat}
       Strings[i+2]:=FetchElmFNo(RetNo,DepFNo,j+5); {birth}
       Strings[i+3]:=FetchElmFNo(RetNo,DepFNo,j+2); {Nm}
       Inc(i,4);
      end;
      Inc(j,15);
     until (j>125) or (i>143);
    end;
  end;

  SaveTv(RetNo,FName,FNo);
end;

//20251125 Igor >>>
procedure BCMJ(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, TaxFNo1: Integer;
  x, y, z: Real;
  T2203FNo: Integer;
begin
  InitPrvConstants('BC');
  TaxFNo1:= GetFormNo('BC428');
  T2203FNo:= GetFormNo('T2203');

  with Ret[RetNo].Frm[FNo] do
  begin
    if not IsMultJurisdiction(RetNo) or (Vl(GetMjAlloc(RetNo,'BC')) = 0) then
    begin
      for i:= 1 to 103 do Tv[i]:= 0;
      for i:= 106 to 113 do Tv[i]:= 0;
      //for i:= 1 to 113 do Tv[i]:= 0;
      SaveTv(RetNo, FName, FNo);
      Exit;
    end;
  end;

  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    Tv[5]:= Ret[RetNo].Lnn[26000];
    J:= 2;
    for i:= 6 to 20 do
    begin
      Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
      Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
      Inc(j);
    end;
    //Tv[104]:= Vl(FetchElmFNo(RetNo, TaxFNo1, 124));  //polit contr //20210419  manual entry

    J:= 17;
    for i:= 53 to 58 do
    begin
      Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, j);
      Tv[i]:= Vl(FetchElmFNo(RetNo, TaxFNo1, j));
      Inc(j);
    end;

    J:= 66;
    for i:= 63 to 69 do
    begin
      Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, j);
      Tv[i]:= Vl(FetchElmFNo(RetNo, TaxFNo1, j));
      Inc(j);
    end;

    J:= 73;
    for i:= 70 to 76 do
    begin
      Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, j);
      Tv[i]:= Vl(FetchElmFNo(RetNo, TaxFNo1, j));
      Inc(j);
    end;

    J:= 90;
    for i:= 90 to 96 do
    begin
      Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, j);
      Tv[i]:= Vl(FetchElmFNo(RetNo, TaxFNo1, j));
      Inc(j);
    end;

    J:= 103;
    for i:= 133 to 139 do
    begin
      Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, j);
      Tv[i]:= Vl(FetchElmFNo(RetNo, TaxFNo1, j));
      Inc(j);
    end;

    Tv[32]:= MaxR(Tv[56], MaxR(Tv[57], Tv[58]));
    Tv[32]:= MaxR(Tv[32], MaxR(Tv[69], Tv[76]));
    Tv[32]:= MaxR(Tv[32], Tv[96]);
    Tv[32]:= MaxR(Tv[32], Tv[139]);

    if (SplitIncome(RetNo)) and (isMultJurisdiction(RetNo)) then Tv[33]:= Vl(FetchElm(RetNo, 'T1206', 18)) else Tv[33]:= 0;

    Tv[34]:= Tv[32] + Tv[33];
    Tv[35]:= Vl(FetchElm(RetNo, 'T2203', 627));

    if Ret[RetNo].Province.Equals('BC') then Tv[38]:= Vl(FetchElm(RetNo, 'DTC', 9)) else Tv[38]:= 0;

    Tv[41]:= ret[RetNo].Lnn[40427];
    Tv[52]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[42]:= Tv[41] * Tv[52] / 100;
    Tv[43]:= Tv[35] + Tv[38] + tv[42];
    Tv[44]:= Tv[43];
    Tv[45]:= MaxR(0, Tv[34] - Tv[44]);
    Tv[39]:= MaxR(0, Vl(FetchElm(RetNo, 'T691', 307)) - Vl(FetchElm(RetNo, 'T691', 308)));
    Tv[22]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[46]:= Tv[39] * Tv[22] / 100;
    Tv[3]:= Tv[45] + Tv[46];
    Strings[4]:= GetMjAlloc(RetNo, 'BC');
    Tv[47]:= Tv[3] * Vl(Strings[4]) / 100;
    Tv[36]:= Tv[47];
    Tv[50]:= Vl(PrvConstant[RY].PrvDivRate);
    Tv[1]:= Vl(FetchElmFNo(RetNo, T2203FNo, 123)) + Vl(FetchElmFNo(RetNo, T2203FNo, 124)) + Vl(FetchElmFNo(RetNo, T2203FNo, 681)) + Vl(FetchElmFNo(RetNo, T2203FNo, 610));
    Tv[2]:= Tv[15];
    Tv[24]:= Tv[1] * Tv[15] / 100;
    Tv[25]:= Tv[38];
    Tv[27]:= Tv[24] + Tv[25];
    Strings[21]:= '100.0000';
    Strings[23]:= Strings[4];
    Strings[26]:= FormatFloat('###.0000', Vl(Strings[21]) - Vl(Strings[23]));
    Strings[28]:= Strings[26];
    Tv[29]:= Tv[27] * vl(strings[28]) / 100;
    Tv[30]:= Tv[29];

    if not Ret[RetNo].Province.Equals('BC') then
    begin
      Tv[1]:= 0;
      for i:= 24 to 30 do Tv[i]:= 0;
      for i:= 1 to 2 do Tv[i]:= 0;
      for i:= 24 to 25 do Tv[i]:= 0;
      for i:= 27 to 31 do Tv[i]:= 0;

      Tv[48]:= 0
    end else
      Tv[48]:= GetPrvForTaxCredit(RetNo, 'BC');

    Tv[31]:= MaxR(0, Tv[36] - Tv[30]);
    Tv[49]:= MaxR(0, Tv[31] - Tv[48]);

    //cfr Page 2
    Tv[103]:= TV[49];
    xx:= Ret[RetNo].lnn[23600];
    Tv[114]:= 562 * Ret[RetNo].PartYear;
    Tv[115]:= Ret[RetNo].Lnn[23600];
    Tv[116]:= 25020 * Ret[RetNo].PartYear;
    Tv[117]:= MaxR(0, Tv[115] - Tv[116]);
    Tv[118]:= 3.56;
    Tv[119]:= Tv[117] * Tv[118] / 100;
    Tv[120]:= Tv[119];
    Tv[121]:= MaxR(0, Tv[114] - Tv[120]);
    Strings[122]:= Strings[4];   //
    Tv[123]:= Tv[121] * vl(strings[122]) / 100;
    Tv[124]:= Tv[123];

    if not Ret[RetNo].Province.Equals('BC') then
      for i:= 114 to 124 do Tv[i]:= 0;

    Tv[125]:= MaxR(0, Tv[103] - Tv[124]);
    Tv[127]:= MaxR(0, Tv[125] - Tv[126]);

    if (Vl(GetMjAlloc(RetNo, 'BC')) = 0) then Tv[104]:= 0;

    Tv[104]:= GetPrvPolit(RetNo,'BC');
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //    if IsMultJurisdiction(RetNo) then Tv[104]:= Vl(FetchElm(RetNo, 'POLIT', 46));  //20240510

    x:= MinR(100, Tv[104]) * 0.75;
    y:= MinR(450, MaxR(0,(Tv[104] - 100))) * 0.50;
    z:= MaxR(0,(Tv[104] - 550)) * (33.33 / 100);
    Tv[105]:= MinR(500, x + y + z);
    Tv[106]:= MaxR(0, Tv[127] - Tv[105]);

    if not Ret[RetNo].Province.Equals('BC') then Tv[108]:= 0;

    Tv[109]:= MinR(2000, Tv[107] + Tv[108]);
    Tv[110]:= Tv[109];
    Tv[101]:= MaxR(0, Tv[106] - Tv[110]);
    Tv[111]:= Vl(FetchElm(RetNo, 'T1231', 7));

    if not Ret[RetNo].Province.Equals('BC') then Tv[111]:= 0;

    Tv[113]:= MaxR(0, Tv[101] - Tv[111]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

procedure NTMJ(RetNo: integer; FName: String;FNo: integer);
Var i,j,TaxFNo1:Integer;
T2203FNo:Integer;
Begin
 InitPrvConstants('NT');
 TaxFNo1:=GetFormNo('NT428');
 T2203FNo:=GetFormNo('T2203');

 LoadTv(RetNo,FName,FNo);

 If (IsMultJurisdiction(RetNo) = False)
 Or (Vl(GetMjAlloc(RetNo,'NT')) =0) then
 begin
   For i:=1 to 71 do ret[RetNo].Frm[FNo].Tv[i]:=0;
   SaveTv(RetNo,FName,FNo);
   Exit;
 end;

 with ret[RetNo], ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:=Lnn[26000];
   J:=2;
   For i:=2 to 22 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;
   J:=66;
   For i:=66 to 72 do
   begin
     Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   Tv[30] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[67]));
   If SplitIncome(RetNo) then
     Tv[31] := Vl(FetchElm(RetNo,'T1206',103))
    else
    Tv[31] :=0;
   Tv[32] := Tv[30]+Tv[31];

  // ShowMessage(FetchElm(RetNo,'T2203',853));      //20190317

   Tv[33] := Vl(FetchElm(RetNo,'T2203',853));

   If Province = 'NT' then
     Tv[36] := vl(FetchElm(RetNo,'DTC',9)) //Tv[35] * Tv[52]/100;
   else
     Tv[36]:=0;
   Tv[39] := ret[RetNo].Lnn[40427];
   Tv[54] := PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[40] := Tv[39] * Tv[54]/100;
   Tv[41] := Tv[33]+Tv[36]+Tv[38]+Tv[40];
   Tv[42] := Tv[41];
   Tv[43] := MaxR(0,Tv[32]-Tv[42]);

   Tv[23]:=Vl(FetchElm(RetNo,'T691',316));
   Tv[24]:= Tv[54];
   Tv[46]:=Tv[23]*Tv[24]/100;
   Tv[45] := Tv[43]+Tv[46];
   Frm[FNo].Strings[48]:=GetMjAlloc(RetNo,'NT');
   Tv[62] := Tv[45]*Vl(Frm[FNo].Strings[48])/100;

   //20180325
   //Tv[28]:=Vl(FetchElm(RetNo,'T2203',128)); //20180325
      //20180403
   Tv[28]:=Vl(FetchElmFNo(RetNo,T2203FNo,836));


   Tv[29]:=Tv[28]*5.9/100;
   Tv[34]:=TV[36];
   Tv[35]:=Tv[29]+Tv[34];

     //20210405
   Frm[FNo].Strings[50]:='100.0000';
   Frm[FNo].Strings[51]:=Frm[FNo].Strings[48];
   Frm[FNo].Strings[52]:=FormatFloat('###.0000',Vl(Frm[FNo].Strings[50])-Vl(Frm[FNo].Strings[51]));
   Frm[FNo].Strings[37]:= Frm[FNo].Strings[52];
   Tv[38]:= Tv[35] * vl(Frm[FNo].strings[37])/100;
    //Tv[37]:=100-Tv[48];
   //Tv[38]:=Tv[35] * Tv[37]/100;
   Tv[44]:=Tv[38];
   if Ret[retNo].Province<>'NT' then
   Begin
    for i:=28 to 29 do Tv[i]:=0;
    for i:=34 to 35 do Tv[i]:=0;
    for i:=37 to 38 do Tv[i]:=0;
    Tv[44]:=0;
   End;

   Tv[49]:=MaxR(0,Tv[62]-Tv[44]);
   If Province = 'NT' then
    Tv[47] := GetPrvForTaxCredit(RetNo,'NT')
   else
    Tv[47]:=0;
   Tv[27]:=MaxR(0,Tv[49]-Tv[47]);  //20180325

  // Tv[52] := Vl(PrvConstant[RY].PrvDivRate);  //20180325
   //Tv[53] := PrvConstant[RY].PrvOverseasRate;
   //Tv[35] := ret[RetNo].Lnn[12000];
   // Tv[37] := ret[RetNo].Lnn[426];
   //Tv[38] := Tv[37] * Tv[53]/100;

   Tv[25]:=Vl(FetchElm(RetNo,'NT428',124));
   Tv[26]:=Vl(FetchElm(RetNo,'NT428',125));

   if IsMultJurisdiction(RetNo)=True then //20240510
   Begin

     Tv[25]:= GetPrvPolit(RetNo,'NT');
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //Tv[25]:= Vl(FetchElm(RetNo,'POLIT',51));
     If Tv[25] <= 100 then Tv[26] :=Tv[25]
     else If (Tv[25]>100) then
       Tv[26]:= Tv[26]+(Tv[25]-100) * 0.50;
     if Tv[26]>500 then Tv[26]:=500;
   End;

   //TV[26] ???
   // Tv[44] := MaxR(0,Tv[27]-Tv[26]);
   //Tv[64]:=MaxR(0,Tv[44]-Tv[63]);
   Tv[64]:=MaxR(0,Tv[27]-Tv[26]);
  end;
  SaveTv(RetNo,FName,FNo);
end;

//20251125 Igor >>>
procedure NUMJ(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, TaxFNo1: Integer;
  T2203FNo: Integer;
begin
  InitPrvConstants('NU');
  TaxFNo1:= GetFormNo('NU428');
  T2203FNo:= GetFormNo('T2203');
  LoadTv(RetNo, FName, FNo);

  if not IsMultJurisdiction(RetNo) or (Vl(GetMjAlloc(RetNo,'NU')) = 0) then
  begin
    For i:= 1 to 87 do Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    SaveTv(RetNo, FName, FNo);
    Exit;
  end;

  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    Tv[1]:= Lnn[26000];
    J:= 2;
    for i:= 2 to 22 do
    begin
      Frm[FNo].Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, j);
      Tv[i]:= Vl(FetchElmFNo(RetNo, TaxFNo1, j));
      Inc(j);
    end;
    I:= 66;
    J:= 66;
    for i:= 66 to 72 do
    begin
      Frm[FNo].Strings[i]:= FetchElmFNo(RetNo, TaxFNo1, j);
      Tv[i]:= Vl(FetchElmFNo(RetNo, TaxFNo1, j));
      Inc(j);
    end;

    Tv[49]:= PrvConstant[RY].PrvNonRefundRate;
    Tv[23]:= Lnn[33500];
    Tv[24]:= Lnn[33500] * Tv[49] / 100;
    Tv[25]:= Lnn[32005];
    Tv[50]:= PrvConstant[RY].PrvDonRate1;
    Tv[51]:= PrvConstant[RY].PrvDonRate2;
    Tv[25]:= Lnn[32005];
    Tv[26]:= Tv[25] * Tv[50] / 100;
    Tv[27]:= Lnn[34700];
    Tv[28]:= Tv[27] * Tv[51] / 100;
    Tv[29]:= Tv[24] + Tv[26] + Tv[28];
    Tv[30]:= MaxR(MaxR(Tv[20], Tv[21]), MaxR(Tv[22], Tv[67]));

    if SplitIncome(RetNo) then Tv[31]:= Vl(FetchElm(RetNo, 'T1206', 103)) else Tv[31]:= 0;

    Tv[32]:= Tv[30] + Tv[31];
    Tv[33]:= Vl(FetchElm(RetNo, 'T2203', 879));

    if Ret[RetNo].Province.Equals('NU') then Tv[36]:= Vl(FetchElm(RetNo, 'DTC', 9)) else Tv[36]:= 0;

    // Tv[53]:= PrvConstant[RY].PrvOverseasRate;
    Tv[39]:= ret[RetNo].Lnn[40427];
    Tv[54]:= PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[40]:= Tv[39] * Tv[54] / 100;
    //Tv[37]:= ret[RetNo].Lnn[426];
    //Tv[38]:= Tv[37] * Tv[53]/100;
    Tv[41]:= Tv[33] + Tv[36] + Tv[40];
    Tv[42]:= Tv[41];
    Tv[43]:= MaxR(0, Tv[32] - Tv[42]);
    Tv[23]:= Vl(FetchElm(RetNo, 'T691', 316));
    Tv[24]:= 45;
    Tv[46]:= Tv[23] * Tv[24] / 100;
    Tv[45]:= Tv[43] + Tv[46];
    Frm[FNo].Strings[48]:= GetMjAlloc(RetNo, 'NU');
    Tv[62]:= Tv[45] * Vl(Frm[FNo].Strings[48]) / 100;
    Tv[37]:= Vl(FetchElmFNo(RetNo,T2203FNo, 802)) + Vl(FetchElmFNo(RetNo, T2203FNo, 862));
    Tv[38]:= Tv[37] * 0.04;
    Tv[52]:= Tv[36];
    Tv[53]:= Tv[38] + Tv[52];

    //20210405
    Frm[FNo].Strings[92]:= '100.0000';
    Frm[FNo].Strings[93]:= Frm[FNo].Strings[48];
    Frm[FNo].Strings[94]:= FormatFloat('###.0000', Vl(Frm[FNo].Strings[92]) - Vl(Frm[FNo].Strings[93]));
    Frm[FNo].Strings[88]:= Frm[FNo].Strings[94];
    Tv[89]:= Tv[53] * vl(Frm[FNo].strings[88]) / 100;
    //Frm[FNo].strings[88] := FormatFloat('0.0000', MaxR(0,100-Vl( GetMjAlloc(RetNo,'NU') )) ); //jz 20190212 // Tv[88]:=100-Vl(GetMjAlloc(RetNo,'NU'));
    //Tv[89]:=Tv[53]*vl(Frm[FNo].strings[88])/100; //jz 20190212 //Tv[89]:=Tv[53]*Tv[88]/100;
    Tv[90]:= Tv[89];

    if not Ret[RetNo].Province.Equals('NU') then
    begin
      for i:= 38 to 38 do Tv[i]:= 0;
      for i:= 52 to 53 do Tv[i]:= 0;
      for i:= 88 to 90 do Tv[i]:= 0;
    end;

    Tv[91]:= MaxR(0, Tv[62] - Tv[90]);

    if Province.Equals('NU') then Tv[47]:= GetPrvForTaxCredit(RetNo, 'NU') else Tv[47]:= 0;

    Tv[28]:= MaxR(0, Tv[91] - Tv[47]);
    Tv[35]:=Vl(FetchElm(RetNo, 'NU428', 74));

    if (Tv[35] > 722) then Tv[35]:= 722;

    Tv[44]:= MaxR(0, Tv[28] - Tv[35]);
    TaxFNo1:= GetFormNo('NU428');

    for i:= 55 to 87 do Frm[FNo].Strings[i]:= FetchElmFNo(RetNo, TaxFno1, i + 100);

    Frm[FNo].Strings[49]:= FetchElmFNo(RetNo, TaxFno1, 105);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251125 Igor <<<

procedure YTMJ(RetNo: integer; FName: String;FNo: integer);
Var i,j,TaxFNo1:Integer; x:real;
T2203FNo:Integer;
Begin

 InitPrvConstants('YT');
 TaxFNo1:=GetFormNo('YT428');
 T2203FNo:=GetFormNo('T2203');
 //20160322 //20160505 Igor
 For i:=2 to 22 do Ret[RetNo].Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,i);
 For i:=66 to 72 do Ret[RetNo].Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,i);
 For i:=76 to 76 do Ret[RetNo].Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,i); //20240508
 For i:=83 to 89 do Ret[RetNo].Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,i);
 For i:=90 to 99 do Ret[RetNo].Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,i);
 Ret[RetNo].Frm[FNo].Strings[100]:=FetchElmFNo(RetNo,TaxFNo1,100);
 Ret[RetNo].Frm[FNo].Strings[106]:=FetchElmFNo(RetNo,TaxFNo1,106);
 Ret[RetNo].Frm[FNo].Strings[109]:=FetchElmFNo(RetNo,TaxFNo1,109);
 Ret[RetNo].Frm[FNo].Strings[113]:=FetchElmFNo(RetNo,TaxFNo1,113);

 LoadTv(RetNo,FName,FNo);
 If (IsMultJurisdiction(RetNo) = False)
 Or (Vl(GetMjAlloc(RetNo,'YT')) =0) then
 begin
   For i:=1 to 123 do ret[RetNo].Frm[FNo].Tv[i]:=0;  //20110313
   SaveTv(RetNo,FName,FNo);
   Exit;
 end;

 with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   Tv[1]:=ret[RetNo].Lnn[26000];
  //20160322 //20160505 Igor
  Tv[30] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[67]));
  Tv[30] := MaxR(Tv[30],Tv[89]);

  If SplitIncome(RetNo) then
    Tv[31] := Vl(FetchElm(RetNo,'T1206',103))
   else
   Tv[31] :=0;
   Tv[32] := Tv[30]+Tv[31];

   Tv[33] := Vl(FetchElm(RetNo,'T2203',911));
   If ret[RetNo].Province = 'YT' then
    Tv[36] := vl(FetchElm(RetNo,'DTC',9))   //Tv[35] * Tv[52]/100;
   else
    Tv[36]:=0;
   Tv[39] := ret[RetNo].Lnn[40427];
   Tv[54] := PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[40] := Tv[39] * Tv[54]/100;
   Tv[41] := Tv[33]+Tv[36]+Tv[40];
   Tv[42] := Tv[41];
   Tv[43] := MaxR(0,Tv[32]-Tv[42]);

   Tv[45] := PrvConstant[RY].PrvAMTCarryOverRate; //20160505 Igor
   Tv[46] := Vl(FetchElm(RetNo,'T1219',126)) * Tv[44]/100;  //20160322 //20160505 Igor

   Tv[64] := Tv[43]+Tv[46];
   Frm[FNo].Strings[65]:=GetMjAlloc(RetNo,'YT');
   Tv[62] := Tv[64]*Vl(Frm[FNo].Strings[65])/100;

   If ret[RetNo].Province='YT' then  //20150314
   Begin
   //58189, 58310, 58326,  58330, and 58360
   Tv[23]:=Vl(FetchElmFNo(RetNo,T2203FNo,807))  //58189
   +Vl(FetchElmFNo(RetNo,T2203FNo,803))      //58310
   +Vl(FetchElmFNo(RetNo,T2203FNo,114))     //58326
   +Vl(FetchElmFNo(RetNo,T2203FNo,805))     //58330
   +Vl(FetchElmFNo(RetNo,T2203FNo,894));    //58360
   //   +Vl(FetchElmFNo(RetNo,T2203FNo,804))  //2020402

    Tv[24]:=6.4;
    Tv[25]:=Tv[23]*Tv[24]/100;
    Tv[34]:=Tv[36];
    Tv[35]:=Tv[25]+Tv[34];

    //20210405
    Frm[FNo].Strings[37]:='100.0000';
    Frm[FNo].Strings[38]:=Frm[FNo].Strings[65];
    Frm[FNo].Strings[47]:=FormatFloat('###.0000',Vl(Frm[FNo].Strings[37])-Vl(Frm[FNo].Strings[38]));
    Frm[FNo].Strings[26]:= Frm[FNo].Strings[47];
    Tv[27]:= Tv[35] * vl(Frm[FNo].strings[26])/100;
   // Frm[FNo].strings[26] := FormatFloat('0.0000', MaxR(0,100-Vl( GetMjAlloc(RetNo,'YT') )) ); //jz 20190212 //Tv[26]:=100-vl(GetMjAlloc(RetNo,'YT'));
   // Tv[27]:=Tv[35] * vl(Frm[FNo].strings[26])/100; //jz 20190212 //Tv[27]:=Tv[35] * Tv[26]/100;

    Tv[28]:=Tv[27];
   end
   Else
   begin
    For i:=23 to 28 do Tv[i]:=0;
    For i:=34 to 35 do Tv[i]:=0;
   end;
   Tv[29]:=MaxR(0,Tv[62]-Tv[28]);
  end;

  //20200402
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
   If ret[RetNo].Province = 'YT' then
    Tv[147] := GetPrvForTaxCredit(RetNo,'YT')
   Else
    Tv[147]:=0;
   Tv[144] := MaxR(0,Tv[29]-Tv[147]);  //20160322 //20160505 Igor
   //page 2 //20230409
   Tv[48]:=Tv[144];
   //from yt428
   //Tv[92]:=?? user entry?
   Tv[93]:=Tv[90]+Tv[92];
   Tv[94]:=Tv[48]; //Tv[103];  //20230507
   Tv[95]:=MinR(Tv[93],Tv[94]);
   if Tv[95]>25000 then Tv[95]:=25000;
   //unused
   Tv[96]:=Tv[93];
   Tv[97]:=Tv[95];
   Tv[98]:=MaxR(0,Tv[96]-Tv[97]);

   Tv[91]:=Tv[48]-Tv[95];
   Tv[109]:=Vl(FetchElm(RetNo,'YT432',10)); //20221203
   Tv[113]:=MaxR(0,Tv[91]-Tv[109]);

   //2022230422
   Tv[76]:=GetPrvPolit(RetNo,'YT');
      //jz//20260328//MJCERT2025 - changed GetPrvPolit to handle if IsMultJurisdiction
      //if IsMultJurisdiction(RetNo) then Tv[76]:=Vl(FetchElm(RetNo,'POLIT',57)); //20240510

   If Tv[76] <=400 then x:= Tv[76] * 0.75
   Else if ((Tv[76] >400) and (Tv[76] <=750)) then
       x := (Tv[76]-400) * 0.50 + 300
   Else if Tv[76] >750 then x := (Tv[76]-750) * 0.3333 + 475;
   If x >650 then x :=650;  //20221203
   Tv[75] := MinR(650,x);
   //Tv[75]:=Vl(FetchElm(RetNo,'YT428',75));
   If Vl(GetMjAlloc(RetNo,'YT')) =0 then begin Tv[76]:=0;Tv[75]:=0;end; //20230422
   //If Ret[RetNo].Province <> 'YT' then Tv[76]:=0;
    Tv[123] := MaxR(0,Tv[113] - Tv[75]);  //20150907+
  end;
  SaveTv(RetNo,FName,FNo);
end;


//20251125 Igor <<<
(* //20230407
procedure ONMJ(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,TaxFno1:Integer;
T2203FNo:Integer;
Begin

 //20130426
 For i:=12 to 23 do Tv[i]:=0;
 For i:=46 to 54 do Tv[i]:=0;
 For i:=156 to 162 do Tv[i]:=0;
 //20150216
 For i:=117 to 121 do Tv[i]:=0; For i:=123 to 124 do Tv[i]:=0;

 InitPrvConstants('ON');
 TaxFNo1:=GetFormNo('ON428');
 T2203FNo:=GetFormNo('T2203');
 LoadTv(RetNo,FName,FNo);

 If (IsMultJurisdiction(RetNo) = False)
 Or (Vl(GetMjAlloc(RetNo,'ON')) =0) then
 begin
   For i:=1 to 124 do Tv[i]:=0;  //20150216
   SaveTv(RetNo,FName,FNo);
   Exit;
 end;

 with ret[RetNo].Frm[Fno] do
 begin
   Tv[1]:=Vl(FetchElmFNo(RetNo,TaxFNo1,1));

   j:=2;
   For i:=12 to 23 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   J:=14;
   For i:=46 to 54 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   //20130426
   j:=156;
   For i:=156 to 162 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;

   //20150216
   j:=117;
   For i:=117 to 124 do
   begin
     Strings[i]:=FetchElmFNo(RetNo,TaxFNo1,j);
     Tv[i]:=Vl(FetchElmFNo(RetNo,TaxFNo1,j));
     Inc(j);
   end;


   Tv[30] := MaxR(Tv[124],MaxR(Tv[162],MaxR(Tv[52],MaxR(Tv[53],Tv[54])))); //20150216
   Tv[33] := Vl(FetchElmFno(RetNo,T2203FNo,527)); //Vl(FetchElm(RetNo,'T2203',527));  //20200404
   Tv[55]:=MaxR(0,Tv[30]-Tv[33]); //Tv[55]:=MaxR(0,Tv[30]-Tv[57]);

   Tv[64]:=Tv[55];
   If ret[RetNo].Province = 'ON' then
     Tv[65] := Vl(FetchElm(RetNo,'DTC',9)) //Tv[35] * Tv[26]/100;
   else
     Tv[65]:=0;
   Tv[66]:=MaxR(0,Tv[64]-Tv[65]);

   Tv[26]:=Vl(FetchElm(RetNo,'T1',144)); //Vl(FetchElm(RetNo,'S1',106));
   Tv[35]:= PrvConstant[RY].PrvAmtCarryOverRate;
   Tv[25]:=Tv[26]*Tv[35]/100;

   Tv[67]:=MinR(Tv[66],Tv[25]);
   Tv[68]:=MaxR(0,Tv[55]-Tv[67]);

   Tv[41] :=Vl(FetchElm(RetNo,'T691',249));
   Tv[42] :=PrvConstant[RY].PrvAmtCarryOverRate;
   Tv[40]:= Tv[41] * Tv[42]/100;
   Tv[4]:=Tv[10]+Tv[40]; //Tv[68]+Tv[40];  //20170613

   Strings[24]:=GetMjAlloc(RetNo,'ON');
   Tv[24]:= Vl(Strings[24]);  //100-Vl(Strings[29]);   //20150403
   Strings[24]:=FormatFloat('0.0000',Tv[24]);

   Tv[44]:=Tv[68] * tv[24]/100;  //Tv[4]*Tv[24]/100; //Tv[39];  //20170613

   //adjustments
   //20180403
   Tv[5]:=Vl(FetchElmFNo(RetNo,T2203FNo,592))+Vl(FetchElmFNo(RetNo,T2203FNo,510));
   Tv[6]:=6.05;
   Tv[7]:=Tv[5] * Tv[6]/100;
   //20210405
   Strings[78]:='100.0000';
   Strings[80]:=Strings[24];
   Strings[81]:=FormatFloat('###.0000',Vl(Strings[78])-Vl(Strings[80]));
   Strings[45]:=Strings[81];
   Tv[28]:= Tv[7] * vl(strings[45])/100;
   Tv[60]:=Tv[28];
   Tv[43]:=MaxR(0,Tv[44]-Tv[60]);

  If (SplitIncome(RetNo)) and (Ret[RetNo].Province = 'ON') then
     Tv[31] := Vl(FetchElm(RetNo,'T1206',18) )// Tv[31] := Vl(FetchElm(RetNo,'T1206',103))
   else
     Tv[31] :=0;
   Tv[32]:=Tv[43]+Tv[31];

   if Ret[RetNo].Province <>'ON' then
   Begin
    For i:=5 to 7 do Tv[i]:=0;
    Tv[45]:=0;Tv[28]:=0;Tv[60]:=0;
    Tv[43]:=0;Tv[31]:=0;
    Tv[32]:=Tv[44];
   End;

   //Surtax
   //20180325
  ??? Tv[101]:=Tv[68];   ???
  ??? Tv[2] := Tv[101]; //Tv[29]; //Tv[101]; //Tv[32];  //20170613
   //20220404
   Tv[3] := MaxR(0,Tv[2] - 4874) * 20/100;  //20210410 //Tv[3] := MaxR(0,Tv[2] - 4331) * 20/100;    //20170408
   Tv[8] :=Tv[101]; ////Tv[32];
   Tv[9] := MaxR(0,Tv[8] - 6237) * 36/100; //20210410
   Tv[11] := Tv[3]+Tv[9];
   Tv[37]:=Tv[11];
   strings[38]:= strings[24]; //20190207 //FormatFloat('0.##',Tv[24]);
   Tv[34]:=Tv[37] * Vl(Strings[38])/100;//Tv[34] := Tv[11];
   Tv[61] := Tv[32]+Tv[34]; //Tv[101]+Tv[34];
 end;

 //20180325 onmj pg2

 with ret[RetNo].Frm[Fno] do
 begin
   Tv[27]:=TV[61]; //Tv[31];

  If ret[RetNo].Province = 'ON' then
   Tv[36]:=Vl(FetchElm(RetNo,'DTC',9))     //20150423
  Else
   Tv[36]:=0;
  Tv[10]:=MaxR(0,Tv[27]-Tv[36]);  //20150315
  Tv[40]:=Vl(FetchElm(RetNo,'ON428',144));  //20180325
  Tv[4]:=Tv[10]+Tv[40];

  {tax reduction}  //20220404
  Tv[70]:=251; //20220406 //249; //244; //20200202  239;    //20190205
  //20190403
  if Tv[4]<=0 then
  Begin
   for i:=103 to 113 do begin Strings[i]:='';Tv[i]:=0;end;
   Tv[71]:=0;Tv[72]:=0;Tv[56]:=0;Tv[57]:=0; Tv[62]:=0;Tv[69]:=0;
  End
  Else
  Begin
   strings[71]:=strings[24];
   Tv[102]:=Tv[70]*vl(strings[71])/100;
   If GetPrvNetIncome(RetNo,'ON')> SpouseIncome(RetNo) then
   begin
     Strings[103] := FetchElm(RetNo,'DEPEND',8);
     k:= MystrToInt(FetchElm(RetNo,'DEPEND',9));
     If (Vl(FetchElm(RetNo,'S2',5)) > 0) and
        (Ret[RetNo].Lnn[32600] >0) then Inc(K); {disabil xferd from spouse}
     Strings[105] := IntToStr(k);
   end
   Else
   begin
    Strings[103] :='';
    Strings[105] := '';
   end;
  //20180325
  Tv[104] := Vl(Strings[103]) * 464;//  460; //442; //20220406

  Strings[39]:=Strings[24];
  // Tv[39]:=Tv[7]+Tv[29];   //+Tv[10]    //20150403 ??????????
  Tv[56]:=Tv[104]*Vl(Strings[39])/100;
  Tv[57]:=Tv[56];


  Tv[106] := Vl(Strings[105]) * 464; //460; //442; //434; //20200131
  Strings[62]:=Strings[24];
  Tv[69]:=Tv[106]*Vl(Strings[62])/100;
  Tv[72]:=Tv[69]; //20220406
  Tv[107] := Tv[102]+Tv[57]+Tv[72];

  Tv[108] := Tv[107];
  Tv[109] := Tv[108] * 2;
  Tv[110] := Tv[4]; //Tv[101];  //20200412
  Tv[111] := MaxR(0,Tv[109] - Tv[110]);
  Tv[112] := Tv[111];
  If ret[RetNo].Province <> 'ON' then
   begin For i:=102 to 112 do Tv[i]:=0;end;
  Tv[113] :=MaxR(0,Tv[4] -Tv[112]);  // 20170613//MaxR(0,Tv[10] -Tv[112]); //MaxR(0,Tv[101] -Tv[112]);  //20130315
 End;


  If ret[RetNo].Province = 'ON' then
    Tv[153] := GetPrvForTaxCredit(RetNo,'ON')
  else
    Tv[153]:=0;

  Tv[154] := MaxR(0,Tv[113] - Tv[153]);

  //20200202
  Tv[74]:=Vl(FetchElm(RetNo,'ON428A',41));
  Strings[75]:=Strings[24];
  Tv[76]:=Tv[74]*Vl(Strings[75])/100;
  Tv[77]:=Tv[76];
  Tv[79]:=MaxR(0,Tv[154]-Tv[77]);

  Tv[58]:=Tv[63]*25/100;
  Tv[59]:=MaxR(0,Tv[79]-Tv[58]); //20200202 //MaxR(0,Tv[154]-Tv[58]);

  If ret[RetNo].Province='ON' then
    Tv[127]:= Vl(FetchElm(RetNo,'ON428',134))
  Else
    Tv[127]:=0;

  Tv[122] :=Tv[59]+Tv[127]; //20150314
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)





























































(* //jz//20260328//MJCERT2025 - FROM CALC1 - NOT USED???? >>>>>>>>>>>>>>>>>>>>>>


//20240605
Procedure ABMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=656;  //Spouse credit in T2203
 T2203EligDependantElm=657;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606
 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('AB');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    Tv[46]:=0;
    //find dependands for caregiver from S5PRV.
    i:=18; //index to s5prv
    K:=1;
    while i<=81 do //20240605
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       xx:=Tv[31];
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
       Tv[46]:=Tv[46]+Tv[35];
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
 end;

 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure BCMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=604;  //Spouse credit in T2203
 T2203EligDependantElm=605;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;


 InitPrvConstants('BC');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure MBMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=556;  //Spouse credit in T2203
 T2203EligDependantElm=557;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('MB');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       xx:=Tv[31];
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

{
//20250425 see calc2
//20240605
Procedure NBMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=530;  //Spouse credit in T2203
 T2203EligDependantElm=531;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606


 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NB');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;
}

//20240605
Procedure NLMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=304;  //Spouse credit in T2203
 T2203EligDependantElm=305;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 T2203FNo:=GetFormNo('T2203'); //20240606
 InitPrvConstants('NL');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure ONMJ(RetNo: integer; FName: String; FNo: integer);
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=504;  //Spouse credit in T2203
 T2203EligDependantElm=505;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('ON');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure PEMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=330;  //Spouse credit in T2203
 T2203EligDependantElm=331;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('PE');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure SKMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=630;  //Spouse credit in T2203
 T2203EligDependantElm=631;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('SK');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure NSMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=356;  //Spouse credit in T2203
 T2203EligDependantElm=357;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NS');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure NUMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=856;  //Spouse credit in T2203
 T2203EligDependantElm=857;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
 T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NU');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more

 end;
 SaveTv(RetNo, FName, FNo);
end;

//20240605
Procedure NTMJ(RetNo: integer; FName: String; FNo: integer); //20240522
Const
 AgeRate=15;  //that's fed non refubdable rate
 T2203SpouseElm=830;  //Spouse credit in T2203
 T2203EligDependantElm=831;  //or Elig dep elm fot T2203 credit

Var i,k, S5PrvFNo, T2203FNo:Integer;
Prv:String;

begin
  T2203FNo:=GetFormNo('T2203'); //20240606

 if IsMultJurisdiction(RetNo) then
  Prv:=T2203Prov
 Else
  Prv:=Ret[RetNo].Province;

 InitPrvConstants('NT');

 LoadTv(RetNo, FName, FNo);   //20240522
 //==========age amount
 with ret[RetNo].Frm[FNo] do
 Begin
   Tv[6]:= PrvConstant[RY].PrvMaxAgeAmount; // := 5373;
   Tv[7]:=Vl(fetchElm(RetNo,'T1',322));//Ret[RetNo].LNN[23600]; //Vl(fetchElm(RetNo,'T1',322)); //Ret[RetNo].LNN[23600];  //Ret[RetNo].LNN[23600] does not work??;
   Tv[8]:=PrvConstant[RY].PrvAgeBaseAmount; // := 39994; //Threshold;
   Tv[9]:=MaxR(0,Tv[7]-Tv[8]);
   Tv[10]:=AgeRate;
   Tv[11]:=Tv[9]*AgeRate/100;
   Tv[12]:=Tv[11];
   Tv[13]:=MaxR(0,Tv[6]-Tv[12]);
   if Tv[7]<=PrvConstant[RY].PrvAgeBaseAmount then Tv[13]:=PrvConstant[RY].PrvMaxAgeAmount; //MaxClaim;
   if Tv[7]>=PrvConstant[RY].PrvAgeNIThreshHold then Tv[13]:=0;
 end;
 //============== Spouse amount
 //==============Elig dependant amount
 //==============Caregiver amount
 S5PrvFNo:=GetFormNo('S5PRV');
 //k dependant number //num of dependants with casegiver Only 3 can take
 with ret[RetNo].Frm[FNo] do
 begin
    //find dependands for caregiver from S5PRV.
    i:=18;
    K:=1;
    while i<=63 do
    Begin
     if (FetchelmFNo(RetNo,S5prvFno,i)='58400')
     and (k<=3)
     and (vl(FetchelmFNo(RetNo,S5prvFno,i+1))>0)  //amount federally claimed
     then
     Begin
      if k=1 then //first caregiver
      begin
       Tv[31]:=PrvConstant[RY].PrvCareGvrBase; // := 22985;
       Tv[32]:=Vl(FetchElmFNo(RetNo,S5PrvFno,i-2));
       Tv[33]:=MaxR(0,Tv[31]-Tv[32]);  //5243;
       Tv[33]:=MinR(Tv[33],PrvConstant[RY].PrvMaxCareGvr);
       Tv[34]:=MaxR(Vl(FetchElmFNo(RetNo,T2203FNo,T2203SpouseElm)),Vl(FetchElmFNo(RetNo,T2203FNo,T2203EligDependantElm)));
       // T2203 58120 spouse or 28160 elig dependant
       Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
      end
      Else if k=2 then //second caregiver
      begin

      end
      Else if k=3 then //third caregiver
      begin

      end;
     end; //if claimed federally in S5prv
     Inc(i,9);
     k:=k+1;
    End;
    Tv[46]:=Tv[35]; //+ TV[]...????  +++ two more
 end;
 SaveTv(RetNo, FName, FNo);
end;

*)  //jz//20260328//MJCERT2025 - FROM CALC1 - NOT USED???? <<<<<<<<<<<<<<<<<<<<<<<<<<<




end.
