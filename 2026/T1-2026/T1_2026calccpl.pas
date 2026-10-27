unit T1_2026CalcCpl;
//clone a,b=From, to
interface
uses

 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T1_2026Declare, T1_2026common, T1_2026common2, T1_2026TrimStr, T1_2026T1Rtns; //20160119 Igor

Procedure CplXfer(SpRetNo:Integer;CurRetNo:integer);
Procedure ReverseOn428A(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseS14(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseS6(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseS12(SpRetNo:Integer;CurRetNo:Integer);
Procedure CopyPrincipalResidence(SpRetNo:Integer;CurRetNo:Integer);
//Procedure ReverseONS12(SpRetNo:Integer;CurRetNo:Integer); //20211226
Procedure ReverseS12BC(SpRetNo:Integer;CurRetNo:Integer);
//Procedure ReverseS12SK(SpRetNo:Integer;CurRetNo:Integer);  //20220225
Procedure ReverseS12NB(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseOPTIMIZE(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseDepend(SpRetNo:Integer;CurRetNo:integer);
Procedure ReverseDisab(SpRetNo:Integer;CurRetNo:integer);
Procedure ReverseMedical(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseDon(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReversePolit(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseAdopt(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReversePTransit(SpRetNo:Integer;CurRetNo:Integer);
Procedure ApplySharedStatements(SpRetNo:Integer;CurRetNo:integer); //T5, T3 T2125 etc
Procedure CopyUCCB(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseUCCB(SpRetNo:Integer;CurRetNo:Integer);
Procedure CopyT1032(SpRetNo:Integer;CurRetNo:Integer);
//Procedure CopySPORTS(SpRetNo:Integer;CurRetNo:Integer);  //20151114
Procedure CopyFitness(SpRetNo:Integer;CurRetNo:Integer);
Procedure CopyARTS(SpRetNo:Integer;CurRetNo:Integer);
Procedure CopyBCARTS(SpRetNo:Integer;CurRetNo:Integer);
Procedure CopyMBARTS(SpRetNo:Integer;CurRetNo:Integer);
Procedure CopyYTARTS(SpRetNo:Integer;CurRetNo:Integer);
Procedure CopyMBFitnes(SpRetNo:Integer;CurRetNo:Integer);
//Procedure ReverseCATC(SpRetNo:Integer;CurRetNo:Integer);   //20171119
Procedure CreateS2(SpRetNo:Integer;CurRetNo:integer);
Procedure ReverseGstCredit(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReversePrvCredits(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseCTB(SpRetNo:Integer;CurRetNo:Integer);

Procedure ReverseHOMEBUY(SpRetNo:Integer;CurRetNo:Integer);
Procedure ReverseJointInvoice(SpRetNo:Integer;CurRetNo:Integer);

implementation
Uses vtCommon, //20160119 Igor
  T1_2026,T1_2026Calc,T1_2026ChildWinNew,
  vtTrimStr, vtShared;

Procedure CplXfer(SpRetNo:Integer;CurRetNo:integer);
var i:integer;
begin
UpdateAllDataIndicators(SpRetNo);
//ApplySharedStatements(SpRetNo,CurRetNo); //done in calcall but not calcforoptimize
CopyUCCB(SpRetNo,CurRetNo);
CopyT1032(SpRetNo,CurRetNo);
CopyPrincipalResidence(SpRetNo,CurRetNo);
ReverseUCCB(SpRetNo,CurRetNo);
ReverseON428A(SpRetNo,CurRetNo); //20200227
ReverseDepend(SpRetNo,CurRetNo);
ReverseDISAB(SpRetNo,CurRetNo);
ReverseMedical(SpRetNo,CurRetNo);
ReverseAdopt(SpRetNo,CurRetNo);
ReversePTransit(SpRetNo,CurRetNo);
ReverseHOMEBUY(SpRetNo,CurRetNo);

CreateS2(SpRetNo,CurRetNo);
ReverseDon(SpRetNo,CurRetNo);
ReversePolit(SpRetNo,CurRetNo);

ReverseOptimize(SpRetNo,CurRetNo); //after other reversals

CopyFitness(SpRetNo,CurRetNo);
CopyARTS(SpRetNo,CurRetNo);
CopyBCARTS(SpRetNo,CurRetNo);
CopyMBARTS(SpRetNo,CurRetNo);
CopyYTARTS(SpRetNo,CurRetNo);

CopyMBFitnes(SpRetNo,CurRetNo);

ReverseGstCredit(SpRetNo,CurRetNo);
ReverseJointInvoice(SpRetNo,CurRetNo);
ReverseCTB(SpRetNo,CurRetNo);
ReverseS6(SpRetNo,CurRetNo);  //20161121
ReverseS12(SpRetNo,CurRetNo);  //20161121
ReverseS14(SpRetNo,CurRetNo);  //20190405
//ReverseONS12(SpRetNo,CurRetNo);
ReverseS12BC(SpRetNo,CurRetNo);
//ReverseS12SK(SpRetNo,CurRetNo);  //20220225
ReverseS12NB(SpRetNo,CurRetNo);
ReversePrvCredits(SpRetNo,CurRetNo);

UpdateAllDataIndicators(CurRetNo);
UpdateAllDataIndicators(SpRetNo);
Sumslips(CurRetNo,'T3MULT');
end;

Procedure ReverseDepend(SpRetNo:Integer;CurRetNo:integer);
Var i:integer;FNo:Integer;k:Integer; EligIndicator:String;
Begin
  FNo:=GetFormNo('DEPEND');
  // CloneForm(SpRetNo,'DEPEND',CurRetNo);
  //special clone - all except eligible dependant indicator
  InitFormData(CurRetNo,FNo);
  For i:=1 to 199 do //161 do      //20130227
  begin
   If (i=19) or (i=34) or (i=49) or (i=64) or (i=79) or (i=94)
   or (i=109) or (i=124)or (i=139)
   or (i=160) or (i=140)  //who claims and %   //20101206
   then
   //do not copy elig dependant column
   else
    StoreElm(CurRetNo,FNo,i,FetchElmFNo(SpRetNo,FNo,i));
  end;

  //reverse the Ln367 indicator
  i:=163;    //ndx to ln 367
  Repeat
   If UpperCase(FetchElmFNo(SpRetNo,FNo,i)) = 'Y' then
    StoreElm(CurRetNo,FNo,i,'N')
   else
     StoreElm(CurRetNo,FNo,i,'Y');
   Inc(i,1);
  until i>171;

  If UpperCase(FetchElmFNo(SpRetNo,FNo,140)) = 'Y' then   //claim on S5
    StoreElm(CurRetNo,FNo,140,'N')
  else
    StoreElm(CurRetNo,FNo,140,'Y');

  StoreElm(CurRetNo,FNo,160,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,160)))); //% claim

end;

Procedure ReverseDisab(SpRetNo:Integer;CurRetNo:integer);
Var FNo:Integer;
Begin
  FNo:=GetFormNo('TRANSF');
  //March 20 2008
  If ((FetchElmFNo(CurRetNo,FNo,158) ='Y')
  Or (FetchElmFNo(SpRetNo,FNo,158) ='Y'))
  then
  begin
    //StoreElm(CurRetNo,FNo,158,FetchElmFNo(SpRetNo,FNo,158)); //20090225
  end
  Else
  begin
   //disab
   CloneForm(SpRetNo,'TRANSF',CurRetNo,'TRANSF',True); //20170131
   StoreElm(CurRetNo,FNo,69,FetchElmFNo(SpRetNo,FNo,48));
   StoreElm(CurRetNo,FNo,48,FetchElmFNo(SpRetNo,FNo,69));

   StoreElm(CurRetNo,FNo,70,FetchElmFNo(SpRetNo,FNo,50));
   StoreElm(CurRetNo,FNo,50,FetchElmFNo(SpRetNo,FNo,70));

  end;
end;

Procedure ReverseOptimize(SpRetNo:Integer;CurRetNo:Integer);
Var FNo,MedFNo :Integer;s:String;TotMedExp,RemainingMedExp:Real;
begin
 FNo := GetFormNo('OPTIMIZE');
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);

 //Pension
 //months
 StoreElm(CurRetNo,FNo,42,FetchElmFNo(SpRetNo,FNo,43));
 StoreElm(CurRetNo,FNo,43,FetchElmFNo(SpRetNo,FNo,42));
 StoreElm(CurRetNo,FNo,44,FetchElmFNo(SpRetNo,FNo,44));

 StoreElm(CurRetNo,FNo,35,FetchElmFNo(SpRetNo,FNo,24));
 StoreElm(CurRetNo,FNo,24,FetchElmFNo(SpRetNo,FNo,35));

 StoreElm(CurRetNo,FNo,31,FetchElmFNo(SpRetNo,FNo,31)); //IncrBy
 StoreElm(CurRetNo,FNo,17,FetchElmFNo(SpRetNo,FNo,17)); //include for optimization
 //which ret to optimize
  If UpperCase(FetchElmFNo(CurRetNo,FNo,13)) ='X' then
   begin
     StoreElm(CurRetNo,FNo,13,'');
     StoreElm(CurRetNo,FNo,14,'X');
   end
   else
   begin
     StoreElm(CurRetNo,FNo,13,'X');
     StoreElm(CurRetNo,FNo,14,'')
   end;
  //Accuracy
  StoreElm(CurRetNo,FNo,56,FetchElmFNo(SpRetNo,FNo,56));
  StoreElm(CurRetNo,FNo,57,FetchElmFNo(SpRetNo,FNo,57));
  //results
  StoreElm(CurRetNo,FNo,22,FetchElmFNo(SpRetNo,FNo,22));
  StoreElm(CurRetNo,FNo,25,FetchElmFNo(SpRetNo,FNo,25));
  StoreElm(CurRetNo,FNo,26,FetchElmFNo(SpRetNo,FNo,26));

  //results  bfr any optimize section   //20110403
  If Vl(FetchElmFNo(SpRetNo,FNo,75))<>0 then StoreElm(CurRetNo,FNo,75,FetchElmFNo(SpRetNo,FNo,75));
  If Vl(FetchElmFNo(SpRetNo,FNo,76))<>0 then StoreElm(CurRetNo,FNo,76,FetchElmFNo(SpRetNo,FNo,76));
  If Vl(FetchElmFNo(SpRetNo,FNo,77))<>0 then StoreElm(CurRetNo,FNo,77,FetchElmFNo(SpRetNo,FNo,77));

 //Depend/S5
  StoreElm(CurRetNo,FNo,34,FetchElmFNo(SpRetNo,FNo,36)); //reverse %
  StoreElm(CurRetNo,FNo,36,FetchElmFNo(SpRetNo,FNo,34));

 //Disab  xfer
  StoreElm(CurRetNo,FNo,46,FetchElmFNo(SpRetNo,FNo,47)); //reverse %
  StoreElm(CurRetNo,FNo,47,FetchElmFNo(SpRetNo,FNo,46));

  //tution xfer
  StoreElm(CurRetNo,FNo,62,FetchElmFNo(SpRetNo,FNo,63)); //reverse %
  StoreElm(CurRetNo,FNo,63,FetchElmFNo(SpRetNo,FNo,62));
 
 //Medical
  StoreElm(CurRetNo,FNo,1,FetchElmFNo(SpRetNo,FNo,6)); //reverse %
  StoreElm(CurRetNo,FNo,6,FetchElmFNo(SpRetNo,FNo,1));
  StoreElm(CurRetNo,FNo,59,FetchElmFNo(SpRetNo,FNo,60)); //reverse %
  StoreElm(CurRetNo,FNo,60,FetchElmFNo(SpRetNo,FNo,59));

  //Donations
  StoreElm(CurRetNo,FNo,9,FetchElmFNo(SpRetNo,FNo,12)); //via calc
  StoreElm(CurRetNo,FNo,12,FetchElmFNo(SpRetNo,FNo,9));


 //Political
  StoreElm(CurRetNo,FNo,15,FetchElmFNo(SpRetNo,FNo,18)); //via calc
  StoreElm(CurRetNo,FNo,18,FetchElmFNo(SpRetNo,FNo,15));
 //Adoption
  StoreElm(CurRetNo,FNo,49,FetchElmFNo(SpRetNo,FNo,50)); //via calc
  StoreElm(CurRetNo,FNo,50,FetchElmFNo(SpRetNo,FNo,49));
 //Pransit
  StoreElm(CurRetNo,FNo,8,FetchElmFNo(SpRetNo,FNo,11)); //via calc
  StoreElm(CurRetNo,FNo,11,FetchElmFNo(SpRetNo,FNo,8));

 //HomeBuy
  StoreElm(CurRetNo,FNo,67,FetchElmFNo(SpRetNo,FNo,68)); //via calc
  StoreElm(CurRetNo,FNo,68,FetchElmFNo(SpRetNo,FNo,67));

end;

Procedure ReverseMedical(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
begin
 //Medical
 FNo := GetFormNo('MEDICAL');
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 CloneMedical(SpRetNo,CurRetNo);
 StoreElm(CurRetNo,FNo,233,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,233))));
 StoreElm(CurRetNo,FNo,236,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,236))));
 Calc(CurRetNo,'MEDICAL');
end;


Procedure ReverseS12(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
Begin
 //20170311
 FNo := GetFormNo('S12#1');
 CloneForm(SpRetNo,'S12#1',CurRetNo,'S12#1',True); //20170131);
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 //20161127
 StoreElm(CurRetNo,FNo,171,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,172))));
 StoreElm(CurRetNo,FNo,172,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,171))));
 Calc(CurRetNo,'S12#1');

 //20170311
 FNo := GetFormNo('S12#2');
 if FNo>0 then
 Begin
  if Ret[SpRetNo].FrmHasData[FNo] then
  begin
   CloneForm(SpRetNo,'S12#2',CurRetNo,'S12#2',True); //20170131);
   If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
   //20161127
   StoreElm(CurRetNo,FNo,171,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,172))));
   StoreElm(CurRetNo,FNo,172,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,171))));
   Calc(CurRetNo,'S12#2');
  end;
 End;
