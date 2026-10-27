unit FP_2027calc;
interface

uses Classes;

 Procedure DTC(RetNo:integer;FName:string;FNo:integer);
 Procedure ACCOUNTS(RetNo: integer; FName: String;FNo: integer);
 Procedure GENPLAN(RetNo: integer; FName: String;FNo: integer);
 Procedure SPECIFICPLAN(RetNo: integer; FName: String;FNo: integer);
 Procedure PORTFOLIO(RetNo: integer; FName: String;FNo: integer);
 Procedure CalcDetAssetYield(CurVal:Real;Interest:String;PercentCl:Real;PercentSp:Real;
         Var CurValCl:Real;Var CurValSp:Real;
         Var Yield:Real;Var YieldCl:Real;Var YieldSp:Real);
 Procedure FldMEM(RetNo: integer; FName: String;FNo: integer);
 Procedure FldTAPE(RetNo: integer; FName: String;FNo: integer);
 Function GetLifeEventsEmptyIndex(RetNo:Integer;DepName:String):Integer;
 Procedure CalcEducation(RetNo:Integer);
 Procedure CalcAccumDetails(RetNo:Integer);
 Procedure CalcMultiPageForm(RetNo:integer;FName:string);
 Procedure Calc(RetNo: integer; FName: string);
 Procedure CalcDynamic(RetNo: integer; FName: string; MyComponent:TComponent);
 Procedure CalcAffectedBy(RetNo: integer; FName: String);
 procedure UpdatePrices(FileNm:string);
 Procedure CALCALL(RetNo: integer);

 procedure PrepLetter(RetNo: integer; FName: String;FNo: integer;Pg:integer);
 procedure LETR_1(RetNo: integer; FName: string; FNo: integer);
 procedure LETR_2(RetNo: integer; FName: string; FNo: integer);
 procedure Profile(RetNo: integer; FName: string; FNo: integer);
 Procedure NETWORTH(RetNo: integer; FName: String;FNo: integer);
 procedure LIVINGExp_1(RetNo: integer; FName: string; FNo: integer);
 procedure LIVINGExp_2(RetNo: integer; FName: string; FNo: integer);
 procedure ADDINFO(RetNo: integer; FName: string; FNo: integer);
 procedure SUPPL(RetNo: integer; FName: string; FNo: integer);
 procedure NPAD(RetNo: integer; FName: string; FNo: integer);
 procedure NPADC(RetNo: integer; FName: string; FNo: integer);
 procedure PRIVAT(RetNo: integer; FName: string; FNo: integer);
 procedure STATUS(RetNo: integer; FName: string; FNo: integer);

 procedure INV_1(RetNo: integer; FName: string; FNo: integer);
 procedure INV_2(RetNo: integer; FName: string; FNo: integer);
 Procedure OTHASS(RetNo: integer; FName: String;FNo: integer);

 Procedure PreAssetSum(RetNo: integer; FName: String; FNo: integer);//20170408 Igor
 Procedure AssetSum(RetNo: integer; FName: String; FNo: integer; MyComponent:TComponent);
 Procedure PreLiabSum(RetNo: integer; FName: String; FNo: integer); //20170408 Igor
 Procedure LiabSum(RetNo: integer; FName: String; FNo: integer; MyComponent:TComponent);

 Procedure Cash(RetNo: integer; FName: String;FNo: integer);
 Procedure CSB(RetNo: integer; FName: String;FNo: integer);
 Procedure GIC(RetNo: integer; FName: String;FNo: integer);
 Procedure Bonds(RetNo: integer; FName: String;FNo: integer);
 Procedure LOANS(RetNo: integer; FName: String;FNo: integer);
 Procedure TERMDEP(RetNo: integer; FName: String;FNo: integer);
 Procedure MUTFUNDS(RetNo: integer; FName: String;FNo: integer);
 Procedure STOCKS(RetNo: integer; FName: String;FNo: integer);
 Procedure DEFPLANS(RetNo: integer; FName: String;FNo: integer);
 Procedure REALEST(RetNo: integer; FName: String;FNo: integer);
 Procedure AUTOS(RetNo: integer; FName: String;FNo: integer);
 Procedure BUSINESS(RetNo: integer; FName: String;FNo: integer);
 // Procedure VACPROP(RetNo: integer; FName: String;FNo: integer);
// Procedure INVESTPROP(RetNo: integer; FName: String;FNo: integer);
// Procedure BUSINESSINC(RetNo: integer; FName: String;FNo: integer);
// Procedure BUSINESSNON(RetNo: integer; FName: String;FNo: integer);
 Procedure OTHASSETS(RetNo: integer; FName: String;FNo: integer);
 Procedure OTHFIXED(RetNo: integer; FName: String;FNo: integer);
 Procedure PROJECTIONCHARTS(RetNo: integer; FName: String;FNo: integer);
 Procedure LIFEINS(RetNo: integer; FName: String;FNo: integer);

 Procedure CreditCards(RetNo: integer; FName: String;FNo: integer);
 Procedure Mortgages(RetNo: integer; FName: String;FNo: integer);
 Procedure BANKADV(RetNo: integer; FName: String;FNo: integer);
 Procedure UnpaidBills(RetNo: integer; FName: String;FNo: integer);
 Procedure TaxPayable(RetNo: integer; FName: String;FNo: integer);
 Procedure CarLoans(RetNo: integer; FName: String;FNo: integer);
 Procedure OtherLtl(RetNo: integer; FName: String;FNo: integer);

 { I M P L E M E N T A T I O N }
implementation

Uses SysUtils,Graphics,Controls,Forms,Dialogs,vtMulti,vtCommon
   , vtDialogs,fCalcWatch,FP_2027,FP_2027Declare,FP_2027common,FP_2027common2
   , FP_2027TrimStr,FP_2027Calc1,FP_2027Calc2,FP_2027CALCTAX,FP_2027Calc3
   , FP_2027PopList,vtLabel,vtShape,vtEditBox,vtChild,FP_2027ChildWinNew
   , vtTrimStr, vtShared
   , vtDataBase, uADCompClient;


(*
Procedure LoadTV(RetNo: integer;FName: string; FNo : integer);
var
 i, BucketNo, StartFieldBucket,EndFieldBucket :integer;
 FPtr : Pointer;
 HdrRec   : PHeaderList; FldRec: PFieldList;
 NFields,NLines,NLabels: integer;
begin
 For i := 1 to High(Tv) do TV[i] := 0;
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 {Get Form specifications, Fields, etc}
 FPtr := GetFormPtr(FName);
 If (FPtr = Nil) then
   begin
      ShowMessage('Form '+FName+ ' was not found');
      exit;
   end;
 HdrRec  := FPtr;
 NFields := HdrRec.NumbFields;
 NLabels := HdrRec.NumbLabels;
 NLines  := HdrRec.NumbLines;
 FormOvrSw := GetFormOvrSw(RetNo,FNo);

 StartFieldBucket := (NLabels * LabelProperties) + (NLines * LineProperties) +1;
 EndFieldBucket   := StartFieldBucket+ NFields ;
 BucketNo := StartFieldBucket;
  {Load numeric strings into TV array}
 for i := StartFieldBucket to EndFieldBucket-1 do
   begin
     FldRec := Addr(HdrRec.Bucket[BucketNo]);
     If FldRec.Tag = 2 then {numeric}
        TV[FldRec.FieldId] := Vl(Ret[RetNo].Frm[FNo].Strings[FldRec.FieldId]);
     Inc(BucketNo,FieldProperties);
   end;
end;

Procedure SaveTV(RetNo: integer; FName: string; FNo: integer);
var
 i, BucketNo, StartFieldBucket,EndFieldBucket :integer;
 FPtr : Pointer;
 HdrRec   : PHeaderList; FldRec: PFieldList;
 NFields,NLines,NLabels: integer;
 S :string[13];
begin
 If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 {Get Form specifications, Fields, etc}
 FPtr := GetFormPtr(FName);
 If (FPtr = Nil) then
   begin
      ShowMessage('Form '+FName+ ' was not found');
      exit;
   end;
 HdrRec  := FPtr;
 NFields := HdrRec.NumbFields;
 NLabels := HdrRec.NumbLabels;
 NLines  := HdrRec.NumbLines;

 StartFieldBucket := (NLabels * LabelProperties) + (NLines * LineProperties) +1;
 EndFieldBucket   := StartFieldBucket+ NFields ;
 BucketNo := StartFieldBucket;
 {Copy TV array into the strings}
 BucketNo := StartFieldBucket;
 for i := StartFieldBucket to EndFieldBucket-1 do
   begin
     FldRec := Addr(HdrRec.Bucket[BucketNo]);
     If FldRec.Tag = 2 then {numeric}
      begin
       If TV[FldRec.FieldId] = 0 then
         Ret[RetNo].Frm[FNo].Strings[FldRec.FieldId] := ''
       else
         begin
          Str(TV[FldRec.FieldId]:10:2,s);
          Ret[RetNo].Frm[FNo].Strings[FldRec.FieldId] := s;
         end;
      end;
     Inc(BucketNo,FieldProperties);
   end;

end;
*)
Procedure CalcMultiPageForm(RetNo:integer;FName:string);
Var i,n:integer;Root:string[10];
begin
   n:=GetFormMxPg(FName);
   Root := ExtractFormRootName(FName);
   If Root = 'PAGE_' Then begin Calc(RetNo,FName);exit;end;
   For i:=1 to n do
     Calc(RetNo,Root+'_'+IntToStr(i)+ExtractFormInst(FName));

   If (Root = 'T777_') or (Root = 'T2124_') or (Root = 'T2032_')
   or (Root = 'T2121_') or (Root = 'T2042_') then
      Calc(RetNo,'GST370');
end;

Procedure CalcAffectedBy(RetNo: integer;FName: string);
Begin
  FList.CalcAffectedBy(RetNo,FName);
end;

Procedure CalcDynamic(RetNo: integer; FName: string; MyComponent:TComponent); //ALL FORMS IN CAPITAL
Var
i,FNo : integer;
Begin
  FNo :=GetFormNo(FName);
  If FNo =0 then exit;
  If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
  if FName = 'ASSETSUM' then begin AssetSum(RetNo,FName,FNo,MyComponent); exit; end
  else if FName = 'LIABSUM'  then begin LIABSUM(RetNo,FName,FNo,MyComponent);  exit; end;
End;

