unit T3_2026calcT5013;

interface

uses


 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T3_2026Declare, T3_2026common, T3_2026common2, T3_2026TrimStr;


Function GetBoxTotalsFromAllT5013(RetNo:Integer;BoxNo:String):Real;
Function GetTheBoxNoOfT5013Ws(AmtElm:String):String;
Function FindEmptyBoxInT5013(RetNo:Integer;FNo:Integer):Integer;
Procedure T5013WS(RetNo:integer;FName:string;FNo:integer);
Function GetT5013YearEndYYYY(RetNo:Integer):Integer;
Function GetT5013FiscalPeriodEnd(RetNo:Integer):String;
Function GetT5013AccountNo(RetNo:Integer):String;
Procedure GenerateT5013Ps50Pg1Pg2Forms(RetNo:Integer);
Procedure GenerateT5013PS50PG3Forms(RetNo:Integer);

Procedure T5013FIN(RetNo: integer; FName: String;FNo: integer);
Procedure PS5(RetNo:integer;FName:string;FNo:integer);
Procedure PS9(RetNo:integer;FName:string;FNo:integer);

Procedure T661(RetNo:integer;FName:string;FNo:integer);

Function CountPS125(RetNo:Integer):Integer;
Function GetT5013SlipType(RetNo:Integer):String;
Procedure PT1135(RetNo:integer;FName:string;FNo:integer);
Function ClaimedRenouncedresources(RetNo:Integer):Boolean;
//Function IsLimitedPartnership(RetNo:Integer):Boolean;
//Function CountT5013Slips(RetNo:Integer):Integer;
Function IsT5013Shelter(RetNo:Integer):Boolean;
Procedure ClearAllT5013Slips(RetNo:Integer);
//Procedure POTHINFO(RetNo: integer; FName: String;FNo: integer);
Function GetEmptyCodeInT5013Sum:Integer;
Function GetEmptyDescrInT5013Sum(RetNo:Integer):Integer;
Procedure CalcPCCA(Cls:string;UccStart:real;
                 Additions:real;Adjustments:real;Proceeds:real;
                 Var UCC:real;Var HalfRuleAmount:real; Var UCCReduced:real;
                 OverrideIndic:String;HalfYearIndic:String;TermLossIndic:String;
                 Rate:string;
                 Var Recapture:Real;Var TerminalLoss:Real;
                 Var CCA:real;Var UccEnd:real;
                 DaysinTaxYear:integer);

Procedure T5013SUM(RetNo:integer;FName:string;FNo:integer); {slip}
Procedure PS1(RetNo:integer;FName:string;FNo:integer);
Procedure PS2(RetNo:integer;FName:string;FNo:integer);
Procedure PS6(RetNo:integer;FName:string;FNo:integer);
Procedure PS6DTL1(RetNo:integer;FName:string;FNo:integer);
Procedure PS6DTL2(RetNo:integer;FName:string;FNo:integer);
Procedure PS6DTL3(RetNo:integer;FName:string;FNo:integer);
Procedure PS8(RetNo:integer;FName:string;FNo:integer);
Procedure PS10(RetNo:integer;FName:string;FNo:integer);
Procedure PS12(RetNo:integer;FName:string;FNo:integer);
//Procedure PS19(RetNo:integer;FName:string;FNo:integer);
//Procedure PS25(RetNo:integer;FName:string;FNo:integer);
Procedure PS50(RetNo:integer;FName:string;FNo:integer);
Procedure PS52(RetNo:integer;FName:string;FNo:integer);
Procedure PS100(RetNo:integer;FName:string;FNo:integer);
Procedure PS125(RetNo:integer;FName:string;FNo:integer);
Procedure PS141(RetNo: integer; FName: String;FNo: integer);
Procedure T5013(RetNo:integer;FName:string;FNo:integer); {slip}
Procedure T5013A(RetNo:integer;FName:string;FNo:integer); {slip}

Procedure FillT5013Slip(RetNo,PS50PageNo,PS50Elm:integer;SlipFNo:Integer);
Procedure GenerateT5013Slips(RetNo:Integer);
//Procedure GenerateSomeT5013Slips(RetNo:integer;PS50PageNo:integer;Var SlipPageNo:Integer);
Procedure T5011(RetNo: integer; FName: String;FNo: integer);

implementation
Uses T3_2026Calc, vtShared, T3_2026, vtCommon, vtTrimStr;



Procedure T5013SUM(RetNo: integer; FName: String;FNo: integer);
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Strings[1]:=FetchElm(RetNo,'T5013FIN',7);
  Strings[2]:=FetchElm(RetNo,'T5013FIN',18);
  Strings[3]:=FetchElm(RetNo,'T5013FIN',38);
  Strings[4]:=FetchElm(RetNo,'T5013FIN',39);
  Strings[5]:=FetchElm(RetNo,'T5013FIN',1);
 // Strings[6]:=FetchElm(RetNo,'T5013FIN',2);
 // Strings[7]:=FetchElm(RetNo,'T5013FIN',3);
  //Strings[8]:=IntToStr(CountT5013Slips(RetNo));

  //Strings[44]:=IntToStr(CountT5013Slips(RetNo));
  //If GetT5013SlipType(RetNo)='T5013' then
    //begin
   Strings[8]:=IntToStr(CountT5013Partners(RetNo));
   If Strings[18]='' then Strings[18]:= FormatDateTime('yyyy/mm/dd',Date);  //20140101
   If Strings[21]='' then Strings[21]:= FormatDateTime('yyyy/mm/dd',Date);


  If FetchElm(RetNo,'T5013FIN',62)>'' then
  begin
   Strings[12]:='Y';
   Strings[13]:='TS'+FetchElm(RetNo,'T5013FIN',62);
  end
  Else
  begin
   Strings[12]:='';
   Strings[13]:='';
  end;
  Tv[14]:=TotMultiple(RetNo,'T5013',7);
  Tv[15]:=TotMultiple(RetNo,'T5013',9);
  Tv[264]:=TotMultiple(RetNo,'T5013',12);
  Tv[266]:=TotMultiple(RetNo,'T5013',27);

  Tv[7]:=GetBoxTotalsFromAllT5013(RetNo,'110');
  Tv[91]:=GetBoxTotalsFromAllT5013(RetNo,'120');
  Tv[149]:=GetBoxTotalsFromAllT5013(RetNo,'190');
  Tv[150]:=GetBoxTotalsFromAllT5013(RetNo,'191');
  Tv[154]:=GetBoxTotalsFromAllT5013(RetNo,'194');
  Tv[140]:=GetBoxTotalsFromAllT5013(RetNo,'210');


  // end

 // If strings[44]='0' then strings[44]:='';
 // If strings[45]='0' then strings[45]:='';

 // If Strings[8]+Strings[9]='' then Strings[8]:='X';
  //If Strings[17]='' then Strings[17]:='CAN';
  //If Strings[17]<>'CAN' then begin Strings[15]:='';Strings[16]:='';end;
  {
  If (Strings[17]='CAN') Or (Strings[17]='') then
     begin Strings[18]:='';Strings[19]:='';Strings[54]:='';end;
  If (Strings[24]='CAN') Or (Strings[24]='') then
     begin Strings[25]:='';Strings[26]:='';Strings[238]:='';end;
  If (Strings[34]='CAN') Or (Strings[34]='') then
     begin Strings[35]:='';Strings[36]:='';Strings[239]:='';end;
  If (Strings[41]='CAN') Or (Strings[41]='') then
     begin Strings[42]:='';Strings[43]:='';Strings[240]:='';end;

  If Strings[27]+Strings[28]='' then Strings[27]:='X';
  If Strings[56]+Strings[57]='' then Strings[56]:='X';
  If Strings[58]+Strings[59]='' then Strings[58]:='X';
  If Strings[60]+Strings[61]='' then Strings[60]:='X';
  If Strings[167]+Strings[168]='' then Strings[167]:='X';
  If Strings[169]+Strings[170]='' then Strings[169]:='X';
  If Strings[171]+Strings[172]='' then Strings[171]:='X';
  }
  (*  20120324
  If GetT5013SlipType(RetNo)='T5013' then
  Begin
   Tv[71]:=TotMultiple(RetNo,'T5013',31);
   Tv[72]:=TotMultiple(RetNo,'T5013',32);
  end
  else
  begin
   Tv[71]:=TotMultiple(RetNo,'T5013A',31);
   Tv[72]:=TotMultiple(RetNo,'T5013A',32);
  end;
  *)


 // Tv[131]:=Tv[130] * 125/100;
 // Tv[132]:=Tv[131]*13.3333/100;
 // Tv[134]:=Tv[133] * 145/100;
 // Tv[135]:=Tv[134]*18.9655/100;

 // If Strings[78]='34' then Strings[77]:='Partnership total gross income' else Strings[77]:='';
//  Tv[264]:=Vl(FetchElm(RetNo,'PS6',422));
//  Tv[266]:=TotMultiple(RetNo,'PS8',232);
 (*
  i:=267;
  repeat
   Strings[i]:='';
   Strings[i+1]:='';
   Strings[i+2]:='';
   Tv[i+3]:=0;
   Tv[i]:=0;
   Inc(i,4);
  until i>379;

  //populate from S6
  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS6',423))<> 0) then
  begin
    Strings[i]:='70-2';
    Strings[i-1]:=LeftStr('Qualified small business corporation shares',47);
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS6',423));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS6',424))<> 0) then
  begin
    Strings[i]:='70-3';
    Strings[i-1]:=LeftStr('Qualified farm (QFP) and qualified fishing property',47);
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS6',424));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS6',425))<> 0) then
  begin
    Strings[i]:='70-4';
    Strings[i-1]:=LeftStr('QFP/qualified fishing property from mortgage foreclosures',47);
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS6',425));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS6',26))<> 0) then
  begin
    Strings[i]:='70-17';
    Strings[i-1]:=LeftStr('Farming/fishing eligible for the capital gains deduction from ECP',47);
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS6',26));
  end;


  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS6',18))<> 0) then
  begin
    Strings[i]:='70-18';
    Strings[i-1]:='Capital gains inclusion adjustment';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS6',18));
  end;

  //populate from S2
  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (TotMultiple(RetNo,'PS2',29)+TotMultiple(RetNo,'PS2',54)> 0) then
  begin
    Strings[i]:='103';
    Strings[i-1]:='Donations and Gifts';
    Tv[i+2]:=TotMultiple(RetNo,'PS2',29)+TotMultiple(RetNo,'PS2',54);
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (TotMultiple(RetNo,'PS2',73)+TotMultiple(RetNo,'PS2',92)> 0) then
  begin
    Strings[i]:='104';
    Strings[i-1]:=LeftStr('Gifts: certified cultural/ecologically sensitive land',47);
    Tv[i+2]:=TotMultiple(RetNo,'PS2',73)+TotMultiple(RetNo,'PS2',92);
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (TotMultiple(RetNo,'PS2',111)> 0) then
  begin
    Strings[i]:='105';
    Strings[i-1]:='Federal political contributions';
    Tv[i+2]:=TotMultiple(RetNo,'PS2',111);
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (TotMultiple(RetNo,'PS2',130)> 0) then
  begin
    Strings[i]:='106';
    Strings[i-1]:=LeftStr('Prov/territorial political contributions',47);
    Tv[i+2]:=TotMultiple(RetNo,'PS2',130);
  end;

  //populate from S12
  //find empty code and post
  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',15))<> 0) then
  begin
    Strings[i]:='90';
    Strings[i-1]:='Canadian Exploration Expenses';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',15));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',26))<> 0) then
  begin
    Strings[i]:='91';
    Strings[i-1]:='Canadian development expenses';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',26));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',38))<> 0) then
  begin
    Strings[i]:='92';
    Strings[i-1]:='Canadian oil and gas property expenses';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',38));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',72))<> 0) then
  begin
    Strings[i]:='93';
    Strings[i-1]:=LeftStr('Total Foreign expl/development expenses',47);
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',72));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',73))<> 0) then
  begin
    Strings[i]:='94';
    Strings[i-1]:='Recapture of earned depletion';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',73));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',74))<> 0) then
  begin
    Strings[i]:='95';
    Strings[i-1]:=LeftStr('Amount eligible for resource allowance deduction',47);
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',74));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',16))<> 0) then
  begin
    Strings[i]:='96';
    Strings[i-1]:='Assistance for Cdn Exploration expenses';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',16));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',27))<> 0) then
  begin
    Strings[i]:='97';
    Strings[i-1]:='Assistance for Cdn development expenses';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',27));
  end;

  i:=GetEmptyCodeinT5013Sum;
  If (i>0) and (Vl(FetchElm(RetNo,'PS12',39))<> 0) then
  begin
    Strings[i]:='98';
    Strings[i-1]:='Assistance for Cdn oil/gas property expenses';
    Tv[i+2]:=Vl(FetchElm(RetNo,'PS12',39));
  end;

  j:=4;
  Repeat
    If Vl(FetchElm(RetNo,'POTHINFO',j))<>0 then
    begin
       i:=GetEmptyCodeinT5013Sum;
       If I>0 then
       begin
        Strings[i]:=FetchElm(RetNo,'POTHINFO',j-3); //code
        Tv[i+2]:=Vl(FetchElm(RetNo,'POTHINFO',j));  //amount
        Strings[i-1]:=LeftStr(FetchElm(RetNo,'POTHINFO',j-2),48);   //descr
        Strings[i+1]:=FetchElm(RetNo,'POTHINFO',j-1);   //Province
       end;
    end;
    Inc(j,4);
  until J>103;

  //descriptive info
  For i:=383 to 402 do Strings[i]:='';
  j:=179;
  Repeat
    If FetchElm(RetNo,'POTHINFO',j)>'' then
    begin
       i:=GetEmptyDescrInT5013Sum(RetNo);
       If I>0 then
       begin
        Strings[i]:=FetchElm(RetNo,'POTHINFO',j); //descr
        Strings[i-1]:=FetchElm(RetNo,'POTHINFO',j-2); //code
       end;
    end;
    Inc(j,3);
  until J>251;
 *)
  //renounced fro PS52
  TV[149]:=Vl(FetchElm(RetNo,'PS52',33));
  TV[150]:=Vl(FetchElm(RetNo,'PS52',34));
//  TV[153]:=Vl(FetchElm(RetNo,'PS52',35));
//  TV[151]:=Vl(FetchElm(RetNo,'PS52',56));
//  TV[152]:=Vl(FetchElm(RetNo,'PS52',57));
  TV[154]:=Vl(FetchElm(RetNo,'PS52',78));
