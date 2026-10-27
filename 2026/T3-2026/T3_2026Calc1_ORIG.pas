unit T3_2026calc1;
{? need polit contr from POLIT}
interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T3_2026Declare, T3_2026common, T3_2026common2, T3_2026TrimStr;
    { procedure POLIT(RetNo: integer; FName: String;FNo: integer);}


Procedure T3MJON(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJAB(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJBC(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJMB(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJNB(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJNL(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJNU(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJNS(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJPE(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJSK(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJYT(RetNo: integer; FName: String; FNo: integer);
Procedure T3MJNT(RetNo: integer; FName: String; FNo: integer);

Procedure T4AP(RetNo: integer; FName: String; FNo: integer);
Procedure T106(RetNo: integer; FName: String;FNo: integer);
Procedure T106SL(RetNo: integer; FName: String;FNo: integer);

Procedure T1235(RetNo:integer;FName:string;FNo:integer);

Procedure T1236(RetNo:integer;FName:string;FNo:integer);


Procedure T2202Ws(RetNo:integer;FName:string;FNo:integer);
Function GetEmptyFootnoteElm(RetNo:Integer;FName:String):Integer;

Procedure T3A(RetNo:integer;FName:string;FNo:integer);

Procedure T4_1(RetNo:integer;FName:string;FNo:integer);
//procedure DON(RetNo: integer; FName: String;FNo: integer);
Procedure CreatePrBnfr(RetNo:Integer);
Procedure PRBNFR(RetNo:integer;FName:string;FNo:integer);
Procedure T3Supl(RetNo:integer;FName:string;FNo:integer);
Procedure CalcT3Slips(RetNo:Integer);

Procedure Invoice(RetNo:integer;FName:string;FNo:integer);
Procedure InvForms(RetNo:integer;FName:string;FNo:integer);

Procedure AVLBLE(RetNo:integer;FName:string;FNo:integer);
Procedure S1SUPPL(RetNo:integer;FName:string;FNo:integer);

Procedure S1SPLBG(RetNo:integer;FName:string;FNo:integer);
Procedure INVSTM(RetNo:integer;FName:string;FNo:integer);
Procedure FINVSTM(RetNo:integer;FName:string;FNo:integer);
Procedure T1013(RetNo:integer;FName:string;FNo:integer);

Procedure T3SUM(RetNo:integer;FName:string;FNo:integer);

Procedure POLIT(RetNo:integer;FName:string;FNo:integer);
procedure NPAD(RetNo: integer; FName: String;FNo: integer);
procedure NPADC(RetNo: integer; FName: String;FNo: integer);
procedure PRIVAT(RetNo: integer; FName: String;FNo: integer);


implementation
Uses T3_2026Calc, vtShared, T3_2026, vtCommon, vtTrimStr, vtMulti;

Procedure CalcT3Slips(RetNo:Integer);
Var
 i,FNo : integer;
begin
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormName = 'T3SUPL' then
      begin
        FNo :=Frec.FormNo;
        If (Ret[RetNo].FrmHasData[FNo]) and
           (FetchElmFNo(RetNo,FNo,41) > '')
        then T3Supl(RetNo,Frec.FormName+Frec.FormInst, FNo);
      end;
  end;
end;





procedure NPAD(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  {
  Strings[1] := GetReturnName(RetNo);
  Strings[2] := Ret[RetNo].TrustYear;
  Strings[4] :=GetAccountNumber(RetNo);
  }
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure NPADC(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  {
  Strings[2] := GetReturnName(RetNo);
  Strings[1] := Ret[RetNo].TrustYear;
  Strings[3] :=GetAccountNumber(RetNo);
  }
  If Tv[30]=0 then Tv[30] :=100;
  If Tv[58]=0 then Tv[58] :=100;
  If Tv[75]=0 then Tv[75] :=100;
  Tv[29] :=0; i:=6;
  Repeat
   Tv[29] := Tv[29]+Tv[i];
   Inc(i,2);
  until i>28;
  Tv[31] := Tv[29] * Tv[30] /100;

 Tv[57] :=0; i:=34;
  Repeat
   Tv[57] := Tv[57]+Tv[i];
   Inc(i,2);
  until i>56;
  Tv[59] := Tv[57] * Tv[58] /100;

 Tv[74] :=0; i:=61;
  Repeat
   Tv[74] := Tv[74]+Tv[i];
   Inc(i,2);
  until i>73;
  Tv[76] := Tv[74] * Tv[75] /100;

 end;
 SaveTv(RetNo,FName,FNo);

end;

procedure PRIVAT(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure POLIT(RetNo:integer;FName:string;FNo:integer);
Var i:integer; PrvPolit:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   {
   PrvPolit:=TotMultiple(RetNo,'T5013INC',25);
   If Ret[RetNo].Province='ON' then Prv:=
   If Ret[RetNo]
   }
   {Fed}
   Tv[142]:=Ret[RetNo].T5013FedPol;
   I:=3;Tv[22]:=Tv[142]; //20090416
   Repeat Tv[22]:= Tv[22]+Tv[i];Inc(i,3);until i > 21;
   {Ont}
   I:=25;Tv[32]:=0;Repeat Tv[32]:= Tv[32]+Tv[i];Inc(i,3); until i > 31;
   {Alb}
   I:=35;Tv[42]:=0;Repeat Tv[42]:= Tv[42]+Tv[i];Inc(i,3); until i > 41;
   {pei}
   I:=45;Tv[52]:=0;Repeat Tv[52]:= Tv[52]+Tv[i];Inc(i,3); until i > 51;
   {nwt}
   I:=55;Tv[62]:=0;Repeat Tv[62]:= Tv[62]+Tv[i];Inc(i,3); until i > 61;
   {b.c}
   I:=65;Tv[72]:=0;Repeat Tv[72]:= Tv[72]+Tv[i];Inc(i,3); until i > 71;
   {n.s}
   I:=75;Tv[82]:=0;Repeat Tv[82]:= Tv[82]+Tv[i];Inc(i,3); until i > 81;
   {n.b}
   I:=85;Tv[92]:=0;Repeat Tv[92]:= Tv[92]+Tv[i];Inc(i,3); until i > 91;
   {man}
   I:=95;Tv[102]:=0;Repeat Tv[102]:= Tv[102]+Tv[i];Inc(i,3); until i > 101;
   {sask}
   I:=105;Tv[112]:=0;Repeat Tv[112]:= Tv[112]+Tv[i];Inc(i,3); until i > 111;
   {yuk}
   I:=115;Tv[122]:=0;Repeat Tv[122]:= Tv[122]+Tv[i];Inc(i,3); until i > 121;
   {NU}
   I:=126;Tv[130]:=0;Repeat Tv[130]:= Tv[130]+Tv[i];Inc(i,3); until i > 121;
   {SK}
   I:=133;Tv[140]:=0;Repeat Tv[140]:= Tv[140]+Tv[i];Inc(i,3); until i > 139;
   {sumit up}
   Tv[123] :=Tv[22];
   i := 32;
   Repeat
    Tv[123] := Tv[123] +Tv[i];
    Inc(i,10);
   until i>122;
   Tv[123] := Tv[123]+Tv[130];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


(*
Procedure T1013(RetNo:integer;FName:string;FNo:integer);
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin

    If Strings[17]='' then Strings[17] :=OptRec.Prp_Name;
    If Strings[18]='' then Strings[18] := OptRec.Prp_Area;
    If Strings[19]='' then Strings[19] := OptRec.Prp_Tel;

    //If UpperCase(Strings[5])='Y' then Strings[27] := OptRec.Prp_RepId;
   // If UpperCase(Strings[37])='Y' then Strings[28] := OptRec.Prp_BusNo;
    If (Strings[27]>'') and (Strings[28]>'') then Strings[28]:='';

    If OptRec.Prp_Fax>'' then
    begin
      If Strings[24]='' then Strings[24] := OptRec.Prp_FxArea;
      If Strings[25]='' then Strings[25] := OptRec.Prp_Fax;
    end;

    {
    If Strings[101]>'' then
    begin
      If Strings[103]='' then Strings[103]:=GetT1013Level;
    end;
    }
    If Strings[101]='' then strings[103]:='';
    //If Strings[133] = '' then Strings[133] :=  UpperCase(GetFirstName(RetNo)+' '+GetLastName(RetNo));
    If Strings[131] = '' then Strings[131] :=  FormatDateTime('yyyy-mm-dd',Date);
   end;
   SaveTv(RetNo,FName,FNo);
End;
*)

Procedure T1013(RetNo:integer;FName:string;FNo:integer);
var i:integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin
    //Strings[12]:=GetTrustAccount(RetNo); //Strings[41]:=GetTrustName(RetNo);

    //part 2
     If (Strings[27]>'') and (Strings[28]>'') then Strings[28]:='';
    If (Strings[8]>'') and (Strings[28]>'') then Strings[28]:='';

   (*
    //part 3
    If Strings[17]='' then Strings[17] :=OptRec.Prp_Name;
    If Strings[18]='' then Strings[18] := OptRec.Prp_Area;
    If Strings[19]='' then Strings[19] := OptRec.Prp_Tel;
    If OptRec.Prp_Fax>'' then
    begin
      If Strings[24]='' then Strings[24] := OptRec.Prp_FxArea;
      If Strings[25]='' then Strings[25] := OptRec.Prp_Fax;
    end;
   *)
    if Strings[8]+Strings[27]+Strings[28]+Strings[32] > '' then
    begin
     Strings[15]:='';
     Strings[22]:='';

     Strings[17]:='';
     Strings[18]:='';
     Strings[19]:='';
     Strings[24]:='';
     Strings[25]:='';

     Strings[101]:='';
     Strings[103]:='';

     Strings[132]:='';
     for i:=105 to 124 do
        Strings[i]:='';
     Strings[130]:='';
    end;

    //Part 5
    if Strings[14] > '' then
        begin Strings[1] := ''; Strings[31] := ''; Strings[2] := ''; Strings[6] := ''; Strings[10] :=  ''; Strings[7] := ''; end;

    //Part 6
    If Strings[131] = '' then
        Strings[131] :=  FormatDateTime('yyyy-mm-dd',Date);

   end;
   SaveTv(RetNo,FName,FNo);
End;


Procedure T3SUM(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
  begin
   Strings[1] := GetRetName(RetNo);

   Strings[3] := FetchElm(RetNo,'T3',3) +' '+FetchElm(RetNo,'T3',53);  //20220215
   Strings[14]:= FetchElm(RetNo,'T3',4);
   Strings[17] := FetchElm(RetNo,'T3',7)+', '+FetchElm(RetNo,'T3',67)
                +', '+FetchElm(RetNo,'T3',8)+'  '+FetchElm(RetNo,'T3',23);  //20210324

   Strings[2] := GetT3AccountNumber(RetNo);
   Strings[4] := FetchElm(RetNo,'T3',5);
   Strings[5] := FetchElm(RetNo,'T3',6);

   Strings[9] := FetchElm(RetNo,'T3',14);
   Strings[12] := FetchElm(RetNo,'T3',17);
   Strings[15] := IntToStr(CountResidentSlips(RetNo));
   Strings[38]:=FetchElm(RetNo,'T3',25);

  If Strings[36]+Strings[37]='' then Strings[37]:='X';
   {sign}
   If Strings[10] = '' then Strings[10] := FetchElm(RetNo,'T3',327);
   If Strings[13] ='' then Strings[13] := FetchElm(RetNo,'T3',335);
   If Strings[11] = '' then Strings[11] := FormatDateTime('yyyy-mm-dd',Now); //FetchElm(RetNo,'T3',339);

   With Ret[RetNo] do
    begin
     Tv[16] := T3BoxRes[21]+T3BoxPref[21];
     Tv[18] := T3BoxRes[23]+T3BoxPref[23];
     Tv[21] := T3BoxRes[26]+T3BoxPref[26];
     Tv[22] := T3BoxRes[30]+T3BoxPref[30];
     Tv[24] := T3BoxRes[32]+T3BoxPref[32];
     Tv[19] := T3BoxRes[49]+T3BoxPref[49];
     Tv[10] := T3BoxRes[50]+T3BoxPref[50];
     Tv[20] := T3BoxRes[51]+T3BoxPref[51];
     Tv[33] := T3BoxRes[39]+T3BoxPref[39];
    end;
  end;
 SaveTv (RetNo, Fname, FNo);
end;

Procedure S1SUPPL(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
     {Shares}
     i := 4;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,7);
     until i > 67;

     Tv[71] :=0;Tv[72] :=0;
     i := 4;
     repeat
     Tv[71] := Tv[71]+Tv[i];
     Tv[72] := Tv[72]+Tv[i+3];
     inc(i,7);
     until i > 67;
     {real estate}
     i := 75;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,6);
     until i > 87;

     Tv[91] :=0;Tv[92] :=0;
     i :=75;
     repeat
     Tv[91] := Tv[91]+Tv[i];
     Tv[92] := Tv[92]+Tv[i+3];
     inc(i,6);
     until i > 87;

     {Bonds}
     i := 97;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,8);
     until i > 121;

     Tv[125] :=0;Tv[126] :=0;
     i :=97;
     repeat
     Tv[125] := Tv[125]+Tv[i];
     Tv[126] := Tv[126]+Tv[i+3];
     inc(i,8);
     until i > 121;
 end;
 SaveTv(RetNo,FName,FNo);
end;

(*
Procedure S1SUPL2(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo] do
   begin
     {Shares}
     i := 4;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,7);
     until i > 67;

     Tv[71] :=0;Tv[72] :=0;
     i := 4;
     repeat
     Tv[71] := Tv[71]+Tv[i];
     Tv[72] := Tv[72]+Tv[i+3];
     inc(i,7);
     until i > 67;
     {real estate}
     i := 75;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,6);
     until i > 87;

     Tv[91] :=0;Tv[92] :=0;
     i :=75;
     repeat
     Tv[91] := Tv[91]+Tv[i];
     Tv[92] := Tv[92]+Tv[i+3];
     inc(i,6);
     until i > 87;

     {Bonds}
     i := 97;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,8);
     until i > 121;

     Tv[125] :=0;Tv[126] :=0;
     i :=97;
     repeat
     Tv[125] := Tv[125]+Tv[i];
     Tv[126] := Tv[126]+Tv[i+3];
     inc(i,8);
     until i > 121;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure S1SUPL3(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo] do
   begin
     {Shares}
     i := 4;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,7);
     until i > 67;

     Tv[71] :=0;Tv[72] :=0;
     i := 4;
     repeat
     Tv[71] := Tv[71]+Tv[i];
     Tv[72] := Tv[72]+Tv[i+3];
     inc(i,7);
     until i > 67;
     {real estate}
     i := 75;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,6);
     until i > 87;

     Tv[91] :=0;Tv[92] :=0;
     i :=75;
     repeat
     Tv[91] := Tv[91]+Tv[i];
     Tv[92] := Tv[92]+Tv[i+3];
     inc(i,6);
     until i > 87;

     {Bonds}
     i := 97;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,8);
     until i > 121;

     Tv[125] :=0;Tv[126] :=0;
     i :=97;
     repeat
     Tv[125] := Tv[125]+Tv[i];
     Tv[126] := Tv[126]+Tv[i+3];
     inc(i,8);
     until i > 121;
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)



Procedure S1SPLBG(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
 {Load the numeric fields of a form into the Temporary Variables array}
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
     {Shares}
     i := 4;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,7);
     until i > 67;

     Tv[71] :=0;Tv[72] :=0;
     i := 4;
     repeat
     Tv[71] := Tv[71]+Tv[i];
     Tv[72] := Tv[72]+Tv[i+3];
     inc(i,7);
     until i > 67;
     {real estate}
     i := 75;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,6);
     until i > 87;

     Tv[91] :=0;Tv[92] :=0;
     i :=75;
     repeat
     Tv[91] := Tv[91]+Tv[i];
     Tv[92] := Tv[92]+Tv[i+3];
     inc(i,6);
     until i > 87;

     {Bonds}
     i := 97;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,8);
     until i > 121;

     Tv[125] :=0;Tv[126] :=0;
     i :=97;
     repeat
     Tv[125] := Tv[125]+Tv[i];
     Tv[126] := Tv[126]+Tv[i+3];
     inc(i,8);
     until i > 121;

     {mortages}
     i := 129;
     repeat
     Tv[i+3] := Tv[i] - Tv[i+1]-Tv[i+2];
     inc(i,6);
     until i > 135;

     Tv[139] :=0;Tv[140] :=0;
     i :=129;
     repeat
     Tv[139] := Tv[139]+Tv[i];
     Tv[140] := Tv[140]+Tv[i+3];
     inc(i,6);
     until i > 135;
 end;
 {save data}
 SaveTv(RetNo,FName,FNo);
end;

Procedure INVSTM(RetNo:integer;FName:string;FNo:integer);
var i: integer;  FInst:String;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
   FInst:=ExtractFormInst(FName);

   For i :=58 to 67 do Tv[i] :=0;
   For i :=83 to 84 do Tv[i] :=0;

   If Finst='#1' then   //20110427
   begin
    Tv[85]:=Ret[RetNo].T5Dividends+Ret[RetNo].T3Dividends+T5013ActDiv;
    Tv[87]:=Ret[RetNo].T5DividendsEligible+Ret[RetNo].T3DividendsEligible+T5013ActDivEligible;
    Tv[89]:=Ret[RetNo].T5Interest+Ret[RetNo].T3OthInc+Ret[RetNo].T5013Interest;
   end
   Else
   begin
    Tv[85]:=0;
    Tv[87]:=0;
    Tv[89]:=0;
   end;
   i:=2;
   Repeat  {div non-elig}
    Tv[58] := Tv[58]+Tv[i];
    Tv[59] := Tv[59]+Tv[i+1];
    Inc(i,3);
   until i>14;
   Tv[58]:=Tv[58]+Tv[85];
   Tv[59]:=Tv[59]+Tv[86];

   i:=69;
   Repeat  {div elig}
    Tv[83] := Tv[83]+Tv[i];
    Tv[84] := Tv[84]+Tv[i+1];
    Inc(i,3);
   until i>81;
   Tv[83]:=Tv[83]+Tv[87];
   Tv[84]:=Tv[84]+Tv[88];

   i:=17;
   Repeat  {Int-bonds}
    Tv[60] := Tv[60]+Tv[i];
    Tv[61] := Tv[61]+Tv[i+1];
    Inc(i,3);
   until i>29;
   Tv[60]:=Tv[60]+Tv[89];
   Tv[61]:=Tv[61]+Tv[90];

   i:=32;   {int oth depos}
   Repeat
    Tv[62] := Tv[62]+Tv[i];
    Tv[63] := Tv[63]+Tv[i+1];
    Inc(i,3);
   until i>38;

   i:=41; {mortg}
   Repeat
    Tv[64] := Tv[64]+Tv[i];
    Tv[65] := Tv[65]+Tv[i+1];
    Inc(i,3);
   until i>47;

   i:=50; {oth inv}
   Repeat
    Tv[66] := Tv[66]+Tv[i];
    Tv[67] := Tv[67]+Tv[i+1];
    Inc(i,3);
   until i>56;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure FINVSTM(RetNo:integer;FName:string;FNo:integer);
var i,TotNdx: integer;
Begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[FNo] do
 begin
  For i:=91 to 96 do Tv[i] :=0;
  Tv[97]:=Ret[RetNo].T5FNonBusInc1+Ret[RetNo].T5013FNonBusInc1;
  Tv[98]:=Ret[RetNo].T5FNonBusTax1+Ret[RetNo].T5013FNonBusTax1;
  Strings[99]:='1';

  Tv[100]:=Ret[RetNo].T5FNonBusInc2+Ret[RetNo].T5013FNonBusInc2;
  Tv[101]:=Ret[RetNo].T5FNonBusTax2+Ret[RetNo].T5013FNonBusTax2;
  Strings[102]:='2';

  Tv[103]:=Ret[RetNo].T5FNonBusInc3+Ret[RetNo].T5013FNonBusInc3;
  Tv[104]:=Ret[RetNo].T5FNonBusTax3+Ret[RetNo].T5013FNonBusTax3;
  Strings[105]:='3';


  Tv[106]:=Ret[RetNo].T3FNonBusInc1;
  Tv[107]:=Ret[RetNo].T3FNonBusTax1;
  Strings[108]:='1';

  Tv[109]:=Ret[RetNo].T3FNonBusInc2;
  Tv[110]:=Ret[RetNo].T3FNonBusTax2;
  Strings[111]:='2';

  Tv[112]:=Ret[RetNo].T3FNonBusInc3;
  Tv[113]:=Ret[RetNo].T3FNonBusTax3;
  Strings[114]:='3';

  Tv[44]:=0;Tv[45]:=0;
  Tv[86]:=0;Tv[87]:=0;

  Strings[88] := Strings[1];
  Strings[89] := Strings[2];
  Strings[90] := Strings[3];

  {foreign interest}
  i:=5;TotNdx:=91;
  Repeat
   Tv[44] := Tv[44] + Tv[i];
   Tv[45] := Tv[45] + Tv[i+1];
   If (Strings[i+2] <'2') or (Strings[i+2] > '3') then
     begin
     Tv[TotNdx] := Tv[TotNdx]+Tv[i];
     Tv[TotNdx+3] := Tv[TotNdx+3]+Tv[i+1];
     end

   else If Strings[i+2] ='2' then
     begin
     Tv[TotNdx+1] := Tv[TotNdx+1]+Tv[i];
     Tv[TotNdx+3+1] := Tv[TotNdx+3+1]+Tv[i+1];
     end

   else If Strings[i+2] ='3' then
     begin
     Tv[TotNdx+2] := Tv[TotNdx+2]+Tv[i];
     Tv[TotNdx+3+2] := Tv[TotNdx+3+2]+Tv[i+1];
     end;
  Inc(i,4);
  until i>41;
  Tv[44]:=Tv[44]+Tv[97]+Tv[100]+Tv[103];
  Tv[45]:=Tv[45]+Tv[98]+Tv[101]+Tv[104];


  {other foreign investm}
  i:=47;TotNdx:=91;
  Repeat
   Tv[86] := Tv[86] + Tv[i];
   Tv[87] := Tv[87] + Tv[i+1];
   If (Strings[i+2] <'2') or (Strings[i+2] > '3') then
     begin
     Tv[TotNdx] := Tv[TotNdx]+Tv[i];
     Tv[TotNdx+3] := Tv[TotNdx+3]+Tv[i+1];
     end

   else If Strings[i+2] ='2' then
      begin
     Tv[TotNdx+1] := Tv[TotNdx+1]+Tv[i];
     Tv[TotNdx+3+1] := Tv[TotNdx+3+1]+Tv[i+1];
     end

   else If Strings[i+2] ='3' then
     begin
     Tv[TotNdx+2] := Tv[TotNdx+2]+Tv[i];
     Tv[TotNdx+3+2] := Tv[TotNdx+3+2]+Tv[i+1];
     end;
  Inc(i,4);
  until i>83;
  Tv[86]:=Tv[86]+Tv[106]+Tv[109]+Tv[112];
  Tv[87]:=Tv[87]+Tv[107]+Tv[110]+Tv[113];
  //totals
  Tv[91]:=Tv[91]+Tv[97]+Tv[106];
  Tv[94] :=Tv[94]+Tv[98]+Tv[107];

  Tv[92]:=Tv[92]+Tv[100]+Tv[109];
  Tv[95] :=Tv[95]+Tv[101]+Tv[110];

  Tv[93]:=Tv[93]+Tv[103]+Tv[112];
  Tv[96] :=Tv[96]+Tv[104]+Tv[113];

 end;
 {save data}
 SaveTv(RetNo,FName,FNo);

end;


Procedure AVLBLE(RetNo:integer;FName:string;FNo:integer);
//picks up from various schedules
Var i,k:Integer;TotGains,TotEligible:Real;InclRate:Real;T3FNo:Integer;
begin
 T3Fno:=GetFormNo('T3');
 InclRate := FetchInclusionRate(RetNo);
 If InclRate=0 then InclRate:=1;
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   Tv[1] := MaxR(0,Vl(FetchElm(RetNo,'T3',101)));

   Tv[4] := Vl(FetchElm(RetNo,'S7',20));    {lump sum}
   Tv[7] := Vl(FetchElm(RetNo,'T3',140))+Vl(FetchElm(RetNo,'T3',77));  //20150101 {actual non elig div}
   Tv[19] := Vl(FetchElm(RetNo,'T3',103))
            -Vl(FetchElm(RetNo,'T3',140))
            -Vl(FetchElm(RetNo,'T3',77))  //20150117  (in 2013}
            ;  {actual elig div}

   //20090413
   Tv[10]:=Ret[RetNo].T3FBusInc1+Ret[RetNo].T3FBusInc2+Ret[RetNo].T3FBusInc3
       +Ret[RetNo].T5013FBusInc1+Ret[RetNo].T5013FBusInc2+Ret[RetNo].T5013FBusInc3;

   Tv[13] := Vl(FetchElm(RetNo,'S8',5));   {foreign non bus}

   {other income}
   //If UpperCase(Frm[FNo].Strings[44]) <>'Y' then Tv[16]:=OthIncForAllocation(RetNo); //20220326

  Tv[50]:= vl(FetchElmFNo(RetNo,T3FNo,107));  //T2125
  Tv[54]:=Vl(FetchElmFNo(RetNo,T3FNo,109));  //Farm Fis
  Tv[55]:=Vl(FetchElmFNo(RetNo,T3FNo,113));  //Rental
  Tv[44]:=Vl(FetchElmFNo(RetNo,T3FNo,124));  //Othinc in T3
  Tv[72]:=Vl(FetchElm(RetNo,'T3',105))+Vl(FetchElm(RetNo,'T3',114)); //oth invstm and Agri //20220329
  Tv[70]:=Tv[50]+Tv[54]+Tv[55]+Tv[44] +Tv[65]+Tv[67]+Tv[69]+Tv[72];  //20220329

  Tv[16]:=Tv[70];


  // Tv[16]:=Vl(FetchElm(RetNo,'T3',123));  //20220322

   //tot incme before allocations minus other categoties
  // Tv[16] := MaxR(0,Vl(FetchElm(RetNo,'T3',252)))-Tv[1]-Tv[4]-Tv[7]-Tv[10]-Tv[13]-Tv[19];
            // + Vl(FetchElm(RetNo,'T3',251)) //taxable benefits
            // - Vl(FetchElm(RetNo,'T3',243)); //20220305 //other deductions

   {
   Tv[16] := MaxR(0,Vl(FetchElm(RetNo,'T3',126))   //tot incme
             - MaxR(0,Tv[1])-MaxR(0,Tv[4])-MaxR(0,tv[7])-MaxR(0,tv[10])
              -MaxR(0,tv[13])
              -MaxR(0,tv[19])
             + Vl(FetchElm(RetNo,'T3',251)) //taxable benefits
             - Vl(FetchElm(RetNo,'T3',243))); //20220305 //other deductions

    If UpperCase(FetchElm(RetNo,'T1055',37)) <> 'Y' then Tv[16]:=MaxR(0,Tv[16]-Vl(FetchElm(RetNo,'T3',116)));  //exclude deemed realizations
   }

   { //20220320  in T3-2020
   Tv[16] := MaxR(0,Vl(FetchElm(RetNo,'T3',126))
             - MaxR(0,Tv[1])-MaxR(0,Tv[4])-MaxR(0,tv[7])-MaxR(0,tv[10])
              -MaxR(0,tv[13])
              -MaxR(0,tv[19])
             + Vl(FetchElm(RetNo,'T3',251)) //
             - Vl(FetchElm(RetNo,'T3',243))); //20220305

    If UpperCase(FetchElm(RetNo,'T1055',37)) <> 'Y' then
      Tv[16]:=MaxR(0,Tv[16]-Vl(FetchElm(RetNo,'T3',116)));  //exclude deemed realizations
    }
    //20090313
    {Get Net}
    Tv[3] := MaxR(0,Tv[1] - Tv[2]-Tv[57]);   //20
    Tv[6] := MaxR(0,Tv[4] - Tv[5]-Tv[58]);
    Tv[9] := MaxR(0,Tv[7] - Tv[8]-Tv[59]);
    Tv[12] := MaxR(0,Tv[10] - Tv[11]-Tv[60]);
    Tv[15] := MaxR(0,Tv[13] - Tv[14]-Tv[61]);
    Tv[18] := MaxR(0,Tv[16] - Tv[17]-Tv[62]);
    Tv[21] := MaxR(0,Tv[19] - Tv[20]-Tv[63]);
    i:=1;
    k:=57;
    Tv[45]:=0;Tv[46]:=0;Tv[47] :=0;Tv[64]:=0;
    Repeat
     Tv[45] := Tv[45]+MaxR(0,Tv[i]);
     Tv[46] := Tv[46]+Tv[i+1];
     Tv[64] := Tv[64]+Tv[k];
     Tv[47] := Tv[47]+Tv[i+2];
     Inc(i,3);
     Inc(k,1);
    until i>19;

  If UpperCase(Frm[FNo].Strings[48]) <> 'Y' then
  begin
   {Other amounts}
   Tv[31] := (Vl(FetchElm(RetNo,'S1',118))
             +Vl(FetchElm(RetNo,'S1',112)))*(50/100); { 29}
   Tv[43] := (Vl(FetchElm(RetNo,'S1',119))+Vl(FetchElm(RetNo,'S1',126)))*(50/100); { -30}
   Tv[22] := Vl(FetchElm(RetNo,'S3',46)); {29 + 30 for box 30 of the slip -cap gains elgble}
   Tv[23] := Vl(FetchElm(RetNo,'S7',22)); {31 Eligbl pension}

   Tv[24] := Tv[9] * 1.15; //20191218 1.16; //1.18; //20190225       {32 txbl dividends}
  // Tv[24] := Tv[9] * 1.17; //1.18; //20170125 //Tv[9] * 1.25;               {32 txbl dividends}

   Tv[29]:=  Tv[21] * 1.38; //   //20120324
   Tv[25] := Ret[RetNo].T3FBusTax1+Ret[RetNo].T3FBusTax2+Ret[RetNo].T3FBusTax3
      +Ret[RetNo].T5013FBusTax1+Ret[RetNo].T5013FBusTax2+Ret[RetNo].T5013FBusTax3;
    //33 foreign bus inc tax
   Tv[26] := Vl(FetchElm(RetNo,'FINVSTM',94))+  {34 foreign non bus tax}
             Vl(FetchElm(RetNo,'FINVSTM',95))+
             Vl(FetchElm(RetNo,'FINVSTM',96));  {34 foreign non bus tax}
   Tv[37] := Vl(FetchElm(RetNo,'S7',23)); {36-1 miscellaneous-60(i)}
   If TrustType <> IvCommunal then Tv[38] :=0;
   Tv[33] := Vl(FetchElm(RetNo,'S10',20));{38 part XII.2 credit}

   Tv[34] := Tv[24] * 9.0301/100; //20191218 10.0313/100; //20170125 11.017/100;

   Tv[35] := MaxR(0,vl(FetchElm(RetNo,'T2038',3))
            +vl(FetchElm(RetNo,'T2038',7))
            +vl(FetchElm(RetNo,'T2038',32))
            +vl(FetchElm(RetNo,'T2038',11))
            +vl(FetchElm(RetNo,'T2038',14))
            +vl(FetchElm(RetNo,'T2038',18)));
          //  -Vl(FetchElm(RetNo,'S9',74))); {40 ITC}
   Tv[36] :=MaxR(0,vl(FetchElm(RetNo,'T2038',142)));
           // -Vl(FetchElm(RetNo,'S9',78)));   {41 ITC credit}

    Tv[29] := Tv[21] * 1.38;  //20120324             {49 txbl dividends eligible}
   If Ry=0 then     //20110328
    Tv[30] := Tv[29] * 15.02/100  //20120324 17.9739/100  //18.9655/100          {51 Fed div tax credit}
   else
    Tv[30] := Tv[29] * 15.02/100; //20120324 17.9739/100;  //18.9655/100; //???          {51 Fed div tax credit}

//   Tv[65]:=Vl(FetchElm(RetNo,'T3',77));  //20150117   //20160207
   {footnotes ?}
    {Box 21}
    Tv[49]:=Tv[3]; { MaxR(0,Tv[59]);}

   {QFP}
    TV[51]:= Vl(FetchElm(RetNo,'S1',114))* InclRate;  //qfp
    TV[53]:= Vl(FetchElm(RetNo,'S1',106))* InclRate;  //QSB  //20210326
  end;
   {save amounts to avlble array etc}
   AvlbleAlloc[21] := Tv[3];
   AvlbleAlloc[22] := Tv[6];
   AvlbleAlloc[23] := Tv[9];
   AvlbleAlloc[24] := Tv[12];
   AvlbleAlloc[25] := Tv[15];
   AvlbleAlloc[26] := Tv[18];

   AvlbleAlloc29 := Tv[31];
   AvlbleAlloc30 := Tv[43];
   AvlbleAlloc[30] := Tv[22];
   AvlbleAlloc[31] := Tv[23];
   AvlbleAlloc[32] := Tv[24];
   AvlbleAlloc[33] := Tv[25];
   AvlbleAlloc[34] := Tv[26];
   AvlbleAlloc[35] := Tv[27];
   Avlble_36Xfer     := Tv[28];
   Avlble_36RetAllow := Tv[29];
   Avlble_36Don      := Tv[30];
   AvlbleAlloc[36]   := Tv[31];
   AvlbleAlloc[37] := Tv[32];
   AvlbleAlloc[38] := Tv[33];
   AvlbleAlloc[39] := Tv[34];
   AvlbleAlloc[40] := Tv[35];
   AvlbleAlloc[41] := Tv[36];
   AvlbleAlloc[42]    := Tv[28];
   AvlbleAlloc[45]    := Tv[39];
   AvlbleAlloc[46]    := Tv[37];
   AvlbleAlloc[47]    := Tv[52];
   AvlbleAlloc[48]    := Tv[38];

   AvlbleAlloc[49]    := Tv[21];
   AvlbleAlloc[50]    := Tv[29];
   AvlbleAlloc[51]    := Tv[30];

//   AvlbleAlloc[52]    := Tv[65];  //20150117  //20160207
   {footnotes}
   AvlbleFoot[1]   := Tv[40];
   AvlbleFoot[2]   := Tv[41];
   AvlbleFoot[3]   := Tv[42];
   AvlbleFoot[4]   := Tv[43];
   AvlbleFoot[5]   := Tv[44];
   AvlbleFoot[6]:= Tv[37];
   AvlbleFoot[7]:= Tv[38];
   AvlbleFoot[8]:= Tv[49];

   TotEligible := Vl(FetchElm(RetNo,'S1',114))
                + Vl(FetchElm(RetNo,'S1',106));

   AvlbleFootQFP1 := 0;
   AvlbleFootQFP2 := 0;
   AvlbleFootQfp3 := 0;

   AvlbleFootQsb1 := 0;
   AvlbleFootQsb2 := 0;
   AvlbleFootQsb3 := 0;

   If TotEligible <> 0 then
   begin
     AvlbleFootQFP3 := Tv[22] * (Tv[51]/TotEligible)/InclRate;
     AvlbleFootQsb3 := Tv[22] * (Tv[53]/TotEligible)/InclRate;
   end;
 end;
 SaveTv (RetNo, Fname, FNo);
end;

Procedure InvForms(RetNo:integer;FName:string;FNo:integer);
Var i,j,PagesCharged:integer; Frms,HowMany:TstringList;
begin
// UpdateAllDataIndicators(RetNo);
 LoadTv(RetNo,FName,FNo);
 Frms := TStringList.Create;
 HowMany := TStringList.Create;
 with Ret[RetNo].Frm[Fno] do
 begin
  PagesCharged :=0;
  Strings[1] := GetRetName(RetNo);
  Strings[2] := GetTrustYear(RetNo);
  Strings[2] :=AppYear;
  Strings[3] :=IntToStr(CountPagesGenerated(RetNo));
  Tv[3] := GetTotalFee(RetNo);
  GetListInvoiceForms(RetNo,Frms,HowMany);
  Tv[5]:=0;
  j := 7;
  For i:=0 to Frms.Count-1 do
  begin
    Inc(PagesCharged,MyStrToInt(HowMany[i]));
    Strings[j]   := PaddR(HowMany[i],5)+Frms[i];
    Tv[j+1] := GetFormFee(Frms[i],MyStrToInt(HowMany[i]));
    Tv[5]:=Tv[5]+Tv[j+1];
    Inc(j,2);
    If J>130 then break;
  end;
  Strings[4] := IntToStr(PagesCharged);
 end;
 Frms.Free;HowMany.Free;
 SaveTv(RetNo,FName,FNo);
end;


Procedure Invoice(RetNo:integer;FName:string;FNo:integer);
Var i,j,PagesCharged:integer; Frms,HowMany:TstringList;
begin
// UpdateAllDataIndicators(RetNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
    Strings[201] := OptRec.PRp_Name;
    Strings[202] := OptRec.PRp_Street;
    Strings[204] := OptRec.PRp_City+', '+OptRec.PRp_Prov;
    Strings[205] := OptRec.PRp_Postal;
    Strings[207] := OptRec.PRp_Area+' '+OptRec.PRp_Tel;
    Strings[208] := OptRec.PRp_GSTNo;
    If strings[203] = '' then Strings[203] := DateToMonthDayYear(Date);
    If Strings[223]+Strings[224]+strings[225] >'' then
    begin
        If Strings[209] = '' then Strings[209] := DateToStr(Date);
    end
    else
        Strings[209] := '';

    If Strings[210]='' then Strings[210] := 'T'+GetT3AccountNumber(RetNo)
                                          +'-'+GetTrustYear(RetNo);
    Strings[211] := GetRetName(RetNo);
    If IsT3Return(RetNo) then
    Begin
        Strings[212] := Rtrim(FetchElm(RetNo,'T3',4));
        Strings[215] := Rtrim(FetchElm(RetNo,'T3',7))+', '+
                        Rtrim(FetchElm(RetNo,'T3',8));
        If Strings[216]='' then Strings[216] := 'Preparation of '+GetTrustYear(RetNo)+ ' Trust return';
    End;


    If Strings[251]+Strings[249]+Strings[244]+Strings[245]+Strings[246]+
         Strings[247]+Strings[248]+Strings[252] ='' then
    begin
         Case MyStrToInt(OptRec.Prp_Bill) of
          0: Strings[251] :='X';
          1: Strings[249] :='X';
          2: begin Strings[252] :='X';Strings[250] := '30';end;
          3: Strings[246] :='X';
         end;
    end;

    If Strings[244]>'' then Tv[217] := OptRec.Prp_VSFee else Tv[207] :=0;
    If Strings[245]>'' then Tv[217] := OptRec.Prp_SFee else Tv[206]:=0;
    If Strings[246]>'' then Tv[217] := OptRec.Prp_AFee else tv[208] :=0;
    If Strings[247]>'' then Tv[217] := OptRec.Prp_CFee else Tv[209]:=0;
    If Strings[248]>'' then Tv[217]:= OptRec.Prp_VCFee else Tv[210]:=0;
    If Strings[249]>'' then Tv[217]:= GetTotalFee(RetNo);
    If Strings[252]>'' then Tv[217]:= Vl(Strings[250]) * OptRec.Prp_Hour/60;

    Tv[219] := Tv[217] + Tv[218]+Tv[234] + Tv[235]+Tv[236] + Tv[237]+Tv[238] + Tv[239]+
                Tv[242] + Tv[243];
    If Strings[208] = '' then
        Strings[220] := ''
    else
        Strings[220] :=FormatFloat('###.##',OptRec.Opr_GstHst);
    Tv[221] := Tv[219] * Vl(Strings[220]) / 100;
    Tv[222] := Tv[219] + Tv[221];
    Strings[226] := User.Prep_Name;

    //footnotes
    With OptRec do
    begin
        Strings[253]:=InvFoot1;
        Strings[254]:=InvFoot2;
        Strings[255]:=InvFoot3;
        Strings[256]:=InvFoot4;
        Strings[257]:=InvFoot5;
    end;
 end; //end with

 SaveTv(RetNo,FName,FNo);

end;


Procedure T3Supl(RetNo:integer;FName:string;FNo:integer);
Var i,j,NumSlips,ResidentSlips,elm:Integer;
  PercentAlloc,PercentDividendsAlloc : real; Tp:string[1];
   InclRate:Real;
begin
 LoadTv (RetNo, Fname, FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   InclRate := FetchInclusionRate(RetNo);
   If InclRate =0 then InclRate :=1;
   Strings[1] := Strings[46];
   If Strings[41]='' then strings[41] :='Y';
   If Strings[66]='' then Strings[66]:='CAN';  //20110521
   If (UpperCase(Strings[44]) <> 'Y') and
      (strings[45] <> 'Y') then strings[43] :='Y';

   If (UpperCase(Strings[44]) <> 'Y') and
      (strings[45] = '') then strings[43] :='Y';

   If (UpperCase(Strings[44]) = 'Y') or
      (strings[45] <> '') then strings[43] :='';


    If (UpperCase(strings[41]) = 'Y') then {resident}
         Tp := 'R'
    else
         Tp := 'N';  {non resident}

    If UpperCase(Strings[42]) = 'Y' then
         Tp := 'P';  {preferred}

   If Strings[3] = '' then Strings[3] := 'O';  //'0';
   If Strings[4] = '' then Strings[4] := '1';
   Strings[2] := GetT3AccountNumber(RetNo);
   Strings[38] := GetRetName(RetNo);
   Strings[39] := LeftStr(GetYearEnd(RetNo),4);
   Strings[40] := MidStr(GetYearEnd(RetNo),6,2);


    {Now calculate amounts}
   If (UpperCase(Strings[44])= 'Y') then //manual allocation
    begin
     //20140318
     Tv[55]:=Tv[56] * 1.38;
     Tv[54]:=Tv[55] * 15.0198/100; //15.02/100;  //20170125
     Tv[14]:=Tv[7] * 1.15; //1.16;   //20190225  //20191218
     Tv[21]:=Tv[7] * 10.384/100; //10.0313/100; //20191218    //Tv[21]:=Tv[14] * 10.384/100; //10.0313/100; //20191218

     //20150419
     If Strings[4]='3' then  //if corp not taxable  //20150419
     begin
      Tv[55]:=0;
      Tv[54]:=0;
      Tv[14]:=0;
      Tv[21]:=0;
     end;

     SaveTv(RetNo, Fname, FNo);
     exit;
    end;


   If (Strings[1] = '') then   {no sin}
    begin
      For j:=5 to 25 do Tv[j] :=0;
      For j:=54 to 56 do Tv[j] :=0;
      SaveTv(RetNo, Fname, FNo);exit;
    end;

   {autocalc or %}
   NumSlips:=CountAllT3Slips(RetNo);
   PercentAlloc:=0;
   if Strings[45] >'' then
     PercentAlloc := Vl(Strings[45])
   else if NumSlips>0 then
     PercentAlloc := 100/NumSlips;
  end;

  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
   Tv[56] := AvlbleAlloc[49] * PercentAlloc /100;
   Tv[55] := AvlbleAlloc[50] * PercentAlloc /100;
   If Frm[FNo].Strings[4]='3' then Tv[55]:=0;  //20120330
   Tv[54] := AvlbleAlloc[51] * PercentAlloc /100;
   If Frm[FNo].Strings[4]='3' then Tv[54]:=0;  //20120330
   Tv[5] := AvlbleAlloc[21]* (1/InclRate) * PercentAlloc /100;
   Tv[6] := AvlbleAlloc[22] * PercentAlloc /100;
   Tv[7] := AvlbleAlloc[23] * PercentAlloc /100;
   Tv[8] := AvlbleAlloc[24] * PercentAlloc /100;
   Tv[9] := AvlbleAlloc[25] * PercentAlloc /100;

 //  AvlbleAlloc[26]:=Vl(FetchElm(RetNo,'T3',123));  //new 20220322
   Tv[10] := AvlbleAlloc[26] * PercentAlloc /100;

   Tv[58] := AvlbleAlloc29 * (1/InclRate) * PercentAlloc /100;
   Tv[59] := AvlbleAlloc30 * (1/InclRate) * PercentAlloc /100;
   Tv[12] := AvlbleAlloc[30] * (1/InclRate) * PercentAlloc /100;
   Tv[13] := AvlbleAlloc[31] * PercentAlloc /100;
   Tv[14] := AvlbleAlloc[32] * PercentAlloc /100;
   If Frm[FNo].Strings[4]='3' then Tv[14]:=0;  //20120330
   Tv[15] := AvlbleAlloc[33] * PercentAlloc /100;
   Tv[16] := AvlbleAlloc[34] * PercentAlloc /100;
   Tv[17] := AvlbleAlloc[35] * PercentAlloc /100;
   Tv[18] := AvlbleAlloc[36] * PercentAlloc /100;
   Tv[19] := AvlbleAlloc[37] * PercentAlloc /100;
   Tv[20] := AvlbleAlloc[38] * PercentAlloc /100;
   Tv[21] := AvlbleAlloc[39] * PercentAlloc /100;
   If Frm[FNo].Strings[4]='3' then Tv[21]:=0;  //20120330
   Tv[22] := AvlbleAlloc[40] * PercentAlloc /100;
   Tv[23] := AvlbleAlloc[41] * PercentAlloc /100;
   Tv[18] := AvlbleAlloc[45] * PercentAlloc /100;
   Tv[49] := AvlbleAlloc[42] * PercentAlloc /100;

   Tv[51] := AvlbleAlloc[46] * PercentAlloc /100;
   Tv[52] := AvlbleAlloc[47] * PercentAlloc /100;
   Tv[53] := AvlbleAlloc[48] * PercentAlloc /100;

 //  Tv[68] := AvlbleAlloc[52] * PercentAlloc /100;  //20150117  //non elig in 2013  //20160207

   If tp = 'N' then {non resident}
   begin
    Tv[13]:=0;Tv[14]:=0;Tv[20]:=0;Tv[21]:=0;
   end;

   If tp = 'P' then {preferred}
   begin
    Tv[13]:=0;Tv[17]:=0;Tv[18]:=0;Tv[19]:=0;Tv[20]:=0;
   end;

   {? footnotes}

  If Uppercase(Frm[FNo].Strings[41])<>'Y' then
  begin
   {FOOTNOTES}
   Tv[31]:=0;Tv[33]:=0;Tv[35]:=0;Tv[37]:=0;Tv[48]:=0;
   Frm[FNo].Strings[30]:='';
   Frm[FNo].Strings[32]:='';
   Frm[FNo].Strings[34]:='';
   Frm[FNo].Strings[36]:='';
   Frm[FNo].Strings[47]:='';

   Elm :=GetEmptyFootNoteElm(RetNo,FName);
   If (Ret[RetNo].AvlbleFoot[1] <> 0) and (Elm >0) then
   begin
    Frm[FNo].Strings[elm-1] := 'Box 21-Inc for FTC';
    Tv[Elm] := Ret[RetNo].AvlbleFoot[1] * PercentAlloc /100;
   end;

   Elm :=GetEmptyFootNoteElm(RetNo,FName);
   If (Ret[RetNo].AvlbleFoot[2] <> 0) and (Elm >0) then
   begin
    Frm[FNo].Strings[elm-1] := 'Box 26-ECP-QFP';
    Tv[Elm] := Ret[RetNo].AvlbleFoot[2] * PercentAlloc /100;
   end;

   Elm :=GetEmptyFootNoteElm(RetNo,FName);
   If (Ret[RetNo].AvlbleFoot[3] <> 0) and (Elm >0) then
   begin
    Frm[FNo].Strings[elm-1] := 'Box 26-Self-empl';
    Tv[Elm] := Ret[RetNo].AvlbleFoot[3] * PercentAlloc /100;
   end;
  end;
 end;
 SaveTv (RetNo, Fname, FNo);
end;

Function GetEmptyFootnoteElm(RetNo:Integer;FName:String):Integer;
var FNo: integer;
begin
 Result :=0;
 FNo := GetFormNo(FName);
 with Ret[RetNo].Frm[FNo] do
 begin
   If Tv[31] =0 then begin Result :=31;exit;end;
   If Tv[33] =0 then begin Result :=33;exit;end;
   If Tv[35] =0 then begin Result :=35;exit;end;
   If Tv[37] =0 then begin Result :=37;exit;end;
   If Tv[48] =0 then begin Result :=48;exit;end;
 end;
end;

Procedure PRBNFR(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
begin
 If FetchElmFno(RetNo,FNo,10) ='' then
 begin
  For i:=1 to 9 do StoreElm(RetNo,FNo,i,'');
  Exit;
 end;
 CreatePrBnfr(RetNo);
end;

Procedure CreatePrBnfr(RetNo:Integer);
Var i,Cnt,FNo,PrfFNo:integer;BnfAlloc: Real; PrfFName :string[12];
begin
  (*
  {it abends}
  {Delete existing prBnfr}
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo :=GetFormNo(Frec.FormName+Frec.FormInst);
    If (FRec.FormName = 'PRBNFR') and
     (FRec.FormInst <> '#1') and
     (FNo > 0)
     then
     ClearForm(RetNo,Frec.FormName+Frec.FormInst);
  end;
  *)
  {create new}
  Cnt :=0;
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo := Frec.FormNo;
    If (FRec.FormName = 'T3SUPL') and
       (Ret[RetNo].FrmHasData[FNo]) and
       (FetchElmFNo(RetNo,FNo,1) > '') and
       (UpperCase(FetchElmFNo(RetNo,FNo,42)) = 'Y')   {preferred}
    then
    begin
        Inc(Cnt);
        PrfFName := 'PRBNFR#'+IntToStr(Cnt);
        PrfFNo := GetFormNo(PrfFName);
        If (PrfFNo = 0) then
           begin
            AddPageInstance(RetNo,ExtractNonInstFormName(PrfFName),'#'+IntToStr(Cnt));
            PrfFNo := GetFormNo(PrfFName); {get it again}
           end;
        If Ret[RetNo].Frm[PrfFNo].Count =0 then
            InitFormData(RetNo,PrfFNo);
        {copy data from slip}
        BnfAlloc :=0;
        With Ret[RetNo].Frm[PrfFNo] do
        begin
          Strings[1] := GetYearEnd(RetNo);
          Strings[2] := LeftStr(GetYearEnd(RetNo),4);
          if Strings[11]='' then
          Begin
           BnfAlloc:=BnfAlloc
            + Vl(FetchElmFNo(RetNo, FNo, 56)) //div elgble
            + Vl(FetchElmFNo(RetNo, FNo, 5)) //Cap gains
            + Vl(FetchElmFNo(RetNo, FNo, 7)) //Div non elig
            + Vl(FetchElmFNo(RetNo, FNo, 10)); // Oth Inc
           (*
           BnfAlloc :=
            Vl(FetchElmFNo(RetNo,FNo,5))    {box 21}
                       +Vl(FetchElmFNo(RetNo,FNo,6))   {22}
                       +Vl(FetchElmFNo(RetNo,FNo,7))   {23}
                       +Vl(FetchElmFNo(RetNo,FNo,8))   {24}
                       +Vl(FetchElmFNo(RetNo,FNo,9))   {25}
                       +Vl(FetchElmFNo(RetNo,FNo,10));  {26}
           *)
           Strings[3] := FormatFloat('#######',Vl(FetchElm(RetNo,'T3',125))); //20230320 Tot income FormatFloat('#######',GetTotalPreferredAllocation(RetNo));
           Strings[4] := FormatFloat('########',BnfAlloc);
           Strings[5] := Strings[4];
           Strings[6] := FetchElm(RetNo,'T3',327); {trustee}
           Strings[8] := FetchElmFNo(RetNo,FNo,64)+' '+FetchElmFNo(RetNo,FNo,26); {benef first and last name}
          End;

         end; {copying with RetNo}
    end; {if preferred}
  end; {For}
end;


(*
procedure DON(RetNo: integer; FName: String;FNo: integer);
Var Cn,Us,CnCf,UsCf,TotCf,Remaining: real; I: integer;
begin
  LoadTv(RetNo,FName,FNo);
  CnCf:=0;UsCf:=0;
  with Ret[RetNo].Frm[Fno] do
  begin
     {Tv[1] := Ret[RetNo].T4Don;}
     {Tv[6] := Ret[RetNo].T4ADon;}
     {Tv[11] := Ret[RetNo].T5013Don;}
     cn  :=0; us :=0;
     If Strings[2] > '' then Strings[2] :='';   {no us for slips}
     If Strings[7] > '' then Strings[7] :='';
     cn := Tv[1]+Tv[6]+tv[11];
     i := 17;
     Repeat  {first column}
      If UpperCase(Strings[i+1]) = 'X'then
        us := us+tv[i]
      else
        cn := cn + Tv[i];
      Inc(i,6);
     Until i > 83;

     i := 4;
     Repeat   {Second column}
      If UpperCase(Strings[i+1]) = 'X'then
        us := us+tv[i]
      else
        cn := cn + Tv[i];
      Inc(i,5);
     Until i > 14;

     i := 20;
     Repeat   {Second column}
      If UpperCase(Strings[i+1]) = 'X'then
        us := us+tv[i]
      else
        cn := cn + Tv[i];
      Inc(i,6);
     Until i > 86;

     Tv[88] := cn+Us;


    {PRIOR YEARS}
     Strings[89]  := GetPrvYear(Ret[RetNo].TrustYear,3);
     Strings[94]  := GetPrvYear(Ret[RetNo].TrustYear,2);
     Strings[99]  := GetPrvYear(Ret[RetNo].TrustYear,1);
     Strings[104] := Ret[RetNo].TrustYear;
     
    {current year row}
    Tv[105] := Tv[88];
    {get portion applied from each year}
    Remaining := Tv[90]+Tv[95]+Tv[100]+Tv[105]; {Tv[130];}
    i:=90;
    Repeat
     If Tv[i] < Remaining then
       begin
        If UpperCase(Strings[142]) <> 'Y' then Tv[i+1] := Tv[i];
        Remaining := Remaining-Tv[i+1];
       end
     else
       begin
        If UpperCase(Strings[142]) <> 'Y' then Tv[i+1] := Remaining;
        Remaining := 0;
       end;
      Inc(i,5);
    until i > 105;

    {prior year : Horizontal}
     i := 90;
     Repeat
      Tv[i+3] := MaxR(0,Tv[i] - Tv[i+1] - Tv[I+2]);
      Inc(i,5);
     until i > 105;

    {prior year : Vertical}
     For i := 90 to 93 do
        Tv[i+19] := Tv[i] + (Tv[i+5] + Tv[I+10]+ Tv[i+15]);

    {Calculate credit}
    Tv[122] := Vl(FetchElm(RetNo,'T3',256)); {Net Inc}
    Tv[113] := Tv[106]; {Cn;}
    Tv[115] := Tv[106];

    Tv[113] := MaxR(0,Tv[115]-Tv[114]); {us;?}
    TotCf :=Tv[91]+Tv[96]+Tv[101]; {Tv[90]+Tv[95]+Tv[100];}
    CnCf := TotCf;
    If Tv[117] > TotCf then Tv[117] := TotCf;
    If Tv[117] >0 then
      Tv[116] := MaxR(0,TotCf - Tv[117])
    else
      Tv[116] := TotCf;

    If Tv[116] > CnCf then Tv[116] :=CnCf; {if override}
    Tv[118] := Tv[116];
    Tv[116] := MaxR(0,Tv[118]-Tv[117]); {us;?}

    Tv[119] := Tv[113] + Tv[116];
    Tv[120] := Tv[114] + Tv[117];
    Tv[125] := Constant[RY].DonPercent/100 * Tv[122];
    Tv[126] := Constant[RY].DonPercent/100 * Tv[123];
  
    Tv[128] := MinR(Tv[119], Tv[125]);
    Tv[129] := MinR(Tv[120], Tv[126]);
    Tv[131] := Tv[112];

    {Horizontal calc}
    i:=113;
    Repeat
     Tv[i+2] := Tv[i] + Tv[i+1];
     Inc(i,3);
    until i > 131;


    {cultural,ecological}
    {Tv[135] := Ret[RetNo].T5013Gifts;}
    Tv[140] := Tv[135] + Tv[137] +Tv[139];


  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;
*)

Procedure T4_1(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T3A(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x:Real;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  Strings[1] := FetchElm(RetNo,'T3',1);
  Strings[2] := FetchElm(RetNo,'T3',2);
  Strings[3] := FetchElm(RetNo,'T3',17);

  if Certificationmode then Strings[3]:='';


  //20201220
  Strings[32] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),1),4);
  Strings[34] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),2),4);
  Strings[36] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),3),4);

  Strings[51] := Strings[32];
  Strings[52] := Strings[34];
  Strings[53] := Strings[36];

  Tv[4] := Vl(FetchElm(RetNo,'T3',101));
  Tv[5] := Vl(FetchElm(RetNo,'T3',266)); //20191225 instead of 267
  Tv[6] := Vl(FetchElm(RetNo,'T3',102));
  {investm}
  x:=     Vl(FetchElm(RetNo,'S8',1))
         + Vl(FetchElm(RetNo,'T3',255))
         + Vl(FetchElm(RetNo,'T3',104))
         + Vl(FetchElm(RetNo,'T3',105))
         - Vl(FetchElm(RetNo,'S8',25))
         //20110321
         - Vl(FetchElm(RetNo,'T3',231));
  If x>0 then
  begin  Tv[7] := x; Tv[8] :=0; end
  else
  begin Tv[7] := 0; Tv[8] :=ABS(x); end;
  {bus}
  x:=Vl(FetchElm(RetNo,'T3',107));
  If x>0 then
  begin Tv[9]:=x;Tv[10]:=0;end
  else
  begin Tv[9]:=0;Tv[10]:=ABS(x); end;

  {Farm}
  x:=Vl(FetchElm(RetNo,'T3',109));
  If x>0 then
  begin Tv[11]:=x;Tv[12]:=0;end
  else
  begin Tv[11]:=0;Tv[12]:=ABS(x); end;

  {Fish}
  x:=Vl(FetchElm(RetNo,'T3',111));
  If x>0 then
  begin Tv[13]:=x;Tv[14]:=0;end
  else
  begin Tv[13]:=0;Tv[14]:=ABS(x); end;

  {Rental}
  x:=Vl(FetchElm(RetNo,'T3',113));
  If x>0 then
  begin Tv[15]:=x;Tv[16]:=0;end
  else
  begin Tv[15]:=0;Tv[16]:=ABS(x); end;

  {Nisa 2}
  x:=Vl(FetchElm(RetNo,'T3',114));
  If x>0 then
  begin Tv[17]:=x;end
  else
  begin Tv[17]:=0;end;

  {T1055}
  x:=Vl(FetchElm(RetNo,'T3',116));
  If x>0 then
  begin Tv[18]:=x;Tv[19]:=0;end
  else
  begin Tv[18]:=0;Tv[19]:=ABS(x); end;

  {oth inc}
  x:=Vl(FetchElm(RetNo,'T3',124));
  If x>0 then
  begin Tv[20]:=x;end
  else
  begin Tv[20]:=0;end;

  {abil}
  x:=Vl(FetchElm(RetNo,'T3',232));
  If x>0 then
  begin Tv[21]:=x;end
  else
  begin Tv[21]:=0;end;

  {losses oth years}
  x:=Vl(FetchElm(RetNo,'T3',267));
  If x>0 then
  begin Tv[23]:=x;end
  else
  begin Tv[23]:=0;end;

  Tv[24] := Tv[4]+Tv[6]+Tv[7]+Tv[9]+Tv[11]+Tv[15]+Tv[17]+Tv[18]+Tv[20]; //13 out
  Tv[25] := Tv[5]+Tv[8]+Tv[10]+Tv[12]+Tv[16]+Tv[21]+Tv[22]+Tv[23];  //20191225 14 out and p loss fld 19

  Tv[26] := Vl(FetchElm(RetNo,'T3',244));

  Tv[27] := MaxR(0,Tv[24]-Tv[26]);
  Tv[28] := Tv[27];
  Tv[29] := MaxR(0,Tv[25] - Tv[28]);

  {fish and Farm}
  x:= Vl(FetchElm(RetNo,'T3',109))+Vl(FetchElm(RetNo,'T3',111));
  If x>0 then
  begin Tv[41]:=0;Tv[42]:=x;end
  else
  begin Tv[41]:=Abs(x);Tv[42]:=0; end;
  Tv[43] := MaxR(0,Tv[41]-Tv[42]);

  Tv[30] := MinR(Tv[29],Tv[43]);
  Tv[31] := MaxR(0,Tv[29]-Tv[30]);

  Tv[38]:=AddColumns(33,37,2);
  Tv[39] := Tv[38];
  Tv[40] := MaxR(0,Tv[31] - Tv[39]);


  Tv[44] := Tv[30];
  Tv[48]:=AddColumns(45,47,1);
  Tv[49]:=Tv[48];
  Tv[50] := MaxR(0,Tv[44] - Tv[49]);
 end;

 //T3A pg 2 --------------------------------------------------------------------
 with Ret[RetNo].Frm[Fno] do
 begin
  //20201220
  Strings[108] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),1),4);
  Strings[109] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),2),4);
  Strings[110] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),3),4);

  Strings[111] := Strings[108];
  Strings[112] := Strings[109];
  Strings[113] := Strings[110];

  Strings[121] := Strings[108];
  Strings[122] := Strings[109];
  Strings[123] := Strings[110];

   x:=Vl(FetchElm(RetNo,'S1',97));
   If x<0 then Tv[101] := ABS(x) else Tv[101] :=0;

   Tv[105] := AddColumns(102,104,1);
   Tv[106] := Tv[105];
   Tv[107] := MaxR(0,Tv[101] - Tv[106]);

   Tv[118] := AddColumns(115,117,1);
   Tv[119] := Tv[118];
   Tv[120] := MaxR(0,Tv[114] - Tv[119]);

   Tv[128] := AddColumns(125,127,1);
   Tv[129] := Tv[128];
   Tv[130] := MaxR(0,Tv[124] - Tv[129]);
 end;

 SaveTv(RetNo,FName,FNo);