Procedure Calc(RetNo: integer; FName: string); {ALL FORMS IN CAPITAL}
Var
I,FNo : integer;
Begin
 FNo :=GetFormNo(FName);
 If FNo =0 then exit;
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 if FName = 'PROFILE' then
  begin Profile(RetNo,'PROFILE',GetFormno('PROFILE')); exit; end

 else if FName = 'LETR_1'   then begin LETR_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'INV_1'   then begin INV_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'INV_2'   then begin INV_2(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'NETWORTH' then begin NETWORTH(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'LIVINGEXP_1'  then begin LIVINGEXP_1(RetNo,'LIVINGEXP_1',GetFormno('LIVINGEXP_1')); exit;end
 else if FName = 'LIVINGEXP_2'  then begin LIVINGEXP_2(RetNo,'LIVINGEXP_2',GetFormno('LIVINGEXP_2')); exit;end
 else if FName = 'INVESTSTRATEGY'  then begin INVESTSTRATEGY(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'GENOBJ'  then begin GENOBJ(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'ACCOUNTS'  then begin ACCOUNTS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,5) = 'CASH#'  then begin CASH(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,4) = 'GIC#'  then begin GIC(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'BONDS#'  then begin BONDS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,4) = 'CSB#'  then begin CSB(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,9) = 'DEFPLANS#'  then begin DEFPLANS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,9) = 'BUSINESS#'  then begin BUSINESS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,10) = 'OTHASSETS#'  then begin OTHASSETS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,9) = 'OTHFIXED#'  then begin OTHFIXED(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'LOANS#'  then begin LOANS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,8) = 'TERMDEP#'  then begin TERMDEP(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,9) = 'MUTFUNDS#'  then begin MUTFUNDS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7) = 'STOCKS#'  then begin STOCKS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,8) = 'REALEST#'  then begin REALEST(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'AUTOS#'  then begin AUTOS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,8) = 'FLDTAPE#'  then begin FLDTAPE(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,8) = 'LIFEINS#'  then begin LIFEINS(RetNo,FName,GetFormno(FName));exit; end

 else if LeftStr(FName,12) = 'CREDITCARDS#'  then begin CREDITCARDS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,9) = 'CARLOANS#'  then begin CARLOANS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,10) = 'MORTGAGES#'  then begin MORTGAGES(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,8) = 'BANKADV#'  then begin BANKADV(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,12) = 'UNPAIDBILLS#'  then begin UNPAIDBILLS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,11) = 'TAXPAYABLE#'  then begin TAXPAYABLE(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,9) = 'OTHERLTL#'  then begin OTHERLTL(RetNo,FName,GetFormno(FName));exit; end

 else if FName ='INCPROJECTION'  then begin INCPROJECTION(RetNo,FName,GetFormno(FName));exit; end
 else if FName  ='LIFEEVENTS'  then begin LIFEEVENTS(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'CASHFLOW'  then begin CASHFLOW(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'ACKNLDG'  then begin ACKNLDG(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'ADDINFO'  then begin ADDINFO(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'STATUS'  then begin STATUS(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'T1LINK'  then begin T1Link(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'RETPLAN'  then begin RETPLAN(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'CHACCUM'  then begin CHACCUM(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'PEVENTS'  then begin PEVENTS(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7) = 'EDUPLN#'  then begin EDUPLN(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'SUMOBJ'  then begin SUMOBJ(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'ANNINC'  then begin ANNINC(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'INSNEED'  then begin INSNEED(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'DISABLT'  then begin DISABLT(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'GOALS'  then begin GOALS(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'GOALSR'  then begin GOALSR(RetNo,FName,GetFormno(FName));exit; end
 {else if FName = 'CRITILL'  then begin CRITILL(RetNo,FName,GetFormno(FName));exit; end}
 else if FName = 'WILLS'  then begin WILLS(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'OTHASS'  then begin OTHASS(RetNo,FName,GetFormno(FName));exit; end

 else if FName = 'PROJECTIONCHARTS'  then begin PROJECTIONCHARTS(RetNo,FName,GetFormno(FName));exit; end

 else if FName = 'TXSUM_1'  then begin TXSUM_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'TXSUM_2'  then begin TXSUM_2(RetNo,FName,GetFormno(FName));exit; end

 else if FName = 'PRESVAL'  then begin PRESVAL(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'FUTVAL'  then begin FUTVAL(RetNo,FName,GetFormno(FName));exit; end

 else if FName = 'T2033_1'   then begin T2033_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'T2151_1'   then begin T2151_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'T2220_1'   then begin T2220_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'EFORM'   then begin EFORM(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'TD2'     then begin TD2(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'T1058'   then begin T1058(RetNo,FName,GetFormno(FName));exit; end

 else if FName = 'T1036_1'   then begin T1036_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'T3012_1'   then begin T3012_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'T2097'   then begin T2097(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'PASSSUM' then begin PASSSUM(RetNo,FName,GetFormno(FName));exit; end
 else if FName = 'ASSUME'  then begin ASSUME(RetNo,FName,GetFormno(FName));exit; end

  {multiple pages}
 else if LeftStr(Fname,8) = 'GENPLAN#'   then begin GENPLAN(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(Fname,13) = 'SPECIFICPLAN#' then begin SPECIFICPLAN(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(Fname,5) = 'NPAD#'   then begin NPAD(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(Fname,6) = 'NPADC#'   then begin NPADC(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(Fname,7) = 'PRIVAT#'  then begin PRIVAT(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7) = 'PSHELT#'  then begin PSHELT(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7) = 'PNONSH#'  then begin PNONSH(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7) = 'PSEMSH#'  then begin PSEMSH(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7) = 'POTHER#'  then begin POTHER(RetNo,FName,GetFormno(FName));exit; end

 //else if LeftStr(FName,6) = 'PFIXA#'   then begin PFIXA(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'PNETW#'   then begin PNETW(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'PLIAB#'   then begin PLIAB(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7) = 'PSMINV#'  then begin PSMINV(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,10) = 'PCASHFLOW#' then begin PCASHFLOW(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,8) = 'PINVPLN#' then begin PINVPLN(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'PRRSP#'   then begin PRRSP(RetNo,FName,GetFormno(FName));exit; end

 else if LeftStr(FName,6) = 'ORD_1#'  then begin ORD_1(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'ORD_2#'  then begin ORD_2(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'ORD_3#'  then begin ORD_3(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,6) = 'ORD_4#'  then begin ORD_4(RetNo,FName,GetFormno(FName));exit; end

 else if LeftStr(FName,10) = 'PORTFOLIO#'  then begin PORTFOLIO(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,11)  = 'TAXPLANNER#' then begin TAXPLANNER(RetNo,FName,GetFormno(FName));exit; end
 else if FName              = 'S1' then begin S1(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7)  = 'TAXP_1#'  then begin TAXP_1(RetNo,FName,GetFormno(FName));exit; end
 else if LeftStr(FName,7)  = 'TAXP_2#'  then begin TAXP_2(RetNo,FName,GetFormno(FName));exit; end

 else if FName  = 'TAXPL_1'  then begin TAXPL_1(RetNo,FName,GetFormno(FName));exit; end
 else if FName  = 'TAXPL_2'  then begin TAXPL_2(RetNo,FName,GetFormno(FName));exit; end
 else if FName  = 'TAXPL_3'  then begin TAXPL_3(RetNo,FName,GetFormno(FName));exit; end

 else exit;
end;


procedure Profile(RetNo: integer; FName: String;FNo: integer);
var
i,k,DaysInCan:integer;
D1,D2 : string[11]; {mm/dd/yyyy/}
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
  If Strings[80]='' then Strings[80]:=FormatDateTime('yyyy-mm-dd',Date);
  If Strings[99]='' then strings[99] := OptRec.Nfl_Prov;
  If Length(strings[99]) >2 then Strings[99] := PrvShort[GetPrvLongIndex(Strings[99])];
  Strings[7] := GetT1Year;
  Strings[42] := GetT1Year;
  Strings[18] := GetT1Year;
  If Strings[95]+Strings[96] = '' then Strings[95] :='X';
  if Strings[41]='' then Strings[41]:='365';  //20190303
   if MyStrToInt(Strings[41])> Constant[RY].FullYear then Strings[41]:=IntToStr(Constant[RY].FullYear); //20190303

  Ret[RetNo].PartYear := MyStrToInt(Strings[41]) / Constant[RY].FullYear;
  If Strings[8]='' then strings[8] := Strings[99];
  If Length(strings[8]) >2 then Strings[8] := PrvShort[GetPrvLongIndex(Strings[8])];

  If Strings[6]=''   then Strings[6] := User.OverloadProperty[AppFP, 'Prp_City']; //20170112 Igor
  If Strings[27]=''  then Strings[27] := '1970-01-01';
  (*
  If (Ret[RetNo].ClientId ='') and (GetSinNo(RetNo) >'') then
    Ret[RetNo].ClientId := GetSinNo(RetNo)+'-'+'BL'+MidStr(FormatDateTime('yyyy-mm-dd',Now),4,1);
  *)
  ClientIdName :=
   AllTrim(GetLastName(RetNo))+', '+AllTrim(GetFirstName(RetNo));
  If Strings[9]+Strings[79]='' then Strings[82]:='';
  Ret[RetNo].Province:=Strings[99];
  Ret[RetNo].MarStatus:=GetMarStatus(RetNo);

  If Ret[RetNo].MarStatus < 3 then
  begin
   If strings[82]='' then strings[82] := Strings[2];  //last nm
   If strings[21]='' then strings[19] := 'X';    //last nm
   If strings[29]='' then strings[29] := Strings[27];    //Fp
  end;


  i:=43;k:=101;
  Repeat
   If Strings[i+2]='' then Strings[k]:='';  //no birthdate, no education
   If (UpperCase(Strings[k]) = 'X') and (Strings[k+10]='') then
      Strings[k+10] :='4';

   If (Strings[k+10]='') and (Strings[k+11]>'') then Strings[k+11]:='';
   Inc(i,4);
   Inc(k,1);
  until i>75;

  If OptRec.Capitalization='ProperCase' then
  begin
   Strings[1]:=ConvertToProper(Strings[1]);
   Strings[2]:=ConvertToProper(Strings[2]);
   Strings[5]:=ConvertToProper(Strings[5]);

   Strings[17]:=ConvertToProper(Strings[17]);
   Strings[82]:=ConvertToProper(Strings[82]);
   Strings[21]:=ConvertToProper(Strings[21]);
  end
  else
  begin
   Strings[1]:=UpperCase(Strings[1]);
   Strings[2]:=UpperCase(Strings[2]);
   Strings[5]:=UpperCase(Strings[5]);

   Strings[17]:=UpperCase(Strings[17]);
   Strings[82]:=UpperCase(Strings[82]);
   Strings[21]:=UpperCase(Strings[21]);

  end;

  //put prep info invisible for letter use
  Strings[120]:=OptRec.Prp_Name;
  Strings[121]:=OptRec.Prp_Street;
  Strings[122]:=OptRec.Prp_City;
  Strings[123]:=OptRec.Prp_Prov;
  Strings[124]:=OptRec.Prp_Postal;
  Strings[125]:=OptRec.Prp_Area;
  Strings[126]:=OptRec.Prp_Tel;
  Strings[127]:=OptRec.Prp_FxArea;
  Strings[128]:=OptRec.Prp_Fax;
  Strings[129]:=OptRec.Prp_EMail;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure CALCALL(RetNo: integer);
Var i,j,StreamId,FNo:Integer;FName : string[10];
   TxblInc,DividendCredit:Real; FromFNo:Integer;
begin
Try
 With Ret[RetNo] do
 begin
  SummarizeAssets(RetNo);
  SummarizeLifeIns(RetNo);
  SummarizeLiabilities(RetNo);
  Calc(RetNo,'PROFILE');
  Calc(RetNo,'ASSUME');
  Calc(RetNo,'GOALS');
  Calc(RetNo,'DTC');       //20170411
  Calc(RetNo,'LIVINGEXP_1'); //20200314
  Calc(RetNo,'LIVINGEXP_2'); //20200314
  Calc(RetNo,'CASHFLOW');
  Calc(RetNo,'INCPROJECTION');
  Calc(RetNo,'NETWORTH');
  Calc(RetNo,'ANNINC');
  Calc(RetNo,'INSNEED');
  Calc(RetNo,'INVESTSTRATEGY');  //investm strategy
  CalcEducation(RetNo);
  GetRetirementParms(RetNo);
  FixedAssetsProjectionList.clear;
  BalanceList.Clear;
  LiabilitiesProjectionList.Clear;
  BusinessProjectionList.Clear;
  CashFlowProjectionList.Clear;
  TotInvestmProjectionList.Clear;
  InvProjectionList.Clear;
  NetWorthProjectionList.Clear;

  For i:=0 to RetirementParms.NumbPeriods do
 // For i:=0 to RetirementParms.NumbPeriods +2 do
  begin
   //New(FixedAssetsProjectionRec);
   FixedAssetsProjectionRec := TFixedAssetsProjectionRec.Create;
   FixedAssetsProjectionRec.PeriodNo      := i;
   FixedAssetsProjectionRec.Total         := 0;
   FixedAssetsProjectionList.Add(FixedAssetsProjectionRec);

   //New(BalanceRec);
   BalanceRec := TBalanceRec.Create;
   BalanceRec.PeriodNo      := i;
   For StreamId:= 1 to 4 do
   begin
    BalanceRec.BegBalance[StreamId]    := 0;
    BalanceRec.RegContr[StreamId]      := 0;
    BalanceRec.RegWithDr[StreamId]     := 0;
    BalanceRec.LumpSumContr[StreamId]  := 0;
    BalanceRec.LumpSumWithDr[StreamId] := 0;
    BalanceRec.EndBalance[StreamId]    := 0;
    BalanceRec.EndActual[StreamId]     := 0;
    BalanceRec.Notes[StreamId]  := '';
   end;

   BalanceList.Add(BalanceRec);

   //New(LiabilitiesProjectionRec);
   LiabilitiesProjectionRec := TLiabilitiesProjectionRec.Create;
   LiabilitiesProjectionRec.PeriodNo      := i;
   LiabilitiesProjectionList.Add(LiabilitiesProjectionRec);

   //New(BusinesssProjectionRec);
   BusinesssProjectionRec := TBusinessProjectionRec.Create;
   BusinesssProjectionRec.PeriodNo      := i;
   BusinessProjectionList.Add(BusinesssProjectionRec);

   //New(CashFlowProjectionRec);
   CashFlowProjectionRec := TCashFlowProjectionRec.Create;
   CashFlowProjectionRec.PeriodNo      := i;
   CashFlowProjectionRec.Cola               := 0;
   CashFlowProjectionRec.LTermDebt          := 0;
   CashFlowProjectionRec.DispInc            := 0;
   CashFlowProjectionList.Add(CashFlowProjectionRec);

   //New(InvProjectionRec);
   InvProjectionRec := TInvProjectionRec.Create;
   InvProjectionRec.PeriodNo      := i;
   InvProjectionList.Add(InvProjectionRec);

   //New(TotInvestmProjectionRec);
   TotInvestmProjectionRec := TTotInvestmentsRec.Create;
   TotInvestmProjectionRec.PeriodNo      := i;
   For StreamId:= 1 to 4 do
   begin
    TotInvestmProjectionRec.BegBalance[StreamId]    := 0;
    TotInvestmProjectionRec.EndBalance[StreamId]    := 0;
   end;
   TotInvestmProjectionRec.TotBegBalance  := 0;
   TotInvestmProjectionRec.TotEndBalance    := 0;
   TotInvestmProjectionList.Add(TotInvestmProjectionRec);

   //New(NetWorthProjectionRec);
   NetWorthProjectionRec := TNetWorthProjectionRec.Create;
   NetWorthProjectionRec.PeriodNo      := i;
   NetWorthProjectionRec.TotAssets     :=0;
   NetWorthProjectionRec.TotLiabilities:=0;
   NetWorthProjectionRec.CapGains      :=0;
   NetWorthProjectionRec.CapGainsTaxes :=0;
   NetWorthProjectionRec.NetWorth      :=0;
   NetWorthProjectionList.Add(NetWorthProjectionRec);

   //New(RRSPProjectionRec);
   RRSPProjectionRec := TRRSPProjectionRec.Create;
   RRSPProjectionRec.PeriodNo      := i;
   RRSPProjectionList.Add(RRSPProjectionRec);
  end;
  BuildFixedAssetsProjection(RetNo);
  BuildBusinessProjection(RetNo);
  BuildLiabilitiesProjection(RetNo);
  BuildCashFlowProjection(RetNo);
  BuildRRSPProjection(RetNo);
  BuildInvDetailProjection(RetNo);  //builds balancelist  depends on cashflowprojectionlist  -FAILS!!
  //Delay(100);  //20130203  //20170408 Igor
  BuildAssetsProjection(RetNo); // builds TotInvestmProjectionList relies on balancelist
  BuildNetWorthProjection(RetNo);
  BuildCashFlowProjection(RetNo);
  BuildRRSPProjection(RetNo);
  BuildInvProjection(RetNo);    //invprojectionlist
  CalcAccumDetails(RetNo);

  Calc(RetNo,'ACKNLDG');
  UpdateAllDataIndicators(RetNo);
  Ret[RetNo].CalcStatus := True;
 end;
except
end;
end;


Procedure LIVINGEXP_1(RetNo: integer; FName: String;FNo: integer);
Var I,j:integer; Percent:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,1,2);
    If Strings[91]='' then Strings[91]:='Y';
    //20130908
    If Strings[94]='' then Strings[94]:='Y';
    if Strings[94]='' then Strings[94]:=FetchElm(RetNo,'ASSUME',74);
    If Strings[93]='' then Strings[93]:=FetchElm(RetNo,'ASSUME',3);
    StoreElm(RetNo,GetFormNo('ASSUME'), 3, Strings[93]);   //update assume
    StoreElm(RetNo,GetFormNo('ASSUME'), 74, Strings[94]);

    If UpperCase(Strings[91]) ='Y' then
    begin
     If Tv[92]=0 then Tv[92]:=75;
     Percent:=Tv[92]/100;
     i:=3;
     Repeat
      Tv[i+2]:=Tv[i] * Percent;
      Inc(i,4);
     until i>87;
    end;
    {Exp and allow}
    For i:=11 to 14 do Tv[i]:=0;
    Tv[11] := Tv[3]+Tv[7];
    Tv[12] := Tv[4]+Tv[8];
    Tv[13] := Tv[5]+Tv[9];
    Tv[14] := Tv[6]+Tv[10];
  {Auto exp}
   Tv[47] := AddColumns(15,39,4);
   Tv[48] := AddColumns(16,40,4);
   Tv[49] := AddColumns(17,41,4);
   Tv[50] := AddColumns(18,42,4);
  {Clothing}
   Tv[87] := AddColumns(51,83,4);
   Tv[88] := AddColumns(52,84,4);
   Tv[89] := AddColumns(53,85,4);
   Tv[90] := AddColumns(54,86,4);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure LIVINGEXP_2(RetNo: integer; FName: String;FNo: integer);
Var I:integer;Percent:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   FillHeader(RetNo,FNo,1,2);
   If UpperCase(FetchElm(RetNo,'LIVINGEXP_1',91)) ='Y' then
   begin
    Percent:=Vl(FetchElm(RetNo,'LIVINGEXP_1',92))/100;
    i:=3;
    Repeat
     Tv[i+2]:=Tv[i] * Percent;
     Inc(i,4);
    until i>23;
    Tv[33]:=Tv[31] * Percent;
    Tv[41]:=Tv[39] * Percent;

    i:=44;
    Repeat
     Tv[i+2]:=Tv[i] * Percent;
     Inc(i,5);
    until i>64;

    i:=76;
    Repeat
     Tv[i+2]:=Tv[i] * Percent;
     Inc(i,4);
    until i>92;

    i:=97;
    Repeat
     Tv[i+2]:=Tv[i] * Percent;
     Inc(i,5);
    until i>112;

    i:=135;
    Repeat
     Tv[i+2]:=Tv[i] * Percent;
     Inc(i,5);
    until i>135;
   end;

   Tv[68] := AddColumns(3,23,4)+Tv[31]+Tv[39]+AddColumns(44,64,5);
   Tv[69] := AddColumns(4,24,4)+Tv[32]+Tv[40]+AddColumns(45,65,5);
   Tv[70] := AddColumns(5,25,4)+Tv[33]+Tv[41]+AddColumns(46,66,5);
   Tv[71] := AddColumns(6,26,4)+Tv[34]+Tv[42]+AddColumns(47,67,5);

   Tv[116] := AddColumns(76,92,4)+AddColumns(97,112,5);
   Tv[116]:=Tv[116]+Tv[135];
   Tv[117] := AddColumns(77,93,4)+AddColumns(98,113,5);
   Tv[117]:=Tv[117]+Tv[136];
   Tv[118] := AddColumns(78,94,4)+AddColumns(99,114,5);
   Tv[118]:=Tv[118]+Tv[137];
   Tv[119] := AddColumns(79,95,4)+AddColumns(100,115,5);
   Tv[119]:=Tv[119]+Tv[138];

   If Vl(FetchElm(RetNo,'LIVINGEXP_1',43)) >0 then
     Tv[120]:=Vl(FetchElm(RetNo,'LIVINGEXP_1',43))
   else
     Tv[120] := Vl(FetchElm(RetNo,'LIVINGEXP_1',11))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',47))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',87))+
              Tv[68]+Tv[72]+Tv[116];

   If Vl(FetchElm(RetNo,'LIVINGEXP_1',44)) >0 then
     Tv[121]:=Vl(FetchElm(RetNo,'LIVINGEXP_1',44))
   else
     Tv[121] := Vl(FetchElm(RetNo,'LIVINGEXP_1',12))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',48))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',88))+
              Tv[69]+Tv[73]+Tv[117];

   If Vl(FetchElm(RetNo,'LIVINGEXP_1',45)) >0 then
     Tv[122]:=Vl(FetchElm(RetNo,'LIVINGEXP_1',45))
   else
     Tv[122] := Vl(FetchElm(RetNo,'LIVINGEXP_1',13))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',49))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',89))+
              Tv[70]+Tv[74]+Tv[118];

   If Vl(FetchElm(RetNo,'LIVINGEXP_1',46)) >0 then
     Tv[123]:=Vl(FetchElm(RetNo,'LIVINGEXP_1',46))
   else
     Tv[123] := Vl(FetchElm(RetNo,'LIVINGEXP_1',14))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',50))+
              Vl(FetchElm(RetNo,'LIVINGEXP_1',90))+
              Tv[71]+Tv[75]+Tv[119];
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure NETWORTH(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
   LoadTv(RetNo,FName,FNo);
   {As of today}
   with Ret[RetNo].Frm[Fno] do
   begin
    FillHeader(RetNo,FNo,27,1);
    Strings[13]:=ClientFirstName(RetNo);
    Strings[25]:=ClientFirstName(RetNo);
    Strings[26]:=ClientFirstName(RetNo);
    Strings[3] :=SpouseFirstName(RetNo);
    Strings[54]:=SpouseFirstName(RetNo);
    Strings[40]:=SpouseFirstName(RetNo);
    (*
    //20121213
    If UpperCase(Strings[92])<> 'Y' then
    begin
     If AssetsSumRec.TotalValu =0 then
     begin
      ShowTimedMessage('There are no detail schedules prepared'),1400);
      Strings[92]:='Y';
     end;
    end;
    *)
    If UpperCase(Strings[92])<> 'Y' then
    begin
     Tv[4] := AssetsSumRec.CashTotalValueCl;
     Tv[5] := AssetsSumRec.NonShTotalValueCl;
     Tv[6] := AssetsSumRec.SheltTotalValueCl;
     Tv[7] := AssetsSumRec.SemShTotalValueCl;
     Tv[12] := AssetsSumRec.OthAssetsTotalValueCl;
     Tv[8] := LifeInsuranceRec.CashSurrenderValue;
     //fixed
     Tv[11] := AssetsSumRec.HomesTotalValueCl;
     Tv[80] := AssetsSumRec.VacPropTotalValueCl;
     Tv[10] := AssetsSumRec.AutosTotalValueCl;
     Tv[83] := AssetsSumRec.OthFixedTotalValueCl;

    //Other assets
     Tv[74] := AssetsSumRec.BusinessNonIncTotalValueCl;
     Tv[77] := AssetsSumRec.BusinessIncTotalValueCl;
     Tv[12] := AssetsSumRec.InvestPropTotalValueCl;
     Tv[36] := AssetsSumRec.InvestPropTotalValueSp;
     Tv[15] := AssetsSumRec.OthAssetsTotalValueCl;
    //spouse
     Tv[28] := AssetsSumRec.CashTotalValueSp;
     Tv[29] := AssetsSumRec.NonShTotalValueSp;
     Tv[30] := AssetsSumRec.SheltTotalValueSp;
     Tv[31] := AssetsSumRec.SemShTotalValueSp;
     Tv[32] := LifeInsuranceRec.CashSurrenderValue;
     Tv[35] := AssetsSumRec.HomesTotalValueSp;
     Tv[79] := AssetsSumRec.VacPropTotalValueSp;
     Tv[34] := AssetsSumRec.AutosTotalValueSp;
     Tv[82] := AssetsSumRec.OthFixedTotalValueSp;

     Tv[64] := AssetsSumRec.BusinessNonIncTotalValueSp;
     Tv[76] := AssetsSumRec.BusinessIncTotalValueSp;
     Tv[38] := AssetsSumRec.OthAssetsTotalValueSp;
     //Liabilities client
     Tv[18] := LiabilitySumRec.AccountsPayableCl;
     Tv[17] := LiabilitySumRec.BankAdvancesCl;
     Tv[22] := LiabilitySumRec.LongTermMonthlyCl*12;
     Tv[19] := LiabilitySumRec.LongTermMonthlyCl * 12;
     Tv[40]:=LiabilitySumRec.HomeMortgageCl;
     Tv[85]:=LiabilitySumRec.VacPropMortgageCl;
     Tv[88]:=LiabilitySumRec.InvestPropMortgageCl;
     Tv[70]:=LiabilitySumRec.OtherLTLCl;
     Tv[22]:=Tv[19];
     //Liabilities spouse
     Tv[57] := LiabilitySumRec.AccountsPayableSP;
     Tv[56] := LiabilitySumRec.BankAdvancesSP;
     Tv[58]:=LiabilitySumRec.LongTermMonthlySP * 12;
     Tv[26]:=LiabilitySumRec.HomeMortgageSP;
     Tv[84]:=LiabilitySumRec.VacPropMortgageSP;
     Tv[87]:=LiabilitySumRec.InvestPropMortgageSP;
     Tv[60]:=LiabilitySumRec.OtherLTLSP;

     Tv[61]:=Tv[58];
     end;
   end;
   {Add up}
   with Ret[RetNo].Frm[Fno] do
   begin
    //client
    Tv[9] := Tv[4]+Tv[5]+Tv[6]+Tv[7]+Tv[8]; //+Tv[26];
    Tv[14]:= Tv[11]+Tv[80]+Tv[10]+Tv[83];
    Tv[89]:= Tv[74]+Tv[77]+Tv[12]+Tv[15];
    Tv[16]:= Tv[9]+Tv[14]+Tv[89];
    //client liab
    Tv[20]:= Tv[17]+Tv[18]+Tv[19];
    Tv[2] := Tv[40]+Tv[85]+Tv[88]+Tv[70] - Tv[22];
    Tv[23]:= Tv[20]+Tv[2];
    Tv[24]:= Tv[16]-Tv[23];
    Tv[25]:= Tv[23]+Tv[24];
    //Spouse assets
    Tv[33] := Tv[28]+Tv[29]+Tv[30]+Tv[31]+Tv[32];
    Tv[37]:= Tv[35]+Tv[79]+Tv[34]+Tv[82];
    Tv[90]:= Tv[64]+Tv[76]+Tv[36]+Tv[38];
    Tv[39]:= Tv[33]+Tv[37]+Tv[90];
    //spouse liabl
    Tv[59]:= Tv[57]+Tv[56]+Tv[58];
    Tv[63] := Tv[26]+Tv[84]+Tv[87]+Tv[60] - Tv[61];
    Tv[62]:= Tv[59]+Tv[63];
    Tv[55]:= Tv[39]-Tv[62];
    //Tv[25]:= Tv[23]+Tv[24];

    //add cl and sp assets
    Tv[41]:=Tv[4]+Tv[28];
    Tv[42]:=Tv[5]+Tv[29];
    Tv[43]:=Tv[6]+Tv[30];
    Tv[44]:=Tv[7]+Tv[31];
    Tv[45]:=Tv[8]+Tv[32];
    Tv[46]:=Tv[9]+Tv[33];


    Tv[48]:=Tv[11]+Tv[35];
    Tv[78]:=Tv[80]+Tv[79];
    Tv[47]:=Tv[10]+Tv[34];
    Tv[81]:=Tv[83]+Tv[82];
    Tv[50]:=Tv[14]+Tv[37];

    Tv[53]:=Tv[74]+Tv[64];
    Tv[75]:=Tv[77]+Tv[76];
    Tv[49]:=Tv[12]+Tv[36];
    Tv[51]:=Tv[15]+Tv[38];
    Tv[91]:=Tv[89]+Tv[90];
    Tv[52]:=Tv[16]+Tv[39];
    // add cl and sp liabilities
    Tv[67]:=Tv[18]+Tv[57];
    Tv[66]:=Tv[17]+Tv[56];
    Tv[68]:=Tv[19]+Tv[58];
    Tv[69]:=Tv[20]+Tv[59];

    Tv[25]:=Tv[40]+Tv[26];
    Tv[54]:=Tv[85]+Tv[84];
    Tv[86]:=Tv[88]+Tv[87];
    Tv[21]:=Tv[70]+Tv[60];
    Tv[71]:=Tv[22]+Tv[61];
    Tv[73]:=Tv[2]+Tv[63];
    Tv[72]:=Tv[23]+Tv[62];
    Tv[65]:=Tv[24]+Tv[55];
   end;
   SaveTv(RetNo,FName,FNo);
   Ret[RetNo].FrmHasData[FNo] := True;
end;

procedure NPAD(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Strings[1] := ClientLastName(RetNo)+', '+ClientFirstName(RetNo);
  Strings[4] :=GetSinNo(RetNo);
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure NPADC(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Strings[2] := ClientLastName(RetNo)+', '+ClientFirstName(RetNo);
  Strings[3] := GetSinNo(RetNo);
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

procedure ADDINFO(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo] do
 Begin
  Frm[FNo].Strings[31] := AllTrim(FetchElm(RetNo,FirstFormName,2))
   +', '+AllTrim(FetchElm(RetNo,FirstFormName,1));
  Ret[RetNo].Frm[FNo].Strings[1] := HoRec.BusinessName;
  Ret[RetNo].Frm[FNo].Strings[2] := '???' {User.Prep_Name;}
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure SUPPL(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo] do
 Begin
   Frm[FNo].Strings[1] := ClientLastName(retNo)+', '+ ClientFirstName(RetNo);
 end;
 SaveTv(RetNo,FName,FNo);

end;

Procedure PRIVAT(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
    Strings[40] := ClientLastName(retNo)+', '+ ClientFirstName(RetNo);
    Strings[41] := GetSinNo(RetNo);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure STATUS(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     Strings[1] := ClientLastName(retNo)+', '+ ClientFirstName(RetNo);
     Strings[3] := GetSinNo(RetNo);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure Inv_1(RetNo:integer;FName:string;FNo:integer);
Var i,j,PagesCharged:integer; Frms,HowMany:TstringList;
begin
 UpdateAllDataIndicators(RetNo);
 LoadTv(RetNo,FName,FNo);
 Frms := TStringList.Create;
 HowMany := TStringList.Create;
 with Ret[RetNo].Frm[Fno] do
 begin
  PagesCharged :=0;
  Strings[1] := ClientLastName(RetNo)+', '+ClientFirstName(RetNo);
  Strings[2] :=AppYear;
  Strings[3] :=IntToStr(CountPagesGenerated(RetNo));
  Strings[5] :=FloatToStr(GetTotalFee(RetNo)); //FormatAmount(FloatToStr(GetTotalFee(RetNo)));
  GetListInvoiceForms(RetNo,Frms,HowMany);
  j := 7;
  For i:=0 to Frms.Count-1 do
    begin
    Inc(PagesCharged,MyStrToInt(HowMany[i]));
    Strings[j]   := PaddR(HowMany[i],5)+Frms[i];
    Strings[j+1] :=FormatFloat('###,###.##',GetFormFee(Frms[i],MyStrToInt(HowMany[i])));
     //FormatAmount(FloatToStr(GetFormFee(Frms[i],MyStrToInt(HowMany[i]))));
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
with Ret[RetNo].Frm[Fno] do
 begin
 Strings[1] := OptRec.PRp_Name;
 Strings[2] := OptRec.PRp_Street;
 Strings[4] := OptRec.PRp_City+', '+OptRec.PRp_Prov;
 Strings[5] := OptRec.PRp_Postal;
 Strings[7] := OptRec.PRp_Area+' '+OptRec.PRp_Tel;
 Strings[8] := OptRec.PRp_GSTNo;
 If strings[3] = '' then Strings[3] := DateToMonthDayYear(Date);
 If Strings[23]+Strings[24]+strings[25] >'' then
 begin
  If Strings[9] = '' then Strings[9] := DateToStr(Date);
 end
 else
  Strings[9] := '';
 (*? Invoice Number
 Strings[10] := User.M_Office+'-'+User.Branch + '-'
    + User.Prep_Intls
    + '-' +IntToStr(User.Inv_no); {invoice}
 *)
 If Strings[10]='' then Strings[10] := GetSinNo(RetNo)+'-'+AppYear;
 Strings[11] := GetRetName(RetNo);
 Strings[12] := Rtrim(FetchElm(RetNo,'PAGE_1',4));
 Strings[15] := Rtrim(FetchElm(RetNo,'PAGE_1',7))+', '+
                Rtrim(FetchElm(RetNo,'PAGE_1',8));
 Strings[16] := AppYear;

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
 If Strings[52]>'' then Tv[17]:= Vl(Strings[50]) * OptRec.Prp_Hour/60;

 Tv[19] := Tv[17] + Tv[18]+Tv[34] + Tv[35]+Tv[36] + Tv[37]+Tv[38] + Tv[39]+
           Tv[42] + Tv[43];
 If Strings[8] = '' then Strings[20] := '' else Strings[20] :='6';
 Tv[21] := Tv[19] * Vl(Strings[20]) / 100;
 Tv[22] := Tv[19] + Tv[21];
 Strings[26] := OptRec.PRp_Name;
 end;

SaveTv(RetNo,FName,FNo);
end;


(*
Procedure Inv_2(RetNo:integer;FName:string;FNo:integer);
Var i:integer;
begin
UpdateAllDataIndicators(RetNo);
LoadTv(RetNo,FName,FNo);
with Ret[RetNo].Frm[Fno] do
 begin
 Strings[1] := OptRec.Prp_Name; //HoRec.BusinessName;
 Strings[2] := OptRec.Prp_street;
                 //HoRec.Street;
 Strings[4] := OptRec.Prp_City + ','+OptRec.Prp_Prov;//HoRec.City+', '+HoRec.Province;
 Strings[5] := OptRec.Prp_Postal; //HoRec.Postal;
 Strings[7] := OptRec.Prp_Area + ' '+OptRec.Prp_Tel; //HoRec.Phone;
 Strings[8] := OptRec.Prp_GSTNo; //HoRec.GSTNo;
 Strings[3] := DateToMonthDayYear(Date);
 Strings[9] := FormatDateTime('yyyy-mm-dd',Now);
  {DateToStr(Date);}
 Strings[10] := GetSinNo(RetNo)+'-'+AppYear;
 Strings[11] := AllTrim(ClientFirstName(RetNo))+' '+AllTrim(ClientLastName(RetNo));
 Strings[12] := Rtrim(FetchElm(RetNo,'PROFILE',5));
 Strings[15] := Rtrim(FetchElm(RetNo,'PROFILE',6))
                +', '+Rtrim(FetchElm(RetNo,'PROFILE',8))
                +', '+Rtrim(FetchElm(RetNo,'PROFILE',12));

 If Strings[16]='' then Strings[16] := AppYear;

 If Strings[51]+Strings[49]+Strings[44]+Strings[45]+Strings[46]+
         Strings[47]+Strings[48]+Strings[52] =''
 then
   begin
         Case MyStrToInt(HoRec.BillType) of
          0: Strings[51] :='X';
          1: Strings[49] :='X';
          2: begin Strings[52] :='X';Strings[50] := '30';end;
          3: Strings[46] :='X';
         end;
   end;

 If Strings[44]>'' then Tv[17] := HoRec.VSFee else Tv[7] :=0;
 If Strings[45]>'' then Tv[17] := HoRec.SFee else Tv[6]:=0;
 If Strings[46]>'' then Tv[17] := HoRec.AFee else tv[8] :=0;
 If Strings[47]>'' then Tv[17] := HoRec.CFee else Tv[9]:=0;
 If Strings[48]>'' then Tv[17]:= HoRec.VCFee else Tv[10]:=0;
 If Strings[49]>'' then Tv[17]:= GetTotalFee(RetNo);
 If Strings[52]>'' then Tv[17]:= Vl(Strings[50]) *HoRec.HourlyRate/60;


 Tv[19] := Tv[17] + Tv[18]+Tv[34] + Tv[35]+Tv[36] + Tv[37]+Tv[38] + Tv[39]+
           Tv[42] + Tv[43];
 If Strings[8] = '' then Strings[20] := '' else Strings[20] :='6';
 Tv[21] := Tv[19] * Vl(Strings[20]) / 100;
 Tv[22] := Tv[19] + Tv[21];
 Strings[26] := '???' {User.Prep_Name;}
 end;

SaveTv(RetNo,FName,FNo);
end;
*)

Procedure STOCKS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=511 to 540 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+8]='' then Strings[i+8]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+9]+tv[i+10]+Tv[i+11]=0 then Tv[i+9]:=100;
       If Tv[i+9]>100 then Tv[i+9]:=100;
       {sp %} If tv[i+10]>100 then Tv[i+10]:=100;
             If tv[i+11]>100 then Tv[i+11]:=100;
             If Tv[i+10]+Tv[i+11]>100 then Tv[i+11]:=0;
      {client percent}  Tv[i+9]:=100-Tv[i+10]-Tv[i+11];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}  //if Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn('Cash');
      If Strings[i+12]='' then Strings[i+12]:='NONSH';
      CurVal:=Tv[i+7];
      Interest:=Strings[i+13];
      PercentCl:=Tv[i+9];
      PercentSp:=Tv[i+10];
      PortfolioType:=Strings[i+12];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+14]:=Yield;
      //Summary
      If PortfolioType = 'NONSH' then
      begin
       Tv[511]:=Tv[511]+CurValCl; //cl cur valu
       Tv[516]:=Tv[516]+YieldCl; //cl yield
       Tv[526]:=Tv[526]+CurValSp; //Sp cur valu
       Tv[531]:=Tv[531]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SHELT'  then
      begin
        Tv[512]:=Tv[512]+CurValCl; //cl cur valu
        Tv[517]:=Tv[517]+YieldCl; //cl cur valu
        Tv[527]:=Tv[527]+CurValSp; //Sp cur valu
        Tv[532]:=Tv[532]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SEMSH'  then
      begin
        Tv[513]:=Tv[513]+CurValCl; //cl cur valu
        Tv[518]:=Tv[518]+YieldCl; //cl cur valu
        Tv[528]:=Tv[528]+CurValSp; //Sp cur valu
        Tv[533]:=Tv[533]+YieldSp; //cl yield
      end;

      If PortfolioType = 'OTHER'  then
      begin
        Tv[514]:=Tv[514]+CurValCl; //cl cur valu
        Tv[519]:=Tv[519]+YieldCl; //cl cur valu
        Tv[529]:=Tv[529]+CurValSp; //Sp cur valu
        Tv[534]:=Tv[534]+YieldSp; //cl yield
      end;

     end;
    Inc(i,16);
   until i>465;
   //Summary box cl
   If Tv[511]>0 then Tv[521] :=(Tv[516]/Tv[511])*100 else Tv[521]:=0; //yieldcl%
   If Tv[512]>0 then Tv[522] :=(Tv[517]/Tv[512])*100 else Tv[522]:=0; //YieldSp%
   If Tv[523]>0 then Tv[523] :=(Tv[518]/Tv[513])*100 else Tv[523]:=0; //yieldcl%
   If Tv[514]>0 then Tv[524] :=(Tv[519]/Tv[514])*100 else Tv[522]:=0; //YieldSp%
   Tv[515]:=Tv[511]+Tv[512]+Tv[513]+Tv[514]; //total curvalCl
   Tv[520]:=Tv[516]+Tv[517]+Tv[518]+Tv[519];//YieldCl
   If Tv[515]>0 then Tv[525] :=(Tv[520]/Tv[515])*100 else Tv[525]:=0; //TotYieldCl
   //Summary box Sp
   If Tv[526]>0 then Tv[536] :=(Tv[531]/Tv[526])*100 else Tv[526]:=0; //yieldcl%
   If Tv[527]>0 then Tv[537] :=(Tv[532]/Tv[527])*100 else Tv[537]:=0; //YieldSp%
   If Tv[528]>0 then Tv[538] :=(Tv[533]/Tv[528])*100 else Tv[538]:=0; //yieldcl%
   If Tv[529]>0 then Tv[539] :=(Tv[534]/Tv[529])*100 else Tv[539]:=0; //YieldSp%
   Tv[530]:=Tv[526]+Tv[527]+Tv[528]+Tv[529]; //total curvalCl
   Tv[535]:=Tv[531]+Tv[532]+Tv[533]+Tv[534];//YieldCl
   If Tv[530]>0 then Tv[540] :=(Tv[535]/Tv[530])*100 else Tv[540]:=0; //TotYieldCl
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure OTHASS(RetNo: integer; FName: String;FNo: integer);
Var I:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     FillHeader(RetNo,FNo,1,2);
     Tv[23] := AddColumns(4,22,2);
   end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure OLDMF4(RetNo: integer; FName: String;FNo: integer);
Var I:integer;x,TotCurrValue,EstAnnualRate:real;
begin

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
     FillHeader(RetNo,FNo,1,2);
    {Stocks}
    Tv[158]:=0;x:=0;
    i:=7;
    Repeat
     Tv[i+2] := Tv[i] * Tv[i+1]/100;
     Tv[158] := Tv[158]+Tv[i];
     x:=x+Tv[i+2];
     Inc(i,7);
    until i>154;
   If Tv[158] <>0 then
      Tv[159] := (x / Tv[158]) * 100
    else
      Tv[159] := 0;

    {Life insurance}
    Tv[3] :=0;Tv[230]:=0;Tv[231]:=0;Tv[232]:=0;
    i:=164;
    Repeat
     Tv[3] := Tv[3] + Tv[i-1];
     Tv[230] := Tv[230]+Tv[i];
     Tv[231] := Tv[231] + Tv[i+1];
     Tv[232] := Tv[232] + Tv[i+2];
     Inc(i,10);
    until i>224;

   end; {End with}
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

procedure PrepLetter(RetNo: integer; FName: String;FNo: integer;Pg:integer);
Var  i,LinesInPage1,MaxLinesInPage,Ltr2FNo: integer;AList :TstringList;Txt:Ansistring;
    CleanList:TstringList;CoverLetterFile:String;
begin
If UpperCase(LetterType) = 'FP' then {calc only if cover}
 begin
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[Fno] do
  Begin
   For i:=1 to 60 do Strings[i] :='';
   LoadDataDict;
   AList := TStringList.Create;
   CoverLetterFile := 'FP.LTR';
   (*   If UpperCase(FetchElm(RetNo,'PAGE_1',46)) = 'Y' then {Efiled}
     CoverLetterFile := 'COVER2.LTR'
   else
     CoverLetterFile := 'COVER1.LTR';
   *)
   If FileExists(AppDir+'\'+CoverLetterFile) then
      AList.LoadFromFile(AppDir+'\'+CoverLetterFile);
   For i :=0 to AList.Count-1 do {first pass:conditions stay in}
    begin
     txt := AList[i];
     InterpretTextLine(txt);
     AList[i] := txt; {put it back}
    end;
   ResolveConditions(AList);  {second pass}
   ExpandTabs(AList);
   AllowLinesForLogo(Alist);

   MaxLinesInPage := 59;
   Ltr2FNo := GetFormNo('LETR_2');
   If AList.Count >MaxLinesInPage then
    begin LinesInPage1:=MaxLinesInPage; Ret[RetNo].FrmHasData[Ltr2FNo] := True;end
   else
    begin LinesInPage1:=AList.Count;Ret[RetNo].FrmHasData[Ltr2FNo] := False;end;
   InitFormData(RetNo,GetFormNo('LETR_1'));
   InitFormData(RetNo,GetFormNo('LETR_2'));
   for i:=0 to LinesInPage1-1 do
     Ret[RetNo].Frm[GetFormNo('LETR_1')].Strings[i+1] := AList[i];
   for i:=LinesInPage1 to AList.Count-1 do
     Ret[RetNo].Frm[GetFormNo('LETR_2')].Strings[i-MaxLinesInPage+1] := AList[i];
  end;  {with}
  AList.Free;
 end; {end if Cover}
end;

procedure UpdatePrices(FileNm:String);
Var
  Table1: TADTable;
  ADConnection: TADConnection;
  MFundsMastRec: TMFundsMastRec;
begin
  //Table1:= TTable.Create(Application);
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  //DataBaseName := ClientsDb; {CfgRec.Dir_cur;}
  SetTableName(ADConnection, Table1, ClientPortfoliosDBLite, ClientPortfoliosTableLite, 'File_Name');

  With table1 Do
  begin
    If Table1.Active then Table1.close;
    //DataBaseName := ClientsDb; {CfgRec.Dir_cur;}
    Table1.TableName := 'ClientPortfolios';
    Table1.Open;
    Table1.IndexFieldNames := 'File_Name';
    ApplyClientRange(Table1,FileNm);
    First;
    repeat
      If GetMFundsMasterData(AllTrim(FieldByName('FundId').AsString), MFundsMastRec) = true then
      begin
        Edit;
        FieldByName('FundName').AsString := MFundsMastRec.FundName;
        FieldByName('UnitPrice').AsFloat := MFundsMastRec.UnitPrice;
        FieldByName('CurrentValue').AsFloat := MFundsMastRec.UnitPrice * Table1.FieldByName('Qty').AsFloat;
        FieldByName('Date').AsString := MFundsMastRec.Date;
        Try
          Table1.Post;
        except on E: Exception do
          MessageDlg(E.Message, mtError, [mbok], 0);
        end;
      end;
      Next;
    until Table1.Eof;
  end;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
end;

Procedure CalcAccumDetails(RetNo:Integer);
Var i,MxPgNo :Integer;
begin
  Calc(RetNo,'RETPLAN');
  BuildInvDetailProjection(RetNo);
  MxPgNo := GetMaxAccumPageNo(RetNo);
  If MxPgNo>1 then
    AddYearlyInstances(RetNo);
  For i :=1 to MxPgNo do Calc(RetNo,'PNONSH'+'#'+AllTrim(IntToStr(i)));
  For i :=1 to MxPgNo do Calc(RetNo,'PSHELT'+'#'+AllTrim(IntToStr(i)));
  For i :=1 to MxPgNo do Calc(RetNo,'PSEMSH'+'#'+AllTrim(IntToStr(i)));
  For i :=1 to MxPgNo do Calc(RetNo,'POTHER'+'#'+AllTrim(IntToStr(i)));
 Calc(RetNo,'RETPLAN');
end;

Procedure CalcEducation(RetNo:Integer);
Var i,j,k,n,Cnt,ProfFNo,LeFNo,EduPlnFNo:Integer;FInst:String[4];x:Real;
begin
  //create instances for EDUPLN and calc each child
  Cnt:=CountEducationKids(RetNo);
  If Cnt>0 then
  begin
   For i:=2 to cnt do
   begin
    FInst:='#'+AllTrim(IntToStr(i));
    EduPlnFNo:=GetFormNo('EDUPLN'+FInst);
    If EduPlnFNo=0 then
    begin
     AddPageInstance(RetNo, 'EDUPLN',FInst);
     //EduPlnFNo:=GetFormNo('EDUPLN'+FInst);
     If Ret[RetNo].Frm[EduPlnFNo].Count =0 then InitFormData(RetNo,EduPlnFNo);
    end;
   end;
  end;

  Cnt:=0;
  ProfFNo:=GetFormNo('PROFILE');
  i:=43; //index to Profile form
  k:=101;
  Repeat   {name and university}
   If (FetchElmFNo(RetNo,ProfFNo,i)>'')
   and (FetchElmFNo(RetNo,ProfFNo,i+2)>'')
   and (UpperCase(FetchElmFNo(RetNo,ProfFNo,k))='X')
   then
   begin
    Inc(cnt);
    FInst:='#'+AllTrim(IntToStr(Cnt));
    EduPlnFNo:=GetFormNo('EDUPLN'+FInst);
    EduPln(RetNo,'EDUPLN'+FInst,EduPlnFNo);
   end;
   Inc(i,4);
   Inc(k,1);
   until i>75;
end;

Function GetLifeEventsEmptyIndex(RetNo:Integer;DepName:String):Integer;
Var i,LeFNo:Integer;
begin
 Result:=0;
 LEFNo:=GetFormNo('PEVENTS');
 i:=3;
 Repeat
  If (UpperCase(FetchElmFNo(RetNo,LeFNo,i)) = '')
  or (UpperCase(FetchElmFNo(RetNo,LeFNo,i))=UpperCase(DepName+Chr(39)+'s EDUCATION')) then
    begin Result:=i;exit;end;
  Inc(i,11);
 until i>135;
end;

Procedure FldMEM(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure Cash(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=271 to 279 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date} //   If Strings[i+4]='' then Strings[i+4]:=FormatDateTime('yyyy-mm-dd',Now);
      {client percent}  If Tv[i+5]+tv[i+6]+Tv[i+7]=0 then Tv[i+5]:=100;
       If Tv[i+5]>100 then Tv[i+5]:=100;
       {sp %} If tv[i+6]>100 then Tv[i+6]:=100;
       If tv[i+7]>100 then Tv[i+7]:=100;
       If Tv[i+6]+Tv[i+7]>100 then Tv[i+7]:=0;
      {client percent}  Tv[i+5]:=100-Tv[i+6]-Tv[i+7];
      {asset class}
      //{int-div-capg} Strings[i+9]:=GetAssumedIntDivCapG('Cash');
      {interest}     If Strings[i+8]='' then Strings[i+8] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
      {annual yield} Tv[i+9]:= (Tv[i+3] * Vl(Strings[i+8]))/100;
      //{portfolio type} Strings[i+12]:='CASH';
      Tv[271]:=Tv[271]+Tv[i+3] * Tv[i+5]/100; //cl cur valu
      Tv[272]:=Tv[272]+Tv[i+9]* Tv[i+5]/100; //cl yield

      Tv[274]:=Tv[274]+Tv[i+3] * Tv[i+6]/100; //Sp cur valu
      Tv[275]:=Tv[275]+Tv[i+9]* Tv[i+6]/100; //sp curr value

     end;
    Inc(i,9);
   until i>262;
   {annual yield %}
   {client} If Tv[271]>0 then Tv[273]:=(Tv[272]/Tv[271]) * 100 else Tv[273]:=0;
   {Spouse} If Tv[274]>0 then Tv[276]:=(Tv[275]/Tv[274]) * 100 else Tv[276]:=0;
   {Total}
            Tv[277]:=Tv[271]+Tv[274];
            Tv[278]:=Tv[272]+Tv[275];
            If Tv[277]>0 then Tv[279]:=(Tv[278]/Tv[277]) * 100 else Tv[279]:=0;
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure GIC(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=451 to 468 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+6]='' then Strings[i+6]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+7]+tv[i+8]+Tv[i+9]=0 then Tv[i+7]:=100;
       If Tv[i+7]>100 then Tv[i+7]:=100;
       {sp %} If tv[i+8]>100 then Tv[i+8]:=100;
             If tv[i+9]>100 then Tv[i+9]:=100;
             If Tv[i+8]+Tv[i+9]>100 then Tv[i+9]:=0;
      {client percent}  Tv[i+7]:=100-Tv[i+8]-Tv[i+9];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}   If Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
      If Strings[i+12]='' then Strings[i+12]:='NONSH';
      CurVal:=Tv[i+5];
      Interest:=Strings[i+11];
      PercentCl:=Tv[i+7];
      PercentSp:=Tv[i+8];
      PortfolioType:=Strings[i+12];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+13]:=Yield;
      //Summary
      If PortfolioType = 'NONSH' then
      begin
       Tv[451]:=Tv[451]+CurValCl; //cl cur valu
       Tv[452]:=Tv[452]+YieldCl; //cl yield
       Tv[460]:=Tv[460]+CurValSp; //Sp cur valu
       Tv[461]:=Tv[461]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SHELT'  then
      begin
        Tv[454]:=Tv[454]+CurValCl; //cl cur valu
        Tv[455]:=Tv[455]+YieldCl; //cl cur valu
        Tv[463]:=Tv[463]+CurValSp; //Sp cur valu
        Tv[464]:=Tv[464]+YieldSp; //cl yield
      end;
     end;
    Inc(i,15);
   until i>436;
   //Summary box cl
   If Tv[451]>0 then Tv[453] :=(Tv[452]/Tv[451])*100 else Tv[459]:=0; //yieldcl%
   If Tv[454]>0 then Tv[456] :=(Tv[455]/Tv[454])*100 else Tv[454]:=0; //YieldSp%
   Tv[457]:=Tv[451]+Tv[454]; //total curvalCl
   Tv[458]:=Tv[452]+Tv[455]; //YieldCl
   If Tv[457]>0 then Tv[459] :=(Tv[458]/Tv[457])*100 else Tv[459]:=0; //TotYieldCl
   //Summary box Sp
   If Tv[460]>0 then Tv[462] :=(Tv[461]/Tv[460])*100 else Tv[460]:=0; //yieldcl%
   If Tv[463]>0 then Tv[465] :=(Tv[464]/Tv[463])*100 else Tv[463]:=0; //YieldSp%
   Tv[466]:=Tv[460]+Tv[463];  //
   Tv[467]:=Tv[461]+Tv[464];
   If Tv[466]>0 then
    Tv[468] :=(Tv[467]/Tv[466])*100 else Tv[468]:=0;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure CSB(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=451 to 468 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date} //   If Strings[i+6]='' then Strings[i+6]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+7]+tv[i+8]+Tv[i+9]=0 then Tv[i+7]:=100;
       If Tv[i+7]>100 then Tv[i+7]:=100;
       {sp %} If tv[i+8]>100 then Tv[i+8]:=100;
             If tv[i+9]>100 then Tv[i+9]:=100;
             If Tv[i+8]+Tv[i+9]>100 then Tv[i+9]:=0;
      {client percent}  Tv[i+7]:=100-Tv[i+8]-Tv[i+9];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}   If Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
      If Strings[i+12]='' then Strings[i+12]:='NONSH';
      CurVal:=Tv[i+5];
      Interest:=Strings[i+11];
      PercentCl:=Tv[i+7];
      PercentSp:=Tv[i+8];
      PortfolioType:=Strings[i+12];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+13]:=Yield;
      //Summary
      If PortfolioType = 'NONSH' then
      begin
       Tv[451]:=Tv[451]+CurValCl; //cl cur valu
       Tv[452]:=Tv[452]+YieldCl; //cl yield
       Tv[460]:=Tv[460]+CurValSp; //Sp cur valu
       Tv[461]:=Tv[461]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SHELT'  then
      begin
        Tv[454]:=Tv[454]+CurValCl; //cl cur valu
        Tv[455]:=Tv[455]+YieldCl; //cl cur valu
        Tv[463]:=Tv[463]+CurValSp; //Sp cur valu
        Tv[464]:=Tv[464]+YieldSp; //cl yield
      end;
     end;
    Inc(i,15);
   until i>436;
   //Summary box cl
   If Tv[451]>0 then Tv[453] :=(Tv[452]/Tv[451])*100 else Tv[459]:=0; //yieldcl%
   If Tv[454]>0 then Tv[456] :=(Tv[455]/Tv[454])*100 else Tv[454]:=0; //YieldSp%
   Tv[457]:=Tv[451]+Tv[454]; //total curvalCl
   Tv[458]:=Tv[452]+Tv[455]; //YieldCl
   If Tv[457]>0 then Tv[459] :=(Tv[458]/Tv[457])*100 else Tv[459]:=0; //TotYieldCl
   //Summary box Sp
   If Tv[460]>0 then Tv[462] :=(Tv[461]/Tv[460])*100 else Tv[460]:=0; //yieldcl%
   If Tv[463]>0 then Tv[465] :=(Tv[464]/Tv[463])*100 else Tv[463]:=0; //YieldSp%
   Tv[466]:=Tv[460]+Tv[463];  //
   Tv[467]:=Tv[461]+Tv[464];
   If Tv[466]>0 then
    Tv[468] :=(Tv[467]/Tv[466])*100 else Tv[468]:=0;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure BONDS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=451 to 468 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+6]='' then Strings[i+6]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+7]+tv[i+8]+Tv[i+9]=0 then Tv[i+7]:=100;
       If Tv[i+7]>100 then Tv[i+7]:=100;
       {sp %} If tv[i+8]>100 then Tv[i+8]:=100;
             If tv[i+9]>100 then Tv[i+9]:=100;
             If Tv[i+8]+Tv[i+9]>100 then Tv[i+9]:=0;
      {client percent}  Tv[i+7]:=100-Tv[i+8]-Tv[i+9];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}   If Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
      If Strings[i+12]='' then Strings[i+12]:='NONSH';
      CurVal:=Tv[i+5];
      Interest:=Strings[i+11];
      PercentCl:=Tv[i+7];
      PercentSp:=Tv[i+8];
      PortfolioType:=Strings[i+12];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+13]:=Yield;
      //Summary
      If PortfolioType = 'NONSH' then
      begin
       Tv[451]:=Tv[451]+CurValCl; //cl cur valu
       Tv[452]:=Tv[452]+YieldCl; //cl yield
       Tv[460]:=Tv[460]+CurValSp; //Sp cur valu
       Tv[461]:=Tv[461]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SHELT'  then
      begin
        Tv[454]:=Tv[454]+CurValCl; //cl cur valu
        Tv[455]:=Tv[455]+YieldCl; //cl cur valu
        Tv[463]:=Tv[463]+CurValSp; //Sp cur valu
        Tv[464]:=Tv[464]+YieldSp; //cl yield
      end;
     end;
    Inc(i,15);
   until i>436;
   //Summary box cl
   If Tv[451]>0 then Tv[453] :=(Tv[452]/Tv[451])*100 else Tv[459]:=0; //yieldcl%
   If Tv[454]>0 then Tv[456] :=(Tv[455]/Tv[454])*100 else Tv[454]:=0; //YieldSp%
   Tv[457]:=Tv[451]+Tv[454]; //total curvalCl
   Tv[458]:=Tv[452]+Tv[455]; //YieldCl
   If Tv[457]>0 then Tv[459] :=(Tv[458]/Tv[457])*100 else Tv[459]:=0; //TotYieldCl
   //Summary box Sp
   If Tv[460]>0 then Tv[462] :=(Tv[461]/Tv[460])*100 else Tv[460]:=0; //yieldcl%
   If Tv[463]>0 then Tv[465] :=(Tv[464]/Tv[463])*100 else Tv[463]:=0; //YieldSp%
   Tv[466]:=Tv[460]+Tv[463];  //
   Tv[467]:=Tv[461]+Tv[464];
   If Tv[466]>0 then
    Tv[468] :=(Tv[467]/Tv[466])*100 else Tv[468]:=0;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure LOANS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=307 to 318 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {maturity date} //   If Strings[i+4]='' then Strings[i+4]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+5]+tv[i+6]+Tv[i+7]=0 then Tv[i+5]:=100;
       If Tv[i+5]>100 then Tv[i+5]:=100;
       {sp %} If tv[i+6]>100 then Tv[i+6]:=100;
             If tv[i+7]>100 then Tv[i+7]:=100;
             If Tv[i+6]+Tv[i+7]>100 then Tv[i+7]:=0;
      {client percent}  Tv[i+5]:=100-Tv[i+6]-Tv[i+7];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}   //If Strings[i+8]='' then Strings[i+8] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
     // If Strings[i+9]='' then Strings[i+9]:='NONSH';
      CurVal:=Tv[i+3];
      Interest:=Strings[i+8];
      PercentCl:=Tv[i+5];
      PercentSp:=Tv[i+6];
      //PortfolioType:=Strings[i+9];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+10]:=Yield;
      //Summary
      //If PortfolioType = 'NONSH' then

       Tv[307]:=Tv[307]+CurValCl; //cl cur valu
       Tv[308]:=Tv[308]+YieldCl; //cl yield
       Tv[316]:=Tv[316]+CurValSp; //Sp cur valu
       Tv[317]:=Tv[317]+YieldSp; //cl yield
     end;
    Inc(i,10);
   until i>291;
   //Summary box cl
   If Tv[308]>0 then Tv[309] :=(Tv[308]/Tv[307])*100 else Tv[309]:=0; //yieldcl%
   If Tv[316]>0 then Tv[318] :=(Tv[317]/Tv[316])*100 else Tv[318]:=0; //YieldSp%
  // Tv[307]:=Tv[301]+Tv[304]; //total curvalCl
  // Tv[308]:=Tv[302]+Tv[305]; //YieldCl
  // If Tv[307]>0 then Tv[309] :=(Tv[308]/Tv[307])*100 else Tv[307]:=0; //TotYieldCl
   //Summary box Sp
  // If Tv[310]>0 then Tv[312] :=(Tv[311]/Tv[310])*100 else Tv[312]:=0; //yieldcl%
  // If Tv[313]>0 then Tv[315] :=(Tv[314]/Tv[313])*100 else Tv[313]:=0; //YieldSp%
  // Tv[316]:=Tv[310]+Tv[313];
  // Tv[317]:=Tv[311]+Tv[314];
  // If Tv[316]>0 then Tv[318] :=(Tv[317]/Tv[316])*100 else Tv[318]:=0;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure TERMDEP(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=421 to 438 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+6]='' then Strings[i+6]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+7]+tv[i+8]+Tv[i+9]=0 then Tv[i+7]:=100;
       If Tv[i+7]>100 then Tv[i+7]:=100;
       {sp %} If tv[i+8]>100 then Tv[i+8]:=100;
             If tv[i+9]>100 then Tv[i+9]:=100;
             If Tv[i+8]+Tv[i+9]>100 then Tv[i+9]:=0;
      {client percent}  Tv[i+7]:=100-Tv[i+8]-Tv[i+9];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}   If Strings[i+10]='' then Strings[i+10] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
      If Strings[i+13]='' then Strings[i+13]:='NONSH';
      CurVal:=Tv[i+5];
      Interest:=Strings[i+10];
      PercentCl:=Tv[i+7];
      PercentSp:=Tv[i+8];
      PortfolioType:=Strings[i+13];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+13]:=Yield;
      //Summary
      If PortfolioType = 'NONSH' then
      begin
       Tv[421]:=Tv[421]+CurValCl; //cl cur valu
       Tv[422]:=Tv[422]+YieldCl; //cl yield
       Tv[424]:=Tv[424]+CurValSp; //Sp cur valu
       Tv[425]:=Tv[425]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SHELT'  then
      begin
        Tv[430]:=Tv[430]+CurValCl; //cl cur valu
        Tv[431]:=Tv[431]+YieldCl; //cl cur valu
        Tv[433]:=Tv[433]+CurValSp; //Sp cur valu
        Tv[434]:=Tv[434]+YieldSp; //cl yield
      end;
     end;
    Inc(i,15);
   until i>406;
   //Summary box cl
   If Tv[421]>0 then Tv[423] :=(Tv[422]/Tv[421])*100 else Tv[421]:=0; //yieldcl%
   If Tv[424]>0 then Tv[426] :=(Tv[425]/Tv[424])*100 else Tv[426]:=0; //YieldSp%
   Tv[427]:=Tv[421]+Tv[424]; //total curvalCl
   Tv[428]:=Tv[422]+Tv[425]; //YieldCl
   If Tv[427]>0 then Tv[429] :=(Tv[428]/Tv[427])*100 else Tv[429]:=0; //TotYieldCl
   //Summary box Sp
   If Tv[430]>0 then Tv[432] :=(Tv[431]/Tv[430])*100 else Tv[432]:=0; //yieldcl%
   If Tv[433]>0 then Tv[435] :=(Tv[434]/Tv[433])*100 else Tv[435]:=0; //YieldSp%
   Tv[436]:=Tv[430]+Tv[433];
   Tv[437]:=Tv[431]+Tv[434];
   If Tv[436]>0 then
    Tv[438] :=(Tv[437]/Tv[436])*100 else Tv[438]:=0;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure MUTFUNDS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  MFundsMastRec:TMfundsMastRec;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
  FundCode:String;
  //Units,UnitPrice:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=511 to 540 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]+Strings[3]>'' then
     begin
      {percent}
       If Tv[i+9]+tv[i+10]+Tv[i+11]=0 then Tv[i+9]:=100;
       If Tv[i+9]>100 then Tv[i+9]:=100;
       {sp %} If tv[i+10]>100 then Tv[i+10]:=100;
             If tv[i+11]>100 then Tv[i+11]:=100;
             If Tv[i+10]+Tv[i+11]>100 then Tv[i+11]:=0;
      {client percent}  Tv[i+9]:=100-Tv[i+10]-Tv[i+11];

     FundCode:=Strings[i+2];
     {asof date}  If FundCode>'' then
     begin
      If Strings[i+8]='' then Strings[i+8]:=FormatDateTime('yyyy-mm-dd',Now);
     end;
      //bring from mutfunds db
      If UpperCase(Strings[545]) = 'Y' then
      begin
       If FundCode>'' then
       begin
        If GetMFundsMasterData(FundCode,MFundsMastRec) = True
        then
        begin
         Strings[i+3]:=MFundsMastRec.FundName;
         Strings[i+6]:=FormatFloat('#####.####',MFundsMastRec.UnitPrice);
         Strings[i+8]:=MFundsMastRec.Date;
        end
        Else
         ShowTimedMsg('Fund Code '+FundCode +' not found on the Mutual Funds Data Base',1300);
       end;
      end; //bring unit price

      If Strings[i+13]='' then Strings[i+13]:='NONSH';
      If Vl(Strings[i+5])>0 then Tv[i+7]:=Vl(Strings[i+5]) * Vl(Strings[i+6]);
      CurVal:=Tv[i+7];
      Interest:=Strings[i+12];
      PercentCl:=Tv[i+9];
      PercentSp:=Tv[i+10];
      PortfolioType:=Strings[i+13];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+16]:=Yield;
      //Summary
      If PortfolioType = 'NONSH' then
      begin
       Tv[511]:=Tv[511]+CurValCl; //cl cur valu
       Tv[516]:=Tv[516]+YieldCl; //cl yield
       Tv[526]:=Tv[526]+CurValSp; //Sp cur valu
       Tv[531]:=Tv[531]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SHELT'  then
      begin
        Tv[512]:=Tv[512]+CurValCl; //cl cur valu
        Tv[517]:=Tv[517]+YieldCl; //cl cur valu
        Tv[527]:=Tv[527]+CurValSp; //Sp cur valu
        Tv[532]:=Tv[532]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SEMSH'  then
      begin
        Tv[513]:=Tv[513]+CurValCl; //cl cur valu
        Tv[518]:=Tv[518]+YieldCl; //cl cur valu
        Tv[528]:=Tv[528]+CurValSp; //Sp cur valu
        Tv[533]:=Tv[533]+YieldSp; //cl yield
      end;

      If PortfolioType = 'OTHER'  then
      begin
        Tv[514]:=Tv[514]+CurValCl; //cl cur valu
        Tv[519]:=Tv[519]+YieldCl; //cl cur valu
        Tv[529]:=Tv[529]+CurValSp; //Sp cur valu
        Tv[534]:=Tv[534]+YieldSp; //cl yield
      end;

     end;
    Inc(i,18);
   until i>487;

   //Summary box cl
   If Tv[511]>0 then Tv[521] :=(Tv[516]/Tv[511])*100 else Tv[521]:=0; //yieldcl%
   If Tv[512]>0 then Tv[522] :=(Tv[517]/Tv[512])*100 else Tv[522]:=0; //YieldSp%
   If Tv[523]>0 then Tv[523] :=(Tv[518]/Tv[513])*100 else Tv[523]:=0; //yieldcl%
   If Tv[514]>0 then Tv[524] :=(Tv[519]/Tv[514])*100 else Tv[522]:=0; //YieldSp%
   Tv[515]:=Tv[511]+Tv[512]+Tv[513]+Tv[514]; //total curvalCl
   Tv[520]:=Tv[516]+Tv[517]+Tv[518]+Tv[519];//YieldCl
   If Tv[515]>0 then Tv[525] :=(Tv[520]/Tv[515])*100 else Tv[525]:=0; //TotYieldCl
   //Summary box Sp
   If Tv[526]>0 then Tv[536] :=(Tv[531]/Tv[526])*100 else Tv[526]:=0; //yieldcl%
   If Tv[527]>0 then Tv[537] :=(Tv[532]/Tv[527])*100 else Tv[537]:=0; //YieldSp%
   If Tv[528]>0 then Tv[538] :=(Tv[533]/Tv[528])*100 else Tv[538]:=0; //yieldcl%
   If Tv[529]>0 then Tv[539] :=(Tv[534]/Tv[529])*100 else Tv[539]:=0; //YieldSp%
   Tv[530]:=Tv[526]+Tv[527]+Tv[528]+Tv[529]; //total curvalCl
   Tv[535]:=Tv[531]+Tv[532]+Tv[533]+Tv[534];//YieldCl
   If Tv[530]>0 then Tv[540] :=(Tv[535]/Tv[530])*100 else Tv[540]:=0; //TotYieldCl
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure DefPlans(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=511 to 540 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+4]='' then Strings[i+4]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+5]+tv[i+6]+Tv[i+7]=0 then Tv[i+5]:=100;
       If Tv[i+5]>100 then Tv[i+5]:=100;
       {sp %} If tv[i+6]>100 then Tv[i+6]:=100;
             If tv[i+7]>100 then Tv[i+7]:=100;
             If Tv[i+6]+Tv[i+7]>100 then Tv[i+7]:=0;
      {client percent}  Tv[i+5]:=100-Tv[i+6]-Tv[i+7];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}  //if Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
      Strings[i+8]:='SHELT';
      CurVal:=Tv[i+3];
      Interest:=Strings[i+10];
      PercentCl:=Tv[i+5];
      PercentSp:=Tv[i+6];
      PortfolioType:=Strings[i+8];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+11]:=Yield;
      //Summary
      If PortfolioType = 'NONSH' then
      begin
       Tv[511]:=Tv[511]+CurValCl; //cl cur valu
       Tv[516]:=Tv[516]+YieldCl; //cl yield
       Tv[526]:=Tv[526]+CurValSp; //Sp cur valu
       Tv[531]:=Tv[531]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SHELT'  then
      begin
        Tv[512]:=Tv[512]+CurValCl; //cl cur valu
        Tv[517]:=Tv[517]+YieldCl; //cl cur valu
        Tv[527]:=Tv[527]+CurValSp; //Sp cur valu
        Tv[532]:=Tv[532]+YieldSp; //cl yield
      end;
      If PortfolioType = 'SEMISH'  then
      begin
        Tv[513]:=Tv[513]+CurValCl; //cl cur valu
        Tv[518]:=Tv[518]+YieldCl; //cl cur valu
        Tv[528]:=Tv[528]+CurValSp; //Sp cur valu
        Tv[533]:=Tv[533]+YieldSp; //cl yield
      end;

      If PortfolioType = 'OTHER'  then
      begin
        Tv[514]:=Tv[514]+CurValCl; //cl cur valu
        Tv[519]:=Tv[519]+YieldCl; //cl cur valu
        Tv[529]:=Tv[529]+CurValSp; //Sp cur valu
        Tv[534]:=Tv[534]+YieldSp; //cl yield
      end;

     end;
    Inc(i,11);
   until i>320;
   //Summary box cl
   If Tv[511]>0 then Tv[521] :=(Tv[516]/Tv[511])*100 else Tv[521]:=0; //yieldcl%
   If Tv[512]>0 then Tv[522] :=(Tv[517]/Tv[512])*100 else Tv[522]:=0; //YieldSp%
   If Tv[523]>0 then Tv[523] :=(Tv[518]/Tv[513])*100 else Tv[523]:=0; //yieldcl%
   If Tv[514]>0 then Tv[524] :=(Tv[519]/Tv[514])*100 else Tv[522]:=0; //YieldSp%
   Tv[515]:=Tv[511]+Tv[512]+Tv[513]+Tv[514]; //total curvalCl
   Tv[520]:=Tv[516]+Tv[517]+Tv[518]+Tv[519];//YieldCl
   If Tv[515]>0 then Tv[525] :=(Tv[520]/Tv[515])*100 else Tv[525]:=0; //TotYieldCl
   //Summary box Sp
   If Tv[526]>0 then Tv[536] :=(Tv[531]/Tv[526])*100 else Tv[526]:=0; //yieldcl%
   If Tv[527]>0 then Tv[537] :=(Tv[532]/Tv[527])*100 else Tv[537]:=0; //YieldSp%
   If Tv[528]>0 then Tv[538] :=(Tv[533]/Tv[528])*100 else Tv[538]:=0; //yieldcl%
   If Tv[529]>0 then Tv[539] :=(Tv[534]/Tv[529])*100 else Tv[539]:=0; //YieldSp%
   Tv[530]:=Tv[526]+Tv[527]+Tv[528]+Tv[529]; //total curvalCl
   Tv[535]:=Tv[531]+Tv[532]+Tv[533]+Tv[534];//YieldCl
   If Tv[530]>0 then Tv[540] :=(Tv[535]/Tv[530])*100 else Tv[540]:=0; //TotYieldCl
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure Autos(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=217 to 219 do Tv[i]:=0;
   //Non Inc
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+5]='' then Strings[i+5]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+6]+tv[i+7]+Tv[i+8]=0 then Tv[i+6]:=100;
       If Tv[i+6]>100 then Tv[i+6]:=100;
       {sp %} If tv[i+7]>100 then Tv[i+7]:=100;
             If tv[i+8]>100 then Tv[i+8]:=100;
             If Tv[i+7]+Tv[i+8]>100 then Tv[i+8]:=0;
      {client percent}  Tv[i+6]:=100-Tv[i+7]-Tv[i+8];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}  //if Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
    //If Strings[i+15]='' then Strings[i+15]:='NONSH';
      CurVal:=Tv[i+4];
     //interest:=Strings[i+12];
      PercentCl:=Tv[i+6];
      PercentSp:=Tv[i+7];
     // PortfolioType:=Strings[i+15];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
     //yield:=Tv[i+6];
      //CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      //Tv[i+16]:=Yield;
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //YieldCl:=Yield * PercentCl/100;
      //YieldSp:=Yield * PercentSp/100;
      //Summary
       Tv[217]:=Tv[217]+CurValCl; //cl cur valu
      //v[209]:=Tv[209]+YieldCl; //cl yield
       Tv[218]:=Tv[218]+CurValSp; //Sp cur valu
     //Tv[212]:=Tv[212]+YieldSp; //cl yield
     end;
    Inc(i,8);
   until i>209;
   //Summary box cl
   Tv[219]:=Tv[217]+Tv[218]; //total curvalCl
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure REALEST(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=235 to 258 do Tv[i]:=0;
   //Non Inc
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+5]='' then Strings[i+5]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+6]+tv[i+7]+Tv[i+8]=0 then Tv[i+6]:=100;
       If Tv[i+6]>100 then Tv[i+6]:=100;
       {sp %} If tv[i+7]>100 then Tv[i+7]:=100;
             If tv[i+8]>100 then Tv[i+8]:=100;
             If Tv[i+7]+Tv[i+8]>100 then Tv[i+8]:=0;
      {client percent}  Tv[i+6]:=100-Tv[i+7]-Tv[i+8];
      CurVal:=Tv[i+4];
     //interest:=Strings[i+12];
      PercentCl:=Tv[i+6];
      PercentSp:=Tv[i+7];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
     Yield:=Tv[i+9];
      //CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      //Tv[i+16]:=Yield;
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      YieldCl:=Yield * PercentCl/100;
      YieldSp:=Yield * PercentSp/100;
      //Summary
      If (i<38) then  //homes
      begin
       Tv[235]:=Tv[235]+CurValCl; //cl cur valu
       Tv[236]:=Tv[236]+YieldCl; //cl yield
       Tv[247]:=Tv[247]+CurValSp; //sp cur valu
       Tv[248]:=Tv[248]+YieldSp; //sp yield
      end;

      If (i>37) and (i<83) then  //vac prop
      begin
       Tv[238]:=Tv[238]+CurValCl; //cl cur valu
       Tv[239]:=Tv[239]+YieldCl; //cl yield
       Tv[250]:=Tv[250]+CurValSp; //sp cur valu
       Tv[251]:=Tv[251]+YieldSp; //sp yield
      end;

      If (i>82) then  //investm prop
      begin
       Tv[241]:=Tv[241]+CurValCl; //cl cur valu
       Tv[242]:=Tv[242]+YieldCl; //cl yield
       Tv[253]:=Tv[253]+CurValSp; //sp cur valu
       Tv[254]:=Tv[254]+YieldSp; //sp yield
      end;
    end;
    Inc(i,9);
   until i>226;
   //Summary box cl
   Tv[244]:=Tv[235]+Tv[238]+Tv[241]; //total curvalCl
   Tv[245]:=Tv[236]+Tv[239]+Tv[242]; //total yieldCl

   Tv[256]:=Tv[247]+Tv[250]+Tv[253]; //total curvalsp
   Tv[257]:=Tv[248]+Tv[251]+Tv[254]; //total curvalsp

   If TV[235]>0 then Tv[237]:=(Tv[236]/Tv[235])*100 else Tv[237]:=0; //TotYieldCl
   If TV[238]>0 then Tv[240]:=(Tv[239]/Tv[238])*100 else Tv[240]:=0; //TotYieldCl
   If TV[241]>0 then Tv[243]:=(Tv[242]/Tv[241])*100 else Tv[243]:=0; //TotYieldCl
   If TV[244]>0 then Tv[246]:=(Tv[245]/Tv[244])*100 else Tv[246]:=0; //TotYieldCl


   If TV[247]>0 then Tv[249]:=(Tv[248]/Tv[247])*100 else Tv[249]:=0; //TotYieldsp
   If TV[250]>0 then Tv[252]:=(Tv[251]/Tv[250])*100 else Tv[252]:=0; //TotYieldsp
   If TV[253]>0 then Tv[255]:=(Tv[254]/Tv[253])*100 else Tv[255]:=0; //TotYieldsp
   If TV[256]>0 then Tv[258]:=(Tv[257]/Tv[256])*100 else Tv[258]:=0; //TotYieldsp
  end;
  SaveTv(RetNo,FName,FNo);
End;


Procedure Business(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=208 to 216 do Tv[i]:=0;
   For i:=217 to 225 do Tv[i]:=0;
   //Non Inc
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+5]='' then Strings[i+5]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+7]+tv[i+8]+Tv[i+9]=0 then Tv[i+7]:=100;
       If Tv[i+7]>100 then Tv[i+7]:=100;
       {sp %} If tv[i+8]>100 then Tv[i+8]:=100;
             If tv[i+9]>100 then Tv[i+9]:=100;
             If Tv[i+8]+Tv[i+9]>100 then Tv[i+9]:=0;
      {client percent}  Tv[i+7]:=100-Tv[i+8]-Tv[i+9];
      CurVal:=Tv[i+4];
      PercentCl:=Tv[i+7];
      PercentSp:=Tv[i+8];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      Yield:=Tv[i+6];
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      YieldCl:=Yield * PercentCl/100;
      YieldSp:=Yield * PercentSp/100;
      //Summary
       Tv[208]:=Tv[208]+CurValCl; //cl cur valu
       Tv[209]:=Tv[209]+YieldCl; //cl yield
       Tv[211]:=Tv[211]+CurValSp; //Sp cur valu
       Tv[212]:=Tv[212]+YieldSp; //cl yield
     end;
    Inc(i,9);
   until i>118;
   //Summary box cl
   If Tv[208]>0 then Tv[210] :=(Tv[209]/Tv[208])*100 else Tv[210]:=0; //yieldcl%
   If Tv[211]>0 then Tv[213] :=(Tv[212]/Tv[211])*100 else Tv[213]:=0; //YieldSp%
   Tv[214]:=Tv[208]+Tv[211]; //total curvalCl
   Tv[215]:=Tv[209]+Tv[212];//YieldCl
   If Tv[214]>0 then Tv[216] :=(Tv[215]/Tv[214])*100 else Tv[216]:=0; //TotYieldCl


   //Incorporated
   i:=126; //1 less than starting element
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+5]='' then Strings[i+5]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
      If Tv[i+7]+tv[i+8]+Tv[i+9]=0 then Tv[i+7]:=100;
      If Tv[i+7]>100 then Tv[i+7]:=100;
      If tv[i+8]>100 then Tv[i+8]:=100; //sp %
      If tv[i+9]>100 then Tv[i+9]:=100;
      If Tv[i+8]+Tv[i+9]>100 then Tv[i+9]:=0;
      Tv[i+7]:=100-Tv[i+8]-Tv[i+9];  //client percent
      CurVal:=Tv[i+4];
      PercentCl:=Tv[i+7];
      PercentSp:=Tv[i+8];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;
      Yield:=Tv[i+6];
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      YieldCl:=Yield * PercentCl/100;
      YieldSp:=Yield * PercentSp/100;
      //Summary
       Tv[217]:=Tv[217]+CurValCl; //cl cur valu
       Tv[218]:=Tv[218]+YieldCl; //cl yield
       Tv[220]:=Tv[220]+CurValSp; //Sp cur valu
       Tv[221]:=Tv[221]+YieldSp; //cl yield
     end;
    Inc(i,9);
   until i>199;
   //Summary box cl
   If Tv[217]>0 then Tv[219] :=(Tv[218]/Tv[217])*100 else Tv[219]:=0; //yieldcl%
   If Tv[220]>0 then Tv[222] :=(Tv[221]/Tv[220])*100 else Tv[222]:=0; //YieldSp%
   Tv[223]:=Tv[217]+Tv[220]; //total curvalCl
   Tv[224]:=Tv[218]+Tv[221];//YieldCl
   If Tv[223]>0 then Tv[225] :=(Tv[224]/Tv[223])*100 else Tv[225]:=0; //TotYieldCl
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure OthFixed(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=271 to 276 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+5]='' then Strings[i+5]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+6]+tv[i+7]+Tv[i+8]=0 then Tv[i+6]:=100;
       If Tv[i+6]>100 then Tv[i+6]:=100;
       {sp %} If tv[i+7]>100 then Tv[i+7]:=100;
             If tv[i+8]>100 then Tv[i+8]:=100;
             If Tv[i+7]+Tv[i+8]>100 then Tv[i+8]:=0;
      {client percent}  Tv[i+6]:=100-Tv[i+7]-Tv[i+8];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}  //if Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
     // If Strings[i+14]='' then Strings[i+14]:='OTHER';
      CurVal:=Tv[i+4];
      Interest:=Strings[i+9];
      PercentCl:=Tv[i+6];
      PercentSp:=Tv[i+7];
     // PortfolioType:=Strings[i+14];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+10]:=Yield;
      //Summary
      Tv[271]:=Tv[271]+CurValCl; //cl cur valu
      Tv[272]:=Tv[272]+YieldCl; //cl yield
      Tv[274]:=Tv[274]+CurValSp; //Sp cur valu
      Tv[275]:=Tv[275]+YieldSp; //cl yield
     end;
    Inc(i,10);
   until i>261;
   //Summary box cl
   If Tv[271]>0 then Tv[273] :=(Tv[272]/Tv[271])*100 else Tv[273]:=0; //yieldcl%
   If Tv[274]>0 then Tv[276] :=(Tv[275]/Tv[274])*100 else Tv[276]:=0; //yieldcl%
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure OthAssets(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=271 to 276 do Tv[i]:=0;

   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+5]='' then Strings[i+5]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+6]+tv[i+7]+Tv[i+8]=0 then Tv[i+6]:=100;
       If Tv[i+6]>100 then Tv[i+6]:=100;
       {sp %} If tv[i+7]>100 then Tv[i+7]:=100;
             If tv[i+8]>100 then Tv[i+8]:=100;
             If Tv[i+7]+Tv[i+8]>100 then Tv[i+8]:=0;
      {client percent}  Tv[i+6]:=100-Tv[i+7]-Tv[i+8];
      //{asset class}    Strings[i+14]:='Income';
     // {int-div-capg} Strings[i+15]:=GetAssumedIntDivCapG(Strings[i+14]);
      {interest}  //if Strings[i+11]='' then Strings[i+11] :=GetAssumedHistRateOfReturn(RetNo,'Cash');
     // If Strings[i+14]='' then Strings[i+14]:='OTHER';
      CurVal:=Tv[i+4];
      Interest:=Strings[i+9];
      PercentCl:=Tv[i+6];
      PercentSp:=Tv[i+7];
     // PortfolioType:=Strings[i+14];
      CurValCl:=0;CurValSp:=0;Yield:=0;YieldCl:=0;YieldSp:=0;

      {annual yield}
      CalcDetAssetYield(CurVal,Interest,PercentCl,PercentSp,CurValCl,CurValSp,Yield,YieldCl,YieldSp);
      Tv[i+10]:=Yield;
      //Summary
      Tv[271]:=Tv[271]+CurValCl; //cl cur valu
      Tv[272]:=Tv[272]+YieldCl; //cl yield
      Tv[274]:=Tv[274]+CurValSp; //Sp cur valu
      Tv[275]:=Tv[275]+YieldSp; //cl yield
     end;
    Inc(i,10);
   until i>261;
   //Summary box cl
   If Tv[271]>0 then Tv[273] :=(Tv[272]/Tv[271])*100 else Tv[273]:=0; //yieldcl%
   If Tv[274]>0 then Tv[276] :=(Tv[275]/Tv[274])*100 else Tv[276]:=0; //yieldcl%
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure LifeIns(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
  CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=172 to 175 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]+Strings[3]>'' then
     begin
      If Strings[i+4]='' then Strings[i+4]:=FormatDateTime('yyyy-mm-dd',Now);
     end;
     Tv[172]:=Tv[172]+Tv[i+5];
     Tv[173]:=Tv[173]+Tv[i+6];
     Tv[174]:=Tv[174]+Tv[i+7];
     Tv[175]:=Tv[175]+Tv[i+8];
     Inc(i,9);
   until i>163;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure CalcDetAssetYield(CurVal:Real;Interest:String;PercentCl:Real;PercentSp:Real;
         Var CurValCl:Real;Var CurValSp:Real;
         Var Yield:Real;Var YieldCl:Real;Var YieldSp:Real);
 begin
 CurValCl:=CurVal * PercentCl/100;
 CurValSp:=CurVal * PercentSp/100;
 Yield   :=CurVal * Vl(Interest)/100;
 YieldCl :=CurValCl * Vl(Interest)/100;
 YieldSp :=CurValSp * Vl(Interest)/100;
