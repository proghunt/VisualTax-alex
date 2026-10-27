unit T3_2026calcBus;

interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T3_2026Declare, T3_2026common, T3_2026common2, T3_2026TrimStr;


    Procedure T2043(RetNo:integer;FName:string;FNo:integer); //20230106
    Procedure T2043A(RetNo:integer;FName:string;FNo:integer); //20230106

    Procedure CalcCCA(Cls:string;UccStart:real;
                 Additions:real;Proceeds:real;
                 Var Adjustments:real;Var BaseForCCA:real;
                 Rate:string;Var CCA:real;Var UccEnd:real;
                 OvrCCA:string;OvrUCC:string;ClaimIt:Boolean;
                 Rule50Exempt:String;BusPercent:Real;Var MaxCCA:Real);

    Function GetLine5K(Yr:String):Real;
    Function GetLine6K(Yr:String):Real;
    Function GetLine7K(Yr:String):Real;
    Procedure T2038(RetNo:integer;FName:string;FNo:integer);
    Procedure T2038fromT1(RetNo:integer;FName:string;FNo:integer);
    Procedure T2038PreviousWithEXIT(RetNo:integer;FName:string;FNo:integer);
    Procedure T3FFT(RetNo:integer;FName:string;FNo:integer);
    Procedure T3PFT(RetNo:integer;FName:string;FNo:integer);
    Procedure CalcAutoExp(RetNo:integer;FName:string;FNo:integer;Stm:string);
    Procedure CalcBusProf_3(RetNo:integer;FName:string;FNo:integer;Stm:string);

    Procedure T2125(RetNo:integer;FName:string;FNo:integer);
    Procedure T2042(RetNo:integer;FName:string;FNo:integer);
    Procedure T2121(RetNo:integer;FName:string;FNo:integer);
    procedure T776(RetNo: integer; FName: String;FNo: integer);

implementation
Uses T3_2026Calc, vtShared, T3_2026, vtCommon, vtTrimStr;

Procedure T3PFT(RetNo:integer;FName:string;FNo:integer);
Var k:integer;ThisFrm:string[10];
Begin
    LoadTv(RetNo,FName,FNo);
    Ret[RetNo].Frm[Fno].Strings[1] :=FetchElm(RetNo,'FINVSTM',1);
    Ret[RetNo].Frm[Fno].Strings[12] :=FetchElm(RetNo,'FINVSTM',2);
    Ret[RetNo].Frm[Fno].Strings[23] :=FetchElm(RetNo,'FINVSTM',3);
    with Ret[RetNo].Frm[FNo] do
    begin
      K:=0;
      Repeat
      If k=0 then ThisFrm := 'T3FFT#1'
      else if k=11 then ThisFrm := 'T3FFT#2'  {?}
      else if k=22 then ThisFrm := 'T3FFT#3';

      Tv[2+k] := Vl(FetchElm(RetNo,ThisFrm,1));
      Tv[3+k] := Vl(FetchElm(RetNo,ThisFrm,6));
      Tv[6+k] := MaxR(0,(Tv[2+k] - Tv[3+k]));
      Tv[7+k] := Vl(FetchElm(RetNo,ThisFrm,2))+
               Vl(FetchElm(RetNo,ThisFrm,8)); //net Foreign income
      Tv[8+k] :=  Vl(FetchElm(RetNo,'T3FFT#1',5));
      If Uppercase(Ret[RetNo].Frm[FNo].Strings[35]) <> 'Y' then
       Tv[9+k] := PrvTaxBfrT3PFT(RetNo);
      If Tv[8+k] = 0 then
          Tv[10+k] := 0
      Else
          Tv[10+k] := (Tv[7+k] / Tv[8+k]) * Tv[9+k];
      If Tv[10+k] > Tv[9+k] then Tv[10+k] := Tv[9+k];
      Tv[11+k] := MinR(Tv[6+k],Tv[10+k]);
      {?T3PFT other countries}
      Inc(K,11);
      until k >23;
      Tv[34] := Tv[11]+Tv[22]+Tv[33];
    end;
    {save data}
    SaveTv(RetNo,FName,FNo);

End;

Procedure T3FFT(RetNo:integer;FName:string;FNo:integer);
var i,k: integer;FInst :String[4]; FBInc,FBTax:Real;
Begin

    Finst := ExtractFormInst(FName);
    LoadTv(RetNo,FName,FNo);
    If      FInst = '#1' then K:=0
    else If FInst = '#2' then K:=1
    else If FInst = '#3' then K:=2
    else exit; {ignore more than three}

    with ret[retNo], Ret[RetNo].Frm[FNo] do
    begin
        {country}
        If K=0 then Frm[FNo].Strings[19] := FetchElm(RetNo,'FINVSTM',1)
        else If K=1 then Frm[FNo].Strings[19] := FetchElm(RetNo,'FINVSTM',2)
        else If K=2 then Frm[FNo].Strings[19] := FetchElm(RetNo,'FINVSTM',3);

        Tv[1] := MaxR(0,Vl(FetchElm(RetNo,'FINVSTM',94+k))-Vl(FetchElm(RetNo,'S9',50)));
        Tv[2] := MaxR(0,Vl(FetchElm(RetNo,'FINVSTM',91+k))+Ret[RetNo].T3FCapGains-Vl(FetchElm(RetNo,'S9',25)));
        Tv[5] := MaxR(0, Vl(FetchElm(RetNo,'T3',256)) -  //Net Inc
                         Vl(FetchElm(RetNo,'T3',266)));  //- Net cap losses oth yrs

        xx:=Vl(FetchElm(RetNo,'FINVSTM',91+k));
        xx:=Ret[RetNo].T3FCapGains;
        xx:=Vl(FetchElm(RetNo,'S9',25));
        xx:=Tv[2];


        If Tv[2]>Tv[5] Then Tv[2]:=Tv[5];   //20130218

        xx:=Tv[2];

        Tv[3] := Vl(FetchElm(RetNo,'S11',104))   //fed tax
                +Vl(FetchElm(RetNo,'S11',141));  //Fed div tax credit

        {?t3FFT + overseas}
	If Tv[5] >0 then
          Tv[4] := (Tv[2] / Tv[5]) * Tv[3]
        else
          Tv[4] :=0;

	Tv[6] := MinR(Tv[1],Tv[4]);

        //20090113
        FBinc:=0; FBTax:=0;
        If k=0 then
         begin
          FBinc:=Ret[RetNo].T3FBusInc1+Ret[RetNo].T5013FBusInc1;
          FBTax:=Ret[RetNo].T3FBusTax1+Ret[RetNo].T5013FBusTax1;
         end
        else if k=1 then
        begin
         FBinc:=Ret[RetNo].T3FBusInc2+Ret[RetNo].T5013FBusInc2;
         FBTax:=Ret[RetNo].T3FBusTax2+Ret[RetNo].T5013FBusTax2;
        end
        else if k=2 then
        begin
         FBinc:=Ret[RetNo].T3FBusInc3+Ret[RetNo].T5013FBusInc3;
         FBTax:=Ret[RetNo].T3FBusTax3+Ret[RetNo].T5013FBusTax3;
        end;

        Tv[7]:=MaxR(0,FBTax-Vl(FetchElm(RetNo,'S9',46)));
        Tv[8]:=MaxR(0,FBInc-Vl(FetchElm(RetNo,'S9',21)));
        (*
        Tv[7]:=MaxR(0,Vl(FetchElm(RetNo,'AVLBLE',25))-Vl(FetchElm(RetNo,'S9',46)));
        Tv[8]:=MaxR(0,Vl(FetchElm(RetNo,'AVLBLE',12))-Vl(FetchElm(RetNo,'S9',21)));
        *)
        Tv[9] := Tv[3];
        TV[11] := Tv[5];
        If Tv[11]>0 then
           Tv[10] := (Tv[8] / Tv[11]) * Tv[9]
        else
           Tv[10] :=0;
        Tv[12] :=Vl(FetchElm(RetNo,'S11',103)); //Vl(FetchElm(RetNo,'S11',33)); //20210309
        //??  what if mj
        Tv[13] := Tv[10] + Tv[12];
      	Tv[14] := Tv[9] + Tv[12];
        Tv[15] := Tv[6];
	Tv[16] := MaxR(0,Tv[14] - Tv[15]);
        Tv[20]:=Tv[16];  //20131020
	Tv[17] := MinR(Tv[20],MinR(Tv[7],Tv[13]));
	Tv[18] := Tv[6] + Tv[17];
    end;
   SaveTv(RetNo,FName,FNo);

end;