end;


Procedure T2202Ws(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x:Real; TotPartTime,TotFullTime:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  Tv[38]:=0;
  TotPartTime:=0;
  TotFullTime:=0;
  i:=3;
  Repeat
   If Strings[i+2]='' then Strings[i+2]:=Strings[i];
   If (Strings[i+1]>'') and (length(Strings[i+1])=1) then Strings[i+1]:='0'+Strings[i+1];
   If (Strings[i+3]>'') and (length(Strings[i+3])=1) then Strings[i+3]:='0'+Strings[i+3];
   If (Strings[i+5]>'') and (length(Strings[i+5])=1) then Strings[i+5]:='0'+Strings[i+5];
   If (Strings[i+6]>'') and (length(Strings[i+6])=1) then Strings[i+6]:='0'+Strings[i+6];

   Tv[38]:=Tv[38]+Tv[i+4];
   TotPartTime:=TotPartTime+MyStrToInt(Strings[i+5]);
   TotFullTime:=TotFullTime+MyStrToInt(Strings[i+6]);
   Inc(i,7);
  until i>31;
  Strings[39]:=IntToStr(TotPartTime);
  Strings[40]:=IntToStr(TotFullTime);
  If (Strings[39]>'') and (length(Strings[39])=1) then Strings[39]:='0'+Strings[39];
  If (Strings[40]>'') and (length(Strings[40])=1) then Strings[40]:='0'+Strings[40];
  If Tv[53]>Tv[38] then Tv[53]:=Tv[38];
  If Tv[54]>Tv[38] then Tv[54]:=Tv[38];

  If Tv[53]>Tv[38] then Tv[53]:=Tv[38];
  If Tv[54]>Tv[38] then Tv[54]:=Tv[38];
  Strings[57]:=UpperCase(Strings[44]+' '+Strings[45]);  //20150307
  If Strings[56]='' then Strings[56]:=FormatDateTime('yyyy-mm-dd',Date);

 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure T1235(RetNo:integer;FName:string;FNo:integer);
Var i,k:integer;
begin
 k:=0;
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin

  If (FetchElmFNo(RetNo,GetFormNO('T3010'),1)<'2013-01-01')
  Or (FetchElmFNo(RetNo,GetFormNo('T3010'),1)='')
  then
  begin
   For i:=1 to 99 do begin Strings[i]:='';Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  end;

  i:=1;
  Repeat
   If Strings[i]>'' then k:=K+1;
   Inc(i,12);
  until i>73;
  Strings[85]:=IntToStr(k);
  If CertificationMode=True then Strings[85]:='';
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T1236(RetNo:integer;FName:string;FNo:integer);
Var i,k:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin

  If (FetchElmFNo(RetNo,GetFormNO('T3010'),1)='')
  or (FetchElmFNo(RetNo,GetFormNO('T3010'),1)<'2013-01-01')
  then
  begin
   For i:=1 to 88 do begin Strings[i]:='';Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  end;

  k:=0;
  i:=1;
  Repeat
   If Strings[i]>'' then k:=k+1;
   Inc(i,8);
  until i>65;
  Strings[77]:=IntToStr(k);
  If CertificationMode=True then Strings[77]:='';

  Tv[75]:=0;
  Tv[76]:=0;
  i:=7;
  Repeat
   Tv[75]:=Tv[75]+Tv[i];
   Tv[76]:=Tv[76]+Tv[i+1];
   Inc(i,8);
  until i>71;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T106(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
     FillHeader(RetNo,FNo,1,2,3);
     //For i:=8 to 22 do Strings[i]:='';
     Strings[32]:=IntToStr(CountMultipleInstances(RetNo,'T106SL'));
     Tv[33]:=TotMultiple(RetNo,'T106SL',110);
     If Strings[39]+Strings[40]='' then Strings[40]:='X';
     If Strings[41]+Strings[42]='' then Strings[42]:='X';
     If Strings[45]+Strings[46]='' then Strings[46]:='X';
     If Strings[49]+Strings[50]='' then Strings[50]:='X';
     If Strings[51]+Strings[52]='' then Strings[52]:='X';
   end;
    SaveTv(RetNo,FName,FNo);
end;

Procedure T106SL(RetNo: integer; FName: String;FNo: integer);
Var i,k:Integer; FInst:String;
begin
  FInst:=ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
     Strings[69]:=MidStr(FInst,2,3);
     Strings[71]:=IntToStr(CountT106Slips(RetNo));
     Tv[92]:=Tv[120]+AddColumns(32,88,4)+Tv[73]+Tv[85]+Tv[124];
     Tv[94]:=Tv[122]+AddColumns(34,90,4)+Tv[75]+Tv[87]+Tv[125];
     i:=96;
     Tv[108]:=0;
     Tv[109]:=0;
     Repeat
      Tv[i+3]:=MaxR(0,Tv[i]+tv[i+1]-Tv[i+2]);
      Tv[108]:=Tv[108]+Tv[i+1];
      Tv[109]:=Tv[109]+Tv[i+2];
      Inc(i,4);
     until i>104;
     i:=126;
     Tv[159]:=0;Tv[160]:=0;Tv[161]:=0;
     k:=0;
     Repeat
      k:=k+MyStrToInt(Strings[i]);
      Tv[159]:=Tv[159]+Tv[i+1];
      Tv[160]:=Tv[160]+Tv[i+2];
      Tv[161]:=Tv[161]+Tv[i+3];
      Inc(i,4);
     until i>154;
     Strings[158]:=IntToStr(k);
     Tv[110]:=Tv[92]+Tv[94]+Tv[108]+Tv[109]+Tv[160]+Tv[161];
     Tv[114]:=Tv[111]+Tv[112]-Tv[113];
     Tv[118]:=Tv[115]+Tv[116]-Tv[117];
   end;
   SaveTv(RetNo,FName,FNo);
end;

Procedure T4AP(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    Strings[9] := AppYear;
    // If ShowUnconvertedLastYear(RetNo) then Strings[9]:=GetLastYearTaxYear;
   // Strings[10] := FetchElm(RetNo, 'INFO', 3);
   // Strings[1] := FetchElm(RetNo, 'INFO', 5) + ', ' + FetchElm(RetNo, 'INFO', 2);
    Tv[4] := Tv[11] + Tv[13] + Tv[14] + Tv[15] + Tv[16] + Tv[5];
    If Tv[2] > Tv[4] then Tv[2] := Tv[4]; // indian diability exempt  //20121213

  end;
  SaveTv(RetNo, FName, FNo);
end;



Procedure T3MJON(RetNo: integer; FName: String; FNo: integer);
  Var i,k :integer; SpRetNo,WhichRetNo:integer;
  //20170114

  //jz//2025updateforgotenT3MJ
  BasicAddTaxRate, SurtaxTaxRate,
  Ln27Ln47Rate1  , Ln27Ln47Rate2 : string;
  Ln25Ln48Amount1, Ln26Ln49Amount2 : real;


Begin
 InitPrvConstants('ON');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    For i:=1 to 69 do Tv[i]:=0;
    //20141231
    For i:=2 to 22 do Tv[i]:=0;
    For i:=156 to 162 do Tv[i]:=0;
    For i:=117 to 121 do Tv[i]:=0;
    For i:=123 to 124 do Tv[i]:=0;  //20160811

    If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Certificationmode=False then  //2021105
    Begin
      SaveTv(RetNo,FName,FNo);Exit;
    End;

    Tv[1]:= GetTrustTxbl(RetNo);

    //jz//2025updateforgotenT3MJ -->
    If Ry=0 then
      begin BasicAddTaxRate:= '24.63'; SurtaxTaxRate:= '56'; Ln25Ln48Amount1:= 5554; Ln26Ln49Amount2:= 7108; Ln27Ln47Rate1:= '20'; Ln27Ln47Rate2:= '36'; end
    else
      begin BasicAddTaxRate:= '24.63'; SurtaxTaxRate:= '56'; Ln25Ln48Amount1:= 5554; Ln26Ln49Amount2:= 7108; Ln27Ln47Rate1:= '20'; Ln27Ln47Rate2:= '36'; end;

    Tv[64]  := Ln25Ln48Amount1;

    Tv[65]  := Ln26Ln49Amount2;
    Tv[110] := Ln25Ln48Amount1;
    Tv[112] := Ln26Ln49Amount2;

    strings[64]  := Ln27Ln47Rate1;
    strings[65]  := Ln27Ln47Rate2;
    strings[111] := Ln27Ln47Rate1;
    strings[113] := Ln27Ln47Rate2;

    Tv[54]  := Ln25Ln48Amount1;
    Tv[55]  := Ln26Ln49Amount2;

    //jz//2025updateforgotenT3MJ <--

    With PrvConstant[RY] do
    begin
      Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket1);
      Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket1);
      Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket2);
      Ret[RetNo].Frm[FNo].Strings[70]:=FormatFloat('###,###',PrvBracket2);
      Ret[RetNo].Frm[FNo].Strings[61]:=FormatFloat('###,###',PrvBracket3);
      Ret[RetNo].Frm[FNo].Strings[71]:=FormatFloat('###,###',PrvBracket3);
      Ret[RetNo].Frm[FNo].Strings[72]:=FormatFloat('###,###',PrvBracket4);
      Ret[RetNo].Frm[FNo].Strings[69]:=FormatFloat('###,###',PrvBracket4);

      Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
      Tv[6]   :=PrvBracket1;
      Tv[7]   :=PrvBracket2;
      Tv[157] :=PrvBracket3;
      Tv[118] :=PrvBracket4;

      Tv[11]  := Vl(PrvConstant[RY].PrvRate1);

      //tempRealVar := Tv[11];

      Tv[12]  := Vl(PrvConstant[RY].PrvRate2);
      Tv[13]  := Vl(PrvConstant[RY].PrvRate3);
      Tv[159] := Vl(PrvConstant[RY].PrvRate4);
      Tv[120] := Vl(PrvConstant[RY].PrvRate5);

      Tv[57]:= Vl(PrvConstant[RY].PrvRate5);

      Tv[17]:= PrvConstant[RY].PrvBracketTax1;
      Tv[18]:= PrvConstant[RY].PrvBracketTax2;
      Tv[19]:= PrvConstant[RY].PrvBracketTax3;
      Tv[161]:= PrvConstant[RY].PrvBracketTax4;
      Tv[123]:= PrvConstant[RY].PrvBracketTax5;

      Tv[58]:= PrvConstant[RY].PrvDonRate1;
      Tv[59]:= 11.16;   //20170114
      Tv[37]:= 17.41; //20211030 //PrvConstant[RY].PrvDonRate2;  //Tv[37]:=17.41; //20201209  //donation rate all other trusts
      Ret[RetNo].Frm[FNo].Strings[60]:= PrvConstant[RY].PrvDivRate;
      Ret[RetNo].Frm[FNo].Strings[35]:= PrvConstant[RY].PrvDivRateBig;

      Tv[55]:= PrvConstant[RY].PrvAmtCarryOverRate;

      Tv[62] := 20;
      Tv[63]:= 36;

      {CERTIFICATION  20201209 dummy out this section Open New, set ONT provinve, open T3ON and click Recalc
      //20170305
      //BETTER override the amounts directly on the form
      }
      //-------------------------------------------


      If (OtherThanQreAndQdt(RetNo)=True) then
      begin
        If CertificationMode=False then
        begin
          Tv[57]:= Vl(PrvConstant[RY].PrvRate5);
          //20181219

          Strings[5]:= '';
          For i:=2 to 22    do Tv[i]:=0;
          For i:=156 to 162 do Tv[i]:=0;
          For i:=117 to 121 do Tv[i]:=0;  // 20240208  why this, what is it blanking begin Tv[i]:=0; Ret[RetNo].Frm[FNo].Strings[i]:=''; end;
          For i:=123 to 124 do Tv[i]:=0;
        end;
      end;
      // else Tv[57]:=0;
      //---------------------------------------------------------
      //20231121
      //jz//2025updateforgotenT3MJ -->
      {
      If Ry=0 then
        begin Tv[64]:=5315; Tv[65]:=6802; Tv[54]:=Tv[64];Tv[55]:=Tv[65]; end
      else
        begin Tv[64]:=5315; Tv[65]:=6802; Tv[54]:=Tv[64];Tv[55]:=Tv[65]; end;
      }

    end; //end with RY
 end; //end wirh Ret[RetNo]

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     if not OtherThanQreAndQdt(RetNo) then Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     if not OtherThanQreAndQdt(RetNo) then Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <PrvConstant[RY].PrvBracket3)
   then
   begin
     if not OtherThanQreAndQdt(RetNo) then Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Vl(Frm[FNo].Strings[13])/100;
     Tv[22] := Tv[16] + Tv[19];
   end;
   //20130202
   If (Tv[1] > PrvConstant[RY].PrvBracket3)
    and (Tv[1] <PrvConstant[RY].PrvBracket4)     //20141231
   then
   begin
     if not OtherThanQreAndQdt(RetNo) then Tv[156] := Tv[1];
     Tv[158] := MaxR(0,Tv[156]-Tv[157]);
     Tv[160] := Tv[158] * Vl(Frm[FNo].Strings[159])/100;
     Tv[162] := Tv[160] + Tv[161];
   end;

   //20141231
   If (Tv[1] > PrvConstant[RY].PrvBracket4)
   then
   begin
     if not OtherThanQreAndQdt(RetNo) then  Tv[117] := Tv[1];
     Tv[119] := MaxR(0,Tv[117]-Tv[118]);
     Tv[121] := Tv[119] * Vl(Frm[FNo].Strings[120])/100;
     Tv[124] := Tv[121] + Tv[123];
   end;

   //20160811
   Tv[57]:=20.53;  //20170114
   If OtherThanQreAndQdt(RetNo)=True then
   Begin
    Tv[23] := Tv[1];
    Tv[24]:=Tv[23] * Tv[57]/100;
   end
   Else
   Begin
    Tv[23]:=0;
    Tv[24]:=0;
   End;

   //20170326
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 //  Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   //20170327
   Tv[28]:=0;
   Tv[41]:=0;

   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    If (IsQre(RetNo)) or (IsQdt(RetNo)) then
    Begin
     Tv[28]:=MaxR(0,Tv[25]-200);
     Tv[41]:=0;
    end
    Else
    Begin
      Tv[41] :=MaxR(0,Tv[25]-200);
      Tv[28]:=0;
    end;
   end  //>200
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
    Tv[41]:=0;
   end;


   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[29] := Tv[28] * Tv[59]/100;
   Tv[38] := Tv[41] * Tv[37]/100;
   Tv[30] := Tv[27]+Tv[29]+Tv[38];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
   Begin
     Tv[31] := MaxR(MaxR(Tv[20],Tv[162]),MaxR(Tv[21],Tv[22]));
     Tv[31] := MaxR(Tv[31],Tv[124]);  //20141231
   end;

   Tv[83] := Tv[31]+Tv[82];
   //tempRealVar := Tv[83]; //????

   Tv[32] := Tv[30];
   Tv[73]:=MaxR(0,Tv[83]-Tv[32]);   //20141231

   Tv[74]:=Tv[73];


   // Chart 1 - Dividend tax credit  //20170114 <<<
   Tv[53]:=Vl(FetchElm(RetNo,'S8',34));
   Tv[33]:=Vl(FetchElm(RetNo,'S8',35));
   if Ret[RetNo].Province <> 'ON' then //ontario residents only
   begin
     Tv[53] := 0; Tv[33] := 0;
   end;
   Frm[FNo].Strings[35]:=PrvConstant[RY].PrvDivRateBig; //20180108
   Tv[52]:=Tv[53]*Vl(PrvConstant[RY].PrvDivRateBig)/100;

   Frm[FNo].Strings[60]:=PrvConstant[RY].PrvDivRate;  //20180108
   Tv[34]:=Tv[33]*Vl(PrvConstant[RY].PrvDivRate)/100;
   Tv[84]:=Tv[52]+Tv[34];
   if Ret[RetNo].Province <> 'ON' then Tv[84]  := 0;


   //Tv[81] := Vl(FetchElm(RetNo,'S8',43));      //20141231
   Tv[52] := Tv[53] * Vl(Ret[RetNo].Frm[FNo].Strings[35])/100;
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[60])/100;
   //Tv[83]:=  Tv[81] * Vl(Ret[RetNo].Frm[FNo].Strings[82])/100;
   Tv[84] := Tv[52]+Tv[34]; //+Tv[83];   //20141231
   // Chart 1 >>>

