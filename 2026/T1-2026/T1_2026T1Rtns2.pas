unit T1_2026T1RTNS2;

interface
uses SysUtils,{$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON},WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,ShellApi,
  T1_2026Declare;

Function CalcGSTC(RetNo: integer; FName: String;FNo: integer):Real;
Procedure CopyDependToPage1(PrevRetNo:Integer;RetNo:integer;Ndx:Integer);
Function GetIndexInDependants(PrevRetNo:Integer;CplSin:String):Integer;
Function GetEducXferFromKids(RetNo:Integer):real;
Function CareGiverEligible(RetNo:Integer;BirthDate,Relationship,Infirmity:string;NetInc:Real):boolean; //20130601
Function GetQuebecAbat(RetNo:Integer;BfrAmt:Boolean):Real;
Function GetTxblIncBfrLosses(RetNo:Integer):real;
Function GetNetCapLossApplied(RetNo:Integer):Real;
Function GetNonCapLossApplied(RetNo:Integer):Real;
Function GetFarmLossApplied(RetNo:Integer):Real;
Function GetRestrFarmLossApplied(RetNo:Integer):Real;
Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
Procedure CopyOldLossesToNewFormat(RetNo:Integer);
Procedure CopyOldLossElm(RetNo,OldLossFNo,OldLossElm,Cfr2FNo,Cfr2Elm:Integer);
Function GetTotPrevYrsLossApplied(RetNo:Integer):Real;
Procedure T5013Process(RetNo:Integer;
  Var T5013LimitedInc:real;
  Var T5013OthInc: real;Var T5013ITC: real;
  Var T5013ElgblQSB1: real;  Var T5013ElgblQFP1: real;Var T5013ElgblOTH1: real;
  Var T5013NonElgblGains1: real;
  Var T5013ActDiv: real;Var T5013ActDivEligible: real;
  Var T5013CarrCharg: real;
  Var T5013CDE: real;Var T5013CEE: real;Var T5013COGPE: real;
  Var T5013FDE: real;Var T5013RecapDepl: real;
  Var T5013FedPol: real; Var T5013ProvPol: real;Var T5013Don: real;
  Var T5013Gifts: real;Var T5013Abil: real;
  Var T5013FNonBusInc1: real;Var T5013FNonBusInc2: real;
  Var T5013FNonBusInc3: real;
  Var T5013FNonBusTax1: real;Var T5013FNonBusTax2: real;
  Var T5013FNonBusTax3: real;
  Var T5013FBusInc1: real;Var T5013FBusInc2: real;
  Var T5013FBusInc3: real;
  Var T5013FBusTax1: real;Var T5013FBusTax2: real;
  Var T5013FBusTax3:real;
  Var T5013Interest:real;
  Var T5013Tax:real;
  Var T5013ResAllow:real;
  Var T5013FInterest:real;
  Var T5013ElgblQSB2: real;Var T5013ElgblQFP2: real;Var T5013ElgblOTH2: real;
  Var T5013NonElgblGains2: real;
  Var T5013ElgblQSB3: real;Var T5013ElgblQFP3: real;Var T5013ElgblOTH3: real;
  Var T5013NonElgblGains3: real);

implementation

uses vtCommon,vtMulti,vtDialogs,T1_2026,T1_2026T1Rtns,T1_2026Trimstr,
  T1_2026ChildWinNEW,T1_2026Main,T1_2026Common,T1_2026Common2,vtTrimStr,
  vtShared;


Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
var
  i,LineCnt,MxLinesPerPage,PageCnt:integer;PrnFile: TextFile;
  {TempList:TstringList;}
  XPos :LongInt;PageX, PageY : LongInt;
  ScMult : Integer; s:string;
  F1 :TextFile;
  ScaleX, ScaleY : Word;
  FirstTimeSw:boolean;
