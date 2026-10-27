unit FP_2027CalcTax;
//  ...//FP are changes for FP purposes

interface
uses
 SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  StdCtrls,Dialogs,DBctrls,ExtCtrls,ShellApi;

//dummy functions

   Procedure On428(RetNo:integer;FName:string;FNo:integer);
   Procedure ON479(RetNo:integer;FName:string;FNo:integer);
//   Procedure ONCR_2(RetNo:integer;FName:string;FNo:integer);
   Procedure BC479(RetNo:integer;FName:string;FNo:integer);
   Procedure BC428(RetNo:integer;FName:string;FNo:integer);
   Procedure NB428(RetNo:integer;FName:string;FNo:integer);
   Procedure NL428(RetNo:integer;FName:string;FNo:integer);
   Procedure NT428(RetNo:integer;FName:string;FNo:integer);
   Procedure NT479(RetNo:integer;FName:string;FNo:integer);
   Procedure PE428(RetNo:integer;FName:string;FNo:integer);
   Procedure MB428(RetNo:integer;FName:string;FNo:integer);
   Procedure MANCR_2(RetNo:integer;FName:string;FNo:integer);
   Procedure SK428(RetNo:integer;FName:string;FNo:integer);
   Procedure YT428(RetNo:integer;FName:string;FNo:integer);
   Procedure YT479(RetNo:integer;FName:string;FNo:integer);
   Procedure AB428(RetNo:integer;FName:string;FNo:integer);
   Procedure NS428(RetNo:integer;FName:string;FNo:integer);
   Procedure NS479(RetNo:integer;FName:string;FNo:integer);
   Procedure NU428(RetNo:integer;FName:string;FNo:integer);
   Procedure NU479(RetNo:integer;FName:string;FNo:integer);
    procedure NSLS(RetNo: integer; FName: String;FNo: integer);

Function GetSpouseBirthDate(RetNo:Integer):String;
Function IsSpouseDeceased(RetNo:Integer):Boolean;
Function AmountForPrvMinTax(RetNo:Integer):Real;
Function GetPrvNetIncome(RetNo:Integer;Prv:String):Real;
Function CalcMortgageForeclosure(V1,V2,V3:Real):Real;
Function IsDeceased(RetNo:Integer):Boolean;
Function SplitIncome(RetNo:Integer):Boolean;
Function GetPrvEducXfer(RetNo:Integer):Real;
Function GetPrvDisabXfer(RetNo:Integer):Real;
Function GetPrvPolit(RetNo:Integer;Prv:String):Real;
Function CalcPrvMedicalLimit(RetNo:Integer):Real; //FP
Function GetPrvForTaxCredit(RetNo:Integer;Prv:String):Real;
Function GetSpouseIncome(RetNo:Integer):Real;  //FP
Function CalcThisProvince(RetNo:Integer;Prv:String):Boolean; //FP
Procedure S1(RetNo:integer;FName:string;FNo:integer);
procedure TAXPLANNER(RetNo: integer; FName: String;FNo: integer);
Procedure InitPRVConstants(Prv:String);


Procedure CalcGrossFedTax(TxblIncome:Real;RY:Integer;
  Var BracketTax1:Real;
  Var BracketTax2:Real;
  Var BracketTax3:Real;
  Var BracketTax4:Real;
  Var AllBracketsTax:Real);

Procedure CalcGrossProvincialTax(TxblIncome:Real;Prv:String;RY:Integer;
  Var BracketTax1:Real;
  Var BracketTax2:Real;
  Var BracketTax3:Real;
  Var BracketTax4:Real;
  Var BracketTax5:Real;
  Var AllBracketsTax:Real);

//Procedure RecalcTaxPlanner(RetNo:Integer);
//Procedure ProcessT1Results(RetNo:Integer;FInst:String);
//procedure PrepAndCallT1(RetNo:Integer;AFunction:String;FInst:String);
Procedure TAXP_1(RetNo: integer; FName: String;FNo: integer);
Procedure TAXP_2(RetNo: integer; FName: String;FNo: integer);
//Procedure CallT1(TaxInput1,TaxInput2:TStringList;AFunction:String);
Function GetCPPMonths(RetNo:integer;BirthDate:String):Integer;
Function CalcPRVSurTax(RetNo:Integer; Prv:String;Txbl,PrvTax,FamIncome:real):Real;
Function CalcPensDed(RetNo:Integer; PensInc:Real):Real;
Function CalcEmplCPP(RetNo:Integer;EmplInc:Real;BirthDate:string):Real;
Function CalcSelfCPP(RetNo:Integer;EmplInc,SelfEmplInc,EmplCpp:Real;BirthDate:string):Real;
Function CalcEI(RetNo:Integer;EmplInc:Real):Real;
Function CalcMarStatus(RetNo:Integer): Integer;
Function GetMarStatusDescr(I:Integer):string;
Procedure InitTaxPlHeader(RetNo,FNo:Integer);
Procedure TAXPL_1(RetNo: integer; FName: String;FNo: integer);
Procedure TAXPL_2(RetNo: integer; FName: String;FNo: integer);
Procedure TAXPL_3(RetNo: integer; FName: String;FNo: integer);
Function CalcTaxForCashFlow(RetNo:Integer):Real;  //20200314
//Procedure CalcTaxForCashFlow(RetNo:Integer);
//ocedure CalcTaxForCashFlowProjection(RetNo:Integer);
Function CalcSpousalClaim(SpNi,PartYear:Real):Real;
Function CalcPrvSpousalClaim(SpNi,PartYear:Real):Real;
Function CalcFedTax(TxblInc:Real):real;
Function CalcMedical(Medical,NI:Real):real;
//Function CalcAgeIn2001(BirthDate: string): Integer;
Function CalcAgeEx(Age: integer;NI:real):real;
Function CalcFedSurtax(BasFedTax,FAvrgCr:Real):Real;
Function CalcCLAWBack(NI,EIBenefits,OAS:Real):real;
Procedure InitConstants;
Function GetPrvIndex(SPrv: string): Integer;

implementation
Uses vtMulti,vtCommon,FP_2027,FP_2027Declare,FP_2027common,FP_2027common2,
  FP_2027TrimStr,FP_2027PopList,FP_2027Main,FP_2027Calc,vtTrimStr,vtShared;


Procedure BC428(RetNo:integer;FName:string;FNo:integer);
Var
i:Integer;
Thresh1,Thresh2,Reduction:Real;
Begin
 InitPrvConstants('BC');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'BC') = false  then
 begin
  For i:=1 to 152 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314 Tv[1]:=TaxRec.TaxableIncome;
//   Tv[1] := Ret[RetNo].Ln[260];
   //20150227 All below
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 79 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=90 to 96 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;    //20140813

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[69] := PrvConstant[RY].PrvRate4;
   Frm[FNo].Strings[76] := PrvConstant[RY].PrvRate5;
   Frm[FNo].Strings[93] := PrvConstant[RY].PrvRate6; //20140813

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[67] := PrvConstant[RY].PrvBracket3;
   Tv[71] := PrvConstant[RY].PrvBracketTax4;         {?}
   Tv[74] := PrvConstant[RY].PrvBracket4;
   Tv[78] := PrvConstant[RY].PrvBracketTax5;
   Tv[95] := PrvConstant[RY].PrvBracketTax6;   //20140420

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[66] := Tv[1];
     Tv[67] := PrvConstant[RY].PrvBracket3;
     Tv[68] := MaxR(0,Tv[66]-Tv[67]);
     Tv[70] := Tv[68] * Vl(Frm[FNo].Strings[69])/100;
     Tv[71] := PrvConstant[RY].PrvBracketTax4;         {?}
     Tv[72] := Tv[70] + Tv[71];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket4)
   and (Tv[1] <= PrvConstant[RY].PrvBracket5) then //20140813
   begin
     Tv[73] := Tv[1];
     Tv[74] := PrvConstant[RY].PrvBracket4;
     Tv[75] := MaxR(0,Tv[73]-Tv[74]);
     Tv[77] := Tv[75] * Vl(Frm[FNo].Strings[76])/100;
     Tv[78] := PrvConstant[RY].PrvBracketTax5;
     Tv[79] := Tv[77] + Tv[78];
   end;

   //20140813
   If Tv[1] > PrvConstant[RY].PrvBracket5 then
   begin
     Tv[90] := Tv[1];
     Tv[91] := PrvConstant[RY].PrvBracket5;
     Tv[92] := MaxR(0,Tv[90]-Tv[91]);
     Tv[94] := Tv[92] * Vl(Frm[FNo].Strings[93])/100;
     Tv[95] := PrvConstant[RY].PrvBracketTax6;
     Tv[96] := Tv[94] + Tv[95];
   end;



   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
   Tv[26] := GetSpouseIncome(RetNo);
   Tv[27] := CalcPrvSpousalClaim(RetNo,GetSpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
   Tv[51] := Ret[RetNo].Ln[313];
   If Tv[51]>10445 then Tv[51]:=10445;
 //  Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//Ret[RetNo].Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[47]+Tv[51];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

   //Second Page----------------------------------------------------------------
    Tv[132]:=MaxR(Tv[96],MaxR( MaxR(Tv[20],MaxR(Tv[21],Tv[22])), MaxR(TV[72],TV[79]))); //20150227
    //Tv[132] := MaxR(MaxR(Tv[20],MaxR(Tv[21],Tv[22])),MaxR(TV[72],TV[79]));

    If SplitIncome(RetNo) then
     Tv[133] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[133] :=0;
    Tv[134] := Tv[132]+Tv[133];
 
    Tv[135] :=Tv[61];
 
    Tv[152] := PrvConstant[RY].PrvAMTCarryOverRate;
 
    Tv[141] := Ret[RetNo].Ln[427];
    Tv[138] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[37] * Tv[50]/100;
    // overseas credit
    Tv[107]:=MaxR(0,Tv[132]-Tv[135]-Tv[138]);
    Tv[118]:=MaxR(0,Vl(FetchElm(RetNo,'S1',101))
           -Vl(FetchElm(RetNo,'S1',104))
           -Vl(FetchElm(RetNo,'S1',105)));
    Tv[109]:=Vl(FetchElm(RetNo,'S1',130));
    If Tv[108]<>0 then
      Tv[110]:=(Tv[107]/Tv[108]) * Tv[109]
    else
      Tv[110]:=0;
    Tv[140] := Tv[110];
    Tv[142] := Tv[141] * Tv[152]/100;
 
    Tv[143] := Tv[135]+Tv[138]+Tv[140]+Tv[142];
    Tv[144] := Tv[143];
    Tv[145] := MaxR(0,Tv[134] - Tv[144]);
    Tv[111]:=AmountForPrvMinTax(RetNo);
    Tv[112]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[146]:=Tv[111] * Tv[112]/100;
 
    Tv[147] := Tv[145]+Tv[146];
 
    If Ret[RetNo].Province <> 'BC' then
     Tv[148] :=0
    else
     Tv[148] := GetPrvForTaxCredit(RetNo,'BC');
    Tv[149] := MaxR(0,Tv[147]-Tv[148]);
 
   (*
    If Vl(FetchElm(RetNo,'T81',4)) >0 then
    begin
     Tv[103]:=0;
     Tv[105]:=Vl(FetchElm(RetNo,'T81',4));
    end
    else
    begin
     Tv[103]:=Abs(Vl(FetchElm(RetNo,'T81',4)));
     Tv[105]:=0;
    end;
    *)
    //Tv[104]:=Tv[149]+Tv[103];
    Thresh1:=18200*PartYear;Thresh2:=30981;Reduction:=409*PartYear;
    If Ret[RetNo].Ln[236]<Thresh2 then
    begin
     Tv[113]:=Reduction;
     Tv[114]:=Ret[RetNo].Ln[236];
     Tv[115]:=Thresh1;
     Tv[116]:=MaxR(0,Tv[114]-Tv[115]);
    // Tv[117]:=3.6;
     Tv[117]:=3.2;
     Tv[136]:=Tv[116]*Tv[117]/100;
     Tv[118]:=Tv[136];
     Tv[119]:=MaxR(0,Tv[113]-Tv[118]);
     Tv[120]:=Tv[119];
    end
    else
    begin
     for i:=113 to 120 do Tv[i]:=0;
    end;
    Tv[121]:=MaxR(0,Tv[149]-Tv[120]);
  //  Tv[122] :=BCLoggingTaxCredit(RetNo,Vl(FetchElm(RetNo,'DIRECT',10)),Vl(FetchElm(RetNo,'DIRECT',11)));
    Tv[123] := MaxR(0,Tv[121]-Tv[122]);

    Tv[81]:=Tv[123];
    Tv[124] := GetPrvPolit(RetNo,'BC');
    If Tv[124] <= 100 then Tv[125] :=Tv[124]* 0.75
    else If (Tv[124]>100) and (Tv[124] <=550) then
       Tv[125]:= (Tv[124]-100) * 0.50 + 75
    else Tv[125] := (Tv[124] - 550) * 0.3333 +300;
    If Tv[125]>500 then Tv[125]:=500;

    Tv[126] := MaxR(0,Tv[81]-Tv[125]);

    Tv[129] := MinR(2000,Tv[127]+Tv[128]);
    Tv[130] :=Tv[129];
    Tv[101] := MaxR(0,Tv[126]-Tv[130]);
    Tv[102]:= Vl(FetchElm(RetNo,'T1231',7));

    Tv[131] := MaxR(0,Tv[101]-Tv[102]);
    Ln[428] := Tv[131];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure ON428(RetNo:integer;FName:string;FNo:integer);
Var i,k :integer; SpRetNo,WhichRetNo:integer; Txbl:Real;
SurTaxBase1,SurtaxBase2:Real;
Begin
 InitPrvConstants('ON');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'ON') = false  then
 begin
  For i:=1 to 154 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:=TaxRec.TaxableIncome;   //20200314

   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=156 to 162 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=117 to 124 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;  //20140813

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[159] := PrvConstant[RY].PrvRate4;
   Frm[FNo].Strings[120] := PrvConstant[RY].PrvRate5;  //20140813


   {
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
    }


 (*
   Tv[5] :=0;
   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[17] :=0;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;
*)
   //20150226
   Tv[5] :=0;
   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[157] := PrvConstant[RY].PrvBracket3;
   Tv[118] := PrvConstant[RY].PrvBracket4;  //20140813
   Tv[17] :=0;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[161]:= PrvConstant[RY].PrvBracketTax4;
   Tv[123]:= PrvConstant[RY].PrvBracketTax5;  //20140813

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;


   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4) then     //20140813
   begin
     Tv[156] := Tv[1];
     Tv[157] := PrvConstant[RY].PrvBracket3;
     Tv[158] := MaxR(0,Tv[156]-Tv[157]);
     Tv[160] := Tv[158] * Vl(Frm[FNo].Strings[159])/100;
     Tv[161] := PrvConstant[RY].PrvBracketTax4;
     Tv[162] := Tv[160] + Tv[161];
   end;
   //20140813
   If Tv[1] > PrvConstant[RY].PrvBracket4 then
   begin
     Tv[117] := Tv[1];
     Tv[118] := PrvConstant[RY].PrvBracket4;
     Tv[119] := MaxR(0,Tv[117]-Tv[118]);
     Tv[121] := Tv[119] * Vl(Frm[FNo].Strings[120])/100;
     Tv[123] := PrvConstant[RY].PrvBracketTax5;
     Tv[124] := Tv[121] + Tv[123];
   end;



   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
 //  Tv[26] := SpouseIncome(RetNo);
  // Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
 //  Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40]:= GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   If UpperCase(Frm[FNo].Strings[67])='Y' then Tv[42]:=Tv[68];
   Tv[66] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[51]:=Ret[RetNo].Ln[313];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[47]+Tv[51];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

 // SECOND PAGE-----------------------------------------------------------------------------------

   Tv[101]:=MaxR(Tv[124],MaxR(MaxR(Tv[20],MaxR(Tv[21],Tv[22])),Tv[162])); //20150226
  // Tv[101] := MaxR(Tv[20],MaxR(Tv[21],Tv[22])); //MaxR(Vl(FetchElm(RetNo,'ON428',20)),

 (*

   Tv[127] := PrvConstant[RY].PrvOverseasRate;
   If SplitIncome(RetNo) then
     Tv[131] := Vl(FetchElm(RetNo,'T1206_2',3))
   else
     Tv[131] :=0;
   Tv[132] := Tv[101]+Tv[131];
   Tv[133] := Tv[61]; //Vl(FetchElm(RetNo,'ON428',61));
   {
   If IsNonResWithCanEmpl(RetNo) then
    Tv[133]:= (Tv[31]  //Vl(FetchElm(RetNo,'ON428',31))
              +Tv[33]  //Vl(FetchElm(RetNo,'ON428',33))
              +Tv[36]  //Vl(FetchElm(RetNo,'ON428',36))
              +Tv[38]  //Vl(FetchElm(RetNo,'ON428',38)) {5852}
              +Tv[39]  //Vl(FetchElm(RetNo,'ON428',39))  {5856}
              +Tv[60])  //Vl(FetchElm(RetNo,'ON428',60))){5896}
              * PrvConstant[RY].PrvNonRefundRate/100;
   }
   Tv[137] := Ret[RetNo].Ln[426];
   If (Ret[RetNo].Province <> 'ON') then
   begin
    Tv[137] := 0;
   end;
   Tv[136] := Vl(FetchElm(RetNo,'DTC',9));
   Tv[138] := Tv[137] * Tv[127]/100;

   Tv[140] :=Vl(FetchElm(RetNo,'OT1219',17));//Vl(FetchElm(RetNo,'O1219_3',7));
   Tv[141] := Tv[133]+Tv[136]+Tv[138]+Tv[140];
   Tv[142] := Tv[141];
   Tv[143] := MaxR(0,Tv[132] - Tv[142]);

   Tv[128]:=Vl(FetchElm(RetNo,'T691_3',49));
   If IsDeceased(RetNo) then Tv[128]:=0;
   Tv[129]:=PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[144]:=Tv[128] * Tv[129]/100;
   Tv[145] := Tv[143]+Tv[144];
   Tv[146] := Tv[145];
   Tv[147] := MaxR(0,Tv[146] - 4100) * 20/100;

   Tv[148] :=Tv[145];
   Tv[149] := MaxR(0,Tv[148] - 5172) * 36/100;

   Tv[150] := Tv[147]+Tv[149];
   Tv[151] := Tv[150];
   Tv[152] := Tv[145]+Tv[151];

  {tax reduction}
  Tv[102]:=198 * Partyear;

  {
  If ((Ret[RetNo].MarStatus<3) and (GetPrvNetIncome(RetNo,'ON') > SpouseIncome(RetNo))
      or (Ret[RetNo].MarStatus>2)) then
  begin
    Frm[FNo].Strings[103] := FetchElm(RetNo,'DEPEND',8);
    k:= MystrToInt(FetchElm(RetNo,'DEPEND',9));
    If (Vl(FetchElm(RetNo,'S2',5)) > 0) and
        (Ln[326] >0) then Inc(K);
    Frm[FNo].Strings[105] := IntToStr(k);
  end
  Else
  begin
   Frm[FNo].Strings[103] :='';
   Frm[FNo].Strings[105] := '';
  end;
  }
  Tv[104] := Vl(Frm[FNo].Strings[103]) * 365;
  Tv[106] := Vl(Frm[FNo].Strings[105]) * 365;

  Tv[107] := Tv[102]+Tv[104]+Tv[106];

  Tv[108] := Tv[107];
  Tv[109] := Tv[108] * 2;
  Tv[110] := Tv[152];  //Tv[54];
  Tv[111] := MaxR(0,Tv[109] - Tv[110]);
  If Tv[144]>0 then
  begin
   For i:=102 to 111 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
  end;
  Tv[112] := Tv[111];
  If Ret[RetNo].Province <> 'ON' then
   begin For i:=102 to 112 do Tv[i]:=0;end;

  Tv[113]:=MaxR(0,Tv[152]-Tv[112]);
  If Tv[144]>0 then //adiitionl min tax
  begin
   for i:=102 to 112 do Tv[i]:=0;
  end;

  Tv[90]:=Tv[113];
  Tv[153] := GetPrvForTaxCredit(RetNo,'ON');
  Tv[154] := MaxR(0,Tv[90] - Tv[153]);

  If UpperCase(Frm[FNo].Strings[23]) = 'Y' then
    Tv[114] := Vl(FetchElm(RetNo,'LABORSP',3));
  Tv[115] := MinR(1125,Tv[114] * 0.15);
  Tv[125] := MinR(375,Tv[124] * 0.05);

  If Tv[116] > 4150 then Tv[116] := 4150;
  Tv[118] := Tv[116]+Tv[117];
  Tv[119] := Tv[118];
  Tv[120] := Tv[115]+Tv[125]+Tv[119];
  Tv[121] := Tv[120];
  Tv[130]:=MaxR(0,Tv[154]-Tv[121]);

  //ohip
  For i:=69 to 89 do Tv[i]:=0;
  For i:=91 to 94 do Tv[i]:=0;
  Txbl:=TaxRec.TaxableIncome;
  //TxBl:=Ret[RetNo].Ln[260];
  Tv[95] := Txbl;
  if Txbl <= 20000 then Tv[69]:=0
  else if (Txbl >= 20000) and (Txbl <= 25000) then
   begin  Tv[80] := Txbl;Tv[81]:=Tv[80]-20000;Tv[70]:=Tv[81]*0.06;end
  else if (Txbl > 25000)and (Txbl<=36000) then  Tv[71] := 300
  else if (Txbl >= 36000) and (Txbl <= 38500) then
   begin  Tv[82] := Txbl;Tv[83]:=Tv[82]-36000;Tv[84]:=Tv[83]*0.06;Tv[72]:=Tv[84]+300;end
  else if (Txbl >= 38500) and (Txbl <= 48000) then Tv[73]:=450
  else if (Txbl >= 48000) and (Txbl <= 48600) then
   begin  Tv[85] := Txbl;Tv[86]:=Tv[85]-48000;Tv[87]:=Tv[86]*0.25;Tv[74]:=Tv[87]+450;end
  else if (Txbl >= 48600) and (Txbl <= 72000) then Tv[75]:=600
  else if (Txbl >= 72000) and (Txbl <= 72600) then
   begin  Tv[88] := Txbl;Tv[89]:=Tv[88]-72000;Tv[91]:=Tv[89]*0.25;Tv[76]:=Tv[91]+600;end
  else if (Txbl >= 72600) and (Txbl <= 200000) then Tv[77]:=750
  else if (Txbl >= 200000) and (Txbl <= 200600) then
   begin  Tv[92] := Txbl;Tv[93]:=Tv[92]-200000;Tv[94]:=Tv[93]*0.25;Tv[78]:=Tv[94]+750;end
  else if (Txbl >= 200600) then Tv[79]:=900;

  Tv[134]:= AddColumns(69,79,1);
  If Txbl <=20000 then Tv[134]:=0;  //vl(FetchElm(RetNo,'ON428',1)) <=20000 then Tv[34]:=0;
  Tv[122] := Tv[130]+Tv[134];
  Ln[428] := Tv[122];
 *)
    If SplitIncome(RetNo) then
     Tv[131] := Vl(FetchElm(RetNo,'T1206',103))
   else
     Tv[131] :=0;
   Tv[132] := Tv[101]+Tv[131];
   Tv[133] := Tv[61]; //Vl(FetchElm(RetNo,'ON428',61));
  {
   If IsNonResWithCanEmpl(RetNo) then    //put notes back
    Tv[133]:= (Tv[31]
              +Tv[33]
              +Tv[36]
              +Tv[38]
              +Tv[39]
              +Tv[60])
              * PrvConstant[RY].PrvNonRefundRate/100;
   }
   //various changes 20140813
   Tv[137] := Ret[RetNo].Ln[426];
   If (Ret[RetNo].Province <> 'ON') then Tv[137] := 0;
   Tv[127] := PrvConstant[RY].PrvOverseasRate;
   Tv[138] := Tv[137] * Tv[127]/100;
   Tv[114]:=Tv[133]+Tv[138];
   Tv[115]:=Tv[114];
   Tv[125]:=MaxR(0,Tv[132]-Tv[115]);

   Tv[126]:=Tv[125];
   Tv[136]:=Vl(FetchElm(RetNo,'DTC',9));
   Tv[130]:=MaxR(0,Tv[126]-Tv[136]);
   Tv[96]:=Ret[RetNo].Ln[427];
   Tv[97]:= 33.67; //40.33;
   Tv[140] :=(Tv[96]*Tv[97])/100;

   Tv[135]:=MinR(Tv[130],Tv[140]);
   Tv[139]:=MaxR(0,Tv[125]-Tv[135]);

   Tv[128]:=Vl(FetchElm(RetNo,'T691',249));
   If IsDeceased(RetNo) then Tv[128]:=0;
   Tv[129]:=PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[144]:=Tv[128] * Tv[129]/100;
   Tv[145]:=Tv[139]+Tv[144];

   If RY=0 then    //20200314   //http://www.taxtips.ca/taxrates/on.htm
   begin
    SurTaxBase1:=4740; //5739;  //20191120
    SurtaxBase2:=6067; //5739;  //20191120
   end
   Else
   begin
    SurTaxBase1:=4740;
    SurtaxBase2:=6067;
   end;

   Tv[146] := Tv[145];
   Tv[147] := MaxR(0,Tv[146] - SurTaxBase1) * 20/100;
   Tv[148] :=Tv[145];
   Tv[149] := MaxR(0,Tv[148] - SurTaxBase2) * 36/100;
   Tv[150] := Tv[147]+Tv[149];
   Tv[151] := Tv[150];
   Tv[152] := Tv[145]+Tv[151];

   Tv[155]:=Vl(FetchElm(RetNo,'DTC',9));
   Tv[163]:=MaxR(0,Tv[152]-TV[155]);

   {
   Tv[141] := Tv[133]+Tv[136]+Tv[138]+Tv[140];
   Tv[142] := Tv[141];
   Tv[143] := MaxR(0,Tv[132] - Tv[142]);
   Tv[136] := Vl(FetchElm(RetNo,'DTC',9));
   Tv[145] := Tv[143]+Tv[144];
   }
  {Pg 3 tax reduction}
  Tv[90]:=Tv[163];
  If RY=0 then
   Tv[102]:=231   //20140813
  else
   Tv[102]:=231;  //20140813

   (*
   // If (Immigrant(RetNo) or Emigrant(RetNo)) then Tv[102]:=0; //20131201
  If ((Ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'ON') > SpouseIncome(RetNo))
      or (Ret[RetNo].MarStatus>2)) then
  begin
    Frm[FNo].Strings[103] := FetchElm(RetNo,'DEPEND',8);
     k:= MystrToInt(FetchElm(RetNo,'DEPEND',9));
     If (Vl(FetchElm(RetNo,'S2PRV',5)) > 0) and (Vl(FetchElm(RetNo,'S2PRV',19))>0)
       then Inc(K); {disabil xferd from spouse}  //20090227
     Frm[FNo].Strings[105] := IntToStr(k);
  end
  Else
  begin
   Frm[FNo].Strings[103] :='';
   Frm[FNo].Strings[105] := '';
  end;

  If IsPrebankruptcyReturn(RetNo) then
   begin Frm[FNo].Strings[103]:='';Frm[FNo].Strings[105]:='';end;

  If RY=0 then
    DepCredit:=413   //20140813
  else
    DepCredit:=413; //20140813

  If (Immigrant(RetNo) or Emigrant(RetNo)) then begin Frm[FNo].Strings[103] :=''; Frm[FNo].Strings[105] := '';DepCredit:=0;end; //20131201

  Tv[104] := Vl(Frm[FNo].Strings[103]) * DepCredit;
  Tv[106] := Vl(Frm[FNo].Strings[105]) * DepCredit;
  *)

  Tv[107] := Tv[102]+Tv[104]+Tv[106];

  Tv[108] := Tv[107];
  Tv[109] := Tv[108] * 2;
  Tv[110] := Tv[90]; //Tv[152];    //20150211
  Tv[111] := MaxR(0,Tv[109] - Tv[110]);
  If Tv[144]>0 then
  begin
   For i:=102 to 111 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
  end;
  Tv[112] := Tv[111];
  If Ret[RetNo].Province <> 'ON' then begin For i:=102 to 112 do Tv[i]:=0;end;
  If Tv[144]>0 then //adiitionl min tax
  begin
   for i:=102 to 112 do Tv[i]:=0;
  end;

  Tv[113]:=MaxR(0,Tv[90]-Tv[112]);

  Tv[153] := GetPrvForTaxCredit(RetNo,'ON');
  Tv[154] := MaxR(0,Tv[113] - Tv[153]); //20141117 MaxR(0,Tv[90] - Tv[153]);

  Tv[165]:=Tv[166] * 25/100;
  Tv[164]:=MaxR(0,Tv[154]-Tv[165]);

  //ohip
  For i:=69 to 89 do Tv[i]:=0;
  For i:=92 to 94 do Tv[i]:=0;      //20121124

  Txbl:=TaxRec.TaxableIncome;
  //TxBl:=Ret[RetNo].Ln[260];

  Tv[95] := Txbl;
  if Txbl <= 20000 then Tv[69]:=0
  else if (Txbl > 20000) and (Txbl <= 25000) then
   begin  Tv[80] := Txbl;Tv[81]:=Tv[80]-20000;Tv[70]:=Tv[81]*0.06;end
  else if (Txbl > 25000)and (Txbl<=36000) then  Tv[71] := 300  //20101021
  else if (Txbl > 36000) and (Txbl <= 38500) then
   begin  Tv[82] := Txbl;Tv[83]:=Tv[82]-36000;Tv[84]:=Tv[83]*0.06;Tv[72]:=Tv[84]+300;end
  else if (Txbl > 38500) and (Txbl <= 48000) then Tv[73]:=450
  else if (Txbl > 48000) and (Txbl <= 48600) then
   begin  Tv[85] := Txbl;Tv[86]:=Tv[85]-48000;Tv[87]:=Tv[86]*0.25;Tv[74]:=Tv[87]+450;end
  else if (Txbl > 48600) and (Txbl <= 72000) then Tv[75]:=600
  else if (Txbl > 72000) and (Txbl <= 72600) then
   begin  Tv[88] := Txbl;Tv[89]:=Tv[88]-72000;Tv[91]:=Tv[89]*0.25;Tv[76]:=Tv[91]+600;end
  else if (Txbl > 72600) and (Txbl <= 200000) then Tv[77]:=750
  else if (Txbl > 200000) and (Txbl <= 200600) then
   begin  Tv[92] := Txbl;Tv[93]:=Tv[92]-200000;Tv[94]:=Tv[93]*0.25;Tv[78]:=Tv[94]+750;end
  else if (Txbl > 200600) then Tv[79]:=900;

  Tv[134]:= AddColumns(69,79,1);
  If Txbl <=20000 then Tv[134]:=0;

  Tv[122]:=Tv[164]+Tv[134];  //20141118 Tv[154]+Tv[134]; // 20121124 Tv[130]+Tv[134];
  Ln[428] := Tv[122];

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure NB428(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;BasicRed:Real;
Begin
 BasicRed:=614; //558;   //20150228
 InitPrvConstants('NB');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NB') = false  then
 begin
  For i:=1 to 150 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   //Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314 Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Frm[FNo].Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
 //  Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
 //  Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//Ret[RetNo].Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

//SECOND PAGE ------------------------------------------------------------------

   Tv[101]:=0;
   if Tv[20] > 0 then                  //Vl(FetchElm(RetNo,'NB428',20)) > 0 then
        Tv[101] := Tv[20]              //Vl(FetchElm(RetNo,'NB428',20))
   else if Tv[21] > 0 then             //Vl(FetchElm(RetNo,'NB428',21)) > 0 then
        Tv[101] := Tv[21]              //Vl(FetchElm(RetNo,'NB428',21))
   else if Tv[22] > 0 then             //Vl(FetchElm(RetNo,'NB428',22)) > 0 then
        Tv[101] := Tv[22]              //Vl(FetchElm(RetNo,'NB428',22))
   else if Tv[67] > 0 then             //Vl(FetchElm(RetNo,'NB428',67)) > 0 then
        Tv[101] := Tv[67];             //Vl(FetchElm(RetNo,'NB428',67));

   If SplitIncome(RetNo) then
     Tv[102] := Vl(FetchElm(RetNo,'T1206_2',3))
   else
     Tv[102] :=0;
   Tv[103] := Tv[101] + Tv[102];
   Tv[104] := Tv[61];                  //Vl(FetchElm(RetNo,'NB428',61));
   Tv[106] := MaxR(0,Tv[103] - Tv[104]);
   Tv[108] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[5] * Tv[7]/100;
   Tv[113] := Ret[RetNo].Ln[426];
   Tv[116] := PrvConstant[RY].PrvOverseasRate;
   Tv[110] := Tv[113] * Tv[116]/100;
   Tv[140] := Ret[RetNo].Ln[427];
   Tv[141] := PrvConstant[RY].PrvAmtCarryOverRate;
   Tv[111] := Tv[140] * Tv[141]/100;
   Tv[112] := Tv[108] + Tv[110]+ Tv[111];
   Tv[109] := Tv[112];
   Tv[114] := MaxR(0,Tv[106] - Tv[109]);

   Tv[131] := MaxR(0,Vl(FetchElm(RetNo,'T691_4',7)) - Vl(FetchElm(RetNo,'T691_4',4)));
   If IsDeceased(RetNo) then Tv[131]:=0;
   Tv[132] := PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[115] := Tv[131] * Tv[132]/100;

   Tv[117] := Tv[114] + Tv[115];
   Tv[118] := GetPrvForTaxCredit(RetNo,'NB');
   Tv[119] := MaxR(0,Tv[117] - Tv[118]);
   Tv[121]:=MaxR(0,Tv[119]-Tv[120]);

   If Frm[FNo].Strings[137]+Frm[FNo].Strings[138]= '' then
             Frm[FNo].Strings[137]:= 'X';

    If Frm[FNo].Strings[137] >'' then
    begin
     Tv[151]:=CalcMortgageForeclosure(Ret[RetNo].Ln[127],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
     Tv[152]:=Vl(FetchElm(RetNo,'FORECLO',4));

     Tv[127] := MaxR(0,Ln[236]-Tv[151]);
     Tv[128] := Ret[RetNo].Ln[213];
     Tv[107] := Tv[127]+Tv[128];
     Tv[105] := Ret[RetNo].Ln[117];  //GetTotalUCCB(RetNo);
     Tv[154] := MaxR(0,Tv[107]-Tv[105]);

     Tv[51]:=MaxR(0,Vl(FetchElm(RetNo,'INFO',19))-(Tv[152]));  //spnetincome
     Tv[73]:=Vl(FetchElm(RetNo,'INFO',162));
     Tv[75]:=Vl(FetchElm(RetNo,'INFO',131));
     Tv[74]:=Tv[51]+Tv[73];
     Tv[76]:=MaxR(0,Tv[74]-Tv[75]);
     Tv[77] :=Tv[154]+Tv[76];
     Tv[78]:=Tv[121];

     Tv[122] := BasicRed;
     If MarStatus <3 then Tv[123] := BasicRed else Tv[123]:=0;
     If Ln[305]>0 then Tv[124] := BasicRed else Tv[124]:=0;
     Tv[125] := MinR(BasicRed * 2,Tv[122]+Tv[123]+Tv[124]); //Tv[1]+Tv[2]+Tv[3]);
     Tv[126] := Tv[125];


    //Tv[77]:=Tv[139];
     Tv[129] := TV[77];
     Tv[130] := 15808;  //20150228
     Tv[133] := MaxR(0,Tv[129]-Tv[130]);
     Tv[134] := 5;
     Tv[135] := Tv[133] * Tv[134]/100;
     Tv[136] := Tv[135];
     Tv[139] := MaxR(0,Tv[126]-Tv[136]);
     Tv[142] := Tv[139];
   end
   else
    begin
      For i:=122 to 126 do Tv[i]:=0;
      For i:=129 to 130 do Tv[i]:=0;
      For i:=133 to 136 do Tv[i]:=0;
      Tv[139]:=0;
      Tv[142]:=0;
    end;
   If Tv[120]>0 then
   begin
      For i:=122 to 126 do Tv[i]:=0;
      For i:=129 to 130 do Tv[i]:=0;
      For i:=133 to 136 do Tv[i]:=0;
      Tv[139]:=0;
      Tv[142]:=0;
   end;
   Tv[143]:=MaxR(0,Tv[78]-Tv[142]);

   Tv[144] := GetPrvPolit(RetNo,'NB');
   If Tv[144] <=200 then x:= Tv[144] * 0.75
   Else if ((Tv[144] >200) and (Tv[144] <=550)) then
        x := (Tv[144]-200) * 0.50 + 150
   Else if Tv[144] >550 then x := (Tv[144]-550) * 0.3333 + 325;
   If x >500 then x :=500;
   Tv[145] := MinR(500,x);
   Tv[146] := MaxR(0,Tv[143]-Tv[145]);

   If Tv[147]>750 then Tv[147] := 750;
   Tv[148] := MaxR(0,Tv[146]-Tv[147]);

   Tv[149]:=Vl(FetchElm(RetNo,'T1258',6));
   If Tv[149]>15000 then Tv[149]:=15000;

   Tv[150]:=MaxR(0,Tv[148]-Tv[149]);
   Ln[428]:=Tv[150];
   Tv[79]:=Tv[142];
   Tv[81]:=Tv[119];
   Tv[82]:=MaxR(0,Tv[79]-Tv[81]);
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure NL428(RetNo:integer;FName:string;FNo:integer);
var i,count: integer;x,y,z:real;
Begin
 InitPrvConstants('NL');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NL') = false  then
 begin
  For i:=1 to 142 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   //Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314 Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));

   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];

   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];

   Tv[51]:= Ret[RetNo].Ln[313];
   If Tv[51]>10100 then Tv[51]:=10100;
//   Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40]:=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));

   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[66] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := MaxR(0,Tv[44]+Tv[45]);
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[51]+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

