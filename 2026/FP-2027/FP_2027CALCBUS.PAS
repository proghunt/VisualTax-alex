unit FP_2027calcBus;

interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 UDeclare,common, common2,TrimStr;

    Procedure BUSSUM(RetNo: integer; FName: String;FNo: integer);
    Procedure CalcAutoExp(RetNo:integer;FName:string;FNo:integer;Stm:string);
    Procedure CalcBusProf_3(RetNo:integer;FName:string;FNo:integer;Stm:string);
    Procedure CalcBusProf_4(RetNo:integer;FName:string;FNo:integer;Stm:string);
    procedure ResInc(RetNo: integer; FName: String;FNo: integer);
    procedure ResExp(RetNo: integer; FName: String;FNo: integer);
    Procedure FORINC(RetNo:integer;FName:string;FNo:integer);
    Procedure INV_1(RetNo:integer;FName:string;FNo:integer);
    Procedure INV_2(RetNo:integer;FName:string;FNo:integer);
    Procedure T1139SM(RetNo:integer;FName:string;FNo:integer);
    Procedure T1139_1(RetNo:integer;FName:string;FNo:integer);
    Procedure T1139_2(RetNo:integer;FName:string;FNo:integer);
    Procedure T2124_1(RetNo:integer;FName:string;FNo:integer);
    Procedure T2124_2(RetNo:integer;FName:string;FNo:integer);
    Procedure T2124_3(RetNo:integer;FName:string;FNo:integer);
    Procedure T2124_4(RetNo:integer;FName:string;FNo:integer);
    Procedure T2124_5(RetNo:integer;FName:string;FNo:integer);

    Procedure T2032_1(RetNo:integer;FName:string;FNo:integer);
    Procedure T2032_2(RetNo:integer;FName:string;FNo:integer);
    Procedure T2032_3(RetNo:integer;FName:string;FNo:integer);
    Procedure T2032_4(RetNo:integer;FName:string;FNo:integer);
    Procedure T2032_5(RetNo:integer;FName:string;FNo:integer);

    Procedure T2042_1(RetNo:integer;FName:string;FNo:integer);
    Procedure T2042_2(RetNo:integer;FName:string;FNo:integer);
    Procedure T2042_3(RetNo:integer;FName:string;FNo:integer);
    Procedure T2042_4(RetNo:integer;FName:string;FNo:integer);
    Procedure T2042_5(RetNo:integer;FName:string;FNo:integer);
    Procedure T2042_6(RetNo:integer;FName:string;FNo:integer);

    Procedure T2121_1(RetNo:integer;FName:string;FNo:integer);
    Procedure T2121_2(RetNo:integer;FName:string;FNo:integer);
    Procedure T2121_3(RetNo:integer;FName:string;FNo:integer);
    Procedure T2121_4(RetNo:integer;FName:string;FNo:integer);
    Procedure T2121_5(RetNo:integer;FName:string;FNo:integer);
implementation
Uses UCalc;


