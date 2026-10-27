unit TF_2026calc1;
{? need polit contr from POLIT}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
  TF_2026Declare, TF_2026common, TF_2026common2, TF_2026TrimStr;

  procedure T2081(RetNo:integer;FName:string;FNo:integer);  //20250115
   //20230324
  procedure PS58(RetNo: integer; FName: String; FNo: integer); // 20220508
  procedure PS63(RetNo: integer; FName: String; FNo: integer); // 20220508
  procedure PS65(RetNo: integer; FName: String; FNo: integer); // 20220508

  procedure T106(RetNo: integer; FName: String;FNo: integer);
  procedure T106SL(RetNo: integer; FName: String;FNo: integer);

  procedure T1235(RetNo:integer;FName:string;FNo:integer);

  procedure T1236(RetNo:integer;FName:string;FNo:integer);

  procedure T2202Ws(RetNo:integer;FName:string;FNo:integer);
  //Function GetEmptyFootnoteElm(RetNo:Integer;FName:String):Integer;

  //Procedure T3A(RetNo:integer;FName:string;FNo:integer);

  //Procedure T4_1(RetNo:integer;FName:string;FNo:integer);
  //procedure DON(RetNo: integer; FName: String;FNo: integer);
  procedure CreatePrBnfr(RetNo:Integer);
  procedure PRBNFR(RetNo:integer;FName:string;FNo:integer);
  //Procedure T3Supl(RetNo:integer;FName:string;FNo:integer);
  //Procedure CalcT3Slips(RetNo:Integer);

  procedure Invoice(RetNo:integer;FName:string;FNo:integer);
  procedure InvForms(RetNo:integer;FName:string;FNo:integer);

  //Procedure AVLBLE(RetNo:integer;FName:string;FNo:integer);
  //Procedure S1SUPPL(RetNo:integer;FName:string;FNo:integer);

  procedure S1SPLBG(RetNo:integer;FName:string;FNo:integer);
  //Procedure INVSTM(RetNo:integer;FName:string;FNo:integer);
  //Procedure FINVSTM(RetNo:integer;FName:string;FNo:integer);
  procedure T1013(RetNo:integer;FName:string;FNo:integer);

  //Procedure T3SUM(RetNo:integer;FName:string;FNo:integer);

  //Procedure POLIT(RetNo:integer;FName:string;FNo:integer);
  procedure NPAD(RetNo: integer; FName: String;FNo: integer);
  procedure NPADC(RetNo: integer; FName: String;FNo: integer);
  procedure PRIVAT(RetNo: integer; FName: String;FNo: integer);

  procedure PS75(RetNo: integer; FName: String; FNo: integer); // 20250812 Igor
  procedure PS78(RetNo: integer; FName: String; FNo: integer); // 20250812 Igor
  procedure PS130(RetNo: integer; FName: String; FNo: integer); // 20250820 Igor
  procedure PS140(RetNo: integer; FName: string; FNo: integer); // 20250820 Igor

implementation

uses
  TF_2026Calc, vtShared, TF_2026, vtCommon, vtTrimStr, vtMulti;

procedure NPAD(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure NPADC(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
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



Procedure T1013(RetNo:integer;FName:string;FNo:integer);
var i:integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin

    //part 2
     If (Strings[27]>'') and (Strings[28]>'') then Strings[28]:='';
    If (Strings[8]>'') and (Strings[28]>'') then Strings[28]:='';

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

Procedure InvForms(RetNo:integer;FName:string;FNo:integer);
Var i,j,PagesCharged:integer; Frms,HowMany:TstringList;
begin
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

   // If Strings[210]='' then Strings[210] := 'T'+GetT3AccountNumber(RetNo)+'-'+GetTrustYear(RetNo);

    Strings[211] := GetRetName(RetNo);
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
        With Ret[RetNo].Frm[PrfFNo] do
        begin
          Strings[1] := GetYearEnd(RetNo);
          Strings[2] := LeftStr(GetYearEnd(RetNo),4);

          BnfAlloc := {Vl(FetchElm(RetNo,'S9_1',32));}
           Vl(FetchElmFNo(RetNo,FNo,5))    {box 21}
                      +Vl(FetchElmFNo(RetNo,FNo,6))   {22}
                      +Vl(FetchElmFNo(RetNo,FNo,7))   {23}
                      +Vl(FetchElmFNo(RetNo,FNo,8))   {24}
                      +Vl(FetchElmFNo(RetNo,FNo,9))   {25}
                      +Vl(FetchElmFNo(RetNo,FNo,10));  {26}

          Strings[3] := FormatFloat('#######',
              GetTotalPreferredAllocation(RetNo));
              {Vl(FetchElm(RetNo,'T3',252)));}
          Strings[4] := FormatFloat('########',BnfAlloc);
          Strings[5] := Strings[4];
          Strings[6] := FetchElm(RetNo,'T3',327); {trustee}
          Strings[8] := FetchElmFNo(RetNo,FNo,26); {benef name}
         end; {copying with RetNo}
    end; {if preferred}
  end; {For}
end;




(*
Procedure T3A(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x:Real;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  Strings[1] := FetchElm(RetNo,'T3',1);
  Strings[2] := FetchElm(RetNo,'T3',2);
  Strings[3] := FetchElm(RetNo,'T3',17);

  Strings[32] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),3),4);
  Strings[34] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),2),4);
  Strings[36] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),1),4);

  Strings[51] := Strings[32];
  Strings[52] := Strings[34];
  Strings[53] := Strings[36];

  Tv[4] := Vl(FetchElm(RetNo,'T3',101));
  Tv[5] := Vl(FetchElm(RetNo,'T3',267));
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

  Tv[24] := Tv[4]+Tv[6]+Tv[7]+Tv[9]+Tv[11]+Tv[13]+Tv[15]+Tv[17]+Tv[18]+Tv[20];
  Tv[25] := Tv[5]+Tv[8]+Tv[10]+Tv[12]+Tv[14]+Tv[16]+Tv[19]+Tv[21]+Tv[22]+Tv[23];

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
  Strings[108] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),3),4);
  Strings[109] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),2),4);
  Strings[110] := LeftStr(GetPrevYearEnd(FetchElm(RetNo,'T3',17),1),4);

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
*)