//  TV[155]:=Vl(FetchElm(RetNo,'PS52',79));
//  TV[156]:=Vl(FetchElm(RetNo,'PS52',104));
 {
  TV[157]:=Vl(FetchElm(RetNo,'PS52',105));
  TV[158]:=Vl(FetchElm(RetNo,'PS52',106));
  TV[159]:=Vl(FetchElm(RetNo,'PS52',107));

  Tv[161]:=TotMultiple(RetNo,'T5013A',194);
  Tv[163]:=TotMultiple(RetNo,'T5013A',196);
  If Tv[161]>0 then
   Tv[162]:=Tv[163] / Tv[161]
  else
   Tv[162]:=0;
  Tv[164]:=TotMultiple(RetNo,'T5013A',197);
  Tv[165]:=TotMultiple(RetNo,'T5013A',198);
  Tv[166]:=TotMultiple(RetNo,'T5013A',199);
  }
 {
  If Strings[179]+Strings[180]='' then begin Strings[179]:='X';Strings[180]:='X';End;
  If Vl(FetchElm(RetNo,'PS2#1',73))+ Vl(FetchElm(RetNo,'PS2#1',92))>0 then
  begin
   Strings[183]:='';Strings[184]:='X';end
  Else
  Begin
   Strings[183]:='X';Strings[184]:='';
  end;
  If ClaimedRenouncedResources(RetNo) then
  begin Strings[185]:='';Strings[186]:='X'; end
  Else Begin Strings[185]:='X';Strings[186]:=''; end;


  If Ret[RetNo].FrmHasData[GetFormNo('PS12')] then  //20110315
  begin Strings[191]:='';Strings[192]:='X'; end
  Else Begin Strings[191]:='X';Strings[192]:=''; end;


  If Ret[RetNo].FrmHasData[GetFormNo('PS19')] then  //20110315
  begin Strings[197]:='';Strings[198]:='X'; end
  Else Begin Strings[197]:='X';Strings[198]:=''; end;

  If Ret[RetNo].FrmHasData[GetFormNo('PT1135')] then
  begin Strings[203]:='';Strings[204]:='X'; end
  Else Begin Strings[203]:='X';Strings[204]:=''; end;
  }
  If Strings[236]='' then Strings[236]:=FormatDateTime('yyyy/mm/dd',Date);
 end;
 SaveTv(RetNo,FName,FNo);
end;



Procedure T5013FIN(RetNo: integer; FName: String;FNo: integer);
Var  i,j: integer; s:String;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  //Left side
 // If Strings[2]+Strings[3]='' then Strings[3]:='X';
  If Strings[11]+Strings[12]='' then Strings[12]:='X';

  If Strings[46]+Strings[157]='' then Strings[46]:='X';  //20170306
  //right hand side
  //Strings[45]:=IntToStr(CountT5013Slips(RetNo));
  If Strings[36]+Strings[37]='' then Strings[37]:='X';
    If Strings[38]='' then
  begin
    Strings[38]:=Appyear+'/01/01';
    Strings[39]:=Appyear+'/12/31';
  end;
  If Strings[39]>'' then  //20130217
  begin
   If Strings[39]> IntToStr(MyStrToInt(AppYear)+1)+'/12/31' then
   begin
     Strings[1]:='';
     Strings[38]:='';
     Strings[39]:='';
     Exit;
   end;
  end;

  If Strings[40]+Strings[41]='' then Strings[40]:='X';
  If Strings[42]+Strings[43]='' then Strings[43]:='X';
  If Strings[158]+Strings[159]='' then Strings[159]:='X';  //20170306

  //s:=IntToStr(CountT5013Partners(RetNo));
  Strings[45]:=IntToStr(CountT5013Partners(RetNo));

  {
  Strings[45]:='';Strings[46]:='';
  If (IsT5013Shelter(RetNo)=True) Or (ClaimedRenouncedResources(RetNo)=True) then
      begin Strings[46]:=s; Strings[45]:='';end
  Else
      begin Strings[45]:=s; Strings[46]:='';end;
  }
  If Strings[47]+Strings[48]='' then Strings[48]:='X';
 // If Strings[50]+Strings[51]='' then Strings[51]:='X';  //20170306

  //Page 2
  Strings[63]:=GetT5013AccountNo(RetNo);
  Strings[64]:=GetT5013FiscalPeriodEnd(RetNo);

  //complety automaticaly
  i:=65;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2)
  until i>89;


  Tv[132]:=Vl(FetchElm(RetNo,'PS52',118));

  //Page 3  ??
  Strings[91]:=GetT5013AccountNo(RetNo);
  Strings[92]:=GetT5013FiscalPeriodEnd(RetNo);

  i:=93;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2);
  until i>105;

  i:=109;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2);
  until i>123;

  i:=126;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2);
  until i>128;


  //Page 4  ??
  Strings[134]:=GetT5013AccountNo(RetNo);
  Strings[135]:=GetT5013FiscalPeriodEnd(RetNo);
  //???  auto
  If Strings[145]='' then Strings[145]:= FormatDateTime('yyyy/mm/dd',Date);
  If Strings[148]+Strings[149]='' then Strings[148]:='X';
  If Strings[153]+Strings[154]='' then Strings[153]:='X';

 end;


 SaveTv(RetNo,FName,FNo);
end;

Function GetEmptyCodeInT5013Sum:Integer;
Var i:Integer;
begin
 Result:=0;
 i:=270;
 Repeat
  If Tv[i]=0 then begin result:=i-2;exit;end;
  Inc(i,4);
 until i>382;
end;

Function GetEmptyDescrInT5013Sum(RetNo:Integer):Integer;
Var i:Integer;AFNo:Integer;
begin
 Result:=0;
 AFNo:=GetFormNo('T5013SUM');
 i:=384;
 Repeat
  If FetchElmFNo(RetNo,AFNo,i)='' then begin result:=i;exit;end;
  Inc(i,2);
 until i>402;
end;


Procedure T5013(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  If Strings[29]+Strings[30]='' then Strings[29]:='X';
  If Strings[1]='' then Strings[1]:='N';
  Strings[3]:='';
  Strings[6]:='';
  Strings[8]:='';
 //done in generateT5013Slips
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure PS8(RetNo: integer;FName: string;FNo: integer);
Var i:integer;FInst :String[4];NumDays:Integer;
begin
  NumDays:=GetT5013NumDays(RetNo);
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillPHeader(RetNo,FNo,1,2,3);
    If Strings[4]+Strings[44] = '' then Strings[44] := 'X';
    {CCA}
    For i:=230 to 233 do Tv[i] :=0;
    I := 6;
    Repeat
     If Strings[i]='' then
     begin
      Tv[i+1]:=0;
      Tv[i+2]:=0;
      Tv[i+3]:=0;
      Tv[i+4]:=0;
      Tv[i+5]:=0;
      Tv[i+6]:=0;
      Tv[i+7]:=0;
     end;
      Tv[i+2]:=MaxR(0,Tv[i+2]);
      If Uppercase(Strings[i+8]) <> 'O' then Strings[i+11] := GetCCARate(Strings[i]);
      If (Strings[i] > '') and (Strings[i+9] ='') then {half year indic}
         Strings[i+9] := 'H';  {half year}
      If UpperCase(Strings[i+8]) = 'O' then {override}
       begin
        If Tv[i+2]=0 then
         Tv[i+15] := MaxR(0,Tv[i+7]-Tv[i+14])
        else
         Tv[i+15] := MaxR(0,Tv[i+5]-Tv[i+14]);
       end
      {no action}
      else
      begin
      CalcPCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],Tv[i+4],
                       Tv[i+5],Tv[i+6],Tv[i+7],
                       Strings[i+8],Strings[i+9],Strings[i+10],
                       Strings[i+11],
                       Tv[i+12],Tv[i+13],Tv[i+14],Tv[i+15],
                       NumDays);
     end;
     If (AllTrim(Strings[i]) = '29') and (Vl(Strings[i+11])=0) then
       Strings[i+11] :='N/A';
     Tv[230] := Tv[230] + Tv[I+12];
     Tv[231] := Tv[231] + Tv[I+13];
     Tv[232] := Tv[232] + Tv[I+14];
     Tv[233] := Tv[233] + Tv[I+15];
     I := i+16;
    until i > 198;
    {bring from S8LH}
    If Finst = '#1' then
    begin
     Tv[215] := Vl(FetchElm(RetNo,'PS8LH',142)); {ucc}
     Tv[217] := Vl(FetchElm(RetNo,'PS8LH',143)); {adj}
     Tv[218] := Vl(FetchElm(RetNo,'PS8LH',144)); {Disp}
     Tv[221] := Vl(FetchElm(RetNo,'PS8LH',145)); {reduced UCC}
     Tv[228] := Vl(FetchElm(RetNo,'PS8LH',147)); {CCA}
     Tv[229] := Vl(FetchElm(RetNo,'PS8LH',148)); {ending ucc}
     If Tv[228] >0 then Strings[214] := '13';
    end;
    {total CCA}
    Tv[232] := Tv[232] + Tv[228];
    Tv[234] := AddColumns(8,200,16)+Tv[216];
    Tv[235] := AddColumns(10,202,16)+Tv[218];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure GenerateT5013Slips(RetNo:Integer);
{gen slips for each of the Ps50 pages, check all until no slips on a page}
{SlipPageNo is the first processed for each page}
{Num of slips is the number of slips for each page}
Const Fmt='##########.##';
 Var i,ii,j,k,SlipFNo,FromFNo,PS50PageNo,SlipPageNo,NumOfSlips:Integer;SlipNo:Integer; SlipType:String;
 Percent,CreditPercent,GrossUp:Real;AtRiskAmt:Real;
 ActualNonEligDividends, ActualEligDividends:Real;
 WsFNo:Integer;
 TypeOfPartner,BoxNumber:String;
 begin
  SlipType:='T5013';
  WsFNo:=GetFormNo('T5013WS');
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec.FormName = 'PS50' then
   Begin
     k := MyStrToInt(FetchElmFNo(RetNo,Frec.FormNo,10));
     SlipFNo:=GetFormNo(SlipType+'#'+IntToStr(k));
     If SlipFNo=0 then  {slip does not exist}
     begin
      AddPageInstance(RetNo,SlipType,'#'+IntToStr(k));
      SlipFno := GetFormNo(SlipType+'#'+IntToStr(k)); {get it again}
     end;

     If SlipFNo > 0 then
     begin
      Ret[RetNo].FrmHasData[SlipFNo] := True;
     end;
     FromFNo:=GetFormNo('T5013FIN');
     StoreElm(RetNo,SlipFNo,2,FetchElmFNo(RetNo,FromFNo,39)); //Y/e
     StoreElm(RetNo,SlipFNo,3,MidStr(FetchElmFNo(RetNo,FromFNo,39),6,2)); {mm}
     StoreElm(RetNo,SlipFNo,4,FetchElmFNo(RetNo,FromFNo,1)); {filer no}
     StoreElm(RetNo,SlipFNo,5,'TS'+FetchElmFNo(RetNo,FromFNo,62)); {tax shelter no}
     //20100326
     StoreElm(RetNo,SlipFNo,6,FetchElmFNo(RetNo,FromFNo,119)); {publicly}  //Yes or NO?
     If FetchELmFNo(RetNo,SlipFNo,8)='' then StoreElm(RetNo,SlipFNo,8,'0');  //type of slip
     StoreElm(RetNo,SlipFNo,9,''); //partnship code - blank by specs

     FromFNo:=GetFormNo('PS50#'+AllTrim(IntToStr(k)));
     TypeOfPartner:=FetchElmFNo(RetNo,FromFNo,14);
     StoreElm(RetNo,SlipFNo,10,FetchElmFNo(RetNo,FromFNo,24)); {country code}
     If FetchELmFNo(RetNo,SlipFNo,10)='' then StoreElm(RetNo,SlipFNo,10,'CAN');
     StoreElm(RetNo,SlipFNo,11,FetchElmFNo(RetNo,FromFNo,15)); {member code}
   //  StoreElm(RetNo,SlipFNo,12,FetchElmFNo(RetNo,FromFNo,61)); {units held}    ???
     StoreElm(RetNo,SlipFNo,13,FetchElmFNo(RetNo,FromFNo,16)); {%}
     StoreElm(RetNo,SlipFNo,14,FetchElmFNo(RetNo,FromFNo,13)); {recipient id}
     StoreElm(RetNo,SlipFNo,204,FetchElmFNo(RetNo,FromFNo,14)); {type}


     //recipient address
     StoreElm(RetNo,SlipFNo,15,FetchElmFNo(RetNo,FromFNo,11)); //last name
     StoreElm(RetNo,SlipFNo,80,FetchElmFNo(RetNo,FromFNo,30)); //first name
     StoreElm(RetNo,SlipFNo,81,FetchElmFNo(RetNo,FromFNo,34)); //initials
     StoreElm(RetNo,SlipFNo,17,FetchElmFNo(RetNo,FromFNo,20)); //street
     StoreElm(RetNo,SlipFNo,18,FetchElmFNo(RetNo,FromFNo,21)); //city
     StoreElm(RetNo,SlipFNo,19,FetchElmFNo(RetNo,FromFNo,22)); //prov
     StoreElm(RetNo,SlipFNo,20,FetchElmFNo(RetNo,FromFNo,23)); //postal

     AtRiskAmt:=Vl(FetchElmFNo(RetNo,FromFNo,31));

    //?? HOW StoreElm(RetNo,SlipFNo,194,FetchElmFNo(RetNo,FromFNo,61)); //num units //20131230

    //partnership info
     FromFNo:=GetFormNo('T5013FIN');
     StoreElm(RetNo,SlipFNo,21,FetchElmFNo(RetNo,FromFNo,7)); {p name}
     StoreElm(RetNo,SlipFNo,22,FetchElmFNo(RetNo,FromFNo,13)); {p str}
     StoreElm(RetNo,SlipFNo,23,FetchElmFNo(RetNo,FromFNo,14)); {p city}
     StoreElm(RetNo,SlipFNo,24,FetchElmFNo(RetNo,FromFNo,15)); {p prov}
     StoreElm(RetNo,SlipFNo,25,FetchElmFNo(RetNo,FromFNo,16)); {p postal}
     StoreElm(RetNo,SlipFNo,26,FetchElmFNo(RetNo,FromFNo,17)); {p country}
     StoreElm(RetNo,SlipFNo,25,FetchElmFNo(RetNo,FromFNo,18)); //postal zip

     If FetchElmFNo(RetNo,SlipFNo,29) >'' then  //based on partners interest
     Begin
      For j:=32 to 67 do begin StoreElm(RetNo,SlipFNo,j,'');end;  //initialize boxes/amounts
      If AtRiskAmt>0  then //at risk
      Begin
       StoreElm(RetNo,SlipFNo,32,'105');
       StoreElm(RetNo,SlipFNo,34,FormatFloat('#########.##',AtRiskAmt)); {at risk}
      end;

      Percent:=Vl(FetchElmFNo(RetNo,SlipFNo,13))/100;

      StoreElm(RetNo,SlipFNo,7,FormatFloat('#########.##',Vl(FetchElmFNo(RetNo,WsFNo,4))* Percent));  //bx 10
      StoreElm(RetNo,SlipFNo,9,FormatFloat('#########.##',Vl(FetchElmFNo(RetNo,WsFNo,26))* Percent)); //bx 20
      StoreElm(RetNo,SlipFNo,12,FormatFloat('#########.##',Vl(FetchElmFNo(RetNo,WsFNo,120))* Percent)); //bx 30
      StoreElm(RetNo,SlipFNo,27,FormatFloat('#########.##',Vl(FetchElmFNo(RetNo,WsFNo,166))* Percent)); //bx 40


      //Get Other amounts from ws
      j:=4; //index to  amount of ws
      Repeat
       If (j<>4) and (j<>26) and (j<>120) and (j<>166) then  //codes 010,020,030,040 already done above
       Begin
        If Vl(FetchElmFNo(RetNo,WsFNo,j))<>0 then
        begin
         k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
         If (k>0) and (k<68) then  //low and upper elms of slip boxes
         begin
           StoreElm(RetNo,SlipFNo,k,FormatFloat('##########.##',Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent));
           StoreElm(RetNo,SlipFNo,k-1, FetchElmFNo(RetNo,WsFNo,j-1));
           BoxNumber:=GetTheBoxNoOfT5013Ws(PaddZero(IntToStr(j),3));
           StoreElm(RetNo,SlipFNo,k-2,BoxNumber);
           If BoxNumber='129' then ActualNonEligDividends:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;
           If BoxNumber='132' then ActualEligDividends:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;
         end;
        end;
       end;
       Inc(j,2);
      until j>240;
     end;


     //20140615
     //Now add taxable dividends and Dividend tax credit if not Corp partner
     GrossUp:=1.25;
     CreditPercent:=13.3333;
     If LeftStr(FetchElm(RetNo,'T5013FIN',39),4)>'2013' then
     begin
        Grossup:=1.18;
        CreditPercent:=11.0169;
     end;

     If (ActualNonEligDividends>0)
     and ((TypeofPartner ='1') or (TypeofPartner ='3') Or (TypeofPartner ='4')) then //box 129
     begin
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         StoreElm(RetNo,SlipFNo,k,FormatFloat('##########.##',ActualNonEligDividends * GrossUp));
         StoreElm(RetNo,SlipFNo,k-2,'130');  //taxable
       end;
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         StoreElm(RetNo,SlipFNo,k,FormatFloat('##########.##',ActualNonEligDividends * GrossUp * CreditPercent/100));
         StoreElm(RetNo,SlipFNo,k-2,'131');  //taxable
       end;
     end;

     If (ActualEligDividends>0)
     and ((TypeofPartner ='1') or (TypeofPartner ='3') Or (TypeofPartner ='4')) then //box 129
     begin
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         StoreElm(RetNo,SlipFNo,k,FormatFloat('##########.##',ActualEligDividends * 1.38));
         StoreElm(RetNo,SlipFNo,k-2,'133');  //taxable
       end;
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         StoreElm(RetNo,SlipFNo,k,FormatFloat('##########.##',ActualEligDividends * 1.38 * 15.0198/100));
         StoreElm(RetNo,SlipFNo,k-2,'134');  //taxable
       end;
     end;

     //201160209
     j:=32;
     Repeat
      If Vl(FetchElmFNo(RetNo,SlipFNo,j))=0 then StoreElm(RetNo,SlipFNo,j+2,'');  //20160209
      Inc(j,3);
     until j>41;

    end; //rec = ps50
 end; //i
