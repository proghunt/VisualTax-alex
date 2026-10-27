unit T1_2026T1rtns;
{$B-}

interface
 uses
 SysUtils,{$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON},WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB ,IniFiles,
 T1_2026Declare,ShellApi,{UAdminPassword,}Registry,vtAuthorization;

{Const}

Const Cw =14;  {space T4sum}

//function GetGpValue(FldName:WideString):String;
//Procedure GetEfFields(RetNo:Integer);

//Procedure PrepareJacketForPrint(RetNo:Integer;FName:String);
Function GetBatchPrintTemplate:string;
(*
Procedure StoreLastYearT2125Sum(RetNo:Integer;FInst:String);
Procedure StoreLastYearT2042Sum(RetNo:Integer;FInst:String);
Procedure StoreLastYearT2121Sum(RetNo:Integer;FInst:String);
Procedure StoreLastYearT776Sum(RetNo:Integer;FInst:String);
Procedure StoreLastYearT1163Sum(RetNo:Integer;FInst:String);
Procedure StoreLastYearT1273Sum(RetNo:Integer;FInst:String);
*)
Procedure T3MultDetails(RetNo:integer;FNo:integer;j,jj:integer;SlipFNo:Integer);
Function CountT3MultSlips(RetNo:integer):integer;
Procedure ClearT5007SumTotal;
Procedure T5007Header1(RetNo:integer;FNo:integer;j:integer);
Procedure T5007Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T5007Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);


Procedure ClearT4ESumTotal;
Procedure T4EHeader1(RetNo:integer;FNo:integer;j:integer);
Procedure T4EHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4EDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Procedure ClearT4AOASSumTotal;
Procedure T4AOASHeader1(RetNo:integer;FNo:integer;j:integer);
Procedure T4AOASHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4AOASDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Procedure ClearT4APSumTotal;
Procedure T4APHeader1(RetNo:integer;FNo:integer;j:integer);
Procedure T4APHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4APDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Procedure ClearT4PSSumTotal;
Procedure T4PSHeader1(RetNo:integer;FNo:integer;j:integer);
Procedure T4PSHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4PSDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Function AssetElmIsOverride(Elm:Integer):Boolean;
Procedure ResortFormsToPrint(Var FormsToPrint:TStringList);
Function CountT5MultSlips(RetNo:integer):integer;
Function GetWinBootDir:String;
Function CountAllDependants(RetNo:Integer):Integer;
Function CalcInvSurcharge(RetNo:Integer):Real;
Function IsReadyForEfile(RetNo:Integer):Boolean;
Function IsReadyForBarCode(RetNo:Integer):Boolean;
Function IsReturnEfiled(RetNo:Integer):Boolean;
Function GetNonPageFrm(Frm:String):String;
//Procedure ResequenceFormsToPrint(Var FormsToPrint:TStringList);
//Procedure ResequenceStatements(Var TempList2:TStringList);
Function ChildBornThisYear(RNo:Integer):Boolean;
Function AllowedToFormPrint(RetNo:Integer;FormName:String):Boolean;
Function IsReturnDiscounted(RetNo:Integer):Boolean;
Function CalcNUCola(AdjInc:Real):Real;
Function CalcONPolit(Contr:Real):Real;
Function CalcNUPolit(Contr:Real):Real;
Function ItIsFirstNation(RetNo:Integer):Boolean;
Function GetFirstNationName(RetNo:Integer):String;
Function GetFirstNationNumber(RetNo:Integer):String;
//Function AllowedToChangeSaveDir(SaveDir:String):Boolean;
Function AllowedToFullPrint(RetNo:Integer):Boolean;
Function GetNextInvNo:String; //standard: for prefix-seq-Suffix
Function GetNextInvoiceNo(UserName:String):Integer;  //multiuser
Function MakeInvoiceNo(RetNo:Integer):String;
//Function YouKnowTheAdminPassword:Boolean;
//Function GetAdminPassword(UserName: string):String;
//Function GetOverseasCredit(RetNo:Integer):Real;
procedure RecalcEverything(RetNo:Integer);
Procedure CalcAllForms(RetNo:Integer);
Procedure CopyFields(FromRetNo,ToRetNo,FNo,Ndx1,Ndx2:integer);
Function IncludeFormInPrint(RetNo:Integer;FNm:String):boolean;
Function DependantsEntered(RNo:Integer):Boolean;
Procedure T4A(RetNo: integer; FName: String;FNo: integer);
Procedure T4AOAS(RetNo: integer; FName: String;FNo: integer);
Procedure T4E(RetNo: integer; FName: String;FNo: integer);
Procedure UpdateACKDate(FullAckFileName:String;DataDir:string);
Procedure UpdateRTUDate(FullRtuNo:String;DataDir:string);
Function MakeReceivedFileName(FlName,LicenseLevel,FileType:string):string;
Function ValidateSend(DataDir,FlName:string):boolean;
//procedure OnestepCom;

//Procedure CalcCCAFromAssetsB;    //20110204
Procedure CalcCCAFromAutos(Cls:string;UccStart:real;
                 Additions:real;Proceeds:real;
                 Var Adjustments:real;Var BaseForCCA:real;
                 Rate:string;Var CCA:real;Var UccEnd:real;
                 OvrCCA:string;OvrUCC:string;ClaimIt:Boolean;
                 Rule50Exempt:String;BusPercent:Real;Var MaxCCA:Real);
{
(Cls:string;UccStart:real;
                 Additions:real;Proceeds:real;
                 Var Adjustments:real;Var BaseForCCA:real;
                 Rate:string;Var CCA:real;Var UccEnd:real;
                 OvrCCA:string;OvrUCC:string;ClaimIt:Boolean;
                 Rule50Exempt:String;BusPercent:Real;Var MaxCCA:Real);
}
Procedure CalcCCA(Cls:string;UccStart:real;
                 Additions:real;Proceeds:real;
                 Var Adjustments:real;Var BaseForCCA:real;
                 Rate:string;Var CCA:real;Var UccEnd:real;
                 OvrCCA:string;OvrUCC:string;ClaimIt:Boolean;
                 Rule50Exempt:String;BusPercent:Real;Var MaxCCA:Real);


Function FedLoggingTaxCredit(RetNo:integer;LogTax,LogIncome:Real):Real;
Function BCLoggingTaxCredit(RetNo:integer;LogTax,LogIncome:Real):Real;
Function IncrementYear(YYYYMMDD:String):String;
Procedure ClearFields(RetNo,FNo,Ndx1,Ndx2:integer);
Procedure CFZeroAmounts;
Procedure CFFilterLastYrAndStore(RetNo:Integer;FormNm:String;FNo:Integer;Elm:integer;Valu:String);
Procedure CFReformatPrvYearData(RetNo:Integer);

Function GetPrintTemplate:string;
Procedure GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList);
Function GetPrintSequence(FName:string):String;
procedure OnestepEFile;
Function GetCopiesToPrint(FName:string;TemplForms:TstringList;
        TemplCopies:TStringList):String;
Function GetQueryName(QDescr: string): string;
Procedure TotT1139(RetNo:Integer;
          Var T1139ReserveConv:real;
          Var T1139ReserveAlt:real;
          Var T1139Bus:real;
          Var T1139Prof:real;
          Var T1139Farm:real;
          Var T1139Fish:real);

Function DtDiff(D1: string; D2 : string):Integer;
//Function YYYYMMDDToWinFormat(Dt:String):string;//20170728 Igor
Procedure GetBusStatements(RetNo:Integer);
Procedure GetSpecificBusStatements(RetNo:Integer;FNm:String);
Procedure GetOddBusStatements(RetNo:Integer); //t1139
Procedure GetFarmingStatements(RetNo:Integer);  //t220423
Procedure AddToOddStm(FName,BusName,EndDate:string;BusInc:Real);
Procedure WriteFileForEFCom;
Function SubstituteForm(RetNo:Integer;FrmNm:String):String;
Procedure CopySubstitute(RetNo:Integer;FromFrm,ToFrm:String);
//Procedure CopySubstitute(FromFrm,ToFrm:String);
Function SpouseIncome(RetNo:Integer):real;
Function GetKidsUnder7(RetNo:Integer):Integer;
Procedure PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4:String);
Function PrintLabels(RetNo: integer; DataDir,FileNm:String):boolean;
Function GetWinIniString(IniFileName:String;Sect:String;Ident:String):String;
//Function MMDDYYYYToWinFormat(Dt:String):string;//20170728 Igor
//Function DateDiff(D1: String; D2 : string):Integer;
Function GetBasicFedTax(RetNo:Integer;Prv:String): Real;
Function GetPrvNetIncome(RetNo:Integer;Prv:String): Real;
Function GetMultPrvTax(RetNo:Integer;Prv:String): Real;
Function IsMultJurisdiction(RetNo:Integer): Boolean;
Function CalcThisProvince(RetNo:Integer;Prv:String): Boolean;
Function GetPrvPolit(RetNo:Integer;Prv:String): Real;

Procedure CountSlips(RetNo:integer;Var T4Cnt:integer;
          Var T4ACnt:integer;Var T5Cnt:integer;Var T3Cnt:Integer;
          Var T4RifCnt:integer;Var T4RspCnt:integer;
          Var T4AOASCnt:Integer;Var T4APCnt:Integer; Var T4ECnt:Integer;
          Var T4PSCnt:Integer; Var T5007Cnt:Integer);

Procedure ClearT4SumTotal;
Function FormatSlSum(x:real):string;
Procedure TotLine(RetNo:Integer;FNo:integer;J:integer);

Procedure T4Header1(RetNo:integer;FNo:integer;j:integer);
Procedure T4Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Procedure T5Header1(RetNo:integer;FNo:integer;j:integer);
Procedure T5Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T5Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Procedure T5MultDetails(RetNo:integer;FNo:integer;j,jj:integer;SlipFNo:Integer);

Procedure T3Header1(RetNo:integer;FNo:integer;j:integer);
Procedure T3Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
//Procedure T3Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Procedure T4AHeader1(RetNo:integer;FNo:integer;j:integer);
Procedure T4AHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4ADetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Procedure T4RSPHeader1(RetNo:integer;FNo:integer;j:integer);
Procedure T4RSPHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4RSPDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Procedure T4RIFHeader1(RetNo:integer;FNo:integer;j:integer);
Procedure T4RIFHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
Procedure T4RIFDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);

Function GetCCARate(Cls:string):String;
Procedure InitCCARates;
Function FindAnySpouseRetNo:Integer;
Function FindReturnNoFromSin(S:String):Integer;
//Function GetTotalFee(RetNo:Integer):Real;  //20110129
{Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;}
Function ValidShortProvince(s:string):Boolean;
Function ValidLongProvince(s:string):Boolean;
Function CanStatusBeReady(RetNo:Integer;EfStat:Integer;PrepStatus:integer):boolean;
Function InvoicePrepared(RetNo:integer):boolean;
Function SubjectToMinTax(RetNo:Integer):Boolean;
{procedure CCA1(RetNo: integer; FName: String;FNo: integer);}
procedure RC71(RetNo: integer; FName: String;FNo: integer);

procedure RC72(RetNo: integer; FName: String;FNo: integer);
Procedure RPP(RetNo:integer;FName:string;FNo:integer);
procedure EFMEMO(RetNo: integer; FName: String;FNo: integer);
procedure T4SUM(RetNo: integer; FName: String;FNo: integer);

Procedure T664(RetNo:integer;FName:string;FNo:integer);


Procedure T936(RetNo:integer;FName:string;FNo:integer);

Procedure CountSFDS(
      RetNo:Integer;  //20180114
  Var RentSfds:integer; Var BusSfds:Integer;  Var ProfSfds:integer;
  Var FarmSfds:Integer; Var FishSfds:Integer; Var NisaSfds:Integer;
  Var HCaisSfds:Integer;
  Var T777Sfds:Integer;
  Var TL2Sfds:Integer;
  Var T2091Sfds:Integer;Var T1255Sfds:Integer);
//  Var T777sSFDs:Integer);   //20319123


Procedure CountSFDSForBarcode(RetNo:Integer; Var RentSfds:integer; Var BusSfds:Integer;  Var ProfSfds:integer; Var FarmSfds:Integer;
  Var FishSfds:Integer; Var NisaSfds:Integer;Var HCaisSfds:Integer;
  Var T777Sfds:Integer;Var TL2Sfds:Integer;Var T2091Sfds:Integer;Var T1255Sfds:Integer);  //20210123

 // Var i,j:integer;


Procedure GetPrevYearLines(FlName:String;DataDir:string;
   Var LinesList:TStringList;Var ValueList:TstringList);

Procedure GetPrevYearLinesFromYRSum(Var LinesList:TStringList;Var ValueList:TstringList);

Procedure GetPrevPrevYearLines(FlName:String;DataDir:string;
   Var LinesList:TStringList;Var ValueList:TstringList);
Function AllowedToChangeSaveDir(SaveDir:String):Boolean;
Var  Tot: Array[1..9] of real;

Implementation

uses T1_2026, vtMulti,vtCommon,vtDialogs,T1_2026TrimStr,T1_2026Common,
  T1_2026Common2,T1_2026CALC,T1_2026Print,T1_2026CntErr,T1_2026ChildWinNew,
  vtPrints, vtTrimStr, vtShared, vtDataBase,
  uADCompClient;
//TrimStr,Common,Common2,UCALC,UPopList,UPrint,UCntErr,ChildWinNew;

Function ValidShortProvince(s:string):Boolean;
Var i:integer;
begin
 result := false;
 For i:=Low(PrvShort) to High(PrvShort) do
  If s = PrvShort[i] then begin result :=true;exit;end
end;

Function ValidLongProvince(s:string):Boolean;
Var i:integer;
begin
 result := false;
 For i:=Low(PrvLong) to High(PrvLong) do
  If s = PrvLong[i] then begin result :=true;exit;end
end;


Procedure CountSFDS(RetNo:Integer; Var RentSfds:integer; Var BusSfds:Integer;  Var ProfSfds:integer; Var FarmSfds:Integer;
  Var FishSfds:Integer; Var NisaSfds:Integer;Var HCaisSfds:Integer;
  Var T777Sfds:Integer;Var TL2Sfds:Integer;Var T2091Sfds:Integer;Var T1255Sfds:Integer);  //20210123
  Var i,j:integer;
begin
  RentSfds:=0;BusSfds:=0;ProfSfds:=0;FarmSfds:=0;FishSfds:=0;NisaSfds:=0;HCaisSfds:=0;
  T777Sfds:=0;TL2Sfds:=0;T2091Sfds:=0;T1255Sfds:=0;

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'T776') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(RentSfds);
   If (Frec.FormName = 'T777') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T777Sfds);

   If (Frec.FormName = 'TL2') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(TL2Sfds);

   If (Frec.FormName = 'T2125')
      and (Frec.FormInst>'')
      and (Ret[RetNo].FrmHasData[Frec.FormNo])
      then
      begin
       If  FetchElmFNo(RetNo,Frec.FormNo,82)>'' then Inc(BusSfds); //business //20101221 relocated from above
      end;
   If (Frec.FormName = 'T2125')
      and (Frec.FormInst>'')
      and (Ret[RetNo].FrmHasData[Frec.FormNo])
      then
      Begin
       If FetchElmFNo(RetNo,Frec.FormNo,90)>'' then Inc(ProfSfds);//Professional //20101221 relocated from above
      end;
   If (Frec.FormName = 'T2042') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(FarmSfds);
   If (Frec.FormName = 'T1163') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(NisaSfds);
   If (Frec.FormName = 'T1273') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(HCaisSfds,2);   //20200103 as before      //why 2? //Inc(HCaisSfds,2);      //20200130   //why 2?
   If (Frec.FormName = 'T2121') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(FishSfds);
   //20180114
   If (Frec.FormName = 'T2091') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T2091Sfds);
    //20180304
   If (Frec.FormName = 'T1255') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T1255Sfds);

    {
    //20210123
   If (Frec.FormName = 'T777S') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T777sSfds);
   }
 end;   {Flist do}
end;


Procedure CountSFDSForBarcode(RetNo:Integer; Var RentSfds:integer; Var BusSfds:Integer;  Var ProfSfds:integer; Var FarmSfds:Integer;
  Var FishSfds:Integer; Var NisaSfds:Integer;Var HCaisSfds:Integer;
  Var T777Sfds:Integer;Var TL2Sfds:Integer;Var T2091Sfds:Integer;Var T1255Sfds:Integer);  //20210123
  Var i,j:integer;
begin

  RentSfds:=0;BusSfds:=0;ProfSfds:=0;FarmSfds:=0;FishSfds:=0;NisaSfds:=0;HCaisSfds:=0;
  T777Sfds:=0;TL2Sfds:=0;T2091Sfds:=0;T1255Sfds:=0;
  //T777sSFDs:=0;  //20210123

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'T776') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(RentSfds);
   If (Frec.FormName = 'T777') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T777Sfds);

   If (Frec.FormName = 'TL2') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(TL2Sfds);

   If (Frec.FormName = 'T2125')
      and (Frec.FormInst>'')
      and (Ret[RetNo].FrmHasData[Frec.FormNo])
      then
      begin
       If  FetchElmFNo(RetNo,Frec.FormNo,82)>'' then Inc(BusSfds); //business //20101221 relocated from above
      end;
   If (Frec.FormName = 'T2125')
      and (Frec.FormInst>'')
      and (Ret[RetNo].FrmHasData[Frec.FormNo])
      then
      Begin
       If FetchElmFNo(RetNo,Frec.FormNo,90)>'' then Inc(ProfSfds);//Professional //20101221 relocated from above
      end;
   If (Frec.FormName = 'T2042') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(FarmSfds);
   If (Frec.FormName = 'T1163') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(NisaSfds);
   If (Frec.FormName = 'T1273') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(HCaisSfds,0);  //Inc(HCaisSfds,2);   //20200103 as before      //why 2? //Inc(HCaisSfds,2);      //20200130   //why 2?
   If (Frec.FormName = 'T2121') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(FishSfds);
   //20180114
   If (Frec.FormName = 'T2091') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T2091Sfds);
    //20180304
   If (Frec.FormName = 'T1255') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T1255Sfds);
    {
    //20210123
   If (Frec.FormName = 'T777S') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[Frec.FormNo]) then
      Inc(T777sSfds);
    }
 end;   {Flist do}
end;



Function SubjectToMinTax(RetNo:Integer):Boolean;
begin
 //Result:=False; EXIT;     //20250402
 //--------------------------
 Result := false;
 If Vl(FetchElm(RetNo,'T691',147)) > 0 then result := true;  //20250419
 //If Vl(FetchElm(RetNo,'T691',213)) > 0 then result := true; //jz//20250406 - wrong elm change to 213 from 129
 If FetchElm(RetNo,'INFO',24) > '' then result := false; {dead}
 If FetchElm(RetNo,'BANKRPT',6) > '' then result := false; {Trustee return}
end;

Function InvoicePrepared(RetNo:integer):boolean;
begin
 result := false;
 If (Vl(FetchElm(RetNo,'INVOICE',222)) >0) and
 (FetchElm(RetNo,'INVOICE',223)+ FetchElm(RetNo,'INVOICE',224)
  +FetchElm(RetNo,'INVOICE',225)+FetchElm(RetNo,'INVOICE',282)
  +FetchElm(RetNo,'INVOICE',271)>'')
 then result := true;
end;

Function CanStatusBeReady(RetNo:Integer;EfStat:Integer;PrepStatus:integer):boolean;
begin
  Result := True;
  If IsReturnDiscounted(RetNo) then exit;
//  If LeftStr(LicenseLevel,8) = 'T1 Multi' then
  If LicenseLevel in anyMulti then
  begin
   If (not InvoicePrepared(RetNo)) and
    ((EfStat = 1) or  {ready for RTU}
    (PrepStatus = 5)) {ready to print}
    then result := false;
  end;
end;

Function IsReadyForBarCode(RetNo:Integer):Boolean;
Var i:Integer;TempList:TStringList;
begin
  Result := True;
  If RetNo=0 then exit;
  CountDiagnostics(RetNo);
  TempList:=TStringList.Create;
//  For i:=Low(Ret[RetNo].AuditRec) to High(Ret[RetNo].AuditRec) do
  For i:=0 to Ret[RetNo].AuditList.Count - 1 do
  begin
    If Ret[RetNo].AuditRec[i].Category='F-' then
    begin
    If Ret[RetNo].AuditRec[i].Form <>'F-T183' then
      TempList.Add(Ret[RetNo].AuditRec[i].Description);
    end;
  end;
  If TempList.count>0 then Result:=False;
  TempList.Free;
end;


Function IsReadyForEfile(RetNo:Integer):Boolean;
begin
  Result := True;
  If RetNo=0 then exit;
  CountDiagnostics(RetNo);
  If (Ret[RetNo].EFileErrorCount > 0) then result :=False;
//  Result := True;
//  If RetNo=0 then exit;
//  CountDiagnostics(RetNo);
//  If (EFileErrorCount > 0) then result :=False;
end;

Procedure RPP(RetNo:integer;FName:string;FNo:integer);
Begin
  {Load the numeric fields of a form into the Temporary Variables array}
  LoadTv(RetNo,FName,FNo);
  with ret[RetNo].Frm[FNo] do
  begin
    {Calc this form}
    Tv[4] := Tv[1] + Tv[2] + Tv[3];
    Tv[9] := Tv[7] + Tv[8];
    Tv[10] := Tv[9];
    Tv[11] := 3500;
    Tv[13] := Vl(Ret[RetNo].Frm[FNo].Strings[12]) * 3500;
    Tv[15] := Tv[13] - Tv[14];
    Tv[16] := Tv[15];
    Tv[17] := MinR(MinR(Tv[10],Tv[11]),Tv[16]);
    Tv[21] := Tv[19] + Tv[20];
    Tv[22] := Tv[21];
    Tv[23] := 3500;
    Tv[26] := Tv[24] + Tv[25];
    Tv[27] := Tv[17];
    Tv[28] := Tv[23] - (Tv[26] + Tv[27]);
    Tv[29] := Tv[28];
    Tv[30] := MinR(Tv[22],Tv[29]);
    Tv[35] := Tv[32] + Tv[33] + Tv[34];
  end;
  {save data}
  SaveTv(RetNo,FName,FNo);
End;

procedure EFMEMO(RetNo: integer; FName: String;FNo: integer);
Var  i: integer; x:real;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[35]:=Tv[47]+Tv[48];
  Tv[3]:=GetFisherUiEarnings(RetNo);

  //jz//20250224 line 51051
  if Vl(FetchElm(RetNo,'INFO',19)) < 0 then
  begin
    Tv[10]:= abs(Vl(FetchElm(RetNo,'INFO',19)));
    //strings[17]:= '1'; //9918 populated in EfRules, removed from eflines form
  end;

  //inelig inc on 115 and 129
  Tv[5]:= Vl(FetchElm(RetNo,'PNSDED',6))
      +TotMultiple(RetNo,'T4RSP',6)+TotMultiple(RetNo,'T4RSP',5);  //20100109
  Tv[5]:=MinR(Tv[5],Ret[RetNo].Lnn[11500] + Ret[RetNo].Lnn[12900]);

  Tv[6]:= Vl(FetchElm(RetNo,'RRSP',74));
  Tv[13]:= Vl(FetchElm(RetNo,'RRSP',77));
  Tv[7]:= TotMultiple(RetNo,'T4',11)+TotMultiple(RetNo,'T4',48); //status indian exempt plus Placement Office self-Empl
  Tv[46]:=Vl(FetchElm(RetNo,'RC383',5));  //20141205  //other exempt
  Tv[15]:= TotMultiple(RetNo,'T4',11)+Tv[46];   //20111219
  Tv[1]:= Ret[RetNo].T4AAnnuity
         +TotMultiple(RetNo,'T5',13)
         +Ret[RetNo].T4RifAnnuity;
  If Tv[1]>Ret[RetNo].Lnn[11500] then Tv[1]:=Ret[RetNo].Lnn[11500];
  Tv[14]:=Ret[RetNo].Lnn[12100];
  If UpperCase(Strings[40]) <> 'Y' then
  begin
   Tv[37] := TotMultiple(RetNo,'T5MULT',128);
   Tv[38] := TotMultiple(RetNo,'T5MULT',129);
   Tv[39] := TotMultiple(RetNo,'T5MULT',130);
   Tv[41]:=TotMultiple(RetNo,'T3MULT',118);  //20110226
  end;
//  Tv[41]:=TotMultiple(RetNo,'T3MULT',118);  //20101207
  //20191210 instead of 7 use 1
  If Strings[18] > '' then strings[18] := '1';
  If Strings[19] > '' then strings[19] := '1';

  //20260709  Removed the old 9915 and 9917
  //If Strings[20] > '' then strings[20] := '1'; //'7';  //20191210
  //If Strings[8]  > '' then strings[8] := '1';
  //new fields to be Overrides and behave like indicatore and nor dollar amounts


  //---------------------------------------
  //20260628  Duplicated to be part of the Overrides.
  // So id not affect the calculations (only an indicator)
  Strings[53]:='9915';
   //20260709 //use the override box  Manual entry
  //Strings[20]:='';  //remove the old one
  {Leave it blank  for manual entery
  if FetchElm(RetNo,INFOFNo,123)>'' then
   Strings[54]:='1' //20260709 //use the override box
  Else
   Strings[54]:=''; //20260709 //use the override box
  }

  Strings[55]:='9917';  //Strings[8]:='';  //remove the old box  //20260709  //Strings[56]:=  ???
  IF (Ret[RetNo].Age >= 65) and (Ret[RetNo].Lnn[11300] = 0) then
   Strings[56]:='1'  //not OAS received
  Else
   Strings[56]:='';  //OAS received

  //--------------------------------------


  If FetchElm(RetNo,'INFO',103) > '' then
    strings[21] := '1'
   else
    Strings[21]:='';

 //20141220
  If (Vl(FetchElm(RetNo,'RC381',47))>0)  //f373 present
  and (Vl(FetchElm(RetNo,'RC381',48))=0) //F399 not present
  then Strings[22]:='';

  If Strings[22] > '' then strings[22] := '5';

  If Ret[RetNo].Province= 'QC' then
  begin
   //20141211
   Strings[43]:='';
   If (HasNonQCT4Income(RetNo)=True)
   and (Vl(FetchElm(RetNo,'S10',9))=0)
   then Strings[43]:='2';  //20141211
   If Ret[RetNo].Lnn[10100]=0 then Strings[43]:='';
  end;
  If Strings[43] > '' then strings[43] := '2';

  //20130130
  //Tv[49]:=Calc5031(RetNo);    //20260502

  //20130404
  i:=23;
  Repeat
   If Strings[i]='5031' then Tv[49]:=Vl(Strings[i+1]);
   Inc(i,2);
  until i>33;

 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure RC71(RetNo: integer; FName: String;FNo: integer);
Var i:integer;Cost:Real;
begin
  LoadTv(RetNo,FName,FNo);
  If FetchElm(RetNo,'INFO',102) = '' then
  begin
    For i:=1 to 39 do begin Ret[RetNo].Frm[FNo].Strings[i] :='';ret[RetNo].Frm[FNo].Tv[i] := 0;end; //20250315
    SaveTv(RetNo,FName,FNo);
    exit;
  end;

  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[31] := AppYear;
   Strings[1] :=  OptRec.Prp_Name;
   Strings[15] := OptRec.Prp_Street;
   Strings[18] := OptRec.Prp_City;
   Strings[28] := OptRec.Prp_Prov+', '+ OptRec.Prp_Postal;
   Strings[2]  := OptRec.Prp_DiscNo;
   Strings[6]  := OptRec.Prp_DiscNm;
   Strings[7]  := OptRec.Prp_Area+ ' '+OptRec.Prp_Tel;
   Strings[8] := GetFirstName(RetNo);
   Strings[9] := GetLastName(RetNo);
   Strings[11] := FetchElm(RetNo,'INFO',6); {str}
   If FetchElm(RetNo,'INFO',22)>'' then Strings[11] := Strings[11]
         +' Apt '+FetchElm(RetNo,'INFO',22); {apt}
   Strings[12] := FetchElm(RetNo,'INFO',10)
               +' '+FetchElm(RetNo,'INFO',14); {city,postal}
   Strings[13] := FetchElm(RetNo,'INFO',15); {postal}
   Strings[10] := GetSinNo(RetNo);
   Strings[14] := FetchElm(RetNo,'INFO',54)+
           ' '+FetchElm(RetNo,'INFO',55);
   Tv[3] := MaxR(0,Ret[RetNo].Lnn[48400]-Tv[33]);
   If (vl(Strings[35])<0.85) Or (vl(Strings[35])>1) Then Strings[35]:='0.85';
   If (vl(Strings[36])<0.95) Or (vl(Strings[36])>1) Then Strings[36]:='0.95';

   Tv[16] := MinR(300,Tv[3]) * 0.85; If Strings[35]>'' then  Tv[16] := MinR(300,Tv[3]) * Vl(Strings[35]);  //20130131
   Tv[17] := MaxR(0,Tv[3]-300) * 0.95;If Strings[36]>'' then Tv[17] := MaxR(0,Tv[3]-300) * Vl(Strings[36]);//20130131
   Tv[32] := Tv[16]+Tv[17];
   Tv[4] := Tv[32];
   Cost :=MaxR(0,Tv[3] - Tv[4]);

   For i:=19 to 21 do Tv[i] :=0;

   If OptRec.Opr_GstHst >5 then      //hst
   begin
      Tv[19] :=0; Tv[20]:= (Cost * 2/3) * OptRec.Opr_GstHst/100;
      If Cost >45 then Tv[20] := 4.50;
  end
   else
   begin
     Tv[20] :=0; Tv[19]:= (Cost * 2/3)* OptRec.Opr_GstHst/100;
     If (Cost>45) and (OptRec.Opr_GstHst>0) then Tv[19]:= 2.10;
   end;
   Tv[19]:=MinR(1.50,Tv[19]);
   If Ret[Retno].Province='ON' then  //20170308
    Tv[20]:=MinR(3.90,Tv[20])
   Else
    Tv[20]:=MinR(4.50,Tv[20]);  //20170305 // Tv[20]:=MinR(3.90,Tv[20]);

   Tv[21]:=0;
  // If Ret[RetNo].Province = 'PE' then  Tv[21]:= (Cost+Tv[19]+Tv[20]) * 0.10;  end;  //20170305
   If Ret[RetNo].Province = 'QC' then
   begin
    Tv[21]:= (Cost * 2/3+Tv[19]+Tv[20]) * 7.5/100;
    If Cost>45 then Tv[21] := 2.41;
   end;

   //Tv[34]:=MinR(2.10,Tv[34]);

   //jz//20250314 - set esig data from info
   strings[39]:=FetchElm(RetNo,'INFO',144);
   If FetchElm(RetNo,'INFO',203) = 'Y' then
   begin
    strings[5]  := FetchElm(RetNo,'INFO',153); //bring date
    strings[38] := FetchElm(RetNo,'INFO',155); //bring time
   end
   else //clear
   begin
    //strings[5]  := ''; //clear date
    //strings[38] := ''; //clear time
   end;


   Tv[22] := Tv[19]+Tv[20]+Tv[37]+Tv[21]; //+Tv[34];  //20210307
   Tv[23] := MaxR(0,Tv[4]-Tv[22]);
   Tv[24] := Cost;
   Strings[25] := Strings[1];
   Strings[26] :=Strings[18];
   If Strings[27] = '' then strings[27] :=FormatDateTime('yyyy-mm-dd',Now);
   If Strings[5] = '' then strings[5] :=FormatDateTime('yyyy-mm-dd',Now);
   If (Strings[38]='') then strings[38]:=TimeToHHMMDD(Now);  //20220130
   Strings[29] := GetFirstName(RetNo)+' '+GetLastName(RetNo);
   Strings[30] :=FetchElm(RetNo,'INFO',10);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure RC72(RetNo: integer; FName: String;FNo: integer);
