unit FP_2027calc1;
interface
uses
 SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  StdCtrls,Dialogs,DBctrls,ExtCtrls,FileCtrl,Math;

 Procedure LIFEEVENTS(RetNo: integer; FName: String;FNo: integer);
 Procedure INCPROJECTION(RetNo: integer; FName: String;FNo: integer);
 Procedure GENOBJ(RetNo: integer; FName: String;FNo: integer);
 Procedure CashFlow(RetNo: integer; FName: String;FNo: integer);
 Procedure PCashFlow(RetNo: integer; FName: String;FNo: integer);
 Procedure PInvPln(RetNo: integer; FName: String;FNo: integer);
 Procedure PRRSP(RetNo: integer; FName: String;FNo: integer);
 //Procedure PFIXA(RetNo: integer; FName: String;FNo: integer);
 Procedure PNETW(RetNo: integer; FName: String;FNo: integer);
 Procedure PLIAB(RetNo: integer; FName: String;FNo: integer);
 Procedure PSMINV(RetNo: integer; FName: String;FNo: integer);

 Procedure T1LINK(RetNo: integer; FName: String;FNo: integer);
 Procedure EDUPLN(RetNo: integer; FName: String;FNo: integer);
 Procedure GOALS(RetNo: integer; FName: String;FNo: integer);
 Procedure GOALSR(RetNo: integer; FName: String;FNo: integer);

 Procedure CalcEduBalances(
  Contribution:Real;
  WithDrawal:Real;
  Interest:Real;
  n:Integer;
  StartContrYear:Integer;
  StartEduYear:Integer;
  StartCap:Real;
  CESGInclude : String;
  StudentContrEntered:Real;
  Var Years:Array of Integer;
  Var BegCap:Array of real;
  Var AnnualContr:Array of real;
  Var InterestOnInv:Array of real;
  Var StudentContr:Array of real;
  Var CESG:Array of real;
  Var EduCost:Array of real;
  Var EndCap:Array of real);

 Procedure CommonAccumForm(RetNo: integer; FName: String;FNo: integer);
 procedure T2033_1(RetNo: integer; FName: string; FNo: integer);
 procedure T2151_1(RetNo: integer; FName: string; FNo: integer);
 procedure T2220_1(RetNo: integer; FName: string; FNo: integer);
 procedure EFORM(RetNo: integer; FName: string; FNo: integer);
 procedure TD2(RetNo: integer; FName: string; FNo: integer);
 procedure T1058(RetNo: integer; FName: string; FNo: integer);
 procedure T1036_1(RetNo: integer; FName: string; FNo: integer);
 procedure T3012_1(RetNo: integer; FName: string; FNo: integer);
 procedure T2097(RetNo: integer; FName: string; FNo: integer);
 procedure PASSSUM(RetNo: integer; FName: string; FNo: integer);
 procedure ASSUME(RetNo: integer; FName: string; FNo: integer);


 procedure PresVal(RetNo: integer; FName: string; FNo: integer);
 procedure FutVal(RetNo: integer; FName: string; FNo: integer);

 procedure TXSUM_1(RetNo: integer; FName: string; FNo: integer);
 procedure TXSUM_2(RetNo: integer; FName: string; FNo: integer);

 procedure PSHELT(RetNo: integer; FName: string; FNo: integer);
 procedure PNONSH(RetNo: integer; FName: string; FNo: integer);
 procedure PSEMSH(RetNo: integer; FName: string; FNo: integer);
 procedure POTHER(RetNo: integer; FName: string; FNo: integer);
 procedure RETPLAN(RetNo: integer; FName: string; FNo: integer);
 procedure CHACCUM(RetNo: integer; FName: string; FNo: integer);
 procedure PEVENTS(RetNo: integer; FName: string; FNo: integer);
 procedure ACKNLDG(RetNo: integer; FName: string; FNo: integer);
 procedure SUMOBJ(RetNo: integer; FName: string; FNo: integer);
 procedure INSNEED(RetNo: integer; FName: string; FNo: integer);
 procedure DISABLT(RetNo: integer; FName: string; FNo: integer);
 procedure CRITILL(RetNo: integer; FName: string; FNo: integer);
 procedure ANNINC(RetNo: integer; FName: string; FNo: integer);
 procedure INVESTSTRATEGY(RetNo: integer; FName: string; FNo: integer);
 procedure WILLS(RetNo: integer; FName: string; FNo: integer);

 procedure ORD_1(RetNo: integer; FName: string; FNo: integer);
 procedure ORD_2(RetNo: integer; FName: string; FNo: integer);
 procedure ORD_3(RetNo: integer; FName: string; FNo: integer);
 procedure ORD_4(RetNo: integer; FName: string; FNo: integer);


implementation
Uses vtMulti,vtCommon,FP_2027,FP_2027Declare,FP_2027common,FP_2027common2,
  FP_2027TrimStr,FP_2027CalcTax,FP_2027Calc,vtTrimStr,vtShared;
 {---------------  procedures  ----------------}