//20230211 john
Procedure T2202Ws(RetNo:integer;FName:string;FNo:integer);
Var i:integer;x:Real; TotPartTime,TotFullTime:Integer;FInst:String;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  Strings[64]:= AppYear;  //20230211
  FInst := ExtractFormInst(FName);
  if FInst>'#1' then
  begin
   StoreElm(RetNo,FNo,41,FetchElmFNo(RetNo,GetFormNo('T2202WS'),41));
   StoreElm(RetNo,FNo,42,FetchElmFNo(RetNo,GetFormNo('T2202WS'),42));
   StoreElm(RetNo,FNo,43,FetchElmFNo(RetNo,GetFormNo('T2202WS'),43));
  end;

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

  //Strings[57]:=UpperCase(Strings[44]+' '+Strings[45]);  //20230211 field removed
  If Strings[56]='' then Strings[56]:=FormatDateTime('yyyy-mm-dd',Date);

 end;
 SaveTv(RetNo,FName,FNo);
end;


(*
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
*)

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

  {
  i:=1;
  Repeat
   If Strings[i]>'' then k:=K+1;
   Inc(i,12);
  until i>73;
  }
  k:=CountT1235Directors(RetNo);
  //20201211
  Strings[85]:=IntToStr(k);
  Strings[100]:=FetchElm(RetNo,'T3010',37);
  Strings[101]:=FetchElm(RetNo,'T3010',2);
  Strings[102]:=ReplaceChar(FetchElm(RetNo,'T3010',1),'-','/');
  //----------------
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

  Strings[5]:=ReplaceChar(FetchElm(RetNo,'T3010',1),'-','/');  //20201211
  Strings[87]:=LeftStr(FetchElm(RetNo,'T3010',37),116);  //20191230 CharityName
  Strings[88]:=GetCharityBN(RetNo);   //20191230

  i:=1;
  Repeat
   Strings[i]:=LeftStr(Strings[i],87);  //20240108)
   Inc(i,8);
  Until i>57;

  i:=78;
  Repeat
   Strings[i]:=LeftStr(Strings[i],36);  //20240108)
   Inc(i,1);
  Until i>86;


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
     if (strings[1]='') or (UpperCase(Strings[1])<>'X') then
     //ok
     else
      Strings[1]:='';

    // FillHeader(RetNo,FNo,1,2,3);
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