end;

Function FindEmptyBoxInT5013(RetNo:Integer;FNo:Integer):Integer;
Var i:Integer;
Begin
  Result:=0;
  i:=34;
  Repeat
   If Vl(FetchElmFNo(RetNo,FNo,i))=0 then begin result:=i;Exit;End;
   Inc(i,3);
  until i>67;
end;


(*  OLD
Procedure GenerateT5013Slips(RetNo:Integer);
{gen slips for each of the Ps50 pages, check all until no slips on a page}
{SlipPageNo is the first processed for each page}
{Num of slips is the number of slips for each page}
Const Fmt='##########.##';
Var i,ii,j,k,SlipFNo,FromFNo,PS50PageNo,SlipPageNo,NumOfSlips:Integer;SlipNo:Integer; SlipType:String;
Percent:Real;
begin
 ClearAllT5013Slips(RetNo);
 //SlipNo:=0;
 SlipType:='T5013';
// If (IsT5013Shelter(RetNo)) or (ClaimedRenouncedResources(RetNo)) then SlipType:='T5013A';

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName = 'PS50' then
   Begin
     k := MyStrToInt(FetchElmFNo(RetNo,Frec.FormNo,10)); //'#'+IntToStr(SlipNo));
     //FromFromFNo:=GetFormNo('PS50');
     SlipFNo:=GetFormNo(SlipType+'#'+IntToStr(k));
     If SlipFNo=0 then  {slip does not exist}
     begin
      AddPageInstance(SlipType,'#'+IntToStr(k));
      SlipFno := GetFormNo(SlipType+'#'+IntToStr(k)); {get it again}
     end;

     If SlipFNo > 0 then
     begin
      Ret[RetNo].FrmHasData[SlipFNo] := True;
     end;
     FromFNo:=GetFormNo('T5013FIN');
     StoreElm(RetNo,SlipFNo,2,FetchElmFNo(RetNo,FromFNo,39)); //Y/e
     StoreElm(RetNo,SlipFNo,3,MidStr(FetchElmFNo(RetNo,FromFNo,39),6,2)); {mm}
     StoreElm(RetNo,SlipFNo,4,FetchElmFNo(RetNo,FromFNo,1)); {filer no}
     StoreElm(RetNo,SlipFNo,5,FetchElmFNo(RetNo,FromFNo,62)); {tax shelter no}
     //20100326
     StoreElm(RetNo,SlipFNo,6,FetchElmFNo(RetNo,FromFNo,119)); {publicly}  //Yes or NO?
     If FetchELmFNo(RetNo,SlipFNo,8)='' then StoreElm(RetNo,SlipFNo,8,'0');  //type of slip
     StoreElm(RetNo,SlipFNo,9,''); //partnship code - blank by specs

     FromFNo:=GetFormNo('PS50#'+AllTrim(IntToStr(k)));
     StoreElm(RetNo,SlipFNo,10,FetchElmFNo(RetNo,FromFNo,24)); {country code}
     If FetchELmFNo(RetNo,SlipFNo,10)='' then StoreElm(RetNo,SlipFNo,10,'CAN');
     StoreElm(RetNo,SlipFNo,11,FetchElmFNo(RetNo,FromFNo,15)); {member code}
     StoreElm(RetNo,SlipFNo,12,FetchElmFNo(RetNo,FromFNo,61)); {units held}
     StoreElm(RetNo,SlipFNo,13,FetchElmFNo(RetNo,FromFNo,16)); {%}
     StoreElm(RetNo,SlipFNo,14,FetchElmFNo(RetNo,FromFNo,13)); {recipient id}
     StoreElm(RetNo,SlipFNo,204,FetchElmFNo(RetNo,FromFNo,14)); {type}
     //recipient address
     StoreElm(RetNo,SlipFNo,15,FetchElmFNo(RetNo,FromFNo,11)); //name
     StoreElm(RetNo,SlipFNo,17,FetchElmFNo(RetNo,FromFNo,20)); //street
     StoreElm(RetNo,SlipFNo,18,FetchElmFNo(RetNo,FromFNo,21)); //city
     StoreElm(RetNo,SlipFNo,19,FetchElmFNo(RetNo,FromFNo,22)); //prov
     StoreElm(RetNo,SlipFNo,20,FetchElmFNo(RetNo,FromFNo,23)); //postal

    //?? HOW StoreElm(RetNo,SlipFNo,194,FetchElmFNo(RetNo,FromFNo,61)); //num units //20131230

    //partnership info
     FromFNo:=GetFormNo('T5013FIN');
     StoreElm(RetNo,SlipFNo,21,FetchElmFNo(RetNo,FromFNo,7)); {p name}
     StoreElm(RetNo,SlipFNo,22,FetchElmFNo(RetNo,FromFNo,13)); {p str}
     StoreElm(RetNo,SlipFNo,23,FetchElmFNo(RetNo,FromFNo,14)); {p city}
     StoreElm(RetNo,SlipFNo,24,FetchElmFNo(RetNo,FromFNo,15)); {p prov}
     StoreElm(RetNo,SlipFNo,25,FetchElmFNo(RetNo,FromFNo,16)); {p postal}
     StoreElm(RetNo,SlipFNo,26,FetchElmFNo(RetNo,FromFNo,17)); {p country}
     StoreElm(RetNo,SlipFNo,25,FetchElmFNo(RetNo,FromFNo,18)); //postal zip

     Percent:=Vl(FetchElmFNo(RetNo,SlipFNo,13))/100;

     FromFNo:=GetFormNo('T5013SUM');   //for amounts

     If UpperCase(FetchElmFNo(RetNo,SlipFNo,1)) <> 'Y' then
     Begin
      StoreElm(RetNo,SlipFNo,27,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,67))*Percent)); //bx 20
      StoreElm(RetNo,SlipFNo,28,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,68))*Percent)); //bx 20-1
      StoreElm(RetNo,SlipFNo,29,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,69))*Percent)); //bx 21
      StoreElm(RetNo,SlipFNo,30,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,70))*Percent)); //bx 22
      //manual entry of at risk amount
      StoreElm(RetNo,SlipFNo,33,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,73))*Percent)); //bx 23
      StoreElm(RetNo,SlipFNo,34,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,74))*Percent)); //bx 24
      StoreElm(RetNo,SlipFNo,35,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,75))*Percent)); //bx 25
      StoreElm(RetNo,SlipFNo,36,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,76))*Percent)); //bx 27

      //generic
      StoreElm(RetNo,SlipFNo,37,FetchElmFNo(RetNo,FromFNo,78)); //
      StoreElm(RetNo,SlipFNo,38,FetchElmFNo(RetNo,FromFNo,79)); //
      StoreElm(RetNo,SlipFNo,39,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,80))*Percent)); //
      For j:=40 to 48 do StoreElm(RetNo,SlipFNo,j,'');


      //can and foreign net bus inc
      StoreElm(RetNo,SlipFNo,49,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,89))*Percent)); //bx 35
      StoreElm(RetNo,SlipFNo,50,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,91))*Percent)); //bx 37
      StoreElm(RetNo,SlipFNo,51,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,93))*Percent)); //bx 41
      StoreElm(RetNo,SlipFNo,52,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,95))*Percent)); //bx 43
      StoreElm(RetNo,SlipFNo,53,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,86))*Percent)); //bx 30
      StoreElm(RetNo,SlipFNo,54,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,87)))); //20090717 *Percent)); //bx 34
      StoreElm(RetNo,SlipFNo,55,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,129))*Percent)); //bx 26
      StoreElm(RetNo,SlipFNo,56,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,130))*Percent)); //bx 51
      StoreElm(RetNo,SlipFNo,57,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,131))*Percent)); //bx 51-1
      StoreElm(RetNo,SlipFNo,58,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,132))*Percent)); //bx 51-2
      StoreElm(RetNo,SlipFNo,59,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,133))*Percent)); //bx 52
      StoreElm(RetNo,SlipFNo,60,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,134))*Percent)); //bx 52-1
      StoreElm(RetNo,SlipFNo,61,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,135))*Percent)); //bx 52-2
      StoreElm(RetNo,SlipFNo,62,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,136))*Percent)); //bx 50
      StoreElm(RetNo,SlipFNo,63,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,138))*Percent)); //bx 55
      StoreElm(RetNo,SlipFNo,64,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,139))*Percent)); //bx 56
      StoreElm(RetNo,SlipFNo,65,FormatFloat(Fmt,vl(FetchElmFNo(RetNo,FromFNo,140))*Percent)); //bx 59
       //generic
      StoreElm(RetNo,SlipFNo,66,FetchElmFNo(RetNo,FromFNo,142)); //
      StoreElm(RetNo,SlipFNo,69,FetchElmFNo(RetNo,FromFNo,146)); //
      StoreElm(RetNo,SlipFNo,72,FetchElmFNo(RetNo,FromFNo,82)); //
      StoreElm(RetNo,SlipFNo,67,FetchElmFNo(RetNo,FromFNo,143)); //
      StoreElm(RetNo,SlipFNo,70,FetchElmFNo(RetNo,FromFNo,147)); //
      StoreElm(RetNo,SlipFNo,73,FetchElmFNo(RetNo,FromFNo,83)); //

      StoreElm(RetNo,SlipFNo,68,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,144))*Percent)); //
      StoreElm(RetNo,SlipFNo,71,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,148))*Percent)); //
      StoreElm(RetNo,SlipFNo,74,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,84))*Percent)); //
      //other amounts
      StoreElm(RetNo,SlipFNo,75,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,264))*Percent)); //bx 70
      StoreElm(RetNo,SlipFNo,76,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,265))*Percent)); //bx 71
      StoreElm(RetNo,SlipFNo,77,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,266))*Percent)); //bx 85

      //resource amounts  //20090717
      StoreElm(RetNo,SlipFNo,176,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,149))*Percent)); //bx 120
      StoreElm(RetNo,SlipFNo,177,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,150))*Percent)); //bx 121
      StoreElm(RetNo,SlipFNo,178,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,151))*Percent)); //bx 124
      StoreElm(RetNo,SlipFNo,179,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,152))*Percent)); //bx 125
      StoreElm(RetNo,SlipFNo,180,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,153))*Percent)); //bx 130
      StoreElm(RetNo,SlipFNo,181,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,154))*Percent)); //bx 128
      StoreElm(RetNo,SlipFNo,182,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,155))*Percent)); //bx 129

      StoreElm(RetNo,SlipFNo,184,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,156))*Percent)); //bx 141
      StoreElm(RetNo,SlipFNo,185,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,157))*Percent)); //bx 143
      StoreElm(RetNo,SlipFNo,186,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,158))*Percent)); //bx 144
      StoreElm(RetNo,SlipFNo,187,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,159))*Percent)); //bx 145

      //generic
      ii:=78; //index to slip
      j:=268; //index to T5013sum
      If SlipType='T5013' then k:=150 else k:=150; //108; ?? 20131229
      Repeat
       StoreElm(RetNo,SlipFNo,ii,FetchElmFNo(RetNo,FromFNo,j)); //
       StoreElm(RetNo,SlipFNo,ii+1,FetchElmFNo(RetNo,FromFNo,j+1)); //
       StoreElm(RetNo,SlipFNo,ii+2,FormatFloat(Fmt,Vl(FetchElmFNo(RetNo,FromFNo,j+2))*Percent));
       Inc(ii,3);
       Inc(j,4);
      until ii>k;

      //descriptive
      If SlipType='T5013' then  //only this slip
      begin
       ii:=155; //index to slip
       j:=383; //index to T5013sum
       Repeat
       StoreElm(RetNo,SlipFNo,ii,FetchElmFNo(RetNo,FromFNo,j)); //
       StoreElm(RetNo,SlipFNo,ii+1,FetchElmFNo(RetNo,FromFNo,j+1)); //
       Inc(ii,2);
       Inc(j,2);
      until ii>173;
      End;
     end; //override
   end; //is ps50
 end; //i
 {
 SlipPageNo:=1;
 PS50PageNo:=1;
 Repeat
   NumOfSlips := MyStrToInt(FetchElm(RetNo,'PS50#'+IntToStr(PS50PageNo),362));
   GenerateSomeT5013Slips(RetNo,PS50PageNo,SlipPageNo); {gen the slips for each page of PS50}
   Inc(PS50PageNo);
 until NumOfSlips =0; {until get a PS50 page with no partners}
 }