Procedure ACKNLDG(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    Strings[20] := HoRec.BusinessName;
    Strings[21] := HoRec.Street;
    Strings[22] := HoRec.City;
    Strings[23] := HoRec.Province;
    Strings[24] := HoRec.Postal;
    Strings[25] := HoRec.Phone;
    Strings[26] := HoRec.Fax;

    {Rep}
    Strings[7] := User.Code; //20170112 Igor
    Strings[9] := User.Prep_Name; //20170112 Igor
    Strings[11] := User.PREP_INTLS; //20170112 Igor

    Strings[5] :=DateToMonthDayYear(Date);
    Strings[6] := ClientLastName(retNo)+', '+ ClientFirstName(RetNo);
    Strings[10] := FetchElm(RetNo,'PROFILE',5);
    Strings[12] := FetchElm(RetNo,'PROFILE',6);
    Strings[14] := FetchElm(RetNo,'PROFILE',8)+
                   ', '+FetchElm(RetNo,'PROFILE',12);

    Strings[17] := HoRec.BusinessName;
    Strings[18] := Strings[17];
    Strings[19] := Strings[17];
    Strings[15] := Strings[17];
    Strings[16] := Strings[17];
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure SUMOBJ(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
       FillHeader(RetNo,FNo,2,1);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure INSNEED(RetNo: integer; FName: String;FNo: integer);
Var I:integer; ClientDeathShortFall,SpouseDeathShortFall:real;
     TaxRate,Interest,EffectiveInterest,Amount:Real;
     Years:Integer;
     Prv:String;

begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     FillHeader(RetNo,FNo,1,2);
     If Strings[20]='' then strings[20]:='Y';  //pay off mortgages
     Tv[5] := Vl(FetchElm(RetNo,'NETWORTH',66))+
              Vl(FetchElm(RetNo,'NETWORTH',67));
     Prv:=FetchElm(RetNo,'PROFILE',99);
     Tv[19] := CalcProbate(Vl(FetchElm(RetNo,'NETWORTH',24)),PRV);
     Tv[21] := Vl(FetchElm(RetNo,'NETWORTH',21));
     If UpperCase(Strings[20]) ='Y' then         //mortgages
      Tv[18]:=Vl(FetchElm(RetNo,'NETWORTH',25))
             +Vl(FetchElm(RetNo,'NETWORTH',54))
             +Vl(FetchElm(RetNo,'NETWORTH',86))
     else
      Tv[18]:=0;

     Tv[23] := Vl(FetchElm(RetNo,'LIVINGEXP_2',123))/2;

     Tv[39] := Tv[3]+Tv[5]+Tv[9]+Tv[13]
              +Tv[15]+Tv[17]+Tv[19]+Tv[18]+Tv[21]+Tv[23]
              +Tv[26]+Tv[29]+Tv[32]+Tv[35]+Tv[37];

     {cash sources}
     Tv[12] :=  Tv[42]+Tv[44]+Tv[46]+Tv[48]+Tv[50];
     Tv[14] :=  Tv[43]+Tv[45]+Tv[47]+Tv[49]+Tv[51];
     Tv[52] := Tv[81]+Tv[12];
     Tv[53] := Tv[81]+Tv[14];

     ClientDeathShortFall := MaxR(0,Tv[39]-Tv[52]);
     SpouseDeathShortFall := MaxR(0,Tv[39]-Tv[53]);


     If Tv[10]=0 then Tv[10] := 12;

     Tv[7] := MyPresentValue(ClientDeathShortFall,MyStrToInt(Strings[11]),Tv[10]);
     Tv[8] := MyPresentValue(SpouseDeathShortFall,MyStrToInt(Strings[16]),Tv[10]);

     Tv[4] := Tv[39]+Tv[7];
     Tv[6] := Tv[39] + Tv[8];

     {Cash sources}
     Tv[81] :=  Vl(FetchElm(RetNo,'NETWORTH',9));
     Tv[46] := LifeInsuranceRec.SpouseCoverage;
     Tv[47] := LifeInsuranceRec.SelfCoverage;

     {Insurance Short fall}
     Tv[54] := Tv[52]-Tv[4];
     Tv[55] := Tv[53]-Tv[6];
     If Tv[54] <0 then Tv[59] := ABS(Tv[54]) else Tv[59] :=0;
     If Tv[55] <0 then Tv[60] := ABS(Tv[55]) else Tv[60] :=0;
     If Tv[59] >0 then Tv[59] := Trunc(Tv[59]/50000)*50000 +50000;
     If Tv[60] >0 then Tv[60] := Trunc(Tv[60]/50000)*50000 +50000;
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



Procedure ANNINC(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     FillHeader(RetNo,FNo,3,1);
     Strings[7]:=ClientFirstName(RetNo);
     Strings[139]:=Strings[7];
     Strings[140]:=Strings[7];
     Strings[8]:=SpouseFirstName(RetNo);
     Strings[11]:=Strings[7];
     Strings[12]:=Strings[8];
     Strings[21]:=Strings[7];
     Strings[22]:=Strings[8];

     //income needs
     Tv[4] := Vl(FetchElm(RetNo,'LIVINGEXP_2',121));
     Tv[5] := Vl(FetchElm(RetNo,'LIVINGEXP_2',122));
     Tv[6] := Vl(FetchElm(RetNo,'LIVINGEXP_2',123));
     {convert to before tax}
     Tv[2]   := ConvertToBeforeTax(Tv[4],CalcAfterToBeforeFactor(Tv[4]));
     Tv[118] := ConvertToBeforeTax(Tv[5],CalcAfterToBeforeFactor(Tv[5]));
     Tv[119] := ConvertToBeforeTax(Tv[6],CalcAfterToBeforeFactor(Tv[6]));

     //cpp benefits
     If Tv[9]=0 then Tv[9]:=Vl(FetchElm(RetNo,'ASSUME',7));
     If Ret[RetNo].MarStatus <3 then
     begin
       If Tv[10]=0 then Tv[10]:=Vl(FetchElm(RetNo,'ASSUME',7));
     end;

     //oas
     If Tv[39]=0 then Tv[39]:=Vl(FetchElm(RetNo,'ASSUME',5));
     If Ret[RetNo].MarStatus <3 then
     begin
       If Tv[40]=0 then Tv[40]:=Vl(FetchElm(RetNo,'ASSUME',5));
     end;

     Tv[64] := Vl(FetchElm(RetNo,'DISABLT',83)) * 12;
     //Tv[120]:=  Vl(FetchElm(RetNo,'CRITILL',83)) * 12;   ??
     Tv[65] := Vl(FetchElm(RetNo,'DISABLT',85)) * 12;
     //Tv[121]:= Vl(FetchElm(RetNo,'CRITILL',85)) * 12;    ??

     Tv[88] := Tv[82]+Tv[25]+Tv[94]+Tv[13]
              +Tv[64]+Tv[107]+Tv[120]+Tv[104]
              +Tv[70]+Tv[76]+Tv[129]
              +Tv[44]+Tv[51]+Tv[58];
      Tv[89] := Tv[83]+Tv[26]+Tv[95]+ Tv[16]
               +Tv[65]+Tv[109]+Tv[121]+Tv[105]
               +Tv[71]+Tv[77]+Tv[130]+Tv[45]+Tv[52]+Tv[59];

     Tv[90] := Tv[84]+Tv[27]+Tv[96]+Tv[112]+Tv[33]+
               +Tv[39]+Tv[9]+Tv[100]+Tv[66]+Tv[110]+Tv[122]
               +Tv[106]+Tv[72]+Tv[78]+Tv[131]+Tv[46]+Tv[53]+Tv[60];

     Tv[91] := Tv[85]+Tv[28]+Tv[97]+Tv[117]+Tv[34]+Tv[40]+Tv[10]
     +Tv[101]+Tv[67]+Tv[111]+Tv[123]+Tv[126]+Tv[73]+Tv[79]+Tv[132]
                +Tv[47]+Tv[54]+Tv[61];

     Tv[92] := Tv[86]+Tv[29]+Tv[98]+Tv[137]+Tv[35]
               +Tv[41]+tv[17]+Tv[23]
               +Tv[68]+Tv[113]+Tv[124]+Tv[127]+Tv[74]+Tv[80]+Tv[133]
               +Tv[48]+Tv[55]+Tv[62];

     Tv[93] := Tv[87]+Tv[30]+Tv[99]+Tv[138]+Tv[36]+Tv[42]
               +Tv[18]+Tv[24]+Tv[69]+Tv[115]+Tv[125]+Tv[128]+Tv[75]+Tv[81]
               +Tv[134]+Tv[49]+Tv[56]+Tv[63];

     Tv[135]:=Tv[88]+Tv[89];
     Tv[108] := Tv[90]+Tv[91];
     Tv[136]:=Tv[92]+Tv[93];

     Tv[19]  := Tv[135]-Tv[2]; //Tv[88] - Tv[2];
     //Tv[112] := Tv[89] - Tv[2];   //??
     Tv[114] := Tv[108]-Tv[118];
     Tv[116] := Tv[136]-Tv[119]; //Tv[92]-Tv[119];
     {after tax}
     Tv[20] := Tv[19]  * BeforeToAfterTaxRate(Tv[4],Tv[2]);
     Tv[14] := Tv[114] * BeforeToAfterTaxRate(Tv[5],Tv[118]);
     Tv[15] := Tv[116] * BeforeToAfterTaxRate(Tv[6],Tv[119]);

   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure INVESTSTRATEGY(RetNo: integer; FName: String;FNo: integer);
Var I:integer; DedLimit1,DedLimit2,TotInv,TotDisp:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   FillHeader(RetNo,FNo,1,2);
    //alloc disp income        /20130804
   Tv[8]:= vl(FetchElm(RetNo,'CASHFLOW',73));
   Tv[65]:=Tv[1]+Tv[2]+Tv[49]+Tv[53];
   Tv[66]:=Tv[54]+Tv[55]+Tv[56]+Tv[57];
   Tv[58]:=Tv[65]+Tv[66];
   Tv[21]:=MaxR(0,Tv[8]-Tv[58]);

   //20130804
   //RRSP
   If Tv[60]>Tv[59] then Tv[60]:=Tv[59];
   If Tv[63]>Tv[62] then Tv[63]:=Tv[62];
   Tv[52]:=Tv[60]+Tv[63];
   Tv[64]:=MaxR(0,Tv[21]-Tv[52]);

  (*
   {Allocate}
   Tv[23] := MinR(LifeInsuranceRec.AnnualPremium,Tv[8]);
   Tv[16]:=Tv[9]+Tv[23];
   Tv[17]:=Tv[16];
   Tv[21]:=MaxR(0,Tv[8]-Tv[17]);
   If Tv[8]<=0 then
   begin
    Tv[9]:=0;Tv[23]:=0;Tv[16]:=0;Tv[17]:=0;Tv[21]:=0;
   end;
   //rrsp
   Strings[19]:=ClientFirstName(RetNo);
   Strings[20]:=SpouseFirstName(RetNo);
   Strings[24]:=IntToStr(65-ClientAge(RetNo));
   If Vl(Strings[24])<0 then Strings[24]:='0';
   If Strings[20]>'' then Strings[27]:=IntToStr(65-SpouseAge(RetNo));
   If Vl(Strings[27])<0 then Strings[27]:='0';
   Tv[34]:=Tv[6]*0.18;
   Tv[35]:=Tv[7]*0.18;
   Tv[36]:=GetDollarLimit(StrToInt(AppYear));
   Tv[37]:=GetDollarLimit(StrToInt(AppYear));
   Tv[38]:=MinR(Tv[34],Tv[36]);
   Tv[39]:=MinR(Tv[35],Tv[37]);
   If (UpperCase(Strings[18])<>'Y') then
   begin
    Tv[14]:=MaxR(0,Tv[38]-Tv[40])+Tv[4];
    Tv[15]:=MaxR(0,Tv[39]-Tv[41])+Tv[5];
   end;
   Tv[25]:=Tv[14]+Tv[15];  //Max RRSP

   If (Strings[44]='') and (Tv[46]=0) then Strings[44]:='X';
   If (Strings[45]='') and (Tv[47]=0) then Strings[45]:='X';

   If TV[46]>0 then Strings[44]:='';
   If TV[47]>0 then Strings[45]:='';

   If Ret[RetNo].MarStatus >2 then
   begin
    Strings[20]:='';
    Strings[27]:='';
    Tv[7]:=0;
    Tv[35]:=0;
    Tv[37]:=0;
    Tv[39]:=0;
    Tv[41]:=0;
    Tv[5]:=0;
    Tv[15]:=0;
   end;

   DedLimit1:=Tv[14];
   DedLimit2:=Tv[15];
   TotInv:=Tv[21];

   If TotInv <=0 then //none available for investments
     begin Tv[50]:=0;Tv[51]:=0;Tv[52]:=0;end;

   If UpperCase(Strings[44]) = 'X' then Tv[50]:= MinR(DedLimit1,TotInv)
   else If Tv[46]>0 then Tv[50]:=MinR(Tv[46],MinR(DedLimit1,TotInv));
   If UpperCase(Strings[45]) = 'X' then Tv[51]:= MinR(DedLimit2,TotInv-TV[50])
   else If Tv[47]>0 then Tv[51]:=MinR(Tv[47],MinR(DedLimit2,TotInv-Tv[50]));

   If ClientAge(RetNo) > 69 then Tv[50]:=0; //years of remaining contr
   If SpouseAge(RetNo) > 69 then Tv[51]:=0;

   Tv[52]:=Tv[50]+Tv[51];
   //If Tv[52]=0 then Tv[22]:=TotInv;
   Tv[42]:=TotInv;
   //If (Tv[52]>0) and (Tv[26]+Tv[33]=0) then Tv[22]:=TotInv-(Tv[52]+Tv[22]+Tv[26]+Tv[33]);
   Tv[22]:=TotInv-Tv[52]-Tv[26]-Tv[33];
   //future years
   If Strings[43]+Strings[48]='' then Strings[43]:='X';

   If UpperCase(Strings[48])='X' then //option 2 in effect
   begin
    If UpperCase(Strings[10])='X' then Tv[11]:=0;
    If Tv[11]>0 then Strings[10]:='';
    If Tv[12]+Tv[13]+Tv[28]=0 then Tv[12]:=100;
    If Tv[12]>100 then Tv[12]:=100;
    If Tv[13]>100 then Tv[13]:=100;
    If Tv[28]>100 then Tv[28]:=100;
    Tv[12]:=100-Tv[13]-Tv[28];

    //remove option1
    Strings[43]:='';
    For i:=29 to 32 do Tv[i]:=0;
    Tv[3]:=0;
   end
   Else    //option 1 in effect
   begin
    Tv[3]:=100;
    For i:=30 to 32 do begin If Tv[i]>100 then Tv[i]:=100;end;
    Tv[29]:=Tv[3]-Tv[30]-Tv[31]-Tv[32];
    //remove option2
    Strings[10]:='';
    For i:=11 to 13 do Tv[i]:=0;
    Tv[28]:=0;
   end;
  *)
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure GENOBJ(RetNo: integer; FName: String;FNo: integer);
Var I:integer; LeftOver:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   FillHeader(RetNo,FNo,1,2);
   //Strings[3] := AppYear;
   Strings[11] := HoRec.BusinessName;

  (*
   Tv[4] := MinR(13500,Tv[4]);
   Tv[5] := MinR(13500,Tv[5]);
   Tv[12] := MaxR(0,Tv[8]-Tv[10]);
   {spouse}
   Tv[13] := MaxR(0,Tv[9]-Tv[11]);
   {both}
   Tv[20] := Tv[8]-Tv[10]-Tv[14]+Tv[16]+Tv[18]
            +Tv[9]-Tv[11]-Tv[15]+Tv[17]+Tv[19];
   Tv[21] := Vl(FetchElm(RetNo,'LIVINGEXP_2',130));
   Tv[45] := Tv[20]-Tv[21];

   If Tv[45] >0 then   //there is disp income
   Begin
    {Allocate}
     If UpperCase(Strings[51]) <> 'Y' then
     begin
      Tv[22] := MinR(Tv[45],Vl(FetchElm(RetNo,'NETWORT',20))); {current liabilities?}
      Tv[23] := LifeInsuranceRec.AnnualPremium;
     end;
     Tv[24] := Tv[45] -Tv[22]-Tv[23];
     If Tv[22]= Tv[45] then
     begin Tv[23]:=0;Tv[24] :=0;end;
   end;
  *)
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure CHACCUM(RetNo: integer; FName: String;FNo: integer);
Var AccFNo:integer;
begin
  AccFNo := GetFormNo('RETPLAN');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,1,2);
    Strings[3]   := FetchElmFNo(RetNo,AccFNo,70);
    Tv[4]   := Vl(FetchElmFNo(RetNo,AccFNo,45));
    Tv[5]   := Vl(FetchElmFNo(RetNo,AccFNo,46));
    Tv[6]   := Vl(FetchElmFNo(RetNo,AccFNo,47));
   end;
  SaveTv(RetNo,FName,FNo);
end;
                                        

Procedure RETPLAN(RetNo: integer; FName: String;FNo: integer);
Var I,J,RetAge,years,FNoAssume:integer;
   Amount,TaxRate,Interest,Inflation,EffectiveInterest:Real;
   RemainingforInvest:Real;
   RemainingAfterShelt:Real;
   DispIncome:Real;

begin
Try
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,1,2);
    //20150227
    If Strings[6]='' then Strings[6]:='65';
    If Strings[8] ='' then Strings[8]:='90';  //ultimate age

    If Strings[5]>'' then //spouse exists
    Begin
     If Strings[7]='' then Strings[7]:='65';
     If Strings[9] ='' then Strings[9]:='90';  //ultimate age
    end;

    StoreElm(RetNo,GetFormNo('GOALS'),4,Strings[6]); //retirement age
    StoreElm(RetNo,GetFormNo('GOALS'),10,Strings[7]); //spouse ret age
    StoreElm(RetNo,GetFormNo('GOALS'),6,Strings[8]); //ultimate age
    StoreElm(RetNo,GetFormNo('GOALS'),12,Strings[9]);
    

    Strings[4]   := IntToStr(ClientAge(RetNo));
    Strings[6] := IntToStr(ClientAgeAtRetirement(RetNo));
    If Vl(Strings[8]) < Vl(Strings[6])  then Strings[8]:=Strings[6]; //20150227
    Strings[8] := IntToStr(ClientUltimateAge(RetNo));
    Strings[10]  := IntToStr(ClientYearsToRetirement(RetNo));
    Strings[12]  := IntToStr(ClientRetirementYears(RetNo));
    Strings[5] :='';
    Strings[11]:='';Strings[13]:='';

    If SpouseAge(RetNo) >0 then
    begin
     Strings[5]  := IntToStr(SpouseAge(RetNo));
     Strings[7]  := IntToStr(SpouseAgeAtRetirement(RetNo));
     Strings[9]  := IntToStr(SpouseUltimateAge(RetNo));
     Strings[11] := IntToStr(SpouseYearsToRetirement(RetNo));
     Strings[13] := IntToStr(SpouseRetirementYears(RetNo));
    end;
    For i:=10 to 13 do
      If Vl(Strings[i]) <0 then Strings[i] :='0';


    Tv[14] := GetInitialNonSh(RetNo);
    Tv[15] := GetInitialShelt(RetNo);
    Tv[17] := GetInitialSemSh(RetNo);
    Tv[16] := GetInitialOther(RetNo);

    Tv[19]:= MaxR(0,Tv[34]-Tv[20]-Tv[22]-Tv[21]);  //20140225

    //% 20140224
    For i:=63 to 66 do Tv[i]:=0;
    If Tv[34]>0 then
    Begin
     Tv[63]:= (Tv[19]/Tv[34]) * 100;
     Tv[64]:= (Tv[20]/Tv[34]) * 100;
     Tv[65]:= (Tv[22]/Tv[34]) * 100;
     Tv[66]:= (Tv[21]/Tv[34]) * 100;
     Tv[67]:= (Tv[23]/Tv[34]) * 100;
    end;

    {tax refund?}
    Tv[40] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',11));
    DispIncome := Vl(FetchElm(RetNo,'INVESTSTRATEGY',21));
    Tv[34]:=DispIncome;
    //20130804
    Tv[20]:=Vl(FetchElm(RetNo,'INVESTSTRATEGY',52));
    Tv[23] := Tv[19]+Tv[20]+Tv[22]+Tv[21];
    (*
    //20121019     //20130804
    If FetchElm(RetNo,'INVESTSTRATEGY',43) >'' then
    Begin
    Tv[19] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',30))*DispIncome/100;//nonshelt //If tv[19]=0 then Tv[19] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',30)); //20120611
    Tv[20] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',29))*DispIncome/100; //shelt
    Tv[22] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',31))*DispIncome/100; //semish
    Tv[21] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',32))*DispIncome/100;; //other
    Tv[23] := Tv[19]+Tv[20]+Tv[22]+Tv[21]; //total //Vl(FetchElm(RetNo,'INVESTSTRATEGY',18));  //20121019
    end
    Else
    Begin
     If FetchElm(RetNo,'INVESTSTRATEGY',10)>'' then
       Tv[20] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',52)) //shelt
     else
      Tv[20] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',11)); //shelt
     RemainingAfterShelt:=MaxR(0,DispIncome-Tv[20]);
     Tv[19] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',12))*RemainingAfterShelt/100;//nonshelt //If tv[19]=0 then Tv[19] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',30)); //20120611
     Tv[22] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',13))*RemainingAfterShelt/100; //semish
     Tv[21] := Vl(FetchElm(RetNo,'INVESTSTRATEGY',10))*RemainingAfterShelt/100; //other
     Tv[23] := Tv[19]+Tv[20]+Tv[22]+Tv[21]; //total //Vl(FetchElm(RetNo,'INVESTSTRATEGY',18));  //20121019
    end;
    *)
    Tv[30] :=AssetsSumRec.NonShYieldPercent;
    Tv[31] :=AssetsSumRec.SheltYieldPercent;
    Tv[32] :=AssetsSumRec.SemShYieldPercent;
    Tv[33] :=AssetsSumRec.OtherYieldPercent;

    {Horizontal}
    Tv[18]:=Tv[14]+Tv[15]+Tv[17]+Tv[16];

    If UpperCase(Strings[61]) <> 'Y' then
    begin
     If ClientMarginalRate(RetNo) > SpouseMarginalRate(RetNo) then
      Tv[29] := ClientMarginalRate(RetNo)
     else
      Tv[29] := SpouseMarginalRate(RetNo);
    end;

    //Tv[28] := Tv[20] * (Tv[29])/100;
   // Tv[25] := Tv[28] - Tv[24]-Tv[27]-Tv[26];

    //20130804
    {
    Tv[3] := Tv[19]+Tv[24];
    Tv[41] := Tv[20]+Tv[25];
    Tv[43] := Tv[22]+Tv[27];
    Tv[42] := Tv[21]+Tv[26];
    Tv[50] := Tv[23]+Tv[28];
    }

    If Tv[45]=0 then Tv[45] := Vl(FetchElm(RetNo,'ASSUME',15));  //nonsh
    If Tv[46]=0 then Tv[46] := Vl(FetchElm(RetNo,'ASSUME',16));  //sh
    If Tv[47]=0 then Tv[47] := Vl(FetchElm(RetNo,'ASSUME',17)); //semi
    If Tv[48]=0 then Tv[48] := Vl(FetchElm(RetNo,'ASSUME',18)); //other

    If Strings[34]='' then Strings[34]:='N';
    If Strings[34] = 'N' then
    begin
     Tv[45] := Vl(FetchElm(RetNo,'ASSUME',15));  //nonsh
     Tv[46] := Vl(FetchElm(RetNo,'ASSUME',16));  //sh
     Tv[47] := Vl(FetchElm(RetNo,'ASSUME',17)); //semi
     Tv[48] := Vl(FetchElm(RetNo,'ASSUME',18)); //other
    end;
    //save any changed rates to assumptions form
    StoreElm(RetNo,FNoAssume,15,FormatFloat('###.##',Tv[45]));
    StoreElm(RetNo,FNoAssume,16,FormatFloat('###.##',Tv[46]));
    StoreElm(RetNo,FNoAssume,17,FormatFloat('###.##',Tv[47]));
    StoreElm(RetNo,FNoAssume,18,FormatFloat('###.##',Tv[48]));


    Tv[55] := Tv[45] * (100-Tv[29])/100;
    Tv[56] := Tv[46];
    Tv[57] := Tv[47] * (100-Tv[29]* 0.75)/100;
    Tv[58] := Tv[48] * (100-Tv[29])/100;

    (*
    If ClientYearsToRetirement(RetNo) < SpouseYearsToRetirement(RetNo) then
      begin
         Strings[34] := IntToStr(ClientYearsToRetirement(RetNo));
         Strings[49] := ClientYearOfRetirement(RetNo);
      end
    else
      begin
         Strings[34] := IntToStr(SpouseYearsToRetirement(RetNo));
         Strings[49] := SpouseYearOfRetirement(RetNo);
      end;
    *)
    RetAge := MyStrToInt(Strings[6]);
    Tv[35] := GetEndBalanceByAge(RetNo,RetAge,'PNONSH'); {Ret[RetNo].PNonShBalance;}
    Tv[36] := GetEndBalanceByAge(RetNo,RetAge,'PSHELT'); {Ret[RetNo].PSheltBalance;}
    Tv[37] := GetEndBalanceByAge(RetNo,RetAge,'PSEMSH'); {Ret[RetNo].PSemShBalance;}
    Tv[38] := GetEndBalanceByAge(RetNo,RetAge,'POTHER'); {Ret[RetNo].POtherBalance;}

    If RetAge < ClientAge(RetNo) then
    begin
     Tv[35]:=Tv[14];
     Tv[36]:=Tv[15];
     Tv[37]:=Tv[17];
     Tv[38]:=Tv[16];
    end;
    Tv[39]:=Tv[35]+Tv[36]+Tv[37]+Tv[38];

    {cap at retirement}
    Tv[52] :=GetIncShortFall(RetNo);

    If Tv[53]=0 then Tv[53] := 12;

    Strings[54] := IntToStr(YearsOfPayout(RetNo));
    Amount := Tv[52];
    Years := MyStrToInt(Strings[54]);
    If Years <1 then Years:=1;
    Interest := Vl(Strings[53]);
    Inflation :=0;
   {Inflation := Vl(InflationBox.Text)/100;}
    TaxRate   :=GetRetirementTaxRate(RetNo);
      //CalcMarginalRate(Vl(FetchElm(RetNo,'INCNEED_2',122)));
    EffectiveInterest := (Interest * (100-TaxRate)/100)/100;
    Tv[59]:=EffectiveInterest * 100;
    If UpperCase(Strings[51]) <> 'Y' then  //20120611
     Tv[44]:=Math.PresentValue(EffectiveInterest,Years,-Amount,0,PtStartofPeriod);
    Tv[60]:=Tv[39]-Tv[44];
    If TV[60] >=0 then Strings[62]:='SURPLUS' else Strings[62]:='SHORTFALL';
   end; {End with}
  SaveTv(RetNo,FName,FNo);
  GetRetirementParms(RetNo);
