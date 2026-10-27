unit T1_2026CalcBus;

interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T1_2026Declare, T1_2026common, T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns; //20160119 Igor

    procedure MIA(RetNo: integer; FName: String;FNo: integer);
    Procedure CCAMULT(RetNo:integer;FName:string;FNo:integer);
    Procedure DEPLEXP(RetNo: integer; FName: String;FNo: integer);
    Procedure BUSSUM(RetNo: integer; FName: String;FNo: integer);
    Procedure CalcAuto(RetNo:integer;FName:string;FNo:integer;Stm:string);
    procedure ResInc(RetNo: integer; FName: String;FNo: integer);
    Procedure FORINC(RetNo:integer;FName:string;FNo:integer);
    procedure T1229(RetNo: integer; FName: String;FNo: integer);
    Procedure T2125(RetNo:integer;FName:string;FNo:integer);

    Procedure T2125Sum(RetNo: integer; FName: String;FNo: integer);
    Procedure T2121Sum(RetNo: integer; FName: String;FNo: integer);
    Procedure T2042Sum(RetNo: integer; FName: String;FNo: integer);
    Procedure T1163Sum(RetNo: integer; FName: String;FNo: integer);
    Procedure T1273Sum(RetNo: integer; FName: String;FNo: integer);
    procedure T776(RetNo: integer; FName: String; FNo: integer);
    Procedure T776Sum(RetNo: integer; FName: String;FNo: integer);

    Procedure T2042(RetNo:integer;FName:string;FNo:integer);

    Procedure T2121(RetNo:integer;FName:string;FNo:integer);

    {for Autoexp}
    Function GetLine5K(Yr:String):Real;
    Function GetLine6K(Yr:String):Real;
    Function GetLine7K(Yr:String):Real;

implementation
Uses vtCommon, //20160119 Igor
  T1_2026,
  T1_2026Calc,
  vtTrimStr,vtShared;


  Function GetLine5K(Yr:String):Real;  //yr is the starting leases year
//20260329
begin
 If Yr=''     then begin Result := 0;EXIT; end    //20241217
 else If Yr='2025' then begin Result := 42253;EXIT; end   //20241217  //20260329
 else If Yr='2024' then begin Result := 43529;EXIT; end   //20241217
 else If Yr='2023' then begin Result := 42353;EXIT; end ////20240121 //20240309
 else If Yr='2001' then begin Result := 40000;EXIT; end ////20240121
 else If Yr='2000' then begin Result := 31765;EXIT; end {2000 and till now}
 else If (Yr >'1997') and (Yr < '2000') then BEGIN result := 30588;EXIT; end
 else If Yr = '1997' then begin result := 29412;EXIT; end
 else If (Yr= '1990') and (Yr < '1997') then begin result := 28235;EXIT; end
 else If yr = '1990' then begin result := 23529;EXIT; end;
end;

Function GetLine6K(Yr:String):Real;
begin
 //20260329
 If Yr>='2025' then Result := 950
 ELSE If Yr>='2024' then Result := 1050 //20241217
 ELSE If Yr>='2023' then Result := 950 //20240121
 ELSE If Yr>='2001' then Result := 900 //800;     //20221206
 ELSE If Yr='2000' then Result := 700
 ELSE If (Yr >'1997') and (Yr < '2000') then result := 650
 ELSE If Yr = '1997' then result := 550
 ELSE If (Yr >'1990') and (Yr < '1997') then result := 650
 ELSE If yr < '1990' then result := 600
 ELSE If Yr='' then result:=0;
end;

Function GetLine7K(Yr:String):Real;
//20260329
begin
 If Yr>='2025' then Result := 38000 //20241217 //20260329
 Else If Yr='2024' then Result := 37000 //20241217
 Else If Yr>='2023' then Result := 36000 //20240121
 Else If Yr>='2001' then Result := 34000 //20221206 30000;
 Else If Yr='2000' then Result := 27000
 Else If (Yr >'1997') and (Yr < '2000') then result := 26000
 Else If Yr = '1997' then result := 25000
 Else If (Yr >'1990') and (Yr < '1997') then result := 24000
 Else If yr < '1990' then result := 20000
 Else If Yr='' then result :=0;
end;

Procedure FORINC(RetNo:integer;FName:string;FNo:integer);
var i,k,col,OthEmplFNo:Integer; //,T626FNo: integer;  //20161119
Begin
 //20260329
  LoadTv(RetNo,FName,FNo);
  With ret[RetNo], ret[RetNo].Frm[Fno] do
  begin
    {Foreign Pension}
    Tv[4]:=0;Tv[5]:=0;  //20121225  ONLY if both I and T are there
    If (GetFPENSByCountry(RetNo,'1','I')>0) and (GetFPENSByCountry(RetNo,'1','T')>0) then
    Begin
     Tv[4] := GetFPENSByCountry(RetNo,'1','I'); {income}
     Tv[5] := GetFPENSByCountry(RetNo,'1','T'); {Tax}
    end;

    Tv[6]:=0;Tv[7]:=0;
    If (GetFPENSByCountry(RetNo,'2','I')>0) and (GetFPENSByCountry(RetNo,'2','T')>0) then
    Begin
     Tv[6] := GetFPENSByCountry(RetNo,'2','I');
     Tv[7] := GetFPENSByCountry(RetNo,'2','T');
    end;

    Tv[8]:=0;Tv[9]:=0;
    If (GetFPENSByCountry(RetNo,'3','I')>0) and (GetFPENSByCountry(RetNo,'3','T')>0) then
    Begin
     Tv[8] := GetFPENSByCountry(RetNo,'3','I');
     Tv[9]:= GetFPENSByCountry(RetNo,'3','T');
    end;

    Tv[121]:= GetFPENSByCountry(RetNo,'1','E'); {exempt income}
    Tv[123] := GetFPENSByCountry(RetNo,'2','E');
    Tv[124] := GetFPENSByCountry(RetNo,'3','E');

    //20120129
    For i:=17 to 22 do Tv[i]:=0;

    //for empl
    OthEmplFNo:=GetFormNo('OTHEMPL');

    Tv[17]:=Vl(FetchElmFNo(RetNo,OthEmplFNo,17));
    Tv[18]:=Vl(FetchElmFNo(RetNo,OthEmplFNo,18));
   // T626FNo:=GetFormNo('T626#1');  //20161119
    {
    If ret[RetNo].FrmHasData[T626FNo] then  //20120129
    begin
     Tv[17]:=Tv[17]-Vl(FetchElmFNo(RetNo,T626Fno,102));
     Tv[18]:=Tv[18]-Vl(FetchElmFNo(RetNo,T626Fno,130));
    end;
    }
    Tv[19]:=Vl(FetchElmFNo(RetNo,OthEmplFNo,19));
    Tv[20]:=Vl(FetchElmFNo(RetNo,OthEmplFNo,20));
    {
    T626FNo:=GetFormNo('T626#2');
    If ret[RetNo].FrmHasData[T626FNo] then  //20120129
    begin
     Tv[19]:=Tv[19]-Vl(FetchElmFNo(RetNo,T626Fno,102));
     Tv[20]:=Tv[20]-Vl(FetchElmFNo(RetNo,T626Fno,130));
    end;
    }

    Tv[21]:=Vl(FetchElmFNo(RetNo,OthEmplFNo,21));
    Tv[22]:=Vl(FetchElmFNo(RetNo,OthEmplFNo,22));
    {
    T626FNo:=GetFormNo('T626#3');
    If ret[RetNo].FrmHasData[T626FNo] then  //20120129
    begin
     Tv[21]:=Tv[21]-Vl(FetchElmFNo(RetNo,T626Fno,102));
     Tv[22]:=Tv[22]-Vl(FetchElmFNo(RetNo,T626Fno,130));
    end;
    }
    //20111114
    {
    If (Tv[17]>0) and (UpperCase(LeftStr(FRM[Fno].Strings[1],3))='USA') then Tv[17]:=MaxR(0,Tv[17]-Vl(FetchElm(RetNo,'RC268',7)));
    If (Tv[19]>0) and (UpperCase(LeftStr(FRM[Fno].Strings[2],3))='USA') then Tv[19]:=MaxR(0,Tv[19]-Vl(FetchElm(RetNo,'RC268',7)));
    If (Tv[21]>0) and (UpperCase(LeftStr(FRM[Fno].Strings[3],3))='USA') then Tv[21]:=MaxR(0,Tv[21]-Vl(FetchElm(RetNo,'RC268',7)));
    }


    (*  //20161119
    //T626  #1
    For k:=1 to 3 do
    begin
     T626FNo:=GetFormNo('T626#'+AllTrim(IntToStr(k)));
     If T626FNo>0 then  //20101219
     Begin
     If Vl(FetchElmFNo(RetNo,T626FNo,130)) >0 then  //paid foreign taxes
     begin
      If FetchElmFNo(RetNo,T626FNo,131)='1' then      //first instance
      begin
       Tv[17]:=Tv[17]+Vl(FetchElmFNo(RetNo,T626FNo,110));
       Tv[18]:=Tv[18]+Vl(FetchElmFNo(RetNo,T626FNo,130));
      end;
      If FetchElmFNo(RetNo,T626FNo,131)='2' then
      begin
       Tv[19]:=Tv[19]+Vl(FetchElmFNo(RetNo,T626FNo,110));
       Tv[20]:=Tv[20]+Vl(FetchElmFNo(RetNo,T626FNo,130));
      end;
      If FetchElmFNo(RetNo,T626FNo,131)='3' then
      begin
       Tv[21]:=Tv[21]+Vl(FetchElmFNo(RetNo,T626FNo,110));
       Tv[22]:=Tv[22]+Vl(FetchElmFNo(RetNo,T626FNo,130));
      end;
     end;
     end;
    end;
    *)

    {For investment income}
            {ret,Slip,Row,exhrow,sharerow,countrycode,countryrow}
    Tv[43]:= GetForeignFromSlip(RetNo,'T4PS',7,0,0,0,0)+  {country 1 always}
             MaxR(0,GetForeignFromSlip(RetNo,'T4PS',8,0,0,0,0))+
             T5FNonBusInc1+ {country 1}
             T3FNonBusInc1+
             T5013FNonBusInc1;  {country 1}
    Tv[45]:= T5FNonBusInc2+ {country 2}
             T3FNonBusInc2+
             T5013FNonBusInc2;
    Tv[47]:= T5FNonBusInc3+  {country 3}
             T3FNonBusInc3+
             T5013FNonBusInc3;
    {For investment tax} {ret,Slip,Row,exhrow,sharerow,countrycode,countryrow}
    Tv[44]:= GetForeignFromSlip(RetNo,'T4PS',9,0,0,0,0)+
             T5FNonBusTax1+ {GetForeignFromSlip(RetNo,'T5',10,4,2,1,5)+}
             T3FNonBusTax1+
             T5013FNonBusTax1;
    Tv[46] := T5FNonBusTax2+ {country 2}
              T3FNonBusTax2+
              T5013FNonBusTax2;
    TV[48] := T5FNonBusTax3+ {country 3}
              T3FNonBusTax3+
              T5013FNonBusTax3;

    {NON BUS totals}
    col :=0;
    Repeat
      Tv[37+Col] := Tv[04+Col]+Tv[10+Col]+Tv[17+Col]+Tv[24+Col]+Tv[31+Col];
      inc(Col);
    until Col > 5;
    {Invstm totals}
    col :=0;
    Repeat
      Tv[70+Col] := Tv[43+Col]+Tv[50+Col]+Tv[57+Col]+Tv[64+Col];
      inc(Col);
    until Col > 5;
  {Rental totals}
    col :=0;
    Repeat
      Tv[103+Col] := Tv[76+Col]+Tv[83+Col]+Tv[90+Col]+Tv[97+Col];
      inc(Col);
    until Col > 5;
    {Tot Non Bus}
    col :=0;
    Repeat
       Tv[109+Col] := Tv[37+Col]+Tv[70+Col]+Tv[103+Col];
       inc(Col);
    until Col > 5;

    (*     //20161119
    //T626
    for i:=145 to 150 do Tv[i]:=0;
    For k:=1 to 3 do  //20111120
    Begin
     T626FNo:=GetFormNo('T626#'+AllTrim(IntToStr(k)));   //20111120
     If T626FNo >0 then  //20101217
     begin
      If Vl(FetchElmFNo(RetNo,T626FNo,130)) >0 then   //if tax on T626   //20111120
      //If Vl(FetchElmFNo(RetNo,T626FNo,30)) >0 then   //if tax on T626
      begin
       If FetchElmFNo(RetNo,T626FNo,131)= '1' then   //country code  //20111120
       // If FetchElmFNo(RetNo,T626FNo,31)= '1' then   //country code
       begin
         Tv[145]:=Vl(FetchElmFNo(RetNo,T626FNo,125));  //least of E and F in T626
         If Vl(FetchElmFNo(RetNo,T626FNo,110)) >0 then  {empl inc after deductions}  //20111120
           Tv[146]:= Vl(FetchElmFNo(RetNo,T626FNo,130)) * Tv[145]/Vl(FetchElmFNo(RetNo,T626FNo,110));
       end;
       If FetchElmFNo(RetNo,T626FNo,131)= '2' then
       begin
         Tv[147]:=Vl(FetchElmFNo(RetNo,T626FNo,125));  //least of E and F in T626
         If Vl(FetchElmFNo(RetNo,T626FNo,110)) >0 then  {empl inc after deductions}
           Tv[148]:= Vl(FetchElmFNo(RetNo,T626FNo,130)) * Tv[147]/Vl(FetchElmFNo(RetNo,T626FNo,110));
       end;
       If FetchElmFNo(RetNo,T626FNo,131)= '3' then
       begin
         Tv[149]:=Vl(FetchElmFNo(RetNo,T626FNo,125));  //least of E and F in T626
         If Vl(FetchElmFNo(RetNo,T626FNo,110)) >0 then  {empl inc after deductions}
           Tv[150]:= Vl(FetchElmFNo(RetNo,T626FNo,130)) * Tv[150]/Vl(FetchElmFNo(RetNo,T626FNo,110));
       end;
      end;
     end;
    end; //k
    *)
    {S(11) deduction/investm only}
    Tv[127] := MaxR(0,tv[71] -Tv[70] * 0.15);Tv[128] := Tv[127];
    Tv[129] := MaxR(0,Tv[73] -Tv[72] * 0.15); Tv[130] := Tv[129];
    Tv[131] := MaxR(0,Tv[75] -Tv[74] * 0.15);Tv[132] := Tv[131];
    {Net Non inv income}
    Col:=0;
    Repeat
     Tv[157+Col] := MaxR(0,Tv[109+Col] - Tv[115+Col]-Tv[121+col]-Tv[127+Col]-
                    Tv[133+Col] - Tv[139+Col]-Tv[145+col]-Tv[151+Col]);
    Inc(Col);
    until Col >5;

    {Foreign Business Income}
    Tv[163]:= T3FBusInc1; {country 1}
    Tv[165]:= T3FBusInc2; {country 2}
    Tv[167]:= T3FBusInc3; {country 3}
    Tv[169]:= T5013FBusInc1; {country 1}
    Tv[171]:= T5013FBusInc2; {country 2}
    Tv[173]:= T5013FBusInc3; {country 3}
    {For Business Tax}
    Tv[164]:= T3FBusTax1; {country 1}
    Tv[166]:= T3FBusTax2; {country 2}
    Tv[168]:= T3FBusTax3; {country 3}
    Tv[170]:= T5013FBusTax1; {country 1}
    Tv[172]:= T5013FBusTax2; {country 2}
    Tv[174]:= T5013FBusTax3; {country 3}

    {Bus totals}
    col :=0;
    Repeat
      Tv[189+Col] := Tv[163+Col]+Tv[169+Col]+Tv[176+Col]+Tv[183+Col];
      inc(Col);
    until Col > 5;

    col :=0;
    Repeat
      Tv[207+Col] := MaxR(0,Tv[189+Col]-Tv[195+Col]-Tv[201+Col]);
      inc(Col);
    until Col > 5;

    Tv[225] := Tv[157]+Tv[207];
    Tv[226] := Tv[159]+Tv[209];
    Tv[227] := Tv[161]+Tv[211];

    Tv[228] := Tv[158]+Tv[208];
    Tv[229] := Tv[160]+Tv[210];
    Tv[230] := Tv[162]+Tv[212];