{T2032_1}
Procedure T2032_1(RetNo:integer;FName:string;FNo:integer);
var i: integer;
  FInst : String[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[FNo] do
  begin
     Strings[1] := FetchElm(RetNo,FirstFormName,2);
     Strings[2] := FetchElm(RetNo,FirstFormName,5);
     Strings[3] := FetchElm(RetNo,FirstFormName,3);
     If Strings[4] ='' then Strings[4] := '01-01-'+AppYear;
     If Strings[7] ='' then Strings[7] := '31-12-'+AppYear;
     If Strings[10]+Strings[11] ='' then
       begin Strings[10] := '';Strings[11] := 'X'; end;
     If TV[21] = 0 then TV[21] := 100;

    Tv[29] := Tv[27] + Tv[28];
    Tv[30] := Tv[29];
    Tv[31] := Tv[26] - Tv[30];
    Tv[36] := Tv[31] + Tv[32] + Tv[33] + Tv[35];
    Tv[46] := Tv[5] * 0.50;
    Tv[57] := Tv[70]+Tv[56];
    for i:= 37 to 54 do
        Tv[57] := Tv[57] + Tv[i];
    Tv[58] := Vl(FetchElm(RetNo,'T2032_3'+FInst,82));
    Tv[59] := Vl(FetchElm(RetNo,'T2032_4'+FInst,52)); {normal allowance}
    If Tv[59] =0 then Tv[59] :=
          -Vl(FetchElm(RetNo,'T2032_4'+FInst,55));  {inc inclusion}

    Tv[60] := Tv[57] + Tv[58] + Tv[59];
    Tv[61] := Tv[60];
    Tv[62] := Tv[36] - Tv[61];
    Tv[63] := Tv[62] * Tv[21]/100;
    Tv[64] := Vl(FetchElm(RetNo,'T2032_2'+FInst,9));
    Tv[65] := Tv[63] - Tv[64];
    Tv[66] := Vl(FetchElm(RetNo,'T2032_2'+FInst,31));
    Tv[67] := Tv[65] - Tv[66];
    Tv[68] := Vl(FetchElm(RetNo,'T2032_2'+Finst,34));
    Tv[69] := Tv[67] - Tv[68];
    Ret[RetNo]^.Ln[137] := Tv[69];
 end;
    {save data}
    SaveTv(RetNo,FName,FNo);
End;

{T2032_2}
Procedure T2032_2(RetNo:integer;FName:string;FNo:integer);
var i: integer; x :Real;
     FInst : String[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo]^ do
   begin
    If Tv[52] >0 then
     Frm[FNo].Strings[10] :=GetSpouseFirstName(RetNo)+' '+
                   GetSpouseLastName(RetNo)+'  '+
                   GetSpouseAddress(RetNo)
    else
     Frm[FNo].Strings[10] :='';
    Tv[9] := 0;
    i := 2;
    repeat
        Tv[9] := Tv[9] + Tv[i];
        i := i + 2;
    until i > 8;
    Tv[24] := 0;
    for i:= 12 to 17 do
        Tv[24] := Tv[24] + Tv[i];
    Tv[24] := Tv[24] + Tv[19] + Tv[21] + Tv[23];

    Tv[25] := tv[24] * Tv[53] /100;
    Tv[26] := Tv[24] - Tv[25];
    If Tv[11] =0 then Tv[11] := 100;
    Tv[50] := Tv[26] * Tv[11] /100;
    Tv[27] := Vl(FetchElm(RetNo,'CFR_1',34));
    Tv[28] :=Tv[50]+Tv[27];
    Tv[29] := MaxR(0,Vl(FetchElm(RetNo,'T2032_1'+FInst,29)));
    Tv[30] := MinR(0,(Tv[28] - Tv[29]));
    Tv[31] := MinR(Tv[28],Tv[29]);

    Tv[34] := Tv[32] - Tv[33];
    {partners}
    x := Vl(FetchElm(RetNo,'T2032_1'+FInst,21)) +  {my share}
      Tv[52]+Tv[37]+Tv[40]+Tv[43]+Tv[46];   {others}
    If x > 100 then   {check %}
      begin
      MessageBeep(0);
      Tv[52] := Tv[52] - (x - 100); {adjust first one}
    end;

    Tv[51] := (Tv[51]  *  Tv[52]) / 100;
    i := 36;    {calc inc for partners}
    repeat
        Tv[i] := (Tv[i]  *  Tv[i+1]) / 100;
        i := i + 3;
    until i > 45;
  end;
    {save data}
    SaveTv(RetNo,FName,FNo);
End;

Procedure T2032_3(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcBusProf_3(RetNo,FName,FNo,'P');
end;

Procedure T2032_4(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcBusProf_4(RetNo,FName,FNo,'P');
end;

Procedure T2032_5(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcAutoExp(RetNo,FName,FNo,'P');
End;

{T1A_1}
Procedure T1A_1(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
    {Load the numeric fields of a form into the Temporary Variables array}
    LoadTv(RetNo,FName,FNo);

    {Calc this form}
    Tv[6] := Ret[RetNo]^.Ln[101] + Ret[RetNo]^.Ln[104]
            - Ret[RetNo]^.Ln[207] - Ret[RetNo]^.Ln[212]
            - Ret[RetNo]^.Ln[229];
    Tv[8] := Ret[RetNo]^.Ln[120] + Ret[RetNo]^.Ln[121] - Ret[RetNo]^.Ln[221];
    Tv[10] := Ret[RetNo]^.Ln[122];
    Tv[12] := Ret[RetNo]^.Ln[126];
    Tv[14] := Ret[RetNo]^.Ln[135];
    Tv[16] := Ret[RetNo]^.Ln[137];
    Tv[18] := Ret[RetNo]^.Ln[139];
    Tv[20] := Ret[RetNo]^.Ln[141];
    Tv[22] := Ret[RetNo]^.Ln[143];
    Tv[24] := Ret[RetNo]^.Ln[127];
    Tv[25] := Ret[RetNo]^.Ln[147];

    Tv[26] := Ret[RetNo]^.Ln[253];
    Tv[27] := Ret[RetNo]^.Ln[254];
    Tv[28] := Ret[RetNo]^.Ln[217];
    Tv[29] := Ret[RetNo]^.Ln[428];
    Tv[30] := Ret[RetNo]^.Ln[249];
    Tv[31] := Ret[RetNo]^.Ln[250];
    Tv[32] := Vl(FetchElm(RetNo,'OTHDED',22));
    Tv[33] := Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[113]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[114]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[115]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[119]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[128]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[129]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[130];

    Tv[34] := 0;
    Tv[35] := 0;
    i := 6;
    repeat
        If Tv[i] < 0 then
         Begin
            Tv[i+1] := Tv[i];
            Tv[35] := Tv[35] + Tv[i+1];
            Tv[i] := 0;
         end
        Else
            Tv[34] := Tv[34] + Tv[i];
        i := i + 2;
    until i = 24;

    Tv[34] := Tv[34] + Tv[24] + Tv[25] + Tv[33];

    for i := 26 to 32 do
        Tv[35] := Tv[35] + Tv[i];

    Tv[36] := Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[208]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[209]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[214]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[215]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[219]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[220]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[232]
            + Ret[RetNo]^.Ln[113] + Ret[RetNo]^.Ln[235];
    Tv[37] := MinR(0,(Tv[34] - Tv[36]));
    Tv[38] := Tv[37];
    Tv[39] := MaxR(0,(Tv[35] - Tv[38]));
    {?T1A_1 Tv[40] check with latest form}
    Tv[40] := MinR(Tv[39],Vl(FetchElm(RetNo,'T1A_2',3)));
    Tv[41] := MaxR(0,(Tv[39] - Tv[40]));
    Tv[42] := Ret[RetNo]^.Ln[237];
    Tv[43] := MaxR(0,(Tv[41] - Tv[42]));
    Tv[47] := Tv[44] + Tv[45] + Tv[46];
    Tv[48] := Tv[47];
    Tv[49] := MaxR(0,(Tv[43] - Tv[48]));

    {save data}
    SaveTv(RetNo,FName,FNo);
End;

Procedure T2042_1(RetNo:integer;FName:string;FNo:integer);
Var i :integer;
  FInst : String[4];
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo]^.Frm[Fno] do
 begin
   Strings[1] := FetchElm(RetNo,FirstFormName,2);
   Strings[2] := FetchElm(RetNo,FirstFormName,5);
   Strings[3] := FetchElm(RetNo,FirstFormName,3);
   If Strings[4] ='' then Strings[4] := '01-01-'+AppYear;
   If Strings[5] ='' then Strings[5] := '31-12-'+AppYear;
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;
   If TV[24] = 0 then TV[24] := 100;
   Tv[35] := 0;
   For i :=26 to 34 do
     Tv[35] := Tv[35] +Tv[i];
   Tv[36] := Tv[35];
   Tv[66] :=Tv[35];
   For i :=37 to 58 do
     Tv[66] := Tv[66] +Tv[i];
   Tv[65] := Tv[60] + Tv[62]+Tv[64];
   Tv[66] := Tv[66] +Tv[65];

  end; {End with}

  SaveTv(RetNo,FName,FNo);


End;

Procedure T2042_2(RetNo:integer;FName:string;FNo:integer);
Var i :integer;
  FInst : String[4]; x:real;
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo]^.Frm[Fno] do
 begin
   Tv[1] := Vl(FetchElm(RetNo,'T2042_1'+FInst,66));
   Tv[35]:= 0;
   For i :=2 to 28 do
     Tv[35] := Tv[35] +Tv[i];
   Tv[35] :=Tv[35]+Tv[30]+Tv[32] + Tv[34];
   Tv[36] := Vl(FetchElm(RetNo,'T2042_4'+FInst,148));
   Tv[37] := Vl(FetchElm(RetNo,'T2042_4'+FInst,159));
   If Tv[37] =0 then Tv[37] :=
          -Vl(FetchElm(RetNo,'T2042_4'+FInst,162));  {inc inclusion}

   Tv[38] :=Tv[35]+Tv[36]+Tv[37];
   Tv[39] := Tv[38];
   Tv[40] := Tv[1] -Tv[39];
   Tv[43] :=Tv[40]+Tv[41]+Tv[42];
   Tv[44] := Tv[43] * Vl(FetchElm(Retno,'T2042_1'+FInst,24))/100;
   Tv[45] := Vl(FetchElm(Retno,'T2042_5'+FInst,13));
   Tv[46] := Tv[44] - Tv[45];
   Tv[47] := Vl(FetchElm(Retno,'T2042_5'+FInst,36));
   Tv[48] := Tv[46] - Tv[47];
 end;
   SaveTv(RetNo,FName,FNo);
End;

Procedure T2042_3(RetNo:integer;FName:string;FNo:integer);
Var I: integer; FInst :String[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo]^.Frm[Fno] do
  begin
    {equip additions}
    I := 3; Tv[22] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[22] := Tv[22] + Tv[I+2];
      i := i + 5;
    Until i > 18;
    Tv[22] := Tv[22] + Tv[21];

  {Motor vih}
    I := 25; Tv[44] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[44] := Tv[44] + Tv[I+2];
      i := i + 5;
    Until i > 40;
    Tv[44] := Tv[44] + Tv[43];

    Tv[45] := Tv[22]+Tv[44];

    {build additions}
    I := 48; Tv[67] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[67] := Tv[67] + Tv[I+2];
      i := i + 5;
    Until i > 63;
    Tv[67] := Tv[67] + Tv[66];

    {equip disp }
    I := 70; Tv[89] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[89] := Tv[89] + Tv[I+2];
      i := i + 5;
    Until i > 85;
    Tv[89] := Tv[89] + Tv[88];

    {Motor veh disp}
    I := 92; Tv[111] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[111] := Tv[111] + Tv[I+2];
      i := i + 5;
    Until i > 107;
    Tv[111] := Tv[111] + Tv[110];
    Tv[112] := Tv[89] + Tv[111];
    {build disp }
    I := 115; Tv[134] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[134] := Tv[134] + Tv[I+2];
      i := i + 5;
    Until i > 130;
    Tv[134] := Tv[134] + Tv[133];
  end; {End with}
  SaveTv(RetNo,FName,FNo);

End;

Procedure T2042_4(RetNo:integer;FName:string;FNo:integer);
Var I: integer; FInst :String[4];

Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo]^.Frm[Fno] do
  begin
    {CCA Xi}
    Tv[82] := 0;
    I := 1;
    Repeat
    If Uppercase(Strings[163]) <> 'X' then  Strings[i+6] := GetCCARate(Strings[i]);
    CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       Tv[i+4],Tv[i+5],Strings[i+6],Tv[i+7],Tv[i+8]);

     Tv[82] := Tv[82] + Tv[I+7];
     I := i+10;
    until i > 82;
    Tv[82] := Tv[82] + Tv[81];

   {cca - motor veh}
   Tv[86] := 0; {solve a problem}
   Tv[124] := 0;
   I := 83;
    Repeat
     Strings[i] := '10.1'; Strings[i+6] := '30'; {GetCCARate(Strings[i]);}
     Strings[113] := '10';
     CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       Tv[i+4],Tv[i+5],Strings[i+6],Tv[i+7],Tv[i+8]);
     Tv[124] := Tv[124] + Tv[I+7];
     I := i+10;
    until i > 113;
    Tv[124] := Tv[124] + Tv[123];

   {CCA XVII}
    Tv[147] := 0;
    I := 128;
    Repeat
     Tv[I+2] := Tv[i] * Tv[I+1]/100;
     Tv[147] := Tv[147] + Tv[I+2];
     I := i+7;
    until i > 139;
    Tv[147] := Tv[147] + Tv[146];
    Tv[148] := Tv[82] +Tv[147];

  {CEC}
    Tv[151] := Tv[150] * 0.75;
    Tv[152] := Tv[149] + Tv[151];
    Tv[155] := Tv[153] + Tv[154];
    Tv[156] := Tv[155] * 0.75;
    Tv[157] := Tv[152] - Tv[156];
    If Tv[157] <0 then
      begin
        Tv[160] := ABS(Tv[157]);
        Tv[159] := 0;
        Tv[158] :=0;
        Tv[162] := MaxR(0,Tv[160] - Tv[161]);
      end
    else
      begin
        Tv[160] := 0; Tv[161] := 0;Tv[162] := 0;
        If Tv[158]>0 then
         Tv[159] := Tv[158]
         else
         Tv[159] := Tv[157] * 0.07;
      end;

  end; {End with}
  SaveTv(RetNo,FName,FNo);