begin
  UndefMsg('PrintAListing');
  Result := False; //???
 If MainFormT1.PrintDialogItem.Execute = false then Exit; //20120122

  AssignFile(F1, FileNm);
  Reset(F1);

  FirstTimeSw := true;
  LineCnt:=0;PageCnt :=0;MxLinesPerPage :=60;

  {now print}
  Printer.BeginDoc;
  XPos := 30;
  ScMult :=10;
  PageX:= Printer.PageWidth;
  PageY :=Printer.PageHeight;
  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
  ScaleY := (PageY * ScMult) div 1000; {formheight}

  Repeat
   If (FirstTimeSw) or (LineCnt >=MxLinesPerPage) then
   begin  {print headers}
     LineCnt:=1;
     Inc(PageCnt);
     If not FirstTimeSw then Printer.NewPage;

     Printer.Canvas.Font.Name := 'Arial';
     Printer.Canvas.Font.Size := 10;
     Printer.Canvas.Font.Style := [fsBold];
     Printer.Canvas.Font.Color := clBlack;
     Printer.Canvas.TextOut((XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
        Hdr1+' Page: '+IntToStr(PageCnt));

     Inc(LineCnt); {leave empty line}
     Printer.Canvas.Font.Name := 'Courier New';
     Printer.Canvas.Font.Size := 8;
     Printer.Canvas.Font.Style := [fsBold];
     Printer.Canvas.Font.Color := clBlack;
     Inc(LineCnt);
     Printer.Canvas.TextOut((XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr2);

     Inc(LineCnt);
     Printer.Canvas.TextOut((XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr3);
     Inc(LineCnt,1);
   end; {headers}
   FirstTimeSw := False;
   Printer.Canvas.Font.Style := [];
   Readln(F1,s);
   Printer.Canvas.Font.Style := [fsBold];
   Printer.Canvas.Font.Color := clBlack;
   Printer.Canvas.TextOut((XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,s);
   Inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  Result := True;
end;

Procedure CopyOldLossesToNewFormat(RetNo:Integer);
Var i:integer;Cfr2FNo,OldLossFNo:Integer;
  OldNdx,NewNonCapNdx,NewFarmNdx,NewRestrNdx:integer;
  x,Pre85,To87,In8889,after89:Real;
  Yr:string; //[4];
begin
 Cfr2FNo := GetFormNo('CFR');
 OldLossFNo := GetFormNo('OLDLOSS');
 {from old  to new}
 {first 3 years in old format}
 {farm losses}
 CopyOldLossElm(RetNo,OldLossFNo,2,Cfr2FNo,146);
 CopyOldLossElm(RetNo,OldLossFNo,5,Cfr2FNo,151);
 CopyOldLossElm(RetNo,OldLossFNo,8,Cfr2FNo,156);
 {restr farm losses}
 CopyOldLossElm(RetNo,OldLossFNo,3,Cfr2FNo,205);
 CopyOldLossElm(RetNo,OldLossFNo,6,Cfr2FNo,210);
 CopyOldLossElm(RetNo,OldLossFNo,9,Cfr2FNo,215);

 OldNdx:=11;NewNonCapNdx := 2;NewFarmNdx:=161;NewRestrNdx:= 220;
 repeat
  CopyOldLossElm(RetNo,OldLossFNo,OldNdx,Cfr2FNo,NewFarmNdx);
  CopyOldLossElm(RetNo,OldLossFNo,OldNdx+1,Cfr2FNo,NewRestrNdx);
  CopyOldLossElm(RetNo,OldLossFNo,OldNdx+2,Cfr2FNo,NewNonCapNdx);
  Inc(OldNdx,4);
  Inc(NewFarmNdx,5);
  Inc(NewRestrNdx,5);
  Inc(NewNonCapNdx,5);
 until OldNdx >35;
 {net cap losses}
 i:=56;
 Pre85:=0;To87:=0;In8889:=0;After89:=0;
 Repeat
  Yr:= AllTrim(FetchElmFNo(RetNo,OldLossFNo,i));
  x := Vl(FetchElmFNo(RetNo,OldLossFNo,i+1));
  {If      Yr <'1985'      then Pre85:=Pre85+x}
  If Yr <'1988' then To87:=To87+x {wrong but works}
  else If Yr <'1990' then In8889:=In8889+x {wrong but works?}
  else After89:=After89+x;
  Inc(i,4);
 until i > 92;
 StoreElm(RetNo,Cfr2FNo,163,FloatToStr(Pre85));
 StoreElm(RetNo,Cfr2FNo,168,FloatToStr(To87));
 StoreElm(RetNo,Cfr2FNo,173,FloatToStr(In8889));
 StoreElm(RetNo,Cfr2FNo,178,FloatToStr(After89));
end;

Procedure CopyOldLossElm(RetNo,OldLossFNo,OldLossElm,Cfr2FNo,Cfr2Elm:Integer);
begin
 StoreElm(RetNo,Cfr2FNo,Cfr2Elm,FetchElmFNo(RetNo,OldLossFNo,OldLossElm));
end;


Function GetTotPrevYrsLossApplied(RetNo:Integer):Real;
Var i,FNo :Integer;
begin
 Result := GetNonCapLossApplied(RetNo)+
           GetFarmLossApplied(RetNo)+
           GetRestrFarmLossApplied(RetNo);
end;

Function GetNonCapLossApplied(RetNo:Integer):Real;
Var i,FNo :Integer;
begin
 FNo := GetFormNo('CFR');
 Result :=0;
 {Non cap}
 i:=103;
 Repeat
  result := result+Vl(FetchElmFNo(RetNo,FNo,i));
  Inc(i,5);
 until i>133;
end;

Function GetFarmLossApplied(RetNo:Integer):Real;
Var i,FNo :Integer;
begin
 FNo := GetFormNo('CFR');
 Result :=0;
 {Farm}
 i:=147;
 Repeat
  result := result+Vl(FetchElmFNo(RetNo,FNo,i));
  Inc(i,5);
 until i>192;
end;

Function GetRestrFarmLossApplied(RetNo:Integer):Real;
Var i,FNo :Integer;
begin
 FNo := GetFormNo('CFR');
 Result :=0;
 {Restr cap}
 i:=206;
 Repeat
  result := result+Vl(FetchElmFNo(RetNo,FNo,i));
  Inc(i,5);
 until i>251;
end;

Procedure T5013Process(RetNo:Integer;
   Var T5013LimitedInc:real;
  Var T5013OthInc: real;Var T5013ITC: real;
  Var T5013ElgblQSB1: real;  Var T5013ElgblQFP1: real;Var T5013ElgblOTH1: real;
  Var T5013NonElgblGains1: real;
  Var T5013ActDiv: real;Var T5013ActDivEligible: real;
  Var T5013CarrCharg: real;
  Var T5013CDE: real;Var T5013CEE: real;Var T5013COGPE: real;
  Var T5013FDE: real;Var T5013RecapDepl: real;
  Var T5013FedPol: real; Var T5013ProvPol: real;Var T5013Don: real;
  Var T5013Gifts: real;Var T5013Abil: real;
  Var T5013FNonBusInc1: real;Var T5013FNonBusInc2: real;
  Var T5013FNonBusInc3: real;
  Var T5013FNonBusTax1: real;Var T5013FNonBusTax2: real;
  Var T5013FNonBusTax3: real;
  Var T5013FBusInc1: real;Var T5013FBusInc2: real;
  Var T5013FBusInc3: real;
  Var T5013FBusTax1: real;Var T5013FBusTax2: real;
  Var T5013FBusTax3:real;
  Var T5013Interest:real;
  Var T5013Tax:real;
  Var T5013ResAllow:real;
  Var T5013FInterest:real;
  Var T5013ElgblQSB2: real;Var T5013ElgblQFP2: real;Var T5013ElgblOTH2: real;
  Var T5013NonElgblGains2: real;
  Var T5013ElgblQSB3: real;Var T5013ElgblQFP3: real;Var T5013ElgblOTH3: real;
  Var T5013NonElgblGains3: real);

Var i,FNo,T5013Period : integer;
begin
  T5013LimitedInc:=0;T5013OthInc:=0;T5013ITC:=0;
  T5013ElgblQSB1:=0;T5013ElgblQFP1:=0;T5013ElgblOTH1:=0;T5013NonElgblGains1:=0;
  T5013ElgblQSB2:=0;T5013ElgblQFP2:=0;T5013ElgblOTH2:=0;T5013NonElgblGains2:=0;
  T5013ElgblQSB3:=0;T5013ElgblQFP3:=0;T5013ElgblOTH3:=0;T5013NonElgblGains3:=0;
  T5013ActDiv:=0;T5013ActDivEligible:=0;
  T5013CarrCharg:=0;
  T5013CDE:=0;T5013CEE:=0;T5013COGPE:=0;T5013FDE:=0;T5013RecapDepl:=0;
  T5013FedPol:=0; T5013ProvPol:=0;T5013Don:=0;T5013Gifts:=0;T5013Abil:=0;
  T5013FNonBusInc1:=0;T5013FNonBusInc2:=0;T5013FNonBusInc3:=0;
  T5013FNonBusTax1:=0;T5013FNonBusTax2:=0;T5013FNonBusTax3:=0;
  T5013FBusInc1:=0;T5013FBusInc2:=0;T5013FBusInc3:=0;
  T5013FBusTax1:=0;T5013FBusTax2:=0;T5013FBusTax3:=0;
  T5013Interest :=0;T5013FInterest:=0; T5013Tax :=0;
  T5013ResAllow:=0;
 for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T5013' then
    begin
      FNo :=Frec.FormNo;
      T5013Period := 3;
        {MyStrToInt(FetchElmFNo(RetNo,FNo,22));}
      If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then
      begin
        T5013ITC:=T5013ITC+Vl(Ret[RetNo].Frm[FNo].Strings[26]);
          T5013ElgblQSB3:=T5013ElgblQSB3+Vl(Ret[RetNo].Frm[FNo].Strings[13]);
          T5013ElgblQFP3:=T5013ElgblQFP3+Vl(Ret[RetNo].Frm[FNo].Strings[12]);
          T5013NonElgblGains3:=T5013NonElgblGains3+Vl(Ret[RetNo].Frm[FNo].Strings[42]);
            // +Vl(Ret[RetNo].Frm[FNo].Strings[14]);
        T5013ActDiv:=T5013ActDiv+Vl(Ret[RetNo].Frm[FNo].Strings[5]);
        T5013ActDivEligible:=T5013ActDivEligible+Vl(Ret[RetNo].Frm[FNo].Strings[61]);
        T5013CarrCharg:=T5013CarrCharg+Vl(Ret[RetNo].Frm[FNo].Strings[19]);
        T5013CDE:=T5013CDE+Vl(Ret[RetNo].Frm[FNo].Strings[28]);
                 // +Vl(Ret[RetNo].Frm[FNo].Strings[51]);
        T5013CEE:=T5013CEE+Vl(Ret[RetNo].Frm[FNo].Strings[27]);
                  //+Vl(Ret[RetNo].Frm[FNo].Strings[47]);
        T5013COGPE:=T5013COGPE+Vl(Ret[RetNo].Frm[FNo].Strings[29]);
        T5013FDE:=T5013FDE+Vl(Ret[RetNo].Frm[FNo].Strings[30]);
        T5013RecapDepl:=T5013RecapDepl+Vl(Ret[RetNo].Frm[FNo].Strings[31]);
        T5013FedPol:=T5013FedPol+Vl(Ret[RetNo].Frm[FNo].Strings[24]);
        T5013ProvPol:=T5013ProvPol+Vl(Ret[RetNo].Frm[FNo].Strings[25]);
        T5013Don:=T5013Don+Vl(Ret[RetNo].Frm[FNo].Strings[33]);
        T5013Gifts:=T5013Gifts+Vl(Ret[RetNo].Frm[FNo].Strings[34]);
        T5013Abil:=T5013Abil+Vl(Ret[RetNo].Frm[FNo].Strings[16]);
        T5013ResAllow:= T5013ResAllow+Vl(Ret[RetNo].Frm[FNo].Strings[32]);
        T5013RecapDepl:= T5013RecapDepl+Vl(Ret[RetNo].Frm[FNo].Strings[31]);

        //T5013FBusInc1:=T5013FBusInc1; //+Vl(Ret[RetNo].Frm[FNo].Strings[8])+Vl(Ret[RetNo].Frm[FNo].Strings[9]);
        {If Foreign bus income then foreign tax goes to FBusTax}
        //If (Vl(ret[RetNo].Frm[FNo].Strings[8])+Vl(ret[RetNo].Frm[FNo].Strings[9])) >0 then //20140322
        T5013FBusTax1:=T5013FBusTax1+Vl(Ret[RetNo].Frm[FNo].Strings[67]);//20140420 Strings[23]);
        //else
        T5013FNonBusTax1:=T5013FNonBusTax1+Vl(Ret[RetNo].Frm[FNo].Strings[23]); //20140420 Strings[67]); //20140322 //T5013FNonBusTax1+Vl(ret[RetNo].Frm[FNo].Strings[23]);

        T5013FNonBusInc1:=T5013FNonBusInc1+Vl(Ret[RetNo].Frm[FNo].Strings[10]);

        T5013Interest:=T5013Interest+Vl(Ret[RetNo].Frm[FNo].Strings[7])
                                    +Vl(Ret[RetNo].Frm[FNo].Strings[65]);
        T5013FInterest:=T5013FInterest+Vl(Ret[RetNo].Frm[FNo].Strings[10]);
        T5013Tax:=T5013Tax+Vl(Ret[RetNo].Frm[FNo].Strings[17]);
        //If LeftStr(Ret[RetNo].Frm[FNo].Strings[1],3) = '122' then
        //begin
          // If (MidStr(Ret[RetNo].Frm[FNo].Strings[1],4,1) <> '1')
          // and (MidStr(Ret[RetNo].Frm[FNo].Strings[1],4,1) <> '6') then
            T5013LimitedInc:=T5013LimitedInc+Vl(Ret[RetNo].Frm[FNo].Strings[2]);
             // +Vl(Ret[RetNo].Frm[FNo].Strings[3]);

        //end;
       // If LeftStr(Ret[RetNo].Frm[FNo].Strings[1],3) = '130' then
         Ret[RetNo].T5013OthInc:=T5013OthInc+Vl(Ret[RetNo].Frm[FNo].Strings[63]);
             // +Vl(Ret[RetNo].Frm[FNo].Strings[2])
             // +Vl(Ret[RetNo].Frm[FNo].Strings[3]);

      end;
    end;
  end;
end;

Function GetNetCapLossApplied(RetNo:Integer):Real;
Var FNo :Integer; InclRate,InclRate2000:Real;
begin
 FNo := GetFormNo('CFR',RetNo);
 InclRate:= 50/100;
 InclRate2000:=Vl(FetchElmFNo(RetNo,FNo,303));
 {Loss * This years inclusion rate / from yers incl rate}
 Result := Vl(FetchElmFNo(RetNo,FNo,265)) * (InclRate) / (1/2)
          +Vl(FetchElmFNo(RetNo,FNo,270)) * (InclRate) / (1/2)
          +Vl(FetchElmFNo(RetNo,FNo,275)) * (InclRate) / (2/3)
          +Vl(FetchElmFNo(RetNo,FNo,280)) * (InclRate) / (3/4)
          +Vl(FetchElmFNo(RetNo,FNo,290)) * (InclRate) / (1/2)
          +Vl(FetchElmFNo(RetNo,FNo,300)) * (InclRate) / (1/2)
          +Vl(FetchElmFNo(RetNo,FNo,313)) * (InclRate) / (1/2)
          +Vl(FetchElmFNo(RetNo,FNo,308)) * (InclRate) / (1/2);
          If InclRate2000>0 then
           result := result
           +Vl(FetchElmFNo(RetNo,FNo,285))* (InclRate) / (InclRate2000/100);
end;

Function GetTxblIncBfrLosses(RetNo:Integer):real;
begin
 With Ret[RetNo] do
 begin
  result := MaxR(0,
       Lnn[23600]
     // -Lnn[248]  //20181109
      -Lnn[24900]
      -Lnn[25000]
      -Lnn[25100]
      {-Lnn[25300]}
      {-Lnn[25400]}
      -Lnn[25500]
      -Lnn[25600]);
   {reduce by Ref credits}
 // result :=MaxR(0,result -MaxR(0,(100/16)*(Lnn[35000]+Lnn[40425]+Lnn[40427]-Lnn[423])));
 end;
end;

Function GetQuebecAbat(RetNo:Integer;BfrAmt:Boolean):Real;
Var Rate:Real;
begin
 Rate:=16.5;  //20111124
 //May 31, 2008
 If ((Ret[RetNo].Province = 'QC')       or
    (IsMultJurisdiction(RetNo) = True)) or
    (IsDeemedResQuebec(RetNo))          or  //jz//NonResCERT-R1 //202404 - add IsDeemedResQuebec
    (FetchElmFNo(RetNo,InfoFNo,245)>'')     //property in QC //jz//NonResCERT-R1 //202404 - add
 then
  //ok continue
 Else
   begin
    result :=0;
    { Did not work
    //20240402
     if (FetchElmFNo(RetNo,InfoFNo,252)>'')  //deemed nores
     and (FetchElmFNo(RetNo,InfoFNo,238)>'')  //sect 116 disposed property
     and (FetchElmFNo(RetNo,InfoFNo,245)>'')   //property in QC
     then
     //ok
     Else
     }
     exit;
   end;

 //20100117
 If BfrAmt=True then  //bfr min tax
 Begin
  Result := Vl(FetchElm(RetNo,'T691',206)) * Rate/100;
  If IsMultJurisdiction(RetNo) then Result := Vl(FetchElm(RetNo,'T2203',212));
  Exit;
 end
 else
 begin
  Result := Vl(FetchElm(RetNo,'T691',206)) * Rate/100;
  If IsMultJurisdiction(RetNo) then Result := Vl(FetchElm(RetNo,'T2203',212));
  //20130106
  If SubjectToMinTax(RetNo) then Result:=MaxR(0,Vl(FetchElm(RetNo,'T691',208))-Vl(FetchElm(RetNo,'T1',149)))* Rate / 100;   //logging //20190922
  //If SubjectToMinTax(RetNo) then Result:=MaxR(0,Vl(FetchElm(RetNo,'T691',208))-Vl(FetchElm(RetNo,'S1',76)))* Rate / 100;   //logging

 end;
end;



Function CareGiverEligible(RetNo:Integer;BirthDate,Relationship,Infirmity:string;NetInc:Real):boolean;
Var DependantAge:integer;
begin
  //20130422
 If Birthdate = '' then  begin result := false;exit;end;

{//20180310
 If NetInc >=Constant[RY].CareGvrBase then
 begin
  If (Ret[RetNo].Province='ON')
  Or (Ret[RetNo].Province='AB')
  Or (Ret[RetNo].Province='SK') then
   Result:=True
  Else
  begin result := false;exit;End;
 end;
}
 DependantAge:= CalcAge(BirthDate);
 //If DependantAge<18 then begin Result:=False;exit;end;  //20171125

 result := false;
 If DependantAge >=65 then
 begin
   If (Relationship = 'Parent') or (Relationship = 'GrandParent') then
   begin
     result := true;
     exit;
   end
   else
   begin
    //If UpperCase(Infirmity) ='Y' then result :=True;  //20121115  //20170511
   exit;
 end;
 end;

 //20170511
 If (DependantAge >=18)then result := true;
 If (DependantAge <18) and (Ret[RetNo].Province='ON') then result := true; //20180310

end;


Function GetEducXferFromKids(RetNo:Integer):real;
{anybody tranferred education to my SIN}
Var I,RNo,S11FNo:integer;
begin
 {check S11 of all loaded returns}
 Result := 0;
 S11FNo:= GetFormNo('S11',RetNo);
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   Rno := RetRec.RetNo;
   If FetchElmFNo(RNo,S11FNo,26) = GetSinNo(RetNo) then {retno designated as rceipient}
    begin
     Result := Result+Vl(FetchElmFNo(RNo,S11FNo,10));
    end;
 end;
end;


Procedure CopyDependToPage1(PrevRetNo:Integer;RetNo:integer;Ndx:Integer);
Var i,FNo:integer;
begin     {ndx is the subscipt to the SIN in DEPEND}
 FNo := GetFormNo('DEPEND');
// InfoFNo:=GetFormNo('INFO');
 With Ret[Retno].Frm[InfoFNo] do
 begin
  Strings[3] := Ret[PrevRetno].Frm[FNo].Strings[Ndx];  {sin}
  Strings[2] := Ret[PrevRetno].Frm[FNo].Strings[Ndx-2];  {Firstname}
  Strings[5] := Ret[PrevRetno].Frm[FNo].Strings[Ndx-1];  {last}
  Strings[6] := Ret[PrevRetno].Frm[FNo].Strings[Ndx+7];  {street}
  Strings[10] := Ret[PrevRetno].Frm[FNo].Strings[Ndx+8];  {City}
  Strings[14] := Ret[PrevRetno].Frm[FNo].Strings[Ndx+10];  {prov}
  Strings[15] := Ret[PrevRetno].Frm[FNo].Strings[Ndx+11];  {postal}
  Strings[9] := Ret[PrevRetno].Frm[FNo].Strings[Ndx+3];  {birthdate}
  Strings[10] := Ret[PrevRetno].Frm[FNo].Strings[Ndx+8];  {City}
  Strings[18] := 'X'; {assumed single}
 end;
end;

Function GetIndexInDependants(PrevRetNo:Integer;CplSin:String):Integer;
Var i:integer;
begin
 Result :=-1;
 i:=7;  {fistr sin}
 Repeat
  If CplSin =  FetchElm(PrevRetNo,'DEPEND',i) then
    begin Result :=i;exit;end;
  Inc(i,15);
 until i>127;
end;

Function CalcGSTC(RetNo: integer; FName: String;FNo: integer):Real;
Const BaseCredit=248; ChildCredit=130;BaseAmount1=8047;BaseAmount2=32312;
//Const BaseCredit=216; ChildCredit=114;BaseAmount1=7022;BaseAmount2=28193;
Var I,k:integer; Kids,QKids:String;EquivSp:Boolean;
begin
  result:=0;
  with Ret[RetNo].Frm[Fno] do
  begin
    Kids := FetchElm(RetNo,'INFO',31);
    If Ret[RetNo].Lnn[30425] > 0 then
       EquivSp := True
     else
       EquivSp := false;

     Tv[4] := Ret[RetNo].Lnn[23600];
     Tv[5] := SpouseIncome(RetNo);
     Tv[24]:=GetTotalUCCB(RetNo)+GetTotalRDSP(RetNo);
     Tv[6] := Tv[4] + Tv[5]-Tv[24];

     Tv[7] := BaseCredit;
     If Ret[RetNo].MarStatus < 3 then Tv[8] :=BaseCredit else Tv[8] := 0;
     If Ret[RetNo].Lnn[30425] > 0 then Tv[9] := BaseCredit else Tv[9] := 0;
     If EquivSp <> True then
       QKids := Kids
     else
     begin
        k:= MyStrToInt(kids)-1; {exclude eq to spouse}
        If k<0 then k:=0;
        QKids := IntToStr(k);
     end;

     Tv[11] := Vl(QKids) * ChildCredit;

     If Ret[RetNo].MarStatus > 2 then
      begin
       Tv[12] := Tv[6];
       Tv[13] := BaseAmount1;
       Tv[14] := MaxR(0,Tv[12] - Tv[13]);
       Tv[15] := MinR(ChildCredit, 0.02 * Tv[14]);//MinR(105, 0.02 * Tv[14]);
      end
     else
      for i := 12 to 15 do Tv[i] :=0;

    Tv[16] := Tv[7] +Tv[8]+Tv[9]+Tv[11]+Tv[15];
    Tv[17] := Tv[6];
    Tv[18] := BaseAmount2;
    Tv[19] := MaxR(0, Tv[17] - Tv[18]);
    Tv[20] := Tv[19] * 0.05;
    Tv[21] := MaxR(0,Tv[16]-Tv[20]);
    If Tv[21] < 1 then Tv[21] := 0;
    Tv[22] := Tv[21] / 4;

    Result := Tv[22];
  end; {End with}
end;


end.