end;

Procedure Mortgages(RetNo: integer; FName: String;FNo: integer);
Var i,j,ReFNo:Integer; CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  MonthlyPayment:Real;
  FInst,PortfolioType:String;
begin
  FInst:=ExtractFormInst(FName);
  ReFNo:=GetFormNo('REALEST'+FInst);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   //bring from Real Estate
   If ReFNo >0 then
   begin
    i:=1; //mortgagr ndx
    j:=1; //re ndx
    repeat
     Strings[i]:=FetchElmFNo(RetNo,REFNo,j);
     Inc(i,12);
     Inc(j,9);
    until i>253;
   end;

   For i:=265 to 280 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+3]='' then Strings[i+3]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+9]+tv[i+10]+Tv[11]=0 then Tv[i+9]:=100;
       If Tv[i+9]>100 then Tv[i+9]:=100;
       {sp %} If tv[i+10]>100 then Tv[i+10]:=100;
              If tv[i+11]>100 then Tv[i+11]:=100;
              If Tv[i+10]+Tv[i+11]>100 then Tv[i+11]:=0;
              Tv[i+9]:=100-Tv[i+10]-Tv[i+11];
      CurVal:=Tv[i+2];
      Interest:=Strings[i+5];
      PercentCl:=Tv[i+9];
      PercentSp:=Tv[i+10];
      MonthlyPayment:=Tv[i+6];
      CurValCl:=0;CurValSp:=0;
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //Summary
      If i<50 then //homes
      begin
       Tv[265]:=Tv[265]+CurValCl; //cl cur valu
       Tv[269]:=Tv[269]+MonthlyPayment* PercentCl/100;
       Tv[273]:=Tv[273]+CurValSp; //Sp cur valu
       Tv[277]:=Tv[277]+MonthlyPayment* PercentSp/100;
      end;

      If (i>49) and (i<110) then  //vac prop
      begin
       Tv[266]:=Tv[266]+CurValCl; //cl cur valu
       Tv[270]:=Tv[270]+MonthlyPayment* PercentCl/100;
       Tv[274]:=Tv[274]+CurValSp; //Sp cur valu
       Tv[278]:=Tv[278]+MonthlyPayment* PercentSp/100;
      end;

      If (i>109) and (i<254) then  //investm prop
      begin
       Tv[267]:=Tv[267]+CurValCl; //cl cur valu
       Tv[271]:=Tv[271]+MonthlyPayment* PercentCl/100;
       Tv[275]:=Tv[275]+CurValSp; //Sp cur valu
       Tv[279]:=Tv[279]+MonthlyPayment* PercentSp/100;
      end;
     end;
     //Totals
     Tv[268]:=Tv[265]+Tv[266]+Tv[267];
     Tv[272]:=Tv[269]+Tv[270]+Tv[271];
     Tv[276]:=Tv[273]+Tv[274]+Tv[275];
     Tv[280]:=Tv[277]+Tv[278]+Tv[279];
    Inc(i,12);
   until i>253;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure BANKADV(RetNo: integer; FName: String;FNo: integer);
