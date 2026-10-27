unit TF_2026calc;

interface
uses


 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,ComCtrls,
 TF_2026Declare, TF_2026common, TF_2026common2, TF_2026TrimStr,
 TF_2026Calc1, TF_2026Calc2,
 TF_2026Calc3, TF_2026CalcBus, TF_2026CalcT5013, {PopList,} TF_2026Calndr;  //20130216

 //20170609
// Procedure T1079(RetNo: integer; FName: String;FNo: integer);
// Procedure T1079WS(RetNo: integer; FName: String;FNo: integer);

 Procedure T1135(RetNo: integer; FName: String;FNo: integer);
 Procedure PS50Pg1(RetNo: integer; FName: String;FNo: integer);
 Procedure PS50Pg2(RetNo: integer; FName: String;FNo: integer);
 Procedure PS50Pg3(RetNo: integer; FName: String;FNo: integer);
 Procedure TESTFRM(RetNo: integer; FName: String;FNo: integer);
 Function IsFormElmInTfPropDynList(FName:String;Fld:Integer):Boolean;
 Procedure PRVCR(RetNo: integer; FName: String;FNo: integer);
 Procedure UsedFrm(RetNo: integer; FName: String;FNo: integer);
 Procedure CalcUsedFrm(RetNo: integer);
// Procedure Autos(RetNo:integer;FName:string;FNo:integer);
// Procedure ASSETSB(RetNo:integer;FName:string;FNo:integer);
// Procedure T3INCOME(RetNo: integer; FName: String;FNo: integer);
// Procedure T5INCOME(RetNo: integer; FName: String;FNo: integer);
// Procedure T5013INC(RetNo: integer; FName: String;FNo: integer);
 Procedure FLDTAPE(RetNo: integer; FName: String;FNo: integer);
// Procedure T3OTHDED(RetNo: integer; FName: String;FNo: integer);
 Procedure FldMEM(RetNo: integer; FName: String;FNo: integer);
 Procedure CutPast(RetNo:integer;FName:string;FNo:integer);
// Procedure ClearAllProvTaxForms(RetNo:Integer);
 procedure STATUS(RetNo: integer; FName: String;FNo: integer);
 Procedure ClearThisForm(RetNo:integer;FName:string);
// Function GetSurtaxReduction(RetNo:Integer;Bft:Real):Real;
 Procedure CalcMultiPageForm(RetNo:integer;FName:string);
// Procedure CalcPrvTaxAndCredits(RetNo:integer);
// Procedure LoadTV(RetNo: integer;FName: string; FNo : integer);
// Procedure SaveTV(RetNo: integer;FName: string; FNo : integer);
// Procedure Calc(RetNo: integer; FName: string);
// Procedure CalcAffectedBy(RetNo: integer; FName: String);

//Function S1SectionII(RetNo:Integer):Boolean;
// Function S1SectionIII(RetNo:Integer):Boolean;
// Function S1SectionIV(RetNo:Integer):Boolean;
// Function CalcInclusionRate(RetNo:Integer):Real;
// Function CalcBCSurtax(RetNo:Integer;ATax:Real):Real;