End;

Procedure T2042_5(RetNo:integer;FName:string;FNo:integer);
var i: integer; x,NI : real; FInst : String[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin
    If Tv[42] >0 then
    begin
    Strings[40] :=GetSpouseFirstName(RetNo)+' '+
                  GetSpouseLastName(RetNo);
    Strings[43] :=GetSpouseAddress(RetNo);
    end
   else
    begin Strings[57] :='';Strings[43] :='';end;

    {amounts deductible}
    Tv[13] := Tv[6] +Tv[8]+tv[10]+tv[12];

    {business use of home}
    Tv[26] := Tv[14]+Tv[15] +Tv[16]+tv[17]+tv[18]+tv[19];
    Tv[26] := Tv[26] +Tv[21] +Tv[23]+tv[25];

    Tv[28] := (Tv[26] * Tv[27]) / 100;  {pers use}
    Tv[29] := Tv[26] - Tv[28];
    If Tv[30]=0 then Tv[30] :=0;
    Tv[31] := (Tv[29] * Tv[30]) / 100;  {allocation}
    Tv[29] := Tv[26] - Tv[28];
    Tv[32] := Vl(FetchElm(RetNo,'CFR_1',35));
    Tv[33] := Tv[31] + Tv[32];
    Tv[34] := Vl(FetchElm(RetNo,'T2042_2'+FInst,46));
    Tv[35] := MaxR(0,Tv[33]-Tv[34]);
    Tv[36] := MaxR(0,MinR(Tv[33],Tv[34]));
    {partners}
    x := Vl(FetchElm(RetNo,'T2042_1'+FInst,24)) +  {my share}
      Tv[42]+Tv[46]+Tv[50]+Tv[54]+Tv[58]+Tv[62];   {others}
    If x > 100 then   {check %}
      begin
      MessageBeep(0);
      Tv[42] := Tv[42] - (x - 100); {adjust first one}
    end;
    Ni :=Vl(FetchElm(RetNo,'T2042_2'+FInst,48));
    i := 41;    {calc inc for partners}
    repeat
        Tv[i] := Ni *  Tv[i+1] / 100;
        i := i + 4;
    until i > 61;
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

Procedure T2042_6(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcAutoExp(RetNo,FName,FNo,'F');
End;

Procedure T2121_1(RetNo:integer;FName:string;FNo:integer);
Var i :integer;
  FInst : String[4];
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo]^.Frm[Fno] do
 begin
   Strings[1] := FetchElm(RetNo,FirstFormName,2);
   Strings[2] := FetchElm(RetNo,FirstFormName,5);
   Strings[3] := FetchElm(RetNo,FirstFormName,3);
   If Strings[4] ='' then Strings[4] := '01-01-'+AppYear;
   If Strings[5] ='' then Strings[5] := '31-12-'+AppYear;
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;
   If TV[18] = 0 then TV[18] := 100;
   Tv[30] :=  TotMultiple(RetNo,'T4F',2);
   Tv[35] :=0;
   For i :=20 to 24 do
     Tv[35] := Tv[35] +Tv[i];
   Tv[35] := Tv[35] + Tv[26]+Tv[28]+Tv[30]+tv[32]+Tv[34];

   Tv[52] := Tv[49]+Tv[50]+Tv[51];
   Tv[54] := Tv[52] - Tv[53];
   Tv[55] := Tv[54];

   Tv[64] := 0;
   For i :=36 to 48 do
     Tv[64] := Tv[64] +Tv[i];
   Tv[64] := Tv[64] + Tv[55]+Tv[57]+tv[59]+Tv[61]+Tv[63];
   Tv[65] := Vl(FetchElm(RetNo,'T2121_2'+FInst,177));
   Tv[66] := Vl(FetchElm(RetNo,'T2121_4'+FInst,32));
   If Tv[66] =0 then Tv[66] :=
          -Vl(FetchElm(RetNo,'T2121_4'+FInst,36));  {inc inclusion}

   Tv[67] := Tv[64] + Tv[65]+Tv[66];
   Tv[68] := Tv[67];
   Tv[69] := Tv[35] - Tv[68];
   Tv[70] := Tv[69] * Tv[18] /100;
   Tv[71] := Vl(FetchElm(RetNo,'T2121_2'+FInst,9));
   Tv[72] := Tv[70] - Tv[71];
   Tv[73] := Vl(FetchElm(RetNo,'T2121_2'+FInst,32));
   Tv[74] := Tv[72] - Tv[73];

  end; {End with}

  SaveTv(RetNo,FName,FNo);


End;

Procedure T2121_2(RetNo:integer;FName:string;FNo:integer);
var i: integer; x : real; FInst : String[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin
    {amounts deductible}
    Tv[9] := Tv[2] +Tv[4]+tv[6]+Tv[8];
    {business use of home}
    Tv[22] := Tv[10] +Tv[11]+tv[12]+tv[13]+tv[14]+Tv[15];
    Tv[22] := Tv[22] +Tv[17] +Tv[19]+Tv[21];

    Tv[24] := (Tv[22] * Tv[23]) / 100;  {pers use}
    Tv[25] := Tv[22] - Tv[24];
    If Tv[26] =0 then Tv[26] :=100;
    Tv[27] := (Tv[25] * Tv[26]) / 100;  {alloca}
    If Finst = '#1' then Tv[28] := Vl(FetchElm(RetNo,'CFR_1',36));
    Tv[29] := Tv[27] + Tv[28];
    Tv[30] :=MaxR(0,Vl(FetchElm(RetNo,'T2121_1'+FInst,72)));
    Tv[31] := MaxR(0, Tv[29]-Tv[30]);
    Tv[32] := MinR(Tv[29],Tv[30]);

    {CCA Xi}
    Tv[118] := 0;
    I := 37;
    Repeat
     If Uppercase(Strings[36]) <> 'X' then  Strings[i+6] := GetCCARate(Strings[i]);
     CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       Tv[i+4],Tv[i+5],Strings[i+6],Tv[i+7],Tv[i+8]);
     Tv[118] := Tv[118] + Tv[I+7];
     I := i+10;
    until i > 107;
    Tv[118] := Tv[118] + Tv[117];

   {cca - motor veh}
   Tv[160] := 0;
   I := 119;
    Repeat
     Strings[i] := '10.1'; Strings[i+6] := '30';
     Strings[149] := '10';
     CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       Tv[i+4],Tv[i+5],Strings[i+6],Tv[i+7],Tv[i+8]);
     Tv[160] := Tv[160] + Tv[I+7];
     I := i+10;
    until i > 149;
    Tv[160] := Tv[160] + Tv[159];
   {CCA XVII}
    Tv[176] := 0;
    I := 164;
    Repeat
     Tv[I+2] := Tv[i] * Tv[I+1]/100;
     Tv[176] := Tv[176] + Tv[I+2];
     I := i+7;
    until i > 171;
    Tv[176] := Tv[176] + Tv[175];
    Tv[177] := Tv[118]+Tv[176];
  end; {End with}
  SaveTv(RetNo,FName,FNo);

End;