end;
    {save data}
SaveTv(RetNo,FName,FNo);
{initialize fed/prov credits}
End;

Procedure RESINC(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   Tv[10] := Tv[1] +tv[2]+Tv[3]+Tv[4]+tv[5]+tv[7]+TV[9]+Tv[59];
   Tv[18] := Tv[11] +tv[12]+Tv[13]+Tv[15]+tv[17];
   Tv[19] := tv[10] - Tv[18];
   Tv[20] := ret[RetNo].T102PShipInc;
   Tv[21] := Tv[12];
   If Vl(FetchElm(RetNo,'T1229',30))<0 then
      Tv[22] := ABS(Vl(FetchElm(RetNo,'T1229',30)))
   else
      Tv[22] :=0;
   If Vl(FetchElm(RetNo,'T1229',29))<0 then
      Tv[23] := ABS(Vl(FetchElm(RetNo,'T1229',29)))
   else
      Tv[23] :=0;

   Tv[24] := Tv[20] +tv[21]+Tv[22]+Tv[23];
   Tv[26] := 0;  //Tv[19] /4;    //20100328
   Tv[27] := Tv[59];
   Tv[29] := Vl(FetchElm(RetNo,'T1229',42));
   Tv[30] := Vl(FetchElm(RetNo,'T1229',41));
   Tv[31] := Vl(FetchElm(RetNo,'T1229',40));

   Tv[36] := Tv[26] +Tv[27]+Tv[28]+Tv[29]+Tv[30] +tv[31]+Tv[33]+Tv[35];
   Tv[37] := Tv[19] +Tv[24]-Tv[36];

   Tv[38] := Vl(FetchElm(RetNo,'DEPLEXP',12));
   Tv[39] := Vl(FetchElm(RetNo,'DEPLEXP',13));

   Tv[44] := Tv[38] +tv[39]+Tv[41]+Tv[43];
   Tv[45] := tv[37] - Tv[44];
   Tv[53] := Tv[46] +Tv[47]+Tv[48]+Tv[50]+Tv[52];
   Tv[54] := MaxR(0,Vl(FetchElm(RetNo,'T1229',43)));
   Tv[57] := Tv[54] +tv[56];
   Tv[58] := Tv[45] +tv[53]-Tv[57];
   Tv[25] := Vl(FetchElm(RetNo,'DEPLEXP',17))+
             Vl(FetchElm(RetNo,'DEPLEXP',20));
   Tv[61] := Vl(FetchElm(RetNo,'DEPLEXP',18))
            +Vl(FetchElm(RetNo,'DEPLEXP',21));
   Tv[60] := Tv[58] + Tv[25]+Tv[61];
  end;
  SaveTv(RetNo,FName,FNo);

end;

Procedure T1229(RetNo: integer; FName: String;FNo: integer);
Var i,k:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
   {clear previous entries}
   For i:=74 to 107 do begin Strings[i]:='';Tv[i]:=0;end;


  {??? //20240409
   If Ret[RetNo].DataVersion ='a' then
   begin
    for i:=25 to 28 do Tv[i]:=0;
    Tv[7]:=0;
    Tv[15]:=0;
   end;
  }
  // Tv[72]:=0;
  // Tv[48]:=TotMultiple(RetNo,'T101',17)+TotMultiple(RetNo,'T5013',53);  //itc
 //  Tv[18]:=TotMultiple(RetNo,'T5013',71);  //202304 12 itc

   Tv[52]:=Tv[48]+Tv[49]+Tv[50]+Tv[51];
   Tv[4]:=Tv[18]+Tv[16]+Tv[12]+Tv[8]; //20240409
   {Collect from T101 and T5013}
   k:=74-7;  //67
   for i :=0 to (FList.Count - 1) do
   begin
     FRec := FList.Items[i];
     If (Frec.FormName = 'T101')  then
     begin
      If Vl(FetchElmFNo(RetNo,Frec.FormNo,14))+
         Vl(FetchElmFNo(RetNo,Frec.FormNo,15))>0 then
      begin
       Inc(K,7);
       If K<= 88 then  {else no room to put it, instead extra line}
       begin
        {CEE}
        strings[k]:=FetchElmFNo(RetNo,Frec.FormNo,1);
        Tv[k+1]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,2)); {Renunc}
        Tv[k+3]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,5)); {Assist}
        {CDE}
        Tv[k+4]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,3)); {Renunc}
        Tv[k+6]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,12)); {Renunc}
       end
       else {CEE overflow}
       begin
        Tv[95]:=Tv[95]+Vl(FetchElmFNo(RetNo,Frec.FormNo,2)); {Renunc}
        Tv[97]:=TV[97]+Vl(FetchElmFNo(RetNo,Frec.FormNo,5)); {Assist}
        {CDE ovrflow}  //july 2007
        Tv[98]:=Tv[98]+Vl(FetchElmFNo(RetNo,Frec.FormNo,3)); {Renunc}
        Tv[100]:=Tv[100]+Vl(FetchElmFNo(RetNo,Frec.FormNo,12)); {Assist}
       end;
      end; {there is cce or cde}
     end; {T101}

     {5013}
     If (Frec.FormName = 'T5013') then
     begin
      If Vl(FetchElmFNo(RetNo,Frec.FormNo,44))+Vl(FetchElmFNo(RetNo,Frec.FormNo,48))>0
     // If Vl(FetchElmFNo(RetNo,Frec^.FormNo,47))+Vl(FetchElmFNo(RetNo,Frec^.FormNo,51))>0
      then  {CEE or CDE}
      begin
       Inc(k,7);
       If K<= 88 then  {else no room to put it, instead extra line}
       begin  {T5013 CEE}
        strings[k]:='(T5013 slip)';
        Tv[k+1]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,44)); {Renunc}
        Tv[k+3]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,20)); {Assist} //Vl(FetchElmFNo(RetNo,Frec^.FormNo,46)); {Assist}
        {CDE}
        Tv[k+4]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,48)); {Renunc}
        Tv[k+6]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,50)); {assist}
       end
       else
       begin  {CEE overflow}
        Tv[95]:=Tv[95]+Vl(FetchElmFNo(RetNo,Frec.FormNo,44)); {Renunc}
        Tv[97]:=Tv[97]+Vl(FetchElmFNo(RetNo,Frec.FormNo,20)); {Assist}
        {CDE overflow}
        Tv[98]:=Tv[98]+Vl(FetchElmFNo(RetNo,Frec.FormNo,48)); {Renunc}
        Tv[100]:=Tv[100]+Vl(FetchElmFNo(RetNo,Frec.FormNo,50)); {Renunc}
       end;
      end; {tere is CEE or CDE}
     end; {T5013}
   end;
   Tv[101]:=AddColumns(75,89,7)+Tv[95];
   Tv[102]:=AddColumns(76,90,7)+Tv[96];
   Tv[103]:=AddColumns(77,91,7)+Tv[97];
   Tv[104]:=AddColumns(78,92,7)+Tv[98];
   Tv[105]:=AddColumns(79,93,7)+Tv[99];
   Tv[106]:=AddColumns(80,94,7)+Tv[100];
   Tv[107] := TotMultiple(RetNo,'T101',20)+TotMultiple(RetNo,'T5013',66);
   Tv[72] := TotMultiple(RetNo,'T101',19)+TotMultiple(RetNo,'T5013',55);


   Strings[33] :='100';
   Strings[34] := '30';
   Strings[35] := '10';
   {CEE}
   Tv[5] :=Tv[101];
   Tv[53]:=ret[RetNo].T5013CEE; //+ret[RetNo].T101CEE+ret[RetNo].T102CEE
   Tv[59]:=Tv[5]+Tv[53]+Tv[9];
   Tv[13]:= Tv[103];
   Tv[21] := TotMultiple(RetNo,'T5013',16);
   {//20240409
   Tv[68]:=Vl(FetchElm(RetNo,'ON479',128))
           +Vl(FetchElm(RetNo,'T1231',7))
           +Vl(FetchElm(RetNo,'SK428',133))
           +Vl(FetchElm(RetNo,'MB428',104));  //20090415
   }
   Tv[108]:=Tv[13]+Tv[67]+Tv[68]+Tv[21]+Tv[25];//20170130  //Tv[108]:=Tv[13]+Tv[67]+Tv[68]+Tv[17]+Tv[21]+Tv[25];
   //totals
   Tv[29] := MaxR(0,Tv[1]+tv[59]-Tv[108]);
   Tv[36] := MaxR(0,Tv[29] * MyStrToInt(Strings[33]) /100);
   If UpperCase(Strings[63]) <> 'Y' then Tv[40] := Tv[36];
   Tv[44] := MaxR(0,Tv[29] -Tv[40]);
   {CDE}
   Tv[6] :=Tv[104];
   Tv[54]:=ret[RetNo].T5013CDE; //+ret[RetNo].T101CDE+ ret[RetNo].T102CDE
   Tv[60]:=Tv[6]+Tv[54]+Tv[10];
   Tv[14]:=Tv[106];
   Tv[22]:= TotMultiple(RetNo,'T5013',21);
   Tv[109]:=Tv[14]+Tv[22]+Tv[26]; //20170130 //Tv[109]:=Tv[14]+Tv[18]+Tv[22]+Tv[26];

   Tv[30] := Tv[2]+Tv[60]-Tv[109];
   Tv[37] := MaxR(0,Tv[30] * MyStrToInt(Strings[34]) /100);
   If UpperCase(Strings[63]) <> 'Y' then Tv[41] := Tv[37];
   Tv[45] := MaxR(0,Tv[30]-Tv[41]);

   {COGPE}
   Tv[55]:= ret[RetNo].T101COGPE+ret[RetNo].T102COGPE+ret[RetNo].T5013COGPE;
   Tv[61]:=Tv[55]+Tv[11];
   Tv[23] := ret[RetNo].T101AllowCOGPE + ret[RetNo].T102AllowCOGPE
          +GetRowFromSlip(RetNo,'T5013',52,0,0);
   Tv[110]:=Tv[23]+Tv[27]; //20170130 //+Tv[56]; //Tv[110]:=Tv[19]+Tv[23]+Tv[27]; //+Tv[56];

   Tv[31] := Tv[3] +Tv[61]-Tv[110];

   Tv[38] := MaxR(0,Tv[31] * MyStrToInt(Strings[35]) /100);
   If UpperCase(Strings[63]) <> 'Y' then Tv[42] := Tv[38];
   Tv[46] := MaxR(0,Tv[31]-Tv[42]);

   //20200117
   Tv[56]:=Tv[17]+Tv[19];
   Tv[76]:=Tv[20];

   //PG 2

   Tv[79]:=Tv[39]+Tv[47];//Tv[108];  //20240414
   Tv[83]:=Tv[43]+Tv[57]; //Tv[110]; //20240414
   Tv[86]:=Tv[59];
   Tv[90]:=Tv[61];

   Tv[93]:=Tv[56];
   Tv[96]:=Tv[76];

   Tv[99]:=Tv[86]+Tv[93];
   Tv[102]:=Tv[90]+Tv[96];

   Tv[105]:=MaxR(0,Tv[79]-Tv[99]);
   Tv[118]:=MaxR(0,Tv[83]-Tv[102]);
   Tv[119]:=MaxR(0,Tv[56]-Tv[105]);
   Tv[120]:=MaxR(0,Tv[76]-Tv[118]);

   Tv[7]:=Tv[119]*15/100;
   Tv[65]:=Tv[120]*5/100;
   //Tv[121], tv[122:=  user entry
   //20240414
   Tv[123]:=Tv[29];//cde//Tv[29]-Tv[40]-Tv[56]); //Tv[44]-Tv[121];   //
   Tv[124]:=MaxR(0,Tv[30]-Tv[41]); //ccde//Tv[45];
   Tv[125]:=MaxR(0,Tv[31]-Tv[42]-Tv[122]); //ccogpe Tv[46]-Tv[122];

   Tv[64]:= Tv[40]+Tv[41]+Tv[42]+Tv[121]+Tv[122];
   //Tv[65]:= Tv[43];
   //Tv[112]:=ret[RetNo].T5013ResAllow; //GetRowFromSlip(RetNo,'T5013',32,0,0);
   //Tv[112]:=Tv[112]+TotMultiple(RetNo,'T5MULT',126); //GetRowFromSlip(RetNo,'T5',16,4,2);

   If Appyear='2004' then Tv[116]:=75
   else If Appyear='2005' then Tv[116]:=65
   else If Appyear='2006' then Tv[116]:=35
   else If Appyear>'2006' then Tv[116]:=0;

   Tv[66]:=Tv[64]+Tv[65]+Tv[117]; //+Tv[115];  //20200118
   Tv[69]:=Tv[52];
   Tv[70]:=Tv[68];
   Tv[71]:=MaxR(0,Tv[69]-Tv[70]);
   Tv[32]:=Tv[4]; //20260111 JZ/CZ
   Tv[24]:=MaxR(0,Tv[32]-Tv[28]);  //20230412

   Tv[114]:=Vl(FetchElm(RetNo,'DEPLEXP',18));
  end;
  SaveTv(RetNo,FName,FNo);