end;



Procedure ReverseS12BC(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
Begin
 FNo := GetFormNo('S12BC');
 CloneForm(SpRetNo,'S12BC',CurRetNo,'S12BC',True); //20170131;
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 StoreElm(CurRetNo,FNo,171,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,172))));
 StoreElm(CurRetNo,FNo,172,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,171))));
 Calc(CurRetNo,'S12BC');
end;


(*
Procedure ReverseS12SK(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
Begin
 FNo := GetFormNo('S12SK');
 CloneForm(SpRetNo,'S12SK',CurRetNo,'S12SK',True); //20170131;
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 StoreElm(CurRetNo,FNo,171,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,172))));
 StoreElm(CurRetNo,FNo,172,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,171))));
 Calc(CurRetNo,'S12SK');
end;
*)
//20151102
Procedure ReverseS12NB(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
Begin
 FNo := GetFormNo('S12NB');
 CloneForm(SpRetNo,'S12NB',CurRetNo,'S12NB',True); //20170131;
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 StoreElm(CurRetNo,FNo,171,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,172))));
 StoreElm(CurRetNo,FNo,172,FormatFloat('###.##',Vl(FetchElmFNo(SpRetNo,FNo,171))));
 Calc(CurRetNo,'S12NB');
end;



Procedure ReverseDon(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
Begin
 //Donations
 FNo := GetFormNo('DON'); //20170101
 CloneDonations(SpRetNo,CurRetNo);
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 StoreElm(CurRetNo,FNo,6,Ret[SpRetNo].Frm[FNo].Strings[6]);

 (*20170225
 If FetchElmFNo(SpRetNo,FNo,187)>'' then  //force to a spouse
 Begin
   StoreElm(SPRetNo,FNo,179,'100');   //20170225  spouse forced
   StoreElm(CurRetNo,FNo,179,'');
   StoreElm(CurRetNo,FNo,187,'');
 End
 Else
  If FetchElmFNo(CurRetNo,FNo,187)>'' then  //force to a spouse //20170225  spouse forced
  Begin
    StoreElm(CurRetNo,FNo,179,'100');   //20170225  spouse forced
    StoreElm(SpRetNo,FNo,179,'');
    StoreElm(SpRetNo,FNo,187,'');
  End;

//  StoreElm(CurRetNo,FNo,179,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,179))));
 //StoreElm(CurRetNo,FNo,179,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,179)))); //20170218
 *)
 Calc(CurRetNo,'DON');
end;

Procedure ReversePolit(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
Begin
 FNo := GetFormNo('POLIT');
 CloneForm(SpRetNo,'POLIT',CurRetNo,'POLIT',True); //20170131;
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 StoreElm(CurRetNo,FNo,26,FetchElmFNo(SpRetNo,FNo,26)); //y indicator
 StoreElm(CurRetNo,FNo,19,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,19))));
 StoreElm(CurRetNo,FNo,27,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,27))));
 StoreElm(CurRetNo,FNo,42,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,42)))); //20240511
 Calc(CurRetNo,'POLIT');
end;