Procedure T2121_3(RetNo:integer;FName:string;FNo:integer);
Var I: integer; FInst :String[4]; x :real;
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo]^.Frm[Fno] do
  begin
    {equip additions}
    I := 3; Tv[22] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[22] := Tv[22] + Tv[I+2];
      i := i + 5;
    Until i > 18;
    Tv[22] := Tv[22] + Tv[21];

    {motor}
    I := 25; Tv[44] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[44] := Tv[44] + Tv[I+2];
      i := i + 5;
    Until i > 40;
    Tv[44] := Tv[44] + Tv[43];
    Tv[45] := Tv[22] +Tv[44];
    {build additions}
    I := 48; Tv[67] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[67] := Tv[67] + Tv[I+2];
      i := i + 5;
    Until i > 63;
    Tv[67] := Tv[67] + Tv[66];

    {equip disp }
    I := 70; Tv[89] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[89] := Tv[89] + Tv[I+2];
      i := i + 5;
    Until i > 85;
    Tv[89] := Tv[89] + Tv[88];
    {motor disp }
    I := 92; Tv[111] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[111] := Tv[111] + Tv[I+2];
      i := i + 5;
    Until i > 107;
    Tv[111] := Tv[111] + Tv[110];
    Tv[112] := Tv[89] + Tv[111];
    {build disp }
    I := 115; Tv[134] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[134] := Tv[134] + Tv[I+2];
      i := i + 5;
    Until i > 130;
    Tv[134] := Tv[134] + Tv[133];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
End;

Procedure T2121_4(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x,Ni:real;FInst:string[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo]^.Frm[Fno] do
  begin
    If Tv[5] >0 then
     begin
      Strings[3] :=GetSpouseFirstName(RetNo)+' '+
                   GetSpouseLastName(RetNo);
      Strings[6] :=GetSpouseAddress(RetNo);
     end
     else
      begin Strings[3] :='';Strings[6] :='';end;

    {partners}
    x := Vl(FetchElm(RetNo,'T2121_1'+FInst,18)) +  {my share}
      Tv[5]+Tv[9]+Tv[13]+Tv[17]+Tv[21];   {others}
    If x > 100 then   {check %}
      begin
      MessageBeep(0);
      Tv[9] := Tv[9] - (x - 100); {adjust first one}
    end;
    Ni := Vl(FetchElm(RetNo,'T2121_1'+FInst,74));
    i := 4;    {calc inc for partners}
    repeat
        Tv[i] := Ni  *  Tv[i+1] / 100;
        i := i + 4;
    until i > 20;

    {CEC}
    Tv[25] := Tv[24] * 0.75;
    Tv[26] := Tv[23] + Tv[25];
    Tv[29] := Tv[27] + Tv[28];
    Tv[30] := Tv[29] * 0.75;
    Tv[31] := Tv[26] - Tv[30];
    If Tv[31] <0 then
      begin
        Tv[34] := ABS(Tv[31]);
        Tv[33] := 0;
        Tv[32] :=0;
        Tv[36] := MaxR(0,Tv[34] - Tv[35]- Tv[38]);
      end
    else
      begin
        Tv[34] := 0; Tv[35] := 0;Tv[36] := 0;
        If Tv[32]>0 then
         Tv[33] := Tv[32]
         else
         Tv[33] := Tv[31] * 0.07;
      end;
  end;
 SaveTv(RetNo,FName,FNo);
End;

Procedure T2121_5(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcAutoExp(RetNo,FName,FNo,'I');
End;


(* Pattern
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo]^.Frm[Fno] do
  begin
    Tv[10] := Tv[1]+Tv[2];
    Strings[1] := FetchElm(RetNo,FirstFormName,2);
    repeat
        Tv[9] := Tv[9] + Tv[i];
        i := i + 2;
    until i = 10;
    Ret[RetNo]^.Ln[162] := Tv[32]
  end; {End with}

  SaveTv(RetNo,FName,FNo);
*)


Procedure T1139_1(RetNo:integer;FName:string;FNo:integer);
Var I:integer;
  FInst : String[3];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin
   Strings[4] :=GetSinNo(RetNo);
   if strings[2]+strings[3] ='' then strings[2] :='X';
   If strings[30] = '' then Strings[30] := DateToStr(Date);
   If strings[31] ='' then strings[31] :=
     GetLastName(RetNo)+', '+GetFirstName(RetNo);
   If UpperCase(Strings[2]) = 'X' then
   begin
   for i:=18 to 28 do Tv[i] :=0;
   Tv[8] :=tv[6]+Tv[7];
   Tv[10] := Tv[9];
   Tv[11] := Tv[9] * 0.95;
   Tv[12] := MaxR(0,Vl(FetchElm(RetNo,'T1139_2'+FInst,11)));
   Tv[13] := MinR(Tv[11],Tv[12]);
   Tv[14] := Tv[13];
   Tv[16] := Tv[8] - Tv[13];
   Tv[14] := Tv[13];
   end
   else   {alternative method}
   begin
   for i:=6 to 17 do Tv[i] :=0;
   Tv[20] :=tv[18]+Tv[19];
   Tv[22] := Tv[21];
   Tv[23] := Tv[21] * 0.95;
   Tv[24] := MaxR(0,Vl(FetchElm(RetNo,'T1139_2'+FInst,11)));
   Tv[25] := MinR(Tv[23],Tv[24]);
   Tv[27] := Tv[20] - Tv[25];
   Tv[28] := Tv[27];
   end;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure T1139_2(RetNo:integer;FName:string;FNo:integer);
Var I:integer;
  FInst : String[3];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin
   Strings[1] := FetchElm(RetNo,'T1139_1'+FInst,1);
   Strings[2] := FetchElm(RetNo,'T1139_1'+FInst,32);
   Strings[3] := FetchElm(RetNo,'T1139_1'+FInst,33);

   If UpperCase(FetchElm(RetNo,'T1139_1'+FInst,3)) = 'X' then
   begin
    for i := 12 to 19 do Tv[i] :=0;
    Tv[4] := Vl(FetchElm(RetNo,'T1139_1'+FInst,8));
    {?t1139_2  Tv[6] := Ln[150]-Ln[135]-Ln[137]-Ln[139]-Ln[141]-Ln[143];} 
    Tv[7] := Tv[4]+Tv[5]+Tv[6];
    Tv[10] := Tv[7]-Tv[8]-Tv[9];
    Tv[11] := Tv[7]-Tv[10];
   end
   else
   begin
    for i := 4 to 11 do Tv[i] :=0;
    Tv[12] := Vl(FetchElm(RetNo,'T1139_1'+FInst,18));
    Tv[15] := MinR(Tv[13],Tv[14]);
    Tv[16] := Tv[12]-Tv[15];
    {?T1139 Strings[17] := }
    {?T1139 Strings[18] := }
   end;
   Tv[20] := Vl(FetchElm(RetNo,'T1139_1'+FInst,13)) * 0.10;
   Tv[21] := Vl(FetchElm(RetNo,'T1139_1'+FInst,13)) * 0.15;
 end;
   SaveTv(RetNo,FName,FNo);

end;

Procedure T1139SM(RetNo:integer;FName:string;FNo:integer);
Begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin
   Strings[1] :=GetSinNo(RetNo);
   If strings[8] = '' then Strings[8] := DateToStr(Date);
   If strings[27] ='' then strings[27] :=
     GetLastName(RetNo)+', '+GetFirstName(RetNo);

   Tv[5] :=tv[3]+Tv[4];
   Tv[7] := Tv[6];
   Tv[9] := Tv[6] * 0.95;
   Tv[11] := MinR(Tv[9],Tv[10]);
   Tv[12] := Tv[11];
   Tv[13] := Tv[5] - Tv[11];
   Tv[14] := Tv[13];

   {alternative method}
   Tv[17] :=tv[15]+Tv[16];
   Tv[19] := Tv[18];
   Tv[20] := Tv[18] * 0.95;
   Tv[22] := MinR(Tv[20],Tv[21]);
   Tv[23] := Tv[22];
   Tv[13] := Tv[17] - Tv[22];
   Tv[25] := Tv[24];

  end;
  SaveTv(RetNo,FName,FNo);
end;
(*

Var i :integer;
Begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo]^ do
 begin
  {First part}
  Frm[FNo].Strings[1] := FetchElm(RetNo,'PAGE_1',3);
  Tv[7] := Tv[3]+Tv[5];
  Tv[8] := Tv[4]+Tv[6];
  If TV[9] <0 then  TV[9] :=0;
  If TV[10] <0 then  TV[10] :=0;
  Tv[11] := Tv[9] + Tv[10];
  Tv[12] := Tv[9] * 0.95;
  Tv[13] := Tv[10] * 0.95;

  If Tv[16] > MinR(Tv[12],Tv[14]) then Tv[16] := MinR(Tv[12],Tv[14]);
  If Tv[17] > MinR(Tv[13],Tv[15]) then Tv[17] := MinR(Tv[13],Tv[15]);
  Tv[18] := Tv[16] + TV[17];
  Tv[19] := Tv[7] - Tv[16];
  Tv[20] := Tv[8] - Tv[17];
  {Part 2}
  Tv[25] := Tv[21]+Tv[23];
  Tv[26] := Tv[22]+Tv[24];
  If TV[27] <0 then  TV[27] :=0;
  If TV[28] <0 then  TV[28] :=0;

  Tv[29] := Tv[27] + Tv[28];
  Tv[30] := Tv[27] * 0.95;
  Tv[31] := Tv[28] * 0.95;

  If Tv[34] > MinR(Tv[30],Tv[32]) then Tv[34] := MinR(Tv[30],Tv[32]);
  If Tv[35] > MinR(Tv[31],Tv[33]) then Tv[35] := MinR(Tv[31],Tv[33]);
  Tv[36] := Tv[34] + TV[35];
  Tv[37] := Tv[25] - Tv[34];
  Tv[38] := Tv[26] - Tv[35];

  Ln[181] := Tv[11];
  Ln[182] := Tv[18];
  Ln[184] := Tv[29];
  Ln[185] := Tv[36];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)