//jz//20260223 - code taken from T1 as as well as the pas/dfm
Procedure T2038fromT1(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
  // Frm[FNo].Strings[1] := AppYear;
  // Tv[4] := Tv[3] * 0.30; //20140913
   Tv[8] := Tv[7] * 0.15; //0.20;  //20140913

   Tv[33] :=Tv[32] * 0.15; //0.20;          //20140913
   Tv[12] := Tv[11] * 0.10;

   //Tv[15] := Tv[14] * 0.05; ////0.15;  //jz//20250306 [15] doest belong here removed
   Tv[16] := Tv[8]+Tv[33]+Tv[1]+Tv[12];  //jz//20250306 [15] removed   +Tv[15]; //Tv[4]+Tv[8]+Tv[33]+Tv[12]+Tv[15];

   Tv[34]:=Vl(FetchElm(RetNo,'T1229',71));
   Tv[18]:=Tv[34]+Tv[35];     //???
   Tv[46] := Tv[18] * 0.15;
   Tv[10]:=Vl(FetchElm(RetNo,'T1229',24)); //20240409
   Tv[13]:=Tv[10]*0.30; //20230117

   i:=54;
   Repeat
    If Tv[i]>20000 then Tv[i]:=20000;
    Inc(i,3);
   until i>63;

   Tv[44] :=Tv[54]+Tv[57]+Tv[60]+Tv[63]; //vl(FetchElm(RetNo,'AJCTC',101));
   Tv[43] :=  Tv[44] * 0.10;
   //20241214

   //jz//20250306
   //Tv[2]
   Tv[14]:=Tv[2]*0.20;
   //Tv[15]
   Tv[19]:=Tv[15]*0.15;
   Tv[21]:=Tv[14]+Tv[19];
   Tv[22]:= Tv[21];

   Tv[42]:=Tv[46]+Tv[13]+Tv[43]+Tv[22];   //20241214


   //jz//20260228 this section does not seem to exist, [19] calced above
   {
   //child care spaces
   Tv[66] := Vl(Frm[FNo].Strings[65]) * 40000;
   Tv[49] := MinR(Tv[64],Tv[66]);
   Tv[48] := Tv[49] * 0.25;
   Tv[19] := Tv[46]+Tv[43]+Tv[48];
   Tv[72]:=MinR(Tv[70],Tv[71]);
   Tv[73]:=Tv[69]+Tv[72];
  }



   //Page 3 --------------------------------------------------------------------

   //recapture of ICT
   Tv[28] := Tv[20] * 0.15; //0.30; //20140913
   Tv[41] := Tv[39] * 0.20;
   Tv[74]:=Tv[28]+Tv[41];

   //20251124 Tv[51] := Tv[74]+Tv[73]; //Tv[28]+Tv[41]; //20140209

   //20240225
  //  modified in 2023========= ==============
   Tv[3]:=Tv[16];
   Tv[17]:=Tv[42];
   Tv[45]:=Tv[3]+Tv[17];
   Tv[50]:=Tv[45];
   Tv[67]:=Tv[137]+Tv[50];
   //Tv[66]:=?? T3?
   Tv[77]:=Tv[67]-Tv[66];


   Tv[78]:=Ret[RetNo].LNN[40600];
   Tv[79]:=Ret[RetNo].LNN[41000];
   Tv[80]:=MaxR(0,Tv[78]-Tv[79]);
   Tv[81]:=Ret[RetNo].LNN[41400];
   Tv[82]:=MaxR(0,Tv[80]-Tv[81]);
   Tv[83]:=Tv[82];
   Tv[84]:=MinR(Tv[77],Tv[83]);


   if (SubjectToMinTax(RetNo))
   and (Vl(FetchElm(RetNo,'T691',249))>0) //20250404
   then
   begin
    Tv[85]:=Tv[83];
    Tv[86]:=Ret[RetNo].LNN[40500];
    Tv[87]:=Tv[85]+Tv[86];

    //jz//20250404 - form descr wrong , should be from line 108 elm 131 not elm 129
    Tv[88]:=Vl(FetchElm(RetNo,'T691',131)); //Vl(FetchElm(RetNo,'T691',129));

    Tv[89]:=MaxR(0,Tv[87]-Tv[88]); //20240226 //MaxR(0,Tv[87]-Tv[86]);
    Tv[90]:=Tv[89];
    Tv[91]:=MinR(Tv[77],Tv[90]);
    Tv[92]:=Tv[91];
   end
   else
   begin
    for i:=85 to 91 do Tv[i]:=0;  //20240226
    Tv[92]:=Tv[84];
   end;

    Ret[RetNo].LNN[41200]:=Tv[92];


   //===============
   Tv[4]:=Tv[77];
   Tv[5]:=Tv[137];
   Tv[9]:=MaxR(0,Tv[4]-Tv[5]);
   Tv[93]:=Tv[9];
   Tv[94]:=MaxR(Tv[84],Tv[91]);
   Tv[95]:=Tv[137];
   Tv[96]:=MaxR(0,Tv[94]-Tv[95]);
   Tv[97]:=Tv[96];   //20240226
   Tv[98]:=Tv[93]-Tv[97];      //20240226
   //Carry back request
   Frm[FNo].Strings[105] := IntToStr(StrToInt(AppYear)-3);
   Frm[FNo].Strings[107] := IntToStr(StrToInt(AppYear)-2);
   Frm[FNo].Strings[109] := IntToStr(StrToInt(AppYear)-1);
   Tv[111]:=Tv[106]+Tv[108]+Tv[110];

   // Part E2
   Tv[6]:=Tv[16];
   Tv[99]:=Tv[66];
   Tv[100]:=Tv[6]-Tv[99];

   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
   Tv[101]:=Tv[100];
    //20240226
   Tv[120]:=Tv[92];
   Tv[126]:=Tv[137];
   Tv[127]:=Tv[120]-Tv[126];
   Tv[128]:=Tv[111];
   Tv[129]:=Tv[127]+Tv[128];
   Tv[130]:=Tv[42];
   Tv[131]:=MaxR(0,Tv[129]-Tv[130]);
   Tv[132]:=Tv[131]; //20240121
   Tv[133]:=MaxR(0,Tv[101]-Tv[132]);

   Tv[134]:=Tv[133];
   if Tv[134]>Tv[133] then Tv[134]:=Tv[133];
   Tv[135]:=Tv[134]*0.40;

   Tv[136]:=Tv[77];

   Tv[139]:=Tv[92];
   Tv[141]:=Tv[111];
   Tv[144]:=Tv[135];
   Tv[147]:=Tv[139]+Tv[141]+Tv[144];
   Tv[148]:=Tv[147];
   Tv[146]:=MaxR(0,Tv[136]-Tv[148]);

   Lnn[45400] := Tv[135]; //20240410
  End;
  SaveTv(RetNo,FName,FNo);
End;


Procedure T2038PreviousWithEXIT(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin



  //EXIT;  //wrong form and wrong calc It meant to be for T1 //20240118



  LoadTv(RetNo,FName,FNo);
  with ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   Tv[8] := Tv[7] * 0.15; //0.20;  //20140913
   Tv[33] :=Tv[32] * 0.15; //0.20;          //20140913
   Tv[12] := Tv[11] * 0.10;
   Tv[15] := Tv[14] * 0.05; ////0.15;
   Tv[16] := Tv[8]+Tv[33]+Tv[1]+Tv[12]+Tv[15]; //Tv[4]+Tv[8]+Tv[33]+Tv[12]+Tv[15];

   Tv[34]:=Vl(FetchElm(RetNo,'T1229',71));

   Tv[18]:=Tv[34]+Tv[35];     //???
   Tv[46] := Tv[18] * 0.15;
   i:=54;
   Repeat
    If Tv[i]>20000 then Tv[i]:=20000;
    Inc(i,3);
   until i>63;

   Tv[44] :=Tv[54]+Tv[57]+Tv[60]+Tv[63]; //vl(FetchElm(RetNo,'AJCTC',101));
   //Tv[43]:=Vl(FetchElm(RetNo,'AJCTC',102));
   Tv[43] :=  Tv[44] * 0.10;
   Tv[42]:=Tv[46]+Tv[43];   //20210310
   //child care spaces
   Tv[66] := Vl(Frm[FNo].Strings[65]) * 40000;
   Tv[49] := MinR(Tv[64],Tv[66]);
   Tv[48] := Tv[49] * 0.25;
   Tv[19] := Tv[46]+Tv[43]+Tv[48];

   //Page 3 --------------------------------------------------------------------
   //recapture of ICT  part c
   Tv[28] := Tv[20] * 0.15; //0.30; //20140913
   Tv[41] := Tv[39] * 0.20;
   Tv[74]:=Tv[28]+Tv[41];
   Tv[72]:=MinR(Tv[70],Tv[71]);
   Tv[73]:=Tv[69]+Tv[72];
   Tv[51] := Tv[74]+Tv[73]; //Tv[28]+Tv[41]; //20140209
   //========================
   // PARET D
   Tv[3]:=Tv[16];
   Tv[17]:=Tv[426];
   Tv[45]:=Tv[16]+Tv[42];
   Tv[67]:=Tv[137]+Tv[45];
   //Tv[68]:=???  from T3
   Tv[77]:=MaxR(0,Tv[67]-Tv[68]);
   Tv[78]:=Ret[RetNo].Lnn[40600];
   Tv[79]:=Ret[RetNo].Lnn[41000];
   Tv[80]:=MaxR(0,Tv[78]-Tv[79]);
   Tv[81]:=Ret[RetNo].Lnn[41400];
   Tv[82]:=MaxR(0,Tv[80]-Tv[81]);
   Tv[83]:=Tv[82];
   Tv[84]:=MinR(Tv[77],Tv[83]);

   Tv[85]:=Tv[83];
   Tv[86]:=Ret[RetNo].Lnn[40500];
   Tv[87]:=Tv[85]+Tv[86];
   Tv[88]:=Vl(FetchElm(RetNo,'T691',129));
   Tv[89]:=MaxR(0,Tv[13]-Tv[14]);
   Tv[90]:=Tv[89];
   Tv[91]:=MinR(Tv[77],Tv[89]);
   if SubjectToMinTax(RetNo) then
   begin
    Tv[92]:=Tv[91];
   end
   else
   begin
    Tv[92]:=Tv[84];
   end;
   //=================================
   //PAERT E  Page 5
   Tv[4]:=Tv[77];
   Tv[5]:=Tv[137];
   Tv[9]:=MaxR(0,Tv[77]-Tv[137]);
   Tv[93]:=Tv[9];
   if SubjectToMinTax(RetNo) then
    Tv[94]:=Tv[91]
   Else
    Tv[94]:=Tv[83];

   Tv[95]:=Tv[137];
   Tv[96]:=MaxR(0,Tv[94]-Tv[95]);
   Tv[97]:=Tv[96];
   Tv[98]:=MaxR(0,Tv[93]-Tv[97]);
  //-----------------------------------
   //Carry back request
   Frm[FNo].Strings[105] := IntToStr(StrToInt(AppYear)-3);
   Frm[FNo].Strings[107] := IntToStr(StrToInt(AppYear)-2);
   Frm[FNo].Strings[109] := IntToStr(StrToInt(AppYear)-1);

   Tv[111] := MinR(TV[98],Tv[106]+tv[108]+Tv[110]);
   Strings[124] := DateToYYYYMMDD(Date);
   //=====================End of pert E =====
   //PART E contniued

   Tv[6]:=Tv[16];
   Tv[99]:=Tv[68];
   Tv[100]:=MaxR(0,Tv[6]-Tv[99]);
   Tv[101]:=Tv[100];
   Tv[120]:=Tv[92];
   Tv[126]:=Tv[137];
   Tv[127]:=MaxR(0,Tv[120]-Tv[126]);
   Tv[128]:=Tv[111];
   Tv[129]:=Tv[127]+Tv[128];

   Tv[130]:=Tv[42];
   Tv[131]:=MaxR(0,Tv[129]-Tv[130]);
   Tv[133]:=MaxR(0,Tv[101]-Tv[132]);

   if Tv[134]>Tv[133] then Tv[134]:=Tv[133];
   Tv[135]:=Tv[134]*0.40;

   Tv[136]:=Tv[77];
   Tv[139]:=Tv[92];
   Tv[141]:=Tv[111];
   Tv[144]:=Tv[135];
   Tv[147]:=Tv[139]+Tv[141]+Tv[144];
   Tv[148]:=Tv[147];
   Tv[146]:=MaxR(0,Tv[77]-Tv[148]);

   {
   //allowable claim
   Tv[21] := Tv[142];
   Tv[22] := Vl(FetchElm(RetNo,'POLIT',22));  //20220320//Lnn[40600]; //Vl(FetchElm(RetNo,'T3',310));  //20220320//Lnn[40600];
  // Tv[23] := polit contr credit ??  Lnn[41000];
   Tv[24] := MaxR(0,Tv[22] - Tv[23]);
   Tv[25] := Lnn[41400];
   Tv[26] := MaxR(0,Tv[24] - Tv[25]);
   Tv[47] := Tv[26];
   Tv[37]:=MinR(Tv[21],Tv[47]);

   //20220320
   //optimize
   //If (ret[RetNo].Lnn[40600] > Vl(FetchElm(RetNo,'T691',129))) then   //> than minimum amount
   // Tv[37]:=MinR(Tv[37],ret[RetNo].Lnn[40600] - Vl(FetchElm(RetNo,'T691',129)));

   If UpperCase(Frm[FNo].Strings[36])='Y' then Tv[37]:=Tv[38];

   //if min tax applies
   If Vl(FetchElm(RetNo,'T691',249))>0 then  //same as above
   begin
    Tv[27] := Tv[47];
    //2009021
    Tv[75]:=ret[RetNo].Lnn[405];
    Tv[76]:=Tv[27]+Tv[75];

    Tv[29] := Vl(FetchElm(RetNo,'T691',129));
    Tv[30] := MaxR(0,Tv[76] - Tv[29]); //20090201
    //Tv[30] := MaxR(0,Tv[27] - Tv[29]);
    Tv[31] := Tv[30];
    Tv[40]:=MinR(Tv[21],Tv[31]);
    If UpperCase(Frm[FNo].Strings[42])='Y' then Tv[40]:=Tv[43];

    Tv[37]:=0;  //???? WHy?
   end
   else
   begin
     Tv[27]:=0;Tv[29]:=0;Tv[30]:=0;Tv[31]:=0;Tv[40]:=0;
   end;

   If Not SubjectToMinTax(RetNo) then
     Tv[125]:=0
   else
     Tv[125]:= MinR(Vl(FetchElm(RetNo,'T2038',148)),
                  Vl(FetchElm(RetNo,'T2038',131)));
   Tv[138] := Tv[16]; //Vl(FetchElm(RetNo,'T2038',16)); //20210310
   Tv[152] := Tv[42]; //Vl(FetchElm(RetNo,'T2038',19)); //Vl(FetchElm(RetNo,'T2038',19));  //20210310
   Tv[142] := Tv[137]+Tv[138]+Tv[152]+Tv[140];
   //Tv[143] :=MinR(Tv[142],Vl(FetchElm(RetNo,'T2038',147)));
   //june 17, 2002
   Tv[143]:= Vl(FetchElm(RetNo,'T2038',37));
   If Vl(FetchElm(RetNo,'T2038',140))>0 then
   begin
    Tv[125]:=Vl(FetchElm(RetNo,'T2038',140));
    Tv[143]:=0;
   end;
   Tv[145] := Tv[111]+Tv[123];
   Tv[146] := MaxR(0,Tv[142] - Tv[143] - Tv[125] - Tv[145]);

   Tv[102] := MaxR(0,Tv[142]-Tv[137]);
   Tv[103] :=MaxR(0, Tv[143]+Tv[125]-Tv[137]);
   Tv[104] := MaxR(0,Tv[102] - Tv[103]);
  }

  {
   Tv[111] := MinR(Tv[104],Tv[106]+tv[108]+Tv[110]);

   Frm[FNo].Strings[124] := DateToYYYYMMDD(Date);

   //ITC available for refund
   Tv[112] := MaxR(0,Tv[138]-Tv[140]);
   Tv[113] :=MaxR(0,Tv[143]+Tv[125]-Tv[137]);
   Tv[114] := Tv[111];
   Tv[116] := Tv[113]+Tv[114];
   Tv[117] := Tv[152];
   Tv[115] := MaxR(0,Tv[116]-Tv[117]);
   Tv[118] := Tv[115];
   Tv[119] := MaxR(0,Tv[112] - Tv[118]);

   //Calculating ITC refund
   //Tv[120] := Tv[119];   //20200208
   Tv[121] := Tv[119];
   Tv[122] := 0.40;
   Tv[123] := Tv[121] * Tv[122];

   Lnn[45400] := Tv[123];
  }
  End;
  SaveTv(RetNo,FName,FNo);
End;



Procedure T2038(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
Begin

  //USE T1 VERSION
  if true then begin T2038fromT1(RetNo,FName,FNo); EXIT; end;
  //if true then begin T2038PreviousWithEXIT(RetNo,FName,FNo); exit; end;


  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do   //with Ret[RetNo] do
  begin
   //20220305
  // Frm[FNo].Strings[1] := AppYear;
  // Tv[4] := Tv[3] * 0.30;
   Tv[8] := Tv[7] * 0.15;
   Tv[33] :=Tv[32] * 0.15;
   Tv[12] := Tv[11] * 0.10;
   Tv[15] := Tv[14] * 0.15;
   Tv[16] := Tv[4]+Tv[8]+Tv[33]+Tv[12]+Tv[15];

  // Tv[34]:=Vl(FetchElm(RetNo,'T1229',71));

   Tv[18]:=Tv[34]+Tv[35];     //???
   Tv[46] := Tv[18] * 0.15;
   i:=54;
   Repeat
    If Tv[i]>20000 then Tv[i]:=20000;
    Inc(i,3);
   until i>63;

   Tv[44] :=Tv[54]+Tv[57]+Tv[60]+Tv[63]; //vl(FetchElm(RetNo,'AJCTC',101));
   Tv[43] :=  Tv[44] * 0.10;

   //child care spaces
   Tv[66] := Vl(Strings[65]) * 40000; //jz//Tv[66] := Vl(Frm[FNo].Strings[65]) * 40000;
   Tv[49] := MinR(Tv[64],Tv[66]);
   Tv[48] := Tv[49] * 0.25;
   Tv[19] := Tv[46]+Tv[43]+Tv[48];

   Tv[72]:=MinR(Tv[70],Tv[71]);
   Tv[73]:=Tv[69]+Tv[72];
   //Page 3 --------------------------------------------------------------------

   //recapture of ICT
   Tv[74]:=Tv[73];
   Tv[28] := Tv[20] * 0.30;
   Tv[41] := Tv[39] * 0.20;
   Tv[51] := Tv[74]+Tv[28]+Tv[41];

   //allowable claim
   Tv[21] := Tv[142];
   Tv[22] :=GetFedTaxBfrITC(RetNo); //Vl(FetchElm(RetNo,'S11',112));
   Tv[23] := Vl(FetchElm(RetNo,'S11',107));

   Tv[24] := MaxR(0,Tv[22] - Tv[23]);
   //Tv[25] := Ln[414];  //n/a in T3
   Tv[26] := MaxR(0,Tv[24] - Tv[25]);
   Tv[47] := Tv[26];
   Tv[37]:=MinR(Tv[21],Tv[47]);

   //optimize

   //   If (Ret[RetNo].Ln[406] > Vl(FetchElm(RetNo,'T691_2',29))) then   //> than minimum amount
   //    Tv[37]:=MinR(Tv[37],Ret[RetNo].Ln[406] - Vl(FetchElm(RetNo,'T691_2',29)));

   If UpperCase(Strings[36])='Y' then Tv[37]:=Tv[38]; //jz//If UpperCase(Frm[FNo].Strings[36])='Y' then Tv[37]:=Tv[38];

   //if min tax applies
   If SubjectToMinTax(RetNo) then
   //If Vl(FetchElm(RetNo,'T691_3',49))>0 then
   begin
    Tv[27] := Tv[47];
    //  Tv[75]:=Ret[RetNo].Ln[405];   //fed foreign tax credit not in T3
    Tv[76]:=Tv[27]+Tv[75];
//  Tv[29] :=Vl(FetchElm(RetNo,'S12',117));  //20130118
    Tv[30] := MaxR(0,Tv[76] - Tv[29]);
    Tv[31] := Tv[30];
    Tv[40]:=MinR(Tv[21],Tv[31]);
    If UpperCase(Strings[42])='Y' then Tv[40]:=Tv[43]; //jz//    If UpperCase(Frm[FNo].Strings[42])='Y' then Tv[40]:=Tv[43];

    tv[37]:=0;
   end
   else
   begin
     Tv[27]:=0;Tv[29]:=0;Tv[30]:=0;Tv[31]:=0;Tv[40]:=0;
   end;

   {   not/Appl to T3?
   If Not SubjectToMinTax(RetNo) then
     Tv[125]:=0
   else
     Tv[125]:= MinR(Vl(FetchElm(RetNo,'T2038',48)),Vl(FetchElm(RetNo,'T2038',31)));
   }
   Tv[138] := Vl(FetchElm(RetNo,'T2038',16));
   Tv[152] :=  Vl(FetchElm(RetNo,'T2038',19));
   Tv[142] := Tv[137]+Tv[138]+Tv[152]+Tv[140];
   Tv[143]:= Vl(FetchElm(RetNo,'T2038',37));
   If Vl(FetchElm(RetNo,'T2038',140))>0 then
   begin
    Tv[125]:=Vl(FetchElm(RetNo,'T2038',140));
    Tv[143]:=0;
   end;

   Tv[145] := Tv[111]+Tv[123];
   Tv[146] := MaxR(0,Tv[142] - Tv[143] - Tv[125] - Tv[145]);

   Tv[102] := MaxR(0,Tv[142]-Tv[137]);
   Tv[103] :=MaxR(0, Tv[143]+Tv[125]-Tv[137]);
   Tv[104] := MaxR(0,Tv[102] - Tv[103]);

   //Carry back request
   Strings[105] := IntToStr(StrToInt(AppYear)-3); //jz//Frm[FNo].Strings[105] := IntToStr(StrToInt(AppYear)-3);
   Strings[107] := IntToStr(StrToInt(AppYear)-2); //jz//Frm[FNo].Strings[107] := IntToStr(StrToInt(AppYear)-2);
   Strings[109] := IntToStr(StrToInt(AppYear)-1); //jz//Frm[FNo].Strings[109] := IntToStr(StrToInt(AppYear)-1);

   Tv[111] := MinR(Tv[104],Tv[106]+tv[108]+Tv[110]);

   Strings[124] := DateToYYYYMMDD(Date);   //jz//Frm[FNo].Strings[124] := DateToYYYYMMDD(Date);

   //ITC available for refund
   Tv[112] := MaxR(0,Tv[138]-Tv[140]);
   Tv[113] :=MaxR(0,Tv[143]+Tv[125]-Tv[137]);
   Tv[114] := Tv[111];
   Tv[116] := Tv[113]+Tv[114];
   Tv[117] := Tv[152];
   Tv[115] := MaxR(0,Tv[116]-Tv[117]);
   Tv[118] := Tv[115];
   Tv[119] := MaxR(0,Tv[112] - Tv[118]);

   //Calculating ITC refund
   Tv[120] := Tv[119];
   Tv[121] := Tv[119];
   Tv[122] := 0.40;
   Tv[123] := Tv[121] * Tv[122];
//   Ln[454] := Tv[123];
  End;
  SaveTv(RetNo,FName,FNo);
End;


Procedure CalcAutoExp(RetNo:integer;FName:string;FNo:integer;Stm:string);
Var I: integer; FInst :String[4];k,Gst,Pst:real;
 Line5K,Line6K,Line7K:Real;Yr:String[4];
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
  begin
   If Stm = 'B' then
      begin
       Tv[118] := Vl(FetchElm(RetNo,'T2125'+FInst,424));
       If Strings[39] = '' then Strings[39] := 'Business Statement '+FInst;
      end
   else If Stm = 'P' then
     begin
       Tv[118] := Vl(FetchElm(RetNo,'T2032_3'+FInst,124));
       If Strings[39] = '' then Strings[39] := 'Professional Statement '+FInst;
      end

   else If Stm = 'I' then  {fishing}
     begin
       Tv[118] := Vl(FetchElm(RetNo,'T2121'+FInst,260));
       If Strings[39] = '' then Strings[39] := 'Fishing Statement '+FInst;
      end

   else If Stm = 'F' then  {farming}
     begin
       Tv[118] := Vl(FetchElm(RetNo,'T2042'+FInst,524));
       If Strings[39] = '' then Strings[39] := 'Farming Statement '+FInst;
      end

   else If Stm = 'O' then  {Other - unattached}
     begin
       {Tv[118] := Vl(FetchElm(RetNo,'T2121_4'+FInst,124));}
      end;

   If (Vl(Strings[4]) =0) and (Vl(Strings[7]) =0) then
      begin Strings[4] :='1';Strings[7] :='1';end;
   For i :=4 to 6 do
     If Vl(Strings[i+3]) < Vl(Strings[i]) then Strings[i+3] := Strings[i];

   Tv[119] := Tv[118]-Tv[120]-Tv[121];

   {interest}
   Tv[19] := Tv[115];
   Tv[20]:=Tv[116];
   Tv[21]:=Tv[117];
   {Lease}
   Tv[16]:=Tv[99];
   Tv[17]:=Tv[100];
   Tv[18]:=Tv[101];

   For i:=0 to 2 do
   begin
    Tv[42+i] := Tv[10+i]+Tv[19+i]+Tv[22+i]+Tv[25+i]+Tv[13+i]+tv[16+i]
                +Tv[32+i]+Tv[36+i];
    If Vl(Strings[7+i]) > 0 then
      Tv[45+i] := Tv[42+i] * (Vl(Strings[4+i]) / Vl(Strings[7+i]))
    else
      Tv[45+i] := 0;
    Tv[54+i] := MaxR(0,Tv[45+i] + Tv[48+i]-Tv[51+i]);

    If Vl(Strings[7+i]) > 0 then
      Tv[122+i] := Tv[119+i] * (Vl(Strings[4+i]) / Vl(Strings[7+i]))
    else
      Tv[122+i] := 0;

    {Lease}
    Yr :=RightStr(Strings[57+i],4);
    Line5K:= GetLine5K(Yr);
    If Tv[126+i] =0 then Tv[126+i] := 7;
    If yr='' then Tv[126+i] :=0;
    Gst:= Line5K*Tv[126+i]/100;
    Pst := Line5K*Vl(Strings[63+i])/100;
    If yr< '1991' then  begin gst:=0;Pst:=0;end;

    k:=Line5k+Gst+Pst;
    Tv[78+i] := MaxR(k,Tv[75+i]) * 0.85;

    Line6K := GetLine6K(Yr);
    Gst:= Line6K*Tv[126+i]/100;Pst := Line6K*Vl(Strings[63+i])/100;
    If yr< '1991' then  begin Gst:= 0;Pst := 0;end;
    k:=Line6K+Gst+Pst;
    Tv[81+i] := MaxR(0,((k * Tv[72+i])/30) - Tv[69+i]);

    Line7K := GetLine7K(Yr);
    Gst:= Line7K*Tv[126+i]/100;Pst := Line7K*Vl(Strings[63+i])/100;
    If yr< '1991' then  begin gst:=0;Pst:=0;end;
    k:=Line7K+Gst+Pst;
    If Tv[78+i] >0 then
     Tv[84+i] := k * Tv[66+i]/Tv[78+i]
    else
     Tv[84+i] :=0;


    Tv[99+i] := MinR(Tv[81+i],Tv[84+i]);
    {Interest}
    If Tv[109+i] = 0 then Tv[109+i] := 8.33;
    If Vl(Strings[106+i]) = 0 then Tv[109+i] := 0;
    Tv[112+i] := Vl(Strings[106+i]) * Tv[109+i];
    Tv[115+i] := MinR(Tv[103+i],Tv[112+i]);
   end;

   Tv[102] := Tv[54]+Tv[55]+Tv[56];
   Tv[125] := Tv[122]+Tv[123]+Tv[124];
 end; {End with}
  SaveTv(RetNo,FName,FNo);
 End;

Function GetLine5K(Yr:String):Real;
begin
 If Yr>'2021' then Result := 40000;  //20230108
 (*
 If Yr>='2001' then Result := 35294;
 If Yr='2000' then Result := 31765; {2000 and till now}
 If (Yr >'1997') and (Yr < '2000') then result := 30588;
 If Yr = '1997' then result := 29412;
 If (Yr >'1990') and (Yr < '1997') then result := 28235;
 If yr < '1990' then result := 23529;
 *)
 If Yr='' then result :=0;
end;

Function GetLine6K(Yr:String):Real;
begin
 If Yr>'2021' then Result := 900;
 (*
 If Yr>='2001' then Result := 800;
 If Yr='2000' then Result := 700;
 If (Yr >'1997') and (Yr < '2000') then result := 650;
 If Yr = '1997' then result := 550;
 If (Yr >'1990') and (Yr < '1997') then result := 650;
 If yr < '1990' then result := 600;
 *)
 If Yr='' then result:=0;
end;

Function GetLine7K(Yr:String):Real;
begin
 If Yr>'2021' then Result := 34000;
 (*
 If Yr>='2001' then Result := 30000;
 If Yr='2000' then Result := 27000;
 If (Yr >'1997') and (Yr < '2000') then result := 26000;
 If Yr = '1997' then result := 25000;
 If (Yr >'1990') and (Yr < '1997') then result := 24000;
 If yr < '1990' then result := 20000;
 *)
 If Yr='' then result :=0;
end;


Procedure CalcBusProf_3(RetNo:integer;FName:string;FNo:integer;Stm:string);
Var I,j,AssetsFNo: integer; FInst :String[4];Stmt:String;
 Dummy:Real; RemainingAmount:Real;MaxCCA:Real;
 TermLossAmount,RecaptAmount:Real;
 AutoCCAForStmt, v5, v6, v8, v9:Real;
Begin
  If FNo=0 then exit;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   Tv[215]:=0;  Tv[216]:=0;  //Feb 23 2008
   Stmt:=LeftStr(FName,5);
   If PostCCaFromAssetsB(RetNo) then
   begin
    PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,1,71,10,80,81,82);
    Tv[215]:=Vl(Strings[215]);
    Tv[216]:=Vl(Strings[216]);
   end
   Else  //calculate it
   begin
    {CCA}
    Tv[82] := 0;
    I := 1;
    Repeat
      If AllTrim(Strings[i])='0' then Strings[i]:='';
      If Uppercase(Strings[214]) <> 'X' then  Strings[i+6] := GetCCARate(Strings[i]);
      Dummy:=0;
      v5 := Tv[i+4];
      v6 := Tv[i+5];
      v8 := Tv[i+7];
      v9 := Tv[i+8];
      CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       v5,v6,Strings[i+6],v8,v9,
                       Strings[214],Strings[i+9],True,'',100,MaxCCA);
      Tv[i+4] := v5;
      Tv[i+5] := v6;
      Tv[i+7] := v8;
      Tv[i+8] := v9;

      Tv[82] := Tv[82] + Tv[I+7];
      I := i+10;
    until i > 71;
    Tv[82] := Tv[82] + Tv[81];
   end;

   {cca - motor veh}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    Tv[215]:=Tv[215]+TermLossAmount;
    Tv[216]:=Tv[216]+RecaptAmount;
    For i:=83 to 124 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    For i:=215 to 217 do begin Tv[i]:=0;Strings[i]:='';end; //clear section Feb 25 2008
    Tv[123]:=0; //suppl clear
    RemainingAmount:=0;
    j:=83;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>113 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds;
         Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAForTheYear; //CCAClaimed;
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;
         Inc(j,10);
        end;
      end;
    end;
    Tv[123]:=RemainingAmount;
   Tv[124] := 0;
   I := 83;
    Repeat
     Tv[124] := Tv[124] + Tv[I+7];
     I := i+10;
    until i > 113;
    Tv[124] := Tv[124] + Tv[123];
    Tv[217]:=Tv[82]+AutoCCAForStmt; //Tv[124];  //Feb 25 2008
    //non build additions
    If PostCCaFromAssetsB(RetNo) then
    begin
     If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,125,140,5,144,145,146);
    end;
    I := 127; Tv[146] := 0;
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[146] := Tv[146] + Tv[I+2];
       i := i + 5;
     Until i > 142;
     Tv[146] := Tv[146] + Tv[145];

    {motor additions}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=147 to 168 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[167]:=0; //clear suppl
    RemainingAmount:=0;
    j:=147;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions >0 then
        begin
          If j>162 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[167]:=RemainingAmount;
    I := 149; Tv[168] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[168] := Tv[168] + Tv[I+2];
      i := i + 5;
    Until i > 164;
    Tv[168] := Tv[168] + Tv[167];
    Tv[169] := Tv[146] + Tv[168];

    //building additions
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,170,185,5,189,190,191);
    end;
    I := 172; Tv[191] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[191] := Tv[191] + Tv[I+2];
      i := i + 5;
    Until i > 187;
    Tv[191] := Tv[191] + Tv[190];

    //equipm dispositions other than buildings and motor veh
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,192,207,5,211,212,213);
    end;
    I := 194; Tv[213] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[213] := Tv[213] + Tv[I+2];
      i := i + 5;
    Until i > 209;
    Tv[213] := Tv[213] + Tv[212];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
End;

Procedure CalcCCA(Cls:string;UccStart:real;
                 Additions:real;Proceeds:real;
                 Var Adjustments:real;Var BaseForCCA:real;
                 Rate:string;Var CCA:real;Var UccEnd:real;
                 OvrCCA:string;OvrUCC:string;ClaimIt:Boolean;
                 Rule50Exempt:String;BusPercent:Real;Var MaxCCA:Real);
Var AdjUcc:real;OvrRate:Boolean;
begin
     If BusPercent>100 then BusPercent:=100;
     AdjUcc      := UccStart + Additions - Proceeds;
     Adjustments := MaxR(0, 0.5 * (Additions - Proceeds));
     If UpperCase(Rule50Exempt)='X' then Adjustments:=0;
     BaseForCCA  := AdjUcc - Adjustments;

     If AllTrim(Rate) <> GetCCARate(Cls) then
     begin
       If BaseForCCA <0 then CCA := BaseForCCA
       else
       begin
        MaxCCA:=  BaseForCCA * (Vl(Rate) / 100);
        CCA   := (BaseForCCA * (Vl(Rate) / 100) * (BusPercent)/100);
       end
     end
     else
     begin
      If UpperCase(OvrCCA) <> 'X' then
      begin
       If BaseForCCA <0 then CCA := BaseForCCA
       else
       begin
         MaxCCA:=  BaseForCCA * (Vl(Rate) / 100);
         CCA   := (BaseForCCA * (Vl(Rate) / 100) * (BusPercent/100));
       end;
      end;
     end;
     If UpperCase(Cls) = '10A' then CCA := BaseForCca * (30/100)+Additions * (85/100);
     If UpperCase(Cls) = '12A' then CCA := BaseForCca * (100/100)+Additions * (50/100);
     If ClaimIt=False then CCA :=0;
     If OvrUcc <> 'OVRUCC' then UccEnd   := MaxR(0,AdjUcc - CCA);
     If cls='10.1' then OvrUcc :=''; //not allowed
     {terminal loss}
     If UpperCase(OvrUCC) = 'X' then
     begin
      If UccEnd >0 then begin CCA := AdjUcc;UccEnd :=0;end;
     end;
     { if Term loss
       CCA :=0;
       Recapture :=0;
       TerminalLoss := MaxR(0,UCCReduced);  //UCC - HalfRuleAmount;
       UccEnd   := 0;
    }
end;