end;


Procedure BUSSUM(RetNo: integer; FName: String;FNo: integer);
Var I,k,T2125FldBus,T2121Fld,T2042Fld,T2125FldProf,NISAFld:integer;
    T2125CntBus,T2125CntProf,T2121Cnt,T2042Cnt,NISACnt:integer;
    FInst : string[3];
    TotFarmLoss,Deduction:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[Fno] do
  begin
    T2125FldBus:=1;T2125FldProf:=1;T2121Fld:=1;T2042Fld:=1;NISAFld :=1;
    T2125CntBus:=0;T2125CntProf:=0;T2121Cnt:=0;T2042Cnt:=0;NISACnt:=0;
    Tv[121]:=0; Tv[122]:=0;Tv[123]:=0;tv[124] :=0;Tv[149] :=0;

    for i:=1 to 149 do begin Strings[i]:='';Tv[i]:=0;end; //clear it
    k:=150;
    for i :=0 to (FList.Count - 1) do
    begin
     FRec := FList.Items[i];
     if (FRec.FormName = 'T2125')     //20101214
     and (ret[RetNo].FormHasData[FRec.FormName+Frec.FormInst])   //20160813
    // and (FetchElmFNo(RetNo,FRec^.FormNo,82)>'')  //business
     then
     begin
            Inc(T2125CntBus);
            FInst := FRec.FormInst;
            If T2125CntBus > 11 then
              begin
               T2125FldBus := 67;
               Strings[T2125FldBus] := '**** There are more ****';
               Strings[T2125FldBus+1] := '';
               Strings[T2125FldBus+2] := '';
               Tv[T2125FldBus+3] := 0;
               Tv[T2125FldBus+4] := 0;
               Tv[T2125FldBus+5] := 0;
               Tv[121] := tv[121]+Vl(FetchElm(RetNo,'T2125'+FInst,106));
              end
              else
              begin
               T2125FldBus :=(T2125CntBus-1)*6+1;
               Strings[T2125FldBus] := FetchElm(RetNo,'T2125'+FInst,8);
               Strings[T2125FldBus+1] := FetchElm(RetNo,'T2125'+FInst,4);
               Strings[T2125FldBus+2] := FetchElm(RetNo,'T2125'+FInst,5);
               Tv[T2125FldBus+3] := vl(FetchElm(RetNo,'T2125'+FInst,18));
               Tv[T2125FldBus+4] := Vl(FetchElm(RetNo,'T2125'+FInst,32));
               Tv[T2125FldBus+5] := Vl(FetchElm(RetNo,'T2125'+FInst,106));
               If FetchElm(RetNo,'T2125'+FInst,82)>'' then
               begin
                Strings[k] := 'B';
                Tv[121] := tv[121]+Vl(FetchElm(RetNo,'T2125'+FInst,106));
               end
               Else If FetchElm(RetNo,'T2125'+FInst,90)>'' then
               begin
                Strings[k] := 'P';
                Tv[122] := tv[122]+Vl(FetchElm(RetNo,'T2125'+FInst,106));
               end;
               Inc(K,1);
              end;

      end {end T2125bus}
      Else if (FRec.FormName = 'T2042') and
         (ret[RetNo].FormHasData[FRec.FormName+Frec.FormInst]) then  //20160813
      begin
            Inc(T2042Cnt);
            FInst := FRec.FormInst;
            If T2042Cnt > 3 then
              begin
               T2042Fld := 91;
               Strings[T2042Fld] := '**** There are more ****';
               Strings[T2042Fld+1] := '';
               Strings[T2042Fld+2] := '';
               Tv[T2042Fld+3] := 0;
               Tv[T2042Fld+4] := 0;
               Tv[T2042Fld+5] := 0;
               Tv[123] := Tv[123]+Vl(FetchElm(RetNo,'T2042'+FInst,148));
              end
              else
              begin
               T2042Fld :=(T2042Cnt-1)*6+73;
               Strings[T2042Fld] := FetchElm(RetNo,'T2042'+FInst,8);
               Strings[T2042Fld+1] := FetchElm(RetNo,'T2042'+FInst,4);
               Strings[T2042Fld+2] := FetchElm(RetNo,'T2042'+FInst,5);
               Tv[T2042Fld+3] := vl(FetchElm(RetNo,'T2042'+FInst,24));
               Tv[T2042Fld+4] := Vl(FetchElm(RetNo,'T2042'+FInst,66));
               Tv[T2042Fld+5] := Vl(FetchElm(RetNo,'T2042'+FInst,148));
               Tv[123] := Tv[123]+Vl(FetchElm(RetNo,'T2042'+FInst,148));
              end;
      end {end t2042}

      Else if (FRec.FormName = 'T1163') and
         (ret[RetNo].FormHasData[FRec.FormName+Frec.FormInst]) then  //20160813
      begin
            Inc(NISACnt);
            FInst := FRec.FormInst;
            If NISACnt > 3 then
              begin
               NISAFld := 143;
               Strings[NISAFld] := '**** There are more ****';
               Strings[NISAFld+1] := '';
               Strings[NISAFld+2] := '';
               Tv[NISAFld+3] := 0;
               Tv[NISAFld+4] := 0;
               Tv[NISAFld+5] := 0;
               Tv[149] := Tv[149]+Vl(FetchElm(RetNo,'T1163'+FInst,616));
              end
              else
              begin
               NISAFld :=(NISACnt-1)*6+125;
               Strings[NISAFld] := FetchElm(RetNo,'T1163'+FInst,201); //farm name
               Strings[NISAFld+1] := FetchElm(RetNo,'T1163'+FInst,213); //yr start
               Strings[NISAFld+2] := FetchElm(RetNo,'T1163'+FInst,214); //yr end
               Tv[NISAFld+3] := vl(FetchElm(RetNo,'T1163'+FInst,627));  //%
               Tv[NISAFld+4] := Vl(FetchElm(RetNo,'T1163'+FInst,352));  //gross
               Tv[NISAFld+5] := Vl(FetchElm(RetNo,'T1163'+FInst,616));   //net
               Tv[149] := Tv[149]+Vl(FetchElm(RetNo,'T1163'+FInst,616));
              end;
      end {end nisa}

      Else if (FRec.FormName = 'T1273') and
         (ret[RetNo].FormHasData[FRec.FormName+Frec.FormInst]) then    //20160813
      begin
            Inc(NISACnt);
            FInst := FRec.FormInst;
            If NISACnt > 3 then
              begin
               NISAFld := 143;
               Strings[NISAFld] := '**** There are more ****';
               Strings[NISAFld+1] := '';
               Strings[NISAFld+2] := '';
               Tv[NISAFld+3] := 0;
               Tv[NISAFld+4] := 0;
               Tv[NISAFld+5] := 0;
               Tv[149] := Tv[149]+Vl(FetchElm(RetNo,'T1163'+FInst,616));
              end
              else
              begin
               NISAFld :=(NISACnt-1)*6+125;
               Strings[NISAFld] := FetchElm(RetNo,'T1273'+FInst,201); //farm name
               Strings[NISAFld+1] := FetchElm(RetNo,'T1273'+FInst,213); //yr start
               Strings[NISAFld+2] := FetchElm(RetNo,'T1273'+FInst,214); //yr end
               Tv[NISAFld+3] := vl(FetchElm(RetNo,'T1273'+FInst,627));  //%
               Tv[NISAFld+4] := Vl(FetchElm(RetNo,'T1273'+FInst,352));  //gross
               Tv[NISAFld+5] := Vl(FetchElm(RetNo,'T1273'+FInst,616));   //net
               Tv[149] := Tv[149]+Vl(FetchElm(RetNo,'T1273'+FInst,616));
              end;
      end {end nisa}

      Else if (FRec.FormName = 'T2121') and
         (ret[RetNo].FormHasData[FRec.FormName+Frec.FormInst]) then  //20160813
      begin
            Inc(T2121Cnt);
            FInst := FRec.FormInst;
            If T2121Cnt > 3 then
              begin
               T2121Fld := 115;
               Strings[T2121Fld] := '**** There are more ****';
               Strings[T2121Fld+1] := '';
               Strings[T2121Fld+2] := '';
               Tv[T2121Fld+3] := 0;
               Tv[T2121Fld+4] := 0;
               Tv[T2121Fld+5] := 0;
               Tv[124] := Tv[124]+Vl(FetchElm(RetNo,'T2121'+FInst,74));
              end
              else
              begin
               T2121Fld :=(T2121Cnt-1)*6+97;
               Strings[T2121Fld] := FetchElm(RetNo,'T2121'+FInst,8);   //20190213 instead of 61
               Strings[T2121Fld+1] := FetchElm(RetNo,'T2121'+FInst,4);
               Strings[T2121Fld+2] := FetchElm(RetNo,'T2121'+FInst,5);
               Tv[T2121Fld+3] := vl(FetchElm(RetNo,'T2121'+FInst,18));
               Tv[T2121Fld+4] := Vl(FetchElm(RetNo,'T2121'+FInst,35));
               Tv[T2121Fld+5] := Vl(FetchElm(RetNo,'T2121'+FInst,74));
               Tv[124] := Tv[124]+Vl(FetchElm(RetNo,'T2121'+FInst,74));
              end;
      end; {end t2121}
   end; {loop thru forms}

 //20190516
   // restricted farm loss
   if (UpperCase(Strings[162])<>'Y') Or (Tv[123] >= 0) then
   begin
     for i:=163 to 168 do begin Tv[i]:=0;end;
   end
   Else
   Begin
    //t2042
    TotFarmLoss:=0;
    i:=78;
    Repeat
      if Tv[i]<0 then TotFarmLoss:=TotFarmLoss+Abs(Tv[i]);
      Inc(i,6);
    Until i>96;

    i:=130;
    Repeat
      if Tv[i]<0 then TotFarmLoss:=TotFarmLoss+Abs(Tv[i]);
      Inc(i,6);
    Until i>148;
    Tv[163]:=TotFarmLoss;
    if TotFarmLoss>=32500 then
      deduction:=17500
    else
      Deduction:= MinR(TotFarmLoss, (2500+ MaxR(0,TotFarmLoss-2500)*0.50));
    Tv[168]:=-Deduction;  //ln 141
    Tv[167]:=Tv[163]-deduction;
   End;
 end;  {end with Ret...}