Var i:Integer; CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=161 to 164 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}  //  If Strings[i+3]='' then Strings[i+3]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+6]+tv[i+7]+Tv[i+8]=0 then Tv[i+6]:=100;
       If Tv[i+6]>100 then Tv[i+6]:=100;
       {sp %} If tv[i+7]>100 then Tv[i+7]:=100;
             If tv[i+8]>100 then Tv[i+8]:=100;
             If Tv[i+7]+Tv[i+8]>100 then Tv[i+8]:=0;
             Tv[i+6]:=100-Tv[i+7]-Tv[i+8];
      CurVal:=Tv[i+2];
      //iterest:=Strings[i+9];
      PercentCl:=Tv[i+6];
      PercentSp:=Tv[i+7];
      CurValCl:=0;CurValSp:=0;Yield:=0;//YieldCl:=0;YieldSp:=0;
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //Summary
      Tv[161]:=Tv[161]+CurValCl; //cl cur valu
      Tv[164]:=Tv[164]+CurValSp; //Sp cur valu
     end;
    Inc(i,8);
   until i>153;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure UNPAIDBILLS(RetNo: integer; FName: String;FNo: integer);
Var i:Integer; CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  Yield,YieldCl,YieldSp:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=211 to 212 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+3]='' then Strings[i+3]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+5]+tv[i+6]+Tv[i+7]=0 then Tv[i+5]:=100;
       {sp %} If tv[i+5]>100 then Tv[i+5]:=100;
             If tv[i+6]>100 then Tv[i+6]:=100;
             //If Tv[i+5]+Tv[i+6]>100 then Tv[i+6]:=0;
             Tv[i+5]:=100-Tv[I+6]-Tv[i+7];
      CurVal:=Tv[i+2];
      //terest:=Strings[i+9];
      PercentCl:=Tv[i+5];
      PercentSp:=Tv[i+6];
      CurValCl:=0;CurValSp:=0;Yield:=0;//YieldCl:=0;YieldSp:=0;
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //Summary
      Tv[211]:=Tv[211]+CurValCl; //cl cur valu
      Tv[212]:=Tv[212]+CurValSp; //Sp cur valu
     end;
    Inc(i,7);
   until i>203; //115;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure TaxPayable(RetNo: integer; FName: String;FNo: integer);