// 20200607
procedure PS58(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer; x:real;
  errcode:Integer; //for val  converting string to real;
  FInst: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FInst := UpperCase(ExtractFormInst(FName));
    FillT5013Header(RetNo, FNo, 1, 2, 3);
    if Strings[8] + Strings[9] = '' then  Strings[8] := 'X';

    if (Strings[9] > '') then
    Begin
      Strings[10] := '';
      Strings[11] := '';
      Strings[12] := '';
     // Strings[19] := ''; // 20200609
    end
    Else
    Begin
      if Strings[10] = '' then
        Strings[10] := GetTaxationYearStart(RetNo);
      if Strings[11] = '' then
        Strings[11] := GetTaxationYearEnd(RetNo);
      Strings[19] := IntToStr(DateDiffYMD(Strings[10], Strings[11]));
      // 20200609 Days qualified
      if Strings[19] > '365' then
        Strings[19] := '365'; // 20201016

    end;

    Tv[14] := 0;
    i := 27;
    Repeat
      if (Strings[i + 1] = '') or (Strings[i + 2] = '') then
        Tv[i + 3] := 0;

      Tv[i + 5] := MaxR(0, Tv[i + 3] - Tv[i + 4]);
      if Strings[i + 1] > '' then // name entered
        Tv[i + 6] := 55000 * (StrToInt(Strings[19]) / 365)
      Else
        Tv[i + 6] := 0;
      Tv[i + 7] := MinR(Tv[i + 5], Tv[i + 6]);
      Tv[i + 8] := Round(Tv[i + 7] * 0.25);
      Tv[14] := Tv[14] + Tv[i + 8];
      Inc(i, 8);
    Until i > 244;

    Tv[13] := TotMultiple(RetNo, 'PS58', 13) - Tv[13]; // exclude the #1
    Tv[14] := Tv[14] + Tv[13];
    Tv[16] := Tv[14] + Tv[15];
    Tv[18] := MaxR(0, Tv[16] - Tv[17]);
    //allocation


    i:=254;
    Tv[6]:=0;
    repeat
     if Vl(Strings[i])>1 then Strings[i]:='';
     val(Strings[i],X,errCode);   //Vl(Strings[i]) *100;
     Tv[6]:=Tv[6]+X;
     Inc(i,4);
    until i>294;
    //Strings[6]:=Formatfloat('#.0000',Tv[6]);

    i:=255;
    Tv[7]:=0;
    repeat
     if Tv[6]>0  then
     begin
      val(Strings[i-1],X,errCode); //x:=Vl(Strings[i-1]);
      Tv[i]:=Tv[18] * X; // / Tv[6]
     end
     Else
      Tv[i]:=0;
     Tv[7]:=Tv[7]+Tv[i];
     Inc(i,4);
    until i>295;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

//20230328
Procedure PS63(RetNo: integer; FName: String; FNo: integer); // 20220508
Var
  i, k,K1: integer;
  S1FNo, S5FNo: integer;
  Rate:Real;
  FiscalDays:Integer;
begin
 EXIT;   //20250326

  S1FNo := GetFormNo('PS1');
  S5FNo := GetFormNo('PS5');
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);
    Tv[8]:=Tv[5]+Tv[6]+Tv[7];
    Tv[9]:=Tv[8];
    Tv[10]:=MaxR(0,Tv[4]-Tv[9]);

    //PART 2 Pg2
    // ON
    if Strings[255]>'' then
    begin
      k:=0;
      K1:=0;
      Tv[11+k] := Vl(FetchElmFNo(RetNo, S5FNo, 37));
      Tv[12+k] := Vl(FetchElmFNo(RetNo, S5FNo, 71));
      If Tv[12+k]>0 then
       Tv[13+k]:=(Tv[11+k]/Tv[12+k]) * 100
      Else
       Tv[13+k]:=0;
      Tv[14+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 36));
      Tv[15+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 70));
      if Tv[15+k]>0 then
       Tv[16+k]:=(Tv[14+k]/Tv[15+k]) * 100
      Else
       Tv[16+k]:=0;
     Tv[17+k]:=Tv[13+k]+Tv[16+k];
     Tv[18+k]:=Tv[17+k]*50/100;
     if (Tv[12+k]=0) or (Tv[15+k]=0) then Tv[18+k]:=Tv[17+k]; //no 50%  multiply
     Tv[19+k]:=Tv[18+k]*Tv[10]/100;
     if Vl(Strings[51+k1])>1 then Strings[51+k1]:='0';
     if Vl(Strings[52+K1])>1 then Strings[52+k1]:='0';
     if GetTaxationYearStart(RetNo)=GetTaxationYearEnd(RetNo) then
     Strings[52+k1]:='0';
     //ON
     if LeftStr(GetTaxationYearStart(RetNo),4)='2021' then
       rate:=1.51
     else
       Rate:=1.73;
     //MB
     Tv[62]:=Tv[19];
     Tv[63]:=Tv[62]*Vl(Strings[51]) * Rate/1000;
     Tv[64]:=Tv[19];
     Tv[65]:=Tv[64] * Vl(Strings[52]) * Rate/1000;
     Tv[66]:=Tv[63]+Tv[65];
    end;
    // MB
    if Strings[256]>'' then
    begin
      k:=9;  //incr from ontario
      K1:=2;  //forrow 10 and 11
      Tv[11+k] := Vl(FetchElmFNo(RetNo, S5FNo, 41)); //different for each prov

        Tv[12+k] := Vl(FetchElmFNo(RetNo, S5FNo, 71));
        If Tv[12+k]>0 then
         Tv[13+k]:=(Tv[11+k]/Tv[12+k]) * 100
        Else
         Tv[13+k]:=0;
        Tv[14+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 40));
        Tv[15+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 70));
        if Tv[15+k]>0 then
         Tv[16+k]:=(Tv[14+k]/Tv[15+k]) * 100
        Else
         Tv[16+k]:=0;
       Tv[17+k]:=Tv[13+k]+Tv[16+k];
       Tv[18+k]:=Tv[17+k]*50/100;
       if (Tv[12+k]=0) or (Tv[15+k]=0) then Tv[18+k]:=Tv[17+k]; //no 50%  multiply
       Tv[19+k]:=Tv[18+k]*Tv[10]/100;
       if Vl(Strings[51+k1])>1 then Strings[51+k1]:='0';
       if Vl(Strings[52+K1])>1 then Strings[52+k1]:='0';
       if GetTaxationYearStart(RetNo)=GetTaxationYearEnd(RetNo) then
         Strings[52+k1]:='0';
       //ON
       if LeftStr(GetTaxationYearStart(RetNo),4)='2021' then
         rate:=1.51
       else
         Rate:=1.73;
       //MB
       Tv[67]:=Tv[28];
       Tv[68]:=Tv[67]*Vl(Strings[53]) * Rate/1000;
       Tv[69]:=Tv[28];
       Tv[70]:=Tv[69] * Vl(Strings[54]) * Rate/1000;
       Tv[71]:=Tv[68]+Tv[70];
    end;

    // SK
    if Strings[257]>'' then
    begin
      k:=18;  //incr from ontario
      K1:=4;
      Tv[11+k] := Vl(FetchElmFNo(RetNo, S5FNo, 45)); //different for each prov

        Tv[12+k] := Vl(FetchElmFNo(RetNo, S5FNo, 71));
        If Tv[12+k]>0 then
         Tv[13+k]:=(Tv[11+k]/Tv[12+k]) * 100
        Else
         Tv[13+k]:=0;
        Tv[14+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 44));
        Tv[15+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 70));
        if Tv[15+k]>0 then
         Tv[16+k]:=(Tv[14+k]/Tv[15+k]) * 100
        Else
         Tv[16+k]:=0;
       Tv[17+k]:=Tv[13+k]+Tv[16+k];
       Tv[18+k]:=Tv[17+k]*50/100;
       if (Tv[12+k]=0) or (Tv[15+k]=0) then Tv[18+k]:=Tv[17+k]; //no 50%  multiply
       Tv[19+k]:=Tv[18+k]*Tv[10]/100;
       if Vl(Strings[51+k1])>1 then Strings[51+k1]:='0';
       if Vl(Strings[52+K1])>1 then Strings[52+k1]:='0';
       if GetTaxationYearStart(RetNo)=GetTaxationYearEnd(RetNo) then
         Strings[52+k1]:='0';
       //ON
       if LeftStr(GetTaxationYearStart(RetNo),4)='2021' then
         rate:=1.51
       else
         Rate:=1.73;
       //SK
       Tv[72]:=Tv[37];
       Tv[73]:=Tv[72]*Vl(Strings[55]) * Rate/1000;
       Tv[74]:=Tv[37];
       Tv[75]:=Tv[74] * Vl(Strings[56]) * Rate/1000;
       Tv[76]:=Tv[73]+Tv[75];
    end;

    // AB
    if Strings[258]>'' then
    begin
      k:=27;  //incr from ontario 11 to 49
      K1:=7;   //58-11 = 7
      Tv[11+k] := Vl(FetchElmFNo(RetNo, S5FNo, 49)); //different for each prov
        Tv[12+k] := Vl(FetchElmFNo(RetNo, S5FNo, 71));
        If Tv[12+k]>0 then
         Tv[13+k]:=(Tv[11+k]/Tv[12+k]) * 100
        Else
         Tv[13+k]:=0;
        Tv[14+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 48));
        Tv[15+k]:= Vl(FetchElmFNo(RetNo, S5FNo, 70));
        if Tv[15+k]>0 then
         Tv[16+k]:=(Tv[14+k]/Tv[15+k]) * 100
        Else
         Tv[16+k]:=0;
       Tv[17+k]:=Tv[13+k]+Tv[16+k];
       Tv[18+k]:=Tv[17+k]*50/100;
       if (Tv[12+k]=0) or (Tv[15+k]=0) then Tv[18+k]:=Tv[17+k]; //no 50%  multiply
       Tv[19+k]:=Tv[18+k]*Tv[10]/100;
       if Vl(Strings[51+k1])>1 then Strings[51+k1]:='0';
       if Vl(Strings[52+K1])>1 then Strings[52+k1]:='0';
       if GetTaxationYearStart(RetNo)=GetTaxationYearEnd(RetNo) then
         Strings[52+k1]:='0';
       //ON
       if LeftStr(GetTaxationYearStart(RetNo),4)='2021' then
         rate:=1.51
       else
         Rate:=1.73;
      End;
       //AB
       Tv[77]:=Tv[46];
       Tv[78]:=Tv[77]*Vl(Strings[58]) * Rate/1000;
       Tv[79]:=Tv[46];
       Tv[80]:=Tv[79] * Vl(Strings[59]) * Rate/1000;
       Tv[81]:=Tv[78]+Tv[80];
    //----------------------------------------
     //20230329
     Tv[83]:=Vl(FetchElm(RetNo,'T5013WS',247));
     Tv[84]:=Vl(FetchElm(RetNo,'T5013WS',248));
     Tv[85]:=Vl(FetchElm(RetNo,'T5013WS',249));
     Tv[86]:=Vl(FetchElm(RetNo,'T5013WS',250));
     Tv[92]:=Tv[83]+Tv[84]+Tv[85]+Tv[86];
     Tv[93]:=Tv[82]+Tv[92];

    Tv[82]:=Tv[66]+Tv[71]+Tv[76]+Tv[81];
  end; // with
  SaveTv(RetNo, FName, FNo);