SaveTv(RetNo,FName,FNo);
end; {end routine}



Procedure DEPLEXP(RetNo: integer; FName: String;FNo: integer);
Var ResFNo:Integer;x:Real;
Begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   Tv[10] := MinR(MaxR(0,Vl(FetchElm(RetNo,'RESINC',37)))*25/100,Tv[8]);
   Tv[12]:=Tv[10];
   Tv[4] := MaxR(0,Tv[8]-Tv[12]);
   Tv[15] := MaxR(0,Tv[9]-Tv[13]);
   {analysis}
   ResFNo:=GetFormNo('T1229');
   x:= Vl(FetchElmFNo(RetNo,ResFNo,40))
       +Vl(FetchElmFNo(RetNo,ResFNo,41))
       +Vl(FetchElmFNo(RetNo,ResFNo,42))
       +Vl(FetchElmFNo(RetNo,ResFNo,43));

   If Tv[20]>x then Tv[20]:=x;
   If Tv[21]>Tv[12]+Tv[13] then Tv[21]:=Tv[12]+Tv[13];
   Tv[17] :=MaxR(0,x-Tv[20]);
   Tv[18] := MaxR(0,Tv[12]+Tv[13]-Tv[21]);

   Tv[19] := Tv[17]+Tv[18];
   Tv[22] := Tv[20]+Tv[21];
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure CCAMULT(RetNo:integer;FName:string;FNo:integer);
Var I: integer; FInst :String[4];MaxCCA:Real;
 Rate: string[4];
  {UccStart, Additions,Proceeds,AdjUcc, Adjustments,BaseForCca,
   CCA, UCCEnd : real;}
  v1, v2, v3, v4, v5: real;
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);

  with ret[RetNo].Frm[Fno] do
  begin
    {CCA}
    Tv[82] := 0;
    I := 1;
    Repeat
      If Uppercase(Strings[126]) <> 'X' then Strings[i+6] := GetCCARate(Strings[i]);
      v1 := Tv[i+4];
      v2 := Tv[i+5];
      v3 := Tv[i+7];
      v4 := Tv[i+8];
      CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       v1,v2,Strings[i+6],v3,v4,
                       Strings[126],Strings[i+9],True,'',100,MaxCCA);
      Tv[i+4] := v1;
      Tv[i+5] := v2;
      Tv[i+7] := v3;
      Tv[i+8] := v4;
     Tv[82] := Tv[82] + Tv[I+7];
     I := i+10;
    until i > 71;
    Tv[82] := Tv[82] + Tv[81];

   {cca - motor veh}
   Tv[124] := 0;
   I := 83;
    Repeat
     If Strings[i]='' then Strings[i] := '10.1';
     If Strings[113] = '' then Strings[113] := '10';
     Strings[i+6] := '30';
     v1 := Tv[i+4];
     v2 := Tv[i+5];
     v3 := Tv[i+7];
     v4 := Tv[i+8];
     CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       v1,v2,Strings[i+6],v3,v4,
                       Strings[126],Strings[i+9],True,'',100,MaxCCA);
     Tv[i+4] := v1;
     Tv[i+5] := v2;
     Tv[i+7] := v3;
     Tv[i+8] := v4;
     Tv[124] := Tv[124] + Tv[I+7];
     I := i+10;
    until i > 113;
    Tv[124] := Tv[124] + Tv[123];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
End;


procedure MIA(RetNo: integer; FName: String;FNo: integer);
Var i,FPeriod:Integer;FarmFName,Inst,Fnm1,Fnm2:String;
begin
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
   i:=3;FPeriod:=StrToInt(AppYear);
   Tv[91]:=0;Tv[92]:=0;
   Repeat
    Strings[i]:=IntToStr(Fperiod);
    Fperiod:=FPeriod-1;

    If Tv[i+4]=0 then Tv[i+4]:=70;
    If (Tv[i+4]<70) or (Tv[i+4]>100) then Tv[i+4]:=70;

    if i=3 then
     Tv[8]:=Tv[4] * Tv[7]/100
    else
     Tv[i+5]:= (Tv[i+2]+Tv[i+3]) * Tv[i+4]/100;

    Tv[91]:=Tv[91]+Tv[i+5];
    Tv[92]:=Tv[92]+Tv[i+7];
    Inc(i,8);
   until i>83;
   Strings[83]:='before '+IntToStr(StrToInt(AppYear)-9);

   If LeftStr(Strings[1],5) ='T2042' then
   begin
    Inst:=AllTrim(MidStr(Strings[1],6,3));
    FarmFName:='T2042'+Inst
   end
   else
   If LeftStr(Strings[1],5) ='T1163' then
   begin
    Inst:=AllTrim(MidStr(Strings[1],6,3));
    FarmFName:='T1163'+Inst;
   end;

   If LeftStr(Strings[1],5) ='T1273' then
   begin
    Inst:=AllTrim(MidStr(Strings[1],6,3));
    FarmFName:='T1273'+Inst;
   end;

   Tv[93]:=0;
   If LeftStr(Strings[1],5) ='T2042' then
   begin
    If (Vl(FetchElm(RetNo,FarmFName,140))<0)
    and (FetchElm(RetNo,'T2042'+Inst,14)>'') //cash method
    then
     Tv[93]:=Abs(Vl(FetchElm(RetNo,FarmFName,140)));
   end;

   If LeftStr(Strings[1],5) ='T1163' then
   begin
    Fnm1:=ExtractFormRootName(FarmFName)+Inst;
    Fnm2:=ExtractFormRootName(FarmFName)+Inst;
    If (Vl(FetchElm(RetNo,Fnm1,603))<0)            //20110216  was 803
    and
    (FetchElm(RetNo,Fnm2,212)='2') //cash method
    then
     Tv[93]:=Abs(Vl(FetchElm(RetNo,Fnm1,603)));   //20110216
   end;

   If LeftStr(Strings[1],5) ='T1273' then
   begin
    Fnm1:=ExtractFormRootName(FarmFName)+Inst;
    Fnm2:=ExtractFormRootName(FarmFName)+Inst;
    If (Vl(FetchElm(RetNo,Fnm1,603))<0)        //20110216
    and
    (FetchElm(RetNo,Fnm2,212)='2') //cash method
    then
     Tv[93]:=Abs(Vl(FetchElm(RetNo,Fnm1,603)));
   end;

   Tv[94]:=Tv[91]+Tv[92];
   Tv[95]:=MinR(Tv[93],Tv[94]);
   //oia
   Tv[97]:=Tv[95];
   Tv[98]:=MaxR(0,Tv[96]-Tv[97]);

   If Tv[99]>Tv[98] then Tv[99]:=Tv[98];

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure CalcAuto(RetNo:integer;FName:string;FNo:integer;Stm:string);
Var I: integer; FInst :String[4];k,Gst,Pst:real;
 Line5K,Line6K,Line7K:Real;Yr:String[4];
 TotalDays,DaysBeforeJuly1,DaysAfterJuly1:Integer;
 StartLease,ENdLease:String;
Begin
 ConvertOldAutoExpDates(RetNo,FNo);
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
  begin
   If Strings[129]='' then strings[129]:='Business Parking Fees';
   If Strings[130]='' then strings[130]:='Supplementary Business Insurance';
   If Stm = 'B' then
      begin
       Tv[118] := Vl(FetchElm(RetNo,'T2125'+FInst,424));
       If Strings[39] = '' then Strings[39] := 'Business Statement '+FInst;
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
       //
      end;

   If (Vl(Strings[4]) =0) and (Vl(Strings[7]) =0) then
      begin Strings[4] :='1';Strings[7] :='1';end;

   If (Vl(Strings[5]) =0) and (Vl(Strings[8]) =0) then
      begin Strings[5] :='1';Strings[8] :='1';end;

   If (Vl(Strings[6]) =0) and (Vl(Strings[9]) =0) then
      begin Strings[6] :='1';Strings[9] :='1';end;

   For i :=4 to 6 do
     If Vl(Strings[i+3]) < Vl(Strings[i]) then Strings[i+3] := Strings[i];

   Tv[119] := Tv[118]-Tv[120]-Tv[121];

   {interest}
   If UpperCase(Strings[28]) <> 'Y' then
   begin
    Tv[19] := Tv[115];
    Tv[20] :=Tv[116];
    Tv[21] :=Tv[117];
   end;
   {Lease}
   If UpperCase(Strings[29]) <> 'Y' then
   begin
    Tv[16]:=Tv[99];
    Tv[17]:=Tv[100];
    Tv[18]:=Tv[101];
   end;

   For i:=0 to 0 do
   begin
    Tv[42+i] := Tv[10+i]+Tv[19+i]+Tv[22+i]+Tv[25+i]+Tv[13+i]+tv[16+i]
                +Tv[32+i]+Tv[36+i];
    If Vl(Strings[7+i]) > 0 then
      Tv[45+i] := Tv[42+i] * (Vl(Strings[4+i]) / Vl(Strings[7+i]))
    else
      Tv[45+i] := 0;
    Tv[54+i] := MaxR(0,Tv[45+i] + Tv[48+i]+Tv[51+i]);

    If Vl(Strings[7+i]) > 0 then
      Tv[122+i] := Tv[119+i] * (Vl(Strings[4+i]) / Vl(Strings[7+i]))
    else
      Tv[122+i] := 0;

    {Lease}
    Yr :=LeftStr(Strings[57+i],4);
    StartLease:=Strings[57+i];
    EndLease:=Strings[60+i];
    If (StartLease>'') and (EndLease>'') then
      TotalDays:=DateDiff(YMDtoDate(StartLease),YMDtoDate(EndLease)); //20160119 Igor
    DaysBeforeJuly1:=DateDiff(YMDtoDate(StartLease),YMDtoDate(MinString('2006-07-01',EndLease))); //20160119 Igor
    DaysAfterJuly1:=DateDiff(YMDtoDate(MaxString('2006-07-01',StartLease)),YMDtoDate(EndLease)); //20160119 Igor
    If DaysBeforeJuly1<0 then DaysBeforeJuly1:=0;
    If DaysAfterJuly1<0 then DaysAfterJuly1:=0;
    Line5K:= GetLine5K(Yr);
    If Tv[126+i] =0 then Tv[126+i] := 7;
    If yr='' then Tv[126+i] :=0;
    If TotalDays>0 then
     Tv[126+i]:= (DaysBeforeJuly1 *7 +DaysAfterJuly1 * 6.0)/TotalDays
    Else
     Tv[126+i]:= 0;
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
    If Tv[109+i] = 0 then Tv[109+i] := 10;
    If Vl(Strings[106+i]) = 0 then Tv[109+i] := 0;
    Tv[112+i] := Vl(Strings[106+i]) * Tv[109+i];
    Tv[115+i] := MinR(Tv[103+i],Tv[112+i]);
   end;

   Tv[102] := Tv[54]+Tv[55]+Tv[56];
   Tv[125] := Tv[122]+Tv[123]+Tv[124];
 end; {End with}
  SaveTv(RetNo,FName,FNo);
 End;


Procedure T2125Sum(RetNo: integer; FName: String;FNo: integer);
Var i,FromElm,ToElm:integer;
   TempList:TstringList;
   FInst:String;
   StmFNo:Integer;