//SECOND PAGE-------------------------------------------------------------------

    Tv[101] := MaxR(Tv[20],MaxR(Tv[21],Tv[22])); //MaxR(Vl(FetchElm(RetNo,'NL428',20)),
                                                //MaxR(Vl(FetchElm(RetNo,'NL428',21)),Vl(FetchElm(RetNo,'NL428',22))));

    If SplitIncome(RetNo) then
     Tv[102] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[102] :=0;
    Tv[103] := Tv[101]+Tv[102];

    Tv[105] := Tv[61]; //Vl(FetchElm(RetNo,'NL428',61));

    Tv[111]:=Vl(FetchElm(RetNo,'DTC',9)); //Tv[6] * Tv[7]/100;
    Tv[113] := PrvConstant[RY].PrvOverseasRate;
    Tv[122] := PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[112] := Ret[RetNo].Ln[426];
    Tv[119] := Ret[RetNo].Ln[427];
    Tv[116] := Tv[112] * Tv[113]/100;
    Tv[123] := Tv[119] * Tv[122]/100;
    Tv[124] := Tv[105]+Tv[111]+Tv[116]+Tv[123];
    Tv[125] := Tv[124];
    Tv[126] := MaxR(0,Tv[103] - Tv[125]);

    Tv[145]:=Vl(FetchElm(RetNo,'T691_4',16));
    If IsDeceased(RetNo) then Tv[145]:=0;
    Tv[146]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[127]:=Tv[145] * Tv[146]/100;
    Tv[128] := Tv[126]+Tv[127];

    Tv[129] := Tv[128];
    //Tv[130] := MaxR(0,(Tv[129]-7102) * 9/100);
    Tv[130]:=MaxR(0,(Tv[129]-7102) * 4.5/100);
    Tv[131] := Tv[128]+Tv[130];
    Tv[132] := GetPrvForTaxCredit(RetNo,'NL');
    Tv[133] := MaxR(0,Tv[131] - Tv[132]);
    Tv[104] := GetPrvPolit(RetNo,'NL'); {Vl(FetchElm(RetNo,'POLIT',12));}
    If Tv[104] <=100 then x:= Tv[104] * 0.75
    Else if ((Tv[104] >100) and (Tv[104] <=550)) then
        x := (Tv[104]-100) * 0.50 + 75
    Else if Tv[104] >550 then x := (Tv[104]-550) * 0.3333 + 300;
    If x >500 then x :=500;
    Tv[108]:=x;
    Tv[110] := MaxR(0,Tv[133]-Tv[108]);

    Tv[118]:=MaxR(0,Tv[110]-Tv[109]);
    Tv[114]:=Vl(FetchElm(RetNo,'T1272',7));
    Tv[120]:=MaxR(0,Tv[118]-Tv[114]);

    Tv[69]:=MaxR(0,Tv[120]-Tv[68]);
    Tv[67]:=Tv[69];
    Tv[139]:=MaxR(0,Tv[67]-Tv[134]);
    If Frm[FNo].Strings[115]='' then Frm[FNo].Strings[115]:='Y';
    //If Ret[RetNo].MarStatus>2 then Strings[15]:='N';
    Tv[82]:=CalcMortgageForeclosure(Ret[RetNo].Ln[127],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
    Tv[75]:=Vl(FetchElm(RetNo,'FORECLO',4));
    If Frm[FNo].Strings[115]='Y' then
    begin
      Tv[148]:=MaxR(0,Ret[RetNo].Ln[236]-Tv[82]);
      Tv[149]:=Ret[RetNo].Ln[213];
      Tv[150]:=Tv[148]+Tv[149];
      Tv[106]:=Ret[RetNo].Ln[117];
      Tv[107]:=MaxR(0,Tv[150]-Tv[106]);

      //lowincome
      Tv[70]:=MaxR(0,Vl(FetchElm(RetNo,'INFO',19))
           - Tv[75]); //foreclosure spouse
      Tv[71]:=Vl(FetchElm(RetNo,'INFO',162));
      Tv[73]:=Vl(FetchElm(RetNo,'INFO',131));
      Tv[72]:=Tv[70]+Tv[71];
      Tv[74]:=MaxR(0,Tv[72]-Tv[73]);
      Tv[76] :=Tv[107]+Tv[74];
      Tv[77]:=Tv[139];

      Tv[140]:=464;
      If Ret[RetNo].MarStatus <3 then Tv[141]:=129 else Tv[141]:=0;
      If Tv[29] >0 then  //elg dep
       Tv[142]:=129
      else
       Tv[142]:=0;
      Tv[143]:=MinR(593,Tv[140]+Tv[141]+Tv[142]);
      Tv[147]:=Tv[143];

      Tv[78]:=Tv[76];
      If Tv[141]+Tv[142]>0 then
       Tv[151]:=21000
      else
       Tv[151]:=13000;
      Tv[152]:=MaxR(0,Tv[78]-Tv[151]);
      Tv[153]:=16;
      Tv[154]:=Tv[152]*Tv[153]/100;
      Tv[155]:=Tv[154];
      Tv[156]:=MaxR(0,Tv[147]-Tv[155]);
      Tv[157]:=Tv[156];
    end
    Else
    Begin
     For i:=140 to 143 do Tv[i]:=0;
     For i:=151 to 157 do Tv[i]:=0;
    end;
    If Tv[134]>0 then
    begin
     For i:=140 to 143 do Tv[i]:=0;
     For i:=151 to 157 do Tv[i]:=0;
    end;
    Tv[121]:=MaxR(0,Tv[77]-Tv[157]);
    Ln[428] := Tv[121];
    Tv[79]:=Tv[69];
    Tv[81]:=MaxR(0,Tv[79]-Tv[80]);
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure NT428(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,y,z:real;
Begin
 InitPrvConstants('NT');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NT') = false  then
 begin
  For i:=1 to 148 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   //Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;


   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Frm[FNo].Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
//   Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//Ret[RetNo].Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := MaxR(0,Tv[44]+Tv[45]);
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

   //SECOND PAGE ---------------------------------------------------------------
    Tv[101] := MaxR( MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[67]) );
         //MaxR(
         //MaxR(Vl(FetchElm(RetNo,'NT428',20)),Vl(FetchElm(RetNo,'NT428',21))),
         //MaxR(Vl(FetchElm(RetNo,'NT428',22)),Vl(FetchElm(RetNo,'NT428',67))));

    If SplitIncome(RetNo) then
     Tv[102] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[102] :=0;
    Tv[103] := Tv[101]+Tv[102];

    Tv[104] :=Tv[61];   //Vl(FetchElm(RetNo,'NT428',61));

    //Tv[6] := PrvConstant[RY].PrvDivRate;
    Tv[109] := PrvConstant[RY].PrvOverseasRate;
    Tv[112] := PrvConstant[RY].PrvAMTCarryOverRate;

    //Tv[5] := Ret[RetNo].Ln[120];
    Tv[108] := Ret[RetNo].Ln[426];
    Tv[111] := Ret[RetNo].Ln[427];
    Tv[107] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[5] * Tv[6]/100;
    Tv[110] := Tv[108] * Tv[109]/100;
    Tv[113] := Tv[111] * Tv[112]/100;
    Tv[114] := Tv[104]+Tv[107]+Tv[110]+Tv[113];
    Tv[115] := Tv[114];
    Tv[116] := MaxR(0,Tv[103] - Tv[115]);

    Tv[121]:=Vl(FetchElm(RetNo,'T691_4',16));
    If IsDeceased(RetNo) then Tv[121]:=0;
    Tv[122]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[117]:=Tv[121] * Tv[122]/100;


    Tv[118] := Tv[116]+Tv[117];

    If Ret[RetNo].Province <> 'NT' then
     Tv[119] :=0
    else
     Tv[119] := GetPrvForTaxCredit(RetNo,'NT');
    Tv[123] := MaxR(0,Tv[118]-Tv[119]);

     Tv[124] := GetPrvPolit(RetNo,'NT'); {Vl(FetchElm(RetNo,'POLIT',12));}
     If Tv[124] <= 100 then x := MinR(100,Tv[124])
     else if Tv[124] >100 then  x:=100+MaxR(0,(Tv[124] - 100)) * 0.50;
     Tv[125] := MinR(500,x);
     Tv[126]:=MaxR(0,Tv[123]-Tv[125]);

     Tv[51]:=Tv[126];
     Tv[127]:=MinR(100000,Tv[127]);
     Tv[128]:=MinR(5000,Tv[127]);
     Tv[129]:=Tv[128]*0.15;
     Tv[130]:=MaxR(0,Tv[127]-Tv[128]);
     Tv[131]:=Tv[130]*0.30;

     Tv[132]:=MinR(100000,Tv[132]);
     Tv[133]:=Tv[132]*0.30;
     Tv[134]:=Tv[129]+Tv[131]+Tv[133];
     Tv[105]:=Tv[134]+Tv[140];

     Tv[135]:=30000;
     Tv[136]:=Tv[129];
     Tv[137]:=MaxR(0,Tv[135]-Tv[136]);
     Tv[138]:=Tv[137];
     //Tv[39]:=MinR(Tv[34],Tv[38]);
     //Tv[41]:=Tv[39]+Tv[40];
     Tv[142]:=MinR(Tv[105],Tv[138]); //MinR(Tv[26],MinR(Tv[38],Tv[41]));

     Tv[120]:=MaxR(0,Tv[51]-Tv[142]);
     Ln[428] := Tv[120];

     Tv[143]:=Tv[105];
     Tv[144]:=MinR(Tv[51],Tv[142]);
     Tv[145]:=MaxR(0,Tv[143]-Tv[144]);
     If Tv[145]=0 then begin Tv[146]:=0;Tv[147]:=0;Tv[148]:=0;end;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PE428(RetNo:integer;FName:string;FNo:integer);
var i,k,count: integer;x,y,z:real;
Begin
 InitPrvConstants('PE');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'PE') = false  then
 begin
  For i:=1 to 154 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   //Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
 
   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
 
   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
 
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;
 
   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;
 
   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;
 
   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   If UpperCase(Frm[FNo].Strings[62]) = 'Y' then
    Tv[24]:=Tv[63]
   else
    Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
 
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Frm[FNo].Strings[67]:=FetchElm(RetNo,'PE428',181);
   {
   If Ret[RetNo].MarStatus < 3 then
   begin
    If Not IsLowerIncomeSpouse(RetNo) then Frm[FNo].Strings[67]:='';
   end;
   }
   Tv[68] := Vl(Frm[FNo].Strings[67]) * 100;
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
//   Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));
 
   Tv[37]:=GetPrvDisabXfer(RetNo);
   If Tv[75]>500 then Tv[75]:=500;
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40]:=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[66] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := MaxR(0,Tv[44]+Tv[45]);
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+Tv[68]+AddColumns(31,41,1)+Tv[47]+Tv[75];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];
 end;
   //SECOND PAGE----------------------------------------------------------------
 
 with Ret[RetNo].Frm[FNo] do
 begin
 
    Tv[101] := MaxR( TV[20],MaxR(TV[21],TV[22]) );
 
   If SplitIncome(RetNo) then
     Tv[102] := Vl(FetchElm(RetNo,'T1206_2',3))
   else
     Tv[102] :=0;
   Tv[103] := Tv[101]+Tv[102];
 
   Tv[104] := TV[61];
   Tv[116] := PrvConstant[RY].PrvOverseasRate;
   Tv[141] := PrvConstant[RY].PrvAmtCarryOverRate;
   Tv[113] := Ret[RetNo].Ln[426];
   Tv[140] := Ret[RetNo].Ln[427];
   Tv[108] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[5] * Tv[7]/100;
   Tv[117] := Tv[113] * Tv[116]/100;
   Tv[142] := Tv[140] * Tv[141]/100;
   Tv[143] := Tv[104]+Tv[108]+Tv[117]+Tv[142];
   Tv[144] := Tv[143];
   Tv[145] := MaxR(0,Tv[103] - Tv[144]);

   Tv[131]:=Vl(FetchElm(RetNo,'T691_4',16));
   If IsDeceased(RetNo) then Tv[131]:=0;
   Tv[132]:=PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[146]:=Tv[131] * Tv[132]/100;
   Tv[147] := Tv[145]+Tv[146];

   Tv[148] := Tv[147];
   Tv[149] := MaxR(0,Tv[148] - 8850) * 10/100;
   Tv[150] := Tv[147]+Tv[149];
   Tv[152] := MaxR(0,Tv[150]-Tv[151]);

   {Step 4}
   If Strings[137]+Strings[138] = '' then Strings[137] := 'X';
    {reduction}
   Tv[139]:=CalcMortgageForeclosure(Ret[RetNo].Ln[127],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
   Tv[155]:=Vl(FetchElm(RetNo,'FORECLO',4));
   If UpperCase(Strings[137]) = 'X' then
   begin
     Tv[122] :=MaxR(0,Ret[RetNo].Ln[236]-Tv[139]);
     Tv[123] := Ret[RetNo].Ln[213]; //MaxR(0,SpouseIncome(RetNo)-Tv[155]);
     Tv[124] := Tv[122] + Tv[123];
     Tv[105]:= Ret[RetNo].Ln[117]; //GetTotalUCCB(RetNo);
     Tv[107]:=MaxR(0,Tv[124]-Tv[105]);

     Tv[51]:=MaxR(0,Vl(FetchElm(RetNo,'INFO',19))-Tv[155]);  //spnetincome
     Tv[69]:=Vl(FetchElm(RetNo,'INFO',162));
     Tv[71]:=Vl(FetchElm(RetNo,'INFO',131));

     Tv[70]:=Tv[51]+Tv[69];
     Tv[72]:=MaxR(0,Tv[70]-Tv[71]);
     Tv[73] :=Tv[107]+Tv[72];

     Tv[74]:=Tv[152];
     Tv[109] := 250;
     If Ret[RetNo].MarStatus < 3 then Tv[114] := 250 else Tv[114] :=0;
     If Ret[RetNo].Ln[305]>0 then Tv[115] := 250 else Tv[115] :=0;
     Strings[118] := IntToStr(MystrToInt(FetchElm(RetNo,'DEPEND',1))
                           -MystrToInt(FetchElm(RetNo,'DEPEND',3))) ;
     If Vl(Strings[118]) <0 then Strings[118]:='';
                           {tot less eqiv to spouse}
     Tv[119] := Vl(Ret[RetNo].Frm[FNo].Strings[118]) * 200;
     Tv[120] := Tv[109] + Tv[114] + Tv[115] + Tv[119];

     Tv[139]:=CalcMortgageForeclosure(Ret[RetNo].Ln[127], Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
     Tv[76] := MaxR(0,Tv[73]);
     Tv[155]:=Vl(FetchElm(RetNo,'FORECLO',4)); //CalcMortgageForeclosure(SpRetNo);

     Tv[125] := 15000;
     Tv[126] := MaxR(0,(Tv[76] - Tv[125]));
     Tv[127] := 5;
     Tv[128] := Tv[126] * Tv[127] /100;
     Tv[129] := Tv[128];
     Tv[111] := MaxR(0,(Tv[120] - Tv[129]));
     Tv[130] :=Tv[111];
    end
    else
     begin
      Tv[109]:=0;Tv[76]:=0;Tv[107]:=0;
      For i:=114 to 115 do Tv[i]:=0;
      For i:=118 to 120 do Tv[i]:=0;
      For i:=125 to 130 do Tv[i]:=0;
     end;

   //less than 19, no kids, no spouse
    If (Ret[RetNo].Age<19) and (Tv[114]+Tv[115]+Tv[119]=0) then
    begin
     Tv[109]:=0;
     for i:=114 to 115 do TV[i] :=0;
     for i:=119 to 129 do TV[i] :=0;
     Tv[111]:=0;
     Tv[130]:=0;
    end;

   If Ret[RetNo].Province <> 'PE' then Tv[130]:=0;
   Tv[74]:=Tv[152];
   Tv[153] := MaxR(0,Tv[74]-Tv[130]);
   Tv[154] := GetPrvForTaxCredit(RetNo,'PE');
   Tv[133] := MaxR(0,Tv[153]-Tv[154]);

   If Ret[RetNo].Province = 'PE' then
   begin
       {Polit}
       Tv[106] := GetPrvPolit(RetNo,'PE'); {Vl(FetchElm(RetNo,'POLIT',12));}
       If Tv[106] <=100 then x:= Tv[106] * 0.75
       Else if ((Tv[106] >100) and (Tv[106] <=550)) then
           x := (Tv[106]-100) * 0.50 + 75
       Else if Tv[106] >550 then x := (Tv[106]-550) * 0.3333 + 300;
       If x >500 then x :=500;
       Tv[110]:=x;
   end;
   Tv[134] := Tv[130];
   Tv[135]:=Tv[150];
   Tv[136] := MaxR(0,Tv[134]-Tv[135]);

   Tv[112]:= MaxR(0,Tv[133]-Tv[110]);
   Ret[RetNo].Ln[428] := Tv[112];

   // young children
   i:=160;
   k:=0;
   Repeat
    If Vl(Strings[i])>12 then Strings[i]:='12';
    If AppYear='2006' then
    begin
     If Vl(Strings[i])>6 then Strings[i]:='6';
    end;
    If (Ret[RetNo].Ln[236] > Vl(FetchElm(RetNo,'INFO',19)))
    and (Ret[RetNo].MarStatus <3)  then Strings[i-1]:='';
    If Strings[i-1] >'' then  k:=k+MyStrToInt(Strings[i]);
    Inc(i,5);
   until i>180;
   Strings[181]:=IntToStr(k);
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure MB428(RetNo:integer;FName:string;FNo:integer);
var i,j,k: integer;
Begin
 InitPrvConstants('MB');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'MB') = false  then
 begin
  For i:=1 to 161 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   //Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     {Ret[RetNo].Frm[FNo].Strings[11] := OnConstant[RY].OnRate1;}
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
   Tv[67] := Ret[RetNo].Ln[365];
   Tv[51] := Ret[RetNo].Ln[313];
   If Tv[51]>10000 then Tv[51]:=10000;
//   Tv[34] := GetPrvPnsDed(RetNo); //Vl(FetchElm(RetNo,'PNSDED',18));
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90)); //not 39
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[66] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := MaxR(0,Tv[44]+Tv[45]);
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+Tv[67]+Tv[51]+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

//SECOND PAGE ------------------------------------------------------------------

     //Tv[1] := MaxR(MaxR(Vl(FetchElm(RetNo,'MB428',20)),

     Tv[101] := MaxR(Tv[20], MaxR(Tv[21],Tv[22]));
       //, MaxR(Tv[72],Tv[79]) );

     If SplitIncome(RetNo) then
      Tv[112] := Vl(FetchElm(RetNo,'T1206_2',3))
     else
      Tv[112] :=0;
     Tv[113]:=Tv[101]+Tv[112];
     Tv[105]:=Tv[61];          //Vl(FetchElm(RetNo,'MB428',61));

     Tv[110] := PrvConstant[RY].PrvOverseasRate;
     Tv[111] := PrvConstant[RY].PrvAMTCarryOverRate;

     Tv[108] := Ret[RetNo].Ln[426];
     Tv[163] := Ret[RetNo].Ln[427];

     Tv[107] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[6] * Tv[9]/100;
     Tv[162] := Tv[108] * Tv[110]/100;
     Tv[164] := Tv[163] * Tv[111]/100;

     Tv[165] := Tv[105]+Tv[107]+Tv[162]+Tv[164];
     Tv[166]:=Tv[165];
     Tv[167]:=MaxR(0,Tv[113]-Tv[166]);

     Tv[128] := 225;
     If Tv[28] > 0 then Tv[129] := 225 else Tv[129]:=0;
     If Tv[29] > 0 then Tv[130] := 225 else Tv[130]:=0;
     If Age >= 65 then Tv[131] := 225 else Tv[131] :=0;

     If (Vl(FetchElm(RetNo,'S2PRV',3))>0) //claimed age xfer  S@PRV NOT S2
     and (Vl(FetchElm(RetNo,'S2PRV',3)) > Vl(FetchElm(RetNo,'S2PRV',18)))
     then  Tv[132]:= 225 else Tv[132] :=0;

     If (Vl(FetchElm(RetNo,'S2PRV',5))>0) //claimed disab xfer
     and (Vl(FetchElm(RetNo,'S2PRV',19)) > Vl(FetchElm(RetNo,'S2PRV',6)))
     then  Tv[143]:= 300 else Tv[143] :=0;

     {Higher net income claims the disabled dependants: }
     {?MANTAX  in fact it needs the adjusted income}

    (*
     k:=0;
     If ((Ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (Ret[RetNo].MarStatus>2)) then
     begin  //count transfers
      If Tv[37] > 0 then   //>=18 and infirm
         k := StrToInt(FetchElm(RetNo,'DEPEND',2))+
              StrToInt(FetchElm(RetNo,'DEPEND',4));
     end;
     *)
     If Tv[36] > 0 then k:=k+1; {disability for self}
     Frm[FNo].Strings[133] := IntTostr(k);

    (*
     //REDUCTION FOR DISABLED DEPENDANDS claimed ON LINE 5820
     If ((Ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (Ret[RetNo].MarStatus>2))
     and (Tv[30] > 0 )   //line 5820
     then
      k:=MyStrToInt(FetchElm(RetNo,'DEPEND',4)) //infirm over 18
        +MyStrToInt(FetchElm(RetNo,'DEPEND',53)) {infirm eq 18}
     Else
      k:=0;
     If Tv[130]>0 then k:=k-1; {equiv to spouse}
     If k<0 then k:=0;
     Frm[FNo].Strings[135] := IntToStr(k);

     k:=MyStrToInt(FetchElm(RetNo,'DEPEND',1)); {18 or less}
     If Tv[130] >0 then k:= k-1;  {equiv to spouse}
     If k<0 then k:=0;
     If ((Ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo))
        or (Ret[RetNo].MarStatus>2)) then
     //If (GetPrvNetIncome(RetNo,'MB') > SpouseIncome(RetNo)) then
         Frm[FNo].Strings[137] := IntToStr(k)
     else
         Frm[FNo].Strings[137] := '';

     If Vl(Frm[FNo].Strings[137]) >0 then  //copy dependants
     begin
       i := 146;j:=5;
       If Ret[RetNo].FrmHasData[GetFormNo('DEPEND')] then
       repeat
         If (FetchElm(RetNo,'DEPEND',j+6) ='Child')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Son')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Daughter') then
         begin
           If CalcAge(FetchElm(RetNo,'DEPEND',j+5)) <=18 then
            begin
             Frm[FNo].Strings[i]   := FetchElm(RetNo,'DEPEND',j)+' '+
                             FetchElm(RetNo,'DEPEND',j+1); //first/last
             Frm[FNo].Strings[i+1]:= FetchElm(RetNo,'DEPEND',j+6); //relationship
             Frm[FNo].Strings[i+2] := FetchElm(RetNo,'DEPEND',j+5); //birthdate
             Frm[FNo].Strings[i+3] := FetchElm(RetNo,'DEPEND',j+2); //sin
            end;
           inc(i,4);
         end;
       Inc(j,15);
       until (i>158) or (j>125);
     end
     else
      For i:=146 to 161 do Frm[FNo].Strings[i]:='';
    *)
     Tv[134] := Vl(Ret[RetNo].Frm[FNo].Strings[133]) * 300;
     Tv[136] := Vl(Ret[RetNo].Frm[FNo].Strings[135]) * 300;
     Tv[138] := Vl(Ret[RetNo].Frm[FNo].Strings[137]) * 300;
     Tv[139] := 0;
     For i := 128 to 132 do Tv[139] := Tv[139] + Tv[i];
     Tv[139] := Tv[139] + Tv[143]+ Tv[134] + Tv[136] + Tv[138];
     Tv[102]:= Ln[236];
     Tv[140] := Tv[102] * 1/100;
     Tv[141] := MaxR(0,(Tv[139] - Tv[140]));
     Tv[142] := Tv[141];
     If Ret[RetNo].Province <> 'MB' then
     begin
      for i:=128 to 142 do Tv[i] :=0;
      Tv[143] :=0;
     end;
     Tv[117] := MaxR(0,(Tv[167] - Tv[142]));

     Tv[114]:=AmountForPrvMinTax(RetNo);
     Tv[115]:=PrvConstant[RY].PrvAMTCarryOverRate;
     Tv[118]:=Tv[114] * Tv[115]/100;

     Tv[119] := Tv[117]+Tv[118];

     Tv[68]:=Tv[119];
     Tv[120] := GetPrvPolit(RetNo,'MB');
     If Tv[120] <= 400 then Tv[121] :=Tv[120]* 0.75
     else If (Tv[120]>400) and (Tv[120] <=750) then
       Tv[121]:= (Tv[120]-400) * 0.50 + 300
     else Tv[121] := (Tv[120] - 750) * 0.3333 +475;
     If Tv[121]>650 then Tv[121]:=650;

     Tv[122] := MaxR(0,Tv[68]-Tv[121]);
     {lab sp}
     //Tv[23] := Vl(FetchElm(RetNo,'LABORSP',4));
     If Tv[123]>1800 then Tv[123]:=1800; //Tv[23] := MinR(750,Tv[23]);
     {equity}
     Tv[124] := MinR(1500,Tv[124]);
     Tv[125] := Tv[123]+Tv[124];
     Tv[126] := Tv[125];
     Tv[127] := MaxR(0,Tv[122] -Tv[126]);
     Tv[144] := GetPrvForTaxCredit(RetNo,'MB');
     If Tv[118]>0 then Tv[144]:=0;  //if min tax

     Tv[103]:= MaxR(0,Tv[127]-Tv[144]);
     Tv[14]:=Vl(FetchElm(RetNo,'T1241',6));
     Tv[168]:=Vl(FetchElm(RetNo,'T1256',6));
     If Tv[168]>9000 then Tv[168]:=9000;
     Tv[116] :=MaxR(0,Tv[103]-Tv[168]); //MaxR(0,Tv[3]-Tv[4]);
     Tv[104]:=Vl(FetchElm(RetNo,'T1241',6));
     Tv[69]:=MaxR(0,Tv[116]-Tv[104]);
     TV[70]:=Vl(FetchElm(RetNo,'T1005',11));
     Tv[145] := MaxR(0,Tv[69]-Tv[70]);
     Ln[428] := Tv[145];
 end;
   SaveTv(RetNo,FName,FNo);
end;

Procedure SK428(RetNo:integer;FName:string;FNo:integer);
var i,j: integer;DepFNo:integer;
Begin
 InitPrvConstants('SK');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'SK') = false  then
 begin
  For i:=1 to 161 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  // Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314 Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
//   Tv[28] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   If UpperCase(Frm[FNo].Strings[64])='Y' then
     begin Tv[27]:=Tv[65];Tv[28]:=Tv[65];end;

   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));

  (*
   {lower income claims}
   If MarStatus <3 then
   begin
    If GetPrvNetIncome(RetNo,'SK')< SpouseIncome(RetNo) then
    begin
    Frm[FNo].Strings[68] :=IntToStr
       (MyStrToInt(FetchElm(RetNo,'DEPEND',1))
       -MyStrToInt(FetchElm(RetNo,'DEPEND',3)))
    end
    else
    Frm[FNo].Strings[68] :='';
   end
   else
    Frm[FNo].Strings[68] :=IntToStr
       (MyStrToInt(FetchElm(RetNo,'DEPEND',1))
       -MyStrToInt(FetchElm(RetNo,'DEPEND',3)));
   *)
   If Vl(Frm[FNo].Strings[68]) <0 then Frm[FNo].Strings[68] :='';

   Tv[66] := Vl(Frm[FNo].Strings[68]) * 5834; //2743;  //20150228
   Tv[67]:=0;
   If Age >=65 then Tv[67]:=1237; //1097;  //20150228
   // else Tv[67]:=0;
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
//   Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//Ret[RetNo].Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40]:=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[69] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := MaxR(0,Tv[44]+Tv[45]);
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+Tv[66]+Tv[67]
           +AddColumns(31,41,1)+Tv[47]+Tv[51];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

    For i:=146 to 161 do Frm[FNo].Strings[i]:='';
   (*
    If GetPrvNetIncome(RetNo,'SK')< SpouseIncome(RetNo) then
    begin
     i:=146;j:=5; {j:index to depend}
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
       Frm[FNo].Strings[i]:=FetchElmFNo(RetNo,DepFNo,j)
            +' '+FetchElmFNo(RetNo,DepFNo,j+1); {Nm}
       Frm[FNo].Strings[i+1]:=FetchElmFNo(RetNo,DepFNo,j+6); {Relat}
       Frm[FNo].Strings[i+2]:=FetchElmFNo(RetNo,DepFNo,j+5); {birth}
       Frm[FNo].Strings[i+3]:=FetchElmFNo(RetNo,DepFNo,j+2); {Nm}
       Inc(i,4);
      end;
      Inc(j,15);
     until (j>125) or (i>158);
   end;
   *)
   //SECOND PAGE ---------------------------------------------------------------
    Tv[101] := MaxR(Tv[20],MaxR(Tv[21],Tv[22]));        //MaxR(Vl(FetchElm(RetNo,'SK428',20)),
                                                        //MaxR(Vl(FetchElm(RetNo,'SK428',21)),Vl(FetchElm(RetNo,'SK428',22))));
    Tv[142] := MaxR(0,Tv[101] - Tv[141]);
    If SplitIncome(RetNo) then
     Tv[102] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[102] :=0;
    Tv[103] := Tv[142]+Tv[102];
    Tv[104] :=Tv[61];           //Vl(FetchElm(RetNo,'SK428',61));
    //TV[5] := MaxR(0,Tv[3]-Tv[4);
    Tv[106] :=Vl(FetchElm(RetNo,'T1284',16));
    Tv[107] :=Vl(FetchElm(RetNo,'T1284',21));
    Tv[110] := PrvConstant[RY].PrvOverseasRate;
    Tv[113] := PrvConstant[RY].PrvAMTCarryOverRate;

    //Tv[6] := Ret[RetNo].Ln[120];
    Tv[109] := Ret[RetNo].Ln[426];
    Tv[112] := Ret[RetNo].Ln[427];
    Tv[108] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[6] * Tv[7]/100;
    Tv[111] := Tv[109] * Tv[110]/100;
    Tv[114] := Tv[112] * Tv[113]/100;
    Tv[115] := Tv[104]+Tv[108]+Tv[111]+Tv[114];
    Tv[116] := Tv[115];
    Tv[117] := MaxR(0,Tv[103] - Tv[116]);

    Tv[162]:=AmountForPrvMinTax(RetNo);
    If IsDeceased(RetNo) then Tv[162]:=0;
    Tv[163]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[105]:=Tv[162] * Tv[163]/100;
    Tv[143]:=Tv[117]+Tv[105];
    Tv[118] := GetPrvForTaxCredit(RetNo,'SK');
    Tv[119] := MaxR(0,Tv[143]-Tv[118]);
    //Tv[44] := skroyalty ?
    Tv[145]:=MaxR(0,Tv[119]-Tv[144]);

    Tv[120] := GetPrvPolit(RetNo,'SK');
    If Tv[120] <=400 then Tv[121]:= Tv[120] * 0.75
    else If (Tv[120] >400) and (Tv[120] <=750) then
      Tv[121]:= (Tv[120]-400) * 0.50 + 300
    else If (Tv[120] >750) then Tv[121]:= (Tv[120]-750) * 0.3333 + 475;
    If Tv[121] > 1275 then Tv[121]:= 650;

    Tv[122] := MaxR(0,Tv[145]-Tv[121]);
    Tv[123] := MinR(1000,Tv[123]);
    Tv[124] := MinR(1000,Tv[124]);
    Tv[127] := MinR(1000,Tv[123]+Tv[124]);
    Tv[126] := Tv[127];
    Tv[125] := MaxR(0,Tv[122]-Tv[126]);

    Tv[70]:=Tv[125];
    Tv[72]:=Tv[71]+Tv[107];
    Tv[73]:=Tv[72];

    Tv[164]:=Tv[106];
    If Tv[73]>0 then Tv[164]:=Tv[73];
    Tv[165]:=Tv[164];
    Tv[166]:=MaxR(0,Tv[70]-Tv[165]);

   // Tv[128] := MinR(850,Tv[128]);
   // Tv[130]:= Tv[128];
   // If Tv[129]>0 then Tv[130]:=Tv[129];
   // Tv[131]:= Tv[130];
    Tv[132] := MaxR(0,Tv[166]-Tv[129]);
    //Tv[35]:= Tv[33]+Tv[34];
    //Tv[36]:=Tv[35];
    Tv[137] := MaxR(0,Tv[132]-Tv[134]);
    Ln[428] := Tv[137];
  
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure YT428(RetNo:integer;FName:string;FNo:integer);
var i,count: integer;x,y,z:real;
Begin
 InitPrvConstants('YT');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'YT') = false  then
 begin
  For i:=1 to 141 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  // Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Frm[FNo].Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Ret[RetNo].Ln[301];
   Tv[25] := Ret[RetNo].Ln[367];
   Tv[28]:=  Ret[RetNo].Ln[303];
   //Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
   //Tv[26] := SpouseIncome(RetNo);
   //Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   //Tv[28]:= Tv[27];
  // If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];

   Tv[26] := Ret[RetNo].Ln[365];
   Tv[29] := Ret[RetNo].Ln[305]; //Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Ret[RetNo].Ln[306]; //Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
   Tv[73] := Ret[RetNo].Ln[363];
   Tv[74] := Ret[RetNo].Ln[364];
   Tv[51] := Ret[RetNo].Ln[313];
//   Tv[34] := GetPrvPnsDed(RetNo);//Ret[RetNo].Ln[314]; //Vl(FetchElm(RetNo,'PNSDED',18));//Ret[RetNo].Ln[314];
   Tv[35] := Ret[RetNo].Ln[315]; //Vl(FetchElm(RetNo,'S5PRV',90));
   Tv[36] :=Ret[RetNo].Ln[316];
   Tv[37] :=Ret[RetNo].Ln[318]; //GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] := GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42] := Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+Tv[25]+Tv[26]+AddColumns(28,30,1)+Tv[73]+Tv[74]+Tv[51]+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

   //SECOND PAGE ---------------------------------------------------------------
    Tv[134] := MaxR( MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[67]) );
//      MaxR(
//      MaxR(Vl(FetchElm(RetNo,'YT428',20)),Vl(FetchElm(RetNo,'YT428',21))),
//      MaxR(Vl(FetchElm(RetNo,'YT428',22)),Vl(FetchElm(RetNo,'YT428',67))));

    If SplitIncome(RetNo) then
     Tv[133] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[133] :=0;
    Tv[132] := Tv[134]+Tv[133];

    Tv[131] := Tv[61];   //Vl(FetchElm(RetNo,'YT428',61));

    //Tv[6] := PrvConstant[RY].PrvDivRate;
    Tv[109] := PrvConstant[RY].PrvOverseasRate;
    Tv[112] := PrvConstant[RY].PrvAMTCarryOverRate;

    //Tv[30] := Ret[RetNo].Ln[120];
    Tv[129] := Ret[RetNo].Ln[426];
    Tv[127] := Ret[RetNo].Ln[427];
    Tv[108] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[30] * Tv[6]/100;
    Tv[128] := Tv[129] * Tv[109]/100;
    Tv[126] := Tv[127] * Tv[112]/100;
    Tv[125] := Tv[131]+Tv[108]+Tv[128]+Tv[126];
    Tv[111] := Tv[125];
    Tv[110] := MaxR(0,Tv[132] - Tv[111]);

    Tv[102]:=Vl(FetchElm(RetNo,'T691_4',16));
    If IsDeceased(RetNo) then Tv[102]:=0;
    Tv[101]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[107]:=Tv[102] * Tv[101]/100;
    Tv[105] := Tv[110]+Tv[107];

    Tv[135]:=Tv[105];
    Tv[136]:=6000;
    Tv[137]:=MaxR(0,Tv[135]-Tv[136]);
    Tv[138]:=5;
    Tv[139]:=Tv[137]*Tv[138]/100;
    Tv[140]:=Tv[139];
    Tv[141]:=Tv[105]+Tv[140];

    If Ret[RetNo].Province <> 'YT' then
     Tv[104] :=0
    else
     Tv[104] := GetPrvForTaxCredit(RetNo,'YT');
    Tv[103]:=MaxR(0,Tv[141]-Tv[104]);

    Tv[27]:=Tv[103];

    Tv[114] := Ln[236];
    Tv[62]  :=Ln[213];
    Tv[63]:=Tv[114]+Tv[62];
    Tv[106] := Ln[117];
    Tv[130] :=MaxR(0,Tv[63]-Tv[106]);

    If Tv[130]<25000 then
    begin
     Tv[113] := 300;
     Tv[142]:=Tv[130];
     Tv[115] := 15000;
     Tv[116] := MaxR(0,Tv[142] - Tv[115]);
     Tv[117] := 3;
     Tv[118] := Tv[116] * Tv[117]/100;
     Tv[119] := Tv[118];
     Tv[120] := MaxR(0,Tv[113] - Tv[119]);
     Tv[124] := Tv[27];
     Tv[121] := Tv[124] * 0.80;
     Tv[122] := MinR(Tv[120],Tv[121]);
    end
    else
    begin
     Tv[113] := 0;
     Tv[142]:=0;
     Tv[115] :=0;
     Tv[116] :=0;
     Tv[117] :=0;
     Tv[118] := 0;
     Tv[119] := 0;
     Tv[120] := 0;
     Tv[124] := 0;
     Tv[121] := 0;
     Tv[122] := 0;
    end;
  (*
    If ((Ret[RetNo].MarStatus <3) and (Ln[236] < SpouseIncome(RetNo)))
    or (Tv[122] =0) then
    begin {higher income can claim it}
       //Tv[113]:=0;
       //TV[142]:=0;
       //For i:=115 to 122 do Tv[i] :=0;
       //Tv[124] :=0;
      // Tv[130]:=0;
      Tv[142]:=0;
    end;
    *)
    Tv[115]:=15000;
    Tv[117]:=3;
    If Ret[RetNo].Province <> 'YT' then Tv[122]:=0;
    Tv[123] := MaxR(0,Tv[27] - Tv[122]);
    Ln[428] := Tv[123];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure AB428(RetNo:integer;FName:string;FNo:integer);
Var i,DonFNo:Integer;x,y,z:real;
Begin
 InitPrvConstants('AB');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'AB') = false  then
 begin
  For i:=1 to 122 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 DonFNo:=GetFormNo('DON');
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];

   Tv[1] := PrvConstant[RY].PrvSpouseBasicAmount;
   Tv[2] := Vl(FetchElm(RetNo,'S5PRV',8));
   Tv[3]:= Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