end;


(* //20230327
Procedure PS63(RetNo: integer; FName: String; FNo: integer); // 20220508
Var
  i, k: integer;
  S1FNo, S5FNo: integer;
begin
  S1FNo := GetFormNo('S1');
  S5FNo := GetFormNo('S5');
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);
    if IsMultJurisdiction(RetNo) = false then // initiaize
    Begin
      for i := 11 to 21 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 22 to 32 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 33 to 43 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 44 to 54 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
    End;


    {?????   //20230325
    if (Ret[RetNo].Province = 'ON') or (Ret[RetNo].Province = 'MB') or
      (Ret[RetNo].Province = 'SK') or (Ret[RetNo].Province = 'AB') Or
      (IsMultJurisdiction(RetNo)) then
      // ok
    Else
    Begin
      for i := 4 to 97 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;
    }
    //If UpperCase(Strings[90]) <> 'Y' then Tv[4] := TotMultiple(RetNo, 'S125', 32); //20230325
    // 9998 GIFI Farm expenses //20220705
    If Tv[4] < 25000 then
    Begin
      for i := 4 to 97 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;

   {  //202303 26 needs full revision
    // Tv[4]:=TotMultiple(RetNo,'S125',32); //9998 GIFI
    Tv[5] := Vl(FetchElmFNo(RetNo, S1FNo, 210));
    Tv[6] := Vl(FetchElmFNo(RetNo, S1FNo, 214));
    // [7]:=? User
    Tv[8] := Tv[5] + Tv[6] + Tv[7];
    Tv[9] := Tv[8];
    Tv[10] := MaxR(0, Tv[4] - Tv[9]);
    // ON
    if (Ret[RetNo].Province = 'ON') then
    Begin
      Tv[11] := Tv[10];
      if IsMultJurisdiction(RetNo) then
      Begin
        Tv[11] := 0;
        Tv[12] := Vl(FetchElmFNo(RetNo, S5FNo, 162));
        Tv[13] := Vl(FetchElmFNo(RetNo, S5FNo, 272));
        if Tv[13] > 0 then
          Strings[14] := FormatFloat('##0.00000', (Tv[12] / Tv[13]))
        else
          Strings[14] := '';
        Strings[15] := Strings[14];
        Tv[16] := Vl(FetchElmFNo(RetNo, S5FNo, 160));
        Tv[17] := Vl(FetchElmFNo(RetNo, S5FNo, 270));
        If Tv[17] > 0 then
          Strings[18] := FormatFloat('##0.00000', (Tv[16] / Tv[17]))
        else
          Strings[18] := '';
        Strings[19] := Strings[18];
        Strings[20] := FormatFloat('##0.00000',
          (Vl(Strings[15]) + Vl(Strings[19])) * 0.5);
        Tv[21] := Tv[10] * StrToFloat(Strings[20]);
      End;
    End;
    // MB
    if (Ret[RetNo].Province = 'MB') then
    Begin
      Tv[22] := Tv[10];
      // if IsMultJurisdiction(RetNo) then
      // Begin
      Tv[12] := 0;
      Tv[23] := Vl(FetchElmFNo(RetNo, S5FNo, 173));
      Tv[24] := Vl(FetchElmFNo(RetNo, S5FNo, 272));
      If Tv[24] > 0 then
        Strings[25] := FormatFloat('##0.00000', (Tv[23] / Tv[24]))
      else
        Strings[25] := '';
      Strings[26] := Strings[25];
      Tv[27] := Vl(FetchElmFNo(RetNo, S5FNo, 171));
      Tv[28] := Vl(FetchElmFNo(RetNo, S5FNo, 270));
      If Tv[28] > 0 then
        Strings[29] := FormatFloat('##0.00000', (Tv[27] / Tv[28]))
      else
        Strings[29] := '';
      Strings[30] := Strings[29];
      Strings[31] := FormatFloat('##0.00000',
        (Vl(Strings[26]) + Vl(Strings[30])) * 0.5);
      Tv[32] := Tv[22] * Vl(Strings[31]);
      If (Vl(Strings[26]) = 0) or (Vl(Strings[30]) = 0) then
        Tv[32] := Tv[22]; // only MB  (3D or 3g=0) //20221016 do not mult by 0.5
      // end;
    end;
    if (Ret[RetNo].Province = 'SK') then
    Begin
      // Sk
      Tv[33] := Tv[10];
      if IsMultJurisdiction(RetNo) then
      Begin
        Tv[33] := 0;
        Tv[34] := Vl(FetchElmFNo(RetNo, S5FNo, 184));
        Tv[35] := Vl(FetchElmFNo(RetNo, S5FNo, 272));
        If Tv[35] > 0 then
          Strings[36] := FormatFloat('##0.00000', (Tv[34] / Tv[35]))
        else
          Strings[36] := '';
        Strings[37] := Strings[36];
        Tv[38] := Vl(FetchElmFNo(RetNo, S5FNo, 182));
        Tv[39] := Vl(FetchElmFNo(RetNo, S5FNo, 270));
        If Tv[39] > 0 then
          Strings[40] := FormatFloat('##0.00000', (Tv[38] / Tv[39]))
        else
          Strings[40] := '';
        Strings[41] := Strings[40];
        Strings[42] := FormatFloat('##0.00000',
          (Vl(Strings[37]) + Vl(Strings[41])) * 0.5); // (Tv[37]+Tv[41]) * 0.5;
        Tv[43] := Tv[10] * StrToFloat(Strings[42]);
      end;
    End;

    // AB
    if (Ret[RetNo].Province = 'AB') then
    Begin
      Tv[44] := Tv[10];
      if IsMultJurisdiction(RetNo) then
      Begin
        Tv[44] := 0;
        Tv[45] := Vl(FetchElmFNo(RetNo, S5FNo, 195));
        Tv[46] := Vl(FetchElmFNo(RetNo, S5FNo, 272));
        If Tv[46] > 0 then
          Strings[47] := FormatFloat('##0.00000', (Tv[45] / Tv[46]))
        else
          Strings[47] := '';
        Strings[48] := Strings[47];
        Tv[49] := Vl(FetchElmFNo(RetNo, S5FNo, 193));
        Tv[50] := Vl(FetchElmFNo(RetNo, S5FNo, 270));
        If Tv[50] > 0 then
          Strings[51] := FormatFloat('##0.00000', (Tv[49] / Tv[50]))
        else
          Strings[51] := '';
        Strings[52] := Strings[51];
        Strings[53] := FormatFloat('##0.00000',
          (Vl(Strings[48]) + Vl(Strings[52])) * 0.5); // (Tv[48]+Tv[52]) * 0.5;
        Tv[54] := Tv[10] * StrToFloat(Strings[53]);
      end;
    End;
    // pg3
    k := GetNumDays(RetNo, '31-12-2020', 'A') -
      GetNumDays(RetNo, '31-12-2021', 'A');
    Strings[55] := IntToStr(k);
    Strings[56] := IntToStr(Ret[RetNo].DaysInYear);
    Strings[57] := FormatFloat('##0.00000', k / Ret[RetNo].DaysInYear);

    k := GetNumDays(RetNo, '31-12-2021', 'A') -
      GetNumDays(RetNo, '31-12-2022', 'A');
    Strings[58] := IntToStr(k);
    Strings[59] := IntToStr(Ret[RetNo].DaysInYear);
    Strings[60] := FormatFloat('##0.00000', k / Ret[RetNo].DaysInYear);
    // ON
    Strings[61] := Strings[57];
    Tv[62] := MaxR(Tv[11], Tv[21]);
    Tv[63] := StrToFloat(Strings[61]) * (Tv[62] * 0.147) / 100; // 20220611

    Strings[64] := Strings[60];
    Tv[65] := MaxR(Tv[11], Tv[21]);
    Tv[66] := StrToFloat(Strings[64]) * (Tv[65] * 0.173) / 100;
    Tv[67] := Tv[63] + Tv[66];
    // MB
    Strings[68] := Strings[57];
    Tv[69] := MaxR(Tv[22], Tv[32]);
    Tv[70] := Vl(Strings[68]) * (Tv[69] * 0.147) / 100;

    Strings[71] := Strings[60];
    Tv[72] := MaxR(Tv[22], Tv[32]);
    Tv[73] := StrToFloat(Strings[71]) * (Tv[72] * 0.173) / 100;
    Tv[74] := Tv[70] + Tv[73];

    // SK
    Strings[75] := Strings[57];
    Tv[76] := MaxR(Tv[33], Tv[43]);
    Tv[77] := StrToFloat(Strings[75]) * (Tv[76] * 0.147) / 100;

    Strings[78] := Strings[60];
    Tv[79] := MaxR(Tv[33], Tv[43]);
    Tv[80] := StrToFloat(Strings[78]) * (Tv[79] * 0.173) / 100;
    Tv[81] := Tv[77] + Tv[80];

    // AB
    Strings[82] := Strings[57];
    Tv[83] := MaxR(Tv[44], Tv[54]);
    Tv[84] := StrToFloat(Strings[82]) * (Tv[83] * 0.147) / 100;

    Strings[86] := Strings[60];
    Tv[87] := MaxR(Tv[44], Tv[54]);
    Tv[85] := StrToFloat(Strings[86]) * (Tv[87] * 0.173) / 100;
    Tv[88] := Tv[84] + Tv[85];

    Tv[89] := Tv[67] + Tv[74] + Tv[81] + Tv[88];
    // pg4
    Tv[96] := Tv[92] + Tv[93] + Tv[94] + Tv[95];
    Tv[97] := Tv[89] + Tv[96];
  }
  end; // with
  SaveTv(RetNo, FName, FNo);