(*
//20230224
//line 1 is the NAME - T12125 has line 2 First Last Name. Not in T3
Procedure T2125(RetNo:integer;FName:string;FNo:integer);
Var i,j,jj,k,NumCars,AutosFNo :integer;
  FInst,Stmt:String;  //[5];  //20110125
  TermLossAmount,RecaptAmount:Real;AutoCCAForStmt:Real;
  CCAForStmt:Real;
  RemainingAmount:Real;MaxCCA:Real;
  T4AFNo,T1204FNo:Integer;

Begin
 If FNo=0 then exit;
 T4AFNo:=GetFormNo('T4A#1');
 T1204FNo:=GetFormNo('T1204#1');

 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin


   If Strings[49]='' then Strings[49]:='0';
   If Strings[51]='' then Strings[51]:='0';
   If Vl(Strings[51])>100 then Strings[51]:='0';
   If (Strings[17]>'') and (Strings[52]='') then  //20140130
   begin
     Strings[17]:='';
     Strings[52]:='';
   end;

   {T1 only
   If UpperCase(Strings[77]) ='Y' then  //same address
   begin
     //20100305
     Strings[10]:=FetchElm(RetNo,'INFO',22)+' '+FetchElm(RetNo,'INFO',6)+' '+FetchElm(RetNo,'INFO',68)
        +FetchElm(RetNo,'INFO',163); //Apt street rr po box  //20180110
     Strings[13]:= FetchElm(RetNo,'INFO',10); //+', '+FetchElm(RetNo,'INFO',14);//city prov //20180111
     Strings[53]:= FetchElm(RetNo,'INFO',14); //20180111
     Strings[14]:= FetchElm(RetNo,'INFO',15);//postal
   end;
   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
   }
   //20220305
   //   Strings[2]:=GetT3TrustName(RetNo);
   //   Strings[3]:='T'+GetT3AccountNumber(RetNo);
   If Strings[4] ='' then Strings[4] := AppYear+'-01-01';
   If Strings[5] ='' then Strings[5] := AppYear+'-12-31';
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;
   Strings[9]:=LeftStr(Strings[9],30);   //20220309
   If Strings[18] = '' then Strings[18]:='100.0000';  //20111208
   Strings[18]:=FormatFloat('##0.0000',Vl(Strings[18])); //20111208
   If Strings[73]+Strings[74] ='' then
     begin Strings[73] := 'X';Strings[74] := ''; end;
   //If Strings[11]+Strings[22] ='' then  begin Strings[11] := 'X';Strings[22] := ''; end; //20181115

   If Strings[17] ='' then Strings[17] := OptRec.Prp_Name; //20140130
   If Strings[52] ='' then
      Strings[52]:=OptRec.Prp_Street+','+OptRec.Prp_City+','+OptRec.Prp_Prov+','+OptRec.Prp_Postal; //20130131
   If Strings[82]+Strings[90]='' then Strings[82]:='X'; //20110308
  //If Strings[2]+Strings[90]='' then Strings[82]:='X';

   {
   If Strings[82]>'' then Tv[76]:=GetT4AIncomeForT2125(RetNo,FInst)      //20110207
   else If Strings[90]>'' then Tv[84]:=GetT4AIncomeForT2125(RetNo,FInst);      //20110207
   }
   If Strings[82]='' then        //20120112
   begin
    Tv[23]:=0; Tv[76]:=0;Tv[24]:=0;
    For i:=38 to 40 do Tv[i]:=0;
    //For i:=23 to 27 do Tv[i]:=0;
    Tv[83]:=0;
   end
   else
   begin
   // Tv[76]:=GetT4AIncomeForT2125(RetNo,FInst);  //201102
   // Tv[85]:=GetT1204IncomeForT2125(RetNo,FInst); //20190208
    Tv[86]:=Tv[76]+Tv[26]+Tv[85];   //20190208
    Tv[38]:=Tv[23]+Tv[86]-Tv[24]; //20190208 //Tv[23]+Tv[76]-Tv[24]+Tv[26];  //20130110 //added T3
    Tv[46]:=Tv[39]-Tv[40]; //20120210 //Tv[26] := Tv[39]+Tv[40]++Tv[25];  //20120111 Tv[24] + Tv[25];
    //Tv[27] := Tv[26];
   // If Tv[76]>0 then ret[RetNo].FrmHasData[GetFormNo('T2125#1')]:=True;
    If Tv[76]>0 then ret[RetNo].FormHasData['T2125'+FInst]:=True;  //20110414
    Tv[83]:=Tv[38]+Tv[46]; //// 20120111 Tv[23]+Tv[76]-Tv[27];
   end;
   Tv[83]:=MaxR(0,Tv[83]);  //20100619

   If Strings[90]='' then
   begin
    Tv[89]:=0;
    Tv[84]:=0;Tv[41]:=0;Tv[42]:=0;Tv[43]:=0;Tv[44]:=0;Tv[45]:=0;Tv[87]:=0;Tv[93]:=0;//For i:=84 to 88 do Tv[i]:=0;
    //For i:=91 to 93 do Tv[i]:=0;
   end
   else
   begin
    //Tv[84]:=GetT4AIncomeForT2125(RetNo,FInst);
   // Tv[86] := Tv[88] + Tv[87];
   // If Finst='#1' then Tv[84]:=TotMultiple(RetNo,'T4A',3)+TotMultiple(RetNo,'T4A',24); //20110207
    //Tv[85] := Tv[86];
    Tv[42]:=Tv[89]+Tv[84]-Tv[41];
    Tv[45]:=Tv[43]-Tv[44];
    //Tv[91]:=Tv[89]+Tv[84]-Tv[85];
   // If Tv[84]>0 then ret[RetNo].FrmHasData[GetFormNo('T2125#1')]:=True;
    If Tv[84]>0 then ret[RetNo].FormHasData['T2125'+FInst]:=True;  //20110414
    Tv[93]:=Tv[42]+Tv[45]+Tv[87]; //20120315  //Tv[93]:=Tv[42]+Tv[45]-Tv[87]; //Tv[91]+Tv[92];
   end;
   {
   //20110208
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[37] :=OptRec.Bus_Disclm
   else
     Strings[37] :='';
   }
   //part 3
   Tv[28]:=MaxR(Tv[83],Tv[93]);
    //recapt
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[66]:=RecaptAmount;
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[66]:=Tv[66]+RecaptAmount;
   //Tv[66]:=Tv[66]+Tv[655];  //CEC recapture  //20171119
   Tv[31]:=Tv[75]+Tv[66];
   Tv[33]:=Tv[31];
   Tv[34]:=Tv[29]+Tv[33];
   Tv[94]:=Tv[34];
   If Strings[35]='' then Tv[32]:=Tv[28]+Tv[94];
  end; {End with}
   //pg 2  ???
  with ret[RetNo].Frm[Fno] do
  begin
   If Strings[82]>''  then //business
   begin
    If Strings[35]='' then
      Tv[101]:=Tv[32]
    else Tv[101]:=0;
    Tv[139] := Tv[133] + Tv[134] + Tv[135] +Tv[136]+Tv[138];
    Tv[141] := MaxR(0,Tv[139] - Tv[140]);  //20100619
    Tv[142] := Tv[141];
    If Strings[35]='' then
      Tv[143] := Tv[101] - Tv[142]
    Else
      Tv[143]:=0;
   end
   else
   begin
    Tv[101]:=0;
    For i:=133 to 143 do Tv[i]:=0;
   end;

   If Strings[35]='' then
   begin
   If Strings[82]>''  then //business
     Tv[108]:=Tv[143]
   else
     Tv[108]:=Tv[32];
   end
   else
     Tv[108]:=0;  //T5013
   //CCA
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[168]:=CCAForStmt;
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[168]:=Tv[168]+AutoCCAForStmt;
  //Term loss
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[180]:=TermLossAmount;
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[180]:=Tv[180]+TermLossAmount;


  // Tv[169] := Tv[652]; {normal cec allowance} //20171119
   If Strings[36]='' then Strings[36]:='50';
   If vl(Strings[36])>100 then Strings[36]:='100';
   //Tv[153] := Vl(FormatFloat('#########.##',Tv[165]*0.50));
   Tv[153] := Vl(FormatFloat('#########.##',Tv[165]*vl(Strings[36])/100)); //20110117
   //get autoexpenses
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[154]:=0;
   For i:=0 to ExtractedAutoList.count-1 do
   begin
     ExtractedAutoRec:=ExtractedAutoList.Items[i];
     If ExtractedAutoRec.PartnerFlag='' then
       Tv[154]:=Tv[154]+ExtractedAutoRec.ExpensesClaimed;
   end;

   If UpperCase(Strings[178]) = 'Y' then Tv[154]:=Tv[179];
   Tv[181]:=Tv[164]+Tv[180];
   Tv[170]:=Tv[144]+Tv[153]+Tv[145]+Tv[149]+Tv[150]+Tv[146]+Tv[155]+Tv[156]+Tv[157]+Tv[152];
   Tv[170]:=Tv[170]+Tv[159]+Tv[151]+Tv[160]+Tv[158]+Tv[161]+Tv[162]+Tv[148]+Tv[147]+Tv[154]; //+Tv[169]; //20171119
   Tv[170]:=Tv[170]+Tv[168]+Tv[181];
   Tv[171]:=Tv[170];
   Tv[172]:=Tv[108]-Tv[171];
   {NI before adjustments}
   If UpperCase(Strings[176]) <> 'Y' then    //20110204
    //If UpperCase(Strings[76]) <> 'Y' then
      Tv[102] := Tv[172] *  Vl(Strings[18]) / 100;  {Share}  //20111208
    Tv[110]:=Tv[102]+Tv[109];
    Tv[111]:=Tv[110];

    Tv[103] := Tv[215];
    Tv[104] := Tv[111] - Tv[103];
    Tv[105]:= Tv[235]; //Tv[335];
    If Strings[35]='' then Tv[106]:= Tv[104]-Tv[105];    //??? 35??
  end; {End with}

   //pg 3
  with ret[RetNo].Frm[Fno] do
  begin
   {
   If ShowCondominiumIndicator = True then
   begin
    If Strings[222]='' then Strings[222]:='Condominium fees';
    If Strings[224]='' then Strings[224]:='Telephone expenses';
   end;
  }
   If Vl(Strings[238]) >0 then
    begin
    {
    Strings[257] :=GetSpouseFirstName(RetNo);
    Strings[239] :=GetSpouseLastName(RetNo);
    Strings[242] :=GetSpouseSIN(RetNo);
    Strings[236] :=GetSpouseAddress(RetNo);
    }
    end
   else
   begin
    Strings[257] :='';
    Strings[239] :='';
    Strings[242] :='';
    Strings[236] :='';
   end;

    {amounts deductible}
    Tv[214]:=Tv[213]+Tv[275];
    Tv[215] := Tv[208] +Tv[210]+tv[212]+tv[214]
       +Tv[55];   //20171212
    {business use of home}
    //20180117
    Tv[70]:=Tv[223]+Tv[225]+Tv[227];
    Tv[71]:=Tv[70];
    Tv[228] := Tv[216] +Tv[217]+tv[218]+tv[219]+tv[220]+Tv[221]+Tv[71];
    //Tv[228] := Tv[228] +Tv[223] +Tv[225]+tv[227];
    If UpperCase(Strings[272]) <> 'Y' then Tv[255]:=100;
    Tv[228] := Tv[228] * Tv[255] /100;

    Tv[229] := (Tv[228] * Tv[254]) / 100;  {pers use}
    Tv[230] := Tv[228] - Tv[229];

    //Tv[274] := Tv[230]+Tv[273];
    Tv[232] := Tv[230] + Tv[273]+Tv[231];

    Tv[233] := MaxR(0,Tv[104]); //MaxR(0,Tv[4]);
    Tv[234] := MaxR(0, Tv[232]-Tv[233]);
    Tv[235] := MinR(Tv[232],Tv[233]);

    {partners}

    //sins
    i:=242; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=262; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=265; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=268; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=271; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');

    Tv[204]:=0; //tot *
    i := 237;    {calc inc for partners}
    repeat
        Tv[i] := (Tv[172]*  Vl(Strings[i+1])) / 100;
        Strings[i+1]:=FormatFloat('##0.0000',Vl(Strings[i+1]));
        If Strings[i+1]='0.0000' then strings[i+1]:=''; //20111208
        Tv[204]:=Tv[204]+Vl(Strings[i+1]); //20111208
        Strings[204]:=FormatFloat('##0.0000',Tv[204]); //20111208
        //Tv[204]:=Tv[204]+Vl(Strings[i+1]); //20111208
        i := i + 3;
    until i > 249;
  end; {End with}

  //pg 5 CCA table
  Tv[515]:=0;  Tv[516]:=0;  //Feb 23 2008
  Stmt:=LeftStr(FName,5);
  with ret[RetNo].Frm[Fno] do
  begin
   If PostCCaFromAssetsB(RetNo) then
   begin
    PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,301,371,10,380,381,382);  //20130408 looks ok
    Tv[515]:=Vl(Strings[515]);
    Tv[516]:=Vl(Strings[516]);
   end
   Else  //20090101
    For i:=301 to 382 do begin Strings[i]:='';Tv[i]:=0;end;

   //20140122
   i:=302;
   j:=551;
   Repeat
    Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
    Inc(i,10);
    Inc(j,1);
   until i>372;

   {cca - motor veh}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    Tv[515]:=Tv[515]+TermLossAmount;
    Tv[516]:=Tv[516]+RecaptAmount;
    For i:=383 to 424 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    For i:=515 to 517 do begin Tv[i]:=0;Strings[i]:='';end; //clear section Feb 25 2008

    Tv[423]:=0; //suppl clear
    RemainingAmount:=0;
    j:=383;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>413 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds;
         Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAForTheYear; //CCAClaimed;
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;

         //20190216Con
         Tv[i+197]:=ExtractedAutoRec.AiiPAdditions;
         Tv[i+182]:=ExtractedAutoRec.AiiPProceeds;
         Tv[i+120]:=ExtractedAutoRec.AiiPUccAdj;

         Inc(j,10);
        end;
      end;
    end;

   //20140122
   i:=384;
   j:=561;
   Repeat
    Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
    Inc(i,10);
    Inc(j,1);
   until i>414;

    Tv[423]:=RemainingAmount;
    Tv[424] := 0;
    I := 383;
    Repeat
     Tv[424] := Tv[424] + Tv[I+7];
     I := i+10;
    until i > 413;  //113;  //20110203
    Tv[424] := Tv[424] + Tv[423];
    Tv[517]:=Tv[382]+AutoCCAForStmt; //Tv[124];  //Feb 25 2008

   Tv[81]:=Tv[382]+Tv[424]; //20190120
    //non build additions
  //  If PostCCaFromAssetsB(RetNo) then   //20110204
  //  begin
     If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,425,540,5,444,545,546);
  //  end;
    I := 427; Tv[446] := 0;
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[446] := Tv[446] + Tv[I+2];
       i := i + 5;
     Until i > 442;
     Tv[446] := Tv[446] + Tv[445];

    {motor additions}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=447 to 468 do begin Tv[i]:=0;Strings[i]:='';end; //clear section

    Tv[467]:=0; //clear suppl
    RemainingAmount:=0;
    j:=447;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions >0 then
        begin
          If j>462 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[467]:=RemainingAmount;

    I := 449; Tv[468] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[468] := Tv[468] + Tv[I+2];
      i := i + 5;
    Until i > 464;
    Tv[468] := Tv[468] + Tv[467];
    Tv[469] := Tv[446] + Tv[468];

    //building additions
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,470,485,5,489,490,491);
    end;
    I := 472; Tv[491] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[491] := Tv[491] + Tv[I+2];
      i := i + 5;
    Until i > 487;
    Tv[491] := Tv[491] + Tv[490];

    //equipm dispositions other than buildings and motor veh
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,492,507,5,511,512,513);
    end;
    I := 494; Tv[513] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[513] := Tv[513] + Tv[I+2];
      i := i + 5;
    Until i > 509;
    Tv[513] := Tv[513] + Tv[512];
  end; {End with}

  //pg 5
    with ret[RetNo].Frm[Fno] do
  begin
    //disp motor vehicles
    Stmt:=LeftStr(FName,5);
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=601 to 616 do begin Tv[i]:=0;Strings[i]:='';end; //clear section

    RemainingAmount:=0;
    j:=601;  //dispositions
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired,4)<>AppYear then
        begin
         If j>611 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Proceeds - ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Proceeds;
          Tv[j+3]:=ExtractedAutoRec.ProceedsPersonal;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[616]:=RemainingAmount;

    I := 603; Tv[656] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[656] := Tv[656] + Tv[I+2];
      i := i + 5;
    Until i > 613;

    //20110406  //remove cls and descr if no bus claim
    i:=605;
    Repeat
     If Tv[i]=0 then begin Strings[i-4]:='';Strings[i-3]:='';end;
     Inc(i,5);
    until i>=615;

    Tv[656] := Tv[656] + Tv[616];
    Tv[617] := Tv[656] +Tv[513];
    // dispositions Building
    If PostCCAFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,618,633,5,637,638,639);
    end;
    {build disp }
    I := 620; Tv[639] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[639] := Tv[639] + Tv[I+2];
      i := i + 5;
    Until i > 635;
    Tv[639] := Tv[639] + Tv[638];

  end; {End with}

 //pg 6
 NumCars:=0;
 FInst := ExtractFormInst(FName);
 Stmt:='T2125'+FInst;
 FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car
 For j:=710 to 873 do begin StoreElm(RetNo,FNo,j,'');Tv[j]:=0;end; //20110226     //20110125
 //For j:=710 to 873 do StoreElm(RetNo,FNo,j,'');     //20110125
 //For j:=701 to 872 do StoreElm(RetNo,FNo,j,'');

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName='AUTOS' then
   begin
    AutosFNo:=Frec.FormNo;
    If ret[RetNo].FormHasData[Frec.FormName] then  //20191225
    //If ret[RetNo].FormHasData[GetFormName(RetNo,AutosFNo)] then
    begin
     j:=215;                            //20110125  instead of 915
     Repeat
      If (trim(FetchElmFNo(RetNo,AutosFNo,j)) = trim(Stmt)) and (Vl(FetchElmFNo(RetNo,AutosFNo,j+1))>0) then //20160428 Igor
      begin
       NumCars:=NumCars+1;
       //If NumCars=1 then
       If NumCars>=1 then  //20110226
       begin
         For jj:=710 to 830 do    //20110125
          begin
            Tv[jj]:=Tv[jj]+Vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
          end;
       end;
      end;
      Inc(j,6);  //dummy
     until j>227;                        //20110125 instead of 927;
    end;  //has data
   end; //autos
 end;  //i

  If NumCars>=1 then begin For j:=710 to 830 do StoreElm(RetNo,FNo,j,'');Tv[j]:=0;end; //20110226 //20110226
  StoreElm(RetNo,FNo,706,' ');
  j:=831;
  i:=1;
  Repeat
    ret[RetNo].Frm[FNo].Strings[j]:=SelfAutoExpRec.Descr[i];
    ret[RetNo].Frm[FNo].Strings[j+1]:=IntToStr(SelfAutoExpRec.KmDrove[i]);
    ret[RetNo].Frm[FNo].Strings[j+2]:=IntToStr(SelfAutoExpRec.KmTotal[i]);
    ret[RetNo].Frm[FNo].Strings[j+3]:=SelfAutoExpRec.Stmt[i];
    Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
    ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
    Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
    //for jj:=j+1 to J+6 do Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[JJ]);  //20110125
    //20110226  ?? needs logic here

    i:=i+1;
    j:=j+7;
  until i>6;
  If NumCars>1 then ret[RetNo].Frm[FNo].Strings[706]:='More than one automobiles claimed (Details per auto are in AUTOS forms)';

  i:=837;
  Tv[873]:=0;
  Repeat
   Tv[873]:=Tv[873]+Tv[i];
   Inc(i,7);
  until i>872;

  //----------------------
  //20171212
  i:=832;
  k:=0;
  Repeat
   k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
   Inc(i,7);
  Until i>867;
  Ret[RetNo].Frm[FNo].Strings[56]:=IntToStr(k);

  i:=833;
  k:=0;
  Repeat
   k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
   Inc(i,7);
  Until i>868;
  Ret[RetNo].Frm[FNo].Strings[57]:=IntToStr(k);

  Ret[RetNo].Frm[FNo].Strings[58]:=Ret[RetNo].Frm[FNo].Strings[56];
  Ret[RetNo].Frm[FNo].Strings[59]:=Ret[RetNo].Frm[FNo].Strings[57];
  //----------------------

  If NumCars=1 then  //20110326
   begin
              ret[RetNo].Frm[FNo].Strings[757]:=FetchElmFNo(RetNo,AutosFNo,57); //leas dt1
              ret[RetNo].Frm[FNo].Strings[760]:=FetchElmFNo(RetNo,AutosFNo,60); //leas dt2
              ret[RetNo].Frm[FNo].Strings[763]:=FetchElmFNo(RetNo,AutosFNo,63); //leas pst
              ret[RetNo].Frm[FNo].Strings[806]:=FetchElmFNo(RetNo,AutosFNo,106); //Interest days in yr
              //20140323
              ret[RetNo].Frm[FNo].Strings[731]:=FetchElmFNo(RetNo,AutosFNo,31); //descr of other exp
              ret[RetNo].Frm[FNo].Strings[735]:=FetchElmFNo(RetNo,AutosFNo,35); //descr of other exp
   end;

  //20110226 remove interest and lease
  If NumCars>1 then
  begin
   ret[RetNo].Frm[FNo].Strings[803]:='';Tv[803]:=0;
   ret[RetNo].Frm[FNo].Strings[809]:='10';Tv[809]:=10;  //20140120
   ret[RetNo].Frm[FNo].Strings[806]:='';Tv[806]:=0;
   ret[RetNo].Frm[FNo].Strings[812]:='';Tv[812]:=0;
   ret[RetNo].Frm[FNo].Strings[815]:='';TV[815]:=0;
   ret[RetNo].Frm[FNo].Strings[757]:='';Tv[757]:=0;
   ret[RetNo].Frm[FNo].Strings[760]:='';Tv[760]:=0;
   ret[RetNo].Frm[FNo].Strings[763]:='';Tv[763]:=0;
   ret[RetNo].Frm[FNo].Strings[826]:='';Tv[826]:=0;
   ret[RetNo].Frm[FNo].Strings[766]:='';Tv[766]:=0;
   ret[RetNo].Frm[FNo].Strings[769]:='';Tv[769]:=0;
   ret[RetNo].Frm[FNo].Strings[772]:='';Tv[772]:=0;
   ret[RetNo].Frm[FNo].Strings[775]:='';Tv[775]:=0;
   ret[RetNo].Frm[FNo].Strings[778]:='';Tv[778]:=0;
   ret[RetNo].Frm[FNo].Strings[781]:='';Tv[781]:=0;
   ret[RetNo].Frm[FNo].Strings[784]:='';Tv[784]:=0;
   ret[RetNo].Frm[FNo].Strings[799]:='';TV[799]:=0;
  end;

  If ret[RetNo].Frm[FNo].Strings[809]='' then
    begin ret[RetNo].Frm[FNo].Strings[809]:='10';Tv[809]:=10;end;  //20140120  Daily allowance
  If ret[RetNo].Frm[FNo].Strings[829]='' then  begin ret[RetNo].Frm[FNo].Strings[829]:='Business parking fees';end;  //20140120  Daily allowance
  If ret[RetNo].Frm[FNo].Strings[830]='' then  begin ret[RetNo].Frm[FNo].Strings[830]:='Supplementary business insurance';end;  //20140120  Daily allowance


  SaveTv(RetNo,FName,FNo);
End;