// procedure T3(RetNo: integer; FName: string; FNo: integer);

 (*
 procedure S1(RetNo: integer;FName: string;FNo: integer);
 procedure S1SUPQ(RetNo:integer;FName:string;FNo:integer);
 procedure S2(RetNo: integer;FName: string;FNo: integer);
 procedure S1A(RetNo: integer;FName: string;FNo: integer);

 procedure S3(RetNo: integer;FName: string;FNo: integer);

 procedure S4(RetNo: integer;FName: string;FNo: integer);

 procedure S5(RetNo: integer;FName: string;FNo: integer);
 procedure S6(RetNo: integer;FName: string;FNo: integer);
 procedure S7(RetNo: integer;FName: string;FNo: integer);
 procedure S8(RetNo: integer;FName: string;FNo: integer);

 procedure S9(RetNo: integer;FName: string;FNo: integer);

 procedure S10(RetNo: integer;FName: string;FNo: integer);

 procedure S11(RetNo: integer;FName: string;FNo: integer);
 procedure S11A(RetNo: integer;FName: string;FNo: integer); //20170325

 procedure S12(RetNo: integer;FName: string;FNo: integer);

 procedure T3ON(RetNo: integer;FName: string;FNo: integer);
 procedure T3AB(RetNo: integer;FName: string;FNo: integer);
 procedure T3BC(RetNo: integer;FName: string;FNo: integer);
 procedure T3NB(RetNo: integer;FName: string;FNo: integer);
 procedure T3NS(RetNo: integer;FName: string;FNo: integer);
 procedure T3NL(RetNo: integer;FName: string;FNo: integer);
 procedure T3NU(RetNo: integer;FName: string;FNo: integer);
 procedure T3NT(RetNo: integer;FName: string;FNo: integer);
 procedure T3MB(RetNo: integer;FName: string;FNo: integer);
 procedure T3SK(RetNo: integer;FName: string;FNo: integer);
 procedure T3PE(RetNo: integer;FName: string;FNo: integer);
 procedure T3YT(RetNo: integer;FName: string;FNo: integer);
*)
// procedure T3ADJ(RetNo: integer;FName: string;FNo: integer);
 procedure PENSINC(RetNo: integer;FName: string;FNo: integer);
// procedure ABIL(RetNo: integer;FName: string;FNo: integer);
// Procedure T1135(RetNo:integer;FName:string;FNo:integer);

 Procedure T1055(RetNo:integer;FName:string;FNo:integer);
{
 procedure T3Sl1(RetNo: integer;FName: string;FNo: integer);
 procedure T3Sl23(RetNo: integer;FName: string;FNo: integer);
 procedure T3Sl4(RetNo: integer;FName: string;FNo: integer);
}
 procedure NR4Sl1(RetNo: integer;FName: string;FNo: integer);
 procedure NR4Sl23(RetNo: integer;FName: string;FNo: integer);
 procedure NR4Sl4(RetNo: integer;FName: string;FNo: integer);

// procedure T3LOSS(RetNo: integer; FName: String;FNo: integer);

// procedure T3DON(RetNo: integer; FName: String;FNo: integer);

 Procedure LETR_1(RetNo: integer; FName: String;FNo: integer);
 Procedure LETR_2(RetNo: integer; FName: String;FNo: integer);
 Procedure ADDINFO(RetNo: integer; FName: String;FNo: integer);
 Procedure NR6(RetNo: integer; FName: String;FNo: integer);
// Procedure T3OTHDED(RetNo: integer; FName: String;FNo: integer);
 Procedure NR6INSTR(RetNo: integer; FName: String;FNo: integer);
 Procedure CALCALL(RetNo: integer);
// Procedure CalcFullT3(RetNo:Integer);
 Procedure CalcFullT5013(RetNo:Integer);
 Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo:Integer);//20160310 Igor
 { I M P L E M E N T A T I O N }
implementation

Uses TF_2026ChildWinNew, TF_2026Main, vtTrimStr, TF_2026,
  vtShared, vtCommon, vtChild;


Procedure CalcMultiPageForm(RetNo:integer;FName:string);
Var i,n:integer;Root:string[10];
begin
   n:=GetFormMxPg(FName);
   Root := ExtractFormRootName(FName);
   If Root = 'PAGE_' Then begin Calc(RetNo,FName);exit;end;
   For i:=1 to n do
     Calc(RetNo,Root+'_'+IntToStr(i)+ExtractFormInst(FName));
end;