Var i:integer;Cost:Real;
begin
  LoadTv(RetNo,FName,FNo);
  If FetchElm(RetNo,'INFO',102) = '' then
  begin
    //20120612  added begin end
    begin For i:=1 to 28 do Ret[RetNo].Frm[FNo].Strings[i] :='';ret[RetNo].Frm[FNo].Tv[i] := 0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
  end;

  With Ret[RetNo].Frm[FNo] do
  begin
   Strings[2] := GetFirstName(RetNo);
   Strings[11] := GetLastName(RetNo);
   Strings[8] := GetSinNo(RetNo);

   Strings[1] := FetchElm(RetNo,'INFO',6); {str}
   Strings[3]:=FetchElm(RetNo,'INFO',22);
   Strings[4] := FetchElm(RetNo,'INFO',68); {rr box}
   Strings[5] := FetchElm(RetNo,'INFO',10);
   Strings[6] := FetchElm(RetNo,'INFO',14);
   Strings[7] := FetchElm(RetNo,'INFO',15); {postal}

   Strings[9]  := OptRec.Prp_DiscNo;
   Strings[10] := AppYear;
   Strings[12] :=  OptRec.Prp_Name;
   If Strings[13]='' then Strings[13] := OptRec.Prp_Street;
   If Strings[14]='' then Strings[14] := OptRec.Prp_City;
   If Strings[15]='' then Strings[15] := OptRec.Prp_Prov;
   If Strings[16]='' then Strings[16] := OptRec.Prp_Postal;

   Strings[22]  := OptRec.Prp_Name;
   {location}
   If Strings[23] ='' then strings[23] :=FormatDateTime('yyyy-mm-dd',Now);
   If Strings[28] ='' then Strings[28] :=TimeToHHMMDD(Now); //20220122
   If Strings[24] ='' then Strings[24] := OptRec.Prp_Street;
   If Strings[25] ='' then Strings[25] := OptRec.Prp_City;
   If Strings[26] ='' then Strings[26] := OptRec.Prp_Prov;
   If Strings[27] ='' then Strings[27] := OptRec.Prp_Postal;

   Tv[18]:= Vl(FetchElm(RetNo,'RC71',3));  //24
   Tv[19]:=MaxR(0,Tv[17]-Tv[18]);
   Tv[21]:=MaxR(0,Tv[19]-Tv[20]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;




Procedure T664(RetNo:integer;FName:string;FNo:integer);
Var i,j:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    {Strings[15] := DateToMonthDayYear(Date);
    Strings[16] := GetAreaCode(RetNo);
    Strings[17] := GetPhoneNo(RetNo);}
  end;
  //pg 2
    with Ret[RetNo].Frm[FNo] do
  begin
   {flow thru}
   I:=101; J:=1;
   repeat
    If UpperCase(FetchElm(RetNo,'T664',j)) ='F' then
    begin
     Strings[i] :=FetchElm(RetNo,'T664',j);
     Inc(i,6);
    end;
    Inc(j,4);
   until j>98; {T664 index}

     {flow thru}
   I:=181; J:=1;
   repeat
   If UpperCase(FetchElm(RetNo,'T664',j)) ='O' then
    begin
     Strings[i] :=FetchElm(RetNo,'T664',j);
     Inc(i,6);
    end;
    Inc(j,4);
   until j>98; {T664 index}
  {add up flow}
  I:=102; Tv[80]:=Tv[79];
  Repeat
   Tv[i+2] := Tv[i+1] - Tv[i];
   Tv[i+4] := Tv[i+2] - Tv[i+3];
   Tv[180] :=Tv[180]+Tv[i+4];
   Inc(i,6);
  until I>174;

  {add up other}
  I:=182; Tv[272]:=Tv[271];
  Repeat
   Tv[i+2] := Tv[i+1] - Tv[i];
   Tv[i+4] := Tv[i+2] - Tv[i+3];
   Tv[272] :=Tv[272]+Tv[i+4];
   Inc(i,6);
  until I>266;
 end;
  //pg 3

  with Ret[RetNo].Frm[FNo] do
  begin
  Strings[312] := GetFirstName(RetNo)+' '+
                 GetLastName(RetNo);
  Strings[313] := FetchElm(RetNo,'INFO',6)+' '+FetchElm(RetNo,'INFO',22)+','+
                 FetchElm(RetNo,'INFO',10)+','+
                 FetchElm(RetNo,'INFO',14)+','+
                 FetchElm(RetNo,'INFO',15);
  Strings[314] := GetSinNo(RetNo);
  Strings[315] := DateToMonthDayYear(Date);

  Tv[301] := Vl(FetchElm(RetNo,'T664',180));
  Tv[302] := Tv[301] * 3/4;
  {Where does it Go?}
  Tv[303] := Vl(FetchElm(RetNo,'T664',272));
  Tv[304] := Tv[303] * 3/4;
  {Where does it Go?}

  {Penalty}
  Tv[305] := Tv[302]+Tv[304];
  Tv[307] := MaxR(0,Tv[305]-Tv[306]);
  Tv[309] := Tv[307] * Vl(Strings[308]);
  Tv[310] := Tv[309] /300;
  end;

 SaveTv(RetNo,FName,FNo);
End;


//20260128 several changes
Procedure T936(RetNo:integer;FName:string;FNo:integer); //20240126
var i,S3FNo,T2017FNo: integer;
Begin
  //20250126
  S3FNo:=GetFormNo('S3');
  T2017FNo:=GetFormNo('T2017');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
    {Part 1}
  Tv[1] := Ret[RetNo].Lnn[22100];
  If Lnn[12600] <0 then Tv[2] :=ABS(Lnn[12600]) else Tv[2] :=0;
  If Lnn[12200] <0 then Tv[3] :=ABS(Lnn[12200]) else Tv[3] :=0;
  Tv[4] := Ret[RetNo].Lnn[25100];
  Tv[5] := Ret[RetNo].Lnn[22400] * 0.50;
  Tv[7] := MinR(Vl(FetchElm(RetNo,'T936',140)),Lnn[25300]);
    Tv[9] := 0;
    for i := 1 to 7 do Tv[9] := Tv[9] + Tv[i]; //20200125
    //Tv[9] := Tv[8];
  {Part 2}
  Tv[10] := Lnn[12000] + Lnn[12100];
  If Lnn[12600] >0 then Tv[11] :=Lnn[12600] else Tv[11] :=0;
  If Lnn[12200] >0 then Tv[12] :=Lnn[12200] else Tv[12] :=0;
    {?t936-1 recovery of expl.. Tv[14] := Lnn[13000] * 0.50;}
  //20250430
  Tv[24]:=TotMultiple(RetNo,'T3MULT',100);
  Tv[35]:=Tv[24]+Tv[26]+Tv[28]+Tv[33];
  Tv[13]:=Tv[35];
  Tv[15] := Vl(FetchElm(RetNo,'T936',140));
    Tv[17] := 0;
    for i := 10 to 15 do Tv[17] := Tv[17] + Tv[i];
  end;

  // pg 2 comments

  //pg 3  //20260108
   with Ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
        {Part 3}
        Tv[142] := Tv[9];
        Tv[143] := Vl(FetchElm(RetNo,'CFR',29));
        Tv[36]:=Tv[142]+Tv[143];
        Tv[37]:=Vl(FetchElm(RetNo,'T2048',78));  //20260128
        Tv[16]:=Tv[36]-Tv[37];  //??  if neg?
        Tv[20]:=Tv[16];
        Tv[21]:=Tv[17];
        //Tv[43]:=Tv[21];
        //Tv[43]:=Tv[21];
        Tv[44] := Vl(FetchElm(RetNo,'CFR',30));
        Tv[45]:=Tv[21]+Tv[44];
        Tv[46]:=Tv[45];
        Tv[150] := MaxR(0,(Tv[20] - Tv[46]));

   //pg 4   //20260108
       Tv[101]:=Vl(FetchElmFNo(RetNo,S3FNo,339)); //339)); //20250412

       if Tv[101]<>0 then
       Begin
         //Tv[38]:= from t2048
         Tv[39]:=Tv[101]-Tv[38];
         //Tv[102]:=Vl(FetchElmFNo(RetNo,S3FNo,106));
         {
         Tv[18]:=Vl(FetchElmFNo(RetNo,S3FNo,114));
         Tv[19]:=Vl(FetchElmFNo(RetNo,S3FNo,122));
         Tv[47]:=Vl(FetchElm(RetNo,'T2017',40));
         }
         Tv[30]:=Vl(FetchElmFNo(RetNo,S3FNo,173));
         Tv[31]:=Vl(FetchElmFNo(RetNo,S3FNo,186));
         //Tv[18]:=Vl(FetchElmFNo(RetNo,S3FNo,173));
         Tv[32]:=Vl(FetchElmFNo(RetNo,S3FNo,195));
         Tv[34]:=Tv[30]+Tv[31]+Tv[32];
         If Vl(FetchElmFNo(RetNo,S3FNo,292))<>0 then
           Tv[48]:=Vl(FetchElm(RetNo,'T2017',44))+Vl(FetchElm(RetNo,'T2017',77));
         Tv[49]:=Tv[34]+Tv[48];
         //20260128
         Tv[22]:=Tv[49]*50/100;
         Tv[8]:=TotMultiple(RetNo,'T2048',70); //Vl(FetchElm(RetNo,'T2048',70)); //20260128
         Tv[18]:=MaxR(0,Tv[22]-Tv[8]);
         Tv[19]:=Tv[18];
         Tv[60]:=MaxR(0,Tv[39]-Tv[19]);

         if Tv[60]=0 then
          begin
          for i:=134 to 136 do Tv[i]:=0;
          Tv[42]:=0;
          Tv[23]:=0;
          Tv[139]:=0;
          end;
         //Tv[8]:=Tv[49]*50/100;
         //Tv[22]:=TV[8];

        // Tv[60]:=MaxR(0,Tv[291]-Tv[22]);
        // Tv[60]:=MaxR(0,Tv[101]-Tv[22]); //jz//20250406 - is [101] not [291]
         if Tv[60]=0 then
         Begin
          For i:=134 to 136 do Tv[i]:=0;
          Tv[23]:=0;
          Tv[139]:=0;
          Tv[140]:=0;
         End
         Else
         begin
          Tv[134]:=SumT3MultBox(RetNo,82);  //box 21
          Tv[135]:=SumT3MultBox(RetNo,88);  //box 30
          Tv[136]:=Tv[134]-Tv[135];
          Tv[42]:=50;
          Tv[23]:=Tv[136]*Tv[42]/100;  //20250429
          Tv[139]:=Tv[23];
         // Tv[140]:=MaxR(0,Tv[60]-tv[139]);
         end;
       End //tv[101] <> 0;
       Else
       Begin  //20260128
        for i:=134 to 136 do Tv[i]:=0;
        Tv[38]:=0;
        Tv[39]:=0;
        Tv[60]:=0;
        Tv[19]:=0;
        Tv[23]:=0;
        Tv[139]:=0;
       End;
       Tv[140]:=MaxR(0,Tv[60]-Tv[139]);

   end;
    SaveTv(RetNo,FName,FNo);
End;


(*
//20250207
Procedure T936(RetNo:integer;FName:string;FNo:integer); //20240126
var i,S3FNo,T2017FNo: integer;
Begin
  //20250126
  S3FNo:=GetFormNo('S3');
  T2017FNo:=GetFormNo('T2017');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
	{Part 1}
  Tv[1] := Ret[RetNo].Lnn[22100];
  If Lnn[12600] <0 then Tv[2] :=ABS(Lnn[12600]) else Tv[2] :=0;
  If Lnn[12200] <0 then Tv[3] :=ABS(Lnn[12200]) else Tv[3] :=0;
  Tv[4] := Ret[RetNo].Lnn[25100];
  Tv[5] := Ret[RetNo].Lnn[22400] * 0.50;
  Tv[7] := MinR(Vl(FetchElm(RetNo,'T936',140)),Lnn[25300]);
	Tv[9] := 0;
	for i := 1 to 7 do Tv[9] := Tv[9] + Tv[i]; //20200125
	//Tv[9] := Tv[8];
  {Part 2}
  Tv[10] := Lnn[12000] + Lnn[12100];
  If Lnn[12600] >0 then Tv[11] :=Lnn[12600] else Tv[11] :=0;
  If Lnn[12200] >0 then Tv[12] :=Lnn[12200] else Tv[12] :=0;
	{?t936-1 recovery of expl.. Tv[14] := Lnn[13000] * 0.50;}
  //20250430
  Tv[24]:=TotMultiple(RetNo,'T3MULT',100);
  Tv[35]:=Tv[24]+Tv[26]+Tv[28]+Tv[33];
  Tv[13]:=Tv[35];
  Tv[15] := Vl(FetchElm(RetNo,'T936',140));
	Tv[17] := 0;
	for i := 10 to 15 do Tv[17] := Tv[17] + Tv[i];
  end;

  // pg 2 comments

  //pg 3  //20260108
   with Ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
        {Part 3}
        Tv[142] := Tv[9];
        Tv[143] := Vl(FetchElm(RetNo,'CFR',29));
        Tv[36]:=Tv[142]+Tv[143];
       // Tv[37]:=
        Tv[16]:=Tv[36]-Tv[37];  //??  if neg?
        Tv[20]:=Tv[16];
        Tv[21]:=Tv[17];

        //Tv[43]:=Tv[21];
        //Tv[43]:=Tv[21];
        Tv[44] := Vl(FetchElm(RetNo,'CFR',30));
        Tv[45]:=Tv[21]+Tv[44];
        Tv[46]:=Tv[45];
        Tv[150] := MaxR(0,(Tv[20] - Tv[46]));

   //pg 4   //20260108
       Tv[101]:=Vl(FetchElmFNo(RetNo,S3FNo,339)); //339)); //20250412
       if Tv[101]<>0 then
       Begin
         Tv[38]:= TotMultiple(RetNo,'T2048',63); //jz//20260128 - adjust elm, total all instances
         Tv[39]:=Tv[101]-Tv[38];
         //Tv[102]:=Vl(FetchElmFNo(RetNo,S3FNo,106));
         {
         Tv[18]:=Vl(FetchElmFNo(RetNo,S3FNo,114));
         Tv[19]:=Vl(FetchElmFNo(RetNo,S3FNo,122));
         Tv[47]:=Vl(FetchElm(RetNo,'T2017',40));
         }
         Tv[30]:=Vl(FetchElmFNo(RetNo,S3FNo,173));
         Tv[31]:=Vl(FetchElmFNo(RetNo,S3FNo,186));
         //Tv[18]:=Vl(FetchElmFNo(RetNo,S3FNo,173));
         Tv[32]:=Vl(FetchElmFNo(RetNo,S3FNo,195));
         Tv[34]:=Tv[30]+Tv[31]+Tv[32];
         If Vl(FetchElmFNo(RetNo,S3FNo,292))<>0 then
          Tv[48]:=Vl(FetchElm(RetNo,'T2017',44))+Vl(FetchElm(RetNo,'T2017',77));
         Tv[49]:=Tv[34]+Tv[48];
         Tv[8]:=Tv[49]*50/100;
         Tv[22]:=Tv[8];
         Tv[60]:=MaxR(0,Tv[39]-Tv[22]);
         if Tv[60]=0 then
          begin
          for i:=134 to 136 do Tv[i]:=0;
          Tv[42]:=0;
          Tv[23]:=0;
          Tv[139]:=0;
          end;
         Tv[8]:=Tv[49]*50/100;
         Tv[22]:=TV[8];
         Tv[60]:=MaxR(0,Tv[291]-Tv[22]);
         Tv[60]:=MaxR(0,Tv[101]-Tv[22]); //jz//20250406 - is [101] not [291]
         if Tv[60]=0 then
         Begin
          For i:=134 to 136 do Tv[i]:=0;
          Tv[23]:=0;
          Tv[139]:=0;
          Tv[140]:=0;
         End
         Else
         begin
          Tv[134]:=SumT3MultBox(RetNo,82);  //box 21
          Tv[135]:=SumT3MultBox(RetNo,88);  //box 30
          Tv[136]:=Tv[134]-Tv[135];
          Tv[42]:=50;
          Tv[23]:=Tv[136]*Tv[42]/100;  //20250429
          Tv[139]:=Tv[23];
          Tv[140]:=MaxR(0,Tv[60]-tv[139]);
         end;
       End //tv[101] <> 0;
       Else
       Begin
        for i:=134 to 136 do Tv[i]:=0;
        Tv[42]:=0;
        Tv[23]:=0;
        Tv[139]:=0;
       End;
   end;
	{save data}
	SaveTv(RetNo,FName,FNo);
End;
*)
(* //20250207
Procedure T936(RetNo:integer;FName:string;FNo:integer); //20240126
var i,S3FNo,T2017FNo: integer;
Begin
  //20250126
  S3FNo:=GetFormNo('S3');
  T2017FNo:=GetFormNo('T2017');
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo], ret[RetNo].Frm[FNo] do
  begin
	{Part 1}
  Tv[1] := Ret[RetNo].Lnn[22100];
  If Lnn[12600] <0 then Tv[2] :=ABS(Lnn[12600]) else Tv[2] :=0;
  If Lnn[12200] <0 then Tv[3] :=ABS(Lnn[12200]) else Tv[3] :=0;
  Tv[4] := Ret[RetNo].Lnn[25100];
  Tv[5] := Ret[RetNo].Lnn[22400] * 0.50;
  Tv[7] := MinR(Vl(FetchElm(RetNo,'T936',140)),Lnn[25300]);
	Tv[9] := 0;
	for i := 1 to 7 do Tv[9] := Tv[9] + Tv[i]; //20200125
	//Tv[9] := Tv[8];
  {Part 2}
  Tv[10] := Lnn[12000] + Lnn[12100];
  If Lnn[12600] >0 then Tv[11] :=Lnn[12600] else Tv[11] :=0;
  If Lnn[12200] >0 then Tv[12] :=Lnn[12200] else Tv[12] :=0;
	{?t936-1 recovery of expl.. Tv[14] := Lnn[13000] * 0.50;}

  Tv[15] := Vl(FetchElm(RetNo,'T936',140));
	Tv[17] := 0;
	for i := 10 to 15 do Tv[17] := Tv[17] + Tv[i];
  end;

  //pg 2
   with Ret[RetNo], ret[RetNo].Frm[FNo] do
   begin
        {Part 3}
        Tv[142] := Tv[9]; //lm(RetNo,'T936',9));
        Tv[143] := Vl(FetchElm(RetNo,'CFR',29));
        Tv[16]:=Tv[142]+Tv[143];
        Tv[20]:=Tv[16];
        Tv[21]:=Tv[17];
        Tv[43]:=Tv[21];
        Tv[43]:=Tv[21];
        Tv[44] := Vl(FetchElm(RetNo,'CFR',30));
        Tv[45]:=Tv[21]+Tv[44];
        Tv[46]:=Tv[45];
        Tv[150] := MaxR(0,(Tv[20] - Tv[46]));

        Tv[101]:=Vl(FetchElmFNo(RetNo,S3FNo,339));
        if Tv[101]<>0 then
        Begin
         Tv[102]:=Vl(FetchElmFNo(RetNo,S3FNo,173));
         Tv[18]:=Vl(FetchElmFNo(RetNo,S3FNo,186));
         Tv[19]:=Vl(FetchElmFNo(RetNo,S3FNo,195));
         Tv[47]:=Vl(FetchElm(RetNo,'T2017',40));
         Tv[30]:=Vl(FetchElmFNo(RetNo,S3FNo,106));
         Tv[31]:=Vl(FetchElmFNo(RetNo,S3FNo,114));
         Tv[18]:=Vl(FetchElmFNo(RetNo,S3FNo,173));
         Tv[32]:=Vl(FetchElmFNo(RetNo,S3FNo,173));
         Tv[34]:=Tv[102]+Tv[18]+Tv[19]+Tv[47]+Tv[30]+Tv[31]+Tv[32];
         If Vl(FetchElmFNo(RetNo,S3FNo,292))<>0 then
         begin
          Tv[48]:=Vl(FetchElm(RetNo,'T2017',44))
                 +Vl(FetchElm(RetNo,'T2017',77));
         end;
         Tv[49]:=Tv[34]-Tv[48];
         Tv[50]:=Vl(FetchElmFNo(RetNo,S3FNo,305));
         Tv[51]:=Tv[49]-Tv[50];
         Tv[52]:=Vl(FetchElmFNo(RetNo,S3FNo,304));
         Tv[53]:=Tv[51]-Tv[52];
         Tv[54]:=Vl(FetchElmFNo(RetNo,S3FNo,333));
         Tv[55]:=Tv[53]*Tv[54]/100;
         Tv[56]:=Vl(FetchElmFNo(RetNo,S3FNo,335));
         Tv[57]:=Vl(FetchElmFNo(RetNo,S3FNo,337));
         Tv[59]:=MaxR(0,Tv[55]+Tv[56]+Tv[57]);
         Tv[58]:=Tv[59];
         Tv[60]:= Tv[101]-Tv[58];
        End
        Else  //line 1 is zero
        Begin
         Tv[102]:=0;
         Tv[47]:=0;
         for i:=30 to 32 do Tv[i]:=0;
         Tv[34]:=0;
         for i:=18 to 19 do Tv[i]:=0;
         Tv[34]:=0;
         for i:=48 to 58 do Tv[i]:=0;
        End;

        Tv[134]:= SumT3MultBox(RetNo,82);  //box 21
        Tv[135] :=SumT3MultBox(RetNo,88);  //box 30
        Tv[136]:=Tv[134]-Tv[135];
        Tv[42]:=Vl(FetchElmFNo(RetNo,S3FNo,333));
        Tv[22]:=Tv[136];
        Tv[23]:=Tv[22]*(1/2);
        Tv[139]:=Tv[23];
        Tv[140]:=MaxR(0,Tv[60]-Tv[139]);

   end;
	{save data}
	SaveTv(RetNo,FName,FNo);
End;
*)

(*
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
  AssignFile(F1, FileNm);
  Reset(F1);

  FirstTimeSw := true;
  LineCnt:=0;PageCnt :=0;MxLinesPerPage :=60;
  {now print}
  Printer.BeginDoc;
  XPos := 70;
  ScMult :=10;
  PageX:= Printer.PageWidth;
  PageY :=Printer.PageHeight;
  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
  ScaleY := (PageY * ScMult) div 1000; {formheight}

  Repeat
   If (FirstTimeSw) or (LineCnt >MxLinesPerPage) then
   begin  {print headers}
     LineCnt:=1;
     Inc(PageCnt);
     If not FirstTimeSw then Printer.NewPage;

     Printer.Canvas.Font.Name := 'Arial';
     Printer.Canvas.Font.Size := 10;
     Printer.Canvas.Font.Style := [fsBold];
     Printer.Canvas.TextOut(
       (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
        Hdr1+' Page: '+IntToStr(PageCnt));

     Inc(LineCnt); {leave empty line}
     Printer.Canvas.Font.Name := 'Courier New';
     Printer.Canvas.Font.Size := 8;
     Printer.Canvas.Font.Style := [];
     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr2);

     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr3);
     Inc(LineCnt,1);
   end; {headers}
   FirstTimeSw := False;
   Printer.Canvas.Font.Style := [];
   Readln(F1,s);
   Printer.Canvas.TextOut(
    (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
          s);
   Inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  Result := True;
end;
*)
Function FindAnySpouseRetNo:Integer;
Var I,RNo:integer;
begin
 Result := 0;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   Rno := RetRec.RetNo;
   If Ret[RNo].MarStatus <3 then
    begin Result := RNo;exit;end;
 end;
end;

Function FindReturnNoFromSin(S:String):Integer;
Var I,RNo:integer;
begin
 Result := 0;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   if assigned(RetRec) then  //20160301 Igor
   Begin
     Rno := RetRec.RetNo;
     If FetchElmFNo(RNo,1,3) = S then
     begin
       Result := RNo;
       exit;
     end;
   End;
 end;
end;

(* 20110129
Function GetTotalFee(RetNo:Integer):Real;
Var I:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo].FrmHasData[Frec.FormNo] then
    If Frec.FormInst >'#1' then
     Result := Result+ Vl(FRec.Fee) //Vl(FRec.Each_Item) 20090104
    else
     Result := Result+ Vl(FRec.Fee);
 end;
 Result:=Result+CalcInvSurcharge(RetNo);
end;
*)

Procedure InitCCARates;
Var TempList :TstringList;
I :integer;
begin
  TempList := TStringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'CCARATES.D');
  try
    For i:=0 to TempList.Count-1 do
      begin
      CCaClasses[i+1] := RTrim(LeftStr(TempList[i],4));
      CCaRates[i+1] := MidStr(TempList[i],6,3);
      end;
  finally
    freeAndNil(TempList); //20160720 Igor
  end;
end;

Function GetCCARate(Cls:string):String;
Var I:integer;
begin
 Result :='';
 For i :=1 to High(CCAClasses) do
   If Rtrim(Cls) = Ltrim(Rtrim(CCAClasses[i])) then
     begin Result := Ltrim(RTrim(CCARates[i]));exit;end;
end;

Procedure T4SUM(RetNo:integer;FName:string;FNo:integer); //20170417 Igor
var i,j,jj,SlipFNo,LineCnt,T4Cnt,T5Cnt,T3Cnt,T4ACnt,T4RSPCnt,T4RIFCnt: integer;
    T4AOASCnt,T4APCnt,T4ECnt,T4PSCnt,T5007Cnt:Integer;

const
  MaxElement = 104;

procedure PreparePage;
var
  x: Integer;
begin
  LoadTv(RetNo,FName,FNo);
  For x := 1 to MaxElement do
    Ret[RetNo].Frm[FNo].strings[x] := '';
end;

procedure DonePage;
begin
  SaveTv(RetNo, FName, FNo);
end;

procedure DeleteUnusedPage;
var
  X: Integer;
  MaxInst: Integer;
  R: TFRecArray;
begin
  R := FList.GetAllInstForms(ExtractNonInstFormName(FName));
  MaxInst := ExtractFormInstNo(FName);
  for X := 0 to Length(R) - 1 do
    if R[X].InstNo > MaxInst then
      ClearForm(RetNo, R[X].FormInstName);
end;

procedure PrepareLine; //20170417 Igor
begin
  Inc(LineCnt);
  j := LineCnt * 2 + 1;
  if J > MaxElement  then
  Begin
    DonePage;
    FName := ExtractNonInstFormName(FName) + '#' + IntToStr(ExtractFormInstNo(FName) + 1);
    FNo := RetList[RetNo].GetFormNo(FName);
    if FNo = 0 then
      FNo := RetList[RetNo].AddPageInstance(ExtractNonInstFormName(FName),
        '#' + IntToStr(ExtractFormInstNo(FName)));

    LineCnt := 0;
    J := 1;
    PreparePage;
  End;
end;

Begin
 If ShowUnconvertedLastYear(RetNo) then exit;
 If RightStr(Fname,2) > '#1' then exit;     //only one page supported why?
 FormatSettings.DecimalSeparator:='.';
 UpdateAllDataIndicators(RetNo);
//20170417 Igor>>>
 PreparePage;
// LoadTv(RetNo,FName,FNo);
// For i:=1 to 104 do Ret[RetNo].Frm[FNo].strings[i] :='';
//20170417 Igor <<<
 LineCnt := -1; //20170417 Igor
 ClearT4SumTotal;
 CountSlips(RetNo,T4Cnt,T4ACnt,T5Cnt,T3Cnt,
          T4RIFCnt,T4RSPCnt,
          T4AOASCnt,T4APCnt,T4ECnt,
          T4PSCnt,T5007Cnt);
 {show T4 list}
 If T4Cnt >0 then
 begin
   ClearT4SumTotal;
   PrepareLine;
   T4Header1(RetNo,FNo,j);
   PrepareLine;
   T4Header2(RetNo,FNo,j,T4Cnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
           PrepareLine;
           T4Details(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end; {end t4}


 {show T5mult list}
 If T5Cnt >0 then
 begin
   ClearT4SumTotal;
   PrepareLine;
   T5Header1(RetNo,FNo,j);
   PrepareLine;
   T5Header2(RetNo,FNo,j,T5Cnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T5MULT') and (Ret[RetNo].FrmHasData[SlipFNo])
      then
         begin
          For jj:=131 to 135 do
          begin
           If FetchElmFNo(RetNo,SlipFNo,jj)>'' then
           begin
             //March 5 2008
             If ((jj=131) and (Vl(FetchElmFNo(RetNo,SlipFNo,2))>0))
             or ((jj=132) and (Vl(FetchElmFNo(RetNo,SlipFNo,24))>0))
             or ((jj=133) and (Vl(FetchElmFNo(RetNo,SlipFNo,46))>0))
             or ((jj=134) and (Vl(FetchElmFNo(RetNo,SlipFNo,68))>0))
             or ((jj=135) and (Vl(FetchElmFNo(RetNo,SlipFNo,90))>0))
             then
             begin
              PrepareLine;
              T5MultDetails(RetNo,FNo,j,jj,SlipFNo);
             end;
           end;
          end;
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end; {end slips}


 (*
 {show T3 list  SINGLE}
 If T3Cnt >0 then
 begin
   ClearT4SumTotal;
   Inc(LineCnt);j:= LineCnt * 2 +1;
   T3Header1(RetNo,FNo,j);
   Inc(LineCnt); j:= LineCnt * 2 +1;
   T3Header2(RetNo,FNo,j,T3Cnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T3') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          If Vl(FetchElmFNo(RetNo,SlipFNo,2))>0 then  //march 5 2008
          begin
           Inc(LineCnt);j:=LineCnt*2+1;
           T3Details(RetNo,FNo,j,SlipFNo);
          end;
         end;
   end; {for i}
   Inc(LineCnt);j:=LineCnt*2+1;
   TotLine(RetNo,FNo,J);
   Inc(LineCnt);j:=LineCnt*2+1;
 end; {end slips}
*)

 //t3 mult
 If T3Cnt >0 then
 begin
   ClearT4SumTotal;
   PrepareLine;
   T3Header1(RetNo,FNo,j);
   PrepareLine;
   T3Header2(RetNo,FNo,j,T3Cnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T3MULT') and (Ret[RetNo].FrmHasData[SlipFNo])
      then
         begin
          For jj:=233 to 237 do
          begin
           If FetchElmFNo(RetNo,SlipFNo,jj)>'' then
           begin
             If ((jj=233) and (Vl(FetchElmFNo(RetNo,SlipFNo,35))>0))
             or ((jj=234) and (Vl(FetchElmFNo(RetNo,SlipFNo,36))>0))
             or ((jj=235) and (Vl(FetchElmFNo(RetNo,SlipFNo,37))>0))
             or ((jj=236) and (Vl(FetchElmFNo(RetNo,SlipFNo,38))>0))
             or ((jj=237) and (Vl(FetchElmFNo(RetNo,SlipFNo,39))>0))
             then
             begin
              PrepareLine;
              T3MultDetails(RetNo,FNo,j,jj,SlipFNo);
             end;
           end;
          end;
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end; {end slips}

 {show T4A list}
 If T4ACnt >0 then
 begin
   ClearT4SumTotal;
   PrepareLine;
   T4AHeader1(RetNo,FNo,j);
   PrepareLine;
   T4AHeader2(RetNo,FNo,j,T4ACnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4A') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T4ADetails(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end; {end slips}

  {show T4RIF list}
 If T4RIFCnt >0 then
 begin
   ClearT4SumTotal;
   PrepareLine;
   T4RIFHeader1(RetNo,FNo,j);
   PrepareLine;
   T4RIFHeader2(RetNo,FNo,j,T4RIFCnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4RIF') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T4RIFDetails(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end; {end slips}

 {show T4RSP list}
 If T4RSPCnt >0 then
 begin
   ClearT4SumTotal;
   PrepareLine;
   T4RSPHeader1(RetNo,FNo,j);
   PrepareLine;
   T4RSPHeader2(RetNo,FNo,j,T4RSPCnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4RSP') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T4RSPDetails(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end;
 {show T4OAS list}
 If T4AOASCnt >0 then
 begin
   ClearT4AOASSumTotal;
   PrepareLine;
   T4AOASHeader1(RetNo,FNo,j);
   PrepareLine;
   T4AOASHeader2(RetNo,FNo,j,T4AOASCnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4AOAS') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T4AOASDetails(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end;

 {show T4AP list}
 If T4APCnt >0 then
 begin
   ClearT4ApSumTotal;
   PrepareLine;
   T4APHeader1(RetNo,FNo,j);
   PrepareLine;
   T4APHeader2(RetNo,FNo,j,T4APCnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4AP') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T4APDetails(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end;

 {show T4E list}
 If T4ECnt >0 then
 begin
   ClearT4ESumTotal;
   PrepareLine;
   T4EHeader1(RetNo,FNo,j);
   PrepareLine;
   T4EHeader2(RetNo,FNo,j,T4ECnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4E') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T4EDetails(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end;

 If T4PSCnt >0 then
 begin
   ClearT4PSSumTotal;
   PrepareLine;
   T4PSHeader1(RetNo,FNo,j);
   PrepareLine;
   T4PSHeader2(RetNo,FNo,j,T4PSCnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T4PS') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T4PSDetails(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
   PrepareLine;
 end;

 If T5007Cnt >0 then
 begin
   ClearT5007SumTotal;
   PrepareLine;
   T5007Header1(RetNo,FNo,j);
   PrepareLine;
   T5007Header2(RetNo,FNo,j,T5007Cnt);
   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
      if (FRec.FormName = 'T5007') and (Ret[RetNo].FrmHasData[SlipFNo]) then
         begin
          PrepareLine;
          T5007Details(RetNo,FNo,j,SlipFNo);
         end;
   end; {for i}
   PrepareLine;
   TotLine(RetNo,FNo,J);
 end;
//20170417 Igor >>>
 DonePage;
 DeleteUnusedPage;
// SaveTv(RetNo,FName,FNo);
//20170417 Igor <<<
End;


Procedure TotLine(RetNo:Integer;FNo:integer;J:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] :=''; Strings[j+1] :='';
   Strings[j]   := '          Total';
   Strings[j+1] := FormatSlSum(Tot[1])
    +FormatSlSum(Tot[2])
    +FormatSlSum(Tot[3])
    +FormatSlSum(Tot[4])
    +FormatSlSum(Tot[5])
    +FormatSlSum(Tot[6])
    +FormatSlSum(Tot[7]);

 end;
end;

Procedure T4Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4 Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] := JustRight('Box 14',Cw)
                  +JustRight('Box 16/17',Cw)
                  +JustRight( 'Box 18',Cw)
                  +JustRight( 'Box 20',Cw)
                  +JustRight( 'Box 22',Cw)
                  +JustRight( 'Box 24',Cw)
                  +JustRight( 'Box 44/46',Cw);
 end;
end;

Procedure T4Header1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] :=JustRight('Gross',Cw)
   +JustRight('CPP/QPP',Cw)
   +JustRight('EI',Cw)
   +JustRight('RPP',Cw)
   +JustRight('Tax',Cw)
   +JustRight('EI Earn',Cw)
   +JustRight('Union/Don',Cw);
  end;
end;

Procedure T4AOASHeader1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] :=JustRight('Taxable',Cw)
   +JustRight('Gross',Cw)
   +JustRight('Overpayment',Cw)
   +JustRight('Net Suppl',Cw)
   +JustRight('Tax',Cw);
  end;
end;
Procedure T4AOASHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:Integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4AOAS Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] := JustRight('Box 18',Cw)
                  +JustRight('Box 19',Cw)
                  +JustRight( 'Box 20',Cw)
                  +JustRight( 'Box 21',Cw)
                  +JustRight( 'Box 22',Cw);
 end;
end;

Procedure T4AOASDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:Real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,1),2);
       x:= Vl(FetchElmFNo(RetNo,SlipFNo,2));

       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,10));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,4));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,3));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;
  end;
 end;