Procedure T2042(RetNo:integer;FName:string;FNo:integer);
Var i,j,k,jj,AutosFNo,NumCars :integer;x:Real;
  FInst : String[4];
  TermLossAmount,RecaptAmount,AutoCCAForStmt,CCAForStmt:Real;
  NI,MIA,OIA:Real;
  NormalLoss,AllowedLoss,RestrictedLoss,RemainingAmount:real;
  Stmt:String;
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
   //20131223
   If Strings[63]='' then Strings[63]:='0';
   If Strings[70]='' then Strings[70]:='0';
   If Vl(Strings[70])>100 then Strings[70]:='0';
   {
   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
   }

   {//20220305
   Strings[2]:=GetT3TrustName(RetNo);
   Strings[3]:='T'+GetT3AccountNumber(RetNo);
   }
   {
    //20130224
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[9] :=OptRec.Bus_Disclm
   else
     Strings[9] :='';
   }
   If Strings[4] ='' then Strings[4] := AppYear+'-01-01';
   If Strings[5] ='' then Strings[5] := AppYear+'-12-31';
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;

   If Strings[13] = '' then
   Begin
    if Uppercase(Strings[68])<>'Y' then Strings[13] := FetchElm(RetNo,'INFO',15); //20181202 //only if not T5013
   end;

   If Strings[19] = '' then Strings[19] := OptRec.Prp_Name
    +', '+OptRec.Prp_Street+','+OptRec.Prp_City+','+OptRec.Prp_Prov+','+OptRec.Prp_Postal; //20130131

   If Strings[24]='' then Strings[24]:='100.0000'; //20111108 //If TV[24] = 0 then TV[24] := 100;
   Strings[24]:=FormatFloat('##0.0000',Vl(Strings[24]));
   Tv[24]:=Vl(Strings[24]);  //20111208
   //recapt
   ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[64]:=RecaptAmount;
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[64]:=Tv[64]+RecaptAmount;
   //Tv[64]:=Tv[64]+Tv[562];   //20171119  cec?
   Tv[65] := Tv[60] + Tv[62]+Tv[64];

   x:=0;
   For i :=26 to 33 do x:=x+Tv[i];
   For i :=36 to 58 do x:=x+Tv[i];
   x:=x+Tv[65];
   If UpperCase(Strings[68]) <> 'Y' then Tv[66] :=x;
  end; {End with}

  //pg 2
   with ret[RetNo].Frm[Fno] do
 begin
   Strings[153]:='Double click for MIA Worksheet';
   Tv[101] := Tv[66];
   Tv[135]:= 0;
   //get autoexpenses
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[110]:=0;
   For i:=0 to ExtractedAutoList.count-1 do
   begin
     ExtractedAutoRec:=ExtractedAutoList.Items[i];
     If ExtractedAutoRec.PartnerFlag='' then Tv[110]:=Tv[110]+ExtractedAutoRec.ExpensesClaimed;
   end;
   For i :=102 to 128 do
     Tv[135] := Tv[135] +Tv[i];

  //Term loss
   ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[134]:=TermLossAmount;
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[134]:=Tv[134]+TermLossAmount;
   //CCA
   ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[136]:=CCAForStmt;
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[136]:=Tv[136]+AutoCCAForStmt;

   Tv[152] :=Tv[130]+Tv[132] + Tv[134];
   Tv[151] := Tv[152];
   Tv[135] :=Tv[135]+Tv[151];

   //Tv[137] := MaxR(0,Tv[559]);   //20171119 cec
   Tv[138] :=Tv[135]+Tv[136]; //+Tv[137];    //20171119 cec
   Tv[139] := Tv[138];
   Tv[140] := Tv[101] -Tv[139];
   {
   If UpperCase(Strings[154])='Y' then
   begin
    GetMIAAmount(RetNo,FName,MIA,OIA);
    Tv[141]:=OIA;
    Tv[142]:=MIA;
   end;
   }
   Tv[143] :=Tv[140]+Tv[141]+Tv[142];
   Tv[144] := Tv[143] * Tv[24]/100;
   Tv[156]:=Tv[144]+Tv[155];
   Tv[157]:=Tv[156];

   Tv[145] := Tv[613];
   Tv[146] := Tv[157] - Tv[145]; //Tv[44] - Tv[45];  //20100215
   Tv[147] := Tv[636];
   Tv[149] := Tv[146] - Tv[147];
   If (UpperCase(Strings[67]) = 'Y')
   and (Tv[149] <0) then
   {restricted farm loss}
   begin
     NormalLoss := ABS(Tv[149]);
     //20140312
     If NormalLoss>32500 then
      AllowedLoss := 17500
     else
       AllowedLoss:= MinR(NormalLoss,(2500+ MaxR(0,NormalLoss-2500)*0.50)); //20190516 Correct
     // AllowedLoss := MinR(NormalLoss,2500+ MaxR(0,(NormalLoss-2500)/2));

     RestrictedLoss := NormalLoss-AllowedLoss;
     If UpperCase(Strings[133])<>'Y' then  //20090504
        Tv[150] := RestrictedLoss;
     If UpperCase(Strings[68]) <> 'Y' then  //from t5013
      Tv[148] := Tv[149]-(-Tv[150]);
    end
    else
     begin
      Tv[150] := 0;
       If UpperCase(Strings[68]) <> 'Y' then
        Tv[148] := Tv[149];
     end;

    If UpperCase(Strings[68]) = 'Y' then
    begin
     For i:=101 to 147 do Tv[i] :=0;
     For i:=149 to 150 do Tv[i] :=0;
    end;
 end;
 //pg 3
   with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    {equip additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,201,216,5,220,221,222);
    end;
    I := 203; Tv[222] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[222] := Tv[222] + Tv[I+2]; //20110109
      i := i + 5;
    Until i > 218;
    Tv[222] := Tv[222] + Tv[221];

   {Motor veh additions}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=223 to 243 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[243]:=0; //clear suppl
    RemainingAmount:=0;
    j:=223;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions>0 then
        begin
         If j>238 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[243]:=RemainingAmount;

    I := 225; Tv[244] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[244] := Tv[244] + Tv[I+2];
      i := i + 5;
    Until i > 240;
    Tv[244] := Tv[244] + Tv[243];

    Tv[245] := Tv[222]+Tv[244];

    {build additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,246,261,5,265,266,267);
    end;
    I := 248; Tv[267] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[267] := Tv[267] + Tv[I+2];
      i := i + 5;
    Until i > 263;
    Tv[267] := Tv[267] + Tv[266];

    {equip disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,268,283,5,287,288,289);  //20110109
    end;
    I := 270; Tv[289] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[289] := Tv[289] + Tv[I+2];
      i := i + 5;
    Until i > 285;
    Tv[289] := Tv[289] + Tv[288];

    {Motor veh disp}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=290 to 310 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    RemainingAmount:=0;
    j:=290;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired,4)<>AppYear then
        begin
         If j>205 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Proceeds - ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Proceeds;
          Tv[j+3]:=ExtractedAutoRec.ProceedsPersonal;
         //20190216Con
          Tv[i+182]:=ExtractedAutoRec.AiiPAdditions;
          Tv[i+186]:=ExtractedAutoRec.AiiPProceeds;
          Tv[i+190]:=ExtractedAutoRec.AiiPUccAdj;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[310]:=RemainingAmount;

    I := 292; Tv[311] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[311] := Tv[311] + Tv[I+2];
      i := i + 5;
    Until i > 307;
    Tv[311] := Tv[311] + Tv[310];
    Tv[312] := Tv[289] + Tv[311];

    {build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,313,328,5,332,333,334);
    end;
    I := 315; Tv[334] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[334] := Tv[334] + Tv[I+2];
      i := i + 5;
    Until i > 330;
    Tv[334] := Tv[334] + Tv[333];
  end; {End with}



  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    Tv[482] := 0;
    {CCA Xi}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,401,471,10,480,481,482);
      Tv[615]:=Vl(Strings[615]);
      Tv[616]:=Vl(Strings[616]);
    end
    Else  //20090101
    begin
     for i:=401 to 482 do begin Strings[i]:='';Tv[i]:=0;end;
    end;

    {cca - motor veh}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    //20120407
    Tv[134]:=Tv[134]+TermLossAmount;
    For i:=483 to 523 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[523]:=0; //suppl clear
    RemainingAmount:=0;
    j:=483;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>513 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds; //Feb 2008
         Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAForTheYear;//ExtractedAutoRec^.CCAClaimed; //Feb 2008
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;
         Inc(j,10);
        end;
     end;
    end;
    Tv[523]:=RemainingAmount;

   Tv[524] := 0;
   I := 483;
    Repeat
     Tv[524] := Tv[524] + Tv[I+7];
     I := i+10;
    until i > 513;
    Tv[524] := Tv[524] + Tv[523];

   {CCA XVII}
    Tv[547] := 0;
    I := 528;
    Repeat
     Tv[I+2] := Tv[i] * Tv[I+1]/100;
     Tv[547] := Tv[547] + Tv[I+2];
     I := i+7;
    until i > 539;
    Tv[547] := Tv[547] + Tv[546];

    Tv[548] := Tv[482]+Tv[524]+Tv[547];
  //  Tv[617]:=Tv[548];   //used to be 217 in 2009 //20101204
  end; {End with}

  //pg 5
  with ret[RetNo].Frm[Fno] do
  begin
    If Tv[642] >0 then
      begin
      {
      Strings[640] :=GetSpouseFirstName(RetNo);
      Strings[664] :=GetSpouseLastName(RetNo);
      Strings[665] :=GetSpouseSIN(RetNo);
      Strings[643] :=GetSpouseAddress(RetNo);
      }
      end
   else
    begin Strings[657] :='';Strings[643] :='';end;

    Tv[612]:=Tv[681]+Tv[682];
    Tv[613] := Tv[606] +Tv[608]+tv[610]+Tv[673]+tv[612];   //20190111
    //20180117
    {business use of home}
    Tv[76]:=Tv[621]+Tv[623]+Tv[625];
    Tv[77]:=Tv[76];
    Tv[626] := Tv[614]+Tv[615]+Tv[616]+tv[617]+tv[618]+tv[619]+Tv[77];
    //Tv[626] := Tv[626] +Tv[621] +Tv[623]+tv[625];
    If UpperCase(Strings[676]) <> 'Y' then Tv[630]:=100;
    Tv[626]:=Tv[626]*Tv[630]/100;
    Tv[628] := (Tv[626] * Tv[627]) / 100;  {pers use}
    Tv[629] := Tv[626] - Tv[628];
    Tv[633] :=Tv[629]+Tv[677]+Tv[632]; //Tv[631] + Tv[632];
    Tv[634] := MaxR(0,Vl(FetchElm(RetNo,'T2042'+FInst,146)));
    Tv[635] := MaxR(0,Tv[633]-Tv[634]);
    Tv[636] := MaxR(0,MinR(Tv[633],Tv[634]));
  //  Tv[611]:=Tv[642]+Tv[646]+Tv[650]+Tv[654]+Tv[658]+Tv[662];  //see below
    Ni :=Vl(FetchElm(RetNo,'T2042'+FInst,143));
    i := 641;    {calc inc for partners}
    repeat
        Tv[i+1]:=Vl(Strings[i+1]);
        Strings[i+1]:=FormatFloat('##0.0000',Tv[i+1]);
        If Tv[i+1]=0 then Strings[i+1]:='';
        Tv[i] := Ni *  Tv[i+1] / 100;
        i := i + 4;
    until i > 661;
    Strings[611]:=FormatFloat('##0.0000',Vl(Strings[642])+Vl(Strings[646])+Vl(Strings[650])+Vl(Strings[654])+Vl(Strings[658])+Vl(Strings[662]));
  end; {End with}


 //pg 6
 NumCars:=0;
 FInst := ExtractFormInst(FName);
 Stmt:='T2042'+FInst;
 FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car
 For j:=710 to 873 do StoreElm(RetNo,FNo,j,'');              //20110125
 //For j:=701 to 872 do StoreElm(RetNo,FNo,j,'');

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName='AUTOS' then
   begin
    AutosFNo:=Frec.FormNo;
    If ret[RetNo].FormHasData[Frec.FormName] then
    begin
     j:=215;                            //20110125  instead of 915
     Repeat
      If (trim(FetchElmFNo(RetNo,AutosFNo,j)) = trim(Stmt)) and (Vl(FetchElmFNo(RetNo,AutosFNo,j+1))>0) then  //20160428 Igor
      begin
       NumCars:=NumCars+1;
       If NumCars=1 then
       begin
         For jj:=710 to 830 do    //20110125
          begin
            ret[RetNo].Frm[FNo].Strings[jj]:=FetchElmFNo(RetNo,AutosFNo,jj-700);
            Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[jj]);
          end;
         //For jj:=701 to 830 do StoreElm(ReTno,FNo,jj,FetchElmFNo(RetNo,AutosFNo,jj));
       end;
      end;
      Inc(j,6);  //dummy
     until j>227;                        //20110125 instead of 927;
    end;  //has data
   end; //autos
 end;  //i

  If NumCars>1 then For j:=710 to 830 do StoreElm(RetNo,FNo,j,'');
  StoreElm(RetNo,FNo,706,' ');
  j:=831;
  i:=1;
  Repeat
    ret[RetNo].Frm[FNo].Strings[j]:=SelfAutoExpRec.Descr[i];
    ret[RetNo].Frm[FNo].Strings[j+1]:=IntToStr(SelfAutoExpRec.KmDrove[i]);
    ret[RetNo].Frm[FNo].Strings[j+2]:=IntToStr(SelfAutoExpRec.KmTotal[i]);
    ret[RetNo].Frm[FNo].Strings[j+3]:=SelfAutoExpRec.Stmt[i];
    Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
    ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
    Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
    //for jj:=j+1 to J+6 do Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[JJ]);  //20110125
    i:=i+1;
    j:=j+7;
   until i>6;

    //----------------------
  //20171216
  i:=832;
  k:=0;
  Repeat
   k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
   Inc(i,7);
  Until i>867;
  Ret[RetNo].Frm[FNo].Strings[72]:=IntToStr(k);

  i:=833;
  k:=0;
  Repeat
   k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
   Inc(i,7);
  Until i>868;
  Ret[RetNo].Frm[FNo].Strings[73]:=IntToStr(k);

  Ret[RetNo].Frm[FNo].Strings[74]:=Ret[RetNo].Frm[FNo].Strings[72];
  Ret[RetNo].Frm[FNo].Strings[75]:=Ret[RetNo].Frm[FNo].Strings[73];
  //----------------------



  If NumCars>1 then ret[RetNo].Frm[FNo].Strings[706]:='More than one automobiles claimed (Details per auto are in AUTOS forms)';

  i:=837;
  Tv[873]:=0;
  Repeat
   Tv[873]:=Tv[873]+Tv[i];
   Inc(i,7);
  until i>872;

  SaveTv(RetNo,FName,FNo);
End;


Procedure T2121(RetNo:integer;FName:string;FNo:integer);
Var i,j,jj,k, AutosFNo :integer; FInst : String[4];
 TermLossAmount,RecaptAmount:Real;AutoCCAForStmt:Real;CCAForStmt, NI:Real;
  AssetsFNo: integer; Stmt:String;RemainingAmount:Real;
  NumCars:Integer;

Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
//20131223
   If Strings[86]='' then Strings[86]:='0';
   If Strings[88]='' then Strings[88]:='0';
   If Vl(Strings[88])>100 then Strings[88]:='0';
   If Strings[89]='' then Strings[89]:=ret[RetNo].Province;  //20150128
   {T1 only
   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
   }

   //20220305
  // Strings[2]:=GetT3TrustName(RetNo);
  // Strings[3]:='T'+GetT3AccountNumber(RetNo);

   {
   //20130224
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[81] :=OptRec.Bus_Disclm
   else
     Strings[81] :='';
   }
   If Strings[4] ='' then Strings[4] :=AppYear+'-01-01';
   If Strings[5] ='' then Strings[5] :=AppYear+'-12-31';
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;
   If Strings[13] = '' then Strings[13] := OptRec.Prp_Name;
   If Strings[30] = '' then Strings[30] :=
     OptRec.Prp_Street+','+OptRec.Prp_City+','+OptRec.Prp_Prov+','+OptRec.Prp_Postal;
   If Strings[19]+Strings[76] ='' then Strings[19] :='X';
   //20111208
   If Strings[18]='' then Strings[18]:='100.0000';
   Strings[18]:=FormatFloat('##0.0000',vl(Strings[18]));
   Tv[18]:=Vl(Strings[18]);
   //If TV[18] = 0 then TV[18] := 100;
   If FInst='#1' then Tv[32] :=  TotMultiple(RetNo,'T4',35);


 //Feb 24 2008
   //recapt
   ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[28]:=RecaptAmount;
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[28]:=Tv[28]+RecaptAmount;
  //Term loss
   ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[60]:=TermLossAmount;
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[60]:=Tv[60]+TermLossAmount;
   //CCA
   ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[65]:=CCAForStmt;
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[65]:=Tv[65]+AutoCCAForStmt;

   //Tv[66] := Tv[532]; //20171119 cec
   //If Tv[66] =0 then Tv[66] :=-Tv[536];  {inc inclusion}
   {
   If Tv[66]<0 then
   begin
    Tv[28]:=Tv[28]+Abs(Tv[66]);
    Tv[66]:=0;
   end;
   }
   If UpperCase(Strings[27]) <> 'Y' then
     Tv[35] :=AddColumns(20,24,1)+Tv[26]+Tv[28]+Tv[32]+Tv[34];
   Tv[77]:=Tv[35];
   //get autoexpenses
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[44]:=0;
   For i:=0 to ExtractedAutoList.count-1 do
   begin
     ExtractedAutoRec:=ExtractedAutoList.Items[i];
     If ExtractedAutoRec.PartnerFlag='' then Tv[44]:=Tv[44]+ExtractedAutoRec.ExpensesClaimed;
   end;
   If UpperCase(Strings[79])='Y' then Tv[44]:=Tv[80];

   Tv[52] := Tv[49]+Tv[50]+Tv[51];
   Tv[54] := Tv[52] - Tv[53];
   Tv[55] := Tv[54];

   Tv[64] := 0;
   For i :=36 to 48 do Tv[64] := Tv[64] +Tv[i];
   Tv[63] := Tv[57]+Tv[59]+Tv[60];
   Tv[64] := Tv[64] + Tv[55]+Tv[63];
   Tv[67] := Tv[64] + Tv[65];  //+Tv[66];  //20171119
   Tv[68] := Tv[67];
   Tv[69] := Tv[77] - Tv[68]; //Tv[35] - Tv[68];
   Tv[70] := Tv[69] * Tv[18] /100;
   Tv[78] := Tv[70]+Tv[10];
   Tv[62] := Tv[78]; //Tv[70]+Tv[10];  //20120130
   Tv[71] := Tv[109];
   Tv[72] := Tv[62]-Tv[71]; //Tv[70] - Tv[71];     //20100220
   Tv[73] := Tv[132];

   If UpperCase(Strings[27]) = 'Y' then  //20091229
   begin
     For i :=36 to 48 do Tv[i]:=0;
     Tv[57]:=0;
     Tv[59]:=0;
     For i :=63 to 73 do Tv[i]:=0;
   end;
   If UpperCase(Strings[27]) <> 'Y' then Tv[74] := Tv[72] - Tv[73];
  end; {End with}
  //pg 2 NOT FULLY CONVERTED??????

//??  Tv[215]:=0;  Tv[216]:=0;  //Feb 23 2008
  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    {amounts deductible}
    //get autoexpenses
    ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
//??    Tv[215]:=Tv[215]+TermLossAmount;
//??    Tv[216]:=Tv[216]+RecaptAmount;

    Tv[108]:=Tv[281]+Tv[282];
    Tv[109] := Tv[102] +Tv[104]+tv[106]+Tv[108]+Tv[98]; //201171213

  {business use of home}
    //20180117
    Tv[99]:=Tv[117]+Tv[119]+Tv[121];
    Tv[100]:=Tv[99];
    Tv[107]:=Tv[110] +Tv[111]+tv[112]+tv[113]+tv[114]+Tv[115]+Tv[100];
    If UpperCase(Strings[278]) <> 'Y' then Tv[126] :=100;
    Tv[107] := (Tv[107] * Tv[126]) / 100;  {alloca}

    Tv[124]:=Tv[107]*Tv[123]/100;
    Tv[122]:=MaxR(0,Tv[107]-Tv[124]);
    Tv[280]:=Tv[279];
    Tv[125]:=Tv[122]+Tv[280]+Tv[128];

    Tv[129]:=Tv[122]+Tv[280]+Tv[128]; //Tv[127];
    Tv[130] :=MaxR(0,Tv[72]);
    Tv[131] := MaxR(0, Tv[129]-Tv[130]);
    Tv[132] := MinR(Tv[129],Tv[130]);

    Tv[218] := 0;
    If PostCCaFromAssetsB(RetNo) then
    Begin
      PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,137,207,10,216,217,218);
      Tv[315]:=Vl(Strings[315]);
      Tv[316]:=Vl(Strings[316]);
    end
    else //20090101
    begin
     For i:=137 to 207 do begin Strings[i]:='';Tv[i]:=0;end;
    end;

    Tv[218] := Tv[218] + Tv[217];


    {cca - motor veh}
   //get autoexpenses
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=219 to 259 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[259]:=0; //suppl clear
    RemainingAmount:=0;
    j:=219;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>249 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds; //feb 2008
         Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAForTheYear; //ExtractedAutoRec^.CCAClaimed; //Feb 2008
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;

         //20190216Con
          Tv[i+443]:=ExtractedAutoRec.AiiPAdditions;
          Tv[i+447]:=ExtractedAutoRec.AiiPProceeds;
          Tv[i+451]:=ExtractedAutoRec.AiiPUccAdj;
         Inc(j,10);
        end;
     end;
    end;
    Tv[259]:=RemainingAmount;

   {cca - motor veh}
   Tv[260] := 0;
   I := 219;
    Repeat
     Tv[260] := Tv[260] + Tv[I+7];
     I := i+10;
    until i > 249;
    Tv[260] := Tv[260] + Tv[259];

    Tv[277] := Tv[218]+ Tv[260];
    Tv[317]:=Tv[277];
  end; {End with}


  //pg 3
  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    If PostCCaFromAssetsB(RetNo) then
    begin
     If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,301,316,5,320,321,322);
    end;
    {equip additions}
    I := 303; Tv[322] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[322] := Tv[322] + Tv[I+2];
      i := i + 5;
    Until i > 318;
    Tv[322] := Tv[322] + Tv[321];

    {motor additions}
    //get autoexpenses
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=323 to 343 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[343]:=0; //clear suppl
    RemainingAmount:=0;
    j:=323;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions>0 then
        begin
         If j>338 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[343]:=RemainingAmount;

    {motor}
    I := 325; Tv[344] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[344] := Tv[344] + Tv[I+2];
      i := i + 5;
    Until i > 340;
    Tv[344] := Tv[344] + Tv[343];
    Tv[345] := Tv[322] +Tv[344];

    //20140122
    i:=138;
    j:=90;
    Repeat
     Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
     Inc(i,10);
     Inc(j,1);
    until i>208;

    //20140122
    i:=220;
    j:=261;
    Repeat
     Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
     Inc(i,10);
     Inc(j,1);
    until i>264;

    {build additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,346,361,5,365,366,367);
    end;
    I := 348; Tv[367] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[367] := Tv[367] + Tv[I+2];
      i := i + 5;
    Until i > 363;
    Tv[367] := Tv[367] + Tv[366];



    {non build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,368,383,5,337,338,339);
    end;
    I := 370; Tv[389] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[389] := Tv[389] + Tv[I+2];
      i := i + 5;
    Until i > 385;
    Tv[389] := Tv[389] + Tv[388];

    {motor disp }
    //get autoexpenses
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=390 to 410 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[411]:=0;   //20130205
    RemainingAmount:=0;
    j:=390;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired,4)<>AppYear then
        begin
         If j>405 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Proceeds - ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Proceeds;
          Tv[j+3]:=ExtractedAutoRec.ProceedsPersonal;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[410]:=RemainingAmount;

    I := 392; Tv[311] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[411] := Tv[411] + Tv[I+2];
      i := i + 5;
    Until i > 407;
    Tv[411] := Tv[411] + Tv[410];
    Tv[412] := Tv[389] + Tv[411];

    {build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostnonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,413,428,5,432,433,434);
    end;
    I := 415; Tv[434] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[434] := Tv[434] + Tv[I+2];
      i := i + 5;
    Until i > 430;
    Tv[434] := Tv[434] + Tv[433];
  end; {End with}

  //pg 4
    with ret[RetNo].Frm[Fno] do
  begin
    If Tv[505] >0 then
     begin
      {
      Strings[503]  :=GetSpouseFirstName(RetNo);
      Strings[537] :=GetSpouseLastName(RetNo);
      Strings[538] :=GetSpouseSIN(RetNo);
      Strings[506]  :=GetSpouseAddress(RetNo);
      }
     end
     else
      begin Strings[503] :='';Strings[506] :='';end;

   // Tv[547]:=Tv[505]+Tv[509]+Tv[513]+Tv[517]+Tv[521];  //see below
    Ni := Tv[69];
    i := 504;    {calc inc for partners}
    repeat
        Strings[i+1]:=FormatFloat('##0.0000',Vl(Strings[i+1]));
        Tv[i+1]:=Vl(Strings[i+1]);
        If Tv[i+1]=0 then Strings[i+1]:='';
        Tv[i] := Ni  *  Tv[i+1] / 100;
        i := i + 4;
    until i > 520;
    Strings[547]:=FormatFloat('##0.0000',Vl(Strings[505])+Vl(Strings[509])+Vl(Strings[513])+Vl(Strings[517])+Vl(Strings[521]));  //20120227
    // Tv[547]:=Tv[505]+Tv[509]+Tv[513]+Tv[517]+Tv[521];  //20111208
   // Strings[547]:=FormatFloat('##0.0000',Tv[547]);


  end;

 //pg 5
 NumCars:=0;
 FInst := ExtractFormInst(FName);
 Stmt:='T2121'+FInst;
 FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car
 For j:=610 to 773 do StoreElm(RetNo,FNo,j,'');              //20110125
 //For j:=701 to 872 do StoreElm(RetNo,FNo,j,'');

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName='AUTOS' then
   begin
    AutosFNo:=Frec.FormNo;
    If ret[RetNo].FormHasData[Frec.FormName] then
    begin
     j:=215;                   //20110125  instead of 915
     Repeat
      If (trim(FetchElmFNo(RetNo,AutosFNo,j)) = trim(Stmt)) and (Vl(FetchElmFNo(RetNo,AutosFNo,j+1))>0) then //20160428 Igor
      begin
       NumCars:=NumCars+1;
       If NumCars=1 then
       begin
         For jj:=610 to 730 do    //20110125
          begin
            ret[RetNo].Frm[FNo].Strings[jj]:=FetchElmFNo(RetNo,AutosFNo,jj-600);
            Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[jj]);
          end;
         //For jj:=701 to 830 do StoreElm(ReTno,FNo,jj,FetchElmFNo(RetNo,AutosFNo,jj));
       end;
      end;
      Inc(j,6);  //dummy
     until j>227;                        //20110125 instead of 927;
    end;  //has data
   end; //autos
 end;  //i

  If NumCars>1 then For j:=610 to 730 do StoreElm(RetNo,FNo,j,'');
  StoreElm(RetNo,FNo,606,' ');
  j:=731;
  i:=1;
  Repeat
    ret[RetNo].Frm[FNo].Strings[j]:=SelfAutoExpRec.Descr[i];
    ret[RetNo].Frm[FNo].Strings[j+1]:=IntToStr(SelfAutoExpRec.KmDrove[i]);
    ret[RetNo].Frm[FNo].Strings[j+2]:=IntToStr(SelfAutoExpRec.KmTotal[i]);
    ret[RetNo].Frm[FNo].Strings[j+3]:=SelfAutoExpRec.Stmt[i];
    Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
    ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
    Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
    //for jj:=j+1 to J+6 do Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[JJ]);  //20110125
    i:=i+1;
    j:=j+7;
   until i>6;

     //----------------------
  //20171213
  i:=732;
  k:=0;
  Repeat
   k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
   Inc(i,7);
  Until i>767;
  Ret[RetNo].Frm[FNo].Strings[267]:=IntToStr(k);

  i:=733;
  k:=0;
  Repeat
   k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
   Inc(i,7);
  Until i>768;
  Ret[RetNo].Frm[FNo].Strings[268]:=IntToStr(k);

  Ret[RetNo].Frm[FNo].Strings[265]:=Ret[RetNo].Frm[FNo].Strings[267];
  Ret[RetNo].Frm[FNo].Strings[266]:=Ret[RetNo].Frm[FNo].Strings[268];
  //----------------------



  If NumCars>1 then ret[RetNo].Frm[FNo].Strings[606]:='More than one automobiles claimed (Details per auto are in AUTOS forms)';

  i:=737;
  Tv[773]:=0;
  Repeat
   Tv[773]:=Tv[773]+Tv[i];
   Inc(i,7);
  until i>772;
  If ret[RetNo].Frm[FNo].Strings[709]='' then  begin ret[RetNo].Frm[FNo].Strings[709]:='10';Tv[709]:=10;end;  //20140120  Daily allowance
  If ret[RetNo].Frm[FNo].Strings[729]='' then  begin ret[RetNo].Frm[FNo].Strings[729]:='Business parking fees';end;  //20140120  Daily allowance
  If ret[RetNo].Frm[FNo].Strings[730]='' then  begin ret[RetNo].Frm[FNo].Strings[730]:='Supplementary business insurance';end;  //20140120  Daily allowance
  SaveTv(RetNo,FName,FNo);
  UpdateThisFormDataIndicator(RetNo,FName);