Procedure CALCALL(RetNo: integer);
Var i: integer;Fnm : string[10];
begin
 Calc(RetNo,'NR4SUM');  //20180316
 //charity
 Calc(RetNo,'T3010');
 Calc(RetNo,'T1235#1');
 Calc(RetNo,'T1236#1');
 Calc(RetNo,'T2057#1'); //20240519

 PopulateT5018G(RetNo);

 If Ret[RetNo].FrmHasData[GetFormNo('T5013FIN')] = True then
 begin
   DeleteT5013Slips(RetNo);
   CreateNewT5013Slips(RetNo);
   for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    If LeftStr(Frec.FormName,6) = 'T5013#' then
     T5013(RetNo,Frec.FormName,Frec.FormNo);
   end;

   CalcFullT5013(RetNo); //20260905  //ir includes calcualation of the T5013 slips
  {
   CreateNewT5013Slips(RetNo);  //20260903 Update it so it has he same number os forms as in PS50
   RevisePartnerIdOfSlips(RetNo); //create any new slips and enter ParterId on them from ps50 forms
   CalcFullT5013(RetNo);   //ir includes calcualation of the T5013 slips
  }
 end;
 Ret[RetNo].CalcStatus := True;
end;


Procedure CalcFullT5013(RetNo:Integer);
Var i,j,k:integer;
begin
  for I := 0 to (FList.Count - 1) do //20230325
  begin
    FRec := FList.Items[I];
    If (Ret[RetNo].FrmHasData[FRec.FormNo])
    and (FRec.FormType='PA') then
      Calc(RetNo,Frec.FormName);  //20260830
  end;

  PS8(RetNo,'PS8#1', GetFormNo('PS8#1'));
  //PS10(RetNo,'PS10#1', GetFormNo('PS10#1'));  //20130217
  PS141(RetNo,'PS141', GetFormNo('PS141'));

  T5013WS(RetNo, 'T5013WS', GetFormno('T5013WS'));
  Calc(RetNo, 'S58#1'); // 20220510  Fuel
  Calc(RetNo, 'S58#2'); // 20220510  Fuel
  Calc(RetNo, 'S63'); // 20220510  Fuel
  Calc(RetNo, 'S65'); // 20220510  Air

  Calc(RetNo, 'T1135'); // 20240318
  T5013Sum(RetNo, 'T5013SUM', GetFormno('T5013SUM'));

  //second time //20230324 to complete all affected schedules
  //20260828cz  to update all T5013#1  to last partner

  T5013Sum(RetNo, 'T5013SUM', GetFormno('T5013SUM'));
 // GenerateT5013SlipsNEW(RetNo);//GenerateT5013Slips(RetNo);

  T5013FIN(RetNo,'T5013FIN', GetFormNo('T5013FIN'));

  //  //20260908
  //GenerateT5013PS50Pg1Pg2Forms(RetNo);   //20120228   //out on 20120321
  //GenerateT5013PS50PG3Forms(RetNo);  //20120324

  //20260904

  //20260908
  //DeleteT5013Slips(RetNo); //create any new slips and enter ParterId on them
  //CreateNewT5013Slips(RetNo); //create any new slips and enter ParterId on them
  {
  k:=GetNumberofPartnersFromPs50(RetNo);
  for j:=1 to k do
  begin
   T5013(RetNo, 'T5013#'+IntToStr(j),GetFormNo('T5013#'+IntToStr(j)));
  end;


  //Not here It is done in the T5013
  //20260904
  CreateNewT5013Slips(RetNo);
  k:=GetNumberofPartnersFromPs50(RetNo);
  for j:=1 to k do
  begin
   T5013(RetNo, 'T5013#'+IntToStr(j),GetFormNo('T5013#'+IntToStr(j)));
  end;
  }

end;


Procedure NR4Sl1(RetNo:integer;FName:string;FNo:integer);
Var i,NumSlips:Integer; PercentAlloc : real; Tp:string[1];
begin
end;

Procedure NR4Sl23(RetNo:integer;FName:string;FNo:integer);
Var i,NumSlips:Integer; PercentAlloc : real; Tp:string[1];
begin
 {No calc not displayed}
end;

Procedure NR4Sl4(RetNo:integer;FName:string;FNo:integer);
Var i,NumSlips:Integer; PercentAlloc : real; Tp:string[1];
begin
  {No calc not displayed}
end;