//   Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   { Vl(FetchElm(RetNo,'DISABPV',71));}
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40]:=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[66] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[51]:=Ret[RetNo].Ln[313];
   If Tv[51]>10557 then Tv[51]:=10557;
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+Tv[51]+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;

   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[13]:=
      Vl(FetchElmFNo(RetNo,DonFNo,136))
      +Vl(FetchElmFNo(RetNo,DonFNo,141))
      +Vl(FetchElmFNo(RetNo,DonFNo,90))
      +Vl(FetchElmFNo(RetNo,DonFNo,95))
      +Vl(FetchElmFNo(RetNo,DonFNo,100));
   Tv[15]:=Tv[13];
   Tv[16]:=MinR(Tv[53],Tv[15]);
   Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
   Tv[18]:=12.75; //PrvConstant[RY].PrvDonRate2;
   Tv[19]:=Tv[17] * Tv[18] /100;
   Tv[56]:=Ln[347];
   Tv[20]:=Tv[17];
   Tv[21]:=MaxR(0,Tv[56]-Tv[20]);
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[21] * Tv[57]/100;
   Tv[22]:=Tv[55]+Tv[19]+Tv[58];
   Tv[59]:=Tv[22];
   Tv[61] := Tv[52]+Tv[59];

   //SECOND PAGE ---------------------------------------------------------------
  // Tv[5] := Ret[RetNo].Ln[260];
   Tv[5]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314 Tv[5]:=TaxRec.TaxableIncome;
   If UpperCase(Frm[FNo].Strings[11])='Y' then Tv[5]:=Tv[12];
   Frm[FNo].Strings[6] := PrvConstant[RY].PrvRate1;
   Tv[7] := Tv[5] * Vl(Frm[FNo].Strings[6])/100;
   Tv[8]:=Vl(FetchElm(RetNo,'T1206_2',3));
   Tv[9] := Tv[7]+Tv[8];

   Tv[101] := Tv[61];    //Vl(FetchElm(RetNo,'AB428',4));
   //Tv[2] := Ln[120];
   //Tv[18]:= PrvConstant[RY].PrvDivRate;
   Tv[103] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[2] * Tv[18]/100;

   Tv[104] := Ln[426];
   Tv[119]:= PrvConstant[RY].PrvOverseasRate;
   Tv[105] := Tv[104] * Tv[119]/100;

   Tv[106] := Ln[427];
   Tv[120]:= PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[107] := Tv[106] * Tv[120]/100;

   Tv[108] := Tv[101]+Tv[103]+Tv[105]+Tv[107];
   Tv[109] := Tv[108];
   Tv[110] :=MaxR(0,Tv[9]-Tv[109]);
   Tv[123]:=AmountForPrvMinTax(RetNo);
   Tv[124]:=PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[121]:=Tv[123] * Tv[124]/100;
   Tv[122]:= Tv[110]+Tv[121];

   Tv[111] :=GetPrvForTaxCredit(RetNo,'AB');
   Tv[112] := MaxR(0,Tv[122]-Tv[111]);

   If Ret[RetNo].Province = 'AB' then
   begin
    Tv[113] := GetPrvPolit(RetNo,'AB');
    If Tv[113] <= 200 then
       Tv[114] :=Tv[113]* 0.75
    else If (Tv[113]>200) and (Tv[113] <=1100) then
       Tv[114]:= (Tv[113]-200) * 0.50 +150
    else if (Tv[113]> 1100) and (Tv[113]<=2300)
       then Tv[114] := (Tv[113] - 1100) * 0.3333 + 600;
    If Tv[113]>2300 then Tv[114]:=1000;
   end;

   If Ret[RetNo].Province = 'AB' then
   begin
    Tv[125] := Vl(FetchElm(RetNo,'POLIT',16));
    If Tv[125] <= 200 then
       Tv[126] :=Tv[125]* 0.75
    else If (Tv[125]>200) and (Tv[125] <=1100) then
       Tv[126]:= (Tv[125]-200) * 0.50 +150
    else if (Tv[125]> 1100) and (Tv[125]<=2300)
       then Tv[126] := (Tv[125] - 1100) * 0.3333 + 600;
    If Tv[125]>2300 then Tv[126]:=1000;
   end;

  Tv[128] := MaxR(0,Tv[114]+Tv[126]);
  Tv[127] := MaxR(0,Tv[114]+Tv[126]); //same
  Tv[115] := MaxR(0,Tv[112]-Tv[127]);

  Tv[116] := Tv[14] * 0.10;
  Tv[117] := MaxR(0,Tv[115]-Tv[116]);
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure NS428(RetNo:integer;FName:string;FNo:integer);
Var i,k:integer;
Begin
 InitPrvConstants('NS');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NS') = false  then
 begin
  For i:=1 to 150 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   //Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314 Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and  (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Frm[FNo].Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;


   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];

   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Frm[FNo].Strings[73]:=Frm[FNo].Strings[158];
   (*
   If Ret[RetNo].MarStatus < 3 then
   begin
    If Not IsLowerIncomeSpouse(RetNo) then Frm[FNo].Strings[73]:='';
   end;
   *)
   Tv[74]:= Vl(Frm[FNo].Strings[73])*100;
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
//   Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[75] := Vl(FetchElm(RetNo,'SPORTS',3));
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+Tv[74]+AddColumns(31,41,1)+Tv[47]+Tv[75];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

//SECOND PAGE-------------------------------------------------------------------

   Tv[130]:=0;
   //if Vl(FetchElm(RetNo,'NS428',20)) > 0 then
   if Tv[20] > 0 then
        Tv[130] := Tv[20]      //Vl(FetchElm(RetNo,'NS428',20))
   else if Tv[21] > 0 then     //Vl(FetchElm(RetNo,'NS428',21)) > 0 then
        Tv[130] := Tv[21]      //Vl(FetchElm(RetNo,'NS428',21))
   else if Tv[22] > 0 then          //Vl(FetchElm(RetNo,'NS428',22)) > 0 then
        Tv[130] := Tv[22]      //Vl(FetchElm(RetNo,'NS428',22))
   else if Tv[67] > 0 then         //Vl(FetchElm(RetNo,'NS428',67)) > 0 then
        Tv[130] := Tv[67];     //Vl(FetchElm(RetNo,'NS428',67));

   Tv[105] := PrvConstant[RY].PrvOverseasRate;
   Tv[106] := PrvConstant[RY].PrvAmtCarryOverRate;

   If SplitIncome(RetNo) then
     Tv[131] := Vl(FetchElm(RetNo,'T1206_2',3))
   else
     Tv[131] :=0;
   Tv[132] := Tv[130]+Tv[131];
   Tv[133] := Tv[61]; //Vl(FetchElm(RetNo,'NS428',61));
   Tv[137] := Ret[RetNo].Ln[426];
   Tv[139] := Ret[RetNo].Ln[427];
   If (Ret[RetNo].Province <> 'NS') then
   begin
    Tv[135] := 0;
    Tv[137] := 0;
   end;
   Tv[136] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[35] * Tv[4]/100;
   Tv[138] := Tv[137] * Tv[105]/100;
   Tv[140] := Tv[139] * Tv[106]/100;
   Tv[141] := Tv[133]+Tv[136]+Tv[138]+Tv[140];
   Tv[142] := Tv[141];
   Tv[143] := MaxR(0,Tv[132] - Tv[142]);

   Tv[112]:=Vl(FetchElm(RetNo,'T691_4',16));
   If IsDeceased(RetNo) then Tv[112]:=0;
   Tv[120]:=PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[144]:=Tv[112] * Tv[120]/100;
   Tv[145] := Tv[143]+Tv[144];

   Tv[146] := Tv[145];
   Tv[147] := MaxR(0,Tv[146] - 10000) * 10/100;
   Tv[148] :=Tv[145]+Tv[147];
   Tv[149] := GetPrvForTaxCredit(RetNo,'NS');
   Tv[150] := MaxR(0,Tv[148] - Tv[149]);

    //less than 19, no kids, no spouse
    If (Ret[RetNo].Age<19) and (Tv[108]+Tv[109]+Tv[110]=0) then
    begin
     for i:=107 to 111 do TV[i] :=0;
     for i:=113 to 118 do TV[i] :=0;
     for i:=126 to 127 do TV[i] :=0;
    end;

    Tv[122]:=CalcMortgageForeclosure(Ret[RetNo].Ln[127],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
    Tv[124]:=Vl(FetchElm(RetNo,'FORECLO',4)); //CalcMortgageForeclosure(SpRetNo);
    Tv[113] := MaxR(0,Ln[236]-Tv[122]);
    Tv[114] := Ret[RetNo].Ln[213]; //,MaxR(0,SpouseIncome(RetNo)-Tv[124]);
    Tv[115] := Tv[113] + Tv[114];
    Tv[104]:=  Ret[RetNo].Ln[117];  //GetTotalUCCB(RetNo);
    Tv[125]:=MaxR(0,TV[115]-Tv[104]);

    Tv[51]:=MaxR(0,Vl(FetchElm(RetNo,'INFO',19))-Tv[124]);
    Tv[76]:=Vl(FetchElm(RetNo,'INFO',162));
    Tv[78]:=Vl(FetchElm(RetNo,'INFO',131));
    Tv[77]:=Tv[51]+Tv[76];
    Tv[79]:=MaxR(0,Tv[77]-Tv[78]);
    Tv[81] :=Tv[125]+Tv[79];
    Tv[82]:=Tv[150];

   If Frm[FNo].Strings[102]+Frm[FNo].Strings[103]= '' then
      Frm[FNo].Strings[102] := 'X';
   If UpperCase(Frm[FNo].Strings[102]) = 'X' then {reduction claimed}
    begin
     Tv[107] := 300;
     If MarStatus < 3 then Tv[108] := 300 else Tv[108] :=0;
     If Ln[305]>0 then Tv[109] := 300 else Tv[109] :=0;
     Frm[FNo].Strings[121] :=
        IntToStr(MyStrToInt(FetchElm(RetNo,'DEPEND',1))
        -MyStrToInt(FetchElm(RetNo,'DEPEND',3)));

     If Vl(Frm[FNo].Strings[121]) <0 then
            Frm[FNo].Strings[121] :='';

     {?NSTAX  above should exclude if kids were eqiv to spouse}
     Tv[110] := Vl(Ret[RetNo].Frm[FNo].Strings[121]) * 165;
     Tv[111] := Tv[107] + Tv[108] + Tv[109] + Tv[110];
    end
    else
    begin
     for i:=107 to 111 do TV[i] :=0;
     Frm[FNo].Strings[121] :='';
    end;

    Tv[160] := Tv[81];
    Tv[116] := 15000;
    Tv[117] := MaxR(0,(Tv[160] - Tv[116]));
    Tv[126] := 5;
    Tv[127] := Tv[117] * Tv[126] /100;
    Tv[118] := Tv[127];

    Tv[101] := MaxR(0,(Tv[111] - Tv[118]));
    Tv[119]:=Tv[101];
    If Ret[RetNo].Province <> 'NS' then Tv[119]:=0;
    Tv[128]:=MaxR(0,Tv[82]-Tv[119]);
    Tv[129] := GetPrvPolit(RetNo,'NS');
    {
    If Tv[129] <= 100 then Tv[134] :=Tv[129]* 0.75
    else If (Tv[129]>100) and (Tv[129] <=550) then
       Tv[134]:= (Tv[129]-100) * 0.50 + 75
    else Tv[134] := (Tv[129] - 550) * 0.3333 +300;
    If Tv[134]>500 then Tv[134]:=500;
    }
    Tv[134]:=MinR(750,Tv[129] * 75/100);

    Tv[135]:=MaxR(0,Tv[128]-Tv[134]);
    Tv[152]:=MinR(1000,Tv[151] * 20/100);
    Tv[153]:=MaxR(0,Tv[135]-Tv[152]);
    If Tv[154]>1000 then Tv[154]:=1000;
    If Tv[84]>1000 then Tv[84]:=1000;
    If Tv[84]>0 then Tv[154]:=0;
    If Tv[84]>0 then Tv[159]:=Tv[84] else Tv[159]:=Tv[154];
    Tv[85]:=Tv[159];
    Tv[155]:=MaxR(0,Tv[153]-Tv[85]);
    Tv[156]:=Vl(FetchElm(RetNo,'T1285',6));
    Tv[123] := MaxR(0,Tv[155] - Tv[156]);
    Ln[428] := Tv[123];
    Tv[83]:=MinR(250,Tv[83]);
    Ln[479]:= Tv[83];

    i:=89;
    k:=0;
    Repeat
     If Vl(Frm[Fno].Strings[i])>12 then Frm[FNo].Strings[i]:='12';
     {
     If AppYear='2007' then
     begin
      If Vl(Strings[i])>6 then Strings[i]:='6';
     end;
     }
     If (Ret[RetNo].Ln[236] > Vl(FetchElm(RetNo,'INFO',19)))
     and (Ret[RetNo].MarStatus <3)  then Frm[FNo].Strings[i]:='0';
     k:=k+MyStrToInt(Frm[FNo].Strings[i]);
     Inc(i,4);
    until i>97;
    If Vl(Frm[Fno].Strings[157])>12 then Frm[FNo].Strings[157]:='12';
    k:=k+MyStrToInt(Frm[FNo].Strings[157]);
    Frm[FNo].Strings[158]:=IntToStr(k);
 end;
 SaveTv(RetNo,FName,FNo);
End;

Procedure NU428(RetNo:integer;FName:string;FNo:integer);
var i,j,count: integer;x,y,z:real;
Begin
 InitPrvConstants('NU');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NU') = false  then
 begin
  For i:=1 to 187 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo].Frm[FNo] do
 begin
  // Tv[1] := Ret[RetNo].Ln[260];
   Tv[1]:=Vl(FetchElm(RetNo,'CASHFLOW',112)); //TaxRec.TaxableIncome;   /20200314 Tv[1]:=TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Strings[i]:='';end;
   Strings[11] := PrvConstant[RY].PrvRate1;
   Strings[12] := PrvConstant[RY].PrvRate2;
   Strings[13] := PrvConstant[RY].PrvRate3;
   Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * Ret[retNo].PartYear;
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * Ret[RetNo].PartYear;
//   Tv[26] := SpouseIncome(RetNo);
//   Tv[27] := CalcPrvSpousalClaim(RetNo,SpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Strings[64])='Y' then Tv[28]:=Tv[65];
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Strings[75]:=FetchElm(RetNo,'NU428',105);
//   If Not IsLowerIncomeSpouse(RetNo) then Strings[75]:='';
   Tv[73]:=Vl(Strings[75]) * 1200;
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
//   Tv[34] := GetPrvPnsDed(RetNo);//Vl(FetchElm(RetNo,'PNSDED',18));//Ret[RetNo].Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+Tv[73]+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ret[RetNo].Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ret[RetNo].Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];

   //SECOND PAGE ---------------------------------------------------------------
    Tv[101] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[67]));
//    MaxR(
//      MaxR(Vl(FetchElm(RetNo,'NU428',20)),Vl(FetchElm(RetNo,'NU428',21))),
//      MaxR(Vl(FetchElm(RetNo,'NU428',22)),Vl(FetchElm(RetNo,'NU428',67))));

    If SplitIncome(RetNo) then
     Tv[102] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[102] :=0;
    Tv[103] := Tv[101]+Tv[102];

    Tv[104] :=Tv[61];   //Vl(FetchElm(RetNo,'NU428',61));

    //Tv[6] := PrvConstant[RY].PrvDivRate;
    Tv[109] := PrvConstant[RY].PrvOverseasRate;
    Tv[112] := PrvConstant[RY].PrvAMTCarryOverRate;

    //Tv[5] := Ret[RetNo].Ln[120];
    Tv[108] := Ret[RetNo].Ln[426];
    Tv[111] := Ret[RetNo].Ln[427];
    Tv[107] := Vl(FetchElm(RetNo,'DTC',9)); //Tv[5] * Tv[6]/100;
    Tv[110] := Tv[108] * Tv[109]/100;
    Tv[113] := Tv[111] * Tv[112]/100;
    Tv[114] := Tv[104]+Tv[107]+Tv[110]+Tv[113];
    Tv[115] := Tv[114];
    Tv[116] := MaxR(0,Tv[103] - Tv[115]);

    Tv[121]:=Vl(FetchElm(RetNo,'T691_4',16));
    If IsDeceased(RetNo) then Tv[121]:=0;
    Tv[122]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[117]:=Tv[121] * Tv[122]/100;

    Tv[118] := Tv[116]+Tv[117];

    If Ret[RetNo].Province <> 'NU' then
     Tv[119] :=0
    else
     Tv[119] := GetPrvForTaxCredit(RetNo,'NU');
    Tv[120] := MaxR(0,Tv[118]-Tv[119]);
    Ret[RetNo].Ln[428] := Tv[120];
    j:=0;
    i:=156;
    repeat
     If Strings[i]>'' then Inc(j,1);
     Inc(i,4);
    until i>184;
    Strings[105]:=AllTrim(IntToStr(j));
 end;
 SaveTv(RetNo,FName,FNo);
end;


Function CalcMedical(Medical,NI:Real):real;
Var Limit :Real;
begin
  Limit :=MaxR(0,MinR(NI * 0.03, Constant[RY].MedicalLimit));
  Result := MaxR(0,Medical-MinR(Medical,Limit));
end;

(*
Function ClientAgeIn2001(RetNo:Integer): Integer;
Var BirthDate:string;
begin
 Birthdate := ClientBirthDate(RetNo);
 result := CalcAgeIn2001(BirthDate);
end;

Function SpouseAgeIn2001(RetNo:Integer): Integer;
Var BirthDate:string;
begin
 Birthdate := SpouseBirthDate(RetNo);
 result := CalcAgeIn2001(BirthDate);
end;
*)

(*
Function CalcAgeIn2001(BirthDate: string): Integer;
Var ToDate :String;
{birthdate in form dd-mm-yyyy}
Begin
 ToDate := '31-12-2001';
 If (Length(BirthDate) <> 10) or (Length(ToDate) <> 10)
  then begin Result :=0;exit;end;
 Result := MyStrToInt(RightStr(ToDate,4)) - StrToInt(RightStr(BirthDate,4));
end;
*)
Function CalcAgeEx(Age: integer;NI:real):real;
var x,y,z:real;
begin
If (Age <65) or (NI > Constant[RY].AgeNIThreshhold) then
  begin result :=0;exit;end;
x:= MaxR(0,NI - Constant[RY].AgeBaseAmount);
y := x * 0.15;
Result := MaxR(0,Constant[RY].MaxAgeAmount - y);
end;


Function GetPrvIndex(SPrv: string): Integer;
Var i : integer;
Begin
  Result := 5;  {Ontario}
  For i := 1 to High(PrvShort) do
   begin
    If UpperCase(SPrv) = PrvShort[i] then
    begin Result := i;exit;end;
   end;
End;


Function CalcSpousalClaim(SpNi,PartYear:Real):Real;
begin
   Result :=MinR(Constant[RY].MaxSpousalAmount,
       MaxR(0,Constant[RY].SpousalBase* PartYear - SpNi));
   If Result > Constant[RY].MaxSpousalAmount
      Then Result :=Constant[RY].MaxSpousalAmount;
end;

Function CalcPrvSpousalClaim(SpNi,PartYear:Real):Real;
begin
   Result :=MinR(PrvConstant[RY].PrvMaxSpousalAmount,
       MaxR(0,PrvConstant[RY].PrvSpouseBasicAmount * PartYear - SpNi));
   If Result > PrvConstant[RY].PrvMaxSpousalAmount
      Then Result :=PrvConstant[RY].PrvMaxSpousalAmount;
end;


Function CalcFedSurtax(BasFedTax,FAvrgCr:Real):Real;
Var x,y:Real;
begin
 x:=  MaxR(0,BasFedTax-FAvrgCr);
 y := MaxR(0,x - 12500);
 result :=x * 0.03+ y* 0.05;
 {need also Additl fforcr and addtl itc}
end;

Function CalcCLAWBack(NI,EIBenefits,OAS:Real):real;
Var  i: integer;EIClaw,OASClaw,x,y:Real;
 EiRepaid, OASRepaid, NetFedSuppl,OASAndSuppl :real;
begin
  Result:=0;
  Exit;
    EiRepaid:=0; OASRepaid:=0; NetFedSuppl:=0;OASAndSuppl:=0;
    {UI}
    x := MaxR(0,EIBenefits-EIRepaid);
    y := MaxR(0,NI - Constant[RY].UIBaseRep);
    EiClaw := 0.30 * MinR(x,y);
    {OAS}
    OASAndSuppl := MaxR(0,OAS+NetFedSuppl - OASRepaid);
    OASClaw := MinR(
               OASAndSuppl,
               MaxR(0,MaxR(0,NI-EIClaw)-Constant[RY].OASBaseRep) * 0.15
               );
    {total}
    Result := EiClaw + OASClaw;
 end;