Var i:Integer; CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  MonthlyPayment:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=181 to 184 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+4]='' then Strings[i+4]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+8]+tv[i+9]=0 then Tv[i+8]:=100;
       If Tv[i+8]>100 then Tv[i+8]:=100;
       {sp %} If tv[i+9]>100 then Tv[i+9]:=100;
              Tv[i+8]:=100-Tv[i+9];
      CurVal:=Tv[i+3];
      //iterest:=Strings[i+9];
      PercentCl:=Tv[i+8];
      PercentSp:=Tv[i+9];
      MonthlyPayment:=Tv[i+6];
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //Summary
      Tv[181]:=Tv[181]+CurValCl; //cl cur valu
      Tv[182]:=Tv[182]+MonthlyPayment* PercentCl/100;
      Tv[183]:=Tv[183]+CurValSp; //Sp cur valu
      Tv[182]:=Tv[184]+MonthlyPayment* PercentSp/100;
     end;
    Inc(i,9);
   until i>172;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure OtherLtl(RetNo: integer; FName: String;FNo: integer);
Var i:Integer; CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  MonthlyPayment:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=331 to 334 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+3]='' then Strings[i+3]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+9]+tv[i+10]+Tv[i+11]=0 then Tv[i+9]:=100;
       If Tv[i+9]>100 then Tv[i+9]:=100;
       {sp %} If tv[i+10]>100 then Tv[i+10]:=100;
              If tv[i+11]>100 then Tv[i+11]:=100;
              Tv[i+9]:=100-Tv[i+10]-Tv[i+11];
      CurVal:=Tv[i+2];
      //iterest:=Strings[i+9];
      PercentCl:=Tv[i+9];
      PercentSp:=Tv[i+10];
      MonthlyPayment:=Tv[i+6];

      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //Summary
      Tv[331]:=Tv[331]+CurValCl; //cl cur valu
      Tv[333]:=Tv[333]+MonthlyPayment* PercentCl/100;
      Tv[332]:=Tv[332]+CurValSp; //Sp cur valu
      Tv[334]:=Tv[334]+MonthlyPayment* PercentSp/100;
     end;
    Inc(i,11);
   until i>320;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure CarLoans(RetNo: integer; FName: String;FNo: integer);