Procedure T4Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:Real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,1),19);
       x:= Vl(FetchElmFNo(RetNo,SlipFNo,2));

       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,3))+Vl(FetchElmFNo(RetNo,SlipFNo,4));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,5));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,6));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,8));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,9));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,14))+Vl(FetchElmFNo(RetNo,SlipFNo,15));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;

  end;
 end;


Function FormatSlSum(x:real):string;
begin
 If x = 0 then
  result := JustRight(FormatFloat('##,###,###.##',x),Cw)
 else
  Result :=JustRight(FormatFloat('##,###,###.00',x),Cw);
end;

Procedure T5Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T5 Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] := JustRight('Box 11/25',Cw)
    +JustRight('Box 13',Cw)
    +JustRight('Box 14',Cw)
    +JustRight('Box 15',Cw)
    +JustRight('Box 16',Cw)
    {
    +JustRight('Box 40',Cw)
    +JustRight('Box 41',Cw)
    }
    +JustRight('Box 18',Cw)
    +JustRight('Box 19',Cw);
  end;
end;

Procedure T5Header1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] := JustRight('TaxableDiv.',Cw)
    +JustRight('Interest',Cw)
    +JustRight('OtherInc',Cw)
    +JustRight('ForeignInc',Cw)
    +JustRight('ForeignTax',Cw)
    {+JustRight('CapGainsP1',Cw)
    +JustRight('CapGainsP2',Cw)}
    +JustRight('CapGains',Cw)
    +JustRight('AccrAnnuity',Cw)
  end;
end;

Procedure T4APHeader1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] :=JustRight('TaxableCPP',Cw)
    +JustRight('IncTax',Cw)
    +JustRight('Retirement',Cw)
    +JustRight('Survivor',Cw)
    +JustRight('Disability',Cw)
    +JustRight('ChildBenefit',Cw)
    +JustRight('DeathBenefit',Cw);
  end;
end;

Procedure T5007Header1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] :=
     JustRight('W/C Benefit',Cw)
    +JustRight('SocialAssist',Cw);
  end;
end;


Procedure T4PSHeader1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] :=
     JustRight('EligDiv',Cw)
    +JustRight('CapGain/loss',Cw)
    +JustRight('OthIncome',Cw)
    +JustRight('Forfeited',Cw)
    +JustRight('NonEligDiv',Cw)
    +JustRight('ForeinNonBus',Cw)
    +JustRight('ForeignCapG',Cw)
    +JustRight('ForNonBusTax',Cw);
  end;
end;


Procedure T4APHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4AP Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] :=
     JustRight('Box 20',Cw)
    +JustRight('Box 22',Cw)
    +JustRight('Box 14',Cw)
    +JustRight('Box 15',Cw)
    +JustRight('Box 16',Cw)
    +JustRight('Box 17',Cw)
    +JustRight('Box 18',Cw);
  end;
end;

Procedure T5007Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T5007 ('+IntTostr(SlipCnt)+')';
   Strings[j+1] :=
     JustRight('Box 10',Cw)
    +JustRight('Box 11',Cw);
  end;
end;


Procedure T4PSHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4PS Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] :=
     JustRight('Box 31',Cw)
    +JustRight('Box 34',Cw)
    +JustRight('Box 35',Cw)
    +JustRight('Box 36',Cw)
    +JustRight('Box 25',Cw)
    +JustRight('Box 37',Cw)
    +JustRight('Box 38',Cw)
    +JustRight('Box 39',Cw);
  end;
end;

Procedure T5Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,1),19);
       If Vl(FetchElmFNo(RetNo,SlipFNo,2))>0 then
         Strings[j] := LeftStr(Strings[j],12)+' '+
         Ltrim(FetchElmFNo(RetNo,SlipFNo,2))+'%';

       x:= Vl(FetchElmFNo(RetNo,SlipFNo,6));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,8));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,9));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,10));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,12));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,13));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;

  end;
 end;

Procedure T4APDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       x:= Vl(FetchElmFNo(RetNo,SlipFNo,4));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,11));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,14));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,13));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,16));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,15));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;
  end;
 end;


Procedure T5007Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       x:= Vl(FetchElmFNo(RetNo,SlipFNo,2));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,3));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;
  end;
 end;


Procedure T4PSDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       x:= Vl(FetchElmFNo(RetNo,SlipFNo,2));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,3));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,5));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,6));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,4));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,8));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,9));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[8] := Tot[8]+x;
  end;
 end;


Procedure T4EDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       x:= Vl(FetchElmFNo(RetNo,SlipFNo,2));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,8));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,6));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,13));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,9));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,3));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,14));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,10));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[8] := Tot[8]+x;
  end;
 end;




 Procedure ClearT4SumTotal;
 Var I:integer;
 begin
   For i:=1 to 9 do Tot[i] :=0;
 end;

 Procedure ClearT5007SumTotal;
 Var I:integer;
 begin
   For i:=1 to 9 do Tot[i] :=0;
 end;


 Procedure ClearT4ESumTotal;
 Var I:integer;
 begin
   For i:=1 to 9 do Tot[i] :=0;
 end;


 Procedure ClearT4APSumTotal;
 Var I:integer;
 begin
   For i:=1 to 9 do Tot[i] :=0;
 end;

Procedure ClearT4PSSumTotal;
 Var I:integer;
 begin
   For i:=1 to 9 do Tot[i] :=0;
 end;

Procedure ClearT4AOASSumTotal;
 Var I:integer;
 begin
   For i:=1 to 9 do Tot[i] :=0;
 end;


Procedure T3Header2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T3 Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] := JustRight('Box 21',Cw)
    +JustRight('Box 22',Cw)
    +JustRight('Box 25',Cw)
    +JustRight('Box 26',Cw)
    +JustRight('Box 31',Cw)
    +JustRight('Box 32/50',Cw)
    +JustRight('Box 34',Cw);
  end;
end;

Procedure T4EHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4E Slips ('+IntTostr(SlipCnt)+')';
    Strings[j+1] :=
     JustRight('Box 14',Cw)
    +JustRight('Box 15',Cw)
    +JustRight('Box 17',Cw)
    +JustRight('Box 20',Cw)
    +JustRight('Box 21',Cw)
    +JustRight('Box 22',Cw)
    +JustRight('Box 18',Cw)
    +JustRight('Box 30',Cw);
  end;
end;


Procedure T3Header1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] := JustRight('CapGains',Cw)
    +JustRight('Lump-sumPens',Cw)
    +JustRight('FrgnNonBInc',Cw)
    +JustRight('OtherIncome',Cw)
    +JustRight('PensIncome',Cw)
    +JustRight('TaxableDiv',Cw)
    +JustRight('ForeignTax',Cw);
  end;
end;

Procedure T4EHeader1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] :=
     JustRight('TotBenefits',Cw)
    +JustRight('Reg/Other',Cw)
    +JustRight('EmplBenefits',Cw)
    +JustRight('TxblTuition',Cw)
    +JustRight('NonTxTuition',Cw)
    +JustRight('IncomeTax',Cw)
    +JustRight('TaxExempt',Cw)
    +JustRight('Repaid',Cw)
  end;
end;

(*
Procedure T3Details(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,1),19);
       If Vl(FetchElmFNo(RetNo,SlipFNo,2))>0 then
         Strings[j] := LeftStr(Strings[j],12)+' '+
         Ltrim(FetchElmFNo(RetNo,SlipFNo,2))+'%';

       x:= Vl(FetchElmFNo(RetNo,SlipFNo,6));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,9));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,10));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,12));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,13))+Vl(FetchElmFNo(RetNo,SlipFNo,26));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,15));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;
  end;
 end;
*)


Procedure T3MultDetails(RetNo:integer;FNo:integer;j,jj:integer;SlipFNo:Integer);
Var x:real;k:Integer;
//jj is the field shoing the indicator that slip is used
begin
 k:= jj-232-1; //% used by taxpayer field  initially 0
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,17+K),19);
       If Vl(FetchElmFNo(RetNo,SlipFNo,k+35))>0 then //%
         Strings[j] := LeftStr(Strings[j],12)+' '+
         Ltrim(FetchElmFNo(RetNo,SlipFNo,k+35))+'%';

       x:= Vl(FetchElmFNo(RetNo,SlipFNo,77+k));  //cap gains 21
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,101+K));                 //box22
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,113+k));    //box 25
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,95+k));   //box 26
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,119+k));     //box 31
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,89+k))+Vl(FetchElmFNo(RetNo,SlipFNo,71+k));  //box 32 and 50
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,131+k));   //box 34
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;
  end;
 end;

 Procedure T5MultDetails(RetNo:integer;FNo:integer;j,jj:integer;SlipFNo:Integer);
//j is the summury line cnt jj is the indic that slip is used
Var x:real; k:Integer;
begin
 k:=jj-130-1;  //slip column i.e slip one has a factor of 0
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,1+K*22),19);
       If Vl(FetchElmFNo(RetNo,SlipFNo,2+K*22))>0 then
         Strings[j] := LeftStr(Strings[j],12)+' '+
         Ltrim(FetchElmFNo(RetNo,SlipFNo,2+K*22))+'%';

       x:= Vl(FetchElmFNo(RetNo,SlipFNo,6+K*22))
          + Vl(FetchElmFNo(RetNo,SlipFNo,141+K*1));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7+K*22));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,8+K*22));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,9+K*22));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,10+K*22));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,12+K*22));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,13+K*22));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;

  end;
 end;


Procedure T4AHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4A Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] :=
     JustRight('Box 016',Cw)
    +JustRight('Box 018',Cw)
    +JustRight('Box 022',Cw)
    +JustRight('Box 024',Cw)
    +JustRight('Box 020/048',Cw) //20110130
    +JustRight('Box 028',Cw)
    +JustRight('Box 026',Cw);
  end;
end;

Procedure T4AHeader1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] :=
     JustRight('Pension',Cw)
    +JustRight('Lump-sum',Cw)
    +JustRight('Tax',Cw)
    +JustRight('Annuities',Cw)
    +JustRight('Comm/Fees',Cw)
    +JustRight('OtherIncome',Cw)
    +JustRight('Elig/Retirem',Cw)
  end;
end;

Procedure T4ADetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,81),19); //20110301

       x:= Vl(FetchElmFNo(RetNo,SlipFNo,1));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,2));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,4));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,5));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,3))+Vl(FetchElmFNo(RetNo,SlipFNo,62));//Vl(FetchElmFNo(RetNo,SlipFNo,7)); //20110130
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7));         //20110130
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,6));         //20110130
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;

       {20110130
       x:=Vl(FetchElmFNo(RetNo,SlipFNo,10));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;
       }
  end;
 end;

Procedure T4RSPHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4RSP Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] := JustRight('Box 16',Cw)
    +JustRight('Box 20',Cw)
    +JustRight('Box 22',Cw)
    +JustRight('Box 26',Cw)
    +JustRight('Box 28',Cw)
    +JustRight('Box 30',Cw)
    +JustRight('Box 34',Cw);
  end;
end;

Procedure T4RSPHeader1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] := JustRight('Annuity',Cw)
    +JustRight('RefundContr.',Cw)
    +JustRight('Withdrawal',Cw)
    +JustRight('Deregistr',Cw)
    +JustRight('OtherIncome',Cw)
    +JustRight('Tax',Cw)
    +JustRight('Recpt-death',Cw);
  end;
end;

Procedure T4RSPDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,1),19);

       x:= Vl(FetchElmFNo(RetNo,SlipFNo,2));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,5));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,6));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,8));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,9));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,11));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,12));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;
  end;
 end;

Procedure T4RIFHeader2(RetNo:integer;FNo:integer;j:integer;SlipCnt:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j] := 'T4RIF Slips ('+IntTostr(SlipCnt)+')';
   Strings[j+1] := JustRight('Box 16',Cw)
    +JustRight('Box 18',Cw)
    +JustRight('Box 20',Cw)
    +JustRight('Box 22',Cw)
    +JustRight('Box 24',Cw)
    +JustRight('Box 26',Cw)
    +JustRight('Box 28',Cw);
  end;
end;

Procedure T4RIFHeader1(RetNo:integer;FNo:integer;j:integer);
begin
 with Ret[RetNo].Frm[FNo] do
 begin
   Strings[j+1] := JustRight('AmountsTxble',Cw)
    +JustRight('Deceased',Cw)
    +JustRight('Deregistr',Cw)
    +JustRight('OtherIncome',Cw)
    +JustRight('ExcessAmount',Cw)
    +JustRight('Spousal',Cw)
    +JustRight('Tax',Cw);
  end;
end;

Procedure T4RIFDetails(RetNo:integer;FNo:integer;j:integer;SlipFNo:Integer);
Var x:real;
begin
 with Ret[RetNo].Frm[FNo] do
 begin
       Strings[j]   :=LeftStr(FetchElmFNo(RetNo,SlipFNo,1),19);

       x:= Vl(FetchElmFNo(RetNo,SlipFNo,2));
       Strings[j+1] :=FormatSlSum(x); Tot[1] := Tot[1]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,3));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[2] := Tot[2]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,4));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[3] := Tot[3]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,5));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[4] := Tot[4]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,8));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[5] := Tot[5]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,15));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[6] := Tot[6]+x;

       x:=Vl(FetchElmFNo(RetNo,SlipFNo,7));
       Strings[j+1] :=Strings[j+1]+FormatSlSum(x);Tot[7] := Tot[7]+x;
  end;
 end;


Procedure CountSlips(RetNo:integer;Var T4Cnt:integer;
          Var T4ACnt:integer;Var T5Cnt:integer;Var T3Cnt:Integer;
          Var T4RifCnt:integer;Var T4RspCnt:integer;
          Var T4AOASCnt:Integer;Var T4APCnt:Integer; Var T4ECnt:Integer;
          Var T4PSCnt:Integer; Var T5007Cnt:Integer);

Var I,slipFNo:integer;
begin
 T4Cnt :=0;T4ACnt:=0;T5Cnt:=0;T3Cnt:=0;T4RifCnt:=0;T4RspCnt:=0;
 T4AOASCnt:=0;T4APCnt:=0;T4ECnt:=0;T4PSCnt:=0;T5007Cnt:=0;
 for i :=0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[i];  SlipFNo :=Frec.FormNo;
    if Ret[RetNo].FrmHasData[SlipFNo] then
    begin
     If      FRec.FormName = 'T4'   then Inc(T4Cnt)
     else if FRec.FormName = 'T4A'  then Inc(T4ACnt)
    // else if FRec.FormName = 'T5'   then Inc(T5Cnt)
    // else if FRec.FormName = 'T3'   then Inc(T3Cnt)
     else if FRec.FormName = 'T4RSP'  then Inc(T4RspCnt)
     else if FRec.FormName = 'T4RIF'  then Inc(T4RIFCnt)

     else if FRec.FormName = 'T4AOAS'   then Inc(T4AOASCnt)
     else if FRec.FormName = 'T4AP'  then Inc(T4APCnt)
     else if FRec.FormName = 'T4E'  then Inc(T4ECnt)
     else if FRec.FormName = 'T4PS'   then Inc(T4PSCnt)
     else if FRec.FormName = 'T5007'  then Inc(T5007Cnt);
    end;
 end;
 T5Cnt:=T5Cnt+CountT5MultSlips(RetNo);
 T3Cnt:=T3Cnt+CountT3MultSlips(RetNo);
end;

Function CountT3MultSlips(RetNo:integer):integer;
Var I,j,FNo:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[i];
    FNo:=FRec.FormNo;
    If FRec.FormName = 'T3MULT'   then
    begin
      If Ret[RetNo].FrmHasData[FNo] then
      begin
        For j:=233 to 237 do
        begin
         If FetchElmFNo(RetNo,FNo,j) >'' then Inc(Result);
        end;
      end;
    end; //t3MULT
 end;
end;


Function CountT5MultSlips(RetNo:integer):integer;
Var I,j,FNo:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[i];
    FNo:=FRec.FormNo;
    If FRec.FormName = 'T5MULT'   then
    begin
      If Ret[RetNo].FrmHasData[FNo] then
      begin
        For j:=131 to 135 do
        begin
         If FetchElmFNo(RetNo,FNo,j) >'' then Inc(Result);
        end;
      end;
    end; //t5MULT
 end;
end;

(*
Procedure Tot1139(RetNo:Integer;Var ATv: array of Real);
Var i,j,FNo:integer;x:real;
begin
 For i:=Low(ATv) to High(ATv) do Atv[i] :=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   FNo := Frec.FormNo;
   If (Frec.FormName = 'T1139') and
      (Frec.FormInst>'') and
      (Ret[RetNo].FrmHasData[FNo]) then
    begin
     for j:=6 to 30 do ATv[j] := ATv[j]+Vl(FetchElmFNo(RetNo,FNo,j));
     If FetchElmFNo(RetNo,FNo,2) >'' then
      x:= Vl(fetchElmFNo(RetNo,FNo,17)) {which option}
     else
      x:= Vl(fetchElmFNo(RetNo,FNo,30));

     If      FetchElmFNo(RetNo,FNo,33)>'' then ATv[37] := ATv[37]+ x
     else If FetchElmFNo(RetNo,FNo,34)>'' then ATv[38] := ATv[38]+ x
     else If FetchElmFNo(RetNo,FNo,35)>'' then ATv[39] := ATv[39]+ x
     else If FetchElmFNo(RetNo,FNo,36)>'' then ATv[40] := ATv[39]+ x;
    end;
 end;   {Flist do}
end;
*)


Function CalcThisProvince(RetNo:Integer;Prv:String): Boolean;
Var spRetNo:Integer;i:integer; T2203FNo:Integer;
Begin
 Result := False;
 If (Prv = Ret[RetNo].Province)
 Or (FetchElmFNo(RetNo,InfoFNo,250)=Prv)  //20260505 //NR Taxable gains from a province
 then result :=True;

 //20220408
 if (Ret[RetNo].Province='ZZ')
 or (FetchElmFNo(RetNo,InfoFNo,189)>'')  //zero out prov tax //20220413
 then   //zeroout prvtax
 Begin
  Result:=False;
  Ret[RetNo].Lnn[47900]:=0;
  StoreElm(RetNo,GetFormNo('T1'),427,'');
  Exit;
 end; //20220407


 T2203FNo:=GetFormNo('T2203');  //20230508 relocated from above
 If IsMultJurisdiction(RetNo) then     //check income allocated
 begin
  If (Prv='NL') and (Vl(FetchElmFNo(RetNo,T2203FNo,7))>0) then
   begin Result:=True;Exit; end;
  If (Prv='PE') and (Vl(FetchElmFNo(RetNo,T2203FNo,14))>0) then
   begin Result:=True;Exit;end;
  If (Prv='NS') and (Vl(FetchElmFNo(RetNo,T2203FNo,21))>0) then
   begin Result:=True;Exit;end;
  If (Prv='NB') and (Vl(FetchElmFNo(RetNo,T2203FNo,28))>0) then
   begin Result:=True;Exit;end;
  If (Prv='QC') and (Vl(FetchElmFNo(RetNo,T2203FNo,35))>0) then
   begin Result:=True;Exit;end;
  If (Prv='ON') and (Vl(FetchElmFNo(RetNo,T2203FNo,42))>0) then
   begin Result:=True;Exit;end;
  If (Prv='MB') and (Vl(FetchElmFNo(RetNo,T2203FNo,49))>0) then
   begin Result:=True;Exit;end;
  If (Prv='SK') and (Vl(FetchElmFNo(RetNo,T2203FNo,56))>0) then
   begin Result:=True;Exit;end;
  If (Prv='AB') and (Vl(FetchElmFNo(RetNo,T2203FNo,63))>0) then
   begin Result:=True;Exit;end;
  If (Prv='BC') and (Vl(FetchElmFNo(RetNo,T2203FNo,70))>0) then
   begin Result:=True;Exit;end;
  If (Prv='YT') and (Vl(FetchElmFNo(RetNo,T2203FNo,77))>0) then
   begin Result:=True;Exit;end;
  If (Prv='NT') and (Vl(FetchElmFNo(RetNo,T2203FNo,84))>0) then
    begin Result:=True;Exit;end;    //20210405
  If (Prv='NU') and (Vl(FetchElmFNo(RetNo,T2203FNo,105))>0) then
   begin Result:=True;Exit;end;
  If (Prv='ZZ') and (Vl(FetchElmFNo(RetNo,T2203FNo,91))>0) then
   begin Result:=True;Exit;end;
 end;

 {NR with empl income in the province}
 If (IsNonResWithCanEmpl(RetNo))
 and (EmplIncInProv(RetNo,Prv)>0)
  then result:=True;

End;

Function GetBasicFedTax(RetNo:Integer;Prv:String): Real;
Begin
 Result :=Vl(FetchElm(RetNo,'T1',147)); //Vl(FetchElm(RetNo,'S1',109)); //20190922
end;

Function GetPrvNetIncome(RetNo:Integer;Prv:String): Real;
Begin
 Result := Ret[RetNo].Lnn[23600];
{
 If IsMultJurisdiction(RetNo) = false then
   Result := Ret[RetNo].Lnn[23600]
 else
  Result := Vl(FetchElm(RetNo,'T2203',GetPrvIndex(Prv)*7));
 }
End;

Function IsMultJurisdiction(RetNo:Integer): Boolean;
Begin
  Result := false;
  If FetchElm(RetNo,'T2203',110) > '' then result := true;
End;


Function GetMultPrvTax(RetNo:Integer;Prv:String): Real;
Begin
 result :=0;
 If      Prv = 'NL' then Result := Vl(FetchElm(RetNo,'NL428',3))
 else if Prv = 'PE' then Result := Vl(FetchElm(RetNo,'PE428',5))
 else if Prv = 'NS' then
  begin
  Result := Vl(FetchElm(RetNo,'NS428',50));
  If Prv = Ret[RetNo].Province then Result :=
     Vl(FetchElm(RetNo,'NS428',123));
  end
 else if Prv = 'NB' then Result := Vl(FetchElm(RetNo,'NB428',48))
 else if Prv = 'ON' then
   begin
   Result := Vl(FetchElm(RetNo,'ON428',54));
   If Prv = Ret[RetNo].Province then Result :=Vl(FetchElm(RetNo,'ON428',122));
   end
 else if Prv = 'MB' then
  begin
  Result := Vl(FetchElm(RetNo,'MB428',6));
  If Prv = Ret[RetNo].Province then Result :=Vl(FetchElm(RetNo,'MB428',145));
  end
 else if Prv = 'SK' then
  begin
  Result := Vl(FetchElm(RetNo,'SK428',14));
  If Prv = Ret[RetNo].Province then Result :=Vl(FetchElm(RetNo,'SK428',35));
  end
 else if Prv = 'AB' then
  begin
   Result := Vl(FetchElm(RetNo,'AB428',10));
   If Prv = Ret[RetNo].Province then Result :=Vl(FetchElm(RetNo,'AB428',17));
  end
 else if Prv = 'BC' then
  begin
   Result := Vl(FetchElm(RetNo,'BC428',47));
   If Prv = Ret[RetNo].Province then Result :=Vl(FetchElm(RetNo,'BC428',131));
  end
 else if Prv = 'NT' then Result := Vl(FetchElm(RetNo,'NT428',3))
 else if Prv = 'NU' then Result := Vl(FetchElm(RetNo,'NU428',6))
 else if Prv = 'YT' then Result := Vl(FetchElm(RetNo,'YT428',5));

End;

Function GetPrvPolit(RetNo:Integer;Prv:String): Real;
Begin
 result :=0;
 If Prv = Ret[RetNo].Province then
  result := Vl(FetchElm(RetNo,'POLIT',12));
 //jz//20260328//MJCERT2025 - better to handle MJ here than have it scattered
 if IsMultJurisdiction(RetNo) then
 begin
    if Prv = 'AB' then result := Vl(FetchElm(RetNo,'POLIT',45));
    if Prv = 'BC' then result := Vl(FetchElm(RetNo,'POLIT',46));
    if Prv = 'MB' then result := Vl(FetchElm(RetNo,'POLIT',47));
    if Prv = 'NS' then result := Vl(FetchElm(RetNo,'POLIT',48));
    if Prv = 'NB' then result := Vl(FetchElm(RetNo,'POLIT',49));
    if Prv = 'NL' then result := Vl(FetchElm(RetNo,'POLIT',50));
    if Prv = 'NT' then result := Vl(FetchElm(RetNo,'POLIT',51));
    if Prv = 'NU' then result := Vl(FetchElm(RetNo,'POLIT',52));
    if Prv = 'ON' then result := Vl(FetchElm(RetNo,'POLIT',53));
    if Prv = 'PE' then result := Vl(FetchElm(RetNo,'POLIT',54));
    if Prv = 'QC' then result := Vl(FetchElm(RetNo,'POLIT',55));
    if Prv = 'SK' then result := Vl(FetchElm(RetNo,'POLIT',56));
    if Prv = 'YT' then result := Vl(FetchElm(RetNo,'POLIT',57));
 end;
End;

Function GetWinIniString(IniFileName:String;Sect:String;Ident:String):String;
var
  SomeIniFile: TIniFile;
begin
  SomeIniFile := TIniFile.Create(IniFileName);
  Result :=SomeIniFile.ReadString(Sect,Ident, 'Not Found');
  SomeIniFile.Free;
end;

//20170728 Igor>>>
//Function MMDDYYYYToWinFormat(Dt:String):string;
//Var WinDateFormat:String;Sep:string[1];WinBootDir:String;
//begin
// Result :=Dt;
// WinBootDir:=GetWinBootDir;
// WinDateFormat := UpperCase(
//     GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sShortDate'));
// Sep := UpperCase(
//     GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sDate'));
//
// If LeftStr(WinDateFormat,1)='M' then   {to MMDDYY}
// begin
//  Result := Dt;exit;
// end
// else If LeftStr(WinDateFormat,1)='D' then   {to DDMMYY}
// begin
//  Result := MidStr(Dt,4,2)+Sep+LeftStr(Dt,2)+Sep+RightStr(Dt,4);
// end
// else If LeftStr(WinDateFormat,1)='Y' then {to YYMMDD}
// begin
//  Result :=RightStr(Dt,4)+Sep+LeftStr(Dt,2)+Sep+MidStr(Dt,4,2);
// end;
//
//end;
//20170728 Igor<<<

Function DtDiff(D1: string; D2 : string):Integer;
{D1,D2 in form YYYYMMDD}
Var
  Date1, Date2 : TDateTime;
begin
//20170728 Igor>>>
  if D1.IsEmpty or D2.IsEmpty then
    exit(0)
  else
  if not TryYYYYMMDDToDate(D1, Date1) or not TryYYYYMMDDToDate(D2, Date2) then
  begin
    MessageDlg('Invalid Date formats: ' + D1 + ' ' + D2, mtError, [mbOk], 0);
    exit(365);
  end
  else
    Result := DateDiff(Date2, Date1);

//  if (D1='') or (d2='') then begin result :=0;exit;end;
//  D1 := YYYYMMDDToWinFormat(D1);
//  D2 := YYYYMMDDToWinFormat(D2);
//  try
//  Date1 := StrToDateTime(D1);
//  Date2 := StrToDateTime(D2);
//  Result := StrToInt(FloatToStr(Date2-Date1))+1;
//  except
//   on exception do
//    begin
//   //  ShowTimedMsg('Invalid Date formats: '+D1+' '+D2,100);  //20110313
//    ShowMessage('Invalid Date formats: '+D1+' '+D2);  //20110313
//    result :=365; //date dirrence if dates wrong
//    end;
// end;
//20170728 Igor<<<
end;



Function PrintLabels(RetNo: integer;  DataDir,FileNm:String):boolean;
var
//  Tbl:TTable;
  FDConnection: TADConnection;
  Tbl: TADTable;
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap
     : Integer;
  Line1,Line2,Line3,Line4:String;
  PostalCd:String;
  PoBox,RR:String;
  FlName:String;
begin
 {Set up label parameters}

  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  TopMargin  := Trunc(0.5 *  PixPerInY);
  LeftMargin := Trunc(1/8 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
  LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}
  HorizLabelGap := Trunc(2/8 *  PixPerInX);

  {open the input file of keys}
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  {start printer}
  Printer.BeginDoc;
  { Get data from data base}
//  Tbl := TTable.Create(Application);
//  Tbl.DataBaseName := DataDir;
//  Tbl.TableName := 'CLIENTS.DBF';
//  Tbl.IndexName := 'FILE_NAME';
//  If Tbl.Active then Tbl.Close;
//  Tbl.Open;
  //20150916 Igor+
  FDConnection := TADConnection.Create(nil);
  Tbl := TADTable.Create(nil);
  if SetTableName(FDConnection, Tbl, DataDir + '\' + ClientsDbLite, ClientsTableLite, 'File_Name') then

  RecNo :=0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    //20170223 Igor >>>
    //if Tbl.FindKey([InpKey]) then
    if Tbl.Locate('FILE_NAME', InpKey, [loCaseInsensitive]) then  //20170425 CON
    //if Tbl.Locate('FILENAME', InpKey, [loCaseInsensitive]) then
    //20170223 Igor <<<
     begin
      Inc(RecNo);
      If RecNo >30 then begin RecNo :=1; Printer.NewPage; end;
      Line1 := Tbl.FieldByName('FIRST_NAME').AsString
               +' '+Tbl.FieldByName('LAST_NAME').AsString;
      If Tbl.FieldByName('APARTMENT').AsString = '' then
        Line2 := Tbl.FieldByName('STREET').AsString
      else
        Line2 := Tbl.FieldByName('STREET').AsString
              +', #'+Tbl.FieldByName('APARTMENT').AsString;
      PostalCd:=RemoveChar(Tbl.FieldByName('POSTAL').AsString,' ');
      PostalCd:=LeftStr(PostalCd,3)+' '+MidStr(PostalCd,4,3);

      //20100213
      FlName:=OptRec.Dir_Cur+'\'+
        LeftStr(Tbl.FieldByName('SIN').AsString,8)+'.'+RightStr(Tbl.FieldByName('SIN').AsString,1);
      GetPOBoxAndRRFromDisk(RetNo,PoBox,RR,FlName);
      If PoBox+RR>'' then
      begin
       Line3:=PoBox+' '+RR;
       Line4 := Tbl.FieldByName('CITY').AsString + '  '+Tbl.FieldByName('PROVINCE').AsString+' '+PostalCd;
      end
      Else
      begin
        Line3 := Tbl.FieldByName('CITY').AsString + '  '+
          Tbl.FieldByName('PROVINCE').AsString+' '+PostalCd;
        Line4:=' ';
      end;
       {
        Line3 := Tbl.FieldByName('CITY').AsString + '  '+
          Tbl.FieldByName('PROVINCE').AsString+' '+PostalCd;
        Line4:=' ';
        }

      If RecNo < 11 then  {left label}
        begin
         LabelPosX := LeftMargin;
         LabelPosY := TopMargin+(RecNo-1)*LabelHeight;
        end;
      If (RecNo >10) and (RecNo < 21) then  {Midle label}
         begin
         LabelPosX := LeftMargin+LabelWidth+HorizLabelGap;
         LabelPosY := TopMargin+(RecNo-11)*LabelHeight;
         end;
      If (RecNo >20) and (RecNo <31) then  {right label}
          begin
          LabelPosX := LeftMargin+2 *LabelWidth+2 * HorizLabelGap;
          LabelPosY := TopMargin+(RecNo-21)*LabelHeight;
          end;
      PrintALabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4);
     end;
  end; {end while}

  CloseFile(InpFile);
  Tbl.Free;
  FDConnection.Free;
  Printer.EndDoc;
  Result := True;