end;
*)
Procedure GenerateT5013PS50Pg1Pg2Forms(RetNo:Integer);   //pg1 and pg2
Var FName:string;i,j,FNo, FromFNo:Integer;NumberOfPartners,ParnersWithDisposition:Integer;
PagePrinting:Integer;
Cnt:Integer;
WhichCopy,WhichInst:integer;
InstancesRequired:Integer;
NumOfPages:Integer;
begin

 //Clear printout forms
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If Frec.FormName='PS50PG1' then  begin  For j:=1 to 133 do Begin StoreElm(RetNo,Frec.FormNo,j,'');end;end;
  If Frec.FormName='PS50PG2' then
  begin
   For j:=1 to 133 do
   Begin
    StoreElm(RetNo,Frec.FormNo,j,'');end;
    Ret[retNo].FrmHasData[Frec.FormNo]:=False;   //20120324
   end;
  end;

 NumberOfPartners:=CountT5013Partners(RetNo);
 If Odd(NumberOfPartners) then
   NumOfPages:=NumberOfPartners div 2 +1
 Else
   NumOfPages:=NumberOfPartners div 2;


 If CertificationMode=True then NumberOfPartners:=3;  //20120318
 If NumberOfPartners=0 then exit;

 If NumberofPartners<3 then
  InstancesRequired:=0
 else
  InstancesRequired:=(NumberOfPartners-2) Div 2 +1;  //for pg2  //20140318

 FName:='PS50PG2';
 For WhichInst:=2 to InstancesRequired do
 Begin
  FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
  If FNo = 0 then
  begin
   AddPageInstance(RetNo,FName,'#'+IntToStr(WhichInst));
   FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
   InitFormData(RetNo,FNo);          //20120323
  end;
 end;

 //populate the printoutes from ps50

 Cnt:=0;
 WhichCopy:=0;
 for i:=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName='PS50')
   and (Ret[RetNo].FrmHasData[Frec.FormNo])
   then
   Begin
     //Calc(RetNo,Frec.FormName);  //20140325
     FromFNo:=Frec.FormNo;
     Cnt:=Cnt+1;
     If Cnt=1 then
     Begin
      FName:='PS50PG1';
      FNo:=GetFormNo(FName);
      For j:=1 to 33 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); End; //copy to top part
      StoreElm(RetNo, FNo,10,IntToStr(1));
      StoreElm(RetNo, FNo,135,'1'); //pg number //20140325
      StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
      If CertificationMode then
      begin
       StoreElm(RetNo, FNo,10,'1');
       StoreElm(RetNo, FNo,110,'1');
      end;
     end

     Else If Cnt=2 then
     Begin
         Inc(WhichCopy);
         FName:='PS50PG1';
         For j:=10 to 33 do begin StoreElm(RetNo, FNo,j+100, FetchElmFNo(RetNo,FromFNo,j)); End; //copy to bottom part
         StoreElm(RetNo, FNo,110,'2');   //20140318
         StoreElm(RetNo, FNo,135,'1'); //pg number //20140325
         StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
         If CertificationMode then StoreElm(RetNo, FNo,110,'2');
         WhichCopy:=0;  //initialize it
     end

     Else If Cnt>2 then  //it uses the pg2 format
     Begin
        //20140319
        if odd(Cnt) then
        begin
            WhichCopy:=1;
            WhichInst:=(Cnt Div 2);
        end
        else
        begin
            WhichCopy:=2;
            WhichInst:=((Cnt-1) Div 2);
        end;

        FName:='PS50PG2';
        FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
        If FNo = 0 then
        begin
          AddPageInstance(RetNo,FName,'#'+IntToStr(WhichInst));
          FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
          InitFormData(RetNo,FNo);
          Ret[retNo].FrmHasData[FNo]:=False;   //20120324
        end;

        //populate it
        If WhichCopy=1 then
        begin
         For j:=1 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=10 to 33 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j));end;

         StoreElm(RetNo, FNo,10,IntToStr(Cnt));
         StoreElm(RetNo, FNo,135,IntToStr(WhichInst+1)); //pg number //20140325
         StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
         Ret[RetNo].FrmHasData[FNo]:=True;   //20120324
         If CertificationMode then StoreElm(RetNo, FNo,10,'1');
        end;

        If WhichCopy=2 then
        begin
         For j:=1 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=10 to 33 do begin StoreElm(RetNo, FNo,j+100, FetchElmFNo(RetNo,FromFNo,j)); end;
         StoreElm(RetNo, FNo,110,IntToStr(Cnt));
         StoreElm(RetNo, FNo,135,IntToStr(WhichInst+1)); //pg number //20140325
         StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
         Ret[RetNo].FrmHasData[FNo]:=True;   //20120324
         If CertificationMode then StoreElm(RetNo, FNo,110,'2');
        end;

     end;  //cnt >2
   end; //has data
 end;  //i
end;


Procedure GenerateT5013PS50PG3Forms(RetNo:Integer);  //pg3
Var FName:string;i,j,FNo, FromFNo:Integer;NumberOfPartners,ParnersWithDisposition:Integer;
PagePrinting:Integer; Cnt,AllCnt,InstancesRequired:Integer;
WhichInst,WhichCopy:Integer;
begin
 //Clear any pre-existing Pg3 printout forms
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];  //20120324  WAS MISSING!!
   If Frec.FormName='PS50PG3' then
    begin
     For j:=1 to 180 do Begin StoreElm(RetNo,Frec.FormNo,j,'');end;
     Ret[RetNo].FrmHasData[Frec.FormNo]:=False;   //20110324
    end;
 end;
 // create all required instances
 AllCnt:=CountT5013PartnersWithDisposition(RetNo);
 InstancesRequired:=(AllCnt Div 3)+1;
 FName:='PS50PG3';
 For WhichInst:=2 to InstancesRequired do
 Begin
  FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
  If FNo = 0 then
  Begin
    AddPageInstance(RetNo,FName,'#'+IntToStr(WhichInst));
    FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
    InitFormData(RetNo,FNo);                         //20120323
    Ret[RetNo].FrmHasData[FNo]:=False;   //20110324
  end;
 end;
 //populate Pg3 instances printout form
 Cnt:=0;
 WhichCopy:=0;
 for i:=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName='PS50') and (Ret[RetNo].FrmHasData[Frec.FormNo]) and (FetchElmFNo(RetNo,Frec.FormNo,41)>'') then  //has disp date 20120303
   Begin
        Cnt:=Cnt+1;
        //20120324


        Case cnt of
          1..3: WhichInst:=1;
          4..6: WhichInst:=2;
          7..9: WhichInst:=3;
          10..12: WhichInst:=4;
          13..15: WhichInst:=5;
          16..18: WhichInst:=6;
          19..21: WhichInst:=7;
          22..24: WhichInst:=8;
          25..27: WhichInst:=9;
          28..30: WhichInst:=10;
          31..33: WhichInst:=11;
          34..36: WhichInst:=12;
          37..39: WhichInst:=13;
          40..42: WhichInst:=14;
          43..45: WhichInst:=15;
          46..48: WhichInst:=16;
          49..51: WhichInst:=17;
          52..54: WhichInst:=18;
          55..57: WhichInst:=19;
          58..60: WhichInst:=20;
          61..63: WhichInst:=21;
          64..66: WhichInst:=22;
          67..69: WhichInst:=23;
          70..72: WhichInst:=24;
          73..75: WhichInst:=25;
          76..78: WhichInst:=26;
          79..81: WhichInst:=27;
          82..84: WhichInst:=28;
          85..87: WhichInst:=29;
          88..90: WhichInst:=30;
          91..93: WhichInst:=31;
        end;

       {
        WhichInst:= (Cnt Div 3)+1;  //20120324 // WhichInst:= (Cnt Div 3); // +1;  //integer part)
        If WhichInst=0 then WhichInst:=1;  //20120324
        }
        WhichCopy:=WhichCopy+1;
      //  If WhichCopy>3 then WhichCopy:=1;  //back to 1 if exceeds 3   //20120324  //moved below in copy 3
        FromFNo := Frec.FormNo;
        FName:='PS50PG3';
        FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
        //populate instance FNo with data
        If WhichCopy=1 then
        begin
         For j:=2 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=35 to 60 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j));end;
         StoreElm(RetNo, FNo,35,IntToStr(Cnt));
         Ret[RetNo].FrmHasData[FNo]:=True;  //20110324
        end
        else if WhichCopy=2 then
        begin
         For j:=2 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=35 to 60 do begin StoreElm(RetNo, FNo,j+60, FetchElmFNo(RetNo,FromFNo,j)); end;
         StoreElm(RetNo, FNo,95,IntToStr(Cnt));
         Ret[RetNo].FrmHasData[FNo]:=True;  //20110324
        end
        else if WhichCopy=3 then
        begin
          For j:=2 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
          For j:=35 to 60 do begin StoreElm(RetNo, FNo,j+120, FetchElmFNo(RetNo,FromFNo,j));end;
          StoreElm(RetNo, FNo,155,IntToStr(Cnt));
          WhichCopy:=0;  //initialize  //20120324
          Ret[RetNo].FrmHasData[FNo]:=True;  //20110324
        end;
   end; //has data
 end;  //i
end;

Procedure FillT5013Slip(RetNo,PS50PageNo,PS50Elm:integer;SlipFNo:Integer);
Var i,FromFNo:integer;FromForm:String[10];Percent:Real;
begin
 FromForm := 'PS50#'+IntToStr(PS50PageNo);
 FromFNo:=GetFormNo(FromForm);
 i:=PS50Elm-4; //if ps50elm is 4 then i=0 so we can use i+elm in From PS50 for readability
 StoreElm(RetNo,SlipFNo,10,FetchElmFNo(RetNo,FromFNo,i+20)); {country}
 StoreElm(RetNo,SlipFNo,11,FetchElmFNo(RetNo,FromFNo,i+6)); {member}
 StoreElm(RetNo,SlipFNo,12,FetchElmFNo(RetNo,FromFNo,i+8)); {units held}
 StoreElm(RetNo,SlipFNo,13,FetchElmFNo(RetNo,FromFNo,i+9)); {percent}
 StoreElm(RetNo,SlipFNo,14,FetchElmFNo(RetNo,FromFNo,i+5)); {partner id}
 // 175??
 StoreElm(RetNo,SlipFNo,15,FetchElmFNo(RetNo,FromFNo,i+4)); {Name}
 StoreElm(RetNo,SlipFNo,16,FetchElmFNo(RetNo,FromFNo,i+16)); {str}
 StoreElm(RetNo,SlipFNo,17,FetchElmFNo(RetNo,FromFNo,i+17)); {city}
 StoreElm(RetNo,SlipFNo,18,FetchElmFNo(RetNo,FromFNo,i+18)); {prov}
 StoreElm(RetNo,SlipFNo,19,FetchElmFNo(RetNo,FromFNo,i+19)); {postal}
 StoreElm(RetNo,SlipFNo,20,FetchElmFNo(RetNo,FromFNo,i+20)); {country}
end;

