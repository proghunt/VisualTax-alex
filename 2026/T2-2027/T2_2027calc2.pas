unit T2_2027calc2;

interface

uses
Dialogs, Math; //20260508 Alex
{
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 UDeclare,common, common2,TrimStr;
}

//procedure UHT(RetNo: integer; FName: String;FNo: integer); //20231020  //20240726 Igor
procedure S8FREE(RetNo: integer;FName: string;FNo: integer);  //20210508


Procedure CONSENT(RetNo:integer;FName:string;FNo:integer); //20200212
Function PermanentEstablishmentInProvince(RetNo:Integer;Prov:String):Boolean; //20181105 CON
procedure GroupInfo(RetNo: integer;FName: string;FNo: integer); //20170715

//20191912
procedure S349(RetNo: integer;FName: string;FNo: integer);
procedure S350(RetNo: integer;FName: string;FNo: integer);
procedure S352(RetNo: integer;FName: string;FNo: integer); //20220917
procedure S353(RetNo: integer;FName: string;FNo: integer); //20220917
//20130531
procedure S322(RetNo: integer;FName: string;FNo: integer);
procedure S461(RetNo: integer;FName: string;FNo: integer);
procedure S481(RetNo: integer;FName: string;FNo: integer);

procedure S305(RetNo: integer;FName: string;FNo: integer);
procedure S306(RetNo: integer;FName: string;FNo: integer);
procedure S307(RetNo: integer;FName: string;FNo: integer);
procedure S308(RetNo: integer;FName: string;FNo: integer);  //20171120
procedure S60(RetNo: integer;FName: string;FNo: integer);
Procedure RC59(RetNo:integer;FName:string;FNo:integer);
Procedure RC59X(RetNo:integer;FName:string;FNo:integer);
procedure S346(RetNo: integer;FName: string;FNo: integer);
Procedure S347(RetNo: integer; FName: String;FNo: integer);
procedure S97(RetNo: integer;FName: string;FNo: integer);

//Procedure T2054(RetNo:integer;FName:string;FNo:integer); //20240728 Igor

procedure S16(RetNo: integer;FName: string;FNo: integer);
procedure S17(RetNo: integer;FName: string;FNo: integer);

procedure S20(RetNo: integer;FName: string;FNo: integer);

procedure S21(RetNo: integer;FName: string;FNo: integer);

procedure S22(RetNo: integer;FName: string;FNo: integer);
procedure S23(RetNo: integer;FName: string;FNo: integer);
procedure S24(RetNo: integer;FName: string;FNo: integer);
procedure S25(RetNo: integer;FName: string;FNo: integer);

procedure S27RATE(RetNo: integer;FName: string;FNo: integer);

procedure S27(RetNo: integer;FName: string;FNo: integer);

procedure S28(RetNo: integer;FName: string;FNo: integer);
procedure S29(RetNo: integer;FName: string;FNo: integer);
procedure S31(RetNo: integer;FName: string;FNo: integer);
procedure S33(RetNo: integer;FName: string;FNo: integer);

procedure S34(RetNo: integer;FName: string;FNo: integer);

procedure S35(RetNo: integer;FName: string;FNo: integer);

//procedure S37(RetNo: integer;FName: string;FNo: integer);  //20170525
procedure S39(RetNo: integer;FName: string;FNo: integer);
procedure S40(RetNo: integer;FName: string;FNo: integer);
procedure S41(RetNo: integer;FName: string;FNo: integer);
procedure S42(RetNo: integer;FName: string;FNo: integer);

procedure S43(RetNo: integer;FName: string;FNo: integer);

procedure S44(RetNo: integer;FName: string;FNo: integer);
procedure S45(RetNo: integer;FName: string;FNo: integer);
procedure S46(RetNo: integer;FName: string;FNo: integer);
procedure S49(RetNo: integer;FName: string;FNo: integer);
procedure S50(RetNo: integer;FName: string;FNo: integer);
procedure S52(RetNo: Integer; FName: string; FNo: Integer); //20261006 Alex
Procedure S75(RetNo: integer;FName: string;FNo: Integer);

procedure S71(RetNo: integer;FName: string;FNo: integer);
procedure S72(RetNo: integer;FName: string;FNo: integer);
procedure S73(RetNo: integer;FName: string;FNo: integer);

procedure S76(RetNo: integer;FName: string;FNo: integer);
Procedure S77(RetNo: integer;FName: string;FNo: Integer); //20260508 Alex
procedure S78(RetNo: integer;FName: string;FNo: integer);
procedure S130(RetNo: integer;FName: string;FNo: integer);
procedure T2184(RetNo: integer;FName: string;FNo: integer);


Function FixDD(DD:integer;MM:integer):integer;
Procedure T7B(RetNo:integer;FName:string;FNo:integer);

Procedure Invoice(RetNo:integer;FName:string;FNo:integer);
Procedure InvForms(RetNo:integer;FName:string;FNo:integer);

Procedure INSTLM(RetNo:integer;FName:string;FNo:integer);
Procedure POLIT(RetNo:integer;FName:string;FNo:integer);

//procedure S300(RetNo: integer;FName: string;FNo: integer);
procedure S301(RetNo: integer;FName: string;FNo: integer);
procedure S302(RetNo: integer;FName: string;FNo: integer);

procedure S303(RetNo: integer;FName: string;FNo: integer);

Procedure S304(RetNo: integer; FName: String;FNo: integer);
procedure S321(RetNo: integer;FName: string;FNo: integer);

procedure S340(RetNo: integer;FName: string;FNo: integer);

procedure S341(RetNo: integer;FName: string;FNo: integer);

procedure S360(RetNo: integer;FName: string;FNo: integer);

procedure S366(RetNo: integer;FName: string;FNo: integer);
procedure S380(RetNo: integer;FName: string;FNo: integer);
procedure S381(RetNo: integer;FName: string;FNo: integer);
procedure S383(RetNo: integer;FName: string;FNo: integer);

procedure S384(RetNo: integer;FName: string;FNo: integer);

procedure S385(RetNo: integer;FName: string;FNo: integer);
procedure S388(RetNo: integer;FName: string;FNo: integer);
procedure S389(RetNo: integer;FName: string;FNo: integer);

procedure S400(RetNo: integer;FName: string;FNo: integer);

procedure S402(RetNo: integer;FName: string;FNo: integer);
procedure S403(RetNo: integer;FName: string;FNo: integer);
procedure S404(RetNo: integer;FName: string;FNo: integer);
//procedure S410(RetNo: integer;FName: string;FNo: integer); //20170525
procedure S411(RetNo: integer;FName: string;FNo: integer);
//procedure S460(RetNo: integer;FName: string;FNo: integer);
//procedure S480(RetNo: integer;FName: string;FNo: integer);

procedure S421(RetNo: integer;FName: string;FNo: integer);


//procedure S426(RetNo: integer;FName: string;FNo: integer);  //20170525


procedure S427(RetNo: integer;FName: string;FNo: integer);

procedure S420(RetNo: integer;FName: string;FNo: integer);
procedure S440(RetNo: integer;FName: string;FNo: integer);

procedure S442(RetNo: integer;FName: string;FNo: integer);
procedure S443(RetNo: integer;FName: string;FNo: integer);

procedure S91(RetNo: integer;FName: string;FNo: integer); //new sep 2008

Procedure S70(RetNo:integer;FName:string;FNo:integer);

procedure S422(RetNo: integer;FName: string;FNo: integer);

procedure S423(RetNo: integer;FName: string;FNo: integer);

Procedure T661(RetNo:integer;FName:string;FNo:integer);
Procedure S30(RetNo:integer;FName:string;FNo:integer);
Procedure T661F(RetNo:integer;FName:string;FNo:integer);

Procedure S425(RetNo:integer;FName:string;FNo:integer);

implementation

Uses
  SysUtils, Classes,
  vtMulti,vtCommon,
  //UCalc;
  T2_2027,T2_2027Multi,
  T2_2027Declare,T2_2027common, T2_2027common2,T2_2027TrimStr,
  vtTrimStr,vtShared;


Function FixDD(DD:integer;MM:integer):integer;
begin
 result := dd;
 If dd>31 then result :=31;
 If (mm=2) and (dd>28) then result :=28;
 If ((mm=4) or (mm=6) or (mm=9) or (mm=11))
  and (dd>30) then result :=30;
end;

Procedure T7B(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   i:=3;Tv[52] :=0;
   Repeat
    If Tv[i]<0 then Tv[i]:=0;
    Tv[52]:=Tv[52]+Tv[i];
    Inc(i,3);
   until i>51;
  end; { end with}
SaveTv (RetNo, Fname, FNo);
end;

Procedure InvForms(RetNo:integer;FName:string;FNo:integer);
Var i,j,PagesCharged,HowToFormat:integer; Frms,HowMany:TstringList;
begin
 UpdateAllDataIndicators(RetNo);
 LoadTv(RetNo,FName,FNo);
 Frms := TStringList.Create;
 HowMany := TStringList.Create;
 with Ret[RetNo].Frm[Fno] do
 begin
  PagesCharged :=0;
  Strings[1] := GetCorpName(RetNo);
  Strings[2] :=AppYear;
  Strings[3] :=IntToStr(CountPagesGenerated(RetNo));
  HowToFormat :=GetHowToFormat(FName,5);
  Strings[5] := FormatAmount(FName,FloatToStr(GetTotalFee(RetNo)),HowToFormat);
  GetListInvoiceForms(RetNo,Frms,HowMany);
  j := 7;
  For i:=0 to Frms.Count-1 do
    begin
    Inc(PagesCharged,MyStrToInt(HowMany[i]));
    Strings[j]   := PaddR(HowMany[i],5)+Frms[i];
    HowToFormat :=GetHowToFormat(FName,J+1);
    Strings[j+1] :=FormatAmount(FName,FloatToStr(GetFormFee(Frms[i],MyStrToInt(HowMany[i]))),HowToFormat);

    Inc(j,2);
    If J>130 then break;
    end;
  Strings[4] := IntToStr(PagesCharged);
 end;
 Frms.Free;HowMany.Free;
 SaveTv(RetNo,FName,FNo); // not needed}
end;


Procedure Invoice(RetNo:integer;FName:string;FNo:integer);
Begin
 UpdateAllDataIndicators(RetNo);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
 Strings[1] := OptRec.PRp_Name;
 Strings[2] := OptRec.PRp_Street;
 Strings[4] := OptRec.PRp_City+', '+OptRec.PRp_Prov;
 Strings[5] := OptRec.PRp_Postal;
 Strings[7] := OptRec.PRp_Area+' '+OptRec.PRp_Tel;
 Strings[8] := OptRec.PRp_GSTNo;
 If Strings[3]='' then Strings[3] := DateToMonthDayYear(Date);  //20121229
 If FillSignatureDates=True then Strings[9] := FormatDateTime('yyyy/mm/dd',Date); {DateToStr(Date);}

 If Strings[10]='' then
  Strings[10] := LeftStr(GetAccountNumber(RetNo),9)+'-'+
    LeftStr(GetTaxationYearend(RetNo),4);
 If Strings[11] ='' then  Strings[11] := GetCorpName(RetNo);
 If Strings[12] ='' then Strings[12] := Rtrim(FetchElm(RetNo,'T2',12))+
                 ' '+Rtrim(FetchElm(RetNo,'T2',13));
 If Strings[15] ='' then Strings[15] := Rtrim(FetchElm(RetNo,'T2',16))
     +', '+Rtrim(FetchElm(RetNo,'T2',17))+', '+
     Rtrim(FetchElm(RetNo,'T2',20))+' '+
     Rtrim(FetchElm(RetNo,'T2',19));

 Strings[16] := LeftStr(GetTaxationYearEnd(RetNo),4);

 If Strings[51]+Strings[49]+Strings[44]+Strings[45]+Strings[46]+
         Strings[47]+Strings[48]+Strings[52] =''
 then
   begin
         Case MyStrToInt(OptRec.Prp_Bill) of
          0: Strings[51] :='X';
          1: Strings[49] :='X';
          2: begin Strings[52] :='X';Strings[50] := '30';end;
          3: Strings[46] :='X';
         end;
   end;

 If Strings[44]>'' then Tv[17] := OptRec.Prp_VSFee else Tv[7] :=0;
 If Strings[45]>'' then Tv[17] := OptRec.Prp_SFee else Tv[6]:=0;
 If Strings[46]>'' then Tv[17] := OptRec.Prp_AFee else tv[8] :=0;
 If Strings[47]>'' then Tv[17] := OptRec.Prp_CFee else Tv[9]:=0;
 If Strings[48]>'' then Tv[17]:= OptRec.Prp_VCFee else Tv[10]:=0;
 If Strings[49]>'' then Tv[17]:= GetTotalFee(RetNo);
 If Strings[52]>'' then Tv[17]:= Vl(Strings[50]) *OptRec.Prp_Hour/60;


 Tv[19] := Tv[17] + Tv[18]+Tv[34] + Tv[35]+Tv[36] + Tv[37]+Tv[38] + Tv[39]+
           Tv[42] + Tv[43];


 If Strings[8] = '' then
     Strings[20] := ''
 else
 begin
  If Strings[20] ='' then
   Strings[20] :=FormatFloat('###.00',OptRec.OPR_GSTHST);
 end;
 Tv[21] := Tv[19] * Vl(Strings[20]) / 100;
 Tv[22] := Tv[19] + Tv[21];  //+Tv[13]; 20101123
 Strings[26] := User.Prep_Name;
 //Footer
  Strings[72]:=OptRec.InvFoot1;
  Strings[73]:=OptRec.InvFoot2;
  Strings[74]:=OptRec.InvFoot3;
  Strings[79]:=OptRec.InvFoot4;
  Strings[80]:=OptRec.InvFoot5;
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure RC59(RetNo:integer;FName:string;FNo:integer);
Var i:Integer; s:String;
Begin

  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    if Strings[66]='' then Exit;

    Strings[1] := GetCorpName(RetNo);
    Strings[2]:= LeftStr(GetAccountNumber(RetNo),9);

    //20180709
    if Strings[11]>'' then //use for Efile
    Begin
     if Strings[57]+Strings[20]='' then Strings[10]:=OptRec.Prp_repid; //no groupid or bus No. //20180731 CON
    End
    Else
    Begin
      Strings[10]:='';
      Strings[57]:='';
      Strings[13]:='';

      if (trim(strings[16]) = '3') then strings[16] := '';
      if (trim(strings[22]) = '3') then strings[22] := '';
      if (trim(strings[29]) = '3') then strings[29] := '';
      if (trim(strings[36]) = '3') then strings[36] := '';
      if (trim(strings[43]) = '3') then strings[43] := '';
    End;



    If UpperCase(Strings[65])='Y' then  //if copy from Config
    begin
     Strings[3]:=OptRec.Prp_ContactFN+' '+OptRec.Prp_ContactLn;
     Strings[7] := OptRec.Prp_Area;
     Strings[8] := OptRec.Prp_Tel;

     Strings[6] := OptRec.Prp_Name;
     Strings[9]:=LeftStr(OptRec.Prp_BusNo,9);
    end;

   //Part 3
    i:=17;
    Repeat
     if Strings[17]='' then begin Strings[i+1]:='';Strings[i+2]:='';Strings[i+5]:='';Strings[i+6]:=''; end;
     If Strings[i+1]>'' then Strings[i+2]:='';
     Inc(i,7);
    until i>38;

    //Part 4
    s:=''; for i:=76 to 82 do s:=s+strings[i];
    if S='' then Strings[76]:='X';

    if Strings[52]='' then Strings[52]:=FetchElm(RetNo,'T2',743);  //first
    if Strings[53]='' then Strings[53]:=FetchElm(RetNo,'T2',742);  //last nm

    if Strings[14]='' then Strings[14]:=FetchElm(RetNo,'T2',755);  //erea
    if Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',746);    //phone

    If Strings[55]='' then Strings[55]:=FormatDateTime('yyyy/mm/dd',Date);

    //If On-line Authorization  //20180728
    if Strings[11]>'' then
    Begin
     Strings[3]:='';
     Strings[7]:='';
     Strings[8]:='';
     Strings[6]:='';
     Strings[9]:='';
    End;

    if Strings[12]='' then begin Strings[16]:='';Strings[15]:='';end; //20180728  //not all programs
  end; //with
End;

Procedure RC59X(RetNo:integer;FName:string;FNo:integer);
Var i:Integer; s:String;
Begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    if Strings[66]='' then Exit;

    Strings[1] := GetCorpName(RetNo);
    Strings[2]:= LeftStr(GetAccountNumber(RetNo),9);

    s:=''; for i:=76 to 82 do s:=s+strings[i];
    if S='' then Strings[76]:='X';

    if Strings[52]='' then Strings[52]:=FetchElm(RetNo,'T2',743);  //first
    if Strings[53]='' then Strings[53]:=FetchElm(RetNo,'T2',742);  //last nm

    if Strings[14]='' then Strings[14]:=FetchElm(RetNo,'T2',755);  //erea
    if Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',746);    //phone

    If Strings[55]='' then Strings[55]:=FormatDateTime('yyyy/mm/dd',Date);

   //20180803
   Strings[28]:=LeftStr(Strings[28],2);
   Strings[41]:=LeftStr(Strings[41],2);
  end; //with
End;



Procedure INSTLM(RetNo:integer;FName:string;FNo:integer);
Var i,k,Mcnt:Integer;dd,mm,yyyy:integer;
//YrEnd:string[10];
YrEnd:string;//[10]; //20150701
Sep :string;//[1]; //20150701 //Sep :string[1];
FedBase,{InstlmBase,}AlbBase,x :real;
WinbootDir:String;
begin
 Try
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    {Fed}
    Tv[4] :=Vl(FetchElm(RetNo,'T2',733)); {Ret[RetNo].Ln[163];}
    Tv[5] :=Vl(FetchElm(RetNo,'T2',732)); {Ret[RetNo].Ln[165];}
    With Ret[RetNo] do
    begin
     FedBase := MaxR(0,Vl(FetchElm(RetNo,'T2',714)));
     {subtract credits x};
     x:=0;
     For i:=715 to 720 do x:=x+Vl(FetchElm(RetNo,'T2',i));
     x:=x+Vl(FetchElm(RetNo,'T2',754));
     For i:=722 to 724 do x:=x+Vl(FetchElm(RetNo,'T2',i));
     x:=x+Vl(FetchElm(RetNo,'T2',726));
     //20171129
     FedBase := MaxR(0,FedBase-x);
     FedBase :=FedBase * DaysInYear/365;
    end;
    {Alb}
    If Vl(FetchElm(RetNo,'AT1',125)) <0 then
     begin
      Tv[8] :=0;
      Tv[9]:=ABS(Vl(FetchElm(RetNo,'AT1',125)));
     end
     else
      begin
      Tv[8] :=Vl(FetchElm(RetNo,'AT1',125));
      Tv[9] :=0;
      end;

     //20130207
     Tv[10] := Tv[4]+Tv[8];
     Tv[11] := Tv[5]+Tv[9];

     //20171129
     //fed base
     With Ret[retno] do
     Begin
      //Fed
       Tv[80]:=Ln[700]+Ln[720]+Ln[724]+Ln[727];
       Tv[81]:=Ln[760];
       Tv[81]:=MaxR(0,Tv[81]-GetRefundableTaxCreditsAllProvinces(RetNo)); //20171201
       Tv[82]:=Tv[80]+Tv[81];
       //Tv[83]:=?
       Tv[84]:=MaxR(0,Tv[82]-Tv[83]);
       Tv[85]:=Tv[84] *(365/DaysInYear);  //20171201
       //Tv[85]:=Tv[84] *(DaysInYear/365);
       Tv[6]:=MaxR(0,Tv[85]+Tv[86]);
       Tv[87]:=Round(Tv[6]/12);
      //Alb
       Tv[88]:=Vl(FetchElm(RetNo,'AT1',118));
       //Tv[89]:=??
       Tv[90]:=MaxR(0,Tv[88]-Tv[89]);
       Tv[91]:=Tv[90] *(365/DaysInYear); //20171201
       Tv[7]:=MaxR(0, Tv[91]+Tv[92]);
       Tv[93]:=Round(Tv[7]/12);
     End;

     //20171129
     if Tv[80]<=3000 then
     Begin
      for i:=80 to 87 do Tv[i]:=0;
      Tv[6]:=0;
     End;


     YrEnd:=GetTaxationYearEnd(RetNo);
     If Yrend='' then exit; //20090723
     {Put dates}
     If UpperCase(Strings[74]) <> 'Y' then
     begin
      i:=14; Mcnt:=0;
      Repeat
       Inc(MCnt);
       dd := StrToInt(RightStr(YrEnd,2))+1;     {add 1 to day, later fix if > 31}
       mm := StrToInt(MidStr(YrEnd,6,2))+MCnt;
       yyyy := StrToInt(LeftStr(YrEnd,4));
       Strings[i] := RemoveChar(PaddZero(IntToStr(dd),2)
                     +'-'+PaddZero(IntToStr(mm),2)
                     +'-'+PaddZero(IntToStr(yyyy),4),
                     ' ');
       Tv[i+1] := Tv[87]; //FedBase/12 else Tv[i+1] :=0;  //20100214
       Tv[i+3] := Tv[93]; //AlbBase/12;   //20171129
       Inc(i,5);
      until i>69;
      {Fix day,Month, year}
      i:=14;
      Repeat
       dd := MyStrToInt(LeftStr(Strings[i],2));
       mm := MyStrToInt(MidStr(Strings[i],4,2));
       yyyy := MyStrToInt(RightStr(Strings[i],4));
       If mm >12 then
        begin mm:=mm-12;yyyy := yyyy+1;end;
       dd :=FixDD(dd,mm);
       Strings[i] := RemoveChar(PaddZero(IntToStr(dd),2)
                     +'-'+PaddZero(IntToStr(mm),2)
                     +'-'+PaddZero(IntToStr(yyyy),4),
                     ' ');
       Inc(i,5);
      until i>69;
     {Calc PayDue date : 3 months}
      dd := StrToInt(RightStr(YrEnd,2));
      mm := StrToInt(MidStr(YrEnd,6,2))+3; {add 3 months}
      dd :=FixDD(dd,mm);
      yyyy := StrToInt(LeftStr(YrEnd,4));
      If mm>12 then begin mm:=mm-12;yyyy:=yyyy+1;end;
      dd :=FixDD(dd,mm);
      Strings[12]:=RemoveChar(
                        PaddZero(IntTostr(dd),2)
                   +'-'+PaddZero(IntToStr(mm),2)
                   +'-'+PaddZero(IntToStr(yyyy),4),' ');

      {Calc FileDue date : 6 months}
      dd := StrToInt(RightStr(YrEnd,2));
      mm := StrToInt(MidStr(YrEnd,6,2))+6; {add 6 months}
      yyyy := StrToInt(LeftStr(YrEnd,4));
      If mm>12 then begin mm:=mm-12;yyyy:=yyyy+1;end;
      dd :=FixDD(dd,mm);

      Strings[13]:=RemoveChar(
                        PaddZero(IntTostr(dd),2)
                   +'-'+PaddZero(IntToStr(mm),2)
                   +'-'+PaddZero(IntToStr(yyyy),4),' ');

     end; {override}
     {add horizontal}
     i:=14;
     Repeat
      Tv[i+4] := Tv[i+1]+Tv[i+3];
      Inc(i,5);
     until i>69;
  end; { end with}
 except
    on E: Exception do ExceptMsg(E);   //20150703
 end; {try}
SaveTv (RetNo, Fname, FNo);

end;


Procedure POLIT(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   {Ont}
   Tv[32]:=Vl(FetchElm(RetNo,'S525',7));
   {Alb}
   I:=35;
   Tv[42]:=0;
   Repeat
    If DateWithinTaxYear(Strings[i-2],RetNo) = false then Tv[i]:=0;
    Tv[42]:= Tv[42]+Tv[i];
    Inc(i,3);
   until i > 41;
   If LeftStr(GetBegYearEnd(RetNo),4) >'2003' then Tv[128]:=0;
   If LeftStr(GetTaxationYearEnd(RetNo),4) <'2004' then Tv[129]:=0;
   Tv[42]:=Tv[42]+Tv[128]+Tv[129];
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
   {NFLD}
   I:=105;Tv[112]:=0;Repeat Tv[112]:= Tv[112]+Tv[i];Inc(i,3); until i > 111;
   {yuk}
   I:=115;Tv[122]:=0;Repeat Tv[122]:= Tv[122]+Tv[i];Inc(i,3); until i > 121;
   {Sask}
   I:=25;Tv[127]:=0;Repeat Tv[127]:= Tv[127]+Tv[i];Inc(i,3); until i > 31;

   {sumit up}
   Tv[123] :={Tv[22]+}Tv[127]+Tv[130]+Tv[131]; //Sask, QC and NU}  //20110929
   i := 32;  {other prov}
   Repeat
    Tv[123] := Tv[123] +Tv[i];
    Inc(i,10);
   until i>122;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S17(RetNo: integer;FName: string;FNo: integer); //20181030 Igor
Var i:integer;x:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If Not IsCreditUnion(RetNo) then
   begin
    For i:=4 to 71 do Tv[i]:=0;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;


  Strings[1] := GetCorpName(RetNo);
  Strings[2]:= LeftStr(GetAccountNumber(RetNo),9);
  Strings[3]:=GetTaxationYearEnd(RetNo);

  Tv[29] := AddColumns(8,28,5);
  Tv[55] := AddColumns(34,54,5);
  Tv[56]:=Tv[29]+Tv[55];


  //Part 3 ---------------------------------------------------------------------
  //20181105 CON
  If (PermanentEstablishmentInProvince(RetNo,'ON')=True)
  //or (PermanentEstablishmentInProvince(RetNo,'MB')=True) //jz 2019 MB gets own section
  or (PermanentEstablishmentInProvince(RetNo,'BC')=True) then
  begin
   Tv[38]:=Vl(FetchElm(RetNo,'T2',232));
   //Tv[40]:=Tv[58]; //jz 2019 ???

   //jz 2019 moved from below Tv[43] depends on it as per form (amount 3G)??
   Tv[93]:=Tv[91]+Tv[92];
   Tv[94]:=Tv[93];

//   Tv[43]:=Tv[94]; //jz 2019 changed from Tv[59]; as per form //20181107
   Tv[81]:=MaxR(0,Tv[40]-Tv[43]);
   Tv[45]:=Tv[81];
   Tv[48]:=MinR(Tv[45],Tv[38]);

   Tv[50]:=GetIncForSmBusDed(RetNo); //jz 2019 changed from Tv[62];, got code from there
   Tv[53]:=MaxR(0,Tv[48]-Tv[50]);

   Tv[75]:=Tv[53];
   Tv[78]:=Round(Tv[75]*19/100); //jz 2019 change rate

   Tv[93]:=Tv[91]+Tv[92];
   Tv[94]:=Tv[93];

   Tv[95]:=Ret[RetNo].Ln[430];
   //Tv[98]:=Tv[78];
   Tv[97]:=Tv[95]+Tv[98];


   Tv[105]:=Tv[97];
   Tv[108]:=Round(Tv[105]* 0.19);

   Tv[110]:=Tv[108];
   Tv[111]:=Tv[94]+Tv[110];
  End
  Else
  Begin
   For i:=91 to 97 do begin Tv[i]:=0;end;
   Tv[110]:=0;
   Tv[111]:=0;
  End;

   //Part 4 //20191028---------------------------------------------------------------------
  //jz 2019 - all new section
 // begin
    Tv[112] := Vl(FetchElm(RetNo,'S383',38));
    Tv[115] := MaxR(0,Tv[113]-Tv[114]);
    Tv[116] := Tv[115];
    Tv[117] := MinR(Tv[112],Tv[116]);
    Tv[118] := Vl(FetchElm(RetNo,'S383',13));
    Tv[119] := MaxR(0,Tv[117]-Tv[118]);

    Tv[136] := Tv[119];
    Strings[137] := IntToStr(GetNumDays(RetNo,'31-12-2020','A')-GetNumDays(RetNo,'31-12-2021','A')); //???
    Strings[138] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[139] := (Tv[136]*(Vl(Strings[137])/Vl(Strings[138])))*0.4;

    Tv[140] := Tv[119];
    Strings[141] := IntToStr(GetNumDays(RetNo,'31-12-2021','A')-GetNumDays(RetNo,'31-12-2022','A')); //???
    Strings[142] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[143] := (Tv[140]*(Vl(Strings[141])/Vl(Strings[142])))*0.2;

    Tv[144] := Tv[139] + Tv[143];
    Tv[145] := Tv[144];

    Tv[147] := Tv[145];
    Tv[148] := Tv[147]*0.12;

    Tv[155] := Tv[153]+ Tv[154];

    Tv[156] :=vl(FetchElm(RetNo,'S383',45)); //Tv[152]; //jz 2019 Tv[156] := Tv[119];
    Tv[157] := Tv[145];

    Tv[159] := Tv[155] +Tv[156] +Tv[157];
    Tv[160] := Tv[159];
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;






procedure S20(RetNo: integer;FName: string;FNo: integer);
Var i,k,Pg8FNo:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If (IsNonResidentCorp(RetNo) = False)
   or (UpperCase(Strings[24]) <> 'Y')
   then
   begin
    For i:=1 to 31 do begin Strings[i]:='';Tv[i]:=0;end;
    For i:=101 to 127 do begin Strings[i]:='';Tv[i]:=0;end; //from pg 2
    For i:=201 to 214 do begin Strings[i]:='';Tv[i]:=0;end; //from pg 3
    For i:=301 to 327 do begin Strings[i]:='';Tv[i]:=0;end; //from pg 4
    For i:=401 to 538 do begin Strings[i]:='';Tv[i]:=0;end; //from pg 5
    SaveTv(RetNo,FName,FNo);
    Exit;
   end;

   FillHeader(RetNo,FNo,1,2,3);
   Tv[4]:=Ret[RetNo].Ln[360]; //Vl(FetchElm(RetNo,'T2',234)); //20201016
   If IsTaxExempt(retNo) then Tv[4]:=0;
   Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
   Tv[8]:=Tv[6];

   Tv[12]:=Tv[10]+Tv[11];
   Tv[13]:=Tv[12];
   Tv[14]:=MaxR(0,Tv[9]-Tv[13]);
   Tv[15]:=Tv[14];

   Tv[19]:=MaxR(0,Tv[17]-Tv[18]);
   Tv[20]:=Tv[19];

   Tv[22]:=Tv[8]+Tv[7]+Tv[15]+Tv[16]+Tv[20]+Tv[21];

  end; {End with}
  //S20 pg 2--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin


   Pg8FNo:=GetFormNo('T2');
   Tv[101]:= Vl(FetchElmFNo(RetNo,Pg8FNo,701))+
             Vl(FetchElmFNo(RetNo,Pg8FNo,702))+
             Vl(FetchElmFNo(RetNo,Pg8FNo,706));

   If IsTaxExempt(RetNo) then Tv[101]:=0;

   Tv[128]:=Vl(FetchElm(RetNo,'S5',411))
           +Vl(FetchElm(RetNo,'S5',414))
           +Vl(FetchElm(RetNo,'S5',546))
           +Vl(FetchElm(RetNo,'S5',508))
           +Vl(FetchElm(RetNo,'S5',720)) //mb
           +Vl(FetchElm(RetNo,'S5',733)) //sk
           +Vl(FetchElm(RetNo,'S5',816)) //bc
           +Vl(FetchElm(RetNo,'S5',825)) //yt
           +Vl(FetchElm(RetNo,'S5',928))
           +Vl(FetchElm(RetNo,'S5',905));

   Tv[129]:=Vl(FetchElm(RetNo,'S5',623))
              +Vl(FetchElm(RetNo,'S5',624));
   //Tv[30] = Quebec
   Tv[131]:=Vl(FetchElm(RetNo,'AT1',118));  //alb
   Tv[102]:=Tv[128]+tv[129]+Tv[130]+Tv[131];
   Tv[103]:=Tv[101]+Tv[102];
   Tv[104]:=Tv[103];
   Tv[105]:=Vl(FetchElm(RetNo,'S20',6));
   Tv[106]:=Vl(FetchElm(RetNo,'S20',4));
   If Tv[106]>0 then Tv[107]:=Tv[104] * Tv[105]/Tv[106] else Tv[107]:=0;
   Tv[108]:=Vl(FetchElm(RetNo,'S1',7));  //20121108
   Tv[109]:=MaxR(Vl(FetchElm(RetNo,'S20',325)),Vl(FetchElm(RetNo,'S20',537)));

   Tv[114]:=Tv[112]+Tv[113];
   Tv[115]:=Tv[114];
   Tv[116]:=MaxR(0,Tv[111]-Tv[115]);
   Tv[117]:=Tv[116];
   Tv[118]:=Tv[107]+Tv[108]+Tv[109]+Tv[117];
   If Tv[122]>Tv[125] Then Tv[122]:=Tv[125];
   Tv[119]:=Vl(FetchElm(RetNo,'S20',22));
   Tv[120]:=Tv[118];
   Tv[121]:=MaxR(0,Tv[119]-Tv[120]);
   Tv[110]:=Tv[121];
   Tv[123]:=MaxR(0,Tv[110]-Tv[122]);
   Tv[133]:=Tv[123];
   If Tv[132]=0 then Tv[132]:=25;
   If Tv[132]>25 then Tv[132]:=25; //20140511
   Tv[124]:=Tv[133] * Tv[132]/100;  //20140511
   If Tv[125]>500000 then Tv[125]:=500000;
   Tv[126]:=Tv[122];
   Tv[127]:=MaxR(0,Tv[125]-Tv[126]);
  end; {End with}
  //S20 pg 3--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin


   If UpperCase(FetchElm(RetNo,'S20',23)) = 'Y' then  //autho foreign bank
   begin
    For i:=201 to 202 do begin Strings[i]:='';Tv[i]:=0;end;  //20191421
    For i:=203 to 214 do begin Strings[i]:='';Tv[i]:=0;end;
    //For i:=201 to 214 do begin Strings[i]:='';Tv[i]:=0;end;
    For i:=301 to 327 do begin Strings[i]:='';Tv[i]:=0;end; //from pg 4
    For i:=401 to 538 do begin Strings[i]:='';Tv[i]:=0;end; //from pg 5
    SaveTv(RetNo,FName,FNo);
    Exit;
   end;

   Tv[203]:=Tv[226]*4/3;
   Tv[213]:=MinR(Tv[211],Tv[212]);
   Tv[214]:=AddColumns(201,202,1)+AddColumns(204,209,1)+Tv[213];  //20190421 //203 out
   //Tv[214]:=AddColumns(201,209,1)+Tv[213]; //AddColumns(201,210,1)+Tv[213]; //20171120

  end; {End with}

  //S20 pg 4--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[322]:= AddColumns(315,320,1);
   Tv[323]:=Tv[322];
   Tv[324]:=MaxR(0,Tv[214]-Tv[323]);  //20121006

   If UpperCase(Strings[327])<>'Y' then Tv[325]:=Tv[324];

  end; {End with}
  //S20 pg 5--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   i:=400;
   k:=400;
   Tv[533]:=0;
   Repeat
     If Strings[i+1]>'' then Inc(k);
     Tv[i+3]:=Round(Tv[i+2]*5/100);
     Tv[i+7]:=Tv[i+5]+Tv[i+6];
     Tv[i+9]:=Tv[i+7]+Tv[i+8];
     If Tv[i+9]>Tv[i+2]-Tv[i+3]-Tv[i+7] then
       Tv[i+9]:=Tv[i+2]-Tv[i+3]-Tv[i+7];
     Tv[i+10]:=MaxR(0,Tv[i+4]-Tv[i+9]);
     Tv[i+11]:=MaxR(Tv[i+3],Tv[i+10]);
     Tv[133]:=Tv[133]+Tv[i+11];
     Inc(i,11);
   until i>522;
   if k>0 then Tv[534]:= Round(Tv[533]/k) else Tv[534]:=0;
   Tv[536]:=MaxR(0,Tv[534]-Tv[535]);
   If UpperCase(Strings[538])<> 'Y' then Tv[537]:=Tv[536];
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

procedure S21(RetNo: integer;FName: string;FNo: integer);
Var i,j,k:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   i:=8;Tv[49] :=0;j:=102;  //witout surtax etc. //2 less than starting point
   Tv[119]:=0;
   Repeat
    If Tv[i-3]<0 then Tv[i-3]:=0;
    If Tv[i-2]<0 then Tv[i-2]:=0;
    If Tv[i-1]<0 then Tv[i-1]:=0;
    Tv[i] := MaxR(0,Tv[i-2] -Tv[i-1]);
    If Tv[i]>0 then Tv[i+1]:= Tv[308] //20280628 Vl(FetchElm(RetNo,'S21',308))
     else Tv[i+1] :=0;
    If Strings[i-4]='' then
      Tv[i+2] := 0
    Else
      Tv[i+2] := Tv[316]; //Vl(FetchElm(RetNo,'S21',316));  //20280628

    If Strings[i-4]='' then
      Tv[J+2] := 0
    else
      Tv[j+2]:=TV[323]; //Vl(FetchElm(RetNo,'S21',323));  //20280628
    If Tv[i+1] >0 then
    begin
      Tv[i+3] := RoundCorrect((Tv[i-3] * Tv[i+2]) / Tv[i+1]); //20180610
      Tv[J+3] := RoundCorrect((Tv[i-3] * Tv[J+2]) / Tv[i+1]); //20180610
    end
    else
    begin
      Tv[i+3] :=0;
      Tv[j+3]:=0;
    end;

    If Tv[i+3]>Tv[I+2] then Tv[i+3]:=Tv[i+2];
    If Tv[J+3]>Tv[J+2] then Tv[J+3]:=Tv[J+2];

    Tv[i+4] := MinR(Tv[i],Tv[i+3]);
    Tv[J+4] := MinR(Tv[i],Tv[J+3]);

    Tv[49] := Tv[49]+Tv[i+4];
    Tv[119]:= Tv[119]+Tv[J+4];
    Inc(i,9);
    Inc(j,3);
   until i>40;

   If UpperCase(Strings[102]) <>'N' then Tv[103] := Tv[49];

   i:=54;Tv[100]:=0;k:=0;
   Repeat
    If Tv[i-3]<0 then Tv[i-3]:=0;  //20140602
    If Tv[i-2]<0 then Tv[i-2]:=0;  //20140602
    If Tv[i-1]<0 then Tv[i-1]:=0;  //20140602
    Tv[i] := Tv[i-2] +Tv[i-1];
    Tv[i+1]:= Tv[308]; //Vl(FetchElm(RetNo,'S21',308)); //20280628
    If Strings[i-4]='' then
    begin
     Tv[i+1]:=0;  //20110717
     Tv[i+2]:=0;
    end
    Else
     Tv[i+2] := Tv[322]; //Vl(FetchElm(RetNo,'S21',322)); //20280628
    If Tv[i+1] >0 then
    begin
     Tv[i+4] := RoundCorrect((Tv[i-3] * Tv[i+2]) / Tv[i+1]); //20180610
     end
    else
    begin
     Tv[i+4] :=0;
     end;
    Tv[i+3]:= MaxR(0,Tv[I+2]- Tv[103]); //20130307
    Tv[i+5] := MinR(Tv[i],MinR(Tv[i+3],Tv[i+4]));
    Tv[100] := Tv[100]+Tv[i+5];

    Inc(i,10);
    Inc(k);
   until i>90;
  Tv[101] := AddColumns(7,43,9);
  end; {End with}
  //S21 pg2 --------------------------------------------------------------------
  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
  i:=201;j:=50;
  Repeat
   If Tv[i+3]+Tv[i+4]>0 then
     Frm[FNo].Strings[i] := FetchElm(RetNo,'S21',j)
   else
     Frm[FNo].Strings[i]:='';
   Tv[i+3] := MaxR(0,Tv[i+1] - Tv[i+2]);
   Tv[i+5] := Vl(FetchElm(RetNo,'S21',j+2));
   Tv[i+6]    := Vl(FetchElm(RetNo,'S21',j+9));
   Tv[i+7] := Tv[i+11]+Tv[i+12]+Tv[i+13];
   Tv[i+8] := MaxR(0,Tv[i+3]+Tv[i+4]+Tv[i+5]-Tv[i+6]-Tv[i+7]);
   If Tv[i+11]+Tv[i+12]+Tv[i+13]>0 then
    Frm[FNo].Strings[i+9] := FetchElm(RetNo,'S21',j)  //Frm[FNo].Strings[i]
   else
    Frm[FNo].Strings[i+9]:='';
   Tv[i+10] := MaxR(0,Tv[i+5] - Tv[i+6]);
   Inc(i,14);
   Inc(j,10);
  until i>257;

  Tv[272] := RoundCorrect(Tv[271] * 6.666/100); //20180610
  Tv[274] := RoundCorrect(Tv[273] * (2/3));     //20180610
  Tv[275] := MinR(Tv[272],Tv[274]);

  Tv[277] := RoundCorrect(Tv[276] * 6.666/100); //20180610
  Tv[279] := RoundCorrect(Tv[278] * (2/3));     //20180610
  Tv[280] := MinR(Tv[277],Tv[279]);
  Tv[281] := Tv[275]+Tv[280];
  Tv[282] := RoundCorrect(GetTxblIncome(RetNo)* 6.666/100); //20180610
  Tv[283] := MinR(Tv[281],Tv[282]);
  end; {End with}
  //S21 pg3 --------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[301] := GetNetInc(RetNo);
   Tv[302] := Vl(FetchElm(RetNo,'T2',222));
   Tv[303] := Vl(FetchElm(RetNo,'T2',219));
   Tv[304] := Vl(FetchElm(RetNo,'T2',227));
   Tv[305] := Vl(FetchElm(RetNo,'T2',228));
   Tv[127]:= Vl(FetchElm(RetNo, 'T2', 271)); //20260508 Alex
   Tv[128]:= Tv[302] + Tv[303] + Tv[305] + Tv[127]; //20260508 Alex
   Tv[306]:= Tv[128]; //20260508 Alex
   Tv[129]:= MaxR(0, Tv[301] - Tv[306]); //20260508 Alex
   //Tv[306]:= MaxR(0, Tv[301] - Tv[302] - Tv[303] - Tv[305]); //20260508 Alex
   Tv[307] := Vl(FetchElm(RetNo,'T2',231));
   Tv[304] := Tv[129]+Tv[307];//Tv[306]+Tv[307];   //20260524

   If UpperCase(Strings[335])='Y' then   //20110508
   begin
     For i:=301 to 307 do Tv[i]:=0;
     Tv[328]:=Ret[RetNo].Ln[360];
     Tv[330]:=Ret[RetNo].Ln[300];
     Tv[331]:=Tv[307];
     Tv[332]:=Tv[330]+Tv[331];
     Tv[120]:=Tv[332];  //20210616
     Tv[333]:=MinR(Tv[328],Tv[120]); //Tv[333]:=MinR(Tv[328],Tv[332]);  //20210616
     Tv[308]:= Tv[333];
   end
   Else
   begin
    Tv[308]:=Tv[304];
    Tv[328]:=0;
    For i :=330 to 333 do Tv[i]:=0;
   end;

   Tv[309] := Ret[RetNo].Ln[550];
   Tv[310] := Ret[RetNo].Ln[608];
   Tv[311] := Ret[RetNo].Ln[620];
   //Tv[312] := Ret[RetNo].Ln[628]; //20210616
   Tv[324] := Ret[RetNo].Ln[639];

   Tv[121] := Tv[310]+Tv[311]+Tv[324];  //20210616
   Tv[313] := Tv[121];
   //Tv[313] := MaxR(0,Tv[309] -Tv[310]-Tv[311]-Tv[312]-Tv[324]);
   //Tv[314] := Ret[RetNo].Ln[600];   //20210616
   Tv[329] := Ret[RetNo].Ln[602];
   Tv[315] := Ret[RetNo].Ln[604];
   Tv[130]:= Vl(FetchElm(RetNo, 'T2', 130)); //20260508 Alex
   Tv[131]:= Vl(FetchElm(RetNo, 'T2', 642)); //20260508 Alex
   Tv[132]:= Vl(FetchElm(RetNo, 'T2', 199)); //20260508 Alex
   Tv[122]:= Tv[329] + Tv[315] + Tv[130] + Tv[131] + Tv[132]; //20260508 Alex
   Tv[123]:= Tv[122];
   Tv[316] := Tv[309]-Tv[313]+Tv[123]; //20210616//Tv[313]+Tv[314]+Tv[329]+Tv[315];

   //20210708
   Tv[323] :=MaxR(0,Tv[309]-Tv[313]+Tv[123]);
   //Tv[323] := Tv[313]+Tv[329];  //20110508

   Tv[317] := Ret[RetNo].Ln[550];
   Tv[318] := Ret[RetNo].Ln[620];
  // Tv[319] := Ret[RetNo].Ln[628]; //20210616
   Tv[325] := Ret[RetNo].Ln[638];
   Tv[326] := Ret[RetNo].Ln[639];
   Tv[124]:=Tv[318]+Tv[325]+Tv[326];
   Tv[320] := Tv[124];//20210616 //MaxR(0,Tv[317]-Tv[318]-Tv[319]-Tv[325]-Tv[326]);
   Tv[133]:= Vl(FetchElm(RetNo, 'T2', 130)); //20260508 Alex
   Tv[134]:= Vl(FetchElm(RetNo, 'T2', 642)); //20260508 Alex
   Tv[135]:= Vl(FetchElm(RetNo, 'T2', 199)); //20260508 Alex
   Tv[136]:= Vl(FetchElm(RetNo, 'T2', 130)); //20260508 Alex
   Tv[137]:= Tv[133] + Tv[134] + Tv[135] + Tv[136]; //20260508 Alex
   Tv[327]:= Tv[137]; //20260508 Alex
  // Tv[321] := Ret[RetNo].Ln[600];  //20210616
   Tv[327] := Ret[RetNo].Ln[602];

   //20210708
   Tv[322] := MaxR(0,Tv[317]-Tv[320]+Tv[327]);

   //Tv[322] := Tv[320]+Tv[327];  //20210616
   //Tv[334] := Tv[320]+Tv[327];  //20210708

   //20260508 Alex >>>
   //Page 5
   Tv[190]:= Tv[6] + Tv[15] + Tv[24] + Tv[33] + Tv[42];
   Tv[191]:= Tv[101];
   Tv[192]:= Tv[190] - Tv[191];
   Tv[193]:= Tv[49];
   Tv[194]:= Tv[192] - Tv[193];
   Tv[195]:= Tv[194];
   Tv[196]:= GetTxblIncomeFromS5(RetNo, PrvShort[GetPrvNdx(Ret[RetNo].Province)]);
   Tv[197]:= GetTxblIncome(RetNo);
   if PrvShort[GetPrvNdx(Ret[RetNo].Province)].Equals('ON') then Tv[197]:= IfThen(Tv[197] <> 0, Tv[197], 1000);
   Tv[198]:= Tv[195] * Tv[196] / IfThen(Tv[197] = 0, 1, Tv[197]);
   Tv[199]:= Tv[5] + Tv[14] + Tv[23] + Tv[32] + Tv[41];
   Tv[200]:= Tv[199];
   Tv[173]:= PrvHighRate[GetPrvNdx(Ret[RetNo].Province)]; //in Part 9 of S21

   //20260628 failing statement with province MJ.  Needs more provinces
   //see alsp PRVRate.d

   if PrvShort[GetPrvNdx(Ret[RetNo].Province)].Equals('ON') then Tv[173]:= Vl(GetOntBasicTaxRate(RetNo));
   Tv[175]:= Tv[200] * Tv[173] / 100;
   Tv[126]:= Tv[175];
   Tv[174]:= GetTxblIncomeFromS5(RetNo, PrvShort[GetPrvNdx(Ret[RetNo].Province)]);
   Tv[125]:= GetTxblIncome(RetNo);
   if PrvShort[GetPrvNdx(Ret[RetNo].Province)].Equals('ON') then Tv[197]:= IfThen(Tv[125] <> 0, Tv[125], 1000);
   Tv[177]:= Tv[126] * Tv[174] / IfThen(Tv[125] = 0, 1, Tv[125]);
   Tv[178]:= MinR(Tv[198], Tv[177]);
   //20260508 Alex <<<

  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

procedure S22(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S23(RetNo: integer;FName: string;FNo: integer);
Var i,j,jj,k:integer; x,AdjLimit:real;S9FNo:Integer;
begin
//  DecimalSeparator:='.'; //20130604
  FormatSettings.DecimalSeparator:='.'; //20150604
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If (Strings[11] >'') or (Strings[17]>'') then
     Strings[127]:='Y';

   Strings[1] :='';
   Strings[2] := IntToStr(GetTaxationYearEndYYYY(RetNo));
   If Strings[3]+Strings[4]='' then Strings[4]:='X';
   Strings[5] := GetCorpName(RetNo);
   Strings[6] := GetAccountNumber(RetNo);

   //20150114
   Tv[8]:=500000;
  // If Ret[RetNo].DaysInYear <357 then Tv[8]:= RoundCorrect(Tv[8] * Ret[RetNo].DaysInYear/365); //20180610 //20190820


   i:=5;
   Repeat  //remove line
    If Strings[i]='' then
    For k:=1 to 5 do begin Strings[i+k]:='';Tv[i+k]:=0;end;
    Strings[I+1]:=FixBusinessNumberMissingRC(Strings[I+1]); //20190820
    If LeftStr(Strings[i+2],1)='2' then Tv[i+3]:=0;   //20120604
    If Not Numeric(Strings[i+2]) then Strings[i+2]:='';     //20130602
    If Vl(Strings[i+4])<0 then Strings[i+4]:='';  //20130602
    Inc(i,6);
   until i>119;

   Strings[9]:='100';

   i:=11;
   Repeat
    If Strings[i]>'' then
    begin
     Strings[i+4]:=FormatFloat('###.000',Vl(Strings[i+4]));
     Tv[i+5]:=RoundCorrect(Tv[i+3] * Vl(Strings[i+4])/100); //20180610
    end
    else
    begin
     Strings[i+1]:='';
     Strings[i+2]:='';
     Tv[i+3]:=0;
     Strings[i+4]:='';
     Tv[i+5]:=0;
    end;
    Inc(i,6);
   until i>119;

   //find tot % of others
   x:=0;
   i:=15; //second row
   repeat
    x:=x+vl(Strings[i]);
    Inc(i,6);
   until i>123;
   Tv[9]:=100-x;
   Tv[10]:=Tv[8] * Tv[9]/100;
   Strings[9]:=FormatFloat('###.000',Tv[9]);

   Tv[125]:=Vl(Strings[9])+x;
   Strings[125]:=FormatFloat('###.000',Tv[125]);

   i:=10;
   Tv[126]:=0;
   repeat
    Tv[126]:=Tv[126]+Tv[i];
    Inc(i,6);
   until i>124;
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S24(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);

   {STORE type of corp}
   For i := 4 to 21 do
    If Strings[i] >'' then
    begin
     If   i=4 then Strings[66]:='01'
     else if i=6 then Strings[66]:='02'
     else if i=8 then Strings[66]:='03'
     else if i=10 then Strings[66]:='04'
     else if i=12 then Strings[66]:='05'
     else if i=14 then Strings[66]:='06'
     else if i=16 then Strings[66]:='07'
     else if i=18 then Strings[66]:='08'
     else if i=20 then Strings[66]:='09'
     else if i=5 then Strings[66]:='10'
     else if i=7 then Strings[66]:='11'
     else if i=9 then Strings[66]:='12'
     else if i=11 then Strings[66]:='13'
     else if i=13 then Strings[66]:='14'
     else if i=15 then Strings[66]:='15'
     else if i=17 then Strings[66]:='16'
     else if i=21 then Strings[66]:='99';
    end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S25(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   i:=4;
   Repeat
     If Strings[i]='' then begin Strings[i+1]:='';Strings[i+2]:='';Tv[i+1]:=0;Tv[i+2]:=0;end;
     Inc(i,3);
   until i>64;

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

(*
//20181114
procedure S300(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   FillHeader(RetNo,FNo,1,2,3);

   If (Ret[RetNo].Province = 'MJ')  or (Ret[RetNo].Province = 'NL') then
   begin
    Tv[4] := Vl(FetchElm(RetNo,'S27',213));
    Tv[5] := GetIncForSmBusDed(RetNo);
    Tv[6] := MaxR(0,Tv[4]-Tv[5]);
    Tv[7] := Tv[6];
    Tv[8] := Vl(FetchElm(RetNo,'S27',224));
    Tv[9] := MinR(Tv[7],Tv[8]);
    Tv[12]:= GetTxblIncomeInProv(RetNo,'NL');
    Tv[13]:= GetTxblIncome(RetNo);
    If Tv[13] >0 then
      Tv[10] := Tv[9] * Tv[12] / Tv[13]
    else
      Tv[10] :=0;
    //20170626
    Tv[14]:=Tv[10];
    Strings[15]:=IntToStr(GetNumDays(RetNo,'01-01-2016','B'));
    Strings[16]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[17]:=Tv[14]*Vl(Strings[15])/Vl(Strings[16]);
    Tv[11] := Round(Tv[17] * 0.09);//Tv[10] * 0.09;
   end
   else
    for i:=4 to 17 do Tv[i] :=0;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;
*)

procedure S301(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  If Vl(GetPrvAlloc(RetNo,'NL')) = 0 then
  begin
   For i:=1 to 11 do begin StoreElm(RetNo,FNo,i,'');end;
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);

   If (Ret[RetNo].Province = 'MJ')  or (Ret[RetNo].Province = 'NL') then
   begin
    FillHeader(RetNo,FNo,1,2,3);
    Tv[6] := Tv[4] * 0.15;
    Tv[9] := Tv[7]+Tv[8];
    Tv[10] := Tv[9];
    Tv[11] := Tv[6]+Tv[10];
   end
   else
    For I:=5 to 11 do Tv[i] :=0;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S302(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Tv[42]:=0;
    i:=5;
    Repeat
    If Tv[i]>3000000 then Tv[i]:=3000000;
    Tv[42]:=Tv[42]+Tv[i];
    Inc(i,2);
    until i>41;
    If Tv[42]>3000000 then Tv[42]:=3000000;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S303(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);

    Tv[14]:=AddColumns(5,13,2);
    Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
    Tv[18]:=Tv[17];

    Tv[20]:=Tv[14];
    Tv[21]:=Tv[19]+Tv[20];
    Tv[22]:=Tv[21];
    Tv[29]:=Tv[18]+Tv[22];
    Tv[23]:=Tv[29]; //Tv[18]+Tv[22];  //20171120

    Tv[24]:=MinR(50000,Tv[23]);
    Tv[25]:=Vl(FetchElm(RetNo,'S303',107));
    Tv[26]:=Tv[24]+Tv[25];
    Tv[27]:=Tv[26];
    Tv[28]:=MaxR(0,Tv[23]-Tv[27]);
  end; {End with}
  //S303 pg2 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
    Tv[107]:=Tv[102]+Tv[104]+Tv[106];
    Tv[124]:=AddColumns(109,123,2);
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

Procedure S304(RetNo: integer; FName: String;FNo: integer);
Var i,k:Integer;YEnd:String;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  with Ret[RetNo].Frm[FNo] do
  begin
   Tv[14]:=0;
   i:=5;
   Repeat
    Tv[14]:=Tv[14]+Tv[i];
    Inc(i,2);
   until i>13;
   Tv[17]:=MaxR(0,Tv[15]-Tv[16]);

   //Part 3
   i:=27;
   k:=1;
   Yend:=GetTaxationYearEnd(RetNo);
   Repeat
    If Strings[i]='' then Strings[i]:=GetPrevYearEnd(YEnd,k);
    Inc(i,2);
    Inc(k,1);
   until i>31;
   Tv[33]:=Tv[28]+Tv[30]+Tv[32];

   i:=34;
   k:=7;
   Yend:=GetTaxationYearEnd(RetNo);
   Repeat
    Strings[i]:=GetPrevYearEnd(YEnd,k);
    Inc(i,2);
    Dec(k,1);
   until i>48;

   Tv[50]:=AddColumns(35,49,2);
   Tv[18]:=Tv[17];
   Tv[19]:=Tv[14];
   Tv[20]:=Tv[19];
   Tv[21]:=Tv[18]+Tv[20];
   If Tv[22]>50000 then Tv[22]:=50000;
   If Tv[22]>Tv[21] then Tv[22]:=Tv[21];
   Tv[23]:=Tv[33];
   Tv[24]:=Tv[22]+Tv[23];
   Tv[25]:=Tv[24];
   Tv[26]:=MaxR(0,Tv[21]-Tv[25]);
  end;
  SaveTv(RetNo,FName,FNo);
end;

procedure S305(RetNo: integer;FName: string;FNo: integer);
Var i:integer;x:real;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  If (Ret[RetNo].Province = 'MJ')  or (Ret[RetNo].Province = 'NL') then
  begin
  with Ret[RetNo].Frm[Fno] do
  begin
    Tv[4]:=Vl(FetchElm(RetNo,'S38',17));
    If Tv[4]=0 then Tv[4]:=Vl(FetchElm(RetNo,'S38',20));
    Tv[5]:=5000000;
    If Ret[RetNo].FrmHasData[GetFormNo('S306')] then Tv[5]:=Vl(FetchElm(RetNo,'S306',6)); //related
    If Tv[4]>10000000 then Tv[5]:=0;
    Tv[6]:=MaxR(0,Tv[4]-Tv[5]);

    If IsTrustOrLoanCorp(RetNo) then
    begin
     Tv[7]:=Vl(FetchElm(RetNo,'S5',7))+Vl(FetchElm(RetNo,'S5',150));
     Tv[8]:=Vl(FetchElm(RetNo,'S5',172));
     If Tv[8]>0 then
       Strings[9]:=FormatFloat('##0.0000',Tv[7]/Tv[8])
     else
       Strings[9]:='';
     Tv[10]:=Tv[6];
     Strings[11]:=Strings[9];
     Tv[12]:=Tv[10] * Vl(Strings[11])/100;
    end
    Else
    begin
       For i:=7 to 13 do begin Tv[i]:=0;Strings[i]:='';end;
    end;

    If IsBankCorp(RetNo) then
    begin
     Tv[14]:=Vl(FetchElm(RetNo,'S5',5))+Vl(FetchElm(RetNo,'S5',148));
     Tv[15]:=Vl(FetchElm(RetNo,'S5',170));
     If Tv[15]>0 then
       Strings[16]:=FormatFloat('##0.0000',Tv[14]/Tv[15])
     else
       Strings[16]:='';

     Tv[17]:=2 * Vl(FetchElm(RetNo,'S5',7))+Vl(FetchElm(RetNo,'S5',150));
     Tv[18]:=Vl(FetchElm(RetNo,'S5',172));
     If Tv[18]>0 then
       Strings[19]:=FormatFloat('##0.0000',Tv[17]/Tv[18])
     else
       Strings[19]:='';

     Strings[20]:=FormatFloat('##0.0000',Vl(Strings[16])+Vl(Strings[19]));
     //20161112
     x:=1/3;
     if Vl(FetchElm(RetNo,'S5',270))=0 then x:=1/2;
     if Vl(FetchElm(RetNo,'S5',272))=0 then x:=1;
     Strings[21]:=FormatFloat('##0.0000',Vl(Strings[20]) * X);

     Tv[22]:=Tv[6];
     Strings[23]:=Strings[21];
     Tv[24]:=Tv[22] * Vl(Strings[23])/100;
     end
     Else
     begin
         For i:=14 to 24 do begin Tv[i]:=0;Strings[i]:='';end;
     end;

    Tv[27]:=MaxR(Tv[6],MaxR(Tv[12],Tv[24]));

    //20160710
    Tv[28]:=Tv[27];
    Strings[34]:=IntToStr(GetNumDays(RetNo,'01-04-2015','B'));
    Strings[35]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[29]:=Round(Tv[28]*(Vl(Strings[34])/Vl(Strings[35]))*4/100);

    Tv[38]:=Tv[27];
    Strings[36]:=IntToStr(GetNumDays(RetNo,'31-03-2015','A')-GetNumDays(RetNo,'31-12-2015','A')); //20161112
    Strings[37]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[39]:=Round(Tv[38]*(Vl(Strings[36])/Vl(Strings[37]))*5/100);

    Tv[41]:=Tv[27];
    Strings[42]:=IntToStr(GetNumDays(RetNo,'31-03-2015','A')); //20161112
    Strings[43]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[44]:=Round(Tv[41]*(Vl(Strings[42])/Vl(Strings[43]))*6/100);


    Tv[40]:= Tv[29]+Tv[39]+Tv[44];  ////20161112

    If IsShortYear(RetNo) then
    begin
     Tv[30]:=Tv[29];
     Strings[31]:=IntToStr(Ret[RetNo].DaysInYear);
     Tv[32]:=Tv[30]*Vl(Strings[31])/365;
     Tv[33]:=Tv[32];
    end
    Else
    Begin
      Tv[3]:=0;
      Strings[31]:='';
      Tv[32]:=0;
      Tv[33]:=Tv[40];  //20160710
    end;
  end; {End with}
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure S306(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[64]:=0;
   i:=6;
   Repeat
    Tv[64]:=Tv[64]+Tv[i];
    Inc(i,3);
   until i>63;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
//20260903 Alex >>>
procedure S307(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    Tv[4]:= GetTxblIncomeInProv(RetNo, 'NL');
    Tv[5]:= Ret[RetNo].Ln[400];
    Tv[6]:= Ret[RetNo].Ln[405];
    Tv[7]:= Ret[RetNo].Ln[428];
    Tv[8]:= MinR(Tv[7],MinR(Tv[5],Tv[6]));
    Tv[9]:= Tv[8];
    Tv[10]:= Tv[4];
    Tv[11]:= GetTxblIncomeInAllProv(RetNo);

    if Tv[11] > 0 then Tv[12]:= Tv[9] * Tv[10] / Tv[11] else Tv[12]:= 0;
    Tv[13]:= MaxR(0, Tv[4] - Tv[12]);

    //jz 20241119
    //Amount 1F (1)
    Tv[14]:= Tv[12];
    strings[16]:= inttostr(GetNumDays(RetNo, '01-01-2026', 'B')); //20260903 Alex
    strings[17]:= inttostr(Ret[RetNo].DaysInYear);
    Tv[26]:= Tv[14] * strtoint(strings[16]) / strtoint(strings[17]) * 0.025; //20260903 Alex

    //Amount 1F (2)
    Tv[28]:= Tv[12];
    strings[27]:= inttostr(GetNumDays(RetNo, '01-01-2027', 'B')); //20260903 Alex
    strings[30]:= inttostr(Ret[RetNo].DaysInYear);
    Tv[29]:= Tv[28] * strtoint(strings[27]) / strtoint(strings[30]) * 0.02; //20260903 Alex

    //Amount 1F (3)
    Tv[33]:= Tv[12]; //20260903 Alex
    strings[36]:= inttostr(GetNumDays(RetNo, '01-01-2028', 'B')); //20260903 Alex
    strings[37]:= inttostr(Ret[RetNo].DaysInYear); //20260903 Alex
    Tv[34]:= Tv[33] * strtoint(strings[36]) / strtoint(strings[37]) * 0.015; //20260903 Alex

    //Amount 1F (4)
    Tv[34]:= Tv[12]; //20260903 Alex
    strings[39]:= inttostr(GetNumDays(RetNo,'31-12-2027','A')); //20260903 Alex
    strings[40]:= inttostr(Ret[RetNo].DaysInYear); //20260903 Alex
    Tv[38]:= Tv[35] * strtoint(strings[39]) / strtoint(strings[40]) * 0.01; //20260903 Alex

    Tv[32]:= Tv[26] + Tv[29] + Tv[34] + Tv[38]; //20260903 Alex
    Tv[24]:= Tv[13];
    Tv[25]:= Round(Tv[24] * (15 / 100));
    //Tv[31]:= Tv[32] + Tv[25]; //Tv[29]+Tv[25]; //jz 20241119 //20260903 Alex
    Tv[18]:= Tv[32] + Tv[25]; //Tv[31]; //20260903 Alex

    //20260725
    Tv[19]:= Tv[18];
    Tv[22]:= Vl(FetchElm(RetNo, 'S5', 252));  //20260725 //offshore txbl
    Tv[23]:= Vl(FetchElm(RetNo, 'S5', 109)) + Tv[22];  //Tv[[22] is the offshore Vl(FetchElm(RetNo,'S5',252)); //20240706

    if Tv[23] > 0 then Tv[20]:= Tv[19] * Tv[22] / Tv[23] else Tv[20]:= 0;

    Tv[21]:= MaxR(0, Tv[19] - Tv[20]); //20260903 Alex
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260903 Alex <<<

//20171120
procedure S308(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    //20171124
    If (Ret[RetNo].Province = 'MJ')  or (Ret[RetNo].Province = 'NL') then
    Begin
     Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
     Tv[18]:=Tv[17];
     Tv[21]:=Tv[7]+Tv[18];
     if UpperCase(Strings[8])<>'Y' then Tv[22]:=Tv[21];
     Tv[33]:=Tv[28]+Tv[30]+Tv[32];
     Tv[23]:=Tv[33];
     Tv[24]:=Tv[22]+Tv[23];
     Tv[25]:=Tv[24];
     Tv[26]:=MaxR(0,Tv[21]-Tv[25]);
    End
    Else
    begin
     for i:=7 to 32 do begin Tv[i]:=0;end;
    end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



//20181027
procedure S403(RetNo: integer;FName: string;FNo: integer);
Var i,k:integer;x:real;Yend:String;
begin

  If Vl(GetPrvAlloc(RetNo,'SK')) = 0 then
  begin
   For i:=1 to 49 do begin StoreElm(RetNo,FNo,i,'');end;
   exit;
  end;
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);


  If GetTaxationYearEnd(RetNo) < '2017/04/01' then
  //If DateWithinTaxYear('2017/03/31',RetNo) then //before Apr 1, 2017
  Begin
   //????  missing calcscalcs
   //20161115
   Strings[29]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[31]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[33]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
   //20161115
   i:=62;
   k:=10;
   Yend:=GetTaxationYearEnd(RetNo);
   Repeat
    If Strings[i]='' then Strings[i]:=GetPrevYearEnd(YEnd,k);
    Inc(i,2);
    Dec(k,1);
   until i>82;
  End
  Else
  begin  //part 1, 2 and 3
   for i:=109 to 121 do begin Tv[i]:=0;end;
   for i:=109 to 127 do begin Tv[i]:=0;end;
   for i:=29 to 35 do begin Tv[i]:=0;Strings[i]:='';end;
   for i:=62 to 83 do begin Tv[i]:=0;Strings[i]:='';end;
  end;


  If GetTaxationYearEnd(RetNo) > '2017/03/31' then //after March 31, 2017
  begin
    //Part 6 first
    Strings[55]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
    Strings[47]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
    Strings[45]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
    Tv[43]:=Tv[51]+Tv[46]+Tv[44];
    //part 5
    Tv[53]:=Vl(FetchElm(RetNo,'S31',423));
    Tv[4]:=Round(Tv[53]*1/3);
    Tv[5]:=Tv[4];
    Tv[54]:=MinR(Tv[52],Tv[5]);
    Tv[10]:=Round(Tv[54] * 10/100);
    //part 5
    if Tv[10]>0 then Tv[11]:=MaxR(0,Tv[52]-Tv[54]);
    Tv[15]:=MaxR(0,Tv[12]-Tv[13]);
    Tv[14]:=Tv[15];
    Tv[9]:=Tv[11];
    Tv[49]:=Round(Tv[9]*10/100);
    Tv[20]:=Tv[17]+Tv[49]+Tv[18]+Tv[19];
    Tv[21]:=Tv[20];
    Tv[22]:=Tv[14]+Tv[21];

    //part 6 first
    Tv[6]:=MaxR(0,Tv[22]-Tv[23]);
    Tv[7]:=MaxR(0,1000000-Tv[10]);
    if UpperCase(Strings[50])<>'Y' then  //20190421
        Tv[24]:=MinR(Tv[6],Tv[7]);
    Tv[25]:=Tv[43];
    Tv[26]:=Tv[23]+Tv[24]+Tv[25];
    Tv[27]:=Tv[26];
    Tv[28]:=MaxR(0,Tv[22]-Tv[27]);

    //part 7
    i:=84;
    k:=10;
    Yend:=GetTaxationYearEnd(RetNo);
    Repeat
     If Strings[i]='' then Strings[i]:=GetPrevYearEnd(YEnd,k);
     Inc(i,2);
     Dec(k,1);
    until i>104;

    Tv[42]:=0;
    i:=85;
    Repeat
     Tv[42]:=Tv[42]+Tv[i];
     Inc(i,2);
    Until i>105;

    Tv[56]:=Tv[4]; //Vl(FetchElm(RetNo,'S31',423));
    Strings[57]:=IntToStr(GetNumDays(RetNo,'31-03-2017','A'));
    Strings[58]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[59]:=Round(Tv[56] * Vl(Strings[57])/Vl(Strings[58]));
   end
  Else
  begin
    for i:=52 to 54 do begin Tv[i]:=0;end;
    Tv[4]:=0;
    Tv[5]:=0;
    for i:=11 to 15 do begin Tv[i]:=0;end;
    for i:=17 to 28 do begin Tv[i]:=0;end;
    Tv[9]:=0;
    Tv[49]:=0;
    for i:=43 to 45 do begin Tv[i]:=0;end;
    Tv[51]:=0;
    i:=85;;
    repeat
     Tv[i]:=0;
     Inc(i,2);
    until i>105;
    Tv[42]:=0;
  end;

  Tv[128]:=Tv[123];
  Tv[129]:=Tv[24];
  Tv[130]:=Tv[128]+Tv[129];
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

//20191012
procedure S404(RetNo: integer;FName: string;FNo: integer);

Var  i:integer; profits:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //pg 1
   FillHeader(RetNo,FNo,1,2,3);

   If (Ret[RetNo].Province= 'SK')
   or (GetTxblIncomeInProv(RetNo,'SK') >0)
   then
     //ok
   else
   begin
        For i:=4 to 88 do begin Strings[i]:='';Tv[i]:=0;end;
        SaveTv(RetNo,FName,FNo);
        Exit;
   end;

   //part 1

   profits := Vl(FetchElm(RetNo,'S27',213));
   if UpperCase(FetchElm(RetNo,'S27',314)) = 'Y' then
     profits := Vl(FetchElm(RetNo,'S27',401));

   For i:=4 to 88 do begin Strings[i]:='';Tv[i]:=0;end;

   if GetNumDays(RetNo,'01-01-2018','B') > 0 then //before January 1, 2018
   begin
        Tv[4]  := profits;
        Tv[5]  := Vl(FetchElm(RetNo,'S411',28));   //20111117
        If Ret[RetNo].CorpType <> CCPC then Tv[5]:=0;
        Tv[6]  := MaxR(0,Tv[4]-Tv[5]);
        Tv[7]  := Ret[RetNo].Ln[360]; //Vl(FetchElm(RetNo,'T2',232));  //20191019
        Tv[8]  := Tv[5]; //Vl(FetchElm(RetNo,'S411_1',8));
        If Ret[RetNo].CorpType <> CCPC then Tv[8]:=0;
        Tv[9]  := Vl(FetchElm(RetNo,'T2',440));  //504)); //20191019
        If Ret[RetNo].CorpType <> CCPC then Tv[9]:=0;
      //  Tv[101]:=Vl(FetchElm(RetNo,'S27',229));   ???
        Tv[10] := Vl(FetchElm(RetNo,'T2',636));
        Tv[11] := Tv[10] * 4;  //20191019
        Tv[12] := Tv[8]+Tv[9]+Tv[11];
        Tv[13] := Tv[12];
        Tv[14] := MaxR(0,Tv[7]-Tv[13]);
        Tv[15] := MinR(Tv[6],Tv[14]);
   end
   Else
   Begin
    for i:=4 to 15 do begin Tv[i]:=0;end;
   End;

   If GetNumDays(RetNo,'31-12-2017','A') > 0 then //after December 31, 2017
   begin
        Tv[16]  := profits;
        Tv[17]  := Vl(FetchElm(RetNo,'S411',69)); //jz 2019
        If GetNumDays(RetNo,'31-12-2018','A')>0 then Tv[17]  := Vl(FetchElm(RetNo,'S411',28)); //jz 2019
        If Ret[RetNo].CorpType <> CCPC then Tv[17]:=0;
        Tv[18]  := MaxR(0,Tv[16]-Tv[17]);
        Tv[19]  := Ret[RetNo].Ln[360];
        Tv[20]  := Tv[17]; //Vl(FetchElm(RetNo,'S411_1',8));
        Tv[21]  := Ret[RetNo].Ln[440];
        If Ret[RetNo].CorpType <> CCPC then Begin Tv[20]:=0;Tv[21]:=0;end;
        //Tv[101]:=Vl(FetchElm(RetNo,'S27',229));  //jz 2019 ???
        Tv[22] := Ret[RetNo].Ln[636]; //Vl(FetchElm(RetNo,'T2',636));//Vl(FetchElm(RetNo,'T2',631));  //20191023
        Tv[23] := Tv[22] * 4; // * Tv[101]; //jz 2019 ???
        Tv[24] := Tv[20]+Tv[21]+Tv[23];
        Tv[25] := Tv[24];
        Tv[26] := MaxR(0,Tv[19]-Tv[25]);
        Tv[27] := MinR(Tv[18],Tv[26]);
    end
    Else
    Begin
     for i:=16 to 27 do begin Tv[i]:=0;end;
    End;

   //pg 2
   //part 1 continued ----------------------------------------------------------
   Tv[28] := Tv[15];
   strings[29] := IntToStr(GetNumDays(RetNo,'01-01-2018','B')); //Tv[29] := IntToStr(GetNumDays(RetNo,'01-01-2018','B'));
   strings[30] := IntToStr(Ret[RetNo].DaysInYear); //Tv[30] := IntToStr(Ret[RetNo].DaysInYear);
   if Tv[30]>0 then Tv[31] := Tv[28] * (Tv[29] / Tv[30]) Else Tv[31]:=0;

   Tv[32] := Tv[27];
   strings[33] := IntToStr(GetNumDays(RetNo,'31-12-2018','A')); //Tv[33] := IntToStr(GetNumDays(RetNo,'31-12-2018','A'));
   strings[34] := IntToStr(Ret[RetNo].DaysInYear); //Tv[34] := IntToStr(Ret[RetNo].DaysInYear);
   if Tv[34]>0 then Tv[35] := Tv[32] * (Tv[33] / Tv[34]) else Tv[35]:=0;

   Tv[36] := Tv[31] + Tv[35];

   //part 2 --------------------------------------------------------------------
   Tv[52] := Tv[36]; //Tv[15];
   Tv[53] := GetTxblIncomeInProv(RetNo,'SK');
   Tv[89] := GetTxblIncome(RetNo);
   If Tv[89]>0 then Tv[54] := Tv[52] * Tv[53]/Tv[89] else Tv[54]:=0;
  // Tv[55] := 2; //7;   //20111117
   Tv[56]:= GetTxblIncomeInProv(RetNo,'SK');
   Tv[90]:=GetTxblIncome(RetNo);
   If Tv[90]>0 then
     Strings[57] := FormatFloat('###.####',(Tv[56]/Tv[90]) * 2/100) else Strings[57]:='';;
   Tv[88]:=Round(Tv[54] * Vl(Strings[57]));  //20111117
  end;
  SaveTv(RetNo,FName,FNo);
end;




(*  //20191012
procedure S404(RetNo: integer;FName: string;FNo: integer);
Var  i:integer; profits:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);

   If (Ret[RetNo].Province= 'SK')
   or (GetTxblIncomeInProv(RetNo,'SK') >0)
   then
     //ok
   else
   begin
        For i:=4 to 88 do begin Strings[i]:='';Tv[i]:=0;end;
        SaveTv(RetNo,FName,FNo);
        Exit;
   end;

   profits := Vl(FetchElm(RetNo,'S27',213));
   if UpperCase(FetchElm(RetNo,'S27',314)) = 'Y' then
     profits := Vl(FetchElm(RetNo,'S27',401));

   For i:=4 to 88 do begin Strings[i]:='';Tv[i]:=0;end;

        Tv[4]  := profits;
        Tv[5]  := Vl(FetchElm(RetNo,'S411',37));   //20111117
        If Ret[RetNo].CorpType <> CCPC then Tv[5]:=0;
        Tv[6]  := MaxR(0,Tv[4]-Tv[5]);
        Tv[7]  := Vl(FetchElm(RetNo,'T2',232));
        Tv[8]  := Tv[5]; //Vl(FetchElm(RetNo,'S411_1',8));
        Tv[9]  := Vl(FetchElm(RetNo,'T2',504));
        If Ret[RetNo].CorpType <> CCPC then Tv[9]:=0;
        Tv[101]:=Vl(FetchElm(RetNo,'S27',229));
        Tv[10] := Vl(FetchElm(RetNo,'T2',631));
        Tv[11] := Tv[10] * Tv[101];  //20111117
        Tv[12] := Tv[8]+Tv[9]+Tv[11];
        Tv[13] := Tv[12];
        Tv[14] := MaxR(0,Tv[7]-Tv[13]);
        Tv[15] := MinR(Tv[6],Tv[14]);


   Tv[52] := Tv[15];
   Tv[53] := GetTxblIncomeInProv(RetNo,'SK');
   Tv[89]:=GetTxblIncome(RetNo);
   If Tv[89]>0 then Tv[54] := Tv[52] * Tv[53]/Tv[89] else Tv[54]:=0;
  // Tv[55] := 2; //7;   //20111117
   Tv[56]:= GetTxblIncomeInProv(RetNo,'SK');
   Tv[90]:=GetTxblIncome(RetNo);
   If Tv[90]>0 then
     Strings[57] := FormatFloat('###.####',(Tv[56]/Tv[90]) * 2/100) else Strings[57]:='';;
   Tv[88]:=Round(Tv[54] * Vl(Strings[57]));  //20111117
  end;
  SaveTv(RetNo,FName,FNo);
end;
*)


procedure S321(RetNo: integer;FName: string;FNo: integer);
{PE itc}
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);

   Tv[45]:= Tv[40]+Tv[42]+Tv[44];

   Tv[20]:=Tv[7]+Tv[11]+Tv[15]+Tv[19];
   Tv[23] := MaxR(0,Tv[21]-Tv[22]);
   Tv[24] := Tv[23];
   Tv[26]:=Tv[20];
   Tv[27]:=Tv[26] * 10/100;
   Tv[30]:=Tv[25]+Tv[27]+Tv[28]+Tv[29];
   Tv[31]:=Tv[30];
   Tv[32] := Tv[24]+Tv[31];
   Tv[35]:= Tv[45];
   Tv[36]:=Tv[33]+Tv[34]+Tv[35];
   Tv[37]:=Tv[36];
   Tv[38]:= MaxR(0,Tv[32]-Tv[37]);


  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S340(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  If Vl(GetPrvAlloc(RetNo,'NS')) = 0 then
  begin
   For i:=1 to 13 do begin StoreElm(RetNo,FNo,i,'');end;
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);

   Tv[6] := Tv[5] * 0.15;
   Tv[9] := Tv[7]+Tv[8];
   Tv[10]:=Tv[9];
   Tv[11]:=Tv[6]+Tv[10];
   Tv[13] := MaxR(0,Tv[11]-Tv[12]);
  end; {End with}
  //S340 pg2 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin

   i:=101;Tv[116]:=0;
   Repeat
    If Tv[i+16]>100 then Tv[i+16]:=100;
    Tv[i+2]:=MinR(Tv[i],Tv[i+1]);
    Tv[116]:=Tv[116]+Tv[i+2];
    Inc(i,3);
   until i>113;  //because it starts from 0

  end; {End with}
  //S340 pg3 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin

   i:=201;j:=117;Tv[216]:=0;
   Repeat
    Tv[i]:=MaxR(0,Vl(FetchElm(RetNo,'S340',j))
           * Vl(FetchElm(RetNo,'S340',j+1))-Vl(FetchElm(RetNo,'S340',j+2)));
    Tv[i+2]:=MinR(Tv[i],Tv[i+1]);
    Tv[216]:=Tv[216]+Tv[i+2];
    Inc(i,3);
    Inc(j,3);
   until i>213;

   Tv[218]:=Vl(FetchElm(RetNo,'S340',116));
   Tv[219]:=Tv[216];
   Tv[220]:=Tv[217];
   Tv[221]:=Tv[218]+Tv[219]+Tv[220];

  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

//20251001
procedure S341(RetNo: integer;FName: string;FNo: integer);
Var i,S7FNo, F1Ndx, K1Ndx:integer;
begin
  S7FNo:=GetFormNo('S7');
  LoadTv(RetNo,FName,FNo);
  //revised 20250918
  with Ret[RetNo].Frm[Fno] do
  begin
    if UpperCase(Strings[10])<>'Y' then
    Begin
     for i:=1 to 33 do begin TV[i]:=0;end;
     SaveTv(RetNo,FName,FNo);
     Exit;
    End;

    FillHeader(RetNo,FNo,1,2,3);
   // Tv[4]:=GetTxblIncomeInProv(RetNo,'NS');
    Tv[5]:=Ret[RetNo].Ln[400];
    Tv[6]:=Ret[RetNo].Ln[405];
  //  Tv[19]:=Ret[RetNo].Ln[428];
    Tv[7]:= Ret[RetNo].Ln[428]; //Round(Tv[19] * 700000/500000); //20250921
    Tv[8]:=MinR(Tv[5],MinR(Tv[6],Tv[7]));
    Tv[9]:=Tv[8]; //Tv[23];   //20190421
    Tv[11]:= GetTxblIncomeInProv(RetNo,'NS');
    Tv[12]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[12]>0 then
     Tv[13]:=Round(Tv[9]*Tv[11]/Tv[12])
    else
     Tv[13]:=0;

   // Tv[14]:=MaxR(0,Tv[4]-Tv[13]);

    //20210518
    Tv[16]:=Tv[13];
    Strings[15]:=IntToStr(GetNumDays(RetNo,'01-04-2025','B'));
    Strings[20]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[17]:=Round(Tv[16]* (Vl(Strings[15])/Vl(Strings[20]))*2.5/100);

    Tv[32]:=Tv[13];
    Strings[21]:=IntToStr(GetNumDays(RetNo,'31-03-2025','A'));
    Strings[22]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[30]:=Round(Tv[32]* (Vl(Strings[21])/Vl(Strings[22]))*1.5/100);

    Tv[33]:=Tv[17]+Tv[30];
    Tv[18]:=Tv[33];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S346(RetNo: integer;FName: string;FNo: integer);
//20140413
Var i,j,s7FNo,F1Ndx,K1Ndx:Integer;   //index to F1, K1 column of S7
begin
 S7FNo:=GetFormNo('S7');
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   If (Ret[RetNo].Province = 'NS')
   or (Ret[RetNo].Province = 'NO')
   or (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=1 to 113 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   FillHeader(RetNo,FNo,100,101,102);

   Tv[109]:=GetTxblIncomeInProv(RetNo,'NS');
   Tv[22]:=Ret[RetNo].Ln[400];
   Tv[103] :=Ret[RetNo].Ln[405];
   Tv[21]  :=Ret[RetNo].Ln[428]; //20250918  //GetReducedBusinessLimit(RetNo); //resolves 427 vs 428
   Tv[4]:=MinR(Tv[22],(MinR(Tv[103],Tv[21]))); //jz//2025/09/22 - replaced editbox 56 with 22

   Tv[108]:= Tv[4]; //jz 2019 Tv[107];
   Tv[110]:=Tv[109];
   Tv[111]:=GetTxblIncomeInAllProv(RetNo);
   If Tv[111]>0 then Tv[112]:=RoundCorrect(Tv[108]*Tv[110]/Tv[111])
   else
    Tv[112]:=0;

   If Tv[112]>Tv[109] then Tv[112]:=Tv[109];
   Tv[113]:=MaxR(0,Tv[109]-Tv[112]);

   //20251004
   Tv[8]:=GetTxblIncomeInProv(RetNo,'NS');  //20251016
   If (Ret[RetNo].Province = 'MJ')  then    //20260628
   begin
    Tv[8]:= Vl(FetchElm(RetNo,'S5',131))+Vl(FetchElm(RetNo,'S5',241)); //both txbl invome
   end;

   Tv[23]:=Ret[RetNo].Ln[400];
   Tv[3]:=Ret[RetNo].Ln[405];
   Tv[13]:=Ret[RetNo].Ln[428];
   Tv[31]:=RoundCorrect(Tv[13]*700000/500000);
   Tv[30]:=MinR(Tv[23],(MinR(Tv[3],Tv[31])));

   Tv[7]:=Tv[30];
   Tv[90]:=Tv[110];
   Tv[91]:=Tv[111];
   if Tv[91]>0 then
    Tv[11]:=RoundCorrect(Tv[7] * Tv[90]/Tv[91])
   else
    Tv[11]:=0;
   Tv[12]:=MaxR(0,Tv[8]-Tv[11]);

   //PART 2 //after March 31, 2925
  if UpperCase(Strings[87])='Y'  then
  Begin
   TV[35]:= Vl(FetchElmFNo(RetNo,S7FNo,159)); //amount Y S7 part 6
   TV[36]:= Vl(FetchElmFNo(RetNo,S7FNo,26)); //amount 530  part 6 of s7
   TV[37]:= Vl(FetchElmFNo(RetNo,S7FNo,99)); //amount 540 of S7
   TV[38]:= Vl(FetchElmFNo(RetNo,S7FNo,100)); //amount AA of S7
   TV[39]:= Vl(FetchElmFNo(RetNo,S7FNo,165)); //amount CC of S7
   Tv[40]:=Tv[35]+Tv[36]+Tv[37]+Tv[38]+Tv[39];
   Tv[41]:=Tv[40];
   TV[42]:= Vl(FetchElmFNo(RetNo,S7FNo,150)); //amount Q of S7
  end
  Else
  begin
   For i:=35 to 42 do begin Tv[i]:=0;end;
  end;

  //Part 2 Continued
    F1Ndx:=105;   //index to F1 column of S7
    K1Ndx:=64;   //index to K1 column of S7
    I:=43;    //index on this schedule of first column
    Tv[75]:=0;
    Tv[76]:=0;
    Tv[i+3];
    Repeat
     Tv[i]:=Vl(FetchElmFNo(RetNo,S7FNo,F1Ndx));
     Tv[I+1]:=Round(Vl(FetchElmFNo(RetNo,S7FNo,K1Ndx)) *700000/500000);
     Tv[i+2]:=Tv[i]-Tv[i+1];
     Tv[I+3]:=MinR(Tv[i+1],Tv[I+2]);
     if Tv[i]<0 then Tv[i+3]:=0;
     Tv[75]:=Tv[75]+Tv[i+2];
     Tv[76]:=Tv[76]+Tv[i+3];
     Inc(F1Ndx,8);
     Inc(K1Ndx,1);
     Inc(i,4);
    Until F1Ndx>133;

     //20250822
    Tv[77]:=Vl(FetchElmFNo(RetNo, S7FNo,143));  //ln 370 of S7
    Tv[78]:=Vl(FetchElmFNo(RetNo, S7FNo,144));  //ln 380 of S7
    Tv[79]:=Tv[77]+Tv[78];
    Tv[80]:=MinR(Tv[75],Tv[79]);
    Tv[81]:=Tv[76]+Tv[80];
    Tv[82]:=Tv[81];
    Tv[83]:=MaxR(0,Tv[42]-Tv[82]); //maxr(0?
    Tv[84]:=Tv[83];
    Tv[85]:=MaxR(0,Tv[42]-Tv[84]);  //maxr(0?

    if UpperCase(Strings[87])<>'Y' then
    Begin
      for i:=35 to 42 do Tv[i]:=0;
      Tv[84]:=0;Tv[85]:=0;
    End;

  //PART 3
   Tv[1]:=Tv[112];
   Strings[27]:=IntToStr(GetNumDays(RetNo,'01-04-2025','B'));
   Strings[28]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[2]:=RoundCorrect(Tv[1] * Vl(Strings[27])/Vl(Strings[28])*2.5/100);

   Tv[5]:= Tv[11];   //20251016
  // xx:=Tv[5];
   Strings[6]:=IntToStr(GetNumDays(RetNo,'31-03-2025','A'));
   Strings[14]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[15]:=RoundCorrect(Tv[5] * Vl(Strings[6])/Vl(Strings[14])*1.5/100);

   Tv[16]:=Tv[2]+Tv[15];
   TV[17]:=Tv[16];

   Tv[18]:=Tv[113];
   Strings[9]:=IntToStr(GetNumDays(RetNo,'01-04-2025','B'));
   Strings[10]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[19]:=RoundCorrect(Tv[18] * Vl(Strings[9])/Vl(Strings[10])*14/100);

   Tv[34]:= Tv[12];
   Strings[32]:=IntToStr(GetNumDays(RetNo,'31-03-2025','A'));
   Strings[33]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[88]:=RoundCorrect(Tv[34] * Vl(Strings[32])/Vl(Strings[33])*14/100);

   Tv[86]:=Tv[19]+Tv[88];
   Tv[89]:=Tv[86];

   Tv[20]:=Tv[17]+Tv[89];

  {//20260725
  If (Vl(FetchElm(RetNo,'S5',241))>0)
  and (Vl(FetchElm(RetNo,'S5',241))>0)
  then //oFFsHORE TXBL //offshoretxblINC GetTxblIncomeInProv(RetNo,'NO'>0   //txbl in POffshore
  begin
   Tv[24]:=Tv[20];
   Tv[25]:=Vl(FetchElm(RetNo,'S5',241)); // GetTxblIncomeInProv(RetNo,'NO');
  }
  Tv[24]:=Tv[20];
  Tv[25]:=Vl(FetchElm(RetNo,'S5',241));  // GetTxblIncomeInProv(RetNo,'NO');
  Tv[26]:=Vl(FetchElm(RetNo,'S5',131))+Tv[25]; //NS plus ns offshore  //20260725
  If Tv[26]>0 then //denominator
     Tv[28]:=RoundCorrect(Tv[24] * Tv[25]/Tv[26])
  Else
     Tv[28]:=0;

  Tv[29]:=MaxR(0,Tv[20]-Tv[28]);
  end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


Procedure S347(RetNo: integer; FName: String;FNo: integer);
Var i,k:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  with Ret[RetNo].Frm[FNo] do
  begin
   Tv[42]:=0;
   i:=5;
   Repeat
    Tv[42]:=Tv[42]+Tv[i];
    Inc(i,2);
   until i>41;
  end;
  SaveTv(RetNo,FName,FNo);
end;

procedure S360(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If (Ret[RetNo].Province = 'NB')
   or (GetTxblIncomeInProv(RetNo,'NB')>0) then
   //ok
   else
   begin
   // For i:=4 to 30 do begin Strings[i]:='';Tv[i]:=0;end;
    For i:=101 to 145 do begin Strings[i]:='';Tv[i]:=0;end; //moved from page 2 below
    For i:=201 to 236 do begin Strings[i]:='';Tv[i]:=0;end; //moved from page 3 below
    SaveTv(RetNo,FName,FNo);
    Exit;
   end;

   FillHeader(RetNo,FNo,1,2,3);
  (*
   Tv[7]  := MaxR(0,Tv[5]-Tv[6]);
   Tv[8] := Tv[7];
   Tv[10] := Tv[4];
   Tv[11] := Tv[10] * 0.10;
   Tv[14] := Tv[9]+Tv[11]+Tv[12]+Tv[13];
   Tv[15] := Tv[14];
   Tv[16] := Tv[8]+Tv[15];

   If UpperCase(Strings[29]) <> 'Y' then Tv[18]:=MinR(Tv[16],GetMaxNonRefNbRdCredit(RetNo));
   Tv[20]:=Tv[17]+Tv[18];
   Tv[19]:=Tv[28];
   Tv[20]:=Tv[17]+Tv[18]+Tv[19];
   Tv[30]:=Tv[20];
   Tv[21]:=MaxR(0,Tv[16]-Tv[30]);

   Strings[22]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[24]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[26]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);

   Tv[28] := Tv[23]+Tv[25]+Tv[27];
  *)

 //S360 pg2 -------------------------------------------------------------------

  Tv[145]:= AddColumns(130,144,2);
  Tv[102]:=Tv[101] * 0.15;
  Tv[105]:=Tv[103]+Tv[104];
  Tv[106]:=Tv[105];
 // Tv[107]:=Tv[102]+Tv[106];
  Tv[109]:=Tv[102]+Tv[106];     //MaxR(0,Tv[107]-Tv[108]);

  i:=110;
  Tv[125]:=0;
  Repeat
   Tv[i+2]:=MinR(Tv[i],Tv[i+1]);
   Tv[125]:=Tv[125]+Tv[i+2];
   Inc(i,3);
  until i>122;

  //S360 pg3 -------------------------------------------------------------------
  i:=216;
  Repeat
   Tv[i]:=MaxR(0,(Vl(Strings[i-15]) * Tv[i-14]) - Tv[i-13]);
   Tv[i+2]:=MinR(Tv[i],Tv[i+1]);
   Tv[231]:=Tv[231]+Tv[i+2];
   Inc(i,3);
  until i>228;

  Tv[233]:=TV[125];
  Tv[234]:=Tv[231];
  Tv[235]:=Tv[232];
  Tv[236]:=Tv[233]+Tv[234]+Tv[235];
 end; //with
 SaveTv(RetNo,FName,FNo);
end;

(* //20220509
procedure S365(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   Tv[30] := AddColumns(5,29,2);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)

//20210516
procedure S366(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;//BizLimit:Real; //20191006
begin
 //20191006
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   If (Ret[RetNo].Province = 'NB') or
    (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 217 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   FillHeader(RetNo,FNo,1,2,3);
   //20210516
   Tv[14]:=GetTxblIncomeInProv(RetNo,'NB');
   Tv[15]:=Ret[RetNo].Ln[400];
   Tv[16]:=Ret[RetNo].Ln[405];
   Tv[18]:=Ret[RetNo].Ln[410];
   Tv[9] :=Ret[RetNo].Ln[415];
   Tv[11]:=Tv[18];
   Tv[12]:=Vl(FetchElm(RetNo,'T2',122)); //Tv[9]; //20240706
   Tv[17]:=Round(Tv[11]*Tv[12]/90000); //20240705 //Round(Tv[11]*Tv[12]/11250);

   Tv[24]:=Ret[RetNo].Ln[515];
   Tv[25]:=MaxR(0,Tv[18]-Tv[17]-Tv[24]);
   Tv[26]:=Tv[25];
   Tv[19]:=MinR(Tv[15],MinR(Tv[16],Tv[26]));
   Tv[7]:=Tv[19];
   Tv[20]:=Tv[14];
   Tv[21]:=GetTxblIncomeInAllProv(RetNo);
   If Tv[21]>0 then
    Tv[22]:=RoundCorrect(Tv[7]*Tv[20]/Tv[21])
   else
    Tv[22]:=0;
   If Tv[22]>Tv[14] then Tv[22]:=Tv[14];

   Tv[23]:=MaxR(0,Tv[14]-Tv[22]);


   Tv[191]:= Tv[22];
   Tv[194]:=RoundCorrect(Tv[191]* 2.5/100);

   Tv[4]:= Tv[23];
   Tv[8]:=RoundCorrect(Tv[4]* 14/100);
   Tv[217]:=Tv[194]+Tv[8];
 end;
 SaveTv(RetNo,FName,FNo);
end;

//20160508  John's
procedure S380(RetNo: integer;FName: string;FNo: integer);
Var i,k:integer;Yend:String;
begin
  //290171103
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,37,38,39);
   Strings[40]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[41]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[42]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);

   //part 4
   i:=47;
   k:=10;
   Yend:=GetTaxationYearEnd(RetNo);
   Repeat
    If Strings[i]='' then Strings[i]:=GetPrevYearEnd(YEnd,k);
    Inc(i,2);
    Dec(k,1);
   until i>67;

   //significant changes 20150531
 //  Tv[1]:=Tv[25]+Tv[28];
   //Tv[13]:=Tv[17]+Tv[18];
   //part 1
   Tv[29]:=Tv[17]+Tv[18];  //20201111
   Tv[30]:=Tv[29];
   if Tv[30]>Tv[13] then Tv[30]:=Tv[13]; //20201111

   //part 2
   Tv[6] := maxR(0,Tv[4]-Tv[5]);
   Tv[7] := Tv[6];

   Tv[3]:=20;
   Tv[32]:=RoundCorrect(Tv[31]*Tv[3]/100);

   Tv[27]:=15;
   Tv[72]:= RoundCorrect(Tv[26] * Tv[27]/100);

//   Tv[2]:=Tv[1];
//   Tv[46]:=RoundCorrect(Tv[2] * 20/100);
   Tv[73]:=Tv[13];
   Tv[79]:=RoundCorrect(Tv[73]*15/100);
   {
   If Tv[3]=0 then Tv[3]:=20;
   Tv[46]:=Tv[2] * Tv[3]/100;
   }

   Tv[15]:=Tv[79]+Tv[11]+Tv[14];
   Tv[16]:=MaxR(0,Tv[15]-Tv[43]);
   Tv[85]:=Tv[16];

   Tv[33]:=Tv[6]+Tv[9]+Tv[32]+Tv[72]+Tv[85];//Tv[7]+Tv[9]+Tv[32]+Tv[72]+Tv[85];


   Tv[34]:=Tv[84];
   Tv[45]:=Tv[44]+Tv[34]+Tv[35];
   Tv[69]:=Tv[45];
   Tv[19]:=MaxR(0,Tv[33]-Tv[69]);


   //now do part 5 first
   Tv[70]:=Tv[25];
   Tv[71]:=RoundCorrect(Tv[70]*20/100);
   Tv[74]:=Tv[28];
   Tv[75]:=RoundCorrect(Tv[74]*10/100);
   Tv[83]:=Tv[17];
   Tv[86]:=RoundCorrect(Tv[83]*15/100);
   Tv[87]:=Tv[18];
   Tv[88]:=RoundCorrect(Tv[87]*7.5/100);

   Tv[76]:=Tv[71]+Tv[75]+Tv[86]+Tv[88]+Tv[8]+Tv[10];
   Tv[77]:=Tv[76];
   Tv[78]:=Tv[33];
   Tv[80]:=MaxR(0, Vl(FetchElm(RetNo,'S5',720))+Vl(FetchElm(RetNo,'S5',717)));
   //MaxR(0, Vl(FetchElm(RetNo,'S5',720))-Vl(FetchElm(RetNo,'S5',713)));
   Tv[81]:=MaxR(0,Tv[78]-Tv[80]);
   Tv[82]:=Tv[81];
   Tv[12]:=Tv[85];
   Tv[84]:=MinR(Tv[77],MinR(Tv[82],Tv[12]));
   //back to part 3
   If UpperCase(Strings[24]) <> 'Y' then
     Tv[44] := MaxR(0,MinR(GetMaxMbRDcredit(RetNo),Tv[33]));
   Tv[34]:=Tv[84];
  //------------------part 3/4
   Tv[23]:=Tv[20]+Tv[21]+Tv[22];
   //part 4
   i:=48;
   Tv[36]:=0;
   Repeat
    Tv[36]:=Tv[36]+Tv[i];
    Inc(i,2);
   until i>68;
   //-------------------------------

   Tv[35]:=Tv[23];
   Tv[45]:=Tv[44]+Tv[34]+Tv[35];
   Tv[69]:=Tv[45];
   Tv[19]:=MaxR(0,Tv[33]-Tv[69]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20260903 Alex >>>
procedure S381(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  AfterDec3107, BfrJan0108: Real;
  YEnd: string;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    //Page 1 -------------------------------------------------------------------
    Tv[18]:= 0;
    Tv[10]:= 0;
    i:= 71;
    k:= 46; //20260903 Alex
    repeat
      Tv[18]:= Tv[18] + Tv[k]; //20260903 Alex
      if (Strings[i] >= GetTaxationYearStart(RetNo)) and (Strings[i] <= GetTaxationYearEnd(RetNo)) then Tv[10]:= Tv[10] + Tv[i + 1]; //20260903 Alex
      //if Strings[i]<'2019/07/01' then Tv[18]:=Tv[18]+Tv[i+1] else Tv[10]:=Tv[10]+Tv[i+1];//jz 2019 ???
      Inc(i, 4);
      Inc(k, 1); //20260903 Alex
    until i > 103;
    //Tv[20]:=AddColumns(72,104,4);

    //Page 2 -------------------------------------------------------------------
    Tv[23]:= MaxR(0, Tv[21] - Tv[22]);
    Tv[24]:= Tv[23];

    //Tv[26]:=Tv[20]; //jz 2019 removed
    //Tv[27]:=RoundCorrect(Tv[26] * 10/100);

    Tv[16]:= Tv[18];
    Tv[17]:= RoundCorrect(Tv[16] * 0.01); //20260903 Alex
    Tv[12]:= Tv[10];
    Tv[13]:= RoundCorrect(Tv[12] * 0.08); //20260903 Alex
    Tv[30]:= Tv[17] + Tv[13] + Tv[28] + Tv[14] + Tv[29] + Tv[15]; //20260903 Alex
    //Tv[30]:= Tv[17] + Tv[13] + Tv[28] + Tv[29]; //jz 2019 removed Tv[27]+ added Tv[13]+
    Tv[5]:= MaxR(0, Tv[30] - Tv[4]);
    Tv[6]:= Tv[5];
    Tv[32]:= Tv[24] + Tv[25] + Tv[6];

    if (UpperCase(Strings[39]) <> 'Y') then Tv[34]:= Tv[32];

    Tv[7]:= Tv[32];
    if Tv[8] > 0 then Tv[11]:= MaxR(0, Tv[7] - Tv[8]);

    //Tv[19]:= Tv[30];
    //Tv[31]:= RoundCorrect(Tv[19] * 8/9);
    Tv[33]:= Tv[30]; //jz 2019 added
    Tv[40]:= RoundCorrect(Tv[33] * 7/8);
    Tv[9]:= Tv[33] - Tv[4]; //Tv[31] + Tv[40]; //20260903 Alex
    Tv[68]:= MinR(Tv[40], MinR(Tv[11], Tv[9])); //20260903 Alex
    Tv[35]:= Tv[145];
    Tv[36]:= Tv[34] + Tv[68] + Tv[35];
    Tv[37]:= Tv[36];
    Tv[38]:= MaxR(0, Tv[32] - Tv[37]);

    //Page 3 -------------------------------------------------------------------
    Strings[139]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo), 1);
    Strings[141]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo), 2);
    Strings[143]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo), 3);
    Tv[145]:= Tv[140] + Tv[142] + Tv[144];

    i:=105;
    k:=10;
    Yend:= GetTaxationYearEnd(RetNo);
    repeat
      if Strings[i] = '' then Strings[i]:= GetPrevYearEnd(YEnd, k);

      Inc(i, 1);
      Dec(k, 1);
    until i > 115;

    Tv[127]:= AddColumns(116, 126, 1);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260903 Alex <<<

procedure S383(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
 //20210922
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   If (Ret[RetNo].Province = 'MB') or (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 46 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   FillHeader(RetNo,FNo,1,2,3);
   Tv[38]:=GetTxblIncomeInProv(RetNo,'MB');  //20190930 //relocated from below
   Tv[39]:=Ret[RetNo].Ln[400];
   Tv[40]:=Ret[RetNo].Ln[405];
   Tv[42]:=Ret[RetNo].Ln[428];

   Tv[43]:=MinR(Tv[39],MinR(Tv[40],Tv[42]));

   Tv[10]:= Tv[43];
   Tv[44]:=Tv[38];
   Tv[4]:=GetTxblIncomeInAllProv(RetNo);
   If Tv[4]>0 then
    Tv[45]:=RoundCorrect(Tv[10]*Tv[44]/Tv[4])
   else
    Tv[45]:=0;
   Tv[46]:=MaxR(0,Tv[38]-Tv[45]);

   //Part 2
   Tv[5]:=Tv[46];
   Tv[36]:=Round(Tv[5]*0.12);
   Tv[37]:=Vl(FetchElm(RetNo,'S17',148));
   Tv[6]:=MaxR(0,Tv[36]-Tv[37]);
 end;
 SaveTv(RetNo,FName,FNo);
end;


  (*
   If GetNumDays(RetNo,'01-01-2019','B')> 0 then    //20190422
   Begin
    //20170627
  //  Tv[38]:=GetTxblIncomeInProv(RetNo,'MB');
    Tv[39]:=Ret[RetNo].Ln[400]; If Tv[178]>0 then Tv[39]:=Tv[178]; //MaxR(Vl(FetchElm(RetNo,'T2',335)),Tv[178]); //20170602
    Tv[40]:=Ret[RetNo].Ln[405]; //  Vl(FetchElm(RetNo,'T2',336));
    Tv[41]:=Ret[RetNo].Ln[428];//Ret[RetNo].Ln[427];  //20190930 //GetReducedBusinessLimit(RetNo); //20190626 Ret[RetNo].Ln[427]; //20170620 Vl(FetchElm(RetNo,'T2',342));
    Tv[42]:=RoundCorrect(Tv[41]*450000/500000);   //20160620
    //Tv[42]:=RoundCorrect(Tv[41]*425000/500000);   //20160620
    Tv[43]:=MinR(Tv[39],MinR(Tv[40],Tv[42]));

    {<--- //jz 2019 REMOVED
    If IsCreditUnion(RetNo) then
     Tv[5]:=Vl(FetchElm(RetNo,'S17',61)) //20181108 //Vl(FetchElm(RetNo,'S17',63))
    else
     Tv[5]:=0;
    Tv[6]:=Tv[43];
    Tv[7]:=MaxR(0,Tv[5]-Tv[6]);
    Tv[8]:=Tv[7];
    Tv[9]:=Tv[43]+Tv[8];
    -->}

    Tv[13]:= Tv[43]; //jz 2019

    Tv[10]:= Tv[13]; //jz 2019 //Tv[9];
    Tv[44]:=Tv[38];
    Tv[206]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[206]>0 then
     Tv[45]:=RoundCorrect(Tv[10]*Tv[44]/Tv[206])
    else
     Tv[45]:=0;
    Tv[46]:=MaxR(0,Tv[38]-Tv[45]);
  // end
  (*
   Else
   Begin
   *)
{
    For i:=39 to 43 do begin Tv[i]:=0;;end; //20190930   //For i:=38 to 43 do begin Tv[i]:=0;;end;
    For i:=44 to 46 do begin Tv[i]:=0;end;  //46 insted of 56
   end;

    //after Dec 31, 2013
   If GetNumDays(RetNo,'31-12-2018','A')> 0 then    //20160620
   Begin
    //Tv[16]:=GetTxblIncomeInProv(RetNo,'MB'); //jz 2019 removed

    Tv[17]:=Ret[RetNo].Ln[400]; //20170627 //[278]; //MaxR(Vl(FetchElm(RetNo,'T2',335)),Tv[278]);   //20170602
    //if Tv[278]>0 then Tv[17]:=Tv[278]; //jz 2019 ?????????????? 278 not used?  //20170627

    Tv[18]:=Ret[RetNo].Ln[405]; //Vl(FetchElm(RetNo,'T2',336));
    Tv[20]:=Ret[RetNo].Ln[428]; //20200926  //GetReducedBusinessLimit(RetNo); //jz 2019 ??????????????  //20190626  Ret[RetNo].Ln[427]; //Vl(FetchElm(RetNo,'T2',342));
    //Tv[20]:=RoundCorrect(Tv[19]*450000/500000);    //20160620
    Tv[21]:=MinR(Tv[17],MinR(Tv[18],Tv[20]));
    Tv[14]:=Tv[21];

    {<--- //jz 2019 REMOVED
    If IsCreditUnion(RetNo) then
     Tv[27]:=Vl(FetchElm(RetNo,'S17',61)) //20181108 //Vl(FetchElm(RetNo,'S17',63))
    else
     Tv[27]:=0;
    Tv[28]:=Tv[21];
    Tv[29]:=MaxR(0,Tv[27]-Tv[28]);
    Tv[30]:=Tv[29];

    Tv[11]:=Tv[30];
    Tv[12]:=Round(Tv[11]*0.80);
    Tv[31]:=Tv[21]+Tv[12]; //Tv[21]+Tv[30];
    -->}


  {
    Tv[32]:=Tv[14]; //Tv[31]; //jz 2019
    Tv[22]:= Tv[38]; //jz 2019 changed from //Tv[16];
    Tv[25]:=GetTxblIncomeInAllProv(RetNo);

    If Tv[25]>0 then
     Tv[23]:=RoundCorrect(Tv[32]*Tv[22]/Tv[25])
    else
     Tv[23]:=0;
    Tv[24]:=MaxR(0,Tv[38]-Tv[23]);//MaxR(0,Tv[16]-Tv[23]);
   End
   Else
   Begin
   // Tv[16]:=0;
    Tv[17]:=0;
    Tv[18]:=0;
    Tv[20]:=0;
    Tv[21]:=0;
    Tv[14]:=0;
    Tv[32]:=0;
    Tv[22]:=0;
    Tv[25]:=0;
    Tv[23]:=0;
    Tv[24]:=0;
   end;

   //Part 2   - bfr jan 1 204 -------------------------------------------------
   If GetNumDays(RetNo,'01-01-2019','B')> 0 then     //20160620
   Begin
    Tv[279]:=Vl(FetchElm(RetNo,'S7',159));
    Tv[280]:=Vl(FetchElm(RetNo,'S7',26));
    Tv[15] :=Vl(FetchElm(RetNo,'S7',99));   //jz 2019 added
    Tv[26] :=Vl(FetchElm(RetNo,'S7',100));  //jz 2019 added
    Tv[33] :=Vl(FetchElm(RetNo,'S7',165));  //jz 2019 added

    Tv[281]:=Tv[279]- ( Tv[280] + Tv[15] + Tv[26] ) - Tv[33]; //jz 2019 updated
    Tv[146]:=Tv[281];
    Tv[147]:=Vl(FetchElm(RetNo,'S7',150));

    i:=148;
    j:=105;
    Repeat
     Tv[i]:=Vl(FetchElm(RetNo,'S7',j));
     Inc(i,4);
     Inc(j,8);
    until i>164;

    i:=149;
    j:=107;
    Repeat
     Tv[i]:=RoundCorrect(Vl(FetchElm(RetNo,'S7',j)) * 450000/500000);    //20160620
     Inc(i,4);
     Inc(j,8);
    until i>165;
    i:=150;Tv[168]:=0;Tv[169]:=0;
    Repeat
     Tv[i]:=MaxR(0,Tv[i-2]-Tv[i-1]);
     Tv[i+1]:= MinR(Tv[i-2],Tv[i-1]);
     If Tv[i-2]<0 then Tv[i+1]:=0;
     Tv[168]:=Tv[168]+Tv[i];
     Tv[169]:=Tv[169]+Tv[i+1];
     Inc(i,4);
    until I>166;

    Tv[170]:=Vl(FetchElm(RetNo,'S7',143));
    Tv[171]:=Vl(FetchElm(RetNo,'S7',144));
    Tv[172]:=Tv[170]+Tv[171];
    Tv[173]:=MinR(Tv[168],Tv[172]);
    Tv[174]:=Tv[169]+Tv[173];
    Tv[175]:=Tv[174];
    Tv[176]:=MaxR(0,Tv[147]-Tv[175]);
    Tv[177]:=Tv[176];
    Tv[178]:=MaxR(0,Tv[146]-Tv[177]);
   end
   Else
   Begin
    For i:=279 to 281 do begin Tv[i]:=0;;end;
    For i:=146 to 178 do begin Tv[i]:=0;;end;
   end;

   //Part 3
   Tv[183]:= Tv[46];
   Strings[184]:=IntToStr(GetNumDays(RetNo,'01-01-2019','B'));
   Strings[185]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[186]:=RoundCorrect(Tv[183]* vl(Strings[184])/Vl(Strings[185]));

   Tv[211]:=Tv[24];
   Strings[212]:=IntToStr(GetNumDays(RetNo,'31-12-2018','A'));
   Strings[213]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[195]:=RoundCorrect(Tv[211] * Vl(Strings[212])/Vl(Strings[213]));

   Tv[196]:=Tv[186]+Tv[195];
   Tv[35] :=Tv[196]; //jz 2019 added
   Tv[36] :=RoundCorrect(Tv[35]*12/100); //RoundCorrect(Tv[196]*12/100); ////jz 2019 added
   Tv[37] :=VL(FetchElm(RetNo,'S17',148)); //jz 2019 added ???

   Tv[217]:=MaxR(0,Tv[36]-Tv[37]); //RoundCorrect(Tv[196]*12/100); //jz 2019 updated
 end;
 }


(*
//prior to 20190920
//20190421
procedure S383(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   If (Ret[RetNo].Province = 'MB') or
    (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 278 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   FillHeader(RetNo,FNo,1,2,3);
   If GetNumDays(RetNo,'01-01-2019','B')> 0 then    //20190422
   Begin
    //20170627
    Tv[38]:=GetTxblIncomeInProv(RetNo,'MB');
    Tv[39]:=Ret[RetNo].Ln[400]; If Tv[178]>0 then Tv[39]:=Tv[178]; //MaxR(Vl(FetchElm(RetNo,'T2',335)),Tv[178]);  //20170602
    Tv[40]:=Ret[RetNo].Ln[405]; //  Vl(FetchElm(RetNo,'T2',336));
    Tv[41]:=Ret[RetNo].Ln[428]; //20200926  //GetReducedBusinessLimit(RetNo); //20190626  Ret[RetNo].Ln[427]; //20170620 Vl(FetchElm(RetNo,'T2',342));
    Tv[42]:=RoundCorrect(Tv[41]*450000/500000);   //20160620
    //Tv[42]:=RoundCorrect(Tv[41]*425000/500000);   //20160620
    Tv[43]:=MinR(Tv[39],MinR(Tv[40],Tv[42]));
    If IsCreditUnion(RetNo) then
     Tv[5]:=Vl(FetchElm(RetNo,'S17',61)) //20181108 //Vl(FetchElm(RetNo,'S17',63))
    else
     Tv[5]:=0;
    Tv[6]:=Tv[43];
    Tv[7]:=MaxR(0,Tv[5]-Tv[6]);
    Tv[8]:=Tv[7];
    Tv[9]:=Tv[43]+Tv[8];
    Tv[10]:=Tv[9];
    Tv[44]:=Tv[38];
    Tv[206]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[206]>0 then
     Tv[45]:=RoundCorrect(Tv[10]*Tv[44]/Tv[206])
    else
     Tv[45]:=0;
    Tv[46]:=MaxR(0,Tv[38]-Tv[45]);
   end
   Else
   Begin
    For i:=38 to 43 do begin Tv[i]:=0;;end;
    For i:=5 to 9 do begin Tv[i]:=0;;end;
    For i:=44 to 46 do begin Tv[i]:=0;;end;  //46 insted of 56
   end;

    //after Dec 31, 2013
   If GetNumDays(RetNo,'31-12-2018','A')> 0 then    //20160620
   Begin
    Tv[16]:=GetTxblIncomeInProv(RetNo,'MB');
    Tv[17]:=Ret[RetNo].Ln[400]; //20170627 //[278]; //MaxR(Vl(FetchElm(RetNo,'T2',335)),Tv[278]);   //20170602
    if Tv[278]>0 then Tv[17]:=Tv[278];   //20170627
    Tv[18]:=Ret[RetNo].Ln[405]; //Vl(FetchElm(RetNo,'T2',336));
    Tv[20]:=GetReducedBusinessLimit(RetNo); //20190626  Ret[RetNo].Ln[427]; //Vl(FetchElm(RetNo,'T2',342));
    //Tv[20]:=RoundCorrect(Tv[19]*450000/500000);    //20160620
    Tv[21]:=MinR(Tv[17],MinR(Tv[18],Tv[20]));

    If IsCreditUnion(RetNo) then
     Tv[27]:=Vl(FetchElm(RetNo,'S17',61)) //20181108 //Vl(FetchElm(RetNo,'S17',63))
    else
     Tv[27]:=0;
    Tv[28]:=Tv[21];
    Tv[29]:=MaxR(0,Tv[27]-Tv[28]);
    Tv[30]:=Tv[29];

    Tv[11]:=Tv[30];
    Tv[12]:=Round(Tv[11]*0.80);
    Tv[31]:=Tv[21]+Tv[12]; //Tv[21]+Tv[30];

    Tv[32]:=Tv[31];
    Tv[22]:=Tv[16];
    Tv[25]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[25]>0 then
     Tv[23]:=RoundCorrect(Tv[32]*Tv[22]/Tv[25])
    else
     Tv[23]:=0;
    Tv[24]:=MaxR(0,Tv[16]-Tv[23]);
   End
   Else
   Begin
    Tv[16]:=0;
    Tv[17]:=0;
    Tv[18]:=0;
    Tv[20]:=0;
    Tv[21]:=0;
    Tv[27]:=0;
    Tv[28]:=0;
    Tv[29]:=0;
    Tv[30]:=0;
    Tv[11]:=0;
    Tv[12]:=0;
    Tv[31]:=0;
    Tv[32]:=0;
    Tv[22]:=0;
    Tv[25]:=0;
    Tv[23]:=0;
    Tv[24]:=0;
   end;

   //Part 2   - bfr jan 1 204
   If GetNumDays(RetNo,'01-01-2019','B')> 0 then     //20160620
   Begin
    Tv[279]:=Vl(FetchElm(RetNo,'S7',159));
    Tv[280]:=Vl(FetchElm(RetNo,'S7',26));
    Tv[281]:=Tv[279]-Tv[280];
    Tv[146]:=Tv[281];
    Tv[147]:=Vl(FetchElm(RetNo,'S7',150));

    i:=148;
    j:=105;
    Repeat
     Tv[i]:=Vl(FetchElm(RetNo,'S7',j));
     Inc(i,4);
     Inc(j,8);
    until i>164;

    i:=149;
    j:=107;
    Repeat
     Tv[i]:=RoundCorrect(Vl(FetchElm(RetNo,'S7',j)) * 450000/500000);    //20160620
     Inc(i,4);
     Inc(j,8);
    until i>165;
    i:=150;Tv[168]:=0;Tv[169]:=0;
    Repeat
     Tv[i]:=MaxR(0,Tv[i-2]-Tv[i-1]);
     Tv[i+1]:= MinR(Tv[i-2],Tv[i-1]);
     If Tv[i-2]<0 then Tv[i+1]:=0;
     Tv[168]:=Tv[168]+Tv[i];
     Tv[169]:=Tv[169]+Tv[i+1];
     Inc(i,4);
    until I>166;

    Tv[170]:=Vl(FetchElm(RetNo,'S7',143));
    Tv[171]:=Vl(FetchElm(RetNo,'S7',144));
    Tv[172]:=Tv[170]+Tv[171];
    Tv[173]:=MinR(Tv[168],Tv[172]);
    Tv[174]:=Tv[169]+Tv[173];
    Tv[175]:=Tv[174];
    Tv[176]:=MaxR(0,Tv[147]-Tv[175]);
    Tv[177]:=Tv[176];
    Tv[178]:=MaxR(0,Tv[146]-Tv[177]);
   end
   Else
   Begin
    For i:=279 to 281 do begin Tv[i]:=0;;end;
    For i:=146 to 178 do begin Tv[i]:=0;;end;
   end;

   {
   //Part 2   - after Dec 31, 2015
   If GetNumDays(RetNo,'31-12-2015','A')> 0 then   //20160620
   Begin
    Tv[282]:=Vl(FetchElm(RetNo,'S7',159));
    Tv[283]:=Vl(FetchElm(RetNo,'S7',26));
    Tv[285]:=Vl(FetchElm(RetNo,'S7',99));
    Tv[286]:=Vl(FetchElm(RetNo,'S7',100));
    Tv[287]:=Vl(FetchElm(RetNo,'S7',165));
    Tv[284]:=Tv[282]-(Tv[283]+Tv[285]+Tv[286])+Tv[287];      //20180508
    Tv[246]:=Tv[284];
    Tv[247]:=Vl(FetchElm(RetNo,'S7',150));

    i:=248;
    j:=105;
    Repeat
     Tv[i]:=Vl(FetchElm(RetNo,'S7',j));
     Inc(i,4);
     Inc(j,8);
    until i>264;

    i:=249;
    j:=64; //107;   //20180508
    Repeat
     Tv[i]:=RoundCorrect(Vl(FetchElm(RetNo,'S7',j)) * 450000/500000);   //20160620
     Inc(i,4);
     Inc(j,1);   //not 4  //20180510
    until i>265;

    i:=250;Tv[268]:=0;Tv[269]:=0;
    Repeat
     Tv[i]:=MaxR(0,Tv[i-2]-Tv[i-1]);
     Tv[i+1]:= MinR(Tv[i-2],Tv[i-1]);
     If Tv[i-2]<0 then Tv[i+1]:=0;
     Tv[268]:=Tv[268]+Tv[i];
     Tv[269]:=Tv[269]+Tv[i+1];
     Inc(i,4);
    until I>266;

    Tv[270]:=Vl(FetchElm(RetNo,'S7',143));
    Tv[271]:=Vl(FetchElm(RetNo,'S7',144));
    Tv[272]:=Tv[270]+Tv[271];
    Tv[273]:=MinR(Tv[268],Tv[272]);
    Tv[274]:=Tv[269]+Tv[273];
    Tv[275]:=Tv[274];
    Tv[276]:=MaxR(0,Tv[247]-Tv[275]);
    Tv[277]:=Tv[276];
    Tv[278]:=MaxR(0,Tv[246]-Tv[277]);
   end
   Else
   Begin
    For i:=282 to 284 do begin Tv[i]:=0;;end;
    For i:=246 to 278 do begin Tv[i]:=0;;end;
   end;
  }

  //final calc
   Tv[183]:= Tv[46];
   Strings[184]:=IntToStr(GetNumDays(RetNo,'01-01-2019','B'));
   Strings[185]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[186]:=RoundCorrect(Tv[183]* vl(Strings[184])/Vl(Strings[185]));

   Tv[211]:=Tv[24];
   Strings[212]:=IntToStr(GetNumDays(RetNo,'31-12-2018','A'));
   Strings[213]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[195]:=RoundCorrect(Tv[211] * Vl(Strings[212])/Vl(Strings[213]));

   Tv[196]:=Tv[186]+Tv[195];
   Tv[217]:=RoundCorrect(Tv[196]*12/100);
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

//20171104
procedure S443(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   If (Ret[RetNo].Province = 'YT') or
    (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 217 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   FillHeader(RetNo,FNo,1,2,3);

    Tv[6]:=GetTxblIncomeInProv(RetNo,'YT');
    //20190626
    Tv[7]:=Ret[RetNo].Ln[400]; //MaxR(Vl(FetchElm(RetNo,'T2',335)),Tv[178]);
    Tv[8]:=Ret[RetNo].Ln[405]; //Vl(FetchElm(RetNo,'T2',336));
    Tv[11]:=Ret[RetNo].Ln[428]; //20200926 //GetReducedBusinessLimit(RetNo); //20190626  Ret[RetNo].Ln[427]; //20170620 Vl(FetchElm(RetNo,'T2',342));
    Tv[12]:=MinR(Tv[7],MinR(Tv[8],Tv[11]));

    Tv[18]:=Tv[12];
    Tv[13]:=Tv[6];
    Tv[16]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[16]>0 then
     Tv[14]:=RoundCorrect(Tv[18]*Tv[13]/Tv[16])
    else
     Tv[14]:=0;
    Tv[15]:=MaxR(0,Tv[6]-Tv[14]);

  //20170625
  // Tv[49]:= Tv[14];
  // Tv[34]:=Round(Tv[49]*2/100);

   Tv[21]:=Tv[15];
   Tv[33]:=Round(Tv[21]*12/100);
   Tv[217]:=Tv[34]+Tv[33];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure S388(RetNo: integer; FName: String;FNo: integer);
Var i,k:Integer;YEnd,Dateb:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If (Ret[RetNo].Province = 'MB') or
    (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 81 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
   If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
   If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);
   If Strings[11]+Strings[12]='' then Strings[11]:='X';
   If Strings[13]+Strings[14]='' then Strings[13]:='X';
   If Strings[15]+Strings[16]='' then Strings[15]:='X';
   If Strings[17]+Strings[18]='' then Strings[17]:='X';
   //Part 3 -----------------------------------------
   If Tv[21]>Tv[20] then Tv[21]:=Tv[20];
   if Tv[20] = 0 then
    Strings[22] := '0.00'
   else
    Strings[22] := FormatFloat('###.##',(Tv[21] / Tv[20]) * 100);

   //if Vl(Strings[22]<25 then //NOT eligible ?? ag

   //part 4
   Strings[28]:=Strings[10];
   Dateb:=Strings[29];
   If Strings[30]>Dateb then Dateb:=Strings[30];
   If Strings[31]>Dateb then Dateb:=Strings[31];

   If Strings[28]<Dateb then Strings[27]:=Strings[28] else strings[27]:=Dateb;

   If Strings[25]+Strings[26]='' then Strings[25]:='X';
   If (Strings[24]>'') and (Strings[26]>'') then
   begin
    For i:=27 to 31 do Strings[i]:='';
   end
   else
   begin
    // ?? Strings[27]:=Strings[28];
   end;

   //Part 5 -----------------------------------------
   Tv[37] := Tv[33] + Tv[34] + Tv[35] + Tv[36];
   Tv[38] := Tv[37];
   Tv[40] := Tv[32] + Tv[38] + Tv[39];

   //Tv[42] := Tv[40];   //20210920
   //Tv[43] := ; ????????  user
   Tv[44] := RoundCorrect(Tv[42] * Vl(Strings[43])/100);
   Tv[45] := MinR(Tv[41],Tv[44]);
   //Part 6 -----------------------------------------
   Tv[46] := Tv[40];
   Tv[47] := Tv[45];
   Tv[48] := Tv[46] + Tv[47];
   Tv[50] := MaxR(0,Tv[48] - Tv[49]);
   Tv[52] := Tv[50] + Tv[51];
   Tv[54] := MaxR(0,Tv[52] - Tv[53]);
   Tv[55] := Tv[54];
   //Tv[56] := ; user input  Strings
   Tv[57] := RoundCorrect(Tv[55] * Vl(Strings[56])/100);
   //Part 7 -----------------------------------------
   Tv[58] := Tv[54];
   //Tv[59] := ; user
   Tv[60] := RoundCorrect(Tv[58] * vl(Strings[59])/100);
   If Vl(Strings[61])>100 then Strings[61]:='100';
   //Tv[61] :=  //user
   Tv[62] := RoundCorrect(Tv[60] * Vl(Strings[61]) / 100);
   //Part 8 -----------------------------------------
   Tv[63] := Tv[54];
   //Tv[64] := ;  user
   Tv[65] := RoundCorrect(Tv[63] * Vl(Strings[64]) / 100);
   //Part 9 -----------------------------------------
   Tv[66] := Tv[54];
   //Tv[67] := ;  user
   Tv[68] := Tv[66] * Vl(Strings[67]) / 100;
   //Part 10 ----------------------------------------
  // If Strings[10]>'2010/03/31' then
  // begin
    Tv[87]:=Tv[83]+Tv[84]+Tv[85]+Tv[86];
    Tv[88]:=Tv[87];

    Tv[91]:= Tv[82]+Tv[88]+Tv[89]+Tv[90]+Tv[119];  //20141116
    Tv[97]:=MaxR(0,Tv[91]-Tv[96]);
    Tv[98]:=Tv[97];
    Tv[99]:=RoundCorrect(Tv[98]*30/100);
    Tv[23]:=Tv[97];
    Tv[24]:=RoundCorrect(Tv[23]*8/100);
    Tv[25]:=Tv[99]+Tv[24];
  {
   end
   Else
   begin
    For i:=82 to 99 do Tv[i]:=0;
   end;
  }
   Tv[69] := Tv[57];
   Tv[70] := Tv[62];
   Tv[71] := Tv[65];
   Tv[72] := Tv[68];
   Tv[100]:=Tv[69] + Tv[70] + Tv[71] + Tv[72];
   Tv[101]:=Tv[25];
   Tv[73]:= MaxR(Tv[100],Tv[101]);  //20210515
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure S389(RetNo: integer; FName: String;FNo: integer);
Var i,k:Integer;YEnd:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If (Ret[RetNo].Province = 'MB') or
    (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 67 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;


   //Part 1 -----------------------------------------
   If Strings[4]+Strings[5]='' then Strings[4]:='X';
   If Strings[6]+Strings[7]='' then Strings[6]:='X';
   If Strings[8]+Strings[9]='' then Strings[8]:='X';

   If Tv[11]<Tv[10] then Tv[11]:=Tv[10];
   if Tv[11] = 0 then
    Strings[12] := ''
   else
    Strings[12] := FormatFloat('###.##',RoundCorrect((Tv[10] / Tv[11]) * 100)); //20180610

   //Part 2 -----------------------------------------
   //are strings?
   k:=0;
   i:=17;
   Repeat
    k:=k+MyStrToInt(Strings[i]);
    Inc(i,6);
   until i>49;
   Strings[53]:=IntToStr(k);
   //Part 3 -----------------------------------------
   Tv[54]:=Tv[10];   //20180509
   Tv[56] := RoundCorrect(Tv[55] * 65/100);
   Tv[57] := Tv[54] + Tv[56];
   Strings[58] := Strings[53];
   If Vl(Strings[59])<Vl(Strings[58]) then Strings[59]:=Strings[58];
   if Vl(Strings[59]) = 0 then
     Strings[60] := ''
   else
    Strings[60] := FormatFloat('##0.00',RoundCorrect((Vl(Strings[58]) / Vl(strings[59])) * 100));
   Tv[61] := RoundCorrect(Tv[57] * Vl(Strings[60])/100);
   Tv[63] := Tv[61] + Tv[62];
   Tv[64] := RoundCorrect(MinR(100000,Tv[63] * 40/100));
   //20120530
  //v[69]:=Round(Tv[65] * 10/100);
  //v[70]:=Round(Tv[68] * 15/100);
   Tv[66]:=RoundCorrect(Tv[68]*15/100);  //20180502
   //Tv[66] := Tv[71];  //20180526
   Tv[67] := Tv[64] + Tv[66];
  end;
  SaveTv(RetNo,FName,FNo);
end;

procedure S400(RetNo: integer;FName: string;FNo: integer);
{SK royalty taxrebate}
Var i:integer; X1,X2:Real;
begin
  If Vl(GetPrvAlloc(RetNo,'SK')) = 0 then
  begin
   For i:=1 to 44 do begin StoreElm(RetNo,FNo,i,'');end;
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   Tv[8] := Vl(FetchElm(RetNo,'S12',120));
   Tv[9] := Vl(FetchElm(RetNo,'S12',121));
   Tv[10] := Vl(FetchElm(RetNo,'S12',221))+Vl(FetchElm(RetNo,'S12',222));
   Tv[11] := Vl(FetchElm(RetNo,'S12',223))+Vl(FetchElm(RetNo,'S12',224));

   Tv[12] := GetTxblIncome(RetNo);
   Tv[13] := Vl(FetchElm(RetNo,'S1',4));
   Tv[14] := Vl(FetchElm(RetNo,'S12',22))+Vl(FetchElm(RetNo,'S12',23));

   Tv[17] := Tv[15]+Tv[16];
   Tv[18]:= Vl(FetchElm(RetNo,'S51',244));
   Tv[19] := Tv[17];
   Tv[20] := Tv[18]-Tv[19];
   Tv[21]:= Vl(FetchElm(RetNo,'S1',223));
   Tv[22] := MaxR(0,Tv[20]+Tv[21]);
   Tv[23] := Vl(FetchElm(RetNo,'S12',12))+Vl(FetchElm(RetNo,'S12',11));
   Tv[24] := RoundCorrect(Tv[22] * 0.25);
   Tv[25] := Tv[23] - Tv[24];
   Tv[28] := MaxR(0,Tv[25]+Tv[26]+Tv[27]);
   Tv[29] := Tv[17];
   Tv[30] := Tv[21];
   Tv[31] := Tv[29] - Tv[30];
   If Tv[25] >=0 then
    Tv[32] := Tv[25]
   else
    Tv[32] := MinR(ABS(Tv[25]),Tv[26]+Tv[27]);
   Tv[33] := MaxR(0,Tv[31] -Tv[32]);

   If (Ret[RetNo].Province = 'MJ') then
   begin
   X1:= Vl(FetchElm(RetNo,'S5',186));
   X2:= Vl(FetchElm(RetNo,'S5',274));
   end
   else
   begin
    X1:= GetTxblIncome(RetNo);
    X2:= GetTxblIncome(RetNo);
   end;
   If X2<>0 then
    Tv[34] := RoundCorrect(Tv[33] * X1/X2)
   else
    Tv[34] :=0;
   Tv[46]:=X1;
   Tv[47]:=X2;

   Tv[48]:=Vl(FetchElm(RetNo,'S5',724));
   Tv[49]:=Tv[46];
   If Tv[49]>0 then
    Tv[35]:=RoundCorrect(Tv[34] * (Tv[48]/Tv[49]))
   else
    Tv[35]:=0;


   Tv[38] := Tv[35]+Tv[36]+Tv[37];
   Tv[39] := Vl(FetchElm(RetNo,'S5',724));
   Tv[41] := Vl(FetchElm(RetNo,'S5',729)); //Vl(FetchElm(RetNo,'S5',425)); //20090210
   Tv[40] := MaxR(0,Tv[39]-Tv[41]);
   Tv[42] := MinR(Tv[38],Tv[40]);
   Tv[43] := MaxR(0,Tv[40]-Tv[42]);
   Tv[44] := MaxR(0,Tv[38]-Tv[42]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20171104
procedure S402(RetNo: integer;FName: string;FNo: integer);
Var i,k:integer;ThisYearEnd:String;
   //x:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   Tv[20]:=0; //Tv[7]+Tv[11]+Tv[15]+Tv[19];
   Tv[57]:=0;
   Tv[58]:=0;
  // Tv[63]:=0;
  // x:=0;  //prior tp 2004/04/01
   i:=7;
   Repeat
    Tv[20]:=Tv[20]+Tv[i];
    //If Strings[i-1]<'2004/04/01' then x:=x+Tv[i];
    If Strings[i-1]<'2017/03/23' then Tv[57]:=Tv[57]+Tv[i];
    If Strings[i-1]>'2017/03/22' then Tv[58]:=Tv[58]+Tv[i];
   // If (Strings[i-1]>'2006/10/27') then Tv[63]:=Tv[63]+Tv[i];
    Inc(i,4);
   until i>19;

   Tv[23] := MaxR(0,Tv[21]-Tv[22]);
   Tv[24] := Tv[23];

   Tv[30]:=Tv[23]+Tv[25];
   Tv[31]:=Tv[30];
   Tv[32] := Tv[24]+Tv[31];
   //Tv[35]:= Tv[45];

   If UpperCase(Strings[79]) <> 'Y' then Tv[34]:=MaxR(0,Tv[31]-Tv[33]);
   If Tv[34]>GetMaxSkItc(RetNo) then Tv[34]:=GetMaxSkItc(RetNo);
   //Tv[36]:=Tv[33]+Tv[34]+Tv[35];
   //Tv[37]:=Tv[36];
   Tv[38]:= MaxR(0,Tv[31]-Tv[33]-Tv[34]);  //20171121

   //Tv[26]:=Tv[58];
   //Tv[27]:=Tv[26] * 7/100;

   Tv[61]:=Tv[57];
   Tv[62]:=RoundCorrect(Tv[61]*5/100);

   Tv[26]:=Tv[58];
   Tv[27]:=RoundCorrect(Tv[26]*6/100);

   Tv[66]:=Tv[62]+Tv[27]++Tv[59]+Tv[60];

  // Tv[78]:=AddColumns(67,77,1);

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S420(RetNo: integer;FName: string;FNo: integer);
Var i,Ndx:integer;sbd:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If (Ret[RetNo].Province = 'MJ')  or (Ret[RetNo].Province = 'BC') then
    begin
    Tv[9]:=GetTxblIncomeInProv(RetNo,'BC');
    Tv[4]:=Tv[9]+Tv[10];
    Tv[5] := GetPrvTaxBfrCredits(RetNo,Ret[RetNo].Province,'BC');
    Sbd := GetIncForSmBusDed(RetNo);
    Ndx:=GetPrvNdx('BC');
    Tv[6] := Tv[5]+RoundCorrect(Tv[10] * PrvHighRate[Ndx]/100);
    Tv[7] := Tv[5]-Tv[6];
    If Tv[4] <=0 then Tv[7] :=0;
    end
    else
    for i:=4 to 7 do Tv[i] :=0;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


//20180510
procedure S440(RetNo: integer;FName: string;FNo: integer);
Var i:integer; YtTaxable:Real;
begin

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If (Ret[RetNo].Province = 'MJ')  or (Ret[RetNo].Province = 'YT') then
   begin
    {form needs revision}
    Tv[4] := Vl(FetchElm(RetNo,'S27',213));
    Tv[19]:= Vl(FetchElm(RetNo,'S443',12));
    Tv[10]:=Tv[4]+Tv[19];
    Tv[12]:=Ret[RetNo].Ln[360];

    Tv[27]:=Tv[19];
    Tv[28]:=Ret[RetNo].Ln[440];
    If Ret[RetNo].CorpType <> CCPC then
    Begin
     Tv[27]:=0;
     Tv[28]:=0;
    End;

    Tv[29]:=Ret[RetNo].Ln[636];
    Tv[30]:=RoundCorrect(Tv[29]*4);
    Tv[23]:=Tv[27]+Tv[28]+Tv[30];
    Tv[22]:=Tv[23];
    Tv[21]:=MaxR(0,Tv[12]-Tv[22]);

    {
    Tv[20]:=Tv[6]*Vl(Strings[7]) /Ret[RetNo].DaysInYear;
    Tv[11]:=Tv[19]+Tv[20];
    Tv[8]:=Tv[11];
    Tv[10]:=MaxR(0,Tv[4]-Tv[8]);
    }

    Tv[9]:=MinR(Tv[4],Tv[19]);
    Tv[14]:=GetTxblIncomeInProv(RetNo,'YT');
    TV[15]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[15]>0 then
     Tv[34]:=RoundCorrect(Tv[9] * (Tv[14]/Tv[15]))
    Else
     Tv[34]:=0;

    Tv[11]:=Tv[34];
    Strings[16]:=IntToStr(GetNumDays(RetNo,'01-01-2021','B'));
    Strings[17]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[18]:=RoundCorrect(Tv[11]*(Vl(Strings[16])/Vl(Strings[17]))*(0.5/100));


    Tv[31]:=MinR(Tv[10],Tv[21]);
    Tv[32]:=GetTxblIncomeInProv(RetNo,'YT');
    Tv[33]:=GetTxblIncomeInAllProv(RetNo);

    if Tv[33]>0 then
      Tv[35]:=RoundCorrect(Tv[31]* (Tv[32]/Tv[33])*(9.5/100))
    Else
      Tv[35]:=0;

    Tv[13]:=Tv[18]+Tv[35];
   end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



//20221129
procedure S31(RetNo: integer;FName: string;FNo: integer);
Var
    i,j:integer;
    Yr:integer;
    BL:Real;
    L390,L395,L398,Page4Line4,BoxA,BoxB,EE,FF:Real;
    FNo7S31:integer;

    SixMil,SixtyMil:integer;  //jz//20260625
begin
  //20180610 use RoundCorrect
  LoadTv(RetNo,FName,FNo);

  //s31 pg 3 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,101,102,103);
   If Strings[604]+Strings[605] = '' then Strings[605] := 'X';  //20221129
   //If Strings[104]+Strings[105] = '' then Strings[104] := 'X';  //??20221129
   //If UpperCase(Strings[104]+Strings[105]) = 'XX' then Strings[104] := '';
   If Strings[107]+Strings[108] = '' then Strings[108] := 'X';
   //If UpperCase(Strings[107]+Strings[108]) = 'XX' then Strings[108] := '';
   Tv[109]:=Round(Tv[2]*80/100);  //20201105
  end; {End with}

  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,267,268,269);
   I:=205;
   Tv[236] :=0;
   Repeat
    Tv[236] := Tv[236]+Tv[i];
    Inc(i,5);
   until i>235;
    For i:=205 to 271 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121

    //20260903 Alex >>>
    //Page 3
    if (Tv[8]) > 60000000 then Tv[8]:= 60000000 else
    if (Tv[8]) < 0 then Tv[8]:= 0;
    //20260903 Alex <<<

   //pg 4
   Tv[240] := Tv[238]+Tv[239];
   Tv[241] := Tv[240];
   Tv[242] := MaxR(0,Tv[237] - Tv[241]);

   Tv[245]:=Tv[236];    //20241201
   Tv[246] := RoundCorrect(Tv[245] * 0.10);
   //Tv[274]:= RoundCorrect(Tv[276] * 0.10);
   Tv[248]:=Tv[243]+Tv[244]+Tv[246]+Tv[247];
   Tv[249] := Tv[248];
   Tv[250] := Tv[242]+Tv[249];

   Tv[251] := GetMaxItcClaim(RetNo,Tv[250],'QP');
   If Tv[266] >0 then Tv[251] := Tv[266];
   Tv[252] := Tv[265];
   Tv[254] := Tv[251]+Tv[252]+Tv[253];
   Tv[255] := Tv[254];
   Tv[256] := MaxR(0,Tv[250]-Tv[255]);



   Tv[257] := Tv[271]; //Vl(FetchElm(Retno,'S31',306));  //20091025
   Tv[258] := MaxR(0,Tv[256]-Tv[257]);

   Yr := GetTaxationYearEndYYYY(RetNo);
   Strings[259]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[261]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[263]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
   Tv[265] := Tv[260]+Tv[262]+Tv[264];

   If Strings[270] ='' then strings[270] :='Y';
   If UpperCase(Strings[270]) = 'Y' then
   begin
    Tv[273] := Tv[244]+Tv[246]+Tv[247];
    Tv[272] := Tv[256];
    Tv[271] := RoundCorrect(0.40 * (MinR(Tv[273],Tv[272])));  //20180610
   end
   else
   begin
    For i:=271 to 273 do Tv[i] :=0;
   end;
  end; {End with}

  //s31 pg 5 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,301,302,303);
   If Strings[326] ='' then strings[326] :='Y';
   If Strings[329]+Strings[330]='' then Strings[330]:='X';

   For i:=307 to 331 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121

   If UpperCase(Strings[326]) = 'Y' then
   begin
    Tv[307] :=MaxR(0,Vl(FetchElm(RetNo,'T661',331)))+Tv[109];  //20260612cz->change not marked, jz updated with file compare //20210211 //MaxR(0,Vl(FetchElm(RetNo,'T661',168)))+Tv[109];  //20210211
    Tv[19]  := Vl(FetchElm(RetNo, 'T661', 330)); //20260524  questionable
    //20260501 Alex //T661 does not have line 558 and last update on the CRA site from the 2020 year.
    Tv[309] := Vl(FetchElm(RetNo,'T661',169));
   end;
   Tv[310]:= Tv[307] + Tv[19] + Tv[309]; //20260501 Alex //Tv[307]+Tv[308]+Tv[309];   //20191019

   BL:=400000;
   If Strings[329]>'' then //Ret[RetNo].CorpType<>CCPC then
   begin
    Tv[311]:=0;
    Tv[312]:=0;
   end;
  end; {End with}

  //s31 pg 5 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
    {
     L390:=Tv[311];
     L395:=Tv[312];
     L398:=Tv[331];
     Page4Line4:=Vl(FetchElm(RetNo,'T2',333)); //20111206 Vl(FetchElm(RetNo,'T2',334));
    }

    //20221129
    if Ret[RetNo].corptype = CCPC then
    Begin
     if (Strings[11] + Strings[12] = '') then Strings[12]:= 'X'; //20260501 Alex
     if (Strings[13] + Strings[14] = '') then Strings[14]:= 'X'; //20260501 Alex
     if Strings[329] + Strings[330] = '' then Strings[330]:= 'X';
     if (Strings[43] + Strings[44] = '') then Strings[44]:= 'X'; //20260903 Alex
     //Tv[331]:=MaxR(0,Tv[331]-40000000);
     if Tv[331] > 60000000 then Tv[331]:= 60000000; //40000000 //20260903 Alex
    End
    Else
    Begin
      Strings[29]:='';
      Strings[330]:='';
      Tv[331]:=0;
    End;

    //20260903 Alex >>>
    if (Strings[43] = 'X') then
    begin
      Strings[45]:= '';
      Strings[46]:= '';
      Strings[47]:= '';
      Tv[48]:= 0;
      Tv[49]:= 0;
      Tv[50]:= 0;
    end;
    //20260903 Alex <<<

    Tv[15]:=minr(60000000,maxr(0,Tv[15])); //jz//20260622 - line 399 > 0, < 60,000,000

  end; //end with //jz//20260622



  //Part 10  //jz//20260622 - added if before date ('2024/12/16')
  //                        - adjusted part a, part b all wrong so fixed
  //                        - populate ln410 differently
  //                        - moved when the clearing of fields is done
  with Ret[RetNo].Frm[Fno] do
  begin
    //Part 10a - clear
    Tv[465]:=0; strings[466]:=''; Tv[467]:=0; Tv[419]:=0; Tv[420]:=0; strings[421]:=''; Tv[422]:=0; Tv[423]:=0;
    //Part 10b - clear
    Tv[20] :=0; strings[22] :=''; Tv[23] :=0; Tv[24] :=0; Tv[25] :=0; strings[41] :=''; Tv[26] :=0; Tv[27] :=0;

      //Part 10a
    if GetTaxationYearStart(RetNo) < '2024/12/16'  then  //2026/06/23
    begin
      If (Ret[RetNo].corptype = CCPC) then
      Begin
         if strings[330] = 'X' then //jz//20260622 - NOT Associated for purposes of for the purpose of calculating SR&ED  //If IsAssociated(RetNo)=false then
         Begin
           Tv[465]:= MaxR(0, 60000000 - Tv[331]); //40000000 //20260903 Alex
           Strings[466]:= FormatFloat('###.##0.00000', Tv[465] / 60000000); //40000000 //20260903 Alex
           Tv[467]:= 6000000 * Vl(Strings[466]); //3000000 //20260903 Alex
           xx:=Tv[467];
           Tv[467]:= minR(6000000, Tv[467]);                //ln 10c part10a //3000000 //20260903 Alex
           xx:= minR(6000000, Tv[467]);                     //ln 10c part10a //3000000 //20260903 Alex

           Tv[423]:= Tv[467];                              //ln 410 part10a
         End
         Else //IS Associated for purposes of for the purpose of calculating SR&ED
         Begin
           Tv[419]:=Vl(FetchElm(RetNo,'S49',9));
           Tv[419]:=minR(3000000,Tv[419]);                //ln 400 part10a

           Tv[423]:=Tv[419];                              //ln 410 part10a
         End;

         if Ret[RetNo].DaysInYear<357 then
         Begin
          Tv[420]:=MaxR(Tv[467],Tv[419]);
          Strings[421] := IntToStr(Ret[RetNo].DaysInYear);
          Tv[422] := RoundCorrect(Tv[420] * Ret[RetNo].DaysInYear/365);

          Tv[423]:=Tv[422];             //ln 410 part10a
         End;
      end     //end part a corptype = CCPC
    end       //end part 10a < '2024/12/16'

    ELSE      //is part 10b - after 2024/12/15
    begin
      if (Ret[RetNo].corptype = CCPC) or (Tv[15] > 0) {or (Ret[RetNo].corptype = ECPC)} then
      begin
         sixMil   := 6000000;   //jz//20260625 - add 6 vs 60 million as vars to better readability
         sixtyMil := 60000000;

         if strings[330] = 'X' then //jz//20260622 - NOT Associated for purposes of for the purpose of calculating SR&ED  //If IsAssociated(RetNo)=false then
         begin
           if Tv[15] > 0 then Tv[20]:= sixtyMil - Tv[15]   //if ln 399 populated then is it ECPC??
                         else Tv[20]:= sixtyMil - Tv[331];
           strings[22]:= FormatFloat('###.##0.00000',Tv[20] / sixtyMil);
           Tv[23]:= vl(strings[22]) * sixMil;
           Tv[23]:= minR(sixMil,Tv[23]); //ln 10c part10b

           Tv[27]:= Tv[23];                //ln 410 part10b
         end
         else   //IS Associated for purposes of for the purpose of calculating SR&ED
         begin
            Tv[24]:= Vl(FetchElm(RetNo,'S49',9));
            Tv[24]:= minR(sixMil,Tv[24]);   //box 400 part10b

            Tv[27]:= Tv[24];                //ln410 part10b
         end;

         if Ret[RetNo].DaysInYear < 357 then
         begin
          Tv[25]:= MaxR(Tv[23], Tv[24]);
          Strings[41]:= IntToStr(Ret[RetNo].DaysInYear);
          Tv[26]:= RoundCorrect(Tv[25] * Ret[RetNo].DaysInYear/365);

          Tv[27]:= Tv[26];                //ln410 part10b
        end;
      end //end part b corptype = CCPC or ECPC
    end; //part 10b
  end; //End with part 10



  //WRONG part10 -->
  {
  //Part 10
  If (Ret[RetNo].corptype = CCPC) then
  Begin
   If IsAssociated(RetNo)=false then
   Begin
    Tv[465]:=MaxR(0,40000000-Tv[331]);
    Strings[466]:=FormatFloat('###.##0.00000',Tv[465]/40000000);
    Tv[467]:=Tv[20] * Vl(Strings[466]); //20260612cz->change not marked, jz updated from file compare
    //Tv[467]:=3000000 * Vl(Strings[466]);
    if Tv[467]>3000000 then Tv[467]:=3000000;
    xx:=TV[467];     
   End
   Else //associated
   Begin
    Tv[465]:=0;
    Strings[466]:='';
    Tv[467]:=0;
    Tv[419]:=Vl(FetchElm(RetNo,'S49',9));
   End;

   if Ret[RetNo].DaysInYear<357 then
   Begin
    Tv[420]:=MaxR(Tv[467],Tv[419]);
    Strings[421] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[422] := RoundCorrect(Tv[420] * Ret[RetNo].DaysInYear/365);
   End
   Else
   Begin
    for i:=420 to 422 do Tv[i]:=0;
   End;
  End
  Else
  begin
   for i:=465 to 467 do Tv[i]:=0;
   for i:=420 to 422 do Tv[i]:=0;
  end;
  Tv[423]:=MaxR(Tv[467],MaxR(Tv[419],Tv[422]));

  //20260501 Alex >>>
  if (Ret[RetNo].corptype = CCPC) then
  begin
    Tv[20]:= 60000000 - Tv[331];
  end
  else
    Tv[20]:= 60000000 - Tv[15];
  Tv[22]:= Tv[20] / 60000000;
  Tv[23]:= Tv[22] * 6000000;

  if Ret[RetNo].DaysInYear < 357 then
  begin
    Tv[25]:= MaxR(Tv[20], Tv[419]);
    Strings[41]:= IntToStr(Ret[RetNo].DaysInYear);
    Tv[26]:= RoundCorrect(Tv[25] * Ret[RetNo].DaysInYear/365);
  end else
  begin
    Tv[25]:= 0;
    Tv[26]:= 0;
    Tv[41]:= 0;
  end;
  Tv[27]:= MaxR(Tv[23], MaxR(Tv[24], Tv[26])); //20260612 // MaxR(Tv[26], MaxR(Tv[20], Tv[419]));
  //20260501 Alex <<<

 end; //End with
 }
 // wrong part 10 <---

  //s31 pg 6 part 11 and 12---------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   For i:=501 to 546 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121
   Tv[501] :=MinR(Tv[307],Tv[27]); //20260612cz //MinR(Tv[307],Tv[423]);
   If Ret[RetNo].CorpType = CCPC then  //20210601
     Tv[502] := RoundCorrect(Tv[501] * 0.35)  //20100911
   Else
     Tv[502] :=0;
   Tv[503] := MaxR(0,TV[307]-TV[27]); //20260612cz //MaxR(0,TV[307]-TV[423]);      //20191116
   Tv[21]  := RoundCorrect(Tv[503]*15/100);

   //20260501 Alex >>>
   Tv[28]:= MaxR(0,Tv[27]-Tv[307]); //20260612cz //MaxR(0, Tv[423] - Tv[307]);
   Tv[29]:= MinR(Tv[19], Tv[28]);
   Tv[30]:= RoundCorrect(Tv[29] * 0.35);
   Tv[31]:= MaxR(0, Tv[19] - Tv[28]);
   Tv[32]:= RoundCorrect(Tv[31] * 0.15);
   //20260501 Alex <<<

   Tv[510] := Tv[309];
   If Tv[510]=0 then begin Tv[511]:=0;Tv[515]:=0;Tv[16]:=0;end;  //20110503

   Tv[512] := RoundCorrect(Tv[511] * 0.35);
   Tv[516] := RoundCorrect(Tv[515] * 0.20);
   Tv[17]  := RoundCorrect(Tv[16]  * 0.15);
   If Ret[RetNo].CorpType <> CCPC then Tv[502] :=0;  //11A Why?
   Tv[517] := Tv[512]+Tv[516]+Tv[17];
   Tv[18] := Tv[517];
   Tv[519] := Tv[502]+Tv[21]+Tv[30]+Tv[32]+Tv[18]; //20260612cz

   {Part 12}
   Tv[523] := Tv[521]+Tv[522];
   Tv[524] := Tv[523];
   Tv[525] := MaxR(0,Tv[520] - Tv[524]);
   Tv[527] := Tv[519];
   Tv[529] := Tv[526]+Tv[527]+Tv[528];
   Tv[530] := Tv[529];
   Tv[531] := Tv[525]+Tv[530];
   Tv[532] := GetMaxItcClaim(RetNo,Tv[531],'RD');
   If Strings[547]>'' then Tv[532] :=Vl(Strings[547]);

   Tv[546]:=Tv[541]+Tv[543]+Tv[545];
   Tv[533] := Tv[546];
   Tv[535] := Tv[532]+Tv[533]+Tv[534];
   Tv[536] := Tv[535];
   Tv[537] := MaxR(0,Tv[531] - Tv[536]);
   TV[538] := MaxR(Tv[615],Tv[624]);
   Tv[539] := MaxR(0,Tv[537]-Tv[538]);
   //page 7
   //part 13
   Yr := GetTaxationYearEndYYYY(RetNo);
   Strings[540]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[542]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[544]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
   Tv[546] := Tv[541]+Tv[543]+Tv[545];
  end; {End with}
  //part 14
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,601,602,603);
   If Strings[604]+Strings[605] ='' then Strings[605] := 'X';
   If UpperCase(Strings[604]+Strings[605]) ='XX' then Strings[605] := '';
   If (UpperCase(Strings[104]) = 'X')
   or (UpperCase(Strings[104]) = 'X') then
   begin
   For i:=606 to 624 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121

   Tv[606] := Tv[527]+Tv[528]; //Tv[537]; //20260620
   Tv[607] := Tv[527]+Tv[528];
   Tv[608] := MinR(Tv[606],Tv[537]);//20260620  //MinR(Tv[606],Tv[607]);
   If UpperCase(Strings[604]) = 'X' then Tv[608] :=RoundCorrect(Tv[608] *0.40);
   Tv[609] := Tv[502];
   Tv[610] := MinR(Tv[608],Tv[609]);
   Tv[611] := MaxR(0,Tv[608] - Tv[610]);
   Tv[612] := Tv[611];
   Tv[613] := RoundCorrect(Tv[612] * 0.40);
   Tv[614] := Tv[610];
   Tv[615] := Tv[613]+Tv[614];
   If UpperCase(Strings[625]) = 'Y' then Tv[615] := Tv[626];
   end
   else
   begin
    for i:=606 to 615 do Tv[i] :=0;
   end;
   //part 15
   If UpperCase(Strings[105]) = 'X' then
   begin
   Tv[616] := Tv[537];
   //20260501 Alex >>>
   Tv[33]:= MinR(Tv[616], Tv[502]);
   Tv[34]:= MaxR(0, Tv[616] - Tv[33]);
   Tv[35]:= MinR(Tv[34], Tv[30]);
   Tv[36]:= Tv[35] * 0.40;
   Tv[37]:= Tv[33];
   Tv[624]:= Tv[36] + Tv[37];
   //20260501 Alex <<<
   //Tv[624] := MinR(Tv[616],Tv[502]);//20260501 Alex //Tv[622]+Tv[623];
   If UpperCase(Strings[627]) = 'Y' then Tv[624] := Tv[628];
   end
   else
   begin
    for i:=616 to 624 do Tv[i] :=0;
   end;
  end; {End with}

  //s31 pg 8 Part 16-------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   //FillHeader(RetNo,FNo,701,702,703);
   Tv[722] :=0;
   For i:=704 to 740 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121
   i:=706;
   Repeat
    Tv[i] := MinR(Tv[i-2],Tv[i-1]);
    Tv[722] := Tv[722]+Tv[i];
    Inc(i,3);
   until i>721;

   i:=723;
   Repeat
    If Tv[i]>100 then Tv[i]:=100;
    Inc(i,3);
   until i>738;
  end; {End with}
  //s31 pg 9 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,801,802,803);

   For i:=804 to 827 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121

   i:=804;
   j:=723;
   Tv[822]:=0;
   Repeat
    Tv[i] := MaxR(0,
              Vl(FetchElmFNo(RetNo,FNo,j))
             * Vl(FetchElmFNo(RetNo,FNo,j+1)) / 100
             - Vl(FetchElmFNo(RetNo,FNo,j+2)));
    Tv[i+2] := MinR(Tv[i],Tv[i+1]);
    Tv[822]:=Tv[822]+Tv[i+2];
    Inc(i,3);
    Inc(j,3);
   until i>819;

   Tv[824] := Vl(FetchElmFNo(RetNo,FNo,722));
   Tv[825] := Tv[822];
   Tv[826] := Tv[823];
   Tv[827]:=Tv[824]+Tv[825]+Tv[826];
  end; {End with}


  //s31 pg 11 ------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,801,8002,8003);


   Tv[1005]:=Tv[1034]+Tv[1004];
   Tv[1006]:=Tv[1005];
   Tv[1007]:=MaxR(0,Tv[1020]-Tv[1006]);
   Tv[1017]:=Tv[1007]+Tv[1008];

   If UpperCase(Strings[1031]) <> 'Y' then
     Tv[1018]:=Tv[1017]
   else
     Tv[1018]:=Tv[1032];
   Tv[1023]:=MaxR(0,Tv[1017]-Tv[1018]);//MaxR(0,Tv[1017]-Tv[1022]); //20201105

  end; //with
  //s31 pg 10 ------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   //20180521
   Strings[1156]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[1157]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[1158]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);

   For i:=1103 to 1162 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121
   i:=1105;
   Tv[1143]:=Tv[1142];
   Repeat
    Tv[i+1]:=RoundCorrect(Tv[i] *10/100);
    Tv[i+2]:=MinR(2000,Tv[i+1]);
    Tv[1143]:=Tv[1143]+Tv[i+2];
    Inc(i,5);
   until i>1135;

   Tv[1145]:=MaxR(0,Tv[1139]-Tv[1138]-Tv[1144]);
   Tv[1147]:=Tv[1143];
   Tv[1167]:= AddColumns(1146,1149,1); //20260501 Alex
   Tv[1168]:= Tv[1167]; //20260501 Alex
   Tv[1150]:=Tv[1145]+AddColumns(1146,1149,1);
   Tv[1162]:=Tv[1159]+Tv[1160]+Tv[1161];
   Tv[1152]:=Tv[1162];

   //20160609
   If UpperCase(Strings[1140]) <> 'Y' then
   Begin
    Tv[1151]:=GetMaxItcClaim(RetNo,Tv[1150],'AP'); //MinR(MaxR(0, Round(Vl(FetchElm(RetNo,'T2', 623))) - OthCredits), Round(Avlbl)); //optimize
   end;

   Tv[1153]:=Tv[1151]+Tv[1152];
   Tv[1154]:=Tv[1153];
   Tv[1155]:=MaxR(0,Tv[1150]-Tv[1154]);
  end; {End with}

  //s31 pg 11 --part 23-----------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,267,268,269);

   //part 23  //20260809
   //20260811 Alex >>>
   //This block have no any sense, because this valuese did not use in any places, but will be rewrite above in code
   {Tv[3]:= TotMultiple(RetNo, 'S74', 62);
   Tv[4]:=Vl(FetchElm(RetNo,'S75',186));
   Tv[5]:=Vl(FetchElm(RetNo,'S76',129));
   Tv[6]:=TotMultiple(RetNo,'S78',154);
   Tv[7]:=Tv[3]+Tv[4]+Tv[6]+Tv[38];
   }
   Tv[3]:= TotMultiple(RetNo, 'S74', 16) + TotMultiple(RetNo, 'S74', 62); //20260811 Alex
   Tv[4]:= Vl(FetchElm(RetNo, 'S75', 186)) + Vl(FetchElm(RetNo, 'S75', 169)); //20260811 Alex
   Tv[5]:= Vl(FetchElm(RetNo, 'S76', 129)) + Vl(FetchElm(RetNo, 'S76', 72)); //20260811 Alex
   Tv[6]:= TotMultiple(RetNo,'S78',154);
   Tv[7]:= Tv[3]+Tv[4]+Tv[5]+Tv[38]+Tv[6]; //20250610 //20260501 Alex //Tv[7]:=Tv[3]+Tv[4]+Tv[5]+Tv[6];
   //20260811 Alex <<<

   For i:=1207 to 1255 do
   begin
    If Tv[i]<0 then Tv[i]:=0;
   end;  //20101121
   i:=1207;
   Tv[1244]:=0;
   Repeat
    Strings[i-2]:=LeftStr(Strings[i-2],30); //20181107
    If Strings[i-3]='' then begin Strings[i-2]:='';Strings[i-1]:='';Tv[i]:=0;end;
    Tv[1244]:=Tv[1244]+Tv[i];
    Inc(i,4);
   until i>1243;
  Tv[1251]:=Tv[1244]+Tv[1246];  ////20100517
  Tv[1253]:=MaxR(0,Tv[1251]-Tv[1252]);
  Tv[1255]:=Tv[1253]+Tv[1254];
  end; {End with}

  //pg12


  //s31 pg 14 ------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   For i:=1301 to 1329 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121
   Tv[1301]:=Tv[1255];
   Tv[1302]:=RoundCorrect(Tv[1301] * 25/100);
   If Tv[1302]=0 then Strings[1303]:='';
   Tv[1304]:=10000 * MyStrToInt(Strings[1303]);
   Tv[1305]:=MinR(Tv[1302],Tv[1304]);

   //part 25 pg 12
   Strings[1323]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[1324]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[1325]:= GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
   Tv[1329]:=AddColumns(1326,1328,1);

   Tv[1309]:=Tv[1307]+Tv[1308];
   Tv[1310]:=Tv[1309];
   Tv[1311]:=MaxR(0,Tv[1306]-Tv[1310]);

   Tv[1313]:=Tv[1305];
   Tv[1315]:=Tv[1312]+Tv[1313]+Tv[1314];
   Tv[1316]:=Tv[1315];
   Tv[1317]:=Tv[1311]+Tv[1316];

   Tv[1319]:=Tv[1329];
   Tv[1320]:=Tv[1318]+Tv[1319];
   Tv[1321]:=Tv[1320];
   Tv[1322]:=MaxR(0,Tv[1317]-Tv[1321]);
  end; {End with}

  //s31 pg 11 ------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1201,1202,1203);
   For i:=1404 to 1467 do begin If Tv[i]<0 then Tv[i]:=0;end;  //20101121
   Tv[1406]:=MinR(Tv[1404],Tv[1405]);
   Tv[1408]:=Tv[1406]+Tv[1407];

   //---------SUMMARY of ITC
  //part 24
  {
   //20250610
   // elm 4 t to 7      i though we are dealing with 23
   Tv[3]:= TotMultiple(RetNo, 'S74', 16);
   Tv[4]:= Vl(FetchElm(RetNo, 'S75', 186));
   Tv[5]:= Vl(FetchElm(RetNo, 'S76', 72));
   Tv[6]:= TotMultiple(RetNo,'S78',154);
   Tv[7]:= Tv[3]+Tv[4]+Tv[5]+Tv[38]+Tv[6]; //20250610 //20260501 Alex //Tv[7]:=Tv[3]+Tv[4]+Tv[5]+Tv[6];
   }

   Tv[1409]:=Vl(FetchElm(RetNo,'S31',827));
   Tv[1410]:=Tv[1408];
   Tv[8]:= Tv[1408];
   //Tv[9]:=Vl(Fet5chElm(RetNo,'S75, ??));
   //Tv[39]:= MinR(Vl(FetchElm(RetNo, 'S74', 62)), Vl(FetchElm(RetNo, 'S74', 71))); //20260501 Alex
   Tv[10]:=Vl(FetchElm(RetNo,'S76', 129)); //20250610
   Tv[1411]:= Tv[1409]+Tv[1410]+Tv[8]+Tv[9]+Tv[10]; //20250607

   //part 25
   Tv[1463]:=Tv[251];
   Tv[1464]:=Tv[532];
   Tv[1465]:=Tv[1018];
   Tv[1466]:=Tv[1151];
   Tv[1416]:=Tv[1318];
   Tv[1467]:=AddColumns(1463,1466,1)+Tv[1416];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S33(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If (IsFedFnclInstitution(RetNo))
   or (IsCooperativeCorp(RetNo))
   or (IsNonResidentInvestmentCorp(RetNo))
   then
   begin
     For i:=5 to 24 do Tv[i] :=0;
     For i:=101 to 122 do Tv[i] :=0; //moved from pg2 below
     SaveTv(RetNo,FName,FNo);
     exit;
   end;
   If Strings[25]='' then Strings[25]:='N';
   If Strings[4]='' then Strings[4]:='N';
   If UpperCase(Strings[4]) = 'Y' then
   begin
    Tv[6] := GetCapitalStock(RetNo);
    Tv[7] := GetRetainedEarnings(RetNo);
    Tv[8] := GetContributedSurplus(RetNo);
    Tv[9] := GetOtherSurpluses(RetNo);
    If Vl(FetchElm(RetNo,'S100',54)) <0 then //Vl(FetchGifiElm(RetNo,'GIFIBS#1','3849')) <0 then
     Tv[19] := ABS(Vl(FetchElm(RetNo,'S100',54)))
   else
     Tv[19] :=0;
   end;

   Tv[16] :=AddColumns(5,15,1);
   Tv[17] :=Tv[16];
   Tv[26]:=Tv[17];  //20160612

 //  Tv[18]:=Vl(FetchGifiElm(RetNo,'S100','3240')); //20160603 not needed  //20130515//Vl(FetchGifiElm(RetNo,'GIFIBS#1','3240')); //20150826
   Tv[22] :=AddColumns(18,21,1);
   Tv[23] := Tv[22];
   Tv[24] := MaxR(0,Tv[26]-Tv[23]); // MaxR(0,Tv[17]-Tv[23]);  //20160612


  end; {End with}
  //S33 pg2 --------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[108] :=AddColumns(101,107,1);

   Tv[109] := Vl(FetchElm(RetNo,'S33',24));
   Tv[110] := Tv[108];
   Tv[111] := MaxR(0,Tv[109]-Tv[110]);

   If IsCorpResident(RetNo) then
   begin
    Tv[112] := Tv[111];
    Tv[113] := GetTxblIncome(RetNo)
             -Vl(FetchElm(RetNo,'S5',263));  {should be only cdn txbl inc}
    Tv[122] := GetTxblIncome(RetNo);
    If Tv[122] <=0 then
    begin
     Tv[113]:=1000;
     Tv[122]:=1000;
    end;
    Tv[114] := Tv[112] * Tv[113] /Tv[122];
    For i:=115 to 119 do Tv[i] :=0;Tv[120]:=0;
   end
   else
   begin
    For i:=112 to 114 do Tv[i]:=0;
    Tv[122] :=0;
    Tv[117] := Tv[115]+Tv[116]+Tv[121];
    Tv[118] := Tv[117];
    Tv[119] := MaxR(0,Tv[120]-Tv[118]);
   end;
  end; {End with}
  //S33 pg3 --------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
    //part 5
    Tv[204]:=MaxR(0,Tv[206]-Tv[205]);
    Tv[201]:=Tv[204]* 0.00225;
  end;
  SaveTv(RetNo,FName,FNo);

end;

procedure S34(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If (Not IsFedFnclInstitution(RetNo))
   or (IsInsuranceCorp(RetNo) = True)
   or (IsLifeInsuranceCorp(RetNo) = True)
   then
   begin
     For i:=5 to 21 do Tv[i]:=0;

     For i:=101 to 114 do Tv[i]:=0; //moved from page 2 below

     SaveTv(RetNo,FName,FNo);
     exit;
   end;

   FillHeader(RetNo,FNo,1,2,3);

   Tv[7] := GetCapitalStock(RetNo);
   Tv[8] := GetRetainedEarnings(RetNo);
   Tv[9] := GetContributedSurplus(RetNo);
   Tv[10] := GetOtherSurpluses(RetNo);
   Tv[11] := 0; For i:=5 to 10 do Tv[11] := Tv[11]+Tv[i];
   Tv[12] := Tv[11];
   Tv[16] := Tv[13]+Tv[14]+Tv[15];
   Tv[17] := Tv[16];
   Tv[18] := MaxR(0,Tv[12]-Tv[17]);

   Tv[21] := Tv[19]+Tv[20];

   If IsForeignAuthorizedBank(RetNo) then
    for i:=5 to 18 do Tv[i]:=0
   else
    for i:=19 to 21 do Tv[i]:=0

  end; {End with}
  //S34 pg2 --------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin

   Tv[111]:=Tv[109]+Tv[110];

   If IsNonResidentCorp(RetNo)=True then  for i:=109 to 111 do Tv[i]:=0;

   If isForeignAuthorizedBank(RetNo) then
    Tv[112]:=Vl(FetchElm(RetNo,'S34',21))
   else
    Tv[112]:=Vl(FetchElm(RetNo,'S34',18));

   Tv[113] := Tv[111];
   Tv[114] := MaxR(0,Tv[112]-Tv[113]);


   Tv[103] := Tv[114];
   If Tv[104]=0 then Tv[104]:=Vl(FetchElm(RetNo,'S100',89)); //Vl(GetGifiValFromMem(RetNo,GetFormNo('GIFIBS#1'),'2599')); //20150826
   If Tv[106]=0 then Tv[106]:=Tv[104];
   If Tv[106] >0 then Tv[107] := Tv[103] * Tv[104]/Tv[106] else Tv[107]:=0;
   Tv[108] := Tv[101]+Tv[102]+Tv[107];
   //part 5
   Tv[115]:=MaxR(0,Tv[133]-Tv[132]);
   Tv[105]:= Tv[115]* 0.00225;
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;


(*
//20170525
procedure S37(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
   LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,35);
   Tv[12] := MaxR(0,Tv[10] - Tv[11]);
   Tv[14] := Tv[12]+Tv[13];
   {tv[17] :=?}
   //carry back
   Tv[22] := MaxR(0,Tv[14]-Tv[17]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)

procedure S39(RetNo: integer;FName: string;FNo: integer);
Var i:integer;x:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Strings[4] := GetCorpName(RetNo);
   Strings[5]:= GetAccountNumber(RetNo);

   i:=6; x:=0;
   Tv[99]:=0;  //20100823 =Tv[7];
   Repeat
    Tv[99]:=Tv[99]+Tv[i+1];
    Inc(i,4);
   until i>94;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S41(RetNo: integer;FName: string;FNo: integer);
Var i:integer;x:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If Strings[4] = '' then
     Strings[4] := IntToStr(GetTaxationYearEndYYYY(RetNo));
   If Strings[2]+Strings[3] = '' then Strings[3] := 'X';
   Strings[5] := GetCorpName(RetNo);
   Strings[6] := GetAccountNumber(RetNo);
   x:=AddColumns(11,75,4);
   Tv[7] := 400000000 - x;
   Tv[77] := Tv[7]+x;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S42(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  FillHeader(RetNo,FNo,1,2,3);

  Tv[28] := Tv[24]+Tv[26]+Tv[27];

  Tv[13] := MaxR(0,Tv[11]-Tv[12]);
  Tv[15] := Tv[13]+Tv[14];
  Tv[17] := MaxR(0,Tv[15]-Tv[16]);
  Tv[18] := Vl(FetchElm(RetNo,'S38',325));
  Tv[19] := Tv[17]+Tv[18];
  Tv[20] := Tv[28];
  Tv[21] := MaxR(0,Tv[19]-Tv[20]);

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S43(RetNo: integer;FName: string;FNo: integer);
Var i:integer; x:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If strings[8]+Strings[9]='' then Strings[9]:='X';
   If Strings[10]='' then Strings[10]:= IntToStr(GetTaxationYearEndYYYY(RetNo));
   If Tv[4]>500000 then Tv[4]:=500000;
   Tv[66]:=1000000;
   Tv[5]:=MaxR(0,Tv[65]-Tv[66]);
   Tv[67]:=Tv[5];
   Tv[6]:=MaxR(0,Tv[4]-Tv[5]);


    Strings[11]:=GetCorpName(RetNo);
    Strings[12]:=GetCorpBusNo(RetNo);
    Strings[14]:=GetTaxationYearEnd(RetNo);
    Tv[63]:=Tv[6];
    i:=17;
    x:=0;
    repeat
     x:=x+Tv[i];
     Inc(i,4);
    until i>61;
    Tv[13]:=MaxR(0,Tv[63]-x);
  end; {End with}
  //S43 pg2---------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   If TV[13] >0 then // Vl(FetchElm(RetNo,'S43',13))>0 then  //20190421
    Tv[101]:=Tv[13] //Vl(FetchElm(RetNo,'S43',13))
   else
    Tv[101]:=Tv[65]; //Vl(FetchElm(RetNo,'S43',65));
   Tv[101] := Tv[101] * Ret[RetNo].DaysInYear/365;
   Tv[103] := MinR(Tv[101],Tv[102]);
   Tv[104] := MaxR(0,Tv[102]-Tv[103]);
   //20130830
   //Strings[14]:='40';
   //If GetTaxationYearEndYYYY(RetNo) <2010 then Strings[14]:='50';
   //If (GetTaxationYearEndYYYY(RetNo) >2009) and (GetTaxationYearEndYYYY(RetNo)<2012) then Strings[14]:='45';

   Tv[105] := Round(Tv[104] * 0.40); //Vl(Strings[14])/100;
   //tv[32]:=?
   Tv[106] := Tv[101];
   Tv[107] := Tv[103];
   Tv[108] := MaxR(0,Tv[106]-Tv[107]);
   //Tv[133] := MinR(Tv[132],Tv[108]);
   Tv[109] := MinR(Tv[132],Tv[108]);
   Tv[110] := MaxR(0,Tv[132]-Tv[109]);
   Tv[111] := Tv[110]*0.40;
   Tv[113]:=Tv[101];
   Tv[114]:=Tv[103];
   Tv[115]:=Tv[109];
   Tv[134]:=Tv[114]+Tv[115];
   Tv[135]:=Tv[134];
   Tv[116]:=MaxR(0,Tv[113]-Tv[135]);
   Tv[117]:=MinR(Tv[112],Tv[116]);
   Tv[118]:=MaxR(0,Tv[112]-Tv[117]);
   Tv[119]:=Round(Tv[118]*0.25);

   Tv[122]:=Tv[105]+Tv[111]+Tv[119]+Tv[120];
   Tv[124]:=MaxR(0,Tv[122]-Tv[121]);

   //pg3
   Tv[127]:=Tv[125]+Tv[126];
   //Tv[129]:=Tv[127];
   Tv[130]:=Round(Tv[129]*0.10);  //10/100;
   Tv[22]:=Round(Tv[18]*0.30);
   Tv[30]:=Round(Tv[26]*0.10);
   Tv[131]:=Tv[22]+Tv[30];
   Tv[38]:=Round(Tv[34] * 0.10);
   Tv[42]:=MaxR(0,Tv[131]-Tv[38]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

procedure S44(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S45(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Strings[3]:=GetCorpName(RetNo);
   Strings[4]:=GetCorpBusNo(RetNo);
   Strings[5]:=GetTaxationYearEnd(RetNo);
   Tv[46]:=0;
   i:=8;
   Repeat
    If (Strings[i]='') and (strings[i-2]>'') then Strings[i]:=GetTaxationYearEnd(RetNo);
    Tv[46]:=Tv[46]+Tv[i+1];
    Inc(i,4);
   until i>44;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S46(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  FillHeader(RetNo,FNo,1,2,3);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S49(RetNo: integer;FName: string;FNo: integer);
Var i,j,S23FNo:integer; ExpLimit,BoxA,BoxB,BoxC,BoxD,x,y: real; //MaxAmount:Real;
AA,BB,EE,FF:Real;
begin

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    {copy from S23}
    Strings[1]:='';
    If Strings[2]='' then Strings[2]:= IntToStr(GetTaxationYearEndYYYY(RetNo));

   {chg to non-ccpc}
    i:=7;
    repeat
     If Strings[i] = '' then Strings[i] := '1';
     If (Strings[i] = '2') or (Strings[i]='5') then Strings[i] :='1';
     If (Strings[i] = '3') or (Strings[i]='4') then Strings[i] :='2';
     If (Strings[i] > '5') or (strings[i]<'1') then Strings[i] :='2';
     If strings[i-2]='' then Strings[i]:='';
     Inc(i,6);
    until i>121;

    Tv[125] := AddColumns(8,122,6);
   // If Tv[132]>40000000 then Tv[132]:=40000000;
   // Tv[130]:=Tv[125];
   // If GetTaxationYearStart(RetNo) >'2008/02/26' Then Tv[130]:=0;  //20100501 //lm 475
    BoxA:=Tv[128];  If BoxA>500000 then BoxA:=500000;
    BoxB:=Tv[129];If BoxB<0 then BoxB:=0; If BoxB>40000000 then BoxB:=40000000;
    {
    BoxC:=Tv[130];
    BoxD:=Tv[132];
    }
   //2019 1019
   ExpLimit:=Round(3000000 * (MaxR(0,40000000-BoxB)/40000000));
   If GetTaxationYearEnd(RetNo) < '2019/03/19' then
     ExpLimit:=Round(MaxR(0,(8000000 - 10 * BoxA) * (MaxR(0,40000000-BoxB))/40000000));

   {only ccpc}
    i:=9;
    Repeat
     If Strings[i-2] <> '1' then Tv[i] :=0;
     Inc(i,6);
    until i>123;

    //20100501
    Tv[129]:=BoxB;

    i:=9;
    x:=0;
    Repeat
     x:=x+Tv[i];
     Inc(i,6);
    until i>123;
    ExpLimit:=x;
    Tv[127]:=ExpLimit;
    Tv[126] := ExpLimit; //,123,6);  //20100501
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S50(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   //add %
   i:=7;
   Tv[130]:=0;Tv[131]:=0;
   Repeat
    Strings[I-2]:=FixBusinessNumberMissingRC(Strings[I-2]);//20190822 //20190820  BN
    Tv[130]:=Tv[130]+Vl(Strings[i]);
    Strings[130]:=FormatFloat('####.##',Tv[130]);
    Tv[131]:=Tv[131]+Vl(Strings[i+1]);
    Strings[131]:=FormatFloat('####.##',Tv[131]);
    Inc(i,5);
   until i>127;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



//20260522 Itseems to have changes /logic of the 2026B form but it is the T2-2026 base logic
//It screed up the T2-2026
Procedure T661(RetNo:integer;FName:string;FNo:integer);
Type
  AProjectRec = Record
  //Title     : String[60];
  Title     : String;//[60]; //20150701
end;
Var i,j,k,S60FNo:integer;x:Real;
  ProjectRec: Array[1..148] of AProjectRec;  //20190512
  //ProjectRec: Array[1..14] of AProjectRec;  //1..10  //20130713
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    //pg1
   FillHeader(RetNo,FNo,1,2,3);
   FillHeader(RetNo,FNo,321,324,323);  //20111125
   Strings[322] := GetBegYearEnd(RetNo); //GetAccountNumber(RetNo);
   Strings[325]:='';Strings[326]:=''; //T1 and TF
   Strings[327]:=IntToStr(GetT661Numprojects(RetNo));
   If Strings[328] = '' then
   begin
    If FetchElm(RetNo,'T2',749)>'' then
     Strings[328]:=FetchElm(RetNo,'T2',749)
    else
     Strings[328] := FetchElm(RetNo,'T2',743)+ ' '+FetchElm(RetNo,'T2',742); {contact}
   end;
   If Strings[329] = '' then
   begin
    If FetchElm(RetNo,'T2',756)>'' then
    begin
     Strings[329]:=FetchElm(RetNo,'T2',756);
     Strings[310]:=FetchElm(RetNo,'T2',750);
    end
    else
    begin
     Strings[329] := FetchElm(RetNo,'T2',755);
     Strings[310] := FetchElm(RetNo,'T2',746);
    end;
   end;

   If Strings[333]='' then Strings[333]:=Strings[328];
   If Strings[334]='' then Strings[334]:=Strings[329];
   If Strings[312]='' then Strings[312]:=Strings[310];

   Strings[338]:=''; Strings[339]:='';
   For i:=340 to 369 do begin Strings[i]:='';Tv[i]:=0;end;

   //pg 4
   If Strings[104]+Strings[105]='' then Strings[104]:='X';
   Tv[108]:=Tv[106]+Tv[107];
   If Strings[104]>'' then Tv[119]:=0;
   Tv[120]:= TotMultiple(RetNo,'S30',3);

   if Strings[105]>'' then Tv[118]:=0;     //if traditional 20210519
   if Strings[104]>'' then Tv[119]:=0;     //if proxy no overhead 20210519


   Tv[121]:=Tv[108]+Tv[109]+Tv[110]
       +Tv[111]+Tv[113]+Tv[114]+Tv[115]+Tv[116]+TV[117]+Tv[118]+Tv[119]+Tv[120]; //20260520

   Tv[142]:=Tv[121]+Tv[139]; //20260520
   //-----------------------------
   Tv[124]:=TV[142]; // 20260612cz Tv[121]; //Tv[123];   //20201111

   Tv[122]:=Vl(FetchElm(RetNo,'AS29',27)); //20250622B//Vl(FetchElm(RetNo,'AT1',74));
   //20251125 put back but wrong for final fed purposes  but fine for alb.
   //20251120 stopped

  // If Tv[123]=0 then Tv[125]:=0;
   Tv[130]:=Tv[124]-(Tv[125]+Tv[126]+Tv[127]+Tv[128]+Tv[129]); //+Tv[122]);  //20260620 remove 122
   //Tv[130]:=Tv[124]-(Tv[125]+Tv[126]+Tv[127]+Tv[128]+Tv[129]);
   x:=AddColumns(130,134,1);
   If x>0 then begin Tv[135]:=x;Tv[391]:=0; end
    else begin Tv[135]:=0;Tv[391]:=ABs(X); end;
   If Strings[370]='' then Strings[370]:='N';
   If UpperCase(Strings[370]) ='N' then Tv[136]:=Tv[135];
   If Tv[136]<0 then Tv[136]:=0;
   Tv[137]:=MaxR(0,Tv[135]-Tv[136]);

   //pg 5
   Tv[138]:=Tv[121];
  // Tv[139]:=Tv[122];
   If Strings[371]='' then Strings[371]:='N';
   If UpperCase(Strings[371]) ='N' then Tv[141]:=Tv[290];
   If Strings[105]>'' then Tv[141]:=0;  //trad method
   Tv[143]:=TotMultiple(RetNo,'T1146',2);
   Tv[144]:=Tv[139]; //20260612cz  Tv[144]:=TotMultiple(RetNo,'T1146',3);
   Tv[145]:=Tv[138]+Tv[140]+Tv[141]+Tv[143];
   Tv[150]:=Tv[144]+Tv[146]+Tv[148];  //20260522CZ
   //-------------------------------------------
   Tv[159]:=TotMultiple(RetNo,'T1145',2);
   Tv[161]:=Tv[116];

   if UpperCase(Strings[13])<>'Y' then    //20201023
      Tv[13]:=RoundCorrect((Tv[115]+Tv[120])*20/100);  //20170603
   //20260522
   //20260722 Not negative
   Tv[331]:=MaxR(0,Tv[145]-Tv[147]-Tv[149]-Tv[151]
                   -Tv[153]-Tv[154]-Tv[13]-Tv[155]
                  -Tv[157]-Tv[159]-Tv[161]-Tv[162]-Tv[164]);

   Tv[330]:=Tv[150]-Tv[152]-Tv[156]-Tv[158]
                   -Tv[160]-Tv[163]-Tv[163]-Tv[165]
                   -Tv[166]-Tv[167];
   Tv[168]:=Tv[331]+Tv[330];
   Tv[170]:=Tv[168]+Tv[169];

   //pg 6
   If Strings[105] >'' then  //traditional method
   begin
    For i:=171 to 290 do begin Strings[i]:='';Tv[i]:=0;End;
   end
   Else
   begin
    Tv[171]:=Tv[106]+Tv[109];
    Tv[173]:=MaxR(0,Tv[171]-Tv[172]);

    //202600301
    If Tv[309]=0 then Tv[309]:=71300;
    If GetTaxationYearEndYYYY(RetNo) = 2023 then Tv[309] := 66600 //20200922
    else If GetTaxationYearEndYYYY(RetNo) = 2024 then Tv[309] := 68500 //20200922
    else If GetTaxationYearEndYYYY(RetNo) = 2025 then Tv[309] := 71300 //20200922
    else If GetTaxationYearEndYYYY(RetNo) >= 2026 then Tv[309] := 74600; //20260522
     //20110302
    i:=176;
    j:=372; //days
    Tv[320]:=0;
   // Tv[288]:=0;
    Repeat
     If Vl(Strings[i])>75 then Strings[i]:='75';
     Tv[i+1]:=RoundCorrect(Tv[i-1] * Vl(Strings[i])/100);
     Tv[i+2]:=RoundCorrect(2.5 * Tv[309] * Vl(Strings[j])/365);
     Tv[i+3]:=MinR(Tv[i+1],Tv[i+2]);
     Tv[320]:=Tv[320]+Tv[i+3];
     Inc (i,6);
     Inc(j,1);
    until i>284;
    Tv[288]:=Tv[320];
    Tv[289]:=Tv[173]+Tv[288];
    Tv[290]:=RoundCorrect(Tv[289] * 55/100);  //20201111
   end;

   //project cost details
    k:=1;   //array index
    for i :=0 to (FList.Count - 1) do
    begin
     FRec := FList.Items[i];
     If Frec.FormName='S60' then   //20150703
     begin
      If Ret[RetNo].FrmHasData[Frec.FormNo] then
      begin
       ProjectRec[k].Title:=FetchElmFNo(RetNo,Frec.FormNo,4);
       Inc(k,1);
       If K>48 then break;  //20190512//If K>14 then break;   //10  //20130713
      end;
     end;
    end;

   //20190512 totals
   For i:=315 to 317 do Begin Tv[i]:=0;end;
   //Tv[858]:=0; //tot leases  //20260520
   Tv[319]:=0;Tv[326]:=0;
   k:=1;
   j:=601;
   i:=401;
   //jj:=710; //lease column
   Repeat
      Strings[i]:=ProjectRec[k].Title;
      Tv[315]:=Tv[315]+Tv[i+1];
      Tv[316]:=Tv[316]+Tv[i+2];
      Tv[317]:=Tv[317]+Tv[i+3];
      Tv[319]:=Tv[319]+Tv[j];
      //Tv[858]:=Tv[858]+Tv[jj];
      Inc(i,4);
      Inc(j,1);
      Inc(k,1);
     // Inc(jj,1);   //20260520
   until i>589;  //20190512 437;  //20130713//until i>453;  //437;  //20130713

   Tv[858]:= AddColumns(710, 726, 1); //20260522 Alex
   Tv[858]:= Tv[858] + AddColumns(827, 857, 1); //20260522 Alex


   If Vl(Strings[327])>48 then Strings[589]:='All other projects';   //20190512
   //If Vl(Strings[327])>14 then Strings[453]:='All other projects';   //20130713

   //20181119
    Tv[595]:=Tv[108]+Tv[109]+Tv[110]+Tv[111];
    Tv[596]:=Tv[113]+Tv[114];
    Tv[597]:=Tv[115]+Tv[116];
    Tv[326]:=Tv[119];  //20201111
    {
    Tv[485]:=Tv[108]+Tv[109]+Tv[110]+Tv[111];
    Tv[486]:=Tv[113]+Tv[114];
    Tv[487]:=Tv[115]+Tv[116];
    }

    //20181119
    If Vl(Strings[327])=1 then
    begin
     //20130713
     Tv[402]:=Tv[595]; //TV[485];
     Tv[403]:=Tv[596]; ////Tv[486];
     Tv[404]:=Tv[597]; //Tv[487];
    end;

   //pg 7
   Tv[291]:=MaxR(0,Tv[121]-Tv[109]-Tv[110]-Tv[115]-Tv[116]-Tv[120]);  //20210716  //form change

    //20130829
   //PART 9
   If Strings[16]+Strings[17]='' then Strings[17]:='X';
   Tv[102]:=0;
   i:=18;
   Repeat
    If  Strings[17]>'' then Strings[i]:=''; //no entries
    Strings[i+3]:=RemoveChar(Strings[i+3],',');   //20171106
    Strings[i+4]:=LeftStr(Strings[i+4],60);   //20140602
    If Strings[i]='' then
    Begin
     Strings[I+1]:='';
     Strings[I+2]:='';
     Strings[I+3]:='';
     Strings[I+4]:='';
     Tv[i+5]:=0;
    end;
    Tv[102]:=Tv[102]+Tv[i+5];
    Inc(i,6);
   until i>96;
   If Strings[314]='' then Strings[314]:=FetchElm(RetNo,'T2',745);
   If Strings[103]='' then Strings[103]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); {signing}

   If Strings[306]='' then Strings[306]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); {signing}
   If Strings[308]='' then Strings[308]:=Strings[306];

   If Strings[307]='' then Strings[307] :=FetchElm(RetNo,'T2',745);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure S30(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure T661F(RetNo:integer;FName:string;FNo:integer);
Var i,Cnt1,Cnt2:integer;
begin
  LoadTv(RetNo,FName,FNo);
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
   Strings[2]:=IntToStr(Cnt2);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S27RATE(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Tv[4]:=Vl(FetchElm(RetNo,'S27',216));
    Tv[5]:=Vl(FetchElm(RetNo,'S27',224));
    Tv[6]:=MinR(Tv[4],Tv[5]);

    Tv[7]:=Tv[6];
    Strings[8]:= IntToStr(GetNumDays(RetNo,'31-12-2006','A')-GetNumDays(RetNo,'31-12-2007','A'));
    Strings[9]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[10]:=Tv[7] * (Vl(Strings[8])/Ret[RetNo].DaysInYear) * 0.07;


    Tv[11]:=Tv[6];
    Strings[12]:= IntToStr(GetNumDays(RetNo,'31-12-2007','A')-GetNumDays(RetNo,'31-12-2008','A'));
    Strings[13]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[14]:=Tv[11] * (Vl(Strings[12])/Ret[RetNo].DaysInYear) * 8.5/100;

    Tv[15]:=Tv[6];
    Strings[16]:= IntToStr(GetNumDays(RetNo,'31-12-2008','A')-GetNumDays(RetNo,'31-12-2009','A'));
    Strings[17]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[18]:=Tv[15] * (Vl(Strings[16])/Ret[RetNo].DaysInYear) * 0.09;

    Tv[19]:=Tv[6];
    Strings[20]:= IntToStr(GetNumDays(RetNo,'31-12-2009','A')-GetNumDays(RetNo,'31-12-2010','A'));
    Strings[21]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[22]:=Tv[19] * (Vl(Strings[20])/Ret[RetNo].DaysInYear) * 0.10;

    Tv[23]:=Tv[6];
    Strings[24]:= IntToStr(GetNumDays(RetNo,'31-12-2010','A')-GetNumDays(RetNo,'31-12-2011','A'));
    Strings[25]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[26]:=Tv[23] * (Vl(Strings[24])/Ret[RetNo].DaysInYear) * 11.5/100;

    Tv[27]:=Tv[6];
    Strings[28]:= IntToStr(GetNumDays(RetNo,'31-12-2011','A'));
    Strings[29]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[30]:=Tv[27] * (Vl(Strings[28])/Ret[RetNo].DaysInYear) * 0.13;

    Tv[31]:=Tv[10]+Tv[14]+Tv[18]+Tv[22]+Tv[26]+Tv[30];
  end;
  SaveTv(RetNo,FName,FNo);
end;

procedure S27(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    If Strings[22]='' then strings[22]:='N';
    If Strings[20] ='' then Strings[20] :='N';
    //Tv[4] := MaxR(0,Vl(FetchElm (RetNo, 'S7', 163))); //20180616 //20160609 from hidden box
    Tv[4] := MaxR(0,Vl(FetchElm (RetNo, 'S7', 162)));
    Tv[4]:=MaxR(0,Tv[4]);
    Tv[5]:=MaxR(0,Tv[5]);
    Tv[6] := Tv[4] + Tv[5];
    If Tv[6] >200000 then Strings[20] :='N';

    If IsFedFnclInstitution(RetNo) then Strings[20] :='N';

    If UpperCase(Strings[20])='Y' then begin Tv[13]:=0;Tv[19]:=0;end;  //20140913  //if small manufcturer

    If UpperCase(Strings[20]) <> 'Y' then
    begin
     Tv[4]:=0;Tv[5]:=0;Tv[6]:=0;
     Tv[7] := Tv[19];
     Tv[8] := Vl(FetchElm(RetNo,'S27',114));
     Tv[9] := Vl(FetchElm(RetNo,'S27',204));
     Tv[10] := Vl(FetchElm(RetNo,'S27',111));
     Tv[11] := Vl(FetchElm(RetNo,'S27',136));
     If Tv[10]+Tv[11]>0 then
       Tv[12] := Tv[7] * (Tv[8]+Tv[9])/(Tv[10]+Tv[11])
     else
       Tv[12] :=0;

     Tv[13] := MaxR(0,Vl(FetchElm (RetNo, 'S7', 162)));
     If UpperCase(Strings[20])='Y' then Tv[13]:=0;  //20140913  //if small manufcturer
     Tv[14] := Vl(FetchElm(RetNo,'S27',212));
     Tv[43]:=MaxR(0,Tv[14]-Tv[42]);
     Tv[17] :=Tv[43]+Tv[15]; // Tv[14]+Tv[15]+Tv[16];
     Tv[18] := MaxR(0,Tv[17]);
     Tv[19] := MaxR(0,Tv[13] - Tv[18]);
    end;
  end; {End with}

  //S27 pg 2--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   {C}
   Tv[107]:=0; For i:=101 to 106 do Tv[107]:=Tv[107]+Tv[i];
   Tv[108] := Tv[107] * 0.10;
   Tv[111] := Tv[108]+Tv[109]+Tv[110];

  {MC}
   Tv[112] := Tv[111];
   Tv[114] := Tv[113] * (100/85);
   If Tv[114] > Tv[112] then Tv[114] := Tv[112];

   {L}
   Tv[44] := Tv[116]+Tv[117]+Tv[118]+Tv[119];
   Tv[120]:= Tv[44]; //Tv[116]+Tv[117]+Tv[118]+Tv[119]; //20140608

   Tv[121] := MaxR(0,Tv[115]-Tv[120]);
   Tv[123] := Tv[121]+Tv[122];
   Tv[45] := Tv[124]+Tv[125]+Tv[126];   //20140608
   Tv[127] :=Tv[45]; // Tv[124]+Tv[125]+Tv[126];

   Tv[132]:=0; For i:=128 to 131 do Tv[132]:=Tv[132]+Tv[i];
   Tv[133] := MaxR(0, Tv[127]-Tv[132]);
   Tv[135] := Tv[133] + Tv[134];
   Tv[136] := Tv[123] + Tv[135];
  end; {End with}

  //S27 pg 3--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[203] := Tv[201] +Tv[202];
   Tv[204] := Tv[203] * (100/75);
   If Tv[204] > Vl(FetchElm(RetNo,'S27',136)) then
     Tv[204] :=Vl(FetchElm(RetNo,'S27',136));

   {part 8}
   Tv[207] := Tv[205]+Tv[206];
   Tv[210] := Tv[208]+Tv[209];
   Tv[211] := Tv[210];
   Tv[212] := MaxR(0,Tv[207] - Tv[211]);

   {part 9}
   If UpperCase(FetchElm(RetNo,'S27',20)) = 'Y' then
    Tv[213] := Vl(FetchElm(RetNo,'S27',4))
   else
    Tv[213] := Vl(FetchElm(RetNo,'S27',12));

    If Ret[RetNo].CorpType = CCPC then
     Tv[214] := GetIncForSmBusDed(RetNo)
    else
      Tv[214] :=0;

    Tv[215] := MaxR(0,Tv[213]-Tv[214]);
    Tv[216] :=Tv[215];
    Tv[217] :=GetTxblIncome(RetNo);
    Tv[218] := GetIncForSmBusDed(RetNo);
    If Ret[RetNo].CorpType = CCPC then
     Tv[219] := Vl(FetchElm(RetNo,'T2',504))
    else
     Tv[219] :=0;
    Tv[220] :=Vl(FetchElm(RetNo,'T2',631));

    Strings[229]:='4';  //20160612
    {
    If GetTaxationYearEndYYYY(RetNo) < 2003 then
     strings[229]:='2.5'
    else
     Strings[229]:='3';
    }
    Tv[221] := Tv[220] * Vl(Strings[229]);  // /4 wrong s/b 10/4;
    Tv[222] := Tv[218]+tv[219]+Tv[221];
    Tv[223] := Tv[222];
    Tv[224] :=MaxR(0,Tv[217]-TV[223]);

    Tv[38]:=MinR(Tv[216],Tv[224]);
    Strings[39]:= IntToStr(GetNumDays(RetNo,'31-12-2011','A'));
    Strings[40]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[41]:=Tv[38] * (Vl(Strings[39])/Ret[RetNo].DaysInYear) * 0.13; //20140530
   // Tv[227]:=Tv[41];  //20221203
   //  Tv[227]:=Vl(FetchElm(RetNo,'S27RATE',31));
    If UpperCase(FetchElm(RetNo,'S27',314))='Y' then
      Tv[228]:=vl(FetchElm(RetNo,'S27',417))
    else
      Tv[228]:=0;
    Tv[23]:=Tv[53];  //20221203
    Tv[225]:=Tv[41]+Tv[228]+Tv[23]; //20221203 //Tv[227]+Tv[228];
  end; {End with}

  //S27 pg 4--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   If IsElectricalGenerator(RetNo) = False then
   begin
    For i:=301 to 323 do begin Strings[i]:='';Tv[i] :=0;end;
    For i:=401 to 417 do begin Strings[i]:='';Tv[i] :=0;end; //from pg 5
  //  SaveTv(RetNo,FName,FNo);  //202306162
  //  exit;
  end
  Else
  Begin
   Tv[307]:= Vl(FetchElm(RetNo,'S27',111));
   If Tv[308]>Tv[307] then Tv[308]:=Tv[307];
   Tv[309]:=Tv[308] * 100/85;

   Tv[312]:=Tv[310]+Tv[311];
   Tv[313]:=Tv[312] * 100/75;

   //MPA cal;culation
   Tv[301]:=Vl(FetchElm(RetNo,'S27',19));
   Tv[302]:=Tv[309];
   Tv[303]:=Vl(FetchElm(RetNo,'S27',111));
   Tv[304]:=Tv[313];
   Tv[305]:=Vl(FetchElm(RetNo,'S27',136));
   If Tv[303]+Tv[305]>0 then
    Tv[306]:=Tv[301] * (Tv[302]+Tv[304])/(Tv[303]+Tv[305])
   else
    Tv[306]:=0;
   End;
  end; {End with}

  //S27 pg 5--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[401]:=Vl(FetchElm(RetNo,'S27',306));
   If Ret[RetNo].CorpType = CCPC then
   begin
    Tv[402]:=GetIncForSmBusDed(RetNo);
   end
   else
    Tv[402]:=0;
   Tv[403]:=MaxR(0,Tv[401]-Tv[402]);
   Tv[404]:=Tv[403];
   Tv[405]:=GetTxblIncome(RetNo);
   Tv[406]:=GetIncForSmBusDed(RetNo);
   If Ret[RetNo].CorpType = CCPC then
     Tv[407] := Vl(FetchElm(RetNo,'T2',504))
   else
     Tv[407]:=0;
   Tv[408]:=Vl(FetchElm(RetNo,'T2',631));
   Tv[409]:=Tv[408] * 3;
   Tv[410]:=Tv[406]+Tv[407]+Tv[409];
   Tv[411]:=Tv[410];
   Tv[412]:=MaxR(0,Tv[405]-Tv[411]);
   Tv[413]:=MinR(Tv[404],Tv[412]);
   Tv[414]:=MinR(Vl(FetchElm(RetNo,'S27',216)),Vl(FetchElm(RetNo,'S27',224)));
   Tv[415]:=MaxR(0,Tv[413]-Tv[414]);
   Tv[416]:=Tv[415];

   Tv[62]:=Tv[416];
   Strings[63]:= IntToStr(GetNumDays(RetNo,'31-12-2011','A'));
   Strings[64]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[65]:=Tv[62] * (Vl(Strings[63])/Ret[RetNo].DaysInYear) * 0.13;
   Tv[417]:=Tv[65]; //Tv[416] * 7/100;  //20140608
  end; //with

   //PAGE 7
   //PART 14 ZETM
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[24]:=Tv[19];

   Tv[56]:=Tv[16];
   Tv[58]:=Tv[111];
   Tv[57]:=Tv[21];
   Tv[59]:=Tv[136];
   if Tv[58]+Tv[59]>0 then
     Tv[25]:=round(Tv[56]+Tv[57])/(Tv[58]+Tv[59])
   Else
     Tv[25]:=0;

   Tv[60]:=Tv[111];
   Tv[61]:=Tv[16];
   Tv[62]:=Tv[136];
   Tv[63]:=Tv[21];

   if Tv[25]>=0.9 then
   Begin
   if Tv[61]+Tv[63]>0 then
    Tv[26]:=round((Tv[60]+Tv[62])/(Tv[61]+Tv[63]))
   Else
    Tv[26]:=0;
   End
   Else
    Tv[26]:=1;

   //part 15
   Tv[27]:=Round((Tv[24] * Tv[25]) * Tv[26]);
   Tv[28]:=Tv[111];
   Tv[16]:=Round(Tv[113]*100/85);
   if Tv[16]>Tv[28] then Tv[16]:=Tv[28];

   //part 16
   Tv[64]:=Tv[30]+Tv[31];
   Tv[21]:= Round(Tv[64]*100/75);
   if Tv[21]>Tv[136] then Tv[21]:=Tv[136];


   //Page 8-Part 17
   Tv[51]:=Tv[27];
   Tv[48]:=Tv[13];
   If Ret[retno].CorpType=CCPC then
     Tv[50]:=GetIncForSmBusDed(RetNo)
   else
     Tv[50]:=0;
   Tv[54]:=MaxR(0,Tv[48]-Tv[50]);
   Tv[49]:=Tv[54];
   Tv[55]:=GetTxblIncome(RetNo); //20230609 //Ret[RetNo].Lnn[360];
   If Ret[retno].CorpType=CCPC then
   Begin
    Tv[32]:=Tv[50];
    Tv[33]:=Ret[RetNo].Lnn[440];
   End
   else
   Begin
    Tv[32]:=0;
    Tv[33]:=0;
   End;
   Tv[34]:=Ret[RetNo].Lnn[636];
   Tv[35]:=Tv[34]*4;
   Tv[36]:=Tv[32]+Tv[33]+Tv[35];
   Tv[37]:=Tv[36];
   Tv[39]:=MaxR(0,Tv[55]-Tv[37]);
   Tv[40]:=MinR(Tv[51],MinR(Tv[49],Tv[39]));
   Tv[46]:=Round(Tv[40]*7.5/100);  //Round(Tv[40]*7.6/100);  //20230616
   Tv[47]:=MinR(Tv[32],MinR(Tv[51],Tv[40]));
   Tv[52]:=round(Tv[47]*4.5/100);
   Tv[53]:=Tv[46]+Tv[52];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S28(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S29(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20241130
//20240525
procedure S411(RetNo: integer;FName: string;FNo: integer);
Var i,j,NumDays:integer;
begin
  //20191006
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   FillHeader(RetNo,FNo,1,2,3);
   If (Ret[RetNo].Province = 'SK') or
     (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 189 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

    For i:=4 to 189 do begin Strings[i]:='';Tv[i]:=0;end;
    Tv[32]:=GetTxblIncomeInProv(RetNo,'SK');

    //jz 20241117
    //according to CRA T2 subission notes: 1B to equal to line 200400 + line 007625 x 600,000/500,000 – line 007625
    //Tv[33]:=Ret[RetNo].Ln[400];showmessage(floattostr(Tv[33]));
    Tv[33]:= Ret[RetNo].Ln[400] + vl(FetchElm(RetNo,'S7', 262)) * (600000 / 500000) - vl(FetchElm(RetNo,'S7', 262)); //showmessage(floattostr(Tv[33]));

    Tv[34]:=Ret[RetNo].Ln[405];
    if Tv[178]>0 then Tv[34]:=Tv[178]; //from partnership section
    Tv[75]:=Ret[RetNo].Ln[428]; //20200926 GetReducedBusinessLimit(RetNo); //20190626 Ret[RetNo].Ln[427]; //20170620
    Tv[36]:=Round(Tv[75]*600000/500000);
    Tv[37]:=MinR(Tv[33],MinR(Tv[34],Tv[36]));
    Tv[28]:=Tv[37];
    Tv[43]:=Tv[28];
    Tv[16]:=Tv[32];
    Tv[17]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[17]>0 then
     Tv[44]:=Tv[43] * Tv[16]/Tv[17]
    else
     Tv[44]:=0;
    Tv[45]:=MaxR(0,Tv[32]-Tv[44]);

    Tv[279]:=Vl(FetchElm(RetNo,'S7',159));
    Tv[280]:=Vl(FetchElm(RetNo,'S7',26));
    Tv[54]:=Vl(FetchElm(RetNo,'S7',99));
    Tv[55]:=Vl(FetchElm(RetNo,'S7',100));
    Tv[56]:=Vl(FetchElm(RetNo,'S7',165));
    Tv[281]:=MaxR(0,Tv[279]-Tv[280]-Tv[54]-Tv[55]-Tv[55]);
    Tv[146]:=Tv[281];

    Tv[147]:=Vl(FetchElm(RetNo,'S7',150));
    i:=148;
    j:=105;
    Repeat
     Tv[i]:=Vl(FetchElm(RetNo,'S7',j));
     Inc(i,4);
     Inc(j,8);
    until i>164;

    i:=149;
    j:=107;
    Repeat
     Tv[i]:=RoundCorrect(Vl(FetchElm(RetNo,'S7',j)) * 600000/500000);
     Inc(i,4);
     Inc(j,8);
    until i>165;
    i:=150;
    Tv[168]:=0;
    Tv[169]:=0;
    Repeat
     Tv[i]:=MaxR(0,Tv[i-2]-Tv[i-1]);
     Tv[i+1]:= MinR(Tv[i-2],Tv[i-1]);
     If Tv[i-2]<0 then Tv[i+1]:=0;
     Tv[168]:=Tv[168]+Tv[i];
     Tv[169]:=Tv[169]+Tv[i+1];
     Inc(i,4);
    until I>166;

    Tv[170]:=Vl(FetchElm(RetNo,'S7',143));
    Tv[171]:=Vl(FetchElm(RetNo,'S7',144));
    Tv[172]:=Tv[170]+Tv[171];
    Tv[173]:=MinR(Tv[168],Tv[172]);
    Tv[174]:=Tv[169]+Tv[173];
    Tv[175]:=Tv[174];
    Tv[176]:=MaxR(0,Tv[147]-Tv[175]);
    Tv[177]:=Tv[176];
    Tv[178]:=MaxR(0,Tv[146]-Tv[177]);

   //----Part 3   //20210515
   //20240525

{  //jz 20241130 removed from form but seems to not have been in the calc anyway
   Tv[23]:=Tv[44];
   Strings[25]:=IntToStr(GetNumDays(RetNo,'01-07-2023','B'));
   Strings[26]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[24]:=0;
}

   ///default
   //-GetNumDays(RetNo,'30-06-2024','A'));
   //Strings[11]:='1';
   //Strings[9]:=IntToStr(GetNumDays(RetNo,'30-06-2024','A'));
   //Strings[12]:='2';

   Tv[18]:=Tv[44];
   Strings[7]:=IntToStr(GetNumDays(RetNo,'30-06-2023','A'));
   NumDays:=GetNumDays(RetNo,'30-06-2023','A');
   Strings[8]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[50]:=Round((Tv[18]*(Vl(Strings[7])/Vl(Strings[8])))* 1/100);

   Tv[20]:=Tv[45];
   Tv[21]:=Round(Tv[20]*12/100);

   Tv[189]:=Tv[50]+Tv[21];
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


(*
//20240525
procedure S411(RetNo: integer;FName: string;FNo: integer);
Var i,j,NumDays:integer;
begin
  //20191006
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   FillHeader(RetNo,FNo,1,2,3);
   If (Ret[RetNo].Province = 'SK') or
     (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 189 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

    For i:=4 to 189 do begin Strings[i]:='';Tv[i]:=0;end;
    Tv[32]:=GetTxblIncomeInProv(RetNo,'SK');

    //jz 20241117
    //according to CRA T2 subission notes: 1B to equal to line 200400 + line 007625 x 600,000/500,000 – line 007625
    //Tv[33]:=Ret[RetNo].Ln[400];showmessage(floattostr(Tv[33]));
    Tv[33]:= Ret[RetNo].Ln[400] + vl(FetchElm(RetNo,'S7', 262)) *  (600000 / 500000) - vl(FetchElm(RetNo,'S7', 262)); //showmessage(floattostr(Tv[33]));

    Tv[34]:=Ret[RetNo].Ln[405];
    if Tv[178]>0 then Tv[34]:=Tv[178]; //from partnership section
    Tv[75]:=Ret[RetNo].Ln[428]; //20200926 GetReducedBusinessLimit(RetNo); //20190626 Ret[RetNo].Ln[427]; //20170620
    Tv[36]:=Round(Tv[75]*600000/500000);
    Tv[37]:=MinR(Tv[33],MinR(Tv[34],Tv[36]));
    Tv[28]:=Tv[37];
    Tv[43]:=Tv[28];
    Tv[16]:=Tv[32];
    Tv[17]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[17]>0 then
     Tv[44]:=Tv[43] * Tv[16]/Tv[17]
    else
     Tv[44]:=0;
    Tv[45]:=MaxR(0,Tv[32]-Tv[44]);

    Tv[279]:=Vl(FetchElm(RetNo,'S7',159));
    Tv[280]:=Vl(FetchElm(RetNo,'S7',26));
    Tv[54]:=Vl(FetchElm(RetNo,'S7',99));
    Tv[55]:=Vl(FetchElm(RetNo,'S7',100));
    Tv[56]:=Vl(FetchElm(RetNo,'S7',165));
    Tv[281]:=MaxR(0,Tv[279]-Tv[280]-Tv[54]-Tv[55]-Tv[55]);
    Tv[146]:=Tv[281];

    Tv[147]:=Vl(FetchElm(RetNo,'S7',150));
    i:=148;
    j:=105;
    Repeat
     Tv[i]:=Vl(FetchElm(RetNo,'S7',j));
     Inc(i,4);
     Inc(j,8);
    until i>164;

    i:=149;
    j:=107;
    Repeat
     Tv[i]:=RoundCorrect(Vl(FetchElm(RetNo,'S7',j)) * 600000/500000);
     Inc(i,4);
     Inc(j,8);
    until i>165;
    i:=150;
    Tv[168]:=0;
    Tv[169]:=0;
    Repeat
     Tv[i]:=MaxR(0,Tv[i-2]-Tv[i-1]);
     Tv[i+1]:= MinR(Tv[i-2],Tv[i-1]);
     If Tv[i-2]<0 then Tv[i+1]:=0;
     Tv[168]:=Tv[168]+Tv[i];
     Tv[169]:=Tv[169]+Tv[i+1];
     Inc(i,4);
    until I>166;

    Tv[170]:=Vl(FetchElm(RetNo,'S7',143));
    Tv[171]:=Vl(FetchElm(RetNo,'S7',144));
    Tv[172]:=Tv[170]+Tv[171];
    Tv[173]:=MinR(Tv[168],Tv[172]);
    Tv[174]:=Tv[169]+Tv[173];
    Tv[175]:=Tv[174];
    Tv[176]:=MaxR(0,Tv[147]-Tv[175]);
    Tv[177]:=Tv[176];
    Tv[178]:=MaxR(0,Tv[146]-Tv[177]);

   //----Part 3   //20210515
   //20240525

   Tv[23]:=Tv[44];
   Strings[25]:=IntToStr(GetNumDays(RetNo,'01-07-2023','B'));
   Strings[26]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[24]:=0;

   ///default
   Strings[7]:=IntToStr(GetNumDays(RetNo,'30-06-2023','A')-GetNumDays(RetNo,'30-06-2024','A'));
   Strings[11]:='1';
   Strings[9]:=IntToStr(GetNumDays(RetNo,'30-06-2024','A'));
   Strings[12]:='2';

   Tv[18]:=Tv[44];
   //exception
NumDays:=GetNumDays(RetNo,'30-06-2023','A')-GetNumDays(RetNo,'30-06-2024','A'); //before jul 1
   if Numdays>0 then
   Begin
    Strings[11]:='1';  //rate
    Strings[7]:=IntToStr(NumDays);
   end;
   Strings[8]:=IntToStr(Ret[RetNo].DaysInYear);
Tv[50]:=Round((Tv[18]*(Vl(Strings[7])/Vl(Strings[8])))*Vl(Strings[11])/100);

   Tv[4]:=Tv[44];
   NumDays:= GetNumDays(RetNo,'30-06-2024','A'); //-GetNumDays(RetNo,'30-06-2024','A');
   Strings[9]:=IntToStr(Numdays);
   Strings[12]:='2';  //rate
   Strings[10]:=IntToStr(Ret[RetNo].DaysInYear);
Tv[5]:=Round((Tv[4]*(Vl(Strings[9])/Vl(Strings[10])))*Vl(Strings[12])/100);

   Tv[6]:=Tv[50]+Tv[5];

   Tv[20]:=Tv[45];
   Tv[21]:=Round(Tv[20]*12/100);

   Tv[189]:=Tv[6]+Tv[21];
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;
*)
{
//20181113
procedure S411(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  //20191006
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   FillHeader(RetNo,FNo,1,2,3);
   If (Ret[RetNo].Province = 'SK') or
     (Ret[RetNo].Province = 'MJ') then
    //continue
   else
   begin
    For i:=4 to 189 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

    For i:=4 to 189 do begin Strings[i]:='';Tv[i]:=0;end;
    Tv[32]:=GetTxblIncomeInProv(RetNo,'SK');
    Tv[33]:=Ret[RetNo].Ln[400];
    Tv[34]:=Ret[RetNo].Ln[405];
    if Tv[178]>0 then Tv[34]:=Tv[178]; //from partnership section
    Tv[75]:=Ret[RetNo].Ln[428]; //20200926 GetReducedBusinessLimit(RetNo); //20190626 Ret[RetNo].Ln[427]; //20170620
    Tv[36]:=Round(Tv[75]*600000/500000);
    Tv[37]:=MinR(Tv[33],MinR(Tv[34],Tv[36]));
    Tv[28]:=Tv[37];

    If IsCreditUnion(RetNo) then
     Tv[38]:=Vl(FetchElm(RetNo,'S17',61))  //Vl(FetchElm(RetNo,'S17',63))  //20181107
    else
     Tv[38]:=0;
    Tv[39]:=Tv[28];
    Tv[40]:=MaxR(0,Tv[38]-Tv[39]);
    Tv[41]:=Tv[40];


    //Tv[31]:=Tv[41];
    //Strings[29]:=IntToStr(GetNumDays(RetNo,'01-01-2019','B'));
    //Strings[30]:=IntToStr(Ret[RetNo].DaysInYear);
    //Tv[35]:=Round(Tv[31] * Vl(Strings[29])/(Vl(Strings[30]))*(50/100));

    Tv[48]:=Tv[41];
    Strings[46]:=IntToStr(GetNumDays(RetNo,'31-12-2018','A')-GetNumDays(RetNo,'31-12-2019','A'));  //20210515
    Strings[47]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[49]:=Round(Tv[48] * (Vl(Strings[46])/(Vl(Strings[47]))*(25/100)));


    //Tv[12]:=Tv[35]+Tv[49];
    //Tv[13]:=Tv[12];

    Tv[42]:=Tv[28]+Tv[49]; //13]; //20210515

    Tv[43]:=Tv[42];
    Tv[16]:=Tv[32];
    Tv[17]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[17]>0 then
     Tv[44]:=Tv[43] * Tv[16]/Tv[17]
    else
     Tv[44]:=0;
    Tv[45]:=MaxR(0,Tv[32]-Tv[44]);

    Tv[279]:=Vl(FetchElm(RetNo,'S7',159));
    Tv[280]:=Vl(FetchElm(RetNo,'S7',26));
    Tv[54]:=Vl(FetchElm(RetNo,'S7',99));
    Tv[55]:=Vl(FetchElm(RetNo,'S7',100));
    Tv[56]:=Vl(FetchElm(RetNo,'S7',165));
    Tv[281]:=MaxR(0,Tv[279]-Tv[280]-Tv[54]-Tv[55]-Tv[55]);
    Tv[146]:=Tv[281];

    Tv[147]:=Vl(FetchElm(RetNo,'S7',150));
    i:=148;
    j:=105;
    Repeat
     Tv[i]:=Vl(FetchElm(RetNo,'S7',j));
     Inc(i,4);
     Inc(j,8);
    until i>164;

    i:=149;
    j:=107;
    Repeat
     Tv[i]:=RoundCorrect(Vl(FetchElm(RetNo,'S7',j)) * 600000/500000);
     Inc(i,4);
     Inc(j,8);
    until i>165;
    i:=150;
    Tv[168]:=0;
    Tv[169]:=0;
    Repeat
     Tv[i]:=MaxR(0,Tv[i-2]-Tv[i-1]);
     Tv[i+1]:= MinR(Tv[i-2],Tv[i-1]);
     If Tv[i-2]<0 then Tv[i+1]:=0;
     Tv[168]:=Tv[168]+Tv[i];
     Tv[169]:=Tv[169]+Tv[i+1];
     Inc(i,4);
    until I>166;

    Tv[170]:=Vl(FetchElm(RetNo,'S7',143));
    Tv[171]:=Vl(FetchElm(RetNo,'S7',144));
    Tv[172]:=Tv[170]+Tv[171];
    Tv[173]:=MinR(Tv[168],Tv[172]);
    Tv[174]:=Tv[169]+Tv[173];
    Tv[175]:=Tv[174];
    Tv[176]:=MaxR(0,Tv[147]-Tv[175]);
    Tv[177]:=Tv[176];
    Tv[178]:=MaxR(0,Tv[146]-Tv[177]);

   //----Part 3   //20210515
   Tv[18]:=Tv[44];
   Strings[7]:=IntToStr(GetNumDays(RetNo,'01-10-2020','B'));
   Strings[8]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[50]:=Round((Tv[18]*(Vl(Strings[7])/Vl(Strings[8])))*2/100);

   Tv[4]:=Tv[44];
   Strings[9]:=IntToStr(GetNumDays(RetNo,'30-06-2022','A')-GetNumDays(RetNo,'30-06-2023','A'));
   Strings[10]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[5]:=Round((Tv[4]*(Vl(Strings[9])/Vl(Strings[10])))*1/100);

   Tv[6]:=Tv[50]+Tv[5];

   Tv[20]:=Tv[45];
   Tv[21]:=Round(Tv[20]*12/100);

   Tv[189]:=Tv[6]+Tv[21];
 end; //End with
 SaveTv(RetNo,FName,FNo);
end;
}

procedure S427(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  //revised //20160712
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Tv[4]:=GetTxblIncomeInProv(RetNo,'BC');
    Tv[5]:=Ret[RetNo].Ln[400];
    Tv[6]:=Ret[RetNo].Ln[405];
    Tv[7]:=Ret[RetNo].Ln[428]; //20200926 GetReducedBusinessLimit(RetNo); //20190626  Ret[RetNo].Ln[427];   //20170619 from 425
    Tv[8]:=MinR(Tv[7],MinR(Tv[5],Tv[6]));
    Tv[16]:=Tv[8];   //20160710
    If IsCreditUnion(RetNo) then
    begin
     Tv[34]:=Vl(FetchElm(RetNo,'S17',61)); //20181108 //Vl(FetchElm(RetNo,'S17',63));
     Tv[35]:=Tv[16];    //201607
     Tv[36]:=MaxR(0,Tv[34]-Tv[35]);
     Tv[9]:=Tv[36];
    end
    else
    begin
     Tv[34]:=0;
     Tv[35]:=0;
     Tv[36]:=0;
     Tv[9]:=0;
    end;
    Tv[17]:=Tv[9];
    Tv[10]:=Tv[16]+Tv[9];  //20190930

    Tv[11]:=Tv[10];
    Tv[12]:=Tv[4];
    Tv[13]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[13]>0 then
      Tv[14]:=Tv[11] * Tv[12]/Tv[13]
    else
      Tv[14]:=0;
    Tv[15]:=MaxR(0,Tv[4]-Tv[14]);

   Tv[29]:= Tv[14];

   Tv[33]:=Round(Tv[29] *2/100);

   Tv[42]:= Tv[15];
   Tv[65]:=Round(Tv[42] * 12/100);
   Tv[25]:=Tv[33]+Tv[65];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S442(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  If Vl(GetPrvAlloc(RetNo,'YT')) = 0 then
  begin
   For i:=1 to 16 do begin StoreElm(RetNo,FNo,i,'');end;
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   {Tv[4] := ?}
   Tv[5] := Tv[4];
   Tv[6] := Tv[5] * 15/100;
   Tv[8] := Tv[7] * 5/100;
   Tv[9] := Tv[6]+Tv[8];
   Tv[10] := Tv[9];

   Tv[18]:=Round(Tv[16]*Tv[17]/100);  //20120531
   Tv[13] := Tv[11]+Tv[12]+Tv[18];
   Tv[14] := Tv[13];
   Tv[15] := Tv[10]+Tv[14];

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S421(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
  end; {End with}
  //S421 pg2 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   //FillHeader(RetNo,FNo,101,102,103);
   Tv[116]:=Tv[109]+Tv[111]+Tv[113]+Tv[115];
   Tv[117] := Tv[116];
   Tv[118] := Tv[104]+Tv[105]+Tv[106]+Tv[107]+Tv[117];

   Tv[121] := MaxR(0,Tv[119]-Tv[120]);

   Tv[122] := Tv[118];
   Tv[123] := Tv[121];
   Tv[124] := MaxR(0,Tv[122]-Tv[123]);
   Tv[136] := Tv[124] * 0.20;
   Tv[139] := Tv[138] * 0.10;
   Tv[125] := Tv[136]+Tv[139]+Tv[137];

   {20170625
   If Strings[126] = '' then Strings[126] := FetchElm(RetNo,'T2',742);
   If Strings[127] = '' then Strings[127] := FetchElm(RetNo,'T2',743);
   If Strings[128] = '' then Strings[128] := FetchElm(RetNo,'T2',744);

   If Strings[129] = '' then Strings[129] := FetchElm(RetNo,'T2',745);
   If Strings[130] = '' then Strings[130] := FetchElm(RetNo,'T2',755) + ' '+FetchElm(RetNo,'T2',746);
   If Strings[131] = '' then Strings[131] := FetchElm(RetNo,'T2',747);
   If Strings[132] = '' then Strings[132] := FetchElm(RetNo,'T2',748);
   }
  end; {End with}
  SaveTv(RetNo,FName,FNo);


end;

procedure S422(RetNo: integer;FName: string;FNo: integer);
Var i:integer; x:Real; Pg8FNo:Integer;
PhotoBegins:String;  //20170524
//major changes
begin

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
     //20130516
    If (Ret[RetNo].Province <> 'BC') and (Ret[RetNo].Province <> 'MJ') then  //20160709
    begin
      For i:=4 to 125 do begin Tv[i]:=0;Strings[i]:='';end;  //121 to 125  //20180423
      SaveTv(RetNo,FName,FNo);
      Exit;
    end;


    FillHeader(RetNo,FNo,1,2,3);
    PhotoBegins:=Strings[7];
    Pg8FNo:=GetFormNo('T2');
    If Strings[4]='' then Strings[4]:=FetchElmFNo(RetNo,Pg8FNo,43)+' '+FetchElmFNo(RetNo,Pg8FNo,742); //name
    If Strings[5]='' then Strings[5]:=FetchElmFNo(RetNo,Pg8FNo,755);
    If Strings[8]='' then Strings[8]:=FetchElmFNo(RetNo,Pg8FNo,746);
   // If Length(Strings[10]) <> 3

    If Strings[11]+Strings[12]='' then Strings[12]:='X';
    If Strings[13]+Strings[14]='' then Strings[14]:='X';
    If Strings[15]+Strings[16]='' then Strings[16]:='X';
    If Strings[17]+Strings[18]='' then Strings[18]:='X';
    //part 3

    If Strings[21]+Strings[22]='' then Strings[22]:='X';
    If Strings[23]+Strings[24]='' then Strings[24]:='X';
    If Strings[25]+Strings[26]='' then Strings[26]:='X';
    If Strings[27]+Strings[28]='' then Strings[28]:='X';
    If Strings[29]+Strings[30]='' then Strings[30]:='X';
    If Strings[31]+Strings[32]='' then Strings[32]:='X';
    If Strings[33]+Strings[34]='' then Strings[34]:='X';

    If Strings[21]+Strings[23]+Strings[25]+Strings[25]+Strings[27]+Strings[29]+Strings[31]+Strings[33]>'' then
    begin
    //not eligible
    end;

   If Strings[126]+Strings[127]='' then Strings[127]:='X';   //20150415
   (*
   If Strings[127]>'' then
   Begin
    Strings[82]:='100';
    x:=Vl(Strings[83])+Vl(Strings[84]);
    Strings[85]:=FormatFloat('###.##',x);
    Strings[86]:=Strings[85];
    Strings[87]:=FormatFloat('###.##',Vl(Strings[82])-Vl(Strings[86]));
    If Vl(Strings[87])<0 then Strings[87]:='';
    Strings[88]:=Strings[87];

    If Vl(Strings[88])>0 then
    begin
      Strings[89]:= FormatFloat('###.##',(Vl(Strings[81]) / Vl(Strings[88])*100));
      If Vl(Strings[89])>100 then Strings[89]:='100';  //20150415
    end
    Else
      Strings[89]:='';
   end
   Else
   Begin
    Strings[82]:='100';
    Strings[85]:='';
    Strings[86]:='';
    Strings[87]:='';
    Strings[88]:='';
    Strings[89]:=''
   end;
  *)

   //part 4
   Tv[37]:=MaxR(0,Tv[35]-TV[36]);
   Tv[38]:=TV[37];
   Tv[40]:=Tv[38]*60/100;   //20160709
   Tv[42]:=MaxR(0,Tv[40]-Tv[41]);
   //Part 5
   Tv[48]:=Tv[44]+Tv[45]+Tv[46]+Tv[47];
   Tv[49]:=Tv[48];
   Tv[51]:=Tv[43]+Tv[49]+Tv[50];
   Tv[54]:=MaxR(0,Tv[52]-Tv[53]);
   Tv[55]:=Tv[54];
   Tv[56]:=Tv[51]+Tv[55];
   Tv[58]:=MaxR(0,Tv[56]-Tv[57]);
   Tv[59]:=MinR(Tv[42],Tv[58]);

   //part 6  //20190423
   Tv[139]:=Tv[135]+Tv[136]+Tv[137]+Tv[138];
   Tv[140]:=Tv[139];
   Tv[142]:=Tv[134]+Tv[140]+Tv[141];

   //part 7
   Tv[65]:=Tv[61]+Tv[62]+Tv[63]+Tv[64];
   Tv[66]:=Tv[65];
   Tv[68]:=Tv[60]+Tv[66]+Tv[67];
   Tv[69]:=Tv[68]+Tv[125];  //20140511

   Tv[73]:=Tv[70]+Tv[71]+Tv[72];
   Tv[74]:=Tv[73];
   Tv[75]:=MaxR(0,Tv[69]-Tv[74]);
  (*
   If Strings[7]>'20100228' then
     //ok
   Else
    Tv[76]:=0;
  *)
  // End;

   (*
  //part 7
   Tv[77]:=Tv[59];
   Tv[78]:=Tv[77] * 35/100;
   Strings[79]:='100';
   *)
   //20150415
   If Strings[15]>'' then  //interprovincial
   Begin
    If (Strings[7]<'2012/01/01') and (Strings[126]>'') //started bfr and Yes to calculation of %
    then Strings[79]:=Strings[89];
   end;

   //part 8
   Tv[80]:=Round(Tv[59] * 0.35); ////Tv[78] * Vl(Strings[79])/100;

   Tv[143]:=Tv[142];
   Tv[146]:=Tv[144]+Tv[145];
   Tv[147]:=Tv[146];
   Tv[148]:=MaxR(0,Tv[143]-Tv[147]);
   Tv[149]:=Round(Tv[148]*0.35);

  //part 9   //20160709
  Tv[90]:=Tv[59];
  Tv[92]:=MaxR(0,Tv[90]-Tv[91]);
  Tv[93]:=Tv[92];


  If Vl(Strings[95])>0 then
    Strings[96]:=FormatFloat('##0.0000',Vl(Strings[94])/Vl(Strings[95]))  //20160709
  Else
    Strings[96]:='';
  if Vl(Strings[96])>1 then Strings[96]:='1.0000'; //20160709

  //20170524
  if Tv[122]>0 then
    Strings[128]:=FormatFloat('##0.0000',Tv[114]/Tv[122])
  Else
    Strings[128]:='';
  if Vl(Strings[128])>1 then Strings[128]:='1.0000';

  if Vl(Strings[94])>0 then
   Tv[129]:=Vl(Strings[96])* Tv[93]
  Else
   Tv[129]:=Vl(Strings[128]) * Tv[93];

  Tv[97]:=Tv[129];  //*Vl(Strings[129]);  //Tv[97]:=Tv[93]*Vl(Strings[96]); ///100; //20160709
  Tv[98]:=Tv[97] * 12.5/100;

  //part 9
  Tv[99]:=Tv[59];
  Tv[101]:=MaxR(0,Tv[99]-Tv[100]);
  Tv[102]:=Tv[101];

  {?? //does not work?
  if PhotoBegins<'2015/06/27' then
  Begin
   Tv[39]:=0;
   Tv[76]:=0;
   Strings[112]:='';
  End
  Else
  Begin
   Strings[19]:='';
   Strings[20]:='';
   Strings[103]:='';
  End;
  }

  If Vl(Strings[20])>0 then
   Strings[103]:=FormatFloat('##0.0000',Vl(Strings[19])/Vl(Strings[20]))  //20160709
  Else
   Strings[103]:='';
  if Vl(Strings[103])>1 then Strings[103]:='1.0000';  //20160709

 //20170524
  if Tv[76]>0 then
    Strings[112]:=FormatFloat('##0.0000',Tv[39]/Tv[76])
  Else
    Strings[112]:='';
  if Vl(Strings[112])>1 then Strings[112]:='1.0000';

  //20170527
  If Vl(Strings[103])>0 then
   Tv[113]:=Tv[102] * Vl(Strings[103])
  Else
   Tv[113]:=Tv[102] * Vl(Strings[112]);
  Tv[104]:=Tv[113];

  Tv[105]:=Round(Tv[104] * 6/100);

  //part 10
  Tv[108]:=MaxR(0,Tv[106]-Tv[107]);
  Tv[124]:=Tv[108];
  Tv[109]:=Tv[124]*30/100;
  Tv[123]:=Tv[59];
  Tv[110]:=Tv[123]*3/100;
  Tv[111]:=MinR(Tv[109],Tv[110]);

  //part 11
  //20170527
  if PhotoBegins<'2016/10/01' then  //'2015/06/27' then
  Begin
   Tv[130]:=Tv[75];
   Tv[131]:=Round(Tv[130] * 17.5/100);
   Tv[132]:=0;
   Tv[133]:=0;
  End
  Else
  Begin
   Tv[132]:=Tv[75];
   Tv[133]:=Round(Tv[132] * 16/100);
   Tv[130]:=0;
   Tv[131]:=0;  //20170529
  End;
  Tv[115]:=MaxR(Tv[131],Tv[133]);
 {//20170527
  Tv[112]:=Tv[75];
  Tv[113]:=Tv[112] * 15/100;
  Tv[122]:=Tv[76];
  Tv[114]:=Tv[122] * 2.5/100;
  Tv[115]:=Tv[113]+Tv[114];
 }
  //Part 12
  Tv[116]:=Tv[80];
  Tv[117]:=Tv[149]; //Tv[98];
  Tv[118]:=Tv[98];
  Tv[77]:=Tv[105];
  Tv[119]:=Tv[111];
  Tv[120]:=Tv[115];
  Tv[121]:=Tv[116]+Tv[117]+Tv[118]+Tv[77]+Tv[119]+Tv[120];
  end;
  SaveTv(RetNo,FName,FNo);
end;

procedure S91(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   Tv[85]:=Tv[81]+Tv[82]+Tv[83]+Tv[84];

   Strings[25]:='';
   if      Strings[54]>'' then Strings[25]:='BC'
   Else if Strings[55]>'' then Strings[25]:='AB'
   Else if Strings[56]>'' then Strings[25]:='SK'
   Else if Strings[57]>'' then Strings[25]:='MB'
   Else if Strings[58]>'' then Strings[25]:='ON'
   Else if Strings[59]>'' then Strings[25]:='QC'
   Else if Strings[60]>'' then Strings[25]:='YT'
   Else if Strings[61]>'' then Strings[25]:='NT'
   Else if Strings[62]>'' then Strings[25]:='NU'
   Else if Strings[63]>'' then Strings[25]:='NB'
   Else if Strings[64]>'' then Strings[25]:='NS'
   Else if Strings[65]>'' then Strings[25]:='PE'
   Else if Strings[66]>'' then Strings[25]:='NL'
   Else if Strings[67]>'' then Strings[25]:='MJ';

   Strings[27]:='';
   if      Strings[68]>'' then Strings[27]:='01'
   Else if Strings[69]>'' then Strings[27]:='05'
   Else if Strings[70]>'' then Strings[27]:='09'
   Else if Strings[71]>'' then Strings[27]:='02'
   Else if Strings[72]>'' then Strings[27]:='06'
   Else if Strings[73]>'' then Strings[27]:='10'
   Else if Strings[74]>'' then Strings[27]:='03'
   Else if Strings[75]>'' then Strings[27]:='07'
   Else if Strings[76]>'' then Strings[27]:='11'
   Else if Strings[77]>'' then Strings[27]:='04'
   Else if Strings[78]>'' then Strings[27]:='08';

   If Length(Strings[88]) >30 then Strings[88]:=LeftStr(Strings[88],30);  //20131016
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S97(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If (GetTaxationYearEnd(RetNo) > '2004/12/31')
   and (IsNonResidentInvestmentCorp(RetNo))then Strings[11]:='';

   Strings[22]:='';

   For i:=7 to 18 do
   begin
    If Strings[i]>'' then
      begin Strings[22]:=FillLeftZeros(IntToStr(i-6),2);Exit;End;
   end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S70(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer; s7FNo:Integer;
begin
  S7FNo:=GetFormNo('S7');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If Vl(FetchElmFNo(RetNo,S7FNo,152)) <=0 then
   begin
    For i:=4 to 42 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   end;
   Tv[29] :=0;
   Tv[30]:=0;
   i:=4;
   j:=105;
   Repeat
    Tv[i]:=Vl(FetchElmFNo(RetNo,S7FNo,j));
    Tv[i+1]:=Vl(FetchElmFNo(RetNo,S7FNo,j+2));
    Tv[i+2]:=Tv[i+1] * 300000/GetMaxBizLimit(RetNo,GetTaxationYearEndYYYY(RetNo));
    Tv[i+3]:=MaxR(0,Tv[i]-Tv[i+2]);

    Tv[i+4]:=MinR(Tv[i],Tv[i+2]);
    If Tv[i]<0 then tv[i+4]:=0;

    Tv[29] := Tv[29]+Tv[i+3];
    Tv[30] := Tv[30]+Tv[i+4];
   Inc(i,5);
   Inc(j,8);
   until i>24;

   Tv[31] := Vl(FetchElmFNo(RetNo,S7FNo,165));
   Tv[35] := MinR(Tv[29],Tv[31]);
   Tv[36] := Tv[30]+Tv[35];

   Tv[37] := Vl(FetchElmFNo(RetNo,S7FNo,150));
   Tv[38] := Tv[36];
   Tv[39] := MaxR(0, Tv[37]-Tv[38]);

   Tv[40] := Vl(FetchElmFNo(RetNo,S7FNo,159));
   Tv[41] := Tv[39];
   Tv[42] := MaxR(0, Tv[40]-Tv[41]);

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;




// 20191012
procedure S71(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    // pg1
    FillHeader(RetNo, FNo, 1, 2, 3);
    //20230112
    if (Strings[10]>'') and (Strings[11]>'') then
      Strings[6] := IntToStr(DateDiffYMD(Strings[32], Strings[33]))
    Else
      Strings[6]:='';
    // part 1
    // If Strings[6]+Strings[7]='' then Strings[7]:='X'; //jz 2019 removed

    {
      <-- jz 2019 removed
      Tv[14]:=Tv[12]+Tv[13];
      Tv[15]:=Tv[14];
      Tv[17]:=MinR(Tv[16],Tv[17]);
      Tv[18]:=Tv[16]+Tv[17];
      Tv[19]:=Tv[18];
      Tv[20]:=Tv[15]+Tv[19];
      Tv[22]:=MaxR(0,Tv[20]-Tv[21]);
      -->
    }

    // part 2
    Tv[25] := Tv[23] + Tv[24];
    Tv[26] := Tv[25];
    Tv[29] := MaxR(0, Tv[27] - Tv[28]); // 20130925
    Tv[30] := Tv[29];

    Tv[31] := Tv[26] + Tv[30]; // 20130919


    // jz 2019 ????
    // 20160621
    // Proportion
    // Tv[112]:=0;Tv[113]:=0;Tv[114]:=0;  //20191013 con
    (* //20191013 con
      if Tv[31]>0 then
      Begin
      {
      Strings[112]:=FormatFloat('##0.00000',100*Tv[23]/Tv[31]);
      Strings[113]:=FormatFloat('##0.00000',100*Tv[27]/Tv[31]);
      Strings[114]:=FormatFloat('##0.00000',100*Tv[28]/Tv[31]);
      }
      End;
    *)

    // 20121025
    // If Strings[10]<GetTaxationYearStart(RetNo) then Strings[32]:=GetTaxationYearStart(RetNo) else Strings[32]:=Strings[10];
    // If Strings[11]>GetTaxationYearEnd(RetNo) then Strings[33]:=GetTaxationYearEnd(RetNo) else Strings[33]:=Strings[11];


    // 20121025
    // If Strings[10]<GetTaxationYearStart(RetNo) then Strings[32]:=GetTaxationYearStart(RetNo) else Strings[32]:=Strings[10];
    // If Strings[11]>GetTaxationYearEnd(RetNo) then Strings[33]:=GetTaxationYearEnd(RetNo) else Strings[33]:=Strings[11];

    // Strings[34]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[32]),YYYYMMDDToMMDDYYYY(Strings[33]))); //20150703
    // Strings[35]:=
    // Strings[35]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[10]),YYYYMMDDToMMDDYYYY(Strings[11])));

  //  Strings[34] := IntToStr(DateDiffYMD(Strings[32], Strings[33]));    //20230112
    Strings[36] := Strings[34]; // 20160605 //jz 2019 ??? why?
    If Vl(Strings[35]) > 0 then
      Strings[36] := FormatFloat('#0.#######',
        Vl(Strings[34]) / Vl(Strings[35]));
    Tv[37] := Tv[31] * Vl(Strings[36]);

    Tv[40] := Tv[38] + Tv[39];
    Tv[41] := Tv[40];
    Tv[42] := MaxR(0, Tv[37] - Tv[41]);

    // part 3
    If Vl(Strings[46]) > 0 then
      Strings[47] := FloatToStr(Vl(Strings[45]) / Vl(Strings[46]));
    Tv[48] := Round(Tv[44] * Vl(Strings[47]));
    Tv[49] := MinR(Tv[43], Tv[48]);

    // jz 2019 removed
    // <-- ----------------------------------------------------------------------
    {
      //part 5 QTI -------------------
      Tv[50]:=Tv[22];
      //  Tv[51]:=Tv[42];       //201309/17
      Tv[52]:=Tv[50]+Tv[51];

      //part 6 transitional income  ---------------------
      Tv[55]:=Tv[53]+Tv[54];
      Tv[56]:=Tv[55];
      Tv[59]:=Tv[57]+Tv[58];
      Tv[60]:=Tv[59];
      Tv[61]:=Tv[56]+Tv[60]; //20121219

      If Vl(Strings[63])>0 then Strings[64]:=FloatToStr(Vl(Strings[62]) /Vl(Strings[63]));
      Tv[65]:=Tv[61] * Vl(Strings[64]);
      Tv[67]:=MaxR(0,Tv[65]-Tv[66]);
      Tv[69]:=Tv[67]+Tv[68];

      //part 7 transitional reserve  -----------------------
      If Vl(Strings[71])>100 then Tv[71]:=100;
      Tv[72]:=Tv[70] * Tv[71]/100;
      Tv[74]:=Tv[69];
      Tv[76]:=Tv[74]+Tv[75];
      Tv[77]:=Tv[76];
      Tv[78]:=Tv[73]+Tv[77];
      Tv[79]:=Tv[78];
      //tv[81]:=?
      // If Tv[82]=0 then Tv[82]:=MinR(Tv[82],Tv[81]); //20121219

      -----------------------------------------------------------------------
      //--> }

    // part 4
    Tv[85] := MaxR(0, Tv[83] - Tv[84]); // 20121219
    Tv[86] := Tv[85];

    Tv[89] := MaxR(0, Tv[87] - Tv[88]); // 20121219
    Tv[90] := Tv[89];
    Tv[91] := Tv[86] + Tv[90];

    If Vl(Strings[93]) > 0 then
      Strings[94] := FloatToStr(Vl(Strings[92]) / Vl(Strings[93]));
    Tv[95] := Tv[91] * Vl(Strings[94]);
    Tv[97] := Tv[95] - Tv[96];

    Tv[100] := Tv[98] + Tv[99];
    Tv[101] := MinR(Tv[97], Tv[100]);
    Tv[102] := MaxR(0,Tv[101] - Tv[98]);  //20230111
    Tv[104] := Tv[102] * Vl(Strings[103]);

    Tv[107] := Tv[104] * Vl(Strings[106]);

    Tv[108] := Tv[101] * Vl(Strings[103]);
    Tv[109] := Tv[108] * Vl(Strings[106]);
    Tv[110] := Tv[109] * 25 / 100;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;



//==============================
//20230112
procedure S73(RetNo: integer;FName: string;FNo: integer);
Var i,j,k,k1,K2,k3:integer;
  lFRecInstIdx: Integer; //20260730 Alex
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);

  //populate from S71
  for i:=364 to 371 do Tv[i]:=0;  //iit totals
  for i:=500 to 501 do Tv[i]:=0;  //iit totals
  k:=0;

  //20260730 Alex >>>
  for i:= 0 to pred(FList.Count) do
  begin
    FRec:= FList.Items[i];
    if LeftStr(Frec.FormName, 3).Equals('S71') and (Ret[RetNo].FrmHasData[Frec.FormNo]) then
    begin
      lFRecInstIdx:= StrToIntDef(Trim(ReplaceStr(Frec.FormInst, '#', '')), 0);
      k:= pred(lFRecInstIdx) * 17;
      //Part 1
      Strings[k + 4]:= FetchElmFNo(RetNo, Frec.FormNo, 5); //account
      Strings[k + 5]:= FetchElmFNo(RetNo, Frec.FormNo, 4); //name
      Strings[k + 6]:= FetchElmFNo(RetNo, Frec.FormNo, 10);
      Strings[k + 7]:= FetchElmFNo(RetNo, Frec.FormNo, 11);
      //Part 2
      Strings[k + 9]:= FetchElmFNo(RetNo, Frec.FormNo, 5);
      Tv[k + 10]:= Vl(FetchElmFNo(RetNo, Frec.FormNo, 37)); //stub acrual
      Tv[k + 11]:= Vl(FetchElmFNo(RetNo, Frec.FormNo, 38)); //resource
      Tv[k + 12]:= Vl(FetchElmFNo(RetNo, Frec.FormNo, 39)); //discretionary

      Tv[k + 13]:= MaxR(0, Tv[K + 10] - Tv[k + 11] - Tv[K + 12]); //calced
      //Tv[k+14] = user previous year
      Tv[k + 15]:= Vl(FetchElmFNo(RetNo, Frec.FormNo, 49)); //income inclusion
      // Tv[k1+16]:=user prev year
      // Tv[k+17]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,49)); //net
      //Tv[K3+31]:=user prior year
      Tv[K + 17]:= MaxR(0, Tv[k + 13] + Tv[K + 15] - Tv[K + 14] - Tv[K + 16]);
      //part 3
      Strings[k + 18]:= Strings[K + 4];//FetchElmFNo(RetNo,Frec.FormNo,5);
      Tv[k + 19]:= Vl(FetchElmFNo(RetNo, Frec.FormNo, 107));
      Tv[k + 20]:= Vl(FetchElmFNo(RetNo, Frec.FormNo, 110));

      //add to toals
      Tv[364]:= Tv[364] + Tv[k + 10];
      Tv[365]:= Tv[365] + Tv[k + 11];
      Tv[366]:= Tv[366] + Tv[k + 12];
      Tv[367]:= Tv[367] + Tv[k + 13];
      Tv[368]:= Tv[368] + Tv[k + 14];
      Tv[369]:= Tv[369] + Tv[k + 15];
      Tv[370]:= Tv[370] + Tv[k + 16];
      Tv[371]:= Tv[371] + Tv[k + 17];
      Tv[500]:= Tv[500] + Tv[k + 19];
      Tv[501]:= Tv[501] + Tv[k + 20];

      //Inc(k, 17);  //20230111
    end; //if S71
  end;
  //20260730 Alex >>>
  For i:=500 TO 501 do begin Tv[i]:=0;end;  //init
   //Page 3
   i:=19;
   Repeat
    Tv[500]:=Tv[500]+Tv[i];
    Tv[501]:=Tv[501]+Tv[i+1];
    Inc(i,17);
   until i>342;


   Tv[505]:=Tv[500];
   Tv[506]:=Tv[505];
   Tv[507]:=MinR(Tv[500],Tv[501]);
   Tv[508]:=MaxR(0,Tv[505]-Tv[507]);
   Tv[509]:=RounD(Tv[508]*0.50);
   Tv[510]:=Tv[506]+Tv[509];

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20150531
procedure S76(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);
  i:=4;
  Tv[70]:=0;
  Repeat
   Tv[i+8]:=Tv[i+5]-Tv[i+6]+Tv[i+7];
   If Tv[i+9]=0 then Tv[i+9]:=30;  //2025-607
   Tv[i+10]:=Tv[i+8] * Vl(Strings[I+9])/100;
   Tv[70]:=Tv[70]+Tv[i+10];
   Inc(i,11);
  Until i>59;
  //pg2
  Tv[72]:=Tv[70]+Tv[71];

  i:=73;
  Tv[127]:=0;
  Repeat
   if Tv[i+6]>0 then
    Tv[i+7]:=Tv[i+4] * (Tv[i+5]/Tv[i+6])
   Else
    Tv[i+7]:=0;
   Tv[i+8]:=MinR(Tv[i+4],Tv[i+7]);
   Tv[127]:=Tv[127]+Tv[i+8];
   Inc(i,9);
  Until i>122;

  Tv[129]:=Tv[127]+Tv[128];

  //20260501 Alex >>>
  i:=139;
  Tv[130]:= 0;
  Tv[161]:= 0;
  repeat
    Tv[130]:= Tv[130] + Tv[i];
    Tv[161]:= Tv[161] + Tv[i + 1];

   Inc(i, 4);
  Until i > 159;
  //20260501 Alex <<<
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


//20250531
//jz//20260611/VT52 v2 - added rates and other conditions based on dates
procedure S78(RetNo: integer;FName: string;FNo: integer);
Var
  i:integer;
  Tot4H:Real;


  Tot1Mbfr,Tot1Maft:Real;
  dateElm:integer;
  CCUSpercent,CCUSReduction:real;
  CCUSDate,commOpsDate: TDate; //TDateTime;
  dtS: TFormatSettings;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);
  //20260518 Alex >>>
  i:= 9;
  repeat
    if not Strings[i].IsEmpty then Strings[i]:= Copy(Strings[i], 0, 2); //Get code only
    if not Strings[i + 1].IsEmpty then Strings[i + 1]:= Copy(Strings[i + 1], 0, 2); //Get code only
    inc(i, 14);
  until i > 135;
  //20260518 Alex <<<

  i             :=9;
  Tot1Mbfr      :=0;
  Tot1Maft      :=0;

  dtS := TFormatSettings.Create; dtS.DateSeparator := '/'; dtS.ShortDateFormat := 'yyyy/mm/dd';
  if strings[6] > '' then commOpsDate   :=StrToDate(strings[6],dtS);   //commOpsDate   :=StrToDate(StringReplace(strings[6], '/', '-', [rfReplaceAll]));
  //TryStrToDate(strings[6], commOpsDate);
  dateElm       :=304;
  Repeat
   Tv[i+8]:=Tv[i+5]-Tv[I+6]+Tv[i+7];
   Strings[i+9]:='1.0000';
   if Tv[i+8]=0 then Strings[i+9]:='';

   Tv[i+10]:=Tv[i+8]*Vl(Strings[i+9]);  //k

   //20250610
   //jz//20260611/VT52 v2 - add percentages for other years and creditRateReduction as per form instructions / CRA cert feedback
   If (Strings[i]>'') then
   begin

    if Strings[dateElm] > '' then
    begin
      CCUSDate := StrToDate(Strings[dateElm],dtS); //TryStrToDate(Strings[dateElm], CCUSDate);

      //after 2021 and before 2036
      if      (CCUSDate > StrToDate('2021/12/31',dtS)) and ( CCUSDate < StrToDate('2036/01/01',dtS)) then
      begin
        if      LeftStr(Strings[i+1],2) =  '01' then  CCUSpercent:= 60
        else if LeftStr(Strings[i+1],2) =  '02' then  CCUSpercent:= 50
        else if LeftStr(Strings[i+1],2) >= '03' then  CCUSpercent:= 37.5;
      end
      //After 2035 and before 2041
      else if (CCUSDate > StrToDate('2035/12/31',dtS)) and ( CCUSDate < StrToDate('2040/12/31',dtS)) then
      begin
        if      LeftStr(Strings[i+1],2) =  '01' then  CCUSpercent:= 30
        else if LeftStr(Strings[i+1],2) =  '02' then  CCUSpercent:= 25
        else if LeftStr(Strings[i+1],2) >= '03' then  CCUSpercent:= 18.75;
      end
      //After 2040
      else if (CCUSDate > StrToDate('2040/12/31',dtS)) then
      begin
                                                      CCUSpercent := 0;
      end
      else
      begin
                                                      CCUSpercent := 0;
      end;
    end
    else //else if no date
      CCUSpercent := 0;

    inc(dateElm,1);

        //Labour requirements apply to specified property prepared or installed after November 27, 2023. If you do not elect to meet the labour requirements
        //in Part 2, you can only claim the CCUS ITC at the reduced tax credit rate, which equals the regular tax credit rate (specified percentage) minus
        //10 percentage points.
    CCUSReduction := 0;
        //do not elect to meet the labour requirements col 1n not sure of the significance of being after date 2023-11-27
    if (Strings[i+13] <> 'Y') and ( CCUSDate > StrToDate('2023/11/27',dtS)) then
      CCUSReduction := 10;

    Strings[i+11] := floattostr(maxR(0,CCUSpercent - CCUSReduction));

   end
   Else
     Strings[i+11]:='';

   Tv[i+12]:=Tv[i+10]*Vl(Strings[i+11])/100;  //m

   if CCUSDate <  commOpsDate     then  Tot1Mbfr:=Tot1Mbfr+Tv[i+12]
                                  else  Tot1Maft:=Tot1Maft+Tv[i+12];

   Inc(i,14);
  Until i>135;

  //total of column 1M for expenditures incurred before the first day of commercial operations plus line 170 of the previous year
      //BUT ALSO, what about this?? -->If the projected eligible use percentage is reduced prior to the first day of commercial operations, recalculate the cumulative CCUS development tax credit for the current year (see subsection 127.44(6))
  //Tv[150]:= tv[314];  //prior yesr  //20260809cz        //ln175

  Tv[149]:= Tot1Mbfr + Tv[314];  //20260809CZ;  Tv[150]; //ln170

  Tv[151]:=MaxR(0,Tv[149]-Tv[150]);
  Tv[152]:=Tot1Maft;
  //TV[153]:=  tpt from T5013's
  //xx:=Tv[152];

  Tv[154]:=Tv[151]+Tv[152]+Tv[153];

  //pg3
  //20260811 Alex >>>
  if UpperCase(Strings[160]).Equals('X') then
  begin
    Tv[164]:=Vl(Strings[163]) * 20;
    Tv[167]:=MaxR(0,Vl(Strings[165]) - Vl(Strings[166])) * 50;
    Tv[169]:=Tv[164]+Tv[167]+Tv[168];
  end else
    for i:= 162 to 169 do
    begin
      Tv[i]:= 0;
      Strings[i]:= '';
    end;
  //20260811 Alex <<<

  Tv[184]:= MaxR(0, Tv[182]-Tv[183]);       //20250918

  Tv[188]:=MaxR(0,Tv[185]-Tv[186]-Tv[187]); //20250918
  Tv[192]:=MaxR(0,Tv[189]-Tv[190]-Tv[191]);

  //pg4
  Tv[182]:=Tv[150];
  Tv[183]:=Tv[149];
  Tv[184]:=MaxR(0,Tv[182]-Tv[183]); //20260809CZ

  xx:=Tv[152];

  //pg6
  i:=193;
  Tot4H:=0;
  Repeat
    if not Strings[i].IsEmpty then Strings[i]:= Copy(Strings[i], 0, 2);             //Get code only //20260518 Alex
    if not Strings[i + 1].IsEmpty then Strings[i + 1]:= Copy(Strings[i + 1], 0, 2); //Get code only //20260518 Alex
   if Tv[i+4]>0 then
     Tv[i+5]:=Tv[i+2] * Tv[I+3]/Tv[i+4]
   else
     Tv[i+5]:=0;
   Tv[i+7]:=MaxR(0,Tv[i+5]-Tv[i+6]);
   Tot4H:=Tot4H+Tv[i+7];
   Inc(i,8);
  Until i>241;

  Tv[250]:=Tot4H;
    //Tv[249]:=  ??
  Tv[252]:=Tv[184]+Tv[188]+Tv[192]
          +TV[249]+Tv[250]+Tv[251];


  xx:=Tv[152];

  //20260811 Alex >>>
  Tv[301]:= AddColumns(268, 298, 5);
  Tv[302]:= AddColumns(269, 299, 5);
  Tv[303]:= AddColumns(270, 300, 5);
  //20260811 Alex <<<

 end; //End with
 SaveTv(RetNo,FName,FNo);
end;

//20260616 Alex >>>
procedure S130(RetNo: Integer;FName: string;FNo: integer);
var
  i: Integer;
  lCol1, lCol2, lCol3, lCol4, lCol5, lCol6, lCol7: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    //Page 1
    Tv[50]:= AddColumns(8, 24, 4); // 20260624 Alex

    //Page 2
    Tv[53]:= AddColumns(27, 47, 5);
    Tv[54]:= AddColumns(28, 48, 5);
    Tv[55]:= AddColumns(29, 49, 5);
    Tv[77]:= AddColumns(59, 74, 5);
    Tv[78]:= AddColumns(60, 75, 5);
    Tv[79]:= AddColumns(61, 76, 5);

    //Page 3
    Tv[96]:= AddColumns(82, 94, 4);
    Tv[97]:= AddColumns(83, 95, 4);
    i:= 100;
    repeat
      lCol3:= i;
      lCol4:= i + 1;
      lCol5:= i + 2;
      lCol6:= i + 3;
      Tv[lCol6]:= Tv[lCol3] - Tv[lCol4] - Tv[lCol5];
      inc(i, 6);
    until i > 124;
    Tv[128]:= AddColumns(103, 127, 6);

    //Page 5
    i:= 151;
    repeat
      lCol2:= i;
      lCol3:= i + 1;
      lCol4:= i + 2;
      lCol5:= i + 3;
      lCol6:= i + 4;
      lCol7:= i + 5;

      Tv[lCol4]:= MaxR(0, Tv[lCol2] + Tv[lCol3]);
      if (Tv[lCol4] > 0) then Tv[lCol5]:= Tv[lCol4] else Tv[lCol5]:= 0;
      if (Tv[lCol6] > Tv[lCol4]) then Tv[lCol6]:= Tv[lCol4];
      Tv[lCol7]:= MaxR(0, Tv[lCol4] - Tv[lCol6]);
      inc(i, 7);
    until i > 179;
    Tv[185]:= AddColumns(154, 182, 7);
    Tv[186]:= AddColumns(155, 183, 7);

    i:= 187;
    repeat
      lCol2:= i;
      lCol3:= i + 1;
      lCol4:= i + 2;
      lCol5:= i + 3;
      lCol6:= i + 4;

      Tv[lCol4]:= MaxR(0, Tv[lCol2] + Tv[lCol3]);
      if (Tv[lCol5] > Tv[lCol4]) then Tv[lCol5]:= Tv[lCol4];
      Tv[lCol6]:= MaxR(0, Tv[lCol4] - Tv[lCol5]);
      inc(i, 5);
    until i > 232;
    Tv[237]:= AddColumns(190, 235, 5);
    //Page 4 //After page 5 calculation, because we need calculation Tv[237] before
    Tv[129]:= Tv[77];
    Tv[132]:= Tv[186];
    Tv[133]:= Tv[237];
    Tv[134]:= Tv[185];
    Tv[135]:= Tv[78];
    Tv[141]:= Tv[128];
    Tv[144]:= AddColumns(129, 143, 1);
    Tv[145]:= Tv[79];
    Tv[148]:= AddColumns(145, 147, 1);
    Tv[149]:= MaxR(0, Tv[144] - Tv[148]);

    //Page 6
    Tv[241]:= Tv[96];
    Tv[246]:= AddColumns(238, 245, 1);
    Tv[247]:= Tv[97];
    Tv[253]:= AddColumns(247, 252, 1);
    Tv[254]:= MaxR(0, Tv[246] - Tv[253]);

    //Page 7
    i:= 257;
    repeat
      lCol2:= i;
      lCol3:= i + 1;
      lCol4:= i + 2;
      lCol5:= i + 3;
      lCol6:= i + 4;

      Tv[lCol4]:= MinR(Tv[lCol2], Tv[lCol3]);
      Tv[lCol6]:= Tv[lCol5] * Tv[lCol4] / IfThen(Tv[lCol2] <> 0, Tv[lCol2], 1);
      inc(i, 6);
    until i > 281;
    Tv[286]:= AddColumns(261, 285, 6);

    Tv[287]:=Ret[RetNo].Lnn[300];  //
    //Page 8                            72202607
    Tv[291]:= AddColumns(288, 290, 1); //20260730 Alex
    Tv[292]:= Tv[291];
    Tv[293]:= Tv[287] - Tv[292];
    Tv[294]:= Tv[149];
    Tv[300]:= Tv[286];
    Tv[303]:= Tv[55];
    Tv[307]:= AddColumns(294, 306, 1);

    //Page 9
    Tv[308]:= Tv[254];
    Tv[316]:= Tv[54];
    Tv[318]:= AddColumns(308, 317, 1);
    Tv[319]:= MaxR(0, Tv[293] + Tv[307] - Tv[318]);

    //Page 10
    Tv[320]:= Tv[319];
    Tv[322]:= Tv[320] * Tv[321];
    Tv[323]:= Tv[322];
    Tv[324]:= Tv[254];
    Tv[327]:= MinR(Tv[325], Tv[326]);
    Tv[329]:= Tv[327] * Tv[328];
    Tv[330]:= Tv[329];
    Tv[331]:= MaxR(0, Tv[324] - Tv[330]);
    Tv[332]:= Tv[331];
    Tv[333]:= Tv[323] + Tv[332];
    Tv[334]:= Tv[149];
    Tv[335]:= MaxR(0, Tv[333] - Tv[334]);

    //Page 11
    i:= 351;
    repeat
      lCol1:= i;
      lCol2:= i + 1;
      lCol3:= i + 2;
      lCol4:= i + 3;

      Tv[lCol4]:= MaxR(0, Tv[lCol1] - Tv[lCol2] - Tv[lCol3]);
      inc(i, 4);
    until i > 359;
    Tv[363]:= AddColumns(354, 362, 4);

    Tv[364]:= Tv[337];
    Tv[365]:= Tv[363] + Tv[364];
    Tv[366]:= Tv[365];

    Tv[369]:= Vl(FetchElm(RetNo, 'S4', 50)); // 20260624 Alex
    Tv[370]:= Tv[335];
    Tv[371]:= Tv[50];
    Tv[372]:= Tv[370] + Tv[371];
    Tv[376]:= Tv[372];
    Tv[373]:= MinR(Tv[369], Tv[376]);

    //Page 10. Continue
    Tv[336]:= Tv[373];
    Tv[337]:= MaxR(0, Tv[335] - Tv[336]);

    Tv[338]:= Tv[366];
    Tv[339]:= Tv[149];
    Tv[341]:= Tv[319];
    Tv[343]:= Tv[341] * Tv[342];
    Tv[344]:= Tv[343];
    Tv[345]:= Tv[254];
    Tv[346]:= IfThen(Tv[340] <> 0, Tv[340], Tv[344]) + Tv[345];
    Tv[347]:= Tv[346];
    Tv[348]:= MaxR(0, Tv[339] - Tv[347]);
    Tv[349]:= Tv[348];
    Tv[350]:= MinR(Tv[338], Tv[349]);

    //Page 11. Continue
    Tv[367]:= Tv[350];
    Tv[368]:= MaxR(0, Tv[366] - Tv[367]);

    //Page 12
    Tv[374]:= Tv[149];
    Tv[377]:= Tv[319];
    Tv[379]:= Tv[377] * Tv[378];
    Tv[380]:= Tv[379];
    Tv[381]:= IfThen(Tv[375] <> 0, Tv[375], Tv[380]);
    Tv[382]:= Tv[254];
    Tv[383]:= Tv[50];
    Tv[384]:= Tv[373];
    Tv[385]:= MaxR(0, Tv[383] - Tv[384]);
    Tv[386]:= Tv[385];
    Tv[387]:= Tv[350];
    Tv[388]:= Tv[381] + Tv[382] + Tv[386] + Tv[387];
    Tv[389]:= Tv[374] - Tv[388];
    Tv[390]:= Tv[144];
    Tv[392]:= IfThen(Tv[390] <> 0, Tv[390], Tv[391]);
    Tv[393]:= MaxR(0, Tv[389] / Tv[392]);

    Tv[394]:= Tv[144];
    Tv[395]:= Tv[128];
    Tv[396]:= Tv[143];
    Tv[397]:= MaxR(0, Tv[394] - Tv[395] - Tv[396]);
    Tv[398]:= Tv[397];
    Tv[399]:= Tv[393] * Tv[398];

    //Page 13
    i:= 401;
    repeat
      lCol1:= i - 1;
      lCol2:= i;
      lCol3:= i + 1;
      lCol4:= i + 2;
      lCol5:= i + 3;
      lCol6:= i + 4;

      if (Tv[lCol2] <> 0) then Tv[lCol3]:= Tv[393] else Tv[lCol3]:= 0;

      Tv[lCol4]:= Tv[lCol2] * Tv[lCol3];
      Tv[lCol6]:= Tv[lCol4] * (Tv[lCol5]{ / 100});
      inc(i, 6);
    until i > 425;
    Tv[451]:= AddColumns(405, 429, 6);

    i:= 431;
    repeat
      lCol2:= i;
      lCol3:= i + 1;
      lCol4:= i + 2;

      if (Tv[lCol2] <> 0) then Tv[lCol3]:= Tv[393] else Tv[lCol3]:= 0;

      Tv[lCol4]:= Tv[lCol2] * (Tv[lCol3]{ / 100});
      inc(i, 6);
    until i > 447;
    Tv[450]:= AddColumns(433, 449, 6);

    //Page 14
    Tv[452]:= Tv[128];
    Tv[453]:= Tv[393];
    Tv[454]:= Tv[452] * Tv[453];
    Tv[455]:= Tv[399];
    Tv[456]:= Tv[454];
    Tv[457]:= Tv[451];
    Tv[458]:= Tv[450];
    Tv[459]:= AddColumns(455, 458, 1);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260616 Alex <<<
//20250614
procedure T2184(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  Strings[1] := GetCorpName(RetNo);
  Strings[2] := GetBN(RetNo);
  Strings[3] := FetchElmFNo(RetNo,T2FNo,12);  //street
  Strings[4] := FetchElmFNo(RetNo,T2FNo,16);  //City
  Strings[5] := FetchElmFNo(RetNo,T2FNo,17);  //Prov
  Strings[6] := FetchElmFNo(RetNo,T2FNo,20);  //Postal
  Tv[15]:=MaxR(0,Tv[12]-Tv[14]);
  Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


//========================================================



(*OLD
//20191012
procedure S71(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //pg1
   FillHeader(RetNo,FNo,1,2,3);

   //part 1
   //If Strings[6]+Strings[7]='' then Strings[7]:='X'; //jz 2019 removed


   {
   <-- jz 2019 removed
       Tv[14]:=Tv[12]+Tv[13];
       Tv[15]:=Tv[14];
       Tv[17]:=MinR(Tv[16],Tv[17]);
       Tv[18]:=Tv[16]+Tv[17];
       Tv[19]:=Tv[18];
       Tv[20]:=Tv[15]+Tv[19];
       Tv[22]:=MaxR(0,Tv[20]-Tv[21]);
   -->
   }

   //part 2
   Tv[25]:=Tv[23]+Tv[24];
   Tv[26]:=Tv[25];
   Tv[29]:=MaxR(0,Tv[27]-Tv[28]);   //20130925
   Tv[30]:=Tv[29];

   Tv[31]:=Tv[26]+Tv[30];     //20130919


   //jz 2019 ????
   //20160621
   //Proportion
 //  Tv[112]:=0;Tv[113]:=0;Tv[114]:=0;  //20191013 con

   //20121025
   // If Strings[10]<GetTaxationYearStart(RetNo) then Strings[32]:=GetTaxationYearStart(RetNo) else Strings[32]:=Strings[10];
   // If Strings[11]>GetTaxationYearEnd(RetNo) then Strings[33]:=GetTaxationYearEnd(RetNo) else Strings[33]:=Strings[11];


    //20121025
    // If Strings[10]<GetTaxationYearStart(RetNo) then Strings[32]:=GetTaxationYearStart(RetNo) else Strings[32]:=Strings[10];
    // If Strings[11]>GetTaxationYearEnd(RetNo) then Strings[33]:=GetTaxationYearEnd(RetNo) else Strings[33]:=Strings[11];

    // Strings[34]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[32]),YYYYMMDDToMMDDYYYY(Strings[33]))); //20150703
    //Strings[35]:=
//Strings[35]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[10]),YYYYMMDDToMMDDYYYY(Strings[11])));

   Strings[34]:=IntToStr(DateDiffYMD(Strings[32],Strings[33]));
   if Vl(Strings[34])<0 then Strings[34]:='';   //20230111
   
   Strings[36]:=Strings[34];  //20160605 //jz 2019 ??? why?
   If Vl(Strings[35])>0 then Strings[36]:=FormatFloat('##.#######',Vl(Strings[34])/Vl(Strings[35]));
   Tv[37]:=Tv[31] * Vl(Strings[36]);

   Tv[40]:=Tv[38]+Tv[39];
   Tv[41]:=Tv[40];
   Tv[42]:=Maxr(0,Tv[37]-Tv[41]);


   //part 3
   If Vl(Strings[46])>0 then Strings[47]:=FloatToStr(Vl(Strings[45])/Vl(Strings[46]));
   Tv[48]:=Round(Tv[44]*Vl(Strings[47]));
   Tv[49]:=MinR(Tv[43],Tv[48]);

   //jz 2019 removed
   // <-- ----------------------------------------------------------------------
   {
         //part 5 QTI -------------------
         Tv[50]:=Tv[22];
         //  Tv[51]:=Tv[42];       //201309/17
         Tv[52]:=Tv[50]+Tv[51];

         //part 6 transitional income  ---------------------
        Tv[55]:=Tv[53]+Tv[54];
        Tv[56]:=Tv[55];
        Tv[59]:=Tv[57]+Tv[58];
        Tv[60]:=Tv[59];
        Tv[61]:=Tv[56]+Tv[60]; //20121219

        If Vl(Strings[63])>0 then Strings[64]:=FloatToStr(Vl(Strings[62]) /Vl(Strings[63]));
        Tv[65]:=Tv[61] * Vl(Strings[64]);
        Tv[67]:=MaxR(0,Tv[65]-Tv[66]);
        Tv[69]:=Tv[67]+Tv[68];

        //part 7 transitional reserve  -----------------------
        If Vl(Strings[71])>100 then Tv[71]:=100;
        Tv[72]:=Tv[70] * Tv[71]/100;
        Tv[74]:=Tv[69];
        Tv[76]:=Tv[74]+Tv[75];
        Tv[77]:=Tv[76];
        Tv[78]:=Tv[73]+Tv[77];
        Tv[79]:=Tv[78];
        //tv[81]:=?
        // If Tv[82]=0 then Tv[82]:=MinR(Tv[82],Tv[81]); //20121219

-----------------------------------------------------------------------
   //--> }

   //part 4
   Tv[85]:=MaxR(0,Tv[83]-Tv[84]);  //20121219
   Tv[86]:=Tv[85];

   Tv[89]:=MaxR(0,Tv[87]-Tv[88]);    //20121219
   Tv[90]:=Tv[89];
   Tv[91]:=Tv[86]+Tv[90];

   If Vl(Strings[93])>0 then Strings[94]:=FloatToStr(Vl(Strings[92]) /Vl(Strings[93]));
   Tv[95]:=Tv[91]*vl(Strings[94]);
   Tv[97]:=Tv[95]-Tv[96];

   Tv[100]:=Tv[98]+Tv[99];
   Tv[101]:=MinR(Tv[97],Tv[100]);
   Tv[102]:=Tv[101]+Tv[98];
   Tv[104]:=Tv[102]*Vl(Strings[103]);

   Tv[107]:=Tv[104]*vl(Strings[106])/100;

   Tv[108]:=Tv[101] * Vl(Strings[103]);
   Tv[109]:=Tv[108]*Vl(Strings[106]);
   Tv[110]:=Tv[109] * 25/100;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)

(*20191012
procedure S71(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //pg1
   FillHeader(RetNo,FNo,1,2,3);
   If Strings[6]+Strings[7]='' then Strings[7]:='X';
   //pg2
   Tv[14]:=Tv[12]+Tv[13];
   Tv[15]:=Tv[14];
   Tv[17]:=MinR(Tv[16],Tv[17]);
   Tv[18]:=Tv[16]+Tv[17];
   Tv[19]:=Tv[18];
   Tv[20]:=Tv[15]+Tv[19];
   Tv[22]:=MaxR(0,Tv[20]-Tv[21]);

   Tv[25]:=Tv[23]+Tv[24];
   Tv[26]:=Tv[25];
   Tv[29]:=MaxR(0,Tv[27]-Tv[28]);   //20130925
   Tv[30]:=Tv[29];

   Tv[31]:=Tv[26]+Tv[30];     //20130919

   //20160621
   //Proportion
   Tv[112]:=0;Tv[113]:=0;Tv[114]:=0;
   if Tv[31]>0 then
   Begin
   {
    Strings[112]:=FormatFloat('##0.00000',100*Tv[23]/Tv[31]);
    Strings[113]:=FormatFloat('##0.00000',100*Tv[27]/Tv[31]);
    Strings[114]:=FormatFloat('##0.00000',100*Tv[28]/Tv[31]);
    }
   End;

     //20121025
  // If Strings[10]<GetTaxationYearStart(RetNo) then Strings[32]:=GetTaxationYearStart(RetNo) else Strings[32]:=Strings[10];
  // If Strings[11]>GetTaxationYearEnd(RetNo) then Strings[33]:=GetTaxationYearEnd(RetNo) else Strings[33]:=Strings[11];


   Strings[34]:=IntToStr(DateDiffYMD(Strings[32],Strings[33]));
   Strings[36]:=Strings[34];  //20160605
   //20121025
  // If Strings[10]<GetTaxationYearStart(RetNo) then Strings[32]:=GetTaxationYearStart(RetNo) else Strings[32]:=Strings[10];
  // If Strings[11]>GetTaxationYearEnd(RetNo) then Strings[33]:=GetTaxationYearEnd(RetNo) else Strings[33]:=Strings[11];

  // Strings[34]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[32]),YYYYMMDDToMMDDYYYY(Strings[33])));  //20150703
   //Strings[35]:=
   //Strings[35]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[10]),YYYYMMDDToMMDDYYYY(Strings[11])));
   If Vl(Strings[35])>0 then Strings[36]:=FormatFloat('##.#######',Vl(Strings[34])/Vl(Strings[35]));
   Tv[37]:=Tv[31] * Vl(Strings[36]);

   //pg3
   Tv[40]:=Tv[38]+Tv[39];
   Tv[41]:=Tv[40];
   Tv[42]:=Maxr(0,Tv[37]-Tv[41]);
   //pg4
   If Vl(Strings[46])>0 then Strings[47]:=FloatToStr(Vl(Strings[45])/Vl(Strings[46]));
   Tv[48]:=Round(Tv[44]*Vl(Strings[47]));
   Tv[49]:=MinR(Tv[43],Tv[48]);


   Tv[50]:=Tv[22];
 //  Tv[51]:=Tv[42];       //201309/17
   Tv[52]:=Tv[50]+Tv[51];

   //pg5
   Tv[55]:=Tv[53]+Tv[54];
   Tv[56]:=Tv[55];
   Tv[59]:=Tv[57]+Tv[58];
   Tv[60]:=Tv[59];
   Tv[61]:=Tv[56]+Tv[60]; //20121219

   If Vl(Strings[63])>0 then Strings[64]:=FloatToStr(Vl(Strings[62]) /Vl(Strings[63]));
   Tv[65]:=Tv[61] * Vl(Strings[64]);
   Tv[67]:=MaxR(0,Tv[65]-Tv[66]);
   Tv[69]:=Tv[67]+Tv[68];

   //pg6
   If Vl(Strings[71])>100 then Tv[71]:=100;
   Tv[72]:=Tv[70] * Tv[71]/100;
   Tv[74]:=Tv[69];
   Tv[76]:=Tv[74]+Tv[75];
   Tv[77]:=Tv[76];
   Tv[78]:=Tv[73]+Tv[77];
   Tv[79]:=Tv[78];
   //tv[81]:=?
  // If Tv[82]=0 then Tv[82]:=MinR(Tv[82],Tv[81]);   //20121219

   //Pg7
   Tv[85]:=MaxR(0,Tv[83]-Tv[84]);  //20121219
   Tv[86]:=Tv[85];
   Tv[89]:=MaxR(0,Tv[87]-Tv[88]);    //20121219
   Tv[90]:=Tv[89];
   Tv[91]:=Tv[86]+Tv[90];
   If Vl(Strings[93])>0 then Strings[94]:=FloatToStr(Vl(Strings[92]) /Vl(Strings[93]));
   Tv[95]:=Tv[91]*vl(Strings[94]);
   Tv[97]:=Tv[95]-Tv[96];

   //pg8
   Tv[100]:=Tv[98]+Tv[99];
   Tv[101]:=MinR(Tv[97],Tv[100]);
   Tv[102]:=Tv[101]+Tv[98];
   Tv[104]:=Tv[102]*Vl(Strings[103]);

   Tv[107]:=Tv[104]*vl(Strings[106])/100;

   Tv[108]:=Tv[101] * Vl(Strings[103]);
   Tv[109]:=Tv[108]*Vl(Strings[106]);
   Tv[110]:=Tv[109] * 25/100;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)
(*
procedure S71(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //pg1
   FillHeader(RetNo,FNo,1,2,3);
   If Strings[6]+Strings[7]='' then Strings[7]:='X';
   //pg2
   Tv[14]:=Tv[12]+Tv[13];
   Tv[15]:=Tv[14];
   Tv[17]:=MinR(Tv[16],Tv[17]);
   Tv[18]:=Tv[16]+Tv[17];
   Tv[19]:=Tv[18];
   Tv[20]:=Tv[15]+Tv[19];
   Tv[22]:=MaxR(0,Tv[20]-Tv[21]);

   Tv[25]:=Tv[23]+Tv[24];
   Tv[26]:=Tv[25];
   Tv[29]:=Tv[27]+Tv[28];
   Tv[30]:=Tv[29];

   Tv[31]:=Tv[26]-Tv[30];

   //20121025
  // If Strings[10]<GetTaxationYearStart(RetNo) then Strings[32]:=GetTaxationYearStart(RetNo) else Strings[32]:=Strings[10];
  // If Strings[11]>GetTaxationYearEnd(RetNo) then Strings[33]:=GetTaxationYearEnd(RetNo) else Strings[33]:=Strings[11];

   Strings[34]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[32]),YYYYMMDDToMMDDYYYY(Strings[33])));
   //Strings[35]:=
   //Strings[35]:=IntToStr(DateDiff(YYYYMMDDToMMDDYYYY(Strings[10]),YYYYMMDDToMMDDYYYY(Strings[11])));
   If Vl(Strings[35])>0 then Strings[36]:=FormatFloat('##.####',Vl(Strings[34])/Vl(Strings[35]));
   Tv[37]:=Tv[31] * Vl(Strings[36]);

   //pg3
   Tv[40]:=Tv[38]+Tv[39];
   Tv[41]:=Tv[40];
   Tv[42]:=Maxr(0,Tv[37]-Tv[41]);
   //pg4
   If Vl(Strings[46])>0 then Strings[47]:=FloatToStr(Vl(Strings[45])/Vl(Strings[46]));
   Tv[48]:=Round(Tv[44]*Vl(Strings[47]));
   Tv[49]:=MinR(Tv[43],Tv[48]);


   Tv[50]:=Tv[22];
   Tv[51]:=Tv[42];
   Tv[52]:=Tv[50]+Tv[51];

   //pg5
   Tv[55]:=Tv[53]+Tv[54];
   Tv[56]:=Tv[55];
   Tv[59]:=Tv[57]+Tv[58];
   Tv[60]:=Tv[59];

   If Vl(Strings[63])>0 then Strings[64]:=FloatToStr(Vl(Strings[62]) /Vl(Strings[63]));
   Tv[65]:=Tv[61] * Vl(Strings[64]);
   Tv[67]:=MaxR(0,Tv[65]-Tv[66]);
   Tv[69]:=Tv[67]+Tv[68];

   //pg6
   If Vl(Strings[71])>100 then Tv[71]:=100;
   Tv[72]:=Tv[70] * Tv[71]/100;
   Tv[74]:=Tv[69];
   Tv[76]:=Tv[74]+Tv[75];
   Tv[77]:=Tv[76];
   Tv[78]:=Tv[73]+Tv[77];
   Tv[79]:=Tv[78];
   //tv[81]:=?
   If Tv[82]=0 then Tv[82]:=MinR(Tv[82],Tv[81]);

   //Pg7
   Tv[85]:=Tv[83]+Tv[84];
   Tv[86]:=Tv[85];
   Tv[89]:=Tv[87]+Tv[88];
   Tv[90]:=Tv[89];
   Tv[91]:=Tv[86]+Tv[90];
   If Vl(Strings[963])>0 then Strings[94]:=FloatToStr(Vl(Strings[92]) /Vl(Strings[93]));
   Tv[95]:=Tv[91]*vl(Strings[94]);
   Tv[97]:=Tv[95]-Tv[96];

   //pg8
   Tv[100]:=Tv[98]+Tv[99];
   Tv[101]:=MinR(Tv[97],Tv[100]);
   Tv[102]:=Tv[101]+Tv[98];
   Tv[104]:=Tv[102]*Vl(Strings[103]);

   Tv[107]:=Tv[104]*Tv[106]/100;

   Tv[108]:=Tv[101] * Tv[106]/100;
   Tv[109]:=Tv[108]*Tv[106]/100;
   Tv[110]:=Tv[109] * 25/100;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)
//20260520 Alex >>>
procedure S72(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    //Page 2
    Tv[10]:= Tv[8] - Tv[9];
    Tv[11]:= Tv[10];
    if (Tv[13] > Tv[12]) then Tv[13]:= Tv[12];
    Tv[14]:= Tv[12] - Tv[13];
    Tv[15]:= Tv[14];
    Tv[16]:= Tv[11] + Tv[15];
    Tv[19]:= Tv[17] / IfThen(Tv[18] <> 0, Tv[18], 1);
    Tv[20]:= Tv[16] * Tv[19];
    Tv[23]:= Tv[21] + Tv[22];
    Tv[24]:= Tv[23];
    Tv[25]:= MaxR(0, Tv[20] - Tv[24]);

    //Page 3
    Tv[29]:= Tv[28] / IfThen(Tv[30] <> 0, Tv[30], 1);
    Tv[31]:= Tv[27] * Tv[29];
    Tv[32]:= Tv[31];
    Tv[24]:= Tv[23];
    Tv[33]:= MinR(Tv[26], Tv[32]);

    Tv[36]:= Tv[34] - Tv[35];
    Tv[37]:= Tv[36];
    if (Tv[39] > Tv[38]) then Tv[39]:= Tv[38];
    Tv[40]:= Tv[38] - Tv[39];
    Tv[41]:= Tv[40];
    Tv[42]:= Tv[37] + Tv[41];
    Tv[45]:= Tv[43] / IfThen(Tv[44] <> 0, Tv[44], 1);
    Tv[46]:= Tv[42] * Tv[45];
    Tv[47]:= Tv[21];
    Tv[48]:= Tv[46] - Tv[47];

    //Page 4
    Tv[49]:= Tv[25];
    Tv[50]:= Tv[22];
    Tv[51]:= MaxR(0, Tv[49] + Tv[50]);
    Tv[52]:= MinR(Tv[48], Tv[51]);
    Tv[53]:= Tv[52] - Tv[49];
    Tv[55]:= Tv[53] * Tv[54];
    Tv[57]:= Tv[55] * Tv[56];
    Tv[58]:= Tv[52] * Tv[54];
    Tv[59]:= Tv[58] * Tv[56];
    Tv[60]:= MaxR(0, Tv[59] * 0.25);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260520 Alex <<<
(*OLD
procedure S73(RetNo: integer;FName: string;FNo: integer);
Var i,j,k,k1:integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);

  //20230111 //clien it up
  i:=4;
  With Ret[RetNo].Frm[FNo] do
  Begin
    Repeat
     For k:=0 to 3 do begin Strings[i+k]:='';End; //keep only last column Tiered
     Inc(i,6);
   Until i>118;
   For i:=124 to 438 do begin  Strings[i]:='';Tv[i]:=0;end; //clean it up 20230111
   //For i:=4 to 438 do begin  Strings[i]:='';Tv[i]:=0;end; //clean it up 20230111
  end;

  //populate from S71
  k:=0;
  K1:=0;
  for i :=0 to (FList.Count - 1) do
  begin
  FRec := FList.Items[i];
   If (Frec.FormName='S71') and (Ret[RetNo].FrmHasData[Frec.FormNo]) then
   Begin
     Strings[k+4]:=FetchElmFNo(RetNo,Frec.FormNo,5); //account
     Strings[k+5]:=FetchElmFNo(RetNo,Frec.FormNo,4); //name
     //20191019 ???  depends on S71 ???
     Strings[k+7]:=FetchElmFNo(RetNo,Frec.FormNo,10);
     Strings[k+8]:=FetchElmFNo(RetNo,Frec.FormNo,11);

     Strings[k1+124]:=FetchElmFNo(RetNo,Frec.FormNo,5);
     Tv[k1+125]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,37));
     Tv[k1+126]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,38));
     Tv[k1+127]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,39));
     Tv[k1+128]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,42));
     Tv[k1+129]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,105));
     Tv[k1+130]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,49));

     //part 2
     {
     Strings[k+271]:=FetchElmFNo(RetNo,Frec.FormNo,5);
     Tv[k+273]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,22));
     Tv[k+274]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,52));
     Tv[k+275]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,69));
     Tv[k+276]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,82));
     Tv[k+277]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,73));
     }
     Strings[k+439]:=FetchElmFNo(RetNo,Frec.FormNo,5);
     Tv[k+440]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,107));
     Tv[k+441]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,110));

     Inc(k,6);  //20230111
     Inc(k1,7);  //20230111
    // Tv[502]:=Vl(FetchElmFNo(RetNo,Frec.FormNo,Tv[K112)) * Vl(
  end; //if S71

  end;


   For i:=265 TO 270 do begin Tv[i]:=0;end;  //init

   i:=125;
   Repeat
    Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
    Tv[265]:=Tv[265]+Tv[i];
    Tv[266]:=Tv[266]+Tv[i+1];
    Tv[267]:=Tv[267]+Tv[i+2];
    Tv[268]:=Tv[268]+Tv[i+3];
    Tv[269]:=Tv[269]+Tv[i+4];
    Tv[270]:=Tv[270]+Tv[i+5];
    Inc(i,7)
   until i>258;

   For i:=432 TO 438 do begin Tv[i]:=0;end;  //init
   j:=128; //col 4
   i:=272; //col 7
   k:=278; //col 13
   Repeat
     //col k= 4,6,12 minus col 5,7,11
     Tv[k]:=Round(Tv[j]+Tv[j+2]+Tv[k-1]-(Tv[J+1]+Tv[i]+Tv[k-2])); //20160612
    {
    k:=i+6; //278
    Tv[k]:=Tv[k-150]+Tv[k-148]+Tv[k-1]-Tv[k-149]-Tv[k-6]-Tv[k-2]; //20141202
    //Tv[k-150]+Tv[k-1]+Tv[k-149]-Tv[k-149]-Tv[k-6]-Tv[k-2];
    //20141202 add col 4,6,12 minus col 5,7,11 //add col 4,6,12 minus col 5,7,12
     }
    Tv[432]:=Tv[432]+Tv[i];
    {
    Tv[433]:=Tv[433]+Tv[i+1];
    Tv[434]:=Tv[434]+Tv[i+2];
    Tv[435]:=Tv[435]+Tv[i+3];
    Tv[436]:=Tv[436]+Tv[i+4];
    Tv[437]:=Tv[437]+Tv[i+5];
    }
    Tv[438]:=Tv[438]+Tv[i+6];
    Inc(i,8);
    Inc(k,8);
    Inc(j,7);
   until i>424;
   For i:=500 TO 501 do begin Tv[i]:=0;end;  //init

   //Page 3
   i:=440;
   Repeat
    Tv[500]:=Tv[500]+Tv[i];
    Tv[501]:=Tv[501]+Tv[i+1];
    Inc(i,3);
   until i>497;

   Tv[505]:=Tv[500];
   Tv[506]:=Tv[505];
   Tv[507]:=MinR(Tv[500],Tv[501]);
   Tv[508]:=MaxR(0,Tv[505]-Tv[507]);
   Tv[509]:=RounD(Tv[508]*0.50);
   Tv[510]:=Tv[506]+Tv[509];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;
*)




Procedure S75(RetNo: Integer; FName: string; FNo: Integer);
Var
  i,j: Integer;
  lFormNo: Integer; //20260508 Alex
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo,FNo,1,2,3);

    //Page 2 - Part 1 --------- Page 2 - Part 1 --------- Page 2 - Part 1 ---------
    i:= 76;
    j:= 25;
    Repeat
      Tv[i]   := Tv[j] - Tv[j+1] + Tv[j+2]; //line 140

      //line 145
      if      (strings[j-2] > '2023/03/27') and (strings[j-2] < '2034/01/01') then
        strings[i+1] := '30' //Tv[i+1] := 30; //until 2034
      else if (strings[j-2] > '2033/12/31') and (strings[j-2] < '2035/01/01') then
        strings[i+1] := '15' //Tv[i+1] := 15; //in 2034
      else //if strings[j-2] > '2034/01/01'                                     then
        strings[i+1] := '0';  //Tv[i+1] := 0;  //after 2034

      //SHOWMESSAGE(inttostr(j-2) + ' ' + strings[j-2]);

      Tv[i+2] := Round(Tv[i] * (vl(strings[i+1]) / 100)); //line 150
      inc(i,4);
      inc(j,6);
    until i>96;

    Tv[184] := AddColumns(78,98,4); // line A
    //20260508 Alex >>>
    {Tv[185]:= 0; // line 160
    for i:= 1 to 10 do
    begin
      lFormNo:= GetFormNo('T5013#' + IntToStr(i)); //T5013 in the T2 module???
      If lFormNo > 0 then
       Tv[185]:= Tv[185] + Vl(FetchElmFNo(RetNo, lFormNo, ???));
    end;}
    //20260508 Alex <<<
    Tv[186] :=  Tv[184] + Tv[185];   // line 165

    //Page 2 - Part 2 --------- Page 2 - Part 2 --------- Page 2 - Part 2 ---------
    //20260811 Alex >>>
    i:= 118;
    Repeat
      //line 130
      //if Tv[i-1] > 0 then Tv[i]:= Tv[i-2] / Tv[i-1] else Tv[i]:= 0;
      if (Tv[i - 1] > 0) then Tv[i]:= Tv[i - 3] * (Tv[i - 2] / Tv[i - 1]) else Tv[i]:= 0;
      Tv[i + 1]:= MinR(Tv[i - 3], Tv[i]); //line 235
      inc(i, 6);
    until i > 148;

    Tv[187]:= AddColumns(119, 148, 6); // line B
    //20260811 Alex <<<
    //Tv[168] := ?? // line 240
    Tv[169] :=  Tv[187] + Tv[168];   // line 245

    //Page 3 - Part 4 --------- Page 3 - Part 4 --------- Page 3 - Part 4 ---------
    //20260811 Alex >>>
    if UpperCase(Strings[16]).Equals('X') then
    begin
      Tv[178]:= Round(vl(strings[177]) * 20);                    //line C
      Tv[181]:= MaxR(0, (vl(strings[66]) - vl(strings[180])) * 50); //line D //20260508 Alex
      //Tv[182] := ; //??? //line 425
      Tv[183]:= Tv[178] + Tv[181] + Tv[182];     //line 430
    end else
    for i:= 176 to 183 do
    begin
      Tv[i]:= 0;
      Strings[i]:= '';
    end;
    //20260811 Alex <<<
    //20260508 Alex >>>
    Tv[67]:= 0;
    Tv[68]:= 0;
    Tv[69]:= 0;
    i:= 202;
    repeat
      Tv[67]:= Tv[67] + Tv[i];
      Tv[68]:= Tv[68] + Tv[i + 1];
      Tv[69]:= Tv[69] + Tv[i + 2];
      inc(i, 5);
    until i > 227;
    //20260508 Alex <<<
  end; { end with }
  SaveTv(RetNo, FName, FNo);
end;

//20260508 Alex >>>
procedure S77(RetNo: Integer; FName: string; FNo: Integer);
var
  i, j: Integer;
  lFormNo: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    //Page 1
    FillHeader(RetNo, FNo, 1, 2, 3);

    if (Strings[4] + Strings[5] = '') then Strings[5]:= 'X';
    if (Strings[8] + Strings[9] = '') then Strings[9]:= 'X';

    //Page 2
    i:= 12;
    repeat
      if not Strings[i].IsEmpty then Strings[i]:= Copy(Strings[i], 0, 2); //Get code only
      inc(i, 13);
    until i > 64;

    i:= 19;
    j:= 16;
    repeat
      Tv[i]:= Tv[j] - Tv[j + 1] + Tv[j + 2]; //line 140

      if (Strings[j - 2] > '2023/03/27') and (Strings[j - 2] < '2034/01/01') then Strings[i + 1]:= '30' else //line 145
      if (Strings[j - 2] > '2033/12/31') and (Strings[j - 2] < '2035/01/01') then Strings[i + 1]:= '15' else Strings[i + 1]:= '0'; //line 145

      Tv[i + 2]:= Round(Tv[i] * (vl(strings[i + 1]) / 100)); //line 150
      inc(i, 13);
      inc(j, 13);
    until i > 71;

    Tv[75]:= AddColumns(21, 73, 13); // line A
    Tv[77]:= Tv[75] + Tv[76];

    //Page 3
    if (Strings[83] + Strings[84] = '') then Strings[84]:= 'X';
    Tv[87]:= Round(Vl(Strings[86]) * 20);
    Tv[90]:= MaxR(0, (vl(strings[88]) - vl(strings[89])) * 50); //line 330
    //Tv[182] := ; //??? //line 335
    Tv[92]:= Tv[87] + Tv[90] + Tv[91]; //line 340

    //Page 4
    i:= 110;
    repeat
      if not Strings[i].IsEmpty then Strings[i]:= Copy(Strings[i], 0, 2); //Get code only
      inc(i, 12);
    until i > 170;

    i:= 119;
    j:= 113;
    repeat
      Tv[i]:= Tv[j] - Tv[j + 1]; //line 535
      Tv[i + 1]:= Round(Tv[i] * Tv[j + 2] / IfThen(Tv[i - 1] <> 0, Tv[i - 1], 1)); //line 540
      inc(i, 12);
      inc(j, 12);
    until i > 179;
    Tv[181]:= AddColumns(120, 180, 12); // line B
    Tv[183]:= Tv[181] + Tv[182];

    //Page 5
    i:= 192;
    repeat
      Tv[i]:= Tv[i - 2] - Tv[i - 1]; //line 655
      inc(i, 6);
    until i > 222;
    Tv[223]:= AddColumns(192, 222, 6); // line C
    Tv[225]:= Tv[223] + Tv[224];

    Tv[262]:= AddColumns(228, 258, 6); //750
    Tv[263]:= AddColumns(229, 259, 6); //755
    Tv[264]:= AddColumns(230, 260, 6); //760
    Tv[265]:= AddColumns(231, 261, 6); //765
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260508 Alex <<<

//20150508  John's
procedure S423(RetNo: integer;FName: string;FNo: integer);  //t1197
Var i,j,k:integer;PhotoBegins:String;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
    FillHeader(RetNo,FNo,1,2,13);
    Photobegins:=Strings[30];  //20170524
    If Strings[6] = '' then
    begin
     Strings[6] := FetchElm(RetNo,'T2',743)+' '
                   +FetchElm(RetNo,'T2',742);  {contact}
     If FetchElm(RetNo,'T2',749) >'' then  Strings[6] := FetchElm(RetNo,'T2',749);
    end;
    If Strings[7] = '' then
    begin
     Strings[7] := FetchElm(RetNo,'T2',755)+' '
                   +FormatPhoneForRsi(FetchElm(RetNo,'T2',746));  {phone}
     If FetchElm(RetNo,'T2',750) >'' then
            Strings[7] := FetchElm(RetNo,'T2',756)+' '
                          +FetchElm(RetNo,'T2',750);
    end;

    If Strings[15]+Strings[16]='' then Strings[16] :='X';
    If Strings[33]+Strings[34]='' then Strings[34] :='X';
    If Strings[19]+Strings[20]='' then Strings[20] :='X';
    If Strings[21]+Strings[22]='' then Strings[22] :='X';
    If Strings[23]+Strings[24]='' then Strings[24] :='X';
    If Strings[25]+Strings[26]='' then Strings[26] :='X';
    If Strings[27]+Strings[28]='' then Strings[28] :='X';

    //p2
    Tv[37]:=Tv[17]+Tv[12]+Tv[4]+Tv[36];
    Tv[38]:=Tv[37];
    Tv[3]:=Tv[18]+Tv[38]+Tv[5];
    Tv[8]:=Tv[3]+Tv[39];
    Tv[40]:=Tv[9]+Tv[10]+Tv[11];
    Tv[41]:=Tv[40];
    Tv[32]:=MaxR(0,Tv[8]-Tv[41]);

    //If Strings[30]>'2010/02/28' then Tv[42]:=Tv[32]; //jz line removed

    //p3
    Tv[48]:=Tv[44]+Tv[45]+Tv[46]+Tv[47];
    Tv[49]:=Tv[48];
    Tv[51]:=Tv[43]+Tv[49]+Tv[50];
    Tv[53]:=Tv[51]+Tv[52];
    Tv[57]:=Tv[54]+Tv[55]+Tv[56];
    Tv[58]:=Tv[57];
    Tv[59]:=MaxR(0,Tv[53]-Tv[58]);

    //20250918
   //?? Tv[298]:=Tv[32]; //user

   //Part 6

    Tv[299]:=Round(Tv[298]*28/100);
    //Tv[305]:=??/4
    Tv[306]:=Round(Tv[305]*36/100);
    Tv[62]:=MaxR(Tv[299],Tv[306]);


  //Tabular worksheets pg 6, 7, 8, 9
  //ws #1
  i:=93;
  Tv[272]:=Tv[271];  //additional sheets
  Repeat
   If Vl(Strings[i+2])>0 then
    Tv[i+3]:=Round(Tv[i]*Vl(Strings[i+1])/Vl(Strings[i+2]))
   Else
    Tv[i+3]:=0;
   Tv[272]:=Tv[272]+Tv[i+3];
   Inc(i,6);
  until i>267;


  //WS 2
  i:=276;
  j:=912;
  k:=952;
  Tv[491]:=Tv[490];
  Repeat
   If Tv[k]>0 then
    Tv[i+3]:=Round(Tv[i]* Tv[j]/Tv[k])
   Else
    Tv[i+3]:=0;
   Tv[491]:=Tv[491]+Tv[i+3];
   Inc(i,7);
   Inc(j,1);
   Inc(k,1);
  until i>486;

  //WS 3
  i:=276;
  Tv[494]:=Tv[493];
  Repeat
   If Tv[i+2]>0 then
    Tv[i+3]:=Round(Tv[i]* Tv[i+1]/Tv[i+2])
   Else
    Tv[i+3]:=0;
   Tv[494]:=Tv[494]+Tv[i+3];
   Inc(i,7);
  until i>755;

  //WS 4
  i:=765;
  j:=983;
  k:=1013;
  Tv[496]:=Tv[495];
  Repeat
   If Tv[k]>0 then
    Tv[i+1]:=Round(Tv[i]* Tv[j]/Tv[k])
   Else
    Tv[i+1]:=0;
   Tv[496]:=Tv[496]+Tv[i+1];
   Inc(i,5);
   Inc(j,1);
   Inc(k,1);
  until i>910;


  //part 7
  Tv[71]:=Tv[272];
  Tv[70]:=Tv[32];

  If Vl(Strings[68])>0 then
   Strings[77]:=FormatFloat('##0.0000',Vl(Strings[69])/Vl(Strings[68]))
  else
   Strings[77]:='';

  if Tv[83]>0 then
   Strings[84]:=FormatFloat('##0.0000',Tv[65]/Tv[83])
  Else
   Strings[84]:='';

  {
  if PhotoBegins <'2015/06/27' then
  begin
   Tv[65]:=0;
   Tv[83]:=0;
   Strings[84]:='';
  end
  Else
  Begin
    Strings[69]:='';
    Strings[68]:='';
    Strings[77]:=''
  End;
  }
  if Vl(Strings[77])>0 then
     Tv[14]:=Tv[70]*Vl(Strings[77])
  Else
     Tv[14]:=Tv[70] * Vl(Strings[84]);

   Tv[67]:=Tv[14];
   if Tv[67]>0 then
    Tv[66]:=Round(Tv[67]*6/100)
   Else
    Tv[66]:=Round(Tv[71]*6/100);

   //part 8

   Tv[72]:=Tv[491];
   Tv[79]:=Tv[32];
   If Vl(Strings[74])>0 then
    Strings[78]:=FormatFloat('##0.0000',Vl(Strings[73])/Vl(Strings[74]))
   Else
    Strings[78]:='';

   if Tv[277]>0 then
    Strings[278]:=FormatFloat('##0.0000',Tv[85]/Tv[277])
   Else
    Strings[278]:='';

  {
  if PhotoBegins <'2015/06/27' then
  begin
   Tv[85]:=0;
   Tv[277]:=0;
   Strings[278]:='';
  end
  Else
  Begin
    Strings[73]:='';
    Strings[74]:='';
    Strings[78]:='';
  End;
  }

  if Vl(Strings[78])>0 then
   Tv[80]:=Tv[79]*Vl(Strings[78])
  Else
   Tv[80]:=Tv[79]*Vl(Strings[278]);

  Tv[81]:=Tv[80];

  If Tv[81]>0 then
   Tv[75]:=Round(Tv[81]*6/100)
  Else
   Tv[75]:=Round(Tv[72]*6/100);


  //Part 9
    //Part 9
  Tv[291]:=Tv[59];
  Tv[86]:=Round(Tv[291]*16/100); //MaxR(Tv[285],Tv[292]);

  {
  if PhotoBegins <'2016/10/01' then
  Begin
   Tv[82]:=Tv[59];
   Tv[291]:=0;
  End
  Else
  Begin
   Tv[82]:=0;
   Tv[291]:=Tv[59];
  End;

  Tv[285]:=Round(Tv[82]*17.5/100);
  Tv[292]:=Round(Tv[291]*16/100);
  }
  {does not work
  If PhotoBegins<'2016/10/01' then
   Tv[86]:=Tv[285]
  Else
   Tv[86]:=Tv[292];
  }

  //Part 10

  //Part 11
  Tv[87]:=Tv[62];
  Tv[88]:=Tv[66];
  Tv[89]:=Tv[75];
  Tv[90]:=Tv[86];
  Tv[76]:=Tv[87]+Tv[88]+Tv[89]+Tv[90]+Tv[326]; //20250918

 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


procedure S16(RetNo: integer;FName: string;FNo: integer);
Var i:integer;NIBfrPatr:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Tv[8] := Tv[4]+Tv[6];
    Tv[9] := Tv[5]+Tv[7];
    Tv[12] := Tv[8]+Tv[9];

    Tv[17] := Tv[13]+Tv[15];
    If Tv[17]>0 then
    begin
      Tv[14] := Tv[13] * 100/Tv[17];
      Tv[16] := Tv[15]* 100 /Tv[17];
     end
     else
     begin
      Tv[14]:=0;
      Tv[16]:=0;
    end;

    Tv[34] :=GetNetIncBfrPatronage(RetNo);
    If Strings[10]+Strings[11] = '' then Strings[10] := 'X';

    //20100501
    Tv[18] := Tv[14];
    Tv[19]:=Tv[34];
    Tv[20] := (Tv[18]/100) * Tv[19];

    If Strings[32]>'' then
    begin
     Tv[37]:=Tv[20];
     Tv[39]:=Tv[37]* 85/100;
     Tv[35]:=MinR(Tv[38],Tv[39]);
     Tv[36]:=MaxR(0,Tv[12]-Tv[38]);
     Tv[40]:=Tv[35]+Tv[36];
    end
    else
    begin
     For i:=35 to 40 do Tv[i]:=0;  //20100501
    end;
  end; {End with}
  //S16 pg2---------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   If Vl(FetchElm(RetNo,'S16',40))>0 then
     Tv[137]:=Vl(FetchElm(RetNo,'S16',40))
   else
     Tv[137]:=Vl(FetchElm(RetNo,'S16',12));

   If FetchElm(RetNo,'S16',11)>'' then //line 200 has no
   begin
    Tv[138]:=Vl(FetchElm(RetNo,'S16',20));
    Tv[127]:=Vl(FetchElm(RetNo,'S16',5));
    Tv[128] := Tv[138]+Tv[127];
    Tv[129] := MinR(Tv[137],Tv[128]);
    Tv[130]:=Tv[129];
   end
   else
   begin
    Tv[101]:=0;
    Strings[101]:='';
    Tv[138]:=0;
    Tv[127]:=0;
    Tv[128] :=0;
    Tv[129]:=0;
    Tv[130]:=Tv[137];
   end;
   Tv[102]:=Tv[131]+Tv[101];
   Tv[132]:=Vl(FetchElm(RetNo,'S16',20));
   Tv[133]:=MaxR(0,Tv[130]-Vl(FetchElm(RetNo,'S16',5))); //Tv[27]);

   //20160612
   Tv[21]:=MaxR(0,Tv[132]-Tv[133]);
   Tv[134]:=Tv[21];  //MaxR(0,Tv[132]-Tv[133]);

   Tv[135]:=MinR(Tv[102],Tv[134]);
   Tv[136]:=Tv[130]+Tv[135];
   ////part 4
   Tv[104]:=TV[137]; //Tv[102];
   Tv[22]:=Tv[130];
   Tv[23]:=MaxR(0,Tv[104]-Tv[22]);
   Tv[105]:=Tv[23]; //135];
   Tv[24]:=Tv[102];
   Tv[25]:=Tv[135];
   Tv[26]:=MaxR(0,Tv[24]-Tv[25]);
   Tv[27]:=Tv[26];
   //Tv[106] := MaxR(0,Tv[104]-Tv[105]);
   //Tv[107] := MaxR(0,Tv[137]-Tv[130]);
   Tv[108] := Tv[105]+Tv[27];

   //part 5
   NIBfrPatr := GetNetIncBfrPatronage(RetNo);
   If Tv[109] = NiBfrPatr then
     Tv[110] := Tv[136]
   else
   begin
     Tv[112] := Vl(FetchElm(RetNo,'S16',14));
     Tv[113] := Tv[109];
     Tv[114]:= (Tv[112] /100) * Tv[113];
     Tv[116] := Tv[114]+Tv[115];
     Tv[117] := MinR(Tv[111],Tv[116]);

     Tv[118] := Tv[114];
     Tv[119] := MaxR(0,Tv[117]-Tv[115]);
     Tv[28]  := MaxR(0,Tv[118]-Tv[119]);
     Tv[120] := Tv[28]; //MaxR(0,Tv[118]-Tv[119]);
     Tv[122] := MinR(Tv[120],Tv[121]);
     Tv[123] := Tv[117]+Tv[122];
   end;

   If Tv[109] = NiBfrPatr then
      Tv[124] := Tv[110]
   else
      Tv[124] := Tv[123];

   Tv[125] := MaxR(0,Tv[109] - Tv[124]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;


procedure S35(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;x:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);

   If (Not IsInsuranceCorp(RetNo))
   or (IsNonResidentCorp(RetNo) =True) then
   begin
     For i:=5 to 40 do Tv[i]:=0;
     For i:=101 to 140 do Tv[i]:=0; //from pg 2
     For i:=202 to 235 do Tv[i]:=0; //from pg 3
     SaveTv(RetNo,FName,FNo);
     exit;
   end;

   If IsLifeInsuranceCorp(RetNo) then Strings[4]:='Y';
   If IsInsuranceCorp(RetNo) then  //20231031
   //If UpperCase(Strings[4]) = 'Y' then //life insurance - there is no gifi
    begin
     {20161112
     Tv[6] := GetCapitalStock(RetNo);
     Tv[7] := GetRetainedEarnings(RetNo);
     Tv[8] := GetContributedSurplus(RetNo);
     Tv[9] := GetOtherSurpluses(RetNo);
     }
     Tv[10] := Tv[5]+Tv[6]+Tv[7]+Tv[8]+Tv[9]+Tv[17]+Tv[18]+Tv[19]; //20231031
     Tv[11] := Tv[10];
     Tv[14] := Tv[12]+Tv[13];
     Tv[15] := Tv[14];
     Tv[16] := MaxR(0,Tv[11]-Tv[13]);  //20231031
     For i:=28 to 39 do Tv[i]:=0;
    end
    Else
    begin
     Tv[29] := GetCapitalStock(RetNo);
     Tv[30] := GetRetainedEarnings(RetNo);
     Tv[31] := GetContributedSurplus(RetNo);
     Tv[32] := GetOtherSurpluses(RetNo);
     Tv[33]:=AddColumns(28,32,1)+AddColumns(20,23,1); //20231031
     Tv[34]:=Tv[33];
     //Tv[38]:=AddColumns(35,37,1);  //20231031
     //Tv[39]:=Tv[38];
     Tv[40]:=MaxR(0,Tv[34]-Tv[36]);  //20231031
     For i:=5 to 16 do Tv[i]:=0;
     For i:=17 to 19 do Tv[i]:=0;
    end;
  end; {End with}
  //S35 pg2 --------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,141,142,43);
   {Part 2}
   If (IsLifeInsuranceCorp(RetNo))
   and (IsNonResidentCorp(RetNo)) then
   begin
   Tv[103] := MaxR(Tv[101],Tv[102]);
   Tv[106] := Tv[103]+Tv[104]+Tv[105];
   Tv[107] := Tv[106];
   Tv[113] := Tv[109]+Tv[110]; //+Tv[111]+Tv[112];  //20231031
   Tv[114] := Tv[113];
   Tv[115] := MaxR(0,Tv[108]-Tv[114]);
   Tv[116]:=Tv[115];
   Tv[117] := MaxR(0,Tv[107]-Tv[116]);
   end
   else
    For i:=101 to 117 do Tv[i]:=0;
   //allowance
   Tv[121]:=Tv[119]+Tv[120];
   //taxbl cap
   Tv[122]:=MaxR(Tv[117],MaxR(Tv[16],Tv[40]));  //20231031
   Tv[123]:=Tv[121];
   Tv[124]:=MaxR(0,Tv[122]-Tv[123]);
  end; {End with}
  //S35 pg3 --------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,236,237,238);
   {part 3} // Tv[237]:=Tv[235]+Tv[236];  //20231031
   Tv[226]:=Tv[224]+Tv[225];

  If IsNonResidentCorp(RetNo) = false then
  begin
   If UpperCase(FetchElm(RetNo,'S35',4)) = 'Y' then  //resident wil life ins
   begin
    // Tv[201]:=Tv[226];
     Tv[202]:=Tv[124];  //20231031
     Tv[203]:=Tv[368];  //20231031
     Tv[204]:=Tv[202]+Tv[203];
     Tv[205]:=Tv[369]; //Vl(FetchElm(RetNo,'S35',369));  //20231031
     Tv[206]:=MaxR(0,Tv[204]-Tv[205]);
     Tv[227]:=Tv[206];
     Tv[209]:=Vl(FetchElm(RetNo,'S35',370));

     //20231031
     If Tv[208]+Tv[209] >0 then
      Tv[210]:=Round((Tv[226]+Tv[207]) / (Tv[208]+Tv[209]))
     Else
      Tv[210]:=0;
     {
     If Tv[208]+Tv[209] >0 then
       Tv[210]:= (Tv[227]+Tv[207])/(Tv[208]+Tv[209])
     else
       Tv[210]:=0;
     }
     Tv[229]:=TV[226]+Tv[210];
     for i:=231 to 235 do Tv[i]:=0;
   end
   else                             //resident without life ins
   begin
    //Tv[230]:=Tv[226];
    Tv[231]:=Tv[124]; //Vl(FetchElm(RetNo,'S35',124));
    If Tv[233]>0 then
     Tv[234]:=round(Tv[231] * (Tv[232]/Tv[233]))
    else
     Tv[234]:=0;
    Tv[235]:=Tv[226]+Tv[234]; //Tv[230]+Tv[234]; 20150601
    For i:=202 to 210 do Tv[i]:=0;
    Tv[229]:=0;       //20231031
   end;
  end
  else  //non res insurance
  begin
   //Tv[219]:=Tv[226];
   //Tv[220]:=Vl(FetchElm(RetNo,'S35',124));
   Tv[221]:=Tv[226]+Tv[124]; //Tv[219]+Tv[220];  //20160601
  end;

   //Part 5
   Tv[212]:=MaxR(0,Tv[213]-Tv[211]);
   Tv[217]:=Tv[212]*0.00225;

  end; {End with}
  //S35 pg5 --------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,301,302,303);

   i:=304;j:=371;
   Tv[368]:=0;
   Tv[369]:=0;
   Tv[370]:=0;
   repeat
    Strings[j]:=Strings[i];
    Tv[j+5]:=Tv[j+1]+Tv[j+2]+Tv[j+3]+Tv[j+4];
    Tv[j+8]:=MaxR(0,Tv[j+5]-Tv[j+6]-Tv[j+7]);
    Tv[i+1]:=Tv[j+8];
    Tv[i+5]:=MaxR(0,Tv[i+1]-Tv[i+2]-Tv[i+3]-Tv[i+4]);
    Tv[i+6]:=MaxR(0,Tv[i+2]+Tv[i+3]+Tv[i+4]-Tv[i+1]);
    //20231031
    Tv[368]:=Tv[368]+Tv[i+5];
    Tv[369]:=Tv[369]+Tv[i+6];
    Tv[370]:=Tv[370]+Tv[i+7];
    Inc(i,8);
    Inc(j,9);
   until i>360;

  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;

procedure S40(RetNo: integer;FName: string;FNo: integer);
Var i:integer;x:real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If Not IsLifeInsuranceCorp(RetNo) then
   begin
    For i:=4 to 97 do begin Tv[i] :=0;Strings[i]:='';end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;
   Strings[1] :='';
   If Strings[3] = '' then Strings[3] := IntToStr(GetTaxationYearEndYYYY(RetNo));
   If Strings[2]+Strings[96] = '' then Strings[96] := 'X';
   Strings[4] := GetCorpName(RetNo);
   Strings[5] := GetAccountNumber(RetNo);
   x:=AddColumns(10,94,4);
   Tv[6] := Vl(FetchElm(RetNo,'S38',323)) - x;
   Tv[97] := Tv[6]+x;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure S425(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
begin
  //20180610  RoundCorect(
  If Vl(GetPrvAlloc(RetNo,'BC')) = 0 then
  begin
   For i:=1   to 25  do begin StoreElm(RetNo,FNo,i,'');end;
   For i:=101 to 121 do begin StoreElm(RetNo,FNo,i,'');end; //from pg2
   For i:=201 to 243 do begin StoreElm(RetNo,FNo,i,'');end; //from pg3
   For i:=301 to 345 do begin StoreElm(RetNo,FNo,i,'');end; //from pg4
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Strings[4]:= GetCorpName(RetNo);
    Strings[5]:=GetCorpBusNo(RetNo);
    Strings[6]:= IntToStr(GetTaxationYearEndYYYY(RetNo));
    Strings[7]:= GetBegYearEnd(RetNo);
    Strings[8]:=GetTaxationYearEnd(RetNo);
    If Strings[9]='' then
     Strings[9]:= FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
    If Strings[10]='' then Strings[10]:=FetchElm(RetNo,'T2',755);
    If Strings[11]='' then Strings[11]:=FetchElm(RetNo,'T2',746);
    If Strings[14]+Strings[15]='' then Strings[15]:='X';
    If Strings[16]+Strings[17]='' then Strings[17]:='X';
    If Strings[18]+Strings[19]='' then Strings[19]:='X';
    If Strings[20]+Strings[21]='' then Strings[21]:='X';

    //20160701
    Tv[22]:=Tv[331]; //vl(FetchElm(RetNo,'S425',331));
    //Tv[22]:=vl(FetchElm(RetNo,'S425',331));
    Tv[23]:=Tv[345]; //vl(FetchElm(RetNo,'S425',345));
    Tv[25]:=Tv[22]+Tv[23]+Tv[24];

  end; {End with}
  //S425 pg2 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   If Tv[101]=0 then Tv[101]:=6000000;   //20260628
   Tv[102]:=Tv[25];
   Tv[103]:=MinR(Tv[101],Tv[102]);
   Tv[104]:=RoundCorrect(Tv[103] * 10/100);
   If Ret[RetNo].CorpType <> CCPC then
   begin
    For i:=101 to 106 do Tv[i]:=0;
   end;
   If Uppercase(Strings[5]) <> 'Y' then Tv[106]:=Tv[104];

   Tv[107]:=Tv[25]; //Vl(FetchElm(RetNo,'S425',25)); //20160701
   Tv[108]:=RoundCorrect(Tv[107]*10/100);
   //20100510
   Tv[124]:=MaxR(0,Tv[122]-Tv[123]);
   Tv[125]:=Tv[124];

   Tv[109]:=Tv[106];
   If Tv[121]>MaxR(0,Tv[108]-Tv[109]) then Tv[121]:=MaxR(0,Tv[108]-Tv[109]);
   Tv[110]:=Tv[121];
   Tv[111]:=Tv[109]+Tv[110];
   Tv[112]:=Tv[111];
   Tv[113]:=MaxR(0,Tv[108]+Tv[125]-Tv[112]);    //20100510
   Tv[114]:=Tv[203]; //20160701Vl(FetchElm(RetNo,'S425',203));
   Tv[116]:=Tv[114]+Tv[115];
   Tv[117]:=Tv[116];
   Tv[118]:=Tv[113]+Tv[117];


   Tv[119]:=MaxR(0,Vl(FetchElm(RetNo,'S5',801))
           -Vl(FetchElm(RetNo,'S5',802)) //ftc
           -Vl(FetchElm(RetNo,'S5',803)) //Ltc
           -Vl(FetchElm(RetNo,'S5',804)) //royalty and deemed inc rebate
           -Vl(FetchElm(RetNo,'S5',805)) //poli credit
           -Vl(FetchElm(RetNo,'S5',809)) //sm bus vent cap tax credit
           -Vl(FetchElm(RetNo,'S5',844))); //mp
    Tv[120]:=MinR(Tv[118],Tv[119]);
  //  If Vl(FetchElm(RetNo,'S5',807)) >0 then Tv[120]:=0;  //tax holiday  //20100501
  end; {End with}
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[203]:=MaxR(0,Tv[201]-Tv[202]);
   Tv[204]:=Vl(FetchElm(RetNo,'S425',115));
   Tv[245]:=Tv[125];   //20160701
   Tv[205]:=Tv[108];  //Vl(FetchElm(RetNo,'S425',108));  //20160701
   Tv[206]:=Tv[204]+Tv[245]+Tv[205];  //20160701
   Tv[207]:=Tv[206];
   Tv[208]:=Tv[203]+Tv[207];

   //20160701
   Tv[209]:=Tv[121]; //Vl(FetchElm(RetNo,'S425',121));
   Tv[210]:=Tv[106]; //Vl(FetchElm(RetNo,'S425',106));
   Tv[211]:=Tv[120]; //Vl(FetchElm(RetNo,'S425',120));
   {
   Tv[209]:=Vl(FetchElm(RetNo,'S425',121));
   Tv[210]:=Vl(FetchElm(RetNo,'S425',106));
   Tv[211]:=Vl(FetchElm(RetNo,'S425',120));
   }

   Tv[243]:=Tv[238]+Tv[240]+Tv[242];
   Tv[212]:=Tv[243];
   Tv[213]:=Tv[209]+Tv[210]+Tv[211]+tv[212];
   Tv[214]:=Tv[213];
   Tv[215]:=MaxR(0,Tv[208]-Tv[214]);
   Tv[236]:=AddColumns(217,235,2);

  end; {End with}
  //S425 pg4 -------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   i:=301;
   Repeat
    Tv[i+2]:=MinR(Tv[i],Tv[i+1]);
    Inc(i,3);
   until i>313;
   Tv[316]:=AddColumns(303,315,3);
   Tv[347]:=Tv[316]+Tv[317];

   //if Ret[RetNo].Province='BC' then Strings[346]:='Y'; //20260628

    //20260921 Alex >>>
    if UpperCase(Strings[346]) = 'Y' then
    begin
      Tv[318]:= Vl(FetchElm(RetNo, 'T661', 168));  //Vl(FetchElm(RetNo,'T661',166));
      Tv[332]:= Vl(FetchElm(RetNo, 'T661', 167));
      Tv[319]:= Vl(FetchElm(RetNo, 'T661', 164));
      Tv[333]:= Vl(FetchElm(RetNo, 'T661', 165));
      Tv[320]:= Vl(FetchElm(RetNo, 'T661', 147)) + Vl(FetchElm(RetNo, 'T661', 149)) + Vl(FetchElm(RetNo, 'T661', 151));
      Tv[334]:= Vl(FetchElm(RetNo, 'T661', 148)) + Vl(FetchElm(RetNo, 'T661', 150)) + Vl(FetchElm(RetNo, 'T661', 152));
    end;

    Tv[321]:= AddColumns(318, 320, 1);
    Tv[335]:= AddColumns(332, 334, 1);

    if UpperCase(Strings[46])='Y' then
    begin
      Tv[322]:= Vl(FetchElm(RetNo, 'T661', 143));
      Tv[336]:= Vl(FetchElm(RetNo, 'T661', 144));
      Tv[323]:= Vl(FetchElm(RetNo, 'T661', 149)); //20260921 Alex
      Tv[337]:= Vl(FetchElm(RetNo, 'T661', 156)); //20260921 Alex
    end;

    //Tv[330]:= AddColumns(322, 329, 1);  //20241201 //20260921 Alex
    //Tv[330]:=MaxR(0,Tv[321]-AddColumns(322,329,1));
    //Tv[344]:=MaxR(0,Tv[335]-AddColumns(336,343,1)); //20260921 Alex
    //Tv[331]:= MaxR(0,Tv[321]-Tv[330]);//Tv[330]; //20241201
    //Tv[345]:= Tv[344];  //20241201 what is this
    Tv[331]:= MaxR(0, Tv[321] - AddColumns(322, 329, 1)); //20260921 Alex
    Tv[345]:= MaxR(0, Tv[335] - AddColumns(336, 343, 1)); //20260921 Alex
  end;

  SaveTv(RetNo, FName, FNo);
  //20260921 Alex <<<
end;

//20240728 Igor >>>
{
Procedure T2054(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
//20231218
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Strings[1]:=GetCorpName(RetNo);
   Strings[2]:=GetCorpBusNo(RetNo);
   Strings[3]:=FetchElm(RetNo,'T2',12)+' '+FetchElm(RetNo,'T2',13);
   Strings[15]:=FetchElm(RetNo,'T2',16);
   Strings[4]:=FetchElm(RetNo,'T2',17);
   Strings[113]:=FetchElm(RetNo,'T2',20);

   Strings[5]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
   Strings[6]:=FetchElm(RetNo,'T2',55);
   Strings[7]:=FetchElm(RetNo,'T2',46);
   Tv[11]:=MaxR(0,Tv[9]-Tv[10]);
   if Strings[90]+Strings[91]='' then Strings[91]:='X';
   if Strings[92]+Strings[93]='' then Strings[93]:='X';
  end;

 with Ret[RetNo].Frm[Fno] do
  begin
   //part 5
   i:=117;  //col 4
   Repeat
    Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
    Inc(i,7);
   Until i>180;
   //Part 8 follows panalties  //20231231
   Tv[97]:=Tv[9];
   Tv[98]:=RoundCorrect(Tv[97]*1/100);
   Strings[100]:=FormatFloat('##0.00',Vl(Strings[99]) /12);
   Tv[101]:=Round(Tv[98] * Vl(Strings[100]));
   Strings[102]:=Strings[99];
   Tv[103]:=500*(Vl(Strings[102])/12);

   Tv[104]:=MinR(Tv[101],Tv[103]);

   //part 9
   Tv[105]:=Tv[11];
   Tv[225]:=Tv[105];
   Tv[224]:=Round(Tv[225] *(60/100));

   //Part 10
   Tv[106]:=Tv[104];
   Tv[107]:=Tv[224];
   Tv[108]:=Tv[106]+Tv[107];
   XX:=Tv[108];  //debugging statement  xx is global variable
   if Tv[108]=0 then Tv[109]:=0; //20240131
   //if Tv[109]=0 then Tv[109]:=Tv[108];
   //Part 11
   Strings[110]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
   Strings[111]:=FetchElm(RetNo,'T2',744);
   If Strings[112]='' then Strings[112]:=FormatDateTime('yyyy/mm/dd',Date);
 end;
 SaveTv(RetNo,FName,FNo);
end;
}
//20240728 Igor

//20191012
procedure S384(RetNo: integer;FName: string;FNo: integer);
Var i,j,jj,days:integer;FInst:String; x,MaxSalary,MaxClaim:Real;

begin
 //20151004  ALL NEW
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Finst:=ExtractFormInst(FName);
   FillHeader(RetNo,FNo,1,2,3);

   (* Obsolete  20191013 CON
   //part 1 transitional
   Tv[4]:=0;
   For i:=48 to 59 do Tv[4]:=Tv[4]+Tv[i];
   If FInst>'#1' then
   begin
    Tv[61]:=0;
    For i:=5 to 35 do begin Strings[i]:='';Tv[i]:=0;end;
   end;
   If FInst='#1' then  Tv[4]:=Tv[4]+Tv[61];
   *)

   //part 2 youth work //20160507
   i:=221;
   jj:=224; //override column
   MaxSalary:=20000; MaxClaim:=5000;
   Tv[241]:=Tv[240];
   Repeat
    If Tv[i]>MaxSalary then Tv[i]:=MaxSalary;
    Tv[i+1]:=Round(Tv[i]*25/100);
    If UpperCase(Strings[jj])<>'Y' then
       Tv[i+2]:=MinR(Tv[i+1],MaxClaim);   //20151025
    Tv[241]:=Tv[241]+Tv[i+2];
    Inc(i,5);
    Inc(jj,1);
   until i>236;

   //part 3 co-up student
   i:=95;
   jj:=200;
   MaxSalary:=10000; MaxClaim:=1000;
   Tv[64]:=Tv[63];  //line x80
   Repeat
    If Tv[i]>MaxSalary then Tv[i]:=MaxSalary;
    Tv[i+1]:=Round(Tv[i]*10/100);
    If UpperCase(Strings[jj])<>'Y' then
       Tv[i+2]:=MinR(Tv[i+1],MaxClaim);   //20151025
    Tv[64]:=Tv[64]+Tv[i+2];
    Inc(i,4);
    Inc(jj,1);
   until i>107;

   //part 4 co-up graduate
   i:=111;
   j:=181;
   jj:=204;
   MaxSalary:=50000; MaxClaim:=2500;
   Tv[66]:=Tv[65];  //line x80
   Repeat
    If Strings[i-1]>'' then
    Begin
     If Strings[j]='' then Strings[j]:='365';
     Days:=MyStrToInt(Strings[j]);
     If Tv[i]>MaxSalary then Tv[i]:=MaxSalary;
     Tv[i+1]:=Round(Tv[i]*5/100);
     If UpperCase(Strings[jj])<>'Y' then
      Tv[i+2]:=MinR(MaxClaim*days/365,Tv[i+1]);
     Tv[66]:=Tv[66]+Tv[i+2];
    End
    Else  //no empl name
    Begin
     Strings[j]:=''; Tv[i+1]:=0;Tv[i+2]:=0;Strings[jj]:='';
    end;
    Inc(i,4);
    Inc(j,1);
    Inc(jj,1);
   until i>123;


   //part 5 apprentice
   i:=127;
   j:=185;
   jj:=208;
   MaxSalary:=33333; MaxClaim:=5000;
   Tv[68]:=0; //Tv[67];  //line x80   //20160611
   Repeat
    If Strings[i-1]>'' then
    Begin
     If Tv[i]>MaxSalary then Tv[i]:=MaxSalary;
     If Strings[j]='' then Strings[j]:='365';
     Days:=MyStrToInt(Strings[j]);
     Tv[i+1]:=Round(Tv[i]*15/100);
     If UpperCase(Strings[jj])<>'Y' then
     Tv[i+2]:=MinR(MaxClaim*days/365,Tv[i+1]);
     Tv[68]:=Tv[68]+Tv[i+2];
    end
    Else  //no empl name
    Begin
     Strings[j]:=''; Tv[i+1]:=0;Tv[i+2]:=0;Strings[jj]:='';
    end;
    Inc(i,4);
    Inc(j,1);
    Inc(jj,1);
   until i>139;
   Tv[68]:=MaxR(0,Tv[68]+Tv[67]-Tv[16]); //20160611

   //part 6 apprentice - rural
   i:=143;
   j:=189;
   jj:=212;
   MaxSalary:=25000; MaxClaim:=5000;
   Tv[70]:=0; // Tv[69];  //line x80  //20160611
   Repeat
    If Strings[i-1]>'' then
    Begin
     If Strings[j]='' then Strings[j]:='365';
     If Tv[i]>MaxSalary then Tv[i]:=MaxSalary;
     Days:=MyStrToInt(Strings[j]);
     Tv[i+1]:=Round(Tv[i]*20/100);
     If UpperCase(Strings[jj])<>'Y' then
      Tv[i+2]:=MinR(MaxClaim*days/365,Tv[i+1]);
     Tv[70]:=Tv[70]+Tv[i+2];
    end
    Else  //no empl name
    Begin
     Strings[j]:=''; Tv[i+1]:=0;Tv[i+2]:=0;Strings[jj]:='';
    end;
    Inc(i,4);
    Inc(j,1);
    Inc(jj,1);
   until i>155;
   Tv[70]:=Tv[70]+Tv[69]-Tv[17];  //20160611

  //part 7 Aprentice hiring high scholl  //20160507
   i:=246;
   j:=245;
   jj:=249;
   MaxSalary:=20000; MaxClaim:=5000;
   Tv[269]:=0; //Tv[268];  //20160611
   Repeat
    If Strings[i-2]>'' then
    Begin
     If Strings[j]='' then Strings[j]:='365';
     If Tv[i]>MaxSalary then Tv[i]:=MaxSalary;
     Days:=MyStrToInt(Strings[j]);
     Tv[i+1]:=Round(Tv[i]*25/100);
     If UpperCase(Strings[jj])<>'Y' then
      Tv[i+2]:=MinR(MaxClaim*days/365,Tv[i+1]);
     Tv[269]:=Tv[269]+Tv[i+2];
    end
    Else  //no empl name
    Begin
     Strings[j]:=''; Tv[i+1]:=0;Tv[i+2]:=0;Strings[jj]:='';
    end;
    Inc(i,6);
    Inc(j,6);
    Inc(jj,6);
   until i>264;
   Tv[269]:=MaxR(0,Tv[269]-Tv[18]); //20160611


   //part 8 journeyperson
   i:=159;
   j:=193;
   jj:=216;
   MaxSalary:=33333; MaxClaim:=5000;
   Tv[72]:=0; //Tv[71];  //line x80  //20160611
   Repeat
    If Strings[i-1]>'' then
    Begin
     If Strings[j]='' then Strings[j]:='365';
     If Tv[i]>MaxSalary then Tv[i]:=MaxSalary;
     Days:=MyStrToInt(Strings[j]);
     Tv[i+1]:=Round(Tv[i]*15/100);
     If UpperCase(Strings[jj])<>'Y' then
      Tv[i+2]:=MinR(MaxClaim*days/365,Tv[i+1]);
     Tv[72]:=Tv[72]+Tv[i+2];
    end
    Else  //no empl name
    Begin
     Strings[j]:=''; Tv[i+1]:=0;Tv[i+2]:=0;Strings[jj]:='';
    end;
    Inc(i,4);
    Inc(j,1);
    Inc(jj,1);
   until i>171;
   Tv[72]:=Tv[72]+Tv[71];  //20160611

   //Part 9 paid work experience
   Tv[174]:= Tv[4];
   Tv[242]:= Tv[241];  //20160507
   Tv[175]:=Tv[64];  //what if multiple forms?
   Tv[176]:=Tv[66];
   Tv[177]:=Tv[68];
   Tv[178]:=Tv[70];
   Tv[243]:=Tv[269];    //20160507
   Tv[179]:=TV[72];
   Tv[180]:=Tv[174]+Tv[242]+Tv[175]+Tv[176]+Tv[177]+Tv[178]+Tv[243]+Tv[179]; //20160507
   //removed part 9 //20210809
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



procedure S385(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   Tv[14]:=AddColumns(11,13,1);


   Strings[32]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
   Strings[33]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
   Strings[34]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
   Tv[29]:=Tv[35]+Tv[36]+Tv[37];

   i:=38;j:=10;
   Repeat
    Strings[i]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),j);
    Inc(i,1);
    Inc(j,-1);
   until i>48;
   Tv[60]:=AddColumns(49,59,1);

   //Tv[1]:=Tv[5]+Tv[7]+Tv[2];  //20111129  //???

   Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
   Tv[18]:=Tv[17];
   Tv[30]:=Tv[14];
   Tv[20]:=Tv[30] * 10/100;
   Tv[21]:=Tv[19]+Tv[20];
   Tv[21]:=MaxR(0,Tv[20]-Tv[10]);
   Tv[22]:=Tv[21];
   Tv[23]:=Tv[18]+TV[19]+Tv[22];  //20180512

   //bfr Tv[31]
   Tv[4]:=Tv[23];
   Tv[6]:=MaxR(0,Vl(FetchElm(RetNo,'S5',723))+Vl(FetchElm(RetNo,'S5',753)));   //Tv[24];   //20180512
   //20180512
  // Tv[8]:=MaxR(0,Tv[4]-Tv[6]);
  // Tv[5]:=Tv[8];
   Tv[9]:=MaxR(0,Tv[4]-Tv[6]);
   //----------------

   Tv[31]:=Tv[9];
   Tv[25]:=Vl(FetchElm(RetNo,'S385',29));
   Tv[26]:=Tv[24]+Tv[31]+Tv[25];

   Tv[31]:=Tv[9]; //MinR(Tv[5],Tv[7]);   //20180512
   Tv[27]:=Tv[26];
   Tv[28]:=MaxR(0,Tv[23]-Tv[27]);

  (* moved above
   Tv[4]:=Tv[23];
   Tv[6]:=MaxR(0,Vl(FetchElm(RetNo,'S5',750))-Vl(FetchElm(RetNo,'S5',753)));   //Tv[24];   //20180512
   //20180512
  // Tv[8]:=MaxR(0,Tv[4]-Tv[6]);
  // Tv[5]:=Tv[8];
   Tv[9]:=MaxR(0,Tv[4]-Tv[6]);
  *)
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S60(RetNo: integer;FName: string;FNo: integer);
Var i,j,T661FNo:integer;FInst:String;
begin
  FInst:=ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   //Copy the old 268 and 269 filds to new Elms and clear them  //20190717
   if Strings[83]>'' then begin Strings[22]:=Strings[83];Strings[83]:='';end;
   if Strings[84]>'' then begin Strings[23]:=Strings[84];Strings[84]:='';end;
   if Strings[85]>'' then begin Strings[24]:=Strings[85];Strings[85]:='';end;
   if Strings[86]>'' then begin Strings[25]:=Strings[86];Strings[86]:='';end;

   If Strings[10]+Strings[11]='' then Strings[11]:='X';
   If Strings[8]+Strings[9]='' then Strings[9]:='X';
   If UpperCase(Strings[10])='X' then
   //ok
   else
   begin
    For i:=12 to 21 do Strings[i]:='';
   end;
    //20190717
   if Strings[28]='X' then strings[28]:='';
   {
   If Strings[28]+Strings[29]='' then Strings[28]:='X';
   If Strings[28]>'' then
   begin
    For i:=158 to 211 do Strings[i]:='';  //remove section c descriptions
   end;
   }

   If Strings[29]>'' then  //remove section B descriptions
   begin
    For i:=34 to 60 do Strings[i]:='';
    For i:=104 to 130 do Strings[i]:='';
    For i:=131 to 157 do Strings[i]:='';
   end;

   //20110322
   If Length(Strings[84]) >15 then Strings[84]:=LeftStr(Strings[84],15);
   If Length(Strings[86]) >15 then Strings[86]:=LeftStr(Strings[86],15);
   //pg3
   If Strings[77]+Strings[78]='' then Strings[78]:='X';
   If Strings[79]+Strings[80]='' then Strings[80]:='X';
   If Strings[81]+Strings[82]='' then Strings[82]:='X';
   If Strings[81]>'' then
   //ok
   else
   begin
    For i:=83 to 86 do Strings[i]:='';
   end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20130531
procedure S322(RetNo: integer;FName: string;FNo: integer);
Var i,j,S7FNo,F1Ndx, K1Ndx:integer;   //pointers to S7
begin
  S7FNo:=GetFormNo('S7');
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
   //20251016
   If (Ret[RetNo].Province = 'PE') or (Ret[RetNo].Province = 'MJ') then
     //continue
    else
    begin
     For i:=1 to 98 do begin Strings[i]:='';Tv[i]:=0;end;
     SaveTv(RetNo,FName,FNo);
     exit;
    end;

    FillHeader(RetNo,FNo,1,2,3);
    Tv[4]:=GetTxblIncomeInProv(RetNo,'PE');
    Tv[5]:=Ret[RetNo].Ln[400];
    Tv[6]:=Ret[RetNo].Ln[405];
    Tv[7]:=Ret[RetNo].Ln[428];
    Tv[8]:=MinR(Tv[7],MinR(Tv[5],Tv[6]));

    Tv[9]:=Tv[8]; //Tv[23];   //20190421
    Tv[10]:=Tv[4];
    Tv[11]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[11]>0 then
     Tv[12]:=Tv[9]*Tv[10]/Tv[11]
    else
     Tv[12]:=0;

    Tv[88]:=MaxR(0,Tv[4]-Tv[12]);
    //after june 30
    Tv[90]:=GetTxblIncomeInProv(RetNo,'PE');
    Tv[94]:= Ret[RetNo].Ln[400];
    Tv[13]:= Ret[RetNo].Ln[405];
    Tv[93]:=Ret[RetNo].Ln[428];
    Tv[96]:=RoundCorrect(Tv[93]*(600000/500000));
    Tv[95]:=MinR(Tv[94],MinR(Tv[13],Tv[96]));
    Tv[89]:=Tv[95];
    Tv[97]:=GetTxblIncomeInProv(RetNo,'PE');
    Tv[98]:=GetTxblIncomeInAllProv(RetNo);
    if Tv[98]>0 then
     Tv[91]:=RoundCorrect(Tv[89]*TV[97]/Tv[98])
    else
     Tv[91]:=0;
    Tv[92]:=MaxR(0,Tv[90]-Tv[91]);


    //PART 3
    if UpperCase(Strings[87])='Y'  then
    Begin
    TV[35]:= Vl(FetchElmFNo(RetNo,S7FNo,159)); //amount Y S7 part 6
    TV[36]:= Vl(FetchElmFNo(RetNo,S7FNo,26)); //amount 530  part 6 of s7
    TV[37]:= Vl(FetchElmFNo(RetNo,S7FNo,99)); //amount 540 of S7
    TV[38]:= Vl(FetchElmFNo(RetNo,S7FNo,100)); //amount AA of S7
    TV[39]:= Vl(FetchElmFNo(RetNo,S7FNo,165)); //amount CC of S7
    Tv[40]:=Tv[35]+Tv[36]+Tv[37]+Tv[38]+Tv[39];
    Tv[41]:=Tv[40];
    TV[42]:= Vl(FetchElmFNo(RetNo,S7FNo,150)); //amount Q of S7
   end
   Else
  begin
   For i:=35 to 42 do begin Tv[i]:=0;end;
  end;

    F1Ndx:=105;   //index to F1 column of S7
    K1Ndx:=64;   //index to K1 column of S7
    I:=43;    //index on this schedule of first column
    Tv[75]:=0;
    Tv[76]:=0;
    Tv[i+3];
    Repeat
     Tv[i]:=Vl(FetchElmFNo(RetNo,S7FNo,F1Ndx));
     Tv[I+1]:=Round(Vl(FetchElmFNo(RetNo,S7FNo,K1Ndx)) *700000/500000);
     Tv[i+2]:=Tv[i]-Tv[i+1];
     Tv[I+3]:=MinR(Tv[i+1],Tv[I+2]);
     if Tv[i]<0 then Tv[i+3]:=0;
     Tv[75]:=Tv[75]+Tv[i+2];
     Tv[76]:=Tv[76]+Tv[i+3];
     Inc(F1Ndx,8);
     Inc(K1Ndx,1);
     Inc(i,4);
    Until F1Ndx>133;
    Tv[77]:=Vl(FetchElmFNo(RetNo, S7FNo,143));  //ln 370 of S7
    Tv[78]:=Vl(FetchElmFNo(RetNo, S7FNo,144));  //ln 380 of S7
    Tv[79]:=Tv[77]+Tv[78];
    Tv[80]:=MinR(Tv[75],Tv[79]);
    Tv[81]:=Tv[76]+Tv[80];
    Tv[82]:=Tv[81];
    Tv[83]:=MaxR(0,Tv[42]-Tv[82]); //maxr(0?
    Tv[84]:=Tv[83];
    Tv[85]:=MaxR(0,Tv[42]-Tv[84]);  //maxr(0?

    if UpperCase(Strings[87])<>'Y' then
    Begin
      for i:=35 to 42 do Tv[i]:=0;
      Tv[84]:=0;Tv[85]:=0;
    End;


    //20210518
    Tv[25]:=Tv[12];
    Strings[27]:=IntToStr(GetNumDays(RetNo,'01-07-2025','B'));
    Strings[28]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[29]:=Round(Tv[25]* (Vl(Strings[27])/Vl(Strings[28]))*1/100);

    //20210518
    Tv[14]:=Tv[91];
    Strings[19]:=IntToStr(GetNumDays(RetNo,'30-06-2025','A'));
    Strings[23]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[26]:=Round(Tv[14]* (Vl(Strings[19])/Vl(Strings[23]))*1/100);
    Tv[24]:=Tv[29]+Tv[26];
    Tv[31]:=Tv[24];

    //-----------
    //20250918
    Tv[16]:=Tv[88];
    Strings[15]:=IntToStr(GetNumDays(RetNo,'01-07-2025','B'));
    Strings[20]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[17]:=Round(Tv[16]* (Vl(Strings[15])/Vl(Strings[20]))*16/100);


    Tv[32]:=Tv[92];
    Strings[21]:=IntToStr(GetNumDays(RetNo,'30-06-2025','A'));
    Strings[22]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[30]:=Round(Tv[32]* (Vl(Strings[21])/Vl(Strings[22]))*15/100);

    Tv[33]:=Tv[17]+Tv[30];
    Tv[18]:=Tv[33];

    Tv[34]:=Tv[31]+Tv[18];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20130531
procedure S461(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Tv[4]:=GetTxblIncomeInProv(RetNo,'NT');
    Tv[5]:=Ret[RetNo].Ln[400];
    Tv[6]:=Ret[RetNo].Ln[405];
    Tv[7]:=Ret[RetNo].Ln[428];
    Tv[8]:=MinR(Tv[7],MinR(Tv[5],Tv[6]));

    Tv[9]:=Tv[8];
    Tv[10]:=Tv[4];
    Tv[11]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[11]>0 then
     Tv[12]:=Tv[9]*Tv[10]/Tv[11]
    else
     Tv[12]:=0;
    Tv[23]:=MaxR(0,Tv[4]-Tv[12]);

    Tv[14]:=Tv[12];
    //20210921
    Strings[13]:=IntToStr(GetNumDays(RetNo,'01-01-2021','B'));
    Strings[19]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[15]:=Round(Tv[14]*(Vl(Strings[13])/Vl(Strings[19])) * (4/100));
    //Tv[15]:=Round(Tv[14]*4/100);

    Tv[20]:=Tv[12];
    //20210921
    Strings[22]:=IntToStr(GetNumDays(RetNo,'31-12-2020','A'));
    Strings[24]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[21]:=Round(Tv[20]*(Vl(Strings[22])/Vl(Strings[24])) * (2/100));

    Tv[25]:=Tv[15]+Tv[21];
    Tv[26]:=Tv[25];

    Tv[16]:=Tv[23];
    Tv[17]:=Round(Tv[16]*11.5/100);
    Tv[18]:=Tv[26]+Tv[17];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20191006
procedure S481(RetNo: integer;FName: string;FNo: integer);
Var i,j:integer; s:String;
begin

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Tv[4]:=GetTxblIncomeInProv(RetNo,'NU');
    Tv[5]:=Ret[RetNo].Ln[400];
    Tv[6]:=Ret[RetNo].Ln[405];
    Tv[7]:=Ret[RetNo].Ln[428]; //20200926 GetReducedBusinessLimit(RetNo); //20190626  Ret[RetNo].Ln[427]; //20170620
    Tv[8]:=MinR(Tv[7],MinR(Tv[5],Tv[6]));
    Tv[9]:=Tv[8];
    Tv[10]:=Tv[4];
    Tv[11]:=GetTxblIncomeInAllProv(RetNo);
    If Tv[11]>0 then
     Tv[12]:=Tv[9]*Tv[10]/Tv[11]
    else
     Tv[12]:=0;
    Tv[23]:=MaxR(0,Tv[4]-Tv[12]);

    Tv[14]:=Tv[12];
    Strings[13]:=IntToStr(GetNumDays(RetNo,'01-07-2019','B'));
    Strings[19]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[15]:=Round(Tv[14]*(Vl(Strings[13])/Vl(Strings[19]))*(4/100));

    Tv[20]:=Tv[12];
    //S:=IntToStr(GetNumDays(RetNo,'01-07-2019','A'));
    Strings[22]:=IntToStr(GetNumDays(RetNo,'30-06-2019','A'));  //20201019
    Strings[24]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[21]:=Round(Tv[20]*(Vl(Strings[22])/Vl(Strings[24]))*(3/100));

    Tv[25]:=Tv[15]+Tv[21];
    Tv[26]:=Tv[25];

    Tv[16]:=Tv[23];
    Tv[17]:=Round(Tv[16]*12/100);
    Tv[18]:=Tv[26]+Tv[17];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


//20170715
procedure GroupInfo(RetNo: integer;FName: string;FNo: integer);
Var i,j,k,FromFNo:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);


    FromFNo:=GetFormNo('S9');
    if UpperCase(FetchElmFNo(RetNo,FromFNo,184)) <> 'Y' then Exit;

    //fisr row put the base corp
    Strings[4]:=FetchElm(RetNo,GetFormNo('T2'),3); //corp nm
    Strings[5]:=FetchElm(RetNo,GetFormNo('T2'),19); //country of res if not can
    Strings[6]:=FetchElm(RetNo,GetFormNo('T2'),1); //BN
    Strings[7]:=FetchElm(RetNo,GetFormNo('S9'),186); //relationship

    i:=13;  //current form
    j:=4;  //FromFNo
    Repeat
     for k:=0 to 8 do
     Begin
      Strings[i+k]:=FetchElmFNo(RetNo,FromFNo,j+k);
      Tv[i+k]:=Vl(FetchElmFNo(RetNo,FromFNo,j+k));
     end;

     Inc(i,9);
     Inc(j,9);
    until i>175;

    FromFNo:=GetFormNo('S23');
    i:=189;  //current form
    j:=5;  //FromFNo
    Repeat
     for k:=0 to 5 do
     Begin
      Strings[i+k]:=FetchElmFNo(RetNo,FromFNo,j+k);
      Tv[i+k]:=Vl(FetchElmFNo(RetNo,FromFNo,j+k));
     end;

     Inc(i,6);
     Inc(j,6);
    until i>303;

    Tv[309]:=0;
    Tv[310]:=0;
    i:=193;
    Repeat
     Tv[309]:=Tv[309]+Tv[i];
     Strings[309]:=FormatFloat('####.###',Tv[309]);
     Tv[310]:=Tv[310]+Tv[i+1];
     Inc(i,6);
    Until i>307;


    FromFNo:=GetFormNo('S49');
    i:=372;  //current form
    j:=5;  //FromFNo
    Repeat
     for k:=0 to 5 do
     Begin
      Strings[i+k]:=FetchElmFNo(RetNo,FromFNo,j+k);
      Tv[i+k]:=Vl(FetchElmFNo(RetNo,FromFNo,j+k));
     end;
     Inc(i,5);
     Inc(j,6);  //it looks 5 but it is 6
    until i>467;
    Tv[472]:=0;
    Tv[473]:=0;
    i:=375;
    Repeat
     Tv[472]:=Tv[472]+Tv[i];
     Tv[473]:=Tv[473]+Tv[i+1];
     Inc(i,5);
    Until i>470;

    FromFNo:=GetFormNo('S39');
    i:=311;  //current form
    j:=7;  //FromFNo
    Repeat
     Tv[i]:=Vl(FetchElmFNo(RetNo,FromFNo,j));
     Inc(i,1);
     Inc(j,4);
    until i>330;

    //now copy the s9 to the top listing
    Strings[481]:=GetCorpName(RetNo);
    Strings[482]:=GetCorpBusNo(RetNo);
    Strings[483]:=GetTaxationYearStart(RetNo);
    Strings[484]:=GetTaxationYearEnd(RetNo);
   // Strings[485]:=Ret[RetNo].CorpType;
    //from same page S9 section
    i:=486;
    j:=4;
    Repeat
     for k:=0 to 4 do
     Begin
      Strings[i+k]:=FetchElmFNo(RetNo,FromFNo,j+k);
      //Tv[i+k]:=Vl(FetchElmFNo(RetNo,FromFNo,j+k));
     end;
     Inc(i,5);
     Inc(j,9);
    Until i>576;

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20181105
Function PermanentEstablishmentInProvince(RetNo:Integer;Prov:String):Boolean;
Begin
 Result:=False;
 if Ret[RetNo].Province=Prov  then begin Result:=True;Exit;End;
 if Prov='NL' then Begin Result:=(FetchElm(RetNo,'S5',289)>'');Exit;End;
 if Prov='PE' then Begin Result:=(FetchElm(RetNo,'S5',291)>'');Exit;End;
 if Prov='NS' then Begin Result:=(FetchElm(RetNo,'S5',292)>'');Exit;End;
 if Prov='NB' then Begin Result:=(FetchElm(RetNo,'S5',294)>'');Exit;End;
 if Prov='QC' then Begin Result:=(FetchElm(RetNo,'S5',295)>'');Exit;End;
 if Prov='ON' then Begin Result:=(FetchElm(RetNo,'S5',296)>'');Exit;End;
 if Prov='MB' then Begin Result:=(FetchElm(RetNo,'S5',297)>'');Exit;End;
 if Prov='SK' then Begin Result:=(FetchElm(RetNo,'S5',298)>'');Exit;End;
 if Prov='AB' then Begin Result:=(FetchElm(RetNo,'S5',299)>'');Exit;End;
 if Prov='BC' then Begin Result:=(FetchElm(RetNo,'S5',300)>'');Exit;End;
 if Prov='YT' then Begin Result:=(FetchElm(RetNo,'S5',301)>'');Exit;End;
 if Prov='ZZ' then Begin Result:=(FetchElm(RetNo,'S5',302)>'');Exit;End;
End;



procedure S350(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    //s350 pg 1
    FillHeader(RetNo,FNo,1,2,3);

    //s350 part 1
    Tv[14]:=AddColumns(5,13,2);

    //s350 part 2
    Tv[15]:=Tv[14];  //20191013

    Tv[18]:=MaxR(0,Tv[16]-Tv[17]);
    Tv[19]:=Tv[18];

    Tv[20]:=Tv[15]+Tv[18];

    //Tv[21]:=MinR(50000,Tv[20]); //???

    //S350 part 3 on S350 pg2, needs to be calced before Tv[25]
    Tv[33]:=Tv[28]+Tv[30]+Tv[32];

    //s350 part 2 continued
    Tv[22]:= Tv[33]; //Vl(FetchElm(RetNo,'S350',33));

    Tv[23]:=Tv[21]+Tv[22];
    Tv[24]:=Tv[23];
    Tv[25]:=MaxR(0,Tv[20]-Tv[24]);

    //S350 pg2 -------------------------------------------------------------------
    //S350 part 4
    Tv[56]:=AddColumns(41,55,2);
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;


procedure S352(RetNo: integer;FName: string;FNo: integer);  //20220917
Var i:integer;S5FNo,S38FNo:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  // must be put back //temp on 202200923  //20230606
  with Ret[RetNo].Frm[Fno] do
  Begin
   if GetTaxationYearStart(RetNo)>'2021/10/31' then
    //ok
   Else
   Begin
    for i:=1 to 28 do begin Tv[i]:=0;Strings[i]:='';end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   End;
  End;

  with Ret[RetNo].Frm[Fno] do
  begin
    S38FNo:=GetFormNo('S38');
    S5FNo:=GetFormNo('S5');
    FillHeader(RetNo,FNo,1,2,3);
    Tv[4]:=Vl(FetchElmFNo(RetNo,S38FNo,17));
    if Tv[4]=0 then Tv[4]:=Vl(FetchElmFNo(RetNo,S38FNo,20));
    Tv[6]:=MaxR(0,Tv[4]-Tv[5]);

    if IsTrustOrLoanCorp(RetNo) then
    Begin
     If Vl(FetchElmFNo(RetNo,S5FNo,272))>0 then
      Tv[7]:=(Vl(FetchElmFNo(RetNo,S5FNo,129))+Vl(FetchElmFNo(RetNo,S5FNo,239)))
           /MaxR(0,(Vl(FetchElmFNo(RetNo,S5FNo,272))-Vl(FetchElmFNo(RetNo,S5FNo,261))))
     else
      Tv[7]:=0;
     Tv[8]:=Tv[6];
     Tv[10]:=Tv[7];
     Tv[11]:=Tv[8] * Tv[10];
     Tv[19]:=Tv[11];
    End
    Else
    Begin
      for i:=7 to 8 do Tv[i]:=0;
      for i:=10 to 11 do Tv[i]:=0;
    End;

    if IsBankCorp(retNo) then
    Begin
     Tv[9]:=(Vl(FetchElmFNo(RetNo,S5FNo,127))+Vl(FetchElmFNo(RetNo,S5FNo,237)));
     If Vl(FetchElmFNo(RetNo,S5FNo,272))>0 then
      Tv[23]:=2 * MaxR(0,(Vl(FetchElmFNo(RetNo,S5FNo,272))-Vl(FetchElmFNo(RetNo,S5FNo,261))));
     if Tv[23]>0 then Strings[12]:=Formatfloat('##0.0000',Tv[9]/Tv[23]) else Strings[12]:='';

     Tv[27]:= Vl(FetchElmFNo(RetNo,S5FNo,129))+Vl(FetchElmFNo(RetNo,S5FNo,239));
     If Vl(FetchElmFNo(RetNo,S5FNo,272))>0 then
      Tv[28]:=MaxR(0,(Vl(FetchElmFNo(RetNo,S5FNo,272))-Vl(FetchElmFNo(RetNo,S5FNo,261))));
     if Tv[28]>0 then Strings[13]:=Formatfloat('##0.0000',Tv[27]/Tv[28]) else Strings[13]:='';
     Strings[14]:=FormatFloat('##0.0000',Vl(Strings[12])+Vl(Strings[13]));
     Tv[15]:=Vl(Strings[14])/3;
     //272 is Tott gross reenue in S5
     If Vl(FetchElmFNo(RetNo,S5FNo,270))=0 then Tv[15]:=Vl(Strings[14])/2;
     If Vl(FetchElmFNo(RetNo,S5FNo,272))=0 then Strings[15]:=Strings[14];
     Tv[16]:=Tv[6];
     Strings[17]:=Strings[15];
     Tv[18]:=Tv[16]*Vl(Strings[17]);
     Tv[19]:=MaxR(Tv[6],MaxR(Tv[11],Tv[18]));
    End
    Else
    Begin
     For i:=12 to 19 do Tv[i]:=0;
    End;

    Tv[20]:=Tv[19];
    Tv[21]:=Tv[20]*4/100;
    if Ret[RetNo].DaysInYear< 147 then      //less than 51 weks)
    begin
      Tv[22]:=Tv[19];
      Strings[24]:=IntToStr(Ret[RetNo].DaysInYear);
      Tv[25]:=Tv[22] *Ret[RetNo].DaysInYear * 4/100;
    end;
    Tv[26]:=MaxR(Tv[21],Tv[25]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);

end;


procedure S353(RetNo: integer;FName: string;FNo: integer);  //20220917
Var i:integer;S5FNo,S38FNo:Integer;
begin
   LoadTv(RetNo,FName,FNo);
   with Ret[RetNo].Frm[Fno] do
   Begin
    If Vl(FetchElm(RetNo,'S353',85))>0 then  //capital deduction
    //ok
    Else
    Begin
     for i:=1 to 85 do begin Tv[i]:=0;Strings[i]:='';end;
     SaveTv(RetNo,FName,FNo);
     Exit;
    End;
  end;

  with Ret[RetNo].Frm[Fno] do
  Begin
   if GetTaxationYearStart(RetNo)>'2021/10/31' then
    //ok
   Else
   Begin
    for i:=1 to 85 do begin Tv[i]:=0;Strings[i]:='';end;
    SaveTv(RetNo,FName,FNo);
    Exit;
   End;
  End;

  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo,FNo,1,2,3);
    Strings[4]:=GetCorpName(RetNo);
    Strings[5]:=GetCorpBusNo(RetNo);
    Tv[85]:=0;
    i:=6;
    Repeat
     Tv[85]:=Tv[85]+Tv[i];
     Inc(i,3)
    Until i>63;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



//20191912
procedure S349(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    //s349 pg 1
    FillHeader(RetNo,FNo,1,2,3);
    Tv[14]:=AddColumns(5,13,2);
    Tv[17]:=MaxR(0,Tv[15]-Tv[16]);
    Tv[18]:=Tv[17];

    //Tv[20]:=Tv[14];
    Tv[23]:=Tv[19]+Tv[18];  //20201111
    Tv[24]:=MinR(50000,Tv[23]); //???

    //S349 part 3 on S349 pg2, needs to be calced before Tv[25]
    Tv[107]:=Tv[102]+Tv[104]+Tv[106];
    //s349 part 2 continued
    Tv[25]:= Tv[107]; //Vl(FetchElm(RetNo,'S349',107));
    Tv[26]:=Tv[24]+Tv[25];
    Tv[27]:=Tv[26];
    Tv[28]:=MaxR(0,Tv[23]-Tv[27]);

    //S349 part 4
    Tv[124]:=AddColumns(109,123,2);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20200215
Procedure CONSENT(RetNo:integer;FName:string;FNo:integer); //20200212
Var i:Integer; s:String;
Begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    if Strings[66]='' then Exit;  //prepare this year not printed
    if Strings[12]='' then begin Strings[16]:='';Strings[15]:='';end; //20180728  //not all programs
    if Strings[13]>'' then //authorize
    Begin //clear cancellation elms
      For i:=45 to 49 do begin Strings[i]:='';end;
      Strings[42]:='';
      Strings[51]:='';
    End;
    //20200218  //diffrent than T1
    Strings[1]:=GetCorpName(RetNo);
    Strings[2]:=LeftStr(GetCorpBusNo(RetNo),9);

    if Strings[34]>'' then //authorize
    Begin //clear Auth data
      Strings[10]:='';
      Strings[57]:='';
      Strings[20]:='';
      Strings[21]:='';
      Strings[27]:='';
      Strings[12]:='';
      Strings[16]:='';
      Strings[15]:='';
      Strings[17]:='';
      Strings[24]:='';
      Strings[31]:='';
      Strings[38]:='';
    End;
    //20201211
    if (Strings[13]>'') and (UpperCase(Strings[65])='Y') then
    Begin
     Strings[10]:=OptRec.Prp_RepId;
     Strings[21]:=OptRec.Prp_Area;
     Strings[27]:=OptRec.Prp_Tel;
    End;

    //optiona1
    Strings[16]:=LeftStr(Strings[16],2);
    //option 2
    i:=17;
    Repeat
     Strings[i]:=LeftStr(Strings[i],2);
     Strings[i+5]:=LeftStr(Strings[i+5],2);
     if Strings[17]='' then begin Strings[i+5]:='';Strings[i+6]:=''; end;
     Inc(i,7);
    until i>38;

    if Strings[47] > '' then //cancell all
    begin
      Strings[48]:='';Strings[45]:='';Strings[51]:='';Strings[50]:='';Strings[49]:='';Strings[42]:='';
    end;

    if Strings[48] > '' then  //rep id
    begin
      Strings[50]:='';Strings[49]:='';Strings[42]:='';
    end;

    if Strings[50] > '' then //groupid
    begin
      Strings[48]:='';Strings[45]:='';Strings[51]:='';Strings[49]:='';Strings[42]:='';
    end;

    if Strings[49] > '' then     //bus
    begin
      Strings[48]:='';Strings[50]:='';
    end;

    If Strings[55]='' then Strings[55]:=FormatDateTime('yyyy/mm/dd',Date);
  end; //with
End;

procedure S8FREE(RetNo: integer;FName: string;FNo: integer);  //20210508
Var i,k,K1:integer;
FInst :String;
S8FNo:Integer;
Cls,s,S1,S2:String;
OriginalCost:Real;
UccStart,Additions,Adjustments,Proceeds,UCC,HalfRuleAmount,UCCReduced:Real;
OverrideIndic,HalfYearIndic,TermLossIndic: String;
Rate:String;
Recapture, TerminalLoss,CCA,UCCEnd:Real;
DaysInTaxYear:Integer; // > 365 then DaysInTaxYear := 365;
//cls 13 relted
AssetInfo: String;
//additional fields after aiip
Aiip:Boolean;
AdditionsAiip, AssistanceReceived, RepaidAmount,
ProceedsAiip,NetCapCostAdditionsAiip,UccAdjustmentAiip, UccAdjustmentNONAiip:Real;
Aiipfactor:String;

OverrideBox,HalfRuleBox,TerminalLossBox:String;
HalfYearAmount:Real;

LeaseStart,LeaseEnd: string; LeaseTerm:Real; LeaseAdjustedCost:Real; // RemainingLeaseTerm:Real;
PurchaseDate:String;
LeaseMaxCca:Real;
x:real;

begin
 DaysInTaxYear:=Ret[RetNo].DaysInYear;
 If DaysInTaxYear > 365 then DaysInTaxYear := 365;

 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);
  If Strings[4]+Strings[5] = '' then Strings[5] := 'X';

 //INIT Totals //20190614
  Tv[249]:=0;Tv[234]:=0;Tv[250]:=0;Tv[235]:=0;
  Tv[230]:=0;Tv[231]:=0;Tv[232]:=0;Tv[251]:=0;

  for I:=384 to 396 do Strings[i]:='';  //initialize the botom classes, then copy them //20190705

  for k:=0 to 12 do  //k=01 etc to pick up the right row
  Begin
    Cls:=AllTrim(Strings[6+k*16]);  //20190719 //alltrim
    Strings[384+k*1]:=Cls; //20190705
    Rate:=GetCCARate(Cls);  //string //20190614
    //20190605
    If UpperCase(Strings[14+k*16])='O' then Strings[14+k*16]:='Y'; //override
    If UpperCase(Strings[15+k*16])='H' then Strings[15+k*16]:='Y';  //half year
    if vl(Rate)=100 then Strings[15+k*16]:='N';  //20190614 No half year rule for fast write off //20190614
    If UpperCase(Strings[16+k*16])='T' then Strings[16+k*16]:='Y';  //Term loss

    If UpperCase(Strings[14+k*16])='X' then Strings[14+k*16]:='Y'; //override
    If UpperCase(Strings[15+k*16])='X' then Strings[15+k*16]:='Y';  //half year
    If UpperCase(Strings[16+k*16])='X' then Strings[16+k*16]:='Y';  //Term loss

    OriginalCost:=Tv[371+k*1];
    AssetInfo:=Strings[236+k*1];

    UccStart:=Tv[7+k*16];
    Additions:=Tv[8+k*16];
    Adjustments:=Tv[9+k*16];
    Proceeds:=Tv[10+k*16];

    if (LeaseHold(Cls)) and (UCCStart>0) Then begin Additions:=0;Tv[8+k*16]:=0;end;  //do not allow additions to 13 //20190705
    //if (Cls='13') and (UCCStart>0) Then begin Additions:=0;Tv[8+k*16]:=0;end;  //do not allow additions to 13 //20190705
    //20190809  accept yyymmdd in case they entered yyyy/mm/dd
    If (Cls>'') then
    begin
     if Not LeaseHold(Cls) then
     //if Cls<>'13' then
     Begin
      //replace yyymmdd with yyy/mm/dd for date
      s:=LeftStr(Strings[236+k*1],8);
      if (Length(s)=8) and (Numeric(s)) then
      Strings[236+k*1]:=LeftStr(s,4)+'/'+MidStr(S,6,2)+'/'+RightStr(s,2);
     End
     Else //leasehold //cls='13')
     Begin
      s:=Strings[236+k*1];
      s:=RemoveChar(s,'/');
      s:=RemoveChar(s,'-');
      s:=LeftStr(s,16);
      if (Length(s)=16) and (Numeric(s)) then
      Begin
       s1:=LeftStR(S,8);  //from date
       S1:=LeftStr(s1,4)+'/'+MidStr(S1,5,2)+'/'+RightStr(s1,2);
       S2:=RightStr(S,8); //to date
       S2:=LeftStr(s2,4)+'/'+MidStr(S2,5,2)+'/'+RightStr(s2,2);
       Strings[236+k*1]:=S1+'-'+S2;
      End;
     End;
    end;


    //AIIP indicator//20190621
    //20190705
    Strings[356+k*1]:='';
    if (Additions>0) and (Cls>'') then
    Begin
     s:=ReplaceChar(AssetInfo,',','');
     PurchaseDate:=LeftStr(S,10);
     if PurchaseDate>'2018/11/20' then
       Strings[356+k*1]:='X'  //then 10.1 is aiip
     Else
       Strings[356+k*1]:='';  //20190705
    end;


    if (GetTaxationYearEnd(RetNo)>'2027/12/31') then Strings[356+k*1]:='';  //NO AIIP after 2027? Check it then IF ALIVE! //20190704
    //------------------------------

    If Strings[356+k*1]>'' then Aiip:=True else Aiip:=False;   //20190614

    //20190607
    if (Aiip=False) and (cls>'') then
    Begin
      If Strings[15+k*16]='' then Strings[15+k*16]:='Y';  //20190605 half yer rule by default
    End;
    if Aiip=True then Strings[15+k*16]:='';    //20190614 in O-H-T
    If (cls='24')  or (cls='27') or(cls='29') or (cls='34') then Strings[15+k*16]:=''; //fast write off NO half year rule

    OverrideIndic:=UpperCase(Strings[14+k*16]);
    HalfYearIndic:=UpperCase(Strings[15+k*16]);
    TermLossIndic:=UpperCase(Strings[16+k*16]);

    If Uppercase(OverrideIndic) <> 'Y' then Rate:=GetCCARate(Cls);

    //Inpout validations
    if Cls='10.1' then  //20190622
    Begin
     if PurchaseDate < GetTaxationYearStart(RetNo) then Tv[8+k*16]:=0; //no additions allowed
    End;

    If Aiip=False then Tv[252+k*1]:=0;  //aiip portion of col 3
    AdditionsAiip:=Tv[252+k*1];
    //assistance part of col 5
    If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];
    AssistanceReceived:=Tv[265+k*1];
    //repaid part of col 5
    If Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=Tv[9+k*16]; //repaid
    RepaidAmount:=Tv[278+k*1];
    //both
    If Tv[265+k*1] + Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=0;  //one has to go


    //aiip  related
    If Aiip=False then
    Begin
     Tv[291+k*1]:=0;
     Tv[304+k*1]:=0;
     Tv[343+k*1]:=0;
     Tv[317+k*1]:=0;
     Tv[330+k*1]:=0;
    End;
   if Aiip=True then  //20190705
   Begin
    //fast write off //20190608
    if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then
    Begin
     Tv[8+k*16]:=0; //additions
    End;


   //20210328
 // Aiipfactor
    AiipFactor:='';
    Strings[343+k*1]:='';
    if Cls='' then Aiipfactor:=''; //20190622
    if Aiip=False then Aiipfactor := '';  //default

    if cls = '43.1' then Aiipfactor := '2.33333'
    Else if Cls = '43.2' then Aiipfactor := '1'
    Else if Cls = '53' then Aiipfactor := '1'

    Else if (Cls = '54') then
    Begin
      if Strings[236+k] > '2019/03/18' then
      begin
        Strings[356+k] := 'X';
        Aiipfactor := '2.33333333';
      end
      Else If Strings[236+k] > '2018/11/20' then
      begin
        Strings[356+k] := 'X';
        Aiipfactor := '0.5';
      end;
    End

    Else if (Cls = '55') and (Strings[236+k] > '2019/03/18') then Aiipfactor := '1.5'
    Else if (cls='12') or (Leasehold(cls)) or (cls='14') or (cls='15') then Aiipfactor:=''  //20190806
    Else  Aiipfactor := '0.5';

    if cls='' then begin AiipFactor:='';Strings[343+k*1]:='';end;
   End;
   Strings[343+k*1]:=AiipFactor;

    ProceedsAiip:=Tv[291+k*1];

    HalfRuleAmount:=0;
    UCC:=0;
    UCCReduced:=0;
    Recapture:=0;
    TerminalLoss:=0;


  //get lease and orinal cost from decr box
  If Leasehold(cls) then //if Cls='13' then
  begin
     LeaseTerm:=5; //Default;
     //for class 13: 1234567890-1234567890
     s:=ReplaceChar(AssetInfo,',','');
     LeaseStart:=LeftStr(S,10);
     LeaseEnd:=MidStr(S,12,10);
     if (Length(LeaseStart)<>10) or (Length(LeaseEnd)<>10) then
      LeaseTerm :=0
     Else
     begin
      LeaseTerm := DateDiffYMD(LeaseStart,LeaseEnd) div 365;
      If (LeaseTerm>0) and (LeaseTerm<5) then LeaseTerm :=5;
     End;
     LeaseMaxCCA:=OriginalCost/LeaseTerm;  //20190611
     Rate:=FormatFloat('####.##',100/LeaseTerm);      //20190601
     Strings[17*k*16]:=Rate;
  end;

  if Cls = '' then
  begin
    UCC := 0;
    HalfRuleAmount := 0;
    UccReduced := 0;
    Recapture := 0;
    TerminalLoss := 0;
    CCA := 0;
    UCCEnd := 0;
  end;

  Ucc := UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount - Proceeds; //20190606pm
  if (Cls='10.1') and (Proceeds>0) then UCC:=UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount; //20190820 Get the CCA on disposal

  If LeaseHold(Cls) then //if cls='13' then //20190611
  Begin
   LeaseAdjustedCost:=OriginalCost-UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
   UccReduced:=UCCStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
  End;

  if AiiP=False then  //20190706
  Begin
  if UpperCase(HalfYearIndic) = 'Y' then   ////20190605
  begin
    if UpperCase(OverrideIndic) <> 'Y' then  //20190605
    begin
     HalfRuleAmount := MaxR(0, 0.5 * (Additions-AssistanceReceived+RepaidAmount-Proceeds));
     if LeaseHold(Cls) then HalfRuleAmount := MaxR(0, 0.5 * (Additions-Proceeds)); //20190613
     HalfRuleAmount := RoundCorrect(HalfRuleAmount);
    end;
  end
  else
    HalfRuleAmount := 0;
  end;

  If (Aiip=True) then
  Begin
   HalfRuleAmount:=0;   //20190608
   //20190707
   ProceedsAiip:=MaxR(0,Proceeds+AssistanceReceived-Additions+AdditionsAiiP-RepaidAmount);
   NetCapCostAdditionsAiip:=MaxR(0,AdditionsAiip-ProceedsAiip);
   UccAdjustmentAiip:=NetCapCostAdditionsAiip*vl(AiipFactor);

   UccAdjustmentNONAiip:=MaxR(0,0.5 * (Additions-AdditionsAiip-AssistanceReceived+RepaidAmount-Proceeds)); //20190622 moved from below
   if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34') then UccAdjustmentNONAiip:=0; //20190622  //fast write off //20190622
   UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount-Proceeds-UccAdjustmentNONAiip+UccAdjustmentAiip; //20190707
   //UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount-Proceeds-UccAdjustmentNONAiip; //20190622
   //20190706
   if (cls='10.1') then //(PurchaseDate>'2018/11/20') then  //20190705
   Begin
    //UccAdjustmentNONAiip:=0; //20190706
    UccReduced:=Additions + Adjustments - AssistanceReceived + RepaidAmount+Round(Additions/2); //20190622
   end;
  End
  Else  //NO aiip
  Begin
   if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34')  //fast write off //20190622
   then UccAdjustmentNONAiip:=0; //20190622
   UCCReduced := UCC - HalfRuleAmount;
   if LeaseHold(Cls) then UccReduced:=UCC;  //20190611
   ProceedsAiip:=0;
   NetCapCostAdditionsAiip:=0;
   UccAdjustmentAiip:=0;
  end;


    //put amounts on the S8 form
    Tv[12+k*16]:=HalfRuleAmount;
    if AiiP then Tv[12+k*16]:=0;   //remove half ruleamount
    Tv[11+k*16]:=UCCReduced;
    Strings[17+k*16]:=Rate;

    Tv[291+k*1]:=ProceedsAiip; //UccAdjustmentNONAiip;
    Tv[304+k*1]:=NetCapCostAdditionsAiip;
    Strings[343+k*1]:=AiipFactor;
    if Cls='' then Strings[343+k*1]:='';

    Tv[317+k*1]:=UccAdjustmentAiip;
    If Cls>'' then Tv[330+k*1]:=UccAdjustmentNONAiip;  //20190622


    if UCCReduced < 0 then
    begin
     //If cls<>'10.1' then  //20190820 If 10.1 we still want to claim CCA when disposed, but not recapture
     CCA := 0;
     TerminalLoss := 0;
     Recapture := ABS(UCCReduced);
     if Cls = '10.1' then Recapture:=0;
    end
    else  //positive ucc = CCA or Terminal loss upon disposal
    begin
     TerminalLoss := 0;
     Recapture := 0;

     //20190313
     if Aiip then
      CCA:=Round(UCCReduced * Vl(Rate)/100)  //20190622
     else
      CCA:=Round(UCCReduced * Vl(Rate) / 100);

     if (LeaseHold(Cls)) and (AIIP=False) then  //20190613
       CCA := MinR(UCCReduced, LeaseMaxCCA);

     if (Leasehold(Cls)) then
     Begin
      //if (Aiip=False)  //20190725
      If (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
      then
        CCA:=Round(CCA/2); //20190705
     end;

     If (LeaseHold(Cls)) Then  //20190725
     Begin
      If (Aiip=true)
      and (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
      and (AdditionsAiip>0)
      then  CCA:=CCA *3; //first year  //20190725
     end;


     if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then CCA:=UccReduced; //fast wrire offs 20190609


     //20210526
     If (IsLeapYear(GetTaxationYearStartYYYY(RetNo))
     and (DateWithinTaxYear(IntToStr(GetTaxationYearStartYYYY(RetNo))+'/02/29',RetNo)=True)) then
      CCA:=CCA * Ret[RetNo].DaysInYear / 366
     Else
      CCA:=CCA * Ret[RetNo].DaysInYear / 365;

     (*
    //20200916
     //20200724
     If (IsLeapYear(GetTaxationYearStartYYYY(RetNo)))
    // and (MidStr(GetTaxationYearEnd(RetNo),6,5)>'02/28')  //202001008 //only if after Fabe 28
     then
      CCA:= CCA * Ret[RetNo].DaysInYear / 366
     Else
      CCA:=CCA * Ret[RetNo].DaysInYear / 365;  //20190707
     *)

     if OverrideIndic='Y' then CCA:=Tv[20+k*16];

     if TermLossIndic='Y' then
     Begin
      TerminalLoss:=UccReduced+UCCAdjustmentNONAIIp; //20190626    //TerminalLoss:=UccReduced;
      Tv[19+k*16]:=TerminalLoss;
      Recapture:=0;
      Tv[18+k*16]:=0;
      CCA:=0;
      UccEnd :=0;
     End;


     UccEnd := MaxR(0, UCCReduced - CCA);

     if AiiP=False then
       UccEnd:=MaxR(0,UCCReduced-CCA+HalfRuleAmount)        //20190622
     Else //Aiip is true
     Begin
       UccEnd:=MaxR(0,UccReduced-CCA+UCCAdjustmentNONAIIp-UCCAdjustmentAIIp);  //20190707
       If Cls='10.1' then UccEnd:=MaxR(0,UCCReduced-CCA-UCCAdjustmentNONAIIp);  //20190707
     end;
    end;
    if (cls = '10.1') then begin TerminalLoss := 0;Recapture := 0;end; //20190607
    if (cls = '10.1') and (proceeds > 0) then
    begin
     CCA := Round(CCA/2); //Round((UccStart + Adjustments) / 2 * Vl(Rate) / 100);  //20190705
     UccEnd := 0;
    end;

    //20190626
    if (Recapture>0) or (TerminalLoss>0) then UCcEnd:=0;

    Tv[20+k*16]:=CCA;
    Tv[21+k*16]:=UccEnd;
    Tv[18+k*16]:=Recapture;
    Tv[19+k*16]:=TerminalLoss;

    //add to totals //20190614
    Tv[249]:=Tv[249]+uccStart;
    Tv[234]:=Tv[234]+Additions;
    Tv[250]:=Tv[250]+Adjustments;
    Tv[235]:=Tv[235]+Proceeds;

    Tv[230]:=Tv[230]+Recapture;
    Tv[231]:=Tv[231]+TerminalLoss;
    Tv[232]:=Tv[232]+CCA;
    Tv[251]:=Tv[251]+UccEnd;

  End; //k 0 to 12
 End; //with?
 SaveTv(RetNo,FName,FNo);
end;

//20261006 Alex >>>
procedure S52(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    if (Strings[3] + Strings[4]).IsEmpty then Strings[4]:= 'X';

    Tv[29]:= AddColumns(8, 28, 4);
    if(Tv[29] > 6000000) then Tv[29]:= 6000000;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20261006 Alex <<<
(*//20190622
//20220619
procedure S8OLD(RetNo: integer;FName: string;FNo: integer);
Var i,k,K1:integer;
FInst :String;
S8FNo:Integer;
Cls,s,S1,S2:String;
OriginalCost:Real;
UccStart,Additions,Adjustments,Proceeds,UCC,HalfRuleAmount,UCCReduced:Real;
OverrideIndic,HalfYearIndic,TermLossIndic: String;
Rate:String;
Recapture, TerminalLoss,CCA,UCCEnd:Real;
DaysInTaxYear:Integer; // > 365 then DaysInTaxYear := 365;
//cls 13 relted
AssetInfo: String;
//additional fields after aiip
Aiip:Boolean;
AdditionsAiip, AssistanceReceived, RepaidAmount,
ProceedsAiip,NetCapCostAdditionsAiip,UccAdjustmentAiip, UccAdjustmentNONAiip:Real;
Aiipfactor:String;

OverrideBox,HalfRuleBox,TerminalLossBox:String;
HalfYearAmount:Real;

LeaseStart,LeaseEnd: string; LeaseTerm:Real; LeaseAdjustedCost:Real; // RemainingLeaseTerm:Real;
PurchaseDate:String;
LeaseMaxCca:Real;
x:real;

begin
 DaysInTaxYear:=Ret[RetNo].DaysInYear;
 If DaysInTaxYear > 365 then DaysInTaxYear := 365;

 FInst := ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);
  If Strings[4]+Strings[5] = '' then Strings[5] := 'X';

 //INIT Totals //20190614
  Tv[249]:=0;Tv[234]:=0;Tv[250]:=0;Tv[235]:=0;
  Tv[230]:=0;Tv[231]:=0;Tv[232]:=0;Tv[251]:=0;

  for I:=384 to 396 do Strings[i]:='';  //initialize the botom classes, then copy them //20190705

  for k:=0 to 12 do  //k=01 etc to pick up the right row
  Begin
    Cls:=AllTrim(Strings[6+k*16]);  //20190719 //alltrim
    Strings[384+k*1]:=Cls; //20190705
    Rate:=GetCCARate(Cls);  //string //20190614
    //20190605
    If UpperCase(Strings[14+k*16])='O' then Strings[14+k*16]:='Y'; //override
    If UpperCase(Strings[15+k*16])='H' then Strings[15+k*16]:='Y';  //half year
    if vl(Rate)=100 then Strings[15+k*16]:='N';  //20190614 No half year rule for fast write off //20190614
    If UpperCase(Strings[16+k*16])='T' then Strings[16+k*16]:='Y';  //Term loss

    If UpperCase(Strings[14+k*16])='X' then Strings[14+k*16]:='Y'; //override
    If UpperCase(Strings[15+k*16])='X' then Strings[15+k*16]:='Y';  //half year
    If UpperCase(Strings[16+k*16])='X' then Strings[16+k*16]:='Y';  //Term loss

    OriginalCost:=Tv[371+k*1];
    AssetInfo:=Strings[236+k*1];

    UccStart:=Tv[7+k*16];
    Additions:=Tv[8+k*16];
    Adjustments:=Tv[9+k*16];
    Proceeds:=Tv[10+k*16];

    if (LeaseHold(Cls)) and (UCCStart>0) Then begin Additions:=0;Tv[8+k*16]:=0;end;  //do not allow additions to 13 //20190705
    //20190809  accept yyymmdd in case they entered yyyy/mm/dd
    If (Cls>'') then
    begin
     if Not LeaseHold(Cls) then
     Begin
      //replace yyymmdd with yyy/mm/dd for date
      s:=LeftStr(Strings[236+k*1],8);
      if (Length(s)=8) and (Numeric(s)) then
      Strings[236+k*1]:=LeftStr(s,4)+'/'+MidStr(S,6,2)+'/'+RightStr(s,2);
     End
     Else //leasehold //cls='13')
     Begin
      s:=Strings[236+k*1];
      s:=RemoveChar(s,'/');
      s:=RemoveChar(s,'-');
      s:=LeftStr(s,16);
      if (Length(s)=16) and (Numeric(s)) then
      Begin
       s1:=LeftStR(S,8);  //from date
       S1:=LeftStr(s1,4)+'/'+MidStr(S1,5,2)+'/'+RightStr(s1,2);
       S2:=RightStr(S,8); //to date
       S2:=LeftStr(s2,4)+'/'+MidStr(S2,5,2)+'/'+RightStr(s2,2);
       Strings[236+k*1]:=S1+'-'+S2;
      End;
     End;
    end;


    //AIIP indicator//20190621
    //20190705
    Strings[356+k*1]:='';
    if (Additions>0) and (Cls>'') then
    Begin
     s:=ReplaceChar(AssetInfo,',','');
     PurchaseDate:=LeftStr(S,10);
     if PurchaseDate>'2018/11/20' then
       Strings[356+k*1]:='X'  //then 10.1 is aiip
     Else
       Strings[356+k*1]:='';  //20190705
    end;
    if (GetTaxationYearEnd(RetNo)>'2027/12/31') then Strings[356+k*1]:='';  //NO AIIP after 2027? Check it then IF ALIVE! //20190704
    If Strings[356+k*1]>'' then Aiip:=True else Aiip:=False;   //20190614
    if cls='56' then Begin  Aiip:=False;Strings[356+k*1]:='';end;  //20220531

    //20190607
    if (Aiip=False) and (cls>'') then
    Begin
      If Strings[15+k*16]='' then Strings[15+k*16]:='Y';  //20190605 half yer rule by default
    End;
    if Aiip=True then Strings[15+k*16]:='';    //20190614 in O-H-T
    If (cls='24')  or (cls='27') or(cls='29') or (cls='34') then Strings[15+k*16]:=''; //fast write off NO half year rule

    OverrideIndic:=UpperCase(Strings[14+k*16]);
    HalfYearIndic:=UpperCase(Strings[15+k*16]);
    TermLossIndic:=UpperCase(Strings[16+k*16]);

    If Uppercase(OverrideIndic) <> 'Y' then Rate:=GetCCARate(Cls);

    //Inpout validations
    if Cls='10.1' then  //20190622
    Begin
     if PurchaseDate < GetTaxationYearStart(RetNo) then Tv[8+k*16]:=0; //no additions allowed
    End;

    If (Aiip=False)
    and (cls<>'56') //20220531
     then Tv[252+k*1]:=0;  //aiip portion of col 3

    AdditionsAiip:=Tv[252+k*1];
    //assistance part of col 5
    If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];
    AssistanceReceived:=Tv[265+k*1];
    //repaid part of col 5
    If Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=Tv[9+k*16]; //repaid
    RepaidAmount:=Tv[278+k*1];
    //both
    If Tv[265+k*1] + Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=0;  //one has to go


    //aiip  related
    If Aiip=False then
    Begin
     Tv[291+k*1]:=0;
     Tv[304+k*1]:=0;
     Tv[343+k*1]:=0;
     Tv[317+k*1]:=0;
     Tv[330+k*1]:=0;
    End;
   if Aiip=True then  //20190705
   Begin
    //fast write off //20190608
    if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then
    Begin
     Tv[8+k*16]:=0; //additions
    End;


   //20210328
 // Aiipfactor
    AiipFactor:='';
    Strings[343+k*1]:='';
    if Cls='' then Aiipfactor:=''; //20190622
    if Aiip=False then Aiipfactor := '';  //default

    if cls = '43.1' then Aiipfactor := '2.33333'
    Else if Cls = '43.2' then Aiipfactor := '1'
    Else if Cls = '53' then Aiipfactor := '1'

    Else if (Cls = '54') then
    Begin
      if Strings[236+k] > '2019/03/18' then
      begin
        Strings[356+k] := 'X';
        Aiipfactor := '2.33333333';
      end
      Else If Strings[236+k] > '2018/11/20' then
      begin
        Strings[356+k] := 'X';
        Aiipfactor := '0.5';
      end;
    End
    Else if (Cls = '55') and (Strings[236+k] > '2019/03/18') then Aiipfactor := '1.5'
    Else if (Cls = '56') then Aiipfactor := '2.333331'    //20210927
    Else if (cls='12') or (Leasehold(cls)) or (cls='14') or (cls='15') then Aiipfactor:=''  //20190806
    Else  Aiipfactor := '0.5';

    if cls='' then begin AiipFactor:='';Strings[343+k*1]:='';end;
   End;
   Strings[343+k*1]:=AiipFactor;

   ProceedsAiip:=Tv[291+k*1];

   HalfRuleAmount:=0;
   UCC:=0;
   UCCReduced:=0;
   Recapture:=0;
   TerminalLoss:=0;


  //get lease and orinal cost from decr box
  If Leasehold(cls) then //if Cls='13' then
  begin
     LeaseTerm:=5; //Default;
     //for class 13: 1234567890-1234567890
     s:=ReplaceChar(AssetInfo,',','');
     LeaseStart:=LeftStr(S,10);
     LeaseEnd:=MidStr(S,12,10);
     if (Length(LeaseStart)<>10) or (Length(LeaseEnd)<>10) then
      LeaseTerm :=0
     Else
     begin
      LeaseTerm := DateDiffYMD(LeaseStart,LeaseEnd) div 365;
      If (LeaseTerm>0) and (LeaseTerm<5) then LeaseTerm :=5;
     End;
     LeaseMaxCCA:=OriginalCost/LeaseTerm;  //20190611
     Rate:=FormatFloat('####.##',100/LeaseTerm);      //20190601
     Strings[17*k*16]:=Rate;
  end;

  if Cls = '' then
  begin
    UCC := 0;
    HalfRuleAmount := 0;
    UccReduced := 0;
    Recapture := 0;
    TerminalLoss := 0;
    CCA := 0;
    UCCEnd := 0;
  end;

  Ucc := UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount - Proceeds; //20190606pm
  if (Cls='10.1') and (Proceeds>0) then UCC:=UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount; //20190820 Get the CCA on disposal

  If LeaseHold(Cls) then //if cls='13' then //20190611
  Begin
   LeaseAdjustedCost:=OriginalCost-UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
   UccReduced:=UCCStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
  End;

  if AiiP=False then  //20190706
  Begin
  if UpperCase(HalfYearIndic) = 'Y' then   ////20190605
  begin
    if UpperCase(OverrideIndic) <> 'Y' then  //20190605
    begin
     HalfRuleAmount := MaxR(0, 0.5 * (Additions-AssistanceReceived+RepaidAmount-Proceeds));
     if LeaseHold(Cls) then HalfRuleAmount := MaxR(0, 0.5 * (Additions-Proceeds)); //20190613
     HalfRuleAmount := RoundCorrect(HalfRuleAmount);
    end;
  end
  else
    HalfRuleAmount := 0;
  end;

  If (Aiip=True) then
  Begin
   HalfRuleAmount:=0;   //20190608
   //20190707
   ProceedsAiip:=MaxR(0,Proceeds+AssistanceReceived-Additions+AdditionsAiiP-RepaidAmount);
   NetCapCostAdditionsAiip:=MaxR(0,AdditionsAiip-ProceedsAiip);
   UccAdjustmentAiip:=NetCapCostAdditionsAiip*vl(AiipFactor);

   UccAdjustmentNONAiip:=MaxR(0,0.5 * (Additions-AdditionsAiip-AssistanceReceived+RepaidAmount-Proceeds)); //20190622 moved from below
   if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34') then UccAdjustmentNONAiip:=0; //20190622  //fast write off //20190622
   UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount-Proceeds; //20220618 -UccAdjustmentNONAiip+UccAdjustmentAiip;
   if (cls='10.1')
   and (OverrideIndic<>'Y')   //20220619
   then
   Begin
    UccReduced:=Additions + Adjustments - AssistanceReceived + RepaidAmount+Round(Additions/2); //20190622
   end;
  End
  Else  //NO aiip
  Begin
   if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34')  //fast write off //20190622
   then UccAdjustmentNONAiip:=0; //20190622
   UCCReduced := UCC - HalfRuleAmount;
   if LeaseHold(Cls) then UccReduced:=UCC;  //20190611
   ProceedsAiip:=0;
   NetCapCostAdditionsAiip:=0;
   UccAdjustmentAiip:=0;
  end;

    //put amounts on the S8 form
    Tv[12+k*16]:=HalfRuleAmount;
    if AiiP then Tv[12+k*16]:=0;   //remove half ruleamount
    Tv[11+k*16]:=UCCReduced;
    Strings[17+k*16]:=Rate;

    Tv[291+k*1]:=ProceedsAiip; //UccAdjustmentNONAiip;
    Tv[304+k*1]:=NetCapCostAdditionsAiip;
    Strings[343+k*1]:=AiipFactor;
    if Cls='' then Strings[343+k*1]:='';

    Tv[317+k*1]:=UccAdjustmentAiip;
    If Cls>'' then Tv[330+k*1]:=UccAdjustmentNONAiip;  //20190622

    //cca calcs
    if UCCReduced < 0 then
    begin
     CCA := 0;
     TerminalLoss := 0;
     Recapture := ABS(UCCReduced);
     if Cls = '10.1' then Recapture:=0;
    end
    else  //positive ucc = CCA or Terminal loss upon disposal
    begin
     TerminalLoss := 0;
     Recapture := 0;

     //20190313
     if Aiip then
      CCA:=Round(UCCReduced * Vl(Rate)/100)  //20190622
     else
      CCA:=Round(UCCReduced * Vl(Rate) / 100);

     if (LeaseHold(Cls)) and (AIIP=False) then  //20190613
       CCA := MinR(UCCReduced, LeaseMaxCCA);

     if (Leasehold(Cls)) then
     Begin
      If (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
      then
        CCA:=Round(CCA/2); //20190705
     end;

     If (LeaseHold(Cls)) Then  //20190725
     Begin
      If (Aiip=true)
      and (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
      and (AdditionsAiip>0)
      then  CCA:=CCA *3; //first year  //20190725
     end;


     if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then CCA:=UccReduced; //fast wrire offs 20190609
     if (cls='12') then CCA:=UccReduced; //20210623

     //20210726
     if (isLeapYear(GetTaxationYearEndYYYY(RetNo))
     and (GetTaxationYearEnd(RetNo)>'2020/02/28')) then
      CCA:=CCA * Ret[RetNo].DaysInYear / 366
     Else
      CCA:=CCA * Ret[RetNo].DaysInYear / 365;


     if (cls='12') or (cls='24')  or (cls='27') or(cls='29') or (cls='34') then CCA:=UccReduced; //fast wrire offs 20210623

     if OverrideIndic='Y' then CCA:=Tv[20+k*16];

     if TermLossIndic='Y' then
     Begin
      TerminalLoss:=UccReduced+UCCAdjustmentNONAIIp; //20190626    //TerminalLoss:=UccReduced;
      Tv[19+k*16]:=TerminalLoss;
      Recapture:=0;
      Tv[18+k*16]:=0;
      CCA:=0;
      UccEnd :=0;
     End;


     UccEnd := MaxR(0, UCCReduced - CCA);

     if AiiP=False then
       UccEnd:=MaxR(0,UCCReduced-CCA+HalfRuleAmount)        //20190622
     Else //Aiip is true
     Begin
       UccEnd:=MaxR(0,UccReduced-CCA+UCCAdjustmentNONAIIp-UCCAdjustmentAIIp);  //20190707
     //  If Cls='10.1' then UccEnd:=MaxR(0,UCCReduced-CCA-UCCAdjustmentNONAIIp);  //20190707  //2022017
     end;
    end;
    if (cls = '10.1') then begin TerminalLoss := 0;Recapture := 0;end; //20190607
    if (cls = '10.1') and (proceeds > 0) then
    begin
     CCA := Round(CCA/2); //Round((UccStart + Adjustments) / 2 * Vl(Rate) / 100);  //20190705
     UccEnd := 0;
    end;

    //20190626
    if (Recapture>0) or (TerminalLoss>0) then UCcEnd:=0;

    Tv[20+k*16]:=CCA;
    Tv[21+k*16]:=UccEnd;
    Tv[18+k*16]:=Recapture;
    Tv[19+k*16]:=TerminalLoss;

    //add to totals //20190614
    Tv[249]:=Tv[249]+uccStart;
    Tv[234]:=Tv[234]+Additions;
    Tv[250]:=Tv[250]+Adjustments;
    Tv[235]:=Tv[235]+Proceeds;

    Tv[230]:=Tv[230]+Recapture;
    Tv[231]:=Tv[231]+TerminalLoss;
    Tv[232]:=Tv[232]+CCA;
    Tv[251]:=Tv[251]+UccEnd;

  End; //k 0 to 12
 End; //with?
 SaveTv(RetNo,FName,FNo);
 //20220608
 x:=Vl(FetchElmFNo(RetNo,FNo,232));
// S8New(RetNo,FName,FNo);
 end;
*)

//20240726 Igor >>>
//procedure UHT(RetNo: integer; FName: String;FNo: integer);  //20231020
//var s:string;i:integer;
//Begin
// //if FNo=0 then exit; //20230626
// LoadTv(RetNo,FName,FNo);
// with ret[RetNo].Frm[Fno] do
// begin
//   //20231020
//   If Strings[2]='' then Strings[2]:='2023';  //20231020
//   Strings[3]:=GetCorpName(RetNo);
//   Strings[4]:=GetBN(RetNo);
//
//   If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',12);   //str
//   If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',17);   //prov
//   If Strings[7]='' then Strings[7]:=FetchElm(RetNo,'T2',19);   //country
//   If Strings[8]='' then Strings[8]:=FetchElm(RetNo,'T2',20);   //postl
//   If Strings[9]='' then Strings[9]:=FetchElm(RetNo,'T2',755) +' '+FetchElm(RetNo,'T2',746);   //Tel
//
//   if Tv[41]=0  then Tv[41]:=100;
//   if Tv[41]>100 then Tv[41]:=100;
//
//   Tv[70]:=MaxR(Tv[68],Tv[69]);
//
//
//   Strings[107]:=FormatFloat('###',Vl(strings[99])+Vl(Strings[101])
//               +Vl(Strings[103])+Vl(Strings[105])
//               -Vl(Strings[106])
//               );
//   if Vl(Strings[107])<0 then Strings[107]:='';
//
//   if Strings[126]>'' then  //fmv
//    Tv[130]:=Tv[128]
//   Else
//    Tv[130]:=Tv[70];
//
//   Tv[131]:=Tv[41];
//   Tv[132]:=Tv[130]*Tv[131]/100;
//   Tv[133]:=Tv[132];
//   Tv[134]:=Tv[133]*1/100;
//   Tv[135]:=Tv[134];  //$ enclosed
//   if Strings[138]='' then Strings[138]:=FormatDateTime('yyyy-mm-dd',Now);  //20240407
// end;
// SaveTv(RetNo,FName,FNo);
//end;
// //20240726 Igor  <<<

end.