End;

procedure T776(RetNo: integer; FName: String;FNo: integer);
Var i,j,Pg2FNo:integer; TotPercent,x : real;
   FInst : String[4]; Stmt:String;
   TermLossAmount,RecaptAmount:Real;AutoCCAForStmt,CCAForStmt:Real;
   ClaimIt:Boolean;
   Cls: string[4];Rate:String[4];
  AssetsFNo:Integer;RemainingAmount,Dummy:Real;MaxCCA:Real;

begin
  FInst := ExtractFormInst(FName);
 // Pg2FNo:=GetFormNo('T776'+FInst);
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
    {t1 only
    Strings[1] :=Rtrim(FetchElm(RetNo,'INFO',2))+
          ' '+ FetchElm(RetNo,'INFO',5);
    Strings[2] := FetchElm(RetNo,'INFO',3);
    }
    //20220309
    //Strings[1] := FetchElm(RetNo,'T3',1);  //t3 name
    //Strings[2]:='T'+GetT3AccountNumber(RetNo);

    If strings[3] = '' then strings[3] :=AppYear+'-01-01';
    If strings[6] = '' then strings[6] := AppYear+'-12-31';
    If strings[9]+Strings[10] = '' then Strings[10] := 'X';
    If strings[4]+Strings[5] = '' then Strings[4] := 'X';
    Strings[12] := OptRec.Prp_Name;

    //20170310
    Strings[14] := OptRec.Prp_Street;
    Strings[16] := OptRec.Prp_City;
    Strings[17] := OptRec.Prp_Prov;
    Strings[118] := OptRec.Prp_Postal;

    {
    Strings[14] := OptRec.Prp_Street+', '+OptRec.Prp_City
      + ', '+OptRec.Prp_Prov + ', '+ OptRec.Prp_Postal;
    }
   // If Strings[110] >'' then
    //20190109
    If UpperCase(Strings[145]) ='Y' then    //20120213
    begin
      Strings[109]:=GetFirstName(RetNo)+ ' '+GetLastName(RetNo);
    End;
    If Strings[110]='' then Strings[110]:=FetchElm(RetNo,'INFO',6)+' '+FetchElm(RetNo,'INFO',22)
        +' '+FetchElm(RetNo,'INFO',68)+' '+FetchElm(RetNo,'INFO',63); //str / rural
    If Strings[112]='' then  Strings[112]:=FetchElm(RetNo,'INFO',10); //city
    If Strings[120]='' then  Strings[120]:=FetchElm(RetNo,'INFO',14); //Prov
    If Strings[111]='' then  Strings[111]:=FetchElm(RetNo,'INFO',15); //Postal



    If Strings[18] ='' then Strings[18]:='100.0000'; //Tv[18] :=100; 20111208
    Strings[18]:=FormatFloat('##0.0000',Vl(Strings[18]));  //20111208
    //If (Tv[18] < 0) or (Tv[18] >100) then Tv[18] := 100;

    Strings[19] := '531111'; {sic}

    If Strings[138]='' then Strings[138]:='N';

    If UpperCase(Strings[141]) <> 'Y' then Strings[114]:=Strings[18]; //Tv[114]:=Tv[18];  //20111208

   // If Tv[114]>100 then Tv[114]:=100;
    If Vl(Strings[114])>100 then Strings[114]:='100.0000'; //Tv[18] :=100; 20111208
    Strings[114]:=FormatFloat('##0.0000',Vl(Strings[114]));  //20111208
    Tv[114]:=Vl(Strings[114]);  //20111209

    If Strings[115]='' then Strings[115]:='100.0000'; //20111208
    // If Strings[115]='' then Tv[115] := 100;
    If Vl(Strings[115])>100 then Strings[115]:='100.0000'; //20111208
    //If (Tv[115] >100) then Tv[115] :=100;
    Strings[115]:=FormatFloat('##0.0000',Vl(Strings[115]));  //20111208
    Tv[115]:=Vl(Strings[115]);  //20111209
    Tv[24]:=Vl(Strings[24]); //20111208
    If vl(Strings[24])>0  then //Tv[24] >0 then //20111208
    begin
    {
    Strings[22] :=GetSpouseFirstName(RetNo);
    Strings[117]:=GetSpouseLastName(RetNo);
    Strings[119]:=LeftStr(GetSpouseAddress(RetNo),33);
    }
    end
   else
    Strings[22] :='';
  {Partners}
   i:=24;
   repeat
    Tv[i]:=Vl(Strings[i]);
    If (Tv[i] <0) or (Tv[i] >100) then begin Tv[i] :=0;Strings[i]:='';end;
    Inc(i,4);
   until i>44;
   //sins
   i:=118;
   repeat
    Strings[i]:=RemoveChar(Strings[i],' ');
    Strings[i]:=RemoveChar(Strings[i],'-');
    Inc(i,2);
   until i>128;

   //get autoexpenses
   If UpperCase(Strings[142]) <>'Y' then
   begin
    ExtractAutos(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    Tv[72]:=0;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then Tv[72]:=Tv[72]+ExtractedAutoRec.ExpensesClaimed;
    end;
   end;

   i:=58;
   repeat
    If (UpperCase(Strings[140])='Y') and (Tv[139] >0) and (Tv[i-1]>0) then Tv[i]:=Tv[139];
    If (Tv[i] <0) or (Tv[i] >100) then Tv[i] :=0;
    Inc(i,3);
   until i>91;
   If (UpperCase(Strings[140])='Y') and (Tv[139] >0) and (Tv[130]>0) then Tv[95]:=Tv[139];
   If (Tv[95] <0) or (Tv[95] >100) then Tv[95] :=0;

   Tv[143]:=Tv[24]+Tv[28]+Tv[32]+Tv[36]+Tv[40]+Tv[44];
   Strings[143]:=FormatFloat('##0.0000',Tv[143]);  //20111208
   i := 23;
    Repeat
     Strings[i+1]:=FormatFloat('##0.0000',Vl(Strings[i+1])); //20111208
     Tv[i+1]:=Vl(Strings[i+1]);
     If Tv[i+1]=0 then Strings[i+1]:='';
     Tv[i] := (Tv[103] * Tv[i +1]) / 100;
     i := i + 4;
    until i > 43;

    {Calc Income}
    If UpperCase(Strings[113]) <> 'Y' then
      begin
       Tv[116] := Tv[47]+Tv[50]+Tv[53];
       Tv[56] := Tv[116]+Tv[55];
      end;
    {Calc Expenses}
    Tv[97] :=0; Tv[99] :=0;
    {Horizontal}
    i := 57;
    Repeat
     Tv[i+2] := (Tv[i] * Tv[i+1]) / 100;
     I := i+3;
    until i > 90;
    Tv[96] := (Tv[130] * Tv[95]) / 100;
    Tv[135] := (Tv[131] * Tv[134]) / 100;
    Tv[137] := (Tv[133] * Tv[136]) / 100;
    Tv[94]:=Tv[130]+Tv[131]+Tv[133];
    {Vertical}
    i := 57;
    Repeat
     Tv[97] := Tv[97] + Tv[i];
     Tv[99] := Tv[99] + Tv[i+2];
     i := i+3;
    until i > 90;
    Tv[97]  := Tv[97] + Tv[94];
    Tv[99]  := Tv[99]+ Tv[96]+Tv[135]+Tv[137];
    If UpperCase(Strings[113]) <> 'Y' then
    begin
    Tv[102] := Tv[97]-Tv[99];
    Tv[103] := Tv[56] - Tv[102];
    Tv[104] := (Tv[103] * Vl(Strings[18]))/100;//(Tv[103] * Tv[18]) / 100;
    Tv[8] := Tv[104] - Tv[7];
    Tv[21] := Tv[8] + Tv[20];
    Tv[100] := Tv[21] - Tv[98];

    //recapt
    ExtractCCA(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
    Tv[20]:=RecaptAmount;
    ExtractAutos(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    Tv[20]:=Tv[20]+RecaptAmount;
    Tv[20]:=Tv[20] * Tv[114] / 100;  //Apr 4 2008
    //Term loss
    ExtractCCA(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
    Tv[98]:=TermLossAmount;
    ExtractAutos(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    Tv[98]:=Tv[98]+TermLossAmount;
    Tv[98]:=Tv[98] * Tv[114] / 100;
    //CCA
    ExtractCCA(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
    Tv[105]:=CCAForStmt;
    ExtractAutos(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    Tv[105]:=Tv[105]+AutoCCAForStmt;
    Tv[105]:=Tv[105]* Tv[114] / 100;
    Tv[101] := Tv[100]-Tv[105];
    Tv[107] := Tv[101] * Tv[115] /100;
    Tv[106] := Tv[107] +Tv[144] - Tv[108];    //20100128
    end;
  end; {End with}

 //pg 2
   ret[RetNo].Frm[Fno].Strings[359]:='';Tv[359]:=0; //term loss  Feb 23 2008
  ret[RetNo].Frm[Fno].Strings[383]:='';Tv[383]:=0;  //recapture Feb 23 2008;
  with ret[RetNo].Frm[Fno] do
  begin
    Strings[367]:=FInst + ' - '+ FetchElm(RetNo,'T776'+FInst,45);
    Stmt:=LeftStr(FName,4);
  {CCA}
     Tv[265] := 0;  //total cca
    {cca - nonmotor veh}
    If PostCCaFromAssetsB(RetNo) then
    begin
      PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,201,237,9,245,264,265);
      Tv[359]:=0;
      Tv[383]:=0;
    end
    else  //20090101
    begin
     For i:=201 to 245 do begin Strings[i]:='';Tv[i]:=0;end;
     For i:=360 to 364 do begin Strings[i]:='';Tv[i]:=0;end;
     Tv[264]:=0;
     Tv[381]:=0;
    end;
    Tv[381]:=0;
    Tv[381]:=Tv[208]+Tv[217]+Tv[226]+Tv[235]+Tv[244]+Tv[264];
    //CCA Motor vehicle
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);

    For i:=246 to 254 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    For i:=255 to 263 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[380]:=0; //suppl clear
    RemainingAmount:=0;
    j:=246;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>255 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds;  // feb 2008
         Tv[j+4]:=ExtractedAutoRec.UCCAfter; //20190217    // Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAClaimed;
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;
         //20190216Con
          Tv[i+168]:=ExtractedAutoRec.AiiPAdditions;
          Tv[i+170]:=ExtractedAutoRec.AiiPProceeds;
          Tv[i+172]:=ExtractedAutoRec.AiiPUccAdj;
         Inc(j,9); //dummy
        end;
     end;
    end;
    Tv[380]:=RemainingAmount;
    Tv[382]:=0;
    Tv[382]:=Tv[253]+tv[262]+Tv[380];

    Tv[265] := Tv[381]+Tv[382];


   //20140122
   i:=202;
   j:=146;
   Repeat
    Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
    Inc(i,9);
    Inc(j,1);
   until i>238;

   //20140122
   i:=247;
   j:=151;
   Repeat
    Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
    Inc(i,9);
    Inc(j,1);
   until i>256;


    {equip additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,267,277,5,281,368,288);
    end;
    I := 269; Tv[288] := 0;
    Repeat
      Tv[I+2] := MaxR(0,Tv[I] - Tv[I+1]);
      Tv[288] := Tv[288] + Tv[I+2];
      i := i + 5;
    Until i > 279;
    //AUTO additions
    {motor additions}
    //get autoexpenses
    Stmt:=LeftStr(FName,4);
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=282 to 286 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    For i:=369 to 373 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[287]:=0; //clear suppl
    RemainingAmount:=0;

    j:=282;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions>0 then
        begin
         If j>369 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.Cost * ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Tv[j+4]:=MaxR(0,Tv[j+2] - Tv[j+3]);
          Inc(j,87);
         end;
        end;
     end;
    end;
    Tv[287]:=RemainingAmount;

    Tv[288] := Tv[288] + Tv[368]+Tv[373]+Tv[287];

    {build additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,289,304,5,308,309,310);
    end;
    I := 291; Tv[310] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[310] := Tv[310] + Tv[I+2];
      i := i + 5;
    Until i > 306;
    Tv[310] := Tv[310] + Tv[309];

    {equip disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,311,321,5,325,374,382);
    end;
    I := 313; Tv[332] := 0;
    Repeat
      Tv[I+2] := MaxR(0,Tv[I] - Tv[I+1]);
      Tv[332] := Tv[332] + Tv[I+2];//Tv[132] := Tv[132] + Tv[I+2];   //20110109
      i := i + 5;
    Until i > 323; //128

    //motor disp
    //get autoexpenses
    Stmt:=LeftStr(FName,4);
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=326 to 330 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    For i:=375 to 379 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    RemainingAmount:=0;
    j:=326;  //dispositions
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired,4)<>AppYear then
        begin
         If j>375 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Proceeds - ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Proceeds;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[331]:=RemainingAmount;
    Tv[330]:=MaxR(0,Tv[328]-Tv[329]);
    Tv[379]:=MaxR(0,Tv[377]-Tv[378]);
    Tv[332] := Tv[332] + Tv[379]+Tv[374]+Tv[331];

    {build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,333,348,5,352,353,354);
    end;
    I := 335; Tv[354] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[354] := Tv[354] + Tv[I+2];
      i := i + 5;
    Until i > 350;
    Tv[354] := Tv[354] + Tv[353];
   {
   //20130306
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[390] :=OptRec.Bus_Disclm
   else
     Strings[390] :='';
   }
  end; {End with}

  SaveTv(RetNo,FName,FNo);

end;
*)

//20220417  from t1
procedure T2043(RetNo: integer; FName: String;FNo: integer);  //20230106
  Var i:Integer;OverrideSw:Boolean;
Begin
 //20220220
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
  begin
   if Strings[3]='' Then Strings[3]:='Y';  //20230225
   if UpperCase(Strings[3])='Y'  then OverrideSw:=True else OverrideSw:=False;

   if OverrideSw=false then
   Begin
    Tv[2]:=TotMultiple(RetNo,'T2043A',6); //ON total all xxExp

   if Tv[2]<25000 then
   Begin
    for I:=2 to 31 do Begin Tv[i]:=0;end;
    SaveTv(RetNo, FName, FNo);
    Exit;
   End;

    if Strings[1]='' then  //20220428
    Begin
     if Ret[RetNo].Province='ON' then Tv[4]:=Tv[2] else Tv[4]:=0;
     if Ret[RetNo].Province='MB' then Tv[6]:=Tv[2] else Tv[6]:=0;
     if Ret[RetNo].Province='SK' then Tv[8]:=Tv[2] else Tv[8]:=0;
     if Ret[RetNo].Province='AB' then Tv[9]:=Tv[2] else Tv[9]:=0;
    end;
   end;

   Tv[5]:=(Tv[4] *0.173)/100;
   Tv[7]:=(Tv[6] *0.173)/100;
   Tv[10]:=(Tv[8] *0.173)/100;
   Tv[11]:=(Tv[9] *0.173)/100;
   Tv[12]:=Tv[5]+Tv[7]+Tv[10]+Tv[11];

   if OverrideSw=false then
   Begin
    if UpperCase(Strings[1])='X' then  //multiple
    Begin
     //No part 2
      for i:=4 to 12 do Tv[i]:=0;
     //------Part 3 -----------------
     Tv[13]:=TotMultiple(RetNo,'T2043A',7);  //on
     Tv[14]:=TotMultiple(RetNo,'T2043A',16);  //mb
     Tv[15]:=TotMultiple(RetNo,'T2043A',25);  //sk
     Tv[16]:=TotMultiple(RetNo,'T2043A',34);  //AB
    end;

    if Strings[1]='' then  //20220428
    Begin
     For i:=14 to 22 do begin Tv[i]:=0;end; //no part 3
    end;
   End;  //override

   //Part 3
   if OverrideSw=false then
   Begin
    Tv[17]:=TotMultiple(RetNo,'T2043A',10);  //on
    Tv[18]:=TotMultiple(RetNo,'T2043A',19);  //mb
    Tv[19]:=TotMultiple(RetNo,'T2043A',28);  //sk
    Tv[20]:=TotMultiple(RetNo,'T2043A',37);  //ab
    Tv[21]:=TotMultiple(RetNo,'T2043A',8);  //any colmn TotGInc
    Tv[22]:=TotMultiple(RetNo,'T2043A',11);  //any column TotSal

    if UpperCase(Strings[1])='X' then  //multiple
    Begin
     Tv[23]:=TotMultiple(RetNo,'T2043A',44);  //on
     Tv[24]:=TotMultiple(RetNo,'T2043A',46);  //mb
     Tv[25]:=TotMultiple(RetNo,'T2043A',48);  //SK
     Tv[26]:=TotMultiple(RetNo,'T2043A',50);  //ab
    end
    Else
    Begin
      For i:=14 to 22 do begin Tv[i]:=0;end; //no part 3 unless multiple
    End;
   end;

   Tv[27]:=Tv[23]+Tv[24]+Tv[25]+Tv[26];
   Tv[28]:=Tv[12];
   Tv[29]:=Tv[27];

   Tv[36]:=Tv[32]+Tv[33]+Tv[34]+Tv[35];
   Tv[37]:=Tv[36];
   Tv[38]:=Tv[28]+Tv[29]+Tv[37];

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20220424
procedure T2043A(RetNo: integer; FName: String;FNo: integer);  //20230106
 Var i:Integer;x:Real;FInst:String;T2203FNo:Integer;
   FarmFName:String;FarmFNo:Integer;  //20220423
   Totexp:Real; TotMInv:Real; TotOInv:Real; TotGInc:Real;
   TotSal:Real;

Begin
 If FNo=0 then exit;
 T2203FNo:=GetFormNo('T2203');  //20220416
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);

 with ret[RetNo].Frm[Fno] do
 Begin
   FarmFName:=AllTrim(LeftStr(Alltrim(Strings[69]),8));
   FarmFNo:=GetFormNo(FarmFName);
   if FarmFNo=0 then exit;   //20220424

   if Vl(FetchElm(RetNo,'T2043',2))<25000 then  //20220614
   Begin
    for i:=1 to 95 do begin Tv[i]:=0; end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   End;
 end;
 GetT2030ACharts(RetNo,FarmFname,FarmFNo,Totexp,TotMInv,TotOInv,TotGInc,TotSal);

 with ret[RetNo].Frm[Fno] do
 Begin
   //ChartA
  //20220417
  Tv[1]:=TotExp;
  Tv[2]:=TotMInv;
  Tv[3]:=TotOInv;
  Tv[5]:=Tv[2]+Tv[3]+Tv[4];
  Tv[6]:=MaxR(0,Tv[1]-Tv[5]);  //20220417

  Tv[88]:=TotGInc;
  Tv[91]:=TotSal;
  Tv[90]:=TotSal;


  Tv[8]:=TotGInc;
  Tv[17]:=TotGInc;
  Tv[26]:=TotGInc;
  Tv[35]:=TotGInc;

  Tv[11]:=TotSal;
  Tv[20]:=TotSal;
  Tv[29]:=TotSal;
  Tv[38]:=TotSal;

  //Gross inc  minus credit
  Tv[87]:=MaxR(0,TotGInc - Tv[7]-Tv[16]-Tv[25]-Tv[34]); //tot groos all farming
  Tv[90]:=MaxR(0,TotSal - Tv[8]-Tv[17]-Tv[26]-Tv[35]-Tv[34]); //tot groos all farming

  //RAW 3
  if Tv[8]>0 then Tv[9]:=(Tv[7]/Tv[8])*100 else Tv[9]:=0; //on
  if Tv[17]>0 then Tv[18]:=(Tv[16]/Tv[17])*100 else Tv[18]:=0; //mb
  if Tv[26]>0 then Tv[27]:=(Tv[25]/Tv[26])*100 else Tv[27]:=0; //sk
  if Tv[35]>0 then Tv[36]:=(Tv[34]/Tv[35])*100 else Tv[36]:=0; //ab

  if UpperCase(Strings[57])<>'Y' then  //get salaties
  Begin
  End;

  //RAW 5 Salaries  do for each prov //20220416
  if FetchElm(RetNo,'T2043',1) =''  then  //NON MULT  //20220428
  Begin
   if UpperCase(Strings[57])<>'Y' then
   Begin
    TotSal:=TotMultiple(RetNo,'T2042',115)
          +TotMultiple(RetNo,'T1163',526)
          +TotMultiple(RetNo,'T1273',526);
    Tv[11]:=TotSal;
    Tv[20]:=TotSal;
    Tv[29]:=TotSal;
    Tv[38]:=TotSal;
   end;
  End;

  //RAW 6, 7 , 8 , 9
  //ON
  if Tv[11]>0 then Tv[12]:=(Tv[10]/Tv[11])*100 else Tv[12]:=0;
  Tv[13]:=Tv[9]+Tv[12];
  Tv[14]:=Tv[13]*50/100;
  if (Tv[8]=0) or (Tv[11]=0) then Tv[14]:=Tv[13]; //*50/100;
  Tv[15]:=Tv[14]*Tv[6]/100;   //20220416

  //MB
  if Tv[20]>0 then Tv[21]:=(Tv[19]/Tv[20])*100 else Tv[21]:=0;
  Tv[22]:=Tv[18]+Tv[21];
  Tv[23]:=Tv[22]*50/100;
  if (Tv[17]=0) or (Tv[20]=0) then Tv[24]:=Tv[23];
  Tv[24]:=Tv[23]*Tv[6]/100;
  //SK
  if Tv[29]>0 then Tv[30]:=(Tv[28]/Tv[29])*100 else Tv[29]:=0;
  Tv[31]:=Tv[27]+Tv[30];
  Tv[32]:=Tv[31]*50/100;
  if (Tv[26]=0) or (Tv[29]=0) then Tv[32]:=Tv[31];
  Tv[33]:=Tv[32]*Tv[6]/100;
  //AB
  if Tv[38]>0 then Tv[39]:=(Tv[37]/Tv[38])*100 else Tv[39]:=0;
  Tv[40]:=Tv[36]+Tv[39];
  Tv[41]:=Tv[40]*50/100;
  if (Tv[35]=0) or (Tv[38]=0) then Tv[41]:=Tv[40];
  Tv[42]:=Tv[41]*Tv[6]/100;

  //CHART C
  for i:=44 to 49 do begin Tv[i]:=0;end; //initialize

  Tv[43]:=Tv[15]; Tv[44]:=Tv[43]*0.147/100;
  Tv[45]:=Tv[24]; Tv[46]:=Tv[45]*0.147/100;
  Tv[47]:=Tv[33]; Tv[48]:=Tv[47]*0.147/100;
  Tv[49]:=Tv[42]; Tv[50]:=Tv[49]*0.147/100;
 End;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2125(RetNo:integer;FName:string;FNo:integer);
Var i,j,jj,k,NumCars,AutosFNo :integer;
  FInst,Stmt:String;  //[5];  //20110125
  TermLossAmount,RecaptAmount:Real;AutoCCAForStmt:Real;
  CCAForStmt:Real;
  RemainingAmount:Real;MaxCCA:Real;
  T4AFNo,T1204FNo:Integer;

Begin
 If FNo=0 then exit;
// T4AFNo:=GetFormNo('T4A#1');  //t1 only
 T1204FNo:=GetFormNo('T1204#1');

 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
    //20230225
   Strings[2] := FetchElm(RetNo, 'T3', 1); //Name
   Strings[4] := FetchElm(RetNo, 'T3', 14); //fiscal start
   Strings[5] := FetchElm(RetNo, 'T3', 17); //fiscal start
   Strings[3] := 'T'+FetchElm(RetNo, 'T3', 2); //Account instead of SIN


   If Strings[49]='' then Strings[49]:='0';
   If Strings[51]='' then Strings[51]:='0';
   If Vl(Strings[51])>100 then Strings[51]:='0';
   If (Strings[17]>'') and (Strings[52]='') then  //20140130
   begin
     Strings[17]:='';
     Strings[52]:='';
   end;

   {t1 only
   If UpperCase(Strings[77]) ='Y' then  //same address
   begin
     //20100305
     Strings[10]:=FetchElm(RetNo,'INFO',22)+' '+FetchElm(RetNo,'INFO',6)+' '+FetchElm(RetNo,'INFO',68)
        +FetchElm(RetNo,'INFO',163); //Apt street rr po box  //20180110
     Strings[13]:= FetchElm(RetNo,'INFO',10); //+', '+FetchElm(RetNo,'INFO',14);//city prov //20180111
     Strings[53]:= FetchElm(RetNo,'INFO',14); //20180111
     Strings[14]:= FetchElm(RetNo,'INFO',15);//postal
   end;
   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
  }
   If Strings[4] ='' then Strings[4] := AppYear+'-01-01';
   If Strings[5] ='' then Strings[5] := AppYear+'-12-31';
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;
   If Strings[18] = '' then Strings[18]:='100.0000';  //20111208
   Strings[18]:=FormatFloat('##0.0000',Vl(Strings[18])); //20111208
   If Strings[73]+Strings[74] ='' then
     begin Strings[73] := 'X';Strings[74] := ''; end;
   //If Strings[11]+Strings[22] ='' then  begin Strings[11] := 'X';Strings[22] := ''; end; //20181115

   If Strings[17] ='' then Strings[17] := OptRec.Prp_Name; //20140130
   If Strings[52] ='' then
      Strings[52]:=OptRec.Prp_Street+','+OptRec.Prp_City+','+OptRec.Prp_Prov+','+OptRec.Prp_Postal; //20130131
   If Strings[82]+Strings[90]='' then Strings[82]:='X'; //20110308

   If Strings[82]='' then        //20120112
   begin
    Tv[23]:=0; Tv[76]:=0;Tv[24]:=0;
    For i:=38 to 40 do Tv[i]:=0;
    //For i:=23 to 27 do Tv[i]:=0;
    Tv[83]:=0;
   end
   else
   begin
    Tv[86]:=Tv[76]+Tv[26]+Tv[85];   //20190208
    Tv[38]:=Tv[23]+Tv[86]-Tv[24]; //20190208 //Tv[23]+Tv[76]-Tv[24]+Tv[26];  //20130110 //added T3
    Tv[137]:=Tv[39]-Tv[40]; //20230107
    Tv[46]:=Tv[137]; //20230107 //Tv[39]-Tv[40];
    If Tv[76]>0 then ret[RetNo].FormHasData['T2125'+FInst]:=True;  //20110414
    Tv[83]:=Tv[38]+Tv[46]; //// 20120111 Tv[23]+Tv[76]-Tv[27];
   end;
   Tv[83]:=MaxR(0,Tv[83]);  //20100619

   If Strings[90]='' then
   begin
    Tv[89]:=0;
    Tv[84]:=0;Tv[41]:=0;Tv[42]:=0;Tv[43]:=0;Tv[44]:=0;Tv[45]:=0;Tv[87]:=0;Tv[93]:=0;//For i:=84 to 88 do Tv[i]:=0;
   end
   else
   begin
    Tv[42]:=Tv[89]+Tv[84]-Tv[41];
    Tv[45]:=Tv[43]-Tv[44];
    If Tv[84]>0 then ret[RetNo].FormHasData['T2125'+FInst]:=True;  //20110414
    Tv[93]:=Tv[42]+Tv[45]+Tv[87]; //20120315  //Tv[93]:=Tv[42]+Tv[45]-Tv[87]; //Tv[91]+Tv[92];
   end;
   {t1 only
   //20110208
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[37] :=OptRec.Bus_Disclm
   else
     Strings[37] :='';
   }
   //part 3
   Tv[28]:=MaxR(Tv[83],Tv[93]);
    //recapt
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[66]:=RecaptAmount;
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[66]:=Tv[66]+RecaptAmount;
   //Tv[66]:=Tv[66]+Tv[655];  //CEC recapture  //20171119
   Tv[31]:=Tv[75]+Tv[66];
   Tv[33]:=Tv[31];
   Tv[34]:=Tv[29]+Tv[33];
   Tv[94]:=Tv[34];
   If Strings[35]='' then Tv[32]:=Tv[28]+Tv[94];
  end; {End with}
   //pg 2  ???
  with ret[RetNo].Frm[Fno] do
  begin
   If Strings[82]>''  then //business
   begin
    If Strings[35]='' then
      Tv[101]:=Tv[32]
    else Tv[101]:=0;
    Tv[139] := Tv[133] + Tv[134] + Tv[135] +Tv[136]+Tv[138];
    Tv[141] := MaxR(0,Tv[139] - Tv[140]);  //20100619
    Tv[142] := Tv[141];
    If Strings[35]='' then
      Tv[143] := Tv[101] - Tv[142]
    Else
      Tv[143]:=0;
   end
   else
   begin
    Tv[101]:=0;
    For i:=133 to 143 do Tv[i]:=0;
   end;

   If Strings[35]='' then
   begin
   If Strings[82]>''  then //business
     Tv[108]:=Tv[143]
   else
     Tv[108]:=Tv[32];
   end
   else
     Tv[108]:=0;  //T5013
   //CCA
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[168]:=CCAForStmt;
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[168]:=Tv[168]+AutoCCAForStmt;
  //Term loss
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[180]:=TermLossAmount;
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[180]:=Tv[180]+TermLossAmount;

   If Strings[36]='' then Strings[36]:='50';
   If vl(Strings[36])>100 then Strings[36]:='100';
   Tv[153] := Vl(FormatFloat('#########.##',Tv[165]*vl(Strings[36])/100)); //20110117
   //get autoexpenses
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[154]:=0;
   For i:=0 to ExtractedAutoList.count-1 do
   begin
     ExtractedAutoRec:=ExtractedAutoList.Items[i];
     If ExtractedAutoRec.PartnerFlag='' then
       Tv[154]:=Tv[154]+ExtractedAutoRec.ExpensesClaimed;
   end;

   If UpperCase(Strings[178]) = 'Y' then Tv[154]:=Tv[179];
   Tv[181]:=Tv[164]+Tv[180];
   Tv[170]:=Tv[144]+Tv[153]+Tv[145]+Tv[149]+Tv[150]+Tv[146]+Tv[155]+Tv[156]+Tv[157]+Tv[152];
   Tv[170]:=Tv[170]+Tv[159]+Tv[151]+Tv[160]+Tv[158]+Tv[161]+Tv[162]+Tv[148]+Tv[147]+Tv[154]; //+Tv[169]; //20171119
   Tv[170]:=Tv[170]+Tv[168]+Tv[181];
   Tv[171]:=Tv[170];
   Tv[172]:=Tv[108]-Tv[171];
   {NI before adjustments}
   If UpperCase(Strings[176]) <> 'Y' then    //20110204
       Tv[102] := Tv[172] *  Vl(Strings[18]) / 100;  {Share}  //20111208

    Tv[110]:=Tv[102]+Tv[88]+Tv[109]; //20221207
    Tv[111]:=Tv[110];

    Tv[103] := Tv[215];
    Tv[104] := Tv[111] - Tv[103];
    Tv[105]:= Tv[235];
    //ok
    If Strings[35]='' then
      Tv[106]:= Tv[104]-Tv[105]; //20210214

    if UpperCase(Strings[176])='Y' then Tv[106]:= Tv[104]-Tv[105]; //20210214
     //if no override retain the exisying manually entered value
  end; {End with}

   //pg 3
  with ret[RetNo].Frm[Fno] do
  begin
   {t1 only
   If ShowCondominiumIndicator = True then
   begin
    If Strings[222]='' then Strings[222]:='Condominium fees';
    If Strings[224]='' then Strings[224]:='Telephone expenses';
   end;
   }

   {T1 only
   If Vl(Strings[238]) >0 then
    begin
    Strings[257] :=GetSpouseFirstName(RetNo);
    Strings[239] :=GetSpouseLastName(RetNo);
    Strings[242] :=GetSpouseSIN(RetNo);
    Strings[236] :=GetSpouseAddress(RetNo);
    end
   else
   begin
    Strings[257] :='';
    Strings[239] :='';
    Strings[242] :='';
    Strings[236] :='';
   end;
   }
    {amounts deductible}
    Tv[214]:=Tv[213]+Tv[275];
    Tv[215] := Tv[208] +Tv[210]+tv[212]+tv[214]
       +Tv[55];   //20171212
    {business use of home}
    //20180117
    Tv[70]:=Tv[223]+Tv[225]+Tv[227];
    Tv[71]:=Tv[70];
    Tv[228] := Tv[216] +Tv[217]+tv[218]+tv[219]+tv[220]+Tv[221]+Tv[71];
    //Tv[228] := Tv[228] +Tv[223] +Tv[225]+tv[227];
    If UpperCase(Strings[272]) <> 'Y' then Tv[255]:=100;
    Tv[228] := Tv[228] * Tv[255] /100;

    Tv[229] := (Tv[228] * Tv[254]) / 100;  {pers use}
    Tv[230] := Tv[228] - Tv[229];

    //Tv[274] := Tv[230]+Tv[273];
    Tv[232] := Tv[230] + Tv[273]+Tv[231];

    Tv[233] := MaxR(0,Tv[104]); //MaxR(0,Tv[4]);
    Tv[234] := MaxR(0, Tv[232]-Tv[233]);
    Tv[235] := MinR(Tv[232],Tv[233]);

    {partners}

    //sins
    i:=242; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=262; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=265; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=268; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');
    i:=271; Strings[i]:=RemoveChar(RemoveChar(Strings[i],' '),'-');

    Tv[204]:=0; //tot *
    i := 237;    {calc inc for partners}
    repeat
        Tv[i] := (Tv[172]*  Vl(Strings[i+1])) / 100;
        Strings[i+1]:=FormatFloat('##0.0000',Vl(Strings[i+1]));
        If Strings[i+1]='0.0000' then strings[i+1]:=''; //20111208
        Tv[204]:=Tv[204]+Vl(Strings[i+1]); //20111208
        Strings[204]:=FormatFloat('##0.0000',Tv[204]); //20111208
        //Tv[204]:=Tv[204]+Vl(Strings[i+1]); //20111208
        i := i + 3;
    until i > 249;
  end; {End with}

  //pg 5 CCA table
  with Ret[RetNo].Frm[FNo] do
  begin
   Tv[515]:=0;  Tv[516]:=0;  //Feb 23 2008
   Stmt:=LeftStr(FName,5);
   If PostCCaFromAssetsB(RetNo) then
   begin
    PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,301,371,10,380,381,382);  //20130408 looks ok
    Tv[515]:=Vl(Strings[515]);
    Tv[516]:=Vl(Strings[516]);
   end
   Else  //20090101
    For i:=301 to 382 do begin Strings[i]:='';Tv[i]:=0;end;

   //20140122
   i:=302;
   j:=551;
   Repeat
    Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
    Inc(i,10);
    Inc(j,1);
   until i>372;

   {cca - motor veh}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    Tv[515]:=Tv[515]+TermLossAmount;
    Tv[516]:=Tv[516]+RecaptAmount;
    For i:=383 to 424 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    For i:=515 to 517 do begin Tv[i]:=0;Strings[i]:='';end; //clear section Feb 25 2008

    Tv[423]:=0; //suppl clear
    RemainingAmount:=0;
    j:=383;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>413 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds;
         Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAForTheYear; //CCAClaimed;
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;

         //20190216Con
         Tv[i+197]:=ExtractedAutoRec.AiiPAdditions;
         Tv[i+182]:=ExtractedAutoRec.AiiPProceeds;
         Tv[i+120]:=ExtractedAutoRec.AiiPUccAdj;

         Inc(j,10);
        end;
      end;
    end;

   //20140122
   i:=384;
   j:=561;
   Repeat
    Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
    Inc(i,10);
    Inc(j,1);
   until i>414;

    Tv[423]:=RemainingAmount;
    Tv[424] := 0;
    I := 383;
    Repeat
     Tv[424] := Tv[424] + Tv[I+7];
     I := i+10;
    until i > 413;  //113;  //20110203
    Tv[424] := Tv[424] + Tv[423];
//    Tv[517]:=Tv[382]+AutoCCAForStmt; //Tv[124];  //Feb 25 2008   //20230219

   Tv[81]:=Tv[382]+Tv[424]; //20190120
    //non build additions
    If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,425,540,5,444,545,546);
    I := 427; Tv[446] := 0;
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[446] := Tv[446] + Tv[I+2];
       i := i + 5;
     Until i > 442;
     Tv[446] := Tv[446] + Tv[445];

    {motor additions}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=447 to 468 do begin Tv[i]:=0;Strings[i]:='';end; //clear section

    Tv[467]:=0; //clear suppl
    RemainingAmount:=0;
    j:=447;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions >0 then
        begin
          If j>462 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[467]:=RemainingAmount;

    I := 449; Tv[468] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[468] := Tv[468] + Tv[I+2];
      i := i + 5;
    Until i > 464;
    Tv[468] := Tv[468] + Tv[467];
    Tv[469] := Tv[446] + Tv[468];

    //building additions
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,470,485,5,489,490,491);
    end;
    I := 472; Tv[491] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[491] := Tv[491] + Tv[I+2];
      i := i + 5;
    Until i > 487;
    Tv[491] := Tv[491] + Tv[490];

    //equipm dispositions other than buildings and motor veh
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,492,507,5,511,512,513);
    end;
    I := 494; Tv[513] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[513] := Tv[513] + Tv[I+2];
      i := i + 5;
    Until i > 509;
    Tv[513] := Tv[513] + Tv[512];
  end; {End with}

  //pg 5
    with ret[RetNo].Frm[Fno] do
  begin
    //disp motor vehicles
    Stmt:=LeftStr(FName,5);
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=601 to 616 do begin Tv[i]:=0;Strings[i]:='';end; //clear section

    RemainingAmount:=0;
    j:=601;  //dispositions
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired,4)<>AppYear then
        begin
         If j>611 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Proceeds - ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Proceeds;
          Tv[j+3]:=ExtractedAutoRec.ProceedsPersonal;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[616]:=RemainingAmount;

    I := 603; Tv[656] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[656] := Tv[656] + Tv[I+2];
      i := i + 5;
    Until i > 613;

    //20110406  //remove cls and descr if no bus claim
    i:=605;
    Repeat
     If Tv[i]=0 then begin Strings[i-4]:='';Strings[i-3]:='';end;
     Inc(i,5);
    until i>=615;

    Tv[656] := Tv[656] + Tv[616];
    Tv[617] := Tv[656] +Tv[513];
    // dispositions Building
    If PostCCAFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,618,633,5,637,638,639);
    end;
    {build disp }
    I := 620; Tv[639] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[639] := Tv[639] + Tv[I+2];
      i := i + 5;
    Until i > 635;
    Tv[639] := Tv[639] + Tv[638];

   //pg 6
   NumCars:=0;
   FInst := ExtractFormInst(FName);
   Stmt:='T2125'+FInst;
   FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car
   For j:=710 to 873 do begin StoreElm(RetNo,FNo,j,'');Tv[j]:=0;end; //20110226     //20110125

   for i :=0 to (FList.Count - 1) do
   begin
     FRec := FList.Items[i];
     If Frec.FormName='AUTOS' then
     begin
      AutosFNo:=Frec.FormNo;
      If ret[RetNo].FormHasData[GetFormName(RetNo,AutosFNo)] then
      begin
       j:=215;         //allocation statements thre are 3 staements                   //20110125  instead of 915
       Repeat
        If (trim(FetchElmFNo(RetNo,AutosFNo,j)) = trim(Stmt)) and (Vl(FetchElmFNo(RetNo,AutosFNo,j+1))>0) then //20160428 Igor
        begin
         NumCars:=NumCars+1;
         //If NumCars=1 then
         If NumCars>=1 then  //20110226
         begin
           For jj:=710 to 830 do    //20110125
           begin
              Tv[jj]:=Tv[jj]+Vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
           end;
          //20210301
          ret[RetNo].Frm[FNo].Strings[737]:=FetchElmFNo(RetNo,AutosFNo,43); //zero emmissions
          Tv[737]:=Vl(ret[RetNo].Frm[FNo].Strings[737]);
         end;
        end;
        Inc(j,6);  //dummy
       until j>227;                        //20110125 instead of 927;
      end;  //has data
     end; //autos
   end;  //i

    If NumCars>=1 then begin For j:=710 to 830 do StoreElm(RetNo,FNo,j,'');Tv[j]:=0;end; //20110226 //20110226
    StoreElm(RetNo,FNo,706,' ');
    j:=831;
    i:=1;
    Repeat
      ret[RetNo].Frm[FNo].Strings[j]:=SelfAutoExpRec.Descr[i];
      ret[RetNo].Frm[FNo].Strings[j+1]:=IntToStr(SelfAutoExpRec.KmDrove[i]);
      ret[RetNo].Frm[FNo].Strings[j+2]:=IntToStr(SelfAutoExpRec.KmTotal[i]);
      ret[RetNo].Frm[FNo].Strings[j+3]:=SelfAutoExpRec.Stmt[i];
      Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
      ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
      Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
      //for jj:=j+1 to J+6 do Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[JJ]);  //20110125
      //20110226  ?? needs logic here

      i:=i+1;
      j:=j+7;
    until i>6;
    If NumCars>1 then ret[RetNo].Frm[FNo].Strings[706]:='More than one automobiles claimed (Details per auto are in AUTOS forms)';

    i:=837;
    Tv[873]:=0;
    Repeat
     Tv[873]:=Tv[873]+Tv[i];
     Inc(i,7);
    until i>872;

    //----------------------
    //20171212
    i:=832;
    k:=0;
    Repeat
     k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
     Inc(i,7);
    Until i>867;
    Ret[RetNo].Frm[FNo].Strings[56]:=IntToStr(k);

    i:=833;
    k:=0;
    Repeat
     k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
     Inc(i,7);
    Until i>868;
    Ret[RetNo].Frm[FNo].Strings[57]:=IntToStr(k);

    Ret[RetNo].Frm[FNo].Strings[58]:=Ret[RetNo].Frm[FNo].Strings[56];
    Ret[RetNo].Frm[FNo].Strings[59]:=Ret[RetNo].Frm[FNo].Strings[57];
    //----------------------

    If NumCars=1 then  //20110326
     begin
                ret[RetNo].Frm[FNo].Strings[757]:=FetchElmFNo(RetNo,AutosFNo,57); //leas dt1
                ret[RetNo].Frm[FNo].Strings[760]:=FetchElmFNo(RetNo,AutosFNo,60); //leas dt2
                ret[RetNo].Frm[FNo].Strings[763]:=FetchElmFNo(RetNo,AutosFNo,63); //leas pst
                ret[RetNo].Frm[FNo].Strings[806]:=FetchElmFNo(RetNo,AutosFNo,106); //Interest days in yr
                //20140323
                ret[RetNo].Frm[FNo].Strings[731]:=FetchElmFNo(RetNo,AutosFNo,31); //descr of other exp
                ret[RetNo].Frm[FNo].Strings[735]:=FetchElmFNo(RetNo,AutosFNo,35); //descr of other exp
     end;

    //20110226 remove interest and lease
    If NumCars>1 then
    begin
     ret[RetNo].Frm[FNo].Strings[803]:='';Tv[803]:=0;
     ret[RetNo].Frm[FNo].Strings[809]:='10';Tv[809]:=10;  //20140120
     ret[RetNo].Frm[FNo].Strings[806]:='';Tv[806]:=0;
     ret[RetNo].Frm[FNo].Strings[812]:='';Tv[812]:=0;
     ret[RetNo].Frm[FNo].Strings[815]:='';TV[815]:=0;
     ret[RetNo].Frm[FNo].Strings[757]:='';Tv[757]:=0;
     ret[RetNo].Frm[FNo].Strings[760]:='';Tv[760]:=0;
     ret[RetNo].Frm[FNo].Strings[763]:='';Tv[763]:=0;
     ret[RetNo].Frm[FNo].Strings[826]:='';Tv[826]:=0;
     ret[RetNo].Frm[FNo].Strings[766]:='';Tv[766]:=0;
     ret[RetNo].Frm[FNo].Strings[769]:='';Tv[769]:=0;
     ret[RetNo].Frm[FNo].Strings[772]:='';Tv[772]:=0;
     ret[RetNo].Frm[FNo].Strings[775]:='';Tv[775]:=0;
     ret[RetNo].Frm[FNo].Strings[778]:='';Tv[778]:=0;
     ret[RetNo].Frm[FNo].Strings[781]:='';Tv[781]:=0;
     ret[RetNo].Frm[FNo].Strings[784]:='';Tv[784]:=0;
     ret[RetNo].Frm[FNo].Strings[799]:='';TV[799]:=0;
    end;

    If ret[RetNo].Frm[FNo].Strings[809]='' then
      begin ret[RetNo].Frm[FNo].Strings[809]:='10';Tv[809]:=10;end;  //20140120  Daily allowance
    If ret[RetNo].Frm[FNo].Strings[829]='' then  begin ret[RetNo].Frm[FNo].Strings[829]:='Business parking fees';end;  //20140120  Daily allowance
    If ret[RetNo].Frm[FNo].Strings[830]='' then  begin ret[RetNo].Frm[FNo].Strings[830]:='Supplementary business insurance';end;  //20140120  Daily allowance
  end;
  SaveTv(RetNo,FName,FNo);