Procedure AddInfo(RetNo:integer;FName:string;FNo:integer);
begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[FNo] do
 begin
  Strings[1] := OptRec.Prp_Name;
 end;
SaveTv(RetNo,FName,FNo);
end;

procedure LETR_1(RetNo: integer; FName: String;FNo: integer);
begin
PrepLetter(RetNo,FName,FNo,1);
end;

procedure LETR_2(RetNo: integer; FName: String;FNo: integer);
begin
PrepLetter(RetNo,FName,FNo,2);
end;





Procedure ClearThisForm(RetNo:integer;FName:string);
var i,n,FNo :integer;
begin

 Fno := GetFormNo(FName);
 If (Fno >0) and (Ret[RetNo].Frm[FNo].Count >0)  then
 begin
   n := GetNumbFields(FName);
   For i :=1 to n do
    StoreElm(RetNo,FNo,i,'');  //20120127
   //Begin Ret[Retno].Frm[FNo].Strings[i] := '';Tv[i]:=0;end;
 Calc(RetNo,FName);
 end;
end;

procedure STATUS(RetNo: integer; FName: String;FNo: integer);
Var I: integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Strings[15] := OptRec.Prp_Name;
   Strings[16] :=OptRec.Prp_Street;
   Strings[17] :=OptRec.Prp_City;
   Strings[18] :=OptRec.Prp_Prov;
   Strings[19] :=OptRec.Prp_Postal;
   Strings[20] :=OptRec.Prp_Area+' '+OptRec.Prp_Tel;
   Strings[21] :=OptRec.Prp_Fax;

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure T1055(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
    Frm[FNo].Strings[1] := FetchElm(RetNo,'T3',1);
    Frm[FNo].Strings[2] := FetchElm(RetNo,'T3',2);
    Frm[FNo].Strings[3] := FetchElm(RetNo,'T3',17);

    If UpperCase(Frm[FNo].Strings[23])<>'Y' then   //20130503
    begin
     For i:=4 to 307 do begin Frm[FNo].Strings[i]:=''; Tv[i]:=0;end;
     SaveTv(RetNo,FName,FNo);
     Exit;
    end;

   end;

   // T1055 pg 2 ---------------------------------------------------------------

   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin

        {QSB}
 	Tv[168] := Tv[148] - Tv[149] - Tv[157];
	Tv[204] := Tv[201] - Tv[202] - Tv[203];
        {Tv[224] := T5013ElgblQSB1+T3ElgblQSB1;}
       	Tv[205] := Tv[148] + Tv[201] + Tv[190];
	Tv[206] := Tv[168] + Tv[204] + Tv[224];
       {Qfarm}
        //20160210
        Tv[34]:=Tv[31]-Tv[32]-Tv[33];
        Tv[40]:=Tv[37]-Tv[38]-Tv[39];
        Tv[41]:=Tv[34]+Tv[40];
        //---
    	Tv[212] := Tv[209] - Tv[210] - Tv[211];
        {Tv[226] := T5013ElgblQFP1+T3ElgblQFP1;}
       	Tv[213] := Tv[209] + Tv[225];
	Tv[214] := Tv[212] + Tv[226];
        Tv[214]:=Tv[41]+Tv[42];    //20160210
       {shares}
    	Tv[107] := Tv[104] - Tv[105] - Tv[106];
	Tv[114] := Tv[111] - Tv[112] - Tv[113];

        Tv[116] := TotMultiple(RetNo,'S1SUPPL',71); //Vl(FetchElm(RetNo,'S1SUPPL',71));
        Tv[117] := TotMultiple(RetNo,'S1SUPPL',72); //Vl(FetchElm(RetNo,'S1SUPPL',72)); //20130503

	Tv[118] := Tv[104] + Tv[111] + Tv[116];
	Tv[119] := Tv[107] + Tv[114] + Tv[117];
        {RE}
	Tv[125] := Tv[122] - Tv[123] - Tv[124];
	Tv[131] := Tv[128] - Tv[129] - Tv[130];

        Tv[133] := TotMultiple(RetNo,'S1SUPPL',91); //Vl(FetchElm(RetNo,'S1SUPPL',91));
        Tv[134] := TotMultiple(RetNo,'S1SUPPL',92); //Vl(FetchElm(RetNo,'S1SUPPL',92));

	Tv[135] := Tv[122] + Tv[128] + Tv[133];
	Tv[136] := Tv[125] + Tv[131] + Tv[134];
        {Bonds}
	Tv[146] := Tv[143] - Tv[144] - Tv[145];
	Tv[156] := Tv[153] - Tv[154] - Tv[155];

        Tv[158] := TotMultiple(RetNo,'S1SUPPL',125); //Vl(FetchElm(RetNo,'S1SUPPL',125));
        Tv[159] := TotMultiple(RetNo,'S1SUPPL',126); //Vl(FetchElm(RetNo,'S1SUPPL',126));

	Tv[160] := Tv[143] + Tv[153] + Tv[158];
	Tv[161] := Tv[146] + Tv[156] + Tv[159];
        {pers use}
        //Tv[25]:=Tv[180]; //20131228
	Tv[178] := Tv[175] - Tv[176] - Tv[177];
        //Tv[180]:=Tv[25];
	Tv[181] := Tv[178] + Tv[180];
        Tv[26]:=Tv[175]+Tv[25];   //20131228

        {lpp}
        Tv[27]:=Tv[184]; //20131228
	Tv[187] := Tv[184] - Tv[185] - Tv[186];
	Tv[188] := MaxR(0,Tv[187] - Tv[198]);
        Tv[28]:=Tv[187];  //20131228

	Tv[138] := Tv[206]+Tv[214]+
                  Tv[119] + Tv[136] + Tv[161]+ Tv[181] + Tv[188];

     	Tv[162] := Tv[138];
        //Tv[163] := FetchInclusionRate(RetNo);
        Tv[164] := Tv[162] * (1/2); //Tv[163];
        Tv[165] := MaxR(0,Tv[164]);
        If Vl(FetchElm(RetNo,'S1',97)) <0 then
           Tv[166] := ABS(Vl(FetchElm(RetNo,'S1',97)))
        else
           Tv[166]:=0;
        Tv[167] := MaxR(0,Tv[165]-Tv[166]);
        Tv[169] := Tv[167];

        Tv[195] := Tv[171]+Tv[192]+Tv[196];
        Tv[216]:=Tv[172]+Tv[193]+Tv[197];
        Tv[217]:=Tv[189]+Tv[194]+Tv[215];
        Tv[218] := Tv[217];                   //20160210
        Tv[221] := MaxR(0,Tv[219]-Tv[220]);
        Tv[222] := Tv[221];
        Tv[227] := Tv[169]+Tv[218]+Tv[222]+Tv[223];
   end;

   // T1055 pg 3 ---------------------------------------------------------------
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
    If (Tv[164]<0) and   //cap loss   //20131228 Line 25
       (Vl(FetchElm(RetNo,'S1',97))>0)  then  //line 23   //20131229
    Begin
     Tv[301] := MaxR(0,Vl(FetchElm(RetNo,'S1',97))); //20131229//MaxR(0,Vl(FetchElm(RetNo,'S1_4',12)));
      //20160210
     If Tv[164]<0 then
       Tv[302] := ABS(Tv[164])
     Else
       Tv[302]:=0;

     Tv[303] := MaxR(0,Tv[301]-Tv[302]);
    end
    Else
    begin
      Tv[301] :=0;
      Tv[302] :=0;
      Tv[303] :=0;
    end;
    Tv[307] := MaxR(0,Tv[304]-Tv[306]);
   end;

   SaveTv(RetNo,FName,FNo);

 end;


Procedure PENSINC(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo], Ret[RetNo].Frm[FNo] do
   begin
    i:=2;
    Tv[9]:=0;
    Repeat
     Tv[9]:=Tv[9]+Tv[i];
     Inc(i,2);
    until I>8;

    i:=11;
    Tv[18]:=0;
    Repeat
     Tv[18]:=Tv[18]+Tv[i];
     Inc(i,2);
    until I>17;

    i:=20;
    Tv[27]:=0;
    Repeat
     Tv[27]:=Tv[27]+Tv[i];
     Inc(i,2);
    until I>26;

    i:=29;
    Tv[36]:=0;
    Repeat
     Tv[36]:=Tv[36]+Tv[i];
     Inc(i,2);
    until I>35;

    i:=38;
    Tv[45]:=0;
    Repeat
     Tv[45]:=Tv[45]+Tv[i];
     Inc(i,2);
    until I>44;

    Tv[46]:=Tv[9]+Tv[18]+Tv[27]+Tv[36]+Tv[45];
   end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure CutPast(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[8]:=Strings[5]+'-recalced';
  end;
  For i:=1 to 24 do StoreElm(RetNo,FNo,i,Ret[RetNo].Frm[FNo].Strings[i]);
 (*
 // If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
   //1.
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo] do
   begin
   end;
 SaveTv(RetNo,FName,FNo);
 *)
end;

Procedure FldMEM(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure NR6(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   If Strings[1]='' then Strings[1]:=AppYear;
   Tv[32]:=0;Tv[33]:=0;Tv[34]:=0;
   i:=40;
   Repeat
    Tv[i+2]:=Tv[i]-Tv[i+1];
    Tv[32]:=Tv[32]+Tv[i];
    Tv[33]:=Tv[33]+Tv[i+1];
    Tv[34]:=Tv[34]+Tv[i+2];
    Inc(i,7);
   until i>75;
   If Strings[31]='' then Strings[31]:=FormatDateTime('yyyy-mm-dd',Now);
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure NR6INSTR(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   If Strings[1]='' then Strings[1]:=AppYear;
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure FLDTAPE(RetNo: integer; FName: String;FNo: integer);
Var RefFormName:String;
    //20220121 Igor >>>
    TapeStr: string;
    Idx: integer;
    //20220121 Igor <<<
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FormatSettings.DecimalSeparator:='.';  //needed
    Tv[125]:=AddColumns(1,60,1);
    RefFormName:= Strings[121];
    //If UpperCase(LeftStr(Strings[121],3))='MED' then begin Strings[123]:='';Strings[124]:='X';end;
    //20220121 Igor >>>
    If (Tv[125] <> 0) and (Strings[123] + Strings[124] = '') then
    begin
      Strings[123] := 'X';
      Strings[124] := '';
    end;
    TapeStr := RefFormName + '|' + Strings[122];
    If (UpperCase(Strings[123])='X') and (RefFormName>'') then
    begin
      StoreElm(RetNo,GetFormNo(RefFormName),MyStrToInt(Strings[122]),
       FormatFloat('########.##',TV[125]));
      if not ret[RetNo].TapesList.Find(TapeStr, Idx) then
        ret[RetNo].TapesList.Add(TapeStr);
    end
    else if ret[RetNo].TapesList.Find(TapeStr, Idx) then
      ret[RetNo].TapesList.Delete(Idx);
    //20220121 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
  If (UpperCase(Ret[RetNo].Frm[FNo].Strings[123])='X')
   and (RefFormName>'') then
  begin
    Calc(RetNo,RefFormName);
  end;
  {CalcAllForms(RetNo);}
  //MainForm.UpdateTaxPanel(RetNo);
end;

Procedure UsedFrm(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    //nothing
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure PRVCR(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If Tv[4]>1000 then Tv[4]:=1000;
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure CalcUsedFrm(RetNo: integer);
Var
  i,FNo:Integer;FName:String;
  MyPageControl:TPageControl;
  MyTabSheet : TTabSheet;
begin
 (* 20190413
  FName:='USEDFRM';
  FNo:=GetFormNo(FName);
  Try
  //MyChild:=MainForm.ActiveMDIChild as TMyChild;
  MyPageControl:=GetChild(RetNo).Pages; //GetPageControl(MyChild);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    For i:=1 to 30 do begin Strings[i]:='';end;
    For i:=0 to MyPageControl.PageCount-1 do
    begin
      MyTabSheet:=MyPageControl.Pages[i];
      If i<=30 then
        //if +1 is removed then the info screen is not included....
        Strings[i+1]:=MyTabSheet.Caption;
    end;
   // Strings[31]:=FormName;         //20130214
  end;
  SaveTv(RetNo,FName,FNo);
  Except
  end;
  *)
end;

Function IsFormElmInTfPropDynList(FName:String;Fld:Integer):Boolean;
//if on thec list the elm is NOT vtDollar
Var i:Integer;s:String;
Begin
 Result:=False;
 s:=RTrim(PaddR(Fname,10)+PaddR(IntToStr(fld),6));
 For i:=0 to TfPropDynList.Count-1 do
 begin
  If s=LeftStr(TfPropDynList[i],16) then begin Result:=True;Exit;end;
 end;
end;


Procedure TESTFRM(RetNo: integer; FName: String;FNo: integer);
Var i,Elm,ArrayNo:Integer;BoxesPerRow:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //Array 1 math
   ArrayNo:=1;
   BoxesPerRow:=12; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
   Tv[1]:=0;
   Elm:=ArrayNo*10000+StrToInt('3'); //for field id 10003 on the first row i form
   For i:=0 to MaxDynamicElmsPerForm do
   begin
    Tv[1]:=Tv[1]+Vl(FetchElmFNo(RetNo,FNo,Elm));
    Elm:=Elm+BoxesPerRow;
   end;
   //Array 2 math
   ArrayNo:=2;
   BoxesPerRow:=2;
   Tv[29]:=0;
   Tv[30]:=0;
   Elm:=ArrayNo*10000+StrToInt('1'); //array comes as 1, 2 so elm s/b 10001, 10013 etc //first box '1'
   For i:=0 to MaxDynamicElmsPerForm do
   begin
    Tv[29]:=Tv[29]+Vl(FetchElmFNo(RetNo,FNo,Elm));
    Tv[30]:=Tv[30]+Vl(FetchElmFNo(RetNo,FNo,Elm+1));
    Elm:=Elm+BoxesPerRow;
   end;
  end;
 // StoreElm(RetNo,FNo,1,FormatFloat('#######.##',Tv[1]));
 SaveTv(RetNo,FName,FNo);   //20110131
end;

Procedure PS50Pg1(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  GenerateT5013PS50Pg1Pg2Forms(RetNo);  //20120323
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   //
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure PS50Pg2(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  GenerateT5013PS50Pg1Pg2Forms(RetNo);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   //
  end;
  SaveTv(RetNo,FName,FNo);

end;

Procedure PS50Pg3(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  GenerateT5013PS50PG3Forms(RetNo);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   //
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo:Integer);//20160310 Igor
Var j,Elm:Integer;
Begin
  Elm:= ArrayNo*10000+StrToInt('1'); //firstColumn
  If FetchElmFNo(RetNo,FNo,Elm)='' then
  begin
     For j:=1 to 4 do Begin StoreElm(RetNo,FNo,Elm+j,'');end;
  end;
end;

//20180422
Procedure T1135(RetNo: integer; FName: String;FNo: integer);
Var i,Elm,ArrayNo,T5013FinFNo:Integer;BoxesPerRow:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    T5013FinFNo:=GetFormNo('T5013FIN');   //20210326
    If Strings[21]='' then Strings[21]:='CAD';
    Strings[1] := '';
    Strings[6] := '';
    Strings[9] := '';
    //Strings[12] := 'X'; //t5013 only user input
    if Strings[12] >'' then  //20240725
    begin
     Strings[13] := FetchElm(RetNo,'T5013FIN',7);
     Strings[14] := LeftStr(FetchElm(RetNo,'T5013FIN',1),9);
     Strings[35] := MidStr(FetchElm(RetNo,'T5013FIN',1),12,5);
    end
    Else
    Begin
     Strings[13] :='';
     Strings[14] :='';
     Strings[35] :=''
    End;

    if Strings[42]>'' then begin Strings[34]:='';Strings[86]:='X';end; //20180422
    if Strings[28]='' then Strings[28]:='CAN';  //20160617

    //20210326
    {
    Strings[15]:= FetchElmFNo(RetNo,T5013FinFNo,13)
       +', '+FetchElmFNo(RetNo,T5013FinFNo,14)
       +', '+FetchElmFNo(RetNo,T5013FinFNo,15);
    Strings[63]:=FetchElmFNo(RetNo,T5013FinFNo,16);
    Strings[16]:=FetchElmFNo(RetNo,T5013FinFNo,18);
    Strings[28]:=FetchElmFNo(RetNo,T5013FinFNo,17);
    if Strings[28]='' then Strings[28]:='CAN';  //20160617
    }

    //------------------------------------

    ArrayNo:=1;
    BoxesPerRow:=5;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
    Tv[18]:=0;Tv[31]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     //If Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))=0 then StoreElmDynamic(RetNo,FNo,elm,FormatFloat('########0',Round(Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))))); //??  20160124
     Tv[18]:=Tv[18]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[31]:=Tv[31]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;


    ArrayNo:=2;
    BoxesPerRow:=6; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
    Tv[32]:=0;Tv[33]:=0;Tv[43]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[32]:=Tv[32]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[33]:=Tv[33]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[43]:=Tv[43]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=3;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);            //20160124
    Tv[40]:=0;Tv[41]:=0;Tv[45]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[40]:=Tv[40]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[41]:=Tv[41]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[45]:=Tv[45]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=4;
    BoxesPerRow:=7;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);    //20160124
    Tv[51]:=0;Tv[52]:=0;Tv[54]:=0;Tv[56]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[51]:=Tv[51]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[52]:=Tv[52]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[54]:=Tv[54]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('7');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[56]:=Tv[56]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=5;
    BoxesPerRow:=6; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[61]:=0;Tv[62]:=0;Tv[68]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[61]:=Tv[61]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[62]:=Tv[62]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[68]:=Tv[68]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=6;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[81]:=0;Tv[82]:=0;Tv[85]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[81]:=Tv[81]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[82]:=Tv[82]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[85]:=Tv[85]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    //20150103
    ArrayNo:=7;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[37]:=0;Tv[38]:=0;Tv[44]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[37]:=Tv[37]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[38]:=Tv[38]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[44]:=Tv[44]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    //20210326
    If Strings[70] = '' then Strings[70] := FetchElmFNo(RetNo,T5013FINFNo,143)+' '+FetchElmFNo(RetNo,T5013FINFNo,142); //Name of sign
    If Strings[71] = '' then Strings[71] := FetchElmFNo(RetNo,T5013FINFNo,144);  //Position of sign
    If Strings[72] = '' then Strings[72] :='1'+ '('+FetchElmFNo(RetNo,T5013FINFNo,146)+')'+FetchElmFNo(RetNo,T5013FINFNo,147);  //Teleph //20210326
    If Strings[73] = '' then Strings[73] := ReplaceChar(FormatDateTime('yyyy-mm-dd',Now),' ','');  //20180113 //not slashes, In T1135Efile is converted to dashes

    If UpperCase(Strings[29])='Y' then
    Begin
     Strings[74] := OptRec.Prp_Name;
     Strings[75] := OptRec.Prp_Street;
     Strings[78] := OptRec.Prp_City;
     Strings[79] := OptRec.Prp_Prov;
     Strings[76] := OptRec.Prp_Postal;
     Strings[77]:=ReplaceChar(Strings[77],' ','');   //20180113
    end
    Else
    Begin
     for i:=74 to 79 do Strings[i]:='';
    End;
 end;
 SaveTv(RetNo,FName,FNo);
end;



end.