Var i:Integer; CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  MonthlyPayment:Real;
  PortfolioType:String;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=361 to 364 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+3]='' then Strings[i+3]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+9]+tv[i+10]+Tv[i+11]=0 then Tv[i+9]:=100;
       If Tv[i+9]>100 then Tv[i+9]:=100;
       {sp %} If tv[i+10]>100 then Tv[i+10]:=100;
              If tv[i+11]>100 then Tv[i+11]:=100;
              Tv[i+9]:=100-Tv[i+10]-Tv[i+11];
      CurVal:=Tv[i+2];
      //iterest:=Strings[i+9];
      PercentCl:=Tv[i+9];
      PercentSp:=Tv[i+10];
      MonthlyPayment:=Tv[i+6];
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //Summary
      Tv[361]:=Tv[361]+CurValCl; //cl cur valu
      Tv[362]:=Tv[362]+MonthlyPayment* PercentCl/100;
      Tv[363]:=Tv[363]+CurValSp; //Sp cur valu
      Tv[364]:=Tv[364]+MonthlyPayment* PercentSp/100;
     end;
    Inc(i,12);
   until i>349;
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure CreditCards(RetNo: integer; FName: String;FNo: integer);
Var i:Integer; CurVal,CurValCl,CurValSp:Real;
  Interest:String;PercentCl,PercentSp:Real;
  MonthlyPayment:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   For i:=225 to 228 do Tv[i]:=0;
   i:=0;  //current value
   Repeat
     If Strings[i+1]+Strings[i+2]>'' then
     begin
      {asof date}    If Strings[i+4]='' then Strings[i+4]:=FormatDateTime('yyyy-mm-dd',Now);
      {percent}
       If Tv[i+6]+tv[i+7]+Tv[i+8]=0 then Tv[i+6]:=100;
       If Tv[i+6]>100 then Tv[i+6]:=100;
       {sp %} If tv[i+7]>100 then Tv[i+7]:=100;
              If tv[i+8]>100 then Tv[i+8]:=100;
              If Tv[i+7]+Tv[i+8]>100 then Tv[i+8]:=0;
              Tv[i+6]:=100-Tv[i+7]-Tv[i+8];
      CurVal:=Tv[i+3];
      //iterest:=Strings[i+9];
      PercentCl:=Tv[i+6];
      PercentSp:=Tv[i+7];
      MonthlyPayment:=Tv[i+5];
      CurValCl:=CurVal * PercentCl/100;
      CurValSp:=CurVal * PercentSp/100;
      //Summary
      Tv[225]:=Tv[225]+CurValCl; //cl cur valu
      Tv[226]:=Tv[226]+MonthlyPayment* PercentCl/100;
      Tv[227]:=Tv[227]+CurValSp; //Sp cur valu
      Tv[228]:=Tv[228]+MonthlyPayment* PercentSp/100;
     end;
    Inc(i,8);
   until i>217;
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure PORTFOLIO(RetNo: integer; FName: String;FNo: integer);
Var i,years:Integer;
 TotInvest,InitialInvestment,Percent,GainPercent,TotalAllocatedAmount,TotalAllocatedPercent,
 FutureVal,RateOfReturn,TotalFutureValue,TotalGainPercent:Real;
 MFundsMastRec: TMFundsMastRec;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   TotInvest:=Tv[4];
   Years:=MyStrToInt(Strings[5]);
   TotalAllocatedAmount:=0;
   TotalAllocatedPercent:=0;
   TotalFutureValue:=0;
   TotalGainPercent:=0;
   If Strings[5]='' then strings[5]:='5';
   i:=0;
   Repeat
    If Strings[I+6]='MutualFunds' then
    begin
      If GetMFundsMasterData(Strings[i+7],MFundsMastRec) = True then
         Strings[i+9]:=MFundsMastRec.FundName;
    end;
    Percent:=Tv[i+10];
    RateOfReturn:=Vl(Strings[i+12]);
    InitialInvestment:= TotInvest * Percent/100;
    FutureVal:=FutureValue(InitialInvestment,RateOfReturn,years);
    If InitialInvestment >0 then
     GainPercent:= Round(100 * (FutureVal-InitialInvestment)/InitialInvestment)
    else
     GainPercent:=0;

    Tv[i+11]:=InitialInvestment;
    Tv[i+13]:=FutureVal;
    Tv[i+14]:=GainPercent;
    TotalAllocatedAmount := TotalAllocatedAmount+InitialInvestment;
    TotalAllocatedPercent := TotalAllocatedPercent+Percent;
    TotalGainPercent := TotalGainPercent+GainPercent;
    TotalFutureValue := TotalFutureValue+FutureVal;
    Inc(i,10);
   until i>296;
   Tv[306]:=TotalAllocatedPercent;
   Tv[307]:=TotalAllocatedAmount;
   Tv[309]:=TotalFutureValue;
   Tv[310]:=TotalGainPercent;
  end;
  SaveTv(RetNo,FName,FNo);
end;