end;

Procedure PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 8;
  XPos := LabelPosX +2;
  YPos := LabelPosY+2;
  VertIncr := Trunc(PixPerInY * (1/6));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(XPos,YPos,Line1);
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(XPos,YPos+1 * VertIncr,Line2);
  Printer.Canvas.TextOut(XPos,YPos+2 * VertIncr,Line3);
  Printer.Canvas.TextOut(XPos,YPos+3 * VertIncr,Line4);
end;

Procedure GetPrevYearLines(FlName:String;DataDir:string; Var LinesList:TStringList;Var ValueList:TstringList);
 var
  i,j,k,FNo, SNo, BxNo : integer;
  F1: TextFile;
  Comma :string[1];
  Ndx : Array[1..3] of word;
  S : String[16];
  InputLin,Var1,Var2,Var3,Var4 : String;
  begin
    LinesList.Clear;
    ValueList.Clear;

    AssignFile(F1, DataDir + '\'+ FlName);
    ReSet(F1);
    Readln(F1, InputLin);
     {Break up into variables}
     j := 0;
     for i :=1 to Length(InputLin) do
      begin
      if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
      end;
     Var1 := Copy(InputLin,1,Ndx[1]-1);
     Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
     Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
     Var4 := Copy(InputLin,Ndx[3]+1,255);
     If Var1 <> AppName then
      begin CloseFile(F1); exit; end;

     While not EOF(F1) do
     begin
        Readln(F1, InputLin);
       {break it}
        j := 0;
        for i :=1 to Length(InputLin) do
        begin
          if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
        end;
        Var1 := Copy(InputLin,1,Ndx[1]-1);
        Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
        Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
        Var4 := Copy(InputLin,Ndx[3]+1,255);

        if Var1 = 'L' then
        begin
         LinesList.Add(Var2);
         ValueList.Add(Var3);
        end;
      end;
      CloseFile(F1);
end;

(*
//20190324  //test  did not work either
Procedure GetPrevYearLinesFromYRSum(Var LinesList:TStringList;Var ValueList:TstringList);
var i,RetNo,FNo,j:Integer;LnNo:String[3];
     TempList:TStringList;
begin
    RetNo:=GetCurrentRetNo;
    LinesList.Clear;
    ValueList.Clear;

    FNo:=GetFormNo('YRSUM');

    TempList:=TStringList.Create;
    TempList.LoadFromFile(AppDir+'\'+'YRSUM.D');
    i:=8;
    repeat
     j:=IsInList(AddLeadingZeros(IntToStr(i),3),TempList); //pos of elm in list
     LnNo:=MidStr(TempList[j],5,3);
  //   ShowMessage(LnNo);    //20120207
     LinesList.Add(LnNo);
     ValueList.Add(AllTrim(FetchElmFNo(RetNo,FNo,i+1)));  //prv yr value
     inc(i,5);
    until i>778; //243;  //i>223; //208;   //20110203


    TempList.Free;
end;

*)

Procedure GetPrevYearLinesFromYRSum(Var LinesList:TStringList;Var ValueList:TstringList);
var i,RetNo,FNo,j:Integer;LnNo:String[3];
     TempList:TStringList;
begin
    RetNo:=GetCurrentRetNo;
    LinesList.Clear;
    ValueList.Clear;

    FNo:=GetFormNo('YRSUM');

    TempList:=TStringList.Create;
    TempList.LoadFromFile(AppDir+'\'+'YRSUM.D');
    i:=8;
    repeat
     j:=IsInList(AddLeadingZeros(IntToStr(i),3),TempList); //pos of elm in list
     if j>=0 then
     begin
       LnNo:=MidStr(TempList[j],5,3);
       LinesList.Add(LnNo);
       ValueList.Add(AllTrim(FetchElmFNo(RetNo,FNo,i+1)));  //prv yr value
       {
       //20200308
       If j=241 then
       Begin
        ShowMessage('241' +' '+LnNo);    //20120207
        FetchElmFNo(RetNo,FNo,i+1);
       End;
       }
     end;

     inc(i,5);
    until i>243;   //i>223; //208;   //20110203 //????  //20200213

    //20190324
    i:=263;
    repeat
     j:=IsInList(AddLeadingZeros(IntToStr(i),3),TempList); //pos of elm in list
     If j>=0 then
     begin
      LnNo:=MidStr(TempList[j],5,3);
      LinesList.Add(LnNo);
      ValueList.Add(AllTrim(FetchElmFNo(RetNo,FNo,i+1)));  //prv yr value
     end;
     inc(i,5);
    until i>268;  //i>483;  //2020203


    i:=308;
    repeat
     j:=IsInList(AddLeadingZeros(IntToStr(i),3),TempList); //pos of elm in list
     If j>=0 then
     begin
      LnNo:=MidStr(TempList[j],5,3);
      LinesList.Add(LnNo);
      ValueList.Add(AllTrim(FetchElmFNo(RetNo,FNo,i+1)));  //prv yr value
     end;
     inc(i,5);
    until i>523;  //i>483;  //2020203

    i:=608;
    repeat
     j:=IsInList(AddLeadingZeros(IntToStr(i),3),TempList); //pos of elm in list
     If j>=0 then
     begin
      LnNo:=MidStr(TempList[j],5,3);
      LinesList.Add(LnNo);
      ValueList.Add(AllTrim(FetchElmFNo(RetNo,FNo,i+1)));  //prv yr value
     end;
     inc(i,5);
    until i>768; //758; //743  //20101212

    TempList.Free;
end;

Procedure GetPrevPrevYearLines(FlName:String;DataDir:string;
   Var LinesList:TStringList;Var ValueList:TstringList);
 var
  i,j,k,FNo, SNo, BxNo : integer;
  F1: TextFile;
  Comma :string[1];
  Ndx : Array[1..3] of word;
  S : String[16];
  InputLin,Var1,Var2,Var3,Var4 : String;
  begin
    LinesList.Clear;
    ValueList.Clear;
    AssignFile(F1, DataDir + '\'+ FlName);
    ReSet(F1);
    Readln(F1, InputLin);
     {Break up into variables}
     j := 0;
     for i :=1 to Length(InputLin) do
      begin
      if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
      end;
     Var1 := Copy(InputLin,1,Ndx[1]-1);
     Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
     Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
     Var4 := Copy(InputLin,Ndx[3]+1,255);
     If Var1 <> AppName then
      begin CloseFile(F1); exit; end;

     While not EOF(F1) do
     begin
        Readln(F1, InputLin);
       {break it}
        j := 0;
        for i :=1 to Length(InputLin) do
        begin
          if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
        end;
        Var1 := Copy(InputLin,1,Ndx[1]-1);
        Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
        Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
        Var4 := Copy(InputLin,Ndx[3]+1,255);

        if Var1 = 'L' then
        begin
         LinesList.Add(Var2);
         ValueList.Add(Var3);
        end;
      end;
      CloseFile(F1);
end;


Function GetKidsUnder7(RetNo:Integer):Integer;
Var i,FNo:Integer;
begin
 Result :=0;
 Fno := GetFormNo('DEPEND');
 i := 5;
 repeat
   If (FetchElmFNo(RetNo,FNo,i)+FetchElmFNo(RetNo,FNo,i+1) > '')
   and (FetchElmFNo(RetNo,FNo,i)>'') then
     If CalcAge(FetchElmFNo(RetNo,FNo,i+5)) <7 then Inc(Result);
  i := i+15;
 until i>125;
end;

Function CountAllDependants(RetNo:Integer):Integer;
Var i,FNo:Integer;
begin
 Result :=0;
 Fno := GetFormNo('DEPEND');
 i := 5;
 repeat
   If (FetchElmFNo(RetNo,FNo,i) > '') then Inc(Result);
   i := i+15;
 until i>125;
end;


Function SpouseIncome(RetNo:Integer):real;
//var InfoFNo:Integer;
begin
 //20181227
 //InfoFNo:=GetFormNo('INFO');
 result := Vl(FetchElm(RetNo,'S2',22));


 if GetSinNo(RetNo) = '870031226' then exit;  //jz//20250227

 //jz//20250227 have to remove as per satisfying test case #83,
 //maybe should remove for all, should revist
 If GetSpouseSplitIncome(RetNo,InfoFNo)>0 then
   result:=GetSpouseTosiNetIncome(RetNo,InfoFNo);  //20181227

end;


Function SubstituteForm(RetNo:Integer;FrmNm:String):String;
Var s:String;
begin
 result := FrmNm;


 If (LeftStr(FrmNm,6) = 'S11MJ#') then
 begin
  If LeftStr(FetchElm(RetNo,FrmNm,32),2)='YT' then
  begin
   CopySubstitute(RetNo,FrmNm,'S11MJY');
   result:='S11MJY';
  end
  else
  begin
   CopySubstitute(RetNo,FrmNm,'S11MJG');
   result:='S11MJG';
  end;
  exit;
 end;

  //20180428  //276 is NR with Employment in a province
  If ((LeftStr(FrmNm,4) = 'T1C_') Or (FrmNm='T1'))
  and ((FetchElm(RetNo,'INFO',276)>'') and (Ret[RetNo].Province <> 'ZZ')) then
  Begin
    CopySubstitute(RetNo,'T1','T1NR');
    StoreElm(RetNo,GetFormNo('T1NR'),1,'Other');
    StoreElm(RetNo,GetFormNo('T1NR'),524,FetchElm(RetNo,'INFO',69));  //mail address country
    //StoreElm(RetNo,GetFormNo('T1NR'),186,FetchElm(RetNo,'INFO',186));  //mail address country
    StoreElm(RetNo,GetFormNo('T1NR'),501,FetchElm(RetNo,'INFO',81));
    StoreElm(RetNo,GetFormNo('T1NR'),502,FetchElm(RetNo,'INFO',82));
    StoreElm(RetNo,GetFormNo('T1NR'),503,FetchElm(RetNo,'INFO',83));
    StoreElm(RetNo,GetFormNo('T1NR'),504,FetchElm(RetNo,'INFO',84));
    result := 'T1NR';
    //20200221
    StoreElm(RetNo,GetFormNo('T1C_NR'),501,FetchElm(RetNo,'INFO',81));
    StoreElm(RetNo,GetFormNo('T1C_NR'),502,FetchElm(RetNo,'INFO',82));
    StoreElm(RetNo,GetFormNo('T1C_NR'),503,FetchElm(RetNo,'INFO',83));
    StoreElm(RetNo,GetFormNo('T1C_NR'),504,FetchElm(RetNo,'INFO',84));
    exit;
  End

  Else If FrmNm = 'T1' then  //20180428
  begin
   If Ret[RetNo].Province = 'ON' then
   begin
    CopySubstitute(RetNo,'T1','T1ON');
    StoreElm(RetNo,GetFormNo('T1ON'),524,FetchElm(RetNo,'INFO',198)); //20230123 /climate
    result := 'T1ON';
    exit;
   end
   //20181228
   Else If Ret[RetNo].Province = 'AB' then
   begin
    CopySubstitute(RetNo,'T1','T1AB');
    StoreElm(RetNo,GetFormNo('T1AB'),524,FetchElm(RetNo,'INFO',198)); //20230123 /climate
    result := 'T1AB';
    exit;
   end

   //201812221
   Else If Ret[RetNo].Province = 'NB' then
   begin
    CopySubstitute(RetNo,'T1','T1NB');
    result := 'T1NB';
    exit;
   end

   //201812221
   Else If Ret[RetNo].Province = 'NS' then
   begin
    CopySubstitute(RetNo,'T1','T1NS');
    StoreElm(RetNo,GetFormNo('T1NS'),524,FetchElm(RetNo,'INFO',198)); //20230123 /climate
    result := 'T1NS';
    exit;
   end



   Else If Ret[RetNo].Province = 'MB' then
   begin
    CopySubstitute(RetNo,'T1','T1MB');
    StoreElm(RetNo,GetFormNo('T1MB'),524,FetchElm(RetNo,'INFO',198)); //20230123 /climate
    result := 'T1MB';
    exit;
   end

   Else If Ret[RetNo].Province = 'SK' then
   begin
    CopySubstitute(RetNo,'T1','T1SK');
    StoreElm(RetNo,GetFormNo('T1SK'),524,FetchElm(RetNo,'INFO',198)); //20230123 /climate
    result := 'T1SK';
    exit;
   end
   //----

   Else If Ret[RetNo].Province = 'YT' then
   begin
    CopySubstitute(RetNo,'T1','T1YT');
    StoreElm(RetNo,GetFormNo('T1YT'),513,FetchElm(RetNo,'INFO',41)); //20230311
    StoreElm(RetNo,GetFormNo('T1YT'),514,FetchElm(RetNo,'INFO',42)); //20230311
    result := 'T1YT';
    exit;
   end

   Else If Ret[RetNo].Province = 'BC' then
   begin
    CopySubstitute(RetNo,'T1','T1BC');  //20200222
    If UpperCase(FetchElm(RetNo,'INFO',220))='X' then StoreElm(RetNo,GetFormNo('T1BC'),1,'NON RESIDENT');    //20150323
    //20230123
    StoreElm(RetNo,GetFormNo('T1BC'),525,FetchElmFNo(RetNo,INFOFNo,190)); //20230123 //tsaww'
    StoreElm(RetNo,GetFormNo('T1BC'),526,FetchElmFNo(RetNo,INFOFNo,193)); //20230123 //tsaww' +
    StoreElm(RetNo,GetFormNo('T1BC'),527,FetchElmFNo(RetNo,INFOFNo,194)); //20230123 //tsaww first nation
    StoreElm(RetNo,GetFormNo('T1BC'),528,FetchElmFNo(RetNo,INFOFNo,195)); //20230123 //tsaww first nation

    StoreElm(RetNo,GetFormNo('T1BC'),538,FetchElm(RetNo,'T1',505)); //20250428
    StoreElm(RetNo,GetFormNo('T1BC'),539,FetchElm(RetNo,'T1',506)); //20250428

    result := 'T1BC';
    exit;
   end

   else If (Ret[RetNo].Province = 'NT') then
   begin
    CopySubstitute(RetNo,'T1','T1NT');
    StoreElm(RetNo,GetFormNo('T1NT'),528,FetchElmFNo(RetNo,INFOFNo,195)); //20230123 //tsaww first nation
    result := 'T1NT';
    exit;
   end


   Else If Ret[RetNo].Province = 'NL' then  //20200222
   begin
    CopySubstitute(RetNo,'T1','T1NL');
    result := 'T1NL';
    exit;
   end

   Else If (Ret[RetNo].Province = 'ZZ') then
   begin
    if (FrmNm='T1') then  //20220301
    //if (FrmNm='T1NR')
    Begin
     CopySubstitute(RetNo,'T1','T1NR');
     StoreElm(RetNo,GetFormNo('T1NR'),1,'Other');
     StoreElm(RetNo,GetFormNo('T1NR'),524,FetchElm(RetNo,'INFO',69));  //Country  //20220220
    {
    // StoreElm(RetNo,GetFormNo('T1NR'),186,FetchElm(RetNo,'INFO',186));  //mail address country
     StoreElm(RetNo,GetFormNo('T1NR'),501,FetchElm(RetNo,'INFO',81));
     StoreElm(RetNo,GetFormNo('T1NR'),502,FetchElm(RetNo,'INFO',82));
     StoreElm(RetNo,GetFormNo('T1NR'),503,FetchElm(RetNo,'INFO',83));
     StoreElm(RetNo,GetFormNo('T1NR'),504,FetchElm(RetNo,'INFO',84));
     }
     result := 'T1NR';
     exit;
    end
     //20220228
    Else if FrmNm='T1C_NR' then
    Begin
     CopySubstitute(RetNo,'T1','T1C_NR');
     StoreElm(RetNo,GetFormNo('T1C_NR'),1,'Other');
     StoreElm(RetNo,GetFormNo('T1C_NR'),524,FetchElm(RetNo,'INFO',69));  //Country  //20220220
     result := 'T1C_NR';
     exit;
    End ;
   end //zz

   Else If (Ret[RetNo].Province = 'QC') then
   begin
    CopySubstitute(RetNo,'T1','T1QC');
    result := 'T1QC';
    exit;
   end

   Else If Ret[RetNo].Province = 'NU' then
   begin
    CopySubstitute(RetNo,'T1','T1NU');
    result := 'T1NU';
    exit;
   end

   Else If Ret[RetNo].Province = 'PE' then
   begin
    CopySubstitute(RetNo,'T1','T1PE');
    result := 'T1PE';
    exit;
   end

   Else If Ret[RetNo].Province = 'NS' then
   begin
    CopySubstitute(RetNo,'T1','T1NS');
    result := 'T1NS';
    exit;
   end;

 end;  //end page


 //20160220 //20160223 Igor
 If FrmNm = 'S1A' then
  begin
  Result:='S1A';
  If ((Ret[RetNo].Province = 'ZZ') or (Ret[RetNo].Province = 'QC')) then
  Begin
   CopySubstitute(RetNo,'S1A','S1ANQ');
   result := 'S1ANQ';
  end;
 end;
 //  -----------------

 If FrmNm = 'S2' then
 Begin
  If (Ret[RetNo].Province = 'QC')
 // or (Ret[RetNo].Province = 'ZZ')    //20150204   //20190201
  then
  begin
    CopySubstitute(RetNo,'S2','S2QC');
    result := 'S2QC';
    exit;
  end

  else
  begin
    result:= 'S2';
    exit;
  end;
 end;

 //20100315
 If FrmNm = 'S6' then
 begin
   If (Ret[RetNo].Province = 'QC') then
   begin
    //CopySubstitute(RetNo,'S6','S6QC');  //20171205
    result := 'S6QC';
    exit;
   end

   Else If (Ret[RetNo].Province = 'AB') then  //20130127
   begin
    CopySubstitute(RetNo,'S6','S6AB');
    result := 'S6AB';
    exit;
   end
   Else If (Ret[RetNo].Province = 'NU') then  //20130127
   begin
    CopySubstitute(RetNo,'S6','S6NU');
    result := 'S6NU';
    exit;
   end

   Else   //20130127
   begin
    CopySubstitute(RetNo,'S6','S6GN');
    result := 'S6GN';
    exit;
   end;
 end;

 If FrmNm = 'S9' then
 begin
   If (Ret[RetNo].Province = 'QC') then
   begin
    CopySubstitute(RetNo,'S9','S9QC');
    result := 'S9QC';
    exit;
   end
  else
   begin
    result := 'S9';
    exit;
   end
 end;


 If FrmNm = 'S11' then
 begin
   If (Ret[RetNo].Province = 'QC')
   or (Ret[RetNo].Province = 'ZZ') then   //20160220 //20160223 Igor
   begin
    CopySubstitute(RetNo,'S11','S11QC');
    result := 'S11QC';
    exit;
   end
  else
   begin
    result := 'S11';
    exit;
   end
 end;

 If FrmNm = 'S13' then  //20110204
 begin
   Result:='S13';
   If (Ret[RetNo].Province = 'QC') then
   begin
    CopySubstitute(RetNo,'S13','S13QC');
    result := 'S13QC';
    exit;
   end
 end;



 If FrmNm = 'S2PRV' then
 begin
  If (Ret[RetNo].Province = 'QC') then begin Result:='';Exit;End;   //20110124
  If (Ret[RetNo].Province = 'AB') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVAB');result := 'S2PRVAB';exit; end
  else If (Ret[RetNo].Province = 'BC') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVBC');result := 'S2PRVBC';exit; end
  else If (Ret[RetNo].Province = 'MB') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVMB');result := 'S2PRVMB';exit; end
  else If (Ret[RetNo].Province = 'NB') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVNB');result := 'S2PRVNB';exit; end
  else  If (Ret[RetNo].Province = 'NL') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVNL'); result := 'S2PRVNL';  exit;end
  else  If (Ret[RetNo].Province = 'NT') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVNT'); result := 'S2PRVNT';  exit;end
  else  If (Ret[RetNo].Province = 'NS') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVNS'); result := 'S2PRVNS';  exit;end
  else  If (Ret[RetNo].Province = 'NU') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVNU'); result := 'S2PRVNU';  exit;end
  else If (Ret[RetNo].Province = 'ON') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVON');result := 'S2PRVON';exit; end
  else If (Ret[RetNo].Province = 'PE') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVPE');result := 'S2PRVPE';exit; end
  else If (Ret[RetNo].Province = 'SK') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVSK');result := 'S2PRVSK';exit; end
  else If (Ret[RetNo].Province = 'YT') then
   begin CopySubstitute(RetNo,'S2PRV','S2PRVYT');result := 'S2PRVYT';exit; end
  else
   begin CopySubstitute(RetNo,'S2PRV','S2PRVG'); result := 'S2PRVG';  exit; end;
 end;

 If FrmNm = 'S11PRV' then
 begin
  If Ret[RetNo].Province = 'QC' then Begin result:='';Exit;End;  //20110124
  If Ret[RetNo].Province = 'ZZ' then Begin result:='';Exit;End;  //20160220 //20160223 Igor
  Result:='S11PRV';
  If Ret[RetNo].Province = 'AB' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVAB');result:='S11PRVAB';exit;end
  else If Ret[RetNo].Province = 'BC' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVBC');result:='S11PRVBC';exit;end
  else If Ret[RetNo].Province = 'MB' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVMB');result:='S11PRVMB';exit;end
  else If Ret[RetNo].Province = 'NB' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVNB');result:='S11PRVNB';exit;end
  else If Ret[RetNo].Province = 'NL' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVNL');result:='S11PRVNL';exit;end
  else If Ret[RetNo].Province = 'NS' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVNS');result:='S11PRVNS';exit;end
  else If Ret[RetNo].Province = 'NT' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVNT');result:='S11PRVNT';exit;end
  else If Ret[RetNo].Province = 'NU' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVNU');result:='S11PRVNU';exit;end
  else If Ret[RetNo].Province = 'YT' then  //20210221
   begin
    CopySubstitute(RetNo,'S11PRV','S11PRVYT');
    StoreElm(RetNo,GetFormNo('S11PRVYT'),31,FetchElm(RetNo,'S11',1));
    StoreElm(RetNo,GetFormNo('S11PRVYT'),32,FetchElm(RetNo,'S11',2));
    //20220220 did not work
    //StoreElm(RetNo,GetFormNo('S11PRVYT'),2,FetchElm(RetNo,'S11PRV',21));
    //StoreElm(RetNo,GetFormNo('S11PRVYT'),4,FetchElm(RetNo,'S11',1));
    result:='S11PRVYT';
    exit;
   end

  else If Ret[RetNo].Province = 'ON' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVON');result:= 'S11PRVON';exit;end
  else If Ret[RetNo].Province = 'PE' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVPE'); result:= 'S11PRVPE';exit;end
  else If Ret[RetNo].Province = 'SK' then
   begin CopySubstitute(RetNo,'S11PRV','S11PRVSK');result:='S11PRVSK';exit;end
 { else If Ret[RetNo].Province = 'QC' then             //20110121
   begin CopySubstitute(RetNo,'S11PRV','S11PrvQC');result:='S11PrvQC';exit;end}
  else
  begin CopySubstitute(RetNo,'S11PRV','S11PRVG');result:= 'S11PRVG';exit;end;
end;
end;

Procedure CopySubstitute(RetNo:Integer;FromFrm,ToFrm:String);
Var i,Fno,NumbFlds:Integer; //RetNo,
begin
  Fno := GetFormNo(ToFrm);////
  If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
  {copy data}
  NumbFlds := GetFormNumberFields(GetFormNo(ToFrm));
  If FromFrm='T1' then NumbFlds:=550;  //20200222
  For i:=1 to NumbFlds do
   Ret[RetNo].Frm[FNo].Strings[i]:=FetchElm(RetNo,FromFrm,i);
  {to get the province on the top}
  If FromFrm='T1' then
  begin
   Ret[RetNo].Frm[FNo].Strings[61]:=FetchElm(RetNo,FromFrm,61);
   If UpperCase(FetchElm(RetNo,'INFO',220))='X' then StoreElm(RetNo,FNo,1,'NON RESIDENT');    //20150404
   StoreElm(RetNo,FNo,70,FetchElm(RetNo,'INFO',128));  //20200215  //indian exempt
  end;
end;

Procedure WriteFileForEFCom;
Var TempList:TStringList;
begin
  TempList :=TstringList.Create;
  Templist.Add(User.UserName); //20170112 Igor
  Templist.Add(AppDir);
  //If LeftStr(LicenseLevel,8) = 'T1 Multi' then
  If LicenseLevel in anyMulti then
    Templist.Add('3')
  else
   Templist.Add(LicenseName);
  TempList.SaveToFile(AppDir+'\'+'UserData.d');
  TempList.Free;
end;

Procedure GetFarmingStatements(RetNo:Integer);
Var I,FNo:integer; EndDate:String[10];BusInc:Real;FName:String[12];
begin
 SomeList.Clear;
 for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo :=Frec.FormNo;
    FName :=Frec.FormName+FRec.FormInst;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
     if (LeftStr(FName,6) = 'T2042#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),148));
        EndDate :=FetchElmFNo(RetNo,Fno,5);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,8),EndDate,BusInc);
      end

     else if (LeftStr(FName,6) = 'T1163#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+ExtractFormInst(FName),216));
        EndDate :=FetchElmFNo(RetNo,Fno,214);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,1),EndDate,BusInc);
      end

     else if (LeftStr(FName,6) = 'T1273#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),416));
        EndDate :=FetchElmFNo(RetNo,Fno,414);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,401),EndDate,BusInc);
      end

    end;
  end;
end;


Procedure GetOddBusStatements(RetNo:Integer);
Var I,FNo:integer; EndDate:String[10];BusInc:Real;FName:String[12];
begin
 SomeList.Clear;
 for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo :=Frec.FormNo;
    FName :=Frec.FormName+FRec.FormInst;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
     If (LeftStr(FName,6) = 'T2125#') then   //20101214
      begin
       BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),6));
       EndDate := FetchElmFNo(RetNo,Fno,5);
       AddToOddStm(FName,FetchElmFNo(RetNo,FNo,8),EndDate,BusInc);
      end
     else if (LeftStr(FName,6) = 'T2121#') then
      begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),74));
        EndDate :=FetchElmFNo(RetNo,Fno,5);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,75),EndDate,BusInc);
      end

     else if (LeftStr(FName,6) = 'T2042#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),148));
        EndDate :=FetchElmFNo(RetNo,Fno,5);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,8),EndDate,BusInc);
      end

     else if (LeftStr(FName,6) = 'T1163#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+ExtractFormInst(FName),216));
        EndDate :=FetchElmFNo(RetNo,Fno,214);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,1),EndDate,BusInc);
      end

     else if (LeftStr(FName,6) = 'T1273#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),416));
        EndDate :=FetchElmFNo(RetNo,Fno,414);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,401),EndDate,BusInc);
      end

    end;
  end;
end;


Procedure GetBusStatements(RetNo:Integer);
Var I,FNo:integer; EndDate:String[10];BusInc:Real;FName:String[12];
begin
 SomeList.Clear;
 for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo :=Frec.FormNo;
    FName :=Frec.FormName+FRec.FormInst;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
     If (LeftStr(FName,6) = 'T2125#') then    //20101214  # to include
        SomeList.Add(PaddR(Fname,10)+' '+FetchElmFNo(RetNo,FNo,8))

     else if (LeftStr(FName,6) = 'T2121#') then
        SomeList.Add(PaddR(Fname,10)+' '+FetchElmFNo(RetNo,FNo,75))

     else if (LeftStr(FName,6) = 'T2042#') then
         SomeList.Add(PaddR(Fname,10)+' '+FetchElmFNo(RetNo,FNo,8))

     else if (LeftStr(FName,6) = 'T1163#') then
       SomeList.Add(PaddR(Fname,210)+' '+FetchElmFNo(RetNo,FNo,101))

     else if (LeftStr(FName,5) = 'T776#') then
       SomeList.Add(PaddR(Fname,10)+' '+FetchElmFNo(RetNo,FNo,109));
    end;
  end;
end;

Procedure GetSpecificBusStatements(RetNo:Integer;FNm:String);
Var I,FNo:integer; EndDate:String[10];BusInc:Real;FName:String[12];
begin
 SomeList.Clear;
 for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo :=Frec.FormNo;
    FName :=Frec.FormName;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
     If (LeftStr(FName,7)) = FNm then
        SomeList.Add(PaddR(Fname+FRec.FormInst,11)+' '+FetchElmFNo(RetNo,FNo,8))
    end;
  end;
end;


Procedure GetStatements(RetNo:Integer);
Var I,FNo:integer; EndDate:String[10];BusInc:Real;FName:String[12];
begin
 SomeList.Clear;
 for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    FNo :=Frec.FormNo;
    FName :=Frec.FormName+FRec.FormInst;
    If Ret[RetNo].FrmHasData[FNo] then
    begin
     If (LeftStr(FName,6) = 'T2125#') then    //20101214   added #
      begin
       BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),6));
       EndDate := FetchElmFNo(RetNo,Fno,5);
       AddToOddStm(FName,FetchElmFNo(RetNo,FNo,8),EndDate,BusInc);
      end
     else if (LeftStr(FName,6) = 'T2121#') then
      begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),74));
        EndDate :=FetchElmFNo(RetNo,Fno,5);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,75),EndDate,BusInc);
      end

     else if (LeftStr(FName,6) = 'T2042#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+
                ExtractFormInst(FName),148));
        EndDate :=FetchElmFNo(RetNo,Fno,5);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,8),EndDate,BusInc);
      end

     else if (LeftStr(FName,6) = 'T1163#') then
       begin
        BusInc := Vl(FetchElm(RetNo,ExtractFormRootName(FName)+ExtractFormInst(FName),216));
        EndDate :=FetchElmFNo(RetNo,Fno,214);
        AddToOddStm(FName,FetchElmFNo(RetNo,FNo,1),EndDate,BusInc);
      end

    end;
  end;
end;