end;
*)
//20230325
Procedure PS65(RetNo: integer; FName: String; FNo: integer); // 20220508
Var
  i,j: integer;
  x: Real;
  Affiliated: Boolean;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);
    Affiliated := false;
    If UpperCase(Strings[23]) = 'Y' then
      Affiliated := True;

    (* //20230324
    // part 1 and 2
    if Ret[RetNo].CorpType = CCPC then
    begin
      Strings[4] := 'X';
      Strings[5] := '';
    end
    else
    begin
      Strings[4] := '';
      Strings[5] := 'X'
    end;
    *)

    i := 0;
    Tv[21] := 0;
    Repeat
      if Strings[74 + i] > '' then
      Begin
        Tv[77 + i] := Tv[75 + i] - Tv[76 + i]; // col 4 =col 2 -3
        Tv[80 + i] := Tv[78 + i] + Tv[79 + i]; // col7 =col 5 +8
        Tv[81 + i] := MaxR(0, 10000 - Tv[80 + i]); // col 8=10,000-col 7
        Tv[82 + i] := MinR(Tv[77 + i], Tv[81 + i]);
        // Tv[177+i]+Tv[81+i];    //col 9=least of col 4 and 8 //20221106]
        Tv[83 + i] := Tv[78 + i] + Tv[82 + i]; // col 10= col 5 +9
        Tv[21] := Tv[21] + Tv[82 + i];
      End
      Else
      Begin
        Tv[77 + i] := 0;
        Tv[80 + i] := 0;
        Tv[81 + i] := 0;
        Tv[82 + i] := 0;
        Tv[83 + i] := 0;
      End;
      Inc(i, 10);
    Until i > 244;

    // Part 3
    if Affiliated then
    Begin
    //  Strings[261] := GetCorpName(RetNo);  //20230324
    //  Strings[262] := GetBN(RetNo);      //20230324
      x := 0;
      i := 266; // start from second entry
      Repeat
        x := x + Tv[i];
        Inc(i, 3);
      Until i > 299;
      Tv[263] := MaxR(0, 100 - x);
      // add up
      Tv[41] := 0;
      i := 263;
      Repeat
        Tv[41] := Tv[41] + Tv[i];
        Inc(i, 3);
      Until i > 299;
    end
    Else // remove affiliated
    Begin
      i := 261;
      Repeat
        Tv[i] := 0;
        Strings[i] := '';
        Inc(i, 1);
      Until i > 299;
      Tv[41] := 0;
    End;
    // Part4
    Tv[10] := Tv[21];
    Tv[11] := 100;
    if Affiliated Then
      Tv[11] := Tv[263];
    Tv[12] := (50000 * Tv[11]) / 100;
    Tv[14] := MaxR(0, Tv[12] - Tv[13]);
    Tv[15] := Tv[14];
    Tv[16] := MinR(Tv[10], Tv[15]);
    Tv[17] := Tv[13] + Tv[16];
    Tv[20] := Tv[16];
    Tv[18] := Tv[20] * 25 / 100;
    Tv[22] := Tv[18] + Tv[19];

    i:=59;
    j:=300;
    Tv[40]:=0;
    Repeat
     if Vl(Strings[i])>1 then Strings[i]:='1.0000';
     Tv[j]:=Tv[22]*Vl(Strings[i]);
     Tv[40]:=Tv[40]+Tv[j];  //20230326
     Inc(i,1);
     Inc(j,1);
    Until i>73;
  end;
  SaveTv(RetNo, FName, FNo);