Procedure T2124_1(RetNo:integer;FName:string;FNo:integer);
Var i :integer;
  FInst : String[4];
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo]^.Frm[Fno] do
 begin
   Strings[1] := FetchElm(RetNo,FirstFormName,2);
   Strings[2] := FetchElm(RetNo,FirstFormName,5);
   Strings[3] := FetchElm(RetNo,FirstFormName,3);
   If Strings[4] ='' then Strings[4] := '01-01-'+AppYear;
   If Strings[5] ='' then Strings[5] := '31-12-'+AppYear;
   If Strings[6]+Strings[7] ='' then
     begin Strings[6] := '';Strings[7] := 'X'; end;
   If TV[18] = 0 then TV[18] := 100;
   If Strings[73]+Strings[74] ='' then
     begin Strings[73] := 'X';Strings[74] := ''; end;
   Tv[26] := Tv[24] + Tv[25];
   Tv[27] := Tv[26];
   Tv[28] := Tv[23] - Tv[27];
   Tv[32] := Tv[28] + Tv[29] + Tv[31];
   Tv[39] := Tv[33] + Tv[34] + Tv[35] +Tv[36]+Tv[38];
   Tv[41] := Tv[39] - Tv[40];
   Tv[42] := Tv[41];
   Tv[43] := Tv[32] - Tv[42];
   Tv[53] := Tv[65] * 0.50;
   Tv[54] := Vl(FetchElm(RetNo,'T2124_5'+FInst,102));
   Tv[67] :=0;
   For i :=44 to 62 do
     Tv[67] := Tv[67] +Tv[i];
   Tv[67] := Tv[67] + Tv[64];
   Tv[68] := Vl(FetchElm(RetNo,'T2124_3'+FInst,82))+
             Vl(FetchElm(RetNo,'T2124_5'+FInst,125));
   Tv[69] := Vl(FetchElm(RetNo,'T2124_4'+FInst,52)); {normal allowance}
   If Tv[69] =0 then Tv[69] :=
          -Vl(FetchElm(RetNo,'T2124_4'+FInst,55));  {inc inclusion}
   Tv[70] := Tv[67] + Tv[68]+Tv[69];
   Tv[71] := Tv[70];
   Tv[72] := Tv[43] - Tv[71];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
End;

Procedure T2124_2(RetNo:integer;FName:string;FNo:integer);
var i: integer; x : real; FInst : String[4];
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin

   If Tv[38] >0 then
    Strings[57] :=GetSpouseFirstName(RetNo)+' '+
                  GetSpouseLastName(RetNo)+'  '+
                  GetSpouseAddress(RetNo)
   else
    Strings[57] :='';


    {NI before adjustments}
    Tv[1] := Vl(FetchElm(RetNo,'T2124_1'+FInst,72));
    Tv[2] := Tv[1] *
      Vl(FetchElm(RetNo,'T2124_1'+FInst,18)) / 100;  {Share}
    Tv[3] := Tv[15];
    Tv[4] := Tv[2] - Tv[3];
    {amounts deductible}
    Tv[15] := Tv[8] +Tv[10]+tv[12]+tv[14];
    {business use of home}
    Tv[28] := Tv[16] +Tv[17]+tv[18]+tv[19]+tv[20]+Tv[21];
    Tv[28] := Tv[28] +Tv[23] +Tv[25]+tv[27];
    Tv[29] := (Tv[28] * Tv[54]) / 100;  {pers use}
    Tv[30] := Tv[28] - Tv[29];
    If Tv[55] =0 then Tv[55] := 100;
    Tv[56] := Tv[55] * Tv[30] /100;
    Tv[31] := Vl(FetchElm(RetNo,'CFR_1',33));
    Tv[32] := Tv[56] + Tv[31];
    Tv[33] := MaxR(0,Tv[4]);
    Tv[34] := MaxR(0, Tv[32]-Tv[33]);
    Tv[35] := MinR(Tv[32],Tv[33]);

    Tv[5] := Tv[35];
    Tv[6] := Tv[4] - Tv[5];
    {partners}
    x := Vl(FetchElm(RetNo,'T2124_1'+FInst,18)) +  {my share}
      Tv[38]+Tv[41]+Tv[44]+Tv[47]+Tv[50];   {others}
    If x > 100 then   {check %}
      begin
      MessageBeep(0);
      Tv[38] := Tv[38] - (x - 100); {adjust first one}
    end;
    i := 37;    {calc inc for partners}
    repeat
        Tv[i] := (Vl(FetchElm(RetNo,'T2124_1'+FInst,72))*  Tv[i+1]) / 100;
        i := i + 3;
    until i > 49;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure T2124_3(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcBusProf_3(RetNo,FName,FNo,'B');
End;

Procedure CalcBusProf_3(RetNo:integer;FName:string;FNo:integer;Stm:string);
Var I: integer; FInst :String[4];
 Cls,Rate: string[4];
  {UccStart, Additions,Proceeds,AdjUcc, Adjustments,BaseForCca,
   CCA, UCCEnd : real;}
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo]^.Frm[Fno] do
  begin
    {CCA}
    Tv[82] := 0;
    I := 1;
    Repeat
     If Uppercase(Strings[214]) <> 'X' then
         Strings[i+6] := GetCCARate(Strings[i]);
     CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       Tv[i+4],Tv[i+5],Strings[i+6],Tv[i+7],Tv[i+8]);
     Tv[82] := Tv[82] + Tv[I+7];
     I := i+10;
    until i > 71;
    Tv[82] := Tv[82] + Tv[81];

   {cca - motor veh}
   Tv[124] := 0;
   I := 83;
    Repeat
     Strings[i] := '10.1'; Strings[i+6] := '30'; {GetCCARate(Strings[i]);}
     Strings[113] := '10';
     CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],
                       Tv[i+4],Tv[i+5],Strings[i+6],Tv[i+7],Tv[i+8]);
     Tv[124] := Tv[124] + Tv[I+7];
     I := i+10;
    until i > 113;
    Tv[124] := Tv[124] + Tv[123];

    {equip additions}
    I := 127; Tv[146] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[146] := Tv[146] + Tv[I+2];
      i := i + 5;
    Until i > 142;
    Tv[146] := Tv[146] + Tv[145];

    {motor additions}
    I := 149; Tv[168] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[168] := Tv[168] + Tv[I+2];
      i := i + 5;
    Until i > 164;
    Tv[168] := Tv[168] + Tv[167];
    Tv[169] := Tv[146] + Tv[168];

    {build additions}
    I := 172; Tv[191] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[191] := Tv[191] + Tv[I+2];
      i := i + 5;
    Until i > 187;
    Tv[191] := Tv[191] + Tv[190];

    {equip disp }
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


