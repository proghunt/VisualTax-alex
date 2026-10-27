unit TF_2026calc2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Dialogs, DBctrls, ExtCtrls,
  System.Generics.Collections, vtScrollBox, vtChild, //20260817 Alex
  TF_2026Declare, TF_2026common, TF_2026common2, TF_2026TrimStr, TF_2026CalcSers,
  vtDynData, Math;

  procedure T1134(RetNo: Integer; FName: string; FNo: Integer); //20260817 Alex
  procedure T1134S(RetNo: Integer; FName: string; FNo: Integer); //20260817 Alex

  Procedure T1441(RetNo: integer; FName: String;FNo: integer); //20230621
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


  //20150228
  Procedure T3P(RetNo:integer;FName:string;FNo:integer);
  //Procedure T3P_1(RetNo:integer;FName:string;FNo:integer);
  //Procedure T3P_2(RetNo:integer;FName:string;FNo:integer);


  {Elections}
  Procedure T2205(RetNo:integer;FName:string;FNo:integer);
  Procedure T123(RetNo:integer;FName:string;FNo:integer);
  Procedure T2019(RetNo: integer;FName:string;FNo:integer);

  Procedure T2022(RetNo:integer;FName:string;FNo:integer);
  Procedure T2047(RetNo:integer;FName:string;FNo:integer);

  {
  Procedure T2054(RetNo:integer;FName:string;FNo:integer);
  Procedure T2057(RetNo:integer;FName:string;FNo:integer);
  Procedure T2058(RetNo:integer;FName:string;FNo:integer);
  Procedure T2059(RetNo:integer;FName:string;FNo:integer); //20240615
  }
  Procedure T1OVP(RetNo:integer;FName:string;FNo:integer);
  Procedure BNK(RetNo: integer; FName: String;FNo: integer); {slip}

implementation

uses
  TF_2026, TF_2026Calc, vtShared, vtCommon, vtTrimStr, vtMulti; // TF_2026CalcSers; //20260817 Alex

Procedure T3010(RetNo: integer; FName: String;FNo: integer);
Var  i: integer; LargeCharity:Boolean;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  For i:=1 to 379 do Tv[i]:=Round(Tv[i]);   //20201207  //20240108 from 338
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
 //  Tv[287]:=0;    //20130125  //20240107
   For i:=103 to 107 do begin Strings[i]:='';Tv[i]:=0;end;
   For i:=109 to 109 do begin Strings[i]:='';Tv[i]:=0;end; //20140918
  end
  else
  begin
   Tv[88]:=Tv[79]+Tv[80]+Tv[63]+Tv[83]+Tv[84]+Tv[85]+Tv[86]+Tv[87];
   Tv[104]:=Tv[89]+Tv[90]+Tv[103];
   Tv[107]:=TotMultiple(RetNo,'T1236',76);  //-TotMutiple(RetNo,'T1236',74); //20110213
   Tv[109]:=Tv[104]+Tv[140]+Tv[107];//Tv[104]+Tv[107];  //20230528
  end;

  //pg 4
  If Strings[112]='' then Strings[112]:=FormatDateTime('yyyy-mm-dd',Date);
  If CertificationMode then Strings[112]:='';
  //Strings[121]:=
  //pg 5
  If CertificationMode then for i:=121 to 126 do Strings[i]:='';
  //pg 8/9  Sch 6
  Tv[286]:=Tv[140]; //20230528
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
   Tv[327]:=Tv[318]+Tv[286]+Tv[324]; //20230528
  end
  Else
  begin
    //20240108 Igor >>>
    for i:=262 to 338 do
    begin
      if (i = 322) or (i = 326) or ((i >= 330) and (i <= 335)) then continue;
      Strings[i]:='';Tv[i]:=0;
    End;
    //20230108 Igor <<<
  end;

  //S8:  20230102
  if Strings[341]>'' then //20240311
  Begin
   Tv[362]:=Tv[337];
  // Tv[363]:= Tv[328]+   // ??
   Tv[364]:=MaxR(0,Tv[362]-Tv[363]);

   if Tv[364]<=1000000 then
   Begin
    Tv[365]:=Tv[364]*3.5/100;
    Tv[366]:=0;
    Tv[367]:=0;
    Tv[368]:=0;
   End
   Else
   Begin
    Tv[365]:=0;
    Tv[366]:=Tv[364]-1000000;
    Tv[367]:=Tv[366]*5/100;
    Tv[368]:=Tv[367]+35000;
   End;

   Tv[369]:=MaxR(TV[365],Tv[368]);
   Tv[370]:=Tv[319];
   Tv[371]:=Tv[286];
   Tv[372]:=TV[324];
   Tv[373]:=Tv[370]+Tv[371]+TV[372];
   Tv[374]:=Tv[373]-Tv[369];

   Tv[375]:=Tv[338];
   if Tv[375]<=1000000 then
   Begin
    Tv[376]:=Tv[375]*3.5/100;
    Tv[377]:=0;
    Tv[378]:=0;
    Tv[379]:=0;
   End
   Else
   Begin
    Tv[376]:=0;
    Tv[377]:=Tv[375]-1000000;
    Tv[378]:=Tv[377]*5/100;
    Tv[379]:=Tv[378]+35000;
   End;
  End
  Else
  Begin
   for i:=362 to 379 do Tv[i]:=0;
  End;

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