{  //use the one further down in the code
   // jzmj2024_1
   // Chart 1 <<<
   Tv[53] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));

   if Ret[RetNo].Province <> 'ON' then //ontario residents only
   begin
     Tv[53] := 0; Tv[33] := 0;
   end;

   //Tv[81] := Vl(FetchElm(RetNo,'S8',43));      //20141231
   Tv[52] := Tv[53] * Vl(Ret[RetNo].Frm[FNo].Strings[35])/100;
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[60])/100;
   //Tv[83]:=  Tv[81] * Vl(Ret[RetNo].Frm[FNo].Strings[82])/100;
   Tv[84] := Tv[52]+Tv[34]; //+Tv[83];   //20141231
   // Chart 1 >>>
}

   Tv[75]:=Tv[84];
   Tv[76]:=MaxR(0,Tv[74]-Tv[75]);   //20141231
   Tv[77]:=Vl(FetchElm(RetNo,'S11',143)); //20141231

   //jz//2025updateforgotenT3MJ
   strings[114] := '33.67';
   Tv[78]:=Tv[77] * vl(strings[114])/100;

   Tv[36] := MinR(Tv[76],Tv[78]);
   Tv[39] := MaxR(0,Tv[73]-Tv[36]);


   //additional tax for min tax
   if Vl(FetchElm(RetNo,'S12',124))>0 then
   Begin
    Tv[87]:=Vl(FetchElm(RetNo,'S12',124));

    //jz//2025updateforgotenT3MJ
    //happens a second time below for some reason??
    strings[85] := BasicAddTaxRate;
    Tv[88]:=Tv[87]*vl(strings[85])/100;    //33.67/100; //11.5/100; //20181113 Igor  //20181213

    if OtherThanQREAndQdt(RetNo)then
    Begin
     Tv[89]:=Tv[88];

     //jz//2025updateforgotenT3MJ
     //happens a second time below for some reason??
     strings[109] := SurtaxTaxRate;
     Tv[90]:=Tv[89]*vl(strings[109])/100;    //20211205
     //Tv[81]:=Tv[89]*33.67/100; //20210324
     //Tv[90]:=Tv[81];

    End
    Else
    Begin
     Tv[89]:=0;
     Tv[81]:=0;
     Tv[90]:=0;
     Tv[91]:=Tv[88];
     Tv[92]:=Tv[39];
     Tv[93]:=Tv[91]+Tv[92];
    End;

    Tv[94]:=Tv[93];
    //20181113 Igor >>


    Tv[95]  := MaxR(0,Tv[94]-Tv[110])* vl(strings[111])/100; //jz//2025updateforgotenT3MJ use new fields - happens a second time below for some reason?? //Tv[95]:=MaxR(0,Tv[94]-Tv[54]) * 20/100;  //20231121
    //Tv[95]:=MaxR(0,Tv[94]-4830) * 20/100;  //20210329
    //Tv[95]:=MaxR(0,Tv[94]-Tv[43]) * 20/100;  //20180107   //20201209
    //Tv[95]:=MaxR(0,Tv[94]-4638) * 20/100;  //20180107

    Tv[96]:=Tv[93];
    Tv[97] :=MaxR(0,Tv[96]-Tv[112])* vl(strings[113])/100; //jz//2025updateforgotenT3MJ use new fields - happens a second time below for some reason?? //Tv[97]:=MaxR(0,Tv[96]-Tv[55]) * 36/100; //20231121
    //Tv[97]:=MaxR(0,Tv[96]-6182) * 36/100; //20210329
    //Tv[97]:=MaxR(0,Tv[96]-Tv[46]) * 36/100; //20201209  //20180107//Tv[97]:=MaxR(0,Tv[96]-5936) * 36/100;   //20180107
    //20181113 Igor <<<
    Tv[98]:=Tv[95]+Tv[97];

    Tv[99]:=Tv[49];
    //Tv[100]:=MaxR(0,Tv[98]-Tv[99]);
    Tv[102]:=MaxR(0,Tv[98]-Tv[99]); //Tv[100]; //20230212
    Tv[103]:=Tv[88]+Tv[90]+Tv[102];
   end
   Else  //no min tax
   begin
    Tv[81]:=0;
    for i:=87 to 103 do Tv[i]:=0;
   end;

   Tv[40]:=Tv[103]; //20170114

   if OtherThanQREAndQdt(RetNo)=False then  //they are QRE or QDT   //20170301
   Begin
    Tv[42] := Tv[39];
    Tv[43] := MaxR(0,Tv[42] - Tv[64]);
    Tv[44] := Tv[43] * Tv[62]/100;

    Tv[45] := Tv[39];
    Tv[46] := MaxR(0,Tv[45]-Tv[65]);
    Tv[47] := Tv[46]* Tv[63]/100;
    Tv[48] := Tv[44]+Tv[47];
    Tv[49] := Tv[48];
   End
   Else
   Begin
    for i:=42 to 49 do Tv[i]:=0;
   End;

   Tv[50] := Tv[39]+Tv[49];



   strings[105] := FetchElm(RetNo,'T3MJ',43);
   Tv[106] := Tv[50] * vl(strings[105])/100;
   Tv[107] :=  Tv[82] * (100 - (vl(strings[105]))) /100;

   Tv[108] :=  Tv[106]+Tv[107];

   //Tv[85]:=Tv[80]; //Tv[50];   //20210310

   Tv[79]:=Tv[84];
   if Ret[RetNo].Province <> 'ON' then Tv[79]  := 0;

   Tv[80]:=MaxR(0,Tv[108]-Tv[79]);  //20210312 //MaxR(0,Tv[85]-Tv[79]);  //20170106

   If Vl(FetchElm(RetNo,'S12',124))>0 then  //20231121
     Tv[40]:=Tv[103]  //20231121
   Else
     Tv[40]:=0;

   Tv[85]:=Tv[80];  //20210312
   Tv[86]:=Tv[85]+Tv[40]; //Tv[80]+Tv[40];  //20210312
   Tv[51] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'ON' then Tv[51]  := 0;

   Tv[56] := MaxR(0,Tv[86]-Tv[51]);


   //20231121
   Tv[87]:=Vl(FetchElm(RetNo,'S12',124));

   //jz//2025updateforgotenT3MJ
   //happens a second time above for some reason??
   strings[85] := BasicAddTaxRate;
   Tv[88]:=Tv[87]*vl(strings[85])/100; //   Tv[88]:=Tv[87] * 33.67/100;

   //mjjz2024 <<<
   Tv[54]     := Tv[88];
   strings[55]:= FetchElm(RetNo,'T3MJ',43);
   Tv[81]     := Tv[54] * vl(strings[55])/100;
   //mjjz2024 >>>

   Tv[89] :=Tv[88];

   //jz//2025updateforgotenT3MJ
   //happens a second time above for some reason??
   strings[109] := SurtaxTaxRate;
   Tv[90]:=Tv[89]*vl(strings[109])/100;    //Tv[90] :=Tv[89] * 56/100;

   Tv[91] :=Tv[88];
   Tv[92] :=Tv[39];
   Tv[93] :=Tv[91]+Tv[92];

   Tv[94] :=Tv[93];
   Tv[95]  := MaxR(0,Tv[94]-Tv[110])* vl(strings[111])/100; //jz//2025updateforgotenT3MJ - happens a second time above for some reason??//Tv[95]  := MaxR(0,Tv[94]-Tv[54])* 20/100;


   Tv[96] :=Tv[93];
   Tv[97] :=MaxR(0,Tv[96]-Tv[112])* vl(strings[113])/100; //jz//2025updateforgotenT3MJ - happens a second time above for some reason??//Tv[97] :=MaxR(0,Tv[96]-Tv[55])* 36/100;

   Tv[98] :=Tv[95]+Tv[97];
   Tv[99] :=Tv[49];
   Tv[102]:=MaxR(0,Tv[98]-Tv[99]);

   Tv[100]      := Tv[102];
   strings[101] := FetchElm(RetNo,'T3MJ',43);
   Tv[104]      := Tv[100] * vl(strings[101])/100;

   Tv[103]:=Tv[81]+Tv[90]+Tv[104];

  end;
   StoreElm(RetNo,FNo,17,'0.00'); //20180226
 SaveTv(RetNo,FName,FNo);