Procedure GENPLAN(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure SPECIFICPLAN(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure Accounts(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure PROJECTIONCharts(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   FillHeader(RetNo,FNo,2,1);
   //Strings[1]:=GetRetName(RetNo);
   //Strings[2]:=FormatDateTime('yyyy-mm-dd',Date);
   If Strings[3]+Strings[4]='' then Strings[3]:='X';
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure PreAssetSum(RetNo: integer; FName: String; FNo: integer);//20170408 Igor
var
  frm: TvtScrollBox;
begin
  frm := Ret[RetNo].MyChild.GetForm(FNo, False);
  if frm <> nil then
    AssetSum(RetNo, FName, FNo, frm);
end;
//20170408 Igor>>>
procedure AssetSum(RetNo: integer; FName: string; FNo: integer; MyComponent: TComponent);
type
  TLabelSeting = record
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
    FontSize: Integer;
  end;
  TLabelSettings = Array[0..6] of TLabelSeting;
const
  MxInst = 5;
var
  Inst, NetWFNo: Integer;
  FInst: string;
  i, j, f, CompCount: Integer;
  MyLabel: TvtLabel;
  MyEdit: TvtEdit;
  MyPageBreak: TvtShape;
  MyScrollBox: TvtScrollbox;
  MyTForm: TForm;
  assetFormArray: array of string;
  Supplier, OrigCost, Units, AssetType, Account, Description, CurrentVal: string;
  RealCurrentVal, AssetTypeTotal, AssetTotal: Real;
  IncAmount, CurrentLineNumber, PageNumber, FieldTotal: Integer;
  C: TComponent;
  LabelBounds: TLabelSettings;
  SelfComponentCount: Integer;
const
  c_DynLabelTag: Integer = -999;

procedure InitLabelBounds(const Form: TWinControl; const ATextHeight: Integer);
  procedure DoInit(AIndex: Integer; ALabelName: String;
    DefLeft, DefTop, DefWidth, DefHeight, DefFontSize: Integer);
  var
    L: TvtLabel;
  begin
    L := Form.FindComponent(ALabelName) as TvtLabel;
    with LabelBounds[AIndex] do
      if L <> nil then
      begin
        Left := L.Left;
        Top := L.Top + L.Height;
        Width := L.Width;
        Height := ATextHeight + 4;
        FontSize := (L as TvtLabel).Font.Size;
      end
      else
      begin
        Left := DefLeft;
        Top := DefTop;
        Width := DefWidth;
        Height := DefHeight;
        FontSize := DefFontSize;
      end;
  end;
begin
  DoInit(0, 'vtLabel17', 7, 71, 78, 14, 7);
  DoInit(1, 'vtLabel16', 84, 71, 183, 14, 7);
  DoInit(2, 'vtLabel20', 266, 71, 64, 14, 7);
  DoInit(3, 'vtLabel26', 329, 71, 85, 14, 7);
  DoInit(4, 'vtLabel22', 413, 71, 78, 14, 7);
  DoInit(5, 'vtLabel23', 490, 71, 36, 14, 7);
  DoInit(6, 'vtLabel3', 525, 71, 85, 14, 7);
end;

begin
{$REGION 'PREPARE'}
  formatSettings.DecimalSeparator := '.';


  if MyComponent is TvtScrollbox then
  begin
    MyScrollBox := MyComponent as TvtScrollbox;
    for I := 0 to MyScrollBox.ComponentCount - 1 do
      if MyScrollBox.Components[I].Tag = c_DynLabelTag then
      Begin
        SelfComponentCount := I;
        While MyScrollBox.ComponentCount > SelfComponentCount do
          MyScrollBox.Components[SelfComponentCount].Free;
        break;
      end;
    InitLabelBounds(MyScrollBox, MyScrollBox.TextHeight)
  end
  else if MyComponent is TForm then
  begin
    MyTForm := MyComponent as TForm;
    MyTForm.Color := GetRetColor(RetNo);
    for I := 0 to MyTForm.ComponentCount - 1 do
      if MyTForm.Components[I].Tag = c_DynLabelTag then
      Begin
        SelfComponentCount := I;
        While MyTForm.ComponentCount > SelfComponentCount do
          MyTForm.Components[SelfComponentCount].Free;
        break;
      end;
    InitLabelBounds(MyTForm, MyTForm.Canvas.TextHeight('H'));
  end;


  NetWFNo := GetFormNo('NETWORTH');

  setLength(assetFormArray, 14);
  assetFormArray[0] := 'CASH';
  assetFormArray[1] := 'CSB';
  assetFormArray[2] := 'GIC';
  assetFormArray[3] := 'BONDS';
  assetFormArray[4] := 'LOANS';
  assetFormArray[5] := 'TERMDEP';
  assetFormArray[6] := 'MUTFUNDS';
  assetFormArray[7] := 'STOCKS';
  assetFormArray[8] := 'DEFPLANS';
  assetFormArray[9] := 'REALEST';
  assetFormArray[10] := 'AUTOS';
  assetFormArray[11] := 'BUSINESS';
  assetFormArray[12] := 'OTHFIXED';
  assetFormArray[13] := 'OTHASSETS';
{$ENDREGION 'PREPARE'}

  if vl(FetchElmFNo(RetNo, NetWFNo, 41)) > 0 then
  begin
    CurrentLineNumber := 0;
    PageNumber := 1;
    AssetTotal := 0;
    for f := low(assetFormArray) to high(assetFormArray) do
    begin
{$REGION 'BODY'}
      AssetTypeTotal := 0;
      for Inst := 1 to MxInst do
      begin
        FInst := '#' + AllTrim(IntToStr(Inst));
        FNo := GetFormNo(assetFormArray[f] + FInst);
        if Ret[RetNo].FrmHasData[FNo] then
        begin
          i := 1;
          repeat
           //Start Cash--------------------------------------------------------
{$REGION 'MATH'}
            if assetFormArray[f] = 'CASH' then
            begin
              IncAmount := 9;
              FieldTotal := 270;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 2));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Cash' + ' ';
                  case j of
                    0:
                      Account := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    3..8:
                      begin
                        Supplier := '';
                        OrigCost := '';
                        Units := '';
                      end;
                  end;
                end;
              end;
            end
       //End Cash--------------------------------------------------------
       //Start CSB--------------------------------------------------------
            else if assetFormArray[f] = 'CSB' then
            begin
              IncAmount := 15;
              FieldTotal := 450;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 4));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'CSB' + ' ';
                  case j of
                    0:
                      Account := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                    5..8:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                  end;
                end;
              end;
            end
       //End CSB--------------------------------------------------------
       //Start GIC--------------------------------------------------------
            else if assetFormArray[f] = 'GIC' then
            begin
              IncAmount := 15;
              FieldTotal := 450;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 4));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'GIC' + ' ';
                  case j of
                    0:
                      Account := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                    5..8:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                  end;
                end;
              end;
            end
       //End GIC--------------------------------------------------------
       //Start BONDS--------------------------------------------------------
            else if assetFormArray[f] = 'BONDS' then
            begin
              IncAmount := 15;
              FieldTotal := 450;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 4));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Bonds' + ' ';
                  case j of
                    0:
                      Account := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                    5..8:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                  end;
                end;
              end;
            end
       //End BONDS--------------------------------------------------------
       //Start LOANS--------------------------------------------------------
            else if assetFormArray[f] = 'LOANS' then
            begin
              IncAmount := 10;
              FieldTotal := 300;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 2));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Loans' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    3..8:
                      begin
                        Account := '';
                        Supplier := '';
                        Units := '';
                      end;
                  end;
                end;
              end;
            end
       //End LOANS--------------------------------------------------------
       //Start TERMDEP--------------------------------------------------------
            else if assetFormArray[f] = 'TERMDEP' then
            begin
              IncAmount := 15;
              FieldTotal := 420;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 4));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Term Deposits' + ' ';
                  case j of
                    0:
                      Account := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                    5..8:
                      begin
                        Supplier := '';
                        Units := '';
                      end;
                  end;
                end;
              end;
            end
       //END TERMDEP--------------------------------------------------------
       //Start MUTFUNDS--------------------------------------------------------
            else if assetFormArray[f] = 'MUTFUNDS' then
            begin
              IncAmount := 18;
              FieldTotal := 504;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 6));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Mutual Funds' + ' ';
                  case j of
                    0:
                      Account := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      Units := FetchElmFNo(RetNo, FNo, i + j);
                    6:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    1, 8:
                      begin
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end
       //END MUTFUNDS--------------------------------------------------------
       //Start STOCKS--------------------------------------------------------
            else if assetFormArray[f] = 'STOCKS' then
            begin
              IncAmount := 16;
              FieldTotal := 480;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 6));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Stocks' + ' ';
                  case j of
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      Units := FetchElmFNo(RetNo, FNo, i + j);
                    6:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    0, 2, 5, 7, 8:
                      begin
                        Account := '';
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end
       //End STOCKS--------------------------------------------------------
       //Start DEFPLANS--------------------------------------------------------
            else if assetFormArray[f] = 'DEFPLANS' then
            begin
              IncAmount := 11;
              FieldTotal := 330;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 2));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Deffered Plans' + ' ';
                  case j of
                    0:
                      Account := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    3..8:
                      begin
                        OrigCost := '';
                        Units := '';
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end
       //End DEFPLANS--------------------------------------------------------
       //Start REALEST--------------------------------------------------------
            else if assetFormArray[f] = 'REALEST' then
            begin
              IncAmount := 9;
              FieldTotal := 234;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 3));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Real Estate' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    1, 4..8:
                      begin
                        Account := '';
                        Units := '';
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end
       //End REALEST--------------------------------------------------------
       //Start AUTOS--------------------------------------------------------
            else if assetFormArray[f] = 'AUTOS' then
            begin
              IncAmount := 8;
              FieldTotal := 216;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 3));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Autos' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    1, 4..8:
                      begin
                        Account := '';
                        Units := '';
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end
       //End AUTOS--------------------------------------------------------
       //Start BUSINESS--------------------------------------------------------
            else if assetFormArray[f] = 'BUSINESS' then
            begin
              IncAmount := 9;
              FieldTotal := 126;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 3));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Business' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    1, 4..8:
                      begin
                        Account := '';
                        Units := '';
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end
       //End BUSINESS--------------------------------------------------------
       //Start OTHFIXED--------------------------------------------------------
            else if assetFormArray[f] = 'OTHFIXED' then
            begin
              IncAmount := 10;
              FieldTotal := 270;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 3));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Other Fixed Assets' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    1, 4..8:
                      begin
                        Account := '';
                        Units := '';
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end
       //End OTHFIXED--------------------------------------------------------
       //End OTHASSETS--------------------------------------------------------
            else if assetFormArray[f] = 'OTHASSETS' then
            begin
              IncAmount := 10;
              FieldTotal := 270;
              RealCurrentVal := vl(FetchElmFNo(RetNo, FNo, i + 3));
              if RealCurrentVal > 0 then
              begin
                AssetTypeTotal := AssetTypeTotal + RealCurrentVal;
                for j := 0 to 8 do
                begin
                  AssetType := 'Other Assets' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      OrigCost := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      CurrentVal := FetchElmFNo(RetNo, FNo, i + j);
                    1, 4..8:
                      begin
                        Account := '';
                        Units := '';
                        Supplier := '';
                      end;
                  end;
                end;
              end;
            end;
       //End OTHASSETS--------------------------------------------------------
{$ENDREGION 'MATH'}
{$REGION 'GUI'}
            if RealCurrentVal > 0 then
            begin
              for j := 0 to 6 do
              begin

                if MyComponent is TvtScrollbox then
                  MyLabel := TvtLabel.Create(MyScrollBox)
                else if MyComponent is TForm then
                  MyLabel := TvtLabel.Create(MyTForm);

                with MyLabel do
                begin
                  Tag := c_DynLabelTag;

                  if MyComponent is TvtScrollbox then
                    Parent := MyScrollBox
                  else if MyComponent is TForm then
                    Parent := MyTForm;

                  AutoSize := false;
                  SetBounds(LabelBounds[j].Left, LabelBounds[j].Top + CurrentLineNumber * LabelBounds[j].Height,
                          LabelBounds[j].Width,  LabelBounds[j].Height);

                  case j of
                    0:
                      begin
                        Caption := ' ' + AssetType;
//                        Width := 78;
//                        Left := 7;
                        Alignment := taLeftJustify;
                      end;
                    1:
                      begin
                        Caption := ' ' + Description;
//                        Width := 183;
//                        Left := 84;
                        Alignment := taLeftJustify;
                      end;
                    2:
                      begin
                        Caption := ' ' + Account;
//                        Width := 64;
//                        Left := 266;
                        Alignment := taLeftJustify;
                      end;
                    3:
                      begin
                        Caption := ' ' + Supplier;
//                        Width := 85;
//                        Left := 329;
                        Alignment := taLeftJustify;
                      end;
                    4:
                      begin
                        if OrigCost = '' then
                          Caption := ' '
                        else
                          Caption := FormatFloat('###,###,###.00', Vl(OrigCost)) + ' ';
//                        Width := 78;
//                        Left := 413;
                        Alignment := taRightJustify;
                      end;
                    5:
                      begin
                        Caption := Units + ' ';
//                        Width := 36;
//                        Left := 490;
                        Alignment := taRightJustify;
                      end;
                    6:
                      begin
                        CurrentVal := FormatFloat('###,###,###.00', Vl(CurrentVal)) + ' ';
                        Caption := CurrentVal;
//                        Width := 85;
//                        Left := 525;
                        Alignment := taRightJustify;
                      end;
                  end;
                  Name := 'DynamicField' + IntToStr(CurrentLineNumber) + IntToStr(j);
//                  Height := 14;
//                  Top := 71 + (14 * CurrentLineNumber);
//                  AutoSize := false;
                  Transparent := False;
                  vtTransparent := False;
                  Color := clWhite;
                  vtBorderType := vtlblFull;
                  vtIsPrintable := True;
                  Font.Name := 'Times New Roman';
                  Font.Size := LabelBounds[j].FontSize;
                  BringToFront;
                end;
              end;
              Inc(CurrentLineNumber, 1);

              if (MyLabel.Top + MyLabel.Height) > (920 * PageNumber) then
              begin
                if MyComponent is TvtScrollbox then
                  MyPageBreak := TvtShape.Create(MyScrollBox)
                else if MyComponent is TForm then
                  MyPageBreak := TvtShape.Create(MyTForm);

                if MyComponent is TvtScrollbox then
                  MyPageBreak.Parent := MyScrollBox
                else if MyComponent is TForm then
                  MyPageBreak.Parent := MyTForm;
                MyPageBreak.Tag := c_DynLabelTag;
                MyPageBreak.vtPageBreak := True;
                MyPageBreak.Top := MyLabel.Top + MyLabel.Height + 5;
                MyPageBreak.Pen.Color := clBlack;
                MyPageBreak.Pen.Style := psSolid;
                MyPageBreak.Pen.Width := 5;
                Inc(CurrentLineNumber, 3);
                CurrentLineNumber := CurrentLineNumber + 1;
                Inc(PageNumber, 1)
              end;

            end;
{$ENDREGION 'GUI'}
            Inc(i, IncAmount);
          until i > FieldTotal;
        end;
      end; //inst
   //after all done
{$ENDREGION 'BODY'}

{$REGION 'TOTAL'}
      if AssetTypeTotal > 0 then
      begin
    //FNo:=GetFormNo(assetFormArray[f] + '#1');
        AssetTotal := AssetTotal + AssetTypeTotal;
        if MyComponent is TvtScrollbox then
          MyLabel := TvtLabel.Create(MyScrollBox)
        else if MyComponent is TForm then
          MyLabel := TvtLabel.Create(MyTForm);

        with MyLabel do
        begin
          Tag := c_DynLabelTag;
          if MyComponent is TvtScrollbox then
            Parent := MyScrollBox
          else if MyComponent is TForm then
            Parent := MyTForm;

          Name := 'DynamicFieldTotal' + IntToStr(CurrentLineNumber) + IntToStr(j);
          Caption := FormatFloat('###,###,###.00', AssetTypeTotal) + ' ';
      //Caption := FormatAmount('',FloatToStr(AssetTypeTotal),2) + ' ';
          AutoSize := false;
          SetBounds(LabelBounds[High(LabelBounds)].Left,
            LabelBounds[High(LabelBounds)].Top + CurrentLineNumber * LabelBounds[High(LabelBounds)].Height,
            LabelBounds[High(LabelBounds)].Width,  LabelBounds[High(LabelBounds)].Height);
//          Width := 85;
//          Left := 525;
          Alignment := taRightJustify;
//          Height := 14;
      //Inc(CurrentLineNumber,1);
//          Top := 71 + (14 * CurrentLineNumber);
          Transparent := False;
          vtTransparent := False;
          Color := clWhite;
          vtBorderType := vtlblFull;
          vtIsPrintable := True;
          Font.Name := 'Times New Roman';
          Font.Size := LabelBounds[High(LabelBounds)].FontSize;
          BringToFront;
        end;
        Inc(CurrentLineNumber, 2)

      end;
{$ENDREGION 'TOTAL'}
    end;
  end; //end for assetform

{$REGION 'TOTAL_ALL'}
  if AssetTotal > 0 then
  begin
    if MyComponent is TvtScrollbox then
      MyLabel := TvtLabel.Create(MyScrollBox)
    else if MyComponent is TForm then
      MyLabel := TvtLabel.Create(MyTForm);
    with MyLabel do
    begin
      Tag := c_DynLabelTag;
      if MyComponent is TvtScrollbox then
        Parent := MyScrollBox
      else if MyComponent is TForm then
        Parent := MyTForm;

      Caption := FormatFloat('###,###,###.00', AssetTotal) + ' ';
      AutoSize := false;
      SetBounds(LabelBounds[High(LabelBounds)].Left - 20,
        LabelBounds[High(LabelBounds)].Top + CurrentLineNumber * LabelBounds[High(LabelBounds)].Height,
        LabelBounds[High(LabelBounds)].Width + 20,  LabelBounds[High(LabelBounds)].Height);
//      Width := 120;
//      Left := 490;
      Alignment := taRightJustify;
//      Height := 14;
//      Top := 71 + (14 * CurrentLineNumber);
//      AutoSize := false;
      Transparent := False;
      vtTransparent := False;
      Color := clWhite;
      vtBorderType := vtlblFull;
      vtIsPrintable := True;
      Font.Name := 'Times New Roman';
      Font.Size := LabelBounds[6].FontSize;
      BringToFront;
    end;

    if MyComponent is TvtScrollbox then
      MyPageBreak := TvtShape.Create(MyScrollBox)
    else if MyComponent is TForm then
      MyPageBreak := TvtShape.Create(MyTForm);

    if MyComponent is TvtScrollbox then
      MyPageBreak.Parent := MyScrollBox
    else if MyComponent is TForm then
      MyPageBreak.Parent := MyTForm;
    MyPageBreak.Tag := c_DynLabelTag;
    MyPageBreak.vtPageBreak := True;
    MyPageBreak.Top := 920 * PageNumber;
    MyPageBreak.Pen.Color := clBlack;
    MyPageBreak.Pen.Style := psSolid;
    MyPageBreak.Pen.Width := 5;
  end;
{$ENDREGION 'TOTAL_ALL'}

end;
//20170408 Igor <<<
Procedure PreLiabSum(RetNo: integer; FName: String; FNo: integer);//20170408 Igor
var
  frm: TvtScrollBox;
begin
  frm := Ret[RetNo].MyChild.GetForm(FNo, False);
  if frm <> nil then
    LiabSum(RetNo, FName, FNo, frm);
end;
//20170408 Igor >>>
procedure LiabSum(RetNo: integer; FName: string; FNo: integer; MyComponent: TComponent);
type
  TLabelSeting = record
    Left: Integer;
    Top: Integer;
    Width: Integer;
    Height: Integer;
    FontSize: Integer;
  end;
  TLabelSettings = Array[0..5] of TLabelSeting;
const
  MxInst = 5;
var
  Inst, NetWFNo: Integer;
  FInst: string;
  i, j, f: Integer;
  MyLabel: TvtLabel;
  MyEdit: TvtEdit;
  MyShape: TvtShape;
  MyPageBreak: TvtShape;
  MyScrollBox: TvtScrollbox;
  MyTForm: TForm;
  LiabFormArray: array of string;
  Interest, MonthlyPayment, LiabType, CreditCard, Description, BalanceOwing: string;
  RealBalanceOwing, LiabTypeTotal, LiabTotal: Real;
  IncAmount, CurrentLineNumber, PageNumber, FieldTotal: Integer;

  C: TComponent;
  LabelBounds: TLabelSettings;
  SelfComponentCount: Integer;
const
  c_DynLabelTag: Integer = -999;

procedure InitLabelBounds(const Form: TWinControl; const ATextHeight: Integer);
  procedure DoInit(AIndex: Integer; ALabelName: String;
    DefLeft, DefTop, DefWidth, DefHeight, DefFontSize: Integer);
  var
    L: TvtLabel;
  begin
    L := Form.FindComponent(ALabelName) as TvtLabel;
    with LabelBounds[AIndex] do
      if L <> nil then
      begin
        Left := L.Left;
        Top := L.Top + L.Height;
        Width := L.Width;
        Height := ATextHeight + 4;
        FontSize := (L as TvtLabel).Font.Size;
      end
      else
      begin
        Left := DefLeft;
        Top := DefTop;
        Width := DefWidth;
        Height := DefHeight;
        FontSize := DefFontSize;
      end;
  end;