Procedure T2124_4(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcBusProf_4(RetNo,FName,FNo,'B');
End;

Procedure T2124_5(RetNo:integer;FName:string;FNo:integer);
Begin
  CalcAutoExp(RetNo,FName,FNo,'B');
End;

Procedure CalcAutoExp(RetNo:integer;FName:string;FNo:integer;Stm:string);
Var I,k: integer; FInst :String[4];
Begin
 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo]^.Frm[Fno] do
  begin
   If Stm = 'B' then
      begin
       Tv[118] := Vl(FetchElm(RetNo,'T2124_3'+FInst,124));
       Strings[39] := 'Business Stement '+FInst;
      end
   else If Stm = 'P' then
     begin
       Tv[118] := Vl(FetchElm(RetNo,'T2032_3'+FInst,124));
       Strings[39] := 'Professional Statement '+FInst;
      end

   else If Stm = 'I' then  {fishing}
     begin
       Tv[118] := Vl(FetchElm(RetNo,'T2121_2'+FInst,160));
       Strings[39] := 'Fishing Statement '+FInst;
      end

   else If Stm = 'F' then  {farming}
     begin
       Tv[118] := Vl(FetchElm(RetNo,'T2042_4'+FInst,124));
       Strings[39] := 'Farming Statement '+FInst;
      end

   else If Stm = 'O' then  {Other - unattached}
     begin
       {Tv[118] := Vl(FetchElm(RetNo,'T2121_4'+FInst,124));}
      end;
   For i :=4 to 6 do
     If Vl(Strings[i+3]) < Vl(Strings[i]) then Strings[i+3] := Strings[i];

   If Tv[119]+Tv[120]+Tv[121] =0 then Tv[119] := Tv[118];
   For i:=0 to 2 do
   begin
    Tv[42+i] := Tv[10+i]+Tv[13+i]+tv[16+i]+Tv[19+i]+Tv[22+i]+Tv[25+i]
                +Tv[28+i]+Tv[32+i]+Tv[36+i];
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
    If Vl(RightStr(Strings[57+i],4))< 1991 then
      k := 23529 else k := 28235;
    Tv[78+i] := MaxR(k,Tv[75+i] * 0.85);

    If Vl(RightStr(Strings[57+i],4))< 1991 then k := 600 else k := 650;
    Tv[93+i] := MaxR(0,(k * Tv[72+i]/30) - Tv[69+i]-Tv[81+i] - Tv[87+i]);

    If Vl(RightStr(Strings[57+i],4))< 1991 then k := 20000 else k := 24000;
    If Tv[78+i] >0 then
     Tv[96+i] := MaxR(0,(k * Tv[66+i]/Tv[78+i] - Tv[84+i]-Tv[90+i]))
    else
     Tv[96+i] :=0;
    Tv[99+i] := MinR(Tv[93+i],Tv[96+i]);
    {Interest}
    If Tv[109+i] = 0 then Tv[109+i] := 10;
    Tv[112+i] := Vl(Strings[106+i]) * Tv[109+i];
    Tv[115+i] := MinR(Tv[103+i],Tv[112+i]);
   end;

   Tv[102] := Tv[54]+Tv[55]+Tv[56];
   Tv[125] := Tv[122]+Tv[123]+Tv[124];
 end; {End with}
  SaveTv(RetNo,FName,FNo);
 End;

Procedure CalcBusProf_4(RetNo:integer;FName:string;FNo:integer;Stm:string);
Var I: integer; FInst :String[4];
 Cls: string[4];
  {UccStart, Additions,Proceeds,AdjUcc, Adjustments,BaseForCca,
   Rate, CCA, UCCEnd : real;}
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo]^.Frm[Fno] do
  begin
    {motor disp }
    I := 3; Tv[56] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[56] := Tv[56] + Tv[I+2];
      i := i + 5;
    Until i > 13;
    Tv[56] := Tv[56] + Tv[16];
    If Stm = 'B' then
     Tv[17] := Tv[56] +Vl(FetchElm(RetNo,'T2124_3'+FInst,213))
    else if Stm = 'P' then
      Tv[17] := Tv[56] +Vl(FetchElm(RetNo,'T2032_3'+FInst,213));

    {build disp }
    I := 20; Tv[139] := 0;
    Repeat
      Tv[I+2] := Tv[I] - Tv[I+1];
      Tv[39] := Tv[39] + Tv[I+2];
      i := i + 5;
    Until i > 35;
    Tv[39] := Tv[39] + Tv[38];

    {CEC}
    Tv[44] := Tv[43] * 0.75;
    Tv[45] := Tv[42] + Tv[44];
    Tv[48] := Tv[46] + Tv[47];
    Tv[49] := Tv[48] * 0.75;
    Tv[50] := Tv[45] - Tv[49];
    If Tv[50] <0 then
      begin
        Tv[53] := ABS(Tv[50]);
        Tv[52] := 0;
        Tv[51] :=0;
        Tv[55] := MaxR(0,Tv[53] - Tv[54]- Tv[57]);
      end
    else
      begin
        Tv[53] := 0; Tv[54] := 0;Tv[55] := 0;
        If Tv[51]>0 then
         Tv[52] := Tv[51]
         else
         Tv[52] := Tv[50] * 0.07;
      end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
End;

Procedure Inv_1(RetNo:integer;FName:string;FNo:integer);
Var i,j,PagesCharged:integer; Frms,HowMany:TstringList;
begin
 UpdateAllDataIndicators(RetNo);
 LoadTv(RetNo,FName,FNo);
 Frms := TStringList.Create;
 HowMany := TStringList.Create;
 with Ret[RetNo]^.Frm[Fno] do
 begin
  PagesCharged :=0;
  Strings[1] := GetLastName(RetNo)+', '+GetFirstName(RetNo);
  Strings[2] :=AppYear;
  Strings[3] :=IntToStr(CountPagesGenerated(RetNo));
  Strings[5] := FormatAmount(FloatToStr(GetTotalFee(RetNo)));
  {FormatFloat('###,###.00',GetTotalFee(RetNo));}
  GetListInvoiceForms(RetNo,Frms,HowMany);
  j := 7;
  For i:=0 to Frms.Count-1 do
    begin
    Inc(PagesCharged,MyStrToInt(HowMany[i]));
    Strings[j]   := PaddR(HowMany[i],5)+Frms[i];
    Strings[j+1] := FormatAmount(FloatToStr(
                    GetFormFee(Frms[i],MyStrToInt(HowMany[i]))
                    ));
    {FormatFloat('###,###.00',
                      GetFormFee(Frms[i],MyStrToInt(HowMany[i])));}
    Inc(j,2);
    If J>130 then break;
    end;
  Strings[4] := IntToStr(PagesCharged);
 end;
 Frms.Free;HowMany.Free;
 {SaveTv(RetNo,FName,FNo);  not needed}
end;