(*
Procedure GetEfFields(RetNo:Integer);
Var I,FNo:integer; EndDate:String[10];BusInc:Real;FName:String[12];
TempList:TStringList;
begin
 SomeList.Clear;
 TempList:=TstringList.Create;
 Templist.LoadFromFile(AppDir+'\'+'EFFields.d');
 TempList.Add(' ');
 for i :=0 to (TempList.count - 1) do
  begin
  SomeList.Add(TempList[i]);
  end;
 TempList.Free;
end;
*)

Procedure AddToOddStm(FName,BusName,EndDate:string;BusInc:Real);
begin
 SomeList.Add(Fname+' '+EndDate+' '+
   '$'+JustRight(FormatFloat('##,###,###.00',BusInc),13)+' '+BusName);
end;

//20170728 Igor>>>
//Function YYYYMMDDToWinFormat(Dt:String):string;
//Var WinDateFormat:String;Sep:string[1];WinBootDir:String;
//begin
// Result :=Dt;
// WinBootDir:=GetWinBootDir;
// WinDateFormat := UpperCase(
//     GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sShortDate'));
// Sep := UpperCase(
//     GetWinIniString(WinBootDir+'\'+'Win.Ini','intl','sDate'));
//
// If LeftStr(WinDateFormat,1)='M' then   {to MMDDYYYY}
// begin
//  Result := MidStr(Dt,6,2)+Sep+RightStr(Dt,2)+Sep+LeftStr(Dt,4); //MidStr(Dt,3,2); //20100131
// end
// else If LeftStr(WinDateFormat,1)='D' then   {to DDMMYYYY}
// begin
//  Result := RightStr(Dt,2)+Sep+MidStr(Dt,6,2)+Sep+LeftStr(Dt,4); //MidStr(Dt,3,2); //20100131
// end
// else If LeftStr(WinDateFormat,1)='Y' then {to YYYYMMDD}
// begin
//  Result :=LeftStr(Dt,4)+Sep+MidStr(Dt,6,2)+Sep+RightStr(Dt,2); //20100131
//  //MidStr(Dt,3,2)+Sep+MidStr(Dt,6,2)+Sep+RightStr(Dt,2);
// end;
//end;
//20170728 Igor<<<

Procedure TotT1139(RetNo:Integer;
          Var T1139ReserveConv:real;
          Var T1139ReserveAlt:real;
          Var T1139Bus:real;
          Var T1139Prof:real;
          Var T1139Farm:real;
          Var T1139Fish:real);
var
 i, FNo: Integer;
begin
 T1139ReserveConv:=0;
 T1139ReserveAlt :=0;
 T1139Bus :=0;T1139Prof :=0;T1139Farm :=0;T1139Fish :=0;
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec.FormName = 'T1139' then
    begin
      FNo :=Frec.FormNo;
      If Ret[RetNo].FrmHasData[FNo] then
      begin
          T1139ReserveConv := T1139ReserveConv+Vl(FetchElmFNo(RetNo,FNo,16));
          T1139ReserveAlt  := T1139ReserveAlt+Vl(FetchElmFNo(RetNo,FNo,29));
          If UpperCase(FetchElmFNo(RetNo,FNo,33)) = 'X' then
          begin
           If FetchElm(RetNo,FetchElmFNo(RetNo,FNo,2),82)>'' then
             T1139Bus    := T1139Bus+Vl(FetchElmFNo(RetNo,FNo,37))
           else
             T1139Prof   := T1139Prof+Vl(FetchElmFNo(RetNo,FNo,37));
          end;
         // If UpperCase(FetchElmFNo(RetNo,FNo,34)) = 'X' then T1139Prof   := T1139Prof+Vl(FetchElmFNo(RetNo,FNo,37));

          If UpperCase(FetchElmFNo(RetNo,FNo,35)) = 'X' then
             T1139Farm   := T1139Farm+Vl(FetchElmFNo(RetNo,FNo,37));
          If UpperCase(FetchElmFNo(RetNo,FNo,39)) = 'X' then  //nisa
             T1139Farm   := T1139Farm+Vl(FetchElmFNo(RetNo,FNo,37));

          If UpperCase(FetchElmFNo(RetNo,FNo,36)) = 'X' then
             T1139Fish   := T1139Fish+Vl(FetchElmFNo(RetNo,FNo,37));
       end;
    end;
  end;
end;

Function GetPrintTemplate:string;
begin
  {select print set}
 result :='';
// SomeList := TStringList.Create;
 SomeList.Clear;
 SomeCaption := 'Select Print Template';
 SomeList.Add('CRA');
 SomeList.Add('Client');
 SomeList.Add('Preparer');
 SomeList.Add('C+P (Client and Preparer)');
 SomeList.Add('All three (CRA, Client and Preparer)');
 SomeList.Add('Other 1');
 SomeList.Add('Other 2');
 SomeList.Add('Other 3');
 SelectedString := PopSomeList(SomeList,SomeCaption);
 //Application.CreateForm(TPoplist,PopList);
 //PopList.ShowModal;
// Try
//  SomeList.Free;
// Except
// End;
// PopList.Release;
 If SelectedString = 'CRA' then result := 'CRASET.D'
 else if SelectedString = 'Client'    then result := 'CLINTSET.D'
 else if SelectedString = 'Preparer'  then result := 'PREPSET.D'
 else if SelectedString = 'Other 1'   then result := 'OTH1SET.D'
 else if SelectedString = 'Other 2'   then result := 'OTH2SET.D'
 else if SelectedString = 'Other 3'   then result := 'OTH3SET.D'
 else if LeftStr(SelectedString,3) = 'C+P' then result := 'C+P'
 else if LeftStr(SelectedString,3) = 'All' then result := 'ALL';
end;

Function GetBatchPrintTemplate:string;
begin
  {select print set}
 result :='';
// SomeList := TStringList.Create;
 SomeList.Clear;
 SomeCaption := 'Select Print Template';
 SomeList.Add('CRA');
 SomeList.Add('Client');
 SomeList.Add('Preparer');
 SomeList.Add('Other 1');
 SomeList.Add('Other 2');
 SomeList.Add('Other 3');
 SelectedString := PopSomeList(SomeList,SomeCaption);
// Application.CreateForm(TPoplist,PopList);
// PopList.ShowModal;
// Try
//  SomeList.Free;
// Except
// End;
// PopList.Release;
 If SelectedString = 'CRA' then result := 'CRASET.D'
 else if SelectedString = 'Client'    then result := 'CLINTSET.D'
 else if SelectedString = 'Preparer'  then result := 'PREPSET.D'
 else if SelectedString = 'Other 1'   then result := 'OTH1SET.D'
 else if SelectedString = 'Other 2'   then result := 'OTH2SET.D'
 else if SelectedString = 'Other 3'   then result := 'OTH3SET.D'
 else if LeftStr(SelectedString,3) = 'C+P' then result := 'C+P'
 else if LeftStr(SelectedString,3) = 'All' then result := 'ALL';
end;



Function IncludeFormInPrint(RetNo:Integer;FNm:String):boolean;
Var i,FNo:Integer;FInst:String; //RetNo:Integer;
begin
 result := true;
 With Ret[Retno] do
 begin

   //20140130
   If (FNm = 'T1DD')  then  begin result := false;exit;end;

   //20090321
   If (FNm = 'INVOICE') and (Vl(FetchElm(RetNo,Fnm,222))=0) then
     begin result := false;exit;end;

   If (FNm = 'INVOICE') and (FetchElm(RetNo,Fnm,286)>'') then //joint invoice //20110226
     begin result := false;exit;end;

   If (FNm = 'CUSTINV') then //20140105
     begin result := false;exit;end;

   //20170401
   If (FNm = 'PIPEDA') then
   Begin
    If OptRec.Prn_PIPEDAALL then //20170401  //20180301
    begin
     Result:=true;
     Exit;
    end
    Else
    Begin
     Result:=FirstTimeClient(RetNo);
     Exit;
    End;
   End;


   If (FNm = 'S7') and (Lnn[24500]+Lnn[246]+Lnn[24620]+Lnn[24640]+Lnn[20800] = 0)
   and (Lnn[24700]+Lnn[26300]=0) then begin result := false;exit;end;

   (* 20171217
   //20130316
   If (FNm = 'S12ON') and (Vl(FetchElm(RetNo,'ON479',4)) = 0)
   then begin result := false;exit;end;
   *)


   If (LeftStr(FNm,6) = 'T1013#') Then
   Begin
    If (FetchElm(RetNo,Fnm,26)='') then begin result := false;exit;end;
    If (FetchElm(RetNo,Fnm,39)>'') then begin result := false;exit;end;  //20110130
   end;

   If (FNm = 'T1033') and (Vl(FetchElm(RetNo,Fnm,25))=0) then
     begin result := false;exit;end;

   {//20171119
   //20110306
   If (FNm = 'CATC') and (Vl(FetchElm(RetNo,Fnm,3))=0) then  //no claim
   begin result := false;exit;end;
   }
   If (FNm = 'CAREGVR') and (Ret[RetNo].Lnn[31500]=0) then  //no claim
   begin result := false;exit;end;
   If (FNm = 'CAREPRV') and (Ret[RetNo].Lnn[31500]=0) then  //no claim
   begin result := false;exit;end;


   //20110124
   If (LeftStr(FNm,9) = 'T2125SUM#') then
   begin
     If (Vl(FetchElm(RetNo,Fnm,52))=0) and (Vl(FetchElm(RetNo,Fnm,212))=0) then begin result:=False;Exit;end;
   end;

   //20110124
   If (LeftStr(FNm,9) = 'T2121SUM#') then
   begin
     If (Vl(FetchElm(RetNo,Fnm,47))=0) and (Vl(FetchElm(RetNo,Fnm,142))=0) then begin result:=False;Exit;end;
   end;

   //20110124
   If (LeftStr(FNm,8) = 'T776SUM#') then
   begin
     If (Vl(FetchElm(RetNo,Fnm,22))=0) and (Vl(FetchElm(RetNo,Fnm,157))=0) then begin result:=False;Exit;end;
   end;

   //20110124
   If (LeftStr(FNm,9) = 'T2042SUM#') then
   begin
     If (Vl(FetchElm(RetNo,Fnm,167))=0) and (Vl(FetchElm(RetNo,Fnm,327))=0) then begin result:=False;Exit;end;
   end;

   //20110124
   If (LeftStr(FNm,9) = 'T1273SUM#') then
   begin
     If (Vl(FetchElm(RetNo,Fnm,87))=0) and (Vl(FetchElm(RetNo,Fnm,327))=0) then begin result:=False;Exit;end;
   end;

   If (LeftStr(FNm,9) = 'T1163SUM#') then
   begin
     If (Vl(FetchElm(RetNo,Fnm,87))=0) and (Vl(FetchElm(RetNo,Fnm,327))=0) then begin result:=False;Exit;end;
   end;

   if Ret[RetNo].Province<>'QC' then
   begin
    If (FNm = 'S6') and (Lnn[45300]=0) then begin result := false;exit;end;
   end
   Else
   Begin
    If (FNm = 'S6QC') and (Lnn[45300]=0) then begin result := false;exit;end;
   End;


   If  FNm = 'MEDICAL' then
   begin
    If Vl(FetchElm(RetNo,'MEDICAL',233))=0 then
    begin
     result := False;
     exit;
    end;
   end;

   If  FNm = 'DON' then
   begin
    If Vl(FetchElm(RetNo,'DON',179))=0 then
    begin
     result := False;
     exit;
    end;
   end;

   If  FNm = 'PTRANSIT' then
   begin
    If Vl(FetchElm(RetNo,'PTRANSIT',79))=0 then
    begin
     result := False;
     exit;
    end;
   end;

   If  FNm = 'FITNESS' then
   begin
    If Vl(FetchElm(RetNo,'FITNESS',3))=0 then
    begin
     result := False;
     exit;
    end;
   end;


   If  FNm = 'ADOPT#1' then
   begin
    If Vl(FetchElm(RetNo,'ADOPT#1',5))=0 then
    begin
     result := False;
     exit;
    end;
   end;

   If  FNm = 'POLIT' then
   begin
    If Vl(FetchElm(RetNo,'POLIT',19))+Vl(FetchElm(RetNo,'POLIT',27))=0 then
    begin
     result := False;
     exit;
    end;
   end;

   If  LeftStr(FNm,6) = 'AUTOS#' then
   Begin
       FNo:=GetFormNo(FNm);
       If Vl(FetchElmFNo(RetNo,FNo,216))
        +Vl(FetchElmFNo(RetNo,FNo,222))
        +Vl(FetchElmFNo(RetNo,FNo,228))=0 then
       begin
        result := False;
        exit;
       end;
   end;

   If  LeftStr(FNm,8) = 'ASSETSB#' then
   begin
     FNo:=GetFormNo(FNm);
     If Vl(FetchElmFNo(RetNo,FNo,216))
      +Vl(FetchElmFNo(RetNo,FNo,222))
      +Vl(FetchElmFNo(RetNo,FNo,228))=0 then
     begin
      result := False;
      exit;
     end;
   end;
end;

 //dummy out during barcode cert. They need the T691
 If (LeftStr(FNm,4) = 'T691')
   and (SubjectToMinTax(RetNo) = False) then
      begin result := false;exit;end;

 If (FNm = 'S2') and (Ret[RetNo].Lnn[32600] = 0) then
      begin result := false;exit;end;

 If (FNm = 'CTB')
   and (UpperCase(FetchElm(RetNo,'CTB',71)) <> 'Y') then
      begin result := false;exit;end;
end;

Procedure GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList);
var i,j,FNo:integer;Copies :string[1];//Inst:String[3];
    TemplList,TemplForms,TemplCopies:TstringList;
    Frm,Inst:String;   //20140127