end;


Procedure T2081(RetNo:integer;FName:string;FNo:integer);  //20250115
Var i,k:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  //
 end;
 SaveTv(RetNo,FName,FNo);
end;

// 20250812 Igor >>>
procedure PS75(RetNo: integer; FName: String; FNo: integer);
var
  i, j: integer;
  x: Real;
  Affiliated: Boolean;
  lAssetCodeVal: string;
  lAssetsList: TArray<string>;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);

    Strings[171]:= FetchElm(RetNo, 'T5013FIN', 142);
    Strings[170]:= FetchElm(RetNo, 'T5013FIN', 143);
    Strings[172]:= FetchElm(RetNo, 'T5013FIN', 144);
    Strings[173]:= ReplaceStr(FetchElm(RetNo, 'T5013FIN', 145), '/', '-');
    Strings[174]:= FetchElm(RetNo, 'T5013FIN', 146) + FetchElm(RetNo, 'T5013FIN', 147);

    // Asset code
    i:= 5;
    Repeat
      lAssetCodeVal:= strings[i];
      if Length(lAssetCodeVal) > 2 then
      begin
        lAssetsList:= lAssetCodeVal.Split(['-']);
        strings[i]:= trim(lAssetsList[0]);
      end;
      inc(i, 2);
    until i > 15;

    i:= 101;
    Repeat
      lAssetCodeVal:= strings[i];
      if Length(lAssetCodeVal) > 2 then
      begin
        lAssetsList:= lAssetCodeVal.Split(['-']);
        strings[i]:= trim(lAssetsList[0]);
      end;
      inc(i, 2);
    until i > 111;

    // State Code
    i:= 22;
    Repeat
      lAssetCodeVal:= strings[i];
      if Length(lAssetCodeVal) > 2 then
      begin
        lAssetsList:= lAssetCodeVal.Split([' ']);
        strings[i]:= trim(lAssetsList[0]);
      end;
      inc(i, 6);
    until i > 52;

    i:= 114;
    Repeat
      lAssetCodeVal:= strings[i];
      if Length(lAssetCodeVal) > 2 then
      begin
        lAssetsList:= lAssetCodeVal.Split([' ']);
        strings[i]:= trim(lAssetsList[0]);
      end;
      inc(i, 6);
    until i > 144;

    // Allocation
    Tv[21]:= Tv[186] * Tv[20];
    Tv[61]:= Tv[186] * Tv[60];
    Tv[65]:= Tv[186] * Tv[64];
    Tv[69]:= Tv[186] * Tv[68];
    Tv[73]:= Tv[186] * Tv[72];

    Tv[113]:= Tv[169] * Tv[112];
    Tv[153]:= Tv[169] * Tv[152];
    Tv[157]:= Tv[169] * Tv[156];
    Tv[161]:= Tv[169] * Tv[160];
    Tv[165]:= Tv[169] * Tv[164];

    Tv[188]:= Tv[183] * Tv[175];
    Tv[192]:= Tv[183] * Tv[191];
    Tv[196]:= Tv[183] * Tv[195];
    Tv[200]:= Tv[183] * Tv[199];
    Tv[204]:= Tv[183] * Tv[203];

    i:= 76;
    j:= 25;
    Repeat
      Tv[i]:= (vl(strings[j]) - vl(strings[succ(j)])) + vl(strings[j + 2]);

      //line 145
      if (strings[j - 2] > '2023/03/27') and (strings[j - 2] < '2034/01/01') then
        strings[succ(i)]:= '30' //Tv[i+1] := 30; //until 2034
      else if (strings[j - 2] > '2033/12/31') and (strings[j - 2] < '2035/01/01') then
        strings[succ(i)]:= '15' //Tv[i+1] := 15; //in 2034
      else //if strings[j-2] > '2034/01/01' then
        strings[succ(i)]:= '0';  //Tv[i+1] := 0;  //after 2034

      Tv[i + 2]:= Tv[i] * (vl(strings[succ(i)]) / 100); //line 150
      inc(i, 4);
      inc(j, 6);
    until i > 96;

    Tv[184]:= AddColumns(78, 98, 4); // line A
    //Tv[185] := ?? // line 160
    Tv[186]:= Tv[184] + Tv[185];   // line 165

    i:= 118;
    Repeat
      //line 330
      if Tv[pred(i)] > 0 then
        Tv[i]:= Tv[i - 2] / Tv[i - 1]
      else
        Tv[i]:= 0;

      Tv[succ(i)]:= MinR(Tv[i - 3], Tv[i]); //line 335
      inc(i, 6);
    until i > 148;

    Tv[187]:= AddColumns(119, 149, 6); // line B
    //Tv[168]:= ?? // line 340
    Tv[169]:=  Tv[187] + Tv[168];   // line 345

    Tv[178]:= vl(strings[177]) * 20; // line C
    Tv[181]:= MaxR(0, (vl(strings[179]) - vl(strings[180])) * 50); //line D 630
    //Tv[182]:= ; //??? //line 625
    Tv[183]:= Tv[178] + Tv[181] + Tv[182]; // line 630
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure PS78(RetNo: integer; FName: String; FNo: integer);
var
  i: Integer;
  lCodeVal: string;
  lCodesList: TArray<string>;
  TotM: Real;
  Tot4H: Real;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);

    Strings[6]:= ReplaceStr(Strings[6], '/', '-');
    Strings[8]:= ReplaceStr(Strings[8], '/', '-');
    Strings[158]:= ReplaceStr(Strings[158], '/', '-');

    Strings[156]:= FetchElm(RetNo, 'T5013FIN', 142);
    Strings[155]:= FetchElm(RetNo, 'T5013FIN', 143);
    Strings[157]:= FetchElm(RetNo, 'T5013FIN', 144);
    Strings[158]:= ReplaceStr(FetchElm(RetNo, 'T5013FIN', 145), '/', '-');
    Strings[159]:= FetchElm(RetNo, 'T5013FIN', 146) + FetchElm(RetNo, 'T5013FIN', 147);

    // Allocation
    Tv[54]:= Tv[154] * Tv[40];
    Tv[110]:= Tv[154] * Tv[96];
    Tv[255]:= Tv[154] * Tv[254];
    Tv[259]:= Tv[154] * Tv[258];
    Tv[263]:= Tv[154] * Tv[262];

    Tv[267]:= Tv[154] * Tv[266];
    Tv[271]:= Tv[154] * Tv[270];
    Tv[275]:= Tv[154] * Tv[274];
    Tv[279]:= Tv[154] * Tv[278];
    Tv[283]:= Tv[154] * Tv[282];

    Tv[287]:= Tv[252] * Tv[286];
    Tv[291]:= Tv[252] * Tv[290];
    Tv[295]:= Tv[252] * Tv[294];
    Tv[299]:= Tv[252] * Tv[298];
    Tv[303]:= Tv[252] * Tv[302];

    // Class number code
    i:= 9;
    repeat
      lCodeVal:= strings[i];
      if Length(lCodeVal) > 2 then
      begin
        lCodesList:= lCodeVal.Split(['-']);
        strings[i]:= trim(lCodesList[0]);
      end;
      inc(i, 14);
    until i > 135;

    // Description of qualified
    i:= 10;
    repeat
      lCodeVal:= strings[i];
      if Length(lCodeVal) > 2 then
      begin
        lCodesList:= lCodeVal.Split(['-']);
        strings[i]:= trim(lCodesList[0]);
      end;
      inc(i, 14);
    until i > 136;

    // Class number code
    i:= 193;
    repeat
      lCodeVal:= strings[i];
      if Length(lCodeVal) > 2 then
      begin
        lCodesList:= lCodeVal.Split(['-']);
        strings[i]:= trim(lCodesList[0]);
      end;
      inc(i, 8);
    until i > 241;

    // Description of qualified
    i:= 194;
    repeat
      lCodeVal:= strings[i];
      if Length(lCodeVal) > 2 then
      begin
        lCodesList:= lCodeVal.Split(['-']);
        strings[i]:= trim(lCodesList[0]);
      end;
      inc(i, 8);
    until i > 242;

    i:= 9;
    TotM:= 0;
    repeat
      Tv[i + 8]:= Tv[i + 5] - Tv[i + 6] + Tv[i + 7];

      Strings[i + 9]:= '1.0000';

      if Tv[i + 8] = 0 then Strings[i + 9]:= '';

      Tv[i + 10]:= Tv[i + 8] * Vl(Strings[i + 9]);  //k

      if (Strings[i] > '') then
      begin
        if LeftStr(Strings[i + 1], 2) = '01' then Strings[i + 11]:= '60';
        if LeftStr(Strings[i + 1], 2) = '02' then Strings[i + 11]:= '50';
        if LeftStr(Strings[i + 1], 2) >= '03' then Strings[i + 11]:= '37.5';
      end else
        Strings[i + 11]:= '';

     Tv[i + 12]:= Tv[i + 10] * Vl(Strings[i + 11]) / 100;  //m
     TotM:= TotM + Tv[i + 12];
     Inc(i, 14);
    until i > 143;

    Tv[151]:= MaxR(0, Tv[149] - Tv[150]);
    Tv[152]:= TotM;