Procedure Inv_2(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
begin
 UpdateAllDataIndicators(RetNo);
LoadTv(RetNo,FName,FNo);
with Ret[RetNo]^.Frm[Fno] do
 begin
 Strings[1] := CfgRec.PRp_Name;
 Strings[2] := CfgRec.PRp_Street;
 Strings[4] := CfgRec.PRp_City+', '+CfgRec.PRp_Prov;
 Strings[5] := CfgRec.PRp_Postal;
 Strings[7] := CfgRec.PRp_Area+' '+CfgRec.PRp_Tel;
 Strings[8] := CfgRec.PRp_GSTNo;
 Strings[3] := DateToMonthDayYear(Date);
 Strings[9] := DateToStr(Date);
 (*? Invoice Number
 Strings[10] := User.M_Office+'-'+User.Branch + '-'
    + User.Prep_Intls
    + '-' +IntToStr(User.Inv_no); {invoice}
 *)
 Strings[10] := GetSinNo(RetNo)+'-'+AppYear;
 Strings[11] := GetFirstName(RetNo)+' '+GetLastName(RetNo);
 Strings[12] := Rtrim(FetchElm(RetNo,'PAGE_1',6));
 Strings[15] := Rtrim(FetchElm(RetNo,'PAGE_1',10))+', '+
                Rtrim(FetchElm(RetNo,'PAGE_1',14))+', '+
                Rtrim(FetchElm(RetNo,'PAGE_1',15));
 Strings[16] := AppYear;

 If Strings[51]+Strings[49]+Strings[44]+Strings[45]+Strings[46]+
         Strings[47]+Strings[48]+Strings[52] =''
 then
   begin
         Case MyStrToInt(CfgRec.Prp_Bill) of
          0: Strings[51] :='X';
          1: Strings[49] :='X';
          2: begin Strings[52] :='X';Strings[50] := '30';end;
          3: Strings[46] :='X';
         end;
   end;

 If Strings[44]>'' then Tv[17] := CfgRec.Prp_VSFee else Tv[7] :=0;
 If Strings[45]>'' then Tv[17] := CfgRec.Prp_SFee else Tv[6]:=0;
 If Strings[46]>'' then Tv[17] := CfgRec.Prp_AFee else tv[8] :=0;
 If Strings[47]>'' then Tv[17] := CfgRec.Prp_CFee else Tv[9]:=0;
 If Strings[48]>'' then Tv[17]:= CfgRec.Prp_VCFee else Tv[10]:=0;
 If Strings[49]>'' then Tv[17]:= GetTotalFee(RetNo);
 If Strings[52]>'' then Tv[17]:= Vl(Strings[50]) *CfgRec.Prp_Hour/60;


 Tv[19] := Tv[17] + Tv[18]+Tv[34] + Tv[35]+Tv[36] + Tv[37]+Tv[38] + Tv[39]+
           Tv[42] + Tv[43];
 If Strings[8] = '' then Strings[20] := '' else Strings[20] :='7';
 Tv[21] := Tv[19] * Vl(Strings[20]) / 100;
 Tv[22] := Tv[19] + Tv[21];
 Strings[26] := User.Prep_Name;
 end;

SaveTv(RetNo,FName,FNo);
end;

Procedure FORINC(RetNo:integer;FName:string;FNo:integer);
var i,col: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo]^ do
  begin
    {Foreign Pension}
    Tv[4] := GetFPENSByCountry(RetNo,'1','I'); {income}
    Tv[6] := GetFPENSByCountry(RetNo,'2','I');
    Tv[8] := GetFPENSByCountry(RetNo,'3','I');
    Tv[5] := GetFPENSByCountry(RetNo,'1','T'); {Tax}
    Tv[7] := GetFPENSByCountry(RetNo,'2','T');
    Tv[9]:= GetFPENSByCountry(RetNo,'3','T');
    Tv[121]:= GetFPENSByCountry(RetNo,'1','E'); {exempt income}
    Tv[123] := GetFPENSByCountry(RetNo,'2','E');
    Tv[124] := GetFPENSByCountry(RetNo,'3','E');

    {For investment income}
            {ret,Slip,Row,exhrow,sharerow,countrycode,countryrow}
    Tv[43]:= GetForeignFromSlip(RetNo,'T4PS',7,0,0,0,0)+  {country 1 always}
             GetForeignFromSlip(RetNo,'T4PS',8,0,0,0,0)+
             T5FNonBusInc1+ {country 1}
             T3FNonBusInc1+
             T5013FNonBusInc1;  {country 1}
    Tv[45]:= T5FNonBusInc2+ {country 2}
             T3FNonBusInc2+
             T5013FNonBusInc2; {GetForeignFromSlip(RetNo,'T3',9,4,2,2,5);}
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
    {S(11) deduction}
    Tv[127] := MaxR(0,tv[110] -Tv[109] * 0.15);Tv[128] := Tv[127];
    Tv[129] := MaxR(0,Tv[112] -Tv[111] * 0.15); Tv[130] := Tv[129];
    Tv[131] := MaxR(0,Tv[114] -Tv[113] * 0.15);Tv[132] := Tv[131];
    {Net Non inv income}
    Col:=0;
    Repeat
     Tv[157+Col] := Tv[109+Col] - Tv[115+Col]-Tv[121+col]-Tv[127+Col]-
                    Tv[133+Col] - Tv[139+Col]-Tv[145+col]-Tv[151+Col];
    Inc(Col);
    until Col >5;
    {Foreign Business Income}
    Tv[163]:= T3FBusInc1; {country 1}
    Tv[165]:= T3FBusInc2; {country 2}
    Tv[167]:= T3FBusInc1; {country 3}
    Tv[169]:= T5013FBusInc1; {country 1}
    Tv[171]:= T5013FBusInc2; {country 2}
    Tv[173]:= T5013FBusInc1; {country 3}
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
      Tv[207+Col] := Tv[189+Col]-Tv[195+Col]-Tv[201+Col]-Tv[207+Col];
      inc(Col);
    until Col > 5;

end;
    {save data}
SaveTv(RetNo,FName,FNo);
{initialize fed/prov credits}
InitFormData(RetNo,GetFormNo('T2036'));
InitFormData(RetNo,GetFormNo('T2209#1'));
InitFormData(RetNo,GetFormNo('T2209#2'));
InitFormData(RetNo,GetFormNo('T2209#3'));

End;