begin
  FInst:=ExtractFormInst(FName);
  StmFNo:=GetFormNo('T2125'+FInst);
  If StmFNo=0 then exit;
  If ShowUnconvertedLastYear(RetNo) then exit;

  //DirList:=TStringList.Create;
  //LoadDirList(DirList);

  LoadTv(RetNo,FName,FNo);
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'T2125SUM.D');

  //Initialize
  With ret[RetNo].Frm[Fno] do
  begin
  // Strings[1] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
  //year headings

   Strings[262]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[263]:=FInst;
   Strings[1]:=FetchElmFNo(RetNo,StmFNo,8);  //bus nm
   Strings[2] := AppYear;
   Strings[3] := IntToStr(StrToInt(AppYear)-1);
   Strings[4] := IntToStr(StrToInt(AppYear)-2);
   Strings[5] := IntToStr(StrToInt(AppYear)-3);
   Strings[6] := IntToStr(StrToInt(AppYear)-4);


   Tv[7]:=Vl(FetchElmFNo(RetNo,StmFNo,23))+Vl(FetchElmFNo(RetNo,StmFNo,89));

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3));
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then Tv[ToElm]:=Vl(FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
 TempList.Free;
end;

Procedure T2121Sum(RetNo: integer; FName: String;FNo: integer);
Var i,FromElm,ToElm:integer;
   TempList:TstringList;
   FInst:String;
   StmFNo:Integer;
begin
  FInst:=ExtractFormInst(FName);
  StmFNo:=GetFormNo('T2121'+FInst);
  If StmFNo=0 then exit;
  If ShowUnconvertedLastYear(RetNo) then exit;

  LoadTv(RetNo,FName,FNo);
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'T2121SUM.D');

  //Initialize
  With ret[RetNo].Frm[Fno] do
  begin
  // Strings[1] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
  //year headings

   Strings[262]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[263]:=FInst;
   Strings[1]:=FetchElmFNo(RetNo,StmFNo,8);  //bus nm
   Strings[2] := AppYear;
   Strings[3] := IntToStr(StrToInt(AppYear)-1);
   Strings[4] := IntToStr(StrToInt(AppYear)-2);
   Strings[5] := IntToStr(StrToInt(AppYear)-3);
   Strings[6] := IntToStr(StrToInt(AppYear)-4);


  // Tv[7]:=Vl(FetchElmFNo(RetNo,StmFNo,23))+Vl(FetchElmFNo(RetNo,StmFNo,89));

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3));
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then Tv[ToElm]:=Vl(FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
 TempList.Free;
end;

Procedure T2042Sum(RetNo: integer; FName: String;FNo: integer);
Var i,FromElm,ToElm:integer;
   TempList:TstringList;
   FInst:String;
   StmFNo:Integer;
begin
  FInst:=ExtractFormInst(FName);
  StmFNo:=GetFormNo('T2042'+FInst);
  If StmFNo=0 then exit;
  If ShowUnconvertedLastYear(RetNo) then exit;

  //DirList:=TStringList.Create;
  //LoadDirList(DirList);

  LoadTv(RetNo,FName,FNo);
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'T2042SUM.D');

  //Initialize
  With ret[RetNo].Frm[Fno] do
  begin
  //year headings
   Strings[397]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[398]:=FInst;
   Strings[1]:=FetchElmFNo(RetNo,StmFNo,8);  //bus nm
   Strings[2] := AppYear;
   Strings[3] := IntToStr(StrToInt(AppYear)-1);
   Strings[4] := IntToStr(StrToInt(AppYear)-2);
   Strings[5] := IntToStr(StrToInt(AppYear)-3);
   Strings[6] := IntToStr(StrToInt(AppYear)-4);


   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3));
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then Tv[ToElm]:=Vl(FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
 TempList.Free;
end;

Procedure T776Sum(RetNo: integer; FName: String;FNo: integer);
Var i,FromElm,ToElm:integer;
   TempList:TstringList;
   FInst:String;
   StmFNo:Integer;
begin
  FInst:=ExtractFormInst(FName);
  StmFNo:=GetFormNo('T776'+FInst);
  If StmFNo=0 then exit;
  If ShowUnconvertedLastYear(RetNo) then exit;

  LoadTv(RetNo,FName,FNo);
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'T776SUM.D');

  //Initialize
  With ret[RetNo].Frm[Fno] do
  begin
  // Strings[1] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
  //year headings

   Strings[180]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[181]:=FInst;
   Strings[1]:=FetchElmFNo(RetNo,StmFNo,45);  //bus nm
   Strings[2] := AppYear;
   Strings[3] := IntToStr(StrToInt(AppYear)-1);
   Strings[4] := IntToStr(StrToInt(AppYear)-2);
   Strings[5] := IntToStr(StrToInt(AppYear)-3);
   Strings[6] := IntToStr(StrToInt(AppYear)-4);

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3));
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then Tv[ToElm]:=Vl(FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
 TempList.Free;
end;

Procedure T1163Sum(RetNo: integer; FName: String;FNo: integer);
Var i,FromElm,ToElm:integer;
   TempList:TstringList;
   FInst:String;
   StmFNo:Integer;
begin
  FInst:=ExtractFormInst(FName);
  StmFNo:=GetFormNo('T1163'+FInst);
  If StmFNo=0 then exit;
  If ShowUnconvertedLastYear(RetNo) then exit;

  LoadTv(RetNo,FName,FNo);
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'T1163SUM.D');

  //Initialize
  With ret[RetNo].Frm[Fno] do
  begin
  // Strings[1] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
  //year headings

   Strings[387]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[388]:=FInst;
   Strings[1]:=FetchElmFNo(RetNo,StmFNo,201);  //bus nm
   Strings[2] := AppYear;
   Strings[3] := IntToStr(StrToInt(AppYear)-1);
   Strings[4] := IntToStr(StrToInt(AppYear)-2);
   Strings[5] := IntToStr(StrToInt(AppYear)-3);
   Strings[6] := IntToStr(StrToInt(AppYear)-4);

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3));
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then Tv[ToElm]:=Vl(FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
 TempList.Free;
end;


Procedure T1273Sum(RetNo: integer; FName: String;FNo: integer);
Var i,FromElm,ToElm:integer;
   TempList:TstringList;
   FInst:String;
   StmFNo:Integer;
begin
  FInst:=ExtractFormInst(FName);
  StmFNo:=GetFormNo('T1273'+FInst);
  If StmFNo=0 then exit;
  If ShowUnconvertedLastYear(RetNo) then exit;

  //DirList:=TStringList.Create;
  //LoadDirList(DirList);

  LoadTv(RetNo,FName,FNo);
  TempList := TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'T1273SUM.D');

  //Initialize
  With ret[RetNo].Frm[Fno] do
  begin
  // Strings[1] := FetchElm(RetNo,'INFO',2)+' '+FetchElm(RetNo,'INFO',5);
  //year headings

   Strings[387]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[388]:=FInst;
   Strings[1]:=FetchElmFNo(RetNo,StmFNo,201);  //bus nm
   Strings[2] := AppYear;
   Strings[3] := IntToStr(StrToInt(AppYear)-1);
   Strings[4] := IntToStr(StrToInt(AppYear)-2);
   Strings[5] := IntToStr(StrToInt(AppYear)-3);
   Strings[6] := IntToStr(StrToInt(AppYear)-4);

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3));
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then Tv[ToElm]:=Vl(FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
 TempList.Free;
end;



//JZ//20260419/CCAv10 - relocated when CCA is posted
Procedure T2042(RetNo:integer;FName:string;FNo:integer);
Var i,j,k,jj,AutosFNo,NumCars :integer;x:Real;
  FInst : String[4];
  TermLossAmount,RecaptAmount,CCAForStmt:Real;
  autosTermLossAmount,autosRecaptAmount,autosCCAForStmt:Real;
  NI,MIA,OIA:Real;
  NormalLoss,AllowedLoss,RestrictedLoss,RemainingAmount:real;
  Stmt:String;
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with ret[RetNo].Frm[Fno] do
 begin
  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
    ExtractAutos(RetNo,'T2042',FInst,autosTermLossAmount,autosRecaptAmount,autosCCAForStmt);

    Tv[482] := 0;
    {CCA Xi}
    If PostCCaFromAssetsB(RetNo) then
    begin
      PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,401,471,10,480,481,335);  //20230524 Igor
      //Tv[615]:=Vl(Strings[615]); //jz//20260414//CCAv7 - elm does not exist
      Tv[616]:=Vl(Strings[616]);
    end
    Else  //20090101
    begin
     for i:=401 to 482 do begin Strings[i]:='';Tv[i]:=0;end;
    end;

    {cca - motor veh}
    //20230428 Igor >>>
    PostAutoCCA(RetNo,FName,Stmt,FInst,FNo,523,524);

    (*ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
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
    *)
    //20230428 Igor <<<

    //20230525
    Tv[581]:=0;
    i:=549;
    Repeat
      Tv[581]:=Tv[581]+Tv[i];
      Inc(i,1)
    Until i>552;

   Tv[336]:=Tv[200]+Tv[581]; //20230525 Immed expensing
   Tv[482]:=Tv[335]+Tv[524]; //20230524 Igor

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
      Strings[640] :=GetSpouseFirstName(RetNo);
      Strings[664] :=GetSpouseLastName(RetNo);
      Strings[665] :=GetSpouseSIN(RetNo);
      Strings[643] :=GetSpouseAddress(RetNo);
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
  {//20230517
  //20230501 Igor >>>
  Tv[601] := Tv[245] + Tv[267];
  Tv[602] := Tv[312] + Tv[334];
  //20230501 Igor <<<
  }
 //pg 6
 NumCars:=0;
 FInst := ExtractFormInst(FName);
 Stmt:='T2042'+FInst;
 FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car
 //jz//20260408//CCAv2 - uses For jj:=710 to 873 but elms are not consecutive nor have consistant incr
 //For j:=710 to 873 do StoreElm(RetNo,FNo,j,'');              //20110125

    xx:=ret[RetNo].Frm[Fno].tv[740];

 //populate CHART A,B,C
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName='AUTOS' then //find autos form
   begin
    AutosFNo:=Frec.FormNo;
    If ret[RetNo].FormHasData[GetFormName(RetNo,AutosFNo)] then //if find autos form has data
    begin
     j:=215;                            //20110125  instead of 915
     Repeat
      //check if this form has CCA applied to it
      If (trim(FetchElmFNo(RetNo,AutosFNo,j)) = trim(Stmt)) and (Vl(FetchElmFNo(RetNo,AutosFNo,j+1))>0) then  //20160428 Igor
      begin
       NumCars:=NumCars+1;
       If NumCars=1 then
       begin

         //jz//20260408//CCAv2 - uses For jj:=710 to 830 but elms are not consecutive nor have consistant incr so causes issues, do manually for now
         {
         For jj:=710 to 830 do    //20110125
         begin
            ret[RetNo].Frm[FNo].Strings[jj]:=FetchElmFNo(RetNo,AutosFNo,jj-700);
            ret[RetNo].Frm[FNo].Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[jj]);
         end;
         }

         //jz//20260408//CCAv2 - mnaual entry as loop was causing issues
         //CHART A
         jj := 710; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 719; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 722; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 725; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 713; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 716; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 737; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,43)); //zero emmissions -differnt elm incr
         jj := 731; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 732; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 735; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 736; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 742; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 745; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));

         jj := 829; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,jj-700);

         jj := 748; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));

         jj := 830; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,jj-700);

         jj := 751; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 754; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         //CHART B
         jj := 803; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));

         jj := 199; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,9);

         jj := 809; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));

         jj := 806; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,jj-700);

         jj := 812; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 815; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         //CHART C
         jj := 757; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,jj-700);
         jj := 760; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,jj-700);
         jj := 763; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,jj-700);

         jj := 826; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 766; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 769; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 772; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 775; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         //jj :=  90; ret[RetNo].Frm[FNo].Strings[jj] := FetchElmFNo(RetNo,AutosFNo,jj-700); ???
         jj := 778; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj :=  23; ret[RetNo].Frm[FNo].tv[jj] := ret[RetNo].Frm[FNo].tv[91];
         jj :=  92; ret[RetNo].Frm[FNo].tv[jj] := ret[RetNo].Frm[FNo].tv[769];
         jj := 781; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 784; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
         jj := 799; ret[RetNo].Frm[FNo].tv[jj] := vl(FetchElmFNo(RetNo,AutosFNo,jj-700));
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
    ret[RetNo].Frm[FNo].Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
    ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
    ret[RetNo].Frm[FNo].Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
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

  with ret[RetNo].Frm[FNo] do
  begin
    i:=837;
    Tv[873]:=0;
    Repeat
     Tv[873]:=Tv[873]+Tv[i];
     Inc(i,7);
    until i>872;
  end;


   //20131223
   If Strings[63]='' then Strings[63]:='0';
   If Strings[70]='' then Strings[70]:='0';
   If Vl(Strings[70])>100 then Strings[70]:='0';

   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
    //20130224
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[9] :=OptRec.Bus_Disclm
   else
     Strings[9] :='';
   If Strings[4] ='' then Strings[4] := AppYear+'-01-01';
   If Strings[5] ='' then Strings[5] := AppYear+'-12-31';
   If Strings[6]+Strings[7] ='' then  begin Strings[6] := '';Strings[7] := 'X'; end;
   If Strings[14]+Strings[15] ='' then Strings[15] := 'X';   //20230310

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
   //Tv[64]:=RecaptAmount;
   ExtractAutos(RetNo,'T2042',FInst,autosTermLossAmount,autosRecaptAmount,autosCCAForStmt);
   //Tv[64]:=Tv[64]+RecaptAmount;
   Tv[64]:=  GetTotalRecaptureAmt(RetNo,'T2042', FInst);  //Recapture Amount //jz//20260414//CCAv7
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
   //ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   Tv[110]:=0;
   For i:=0 to ExtractedAutoList.count-1 do
   begin
     ExtractedAutoRec:=ExtractedAutoList.Items[i];
     If ExtractedAutoRec.PartnerFlag='' then Tv[110]:=Tv[110]+ExtractedAutoRec.ExpensesClaimed;
   end;
   For i :=102 to 128 do
     Tv[135] := Tv[135] +Tv[i];

   //jz//20260414//CCAv7 - not sure why done twice and in this way, simplify below T2042
   {
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
   }

   //jz//20260414//CCAv7 - get CCA and terminal loss T2042
   //ExtractCCA(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,CCAForStmt); //jz//20260418//CCAv9 - extract done ONCE above
   //ExtractAutos(RetNo,'T2042',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);

   Tv[136] := tv[482]; //CCAForStmt+autosCCAForStmt;                    //CCA
   Tv[134] := GetTotalTerminalLoss(RetNo,'T2042', FInst);   //Term loss

   xx:=GetTotalTerminalLoss(RetNo,'T2042', FInst);

   Tv[152] :=Tv[130]+Tv[132] + Tv[134];
   Tv[151] := Tv[152];
   Tv[135] :=Tv[135]+Tv[151];

   //Tv[137] := MaxR(0,Tv[559]);   //20171119 cec
   Tv[138] :=Tv[135]+Tv[136]; //+Tv[137];    //20171119 cec
   Tv[139] := Tv[138];
   Tv[140] := Tv[101] -Tv[139];
   If UpperCase(Strings[154])='Y' then
   begin
    GetMIAAmount(RetNo,FName,MIA,OIA);
    Tv[141]:=OIA;
    Tv[142]:=MIA;
   end;
   Tv[143] :=Tv[140]+Tv[141]+Tv[142];
   Tv[144] := Tv[143] * Tv[24]/100;
   Tv[156]:=Tv[144]+Tv[198]+Tv[155]; // 20230419 Tv[199] //20221218     //Tv[144]+Tv[22]+Tv[155];  //20220201
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
      PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,201,216,5,220,221,222);
    I := 203; Tv[222] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[222] := Tv[222] + Tv[I+2]; //20110109
      i := i + 5;
    Until i > 218;
    Tv[222] := Tv[222] + Tv[221];

    Tv[335]:=Tv[481]; //20230426
    i:=408;
    Repeat
     Tv[335]:=Tv[335]+Tv[i];
     Inc(i,10);
    Until i>478;

   {Motor veh additions} // ???
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,autosCCAForStmt);
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
          If j>238 then
            RemainingAmount:=MaxR(0,RemainingAmount+ExtractedAutoRec.Cost - ExtractedAutoRec.AdditionsPersonal)
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

    //jz//20250306 - same code calcing tv[245] as below??
    I := 225; Tv[244] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[244] := Tv[244] + Tv[I+2];
      i := i + 5;
    Until i > 240;
    Tv[244] := Tv[244] + Tv[243];
    Tv[245] := Tv[222]+Tv[244];

    //build additions - T2042
    If PostCCaFromAssetsB(RetNo) then
      PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,246,261,5,265,266,267);
    i := 248; Tv[267] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[267] := Tv[267] + Tv[I+2];
      i := i + 5;
    Until i > 263;
    Tv[267] := Tv[267] + Tv[266];

    //equip dispoitions - t2042
    If PostCCaFromAssetsB(RetNo) then
      PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,268,283,5,287,288,289);  //20110109

    i := 270; Tv[289] := 0;
    Repeat
      Tv[i+2] := Tv[i] - Tv[i+1];
      Tv[289] := Tv[289] + Tv[i+2];
      i := i + 5;
    Until i > 285;
    Tv[289] := Tv[289] + Tv[288];

    Tv[200]:=0; for i:=361 to 368 do Tv[200]:=Tv[200]+Tv[i]; //20230426


    //=============
    //20230521  t2042
    PostAutosAdditions(RetNo,FName,Stmt,FInst,FNo,223,223,5,242,243,244);     //20230519
    I := 225; Tv[244] := 0;
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[244] := Tv[244] + Tv[I+2];
       i := i + 5;
     Until i > 240;
    //jz//20250306 - seems to be the same code calcing tv[245] as above except fpr the PostAutosAdditions??
    //Tv[245] := Tv[244] + Tv[243]; //gives wrong amount, misses top column, add Tv[244] and Tv[245] statemnets like the one above
    Tv[244] := Tv[244] + Tv[243]; //jz//20250306
    Tv[245] := Tv[222]+Tv[244];   //jz//20250306


    PostAutosDispositions(RetNo,FName,Stmt,FInst,FNo,290,305,5,309,310,311);     //20230519
    I := 292; Tv[311] := 0;
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[311] := Tv[311] + Tv[I+2];
       i := i + 5;
     Until i > 307;
     Tv[312] := Tv[311] + Tv[310];
    //=============

    {build disp }
    If PostCCaFromAssetsB(RetNo) then
      PostBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,313,328,5,332,333,334);
    I := 315; Tv[334] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[334] := Tv[334] + Tv[I+2];
      i := i + 5;
    Until i > 330;
    Tv[334] := Tv[334] + Tv[333];
  end; {End with}

  SaveTv(RetNo,FName,FNo);
