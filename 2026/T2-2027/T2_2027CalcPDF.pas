unit T2_2027calcpdf;

interface
{
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 UDeclare,common, common2,TrimStr;
}

Procedure SCT1(RetNo:integer;FName:string;FNo:integer);
Procedure Co17(RetNo:integer;FName:string;FNo:integer);
Procedure Co17A1(RetNo:integer;FName:string;FNo:integer);
Procedure Test(RetNo:integer;FName:string;FNo:integer);
 { I M P L E M E N T A T I O N }
implementation

Uses
  SysUtils,
  vtMulti, vtCommon,
  //ChildWinNew,Main,Ucalc;
  T2_2027, T2_2027Declare,T2_2027common, T2_2027common2,T2_2027TrimStr,
  vtTrimStr,vtShared;


Procedure SCT1(RetNo:integer;FName:string;FNo:integer);
var i,NumFlds: integer;
Begin

  NumFlds:=GetNumbFields(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
   //LoadTv(RetNo,FName,FNo);
   //For i:=1 to NumFlds do TV[i] := Vl(FetchElmFNo(RetNo,FNo,i));
   Strings[3]:=MidStr(GetTaxationYearEnd(RetNo),6,2)+LeftStr(GetTaxationYearEnd(RetNo),4);
   Strings[51]:=FloatToStr(Vl(Strings[47])+Vl(Strings[48])+Vl(Strings[49])+Vl(Strings[50]));
   UserMsg(Strings[51]);
   //Strings[57]:='57';
   //Tv[52]:=Tv[51];
  end;
  //For i:=1 to NumFlds do StoreElm(RetNo,FNo,i,Ret[RetNo].Frm[FNo].Strings[i]);
  //SaveTv(RetNo,FName,FNo);
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

Procedure Co17(RetNo:integer;FName:string;FNo:integer);
var i,NumFlds: integer;
Begin
  //CalcFed(RetNo);
  NumFlds:=GetNumbFields(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[4]:=Strings[1]+'Calculated';
  end;
  For i:=1 to NumFlds do StoreElm(RetNo,FNo,i,Ret[RetNo].Frm[FNo].Strings[i]);
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

Procedure Test(RetNo:integer;FName:string;FNo:integer);
var i,NumFlds: integer;
Begin
  //CalcFed(RetNo);
  NumFlds:=GetNumbFields(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[3]:=Strings[1]+'Calculated';
  end;
  For i:=1 to NumFlds do StoreElm(RetNo,FNo,i,Ret[RetNo].Frm[FNo].Strings[i]);
end;


Procedure Co17A1(RetNo:integer;FName:string;FNo:integer);
var i,NumFlds: integer;
Begin
  NumFlds:=GetNumbFields(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[3]:=Strings[1]+'Calculated';
  end;
  For i:=1 to NumFlds do StoreElm(RetNo,FNo,i,Ret[RetNo].Frm[FNo].Strings[i]);
end;

end.