Procedure RESINC(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin
   Tv[60] := Ret[RetNo]^.T5013ResAllow;
   Tv[10] := Tv[1] +tv[2]+Tv[3]+Tv[4]+tv[5]+tv[7]+TV[9]+Tv[59]+Tv[60];
   Tv[18] := Tv[11] +tv[12]+Tv[13]+Tv[15]+tv[17];
   Tv[19] := tv[10] - Tv[18];
   Tv[20] := Ret[RetNo]^.T102PShipInc;
   Tv[21] := Tv[12];
   If Vl(FetchElm(RetNo,'RESEXP',30))<0 then
      Tv[22] := ABS(Vl(FetchElm(RetNo,'RESEXP',30)));
   If Vl(FetchElm(RetNo,'RESEXP',29))<0 then
      Tv[23] := ABS(Vl(FetchElm(RetNo,'RESEXP',30)));

   Tv[24] := Tv[20] +tv[21]+Tv[22]+Tv[23];
   Tv[25] := Tv[19];
   Tv[26] := Tv[25] * 0.25;
   Tv[27] := Tv[59];
   Tv[29] := Vl(FetchElm(RetNo,'RESEXP',42));
   Tv[30] := Vl(FetchElm(RetNo,'RESEXP',41));
   Tv[31] := Vl(FetchElm(RetNo,'RESEXP',40));

   Tv[36] := Tv[26] +Tv[27]+Tv[28]+Tv[29]+Tv[30] +tv[31]+Tv[33]+Tv[35];
   Tv[37] := Tv[19] +Tv[24]-Tv[36];

   Tv[38] := Vl(FetchElm(RetNo,'RESEXP',52));
   Tv[39] := Vl(FetchElm(RetNo,'RESEXP',53));

   Tv[44] := Tv[38] +tv[39]+Tv[41]+Tv[43];
   Tv[45] := tv[37] - Tv[44];
   Tv[46] := Tv[23];
   If Vl(FetchElm(RetNo,'RESEXP',32))<0 then
      Tv[48] := ABS(Vl(FetchElm(RetNo,'RESEXP',32)));

   Tv[53] := Tv[46] +Tv[47]+Tv[48]+Tv[50]+Tv[52];
   Tv[54] := MaxR(0,Vl(FetchElm(RetNo,'RESEXP',32)));
   Tv[57] := Tv[54] +tv[56];
   Tv[58] := Tv[45] +tv[53]-Tv[57];
  end;
  SaveTv(RetNo,FName,FNo);

end;

Procedure RESEXP(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo]^.Frm[Fno] do
  begin
   Strings[33] :='100';Strings[34] := '30';Strings[35] := '10';
   {CEE}
   Tv[5] := Ret[RetNo]^.T101CEE+Ret[RetNo]^.T102CEE+Ret[RetNo]^.T5013CEE;
   Tv[13] := Ret[RetNo]^.T101AllowCEE + Ret[RetNo]^.T102AllowCEE;
   Tv[29] := Tv[1] +tv[5]+Tv[9]-Tv[13]-tv[17]-Tv[21]-tv[25];
   Tv[36] := MaxR(0,Tv[29] * StrToInt(Strings[33]) /100);
   {If Tv[40] =0 then} Tv[40] := Tv[36];
   Tv[44] := MaxR(0,Tv[29] -Tv[40]);
   {CDE}
   Tv[6] :=  Ret[RetNo]^.T102CDE+Ret[RetNo]^.T5013CDE;
   Tv[14] := Ret[RetNo]^.T102AllowCDE;
   Tv[30] := Tv[2] +tv[6]+Tv[10]-Tv[14]-tv[18]-Tv[22]-tv[26];
   Tv[37] := MaxR(0,Tv[30] * StrToInt(Strings[34]) /100);
   {If Tv[41] =0 then} Tv[41] := Tv[37];
   Tv[45] := MaxR(0,Tv[30]-Tv[41]);
   {COGPE}
   Tv[7] := Ret[RetNo]^.T101COGPE+Ret[RetNo]^.T102COGPE+Ret[RetNo]^.T5013COGPE;
   Tv[15] := Ret[RetNo]^.T101AllowCOGPE + Ret[RetNo]^.T102AllowCOGPE;
   Tv[31] := Tv[3] +tv[7]+Tv[11]-Tv[15]-tv[19]-Tv[23]-tv[27];
   Tv[38] := MaxR(0,Tv[31] * StrToInt(Strings[35]) /100);
   {If Tv[42] =0 then} Tv[42] := Tv[38];
   Tv[46] := MaxR(0,Tv[31]-Tv[42]);
   {For dev}
   Tv[8] := Ret[RetNo]^.T5013FDE;
   {Tv[16] := T101AllowCOGPE + T102AllowCOGPE;}
   Tv[32] := Tv[4] +tv[8]+Tv[12]-Tv[16]-tv[20]-Tv[24]-tv[28];
   Tv[47] := MaxR(0,Tv[32]-Tv[43]);

  {ED, MED}
   Tv[54] := MaxR(0,Tv[48]-Tv[52]);
   Tv[55] := MaxR(0,Tv[49]-Tv[53]);
   {analysis}
   Tv[59] := Tv[40]+tv[41]+Tv[42]+Tv[43];
   Tv[57] := Tv[59]; { - Tv[60]; ?}

   Tv[62] := Tv[52]+Tv[53];
   Tv[58] := Tv[62]; {RESEXP:  - Tv[61]; ?}
  end;
  SaveTv(RetNo,FName,FNo);

end;


Procedure BUSSUM(RetNo: integer; FName: String;FNo: integer);
Var I,T2124Fld,T2121Fld,T2042Fld,T2032Fld:integer;
    T2124Cnt,T2121Cnt,T2042Cnt,T2032Cnt:integer;
    FInst : string[3];
begin
  LoadTv(RetNo,FName,FNo);
  T2124Fld:=1;T2121Fld:=1;T2042Fld:=1;T2032Fld:=1;
  T2124Cnt:=0;T2121Cnt:=0;T2042Cnt:=0;T2032Cnt:=0;
  Tv[121]:=0; Tv[122]:=0;Tv[123]:=0;tv[124] :=0;

  with Ret[RetNo]^.Frm[Fno] do
  begin
    for i :=0 to (FList.Count - 1) do
    begin
    FRec := FList.Items[i];


     if (LeftStr(FRec^.FormName,7) = 'T2124_1') and
       (Ret[RetNo]^.FrmHasData[FRec^.FormNo]) then
     begin
            Inc(T2124Cnt);
            FInst := FRec^.FormInst;
            If T2124Cnt > 7 then
              begin
               T2124Fld := 43;
               Strings[T2124Fld] := '**** There are more ****';
               Strings[T2124Fld+1] := '';
               Strings[T2124Fld+2] := '';
               Tv[T2124Fld+3] := 0;
               Tv[T2124Fld+4] := 0;
               Tv[T2124Fld+5] := 0;
               Tv[121] := tv[121]+Vl(FetchElm(RetNo,'T2124_2'+FInst,6));
              end
              else
              begin
               T2124Fld :=(T2124Cnt-1)*6+1;
               Strings[T2124Fld] := FetchElm(RetNo,'T2124_1'+FInst,8);
               Strings[T2124Fld+1] := FetchElm(RetNo,'T2124_1'+FInst,4);
               Strings[T2124Fld+2] := FetchElm(RetNo,'T2124_1'+FInst,5);
               Tv[T2124Fld+3] := vl(FetchElm(RetNo,'T2124_1'+FInst,18));
               Tv[T2124Fld+4] := Vl(FetchElm(RetNo,'T2124_1'+FInst,32));
               Tv[T2124Fld+5] := Vl(FetchElm(RetNo,'T2124_2'+FInst,6));
               Tv[121] := tv[121]+Vl(FetchElm(RetNo,'T2124_2'+FInst,6));
              end;
      end {end T2124}

      Else if (LeftStr(FRec^.FormName,7) = 'T2042_1') and
         (Ret[RetNo]^.FrmHasData[FRec^.FormNo]) then
      begin
            Inc(T2042Cnt);
            FInst := FRec^.FormInst;
            If T2042Cnt > 3 then
              begin
               T2042Fld := 91;
               Strings[T2042Fld] := '**** There are more ****';
               Strings[T2042Fld+1] := '';
               Strings[T2042Fld+2] := '';
               Tv[T2042Fld+3] := 0;
               Tv[T2042Fld+4] := 0;
               Tv[T2042Fld+5] := 0;
               Tv[123] := Tv[123]+Vl(FetchElm(RetNo,'T2042_2'+FInst,48));
              end
              else
              begin
               T2042Fld :=(T2042Cnt-1)*6+73;
               Strings[T2042Fld] := FetchElm(RetNo,'T2042_1'+FInst,8);
               Strings[T2042Fld+1] := FetchElm(RetNo,'T2042_1'+FInst,4);
               Strings[T2042Fld+2] := FetchElm(RetNo,'T2042_1'+FInst,5);
               Tv[T2042Fld+3] := vl(FetchElm(RetNo,'T2042_1'+FInst,24));
               Tv[T2042Fld+4] := Vl(FetchElm(RetNo,'T2042_1'+FInst,66));
               Tv[T2042Fld+5] := Vl(FetchElm(RetNo,'T2042_2'+FInst,48));
               Tv[123] := Tv[123]+Vl(FetchElm(RetNo,'T2042_2'+FInst,48));
              end;
      end {end t2042}

      Else if (LeftStr(FRec^.FormName,7) = 'T2032_1') and
         (Ret[RetNo]^.FrmHasData[FRec^.FormNo]) then
      begin
            Inc(T2032Cnt);
            FInst := FRec^.FormInst;
            If T2032Cnt > 3 then
              begin
               T2032Fld := 67;
               Strings[T2032Fld] := '**** There are more ****';
               Strings[T2032Fld+1] := '';
               Strings[T2032Fld+2] := '';
               Tv[T2032Fld+3] := 0;
               Tv[T2032Fld+4] := 0;
               Tv[T2032Fld+5] := 0;
               Tv[122] := Tv[122]+Vl(FetchElm(RetNo,'T2032_1'+FInst,69));
              end
              else
              begin
               T2032Fld :=(T2032Cnt-1)*6+49;
               Strings[T2032Fld] := FetchElm(RetNo,'T2032_1'+FInst,12);
               Strings[T2032Fld+1] := FetchElm(RetNo,'T2032_1'+FInst,4);
               Strings[T2032Fld+2] := FetchElm(RetNo,'T2032_1'+FInst,7);
               Tv[T2032Fld+3] := vl(FetchElm(RetNo,'T2032_1'+FInst,21));
               Tv[T2032Fld+4] := Vl(FetchElm(RetNo,'T2032_1'+FInst,36));
               Tv[T2032Fld+5] := Vl(FetchElm(RetNo,'T2032_1'+FInst,69));
               Tv[122] := Tv[122]+Vl(FetchElm(RetNo,'T2032_1'+FInst,69));
              end;
      end {end t2032}



      Else if (LeftStr(FRec^.FormName,7) = 'T2121_1') and
         (Ret[RetNo]^.FrmHasData[FRec^.FormNo]) then
      begin
            Inc(T2121Cnt);
            FInst := FRec^.FormInst;
            If T2121Cnt > 3 then
              begin
               T2121Fld := 115;
               Strings[T2121Fld] := '**** There are more ****';
               Strings[T2121Fld+1] := '';
               Strings[T2121Fld+2] := '';
               Tv[T2121Fld+3] := 0;
               Tv[T2121Fld+4] := 0;
               Tv[T2121Fld+5] := 0;
               Tv[124] := Tv[124]+Vl(FetchElm(RetNo,'T2121_1'+FInst,74));
              end
              else
              begin
               T2121Fld :=(T2121Cnt-1)*6+97;
               Strings[T2121Fld] := FetchElm(RetNo,'T2121_1'+FInst,8);
               Strings[T2121Fld+1] := FetchElm(RetNo,'T2121_1'+FInst,4);
               Strings[T2121Fld+2] := FetchElm(RetNo,'T2121_1'+FInst,5);
               Tv[T2121Fld+3] := vl(FetchElm(RetNo,'T2121_1'+FInst,18));
               Tv[T2121Fld+4] := Vl(FetchElm(RetNo,'T2121_1'+FInst,35));
               Tv[T2121Fld+5] := Vl(FetchElm(RetNo,'T2121_1'+FInst,74));
               Tv[124] := Tv[124]+Vl(FetchElm(RetNo,'T2121_1'+FInst,74));
              end;
      end; {end t2121}
   end; {loop thru forms}
end;  {end with Ret...}
SaveTv(RetNo,FName,FNo);

end; {end routine}

end.