End;

//JZ//20260419/CCAv10 - relocated when CCA is posted
Procedure T2121(RetNo:integer;FName:string;FNo:integer);
Var
  i,j,jj,k, AutosFNo :integer; FInst : String[4];
  NI:Real;
  TermLossAmount,RecaptAmount:Real;CCAForStmt:Real;
  autosTermLossAmount,autosRecaptAmount,autosCCAForStmt:Real;
  AssetsFNo: integer; Stmt:String;RemainingAmount:Real;
  NumCars:Integer;
  autosClaimedElms : Set of 10 .. 173; //jz//20260422//CCAv12 //610 .. 773 - delphi sets must be less than 256, will adjust by 600
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);

  //CCA - post CCA and supporting charts first //pg 4
  with ret[RetNo].Frm[Fno] do
  begin
    Stmt:=LeftStr(FName,5);
    ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
    ExtractAutos(RetNo,'T2121',FInst,autosTermLossAmount,autosRecaptAmount,autosCCAForStmt);

    Tv[218] := 0;
    If PostCCaFromAssetsB(RetNo) then
      PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,137,207,10,215,217,218);
    Tv[218] := Tv[218] + Tv[217]; //is this neccessary?

    PostAutoCCA(RetNo,FName,Stmt,FInst,FNo,259,260);

    Tv[459]:= AddColumns(484,491,1); //col9 Assets sum
    Tv[458]:= AddColumns(556,559,1); //col9 Autos sum
    Tv[536]:=Tv[459]+Tv[458];        //col9 Assets + Autos total

    Tv[277] := Tv[260] + Tv[218]; //jz//CCAv13

    Stmt:=LeftStr(FName,5);

    //AREA B equip additions ==========================================================
    If PostCCaFromAssetsB(RetNo) then
      PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,301,316,5,320,321,322);
    //non motor additions
    i := 303; Tv[322] := 0;
    Repeat
      Tv[i+2] := Tv[i] - Tv[i+1];
      Tv[322] := Tv[322] + Tv[i+2];
      i := i + 5;
    Until i > 318;
    Tv[322] := Tv[322] + Tv[321];
    //motor additions

    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,autosCCAForStmt);
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
         If j>338 then RemainingAmount:=MaxR(0,RemainingAmount+ExtractedAutoRec.Cost -
                                             ExtractedAutoRec.AdditionsPersonal)
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
    //20230428 Igor >>>
    { it is probably incorrect because 261 is a Col6 in Autos row 1
    i:=220;
    j:=261;
    Repeat
     Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
     Inc(i,10);
     Inc(j,1);
    until i>264;
    }
    //20230428 Igor <<<

    //build additions
    If PostCCaFromAssetsB(RetNo) then
      PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,346,361,5,365,366,367);
    I := 348; Tv[367] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[367] := Tv[367] + Tv[I+2];
      i := i + 5;
    Until i > 363;
    Tv[367] := Tv[367] + Tv[366];



    {non build disp }
    If PostCCaFromAssetsB(RetNo) then
      PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,368,383,5,337,338,339);
    i := 370; Tv[389] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[389] := Tv[389] + Tv[I+2];
      i := i + 5;
    Until i > 385;
    Tv[389] := Tv[389] + Tv[388];

    {motor disp }
    //get autoexpenses
    ExtractAutos(RetNo,Stmt,FInst,TermLossAmount,RecaptAmount,autosCCAForStmt);
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
      PostnonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,413,428,5,432,433,434);
    I := 415; Tv[434] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[434] := Tv[434] + Tv[I+2];
      i := i + 5;
    Until i > 430;
    Tv[434] := Tv[434] + Tv[433];
  end; {End with}
  {//20230517
  //20230501 Igor >>>
  Tv[501] := Tv[345] + Tv[367];
  Tv[502] := Tv[412] + Tv[434];
  //20230501 Igor <<<
  }
  //pg 4
    with ret[RetNo].Frm[Fno] do
  begin
    If Tv[505] >0 then
     begin
      Strings[503]  :=GetSpouseFirstName(RetNo);
      Strings[537] :=GetSpouseLastName(RetNo);
      Strings[538] :=GetSpouseSIN(RetNo);
      Strings[506]  :=GetSpouseAddress(RetNo);
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

  end; //with

 //pg 5
 NumCars:=0;
 FInst := ExtractFormInst(FName);
 Stmt:='T2121'+FInst;
 FillSelfAutoExpRec(RetNo,Stmt); //get claim by each car