Procedure CopyUCCB(SpRetNo:Integer;CurRetNo:Integer);
Var i,j,FNo:Integer;s:String;
begin
 //20130403  //moved from reverse
 For i:=1 to 5 do //20130403
 Begin
  FNo := GetFormNo('RC62#'+IntToStr(i));
  If FNo>0 then
  begin
   If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
   If Ret[SpRetNo].Frm[Fno].Count =0 then InitFormData(SpRetNo,FNo);
  end;
 end;

 For i:=1 to 5 do //20130403
 Begin
  FNo := GetFormNo('RC62#'+IntToStr(i));
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  begin
    //20130413
    For j:=6 to 10 do begin StoreElm(CurRetNo,FNo,j,FetchElmFNo(SpRetNo,FNo,j));end; //20130403
    For j:=4 to 4 do begin StoreElm(CurRetNo,FNo,j,FetchElmFNo(SpRetNo,FNo,j));end; //20130403
    For j:=22 to 22 do begin StoreElm(CurRetNo,FNo,j,FetchElmFNo(SpRetNo,FNo,j));end; //20130419
   // For j:=3 to 10 do begin StoreElm(CurRetNo,FNo,j,FetchElmFNo(SpRetNo,FNo,j));end //20130403
  end
  else
  begin
   //20130413
   For j:=6 to 10 do begin StoreElm(SpRetNo,FNo,j,FetchElmFNo(CurRetNo,FNo,j));end; //20130403
   For j:=4 to 4 do begin StoreElm(SpRetNo,FNo,j,FetchElmFNo(CurRetNo,FNo,j));end; //20130403
   //For j:=3 to 10 do begin StoreElm(SpRetNo,FNo,j,FetchElmFNo(CurRetNo,FNo,j));end //20130403
  end;
 end;

 (* 20130518
 //20130404
  If UpperCase(FetchElmFNo(SpRetNo,FNo,6))<> 'Y' then
  Begin
   If UpperCase(FetchElmFNo(SpRetNo,FNo,1)) = 'X' then
    begin
     StoreElm(CurRetNo,FNo,1,'');
     StoreElm(CurRetNo,FNo,2,'X');
    end
    else
     begin
      StoreElm(CurRetNo,FNo,1,'X');
      StoreElm(CurRetNo,FNo,2,'');
     end;
  end;
 *)
 //----
  //2013
  If FetchElm(CurRetNo,'RC62#1',7) ='' then //not claimed by dependant
  begin
    {20130404
     If UpperCase(FetchElmFNo(SpRetNo,FNo,1)) = 'X' then
      begin StoreElm(CurRetNo,FNo,1,'');StoreElm(CurRetNo,FNo,2,'X');end
     else
      begin StoreElm(CurRetNo,FNo,1,'X');StoreElm(CurRetNo,FNo,2,'');end;
    }
     {    //20130413
     s:=FetchElmFNo(CurRetNo,FNo,3);
     StoreElm(CurRetNo,FNo,3,FetchElmFNo(CurRetNo,FNo,5));
     StoreElm(CurRetNo,FNo,5,S);
     }
  end;
end;

Procedure ReverseUCCB(SpRetNo:Integer;CurRetNo:Integer);
Var FNo :Integer;S1,S2:String;
begin
 (*  20130403
 FNo := GetFormNo('RC62#1');
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 If Ret[SpRetNo].Frm[Fno].Count =0 then InitFormData(SpRetNo,FNo);

 //20130325
 FNo := GetFormNo('RC62#2');
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 If Ret[SpRetNo].Frm[Fno].Count =0 then InitFormData(SpRetNo,FNo);

  //20130325
 FNo := GetFormNo('RC62#3');
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 If Ret[SpRetNo].Frm[Fno].Count =0 then InitFormData(SpRetNo,FNo);
*)
end;


Procedure CopyFITNESS(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
  //20110215
  FNo := GetFormNo('FITNESS');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'FITNESS',CurRetNo,'FITNESS',True); //20170131;
   S1:=FetchElmFNo(SpRetNo,FNo,1);
   S2:=FetchElmFNo(SpRetNo,FNo,2);
   StoreElm(CurRetNo,FNo,1,S2);
   StoreElm(CurRetNo,FNo,2,S1);
  end;
end;

Procedure CopyARTS(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
 {
  //20110215
  FNo := GetFormNo('ARTS');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'ARTS',CurRetNo,'ARTS',True); //20170131;
   S1:=FetchElmFNo(SpRetNo,FNo,1);
   S2:=FetchElmFNo(SpRetNo,FNo,2);
   StoreElm(CurRetNo,FNo,1,S2);
   StoreElm(CurRetNo,FNo,2,S1);
  end;
 }
end;

//20220129
Procedure CopyPrincipalResidence(SpRetNo:Integer;CurRetNo:Integer);
Var i,FNo:Integer;s1,s2:String;SpousePercent:Real;
begin
  //20220229
  for i:=1 to 5 do
  Begin
   FNo := GetFormNo('T2091#'+IntToStr(i));
   if IsDeceased(SpRetNo) then GetFormNo('T1255#'+IntToStr(i));

   if (Fno>0) and (Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)]) then
   Begin
    if IsDeceased(CurRetNo) then  //?? SpRetNo
      CloneForm(SpRetNo,'T1255'+IntToStr(i),CurRetNo,'T2091'+IntToStr(i),True)
    Else
      CloneForm(SpRetNo,'T2091'+IntToStr(i),CurRetNo,'T2091'+IntToStr(i),True);
   end;
    //CloneForm(SpRetNo,'T2091'+IntToStr(i),CurRetNo,'T2091'+IntToStr(i),True);
    SpousePercent:=Vl(FetchElmFNo(SpRetNo,FNo,4));
    S2:=FormatFloat('###.##',100-SpousePercent);
    StoreElm(CurRetNo,FNo,4,S2);
  End;

  for i:=1 to 5 do
  Begin
   FNo := GetFormNo('T1255W#'+IntToStr(i));
   if (Fno>0) and (Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)]) then
   Begin
    CloneForm(SpRetNo,'T209W'+IntToStr(i),CurRetNo,'T209W'+IntToStr(i),True);
    SpousePercent:=Vl(FetchElmFNo(SpRetNo,FNo,4));
    S2:=FormatFloat('###.##',100-SpousePercent);
    StoreElm(CurRetNo,FNo,4,S2);
   End;
  End;
end;


Procedure CopyBCARTS(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
  //20110215
  FNo := GetFormNo('BCARTS');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'BCARTS',CurRetNo,'BCARTS',True); //20170131;
   S1:=FetchElmFNo(SpRetNo,FNo,1);
   S2:=FetchElmFNo(SpRetNo,FNo,2);
   StoreElm(CurRetNo,FNo,1,S2);
   StoreElm(CurRetNo,FNo,2,S1);
  end;
end;

Procedure CopyMBARTS(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
  //20110215
  FNo := GetFormNo('MBARTS');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'MBARTS',CurRetNo,'MBARTS',True); //20170131;
   S1:=FetchElmFNo(SpRetNo,FNo,1);
   S2:=FetchElmFNo(SpRetNo,FNo,2);
   StoreElm(CurRetNo,FNo,1,S2);
   StoreElm(CurRetNo,FNo,2,S1);
  end;
end;

Procedure CopyYTARTS(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
  //20110215
  FNo := GetFormNo('YTARTS');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'YTARTS',CurRetNo,'YTARTS',True); //20170131;
   S1:=FetchElmFNo(SpRetNo,FNo,1);
   S2:=FetchElmFNo(SpRetNo,FNo,2);
   StoreElm(CurRetNo,FNo,1,S2);
   StoreElm(CurRetNo,FNo,2,S1);
  end;
end;


Procedure CopyMBFITNES(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
  //20110215
  FNo := GetFormNo('MBFITNES');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'MBFITNES',CurRetNo,'MBFITNES',True); //20170131;
   S1:=FetchElmFNo(SpRetNo,FNo,1);
   S2:=FetchElmFNo(SpRetNo,FNo,2);
   StoreElm(CurRetNo,FNo,1,S2);
   StoreElm(CurRetNo,FNo,2,S1);
  end;
end;

