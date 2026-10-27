unit T3_2026calc2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
  System.Generics.Collections, vtScrollBox, vtChild, //20260115 Igor
  T3_2026Declare, T3_2026common, T3_2026common2, T3_2026TrimStr ;

  procedure T1134(RetNo: Integer; FName: string; FNo: Integer); //20260115 Igor
  procedure T1134S(RetNo: Integer; FName: string; FNo: Integer); //20260115 Igor

  Procedure T1255(RetNo:integer;FName:string;FNo:integer);  //20220327
  Function PrivateFoundation(RetNo:Integer):Boolean;
  Function PublicFoundation(RetNo:Integer):Boolean;

  Procedure TD3(RetNo:integer;FName:string;FNo:integer); {slip}
  Procedure T137(RetNo:integer;FName:string;FNo:integer); {slip}

  {Charity}
  Procedure T3010(RetNo: integer; FName: String;FNo: integer);
  {NPO}
  Procedure T1044(RetNo:integer;FName:string;FNo:integer);

  {pensions}
  Procedure T3GR(RetNo: integer; FName: String;FNo: integer);
  Procedure T3G(RetNo:integer;FName:string;FNo:integer);

  {
  Procedure T3RG_1(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RG_2(RetNo:integer;FName:string;FNo:integer);
  }
  {
  Procedure T3RIG_1(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RIG_2(RetNo:integer;FName:string;FNo:integer);

  Procedure T3RII_1(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RII_2(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RII_3(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RII_4(RetNo:integer;FName:string;FNo:integer);

  Procedure T3RI_1(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RI_2(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RI_3(RetNo:integer;FName:string;FNo:integer);
  Procedure T3RI_4(RetNo:integer;FName:string;FNo:integer);
  }

  //20150228
  Procedure T3P(RetNo:integer;FName:string;FNo:integer);
  Procedure T3PRP(RetNo:integer;FName:string;FNo:integer); //20240118 Igor
  //Procedure T3P_1(RetNo:integer;FName:string;FNo:integer);
  //Procedure T3P_2(RetNo:integer;FName:string;FNo:integer);


  {Elections}
  Procedure T2205(RetNo:integer;FName:string;FNo:integer);
  Procedure T123(RetNo:integer;FName:string;FNo:integer);
  Procedure T2019(RetNo: integer;FName:string;FNo:integer);
  {
  Procedure T2019_1(RetNo:integer;FName:string;FNo:integer);
  Procedure T2019_2(RetNo:integer;FName:string;FNo:integer);
  Procedure T2019_3(RetNo:integer;FName:string;FNo:integer);
  Procedure T2019_4(RetNo:integer;FName:string;FNo:integer);
  }

  Procedure T2022(RetNo:integer;FName:string;FNo:integer);
  Procedure T2047(RetNo:integer;FName:string;FNo:integer);

  Procedure T2054(RetNo:integer;FName:string;FNo:integer);

  Procedure T2057(RetNo:integer;FName:string;FNo:integer);

  Procedure T2058(RetNo:integer;FName:string;FNo:integer);

  Procedure T1OVP(RetNo:integer;FName:string;FNo:integer);

  Procedure BNK(RetNo: integer; FName: String;FNo: integer); {slip}

  Procedure T1098(RetNo:integer;FName:string;FNo:integer); //jz//20260309
  procedure T1099(RetNo: Integer; FName: string; FNo: Integer); //20261006 Alex

implementation

uses
  T3_2026, T3_2026Calc, vtShared, vtTrimStr, vtCommon, vtMulti, vtDynData; //20260115 Igor

Procedure T3010(RetNo: integer; FName: String;FNo: integer);
Var  i: integer; LargeCharity:Boolean;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
 { 20131231
  If (Strings[1]>'') and (Strings[1]<'2013-01-01') then
  begin
   for i:=1 to 388 do begin Strings[i]:='';Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  end;
  }
  For i:=1 to 402 do Tv[i]:=Round(Tv[i]);   //20130330

  If Strings[1]>'' then  //20130217
  begin
   If Strings[1]> IntToStr(MyStrToInt(AppYear)+2)+'-12-31' then
   begin
     Strings[1]:='';
     Strings[37]:='';
     Strings[2]:='';
     Exit;
   end;
  end;

  If Strings[28]>'' then LargeCharity:=True Else LargeCharity:=False;
  //page 3 section D
  If LargeCharity = True then
  begin
   Strings[64]:='';
   Strings[70]:='';
   For i:=71 to 90 do begin Strings[i]:='';Tv[i]:=0;end;
   Tv[63]:=0;
   Tv[287]:=0;    //20130125
   For i:=103 to 107 do begin Strings[i]:='';Tv[i]:=0;end;
   For i:=109 to 109 do begin Strings[i]:='';Tv[i]:=0;end; //20140918
  end
  else
  begin
   Tv[88]:=Tv[79]+Tv[80]+Tv[63]+Tv[83]+Tv[84]+Tv[85]+Tv[86]+Tv[87];
   Tv[104]:=Tv[89]+Tv[90]+Tv[103];
   Tv[107]:=TotMultiple(RetNo,'T1236',76);  //-TotMutiple(RetNo,'T1236',74); //20110213
   Tv[109]:=Tv[104]+Tv[107];  //+Tv[108];  //20110213
  end;

  //pg 4
  If Strings[112]='' then Strings[112]:=FormatDateTime('yyyy-mm-dd',Date);
  If CertificationMode then Strings[112]:='';
  //Strings[121]:=
  {
  Strings[122]:=OptRec.Prp_Name;
  Strings[123]:=OptRec.Prp_Street;
  Strings[124]:=OptRec.Prp_City+','+OptRec.Prp_Prov+','+OptRec.Prp_Postal;
  Strings[125]:=OptRec.Prp_Area;
  Strings[126]:=OptRec.Prp_Tel;
  }
  //pg 5
  If CertificationMode then for i:=121 to 126 do Strings[i]:='';
  //pg 8/9  Sch 6
  If LargeCharity = True then
  begin
   Tv[275]:=AddColumns(264,274,1);
   Tv[280]:=AddColumns(276,279,1);
   Tv[311]:=Tv[218];
   //20110213
   Tv[302]:=Tv[282]+Tv[285]+Tv[288]+Tv[289]+Tv[290]+Tv[291]+Tv[292]+Tv[293]     //AddColumns(285,293,1)+AddColumns(295,300,1);
           +Tv[295]+Tv[296]+Tv[297]+Tv[298]+Tv[299]+Tv[300];
   Tv[318]:=AddColumns(303,316,1);
   Tv[322]:=Tv[95];  //20130225
   Tv[324]:=TotMultiple(RetNo,'T1236',76);     //20110213
   Tv[327]:=Tv[318]+Tv[324];   //Tv[318]+Tv[324]+Tv[325]+Tv[326];      //20110213
  end
  Else
  begin
    for i:=262 to 338 do begin Strings[i]:='';Tv[i]:=0;End;
  end;
 end;
 SaveTv(RetNo,FName,FNo);
end;




Procedure T1044(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  If MidStr(Strings[1],3,1) = '-' then
      //Strings[1] := DDMMYYYYToYYYYMMDD(Strings[1]);
      Strings[1] := DMYToYMD(Strings[1]);
  If MidStr(Strings[2],3,1) = '-' then
      //Strings[2] := DDMMYYYYToYYYYMMDD(Strings[2]);
      Strings[2] := DMYToYMD(Strings[2]);
  If Strings[12]+Strings[13] ='' then Strings[13] :='X';
  Tv[26] := Tv[17]+Tv[18]+Tv[19]+Tv[20]+Tv[21]+Tv[22]+Tv[25];
  Tv[27] :=Tv[26];
  Tv[39] := Tv[29]+Tv[30]+Tv[31]+Tv[32]+Tv[33]+Tv[34]+Tv[35]+Tv[38];
  Tv[40] := Tv[39];
  Tv[44] := Tv[41]+Tv[43];
  Tv[45] := Tv[44];

 end;

//T1044 pg 2 -------------------------------------------------------------------
 with Ret[RetNo].Frm[FNo] do
 Begin
  // Tv[24]:=Tv[1]+Tv[2]+Tv[40];   //20120324
 end;

 SaveTv(RetNo,FName,FNo);
end;


{elections}
Procedure T2054(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[14] := MaxR(0,Tv[12] - Tv[13]);
  Tv[23] := Tv[112]; //Vl(FetchElm(RetNo,'T2054_2',12));
 end;

 //T2054 pg 2
 with Ret[RetNo].Frm[FNo] do
 Begin
  //If Strings[14] ='' then strings[14] := DateToMonthDayYear(Date);
  Tv[101] := Tv[12]; //Vl(FetchElm(RetNo,'T2054_1',12));
  Tv[103] := (Tv[101] * 0.01 * Tv[102]) /12;
  Tv[104] := Tv[102];
  Tv[105] := (500 * Tv[104])/12;
  Tv[106] := MinR(Tv[103],Tv[105]);

  Tv[107] := Tv[14]; //Vl(FetchElm(RetNo,'T2054_1',14));
  Tv[108] := Tv[107];
  Tv[109] := Tv[108] * 0.60;

  Tv[110] := Tv[106];
  Tv[111] := Tv[109];
  Tv[112] := Tv[110]+Tv[111];
  If Strings[114]='' then Strings[114]:= FormatDateTime('yyyy-mm-dd',Now);
 end;

 SaveTv(RetNo,FName,FNo);
end;

Procedure T3GR(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  //20240118 Igor >>> 	 
  If Strings[5]='' then strings[5] :=AppYear;

  Strings[10] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318

  Tv[56]:=Tv[53]+Tv[54]+Tv[55];
  Tv[58]:=Tv[56]-Tv[57];
  Tv[60]:= Vl(FetchElm(RetNo, 'T2000', 168)) + Vl(FetchElm(RetNo, 'T2000', 169)) + Vl(FetchElm(RetNo, 'T2000', 170)) + Vl(FetchElm(RetNo, 'T2000', 171)); //20260209 Igor
  Tv[62]:=Tv[60]+Tv[61];
  Tv[64]:=Tv[62]-Tv[63];
  //20240118 Igor <<<
 end;
 SaveTv(RetNo,FName,FNo);
end;



Procedure T3G(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  If Strings[13]='' then strings[13] :=AppYear;
  Strings[17] := IntToStr(
                  MyStrToInt(Strings[14])+
                  MyStrToInt(Strings[15])+
                  MyStrToInt(Strings[16])
                  );
  Strings[20] := Strings[17];
  Strings[22] := IntToStr(
                  MyStrToInt(Strings[20])-
                  MyStrToInt(Strings[21])
                  );
  //Strings[12] := Strings[19];
  If Strings[25] = '' then Strings[25] := FormatDateTime('yyyy-mm-dd',Now);
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RG_1(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RG_2(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   Strings[4] := IntToStr(
                  MyStrToInt(Strings[1])+
                  MyStrToInt(Strings[2])+
                  MyStrToInt(Strings[3])
                  );
   {
   Strings[24] := IntToStr(MyStrToInt(Strings[1])+MyStrToInt(Strings[5])
                   -MyStrToInt(Strings[6]));

   If Vl(Strings[24]) <0 then Strings[24] :='';
   Strings[8] := IntToStr(MyStrToInt(Strings[1])+MyStrToInt(Strings[5])
                                 -MyStrToInt(Strings[7]));
   }
 end;
 SaveTv(RetNo,FName,FNo);
end;




Procedure T3P(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

   Strings[79] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318

   //20240118 Igor >>>
   Tv[42]:=Tv[40]-Tv[41];
   Tv[45]:=Vl(FetchElm(RetNo,'T2000',174));

   Tv[58]:=Tv[46]+Tv[48]+Tv[50]+Tv[52]+Tv[55]+Tv[56]+Tv[57];
   Tv[63]:=Tv[47]+Tv[49]+Tv[51]+Tv[53]+Tv[54]+Tv[59]+Tv[60]+Tv[61]+Tv[62];
   Tv[64]:=Tv[58];
   Tv[65]:=Tv[63]-Tv[64];
   //20240118 Igor <<<
 end;
 SaveTv(RetNo,FName,FNo);
end;
//20260209 Igor >>>
procedure T3PRP(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
 LoadTv(RetNo, FName, FNo);

 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[53] := ifAmendedPopulateInitialRevNum(RetNo,FName); //jz//20260318
   Tv[47]:= Vl(FetchElm(RetNo, 'T2000', 172{174})); //20260209 Igor
   Tv[42]:= Vl(FetchElm(RetNo, 'T2000', 168)) + Vl(FetchElm(RetNo, 'T2000', 169)) + Vl(FetchElm(RetNo, 'T2000', 170)) + Vl(FetchElm(RetNo, 'T2000', 171));// Tv[47]; //20260209 Igor
   Tv[44]:= Tv[42] - Tv[43]; //20260209 Igor
 end;

 SaveTv(RetNo, FName, FNo);
end;
//20260209 Igor <<<
Procedure T123(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2019(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
 If Strings[26]='' then Strings[26]:=AppYear;
  Tv[29] := MaxR(0, Tv[27] - Tv[28]);
  Tv[30] := Tv[29];
  If Tv[31]>Tv[30] then Tv[31]:=Tv[30];
 end;
 SaveTv(RetNo,FName,FNo);
end;

(*
Procedure T2019_1(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[3] := MaxR(0,Tv[1] - Tv[2]);
  Tv[4] := Tv[3];
  Tv[6] := Tv[4] +Tv[5];
  If UpperCase(Strings[8]) <> 'Y' then Tv[7] := Tv[6];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2019_2(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[4] := MaxR(0,Tv[2] - Tv[3]);
  Tv[5] := Tv[4];
  Tv[22] := Tv[1] +Tv[5]+Tv[21];


  Tv[15] := Tv[11]+Tv[12]+Tv[13]+Tv[14];
  Tv[16] := Tv[15];
  Tv[17] := Vl(FetchElm(RetNo,'T2019_3',26));
  Tv[20] := Tv[18]+Tv[19];

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2019_3(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[15] := Vl(FetchElm(RetNo,'T2019_1',7));
  Tv[17] := MaxR(0,Tv[15] - Tv[16]);
  If UpperCase(Strings[53]) <> 'Y' then Tv[18] := Tv[17];
  Tv[23] := Vl(FetchElm(RetNo,'T2019_2',22));
  Tv[24] := Tv[16];
  Tv[25] := Tv[18];
  Tv[26] := Tv[23]+Tv[24]+Tv[25];
  Tv[27] := Vl(FetchElm(RetNo,'T2019_2',6));
  Tv[28] := Vl(FetchElm(RetNo,'T2019_2',10));
  Tv[29] := Vl(FetchElm(RetNo,'T2019_2',16));
  Tv[30] := Tv[28]+Tv[29];
  Tv[31] := MinR(Tv[27],Tv[30]);
  Tv[32] := MaxR(0,Tv[30] - Tv[31]);
  Tv[52] := Tv[32];
  Tv[33] := Tv[30];
  If Tv[33] <> 0 then Tv[34] := Tv[52]/Tv[33] else Tv[34] :=0;
  If Tv[34] > 1 then Tv[34] :=1;
  Tv[35] := Tv[34];  {? minus?}
  Tv[36] := MaxR(0,1 - Tv[35]);
  Tv[37] := Vl(FetchElm(RetNo,'T2019_2',17));
  Tv[38] := Vl(FetchElm(RetNo,'T2019_2',20));
  Tv[39] := Tv[37] + Tv[38];
  Tv[40] := Tv[39];
  Tv[41] := Tv[36];
  Tv[42] := Tv[40] * Tv[41];
  Tv[43] := MaxR(0,Tv[27]-Tv[42]);

  Tv[44] := Tv[26];
  Tv[45] := Tv[43];
  Tv[46] := MaxR(0,Tv[44] - Tv[45]);
  If Tv[47] > Vl(FetchElm(RetNo,'T2019_2',19)) then
      Tv[47] :=Vl(FetchElm(RetNo,'T2019_2',19));
  Tv[50] := Tv[46]+Tv[47]+Tv[48]+Tv[49];


 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2019_4(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
    Tv[1] := Vl(FetchElm(RetNo,'T2019_3',43));
    Tv[6] := Tv[1]+Tv[2]+Tv[3]+Tv[4]+Tv[5];
    If Vl(FetchElm(RetNo,'T2019_3',18)) < Vl(FetchElm(RetNo,'T2019_3',17))
    then
    begin
      Tv[8] := Vl(FetchElm(RetNo,'T2019_1',7));
      Tv[45] := Tv[43];
      Tv[46] := MaxR(0,Tv[44] - Tv[45]);
      Tv[50] := Tv[46]+Tv[47]+Tv[48]+Tv[49];
    end
   else
   begin
    Tv[46] :=0;
    Tv[50] :=0;
   end;
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

Procedure T2022(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
    Tv[19] := Tv[16] - Tv[17];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2047(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  {OK}
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2057(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[25] := MaxR(0,Tv[23] - Tv[24]);
  Tv[26] := Tv[25];
  Tv[27] := (Tv[26]/4) * 0.01 * Tv[28];
  If Tv[27] > 8000 then Tv[27] :=8000;
  Tv[29] := 100 * Tv[28];
  Tv[30] := MinR(Tv[27],Tv[29]);
 end;

 // T2057 pg 2 -----------------------------------------------------------------


 // T2057 pg 3 -----------------------------------------------------------------
 with Ret[RetNo].Frm[FNo] do
 Begin
  i:=203;
  Repeat
   Tv[i+3] := Tv[i+2]-Tv[i+1];
   Inc(i,8);
  until i>331;
 end;

 SaveTv(RetNo,FName,FNo);
end;




Function PublicFoundation(RetNo:Integer):Boolean;
begin
 Result :=false;
 If FetchElm(RetNo,'QUOTP_1',25) >'' then result :=True;
end;

Function PrivateFoundation(RetNo:Integer):Boolean;
begin
 Result :=false;
 If FetchElm(RetNo,'QUOTP_1',26) >'' then result :=True;
end;


(*
procedure T5014(RetNo: integer;FName: string;FNo: integer);
Var i,DaysInYear:integer;
begin
  DaysInYear:=GetT5013NumDays(RetNo);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    {FillHeader(RetNo,FNo,194,195,196);}
    Strings[194] := FetchElm(RetNo,'T5013_1',5);
    Strings[195] := FetchElm(RetNo,'T5013_1',3);
    Strings[196] := FetchElm(RetNo,'T5013_1',2);
    {CCA}
    Tv[193] := 0;
    I := 1;
    Repeat
      If Uppercase(Strings[191]) <> 'X' then Strings[i+6] := GetCCARate(Strings[i]);
      CalcT5014CCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       Tv[i+4],Tv[i+5],Strings[i+6],Tv[i+7],Tv[i+8],
                       Strings[191],Strings[i+9],DaysInYear);

     {proration done at CalcCca}
     Tv[193] := Tv[193] + Tv[I+7];
     I := i+10;
    until i > 182;

    Tv[193] := Tv[193] + Tv[192]+Tv[197];
  end;
  SaveTv(RetNo,FName,FNo);
end;

*)

Procedure T3RI_1(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   Tv[17] := Vl(FetchElm(RetNo,'T3RI_4',26));
   Tv[18] := Vl(FetchElm(RetNo,'T3RI_4',76));
   Tv[19] := Vl(FetchElm(RetNo,'T3RI_4',126));
   Tv[20] := Vl(FetchElm(RetNo,'T3RI_3',166));
   Tv[21] := Vl(FetchElm(RetNo,'T3RI_3',9));
   Tv[22] := Tv[17]+Tv[18]+Tv[19]+Tv[20]+Tv[21];
   Tv[26] := Tv[22] - Tv[23];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RI_2(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
  begin
    {OK no calcs needed}
  end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RI_3(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  i:=10;
  Repeat
   Tv[i+3] := Tv[i] * 0.20;
   Tv[i+4] := MaxR(0,Tv[i+1] - Tv[i+3]);
   Tv[i+5] := MinR(Tv[i+2],Tv[i+4]);
   Inc(i,6);
  until i> 76;

  i:=82;Tv[166] :=0;
  Repeat
   {relate to prv table}
   If i=82  then j:=10;
   If i=89  then j:=16;
   If i=96  then j:=22;
   If i=103 then j:=28;
   If i=110 then j:=34;
   If i=117 then j:=40;
   If i=124 then j:=46;
   If i=131 then j:=52;
   If i=138 then j:=58;
   If i=145 then j:=64;
   If i=152 then j:=70;
   If i=159 then j:=76;
   Tv[i] := Tv[j+5] * 0.01;
   Tv[i+1] := Tv[i] * 0.20;
   If Tv[i+3] <> 0 then
    Tv[i+4] := 5000 + Tv[i] * (Tv[i+2]/Tv[i+3])
   else
    Tv[i+4] :=0;
   Tv[i+5] := MaxR(Tv[i+4],Tv[i+5]);
   Tv[i+6] := MinR(Tv[i],Tv[i+5]);
   Tv[166] := Tv[166]+Tv[i+6];
   Inc(i,7);
  until i> 159;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RI_4(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  i:=2;Tv[25] :=0;
  Repeat
   Tv[25] := Tv[25]+Tv[i];
   Inc(i,2);
  until i>24;
  Tv[26] := Tv[25] * 0.01;

  i:=30;Tv[75] :=0;
  Repeat
   Tv[i] := MaxR(0,Tv[i-2]-Tv[i-1]);
   Tv[75] := Tv[75]+Tv[i];
   Inc(i,4);
  until i>74;
  Tv[76] := Tv[75] * 0.01;

  i:=80;Tv[125] :=0;
  Repeat
   Tv[i] := MaxR(0,Tv[i-2]-Tv[i-1]);
   Tv[125] := Tv[125]+Tv[i];
   Inc(i,4);
  until i>124;
  Tv[126] := Tv[125] * 0.01;


 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure TD3(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  {OK no calcs needed}
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2058(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[24] := MaxR(0,Tv[22] - Tv[23]); {negative ?}
  Tv[25] := Tv[24];
  Tv[26] := (Tv[25] /4) * 0.01 * Tv[32];
  Tv[27] := 100;
  Tv[28] := Tv[27] * Tv[32];
  If Tv[28] > 8000 then Tv[28] := 8000;
  Tv[29] := MinR(Tv[26],Tv[28]);
 end;
 SaveTv(RetNo,FName,FNo);

 // T2058 pg 2 -----------------------------------------------------------------

 // T2058 pg 3 -----------------------------------------------------------------
 with Ret[RetNo].Frm[FNo] do
 Begin
   i:=203;
   Repeat
     Tv[i+3] := Tv[i+2]-Tv[i+1];
     Inc(i,8);
   until i>307;

   i:=323;
   Repeat
     Tv[i+3] := Tv[i+2]-Tv[i+1];
     Inc(i,8);
   until i>323;

   i:=344;
   Repeat
     Tv[i+3] := Tv[i+2]-Tv[i+1];
     Inc(i,8);
   until i>352;
 end;



end;


Procedure T1OVP(RetNo: integer; FName: String;FNo: integer); {slip}
Var
    i,k,j: integer;//Pg3FNo:Integer;
    Age: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

  Tv[8] := MaxR(0,Tv[6] - Tv[7]);
  Tv[10] := Tv[8] - Tv[9];   //?? remove  Thre is no 10,12 and 21
  Tv[12] := Tv[10]+Tv[11];   // remove

  //Pg3FNo:=GetFormNo('T1OVP');
  Tv[13]:=0;
  i:=513;
  Repeat
   Tv[13]:=Tv[13]+Vl(FetchElmFNo(RetNo,FNo,i));
   Inc(i,1);
  until i>524;
  If UpperCase(Strings[21]) = 'Y' then Tv[12] := Tv[20];  //remove??
  Tv[15] := Tv[13] * 1/100;
  Strings[18]:=FormatDateTime('yyyy-mm-dd',Date);

 //T1OVP pg 2 ------------------------------------------------------------------
  If Strings[140]='' then strings[140]:=AppYear;
  i:=102;
  Repeat
   //If Strings[i]:=IntToStr(MyStrToInt(AppYear)-1) then Tv
   Tv[i+3]:=MaxR(0,Tv[i]+Tv[i+1]-Tv[i+2]);
   Inc(i,6);
  until i>132;

  Tv[139]:=Tv[137]+Tv[138];

 //T1OVP pg 3 ------------------------------------------------------------------

  Age:=CalcAgeTo(Ret[RetNo].Frm[FNo].Strings[525],IntToStr(MyStrToInt(AppYear)-1)+'-12'+'-31');

  for k:=0 to 11 do
  Begin
    //first column
    if k=0 then  //first column
    Begin
     Tv[189]:= Tv[8]; //Vl(FetchElm(RetNo,'T1OVP_1',8));
     Tv[225]:=Tv[189]+Tv[201]+Tv[213];
     Tv[249]:=Tv[225]-Tv[237];
    end
    Else
    Begin
     Tv[189+k]:=Tv[249+k-1]; //line 1
     Tv[225+k]:=Tv[189+k]+Tv[201+k]+Tv[213+k];  //line 4
     Tv[249+k]:=Tv[225+k]-Tv[237+k];   //line 6
    End;
    Tv[261+k]:=Tv[139];
    Tv[285+k]:=Tv[261+k]+Tv[273+k];
    If Age>=19 then Tv[297+K]:=2000 else Tv[297+K]:=0;
    Tv[309+k]:=Tv[285+k]+Tv[297+k];
  end;

   //Part B
   If UpperCase(Strings[526]) = 'X' then
   begin
    for k:=0 to 11 do
    begin
       Tv[345+k]:=MaxR(0,Tv[285+k]-Tv[333+k]);
       Tv[357+k]:=MaxR(0,Tv[321+k]-Tv[345+k]);
       Tv[369+k]:=MinR(Tv[321+k],Tv[357+k]);
       Tv[381+k]:=MaxR(0,Tv[249+k]-Tv[309+k]);
       Tv[393+k]:=MinR(Tv[369+k],Tv[381+k]);
    end;
   end
   else
   begin
     For j:=321 to 404 do Tv[j]:=0;
   end;

   //Part C
   for k:=0 to 5 do
   Begin
    Tv[405+k]:=MaxR(0,Tv[309+k]+Tv[393+k]);
    Tv[417+k]:=MaxR(0,Tv[249+k]-Tv[405+k]);

    Tv[411+k]:=MaxR(0,Tv[315+k]+Tv[399+k]);
    Tv[423+k]:=MaxR(0,Tv[255+k]-Tv[411+k]);
   end;
   //final calc amount due  //20170623
    Tv[13]:=0;
    for i:=417 to 422 do Tv[13]:=Tv[13]+Tv[i];
    for i:=423 to 428 do Tv[13]:=Tv[13]+Tv[i];
    Tv[15]:=Tv[13]*1/100;
    Tv[17]:=Tv[15];
    if Tv[17]<2 then Tv[17]:=0;
 SaveTv(RetNo,FName,FNo);
end;

end;


(*
Procedure T3RIG_1(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  {?}
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure T3RIG_2(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
 {
   Strings[4] := IntToStr(MyStrToInt(Strings[2])+MyStrToInt(Strings[3]));
   Strings[5] := Strings[4];
   Strings[7] := IntToStr(MyStrToInt(Strings[1])+MyStrToInt(Strings[5])
                   -MyStrToInt(Strings[6]));
   If Vl(Strings[7]) <0 then Strings[7] :='';
   Strings[9] := IntToStr(MyStrToInt(Strings[1])+MyStrToInt(Strings[5])
                                 -MyStrToInt(Strings[8]));

   }
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)
Procedure T3RII_1(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[18] := Vl(FetchElm(RetNo,'T3RII_2',122));
  Tv[19] := Vl(FetchElm(RetNo,'T3RII_3',1));
  Tv[20] := Vl(FetchElm(RetNo,'T3RII_3',39));
  Tv[23] := Tv[18]+Tv[19]+Tv[20]+Tv[21]+Tv[22];
  Tv[36] := Tv[24]+Tv[25]+Tv[28];
  Tv[37] := Tv[36];
  Tv[26] := Tv[23] - Tv[37];
  
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RII_2(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
    {Part 2}
  i:=127;
  Repeat
   If i=127 then
                      Tv[127] := Tv[123]+Tv[124]+Tv[125]
   else If i=131 then Tv[131] := Tv[124]+Tv[125]+Tv[126]
   else If i=135 then Tv[135] := Tv[125]+Tv[126]+Tv[130]
   else Tv[i] := Tv[i-13]+Tv[i-9]+Tv[i-5];
   Tv[i+1] := Tv[i] /3;
   Tv[i+2] := MaxR(Tv[i],Tv[i+1]);
   Inc(i,4);
  until i>171;

  {top part}
  i:= 6; Tv[121] :=0;
  Repeat
   {relate to part 2}
   If i=6 then j:=129;
   If i=16 then j:=133;
   If i=26 then j:=137;
   If i=36 then j:=141;
   If i=46 then j:=145;
   If i=56 then j:=149;
   If i=66 then j:=153;
   If i=76 then j:=157;
   If i=86 then j:=161;
   If i=96 then j:=165;
   If i=106 then j:=169;
   If i=116 then j:=173;

   Tv[i-1] := 3 * Tv[j];
   Tv[i-2] := Tv[i-5] * 0.20;
   Tv[i] := MinR(Tv[i-1],Tv[i-2]);
   Tv[i+1] := Tv[i-2]+Tv[i];
   Tv[i+2] := MaxR(0,Tv[i-4] - Tv[i+1]);
   Tv[i+3] := MinR(Tv[i+2],Tv[i-3]);
   Tv[121] := Tv[121]+Tv[i+3];
   Inc(i,10);
  until i>116;
  Tv[122] := Tv[121] * 0.01;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RII_3(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  i:=2;Tv[38] :=0;
  repeat
   Tv[i+2] := MaxR(0,Tv[i] - Tv[i+1]);
   Tv[38]:=Tv[38]+Tv[i+2];
   Inc(i,3);
  until i>35;
 Tv[39] := Tv[38] * 0.01;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RII_4(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[3] := Tv[1]-Tv[2];
  Tv[4] := Tv[3] * 0.75;
  Tv[5] := Tv[4];
  Tv[14] := Tv[5]+Tv[6]+Tv[7]+Tv[8]+Tv[10]+Tv[12]+Tv[13];
  Tv[15]:=Tv[14];
  Tv[20] := Tv[16]+Tv[17]+Tv[18]+Tv[19];
  Tv[21] := Tv[20];
  Tv[22] := Tv[15] - Tv[21];

  Tv[28] := Tv[23]+Tv[24]+Tv[25]+Tv[26]+Tv[27];
  Tv[29]:=Tv[28];
  Tv[30] := Tv[22] - Tv[29];
  Tv[32] := Tv[30]+Tv[31];

  Tv[36] := Tv[33]+Tv[34]+Tv[35];
  Tv[37]:=Tv[36];
  Tv[38] := Tv[32]-Tv[37];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3RII_5(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  i:=1;Tv[37] :=0;
  Repeat
   Tv[i+2] := MaxR(0,Tv[i] - Tv[i+1]);
   Tv[37] := Tv[37]+Tv[i+2];
   Inc(i,3);
  until i>34;
  Tv[38] := Tv[37] * 0.01;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T137(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  {?}
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure BNK(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  {?}
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T2205(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[8] := MaxR(0,Tv[6] - Tv[7]);
  Tv[9] := Tv[8];
  Tv[12] := MaxR(0,Tv[10] - Tv[11]);
  Tv[13] := Tv[12];
  Tv[14] := TV[6];
  Tv[15] := MinR(Tv[9], Tv[13]);
  Tv[16] := MaxR(0,Tv[14] - Tv[15]);
  {rrif}
  Tv[20] := MaxR(0,Tv[18] - Tv[19]);
  Tv[21] := Tv[20];
  Tv[22] := Tv[17]+Tv[21];
  Tv[23] := Tv[22];
  Tv[26] := MaxR(0,Tv[24] - Tv[25]);
  Tv[27] := Tv[26];
  Tv[29] := MinR(Tv[23], Tv[27]);
  Tv[30] := MaxR(0,Tv[28] - Tv[29]);
 end;
 SaveTv(RetNo,FName,FNo);
end;

//copied from T1 T2091 routine EXCEPT IsDeceased
Procedure T1255(RetNo:integer;FName:string;FNo:integer);   //20220327
Var i:Integer;  Finst:String;
Begin
 LoadTv(RetNo,FName,FNo);
 With ret[RetNo].Frm[FNo] do
 begin
  Strings[26]:=AppYear;  //20220222
  //20210412
  {
  if IsDeceased(RetNo)=False then   //
  Begin
   for i:=1 to 152 do begin Strings[i]:='';Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  End;
  }
  FInst:=ExtractFormInst(FName);  //20120126
  if Tv[4]>100 then Tv[4]:=100; //20220129 spouse %

  Strings[26]:=AppYear;  //20180114
  {for T3 only
  Strings[18]:=GetSinNo(RetNo);
  If Strings[2]='' then Strings[2]:=GetFirstName(RetNo)+' '+GetLastName(RetNo);
  If Strings[5]='' then Strings[5]:=FormatDateTime('yyyy-mm-dd',Date);
  }
  Strings[25]:=IntToStr(MyStrToINt(Strings[6])+MyStrToINt(Strings[7]));  //20171203
  Strings[11]:=IntToStr(MyStrToInt(Strings[9])+MyStrToINt(Strings[10]));
  Tv[12]:=Tv[24]; //20220125
  Strings[8]:=Strings[25]; //20180221

  if (Strings[22]='') or (UpperCase(Strings[22])='CA') then Strings[22]:='CAN';  //20180116
 end;

 //pg 2
  With ret[RetNo].Frm[FNo] do
 begin
  Tv[140]:=Tv[12];
  Tv[141]:=Tv[14];
  Tv[142]:=Tv[13];
  Tv[143]:=Tv[141]+Tv[142];
  Tv[144]:=Tv[143];
  Tv[145]:=MaxR(0,Tv[140]-TV[144]);

  Tv[146]:=Tv[145];
  Strings[147]:=IntToStr(MyStrToInt(Strings[8])+1);
  Tv[148]:=Tv[146]*Vl(Strings[147]);
  Strings[149]:=Strings[11];
  If Vl(Strings[149])>0 then
    Tv[150]:=Tv[148]/Vl(Strings[149])
  else
    Tv[150]:=0;
  Tv[151]:=Tv[150];
  Tv[152]:=MaxR(0,Tv[145]-Tv[151]);

  if UpperCase(Strings[3])='Y' then  //20220115
  Begin
   Tv[101]:=Tv[16];
   Tv[102]:=Tv[15];
   Tv[103]:=MaxR(0,Tv[101]-Tv[102]); //20110410 //Tv[103]:=MaxR(0,Tv[1]-Tv[2]);
   Tv[104]:=Tv[103];
   Strings[105]:=IntToStr(MyStrToInt(Strings[6])+1);
   Tv[106]:=Tv[104]*Vl(Strings[105]);
   Strings[107]:=Strings[9];
   If Vl(Strings[107])>0 then
    Tv[108]:=Tv[106]/Vl(Strings[107])
   else
    Tv[108]:=0;
   Tv[109]:=Tv[108];
   Tv[110]:=MaxR(0,Tv[103]-Tv[109]);
  End
  Else
  Begin
   for i:=101 to 110 do Tv[i]:=0;
   Strings[105]:='';
   Strings[107]:='';
  End;

 Tv[111]:=Tv[12];
 Tv[112]:=Tv[16];
 If Tv[112]>Tv[111] then
 begin
  For i:=112 to 124 do begin Tv[i]:=0;Strings[i]:='';end
 end
 else
 begin
  Tv[113]:=Tv[17];
  Tv[114]:=Tv[13];
  Tv[115]:=Tv[112]+Tv[113]+Tv[114];
  Tv[116]:=Tv[115];
  Tv[117]:=Tv[111]-Tv[116];

  Tv[118]:=Tv[117];
  Strings[119]:=Strings[7];
  Tv[120]:=Tv[118]*Vl(Strings[119]);
  Strings[121]:=Strings[10];
  If Vl(Strings[121])>0 then
  Tv[122]:=Tv[120]/Vl(Strings[121])
  else
   Tv[122]:=0;
  Tv[123]:=Tv[122];
  Tv[124]:=MaxR(0,Tv[117]-Tv[123]);
 end;
 Tv[125]:=Tv[16];
 Tv[126]:=Tv[12];
 Tv[127]:=MaxR(0,Tv[125]-Tv[126]);

 Tv[128]:=Tv[110];
 Tv[129]:=Tv[124];
 Tv[130]:=Tv[128]+Tv[129];
 Tv[131]:=Tv[127];
 Tv[132]:=MaxR(0,Tv[130]-Tv[131]);
 Tv[133]:=Tv[132];

 If UpperCase(Strings[138])<>'Y' then
 begin
  For i:=101 to 133 do begin Strings[i]:='';Tv[i]:=0;end;
 end;
 If UpperCase(Strings[138])='Y' then
  Tv[134]:=MinR(Tv[152],Tv[133])
 else
  Tv[134]:=Tv[152];

 Tv[135]:=0;   //20220129
 Tv[137]:=0;

 Tv[136]:=vl(FetchElm(RetNo,'T209W'+Finst,144));  //20220127
 if Tv[136]>0 then
 begin
  Tv[135]:=Tv[134];
  Tv[137]:=MaxR(0,Tv[135]-Tv[136]);
 end;

 end;
 SaveTv(RetNo,FName,FNo);
End;


(*
//20251220
Procedure T106(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   //unique to each App
   {T2
    Strings[5] := GetCorpName(RetNo);
    Strings[6] := GetAccountNumber(RetNo);
    Strings[23] := FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[24] := FetchElm(RetNo, 'T2', 16);
    Strings[25] := FetchElm(RetNo, 'T2', 17);
    Strings[26] := FetchElm(RetNo, 'T2', 20);
    Strings[27] := GetBegYearEnd(RetNo);
    Strings[28] := GetTaxationYearEnd(RetNo);
   }
   //t1? T2 T3 TF?

    // FillHeader(RetNo,FNo,1,2,3);    //20171126
    if Strings[3] = '' then
      Strings[3] := '1  New'; // 20180628

    if Strings[3] = '3   Amended' then //jz 20241211 if amended print Amended at top of page
      Strings[78] := 'AMENDED';

    For i := 8 to 22 do
      Strings[i] := '';
    if Strings[110] = '' then
      Strings[110] := '1  New';
    Strings[4] := 'X';
    if Strings[2] = '' then
      Strings[2] := 'CAN'; // 20220718



    Strings[32] := IntToStr(CountMultipleInstances(RetNo, 'T106SL'));

    // 20180719 Tv[33]:=TotMultiple(RetNo,'T106SL',174);
    Tv[33] := TotMultipleExludingDeletedSlips(RetNo, 'T106SL', 174, 110,
      '4   Delete (Close)');

    Tv[34] := TotMultiple(RetNo, 'S125', 14); // GIFIIS','8299');   //20150826

    // 20180801
    for i := 35 to 38 do
    begin
      Strings[i] := LeftStr(Strings[i], 6);
      // NAICS Replacing CleanUp routine in ChildWinNew
    end;
    Strings[60] := LeftStr(Strings[60], 3);
    // Functional currency Replacing CleanUp routine in ChildWinNew
    Strings[2] := LeftStr(Strings[2], 3);
    // Functional currency Replacing CleanUp routine in ChildWinNew

    // 20171126
    //Section 2
    If Strings[29] + Strings[30] = '' then
      Strings[30] := 'X';
    If Strings[39] + Strings[40] = '' then
      Strings[40] := 'X';
    If Strings[41] + Strings[42] = '' then
      Strings[42] := 'X';

    //If Strings[43] + Strings[44] = '' then //jz 20241126 no longer exists
    //  Strings[44] := 'X';

    //jz 20241126 new fields <<
    If Strings[65] + Strings[66] = '' then
      Strings[66] := 'X';
    If Strings[66] = '' then Strings[67] := '';

    If Strings[68] + Strings[69] = '' then
      Strings[69] := 'X';

    If Strings[70] + Strings[71] = '' then
      Strings[71] := 'X';

    //jz 20241126 >>

    If Strings[45] + Strings[46] = '' then
      Strings[46] := 'X';
    If Strings[49] + Strings[50] = '' then
      Strings[50] := 'X';
    If Strings[51] + Strings[52] = '' then
      Strings[52] := 'X';

    //Certification
    If Strings[53] = '' then
      Strings[53] := FetchElm(RetNo, 'T2', 743);
    If Strings[54] = '' then
      Strings[54] := FetchElm(RetNo, 'T2', 742);
    If Strings[55] = '' then
      Strings[55] := FetchElm(RetNo, 'T2', 755);
    If Strings[56] = '' then
      Strings[56] := FetchElm(RetNo, 'T2', 746);
    If Strings[59] = '' then
      Strings[59] := FetchElm(RetNo, 'T2', 744);
    If Strings[57] = '' then
      Strings[57] := FetchElm(RetNo, 'T2', 743) + ' ' +
        FetchElm(RetNo, 'T2', 742);
    If Strings[58] = '' then
      Strings[58] := FetchElm(RetNo, 'T2', 745);
  end;
  SaveTv(RetNo, FName, FNo);
end;

//20251220
Procedure T106SL(RetNo: integer; FName: String; FNo: integer);
Var
  i, k: integer;
  FInst: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //uniiqe to each APP
    {//T2
    Strings[1] := GetCorpBusNo(RetNo);
    Strings[8] := GetBegYearEnd(RetNo);
    Strings[9] := GetTaxationYearEnd(RetNo);
    if Strings[14] + Strings[15] + Strings[16] = '' then
      Strings[14] := ''; // 20171130
    }
   //T1  etc

    FInst := ExtractFormInst(FName);
    Strings[124] := MidStr(FInst, 2, 3);
    if Strings[110] = '' then
      Strings[110] := '1  New'; // 20180628
    Strings[125] := IntToStr(CountMultipleInstances(RetNo, 'T106SL'));
    // FillHeader(RetNo,FNo,1,2,3);
    Strings[23] := 'X';

    Tv[92] := Tv[120] + AddColumns(32, 88, 4) + Tv[126] + Tv[130] + Tv[134];
    // 20180719 was missing elms in addition Tv[92]:=Tv[120]+AddColumns(32,88,4);
    Tv[94] := Tv[122] + AddColumns(34, 90, 4) + Tv[128] + Tv[132] + Tv[136];
    // was missing elms in addition Tv[94]:=Tv[122]+AddColumns(34,90,4);

    i := 96;
    Tv[108] := 0;
    Tv[109] := 0;
    Repeat
      Tv[i + 3] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2]);
      Tv[108] := Tv[108] + Tv[i + 1];
      Tv[109] := Tv[109] + Tv[i + 2];
      Inc(i, 4);
    until i > 104;
    // new row //20220618
    Tv[179] := Tv[176] + Tv[177] - Tv[178];
    Tv[108] := Tv[108] + Tv[177];
    Tv[109] := Tv[109] + Tv[178];

    i := 138;
    k := 0;
    Tv[171] := 0;
    Tv[172] := 0;
    Tv[173] := 0;
    Repeat
      k := k + MyStrToInt(Strings[i]);
      Tv[171] := Tv[171] + Tv[i + 1];
      Tv[172] := Tv[172] + Tv[i + 2];
      Tv[173] := Tv[173] + Tv[i + 3];
      Inc(i, 4);
    until i > 166;
    Strings[170] := IntToStr(k);
    Tv[174] := Tv[92] + Tv[94] + Tv[108] + Tv[109] + Tv[172] + Tv[173];
    Tv[114] := Tv[111] + Tv[112] - Tv[113];
    Tv[118] := Tv[115] + Tv[116] - Tv[117];
  end;
  SaveTv(RetNo, FName, FNo);
end;
*)

//20260115 Igor >>>
procedure T1134(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  ArrayNo, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: Integer;
  AccountNumbers, ForeignAffiliates: TList<string>;
  IncorrectElmIDs: TList<Integer>;
  Value: string;
  MyScrollBox: TvtScrollBox;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    for i:= 1 to 8 do Strings[i]:= '';
    for i:= 12 to 14 do Strings[i]:= '';

    Strings[9]:= 'X';
    Strings[10]:= GetT3TrustName(RetNo);
    Strings[11]:= GetT3AccountNumber(RetNo);

    if not FetchElm(RetNo, 'T3', 136).IsEmpty() then  //individual
    begin
      if strings[15].IsEmpty() then Strings[15]:= FetchElm(RetNo, 'T3', 4); // street
      if Strings[16].IsEmpty() then Strings[16]:= FetchElm(RetNo, 'T3', 7); //city
      if Strings[17].IsEmpty() then Strings[17]:= FetchElm(RetNo, 'T3', 67); //prov
      if Strings[18].IsEmpty() then Strings[18]:= FetchElm(RetNo, 'T3', 8); //postal
    end else
    if not FetchElm(RetNo, 'T3', 137).IsEmpty() then  //Company
    begin
      if strings[15].IsEmpty() then Strings[15]:= FetchElm(RetNo,'T3',64);    // street
      if Strings[16].IsEmpty() then Strings[16]:= FetchElm(RetNo,'T3',65);    //city
      if Strings[17].IsEmpty() then Strings[17]:= FetchElm(RetNo,'T3',66);   //prov
      if Strings[18].IsEmpty() then Strings[18]:= FetchElm(RetNo,'T3',74);  //postal
    end;

    if Strings[19].IsEmpty() then Strings[19]:= FetchElm(RetNo, 'T3', 14); //AppYear + '-01-01'; //Fisc start
    if Strings[20].IsEmpty() then Strings[20]:= FetchElm(RetNo, 'T3', 17); //AppYear + '-12-31'; //Fisc end;

    if Strings[141].IsEmpty() then Strings[141]:= 'CAN';
    //Otherwise user must select from FCounty.d (No need to maintain anothe table of countries for 2 to 3 char conversion it is an incostistency by CRA

    Strings[142]:= IntToStr(CountMultipleInstances(RetNo, 'T1134S'));

    if Strings[143].IsEmpty() then Strings[143]:= FetchElm(RetNo, 'T3', 327);
    if Strings[23].IsEmpty() then Strings[23]:= FetchElm(RetNo, 'T3', 327);
    if Strings[145].IsEmpty() then Strings[145]:= FetchElm(RetNo, 'T3', 333);
    if Strings[146].IsEmpty() then Strings[146]:= FetchElm(RetNo, 'T3', 334);
    if Strings[147].IsEmpty() then Strings[147]:= FetchElm(RetNo, 'T3', 341);
    if Strings[148].IsEmpty() then Strings[148]:= FetchElm(RetNo, 'T3', 339);

    AccountNumbers:= TList<String>.Create;
    ForeignAffiliates:= TList<String>.Create;
    IncorrectElmIDs:= TList<Integer>.Create;
    try
      if Assigned(RetList[RetNo].MyChild) and (RetList[RetNo].MyChild.ActiveForm <> nil) and SameText(RetList[RetNo].MyChild.ActiveForm.FormName, 'T1134') then
        MyScrollBox:= RetList[RetNo].MyChild.ActiveForm;

      //Reporting trust number
      AccountNumbers.Add(Strings[11]); //20260115 Igor

      //Individuals
      ArrayNo:= 1;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 10;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      //Corporations
      ArrayNo:= 2;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      // trusts
      ArrayNo:= 3;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      //Partnerships
      ArrayNo:= 4;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;

      //Pre populate B other information
      ArrayNo:= 5;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 1;
      LastElm:= Elm;
      //Remove existing account numbers and collect ids with incorrect account numbers
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (AccountNumbers.IndexOf(Value) >= 0) then AccountNumbers.Remove(Value) else IncorrectElmIDs.Add(Elm);
        end else
          IncorrectElmIDs.Add(Elm);

        Elm:= Elm + BoxesPerRow;
        LastElm:= Elm;
      end;

      //Remove rows with incorrect account numbers
      for i:= pred(IncorrectElmIDs.Count) downto 0 do
        if (IncorrectElmIDs[i] < LastElm) then RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      //Add new AccountNumbers
      for i:= 0 to pred(AccountNumbers.Count) do
      begin
        Strings[LastElm]:= AccountNumbers.Items[i];
        LastElm:= LastElm + BoxesPerRow;
      end;

      IncorrectElmIDs.Clear;

      //Collect foreign affiliates for 3.D section related corporations
      ArrayNo:= 6;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 3;
      ElmDormancy:= ArrayNo * 10000 + 8;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);

        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then ForeignAffiliates.Add(Value);

        Elm:= Elm + BoxesPerRow;
        ElmDormancy:= ElmDormancy + BoxesPerRow;
      end;

      //Foreign affiliate
      ArrayNo:= 7;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 1;
      ElmDormancy:= ArrayNo * 10000 + 9;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);
        Value:= FetchElmFNo(RetNo, FNo, Elm + 3); //We need to use other FA in dormant section

        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then ForeignAffiliates.Add(Value);

        Elm:= Elm + BoxesPerRow;
        ElmDormancy:= ElmDormancy + BoxesPerRow;
      end;

      //Pre populate 3.D dormant foreign affiliates
      ArrayNo:= 10;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000 + 1;
      LastElm:= Elm;

      //Remove existing account numbers and collect ids with incorrect account numbers
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      for i:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (ForeignAffiliates.IndexOf(Value) >= 0) then ForeignAffiliates.Remove(Value) else IncorrectElmIDs.Add(Elm);
        end else
          IncorrectElmIDs.Add(Elm);

        Elm:= Elm + BoxesPerRow;
        LastElm:= Elm;
      end;

      //Remove rows with incorrect foreign affiliate names
      for i:= pred(IncorrectElmIDs.Count) downto 0 do
        if (IncorrectElmIDs[i] < LastElm) then RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      //Add new foreign affiliate names
      for i:= 0 to pred(ForeignAffiliates.Count) do
      begin
        Strings[LastElm]:= ForeignAffiliates.Items[i];
        LastElm:= LastElm + BoxesPerRow;
      end;

      //Refresh dynamic rows
      if Assigned(MyScrollBox) then MyScrollBox.RebuildDynamicRows;
    finally
      FreeAndNil(AccountNumbers);
      FreeAndNil(ForeignAffiliates);
      FreeAndNil(IncorrectElmIDs);
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure T1134S(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j, ArrayNo, BoxesPerRow, Elm, RowCount: Integer;
  ArrGroupList: TArray<T1134GroupItem>;
  Value, v: string;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    //20230718 //JZ  shouldnt be done here but did it so to not distrirb the efile for now>>>
    Strings[167]:= ExtractFormInst(FName) + ' of ' + inttostr(CountMultipleInstances(RetNo,ExtractNonInstFormName(FName))); // NonInstFormName

    v:= '';
    if trim(Strings[3]).Equals('1') then v:= 'New'
    else if trim(Strings[3]).Equals('2') then v:= 'Unmodified'
    else if trim(Strings[3]).Equals('3') then v:= 'Amended'
    else if trim(Strings[3]).Equals('4') then v:= 'Delete (Close)';
    Strings[168]:= v;

    v:= '';
    if trim(Strings[175]).Equals('1') then v:= 'Duplicate'
    else if trim(Strings[175]).Equals('2') then v:= 'Filed in Error'
    else if trim(Strings[175]).Equals('3') then v:= 'Other';
    Strings[169]:= v;

    Strings[4]:= GetT1134ForeignAffiliatesIdentificationNumber(RetNo, Strings[35]);

    ArrGroupList:= GetT1134GroupList(RetNo);

    ArrayNo:= 1;
    BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm:= ArrayNo * 10000 + 1;
    RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

    for i:= 0 to RowCount - 1 do
    begin
      Value:= FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1]:= '';
      Strings[Elm + 2]:= '';
      Strings[Elm + 3]:= '';
      Strings[Elm + 4]:= '';

      if not Value.IsEmpty then
        for j:= 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2]:= ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1]:= ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3]:= ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4]:= ArrGroupList[j].AccountNumber
            end;
            break;
          end;
      Elm:= Elm + BoxesPerRow;
    end;

    ArrayNo:= 4;
    BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm:= ArrayNo * 10000 + 1;
    RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

    for i:= 0 to RowCount - 1 do
    begin
      Value:= FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1]:= '';
      Strings[Elm + 2]:= '';
      Strings[Elm + 3]:= '';
      Strings[Elm + 4]:= '';

      if not Value.IsEmpty then
        for j:= 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2]:= ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1]:= ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3]:= ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4]:= ArrGroupList[j].AccountNumber
            end;

            break;
          end;
      Elm:= Elm + BoxesPerRow;
    end;

    ArrayNo:= 12;
    BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm:= ArrayNo * 10000 + 1;
    RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

    for i:= 0 to RowCount - 1 do
    begin
      Value:= FetchElmFNo(RetNo, FNo, Elm);

      for j:= 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1]:= ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm:= Elm + BoxesPerRow;
    end;

    ArrayNo:= 13;
    BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm:= ArrayNo * 10000 + 1;
    RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

    for i:= 0 to RowCount - 1 do
    begin
      Value:= FetchElmFNo(RetNo, FNo, Elm);

      for j:= 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1]:= ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm:= Elm + BoxesPerRow;
    end;

    ArrayNo:= 15;
    BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm:= ArrayNo * 10000 + 1;
    RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

    for i:= 0 to RowCount - 1 do
    begin
      Value:= FetchElmFNo(RetNo, FNo, Elm);

      for j:= 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1]:= ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm:= Elm + BoxesPerRow;
    end;

    Tv[78]:= Tv[74] + Tv[75];
    Tv[82]:= Tv[80] + Tv[81];
    Tv[86]:= Tv[84] + Tv[85];
    Tv[90]:= Tv[88] + Tv[89];
    Tv[94]:= Tv[92] + Tv[93];
    Tv[98]:= Tv[96] + Tv[97];
    Tv[102]:= Tv[100] + Tv[101];
    Tv[106]:= Tv[104] + Tv[105];
    Tv[110]:= Tv[108] + Tv[109];

    Tv[145]:= 0;
    for i in [58, 128, 130, 132, 134, 136, 138, 140, 142, 144] do Tv[145]:= Tv[145] + Tv[i];
    Tv[146]:= 0;
    for i in [59, 129, 131, 133, 135, 137, 139, 141, 143] do Tv[146]:= Tv[146] + Tv[i];
  end;
  SaveTv(RetNo, FName, FNo);
end;
//20260115 Igor <<<



Procedure T1098(RetNo:integer;FName:string;FNo:integer); //jz//20260309
var
  i,j:integer;

  c1ColF,c1ColG,c1ColH,c1ColI,c1ColJ,c1ColL:integer;
  c2ColE,c2ColF,c2ColG,c2ColH,c2ColI:integer;

  c1ColElmStart,chartdif,chart1Incr,chart2Incr,elmIncr:integer;
  c1,c2:integer;

  trnsfrP1Ln:boolean;
  ss:string;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin

    c1ColF:=11;c1ColG:=12;c1ColH:=13;c1ColI:=14;c1ColJ:=15;c1ColL:=17;
    c1ColElmStart   := 6;
    chartdif        := 111;
    chart1Incr      := 12;
    chart2Incr      := 9;

    //T1098 Part1 - Calc
    tv[114] := 0;
    for i := 0 to 8 do
    begin
      tv[c1ColI+(i*chart1Incr)] := tv[c1ColF+(i*chart1Incr)] - tv[c1ColG+(i*chart1Incr)] + tv[c1ColH+(i*chart1Incr)];
      tv[c1ColL+(i*chart1Incr)] := tv[c1ColI+(i*chart1Incr)] * tv[c1ColJ+(i*chart1Incr)]/100;
      //tv[114] := tv[114] + tv[colL+(i*chart1Incr)];
    end;

    tv[114]   := AddColumns(c1ColL,113,chart1Incr);
    //tv[115]   := ; //from 5013 box 265?? where is that?? vtUser for now
    tv[116]   := tv[114] + tv[115];

     ss:=strings[200];

    //T1098 Part2 - populate part 2 elms from Part 1
    for i := 0 to 6 do
    begin
      trnsfrP1Ln := strings[198+i] = 'Y';
      for j := 0 to 3 do
      begin
        c1 := c1ColElmStart+(i*chart1Incr)+j;
        c2 := c1ColElmStart+chartdif+(i*chart2Incr)+j;
        if trnsfrP1Ln then begin strings[c2] := strings[c1]; end
                    else begin strings[c2] := ''; end;
      end;
      //inc(colElmStart,1);
      //Clean Energy ITC amount
      c1 := c1ColElmStart+(i*chart1Incr)+11;
      c2 := c1ColElmStart+chartdif+(i*chart2Incr)+4;
      if trnsfrP1Ln then begin tv[c2] := tv[c1]; end
                  else begin tv[c2] := 0; end;
    end;

    //T1098 Part2 - Calc
    c2ColE:=121;c2ColF:=122;c2ColG:=123;c2ColH:=124;c2ColI:=125;
    tv[180] := 0;
    for i := 0 to 8 do
    begin
      tv[c2ColH+(i*chart2Incr)] := 0;
      if tv[c2ColG+(i*chart2Incr)] > 0 then
        tv[c2ColH+(i*chart2Incr)] := (tv[c2ColE+(i*chart2Incr)] * tv[c2ColF+(i*chart2Incr)]) / tv[c2ColG+(i*chart2Incr)];

      tv[c2ColI+(i*chart2Incr)] := minr(tv[c2ColE+(i*chart2Incr)],tv[c2ColH+(i*chart2Incr)]);
    end;
    tv[180] := AddColumns(c2ColI,179,chart2Incr);
    //tv[181] := ; //from 5013 box 267?? where is that?? vtUser for now
    tv[182] := tv[180] + tv[181];

    tv[192] := tv[191] * 20;
    tv[195] := maxr(0,tv[193] - tv[194] * 50);
    //[196] := //from 5013 box 266, where is that?? vtUser for now
    tv[197] := tv[192] + tv[195] + tv[196];

    //Page 5
    Tv[259]:= AddColumns(216, 256, 5); //20261006 Alex
    Tv[260]:= AddColumns(217, 257, 5); //20261006 Alex
    Tv[261]:= AddColumns(218, 258, 5); //20261006 Alex
  end; //end with

  SaveTv(RetNo, FName, FNo);
end;
//20261006 Alex >>>
procedure T1099(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 3, 2, 4);
    if (Strings[8] + Strings[9] = '') then Strings[9]:= 'X';

    Tv[64]:= AddColumns(12, 60, 6);
    Tv[65]:= AddColumns(13, 61, 6);
    Tv[66]:= AddColumns(14, 62, 6);
    Tv[67]:= AddColumns(15, 63, 6);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20261006 Alex <<<

end.