end;





































Procedure T3MJAB(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;s:string;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='AB';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('AB');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,'AB') then
   begin
    For i:=1 to 123 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit;
   end;

   //20160208  Complete overhaul
   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[13]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[14]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[64]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[65]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket4);

       Ret[RetNo].Frm[FNo].Strings[74]:= '0.00';
       Ret[RetNo].Frm[FNo].Strings[94]:= '0.00';

       Tv[75]:=PrvBracket1;
       Tv[76]:=PrvBracket2;
       Tv[77]:=PrvBracket3;
       Tv[78]:=PrvBracket4;

       Tv[84]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[85]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[86]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[87]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[88]:= Vl(PrvConstant[RY].PrvRate5);

       Tv[94]:= PrvConstant[RY].PrvBracketTax1;
       Tv[95]:= PrvConstant[RY].PrvBracketTax2;
       Tv[96]:= PrvConstant[RY].PrvBracketTax3;
       Tv[97]:= PrvConstant[RY].PrvBracketTax4;
       Tv[98]:= PrvConstant[RY].PrvBracketTax5;

       Tv[57]:= Vl(PrvConstant[RY].PrvRate5); //PrvConstant[RY].PrvIntervivosRate;
       Tv[58]:= PrvConstant[RY].PrvDonRate1;
       Tv[59]:= PrvConstant[RY].PrvDonRate2;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[69] := Tv[1];
     Tv[79] := MaxR(0,Tv[69]-vl(Frm[FNo].Strings[74]));
     Tv[89] := Tv[79] * Tv[84]/100;
     Tv[99] := Tv[89] + Tv[94];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[70] := Tv[1];
     Tv[80] := MaxR(0,Tv[70]-Tv[75]);
     Tv[90] := Tv[80] * Tv[85]/100;
     Tv[100] := Tv[90] + Tv[95];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[71] := Tv[1];
     Tv[81] := MaxR(0,Tv[71]-Tv[76]);
     Tv[91] := Tv[81] * Tv[86]/100;
     Tv[10] := Tv[91] + Tv[96];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[72] := Tv[1];
     Tv[82] := MaxR(0,Tv[72]-Tv[77]);
     Tv[92] := Tv[82] * Tv[87]/100;
     Tv[11] := Tv[92] + Tv[97];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket4) then
   begin
     Tv[73] := Tv[1];
     Tv[83] := MaxR(0,Tv[73]-Tv[78]);
     Tv[93] := Tv[83] * Tv[88]/100;
     Tv[12] := Tv[93] + Tv[98];
   end;


   Tv[23] := Tv[1];

   If OtherThanQreAndQdt(RetNo)=True then
   begin
    Tv[24]:=Tv[23] * 15/100; //20160209  //20170305
    Tv[99]:=0;Tv[100]:=0;Tv[10]:=0;Tv[11]:=0;Tv[12]:=0; //mjjz2024
   end;


    //If IsIntervivos(RetNo) then Tv[24]:=Tv[23] * 11.25/100; //20160209
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Tv[58]:= PrvConstant[RY].PrvDonRate1;
  Tv[21]:=21;

  Tv[61]:= PrvConstant[RY].PrvAmtCarryOverRate;

  Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 Tv[25]:= Vl(FetchElm(RetNo,'S11',38));

   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[22] := Tv[28] * Tv[21]/100; //jzmj2024_1

   Tv[18] := Tv[27] + Tv[22];

   If Tv[24]>0 then //mjjz2024 this seems redundant with the OtherThanQreAndQdt line below
     Tv[31]:=Tv[24]
   Else
   begin                 //jz2024 added begin and end after the else
     Tv[31]:=MaxR(Tv[99],Tv[100]);
     Tv[31]:=MaxR(Tv[31],MaxR(Tv[10],Tv[11]));
     Tv[31]:=MaxR(Tv[31],Tv[12]);
   end;

   If (OtherThanQreAndQdt(RetNo)=True) then Tv[31]:=Tv[24];  //20211212

   Tv[16]:=Tv[31]+Tv[15];

   Tv[32] := tv[18];  //Tv[31];  //20120218


   Tv[9] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));

   //Tv[13]:= Vl(FetchElm(RetNo,'S8',43));  //20141231 //mjjz2024 seems wrong


   Strings[7]:=PrvConstant[RY].PrvDivRateBig;
   Strings[60]:= PrvConstant[RY].PrvDivRate;
   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813

   if CertificationMode=True then
   Begin
    s:=PrvConstant[RY].PrvDivRate;  //temp for test
    Strings[60]:=PrvConstant[RY].PrvDivRate;
    Strings[7]:=PrvConstant[RY].PrvDivRateBig; //20180108
   End;


   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'AB' then
   begin
     Tv[9]  := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;


   Tv[8]  := Tv[9] * Vl(Strings[7])/100;
   Tv[34] := Tv[33] * Vl(Strings[60])/100;
   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[8]+Tv[34]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[16]-Tv[38]);  //20170113
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',533))
   else
    Tv[40]:=0;


   // mjjz2024 -->>
   Tv[2] := Tv[39] + Tv[40];
   Strings[3] := FetchElm(RetNo,'T3MJ',64);
   Tv[4] := Tv[2] * vl(Strings[3])/100;
   Tv[5] := Tv[15] * (100 -  vl(Strings[3])) /100;


   Tv[41]:=Tv[4]+Tv[5];
   //showmessage(floattostr(Tv[41]));

   Tv[6] := Tv[8]+Tv[34];
   strings[17] := FormatFloat('###.##',100 - VL(strings[3]));
   Tv[19] := Tv[6] * vl(strings[17])/100;
   Tv[20] := Tv[19];
   Tv[29] := MaxR(0,Tv[41] - Tv[20]);

   Tv[51] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'AB' then Tv[51] := 0;  //only if resident //mjjz2024

   Tv[56]:=MaxR(0,Tv[29]-Tv[51]);  //mjjz2024


   // <<-- mjjz2024

   { //jz2024 no such thing
   //Instructions
   Frm[FNo].Strings[103] := '0.00';
   Tv[110]:=200;
   Tv[114]:=150;
   Tv[117]:=1100;
   Tv[121]:=600;
   Tv[123]:=1000;
   }
 end;



  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJBC(RetNo: integer; FName: String; FNo: integer);