End;


Procedure T2042(RetNo:integer;FName:string;FNo:integer);
Var i,j,k,jj,AutosFNo,NumCars :integer;x:Real;
  FInst : String[4];
  TermLossAmount,RecaptAmount,AutoCCAForStmt,CCAForStmt:Real;
  NI,MIA,OIA:Real;
  NormalLoss,AllowedLoss,RestrictedLoss,RemainingAmount:real;
  Stmt:String;
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
   //20230225
   Strings[2] := FetchElm(RetNo, 'T3', 1); //Name
   Strings[4] := FetchElm(RetNo, 'T3', 14); //fiscal start
   Strings[5] := FetchElm(RetNo, 'T3', 17); //fiscal start
   Strings[3] := 'T'+FetchElm(RetNo, 'T3', 2); //Account instead of SIN

   //20131223
   If Strings[63]='' then Strings[63]:='0';
   If Strings[70]='' then Strings[70]:='0';
   If Vl(Strings[70])>100 then Strings[70]:='0';

   {
   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
   }
    //20130224
   {t1 only
   If Length(OptRec.Bus_Disclm) >0 then
    Strings[9] :=OptRec.Bus_Disclm
   else
     Strings[9] :='';
   }
   If Strings[4] ='' then Strings[4] := AppYear+'-01-01';
   If Strings[5] ='' then Strings[5] := AppYear+'-12-31';
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;

   If Strings[13] = '' then
   Begin
    if Uppercase(Strings[68])<>'Y' then Strings[13] := FetchElm(RetNo,'INFO',15); //20181202 //only if not T5013
   end;

   If Strings[19] = '' then Strings[19] := OptRec.Prp_Name
    +', '+OptRec.Prp_Street+','+OptRec.Prp_City+','+OptRec.Prp_Prov+','+OptRec.Prp_Postal; //20130131

   If Strings[24]='' then Strings[24]:='100.0000'; //20111108 //If TV[24] = 0 then TV[24] := 100;
   Strings[24]:=FormatFloat('##0.0000',Vl(Strings[24]));
   Tv[24]:=Vl(Strings[24]);  //20111208
   //recapt
   ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[64]:=RecaptAmount;
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[64]:=Tv[64]+RecaptAmount;
   //Tv[64]:=Tv[64]+Tv[562];   //20171119  cec?
   Tv[65] := Tv[60] + Tv[62]+Tv[64]+Tv[137]; //20220424

   x:=0;
   For i :=26 to 33 do x:=x+Tv[i];
   For i :=36 to 58 do x:=x+Tv[i];
   x:=x+Tv[65];
   If UpperCase(Strings[68]) <> 'Y' then Tv[66] :=x;
  end; {End with}

  //pg 2
   with ret[RetNo].Frm[Fno] do
 begin
   Strings[153]:='Double click for MIA Worksheet';
   Tv[101] := Tv[66];
   Tv[135]:= 0;
   //get autoexpenses
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[110]:=0;
   For i:=0 to ExtractedAutoList.count-1 do
   begin
     ExtractedAutoRec:=ExtractedAutoList.Items[i];
     If ExtractedAutoRec.PartnerFlag='' then Tv[110]:=Tv[110]+ExtractedAutoRec.ExpensesClaimed;
   end;
   For i :=102 to 128 do
     Tv[135] := Tv[135] +Tv[i];

  //Term loss
   ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[134]:=TermLossAmount;
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[134]:=Tv[134]+TermLossAmount;
   //CCA
   ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[136]:=CCAForStmt;
   ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[136]:=Tv[136]+AutoCCAForStmt;

   Tv[152] :=Tv[130]+Tv[132] + Tv[134];
   Tv[151] := Tv[152];
   Tv[135] :=Tv[135]+Tv[151];

   //Tv[137] := MaxR(0,Tv[559]);   //20171119 cec
   Tv[138] :=Tv[135]+Tv[136]; //+Tv[137];    //20171119 cec
   Tv[139] := Tv[138];
   Tv[140] := Tv[101] -Tv[139];
   {t1 only
   If UpperCase(Strings[154])='Y' then
   begin
    GetMIAAmount(RetNo,FName,MIA,OIA);
    Tv[141]:=OIA;
    Tv[142]:=MIA;
   end;
   }
   Tv[143] :=Tv[140]+Tv[141]+Tv[142];
   Tv[144] := Tv[143] * Tv[24]/100;
   Tv[156]:=Tv[144]+Tv[198]+Tv[199]+Tv[155];  //20221218     //Tv[144]+Tv[22]+Tv[155];  //20220201
   Tv[157]:=Tv[156];

   Tv[145] := Tv[613];
   Tv[146] := Tv[157] - Tv[145]; //Tv[44] - Tv[45];  //20100215
   Tv[147] := Tv[636];
   Tv[149] := Tv[146] - Tv[147];
   If (UpperCase(Strings[67]) = 'Y')
   and (Tv[149] <0) then
   {restricted farm loss}
   begin
     NormalLoss := ABS(Tv[149]);
     //20140312
     If NormalLoss>32500 then
      AllowedLoss := 17500
     else
       AllowedLoss:= MinR(NormalLoss,(2500+ MaxR(0,NormalLoss-2500)*0.50)); //20190516 Correct
     // AllowedLoss := MinR(NormalLoss,2500+ MaxR(0,(NormalLoss-2500)/2));

     RestrictedLoss := NormalLoss-AllowedLoss;
     If UpperCase(Strings[133])<>'Y' then  //20090504
        Tv[150] := RestrictedLoss;
     If UpperCase(Strings[68]) <> 'Y' then  //from t5013
      Tv[148] := Tv[149]-(-Tv[150]);
    end
    else
     begin
      Tv[150] := 0;
       If UpperCase(Strings[68]) <> 'Y' then
        Tv[148] := Tv[149];
     end;

    If UpperCase(Strings[68]) = 'Y' then
    begin
     For i:=101 to 147 do Tv[i] :=0;
     For i:=149 to 150 do Tv[i] :=0;
    end;
 end;
 //pg 3
   with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    {equip additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,201,216,5,220,221,222);
    end;
    I := 203; Tv[222] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[222] := Tv[222] + Tv[I+2]; //20110109
      i := i + 5;
    Until i > 218;
    Tv[222] := Tv[222] + Tv[221];

   {Motor veh additions}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=223 to 243 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[243]:=0; //clear suppl
    RemainingAmount:=0;
    j:=223;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions>0 then
        begin
         If j>238 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[243]:=RemainingAmount;

    I := 225; Tv[244] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[244] := Tv[244] + Tv[I+2];
      i := i + 5;
    Until i > 240;
    Tv[244] := Tv[244] + Tv[243];

    Tv[245] := Tv[222]+Tv[244];

    {build additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,246,261,5,265,266,267);
    end;
    I := 248; Tv[267] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[267] := Tv[267] + Tv[I+2];
      i := i + 5;
    Until i > 263;
    Tv[267] := Tv[267] + Tv[266];

    {equip disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,268,283,5,287,288,289);  //20110109
    end;
    I := 270; Tv[289] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[289] := Tv[289] + Tv[I+2];
      i := i + 5;
    Until i > 285;
    Tv[289] := Tv[289] + Tv[288];

    {Motor veh disp}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=290 to 310 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    RemainingAmount:=0;
    j:=290;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired,4)<>AppYear then
        begin
         If j>205 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Proceeds - ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Proceeds;
          Tv[j+3]:=ExtractedAutoRec.ProceedsPersonal;
         //20190216Con
          Tv[i+182]:=ExtractedAutoRec.AiiPAdditions;
          Tv[i+186]:=ExtractedAutoRec.AiiPProceeds;
          Tv[i+190]:=ExtractedAutoRec.AiiPUccAdj;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[310]:=RemainingAmount;

    I := 292; Tv[311] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[311] := Tv[311] + Tv[I+2];
      i := i + 5;
    Until i > 307;
    Tv[311] := Tv[311] + Tv[310];
    Tv[312] := Tv[289] + Tv[311];

    {build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,313,328,5,332,333,334);
    end;
    I := 315; Tv[334] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[334] := Tv[334] + Tv[I+2];
      i := i + 5;
    Until i > 330;
    Tv[334] := Tv[334] + Tv[333];
  end; {End with}



  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    Tv[482] := 0;
    {CCA Xi}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,401,471,10,480,481,482);
      Tv[615]:=Vl(Strings[615]);
      Tv[616]:=Vl(Strings[616]);
    end
    Else  //20090101
    begin
     for i:=401 to 482 do begin Strings[i]:='';Tv[i]:=0;end;
    end;

    {cca - motor veh}
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    //20120407
    Tv[134]:=Tv[134]+TermLossAmount;
    For i:=483 to 523 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[523]:=0; //suppl clear
    RemainingAmount:=0;
    j:=483;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>513 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds; //Feb 2008
         Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAForTheYear;//ExtractedAutoRec^.CCAClaimed; //Feb 2008
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;
         Inc(j,10);
        end;
     end;
    end;
    Tv[523]:=RemainingAmount;

   Tv[524] := 0;
   I := 483;
    Repeat
     Tv[524] := Tv[524] + Tv[I+7];
     I := i+10;
    until i > 513;
    Tv[524] := Tv[524] + Tv[523];

   {CCA XVII}
    Tv[547] := 0;
    I := 528;
    Repeat
     Tv[I+2] := Tv[i] * Tv[I+1]/100;
     Tv[547] := Tv[547] + Tv[I+2];
     I := i+7;
    until i > 539;
    Tv[547] := Tv[547] + Tv[546];

    Tv[548] := Tv[482]+Tv[524]+Tv[547];
  //  Tv[617]:=Tv[548];   //used to be 217 in 2009 //20101204
  end; {End with}

  //pg 5
  with ret[RetNo].Frm[Fno] do
  begin
    {t1 only
    If Tv[642] >0 then
      begin
      Strings[640] :=GetSpouseFirstName(RetNo);
      Strings[664] :=GetSpouseLastName(RetNo);
      Strings[665] :=GetSpouseSIN(RetNo);
      Strings[643] :=GetSpouseAddress(RetNo);
      end
   else
    begin Strings[657] :='';Strings[643] :='';end;
   }
    Tv[612]:=Tv[681]+Tv[682];
    Tv[613] := Tv[606] +Tv[608]+tv[610]+Tv[673]+tv[612];   //20190111
    //20180117
    {business use of home}
    Tv[76]:=Tv[621]+Tv[623]+Tv[625];
    Tv[77]:=Tv[76];
    Tv[626] := Tv[614]+Tv[615]+Tv[616]+tv[617]+tv[618]+tv[619]+Tv[77];
    //Tv[626] := Tv[626] +Tv[621] +Tv[623]+tv[625];
    If UpperCase(Strings[676]) <> 'Y' then Tv[630]:=100;
    Tv[626]:=Tv[626]*Tv[630]/100;
    Tv[628] := (Tv[626] * Tv[627]) / 100;  {pers use}
    Tv[629] := Tv[626] - Tv[628];
    Tv[633] :=Tv[629]+Tv[677]+Tv[632]; //Tv[631] + Tv[632];
    Tv[634] := MaxR(0,Vl(FetchElm(RetNo,'T2042'+FInst,146)));
    Tv[635] := MaxR(0,Tv[633]-Tv[634]);
    Tv[636] := MaxR(0,MinR(Tv[633],Tv[634]));
  //  Tv[611]:=Tv[642]+Tv[646]+Tv[650]+Tv[654]+Tv[658]+Tv[662];  //see below
    Ni :=Vl(FetchElm(RetNo,'T2042'+FInst,143));
    i := 641;    {calc inc for partners}
    repeat
        Tv[i+1]:=Vl(Strings[i+1]);
        Strings[i+1]:=FormatFloat('##0.0000',Tv[i+1]);
        If Tv[i+1]=0 then Strings[i+1]:='';
        Tv[i] := Ni *  Tv[i+1] / 100;
        i := i + 4;
    until i > 661;
    Strings[611]:=FormatFloat('##0.0000',Vl(Strings[642])+Vl(Strings[646])+Vl(Strings[650])+Vl(Strings[654])+Vl(Strings[658])+Vl(Strings[662]));


   //pg 6
   NumCars:=0;
   FInst := ExtractFormInst(FName);
   Stmt:='T2042'+FInst;
   FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car
   For j:=710 to 873 do StoreElm(RetNo,FNo,j,'');              //20110125

   for i :=0 to (FList.Count - 1) do
   begin
     FRec := FList.Items[i];
     If Frec.FormName='AUTOS' then
     begin
      AutosFNo:=Frec.FormNo;
      If ret[RetNo].FormHasData[GetFormName(RetNo,AutosFNo)] then
      begin
       j:=215;                            //20110125  instead of 915
       Repeat
        If (trim(FetchElmFNo(RetNo,AutosFNo,j)) = trim(Stmt)) and (Vl(FetchElmFNo(RetNo,AutosFNo,j+1))>0) then  //20160428 Igor
        begin
         NumCars:=NumCars+1;
         If NumCars=1 then
         begin
           For jj:=710 to 830 do    //20110125
           begin
              ret[RetNo].Frm[FNo].Strings[jj]:=FetchElmFNo(RetNo,AutosFNo,jj-700);
              Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[jj]);
           end;
           //20210301
           ret[RetNo].Frm[FNo].Strings[737]:=FetchElmFNo(RetNo,AutosFNo,43); //zero emmissions
           Tv[737]:=Vl(ret[RetNo].Frm[FNo].Strings[737]);
         end;
        end;
        Inc(j,6);  //dummy
       until j>227;                        //20110125 instead of 927;

      end;  //has data
     end; //autos
   end;  //i

    If NumCars>1 then For j:=710 to 830 do StoreElm(RetNo,FNo,j,'');

    //20230197
    If ret[RetNo].Frm[FNo].Strings[829]='' then  begin ret[RetNo].Frm[FNo].Strings[829]:='Business parking fees';end;
    If ret[RetNo].Frm[FNo].Strings[830]='' then  begin ret[RetNo].Frm[FNo].Strings[830]:='Supplementary business insurance';end;


    StoreElm(RetNo,FNo,706,' ');
    j:=831;
    i:=1;
    Repeat
      ret[RetNo].Frm[FNo].Strings[j]:=SelfAutoExpRec.Descr[i];
      ret[RetNo].Frm[FNo].Strings[j+1]:=IntToStr(SelfAutoExpRec.KmDrove[i]);
      ret[RetNo].Frm[FNo].Strings[j+2]:=IntToStr(SelfAutoExpRec.KmTotal[i]);
      ret[RetNo].Frm[FNo].Strings[j+3]:=SelfAutoExpRec.Stmt[i];
      Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
      ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
      Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
      //for jj:=j+1 to J+6 do Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[JJ]);  //20110125
      i:=i+1;
      j:=j+7;
     until i>6;

      //----------------------
    //20171216
    i:=832;
    k:=0;
    Repeat
     k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
     Inc(i,7);
    Until i>867;
    Ret[RetNo].Frm[FNo].Strings[72]:=IntToStr(k);

    i:=833;
    k:=0;
    Repeat
     k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
     Inc(i,7);
    Until i>868;
    Ret[RetNo].Frm[FNo].Strings[73]:=IntToStr(k);

    Ret[RetNo].Frm[FNo].Strings[74]:=Ret[RetNo].Frm[FNo].Strings[72];
    Ret[RetNo].Frm[FNo].Strings[75]:=Ret[RetNo].Frm[FNo].Strings[73];
    //----------------------



    If NumCars>1 then ret[RetNo].Frm[FNo].Strings[706]:='More than one automobiles claimed (Details per auto are in AUTOS forms)';

    i:=837;
    Tv[873]:=0;
    Repeat
     Tv[873]:=Tv[873]+Tv[i];
     Inc(i,7);
    until i>872;
  end;
  SaveTv(RetNo,FName,FNo);
