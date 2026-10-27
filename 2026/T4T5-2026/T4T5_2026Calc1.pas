unit T4T5_2026calc1;
{? need polit contr from POLIT}
interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T4T5_2026Declare, T4T5_2026common, T4T5_2026common2, T4T5_2026TrimStr;
    { procedure POLIT(RetNo: integer; FName: String;FNo: integer);}


Procedure Invoice(RetNo:integer;FName:string;FNo:integer);
Procedure InvForms(RetNo:integer;FName:string;FNo:integer);

procedure NPAD(RetNo: integer; FName: String;FNo: integer);
procedure NPADC(RetNo: integer; FName: String;FNo: integer);
procedure PRIVAT(RetNo: integer; FName: String;FNo: integer);


implementation
Uses T4T5_2026Calc, vtShared, T4T5_2026, vtCommon, vtTrimStr, vtMulti;

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
 //20180102
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

    If Strings[210]='' then Strings[210]:=LeftStr(FetchElm(RetNo,'EMPL',1),6)+'-'+'T4T5-17';
    Strings[281]:=FetchElm(RetNo,'EMPL',9)+' '+FetchElm(RetNo,'EMPL',10);  //Tel


    If Strings[223]+Strings[224]+strings[225]
     +Strings[281]+Strings[271]+strings[286] >'' then
    begin
        If Strings[209] = '' then Strings[209] := DateToStr(Date);
    end
    else
        Strings[209] := '';

    if Strings[1]='' then strings[1]:='100';

    //bill to
    Strings[211]:=FetchElm(RetNo,'EMPL',1);  //nm
    Strings[212]:=FetchElm(RetNo,'EMPL',2);   //Str
    Strings[215]:=FetchElm(RetNo,'EMPL',3)+' '+FetchElm(RetNo,'EMPL',4)+' '+FetchElm(RetNo,'EMPL',5); //City prov an d postal

    if Strings[216]='' then Strings[216]:='Preparation and Filing of Slips and Summaries';

    {
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
    }
    if Strings[251]+Strings[252]='' then
     begin Strings[251]:='X'; Strings[252]:=''; end;

    //If Strings[249]>'' then Tv[217]:= GetTotalFee(RetNo);
    If Strings[252]>'' then Tv[217]:= Vl(Strings[250]) * Vl(Strings[1])/60;

    Tv[219] := Tv[217] + Tv[218]+Tv[234] + Tv[235]+Tv[236] + Tv[237]+Tv[238] + Tv[239]+
                Tv[242] + Tv[243]+
                Tv[256] + Tv[257]+Tv[258] + Tv[261]+Tv[262] + Tv[265]
                +Tv[266] + Tv[267]+Tv[270];

    Strings[220]:=FormatFloat('###.##',OptRec.Opr_GstHst);   //20180103

    Tv[276] := Tv[219] * Vl(Strings[275]) / 100;
    Tv[277]:=Tv[219]-Tv[276];
    Tv[221]:=Tv[277] * Vl(Strings[220])/100;
    Tv[248]:=Tv[277] * Vl(Strings[214])/100;
    Tv[222] := Tv[277] + Tv[221]+Tv[248];
    Tv[284]:=Tv[222]-Tv[283];
    //Strings[226] := User.Prep_Name;
    {
    If Strings[208] = '' then
        Strings[220] := ''
    else
        Strings[220] :=FormatFloat('###.##',OptRec.Opr_GstHst);
    }

  (*
    //footnotes
    With OptRec do
    begin
        Strings[253]:=InvFoot1;
        Strings[254]:=InvFoot2;
        Strings[255]:=InvFoot3;
        Strings[256]:=InvFoot4;
        Strings[257]:=InvFoot5;
    end;
 *)
 end; //end with
 SaveTv(RetNo,FName,FNo);
end;
//20180102 Igor>>>
exports
  Invoice,
  InvForms,
  NPAD,
  NPADC,
  PRIVAT;
//20180102 Igor<<<

end.