(*
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
  Tv[103] := Tv[101] * 0.01;
  Strings[20]:=FormatFloat('0.00000',Vl(Strings[104])/12);
  Tv[21]:=Tv[103]*Vl(Strings[20]);
  Strings[22]:=Strings[104];
  Tv[42]:=500 * Vl(Strings[22])/12;
  Tv[11]:=MinR(Tv[21],Tv[42]);

  {
  Tv[104] := Tv[102];
  Tv[105] := (500 * Tv[104])/12;
  Tv[106] := MinR(Tv[103],Tv[105]);
  }
  Tv[107] := Tv[14]; //Vl(FetchElm(RetNo,'T2054_1',14));
  Tv[108] := Tv[107];
  Tv[109] := Tv[108] * 0.60;

  Tv[110] := Tv[11];
  Tv[111] := Tv[109];
  Tv[112] := Tv[110]+Tv[111];
  If Strings[114]='' then Strings[114]:= FormatDateTime('yyyy-mm-dd',Now);
 end;

 SaveTv(RetNo,FName,FNo);
end;
*)

Procedure T3GR(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  If Strings[12]='' then strings[12] :=AppYear;
  If Strings[28]+Strings[41]='' then strings[28] :='X'; //20150223
  Strings[17] := IntToStr(
                  MyStrToInt(Strings[14])+
                  MyStrToInt(Strings[15])+
                  MyStrToInt(Strings[16])
                  );
  Strings[19] := IntToStr(
                  MyStrToInt(Strings[17])-
                  MyStrToInt(Strings[18]));

  Tv[29]:=Tv[21]+Tv[22]; //+Tv[42]+Tv[43];
  Tv[31]:=Tv[29]-Tv[30];
 If Strings[25] = '' then Strings[25] := FormatDateTime('yyyy-mm-dd',Now);
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
 end;
 SaveTv(RetNo,FName,FNo);
end;




Procedure T3P(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   Tv[18] := Vl(FetchElm(RetNo,'T3P',117));
   Tv[27] := Tv[18] - Tv[22];


   //pg2
   Tv[105]:=Tv[101]+Tv[102]+Tv[103]+Tv[104]+Tv[119]+Tv[121]+Tv[123];
   Tv[114]:=0;
   For i:=107 to 112 do Tv[114]:=Tv[114]+Tv[i];
   Tv[114]:=Tv[114]+Tv[124]+Tv[126]+Tv[128];
   Tv[115]:=Tv[105];
   Tv[116]:=Tv[114]-Tv[115];
 end;
 SaveTv(RetNo,FName,FNo);
end;

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



(*
Procedure T2057(RetNo: integer; FName: String;FNo: integer);
Var  i,ArrayNumber, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: Integer;
  // 20240604 Igor >>>
  x4,x5: extended;
  xs: string;
  // 20240604 Igor <<<
    //AccountNumbers, ForeignAffiliates: TList<string>;
    //IncorrectElmIDs: TList<Integer>;
    //Value:Real;
   // MyScrollBox: TvtScrollBox;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  //20240519
  Strings[10001]:='1';
  Strings[20001]:='1';
  Strings[30001]:='1';
  Strings[40001]:='1';
  Strings[50001]:='1';
  Strings[60001]:='1';
  Strings[70001]:='1';
  Strings[80001]:='1';
  Strings[90001]:='1';
  Strings[100001]:='1';
  Strings[110001]:='1';
  Strings[120001]:='1';

  //xx:=MaxR(0,Tv[23] - Tv[24]);
  Tv[25] := MaxR(0,Tv[23] - Tv[24]);
  Tv[26] := Tv[25];
  Tv[27] := (Tv[26]/4) * 0.01 * Vl(Strings[32]);  //Tv[28]; //20100412
  If Tv[27] > 8000 then Tv[27] :=8000;
  Strings[33]:=Strings[32];
  Tv[29] := 100 * Vl(Strings[33]);
  Tv[30] := MinR(Tv[27],Tv[29]);

  //summarize the very bottm total from all ptrior arrays
  Tv[43]:=0;//Tv[31]:=0;
  ArrayNumber:=4; //start from 40000
  BoxesPerRow:=11;
  //T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
  Elm:=ArrayNumber*10000+BoxesperRow; //for field id 10003 on the first row i form
  //Elm:=ArrayNo*10000+StrToInt(BoxesperRow); //for field id 10003 on the first row i form
  xx:=Vl(FetchElmFNo(RetNo,FNo,Elm));  //NOT Tv[elm]; //
  For i:=0 to MaxDynamicElmsPerForm do
  begin
     Tv[43]:=Tv[43]+Vl(FetchElmFNo(RetNo,FNo,Elm));// Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
  end;

  // 20240531 Igor >>>
  //Summurize 53 - 57
  Tv[53] := 0;
  Tv[54] := 0;
  Tv[55] := 0;
  Tv[56] := 0;
  Tv[57] := 0;
  Tv[58] := 0;
  BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[4];
  for ArrayNumber := 4 to 12 do
  begin
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
    For i := 0 to RowCount - 1 do
    begin
      Elm := (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
      Tv[53] := Tv[53] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
      x4 := Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
      x5 := Vl(FetchElmFNo(RetNo, FNo, Elm));
      Tv[54] := Tv[54] + x5;
      if RoundTo(x5 - x4, -2) <> 0 then
        xs := FormatFloat('########.##', x5 - x4)
      else
        xs := '';
      Elm := (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
      StoreElmFNo(RetNo, FNo, Elm, xs);
      Tv[55] := Tv[55] + x5 - x4;
      Elm := (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
      Tv[56] := Tv[56] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
      Tv[58] := Tv[58] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 11) + i * BoxesPerRow;
      Tv[57] := Tv[57] + Vl(FetchElmFNo(RetNo, FNo, Elm));
    end;
  end;
  // 20240531 Igor <<<


  //repeat...
  //...

 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

(*

Procedure T2058(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
  // 20240613 Igor >>>
  ArrayNumber, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: Integer;
  x4,x5: extended;
  xs: string;
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

  // 20240613 Igor >>>
  //Summurize
 with Ret[RetNo].Frm[FNo] do
 begin
  for ArrayNumber := 1 to 10 do
  begin
    BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
    For i := 0 to RowCount - 1 do
    begin
      Elm := (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
      StoreElmFNo(RetNo, FNo, Elm, IntToStr(i + 1));
    end;
  end;

  Tv[53] := 0;
  Tv[54] := 0;
  Tv[55] := 0;
  Tv[56] := 0;
  Tv[57] := 0;
  Tv[58] := 0;
  BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[4];
  for ArrayNumber := 4 to 10 do
  begin
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
    For i := 0 to RowCount - 1 do
    begin
      Elm := (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
      Tv[53] := Tv[53] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
      x4 := Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
      x5 := Vl(FetchElmFNo(RetNo, FNo, Elm));
      Tv[54] := Tv[54] + x5;
      if RoundTo(x5 - x4, -2) <> 0 then
        xs := FormatFloat('########.##', x5 - x4)
      else
        xs := '';
      Elm := (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
      StoreElmFNo(RetNo, FNo, Elm, xs);
      Tv[55] := Tv[55] + x5 - x4;
      Elm := (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
      Tv[56] := Tv[56] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
      Tv[58] := Tv[58] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 11) + i * BoxesPerRow;
      Tv[57] := Tv[57] + Vl(FetchElmFNo(RetNo, FNo, Elm));
    end;
  end;
 end;
 SaveTv(RetNo,FName,FNo);
  // 202406013 Igor <<<
end;

*)

(*
// 20240614 Igor >>>
Procedure T2059(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
  ArrayNumber, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: Integer;
  x4,x5: extended;
  xs: string;
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

 // T2059 pg 2 -----------------------------------------------------------------

 // T2059 pg 3 -----------------------------------------------------------------
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

 with Ret[RetNo].Frm[FNo] do
 Begin
  for ArrayNumber := 1 to 9 do
  begin
    BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
    For i := 0 to RowCount - 1 do
    begin
      Elm := (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
      StoreElmFNo(RetNo, FNo, Elm, IntToStr(i + 1));
    end;
  end;

  Tv[53] := 0;
  Tv[54] := 0;
  Tv[55] := 0;
  Tv[56] := 0;
  Tv[57] := 0;
  Tv[58] := 0;
  BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[4];
  for ArrayNumber := 4 to 9 do
  begin
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
    For i := 0 to RowCount - 1 do
    begin
      Elm := (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
      Tv[53] := Tv[53] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
      x4 := Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
      x5 := Vl(FetchElmFNo(RetNo, FNo, Elm));
      Tv[54] := Tv[54] + x5;
      if RoundTo(x5 - x4, -2) <> 0 then
        xs := FormatFloat('########.##', x5 - x4)
      else
        xs := '';
      Elm := (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
      StoreElmFNo(RetNo, FNo, Elm, xs);
      Tv[55] := Tv[55] + x5 - x4;
      Elm := (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
      Tv[56] := Tv[56] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
      Tv[58] := Tv[58] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      Elm := (ArrayNumber * 10000 + 11) + i * BoxesPerRow;
      Tv[57] := Tv[57] + Vl(FetchElmFNo(RetNo, FNo, Elm));
    end;
  end;
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)
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

Procedure T1441(RetNo: integer; FName: String;FNo: integer); //20230621
Var  i,j: integer; s:string;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Strings[1]:=FetchElm(RetNo,'T3010',37);  //20191230 CharityName
  Strings[2]:=GetCharityBN(RetNo);
  Strings[3]:=GetCharityYE(RetNo);


  //jz//20230706 if something entered on first instance replicate on all instances
  //but should find an automated way to enter this information
  s := FetchElm(RetNo,'T1441#1',24);
  if s > '' then Strings[24]:= s; //replicate in other instances //20230711 CON

 end;
 SaveTv(RetNo,FName,FNo);
end;

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

//20260817 Alex
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

    Strings[12]:= 'X';
    if Strings[13].IsEmpty() then Strings[13]:= Trim(FetchElm(RetNo, 'T5013FIN', 7) + ' ' + FetchElm(RetNo, 'T5013FIN', 8));
    if Strings[14].IsEmpty() then Strings[14]:= FetchElm(RetNo, 'T5013FIN', 1);

    if not FetchElm(RetNo, 'T5013FIN', 11).IsEmpty() then  //individual
    begin
      if strings[15].IsEmpty() then Strings[15]:= Trim(FetchElm(RetNo, 'T5013FIN', 13) + ' ' + FetchElm(RetNo, 'T5013FIN', 14)); // street
      if Strings[16].IsEmpty() then Strings[16]:= FetchElm(RetNo, 'T5013FIN', 15); //city
      if Strings[17].IsEmpty() then Strings[17]:= FetchElm(RetNo, 'T5013FIN', 16); //prov
      if Strings[18].IsEmpty() then Strings[18]:= FetchElm(RetNo, 'T5013FIN', 18); //postal
      if Strings[141].IsEmpty() then Strings[141]:= FetchElm(RetNo, 'T5013FIN', 17); //country
    end;

    if Strings[19].IsEmpty() then Strings[19]:= FetchElm(RetNo, 'T5013FIN', 38); //Fisc start
    if Strings[20].IsEmpty() then Strings[20]:= FetchElm(RetNo, 'T5013FIN', 39); //Fisc end;

    if Strings[141].IsEmpty() then Strings[141]:= 'CAN';
    //Otherwise user must select from FCounty.d (No need to maintain anothe table of countries for 2 to 3 char conversion it is an incostistency by CRA

    Strings[142]:= IntToStr(CountMultipleInstances(RetNo, 'T1134S'));

    if Strings[143].IsEmpty() then Strings[143]:= FetchElm(RetNo, 'T5013FIN', 143); //cert First name
    if Strings[144].IsEmpty() then Strings[144]:= FetchElm(RetNo, 'T5013FIN', 142); //cert Last name
    if Strings[23].IsEmpty() then Strings[23]:= Trim(FetchElm(RetNo, 'T5013FIN', 143) + ' ' + FetchElm(RetNo, 'T5013FIN', 142)); //cert print full name
    if Strings[145].IsEmpty() then Strings[145]:= FetchElm(RetNo, 'T5013FIN', 146); //cert ext
    if Strings[146].IsEmpty() then Strings[146]:= FetchElm(RetNo, 'T5013FIN', 147); //cert phone
    if Strings[147].IsEmpty() then Strings[147]:= FetchElm(RetNo, 'T5013FIN', 145); //cert date
    if Strings[148].IsEmpty() then Strings[148]:= FetchElm(RetNo, 'T5013FIN', 144); //cert position

    AccountNumbers:= TList<String>.Create;
    ForeignAffiliates:= TList<String>.Create;
    IncorrectElmIDs:= TList<Integer>.Create;
    try
      if Assigned(RetList[RetNo].MyChild) and (RetList[RetNo].MyChild.ActiveForm <> nil) and SameText(RetList[RetNo].MyChild.ActiveForm.FormName, 'T1134') then
        MyScrollBox:= RetList[RetNo].MyChild.ActiveForm;

      //Reporting trust number
      AccountNumbers.Add(Strings[14]); //20260817 Alex

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

procedure T1134S(RetNo: Integer; FName: String; FNo: Integer);
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
//20260817 Alex <<<

end.