begin
  If (UpperCase(LeftStr(Template,8)) <> 'ALL (CRA') and  //20200516
  (UpperCase(LeftStr(Template,3)) <> 'C+P') then
  begin
    If not FileExists(AppDir+'\'+Template) then
     begin
      ShowMessage('Print Template: '+AppDir+'\'+Template+
             chr(13)+'does not exist');
      exit;
     end;
  end;

  TemplList:= TStringList.Create;
  TemplCopies:= TStringList.Create;
  TemplForms:= TStringList.Create;
  {split: templist has nFFFFFF where n=copies and FFFF=form without instance}
  TemplList.LoadFromFile(AppDir+'\'+Template);


  if UpperCase(Template)='ALLFORMSSET.D' then //20200516
  Begin
    for i := 0 to (FList.count - 1) do
    begin
      FRec := FList.Items[i];
      If Ret[RetNo].FrmHasData[FRec.FormNo] then
      Begin
        if ((FRec.FormName<>'CUSTINV') and (FRec.FormName<>'T1C_3')) then //should not be in the flist //20200516
        FormsToPrint.Add(FRec.FormName + FRec.FormInst);
      End;
    End; //i
  End;

  For i:=0 to TemplList.Count-1 do
   begin
     TemplCopies.Add(LeftStr(TemplList[i],1));
     TemplForms.Add(MidStr(TemplList[i],2,10));
   end;


  For i:=0 to FList.Count-1 do {run thru all forms available}
  begin
   FRec := FList.Items[i];
   FNo :=Frec.FormNo;
  //20140127
   Frm:=Frec.FormName;
   Inst:=Frec.FormInst;
   If (IsExactlyInList(Frm,TemplForms)>-1) then {it is on tempate}
   begin
    If (Ret[RetNo].FrmHasData[FNo])  {has data and it is in template}
    and (IncludeFormInPrint(RetNo,Frm+Inst) = True)
    then
         FormsToPrint.Add(Frm+Inst);
   end;
  end;

  {match and attach number of copies}
  For i:=0 to FormsToPrint.Count-1 do
  begin
   if UpperCase(Template)='ALLFORMSSET.D' then //20200516
   Begin
     FormsToPrint[i]:=          {to become sssnFFFFFFFFF}
     GetPrintSequence(FormsToPrint[i])
     +'1'  //fcopies
     + FormsToPrint[i];
   End
   Else
   Begin
    FormsToPrint[i]:=          {to become sssnFFFFFFFFF}
     GetPrintSequence(FormsToPrint[i])
     + GetCopiesToPrint(FormsToPrint[i],TemplForms,TemplCopies)
     + FormsToPrint[i];
   //ShowMessage(FormsToPrint[i]);
   End;
  end;

  FormsToPrint.Sorted :=True; {sort by sequence}
  TemplList.Free;
  TemplForms.Free;
  TemplCopies.Free;
end;

Procedure ResortFormsToPrint(Var FormsToPrint:TStringList);
//comes as sssnFFFFFFFFF  i.e. 1011T2125-1#1
//take the -1#1 and put it under the sss then resort
var i,k1,k2:Integer;TempList:TStringList; Rec:String;
 SeqNo:Integer;SeqNoString:String;
begin
 SeqNo:=0;  //new seq
 TempList:=TStringList.Create;

 FormsToPrint.Sorted:=False;
 For i:=0 to FormsToPrint.Count-1 do
 begin
   Rec:=FormsToPrint[i];
   k1:=Pos('_',Rec);
   K2:=Pos('#',rec);
   If (k1>0) and (k2>0) then
   begin
     Templist.Add
      (
        LeftStr(Rec,4)
       +PaddR(AllTrim(MidStr(Rec,k2,3)),3)+PaddR(AllTrim(MidStr(Rec,k1,3)),3)
       +MidStr(Rec,5,10)
       );
   end
   else
   begin
     Templist.Add
      (
       LeftStr(Rec,4)
       +Space(6)
       +MidStr(Rec,5,10)
       );
   end;
 end;

 TempList.sorted:=True;

 FormsToPrint.Clear;
 For i:=0 to TempList.count-1 do
 begin
  Rec:=TempList[i];
  FormsToPrint.Add(LeftStr(Rec,4)+MidStr(Rec,11,20));
 end;
 TempList.Free;
end;


Function GetPrintSequence(FName:string):String;
Var i:integer;TempList:TStringList;
begin
 //20110207
 If FileExists(AppDir+'\'+'PrintSeq.txt') = False then
 begin
  Result:='999';
  ShowMessage('Print Sequence has not been defined. See Configure -> Print Sequence');
  Exit;
 End;
 FName:=ExtractNonInstFormName(UpperCase(FName));
 TempList:=TStringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'PrintSeq.txt');
 for i :=0 to (TempList.Count - 1) do
 begin
   If UpperCase(AllTrim(LeftStr(TempList[i],15))) = FName then
   begin
     result := AddLeadingZeros(MidStr(TempList[i],16,3),3);
     TempList.Free;
     exit;
   end;
 end;
 TempList.Free;
 (*
 Result := '999';
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If ExtractNonInstFormName(FName) = Frec.FormName then
    begin result := Frec.PrnSeq;exit;end;
 end;
 *)
end;

procedure OnestepEFile;
Var h : THandle; ClickedOK : Boolean;EFMethod:string;
    ZString : Array[0..80] of Char;
    PZString : Pchar;
begin
  //If LeftStr(LicenseLevel,8) ='T1 Multi' then
  If LicenseLevel in anyMulti then
//20170112 Igor >>>
    OptRec.GetOverloadedProperty;
//   begin
//    OptRec.Dir_Cur :=AllTrim(User.Tax_Dir);
//    OptRec.Dir_Deflt :=AllTrim(User.Tax_Dir);
//    OptRec.Ef_DataDir :=  allTrim(User.EFile_Dir);
//   end;
//20170112 Igor <<<

  WriteFileForEfCom;
  PZString := StrPCopy(ZString,AppDir+'\'+'EFCOM.EXE');
  h := ShellExecute(Application.MainForm.Handle, Nil, PZString, Nil,
  Nil, SW_RESTORE);
  {
  h := ShellExecute(MdiHandle, Nil, 'EFCOM.EXE', Nil,
  Nil, SW_RESTORE);        *
  }
  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h));
   SomeCaption := 'Error codes';
   PopSomeFile(AppDir+'\'+'SHELLERR.D',SomeCaption);
//   SomeList := TStringList.Create;
//   SomeCaption := 'Error codes';
//   SomeList.LoadFromFile(AppDir+'\'+'SHELLERR.D');
//   Application.CreateForm(TPoplist,PopList);
//   PopList.ShowModal;
//   SomeList.Free; PopList.Release;
  end;
end;

(*
procedure OnestepCom;
Var h : THandle; ClickedOK : Boolean;EFMethod:string;
begin
  Screen.Cursor := crHourGlass;
  WriteFileForEfCom;
  h := ShellExecute(MdiHandle, Nil, 'GPCOM.EXE', Nil,
  {h := ShellExecute(MainForm.Handle, Nil, 'EFCOM.EXE', Nil,}
  Nil, SW_RESTORE);
  If H<=32 then
  Begin
   ShowMessage('Program cannot execute. Error Code = '+IntToStr(h));
   SomeList := TStringList.Create;
   SomeCaption := 'Error codes';
   SomeList.LoadFromFile(AppDir+'\'+'SHELLERR.D');
   Application.CreateForm(TPoplist,PopList);
   PopList.ShowModal;
   SomeList.Free; PopList.Release;
  end;
  Screen.Cursor := crDefault;
end;
*)

Function GetCopiesToPrint(FName:string;TemplForms:TstringList;
        TemplCopies:TStringList):String;
Var j:integer;
begin
 Result :='0';
 For j:=0 to TemplForms.Count-1 do
   If ExtractNonInstFormName(FName) = TemplForms[j] then
     begin result :=TemplCopies[j];exit;end;
end;


Function GetQueryName(QDescr: string): string;
var i: integer;
begin
 result := '';
 //20160107
 If QDescr = 'All' then begin Result:= QDescr; exit; end;
 //20210801
 If QDescr = 'AuthRepAndNotAutoFilled' then begin Result:= QDescr; exit; end;
 If QDescr = 'AuthRepDone' then begin Result:= QDescr; exit; end;
 If QDescr = 'AuthRepNotDone' then begin Result:= QDescr; exit; end;

 For i:= Low(EFQueries) to High(EFQueries) do
   If QDescr = EFStatusDescr[i] then
    begin
     Result := EFqueries[i];
     break;
    end;
 For i:= Low(PRPQueries) to High(PRPQueries) do
   If QDescr = PRPStatusDescr[i] then
    begin
     Result := PRPqueries[i];
     break;
    end;
end;

Procedure CopyFields(FromRetNo,ToRetNo,FNo,Ndx1,Ndx2:integer);
Var i:integer;
begin
 If Ret[ToRetNo].Frm[FNo].Count =0 then InitFormData(ToRetNo,FNo);
 For i := Ndx1 to Ndx2 do
    StoreElm(ToRetNo,FNo,i,FetchElmFNo(FromRetNo,FNo,i));
end;
(*
Function CopyFields(FromRetNo: integer;FromFormName: string;ToRetNo: integer;FromElm:Integer;ToElm:Integer):Integer;
Var I,j,FNo:integer;
begin
   FNo := GetFormNo(FromFormName);
   If Ret[FromRetNo].Frm[FNo].Count =0 then exit;
   If Ret[ToRetNo].FrmHasData[Fno] = false then InitFormData(ToRetNo,FNo);
   for i :=0 to FList.Count -1 do
   begin
     FRec := FList.Items[i];
     If Frec.FormName+Frec.FormInst = FromFormName then
      begin
         For j :=FromElm to ToElm do
          begin
            Ret[ToRetNo].Frm[Frec.FormNo].strings[j] :=
              FetchElm(FromRetNo,FromFormName,j);
          end;
          Calc(ToRetNo,FromFormName);
          Ret[ToRetNo].FrmHasData[Frec.FormNo]:=True;
          Result := Frec.FormNo;
          exit;
      end;
   end;
end;
*)
Procedure ClearFields(RetNo,FNo,Ndx1,Ndx2:integer);
Var i:integer;
begin
  For i := Ndx1 to Ndx2 do StoreElm(RetNo,FNo,i,'');
end;

Procedure CFZeroAmounts;
begin
 //CF_FirstTimeDon:=False; //20150217  Not used see Strings[182] in DON
 CF_AUTHREPIndic:='';  //20210227
 //CF_T1013Indic:='';  //20200313
 //CF_T1013Submitted:='';  //20200313
 CF_Climate2018:=0;CF_Climate2017:=0;
 CF_2013CapGainDed:=0;
 CF_RetPassword:='';
 CF_T1DDLastYear:='';
 CF_OSHPTG:=0;
 CF_T1005:=0;
 CF_AddAmtTax:=0;
 CF_Invoice:=0;
 CF_LPLoss:=0;
 CF_T1163MandAdj:=0;
 CF_T1163OptAdj:=0;
 CF_T1273MandAdj:=0;
 CF_T1273OptAdj:=0;
 CF_HBP:=0;
 CF_LLP:=0;
 cf_HBPTotWithdrawal:=0;
 cf_LLPTotWithdrawal:=0;
 cf_HBPBalance:=0;
 cf_LLPBalance:=0;
 cf_HBPT4RSP:=0;
 cf_LLPT4RSP:=0;
 Cf_HBPYears:=0;
 Cf_LLPYears:=0;
 cf_HBPRepayment:=0;
 cf_LLPRepayment:=0;
 CF_2000InclusionRate :='';
 CF_StockOptionBnf :=0;
 CF_NetCapLoss:=0;
 CF_StudentLoan:=0;
 CF_PriorYearStudentLoan:=0;  //20230311
 CF_DeductionRoom:=0;
 CF_PensAdj   :=0;
 CF_GSTRebate :=0;
 CF_Earned     :=0;
 Cf_Area       :='';
 Cf_Phone      :='';
 CF_SpouseBirth :='';
 Cf_Don      :=0;
 CF_Moving   :=0;
 Cf_UnclaimedRRSP  :=0;
 CF_CNILInc  :=0;
 Cf_CNILExp  :=0;
 Cf_CNILAddInv:=0;
 CF_AMT      :=0;
 CF_CgdFarmQsb  :=0;
 CF_TxblGain :=0;
 CF_Abil     :=0;
 CF_Ln253     :=0;
 CF_Itc       :=0;
 CF_Education :=0;
 CF_EducationPRV :=0;
 CF_ReserveA  :=0;
 CF_Reserve6684  :=0;
 CF_ReserveB  :=0;
 CF_ReserveC  :=0;
 CF_ReserveD  :=0;
 CF_Reserve2  :=0;
 CF_ON6115In2009 :=0;
end;

Procedure CFFilterLastYrAndStore(RetNo:Integer;FormNm:String;FNo:Integer;Elm:integer;Valu:String);
Var i,DestRow,SourceRow:Integer;CFR3FNo:Integer;
begin
 CurrentRoutine:='C/F filter';
 InfoFNo:=GetFormNo('INFO');  //20251127
 If Ret[RetNo].Frm[InfoFno].Count =0 then InitFormData(RetNo,InfoFNo);
 //20251127
 if myrollover=True then
 Begin
   StoreElm(RetNo,FNo,Elm,Valu);  {once}
   Exit;
 End;

 Try
 If FormNm = 'INFO' then
 begin
   StoreElm(RetNo,InfoFNo,Elm,Valu);  {once}
   // birthdate: if (MyRollover=true) and (elm=9) then Valu:=FetchElm(RetNo,InfoFNo,Elm);StoreElm(RetNo,InfoFNo,Elm,IncrYear(Valu)); end;
   //ShowMessage(IntToStr(Elm)+' '+valu);
   StoreElm(RetNo,InfoFNo,143,'');  //autofill received //20201230
   StoreElm(RetNo,InfoFNo,171,'');  //move to new province
   //newcomer in prev year incom bboxes   //20150321
   StoreElm(RetNo,InfoFNo,139,'');  //firsttime filer //20260428
   StoreElm(RetNo,InfoFNo,144,'N');  //E-Signature //20200323
   StoreElm(RetNo,InfoFNo,211,'');
   StoreElm(RetNo,InfoFNo,212,'');
   StoreElm(RetNo,InfoFNo,213,'');
   StoreElm(RetNo,InfoFNo,214,'');
   StoreElm(RetNo,InfoFNo,215,''); //spouse entry
   StoreElm(RetNo,InfoFNo,216,'');
   StoreElm(RetNo,InfoFNo,223,'');  //refile indicator  //20180301
   StoreElm(RetNo,InfoFNo,272,'');  //rSold princ residence  //20180311
   //20260306
   For i:=229 to 232 do begin StoreElm(RetNo,InfoFNo,i,''); end;  //immigrant etc
   StoreElm(RetNo,InfoFNo,139,'');  //First time filer indicator
   //For i:=233 to 235 do begin StoreElm(RetNo,InfoFNo,i,''); end;  //First time filker
   StoreElm(RetNo,InfoFNo,26,'');  //dd entry to canada
   StoreElm(RetNo,InfoFNo,25,'');  //mm entry to canada


   StoreElm(RetNo,InfoFNo,47,''); //20120206 //used to have the Discounter indicator
 //  If (Elm=47) and (valu='3') then StoreElm(RetNo,InfoFNo,102,'X');  //20120206
   If Elm=23 then
   begin
    If valu='F' then
     StoreElm(RetNo,InfoFNo,109,'X')
    else
     If valu='M' then StoreElm(RetNo,InfoFNo,108,'X');
   end;
   //20131215
   If (Elm=104) and (valu>'') then StoreElm(RetNo,InfoFNo,105,'X');
   If (Elm=133) and (valu>'') then StoreElm(RetNo,InfoFNo,134,'X');

   For i:=56 to 57 do StoreElm(RetNo,InfoFNo,i,'');  {name change}
   For i:=25 to 28 do StoreElm(RetNo,InfoFNo,i,'');  {entry/departure}
   For i:=39 to 40 do StoreElm(RetNo,InfoFNo,i,'');  //mar status change
   StoreElm(RetNo,InfoFNo,88,''); //first time
   StoreElm(RetNo,InfoFNo,112,''); //signing data
   StoreElm(RetNo,InfoFNo,124,''); //due date //20090203

   StoreElm(RetNo,InfoFNo,128,''); //Indian //20200401
 end;   //info

 If (FormNm = 'T1') and (Elm = 423) then Cf_GSTRebate := Vl(Valu);

 If (FormNm = 'AUTHREP#1') and ((Elm = 11) Or (Elm=26))then Cf_AuthRepIndic := Valu; //20200313 //prior 11 or last year 26

 //If (FormNm = 'T1013#1') and (Elm = 11) then Cf_T1013Indic := Valu; //20200313


 If (FormNm = 'YRSUM') then //20200308
 Begin
  If (Elm = 783) then Cf_Climate2018:=Vl(Valu);
  If (Elm = 784) then Cf_Climate2017:=Vl(Valu);
 End;
 //t11d info  20140127  //20140217
 //20150210

 If (FormNm = 'T1DD') and (Elm = 33) then
  begin If UpperCase(Valu)='X' then CF_T1DDLastYear:='X'; end;

 If (FormNm = 'T1DD') and (Elm = 1) then
  begin If UpperCase(Valu)='X' then CF_T1DDLastYear:='X'; end;
 If (FormNm = 'T1DD') and (Elm = 8) then
  begin If UpperCase(Valu)='X' then CF_T1DDLastYear:='X'; end;
 If (FormNm = 'T1DD') and (Elm = 9) then
  begin If UpperCase(Valu)='X' then CF_T1DDLastYear:='X'; end;
 If (FormNm = 'T1DD') and (Elm = 15) then
  begin If UpperCase(Valu)='X' then CF_T1DDLastYear:='X'; end;
 If (FormNm = 'T1DD') and (Elm = 14) then
  begin If UpperCase(Valu)='X' then CF_T1DDLastYear:='X'; end;



 If (FormNm = 'T1') and (Elm = 302) then Cf_PensAdj := Vl(Valu);
 If (FormNm = 'T1005') and (Elm = 26)
    then Cf_T1005 := Vl(Valu);  //20110407
 If (FormNm = 'ON479') and (Elm = 79) then CF_ON6115In2009 := Vl(Valu);
 If (FormNm = 'STATUS') and (Elm = 17) then
       CF_RetPassword := Valu;  //20110104

 If (FormNm = 'MCREDIT') and (Elm = 67) then Cf_OSHPTG := Vl(Valu);  //20120304


 If (FormNm = 'RRSP') then
 begin
  If (Elm = 100) then cf_HBPTotWithdrawal:= MyStrToInt(Valu);
  If (Elm = 99)  then cf_LLPTotWithdrawal:= MyStrToInt(Valu);
  If (Elm = 96) then Cf_HBPBalance := MyStrToInt(Valu);
  If (Elm = 72) then Cf_HBPRepayment := MyStrToInt(Valu);
  If (Elm = 83) then Cf_HBPYears := MyStrToInt(Valu);

  If (Elm = 95) then Cf_LLPBalance := MyStrToInt(Valu);
  If (Elm = 75) then Cf_LLPRepayment := MyStrToInt(Valu);
  If (Elm = 87) then Cf_LLPYears := MyStrToInt(Valu);
 end;
 If (FormNm = 'CFR') and (Elm = 77) then Cf_LPLoss := Vl(Valu);
 If (FormNm = 'ABIL') and (Elm = 57) then Cf_ABIL := Vl(Valu);  //20100305

 If (FormNm = 'S3') and (Elm = 97) then Cf_TxblGain := MaxR(0,Vl(Valu)); //gain in prior yr
 If (FormNm = 'STLOAN') and (Elm = 41) then Cf_StudentLoan := Vl(Valu);  //c/f to nxt yr
 If (FormNm = 'STLOAN') and (Elm = 33) then Cf_PriorYearStudentLoan := Vl(Valu);  //c/f to nxt yr
 If (LeftStr(FormNm,4) = 'T1M#') and (Elm = 129)  then
    Cf_MOVING := Cf_Moving+Vl(Valu);
 If (FormNm = 'INVOICE') and (Elm =222)  then Cf_Invoice := Vl(Valu);
 If (FormNm = 'S11') and (Elm =11)  then Cf_Education := Vl(Valu);
 If (FormNm = 'S11PRV') and (Elm =11)  then
    Cf_EducationPRV := Vl(Valu);
 If (FormNm = 'T1212') and (Elm =6)  then Cf_StockOptionBnf := Vl(Valu);

 If (FormNm = 'T2017') then  //20101127
 begin
  If (Elm = 2)  then Cf_ReserveA := Vl(Valu);
  If (Elm = 9)  then Cf_Reserve6684 := Vl(Valu);
  If (Elm = 6)  then Cf_ReserveB := Vl(Valu);
  If (Elm = 11) then Cf_ReserveC := Vl(Valu);
  If (Elm = 15) then Cf_ReserveD := Vl(Valu);
  If (Elm = 122) then Cf_Reserve2 := Vl(Valu);  //20141212 //If (Elm = 22) then Cf_Reserve2 := Vl(Valu);
 end;

 If (FormNm = 'S7') then
 begin
  If Elm = 10  then  Cf_UnclaimedRRSP := Vl(Valu);
  If Elm = 4  then Cf_HBP := Vl(Valu);
  If Elm = 13  then Cf_LLP := Vl(Valu);
  If Elm = 23  then Cf_HBPT4RSP := Vl(Valu);
  If Elm = 15  then Cf_LLPT4RSP := Vl(Valu);
 end;

 //If (FormNm = 'TAXSUM')  and (Elm = 141)  then  Cf_DeductionRoom := Vl(Valu);
 If (FormNm = 'RRSPNXT')  and (Elm = 10)  then  Cf_DeductionRoom := Vl(Valu); //20120227

 If (FormNm = 'TAXSUM')  and (Elm = 116)  then Cf_NetCapLoss := Vl(Valu);
 If (FormNm = 'T936') and (Elm = 145)  then  Cf_CNILExp := Vl(Valu);
 If (FormNm = 'T936') and (Elm = 149)  then  Cf_CNILInc := Vl(Valu);
 If (FormNm = 'T936') and (Elm = 121)  then Cf_CNILAddInv := Vl(Valu); //??

 If (FormNm = 'T691') and (Elm = 316)  then Cf_AddAMTTax := Vl(Valu);

 If (FormNm = 'T691') and (Elm = 324)  then Cf_AMT := Vl(Valu);
 //20100305
 If (FormNm = 'T657') and (Elm = 221)  then Cf_CgdFarmQsb := Cf_CgdFarmQsb+Vl(Valu);  {qfarm claimed in prior yr}
 If (FormNm = 'T657') and (Elm = 3)  then CF_2013CapGainDed:=CF_2013CapGainDed+vl(valu);  //20150320

 If (FormNm = 'T1') and (Elm = 330)  then Cf_Ln253 := Vl(Valu);
 If (FormNm = 'T2038') and (Elm = 146)  then Cf_Itc := Vl(Valu);
 If (LeftStr(FormNm,4) = 'T4AP') and (Elm = 13)  then
    Cf_Earned := Cf_Earned+ Vl(Valu);


 If FormNm = 'T1' then
 begin
  If (Elm = 203) or (Elm = 205) or (elm = 215)
     or (Elm = 217) or (Elm = 222) or (elm = 224)
     or (Elm = 226) or (Elm = 228) or (elm = 230) then
    CF_earned := Cf_earned + Vl(valu);
 end;

 If FormNm = 'T1' then
 begin
   If (Elm = 306) or (Elm = 312) or (elm = 315) then
    CF_earned := Cf_earned - Vl(valu);
 end;

 If LeftStr(FormNm,3) = 'T4#' then
 begin
   If (CfT4=True) and (elm=1) then
     StoreElm(RetNo,FNo,Elm,Valu);
 end;

 If LeftStr(FormNm,7) = 'T5MULT#' then
 begin
   If (CfT5=True) then
   begin
    Case elm of
    1,23,45,67,89,14,36,58,80,102: StoreElm(RetNo,FNo,Elm,Valu);
    end;  //case
   end;
 end;

 //20110320
 If LeftStr(FormNm,7) = 'T3MULT#' then
 begin
    Case elm of
    17..21: StoreElm(RetNo,FNo,Elm,Valu);
    23..27: StoreElm(RetNo,FNo,Elm,Valu);
    end;  //case
 end;


 If FormNm = 'T1163#1' then
 begin
   If Elm = 608 then CF_T1163OptAdj:=Vl(valu);
 end;

 If FormNm = 'T1163#1' then
 begin
   If Elm = 610 then CF_T1163MandAdj:=Vl(valu);
 end;

 If FormNm = 'T1273#1' then
 begin
   If Elm = 608 then CF_T1273OptAdj:=Vl(valu);
 end;

 If FormNm = 'T1273#1' then
 begin
   If Elm = 610 then CF_T1273MandAdj:=Vl(valu);
 end;

 If (FormNm = 'DEPEND')
 or (LeftStr(FormNm,5) = 'T776#') {rental}
 or (LeftStr(FormNm,8) = 'T776SUM#') {rental}
 or (LeftStr(FormNm,9) = 'T2125SUM#')
 or (LeftStr(FormNm,9) = 'T2121SUM#')
 or (LeftStr(FormNm,9) = 'T2042SUM#')
 or (LeftStr(FormNm,9) = 'T1163SUM#')
 or (LeftStr(FormNm,9) = 'T1273SUM#')

 or (LeftStr(FormNm,4) = 'T777') {Empl exp}
 or (LeftStr(FormNm,6) = 'T2125#')     //20101214
 or (LeftStr(FormNm,6) = 'T2121#')
 or (LeftStr(FormNm,6) = 'T2042#')
 or (LeftStr(FormNm,6) = 'T1163#')
 or (LeftStr(FormNm,6) = 'T1273#')
 or (LeftStr(FormNm,5) = 'T1175')
 or (LeftStr(FormNm,6) = 'T1175H')
 or (LeftStr(FormNm,4) = 'MIA#')
 or (LeftStr(FormNm,5) = 'T1139')
 or (LeftStr(FormNm,4) = 'T664')
 or (LeftStr(FormNm,3) = 'CFR')
 or (LeftStr(FormNm,6) = 'PRIVAT')
 or (LeftStr(FormNm,7) = 'ACBOTHR')
 or (LeftStr(FormNm,6) = 'ACBFRM')
 or (LeftStr(FormNm,8) = 'ASSETSB#')
 or (LeftStr(FormNm,6) = 'AUTOS#')
 or (LeftStr(FormNm,8) = 'AUTO777#')
 or (LeftStr(FormNm,6) = 'FLTHRU')
 or (LeftStr(FormNm,6) = 'T1229')
 or (LeftStr(FormNm,4) = 'T657')
 or (LeftStr(FormNm,7) = 'MEDICAL')
 or (LeftStr(FormNm,7) = 'MEDSUPL')
 or (LeftStr(FormNm,7) = 'STLOAN')
 or (LeftStr(FormNm,5) = 'T1013')

 or (FormNm = 'T1212')
 or (FormNm            = 'DON')
 or (LeftStr(FormNm,5) = 'YRSUM')   // 20120303

 or (LeftStr(FormNm,8) = 'T776SUM#')   // 20120221

 or (LeftStr(FormNm,7) = 'T2032A#')
 or (LeftStr(FormNm,7) = 'T2042A#')
 or (LeftStr(FormNm,7) = 'T2121A#')
 or (LeftStr(FormNm,6) = 'T776A#')
 or (LeftStr(FormNm,8) = 'CCAMULT#')
 //or (LeftStr(FormNm,6) = 'OT1219')
 or (LeftStr(FormNm,6) = 'T1005')
 then
 begin
  StoreElm(RetNo,FNo,Elm,Valu);
 end;
 except
   ShowMessage('Data import may be incomplete - Form '+FormNm);
 end;

end;

Function IncrementYear(YYYYMMDD:String):String;
Var s:string[4];
begin
 s:=LeftStr(YYYYMMDD,4);
 result:=IntToStr(MyStrToInt(s)+1)+MidStr(YYYYMMDD,5,6);
end;

Procedure CFReformatPrvYearData(RetNo:Integer);
Var I,j,k,FNo:Integer; x,y:Real;Inst :String[3];s:String;
  MedToDate:String[10];T1273FNo:Integer;
begin
 //Exit;  //20181230 TEMP  used only once a year to rolover the T1013 without erasing the T1013 data
Try
 CurrentRoutine:='C/F reformat';  //20101216
 Fno := GetFormNo('T1');
 Calc(RetNo,'T1');
 {Private}
 Fno := GetFormNo('PRIVAT#1');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 Calc(RetNo,'PRIVAT#1');

 //20140127
 Fno := GetFormNo('T1DD');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,33,CF_T1ddLastYear);
 Calc(RetNo,'T1DD');

 //20260227 JZ
 Fno := GetFormNo('AUTHREP#1');  //20200209
 If (Fno > 0) and (Ret[RetNo].Frm[Fno].Count =0) then  //jz//20260227 - does not find form, causes error when calculating the count - add condition that fno has to be > zero
  InitFormData(RetNo,FNo);
 //20210227
 if (FetchElm(RetNo,'AUTHREP#1',11)>'') or (FetchElm(RetNo,'AUTHREP#1',26)>'') then
   StoreElm(RetNo,FNo,11,'X');
 If UpperCase(CF_AuthRepIndic)='X' then StoreElm(RetNo,FNo,11,'X'); //20210227

 {//20260227 JZ
 Fno := GetFormNo('AUTHREP#1');  //20200209
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 //20210227
 if (FetchElm(RetNo,'AUTHREP#1',11)>'') or (FetchElm(RetNo,'AUTHREP#1',26)>'') then
   StoreElm(RetNo,FNo,11,'X');

 If UpperCase(CF_AuthRepIndic)='X' then StoreElm(RetNo,FNo,11,'X'); //20210227
 }



  {Don}
 Fno := GetFormNo('DON');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 If Vl(FetchElmFNo(RetNo,FNo,186))>0 then StoreElm(RetNo,FNo,182,'Y');
 ClearFields(RetNo,FNo,1,88);
 ClearFields(RetNo,FNo,134,134);
 StoreElm(RetNo,FNo,169,FetchElmFNo(RetNo,FNo,174));
 ClearFields(RetNo,FNo,170,174);
 {move up}
 StoreElm(RetNo,FNo,136,FetchElmFNo(RetNo,FNo,144));
 StoreElm(RetNo,FNo,141,FetchElmFNo(RetNo,FNo,93));
 ClearFields(RetNo,FNo,137,139);
 ClearFields(RetNo,FNo,142,144);
 J:=90;
 repeat
  StoreElm(RetNo,FNo,j,FetchElmFNo(RetNo,FNo,j+8));
  ClearFields(RetNo,FNo,j+1,J+3);
  Inc(j,5);
 until j>105;

 Calc(RetNo,'DON');

 {T1212}
 FNo:=GetFormNo('T1212');
 StoreElm(RetNo,FNo,2,FloatToStr(CF_StockOptionBnf));
 ClearFields(RetNo,FNo,3,6);

 //T1005  //20110407
 FNo:=GetFormNo('T1005');
 StoreElm(RetNo,FNo,13,FloatToStr(CF_T1005));
 ClearFields(RetNo,FNo,1,12);
 ClearFields(RetNo,FNo,14,26);

 {MEDICAL}
  FNo:=GetFormNo('MEDICAL');
  MedToDate:=FetchElmFNo(RetNo,FNo,3);
  StoreElm(RetNo,FNo,1,IncrDay(MedToDate));
  StoreElm(RetNo,FNo,3,IncrYear(MedToDate));
  j:=5;k:=137;
  repeat
   If FetchElmFNo(RetNo,FNo,j) <= MedToDate then  //claimed last yr
   begin
    ClearFields(RetNo,FNo,j,j+4);
    ClearFields(RetNo,FNo,k,k);
   end;
   inc(j,5);
   Inc(k,1);
  until j>109;
  ClearFields(RetNo,FNo,110,136);

 {T2038}
 Fno := GetFormNo('T2038');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,137,FloatToStr(CF_Itc));
 Calc(RetNo,'T2038');


 //STLOAN
 Fno := GetFormNo('STLOAN');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 //clear current yr section
 ClearFields(RetNo,FNo,1,13);
 ClearFields(RetNo,FNo,37,41);
 ClearFields(RetNo,FNo,43,43);  //autoclaim indicator
 //ClearFields(RetNo,FNo,43,43);  //autoclaim indicator
 StoreElm(RetNo,FNo,43,'N');

 //StoreElm(RetNo,FNo,33,''); //20230311 Must do to remove last years claim first
 i:=14; //push up the records
 Repeat
  StoreElm(RetNo,FNo,i,FetchElmFno(RetNo,FNo,i+4));  //yr
  StoreElm(RetNo,FNo,i+1,''); //FetchElmFNo(RetNo,FNo,i+1+4)); //opening
  StoreElm(RetNo,FNo,i+2,''); //claimed in year               //clained in yr
  StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+3+4));       //closing
  s:=FetchElmFNo(RetNo,FNo,i+3+4);
  Inc(i,4);
 until i>26;


 //get the closing into opening
 StoreElm(RetNo,FNo,15,FetchElmFNo(RetNo,FNo,17));
 StoreElm(RetNo,FNo,19,FetchElmFNo(RetNo,FNo,21));
 StoreElm(RetNo,FNo,23,FetchElmFNo(RetNo,FNo,25));
 s:=FetchElmFNo(RetNo,FNo,29);
 StoreElm(RetNo,FNo,27,FormatFloat('######.##',CF_PriorYearStudentLoan)); //FetchElmFNo(RetNo,FNo,29));
 s:=FetchElmFNo(RetNo,FNo,27);

 StoreElm(RetNo,FNo,30,Appyear);
 StoreElm(RetNo,FNo,31,'');
 StoreElm(RetNo,FNo,32,'');
 StoreElm(RetNo,FNo,33,'');

 StoreElm(RetNo,FNo,43,'Y'); //put back the Yes
 Calc(RetNo,'STLOAN');

 {Status}
 Fno := GetFormNo('STATUS');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 ClearFields(RetNo,FNo,24,30);
 ClearFields(RetNo,FNo,8,10);
 ClearFields(RetNo,FNo,11,14);
 ClearFields(RetNo,FNo,18,20);
 ClearFields(RetNo,FNo,21,23);
 ClearFields(RetNo,FNo,16,16);
 ClearFields(RetNo,FNo,31,31);
 StoreElm(RetNo,FNo,4,'00');
 StoreElm(RetNo,FNo,15,'00');
 StoreElm(RetNo,FNo,17,CF_RetPassword);  //20110104
 Calc(RetNo,'STATUS');
 Ret[RetNo].EfStatus := '00';
 Ret[RetNo].PrpStatus := '00';

 {DEPEND}
 Fno := GetFormNo('DEPEND');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 i:=10;
 Repeat
   If FetchElmFNo(RetNo,FNo,i) >'' then StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i));
   Inc(i,15);
 until i> 130;
 {remove depandants over 18 and not infirm}
 i:=10;
 Repeat
   If FetchElmFNo(RetNo,FNo,i) >'' then
   begin
   end;
  Inc(i,15);
 until i> 130;
 {remove dep ni}
 i:=13;
 Repeat
  StoreElm(RetNo,FNo,i,'');
  Inc(i,15);
 until i> 133;

 {remove dep Txbl }  //20090212
 i:=150;
 Repeat
  StoreElm(RetNo,FNo,i,'');
  Inc(i,1);
 until i> 158;

 ClearFields(RetNo,FNo,38,38); //overrides
 ClearFields(RetNo,FNo,23,23);
 Calc(RetNo,'DEPEND');

 {others}
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   FNo :=Frec.FormNo;
   If Ret[RetNo].FrmHasData[FNo] then
   begin      //20101207
    {
     if FRec.FormName = 'T777S' then //20220202
     begin
      ClearFields(RetNo,FNo,18,18); //days
     end;
    }
     {Empl exp}
     if FRec.FormName = 'T777' then
     begin
       s:=FetchElmFNo(RetNo,FNo,53); {cf}
       ClearFields(RetNo,FNo,1,53);
       Ret[RetNo].Frm[FNo].Strings[49]:=s;
       Calc(RetNo,Frec.FormName);

       Ret[RetNo].Frm[FNo].Strings[185]:= '';
       Ret[RetNo].Frm[FNo].Strings[186]:= '';
       j:=102;
       Repeat
        Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
        ClearFields(RetNo,FNo,j+1,j+6);
        Inc(j,9);
       until j>165;

       j:=178;
       Repeat
        Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+6);
        ClearFields(RetNo,FNo,j+1,j+5);
        Inc(j,12);
       until j>202;
       Calc(RetNo,Frec.FormName);
    end;

    if FRec.FormName = 'MEDSUPL' then
    begin
     MedToDate:=FetchElmFNo(RetNo,FNo,3);
     StoreElm(RetNo,FNo,1,IncrDay(MedToDate));
     StoreElm(RetNo,FNo,3,IncrYear(MedToDate));
     j:=5;k:=110;
     repeat
      If FetchElmFNo(RetNo,FNo,j) <= MedToDate then  //claimed last yr
      begin
       ClearFields(RetNo,FNo,j,j+4);
       ClearFields(RetNo,FNo,k,k);
      end;
      inc(j,5);
      Inc(k,1);
     until j>105;
    end;

   {CCA free standing}
    if FRec.FormName = 'CCAMULT' then
    begin
       j:=3;
       Repeat
        StoreElm(RetNo,FNo,j, '');
        StoreElm(RetNo,FNo,j+1, '');
        StoreElm(RetNo,FNo,j+2, '');
        StoreElm(RetNo,FNo,j+3, '');
        StoreElm(RetNo,FNo,j+4, '');
        StoreElm(RetNo,FNo,j+5, '');
        StoreElm(RetNo,FNo,j+7, '');
        StoreElm(RetNo,FNo,j-1,FetchElmFNo(RetNo,FNo,j+6));
       Inc(j,10);
       until j>73;

       j:=85;
       Repeat
        StoreElm(RetNo,FNo,j, '');
        StoreElm(RetNo,FNo,j+1, '');
        StoreElm(RetNo,FNo,j+2, '');
        StoreElm(RetNo,FNo,j+3, '');
        StoreElm(RetNo,FNo,j+4, '');
        StoreElm(RetNo,FNo,j+5, '');
        StoreElm(RetNo,FNo,j+7, '');
        StoreElm(RetNo,FNo,j-1,FetchElmFNo(RetNo,FNo,j+6));
       Inc(j,10);
       until j>115;

    end;

    {rental}
    if FRec.FormName = 'T776' then
    begin
     // StoreLastYearT776Sum(RetNo,Frec.FormInst);   //20101216    //20120309  //20120401
      Ret[RetNo].Frm[FNo].Strings[3]:=IncrementYear(FetchElmFNo(RetNo,FNo,3));
      Ret[RetNo].Frm[FNo].Strings[6]:=IncrementYear(FetchElmFNo(RetNo,FNo,6));
      ClearFields(RetNo,FNo,47,47);
      ClearFields(RetNo,FNo,50,50);
      ClearFields(RetNo,FNo,53,53);
      j:=57;  //exp and personal, leave % in
      Repeat
       ClearFields(RetNo,FNo,j,j);
       ClearFields(RetNo,FNo,j+2,j+2);
       Inc(j,3);
      until j>90;
      ClearFields(RetNo,FNo,54,56);
      ClearFields(RetNo,FNo,94,108);
      ClearFields(RetNo,FNo,7,8);
      ClearFields(RetNo,FNo,20,21);
      ClearFields(RetNo,FNo,130,133);
      ClearFields(RetNo,FNo,93,93);

      ClearFields(RetNo,FNo,267,358);
      j:=202;
      Repeat
       Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
       ClearFields(RetNo,FNo,j+1,j+6);
       Inc(j,9);
      until j>256;
      ClearFields(RetNo,FNo,264,264);
      //Calc(RetNo,Frec.FormName);  out
     // Calc(RetNo,Frec.FormName+Frec.FormInst); //20120417
      If FetchElmFNo(RetNo,FNo,9) > '' then  ClearFields(RetNo,FNo,1,356); //last yr

    end;


     if FRec.FormName = 'MIA' then
     begin
       //add the last year to the very end
       j:=75;
       For k:=0 to 7 do StoreElm(RetNo,FNo,j+8+k,
         FormatFloat('########',vl(FetchElmFNo(RetNo,FNo,83+k))+vl(FetchElmFNo(RetNo,FNo,75+k))));

       j:=67;   //push down
       Repeat
        For k:=0 to 7 do StoreElm(RetNo,FNo,j+8+k,FetchElmFNo(RetNo,FNo,j+k));
       Inc(j,-8);
       until j<0;
      ClearFields(RetNo,FNo,3,10);
      //clear inv at end  //20100407
      j:=13;
      Repeat
       ClearFields(RetNo,FNo,j,j);
       ClearFields(RetNo,FNo,j+1,j+1);
       Inc(j,8);
      until J>77;
      //purch inventory  //20100407
      j:=18;
      Repeat
       ClearFields(RetNo,FNo,j,j);
       Inc(j,8);
      until J>82;

     //20100407
      ClearFields(RetNo,FNo,85,85);
      ClearFields(RetNo,FNo,86,86);
      ClearFields(RetNo,FNo,90,90);
      ClearFields(RetNo,FNo,99,99);   //optional used last year //20130314
      Calc(RetNo,Frec.FormName);

     end;


     if FRec.FormName = 'T1229' then
     begin
      Ret[RetNo].Frm[FNo].Strings[1]:= FetchElmFNo(RetNo,FNo,44);
      Ret[RetNo].Frm[FNo].Strings[2]:= FetchElmFNo(RetNo,FNo,45);
      Ret[RetNo].Frm[FNo].Strings[3]:= FetchElmFNo(RetNo,FNo,46);
      Ret[RetNo].Frm[FNo].Strings[4]:= FetchElmFNo(RetNo,FNo,47);
      ClearFields(RetNo,FNo,5,114);
      Calc(RetNo,Frec.FormName);
     end;

     if FRec.FormName = 'OT1219' then //ont min tax
     begin
      ClearFields(RetNo,FNo,1,18);
      ClearFields(RetNo,FNo,27,35);
      Ret[RetNo].Frm[FNo].Strings[26]:= FetchElmFNo(RetNo,FNo,25);
      Ret[RetNo].Frm[FNo].Strings[25]:= FetchElmFNo(RetNo,FNo,24);
      Ret[RetNo].Frm[FNo].Strings[24]:= FetchElmFNo(RetNo,FNo,23);
      Ret[RetNo].Frm[FNo].Strings[23]:= FetchElmFNo(RetNo,FNo,22);
      Ret[RetNo].Frm[FNo].Strings[22]:= FetchElmFNo(RetNo,FNo,20);
      Ret[RetNo].Frm[FNo].Strings[20]:= FetchElmFNo(RetNo,FNo,19);
      Ret[RetNo].Frm[FNo].Strings[19]:= FormatFloat('########.##',CF_AddAmtTax);
      Calc(RetNo,Frec.FormName);
     end;


     if FRec.FormName = 'FLTHRU' then
      begin
       j:=51;
       Repeat
        Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+9);
        ClearFields(RetNo,FNo,j+1,j+8);
        Inc(j,10);
       until j>141;
       ClearFields(RetNo,FNo,151,152);
       Calc(RetNo,Frec.FormName);
      end;

      if FRec.FormName = 'T657' then
      begin
       x:=CF_2013CapGainDed; //20150320
       StoreElm(RetNo,FNo,4,FloatToStr(x)); //20150320

       Ret[RetNo].Frm[FNo].Strings[242]:= 'N';  //20140224  //override
       Ret[RetNo].Frm[FNo].Strings[232]:= '0';  //20140224
       Ret[RetNo].Frm[FNo].Strings[244]:= 'N';  //20140224
       Ret[RetNo].Frm[FNo].Strings[234]:= '0';  //20140224
       Ret[RetNo].Frm[FNo].Strings[398]:= FetchElmFNo(RetNo,FNo,302);  //?????
       Ret[RetNo].Frm[FNo].Strings[399]:= FetchElmFNo(RetNo,FNo,303);


       j:=302;
       Repeat
        Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+8);
        Ret[RetNo].Frm[FNo].Strings[j+1]:= FetchElmFNo(RetNo,FNo,j+8+1);
        Ret[RetNo].Frm[FNo].Strings[j+2]:= FetchElmFNo(RetNo,FNo,j+8+2);
        Ret[RetNo].Frm[FNo].Strings[j+3]:= FetchElmFNo(RetNo,FNo,j+8+3);
        Inc(j,8);
       until j>374;
       (*  ???? was under T657  -4 in prev version //20100617
       ClearFields(RetNo,FNo,81,88);
       Ret[RetNo].Frm[FNo].Strings[84]:= FloatToStr(Cf_CNILAddInv);
       Ret[RetNo].Frm[FNo].Strings[82]:= FloatToStr(Cf_Ln253);
       *)
       Calc(RetNo,Frec.FormName);
       If Ret[RetNo].FrmHasData[Fno] then
         Ret[RetNo].FrmHasData[GetFormNo('T657')]:=True;
      end;

      {T1139}
      if FRec.FormName = 'T1139' then
      begin
       Ret[RetNo].Frm[FNo].Strings[22]:=Ret[RetNo].Frm[FNo].Strings[19]; //20110310
       //20101210
       s:=Ret[RetNo].Frm[FNo].Strings[2];
       If S>'' then
       begin
        s:=ReplaceStr(S,'_1', '');
        s:=ReplaceStr(S,'_2', '');
        s:=ReplaceStr(S,'_3', '');
        s:=ReplaceStr(S,'_4', '');
        s:=ReplaceStr(S,'_4', '');
        StoreElm(RetNo,FNo,2,s);
       end;

       ClearFields(RetNo,FNo,6,7);
       ClearFields(RetNo,FNo,9,11);
       ClearFields(RetNo,FNo,13,13);
       ClearFields(RetNo,FNo,15,17);

       ClearFields(RetNo,FNo,18,19);
       ClearFields(RetNo,FNo,21,21);
       ClearFields(RetNo,FNo,23,23);
       ClearFields(RetNo,FNo,26,26);
       ClearFields(RetNo,FNo,28,30);
       ClearFields(RetNo,FNo,32,32);
      end;

     //assets b
      if FRec.FormName = 'ASSETSB' then
      begin
        ClearFields(RetNo,FNo,9,9);   //20260228 factor 1
        ClearFields(RetNo,FNo,17,17);   //20260228 factor 2
        Ret[RetNo].Frm[FNo].Strings[191]:=Ret[RetNo].Frm[FNo].Strings[176];
        ClearFields(RetNo,FNo,22,26);  //additions  //20100307
        ClearFields(RetNo,FNo,30,34);  //additions
        ClearFields(RetNo,FNo,12,12);
        ClearFields(RetNo,FNo,15,15);
        ClearFields(RetNo,FNo,8,8);
        ClearFields(RetNo,FNo,158,158);
        ClearFields(RetNo,FNo,6,6);  //clas empty
        ClearFields(RetNo,FNo,13,13); //override
        ClearFields(RetNo,FNo,206,206);
        ClearFields(RetNo,FNo,28,28);
      end;
     //Autos
      if FRec.FormName = 'AUTOS' then
      begin
        Ret[RetNo].Frm[FNo].Strings[191]:=Ret[RetNo].Frm[FNo].Strings[176]; //20240218
        //Ret[RetNo].Frm[FNo].Strings[140]:=Ret[RetNo].Frm[FNo].Strings[176];
        Ret[RetNo].Frm[FNo].Strings[4]:='1';  //km
        Ret[RetNo].Frm[FNo].Strings[7]:='1';
        ClearFields(RetNo,FNo,37,41); //additions
        ClearFields(RetNo,FNo,143,143);
        ClearFields(RetNo,FNo,15,15);  //disp
        ClearFields(RetNo,FNo,146,146);
        ClearFields(RetNo,FNo,197,200);
        ClearFields(RetNo,FNo,188,188);
        ClearFields(RetNo,FNo,182,182);  //class empty
        ClearFields(RetNo,FNo,206,206);
        ClearFields(RetNo,FNo,178,178);
        //expenses
        ClearFields(RetNo,FNo,10,10);
        ClearFields(RetNo,FNo,28,28);
        ClearFields(RetNo,FNo,19,19);
        ClearFields(RetNo,FNo,22,22);
        ClearFields(RetNo,FNo,25,25);
        ClearFields(RetNo,FNo,13,13);
        ClearFields(RetNo,FNo,29,29);
        ClearFields(RetNo,FNo,16,16);
        ClearFields(RetNo,FNo,32,32);
        ClearFields(RetNo,FNo,36,36);
        ClearFields(RetNo,FNo,48,48);
        ClearFields(RetNo,FNo,51,51);
        //rent
        ClearFields(RetNo,FNo,103,103);
        ClearFields(RetNo,FNo,109,109);
        ClearFields(RetNo,FNo,106,106);
        ClearFields(RetNo,FNo,57,57);
        ClearFields(RetNo,FNo,60,60);
        ClearFields(RetNo,FNo,63,63);
        ClearFields(RetNo,FNo,126,126);
        //leasing
        ClearFields(RetNo,FNo,66,66);
        ClearFields(RetNo,FNo,69,69);
        ClearFields(RetNo,FNo,72,72);
        ClearFields(RetNo,FNo,75,75);
      end;

     //Auto777
      if FRec.FormName = 'AUTO777' then
      begin
        Ret[RetNo].Frm[FNo].Strings[140]:=Ret[RetNo].Frm[FNo].Strings[176];
        Ret[RetNo].Frm[FNo].Strings[4]:='1';  //km
        Ret[RetNo].Frm[FNo].Strings[7]:='1';
        ClearFields(RetNo,FNo,12,12); //20100316
        ClearFields(RetNo,FNo,146,146);
        ClearFields(RetNo,FNo,197,200);
        ClearFields(RetNo,FNo,182,182);  //class empty
        ClearFields(RetNo,FNo,15,15);  //class empty
        ClearFields(RetNo,FNo,206,206);
        ClearFields(RetNo,FNo,173,173);

       //expenses
        ClearFields(RetNo,FNo,10,10);
        ClearFields(RetNo,FNo,28,28);
        ClearFields(RetNo,FNo,19,19);
        ClearFields(RetNo,FNo,22,22);
        ClearFields(RetNo,FNo,25,25);
        ClearFields(RetNo,FNo,13,13);
        ClearFields(RetNo,FNo,29,29);
        ClearFields(RetNo,FNo,16,16);
        ClearFields(RetNo,FNo,32,32);
        ClearFields(RetNo,FNo,36,36);
        ClearFields(RetNo,FNo,48,48);
        //rent
        ClearFields(RetNo,FNo,103,103);
        ClearFields(RetNo,FNo,109,109);
        ClearFields(RetNo,FNo,106,106);
        //leasing
        ClearFields(RetNo,FNo,57,57);
        ClearFields(RetNo,FNo,60,60);
        ClearFields(RetNo,FNo,63,63);
        ClearFields(RetNo,FNo,126,126);
        ClearFields(RetNo,FNo,66,66);
        ClearFields(RetNo,FNo,69,69);
        ClearFields(RetNo,FNo,72,72);
        ClearFields(RetNo,FNo,75,75);
      end;

     {bus}
     if FRec.FormName = 'T2125' then  //20101207
     begin
   //    StoreLastYearT2125Sum(RetNo,Frec.FormInst); //first store then clear 20101212  //20120401
       If Ret[RetNo].Frm[FNo].Strings[6]>'' then  //last yr of operation   //20100305
       begin
        ClearFields(RetNo,FNo,1,94);
       end
       Else
       begin
        Ret[RetNo].Frm[FNo].Strings[4]:=IncrementYear(FetchElmFNo(RetNo,FNo,4));
        Ret[RetNo].Frm[FNo].Strings[5]:=IncrementYear(FetchElmFNo(RetNo,FNo,5));
        //gst bus no
        ClearFields(RetNo,FNo,23,23); //  gross sales
        ClearFields(RetNo,FNo,24,24); //  GST etc  //20180121
        ClearFields(RetNo,FNo,29,29);  //resreves last year
        ClearFields(RetNo,FNo,30,30);  //oth income
        ClearFields(RetNo,FNo,35,35);  //from t5013    //20160404 //20160505 Igor
        ClearFields(RetNo,FNo,39,40);  //20130307
        ClearFields(RetNo,FNo,75,75);   //other income  //20180210
        ClearFields(RetNo,FNo,76,76);   //from t4a
        ClearFields(RetNo,FNo,83,83);
        ClearFields(RetNo,FNo,87,89); //prof income
        ClearFields(RetNo,FNo,84,84);
        ClearFields(RetNo,FNo,92,92);
        ClearFields(RetNo,FNo,178,178); //auto exp override
        ClearFields(RetNo,FNo,179,179); //auto exp override amount
        ClearFields(RetNo,FNo,17,17); //who prepared it //20130208
       end;

      s:=FetchElmFNo(RetNo,FNo,140); //closing inventory c/f
      ClearFields(RetNo,FNo,101,172);
      Ret[RetNo].Frm[FNo].Strings[133]:=s;  //20100307

      If FetchElmFNo(RetNo,GetFormNo(Frec.FormName+Frec.FormInst),206)>''  then //lst yer
        ClearFields(RetNo,FNo,201,275)
      else
      Begin
        s:=FetchElmFNo(RetNo,FNo,234); //home c/f
        ClearFields(RetNo,FNo,201,233);
        ClearFields(RetNo,FNo,201,235);
        ClearFields(RetNo,FNo,251,253);
        Ret[RetNo].Frm[FNo].Strings[231]:=s;  //20100224
      end;

      ClearFields(RetNo,FNo,301,513);
      If FetchElmFNo(RetNo,GetFormNo(Frec.FormName+Frec.FormInst),606)>''  then //lst yer
        ClearFields(RetNo,FNo,601,653)
      else
      Begin
       ClearFields(RetNo,FNo,601,641);
       s:=FetchElmFNo(RetNo,FNo,650); {cec}
       ClearFields(RetNo,FNo,642,655);
       Ret[RetNo].Frm[FNo].Strings[642]:=s;
      end;
      ClearFields(RetNo,FNo,701,873);
     END; //T2125

     {Fish}
     if FRec.FormName = 'T2121' then
     begin
      // StoreLastYearT2121Sum(RetNo,Frec.FormInst);    //20120401
       Ret[RetNo].Frm[FNo].Strings[4]:=
        IncrementYear(FetchElmFNo(RetNo,FNo,4));
       Ret[RetNo].Frm[FNo].Strings[5]:=
        IncrementYear(FetchElmFNo(RetNo,FNo,5));
       ClearFields(RetNo,FNo,13,13);  //who prepared it
       ClearFields(RetNo,FNo,20,74);
       ClearFields(RetNo,FNo,75,78);
       ClearFields(RetNo,FNo,61,61);
       If FetchElmFNo(RetNo,FNo,6)>'' then ClearFields(RetNo,FNo,1,17); //last year

       s:=FetchElmFNo(RetNo,FNo,131); {bus us cf}
       ClearFields(RetNo,FNo,101,135);
       ClearFields(RetNo,FNo,136,136);
       ClearFields(RetNo,FNo,281,282);  //20100301
       Ret[RetNo].Frm[FNo].Strings[128]:=s;
       j:=138;
       Repeat
        Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
        ClearFields(RetNo,FNo,j+1,j+6);
        ClearFields(RetNo,FNo,j+8,j+8);
        Inc(j,10);
       until j>208;
       j:=220;
       Repeat
        Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
        ClearFields(RetNo,FNo,j+1,j+6);
        ClearFields(RetNo,FNo,j+8,j+8);
        Inc(j,10);
       until j>250;
       ClearFields(RetNo,FNo,301,434);
       ClearFields(RetNo,FNo,501,502);
       s:=FetchElmFNo(RetNo,FNo,531); {cec}
       ClearFields(RetNo,FNo,523,536);
       Ret[RetNo].Frm[FNo].Strings[523]:=s;
     END; //t2121

     {farm}
     if FRec.FormName = 'T2042' then
     begin
     // StoreLastYearT2042Sum(RetNo,Frec.FormInst);   //20120401

      Ret[RetNo].Frm[FNo].Strings[4]:=IncrementYear(FetchElmFNo(RetNo,FNo,4));
      Ret[RetNo].Frm[FNo].Strings[5]:=IncrementYear(FetchElmFNo(RetNo,FNo,5));
      ClearFields(RetNo,FNo,19,19); //who prepared it
      //ClearFields(RetNo,FNo,26,66);  //leave 67 restr farm loss //20171216
      ClearFields(RetNo,FNo,26,33);  //leave 67 restr farm loss
      ClearFields(RetNo,FNo,36,66);  //leave 67 restr farm loss
       //20091226
      Ret[RetNo].Frm[FNo].Strings[127]:= FetchElmFNo(RetNo,FNo,141);
      Ret[RetNo].Frm[FNo].Strings[128]:= FetchElmFNo(RetNo,FNo,142);
      ClearFields(RetNo,FNo,101,126);
      ClearFields(RetNo,FNo,129,148);

      ClearFields(RetNo,FNo,201,334);

      s:=FetchElmFNo(RetNo,FNo,557);
      ClearFields(RetNo,FNo,525,562);
      ClearFields(RetNo,FNo,451,453);
      Ret[RetNo].Frm[FNo].Strings[549]:=s;
      ClearFields(RetNo,FNo,563,563);
      j:=402;
      Repeat
       Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
       ClearFields(RetNo,FNo,j+1,j+6);
       ClearFields(RetNo,FNo,j+8,j+8);
       Inc(j,10);
      until j>472;
      j:=484;
      Repeat
       Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
       ClearFields(RetNo,FNo,j+1,j+6);
       ClearFields(RetNo,FNo,j+8,j+8);
       Inc(j,10);
      until j>514;

      s:=FetchElmFNo(RetNo,FNo,635); {bus use}
      ClearFields(RetNo,FNo,601,639);
      Ret[RetNo].Frm[FNo].Strings[632]:=s;

    END; //t2042

    {NISA}
    if FRec.FormName = 'T1163' then
    begin
     // StoreLastYearT1163Sum(RetNo,Frec.FormInst);   //20120401

      For j:=8 to 19 do StoreElm(RetNo,FNo,j,FetchElmFNo(RetNo,FNo,j));
      Ret[RetNo].Frm[FNo].Strings[213]:=IncrementYear(FetchElmFNo(RetNo,FNo,213));
      Ret[RetNo].Frm[FNo].Strings[214]:=IncrementYear(FetchElmFNo(RetNo,FNo,214));
      ClearFields(RetNo,FNo,215,217);
      ClearFields(RetNo,FNo,218,352);
      ClearFields(RetNo,FNo,401,590);
      If Frec.FormInst='#1' then
       begin
        StoreElm(RetNo,FNo,538,FormatFloat('#########.##',CF_T1163MandAdj));
        StoreElm(RetNo,FNo,539,FormatFloat('#########.##',CF_T1163OptAdj));
       end;
    END; //T1163

    if FRec.FormName = 'T1273' then {cca}
    BEGIN
      //StoreLastYearT1273Sum(RetNo,Frec.FormInst); //20120401    //20120401
      //20110326
      Ret[RetNo].Frm[FNo].Strings[213]:=IncrementYear(FetchElmFNo(RetNo,FNo,213));
      Ret[RetNo].Frm[FNo].Strings[214]:=IncrementYear(FetchElmFNo(RetNo,FNo,214));

      ClearFields(RetNo,FNo,219,352);
      ClearFields(RetNo,FNo,401,590);
      ClearFields(RetNo,FNo,807,1122);       //20110326
      If Frec.FormInst='#1' then
       begin
        StoreElm(RetNo,FNo,538,FormatFloat('#########.##',CF_T1273MandAdj));
        StoreElm(RetNo,FNo,539,FormatFloat('#########.##',CF_T1273OptAdj));
       end;
      ClearFields(RetNo,FNo,601,616);
      For j:=10 to 19 do StoreElm(RetNo,FNo,j,'');
      For j:=40 to 62 do StoreElm(RetNo,FNo,j,'');
    END; //t1163

     if FRec.FormName = 'T1175' then {cca}
     begin
      ClearFields(RetNo,FNo,149,167);
     // Ret[RetNo].Frm[FNo].Strings[169]:= FetchElmFNo(RetNo,FNo,172); //cf? causes problems
      j:=2;
      Repeat
       Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7); //ucc
       ClearFields(RetNo,FNo,j+1,j+6);//cca
       ClearFields(RetNo,FNo,j+8,j+8);   //term loss indic
       Inc(j,10);
      until j>72;
      j:=84;
      Repeat
       Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
       ClearFields(RetNo,FNo,j+1,j+6);
       ClearFields(RetNo,FNo,j+8,j+8);
       Inc(j,10);
      until j>114;
     end;

     if FRec.FormName = 'T1175H' then {cca}
     begin
      ClearFields(RetNo,FNo,149,167);
     // Ret[RetNo].Frm[FNo].Strings[169]:= FetchElmFNo(RetNo,FNo,172); //cf couses problems?
      j:=2;
      Repeat
       Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
       ClearFields(RetNo,FNo,j+1,j+6);
       ClearFields(RetNo,FNo,j+8,j+8);
       Inc(j,10);
      until j>72;
      j:=84;
      Repeat
       Ret[RetNo].Frm[FNo].Strings[j]:= FetchElmFNo(RetNo,FNo,j+7);
       ClearFields(RetNo,FNo,j+1,j+6);
       ClearFields(RetNo,FNo,j+8,j+8);
       Inc(j,10);
      until j>114;
     end;
   end; {frm has data}
 end; {i}

 {Gst rebate}
 Fno := GetFormNo('OTHEMPL');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,5,FloatToStr(CF_GSTRebate));

 Fno := GetFormNo('S11');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,13,FloatToStr(CF_Education));
 Calc(RetNo,'S11');

 Fno := GetFormNo('S11PRV');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,13,FloatToStr(CF_EducationPRV));
 Calc(RetNo,'S11PRV');

 {Reserves}
 Fno := GetFormNo('T2017');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,1,FloatToStr(CF_reserveA));
 StoreElm(RetNo,FNo,28,FloatToStr(CF_reserve6684));
 StoreElm(RetNo,FNo,5,FloatToStr(CF_reserveB));
 StoreElm(RetNo,FNo,10,FloatToStr(CF_reserveC));
 StoreElm(RetNo,FNo,14,FloatToStr(CF_reserveD));
 Calc(RetNo,'T2017');

 Fno := GetFormNo('T2017');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,121,FloatToStr(CF_reserve2));

 //cfr
 Fno := GetFormNo('CFR');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 ClearFields(RetNo,FNo,29,30);
 ClearFields(RetNo,FNo,38,39);
 ClearFields(RetNo,FNo,73,77);
 StoreElm(RetNo,FNo,29,FloatToStr(CF_CNILExp));
 StoreElm(RetNo,FNo,30,FloatToStr(CF_CNILInc));
 StoreElm(RetNo,FNo,31,FloatToStr(CF_UnclaimedRRSP));
 StoreElm(RetNo,FNo,51,FloatToStr(CF_HBP));
 StoreElm(RetNo,FNo,52,FloatToStr(CF_LLP));
 StoreElm(RetNo,FNo,38,FloatToStr(CF_Moving));
 StoreElm(RetNo,FNo,39,FloatToStr(CF_AMT));
 StoreElm(RetNo,FNo,98,FloatToStr(CF_OSHPTG));  //20120304
 StoreElm(RetNo,FNo,73,FloatToStr(CF_LPLoss));


 // 20181129 increased by 5 each year
 x:=Cf_TxblGain;
 //20211214
 StoreElm(RetNo,FNo,308,FloatToStr(x));//20201017 //20171216 This was wrong //StoreElm(RetNo,FNo,293,FloatToStr(x)); //20171216
 x:=Cf_CgdFarmQsb;  //total;
 StoreElm(RetNo,FNo,309,FloatToStr(x)); //20201017 //20171216 //StoreElm(RetNo,FNo,294,FloatToStr(x));  //20171216
 x:=Cf_ABIL;StoreElm(RetNo,FNo,312,FloatToStr(x));//20201017  //20171216

 //-------------------------------------
 //cp gean ded
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 {put Yes indicators}
  StoreElm(RetNo,FNo,99,'Y');;  //20211214 StoreElm(RetNo,FNo,304,'Y');
 {non cap losses}
 i:=102;
 Repeat
   StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i+3));
   ClearFields(RetNo,FNo,i+1,i+2);
  Inc(i,5);
 until i>137;

 {push it up}
 i:=102;
 Repeat
  StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i+5));
  Inc(i,5);
 until i>137;
 ClearFields(RetNo,FNo,137,137);
 {Farm losses}
 i:=146;
 Repeat
   StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i+3));
   ClearFields(RetNo,FNo,i+1,i+2);
  Inc(i,5);
 until i>196;
 {push it up}
 i:=146;
 Repeat
   StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i+5));
  Inc(i,5);
 until i>196;
 ClearFields(RetNo,FNo,196,196);
 {Restr losses}
 i:=205;
 Repeat
   StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i+3));
   ClearFields(RetNo,FNo,i+1,i+2);
  Inc(i,5);
 until i>255;
 {push it up}
 i:=205;
 Repeat
  StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i+5));
  Inc(i,5);
 until i>255;
 ClearFields(RetNo,FNo,255,255);
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);

 //net capital losses
 StoreElm(RetNo,FNo,401,'Y');  //automatic
 i:=465;
 Repeat
   StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i+4));
   Inc(i,5);
 until i>600;//595; //590; //20250406 21216 //585; //580; Every year  20170311
 //last row  //!!!!!!!!!  IMPORTANT EVERY YEAR --------------
   StoreElm(RetNo,FNo,605,FetchElmFNo(RetNo,FNo,406));  //20260721  not 600//20240113StoreElm(RetNo,FNo,595,FetchElmFNo(RetNo,FNo,406));//20240113
 //StoreElm(RetNo,FNo,595,FetchElmFNo(RetNo,FNo,406));//20240113
 // StoreElm(RetNo,FNo,595,FetchElmFNo(RetNo,FNo,406));//20240113

 //====================================
 {RRSP undeducted, needed here as well}
 Fno := GetFormNo('RRSP');
 If Ret[RetNo].Frm[Fno].Count =0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,10,FloatToStr(CF_DeductionRoom));
 //Delay(100);
 StoreElm(RetNo,FNo,2,FloatToStr(MaxR(0,CF_EARNED)));
 StoreElm(RetNo,FNo,7,FloatToStr(CF_PensAdj));
 If Cf_HBPYears>0 then StoreElm(RetNo,FNo,83,IntToStr(CF_HBPYears-1));
 If CF_LLPYears>0 then StoreElm(RetNo,FNo,87,IntToStr(CF_LLPYears-1));
 StoreElm(RetNo,FNo,100,FloatToStr(CF_HBPTotWithdrawal));
 StoreElm(RetNo,FNo,99,FloatToStr(CF_LLPTotWithdrawal));
 StoreElm(RetNo,FNo,80,FloatToStr(CF_HBPBalance));
 StoreElm(RetNo,FNo,72,FloatToStr(CF_HBPRepayment));
 StoreElm(RetNo,FNo,84,FloatToStr(CF_LLPBalance));
 StoreElm(RetNo,FNo,75,FloatToStr(CF_LLPRepayment));

 Fno := GetFormNo('YRSUM');
 i:=8;
 Repeat
  StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
  StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
  StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
  StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
 // If i=143 then Showmessage(IntToStr(i)+' ='+FetchElmFNo(RetNo,FNo,i));
  StoreElm(RetNo,FNo,i,''); //current year
  Inc(i,5);
 until i>243; //20120122  238; //213;  //june 15 2008
 i:=308;
 Repeat
  StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
  StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
  StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
  StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
  StoreElm(RetNo,FNo,i,''); //current year
  Inc(i,5);
 until i>523; //20120122 513; //188;  //jun 15 2008

 i:=608;
 Repeat
  StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
  StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
  StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
  StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
  StoreElm(RetNo,FNo,i,''); //current year
  Inc(i,5);
 until i>768; //20120122 //743;


 //20120309
 For j:=1 to 15 do
 Begin
  Fno := GetFormNo('T776SUM'+'#'+AllTrim(IntToStr(j)));
  If FNo>0 then
  Begin
   i:=7;
   Repeat
    StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
    StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
    StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
    StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
    Inc(i,5);
   until i>157; //20120122  238; //213;  //june 15 2008
  end;
 end;

 //20120309                 //part of reformat
 For j:=1 to 15 do
 Begin
  Fno := GetFormNo('T2125SUM'+'#'+AllTrim(IntToStr(j)));
  If FNo>0 then
  Begin
   i:=7;
   Repeat
    StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
    StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
    StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
    StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
    Inc(i,5);
   until i>257;
  end;
 end;

 //20120309
 For j:=1 to 15 do
 Begin
  Fno := GetFormNo('T2121SUM'+'#'+AllTrim(IntToStr(j)));
  If FNo>0 then
  Begin
   i:=7;
   Repeat
    StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
    StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
    StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
    StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
    Inc(i,5);
   until i>187;
  end;
 end;

 //20120309
 For j:=1 to 15 do
 Begin
  Fno := GetFormNo('T2042SUM'+'#'+AllTrim(IntToStr(j)));
  If FNo>0 then
  Begin
   i:=7;
   Repeat
    StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
    StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
    StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
    StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
    Inc(i,5);
   until i>392;
  end;
 end;

 //20120309
 For j:=1 to 15 do
 Begin
  Fno := GetFormNo('T1163SUM'+'#'+AllTrim(IntToStr(j)));
  If FNo>0 then
  Begin
   i:=7;
   Repeat
    StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
    StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
    StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
    StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
    Inc(i,5);
   until i>382;
  end;
 end;

 //20120309
 For j:=1 to 15 do
 Begin
  Fno := GetFormNo('T1273SUM'+'#'+AllTrim(IntToStr(j)));
  If FNo>0 then
  Begin
   i:=7;
   Repeat
    StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
    StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
    StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
    StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
    Inc(i,5);
   until i>382;
  end;
 end;

 (* 20120122
  i:=748;  //invoice amounts //20101212
  StoreElm(RetNo,FNo,i+4,FetchElmFNo(RetNo,FNo,i+3));
  StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+2));
  StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+1));
  StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i));
 *)
  (*
  //20090208   //***  discrepancy from 2008
  i:=754;
  StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,FNo,i));
  StoreElm(RetNo,FNo,i+3,FetchElmFNo(RetNo,FNo,i+3));
  StoreElm(RetNo,FNo,i+2,FetchElmFNo(RetNo,FNo,i+2));
  StoreElm(RetNo,FNo,i+1,FetchElmFNo(RetNo,FNo,i+1));
  *)
 // StoreElm(RetNo,FNo,749,FormatFloat('######.##',Cf_Invoice)); //prev year
 //yrsum