{
 //jz//20260422//CCAv12 - specify elms that are actually for of this part
 autosClaimedElms : [ 731..772,610,619,622,625,613,616,655,631,632,635,636,642,645,729,
                      730,648,651,654,703,709,706,712,715,657,660,663,726,666,
                      669,672,675,678,127,681,684,699
                    ];
}
 //jz//20260422//CCAv12 - specify elms that are actually for of this part, minus 600 because of delhi set elm must be less than 255
 autosClaimedElms :=  [ 131..172,010,019,022,025,013,016,055,031,032,035,036,042,045,129,
                        130,048,051,054,103,109,106,112,115,057,060,063,126,066,
                        069,072,075,078,081,084,099 //127??
                      ];

  For j:=610 to 773 do
  if j-600 in autosClaimedElms then //jz - minus 600 because of delhi set elm must be less than 255
    StoreElm(RetNo,FNo,j,'');

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
            if jj-600 in autosClaimedElms then  //jz//CCAv12 - specify elms actually used for of this part, minus 600 because of delhi set elm must be less than 255
            begin
              ret[RetNo].Frm[FNo].Strings[jj]:=FetchElmFNo(RetNo,AutosFNo,jj-600);
              ret[RetNo].Frm[FNo].Tv[jj]:=Vl(ret[RetNo].Frm[FNo].Strings[jj]);
            end;
          end;
          //zero emmission 20210301
          ret[RetNo].Frm[FNo].Strings[655]:=FetchElmFNo(RetNo,AutosFNo,43);
          ret[RetNo].Frm[FNo].Tv[655]:=Vl(ret[RetNo].Frm[FNo].Strings[43]);
       end;
      end;
      Inc(j,6);  //dummy
     until j>227;                        //20110125 instead of 927;
    end;  //has data
   end; //autos
 end;  //i

  If NumCars>1 then
    For j:=610 to 730 do
      if j-600 in autosClaimedElms then //jz - minus 600 because of delhi set elm must be less than 255
        StoreElm(RetNo,FNo,j,'');

  StoreElm(RetNo,FNo,606,' ');
  j:=731;
  i:=1;
  Repeat
    ret[RetNo].Frm[FNo].Strings[j]:=SelfAutoExpRec.Descr[i];
    ret[RetNo].Frm[FNo].Strings[j+1]:=IntToStr(SelfAutoExpRec.KmDrove[i]);
    ret[RetNo].Frm[FNo].Strings[j+2]:=IntToStr(SelfAutoExpRec.KmTotal[i]);
    ret[RetNo].Frm[FNo].Strings[j+3]:=SelfAutoExpRec.Stmt[i];
    ret[RetNo].Frm[FNo].Tv[j+4]:=SelfAutoExpRec.StmtPercent[i];
    ret[RetNo].Frm[FNo].Strings[j+5]:=SelfAutoExpRec.PartnerFlag[i];
    ret[RetNo].Frm[FNo].Tv[j+6]:=SelfAutoExpRec.ExpensesClaim[i];
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

  with ret[RetNo].Frm[FNo] do
  begin
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






















 with ret[RetNo].Frm[Fno] do
 begin
 //20131223
   If Strings[86]='' then Strings[86]:='0';
   If Strings[88]='' then Strings[88]:='0';
   If Vl(Strings[88])>100 then Strings[88]:='0';
   If Strings[89]='' then Strings[89]:=ret[RetNo].Province;  //20150128

   Strings[1] := FetchElm(RetNo,'INFO',2);
   Strings[2] := FetchElm(RetNo,'INFO',5);
   Strings[3] := FetchElm(RetNo,'INFO',3);
   //20130224
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[81] :=OptRec.Bus_Disclm
   else
     Strings[81] :='';

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


   //jz//20260414//CCAv7 - not sure why done twice and in this way, simplify below
   {
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
   }
   //ExtractCCA(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   //ExtractAutos(RetNo,'T2121',FInst,autosTermLossAmount,autosRecaptAmount,autosCCAForStmt);

   //jz//20260414//CCAv7 - get CCA and terminal loss T2121
   Tv[65] := Tv[277]; //CCAForStmt+autosCCAForStmt;                       //CCA
   Tv[60] := GetTotalTerminalLoss(RetNo,'T2121', FInst);      //Terminal loss
   Tv[28]:=  GetTotalRecaptureAmt(RetNo,'T2121', FInst);      //Recapture Amount //jz//20260414//CCAv7

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

   Tv[459]:=0; for i:=484 to 491 do Tv[459]:=Tv[459]+Tv[i]; //20230426
   If UpperCase(Strings[27]) <> 'Y' then
     Tv[35] :=AddColumns(20,24,1)+Tv[456]+Tv[28]+Tv[26]; //20230126
     //Tv[35] :=AddColumns(20,24,1)+Tv[26]+Tv[28]+Tv[32]+Tv[34];
   Tv[77]:=Tv[35];
   //get autoexpenses
   //ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,autosCCAForStmt); //jz//20260418//CCAv9 - extract already done ONCE above
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
    ExtractAutos(RetNo,'T2121',FInst,TermLossAmount,RecaptAmount,autosCCAForStmt);
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
  end; //End with

  SaveTv(RetNo,FName,FNo);

  UpdateThisFormDataIndicator(RetNo,FName); //CCAv10 why this and what does it do?
End;



//JZ//20260419/CCAv10 - relocated when CCA is posted
Procedure T2125(RetNo:integer;FName:string;FNo:integer);
Var i,j,jj,k,NumCars,AutosFNo :integer;
  FInst,Stmt:String;  //[5];  //20110125
  TermLossAmount,RecaptAmount,CCAForStmt:Real;
  autosTermLossAmount,autosRecaptAmount,autosCCAForStmt:Real;
  RemainingAmount:Real;MaxCCA:Real;
  T4AFNo,T1204FNo:Integer;
Begin
 If FNo=0 then exit;
 T4AFNo:=GetFormNo('T4A#1');
 T1204FNo:=GetFormNo('T1204#1');

 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);

  //CCA - post CCA and supporting charts first - pg 5
  Stmt:=LeftStr(FName,5);
  with ret[RetNo].Frm[Fno] do
  begin
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);        //extract done ONCE here
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,autosCCAForStmt);  //extract done ONCE here

   If PostCCaFromAssetsB(RetNo) then
    PostNonVehicleCCA(RetNo,FName,Stmt,FInst,FNo,301,371,10,380,381,382);  //20130408 looks ok

   Tv[130]:=0; for i:=523 to 530 do Tv[130]:=Tv[130]+Tv[i]; //tot col9 immediate expensing

   //jz//20260404 - does a calc, already done in assetsb  i think , remove from here
   {
   //20140122
   i:=302;
   j:=551;
   Repeat
    Tv[j]:=Tv[i]+Tv[i+1]-Tv[i+2];
    Inc(i,10);
    Inc(j,1);
   until i>372;
   }

   {cca - motor veh}
   //20230428 Igor >>>
    PostAutoCCA(RetNo,FName,Stmt,FInst,FNo,423,424);  //20130408 looks ok
    //Tv[424] := Tv[424] + Tv[423];             // <== this makes no sense?  //20230523 Igor
   //auto population issue looks like ends here, probably ==================================================================================================

    //20230525
    //sum auto cca col9
    Tv[131]:=0;
    i:=646;
    Repeat
      Tv[131]:=Tv[131]+Tv[i];
      Inc(i,1)
    Until i>649;

   Tv[132]:=Tv[130]+Tv[131]; //20230525
   Tv[81]:=Tv[382]+Tv[424]; //20190120

    //non build additions
    If PostCCaFromAssetsB(RetNo) then
      PostNonBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,425,440,5,444,445,446); //jz//CCAv8 - adjust elm var to match chart elms
    i := 427; Tv[446] := 0;
    Repeat
       Tv[I+2] := Tv[I] - Tv[I+1];
       Tv[446] := Tv[446] + Tv[I+2];
       i := i + 5;
     Until i > 442;
     Tv[446] := Tv[446] + Tv[445];


    //======= //20340519 POST the AUTOS CCA Additions to form T2125  =============
    //autos / motor additions
    //           T2125
    PostAutosAdditions(RetNo,FName,Stmt,FInst,FNo,447,462,5,466,467,468);     //20230519
    I := 449; Tv[468] := 0;
    Repeat
       Tv[i+2] := Tv[i] - Tv[i+1];
       Tv[468] := Tv[468] + Tv[i+2];
       i := i + 5;
     Until i > 464;
     Tv[468] := Tv[468] + Tv[467]; //jz//CCAv8 - include supp amount
     Tv[469] := Tv[468] + Tv[446]; //jz//CCAv8 - wrong elm //Tv[467];  //20230520
    //========================================================
    //T2125  autos
    PostAutosDispositions(RetNo,FName,Stmt,FInst,FNo,601,611,5,615,616,656);  //jz//CCAv8 - update var elms to match chart elms
    i := 603; Tv[656]:=0;
    Repeat
       Tv[i+2] := Tv[i] - Tv[i+1];
       Tv[656] := Tv[656] + Tv[i+2];
       i := i + 5;
     Until i > 613;
     Tv[656] := Tv[656] + Tv[616];  //jz//CCAv8 - account for supp amount
     Tv[617] := Tv[656] + Tv[513];  //jz//CCAv8 - Tv[513] to add the totals
    //building additions
    If PostCCaFromAssetsB(RetNo) then
      PostBuildingAdditions(RetNo,FName,Stmt,FInst,FNo,470,485,5,489,490,491);
    I := 472; Tv[491] := 0;
    Repeat
      Tv[i+2] := Tv[i] - Tv[i+1];
      Tv[491] := Tv[491] + Tv[I+2];
      i := i + 5;
    Until i > 487;
    Tv[491] := Tv[491] + Tv[490];

    //equipm dispositions other than buildings and motor veh
    If PostCCaFromAssetsB(RetNo) then
      PostNonBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,492,507,5,511,512,513);
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
  //jz//CCAv8 - already done above?? also elms wrong, not sure why this was for
  {
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

    }

    //jz//CCAv8 - these clears are questionable, leave for now
    //20110406  //remove cls and descr if no bus claim
    i:=605;
    Repeat
     If Tv[i]=0 then begin Strings[i-4]:='';Strings[i-3]:='';end;
     Inc(i,5);
    until i>=615;

    Tv[656] := Tv[656] + Tv[616];
    Tv[617] := Tv[656] +Tv[513];
    // dispositions Building
    If PostCCaFromAssetsB(RetNo) then PostBuildingDispositions(RetNo,FName,Stmt,FInst,FNo,618,633,5,637,638,639);
    {build disp }
    I := 620; Tv[639] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[639] := Tv[639] + Tv[I+2];
      i := i + 5;
    Until i > 635;
    Tv[639] := Tv[639] + Tv[638];
    {//20230517 WHY here?
    //20230501 Igor >>>
    Tv[640] := Tv[469] + Tv[491];
    Tv[641] := Tv[617] + Tv[639];
    //20230501 Igor <<<
    }
  end; {End with}

 //pg 6
 with ret[RetNo].Frm[Fno] do
 begin
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

    {No good. It comes from the Autos form
    If ret[RetNo].Frm[FNo].Strings[809]='' then //20241217  Daily allowance
    begin
     ret[RetNo].Frm[FNo].Tv[809]:=Vl(strings[166])/30;
     ret[RetNo].Frm[FNo].strings[809]:=Formatfloat('###.##',ret[RetNo].Frm[FNo].Tv[809])
    end;
    }
    If ret[RetNo].Frm[FNo].Strings[809]='' then begin ret[RetNo].Frm[FNo].Strings[809]:='10';Tv[809]:=10;end;  //20140120  Daily allowance

    If ret[RetNo].Frm[FNo].Strings[829]='' then  begin ret[RetNo].Frm[FNo].Strings[829]:='Business parking fees';end;  //20140120  Daily allowance
    If ret[RetNo].Frm[FNo].Strings[830]='' then  begin ret[RetNo].Frm[FNo].Strings[830]:='Supplementary business insurance';end;  //20140120  Daily allowance

    if Tv[617]<0 then Tv[617]:=0;  //20240517 Box 9926  dispositionsthen
  end;


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
    Tv[76]:=GetT4AIncomeForT2125(RetNo,FInst);  //201102
    Tv[85]:=GetT1204IncomeForT2125(RetNo,FInst); //20190208
    Tv[86]:=Tv[76]+Tv[26]+Tv[85];   //20190208
    Tv[38]:=Tv[23]+Tv[86]-Tv[24]; //20190208 //Tv[23]+Tv[76]-Tv[24]+Tv[26];  //20130110 //added T3
    //xx:=Tv[38];  //debug //20240317
    Tv[137]:=Tv[39]-Tv[40]; //20230107
    Tv[46]:=Tv[137]; //20230107 //Tv[39]-Tv[40];
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
   end
   else
   begin
    Tv[84]:=GetT4AIncomeForT2125(RetNo,FInst);
    Tv[42]:=Tv[89]+Tv[84]-Tv[41];
    //20240121
    Tv[92]:=Tv[43]-Tv[44];
    Tv[45]:=Tv[92]; //Tv[43]-Tv[44];
    If Tv[84]>0 then ret[RetNo].FormHasData['T2125'+FInst]:=True;  //20110414
    Tv[93]:=Tv[42]+Tv[45]+Tv[87]; //20120315  //Tv[93]:=Tv[42]+Tv[45]-Tv[87]; //Tv[91]+Tv[92];
   end;
   //20110208
   If Length(OptRec.Bus_Disclm) >0 then
     Strings[37] :=OptRec.Bus_Disclm
   else
     Strings[37] :='';
   //part 3
   Tv[28]:=MaxR(Tv[83],Tv[93]);
    //recapt
   //ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);  //extract laready done ONCE above
   //Tv[66]:=RecaptAmount;
   //ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt); //extract laready done ONCE above
   //Tv[66]:=Tv[66]+RecaptAmount;
   Tv[66]:=  GetTotalRecaptureAmt(RetNo,'T2125', FInst);  //Recapture Amount //jz//20260414//CCAv7
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

   //jz//20260414//CCAv7 - not sure why done twice and in this way, simplify below T2125
   {
   //CCA
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   //Tv[168]:=CCAForStmt;
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   //Tv[168]:=Tv[168]+AutoCCAForStmt;
   Tv[168]:= CCAForStmt+AutoCCAForStmt;


  //Term loss -
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   //Tv[180]:=TermLossAmount;   //may not be needed now see below
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,AutoCCAForStmt);
   //Tv[180]:=Tv[180]+TermLossAmount; //Tv[180]:=TermLossAmount; //20240414  //see below
   //======================================================
   Tv[180]:=GetTotalTerminalLoss(RetNo,'T2125', FInst);
   //================================================================
   }

   //jz//20260414//CCAv7 - get CCA and terminal loss T2125
   ExtractCCA(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,CCAForStmt);
   ExtractAutos(RetNo,'T2125',FInst,autosTermLossAmount,autosRecaptAmount,autosCCAForStmt);

   //CCA
   Tv[168] := Tv[81]; //CCAForStmt+autosCCAForStmt;
   Tv[180] := GetTotalTerminalLoss(RetNo,'T2125', FInst);   //Term loss

   If Strings[36]='' then Strings[36]:='50';
   If vl(Strings[36])>100 then Strings[36]:='100';
   Tv[153] := Vl(FormatFloat('#########.##',Tv[165]*vl(Strings[36])/100)); //20110117
   //get autoexpenses
   ExtractAutos(RetNo,'T2125',FInst,TermLossAmount,RecaptAmount,autosCCAForStmt);
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
   If ShowCondominiumIndicator = True then
   begin
    If Strings[222]='' then Strings[222]:='Condominium fees';
    If Strings[224]='' then Strings[224]:='Telephone expenses';
   end;

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
        i := i + 3;
    until i > 249;
  end; {End with}

  SaveTv(RetNo,FName,FNo);