(*  (*
  FNo := GetFormNo('CATC');
  If Ret[SpRetNo].FrmHasData[FNo] then
    CloneForm(SpRetNo,'CATC',CurRetNo,'CATC')
  else
  begin
   If Ret[CurRetNo].FrmHasData[FNo] then
    CloneForm(CurRetNo,'CATC',SpRetNo,'CATC');
  end;
  S1:=FetchElmFNo(CurRetNo,FNo,1);
  S2:=FetchElmFNo(CurRetNo,FNo,2);
  StoreElm(CurRetNo,FNo,1,S2);
  StoreElm(CurRetNo,FNo,2,S1);
 *)

(* //20171119
Procedure ReverseCATC(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
  FNo := GetFormNo('CATC');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'CATC',CurRetNo,'CATC',True); //20170131;
   S1:=FetchElmFNo(CurRetNo,FNo,1);
   S2:=FetchElmFNo(CurRetNo,FNo,2);
   StoreElm(CurRetNo,FNo,1,S2);
   StoreElm(CurRetNo,FNo,2,S1);
 end;
end;
*)


Procedure ReversePTransit(SpRetNo:Integer;CurRetNo:Integer);
Var j:Integer;x:Real;FNo:Integer;
Begin
  FNo:=GetFormNo('PTRANSIT');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  begin
   CloneForm(SpRetNo,'PTRANSIT',CurRetNo,'PTRANSIT',True); //20170131;
   {reverse % }
   StoreElm(CurRetNo,FNo,1,'Y');
   x:=Vl(FetchElmFNo(SpRetNo,FNo,79));  {%}
   StoreElm(CurRetNo,FNo,79,FloatToStr(100-x));
   Calc(CurRetNo,'PTRANSIT');
  end;
end;


Procedure ReverseOn428A(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;x:Real;
//clone from - to
begin
  {//20200302  Both can claim it
  FNo := GetFormNo('ON428A');
  if FetchElm(SpRetNo,FNo,48)='Y' then  // Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'ON428A',CurRetNo,'ON428A',True); //20170131;
   StoreElm(CurRetNo,FNo,48,'N'); //oonlyone can have Y
   Calc(CurRetNo,'ON428A');
  end;
  }
end;


Procedure ReverseHOMEBUY(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;x:Real;
//clone from - to
begin
  FNo := GetFormNo('HOMEBUY');
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  Begin
   CloneForm(SpRetNo,'HOMEBUY',CurRetNo,'HOMEBUY',True); //20170131;
    {reverse % }
   StoreElm(CurRetNo,FNo,2,'Y');
   x:=Vl(FetchElmFNo(SpRetNo,FNo,1));  {%}
   StoreElm(CurRetNo,FNo,1,FloatToStr(100-x));
   Calc(CurRetNo,'HOMEBUY');
  end;
end;


//20151114
(*
Procedure CopySPORTS(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2:String;
begin
  FNo := GetFormNo('SPORTS');
  If Ret[SpRetNo].FrmHasData[FNo] then
    CloneForm(SpRetNo,'SPORTS',CurRetNo,'SPORTS')
  else
    CloneForm(CurRetNo,'SPORTS',SpRetNo,'SPORTS');
  S1:=FetchElmFNo(CurRetNo,FNo,1);
  S2:=FetchElmFNo(CurRetNo,FNo,2);
  StoreElm(CurRetNo,FNo,1,S2);
  StoreElm(CurRetNo,FNo,2,S1);
end;
*)
Procedure CopyT1032(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;s1,s2,s3:String;
begin
  FNo := GetFormNo('T1032');
  If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
  If Ret[SpRetNo].Frm[Fno].Count =0 then InitFormData(SpRetNo,FNo);

  S1:=FetchElmFNo(SpRetNo,FNo,42);
  S2:=FetchElmFNo(SpRetNo,FNo,45);
  If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
  begin
   CloneForm(SpRetNo,'T1032',CurRetNo,'T1032');
   StoreElm(CurRetNo,FNo,34,FetchElmFNo(SpRetNo,Fno,34));   //20110123
   StoreElm(CurRetNo,FNo,32,FetchElmFNo(SpRetNo,Fno,32));   //20110124
   StoreElm(CurRetNo,FNo,42,S2);
   StoreElm(CurRetNo,FNo,45,S1);

   //T1032(RetNo,'T1032',FNo);   //20110123
   T1032(CurRetNo,'T1032',FNo);
   { did not work
   //line k 20090304
   StoreElm(CurRetNo,FNo,50,FetchElmFNo(SpRetNo,FNo,50));
   StoreElm(CurRetNo,FNo,22,FetchElmFNo(SpRetNo,FNo,22));
   }
  end;
end;


Procedure ReverseAdopt(SpRetNo:Integer;CurRetNo:Integer);
Var J,FNo:Integer;s:String;x:Real;
begin
 for j:=1 to 4 do //4 adoptions
 begin
  FNo:=GetFormNo('ADOPT#'+IntToStr(j));
  If ret[SpRetNo].FormHasData[GetFormName(SpRetNo,Fno)] then
  begin
   CloneForm(SpRetNo,'ADOPT#'+IntToStr(j),CurRetNo,'ADOPT#'+IntToStr(j),True); //20170131;
   StoreElm(CurRetNo,FNo,6,'Y');
   x:=Vl(FetchElmFNo(SpRetNo,FNo,5));  {%}
   StoreElm(CurRetNo,FNo,5,FloatToStr(100-x));
   Calc(CurRetNo,'ADOPT#'+IntToStr(J));
  end;
 end;
end;

Procedure ApplySharedStatements(SpRetNo:Integer;CurRetNo:integer);
{calculates SpouseB=second parameter}
Var i,j,jj,jjj,k,FNo,{NewFNo,}result : Integer;
x :real;
CplSin : string[9];
S,s1,S2,s3 : string[10]; ss:string[1];SAlloc:String[7];
begin
 FormatSettings.DecimalSeparator:='.';
 {NOW xfer SHARED DEPEND, T5,t3,T2032,T2125,T2042,T2121, Rental-776}

 for j :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[j];
  FNo:=Frec.FormNo;

 {T5MULT}
  If ((Frec.FormName = 'T5MULT') and (Ret[SpRetNo].Frm[FRec.FormNo].Count > 0)) then
  begin
   s := MidStr(Frec.FormInst,2,2);
   if Ret[SpRetNo].FrmHasData[FNo] then CloneForm(SpRetNo,'T5MULT#'+s,CurRetNo,'T5MULT#'+s,True); //20170131;
  // 20160814  if Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then CloneForm(SpRetNo,'T5MULT#'+s,CurRetNo,'T5MULT#'+s);

   k:=1;
   Repeat
    //copy shared slip column
    For jj:=1+(k-1)*22 to 16+(k-1)*22 do
       StoreElm(CurRetNo,FNo,jj,FetchElmFNo(SpRetNo,FNo,jj));
    StoreElm(CurRetNo,FNo,14,FetchElmFNo(SpRetNo,FNo,14));
    StoreElm(CurRetNo,FNo,36,FetchElmFNo(SpRetNo,FNo,36)); //changed jan 27..
    StoreElm(CurRetNo,FNo,58,FetchElmFNo(SpRetNo,FNo,58));
    StoreElm(CurRetNo,FNo,80,FetchElmFNo(SpRetNo,FNo,80));
    StoreElm(CurRetNo,FNo,102,FetchElmFNo(SpRetNo,FNo,102));


    StoreElm(CurRetNo,FNo,140+k,FetchElmFNo(SpRetNo,FNo,140+k));   //taxable div eligible //20160816
    //20160724 Igor >>>
    StoreElm(CurRetNo,FNo,131,FetchElmFNo(SpRetNo,FNo,131));
    StoreElm(CurRetNo,FNo,132,FetchElmFNo(SpRetNo,FNo,132));
    StoreElm(CurRetNo,FNo,133,FetchElmFNo(SpRetNo,FNo,133));
    StoreElm(CurRetNo,FNo,134,FetchElmFNo(SpRetNo,FNo,134));
    StoreElm(CurRetNo,FNo,135,FetchElmFNo(SpRetNo,FNo,135));
    //20160724 Igor <<<
    {adjust and reverse % }
    StoreElm(CurRetNo,FNo,2+(k-1)*22,FetchElmFNo(SpRetNo,FNo,3+(k-1)*22));
    StoreElm(CurRetNo,FNo,3+(k-1)*22,FetchElmFNo(SpRetNo,FNo,2+(k-1)*22));
    StoreElm(CurRetNo,FNo,81+(k-1)*22,FetchElmFNo(SpRetNo,FNo,81+(k-1)*22));
   Inc(k,1);
   until k>5;


   //20160816  100-... SpRetNo..
   //put 100 on current spouse unless the slip has been used
   If FetchElmFno(CurRetNo,FNo,131)='' then //slip not used
    begin
      StoreElm(CurRetNo,FNo,2,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,81))));   //sp instead of CurRetNo //20160816
     //StoreElm(CurRetNo,FNo,2,FormatFloat('###.##',100-Vl(FetchElmFNo(CurRetNo,FNo,81))));
      StoreElm(CurRetNo,FNo,3,'');
    end;
   If FetchElmFno(CurRetNo,FNo,132)='' then //slip not used
    begin
      StoreElm(CurRetNo,FNo,24,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,103))));
      StoreElm(CurRetNo,FNo,25,'');
    end;

   If FetchElmFno(CurRetNo,FNo,133)='' then //slip not used
    begin
      StoreElm(CurRetNo,FNo,46,FormatFloat('###.##',100-Vl(FetchElmFNo(spRetNo,FNo,125))));
      StoreElm(CurRetNo,FNo,47,'');
    end;

   If FetchElmFno(CurRetNo,FNo,134)='' then //slip not used
   begin
      StoreElm(CurRetNo,FNo,68,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,147))));
      StoreElm(CurRetNo,FNo,69,'');
   end;

  If FetchElmFno(CurRetNo,FNo,135)='' then //slip not used
    begin
      StoreElm(CurRetNo,FNo,90,FormatFloat('###.##',100-Vl(FetchElmFNo(SpRetNo,FNo,169))));
      StoreElm(CurRetNo,FNo,91,'');
    end;

   Calc(CurRetNo,'T5MULT#'+s);
   Calc(SpRetNo,'T5MULT#'+s);
  end //t5mult
 //end;

  {T3MULT}
  Else If ((Frec.FormName = 'T3MULT') and (Ret[SpRetNo].Frm[FRec.FormNo].Count > 0)) then
  begin
   s := MidStr(Frec.FormInst,2,2);
   if Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
     CloneForm(SpRetNo,'T3MULT#'+s,CurRetNo,'T3MULT#'+s, true); //20160724 Igor
   //after Clone all T3Mult amounts are supposed to be in the CurRetNo
   //copy shared slip column
   For jj:=11 to 15 do StoreElm(CurRetNo,FNo,jj,FetchElmFNo(SpRetNo,FNo,jj));
   For jj:=17 to 21 do StoreElm(CurRetNo,FNo,jj,FetchElmFNo(SpRetNo,FNo,jj));
   For jj:=23 to 27 do StoreElm(CurRetNo,FNo,jj,FetchElmFNo(SpRetNo,FNo,jj));

   k:=0;
   Repeat
    {adjust and reverse % }
    StoreElm(CurRetNo,FNo,35+k,FetchElmFNo(SpRetNo,FNo,41+k));
    StoreElm(CurRetNo,FNo,41+k,FetchElmFNo(SpRetNo,FNo,35+k));
    StoreElm(CurRetNo,FNo,233+k,FetchElmFNo(SpRetNo,FNo,233+k)); //20160724 Igor

    //put 100 on current spouse unless the slip has been used
    If FetchElmFno(CurRetNo,FNo,233+k)='' then //slip not used
    begin
      StoreElm(CurRetNo,FNo,35+k,FormatFloat('###.##',100-Vl(FetchElmFNo(CurRetNo,FNo,47+k))));
      StoreElm(CurRetNo,FNo,41+k,'');
    end;

    Inc(k,1);
   until k>4;
   Calc(CurRetNo,'T3MULT#'+s);
   Calc(SpRetNo,'T3MULT#'+s);  //20160724
  end //t3mult

 (* keep fpr T1-2023
  //20200523
  ELSE If ((Frec.FormName = 'T5008') and (Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)])) then
  begin
   //20100310
   S1:='';S2:='';S3:='';
   s := MidStr(Frec.FormInst,2,2); //inst
   CloneForm(SpRetNo,'T5008#'+s,CurRetNo,'T5008#'+s,True);
  {reverse % shares}
   If UpperCase(FetchElmFNo(SpRetNo,FNo,249))='Y' then
   Begin
    jj:=193;//jj:=173;
    Repeat
      S1:=FetchElmFNo(SpRetNo,FNo,jj);
      S2:=FetchElmFNo(SpRetNo,FNo,jj+1);
      //reverse positions
      StoreElm(CurRetNo,FNo,jj,S2);
      StoreElm(CurRetNo,FNo,jj+1,S1);
      //Ret[CurRetNo].Frm[FNo].Strings[i]:= FormatFloat('###.##',x);
      Inc(jj,2);
    until jj>245;
    Calc(CurRetNo,'T5008#'+s);
    Calc(SpRetNo,'T5008#'+s);
   End;
  end
 *)

  //20100310
  ELSE If ((Frec.FormName = 'AUTOS') and (Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)])) then
  begin
   //20100310
   S1:='';S2:='';S3:='';  //20130411
   s := MidStr(Frec.FormInst,2,2);
   If IsSharedStatement(SpRetNo,FetchElmFNo(SpRetNo,FNo,215))then s1:=FetchElmFNo(SpRetNo,FNo,216);
   If IsSharedStatement(SpRetNo,FetchElmFNo(SpRetNo,FNo,221))then s2:=FetchElmFNo(SpRetNo,FNo,222); //20120218 s2 instead of s1
   If IsSharedStatement(SpRetNo,FetchElmFNo(SpRetNo,FNo,227))then s3:=FetchElmFNo(SpRetNo,FNo,228); //20120218
   If S1+S2+S3>'' then CloneForm(SpRetNo,'AUTOS#'+s,CurRetNo,'AUTOS#'+s,True); //20170131 B
   //If S1+S2+S3>'' then CloneForm(SpRetNo,'AUTOS#'+s,CurRetNo,'AUTOS#'+s); //20170131 A
   //If S1+S1+S3>'' then CloneForm(SpRetNo,'AUTOS#'+s,CurRetNo,'AUTOS#'+s);
   If S1>'' then StoreElm(CurRetNo,FNo,216,S1);
   If S2>'' then StoreElm(CurRetNo,FNo,222,S2);
   If S3>'' then StoreElm(CurRetNo,FNo,228,S3);
   Calc(CurRetNo,'AUTOS#'+s);
  end

  ELSE If ((Frec.FormName = 'ASSETSB') and (Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)])) then
  begin
   //20100310
   s := MidStr(Frec.FormInst,2,2);
   S1:='';S2:='';S3:='';  //20130411
   If IsSharedStatement(SpRetNo,FetchElmFNo(SpRetNo,FNo,215))then s1:=FetchElmFNo(SpRetNo,FNo,216);
   If IsSharedStatement(SpRetNo,FetchElmFNo(SpRetNo,FNo,221))then s2:=FetchElmFNo(SpRetNo,FNo,222);
   If IsSharedStatement(SpRetNo,FetchElmFNo(SpRetNo,FNo,227))then s3:=FetchElmFNo(SpRetNo,FNo,228);
   If S1+S2+S3>'' then CloneForm(SpRetNo,'ASSETSB#'+s,CurRetNo,'ASSETSB#'+s,True);  //20170131 b
   //If S1+S2+S3>'' then CloneForm(SpRetNo,'ASSETSB#'+s,CurRetNo,'ASSETSB#'+s);  //20170131 a
   //If S1+S1+S3>'' then CloneForm(SpRetNo,'ASSETSB#'+s,CurRetNo,'ASSETSB#'+s);
   If S1>'' then StoreElm(CurRetNo,FNo,216,S1); // else StoreElm(CurRetNo,FNo,216,'');
   If S2>'' then StoreElm(CurRetNo,FNo,222,S2); // else StoreElm(CurRetNo,FNo,222,'');
   If S3>'' then StoreElm(CurRetNo,FNo,228,S3); // else StoreElm(CurRetNo,FNo,228,'');
   Calc(CurRetNo,'ASSETSB#'+s);
  end

 {ACB FRM}
  ELSE If ((Frec.FormName = 'ACBFRM') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then  //20160813
  begin
   s := MidStr(Frec.FormInst,2,2);
   If UpperCase(FetchElm(SpRetNo,'ACBFRM#'+s,6)) ='Y' then {shared}
    begin
     CloneForm(SpRetNo,'ACBFRM#'+s,CurRetNo,'ACBFRM#'+s,True); //20170131;
     {reverse % }
     Ret[CurRetNo].Frm[GetFormNo('ACBFRM#'+s)].Strings[6] := 'Y';
     x:=Vl(Ret[SpRetNo].Frm[GetFormNo('ACBFRM#'+s)].Strings[5]);  {%}
     Ret[CurRetNo].Frm[GetFormNo('ACBFRM#'+s)].Strings[5]:= FloatToStr(100-x);
     Calc(CurRetNo,'ACBFRM#'+s);
    end;
    //UpdateAllDataIndicators(CurRetNo);
  end

{S3Supl}
  ELSE If ((Frec.FormName = 'S3SUPL') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then   //20160813
  begin
   FNo:=Frec.FormNo;
   s := MidStr(Frec.FormInst,2,2);
   If UpperCase(FetchElmFNo(SpRetNo,FNo,141)) ='Y'
   then //sp sharing
   begin
    CloneForm(SpRetNo,'S3SUPL#'+s,CurRetNo,'S3SUPL#'+s,True); //20170131;
   {reverse % shares}
    i:=153;jj:=173;
    Repeat
      x:=(100-Vl(FetchElmFNo(SpRetNo,FNo,JJ))) - Vl(FetchElmFNo(SpRetNo,FNo,i));
      Ret[CurRetNo].Frm[FNo].Strings[i]:= FormatFloat('###.##',x);
      Inc(i,1);
      Inc(jj,1);
    until i>162;

   {reverse % }
    i:=163;jj:=183;
    Repeat
      x:=(100-Vl(FetchElmFNo(SpRetNo,FNo,JJ))) - Vl(FetchElmFNo(SpRetNo,FNo,i));
      Ret[CurRetNo].Frm[FNo].Strings[i]:= FormatFloat('###.##',x);
      Inc(i,1);
      Inc(jj,1);
    until i>166;

   {reverse % }
    i:=167;jj:=187;
    Repeat
      x:=(100-Vl(FetchElmFNo(SpRetNo,FNo,JJ))) - Vl(FetchElmFNo(SpRetNo,FNo,i));
      Ret[CurRetNo].Frm[FNo].Strings[i]:= FormatFloat('###.##',x);
      Inc(i,1);
      Inc(jj,1);
    until i>170;

    {reverse % }
    i:=171;jj:=190;
    Repeat
      x:=(100-Vl(FetchElmFNo(SpRetNo,FNo,JJ))) - Vl(FetchElmFNo(SpRetNo,FNo,i));
      Ret[CurRetNo].Frm[FNo].Strings[i]:= FormatFloat('###.##',x);
      Inc(i,1);
      Inc(jj,1);
    until i>172;

    Calc(CurRetNo,'S3SUPL#'+s);
   end;
  end

{S3QSupl}
  ELSE If ((Frec.FormName = 'S3QSUPL') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then   //20160813
  begin
   FNo:=Frec.FormNo;
   s := MidStr(Frec.FormInst,2,2);
   If UpperCase(FetchElmFNo(SpRetNo,FNo,181)) ='Y'
   then //sp sharing
   begin
    CloneForm(SpRetNo,'S3QSUPL#'+s,CurRetNo,'S3QSUPL#'+s,True); //20170131;
   {reverse % shares}
    i:=187;jj:=213;
    Repeat
      x:=(100-Vl(FetchElmFNo(SpRetNo,FNo,JJ))) - Vl(FetchElmFNo(SpRetNo,FNo,i));
      Ret[CurRetNo].Frm[FNo].Strings[i]:= FormatFloat('###.##',x);
      Inc(i,1);
      Inc(jj,1);
    until i>206;

   {reverse farm % }
    i:=207;jj:=233;
    Repeat
      x:=(100-Vl(FetchElmFNo(SpRetNo,FNo,JJ))) - Vl(FetchElmFNo(SpRetNo,FNo,i));
      Ret[CurRetNo].Frm[FNo].Strings[i]:= FormatFloat('###.##',x);
      Inc(i,1);
      Inc(jj,1);
    until i>212;

    Calc(CurRetNo,'S3QSUPL#'+s);
   end;
  end



 {T776}
  ELSE If ((Frec.FormName = 'T776') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then  //20160813
  begin
   s := MidStr(Frec.FormInst,2,2);
   If (Vl(FetchElm(SpRetNo,'T776#'+s,24)) >0) then
    begin
    {clone specific fields}
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,1,6);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,9,19);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,22,97);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,99,99);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,102,104);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,109,112);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,130,133);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,93,93);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,95,96);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,134,135);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,136,138);
    CopyFields(SpRetNo,CurRetNo,Frec.FormNo,142,142);  //20101206

    {reverse %}
    Ret[CurRetNo].Frm[GetFormNo('T776#'+s)].Strings[24]
      := FetchElm(SpRetNo,'T776#'+s,18);
    Ret[CurRetNo].Frm[GetFormNo('T776#'+s)].Strings[18]
      := FetchElm(SpRetNo,'T776#'+s,24);
    Calc(CurRetNo,'T776#'+s);
  (* 20110319
    //rental cca
    If UpperCase(FetchElm(SpRetNo,'T776#'+s,138)) ='Y' then //Share cca
    begin
     CloneForm(SpRetNo,'T776#'+s,CurRetNo,'T776#'+s);
     Calc(CurRetNo,'T776#'+s);
    end;
   *)
   end;
  end

 {t2125}
  ELSE If ((Frec.FormName = 'T2125') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then //20160813
  begin
   s := MidStr(Frec.FormInst,2,2);
   If Vl(FetchElm(SpRetNo,'T2125#'+s,238)) >0 then {sp %}
    begin
   // S1:=FetchElmFNo(CurRetNo,FNo,255); //% used in statement    //20100219
    SAlloc :=FormatAmount(FetchElm(CurRetNo,'T2125#'+s,255),False); //% used in sta
    CloneForm(SpRetNo,'T2125#'+s,CurRetNo,'T2125#'+s);
  //  SAlloc :=FormatAmount(FetchElm(CurRetNo,'T2125#'+s,255),False); //% used in sta
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),133,136);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),107,107);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),138,138);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),140,140);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),144,165);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),102,106);
   // CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),216,254);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),216,230);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),232,254);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),256,271);
    StoreElm(CurRetNo,GetFormNo('T2125#'+s),255,SAlloc);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2125#'+s),273,273);
   {reverse % }
    Ret[CurRetNo].Frm[GetFormNo('T2125#'+s)].Strings[18]
      := FetchElm(SpRetNo,'T2125#'+s,238);
    Ret[CurRetNo].Frm[GetFormNo('T2125#'+s)].Strings[238]
      := FetchElm(SpRetNo,'T2125#'+s,18);
    Calc(CurRetNo,'T2125#'+s);
    end;
  end

 {T2042}
  ELSE If ((Frec.FormName = 'T2042') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then       //20160813
  begin
   s := MidStr(Frec.FormInst,2,2);
   If Vl(FetchElm(SpRetNo,'T2042#'+s,642)) >0 then {sp %}  //642 instead of 742     //20100831
    begin
    CloneForm(SpRetNo,'T2042#'+s,CurRetNo,'T2042#'+s);
    SAlloc :=FormatAmount(FetchElm(CurRetNo,'T2042#'+s,630),False);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2042#'+s),601,604);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2042#'+s),614,629);
    StoreElm(CurRetNo,GetFormNo('T2042#'+s),630,SAlloc);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2042#'+s),631,675);
    {reverse % }
    Ret[CurRetNo].Frm[GetFormNo('T2042#'+s)].Strings[24]
      := FetchElm(SpRetNo,'T2042#'+s,642);
    Ret[CurRetNo].Frm[GetFormNo('T2042#'+s)].Strings[642]
      := FetchElm(SpRetNo,'T2042#'+s,24);

    Calc(CurRetNo,'T2042#'+s);
    end;
  end

 {NISAA - T1163}
  ELSE If ((Frec.FormName = 'T1163') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then //20160813
  begin
   s := MidStr(Frec.FormInst,2,2);
   If Vl(FetchElm(SpRetNo,'T1163#'+s,632)) >0 then {sp %}
    begin
    //20090315
    For i:=1 to 19 do StoreElm(CurRetNo,Frec.FormNo,i,FetchElmFNo(SpRetNo,Frec.FormNo,i));
    For i:=21 to 36 do StoreElm(CurRetNo,Frec.FormNo,i,FetchElmFNo(SpRetNo,Frec.FormNo,i));
    CloneForm(SpRetNo,'T1163#'+s,CurRetNo,'T1163#'+s);
    //20090315
    k:=GetFormNo('T1163#'+s);
    For i:=601 to 624 do StoreElm(CurRetNo,k,i,FetchElmFNo(SpRetNo,k,i));
    For i:=635 to 678 do StoreElm(CurRetNo,k,i,FetchElmFNo(SpRetNo,k,i));

    {reverse % }
    Ret[CurRetNo].Frm[GetFormNo('T1163#'+s)].Strings[210]
      := FetchElm(SpRetNo,'T1163#'+s,632);
    Ret[CurRetNo].Frm[GetFormNo('T1163#'+s)].Strings[632]
      := FetchElm(SpRetNo,'T1163#'+s,210);
    (*  //20110507
    //reverse PINS  //20090315
    S1:=FetchElmFNo(CurRetNo,GetFormNo('T1163#'+s),629);
    S2:=FetchElmFNo(CurRetNo,GetFormNo('T1163#'+s),634);
    Ret[CurRetNo].Frm[GetFormNo('T1163#'+s)].Strings[629]:=S2;
    Ret[CurRetNo].Frm[GetFormNo('T1163#'+s)].Strings[634]:=S1;
    *)
    Calc(CurRetNo,'T1163#'+s);

    {CCA}
    CloneForm(SpRetNo,'T1175#'+s,CurRetNo,'T1175#'+s,True); //20170131;
    end;
  end

  //T1273
  ELSE If ((Frec.FormName = 'T1273') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then //20160813
  begin
   s := MidStr(Frec.FormInst,2,2);
   If Vl(FetchElm(SpRetNo,'T1273#'+s,632)) >0 then {sp %}
    begin
    //20090315
    For i:=1 to 19 do StoreElm(CurRetNo,Frec.FormNo,i,FetchElmFNo(SpRetNo,Frec.FormNo,i));
    For i:=21 to 62 do StoreElm(CurRetNo,Frec.FormNo,i,FetchElmFNo(SpRetNo,Frec.FormNo,i));

    CloneForm(SpRetNo,'T1273#'+s,CurRetNo,'T1273#'+s);
    //20090315
    k:=GetFormNo('T1273#'+s);
    CloneForm(SpRetNo,'T1273#'+s,CurRetNo,'T1273#'+s);
    For i:=601 to 624 do StoreElm(CurRetNo,k,i,FetchElmFNo(SpRetNo,k,i));
    For i:=635 to 654 do StoreElm(CurRetNo,k,i,FetchElmFNo(SpRetNo,k,i));
    {reverse % }
    Ret[CurRetNo].Frm[GetFormNo('T1273#'+s)].Strings[210]
      := FetchElm(SpRetNo,'T1273#'+s,632);
    Ret[CurRetNo].Frm[GetFormNo('T1273#'+s)].Strings[632]
      := FetchElm(SpRetNo,'T1273#'+s,210);
   (*  20110507
    //reverse PINS  //20090315
    S1:=FetchElmFNo(CurRetNo,GetFormNo('T1273#'+s),629);
    S2:=FetchElmFNo(CurRetNo,GetFormNo('T1273#'+s),634);
    Ret[CurRetNo].Frm[GetFormNo('T1273#'+s)].Strings[629]:=S2;
    Ret[CurRetNo].Frm[GetFormNo('T1273#'+s)].Strings[634]:=S1;
   *)
    Calc(CurRetNo,'T1273#'+s);
    {CCA}
    CloneForm(SpRetNo,'T1175H#'+s,CurRetNo,'T1175H#'+s);
    end;
  end

 {T2121}
  ELSE If ((Frec.FormName = 'T2121') and (Ret[SpRetNo].FormHasData[Frec.FormName+Frec.FormInst])) then   //20160813
  begin
   s := MidStr(Frec.FormInst,2,2);
   If Vl(FetchElm(SpRetNo,'T2121#'+s,505)) >0 then {sp %}
    begin
    CloneForm(SpRetNo,'T2121#'+s,CurRetNo,'T2121#'+s);
    SAlloc :=FormatAmount(FetchElm(CurRetNo,'T2121#'+s,126),False);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2121#'+s),110,125);
    StoreElm(CurRetNo,GetFormNo('T2121#'+s),126,SAlloc);
    CopyFields(SpRetNo,CurRetNo,GetFormNo('T2121#'+s),127,277);

    {reverse % }
    Ret[CurRetNo].Frm[GetFormNo('T2121#'+s)].Strings[18]
       := FetchElm(SpRetNo,'T2121#'+s,505);
    Ret[CurRetNo].Frm[GetFormNo('T2121#'+s)].Strings[505]
      := FetchElm(SpRetNo,'T2121#'+s,18);
    Calc(CurRetNo,'T2121#'+s);
    end;
  end;

 end;  //j
end;

Procedure CreateS2(SpRetNo:Integer;CurRetNo:integer);
{calc S2 of spouseB}
Var i, j,FNo,result : Integer;
x :real;
CplSin : string[9];
S : string;
begin
 FNo := GetFormNo('S2');
 InitFormData(CurRetNo,FNo);
 //For i:=1 to 32 do StoreElm(CurRetNo,FNo,i,'');
 //copy rdsp
 StoreElm(CurRetno,FNo,33,FetchElm(SpRetNo,'T1',241));
 StoreElm(CurRetno,FNo,34,FetchElm(SpRetNo,'OTHDED',60));

 Calc(CurRetNo,'S2');
 Ret[CurRetNo].FormHasData[Frec.FormName]:=True;  //does not have forminst //20160813
end;

//20150216
Procedure ReverseGstCredit(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
begin
//20150221
 FNo:=GetFormNo('GSTC');
 If  UpperCase(Ret[SpRetNo].Frm[FNo].Strings[31]) <> 'Y' then
   Ret[CurRetNo].Frm[FNo].Strings[31] :='Y'
 else
   Ret[CurRetNo].Frm[FNo].Strings[31] := 'N';
end;

(* 2013
Procedure ReverseGstCredit(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
begin
 FNo:=GetFormNo('INFO');
 {both blank}
 If (Ret[CurRetNo].Frm[FNo].Strings[29]+Ret[CurRetNo].Frm[FNo].Strings[30]='')
 and
 (Ret[SpRetNo].Frm[FNo].Strings[29]+Ret[SpRetNo].Frm[FNo].Strings[30]='')
 then exit;

 If  UpperCase(Ret[SpRetNo].Frm[FNo].Strings[29]) = 'X' then
  begin
   Ret[CurRetNo].Frm[FNo].Strings[29] :='';
   Ret[CurRetNo].Frm[FNo].Strings[30] :='X';
  end
  else
  begin
   Ret[CurRetNo].Frm[FNo].Strings[29] := 'X';
   Ret[CurRetNo].Frm[FNo].Strings[30] :='';
  end;
  //both No
  Ret[CurRetNo].Frm[FNo].Strings[128]:=Ret[SpRetNo].Frm[FNo].Strings[128];
end;
*)
Procedure ReverseJointInvoice(SpRetNo:Integer;CurRetNo:Integer);
Var FNo:Integer;
begin
 FNo:=GetFormNo('INFO');
 Ret[CurRetNo].Frm[FNo].Strings[121] :=Ret[SpRetNo].Frm[FNo].Strings[121];
 {no joint}
 If (Ret[CurRetNo].Frm[FNo].Strings[121]='') then exit;

 If  UpperCase(Ret[SpRetNo].Frm[FNo].Strings[129]) = 'X' then
  begin
   Ret[CurRetNo].Frm[FNo].Strings[129] :='';
   Ret[CurRetNo].Frm[FNo].Strings[130] :='X';
  end
  else
  begin
   Ret[CurRetNo].Frm[FNo].Strings[129] := 'X';
   Ret[CurRetNo].Frm[FNo].Strings[130] :='';
  end;
end;


Procedure ReverseCTB(SpRetNo:Integer;CurRetNo:Integer);
Var FNo :Integer;
begin
 FNo := GetFormNo('CTB');
 If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
 If UpperCase(Ret[SpRetNo].Frm[FNo].Strings[71]) = 'Y' then
   Ret[CurRetNo].Frm[FNo].Strings[71] :='N'
  else
   Ret[CurRetNo].Frm[FNo].Strings[71] := 'Y';
end;



Procedure ReversePrvCredits(SpRetNo:Integer;CurRetNo:Integer);
Var FNo :Integer;
begin
  {Ont prvcr}
  If Ret[CurRetNo].Province = 'ON' then
  begin

  // ReverseCATC(SpRetNo,CurRetNo);  //20171119

   FNo:=GetFormNo('ONBEN');
   If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
   If Ret[SpRetNo].FormHasData[GetFormName(SpRetNo,FNo)] then
   begin
    If UpperCase(FetchElmFNo(SpRetNo,FNo,31)) <> 'X' then  //20120213 //Y to X//20110210
       CloneForm(SpRetNo,'ONBEN',CurRetNo,'ONBEN')
    Else
       Ret[CurRetNo].Frm[FNo].Strings[31] :='X';
       Ret[CurRetNo].Frm[FNo].Strings[43] :='N';   //20120229  //N
   end;

   If UpperCase(FetchElmFNo(SpRetNo,FNo,31))<>'X' then  //involuntary separation
   Begin
    If UpperCase(FetchElmFNo(SpRetNo,FNo,42)) ='Y' then
    begin
      Ret[CurRetNo].Frm[FNo].Strings[42] :='N';
      Ret[CurRetNo].Frm[FNo].Strings[43] :='Y';
    end
    else
    begin
      Ret[CurRetNo].Frm[FNo].Strings[42] :='Y';
      Ret[CurRetNo].Frm[FNo].Strings[43] :='N';
    end;
   end;

   If UpperCase(FetchElmFNo(SpRetNo,FNo,31)) ='X' then
     Ret[CurRetNo].Frm[FNo].Strings[31] :='X'
   else
     Ret[CurRetNo].Frm[FNo].Strings[31] :='';

   //zero out Efiled fields
   If UpperCase(Ret[CurRetNo].Frm[FNo].Strings[42]) <>'Y' then //20110203
   Begin
    Ret[CurRetNo].Frm[FNo].Strings[4] :='';
    Ret[CurRetNo].Frm[FNo].Strings[6] :='';
    Ret[CurRetNo].Frm[FNo].Strings[9] :='';
    Ret[CurRetNo].Frm[FNo].Strings[10] :='';
    Ret[CurRetNo].Frm[FNo].Strings[11] :='';
    Ret[CurRetNo].Frm[FNo].Strings[7] :='0';
    Ret[CurRetNo].Frm[FNo].Strings[8] :='0';
    Ret[CurRetNo].Frm[FNo].Strings[12] :='0';
    Ret[CurRetNo].Frm[FNo].Strings[13] :='0';
   End;
  end;

  {BC prvcr}
  If Ret[CurRetNo].Province = 'BC' then
  begin
   FNo:=GetFormNo('BC479');
   If Ret[CurRetNo].Frm[Fno].Count =0 then
     InitFormData(CurRetNo,FNo);

   If UpperCase(FetchElmFNo(SpRetNo,FNo,38)) ='Y' then  //sales tax credit
     Ret[CurRetNo].Frm[FNo].Strings[38] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[38] :='Y';

   (* 20130924
   If UpperCase(FetchElmFNo(SpRetNo,FNo,19)) ='Y' then
     Ret[CurRetNo].Frm[FNo].Strings[19] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[19] :='Y';

   If UpperCase(FetchElmFNo(SpRetNo,FNo,20)) ='Y' then
     Ret[CurRetNo].Frm[FNo].Strings[20] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[20] :='Y';

   If UpperCase(FetchElmFNo(SpRetNo,FNo,21)) ='Y' then
     Ret[CurRetNo].Frm[FNo].Strings[21] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[21] :='Y';
   *)
  end;

  {NS tax}
  If Ret[CurRetNo].Province = 'NS' then
  begin
   FNo:=GetFormNo('NS428');
   If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);

   If UpperCase(FetchElmFNo(SpRetNo,FNo,102)) ='X' then     //20090225
   begin
     Ret[CurRetNo].Frm[FNo].Strings[102] :='';
     Ret[CurRetNo].Frm[FNo].Strings[103] :='X';
   end
   else
   begin
     Ret[CurRetNo].Frm[FNo].Strings[102] :='X';
     Ret[CurRetNo].Frm[FNo].Strings[103] :='';
   end;
  end;

  {Man prvcr}
  If Ret[CurRetNo].Province = 'MB' then
  begin
   FNo:=GetFormNo('MB479');
   If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
   If UpperCase(FetchElmFNo(SpRetNo,FNo,50)) ='Y' then
     Ret[CurRetNo].Frm[FNo].Strings[50] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[50] :='Y';

   If UpperCase(FetchElmFNo(SpRetNo,FNo,51)) ='Y' then
     Ret[CurRetNo].Frm[FNo].Strings[51] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[51] :='Y';
  end;

  //pe
  If Ret[CurRetNo].Province = 'PE' then
  begin
   FNo:=GetFormNo('PE428');
   If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
   If UpperCase(FetchElmFNo(SpRetNo,FNo,137)) ='X' then  //20110321
   begin
     Ret[CurRetNo].Frm[FNo].Strings[137] :=''; //20110217
     Ret[CurRetNo].Frm[FNo].Strings[138] :='X';
   end
   else                                          //20110217
   begin
     Ret[CurRetNo].Frm[FNo].Strings[137] :='X';
     Ret[CurRetNo].Frm[FNo].Strings[138] :='';
   end;
  end;

  {NT prvcr}
  If Ret[CurRetNo].Province = 'NT' then
  begin
   FNo:=GetFormNo('NT479');
   If Ret[CurRetNo].Frm[Fno].Count =0 then
     InitFormData(CurRetNo,FNo);
   If UpperCase(FetchElmFNo(SpRetNo,FNo,24)) ='Y' then
     Ret[CurRetNo].Frm[FNo].Strings[24] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[24] :='Y';
  end;


  {NB tax}
  If Ret[CurRetNo].Province = 'NB' then
  begin
   FNo:=GetFormNo('NB428');
   If Ret[CurRetNo].Frm[Fno].Count =0 then InitFormData(CurRetNo,FNo);
   If UpperCase(FetchElmFNo(SpRetNo,FNo,21)) ='X' then
   begin
     Ret[CurRetNo].Frm[FNo].Strings[21] :='';
     Ret[CurRetNo].Frm[FNo].Strings[22] :='X';
   end
   else
   begin
     Ret[CurRetNo].Frm[FNo].Strings[21] :='X';
     Ret[CurRetNo].Frm[FNo].Strings[22] :='';
   end;

   //20100301
   If UpperCase(FetchElmFNo(SpRetNo,FNo,137)) ='X' then
   begin
     Ret[CurRetNo].Frm[FNo].Strings[137] :='';
     Ret[CurRetNo].Frm[FNo].Strings[138] :='X';
   end
   else
   begin
     Ret[CurRetNo].Frm[FNo].Strings[137] :='X';
     Ret[CurRetNo].Frm[FNo].Strings[138] :='';
   end;
  //20100301
   Ret[CurRetNo].Frm[FNo].Strings[120] :=FetchElmFNo(SpRetNo,FNo,82);
  end;

 {NL low income reduction}
  If Ret[CurRetNo].Province = 'NL' then
  begin
   FNo:=GetFormNo('NL428');
   If Ret[CurRetNo].Frm[Fno].Count =0 then
     InitFormData(CurRetNo,FNo);
   If UpperCase(FetchElmFNo(SpRetNo,FNo,15)) ='Y' then
     Ret[CurRetNo].Frm[FNo].Strings[15] :='N'
   else
     Ret[CurRetNo].Frm[FNo].Strings[24] :='Y';
  //end;  //20100313
  //20100307
   If UpperCase(FetchElmFNo(SpRetNo,FNo,115)) ='X' then
   begin
     Ret[CurRetNo].Frm[FNo].Strings[115] :='';
     Ret[CurRetNo].Frm[FNo].Strings[83] :='X';
   end
   else
   begin
     Ret[CurRetNo].Frm[FNo].Strings[115] :='X';
     Ret[CurRetNo].Frm[FNo].Strings[83] :='';
   end;
  //20100307
   Ret[CurRetNo].Frm[FNo].Strings[134] :=FetchElmFNo(SpRetNo,FNo,81);
  end;  //2010013
end;

//20190407
Procedure ReverseS6(SpRetNo:Integer;CurRetNo:Integer); //20190405
Begin
 EXIT; //20190407

 if Ret[CurRetNo].Lnn[45300]>0 then
 Begin
  StoreElm(CurRetNo,GetFormNo('S6'+Ret[CurRetNo].Province),66,'X'); //No claim
  StoreElm(SpRetNo,GetFormNo('S6'+Ret[SpRetNo].Province),66,''); //No claim
  Calc(CurRetNo,'S6');
  Calc(SpRetNo,'S6');
 End;

End;


//20190407
Procedure ReverseS14(SpRetNo:Integer;CurRetNo:Integer);
Begin
 EXIT; //20190407
 {
   if Ret[CurRetNo].Lnn[45110]>0 then
   Begin
    StoreElm(CurRetNo,GetFormNo('S14'+Ret[CurRetNo].Province),20,'Y'); //No claim
    StoreElm(SpRetNo,GetFormNo('S14'+Ret[SpRetNo].Province),20,'N'); //No claim
   End;
   Calc(CurRetNo,'S14'+Ret[CurRetNo].Province);
   Calc(SpRetNo,'S14'+Ret[SpRetNo].Province);
 }
End;

(*
//20190407
Procedure ReverseS14(SpRetNo:Integer;CurRetNo:Integer);
Begin
 // If EligibleSpouseForS14(SpRetNo) then  //reverse only if applcable
 //Begin
   if Ret[CurRetNo].Lnn[45110]>0 then
   Begin
    StoreElm(CurRetNo,GetFormNo('S14'+Ret[CurRetNo].Province),20,'N'); //No claim
    StoreElm(SpRetNo,GetFormNo('S14'+Ret[SpRetNo].Province),20,'Y'); //No claim
   End;
   Calc(CurRetNo,'S14'+Ret[CurRetNo].Province);
   Calc(SpRetNo,'S14'+Ret[SpRetNo].Province);
 // End;
End;
*)
end.