Procedure T5011(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  If UpperCase(Strings[5])='X' then Strings[2]:='531390';
  If Strings[50]+Strings[51]='' then Strings[50]:='X';
  If Strings[52]+Strings[53]='' then Strings[52]:='X';
  If Strings[55]+Strings[56]='' then Strings[55]:='X';
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure PS1(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillPHeader(RetNo,FNo,1,2,3);
  FillPHeader(RetNo,FNo,1,42,43); //2nd page
  FillPHeader(RetNo,FNo,1,158,159); //3nd page
  If Strings[150]='' then Strings[150]:='Y';
  Tv[13]:=TotMultiple(RetNo,'PS2',29)+TotMultiple(RetNo,'PS2',54)+TotMultiple(RetNo,'PS2',73)
         +TotMultiple(RetNo,'PS2',92)+TotMultiple(RetNo,'PS2',152);  //20140321
  Tv[14]:=TotMultiple(RetNo,'PS2',111)+TotMultiple(RetNo,'PS2',130)+TotMultiple(RetNo,'PS2',171); //20140321


  Tv[9]:=TotMultiple(RetNo,'PS8',230);
  Tv[49]:=TotMultiple(RetNo,'PS10',50);
  Tv[87]:=Vl(FetchElm(RetNo,'PS12',72));
  Tv[138]:=TotMultiple(RetNo,'PS10',26);
  //page 2
  //Tv[54]:=AddColumns(46,53,1);
  //Tv[55]:=Tv[54];
  Tv[102]:=AddColumns(56,61,1)+AddColumns(63,79,1)+AddColumns(81,91,1)+Tv[153];
  Tv[103]:=Tv[102];
  Tv[156]:=Tv[93]+Tv[95]+Tv[97]+Tv[99]+Tv[101];
  Tv[157]:=Tv[156];
  Tv[104]:=Tv[103]+Tv[157];

  //page 3
  Tv[132]:=AddColumns(105,121,1)+Tv[123]+Tv[125]+Tv[127]+Tv[129]+Tv[131];
  Tv[133]:=Tv[132];
  Tv[136]:=TotMultiple(RetNo,'PS8',232);
  Tv[137]:=TotMultiple(RetNo,'PS8',231);
  Tv[138]:=TotMultiple(RetNo,'PS10',24); //20130214 //TotMultiple(RetNo,'PS10',26);
  Tv[147]:=AddColumns(134,146,1); //+Tv[154];
  Tv[148]:=Tv[147];
  Tv[149]:=Tv[133]+Tv[148];
  //PAGE 1
  If UpperCase(Strings[150])='Y' then Tv[5]:= TotMultiple(RetNo,'PS125',303);
  Tv[32]:=Tv[104];
  //20160305 Igor
  Tv[33]:=Tv[151]+Tv[152]+AddColumns(6,26,1)+AddColumns(46,52,1)+Tv[32]; //20160222 //Tv[151]+Tv[152]+AddColumns(6,26,1)+AddColumns(46,53,1)+Tv[32];
  Tv[39]:=Tv[33];
  Tv[40]:=Tv[149];
  Tv[41]:=Tv[5]+Tv[39]-Tv[40];
  Tv[45]:=Tv[41]-Tv[155];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS2(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillPHeader(RetNo,FNo,1,2,3);
   If Strings[133]+Strings[4]='' then Strings[133]:='X';
   Tv[29]:=AddColumns(5,23,6);
   Tv[54]:=AddColumns(30,48,6);
   Tv[73]:=AddColumns(55,67,6);
   Tv[92]:=AddColumns(74,86,6);
   Tv[111]:=AddColumns(93,105,6);
   Tv[130]:=AddColumns(112,124,6);

   Tv[152]:=AddColumns(134,145,6);
   Tv[171]:=AddColumns(153,165,6);
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS6(RetNo: integer; FName: String;FNo: integer);
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillPHeader(RetNo,FNo,428,429,430);  //20120320
  FillPHeader(RetNo,FNo,428,433,434);  //20120320
  FillPHeader(RetNo,FNo,428,426,427);  //20120320
  Strings[426]:=FetchElm(RetNo,'T5013FIN',1);
  Strings[427]:=FetchElm(RetNo,'T5013FIN',39);

  For i:=41 to 44 do Tv[i]:=0;
  //TV[423]:=0;Tv[424]:=0;
  i:=5;
  j:=522;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[41]:=Tv[41]+Tv[i];
   Tv[42]:=Tv[42]+Tv[i+1];
   Tv[43]:=Tv[43]+Tv[i+2];
   Tv[44]:=Tv[44]+Tv[i+3];
   Inc(i,8);
   Inc(j,1);
  until i>37;

  For i:=75 to 78 do Tv[i]:=0;
  i:=47;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[75]:=Tv[75]+Tv[i];
   Tv[76]:=Tv[76]+Tv[i+1];
   Tv[77]:=Tv[77]+Tv[i+2];
   Tv[78]:=Tv[78]+Tv[i+3];
   Inc(i,6);
  until i>71;

  For i:=114 to 117 do Tv[i]:=0;
  i:=82;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[114]:=Tv[114]+Tv[i];
   Tv[115]:=Tv[115]+Tv[i+1];
   Tv[116]:=Tv[116]+Tv[i+2];
   Tv[117]:=Tv[117]+Tv[i+3];
   Inc(i,7);
  until i>110;



  For i:=158 to 161 do Tv[i]:=0;
  i:=122;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[158]:=Tv[158]+Tv[i];
   Tv[159]:=Tv[159]+Tv[i+1];
   Tv[160]:=Tv[160]+Tv[i+2];
   Tv[161]:=Tv[161]+Tv[i+3];
   Inc(i,8);
  until i>154;
   //real est
  For i:=192 to 195 do Tv[i]:=0;
  i:=164;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[192]:=Tv[192]+Tv[i];
   Tv[193]:=Tv[193]+Tv[i+1];
   Tv[194]:=Tv[194]+Tv[i+2];
   Tv[195]:=Tv[195]+Tv[i+3];
   Inc(i,6);
  until i>188;


  //pg2

  //bonds
  For i:=236 to 239 do Tv[i]:=0;
  i:=200;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[236]:=Tv[236]+Tv[i];
   Tv[237]:=Tv[237]+Tv[i+1];
   Tv[238]:=Tv[238]+Tv[i+2];
   Tv[239]:=Tv[239]+Tv[i+3];
   Inc(i,8);
  until i>232;
  //pers use
  For i:=270 to 273 do Tv[i]:=0;
  i:=242;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[270]:=Tv[270]+Tv[i];
   Tv[271]:=Tv[271]+Tv[i+1];
   Tv[272]:=Tv[272]+Tv[i+2];
   Tv[273]:=Tv[273]+Tv[i+3];
   Inc(i,6);
  until i>266;
  //listed
  For i:=304 to 307 do Tv[i]:=0;
  i:=276;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[304]:=Tv[304]+Tv[i];
   Tv[305]:=Tv[305]+Tv[i+1];
   Tv[306]:=Tv[306]+Tv[i+2];
   Tv[307]:=Tv[307]+Tv[i+3];
   Inc(i,6);
  until i>300;
  //other gains
  For i:=338 to 341 do Tv[i]:=0;
  i:=310;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[338]:=Tv[338]+Tv[i];
   Tv[339]:=Tv[339]+Tv[i+1];
   Tv[340]:=Tv[340]+Tv[i+2];
   Tv[341]:=Tv[341]+Tv[i+3];
   Inc(i,6);
  until i>334;
  //gifts of certain cap prop
  For i:=412 to 418 do Tv[i]:=0;
  i:=373;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[412]:=Tv[412]+Tv[i];
   Tv[413]:=Tv[413]+Tv[i+1];
   Tv[414]:=Tv[414]+Tv[i+2];
   Tv[415]:=Tv[415]+Tv[i+3];
   Tv[416]:=Tv[416]+Tv[i+4];
   Tv[417]:=Tv[417]+Tv[i+5];
   Tv[418]:=Tv[418]+Tv[i+6];
   Inc(i,8);
  until i>405;

  {
  Tv[421]:=TotMultiple(RetNo,'PS10',8);
  Tv[422]:=Tv[44]+Tv[78]+Tv[117]+Tv[161]+Tv[195]+Tv[239]+Tv[273]+Tv[307]+Tv[341]+Tv[418]+Tv[419]+Tv[420]+Tv[421];
  Tv[423]:=Tv[44];
  Tv[424]:=Tv[78];
  Tv[425]:=Tv[117];
  }
  //20250326
  For i:=500 to 502 do begin Tv[i]:=0;end;
  i:=464;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-TV[i+2];
   Tv[500]:=Tv[500]+Tv[i];
   Tv[501]:=Tv[501]+Tv[i+1];
   Tv[502]:=Tv[502]+Tv[i+2];
   Tv[503]:=Tv[503]+Tv[i+3];
   Inc(i,8);
  Until i>496;



 end; //with
 SaveTv(RetNo,FName,FNo);
end;


(*
Procedure PS6(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillPHeader(RetNo,FNo,1,2,3);
   Tv[5]:=ToTMultiple(RetNo,'PS6DTL1',44);
   Tv[6]:=ToTMultiple(RetNo,'PS6DTL1',78);
   Tv[7]:=ToTMultiple(RetNo,'PS6DTL1',117);
   Tv[8]:=ToTMultiple(RetNo,'PS6DTL1',161);
   Tv[9]:=ToTMultiple(RetNo,'PS6DTL1',195);

   Tv[10]:=ToTMultiple(RetNo,'PS6DTL2',44);
   Tv[11]:=ToTMultiple(RetNo,'PS6DTL2',78);
   Tv[12]:=ToTMultiple(RetNo,'PS6DTL2',112);
   Tv[13]:=ToTMultiple(RetNo,'PS6DTL2',146);
   Tv[14]:=ToTMultiple(RetNo,'PS6DTL2',190);

   Tv[15]:=ToTMultiple(RetNo,'PS6DTL3',7);
 //  Tv[16]:=ToTMultiple(RetNo,'PS6DTL3',6);
   Tv[17]:=ToTMultiple(RetNo,'PS6DTL3',5);
 //  Tv[18]:=ToTMultiple(RetNo,'PS6DTL3',185);

   Tv[21]:=TotMultiple(RetNo,'PS10',8);
   Tv[22]:=AddColumns(5,15,1)+Tv[19]+Tv[20]+Tv[21];

   Tv[23]:=Tv[5];
   Tv[24]:=Tv[6];
   Tv[25]:=Tv[7];
   Tv[26]:=Vl(FetchElm(RetNo,'PS10',65));
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

Procedure PS6DTL1(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
Row,FieldId,Elm:Integer;ArrayNo:Integer;BoxesPerRow:Integer; //needed for dynamic
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  ArrayNo:=1;
  BoxesPerRow:=9;
  Row:=1;
  FieldId:=ArrayNo*10000+StrToInt('9'); //for field id 10003 on the first row i form
  if DynamicRowHasData(RetNo,FName,FieldId) then
   StoreElm(RetNo,FNo,FieldId,IntToStr(Row));
 (* Replaced by dynamic
  For i:=41 to 44 do Tv[i]:=0;
  i:=5;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[41]:=Tv[41]+Tv[i];
   Tv[42]:=Tv[42]+Tv[i+1];
   Tv[43]:=Tv[43]+Tv[i+2];
   Tv[44]:=Tv[44]+Tv[i+3];
   Inc(i,8);
  until i>37;
 *)
  For i:=75 to 78 do Tv[i]:=0;
  i:=47;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[75]:=Tv[75]+Tv[i];
   Tv[76]:=Tv[76]+Tv[i+1];
   Tv[77]:=Tv[77]+Tv[i+2];
   Tv[78]:=Tv[78]+Tv[i+3];
   Inc(i,6);
  until i>71;

  For i:=114 to 117 do Tv[i]:=0;
  i:=82;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[114]:=Tv[114]+Tv[i];
   Tv[115]:=Tv[115]+Tv[i+1];
   Tv[116]:=Tv[116]+Tv[i+2];
   Tv[117]:=Tv[117]+Tv[i+3];
   Inc(i,7);
  until i>110;

  For i:=158 to 161 do Tv[i]:=0;
  i:=122;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[158]:=Tv[158]+Tv[i];
   Tv[159]:=Tv[159]+Tv[i+1];
   Tv[160]:=Tv[160]+Tv[i+2];
   Tv[161]:=Tv[161]+Tv[i+3];
   Inc(i,8);
  until i>154;

  For i:=192 to 195 do Tv[i]:=0;
  i:=164;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[192]:=Tv[192]+Tv[i];
   Tv[193]:=Tv[193]+Tv[i+1];
   Tv[194]:=Tv[194]+Tv[i+2];
   Tv[195]:=Tv[195]+Tv[i+3];
   Inc(i,6);
  until i>188;

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS6DTL2(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  For i:=41 to 44 do Tv[i]:=0;
  i:=5;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[41]:=Tv[41]+Tv[i];
   Tv[42]:=Tv[42]+Tv[i+1];
   Tv[43]:=Tv[43]+Tv[i+2];
   Tv[44]:=Tv[44]+Tv[i+3];
   Inc(i,8);
  until i>37;

  For i:=75 to 78 do Tv[i]:=0;
  i:=47;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[75]:=Tv[75]+Tv[i];
   Tv[76]:=Tv[76]+Tv[i+1];
   Tv[77]:=Tv[77]+Tv[i+2];
   Tv[78]:=Tv[78]+Tv[i+3];
   Inc(i,6);
  until i>71;

  For i:=109 to 112 do Tv[i]:=0;
  i:=81;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[109]:=Tv[109]+Tv[i];
   Tv[110]:=Tv[110]+Tv[i+1];
   Tv[111]:=Tv[111]+Tv[i+2];
   Tv[112]:=Tv[112]+Tv[i+3];
   Inc(i,6);
  until i>105;

  For i:=143 to 146 do Tv[i]:=0;
  i:=115;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[143]:=Tv[143]+Tv[i];
   Tv[144]:=Tv[144]+Tv[i+1];
   Tv[145]:=Tv[145]+Tv[i+2];
   Tv[146]:=Tv[146]+Tv[i+3];
   Inc(i,6);
  until i>139;

  For i:=187 to 190 do Tv[i]:=0;
  i:=151;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[187]:=Tv[187]+Tv[i];
   Tv[188]:=Tv[188]+Tv[i+1];
   Tv[189]:=Tv[189]+Tv[i+2];
   Tv[190]:=Tv[190]+Tv[i+3];
   Inc(i,8);
  until i>183;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS6DTL3(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

(*
  Tv[64]:=0;
  Tv[66]:=0;
  i:=8;
  Repeat
   Tv[i+3]:=MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2]); //no losses aloowed
   If Strings[i-1]>'2006-05-01' then Tv[i+5]:=0; //after may 1, 2006
   Tv[i+7]:=MaxR(0,Tv[i+3]-Tv[i+5]); //-Tv[i+6]);
   Tv[64]:=Tv[64]+Tv[i+5];
  // Tv[65]:=Tv[65]+Tv[i+6];
   Tv[66]:=Tv[66]+Tv[i+7];
   Inc(i,12);
  until i>56;

  Tv[127]:=0;Tv[129]:=0;
  i:=71;
  Repeat
   Tv[i+3]:=MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2]); //no losses aloowed
   If Strings[i-1]>'2006-05-01' then Tv[i+5]:=0; //after may 1, 2006
   Tv[i+7]:=MaxR(0,Tv[i+3]-Tv[i+5]); //-Tv[i+6]);
   Tv[127]:=Tv[127]+Tv[i+5];
  // Tv[128]:=Tv[128]+Tv[i+6];
   Tv[129]:=Tv[129]+Tv[i+7];
   Inc(i,12);
  until i>119;

  Tv[180]:=0;
  Tv[182]:=0;
  i:=132;
  Repeat
   Tv[i+3]:=MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2]); //no losses aloowed
   If Strings[i-1]>'2006-05-01' then Tv[i+5]:=0; //after may 1, 2006
   Tv[i+7]:=MaxR(0,Tv[i+3]-Tv[i+5]); //-Tv[i+6]);
   Tv[180]:=Tv[180]+Tv[i+5];
  // Tv[181]:=Tv[181]+Tv[i+6];
   Tv[182]:=Tv[182]+Tv[i+7];
   Inc(i,12);
  until i>172;

  Tv[5]:=Tv[64]+Tv[127]+Tv[180];
 // Tv[6]:=Tv[65]+Tv[128]+Tv[181];
  Tv[7]:=Tv[66]+Tv[129]+Tv[182];

  //?? Tv[185
 *)
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure PS10(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 EXIT;    //20180211
(*
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillPHeader(RetNo,FNo,1,2,3);
  Strings[69]:=FetchElm(RetNo,'T5013FIN',1);
  Strings[70]:=FetchElm(RetNo,'T5013FIN',39);

 // Tv[5]:=0;
  Tv[8]:=Tv[6]-Tv[7]; //MaxR(0,Tv[6]-Tv[7]);
  If Tv[7]>Tv[6] then Strings[67]:='N';
  If Tv[8]<=0 then Strings[67]:='N';
  If UpperCase(Strings[67])='Y' then
  begin
   If Tv[6]>Tv[7] then Tv[17]:=Tv[7];
  end;


  If Tv[13] <0 then Tv[13] :=0;
  Tv[15] := Tv[14] * 0.75;
  Tv[16] := Tv[13]+Tv[15];
  Tv[20] := Tv[17]+Tv[18]+Tv[19];
  Tv[21] := Tv[20] * 0.75;
  Tv[22] := Tv[16] - Tv[21];
  If Tv[22] >0 then
   begin
    Tv[23]:=Tv[22];
    If strings[58] = '' then
      Strings[5] := '7'
    else
      Strings[5]:=Strings[58];
    Tv[24]:= Tv[23] * Vl(Strings[5])/100 * (GetT5013Days(RetNo)/365);
    Tv[27] := MaxR(0,Tv[22] - Tv[24]);
    For i:=28 to 50 do begin Strings[i]:='';Tv[i]:=0;end;
    Tv[71]:=0;Tv[72]:=0;
   end
  else
   begin
    Tv[23]:=0;
    Tv[24]:=0;
    Strings[5]:='';
   // Tv[25] :=0;
   // Tv[26]:=0;
    Tv[27] :=0; {Abs(Tv[12]);}
   end;


  //page 2
  //If Strings[35] ='' then Strings[45] :='Y';

  If Tv[22]<0 then
   Tv[28] := ABS(Tv[22])
   else
   begin
     For i:=29 to 50 do begin strings[i]:='';Tv[i]:=0;end;
   end;
  Strings[49]:='2/3';
  Tv[49]:=2/3;
  Tv[33] := MaxR(0,Tv[31]-Tv[32]);
  Tv[34] :=Tv[33];
  Tv[35] := Tv[29]+Tv[30]+Tv[34];

  Tv[38] :=Tv[36]+Tv[37];
  Tv[39] := Tv[38];
  Tv[40]:=MaxR(0,Tv[35]-Tv[39]);
  Tv[41]:=Tv[40];
  Tv[71]:=MinR(Tv[28],Tv[41]);

  Tv[42]:=Tv[28];
  Tv[43]:=Tv[41];
  Tv[44] := Tv[34];
  Tv[45] := Tv[44] * 0.50;
  Tv[46] := Tv[43]+Tv[45];
  Tv[47] := Tv[46];
  Tv[48] := MaxR(0,Tv[42] - Tv[47]);
  Tv[50]:= Tv[48] * 2/3;  //Vl(Strings[49])/100;   //20120318
  Tv[72]:=Tv[71]+Tv[50];

  //section c
  Tv[55] := Tv[53]+tv[54];
  Tv[56] := Tv[55];
  Tv[57] := MaxR(0,Tv[52]-Tv[56]);
  Tv[59] := Tv[57] * 0.50;
  Tv[62] := Tv[60]+Tv[61];
  Tv[63] := Tv[62];
  Tv[64] := MaxR(0,Tv[51]+Tv[59]-Tv[63]);
  Tv[65] := MinR(Tv[71],Tv[64]);
 end;
 SaveTv(RetNo,FName,FNo);
*)
end;


Procedure PS12(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillPHeader(RetNo,FNo,1,2,3);  //20110309
  Strings[76]:=FetchElm(RetNo,'T5013FIN',1);
  Strings[77]:=FetchElm(RetNo,'T5013FIN',39);

  Tv[9]:=AddColumns(5,8,1);
  Tv[10]:=Tv[9];
  Tv[13]:=Tv[11]+Tv[12];
  Tv[14]:=Tv[13];
  Tv[15]:=MaxR(0,Tv[10]-Tv[14]);

  Tv[20]:=AddColumns(17,19,1);
  Tv[21]:=Tv[20];
  Tv[24]:=Tv[22]+Tv[23];
  Tv[25]:=Tv[24];
  Tv[26]:=MaxR(0,Tv[21]-Tv[25]);

  Tv[31]:=AddColumns(28,30,1);
  Tv[32]:=Tv[31];
  Tv[36]:=Tv[33]+Tv[34]+Tv[35];
  Tv[37]:=Tv[36];
  Tv[38]:=MaxR(0,Tv[32]-Tv[37]);

  i:=41;
  Tv[72]:=0;
  Repeat
   Tv[i+5]:=Tv[i]+Tv[i+1]+Tv[i+2]-Tv[i+3]-Tv[i+4];
   Tv[72]:=Tv[72]+Tv[i+5];
   Inc(i,8);
  until i>65;
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure PS50(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;x,y:Real;SlipCnt:Integer;TotUnitsHeld:Real;
   FInst:String;
begin
 FInst:=ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillPHeader(RetNo,FNo,1,2,3);
  Strings[10]:=AllTrim(MidStr(FInst,2,5));
  If Strings[4]+Strings[5]='' then Strings[4]:='X';
  If Strings[14]='' then Strings[14]:='1';
  If Strings[15]='' then Strings[15]:='0';
  If Vl(Strings[16])>100 then Strings[16]:='100';
  If Strings[24]='' then Strings[24]:='CAN';

  //If Strings[36]='' then Strings[41]:='';  //no partner no disp date

  //If vl(Strings[61])<0 then Strings[61]:='';  //20120324

 // For i:=11 to 15 do begin Strings[i+25]:=Strings[i];end;
 // For i:=20 to 24 do begin Strings[i+25]:=Strings[i];end;
  //top counters
  Strings[6]:=IntToStr(CountT5013Partners(RetNo));
  Strings[7]:=IntToStr(CountT5013PartnersWithDisposition(RetNo));
  { 20131230
  If FetchElm(RetNo,'T5013FIN',2)>'' then
   Strings[8]:=''
  else
  }
  If UpperCase(Strings[37])<>'Y' then
   Tv[17]:=Vl(FetchElm(RetNo,'T5013WS',1)) * Vl(Strings[16])/100;  //20140326
  Strings[8]:=IntToStr(CountT5013PartnersNominees(RetNo));
  Tv[9]:= GetT5013AllPartnersNetIncomeShare(RetNo);
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS52(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillPHeader(RetNo,FNo,1,2,3);  //20110309
  FillPHeader(RetNo,FNo,1,120,121);  //pg2
  For i:=33 to 35 do Tv[i]:=0;
  i:=12;
  Repeat
   Tv[33]:=Tv[33]+Tv[i];
   Tv[34]:=Tv[34]+Tv[i+1];
   Tv[35]:=Tv[35]+Tv[i+2];
   Inc(i,6);
  until i>30;

  For i:=56 to 57 do Tv[i]:=0;
  i:=39;
  Repeat
   Tv[56]:=Tv[56]+Tv[i];
   Tv[57]:=Tv[57]+Tv[i+1];
   Inc(i,5);
  until i>54;

  For i:=78 to 79 do Tv[i]:=0;
  i:=61;
  Repeat
   Tv[78]:=Tv[78]+Tv[i];
   Tv[79]:=Tv[79]+Tv[i+1];
   Inc(i,5);
  until i>76;

  For i:=104 to 105 do Tv[i]:=0;
  Tv[104]:=AddColumns(82,100,6);
  Tv[105]:=AddColumns(83,101,6);
  Tv[106]:=AddColumns(84,102,6);
  Tv[107]:=AddColumns(85,103,6);

  Tv[108]:=100;
  Tv[109]:=100;
  Tv[110]:=Tv[33]+Tv[34];
  Tv[111]:=Tv[56]+Tv[57];
  Tv[113]:=Tv[110]*0.25/100;
  Tv[112]:=Tv[111]*0.25/100;
  Tv[114]:=15000;
  Tv[115]:=15000;
  Tv[116]:=MinR(Tv[114],MinR(Tv[108],Tv[113]));
  Tv[117]:=MinR(Tv[115],MinR(Tv[109],Tv[112]));
  Tv[118]:=Tv[116]+Tv[117];
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure PS100(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
//replaced elm 187 with  3575 as opposed to 3620 //20170506
//Replace elm 186 3600 with 3560
begin
 //20170506  major changes
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

   FillPHeader(RetNo,FNo,1,2,3);

   i:=6;
   Tv[77]:=0;
   repeat
    Tv[77]:=Tv[77]+Tv[i];
    Inc(i,2);
   until i>76;

   i:=79;
   Tv[150]:=0;
   repeat
    Tv[150]:=Tv[150]+Tv[i];
    Inc(i,2);
   until i>149;

   //20170506
   Tv[218]:=TotMultiple(RetNo,'PS125',303)+TotMultiple(RetNo,'PS125',341);  //9999 + 9998
   i:=212;
   Tv[222]:=0;
   Repeat
    Tv[222]:=Tv[222]+Tv[i];
    Inc(i,1);
   Until i>221;

   i:=223;
   Tv[227]:=0;
   Repeat
    Tv[227]:=Tv[227]+Tv[i];
    Inc(i,1);
   Until i>226;

   i:=228;
   Tv[232]:=0;
   Repeat
    Tv[232]:=Tv[232]+Tv[i];
    Inc(i,1);
   Until i>231;

   Tv[184]:=Tv[217];
   Tv[186]:=Tv[227];
   Tv[187]:=Tv[227]+Tv[232];

  {
   i:=152;
   Tv[187]:=0;
   repeat
    Tv[187]:=Tv[187]+Tv[i];
    Inc(i,2);
   until i>186;

   i:=189;
   Tv[210]:=0;
   repeat
    Tv[210]:=Tv[210]+Tv[i];
    Inc(i,2);
   until i>209;
  }
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure PS125(RetNo: integer; FName: String;FNo: integer);
Var  i,j: integer;FInst:String;
begin
 FInst:=ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillPHeader(RetNo,FNo,1,2,3);
   FillPHeader(RetNo,FNo,1,332,333);
   Strings[304]:=paddzero(MidStr(FInst,2,3),2);
  // If CertificationMode then Strings[304]:='01'; //20140324 put it direcly on the form
   i:=8;
   Tv[67]:=0;
   repeat
    Tv[67]:=Tv[67]+Tv[i];
    Inc(i,2);
   until i>66;

  i:=69;
  Tv[127]:=0;
  repeat
   Tv[127]:=Tv[127]+Tv[i];
   Inc(i,2);
  until i>125;

  i:=129;
  Tv[185]:=0;
  repeat
   Tv[185]:=Tv[185]+Tv[i];
   Inc(i,2);
  until i>183;

  Tv[187]:=Tv[127]+Tv[185];
  Tv[188]:=Tv[67]-Tv[187];

  i:=190;
  Tv[205]:=0;
  repeat
   Tv[205]:=Tv[205]+Tv[i];
   Inc(i,2);
  until i>204;
  i:=207;         //20140324
  repeat
   Tv[205]:=Tv[205]+Tv[i];
   Inc(i,2);
  until i>231;


  i:=233; //20140324
  Tv[275]:=0;
  repeat
   Tv[275]:=Tv[275]+Tv[i];
   Inc(i,2);
  until i>273;

  Tv[276]:=Tv[205]-Tv[275];

  i:=334;
  Tv[341]:=0;
  repeat
   Tv[341]:=Tv[341]+Tv[i];
   Inc(i,1);
  until i>340;

  {
  i:=278;
  Tv[302]:=0;
  repeat
   Tv[302]:=Tv[302]+Tv[i];
   Inc(i,2);
  until i>300;
  }
  Tv[300]:=0;
  i:=278;
  Repeat
   Tv[300]:=Tv[300]+Tv[i];
   Inc(i,2);
  until i>298;
  Tv[303]:=Tv[188]+Tv[276]+Tv[300]+Tv[341];  //20170506
  //Tv[303]:=Tv[188]+Tv[276]-Tv[300]+Tv[341];

  For i:=305 to 331 do begin Tv[i]:=0;Strings[i]:='';end;
  For i:=342 to 349 do begin Tv[i]:=0;Strings[i]:='';end;

  If (CountPS125(RetNo)>1) and (FInst='#1') then
  begin
   Tv[305]:=TotMultiple(RetNo,'PS125',188)+TotMultiple(RetNo,'PS125',276);  //9970
   Tv[342]:=TotMultiple(RetNo,'PS125',334);
   Tv[343]:=TotMultiple(RetNo,'PS125',335);
   Tv[344]:=TotMultiple(RetNo,'PS125',336);
   Tv[345]:=TotMultiple(RetNo,'PS125',337);
   Tv[346]:=TotMultiple(RetNo,'PS125',338);
   Tv[347]:=TotMultiple(RetNo,'PS125',339);
   Tv[348]:=TotMultiple(RetNo,'PS125',340);
   Tv[349]:=TotMultiple(RetNo,'PS125',341);

   j:=306;
   Repeat
    Strings[j]:=Strings[j-29];
    Inc(j,2)
   until j>326;

   Tv[307]:=TotMultiple(RetNo,'PS125',278);
   Tv[309]:=TotMultiple(RetNo,'PS125',280);
   Tv[311]:=TotMultiple(RetNo,'PS125',282);
   Tv[313]:=TotMultiple(RetNo,'PS125',284);
   Tv[315]:=TotMultiple(RetNo,'PS125',286);
   Tv[317]:=TotMultiple(RetNo,'PS125',288);
   Tv[319]:=TotMultiple(RetNo,'PS125',290);
   Tv[321]:=TotMultiple(RetNo,'PS125',292);
   Tv[323]:=TotMultiple(RetNo,'PS125',294);
   Tv[325]:=TotMultiple(RetNo,'PS125',296);
   Tv[327]:=TotMultiple(RetNo,'PS125',298);
   Tv[329]:=TotMultiple(RetNo,'PS125',300);
  //tv[330]:=TotMultiple(RetNo,'PS125',338);
   Tv[331]:=TotMultiple(RetNo,'PS125',303);

   (*
   If FInst='#1' then
   begin
    i:=278;j:=307;Tv[330]:=0;
    Repeat
     Strings[j-1]:=Strings[i-1];
     If (Strings[j-1]='') and (FetchElm(RetNo,'PS125#2',i-1)>'') then Strings[j-1]:=FetchElm(RetNo,'PS125#2',i-1);
     If (Strings[j-1]='') and (FetchElm(RetNo,'PS125#3',i-1)>'') then Strings[j-1]:=FetchElm(RetNo,'PS125#3',i-1);
     Tv[j]:=TotMultiple(RetNo,'PS125',i);
     Tv[330]:=Tv[330]+Tv[j];
     Inc(i,2);
     Inc(j,2);
    until i>300;
    Tv[331]:=Tv[305]-Tv[330];
   end;
   *)
  end;
 end;
 SaveTv(RetNo,FName,FNo);
end;



Procedure T5013A(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin

 GenerateT5013Slips(RetNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  //done in GenerateT5013slip
  If Strings[1]='' then Strings[1]:='N';
  Tv[196]:=Tv[194]*Vl(Strings[195]);
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure CalcPCCA(Cls:string;UccStart:real;
                 Additions:real;Adjustments:real;Proceeds:real;
                 Var UCC:real;Var HalfRuleAmount:real; Var UCCReduced:real;
                 OverrideIndic:String;HalfYearIndic:String;TermLossIndic:String;
                 Rate:string;
                 Var Recapture:Real;Var TerminalLoss:Real;
                 Var CCA:real;Var UccEnd:real;
                 DaysinTaxYear:integer);

begin
     If Cls='' then
     begin
      UCC :=0;HalfRuleAmount :=0;UccReduced:=0;Recapture:=0;TerminalLoss:=0;
      CCA:=0;UCCEnd:=0;
      exit;
     end;
     If DaysInTaxYear>365 then DaysInTaxYear :=365;
     Ucc      := UccStart + Additions +Adjustments - Proceeds;
     If UpperCase(HalfYearIndic) = 'H' then
       begin
       If UpperCase(OverrideIndic) <> 'O' then
        HalfRuleAmount := Round(MaxR(0, 0.5 * (Additions - Proceeds)));
       end
     else
       HalfRuleAmount :=0;

     UCCReduced  := UCC - HalfRuleAmount;

     If UpperCase(OverrideIndic) = 'O' then exit;


     If UpperCase(TermLossIndic) = 'T' then
     begin
       CCA :=0;
       Recapture :=0;
       TerminalLoss := MaxR(0,UCCReduced);
       UccEnd   := 0;
     end
     else
     begin
      CCA := Round(((UCCReduced * Vl(Rate)) / 100)*(DaysInTaxYear/365));
      If (Cls='13') and (OverrideIndic <> 'O') and (CCA=0) then
       CCA:=Round(UCCReduced * 0.20* DaysInTaxYear/365);
      TerminalLoss :=0;
      Recapture :=0;
      UccEnd   := MaxR(0,UCC - CCA);
     end;

     If UCCReduced <0 then
     begin
      CCA := 0;
      TerminalLoss:=0;
      Recapture := ABS(UCCReduced);
      UCCEnd := 0;
      If Cls='10.1' then
      begin CCA:=ABS(UCCReduced);Recapture:=0;end;
     end;

     If (cls='10.1') and (proceeds>0) then
     begin
      CCA:= Round((UccStart+Adjustments)/2 * Vl(Rate)/100);
      UCC:=0;
      UccReduced:=0;
      TerminalLoss:=0;
      Recapture:=0;
      UccEnd:=0;
     end;
end;

(*
Procedure POTHINFO(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
    Strings[1]:='152';Strings[2]:= 'Last year'+Chr(39)+'s capital gains reserve included in current year';
    Strings[5]:='156';Strings[6] := 'Foreign capital gains (losses)';
    Strings[9]:='157';Strings[10] := 'Foreign capital gains exempt from Canadian tax due to a a tax';
    Strings[13]:='158';Strings[14] := 'Capital gains from gifts of mutual funds/other shares donated to qualified donee';
  {
    Strings[17]:='70-8';Strings[18] := 'Capital gains from gifts of mutual fund units and other shares-eligible amount';
    Strings[21]:='70-9';Strings[22] :=   'Capital gains from gifts of mutual fund units and other shares-advantage';
    Strings[25]:='70-10';Strings[26] := 'Capital gains from gifts of bonds, debentures, promissory notes donated to qualified donee';
    Strings[29]:='70-11';Strings[30] := 'Capital gains from gifts of bonds, debentures, promissory notes-eligible amount';
    Strings[33]:='70-12';Strings[34] := 'Capital gains from gifts of bonds, debentures, promissory notes-advantage';
    Strings[37]:='70-13';Strings[38] := 'Capital gains from gifts of ecologically sensitive land donated to qualified donee';
    Strings[41]:='70-14';Strings[42] := 'Capital gains from gifts of ecologically sensitive land - Eligible amount';
    Strings[45]:='70-15';Strings[46] :=  'Capital gains from gifts of ecologically sensitive land -  Advantage';
    Strings[49]:='70-16';Strings[50] := 'Capital gains (losses) from a subsection 14(1.01)/14(1.02) election';
    Strings[53]:='70-17';Strings[54] := 'Farming and fishing income eligible for the capital gains deduction(QFP or fishing)';
   }
    Strings[57]:='160';Strings[58] := 'Capital gains reserve-QFP/fishing transferred to your child';
    Strings[61]:='161';Strings[62] := 'Capital gains reserve-QSB transferred to your child';
    Strings[65]:='162';Strings[66] := 'Capital gains reserve-other than QFP/Fishing/QSB transferred to your child';
    Strings[69]:='163';Strings[70] := 'Capital gains reserve from other property';
    Strings[73]:='164';Strings[74] := 'Capital gains reserve from capital property disposed of before Nov 13,1981';
    Strings[77]:='165';Strings[78] := 'Capital gains reserve from non-qualifying securities donated to qualified donee';
    Strings[81]:='166';Strings[82] := 'Capital gains reserve from gifts of non-qualifying securities-eligible amount';
    Strings[85]:='167';Strings[86] := 'Capital gains reserve from gifts of non-qualifying securities-advantage';
    Strings[89]:='168';Strings[90] := 'Income tax deducted';
    Strings[93]:='171';Strings[94] := 'Foreign tax paid on non-business income';
    Strings[97]:='172';Strings[98] := 'Foreign tax paid on business income';
    // out Strings[101]:='85-1';Strings[102] := 'Capital cost allowance class for rental or leasing property';

   // Strings[105]:='103-1';Strings[106] := 'Value of the gift';
   // Strings[109]:='104-1';Strings[110] := 'Value of the cultural/ecological gift';
    Strings[165]:='186';Strings[166] := 'Investment tax credit';
    Strings[169]:='187';Strings[170] := 'Investment tax credit transferred under subsection 127(8.3)';
    Strings[173]:='188';Strings[174] :='Excess ITC recapture';
    //descriptive
   {
  //  Strings[177]:='103-2';Strings[178] := 'Name of the gift'#39's recipient';
  //  Strings[180]:='103-3';Strings[181] := 'Date the recipient received the gift';
  //  Strings[183]:='103-4';Strings[184] := 'Description of the gifted property';
  //  Strings[186]:='103-5';Strings[187] := 'Donor'#39's name that the recipient recorded on the receipt';

 //   Strings[189]:='104-2';Strings[190] := 'Name of the gift'#39's recipient';
    Strings[192]:='104-3';Strings[193] := 'Date the recipient received the gift';
    Strings[195]:='104-4';Strings[196] := 'Description of the gifted property';
    Strings[198]:='104-5';Strings[199] := 'Donor'#39's name that the recipient recorded on the receipt';

    Strings[201]:='105-1';Strings[202] := 'Name of the registered party or provincial devision of it';
    Strings[204]:='105-2';Strings[205] := 'Name of the registered constituency association';
    Strings[207]:='105-3';Strings[208] := 'Name of the candidate';
    Strings[210]:='105-4';Strings[211] := 'Date the recipient received the contribution';
    Strings[213]:='105-5';Strings[214] := 'Donor'#39's name that the recipient recorded on the receipt';

    Strings[216]:='106-1';Strings[217] := 'Name of the provincial or territorial registered party';
    Strings[219]:='106-2';Strings[220] := 'Name of the registered constituency association';
    Strings[222]:='106-3';Strings[223] := 'Name of the candidate';
    Strings[225]:='106-4';Strings[226] := 'Date the recipient received the contribution';
    Strings[228]:='106-5';Strings[229] := 'Donor'#39's name that the recipient recorded on the receipt';
    }
    Strings[231]:='138';Strings[232] := 'Name of the Small Business Corporation';
    Strings[234]:='139';Strings[235] := 'Number and class of shares, or type of debt disposed of';
    Strings[237]:='140';Strings[238] := 'Insolvency, bankruptcy or wind-up date';
    Strings[240]:='141';Strings[241] := 'Date the partnership bought the shares or aquired the debt';
    Strings[243]:='142';Strings[244] := 'Proceeds of disposition';
    Strings[246]:='143';Strings[247] := 'Adjusted cost base of the shares or debt';
    Strings[249]:='144';Strings[250] := 'Outlays and expenses on the disposition';

    //has data
    Ret[RetNo].FrmHasData[FNo]:=False;
    i:=4;
    Repeat
     If Tv[i]>0 then begin  Ret[RetNo].FrmHasData[FNo]:=True;Break;End;
     Inc(i,4);
    until i>176;

    i:=179;
    Repeat
     If Strings[i]>'' then begin  Ret[RetNo].FrmHasData[FNo]:=True;Break;End;
     Inc(i,3);
    until i>251;
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

Procedure ClearAllT5013Slips(RetNo:Integer);
Var i,j:Integer;
begin
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'T5013')
   then
   begin
    If Frec.FormNo>0 then
    begin
      If UpperCase(FetchElmFNo(RetNo,Frec.FormNo,1)) <> 'Y' then
      begin
        For j:=2 to 7 do  StoreElm(RetNo,Frec.FormNo,j,'');
        For j:=9 to 30 do  StoreElm(RetNo,Frec.FormNo,j,'');
        For j:=33 to 174 do  StoreElm(RetNo,Frec.FormNo,j,'');
        For j:=176 to 193 do  StoreElm(RetNo,Frec.FormNo,j,'');
       // For j:=194 to 202 do  StoreElm(RetNo,Frec.FormNo,j,''); //keep it
      end;
    end;
   end;
 end;
end;

(*
Function IsLimitedPartnership(RetNo:Integer):Boolean;
begin
 If FetchElm(RetNo,'T5013FIN',62)>'' then result:=True else result:=False;
end;
*)
Function IsT5013Shelter(RetNo:Integer):Boolean;
begin
 If FetchElm(RetNo,'T5013FIN',62)>'' then result:=True else result:=False;
end;

(*
Function CountT5013Slips(RetNo:Integer):Integer;
Var i,j:Integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName='PS50' then
   begin
    Result:=Result+MyStrToInt(FetchElmFNo(RetNo,Frec.FormNo,362));
    {
    j:=4;
    Repeat
     If (FetchElmFNo(RetNo,Frec.FormNo,j) >'')
     and (FetchElmFNo(RetNo,Frec.FormNo,j+5) >'')  then Inc(Result);
     Inc(j,17);
    until j>327;
    }
   end;
 end;
end;
*)


Function ClaimedRenouncedResources(RetNo:Integer):Boolean;
Var i,FNo:Integer;x:Real;
begin
 FNo:=GetFormNo('T5013SUM');
 x:=0;
 for i:=149 to 159 do x:=x+Vl(FetchElmFNo(RetNo,FNo,i));
 If X>0 then result:=True else Result:=False;
end;

Procedure PT1135(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
  (*
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin
     Strings[12]:='X';
     Strings[13] :=FetchElm(RetNo,'T5013SUM',11);
     Strings[14]:=FetchElm(RetNo,'T5013SUM',5);

     Strings[15] := FetchElm(RetNo,'T5013SUM',13); //address
     Strings[17] := FetchElm(RetNo,'T5013SUM',14);
     Strings[63] := FetchElm(RetNo,'T5013SUM',15);
     If FetchElm(RetNo,'T5013SUM',18)>'' then
           Strings[63] := FetchElm(RetNo,'T5013SUM',18);
     Strings[16] := FetchElm(RetNo,'T5013SUM',16);
     If FetchElm(RetNo,'T5013SUM',19)>'' then
     Strings[16] :=FetchElm(RetNo,'T5013SUM',19)+ ' '+FetchElm(RetNo,'T5013SUM',54)
                  + ' '+FetchElm(RetNo,'T5013SUM',17);

    If Strings[73] = '' then Strings[73] := FormatDateTime('yyyy/mm/dd',Date);

    Strings[74] := OptRec.Prp_Name;
    Strings[75] := OptRec.Prp_Street;
    Strings[78] := OptRec.Prp_City;
    Strings[79] := OptRec.Prp_Prov;
    Strings[76] := OptRec.Prp_Postal;
    Strings[77] := OptRec.Prp_Area+' '+OptRec.Prp_Tel;
    Tv[69] := Trunc(Tv[69]);
   end;
SaveTv(RetNo,FName,FNo);
*)
end;

Procedure PS141(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillPHeader(RetNo,FNo,1,2,3);
   FillPHeader(RetNo,FNo,1,10,11);
   If Strings[12]+Strings[13]='' then Strings[13]:='X';
   If Strings[26]+Strings[27]='' then Strings[27]:='X';
   If Strings[27]>'' then begin Strings[28]:='';Strings[29]:='';end;

   i:=18;
   If Strings[12]>'' then
   Repeat
    If Strings[i]+Strings[i+1]= ''  Then Strings[i+1] :='X';
    Inc(i,2);
   until i>24
   else
   begin
    i:=18;
    repeat
    Strings[i]:='';
    Strings[i+1]:='';
    Inc(i,2);
    until i>24;
   end;
   If (Strings[7]>'') or (Strings[32]>'') then
   begin
     Strings[38]:='';Strings[39]:='';
   end;
   If Strings[36]>'' then begin Strings[38]:='';Strings[39]:='';end;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Function GetT5013SlipType(RetNo:Integer):String;
Begin
  Result:='T5013';
  {If (IsT5013Shelter(RetNo)) or (ClaimedRenouncedResources(RetNo)) then result:='T5013A';}
end;

Function CountPs125(RetNo:Integer):Integer;
Var i:Integer;
Begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'PS125') then
   begin
    If Ret[RetNo].FrmHasData[Frec.FormNo] then Inc(Result);
   end;
 end; //i
end;

Procedure T661(RetNo:integer;FName:string;FNo:integer);
Var
    i,k:integer;
    Cnt1,Cnt2:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  //trings[10]:=RsiApprovalCode;
   
   Strings[1] := FetchElm(RetNo,'T5013SUM',11);
   Strings[2] := FetchElm(RetNo,'T5013SUM',5);
   Strings[3]:=FetchElm(RetNo,'T5013SUM',13)
              +' '+FetchElm(RetNo,'T5013SUM',14);
   Strings[21]:=FetchElm(RetNo,'T5013SUM',15)
              +' '+FetchElm(RetNo,'T5013SUM',16)
              +' '+FetchElm(RetNo,'T5013SUM',17);

   If Strings[11]+Strings[12] = '' then Strings[12] :='X';
   If Strings[25]+Strings[26] = '' then Strings[26] :='X';
   (*
   If Strings[6] = '' then
    Strings[6] := FetchElm(RetNo,'PAGE_8',43)
                  +' '+FetchElm(RetNo,'PAGE_8',42); {contact}

   If Strings[7] = '' then
     Strings[7] := FetchElm(RetNo,'PAGE_8',55)
                 +' '+FetchElm(RetNo,'PAGE_8',46); {tel}
   If Strings[15] ='' then
    Strings[15] := FetchElm(RetNo,'PAGE_8',43)
                  +' '+FetchElm(RetNo,'PAGE_8',42); {signing}
   *)
   If Strings[16]='' then Strings[16]:= FormatDateTime('yyyy/mm/dd',Date);

   Strings[4] := FetchElm(RetNo,'T5013SUM',3);
   Strings[5] := FetchElm(RetNo,'T5013SUM',5);
  end; {End with}

  // T661 pg 2 -----------------------------------------------------------------

  //no calc

  // T661 pg 3 -----------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin

   // Strings[10] := RsiApprovalCode;
   If UpperCase(FetchElm(RetNo,'T661',26)) = 'X' then Tv[251] :=0; //traditional
   If UpperCase(FetchElm(RetNo,'T661',25)) = 'X' then Tv[252] :=0;    //proxy

   Tv[213]:=Vl(FetchElm(RetNo,'T661_9',147))+TotMultiple(RetNo,'T661F',147);
   Tv[248]:=Tv[212]+Tv[213];
   Tv[215]:=Vl(FetchElm(RetNo,'T661_9',148))+TotMultiple(RetNo,'T661F',148);
   Tv[249]:=Tv[214]+Tv[215];

   Tv[253]:=Tv[206]+Tv[244]+Tv[245]+tv[247]+Tv[258]+Tv[248]+Tv[249]+Tv[250]+Tv[251]+Tv[252];

   Tv[254]:=Vl(FetchElm(RetNo,'T661',303)); //+TotMultiple(RetNo,'S30',3); //,T661',552);

   Tv[255]:=Tv[253]+Tv[254];
   Tv[257]:=Tv[255]+Tv[256];

    // Step 2
    Tv[231]:= Tv[257]; // Vl(FetchElm(RetNo,'T661',115));
    Tv[243]:= Vl(FetchElm(RetNo,'T661',503));
    Tv[211]:= Tv[231]-Tv[232]-Tv[234]-Tv[233]+Tv[236]+Tv[242]+Tv[243];
    Tv[238]:=MaxR(0,Tv[211]); //Tv[38]:= Tv[31]-Tv[32]-Tv[34]-Tv[33]+Tv[36]+Tv[42]+Tv[43];
    Tv[239]:=MaxR(0,Tv[211]); //MaxR(0,Tv[38]);
    If UpperCase(Strings[209]) = 'Y' then Tv[239]:=Tv[41];
    If Tv[239]>Tv[211] then Tv[239]:=Tv[211];
    If Tv[239]<0 then Tv[239]:=0;
    Tv[240] :=MaxR(0,Tv[211]-Tv[239]);

    //step 3

    Tv[201] := tv[255]; //Vl(FetchElm(RetNo,'T661',113));
    Tv[202] := Tv[256]; //Vl(FetchElm(RetNo,'T661',114));
    {deductions}
    Tv[204]:=Vl(FetchElm(RetNo,'T661',678));
    Tv[220]:=Vl(FetchElm(RetNo,'T661',510));
    Tv[221]:=Vl(FetchElm(RetNo,'T661',511));
    Tv[222]:=Vl(FetchElm(RetNo,'T661',519));
    Tv[223]:=Vl(FetchElm(RetNo,'T661',520));
    Tv[226]:=MaxR(0,Tv[201]+Tv[203]+Tv[204]+Tv[207]-Tv[218]-Tv[220]-Tv[222]);
    Tv[227]:=MaxR(0,Tv[202]+Tv[205]+Tv[208]-Tv[219]-Tv[221]-Tv[223]);

    Tv[228] := Tv[226]+Tv[227];
    Tv[230] := Tv[228]+Tv[229];
    {for itc done}

  end; {with}



  // T661 pg 4 -----------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[304]:= MaxR(0,Vl(FetchElm(RetNo,'T661',257))
                -Vl(FetchElm(RetNo,'T661',248))
                -Vl(FetchElm(RetNo,'T661',249))
                -Vl(FetchElm(RetNo,'T661',254)));

  end; {with}



  // T661 pg 5 -----------------------------------------------------------------

  //no calc

  // T661 pg 6 -----------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[503]:=Tv[501]+Tv[502];
   Tv[510]:=Tv[504]+Tv[505]+Tv[506]+Tv[508];
   Tv[511]:=Tv[507]+Tv[509];

   Tv[514]:=Vl(FetchElm(RetNo,'T661',249));
   Tv[519]:=Tv[512]+Tv[514]+Tv[515]+Tv[517];
   Tv[520]:=Tv[513]+Tv[516]+Tv[518];
  end; {End with}


  // T661 pg 7 -----------------------------------------------------------------
 with Ret[RetNo].Frm[Fno] do
 begin
  If GetT5013YearEndYYYY(RetNo) = 2000 then Tv[677] := 37600
  else If GetT5013YearEndYYYY(RetNo) = 2001  then Tv[677] := 38300
  else If GetT5013YearEndYYYY(RetNo) = 2002  then Tv[677] := 39100
  else If GetT5013YearEndYYYY(RetNo) = 2003  then Tv[677] := 39900
  else If GetT5013YearEndYYYY(RetNo) = 2004  then Tv[677] := 40500
  else If GetT5013YearEndYYYY(RetNo) = 2005  then Tv[677] := 41100
  else If GetT5013YearEndYYYY(RetNo) >= 2006 then Tv[677] := 42100;

  i := 607;k:=67;Tv[683] :=0;
  Repeat
   If (Vl(Strings[i+1]) =0) and (Strings[i-1] >'') then Strings[i+1] := '75';
   If Vl(Strings[i+1]) > 75 then Strings[i+1] := '75';
   Tv[i+2] := Tv[i] * Vl(Strings[i+1]) /100;
   If Tv[i] >0 then
    Tv[i+3] := 2.5 * Tv[77] * (vl(Strings[k])/365)
   else
    Tv[i+3] :=0;
   Tv[i+4]:=MinR(Tv[i+2], Tv[i+3]);
   Tv[83] := Tv[83] +Tv[i+4];
   Inc(i,6);
   Inc(K,1);
  until i>661;

  Tv[601]:= vl(FetchElm(RetNo,'T661',206));
  Tv[666]:=MaxR(0,Tv[601]-Tv[602]);
  Tv[603]:=Tv[683];
  Tv[605]:=Tv[666]+Tv[603];

  Tv[678]:=Tv[605] * 65/100;
  If UpperCase(Strings[680]) = 'Y' then Tv[678] := Tv[681];
  If FetchElm(RetNo,'T661',25) = '' then  {not proxy}
   begin Tv[601]:=0;Tv[602]:=0;Tv[666]:=0;Tv[603]:=0;Tv[605]:=0;Tv[678]:=0;end;
 end; {End with}



  // T661 pg 8 -----------------------------------------------------------------



  // T661 pg 9 -----------------------------------------------------------------
  //exceeds 1000 - Tv's not updated
  //j???
  with Ret[RetNo].Frm[Fno] do
  begin
   Cnt1:=0;
   Cnt2:=0;
   Tv[147]:=0;
   i:=8;
   Repeat
    Tv[147]:=Tv[147]+Tv[i];
    If Tv[i]>0 then Inc(Cnt1);
    Inc(i,6);
   until i>74;

   Tv[148]:=0;
   i:=80;
   Repeat
    Tv[148]:=Tv[148]+Tv[i];
    If Tv[i]>0 then Inc(Cnt2);
    Inc(i,6);
   until i>146;

   Strings[1]:=IntToStr(Cnt1);
   If Strings[1]='0' then Strings[1]:='';
   Strings[2]:=IntToStr(Cnt2);
   If Strings[2]='0' then Strings[2]:='';

  end; {End with}

  SaveTv(RetNo,FName,FNo);
end;


Function GetT5013YearEndYYYY(RetNo:Integer):Integer;
begin
 result:=MyStrToInt(LeftStr(FetchElm(RetNo,'T5013FIN',1),4));
end;

Function GetT5013AccountNo(RetNo:Integer):String;
begin
 result:=FetchElm(RetNo,'T5013FIN',1);
end;

Function GetT5013FiscalPeriodEnd(RetNo:Integer):String;
begin
 result:=FetchElm(RetNo,'T5013FIN',39);
end;


Procedure PS5(RetNo:integer;FName:string;FNo:integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillPHeader(RetNo,FNo,1,2,3);
    If Strings[68]+Strings[4]='' then Strings[68]:='';
    i:=8;
    Tv[70]:=0;
    Tv[71]:=0;
    Repeat
     If Strings[i-2]+Strings[i-1]='' then Strings[i-1]:='X';
     If UpperCase(Strings[i-1])='X' then begin Tv[i]:=0;Tv[i+1]:=0;end;
     Tv[70]:=Tv[70]+Tv[i];
     Tv[71]:=Tv[71]+Tv[i+1];
     Inc(i,4);
    until i>68;

    i:=74;
    Repeat
     If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
     Inc(i,4);
    until i>94;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure PS9(RetNo:integer;FName:string;FNo:integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillPHeader(RetNo,FNo,1,2,3);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure T5013WS(RetNo:integer;FName:string;FNo:integer);
Var i,j:integer; AFNo:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    TV[1]:=Vl(FetchElm(RetNo,'PS1',41)); //20140326
    (*
    //dividends //20140615
    If UpperCase(Strings[251]) <> 'Y' then
    Begin
     Tv[70]:=Tv[68]*1.25;  //20140615
     Tv[72]:=Tv[70] * 13.3333/100;
     If LeftStr(FetchElm(RetNo,'T5013FIN',39),4)>'2013' then  Tv[72]:=Tv[70] * 11.0169/100;

     Tv[76]:=Tv[74] * 1.38;
     Tv[78]:=Tv[76] * 15.0198/100;
    end;
    *)
    //box 182
    Tv[190]:=TotMultiple(RetNo,'PS2',29)+TotMultiple(RetNo,'PS2',54);
   //box 183
    Tv[192]:=TotMultiple(RetNo,'PS2',73)+TotMultiple(RetNo,'PS2',92);
    //box 184
    Tv[194]:=TotMultiple(RetNo,'PS2',111);
    //box 185
    Tv[196]:=TotMultiple(RetNo,'PS2',130);
     //box 208
    Tv[200]:=TotMultiple(RetNo,'PS2',152);
     //box 207
    Tv[198]:=TotMultiple(RetNo,'PS2',171);

    //from ps6
    //Box 030 and 151  cap gains losses //same?
    Tv[120]:=TotMultiple(RetNo,'PS6',422);
    Tv[122]:=TotMultiple(RetNo,'PS6',422);
    //Box 153  QSB
    Tv[126]:=TotMultiple(RetNo,'PS6',423);
    //Box 154  QSB
    Tv[128]:=TotMultiple(RetNo,'PS6',424);
   //Box 155  foreclosures
    Tv[130]:=TotMultiple(RetNo,'PS6',425);

    //from ps10
   //Box 158
    Tv[136]:=Vl(FetchElm(RetNo,'PS10',65));

   //from ps12
   //Box 173
   Tv[172]:=Vl(FetchElm(RetNo,'PS12',15));

   //Box 206
   Tv[174]:=Vl(FetchElm(RetNo,'PS12',78));

   //Box 179
   Tv[184]:=Vl(FetchElm(RetNo,'PS12',16));

   //Box 174
   Tv[176]:=Vl(FetchElm(RetNo,'PS12',26));

   //Box 180
   Tv[186]:=Vl(FetchElm(RetNo,'PS12',27));

   //Box 175
   Tv[178]:=Vl(FetchElm(RetNo,'PS12',38));

   //Box 181
   Tv[188]:=Vl(FetchElm(RetNo,'PS12',39));

   //Box 176
   Tv[180]:=Vl(FetchElm(RetNo,'PS12',72));

   //Box 177
   Tv[182]:=Vl(FetchElm(RetNo,'PS12',73));

   //Box 040 cca
   Tv[166]:=TotMultiple(RetNo,'PS8',232);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Function GetTheBoxNoOfT5013Ws(AmtElm:String):String;
//Get The box Number corresponding to the amount elm of th T5013Ws
Var i:Integer;TempList:TStringList;
Begin
 Result:='';
 TempList:=TStringList.Create;
 Templist.LoadFromFile(AppDir+'\'+'T5013Boxes.d');
 i:=0;
 Repeat
  If AmtElm=MidStr(TempList[i],5,3) then
  begin
   Result:=LeftStr(TempList[i],3);
   TempList.Free;
   Exit;
  End;
  Inc(i,1);
 Until i>TempList.Count-1;
 TempList.Free;
end;


Function GetBoxTotalsFromAllT5013(RetNo:Integer;BoxNo:String):Real;
Var i,j:Integer; x: real;
Begin
 x:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'T5013') then
   begin
    If Frec.FormNo>0 then
    begin
      j:=32;
      Repeat
       If FetchElmFNo(RetNo,Frec.FormNo,j)=BoxNo then x:=x+Vl(FetchElmFNo(RetNo,Frec.FormNo,j+2));
       Inc(j,3);
      until j>65;
    end;
   end;
 end; //i
 Result:=x;
end;



end.