//    Tv[153]:= 0; // amount from box 245 of each T5013 slip
    Tv[154]:= Tv[151] + Tv[152] + Tv[153];

    //pg3
    Tv[164]:= Vl(Strings[163]) * 20;
    Tv[167]:= MaxR(0, Vl(Strings[165]) - Vl(Strings[166])) * 50;
    Tv[169]:= Tv[164] + Tv[167] + Tv[168];

    Tv[188]:= MaxR(0, Tv[185] - Tv[186] - Tv[187]);
    Tv[192]:= MaxR(0, Tv[189] - Tv[190] - Tv[191]);

    //og4
    Tv[182]:= Tv[150];
    Tv[183]:= Tv[149];
    Tv[184]:= MaxR(0, Tv[182] - Tv[183]);

    //pg2
    i:= 193;
    Tot4H:= 0;
    repeat
      if Tv[i + 4] > 0 then
        Tv[i + 5]:= Tv[i + 2] * Tv[i + 3] / Tv[i + 4]
      else
        Tv[i + 5]:= 0;

     Tv[i + 7]:= MaxR(0, Tv[i + 5] - Tv[i + 6]);
     Tot4H:= Tot4H + Tv[i + 7];
     Inc(i, 8);
    until i > 241;

    Tv[250]:= Tot4H;
    Tv[252]:= Tv[184] + Tv[188] + Tv[192] + TV[249] + Tv[250] + Tv[251];
  end;

  SaveTv(RetNo, FName, FNo);