End;

//JZ//20260418/CCAv9 - moved and updated from calc3
//JZ//20260418/CCAv10 - relocated when CCA posted
procedure T776(RetNo: integer; FName: String; FNo: integer);
Var
  i, j, Pg2FNo: integer;
  TotPercent, x: Real;
  FInst: String[4];
  Stmt: String;

  CCAForStmt, TermLossAmount, RecaptAmount: Real;
  autosCCAForStmt, autosTermLossAmount, autosRecaptAmount: Real; //jz//CCAv9

  ClaimIt: Boolean;
  Cls: string[4];
  Rate: String[4];
  AssetsFNo: integer;
  RemainingAmount, Dummy: Real;
  MaxCCA: Real;

begin

  FInst := ExtractFormInst(FName);

  LoadTv(RetNo, FName, FNo);

  //CCA - post CCA and supporting charts first pg3
  with ret[RetNo].Frm[FNo] do
  begin
    //AREA A --> ==============================================================
    strings[367] := FInst + ' - ' + FetchElm(RetNo, 'T776' + FInst, 45);
    Stmt := LeftStr(FName, 4);

    //CCA ********************************************
    Tv[265] := 0; // TOTAL CCA amount ii for 9936

    PostNonVehicleCCA(RetNo, FName, Stmt, FInst, FNo, 201, 237, 9, 245, 264, 381);
    PostAutoCCA(RetNo, FName, Stmt, FInst, FNo, 380, 382);

    // 20230525
    //sum auto col9 --- THIS SHOULD PROB BE DONE IN Extract / PostAutoCCA ???
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
      PostNonBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 267, 277, 5, 281, 368, 0); //jz//CCAv8 - total indx to 0 as is calced, altho it doesnt seem PostNonBuildingAdditions uses it anyway
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
        PostBuildingAdditions(RetNo, FName, Stmt, FInst, FNo, 289, 304, 5, 308,309, 310);
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
      PostNonBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 311, 321, 5, 325, 374, 0); //jz//CCAv8 - total indx to 0 as is calced, altho doesnt seem is used in the procedure anyway

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

    //T776 AREA E - build disp begin =================================================
    If PostCCaFromAssetsB(RetNo) then
      PostBuildingDispositions(RetNo, FName, Stmt, FInst, FNo, 333, 348, 5, 352, 353, 354);
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
      //total the calc amount, done here so overrides can effect calc but maybe should be all be done in PostNonCompliantShortTermRentalsCCA for ease??
      Tv[427] := Tv[427] + Tv[i + 2];
      Inc(i, 6);
    Until i > 528; //573; //jz//20260408 - elms incr not consistant, remove final 3 rows for now
    //T776 Chart B end ===========================================================

    Tv[427] := Tv[427] + Tv[359];
    Tv[425] := Tv[427];
  end; //End with

  with ret[RetNo].Frm[FNo] do
  begin

    {//jz//CCAv9 - clearing happens in postcca
    // Clear some CCA table Col7, 10, 12 //20230426
    for i := 146 to 150 do begin Tv[i] := 0; end; // col 7
    for i := 196 to 200 do begin Tv[i] := 0; end; // col 10
    for i := 383 to 387 do begin Tv[i] := 0; end; // col 12
    }


    //PART 1 ID ===================================================
    strings[1] := Rtrim(FetchElm(RetNo, 'INFO', 2)) + ' ' + FetchElm(RetNo, 'INFO', 5);
    strings[2] := FetchElm(RetNo, 'INFO', 3);
    If strings[3] = ''                then strings[3] := AppYear + '-01-01';
    If strings[6] = ''                then strings[6] := AppYear + '-12-31';
    If strings[9] + strings[10] = ''  then strings[10] := 'X';
    If strings[4] + strings[5]  = ''  then strings[4] := 'X';
    strings[12] := OptRec.Prp_Name;

    // 20170310
    strings[14] := OptRec.Prp_Street;
    strings[16] := OptRec.Prp_City;
    strings[17] := OptRec.Prp_Prov;
    strings[118] := OptRec.Prp_Postal;

    If UpperCase(strings[145]) = 'Y' then strings[109] := GetFirstName(RetNo) + ' ' + GetLastName(RetNo);

    If strings[110] = '' then
                              strings[110] := FetchElm(RetNo, 'INFO', 6) + ' ' + FetchElm(RetNo, 'INFO', 22) + ' ' +
                                              FetchElm(RetNo, 'INFO', 68) + ' ' +
                                              FetchElm(RetNo, 'INFO',63); // str / rural
    If strings[112] = '' then strings[112] := FetchElm(RetNo, 'INFO', 10); // city
    If strings[120] = '' then strings[120] := FetchElm(RetNo, 'INFO', 14); // Prov
    If strings[111] = '' then strings[111] := FetchElm(RetNo, 'INFO', 15); // Postal

    If strings[18]  = '' then strings[18] := '100.0000'; // Tv[18] :=100; 20111208
    strings[18] := FormatFloat('##0.0000', Vl(strings[18])); // 20111208

    strings[19] := '531111'; { sic }

    //jz - from part, 4 why here? -->
    If strings[138] = '' then strings[138] := 'N'; //Share CCA in coupling? (Y/N)
    If UpperCase(strings[141]) <> 'Y' then strings[114] := strings[18]; //Revise % of Area A
    If Vl(strings[114]) > 100 then
      strings[114] := '100.0000'; // Tv[18] :=100; 20111208
    strings[114] := FormatFloat('##0.0000', Vl(strings[114])); // 20111208
    Tv[114] := Vl(strings[114]); // 20111209

    If strings[115] = ''      then strings[115] := '100.0000'; // 20111208
    If Vl(strings[115]) > 100 then strings[115] := '100.0000'; // 20111208
    strings[115] := FormatFloat('##0.0000', Vl(strings[115])); // 20111208
    Tv[115] := Vl(strings[115]); // 20111209
    //from part 4, why here? <--

    //jz - populate first row for percentage of ownership
    Tv[24] := Vl(strings[24]);
    If Vl(strings[24]) > 0 then
    begin
      strings[22]   := GetSpouseFirstName(RetNo);
      strings[117]  := GetSpouseLastName(RetNo);
      strings[119]  := LeftStr(GetSpouseAddress(RetNo), 33);
    end
    else strings[22] := '';

    //jz - Clears partner's percentage of ownership if not valid, but not sure why doing th: Tv[i] := Vl(strings[i]);
    i := 24;
    repeat
      Tv[i] := Vl(strings[i]);
      If (Tv[i] < 0) or (Tv[i] > 100) then
      begin
        Tv[i]       := 0;
        strings[i]  := '';
      end;
      Inc(i, 4);
    until i > 44;

    //jz//CCAv9 - elms no are longer SINS, are they somewhere else?
    {
    // sins
    i := 118;
    repeat
      strings[i] := RemoveChar(strings[i], ' ');
      strings[i] := RemoveChar(strings[i], '-');
      Inc(i, 2);
    until i > 128;
    }

    //jz//20260418//CCAv9 - do this only ONCE at the start
    ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    ExtractAutos(RetNo, 'T776', FInst, autosTermLossAmount, autosRecaptAmount, autosCCAForStmt);

    // get autoexpenses
    If UpperCase(strings[142]) <> 'Y' then
    begin
      //ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt); //jz//20260418//CCAv9 - extract is done ONCE above
      Tv[72] := 0;
      For i := 0 to ExtractedAutoList.count - 1 do
      begin
        ExtractedAutoRec := ExtractedAutoList.Items[i];
        If ExtractedAutoRec.PartnerFlag = '' then
          Tv[72] := Tv[72] + ExtractedAutoRec.ExpensesClaimed;
      end;
    end;

    //PART 4 begin =============================================================
    i := 58;  //personal percentage
    j := 406; //short term rental portion
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

    If (UpperCase(strings[140]) = 'Y') and (Tv[139] > 0) then
    begin
      If Tv[130] > 0 then Tv[95]  := Tv[139];
      If Tv[131] > 0 then Tv[134] := Tv[139];
      If Tv[133] > 0 then Tv[136] := Tv[139];
    end;
    //PART 4 end   =============================================================


    //PART 2 begin =============================================================
    //note is it here after part 4 code becase it needs tv[103]?
    Tv[143] := Tv[24] + Tv[28] + Tv[32] + Tv[36] + Tv[40] + Tv[44];
    strings[143] := FormatFloat('##0.0000', Tv[143]);

    //all this just for formatting?
    i := 23; //share of income/loss %
    Repeat
      strings[i + 1] := FormatFloat('##0.0000', Vl(strings[i + 1]));
      Tv[i + 1] := Vl(strings[i + 1]);
      If Tv[i + 1] = 0 then strings[i + 1] := '';
      Tv[i] := (Tv[103] * Tv[i + 1]) / 100;
      Tv[143] := 0;
      i := i + 4;
    until i > 43;
    //PART 2 end   =============================================================


    //PART 3 -->  =============================================================
    //Calc Income
    If UpperCase(strings[113]) <> 'Y' then  //Income from T5013?  (Y/N)
    begin
      Tv[405] := Tv[402] + Tv[403] + Tv[404];
      Tv[116] := Tv[47] + Tv[50] + Tv[53];
      Tv[56] := Tv[116] + Tv[55];
    end;
    //PART 3 <--  =============================================================

    //PART 4 --> =============================================================
    //Calc Expenses
    Tv[97] := 0;
    Tv[99] := 0;
    Tv[423] := 0;

    // 20241231
    //Horizontal --> ===============================
    i := 57;
    j := 406;
    Repeat
      if Tv[i + 1] > 0 then
        Tv[i + 2] := (Tv[i] * Tv[i + 1]) / 100
      Else
        Tv[i + 2] := 0; // 20250101
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
    //Horizontal <-- ===============================
    //Vertical --> ===============================
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
    //Vertical <-- ===============================

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
    // recapture
    //ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt); //jz//20260418//CCAv9 - extract is done ONCE above
    //Tv[20] := RecaptAmount;
    //ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,autosCCAForStmt); //jz//20260418//CCAv9 - done ONCE above
    //Tv[20] := Tv[20] + RecaptAmount;
    Tv[20]:=  GetTotalRecaptureAmt(RetNo,'T776', FInst);  //Recapture Amount //jz//20260414//CCAv7
    // Tv[20] := Tv[20] * Tv[114] / 100; // Apr 4 2008 //20240309

    // Term loss
    //ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt); //jz//20260418//CCAv9 - extract is done ONCE above
    Tv[21] := Tv[8] + Tv[20];

    Tv[100] := Tv[21] - Tv[98];

    //jz//20260414//CCAv7 - not sure why done twice and in this way, simplify below T776
    (*
    Tv[98] := TermLossAmount;

    ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);

    Tv[98] := Tv[98] + TermLossAmount;
    Tv[98] := Tv[98] * Tv[114] / 100;
    // CCA
    ExtractCCA(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount, CCAForStmt);
    Tv[105] := CCAForStmt;
    ExtractAutos(RetNo, 'T776', FInst, TermLossAmount, RecaptAmount,AutoCCAForStmt);
    *)

    //jz//20260414//CCAv7 - get CCA and terminal loss T776
    //ExtractCCA  (RetNo,'T776',FInst,TermLossAmount,RecaptAmount,CCAForStmt); //jz//20260418//CCAv9 - extract is done ONCE above
    //ExtractAutos(RetNo,'T776',FInst,TermLossAmount,RecaptAmount,autosCCAForStmt); //jz//20260418//CCAv9 - extract isdone ONCE above

    Tv[98]  := GetTotalTerminalLoss(RetNo,'T776', FInst);  //Term loss
    Tv[98] := Tv[98] * Tv[114] / 100;

    //CCA
    Tv[105] := Tv[265];    //jz//CCAv10 - get from Tv[265] so that flow matches form and override calcs work //CCAForStmt+autosCCAForStmt;       //CCA
    Tv[105] := Tv[105] * Tv[114] / 100;

    Tv[101] := Tv[100] - Tv[105];
    Tv[107] := Tv[101] * Tv[115] / 100;
    Tv[106] := Tv[107] + Tv[144] - Tv[108]; // 20100128
  end; //End with



  SaveTv(RetNo, FName, FNo);
end;


end.