Var i:Integer;
begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='BC';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('BC');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then
   begin
    For i:=1 to 130 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit; //20150101
   end;
   //initilize  columns
   For i:=2 to 22 do Tv[i]:=0;
   For i:=66 to 79 do Tv[i]:=0;
   For i:=85 to 90 do Tv[i]:=0;
   For i:=124 to 129 do Tv[i]:=0;


   //20170114
   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[23]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[24]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[25]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[26]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[27]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[28]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[29]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[29]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[91]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[92]:=FormatFloat('###,###',PrvBracket5);
       Ret[RetNo].Frm[FNo].Strings[119]:=FormatFloat('###,###',PrvBracket5);

       Ret[RetNo].Frm[FNo].Strings[56]:=FormatFloat('###,###',PrvBracket6);
       Ret[RetNo].Frm[FNo].Strings[118]:=FormatFloat('###,###',PrvBracket6);

       //20181106 Igor <<<

       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5] := '0.00';
       //20180226
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[67]:=PrvBracket3;
       Tv[74]:=PrvBracket4;
       Tv[86]:=PrvBracket5; //20181106 Igor  //20181129 con
       Tv[125]:=PrvBracket6;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[69]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[76]:= Vl(PrvConstant[RY].PrvRate5);
       Tv[88]:= Vl(PrvConstant[RY].PrvRate6); //20181106 Igor //20181129 con
       Tv[127]:= Vl(PrvConstant[RY].PrvRate7);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[71]:= PrvConstant[RY].PrvBracketTax4;
       Tv[78]:= PrvConstant[RY].PrvBracketTax5;
       Tv[90]:= PrvConstant[RY].PrvBracketTax6; //20181106 Igor //20181129 con
       Tv[129]:= PrvConstant[RY].PrvBracketTax7;

       //20201206
       Tv[32]:= 20.5; //20201206 /Vl(PrvConstant[RY].PrvRate6);

       Tv[36]:= 5.06;
       Tv[39]:= 16.8;
       Tv[93]:= 20.5;
       Tv[96]:= 5.06;
       Tv[99]:= 20.5;

       Strings[82]:= PrvConstant[RY].PrvDivRateBig;  //43.58;
       Strings[44]:= PrvConstant[RY].PrvDivRate;  //15.0; //

      //20231203
      if CertificationMode=True then
      Begin
       Strings[82]:= PrvConstant[RY].PrvDivRateBig;  //43.58;
       Strings[44]:= PrvConstant[RY].PrvDivRate;  //15.0; //
      End;


       Tv[47]:= 33.7; //PrvConstant[RY].PrvAmtCarryOverRate;
       //polit chart
       Tv[117]:=550;
       Tv[114]:=75;
       Tv[121]:=300;
       Tv[123]:=500;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   StoreElm(RetNo,FNo,17,'0.00'); //20180226
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2] - vl(Frm[FNo].Strings[5]) );
     Tv[14] := Tv[8] * Vl(Frm[FNo].Strings[11])/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Vl(Frm[FNo].Strings[12])/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
    and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[66] := Tv[1];
     Tv[68] := MaxR(0,Tv[66]-Tv[67]);
     Tv[70] := Tv[68] * Tv[69]/100;
     Tv[72] := Tv[70] + Tv[71];
   end;

   //20181106 Igor >>>  //20181129 con
   If (Tv[1] > PrvConstant[RY].PrvBracket4)
     and (Tv[1] <= PrvConstant[RY].PrvBracket5) then
   begin
     Tv[73] := Tv[1];
     Tv[75] := MaxR(0,Tv[73]-Tv[74]);
     Tv[77] := Tv[75] * Tv[76]/100;
     Tv[79] := Tv[77] + Tv[78];
   end;

   //20181129 con
   If (Tv[1] > PrvConstant[RY].PrvBracket5)
   and (Tv[1] <= PrvConstant[RY].PrvBracket6)
   then
   begin
     Tv[85] := Tv[1];
     Tv[87] := MaxR(0,Tv[85]-Tv[86]);
     Tv[89] := Tv[87] * Tv[88]/100;
     Tv[57] := Tv[89] + Tv[90];
   end;

   //20201207
   If (Tv[1] > PrvConstant[RY].PrvBracket6)
   then
   begin
     Tv[124] := Tv[1];
     Tv[126] := MaxR(0,Tv[124]-Tv[125]);
     Tv[128] := Tv[126] * Tv[127]/100;
     Tv[130] := Tv[128] + Tv[129];
   end;


  // Tv[32]:=20.5; //see top assignments //20201206 16.8;  //20170114  // 20181106 Igor
   If OtherThanQreAndQdt(RetNo)=True then
    Tv[31] := Tv[1]
   else
    Tv[31]:=0;
   Tv[33]:=Tv[31] * Tv[32]/100;

   Tv[34]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326

   If (IsQre(RetNo)) or (IsQdt(RetNo)) then
   Begin
    If Tv[34]>200 then
    begin
     Tv[35]:=200;
     Tv[38] :=MaxR(0,Tv[34]-200);
     Tv[30] := MinR(Tv[38],MaxR(0,Tv[1] - vl(strings[118])));  //jzmj2024_1
    end
    else
    begin
     Tv[35]:=Tv[34];
     Tv[38]:=0;
    end;

    if CertificationMode=false then  //20211204
    Begin
     Tv[37] := Tv[35] * Tv[36]/100;
     Tv[40] := Tv[38] * Tv[39]/100;
     Tv[41] := Tv[30] * Tv[93]/100; //jzmj2024_1 //Tv[41] := Tv[37]+Tv[40];

     Tv[94]:=Tv[37]+Tv[40]+Tv[41];
    End;
   end;

   If (OtherThanQreAndQdt(RetNo)=True) then  //If IsIntervivos(RetNo) then
   begin
     if Tv[34]>200 then
     Begin
      Tv[95]:=200;
      Tv[98]:=Tv[34]-200;
     end
     Else
     Begin
      Tv[95]:=Tv[34];
      Tv[98]:=0;
     End;
     Tv[97]:=Tv[95]*Tv[96]/100;
     Tv[100]:=Tv[98]*Tv[99]/100;
     Tv[105]:=Tv[97]+Tv[100];
   end
   Else
   Begin
    For i:=95 to 100 do begin Tv[i]:=0; end;
    Tv[105]:=0
   End;
   Tv[112]:=MaxR(Tv[94],Tv[105]);

   Tv[42] := MaxR(Tv[20],MaxR(Tv[21],Tv[22]));
   Tv[42] := MaxR(MaxR(Tv[42],Tv[72]),Tv[79]);
   Tv[42] := MaxR(Tv[42],Tv[57]);
   Tv[42] := MaxR(Tv[42],Tv[130]);

   If (OtherThanQreAndQdt(RetNo)=True) then Tv[42]:=Tv[33];  //20211212

   Tv[84]:=Tv[42]+Tv[59];  //20170113
   Tv[65] := Tv[112];
   Tv[83] := Vl(FetchElm(RetNo,'S8',34));
   Tv[43] := Vl(FetchElm(RetNo,'S8',35))+Vl(FetchElm(RetNo,'S8',43)); //20141231

   Tv[46] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));

   //mjjz2024 //residents only
   if Ret[RetNo].Province <> 'BC' then
   begin
     Tv[83] := 0;
     Tv[43] := 0;
     Tv[46] := 0;
   end;

   Tv[81]:= Tv[83] * vl(strings[82])/100;

   Tv[45]:= Tv[43] * vl(strings[44])/100;

   Tv[48] := Tv[46] * Tv[47]/100;

   Tv[49] := Tv[65]+Tv[81]+Tv[45]+Tv[48];
   Tv[50] := Tv[49];

   Tv[51] := MaxR(0,Tv[84]-Tv[50]);   //20170113

   Tv[60]:=Tv[51];    //20211125
   If SubjectToMinTax(RetNo) then
    Tv[52] :=  Vl(FetchElm(RetNo,'S12',538))
   else
    Tv[52]:=0;

   //mjjz2024 <<--
   Tv[63] := Tv[60]+Tv[52];

   strings[80] := FetchElm(RetNo,'T3MJ',71);

   Tv[101] := Tv[63] * vl(strings[80])/100;
   Tv[108] := TV[59] * (100 - VL(strings[80]));
   //mjjz2024 -->>

   Tv[53] := Tv[101]+Tv[108]; //mjjz2024

   //mjjz2024 <<--
   //res only
   if Ret[RetNo].Province = 'BC' then
   begin
     Tv[102] := Tv[81] + Tv[45];
     strings[103] := FormatFloat('##0.0000',100 - VL(strings[80]));
     TV[104] := TV[102] * (100 - VL(strings[103])/100);
   end
   else
   begin
     Tv[102] := 0;
     Tv[103] := 0;
     TV[104] := 0;
   end;

   TV[106] := TV[104];
   TV[107] := MaxR(0,Tv[53]-Tv[106]);
   //mjjz2024 -->>


   Tv[54] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'BC' then Tv[54] := 0;   //mjjz2024

   //mjjz2024
   if Ret[RetNo].Province = 'BC' then
    Tv[55] := MaxR(0,Tv[107] - Tv[54])
   else
    Tv[55] := Tv[53];

   TV[58] := Vl(FetchElm(RetNo,'PRVCR',2));

   //jz//20250805
   //Tv[62]:= MaxR(0,Tv[55]-Tv[58]);  //20230212
   Tv[64]:= MaxR(0,Tv[55]-Tv[58]);  //MaxR(0,Tv[62] - Tv[61]);


 end;

 {//mjjz2024 //not applicable?
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
    //Instructions
   Frm[FNo].Strings[103] := '0.00';
   StoreElm(RetNo,FNo,107,'0.00'); //20180226
   Tv[110]:=100;
   Tv[114]:=75;
   Tv[117]:=550;
   Tv[121]:=300;
   Tv[123]:=500;
 end;
 Ret[RetNo].Frm[FNo].Strings[17] := '0.00';
 Ret[RetNo].Frm[FNo].Strings[107] := '0.00';
 }

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJMB(RetNo: integer; FName: String; FNo: integer);
var i,k: integer;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='MB';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('MB');
// InitPRVDividendRates('MB');  //20201209 //part of above

 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,'MB') then //if Certificationmode=False then  //20211205
   Begin
    For i:=1 to 123 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit; //20150101
   end;

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[60]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[61]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[62]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket2);


       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;

       //20170305
       If (OtherThanQreAndQdt(RetNo)=True) then
          Tv[54]:= Vl(PrvConstant[RY].PrvRate3)
       else
          Tv[54]:=0;

       Tv[54]:=Vl(PrvConstant[RY].PrvRate3); //20191223

       Tv[55]:= PrvConstant[RY].PrvDonRate1;
       Tv[56]:= PrvConstant[RY].PrvDonRate2;

       Ret[RetNo].Frm[FNo].Strings[57]:= PrvConstant[RY].PrvDivRate;
       Ret[RetNo].Frm[FNo].Strings[33]:= PrvConstant[RY].PrvDivRateBig; //20201209


       if CertificationMode=True then //20231203
       Begin
        Ret[RetNo].Frm[FNo].Strings[57]:= PrvConstant[RY].PrvDivRate;
        Ret[RetNo].Frm[FNo].Strings[33]:= PrvConstant[RY].PrvDivRateBig; //20201209
       end;
       Ret[RetNo].Frm[FNo].Strings[66]:= PrvConstant[RY].PrvDivRateStart2013;

       Tv[58]:= PrvConstant[RY].PrvAmtCarryOverRate;
       Tv[59]:= 10.8; {%}
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
   begin
    Tv[23] := Tv[1];
    Tv[24] := Tv[23] * Tv[54]/100; //mjjz2024 moved from below
    Tv[20] := 0; Tv[21] := 0; Tv[22] := 0; //mjjz2024
   end
   else
    Tv[23]:=0;

   Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[55]/100;
   Tv[29] := Tv[28] * Tv[56]/100;
   Tv[30] := Tv[27] + Tv[29];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),Tv[22]);

   //jz//2025updateforgotenT3MJ
   //Tv[52] := //comes from a worksheet?? leave as vtuser input for now
   Tv[65] := Tv[31] + Tv[52];


   Tv[35] := Vl(FetchElm(RetNo,'S8',34));
   Tv[37] := Vl(FetchElm(RetNo,'S8',35));
   Tv[67] := Tv[65] * Vl(Ret[RetNo].Frm[FNo].Strings[66])/100;
      //Tv[67] := Tv[65] * Vl(Ret[RetNo].Frm[FNo].Strings[57])/100;
   Tv[39] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813

   //ONLY IF RESIDENT??
   if Ret[RetNo].Province <> 'MB' then
   begin
     Tv[35] := 0;
     Tv[37] := 0;
     Tv[39] := 0;
   end;

   Tv[34] := Tv[35] * Vl(Ret[RetNo].Frm[FNo].Strings[33])/100;
   Tv[38] := Tv[37] * Vl(Ret[RetNo].Frm[FNo].Strings[57])/100;
   Tv[40] := Tv[39] * Tv[58]/100;

   //20180227
   Tv[41]:= MaxR(0,2065-(GetTrustNetIncome(RetNo) *9/100));
   if Certificationmode=True then Tv[41]:=0; //20230212
   strings[59]:='10.8';
   Tv[42] := Tv[41]* vl(strings[59])/100;
   if Certificationmode=True then
      Tv[42]:=0; //20230212
   if (Ret[RetNo].Province <> 'MB') and (not usedInMJ(RetNo,FName)) then
      Tv[42]:=0;
   //If CertificationMode then Begin Tv[41]:=0; Tv[42]:=0;end;  //20120216
   If Tv[41]<0 then Tv[42]:=0;
   Tv[64] := MaxR(0,Tv[31]-Tv[42]);//20231121 //MaxR(0,Tv[66]-Tv[42]);
   Tv[36] := Tv[30];
   Tv[43] := Tv[36]+Tv[34]+Tv[38]+Tv[67]+Tv[40]; //20141231
   Tv[44] := Tv[43];
   Tv[45] := MaxR(0,Tv[64]-Tv[44]);

   If SubjectToMinTax(RetNo) then
    Tv[46] :=  Vl(FetchElm(RetNo,'S12',518))
   else
    Tv[46]:=0;

   Tv[47] := Tv[45]+Tv[46];


   strings[67] := FetchElm(RetNo,'T3MJ',50);
   Tv[68] := Tv[47] * VL(strings[67])/100;
   Tv[69] := Tv[34] + Tv[38];
   strings[70] := FormatFloat('#00.0000',(100 - VL(strings[67])));

   Tv[71] := Tv[69] * vl(strings[70]) / 100;
   Tv[51] := MaxR(0,Tv[68]-Tv[71]);
   Tv[72] := Tv[51];

   Tv[50] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'MB' then Tv[50] := 0;

   Tv[48] :=Vl(FetchElm(RetNo,'POLIT',102));
   Tv[49]:=CalcPolitCredit('MB',Tv[48]);
   Tv[51] := Tv[49]+Tv[50];
   Tv[52] := Tv[51];

   Tv[53] := MaxR(0,Tv[72] - Tv[74]);   //mjjz2024
 end;

  //instructions
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   Frm[FNo].Strings[103]:= '0.00';
   Tv[110]:=400;
   Tv[114]:=300;
   Tv[117]:=750;
   Tv[121]:=475;
   Tv[123]:=1000; //650; //20181207
  end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226

 SaveTv(RetNo, FName, FNo);