End;


Procedure T2121(RetNo:integer;FName:string;FNo:integer);
Var i,j,jj,k, AutosFNo :integer; FInst : String[4];
 TermLossAmount,RecaptAmount:Real;AutoCCAForStmt:Real;CCAForStmt, NI:Real;
  AssetsFNo: integer; Stmt:String;RemainingAmount:Real;
  NumCars:Integer;

Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
      //20230225
   Strings[2] := FetchElm(RetNo, 'T3', 1); //Name
   Strings[4] := FetchElm(RetNo, 'T3', 14); //fiscal start
   Strings[5] := FetchElm(RetNo, 'T3', 17); //fiscal start
   Strings[3] := 'T'+FetchElm(RetNo, 'T3', 2); //Account instead of SIN


  //20131223
   If Strings[86]='' then Strings[86]:='0';
   If Strings[88]='' then Strings[88]:='0';
   If Vl(Strings[88])>100 then Strings[88]:='0';
   If Strings[89]='' then Strings[89]:=ret[RetNo].Province;  //20150128

   {
   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
   }
   //20130224
   {t1 only
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[81] :=OptRec.Bus_Disclm
   else
     Strings[81] :='';
   }
   If Strings[4] ='' then Strings[4] :=AppYear+'-01-01';
   If Strings[5] ='' then Strings[5] :=AppYear+'-12-31';
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;
   If Strings[13] = '' then Strings[13] := OptRec.Prp_Name;
   If Strings[30] = '' then Strings[30] :=
     OptRec.Prp_Street+','+OptRec.Prp_City+','+OptRec.Prp_Prov+','+OptRec.Prp_Postal;
   If Strings[19]+Strings[76] ='' then Strings[19] :='X';
   //20111208
   If Strings[18]='' then Strings[18]:='100.0000';
   Strings[18]:=FormatFloat('##0.0000',vl(Strings[18]));
   Tv[18]:=Vl(Strings[18]);
   //If TV[18] = 0 then TV[18] := 100;
   If FInst='#1' then Tv[32] :=  TotMultiple(RetNo,'T4',35);


 //Feb 24 2008
   //recapt
   ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[28]:=RecaptAmount;
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[28]:=Tv[28]+RecaptAmount;
  //Term loss
   ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[60]:=TermLossAmount;
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[60]:=Tv[60]+TermLossAmount;
   //CCA
   ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   Tv[65]:=CCAForStmt;
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[65]:=Tv[65]+AutoCCAForStmt;

   //Tv[66] := Tv[532]; //20171119 cec
   //If Tv[66] =0 then Tv[66] :=-Tv[536];  {inc inclusion}
   {
   If Tv[66]<0 then
   begin
    Tv[28]:=Tv[28]+Abs(Tv[66]);
    Tv[66]:=0;
   end;
   }
   Tv[455]:=Tv[32]+Tv[34];
   Tv[456]:=Tv[455];


   If UpperCase(Strings[27]) <> 'Y' then
     Tv[35] :=AddColumns(20,24,1)+Tv[456]+Tv[28]+Tv[26]; //20230126
     //Tv[35] :=AddColumns(20,24,1)+Tv[26]+Tv[28]+Tv[32]+Tv[34];
   Tv[77]:=Tv[35];
   //get autoexpenses
   ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[44]:=0;
   For i:=0 to ExtractedAutoList.count-1 do
   begin
     ExtractedAutoRec:=ExtractedAutoList.Items[i];
     If ExtractedAutoRec.PartnerFlag='' then Tv[44]:=Tv[44]+ExtractedAutoRec.ExpensesClaimed;
   end;
   If UpperCase(Strings[79])='Y' then Tv[44]:=Tv[80];

   Tv[52] := Tv[49]+Tv[50]+Tv[51];
   Tv[54] := Tv[52] - Tv[53];
   Tv[55] := Tv[54];

   Tv[64] := 0;
   For i :=36 to 48 do Tv[64] := Tv[64] +Tv[i];
   Tv[63] := Tv[57]+Tv[59]+Tv[60];
   Tv[64] := Tv[64] + Tv[55]+Tv[63];
   Tv[67] := Tv[64] + Tv[65];  //+Tv[66];  //20171119
   Tv[68] := Tv[67];
   Tv[69] := Tv[77] - Tv[68]; //Tv[35] - Tv[68];
   Tv[70] := Tv[69] * Tv[18] /100;
   Tv[78] := Tv[70]+Tv[458]+Tv[10];//Tv[70]+Tv[10];  //20221218
   Tv[62] := Tv[78]; //Tv[70]+Tv[10];  //20120130
   Tv[71] := Tv[109];
   Tv[72] := Tv[62]-Tv[71]; //Tv[70] - Tv[71];     //20100220
   Tv[73] := Tv[132];

   If UpperCase(Strings[27]) = 'Y' then  //20091229
   begin
     For i :=36 to 48 do Tv[i]:=0;
     Tv[57]:=0;
     Tv[59]:=0;
     For i :=63 to 73 do Tv[i]:=0;
   end;
   If UpperCase(Strings[27]) <> 'Y' then Tv[74] := Tv[72] - Tv[73];
  end; {End with}
  //pg 2 NOT FULLY CONVERTED??????

//??  Tv[215]:=0;  Tv[216]:=0;  //Feb 23 2008
  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    {amounts deductible}
    //get autoexpenses
    ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