begin
  DoInit(0, 'vtLabel17', 7, 71, 78, 14, 7);
  DoInit(1, 'vtLabel16', 84, 71, 183, 14, 7);
  DoInit(2, 'vtLabel20', 266, 71, 64, 14, 7);
  DoInit(3, 'vtLabel26', 329, 71, 71, 14, 7);
  DoInit(4, 'vtLabel22', 399, 71, 92, 14, 7);
  DoInit(5, 'vtLabel3', 490, 71, 120, 14, 7);
end;


begin
{$REGION 'PREPARE'}
  FormatSettings.DecimalSeparator := '.';
  if MyComponent is TvtScrollbox then
  Begin
    MyScrollBox := MyComponent as TvtScrollbox;
    for I := 0 to MyScrollBox.ComponentCount - 1 do
      if MyScrollBox.Components[I].Tag = c_DynLabelTag then
      Begin
        SelfComponentCount := I;
        While MyScrollBox.ComponentCount > SelfComponentCount do
          MyScrollBox.Components[SelfComponentCount].Free;
        break;
      end;
    InitLabelBounds(MyScrollBox, MyScrollBox.TextHeight)
  end
  else if MyComponent is TForm then
  Begin
    MyTForm := MyComponent as TForm;
    for I := 0 to MyTForm.ComponentCount - 1 do
      if MyTForm.Components[I].Tag = c_DynLabelTag then
      Begin
        SelfComponentCount := I;
        While MyTForm.ComponentCount > SelfComponentCount do
          MyTForm.Components[SelfComponentCount].Free;
        break;
      end;
    InitLabelBounds(MyTForm, MyTForm.Canvas.TextHeight('H'));
  end;
  NetWFNo := GetFormNo('NETWORTH');

  setLength(LiabFormArray, 7);
  LiabFormArray[0] := 'UNPAIDBILLS';
  LiabFormArray[1] := 'BANKADV';
  LiabFormArray[2] := 'CREDITCARDS';
  LiabFormArray[3] := 'TAXPAYABLE';
  LiabFormArray[4] := 'CARLOANS';
  LiabFormArray[5] := 'MORTGAGES';
  LiabFormArray[6] := 'OTHERLTL';
{$ENDREGION 'PREPARE'}

  if vl(FetchElmFNo(RetNo, NetWFNo, 41)) > 0 then
  begin
{$REGION 'BODY'}
    CurrentLineNumber := 0;
    PageNumber := 1;
    LiabTotal := 0;

    for f := low(LiabFormArray) to high(LiabFormArray) do
    begin
      LiabTypeTotal := 0;
      for Inst := 1 to MxInst do
      begin
        FInst := '#' + AllTrim(IntToStr(Inst));
        FNo := GetFormNo(LiabFormArray[f] + FInst);
        if Ret[RetNo].FrmHasData[FNo] then
        begin
          i := 1;
          repeat
{$REGION 'MATH'}
       //Start UNPAIDBILLS--------------------------------------------------------
            if LiabFormArray[f] = 'UNPAIDBILLS' then
            begin
              IncAmount := 7;
              FieldTotal := 210;
              RealBalanceOwing := vl(FetchElmFNo(RetNo, FNo, i + 1));
              if RealBalanceOwing > 0 then
              begin
                LiabTypeTotal := LiabTypeTotal + RealBalanceOwing;
                for j := 0 to 4 do
                begin
                  LiabType := 'Unpaid Bills' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      BalanceOwing := FetchElmFNo(RetNo, FNo, i + j);
                    2..4:
                      begin
                        Interest := '';
                        MonthlyPayment := '';
                        CreditCard := '';
                      end;
                  end;
                end;
              end;
            end;
       //End UNPAIDBILLS--------------------------------------------------------
       //Start Bank Advances--------------------------------------------------------
            if LiabFormArray[f] = 'BANKADV' then
            begin
              IncAmount := 8;
              FieldTotal := 160;
              RealBalanceOwing := vl(FetchElmFNo(RetNo, FNo, i + 1));
              if RealBalanceOwing > 0 then
              begin
                LiabTypeTotal := LiabTypeTotal + RealBalanceOwing;
                for j := 0 to 4 do
                begin
                  LiabType := 'Bank Advances' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      BalanceOwing := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      Interest := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      MonthlyPayment := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      begin
                        CreditCard := '';
                      end;
                  end;
                end;
              end;
            end;
       //End Bank Advances--------------------------------------------------------
       //Start CREDITCARDS--------------------------------------------------------
            if LiabFormArray[f] = 'CREDITCARDS' then
            begin
              IncAmount := 8;
              FieldTotal := 224;
              RealBalanceOwing := vl(FetchElmFNo(RetNo, FNo, i + 2));
              if RealBalanceOwing > 0 then
              begin
                LiabTypeTotal := LiabTypeTotal + RealBalanceOwing;
                for j := 0 to 4 do
                begin
                  LiabType := 'Credit Cards' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      CreditCard := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      BalanceOwing := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      Interest := FetchElmFNo(RetNo, FNo, i + j);
                    4:
                      MonthlyPayment := FetchElmFNo(RetNo, FNo, i + j);
                  end;
                end;
              end;
            end;
       //End CREDITCARDS--------------------------------------------------------
       //Start TAXPAYABLE--------------------------------------------------------
            if LiabFormArray[f] = 'TAXPAYABLE' then
            begin
              IncAmount := 9;
              FieldTotal := 180;
              RealBalanceOwing := vl(FetchElmFNo(RetNo, FNo, i + 2));
              if RealBalanceOwing > 0 then
              begin
                LiabTypeTotal := LiabTypeTotal + RealBalanceOwing;
                for j := 0 to 4 do
                begin
                  LiabType := 'Tax Payable' + ' ';
                  case j of
                    1:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      BalanceOwing := FetchElmFNo(RetNo, FNo, i + j);
                    3:
                      Interest := FetchElmFNo(RetNo, FNo, i + j + 1); //add 1 to get to proper field
                    4:
                      MonthlyPayment := FetchElmFNo(RetNo, FNo, i + j + 1); //add 1 to get to proper field
                    0:
                      begin
                        CreditCard := '';
                      end;
                  end;
                end;
              end;
            end;
       //End TAXPAYABLE--------------------------------------------------------
       //Start CARLOANS--------------------------------------------------------
            if LiabFormArray[f] = 'CARLOANS' then
            begin
              IncAmount := 12;
              FieldTotal := 359;
              RealBalanceOwing := vl(FetchElmFNo(RetNo, FNo, i + 1));
              if RealBalanceOwing > 0 then
              begin
                LiabTypeTotal := LiabTypeTotal + RealBalanceOwing;
                for j := 0 to 4 do
                begin
                  LiabType := 'Car Loans' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      BalanceOwing := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      Interest := FetchElmFNo(RetNo, FNo, i + j + 2); //add 2 to get to proper field
                    3:
                      MonthlyPayment := FetchElmFNo(RetNo, FNo, i + j + 2); //add 2 to get to proper field
                    4:
                      begin
                        CreditCard := '';
                      end;
                  end;
                end;
              end;
            end;
       //End CARLOANS--------------------------------------------------------
       //Start MORTGAGES--------------------------------------------------------
            if LiabFormArray[f] = 'MORTGAGES' then
            begin
              IncAmount := 12;
              FieldTotal := 264;
              RealBalanceOwing := vl(FetchElmFNo(RetNo, FNo, i + 1));
              if RealBalanceOwing > 0 then
              begin
                LiabTypeTotal := LiabTypeTotal + RealBalanceOwing;
                for j := 0 to 4 do
                begin
                  LiabType := 'Mortgages' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      BalanceOwing := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      Interest := FetchElmFNo(RetNo, FNo, i + j + 2);
                    3:
                      MonthlyPayment := FetchElmFNo(RetNo, FNo, i + j + 2);
                    4:
                      begin
                        CreditCard := '';
                      end;
                  end;
                end;
              end;
            end;
       //End MORTGAGES--------------------------------------------------------
       //Start OTHERLTL--------------------------------------------------------
            if LiabFormArray[f] = 'OTHERLTL' then
            begin
              IncAmount := 11;
              FieldTotal := 330;
              RealBalanceOwing := vl(FetchElmFNo(RetNo, FNo, i + 1));
              if RealBalanceOwing > 0 then
              begin
                LiabTypeTotal := LiabTypeTotal + RealBalanceOwing;
                for j := 0 to 4 do
                begin
                  LiabType := 'Other' + ' ';
                  case j of
                    0:
                      Description := FetchElmFNo(RetNo, FNo, i + j);
                    1:
                      BalanceOwing := FetchElmFNo(RetNo, FNo, i + j);
                    2:
                      Interest := FetchElmFNo(RetNo, FNo, i + j + 2);
                    3:
                      MonthlyPayment := FetchElmFNo(RetNo, FNo, i + j + 2);
                    4:
                      begin
                        CreditCard := '';
                      end;
                  end;
                end;
              end;
            end;
       //End OTHERLTL--------------------------------------------------------
{$ENDREGION 'MATH'}
{$REGION 'GUI'}
            if RealBalanceOwing > 0 then
            begin
              for j := 0 to 5 do
              begin

                if MyComponent is TvtScrollbox then
                  MyLabel := TvtLabel.Create(MyScrollBox)
                else if MyComponent is TForm then
                  MyLabel := TvtLabel.Create(MyTForm);

                with MyLabel do
                begin
                  Tag := c_DynLabelTag;
                  if MyComponent is TvtScrollbox then
                    Parent := MyScrollBox
                  else if MyComponent is TForm then
                    Parent := MyTForm;
                  AutoSize := false;
                  SetBounds(LabelBounds[j].Left, LabelBounds[j].Top + CurrentLineNumber * LabelBounds[j].Height,
                          LabelBounds[j].Width,  LabelBounds[j].Height);
                  case j of
                    0:
                      begin
                        Caption := ' ' + LiabType;
//                        Width := 78;
//                        Left := 7;
                        Alignment := taLeftJustify;
                      end;
                    1:
                      begin
                        Caption := ' ' + Description;
//                        Width := 183;
//                        Left := 84;
                        Alignment := taLeftJustify;
                      end;
                    2:
                      begin
                        Caption := ' ' + CreditCard;
//                        Width := 64;
//                        Left := 266;
                        Alignment := taLeftJustify;
                      end;
                    3:
                      begin
                        Caption := Interest + ' ';
//                        Width := 71;
//                        Left := 329;
                        Alignment := taRightJustify;
                      end;
                    4:
                      begin
                        if MonthlyPayment = '' then
                          Caption := ' '
                        else
                          Caption := FormatFloat('###,###,###.00', Vl(MonthlyPayment)) + ' ';
//                        Width := 92;
//                        Left := 399;
                        Alignment := taRightJustify;
                      end;
                    5:
                      begin
                        BalanceOwing := FormatFloat('###,###,###.00', Vl(BalanceOwing)) + ' ';
                        Caption := BalanceOwing;
//                        Width := 120;
//                        Left := 490;
                        Alignment := taRightJustify;
                      end;
                  end;
                  Name := 'LiabSumDynamicField' + IntToStr(CurrentLineNumber) + IntToStr(j);
//                  Height := 14;
//                  Top := 71 + (14 * CurrentLineNumber);
                  Transparent := False;
                  vtTransparent := False;
                  Color := clWhite;
                  vtBorderType := vtlblFull;
                  vtIsPrintable := True;
                  Font.Name := 'Times New Roman';
                  Font.Size := LabelBounds[j].FontSize;
                  BringToFront;
                end;
              end;
              Inc(CurrentLineNumber, 1);

       //moved below
       //end;
       //Inc(i,IncAmount);

              if MyLabel.Top > (920 * PageNumber) then
              begin
                if MyComponent is TvtScrollbox then
                  MyPageBreak := TvtShape.Create(MyScrollBox)
                else if MyComponent is TForm then
                  MyPageBreak := TvtShape.Create(MyTForm);
                MyPageBreak.Tag := c_DynLabelTag;
                if MyComponent is TvtScrollbox then
                  MyPageBreak.Parent := MyScrollBox
                else if MyComponent is TForm then
                  MyPageBreak.Parent := MyTForm;

                MyPageBreak.vtPageBreak := True;
//                MyPageBreak.vtPageBreak := false;

                MyPageBreak.Top := MyLabel.Top + MyLabel.Height + 5;
                MyPageBreak.Pen.Color := clBlack;
                MyPageBreak.Pen.Style := psSolid;
                MyPageBreak.Pen.Width := 5;
                Inc(CurrentLineNumber, 3);
                CurrentLineNumber := CurrentLineNumber + 1;
                Inc(PageNumber, 1)
              end;

            end; //20110228
{$ENDREGION 'GUI'}
            Inc(i, IncAmount);
          until i > FieldTotal;
        end;
      end; //inst
   //after all done
{$ENDREGION 'BODY'}
{$REGION 'TOTAL'}
      if LiabTypeTotal > 0 then
      begin
        LiabTotal := LiabTotal + LiabTypeTotal;

        if MyComponent is TvtScrollbox then
          MyLabel := TvtLabel.Create(MyScrollBox)
        else if MyComponent is TForm then
          MyLabel := TvtLabel.Create(MyTForm);

        with MyLabel do
        begin
          Tag := c_DynLabelTag;

          if MyComponent is TvtScrollbox then
            Parent := MyScrollBox
          else if MyComponent is TForm then
            Parent := MyTForm;
          AutoSize := false;
          SetBounds(LabelBounds[High(LabelBounds)].Left,
            LabelBounds[High(LabelBounds)].Top + CurrentLineNumber * LabelBounds[High(LabelBounds)].Height,
            LabelBounds[High(LabelBounds)].Width,  LabelBounds[High(LabelBounds)].Height);

          Caption := FormatFloat('###,###,###.00', LiabTypeTotal) + ' ';
      //Caption := FormatAmount('',FloatToStr(AssetTypeTotal),2) + ' ';
//          Width := 120;
//          Left := 490;
          Alignment := taRightJustify;
//          Height := 14;
      //Inc(CurrentLineNumber,1);
//          Top := 71 + (14 * CurrentLineNumber);
//          AutoSize := false;
          Transparent := False;
          vtTransparent := False;
          Color := clWhite;
          vtBorderType := vtlblFull;
          vtIsPrintable := True;
          Font.Name := 'Times New Roman';
          Font.Size := LabelBounds[High(LabelBounds)].FontSize;
          BringToFront;
        end;
        Inc(CurrentLineNumber, 2)

      end;
{$ENDREGION 'TOTAL'}
    end;
  end; //end for Liabform
{$REGION 'TOTAL_ALL'}
  if LiabTotal > 0 then
  begin
    if MyComponent is TvtScrollbox then
      MyLabel := TvtLabel.Create(MyScrollBox)
    else if MyComponent is TForm then
      MyLabel := TvtLabel.Create(MyTForm);
    with MyLabel do
    begin
      if MyComponent is TvtScrollbox then
        Parent := MyScrollBox
      else if MyComponent is TForm then
        Parent := MyTForm;

      Caption := FormatFloat('###,###,###.00', LiabTotal) + ' ';
      AutoSize := false;
      SetBounds(LabelBounds[High(LabelBounds)].Left - 20,
        LabelBounds[High(LabelBounds)].Top + CurrentLineNumber * LabelBounds[High(LabelBounds)].Height,
        LabelBounds[High(LabelBounds)].Width + 20,  LabelBounds[High(LabelBounds)].Height);
//      Width := 120;
//      Left := 490;
      Alignment := taRightJustify;
//      Height := 14;
//      Top := 71 + (14 * CurrentLineNumber);
//      AutoSize := false;
      Transparent := False;
      vtTransparent := False;
      Color := clWhite;
      vtBorderType := vtlblFull;
      vtIsPrintable := True;
      Font.Name := 'Times New Roman';
      Font.Size := LabelBounds[High(LabelBounds)].FontSize;
      BringToFront;
    end;
    if MyComponent is TvtScrollbox then
      MyPageBreak := TvtShape.Create(MyScrollBox)
    else if MyComponent is TForm then
      MyPageBreak := TvtShape.Create(MyTForm);

    if MyComponent is TvtScrollbox then
      MyPageBreak.Parent := MyScrollBox
    else if MyComponent is TForm then
      MyPageBreak.Parent := MyTForm;
    MyPageBreak.Tag := c_DynLabelTag;
    MyPageBreak.vtPageBreak := True;
    MyPageBreak.Top := 920 * PageNumber;
    MyPageBreak.Pen.Color := clBlack;
    MyPageBreak.Pen.Style := psSolid;
    MyPageBreak.Pen.Width := 5;
  end;
{$ENDREGION 'TOTAL_ALL'}

end;  //end liabSum
//20170408 Igor <<<

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


//20170411
Procedure DTC(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;FedNi,NI,PrvNi,x:Real;
EligTxbl, NonEligTxbl:Real;
ActualDividendsNonElig,ActualDividendsElig:Real;
Begin
  InitPRVConstants(ret[RetNo].Province);  //20111113

  LoadTv(RetNo,FName,FNo);
  With ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
     ActualDividendsNonElig:=(Vl(FetchElm(RetNo,'CASHFLOW',23))  //from investments
                   +Vl(FetchElm(RetNo,'CASHFLOW',35)));  //from own corp
     ActualDividendsElig:=Vl(FetchElm(RetNo,'CASHFLOW',109));

     EligTxbl:=ActualDividendsElig * 138/100;
     NonEligTxbl:=ActualDividendsNonElig * 115/100;   //20200314 17

     Tv[10]:=EligTxbl+NonEligTxbl; //20200314
     Tv[11]:=NonEligTxbl;   //20200314
     Tv[14]:=MaxR(0,Tv[10]-Tv[11]);
     //20161117
     Frm[FNo].Strings[13]:='9.0301'; //'10.5217';  //20200314
     If RY=1 then Frm[FNo].Strings[13]:='9.0301'; //'10.5217';  //20200314
     Frm[FNo].Strings[15]:='15.0198';  //same
     If RY=1 then Frm[FNo].Strings[15]:='15.0198';  //same

     Tv[12]:=Tv[11]*Vl(Frm[FNo].Strings[13])/100;
     Tv[16]:=Tv[14]*Vl(Frm[FNo].Strings[15])/100;
     Tv[17]:=Tv[12]+Tv[16];

     //20200314
     Tv[2]:=Tv[10]; //EligTxbl+ActualDividendsNonElig;
     Tv[3]:=Tv[11]; //NonEligTxbl;
     Tv[6]:=MaxR(0,Tv[2]-Tv[3]);
     //20161129  TV to strings
     Frm[FNo].Strings[5]:=PrvConstant[RY].PrvDivRate;
     Frm[FNo].Strings[7]:=PrvConstant[RY].PrvDivRateBig;
     Tv[4]:=Tv[3]*Vl( Frm[FNo].Strings[5])/100;
     Tv[8]:=Tv[6]*Vl( Frm[FNo].Strings[7])/100;

     Tv[9]:=Tv[4]+Tv[8];
     If ret[RetNo].Province = 'QC' then begin For i:=2 to 9 do Tv[i]:=0;end;
   end;
  SaveTv(RetNo,FName,FNo);
end;

end.