end;


//jz2025update-rev1: new form
Procedure T3NBSBI(RetNo: integer; FName: String; FNo: integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   //Tv[1]:=vtuser
   //Tv[2]:=vtuser
   Tv[3]:= Tv[1]+Tv[2];
   Tv[4]:= minr(Tv[3], 75000);

   if IsMultiJurisdiction(RetNo) then
      Tv[5]:= Vl(FetchElm(RetNo,'T3NB',68))
   else
      Tv[5]:= Vl(FetchElm(RetNo,'T3MJNB',68));

   Tv[6]:= minr(Tv[4],Tv[5]);

   Tv[7]:= Tv[3];
   Tv[8]:= Tv[6];
   Tv[9]:= Tv[7]-Tv[8];

   //Tv[10]:=vtuser
   //Tv[11]:=vtuser
   //Tv[12]:=vtuser

   Tv[13]:= Tv[10]+Tv[11]+Tv[12];
   Tv[14]:= Tv[13];
   Tv[15]:= Tv[9]-Tv[14];
 end;
end;

Procedure T3MJNB(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;
Begin


 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NB';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;


 InitPrvConstants('NB');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Certificationmode=False then  //20211205
   Begin For i:=1 to 54 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit; end;

   //many changes 20160211  thouout the routine
   With PrvConstant[RY] do
   begin
       Ret[RetNo].Frm[FNo].Strings[42]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[43]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[44]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[65]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[47]:=FormatFloat('###,###',PrvBracket3);
    //20231121   Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket4);
    //20231121   Ret[RetNo].Frm[FNo].Strings[84]:=FormatFloat('###,###',PrvBracket4);  //20170121
     //20170114
      // Ret[RetNo].Frm[FNo].Strings[49]:=FormatFloat('###,###',PrvBracket5);
      // Ret[RetNo].Frm[FNo].Strings[83]:=FormatFloat('###,###',PrvBracket5);

       Ret[RetNo].Frm[FNo].Strings[6]:= '0.00';
       Ret[RetNo].Frm[FNo].Strings[17]:= '0.00';  //20181209
       Tv[5]:=PrvBracket1;
       Tv[73]:=PrvBracket2;
       Tv[7]:=PrvBracket3;
     //  Tv[57]:=PrvBracket4;
     //  Tv[77]:=PrvBracket5;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[71]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate4);
     //  Tv[59]:= Vl(PrvConstant[RY].PrvRate5);
     //  Tv[79]:= Vl(PrvConstant[RY].PrvRate6);


       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[67]:= PrvConstant[RY].PrvBracketTax3;
       Tv[19]:= PrvConstant[RY].PrvBracketTax4;
     //  Tv[61]:= PrvConstant[RY].PrvBracketTax5;
     //  Tv[81]:= PrvConstant[RY].PrvBracketTax6;

       Tv[50]:= 19.50; //20231121//Vl(PrvConstant[RY].PrvRate6); //20160211
       Tv[51]:= PrvConstant[RY].PrvDonRate1;
       Tv[52]:= PrvConstant[RY].PrvDonRate2;
   end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[6]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[5]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;


   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[75] := Tv[1];
     Tv[72] := MaxR(0,Tv[75]-Tv[73]);
     Tv[70] := Tv[72] * Tv[71]/100;
     Tv[74] := Tv[70] + Tv[67];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   // and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

  {//20231121
    If (Tv[1] > PrvConstant[RY].PrvBracket4) then
   // and (Tv[1] <= PrvConstant[RY].PrvBracket5) then
   begin
     Tv[55] := Tv[1];
     Tv[58] := MaxR(0,Tv[55]-Tv[57]);
     Tv[60] := Tv[58] * Tv[59]/100;
     Tv[56] := Tv[60] + Tv[61];
   end;
  }
   {
   If (Tv[1] > PrvConstant[RY].PrvBracket5) then
   begin
     Tv[76] := Tv[1];
     Tv[78] := MaxR(0,Tv[76]-Tv[77]);
     Tv[80] := Tv[78] * Tv[79]/100;
     Tv[82] := Tv[80] + Tv[81];
   end;
   }

    Strings[53]:= PrvConstant[RY].PrvDivRate; //20201209
    Strings[62]:= PrvConstant[RY].PrvDivRateBig;
    if CertificationMode=True then
    Begin
      Ret[RetNo].Frm[FNo].Strings[53]:=PrvConstant[RY].PrvDivRate; //20231211
      Ret[RetNo].Frm[FNo].Strings[62]:=PrvConstant[RY].PrvDivRateBig; //20180108
    End;
    Tv[54]:= PrvConstant[RY].PrvAmtCarryOverRate;

  Tv[50] := 19.50; //jz 20240305 //20.30;  //20170114
  If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;

   Tv[24]:=Tv[23] * Tv[50]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 Tv[25]:= Vl(FetchElm(RetNo,'S11',38));

   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[51]/100;
   Tv[28] := Tv[29] * Tv[52]/100;
   Tv[30] := Tv[26]+Tv[28];

   If Tv[24]>0 then
     Tv[31] := Tv[24]
   else
   Begin
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[74],Tv[22]));
     Tv[31]:= MaxR(Tv[31],MaxR(Tv[56],Tv[82]));
   end;

   Tv[86]:=Tv[31]+Tv[85]; //20170114
   Tv[32] := Tv[30];

   //20160211
  // Tv[65] := Vl(FetchElm(RetNo,'S8',43)); ///20141231
  //Tv[67]:=Tv[65]*Tv[66]/100;

   Tv[64] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813
   if Ret[RetNo].Province <> 'NB' then
   begin
     Tv[64] := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;

   Tv[63] := Tv[64] * vl(strings[62])/100;
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[53])/100; // 20181106 Igor
   Tv[36] := Tv[35] * Tv[54]/100;

   Tv[37] := Tv[32]+Tv[63]+Tv[34]+Tv[36]; //Tv[32]+Tv[63]+Tv[34]+Tv[67]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[86]-Tv[38]);
   If SubjectToMinTax(RetNo) then
      Tv[40]:=Vl(FetchElm(RetNo,'S12',509))
   else
      Tv[40]:=0;
   If SubjectToMinTax(RetNo) then
    Tv[41] := Tv[40]
   else
    Tv[41]:= Tv[39];

  //mjjz2024 <<<
  strings[49] := FetchElm(RetNo,'T3MJ',29);
  Tv[76] := Tv[41] * vl(strings[49])/100;

  Tv[77] := Tv[85] * ( 1- (VL(strings[49])/100) );
  Tv[78] := Tv[76] + Tv[77];

  Tv[79] := Tv[63] + Tv[34];

  strings[80] := FormatFloat('##0.0000',100 - VL(strings[49])); //mjjz2024

  Tv[81] := Tv[79] * VL(strings[80])/100;
  Tv[82] := Tv[81];
  Tv[48] := MaxR(0,Tv[78] - Tv[82]);

  //mjjz2024 >>>

   Tv[45] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'NB' then //mjjz2024
    Tv[45] := 0;

   Tv[68]:=MaxR(0,Tv[48]-Tv[45]);  //20141231
   //Tv[69]=manual // mjjz2024 is vtcalc ????
   Tv[46] := MaxR(0,Tv[68] - Tv[69]);        //20141231
  end;

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJNL(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NL';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('NL');
 If Ret[RetNo].Frm[FNo].Count = 0 then
      InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   For i:=69 to 103 do Tv[i]:=0;  //20160321 //20160505 Igor

   //20160208  *** Revised whole routine to the end

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Ret[RetNo].Province <> 'NL' then  //20150101
   Begin
    //if Certificationmode=False then  //20211205
    //Begin
     For i:=1 to 103 do Tv[i]:=0;
     SaveTv(RetNo,FName,FNo);
     Exit;
    //end;  //20150101
   end;

   //20160208
   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[2]:=FormatFloat('###,###',PrvBracket1);

       Ret[RetNo].Frm[FNo].Strings[3] :=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[64]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[65]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket4);

       //jz2022
       //New begin ---------------------------------------------------------------
       Ret[RetNo].Frm[FNo].Strings[6] :=FormatFloat('###,###',PrvBracket5);
       Ret[RetNo].Frm[FNo].Strings[7] :=FormatFloat('###,###',PrvBracket5);
       Ret[RetNo].Frm[FNo].Strings[8] :=FormatFloat('###,###',PrvBracket6);
       Ret[RetNo].Frm[FNo].Strings[9] :=FormatFloat('###,###',PrvBracket6);
       Ret[RetNo].Frm[FNo].Strings[10]:=FormatFloat('###,###',PrvBracket7);
       Ret[RetNo].Frm[FNo].Strings[11]:=FormatFloat('###,###',PrvBracket7);
       //New end -----------------------------------------------------------------

       //showmessage (FormatFloat('###,###',PrvBracket4) + ' ' + FormatFloat('###,###',PrvBracket5) + ' ' + FormatFloat('###,###',PrvBracket6) + ' ' +  FormatFloat('###,###',PrvBracket7) );

       Ret[RetNo].Frm[FNo].Strings[74]:= '0.00';
       Ret[RetNo].Frm[FNo].Strings[94]:= '0.00';
       Tv[75]:=PrvBracket1;
       Tv[76]:=PrvBracket2;
       Tv[77]:=PrvBracket3;
       Tv[78]:=PrvBracket4;

       //jz2022
       //New begin ---------------------------------------------------------------
       Tv[15]:=PrvBracket5;
       Tv[16]:=PrvBracket6;
       Tv[17]:=PrvBracket7;
       //New end -----------------------------------------------------------------



       Tv[84]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[85]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[86]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[87]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[88]:= Vl(PrvConstant[RY].PrvRate5);

       //jz2022
       //New begin ---------------------------------------------------------------
       Tv[45]:= Vl(PrvConstant[RY].PrvRate6);
       Tv[46]:= Vl(PrvConstant[RY].PrvRate7);
       Tv[48]:= Vl(PrvConstant[RY].PrvRate8);
       //New end -----------------------------------------------------------------


       Tv[94]:= PrvConstant[RY].PrvBracketTax1;
       Tv[95]:= PrvConstant[RY].PrvBracketTax2;
       Tv[96]:= PrvConstant[RY].PrvBracketTax3;
       Tv[97]:= PrvConstant[RY].PrvBracketTax4;
       Tv[98]:= PrvConstant[RY].PrvBracketTax5;

       //jz2022
       //New begin ---------------------------------------------------------------
       Tv[52]:= PrvConstant[RY].PrvBracketTax6;
       Tv[53]:= PrvConstant[RY].PrvBracketTax7;
       Tv[54]:= PrvConstant[RY].PrvBracketTax8;
       //New end -----------------------------------------------------------------

       Tv[57]:= Vl(PrvConstant[RY].PrvRate8);  //jz2022
       Tv[58]:= PrvConstant[RY].PrvDonRate1;
       Tv[59]:= PrvConstant[RY].PrvDonRate2;

     end;
  end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[69] := Tv[1];
     Tv[79] := MaxR(0,Tv[69]-vl(Frm[FNo].Strings[74]));
     Tv[89] := Tv[79] * Tv[84]/100;
     Tv[99] := Tv[89] + Tv[94];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[70] := Tv[1];
     Tv[80] := MaxR(0,Tv[70]-Tv[75]);
     Tv[90] := Tv[80] * Tv[85]/100;
     Tv[100] := Tv[90] + Tv[95];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[71] := Tv[1];
     Tv[81] := MaxR(0,Tv[71]-Tv[76]);
     Tv[91] := Tv[81] * Tv[86]/100;
     Tv[101] := Tv[91] + Tv[96];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[72] := Tv[1];
     Tv[82] := MaxR(0,Tv[72]-Tv[77]);
     Tv[92] := Tv[82] * Tv[87]/100;
     Tv[102] := Tv[92] + Tv[97];
   end;


   If (Tv[1] > PrvConstant[RY].PrvBracket4)
   and (Tv[1] <= PrvConstant[RY].PrvBracket5) then //new jz2022
   begin
     Tv[73] := Tv[1];
     Tv[83] := MaxR(0,Tv[73]-Tv[78]);
     Tv[93] := Tv[83] * Tv[88]/100;
     Tv[103] := Tv[93] + Tv[98];
   end;


   //jz2022
   //New begin ---------------------------------------------------------------
   If (Tv[1] > PrvConstant[RY].PrvBracket5)
   and (Tv[1] <= PrvConstant[RY].PrvBracket6) then
   begin
     Tv[12] := Tv[1];
     Tv[18] := MaxR(0,Tv[12]-Tv[15]);
     Tv[49] := Tv[18] * Tv[45]/100;
     Tv[55] := Tv[49] + Tv[52];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket5)
   and (Tv[1] <= PrvConstant[RY].PrvBracket6) then
   begin
     Tv[13] := Tv[1];
     Tv[19] := MaxR(0,Tv[13]-Tv[16]);
     Tv[50] := Tv[19] * Tv[46]/100;
     Tv[62] := Tv[50] + Tv[53];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket5)
   and (Tv[1] <= PrvConstant[RY].PrvBracket6) then
   begin
     Tv[14]  := Tv[1];
     Tv[20]  := MaxR(0,Tv[14]-Tv[17]);
     Tv[51]  := Tv[20] * Tv[48]/100;
     Tv[104] := Tv[51] + Tv[54];
   end;

   //New end -----------------------------------------------------------------


   Tv[61]:= PrvConstant[RY].PrvAmtCarryOverRate;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[57]/100;

   Tv[25]:=Vl(FetchElm(RetNo,'S11A',15)); //20211217 //Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[29] := Tv[28] * Tv[59]/100;
   Tv[30] := Tv[27]+Tv[29];
   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[99],MaxR(Tv[100],Tv[101])),
            (MaxR(Tv[102],Tv[103])));

   Tv[5]:=Tv[31]+Tv[4]; //20170114
   Tv[32] := Tv[30];



   //20221128
   Ret[RetNo].Frm[FNo].Strings[44]:='22.88'; //PrvConstant[RY].PrvDivRateBig; //20231210 //FormatFloat('##.####',PrvConstant[RY].PrvDivRateBig); //20231210
   Tv[47]:= Tv[42] * Vl(Ret[RetNo].Frm[FNo].Strings[44])/100;  //Tv[44]/100;

   //20191206
   Ret[RetNo].Frm[FNo].Strings[60]:=PrvConstant[RY].PrvDivRate; //20231210 //FormatFloat('##.####',PrvConstant[RY].PrvDivRate); //20221128 //26.833
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[60])/100;


   Tv[42]:=Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := MaxR(0,Vl(FetchElm(RetNo,'S8',35)){-Tv[49]});  //20180108
   Tv[35] :=   Vl(FetchElm(RetNo,'S11',143)); // Vl(FetchElm(RetNo,'S11',43));  //20160813

   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'NL' then
   begin
     Tv[42]  := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;

   Tv[61]:=58; //20180107 54.7;   //20170114
   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[47]+{Tv[51]+}Tv[34]+Tv[36];  //20170119
   // 20181106 Igor <<<
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[5]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',503))
   else
    Tv[40]:=0;
   Tv[41] := Tv[39]+Tv[40];

   //mjjz2024 <<<
   strings[107] := FetchElm(RetNo,'T3MJ',8);
   Tv[106] := Tv[41] * vl(strings[107])/100;

   Tv[105] := Tv[4] * (100 - (vl(strings[107])/100));
   Tv[108] := Tv[106]+Tv[105];
   Tv[109] := Tv[47]+Tv[34];

   strings[110] := FormatFloat('##0.0000',100 - VL(strings[107]));

   Tv[111] := Tv[109] * (vl(strings[110])/100);
   Tv[112] := Tv[111];
   Tv[113] := MaxR(0,Tv[108] - Tv[112]);
   //mjjz2024 >>>


   Tv[43] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'NL' then Tv[43] := 0;   //mjjz2024

   Tv[56] := MaxR(0,Tv[113] - Tv[43]); //mjjz2024
 end;

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJNU(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NU';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('NU');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);


   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then //if Certificationmode=False then  //20211205
   Begin
    For i:=1 to 116 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit; //20150101
   end;

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[47]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[49]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[50]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[51]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[52]:=FormatFloat('###,###',PrvBracket3);


       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[57]:=PrvBracket3;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[59]:= Vl(PrvConstant[RY].PrvRate4);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[61]:= PrvConstant[RY].PrvBracketTax4;

       Tv[63]:= Vl(PrvConstant[RY].PrvRate4); //PrvConstant[RY].PrvIntervivosRate;
       Tv[64]:= PrvConstant[RY].PrvDonRate1;
       Tv[65]:= PrvConstant[RY].PrvDonRate2;
       Strings[66]:= PrvConstant[RY].PrvDivRate;
       Strings[68]:= PrvConstant[RY].PrvDivRateBig;

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[66]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[68]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[67]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[55] := Tv[1];
     Tv[58] := MaxR(0,Tv[55]-Tv[57]);
     Tv[60] := Tv[58] * Tv[59]/100;
     Tv[56] := Tv[60] + Tv[61];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[63]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[64]/100;
   Tv[28] := Tv[29] * Tv[65]/100;
   Tv[30] := Tv[26]+Tv[28];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[56]));

   Tv[32] := Tv[30];

   Tv[69] := Tv[70] * vl(strings[68])/100;
   Tv[34] := Tv[33] * vl(strings[66])/100;

   Tv[70] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35))+Vl(FetchElm(RetNo,'S8',43)); //20141231
   Tv[35] :=  Vl(FetchElm(RetNo,'S11',143));  //20160813


   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'NU' then
   begin
     Tv[70]  := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;


   Tv[36] := Tv[35] * Tv[67]/100;

   Tv[37] := Tv[32]+Tv[69]+Tv[34]+Tv[36];
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[31]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',539))
   else
    Tv[40]:=0;

   //mjjz2024 <<<
   Tv[84] := Tv[39]+Tv[40];
   strings[72] := FetchElm(RetNo,'T3MJ',106);
   Tv[71] := Tv[84] * vl(strings[72])/100;
   Tv[74] := Tv[44] * (100 - (vl(strings[72])/100));

   Tv[41]:=Tv[71]+Tv[74];
   {If SubjectToMinTax(RetNo) then
    Tv[41] := Tv[40]
   else
    Tv[41]:= Tv[39];
   }

   Tv[75] := Tv[69]+Tv[34];
   strings[76] := FormatFloat('##0.0000',100 - VL(strings[72]));
   Tv[77] := Tv[75] * vl(strings[76])/100;
   Tv[78] := Tv[77];
   Tv[73] := MaxR(0,Tv[41] - Tv[78]);


   Tv[45] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'NU' then Tv[45] := 0;

   Tv[42] :=Vl(FetchElm(RetNo,'POLIT',130));

   Tv[43]:=CalcPolitCredit('NU',Tv[42]);
   Tv[54] := Tv[45]+Tv[43]; //+Tv[44]; 20120212
   Tv[62] := Tv[54];
   Tv[46] := MaxR(0,Tv[73] - Tv[62]);

   Tv[110]:=400;
   Tv[114]:=300;
   Tv[117]:=750;
   Tv[121]:=475;
   Tv[123]:=650;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Frm[FNo].Strings[103]:= '0.00';
  Tv[110]:=100;
  Tv[114]:=100;
  Tv[116]:=500;
 end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226   //WHY??
 StoreElm(RetNo,FNo,107,'0.00'); //20180226

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJNS(RetNo: integer; FName: String; FNo: integer);
Var i:integer;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NS';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('NS');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Certificationmode=False then  //20211205
   Begin
    For i:=1 to 67 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit; //20150101
   End;

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[60]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[61]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[62]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[63]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[42]:=FormatFloat('###,###',PrvBracket3);  //20110210
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[72]:=FormatFloat('###,###',PrvBracket4);

       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[57]:=PrvBracket3;
       Tv[74]:=PrvBracket4;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[59]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[76]:= Vl(PrvConstant[RY].PrvRate5);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[65]:= PrvConstant[RY].PrvBracketTax4;
       Tv[78]:= PrvConstant[RY].PrvBracketTax5;

       Tv[50]:= Vl(PrvConstant[RY].PrvRate5); //PrvConstant[RY].PrvIntervivosRate;
       Tv[51]:= PrvConstant[RY].PrvDonRate1;
       Tv[52]:= PrvConstant[RY].PrvDonRate2;

       Strings[53]:= PrvConstant[RY].PrvDivRate;
       Strings[69]:= PrvConstant[RY].PrvDivRateBig;
       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[53]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[69]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;


       Tv[50]:=Vl(PrvConstant[RY].PrvRate5); //PrvConstant[RY].PrvIntervivosRate;

       Tv[54]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
   and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3)
   and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[56] := Tv[1];
     Tv[58] := MaxR(0,Tv[56]-Tv[57]);
     Tv[64] := Tv[58] * Tv[59]/100;
     Tv[66] := Tv[64] + Tv[65];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket4) then
   begin
     Tv[73] := Tv[1];
     Tv[75] := MaxR(0,Tv[73]-Tv[74]);
     Tv[77] := Tv[75] * Tv[76]/100;
     Tv[79] := Tv[77] + Tv[78];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[50]/100;

   Tv[25]:=Vl(FetchElm(RetNo,'S11A',15));  //20170326  Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[51]/100;
   Tv[28] := Tv[29] * Tv[52]/100;
   Tv[30] := Tv[26]+Tv[28];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
   begin        //20110210
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[66]));
     Tv[31]:=MaxR(Tv[31],Tv[79]);
   end;
   Tv[44]:=Tv[31]+Tv[43]; //20170113

   Tv[32] := Tv[30];

   Tv[71] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35))+Vl(FetchElm(RetNo,'S8',43)); //20141231


   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'NS' then
   begin
     Tv[71] := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;

   Tv[70] := Tv[71] * vl(Strings[69])/100;
   Tv[34] := Tv[33] * vl(Strings[53])/100;

   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); //Vl(FetchElm(RetNo,'S11',43));  //20160813

   Tv[36] := Tv[35] * Tv[54]/100;
   Tv[37] := Tv[32]+Tv[70]+Tv[34]+Tv[36];
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[44]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',506))
   else
    Tv[40]:=0;

   //mjjz2024 <<<
   Tv[82] := Tv[39] + Tv[40];
   strings[81] := FetchElm(RetNo,'T3MJ',22);
   Tv[80] := Tv[82] * vl(strings[81])/100;

   Tv[83] := Tv[43] * (100 - (VL(strings[81])/100));

   Tv[41] := Tv[80]+Tv[83];


   Tv[84] := Tv[70]+Tv[34];
   strings[85] := FormatFloat('##0.0000',100 - VL(strings[81])); //mjjz2024
   Tv[86] := Tv[84] * vl(strings[85])/100;
   Tv[87] := Tv[86];
   Tv[88] := MaxR(0,Tv[41] - Tv[87]);

   Tv[45] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'NS' then Tv[45]:=0;

   Tv[46] :=Vl(FetchElm(RetNo,'POLIT',82));

   Tv[47]:=CalcPolitCredit('NS',Tv[46]);

   Tv[55]:= Tv[45]+Tv[47];
   Tv[48] := Tv[55];
   Tv[49] := MaxR(0,Tv[88] - Tv[48]);
 end;
 //mjjz2024 why is this? commented out //StoreElm(RetNo,FNo,17,'0.00'); //20180226 ?????

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJPE(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='PE';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('PE');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Certificationmode=False then  //20211205
   Begin
    For i:=1 to 123 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit; //20150101
   end;

   With PrvConstant[RY] do
      begin
       //jz//2025updateforgotenT3MJ - clear bracket columns
       For i:=2  to 22 do Tv[i]:=0; For i:=81 to 94 do Tv[i]:=0;

       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[69]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[77]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[78]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[79]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[80]:=FormatFloat('###,###',PrvBracket4);

       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]  :=PrvBracket1;
       Tv[7]  :=PrvBracket2;
       Tv[83] :=PrvBracket3;  //jz//2025updateforgotenT3MJ
       Tv[84] :=PrvBracket4;  //jz//2025updateforgotenT3MJ

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[87]:= Vl(PrvConstant[RY].PrvRate4); //jz//2025updateforgotenT3MJ
       Tv[88]:= Vl(PrvConstant[RY].PrvRate5); //jz//2025updateforgotenT3MJ

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[91]:= PrvConstant[RY].PrvBracketTax4; //jz//2025updateforgotenT3MJ
       Tv[92]:= PrvConstant[RY].PrvBracketTax5; //jz//2025updateforgotenT3MJ

       Tv[57]:= Vl(PrvConstant[RY].PrvRate5); //jz//2025updateforgotenT3MJ
       Tv[58]:= PrvConstant[RY].PrvDonRate1;
       Tv[59]:= PrvConstant[RY].PrvDonRate2;

       Strings[60]:= PrvConstant[RY].PrvDivRate;
       Strings[49]:= PrvConstant[RY].PrvDivRateBig;
       Strings[55]:= PrvConstant[RY].PrvDivRateStart2013;

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[60]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[49]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[61]:= PrvConstant[RY].PrvAmtCarryOverRate;

     end;
  end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;
   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;
   If (Tv[1] > PrvConstant[RY].PrvBracket2)             //jz//2025updateforgotenT3MJ
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;
   If (Tv[1] > PrvConstant[RY].PrvBracket3)             //jz//2025updateforgotenT3MJ
    and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[81] := Tv[1];
     Tv[85] := MaxR(0,Tv[81]-Tv[83]);
     Tv[89] := Tv[85] * Tv[87]/100;
     Tv[93] := Tv[89] + Tv[91];
   end;
   If (Tv[1] > PrvConstant[RY].PrvBracket4) then        //jz//2025updateforgotenT3MJ
   begin
     Tv[82] := Tv[1];
     Tv[86] := MaxR(0,Tv[82]-Tv[84]);
     Tv[90] := Tv[86] * Tv[88]/100;
     Tv[94] := Tv[90] + Tv[92];
   end;


   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[57]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 //Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[29] := Tv[28] * Tv[59]/100;
   Tv[30] := Tv[27]+Tv[29];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(MaxR(MaxR(Tv[20],Tv[21]),Tv[22]),Tv[93]),Tv[94]);  //jz//2025updateforgotenT3MJ - add Tv[93],[94]

   Tv[55]:=Tv[31]+Tv[54];

   Tv[32] := Tv[30];



   Tv[53] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[35] :=  Vl(FetchElm(RetNo,'S11',143));  //20160813
   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'PE' then
   begin
     Tv[53]  := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;

   Tv[54] := Vl(FetchElm(RetNo,'S8',43));  //20141231
   Tv[50] := Tv[53] * vl(strings[49])/100;
   Tv[34] := Tv[33] * vl(strings[60])/100;

   //Tv[62] := Tv[54] * Tv[55]/100;

   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[50]+Tv[34]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[55]-Tv[38]); //20160106
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',525))
   else
    Tv[40]:=0;

   Tv[41] := Tv[39]+Tv[40];

   //mjjz2024 <<<
   strings[45] := FetchElm(RetNo,'T3MJ',15);
   Tv[46] := Tv[41] * vl(strings[45])/100;
   Tv[48] := Tv[54] * (100 - (vl(strings[45])/100));


   Tv[62] := Tv[46]+Tv[48];

   Tv[63] := Tv[50]+Tv[34];

   strings[64] := FormatFloat('##0.0000',100 - VL(strings[45]));
   Tv[65] := Tv[63] * vl(strings[64])/100;
   Tv[70] := Tv[65];
   Tv[71] := MaxR(0,Tv[62] - Tv[70]);

   Tv[72] := Tv[41];
   Tv[73] := 12500; // base amount??
   Tv[74] := MaxR(0,Tv[72] - Tv[73]);
   strings[75] := '10'; // rate??
   Tv[76] := Tv[74] * vl(strings[75])/100;

   Tv[47] := Tv[76] * vl(strings[45])/100;//Tv[41];

   Tv[51] := Tv[47];
   Tv[42] := Tv[71] + Tv[51];

   Tv[43] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'PE' then Tv[43] := 0;  //only if resident //mjjz2024

   Tv[44] := MaxR(0,Tv[42] - Tv[43]);

   //mjjz2024 >>>

   {
   Tv[51] := MaxR(0,(Tv[47]-12500) * 10/100);
   Tv[51]:=MaxR(0,(Tv[47]-12500) * 10/100);
   If RY=1 then Tv[51]:=MaxR(0,(Tv[47]-12500) * 10/100);  //2013
   Tv[42]:= Tv[41]+Tv[51];

   Tv[43] := GetPrvForTaxCredit(RetNo);

   Tv[44] :=Vl(FetchElm(RetNo,'POLIT',52));
   Tv[45]:=CalcPolitCredit('PE',Tv[44]);
   Tv[46] := Tv[43]+Tv[45];
   Tv[52] := Tv[46];
   Tv[56] := MaxR(0,Tv[42] - Tv[52]);
   }
 end;

 //Intructions
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   Frm[FNo].Strings[103]:= '0.00';
   Tv[110]:=100;
   Tv[114]:=75;
   Tv[117]:=550;
   Tv[121]:=300;
   Tv[123]:=500;
 end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJSK(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;
Begin

 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='SK';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('SK');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin

   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Certificationmode=False then  //20211205
   Begin
    For i:=1 to 123 do Tv[i]:=0; SaveTv(RetNo,FName,FNo);Exit; //20150101
   end;

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[66]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[67]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[68]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[69]:=FormatFloat('###,###',PrvBracket2);

       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;

       Tv[57]:= Vl(PrvConstant[RY].PrvRate3); //PrvConstant[RY].PrvIntervivosRate;
       Tv[58]:= PrvConstant[RY].PrvDonRate1;
       Tv[59]:= PrvConstant[RY].PrvDonRate2;

       Ret[Retno].Frm[Fno].Strings[60]:= PrvConstant[RY].PrvDivRate; //20170121
       Ret[Retno].Frm[Fno].Strings[49]:= PrvConstant[RY].PrvDivRateBig;
       Strings[55]:= PrvConstant[RY].PrvDivRateStart2013;

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[60]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[49]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[61]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
  end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[57]/100;

   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11',38));

   If Tv[25]>200 then
   begin
    Tv[26]:=200;
    Tv[28] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[26]:=Tv[25];
    Tv[28]:=0;
   end;
   Tv[27] := Tv[26] * Tv[58]/100;
   Tv[29] := Tv[28] * Tv[59]/100;
   Tv[30] := Tv[27]+Tv[29];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),Tv[22]);

   Tv[48]:=Tv[31]+Tv[47];  //20170113
   Tv[32] := Tv[30];

   Tv[53] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[35] := Vl(FetchElm(RetNo,'S11',143)); // Vl(FetchElm(RetNo,'S11',43)); //20160813
   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'SK' then
   begin
     Tv[53]  := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;

   Tv[54] := Vl(FetchElm(RetNo,'S8',43));  //20141231
   Tv[50] := Tv[53] * Vl(Ret[Retno].Frm[FNo].Strings[49])/100;   //20170121
   Tv[34] := Tv[33] * Vl(Ret[Retno].Frm[FNo].Strings[60])/100; //Tv[60]/100;  //20170121
   Tv[62] := Tv[54] * Tv[55]/100;    //20141231
   Tv[36] := Tv[35] * Tv[61]/100;

   Tv[37] := Tv[32]+Tv[50]+Tv[34]+Tv[62]+Tv[36];  //20141231
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[48]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',528))
   else
    Tv[40]:=0;

   //mjjz2024 <<<
   Tv[41] := Tv[39]+Tv[40];
   strings[43] := FetchElm(RetNo,'T3MJ',57);
   Tv[44] := Tv[41] * vl(strings[43])/100;
   Tv[45] := Tv[47] * (100 - (vl(strings[43])/100));
   Tv[46] := Tv[44]+Tv[45];

   Tv[42] := Tv[50]+Tv[34];
   strings[51] := FormatFloat('##0.0000',100 - VL(strings[43]));
   Tv[52] := Tv[42] * vl(strings[51])/100;
   Tv[56] := Tv[52];
   Tv[72] := MaxR(0,Tv[46] - Tv[56]);

   Tv[70] := GetPrvForTaxCredit(RetNo);  //???
   if Ret[RetNo].Province <> 'SK' then Tv[70] := 0;