end;
// 20250812 Igor <<<

// 20250820 Igor >>>
procedure PS130(RetNo: integer; FName: String; FNo: integer);
var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);

    if (Strings[4] = '') and (Strings[5] = '') then
      Strings[4]:= 'X';

    Tv[31]:= Tv[16] + Tv[12] + Tv[17] + TV[21] + Tv[25];
    Tv[32]:= Tv[26] + Tv[27] + Tv[28] + TV[29] + Tv[30];
    Tv[53]:= Tv[35] + Tv[47] + Tv[48] + TV[49];
    Tv[54]:= Tv[36] + Tv[50] + Tv[51] + TV[52];
    Tv[55]:= Tv[37] + Tv[38] + Tv[39] + TV[40];
    Tv[72]:= Tv[58] + Tv[66] + Tv[67] + TV[68];
    Tv[73]:= Tv[59] + Tv[69] + Tv[70] + TV[71];

    Tv[74]:= Tv[53];
    Tv[79]:= Tv[54];
    Tv[87]:= Tv[55];

    Tv[126]:= Tv[111] + Tv[112] + Tv[113] + TV[114] + Tv[115];
    Tv[127]:= Tv[116] + Tv[117] + Tv[118] + TV[119] + Tv[120];

    Tv[77]:= Tv[127];
    Tv[78]:= Tv[126];

    Tv[86]:= Tv[74] + Tv[75] + Tv[76] + TV[77] + TV[78] + TV[79] + TV[80] + TV[81] + TV[82] + TV[83] + TV[84] + TV[85];
    Tv[89]:= Tv[87] + Tv[88];
    Tv[90]:= Tv[86] - Tv[89];

    // Con I am not sure how this strange condition "IFE in UCC (column 2 plus or minus column 3) If negative, enter '0'" should be calculated
    i:= 106;
    repeat
      if Tv[i - 5] > 0 then
        Tv[i]:= MaxR(0, Tv[i - 10] + Tv[i - 5])
      else
        Tv[i]:= MaxR(0, Tv[i - 10] - Tv[i - 5]);

      Inc(i, 1);
    until i > 110;

    // Part 4
    Tv[131]:= Tv[72];
    Tv[135]:= Tv[128] + Tv[129] + Tv[130] + TV[131] + Tv[132] + Tv[133] + Tv[134];
    Tv[136]:= Tv[73];
    Tv[141]:= Tv[136] + Tv[137] + Tv[138] + TV[139] + Tv[140];
    Tv[142]:= MaxR(0, Tv[135] - Tv[141]);

    // Part 5
    Tv[143]:= Tv[86];
    Tv[144]:= Tv[89];
    Tv[145]:= Tv[135];
    Tv[146]:= Tv[141];
    Tv[147]:= Tv[126];
    Tv[148]:= Tv[127];
    Tv[149]:= Tv[31];
    Tv[150]:= Tv[32];

    i:= 181;
    repeat
      Tv[i]:= Tv[143] * Tv[i - 10];
      Inc(i, 1);
    until i > 190;

    i:= 191;
    repeat
      Tv[i]:= Tv[144] * Tv[i - 20];
      Inc(i, 1);
    until i > 200;

    i:= 201;
    repeat
      Tv[i]:= Tv[145] * Tv[i - 30];
      Inc(i, 1);
    until i > 210;

    i:= 211;
    repeat
      Tv[i]:= Tv[146] * Tv[i - 40];
      Inc(i, 1);
    until i > 220;

    i:= 221;
    repeat
      Tv[i]:= Tv[147] * Tv[i - 50];
      Inc(i, 1);
    until i > 230;

    i:= 231;
    repeat
      Tv[i]:= Tv[148] * Tv[i - 60];
      Inc(i, 1);
    until i > 240;

    i:= 241;
    repeat
      Tv[i]:= Tv[149] * Tv[i - 70];
      Inc(i, 1);
    until i > 250;

    i:= 251;
    repeat
      Tv[i]:= Tv[150] * Tv[i - 80];
      Inc(i, 1);
    until i > 260;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure PS140(RetNo: integer; FName: string; FNo: integer);
var
  i: integer;
begin
  {if CountMultipleInstances(RetNo, 'PS125') < 2 then
  begin
    for i:= 4 to 26 do
    begin
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;
    SaveTv(RetNo, FName, FNo);
    Exit;
  end;}

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);

//    Tv[4]:= TotMultiple(RetNo, 'PS125', 38);
//    Tv[5]:= TotMultiple(RetNo, 'PS125', 39);
//    Tv[18]:= TotMultiple(RetNo, 'PS125', 62);
//    Tv[19]:= TotMultiple(RetNo, 'PS125', 63);

    Tv[25]:= Tv[4] - Tv[6] - Tv[8] + Tv[10] - Tv[12] - Tv[14] - Tv[16] + Tv[18];
    Tv[26]:= Tv[5] - Tv[7] - Tv[9] + Tv[11] - Tv[13] - Tv[15] - Tv[17] + Tv[19];
  end;

  SaveTv(RetNo, FName, FNo);
end;
// 20250820 Igor <<<

end.