except
 ShowMessage('Imported data may be incomplete');
end;

end;

//20121118
(*
//20111124
Function FedLoggingTaxCredit(RetNo:integer;LogTax,LogIncome:Real):Real;
Var x,y:Real; Adj260:Real;BfT:Real;
begin
 With Ret[RetNo] do
 begin
  Bft:=Lnn[429];
  Adj260:=MaxR(0,Lnn[26000]+Lnn[20800]+Lnn[21400]+Lnn[21500]+Lnn[21900]+Lnn[22000]);
  Result:=MinR(Adj260,LogIncome) * 6.6667/100;
  Result:=MinR(Bft,result);
 end;
end;
*)
//put back 20111218
 //20111124
Function FedLoggingTaxCredit(RetNo:integer;LogTax,LogIncome:Real):Real;
Var x,y:Real; Adj260:Real;
begin
// Result:=0; Exit;
 With Ret[RetNo] do
 begin
  Adj260:=MaxR(0,Lnn[26000]-Lnn[20800]-Lnn[21400]-Lnn[21500]-Lnn[21900]-Lnn[22000]);
 end;
 Result :=  MinR(LogTax * 66.6667/100, LogIncome * 6.6667/100);  //20090128
 Result := Minr(Result,Adj260 * (6.6667/100));
end;


Function BCLoggingTaxCredit(RetNo:integer;LogTax,LogIncome:Real):Real;
begin
 result:=MinR(LogTax * 33.33/100, FedLoggingTaxCredit(RetNo,LogTax,LogIncome) /2);
end;

(*  //20110204
Procedure CalcCCAFromAssetsB;
Var AdjUcc:real;OvrRate:Boolean;
begin
 With AssetsBRec do
 begin
     If BusPercent>100 then BusPercent:=100;
     AdjUcc      := UccStart + Additions - Proceeds;
     Adjustments := MaxR(0, 0.5 * (Additions - Proceeds));
     If UpperCase(Rule50Exempt)='X' then Adjustments:=0;
     BaseForCCA  := AdjUcc - Adjustments;

      If UpperCase(OvrCCA) = 'X' then
        CCA   := MaxCCA * (BusPercent/100)
      else
      begin
       If BaseForCCA <0 then
       begin
        CCA := BaseForCCA;
        MaxCCA:=CCA;  //Feb 23 2008
       end
       else
       begin
         MaxCCA:=  BaseForCCA * (Vl(Rate) / 100);
         CCA   := MaxCCA * (BusPercent/100);
       end;
      end ;

     If UpperCase(Cls) = '10A' then CCA := BaseForCca * (30/100)+Additions * (85/100);
     If UpperCase(Cls) = '12A' then CCA := BaseForCca * (100/100)+Additions * (50/100);
     If ClaimIt=False then CCA :=0;
     If OvrUcc <> 'OVRUCC' then UccEnd   := MaxR(0,AdjUcc - CCA);
     //If cls='10.1' then OvrUcc :=''; //not allowed
     If UpperCase(OvrUCC) = 'X' then {terminal loss}
     begin
      If UccEnd >0 then begin CCA := AdjUcc;UccEnd :=0;end;
     end;
 end;
end;
*)
Procedure CalcCCAFromAutos(Cls:string;UccStart:real;
                 Additions:real;Proceeds:real;
                 Var Adjustments:real;Var BaseForCCA:real;
                 Rate:string;Var CCA:real;Var UccEnd:real;
                 OvrCCA:string;OvrUCC:string;ClaimIt:Boolean;
                 Rule50Exempt:String;BusPercent:Real;Var MaxCCA:Real);
Var AdjUcc:real;OvrRate:Boolean;
begin
     If BusPercent>100 then BusPercent:=100;
     AdjUcc      := UccStart + Additions - Proceeds;
     Adjustments := MaxR(0, 0.5 * (Additions - Proceeds));
     If UpperCase(Rule50Exempt)='X' then Adjustments:=0;
     BaseForCCA  := AdjUcc - Adjustments;

     If AllTrim(Rate) <> GetCCARate(Cls) then
     begin
       If BaseForCCA <0 then CCA := BaseForCCA
       else
       begin
        MaxCCA:=  BaseForCCA * (Vl(Rate) / 100);
        CCA   := (BaseForCCA * (Vl(Rate) / 100));
       end
     end
     else
     begin
      If UpperCase(OvrCCA) <> 'X' then
      begin
       If BaseForCCA <0 then CCA := BaseForCCA
       else
       begin
         MaxCCA:=  BaseForCCA * (Vl(Rate) / 100);
         CCA   := (BaseForCCA * (Vl(Rate) / 100));
       end;
      end;
     end;
     If UpperCase(Cls) = '10A' then CCA := BaseForCca * (30/100)+Additions * (85/100);
     If UpperCase(Cls) = '12A' then CCA := BaseForCca * (100/100)+Additions * (50/100);
     If ClaimIt=False then CCA :=0;
     If OvrUcc <> 'OVRUCC' then UccEnd   := MaxR(0,AdjUcc - CCA);
     If cls='10.1' then OvrUcc :=''; //not allowed
     {terminal loss}
     If UpperCase(OvrUCC) = 'X' then
     begin
      If UccEnd >0 then begin CCA := AdjUcc;UccEnd :=0;end;
     end;
end;



Procedure CalcCCA(Cls:string;UccStart:real;
                 Additions:real;Proceeds:real;
                 Var Adjustments:real;Var BaseForCCA:real;
                 Rate:string;Var CCA:real;Var UccEnd:real;
                 OvrCCA:string;OvrUCC:string;ClaimIt:Boolean;
                 Rule50Exempt:String;BusPercent:Real;Var MaxCCA:Real);
Var AdjUcc:real;OvrRate:Boolean;
begin
     If BusPercent>100 then BusPercent:=100;
     AdjUcc      := UccStart + Additions - Proceeds;
     Adjustments := MaxR(0, 0.5 * (Additions - Proceeds));
     If UpperCase(Rule50Exempt)='X' then Adjustments:=0;
     BaseForCCA  := AdjUcc - Adjustments;
    
     If AllTrim(Rate) <> GetCCARate(Cls) then
     begin
       If BaseForCCA <0 then CCA := BaseForCCA
       else
       begin
        MaxCCA:=  BaseForCCA * (Vl(Rate) / 100);
        CCA   := (BaseForCCA * (Vl(Rate) / 100) * (BusPercent)/100);
       end
     end
     else
     begin
      If UpperCase(OvrCCA) <> 'X' then
      begin
       If BaseForCCA <0 then CCA := BaseForCCA
       else
       begin
         MaxCCA:=  BaseForCCA * (Vl(Rate) / 100);
         CCA   := (BaseForCCA * (Vl(Rate) / 100) * (BusPercent/100));
       end;
      end;
     end;
     If UpperCase(Cls) = '10A' then CCA := BaseForCca * (30/100)+Additions * (85/100);
     If UpperCase(Cls) = '12A' then CCA := BaseForCca * (100/100)+Additions * (50/100);
     If ClaimIt=False then CCA :=0;
     If OvrUcc <> 'OVRUCC' then UccEnd   := MaxR(0,AdjUcc - CCA);
     If cls='10.1' then OvrUcc :=''; //not allowed
     {terminal loss}
     If UpperCase(OvrUCC) = 'X' then
     begin
      If UccEnd >0 then begin CCA := AdjUcc;UccEnd :=0;end;
     end;
end;

Function ValidateSend(DataDir,FlName:string):boolean;
//var Tbl:TTable; i:integer;
begin
  result := True;

  EXIT;  //doen not have to be discounted
 (*
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := DataDir;
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'FILE_NAME';
  If Tbl.Active then Tbl.Close;
  Tbl.Open;

  if Tbl.FindKey([FlName]) then
     begin
      If Tbl.FieldByName('Discounted').AsString = 'N'
       then begin result := false;exit;end;
     end;
  Tbl.Free;
 *)
end;