Procedure InitTaxPlHeader(RetNo,FNo:Integer);
Var i:integer;
begin
  with Ret[RetNo].Frm[Fno] do
   begin
    Strings[2] := FetchElm(RetNo,'PROFILE',1);  {First}
    Strings[3] := FetchElm(RetNo,'PROFILE',2);   {last}
    Strings[4] := FetchElm(RetNo,'PROFILE',3);   {SIN}
    Strings[5] := FetchElm(RetNo,'PROFILE',5)+','  {Address}
                 +FetchElm(RetNo,'PROFILE',6)+','
                 +FetchElm(RetNo,'PROFILE',8)+','
                 +FetchElm(RetNo,'PROFILE',12);
    Strings[6] := FetchElm(RetNo,'PROFILE',15);  {area}
    Strings[7] := FetchElm(RetNo,'PROFILE',16);  {phone}
    Strings[8] := FetchElm(RetNo,'PROFILE',27);  {birthdate}
    Strings[9] := FetchElm(RetNo,'PROFILE',99);  {tax province}
    {? Strings[10] := FetchElm(RetNo,'PROFILE',27)};  {resident}
    {? Tv[12] :=                                      {sp net Inc}
    Strings[11] := DateToMonthDayYear(Date);   {date}
    Strings[13] := GetMarStatusDescr(CalcMarStatus(RetNo));

    If Strings[8] = '' then Strings[8] := '01-01-1945';
    If Strings[9] = '' then Strings[9] := 'ON';
    If Strings[10] = '' then Strings[10] := IntToStr(Constant[RY].FullYear);
  end;
end;

Function CalcEmplCPP(RetNo:Integer;EmplInc:Real;BirthDate:string):Real;
Var Age,CppMonths:Integer; Pensionable,CppProrate : Real;
begin
 Age := CalcAge(BirthDate);
 CppMonths :=GetCppMonths(RetNo,BirthDate);
 CppProrate := CppMonths /12;
 {birthdate as dd-mm-yyyy}
 With Constant[RY] do
 begin
  Pensionable := MinR(MaxCppEarnings,EmplInc - BasicCPPExemption*CppProrate);
  Pensionable := MaxR(0,Pensionable);
  result := MinR(MaxCpp,Pensionable * CPPRate);
  If Result > MaxCPP then result := MaxCPP;
 end;
end;

Function CalcSelfCPP(RetNo:Integer;EmplInc,SelfEmplInc,EmplCPP:Real;BirthDate:string):Real;
Var TotPensionable,RequiredCpp:real;
Age,CppMonths:Integer; CppProrate : Real;
begin
 If SelfEmplInc<=0 then begin result :=0;exit;end;
 CppMonths :=GetCppMonths(RetNo,BirthDate);
 CppProrate := CppMonths /12;
 With Constant[RY] do
 begin
  TotPensionable := MinR(EmplInc+SelfEmplInc,MaxCppPensionable*CppProrate);
  RequiredCpp := MaxR(0,TotPensionable - BasicCPPExemption*CppProrate)* CppRate * 2;
  Result := MaxR(0,RequiredCpp - EmplCpp*2);
 end;
end;

Function CalcEI(RetNo:Integer;EmplInc:Real):Real;
begin
 With Constant[RY] do
 begin
  EmplInc := MinR(EmplInc,MaxUIEarn52);
  result  := EmplInc * UIRate;
  If Result > MaxUI52 then result := MaxUI52;
 end;
end;


Function CalcMarStatus(RetNo:Integer): Integer;
Var i : integer;
Begin
 Result := 6; {single}
 If FetchElm(RetNo,'Profile',9) > '' then  result := 1;
 If FetchElm(RetNo,'Profile',79) > '' then  result := 2;
 If FetchElm(RetNo,'Profile',10) > '' then  result := 3;
 If FetchElm(RetNo,'Profile',11) > '' then  result := 4;
 If FetchElm(RetNo,'Profile',13) > '' then  result := 5;
 If FetchElm(RetNo,'Profile',14) > '' then  result := 6;
end;

Function GetMarStatusDescr(I:Integer):string;
begin
  result :='(Uknown)';
  If i =1 then result := 'Married';
  If i =2 then result := 'Common-law';
  If i =3 then result := 'Widow(er)';
  If i =4 then result := 'Divorced';
  If i =5 then result := 'Separated';
  If i =6 then result := 'Single';
end;

Function CalcPensDed(RetNo:Integer; PensInc:Real):Real;
begin
 result := MinR(1000,PensInc);
end;


Function CalcPRVSurTax(RetNo:Integer; Prv:String;Txbl,PrvTax,FamIncome:real):Real;
Var FlatTax,Surtax1,Surtax2:real;
begin
 FlatTax := 0; Surtax1:=0; Surtax2 :=0;
 If Prv = 'AL' then  FlatTax := Txbl * 0.5/100;
 If Prv = 'BC' then
 begin
  Surtax1 := MaxR(0, PrvTax - 5300) * 0.30;
  Surtax2 := MaxR(0, PrvTax - 8745) * 0.245;
 end;
 If Prv = 'NB' then  Surtax1 := MaxR(0, PrvTax - 13500) * 0.08;
 If Prv = 'NS' then  Surtax1 := MaxR(0, PrvTax - 10000) * 0.10;
 If Prv = 'NF' then  Surtax1 := MaxR(0, PrvTax - 7900) * 0.10;
 If Prv = 'ON' then
 begin
  Surtax1 := MaxR(0, PrvTax - 4555) * 0.20;
  Surtax2 := MaxR(0, PrvTax - 6180) * 0.26;
 end;
 If Prv = 'PE' then  Surtax1 := MaxR(0, PrvTax - 5200) * 0.10;
 If Prv = 'SK' then
 begin
  FlatTax := FamIncome * 0.02;
  Surtax1 := MaxR(0,MaxR(0, PrvTax+FlatTax) * 0.10 - 150);
  Surtax2 := MaxR(0, PrvTax+FlatTax - 4000) * 0.15;
 end;
 If Prv = 'YK' then  Surtax1 := MaxR(0, PrvTax - 6000) * 0.05;
 Result := FlatTax+Surtax1+SurTax2;
end;


Procedure TAXPL_1(RetNo: integer; FName: String;FNo: integer);
{Procedure CommonPl1(RetNo: integer; FName: String;FNo: integer;Typ:String);}
Var I,k:integer; x,y,z:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    InitTaxPlHeader(RetNo, FNo);
    {copy column 1 to 2 and 3}

    {tot income}
     i :=27; Tv[69]:=0;Tv[70] :=0;Tv[71]:=0;
     repeat
      Tv[69] := Tv[69]+Tv[i];
      Tv[70] := Tv[70]+Tv[i+1];
      Tv[71] := Tv[71]+Tv[i+2];
      inc(i,3);
     until i > 66; {end repeat}

     {net income}
     i :=72; Tv[147]:=Tv[69];Tv[148] := Tv[70];Tv[149] := Tv[71];
     repeat
      Tv[147] := Tv[147]-Tv[i];
      Tv[148] := Tv[148]-Tv[i+1];
      Tv[149] := Tv[149]-Tv[i+2];
      inc(i,3);
     until i > 108; {end repeat}

     {repay}
     Tv[111] :=CalcClawBack(Tv[147],Tv[51],Tv[30]);
     Tv[112] :=CalcClawBack(Tv[148],Tv[52],Tv[31]);
     Tv[113] :=CalcClawBack(Tv[149],Tv[53],Tv[32]);

     {net inc}
     Tv[114] := MaxR(0,Tv[147] - TV[111]);
     Tv[115] := MaxR(0,Tv[148] - TV[112]);
     Tv[116] := MaxR(0,Tv[149] - TV[113]);

     {taxbl income}
     Tv[144] := Tv[114]; {+Tv[117];}
     Tv[145] := Tv[115]; {+Tv[118];}
     Tv[146] := Tv[116]; {+Tv[119];}
     i :=120;
     repeat
      Tv[144] := Tv[144]-Tv[i];
      Tv[145] := Tv[145]-Tv[i+1];
      Tv[146] := Tv[146]-Tv[i+2];
      inc(i,3);
     until i > 141; {end repeat}

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure TAXPL_2(RetNo: integer; FName: String;FNo: integer);
{Procedure CommonPl2(RetNo: integer; FName: String;FNo: integer;Typ:String);}
Var I,DaysInCan,Age:integer; BirthDate : string[10];
PartYear,SpNetIncome,x,y,z:Real;
NI1,NI2,NI3,Txbl1,Txbl2,Txbl3:real;
PrvNdx : integer;
MarStatus :Integer;
SPrv : string[2];
Begin
   LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    {copy column 1 to 2 and 3}

    For i := 1 to 20 do Strings[i] := FetchElm(RetNo,'TaxPL_1',i);
    Tv[12] := Vl(FetchElm(RetNo,'TAXPL_1',12));

    MarStatus := CalcMarStatus(RetNo);
    BirthDate :=FetchElm(RetNo,'TAXPL_1',8);
    SPrv := FetchElm(RetNo,'TAXPL_1',9);
    PrvNdx := GetPrvIndex(SPrv);
    SpNetIncome := Vl(FetchElm(RetNo,'TAXPl_1',12));
    DaysInCan := MyStrToInt(FetchElm(RetNo,'TAXPL_1',10));
    PartYear := DaysInCan / Constant[RY].FullYear;
    Age := CalcAge(FetchElm(RetNo,'TAXPL_1',8));

    NI1 := Vl(FetchElm(RetNo,'TAXPL_1',114));
    NI2 := Vl(FetchElm(RetNo,'TAXPL_1',115));
    NI3 := Vl(FetchElm(RetNo,'TAXPL_1',116));
    Txbl1 := Vl(FetchElm(RetNo,'TAXPL_1',144));
    Txbl2 := Vl(FetchElm(RetNo,'TAXPL_1',145));
    Txbl3 := Vl(FetchElm(RetNo,'TAXPL_1',146));

    {pers amount}
    Tv[27] := Constant[RY].BasicPersonalAmount * PartYear;
    Tv[28] := Tv[27];
    Tv[29] := Tv[27];

    {Age amount}
    Tv[30] := CalcAgeEx(Age,NI1 * PartYear);
    Tv[31] := CalcAgeEx(Age,NI2 * PartYear);
    Tv[32] := CalcAgeEx(Age,NI3 * PartYear);

    {Sp amount}
    If MarStatus <3 then
    begin
     Tv[33] := CalcSpousalClaim(SpNetIncome,PartYear);
     Tv[34] := Tv[33];Tv[35] := Tv[33];
    end
    else
    begin
      Tv[33] :=0;
      Tv[34] := 0;Tv[35] := 0;
    end;
    {cpp}
    Tv[42] := CalcEmplCpp(RetNo,Vl(FetchElm(RetNo,'TaxPL_1',27)),BirthDate);
    Tv[43] := CalcEmplCpp(RetNo,Vl(FetchElm(RetNo,'TaxPL_1',28)),BirthDate);
    Tv[44] := CalcEmplCpp(RetNo,Vl(FetchElm(RetNo,'TaxPL_1',29)),BirthDate);

        {self cpp}
    Tv[48] := CalcSelfCpp(RetNo,
              Vl(FetchElm(RetNo,'TAXPL_1',27)),  {empl inc}
              Vl(FetchElm(RetNo,'TAXPL_1',48))+   {self empl inc}
              Vl(FetchElm(RetNo,'TAXPL_1',54)),
              Vl(FetchElm(RetNo,'TAXPL_2',42)),
              BirthDate);   {Empl CPP}
    Tv[49] := CalcSelfCpp(RetNo,
              Vl(FetchElm(RetNo,'TAXPL_1',28)),  {empl inc}
              Vl(FetchElm(RetNo,'TAXPL_1',49))+   {self empl inc}
              Vl(FetchElm(RetNo,'TAXPL_1',55)),
              Vl(FetchElm(RetNo,'TAXPL_2',43)),
              BirthDate);   {Empl CPP}
    Tv[50] := CalcSelfCpp(RetNo,
              Vl(FetchElm(RetNo,'TAXPL_1',29)),  {empl inc}
              Vl(FetchElm(RetNo,'TAXPL_1',50))+   {self empl inc}
              Vl(FetchElm(RetNo,'TAXPL_1',56)),
              Vl(FetchElm(RetNo,'TAXPL_2',44)),
              BirthDate);   {Empl CPP}
    {UI}
    Tv[51] := CalcEI(RetNo,Vl(FetchElm(RetNo,'TaxPL_1',27)));
    Tv[52] := CalcEI(RetNo,Vl(FetchElm(RetNo,'TaxPL_1',28)));
    Tv[53] := CalcEI(RetNo,Vl(FetchElm(RetNo,'TaxPL_1',29)));

    {Pens Inc ded}
    Tv[54] := CalcPensDed(RetNo,Vl(FetchElm(RetNo,'TAXPL_1',36)));
    Tv[55] := CalcPensDed(RetNo,Vl(FetchElm(RetNo,'TAXPL_1',37)));
    Tv[56] := CalcPensDed(RetNo,Vl(FetchElm(RetNo,'TAXPL_1',38)));

    {med credit}
    Tv[75] := CalcMedical(Tv[72],NI1);
    Tv[76] := CalcMedical(Tv[73],NI2);
    Tv[77] := CalcMedical(Tv[74],NI3);

    {non-ref credits}
    i :=27; x:=0;y:=0;z:=0;
     repeat
      x := x+Tv[i];
      y := y+Tv[i+1];
      z := z+Tv[i+2];
      inc(i,3);
     until i > 69; {end repeat}
     x:= x+Tv[75]+Tv[162];
     y:=y+Tv[76]+Tv[163];
     z:=z+Tv[77]+Tv[164];
    Tv[78] := x * 0.17;
    Tv[79] := y * 0.17;
    Tv[80] := z * 0.17;

    {tot non-ref}
    Tv[87] := Tv[78]+Tv[84];
    Tv[88] := Tv[79]+Tv[85];
    Tv[89] := Tv[80]+Tv[86];

    {Fed tax}
    Tv[90] := CalcFedTax(Txbl1);
    Tv[91] := CalcFedTax(Txbl2);
    Tv[92] := CalcFedTax(Txbl3);
    {less}
    {Non ref}
    Tv[93] := Tv[87];
    Tv[94] := Tv[88];
    Tv[95] := Tv[89];
    {Div cr}
    Tv[96] := 0.1333 * Vl(FetchElm(RetNo,'TaxPl_1',39));
    Tv[97] := 0.1333 * Vl(FetchElm(RetNo,'TaxPl_1',40));
    Tv[98] := 0.1333 * Vl(FetchElm(RetNo,'TaxPl_1',41));
    {bas fed tax}
    Tv[105] := MaxR(0,Tv[90] - Tv[93]-Tv[96]-Tv[99]-Tv[102]);
    Tv[106] := MaxR(0,Tv[91] - Tv[94]-Tv[97]-Tv[100]-Tv[103]);
    Tv[107] := MaxR(0,Tv[92] - Tv[95]-Tv[98]-Tv[101]-Tv[104]);

    Tv[108] := Vl(FetchElm(RetNo,'TAXPL_3',105));
    Tv[109] := Vl(FetchElm(RetNo,'TAXPL_3',106));
    Tv[110] := Vl(FetchElm(RetNo,'TAXPL_3',107));

    {comp min and bas fed tax}
    Tv[111] := MaxR(Tv[105],Tv[108]);
    Tv[112] := MaxR(Tv[106],Tv[109]);
    Tv[113] := MaxR(Tv[107],Tv[110]);

    {Surtax}
    Tv[126] := CalcFedSurtax(Tv[111],0);  {0=favrgcr}
    Tv[127] := CalcFedSurtax(Tv[112],0);  {0=favrgcr}
    Tv[128] := CalcFedSurtax(Tv[113],0);  {0=favrgcr}
    {net fed tax}
    Tv[129] := MaxR(0,Tv[111] - Tv[114] - Tv[117] - Tv[120] - Tv[123])+Tv[126];
    Tv[130] := MaxR(0,Tv[112] - Tv[115] - Tv[118] - Tv[121] - Tv[124])+Tv[127];
    Tv[131] := MaxR(0,Tv[113] - Tv[116] - Tv[119] - Tv[122] - Tv[125])+Tv[128];
    {prv surtax/flat tax}
     {CalcPrvSurtax(RetNo,Prv,Txbl,PrvTax,FamIncome);}
    Tv[132] :=CalcPrvSurtax(RetNo,SPrv,Txbl1,Tv[144],NI1+SpNetIncome);
    Tv[133] :=CalcPrvSurtax(RetNo,SPrv,Txbl2,Tv[145],NI2+SpNetIncome);
    Tv[134] :=CalcPrvSurtax(RetNo,SPrv,Txbl3,Tv[146],NI3+SpNetIncome);
    {prvrate}
    Tv[141] := PrvRate[PrvNdx] * 100;
    Tv[142] := Tv[141];
    Tv[143] := Tv[141];
    {prvtax}
    Tv[144] := Tv[111] * Tv[141] /100;
    Tv[145] := Tv[112] * Tv[142] /100;
    Tv[146] := Tv[113] * Tv[143] /100;

    {tot prv tax}
    Tv[165] := MaxR(0,Tv[144]+Tv[132]-Tv[150]);
    Tv[166] := MaxR(0,Tv[145]+Tv[133]-Tv[151]);
    Tv[167] := MaxR(0,Tv[146]+Tv[134]-Tv[152]);
    {payable befr credits}
    Tv[147] := Tv[129]+Tv[165];
    Tv[148] := Tv[130]+Tv[166];
    Tv[149] := Tv[131]+Tv[167];
    {Soc benef Repayment}
    Tv[135] := Vl(FetchElm(RetNo,'TAXPL_1',111));
    Tv[136] := Vl(FetchElm(RetNo,'TAXPL_1',112));
    Tv[137] := Vl(FetchElm(RetNo,'TAXPL_1',113));
    {CPP}
    Tv[138] := Tv[42]+Tv[45]+Tv[48];
    Tv[139] := Tv[43]+Tv[46]+Tv[49];
    Tv[140] := Tv[44]+Tv[47]+Tv[50];
    {EI}
    Tv[168] := Tv[51];
    Tv[169] := Tv[52];
    Tv[170] := Tv[53];
    {Tot tax payable}
    Tv[159] := Tv[147]+Tv[135]+Tv[138]+Tv[168]-Tv[153]-Tv[156];
    Tv[160] := Tv[148]+Tv[136]+Tv[139]+Tv[169]-Tv[154]-Tv[157];
    Tv[161] := Tv[149]+Tv[137]+Tv[140]+Tv[170]-Tv[155]-Tv[158];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure TAXPL_3(RetNo: integer; FName: String;FNo: integer);
{Procedure CommonPl3(RetNo: integer; FName: String;FNo: integer;Typ:String);}
Var I:integer;
begin
   LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    {copy column 1 to 2 and 3}
     For i := 1 to 20 do Strings[i] := FetchElm(RetNo,'TaxPL_1',i);
     Tv[12] := Vl(FetchElm(RetNo,'TAXPL_1',12));
     {ref txbl}
     Tv[27] := Vl(FetchElm(RetNo,'TaxPL_1',144));
     Tv[28] := Vl(FetchElm(RetNo,'TaxPL_1',145));
     Tv[29] := Vl(FetchElm(RetNo,'TaxPL_1',146));
     {oil/gas}
     Tv[30] := Vl(FetchElm(RetNo,'TAXPL_1',102));
     Tv[31] := Vl(FetchElm(RetNo,'TAXPL_1',103));
     Tv[32] := Vl(FetchElm(RetNo,'TAXPL_1',104));

     {Cap gains}
     Tv[33] := (1/4)* Vl(FetchElm(RetNo,'TaxPL_1',45))* 4/3;
     Tv[34] := (1/4) * Vl(FetchElm(RetNo,'TaxPL_1',46))* 4/3;
     Tv[35] := (1/4) * Vl(FetchElm(RetNo,'TaxPL_1',47))* 4/3;
     (*
     {rpp}
     Tv[36] := Vl(FetchElm(RetNo,'TaxPL_1',72));
     Tv[37] := Vl(FetchElm(RetNo,'TaxPL_1',73));
     Tv[38] := Vl(FetchElm(RetNo,'TaxPL_1',74));
     {rrsp}
     Tv[39] := Vl(FetchElm(RetNo,'TaxPL_1',75));
     Tv[40] := Vl(FetchElm(RetNo,'TaxPL_1',76));
     Tv[41] := Vl(FetchElm(RetNo,'TaxPL_1',77));
     *)
     {Empl home rel}
     Tv[45] := Vl(FetchElm(RetNo,'TaxPL_1',120));
     Tv[46] := Vl(FetchElm(RetNo,'TaxPL_1',121));
     Tv[47] := Vl(FetchElm(RetNo,'TaxPL_1',122));
     {Stock Opt}
     Tv[48] := Vl(FetchElm(RetNo,'TaxPL_1',123));
     Tv[49] := Vl(FetchElm(RetNo,'TaxPL_1',124));
     Tv[50] := Vl(FetchElm(RetNo,'TaxPL_1',125));
     {tot add}
     i :=30; Tv[51]:=0;Tv[52] :=0;Tv[53]:=0;
     repeat
      Tv[51] := Tv[51]+Tv[i];
      Tv[52] := Tv[52]+Tv[i+1];
      Tv[53] := Tv[53]+Tv[i+2];
      inc(i,3);
     until i > 48; {end repeat}
     {txbl plus additions}
     Tv[54] := Tv[27] + Tv[51];
     Tv[55] := Tv[28] + Tv[52];
     Tv[56] := Tv[29] + Tv[53];
     {gross up div}
     Tv[57] := 0.20 * Vl(FetchElm(RetNo,'TaxPL_1',39));
     Tv[58] := 0.20 * Vl(FetchElm(RetNo,'TaxPL_1',40));
     Tv[59] := 0.20 * Vl(FetchElm(RetNo,'TaxPL_1',41));

     {ABIL}
     Tv[63] := Vl(FetchElm(RetNo,'TaxPL_1',90)) / 3;
     Tv[64] := Vl(FetchElm(RetNo,'TaxPL_1',91)) / 3;
     Tv[65] := Vl(FetchElm(RetNo,'TaxPL_1',92)) / 3;
     {min tax exempt}
     Tv[66] := 40000; Tv[67]:=Tv[66];Tv[68] := Tv[66];
    {tot subtractions}
     i :=57; Tv[69]:=0;Tv[70] :=0;Tv[71]:=0;
     repeat
      Tv[69] := Tv[69]+Tv[i];
      Tv[70] := Tv[70]+Tv[i+1];
      Tv[71] := Tv[71]+Tv[i+2];
      inc(i,3);
     until i > 66; {end repeat}
    {min tax txbl inc}
    Tv[72] := MaxR(0,Tv[54] - Tv[69]);
    Tv[73] := MaxR(0,Tv[55] - Tv[70]);
    Tv[74] := MaxR(0,Tv[56] - Tv[71]);

    Tv[75] := Tv[72] * 0.17;
    Tv[76] := Tv[73] * 0.17;
    Tv[77] := Tv[74] * 0.17;
    {non ref}
    Tv[78] := Vl(FetchElm(RetNo,'TaxPL_2',87));
    Tv[79] := Vl(FetchElm(RetNo,'TaxPL_2',88));
    Tv[80] := Vl(FetchElm(RetNo,'TaxPL_2',89));
    {Pens}
    Tv[81] := Vl(FetchElm(RetNo,'TAXPL_2',54));
    Tv[82] := Vl(FetchElm(RetNo,'TAXPL_2',55));
    Tv[83] := Vl(FetchElm(RetNo,'TAXPL_2',56));
    {xfer from dep}
    Tv[84] := Vl(FetchElm(RetNo,'TAXPL_2',60))
             +Vl(FetchElm(RetNo,'TAXPL_2',66));
    Tv[85] := Vl(FetchElm(RetNo,'TAXPL_2',61))
             +Vl(FetchElm(RetNo,'TAXPL_2',67));
    Tv[86] := Vl(FetchElm(RetNo,'TAXPL_2',62))
             +Vl(FetchElm(RetNo,'TAXPL_2',68));
    {xfer from spouse}
    Tv[87] := Vl(FetchElm(RetNo,'TAXPL_2',69));
    Tv[88] := Vl(FetchElm(RetNo,'TAXPL_2',70));
    Tv[89] := Vl(FetchElm(RetNo,'TAXPL_2',71));
   {tot non ded}
     i :=81; Tv[90]:=0;Tv[91] :=0;Tv[92]:=0;
     repeat
      Tv[90] := Tv[90]+Tv[i];
      Tv[91] := Tv[91]+Tv[i+1];
      Tv[92] := Tv[92]+Tv[i+2];
      inc(i,3);
     until i > 87; {end repeat}

    Tv[93] := Tv[90] * 0.17;
    Tv[94] := Tv[91] * 0.17;
    Tv[95] := Tv[92] * 0.17;

    Tv[96] := MaxR(0,Tv[78] - Tv[93]);
    Tv[97] := MaxR(0,Tv[79] - Tv[94]);
    Tv[98] := MaxR(0,Tv[80] - Tv[95]);

    Tv[99] := MaxR(0,Tv[75] - Tv[96]);
    Tv[100] := MaxR(0,Tv[76] - Tv[97]);
    Tv[101] := MaxR(0,Tv[77] - Tv[98]);

    Tv[105] := MaxR(0,Tv[99] - Tv[102]);
    Tv[106] := MaxR(0,Tv[100] - Tv[103]);
    Tv[107] := MaxR(0,Tv[101] - Tv[104]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Function GetCPPMonths(RetNo:integer;BirthDate:string):Integer;
Var i,FNo,Age : integer;  {birthdata as dd-mm-yyyy}
begin
 With Ret[RetNo] do
 begin
  Age := CalcAge(BirthDate);
  Result := 12;
  If (Age <18) or (Age > 70) then Result := 0
  Else If Age =18 then
   Result := 12- MyStrToInt(MidStr(BirthDate,4,2))
  Else If Age =70 then Result := MyStrToInt(MidStr(BirthDate,4,2));
  If Result<0 then result :=0;
 end; {end with ret[Retno]}
end;

Procedure TAXP_1(RetNo: integer; FName: String;FNo: integer);
{Procedure CommonPl1(RetNo: integer; FName: String;FNo: integer;Typ:String);}
Var I,k:integer; x,y,z:real;
     //DelayCnt:integer;
     TempList2:TStringList;
     //tempstring : Array[0..80] of Char;
     MarStatCode:String[1];
     MarStatDescr:String;
     FrmNm,Valu:String;
     Elm:Integer;

begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
    Strings[1]:=GetT1Year;//'2002';
    Strings[2]:=FetchElm(RetNo,'PROFILE',2)+' '+FetchElm(RetNo,'PROFILE',5); //first/last
    Strings[3]:=FetchElm(RetNo,'PROFILE',3);  //sin
    Strings[4]:=FetchElm(RetNo,'PROFILE',27);  //birthdate
    Strings[5]:=FetchElm(RetNo,'PROFILE',99);  //Tax province
    MarStatCode:='6';
    MarStatDescr:='Single';
    If FetchElm(RetNo,'PROFILE',9)>'' then begin MarStatCode:='1';MarStatDescr:='Married';end;
    If FetchElm(RetNo,'PROFILE',79)>'' then begin MarStatCode:='2';MarStatDescr:='Living-Common-Law';end;
    If FetchElm(RetNo,'PROFILE',10)>'' then begin MarStatCode:='3';MarStatDescr:='Widow(er)';end;
    If FetchElm(RetNo,'PROFILE',11)>'' then begin MarStatCode:='4';MarStatDescr:='Divorced)';end;
    If FetchElm(RetNo,'PROFILE',13)>'' then begin MarStatCode:='5';MarStatDescr:='Separated';end;
    If FetchElm(RetNo,'PROFILE',14)>'' then begin MarStatCode:='6';MarStatDescr:='Single';end;
    Strings[6]:=MarStatDescr;  //Tax province

    //mandatory
    If (Strings[1] = '')
    or (Strings[3] = '')
    or (Strings[4] = '')
    or (Strings[5] = '')
    or (Strings[6] = '') then
    begin
       SaveTv(RetNo,FName,FNo);
       Exit;
    end;
   Tv[25]:=Tv[24]*50/100;
   Tv[27]:=Tv[26]*50/100;
   Tv[28]:=Tv[18]*50/100;

   Tv[39]:=0;
   Tv[39]:=Tv[14]+Tv[16]+Tv[17]+Tv[20]
           +Tv[21]+Tv[23]+Tv[25]+Tv[27]+Tv[28]+Tv[15]
           +Tv[30]+Tv[31]+Tv[29]+Tv[32]+Tv[33]+Tv[34]+Tv[35]+Tv[36]+Tv[113]
           +Tv[38];
   If Strings[118]='' then Strings[118]:='30';
   //get from T1
   SaveTv(RetNo,FName,FNo);

   Tv[71]:=AddColumns(63,65,1)+Tv[127]++AddColumns(67,70,1)+Tv[22];

   Tv[94]:=0;
   Tv[94]:=AddColumns(73,81,1)+Tv[100]+Tv[82]+Tv[83]+Tv[85]+Tv[89]+Tv[90]+Tv[91]+tv[93];
   Tv[95]:=Tv[94] * 16/100;

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure TAXP_2(RetNo: integer; FName: String;FNo: integer);
Begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Strings[1]:=GetT1Year;//'2002';
   //Strings[1]:=FetchElm(RetNo,'TAXP_1',1);
   Tv[63]:=Tv[62];
   Tv[67]:=Tv[63]+Tv[64]+Tv[66];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



Function CalcTaxForCashFlow(RetNo:Integer):Real;  //spouseId 1 or 2
Var FromFNo:Integer;TxblInc:Real;DividendCredit:Real;
  FedTaxC,FedTaxS,PrvTaxC,PrvTaxS:Real;
  PrvC,PrvS:String;OHIP:Real;
begin
   TxblInc:=TaxRec.TaxableIncome; //20200314
   S1(RetNo,'S1',GetFormNo('S1'));
   FedTaxC:=Vl(FetchElm(RetNo,'S1',128));
  // TxblInc:=TaxRec.TaxableIncome; //20200314  see above //20200316
   //Provincial
   PrvC:=TaxRec.Province;
   If PrvC ='ON' then
   begin
     On428(RetNo,'ON428',GetFormNo('ON428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'ON428',122));
   end;

   If PrvC ='AB' then  //done for FP2008
   begin
     StoreElm(RetNo,GetFormNo('AB428'),5,FormatFloat('##########.##',TxblInc));
     AB428(RetNo,'AB428',GetFormNo('AB428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'AB428',117));
   end;

   If PrvC ='BC' then
   begin
     StoreElm(RetNo,GetFormNo('BC428'),1,FormatFloat('##########.##',TxblInc));
     BC428(RetNo,'BC428',GetFormNo('BC428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'BC428',131));
   end;

   If PrvC ='MB' then
   begin
     StoreElm(RetNo,GetFormNo('MB428'),1,FormatFloat('##########.##',TxblInc));
     MB428(RetNo,'MB428',GetFormNo('MB428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'MB428',145));
   end;


  If PrvC ='NL' then
   begin
     StoreElm(RetNo,GetFormNo('NL428'),1,FormatFloat('##########.##',TxblInc));
     NL428(RetNo,'NL428',GetFormNo('NL428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'NL428',121));
   end;

   If PrvC ='NB' then
   begin
     StoreElm(RetNo,GetFormNo('NB428'),1,FormatFloat('##########.##',TxblInc));
     NB428(RetNo,'NB428',GetFormNo('NB428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'NB428',150));
   end;

   If PrvC ='NS' then
   begin
     StoreElm(RetNo,GetFormNo('NS428'),1,FormatFloat('##########.##',TxblInc));
     NS428(RetNo,'NS428',GetFormNo('NS428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'NS428',123));
   end;
   If PrvC ='NT' then
   begin
     StoreElm(RetNo,GetFormNo('NT428'),1,FormatFloat('##########.##',TxblInc));
     NT428(RetNo,'NT428',GetFormNo('NT428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'NT428',120));
   end;

   If PrvC ='NU' then
   begin
     StoreElm(RetNo,GetFormNo('NU428'),1,FormatFloat('##########.##',TxblInc));
     NU428(RetNo,'NU428',GetFormNo('NU428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'NU428',120));
   end;

   If PrvC ='SK' then
   begin
     StoreElm(RetNo,GetFormNo('SK428'),1,FormatFloat('##########.##',TxblInc));
     SK428(RetNo,'SK428',GetFormNo('SK428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'SK428',137));
   end;

   If PrvC ='YT' then
   begin
     StoreElm(RetNo,GetFormNo('YT428'),1,FormatFloat('##########.##',TxblInc));
     YT428(RetNo,'YT428',GetFormNo('YT428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'YT428',123));
   end;

   If PrvC ='PE' then
   begin
     StoreElm(RetNo,GetFormNo('PE428'),1,FormatFloat('##########.##',TxblInc));
     PE428(RetNo,'PE428',GetFormNo('PE428'));
     PrvTaxC:=Vl(FetchElm(RetNo,'PE428',112));
   end;
   Result:=FedTaxC+PrvTaxC;
end;


Function CalcFedTax(TxblInc:Real):real;
begin
 //ShowTimedMsg('Tax Calc',1000);
 If TxblInc <=  Constant[RY].Bracket1 then begin result:= TxblInc * vl(Constant[RY].Rate1)/100;exit;end;

 If (TxblInc >  Constant[RY].Bracket1) and (TxblInc <= Constant[RY].Bracket2) then
  begin result:= Constant[RY].BracketTax2+ (TxblInc-Constant[RY].Bracket1) * Vl(Constant[RY].Rate2)/100;exit;end;

 If (TxblInc >  Constant[RY].Bracket2) and (TxblInc <=Constant[RY].Bracket3) then
  begin result:= Constant[RY].BracketTax2+Constant[RY].BracketTax3+
   (TxblInc-Constant[RY].Bracket3) * Vl(Constant[RY].Rate3)/100;exit;end;

 If (TxblInc >  Constant[RY].Bracket3) then
  begin result:= Constant[RY].BracketTax2+Constant[RY].BracketTax3+
   (TxblInc-Constant[RY].Bracket3) * Vl(Constant[RY].Rate4)/100;exit;end;
end;


//20220915
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
  Cpi := 1019; // 2020 //1.022; // 2015 //1.028; //20120606

  {
  Constant[0].DivOtherThanElig := 9.0301; // 2022  //see CRA D1
  Constant[1].DivOtherThanElig := 9.0301; // 2022  //see CRA D1

  Constant[0].DivElig := 15.0198; // 2022   //see CRA D1
  Constant[1].DivElig := 15.0198; // 2022   //see CRA D1
  //designated by issuing corp after informing its shareholders
 }
  // 20150903   // FCA=Family CareGiver Amount
  Constant[0].FCAAmount := 2350; // 2022  See S5
  Constant[1].FCAAmount := 2350; // 2022  See S5

  // http://www.cra-arc.gc.ca/tx/rgstrd/papspapar-fefespfer/lmts-eng.html  RRSP etc limits
  // 20161129  http://www.taxtips.ca/rrsp/rrspcontributionlimits.htm
  // 2017  http://www.taxtips.ca/rrsp/rrspcontributionlimits.htm //20160505 Igor
  Constant[0].MoneyPurchaseLimit := 30780; //2022 //TaxTips
  Constant[1].MoneyPurchaseLimit := 30780; //2022 //TaxTips

  // s1
  Constant[0].Rate1 := '15.0'; // 2022
  Constant[1].Rate1 := '15.0'; // 2022

  Constant[0].Rate2 := '20.5'; // 2022
  Constant[1].Rate2 := '20.5'; // 2022

  Constant[0].Rate3 := '26'; // 2022
  Constant[1].Rate3 := '26'; // 2022

  Constant[0].Rate4 := '29'; // 2022
  Constant[1].Rate4 := '29'; // 2022

  Constant[0].Rate5 := '33'; // 2022
  Constant[1].Rate5 := '33'; // 2022

  Constant[0].Bracket1 := 50197; // 2022
  Constant[1].Bracket1 := 50197; // 2022

  Constant[0].Bracket2 := 100392; // 2022
  Constant[1].Bracket2 := 100392; // 2022

  Constant[0].Bracket3 := 155625; // 2022
  Constant[1].Bracket3 := 155625; // 2022

  Constant[0].Bracket4 := 221708; // 2022
  Constant[1].Bracket4 := 221708; // 2022

  Constant[0].BracketTax1 := 0; // 2022
  Constant[1].BracketTax1 := 0; // 2022

  // 20201130 added penies
  Constant[0].BracketTax2 := 7529.55; // 2022
  Constant[1].BracketTax2 := 7529.55; // 2022

  Constant[0].BracketTax3 := 17819.53; // 2022
  Constant[1].BracketTax3 := 17819.53; // 2022

  Constant[0].BracketTax4 := 32180.11; // 2022
  Constant[1].BracketTax4 := 32180.11; // 2022

  Constant[0].BracketTax5 := 51344.18; // 2022
  Constant[1].BracketTax5 := 51344.18; // 2022

  Constant[0].BasicPersonalAmount := 14398; // 2022
  Constant[1].BasicPersonalAmount := 14398; // 2022

  Constant[0].FullYear := 365; // 2022
  Constant[1].FullYear := 365; // 2022

  // from 5000g guide line 301
  Constant[0].MaxAgeAmount := 7898; // 2022
  Constant[1].MaxAgeAmount := 7898; // 2022

  // from 5000g guide line 301, reduced when income exceeds
  Constant[0].AgeBaseAmount := 39826; // 2022
  Constant[1].AgeBaseAmount := 39826; // 2022

  // from 5000g guide line 301, eliminated when income exceeds
  Constant[0].AgeNIThreshHold := 92480; // 2022
  Constant[1].AgeNIThreshHold := 92480; // 2022

  // 5000g line 367
  Constant[0].KidClaim := 0; // 2022
  Constant[1].KidClaim := 0; // 2022

  // 5000d line 306, eliminated when dependant income exceeds
  Constant[0].InfirmDependBase := 17670; // 2022  //taxtips Infirm adult
  Constant[1].InfirmDependBase := 17670; // 2022  //taxtips Infirm adult

  // Infirm dependant amount (18+ years of age), including Family Caregiver Amount (Federal & YT)
  Constant[0].MaxInfirmAmount := 7525; // 2022 taxtips infirm adult
  Constant[1].MaxInfirmAmount := 7525; // 2022 taxtips infirm adult

  // 5000d line 315, eliminated when relative's income exceeds
  Constant[0].CareGvrBase := 25195; // 2022
  Constant[1].CareGvrBase := 25195; // 2022

  // 5000d line 315, for in-home care of parent or grandparent 65+ years of age, or of infirm adult relative(3)
  Constant[0].MaxCareGvr := 4732; // 2022
  Constant[1].MaxCareGvr := 4732; // 2022

  // 5000g Line 316
  Constant[0].MaxDisability := 8870; // 2022
  Constant[1].MaxDisability := 8870; // 2022

  // 5000g Line 316, Disability amount supplement for taxpayers under 18 years of age
  Constant[0].MaxDisabSupl18 := 5174; // 2022
  Constant[1].MaxDisabSupl18 := 5174; // 2022

  // 5000d Line 316, reduced when total child care and attendant care expenses claimed for this taxpayer by anyone exceed
  Constant[0].DisabSuplBase := 3030; // 2022
  Constant[1].DisabSuplBase := 3030; // 2022

  // s1, Spouse or common-law partner / equivalent-to-spouse / eligible dependant amount (3) except PE(1)
  Constant[0].MaxSpousalAmount := 14398; // 2022
  Constant[1].MaxSpousalAmount := 14398; // 2022

  //20210805
  //  s1, -eliminated when spousal/dependant income exceeds
  //  Constant[0].SpousalBase := 13204; // 2020  //20201121
  //  Constant[1].SpousalBase := 13204; // 2020   ??

  // s1, Medical expense tax credit is for expenses in excess of the lesser of 3% of net income or
  Constant[0].MedicalLimit := 2479; // 2022
  Constant[1].MedicalLimit := 2479; // 2022

  // 5000g ln 331 The maximum $10,000 limit per eligible dependant has been removed. For more information, see page 46
  Constant[0].MaxMedicalExpense := 200000; // 2022
  Constant[1].MaxMedicalExpense := 200000; // 2022

  //see odf 5000.d1
  // 5000d Line 452 base amount, see 5000.d worksheet line 452 Family net income threshold http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].MedicalRefundBase := 29129; // 2022
  Constant[1].MedicalRefundBase := 29129; // 2022

  // 5000g line 452,  // 2017 Maximum supplement http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].MedicalRefundSupplement := 1316; // 2022
  Constant[1].MedicalRefundSupplement := 1316; // 2022

  // 5000g line 452   // 2017 Minimum earnings threshold http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].MedicalRefundMinThreshHold := 3841; // 2022
  Constant[1].MedicalRefundMinThreshHold := 3841; // 2022

  //see taxtips.ca CPP / EI
  // 5000g Line 308, fed t2204   // 2018 http://www.cra-arc.gc.ca/tx/bsnss/tpcs/pyrll/clcltng/cpp-rpc/cnt-chrt-pf-eng.html
  Constant[0].MaxCpp := 3499.80; // 2022
  Constant[1].MaxCpp := 3499.80; // 2022

  // s8 line 6   // 2017 same  http://www.cra-arc.gc.ca/tx/bsnss/tpcs/pyrll/clcltng/cpp-rpc/cnt-chrt-pf-eng.html
  Constant[0].BasicCppExemption := 3500;  //2022
  Constant[1].BasicCppExemption := 3500;  //2022

  // 2017 same as  http://www.cra-arc.gc.ca/tx/bsnss/tpcs/pyrll/clcltng/cpp-rpc/cnt-chrt-pf-eng.html
  Constant[0].CPPRate := 0.0570; // 2022
  Constant[1].CPPRate := 0.0570; // 2022

  // 5000g Line 308   // 2018 http://www.cra-arc.gc.ca/tx/bsnss/tpcs/pyrll/clcltng/cpp-rpc/cnt-chrt-pf-eng.html
  Constant[0].MaxCppPensionable := 64900; // 2022
  Constant[1].MaxCppPensionable := 64900; // 2022

  // s8 line 7 maximum
  Constant[0].MaxCppEarnings := Constant[0].MaxCppPensionable - Constant[0]
    .BasicCppExemption; // maxpensiinable less exemption 3,500
  Constant[1].MaxCppEarnings := Constant[1].MaxCppPensionable - Constant[1]
    .BasicCppExemption; // maxpensiinable less exemption 3,500

  // 20161119
  Constant[0].QPPRate := 0.0615; // 2022
  Constant[1].QPPRate := 0.0615; // 2022

  Constant[0].MaxQpp := 3776.10; // 2022
  Constant[1].MaxQpp := 3776.10; // 2022

  // http://www.taxtips.ca/cppandei/eirates.htm  see QC section
  // BETTER http://www.revenuquebec.ca/en/entreprises/ras/calculer-ras/rqap/maxrevenusassurables.aspx

  Constant[0].UIRate := 0.0158; // 2022
  Constant[1].UIRate := 0.0158; // 2022

  // http://www.taxtips.ca/cppandei/eirates.htm
  Constant[0].QCUIRate := 0.0120; // 2022
  Constant[1].QCUIRate := 0.0120; // 2022

  // http://www.taxtips.ca/cppandei/eirates.htm
  Constant[0].MaxUI52 := 952.74; // 2022
  Constant[1].MaxUI52 := 952.74; // 2022

  Constant[0].QCMaxUI52 := 723.60; // 2022
  Constant[1].QCMaxUI52 := 723.60; // 2022

  // same including qc //http://www.taxtips.ca/cppandei/eirates.htm
  Constant[0].MaxUIEarn52 := 60300; // 2022
  Constant[1].MaxUIEarn52 := 60300; // 2022

  //PPIP se S10 form
  // https://www.google.ca/search?sourceid=navclient&aq=&oq=ppip+rate&ie=UTF-8&rlz=1T4WZPC_enCA452CA452&q=ppip+rate&gs_l=hp..2.0i22i30l3.0.0.2.137361...........0.judAT9JptL0
  Constant[0].MaxPPIPEarnings := 88000; // 2022
  Constant[1].MaxPPIPEarnings := 88000; // 2022

  Constant[0].PPIPRate := 0.494; // 2022
  Constant[1].PPIPRate := 0.494; // 2022

  Constant[0].MaxPPIP := 434.72; // 2022  //??? s10 not released on A4
  Constant[1].MaxPPIP := 434.72; // 2022  //??? s10 not released on A4

  // self empl
  Constant[0].SEPPIPRate := 0.878; // 2022
  Constant[1].SEPPIPRate := 0.878; // 2022

  // s10
  Constant[0].MaxSEPPIP := 772.84; // 2022
  Constant[1].MaxSEPPIP := 772.84; // 2022

  // s10
  Constant[0].PPIPDeductionRate := 43.736; // 2022
  Constant[1].PPIPDeductionRate := 43.736; // 2022
  // --------------------------------------------------------------

  // s11, 5000g line 323
  Constant[0].EducPerMonth := 0; // 2022 // 400; // 20180408
  Constant[1].EducPerMonth := 0; // 2022  // 400; // 20180408

  Constant[0].PartEducPerMonth := 0; // 2022 // 120; //// 20180408
  Constant[1].PartEducPerMonth := 0; // 2022 // 120; // // 20180408

  // s11, 5000g line 326
  Constant[0].EducLimit := 5000; // 2022
  Constant[1].EducLimit := 5000; // 2022

  // s9, 5000g line 349
  Constant[0].DonPercent := 75; // 2022
  Constant[1].DonPercent := 75; // 2022

  // http://www.cra-arc.gc.ca/limits/
  // https://www.canada.ca/en/revenue-agency/services/tax/registered-plans-administrators/pspa/mp-rrsp-dpsp-tfsa-limits-ympe.html
  Constant[0].RSPLimit := 29210; // 2022
  Constant[1].RSPLimit := 29210; // 2022

  // 5000g ln 235 //http://www.taxtips.ca/cppandei/eiclawback.htm
  Constant[0].UIBaseRep := 75375; // 2022
  Constant[1].UIBaseRep := 75375; // 2022

  // 5000g line 235 //Old age security repayment threshold http://www.cra-arc.gc.ca/nwsrm/fctshts/2014/m11/fs141125-eng.html
  Constant[0].OASBaseRep := 81761; // 2022
  Constant[1].OASBaseRep := 81761; // 2022

  // 5000g line 313
  Constant[0].MaxAdoption := 17131; // 2022
  Constant[1].MaxAdoption := 17131; // 2022

  // s1 ln363
  Constant[0].CanEmplAmount := 1287; // 2022
  Constant[1].CanEmplAmount := 1287; // 2022

  // s9 line 346
  Constant[0].DonRate1 := 15.00; // 2022
  Constant[1].DonRate1 := 15.00; // 2022
  // s9 line 348
  Constant[0].DonRate2 := 29; // 2022
  Constant[1].DonRate2 := 29; // 2022
end;


Procedure InitPRVConstants(Prv: String);
Var
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
  If Prv = 'ON' then // done  //See 5006.d
  begin
    Cpi := 1.02;

    PrvConstant[0].PrvRate1 := '5.05'; // 2022
    PrvConstant[1].PrvRate1 := '5.05'; // 2022

    PrvConstant[0].PrvRate2 := '9.15'; // 2022
    PrvConstant[1].PrvRate2 := '9.15'; // 2022

    PrvConstant[0].PrvRate3 := '11.16'; // 2022
    PrvConstant[1].PrvRate3 := '11.16'; // 2022

    PrvConstant[0].PrvRate4 := '12.16'; // 2022
    PrvConstant[1].PrvRate4 := '12.16'; // 2022

    PrvConstant[0].PrvRate5 := '13.16'; // 2022
    PrvConstant[1].PrvRate5 := '13.16'; // 2022

    PrvConstant[0].PrvBracket1 := 46226; // 2022
    PrvConstant[1].PrvBracket1 := 46226; // 2022

    PrvConstant[0].PrvBracket2 := 92454; // 2022
    PrvConstant[1].PrvBracket2 := 92454; // 2022

    PrvConstant[0].PrvBracket3 := 150000; // 2022
    PrvConstant[1].PrvBracket3 := 150000; // 2022

    PrvConstant[0].PrvBracket4 := 220000; // 2022
    PrvConstant[1].PrvBracket4 := 220000; // 2022

    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // 20191125
    PrvConstant[0].PrvBracketTax2 := 2334.41;  // 2022
    PrvConstant[1].PrvBracketTax2 := 2334.41;  // 2022

    PrvConstant[0].PrvBracketTax3 := 6564.28; // 2022
    PrvConstant[1].PrvBracketTax3 := 6564.28; // 2022

    PrvConstant[0].PrvBracketTax4 := 12986.41; //2022
    PrvConstant[1].PrvBracketTax4 := 12986.41; //2022

    PrvConstant[0].PrvBracketTax5 := 21498.41; // 2022
    PrvConstant[1].PrvBracketTax5 := 21498.41; // 2022

    PrvConstant[0].PrvPersAmount := 11141; // 2022
    PrvConstant[1].PrvPersAmount := 11141; // 2022

    // guide 5006-n line  5006-pc Line 5808   TaxTips
    PrvConstant[0].PrvAgeNIThreshHold := 76762; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 76762; // 2022

    // 5006d Line 5808
    PrvConstant[0].PrvMaxAgeAmount := 5440; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 5440; // 2022

    // 5006d Line 5808
    PrvConstant[0].PrvAgeBaseAmount := 40495; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 40495; // 2022
    // 2017 reduced when income exceeds

    // 5006c Spouse or common-law partner amount     // eliminated when spousal/dependant income exceeds
    PrvConstant[0].PrvSpouseBasicAmount := 10406; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 10406; // 2022

    // 5006c ln 5816     // 2017 Spouse or common-law partner / equivalent-to-spouse / eligible dependant
    PrvConstant[0].PrvMaxSpousalAmount := 9460; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 9460; // 2022

    // 5006d line 5820     // 2017  eliminated when dependant income exceeds
    PrvConstant[0].PrvInfirmDependBase := 11257; // 2022
    PrvConstant[1].PrvInfirmDependBase := 11257; // 2022

    // 5006d line 5820     // 2017 Infirm dependant amount (18+ years of age), including Family Caregiver Amount
    PrvConstant[0].PrvMaxInfirmDependAmount := 5262; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 5262; // 2022

    // 5006pc Line 5836
    PrvConstant[0].PrvMaxPensionAmount := 1541; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1541; // 2022

    // 5006d Line 5840     // 20171128 20862; //2017 -eliminated when relative's income exceeds
    PrvConstant[0].PrvCareGvrBase := 23217; // 2022
    PrvConstant[1].PrvCareGvrBase := 23217; // 2022

    // 5006d line 5840     //2017 Caregiver amount for in-home care of parent or grandparent 65+ years of age, or of infirm adult relative
    PrvConstant[0].PrvMaxCareGvr := 5252; // 2022
    PrvConstant[1].PrvMaxCareGvr := 5252; // 2022

    // 5006s11 line 5918
    PrvConstant[0].PrvEducPerMonth := 547; // 2022
    PrvConstant[1].PrvEducPerMonth := 547; // 2022 ???? most likely 0

    // 5006s11 line 5916
    PrvConstant[0].PrvPartEducPerMonth := 164; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 164; // 2022 ????    most likely 0

    // 5006s11
    PrvConstant[0].PrvMaxEducXfer := 7033; // 2022
    PrvConstant[1].PrvMaxEducXfer := 7033; // 2022

    // 5006d Line 5872     // 2017 Medical expense tax credit is for expenses in excess of the lesser of 3% of net income or
    PrvConstant[0].PrvMedicalLimit := 2522; // 2022
    PrvConstant[1].PrvMedicalLimit := 2522; // 2022

    // 5006-d Line 5872     // 2017 Maximum medical expenses for other eligible dependants (each)
    PrvConstant[0].PrvMaxMedicalExpense := 13274; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 13274; // 2022

    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // 5006c Donations and gifts
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // 5006c Donations and gifts
    PrvConstant[0].PrvDonRate2 := 11.16; // 2022
    PrvConstant[1].PrvDonRate2 := 11.16; // 2022

    PrvConstant[0].PrvDivRate := '2.9863'; // 2022
    PrvConstant[1].PrvDivRate := '2.9863'; // 2022

    PrvConstant[0].PrvDivRateBig := '10'; // 2022
    PrvConstant[1].PrvDivRateBig := '10'; // 2022

    // 5006c
    PrvConstant[0].PrvOverseasRate := 38.5; // 2022
    PrvConstant[1].PrvOverseasRate := 38.5; // 2022

    // 5006c
    PrvConstant[0].PrvAmtCarryOverRate := 33.67; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 33.67; // 2022

    // 5006 pc line Line 5844
    PrvConstant[0].PrvMaxDisability := 9001; // 2022
    PrvConstant[1].PrvMaxDisability := 9001; // 2022

    // 5006 pc line Line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 5250; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 5250; // 2022

    // 5006d Line 5844 Base amount     // 2017 -reduced when total child care and attendant care expenses claimed for this taxpayer by anyone exceed
    PrvConstant[0].PrvDisabSuplBase := 3075; // 2022
    PrvConstant[1].PrvDisabSuplBase := 3075; // 2022

    // 5006 pc Line 5833     // 2017 Eligible adoption expenses - maximum per child
    PrvConstant[0].PrvMaxAdoption := 13593; // 2022
    PrvConstant[1].PrvMaxAdoption := 13593; // 2022

  end; // ON

  If Prv = 'AB' then //in 2022 all look the same as 2021 ????
  begin
    Cpi := 1.024;
    //20221214
    // 20150907  New tax brackets
    PrvConstant[0].PrvRate1 := '10'; // 2022
    PrvConstant[1].PrvRate1 := '10'; // 2022

    PrvConstant[0].PrvRate2 := '12.0'; // 2022
    PrvConstant[1].PrvRate2 := '12.0'; // 2022

    PrvConstant[0].PrvRate3 := '13.0'; // 2022
    PrvConstant[1].PrvRate3 := '13.0'; // 2022

    PrvConstant[0].PrvRate4 := '14.0'; // 2022
    PrvConstant[1].PrvRate4 := '14.0'; // 2022

    PrvConstant[0].PrvRate5 := '15.0'; // 2022
    PrvConstant[1].PrvRate5 := '15.0'; // 2022

    //20221214
    PrvConstant[0].PrvBracket1 := 134238; //131220; // 2022
    PrvConstant[1].PrvBracket1 := 134238; //131220; // 2022

    PrvConstant[0].PrvBracket2 := 161086; //157464; // 2022
    PrvConstant[1].PrvBracket2 := 161086; //157464; // 2022

    PrvConstant[0].PrvBracket3 := 214781; //209952; // 2022
    PrvConstant[1].PrvBracket3 := 214781; //209952; // 2022

    PrvConstant[0].PrvBracket4 := 322171; //314928; // 2022
    PrvConstant[1].PrvBracket4 := 322171; //314928; // 2022

    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    PrvConstant[0].PrvBracketTax2 := 13423.80; //122; // 2022 // Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100); //?
    PrvConstant[1].PrvBracketTax2 := 13423.80; //13122; // 2022 // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);

    PrvConstant[0].PrvBracketTax3 := 16645.56; //16271.28; // 2022 // Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 16645.56; //16271.28; // 2022 // Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);

    PrvConstant[0].PrvBracketTax4 := 23625.91; //23094.72; // 2022 // Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 23625.91; //23094.72; // 2022 // Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);

    PrvConstant[0].PrvBracketTax5 := 38660.51; //7791.36; // 2022 // Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100); //?
    PrvConstant[1].PrvBracketTax5 := 38660.51; //37791.36; // 2022 // Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100);

    PrvConstant[0].PrvPersAmount := 19814; //19369; // 2022
    PrvConstant[1].PrvPersAmount := 19814; //19369; // 2022

    // 5009pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 77911; //76159; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 77911; //76159; // 2022

    // 5009d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 5521; //5397; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 5521; //5397; // 2022

    // 5009d line 5808
    PrvConstant[0].PrvAgeBaseAmount := 41104; //40179; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 41104; //40179; // 2022

    // 5009c Spouse or common-law partner amount
    PrvConstant[0].PrvSpouseBasicAmount := 19814; // 2022 //20221215
    PrvConstant[1].PrvSpouseBasicAmount := 19814; // 2022

    PrvConstant[0].PrvMaxSpousalAmount := 19814; // 2022  //20221215
    PrvConstant[1].PrvMaxSpousalAmount := 19814; // 2022

    // 5009d line 5820
    PrvConstant[0].PrvInfirmDependBase := 19047; //18619; // 2022
    PrvConstant[1].PrvInfirmDependBase := 19047; //18619; // 2022

    // 5009d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 11212; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 11212; // 2022

    // 5009c line 5836
    PrvConstant[0].PrvMaxPensionAmount := 1526; //1491; // 2022 20221214
    PrvConstant[1].PrvMaxPensionAmount := 1526; //1491; // 2022

    // 5009d line 5840
    PrvConstant[0].PrvCareGvrBase := 29706; //29038; // 2022
    PrvConstant[1].PrvCareGvrBase := 29705; //29038; // 2022

    // 5009d line 5840
    PrvConstant[0].PrvMaxCareGvr := 11470; //11212; // 2022
    PrvConstant[1].PrvMaxCareGvr := 11470; //11212; // 2022

    // 5009s11
    PrvConstant[0].PrvPartEducPerMonth := 226; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 226; // 2022

    // 5009s11
    PrvConstant[0].PrvEducPerMonth := 753; // 2022
    PrvConstant[1].PrvEducPerMonth := 753; // 2022

    // 5009s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // 5009c
    PrvConstant[0].PrvMedicalLimit := 2560; //2503; // 2022 //20221214
    PrvConstant[1].PrvMedicalLimit := 2560; //2503; // 2022

    // 5009d line 5872
    PrvConstant[0].PrvMaxMedicalExpense := 13571; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 13571; // 2022

    // 5009c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // 5009c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // 5009d Line 5896
    PrvConstant[0].PrvDonRate2 := 21.00; // 2022
    PrvConstant[1].PrvDonRate2 := 21.00; // 2022

    // 5009d Line 6152
    PrvConstant[0].PrvDivRate := '2.18'; // 2022
    PrvConstant[1].PrvDivRate := '2.18'; // 2022

    // 5009d Line 6152
    PrvConstant[0].PrvDivRateBig := '8.12'; // 2022
    PrvConstant[1].PrvDivRateBig := '8.12'; // 2022

    // 5009c top page 2
    PrvConstant[0].PrvOverseasRate := 35; // 2022
    PrvConstant[1].PrvOverseasRate := 35; // 2022

    // 5009c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 35; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 35; // 2022

    // 5009d line 5844
    PrvConstant[0].PrvMaxDisability := 15284; //14940; // 2022 //20221214
    PrvConstant[1].PrvMaxDisability := 15284; //14940; // 2022
    // 5009d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 11470; //11212; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 11470; //11212; // 2022

    // 5009d line 5844
    PrvConstant[0].PrvDisabSuplBase := 3128; //3057; // 2022
    PrvConstant[1].PrvDisabSuplBase := 3128; //3057; // 2022

    // 5009pc line 5833
    PrvConstant[0].PrvMaxAdoption := 13552; //13247; // 2022  //20221215
    PrvConstant[1].PrvMaxAdoption := 13552; //13247; // 2022

  end; // ab

  If Prv = 'MB' then
  // ----------------------------------------------------------
  begin
    Cpi := 1.000;
    // 5007-c
    PrvConstant[0].PrvBracket1 := 34431; // 2022
    PrvConstant[1].PrvBracket1 := 34431; // 2022

    // 5007-c
    PrvConstant[0].PrvBracket2 := 74416; // 2022
    PrvConstant[1].PrvBracket2 := 74416; // 2022

    // 5007-c
    PrvConstant[0].PrvRate1 := '10.8'; // 2022
    PrvConstant[1].PrvRate1 := '10.8'; // 2022
    // 5007-c
    PrvConstant[0].PrvRate2 := '12.75'; // 2022
    PrvConstant[1].PrvRate2 := '12.75'; // 2022

    // 5007-c
    PrvConstant[0].PrvRate3 := '17.4'; // 2022
    PrvConstant[1].PrvRate3 := '17.4'; // 2022

    // 5007-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // 5007-c
    PrvConstant[0].PrvBracketTax2 := 3718.55; // 2022   // Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100); //20130512
    PrvConstant[1].PrvBracketTax2 := 3718.55; // 2022   // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);

    // 5007-c
    PrvConstant[0].PrvBracketTax3 := 8816.64; // 2022  Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100); //20130512
    PrvConstant[1].PrvBracketTax3 := 8816.64; // 2022  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);

    // 5007-c line 5804
    PrvConstant[0].PrvPersAmount := 10145; // 2022
    PrvConstant[1].PrvPersAmount := 10145; // 2022

    // 5007-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 52602; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 52602; // 2022


    // 5007-d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 3728; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 3728; // 2022

    // 5007-d line 5808
    PrvConstant[0].PrvAgeBaseAmount := 27749; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 27749; // 2022

    // 5007-c Spouse or common-law partner amount
    PrvConstant[0].PrvSpouseBasicAmount := 9134; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 9134; // 2022

    // 5007-c line 5812
    PrvConstant[0].PrvMaxSpousalAmount := 9134; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 9134; // 2022

    // 5007-d line 5820
    PrvConstant[0].PrvInfirmDependBase := 8720; // 2022
    PrvConstant[1].PrvInfirmDependBase := 8720; // 2022

    // 5007-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 3605; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 3605; // 2022

    // 5007-c line 5836, fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount := 1000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1000; // 2022

    // 5007-d line 5840
    PrvConstant[0].PrvCareGvrBase := 15917; // 2022
    PrvConstant[1].PrvCareGvrBase := 15917; // 2022

    // 5007-d line 5840
    PrvConstant[0].PrvMaxCareGvr := 3605; // 2022
    PrvConstant[1].PrvMaxCareGvr := 3605; // 2022

    // 5007-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2022

    // 5007-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2022
    PrvConstant[1].PrvEducPerMonth := 400; // 2022

    // 5007-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // 5007-c -d line 5872
    PrvConstant[0].PrvMedicalLimit := 1728; // 2022
    PrvConstant[1].PrvMedicalLimit := 1728; // 2022

    // 5007-d  line 5872
    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // 5007-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // 5007-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // 5007-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 17.4; // 2022
    PrvConstant[1].PrvDonRate2 := 17.4; // 2022

    // 5007-d line 6152
    PrvConstant[0].PrvDivRate := '0.7835'; // 2022
    PrvConstant[1].PrvDivRate := '0.7835'; // 2022

    // 5007-d line 6152
    PrvConstant[0].PrvDivRateBig := '8'; // 2022
    PrvConstant[1].PrvDivRateBig := '8'; // 2022

    // 5007-c line 6153
    PrvConstant[0].PrvOverseasRate := 50; // 2022
    PrvConstant[1].PrvOverseasRate := 50; // 2022

    // 5007-c line 6154
    PrvConstant[0].PrvAmtCarryOverRate := 50; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 50; // 2022

    // 5007-d line 5848
    PrvConstant[0].PrvMaxDisability := 6180; // 2022
    PrvConstant[1].PrvMaxDisability := 6180; // 2022

    // 5007-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 3605; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 3605; // 2022

    // 5007-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2112; // 2022
    PrvConstant[1].PrvDisabSuplBase := 2112; // 2022

    // 5007-pc line 5833
    PrvConstant[0].PrvMaxAdoption := 10000; // 2022
    PrvConstant[1].PrvMaxAdoption := 10000; // 2022

  end; // end mb

  If Prv = 'BC' then
  // ---------------------------------------------------------
  begin
    Cpi := 1.007;
    // from 5010-c
    PrvConstant[0].PrvBracket1 := 43070; // 2022
    PrvConstant[1].PrvBracket1 := 43070; // 2022

    // from 5010-c
    PrvConstant[0].PrvBracket2 := 86141; // 2022
    PrvConstant[1].PrvBracket2 := 86141; // 2022

    // from 5010-c
    PrvConstant[0].PrvBracket3 := 98901; // 2022
    PrvConstant[1].PrvBracket3 := 98901; // 2022

    // from 5010-c
    PrvConstant[0].PrvBracket4 := 120094; // 2022
    PrvConstant[1].PrvBracket4 := 120094; // 2022

    PrvConstant[0].PrvBracket5 := 162832; // 2022
    PrvConstant[1].PrvBracket5 := 162832; // 2022

    PrvConstant[0].PrvBracket6 := 227091; // 2022
    PrvConstant[1].PrvBracket6 := 227091; // 2022

    // from 5010-c
    PrvConstant[0].PrvRate1 := '5.06'; // 2022
    PrvConstant[1].PrvRate1 := '5.06'; // 2022

    // from 5010-c
    PrvConstant[0].PrvRate2 := '7.7'; // 2022
    PrvConstant[1].PrvRate2 := '7.7'; // 2022

    // from 5010-c
    PrvConstant[0].PrvRate3 := '10.5'; // 2022
    PrvConstant[1].PrvRate3 := '10.5'; // 2022

    // from 5010-c
    PrvConstant[0].PrvRate4 := '12.29'; // 2022
    PrvConstant[1].PrvRate4 := '12.29'; // 2022

    // from 5010-c
    PrvConstant[0].PrvRate5 := '14.7'; // 2022
    PrvConstant[1].PrvRate5 := '14.7'; // 2022

    // from 5010-c
    PrvConstant[0].PrvRate6 := '16.8'; // 2022
    PrvConstant[1].PrvRate6 := '16.8'; // 2022

    // 20201108
    PrvConstant[0].PrvRate7 := '20.5'; // 2022
    PrvConstant[1].PrvRate7 := '20.5'; // 2022

    // from 5010-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // from 5010-c
    PrvConstant[0].PrvBracketTax2 := 2179.34; // 2022    // Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2 := 2179.34; // 2022    // Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);

    // from 5010-c
    PrvConstant[0].PrvBracketTax3 := 5495.81; // 2022  Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 5495.81; // 2022  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);

    // from 5010-c
    PrvConstant[0].PrvBracketTax4 := 6835.81; // 2022  Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 6835.81; // 2022  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);

    // from 5010-c
    PrvConstant[0].PrvBracketTax5 := 9440.23; // 2022  Round(GetTaxOnBase(PrvConstant[0].PrvBracket4,PrvConstant[0].PrvBracket3,Vl(PrvConstant[0].PrvRate4),PrvConstant[0].PrvBracketTax4));
    PrvConstant[1].PrvBracketTax5 := 9440.23; // 2022  Round(GetTaxOnBase(PrvConstant[1].PrvBracket4,PrvConstant[1].PrvBracket3,Vl(PrvConstant[1].PrvRate4),PrvConstant[1].PrvBracketTax4));

    // from 5010-c
    PrvConstant[0].PrvBracketTax6 := 15722.71; // 2022  Round(GetTaxOnBase(PrvConstant[0].PrvBracket5,PrvConstant[0].PrvBracket4,Vl(PrvConstant[0].PrvRate5),PrvConstant[0].PrvBracketTax5));
    PrvConstant[1].PrvBracketTax6 := 15722.71; // 2022  Round(GetTaxOnBase(PrvConstant[1].PrvBracket5,PrvConstant[1].PrvBracket4,Vl(PrvConstant[1].PrvRate5),PrvConstant[1].PrvBracketTax5));

    PrvConstant[0].PrvBracketTax7 := 26518.23; // 2022
    PrvConstant[1].PrvBracketTax7 := 26518.23; // 2022

    // from 5010-c line 5804
    PrvConstant[0].PrvPersAmount := 11302; // 2022
    PrvConstant[1].PrvPersAmount := 11302; // 2022

    // from 5010-pc Line 5808 – Age amount
    PrvConstant[0].PrvAgeNIThreshHold := 71524; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 71524; // 2022

    // from 5010-d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 5069; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 5069; // 2022

    // from 5010-d Line 5808
    PrvConstant[0].PrvAgeBaseAmount := 37730; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 37730; // 2022

    // from 5010-c
    PrvConstant[0].PrvSpouseBasicAmount := 10646; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 10646; // 2022

    // from 5010-c line 5812
    PrvConstant[0].PrvMaxSpousalAmount := 9678; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 9678; // 2022

    // from 5010-d Line 5820
    PrvConstant[0].PrvInfirmDependBase := 11582; // 2022
    PrvConstant[1].PrvInfirmDependBase := 11582; // 2022

    // from 5010-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 4946; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 4946; // 2022

    // from 5010-c line 5836
    PrvConstant[0].PrvMaxPensionAmount := 1000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1000; // 2022

    // from 5010-d Line 5840
    PrvConstant[0].PrvCareGvrBase := 21684; // 2022
    PrvConstant[1].PrvCareGvrBase := 21684; // 2022

    // from 5010-d Line 5840
    PrvConstant[0].PrvMaxCareGvr := 4946; // 2022
    PrvConstant[1].PrvMaxCareGvr := 4946; // 2022

    // from 5010-s11
    PrvConstant[0].PrvPartEducPerMonth := 60; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 60; // 2022

    // from 5010-s11
    PrvConstant[0].PrvEducPerMonth := 200; // 2022
    PrvConstant[1].PrvEducPerMonth := 200; // 2022

    // from 5010-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5010d or 5010c Line 5872
    PrvConstant[0].PrvMedicalLimit := 2350; // 2022
    PrvConstant[1].PrvMedicalLimit := 2350; // 2022

    // from 5010-d Line 5872
    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5010-c bottom of page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5010-c bottom of page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5010-c bottom of page 1
    PrvConstant[0].PrvDonRate2 := 16.8; // 2022
    PrvConstant[1].PrvDonRate2 := 16.8; // 2022

    // from 5010-c -d line 6152
    PrvConstant[0].PrvDivRate := '1.96'; // 2022
    PrvConstant[1].PrvDivRate := '1.96'; // 2022

    // from 5010-d line 6152
    PrvConstant[0].PrvDivRateBig := '12'; // 2022
    PrvConstant[1].PrvDivRateBig := '12'; // 2022

    // from 5010-c -d line 6153 line 44
    PrvConstant[0].PrvOverseasRate := 49.5; // 2022
    PrvConstant[1].PrvOverseasRate := 49.5; // 2022

    // from 5010-c top of page 2
    PrvConstant[0].PrvAmtCarryOverRate := 33.7; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 33.7; // 2022

    // from 5010-d line 5844
    PrvConstant[0].PrvMaxDisability := 8477; // 2022
    PrvConstant[1].PrvMaxDisability := 8477; // 2022

    // from 5010-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 4946; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 4946; // 2022

    // from 5010-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2871; // 2022
    PrvConstant[1].PrvDisabSuplBase := 2871; // 2022

    PrvConstant[0].PrvMaxAdoption := 17131; // 2022 //20221215
    PrvConstant[1].PrvMaxAdoption := 17131; // 2022

  end; { bc }

  If Prv = 'NL' then
  // ---------------------------------------------------------
  begin
    Cpi := 1.009; // 2020
    // from 5001-c
    PrvConstant[0].PrvBracket1 := 39147; // 2022
    PrvConstant[1].PrvBracket1 := 39147; // 2022

    // from 5001-c
    PrvConstant[0].PrvBracket2 := 78294; // 2022
    PrvConstant[1].PrvBracket2 := 78294; // 2022

    // 20150908
    // from 5001-c
    PrvConstant[0].PrvBracket3 := 139780;// 2022
    PrvConstant[1].PrvBracket3 := 139780;// 2022

    // from 5001-c
    PrvConstant[0].PrvBracket4 := 195693; // 2022
    PrvConstant[1].PrvBracket4 := 195693; // 2022

    // from 5001-c
    PrvConstant[0].PrvBracket5 := 250000; // 2022
    PrvConstant[1].PrvBracket5 := 250000; // 2022

    // from 5001-c
    PrvConstant[0].PrvBracket6 := 500000; // 2022
    PrvConstant[1].PrvBracket6 := 500000; // 2022

   {//20230304
    // from 5001-c
    PrvConstant[0].PrvBracket7 := 1000000; // 2022
    PrvConstant[1].PrvBracket7 := 1000000; // 2022

  }
    // from 5001-c
    PrvConstant[0].PrvRate1 := '8.7'; // 2022
    PrvConstant[1].PrvRate1 := '8.7'; // 2022

    // from 5001-c
    PrvConstant[0].PrvRate2 := '14.5'; // 2022
    PrvConstant[1].PrvRate2 := '14.5'; // 2022

    // 20150908
    // from 5001-c
    PrvConstant[0].PrvRate3 := '15.80'; // 2022
    PrvConstant[1].PrvRate3 := '15.80'; // 2022

    // from 5001-c
    PrvConstant[0].PrvRate4 := '17.80'; // 2022
    PrvConstant[1].PrvRate4 := '17.80'; // 2022

    // from 5001-c
    PrvConstant[0].PrvRate5 := '19.80'; // 2022
    PrvConstant[1].PrvRate5 := '19.80'; // 2022

    // from 5001-c
    PrvConstant[0].PrvRate6 := '20.80'; // 2022
    PrvConstant[1].PrvRate6 := '20.80'; // 2022

    // from 5001-c
    PrvConstant[0].PrvRate7 := '21.30'; // 2022
    PrvConstant[1].PrvRate7 := '21.30'; // 2022

   {//20230304
    // from 5001-c
    PrvConstant[0].PrvRate8 := '21.80'; // 2022
    PrvConstant[1].PrvRate8 := '21.80'; // 2022
   }
    // from 5001-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // from 5001-c
    PrvConstant[0].PrvBracketTax2 := 3405.79; // 2022  Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2 := 3405.79; // 2022  Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);

    // from 5001-c
    PrvConstant[0].PrvBracketTax3 := 9082.10; // 2022  Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 9082.10; // 2022  Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);

    // 20190709
    PrvConstant[0].PrvBracketTax4 := 18796.89; // 2022  Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 18796.89; // 2022  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);

    PrvConstant[0].PrvBracketTax5 := 28749.41; // 2022  Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax5 := 28749.41; // 2022  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907

    PrvConstant[0].PrvBracketTax6 := 39502.19; // 2022  Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax6 := 39502.19; // 2022  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907

    PrvConstant[0].PrvBracketTax7 := 91502.19; // 2022  Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax7 := 91502.19; // 2022  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907

    {//20230304
    PrvConstant[0].PrvBracketTax8 := 198002.19; // 2022  Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax8 := 198002.19; // 2022  Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100); //was tax 4 20150907
    }

    // from 5001-c
    PrvConstant[0].PrvPersAmount := 9803; // 2022
    PrvConstant[1].PrvPersAmount := 9803; // 2022

    // from 5001-pc Line 5808 Age Amount
    PrvConstant[0].PrvAgeNIThreshHold := 76013; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 76013; // 2022

    // from 5001-d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 6258; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 6258; // 2022

    // from 5001-d line 5808
    PrvConstant[0].PrvAgeBaseAmount := 34293; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 34293; // 2022

    // from 5001-c
    PrvConstant[0].PrvSpouseBasicAmount := 8813; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 8813; // 2022

    // from 5001-c
    PrvConstant[0].PrvMaxSpousalAmount := 8011; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 8011; // 2022

    // from 5001-d line 5820
    PrvConstant[0].PrvInfirmDependBase := 9803; // 2022
    PrvConstant[1].PrvInfirmDependBase := 9803; // 2022

    // from 5001-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 3113; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 3113; // 2022

    // from federal s1 or provincial 5001-c line 5836
    PrvConstant[0].PrvMaxPensionAmount := 1000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1000; // 2022

    // from 5001-d line 5840
    PrvConstant[0].PrvCareGvrBase := 18327; // 2022
    PrvConstant[1].PrvCareGvrBase := 18327; // 2022

    // from 5001-d line 5840
    PrvConstant[0].PrvMaxCareGvr := 3113; // 2022
    PrvConstant[1].PrvMaxCareGvr := 3113; // 2022

    // from 5001-s11
    PrvConstant[0].PrvPartEducPerMonth := 60; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 60; // 2022

    // from 5001-s11
    PrvConstant[0].PrvEducPerMonth := 200; // 2022
    PrvConstant[1].PrvEducPerMonth := 200; // 2022

    // from 5001-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5001-c bottom page 1
    PrvConstant[0].PrvMedicalLimit := 2135; // 2022
    PrvConstant[1].PrvMedicalLimit := 2135; // 2022

    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5001-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5001-c bottom page 1
    PrvConstant[0].PrvDonRate1 := 8.7; //vl(PrvConstant[0].PrvRate1); //20221209
    PrvConstant[1].PrvDonRate1 := 8.7; //vl(PrvConstant[1].PrvRate1);

    // from 5001-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 21.8; //vl(PrvConstant[0].PrvRate5);  //20221209
    PrvConstant[1].PrvDonRate2 := 21.8; //vl(PrvConstant[1].PrvRate5);

    // 20160119 ------------------------------------------------
    // from 5001-d Line 6152
    PrvConstant[0].PrvDivRate := '3.2'; // 2022  //20221214
    PrvConstant[1].PrvDivRate := '3.2'; // 2022
    // from 5001-d Line 6152
    PrvConstant[0].PrvDivRateBig := '6.3'; // 2022
    PrvConstant[1].PrvDivRateBig := '6.3'; // 2022
    // -----------------------------------------------------------
    // from 5001-c top page 2
    PrvConstant[0].PrvOverseasRate := 51.3; // 2022
    PrvConstant[1].PrvOverseasRate := 51.3; // 2022

    // from 5001-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 58; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 58; // 2022

    // from 5001-d line 5844
    PrvConstant[0].PrvMaxDisability := 6615; // 2022
    PrvConstant[1].PrvMaxDisability := 6615; // 2022

    // from 5001-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 3113; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 3113; // 2022

    // from 5001-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2646; // 2022
    PrvConstant[1].PrvDisabSuplBase := 2646; // 2022

    // from 5001-pc Line 5833
    PrvConstant[0].PrvMaxAdoption := 13230; // 2022  //20221215
    PrvConstant[1].PrvMaxAdoption := 13230; // 2022
  end; // NL

  If Prv = 'SK' then
  // ----------------------------------------------------------
  begin
    Cpi := 1.017;
    // from 5008-c
    PrvConstant[0].PrvBracket1 := 46773; // 2022
    PrvConstant[1].PrvBracket1 := 46773; // 2022

    // from 5008-c
    PrvConstant[0].PrvBracket2 := 133638; // 2022
    PrvConstant[1].PrvBracket2 := 133638; // 2022

    // from 5008-c
    PrvConstant[0].PrvRate1 := '10.50'; // 2022
    PrvConstant[1].PrvRate1 := '10.50'; // 2022

    // from 5008-c
    PrvConstant[0].PrvRate2 := '12.50'; // 2022
    PrvConstant[1].PrvRate2 := '12.50'; // 2022

    // from 5008-c
    PrvConstant[0].PrvRate3 := '14.50'; // 2022
    PrvConstant[1].PrvRate3 := '14.50'; // 2022

    // from 5008-c
    PrvConstant[0].PrvBracketTax1 := 0; // 2022
    PrvConstant[1].PrvBracketTax1 := 0; // 2022

    // from 5008-c
    PrvConstant[0].PrvBracketTax2 := 4911.17;  //2022  Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2 := 4911.17;  //2022  Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);

    // from 5008-c
    PrvConstant[0].PrvBracketTax3 := 15769.29; // 2022   Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 15769.29; // 2022   Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);

    // from 5008-c
    PrvConstant[0].PrvPersAmount := 16615; // 2022
    PrvConstant[1].PrvPersAmount := 16615; // 2022

    // 5008pc Line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 71417; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 71417; // 2022

    // 5008d Line 5808
    PrvConstant[0].PrvMaxAgeAmount := 5061; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 5061; // 2022
    // 5008d Line 5808
    PrvConstant[0].PrvAgeBaseAmount := 37677; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 37677; // 2022

    // from 5008-c
    PrvConstant[0].PrvSpouseBasicAmount := 18277; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 18277; // 2022

    // from 5008-c
    PrvConstant[0].PrvMaxSpousalAmount := 16615; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 16615; // 2022

    // from 5008-d Line 5820
    PrvConstant[0].PrvInfirmDependBase := 16734; // 2022
    PrvConstant[1].PrvInfirmDependBase := 16734; // 2022

    // from 5008-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 9789; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 9789; // 2022

    // from 5008-c Line 5836 from fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount := 1000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1000; // 2022

    // from 5008-d Line 5840
    PrvConstant[0].PrvCareGvrBase := 26506; // 2022
    PrvConstant[1].PrvCareGvrBase := 26506; // 2022

    // from 5008-d Line 5840
    PrvConstant[0].PrvMaxCareGvr := 9559; // 2022
    PrvConstant[1].PrvMaxCareGvr := 9559; // 2022

    // from 5008-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2022
    PrvConstant[1].PrvEducPerMonth := 400; // 2022

    // from 5008-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2022

    // from 5008-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5008-c
    PrvConstant[0].PrvMedicalLimit := 2345; // 2022
    PrvConstant[1].PrvMedicalLimit := 2345; // 2022

    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5008-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5008-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // 5008c
    PrvConstant[0].PrvDonRate2 := vl(PrvConstant[0].PrvRate3); // 2022 // 14.75;
    PrvConstant[1].PrvDonRate2 := vl(PrvConstant[1].PrvRate3); // 2022 // 14.75;

    // 5008d Line 6152
    PrvConstant[0].PrvDivRate := '1.695'; //'2.105'; // 20221215
    PrvConstant[1].PrvDivRate := '1.695'; // 2022
    // 5008d Line 6152
    PrvConstant[0].PrvDivRateBig := '11'; // 2022
    PrvConstant[1].PrvDivRateBig := '11'; // 2022

    // from 5008-c top page 2
    PrvConstant[0].PrvOverseasRate := 50; // 2022
    PrvConstant[1].PrvOverseasRate := 50; // 2022

    // from 5008-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 50; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 50; // 2022

    // from 5008-d line 5848
    PrvConstant[0].PrvMaxDisability := 9789; // 2022
    PrvConstant[1].PrvMaxDisability := 9789; // 2022

    // from 5008-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 9559; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 9559; // 2022

    // from 5008-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2867; // 2022
    PrvConstant[1].PrvDisabSuplBase := 2867; // 2022

    PrvConstant[0].PrvMaxAdoption := 0; // 2022
    PrvConstant[1].PrvMaxAdoption := 0; // 2022

  end; // sk

  If Prv = 'NT' then
  // ---------------------------------------------------------
  begin
    Cpi := 1.017;
    // from 5012-c
    PrvConstant[0].PrvBracket1 := 45462; // 2022
    PrvConstant[1].PrvBracket1 := 45462; // 2022

    // from 5012-c
    PrvConstant[0].PrvBracket2 := 90927; // 2022
    PrvConstant[1].PrvBracket2 := 90927; // 2022

    // from 5012-c
    PrvConstant[0].PrvBracket3 := 147826; // 2022 //20221211
    PrvConstant[1].PrvBracket3 := 147826; // 2022

    // from 5012-c
    PrvConstant[0].PrvRate1 := '5.9'; // 2022
    PrvConstant[1].PrvRate1 := '5.9'; // 2022

    // from 5012-c
    PrvConstant[0].PrvRate2 := '8.6'; // 2022
    PrvConstant[1].PrvRate2 := '8.6'; // 2022

    // from 5012-c
    PrvConstant[0].PrvRate3 := '12.2'; // 2022
    PrvConstant[1].PrvRate3 := '12.2'; // 2022

    // from 5012-c
    PrvConstant[0].PrvRate4 := '14.05'; // 2022
    PrvConstant[1].PrvRate4 := '14.05'; // 2022

    // from 5012-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // from 5012-c
    PrvConstant[0].PrvBracketTax2 := 2682.26;  //2022  Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2 := 2682.26;  //2022  Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 *      vl(PrvConstant[1].PrvRate1) / 100);

    // from 5012-c
    PrvConstant[0].PrvBracketTax3 := 6592.25;  //2022  Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3 := 6592.25;  //2022  Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);

    // from 5012-c
    PrvConstant[0].PrvBracketTax4 := 13533.93;   //2022  Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4 := 13533.93;   //2022  Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);

    // from 5012-c
    PrvConstant[0].PrvPersAmount := 15609; // 2022
    PrvConstant[1].PrvPersAmount := 15609; // 2022

    // guide nt 5012-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 90726; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 90726; // 2022

    // from 5012-d Line 5808 Age amount
    PrvConstant[0].PrvMaxAgeAmount := 7635; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 7635; // 2022

    // from 5012-d Line 5808 Age amount
    PrvConstant[0].PrvAgeBaseAmount := 39826; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 39826; // 2022

    // form 5012-c
    PrvConstant[0].PrvSpouseBasicAmount := 15609; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 15609; // 2022

    PrvConstant[0].PrvMaxSpousalAmount := 15609; // 2022 //20221209
    PrvConstant[1].PrvMaxSpousalAmount := 15609; // 2022

    // from 5012-d line 5820
    PrvConstant[0].PrvInfirmDependBase := 12515; // 2022
    PrvConstant[1].PrvInfirmDependBase := 12515; // 2022

    // from 5012-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 5174; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 5174; // 2022

    // from 5012-c line 5836 or fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount := 1000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1000; // 2022

    // from 5012-d Line 5840
    PrvConstant[0].PrvCareGvrBase := 22844; // 2022
    PrvConstant[1].PrvCareGvrBase := 22844; // 2022

    // from 5012-d Line 5840
    PrvConstant[0].PrvMaxCareGvr := 5174; // 2022
    PrvConstant[1].PrvMaxCareGvr := 5174; // 2022

    // from  5012-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2022

    // from  5012-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2022
    PrvConstant[1].PrvEducPerMonth := 400; // 2022

    // from  5012-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5012-c
    PrvConstant[0].PrvMedicalLimit := 2479; // 2022
    PrvConstant[1].PrvMedicalLimit := 2479; // 2022

    // 5012-d or 5012-pc Line 5872
    PrvConstant[0].PrvMaxMedicalExpense := 5000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 5000; // 2022

    // from 5012-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5012-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5012-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 14.05; // 2022
    PrvConstant[1].PrvDonRate2 := 14.05; // 2022

    // from 5012-d Line 6152
    PrvConstant[0].PrvDivRate := '6'; // 2022
    PrvConstant[1].PrvDivRate := '6'; // 2022
    // from 5012-d Line 6152
    PrvConstant[0].PrvDivRateBig := '11.5'; // 2022
    PrvConstant[1].PrvDivRateBig := '11.5'; // 2022

    // from 5012-c top page 2
    PrvConstant[0].PrvOverseasRate := 45; // 2022
    PrvConstant[1].PrvOverseasRate := 45; // 2022

    // from 5012-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 45; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 45; // 2022

    // from 5012-d line 5848
    PrvConstant[0].PrvMaxDisability := 12658; // 2022
    PrvConstant[1].PrvMaxDisability := 12658; // 2022

    // from 5012-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 5174; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 5174; // 2022

    // from 5012-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 3030; // 2022
    PrvConstant[1].PrvDisabSuplBase := 3030; // 2022

    PrvConstant[0].PrvMaxAdoption := 0; // 2022
    PrvConstant[1].PrvMaxAdoption := 0; // 2022

  end; // NT

  If Prv = 'NB' then
  // ----------------------------------------------------------
  begin
    Cpi := 1.017;

    // ?  two new brackes wetre introduced in 2015. Not implemented in this release
    // from 5004-c
    PrvConstant[0].PrvBracket1 := 44877; // 2022
    PrvConstant[1].PrvBracket1 := 44877; // 2022

    // from 5004-c
    PrvConstant[0].PrvBracket2 := 89775; // 2022
    PrvConstant[1].PrvBracket2 := 89775; // 2022

    // from 5004-c
    PrvConstant[0].PrvBracket3 := 145955; // 2022
    PrvConstant[1].PrvBracket3 := 145955; // 2022

    // from 5004-c
    // -----  //20151102
    PrvConstant[0].PrvBracket4 := 166280; // 2022
    PrvConstant[1].PrvBracket4 := 166280; // 2022
    {
      // from 5004-c
      PrvConstant[0].PrvBracket5       := 250000; //2022
      PrvConstant[1].PrvBracket5       := 250000; //2022
      //-----
    }
    // New rate missing 2020?

    // from 5004-c
    PrvConstant[0].PrvRate1 := '9.40'; // 2022
    PrvConstant[1].PrvRate1 := '9.40'; // 2022

    // from 5004-c
    PrvConstant[0].PrvRate2 := '14.82'; // 2022
    PrvConstant[1].PrvRate2 := '14.82'; // 2022

    // from 5004-c
    PrvConstant[0].PrvRate3 := '16.52'; // 2022
    PrvConstant[1].PrvRate3 := '16.52'; // 2022

    // from 5004-c
    PrvConstant[0].PrvRate4 := '17.84'; // 2022
    PrvConstant[1].PrvRate4 := '17.84'; // 2022

    // -- 20151102
    // from 5004-c
    PrvConstant[0].PrvRate5 := '20.30'; // 2022
    PrvConstant[1].PrvRate5 := '20.30'; // 2022

    // from 5004-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // from 5004-c
    PrvConstant[0].PrvBracketTax2 := 4219.38; // 2022  Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2 := 4219.38; // 2022  Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);

    // from 5004-c
    PrvConstant[0].PrvBracketTax3 := 10871.78; // 2022  //2019 //Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 10871.78; // 2022  //Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);

    // from 5004-c
    PrvConstant[0].PrvBracketTax4 := 20152.72; // 2022  Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 20152.72; // 2022  Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate3)/100);

    // from 5004-c
    // 20151102
    PrvConstant[0].PrvBracketTax5 := 23778.70; // 2022   Round(PrvConstant[0].PrvBracketTax4+(PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate4)/100);
    PrvConstant[1].PrvBracketTax5 := 23778.70; // 2022   Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate4)/100);

    // from 5004-c
    PrvConstant[0].PrvPersAmount := 11720; // 2022
    PrvConstant[1].PrvPersAmount := 11720; // 2022

    // guide nt 5004-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 74535; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 74535; // 2022

    // from 5004-d Line 5808 Age amount
    PrvConstant[0].PrvMaxAgeAmount := 5282; //2022
    PrvConstant[1].PrvMaxAgeAmount := 5282; //2022

    // from 5004-d Line 5808 Age amount
    PrvConstant[0].PrvAgeBaseAmount := 39321; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 39321; // 2022

    // form 5004-c
    PrvConstant[0].PrvSpouseBasicAmount := 10105; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 10105; // 2022

    PrvConstant[0].PrvMaxSpousalAmount := 9186; //20221216 9186; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 9186; //9186; // 2022

    // from 5004-d line 5820
    PrvConstant[0].PrvInfirmDependBase := 12357; // 2022
    PrvConstant[1].PrvInfirmDependBase := 12357; // 2022

    // from 5004-d Line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 5109; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 5109; // 2022

    // from 5004-c line 5836 or fed s1 line 314
    PrvConstant[0].PrvMaxPensionAmount := 1000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1000; // 2022

    // from 5004-d Line 5840
    PrvConstant[0].PrvCareGvrBase := 22555; // 2022
    PrvConstant[1].PrvCareGvrBase := 22555; // 2022

    // from 5004-d Line 5840
    PrvConstant[0].PrvMaxCareGvr := 5108; // 2022
    PrvConstant[1].PrvMaxCareGvr := 5108; // 2022

    // from  5004-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2022

    // from  5004-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2022
    PrvConstant[1].PrvEducPerMonth := 400; // 2022

    // from  5004-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5004-c
    PrvConstant[0].PrvMedicalLimit := 2448; //2022
    PrvConstant[1].PrvMedicalLimit := 2448; //2022

    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5004-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5004-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5004-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 17.95; // 2022
    PrvConstant[1].PrvDonRate2 := 17.95; // 2022

    // from 5004-d Line 6152
    PrvConstant[0].PrvDivRate := '2.75'; // 2022
    PrvConstant[1].PrvDivRate := '2.75'; // 2022
    // from 5004-d Line 6152
    PrvConstant[0].PrvDivRateBig := '14'; // 2022
    PrvConstant[1].PrvDivRateBig := '14'; // 2022

    // from 5004-c top page 2
    PrvConstant[0].PrvOverseasRate := 57; // 2022
    PrvConstant[1].PrvOverseasRate := 57; // 2022

    // from 5004-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 57; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 57; // 2022

    // from 5004-d line 5848
    PrvConstant[0].PrvMaxDisability := 8757; // 2022
    PrvConstant[1].PrvMaxDisability := 8757; // 2022

    // from 5004-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 5109; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 5109; // 2022

    // from 5004-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2922; // 2022
    PrvConstant[1].PrvDisabSuplBase := 2922; // 2022

    PrvConstant[0].PrvMaxAdoption := 0; // 2022
    PrvConstant[1].PrvMaxAdoption := 0; // 2022

  end; // NB

  If Prv = 'PE' then

  begin
    Cpi := 1.000;
    // from 5002-c
    PrvConstant[0].PrvBracket1 := 31984; // 2022
    PrvConstant[1].PrvBracket1 := 31984; // 2022

    // from 5002-c
    PrvConstant[0].PrvBracket2 := 63969; // 2022
    PrvConstant[1].PrvBracket2 := 63969; // 2022

    // from 5002-c
    PrvConstant[0].PrvRate1 := '9.8'; // 2022
    PrvConstant[1].PrvRate1 := '9.8'; // 2022

    // from 5002-c
    PrvConstant[0].PrvRate2 := '13.8'; // 2022
    PrvConstant[1].PrvRate2 := '13.8'; // 2022

    // from 5002-c
    PrvConstant[0].PrvRate3 := '16.7'; // 2022
    PrvConstant[1].PrvRate3 := '16.7'; // 2022

    // from 5002-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // from 5002-c
    PrvConstant[0].PrvBracketTax2 := 3134.43; //2022    Round(PrvConstant[0].PrvBracketTax1+PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1)/100);
    PrvConstant[1].PrvBracketTax2 := 3134.43; //2022    Round(PrvConstant[1].PrvBracketTax1+PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1)/100);

    // from 5002-c
    PrvConstant[0].PrvBracketTax3 := 7548.36; //2022   Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 7548.36; //2022   Round(PrvConstant[1].PrvBracketTax2+(PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2)/100);

    // from 5002-c
    PrvConstant[0].PrvPersAmount := 11250; // 2022
    PrvConstant[1].PrvPersAmount := 11250; // 2022

    // from 5002-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 53112; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 53112; // 2022

    // from 5002-d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 3764; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 3764; // 2022

    // from 5002-d line 5808
    PrvConstant[0].PrvAgeBaseAmount := 28019; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 28019; // 2022

    // NOTE  **** 5816 elig dependant is hardcoded in S5prv
    // it does not follow the spousal parameters. Hardcode each year
    // from 5002-c
    PrvConstant[0].PrvSpouseBasicAmount := 10510;  //2022
    PrvConstant[1].PrvSpouseBasicAmount := 10510;  //2022

    // from 5002-c line 5815
    PrvConstant[0].PrvMaxSpousalAmount := 9555; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 9555; // 2022

    // from 5002-d line 5820
    PrvConstant[0].PrvInfirmDependBase := 7412; // 2022
    PrvConstant[1].PrvInfirmDependBase := 7412; // 2022

    // from 5002-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 2446; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 2446; // 2022

    // from 5002-c line 5839
    PrvConstant[0].PrvMaxPensionAmount := 1000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1000; // 2022

    // from 5002-d line 5840
    PrvConstant[0].PrvCareGvrBase := 14399; // 2022
    PrvConstant[1].PrvCareGvrBase := 14399; // 2022

    // from 5002-d line 5840
    PrvConstant[0].PrvMaxCareGvr := 2446; // 2022
    PrvConstant[1].PrvMaxCareGvr := 2446; // 2022

    // from 5002-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2022

    // from 5002-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2022
    PrvConstant[1].PrvEducPerMonth := 400; // 2022

    // from 5002-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022
    // from 5002-c
    PrvConstant[0].PrvMedicalLimit := 1678; // 2022
    PrvConstant[1].PrvMedicalLimit := 1678; // 2022

    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5002-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5002-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5002-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 16.7; // 2022
    PrvConstant[1].PrvDonRate2 := 16.7; // 2022

    // from 5002-d Line 6152
    PrvConstant[0].PrvDivRate := '1.30'; // 2022 //20221215
    PrvConstant[1].PrvDivRate := '1.30'; // 2022
    // from 5002-d Line 6152
    PrvConstant[0].PrvDivRateBig := '10.5'; // 2022
    PrvConstant[1].PrvDivRateBig := '10.5'; // 2022

    // from 5002-c top page 2
    PrvConstant[0].PrvOverseasRate := 57.5; // 2022
    PrvConstant[1].PrvOverseasRate := 57.5; // 2022

    // from 5002-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 57.5; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 57.5; // 2022

    // from 5002-d line 5848
    PrvConstant[0].PrvMaxDisability := 6890; // 2022
    PrvConstant[1].PrvMaxDisability := 6890; // 2022

    // from 5002-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 4019; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 4019; // 2022

    // from 5002-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2354; // 2022
    PrvConstant[1].PrvDisabSuplBase := 2354; // 2022

    PrvConstant[0].PrvMaxAdoption := 0; // 2022
    PrvConstant[1].PrvMaxAdoption := 0; // 2022

  end; // pe

  If Prv = 'NU' then  //20211125
  // ----------------------------------------------------------
  begin
    Cpi := 1.015; // 2018
    // from 5014-c
    PrvConstant[0].PrvBracket1 := 47862; // 2022
    PrvConstant[1].PrvBracket1 := 47862; // 2022

    // from 5014-c
    PrvConstant[0].PrvBracket2 := 95724; // 2022
    PrvConstant[1].PrvBracket2 := 95724; // 2022

    // from 5014-c
    PrvConstant[0].PrvBracket3 := 155625; // 2022
    PrvConstant[1].PrvBracket3 := 155625; // 2022

    // from 5014-c
    PrvConstant[0].PrvRate1 := '4'; // 2022
    PrvConstant[1].PrvRate1 := '4'; // 2022

    // from 5014-c
    PrvConstant[0].PrvRate2 := '7'; // 2022
    PrvConstant[1].PrvRate2 := '7'; // 2022

    // from 5014-c
    PrvConstant[0].PrvRate3 := '9'; // 2022
    PrvConstant[1].PrvRate3 := '9'; // 2022

    // from 5014-c
    PrvConstant[0].PrvRate4 := '11.5'; // 2022
    PrvConstant[1].PrvRate4 := '11.5'; // 2022
    // from 5014-c
    PrvConstant[0].PrvBracketTax1 := 0; // 2022
    PrvConstant[1].PrvBracketTax1 := 0; // 2022

    // from 5014-c
    PrvConstant[0].PrvBracketTax2 := 1914.48;   //2022 Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2 := 1914.48;   //2022 Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);

    // from 5014-c
    PrvConstant[0].PrvBracketTax3 := 5264.82; //2022    Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3 := 5264.82; //2022    Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);

    // from 5014-c
    PrvConstant[0].PrvBracketTax4 := 10655.91;  //2022  Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4 := 10655.91;  //2022  Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);

    // from 5014-c
    PrvConstant[0].PrvPersAmount := 16862; // 2022
    PrvConstant[1].PrvPersAmount := 16862; // 2022

    // from 5014-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 111586; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 111586; // 2022

    // from 5014-d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 10764; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 10764; // 2022

    // from 5014-d line 5808
    PrvConstant[0].PrvAgeBaseAmount := 39826; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 39826; // 2022

    // from 5014-c
    PrvConstant[0].PrvSpouseBasicAmount := 16862; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 16862; // 2022

    // from 5014-n Line 5812
    PrvConstant[0].PrvMaxSpousalAmount := 16862; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 16862; // 2022

    // from 5014-d line 5820
    PrvConstant[0].PrvInfirmDependBase := 12515; // 2022
    PrvConstant[1].PrvInfirmDependBase := 12515; // 2022

    // from 5014-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 5174; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 5174; // 2022

    // from 5014-c line 5836
    PrvConstant[0].PrvMaxPensionAmount := 2000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 2000; // 2022

    // from 5014-d line 5840
    PrvConstant[0].PrvCareGvrBase := 22844; // 2022
    PrvConstant[1].PrvCareGvrBase := 22844; // 2022

    // from 5014-d line 5840
    PrvConstant[0].PrvMaxCareGvr := 5174; // 2022
    PrvConstant[1].PrvMaxCareGvr := 5174; // 2022

    // 20180202
    // from 5014-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2022

    // from 5014-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2022
    PrvConstant[1].PrvEducPerMonth := 400; // 2022
    // -------------------
    // from 5014-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5014-c
    PrvConstant[0].PrvMedicalLimit := 2479; // 2022
    PrvConstant[1].PrvMedicalLimit := 2479; // 2022

    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5014-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5014-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5014-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 11.5; // 2022
    PrvConstant[1].PrvDonRate2 := 11.5; // 2022

    // from 5014-d Line 6152
    PrvConstant[0].PrvDivRate := '2.61'; // 2022
    PrvConstant[1].PrvDivRate := '2.61'; // 2022
    // from 5014-d Line 6152
    PrvConstant[0].PrvDivRateBig := '5.51'; // 2022
    PrvConstant[1].PrvDivRateBig := '5.51'; // 2022

    // from 5014-c top page 2
    PrvConstant[0].PrvOverseasRate := 45; // 2022
    PrvConstant[1].PrvOverseasRate := 45; // 2022

    // from 5014-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 45; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 45; // 2022

    // from 5014-d line 5848
    PrvConstant[0].PrvMaxDisability := 14352; // 2022
    PrvConstant[1].PrvMaxDisability := 14352; // 2022

    // from 5014-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 5174; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 5174; // 2022

    // from 5014-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 3030; // 2022
    PrvConstant[1].PrvDisabSuplBase := 3030; // 2022

    PrvConstant[0].PrvMaxAdoption := 0; // 2022
    PrvConstant[1].PrvMaxAdoption := 0; // 2022

  end; // nu

  If Prv = 'YT' then  //11
  // ----------------------------------------------------------
  begin
    Cpi := 1.017;

    // ?  New tax bracket over $500000 Not implemented in this release
    // from 5011-c
    PrvConstant[0].PrvBracket1 := 50197; // 2022
    PrvConstant[1].PrvBracket1 := 50197; // 2022

    // from 5011-c
    PrvConstant[0].PrvBracket2 := 100392; // 2022
    PrvConstant[1].PrvBracket2 := 100392; // 2022

    // from 5011-c
    PrvConstant[0].PrvBracket3 := 155625; // 2022
    PrvConstant[1].PrvBracket3 := 155625; // 2022

    // from 5011-c
    PrvConstant[0].PrvBracket4 := 500000; // 2022
    PrvConstant[1].PrvBracket4 := 500000; // 2022

    // from 5011-c
    PrvConstant[0].PrvRate1 := '6.40'; // 2022
    PrvConstant[1].PrvRate1 := '6.40'; // 2022

    // from 5011-c
    PrvConstant[0].PrvRate2 := '9.00'; // 2022
    PrvConstant[1].PrvRate2 := '9.00'; // 2022

    // from 5011-c
    PrvConstant[0].PrvRate3 := '10.90'; // 2022
    PrvConstant[1].PrvRate3 := '10.90'; // 2022

    // from 5011-c
    PrvConstant[0].PrvRate4 := '12.80'; // 2022
    PrvConstant[1].PrvRate4 := '12.80'; // 2022

    // from 5011-c
    PrvConstant[0].PrvRate5 := '15'; // 2022
    PrvConstant[1].PrvRate4 := '15'; // 2022

    // from 5011-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // from 5011-c
    PrvConstant[0].PrvBracketTax2 := 3212.61; // 2022     Round(PrvConstant[0].PrvBracketTax1 + PrvConstant[0].PrvBracket1 * vl(PrvConstant[0].PrvRate1) / 100);
    PrvConstant[1].PrvBracketTax2 := 3212.61; // 2022     Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);

    // from 5011-c
    PrvConstant[0].PrvBracketTax3 := 7730.16; // 2022     Round(PrvConstant[0].PrvBracketTax2 + (PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2) / 100);
    PrvConstant[1].PrvBracketTax3 := 7730.16; // 2022     Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);

    // from 5011c
    PrvConstant[0].PrvBracketTax4 := 13750.56; // 2022    Round(PrvConstant[0].PrvBracketTax3 + (PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3) / 100);
    PrvConstant[1].PrvBracketTax4 := 13750.56; // 2022    Round(PrvConstant[1].PrvBracketTax3 + (PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3) / 100);

    PrvConstant[0].PrvBracketTax5 := 57830.56; // 2022    Round(PrvConstant[0].PrvBracketTax4 + (PrvConstant[0].PrvBracket4 - PrvConstant[0].PrvBracket3) * vl(PrvConstant[0].PrvRate4) / 100);
    PrvConstant[1].PrvBracketTax5 := 57830.56; // 2022    Round(PrvConstant[1].PrvBracketTax4 + (PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4) / 100);

    // from 5011-c  //federal 30000
    PrvConstant[0].PrvPersAmount := 14398; // 2022
    PrvConstant[1].PrvPersAmount := 14398; // 2022

    // from 5011-pc line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 92479; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 92479; // 2022

    // from 5011-d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 7898; // 2022
    PrvConstant[1].PrvMaxAgeAmount := 7898; // 2022

    // from 5011-d line 5808
    PrvConstant[0].PrvAgeBaseAmount := 39826; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 39826; // 2022

    // from 5011-c
    PrvConstant[0].PrvSpouseBasicAmount := 14398; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 14398; // 2022

    // from 5011-n Line 5812
    PrvConstant[0].PrvMaxSpousalAmount := 14398; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 14398; // 2022

    // from 5011-d line 5820  //NOT USED in logic  As in federal
    PrvConstant[0].PrvInfirmDependBase := 17670; // 2022
    PrvConstant[1].PrvInfirmDependBase := 17670; // 2022

    // from 5011-d line 5820  //NOT USED in logic  As in federal
    PrvConstant[0].PrvMaxInfirmDependAmount := 7525; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 7525; // 2022

    // from 5011-c line 5836
    PrvConstant[0].PrvMaxPensionAmount := 2000; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 2000; // 2022

    // from 5011-d line 5840  //NOT USED in logic  As in federal
    PrvConstant[0].PrvCareGvrBase := 25195; // 2022
    PrvConstant[1].PrvCareGvrBase := 25195; // 2022

    // from 5011-d line 5840
    PrvConstant[0].PrvMaxCareGvr := 4732; // 2022
    PrvConstant[1].PrvMaxCareGvr := 4732; // 2022

    // from 5011-s11
    PrvConstant[0].PrvPartEducPerMonth := 120; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 120; // 2022

    // from 5011-s11
    PrvConstant[0].PrvEducPerMonth := 400; // 2022
    PrvConstant[1].PrvEducPerMonth := 400; // 2022

    // from 5011-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5011-c
    PrvConstant[0].PrvMedicalLimit := 2479; // 2022
    PrvConstant[1].PrvMedicalLimit := 2479; // 2022

    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5011-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5011-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5011-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 12.80; // 2022
    PrvConstant[1].PrvDonRate2 := 12.80; // 2022
    // from 5011-d Line 6152
    PrvConstant[0].PrvDivRate := '0.67'; //2022
    PrvConstant[1].PrvDivRate := '0.67'; //2022
    // from 5011-d Line 6152
    PrvConstant[0].PrvDivRateBig := '12.02'; // 2022
    PrvConstant[1].PrvDivRateBig := '12.02'; // 2022

    // from 5011-c top page 2
    PrvConstant[0].PrvOverseasRate := 42.67; // 2022
    PrvConstant[1].PrvOverseasRate := 42.67; // 2022

    // from 5011-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 42.67; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 42.67; // 2022

    // from 5011-d line 5848
    PrvConstant[0].PrvMaxDisability := 8870; // 2022
    PrvConstant[1].PrvMaxDisability := 8870; // 2022

    // from 5011-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 5174; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 5174; // 2022

    // from 5011-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 3030; // 2022
    PrvConstant[1].PrvDisabSuplBase := 3030; // 2022

    PrvConstant[0].PrvMaxAdoption := 17131; // 2022
    PrvConstant[1].PrvMaxAdoption := 17131; // 2022

  end; // yt

  If Prv = 'NS' then
  begin
    Cpi := 1.000;
    // from 5003-c
    PrvConstant[0].PrvBracket1 := 29590; // 2022
    PrvConstant[1].PrvBracket1 := 29590; // 2022

    // from 5003-c
    PrvConstant[0].PrvBracket2 := 59180; // 2022
    PrvConstant[1].PrvBracket2 := 59180; // 2022

    // from 5003-c
    PrvConstant[0].PrvBracket3 := 93000; // 2022
    PrvConstant[1].PrvBracket3 := 93000; // 2022

    // from 5003-c
    PrvConstant[0].PrvBracket4 := 150000; // 2022
    PrvConstant[1].PrvBracket4 := 150000; // 2022

    // from 5003-c
    PrvConstant[0].PrvRate1 := '8.79'; // 2022
    PrvConstant[1].PrvRate1 := '8.79'; // 2022

    // from 5003-c
    PrvConstant[0].PrvRate2 := '14.95'; // 2022
    PrvConstant[1].PrvRate2 := '14.95'; // 2022

    // from 5003-c
    PrvConstant[0].PrvRate3 := '16.67'; // 2022
    PrvConstant[1].PrvRate3 := '16.67'; // 2022

    // from 5003-c
    PrvConstant[0].PrvRate4 := '17.5'; // 2022
    PrvConstant[1].PrvRate4 := '17.5'; // 2022
    // from 5003-c
    PrvConstant[0].PrvRate5 := '21'; // 2022
    PrvConstant[1].PrvRate5 := '21'; // 2022

    // from 5003-c
    PrvConstant[0].PrvBracketTax1 := 0;
    PrvConstant[1].PrvBracketTax1 := 0;

    // from 5003-c
    PrvConstant[0].PrvBracketTax2 := 2600.96; //2022
    PrvConstant[1].PrvBracketTax2 := 2600.96; //2022   Round(PrvConstant[1].PrvBracketTax1 + PrvConstant[1].PrvBracket1 * vl(PrvConstant[1].PrvRate1) / 100);

    PrvConstant[0].PrvBracketTax3 := 7024.67; //2022       Round(PrvConstant[0].PrvBracketTax2+(PrvConstant[0].PrvBracket2 - PrvConstant[0].PrvBracket1) * vl(PrvConstant[0].PrvRate2)/100);
    PrvConstant[1].PrvBracketTax3 := 7024.67; //2022       Round(PrvConstant[1].PrvBracketTax2 + (PrvConstant[1].PrvBracket2 - PrvConstant[1].PrvBracket1) * vl(PrvConstant[1].PrvRate2) / 100);

    // from 5010-c
    PrvConstant[0].PrvBracketTax4 := 12662.46; // 2022     Round(PrvConstant[0].PrvBracketTax3+(PrvConstant[0].PrvBracket3 - PrvConstant[0].PrvBracket2) * vl(PrvConstant[0].PrvRate3)/100);
    PrvConstant[1].PrvBracketTax4 := 12662.46; // 2022     Round(PrvConstant[1].PrvBracketTax3+(PrvConstant[1].PrvBracket3 - PrvConstant[1].PrvBracket2) * vl(PrvConstant[1].PrvRate3)/100);

    // from 5010-c
    PrvConstant[0].PrvBracketTax5 := 22637.46; // 2022     Round(GetTaxOnBase(PrvConstant[0].PrvBracket4,PrvConstant[0].PrvBracket3,Vl(PrvConstant[0].PrvRate4),PrvConstant[0].PrvBracketTax4));
    PrvConstant[1].PrvBracketTax5 := 22637.46; // 2022     Round(PrvConstant[1].PrvBracketTax4+(PrvConstant[1].PrvBracket4 - PrvConstant[1].PrvBracket3) * vl(PrvConstant[1].PrvRate4)/100);

    // from 5003-c
    PrvConstant[0].PrvPersAmount := 8481; // 2022
    PrvConstant[1].PrvPersAmount := 8481; // 2022

    // from 5003-n line 5808
    PrvConstant[0].PrvAgeNIThreshHold := 58437; // 2022
    PrvConstant[1].PrvAgeNIThreshHold := 58437; // 2022

    // from 5003-d line 5808
    PrvConstant[0].PrvMaxAgeAmount := 4141; // 2022 //20221211
    PrvConstant[1].PrvMaxAgeAmount := 4141; // 2022

    // from 5003-d line 5808
    PrvConstant[0].PrvAgeBaseAmount := 30828; // 2022
    PrvConstant[1].PrvAgeBaseAmount := 30828; // 2022

    // from 5003-c
    PrvConstant[0].PrvSpouseBasicAmount := 9329; // 2022
    PrvConstant[1].PrvSpouseBasicAmount := 9329; // 2022

    // from 5003-c
    PrvConstant[0].PrvMaxSpousalAmount := 11841; // 2022
    PrvConstant[1].PrvMaxSpousalAmount := 11841; // 2022

    // from 5003-d line 5820
    PrvConstant[0].PrvInfirmDependBase := 11841; // 2022
    PrvConstant[1].PrvInfirmDependBase := 11841; // 2022

    // from 5003-d line 5820
    PrvConstant[0].PrvMaxInfirmDependAmount := 2798; // 2022
    PrvConstant[1].PrvMaxInfirmDependAmount := 2798; // 2022

    // from 5003-c line 5836
    PrvConstant[0].PrvMaxPensionAmount := 1173; // 2022
    PrvConstant[1].PrvMaxPensionAmount := 1173; // 2022

    // from 5003-d line 5840
    PrvConstant[0].PrvCareGvrBase := 18575; // 2022
    PrvConstant[1].PrvCareGvrBase := 18575; // 2022

    // from 5003-d line 5840
    PrvConstant[0].PrvMaxCareGvr := 4898; // 2022
    PrvConstant[1].PrvMaxCareGvr := 4898; // 2022

    // from 5003-s11
    PrvConstant[0].PrvPartEducPerMonth := 60; // 2022
    PrvConstant[1].PrvPartEducPerMonth := 60; // 2022

    // from 5003-s11
    PrvConstant[0].PrvEducPerMonth := 200; // 2022
    PrvConstant[1].PrvEducPerMonth := 200; // 2022

    // from 5003-s11
    PrvConstant[0].PrvMaxEducXfer := 5000; // 2022
    PrvConstant[1].PrvMaxEducXfer := 5000; // 2022

    // from 5003-c
    PrvConstant[0].PrvMedicalLimit := 1637; // 2022
    PrvConstant[1].PrvMedicalLimit := 1637; // 2022

    PrvConstant[0].PrvMaxMedicalExpense := 10000; // 2022
    PrvConstant[1].PrvMaxMedicalExpense := 10000; // 2022

    // from 5003-c bottom page 1
    PrvConstant[0].PrvNonRefundRate := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvNonRefundRate := vl(PrvConstant[1].PrvRate1);

    // from 5003-c bottom page 1
    PrvConstant[0].PrvDonRate1 := vl(PrvConstant[0].PrvRate1);
    PrvConstant[1].PrvDonRate1 := vl(PrvConstant[1].PrvRate1);

    // from 5003-c bottom page 1
    PrvConstant[0].PrvDonRate2 := 21; // 2022
    PrvConstant[1].PrvDonRate2 := 21; // 2022

    // from 5003-d Line 6152
    PrvConstant[0].PrvDivRate := '2.99'; // 2022
    PrvConstant[1].PrvDivRate := '2.99'; // 2022
    // from 5003-d Line 6152
    PrvConstant[0].PrvDivRateBig := '8.85'; // 2022
    PrvConstant[1].PrvDivRateBig := '8.85'; // 2022

    // from 5003-c top page 2
    PrvConstant[0].PrvOverseasRate := 57.5; // 2022
    PrvConstant[1].PrvOverseasRate := 57.5; // 2022

    // from 5003-c top page 2
    PrvConstant[0].PrvAmtCarryOverRate := 57.5; // 2022
    PrvConstant[1].PrvAmtCarryOverRate := 57.5; // 2022

    // from 5003-d line 5848

    PrvConstant[0].PrvMaxDisability := 7341; // 2022
    PrvConstant[1].PrvMaxDisability := 7341; // 2022

    // from 5003-d line 5844
    PrvConstant[0].PrvMaxDisabSupl18 := 3449; // 2022
    PrvConstant[1].PrvMaxDisabSupl18 := 3449; // 2022

    // from 5003-d line 5844
    PrvConstant[0].PrvDisabSuplBase := 2346; // 2022
    PrvConstant[1].PrvDisabSuplBase := 2346; // 2022

    PrvConstant[0].PrvMaxAdoption := 0; // 2022
    PrvConstant[1].PrvMaxAdoption := 0; // 2022

  end; // ns

end;




Procedure TAXPLANNER(RetNo: integer; FName: String;FNo: integer);
Var i,DaysInCan:Integer;Prv,MarStatCode,MarStatDescr:String;
    TotInc,NetIncome,TxblIncome,x,PartYear:Real;Age:Integer;
    BracketTax1,BracketTax2,BracketTax3,BracketTax4,BracketTax5,AllBracketsTax:real;
begin
  for i := LnLowBound to LnHighBound do
  begin   Ret[RetNo].Ln[i] := 0; Ret[RetNo].LnSpouse[i] := 0; end;
  Calc(RetNo,'S1');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   // PartYear := Ret[RetNo].PartYear; //DaysInCan / Constant[RY].FullYear;
    If Strings[124]='' then Strings[124]:=IntToStr(Constant[RY].FullYear);
    Strings[1]:=GetT1Year;  //'2002';
    Strings[2]:=FetchElm(RetNo,'PROFILE',2)+' '+FetchElm(RetNo,'PROFILE',5); //first/last
    Strings[3]:=FetchElm(RetNo,'PROFILE',3);  //sin
    Strings[4]:=FetchElm(RetNo,'PROFILE',27);  //birthdate
    Strings[5]:=FetchElm(RetNo,'PROFILE',99);  //Tax province
    Prv:=Strings[5];
    MarStatCode:='6';
    MarStatDescr:='Single';
    If FetchElm(RetNo,'PROFILE',9)>'' then begin MarStatCode:='1';MarStatDescr:='Married';end;
    If FetchElm(RetNo,'PROFILE',79)>'' then begin MarStatCode:='2';MarStatDescr:='Living-Common-Law';end;
    If FetchElm(RetNo,'PROFILE',10)>'' then begin MarStatCode:='3';MarStatDescr:='Widow(er)';end;
    If FetchElm(RetNo,'PROFILE',11)>'' then begin MarStatCode:='4';MarStatDescr:='Divorced)';end;
    If FetchElm(RetNo,'PROFILE',13)>'' then begin MarStatCode:='5';MarStatDescr:='Separated';end;
    If FetchElm(RetNo,'PROFILE',14)>'' then begin MarStatCode:='6';MarStatDescr:='Single';end;
    Strings[6]:=MarStatDescr;  //Tax province
    Age := CalcAge(Strings[4]);
    DaysInCan := MyStrToInt(Strings[124]); //CalcDaysInCan; //MyStrToInt(FetchElm(RetNo,'TAXPL_1',10));
    PartYear := DaysInCan / Constant[RY].FullYear;

    Tv[21]:=Tv[216]*1.25; //dividends
    Tv[7] :=Tv[49]*1.45;
    Tv[25]:=Tv[24] * 50/100;
    Tv[27]:=Tv[26] * 50/100;

    //calc up to txblincome
    TotInc:=Tv[14]+Tv[16]+Tv[17]+Tv[20]+Tv[21]+Tv[7]+Tv[23]+Tv[25]+Tv[27]+Tv[28];
    TotInc:=TotInc+Tv[15]+AddColumns(30,31,1)+Tv[29]
            +AddColumns(32,36,1)+Tv[113]+tv[38];
    Tv[39]:=TotInc;
    Tv[62]:=Tv[39]-(Tv[40]+AddColumns(46,48,1)+Tv[104]+Tv[51]+AddColumns(53,60,1));
    Tv[61]:=CalcCLAWBack(Tv[62],Tv[32],Tv[16]);
    //Tv[107]:=Tv[62]-Tv[61];
    Tv[108]:=Tv[62]-Tv[61];
    NetIncome:=Tv[108];
    Tv[22]:=Tv[30]+Tv[31]+Tv[29];
    Tv[71]:=Tv[63]+Tv[64]+Tv[22]+Tv[65]+Tv[127]+AddColumns(67,70,1);
    Tv[72]:=MaxR(0,Tv[108]-Tv[71]);
    TxblIncome:=Tv[72];
    Ret[RetNo].ln[260]:=Tv[72];
    Tv[94]:=AddColumns(73,81,1)+Tv[100]+AddColumns(83,85,1)
             +AddColumns(89,91,1)+Tv[93];
    Tv[95]:=Tv[94] *16/100;
    Tv[101]:=Tv[95]+Tv[99];
    //calc fed tax
    CalcGrossFedTax(TxblIncome,RY,BracketTax1,BracketTax2,BracketTax3,BracketTax4,AllBracketsTax);
    Tv[158]:=Constant[RY].Bracket1;
    Tv[160]:=vl(Constant[RY].Rate1);
    Tv[161]:=BracketTax1;

    Tv[217]:=Constant[RY].Bracket1;
    Tv[218]:=Constant[RY].Bracket2;
    Tv[219]:=vl(Constant[RY].Rate2);
    Tv[220]:=BracketTax2;

    Tv[221]:=Constant[RY].Bracket2;
    Tv[222]:=Constant[RY].Bracket3;
    Tv[223]:=vl(Constant[RY].Rate3);
    Tv[224] :=BracketTax3;

    Tv[225]:=Constant[RY].Bracket3;
    Tv[226]:=vl(Constant[RY].Rate4);
    Tv[227] :=BracketTax4;

    Tv[215] :=AllBracketsTax;
    //calc prv tax
    InitPrvConstants(Prv);
    For i:=228 to 245 do Tv[i]:=0;
    CalcGrossProvincialTax(TxblIncome,Prv,RY,BracketTax1,BracketTax2,BracketTax3,BracketTax4,BracketTax5,AllBracketsTax);
    Tv[228]:=PrvConstant[RY].PrvBracket1;
    Tv[229]:=vl(PrvConstant[RY].PrvRate1);
    Tv[230] :=BracketTax1;

    Tv[231]:=PrvConstant[RY].PrvBracket1;
    Tv[232]:=PrvConstant[RY].PrvBracket2;
    Tv[233]:=vl(PrvConstant[RY].PrvRate2);
    Tv[234] := BracketTax2;

    Tv[235]:=PrvConstant[RY].PrvBracket2;
    Tv[236]:=PrvConstant[RY].PrvBracket3;
    Tv[237]:=vl(PrvConstant[RY].PrvRate3);
    Tv[238] := BracketTax3;

    Tv[239]:=PrvConstant[RY].PrvBracket3;
    Tv[240]:=PrvConstant[RY].PrvBracket4;
    Tv[241]:=vl(PrvConstant[RY].PrvRate4);
    Tv[242] := BracketTax4;

    Tv[243]:=PrvConstant[RY].PrvBracket4;
    Tv[244]:=vl(PrvConstant[RY].PrvRate5);
    Tv[245] :=BracketTax5;

    Tv[197]:=AllBracketsTax;

    If (Prv='ON') Or (Prv='MB') Or (Prv='NL') Or (Prv='PE') Or (Prv='SK') then
    begin
     for i:=235 to 242 do Tv[i]:=0;
     Tv[243]:= PrvConstant[RY].PrvBracket2;
     Tv[244]:=Vl(PrvConstant[RY].PrvRate3);
    end;

    If (Prv='NB') Or (Prv='NS') Or (Prv='NT') Or (Prv='PE') Or (Prv='SK') then
    begin
     for i:=239 to 242 do Tv[i]:=0;
     Tv[243]:= PrvConstant[RY].PrvBracket3;
     Tv[244]:=Vl(PrvConstant[RY].PrvRate4);
    end;

    //Calc Fed Non-refundable
     Tv[73] := Constant[RY].BasicPersonalAmount * PartYear;
     Tv[74] := CalcAgeEx(Age,NetIncome);
     Tv[75] := CalcSpousalClaim(Tv[10],PartYear);
     Tv[78]:= CalcEmplCPP(RetNo,Tv[14],Strings[4]);
     Tv[79]:=CalcSelfCPP(RetNo,Tv[14],Tv[15],Tv[78],Strings[4]);
     {
     Tv[76]:=0;  //elig dep
     Tv[77]:=0;  //imfirm dep
     Tv[80]:=0;  //EI premiums
     }
     Tv[81]:=CalcPensDed(RetNo,Tv[20]);
     //Tv[100]:=0;  //Caregiver
     //disab self
     If Uppercase(Strings[8]) = 'Y' then
     begin
       If Age >=18 then
         Tv[82] := Constant[RY].MaxDisability * PartYear
       else
         Tv[82] := Constant[RY].MaxDisability * PartYear
          + MaxR(0,Constant[RY].MaxDisabSupl18
           -MaxR(0,0-Constant[RY].DisabSuplBase));
     end
     else
        Tv[82]:=0;  //disab self

     {
     Tv[83]:=0;  //sisab non spouse dep
     Tv[84]:=0;  //st loan
     Tv[85]:=0;  //std loan ded
     Tv[88]:=0;  //tuition fees self
     Tv[86]:=0;  //edu months - full time
     Tv[87]:=0;  //edu months - part time
     Tv[89]:=0; //Educ deduction
     Tv[90]:=0;  //tuition xfer from child
     Tv[91]:=0;  //xfers from spouse
     Tv[92]:=0; //Med receipts
     Tv[93]:=0; //med deduction
     Tv[94]:=0; // total
     Tv[95]:=Tv[94] * Vl(Constant[0].Rate1)/100; //16% of
     Tv[96]:=0; //don receipts
     Tv[97]:=0; //gifts of cap prop
     Tv[98]:=0; //cult gifts
     Tv[99]:=0; //tot credit for donations
     }
     //prv non refunsable
     Tv[246]:=PrvConstant[RY].PrvPersAmount * PartYear;
     //Tv[247]:=CalcAgeExPrv
     Tv[248] := CalcPrvSpousalClaim(Tv[10],PartYear);
     //disab self
     //If FullTONIProvince(RetNo) then
     If Uppercase(Strings[8]) = 'Y' then
     begin
       If Age >=18 then
         Tv[256] := PrvConstant[RY].PrvMaxDisability * PartYear
       else
         Tv[256] := PrvConstant[RY].PrvMaxDisability * PartYear
          + MaxR(0,PrvConstant[RY].PrvMaxDisabSupl18
           -MaxR(0,0-PrvConstant[RY].PrvDisabSuplBase));
     end
     else
        Tv[256]:=0;  //disab self
    Tv[94]:=0;
    Tv[94]:=AddColumns(73,81,1)+Tv[100]+Tv[82]+Tv[83]+Tv[85]
            +AddColumns(89,91,1)+Tv[93];
    Tv[95]:=Tv[94]* Vl(Constant[RY].Rate1)/100; //16% of
    Tv[101]:=Tv[95]+Tv[99];
    //calc the rest
    Tv[214]:=Tv[101]; //non ref
    Tv[213]:=(TaxRec.ActualDividendsNonElig * 1.25) * 13.3333/100
            +(TaxRec.ActualDividendsElig * 1.45) * 18.9655/100;
        //Tv[21]*(13.3333/100);  //div tax credit
    Tv[210]:=Tv[215]-Tv[214]-Tv[213]-Tv[212]-Tv[211]; //basic federal tax

    Tv[125]:=Tv[210]+Tv[209]-Tv[208];
    //Tv[207] min tax
    Tv[206]:=MaxR(Tv[210],Tv[207]);
    Tv[199]:=MaxR(0,Tv[206]-AddColumns(200,203,1)+Tv[204]); //net fed tax

    Tv[198]:=Tv[199];
    Tv[205]:=Tv[197];
    Tv[196]:=Tv[79];  //self empl cpp
    Tv[195]:=Tv[61];      //soc ben repay
    Tv[194]:=Tv[198]+Tv[197]+Tv[196]+Tv[195];      //tot tax payable

    Tv[191]:=AddColumns(81,90,1); //tot refundable credits

    x:=Tv[194]-Tv[191];
    If x<=0 then
    begin
     Tv[192]:=Abs(x);
     Tv[193]:=0;
    end
    Else
    Begin
     Tv[192]:=0;
     Tv[193]:=Abs(x);
    end;
  end;
  SaveTv(RetNo,FName,FNo);

end;

Procedure CalcGrossFedTax(TxblIncome:Real;RY:Integer;
  Var BracketTax1:Real;
  Var BracketTax2:Real;
  Var BracketTax3:Real;
  Var BracketTax4:Real;
  Var AllBracketsTax:Real);

begin
      If TxblIncome <=Constant[RY].Bracket1 then
         BracketTax1:=(MaxR(0,TxblIncome -0)) * (Vl(Constant[RY].Rate1))/100+Constant[RY].BracketTax1
      else
         BracketTax1:=0;

      //Tv[217]:=Constant[RY].Bracket1;
      If (TxblIncome > Constant[RY].Bracket1)
        and (TxblIncome <= Constant[RY].Bracket2) then
        BracketTax2 :=(MaxR(0,TxblIncome-Constant[RY].Bracket1)) * (Vl(Constant[RY].Rate2))/100
                  +Constant[RY].BracketTax2
      else
        BracketTax2:=0;

      //Tv[221]:=Constant[RY].Bracket2;
      If (TxblIncome > Constant[RY].Bracket2)
        and (TxblIncome <= Constant[RY].Bracket3) then
        BracketTax3 :=(MaxR(0,TxblIncome-Constant[RY].Bracket2)) * (Vl(Constant[RY].Rate3))/100
                  +Constant[RY].BracketTax3
      else
        BracketTax3:=0;

      //Tv[225]:=Constant[RY].Bracket3;
      If (TxblIncome > Constant[RY].Bracket3) then
        BracketTax4 :=(MaxR(0,TxblIncome-Constant[RY].Bracket3)) * (Vl(Constant[RY].Rate4))/100
                  +Constant[RY].BracketTax4
      else
        BracketTax4:=0;
      AllBracketsTax:=MaxR(MaxR(BracketTax1,BracketTax2),MaxR(BracketTax3,BracketTax4));
end;

Procedure CalcGrossProvincialTax(TxblIncome:Real;Prv:String;RY:Integer;
  Var BracketTax1:Real;
  Var BracketTax2:Real;
  Var BracketTax3:Real;
  Var BracketTax4:Real;
  Var BracketTax5:Real;
  Var AllBracketsTax:Real);
begin
    //calc provincial Tax
      //bracket 1
     InitPrvConstants(Prv);
     If TxblIncome <= PrvConstant[RY].PrvBracket1 then
      BracketTax1 := (MaxR(0,TxblIncome-0)) * Vl(PrvConstant[RY].PrvRate1)/100+ 0
     else
      BracketTax1:=0;

     //bracket 2
     If (TxblIncome > PrvConstant[RY].PrvBracket1)
      and (TxblIncome <= PrvConstant[RY].PrvBracket2) then
       BracketTax2 := (MaxR(0,TxblIncome-PrvConstant[RY].PrvBracket1)) * Vl(PrvConstant[RY].PrvRate2)/100
              + PrvConstant[RY].PrvBracketTax2
     else
       BracketTax2:=0;

     //bracket 3
     BracketTax3:=0;
     If (Prv='NB') Or (Prv='BC') Or (Prv='NS') Or (Prv='NT') Or (Prv='PE') Or (Prv='SK') then
     begin
       If (TxblIncome > PrvConstant[RY].PrvBracket2)
       and (TxblIncome <= PrvConstant[RY].PrvBracket3) then
       BracketTax3 := (MaxR(0,TxblIncome-PrvConstant[RY].PrvBracket2)) * Vl(PrvConstant[RY].PrvRate3)/100
              + PrvConstant[RY].PrvBracketTax3
      else
       BracketTax3:=0;
     end;
     //bracket 4
     BracketTax4:=0;
     If (Prv='BC') then
     begin
       If (TxblIncome > PrvConstant[RY].PrvBracket3)
        and (TxblIncome <= PrvConstant[RY].PrvBracket4) then
       BracketTax4 := (MaxR(0,TxblIncome-PrvConstant[RY].PrvBracket3)) * Vl(PrvConstant[RY].PrvRate4)/100
               + PrvConstant[RY].PrvBracketTax4
      else
       BracketTax4:=0;
     end;
     //Last bracket greater than
     BracketTax5:=0;
     If Prv = 'BC' then
     begin
     If TxblIncome > PrvConstant[RY].PrvBracket4 then
        BracketTax5:=(MaxR(0,TxblIncome-PrvConstant[RY].PrvBracket4)) * (Vl(PrvConstant[RY].PrvRate5))/100
                  +PrvConstant[RY].PrvBracketTax5;
     end
     Else
     begin
      If (Prv='ON') Or (Prv='MB') Or (Prv='NL') Or (Prv='PE') Or (Prv='SK') then
      begin
       If TxblIncome > PrvConstant[RY].PrvBracket2 then
          BracketTax5 :=(MaxR(0,TxblIncome-PrvConstant[RY].PrvBracket2)) * (Vl(PrvConstant[RY].PrvRate3))/100
                  +PrvConstant[RY].PrvBracketTax3;
      end
      Else
      begin
       If (Prv='NB') Or (Prv='BC') Or (Prv='NS') Or (Prv='NT') Or (Prv='NU') Or(Prv='YT') then
       begin
         If TxblIncome > PrvConstant[RY].PrvBracket3 then
            BracketTax5 :=(MaxR(0,TxblIncome-PrvConstant[RY].PrvBracket3)) * (Vl(PrvConstant[RY].PrvRate4))/100
                  +PrvConstant[RY].PrvBracketTax4;

       end;
      end;
     end;
     AllBracketsTax:=MaxR(MaxR(BracketTax1,BracketTax2),MaxR(BracketTax3,BracketTax4));
     AllBracketsTax:=MaxR(BracketTax5,AllBracketsTax);
end;

Procedure BC479(RetNo:integer;FName:string;FNo:integer);
Var I: integer;x,y,z:Real;SalesTaxCr:Real;
Begin
   InitPrvConstants('BC');
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
    LoadTv(RetNo,FName,FNo);
    If CalcThisProvince(RetNo,'BC') = False then
    begin
      For i:=1 to 21 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
      SaveTv(RetNo,FName,FNo);
      exit;
     end;

     For i:=19 to 21 do
       If Frm[FNo].Strings[i] ='' then Frm[FNo].Strings[i]:='Y';
        {
        Tv[24]:=CalcMortgageForeclosure(Ret[RetNo].Ln[127],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
         }
     Tv[25]:=Vl(FetchElm(RetNo,'FORECLO',4)); //CalcMortgageForeclosure(SpRetNo);
     Tv[1] := MaxR(0,Ln[236]-Tv[24]);
     Tv[2] := MaxR(0,GetSpouseIncome(RetNo)-Tv[25]);
     If UpperCase(Frm[FNo].Strings[17]) ='N' then Tv[2]:=0;
     Tv[3] := Tv[1] + Tv[2];
     If MarStatus < 3 then Tv[4] := 18000 else Tv[4] := 15000;
     Tv[5] := MaxR(0,(Tv[3] - Tv[4]));

     {Sales tax Credit}
     If RY=0 then SalesTaxCr:=75 else SalesTaxCr:=75;
     If UpperCase(Frm[Fno].Strings[19]) = 'Y' then Tv[6] := SalesTaxCr else Tv[6] :=0;
     If MarStatus <3 then Tv[7] :=SalesTaxCr else Tv[7] :=0;
     If UpperCase(Frm[Fno].Strings[20]) <> 'Y' then Tv[7] :=0;

 	   Tv[11] := Tv[6] + Tv[7];
     Tv[10] := Tv[5];
     Tv[12] := Tv[10] * 0.02;
   	 Tv[13] := MaxR(0,(Tv[11] - Tv[12]));
     If ((Age <19) and (MarStatus >2))
     or (Ret[RetNo].Province <> 'BC') then
     begin
          for i:= 6 to 7 do Tv[i] := 0;
          for i:= 11 to 13 do Tv[i] := 0;
     end;

     Tv[14] := MinR(120000,Tv[41]+Tv[9]+Tv[8]); //20210114
     //Tv[14] := MinR(60000,Tv[8] + Tv[9]+tv[22]);
     Tv[15] := Tv[14];

    //Tv[34]:=???
    // Tv[35]:= ???  Missing section

    Tv[18]:=Tv[40]+Tv[15]+Tv[16]+Tv[37];  //20210114
    //Tv[18] := Tv[13]+Tv[15]+Tv[16];
    Ln[479] := Tv[18];
  end;
	{save data}
	SaveTv(RetNo,FName,FNo);
End;


Procedure ON479(RetNo:integer;FName:string;FNo:integer);
Var I,SpRetNo:integer;
    x,y,z,Faktor : real;
Begin
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
       {? Age 16 any impact on ont credits}
       LoadTv(RetNo,FName,FNo);

       If (Ret[RetNo].Province <> 'ON') then
       begin
           for i := 1 to 65 do Tv[i] := 0;
           SaveTv(RetNo,FName,FNo);
           exit;
       end;
       If Frm[FNo].Strings[45] <> 'N' then Frm[FNo].Strings[45]:='';
       For i:=42 to 44 do
          If Frm[FNo].Strings[i] ='' then Frm[FNo].Strings[i]:='Y';

       If Frm[FNo].Strings[4] = '' then Frm[FNo].Strings[4] := 'Y';
       Tv[1] := MaxR(0,Ln[236]);{MaxR(0,GetPrvNetIncome(RetNo,'ON'));}

       If (UpperCase(Frm[FNo].Strings[45]) ='N') then
       begin
         Frm[FNo].Strings[31] :='';
         Frm[FNo].Strings[35] :='';
       end;

       If (UpperCase(Frm[FNo].Strings[31]) ='Y') then
       begin
         Frm[FNo].Strings[42] :='Y';  //invol separation
         Frm[FNo].Strings[45] :='';
       end;

       Tv[2] := MaxR(0,GetSpouseIncome(RetNo));
       If (Ret[RetNo].MarStatus >2)
       or (UpperCase(Frm[FNo].Strings[31]) ='Y')
       or (UpperCase(Frm[FNo].Strings[45]) ='N') then Tv[2] :=0;

       If (UpperCase(Frm[FNo].Strings[31]) ='Y')
       or (UpperCase(Frm[FNo].Strings[45]) ='N') then
            Frm[FNo].Strings[43] :='N';
       If (UpperCase(Frm[FNo].Strings[45]) ='N') then
       begin
         Frm[FNo].Strings[31] :='';
         Frm[FNo].Strings[35] :='';
       end;

	Tv[3] := Tv[1] + Tv[2];
        Tv[4]:=Vl(FetchElm(RetNo,'S12ON',170));
        //If Bankrupt <> 2 then Tv[5] :=0;
        If TV[5] >0 then Tv[3] := Tv[5]; {for bunkruptcy returns}
        {Property/sales tax credit}

       {property tax credit details}
        If Frm[FNo].Strings[25] = '' then
         Frm[FNo].Strings[25]:=
                      FetchElm(RetNo,'INFO',6)+
                 ' '+ FetchElm(RetNo,'INFO',22)+
                 ' '+ FetchElm(RetNo,'INFO',10)+
                 ' '+ FetchElm(RetNo,'INFO',14)+
                 ' '+ FetchElm(RetNo,'INFO',15);
        Tv[64]:=0;Tv[65]:=0;
        Tv[64] := Tv[27]+Tv[32]+Tv[40]+Tv[50]+Tv[55]+Tv[60];
        Tv[65] := Tv[28]+Tv[36]+Tv[46]+Tv[51]+Tv[56]+Tv[61];

        Tv[6] := Tv[64];
	Tv[7] := Tv[6] * 0.20;
        Tv[8] := Tv[65];
        If (Tv[9] >0) then Tv[9] :=25;
        Tv[10]:=Tv[7] + Tv[8] + Tv[9];
	//Tv[10] := MaxR(0,Tv[67]-Tv[66]);

        If (Ret[RetNo].Age < 65) then
         Tv[11] := MinR(250,Tv[10])
        else
         Tv[11] := MinR(625,Tv[10]);

        Tv[33] := Tv[10];
	Tv[12] := Tv[33] * 0.10;
	Tv[14] := Tv[11] + Tv[12];
	Tv[15] := 100;
        If UpperCase(Frm[FNo].Strings[13])='Y' then Tv[15]:=0;
        If UpperCase(Frm[Fno].Strings[42]) <> 'Y' then Tv[15] :=0;
        If (MarStatus <3) {and (Ln[303]>0)} then
             Tv[16]:=100 else Tv[16] :=0;
        If UpperCase(Frm[FNo].Strings[45]) = 'N' then Tv[16] :=0;
        If UpperCase(Frm[Fno].Strings[43]) <> 'Y' then Tv[16] :=0;

        Frm[FNo].Strings[17] := FetchElm(RetNo,'DEPEND',1);
        If vl(Frm[FNo].Strings[67])>10 then Frm[FNo].Strings[67]:='';
        If Frm[FNo].Strings[67]>'' then Frm[FNo].Strings[17]:=Frm[FNo].Strings[67];
        If Vl(Frm[FNo].Strings[17]) > Vl(FetchElm(RetNo,'DEPEND',1)) then
          Frm[FNo].Strings[17] := FetchElm(RetNo,'DEPEND',1);

	Tv[18] := Vl(Frm[FNo].Strings[17]) * 50;
        If UpperCase(Frm[Fno].Strings[44]) <> 'Y' then
         begin Tv[18] :=0;Frm[Fno].Strings[17]:='';end;
	Tv[19] := Tv[15] + Tv[16] + Tv[18];
	Tv[20] := Tv[19];
	Tv[21] := Tv[14] + Tv[20];

         If (Ret[RetNo].Age < 65) then
         begin
          Tv[34] :=Tv[3];
          Tv[22] := MaxR(0,(Tv[34] - 4000) * 0.02);
          Tv[4]:=0;
          Tv[68]:=0;
         end
         else
         begin
          If (UpperCase(Frm[Fno].Strings[45])='N')
          or (UpperCase(Frm[Fno].Strings[31])='Y')
          or (Ret[RetNo].MarStatus > 2)
          then  //non resident or non-married
          begin
           Tv[4] := Tv[3];
           Tv[22] := MaxR(0,(Tv[4] - 22000) * 0.04);
           Tv[34]:=0;
           Tv[68]:=0;
          end
          else
          begin
           Tv[68]:=Tv[3];
           Tv[22]:=MaxR(0,(Tv[68] - 22250) * 0.04);
           Tv[34]:=0;
           Tv[4]:=0;
          end;
        end;
	Tv[23] := MaxR(0,(Tv[21] - Tv[22]));
        If (Ret[RetNo].Age < 65) then
          Tv[24] := MinR(1000,Tv[23])
        else
          Tv[24] := MinR(1125,Tv[23]);

	If (Age <16)
        or (Ret[RetNo].Deceased)
        or (UpperCase(Frm[FNo].Strings[42]) = 'N')  then
         begin
          for i:=6 to 24 do Tv[i] := 0;
         end;
   end;
   SaveTv(RetNo,FName,FNo);
End;


Procedure MANTX_2(RetNo:integer;FName:string;FNo:integer);
var i,j,k: integer; x,y,z:real;
Begin
  InitPrvConstants('MB');
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'MB') = false  then
  begin
   For i:=1 to 61 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
     Tv[1] := MaxR(MaxR(Vl(FetchElm(RetNo,'MB428',20)),
      MaxR(Vl(FetchElm(RetNo,'MB428',21)),Vl(FetchElm(RetNo,'MB428',22)))),
      MaxR(Vl(FetchElm(RetNo,'MB428',72)),Vl(FetchElm(RetNo,'MB428',79))));
    {
     If SplitIncome(RetNo) then
      Tv[12] := Vl(FetchElm(RetNo,'T1206_2',3))
     else
      Tv[12] :=0;
    }
     Tv[13]:=Tv[1]+Tv[12];
     Tv[5]:=Vl(FetchElm(RetNo,'MB428',61));

     Tv[9] := Vl(PrvConstant[RY].PrvDivRate);  //20170406
     Tv[10] := PrvConstant[RY].PrvOverseasRate;
     Tv[11] := PrvConstant[RY].PrvAMTCarryOverRate;
     {
     Tv[6] := Ret[RetNo].Ln[120];
     Tv[8] := Ret[RetNo].Ln[426];
     Tv[63] := Ret[RetNo].Ln[427];
     }
     Tv[7] := (TaxRec.ActualDividendsNonElig * 1.25) * Vl(PrvConstant[RY].PrvDivRate)/100
            +(TaxRec.ActualDividendsElig * 1.45) * Vl(PrvConstant[RY].PrvDivRateBig)/100;//Tv[6] * Tv[9]/100;
     Tv[62] := Tv[8] * Tv[10]/100;
     Tv[64] := Tv[63] * Tv[11]/100;

     Tv[65] := Tv[5]+Tv[7]+Tv[62]+Tv[64];
     Tv[66]:=Tv[65];
     Tv[67]:=MaxR(0,Tv[13]-Tv[66]);

     Tv[28] := 225;
     {
     If Ln[303] >0 then Tv[29] := 225 else Tv[29]:=0;
     If UpperCase(FetchElm(RetNo,'MANCR_1',51))='N' then Tv[29]:=0;
     If Ln[305]>0 then Tv[30] := 225 else Tv[30]:=0;
     If Age >= 65 then Tv[31] := 225 else Tv[31] :=0;

     If (Vl(FetchElm(RetNo,'S2PRV',3))>0) //claimed age xfer  S@PRV NOT S2
     and (Vl(FetchElm(RetNo,'S2PRV',3)) > Vl(FetchElm(RetNo,'S2PRV',18)))
     then  Tv[32]:= 225 else Tv[32] :=0;

     If (Vl(FetchElm(RetNo,'S2PRV',5))>0) //claimed disab xfer
     and (Vl(FetchElm(RetNo,'S2PRV',19)) > Vl(FetchElm(RetNo,'S2PRV',6)))
     then  Tv[43]:= 300 else Tv[43] :=0;
    }
     {Higher net income claims the disabled dependants: }
     (*
     {?MANTAX  in fact it needs the adjusted income}
     k:=0;
     If ((Ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > GetSpouseIncome(RetNo))
        or (Ret[RetNo].MarStatus>2)) then
     begin  //count transfers
      If Vl(FetchElm(RetNo,'MB428',37))>0 then   //>=18 and infirm
         k := StrToInt(FetchElm(RetNo,'DEPEND',2))+
              StrToInt(FetchElm(RetNo,'DEPEND',4));
     end;
     If Vl(FetchElm(RetNo,'MB428',36))>0 then k:=k+1; {disability for self}
     Frm[FNo].Strings[33] := IntTostr(k);

     //REDUCTION FOR DISABLED DEPENDANDS claimed ON LINE 5820
     If ((Ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > GetSpouseIncome(RetNo))
        or (Ret[RetNo].MarStatus>2))
     and (Vl(FetchElm(RetNo,'MB428',30)) >0)   //line 5820
     then
      k:=MyStrToInt(FetchElm(RetNo,'DEPEND',4)) //infirm over 18
        +MyStrToInt(FetchElm(RetNo,'DEPEND',53)) {infirm eq 18}
     Else
      k:=0;
     If Tv[30]>0 then k:=k-1; {equiv to spouse}
     If k<0 then k:=0;
     Frm[FNo].Strings[35] := IntToStr(k);

     k:=MyStrToInt(FetchElm(RetNo,'DEPEND',1)); {18 or less}
     If Tv[30] >0 then k:= k-1;  {equiv to spouse}
     If k<0 then k:=0;
     If ((Ret[RetNo].MarStatus<3) and
        (GetPrvNetIncome(RetNo,'MB') > GetSpouseIncome(RetNo))
        or (Ret[RetNo].MarStatus>2)) then
         Frm[FNo].Strings[37] := IntToStr(k)
     else
         Frm[FNo].Strings[37] := '';
    *)
     If Vl(Frm[FNo].Strings[37]) >0 then  //copy dependants
     begin
      (*
       i := 46;j:=5;
       If Ret[RetNo].FrmHasData[GetFormNo('DEPEND')] then
       repeat
         If (FetchElm(RetNo,'DEPEND',j+6) ='Child')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Son')
         or (FetchElm(RetNo,'DEPEND',j+6) ='Daughter') then
         begin
           If CalcAge(FetchElm(RetNo,'DEPEND',j+5)) <=18 then
            begin
             Frm[FNo].Strings[i]   := FetchElm(RetNo,'DEPEND',j)+' '+
                             FetchElm(RetNo,'DEPEND',j+1); //first/last
             Frm[FNo].Strings[i+1]:= FetchElm(RetNo,'DEPEND',j+6); //relationship
             Frm[FNo].Strings[i+2] := FetchElm(RetNo,'DEPEND',j+5); //birthdate
             Frm[FNo].Strings[i+3] := FetchElm(RetNo,'DEPEND',j+2); //sin
            end;
           inc(i,4);
         end;
       Inc(j,15);
       until (i>58) or (j>125);
      *)
     end
     else
      For i:=46 to 61 do Frm[FNo].Strings[i]:='';

     Tv[34] := Vl(Ret[RetNo].Frm[FNo].Strings[33]) * 300;
     Tv[36] := Vl(Ret[RetNo].Frm[FNo].Strings[35]) * 300;
     Tv[38] := Vl(Ret[RetNo].Frm[FNo].Strings[37]) * 300;
     Tv[39] := 0;
     For i := 28 to 32 do Tv[39] := Tv[39] + Tv[i];
     Tv[39] := Tv[39] + Tv[43]+ Tv[34] + Tv[36] + Tv[38];
//     Tv[2]:= Ln[236];
     Tv[40] := Tv[2] * 1/100;
     Tv[41] := MaxR(0,(Tv[39] - Tv[40]));
     Tv[42] := Tv[41];
     If Ret[RetNo].Province <> 'MB' then
     begin
      for i:=28 to 42 do Tv[i] :=0;
      Tv[43] :=0;
     end;
     Tv[17] := MaxR(0,(Tv[67] - Tv[42]));

//     Tv[14]:=AmountForPrvMinTax(RetNo);
     Tv[15]:=PrvConstant[RY].PrvAMTCarryOverRate;
     Tv[18]:=Tv[14] * Tv[15]/100;

     Tv[19] := Tv[17]+Tv[18];

//     Tv[20] := GetPrvPolit(RetNo,'MB');
     If Tv[20] <= 400 then Tv[21] :=Tv[20]* 0.75
     else If (Tv[20]>400) and (Tv[20] <=750) then
       Tv[21]:= (Tv[20]-400) * 0.50 + 300
     else Tv[21] := (Tv[20] - 750) * 0.3333 +475;
     If Tv[21]>650 then Tv[21]:=650;

     Tv[22] := MaxR(0,Tv[19]-Tv[21]);
     {lab sp}
  //   Tv[23] := Vl(FetchElm(RetNo,'LABORSP',4));
     Tv[23] := MinR(750,Tv[23]);
     {equity}
     Tv[24] := MinR(1500,Tv[24]);
     Tv[25] := Tv[23]+Tv[24];
     Tv[26] := Tv[25];
     Tv[27] := MaxR(0,Tv[22] -Tv[26]);
//     Tv[44] := GetPrvForTaxCredit(RetNo,'MB');
     Tv[3]:= MaxR(0,Tv[27]-Tv[44]);
//     Tv[4]:=Vl(FetchElm(RetNo,'T1241',6));
//     Tv[68]:=Vl(FetchElm(RetNo,'T1256',6));
     If Tv[68]>9000 then Tv[68]:=9000;
     Tv[16] :=MaxR(0,Tv[3]-Tv[68]); //MaxR(0,Tv[3]-Tv[4]);
     Tv[45] := MaxR(0,Tv[16]-Tv[4]); //MaxR(0,Tv[16]-Tv[68]);
  //   Ln[428] := Tv[45];
  end;
   SaveTv(RetNo,FName,FNo);
end;

Procedure MANCR_1(RetNo:integer;FName:string;FNo:integer);
Var i,k:Integer;
Begin
   InitPrvConstants('MB');
   LoadTv(RetNo,FName,FNo);
   If CalcThisProvince(RetNo,'MB') = false  then
   begin
    For i:=1 to 54 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
        For i:=50 to 51 do
          If Frm[FNo].Strings[i]='' then Frm[FNo].Strings[i]:='Y';
        If Frm[FNo].Strings[53]='' then Frm[FNo].Strings[53]:='Y';

        Tv[1] := MaxR(0,Ln[236]);
        If UpperCase(Frm[FNo].Strings[52]) <>'N' then
          Tv[2] := MaxR(0,GetSpouseIncome(RetNo))
        else
         Tv[2] :=0;
        If UpperCase(Frm[FNo].Strings[32]) ='Y' then Tv[2] :=0;
        If UpperCase(Frm[FNo].Strings[32]) ='Y' then
          Frm[FNo].Strings[52]:='';
	Tv[3] := Tv[1] + Tv[2];
        TV[4] := 190;
        If Age >=65 then Tv[5] := 110 Else Tv[5] :=0;
        If UpperCase(Frm[Fno].Strings[50]) <> 'Y' then
         begin Tv[4]:=0;Tv[5]:=0;end;

        If (MarStatus <3)
        or ((MarStatus = 3) and (IsSpouseDeceased(RetNo)))
         then Tv[6] := 190 else Tv[6]:=0; {Ask questions}

        If ((MarStatus <3) or ((MarStatus = 3) and (IsSpouseDeceased(RetNo))))
        and (CalcAge(GetSpouseBirthDate(RetNo)) >=65) then
          Tv[7] :=110 else Tv[7] := 0;
        If SpouseDisabled(RetNo) Then Tv[8] := 110 else Tv[8] :=0;
	Tv[9] := Tv[6] + Tv[7] + Tv[8];
	Tv[10] := Tv[9];
        If Ln[305] > 0 then Tv[11] := 190 else Tv[11] :=0;

        
        Frm[FNo].Strings[12] := FetchElm(RetNo,'MANTX_2',33);
        Tv[13] := Vl(Ret[RetNo].Frm[FNo].Strings[12]) * 110;


        Frm[FNo].Strings[14] :=FetchElm(RetNo,'MANTX_2',35);
	Tv[15] := Vl(Ret[RetNo].Frm[FNo].Strings[14]) * 60;

        Frm[FNo].Strings[16] :=FetchElm(RetNo,'MANTX_2',37);
	Tv[17] := Vl(Ret[RetNo].Frm[FNo].Strings[16]) * 25;

        If UpperCase(Frm[Fno].Strings[51]) <> 'Y' then
              For i:=6 to 10 do Tv[i] :=0;

        If UpperCase(Frm[Fno].Strings[53]) <> 'Y' then
        begin
         Tv[13]:=0;Tv[15]:=0;Tv[17]:=0;
         Frm[Fno].Strings[12]:='';Frm[Fno].Strings[14]:='';
         Frm[Fno].Strings[16]:='';
        end;


	Tv[20] := Tv[4] + Tv[5] + Tv[10] + Tv[11]+Tv[13]+Tv[15]+Tv[17];
        Tv[55] := Tv[3];
	Tv[21] := Tv[55] * 0.01;
	Tv[22] := MaxR(0,(Tv[20] - Tv[21]));
        Tv[23] := Vl(FetchElm(RetNo,'MANCR_2',50));
    	Tv[24] := Tv[23] * 0.20;
        Tv[25] := Vl(FetchElm(RetNo,'MANCR_2',51));
	Tv[26] := Vl(FetchElm(RetNo,'MANCR_2',43));
        If Tv[26]<0.02 then Tv[26]:=0;
	Tv[27] := Tv[24] + Tv[25] + Tv[26];
	Tv[28] := 250;
	Tv[30] := MaxR(0,(Tv[27] - Tv[28]));

        If Ret[RetNo].Age >= 65 then Tv[31] :=800 else Tv[31] :=675;

        Tv[18] := Tv[3];
	Tv[34] := Tv[18] * 0.01;
	Tv[35] := MaxR(400,(Tv[31] - Tv[34]));
        Tv[19] := Tv[35];
	Tv[37] := MinR(Tv[30],Tv[19]);
        Tv[38] := Tv[26];
        Tv[36] := MaxR(0,Tv[37]-Tv[38]);
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure MANCR_2(RetNo:integer;FName:string;FNo:integer);
Var i: integer;x,y,z,FamInc:real;
Begin
   InitPrvConstants('MB');
   LoadTv(RetNo,FName,FNo);
   If CalcThisProvince(RetNo,'MB') = false  then
   begin
    For i:=1 to 63 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
     If Ret[RetNo].Province = 'MB' then
     begin
        Tv[52]:= Vl(FetchElm(RetNo,'MANCR_1',36));
        {home owners assist}
        FamInc :=Vl(FetchElm(RetNo,'MANCR_1',3));
        If (Ret[RetNo].Age >=55) and (FamInc <23800) then
        begin
          //Tv[33]:= MbSchoolCredit(RetNo,FamInc);
          If Tv[34]=0 then Tv[33]:=0;
          Tv[35] := MaxR(0,Tv[34] - 160);
          Tv[36] := Vl(FetchElm(RetNo,'MANCR_1',30));
	  Tv[37] := Vl(FetchElm(RetNo,'MANCR_1',37));
          Tv[38] := MaxR(0,Tv[36]-Tv[37]);
          tv[39] := Tv[38];
          Tv[40] := MinR(Tv[33],MinR( Tv[35],Tv[39]));
        end
        else
        begin
          for i:=33 to 33 do Tv[i] :=0;
          for i:=35 to 40 do Tv[i] :=0;
        end;

       If Frm[FNo].Strings[1]='' then
         Frm[FNo].Strings[1]:=AllTrim(FetchElm(RetNo,'INFO',6)
               +' '+FetchElm(RetNo,'INFO',22));
       If Frm[FNo].Strings[2]='' then
         Frm[FNo].Strings[2]:=AllTrim(FetchElm(RetNo,'INFO',68)+' '
         +' '+FetchElm(RetNo,'INFO',10)
         +' '+FetchElm(RetNo,'INFO',14)
         +' '+FetchElm(RetNo,'INFO',15));

        Tv[41] := Tv[52]+Tv[40];
        Tv[46] := MaxR(0,Tv[41]-Tv[45]);
        Tv[42]:=  Vl(FetchElm(RetNo,'MANCR_1',22));
        Tv[47] := Tv[42]+Tv[46];
       If FetchElm(RetNo,'T5007#1',4)>'' then
        begin
            Tv[48] := (Vl(FetchElm(RetNo,'T5007#1',4))); {factor}
            If Tv[48]>1 then tv[48] :=1;
            Tv[63] := Tv[47] * Tv[48];  ///100;
        end
        else
        begin
           Tv[48]:=0; //new
           Tv[63] := Tv[47];
        end;
     end  //mb
     else
     begin
         for i:=33 to 63 do tv[i] :=0;
     end;

     Ln[479] := Tv[63];
     Tv[50] :=0;
     Tv[51] :=0;
     i:=3;
     Repeat
      If UpperCase(Frm[FNo].Strings[i]) = 'O' then
          Tv[51] := Tv[51]+Tv[i+2]
      else
          Tv[50] := Tv[50]+Tv[i+2];
      Inc(i,8);
     until i>27;

     If (UpperCase(Frm[Fno].Strings[3]) = 'O')
     and (Vl(Frm[FNo].Strings[4])=12)
     and (Tv[43]=0)   then Tv[43]:=400;
     If Tv[43]>400 then Tv[43]:=400;
  end;  //with
  SaveTv(RetNo,FName,FNo);
end;

(*
Procedure SK428(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
 InitPrvConstants('SK');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'SK') = false  then
 begin
  For i:=1 to 61 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo] do
 begin
   Tv[1] := TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
   Tv[24] := Ret[RetNo].Ln[301]; {Vl(FetchElm(RetNo,'AGEDED',17));}
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
   Tv[26] := GetSpouseIncome(RetNo);
   Tv[27] := CalcPrvSpousalClaim(RetNo,GetSpouseIncome(RetNo));
   Tv[28] := CalcPrvSpousalClaim(RetNo,GetSpouseIncome(RetNo));
   If UpperCase(Frm[FNo].Strings[64])='Y' then
     begin Tv[27]:=Tv[65];Tv[28]:=Tv[65];end;

   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));

   {
   If MarStatus <3 then
   begin
    If GetPrvNetIncome(RetNo,'SK')< GetSpouseIncome(RetNo) then
    begin
    Frm[FNo].Strings[68] :=IntToStr
       (MyStrToInt(FetchElm(RetNo,'DEPEND',1))
       -MyStrToInt(FetchElm(RetNo,'DEPEND',3)))
    end
    else
    Frm[FNo].Strings[68] :='';
   end
   else
    Frm[FNo].Strings[68] :=IntToStr
       (MyStrToInt(FetchElm(RetNo,'DEPEND',1))
       -MyStrToInt(FetchElm(RetNo,'DEPEND',3)));
   If Vl(Frm[FNo].Strings[68]) <0 then Frm[FNo].Strings[68] :='';

   Tv[66] := Vl(Frm[FNo].Strings[68]) * 2626;
   If RY=1 then  Tv[66] := Vl(Frm[FNo].Strings[68]) * 2684;
   Tv[67]:=0;
   If Age >=65 then Tv[67]:=1051;
   If (Age >=65) and (RY=1) then Tv[67]:=1074;
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
   Tv[34] := Ret[RetNo].Ln[314];{Vl(FetchElm(RetNo,'PNSDED',18));}
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40]:=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[69] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
 }
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
//   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := MaxR(0,Tv[44]+Tv[45]);
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+Tv[66]+Tv[67]
           +AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
 //  Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)
(*
Procedure SKTAX_2(RetNo:integer;FName:string;FNo:integer);
var i,j,DepFNo: integer;x,y,z:Real;
Begin
   InitPrvConstants('SK');
   LoadTv(RetNo,FName,FNo);
   If CalcThisProvince(RetNo,'SK') = false  then
   begin
    For i:=1 to 61 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   with Ret[RetNo] do
   begin
    Tv[1] := MaxR(Vl(FetchElm(RetNo,'SK428',20)),
      MaxR(Vl(FetchElm(RetNo,'SK428',21)),Vl(FetchElm(RetNo,'SK428',22))));
    Tv[42] := MaxR(0,Tv[1] - Tv[41]);
    If SplitIncome(RetNo) then
     Tv[2] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[2] :=0;
    Tv[3] := Tv[42]+Tv[2];
    Tv[4] :=Vl(FetchElm(RetNo,'SK428',61));

    Tv[7] := PrvConstant[RY].PrvDivRate;
    Tv[10] := PrvConstant[RY].PrvOverseasRate;
    Tv[13] := PrvConstant[RY].PrvAMTCarryOverRate;
   {
    Tv[6] := Ret[RetNo].Ln[120];
    Tv[9] := Ret[RetNo].Ln[426];
    Tv[12] := Ret[RetNo].Ln[427];
    }
    Tv[8] := (TaxRec.ActualDividendsNonElig * 1.25) * PrvConstant[RY].PrvDivRate/100
            +(TaxRec.ActualDividendsElig * 1.45) * PrvConstant[RY].PrvDivRateBig/100;//Tv[6] * Tv[7]/100;
    Tv[11] := Tv[9] * Tv[10]/100;
    Tv[14] := Tv[12] * Tv[13]/100;
    Tv[15] := Tv[4]+Tv[8]+Tv[11]+Tv[14];
    Tv[16] := Tv[15];
    Tv[17] := MaxR(0,Tv[3] - Tv[16]);

//    Tv[62]:=AmountForPrvMinTax(RetNo);
  //  If IsDeceased(RetNo) then Tv[62]:=0;
    Tv[63]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[5]:=Tv[62] * Tv[63]/100;
    Tv[43]:=Tv[17]+Tv[5];
//    Tv[18] := GetPrvForTaxCredit(RetNo,'SK');
    Tv[19] := MaxR(0,Tv[43]-Tv[18]);

    Tv[45]:=MaxR(0,Tv[19]-Tv[44]);

  //  Tv[20] := GetPrvPolit(RetNo,'SK');
    If Tv[20] <=400 then Tv[21]:= Tv[20] * 0.75
    else If (Tv[20] >400) and (Tv[20] <=750) then
      Tv[21]:= (Tv[20]-400) * 0.50 + 300
    else If (Tv[20] >750) then Tv[21]:= (Tv[20]-750) * 0.3333 + 475;
    If Tv[21] > 1275 then Tv[21]:= 650;

    Tv[22] := MaxR(0,Tv[45]-Tv[21]);
    Tv[23] := MinR(1000,Tv[23]);
    Tv[24] := MinR(1000,Tv[24]);
    Tv[27] := MinR(1000,Tv[23]+Tv[24]);
    Tv[26] := Tv[27];
    Tv[25] := MaxR(0,Tv[22]-Tv[26]);

    Tv[28] := MinR(675,Tv[28]);
    Tv[30]:= Tv[28];
    If Tv[29]>0 then Tv[30]:=Tv[29];
    Tv[31]:= Tv[30];
    Tv[32] := MaxR(0,Tv[25]-Tv[31]);
    Tv[35]:= Tv[33]+Tv[34];
    Tv[36]:=Tv[35];
    Tv[37] := MaxR(0,Tv[32]-Tv[36]);
    Ln[428] := Tv[37];


    For i:=46 to 61 do Frm[FNo].Strings[i]:='';
   end;
   SaveTv(RetNo,FName,FNo);
end;
*)

(*
Procedure YT428(RetNo:integer;FName:string;FNo:integer);
var i,count: integer;x,y,z:real;
Begin
 InitPrvConstants('YT');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'YT') = false  then
 begin
  For i:=1 to 72 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo] do
 begin
   Tv[1] := TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Frm[FNo].Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
{
   Tv[24] := Ret[RetNo].Ln[301]; //Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
   Tv[26] := GetSpouseIncome(RetNo);
   Tv[27] := CalcPrvSpousalClaim(RetNo,GetSpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
   Tv[34] := Ret[RetNo].Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
  }
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
//   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

(*
Procedure YKTAX_2(RetNo:integer;FName:string;FNo:integer);
Var x,y,z:real;i:integer;
Begin
   InitPrvConstants('YT');
   LoadTv(RetNo,FName,FNo);
   If CalcThisProvince(RetNo,'YT') = false  then
   begin
    For i:=1 to 41 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   with Ret[RetNo] do
   begin
    Tv[34] := MaxR(
      MaxR(Vl(FetchElm(RetNo,'YT428',20)),Vl(FetchElm(RetNo,'YT428',21))),
      MaxR(Vl(FetchElm(RetNo,'YT428',22)),Vl(FetchElm(RetNo,'YT428',67))));
  {
    If SplitIncome(RetNo) then
     Tv[33] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[33] :=0;
    }
    Tv[32] := Tv[34]+Tv[33];

    Tv[31] :=Vl(FetchElm(RetNo,'YT428',61));

    Tv[6] := PrvConstant[RY].PrvDivRate;
    Tv[9] := PrvConstant[RY].PrvOverseasRate;
    Tv[12] := PrvConstant[RY].PrvAMTCarryOverRate;
    {
    Tv[30] := Ret[RetNo].Ln[120];
    Tv[29] := Ret[RetNo].Ln[426];
    Tv[27] := Ret[RetNo].Ln[427];
    }
    Tv[8] := (TaxRec.ActualDividendsNonElig * 1.25) * PrvConstant[RY].PrvDivRate/100
            +(TaxRec.ActualDividendsElig * 1.45) * PrvConstant[RY].PrvDivRateBig/100;//Tv[30] * Tv[6]/100;
    Tv[28] := Tv[29] * Tv[9]/100;
    Tv[26] := Tv[27] * Tv[12]/100;
    Tv[25] := Tv[31]+Tv[8]+Tv[28]+Tv[26];
    Tv[11] := Tv[25];
    Tv[10] := MaxR(0,Tv[32] - Tv[11]);

//    Tv[2]:=Vl(FetchElm(RetNo,'T691_4',16));
//    If IsDeceased(RetNo) then Tv[2]:=0;
    Tv[1]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[7]:=Tv[2] * Tv[1]/100;
    Tv[5] := Tv[10]+Tv[7];

    Tv[35]:=Tv[5];
    Tv[36]:=6000;
    Tv[37]:=MaxR(0,Tv[35]-Tv[36]);
    Tv[38]:=5;
    Tv[39]:=Tv[37]*Tv[38]/100;
    Tv[40]:=Tv[39];
    Tv[41]:=Tv[5]+Tv[40];

    {
    If Ret[RetNo].Province <> 'YT' then
     Tv[4] :=0
    else
     Tv[4] := GetPrvForTaxCredit(RetNo,'YT');
   }
    Tv[3]:=MaxR(0,Tv[41]-Tv[4]);

    Tv[13] := 300;
//    Tv[14] := Ln[236];
    Tv[15] := 15000;
    Tv[16] := MaxR(0,Tv[14] - Tv[15]);
    Tv[17] := 3;
    Tv[18] := Tv[16] * Tv[17]/100;
    Tv[19] := Tv[18];
    Tv[20] := MaxR(0,Tv[13] - Tv[19]);
    Tv[24] := Tv[3];
    Tv[21] := Tv[24] * 0.80;
    Tv[22] := MinR(Tv[20],Tv[21]);

    Tv[15]:=15000;
    Tv[17]:=3;
    If Ret[RetNo].Province <> 'YT' then Tv[22]:=0;
    Tv[23] := MaxR(0,Tv[3] - Tv[22]);
    Ln[428] := Tv[23];
   end;
   SaveTv(RetNo,FName,FNo);
end;
*)
Procedure Yt479(RetNo:integer;FName:string;FNo:integer);
Var x,y,z:real;i:integer;
Begin
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'YT') = false  then
  begin
    For i:=1 to 33 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
     {polit}
    If Ret[RetNo].Province = 'YT' then
    begin
         Tv[6] := GetPrvPolit(RetNo,'YT');
         {polit}
         If Tv[6] <=100 then x:= Tv[6] * 0.75
         Else if ((Tv[6] >100) and (Tv[6] <=550)) then
           x := (Tv[6]-100) * 0.50 + 75
         Else if Tv[6] >550 then x := (Tv[6]-550) * 0.3333 + 300;
         If x >500 then x :=500;
         Tv[10]:=x;
       	 Tv[11] := Ln[428];
	 Tv[12] := MinR(Tv[10],Tv[11]);
        {othr}
        Tv[2] := Tv[24]+Tv[1];
        Tv[25] := Ln[428];
        Tv[26] := Tv[12];
        Tv[27] := MaxR(0,Tv[25] - Tv[26]);

        Tv[28] := MinR(Tv[2],Tv[27]);
        Tv[28] := MinR(25000,Tv[28]);

        Tv[4] := MinR(1250,Tv[4]);
        Tv[18] := Tv[4]+Tv[17];

        Tv[5] := Ln[428];
        Tv[7] := Tv[12]+Tv[28];
        Tv[8] := MaxR(0,Tv[5]-Tv[7]);
        Tv[9] := MinR(Tv[18],Tv[8]);

        Tv[14] := Tv[28]+Tv[9]+Tv[13]+Tv[20];
        Tv[15] := Tv[14];

        Tv[32] :=Vl(FetchElm(RetNo,'YFNTAX',11));
        Tv[33] := Tv[12]+Tv[15]+Tv[32];
        Ln[479] := Tv[33];
     end;
    end;
   SaveTv(RetNo,FName,FNo);
end;


(*
Procedure AB428(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;x,y,z:real;
Begin
 InitPrvConstants('AB');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'AB') = false  then
 begin
  For i:=1 to 61 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo] do
 begin
   Tv[5] := TaxRec.TaxableIncome;
  // If UpperCase(Frm[FNo].Strings[11])='Y' then Tv[5]:=Tv[12];

   Frm[FNo].Strings[6] := PrvConstant[RY].PrvRate1;
   Tv[7] := Tv[5] * Vl(Frm[FNo].Strings[6])/100;
   Tv[9] := Tv[7]+Tv[8];


   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
{
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
   Tv[26] := GetSpouseIncome(RetNo);
   Tv[27] := CalcPrvSpousalClaim(RetNo,GetSpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];

   Tv[1] := PrvConstant[RY].PrvSpouseBasicAmount;
   Tv[2] := Vl(FetchElm(RetNo,'S5PRV',8));
   Tv[3]:= Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
   Tv[34] := Vl(FetchElm(RetNo,'PNSDED',18)); //Ln[314];
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40]:=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[66] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
  }
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
//   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
//   Tv[13]:=Ret[RetNo].Ln[313];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)++Tv[13]+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   //Tv[51] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
 //  Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];
   Tv[10] := Tv[61];
   Tv[4] := MaxR(0,Tv[9] - Tv[10]);
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)
(*
Procedure ALTAX_2(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;x,y,z:real;
Begin
  InitPrvConstants('AB');
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'AB') = false  then
  begin
   For i:=1 to 22 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with Ret[RetNo] do
  begin
   Tv[1] := Vl(FetchElm(RetNo,'ALTAX_1',4));
   Tv[2] := Ln[120];
   Tv[18]:= PrvConstant[RY].PrvDivRate;
   Tv[3] := (TaxRec.ActualDividendsNonElig * 1.25) * PrvConstant[RY].PrvDivRate/100
            +(TaxRec.ActualDividendsElig * 1.45) * PrvConstant[RY].PrvDivRateBig/100;//Tv[2] * Tv[18]/100;

   Tv[4] := Ln[426];
   Tv[19]:= PrvConstant[RY].PrvOverseasRate;
   Tv[5] := Tv[4] * Tv[19]/100;

   Tv[6] := Ln[427];
   Tv[20]:= PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[7] := Tv[6] * Tv[20]/100;

   Tv[8] := Tv[3]+Tv[5]+Tv[7];
   Tv[9] := Tv[8];
   Tv[10] :=MaxR(0,Tv[1]-Tv[9]);
   Tv[23]:=AmountForPrvMinTax(RetNo);
   Tv[24]:=PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[21]:=Tv[23] * Tv[24]/100;
   Tv[22]:= Tv[10]+Tv[21];

   Tv[11] :=GetPrvForTaxCredit(RetNo,'AB');
   Tv[12] := MaxR(0,Tv[22]-Tv[11]);

   If Ret[RetNo].Province = 'AB' then
   begin
//    Tv[13] := GetPrvPolit(RetNo,'AB');
    If Tv[13] <= 200 then
       Tv[14] :=Tv[13]* 0.75
    else If (Tv[13]>200) and (Tv[13] <=1100) then
       Tv[14]:= (Tv[13]-200) * 0.50 +150
    else if (Tv[13]> 1100) and (Tv[13]<=2300)
       then Tv[14] := (Tv[13] - 1100) * 0.3333 + 600;
    If Tv[13]>2300 then Tv[14]:=1000;
   end;

   If Ret[RetNo].Province = 'AB' then
   begin
//    Tv[25] := Vl(FetchElm(RetNo,'POLIT',16));
    If Tv[25] <= 200 then
       Tv[26] :=Tv[25]* 0.75
    else If (Tv[25]>200) and (Tv[25] <=1100) then
       Tv[26]:= (Tv[25]-200) * 0.50 +150
    else if (Tv[25]> 1100) and (Tv[25]<=2300)
       then Tv[26] := (Tv[25] - 1100) * 0.3333 + 600;
    If Tv[25]>2300 then Tv[26]:=1000;
   end;

  Tv[28] := MaxR(0,Tv[14]+Tv[26]);
  Tv[27] := MaxR(0,Tv[14]+Tv[26]); //same
  Tv[15] := MaxR(0,Tv[12]-Tv[27]);
//  Tv[16] := Vl(FetchElm(RetNo,'T79',20));
  Tv[17] := MaxR(0,Tv[15]-Tv[16]);
  end;
  SaveTv(RetNo,FName,FNo);
end;
*)
Procedure NS479(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;x,y,z:real;
Begin
  InitPrvConstants('NS');
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'NS') = false  then
  begin
   For i:=1 to 36 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    {polit}
    Tv[1] := GetPrvPolit(RetNo,'NS');
    If Tv[1] <=100 then x:= Tv[1] * 0.75
    Else if ((Tv[1] >100) and (Tv[1] <=550)) then
        x := (Tv[1]-100) * 0.50 + 75
    Else if Tv[1] >550 then x := (Tv[1]-550) * 0.3333 + 300;
    If x >500 then x :=500;
    Tv[5]:=x;

    {Labor}
    Frm[FNo].Strings[4] :='N';

    Tv[35]:=MinR(1000,Tv[2]*20/100);
    Tv[7] := Tv[5]+Tv[35];
    Tv[8] := Vl(FetchElm(RetNo,'NS428',123));
    Tv[9] := MinR(Tv[7],Tv[8]);

    {equity}
    Tv[17] := Tv[15]+Tv[16];
    Tv[18] := Vl(FetchElm(RetNo,'NS428',123));
    Tv[38] := Tv[9];
    Tv[39] := MaxR(0,Tv[18] - Tv[38]);
    Tv[19] := MinR(15000,MinR(Tv[17],Tv[39]));
    Tv[3]:=Tv[20]+Tv[6]+Tv[36]; //tot carry back
    Tv[34] := Tv[9] + Tv[19];
    Ln[479] := Tv[34];
 end;
    {save data}
    SaveTv(RetNo,FName,FNo);
End;

(*
Procedure NS428(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin
 InitPrvConstants('NS');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NS') = false  then
 begin
  For i:=1 to 54 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo] do
 begin
   Tv[1] := TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;

   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];      +
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and  (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Frm[FNo].Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;


   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
{
   Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
   Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
   Tv[26] := GetSpouseIncome(RetNo);
   Tv[27] := CalcPrvSpousalClaim(RetNo,GetSpouseIncome(RetNo));
   Tv[28]:= Tv[27];
   If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];

   Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
   Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
   Tv[31] := Ret[RetNo].Ln[308];
   Tv[32] := Ret[RetNo].Ln[310];
   Tv[33] := Ret[RetNo].Ln[312];
   Tv[34] := Vl(FetchElm(RetNo,'PNSDED',18));
   Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
   If Ret[RetNo].Age >=18 then
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
   else
     Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

   Tv[37]:=GetPrvDisabXfer(RetNo);
   Tv[38] := Ret[RetNo].Ln[319];
   Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
   Tv[40] :=GetPrvEducXfer(RetNo);
   Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
   Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
   Tv[80] := PrvConstant[RY].PrvMedicalLimit;
   Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
   Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
 }
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[47]+Tv[51];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
//   Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];
 end;
 SaveTv(RetNo,FName,FNo);
End;
*)

(*
Procedure NSTAX_2(RetNo:integer;FName:string;FNo:integer);
Var i,SpRetNo:integer;
Begin
  InitPrvConstants('NS');
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'NS') = false  then
  begin
   For i:=1 to 50 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with Ret[RetNo] do
  begin
   Tv[30]:=0;
   if Vl(FetchElm(RetNo,'NS428',20)) > 0 then
        Tv[30] := Vl(FetchElm(RetNo,'NS428',20))
   else if Vl(FetchElm(RetNo,'NS428',21)) > 0 then
        Tv[30] := Vl(FetchElm(RetNo,'NS428',21))
   else if Vl(FetchElm(RetNo,'NS428',22)) > 0 then
        Tv[30] := Vl(FetchElm(RetNo,'NS428',22))
   else if Vl(FetchElm(RetNo,'NS428',67)) > 0 then
        Tv[30] := Vl(FetchElm(RetNo,'NS428',67));

   Tv[4] := PrvConstant[RY].PrvDivRate;
   Tv[5] := PrvConstant[RY].PrvOverseasRate;
   Tv[6] := PrvConstant[RY].PrvAmtCarryOverRate;
  {
   If SplitIncome(RetNo) then
     Tv[31] := Vl(FetchElm(RetNo,'T1206_2',3))
   else
     Tv[31] :=0;
   }
   Tv[32] := Tv[30]+Tv[31];
   Tv[33] := Vl(FetchElm(RetNo,'NS428',61));
{
   Tv[35] := Ret[RetNo].Ln[120];
   Tv[37] := Ret[RetNo].Ln[426];
   Tv[39] := Ret[RetNo].Ln[427];
   }
   If (Ret[RetNo].Province <> 'NS') then
   begin
    Tv[35] := 0;
    Tv[37] := 0;
   end;
   Tv[36] := (TaxRec.ActualDividendsNonElig * 1.25) * PrvConstant[RY].PrvDivRate/100
            +(TaxRec.ActualDividendsElig * 1.45) * PrvConstant[RY].PrvDivRateBig/100;//Tv[35] * Tv[4]/100;
   Tv[38] := Tv[37] * Tv[5]/100;
   Tv[40] := Tv[39] * Tv[6]/100;
   Tv[41] := Tv[33]+Tv[36]+Tv[38]+Tv[40];
   Tv[42] := Tv[41];
   Tv[43] := MaxR(0,Tv[32] - Tv[42]);

//   Tv[12]:=Vl(FetchElm(RetNo,'T691_4',16));
//   If IsDeceased(RetNo) then Tv[12]:=0;
   Tv[20]:=PrvConstant[RY].PrvAMTCarryOverRate;
   Tv[44]:=Tv[12] * Tv[20]/100;
   Tv[45] := Tv[43]+Tv[44];

   Tv[46] := Tv[45];
   Tv[47] := MaxR(0,Tv[46] - 10000) * 10/100;
   Tv[48] :=Tv[45]+Tv[47];
   Tv[49] := GetPrvForTaxCredit(RetNo,'NS');
   Tv[50] := MaxR(0,Tv[48] - Tv[49]);
   If Frm[FNo].Strings[2]+Frm[FNo].Strings[3]= '' then  Frm[FNo].Strings[2] := 'X';

   If UpperCase(Frm[FNo].Strings[2]) = 'X' then {reduction claimed}
   begin
   end
    else
    begin
     for i:=7 to 11 do TV[i] :=0;
     Frm[FNo].Strings[21] :='';
    end;

    //less than 19, no kids, no spouse
    If (Ret[RetNo].Age<19) and (Tv[8]+Tv[9]+Tv[10]=0) then
    begin
     for i:=7 to 11 do TV[i] :=0;
     for i:=13 to 18 do TV[i] :=0;
     for i:=26 to 27 do TV[i] :=0;
    end;

    {
    Tv[22]:=CalcMortgageForeclosure(Ret[RetNo].Ln[127],
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),122)),
                  Vl(FetchElmFNo(RetNo,GetFormNo('S3'),72)));
    Tv[24]:=Vl(FetchElm(RetNo,'FORECLO',4)); //CalcMortgageForeclosure(SpRetNo);
    Tv[13] := MaxR(0,Ln[236]-Tv[22]);
    Tv[14] :=MaxR(0,GetSpouseIncome(RetNo)-Tv[24]);
   }
    Tv[15] := Tv[13] + Tv[14];
    Tv[16] := 15000;
    Tv[17] := MaxR(0,(Tv[15] - Tv[16]));
    Tv[26] := 5;
    Tv[27] := Tv[17] * Tv[26] /100;
    Tv[18] := Tv[27];
    Tv[1] := MaxR(0,(Tv[11] - Tv[18]));
    Tv[19]:=Tv[1];
    If Ret[RetNo].Province <> 'NS' then Tv[19]:=0;
    Tv[23] := MaxR(0,Tv[50] - Tv[19]);
//    Ln[428] := Tv[23];
  end;
  SaveTv(RetNo,FName,FNo);
End;
*)

procedure POLIT(RetNo: integer; FName: String;FNo: integer);
Var cn,us: real; I: integer;
begin
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
   //Tv[1] := Ret[RetNo].T5013FedPol;
   Tv[6] := Tv[1] +Tv[3] +Tv[5];

  // Tv[7] := Ret[RetNo].T5013ProvPol;
   Tv[12]:= Tv[7] +Tv[9] +Tv[11];

   Tv[16]:= Tv[14]+Tv[15];

   Tv[13] := Tv[6]+Tv[12]+Tv[16];
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

(*
Procedure NU428(RetNo:integer;FName:string;FNo:integer);
var i,count: integer;x,y,z:real;
Begin
 InitPrvConstants('NU');
 LoadTv(RetNo,FName,FNo);
 If CalcThisProvince(RetNo,'NU') = false  then
 begin
  For i:=1 to 72 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 With Ret[RetNo] do
 begin
   Tv[1] := TaxRec.TaxableIncome;
   For i:=2 to 22 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   For i:=66 to 72 do begin Tv[i]:=0;Frm[FNo].Strings[i]:='';end;
   Frm[FNo].Strings[11] := PrvConstant[RY].PrvRate1;
   Frm[FNo].Strings[12] := PrvConstant[RY].PrvRate2;
   Frm[FNo].Strings[13] := PrvConstant[RY].PrvRate3;
   Frm[FNo].Strings[70] := PrvConstant[RY].PrvRate4;

   Tv[6] := PrvConstant[RY].PrvBracket1;
   Tv[18] := PrvConstant[RY].PrvBracketTax2;
   Tv[7] := PrvConstant[RY].PrvBracket2;
   Tv[19] := PrvConstant[RY].PrvBracketTax3;
   Tv[68] := PrvConstant[RY].PrvBracket3;
   Tv[72] := PrvConstant[RY].PrvBracketTax4;

   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[5] :=0;
     Tv[8] := MaxR(0,Tv[2]-Tv[5]);
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[17] :=0;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[6] := PrvConstant[RY].PrvBracket1;
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[18] := PrvConstant[RY].PrvBracketTax2;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[7] := PrvConstant[RY].PrvBracket2;
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[19] := PrvConstant[RY].PrvBracketTax3;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := PrvConstant[RY].PrvBracket3;
     Tv[69] := MaxR(0,Tv[66]-Tv[68]);
     Tv[71] := Tv[69] * Vl(Frm[FNo].Strings[70])/100;
     Tv[72] := PrvConstant[RY].PrvBracketTax4;
     Tv[67] := Tv[71] + Tv[72];
   end;

   Tv[23] := PrvConstant[RY].PrvPersAmount * PartYear;
 //Tv[24] := Vl(FetchElm(RetNo,'AGEDED',17));
// Tv[25] := PrvConstant[RY].PrvSpouseBasicAmount * PartYear;
// Tv[26] := GetSpouseIncome(RetNo);
// Tv[27] := CalcPrvSpousalClaim(RetNo,GetSpouseIncome(RetNo));
   Tv[28]:= Tv[27];
// If UpperCase(Frm[FNo].Strings[64])='Y' then Tv[28]:=Tv[65];
// Tv[29] := Vl(FetchElm(RetNo,'S5PRV',10));
// Tv[30] := Vl(FetchElm(RetNo,'S5PRV',87));
// Tv[31] := Ret[RetNo].Ln[308];
// Tv[32] := Ret[RetNo].Ln[310];
// Tv[33] := Ret[RetNo].Ln[312];
// Tv[34] := Ret[RetNo].Ln[314];
// Tv[35] := Vl(FetchElm(RetNo,'S5PRV',90));
// If Ret[RetNo].Age >=18 then
//   Tv[36] := Vl(FetchElm(RetNo,'DISAB18',14))
// else
//   Tv[36] := Vl(FetchElm(RetNo,'DISAB18',24));

// Tv[37]:=GetPrvDisabXfer(RetNo);
// Tv[38] := Ret[RetNo].Ln[319];
// Tv[39] := Vl(FetchElm(RetNo,'S11PRV',21));
// Tv[40] :=GetPrvEducXfer(RetNo);
// Tv[41] := Vl(FetchElm(RetNo,'S2PRV',19));
// Tv[42]:=Vl(FetchElm(RetNo,'MEDICAL',112));
// Tv[80] := PrvConstant[RY].PrvMedicalLimit;
// Tv[43] := CalcPrvMedicalLimit(RetNo);
   Tv[44] := MaxR(0,Tv[42]-Tv[43]);
// Tv[45] := Vl(FetchElm(RetNo,'MEDPRV',76));
   Tv[46] := Tv[44]+Tv[45];
   Tv[47] := Tv[46];
   Tv[48]:=Tv[23]+Tv[24]+AddColumns(28,30,1)+AddColumns(31,41,1)+Tv[47];
   Tv[49]:=Tv[48];
   Tv[50] := PrvConstant[RY].PrvNonRefundRate;
   Tv[52]:= Tv[49] * PrvConstant[RY].PrvNonRefundRate/100;
// Tv[53]:=Ln[345];
   Tv[54]:= PrvConstant[RY].PrvDonRate1;
   Tv[55] := Tv[53] * Tv[54]/100;
   Tv[56]:=Ln[347];
   Tv[57] := PrvConstant[RY].PrvDonRate2;
   Tv[58] := Tv[56] * Tv[57]/100;
   Tv[59]:=Tv[55]+Tv[58];
   Tv[60] := Tv[59];
   Tv[61] := Tv[52]+Tv[60];
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)
(*
Procedure NUTAX_2(RetNo:integer;FName:string;FNo:integer);
var i,count: integer;x,y,z:real;
Begin
   InitPrvConstants('NU');
   LoadTv(RetNo,FName,FNo);
   If CalcThisProvince(RetNo,'NU') = false  then
   begin
    For i:=1 to 20 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   with Ret[RetNo] do
   begin
    Tv[1] := MaxR(
      MaxR(Vl(FetchElm(RetNo,'NU428',20)),Vl(FetchElm(RetNo,'NU428',21))),
      MaxR(Vl(FetchElm(RetNo,'NU428',22)),Vl(FetchElm(RetNo,'NU428',67))));
  {
    If SplitIncome(RetNo) then
     Tv[2] := Vl(FetchElm(RetNo,'T1206_2',3))
    else
     Tv[2] :=0;
     }
    Tv[3] := Tv[1]+Tv[2];

    Tv[4] :=Vl(FetchElm(RetNo,'NU428',61));

    Tv[6] := PrvConstant[RY].PrvDivRate;
    Tv[9] := PrvConstant[RY].PrvOverseasRate;
    Tv[12] := PrvConstant[RY].PrvAMTCarryOverRate;

    {
    Tv[5] := Ret[RetNo].Ln[120];
    Tv[8] := Ret[RetNo].Ln[426];
    Tv[11] := Ret[RetNo].Ln[427];
    }
    Tv[7] := (TaxRec.ActualDividendsNonElig * 1.25) * PrvConstant[RY].PrvDivRate/100
            +(TaxRec.ActualDividendsElig * 1.45) * PrvConstant[RY].PrvDivRateBig/100;//Tv[5] * Tv[6]/100;
    Tv[10] := Tv[8] * Tv[9]/100;
    Tv[13] := Tv[11] * Tv[12]/100;
    Tv[14] := Tv[4]+Tv[7]+Tv[10]+Tv[13];
    Tv[15] := Tv[14];
    Tv[16] := MaxR(0,Tv[3] - Tv[15]);

//    Tv[21]:=Vl(FetchElm(RetNo,'T691_4',16));
//    If IsDeceased(RetNo) then Tv[21]:=0;
    Tv[22]:=PrvConstant[RY].PrvAMTCarryOverRate;
    Tv[17]:=Tv[21] * Tv[22]/100;

    Tv[18] := Tv[16]+Tv[17];
{
    If Ret[RetNo].Province <> 'NU' then
     Tv[19] :=0
    else
     Tv[19] := GetPrvForTaxCredit(RetNo,'NU');
  }
    Tv[20] := MaxR(0,Tv[18]-Tv[19]);
  //  Ln[428] := Tv[20];

   end;
   SaveTv(RetNo,FName,FNo);
end;
*)

Procedure YFNTAX(RetNo:integer;FName:string;FNo:integer);
var i,count: integer;x,y,z:real; s:String[30];
Begin
   If CalcThisProvince(RetNo,'YT') = false  then exit;
   LoadTv(RetNo,FName,FNo);
   with Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
     Frm[FNo].Strings[14] := 'Champagne and Aishihik';
     Frm[FNo].Strings[15] :='11002';

     Frm[FNo].Strings[17] := 'Kluane';
     Frm[FNo].Strings[18] :='11003';

     Frm[FNo].Strings[20] := 'Little Salmon/Carmacks';
     Frm[FNo].Strings[21] :='11006';

     Frm[FNo].Strings[23] := 'Nacho Nyak Dun';
     Frm[FNo].Strings[24] :='11007';

     Frm[FNo].Strings[38] := 'SelKirk';
     Frm[FNo].Strings[39] :='11009';

     Frm[FNo].Strings[26] := 'Teslin Tlingit';
     Frm[FNo].Strings[27] :='11011';

     Frm[FNo].Strings[29] := 'Tr'+chr(39)+'ondek Hwech'+Chr(39)+'in';
     Frm[FNo].Strings[30] :='11012';

     Frm[FNo].Strings[32] := 'Vuntut Gwitchin';
     Frm[FNo].Strings[33] :='11013';

     Frm[FNo].Strings[35] := 'Ta'+chr(39)+'an Kwach'+Chr(39)+'an';
     Frm[FNo].Strings[36] :='11010';

     Ln[441] := Tv[5];
     Ln[432] := Tv[12];
   end;
  SaveTv(RetNo,FName,FNo);
end;

procedure NT479(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;x:Real;SpRetNo:Integer;
begin
  If CalcThisProvince(RetNo,'NT') = False then
  begin
   For i:=1 to 32 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   Ret[RetNo].Frm[FNo].Strings[24]:='N';
   Ret[RetNo].Frm[FNo].Strings[26]:='N';
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    If Ret[Retno].Province = 'NT' then
    begin
     If Frm[FNo].Strings[26]='' then Frm[FNo].Strings[26]:='Y';
     Tv[7] := Ln[236];
     Tv[8] := Ln[250];
     Tv[9] := MaxR(0,Tv[7]-Tv[8]);
     Tv[10] := Ret[RetNo].Ln[256];
     Tv[11] := MaxR(0,Tv[9] - Tv[10]);

     x:=Tv[11];
     If x <= 12000 then Tv[12] := x * 2.6/100
     Else if ((x >= 12000.01) AND (x <= 48000.00)) then
     	Tv[12] := 312 + (x-12000) * 1.25/100
     Else if (x >= 48000.01) then
     	Tv[12] := 762+ (x-48000) * 1.00/100;
     Tv[12]:=MinR(942,Tv[12]); //Else Tv[12] := 822;
    end
    else
     For i:=7 to 12 do TV[i]:=0;

    If UpperCase(Frm[FNo].Strings[26]) <> 'Y' then
      for i:=7 to 12 do Tv[i]:=0;

    If Frm[FNo].Strings[24]='' then
    begin
      If Ret[RetNo].Age >=18 then
       Frm[FNo].Strings[24]:='Y'
      else
       Frm[FNo].Strings[24]:='N';
    end;
    If Ret[RetNo].Age <18 then Frm[FNo].Strings[24]:='N';
    If Ret[RetNo].Province <> 'NT' then Frm[FNo].Strings[24]:='N';

    If UpperCase(Frm[FNo].Strings[24]) = 'Y' then
    begin
      Tv[3]:=350;
      If Ret[RetNo].MarStatus <3 then
       Tv[4]:=350
      else
       Tv[4]:=0;
      Tv[5]:=Tv[3]+Tv[4];
      Tv[6]:=Tv[5];
      Tv[17]:=Tv[12];
      Tv[19]:=Tv[17]+Tv[18];
      Tv[20]:=Tv[19];
      Tv[21]:=MaxR(0,Tv[6]-Tv[20]);
      Tv[22]:=Tv[21];
    end
    else
    begin
     For i:=3 to 6 do Tv[i]:=0;
     For i:=17 to 22 do Tv[i]:=0;
    end; //nt

    Tv[32]:=MinR(942,Tv[12]+Tv[22]);
    Ln[479] := Tv[32];
   end; //with
  SaveTv(RetNo,FName,FNo);
end;

procedure NU479(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'NU') = False then
  begin
   For i:=1 to 21 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
        Tv[7] := Ln[236];
        Tv[8] := Ln[250];
        Tv[9] := MaxR(0,Tv[7]-Tv[8]);
        Tv[10] := Vl(FetchElm(RetNo,'OTHDED',22));  {exempt}
        Tv[11] := MaxR(0,Tv[9]-Tv[10]);
        //Tv[12] :=CalcNuCola(Tv[11]);
         {Polit}
        Tv[13] := GetPrvPolit(RetNo,'NU');
       // Tv[14] := CalcNuPolit(Tv[13]);
        Tv[15]:=Vl(FetchElm(RetNo,'NU428',120));
        Tv[1] := Tv[12];
	Tv[2] := MaxR(0,Tv[15]-Tv[1]);
        Tv[16] := MinR(Tv[14],Tv[2]);

        Tv[30] := Tv[2];
        Tv[31] := Tv[16];
        Tv[32] := MaxR(0,Tv[30]-Tv[31]);
        Tv[33] := MinR(Tv[28],Tv[32]);
        Tv[34] := Tv[12]+Tv[16]+Tv[33];
        Ln[479] := Tv[34];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure NSLS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  If CalcThisProvince(RetNo,'NS') = False then
  begin
   For i:=1 to 5 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
   Tv[2]:=MinR(525,Tv[1]*15/100);
   Tv[4]:=MinR(1000,Tv[3]*20/100);
   Tv[5]:=MinR(1000,Tv[2]+Tv[4]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Function CalcThisProvince(RetNo:Integer;Prv:String):Boolean;
begin
 Result:=False;
 If UpperCase(Prv)=UpperCase(FetchElm(RetNo,'PROFILE',99)) then
   result:=True;
end;

Function GetSpouseIncome(RetNo:Integer):Real;
begin
 Result:=0;
 //??
end;

Function GetPrvForTaxCredit(RetNo:Integer;Prv:String):Real;
begin
 Result:=0;
 //Result:=0;
 //??
end;

Function CalcPrvMedicalLimit(RetNo:Integer):Real;
begin
 Result:=0;
//
end;

Function GetPrvPolit(RetNo:Integer;Prv:String):Real;
begin
 Result:=0;
//
end;

Function GetPrvDisabXfer(RetNo:Integer):Real;
begin
 Result:=0;
//
end;

Function GetPrvEducXfer(RetNo:Integer):Real;
begin
 Result:=0;
//
end;

Function SplitIncome(RetNo:Integer):Boolean;
begin
//
end;

Function IsDeceased(RetNo:Integer):Boolean;
begin
//
end;

Function CalcMortgageForeclosure(V1,V2,V3:Real):Real;
begin
 Result:=0;
//
end;

Function GetPrvNetIncome(RetNo:Integer;Prv:String):Real;
begin
 Result:=0;
//
end;

Function AmountForPrvMinTax(RetNo:Integer):Real;
begin
 Result:=0;
//
end;

Function IsSpouseDeceased(RetNo:Integer):Boolean;
begin
//
end;

Function GetSpouseBirthDate(RetNo:Integer):String;
begin
//
end;

Procedure S1(RetNo:integer;FName:string;FNo:integer);
var i,k,K1: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
        Frm[FNo].Strings[63]:= WhichTaxForm(RetNo,Ret[RetNo].Province);
        {
        If UpperCase(FetchElm(RetNo,'DEPEND',161))='Y' then
         Frm[FNo].Strings[71]:= IntToStr(CountKidsUnder18(RetNo))
        else
         Frm[FNo].Strings[71]:= '';
        }

   //     ShowMessage('taxable in S1='+FormatFloat('#######.##',TaxRec.TaxableIncome));
        Tv[1]:=TaxRec.TaxableIncome;  //Vl(FetchElm(RetNo,'CASHFLOW',62));
        //20200314 taxable income  //Vl(FetchElm(RetNo,'CASHFLOW',62));
        {If (Province = 'ZZ') and (UpperCase(FetchElm(RetNo,'SNRESB',10)) = 'Y') then
         Tv[1] := MaxR(0,MaxR(Ln[260],Vl(FetchElm(RetNo,'SNRESA',18))));}
     //   If IsSection216(RetNo) then Tv[1]:=Vl(FetchElm(RetNo,'T1159_1',37));
        For i:= 2 to 22 do begin Frm[FNo].Strings[i]:='';Tv[i]:=0;end;
        For i:= 56 to 62 do begin Frm[FNo].Strings[i]:='';Tv[i]:=0;end;

        Frm[FNo].Strings[11] := Constant[RY].Rate1;
        Tv[17] := Constant[RY].BracketTax1; {0}
        Tv[6] := Constant[RY].Bracket1; {30754;}
        Frm[FNo].Strings[12] := Constant[RY].Rate2; {'22';}
        Tv[18] := Constant[RY].BracketTax2; {4921;}
        Tv[7] := Constant[RY].Bracket2; {61509;}
        Frm[FNo].Strings[13] := Constant[RY].Rate3; {'26';}
        Tv[19] := Constant[RY].BracketTax3; {11687;}
        Tv[57] := Constant[RY].Bracket3; {100000;}
        Frm[FNo].Strings[59] := Constant[RY].Rate4; {'29';}
        Tv[61] := Constant[RY].BracketTax4; {21694;}


        If Tv[1] <=Constant[RY].Bracket1 then {30754 then}
        begin
         Tv[2] := Tv[1];
         Tv[5]:=0;
         Tv[8] := MaxR(0,Tv[2]-Tv[5]);
         Frm[FNo].Strings[11] := Constant[RY].Rate1; {'16';}
         Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
         Tv[17] := Constant[RY].BracketTax1; {0}
         Tv[20] := Tv[14]+Tv[17];
        end;

        If (Tv[1] > Constant[RY].Bracket1)
        and (Tv[1] <= Constant[RY].Bracket2) then
        {If (Tv[1] > 30754) and (Tv[1] <= 61509) then}
        begin
         Tv[3] := Tv[1];
         Tv[6] := Constant[RY].Bracket1; {30754;}
         Tv[9] := MaxR(0,Tv[3]-Tv[6]);
         Frm[FNo].Strings[12] := Constant[RY].Rate2; {'22';}
         Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
         Tv[18] := Constant[RY].BracketTax2; {4921;}
         Tv[21] := Tv[15]+Tv[18];
        end;

        If (Tv[1] > Constant[RY].Bracket2) and
        (Tv[1] <=Constant[RY].Bracket3) then
        begin
         Tv[4] := Tv[1];
         Tv[7] := Constant[RY].Bracket2; {61509;}
         Tv[10] := MaxR(0,Tv[4]-Tv[7]);
         Frm[FNo].Strings[13] := Constant[RY].Rate3; {'26';}
         Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
         Tv[19] := Constant[RY].BracketTax3; {11687;}
         Tv[22] := Tv[16]+Tv[19];
        end;

        If Tv[1] > Constant[RY].Bracket3 then
        begin
         Tv[56] := Tv[1];
         Tv[57] := Constant[RY].Bracket3; {100000;}
         Tv[58] := MaxR(0,Tv[56]-Tv[57]);
         Frm[FNo].Strings[59] := Constant[RY].Rate4; {'29';}
         Tv[60] := Tv[58] * Vl(Frm[FNo].Strings[59])/100;
         Tv[61] := Constant[RY].BracketTax4; {21694;}
         Tv[62] := Tv[60]+Tv[61];
        end;

   {refndbl cr}

   Ln[300] := Constant[RY].BasicPersonalAmount * PartYear;
   Ln[301] := Vl(FetchElm(RetNo,'AGEDED',8));
     {CalcAgeEx(Age,Ln[236]) * PartYear;}
   If UpperCase(Frm[FNo].Strings[46]) ='Y' then Ln[301] := Tv[47];
//   Ln[303] := CalcSpousalClaim(RetNo,SpouseIncome(RetNo));
   Ln[367]:=  Vl(Frm[FNo].Strings[71]) * 2000;

   Ln[307] :=0;
  {305,306,308,310,312,314, in sch also  368, 369 in S10?}
   Tv[65]:=MinR(1127,Vl(FetchElm(RetNo,'CASHFLOW',5)));  //empl income  //20150226
   //Tv[65]:=MinR(1127,Ret[RetNo].Ln[101]+Ret[RetNo].Ln[104]);
   Ln[363]:=Tv[65];

   If Ret[RetNo].Province = 'QC' then
     Ln[375]:=MinR(237.12,TotMultiple(RetNo,'T4',44))
   else Ln[375]:=0;
   Tv[66]:=Vl(FetchElm(RetNo,'PTRANSIT',2));
   //Vl(FetchElm(RetNo,'PTRANSIT',78)) * Vl(FetchElm(RetNo,'PTRANSIT',79))/100;
   Ln[364]:=Tv[66];
   Tv[73]:=Vl(FetchElm(RetNo,'FITNESS',3));
   Ln[365]:=Tv[73];
//   Ln[314]:=  GetLn314(RetNo);
   Ln[315] := Vl(FetchElm(RetNo,'S5',90)); //not 39
   Ln[319] :=Vl(FetchElm(RetNo,'STLOAN',40));
   //Vl(FetchElm(RetNo,'DIRECT',15));
   If Ret[RetNo].Age >=18 then
    Ln[316] := Vl(FetchElm(RetNo,'DISAB18',1))
   else
    Ln[316] := Vl(FetchElm(RetNo,'DISAB18',11));
   Ln[318] := Vl(FetchElm(RetNo,'DISAB',71)) * Vl(FetchElm(RetNo,'DISAB',69))/100;
   Ln[320]  := Vl(FetchElm(RetNo,'S11',1));
   Ln[321]  := Vl(FetchElm(RetNo,'S11',34));
   Ln[322]  := Vl(FetchElm(RetNo,'S11',41));
   Ln[327]  := Vl(FetchElm(RetNo,'S11',10));
   Ln[323]  := Vl(FetchElm(RetNo,'S11',21));
   Ln[313]  := TotMultiple(RetNo,'ADOPT',66);
   Ln[324] := Vl(FetchElm(RetNo,'DISAB',72)) * Vl(FetchElm(RetNo,'DISAB',70))/100;;
   {326 in sch}
   Ln[330] := Vl(FetchElm(RetNo,'MEDICAL',112));
   //ln 331 in
   Tv[48] := Vl(FetchElm(RetNo,'MEDICAL',160)); //MaxR(0,Tv[41] - Tv[42]);
   Tv[49] := LN[331];
   Tv[50]:= Tv[48]+Tv[49];

 //  If Bankrupt = 3 then {trustee}  for i:=300 to 332 do Ln[i] :=0;

   Tv[70]:= LN[300]+ LN[301]+ LN[303]+ LN[305]+ LN[306]+
              + LN[308]+ LN[310]+ LN[312]
              + Ln[375]+Ln[376]+Ln[378]
              + Ln[363]+Ln[364]+Ln[365]+Ln[367]
              + Ln[313]+ LN[314]+ LN[315]+ LN[316]
              + LN[318]+ LN[319]+LN[323]+ LN[324]+ LN[326];

   Ln[335]:=Tv[70]+Tv[50]; //Ln[332]; ??
   LN[338] := Ln[335] * Vl(Constant[RY].Rate1)/100; //0.15;
   Ln[337] := Vl(FetchElm(RetNo,'S9',4));
   Ln[339] := Vl(FetchElm(RetNo,'S9',5));
   Ln[340] := Vl(FetchElm(RetNo,'S9',9));
   Ln[342] := Vl(FetchElm(RetNo,'S9',10));
   Ln[345] := Vl(FetchElm(RetNo,'S9',12));
   Ln[346] := Vl(FetchElm(RetNo,'S9',13));
   Ln[347] := Vl(FetchElm(RetNo,'S9',14));
   Ln[348] := Vl(FetchElm(RetNo,'S9',15));
   Ln[349] := Vl(FetchElm(RetNo,'S9',17));
   Ln[350] := Ln[338]+Ln[349];

   {move}
   TV[23] := Ln[300];
   Tv[24] := Ln[301];
   Tv[25] := Constant[RY].SpousalBase * PartYear;
//   Tv[26] := SpouseIncome(RetNo);
   Tv[75] := Constant[RY].BasicPersonalAmount;
   Tv[74]:=Vl(FetchElm(RetNo,'S5',8));
   //Tv[27] := Ln[303];
   Tv[28] := Ln[303];
   Tv[29] := LN[305];
   Tv[72] := Ln[367];
   Tv[30] := LN[306];
   Tv[31] := LN[308];
   Tv[32] := LN[310];
   Tv[33] := LN[312];
   Tv[65]:=  Ln[363];
   Tv[66]:=  Ln[364];
   Tv[67]:=  Ln[375];
   Tv[68]:=  Ln[376];
   Tv[69]:=  Ln[378];
   Tv[64] := Ln[313];
   Tv[34] := LN[314];
   Tv[40] := Ln[315];
   Tv[35] := LN[316];
   Tv[36] := LN[318];
   Tv[43] := Ln[319];
   Tv[37] := Ln[323];  {? new combined line}
   Tv[38] := LN[324];
   Tv[39] := LN[326];
   Tv[41] := LN[330];
//   Tv[42] := CalcMedicalLimit(RetNo);
   Tv[48] := Vl(FetchElm(RetNo,'MEDICAL',160)); //MaxR(0,Tv[41] - Tv[42]);
   Tv[49] := LN[331];
   Tv[50]:= Tv[48]+Tv[49];
   Tv[51]:=Tv[50];
   Ln[332]:=Tv[50];
   Tv[52] := LN[335];
   TV[53] := Ln[338];
   Tv[54] := Ln[349];
   Tv[55] := Ln[350];

//SECOND PAGE ----------------------------------------------------------------------------------------

     Frm[FNo].Strings[135]:= ReplaceChar(WhichTaxForm(RetNo,Ret[RetNo].Province),'1','2');
     Tv[101] := MaxR(MaxR(Tv[20],Tv[62]),MaxR(Tv[21],Tv[22]));  //MaxR(MaxR(Vl(FetchElm(RetNo,'S1',20)),Vl(FetchElm(RetNo,'S1',62))),
                                                                    //MaxR(Vl(FetchElm(RetNo,'S1',21)),Vl(FetchElm(RetNo,'S1',22))));
     If SplitIncome(RetNo) then
       TV[102] := Vl(FetchElm(RetNo,'T1206_1',4))
     else
       Tv[102] :=0;

     Tv[132] := Tv[101] + Tv[102];
     Tv[103]:=Tv[132];
     If UpperCase(Frm[FNo].Strings[134]) <> 'Y' then
     begin
       If Province = 'ZZ' then
         Tv[104] := Vl(FetchElm(RetNo,'SNRESB',11))
       else
         Tv[104] := Ln[350];
       If UpperCase(FetchElm(RetNo,'INFO',73)) = 'X' then Tv[104]:=0;
     end
     else
      Tv[104]:= Tv[133];
     Tv[105]:=Vl(FetchElm(RetNo,'DTC',17));
//     Tv[130] := GetOverseasCredit(RetNo);
     Tv[106] :=Vl(FetchElm(RetNo,'T691_4',21));
//     If Bankrupt = 2 {post bankrpt} then Tv[106] :=0;
     Tv[107] := Vl(FormatFloat('#######.00',Tv[104] + Tv[105] + Tv[130]+Tv[106]));
     Tv[108] := Tv[107];

     Tv[109] := MaxR(0,Tv[103] - Tv[108]);

     {non-resident surtax}
     If Province = 'ZZ' then  {non-resident}
       Tv[110] := Tv[109] * 0.48
     else  {canadian resident}
       Tv[110] :=0;
//     If IsMultJurisdiction(RetNo) then Tv[110] := Vl(FetchElm(RetNo,'T2203_2',7));

     Tv[111] := Tv[109] + Tv[110];

     Tv[112] := Vl(FetchElm(RetNo,'FORINC',158))+
                  Vl(FetchElm(RetNo,'FORINC',160))+
                  Vl(FetchElm(RetNo,'FORINC',162));
     Tv[113] := Vl(FetchElm(RetNo,'FORINC',157))+
                  Vl(FetchElm(RetNo,'FORINC',159))+
                  Vl(FetchElm(RetNo,'FORINC',161));
     If Tv[112] =0 then Tv[113] :=0; {no for tax, no for inc}
     Tv[116] := Ln[236]+Vl(FetchElm(RetNo,'T1206_1',3))
       - (Ln[253] + Ln[248] +Ln[249] + Ln[250] + Ln[254]
       +Vl(FetchElm(RetNo,'OTHDED',22)));  //line added in sept 12 2005
     Tv[114] := Vl(FetchElm(RetNo,'T2209#1',3)); //fed tax
     If Tv[116]>0 then
        Tv[115] := Tv[113]* Tv[114]/Tv[116]
     else
        Tv[115]:=0;

     Tv[117] := TotMultiple(RetNo,'T2209',18);
     Tv[118] := MaxR(0,(Tv[111] - Tv[117]));
   {  Tv[118] := MaxR(0,(Tv[111] - Tv[117]
            -FedLoggingTaxCredit(RetNo,
           Vl(FetchElm(RetNo,'DIRECT',10))+Vl(FetchElm(RetNo,'DIRECT',12)),
           Vl(FetchElm(RetNo,'DIRECT',11))+Vl(FetchElm(RetNo,'DIRECT',13)))));
    }
    Tv[119] :=Vl(FetchElm(RetNo,'POLIT',6)); //total contr //Vl(FetchElm(RetNo,'POLIT',20));
  //  Tv[120] := GetFedPolCredit(RetNo,Tv[119]);
  //  Tv[121] := Vl(FetchElm(RetNo,'T2038',143))+Vl(FetchElm(RetNo,'T2038',125))+ T3ITC; {Apr 29, 2002}
//    If (Bankrupt = 1) or (Bankrupt = 2) {pre and post} then Tv[121] :=0;
    Tv[122] := Vl(FetchElm(RetNo,'LABORSP',3)); {only after march 5,1996}
    Tv[123] := Vl(FetchElm(RetNo,'LABORSP',4)); {MinR(1000,LaborSpFedCredit);}
    Tv[124] := Tv[120]+Tv[121]+Tv[123];
    Tv[125]:=Tv[124];

    Tv[126] := MaxR(0, Tv[118]- Tv[125]);
    {
    If SubjectToMinTax(RetNo) then Tv[126] := Vl(FetchElm(RetNo,'T691_3',13))
    else
    begin
      If SplitIncome(RetNo) then
        Tv[126] := Vl(FetchElm(RetNo,'T1206_1',12))
      else
        Tv[126] := MaxR(0, Tv[118]- Tv[125]);
    end;
    }
//    Tv[131]:=Vl(FetchElm(RetNo,'SNRC_2',7));
//    If IsSection217(RetNo)=False then Tv[131]:=0;

    Tv[129]:=MaxR(0,Tv[126]-Tv[131]);
    If Vl(FetchElm(RetNo,'T1172_2',11)) <>0 then
      Tv[127]:= Vl(FetchElm(RetNo,'T1172_2',11))
    else
      Tv[127]:= Vl(FetchElm(RetNo,'T1172_2',14));

    If Ret[RetNo].Province = 'QC' then
      Tv[127]:= Vl(FetchElm(RetNo,'T1172_2',19));

    Tv[128] := Tv[129]+Tv[127];
    Ln[424] := Tv[102];
    Ln[425] := Tv[105];
    Ln[426] := Tv[130];
    Ln[427] := Tv[106];
   // Ln[431] := Tv[112];
   // Ln[433] := Tv[113];
    Ln[429] := Tv[109];
    Ln[445] := Tv[131];

    Ln[406]:=Tv[118];
    Ln[409]:=Tv[119];
    Ln[410]:=Tv[120];
    Ln[412]:=Tv[121];
    Ln[413]:=Tv[122];
    Ln[414]:=Tv[123];
    Ln[416]:=Tv[125];
    Ln[417]:=Tv[126];
    Ln[418]:=Tv[127];
    Ln[420]:=Tv[128];
  end;
  SaveTv(RetNo,FName,FNo);
end;



end.