//   Tv[55] := // ???
   Tv[54] := Tv[70]+Tv[55];
   Tv[65] := Tv[54];
   Tv[78] := MaxR(0,Tv[72] - Tv[65]);
//   Tv[63] := // ???
   Tv[79] := Tv[78]+Tv[63];
//   Tv[71] := // ???





   Tv[64] := MaxR(0,Tv[79] - Tv[71]);
   //Tv[64] := MaxR(0,Tv[79] - Tv[73]);





//   Tv[62] := CalcPolitCredit('SK',Tv[xx]); // ???

   {
   Tv[41] := MaxR(0,Tv[39],Tv[40]);
   TV[42] := Vl(FetchElm(RetNo,'PRVCR',4));
   TV[43] := Vl(FetchElm(RetNo,'PRVCR',5));
   Tv[51] := GetPrvForTaxCredit(RetNo);

   Tv[44] :=Vl(FetchElm(RetNo,'POLIT',140));
   Tv[45]:=CalcPolitCredit('SK',Tv[44]);
   Tv[46] := Tv[51]+Tv[45]+Tv[42]+Tv[43]; //20230212
   Tv[52] := Tv[46];
   Tv[56] := MaxR(0,Tv[41] - Tv[52]);
   }
  end;
  //Intructions
  With Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
   Frm[FNo].Strings[103]:= '0.00';
   Tv[110]:=400;
   Tv[114]:=300;
   Tv[117]:=750;
   Tv[121]:=475;
   Tv[123]:=650;
  end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJYT(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='YT';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;
 InitPrvConstants('YT');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Certificationmode=False then  //20211205
   Begin
      For i:=1 to 123 do Tv[i]:=0;
      SaveTv(RetNo,FName,FNo);
      Exit;
   end;

   //Changed a lot 20160209
   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[47]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[49]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[77]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[76]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[50]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[51]:=FormatFloat('###,###',PrvBracket4);
       Ret[RetNo].Frm[FNo].Strings[52]:=FormatFloat('###,###',PrvBracket4);


       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[82]:=PrvBracket2;
       Tv[7]:=PrvBracket3;
       Tv[57]:=PrvBracket4;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[80]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate4);
       Tv[59]:= Vl(PrvConstant[RY].PrvRate5);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[78]:= PrvConstant[RY].PrvBracketTax3;
       Tv[19]:= PrvConstant[RY].PrvBracketTax4;
       Tv[61]:= PrvConstant[RY].PrvBracketTax5;

       Tv[44]:= Vl(PrvConstant[RY].PrvRate5); //PrvConstant[RY].PrvIntervivosRate;
       Tv[53]:= PrvConstant[RY].PrvDonRate1;
       Tv[62]:= PrvConstant[RY].PrvDonRate2;

       Strings[63]:= PrvConstant[RY].PrvDivRate;
       Strings[70]:= PrvConstant[RY].PrvDivRateBig;
       if CertificationMode=True then
       Begin
        Ret[RetNo].Frm[FNo].Strings[63]:=PrvConstant[0].PrvDivRate;
        Ret[RetNo].Frm[FNo].Strings[70]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[67]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[84] := Tv[1];
     Tv[81] := MaxR(0,Tv[84]-Tv[82]);
     Tv[79] := Tv[81] * Tv[80]/100;
     Tv[83] := Tv[79] + Tv[78];
   end;


   If (Tv[1] > PrvConstant[RY].PrvBracket3)
    and (Tv[1] <= PrvConstant[RY].PrvBracket4) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket4) then
   begin
     Tv[55] := Tv[1];
     Tv[58] := MaxR(0,Tv[55]-Tv[57]);
     Tv[60] := Tv[58] * Tv[59]/100;
     Tv[56] := Tv[60] + Tv[61];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;
   Tv[24]:=Tv[23] * Tv[44]/100;

   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326 Tv[25]:= Vl(FetchElm(RetNo,'S11',38));
   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[53]/100;
   Tv[28] := Tv[29] * Tv[62]/100;
   Tv[30] := Tv[26]+Tv[28];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
   begin
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[83],Tv[22]));
     Tv[31]:=MaxR(Tv[31],Tv[56]);
   end;
   Tv[66]:=Tv[31]+Tv[45]; //20170113
  //-------------------------------
   Tv[32] := Tv[30];



   Tv[72] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[35] := Vl(FetchElm(RetNo,'S11',143));
   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'YT' then
   begin
    Tv[72] := 0;
    Tv[33] := 0;
    Tv[35] := 0;
   end;

   //Tv[73] := Vl(FetchElm(RetNo,'S8',43)); //20141231 //mjjz2024 ?????
   Tv[71] := Tv[72] * vl(strings[70])/100;
   Tv[34] := Tv[33] * Tv[63]/100;
   //Tv[75] := Tv[73] * Tv[74]/100;  //20141231 //mjjz2024 ?????
   Tv[36] := Tv[35] * Tv[67]/100;
   Tv[37] := Tv[32]+Tv[71]+Tv[34]+Tv[36];//Tv[32]+Tv[71]+Tv[34]+tv[75]+Tv[36]; //20191217
   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[31]-Tv[38]);
   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',545))
   else
    Tv[40]:=0;
   Tv[41] := Tv[39]+Tv[40];

    //mjjz2024 <<<
   strings[68] := FetchElm(RetNo,'T3MJ',78);
   Tv[74] := Tv[41] * vl(strings[68])/100;
   Tv[75] := Tv[45] * (100 - (vl(strings[68])/100));

   Tv[73] := Tv[74]+Tv[75];

   Tv[85] := Tv[71]+Tv[34];
   strings[86] := FormatFloat('##0.0000',100 - VL(strings[68]));
   Tv[87] := Tv[85] * vl(strings[86])/100;
   Tv[88] := Tv[87];
   Tv[89] := MaxR(0,Tv[73] - Tv[88]);
   //mjjz2024 >>>

   Tv[65] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'YT' then Tv[65] := 0; //mjjz2024

   Tv[42] :=Vl(FetchElm(RetNo,'POLIT',122));

   Tv[43]:=CalcPolitCredit('YT',Tv[42]);
   Tv[54] := Tv[65]+Tv[43];
   Tv[64] := Tv[54];
   Tv[46] := MaxR(0,Tv[89] - Tv[64]);
 end;

 //Instructions
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Frm[FNo].Strings[103]:= '0.00';
  Tv[110]:=400;
  Tv[114]:=300;
  Tv[117]:=750;
  Tv[121]:=475;
  Tv[123]:=650;
 end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226
 StoreElm(RetNo,FNo,107,'0.00'); //20180226

  SaveTv(RetNo, FName, FNo);