except
 on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
end;

end;


Procedure WILLS(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
      FillHeader(RetNo,FNo,1,2);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure TXSUM_1(RetNo: integer; FName: String;FNo: integer);
var i, ElmNo, LineId: integer;Apt:string[12];
TaxSumList :TstringList;
begin
  LoadTv(RetNo,FName,FNo);  {needed for initialization}
 (*
  with Ret[RetNo].Frm[Fno] do
  begin

   For i := 1 to High(Tv) do TV[i] := 0;
   TaxSumList := TstringList.Create;
   TaxSumList.LoadFromFile(AppDir +'\'+ 'TAXSUM.D');
   Strings[2] := AllTrim(ClientFirstName(RetNo))+', '+AllTrim(ClientLastName(RetNo));
   Strings[11] := GetSinNo(RetNo);
   Strings[8]:=GetT1Year; //YearOfTaxData;
   For i := 0 to TaxSumList.Count-1 do
   begin
     ElmNo := MyStrToInt(LeftStr(TaxSumList[i],3));
     LineId := MyStrToInt(MidStr(TaxSumList[i],5,3));
     If (ElmNo>0) and (LineId>0) then TV[ElmNo] :=Ret[RetNo].LnTaxPayer[LineId];   //20110510 TV[ElmNo] :=Ret[RetNo].Ln[LineId];
   end;
  end; {End with}

  Taxsumlist.free;
  *)
  SaveTv(RetNo,FName,FNo);
 end;

Procedure TXSUM_2(RetNo: integer; FName: String;FNo: integer);
var i, ElmNo, LineId: integer;Apt:string[12];
TaxSumList :TstringList;
begin
  LoadTv(RetNo,FName,FNo);  {needed for initialization}
 (*
  with Ret[RetNo].Frm[Fno] do
  begin
   For i := 1 to High(Tv) do TV[i] := 0;
   TaxSumList := TstringList.Create;
   TaxSumList.LoadFromFile(AppDir +'\'+ 'TAXSUM.D');
    Strings[8]:=GetT1Year;
    Strings[2] :=  SpouseFirstName(RetNo)+', '+SpouseLastName(RetNo);
    If Strings[2] = ',' then strings[2] := '';
    Strings[11] := GetSpouseSinNo(RetNo);

    For i := 0 to TaxSumList.Count-1 do
     begin
     ElmNo := MyStrToInt(LeftStr(TaxSumList[i],3));
     LineId := MyStrToInt(MidStr(TaxSumList[i],5,3));
     TV[ElmNo] :=Ret[RetNo].LnSpouse[LineId];
    end;

  end; {End with}
  Taxsumlist.free;
 *)
  SaveTv(RetNo,FName,FNo);
 end;

Procedure PresVal(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin

    TV[4] :=
      MyPresentValue(Tv[1],MyStrToInt(Strings[2]),Tv[3]);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure FutVal(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    If Tv[1] =0 then Tv[1] := 1000;
    If Tv[2] =0 then Tv[2] := 20;
    If Tv[3] =0 then Tv[3] := 8;
    TV[4] :=
      FutureValue(Tv[1],Tv[3],MyStrToInt(Strings[2]));
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure DISABLT(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     FillHeader(RetNo,FNo,1,2);
     For i:=83 to 88 do Tv[i]:=0;
     i:=7;
     Repeat
       If Strings[i+3] > '' then  {spouse}
       begin
       Tv[85]:=Tv[85]+Tv[i];
       Tv[86]:=Tv[86]+Tv[i+1];
       end
       else
       begin
        Tv[83]:=Tv[83]+Tv[i];
        Tv[84]:=Tv[84]+Tv[i+1];
       end;
       i:=i+8;
     until i>79;
     Tv[87] := Tv[83]+Tv[85];
     Tv[88] := Tv[84]+Tv[86];
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure CRITILL(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
(*
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     FillHeader(RetNo,FNo,1,2);
     For i:=83 to 88 do Tv[i]:=0;
     i:=7;
     Repeat
       If Strings[i+3] > '' then  {spouse}
       begin
       Tv[85]:=Tv[85]+Tv[i];
       Tv[86]:=Tv[86]+Tv[i+1];
       end
       else
       begin
        Tv[83]:=Tv[83]+Tv[i];
        Tv[84]:=Tv[84]+Tv[i+1];
       end;
       i:=i+8;
     until i>79;
     Tv[87] := Tv[83]+Tv[85];
     Tv[88] := Tv[84]+Tv[86];
   end; {End with}
  SaveTv(RetNo,FName,FNo);
 *)
end;

Procedure T2033_1(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     Strings[1] := GetFirstName(RetNo)+ ' '+GetLastName(RetNo);
     Strings[2] := GetSinNo(RetNo);
     Strings[3] := FetchElm(RetNo,'PROFILE',15)+' '+
                 FetchElm(RetNo,'PROFILE',16);
     Strings[4] :=FetchElm(RetNo,'PROFILE',5)+','+
                  FetchElm(RetNo,'PROFILE',6)+','+
                  FetchElm(RetNo,'PROFILE',8)+','+
                  FetchElm(RetNo,'PROFILE',12);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure T2151_1(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    Strings[1] := GetFirstName(RetNo)+ ' '+GetLastName(RetNo);
    Strings[2] := GetSinNo(RetNo);
    Strings[3] := FetchElm(RetNo,'PROFILE',15)+' '+
                 FetchElm(RetNo,'PROFILE',16);
    Strings[4] :=FetchElm(RetNo,'PROFILE',5)+','+
                  FetchElm(RetNo,'PROFILE',6)+','+
                  FetchElm(RetNo,'PROFILE',8)+','+
                  FetchElm(RetNo,'PROFILE',12);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure T2220_1(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    Strings[1] := GetFirstName(RetNo)+ ' '+GetLastName(RetNo);
    Strings[2] := GetSinNo(RetNo);
    Strings[3] := FetchElm(RetNo,'PROFILE',15)+' '+
                 FetchElm(RetNo,'PROFILE',16);
    Strings[4] :=FetchElm(RetNo,'PROFILE',5)+','+
                  FetchElm(RetNo,'PROFILE',6)+','+
                  FetchElm(RetNo,'PROFILE',8)+','+
                  FetchElm(RetNo,'PROFILE',12);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure EFORM(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure TD2(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    Strings[1] := GetLastName(RetNo);
    Strings[2] := GetFirstName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[4] :=FetchElm(RetNo,'PROFILE',5)+','+
                  FetchElm(RetNo,'PROFILE',6)+','+
                  FetchElm(RetNo,'PROFILE',8)+','+
                  FetchElm(RetNo,'PROFILE',12);

   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure T1058(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure PASSSUM(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure ASSUME(RetNo: integer; FName: String;FNo: integer);
Var I:integer; PAccumFNo:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,2,1);
    PAccumFNo:=GetFormNo('RETPLAN');
    If Strings[70]='' then Strings[70]:='N'; //oas rates etc override
    //indexing
    If Strings[69]='' then strings[69]:='Y'; //fixed assets

    If UpperCase(Strings[68])='Y' then
     for i:=48 to 57 do Strings[i]:='Y'
    else
     begin
      for i:=48 to 57 do Strings[i]:='N';
      for i:=58 to 67 do Tv[i]:=0;
     end;

    If UpperCase(Strings[69])='Y' then
      For i:=41 to 47 do Strings[i]:='Y'
    else
    begin
      For i:=41 to 47 do Strings[i]:='N';
      For i:=23 to 24 do Tv[i]:=0;
      For i:=35 to 39 do Tv[i]:=0;
    end;

    //expected return %
    If Tv[15]=0 then Tv[15]:=3;
    If Tv[16]=0 then Tv[16]:=8;
    If Tv[17]=0 then Tv[17]:=10;
    If Tv[18]=0 then Tv[18]:=0;

    //Fixed assetd apprec %
    If (UpperCase(Strings[41])='Y') and (Tv[23]=0) then Tv[23]:=2;
    If (UpperCase(Strings[42])='Y') and (Tv[24]=0) then Tv[24]:=2;
    If (UpperCase(Strings[43])='Y') and (Tv[35]=0) then Tv[35]:=2;
    If (UpperCase(Strings[44])='Y') and (Tv[36]=0) then Tv[36]:=0;
    If (UpperCase(Strings[45])='Y') and (Tv[37]=0) then Tv[37]:=0;
    If (UpperCase(Strings[46])='Y') and (Tv[38]=0) then Tv[38]:=0;
    If (UpperCase(Strings[47])='Y') and (Tv[39]=0) then Tv[39]:=0;

    If UpperCase(Strings[41])<>'Y' then Tv[23]:=0;
    If UpperCase(Strings[42])<>'Y' then Tv[24]:=0;
    If UpperCase(Strings[43])<>'Y' then Tv[35]:=0;
    If UpperCase(Strings[44])<>'Y' then Tv[36]:=0;
    If UpperCase(Strings[45])<>'Y' then Tv[37]:=0;
    If UpperCase(Strings[46])<>'Y' then Tv[38]:=0;
    If UpperCase(Strings[47])<>'Y' then Tv[39]:=0;

    If Strings[21]='' then Strings[21]:= GetIntDivCapGpercent('Cash');
    If Tv[22]=0 then Tv[22]:= Vl(GetHistoricalRateOfReturn('Cash'));

    If Strings[25]='' then Strings[25]:= GetIntDivCapGpercent('Income');
    If Tv[26]=0 then Tv[26]:= Vl(GetHistoricalRateOfReturn('Income'));

    If Strings[27]='' then Strings[27]:= GetIntDivCapGpercent('Growth');
    If Tv[28]=0 then Tv[28]:= Vl(GetHistoricalRateOfReturn('Growth'));

    If Strings[71]='' then Strings[71]:= GetIntDivCapGpercent('Balanced');
    If Tv[72]=0 then Tv[72]:= Vl(GetHistoricalRateOfReturn('Balanced'));

    If Strings[29]='' then Strings[29]:= GetIntDivCapGpercent('Income & Growth');
    If Tv[30]=0 then Tv[30]:= Vl(GetHistoricalRateOfReturn('Income & Growth'));

    If Strings[31]='' then Strings[31]:= GetIntDivCapGpercent('Global Growth');
    If Tv[32]=0 then Tv[32]:= Vl(GetHistoricalRateOfReturn('Global Growth'));

    If Strings[33]='' then Strings[33]:= GetIntDivCapGpercent('Aggressive Growth');
    If Tv[34]=0 then Tv[34]:= Vl(GetHistoricalRateOfReturn('Aggressive Growth'));

    //RRIF
    If Strings[19]='' then Strings[19]:='Y';
    If UpperCase(Strings[19]) =  'Y' then
    begin
     If (Strings[20]='') or (Vl(Strings[20]) > 71) then Strings[20] := '71';
    end;

   // see http://www.hrsdc.gc.ca/en/isp/oas/oasrates.shtml           N/A
    // see: http://www.hrsdc.gc.ca/asp/gateway.asp?hr=/en/isp/oas/tabrates/cpioas.shtml&hs=ozs
    //See http://www.hrsdc.gc.ca/en/isp/pub/factsheets/rates.shtml   X 12

    //**** http://www.hrsdc.gc.ca/eng/isp/statistics/rates/janmar09.shtml#topic1
   //SEE  http://www.servicecanada.gc.ca/eng/isp/pub/factsheets/rates.shtml   X 12       N/A
    If UpperCase(Strings[70]) <> 'Y' then   //done for 2014
    begin
     Tv[4]:=1.0; //20150227 2.0; //2012 //2011 2.3; //2.5; //2.2; //cpi  2005   // http://www.statcan.ca/english/Subjects/Cpi/cpi-en.htm
     Tv[5]:=9670; //20260505 //OAS benefits //6676; //20150227 6579; ////6510; //2012  //2011 6222; //6082.23;  //5952; //5846.19; //5592.75; //2005 oas      // See T1 program
     Tv[6]:=93454; //20260505 //oas threshold //71592; //20150227  70954; //69562; //2012 67668; //2011 66733; //66335;  //2005 clawback  // See T1 program
     Tv[7]:=1012.50 * 12; //cpp benefits //2012//986.67 * 12; ////1153 * 12;  //1105.99; //1077.52; //?? //9465;  //max ccp benefit
     Tv[8]:=2500; //2012 //cpp death benefit 2500;  //2500; //2500;  //2005 max cpp death benefit
     Tv[9]:= 556.64 * 12; //survivor benefit u65 2012 543.82 * 12; //529.9 *12; //506 * 12; //493.28 * 12; //482.30 * 12;  //survivor under 65
     Tv[10]:=607.60 * 12; //survivor 65+ 2012 //576 *12; //545.25 * 12; //530.75 * 12; //518.25 * 12;  //survivor 65 or over
     Tv[11]:=228.66 * 12; //orpan benefits 2012 //218.50 * 12; //213.99 * 12; //orphan bnft - children of disabled contributor
     Tv[12]:=1212.90 * 12; //cpp disabilty; //1153.37 * 12; //1105.99 * 12; //1077.52 * 12; //??  //1053.77 * 12;  //cpp disabil benefit
     Tv[13]:=22100.10; //ei disability 21476;  //EI disab benefit
     Tv[14]:=10000.50;
     ;  //child care expenses
    end;

    If (UpperCase(Strings[48])='Y') and (Tv[58]=0) then Tv[58]:=tv[4];
    If (UpperCase(Strings[49])='Y') and (Tv[59]=0) then Tv[59]:=tv[4];
    If (UpperCase(Strings[50])='Y') and (Tv[60]=0) then Tv[60]:=tv[4];
    If (UpperCase(Strings[51])='Y') and (Tv[61]=0) then Tv[61]:=tv[4];
    If (UpperCase(Strings[52])='Y') and (Tv[62]=0) then Tv[62]:=tv[4];
    If (UpperCase(Strings[53])='Y') and (Tv[63]=0) then Tv[63]:=tv[4];
    If (UpperCase(Strings[54])='Y') and (Tv[64]=0) then Tv[64]:=tv[4];
    If (UpperCase(Strings[55])='Y') and (Tv[65]=0) then Tv[65]:=tv[4];
    If (UpperCase(Strings[56])='Y') and (Tv[66]=0) then Tv[66]:=tv[4];
    If (UpperCase(Strings[57])='Y') and (Tv[67]=0) then Tv[67]:=tv[4];

    i:=48;
    Repeat
      If UpperCase(Strings[i])<>'Y' then Tv[i+10]:=0;
      Inc(i,1);
    until i>57;
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



Procedure T1036_1(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    Strings[1] := GetFirstName(RetNo);
    Strings[2] := GetLastName(RetNo);
    Strings[3] := GetSinNo(RetNo);
    Strings[8] := FetchElm(RetNo,'PROFILE',15)+' '+
                 FetchElm(RetNo,'PROFILE',16);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure T3012_1(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    Tv[8] := Tv[4]+Tv[5]+Tv[6]+Tv[7];
    Tv[9] := Tv[8];
    Tv[10] := MaxR(0,Tv[3] - Tv[9]);
    Strings[16] := GetFirstName(RetNo)+ ' '+GetLastName(RetNo);
    Strings[17] := GetSinNo(RetNo);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure T2097(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure CommonAccumForm(RetNo: integer; FName: String;FNo: integer);
Var
 i,j,k,TotPages,PeriodsPerPage,PgNo,PgStartYear :Integer;
 RetireYear,OrigStartYear,OrigEndYear:Integer;
 BegBalance:Real;
 ThisStream : String[6];
 FullWithDr : Boolean;
 R:TRect;
 TempCanvas:TCanvas;
begin
 Try
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    For i:=1 to 240 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
    ThisStream:=ExtractNonInstFormName(FName);
    StreamId:=GetStreamId(ThisStream);
    BegBalance:=RetirementParms.OpeningBalance[StreamId];
    PeriodsPerPage:=25;
    TotPages:=0;
    TotPages:=GetMaxAccumPageNo(RetNo);
    PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
    {which page to Show}
    FullWithDr := True;
    If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;

   {Fill form}
   FillHeader(RetNo,FNo,2,1);
   Strings[3] := IntToStr(PgNo);
   Strings[4] := IntToStr(TotPages);
   OrigStartYear := RetirementParms.StartYear;
   OrigEndYear   := StrToInt(ClientYearOfUltimateAge(RetNo));

   {Fill form}
   //  LoadTv(RetNo,FName,FNo); { NOT NEEDED?}
   {assumptions}
   Tv[5]      := Vl(RetirementParms.IntRate[StreamId]);
   Strings[6] := IntToStr(OrigStartYear);
   Strings[7] := IntToStr(OrigEndYear);
   Tv[8]      := RetirementParms.RegContr[StreamId];

   i:=(PgNo-1) * PeriodsPerPage;j:= 16; k:=0;
   Repeat
    BalanceRec  := BalanceList.Items[i];
    Strings[j] := IntToStr(BalanceRec.Year)+' '+IntTostr(BalanceRec.Age[0]);
    Tv[j+1] := Round(BalanceRec.BegBalance[StreamId]);
    Tv[j+2] := Round(BalanceRec.RegContr[StreamId]);  //20140224
    Tv[j+3] := Round(BalanceRec.LumpSumContr[StreamId]);
    Tv[j+4] := Round(BalanceRec.RegWithDr[StreamId]);
    Tv[j+5] := Round(BalanceRec.LumpSumWithDr[StreamId]);
    Tv[j+6] := Round(BalanceRec.EndBalance[StreamId]);
    Tv[j+7] := Round(BalanceRec.EndActual[StreamId]);
    Strings[j+8] := BalanceRec.Notes[StreamId];
    Inc(i);
    Inc(j,9);
   until (i>RetirementParms.NumbPeriods) or (j>232);
  {get retirement age balance}
  RetireYear := MyStrToInt(ClientYearOfRetirement(RetNo)); {MyStrToInt(FetchElm(RetNo,'RETPLAN',49));}
  i:= RetireYear - OrigStartYear;
  If i<0 then i:=0;
  BalanceRec  := BalanceList.Items[i];
  If LeftStr(FName,6) = 'PSHELT' then  Ret[RetNo].PSheltBalance := BalanceRec.EndBalance[StreamId];
  If LeftStr(FName,6) = 'PNONSH' then  Ret[RetNo].PNonShBalance := BalanceRec.EndBalance[StreamId];
  If LeftStr(FName,6) = 'PSEMSH' then  Ret[RetNo].PSemShBalance := BalanceRec.EndBalance[StreamId];
  If LeftStr(FName,6) = 'POTHER' then  Ret[RetNo].POtherBalance := BalanceRec.EndBalance[StreamId];
  If PgNo > TotPages then
  begin
   {IrregContrList.Free;
   IrregWithDrList.Free;}
  end;
 end;
  SaveTv(RetNo,FName,FNo);
 Except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end; //try
end;

Procedure PSHELT(RetNo: integer; FName: String;FNo: integer);
begin
 CommonAccumForm(RetNo,FName,FNo);
end;

Procedure PNONSH(RetNo: integer; FName: String;FNo: integer);
begin
 CommonAccumForm(RetNo,FName,FNo);
end;

Procedure PSEMSH(RetNo: integer; FName: String;FNo: integer);
begin
 CommonAccumForm(RetNo,FName,FNo);
end;

Procedure POTHER(RetNo: integer; FName: String;FNo: integer);
begin
 //CommonAccumForm(RetNo,FName,FNo);
end;


Procedure PEVENTS(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     FillHeader(RetNo,FNo,1,2);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure ORD_1(RetNo: integer; FName: String;FNo: integer);
Var I:integer;FInst :String[4];
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     Strings[18] :=RemoveChar(FormatDateTime('yyyy-mm-dd',Date),'-'); {ord date}
     {Strings[19]:= GetTransId(User.AgentCode); Automatic from order generation
       to avoid duplicates until translog updated}
     Strings[17] := FetchElm(RetNo,'PROFILE',81); {title}
     If Strings[15]+Strings[16]='' then Strings[15] := 'X';
     Strings[28] :=FetchElm(RetNo,'PROFILE',2);
     Strings[27] := FetchElm(RetNo,'PROFILE',1);
     Strings[22] := FetchElm(RetNo,'PROFILE',5);
     Strings[24] := FetchElm(RetNo,'PROFILE',6);
     Strings[25] := FetchElm(RetNo,'PROFILE',8);
     Strings[26] := FetchElm(RetNo,'PROFILE',12);
     Strings[29] := FetchElm(RetNo,'PROFILE',15);
     Strings[30] := FetchElm(RetNo,'PROFILE',16);
     Strings[31] := FetchElm(RetNo,'PROFILE',90);
     Strings[32] := FetchElm(RetNo,'PROFILE',91);
     Strings[33] := FetchElm(RetNo,'PROFILE',3);
     Strings[36] := FetchElm(RetNo,'PROFILE',27);
     If UpperCase(Strings[52]) = 'X' then
     begin
      Strings[43] := FetchElm(RetNo,'PROFILE',4);
      Strings[44] := FetchElm(RetNo,'PROFILE',17);
      Strings[46] := FetchElm(RetNo,'PROFILE',21);
      Strings[48] := FetchElm(RetNo,'PROFILE',22);
      Strings[49] := FetchElm(RetNo,'PROFILE',24);
      Strings[50] := FetchElm(RetNo,'PROFILE',92);
      Strings[53] := FetchElm(RetNo,'PROFILE',4);
      Strings[51] := FetchElm(RetNo,'PROFILE',29);
     end
     else
     begin
      For i:=43 to 51 do Strings[i]:='';
      Strings[53] :='';
      For i:=34 to 35 do Strings[i] :='';
      For i:=37 to 38 do Strings[i] :='';
     end;

    {Strings[54] := User.BrokerCode;}
    Strings[55] := User.Code; //20170112 Igor
    Strings[56] := '???????????';
    Strings[57] := User.Prep_Name; //20170112 Igor

    Tv[143] :=0;Tv[144]:=0;Tv[145] :=0;
    i:=65;
    Repeat
     Tv[143] := TV[143]+Tv[i];
     Tv[144] := Tv[144]+Tv[i+4];
     Tv[145] := Tv[145]+Tv[i+5];
     Inc(i,8);
    until i>137;
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure ORD_2(RetNo: integer; FName: String;FNo: integer);
Var I:integer;FInst :String[4];
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure ORD_3(RetNo: integer; FName: String;FNo: integer);
Var I:integer;FInst :String[4];
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure ORD_4(RetNo: integer; FName: String;FNo: integer);
Var I:integer;FInst :String[4];
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    If Strings[2] = '' then strings[2] := DateToStr(Date);
    If Strings[5] = '' then strings[2] := DateToStr(Date);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure T1LINK(RetNo: integer; FName: String;FNo: integer);
Var I:integer;TempList:TStringList;
begin
  TempList:=TStringList.Create;
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin

    (*
    If FileExists(AppDir+'\'+'T1Link.d') then
    begin
     TempList.LoadFromFile(AppDir+'\'+'T1Link.d');
     Strings[1]:=TempList[0];  //year supported
     Strings[2]:=TempList[1];  //t1 program folder
     Strings[3]:=TempList[2];  //t1 data folder
     Strings[4]:=TempList[3];  //delay
    end
    Else
    begin
    *)
    If not FileExists(AppDir+'\'+'T1Link.d') then
    begin
     Strings[1]:='2002';
     Strings[2]:='C:\T1-2002';
     Strings[3]:='C:\T1-2002\Data';
     Strings[4]:='50';
     TempList.Add(Strings[1]);  //year supported
     TempList.Add(Strings[2]);  //t1 program folder
     TempList.Add(Strings[3]);  //t1 data folder
     TempList.Add(Strings[4]);  //delay
     TempList.SaveToFile(AppDir+'\'+'T1Link.d');
     TempList.Free;
     SaveTv(RetNo,FName,FNo);
     Exit;
   end;

   TempList.Add(Strings[1]);  //year supported
   TempList.Add(Strings[2]);  //t1 program folder
   TempList.Add(Strings[3]);  //t1 data folder
   TempList.Add(Strings[4]);  //delay
   TempList.SaveToFile(AppDir+'\'+'T1Link.d');
   TempList.Free;

   SaveTv(RetNo,FName,FNo);
  end; {End with}
end;


Procedure EDUPLN(RetNo: integer; FName: String;FNo: integer);
Const p=55;Fmt='#######.00';
Var I,j,k,n,n1,n2,ProfFNo,GoalsFNo,KidsCnt:integer;FInst:String[4];

  Withdrawal,Interest,Amount,FinalValue:Double;
  Contribution:Real;
  Years: Array[0..p] of integer;
  BegCap:Array[0..p] of real;
  AnnualContr:Array[0..p] of real;
  InterestOnInv:Array[0..p] of real;
  StudentContr:Array[0..p] of real;
  CESG:Array[0..p] of real;
  EduCost:Array[0..p] of real;
  EndCap:Array[0..p] of real;

  StartCap:Real;
  StartContrYear:Integer;
  StartEduYear:Integer;
  StudentContrEntered:Real;
  CESGInclude:String[1];
  TotCesg:Real;
  EscalTuition,EscalRoom,EscalOther:Real;
begin
  TotCesg:=0;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  ProfFNo:=GetFormNo('PROFILE');
  with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,2,1);
    If Strings[16]='' then Strings[16]:='Y';
    j:=GetEduIndexforAKid(RetNo,MyStrToInt(MidStr(FInst,2,1)));
    If j=0 then
    begin
     SaveTv(RetNo,FName,FNo);
     exit;
    end;
    //get k from j (index to educ plan from name index
    i:=43; k:=101;
    Repeat
     If (j=i) and (FetchElmFNo(RetNo,ProfFNo,i)>'') then break;
     Inc(i,4);
     Inc(k,1);
    until i>75;

    If UpperCase(FetchElmFNo(RetNo,ProfFNo,k))='X' then
    begin
      Strings[3]:=FetchElmFNo(RetNo,ProfFNo,j);  //name
      Strings[4]:=IntToStr(CalcAge(FetchElmFNo(RetNo,ProfFNo,j+2)));  //current Age
      Strings[7]:=FetchElmFNo(RetNo,ProfFNo,k+10);  //educ years
      If Strings[8]='' then Strings[8]:=FetchElmFNo(RetNo,ProfFNo,8);  //province
    end;
    //get default tuition costs
   // If Strings[9]='' then Tv[9]:=GetTuitionCost(Strings[8]);
    If Strings[9]='' then Tv[9]:=4000;
    If Strings[10]='' then Strings[10]:=GetTuitionEscal(Strings[8]);

    //do details

    If Strings[5]='' then Strings[5]:='18'; //age educ starts
    If Strings[5]>'50' then Strings[5]:='50';
    If Vl(Strings[5])< Vl(Strings[4]) then Strings[5]:=Strings[4];
    Strings[6]:=IntToStr(SomeAgeToYear(StrToInt(Strings[5]),StrToInt(Strings[4])));
    //contr starts
    If Strings[18]='' then
      Strings[18]:=LeftStr(FormatDateTime('yyyy-mm-dd',Now),4);
    If Vl(Strings[18]) < Vl(LeftStr(FormatDateTime('yyyy-mm-dd',Now),4)) then
      Strings[18]:=LeftStr(FormatDateTime('yyyy-mm-dd',Now),4);
    If MyStrToInt(Strings[18]) > MyStrToInt(Strings[6]) then
      Strings[18]:=Strings[6];

    StartContrYear:=MyStrToInt(Strings[18]);
    StartCap:=Vl(Strings[15]);
    StartEduYear:=MyStrToInt(Strings[6]);

   // Withdrawal:= Tv[9]+Tv[11]+Tv[13];  //20090525
    EscalTuition:=FutureValue(Tv[9],Vl(Strings[10]),(StartEduYear-StartContryear));
    EscalRoom:=FutureValue(Tv[11],Vl(Strings[12]),(StartEduYear-StartContryear));
    EscalOther:=FutureValue(Tv[13],Vl(Strings[14]),(StartEduYear-StartContryear));
    Withdrawal:=EscalTuition+EscalRoom+EscalOther;


    //CESGAmount:=Vl(Strings[16]);
    StudentContrEntered:=Vl(Strings[17]);
    If Strings[19]='' then Strings[19]:=AllTrim(FetchElm(RetNo,'ASSUME',15));
    Interest:=Vl(Strings[19]);
    n1:=MyStrToInt(Strings[6])-MyStrToInt(Strings[18]); //pre-educ periods
    If n1<0 then n1:=0;
    n2:=MyStrToInt(Strings[7]);  //educ periods
    n:=n1+n2; //total contr periods

    // build array of educost per year
    For i:=0 to n-1 do
    begin
      If i=0 then
      begin
       If StartContrYear> StartEduYear then
        begin Years[i]:=StartEduYear; end
       else
        begin Years[i]:=StartContrYear; end;
      end
      else
      Years[i]:=Years[i-1]+1;
    end;

    For i:=0 to n-1 do
    begin
     If Years[i]< StartEduYear then EduCost[i]:=0;
     If Years[i]= StartEduYear then
       EduCost[i]:=Withdrawal; //Tv[9]+Tv[11]+Tv[13];  20090525

     If Years[i]>StartEduYear then
     begin
       EduCost[i]:=FutureValue(EscalTuition,Vl(Strings[10]),(Years[i]-StartEduYear))
                   +FutureValue(EscalRoom,Vl(Strings[12]),(Years[i]-StartEduYear))
                   +FutureValue(EscalOther,Vl(Strings[14]),(Years[i]-StartEduYear));

      {20090525
       EduCost[i]:=FutureValue(Tv[9],Vl(Strings[10]),(Years[i]-StartEduYear))
                   +FutureValue(Tv[11],Vl(Strings[12]),(Years[i]-StartEduYear))
                   +FutureValue(Tv[13],Vl(Strings[14]),(Years[i]-StartEduYear));
       }
     end;
    end;

    // amount=Educost-Stud contr - CESG times periods - FV of existingfunds

    Amount:= (Withdrawal - Vl(Strings[17]))* n2
              - FutureValue(Vl(Strings[15]),Interest,n);
    If UpperCase(Strings[23])='Y' then Amount:=Amount-7200;
    Contribution:=AnnuityPerPeriod(Amount,Interest,n);
    If UpperCase(Strings[21]) ='Y' then Contribution:=Vl(Strings[24]);

    If Contribution<0 then Contribution :=0;
    Tv[20]:=Contribution;

    //CESGAmount:=Vl(Strings[16]);
    CESGInclude:=Strings[23];
    CalcEduBalances(Contribution,WithDrawal,Interest,n,
    StartContrYear,StartEduYear,StartCap,CESGInclude,StudentContrEntered,
    Years,BegCap,AnnualContr,InterestOnInv,StudentContr,
    CESG,EduCost,EndCap);


    //refine if auto calc
    If (UpperCase(Strings[21]) <> 'Y') and (Contribution>0) then
    begin
     Repeat
     If EndCap[n-1] <0 then
     begin
      Contribution:=Contribution+AnnuityPerPeriod(ABS(EndCap[n-1]),Interest,n);
      If Contribution<0 then Contribution :=0;
      Tv[20]:=Contribution;
      CalcEduBalances(Contribution,WithDrawal,Interest,n,
       StartContrYear,StartEduYear,StartCap,CESGInclude,StudentContrEntered,
       Years,BegCap,AnnualContr,InterestOnInv,StudentContr,
       CESG,EduCost,EndCap);
     end;
     until EndCap[n-1] >=0;

     Repeat
     If EndCap[n-1] >100 then
     begin
      Contribution:=Contribution-AnnuityPerPeriod(ABS(EndCap[n-1]),Interest,n);
      If Contribution<0 then Contribution :=0;
      Tv[20]:=Contribution;
      CalcEduBalances(Contribution,WithDrawal,Interest,n,
       StartContrYear,StartEduYear,StartCap,CESGInclude,StudentContrEntered,
       Years,BegCap,AnnualContr,InterestOnInv,StudentContr,
       CESG,EduCost,EndCap);
     end;
     until EndCap[n-1] <=100;

     Repeat
     If EndCap[n-1] <0 then
     begin
      Contribution:=Contribution+AnnuityPerPeriod(ABS(EndCap[n-1]),Interest,n);
      If Contribution<0 then Contribution :=0;
      Tv[20]:=Contribution;
      CalcEduBalances(Contribution,WithDrawal,Interest,n,
       StartContrYear,StartEduYear,StartCap,CESGInclude,StudentContrEntered,
       Years,BegCap,AnnualContr,InterestOnInv,StudentContr,
       CESG,EduCost,EndCap);
     end;
     until EndCap[n-1]>=0;
    end; //end refine

    //xfer arrays to screen
    i:=0;
    j:=33;
    Repeat
     Strings[j]:=IntToStr(Years[i]);
     If Strings[j]='0' then Strings[j]:='';
     Tv[j+1]:=BegCap[i];
     Tv[j+2]:=AnnualContr[i];
     Tv[j+3]:=InterestOnInv[i];
     Tv[j+4]:=StudentContr[i];
     Tv[j+5]:=CESG[i];
     Tv[j+6]:=EduCost[i];
     Tv[j+7]:=EndCap[i];
     Inc(i,1);
     Inc(j,8);
    until j>273;
    // do summary
    For i:=25 to 31 do Tv[i]:=0;
    Tv[25]:=Tv[15];
    For i:=0 to n-1 do
    begin
     Tv[26]:=Tv[26]+AnnualContr[i];
     Tv[27]:=Tv[27]+InterestOnInv[i];
     Tv[28]:=Tv[28]+CESG[i];
     Tv[29]:=Tv[29]+StudentContr[i];
     Tv[30]:=Tv[30]+EduCost[i];
    end;
    Tv[31]:=Tv[25]+Tv[26]+tv[27]+Tv[28]+Tv[29]-Tv[30];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure CalcEduBalances(
  Contribution:Real;
  WithDrawal:Real;
  Interest:Real;
  n:Integer;
  StartContrYear:Integer;
  StartEduYear:Integer;
  StartCap:Real;
  CESGInclude : String;
  StudentContrEntered:Real;
  Var Years:Array of Integer;
  Var BegCap:Array of real;
  Var AnnualContr:Array of real;
  Var InterestOnInv:Array of real;
  Var StudentContr:Array of real;
  Var CESG:Array of real;
  Var EduCost:Array of real;
  Var EndCap:Array of real);


// withdrwal not used. Instead EduCost array is pre-prepared
Var i:Integer;CesgAmount:Real;TotCesg:Real;
begin
  TotCesg:=0;CesgAmount:=0;
  //build detail arrays
    For i:=0 to n-1 do
    begin
      If i=0 then
      begin
       If StartContrYear> StartEduYear then
         Years[i]:=StartEduYear
       else
         Years[i]:=StartContrYear;
       BegCap[i]:=StartCap;
      end
      else
      begin
       Years[i]:=Years[i-1]+1;
       BegCap[i]:=EndCap[i-1];
      end;

      AnnualContr[i]:=Contribution;
      //CESG[i]:=CESGAmount;
      //TotCesg:=TotCesg+CesgAmount;
      If UpperCase(CesgInclude)='Y' then
      begin
      If TotCesg<7200 then
        CESG[i]:=MinR(400,AnnualContr[i] * 0.20)
      else
        CESG[i]:=0;
      end
      Else
        Cesg[i]:=0;

      TotCesg:=TotCesg+Cesg[i];

      InterestOnInv[i]:=BegCap[i] * Interest/100
        +((AnnualContr[i]+CESG[i])*Interest/100/2);
      If Years[i]>= StartEduYear then
        StudentContr[i]:=StudentContrEntered
      else
         StudentContr[i]:=0;
      {
      If Years[i]>= StartEduYear then
        CESG[i]:=CESGAmount
      else
        CESG[i]:=0;
      }
      EndCap[i]:=BegCap[i]+AnnualContr[i]+InterestOnInv[i]+StudentContr[i]
         +CESG[i]-EduCost[i];
    end; //i
end;

Procedure LIFEEVENTS(RetNo: integer; FName: String;FNo: integer);
Var I,j,k:integer;ProfileFNo:Integer;
begin
  ProfileFNo:=GetFormNo('PROFILE');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,1,2);
    i:=3;
    Repeat
      If Length(Strings[i+1])<4 then Strings[i+1]:='';
      If Length(Strings[i+2])<4 then Strings[i+2]:='';
      If Strings[i]='' then begin
       For j:=i+1 to i+8 do Strings[j]:='';
       Tv[i+4]:=0;
      end;  //if no descr
      If (Strings[i+1]>'') and (Strings[i+2]='') then Strings[i+2]:=Strings[i+1]; //repeat year
      If Vl(Strings[i+1]) > Vl(Strings[i+2]) then Strings[i+2]:=Strings[i+1]; //repeat year
      If Vl(Strings[i+4])=0 then //if no amount
       For j:=i+5 to i+8 do Strings[j]:='';

      For j:=i+5 to i+8 do
      begin
        If (Strings[i]>'') and (Vl(Strings[j])>100) then Strings[j]:='100';
      end;

      If (Vl(Strings[i+5])+Vl(Strings[i+6])+Vl(Strings[i+7])+Vl(Strings[i+8])=0)
      and (Strings[i]>'')
      then Strings[i+5]:='100';

      If Vl(Strings[i+6])+Vl(Strings[i+7])+Vl(Strings[i+8])>0 then
      begin
       Strings[i+5]:=FormatFloat('###',100-Vl(Strings[i+6])-Vl(Strings[i+7])-Vl(Strings[i+8]));
      end;
     Inc(i,9);
    until i>156; 
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure GOALS(RetNo: integer; FName: String;FNo: integer);
Var I,j,k:integer;ProfileFNo:Integer;
begin
  ProfileFNo:=GetFormNo('PROFILE');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    //retirement
    FillHeader(RetNo,FNo,1,2);
    Strings[3]:= FetchElmFNo(RetNo,ProfileFNo,1);
    If Strings[4]='' then strings[4]:='65'; //age at reti
    //If MyStrToInt(Strings[4]) < ClientAge(RetNo) then Strings[4]:=IntToStr(ClientAge(RetNo));
    If strings[6]='' then strings[6]:='90';  //ultimate age
    //If MyStrToInt(Strings[6]) < ClientAge(RetNo) then Strings[6]:=IntToStr(ClientAge(RetNo));
    Strings[5]:='Cost of Living';
    Strings[7]:='Income sources';
    //spouse
    Strings[9]:=FetchElmFNo(RetNo,ProfileFNo,17);
    If Strings[9]='' then  For i:=10 to 12 do Strings[i]:='';
    If Strings[10]='' then strings[10]:='65';
    If MyStrToInt(Strings[10]) < SpouseAge(RetNo) then  //sp age at retir
      Strings[10]:=IntToStr(SpouseAge(RetNo));

    If strings[12]='' then strings[12]:='90';
    If MyStrToInt(Strings[12]) < SpouseAge(RetNo) then
      Strings[12]:=IntToStr(SpouseAge(RetNo));
    //no spouse
    If Ret[RetNo].MarStatus >2 then
    begin
     Strings[9]:='';Strings[10]:='';Strings[12]:='';
    end;
    //education
    Strings[8]:= FetchElmFNo(RetNo,ProfileFNo,1);
    Strings[13]:=FetchElmFNo(RetNo,ProfileFNo,17);
    //kids
    i:=15;
    j:=43;  //index to profile kids
    k:=101;
    Repeat
     If FetchElmFNo(RetNo,ProfileFNo,j) > '' then
     begin
       Strings[i]:=FetchElmFNo(RetNo,ProfileFNo,j); //kid name
       Strings[i+1]:=FetchElmFNo(RetNo,ProfileFNo,K); //kid name
       Inc(i,2);
     end;
     Inc(j,4);
     Inc(k,1);
    until j>63;
    //if no name, no X
    If Strings[8]='' then Strings[11]:='';
    If Strings[13]='' then Strings[14]:='';
    Repeat
     If Strings[i]='' then Strings[i+1]:='';
     Inc(i,2);
    until i>25;

    //estate value
    If Strings[112]='' then Strings[112]:=Strings[6]; //life expectancy

    //asset purchase
    i:=28;
    repeat
     If Strings[i]='' then  //no description
     begin
       For j:=i+1 to i+6 do
       begin Strings[j]:='';Tv[j]:=0;end;
     end;
     If (Strings[i+1] > '')
     and (MyStrToInt(Strings[i+1])<ClientAge(RetNo)) then
       Strings[i+1] := IntToStr(ClientAge(RetNo));
     If Tv[i+3] > Tv[i+2] then Tv[I+3]:=Tv[i+2];
     If Tv[i+5]>100 then Tv[i+5]:=100; //interest
     If Tv[i+6]>50 then Tv[i+6]:=50; //apprteciation
     Inc(i,7);
    until i>56;

  (*
    //life events edit
    i:=63;
    Repeat
      If Strings[i]='' then begin
       For j:=i+1 to i+8 do Strings[j]:='';
       Tv[i+4]:=0;
      end;  //if no descr
      If (Strings[i+1]>'') and (Strings[i+2]='') then Strings[i+2]:=Strings[i+1]; //repeat year
      If Vl(Strings[i+1]) > Vl(Strings[i+2]) then Strings[i+2]:=Strings[i+1]; //repeat year
      If Vl(Strings[i+4])=0 then //if no amount
       For j:=i+5 to i+8 do Strings[j]:='';

      If (Strings[i]>'') and (Strings[i+1]>'') and (Strings[i+3]='') then
       Strings[i+3]:='W'; //type of event

      For j:=i+5 to i+8 do
      begin
        If (Strings[i]>'') and (Vl(Strings[j])>100) then Strings[j]:='100';
      end;

      If (Vl(Strings[i+5])+Vl(Strings[i+6])+Vl(Strings[i+7])+Vl(Strings[i+8])=0)
      and (Strings[i]>'')
      then Strings[i+5]:='100';


      If Vl(Strings[i+6])+Vl(Strings[i+7])+Vl(Strings[i+8])>0 then
      begin
       Strings[i+5]:=FormatFloat('###',100-Vl(Strings[i+6])-Vl(Strings[i+7])-Vl(Strings[i+8]));
      end;

     Inc(i,9);
    until i>146;
   *)
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure GOALSR(RetNo: integer; FName: String;FNo: integer);
Var I,j,jj,k,StartYear:integer;ProfileFNo:Integer;
   YearsList:TStringList;
begin
Ret[RetNo].FrmHasData[FNo] :=False;
EXIT;

  YearsList:=TStringList.Create;
  ProfileFNo:=GetFormNo('PROFILE');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2);

    //retirement
    If Vl(FetchElm(RetNo,'RETPLAN',52)) >0 then
      Strings[3]:='No'
    else
      Strings[3]:='Yes';
    If UpperCase(Strings[3])<>'YES' then
    begin
     Strings[4]:='Revise/reduce less important goals';
     Strings[5]:='Prolong the retirement age';
     Strings[6]:='Reduce the retirement income needs';
     Strings[7]:='Increase the expected return (riskier investments)';
    end;

   //education
   If UpperCase(FetchElm(RetNo,'PROFILE',41)) <> 'Y' then
     Strings[8]:='Not applicable'
   else
   Begin
     GetEduYearsList(RetNo,YearsList);
     Strings[8]:='Yes';
     For i:=0 to YearsList.Count-1 do
     begin
       If GetTotalEndBalanceByYear(RetNo,YearsList[i]) <0 then
       begin Strings[8]:='No';Break;end;
     end;
   end;
   YearsList.Clear;

  //estate needs net worth
    (*
    x:=GetTotalEndBalanceByYear(RetNo,SomeAgeToYear(RetNo,ClientAge(RetNo));
    If UpperCase(Strings[13])<>'YES' then
    begin
      If x>0 then
       Strings[14]:='Your Assets at your ultimate age will be worth $'+FormatFloat('####,###,###.00',x)
      else
       Strings[14]:='All your Assets will be depleted by your ultimate ageat by your ultimate age);
      Strings[15]:='Revise/reduce less important goals';
      Strings[16]:='Reduce desired estate value or change year';
    end;
   *)

  //Asset purchase
  FNo:=GetFormNo('GOALS');
  i:=18;
  j:=28;  //pointer to goals
  Repeat
    Strings[i]:=FetchElmFNo(RetNo,FNo,j);
    Strings[i+1]:='Y';
    StartYear:=SomeAgeToYear(MyStrToInt(FetchElmFNo(RetNo,FNo,j+1)),ClientAge(RetNo));
    YearsList.Add(AllTrim(IntToStr(StartYear)));
    For jj:=0 to YearsList.Count-1 do
    begin
       If GetTotalEndBalanceByYear(RetNo,YearsList[jj]) <0 then
       begin Strings[i+1]:='No';Break;end;
    end;
    Inc(i,2);
    Inc(j,7);
  until i>26;
  i:=19;
  Repeat
    If Strings[i] <> 'YES' then
    begin
     Strings[28]:='Revise/reduce less important goals';
     Strings[29]:='Revise/reduce/postpone the purchase plans';
     Strings[30]:='Reduce lifestyle expenses';
    end;
    Inc(i,2);
  until i>27;
  YearsList.Clear;

  //lif events
  FNo:=GetFormNo('LIFEEVENTS');
  i:=32;
  j:=3;  //pointer to LIFEEVENTS
  Repeat
    Strings[i]:=FetchElmFNo(RetNo,FNo,j);
    Strings[i+1]:='Y';
    StartYear:=MyStrToInt(FetchElmFNo(RetNo,FNo,j+1));
    YearsList.Add(AllTrim(IntToStr(StartYear)));
    k:=MyStrToInt(FetchElmFNo(RetNo,FNo,j+2));   //To year of event
    for jj:=StartYear+1 to k do YearsList.Add(IntToStr(jj));
    For jj:=0 to YearsList.Count-1 do
    begin
       If GetTotalEndBalanceByYear(RetNo,YearsList[jj]) <0 then
       begin Strings[i+1]:='No';Break;end;
    end;
    Inc(i,2);
    Inc(j,9);
  until i>50;
  YearsList.Clear;

  i:=33;
  repeat
   If UpperCase(Strings[i]) <> 'YES' then
   begin
     Strings[52]:='Revise/reduce less important goals';
     Strings[54]:='Reduce lifestyle expenses';
   end;
   Inc(i,2);
  until i>51;

  end; {End with}
  YearsList.Free;
  SaveTv(RetNo,FName,FNo);
end;


(*
Procedure PFIXA(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=1 to 263 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;
  FillHeader(RetNo,FNo,2,1);
  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);
  //put rates
  Tv[7]:= Vl(FetchElm(RetNo,'ASSUME',23));  //homes
  Tv[8]:= Vl(FetchElm(RetNo,'ASSUME',24));  //vac prop
  Tv[9]:= Vl(FetchElm(RetNo,'ASSUME',35));  //incomeprop
  Tv[10]:= Vl(FetchElm(RetNo,'ASSUME',37));  //bus non inc
  Tv[11]:= Vl(FetchElm(RetNo,'ASSUME',38));  //bus inc
  Tv[12]:= Vl(FetchElm(RetNo,'ASSUME',36));  //autos
  Tv[13]:= Vl(FetchElm(RetNo,'ASSUME',39));  //other

  i:=14; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection list
  Repeat
    FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[j];
    Strings[i]:=IntToStr(FixedAssetsProjectionRec.Year);
    Strings[i+1]:=IntToStr(FixedAssetsProjectionRec.Age);
    Tv[i+2]:=FixedAssetsProjectionRec.Homes;
    Tv[i+3]:=FixedAssetsProjectionRec.VacationPr;
    Tv[i+4]:=FixedAssetsProjectionRec.IncomeProp;
    Tv[i+5]:=FixedAssetsProjectionRec.BusNonIncorp;
    Tv[i+6]:=FixedAssetsProjectionRec.BusIncorp;
    Tv[i+7]:=FixedAssetsProjectionRec.Autos;
    Tv[i+8]:=FixedAssetsProjectionRec.OtherFixed;
    Tv[i+9]:=FixedAssetsProjectionRec.Total;
    Inc(i,10);
    Inc(j,1);  //projection list
   until  (i>254) or (j>RetirementParms.NumbPeriods);
 end; //with
 SaveTv(RetNo,FName,FNo);
end;
*)
Procedure PNETW(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
begin
 Try
 BuildCashFlowProjection(RetNo);
 BuildInvProjection(RetNo);
 Except
 end;
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=1 to 204 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;
  FillHeader(RetNo,FNo,2,1);
  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);

  i:=5; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection lists
  Repeat
    BalanceRec := BalanceList.Items[j];
    FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[j];
    BusinesssProjectionRec :=BusinessProjectionList.items[j];
    LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[j];
    InvProjectionRec := InvProjectionList.Items[j];
    TotInvestmProjectionRec  := TotInvestmProjectionList.Items[j];

    Strings[i]:=IntToStr(FixedAssetsProjectionRec.Year);
    Strings[i+1]:=IntToStr(FixedAssetsProjectionRec.Age);
    Tv[i+2]:=Round(FixedAssetsProjectionRec.Total + BusinesssProjectionRec.Total);
  //  Tv[i+3]:=Round(TotInvestmProjectionRec.TotEndBalance);  //Portf balances
      Tv[i+3]:= BalanceRec.EndBalance[1]+BalanceRec.EndBalance[2]+BalanceRec.EndBalance[3]; //march 3
   // Tv[i+3]:= InvProjectionRec.NonSh +InvProjectionRec.Shelt[0]+InvProjectionRec.Shelt[1]+InvProjectionRec.SemiSh;

    Tv[i+4]:=Round(Tv[i+2]+Tv[i+3]);
    Tv[i+5]:=Round(LiabilitiesProjectionRec.TotLiability); //liabilitis
    //Tv[i+6]?
    Tv[i+7]:=Round(Tv[i+4]-Tv[i+5]-Tv[i+6]);
    Inc(i,8);
    Inc(j,1);  //projection list
   until  (i>204) or (j>RetirementParms.NumbPeriods);
   //until  (i>204) or (j>RetirementParms.NumbPeriods-1);
 end; //with
 SaveTv(RetNo,FName,FNo);
end;

Procedure PLIAB(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=1 to 179 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;
  FillHeader(RetNo,FNo,2,1);
  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);

  i:=5; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection lists
  Repeat
    LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[j];
    Strings[i]:=IntToStr(LiabilitiesProjectionRec.Year);
    Strings[i+1]:=IntToStr(LiabilitiesProjectionRec.Age);
    Tv[i+2]:=LiabilitiesProjectionRec.Mortgages;
    Tv[i+3]:=LiabilitiesProjectionRec.Automobiles;
    Tv[i+4]:=LiabilitiesProjectionRec.Other;
    Tv[i+5]:=Tv[i+2]+Tv[i+3]+Tv[i+4];
    Inc(i,7);
    Inc(j,1);  //projection list
   until  (i>179) or (j>RetirementParms.NumbPeriods);
   //until  (i>179) or (j>RetirementParms.NumbPeriods-1);
 end; //with
 SaveTv(RetNo,FName,FNo);
end;

Procedure PSMINV(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
begin

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=1 to 179 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;
  FillHeader(RetNo,FNo,2,1);
  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);
 
  Tv[8]:=Vl(FetchElm(RetNo,'RETPLAN',55)); //non sh
  Tv[9]:=Vl(FetchElm(RetNo,'RETPLAN',56)); //non sh
  Tv[10]:=Vl(FetchElm(RetNo,'RETPLAN',57)); //non sh
  i:=12; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection lists
  Repeat
    FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[j];
    //LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[j];
    TotInvestmProjectionRec  := TotInvestmProjectionList.Items[j];
    Strings[i]:=IntToStr(FixedAssetsProjectionRec.Year);
    Strings[i+1]:=IntToStr(FixedAssetsProjectionRec.Age);
   // Tv[i+2]:=FixedAssetsProjectionRec.Total;  //fixed assets
 
    BalanceRec  := BalanceList.Items[j];
 
    Tv[i+3]:=  Round(BalanceRec.EndBalance[1]);
    Tv[i+4]:=  Round(BalanceRec.EndBalance[2]);  //sh
    Tv[i+5]:=  Round(BalanceRec.EndBalance[3]);;  //nonsh
 
    //Tv[i+3]:=  TotInvestmProjectionRec.EndBalance[1];  //nonsh    //problem here ??? init
    //Tv[i+4]:=  TotInvestmProjectionRec.EndBalance[2];  //sh
    //Tv[i+5]:=  TotInvestmProjectionRec.EndBalance[3];  //nonsh
    Tv[i+6]:=  Tv[i+2]+Tv[i+3]+Tv[i+4]+Tv[i+5];
    //Tv[i+6]:=?? //
    Tv[i+7]:=Tv[i+4]-Tv[i+5]-Tv[i+6];
    Inc(i,7);
    Inc(j,1);  //projection list
   until  (i>179) or (j>RetirementParms.NumbPeriods);
 end; //with
 SaveTv(RetNo,FName,FNo);
end;

(*
Procedure PSMINV(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=1 to 179 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;
  FillHeader(RetNo,FNo,2,1);
  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);

  Tv[8]:=Vl(FetchElm(RetNo,'RETPLAN',55)); //non sh
  Tv[9]:=Vl(FetchElm(RetNo,'RETPLAN',56)); //non sh
  Tv[10]:=Vl(FetchElm(RetNo,'RETPLAN',57)); //non sh
  i:=12; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection lists
  Repeat
    FixedAssetsProjectionRec := FixedAssetsProjectionList.Items[j];
    //LiabilitiesProjectionRec := LiabilitiesProjectionList.Items[j];
    TotInvestmProjectionRec  := TotInvestmProjectionList.Items[j];
    Strings[i]:=IntToStr(FixedAssetsProjectionRec.Year);
    Strings[i+1]:=IntToStr(FixedAssetsProjectionRec.Age);
   // Tv[i+2]:=FixedAssetsProjectionRec.Total;  //fixed assets
    Tv[i+3]:=TotInvestmProjectionRec.EndBalance[1];  //nonsh    //problem here ??? init
    Tv[i+4]:=TotInvestmProjectionRec.EndBalance[2];  //sh
    Tv[i+5]:=TotInvestmProjectionRec.EndBalance[3];  //nonsh
    Tv[i+6]:=Tv[i+2]+Tv[i+3]+Tv[i+4]+Tv[i+5];
    //Tv[i+6]:=?? //
    Tv[i+7]:=Tv[i+4]-Tv[i+5]-Tv[i+6];
    Inc(i,7);
    Inc(j,1);  //projection list
   until  (i>179) or (j>RetirementParms.NumbPeriods);
 end; //with
 SaveTv(RetNo,FName,FNo);
end;
*)
Procedure CashFlow(RetNo: integer; FName: String;FNo: integer);
Var I,FromFNo:integer;ClawBack:Real;
TxblInc:Real;
begin
  FromFNo:=GetFormNo('CASHFLOW');
  InitTaxRec;
  With TaxRec do
  begin
   //Client
   Age:=CalcAge(FetchElm(RetNo,'PROFILE',27));
   MaritalStatus:=GetMarStatus(RetNo);
   Province:=UpperCase(FetchElm(RetNo,'PROFILE',99));
   //PartYear
   ///SpouseNetIncome
   ClawBack:=CalcClawBack(Vl(FetchElmFNo(RetNo,FromFNo,62)), //tot inc=NetInc
             Vl(FetchElmFNo(RetNo,FromFNo,38)),  //EI
             Vl(FetchElmFNo(RetNo,FromFNo,11)));   //OAS
   ActualDividendsNonElig:=(Vl(FetchElmFNo(RetNo,FromFNo,23))  //from investments
                    +Vl(FetchElmFNo(RetNo,FromFNo,35)));  //from own corp
   ActualDividendsElig:=Vl(FetchElmFNo(RetNo,FromFNo,109));
   //taxable income //20200314
   TxblInc:=MaxR(0,Vl(FetchElmFNo(RetNo,FromFNo,62))
             +ActualDividendsElig * 38/100    //gross uptxbl grossup
             +ActualDividendsNonElig * 15/100  //+ActualDividendsNonElig * 25/100  //20200314 17  //grossup to gt thetxbl
             -Vl(FetchElmFNo(RetNo,FromFNo,47))  //workers comp
             -Vl(FetchElmFNo(RetNo,FromFNo,50))  //social assistance}
             -Vl(FetchElmFNo(RetNo,FromFNo,53))
             -ClawBack); //not taxable amounts
   StoreElm(RetNo,FNo,112,FormatFloat('##########.00',TxblInc));
   TaxableIncome:=TxblInc;
  end;
  //tax calculation
  //claaback is assumed zero See CalcClawBack  ???????????????????
  StoreElm(RetNo,FromFNo,69,FormatFloat('##########.00',CalcTaxForCashFlow(RetNo)+ClawBack));

 //spouse
   InitTaxRec;
   With TaxRec do
   begin
    Age:=CalcAge(FetchElm(RetNo,'PROFILE',29));
    MaritalStatus:=GetMarStatus(RetNo);
    Province:=UpperCase(FetchElm(RetNo,'PROFILE',99));
    ClawBack:=CalcClawBack(Vl(FetchElmFNo(RetNo,FromFNo,63)), //tot inc=NetInc
             Vl(FetchElmFNo(RetNo,FromFNo,39)),  //EI
             Vl(FetchElmFNo(RetNo,FromFNo,12)));   //OAS
    ActualDividendsNonElig:=Vl(FetchElmFNo(RetNo,FromFNo,24))
                  +Vl(FetchElmFNo(RetNo,FromFNo,36));
    ActualDividendsElig:=Vl(FetchElmFNo(RetNo,FromFNo,110));
    TxblInc:= MaxR(0,Vl(FetchElmFNo(RetNo,FromFNo,63))
             +ActualDividendsElig * 38/100
             +ActualDividendsNonElig * 15/100   //20200314 17
             -Vl(FetchElmFNo(RetNo,FromFNo,48))
             -Vl(FetchElmFNo(RetNo,FromFNo,51))
             -Vl(FetchElmFNo(RetNo,FromFNo,54)));
    StoreElm(RetNo,FNo,113,FormatFloat('##########.00',TxblInc));
    TaxableIncome:=TxblInc;
    //ClawBack:=0; //20200316   //claaback is assumed zero See CalcClawBack  ???????????????????
    StoreElm(RetNo,FromFNo,70,FormatFloat('##########.00',CalcTaxForCashFlow(RetNo)+ClawBack)); //20200314  NOT known COUPLING?
 end;
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2);
   Strings[3]:=ClientFirstName(RetNo);
   Strings[4]:=SpouseFirstName(RetNo);
   Strings[65]:=Strings[3];
   Strings[66]:=Strings[4];
   Tv[17]:=AddColumns(8,14,3);
   Tv[18]:=AddColumns(9,15,3);
   Tv[29]:=AddColumns(20,26,3)+Tv[109];
   Tv[30]:=AddColumns(21,27,3)+Tv[110];
   Tv[59]:=AddColumns(38,56,3);
   Tv[60]:=AddColumns(39,57,3);

   Tv[97]:=AddColumns(90,94,4)+AddColumns(102,106,4);
   Tv[98]:=AddColumns(91,95,4)+AddColumns(103,107,4);

   Tv[62]:=Tv[5]+Tv[17]+Tv[29]+Tv[85]+Tv[32]+Tv[35]+Tv[59]+Tv[97];
   Tv[63]:=Tv[6]+Tv[18]+Tv[30]+Tv[86]+Tv[33]+Tv[36]+Tv[60]+Tv[98];
   //horizontal
   i:=5;
   Repeat
    Tv[i+2]:=Tv[i]+Tv[i+1];
    Inc(i,3);
   until i>62;
   Tv[87]:=Tv[85]+Tv[86];
   Tv[99]:=Tv[97]+Tv[98];
   Tv[111]:=Tv[109]+Tv[110];
   //inc percentages
   If Tv[64]>0 then
   begin
    Tv[74]:=100 * Tv[7]/tv[64];
    Tv[75]:=100 * Tv[19]/tv[64];
    Tv[76]:=100 * Tv[31]/tv[64];
    Tv[88]:=100 * Tv[87]/tv[64];
    Tv[77]:=100 * Tv[34]/tv[64];
    Tv[78]:=100 * Tv[37]/tv[64];
    Tv[79]:=100 * Tv[61]/tv[64];
    Tv[100]:=100 * Tv[99]/tv[64];
    Tv[80]:=100 * Tv[64]/tv[64];
   end
   else
   begin
    Tv[74]:=0;
    Tv[75]:=0;
    Tv[76]:=0;
    Tv[77]:=0;
    Tv[88]:=0;
    Tv[78]:=0;
    Tv[79]:=0;
    Tv[80]:=0;
   end;

   //uses of cash
   Tv[67]:=Vl(FetchElm(RetNo,'LIVINGEXP_2',120));
   Tv[68]:=Vl(FetchElm(RetNo,'NETWORTH',69)); //20090521
   Tv[71]:=Tv[69]+Tv[70];
   Tv[72]:=Tv[67]+Tv[68]+Tv[71];
   //%
   If Tv[72]>0 then
   begin
    Tv[81]:=100 * Tv[67]/tv[72];
    Tv[82]:=100 * Tv[68]/tv[72];
    Tv[83]:=100 * Tv[71]/tv[72];
    Tv[84]:=100 * Tv[72]/tv[72];
   end
   else
   begin
    Tv[81]:=0;
    Tv[82]:=0;
    Tv[83]:=0;
    Tv[84]:=0;
   end;
   Tv[73]:=Tv[64]-Tv[72];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure INCPROJECTION(RetNo: integer; FName: String;FNo: integer);
Var I,k,m:integer;CashFlFNo:Integer;
  ClRetAge,SpRetAge:String;s:String;
begin
  CashFlFNo:=GetFormNo('CASHFLOW');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,2,1);
 //   ClRetAge:=IntToStr(ClientAgeAtRetirement(RetNo));
 //   SpRetAge:=IntToStr(SpouseAgeAtRetirement(RetNo));
    Strings[3]:=ClientFirstName(RetNo);
    Strings[4]:=SpouseFirstName(RetNo);
    Strings[6]:=IntToStr(ClientAgeAtRetirement(RetNo));  //ClientYearOfRetirement(RetNo); //20120610
    Strings[5]:=ClientYearOfRetirement(RetNo);//IntToStr(SpouseAgeAtRetirement(RetNo));  //ClRetAge; //20120610
    ClRetAge:=IntToStr(ClientAgeAtRetirement(RetNo)-1);  //20120610
    SpRetAge:=IntToStr(SpouseAgeAtRetirement(RetNo)-1);  //20120610
    If Ret[RetNo].MarStatus<3 then
    begin
     Strings[7]:=SpouseYearOfRetirement(RetNo);
     Strings[8]:=SpRetAge;
    end
    Else
    begin
     Strings[7]:='';
     Strings[8]:='';
    end;
    // client age
    i:=10;
    Repeat
     If Tv[i-1]>0 then
     begin
      //pensuions
      If (i>=42) and (i<=74) then //pensions dates
      begin
        If Strings[i]='' then Strings[i]:=IntToStr(ClientAgeAtRetirement(RetNo)); //ClRetAge; 20120610
        If Strings[i+1]='' then Strings[i+1]:=IntToStr(ClientUltimateAge(RetNo));
      end
      else //other than pensions
      Begin
       If Strings[i]='' then Strings[i]:=IntToStr(ClientAge(RetNo)); //from age
       If Strings[i+1]='' then
       begin
        If i<34 then If Strings[i+1]='' then Strings[i+1]:=ClRetAge  //employment
        else
        If Strings[i+1]='' then Strings[i+1]:=IntToStr(ClientUltimateAge(RetNo)); //to age
       end;
      end;

      If Vl(Strings[i]) < ClientAge(RetNo) then Strings[i]:=IntToStr(ClientAge(RetNo));
      If Vl(Strings[i+1]) > ClientUltimateAge(RetNo) then Strings[i+1]:=IntToStr(ClientUltimateAge(RetNo));
      If Vl(Strings[i+1]) < Vl(Strings[i]) then Strings[i+1]:=Strings[i];
     end;
      Inc(i,8);
    until i>218;   //241  20090525

   // Spouse Age
    i:=14;
    Repeat
     If Tv[i-1]>0 then
     begin
      If (i>=46) and (i<=78) then //pensions dates
      begin
        If Strings[i]='' then Strings[i]:=IntToStr(SpouseAgeAtRetirement(RetNo)); //SpRetAge;  //frpm age
        If Strings[i+1]='' then Strings[i+1]:=IntToStr(SpouseUltimateAge(RetNo));
      end
      else  //other than pensions
      Begin
       If Strings[i]='' then Strings[i]:=IntToStr(ClientAge(RetNo)); //from age
       If Strings[i+1]='' then
       begin
        If i<38 then If Strings[i+1]='' then Strings[i+1]:=ClRetAge  //employment
        else
        If Strings[i+1]='' then Strings[i+1]:=IntToStr(ClientUltimateAge(RetNo)); //to age
       end;
      end;

      If Vl(Strings[i]) < SpouseAge(RetNo) then Strings[i]:=IntToStr(SpouseAge(RetNo));
      If Vl(Strings[i+1]) > SpouseUltimateAge(RetNo) then Strings[i+1]:=IntToStr(SpouseUltimateAge(RetNo));
      If Vl(Strings[i+1]) < Vl(Strings[i]) then Strings[i+1]:=Strings[i];
     end;
     Inc(i,8);
    until i>222; //245;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure PCashFlow(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
    YearExp:Real;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  //do not blank elm 231 and 232
  For i:=1 to 230 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  Strings[231]:='N';
  If Ret[RetNo].MarStatus >2 then
   Strings[5]:=ClientFirstName(RetNo)
  else
   Strings[5]:='Combined for '+ClientFirstName(RetNo)+' and '+SpouseFirstName(RetNo);

  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;
  FillHeader(RetNo,FNo,2,1);
  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);

  i:=6; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection lists
  Repeat
    CashFlowProjectionRec := CashFlowProjectionList.Items[j];
    Strings[i]:=IntToStr(CashFlowProjectionRec.Year)
              +' '+IntToStr(CashFlowProjectionRec.Age);

    Tv[i+1]:=Round(CashFlowProjectionRec.Empl[0]+CashFlowProjectionRec.Empl[1]);
    Tv[i+2]:=Round(
             CashFlowProjectionRec.InvInterest[0]+CashFlowProjectionRec.InvOther[0]
            +CashFlowProjectionRec.InvActualDivNonElig[0]
            +CashFlowProjectionRec.InvActualDivElig[0]
            +CashFlowProjectionRec.BusAndOther[0]+CashFlowProjectionRec.OthInc[0]
            +CashFlowProjectionRec.InvInterest[1]+CashFlowProjectionRec.InvOther[1]
            +CashFlowProjectionRec.BusAndOther[1]+CashFlowProjectionRec.OthInc[1]
            +CashFlowProjectionRec.InvActualDivNonElig[1]
            +CashFlowProjectionRec.InvActualDivElig[1]);
    Tv[i+3]:=Round(CashFlowProjectionRec.PensCpp[0]+CashFlowProjectionRec.PensOAS[0]
             +CashFlowProjectionRec.PensOther[0]
             +CashFlowProjectionRec.PensCpp[1]+CashFlowProjectionRec.PensOAS[1]
             +CashFlowProjectionRec.PensOther[1]);
    Tv[i+4]:=Round(Tv[i+1]+Tv[i+2]+Tv[i+3]);
    //cola,lterm for both
    Tv[i+5]:=Round(CashFlowProjectionRec.Cola);
    Tv[i+6]:=Round(CashFlowProjectionRec.LTermDebt);
    Tv[i+7]:=Round(CashFlowProjectionRec.EstTax[0]+CashFlowProjectionRec.EstTax[1]);
    Tv[i+8]:=Round(CashFlowProjectionRec.DispInc);
    Inc(i,9);
    Inc(j,1);  //projection list
   until  (i>222) or (j>RetirementParms.NumbPeriods);
  // until  (i>222) or (j>RetirementParms.NumbPeriods-1);

 end; //with
 SaveTv(RetNo,FName,FNo);
end;

Procedure PRRSP(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=1 to 230 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  //FillHeader(RetNo,FNo,2,5);
  Strings[2] := GetPresentationDate(RetNo);
  //Strings[NameElm] := ClientFirstName(RetNo)+' '+ClientLastName(RetNo);

  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;

  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);
  If WhichSpouse=0 then
    Strings[5]:= ClientFirstName(RetNo)+' '+ClientLastName(RetNo)
  Else
    Strings[5]:= SpouseFirstName(RetNo)+' '+SpouseLastName(RetNo);
  i:=6; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection lists
  k:=WhichSpouse;  //global var
  Repeat
    RRSPProjectionRec := RRSPProjectionList.Items[j];
    CashFlowProjectionRec := CashFlowProjectionList.Items[j];
    Strings[i]:=IntToStr(RRSPProjectionRec.Year)
                 +' '+IntToStr(RRSPProjectionRec.Age[K]);
    Tv[i+1]   :=CashFlowProjectionRec.DispInc;
    Tv[i+2]:=RRSPProjectionRec.PriorYrEarned[k];
    Tv[i+3]:=RRSPProjectionRec.DollarLimit;
    Tv[i+4]:=MinR(RRSPProjectionRec.PriorYrEarned[k]*0.18,
              RRSPProjectionRec.DollarLimit);
    Tv[i+5]:=RRSPProjectionRec.PriorYrPA[k];
    Tv[i+6]:=RRSPProjectionRec.PriorYrUnusedRoom[k];
    Tv[i+7]:=RRSPProjectionRec.DedLimit[k];
    Tv[i+8]:=RRSPProjectionRec.RRSPContr[k];
    Inc(i,9);
    Inc(j,1);  //projection list
   until  (i>230) or (j>RetirementParms.NumbPeriods);
   //until  (i>230) or (j>RetirementParms.NumbPeriods-1);
  end; //with

 SaveTv(RetNo,FName,FNo);
end;

Procedure PInvPln(RetNo: integer; FName: String;FNo: integer);
Var i,j,k,PeriodsPerPage,PgNo,TotPages:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=1 to 233 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';Tv[i]:=0;end;
  PeriodsPerPage:=25;
  TotPages:=GetMaxAccumPageNo(RetNo);
  PgNo := MyStrToInt(MidStr(ExtractFormInst(Fname),2,255));
  If (TotPages =0) or (PgNo =0) or (PgNo > TotPages) then exit;
  FillHeader(RetNo,FNo,2,1);
  Strings[3] := IntToStr(PgNo);
  Strings[4] := IntToStr(TotPages);
  Strings[6]:=ClientFirstName(RetNo);
  Strings[7]:=SpouseFirstName(RetNo);
  i:=8; //this form
  j:=(PgNo-1) * PeriodsPerPage;  //index to projection lists
  Repeat
    InvProjectionRec := InvProjectionList.Items[j];
    Strings[i]:=IntToStr(InvProjectionRec.Year);
    Strings[i+1]:=IntToStr(InvProjectionRec.Age[0]);
    Strings[i+2]:=IntToStr(InvProjectionRec.Age[1]);
    If Vl(Strings[i+2])=0 then Strings[i+2]:='';
    Tv[i+3]:=InvProjectionRec.DispInc;
    Tv[i+4]:=InvProjectionRec.NonSh;
    Tv[i+5]:=InvProjectionRec.Shelt[0];
    Tv[i+6]:=InvProjectionRec.Shelt[1];
    Tv[i+7]:=InvProjectionRec.SemiSh;
    Tv[i+8]:=InvProjectionRec.Other;
    Inc(i,9);
    Inc(j,1);  //projection list
   until  (i>224) or (j>RetirementParms.NumbPeriods);

 end; //with
 SaveTv(RetNo,FName,FNo);
end;




end.