//??    Tv[215]:=Tv[215]+TermLossAmount;
//??    Tv[216]:=Tv[216]+RecaptAmount;

    Tv[108]:=Tv[281]+Tv[282];
    Tv[109] := Tv[102] +Tv[104]+tv[106]+Tv[108]+Tv[98]; //201171213

  {business use of home}
    //20180117
    Tv[99]:=Tv[117]+Tv[119]+Tv[121];
    Tv[100]:=Tv[99];
    Tv[107]:=Tv[110] +Tv[111]+tv[112]+tv[113]+tv[114]+Tv[115]+Tv[100];
    If UpperCase(Strings[278]) <> 'Y' then Tv[126] :=100;
    Tv[107] := (Tv[107] * Tv[126]) / 100;  {alloca}

    Tv[124]:=Tv[107]*Tv[123]/100;
    Tv[122]:=MaxR(0,Tv[107]-Tv[124]);
    Tv[280]:=Tv[279];
    Tv[125]:=Tv[122]+Tv[280]+Tv[128];

    Tv[129]:=Tv[122]+Tv[280]+Tv[128]; //Tv[127];
    Tv[130] :=MaxR(0,Tv[72]);
    Tv[131] := MaxR(0, Tv[129]-Tv[130]);
    Tv[132] := MinR(Tv[129],Tv[130]);

    Tv[218] := 0;
    If PostCCaFromAssetsB(RetNo) then
    Begin
      PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,137,207,10,216,217,218);
      Tv[315]:=Vl(Strings[315]);
      Tv[316]:=Vl(Strings[316]);
    end
    else //20090101
    begin
     For i:=137 to 207 do begin Strings[i]:='';Tv[i]:=0;end;
    end;

    Tv[218] := Tv[218] + Tv[217];


    {cca - motor veh}
   //get autoexpenses
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=219 to 259 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[259]:=0; //suppl clear
    RemainingAmount:=0;
    j:=219;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
         If j>249 then
           RemainingAmount:=RemainingAmount+ExtractedAutoRec.CCAClaimed
         else
         begin
         Strings[j]:=ExtractedAutoRec.ClassId;
         Tv[j+1]:=ExtractedAutoRec.UccStart;
         Tv[j+2]:=ExtractedAutoRec.Additions;
         Tv[j+3]:=ExtractedAutoRec.Proceeds; //feb 2008
         Tv[j+4]:=ExtractedAutoRec.Adjustments;
         Tv[j+5]:=ExtractedAutoRec.BaseAmount;
         Strings[j+6]:=FormatFloat('###.##',ExtractedAutoRec.Rate);
         Tv[j+7]:=ExtractedAutoRec.CCAForTheYear; //ExtractedAutoRec^.CCAClaimed; //Feb 2008
         Tv[j+8]:=ExtractedAutoRec.UCCEnd;

         //20190216Con
          Tv[i+443]:=ExtractedAutoRec.AiiPAdditions;
          Tv[i+447]:=ExtractedAutoRec.AiiPProceeds;
          Tv[i+451]:=ExtractedAutoRec.AiiPUccAdj;
         Inc(j,10);
        end;
     end;
    end;
    Tv[259]:=RemainingAmount;

   {cca - motor veh}
   Tv[260] := 0;
   I := 219;
    Repeat
     Tv[260] := Tv[260] + Tv[I+7];
     I := i+10;
    until i > 249;
    Tv[260] := Tv[260] + Tv[259];

    Tv[277] := Tv[218]+ Tv[260];
    Tv[317]:=Tv[277];
  end; {End with}


  //pg 3
  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    If PostCCaFromAssetsB(RetNo) then
    begin
     If PostCCaFromAssetsB(RetNo) then PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,301,316,5,320,321,322);
    end;
    {equip additions}
    I := 303; Tv[322] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[322] := Tv[322] + Tv[I+2];
      i := i + 5;
    Until i > 318;
    Tv[322] := Tv[322] + Tv[321];

    {motor additions}
    //get autoexpenses
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=323 to 343 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[343]:=0; //clear suppl
    RemainingAmount:=0;
    j:=323;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If ExtractedAutoRec.Additions>0 then
        begin
         If j>338 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Cost;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[343]:=RemainingAmount;

    {motor}
    I := 325; Tv[344] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[344] := Tv[344] + Tv[I+2];
      i := i + 5;
    Until i > 340;
    Tv[344] := Tv[344] + Tv[343];
    Tv[345] := Tv[322] +Tv[344];

    //20140122
    i:=138;
    j:=90;
    Repeat
     Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
     Inc(i,10);
     Inc(j,1);
    until i>208;

    //20140122
    i:=220;
    j:=261;
    Repeat
     Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
     Inc(i,10);
     Inc(j,1);
    until i>264;

    {build additions}
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,346,361,5,365,366,367);
    end;
    I := 348; Tv[367] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[367] := Tv[367] + Tv[I+2];
      i := i + 5;
    Until i > 363;
    Tv[367] := Tv[367] + Tv[366];



    {non build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,368,383,5,337,338,339);
    end;
    I := 370; Tv[389] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[389] := Tv[389] + Tv[I+2];
      i := i + 5;
    Until i > 385;
    Tv[389] := Tv[389] + Tv[388];

    {motor disp }
    //get autoexpenses
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
    For i:=390 to 410 do begin Tv[i]:=0;Strings[i]:='';end; //clear section
    Tv[411]:=0;   //20130205
    RemainingAmount:=0;
    j:=390;
    For i:=0 to ExtractedAutoList.count-1 do
    begin
      ExtractedAutoRec:=ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag='' then
      begin
        If LeftStr(ExtractedAutoRec.DateAcquired,4)<>AppYear then
        begin
         If j>405 then RemainingAmount:=MaxR(0,RemainingAmount
            +ExtractedAutoRec.Proceeds - ExtractedAutoRec.ProceedsPersonal)
         else
         begin
          Strings[j]:=ExtractedAutoRec.ClassId;
          Strings[j+1]:=ExtractedAutoRec.Description;
          Tv[j+2]:=ExtractedAutoRec.Proceeds;
          Tv[j+3]:=ExtractedAutoRec.ProceedsPersonal;
          Inc(j,5);
         end;
        end;
     end;
    end;
    Tv[410]:=RemainingAmount;

    I := 392; Tv[311] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[411] := Tv[411] + Tv[I+2];
      i := i + 5;
    Until i > 407;
    Tv[411] := Tv[411] + Tv[410];
    Tv[412] := Tv[389] + Tv[411];

    {build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then PostnonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,413,428,5,432,433,434);
    end;
    I := 415; Tv[434] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[434] := Tv[434] + Tv[I+2];
      i := i + 5;
    Until i > 430;
    Tv[434] := Tv[434] + Tv[433];
  end; {End with}

  //pg 4
  with ret[RetNo].Frm[Fno] do
  begin
    {t1 only
    If Tv[505] >0 then
     begin
      Strings[503]  :=GetSpouseFirstName(RetNo);
      Strings[537] :=GetSpouseLastName(RetNo);
      Strings[538] :=GetSpouseSIN(RetNo);
      Strings[506]  :=GetSpouseAddress(RetNo);
     end
     else
      begin Strings[503] :='';Strings[506] :='';end;
    }
   // Tv[547]:=Tv[505]+Tv[509]+Tv[513]+Tv[517]+Tv[521];  //see below
    Ni := Tv[69];
    i := 504;    {calc inc for partners}
    repeat
        Strings[i+1]:=FormatFloat('##0.0000',Vl(Strings[i+1]));
        Tv[i+1]:=Vl(Strings[i+1]);
        If Tv[i+1]=0 then Strings[i+1]:='';
        Tv[i] := Ni  *  Tv[i+1] / 100;
        i := i + 4;
    until i > 520;
    Strings[547]:=FormatFloat('##0.0000',Vl(Strings[505])+Vl(Strings[509])+Vl(Strings[513])+Vl(Strings[517])+Vl(Strings[521]));  //20120227
    // Tv[547]:=Tv[505]+Tv[509]+Tv[513]+Tv[517]+Tv[521];  //20111208
   // Strings[547]:=FormatFloat('##0.0000',Tv[547]);

   (* //20171208
    {CEC}
    Tv[525] := Tv[524] * 0.75;
    Tv[526] := Tv[523] + Tv[525];
    Tv[529] := Tv[527] + Tv[528];
    Tv[530] := Tv[529] * 0.75;
    Tv[531] := Tv[526] - Tv[530];

      If Tv[531] <0 then
      begin
        Tv[534] := ABS(Tv[531]);
        Tv[531]:=0;
        Tv[533] :=0;
        Tv[532] := 0;
        Tv[560]:=Tv[559]*75/100;
        Tv[561]:=MaxR(0,Tv[534]+Tv[535]-Tv[560]);
        Tv[558]:=Tv[535];
        Tv[562]:=MinR(Tv[561],Tv[558]);

        Tv[563]:=Tv[561];
        Tv[564]:=Tv[535];
        Tv[565]:=MaxR(0,Tv[563]-Tv[564]-Tv[557]);
        Tv[566] := Tv[565] * 2/3;

        Tv[567]:=Tv[562]+Tv[566];
        Tv[568]:=Tv[561];
        Tv[569]:=Tv[535];
        Tv[570]:=MaxR(0,Tv[568]-Tv[569]);

        Tv[571]:=Tv[18];
        Tv[536]:=Tv[567];
        For i:=568 to 572 do Tv[i]:=0;
       end
    else
      begin
        Tv[534] := 0; Tv[535] := 0;Tv[536] := 0;
        If Tv[533]>0 then
         Tv[532] := Tv[533]
         else
         Tv[532] := Tv[531] * 0.07;
        Tv[531]:=MaxR(0,Tv[526] - Tv[530]-Tv[532]);
        For i:=534 to 536 do Tv[i]:=0;
        For i:=560 to 572 do Tv[i]:=0;
        Tv[557]:=0;
        Tv[558]:=0;
      end;
    *)

   //pg 5
   NumCars:=0;
   FInst := ExtractFormInst(FName);
   Stmt:='T2121'+FInst;
   FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car
   For j:=610 to 773 do StoreElm(RetNo,FNo,j,'');              //20110125

   for i :=0 to (FList.Count - 1) do
   begin
     FRec := FList.Items[i];
     If Frec.FormName='AUTOS' then
     begin
      AutosFNo:=Frec.FormNo;
      If ret[RetNo].FormHasData[GetFormName(RetNo,AutosFNo)] then
      begin
       j:=215;                            //20110125  instead of 915
       Repeat
        If (trim(FetchElmFNo(RetNo,AutosFNo,j)) = trim(Stmt)) and (Vl(FetchElmFNo(RetNo,AutosFNo,j+1))>0) then //20160428 Igor
        begin
         NumCars:=NumCars+1;
         If NumCars=1 then
         begin
           For jj:=610 to 730 do    //20110125
            begin
              ret[RetNo].Frm[FNo].Strings[jj]:=FetchElmFNo(RetNo,AutosFNo,jj-600);
              Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[jj]);
            end;
            //zero emmission 20210301
            ret[RetNo].Frm[FNo].Strings[655]:=FetchElmFNo(RetNo,AutosFNo,43);
            Tv[655]:=Vl(ret[RetNo].Frm[FNo].Strings[43]);

         end;
        end;
        Inc(j,6);  //dummy
       until j>227;                        //20110125 instead of 927;
      end;  //has data
     end; //autos
   end;  //i

    If NumCars>1 then For j:=610 to 730 do StoreElm(RetNo,FNo,j,'');
    StoreElm(RetNo,FNo,606,' ');
    j:=731;
    i:=1;
    Repeat
      ret[RetNo].Frm[FNo].Strings[j]:=SelfAutoExpRec.Descr[i];
      ret[RetNo].Frm[FNo].Strings[j+1]:=IntToStr(SelfAutoExpRec.KmDrove[i]);
      ret[RetNo].Frm[FNo].Strings[j+2]:=IntToStr(SelfAutoExpRec.KmTotal[i]);
      ret[RetNo].Frm[FNo].Strings[j+3]:=SelfAutoExpRec.Stmt[i];
      Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
      ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
      Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
      //for jj:=j+1 to J+6 do Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[JJ]);  //20110125
      i:=i+1;
      j:=j+7;
     until i>6;

       //----------------------
    //20171213
    i:=732;
    k:=0;
    Repeat
     k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
     Inc(i,7);
    Until i>767;
    Ret[RetNo].Frm[FNo].Strings[267]:=IntToStr(k);

    i:=733;
    k:=0;
    Repeat
     k:=k+MyStrToInt(Ret[RetNo].Frm[FNo].Strings[i]);
     Inc(i,7);
    Until i>768;
    Ret[RetNo].Frm[FNo].Strings[268]:=IntToStr(k);

    Ret[RetNo].Frm[FNo].Strings[265]:=Ret[RetNo].Frm[FNo].Strings[267];
    Ret[RetNo].Frm[FNo].Strings[266]:=Ret[RetNo].Frm[FNo].Strings[268];
    //----------------------



    If NumCars>1 then ret[RetNo].Frm[FNo].Strings[606]:='More than one automobiles claimed (Details per auto are in AUTOS forms)';

    i:=737;
    Tv[773]:=0;
    Repeat
     Tv[773]:=Tv[773]+Tv[i];
     Inc(i,7);
    until i>772;
    If ret[RetNo].Frm[FNo].Strings[709]='' then  begin ret[RetNo].Frm[FNo].Strings[709]:='10';Tv[709]:=10;end;  //20140120  Daily allowance
    If ret[RetNo].Frm[FNo].Strings[729]='' then  begin ret[RetNo].Frm[FNo].Strings[729]:='Business parking fees';end;  //20140120  Daily allowance
    If ret[RetNo].Frm[FNo].Strings[730]='' then  begin ret[RetNo].Frm[FNo].Strings[730]:='Supplementary business insurance';end;  //20140120  Daily allowance
  end;
  SaveTv(RetNo,FName,FNo);
  UpdateThisFormDataIndicator(RetNo,FName);
End;


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
   //20230225
   Strings[1] := FetchElm(RetNo, 'T3', 1); //Name

   if Strings[3] = '' then
    Strings[3] := FetchElm(RetNo, 'T3', 14); //fiscal start
   if Strings[6] = '' then
    Strings[6] := FetchElm(RetNo, 'T3', 17); //fiscal end

   Strings[2] := 'T'+FetchElm(RetNo, 'T3', 2); //Account instead of SIN
   // Strings[1] := Rtrim(FetchElm(RetNo, 'INFO', 2)) + ' ' +  FetchElm(RetNo, 'INFO', 5); //t1 only
   // Strings[2] := FetchElm(RetNo, 'INFO', 3);                                            //t1 only

    If Strings[3] = '' then
      Strings[3] := AppYear + '-01-01';
    If Strings[6] = '' then
      Strings[6] := AppYear + '-12-31';
    If Strings[9] + Strings[10] = '' then
      Strings[10] := 'X';
    If Strings[4] + Strings[5] = '' then
      Strings[4] := 'X';
    Strings[12] := OptRec.Prp_Name;

    // 20170310
    Strings[14] := OptRec.Prp_Street;
    Strings[16] := OptRec.Prp_City;
    Strings[17] := OptRec.Prp_Prov;
    Strings[118] := OptRec.Prp_Postal;

    {
      Strings[14] := OptRec.Prp_Street+', '+OptRec.Prp_City
      + ', '+OptRec.Prp_Prov + ', '+ OptRec.Prp_Postal;
    }
    // If Strings[110] >'' then
    // 20190109
    If UpperCase(Strings[145]) = 'Y' then // 20120213
    begin
      Strings[109] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);
    End;

    {t1 only
    If Strings[110] = '' then
      Strings[110] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO',
        22) + ' ' + FetchElm(RetNo, 'INFO', 68) + ' ' + FetchElm(RetNo, 'INFO',
        63); // str / rural
    If Strings[112] = '' then
      Strings[112] := FetchElm(RetNo, 'INFO', 10); // city
    If Strings[120] = '' then
      Strings[120] := FetchElm(RetNo, 'INFO', 14); // Prov
    If Strings[111] = '' then
      Strings[111] := FetchElm(RetNo, 'INFO', 15); // Postal
   }
    If Strings[18] = '' then
      Strings[18] := '100.0000'; // Tv[18] :=100; 20111208
    Strings[18] := FormatFloat('##0.0000', Vl(Strings[18])); // 20111208
    // If (Tv[18] < 0) or (Tv[18] >100) then Tv[18] := 100;

    Strings[19] := '531111'; { sic }

    If Strings[138] = '' then
      Strings[138] := 'N';

    If UpperCase(Strings[141]) <> 'Y' then
      Strings[114] := Strings[18]; // Tv[114]:=Tv[18];  //20111208

    // If Tv[114]>100 then Tv[114]:=100;
    If Vl(Strings[114]) > 100 then
      Strings[114] := '100.0000'; // Tv[18] :=100; 20111208
    Strings[114] := FormatFloat('##0.0000', Vl(Strings[114])); // 20111208
    Tv[114] := Vl(Strings[114]); // 20111209

    If Strings[115] = '' then
      Strings[115] := '100.0000'; // 20111208
    If Vl(Strings[115]) > 100 then
      Strings[115] := '100.0000'; // 20111208
    Strings[115] := FormatFloat('##0.0000', Vl(Strings[115])); // 20111208
    Tv[115] := Vl(Strings[115]); // 20111209
    Tv[24] := Vl(Strings[24]); // 20111208
    {t1 only
    If Vl(Strings[24]) > 0 then // Tv[24] >0 then //20111208
    begin
      Strings[22] := GetSpouseFirstName(RetNo);
      Strings[117] := GetSpouseLastName(RetNo);
      Strings[119] := LeftStr(GetSpouseAddress(RetNo), 33);
    end
    else
      Strings[22] := '';
    }
    { Partners }
    i := 24;
    repeat
      Tv[i] := Vl(Strings[i]);
      If (Tv[i] < 0) or (Tv[i] > 100) then
      begin
        Tv[i] := 0;
        Strings[i] := '';
      end;
      Inc(i, 4);
    until i > 44;
    // sins
    i := 118;
    repeat
      Strings[i] := RemoveChar(Strings[i], ' ');
      Strings[i] := RemoveChar(Strings[i], '-');
      Inc(i, 2);
    until i > 128;

    // get autoexpenses
    If UpperCase(Strings[142]) <> 'Y' then
    begin
      ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,
        AutoCCAForStmt);
      Tv[72] := 0;
      For i := 0 to ExtractedAutoList.count - 1 do
      begin
        ExtractedAutoRec := ExtractedAutoList.Items[i];
        If ExtractedAutoRec.PartnerFlag = '' then
          Tv[72] := Tv[72] + ExtractedAutoRec.ExpensesClaimed;
      end;
    end;

    i := 58;
    repeat
      If (UpperCase(Strings[140]) = 'Y') and (Tv[139] > 0) and (Tv[i - 1] > 0)
      then
        Tv[i] := Tv[139];
      If (Tv[i] < 0) or (Tv[i] > 100) then
        Tv[i] := 0;
      Inc(i, 3);
    until i > 91;
    If (UpperCase(Strings[140]) = 'Y') and (Tv[139] > 0) and (Tv[130] > 0) then
      Tv[95] := Tv[139];
    If (Tv[95] < 0) or (Tv[95] > 100) then
      Tv[95] := 0;

    Tv[143] := Tv[24] + Tv[28] + Tv[32] + Tv[36] + Tv[40] + Tv[44];
    Strings[143] := FormatFloat('##0.0000', Tv[143]); // 20111208
    i := 23;
    Repeat
      Strings[i + 1] := FormatFloat('##0.0000', Vl(Strings[i + 1])); // 20111208
      Tv[i + 1] := Vl(Strings[i + 1]);
      If Tv[i + 1] = 0 then
        Strings[i + 1] := '';
      Tv[i] := (Tv[103] * Tv[i + 1]) / 100;
      i := i + 4;
    until i > 43;

    { Calc Income }
    If UpperCase(Strings[113]) <> 'Y' then
    begin
      Tv[116] := Tv[47] + Tv[50] + Tv[53];
      Tv[56] := Tv[116] + Tv[55];
    end;
    { Calc Expenses }
    Tv[97] := 0;
    Tv[99] := 0;
    { Horizontal }
    i := 57;
    Repeat
      Tv[i + 2] := (Tv[i] * Tv[i + 1]) / 100;
      i := i + 3;
    until i > 90;
    Tv[96] := (Tv[130] * Tv[95]) / 100;
    Tv[135] := (Tv[131] * Tv[134]) / 100;
    Tv[137] := (Tv[133] * Tv[136]) / 100;
    Tv[94] := Tv[130] + Tv[131] + Tv[133];
    { Vertical }
    i := 57;
    Repeat
      Tv[97] := Tv[97] + Tv[i];
      Tv[99] := Tv[99] + Tv[i + 2];
      i := i + 3;
    until i > 90;
    Tv[97] := Tv[97] + Tv[94];
    Tv[99] := Tv[99] + Tv[96] + Tv[135] + Tv[137];

   // If UpperCase(Strings[113]) <> 'Y' then  //what is this?
   // begin
      Tv[102] := Tv[97] - Tv[99];
      Tv[103] := Tv[56] - Tv[102];
      Tv[104] := (Tv[103] * Vl(Strings[18])) / 100; // (Tv[103] * Tv[18]) / 100;
      Tv[8] := Tv[104] - Tv[7];
      //20200520
      // recapt
      ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
      Tv[20] := RecaptAmount;
      ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, AutoCCAForStmt);
      Tv[20] := Tv[20] + RecaptAmount;
      Tv[20] := Tv[20] * Tv[114] / 100; // Apr 4 2008
      // Term loss
      ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,CCAForStmt);

      Tv[21] := Tv[8] + Tv[20];
      Tv[100] := Tv[21] - Tv[98];
      Tv[98] := TermLossAmount;
      ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);
      Tv[98] := Tv[98] + TermLossAmount;
      Tv[98] := Tv[98] * Tv[114] / 100;
      // CCA
      ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,CCAForStmt);
      Tv[105] := CCAForStmt;
      ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,
        AutoCCAForStmt);
      Tv[105] := Tv[105] + AutoCCAForStmt;
      Tv[105] := Tv[105] * Tv[114] / 100;
      Tv[101] := Tv[100] - Tv[105];
      Tv[107] := Tv[101] * Tv[115] / 100;
      Tv[106] := Tv[107] + Tv[144] - Tv[108]; // 20100128
    //end;
  end; { End with }

  // pg 2
  with ret[RetNo].Frm[FNo] do
  begin
    ret[RetNo].Frm[FNo].Strings[359] := '';
    Tv[359] := 0; // term loss  Feb 23 2008
    ret[RetNo].Frm[FNo].Strings[383] := '';
    Tv[383] := 0; // recapture Feb 23 2008;
    Strings[367] := FInst + ' - ' + FetchElm(RetNo, 'T776' + FInst, 45);
    Stmt := LeftStr(FName, 4);
    { CCA }
    Tv[265] := 0; // total cca
    { cca - nonmotor veh }
    If PostCCaFromAssetsB(RetNo) then
    begin
      PostNonVehicleCCA(RetNo, FName, Stmt, FInst, FNo, 201, 237, 9, 245,
        264, 265);
      Tv[359] := 0;
      Tv[383] := 0;
    end
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
    Tv[381] := 0;
    Tv[381] := Tv[208] + Tv[217] + Tv[226] + Tv[235] + Tv[244] + Tv[264];
    // CCA Motor vehicle
    ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount, AutoCCAForStmt);

    For i := 246 to 254 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
    end; // clear section
    For i := 255 to 263 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
    end; // clear section
    Tv[380] := 0; // suppl clear
    RemainingAmount := 0;
    j := 246;
    For i := 0 to ExtractedAutoList.count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag = '' then
      begin
        If j > 255 then
          RemainingAmount := RemainingAmount + ExtractedAutoRec.CCAClaimed
        else
        begin
          Strings[j] := ExtractedAutoRec.ClassId;
          Tv[j + 1] := ExtractedAutoRec.UccStart;
          Tv[j + 2] := ExtractedAutoRec.Additions;
          Tv[j + 3] := ExtractedAutoRec.Proceeds; // feb 2008
          Tv[j + 4] := ExtractedAutoRec.UCCAfter;
          // 20190217    // Tv[j+4]:=ExtractedAutoRec.Adjustments;
          Tv[j + 5] := ExtractedAutoRec.BaseAmount;
          Strings[j + 6] := FormatFloat('###.##', ExtractedAutoRec.Rate);
          Tv[j + 7] := ExtractedAutoRec.CCAClaimed;
          Tv[j + 8] := ExtractedAutoRec.UCCEnd;
          // 20190216Con
          Tv[i + 168] := ExtractedAutoRec.AiiPAdditions;
          Tv[i + 170] := ExtractedAutoRec.AiiPProceeds;
          Tv[i + 172] := ExtractedAutoRec.AiiPUccAdj;
          Inc(j, 9); // dummy
        end;
      end;
    end;
    Tv[380] := RemainingAmount;
    Tv[382] := 0;
    Tv[382] := Tv[253] + Tv[262] + Tv[380];

    Tv[265] := Tv[381] + Tv[382];

    // 20140122
    i := 202;
    j := 146;
    Repeat
      Tv[j] := Tv[i] + Tv[i + 1] - Tv[i + 2];
      Inc(i, 9);
      Inc(j, 1);
    until i > 238;

    // 20140122
    i := 247;
    j := 151;
    Repeat
      Tv[j] := Tv[i] + Tv[i + 1] - Tv[i + 2];
      Inc(i, 9);
      Inc(j, 1);
    until i > 256;

    { equip additions }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 267, 277, 5,
          281, 368, 288);
    end;
    i := 269;
    Tv[288] := 0;
    Repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[288] := Tv[288] + Tv[i + 2];
      i := i + 5;
    Until i > 279;
    // AUTO additions
    { motor additions }
    // get autoexpenses
    Stmt := LeftStr(FName, 4);
    ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    For i := 282 to 286 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
    end; // clear section
    For i := 369 to 373 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
    end; // clear section
    Tv[287] := 0; // clear suppl
    RemainingAmount := 0;

    j := 282;
    For i := 0 to ExtractedAutoList.count - 1 do
    begin
      ExtractedAutoRec := ExtractedAutoList.Items[i];
      If ExtractedAutoRec.PartnerFlag = '' then
      begin
        If ExtractedAutoRec.Additions > 0 then
        begin
          If j > 369 then
            RemainingAmount := MaxR(0, RemainingAmount + ExtractedAutoRec.Cost -
              ExtractedAutoRec.Cost * ExtractedAutoRec.ProceedsPersonal)
          else
          begin
            Strings[j] := ExtractedAutoRec.ClassId;
            Strings[j + 1] := ExtractedAutoRec.Description;
            Tv[j + 2] := ExtractedAutoRec.Cost;
            Tv[j + 4] := MaxR(0, Tv[j + 2] - Tv[j + 3]);
            Inc(j, 87);
          end;
        end;
      end;
    end;
    Tv[287] := RemainingAmount;

    Tv[288] := Tv[288] + Tv[368] + Tv[373] + Tv[287];

    { build additions }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 289, 304, 5,
          308, 309, 310);
    end;
    i := 291;
    Tv[310] := 0;
    Repeat
      Tv[i + 2] := Tv[i] - Tv[i + 1];
      Tv[310] := Tv[310] + Tv[i + 2];
      i := i + 5;
    Until i > 306;
    Tv[310] := Tv[310] + Tv[309];

    { equip disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostNonBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 311, 321, 5,
          325, 374, 382);
    end;
    i := 313;
    Tv[332] := 0;
    Repeat
      Tv[i + 2] := MaxR(0, Tv[i] - Tv[i + 1]);
      Tv[332] := Tv[332] + Tv[i + 2];
      // Tv[132] := Tv[132] + Tv[I+2];   //20110109
      i := i + 5;
    Until i > 323; // 128

    // motor disp
    // get autoexpenses
    Stmt := LeftStr(FName, 4);
    ExtractAutos(RetNo, Stmt, FInst, TermLossAmount, RecaptAmount,
      AutoCCAForStmt);
    For i := 326 to 330 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
    end; // clear section
    For i := 375 to 379 do
    begin
      Tv[i] := 0;
      Strings[i] := '';
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
            Strings[j] := ExtractedAutoRec.ClassId;
            Strings[j + 1] := ExtractedAutoRec.Description;
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

    { build disp }
    If PostCCaFromAssetsB(RetNo) then
    begin
      If PostCCaFromAssetsB(RetNo) then
        PostBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 333, 348, 5,
          352, 353, 354);
    end;
    i := 335;
    Tv[354] := 0;
    Repeat
      Tv[i + 2] := Tv[i] - Tv[i + 1];
      Tv[354] := Tv[354] + Tv[i + 2];
      i := i + 5;
    Until i > 350;
    Tv[354] := Tv[354] + Tv[353];
    {
    // 20130306
    If Length(OptRec.Bus_Disclm) > 0 then
      Strings[390] := OptRec.Bus_Disclm
    else
      Strings[390] := '';
    }
  end; { End with }

  SaveTv(RetNo, FName, FNo);

end;


end.