Function MakeReceivedFileName(FlName,LicenseLevel,FileType:string):string;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec : string[2];
begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SMin  := LTrim(RTrim(IntToStr(Min)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SMin)  =1 then SMin  := '0'+SMin;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  If LeftStr(LicenseLevel,8) = 'T1 Multi' then
   Result :=LeftStr(GetOriginalTransmUser(FlName,FileType),4)
            +SDD+SSec
  Else
   Result := SMM + SDD+SMin+SSec;
end;

Procedure UpdateRTUDate(FullRtuNo:String;DataDir:string); //20170329 Igor
var {FNo :integer;}
  RtuRecs{,TempList} :TStringList;
  FlName : string;
  //Table1 : TTable;
  ADConnection: TADConnection;
  I :integer;
  WorkRetNo: Integer;
  RetOwner: Boolean;
  WorkSin: string;
begin
  If Not FileExists(FullRtuNo) then
  begin
    ShowMessage('Rtu '+FullRtuNo+' does not exist'+Chr(13)+
                'RTU transmission data will not be updated on the Clients data base');
    exit;
  end;
  RTURecs := TstringList.Create;
  RTURecs.LoadFromFile(FullRTUNo);
  For i := 0 to RtuRecs.Count-1 do
  begin
    If MidStr(RtuRecs[i],5,2) = '02' then {T1 record}
    begin
      FlName := MidStr(RtuRecs[i], 35, 8)+'.'+MidStr(RtuRecs[i], 43,1);
      WorkSin := MidStr(RtuRecs[i], 35, 9);
      If FileExists(DataDir+'\'+FlName) then
      begin
        {update the tax return with RTU dates}
        WorkRetNo := GetRetNoFromSin(WorkSin);
        if WorkRetNo = 0 then
        begin
          RetOwner := True;
          WorkRetNo := ReadReturn(DataDir, FlName);
        end
        else
          RetOwner := False;

        if WorkRetNo > 0 then
        begin
          try
            StoreElm(WorkRetNo, 'STATUS', 16, ExtractFileName(FullRtuNo));
            StoreElm(WorkRetNo, 'STATUS', 18, User.UserName);
            StoreElm(WorkRetNo, 'STATUS', 19, FormatDateTime('yyyy-mm-dd',Now));
            StoreElm(WorkRetNo, 'STATUS', 20, TimeToStr(Time));
            Ret[WorkRetNo].Changed := True;
            if RetOwner then
              SaveReturn(WorkRetNo, DataDir, FlName, False, False);
          finally
            if RetOwner then
              CloseReturn(WorkRetNo, True);
          end;
        end;

        {now update the data base with RTU dates}
        ADConnection := TADConnection.Create(nil);
        try
          SetConnection(ADConnection, DataDir + '\' + ClientsDbLite, ClientsTableLite, False, False);
          ADConnection.ExecSQL('UPDATE ' + ClientsTableLite + ' SET RTUSent_by = ''' + User.UserName + '' + //20170112 Igor
               ', RTUSent_dt = ''' + FormatDateTime('yyyy-mm-dd',Now) + '' +
               ', RTUSent_tm = ''' + TimeToStr(Time) + '' +
               ', RTUFile = ''' + ExtractFileName(FullRtuNo) + '' +
               ', EF_Status = ''04''' +
               ' WHERE lower(File_Name) = lower(''' + FlName + ''')'); //20170223 Igor
        finally
          ADConnection.Free;
        end;
      end
      else
        ShowMessage('File '+FlName+' not found in '+DataDir);
    end;
  end; {do}
  RtuRecs.Free;
end;

(*
Procedure UpdateRTUDate(FullRtuNo:String;DataDir:string);
var FNo :integer; RtuRecs,TempList :TStringList;
FlName : string;
//Table1 : TTable;
  ADConnection: TADConnection;
  I :integer;
begin
  If Not FileExists(FullRtuNo) then
   begin ShowMessage('Rtu '+FullRtuNo+' does not exist'+
   Chr(13)+ 'RTU transmission data will not be updated on the Clients data base');
   exit;
   end;
  RTURecs := TstringList.Create;
  RTURecs.LoadFromFile(FullRTUNo);
  For i := 0 to RtuRecs.Count-1 do
  begin
    If MidStr(RtuRecs[i],5,2) = '02' then {T1 record}
    begin
        FlName := MidStr(RtuRecs[i], 35,8)+'.'+MidStr(RtuRecs[i], 43,1);
        If FileExists(DataDir+'\'+FlName) then
        begin
         {update the tax return with RTU dates}
         TempList := TstringList.Create;
         Templist.LoadFromFile(DataDir+'\'+FlName);
         Templist.Add( 'F'+Delimiter+'STATUS'+Delimiter+Delimiter);
         TempList.Add('D'+Delimiter+'16'+Delimiter+ExtractFileName(FullRtuNo)+Delimiter);
         TempList.Add('D'+Delimiter+'18'+Delimiter+User.UserName+Delimiter); //20170112 Igor
         TempList.Add('D'+Delimiter+'19'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
         TempList.Add('D'+Delimiter+'20'+Delimiter+TimeToStr(Time)+Delimiter);
         Templist.SaveToFile(DataDir+'\'+FlName);
         TempList.Free;
         {now update the data base with RTU dates}
                  // 20150826 igor
         with TADConnection.Create(nil) do
         try
            DriverName := 'SQLite';
            Params.Values['DataBase'] := DataDir + '\' + ClientsDbLite;
            ExecSQL('UPDATE ' + ClientsTableLite + ' SET RTUSent_by = ''' + User.UserName + '' + //20170112 Igor
               ', RTUSent_dt = ''' + FormatDateTime('yyyy-mm-dd',Now) + '' +
               ', RTUSent_tm = ''' + TimeToStr(Time) + '' +
               ', RTUFile = ''' + ExtractFileName(FullRtuNo) + '' +
               ', EF_Status = ''04''' +
               ' WHERE lower(File_Name) = lower(''' + FlName + ''')'); //20170223 Igor
          finally
            Free;
          end;
//
//         Table1              := TTable.Create(Application);
//         Table1.DataBaseName := DataDir;
//         Table1.TableName    := ClientsTable;
//         Table1.IndexName    := 'File_Name';
//         if Table1.State = dsInactive then Table1.Active := True;
//         if Table1.FindKey([FlName]) then
//         begin
//           Table1.Edit;
//           Table1.FieldByName('RTUSent_by').AsString := UserName;
//           Table1.FieldByName('RTUSent_dt').AsString := FormatDateTime('yyyy-mm-dd',Now);
//             {DateToStr(Date);}
//           Table1.FieldByName('RTUSent_tm').AsString := TimeToStr(Time);
//           Table1.FieldByName('RTUFile').AsString :=
//                           ExtractFileName(FullRtuNo);
//           Table1.FieldByName('EF_Status').AsString :='04';
//           Table1.Post;
//           Table1.Free;
//         end;
        end
        else
         ShowMessage('File '+FlName+' not found in '+DataDir);
    end;
  end; {do}
 RtuRecs.Free;
end;
*)

Procedure UpdateACKDate(FullAckFileName:String;DataDir:string);
Var //Table1 : TTable;
  FDConnection: TADConnection;
  Table1 : TADTable;

  FlName, ErrorCd : string;
 OldFileName, NewFileName :string;
AckRecs,TempList: TStringList;
I,j,k,MatchedCnt,UnmatchedCnt,ElmInStatus :integer;
begin
  MatchedCnt:=0;UnMatchedCnt:=0;
  If Not FileExists(FullAckFileName) then
  begin
   ShowMessage('ACK: '+FullAckFileName+' does not exist');
   exit;
  end;
  AckRecs := TstringList.Create;
  AckRecs.LoadFromFile(FullAckFileName);
  If MidStr(AckRecs[0], 53,8) = 'NEWSNEWS' then
  begin
   if MessageDlg('This Ack is the News broadcast you just saw. Print it?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
      PrintSomeFile(FullAckFileName);
   AckRecs.Free;
   exit;
  end;

//  Table1 := TTable.Create(Application);
//  Table1.DataBaseName := OptRec.Dir_Cur;
//  Table1.TableName := 'CLIENTS.DBF';
//  Table1.IndexName := 'FILE_NAME';
//  Table1.Close;
//  if Table1.State = dsInactive then Table1.Open;
  FDConnection := TADConnection.Create(nil);
  Table1 := TADTable.Create(nil);
  if SetTableName(FDConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDbLite, ClientsTableLite, 'FILE_NAME') then
  begin

    Screen.Cursor := crHourGlass;
    {do for all records in ack file}
    TempList := TstringList.Create;
    FlName :='';
    For i := 0 to AckRecs.Count-1 do
    begin
       {Accepted records}
       if (MidStr(AckRecs[i],5,2) = '05') then
       begin
          FlName := MidStr(AckRecs[i], 12,8)+
                '.'+IntToStr(ChkDigit(MidStr(AckRecs[i], 12,8)));
          If FileExists(OptRec.EF_DataDir+'\'+FlName+'EF') then
           Sysutils.DeleteFile(OptRec.EF_DataDir+'\'+FlName+'EF');
          //20170223 Igor >>> 
          //if Table1.FindKey([FlName]) then
          if Table1.Locate('LILE_NAME', FlName, [loCaseInsensitive]) then
          //20170223 Igor <<<
           begin
             Table1.edit;
             Table1.FieldByName('EF_Status').AsString := '02'; {accepted}
             Table1.Post;
             Inc(MatchedCnt);
           end
           else
             begin
             Inc(UnMatchedCnt);
             ShowMessage('File name (SIN): '+FlName+ ' in Acknowledgement file '+
                 Chr(13)+ ' was not found on your'+
                Chr(13)+ 'Client Data Base in directory '+DataDir);
             end;
       end

       {non accepted records}
       else if (MidStr(AckRecs[i],5,2) = '06') then
       begin
         FlName := MidStr(AckRecs[i], 12,8)+
                '.'+IntToStr(ChkDigit(MidStr(AckRecs[i], 12,8)));
         //20170223 Igor >>>       
         //if Table1.FindKey([FlName]) then
         if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
         //20170223 Igor <<<
         begin
           {update the CLIENTS.DBF file}
           Table1.Edit;
           Table1.FieldByName('ACKRcvd_by').AsString := User.UserName; //20170112 Igor
           Table1.FieldByName('ACKRcvd_dt').AsString := FormatDateTime('yyyy-mm-dd',Now);
            {DateToStr(Date);}
           Table1.FieldByName('ACKRcvd_tm').AsString := TimeToStr(Time);
           Table1.FieldByName('ACKFile').AsString :=
                        ExtractFileName(FullAckFileName);
           Table1.FieldByName('EF_Status').AsString := '03'; {rejected}
           Table1.Post;
           Inc(MatchedCnt);

           j:=1;k:=89; {position of error in ack}
           Repeat
            Errorcd := RmvLeadingZeros(MidStr(AckRecs[i],k,6));
            If Vl(ErrorCd) >0 then TempList.Add(ErrorCd);
            Inc(k,6);Inc(j);
           until j>7; {pick up 7 errors}
           {save error codes}
           If FileExists(OptRec.EF_DataDir+'\'+FlName+'EF') then
             SysUtils.DeleteFile(OptRec.EF_DataDir+'\'+FlName+'EF');
           If TempList.Count >0 then
              Templist.SaveToFile(OptRec.EF_DataDir+'\'+FlName+'EF');
           TempList.Clear; {Free;}
         end  {end matching}
         else  {06 not found}
           begin
            Inc(UnMatchedCnt);
            ShowMessage('File name (SIN): '+FlName+ ' in Acknowledgement file '+
                 Chr(13)+ ' was not found on your'+
                Chr(13)+ 'Client Data Base in directory '+DataDir);
           end;
        end; {end 06}
        (*
        else
        begin
           Inc(UnMatchedCnt);
           ShowMessage('File name (SIN): '+FlName+ ' in Acknowledgement file '+
                 Chr(13)+ ' was not found on your'+
                Chr(13)+ 'Client Data Base in directory '+DataDir);
        end;
        *)
   end; {do for allrecords}
 TempList.Free;
 Screen.Cursor := crDefault;
 ShowMessage('Update process is completed'+
             Chr(13)+'Files Updated   :'+IntToStr(MatchedCnt)+
             Chr(13)+'Files not found  :'+IntToStr(UnMatchedCnt));
  end;
 Table1.Free;
 FDConnection.Free;
 AckRecs.Free;

 {rename Ack}
  OldFileName :=FullAckFileName;
  NewFileName :=ExtractFileName(ChangeFileExt(OldFileName,'.ACX'));
  If RenameFile(OldFileName,NewFileName) then
    begin
    ShowMessage('Ack file renamed to ACX');
    FullAckFileName :=NewFileName;
    end;

end;


//Function GetAdminPassword(UserName: string):String;
//Var
//Table1 : TTable;
//begin
//  Result := '';
//  Table1 := TTable.Create(Application);
//  Table1.DataBaseName := AppDir;
//  Table1.TableName := 'Users.dbf';
//  Table1.IndexName := 'Name';
//  Table1.Open;
//  if Table1.FindKey([UserName]) = true then
//    result := Table1.FieldByName('Pswd').AsString;
//  Table1.Free;
//end;

Procedure T4E(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   If strings[4] = '' then Strings[4] := AppYear;
   If ShowUnconvertedLastYear(RetNo) then Strings[4]:=GetLastYearTaxYear;
   If Strings[6] = '' then Strings[6] := 'Y';
   Strings[5] := FetchElm(RetNo,'INFO',3);
   Strings[1] := FetchElm(RetNo,'INFO',5)+', '
                 + FetchElm(RetNo,'INFO',2);
   If Strings[7] ='' then Strings[7]:='30';
   If (Vl(Strings[7]) = 30) and (Tv[8]+Tv[9]=0) then Tv[8] := Tv[2];
   if Tv[20]>Tv[2] then Tv[20]:=Tv[2];  //20200103
   Tv[23]:=MaxR(0,Tv[10]-Tv[22]);  //20230303
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure T4AOAS(RetNo: integer; FName: String;FNo: integer);
var MaxOas,maxoas75:Real;
begin
               //jz//20260122 - update MAX OAS values
  MaxOas    := 9670.29; //75 or over //9479.82 //8618.04; //8354.52; //20250313
  MaxOas75  := 8791.14; // under 75 //8618.04 //202503138354.52; //8335.44; //7929.75;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin

   //jz//20260122 - add as edits on the form rather than text
   Tv[12]:= MaxOas75;
   Tv[13]:= MaxOas;

   If strings[5] = '' then Strings[5] := AppYear;
   If ShowUnconvertedLastYear(RetNo) then Strings[5]:=GetLastYearTaxYear;
   if Tv[4]<0 then Tv[4]:=0;  //20180315

   Strings[6] := FetchElm(RetNo,'INFO',3);
   Strings[9] := FetchElm(RetNo,'INFO',5)+', '
                 + FetchElm(RetNo,'INFO',2);
   If UpperCase(Strings[11])='Y' then
   begin
    If Ret[RetNo].age <75 then  //20250313
      Tv[2]:= Tv[12]  //MaxOas75 //under 75
    Else
      Tv[2]:= Tv[13]  //MaxOas;  //75 or over
   end;
   If Tv[10]=0 then Tv[10]:=Tv[2];  //20170302    //20170312
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure T4A(RetNo: integer; FName: String;FNo: integer);
Var I:integer;FtCode:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //20110118
   Strings[82] := GetLastName(RetNo); //FetchElm(RetNo,'INFO',3);
   Strings[83] := GetFirstName(RetNo); //FetchElm(RetNo,'INFO',5);
   Strings[84] := GetSinNo(RetNo);  //FetchElm(RetNo,'INFO',2);

   //20110130
   If (Tv[3]>0) then
   begin
    If Strings[12]='' then Strings[12]:='1';
   end
   Else
    Strings[12]:='';

   If (Tv[62]>0) then
   begin
     If (Strings[11]='') then Strings[11]:='1';
   end
   else
     Strings[11]:='';

   if strings[12]='0' then Strings[12]:='1';
   if strings[11]='0' then Strings[11]:='1';
   If Vl(Strings[12])>9 then Strings[12]:='1';
   If Vl(Strings[11])>9 then Strings[12]:='1';

   //20120220
   If UpperCase(Strings[54])='Y' then Strings[13]:='N';
   If UpperCase(Strings[13])='Y' then Strings[54]:='N';

   If UpperCase(Strings[54])='Y' then
     Tv[46]:=Tv[31]
   else
   begin
     Tv[46]:=Vl(FetchElm(RetNo,'PTIMEWS',7));  //20120220
   end;

   If Tv[24]>Tv[43] then Tv[24]:=Tv[43];  //20151207

   //20120220
   If  (UpperCase(Strings[54])='N')
   and (UpperCase(Strings[13])='N') then Tv[46]:=0;

   Tv[35]:=MaxR(0,Tv[32]-Tv[29]);
   Tv[47] := MaxR(0,Tv[31]-Tv[46]);
   Tv[51]:=MinR(10000,Tv[34]);
   Tv[52]:=MaxR(0,Tv[34]-Tv[51]);

   if Tv[88]>0 then Ret[RetNo].FrmHasData[FNo]:=True; //20181125

  end;
  SaveTv(RetNo,FName,FNo);
end;

Function DependantsEntered(RNo:Integer):Boolean;
Var i,FNo:Integer;
begin
 result :=false;
 FNo:=GetFormNo('DEPEND');
 i:= 5;
 repeat
  If FetchElmFNo(RNo,FNo,i)>'' then begin result :=true;exit;end;
  Inc(i,15);
 until i> 125;
end;

Function ChildBornThisYear(RNo:Integer):Boolean;
Var i,FNo:Integer;
begin
 result :=false;
 FNo:=GetFormNo('DEPEND');
 i:= 5;
 repeat
  If (FetchElmFNo(RNo,FNo,i)>'')
  and (LeftStr(FetchElmFNo(RNo,FNo,i+5),4) = AppYear)
   then begin result :=true;exit;end;
  Inc(i,15);
 until i> 125;
end;



(*
Procedure CalcAllForms(RetNo:Integer);  //20130601
Var i:integer; s:AnsiString;
begin
  s:='';
  i := 0;
  Repeat
    Try    //20130601
     FRec := FList.Items[i];
     If (Ret[RetNo].FrmHasData[Frec.FormNo]) then  //20101220
          Calc(RetNo,Frec.FormName+Frec.FormInst);
     Except
        ShowMessage('Error calculating form '+Frec.FormName+Frec.FormInst);
     end;
     Inc(i,1);
  until i>Flist.Count-1;

end;
*)

Procedure CalcAllForms(RetNo:Integer);
Var i:integer; s:AnsiString;
begin
 s:='';
 //ShowTheFList;
 Try    //20101116
  i := 0;
  Repeat
    FRec := FList.Items[i];
    if Frec.FormNo>0 then   //20240605
    begin
     If (Ret[RetNo].FrmHasData[Frec.FormNo]) then  //20101220
      if Frec.FormName>'' then    //20221211
         Calc(RetNo,Frec.FormName+Frec.FormInst);
    end;
  Inc(i,1);
  until i>Flist.Count-1;
 Except
    ShowMessage('Error calculating form '+Frec.FormName+Frec.FormInst);
 end;
end;

procedure RecalcEverything(RetNo:Integer);
begin
 If ShowUnconvertedLastYear(RetNo) then Exit;

 INFO(RetNo,'INFO',GetFormno('INFO'));
 T1(RetNo,'T1',GetFormno('T1'));
 Try SumSlips(RetNo,'ALL'); Except ShowTimedMsg('Recalc error-Slips',2000);end;
 Try CalcAllForms(RetNo);Except ShowTimedMsg('Recalc error-Calc All forms',2000);;end;
 Try CalcAll(RetNo);Except ShowTimedMsg('Recalc error-Calc All',2000);end;
end;

(*  //20260513
procedure RecalcEverything(RetNo:Integer);
begin
 If ShowUnconvertedLastYear(RetNo) then Exit;
 Try
  INFO(RetNo,'INFO',GetFormno('INFO'));
  T1(RetNo,'T1',GetFormno('T1'));
  SumSlips(RetNo,'ALL');
  CalcAllForms(RetNo);   //20170225      //20221211
  CalcAll(RetNo);      //20170225
 Except
  ShowTimedMsg('Recalc error',800);
 end;
end;
*)
(*   //20161119
Function GetOverseasCredit(RetNo:Integer):real;
begin
 Result := TotMultiple(RetNo,'T626',128);
end;
*)

//Function YouKnowTheAdminPassword:Boolean;
//Var InputString:String[20];
//begin
// Result := False;
// If UpperCase(User.Login_Id)='ADMIN' then begin Result:=True;exit;end; //20121214
// Application.CreateForm(TAdminPassWord,AdminPassWord);
// AdminPassWord.ShowModal;
// InputString:= AdminPassword.Edit1.Text;
// If UpperCase(InputString) = UpperCase(GetAdminPassword('ADMIN')) then-
// If UpperCase(InputString) = 'RONCON' then
//  result := True;
//
// AdminPassword.Free;
//end;

Function MakeInvoiceNo(RetNo:Integer):String;
begin
 result := GetSinNo(RetNo)+'-'+AppYear;
 If OptRec.SerializeInvoice=True then
    result:=OptRec.InvPrefix+GetNextInvNo+OptRec.InvSuffix;

 //If LeftStr(LicenseLevel,8) ='T1 Multi' then
 If LicenseLevel in anyMulti then
  Result := AllTrim(IntToStr(GetNextInvoiceNo(User.UserName)))+'-' //20170112 Igor
    +GetSinNo(RetNo)+'-'+AppYear;
end;

Function GetNextInvNo:String; //standard: for prefix-seq-Suffix
Var tempList:TStringList; NextNo:Integer;
begin
 TempList:=TStringList.Create;
 If FileExists(AppDir+'\'+'NextInvNo.d') then
 begin
  TempList.LoadFromFile(AppDir+'\'+'NextInvNo.d');
  Result:=TempList[0];
  //now update for next
  NextNo:=MyStrToInt(TempList[0])+1;
  TempList[0]:=AllTrim(IntToStr(NextNo));
  TempList.SaveToFile(AppDir+'\'+'NextInvNo.d');
  TempList.Free;
 end;
end;

Function GetNextInvoiceNo(UserName:String):Integer; //for multioffice
var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  Result := 0;

  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, AppDir + '\' + UserDBLite, UserTableLite, 'Name');
  //20170223 Igor >>>
  //if Table1.FindKey([UserName]) = true then
  If Table1.Locate('LOGIN_ID', UserName, [loCaseInsensitive]) then //20170224 Igor
  //20170223 Igor <<<
    begin
    result := Table1.FieldByName('Inv_No').AsInteger+1;
    Table1.edit;
    Table1.FieldByName('Inv_No').AsInteger:=Result;
    Table1.Post;
    end;

  Table1.Free;
  ADConnection.Free;
//Var
//Table1 : TTable;
//begin
//  Result := 0;
//  Table1 := TTable.Create(Application);
//  Table1.DataBaseName := AppDir;
//  Table1.TableName := 'Users.dbf';
//  Table1.IndexName := 'Name';
//  Table1.Open;
//  if Table1.FindKey([UserName]) = true then
//    begin
//    result := Table1.FieldByName('Inv_No').AsInteger+1;
//    Table1.edit;
//    Table1.FieldByName('Inv_No').AsInteger:=Result;
//    Table1.Post;
//    end;
//  Table1.Free;
end;

Function AllowedToFullPrint(RetNo:Integer):Boolean;
begin
 result := True;
 //20170219
 If LicenseLevel in anyMulti then
 begin
   //If (Ret[RetNo].Changed) and (Ret[RetNo].Saved = False) then
   If (Ret[RetNo].Changed) then
   begin
    ShowMessage('Please Save the return first or enter the ADMIN password');
    if YouknowTheAdminPassword then begin result:=True;exit;end;
    Result := False;
   end;
 end;
end;

Function AllowedToFormPrint(RetNo:Integer;FormName:String):Boolean;
begin
 result := True;
 //20190219
 If (LicenseLevel in anyMulti) then
 Begin
  If (Ret[RetNo].Changed) then
   begin
    ShowMessage('Please Save the return first or enter the ADMIN password');
    if YouknowTheAdminPassword then begin result:=True;exit;end;
    Result := False;
   end;
  end;
end;


//Function AllowedToChangeSaveDir(SaveDir:String):Boolean;
//Var InputString:String[20];
//begin
// Result := True;
// If (LeftStr(LicenseLevel,8) = 'T1 Multi') then
// begin
//  If (UpperCase(LeftStr(SaveDir,2))= 'A:')
//  or (UpperCase(LeftStr(SaveDir,2))= 'B:') then
//  begin
//   Result := False;
//   Application.CreateForm(TAdminPassWord,AdminPassWord);
//   AdminPassWord.ShowModal;
//   InputString:= AdminPassword.Edit1.Text;
//   If UpperCase(InputString) = UpperCase(GetAdminPassword('ADMIN')) then
//    result := True;
//   AdminPassword.Free;
//  end
//  else
//   result := True;
// end;
//end;

Function GetFirstNationName(RetNo:Integer):String;
Var i:Integer;
begin
 result :='';
 i:=13;
 Repeat
  If UpperCase(FetchElm(RetNo,'YT432',i)) = 'X' then
    begin result:=FetchElm(RetNo,'YT432',i+1);exit;end;
  Inc(i,3);
 until i>43;
end;

Function GetFirstNationNumber(RetNo:Integer):String;
Var i:Integer;
begin
 result :='';
 i:=13;
 Repeat
  If UpperCase(FetchElm(RetNo,'YT432',i)) = 'X' then
    begin result:=FetchElm(RetNo,'YT432',i+2);exit;end;
  Inc(i,3);
 until i>46;
end;


Function ItIsFirstNation(RetNo:Integer):Boolean;
Var i:Integer;
begin
 Result := False;
 i:=13;
 Repeat
  If FetchElm(RetNo,'YT432',I)>'' then
  begin
   result := True;
   Exit;
  end;
  Inc(i,3);
 until i>43;
end;

Function CalcNUCola(AdjInc:Real):Real;
begin
 Result :=0;
 If AdjInc <=12000 then begin Result :=AdjInc * 2.00/100;exit;end;

 If AdjInc >12000 then
 begin
  Result :=(AdjInc-12000)* 1.5/100 + 240;
  If result>750 then result := 750;
 end;

 (*
 If (AdjInc >12000) and (AdjInc <=48000) then
  begin
   Result :=150+(AdjInc-12000)* 1/100;
   exit;
  end;
 If (AdjInc >48000) and (AdjInc <=66000) then
  begin
   Result :=510+(AdjInc-48000)* 0.75/100;
   exit;
  end;
 If AdjInc >66000 then begin Result :=645;exit;end;
 *)
end;

Function CalcNUPolit(Contr:Real):Real;
Var x:Real;
begin
 Result :=0;
 If Contr <=100 then begin result :=Contr;exit;end;
 If Contr >100 then result:= (Contr-100) * 0.50 +100;
 If Result>500 then result :=500;
end;

//20211128
Function CalcONPolit(Contr:Real):Real;  //??2019 needs revision   //20201231
Var Col1,Col2,Col3:Real;
begin
 Result :=0;
 //20231127
 If Contr <=465 then begin result :=Contr * 0.75;exit;end;
 If (Contr >465) and (Contr<=1552) then result:= (Contr-465) * 0.50 + 349
 else If (Contr >1552) then result:= (Contr-1552) * 0.3333 + 892.40;  //304+
 If Result>1552 then result :=1552;
end;


Function IsReturnDiscounted(RetNo:Integer):Boolean;
begin
 Result := False;
 If FetchElm(RetNo,'INFO',102) > '' then result := True;
end;

Function IsReturnEfiled(RetNo:Integer):Boolean;
begin
 Result := False;
 If UpperCase(FetchElm(RetNo,'INFO',46)) = 'X' then result := True;
end;


Function GetNonPageFrm(Frm:String):String;
Var i:Integer;
begin
 Result :='';
 For i:=1 to Length(Frm) do
  If Frm[i] = '_' then
   break
  else
   result := result+Frm[i];
end;

(*
Procedure ResequenceFormsToPrint(Var FormsToPrint:TStringList);
Var i,j,k,PrevSeq:Integer;
    templist,templist2:TStringList;
    Frm,FrmNonPage,PrevFrmNonPage,Inst:String[10];s:String[20];
    AppendSw :Boolean;
begin
 {comes as sssnfffffff#nn wih # not in fixed position}
 TempList:=TStringList.Create;
 TempList2:=TStringList.Create;
 PrevFrmNonPage:='';
 PrevSeq:=0;
 AppendSw := False;

 For i:=0 to FormsToPrint.Count-1 do
 begin
  s:=FormsToPrint[i];
  Frm:=ExtractNonInstFormName(MidStr(s,5,20));
  Inst:=PaddR(ExtractFormInst(MidStr(s,5,20)),3);

  If Numeric(MidStr(S,2,1)) then
  begin
   If (LeftStr(Inst,1)='#') then  {mult statm}
   begin
    If GetNonPageFrm(Frm) = PrevFrmNonPage then
    Begin AppendSw:=True; TempList2.Add(s); end
    else  {changed form within mult statements}
    begin
      If AppendSw then
      begin
       ResequenceStatements(TempList2);
       For k:=0 to Templist2.Count-1 do TempList.Add(TempList2[k]);
       Templist2.Clear;
       AppendSw:=False;
      end
      else
      Begin AppendSw:=True; TempList2.Add(s); end
    end
   end  {end mult #}

   else {hit no mult statement}
   begin
     If AppendSw then
     begin
      ResequenceStatements(TempList2);
      For k:=0 to Templist2.Count-1 do TempList.Add(TempList2[k]);
      Templist2.Clear;
      AppendSw:=False;
     end;
   end;
   PrevFrmNonPage:=ExtractNonInstFormName(MidStr(s,5,20));
   TempList.Add(s);
  end;
 end; {end i loop for all forms}

 FormsToPrint.Clear;
 For i:=0 to TempList.Count-1 do FormsToPrint.Add(
   PaddZero(IntToStr(i),3)+MidStr(TempList2[i],4,20));
 TempList.Free;
 Templist2.Free;
end;

Procedure ResequenceStatements(Var TempList2:TStringList);
Var i:Integer;TempList3:TStringList;
    s:String[20];Frm,Inst:String[10];
    StartSeq:Integer;
begin
 {comiming sssnfffffff#ff}
 TempList3:=TstringList.Create;
 StartSeq:= 0;
 For i:=0 to TempList2.Count-1 do
 begin
   s:=TempList2[i];
   Frm:=ExtractNonInstFormName(MidStr(s,5,20));
   Inst:=PaddR(ExtractFormInst(MidStr(s,5,20)),3);
   TempList3.Add(
     Inst+PaddZero(IntToStr(StartSeq+i),3)+MidStr(s,1,4)+Frm);
     {#ffsssnfffffff}
 end;
 TempList3.Sort;
 TempList2.Clear;
 For i:=0 to Templist3.Count-1 do
    Templist2.Add(
     MidStr(TempList3[i],4,3)+
     AllTrim(MidStr(TempList3[i],4,1))+
     AllTrim(MidStr(Templist3[i],8,10))+
     AllTrim(MidStr(Templist3[i],1,3)));
    {sssnffffffff#ff}
 TempList3.Free;
end;
*)

Function CalcInvSurcharge(RetNo:Integer):Real;
Var Income:Real;TempList:TstringList;
FromInc1,ToInc1,Adj1,
FromInc2,ToInc2,Adj2,
FromInc3,ToInc3,Adj3,
FromInc4,ToInc4,Adj4:Real;
Begin
 Result:=0;
// If LeftStr(LicenseLevel,8) <> 'T1 Multi' then exit;
  If not (LicenseLevel in anyMulti) then exit;

 Income:= Ret[RetNo].Lnn[15000];
 {load inv adjustments}
 If FileExists(AppDir+'\'+'INVADJ.D') then
 begin
  TempList:=TstringList.Create;
  TempList.LoadFromFile(AppDir+'\'+'INVADJ.D');
  FromInc1:=Vl(RemoveChar(AllTrim(LeftStr(TempList[0],10)),','));
  ToInc1  :=Vl(RemoveChar(AllTrim(MidStr(TempList[0],11,10)),','));
  Adj1    :=Vl(RemoveChar(AllTrim(MidStr(TempList[0],21,10)),','));

  FromInc2:=Vl(RemoveChar(AllTrim(LeftStr(TempList[1],10)),','));
  ToInc2  :=Vl(RemoveChar(AllTrim(MidStr(TempList[1],11,10)),','));
  Adj2    :=Vl(RemoveChar(AllTrim(MidStr(TempList[1],21,10)),','));

  FromInc3:=Vl(RemoveChar(AllTrim(LeftStr(TempList[2],10)),','));
  ToInc3  :=Vl(RemoveChar(AllTrim(MidStr(TempList[2],11,10)),','));
  Adj3    :=Vl(RemoveChar(AllTrim(MidStr(TempList[2],21,10)),','));

  FromInc4:=Vl(RemoveChar(AllTrim(LeftStr(TempList[3],10)),','));
  ToInc4  :=Vl(RemoveChar(AllTrim(MidStr(TempList[3],11,10)),','));
  Adj4    :=Vl(RemoveChar(AllTrim(MidStr(TempList[3],21,10)),','));
 end
 else
 begin
  Result:=0;
  exit;
 end;


 If (Income >=FromInc1) and (Income <ToInc1) then Result:=Adj1;
 If (Income >=FromInc2) and (Income <ToInc2) then Result:=Adj2;
 If (Income >=FromInc3) and (Income <ToInc3) then Result:=Adj3;
 If (Income >=FromInc4) and (Income <ToInc4) then Result:=Adj4;
 Templist.Free;
end;


(*
function GetGpValue(FldName:WideString):String;
begin
 Result:='';
 try
   result:= ProfileClient1.Field[FldName]
 except
  on E: Exception do
  begin
  MessageDlg(E.Message, mtError, [mbok], 0);
   result :=FloatToStr(ProfileClient1.Field[FldName]);
   If result='0' then result :='';
   ShowMessage('FldName in error='+FldName);
  end;
 end; //try
end;
*)

Function GetWinBootDir:String;
Var Registry:TRegistry;
begin
 Result:='';
 result:=GetRegistryValue(HKEY_LOCAL_MACHINE,
            '\SOFTWARE\Microsoft\Windows\CurrentVersion','SystemRoot');
 If result='' then
 begin
   Try
    If GetRegistryValue(HKEY_LOCAL_MACHINE,
                '\SOFTWARE\Microsoft\Windows NT\CurrentVersion',
                'SystemRoot') >'' then
                result:=GetRegistryValue(HKEY_LOCAL_MACHINE,
              '\SOFTWARE\Microsoft\Windows NT\CurrentVersion','SystemRoot')
   except
   end;  {except}
 end;
end;

Function AssetElmIsOverride(Elm:Integer):Boolean;
var
I: Integer;
begin
 result:=False;
 i:=175;
 Repeat
  If elm=i then begin result:=True;exit;End;
  Inc(i,4);
 until i>219;
end;


(*
Procedure StoreLastYearT2125Sum(RetNo:Integer;FInst:String);
Var i,FromElm,ToElm,SumFNo,StmFNo:Integer;TempList:TStringList; IInst:Integer;
begin
   TempList := TstringList.Create;
   TempList.LoadFromFile(AppDir+'\'+'T2125SUM.D');
   StmFNo:=GetFormNo('T2125'+FInst);
   SumFNo:=GetFormNo('T2125SUM'+FInst);
   If SumFNo=0 then
   begin
     AddPageInstance('T2125SUM',FInst);
     SumFno := GetFormNo('T2125SUM'+FInst);   //{get it again
     If SumFNo=0 then ShowMessage('cannot create T2125 Summary');
   end;
   //now store the data
   //If Ret[RetNo].Frm[SumFNo].Strings.count=0 then
   If FInst>'#1' then InitFormData(RetNo,SumFNo);  //20101217
   StoreElm(RetNo,SumFNo,7+1,FormatFloat('#########.##',vl(FetchElmFNo(RetNo,StmFNo,23))+Vl(FetchElmFNo(RetNo,StmFNo,89))));


   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3)) +1; //last years thus +1
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then StoreElm(RetNo,SumFNo,ToElm,FetchElmFNo(RetNo,StmFNo,FromElm));
   end;

   TempList.Free;
end;

Procedure StoreLastYearT776Sum(RetNo:Integer;FInst:String);
Var i,FromElm,ToElm,SumFNo,StmFNo:Integer;TempList:TStringList; IInst:Integer;
begin
EXIT;  //20120309
   TempList := TstringList.Create;
   TempList.LoadFromFile(AppDir+'\'+'T776SUM.D');
   StmFNo:=GetFormNo('T776'+FInst);
   SumFNo:=GetFormNo('T776SUM'+FInst);
   If SumFNo=0 then
   begin
     AddPageInstance('T776SUM',FInst);
     SumFno := GetFormNo('T776SUM'+FInst);   //{get it again
     If SumFNo=0 then ShowMessage('cannot create T776 Summary');
   end;
   //now store the data
   InitFormData(RetNo,SumFNo);

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3))+1; //last years thus +1
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then StoreElm(RetNo,SumFNo,ToElm,FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
   TempList.Free;
end;

Procedure StoreLastYearT2042Sum(RetNo:Integer;FInst:String);
Var i,FromElm,ToElm,SumFNo,StmFNo:Integer;TempList:TStringList; IInst:Integer;
begin
  EXIT;
   TempList := TstringList.Create;
   TempList.LoadFromFile(AppDir+'\'+'T2042SUM.D');
   StmFNo:=GetFormNo('T2042'+FInst);
   SumFNo:=GetFormNo('T2042SUM'+FInst);
   If SumFNo=0 then
   begin
     AddPageInstance('T2042SUM',FInst);
     SumFno := GetFormNo('T2042SUM'+FInst);   //{get it again
     If SumFNo=0 then ShowMessage('cannot create T2042 Summary');
   end;
   //now store the data
   InitFormData(RetNo,SumFNo);
  // StoreElm(RetNo,SumFNo,7+1,FormatFloat('#########.##',vl(FetchElmFNo(RetNo,StmFNo,23))+Vl(FetchElmFNo(RetNo,StmFNo,89))));

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3)) +1; //last years thus +1
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then StoreElm(RetNo,SumFNo,ToElm,FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
   TempList.Free;
end;

Procedure StoreLastYearT2121Sum(RetNo:Integer;FInst:String);
Var i,FromElm,ToElm,SumFNo,StmFNo:Integer;TempList:TStringList; IInst:Integer;
begin
 EXIT;
   TempList := TstringList.Create;
   TempList.LoadFromFile(AppDir+'\'+'T2121SUM.D');
   StmFNo:=GetFormNo('T2121'+FInst);
   SumFNo:=GetFormNo('T2121SUM'+FInst);
   If SumFNo=0 then
   begin
     AddPageInstance('T2121SUM',FInst);
     SumFno := GetFormNo('T2121SUM'+FInst);   //{get it again
     If SumFNo=0 then ShowMessage('cannot create T2121 Summary');
   end;
   //now store the data
   InitFormData(RetNo,SumFNo);
  // StoreElm(RetNo,SumFNo,7+1,FormatFloat('#########.##',vl(FetchElmFNo(RetNo,StmFNo,23))+Vl(FetchElmFNo(RetNo,StmFNo,89))));

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3)) +1; //last years thus +1
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then StoreElm(RetNo,SumFNo,ToElm,FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
   TempList.Free;
end;


Procedure StoreLastYearT1163Sum(RetNo:Integer;FInst:String);
Var i,FromElm,ToElm,SumFNo,StmFNo:Integer;TempList:TStringList; IInst:Integer;
begin
 EXIT;
   TempList := TstringList.Create;
   TempList.LoadFromFile(AppDir+'\'+'T1163SUM.D');
   StmFNo:=GetFormNo('T1163'+FInst);
   SumFNo:=GetFormNo('T1163SUM'+FInst);
   If SumFNo=0 then
   begin
     AddPageInstance('T1163SUM',FInst);
     SumFno := GetFormNo('T1163SUM'+FInst);   //{get it again
     If SumFNo=0 then ShowMessage('cannot create T1163 Summary');
   end;
   //now store the data
   InitFormData(RetNo,SumFNo);
  // StoreElm(RetNo,SumFNo,7+1,FormatFloat('#########.##',vl(FetchElmFNo(RetNo,StmFNo,23))+Vl(FetchElmFNo(RetNo,StmFNo,89))));

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3)) +1; //last years thus +1
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then StoreElm(RetNo,SumFNo,ToElm,FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
   TempList.Free;
end;


Procedure StoreLastYearT1273Sum(RetNo:Integer;FInst:String);
Var i,FromElm,ToElm,SumFNo,StmFNo:Integer;TempList:TStringList; IInst:Integer;
begin
 EXIT;
   TempList := TstringList.Create;
   TempList.LoadFromFile(AppDir+'\'+'T1273SUM.D');
   StmFNo:=GetFormNo('T1273'+FInst);
   SumFNo:=GetFormNo('T1273SUM'+FInst);
   If SumFNo=0 then
   begin
     AddPageInstance('T1273SUM',FInst);
     SumFno := GetFormNo('T1273SUM'+FInst);   //{get it again
     If SumFNo=0 then ShowMessage('cannot create T1273 Summary');
   end;
   //now store the data
   InitFormData(RetNo,SumFNo);

   For i:=0 to TempList.count-1 do
   begin
    ToElm:=MyStrtoInt(LeftStr(TempList[i],3)) +1; //last years thus +1
    FromElm:=MyStrtoInt(MidStr(TempList[i],6,3));
    If (ToElm>0) and (FromElm>0) then StoreElm(RetNo,SumFNo,ToElm,FetchElmFNo(RetNo,StmFNo,FromElm));
   end;
   TempList.Free;
end;
*)

Function AllowedToChangeSaveDir(SaveDir: String): Boolean;
//20170811 Igor>>>
begin
  If (LicenseLevel in anyMulti) then
    If (UpperCase(LeftStr(SaveDir,2))= 'A:') or
       (UpperCase(LeftStr(SaveDir,2))= 'B:') then
      Result := YouKnowTheAdminPassword
    else
      result := True
  else
    Result := True;
//20170811 Igor<<<
end;

end.