end;

Procedure T3MJNT(RetNo: integer; FName: String; FNo: integer);
Var i:integer;x,y,z:real;
Begin
 if Certificationmode=True then   //20231203
 Begin
  Ret[RetNo].Province:='NT';
  Ret[RetNo].FrmHasdata[FNo]:=True;
 end;

 InitPrvConstants('NT');
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
   Tv[1]:= GetTrustTxbl(RetNo);

   If not CalcThisMJProvince(RetNo,RightStr(FName,2)) then  //if Certificationmode=False then  //20211205
   Begin
    For i:=1 to 116 do Tv[i]:=0;SaveTv(RetNo,FName,FNo);Exit; //20150101
   end;

   With PrvConstant[RY] do
      begin
       Ret[RetNo].Frm[FNo].Strings[47]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[48]:=FormatFloat('###,###',PrvBracket1);
       Ret[RetNo].Frm[FNo].Strings[49]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[50]:=FormatFloat('###,###',PrvBracket2);
       Ret[RetNo].Frm[FNo].Strings[51]:=FormatFloat('###,###',PrvBracket3);
       Ret[RetNo].Frm[FNo].Strings[52]:=FormatFloat('###,###',PrvBracket3);


       //Tv[5] := 0;
       Ret[RetNo].Frm[FNo].Strings[5]:= '0.00';
       Tv[6]:=PrvBracket1;
       Tv[7]:=PrvBracket2;
       Tv[57]:=PrvBracket3;

       Tv[11]:= Vl(PrvConstant[RY].PrvRate1);
       Tv[12]:= Vl(PrvConstant[RY].PrvRate2);
       Tv[13]:= Vl(PrvConstant[RY].PrvRate3);
       Tv[59]:= Vl(PrvConstant[RY].PrvRate4);

       Tv[17]:= PrvConstant[RY].PrvBracketTax1;
       Tv[18]:= PrvConstant[RY].PrvBracketTax2;
       Tv[19]:= PrvConstant[RY].PrvBracketTax3;
       Tv[61]:= PrvConstant[RY].PrvBracketTax4;

       Tv[63]:= Vl(PrvConstant[RY].PrvRate4); //PrvConstant[RY].PrvIntervivosRate;
       Tv[62]:= PrvConstant[RY].PrvDonRate1;
       Tv[65]:= PrvConstant[RY].PrvDonRate2;

       Ret[RetNo].Frm[FNo].Strings[66]:= PrvConstant[RY].PrvDivRate;
       Ret[RetNo].Frm[FNo].Strings[68]:=PrvConstant[RY].PrvDivRateBig;  //20120216

       if CertificationMode=True then
       Begin
         Ret[RetNo].Frm[FNo].Strings[66]:=PrvConstant[0].PrvDivRate;
         Ret[RetNo].Frm[FNo].Strings[68]:=PrvConstant[RY].PrvDivRateBig; //20180108
       End;

       Tv[67]:= PrvConstant[RY].PrvAmtCarryOverRate;
     end;
 end;

 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
   If Tv[1] <= PrvConstant[RY].PrvBracket1 then
   begin
     Tv[2] := Tv[1];
     Tv[8] := MaxR(0,Tv[2]-vl(Frm[FNo].Strings[5]));
     Tv[14] := Tv[8] * Tv[11]/100;
     Tv[20] := Tv[14] + Tv[17];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket1)
    and (Tv[1] <= PrvConstant[RY].PrvBracket2) then
   begin
     Tv[3] := Tv[1];
     Tv[9] := MaxR(0,Tv[3]-Tv[6]);
     Tv[15] := Tv[9] * Tv[12]/100;
     Tv[21] := Tv[15] + Tv[18];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket2)
    and (Tv[1] <= PrvConstant[RY].PrvBracket3) then
   begin
     Tv[4] := Tv[1];
     Tv[10] := MaxR(0,Tv[4]-Tv[7]);
     Tv[16] := Tv[10] * Tv[13]/100;
     Tv[22] := Tv[16] + Tv[19];
   end;

   If (Tv[1] > PrvConstant[RY].PrvBracket3) then
   begin
     Tv[55] := Tv[1];
     Tv[58] := MaxR(0,Tv[55]-Tv[57]);
     Tv[60] := Tv[58] * Tv[59]/100;
     Tv[56] := Tv[60] + Tv[61];
   end;

   If OtherThanQreAndQdt(RetNo)=True then
    Tv[23] := Tv[1]
   else
    Tv[23]:=0;

   Tv[24]:=Tv[23] * Tv[63]/100;
   Tv[25]:= Vl(FetchElm(RetNo,'S11A',15));  //20170326  Tv[25]:= Vl(FetchElm(RetNo,'S11',25));
   If Tv[25]>200 then
   begin
    Tv[27]:=200;
    Tv[29] :=MaxR(0,Tv[25]-200);
   end
   else
   begin
    Tv[27]:=Tv[25];
    Tv[29]:=0;
   end;
   Tv[26] := Tv[27] * Tv[62]/100;
   Tv[28] := Tv[29] * Tv[65]/100;
   Tv[30] := Tv[26]+Tv[28];

   If OtherThanQreAndQdt(RetNo)=True then
     Tv[31] := Tv[24]
   else
     Tv[31] := MaxR(MaxR(Tv[20],Tv[21]),MaxR(Tv[22],Tv[56]));

   Tv[53] := Tv[31]+Tv[44];
   Tv[32] := Tv[30];

   Tv[70] := Vl(FetchElm(RetNo,'S8',34));
   Tv[33] := Vl(FetchElm(RetNo,'S8',35));
   Tv[35] :=  Vl(FetchElm(RetNo,'S11',143));
   //only if resident //mjjz2024
   if Ret[RetNo].Province <> 'NT' then
   begin
     Tv[70]  := 0;
     Tv[33] := 0;
     Tv[35] := 0;
   end;

   Tv[69] := Tv[70] * Vl(Ret[RetNo].Frm[FNo].Strings[68])/100;
   Tv[34] := Tv[33] * Vl(Ret[RetNo].Frm[FNo].Strings[66])/100;
   Tv[36] := Tv[35] * Tv[67]/100;

   Tv[37] := Tv[32]+Tv[69]+Tv[34];

   Tv[38] := Tv[37];
   Tv[39] := MaxR(0,Tv[53]-Tv[38]);

   If SubjectToMinTax(RetNo) then
    Tv[40] :=  Vl(FetchElm(RetNo,'S12',542))
   else
    Tv[40]:=0;

   //mjjz2024 <<<
   Tv[71] := Tv[39]+Tv[40];
   strings[72] := FetchElm(RetNo,'T3MJ',85);
   Tv[73] := Tv[71] * vl(strings[72])/100;
   Tv[74] := Tv[44] * (100 - VL(strings[72])/100);

   Tv[41] := Tv[73] + Tv[74];

   Tv[75] := Tv[69]+Tv[34];
   strings[76] := FormatFloat('##0.0000',100 - VL(strings[72]));
   Tv[77] := Tv[75] * vl(strings[76])/100;
   Tv[78] := Tv[77];
   Tv[79] := MaxR(0,Tv[41] - Tv[78]);

   if Ret[RetNo].Province <> 'NT' then
   begin Tv[75]  := 0; strings[76] := ''; Tv[77] := 0; end;
   //mjjz2024 >>>

   Tv[45] := GetPrvForTaxCredit(RetNo);
   if Ret[RetNo].Province <> 'NT' then Tv[45] := 0;

   Tv[42] :=Vl(FetchElm(RetNo,'POLIT',62));

   Tv[43]:=CalcPolitCredit('NT',Tv[42]);
   Tv[54] := Tv[45]+Tv[43];
   Tv[64] := Tv[54];
   Tv[46] := MaxR(0,Tv[79] - Tv[64]);
 end;
 //Instructions
 With Ret[RetNo], Ret[RetNo].Frm[FNo] do
 begin
  Frm[FNo].Strings[103]:= '0.00';
  Tv[110]:=100;
  Tv[114]:=100;
  Tv[116]:=500;
 end;

 StoreElm(RetNo,FNo,17,'0.00'); //20180226  mjjz2024 why???????
 StoreElm(RetNo,FNo,107,'0.00'); //20180226 ??????


  SaveTv(RetNo, FName, FNo);
end;






end.

