unit T2_2027CntErr;
(* revision 2014-07-29
*)

interface

uses
  vtMulti,
  vtDynData;   //20190829 CON

//Function NotPaidFor2018(RetNo:Integer):Boolean;  //20170614  move to trimstr //20170628
Function CountAlbErrors(AuditList:TAuditList):Integer;
Function CountDiagnostics(RetNo: integer):Integer;

//20170130
//20170909 Igor>>>
//Procedure ValidateNovDecLicenses(RetNo:Integer);
//20170909 Igor<<<

//20160126
Procedure ValidateConsent(RetNo: integer; Fno: integer; Inst: String);
Procedure ValidateAConsent(RetNo: integer; Fno: integer);
Procedure ValidateT1134(RetNo:Integer;Fno:Integer);
Procedure ValidateT1134S(RetNo:Integer;Fno,FInst:Integer); //20230510 Igor
Procedure ValidateT1135(RetNo:Integer;Fno:Integer);
Procedure RemoveT1135SectionAdata(RetNo:Integer;Fno:Integer);
Procedure RemoveT1135SectionBdata(RetNo:Integer;Fno:Integer);
Procedure ValidateT1135SectionAdata(RetNo:Integer;Fno:Integer);
Procedure ValidateT1135SectionBdata(RetNo:Integer;Fno:Integer);
//20160523
Procedure ValidateT2(RetNo:Integer);
Procedure ValidateS100(RetNo:Integer;FName:String);
Procedure ValidateS101(RetNo:Integer;Fname:String);
Procedure ValidateS125(RetNo:Integer;Fname:String);

//20171121
Procedure ValidateT106(RetNo:Integer);
Procedure ValidateT106SL(RetNo:Integer);
Procedure ValidateAT106SLip(RetNo:Integer;SlFName:String;SlipFNo:Integer);
//----
Procedure ValidateCBCR(RetNo:Integer;Fno:Integer); //20230109 Igor

implementation

uses
  SysUtils, Classes,
  vtCommon,
  T2_2027, T2_2027Multi, T2_2027TrimStr, T2_2027Declare,T2_2027Common, T2_2027Common2,
  vtTrimStr, vtShared, T2_2027Calc4;

Function CountAlbErrors(AuditList:TAuditList):Integer;
Var i:Integer;
  r: TAuditRec;
begin
 Result:=0;
 For i:=0 to AuditList.Count-1 do
 begin
  r := AuditList[i];
  If (r.Category = 'E')
  and (Pos('Alb', r.Description) = 1) then // = 'E-Alb' then
    Inc(Result);
 end;
end;


//20160222 Igor <<<<
Function CountDiagnostics(RetNo: integer):Integer;
Var i,j,J1,J2,J3,j4,j5,JCapitalCost,HalfyearNdx,k,kk,Page1FNo,FNo,ElmNo,ArrayNo: integer; FrmNm: string[10];
Inst:String;
ErrMsg : string[50];x:real;s,s1:String;
TempList:TStringList;
begin
  If RetNo=0 then exit;
  If RetInMem < 1 then exit;
  Ret[RetNo].ErrorCount := 0;
  Ret[RetNo].MandatoryErrorCount := 0;
  Ret[RetNo].SeriousErrorCount:=0;
  Ret[RetNo].EfileErrorCount:=0;
  Ret[RetNo].AuditList.Clear;

  Page1FNo:=GetFormNo('T2');  //20161129

  {Federal}

  //20100528
  //If FetchElm(RetNo,'T183CP',21)>'' then  SaveDiagnostic(RetNo,'T183CP',21,'W-Return is locked');
  If UpperCase(FetchElm(RetNo,'STATUS',26))='Y' then SaveDiagnostic(RetNo,'STATUS',26,'W-Return is locked');

  FrmNm := FirstFormName; {T2 Page 1}

  ValidateT2(RetNo);  //20160523

  If ((FetchElmFNo(RetNo,Page1FNo,28) > '')
  or (FetchElmFNo(RetNo,Page1FNo,30) > '')
  or (FetchElmFNo(RetNo,Page1FNo,36) > '')) then
  Begin
   If Ret[RetNo].FrmHasData[GetFormNo('S24')]=False then
     SaveDiagnostic(RetNo,'S24',1,'E-S24 needs to be completed');
  end;

  //20200221
  if (Vl(FetchElm(RetNo,Page1FNo,92)) = 0) and
   (Vl(FetchElm(RetNo,'S7',335)) > 0) then
   SaveDiagnostic(RetNo,'T2',92,'W-T2-Check Line 417. See S7: Line 744 in Part 2)');//20200221


  //20161129
  If Vl(FetchElmFNo(RetNo,Page1FNo,200)) = 0 then //amalgagmation  //20120529
  begin
   If Vl(FetchElm(RetNo,'S7',157))>0  then SaveDiagnostic(RetNo,'T2',200,'W-T2-Any taxable income from Personal Services Business?');//taxable 20200131
  end;


  If FetchElmFNo(RetNo,Page1FNo,28) > '' then //first year of filing  //20120529
  begin
   If IsOpeningBalanceSheetDone(RetNo) = false then
    SaveDiagnostic(RetNo,'GIFI',1,'E-GIFI Opening Balance sheet is required (See Help-FAQ)'); //20151026
  end;

  If FetchElmFNo(RetNo,Page1FNo,30) > '' then //amalgagmation  //20120529
  begin
   If FetchElm(RetNo,'S24',22)='' then SaveDiagnostic(RetNo,'S24',22,'E-S24-Predecessor Name is required');
   If FetchElm(RetNo,'S24',23)='' then SaveDiagnostic(RetNo,'S24',23,'E-S24-Predecessor Business number is required');
  end;


  //s21  //20221202
  FNo:=GetFormNo('S21');
  if Ret[RetNo].FrmHasData[Fno] then
  Begin
    i:=5;
    Repeat
     if (Vl(FetchElmFNo(RetNo,FNo,i))=0)
     and (Vl(FetchElmFNo(RetNo,FNo,i+1))+Vl(FetchElmFNo(RetNo,FNo,i+2))>0)
      then SaveDiagnostic(RetNo,'S21',i,'E-S21-Please enter the Net foreign non-business income');
      //20221213
     if (Vl(FetchElmFNo(RetNo,FNo,i))+Vl(FetchElmFNo(RetNo,FNo,i+1))>0)
     and (FetchElmFNo(RetNo,FNo,i-1)='')
     then SaveDiagnostic(RetNo,'S21',i-1,'E-S21-Please enter the Country code');

     Inc(i,9);
    Until i>40;
  End;

  If FetchElmFNo(RetNo,Page1FNo,36) > '' then //wind up of subsidiary  //20120529
  begin
   FNo:=GetFormNo('S24');
   If FetchElmFNo(RetNo,FNo,34)='' then SaveDiagnostic(RetNo,'S24',34,'E-S24-Subsidiary Name is required');
   If FetchElmFNo(RetNo,FNo,35)='' then SaveDiagnostic(RetNo,'S24',35,'E-S24-Subsidiary Business Number is required');
   If FetchElmFNo(RetNo,FNo,36)='' then SaveDiagnostic(RetNo,'S24',36,'E-S24-Subsidiary Wind-up start date is required');
   If FetchElmFNo(RetNo,FNo,37)='' then SaveDiagnostic(RetNo,'S24',37,'E-S24-Subsidiary Wind-up date is required');
  end;

  If IsTaxExempt(RetNo) then
     SaveDiagnostic(RetNo,'T2',53,'W-Tax Exemption is in effect');

  //20170909 Igor>>>
(*
  If GetTaxationYearEnd(RetNo) >'2008/12/01' then
  begin
  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = 'X')
  and (Not Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
    SaveDiagnostic(RetNo,'T2',63,'E-Schedule 91 not completed (exempt under treaty)');

  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = '')
  and (Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
    SaveDiagnostic(RetNo,'T2',63,'E-S91-Exempt under treaty. Enter X on page 1');
  end;

  If GetTaxationYearEnd(RetNo) <'2009/01/01' then
  begin
  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = 'X')
  and (Not Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
    SaveDiagnostic(RetNo,'T2',63,'E-S91 not completed (exempt under treaty)');


  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = '')
  and (Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
  //and (Ret[RetNo].FrmHasData[GetFormNo('S91_1')]) then  //20130125
    SaveDiagnostic(RetNo,'T2',63,'E-s91-Exempt under treaty. Enter X on page 1');
  end;
*)
//20170909 Igor<<<

 //-------------------------
  //20160501  NOTE: cannot show both errors  WHY????
  //FNo:=GetFormNo('S100');
  //20160523
  ValidateS125(RetNo,'S125#1');  //20160523
  //20160619
  k:=CountMultipleInstances(RetNo,'S125');
  If k>1 then
  Begin
   for i:=2 to k do ValidateS125(RetNo,'S125#'+AllTrim(IntToStr(i)));
  end;
  ValidateS100(RetNo,'S100');     //20160523
  ValidateS100(RetNo,'S101');     //20160523
  //------------------------------

  //20220614
  If FetchElm(RetNo,'T7DRQR',8)>'' then
  Begin
   If (midStr(FetchElm(RetNo,'T7DRQR',8),4,1)<>'-')
   or (midStr(FetchElm(RetNo,'T7DRQR',8),8,1)<>'-')
   then
     SaveDiagnostic(RetNo,'T7DRQR',8,'E-T7DRQR-Enter SIN in proper format');
  End;
  //----------------------------------


   FNo:=GetFormNo('S89');
   if (FetchElmFNo(RetNo,FNo,10001)='') and (VL(FetchElmFNo(RetNo,FNo,16))>0) then  //col 2 has amount
        SaveDiagnostic(RetNo,'S89',10001,'E-S89 Dates are required if amounts are entered');

   if (FetchElmFNo(RetNo,FNo,10001)='') and (VL(FetchElmFNo(RetNo,FNo,17))>0) then  //col 3 has amount
        SaveDiagnostic(RetNo,'S89',10001,'E-S89 Dates are required if amounts are entered');

   if (FetchElmFNo(RetNo,FNo,10001)='') and (VL(FetchElmFNo(RetNo,FNo,19))>0) then  //col 4 has amount
        SaveDiagnostic(RetNo,'S89',10001,'E-S89 Dates are required if amounts are entered');

   if (FetchElmFNo(RetNo,FNo,10001)='') and (VL(FetchElmFNo(RetNo,FNo,21))>0) then  //col 5 has amount
        SaveDiagnostic(RetNo,'S89',10001,'E-S89 Dates are required if amounts are entered');

   if (FetchElmFNo(RetNo,FNo,10001)='') and (VL(FetchElmFNo(RetNo,FNo,22))>0) then  //col 6 has amount
        SaveDiagnostic(RetNo,'S89',10001,'E-S89 Dates are required if amounts are entered');

   if (FetchElmFNo(RetNo,FNo,10001)='') and (VL(FetchElmFNo(RetNo,FNo,25))>0) then  //col 7 has amount
        SaveDiagnostic(RetNo,'S89',10001,'E-S89 Dates are required if amounts are entered');


   if (FetchElmFNo(RetNo,FNo,30001)='') and (VL(FetchElmFNo(RetNo,FNo,15))<>0) then  //col 7 has amount
        SaveDiagnostic(RetNo,'S89',30001,'E-S89 Dates are required if amounts are entered');

   //20231117
   if (FetchElmFNo(RetNo,FNo,50001)>'') and (FetchElmFNo(RetNo,FNo,50002)='') then  //
        SaveDiagnostic(RetNo,'S89',50002,'E-S89 Business Number is required');

   If (FetchElmFNo(RetNo,FNo,50002)>'') and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,50002))) then
       SaveDiagnostic(RetNo,'S89',50002,'E-S89 Business number is invalid or Enter NR');
   //---

   if (FetchElmFNo(RetNo,FNo,50001)>'') and (FetchElmFNo(RetNo,FNo,50003)='') then  //
        SaveDiagnostic(RetNo,'S89',50003,'E-S89 Date is required');

   //s89 end


  (*
   more generic But too much coding in this case
   ArrayNo:=1;
   i:=ArrayNo+10000;  //First column of first row of dynamic table
   if SplitDynId(RetNo, FNo, i) then  //establishes MaxElm and BoxesPerRow
   Begin
     if (FetchElmFNo(RetNo,FNo,i)='') and (VL(FetchElmFNo(RetNo,FNo,16))>0) then
        SaveDiagnostic(RetNo,'S89',i,'E-S89 Dates are required if amounts are used');
    while i <= MaxElm+10000 do
    begin
      if (FetchElmFNo(RetNo,FNo,i)='') and (VL(FetchElmFNo(RetNo,FNo,16))>0) then
        SaveDiagnostic(RetNo,'S89',i,'E-S89 Dates are required if amounts are used');
      inc(i, BoxesPerRow);
    end;
   End;
  *)

  //20170626
  FNo:=GetFormNo('T183CP');
  if (UpperCase(FetchElmFNo(RetNo,FNo,28))='Y')
  and (FetchElmFNo(RetNo,FNo,18)='')  then
    SaveDiagnostic(RetNo,'T183CP',18,'E-T183CP Enter Email or remove the Y');

  if FetchElmFNo(RetNo,FNo,18)> '' then
  Begin
   If ValidEMail(FetchElmFNo(RetNo,FNo,18))=False then   //20170626
      SaveDiagnostic(RetNo,'T183CP',18,'E-T183CP Email address is invalid');
  End;

  if IsAmendedReturn(RetNo) then
  begin
   if FetchElmFNo(RetNo,FNo,18)> '' then
     SaveDiagnostic(RetNo,'T183CP',18,'E-Email not allowed in Amended returns. Enter N to remove it'); //20220706
  end;

  //20171121
  ValidateT106(RetNo);
  ValidateT106SL(RetNo);

  FNo:=GetFormNo('T1134');
  ValidateT1134(RetNo,FNo);  //20180703

  //20160126
  FNo:=GetFormNo('T1135');
  ValidateT1135(RetNo,FNo);  //20160126

  //-----------------------------
  //20141202
  If Ret[RetNo].FrmHasData[GetFormNo('PRIVAT#1')]=True then
  Begin
    SaveDiagnostic(RetNo,'PRIVAT#1',1,'W-Your Private notepad has data');
  end;

   //20180628
  //20230109 Igor >>>
  FNo:=GetFormNo('CBCR');
  ValidateCBCR(RetNo,FNo);
  //20230109 Igor <<<
  (*
  //20180628
  FNo:=GetFormNo('CBCR');
  If Ret[RetNo].FrmHasData[FNo]=True then
  Begin
    if FetchElmFNo(RetNo,FNo,11)='' then
     SaveDiagnostic(RetNo,'CBCR',11,'E-CBCR-Country-by-Country - Enter Street Number on the Street Number box only');
    if FetchElmFNo(RetNo,FNo,28)>'' then
     Begin
      if FetchElmFNo(RetNo,FNo,33)='' then SaveDiagnostic(RetNo,'CBCR',33,'E-CBCR-Address is missing');
     end;
  end;
  *)

  //20200215 ---------------------------
  Fno := GetFormNo('CONSENT#1');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    Inst := '#1';
    ValidateCONSENT(RetNo, Fno, Inst);
  end;
  Fno := GetFormNo('CONSENT#2');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    Inst := '#2';
    ValidateCONSENT(RetNo, Fno, Inst);
  end;

  //20201205
  Fno := GetFormNo('ACONSENT');
  If Ret[RetNo].FrmHasData[Fno] then
  begin
    ValidateACONSENT(RetNo, Fno);
  end;


  FNo:=GetFormNo('S1');
  { //20260620
  if FetchElmFNo(RetNo,Fno,151)='' then  //20211106
  Begin
   SaveDiagnostic(RetNo,'S1',151,'E-Any Covid 19 Subsidy? Enter Y or No in S1)');  //20220226
  End;
  }
  For i:=5 to 32 do
  begin
   Case i of
    5,6,8,9,10,13,51: {can have negative}
    else
    begin
     If Vl(FetchElmFNo(RetNo,Fno,i))<0 then
       SaveDiagnostic(RetNo,'S1',I,'E-S1 amount cannot be negative');
    end;
   end; //case
  end;

  For i:=35 to 51 do
  begin
   Case i of
    48,51: {can have negative}
    else
    begin
     If Vl(FetchElmFNo(RetNo,Fno,i))<0 then
       SaveDiagnostic(RetNo,'S1',I,'E-S1 amount cannot be negative');
    end;
   end; //case
  end;

  //-----------------------
  FNo:=GetFormNo('S1'); //pg2
  For i:=101 to 137 do
  begin
    If Vl(FetchElmFNo(RetNo,Fno,i))<0 then SaveDiagnostic(RetNo,'S1',I,'E-S1 amount cannot be negative');
  end;
  For i:=148 to 149 do
  begin
   If Vl(FetchElmFNo(RetNo,Fno,i))<0 then SaveDiagnostic(RetNo,'S1',i,'E-S1 amount cannot be negative');
  end;
  i:=139;
  Repeat
   If Vl(FetchElmFNo(RetNo,Fno,i))<0 then SaveDiagnostic(RetNo,'S1',i,'E-S1 amount cannot be negative');
   Inc(i,2);
  until i>147;

 //-----------------------
  FNo:=GetFormNo('S1'); //pg3
  For i:=201 to 216 do
  begin
    If Vl(FetchElmFNo(RetNo,Fno,i))<0 then SaveDiagnostic(RetNo,'S1',I,'E-S1 amount cannot be negative');
  end;
  If Vl(FetchElmFNo(RetNo,Fno,35))<0 then SaveDiagnostic(RetNo,'S1',235,'E-S1 amount cannot be negative');
  If Vl(FetchElmFNo(RetNo,Fno,20))<0 then SaveDiagnostic(RetNo,'S1',220,'E-S1 amount cannot be negative');
  i:=223;
  Repeat
   If Vl(FetchElmFNo(RetNo,Fno,i))<0 then SaveDiagnostic(RetNo,'S1',i,'E-S1 amount cannot be negative');
   Inc(i,2);
  until i>233;

   //-----------------------
  FNo:=GetFormNo('S1'); //pg3
  For i:=201 to 216 do
  begin
    If Vl(FetchElmFNo(RetNo,Fno,i))<0 then SaveDiagnostic(RetNo,'S1',I,'E-S1 amount cannot be negative');
  end;
  If Vl(FetchElmFNo(RetNo,Fno,35))<0 then SaveDiagnostic(RetNo,'S1',235,'E-S1 amount cannot be negative');
  If Vl(FetchElmFNo(RetNo,Fno,20))<0 then SaveDiagnostic(RetNo,'S1',220,'E-S1 amount cannot be negative');
  i:=223;
  Repeat
   If Vl(FetchElmFNo(RetNo,Fno,i))<0 then SaveDiagnostic(RetNo,'S1',i,'E-S1 amount cannot be negative');
   Inc(i,2);
  until i>233;

 //20141203 -----------------------
  FNo:=GetFormNo('S2'); //pg3
  If UpperCase(FetchElmFNo(RetNo,Fno,21))='Y' then SaveDiagnostic(RetNo,'S2',21,'E-S2 Override claim only in Part 7 of S2');
  If UpperCase(FetchElmFNo(RetNo,Fno,158))='Y' then SaveDiagnostic(RetNo,'S2',158,'E-S2 Override claim only in Part 7 of S2');
  If UpperCase(FetchElmFNo(RetNo,Fno,159))='Y' then SaveDiagnostic(RetNo,'S2',159,'E-S2 Override claim only in Part 7 of S2');
  If UpperCase(FetchElmFNo(RetNo,Fno,160))='Y' then SaveDiagnostic(RetNo,'S2',160,'E-S2 Override claim only in Part 7 of S2');
  If UpperCase(FetchElmFNo(RetNo,Fno,161))='Y' then SaveDiagnostic(RetNo,'S2',161,'E-S2 Override claim only in Part 7 of S2');

   // 20140920
  FNo:=GetFormNo('S8ALL');
  i:=6;
  Repeat
  If ((FetchElmFNo(RetNo,FNo,i) ='43.1')  Or (FetchElmFNo(RetNo,FNo,i) ='43.2'))
  and (Vl(FetchElmFNo(RetNo,FNo,i+2))>0) then
  begin
   j:=(I Div 15)+1;
   If Class43HasDetail(RetNo,J)=false then
     SaveDiagnostic(RetNo,'S8ALL',i,'E-S8All Enter details for class 43 (2nd page of S8All)');
  end;
  Inc(i,15);
  until i>531;

  

  //------------------------------
  FNo:=GetFormNo('S15');
  If (Vl(FetchElmFNo(RetNo,FNo,154)) >0)  //20140608
  and (Vl(FetchElmFNo(RetNo,FNo,155)) =0) then
     SaveDiagnostic(RetNo,'S15',155,'W-S15 Any GIFI deduction for deferred income plans? (Line 8623)');
  i:=12; //20140608
  Repeat
   If FetchElmFNo(RetNo,FNo,i)>'' then
   begin
    If FetchElmFNo(RetNo,FNo,i-1)='CA' then
    begin
      If ValidPostal(RetNo,FetchElmFNo(RetNo,FNo,i),FetchElmFNo(RetNo,FNo,i-1)) = False then
           SaveDiagnostic(RetNo,'S15',i,'E-S15-Postal-Enter as ANA NAN (or ZIP as 5 or 9 digits');
    end;
   end;
   Inc(i,10);
  until i>152;
  //---------------------------
  //20150214
  FNo:=GetFormNo('S33');
  If Ret[RetNo].FrmHasData[FNo]=True then
  Begin
  If (Vl(FetchElmFNo(RetNo,FNo,17)) =0) then
    SaveDiagnostic(RetNo,'S33',17,'E-S33 Capital cannot be zero');
  End;


  //20140920
  If Ret[RetNo].FrmHasData[GetFormNo('S88')]=false then
  Begin
    SaveDiagnostic(RetNo,'S88',9,'W-S88-If you earned income from websites, fill form S88');
  end;


  //---------------------------

  FNo:=GetFormNo('S16');
  If (Vl(FetchElm(RetNo,'S16',111)) >0)
   and (Vl(FetchElmFNo(RetNo,FNo,13))+ Vl(FetchElmFNo(RetNo,FNo,15)) =0) then
     SaveDiagnostic(RetNo,'S16',13,'E-S16 Enter line 110 or 111, if Ln 119 >0');

  FNo:=GetFormNo('S24');
  If Ret[RetNo].FrmHasData[GetFormNo('S24')] then
  begin
   If FetchElmFNo(RetNo,FNo,66) ='' then
     SaveDiagnostic(RetNo,'S24',21,'E-S24 Corp type required');  //20150603
   i:=23;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i)))
     then SaveDiagnostic(RetNo,'S24',i,'E-S24 Business No invalid OR 9 digits invalid');
    Inc(i,2);
   until i>33;
   i:=35;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i)))
     then SaveDiagnostic(RetNo,'S24',i,'E-S24 Business No invalid OR 9 digits invalid');

    If (FetchElmFNo(RetNo,FNo,i+2) >'') then
    begin
     If (FetchElmFNo(RetNo,FNo,i+2) < GetBegYearEnd(RetNo))
     or (FetchElmFNo(RetNo,FNo,i+2) > GetTaxationYearEnd(RetNo))
      then SaveDiagnostic(RetNo,'S24',i+2,'E-S24 Date must be within start/end year end of corporation');
    end;
    Inc(i,4);
   until i>63;
  end;  //S24

  If IsFirstYearAfterWindUp(RetNo) then
  begin
   If FetchElm(RetNo,'S24',34) ='' then
      SaveDiagnostic(RetNo,'S24',34,'E-S24 Please provide wind-up info');
  end;

  If (UpperCase(FetchElm(RetNo,'S27',22)) ='Y')
  and (UpperCase(FetchElm(RetNo,'S502',28)) <>'Y')
  and (GetTxblIncomeInProv(RetNo,'ON')>0)
  then
  begin
    SaveDiagnostic(RetNo,'S502',28,'W-S502 M/P claimed on S27 but not in S502');
  end;

  //20100903
  FNo:=GetFormNo('S28');
  //20130603
  If (FetchElmFNo(RetNo,FNo,49)>'') and (FetchElmFNo(RetNo,FNo,50)='') then
     SaveDiagnostic(RetNo,'S28',50,'E-S28 Business number required (or NR)');
  If FetchElmFNo(RetNo,FNo,50)>'' then
  Begin
   If (UpperCase(FetchElmFNo(RetNo,FNo,50)) <>'NR')
   and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,Fno,50))) then
   SaveDiagnostic(RetNo,'S28',50,'E-S28 Business number is invalid');
  end;
  //--
  i:=5;
  Repeat
   If (FetchElmFNo(RetNo,Fno,i)>'')
   and (UpperCase(FetchElmFNo(RetNo,FNo,i)) <>'NR')
   and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,Fno,i))) then
   SaveDiagnostic(RetNo,'S28',i,'E-S28 Business number is invalid');
   Inc(i,3);
  until i>47;

  FNo:=GetFormNo('S31');
  If FetchElmFNo(RetNo,FNo,107) >''  then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,109))=0 then
    SaveDiagnostic(RetNo,'S31',109,'E-S31 Enter contribution amount');
  end;
  //20151025
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If (FetchElmFNo(RetNo,FNo,329)='') and (isAssociated(RetNo)=True)  then
    SaveDiagnostic(RetNo,'S31',329,'W-S31 Line 385: Should it be Associated?');
  end;

  //20130503
  If Vl(FetchElmFNo(RetNo,FNo,245))+Vl(FetchElmFNo(RetNo,FNo,276))> Vl(FetchElmFNo(RetNo,FNo,236))
  then SaveDiagnostic(RetNo,'S31',245,'E-S31 Lines 240 and 242 exceed line (A)');
  If (Vl(FetchElmFNo(RetNo,FNo,236))>0)
  and (Vl(FetchElmFNo(RetNo,FNo,245))+Vl(FetchElmFNo(RetNo,FNo,276))= 0)
  then SaveDiagnostic(RetNo,'S31',245,'W-S31 Any amounts on Lines 240 and 242');

  If Vl(FetchElmFNo(RetNo,FNo,510)) >0  then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,511)) +Vl(FetchElmFNo(RetNo,FNo,515))=0 then
    SaveDiagnostic(RetNo,'S31',511,'W-S31 May qualify for credit, line 460/480/490');
  end;


  //20171109
  If  Vl(FetchElmFNo(RetNo,FNo,511))+Vl(FetchElmFNo(RetNo,FNo,515))+Vl(FetchElmFNo(RetNo,FNo,16))
    > Vl(FetchElmFNo(RetNo,FNo,510)) then
     SaveDiagnostic(RetNo,'S31',511,'W-S31-Lines 460 + 480 + 490 cannot exceed the repayment amount');

  If Vl(FetchElmFNo(RetNo,FNo,736)) >0  then
  begin
    If (FetchElmFNo(RetNo,FNo,704)='')
    or (FetchElmFNo(RetNo,FNo,708)='') then
     SaveDiagnostic(RetNo,'S31',i,'E-S31 Please provide details in 800-807'); //??? where does i come from?
  end;

  If Vl(FetchElmFNo(RetNo,FNo,809))+
     Vl(FetchElmFNo(RetNo,FNo,811))+
     Vl(FetchElmFNo(RetNo,FNo,814)) > Vl(FetchElm(RetNo,'S31',740)) then
  begin
    SaveDiagnostic(RetNo,'S31',709,'E-S31 Expenditures exceed total of Part 16');
    SaveDiagnostic(RetNo,'S31',811,'E-S31 Expenditures exceed total of Part 16');
    SaveDiagnostic(RetNo,'S31',813,'E-S31 Expenditures exceed total of Part 16');
  end;

  If (Vl(FetchElm(RetNo,'S31',1317))>0) //pg14
  and (Vl(FetchElm(RetNo,'S31',1318))=0) then
    SaveDiagnostic(RetNo,'S31',1318,'W-S31 Credit available, but not applied against tax');

  //  --- end S31 validations
  //Fnote related  ------------
  If UseGifi(RetNo) then
  Begin
   FNo:=GetFormNo('S141');          //20160331
  // FNo:=GetFormNo('S141');
   If (IsInactive(RetNo)=False)
   and (IsLifeInsuranceCorp(RetNo)=False)  //20161112
   then
   Begin
    If Ret[RetNo].FrmHasData[FNo] =false then
      SaveDiagnostic(RetNo,'S141',4,'E-S141-GIFI Notes checklist not completed');
    If (Ret[RetNo].FrmHasData[GetFormNo('FNOTE2')]= True)
    and (FetchElmFNo(RetNo,FNo,12)='') then
     SaveDiagnostic(RetNo,'S141',12,'E-S141-GIFI Notes prepared. Enter Yes');


    If ((FetchElmFNo(RetNo,Fno,6)>'') and (FetchElmFNo(RetNo,Fno,33)>''))
    and (FetchElmFNo(RetNo,Fno,34)+FetchElmFNo(RetNo,FNo,35)+FetchElmFNo(RetNo,FNo,36)
       +FetchElmFNo(RetNo,FNo,37)+FetchElmFNo(RetNo,FNo,5)= '') //20230606
    then
    begin
     SaveDiagnostic(RetNo,'S141',34,'E-S141-GIFI Notes-Type of involvement required');
     SaveDiagnostic(RetNo,'S141',35,'E-S141-GIFI Notes-Type of involvement required');
     SaveDiagnostic(RetNo,'S141',36,'E-S141-GIFI Notes-Type of involvement required');
     SaveDiagnostic(RetNo,'S141',37,'E-S141-GIFI Notes-Type of involvement required');
     SaveDiagnostic(RetNo,'S141',5,'E-S141-GIFI Notes-Type of involvement required');  //20230606
    end;

    If ((FetchElmFNo(RetNo,Fno,34)>'') or (FetchElmFNo(RetNo,Fno,35)>''))
    and (FetchElmFNo(RetNo,Fno,38)+FetchElmFNo(RetNo,FNo,39) = '')
    then
     SaveDiagnostic(RetNo,'S141',39,'E-S141-GIFI Notes-Practitioner reservation missing');  //20150415
   end;
  end; //fnote pg1


  //20160621
  FNo:=GetFormNo('S73');
  if (Vl(FetchElmFNo(RetNo,FNo,438)) >0) and
      (Vl(FetchElmFNo(RetNo,FNo,502))+Vl(FetchElmFNo(RetNo,FNo,503))+Vl(FetchElmFNo(RetNo,FNo,504))
      +Vl(FetchElmFNo(RetNo,FNo,511))+Vl(FetchElmFNo(RetNo,FNo,512))=0)  then
    SaveDiagnostic(RetNo,'S73',438,'W-S73-Column 13 total needs the breakdown below');

  FNo:=GetFormNo('S141');
  If UpperCase(FetchElm(RetNo,'T2',76)) ='Y' then  //efile  //20130525
  //If UpperCase(FetchElm(RetNo,'T183CP',19)) ='Y' then  //efile
  begin
   If IsInactive(RetNo)=False then
   Begin
    If (FetchElmFNo(RetNo,FNo,12) >'')  {fnl notes = Y}
    and (GifiNotesEntered(RetNo) = false) then
     SaveDiagnostic(RetNo,'FNOTE2',4,'W-FNOTE2-GIFI Financial notes missing');    //20181106
    If (FetchElmFNo(RetNo,FNo,12) ='')  {fnl notes = Y}
    and (GifiNotesEntered(RetNo) = True) then
     SaveDiagnostic(RetNo,'S141',12,'E-S141-GIFI Notes indicator should be Yes');
   end;
  end;
 //----------------------------------------------------------------------

  //20170614
  FNo:=GetFormNo('S7');
  For i:=79 to 83 do
  Begin
    If (FetchElmFNo(RetNo,FNo,i) >'') then
    Begin
     If (UpperCase(FetchElmFNo(RetNo,FNo,i)) <>'NR')
     and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i)))
      then SaveDiagnostic(RetNo,'S7',i,'E-S7 Business Number is invalid OR first 9 digits invalid');
    End;
  end;

  For i:=84 to 87 do
  Begin
    If (FetchElmFNo(RetNo,FNo,i) >'') then
    Begin
    If (ValidSin(LeftStr(FetchElmFNo(RetNo,FNo,i),9)) = False)
     then SaveDiagnostic(RetNo,'S7',i,'E-S7 The SIN Number is invalid');
    End;
  end;

  For i:=191 to 195 do
  Begin
    If (FetchElmFNo(RetNo,FNo,i) >'') then
    Begin
     If (UpperCase(FetchElmFNo(RetNo,FNo,i)) <>'NR')
     and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i)))
      then SaveDiagnostic(RetNo,'S7',i,'E-S7 Business Number is invalid OR first 9 digits invalid');
    End;
  End;

  If Vl(FetchElmFNo(RetNo,FNo,7))<0 then SaveDiagnostic(RetNo,'S7',7,'E-S7-Value cannot be negative'); //20121205
  If Vl(FetchElmFNo(RetNo,FNo,201))<0 then //loss from rental   //20200805
  Begin
     If Abs(Vl(FetchElmFNo(RetNo,FNo,207)))>Abs(Vl(FetchElmFNo(RetNo,FNo,201))) then
        SaveDiagnostic(RetNo,'S7',204,'E-S7 You must not increase the Rental loss using CCA');
  End;

  //20170601
  i:=106;
  Repeat
   if Vl(FetchElmFNo(RetNo,FNo,i-4))<>0 then
   Begin
    if FetchElmFNo(RetNo,FNo,i)='' then SaveDiagnostic(RetNo,'S7',i,'E-S7-Number of days not entered');
   End;
   Inc(i,8);
  Until i>138;

 //----------  S7
  If (Vl(FetchElm(RetNo,'S21',5))+Vl(FetchElm(RetNo,'S21',14)) >0)
  and (Vl(FetchElm(RetNo,'S7',257)) = 0) then
  begin
   SaveDiagnostic(RetNo,'S7',254,'W-S21-Net Foreign income s/b entered on S7');
  end;

  If FetchElm(RetNo,'RC59',66)='' then
   SaveDiagnostic(RetNo,'RC59',66,'W-RC59-Consent form?');

  If IsAmalgamatedOntario(RetNo)=False then
  begin
   If Ret[RetNo].Province = 'ON' then
   begin
    If Ret[RetNo].FrmHasData[GetFormNo('OAUTH')] = false then
     SaveDiagnostic(RetNo,'OAUTH',1,'W-Ont Consent form needed?');
   end;
  End;

  //-----------------
  //20180529
  FNo:=GetFormNo('RC59');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   if (FetchElm(RetNo,FNo,10)>'') and (Length(FetchElm(RetNo,FNo,10))<>7) then  //20180728
    SaveDiagnostic(RetNo,'RC59',10,'E-RC59-Representative Id must be 7 alhanumeric characters');

   if (FetchElm(RetNo,FNo,3)>'') and (FetchElm(RetNo,FNo,7)='') then
      SaveDiagnostic(RetNo,'RC59',7,'E-RC59-Area code is required');
   if (FetchElm(RetNo,FNo,3)>'') and (FetchElm(RetNo,FNo,8)='') then
      SaveDiagnostic(RetNo,'RC59',8,'E-RC59-Phone number is required');

   if (FetchElm(RetNo,FNo,3)+FetchElm(RetNo,FNo,7)+FetchElm(RetNo,FNo,8)+FetchElm(RetNo,FNo,6)
       +FetchElm(RetNo,FNo,9)='') //20180824 CON
   and (FetchElm(RetNo,FNo,10)+FetchElm(RetNo,FNo,57)+FetchElm(RetNo,FNo,20)='') then
   Begin
    SaveDiagnostic(RetNo,'RC59',3, 'E-RC59-Please complete Telephone/Mail section OR Online section)');
    SaveDiagnostic(RetNo,'RC59',7, 'E-RC59-Please complete Telephone/Mail section OR Online section)');
    SaveDiagnostic(RetNo,'RC59',8, 'E-RC59-Please complete Telephone/Mail section OR Online section)');
    SaveDiagnostic(RetNo,'RC59',6, 'E-RC59-Please complete Telephone/Mail section OR Online section)');
    SaveDiagnostic(RetNo,'RC59',9, 'E-RC59-Please complete Telephone/Mail section OR Online section)');
    SaveDiagnostic(RetNo,'RC59',10,'E-RC59-Please complete Telephone/Mail section OR Online section)');
    SaveDiagnostic(RetNo,'RC59',57,'E-RC59-Please complete Telephone/Mail section OR Online section)');
    SaveDiagnostic(RetNo,'RC59',20,'E-RC59-Please complete Telephone/Mail section OR Online section)');
   End;


   if FetchElmFNo(RetNo,FNo,11)=''  then  //paper filing it //20180627
   Begin
    if (FetchElm(RetNo,FNo,7)+ FetchElm(RetNo,FNo,8)>'')
     and (FetchElm(RetNo,FNo,3)='') then
       SaveDiagnostic(RetNo,'RC59',8,'E-RC59-Name of individual is required');
   end;


   if FetchElm(RetNo,FNo,12)+FetchElm(RetNo,FNo,17)='' then //20180824 CON
   Begin
    SaveDiagnostic(RetNo,'RC59',12,'E-RC59-Please complete Part 3');
    SaveDiagnostic(RetNo,'RC59',17,'E-RC59-Please complete Part 3');
   End;

   if FetchElm(RetNo,FNo,52)+FetchElm(RetNo,FNo,53)+FetchElm(RetNo,FNo,4)
      +FetchElm(RetNo,FNo,14)+FetchElm(RetNo,FNo,5)='' then //20180824 CON
   Begin
    SaveDiagnostic(RetNo,'RC59',52,'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59',53,'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59',4, 'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59',14,'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59',5, 'E-RC59-Please complete the Certification area');
   End;


   if (FetchElm(RetNo,FNo,6)>'') and (FetchElm(RetNo,FNo,9)='') then
      SaveDiagnostic(RetNo,'RC59',9,'E-RC59-Business number is required');
   if (FetchElm(RetNo,FNo,9)>'') and (FetchElm(RetNo,FNo,6)='') then
      SaveDiagnostic(RetNo,'RC59',6,'E-RC59-Name of firm is required');
   if ValidSin(FetchElm(RetNo,FNo,9))=False then
       SaveDiagnostic(RetNo,'RC59',9,'E-RC59-Business number is invalid');
   if (FetchElm(RetNo,FNo,12)>'') and (FetchElm(RetNo,FNo,17)>'') then
   Begin
      SaveDiagnostic(RetNo,'RC59',12,'E-RC59-Use Option 1 or Option 2');
      SaveDiagnostic(RetNo,'RC59',17,'E-RC59-Use Option 1 or Option 2');
   End;
  end;


  FNo:=GetFormNo('RC59X');  //20180803
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   if FetchElm(RetNo,FNo,20)+FetchElm(RetNo,FNo,21)+FetchElm(RetNo,FNo,27)+FetchElm(RetNo,FNo,35)='' then //20180824 CON
    SaveDiagnostic(RetNo,'RC59X',20,'E-RC59X-Enter at least one of the choices in Part 2');

   if FetchElm(RetNo,FNo,52)+FetchElm(RetNo,FNo,53)+FetchElm(RetNo,FNo,4)
      +FetchElm(RetNo,FNo,14)+FetchElm(RetNo,FNo,5)='' then //20180824 CON
   Begin
    SaveDiagnostic(RetNo,'RC59X',52,'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59X',53,'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59X',4, 'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59X',14,'E-RC59-Please complete the Certification area');
    SaveDiagnostic(RetNo,'RC59X',5, 'E-RC59-Please complete the Certification area');

   End;


   if (FetchElm(RetNo,FNo,21)>'')
   or (FetchElm(RetNo,FNo,35)>'') then
   begin
    if FetchElm(RetNo,FNo,10)+FetchElm(RetNo,FNo,57)+FetchElm(RetNo,FNo,7)
       +FetchElm(RetNo,FNo,3)+FetchElm(RetNo,FNo,48)+FetchElm(RetNo,FNo,6)='' then
    Begin
     SaveDiagnostic(RetNo,'RC59X',10,'E-RC59X-Enter at least one of the choices');
     SaveDiagnostic(RetNo,'RC59X',57,'E-RC59X-Enter at least one of the choices');
     SaveDiagnostic(RetNo,'RC59X',7,'E-RC59X-Enter at least one of the choices');
     SaveDiagnostic(RetNo,'RC59X',3,'E-RC59X-Enter at least one of the choices');
     SaveDiagnostic(RetNo,'RC59X',48,'E-RC59X-Enter at least one of the choices');
     SaveDiagnostic(RetNo,'RC59X',6,'E-RC59X-Enter at least one of the choices');
    end;
   end;

   if FetchElm(RetNo,FNo,27)>'' then
   begin
    if FetchElm(RetNo,FNo,28)='' then SaveDiagnostic(RetNo,'RC59X',28,'E-RC59X-Enter Program Identifier');
    if FetchElm(RetNo,FNo,34)='' then SaveDiagnostic(RetNo,'RC59X',34,'E-RC59X-Enter Reference Number i.e. 0001');
   end;


  if FetchElm(RetNo,FNo,35)>'' then
   begin
    if FetchElm(RetNo,FNo,41)='' then SaveDiagnostic(RetNo,'RC59X',41,'E-RC59X-Enter Program Identifier');
    if FetchElm(RetNo,FNo,42)='' then SaveDiagnostic(RetNo,'RC59X',42,'E-RC59X-Enter Reference Number i.e. 0001');
   end;

  end;
  //-----------------
  FNo:=GetFormNo('S3');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=4;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (FetchElmFNo(RetNo,FNo,i+1) ='1') then
    begin
     If (FetchElmFNo(RetNo,FNo,i+2) ='')
       then SaveDiagnostic(RetNo,'S3',i+2,'E-S3 Business No required');

     If (FetchElmFNo(RetNo,FNo,i+3) ='') then
      SaveDiagnostic(RetNo,'S3',i+3,'E-S3 Year end required');
    end;
    If EditDate(FetchElmFNo(RetNo,FNo,i+3),AppYearInt-5,AppYearInt+5) = false
       then SaveDiagnostic(RetNo,'S3',i+3,'E-S3 Invalid Date');

    If (FetchElmFNo(RetNo,FNo,i+2) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+2)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+2)))
     then SaveDiagnostic(RetNo,'S3',i+2,'E-S3 Business No invalid OR 9 digits invalid');
    Inc(i,9);
    Until i>85;
  end;

  {//20250918 why needed?
   If FetchElmFNo(RetNo,FNo,115)+FetchElmFNo(RetNo,FNo,116)='' then
   SaveDiagnostic(RetNo,'S3',115,'E-S3 Please select the applicable option in Part 2, box 100');
  }
  //---------------------------------
  FNo:=GetFormNo('S3'); //pg2
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   {Leave for later
   //20150707
   If (Vl(FetchElmFNo(RetNo,FNo,251))=0) and (GetGifiLine(RetNo,'3701')>0) then
   begin
    SaveDiagnostic(RetNo,'S3',251,'W-S3 Line 450 may be required (Gifi has divindends/line 3701');
   end;
   }
   i:=213;
   Repeat
    If (Vl(FetchElmFNo(RetNo,FNo,i)) >0 )
    or (FetchElmFNo(RetNo,FNo,i-3) >'')
    then   //payment made
    begin
     //nm
     If (FetchElmFNo(RetNo,FNo,i-3) ='') then
        SaveDiagnostic(RetNo,'S3',i-3,'E-S3 Corp. name required');
     //bn
     If (FetchElmFNo(RetNo,FNo,i-2) ='') then
        SaveDiagnostic(RetNo,'S3',i-2,'E-S3 Business number required');
     If (FetchElmFNo(RetNo,FNo,i-2) >'')
     and (FetchElmFNo(RetNo,FNo,i-2) <>'NR')    //20190612
     and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i-2))) then
       SaveDiagnostic(RetNo,'S3',i-2,'E-S3 Business number invalid or Enter NR');
     //yrend
      If (FetchElmFNo(RetNo,FNo,i-1) ='') then
        SaveDiagnostic(RetNo,'S3',i-1,'E-S3 Year End required');
    end;
    Inc(i,4);
    Until i>249;
    If Vl(FetchElmFNo(RetNo,FNo,252)) >
      ABS(Vl(FetchGifiElm(RetNo,'S100','3700')))+ABS(Vl(FetchGifiElm(RetNo,'S100','3701'))) then  //20160514
      //ABS(Vl(FetchGifiElm(RetNo,'GIFIBS#1','3700')))+ABS(Vl(FetchGifiElm(RetNo,'GIFIBS#1','3701'))) then
      SaveDiagnostic(RetNo,'S3',252,'W-Dividends paid should not exceed GIFI LN 3700 plus 3701');

   //20161113
   i:=9;  //field 240
   j:=119;  //field 241
   k:=100; //Apply Y/N
   Repeat
    If (Vl(FetchElmFNo(RetNo,FNo,i)) >0)
    and (Vl(FetchElmFNo(RetNo,FNo,j))=0)
    then   //payment made
      SaveDiagnostic(RetNo,'S3',j,'W-S3 Any dividends received before 2016?');
    If (Vl(FetchElmFNo(RetNo,FNo,i)) >0)
    and (FetchElmFNo(RetNo,FNo,K)='') then
      SaveDiagnostic(RetNo,'S3',K,'W-S3 If Subject to Part IV tax enter Y/N');
    Inc(i,9);
    Inc(j,1);
    Inc(k,1);
    Until i>90;
  end;

  //20230629
  FNo:=GetFormNo('S4WS');
  If Vl(FetchElmFNo(RetNo,FNo,658))+Vl(FetchElmFNo(RetNo,FNo,659))
     > Vl(FetchElmFNo(RetNo,FNo,656))+Vl(FetchElmFNo(RetNo,FNo,657))
  then
  Begin
   SaveDiagnostic(RetNo,'S4WS',658,'E-S4WS application of losses exceed losses available');
   SaveDiagnostic(RetNo,'S4WS',659,'E-S4WS application of losses exceed losses available');
  End;


  //---------------------------------------
  If Vl(FetchElm(RetNo,'S4',18))<0 then SaveDiagnostic(RetNo,'S4',18,'E-S4 Amount cannot be negative');
  If Vl(FetchElm(RetNo,'S4',101))<0 then SaveDiagnostic(RetNo,'S4',101,'E-S4 Amount cannot be negative'); //20100510

  FNo:=GetFormNo('S4'); //pg5
   i:=502;
   Repeat
     If Vl(FetchElmFNo(RetNo,FNo,i))<0 then SaveDiagnostic(RetNo,'S4',i,'E-S4 Amount cannot be negative');
    Inc(i,7);
   until i>544;

   i:=564;
   Repeat
     If Vl(FetchElmFNo(RetNo,FNo,i))<0 then SaveDiagnostic(RetNo,'S4',i,'E-S4 Amount cannot be negative');
    Inc(i,7);
   until i>627;

   i:=647;
   Repeat
     If Vl(FetchElmFNo(RetNo,FNo,i))<0 then
       SaveDiagnostic(RetNo,'S4',i,'E-S4 Amount cannot be negative');
    Inc(i,7);
   until i>710;

   If  (Vl(FetchElmFNo(RetNo,FNo,101))>0)  //20121216  If cap loss from prior year
   and (Vl(FetchElm(RetNo,'S6',685))>0)  //Gain this year
   and (Vl(FetchElmFNo(RetNo,FNo,108))=0)  //apply amount
   then
   Begin
    SaveDiagnostic(RetNo,'S4',108,'W-S4 You may want to apply prior Capital losse this year');
   end;
  //---------------------------------------
  //
  FNo:=GetFormNo('S5');

  If (Ret[RetNo].FrmHasData[GetFormNo('S5')])
  and (Ret[RetNo].Province = 'MJ') then
  begin
    If FetchElm(RetNo,'S5',104) = '' then
     SaveDiagnostic(RetNo,'S5',104,'E-S5-Multiple Jurisdictions. Regulation such as 402 needed and press Re-calc');  //20160709
  end;

  ElmNo:=436;If Not ValidCertificate(RetNo,FNo,ElmNo) then
       SaveDiagnostic(RetNo,'S5',ElmNo,'E-S5-Certificate number is incorrect');
  ElmNo:=454;If Not ValidCertificate(RetNo,FNo,ElmNo) then
       SaveDiagnostic(RetNo,'S5',ElmNo,'E-S5-Certificate number is incorrect');
 

  FNo:=GetFormNo('S5');
  ElmNo:=737;If Not ValidCertificate(RetNo,FNo,ElmNo) then SaveDiagnostic(RetNo,'S5',ElmNo,'E-S5-Certificate number is incorrect');
  //FNo:=GetFormNo('S5'); //20190924
  ElmNo:=531;If Not ValidCertificate(RetNo,FNo,ElmNo) then SaveDiagnostic(RetNo,'S5',ElmNo,'E-S5-Certificate number is incorrect');

  if (Vl(FetchElmFNo(RetNo,FNo,530))>0) and (FetchElmFNo(RetNo,FNo,531)='') then  //20190924
      SaveDiagnostic(RetNo,'S5',531,'W-S5-To claim the credit on line 556, the certificate must be filed with the T2');
  ElmNo:=812;If Not ValidCertificate(RetNo,FNo,ElmNo) then
       SaveDiagnostic(RetNo,'S5',ElmNo,'E-S5-Certificate number is incorrect');
  If Vl(FetchElmFNo(RetNo,FNo,821)) >0 then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,820)) =0 then
    SaveDiagnostic(RetNo,'S5',820,'E-S5-BC-L886. Please claim the credit or remove it');
  end;

  //--------------------------------
  FNo:=GetFormNo('S6');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    i:=9;j:=220;
    repeat
      If (FetchElmFNo(RetNo,FNo,i-3)>'')
      and (Numeric(FetchElmFNo(RetNo,FNo,i-3))=False)  //no of shares
      then
       SaveDiagnostic(RetNo,'S6',i-3,'E-S6 Number of shares must be all numbers');

      If (FetchElmFNo(RetNo,FNo,i) >'')  {aquisition date}
      or (Vl(FetchElmFNo(RetNo,FNo,i+1))>0) {proceeds}
      then
      begin
        If (FetchElmFNo(RetNo,FNo,j) ='')  {aquisition date}
           then SaveDiagnostic(RetNo,'S6',j,'W-S6 Disp date required');
      end;

      If (Vl(FetchElmFNo(RetNo,FNo,I+1)) <0)  {proceeds}
           then SaveDiagnostic(RetNo,'S6',i+1,'E-S6 Proceeds cannot be negative');

      If (Vl(FetchElmFNo(RetNo,FNo,I+3)) <0)  {proceeds}
           then SaveDiagnostic(RetNo,'S6',i+3,'E-S6 Outlays and expenses cannot be negative');

      If FetchElmFNo(RetNo,FNo,j) > '' then //disp date
      begin
       If DateWithinTaxYear(FetchElmFNo(RetNo,FNo,j),RetNo) = false
         then SaveDiagnostic(RetNo,'S6',j,'E-S6 Disp date not within tax year');
      end;
    Inc(i,8);
    Inc(j,1);
    until i>209;
  end;

  //--------------------------------

  FNo:=GetFormNo('S6'); //pg 2
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    i:=306;
    repeat
      If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6',i,'E-S6 Proceeds cannot be negative');
      If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6',i+2,'E-S6 Outlays and expenses cannot be negative');
      //20130125
      //If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6_2',i,'E-S6 Proceeds cannot be negative');
      //If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6_2',i+2,'E-S6 Outlays and expenses cannot be negative');
    Inc(i,9);
    until i>369;
    i:=380;
    repeat
      If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6',i,'E-S6 Proceeds cannot be negative');
      If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6',i+2,'E-S6 Outlays and expenses cannot be negative');
      //20130125
     // If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6_2',i,'E-S6 Proceeds cannot be negative');
     // If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6_2',i+2,'E-S6 Outlays and expenses cannot be negative');
    Inc(i,7);
    until i>415;

    i:=425;
    repeat
      If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6',i,'E-S6 Proceeds cannot be negative');
      If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6',i+2,'E-S6 Outlays and expenses cannot be negative');
      //20130125
      //If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6_2',i,'E-S6 Proceeds cannot be negative');
      //If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6_2',i+2,'E-S6 Outlays and expenses cannot be negative');
    Inc(i,8);
    until i>437;

  end;

  //-----------------------------
  FNo:=GetFormNo('S6');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    i:=507;
    repeat
      If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6',i,'E-S6 Proceeds cannot be negative');
      If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6',i+2,'E-S6 Outlays and expenses cannot be negative');
    Inc(i,7);
    until i>521;
  end;

  //-----------------------------
  FNo:=GetFormNo('S6');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    i:=607;
    repeat
      If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S6',i,'E-S6 Proceeds cannot be negative');
      If Vl(FetchElmFNo(RetNo,FNo,i+1)) <0 then SaveDiagnostic(RetNo,'S6',i+1,'E-S6 Outlays and expenses cannot be negative');
      If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S6',i+2,'E-S6 Outlays and expenses cannot be negative');
    Inc(i,7);
    until i>663;
  end;
  {Gaps}
  If Ret[RetNo].FrmHasData[GetFormNo('S6')] then
  begin
   If GapsInTable(RetNo,'S6',6,206,8) then
     SaveDiagnostic(RetNo,'S6',6,'E-S6 Gaps in lines not allowed');
  end;

  (* remove it ..20279714cz
 //  S8
  if TotMultiple(RetNo,'S8',93)>1500000  then  //20221017
     SaveDiagnostic(RetNo,'S8#'+IntToStr(1),93,'E-S8-Sum of col 238 of all S8 forms exceeds 1.5 million. Remove the Autofill/Enter manually') ;
 *)

  for k:=1 to 10 do //20230517 from 3 to 10
  Begin
   FNo:=GetFormNo('S8#'+IntToStr(k));
   If Ret[RetNo].FrmHasData[FNo] then
     with Ret[RetNo].Frm[FNo] do
     begin
       //col 236
       if (Tv[93]>0) and (Tv[249]>0) then
       begin
           if Tv[77]=0  then  SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'W-S8-Complete Column 11 if applicable') ;
       end;
       //20260707 Alex >>>
       kk:= 6;
       J1:= 233;
       J2:= 243;
       J3:= 323; //lease years //jz//20260713 - was wrong elm  //313; //20260712cz lease years column
       J4:= 373;  //half year indicator  //20260718
       J5:= 293; //property type
       HalfYearNdx:=373;
       JCapitalCost := 313;
       repeat
         { questionable not by profile
          //20260718
          If (FetchElm(RetNo, FNo, j4)>'')  //X on half year indicaoer
          and (ExemptClassesForFirstYearRule(FetchElm(RetNo, FNo, kk))=True)  //class
          then SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), j4, 'E-S8-Half year rule is not applicable to this CCA class');
          }

          if not FetchElm(RetNo, FNo, kk).IsEmpty() and
             FetchElm(RetNo, FNo, J1).IsEmpty()     and
             (Vl(FetchElmFNo(RetNo,FNo,kk+2))>0) //20260707CZ There is acquisition
          then SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), j1, 'E-S8-Complete column Date acquired');

          if not FetchElm(RetNo, FNo, kk).IsEmpty() and
             FetchElm(RetNo, FNo, J2).IsEmpty()     and
             (Vl(FetchElmFNo(RetNo,FNo,kk+2))>0) //20260707CZ There is acquisition
          then SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), j2, 'E-S8-Complete column Date available for use');

          //20260712
          if  (trim(FetchElmFNo(RetNo, FNo, kk))='13') and  //jz//20260713 - needed trim as there are spaces
              (Vl(FetchElmFNo(RetNo, FNo, J3))=0)      //is leashold but no lease years entered  //20260718
          then SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), j3, 'E-S8-Complete the term of the Lease in years)');

          //20260719cz
          if FetchElmFNo(RetNo,Fno,kk)='10.1' then  //for call 10.1
          Begin
           if (Vl(FetchElmFNo(RetNo,Fno,kk+1))>0)   //ucc
           And (Vl(FetchElmFNo(RetNo,Fno,kk+2))>0)   // additions column
           then SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), kk+2, 'E-S8-Enter the 10.1 addition on its own dedicated line');
          End;

          //20260712
          if  (trim(FetchElmFNo(RetNo, FNo, kk))='13') and  //jz//20260713 - needed trim as there are spaces
              (FetchElmFNo(RetNo, FNo, J3)='')              //is leashold but no lease years entered
          then SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), j3, 'E-S8-Complete the term of the Lease in years)');

         //20260816CZ
         if (trim(FetchElmFNo(RetNo, FNo, kk))='13') then
         Begin
          If Vl(FetchElmFNo(RetNo, FNo, JCapitalCost))=0 then
           SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), jCapitalCost,
               'E-S8-Enter Capital Cost amount');

          If Vl(FetchElmFNo(RetNo, FNo, KK+1))=0 then
           SaveDiagnostic(RetNo, 'S8#' + IntToStr(K), KK+1,
               'W-S8-Enter any UCC amount');
         end;
           //20260718cz
          if  (trim(FetchElmFNo(RetNo, FNo, HalfYearNdx))>'')   //Half year indcatorclicked
             and ((FetchElmFNo(RetNo, FNo, J5)='AIIP') Or (FetchElmFNo(RetNo, FNo, J5)='RIIP')
             Or (LeftStr(FetchElmFNo(RetNo, FNo, J5),5)='AIIPZ')
             Or (LeftStr(FetchElmFNo(RetNo, FNo, J5),5)='RIIPZ'))
          then SaveDiagnostic(RetNo, 'S8#' + IntToStr(k), j4,
               'E-S8-Half year rule not allowed for AIIP, and RIIP properties'); //AIIPZEV or RIIPZEV properties'); //20260718
         inc(kk, 22);
         inc(j1, 1);
         inc(j2, 1);
         inc(j3, 1);
         inc(j4, 1); //20260718
         inc(j5, 1); //20260718
         inc(jCapitalCost, 1); //20260816CZ
         inc(HalfYearNDX,1); //20260718
       until (kk > 204);
       //20260707 Alex <<<
     end;

 //20230612
   if (Vl(FetchElm(RetNo,FNo,530))>0) and (Vl(FetchElm(RetNo,FNo,530))<100) then
   begin
    If Vl(FetchElm(RetNo,FNo,93))> Round(Vl(FetchElm(RetNo,FNo,600))) then   //tot Column 12 greater than Line 120 allocated //jz 20240529 changed from 29 to 600, added round
    begin
     SaveDiagnostic(RetNo,'S8#'+IntToStr(k),93,'E-S8-Total immediate expensing exceeds the limit of '
       +FormatFloat('###,###,###.##',Round(Vl(FetchElm(RetNo,FNo,600))))+', reduce above rows') ; //jz 20240529 changed from 29 to 600, added round
    end;
   end;   //20230619 Con


   If Ret[RetNo].FrmHasData[FNo] then
   begin
    i:=6;
    j:=236;
    j1:=371;
    J2:=356;  //aiip flag
    J3:=252;
    J4:=15; //halh year Y or N
    repeat


     //20190705
       if FetchElmFNo(RetNo,FNo,i)>'' then  //cls
       Begin
        {//20250612
        if FetchElmFNo(RetNo,FNo,i)='10.1' then  //leashold  //20210721
        Begin  //20250512
         If Vl(FetchElmFNo(RetNo,FNo,i+2))>34000  then   //20240218 //20240325   i+2=Aquisition cost
           SaveDiagnostic(RetNo,'S8#'+IntToStr(k),i+2,'W-S8-The max on Column 203 for the curreny year should be $36,000 in 2023, $37,000 in 2024,...) plus GST/HST less input credits') ;
        End;
        }

        if FetchElmFNo(RetNo,FNo,i)='13' then  //leashold  //20210721
        begin
         If UpperCase(FetchElmFNo(RetNo,FNo,j4))='Y'  then
            SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j4,'W-S8-Half-year rule should be NO for Leasehold class 13') ;
        end;

        s:=FetchElmFNo(RetNo,FNo,j); //purch date s/b yyyy/mm/dd
        //20190710
        //20260515 Alex >>>
        {if AllTrim(s)='' then
        Begin
         if FetchElmFNo(RetNo,FNo,i)<>'10.1' then  //20190710
           SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'W-S8-Purchase date assumed prior to Nov 21,2018, or enter actual date') ;
        End;
           // so no Enter the purchase date in the format: yyyy/mm/dd');
        If AllTrim(s)>'' then  //20190706
        Begin
          If EditDate(LeftStr(FetchElmFNo(RetNo,FNo,j),10),AppYearInt-50,AppYearInt+50) = false then
           SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Purchase date is invalid, it must be in format yyyy/mm/dd');
        End;}
        //20260515 Alex <<<
       End;
     //-----------  all forced to enter date purchases
      //20190622
      if AllTrim(FetchElmFNo(RetNo,FNo,i))='10.1' then
      begin
        s:=FetchElmFNo(RetNo,FNo,j); //purch date s/b yyyy/mm/dd
        if AllTrim(s)='' then  SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'E-S8-Class 10.1: Enter the purchase date in the format: yyyy/mm/dd');

       //If (s>'2018/11/20')
       If Vl(FetchElmFNo(RetNo,FNo,i+2))>0 //additions
       then //20190622
       begin
        if GetTaxationYearStartYYYY(RetNo)=2023 then
        Begin
         if Vl(FetchElmFNo(RetNo,FNo,i+2))<36000 then  //20240217
          SaveDiagnostic(RetNo,'S8#'+IntToStr(k),I+2,'W-S8 Class 10.1 s/b at least $36,000 and on its own line'); //20190707 //20250512 warning
        end;
        if GetTaxationYearStartYYYY(RetNo)=2024 then
        Begin
         if Vl(FetchElmFNo(RetNo,FNo,i+2))<37000 then  //20240217
          SaveDiagnostic(RetNo,'S8#'+IntToStr(k),I+2,'W-S8 Class 10.1 s/b at least $37,000 and on its own line'); //20190707 //20250512 warning
        end;
       if GetTaxationYearStartYYYY(RetNo)=2025 then
        Begin
         if Vl(FetchElmFNo(RetNo,FNo,i+2))<38000 then  //20240217
          SaveDiagnostic(RetNo,'S8#'+IntToStr(k),I+2,'W-S8 Class 10.1 s/b at least $38,000 and on its own line'); //20190707 //20250512 warning
        end;

       end;
      end;

      //---------------------------
     (* 20260607
      if LeaseHold(AllTrim(FetchElmFNo(RetNo,FNo,i))) then
      //if AllTrim(FetchElmFNo(RetNo,FNo,i))='13' then
      begin
       if Vl(FetchElmFNo(RetNo,FNo,j1))=0 then  //20190613
        SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j1,'E-S8 Lease/Franchise Original Cost must be entered'); //20220913 //20190806

       s:=FetchElmFNo(RetNo,FNo,j); //it should be yyyy/mm/dd-yyyy/mm/dd
       if AllTrim(s)='' then
         SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'E-S8 Lease/Franchise From-To dates must be in format: yyyy/mm/dd-yyyy/mm/dd');//Temp 20220914 //20190806
       If EditDate(LeftStr(FetchElmFNo(RetNo,FNo,j),10),AppYearInt-50,AppYearInt+50) = false then
        SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Lease/Franchise start date is invalid (Dates Format: yyyy/mm/dd-yyyy/mm/dd)');

       If EditDate(MidStr(FetchElmFNo(RetNo,FNo,j),12,10),AppYearInt-50,AppYearInt+50) = false then
        SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Lease/Franchise end date is invalid (Dates Format: yyyy/mm/dd-yyyy/mm/dd)');

       If LeftStr(FetchElmFNo(RetNo,FNo,j),10) >= MidStr(FetchElmFNo(RetNo,FNo,j),12,10) then
        SaveDiagnostic(RetNo,'S8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Lease/Franchise End date less than Start date (Dates Format: yyyy/mm/dd-yyyy/mm/dd)');
      end;
     *)
      //check for gaps   //20190831
      //20260515 Alex >>>
      {If (i<=166) and (FetchElmFNo(RetNo,FNo,i)>'') and (FetchElmFNo(RetNo,FNo,i+16)='') and (FetchElmFNo(RetNo,FNo,i+32)>'') then
      Begin
       SaveDiagnostic(RetNo,'S8#'+IntToStr(k),i+16,'E-S8'+IntToStr(k)+' You cannot leave blank lines in between. Please complete lines in sequence.');
      End;}
      //20260515 Alex <<<

    Inc(i,16);
    Inc(j,1);
    Inc(j1,1);
    Inc(j2,1);
    Inc(j3,1);
    Inc(j4,16); //20210721
    until i>198;
   end;
  end;

 (* //20260718
  //------------------
  FNo:=GetFormNo('S8LH');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    i:=1;
    j:=151; //ndx  First yr
    repeat
      If FetchElmFNo(RetNo,FNo,i)>'' then //date entered
      begin
       If FetchElmFNo(RetNo,FNo,j)='' then SaveDiagnostic(RetNo,'S8LH',j,'E-S8LH Enter Y/N in first year box');
      end;
    Inc(i,11);
    until i>122;
  end;
*)
  //--------------------------------
  //20250611
  for j:=1 to 5 do
  Begin
   FNo:=GetFormNO('S78#'+AllTrim(IntToStr(j)));
   If Ret[RetNo].FrmHasData[FNo] then
   begin
     i:=9;
     repeat
       If (FetchElmFNo(RetNo,FNo,i)>'')
       and (FetchElmFNo(RetNo,FNo,i+1)='')
       then
        SaveDiagnostic(RetNo,'S78#'+AllTrim(IntToStr(j)),i+1,'E-S78-Please select CCUS Description');
     Inc(i,14);
     until i>135;
   end;
  End;

  //20170726
  FNo:=GetFormNo('GROUPINFO');
  if FetchElmFNo(RetNo,FNo,4)>'' then  //corp name
  begin
   If FetchElmFNo(RetNo,FNo,7)='' then
    SaveDiagnostic(RetNo,'GROUPINFO',7,'E-GroupInfo-Enter Relationship Code on S9');
  end;

 FNo:=GetFormNo('S9');
 //20170726
 If Ret[RetNo].FrmHasData[FNo] then
 begin
   if UpperCase(FetchElmFNo(RetNo,FNo,184))='Y' then
   Begin
    if (Vl(FetchElmFNo(RetNo,FNo,186))<1)
    or (Vl(FetchElmFNo(RetNo,FNo,186))>4) then
      SaveDiagnostic(RetNo,'S9',186,'E-S9 Enter Relationship Code');
   End;

   i:=4;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and ((FetchElmFNo(RetNo,FNo,i+2) ='') {bus no}
          or (FetchElmFNo(RetNo,FNo,i+3) =''))
          then SaveDiagnostic(RetNo,'S9',i,'E-S9 Missing data for this Corp.');

    If (FetchElmFNo(RetNo,FNo,i+2) >'') then
    begin
      If Length(FetchElmFNo(RetNo,FNo,i+2))>0 then
      begin
       If (Length(FetchElmFNo(RetNo,FNo,i+2)) <>15)
       and (UpperCase(FetchElmFNo(RetNo,FNo,i+2)) <>'NR') then
         SaveDiagnostic(RetNo,'S9',i+2,'E-S9 Business No invalid OR 9 digits wrong');
       end;
    end;

     If Vl(FetchElmFNo(RetNo,FNo,i+4))>0 then //20121205 coomon shares
     begin
         If Vl(FetchElmFNo(RetNo,FNo,i+5))=0 then
          SaveDiagnostic(RetNo,'S9',i+5,'E-S9 % of common shares is required');
     end;

     If Vl(FetchElmFNo(RetNo,FNo,i+6))>0 then //20121205 //preferred shares
     begin
         If Vl(FetchElmFNo(RetNo,FNo,i+7))=0 then
          SaveDiagnostic(RetNo,'S9',i+7,'E-S9 % of Preferred shares is required');
     end;

    If Vl(FetchElmFNo(RetNo,FNo,i+5)) >0 then  //20111102
    begin
      If Vl(FetchElmFNo(RetNo,FNo,i+8))=0 then SaveDiagnostic(RetNo,'S9',i+8,'W-S9 Book value not entered');
    end;

   Inc(i,9);
   until i>175;
 end;  {S9}

//20170909 Igor>>>
 FNo:=GetFormNo('S10');   //20170730
 If Vl(FetchElmFNo(RetNo,FNo,24))<0 then SaveDiagnostic(RetNo,'S10',24,'E-S10 Amount cannot be negative'); //20100510

 x:=Vl(FetchElmFNo(RetNo,FNo,69));
 Begin
  //20171127
  if X>0 then
    SaveDiagnostic(RetNo,'S8#1',6,'W-S8-Class 14.1 Ensure amount $'+FormatFloat('###,###,###',x)+' is included in class 14.1 column 201');
  if x<0 then
    SaveDiagnostic(RetNo,'S8#1',6,'W-S8-Class 14.1 Ensure amount $'+FormatFloat('###,###,###',x)+' is included in class 14.1 column 213');

  x:=Vl(FetchElmFNo(RetNo,FNo,77));
  if X<>0 then
   SaveDiagnostic(RetNo,'S8',8,'W-S8-Class 14.1 Ensure amount $'+FormatFloat('###,###,###',x)+' is on S8 col 203 as per Box 470 of S10');

  x:=Vl(FetchElmFNo(RetNo,FNo,86));
   if Vl(FetchElm(RetNo,'S6',421)) < x then
    SaveDiagnostic(RetNo,'S6',421,'W-S6-Ensure amount $'+FormatFloat('###,###,###',x)+' is on col 420 as shown in Box 480 of S10');

  //------------------
  if IsClass141Claimed(RetNo) = False then
  Begin
   if X>0 then
    SaveDiagnostic(RetNo,'S8#1',6,'E-S8-Class 14.1 undepreciated amount $'+FormatFloat('###,###,###',x)+' should be on S8 col 201 as per Box 445 of S10')
   Else
   if x<0 then
    SaveDiagnostic(RetNo,'S8#1',6,'E-S8-Class 14.1 Recapture amount $'+FormatFloat('###,###,###',x)+' should be on S8 col 213 as per Box 445 of S10')
  End;
 End;

 //-----------------------
  //NOT KNOWN what it is FNO of what?
  {20171203
  If (FetchElmFNo(RetNo,FNo,4) >'')
  and (FetchElm(RetNo,'S23',10) ='')  then
    SaveDiagnostic(RetNo,'S23',10,'W-S23-Associated? See Schedule 9. If Yes complete S23');
   }
  //-----------------------------------------------------------------

  If GetTaxationYearEnd(RetNo) >'2008/12/01' then
  begin
  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = 'X')
  and (Not Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
    SaveDiagnostic(RetNo,'T2',63,'E-Schedule 91 not completed (exempt under treaty)');

  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = '')
  and (Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
    SaveDiagnostic(RetNo,'T2',63,'E-Exempt under treaty (S91). Enter X on page 1');
  end;

  If GetTaxationYearEnd(RetNo) <'2009/01/01' then
  begin
  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = 'X')
  and (Not Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
    SaveDiagnostic(RetNo,'T2',63,'E-Schedule 91 not completed (exempt under treaty)');


  If (UpperCase(FetchElmFNo(RetNo,Page1FNo,63)) = '')
  and (Ret[RetNo].FrmHasData[GetFormNo('S91')]) then
  //and (Ret[RetNo].FrmHasData[GetFormNo('S91_1')]) then  //20130125
    SaveDiagnostic(RetNo,'T2',63,'E-Exempt under treaty (S91). Enter X on page 1');
  end;


//20170909 Igor<<<
 //------------------
  FNo:=GetFormNo('S11');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=8;
   Repeat
    If (Vl(FetchElmFNo(RetNo,FNo,i)) >0)
    and (FetchElmFNo(RetNo,FNo,i+1)+FetchElmFNo(RetNo,FNo,i+2) ='') then
      SaveDiagnostic(RetNo,'S11',i+1,'E-S11 Line 550 needs to be completed');
    Inc(i,7);
   Until i>92;
  end;
 //------------------
  FNo:=GetFormNo('S13');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=5;
   Repeat
    If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S13',i,'E-S13 Amount cannot be negative');
    If Vl(FetchElmFNo(RetNo,FNo,i+1)) <0 then SaveDiagnostic(RetNo,'S13',i+1,'E-S13 Amount cannot be negative');
    If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0 then SaveDiagnostic(RetNo,'S13',i+2,'E-S13 Amount cannot be negative');
    Inc(i,4);
   Until i>25;

   For i:=31 to 51 do
   begin
    If Vl(FetchElmFNo(RetNo,FNo,i)) <0 then SaveDiagnostic(RetNo,'S13',i,'E-S13 Amount cannot be negative');
   end;
  end;

 //------------------
  FNo:=GetFormNo('S19');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    If Vl(FetchElmFNo(RetNo,FNo,56)) >100 then SaveDiagnostic(RetNo,'S19',56,'E-S19 Total % exceeds 100');
    If Vl(FetchElmFNo(RetNo,FNo,5))+ Vl(FetchElmFNo(RetNo,FNo,7))>0 then  //20121027
    Begin
     If Vl(FetchElmFNo(RetNo,FNo,56))=0 then
      SaveDiagnostic(RetNo,'S19',56,'E-S19 Total on line 300 is required');
    end;
  end;

   //------------------
  FNo:=GetFormNo('S23');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If (FetchElmFNo(RetNo,FNo,2) >'')
   and ((Numeric(FetchElmFNo(RetNo,FNo,2))=False)
     or (Length(FetchElmFNo(RetNo,FNo,2))<>4))
    then
     SaveDiagnostic(RetNo,'S23',2,'E-S23 Year must be 4 digits');
    If Vl(FetchElmFNo(RetNo,FNo,126)) >0 then
    begin
     If ((GetTaxationYearEndYYYY(RetNo)=2004) and (Vl(FetchElmFNo(RetNo,FNo,126))>250000))
     or ((GetTaxationYearEndYYYY(RetNo)=2005) and (Vl(FetchElmFNo(RetNo,FNo,126))>300000))
     or ((GetTaxationYearEndYYYY(RetNo)=2006) and (Vl(FetchElmFNo(RetNo,FNo,126))>300000))
     or ((GetTaxationYearEndYYYY(RetNo)=2007) and (Vl(FetchElmFNo(RetNo,FNo,126))>400000))
     then SaveDiagnostic(RetNo,'S23',126,'W-S23 Business Limit exceeds maximum');
    end;
  end;

  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=5;
   j:=9;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'') then
    begin
     If FetchElmFNo(RetNo,FNo,i+1) ='' then SaveDiagnostic(RetNo,'S23',i+1,'E-S23 Business no missing');
     If FetchElmFNo(RetNo,FNo,i+2) ='' then SaveDiagnostic(RetNo,'S23',i+2,'E-S23 Association code missing');
     If (vl(FetchElmFNo(RetNo,FNo,i+4))>0) and (vl(FetchElmFNo(RetNo,FNo,i+3))=0)  //20120503
        then SaveDiagnostic(RetNo,'S23',i+3,'W-S23 Enter Business Limit');
    end;

    If (FetchElmFNo(RetNo,FNo,i+1) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
     then SaveDiagnostic(RetNo,'S23',i+1,'E-S23 Business No invalid OR 9 digits wrong');

   If (Vl(FetchElmFNo(RetNo,FNo,i+3)) >0)
   and ((FetchElmFNo(RetNo,FNo,i) ='')
   or (FetchElmFNo(RetNo,FNo,i+1) ='')
   or (FetchElmFNo(RetNo,FNo,i+2) ='')) then
     SaveDiagnostic(RetNo,'S23',i,'E-S23 Lines 100, 200 and 300 not completed');
   If (FetchElmFNo(RetNo,FNo,i) >'')
    and (FetchElmFNo(RetNo,FNo,i+2) ='1')
    and (Vl(FetchElmFNo(RetNo,FNo,j)) =0)  //%
     then SaveDiagnostic(RetNo,'S23',j,'W-S23 Allocation % may be missing');

   Inc(i,6);
   Inc(j,6);
   until i>119;
  end;  {S23}

  // -------------------------------------
  FNo:=GetFormNo('S29');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    i:=4;
    Repeat
     If FetchElmFNo(RetNo,FNo,i) >'' then
     begin
      If (FetchElmFNo(RetNo,FNo,i+1) ='')
      or (FetchElmFNo(RetNo,FNo,i+2) ='')
      or (FetchElmFNo(RetNo,FNo,i+5) ='')
      or (FetchElmFNo(RetNo,FNo,i+6) ='')
      or (FetchElmFNo(RetNo,FNo,i+7) ='') then
       SaveDiagnostic(RetNo,'S29',i,'E-S29 is incomplete incomplete');
     end;
     Inc(i,8);
    until i>76;
  end;
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    i:=4;
    Repeat
     If FetchElmFNo(RetNo,FNo,i) >'' then
     begin
      If (FetchElmFNo(RetNo,FNo,i+4) ='')   //country
      and (FetchElmFNo(RetNo,FNo,i+3) ='') then //prov
       SaveDiagnostic(RetNo,'S29',i+1,'E-S29 address is incomplete');
     end;
     Inc(i,8);
    until i>76;
  end; //s29

  //s48
  For j:=1 to 3 do
  begin
   FNo:=GetFormNO('S48#'+AllTrim(IntToStr(j)));
   If ((Fno>0) and (FetchElmFNo(RetNo,FNo,26)>'')) then
    begin
     If Length(FetchElmFNo(RetNo,FNo,26))<>9 then
      SaveDiagnostic(RetNo,'S48#'+AllTrim(IntToStr(j)),26,'E-S48#'+IntToStr(j)+' Certificate must me 9 characters (no dashes)');
    end;
  End;

    //---------------------------------------------
  FNo:=GetFormNo('S50');
  TRY
  If Ret[RetNo].FrmHasData[FNo] = false then
    SaveDiagnostic(RetNo,'S50',4,'W-S50-?Any shareholder holds 10% or more');

  If Ret[RetNo].FrmHasData[FNo] then
  begin
  i:=4;
  k:=132;
  repeat
   If (FetchElmFNo(RetNo,FNo,i) >'') then
   begin
    If (FetchElmFNo(RetNo,FNo,i+1)+FetchElm(RetNo,'S50',i+2)
       +FetchElmFNo(RetNo,FNo,k) ='')
    then SaveDiagnostic(RetNo,'S50',i+1,'E-S50 Business No, SIN, or Trust No required');
    If ((FetchElmFNo(RetNo,FNo,i+1)>'')
       and (FetchElmFNo(RetNo,FNo,i+2)>''))
       or
       ((FetchElmFNo(RetNo,FNo,i+1)>'')
       and (FetchElmFNo(RetNo,FNo,k)>''))
       or
       ((FetchElmFNo(RetNo,FNo,i+2)>'')
       and (FetchElmFNo(RetNo,FNo,k)>''))
       then SaveDiagnostic(RetNo,'S50',i+1,'E-S50 Enter only Business No,SIN,or Trust No');
   end;
   If FetchElmFNo(RetNo,FNo,k)>'' then
   begin
    If (Length(FetchElmFNo(RetNo,FNo,k))= 2) then
    begin
     If UpperCase(FetchElmFNo(RetNo,FNo,k))<> 'NA'
     then SaveDiagnostic(RetNo,'S50',k,'E-S50 Enter valid number or NA')
    end
    else //trust no
    begin
     If IsValidTrustNo(FetchElmFNo(RetNo,FNo,k))= false then
      SaveDiagnostic(RetNo,'S50',k,'E-S50 Invalid Trust No');
    end;
   end;
   If (FetchElmFNo(RetNo,FNo,i) >'')
   and (Vl(FetchElmFNo(RetNo,FNo,i+3))+Vl(FetchElmFNo(RetNo,FNo,i+4)) =0)
   then
     SaveDiagnostic(RetNo,'S50',i+3,'E-S50 Common and/or prefered % required');

   If (FetchElmFNo(RetNo,FNo,i+1) >'') then
    begin
      If Length(FetchElmFNo(RetNo,FNo,i+1))>0 then
      begin
       If (Length(FetchElmFNo(RetNo,FNo,i+1)) <>15)
       and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
       and (ValidSin(LeftStr(FetchElmFNo(RetNo,FNo,i+1),9)) = False)
        then
         SaveDiagnostic(RetNo,'S50',i+1,'E-S50 Business No invalid OR 9 digits wrong');
       end;
     end;

   If (FetchElmFNo(RetNo,FNo,i+1) >'')
   and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
   then
   begin
   If (not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
   and (not ValidPartnershipNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))   //20210516
   then
      SaveDiagnostic(RetNo,'S50',i+1,'E-S50 Business No is invalid or not 15 characters');
   end;

   If Length(FetchElmFNo(RetNo,FNo,i+2)) >0 then
   begin
    If (Length(FetchElmFNo(RetNo,FNo,i+2)) >0)
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+2)) <>'NA')
    and (ValidSin(FetchElmFNo(RetNo,FNo,i+2)) = False)
    then
     SaveDiagnostic(RetNo,'S50',i+2,'E-S50 SIN is invalid');
   end;

   If (Length(FetchElmFNo(RetNo,FNo,i+3)) >0)
   and (Vl(FetchElmFNo(RetNo,FNo,i+3)) >100)
   then
     SaveDiagnostic(RetNo,'S50',i+3,'E-S50 exceeds 100%');

   If (Length(FetchElmFNo(RetNo,FNo,i+4)) >0)
   and (Vl(FetchElmFNo(RetNo,FNo,i+4)) >100)
   then
     SaveDiagnostic(RetNo,'S50',i+4,'E-S50 exceeds 100%');

   Inc(i,5);
   Inc(k,1);
  until i>124;

  If Ret[RetNo].FrmHasData[FNo] = True then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,130)) >100
      then SaveDiagnostic(RetNo,'S50',130,'E-S50 total % exceeds 100%');
   If Vl(FetchElmFNo(RetNo,FNo,131)) >100
      then SaveDiagnostic(RetNo,'S50',131,'E-S50 total % exceeds 100%');
  end;
 end; {S50}
 EXCEPT
 END;

  Fno:=GetFormNo('S39');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=4;
   Repeat
    If Vl(FetchElmFNo(RetNo,FNo,i+2)) <0
       then SaveDiagnostic(RetNo,'S39',i+2,'E-S39 Allocation must be positive');

    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (FetchElmFNo(RetNo,FNo,i+1) ='')
     then SaveDiagnostic(RetNo,'S39',i+1,'E-S39 Business No required');

    If (FetchElmFNo(RetNo,FNo,i+1) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
     then SaveDiagnostic(RetNo,'S39',i+1,'E-S39 Business No invalid OR 9 digits wrong');
    Inc(i,4);
    Until i>92;
    If Vl(FetchElmFNo(RetNo,FNo,99)) >1000000000 then
      SaveDiagnostic(RetNo,'S39',99,'E-S39 Total Capital deduction exceeds maximum');
  end;

  FNo:=GetFormNo('S41');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=5;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (FetchElmFNo(RetNo,FNo,i+1) ='')
     then SaveDiagnostic(RetNo,'S41',i+1,'E-S41 Business No required');

    If (FetchElmFNo(RetNo,FNo,i+1) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
     then SaveDiagnostic(RetNo,'S41',i+1,'E-S41 Business No invalid OR 9 digits wrong');
    Inc(i,4);
    Until i>73;
  end;

  FNo:=GetFormNo('S44');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=4;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (FetchElmFNo(RetNo,FNo,i+1) ='')
     then SaveDiagnostic(RetNo,'S44',i+1,'E-S44 Business No required');

    If (FetchElmFNo(RetNo,FNo,i+1) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
     then SaveDiagnostic(RetNo,'S44',i+1,'E-S44 Business No invalid OR 9 digits wrong');
    Inc(i,3);
    Until i>73;
  end;

  Fno:=GetFormNo('S45');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=3;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (FetchElmFNo(RetNo,FNo,i+1) ='')
     then SaveDiagnostic(RetNo,'S45',i+1,'E-S45 Business No required');

    If (FetchElmFNo(RetNo,FNo,i+1) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
     then SaveDiagnostic(RetNo,'S45',i+1,'E-S45 Business No invalid OR 9 digits wrong');
    Inc(i,3);
    Until i>6;

    i:=6;
    Repeat
     If (FetchElmFNo(RetNo,FNo,i) >'')
     and (FetchElmFNo(RetNo,FNo,i+1) ='')
     then SaveDiagnostic(RetNo,'S45',i+1,'E-S45 Business No required');
     If (FetchElmFNo(RetNo,FNo,i+1) >'')
     and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
     and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
     then SaveDiagnostic(RetNo,'S45',i+1,'E-S45 Business No invalid OR 9 digits wrong');
     Inc(i,4);
    until i>42;
    If Vl(FetchElmFNo(RetNo,FNo,46)) > Vl(FetchElmFNo(RetNo,FNo,2)) then
      SaveDiagnostic(RetNo,'S45',46,'E-S45 Total transferred exceeds line [105]');
  end;


  FNo:=GetFormNo('S49');
  If Vl(FetchElmFNo(RetNo,FNo,127))>3000000 then
      SaveDiagnostic(RetNo,'S49',127,'E-S49 Expenditure limit must not exceed $3,000,000');
  i:=5;
  Repeat
    If (FetchElmFNo(RetNo,FNo,i) >'')
    and (FetchElmFNo(RetNo,FNo,i+1) ='')
     then SaveDiagnostic(RetNo,'S49',i+1,'E-S49 Business No required');

    If (FetchElmFNo(RetNo,FNo,i+1) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i+1)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)))
     then SaveDiagnostic(RetNo,'S49',i+1,'E-S49 Business No invalid OR 9 digits wrong');
    Inc(i,6);
  Until i>119;

  If (IsNonResidentCorp(RetNo)) and
    (Ret[RetNo].FrmHasData[GetFormNo('S97')]=False) then
     SaveDiagnostic(RetNo,'S97',4,'W-S97 Non-resident corp. Schedule 97 missing');


  If Ret[RetNo].FrmHasData[GetFormNo('S53')] then
  begin
   If (Vl(FetchElm(RetNo,'S3',95))>0)
   and (Vl(FetchElm(RetNo,'S53',13))=0) then
     SaveDiagnostic(RetNo,'S53',13,'W-S53 Any eligible dividends received? (See S3)');
   If (UpperCase(FetchElm(RetNo,'S53ADD06',4)) <> 'Y')
   and (DateWithinTaxYear('2006/01/01',RetNo))
   then
     SaveDiagnostic(RetNo,'S53ADD06',4,'W-S53ADD06: Complete the GRIP additions for 2006');
  end;


 //-------------------------------
  //20200607
  FNo:=GetFormNo('S58#1');
  If FetchElmFNo(RetNo,FNo,12) >'' then  //Q number
  Begin
   if LeftStr(FetchElmFNo(RetNo,FNo,12),1)<>'Q' then
     SaveDiagnostic(RetNo,'S58#1',12,'E-S58 The first character must be the letter Q');
  End;

  i:=29;
  Begin
   Repeat
     If FetchElmFNo(RetNo,FNo,i) >'' then  //sin
     Begin
     If ValidSin(FetchElmFNo(RetNo,FNo,i)) = False
      then
        SaveDiagnostic(RetNo,'S58#1',i,'E-S58 The SIN Number is invalid');
     End;
     Inc(i,8);
   Until i>245;
  End;

  FNo:=GetFormNo('S58#2');
  i:=29;
  if Ret[RetNo].FrmHasData[Fno] then
  Begin
    Repeat
     If FetchElmFNo(RetNo,FNo,i) >'' then  //name entered
     Begin
      If ValidSin(FetchElmFNo(RetNo,FNo,i)) = False
       then SaveDiagnostic(RetNo,'S58#1',i,'E-S58 The SIN Number is invalid');
     End;
     Inc(i,8);
    Until i>245;
  End;
  //-------------------------------





  FNo:=GetFormNo('S97');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If FetchElmFNo(RetNo,FNo,22)=''
     then SaveDiagnostic(RetNo,'S97',7,'E-S97 Part 2 information missing');
  end;

  //efile
  If FetchElmFNo(RetNo,Page1FNo,8)>'' then
     SaveDiagnostic(RetNo,'T2',8,'F-Cannot Efile federally with H.O. address change. Phone CRA help desk first'); //20200113

  If FetchElmFNo(RetNo,Page1FNo,21)>'' then
     SaveDiagnostic(RetNo,'T2',21,'F-Cannot Efile due to Mailing address change. Contact CRA');

  If IsNonResidentCorp(RetNo) then
  begin
   If GetTaxationYearEnd(RetNo) <'2009/01/01' then SaveDiagnostic(RetNo,'T2',49,'F-Cannot Efile federally a Non-resident with Y/E prior to 2009');
   //20100510
   If Ret[RetNo].Ln[800]>99999 then
     SaveDiagnostic(RetNo,'T2',28,'F-Cannot Efile. Non-resident/FirstYear/TaxAtSource>$99,999');
   If IsFirstYearFiling(RetNo) then
   begin
    If Ret[RetNo].Ln[800]>24999 then SaveDiagnostic(RetNo,'T2',28,'F-Cannot Efile federally. Non-resident/FirstYear/TaxAtSource>$24,999');
   end;
  end;

  FNo:=GetFormNo('T661');
  If Ret[RetNo].FrmHasData[FNo] = True then
  Begin
   //20151126
   If Length(FetchElmFNo(RetNo,FNo,329)+RemoveNonNumericChars(FetchElmFNo(RetNo,FNo,310)))>10 then
   Begin
      SaveDiagnostic(RetNo,'T661',329,'E-T661 Phone: enter as 999 999-9999');
      SaveDiagnostic(RetNo,'T661',310,'E-T661 Phone: enter as 999 999-9999');
   end;
   If Length(FetchElmFNo(RetNo,FNo,334)+RemoveNonNumericChars(FetchElmFNo(RetNo,FNo,312)))>10 then
   Begin
      SaveDiagnostic(RetNo,'T661',334,'E-T661 Phone: enter as 999 999-9999');
      SaveDiagnostic(RetNo,'T661',312,'E-T661 Phone: enter as 999 999-9999');
   end;
   If Length(FetchElmFNo(RetNo,FNo,331)+RemoveNonNumericChars(FetchElmFNo(RetNo,FNo,311)))>10 then
   Begin
      SaveDiagnostic(RetNo,'T661',331,'E-T661 Phone: enter as 999 999-9999');
      SaveDiagnostic(RetNo,'T661',311,'E-T661 Phone: enter as 999 999-9999');
   end;
   If Length(FetchElmFNo(RetNo,FNo,336)+RemoveNonNumericChars(FetchElmFNo(RetNo,FNo,313)))>10 then
   Begin
      SaveDiagnostic(RetNo,'T661',336,'E-T661 Phone: enter as 999 999-9999');
      SaveDiagnostic(RetNo,'T661',313,'E-T661 Phone: enter as 999 999-9999');
   end;
   //---------------------

   If Vl(FetchElmFNo(RetNo,FNo,123))<>0 then      //20100227
   begin
     If Ret[RetNo].FrmHasData[GetFormNo('S60#1')] = false then
      SaveDiagnostic(RetNo,'S60#1',4,'E-T661 project info missing');
     If ((Ret[RetNo].Province='BC') or (GetTxblIncomeInProv(RetNo,'BC')>0)) and (Vl(FetchElm(RetNo,'S425',25))= 0) then
      SaveDiagnostic(RetNo,'S425',25,'W-S425-Any BC SR&ED claim?');
   end;
   If Vl(FetchElmFNo(RetNo,FNo,136)) <0 then SaveDiagnostic(RetNo,'T661',136,'E-T661 Amount cannot be negative');
   //20130507
   If (Vl(FetchElmFNo(RetNo,FNo,115))+Vl(FetchElmFNo(RetNo,FNo,120))>0)
   and (Vl(FetchElmFNo(RetNo,FNo,13))=0)
    then SaveDiagnostic(RetNo,'T661',13,'W-T661 Any amount for line 529?');
   //20130829
   If FetchElmFNo(RetNo,FNo,14)+FetchElmFNo(RetNo,FNo,15)='' then
    begin
     SaveDiagnostic(RetNo,'T661',14,'E-T661 Enter Research type');
     SaveDiagnostic(RetNo,'T661',15,'E-T661 Enter Research type');
    end;

   For i:=292 to 301 do
   begin
    If Vl(FetchElmFNo(RetNo,FNo,i)) >100 then
       SaveDiagnostic(RetNo,'T661',i,'E-T661 % of funds exceeds 100');
   end;


   //20130829
   If (FetchElmFNo(RetNo,FNo,16)>'')
   and (Vl(FetchElmFNo(RetNo,FNo,102))=0)
   then
     SaveDiagnostic(RetNo,'T661',18,'E-T661 Please complete Billing table');

   i:=18;
   Repeat
    If FetchElmFNo(RetNo,FNo,i)>'' then
    //i+2=code, I+3=Rate I+4=other billing description
    begin
     If (FetchElmFNo(RetNo,FNo,i+1)<>'NR')
     and (ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1))=False)
     and (ValidRTNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1))=False)  //20140530
      then
        SaveDiagnostic(RetNo,'T661',i+1,'E-T661 valid B/N required');
     If FetchElmFNo(RetNo,FNo,i+2)='' then
        SaveDiagnostic(RetNo,'T661',i+2,'E-T661 Billing code required');

     If (FetchElmFNo(RetNo,FNo,i+2)<>'5') then
     begin
     If (FetchElmFNo(RetNo,FNo,i+3)='')   //20171106
    // Or (RealNumeric(FetchElmFNo(RetNo,FNo,i+3))=False)
      then
        SaveDiagnostic(RetNo,'T661',i+3,'E-T661 Billing rate required (do not enter commas)');  //20171106
     end;

     If FetchElmFNo(RetNo,FNo,i+2)='1' then
     Begin
        If Vl(FetchElmFNo(RetNo,FNo,i+3))>100 then
         SaveDiagnostic(RetNo,'T661',i+3,'E-T661 Line 955 needs valid %');
     end;

     //20141124
     If RealNumeric(FetchElmFNo(RetNo,FNo,i+3))= false then
         SaveDiagnostic(RetNo,'T661',i+3,'E-T661 Line 955 must be a numeric value');

     If (FetchElmFNo(RetNo,FNo,i+2)='5')
     and (FetchElmFNo(RetNo,FNo,i+4)='')
     then
        SaveDiagnostic(RetNo,'T661',i+4,'E-T661 Line 960 required');

     If Vl(FetchElmFNo(RetNo,FNo,i+5))=0 then
        SaveDiagnostic(RetNo,'T661',i+5,'E-T661 Amount required');
    end;
    Inc(i,6);
   until i>96;

   If Vl(FetchElmFNo(RetNo,FNo,125)) >0 then
   begin
    s:=FormatFloat('###,###,###',Vl(FetchElm(RetNo,'T661',125)));
    If Vl(FetchElmFNo(RetNo,FNo,147))+Vl(FetchElmFNo(RetNo,FNo,148))=0 then
     SaveDiagnostic(RetNo,'T661',147,'E-T661 Amount required on line 513. Usually equal to line 429'
       +'  $'+s);  //20210710
   end;



   //20181119
   If ValidProjectsInT661(RetNo)= false then
   begin
     SaveDiagnostic(RetNo,'T661',595,'E-T661 Project details do not balance with totals on Part 3-Section B of T661');
     SaveDiagnostic(RetNo,'T661',596,'E-T661 Project details do not balance with totals on Part 3-Section B of T661');
     SaveDiagnostic(RetNo,'T661',597,'E-T661 Project details do not balance with totals on Part 3-Section B of T661');
   end;
   end;

  //s60
  For i:=1 to 20 do   //20130713
  begin
   FNo:=GetFormNo('S60#'+IntToStr(i));
   If FNo>0 then    //20121128
   Begin
   If Ret[RetNo].FrmHasData[Fno] then
   begin
    If FetchElmFNo(RetNo,FNo,5)='' then SaveDiagnostic(RetNo,'S60#'+IntToStr(i),5,'E-S60#'+IntToStr(i)+': Enter Start Date');
    If FetchElmFNo(RetNo,FNo,6)='' then SaveDiagnostic(RetNo,'S60#'+IntToStr(i),6,'E-S60#'+IntToStr(i)+': Enter Completion Date');
    If FetchElmFNo(RetNo,FNo,7)='' then SaveDiagnostic(RetNo,'S60#'+IntToStr(i),7,'E-S60#'+IntToStr(i)+': Enter Field of Science');
    If (FetchElmFNo(RetNo,FNo,10)>'') then  //20110506
    begin
      If (FetchElmFNo(RetNo,FNo,12)='') then SaveDiagnostic(RetNo,'S60#'+IntToStr(i),12,'E-S60#'+IntToStr(i)+': Enter Name(s) of Business');
      If (FetchElmFNo(RetNo,FNo,13)='') then SaveDiagnostic(RetNo,'S60#'+IntToStr(i),13,'E-S60#'+IntToStr(i)+': Enter BN');
    end;

    If (FetchElmFNo(RetNo,FNo,98)>'')
    and (FetchElmFNo(RetNo,FNo,99)='')
    then SaveDiagnostic(RetNo,'S60#'+IntToStr(i),99,'E-S60#'+IntToStr(i)+': Enter description');
    If FetchElmFNo(RetNo,FNo,7)>'' then
    begin
     If MidStr(FetchElmFNo(RetNo,FNo,7),5,1)<>'.' then
      SaveDiagnostic(RetNo,'S60#'+IntToStr(i),7,'E-S60#'+IntToStr(i)+': Invalid code for Field of Science');
    end;

    j:=13;       //20141125
    Repeat
     If (FetchElmFNo(RetNo,Fno,j)>'') then
     begin
      If (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,Fno,j)))
      and (UpperCase(FetchElmFNo(RetNo,FNo,j)) <>'NR') then
      SaveDiagnostic(RetNo,'S60#'+IntToStr(i),j,'E-S60#'+IntToStr(i)+':Business number is invalid');
     end;
     Inc(j,2);
    until j>21;

     //If Ret[RetNo].TS60Ln242Memo[i].count=0 then
     If Ret[RetNo].Frm[FNo].Memos[S60MemoIdx[242]] ='' then
       SaveDiagnostic(RetNo,'S60#'+IntToStr(i),0,'E-S60#'+IntToStr(i)+': Notes on line 242 missing');
     //If Ret[RetNo].TS60Ln244Memo[i].count=0 then
     If Ret[RetNo].Frm[FNo].Memos[S60MemoIdx[244]] ='' then
       SaveDiagnostic(RetNo,'S60#'+IntToStr(i),0,'E-S60#'+IntToStr(i)+': Notes on line 244 missing');
     //If Ret[RetNo].TS60Ln246Memo[i].count=0 then
     If Ret[RetNo].Frm[FNo].Memos[S60MemoIdx[246]] ='' then
       SaveDiagnostic(RetNo,'S60#'+IntToStr(i),0,'E-S60#'+IntToStr(i)+': Notes on line 246 missing');  //20130830

    //20190717
    If FetchElmFNo(RetNo,FNo,81)>'' then
    begin
     If FetchElmFNo(RetNo,FNo,22)='' then
      SaveDiagnostic(RetNo,'S60#'+IntToStr(i),22,'E-S60#'+IntToStr(i)+': Enter Name on line 268');
     If FetchElmFNo(RetNo,FNo,23)='' then
      SaveDiagnostic(RetNo,'S60#'+IntToStr(i),23,'E-S60#'+IntToStr(i)+': Enter NR or business on line 269');
    end;
   end;
   End;
  end;  //t661/s60

  If vl(FetchElm(RetNo,'S303',28)) <> vl(FetchElm(RetNo,'S303',124)) then
     SaveDiagnostic(RetNo,'S303',109,'E-NL-S303 Direct equity credit C/F not completed');

  //20171124
  If vl(FetchElm(RetNo,'S308',56)) <> vl(FetchElm(RetNo,'S308',26)) then
     SaveDiagnostic(RetNo,'S308',56,'E-NL-S308 Details of Credit for C/F must be equal to line 190');

  //20140408
  FNo:=GetFormNo('S381');
  If (vl(FetchElmFNo(RetNo,FNo,7))>0) and (vl(FetchElmFNo(RetNo,FNo,8))=0) then
    SaveDiagnostic(RetNo,'S381',8,'W-MB-S381 Enter tax othewise payable');
  If vl(FetchElmFNo(RetNo,FNo,30))>0 then
  begin
   If vl(FetchElmFNo(RetNo,FNo,10))+vl(FetchElmFNo(RetNo,FNo,14))=0 then
   begin
    SaveDiagnostic(RetNo,'S381',10,'E-MB-S381 enter credit amounts in 2A/2B');
    SaveDiagnostic(RetNo,'S381',14,'E-MB-S381 enter credit amounts in 2A/2B');
   end;
  end;

  FNo:=GetFormNo('S302');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=4;
   repeat
     If Not ValidCertificate(RetNo,FNo,i) then
        SaveDiagnostic(RetNo,'S302',i,'E-NL-S302 Certificate number is incorrect');
   Inc(i,2);
   Until i>40;
  end;

  FNo:=GetFormNo('S303');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=4;
   repeat
     If Not ValidCertificate(RetNo,FNo,i) then
       SaveDiagnostic(RetNo,'S303',i,'E-NL-S303 Receipt number is incorrect');
   Inc(i,2);
   Until i>12;
  end;

  FNo:=GetFormNo('S304');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    If Vl(FetchElmFNo(RetNo,FNo,26)) <> Vl(FetchElmFNo(RetNo,FNo,50)) then
       SaveDiagnostic(RetNo,'S304',50,'E-NL-S304 Part 3 not balancing with Line 200');
    If (Vl(FetchElmFNo(RetNo,FNo,21)) > 0)
    and (Vl(FetchElmFNo(RetNo,FNo,22))=0) then
       SaveDiagnostic(RetNo,'S304',22,'W-NL-S304 credit not claimed');
  end;

  //20230510
  if Ret[RetNo].Province='NL' then
  Begin
   FNo:=GetFormNo('S311');
   If Ret[RetNo].FrmHasData[FNo] then
   begin
     If Vl(FetchElmFNo(RetNo,FNo,99)) <> Vl(FetchElmFNo(RetNo,FNo,149)) then
        SaveDiagnostic(RetNo,'S311',149,'E-NL-S311 total not balancing with Line 350');
   end;
  End;

  //20180512
  FNo:=GetFormNo('S390');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    If Vl(FetchElmFNo(RetNo,FNo,19)) <> Vl(FetchElmFNo(RetNo,FNo,49)) then
       SaveDiagnostic(RetNo,'S390',49,'E-MB-S390 Part 3 not balancing with Line 230');
  end;

    //20180512
  FNo:=GetFormNo('S394');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    If Vl(FetchElmFNo(RetNo,FNo,132)) <> Vl(FetchElmFNo(RetNo,FNo,157)) then
       SaveDiagnostic(RetNo,'S394',157,'E-MB-S394 Part 3 not balancing with Line 295');
  end;



  FNo:=GetFormNo('S429');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If (FetchElm(RetNo,'S429',12)>'') and (FetchElm(RetNo,'S429',14)='') then
       SaveDiagnostic(RetNo,'S429',14,'E-S429 Registration number is required');

   If FetchElm(RetNo,'S429',15)+FetchElm(RetNo,'S429',16)='' then
       SaveDiagnostic(RetNo,'S429',16,'E-S429 Claimed SR&ED?');
  end;

  //20130516
  If Vl(FetchElm(RetNo,'S33',114))>10000000 then
  begin
   If FetchElm(RetNo,'T2',173) = '' then SaveDiagnostic(RetNo,'T2',173,'W-Verify taxable capital re: Line 233 and 234');
  end;

  FNo:=GetFormNo('S387');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    If Vl(FetchElmFNo(RetNo,FNo,26)) <> Vl(FetchElmFNo(RetNo,FNo,56)) then
       SaveDiagnostic(RetNo,'S387',56,'E-MB-S387 Part 4 not balancing with Line 200');
    If (Vl(FetchElmFNo(RetNo,FNo,21)) > 0)
    and (Vl(FetchElmFNo(RetNo,FNo,22))=0) then
       SaveDiagnostic(RetNo,'S387',22,'W-MB-S387 credit not claimed');
  end;


  FNo:=GetFormNo('S306');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,64)) > 5000000 then
       SaveDiagnostic(RetNo,'S306',64,'E-NL S306 total exceeds $5,000,000');
   i:=5;
   Repeat
   If (FetchElmFNo(RetNo,FNo,i) >'')
    and (UpperCase(FetchElmFNo(RetNo,FNo,i)) <>'NR')
    and (Not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i)))
     then SaveDiagnostic(RetNo,'S306',i,'E-S306 Business No invalid OR 9 digits invalid');
   Inc(i,3);
   until i>62;
  end;

  FNo:=GetFormNo('S345');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=4;
   repeat
     If Not ValidCertificate(RetNo,FNo,i) then
       SaveDiagnostic(RetNo,'S345',i,'W-NS-S345 Certificate number is incorrect');
   Inc(i,2);
   Until i>32;
  end;

  FNo:=GetFormNo('S380');
  If (vl(FetchElmFNo(RetNo,FNo,19)) <>
     vl(FetchElmFNo(RetNo,FNo,36)))  then
     SaveDiagnostic(RetNo,'S380',36,'W-MB-S380 C/F history not equal to line 200');

  FNo:=GetFormNo('S381');
  If (vl(FetchElmFNo(RetNo,FNo,127)) <> vl(FetchElmFNo(RetNo,FNo,38)))  then
     SaveDiagnostic(RetNo,'S381',127,'E-MB-S381 C/F history not equal to line 200');
  If (vl(FetchElm(RetNo,'S385',23)) > 0) and
    (vl(FetchElm(RetNo,'S385',24))=0)  then
     SaveDiagnostic(RetNo,'S385',24,'W-MB-S385 No claim made for Odour Control');

  If vl(FetchElm(RetNo,'S385',28)) <> vl(FetchElm(RetNo,'S385',60)) then
     SaveDiagnostic(RetNo,'S385',28,'E-MB-S385 Line 200 does not match details in Part 5');


  FNo:=GetFormNo('S388#1');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,22)) < 25 then
       SaveDiagnostic(RetNo,'S388#1',22,'E-MB-S388 Credit not allowed (less than 25%)');
   If (FetchElmFNo(RetNo,FNo,12)>'')
   or (FetchElmFNo(RetNo,FNo,14)>'')
   or (FetchElmFNo(RetNo,FNo,16)>'')
   or (FetchElmFNo(RetNo,FNo,18)>'') then
    begin
     SaveDiagnostic(RetNo,'S388#1',12,'E-MB-S388 Credit not allowed (answered No in one)');
     SaveDiagnostic(RetNo,'S388#1',14,'E-MB-S388 Credit not allowed (answered No in one)');
     SaveDiagnostic(RetNo,'S388#1',16,'E-MB-S388 Credit not allowed (answered No in one)');
     SaveDiagnostic(RetNo,'S388#1',18,'E-MB-S388 Credit not allowed (answered No in one)');
    end
  end;

  FNo:=GetFormNo('S389');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,12)) < 25 then
       SaveDiagnostic(RetNo,'S389',12,'E-MB-S389 Credit not allowed (less than 25%)');
   If (FetchElmFNo(RetNo,FNo,5)>'')
   or (FetchElmFNo(RetNo,FNo,7)>'')
   or (FetchElmFNo(RetNo,FNo,9)>'') then
    begin
     SaveDiagnostic(RetNo,'S389',5,'E-MB-S389 Credit not allowed (answered No in one)');
     SaveDiagnostic(RetNo,'S389',7,'E-MB-S389 Credit not allowed (answered No in one)');
     SaveDiagnostic(RetNo,'S389',9,'E-MB-S389 Credit not allowed (answered No in one)');
    end
  end;

  FNo:=GetFormNo('S402');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,38)) <> Vl(FetchElmFNo(RetNo,FNo,78)) then
       SaveDiagnostic(RetNo,'S402',78,'E-SK-S402 c/f should equal line 200');
  end;

  FNo:=GetFormNo('S403');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If Vl(FetchElmFNo(RetNo,FNo,48)) <> Vl(FetchElmFNo(RetNo,FNo,28)) then
       SaveDiagnostic(RetNo,'S403',48,'E-SK-S403 c/f analysis should = line 200');
  end;

  //20130602
  FNo:=GetFormNo('S422#1');  //20150415
  If Ret[RetNo].FrmHasData[FNo] then
  begin
    If FetchElmFNo(RetNo,FNo,7)='' then SaveDiagnostic(RetNo,'S422#1',7,'E-BC-S422 Date photography began is required');

   If FetchElmFNo(RetNo,FNo,10)>'' then
   Begin
      If (Length(FetchElmFNo(RetNo,FNo,10))<3)
      or (Length(FetchElmFNo(RetNo,FNo,10))>5)
       then SaveDiagnostic(RetNo,'S422#1',10,'E-BC-S422 Invalid Certificate number');

     If (FetchElmFNo(RetNo,FNo,7)>'2010/02/28') and (Vl(FetchElmFNo(RetNo,FNo,75))>0)  and (Vl(FetchElmFNo(RetNo,FNo,76))=0) then
       SaveDiagnostic(RetNo,'S422#1',76,'W-BC-S422 Any BC Labour Expenditures?');
   end;
  end;

  FNo:=GetFormNo('S422#2');
  If (FNo>0) and (Ret[RetNo].FrmHasData[FNo]) then  //20130516
  begin
    If FetchElmFNo(RetNo,FNo,7)='' then SaveDiagnostic(RetNo,'S422#2',7,'E-BC-S422 Date photography began is required');
    //20130602
    If FetchElmFNo(RetNo,FNo,10)>'' then
    Begin
      If (Length(FetchElmFNo(RetNo,FNo,10))<3)  //20150415
      or (Length(FetchElmFNo(RetNo,FNo,10))>5)
     then SaveDiagnostic(RetNo,'S422#2',10,'E-BC-S422 Invalid Certificate number');
    end;

    If FetchElmFNo(RetNo,FNo,7)='' then
      SaveDiagnostic(RetNo,'S422#2',7,'E-BC-S422 Date photography began is required');

    If (FetchElmFNo(RetNo,FNo,7)>'2010/02/28') and (Vl(FetchElmFNo(RetNo,FNo,75))>0)  and (Vl(FetchElmFNo(RetNo,FNo,76))=0) then
      SaveDiagnostic(RetNo,'S422#1',76,'W-BC-S422 Any BC Labour Expenditures?');

  end;

  For i:=1 to 4 do
  begin
   FNo:=GetFormNo('T1131#'+IntToStr(i));
   If FNo>0 then
   Begin
   If Ret[RetNo].FrmHasData[Fno] then
   begin
    If FetchElmFNo(RetNo,FNo,20)>'' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),20,'E-T1131#'+IntToStr(i)+': Not eligible for the credit. Clear form');
    If FetchElmFNo(RetNo,FNo,31)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),31,'W-T1131#'+IntToStr(i)+': Enter Date');
    If FetchElmFNo(RetNo,FNo,32)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),32,'W-T1131#'+IntToStr(i)+': Enter Date');
    If FetchElmFNo(RetNo,FNo,33)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),33,'W-T1131#'+IntToStr(i)+': Enter Date');
    If FetchElmFNo(RetNo,FNo,34)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),34,'W-T1131#'+IntToStr(i)+': Enter Date');

   // If FetchElmFNo(RetNo,FNo,29)+FetchElmFNo(RetNo,FNo,30)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),30,'E-T1131#'+IntToStr(i)+': Enter Calculation option');
    If FetchElmFNo(RetNo,FNo,7)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),7,'E-T1131#'+IntToStr(i)+': Enter Production Title');
    If FetchElmFNo(RetNo,FNo,8)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),8,'E-T1131#'+IntToStr(i)+': Enter Filming Start Date');
   //20120428  If FetchElmFNo(RetNo,FNo,9)='' then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),9,'W-T1131#'+IntToStr(i)+': Enter CAVCO ref number');

    If (Length(FetchElmFNo(RetNo,FNo,9)) > 0) and (Length(FetchElmFNo(RetNo,FNo,9))<5) then //20120428
      SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),9,'E-T1131#'+IntToStr(i)+': CAVCO reference must be 5 numbers');

    If (Length(FetchElmFNo(RetNo,FNo,10))<>7) and (Length(FetchElmFNo(RetNo,FNo,10))<>9)
     then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),10,'E-T1131#'+IntToStr(i)+': CAVCO Certificate must be 7 or 9 characters');
    If FetchElmFNo(RetNo,FNo,11)>'' then
    begin
     If Length(FetchElmFNo(RetNo,FNo,11))<>7 then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),11,'E-T1131#'+IntToStr(i)+': CAVCO certificatere must be 7 characters');
    end;

    If FetchElmFNo(RetNo,FNo,12)>'' then
    begin
     If Length(FetchElmFNo(RetNo,FNo,12))<>7 then SaveDiagnostic(RetNo,'T1131#'+IntToStr(i),12,'E-T1131#'+IntToStr(i)+': CAVCO certificate must be 7 characters');
    end;
   end;
   end;
  end;

  //20230510 Igor >>>
  For i:=1 to 10 do
  begin
   FNo:=GetFormNo('T1134S#'+IntToStr(i));
   If FNo>0 then
    ValidateT1134S(RetNo,FNo, i);
  end;
  //20230510 Igor <<<


 // Ontario
  //20181122
  FNo:=GetFormNo('S508');
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   If (Vl(FetchElmFNo(RetNo,FNo,32)) >0)
   and (Vl(FetchElmFNo(RetNo,FNo,33))=0) then
       SaveDiagnostic(RetNo,'S508',33,'W-Ont-S508 You could claim some or All ORDTC deduction available (use Y on the override)');
  end;



 If IsAmalgamatedOntario(RetNo) = True then
 begin
   //20111130
   FNo:=GetFormNo('S510');
   If (IsAssociated(RetNo)) and (Ret[RetNo].FrmHasData[Fno]) then
   begin
    If UpperCase(FetchElmFNo(RetNo,FNo,154))='Y' then  //include s510
    Begin
        //If Ret[RetNo].FrmHasData[GetFormNo('S511')] = false
     If vl(FetchElm(RetNo,'S511',84))=0   //20130603
      then SaveDiagnostic(RetNo,'S511',84,'W-S511 is required but it maybe incomplete');
     If vl(FetchElm(RetNo,'S511',85))=0   //20130603
      then SaveDiagnostic(RetNo,'S511',85,'W-S511 is required but it maybe incomplete');
    end;
   end;

   If Vl(FetchElm(RetNo,'S516',126)) > Vl(FetchElm(RetNo,'S516',126))
   then SaveDiagnostic(RetNo,'S516',126,'E-Ont-Allocation line 900 exceeds line 800');

   If ((FetchElm(RetNo,'S506',77)>'') and (FetchElm(RetNo,'S506',79)='')) then
     SaveDiagnostic(RetNo,'S506',79,'W-Ont-Enter days for early termination');

   If Vl(FetchElm(RetNo,'S506',46))<0 then  //20131016
     SaveDiagnostic(RetNo,'S506',46,'E-S506-Line 300 must be positive');


   //20210519
   FNo:=GetFormNo('S546');
   If Ret[RetNo].FrmHasData[Fno] then
   Begin
    SaveDiagnostic(RetNo,'S546',1,'E-S546-You cannot Efile or Paper file any longer the S546. Please Clear the S546 form');
   End;
   FNo:=GetFormNo('S548');
   If Ret[RetNo].FrmHasData[Fno] then
   Begin
    SaveDiagnostic(RetNo,'S548',1,'E-S548-You cannot Efile or Paper file any longer the S548. Please Clear the S548 form');
   End;



  FNo:=GetFormNo('S511'); //20120529
  If Ret[RetNo].FrmHasData[FNo] then
  begin
   i:=4;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i+1)>'') and (UpperCase(FetchElmFNo(RetNo,FNo,i+1))<>'NR') then
    begin
     If not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,i+1)) then
       SaveDiagnostic(RetNo,'S511',i+1,'E-S511-Business No invalid:9 digits+RC+0001 OR 9 digits wrong');
    end;
    //2320130601
    If (Vl(FetchElmFNo(RetNo,FNo,i+2))>0) Or (Vl(FetchElmFNo(RetNo,FNo,i+3))>0) then
    begin
     If (FetchElmFNo(RetNo,FNo,i)='') or (FetchElmFNo(RetNo,FNo,i+1)='') then
       SaveDiagnostic(RetNo,'S511',i,'E-S511-Complete columns 200 and 300');
    end;
    Inc(i,4);
   until i>80;
  end;


   For i:=1 to 5 do
   begin
    FNo:=GetFormNo('S552#'+AllTrim(IntToStr(i)));
    If FNo>0 then
    Begin
     If Ret[RetNo].FrmHasData[Fno] then
     begin
      If (FetchElmFNo(RetNo,FNo,7)>'') and (FetchElmFNo(RetNo,FNo,9)='') then //20141125
        SaveDiagnostic(RetNo,'S552#'+AllTrim(IntToStr(i)),9,'E-S552-Enter parthership name');
      j:=38;
      Repeat
      If FetchElmFNo(RetNo,FNo,j)<> '' then
      begin
       If DateWithinTaxYear(FetchElmFNo(RetNo,FNo,j),RetNo)=false then
         SaveDiagnostic(RetNo,'S552#'+AllTrim(IntToStr(i)),j,'E-S552-Date outside fiscal periods');
      end;
      If FetchElmFNo(RetNo,FNo,j+1)<> '' then
      begin
       If DateWithinTaxYear(FetchElmFNo(RetNo,FNo,j+1),RetNo) =false then
         SaveDiagnostic(RetNo,'S552#'+AllTrim(IntToStr(i)),j+1,'E-S552-Date outside fiscal periods');
      end;
      Inc(j,5);
      until j>58;
     end;
    End;
   end;  //s552


   //20160601
   For i:=1 to 5 do
   begin
    FNo:=GetFormNo('S554#'+AllTrim(IntToStr(i)));
    If FNo>0 then
    Begin
      if Vl(FetchElmFNo(RetNo,Fno,23))>0 then
      Begin
       if FetchElmFNo(RetNo,Fno,26)='' then
               SaveDiagnostic(RetNo,'S554#'+AllTrim(IntToStr(i)),26,'E-S554-Line 450. Parent Corp. Name is required');
       if FetchElmFNo(RetNo,Fno,27)='' then
               SaveDiagnostic(RetNo,'S554#'+AllTrim(IntToStr(i)),27,'E-S554-Line 460. Parent Corp. B/N is required');
      End;

      if Vl(FetchElmFNo(RetNo,Fno,48))>0 then
      Begin
       if FetchElmFNo(RetNo,Fno,51)='' then
               SaveDiagnostic(RetNo,'S554#'+AllTrim(IntToStr(i)),51,'E-S554-Line 650. Parent Corp. Name is required');
       if FetchElmFNo(RetNo,Fno,52)='' then
               SaveDiagnostic(RetNo,'S554#'+AllTrim(IntToStr(i)),52,'E-S554-Line 660. Parent Corp. B/N is required');
      End;
    end;
   end;
   //----------------------
   //20160601
   For i:=1 to 5 do
   begin
    FNo:=GetFormNo('S558#'+AllTrim(IntToStr(i)));
    If FNo>0 then
    Begin
      if Vl(FetchElmFNo(RetNo,Fno,65))>0 then
      Begin
       if FetchElmFNo(RetNo,Fno,66)='' then
               SaveDiagnostic(RetNo,'S558#'+AllTrim(IntToStr(i)),66,'E-S558-Line 646. Parent Corp. Name is required');
       if FetchElmFNo(RetNo,Fno,67)='' then
               SaveDiagnostic(RetNo,'S558#'+AllTrim(IntToStr(i)),67,'E-S558-Line 647. Parent Corp. B/N is required');
      End;

      if Vl(FetchElmFNo(RetNo,Fno,25))>0 then
      Begin
       if FetchElmFNo(RetNo,Fno,26)='' then
               SaveDiagnostic(RetNo,'S558#'+AllTrim(IntToStr(i)),26,'E-S554-Line 746. Parent Corp. Name is required');
       if FetchElmFNo(RetNo,Fno,27)='' then
               SaveDiagnostic(RetNo,'S558#'+AllTrim(IntToStr(i)),27,'E-S558-Line 747. Parent Corp. B/N is required');
      End;
    end;
   end;
   //-------------------


   For i:=1 to 5 do
   begin
    FNo:=GetFormNo('S560#'+AllTrim(IntToStr(i)));
    If FNo>0 then  //20121128
    Begin
     If Ret[RetNo].FrmHasData[Fno] then
     begin
      If (Vl(FetchElmFNo(RetNo,FNo,67))> 0) then
      begin
       If Vl(FetchElmFNo(RetNo,FNo,67)) <> Vl(FetchElmFNo(RetNo,FNo,91))+Vl(FetchElmFNo(RetNo,FNo,92))+Vl(FetchElmFNo(RetNo,FNo,68))
           +Vl(FetchElmFNo(RetNo,FNo,93)) then
        SaveDiagnostic(RetNo,'S560#'+AllTrim(IntToStr(i)),67,'E-S560-Breakdown by dates below is incorrect');
      end;
      If Vl(FetchElmFNo(RetNo,FNo,73))> 0 then
      begin
       If Vl(FetchElmFNo(RetNo,FNo,73)) <> Vl(FetchElmFNo(RetNo,FNo,94))+Vl(FetchElmFNo(RetNo,FNo,95))+Vl(FetchElmFNo(RetNo,FNo,75))
          +Vl(FetchElmFNo(RetNo,FNo,96)) then
        SaveDiagnostic(RetNo,'S560#'+AllTrim(IntToStr(i)),73,'E-S560-Breakdown by dates below is incorrect');
      end;
     end;
    end; //fno
   end; //i
 end;

  FNo:=GetFormNo('S566');  //20111102
  If IsAssociated(RetNo) then
  Begin
   If Vl(FetchElmFNo(RetNo,FNo,175))>0 then //itc
   begin
     If Vl(FetchElmFNo(RetNo,FNo,35))=0 then
      SaveDiagnostic(RetNo,'S566',35,'E-S566-Enter amount on Line 420');
   end;
  End;
  //20180617
  FNo:=GetFormNo('T2054');  //20180617
  If Ret[RetNo].FrmHasData[Fno] then
  Begin
   If FetchElmFNo(RetNo,FNo,99)='' then //months
     SaveDiagnostic(RetNo,'T2054',99,'W-T2054 Enter number of months');  //20190625
   If (Vl(FetchElmFNo(RetNo,FNo,108))>0)  and (Vl(FetchElmFNo(RetNo,FNo,109))=0)
   then SaveDiagnostic(RetNo,'T2054',109,'W-T2054 No payment amount entered');
  End;


  //Alberta
  If Ret[RetNo].AlbAlloc >0 then
  begin
    FrmNm:='AT1';
    FNo:=GetFormNo(Frmnm);    //20111205
    If (FetchElmFNo(RetNo,FNo,134)='') then
      SaveDiagnostic(RetNo,FrmNm,134,'E-Alb-'+FrmNm+' Telephone Number is mandatory');
    If (FetchElmFNo(RetNo,FNo,135)='') then
      SaveDiagnostic(RetNo,FrmNm,135,'E-Alb-'+FrmNm+' Authorized Email is mandatory');

    If (FetchElmFNo(RetNo,FNo,9) = '')
    or (Length(FetchElmFNo(RetNo,FNo,9)) > 10)
    or (Length(FetchElmFNo(RetNo,FNo,9)) < 9)
     then
     SaveDiagnostic(RetNo,'AT1',9,'E-Alb CorpAccount incorrect');

    If (FetchElmFNo(RetNo,FNo,29) = '')
    or (FetchElmFNo(RetNo,FNo,30) = '') then
     SaveDiagnostic(RetNo,'AT1',29,'E-Alb Contact info missing');

    If (FetchElmFNo(RetNo,FNo,17) > '')
    and (FetchElmFNo(RetNo,FNo,19)+
         FetchElmFNo(RetNo,FNo,20)+
         FetchElmFNo(RetNo,FNo,21) = '') then
     SaveDiagnostic(RetNo,'AT1',19,'E-Alb Reason Y/E changed');

    if FetchElm(RetNo,'T2',21)>'' then //mailing address changed  //20221120
    Begin
     If (FetchElmFNo(RetNo,FNo,3) = '')
     or (FetchElmFNo(RetNo,FNo,5) = '')
     or (FetchElmFNo(RetNo,FNo,8) = '')
     or ((FetchElmFNo(RetNo,FNo,6) = '') and
         (FetchElmFNo(RetNo,FNo,7) = '')) then
        SaveDiagnostic(RetNo,'AT1',3,'E-Alb mailing address not completed');
    end;

    //20151115
    If IsTaxExempt(RetNo) then
    begin
     If FetchElm(RetNo,'AT1',16)='' then
        SaveDiagnostic(RetNo,'AT1',16,'W-Alb AT1: Tick box if tax exempt as Federal');
    end;
    If (IsTaxExempt(RetNo)=false)    //20151115
    and (IsAlbTaxExempt(RetNo)=True) then
       SaveDiagnostic(RetNo,'AT1',16,'W-Alb is Tax Exempt but Federal is not');


    //20150510
    k:=GetFormNo('T2');
    If FetchElmFNo(RetNo,FNo,21) >'' then  //20221120 if mailing cnanged
    begin
     If (FetchElmFNo(RetNo,FNo,3) = '')
     or (FetchElmFNo(RetNo,FNo,5) = '')
     or (FetchElmFNo(RetNo,FNo,6) = '')
     or ((FetchElmFNo(RetNo,FNo,7) = '') and
      (FetchElmFNo(RetNo,FNo,8) = '')) then
        SaveDiagnostic(RetNo,'AT1',3,'E-Alb mailing address not completed');

     If (FetchElmFNo(RetNo,FNo,8) > '') then
     begin
      If ValidPostal(RetNo,FetchElmFNo(RetNo,FNo,8),FetchElmFNo(RetNo,FNo,7)) = False then
        SaveDiagnostic(RetNo,'AT1',8,'E-Alb-Postal code-Valid formats are ANANAN or ANA NAN');
     end;
    end;

    If (FetchElmFNo(RetNo,FNo,58) = '') then
     SaveDiagnostic(RetNo,'AT1',58,'E-Alb: SIC valid code required');

    If (FetchElmFNo(RetNo,FNo,58) = '9999') then
     SaveDiagnostic(RetNo,'AT1',58,'W-Alb: SIC may be invalid. Check');

   //20120508
   If FetchElmFNo(RetNo,GetFormNo('AT1'),133) < FormatDateTime('yyyy/mm/dd',Now) then
    SaveDiagnostic(RetNo,'AT1',133,'W-Alb:Signing date older than today');


     //20111205
    If FetchElm(RetNo,'T2',72) > '' then  //functional currency
    Begin
     If FetchElmFNo(RetNo,FNo,62) = '' then  //functional currency
      SaveDiagnostic(RetNo,'AT1',62,'E-Alb-AT1: Exchange rate required (format x.xxxx)');
    If (Length(FetchElmFNo(RetNo,FNo,62))<> 6)
    Or (midStr(FetchElmFNo(RetNo,FNo,62),2,1)<> '.')
    then  //functional currency
      SaveDiagnostic(RetNo,'AT1',62,'E-Alb-AT1: Exchange rate required with 4 decimals: x.xxxx');
    end;

    //alberta schedules
    //20251128

    FrmNm:='AS4';
    FNo:=GetFormNo(FrmNm);  //20100530
    i:=3;
    Repeat
     If (FetchElmFNo(RetNo,FNo,i) ='') and (Vl(FetchElmFNo(RetNo,FNo,i+7))>0) then
      SaveDiagnostic(RetNo,FrmNm,i,'E-Alb-'+FrmNm+' should be completed');
     Inc(i,8);
    until i>35;

    FrmNm:='AS5';
    FNo:=GetFormNo(FrmNm);  //20100530
    i:=12;
    Repeat
     If (FetchElmFNo(RetNo,FNo,i) ='') and (Vl(FetchElmFNo(RetNo,FNo,i+3))>0) then
      SaveDiagnostic(RetNo,FrmNm,i,'E-Alb-'+FrmNm+' should be completed');
     Inc(i,4);
    until i>32;

    FrmNm:='AS9L';
    FNo:=GetFormNo(FrmNm);
    If Vl(FetchElmFNo(RetNo,FNo,150))>Vl(FetchElm(RetNo,'T661',108)) then
       SaveDiagnostic(RetNo,FrmNm,150,'E-Alb-'+FrmNm+' Total exceeds Line 306 of T661 '
         +FormatFloat('###,###,###',Vl(FetchElm(RetNo,'T661',108))));

    //20121220
    If Vl(FetchElmFNo(RetNo,FNo,151))>Vl(FetchElm(RetNo,'T661',168)) then
       SaveDiagnostic(RetNo,FrmNm,151,'E-Alb-'+FrmNm+' Total exceeds Line 559 of T661 '
        +'$'+FormatFloat('###,###,###',Vl(FetchElm(RetNo,'T661',168))));


    FrmNm:='AS5';
    If (FetchElm(RetNo,FrmNm,16) ='1') or (FetchElm(RetNo,FrmNm,16)='2') then
    begin
      If FetchElm(RetNo,FrmNm,17) = '' then
        SaveDiagnostic(RetNo,FrmNm,17,'E-Alb-'+FrmNm+' enter Corp name in line 027');
    end;

    //20151117
    FNo:=GetFormNo('AS10');
    If FetchElmFNo(RetNo,FNo,10)>'' then
    Begin
     If FetchElmFNo(RetNo,FNo,10)<>GetPrevYearEnd(GetAlbYearEnd(RetNo),1) then
       SaveDiagnostic(RetNo,'AS10',10,'W-Alb-'+'AS10'+' Preceding tax year may be incorrect');
    end;
    If FetchElmFNo(RetNo,FNo,15)>'' then
    Begin
     If FetchElmFNo(RetNo,FNo,15)<>GetPrevYearEnd(GetAlbYearEnd(RetNo),2) then
       SaveDiagnostic(RetNo,'AS10',15,'W-Alb-'+'AS10'+' Preceding tax year may be incorrect');
    end;
    If FetchElmFNo(RetNo,FNo,20)>'' then
    Begin
     If FetchElmFNo(RetNo,FNo,20)<>GetPrevYearEnd(GetAlbYearEnd(RetNo),3) then
       SaveDiagnostic(RetNo,'AS10',20,'W-Alb-'+'AS10'+' Preceding tax year may be incorrect');
    end;

   //--------------------------------------------------------

    //20150405
    FNo:=GetFormNo('AS14');
    If UpperCase(FetchElmFNo(RetNo,FNo,21))='Y' then
        SaveDiagnostic(RetNo,'AS14',21,'W-Alb-'+'AS14'+'-Differs from Federal (Y)');

    x:=Vl(FetchElmFNo(RetNo,FNo,14));
    if X>0 then
      SaveDiagnostic(RetNo,'AS12',11,'W-Alb S12-Ensure amount $'+FormatFloat('###,###,###',x)+' is included on line 10 of Alb S12, as per AS14');

    x:=Vl(FetchElmFNo(RetNo,FNo,115));
    if x<0 then
     SaveDiagnostic(RetNo,'AS12',13,'W-Alb S12-Ensure amount $'+FormatFloat('###,###,###',x)+' is included on line 12 of Alb S12, as per AS14');

    //  -----
    FNo:=GetFormNo('AS14WS');
    x:=Vl(FetchElmFNo(RetNo,FNo,17));
    if X>0 then
     SaveDiagnostic(RetNo,'AS13#1',1,'W-Alb S13-Ensure amount $'+FormatFloat('###,###,###',x)+' is included on line 003 of Alb S13 as class 14.1,as per AS14WS');
    if X<0 then
     SaveDiagnostic(RetNo,'AS13#1',1,'W-Alb S13-Ensure amount $'+FormatFloat('###,###,###',x)+' is included on line 015 of Alb S13 as class 14.1, as per AS14WS');

    x:=Vl(FetchElmFNo(RetNo,FNo,34));
    if X<>0 then
     SaveDiagnostic(RetNo,'AS18',16,'W-Alb S18-Ensure amount $'+FormatFloat('###,###,###',x)+' is included on line 008 of Alb S18 as per AS14WS');
  //------------------

    //20150405
    FNo:=GetFormNo('AS21');
    If UpperCase(FetchElmFNo(RetNo,FNo,28))='Y' then
        SaveDiagnostic(RetNo,'AS21',28,'W-Alb-'+'AS21'+'-Differs from Federal (Y)');


    FNo:=GetFormNo('AS20');   //20140616
    If (Vl(FetchElmFNo(RetNo,FNo,109)) >0) and
       (Vl(FetchElmFNo(RetNo,FNo,110)) =0) then
        SaveDiagnostic(RetNo,'AS20',110,'W-Alb-'+'AS20'+'-Gifts entered but no claim');

    If Vl(FetchElmFNo(RetNo,FNo,64)) <> Vl(FetchElmFNo(RetNo,FNo,11)) then
         SaveDiagnostic(RetNo,'AS20',64,'W-Alb-'+'AS20'+'-Donations by origin does not agree with box 018');

    If Vl(FetchElmFNo(RetNo,FNo,65))+Vl(FetchElmFNo(RetNo,FNo,66))+Vl(FetchElmFNo(RetNo,FNo,67))
        <> Vl(FetchElmFNo(RetNo,FNo,111)) then
    begin
         SaveDiagnostic(RetNo,'AS20',65,'W-Alb-'+'AS20'+'-Gifts by origin does not agree with box 078');
         SaveDiagnostic(RetNo,'AS20',66,'W-Alb-'+'AS20'+'-Gifts by origin does not agree with box 078');
         SaveDiagnostic(RetNo,'AS20',67,'W-Alb-'+'AS20'+'-Gifts by origin does not agree with box 078');
    end;


    FNo:=GetFormNo('AS29');  //20210529
    If Ret[RetNo].FrmHasData[Fno] then
    Begin
     If FetchElmFNo(RetNo,FNo,11)='' then SaveDiagnostic(RetNo,'AS29',11,'E-Alb-'+'AS29'+'Enter field of science 1 to 4');
     If Vl(FetchElmFNo(RetNo,FNo,38))>Vl(FetchElmFNo(RetNo,FNo,37)) then
          SaveDiagnostic(RetNo,'AS29',38,'E-Alb-'+'AS29-'+'Line 270 must not exceed line 208');
    End;


    FNo:=GetFormNo('AS29L');  //202105720
    If Ret[RetNo].FrmHasData[Fno] then
    Begin
     If VL(FetchElmFNo(RetNo,FNo,170)) <> VL(FetchElmFNo(RetNo,FNo,148))+VL(FetchElmFNo(RetNo,FNo,149))
                                          -VL(FetchElmFNo(RetNo,FNo,171)) //20250622B
       then SaveDiagnostic(RetNo,'AS29L',170,'E-Alb-'+'AS29'+'Box 170 must equal total of colums 105 and 107 before AB IEG');  //20250622B
    End;


   FrmNm:='POLIT';
   FNo:=GetFormNo(FrmNm);   //20100530
   i:=35;
   j:=124;
   Repeat
      If (Vl(FetchElmFNo(RetNo,FNo,i))>0) then
      begin
       If (Length(FetchElmFNo(RetNo,FNo,i-2))<>10) then SaveDiagnostic(RetNo,FrmNm,i-2,'E-Alb-'+FrmNm+' date is incorrect');
       If FetchElmFNo(RetNo,FNo,j)='' then SaveDiagnostic(RetNo,FrmNm,j,'E-Alb-'+FrmNm+' Official receipt is required');
      end;
     Inc(i,3);
     Inc(j,1);
   until i>39;


   FrmNm:='AS5';
   FNo:=GetFormNo(FrmNm);
   i:=22;
   Repeat
    If (FetchElmFNo(RetNo,FNo,i)>'') and (DateWithinTaxYear(FetchElmFNo(RetNo,FNo,i),RetNo) = false) then
       SaveDiagnostic(RetNo,'AS5',i,'E-Alb-'+'AS5 date must be within tax year');
    Inc(i,4);
   until i>34;

   FrmNm:='AS5';
   If (Ret[RetNo].FrmHasData[GetFormNo('AS5')])
   and (FetchElm(RetNo,'AS5',6)>'') then
      SaveDiagnostic(RetNo,'AS5',5,'E-Alb-'+'AS5 Indicator s/b set to x if Area D filled');
   If (Ret[RetNo].FrmHasData[GetFormNo('AS5')]= False)
   and (FetchElm(RetNo,'AS5',5)>'') then
     SaveDiagnostic(RetNo,'AS5',5,'E-Alb-'+'AS5 Indicator is set but Area D not completed');


    FrmNm:='AS6'; //pg2
    FNo:=GetFormNo(FrmNm);
    i:=109;
    Repeat
     If (FetchElmFNo(RetNo,FNo,i) ='') and (Vl(FetchElmFNo(RetNo,FNo,i+2))>0) then
      SaveDiagnostic(RetNo,FrmNm,i,'E-Alb-'+FrmNm+' should be completed');
     Inc(i,3);
    until i>142;

    FrmNm:='AS7'; //pg2
    FNo:=GetFormNo(FrmNm);  //20100530
    i:=103;
    Repeat
     If (FetchElmFNo(RetNo,FNo,i) ='') and (Vl(FetchElmFNo(RetNo,FNo,i+3))>0) then
      SaveDiagnostic(RetNo,FrmNm,i,'E-Alb-'+FrmNm+' should be completed');
     Inc(i,6);
    until i>151;

    FrmNm:='AS7'; //pg2
    FNo:=GetFormNo(FrmNm);            //20100530
    i:=160;
    Repeat
     If (FetchElmFNo(RetNo,FNo,i) ='') and (Vl(FetchElmFNo(RetNo,FNo,i+5))>0) then
      SaveDiagnostic(RetNo,FrmNm,i,'E-Alb-'+FrmNm+' should be completed');
     Inc(i,6);
    until i>208;

    FrmNm:='AS13#1';
    FNo:=GetFormNo(FrmNm);  //20100530
    i:=3;
    If UpperCase(FetchElmFNo(RetNo,FNo,i)) ='Y' then
      SaveDiagnostic(RetNo,FrmNm,i,'W-Alb-S13-CCA taken differs from federal');


    FrmNm:='AS18'; //pg2
    FNo:=GetFormNo(FrmNm);  //20100530
    i:=104;
    Repeat
     If (FetchElmFNo(RetNo,FNo,i) ='') and (Vl(FetchElmFNo(RetNo,FNo,i+6))<>0) then
      SaveDiagnostic(RetNo,FrmNm,i,'E-Alb-'+FrmNm+' should be completed');
     Inc(i,7);
    until i>160;


    //FrmNm:='AS20';  //20140525
    //FNo:=GetFormNo(FrmNm);            //20100530

    FrmNm:='AS21';  //20140525
    FNo:=GetFormNo(FrmNm);            //20100530
    If (Vl(FetchElmFNo(RetNo,FNo,19))>0)  and (Vl(FetchElmFNo(RetNo,FNo,341))=0) then
     //SaveDiagnostic(RetNo,FrmNm,341,'E-Alb-'+FrmNm+' C/F balance does not balance with Box 049');
     SaveDiagnostic(RetNo,FrmNm,341,'W-Alb-'+FrmNm+' Non Cap losses balances by year missing');
    //farm
    If (Vl(FetchElmFNo(RetNo,FNo,107))>0) and (Vl(FetchElmFNo(RetNo,FNo,453))=0) then
     SaveDiagnostic(RetNo,FrmNm,453,'W-Alb-'+FrmNm+' Farm losses balances by year missing');
    //restr farm
    If (Vl(FetchElmFNo(RetNo,FNo,108))>0) and (Vl(FetchElmFNo(RetNo,FNo,454))=0) then
     SaveDiagnostic(RetNo,FrmNm,454,'E-Alb-'+FrmNm+' Restr. Farm losses balances by year missing');


    //listed pers prop
    If (Vl(FetchElmFNo(RetNo,FNo,133))>0) and (Vl(FetchElmFNo(RetNo,FNo,455))=0) then
     SaveDiagnostic(RetNo,FrmNm,455,'E-Alb-'+FrmNm+' Listed prop. losses balances by year missing');

  end; {Alb}


   {Review Marks}
  for i :=0 to (ReviewList.Count - 1) do
  begin
  ReviewRec := ReviewList.Items[i];
  if (ReviewRec.RetNo = RetNo) then
   SaveDiagnostic(RetNo,GetFormName(ReviewRec.FormNo),ReviewRec.FieldId,'R-RvMark'+' '+ GetFormName(ReviewRec.FormNo));
  end;

 (*
  {FldTapes/FLDMEM}
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec.FormName = 'FLDTAPE' then
   begin
     FrmNm:=Frec.FormName+FRec.FormInst;
     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
     begin
      SaveDiagnostic(RetNo,FrmNm,126,'A-AddTape'+' '+FetchElm(RetNo,FrmNm,121));
     end;
   end;
  *)
  {FldTapes/FLDMEM}
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec.FormName = 'FLDTAPE' then
   begin
     FrmNm:=Frec.FormName+FRec.FormInst;
     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
     begin
      //20170728 Igor>>>
      If FetchElmFNo(RetNo,Frec.Formno, 123)='' then
          SaveDiagnostic(RetNo,FrmNm,123,'W-Tape'+'-'+FrmNm+ 'has amounts but is set to NO posting');

      SaveDiagnostic(RetNo,FrmNm,126,'D-Tape'+' '+PaddR(FetchElm(RetNo,FrmNm,121),12)+' '+FetchElm(RetNo,FrmNm,122));

      //SaveDiagnostic(RetNo,FrmNm,126,'A-AddTape'+' '+FetchElm(RetNo,FrmNm,121));
      //20170728 Igor<<<
     end;
   end;


   If Frec.FormName = 'FLDMEM' then
   begin
     FrmNm:=Frec.FormName+FRec.FormInst;
     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
     begin
      SaveDiagnostic(RetNo,FrmNm,17,'N-Note'+' '+FetchElm(RetNo,FrmNm,17));
     end;
   end;
  end; {i}

  {Signatures}
  If IsEfiled(RetNo) then
   SaveDiagnostic(RetNo,'T183CP',16,'S-Efiled return. Sign the T183CORP form and keep it')
  else
   SaveDiagnostic(RetNo,'Barcode',1,'S-Fed-Sign the Barcoded return before filing');

  { 20110617
  If IsAmalgamatedOntario(RetNo)=False then
  Begin
   If GetOntAlloc(RetNo) >0 then
   begin
    If Not SubjectToCMT(RetNo) then SaveDiagnostic(RetNo,'OPG_17',20,'S-Ont-CT23-17 or Short CT23-3');
    If SubjectToCMT(RetNo) then
     begin
      SaveDiagnostic(RetNo,'xxxxx',1,'S-Ont-CMT-Must D-file');
      SaveDiagnostic(RetNo,'OEFCERT',1,'S-Ont-Certification Form diskette filing');
     end;
   end;
  End;
  }
  Result := Ret[RetNo].ErrorCount;
End;


(*
Procedure SaveReviewMarksDiagnostic(FrmNm: string; ElmNo : integer; ErrMsg:string);
Begin
  Inc(ErrorCount);
  AuditList.Add(PaddR(ErrMsg,60)+PaddR(FrmNm,10)+PaddR(AllTrim(IntToStr(ElmNo)),3));
End;
*)


//20160123
Procedure RemoveT1135SectionAdata(RetNo:Integer;Fno:Integer);
Var i:Integer; s:String;
Begin
   For i:=46 to 50 do
   begin
     If FetchElmFNo(RetNo,FNo,i)>'' then SaveDiagnostic(RetNo,'T1135',i,'E-T1135-Remove Type of property in Part A');
   end;
   If FetchElmFNo(RetNo,FNo,53)>'' then SaveDiagnostic(RetNo,'T1135',53,'E-T1135-Remove Type of property in Part A');
   If FetchElmFNo(RetNo,FNo,55)>'' then SaveDiagnostic(RetNo,'T1135',55,'E-T1135-Remove Type of property in Part A');

   If FetchElmFNo(RetNo,FNo,57)>'' then SaveDiagnostic(RetNo,'T1135',57,'E-T1135-Remove Country code in Part A');
   If FetchElmFNo(RetNo,FNo,58)>'' then SaveDiagnostic(RetNo,'T1135',58,'E-T1135-Remove Country code in Part A');
   If FetchElmFNo(RetNo,FNo,59)>'' then SaveDiagnostic(RetNo,'T1135',59,'E-T1135-Remove Country code in Part A');
   If FetchElmFNo(RetNo,FNo,60)>'' then SaveDiagnostic(RetNo,'T1135',60,'E-T1135-Remove Income in Part A');
   If FetchElmFNo(RetNo,FNo,64)>'' then SaveDiagnostic(RetNo,'T1135',64,'E-T1135-Remove Gain/Loss in Part A');
end;

Procedure RemoveT1135SectionBdata(RetNo:Integer;Fno:Integer);
Var i:Integer;
Begin
 i:=1;
 Repeat
  If (FetchElmFNo(RetNo,FNo,i*10001)>'') then SaveDiagnostic(RetNo,'T1135',i*10001,'E-T1135-Delete all data from Part B');
  Inc(i,1);
 until
 i>7;
end;

Procedure ValidateT1135SectionAdata(RetNo:Integer;Fno:Integer);
Var i:Integer;s:String;
Begin
 s:=FetchElmFNo(RetNo,FNo,72);
 If ValidatePhone(s)=False then
   SaveDiagnostic(RetNo,'T1135',72,'E-T1135-Enter phone in the format n(nnn)nnn-nnnn and no spaces');
 //20160709
 s:=FetchElmFNo(RetNo,FNo,77);
 If ValidatePhone(s)=False then
   SaveDiagnostic(RetNo,'T1135',77,'E-T1135-Enter phone in the format n(nnn)nnn-nnnn and no spaces');

 s:='';
 For i:=46 to 50 do begin s:=s+FetchElmFNo(RetNo,FNo,i);End;
 s:=s+FetchElmFNo(RetNo,FNo,53)+FetchElmFNo(RetNo,FNo,55);
 If s='' then
 begin
    SaveDiagnostic(RetNo,'T1135',46,'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo,'T1135',47,'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo,'T1135',48,'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo,'T1135',49,'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo,'T1135',50,'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo,'T1135',53,'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo,'T1135',55,'E-T1135-Part A: please select at least one Type of property');
 end;
 s:=FetchElmFNo(RetNo,FNo,57)+FetchElmFNo(RetNo,FNo,58)+FetchElmFNo(RetNo,FNo,59);
 If s='' then
 begin
    SaveDiagnostic(RetNo,'T1135',57,'E-T1135-Part A: Please select at least one Country code');
    SaveDiagnostic(RetNo,'T1135',58,'E-T1135-Part A: Please select at least one Country code');
    SaveDiagnostic(RetNo,'T1135',59,'E-T1135-Part A: Please select at least one Country code');
 end;

 If FetchElmFNo(RetNo,FNo,60)='' then
    SaveDiagnostic(RetNo,'T1135',60,'E-T1135-Part A: please enter an amount in the Income from all'+Chr(13)+'specified foreign property field. If nil enter 0.');

 If FetchElmFNo(RetNo,FNo,64)='' then
    SaveDiagnostic(RetNo,'T1135',64,'E-T1135-Part A: please enter an amount in the Gain/Loss from the disposition from'+Chr(13)+'all specified foreign property field. If nil enter 0.');

end;

Procedure ValidateT1135SectionBdata(RetNo:Integer;Fno:Integer);
Var i:Integer;s:String;
Cnt:Integer;
Begin
 Cnt:=0;  //count entries in section B
 i:=1;
 Repeat
  If (FetchElmFNo(RetNo,FNo,i*10000+1)>'') then Cnt:=Cnt+1;      //20160325
  Inc(i,1);
 until
 i>7;
 //20160508
 If Cnt=0 then SaveDiagnostic(RetNo,'T1135',10001,'E-T1135-Specified foreign property over $250,000 specified. At least one row must be fully completed');
 //20160325
 //check country code
 i:=1;
 Repeat
  If (FetchElmFNo(RetNo,FNo,i*10000+1)>'')  and (FetchElmFNo(RetNo,FNo,i*10000+2)='') then
     SaveDiagnostic(RetNo,'T1135',0,'E-T1135-Part B: If you enter Name, you must also enter Country Code');
  Inc(i,1);
 until
 i>7;
end;


Procedure ValidateT1135(RetNo:Integer;Fno:Integer);
//Var s:String;
begin
   //T1135  brand new 20160124  REDO
  If Ret[RetNo].FrmHasData[FNo] = True then
  Begin
   //20160126
   If FetchElmFNo(RetNo,FNo,15)='' then
    SaveDiagnostic(RetNo,'T1135',15,'E-T1135-Street address is required');
   If FetchElmFNo(RetNo,FNo,17)='' then SaveDiagnostic(RetNo,'T1135',17,'E-T1135-City is required');
   If FetchElmFNo(RetNo,FNo,63)='' then SaveDiagnostic(RetNo,'T1135',63,'E-T1135-Province or territory is required');
   If FetchElmFNo(RetNo,FNo,16)='' then SaveDiagnostic(RetNo,'T1135',16,'E-T1135-Postal or Zip code is required');
   If FetchElmFNo(RetNo,FNo,28)='' then SaveDiagnostic(RetNo,'T1135',28,'E-T1135-Country Code is required');
   If FetchElmFNo(RetNo,FNo,28)='OTH' then SaveDiagnostic(RetNo,'T1135',28,'E-T1135-Country Code cannot be OTH in Address');

   If FetchElmFNo(RetNo,FNo,70)='' then SaveDiagnostic(RetNo,'T1135',70,'E-T1135-Certification section - Name is required');

   //tbl 1
   If FetchElmFNo(RetNo,FNo,10002)='OTH' then SaveDiagnostic(RetNo,'T1135',10002,'E-T1135-Country Code cannot be OTH in Part B-Table 1'); //20160123
   If FetchElmFNo(RetNo,FNo,10007)='OTH' then SaveDiagnostic(RetNo,'T1135',10007,'E-T1135-Country Code cannot be OTH in Part B-Table 1'); //20160123
   If FetchElmFNo(RetNo,FNo,10012)='OTH' then SaveDiagnostic(RetNo,'T1135',10012,'E-T1135-Country Code cannot be OTH in Part B-Table 1'); //20160123
   //tbl 5
   If FetchElmFNo(RetNo,FNo,50002)='OTH' then SaveDiagnostic(RetNo,'T1135',50002,'E-T1135-Country Code cannot be OTH in Part B-Table 5'); //20160123
   If FetchElmFNo(RetNo,FNo,50007)='OTH' then SaveDiagnostic(RetNo,'T1135',50007,'E-T1135-Country Code cannot be OTH in Part B-Table 5'); //20160123
   If FetchElmFNo(RetNo,FNo,50012)='OTH' then SaveDiagnostic(RetNo,'T1135',50012,'E-T1135-Country Code cannot be OTH in Part B-Table 5'); //20160123
   //-----------------------

   If FetchElmFNo(RetNo,FNo,36)+FetchElmFNo(RetNo,FNo,42)='' then      //if not B select A or the election to use B
     SaveDiagnostic(RetNo,'T1135',36,'E-T1135-Please check the appropriate box; Total Cost of foreign property exceeds $100,000 but less than $250,000 OR Total Cost of foreign property is $250,000 or more.');

   If (FetchElmFNo(RetNo,FNo,36)>'') And (FetchElmFNo(RetNo,FNo,86)='') //Strictly A
   then
   begin
    RemoveT1135SectionBdata(RetNo,FNo);   //20160123
    ValidateT1135SectionAData(RetNo,FNo);   //20160123
   end;

  //20180422
  //use section B
   If (FetchElmFNo(RetNo,FNo,42)>'')  // >=$250,000
   Or ((FetchElmFNo(RetNo,FNo,36)>'') And (FetchElmFNo(RetNo,FNo,86)>''))
   then
   Begin
    RemoveT1135SectionAdata(RetNo,FNo);
    ValidateT1135SectionBData(RetNo,FNo);
   end;
  {
   //use section B
   If (FetchElmFNo(RetNo,FNo,42)>'')  // >=$250,000
   Or ((FetchElmFNo(RetNo,FNo,36)>'') And (FetchElmFNo(RetNo,FNo,86)>''))
   then
   Begin
    RemoveT1135SectionAdata(RetNo,FNo);
    ValidateT1135SectionBData(RetNo,FNo);
   end;
   }
  //20180422
    //20180422
   if FetchElmFNo(RetNo,FNo,72)>'' then
    if Length(FetchElmFNo(RetNo,FNo,72))<14 then SaveDiagnostic(RetNo,'T1135',72,'E-T1135-Date must be in the format 9(999)999-9999');

//jz 20240424 - not a date (anymore??)
//   if FetchElmFNo(RetNo,FNo,77)>'' then
//    if Length(FetchElmFNo(RetNo,FNo,77))<14 then SaveDiagnostic(RetNo,'T1135',77,'E-T1135-Date must be in the format 9(999)999-9999');

  end;
end;

//20160523
Procedure ValidateS100(RetNo:Integer;FName:String);
//;Fno:Integer);
Var
  i, FNo: Integer;
  s, S1: String;
  x, X1: Real;
  TempList: TStringList;
Begin
  FNo := GetFormNO(FName);
  If Vl(FetchElmFNo(RetNo,FNo,89)) <> Vl(FetchElmFNo(RetNo,FNo,41)) then
  begin
    //20170612 Added S101
    SaveDiagnostic(RetNo, FName, 89, 'E-'+FName+'-GIFI not balanced (Tot Assets vs Tot Liabilities + Equity');
    SaveDiagnostic(RetNo, FName, 41, 'E-'+FName+'-GIFI not balanced (Tot Assets vs Tot Liabilities + Equity');
  end;
  If Vl(FetchGifiElmFNo(RetNo, FNo, '1061')) > Vl(FetchGifiElmFNo(RetNo, FNo, '1060')) then
    SaveDiagnostic(RetNo,FName,1,'E-'+Fname+'-GIFI line 1061 exceeds line 1060');

   {
    //20170612 Added S101
    SaveDiagnostic(RetNo, 'S100', 89, 'E-S100 or S101-GIFI not balanced (Tot Assets vs Tot Liabilities + Equity');
    SaveDiagnostic(RetNo, 'S100', 41, 'E-S100 or S101-GIFI not balanced (Tot Assets vs Tot Liabilities + Equity');
  end;
  If Vl(FetchGifiElmFNo(RetNo, FNo, '1061')) > Vl(FetchGifiElmFNo(RetNo, FNo, '1060')) then
    SaveDiagnostic(RetNo,'S100',1,'E-S100-GIFI line 1061 exceeds line 1060');
   }

  {//20160523
  //20111130
  If Inversion <'2011.3' then
  Begin
    s := '9975';
    x := Vl(FetchGifiElmFNo(RetNo, FNo, s));
    If (x <> 0) and (Vl(FetchGifiElm(RetNo, 'GIFIIS#1', s)) = 0) then
      SaveDiagnostic(RetNo, 'S100', 1, 'E-GIFI-S125-MISPLACED-Enter line ' + s + ' $' + FloatToStr(x));
    s := '9976';
    x := Vl(FetchGifiElmFNo(RetNo, FNo, s));
    If (x <> 0) and (Vl(FetchGifiElm(RetNo, 'GIFIIS#1', s)) = 0) then
      SaveDiagnostic(RetNo, 'S100', 1, 'E-GIFI-S125-MISPLACED-Enter line ' + s + ' $' + FloatToStr(x));
    s := '9980';
    x := Vl(FetchGifiElmFNo(RetNo, FNo, s));
    If (x <> 0) and (Vl(FetchGifiElm(RetNo, 'GIFIIS#1', s)) = 0) then
      SaveDiagnostic(RetNo, 'S100', 1, 'E-GIFI-S125-MISPLACED-Enter line ' + s + ' $' + FloatToStr(x));
    s := '9985';
    x := Vl(FetchGifiElmFNo(RetNo, FNo, s));
    If (x <> 0) and (Vl(FetchGifiElm(RetNo, 'GIFIIS#1', s)) = 0) then
      SaveDiagnostic(RetNo, 'S100', 1, 'E-GIFI-S125-MISPLACED-Enter line ' + s + ' $' + FloatToStr(x));
    s := '9990';
    x := Vl(FetchGifiElmFNo(RetNo, FNo, s));
    If (x <> 0) and (Vl(FetchGifiElm(RetNo, 'GIFIIS#1', s)) = 0) then
      SaveDiagnostic(RetNo, 'S100', 1, 'E-GIFI-S125-MISPLACED-Enter line ' + s + ' $'+FloatToStr(x));
    s := '9995';
    x := Vl(FetchGifiElmFNo(RetNo, FNo, s));
    If (x <> 0) and (Vl(FetchGifiElm(RetNo, 'GIFIIS#1', s)) = 0) then
      SaveDiagnostic(RetNo, 'S100', 1, 'E-GIFI-S125-MISPLACED-Enter line ' + s + ' $' + FloatToStr(x));
  end;
  }
  //check amortization
  TempList := TstringList.Create;
  try
    TempList.LoadFromFile(IncludeTrailingPathDelimiter(AppDir) + 'Amortization.d');
    For i := 0 to TempList.count - 1 do
    begin
      s := LeftStr(TempList[i], 4);
      S1 := MidStr(TempList[i], 6, 4);
      x := Abs(Vl(FetchGifiElmFNo(RetNo, FNo, S1)));
      If X > 0 then
      begin
        If X > Vl(FetchGifiElmFNo(RetNo, FNo, S)) then
          SaveDiagnostic(RetNo, 'S100', 1, 'E-S100-GIFI amortization ' + S1 + ' cannot exceed line ' + s);
      end;
    end;
  finally
    TempList.Free;
  end;
  //20170609 Igor >>>
  if ExtractNonInstFormName(FName).Equals('S100') or
     ExtractNonInstFormName(FName).Equals('S101') then
  begin
    CheckFormTable(RetNo, FName, 'Current Assets', 1, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Tangible capital assets', 2, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Intangible capital assets', 3, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Long term assets', 4, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Current Liabilities', 5, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Long term liabilities', 6, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Equity', 7, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Dividends and adjustments', 8, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
  end;
  //20170609 igor <<<
End;



(*

//20160523
Procedure ValidateS100(RetNo:Integer;FName:String);
//;Fno:Integer);
Var i,FNo:Integer;s,S1:String;x,X1:Real;
TempList:TStringList;
Begin
  FNo:=GetFormNO(FName);
  If Vl(FetchElmFNo(RetNo,FNo,89)) <> Vl(FetchElmFNo(RetNo,FNo,41)) then
  begin
   SaveDiagnostic(RetNo,'S100',89,'E-S100-GIFI not balanced (Tot Assets vs Tot Liabilities + Equity');
   SaveDiagnostic(RetNo,'S100',41,'E-S100-GIFI not balanced (Tot Assets vs Tot Liabilities + Equity');
  end;

  If Vl(FetchGifiElmFNo(RetNo,FNo,'1061'))
    > Vl(FetchGifiElmFNo(RetNo,FNo,'1060')) then
   SaveDiagnostic(RetNo,'S100',1,'E-S100-GIFI line 1061 exceeds line 1060');

  {//20160523
  //20111130
  If Inversion <'2011.3' then
  Begin
  s:='9975';x:=Vl(FetchGifiElmFNo(RetNo,FNo,s));
  If (x <> 0) and (Vl(FetchGifiElm(RetNo,'GIFIIS#1',s)) = 0) then
   SaveDiagnostic(RetNo,'S100',1,'E-GIFI-S125-MISPLACED-Enter line '+s+' $'+FloatToStr(x));
  s:='9976';x:=Vl(FetchGifiElmFNo(RetNo,FNo,s));
  If (x <> 0) and (Vl(FetchGifiElm(RetNo,'GIFIIS#1',s)) = 0) then
   SaveDiagnostic(RetNo,'S100',1,'E-GIFI-S125-MISPLACED-Enter line '+s+' $'+FloatToStr(x));
  s:='9980';x:=Vl(FetchGifiElmFNo(RetNo,FNo,s));
  If (x <> 0) and (Vl(FetchGifiElm(RetNo,'GIFIIS#1',s)) = 0) then
   SaveDiagnostic(RetNo,'S100',1,'E-GIFI-S125-MISPLACED-Enter line '+s+' $'+FloatToStr(x));

  s:='9985';x:=Vl(FetchGifiElmFNo(RetNo,FNo,s));
  If (x <> 0) and (Vl(FetchGifiElm(RetNo,'GIFIIS#1',s)) = 0) then
      SaveDiagnostic(RetNo,'S100',1,'E-GIFI-S125-MISPLACED-Enter line '+s+' $'+FloatToStr(x));
  s:='9990';x:=Vl(FetchGifiElmFNo(RetNo,FNo,s));
  If (x <> 0) and (Vl(FetchGifiElm(RetNo,'GIFIIS#1',s)) = 0) then
      SaveDiagnostic(RetNo,'S100',1,'E-GIFI-S125-MISPLACED-Enter line '+s+' $'+FloatToStr(x));
  s:='9995';x:=Vl(FetchGifiElmFNo(RetNo,FNo,s));
  If (x <> 0) and (Vl(FetchGifiElm(RetNo,'GIFIIS#1',s)) = 0) then
      SaveDiagnostic(RetNo,'S100',1,'E-GIFI-S125-MISPLACED-Enter line '+s+' $'+FloatToStr(x));
  end;
  }
  //check amortization
  TempList:=TstringList.Create;
  TempList.LoadFromFile(AppDir+'\Amortization.d');
  For i:=0 to TempList.count-1 do
  begin
   s:=LeftStr(TempList[i],4);
   S1:=MidStr(TempList[i],6,4);
   x:=Abs(Vl(FetchGifiElmFNo(RetNo,FNo,S1)));
   If X>0 then
   begin
    If X>Vl(FetchGifiElmFNo(RetNo,FNo,S)) then
      SaveDiagnostic(RetNo,'S100',1,'E-S100-GIFI amortization '+S1+' cannot exceed line '+s);
   end;
  end;
  TempList.Free;
End;
*)


//20160523
Procedure ValidateS101(RetNo:Integer;Fname:String);
Var FNo:Integer;
Begin
  FNo:=GetFormNO(FName);
  If Vl(FetchElmFNo(RetNo,Fno,89)) <> Vl(FetchElmFNo(RetNo,Fno,41)) then
  Begin
   SaveDiagnostic(RetNo,'S101',89,'E-S101-It does not balance (Assets Line 2599 is not equal to Liabilities plus Equity on Line 3640)');
   SaveDiagnostic(RetNo,'S101',41,'E-S101-It does not balance (Assets Line 2599 is not equal to Liabilities plus Equity on Line 3640)');
  End;
End;


//20160523
//logic good for S125#1
Procedure ValidateS125(RetNo:Integer;Fname:String);
Var FNo:Integer;
Begin
  FNo:=GetFormNo(FName);
  if CountMultipleInstances(RetNo,'S125')>1 then
  begin
   if  Vl(FetchElmFNo(RetNo,FNo,65))
      +Vl(FetchElmFNo(RetNo,FNo,68))
      +Vl(FetchElmFNo(RetNo,FNo,71))
      +Vl(FetchElmFNo(RetNo,FNo,74))
      +Vl(FetchElmFNo(RetNo,FNo,77))
      +Vl(FetchElmFNo(RetNo,FNo,80))
      +Vl(FetchElmFNo(RetNo,FNo,83))
     // +Vl(FetchElmFNo(RetNo,FNo,7))  //20170227
       <>0 then
    Begin
     SaveDiagnostic(RetNo,'S125#1',65,'E-S125-Multiple GIFI Income Statements. Summary Income entries must be entered on form S140');
     SaveDiagnostic(RetNo,'S140',4,'W-S125-Multiple GIFI Income Statements. Ensure you complete form S140 before filing'); //typo 20170227
     if (FName>'S125#1') and (FetchElmFNo(RetNo,FNo,5)='') then
     begin
       SaveDiagnostic(RetNo,FName,5,'E-S125-Enter description of operation');
     end;
    End;
  end;

   //20141203
  If Vl(FetchGifiElmFNo(RetNo,FNo,'8141'))<>0 then
  begin
   If Ret[RetNo].FrmHasData[GetFormNo('S7RENT#1')] = False then
     SaveDiagnostic(RetNo,'S7RENT#1',1,'W-GIFI has RE Rental income but no Rental income in S7');
  end;

  If (Vl(FetchGifiElmFNo(RetNo,FNo,'8435'))
    +Vl(FetchGifiElmFNo(RetNo,FNo,'8436'))
    +Vl(FetchGifiElmFNo(RetNo,FNo,'8437'))>0)
  and (Ret[RetNo].FrmHasData[GetFormNo('S51CRN')] = false) then
   SaveDiagnostic(RetNo,'S51CRN',4,'W-Crown charges in GIFI. Review S51-Crown form?');

  If (Vl(FetchGifiElmFNo(RetNo,FNo,'8400'))>0)
  and (Ret[RetNo].FrmHasData[GetFormNo('S51')] = false) then
   SaveDiagnostic(RetNo,'S51',104,'W-Resource costs in GIFI. Review S51 form?');

  //20170612 Igor >>
  if ExtractNonInstFormName(FName).Equals('S125') then
  begin
    CheckFormTable(RetNo, FName, 'Sales of goods and services', 1, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Revenue', 2, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Operating expenses', 3, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Farming revenue', 4, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
    CheckFormTable(RetNo, FName, 'Farming expenses', 5, TIntArr.Create(1, 2),
      TIntArrOfIntArr.Create(TIntArr.Create(1),
                             TIntArr.Create(2)));
  end;
  //20170612 Igor <<<

end;


//T20160523
Procedure ValidateT2(RetNo:Integer);
Var i,FNo:Integer;s:String;
x:Real;
Begin
  FNo:=GetFormNo('T2');
  If Length(FetchElmFNo(RetNo,FNo,1)) <>15 then
    SaveDiagnostic(RetNo,'T2',1,'M-Business No is required (9 digits+RC+0001)');

  if (FetchElmFNo(RetNo,FNo,265)>'')   //substantive
  and (Ret[RetNo].CorpType <> OtherPrivate)  //20250524
  then  //20250524
      SaveDiagnostic(RetNo,'T2',265,'E- SUBSTANTIVE CCPC applicable only for Private Corporations. See T2 Pg1 Type Of Corp');

  if NotPaidFor2018(RetNo) then
    SaveDiagnostic(RetNo,'T2',11,'M-Your T2 program license does not cover year ends beyond 2016/12/31. Please renew your license');

  //20191015 Igor >>>
  if not AppT2.CheckAllowedBN(RetNo, true) then
  Begin
   SaveDiagnostic(RetNo,'T2',1,'M-Business Number may not be matching the BN you ordered');   //20200326
   SaveDiagnostic(RetNo,'T2',11,'M-Year End may not be matching your Order. Change it to match your order');
  End;

  //20221122
  If (Vl(FetchElmFNo(RetNo,FNo,751)) < 1)
  or (Vl(FetchElmFNo(RetNo,FNo,751)) >2) then
    SaveDiagnostic(RetNo,'T2',751,'E-Language of correspondence: Enter 1=English or 2=French (CRA disallows default)');

 //20221115   //put back
  //hhmm requirement  //20170612
  if UpperCase(FetchElmFNo(RetNo,FNo,216)) = 'Y' then
  Begin
   if (FetchElmFNo(RetNo,FNo,14)>'')
   Or (FetchElmFNo(RetNo,FNo,69)>'')
   Or (FetchElmFNo(RetNo,FNo,30)>'')
   Or (FetchElmFNo(RetNo,FNo,36)>'')
   Or (FetchElmFNo(RetNo,FNo,39)>'') Then
   //ok
   Else
   begin
    SaveDiagnostic(RetNo,'T2',216,'E-T2: Time in Fiscal Periods: Optionally enter only if you have Yes in any of the boxes: 63,66,71,72,76');
   end;
  End;


  //20160515  Relocated from below
  If not ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,1)) then
  begin
    SaveDiagnostic(RetNo,'T2',1,'E-Business No invalid:9 digits+RC+0001 OR 9 digits wrong');
  end;

  If Length(FetchElmFNo(RetNo,FNo,74))>0 then  //20131016
  begin
    If Length(FetchElmFNo(RetNo,FNo,74))<>5 then
     SaveDiagnostic(RetNo,'T2',74,'E-Efiler number must be 5 characters');
  end;
  //20130525
  s:=FetchElmFNo(RetNo,FNo,75); //wac
  If s>'' then
  begin
   //If Length(S) <8 then SaveDiagnostic(RetNo,'T2',75,'E-WAC number less than 8 digits'); //20230523
   If FetchElmFNo(RetNo,FNo,74)>'' then
    SaveDiagnostic(RetNo,'T2',75,'W-Return will use this WAC number for Efiling');
  end;

  (* 20170625
  //20160605
  if IsAmendedReturn(RetNo) then
  begin
   if UpperCase(FetchElmFNo(RetNo,FNo,6))='Y' then
     SaveDiagnostic(RetNo,'T2',6,'E-T2-Email information not allowed in Amended returns. Delete it'); //20170305 spelling

   if UpperCase(FetchElmFNo(RetNo,FNo,5))='Y' then
     SaveDiagnostic(RetNo,'T2',5,'E-T2-Email information not allowed in Amended returns. Delete it');  //spelling 20170626
  end;
  *)
  //20130604
  If UpperCase(FetchElmFNo(RetNo,FNo,71))='N' then
     SaveDiagnostic(RetNo,'T2',71,'W-GIFI use has been set to No. Verify');

  //20090927
  s:=FetchElmFNo(RetNo,FNo,12);
  For i:=1 to Length(s) do
  begin
        If (midStr(s,i,1) = ',')
        or (midStr(s,i,1) = '.') then
       SaveDiagnostic(RetNo,'T2',12,'E-Comma and period not allowed in address line');
  end;

  s:=FetchElmFNo(RetNo,FNo,26);
  For i:=1 to Length(s) do
  begin
        If (midStr(s,i,1) = ',')
        or (midStr(s,i,1) = '.') then
       SaveDiagnostic(RetNo,'T2',26,'E-Comma and period not allowed in address line');
  end;


  If IsAmendedReturn(RetNo) then
  Begin
   if FetchElm(RetNo,'T183CP',21)>'' then  //20200131
    SaveDiagnostic(RetNo,'AMEND',11,'W-AMEND- Delete the CONFIRMATION from T183CP and Save return as Ready For EFile');
   If (FetchElm(RetNo,'AMEND',11)='') then
    SaveDiagnostic(RetNo,'AMEND',11,'E-AMEND-Description of amendment changes required');
   If FetchElmFNo(RetNo,FNo,21)>'' then //20130515
    SaveDiagnostic(RetNo,'T2',21,'W-AMENDED. CRA WILL NOT ACT ON MAIL ADDRESS CHANGE');
   If FetchElmFNo(RetNo,FNo,67)>'' then //20130515
    SaveDiagnostic(RetNo,'T2',67,'W-AMENDED. CRA WILL NOT ACT ON BOOKS ADDRESS CHANGE');
   If FetchElm(RetNo,'T2',736)>'' then //20130518
    SaveDiagnostic(RetNo,'T2',736,'W-AMENDED. CRA WILL NOT ACT ON DIRECT DEPOSIT CHANGE');

   SaveDiagnostic(RetNo,'T2',751,'W-AMENDED. IF YOU CHANGED THE LANGUAGE CRA WILL NOT ACT');


  end;


  s:=FetchElmFNo(RetNo,FNo,38);
  For i:=1 to Length(s) do
  begin
        If (midStr(s,i,1) = ',')
        or (midStr(s,i,1) = '.') then
       SaveDiagnostic(RetNo,'T2',38,'E-Comma and period not allowed in address line');
  end;
  If FetchElmFNo(RetNo,FNo,10) < MinStartPeriod then
    SaveDiagnostic(RetNo,'T2',10,
    'M-Fiscal periods allowed: '+MinStartPeriod+ '-'+MaxEndPeriod);

  If (MidStr(FetchElmFNo(RetNo,FNo,10),5,1) <> '/')
  or (MidStr(FetchElmFNo(RetNo,FNo,11),5,1) <> '/') then
    SaveDiagnostic(RetNo,'T2',10,'M-Fiscal periods must have slashes');


  If Length(FetchElmFNo(RetNo,FNo,3)) > 60 then
    SaveDiagnostic(RetNo,'T2',3,'E-Name exceeds 60 characters. Continue on second line');

  (*  20260702
  //20130601       dissolution
  If FetchElmFNo(RetNo,FNo,170) >''  then
  Begin
    If FetchElmFNo(RetNo,FNo,170) <> FetchElmFNo(RetNo,FNo,11) then
     SaveDiagnostic(RetNo,'T2',170,'W-Dissolution date does not match the year end');
  end
  Else
  begin
   If FetchElmFNo(RetNo,FNo,42) > '' then //dissolution
    SaveDiagnostic(RetNo,'T2',170,'E-Please enter dissolution date');
  end;
  *)

   If FetchElmFNo(RetNo,FNo,11) >MaxEndPeriod then
    SaveDiagnostic(RetNo,'T2',11,'E-Fiscal periods allowed: '+MinStartPeriod+ '-'+MaxEndPeriod);

  If IsReturnLocked(RetNo) then
      SaveDiagnostic(RetNo,'STATUS',26,'W-This return is locked against changes');

//  If DateDiff(YYYYMMDDToMMDDYYYY(FetchElmFNo(RetNo,FNo,10)),
//     YYYYMMDDToMMDDYYYY(FetchElmFNo(RetNo,FNo,11)))>371 then
  If DateDiffYMD(FetchElmFNo(RetNo,FNo,10),FetchElmFNo(RetNo,FNo,11))>371 then
   SaveDiagnostic(RetNo,'T2',11,'W-Fiscal period exceeds 371 days');

  If FetchElmFNo(RetNo,FNo,42) >'' then //20130601
  Begin
    SaveDiagnostic(RetNo,'T2',42,'W-Before filing, notify/contact CRA of the dissolution');
  end;


  If FetchElmFNo(RetNo,FNo,28) >'' then //20130608
  Begin
    SaveDiagnostic(RetNo,'T2',10,'W-Visually ensure Start Fiscal period not prior to Incorp.');
  end;

  If FetchElmFNo(RetNo,FNo,30) >'' then //20120604
  Begin
    SaveDiagnostic(RetNo,'T2',10,'W-Visually ensure Start Fiscal period not prior to Incorp.');
  end;

  If ((FetchElmFNo(RetNo,FNo,28) = '') and (FetchElmFNo(RetNo,FNo,29) = '')) then
    SaveDiagnostic(RetNo,'T2',29,'E-Line 070-One of the boxes must me checked');

  If ((FetchElmFNo(RetNo,FNo,30) = '') and (FetchElmFNo(RetNo,FNo,31) = '')) then
    SaveDiagnostic(RetNo,'T2',31,'E-Line 071-One of the boxes must me checked');

  If FetchElmFNo(RetNo,FNo,18) > ''  then
  begin
    If Length(FetchElmFNo(RetNo,FNo,18)) <> 10 then
      SaveDiagnostic(RetNo,'T2',18,'E-Invalid date on field 065');
  end;

  If FetchElmFNo(RetNo,FNo,61) > ''   then
  begin
    If Length(FetchElmFNo(RetNo,FNo,61)) <> 10 then
      SaveDiagnostic(RetNo,'T2',61,'E-Invalid date on field 043');
  end;

  If ((FetchElmFNo(RetNo,FNo,28) > '') or (FetchElmFNo(RetNo,FNo,30) > ''))
  and (FetchElmFNo(RetNo,FNo,67) = '')
   then
    SaveDiagnostic(RetNo,'T2',67,'E-Location of books must be Y(first year,or amalgamation)');

  If Length(FetchElmFNo(RetNo,FNo,12)) > 30 then
    SaveDiagnostic(RetNo,'T2',12,'E-Address on this line cannot exceed 30 characters');
  If Length(FetchElmFNo(RetNo,FNo,13)) > 30 then
    SaveDiagnostic(RetNo,'T2',13,'E-Address on this line cannot exceed 30 characters');

  If Length(FetchElmFNo(RetNo,FNo,26)) > 30 then
    SaveDiagnostic(RetNo,'T2',26,'E-Address on this line cannot exceed 30 characters');
  If Length(FetchElmFNo(RetNo,FNo,27)) > 30 then
    SaveDiagnostic(RetNo,'T2',27,'E-Address on this line cannot exceed 30 characters');

  If Length(FetchElmFNo(RetNo,FNo,38)) > 30 then
    SaveDiagnostic(RetNo,'T2',38,'E-Address on this line cannot exceed 30 characters');
  If Length(FetchElmFNo(RetNo,FNo,41)) > 30 then
    SaveDiagnostic(RetNo,'T2',41,'E-Address on this line cannot exceed 30 characters');


  If FetchElmFNo(RetNo,FNo,3) = '' then
     SaveDiagnostic(RetNo,'T2',3,'M-Corp Name missing');


  If (Ret[Retno].Province = 'OC')
  and (FetchElmFNo(RetNo,FNo,48)>'') then
    SaveDiagnostic(RetNo,'T2',48,'W-T2-Jurisdiction Outside Canada. Is it a non-resident?');

  If FetchElmFNo(RetNo,FNo,10) > FetchElmFNo(RetNo,FNo,11) then
    SaveDiagnostic(RetNo,'T2',11,'M-T2-Year end earlier than start year');

  If FetchElmFNo(RetNo,FNo,14) > '' then
  begin
    If FetchElmFNo(RetNo,FNo,18) = '' then
     SaveDiagnostic(RetNo,'T2',18,'E-T2-Date control aquired required');
  end;

  If (IsCanadianProvince(FetchElmFNo(RetNo,FNo,17)))
  and (FetchElmFNo(RetNo,FNo,19) <>'') then
    SaveDiagnostic(RetNo,'T2',19,'E-T2-Prov/Country inconsistent');

  If (IsCanadianProvince(FetchElmFNo(RetNo,FNo,33)))
  and (FetchElmFNo(RetNo,FNo,34) <>'') then  {country}
    SaveDiagnostic(RetNo,'T2',34,'E-T2-Prov/Country inconsistent');

  If (IsCanadianProvince(FetchElmFNo(RetNo,FNo,45)))
  and (FetchElmFNo(RetNo,FNo,46) <>'') then  {country}
    SaveDiagnostic(RetNo,'T2',46,'E-T2-Prov/Country inconsistent');

  If FetchElmFNo(RetNo,FNo,49) > '' then
  begin
    If FetchElmFNo(RetNo,FNo,50) = '' then
     SaveDiagnostic(RetNo,'T2',50,'E-T2-Foreign country required');
  end;

  If FetchElmFNo(RetNo,FNo,57) > '' then
  begin
    If FetchElmFNo(RetNo,FNo,60) = '' then
     SaveDiagnostic(RetNo,'T2',60,'E-T2-Corp type description required');
  end;

  If (UpperCase(FetchElmFNo(RetNo,FNo,8)) = 'X') then
  Begin
   If (FetchElmFNo(RetNo,FNo,12) = '')
      or (FetchElmFNo(RetNo,FNo,16) = '')
      or ((FetchElmFNo(RetNo,FNo,17) = '') and (FetchElmFNo(RetNo,FNo,19) = ''))
      or (FetchElmFNo(RetNo,FNo,20) = '')
      then
      SaveDiagnostic(RetNo,'T2',20,'E-T2-Corp Address not complete');
  end;
  If (FetchElmFNo(RetNo,FNo,20) > '') then
  begin
   If ValidPostal(RetNo,FetchElmFNo(RetNo,FNo,20),FetchElmFNo(RetNo,FNo,19)) = False then
    SaveDiagnostic(RetNo,'T2',20,'M-T2-Postal-Enter as ANA NAN (or ZIP as 5 or 9 digits');
  end;


 If (FetchElmFNo(RetNo,FNo,47) > '') then
  begin
   If ValidPostal(RetNo,FetchElmFNo(RetNo,FNo,47),FetchElmFNo(RetNo,FNo,46)) = False then
    SaveDiagnostic(RetNo,'T2',47,'M-T2-Postal-Enter as ANA NAN (or US ZIP as 5 or 9 digits');
  end;

  If FetchElmFNo(RetNo,FNo,35) > '' then
  begin
   If ValidPostal(RetNo,FetchElmFNo(RetNo,FNo,35),FetchElmFNo(RetNo,FNo,34)) = False then
    SaveDiagnostic(RetNo,'T2',35,'M-T2-Postal-Enter as ANA NAN (or US ZIP as 5 or 9 digits');
  end;

  If Length(FetchElmFNo(RetNo,FNo,1)) =9 then
  begin
    StoreElm(RetNo,FNo,1,FetchElm(RetNo,'T2',1)+'RC0001');
    SaveDiagnostic(RetNo,'T2',1,'W-T2-Business No extended to full 15 characters. Inspect');
  end;

  If FetchElmFNo(RetNo,FNo,62) ='' then
  begin
   SaveDiagnostic(RetNo,'T2',62,'W-T2-Industry Type required or N/A');
  end;

  If (FetchElmFNo(RetNo,FNo,10) = '')
   and (FetchElmFNo(RetNo,FNo,11) = '') then
    SaveDiagnostic(RetNo,'T2',5,'M-T2-Year-end missing');

  If FetchElmFNo(RetNo,FNo,21) >'' then
  begin
   If (FetchElmFNo(RetNo,FNo,26) = '')
   or (FetchElmFNo(RetNo,FNo,32) = '')
   or (FetchElmFNo(RetNo,FNo,35) = '')
   or ((FetchElmFNo(RetNo,FNo,33) = '')
       and (FetchElmFNo(RetNo,FNo,34) = ''))
    then
    SaveDiagnostic(RetNo,'T2',26,'E-T2-Mailing address incomplete');
  end;


  If (FetchElmFNo(RetNo,FNo,67) > '') then
  begin
   If (FetchElmFNo(RetNo,FNo,38) = '') then
    SaveDiagnostic(RetNo,'T2',38,'E-T2-Books/records info not completed');
   If (FetchElmFNo(RetNo,FNo,44) = '') then
     SaveDiagnostic(RetNo,'T2',44,'E-T2-Books/records info not completed');

   If (FetchElmFNo(RetNo,FNo,45) = '')   //postal
   and ((FetchElmFNo(RetNo,FNo,46) = '') OR (FetchElmFNo(RetNo,FNo,46) = 'US')) //country=canda or US  //20140113
   then SaveDiagnostic(RetNo,'T2',45,'E-T2-Books/records info not completed');

   If (FetchElmFNo(RetNo,FNo,47) = '') then
   SaveDiagnostic(RetNo,'T2',47,'E-T2-Books/records info not completed');
  end;

  If Ret[RetNo].DaysInYear < 365 then
      SaveDiagnostic(RetNo,'T2',11,'W-T2-Fiscal year < 365 days. Amounts will be prorated');

  If (Ret[RetNo].Province = 'MJ')
   and (Vl(FetchElm(RetNo,'S5',270))+Vl(FetchElm(RetNo,'S5',272))=0) then
          SaveDiagnostic(RetNo,'S5',104,'W-Multiple Jurisdiction. Please complete S5');

  FNo:=GetFormNo('T2');

  //20151025
  If (IsInactive(RetNo)=False) then
  Begin
   If (Length(FetchElm(RetNo,'T2',203))<>6)
   Or (Numeric(FetchElm(RetNo,'T2',203))=false)
   or (ValidNaics(FetchElm(RetNo,'T2',203))=False)
   then
     SaveDiagnostic(RetNo,'T2',203,'E-T2-A valid NAICS code is required');
  end;
  //------
  x:= Vl(FetchElmFNo(RetNo,FNo,209))+
       Vl(FetchElmFNo(RetNo,FNo,211))+
       Vl(FetchElmFNo(RetNo,FNo,213));

   If x<>100 then SaveDiagnostic(RetNo,'T2',209,'W-T2-Principal products do not equal 100%');
   If x>100 then SaveDiagnostic(RetNo,'T2',209,'E-T2-Principal products % exceeds 100%');  //20121205

   If (FetchElmFNo(RetNo,FNo,208)>'') and (vl(FetchElmFNo(RetNo,FNo,209))=0) then
     SaveDiagnostic(RetNo,'T2',209,'E-T2-Principal product % required');

   If FetchElmFNo(RetNo,FNo,761)='' then
      SaveDiagnostic(RetNo,'T2',761,'E-T2-Corp Type Change-Enter Yes or No');

  If (UpperCase(FetchElmFNo(RetNo,FNo,761))='Y') and (FetchElmFNo(RetNo,FNo,61)='') then  //20121205
     SaveDiagnostic(RetNo,'T2',61,'E-T2-Enter date of Corporate type change');


  If (UpperCase(FetchElmFNo(RetNo,FNo,761))<>'Y') and (FetchElmFNo(RetNo,FNo,61)>'') then  //20121205
     SaveDiagnostic(RetNo,'T2',61,'E-T2-Enter date only if Corporate type changed');

  If FetchElmFNo(RetNo,FNo,762)='' then
      SaveDiagnostic(RetNo,'T2',762,'E-T2- Yes/No required for B/N of prior years');

   If UpperCase(FetchElmFNo(RetNo,FNo,762))='N' then
   Begin
    If (FetchElmFNo(RetNo,FNo,28)='') and (FetchElmFNo(RetNo,FNo,30)='') then  //20121205
      SaveDiagnostic(RetNo,'T2',28,'E-T2-Box 71 or 72 must be set to Yes');
   end;

   If (FetchElmFNo(RetNo,FNo,210)>'') and (vl(FetchElmFNo(RetNo,FNo,211))=0) then
     SaveDiagnostic(RetNo,'T2',210,'E-T2-Principal product % required');

   If (FetchElmFNo(RetNo,FNo,212)>'') and (vl(FetchElmFNo(RetNo,FNo,213))=0) then
     SaveDiagnostic(RetNo,'T2',213,'E-T2-Principal product % required');

 (* 20111020
  If (UpperCase(FetchElm(RetNo,'T2',203)) ='X')
  and (FetchElm(RetNo,'T2',205) ='')  then
  begin
   SaveDiagnostic(RetNo,'T2',205,'E-Major business activity missing');
  end;
 *)
  //Pg8
  FNo:=GetFormNo('T2');


  If Vl(FetchElmFNo(RetNo,FNo,730))>=0 then //no overpayment
  begin
    If FetchElmFNo(RetNo,FNo,731)>'' then  //20260416
       SaveDiagnostic(RetNo,'T2',731,'E-There is no overpayment. Remove refund code');
  end;

  If (Vl(FetchElmFNo(RetNo,FNo,730)) <0) //overpayment
  and (FetchElmFNo(RetNo,FNo,731)='')  then
   SaveDiagnostic(RetNo,'T2',731,'E-Refund code 1,2,3 required');

  {
  If Vl(FetchElmFNo(RetNo,FNo,732))=0 then
  begin
    If FetchElmFNo(RetNo,FNo,731)>'' then  //20100530
     SaveDiagnostic(RetNo,'T2',731,'E-There is overpayment. Remove refund code');
  end;
  }
  If AllTrim(FetchElmFNo(RetNo,FNo,745)) ='' then
    SaveDiagnostic(RetNo,'T2',745,'E-Signatute date is required');
  If FetchElmFNo(RetNo,FNo,745) < FormatDateTime('yyyy/mm/dd',Now) then
    SaveDiagnostic(RetNo,'T2',745,'W-Federal signing date older than today');
  If ValidT2Date(FetchElmFNo(RetNo,FNo,745)) = false then
    SaveDiagnostic(RetNo,'T2',745,'E-Signing date is invalid');

  If FetchElmFNo(RetNo,FNo,737)>'' then  //branch
  begin
   If (Length(FetchElmFNo(RetNo,FNo,737))<>5)
   or (Not Numeric(FetchElmFNo(RetNo,FNo,737)))
    then
     SaveDiagnostic(RetNo,'T2',737,'E-Page-8 Branch must be 5 numbers');
  end;

  If FetchElmFNo(RetNo,FNo,738)>'' then
  begin
   If (Length(FetchElmFNo(RetNo,FNo,738))<>3)
   or (Not Numeric(FetchElmFNo(RetNo,FNo,738)))
    then
     SaveDiagnostic(RetNo,'T2',738,'E-Page-8 Institution must be 3 numbers');
  end;

  If (FetchElmFNo(RetNo,FNo,742) ='')
  or (FetchElmFNo(RetNo,FNo,743) ='')
  or (FetchElmFNo(RetNo,FNo,744) ='') then
  begin
   SaveDiagnostic(RetNo,'T2',742,'E-Signing Officer info not completed');
   SaveDiagnostic(RetNo,'T2',743,'E-Signing Officer info not completed');
   SaveDiagnostic(RetNo,'T2',744,'E-Signing Officer info not completed');
  end;

  If IsAlpha(FetchElmFNo(RetNo,FNo,742)) =False then SaveDiagnostic(RetNo,'T2',742,'E-Signing Last Name must have alpha characters only');
  If IsAlpha(FetchElmFNo(RetNo,FNo,743)) =False then SaveDiagnostic(RetNo,'T2',743,'E-Signing First Name must have alpha characters only');
  If IsAlpha(FetchElmFNo(RetNo,FNo,744)) =False then SaveDiagnostic(RetNo,'T2',744,'E-Signing Officer Position must have alpha characters only');

  If (FetchElmFNo(RetNo,FNo,755)+FetchElmFNo(RetNo,FNo,746) ='')
  and (FetchElmFNo(RetNo,FNo,756)+FetchElmFNo(RetNo,FNo,750) ='') then
  begin
   SaveDiagnostic(RetNo,'T2',755,'E-Contact telephone is required');
   SaveDiagnostic(RetNo,'T2',746,'E-Contact telephone is required');
  end;

  If FetchElmFNo(RetNo,FNo,755)>'' then
  begin
   If (Numeric(FetchElmFNo(RetNo,FNo,755)) = false)
   or (Length(FetchElmFNo(RetNo,FNo,755)) <> 3)  then
     SaveDiagnostic(RetNo,'T2',755,'E-Phone area must be 3 digits');
  end;

  If FetchElmFNo(RetNo,FNo,746) >'' then
  begin
   If ValidPhoneNo(FetchElmFNo(RetNo,FNo,746)) = false  then
    SaveDiagnostic(RetNo,'T2',746,'E-Phone must be nnn-nnnn');
  end;

  If FetchElmFNo(RetNo,FNo,747) >'' then  //same contact
  begin
   If (FetchElmFNo(RetNo,FNo,746) >'')
   and (FetchElmFNo(RetNo,FNo,755) ='') then
   SaveDiagnostic(RetNo,'T2',755,'E-Area code required');

   If (FetchElmFNo(RetNo,FNo,755) >'')
   and (FetchElmFNo(RetNo,FNo,746) ='') then
   SaveDiagnostic(RetNo,'T2',746,'E-Phone number required');
  end;

  If FetchElmFNo(RetNo,FNo,756)>'' then
  begin
   If (Numeric(FetchElmFNo(RetNo,FNo,756)) = false)
   or (Length(FetchElmFNo(RetNo,FNo,756)) <> 3)  then
     SaveDiagnostic(RetNo,'T2',756,'E-Phone area must be 3 digits');
  end;

  If FetchElmFNo(RetNo,FNo,750) >'' then
  begin
   If ValidPhoneNo(FetchElmFNo(RetNo,FNo,750)) = false  then
    SaveDiagnostic(RetNo,'T2',750,'E-Phone must be nnn-nnnn');
  end;

  If FetchElmFNo(RetNo,FNo,748) >'' then //diffrent contact
  begin
   If (FetchElmFNo(RetNo,FNo,750) >'')
   and (FetchElmFNo(RetNo,FNo,756) ='') then
    SaveDiagnostic(RetNo,'T2',756,'E-Area code required');

   If (FetchElmFNo(RetNo,FNo,756) >'')
   and (FetchElmFNo(RetNo,FNo,750) ='') then
    SaveDiagnostic(RetNo,'T2',750,'E-Phone number required');
  end;


  If (UpperCase(FetchElmFNo(RetNo,FNo,748)) ='X')
  and (FetchElmFNo(RetNo,FNo,749) ='')  then
  begin
   SaveDiagnostic(RetNo,'T2',749,'E-Contact info missing');
  end;

  If (UpperCase(FetchElmFNo(RetNo,FNo,748)) ='X')
  and (FetchElmFNo(RetNo,FNo,756)+FetchElmFNo(RetNo,FNo,750) ='')  then
   SaveDiagnostic(RetNo,'T2',756,'E-Contact phone missing');

  //20170520
  If (UpperCase(FetchElmFNo(RetNo,FNo,748)) ='X')
  and (FetchElmFNo(RetNo,FNo,750)='')  then
   SaveDiagnostic(RetNo,'T2',750,'E-Contact phone missing');

  (*
  If (Vl(FetchElmFNo(RetNo,FNo,730)) <0)
  and (FetchElmFNo(RetNo,FNo,731)='')  then
   SaveDiagnostic(RetNo,'T2',731,'E-Refund code 1,2,3 required');

  //20180503
  If Vl(FetchElmFNo(RetNo,FNo,627)) <> Vl(FetchElmFNo(RetNo,FNo,628))* 20/100 //ln 620 must me 20% of Ln 624
  then
   SaveDiagnostic(RetNo,'T2',628,'W-Line 620 must be 20% of Line 627');
  *)
End;

//20170909 Igor>>>
(*
//20170130
Procedure ValidateNovDecLicenses(RetNo:Integer);
// people given extension to end of December
begin
 EXIT;
{
 If GetTaxationYearEnd(RetNo) > '20161031' then
 Begin
   //20170130
   If (LeftStr(AKey,19) = 'T206-8815-7835-1706')   //nick the dog
   Or (LeftStr(AKey,19) = 'T204-6934-6163-1285')  //dba acointing
   Or (LeftStr(AKey,19) = 'T201-4098-3642-0945')  //Igor kyrych
   Or (LeftStr(AKey,19) = 'T201-1751-1557--0853') //bill hummel
   Or (LeftStr(AKey,19) = 'T204-4992-4437-1385')  //arrashaad
   Then
   SaveDiagnostic(RetNo,'T2',11,'M-Your program license does not cover fiscal periods entered');
 End;
 }
End;
*)
//20170909 Igor<<<




Procedure ValidateT106(RetNo:Integer);
Var
  s:string;
  i,T106FNo:Integer;
Begin

 //20171126
 T106FNo:=GetFormNo('T106');
 If UpperCase(FetchElmFNo(RetNo,T106FNo,61))<>'Y' then exit;

 //Section 1- Reporting Person/Partnership Identification ----------------------

 If FetchElmFNo(RetNo,T106FNo,5) ='' then  SaveDiagnostic(RetNo,'T106',5,'E-T106-Summary Information Section 1, Corporation Name required');
 If FetchElmFNo(RetNo,T106FNo,6) ='' then  SaveDiagnostic(RetNo,'T106',6,'E-T106-Summary Information Section 1, Business Number required');
 If FetchElmFNo(RetNo,T106FNo,23)=' 'then  SaveDiagnostic(RetNo,'T106',23,'E-T106-Street Address is required');
 If FetchElmFNo(RetNo,T106FNo,24)='' then  SaveDiagnostic(RetNo,'T106',24,'E-T106-Summary - City is required”');
 If FetchElmFNo(RetNo,T106FNo,25)='' then  SaveDiagnostic(RetNo,'T106',25,'E-T106-Summary - Province or territory is required');
 If FetchElmFNo(RetNo,T106FNo,26)='' then  SaveDiagnostic(RetNo,'T106',26,'E-T106-Summary - Postal or Zip code is required');
 If FetchElmFNo(RetNo,T106FNo,2) ='' then  SaveDiagnostic(RetNo,'T106',2,'E-Summary - Country is required');  //20230110 CON

 //Section 2 – Summary Information ---------------------------------------------

 //'Summary – Section 2, Question 1: Taxation Year “To” and "From" Date required'

 s := FetchElmFNo(RetNo,T106FNo,29) + FetchElmFNo(RetNo,T106FNo,30);
 If s = '' then
   SaveDiagnostic(RetNo,'T106',39,'E-T106-Summary – Section 2, Question 2: Yes or No is required for “Is this the first time you have filed a T106 form?');

 If FetchElmFNo(RetNo,T106FNo,30)>'' then
  If FetchElmFNo(RetNo,T106FNo,31)='' then SaveDiagnostic(RetNo,'T106',31,'E-T106-Summary – Section 2, Question 2: Date of last tax year/fiscal period end reporting person/partnership filed a T106 is required');

 If Vl(FetchElmFNo(RetNo,T106FNo,32))=0 then
   SaveDiagnostic(RetNo,'T106',32,'E-T106-Summary – Section 2: T106 slips need to be prepared');

 s := FetchElmFNo(RetNo,T106FNo,35) + FetchElmFNo(RetNo,T106FNo,36) + FetchElmFNo(RetNo,T106FNo,37) + FetchElmFNo(RetNo,T106FNo,38);
 If s='' then //If FetchElmFNo(RetNo,T106FNo,35)='' then
  SaveDiagnostic(RetNo,'T106',35,'E-T106-Summary – Section 2: At least 1 NAICS code is required');

 s := FetchElmFNo(RetNo,T106FNo,39) + FetchElmFNo(RetNo,T106FNo,40);
 If s = '' then
   SaveDiagnostic(RetNo,'T106',39,'E-T106-Summary – Section 2, Question 7: Yes or No is required');

 //'Summary – Section 2, Question 8: Yes or No is required'
 //'Summary – Section 2, Question 9.1: Yes or No is required'
 If (FetchElmFNo(RetNo,T106FNo,66)>'') and (FetchElmFNo(RetNo,T106FNo,67)='') then //jz 20241206 add and condition //If FetchElmFNo(RetNo,T106FNo,35)='' then
  SaveDiagnostic(RetNo,'T106',67,'E-T106-Summary – Section 2, Question 9.2: Country Code is required');

 //'Summary – Section 2, Question 10.1: Name of the MNE group'
 If (FetchElmFNo(RetNo,T106FNo,68)>'') and (FetchElmFNo(RetNo,T106FNo,73)='')then //jz 20241206 add and condition  //If FetchElmFNo(RetNo,T106FNo,35)='' then
  SaveDiagnostic(RetNo,'T106',73,'E-T106-Summary – Section 2, Question 10.2: Name of the MNE group is required');

 //'Summary – Section 2, Question 10.3: Yes or No is required'
 If (FetchElmFNo(RetNo,T106FNo,70)>'') and (FetchElmFNo(RetNo,T106FNo,72)='') then //jz 20241206 add and condition  //If FetchElmFNo(RetNo,T106FNo,35)='' then
  SaveDiagnostic(RetNo,'T106',72,'E-T106-Summary – Section 2, Question 10.4: Jurisdiction where the CbCR is filed is required');

 //If FetchElmFNo(RetNo,T106FNo,X) ='' then  SaveDiagnostic(RetNo,'T106',X,'

 //'Summary – Section 3, Question 1: Yes or No is required'
 //'Summary – Section 3, Question 2: Yes or No is required'


 If FetchElmFNo(RetNo,T106FNo,45)>'' then
 Begin
   If FetchElmFNo(RetNo,T106FNo,47)+FetchElmFNo(RetNo,T106FNo,48)='' then
   begin
    SaveDiagnostic(RetNo,'T106',47,'E-T106 - At least one account number is required');
    SaveDiagnostic(RetNo,'T106',48,'E-T106 - At least one account number is required');
   end;
 End;

 s := FetchElmFNo(RetNo,T106FNo,47) + FetchElmFNo(RetNo,T106FNo,48)+FetchElmFNo(RetNo,T106FNo,74) + FetchElmFNo(RetNo,T106FNo,75)+FetchElmFNo(RetNo,T106FNo,76) + FetchElmFNo(RetNo,T106FNo,77);
 If (FetchElmFNo(RetNo,T106FNo,45)>'')
  and (s='') then
   SaveDiagnostic(RetNo,'T106',47,'E-T106-Enter primary account(s)');

 for i:=53 to 59 do
 begin
  If FetchElmFNo(RetNo,T106FNo,i)='' then
    SaveDiagnostic(RetNo,'T106',i,'E-T106-Full Certification data are required');
 end;
End;

//20171126
Procedure ValidateT106SL(RetNo:Integer);
Var i, SlipFNo:Integer;SlFName:String;
Begin
 If UpperCase(FetchElm(RetNo,'T106',61))<>'Y' then Exit; //do not validate

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName = 'T106SL' then
   begin
     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
     begin
      SlFName:=FRec.FormName+Frec.FormInst;
      SlipFNo:=FRec.FormNo;
      //SlipFormInst:=FRec.FormInst;
      If FetchElmFNo(RetNo,SlipFNo,10)>'' then ValidateAT106Slip(RetNo,SlFName,SlipFNo);
      end;
   end;
 End; //flist
End;

Procedure ValidateAT106SLip(RetNo:Integer;SlFName:String;SlipFNo:Integer);
Var i:Integer; s:string;
Begin
 //20171201
 if FetchElmFNo(RetNo,SlipFNo,10)>'' then   //name entered
 Begin
  If FetchElmFNo(RetNo,SlipFNo,110)='' then //action
  begin
   SaveDiagnostic(RetNo,SlFName,110,'E-T106 Slip - Enter action code');
  end;

  If (LeftStr(FetchElmFNo(RetNo,SlipFNo,110),1)='4')  //delete slip
  and (FetchElmFNo(RetNo,SlipFNo,175)='') then  //delete reason
   SaveDiagnostic(RetNo,SlFName,175,'E-T106 Slip - Enter reason for deleting Country code'); //20171201

   If FetchElmFNo(RetNo,SlipFNo,10)='' then
    SaveDiagnostic(RetNo,SlFName,10,'E-T106 Slip - Enter Non resident Name');

  If FetchElmFNo(RetNo,SlipFNo,11)='' then
    SaveDiagnostic(RetNo,SlFName,11,'E-T106 Slip - Residence address is required');

  If FetchElmFNo(RetNo,SlipFNo,13)='' then
    SaveDiagnostic(RetNo,SlFName,13,'E-T106 Slip - Country Code is required');

  s := FetchElmFNo(RetNo,SlipFNo,185)+FetchElmFNo(RetNo,SlipFNo,186)+FetchElmFNo(RetNo,SlipFNo,187)+FetchElmFNo(RetNo,SlipFNo,188)+FetchElmFNo(RetNo,SlipFNo,189);
  If s='' then SaveDiagnostic(RetNo,SlFName,185,'E-T106 Slip - “Type of non-resident under foreign law governing the non-resident” is required.');

  s := FetchElmFNo(RetNo,SlipFNo,14)+FetchElmFNo(RetNo,SlipFNo,15)+FetchElmFNo(RetNo,SlipFNo,16)+FetchElmFNo(RetNo,SlipFNo,190);
  If s='' then SaveDiagnostic(RetNo,SlFName,14,'E-T106 Slip - Type of Relationship is required');

  //If  (FetchElmFNo(RetNo,SlipFNo,14)>'') why is this? is Mandatory regardless //jz 20241127
  if (FetchElmFNo(RetNo,SlipFNo,17)+FetchElmFNo(RetNo,SlipFNo,18)='')
   then SaveDiagnostic(RetNo,SlFName,17,'E-T106 Slip -  "Is the non-resident treated differently for tax purposes in its jurisdiction of residency than the classification in question 4?" is required');

  //jz 20240725
  if not (FetchElmFNo(RetNo,SlipFNo,17).IsEmpty) then
  begin
    SaveDiagnostic(RetNo,SlFName,17,
    'W-T106 Slip - You have selected “Yes” “the question “if (1), is the non-resident in a country with which Canada does not have ' +
    'a tax treaty?” on the T106 Slip (Part II, question 3). Do you want to submit the supporting documentation ' +
    'electronically? If yes, you must attach the financial statements of the non-resident file(s) now.');
  end;

  If FetchElmFNo(RetNo,SlipFNo,19)+FetchElmFNo(RetNo,SlipFNo,20)+FetchElmFNo(RetNo,SlipFNo,21)+FetchElmFNo(RetNo,SlipFNo,22)=''
   then
    SaveDiagnostic(RetNo,SlFName,19,'E-T106 Slip - At least 1 valid NAICS code is required');

  If FetchElmFNo(RetNo,SlipFNo,24)+FetchElmFNo(RetNo,SlipFNo,25)+FetchElmFNo(RetNo,SlipFNo,26)+FetchElmFNo(RetNo,SlipFNo,27)=''
   then
    SaveDiagnostic(RetNo,SlFName,24,'E-T106 Slip - At least 1 Country Code is required');

  s := FetchElmFNo(RetNo,SlipFNo,28)+FetchElmFNo(RetNo,SlipFNo,29);
  If s='' then
    SaveDiagnostic(RetNo,SlFName,28,'E-T106 Slip - Please select Yes or No');

  s := FetchElmFNo(RetNo,SlipFNo,30)+FetchElmFNo(RetNo,SlipFNo,31);
  If s='' then
    SaveDiagnostic(RetNo,SlFName,30,'E-T106 Slip - Please select Yes or No');

 End;

End;

 //20180703
Procedure ValidateT1134(RetNo:Integer;Fno:Integer); //20230510 Igor
var ArrayNo, BoxesPerRow, RowCount, I, Elm: integer;
    Value: string;
    UniqueList: TStringList;

    function MandatoryCheck(AElmId: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElmId)='' then
      begin
        SaveDiagnostic(RetNo,'T1134',AElmId,'E-T1134-'+ AError);
        Result := false;
      end;
    end;

    function MandatoryYesNoCheck(AElm1Id, AElm2Id: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElm1Id) + FetchElmFNo(RetNo,FNo,AElm2Id) = '' then
      begin
        SaveDiagnostic(RetNo,'T1134',AElm1Id,'E-T1134-'+ AError);
        Result := false;
      end;
    end;

Begin
  UniqueList := TStringList.Create;
  try
    if Ret[RetNo].FrmHasData[FNo] then
    begin
      MandatoryCheck(25, 'Action is required'); //20230601 Igor
      If FetchElmFNo(RetNo,FNo,31) + FetchElmFNo(RetNo,FNo,32) = '' then
        SaveDiagnostic(RetNo,'T1134',31,'E-T1134-You must specify if the T1134 Summary is filed for one entity or a group');
      MandatoryCheck(30, 'Address number is required');
      MandatoryCheck(15, 'Street Address is required');
      MandatoryCheck(16, 'City is required');
      MandatoryCheck(17, 'Province or territory is required');
      if MandatoryCheck(18, 'Postal or Zip code is required') then
        if not ValidPostal(RetNo, FetchElmFNo(RetNo,FNo,18), FetchElmFNo(RetNo,FNo,141)) then
          SaveDiagnostic(RetNo,'T1134',18,'E-T1134-Postal-Invalid Format of Postal/Zip code, please try again');
      MandatoryCheck(141, 'Country is required');
      If FetchElmFNo(RetNo,FNo,40) + FetchElmFNo(RetNo,FNo,41) + FetchElmFNo(RetNo,FNo,42) + FetchElmFNo(RetNo,FNo,43) = '' then
        SaveDiagnostic(RetNo,'T1134',40,'E-T1134-At least 1 valid NAICS code is required');
      MandatoryCheck(19, 'Taxation Year “From” Date is required');
      MandatoryCheck(20, 'Taxation Year “To” Date is required');
      MandatoryYesNoCheck(21, 22, 'YES or NO is required');

      MandatoryCheck(143, 'First Name is required');
      MandatoryCheck(144, 'Last Name is required');
      If FetchElmFNo(RetNo,FNo,145) + FetchElmFNo(RetNo,FNo,146) = '' then
        SaveDiagnostic(RetNo,'T1134',145,'E-T1134-Telephone Number is required');
      MandatoryCheck(23, 'Certifier Name is required');
      MandatoryCheck(147, 'Date of signature is required');
      MandatoryCheck(148, ' Title of Certifier is required');

      UniqueList.Add(FetchElmFNo(RetNo,FNo,8));

      // individuals check
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'First name of Individual within related group is required');
        MandatoryCheck(Elm + 2, 'Initial of Individual within related group is required'); //20230619 Igor
        MandatoryCheck(Elm + 3, 'Last name of Individual within related group is required');
        MandatoryCheck(Elm + 4, 'Address number is required');
        MandatoryCheck(Elm + 5, 'Street is required');
        MandatoryCheck(Elm + 6, 'City is required');
        MandatoryCheck(Elm + 7, 'Province/Territory is required');
        MandatoryCheck(Elm + 8, 'Postal Code is required');
        MandatoryCheck(Elm + 9, 'Country Code is required');
        if MandatoryCheck(Elm + 10, 'SIN is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 10);
          if not ValidSin(Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 10,'E-T1134-SIN is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 10,'E-T1134-SIN is already used in the list')
          else
            UniqueList.Add(Value);
        end;

        Elm := Elm + BoxesPerRow;
      end;

      // corporation check
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of Corporations within related group is required');
        MandatoryCheck(Elm + 2, 'Address number is required');
        MandatoryCheck(Elm + 3, 'Street is required');
        MandatoryCheck(Elm + 4, 'City is required');
        MandatoryCheck(Elm + 5, 'Province/Territory is required');
        MandatoryCheck(Elm + 6, 'Postal Code is required');
        MandatoryCheck(Elm + 7, 'Country Code is required');
        if MandatoryCheck(Elm + 8, 'Business Number is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 8);
          if not ValidBusNumber(RetNo, Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Business Number is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Business Number is already used in the list')
          else
            UniqueList.Add(Value);
        end;
        if FetchElmFNo(RetNo,FNo,Elm + 9) + FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12) = '' then
          SaveDiagnostic(RetNo,'T1134',Elm + 9,'E-T1134-At least 1 valid NAICS code is required');

        Elm := Elm + BoxesPerRow;
      end;

      // trust check
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of Trusts within related group is required');
        MandatoryCheck(Elm + 2, 'Address number is required');
        MandatoryCheck(Elm + 3, 'Street is required');
        MandatoryCheck(Elm + 4, 'City is required');
        MandatoryCheck(Elm + 5, 'Province/Territory is required');
        MandatoryCheck(Elm + 6, 'Postal Code is required');
        MandatoryCheck(Elm + 7, 'Country Code is required');
        if MandatoryCheck(Elm + 8, 'Trust Account Number is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 8);
          if not IsValidTrustNo(Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Trust Account Number is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Trust Account Number is already used in the list')
          else
            UniqueList.Add(Value);
        end;
        if FetchElmFNo(RetNo,FNo,Elm + 9) + FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12) = '' then
          SaveDiagnostic(RetNo,'T1134',Elm + 9,'E-T1134-At least 1 valid NAICS code is required');

        Elm := Elm + BoxesPerRow;
      end;

      // partnership check
      ArrayNo := 4;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of Partnerships within related group is required');
        MandatoryCheck(Elm + 2, 'Address number is required');
        MandatoryCheck(Elm + 3, 'Street is required');
        MandatoryCheck(Elm + 4, 'City is required');
        MandatoryCheck(Elm + 5, 'Province/Territory is required');
        MandatoryCheck(Elm + 6, 'Postal Code is required');
        MandatoryCheck(Elm + 7, 'Country Code is required');
        if MandatoryCheck(Elm + 8, 'Partnership''s Number is required') then
        begin
          Value := FetchElmFNo(RetNo, FNo, Elm + 8);
          if not ValidPartnershipNumber(RetNo, Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Partnership''s Number is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Partnership''s Number is already used in the list')
          else
            UniqueList.Add(Value);
        end;
        MandatoryCheck(Elm + 9, 'Partnership Code is required');
        if FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12) + FetchElmFNo(RetNo,FNo,Elm + 13) = '' then
          SaveDiagnostic(RetNo,'T1134',Elm + 10,'E-T1134-At least 1 valid NAICS code is required');

        Elm := Elm + BoxesPerRow;
      end;

      // each entity information
      ArrayNo := 5;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Was the entity directly involved in a subsection 85(1) rollover?');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Was the entity directly or indirectly involved in a subsection 85.1(3) transaction?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the entity file a section 86.1 election?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Was the entity involved in a section 87 amalgamation?');
        MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Was the entity involved in a subsection 88(1) winding up?');

        Elm := Elm + BoxesPerRow;
      end;

      MandatoryYesNoCheck(28, 29, 'Response to If the reporting entity is submitting a group Org chart');

      UniqueList.Clear;

      // related corporation
      ArrayNo := 6;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of related corporation is required');
        MandatoryCheck(Elm + 2, 'Country code of residence of corporation is required');
        Value := FetchElmFNo(RetNo, FNo, Elm + 3);
        if MandatoryCheck(Elm + 3, 'Name of FA is required') then
          if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 3,'E-T1134-Name of FA is already used in the list')
          else
            UniqueList.Add(Value);

        MandatoryCheck(Elm + 5, 'Country code of residence of FA is required');
        MandatoryCheck(Elm + 6, 'Corporation''s equity % in FA is required');
        MandatoryCheck(Elm + 7, 'Corporation''s direct equity % in FA is required');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Supplement NOT filed due to dormancy threshold?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear; //20230601 Igor

      // related affiliate
      ArrayNo := 7;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm + 1);
        if MandatoryCheck(Elm + 1, 'Name of FA is required') then
          if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 1,'E-T1134-Name of FA is already used in the list')
          else
            UniqueList.Add(Value);
        MandatoryCheck(Elm + 3, 'Country code of residence of FA is required');
        MandatoryCheck(Elm + 4, 'Name of other FAs is required');
        MandatoryCheck(Elm + 6, 'Country code of residence of other FAs is required');
        MandatoryCheck(Elm + 7, 'FA''s equity percentage in other FA is required');
        MandatoryCheck(Elm + 8, 'FA''s direct equity percentage in other FA is required');
        MandatoryYesNoCheck(Elm + 9, Elm + 10, 'Supplement NOT filed due to dormancy threshold?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear; //20230601 Igor

      // partner
      ArrayNo := 8;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Name of partnership within related group is required');
        MandatoryCheck(Elm + 2, 'Address of partner is required');
        MandatoryCheck(Elm + 3, 'Country code of country of residence is required');

        Elm := Elm + BoxesPerRow;
      end;

      // partnership foreign affiliate
      ArrayNo := 9;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 1, 'Partnership name is required');
        MandatoryCheck(Elm + 2, 'Address of partnership is required');
        MandatoryCheck(Elm + 3, 'Country code of country of residence is required');
        MandatoryCheck(Elm + 4, 'Foreign affiliate is required');
        MandatoryCheck(Elm + 5, 'FA''s interest percentage in the partnership is required');

        Elm := Elm + BoxesPerRow;
      end;

      // dormant foreign affiliate
      ArrayNo := 10;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        MandatoryCheck(Elm + 2, 'Cost Amount is required');
        MandatoryCheck(Elm + 3, 'Gross receipts is required');
        MandatoryCheck(Elm + 4, 'Gross revenue is required');

        Elm := Elm + BoxesPerRow;
      end;

      // NonControlledForeignAffiliate
      ArrayNo := 11;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm + 1);
        if MandatoryCheck(Elm + 1, 'Name of FA is required') then
          if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 1,'E-T1134-Name of FA is already used in the list')
          else
            UniqueList.Add(Value);

        Elm := Elm + BoxesPerRow;
      end;

    end;
  finally
    UniqueList.Free;
  end;
End;

Procedure ValidateT1134S(RetNo:Integer;Fno,FInst:Integer); //20230510 Igor
var ArrayNo, BoxesPerRow, RowCount, I, J, Elm, Temp, LastElm, FormNo: integer; //20230601 Igor
    FName, Value: string;
    UniqueList, GroupList: TStringList; //20230619 Igor

    function MandatoryCheck(AElmId: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElmId)='' then
      begin
        SaveDiagnostic(RetNo,FName,AElmId,'E-T1134S-'+ AError);
        Result := false;
      end;
    end;

    function MandatoryYesNoCheck(AElm1Id, AElm2Id: Integer; AError: string): boolean;
    begin
      Result := true;
      If FetchElmFNo(RetNo,FNo,AElm1Id) + FetchElmFNo(RetNo,FNo,AElm2Id) = '' then
      begin
        SaveDiagnostic(RetNo,FName,AElm1Id,'E-T1134S-'+ AError);
        Result := false;
      end;
    end;

begin
  FName := 'T1134S#' + IntToStr(FInst);
  If Ret[RetNo].FrmHasData[FNo] then
  Begin
    //20230601 Igor >>>
    MandatoryCheck(3, 'Action is required');
    Value := FetchElmFNo(RetNo,FNo,35);
    For i:=1 to 10 do
    begin
     if i = FInst then continue;
     FormNo:=GetFormNo('T1134S#'+IntToStr(i));
     If FormNo>0 then
       if SameText(FetchElmFNo(RetNo, FormNo, 35), Value) then
       begin
         SaveDiagnostic(RetNo,FName,35,'E-T1134S-Foreing affiliate name is already used in T1134S#'+IntToStr(i));
         break;
       end;
    end;
    //20230601 Igor <<<
    UniqueList := TStringList.Create;
    GroupList := TStringList.Create; //20230619 Igor
    try
      PopulateT1134GroupList(RetNo, GroupList, false); //20230619 Igor
      if (Trim(FetchElmFNo(RetNo,FNo,3))='4') then
        MandatoryCheck(175, 'Reason for the deletion of this supplement must be selected');
      MandatoryCheck(35, 'Name of FA is required');
      MandatoryCheck(36, 'Address of Head Office is required');
      If FetchElmFNo(RetNo,FNo,40) + FetchElmFNo(RetNo,FNo,41) + FetchElmFNo(RetNo,FNo,42) + FetchElmFNo(RetNo,FNo,43) = '' then
        SaveDiagnostic(RetNo,FName,40,'E-T1134S-At least 1 valid NAICS code is required');
      If FetchElmFNo(RetNo,FNo,44) + FetchElmFNo(RetNo,FNo,45) + FetchElmFNo(RetNo,FNo,46) + FetchElmFNo(RetNo,FNo,47) = '' then
        SaveDiagnostic(RetNo,FName,44,'E-T1134S-At least one country code is required for where the foreign affiliate either carries on a business or has other income earning activity');
      If FetchElmFNo(RetNo,FNo,5) + FetchElmFNo(RetNo,FNo,6) + FetchElmFNo(RetNo,FNo,7) + FetchElmFNo(RetNo,FNo,8) = '' then
        SaveDiagnostic(RetNo,FName,5,'E-T1134S-At least one Country code to which income tax was paid/payable is required');
      MandatoryCheck(48, 'The country code of residence for the foreign affiliate is required');
      MandatoryYesNoCheck(1, 2, 'First time the reporting entity has filed form T1134 for this foreign affiliate is required.');
      MandatoryYesNoCheck(49, 50, 'Is it a controlled foreign affiliate as defined in subsection 95(1) is required.');
      MandatoryYesNoCheck(9, 10, ' Does the FA have more than one tax year ended in the RE''s tax year?');

      // direct share holders
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        for J in [2,3,4,5] do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + J);
          if not Value.IsEmpty then
            break;
        end;
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-At least one account number is required per row')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 6, 'Year Corporation became a foreign affiliate is required');
        MandatoryYesNoCheck(Elm + 7, Elm + 8, 'Did the corporation cease to be a foreign affiliate of the reporting entity in the year is required');
        MandatoryYesNoCheck(Elm + 9, Elm + 10, 'Was a subsection 93(1) or 93(1.2) election made or will such an election be made for the disposition of shares of the foreign affiliate?');
        if not FetchElmFNo(RetNo,FNo,Elm + 9).IsEmpty then
        begin
          MandatoryCheck(Elm + 11, 'Please provide the actual or estimate amount elected on');
          MandatoryCheck(Elm + 12, 'The currency code of the Elected amount on is required');
        end;

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // common shares
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Ownership % is required');
        MandatoryCheck(Elm + 3, 'ACB of Common Shares is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the ACB increase at any time during the tax year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the ACB decrease at any time during the tax year?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // preferred shares
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Ownership % is required');
        MandatoryCheck(Elm + 3, 'ACB of Preferred Shares is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the ACB increase at any time during the tax year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the ACB decrease at any time during the tax year?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // foreign affiliate other information
      ArrayNo := 5;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Percentage is required');
        MandatoryCheck(Elm + 3, 'Percentage is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Qualifying Interest in the FA at beginning of year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Qualifying Interest in the FA at the end of year?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Has the gross amount the RE owed to the FA been reported on a T106?');
        if not FetchElmFNo(RetNo,FNo,Elm + 9).IsEmpty then
          MandatoryCheck(Elm + 10, 'Gross amount of debt is required');
        MandatoryYesNoCheck(Elm + 11, Elm + 12, 'Has the gross amount the FA owed to the RE been reported on a T106?');
        if not FetchElmFNo(RetNo,FNo,Elm + 12).IsEmpty then
          MandatoryCheck(Elm + 13, 'Gross amount of debt is required');

        MandatoryYesNoCheck(Elm + 16, Elm + 17, 'Did the reporting entity have a "tracking interest" in this foreign affiliate as defined in subsection 95(8) at any time in the year?');
        MandatoryYesNoCheck(Elm + 18, Elm + 19, 'Was this foreign affiliate a controlled foreign affiliate of the reporting entity because of subsection 95(11)?');
        MandatoryYesNoCheck(Elm + 20, Elm + 21, 'Was this foreign affiliate a controlled foreign affiliate of the reporting entity because of subsection 95(12)?');
        MandatoryYesNoCheck(Elm + 22, Elm + 23, 'Is this reporting entity a party to a joint election under subsection 91(1.4) of the Act?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // foreign dumping rules
      ArrayNo := 6;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did 212.3(2) apply in respect of an investment in the FA during the year?');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of the 75% threshold');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of 212.3(16)?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of 212.3(18)?');
        MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Did any member of the related group file with the Minister the information required in subparagraph 212.3(7)(d)(i) in respect of the FA during the year?');
        MandatoryYesNoCheck(Elm + 12, Elm + 13, 'Was a dividend under 212.3(7)(d)(ii) deemed to have been paid in respect of an investment in the FA in the year?');
        MandatoryYesNoCheck(Elm + 14, Elm + 15, 'Was PUC of any class of shares of the FA increased under 212.3(9) in the year?');
        MandatoryYesNoCheck(Elm + 16, Elm + 17, 'Did the RE make an investment in the year in preferred shares of the FA that are described in subsection 212.3(19)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      MandatoryCheck(62, 'Taxation year (From) of the FA is required.');
      MandatoryCheck(63, 'Taxation year (To) of the FA is required.');

      MandatoryYesNoCheck(64, 65, 'Does the RE or any member of the related group hold at least 20% of the voting shares in this FA?');
      if not FetchElmFNo(RetNo,FNo, 64).IsEmpty then
        MandatoryYesNoCheck(11, 12, 'Are the unconsolidated FS (including the notes to the FS) available to you as a shareholder at the time this information return is filed?');
      if not FetchElmFNo(RetNo,FNo, 11).IsEmpty then
        MandatoryYesNoCheck(13, 14, 'Have you attached the unconsolidated FS (including notes to the FS) of the FA with this information return?');

      MandatoryYesNoCheck(76, 77, 'Did the reporting entity receive a dividend on a share of the capital stock of the foreign affiliate any time within the taxation year?');

      // exempt surplus
      ArrayNo := 7;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of exempt surplus is required');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // hybrid surplus
      ArrayNo := 8;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of hybrid surplus is required');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // taxable surplus
      ArrayNo := 9;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of taxable surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5900(2)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(1.1)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // taxable surplus
      ArrayNo := 9;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of taxable surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5900(2)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(1.1)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // preacquisition surplus
      ArrayNo := 10;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 2);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of pre-acquisition surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5901(2)(b)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(2.1)?');
        MandatoryYesNoCheck(Elm + 7, Elm + 8, 'Was any qualifying return of capital (QROC) election made pursuant to Regulation 5911(6) as defined in subsection 90(3)?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      //20230601 Igor >>>
      if not FetchElmFNo(RetNo,FNo, 76).IsEmpty then
      begin
        MandatoryCheck(15, 'Amount of dividends in Cash or in Kind is required');
        MandatoryCheck(16, 'Currency Code is required');
        MandatoryCheck(17, 'Amount of dividend in stock');
        MandatoryCheck(18, 'Currency Code is required');
      end;

      MandatoryYesNoCheck(19, 20, 'Was the FA involved in ant transaction in respect of which 93(1.11)/(1.3) applied?');
	  //20230601 Igor <<<
	  
      // upstream loan rules
      ArrayNo := 11;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo,FNo,Elm + 1);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
        else if UniqueList.IndexOf(Value) > -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
        //20230619 Igor >>>  
        else if GroupList.IndexOf(Value) = -1 then
          SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
        //20230619 Igor <<<  
        else
          UniqueList.Add(Value);

        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did a "specified debtor" (as defined in subsection 90(15)) in respect of the reporting entity or of any member of the Canadian related group owe an amount to the FA or a partnership of which the FA was a member?');
        if not FetchElmFNo(RetNo,FNo, Elm + 2).IsEmpty then
        begin
          MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did subsection 90(6) apply to that debt?');
          if not FetchElmFNo(RetNo,FNo, Elm + 5).IsEmpty then
            MandatoryYesNoCheck(Elm + 6, Elm + 7, 'If subsection 90(6) did not apply, was that because of subsection 90(8)?');
        end;
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Was the FA an ''eligible bank affiliate'' that is owed an ''upstream deposit''?');
        if not FetchElmFNo(RetNo,FNo, Elm + 8).IsEmpty then
          MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Was the FA deemed to make a loan to a reporting entity under subsection 90(8.1)');
        MandatoryYesNoCheck(Elm + 12, Elm + 13, 'Was the FA involved in an upstream loan arrangement in respect of which a deduction under subsection 90(9) was claimed?');
        MandatoryYesNoCheck(Elm + 14, Elm + 15, 'Was the FA involved in an upstream loan arrangement in respect of which an income inclusion under subsection 90(12) was required?');

        Elm := Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      if not FetchElmFNo(RetNo,FNo, 49).IsEmpty then
      begin
        MandatoryYesNoCheck(21, 22, 'Was the reporting entity involved in a subsection 88(3) liquidation and dissolution in respect of the FA?');
        if not FetchElmFNo(RetNo,FNo, 21).IsEmpty then
          MandatoryYesNoCheck(23, 24, 'Was a subsection 88(3.1), 88(3.3), or 88(3.5) election made?');
        MandatoryYesNoCheck(25, 26, 'Was the reporting entity involved in a section 51 convertible property exchange in respect of the FA?');

        // transaction involved entity
        ArrayNo := 12;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          //20230619 Igor >>>
          Value := FetchElmFNo(RetNo,FNo,Elm + 2);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
          else
            UniqueList.Add(Value);
          //20230619 Igor <<<

          { //20230601 Igor
          Value := '';
          for J in [3,4,5,6,7] do
            Value := Value + FetchElmFNo(RetNo,FNo,Elm + J);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 3,'E-T1134S-At least one selected checkbox is required');
          }

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        //jz 20230725
        if not (FetchElmFNo(RetNo,FNo,13).IsEmpty) then
        begin
          SaveDiagnostic(RetNo,FName,13,
          'W-You have selected “Yes” to the question “Unconsolidated Financial Statements attached?” on the T1134 Supplement ' +
          '(section 3). Do you want to submit the supporting documentation electronically? If yes, you must attach the '     +
          ' financial statements of the foreign affiliate file(s).');
        end;


        MandatoryYesNoCheck(27, 28, 'Part II, Section 3(B), Q2 YES or NO is required');

        // foreign affiliate transaction involved entity
        ArrayNo := 13;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 2);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>  
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<  
          else
            UniqueList.Add(Value);

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        //20230601 Igor >>>
        if not FetchElmFNo(RetNo,FNo, 27).IsEmpty then
        begin
          MandatoryYesNoCheck(29, 30, 'Was subsection 91(1.1) applicable with respect to the foreign affiliate?');
          MandatoryYesNoCheck(31, 32, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(c) was applicable?');
          MandatoryYesNoCheck(33, 34, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(d) was applicable?');
          MandatoryYesNoCheck(37, 38, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(e) was applicable?');
          MandatoryYesNoCheck(39, 51, 'Was an election filed in respect of the relevant cost base (as defined in subsection 95(4)) of any property of the foreign affiliate pursuant to Regulation 5911(5)?');
        end;
        //20230601 Igor <<<

        // changes in entity and surplus entitlement percentage
        ArrayNo := 14;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 1);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>  
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<  
          else
            UniqueList.Add(Value);

          MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did the reporting entity''s surplus entitlement percentage in this foreign affiliate change?');
          MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the equity percentage of a foreign affiliate of the reporting entity in respect of this foreign affiliate increase or decrease at any time?');
          MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the equity percentage of this foreign affiliate in respect of another foreign affiliate of the reporting entity increase or decrease at any time?');

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        MandatoryYesNoCheck(52, 53, 'Did the FA dispose of a share in another FA that was excluded property or an interest in a partnership that was excluded property?');
        MandatoryYesNoCheck(54, 55, 'Did the FA dispose of capital property that was excluded property?');
        MandatoryYesNoCheck(56, 57, 'Was the reporting entity or any foreign affiliate of the reporting entity involved in?');

        // other transaction entity list
        ArrayNo := 15;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 2);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>  
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 2,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<  
          else
            UniqueList.Add(Value);

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        Value := '';
        for J in [60, 61, 66, 67, 68, 69] do
          Value := Value + FetchElmFNo(RetNo,FNo,J);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,60,'E-T1134S-Number of Employees is required');
        MandatoryYesNoCheck(70, 71, 'Did the operator rely on the services?');

        MandatoryYesNoCheck(72, 73, 'Indicate if you are providing a breakdown of each income category between arm''s length and non-arm''s length sources');

        if FetchElmFNo(RetNo,FNo,74) + FetchElmFNo(RetNo,FNo,75) + FetchElmFNo(RetNo,FNo,78) > '' then
          MandatoryCheck(79,'Gross Revenue Currency Code is empty');
        if FetchElmFNo(RetNo,FNo,80) + FetchElmFNo(RetNo,FNo,81) + FetchElmFNo(RetNo,FNo,82) > '' then
          MandatoryCheck(83,'Interest Currency Code is required');
        if FetchElmFNo(RetNo,FNo,84) + FetchElmFNo(RetNo,FNo,85) + FetchElmFNo(RetNo,FNo,86) > '' then
          MandatoryCheck(87,'Dividends Currency Code is required');
        if FetchElmFNo(RetNo,FNo,88) + FetchElmFNo(RetNo,FNo,89) + FetchElmFNo(RetNo,FNo,90) > '' then
          MandatoryCheck(91,'Royalties Currency Code is required');
        if FetchElmFNo(RetNo,FNo,92) + FetchElmFNo(RetNo,FNo,93) + FetchElmFNo(RetNo,FNo,94) > '' then
          MandatoryCheck(95,'Rental & Leasing Currency Code is required');
        if FetchElmFNo(RetNo,FNo,96) + FetchElmFNo(RetNo,FNo,97) + FetchElmFNo(RetNo,FNo,98) > '' then
          MandatoryCheck(99,'Loans or Lending Currency Code is required');
        if FetchElmFNo(RetNo,FNo,100) + FetchElmFNo(RetNo,FNo,101) + FetchElmFNo(RetNo,FNo,102) > '' then
          MandatoryCheck(103,'Insurance or reinsurance Currency Code is required');
        if FetchElmFNo(RetNo,FNo,104) + FetchElmFNo(RetNo,FNo,105) + FetchElmFNo(RetNo,FNo,106) > '' then
          MandatoryCheck(107,'Factoring of trade accounts receivable Currency Code is required');
        if FetchElmFNo(RetNo,FNo,108) + FetchElmFNo(RetNo,FNo,109) + FetchElmFNo(RetNo,FNo,110) > '' then
          MandatoryCheck(111,'Disposition of Investment Property Currency Code is required');

        MandatoryYesNoCheck(250, 251, 'Did the foreign affiliate earn FAPI in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(112, 113, 'Did the foreign affiliate earn FAPL in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(114, 115, 'Did the foreign affiliate earn FAPI from transactions resulting in capital gains in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(116, 117, 'Did the foreign affiliate earn FACL from transactions resulting in capital losses in any taxation year of the affiliate that ended in the reporting entity''s taxation year?');
        MandatoryYesNoCheck(118, 119, 'Did the foreign affiliate apply any FAPL incurred in a previous taxation year in calculating its FAPI incurred in the current taxation year?');
        MandatoryYesNoCheck(120, 121, 'Did the foreign affiliate apply any FACL incurred in a previous taxation year in calculating its FAPI incurred in the current taxation year?');
        MandatoryYesNoCheck(122, 123, 'Did the foreign affiliate apply any current year FAPL in calculating its FAPI incurred in a previous taxation year?');
        MandatoryYesNoCheck(124, 125, 'Did the foreign affiliate apply any current year FACL in calculating its FAPI incurred in a previous taxation year?');
        MandatoryYesNoCheck(126, 127, 'Was an election filed under 95(2.44) in respect of the FA for the year?');

        // reporting entity participation percentage
        ArrayNo := 16;
        BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm := ArrayNo * 10000;
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
        For I := 0 to RowCount - 1 do
        begin
          Value := FetchElmFNo(RetNo,FNo,Elm + 1);
          if Value.IsEmpty then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is required')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is already in the list')
          //20230619 Igor >>>  
          else if GroupList.IndexOf(Value) = -1 then
            SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect')
          //20230619 Igor <<<  
          else
            UniqueList.Add(Value);

          MandatoryCheck(Elm + 2, 'Reporting entity (-ies) total participating percentage is required');
          MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Did the participating percentage of the reporting entity or member of the related Canadian group in respect of this FA increase or decrease at any time?');

          Elm := Elm + BoxesPerRow;
        end;

        UniqueList.Clear;

        MandatoryYesNoCheck(147, 148, 'Part III, Section 4, Q1 YES or NO is required');
        if not FetchElmFNo(RetNo,FNo,147).IsEmpty then
        begin
          MandatoryYesNoCheck(149, 150, 'Because of subparagraph 95(2)(a)(i) to 95(2)(a)(vi) of the Act?');
          MandatoryYesNoCheck(151, 152, 'Because of type of business carried on… 95(1) of the Act?');
          MandatoryYesNoCheck(153, 154, 'Because of subparagraph 95(2)(I)(i) to (iii) of the Act?');
          //20230601 Igor >>>
          { 
          Temp := 0;
          LastElm := 149;
          for J in [149,151,153] do
            if not FetchElmFNo(RetNo,FNo,J).IsEmpty then
            begin
              inc(Temp);
              LastElm := J;
            end;
          if (Temp = 0) or (Temp > 1) then
            SaveDiagnostic(RetNo,FName,LastElm,'E-T1134S-There must be one YES between these three questions');
          }
          //20230601 Igor <<<
        end;
        MandatoryYesNoCheck(155, 156, 'Part III, Section 4, Q2 YES or NO is required');
        if not FetchElmFNo(RetNo,FNo,155).IsEmpty then
        begin
          MandatoryYesNoCheck(157, 158, 'Because of 90% test in paragraphs 95(2)(a.1) through (a.4) of the Act?');
          MandatoryYesNoCheck(159, 160, 'Because of subsection 95(2.3) of the Act?');
          MandatoryYesNoCheck(161, 162, 'Because of subsection 95(2.4) of the Act?');
          MandatoryYesNoCheck(163, 164, 'Because of subsection 95(3)?');
          MandatoryYesNoCheck(165, 166, 'Because of subsection 95(3.01)?');
          //20230601 Igor >>>
          { 
          Temp := 0;
          LastElm := 157;
          for J in [157,159,161,163,165] do
            if not FetchElmFNo(RetNo,FNo,J).IsEmpty then
            begin
              inc(Temp);
              LastElm := J;
            end;
          if (Temp = 0) or (Temp > 1) then
            SaveDiagnostic(RetNo,FName,LastElm,'E-T1134S-There must be one YES between these three questions');
          }
          //20230601 Igor <<<
        end;
      end;

      MandatoryYesNoCheck(288, 289, 'Is any information requested in this return not available?');
      if not FetchElmFNo(RetNo,FNo,288).IsEmpty then
      begin
        Value := FetchElmFNo(RetNo,FNo,290) + FetchElmFNo(RetNo,FNo,291) + FetchElmFNo(RetNo,FNo,292) + FetchElmFNo(RetNo,FNo,293);
        if Value.IsEmpty then
          SaveDiagnostic(RetNo,FName,290,'E-T1134S- Please specify information not available.');
      end;
    finally
      UniqueList.Free;
    end;
  End;
end;

Procedure ValidateConsent(RetNo: integer; Fno: integer; Inst: String);
Var
  i: integer;
  S: String;
  Dt: TDate; // Inst:String;
  Fname: String;
  AuthorizeSw, CancelSw:Boolean;
Begin
  if FetchElmFNo(RetNo,FNo,66)='' then exit;
  Fname := 'CONSENT' + Inst;
  If Ret[RetNo].FrmHasData[Fno] = false then Exit;
  if FetchElmFno(RetNo,FNo,13)+FetchElmFNo(RetNo,FNo,34)='' then  //20180728
  Begin
    SaveDiagnostic(RetNo,FNAME,13,'E-CONSENT-Please select option: Authorize or Cancel');
  End;


  AuthorizeSw:=FetchElm(RetNo,FNo,13)>'';
  CancelSw:=FetchElm(RetNo,FNo,34)>'';
  if (FetchElm(RetNo,FNo,1)='') then
      SaveDiagnostic(RetNo,FNAME,1,'E-CONSENT-Business Name is required');

  if (FetchElm(RetNo,FNo,2)='') then SaveDiagnostic(RetNo,FNAME,2,'E-CONSENT-Business number is required');
  if Length(FetchElm(RetNo,FNo,2))<>9 then SaveDiagnostic(RetNo,FNAME,2,'E-CONSENT-Business number must be 9 digits');

  //if ValidSin(FetchElm(RetNo,FNo,2))=False then  SaveDiagnostic(RetNo,FNAME,9,'E-CONSENT-Business number is invalid');

  if AuthorizeSw then
  Begin
  //20200211
   if FetchElmFNo(RetNo,FNo,10)+FetchElmFNo(RetNo,FNo,57)+FetchElmFNo(RetNo,FNo,20)='' then
   Begin
      SaveDiagnostic(RetNo,FNAME,10,'E-CONSENT-Please enter Representative information');
      SaveDiagnostic(RetNo,FNAME,57,'E-CONSENT-Please enter Representative information');
      SaveDiagnostic(RetNo,FNAME,20,'E-CONSENT-Please enter Representative information');
   end;

   //20201211
   if (FetchElmFNo(RetNo,FNo,10)>'') and (FetchElmFNo(RetNo,FNo,20)>'') then
   Begin
     SaveDiagnostic(RetNo,FNAME,10,'E-CONSENT-Enter Rep Id or BN. To change it now remove the Y)');
   End;


    //20200924
   if (FetchElmFNo(RetNo,FNo,21)='') then  SaveDiagnostic(RetNo,FNAME,21,'E-CONSENT-Area is required');
   If (FetchElmFNo(RetNo,FNo,27)='') then SaveDiagnostic(RetNo,FNAME,27,'E-CONSENT-Phone is required');

   if FetchElmFNo(RetNo,FNo,12)+FetchElmFNo(RetNo,FNo,17)='' then //20180824 CON
   Begin
    SaveDiagnostic(RetNo,FNAME,12,'E-CONSENT-Please complete Option 1, or Option 2 Authorization');
    SaveDiagnostic(RetNo,FNAME,17,'E-CONSENT-Please complete Option 1, or Option 2 Authorization');
   End;
   if (FetchElmFNo(RetNo,FNo,10)>'') and (Length(FetchElmFNo(RetNo,FNo,10))<>7) then  //20180728
    SaveDiagnostic(RetNo,FNAME,10,'E-CONSENT-Representative Id must be 7 alhanumeric characters');

   if (FetchElmFNo(RetNo,FNo,12)>'') and (FetchElmFNo(RetNo,FNo,16)='') then  //20180728
        SaveDiagnostic(RetNo,FNAME,16,'E-CONSENT-Select Authorization level 1, 2 or 3');
   //programs
   //if (FetchElm(RetNo,FNo,12)>'') and (FetchElm(RetNo,FNo,16)='') then  //20180728
 End; //authorize

 if CancelSw=True  then
 Begin
  if (FetchElmFNo(RetNo,FNo,34)>'')  //cancel
    and (FetchElmFNo(RetNo,FNo,47)+FetchElmFNo(RetNo,FNo,46)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,47,'E-CONSENT-Select Cancel All or Specific representative');

  {
  if (FetchElmFNo(RetNo,FNo,47)='') and (FetchElmFNo(RetNo,FNo,48)+FetchElmFNo(RetNo,FNo,50)+FetchElm(RetNo,FNo,49)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,47,'E-CONSENT-Select Cancel All or Specific representative');
   }
  if (FetchElmFNo(RetNo,FNo,46)>'') then //cancel specific rep  //20200214
  Begin
   If (FetchElmFNo(RetNo,FNo,48)+FetchElmFNo(RetNo,FNo,50)+FetchElm(RetNo,FNo,49)='') then  //20180728
   Begin
    SaveDiagnostic(RetNo,FNAME,48,'E-CONSENT-Select Rep id, Group Id or BN below');
    SaveDiagnostic(RetNo,FNAME,50,'E-CONSENT-Select Rep id, Group Id or BN below');
    SaveDiagnostic(RetNo,FNAME,49,'E-CONSENT-Select Rep id, Group Id or BN below');
   End;

  End;

  if (FetchElmFNo(RetNo,FNo,48)>'') and (FetchElmFNo(RetNo,FNo,45)='') then
    SaveDiagnostic(RetNo,FNAME,45,'E-CONSENT-Enter Name/Surname');
  if (FetchElmFNo(RetNo,FNo,48)>'') and (FetchElmFNo(RetNo,FNo,51)='') then
    SaveDiagnostic(RetNo,FNAME,51,'E-CONSENT-Enter Surname');


  if (FetchElmFNo(RetNo,FNo,49)>'') and (FetchElmFNo(RetNo,FNo,42)='') then
    SaveDiagnostic(RetNo,FNAME,42,'E-CONSENT-Enter Business Name');

 end;

 //Signature
 if FetchElm(RetNo,FNo,41)+FetchElm(RetNo,FNo,35)='' then //20180824 CON
   SaveDiagnostic(RetNo,FNAME,41,'E-CONSENT-Please select who signes');
   //certification
 //If FetchElm(RetNo,FNo,41)>'' then StoreElm(RetNo,FNo,53,GetFirstName(RetNo)+' '+GetLastName(RetNo));
 //if FetchElm(RetNo,FNo,53)='' then SaveDiagnostic(RetNo,FNAME,41,'E-CONSENT-Please select who signes'); //20200218

 if FetchElmFNo(RetNo,FNo,55)='' then StoreElm(RetNo,FNo,55,FormatDateTime('yyyy-mm-dd', Date));

 if (FetchElm(RetNo,FNo,12)>'') and (FetchElm(RetNo,FNo,17)>'') then
 Begin
      SaveDiagnostic(RetNo,FNAME,12,'E-CONSENT-Use Option 1 or Option 2');
      SaveDiagnostic(RetNo,FNAME,17,'E-CONSENT-Use Option 1 or Option 2');
 End;
End;


Procedure ValidateAConsent(RetNo: integer; Fno: integer);
Var
  i: integer;
  S: String;
  Dt: TDate; // Inst:String;
  Fname: String;
  AuthorizeSw, CancelSw:Boolean;
Begin
  if FetchElmFNo(RetNo,FNo,66)='' then exit;
  Fname := 'ACONSENT';
  If Ret[RetNo].FrmHasData[Fno] = false then Exit;
  if FetchElmFno(RetNo,FNo,2)+FetchElmFNo(RetNo,FNo,3)='' then  //20180728
  Begin
    SaveDiagnostic(RetNo,FNAME,2,'E-CONSENT-Please select option: Authorize or Cancel');
  End;

  AuthorizeSw:=FetchElm(RetNo,FNo,2)>'';
  CancelSw:=FetchElm(RetNo,FNo,3)>'';
  if (FetchElm(RetNo,FNo,4)='') then
      SaveDiagnostic(RetNo,FNAME,4,'E-Legal Name is required');

  if (FetchElm(RetNo,FNo,5)='') then SaveDiagnostic(RetNo,FNAME,5,'E-CONSENT-Alberta Account is required');

  if AuthorizeSw then
  Begin
  if (FetchElmFNo(RetNo,FNo,36)>'') then
   Begin
    if FetchElmFNo(RetNo,FNo,6)+FetchElmFNo(RetNo,FNo,7)='' then
     SaveDiagnostic(RetNo,FNAME,6,'E-CONSENT-Please select Individual or Firm');
    if (FetchElmFNo(RetNo,FNo,12)='') then  SaveDiagnostic(RetNo,FNAME,12,'E-CONSENT-Area is required');
    If (FetchElmFNo(RetNo,FNo,13)='') then SaveDiagnostic(RetNo,FNAME,13,'E-CONSENT-Phone is required');
    If (FetchElmFNo(RetNo,FNo,1)='') then SaveDiagnostic(RetNo,FNAME,1,'E-CONSENT-Email is required');
   End;
   //TRAACS
   if (FetchElmFNo(RetNo,FNo,37)>'') then
   Begin
    If (FetchElmFNo(RetNo,FNo,8)='') then SaveDiagnostic(RetNo,FNAME,8,'E-CONSENT-Email is required');
    if (FetchElmFNo(RetNo,FNo,20)='') then  SaveDiagnostic(RetNo,FNAME,20,'E-CONSENT-Area is required');
    If (FetchElmFNo(RetNo,FNo,34)='') then SaveDiagnostic(RetNo,FNAME,34,'E-CONSENT-Phone is required');
   end;
   //
   If (FetchElmFNo(RetNo,FNo,9)+FetchElmFNo(RetNo,FNo,10)+FetchElmFNo(RetNo,FNo,11)='') then
   Begin
     SaveDiagnostic(RetNo,FNAME,9,'E-CONSENT-Select the fiscal years of New Authorization');
     SaveDiagnostic(RetNo,FNAME,10,'E-CONSENT-Select the fiscal years of New Authorization');
     SaveDiagnostic(RetNo,FNAME,11,'E-CONSENT-Select the fiscal years of New Authorization');
     If (FetchElmFNo(RetNo,FNo,10)>'') and (FetchElmFNo(RetNo,FNo,14)='') then
           SaveDiagnostic(RetNo,FNAME,14,'E-CONSENT-Enter specific years for New Authorization');
   End;
 End; //authorize

 if CancelSw=True  then
 Begin
  If (FetchElmFNo(RetNo,FNo,15)+FetchElmFNo(RetNo,FNo,16)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,15,'E-CONSENT-Select cancel All or cancel Specific');
  If (FetchElmFNo(RetNo,FNo,17)+FetchElmFNo(RetNo,FNo,18)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,17,'E-CONSENT-Select Individual Names Or Firm Name');

  If (FetchElmFNo(RetNo,FNo,17)>'') and (FetchElmFNo(RetNo,FNo,19)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,19,'E-CONSENT-Enter Individual Names');

  If (FetchElmFNo(RetNo,FNo,18)>'') and (FetchElmFNo(RetNo,FNo,21)='') then  //20180728
     SaveDiagnostic(RetNo,FNAME,21,'E-CONSENT-Enter Firm Name');
 end;

 //Certification
 If FetchElm(RetNo,FNo,22)+FetchElm(RetNo,FNo,23)+FetchElm(RetNo,FNo,24)
    +FetchElm(RetNo,FNo,25)+FetchElm(RetNo,FNo,26)='' then
    SaveDiagnostic(RetNo,FNAME,22,'E-CONSENT-Please select who signes');
 if FetchElm(RetNo,FNo,27)='' then SaveDiagnostic(RetNo,FNAME,27,'E-CONSENT-Please enter Email');
 if FetchElm(RetNo,FNo,28)='' then SaveDiagnostic(RetNo,FNAME,28,'E-CONSENT-Please enter Telephone Area');
 if FetchElm(RetNo,FNo,29)='' then SaveDiagnostic(RetNo,FNAME,29,'E-CONSENT-Please enter Telephone Number');
 if FetchElm(RetNo,FNo,30)='' then SaveDiagnostic(RetNo,FNAME,30,'E-CONSENT-Please enter Email');
 if FetchElm(RetNo,FNo,31)='' then SaveDiagnostic(RetNo,FNAME,31,'W-CONSENT-Please enter Fax Area');
 if FetchElm(RetNo,FNo,32)='' then SaveDiagnostic(RetNo,FNAME,32,'W-CONSENT-Please enter Fax Number');
 //if FetchElmFNo(RetNo,FNo,33)='' then StoreElm(RetNo,FNo,55,FormatDateTime('yyyy-mm-dd', Date));
End;

Procedure ValidateCBCR(RetNo:Integer;Fno:Integer); //20230109 Igor
var
  nElm1, nElm2, nElm3, nElm4: Integer;
  k, j  : integer;
  s, ss : string;
begin
  If Ret[RetNo].FrmHasData[FNo] then
  Begin
    if FetchElmFNo(RetNo,FNo,11)='' then
      SaveDiagnostic(RetNo,'CBCR',11,'E-CBCR-Country-by-Country - Enter Street Number on the Street Number box only');
    if FetchElmFNo(RetNo,FNo,28)>'' then
      if FetchElmFNo(RetNo,FNo,33)='' then SaveDiagnostic(RetNo,'CBCR',33,'E-CBCR-Address is missing');
    if FetchElmFNo(RetNo,FNo,602)='' then
      SaveDiagnostic(RetNo,'CBCR',602,'E-CBCR-Enter the fiscal year end date of the MNE group for which you are reporting');
    if FetchElmFNo(RetNo,FNo,4)='' then
      SaveDiagnostic(RetNo,'CBCR',4,'E-CBCR-Reporting Entity Identification should be set to Corporation'); // for initial release only corporation is available
    if FetchElmFNo(RetNo,FNo,5)='' then
      SaveDiagnostic(RetNo,'CBCR',5,'E-CBCR-Corporation Name is empty');
    if FetchElmFNo(RetNo,FNo,6)='' then
      SaveDiagnostic(RetNo,'CBCR',6,'E-CBCR-Corporation Business Number is empty');
    if FetchElmFNo(RetNo,FNo,10)='' then
      SaveDiagnostic(RetNo,'CBCR',10,'E-CBCR-Enter the name of the multinational enterprise group');
    if FetchElmFNo(RetNo,FNo,16)='' then
      SaveDiagnostic(RetNo,'CBCR',16,'E-CBCR-The city name of the reporting entity''s address is required');
    if FetchElmFNo(RetNo,FNo,18)='' then
      SaveDiagnostic(RetNo,'CBCR',18,'E-CBCR-The country code of the country of residence of the reporting entity''s address is required. Use code "X5" for entities deemed not to be resident in any tax jurisdiction for tax purposes.');
    if FetchElmFNo(RetNo,FNo,20) + FetchElmFNo(RetNo,FNo,21) + FetchElmFNo(RetNo,FNo,22) ='' then
      SaveDiagnostic(RetNo,'CBCR',20,'E-CBCR-Check one box only to indicate the role of the reporting entity');
    if (FetchElmFNo(RetNo,FNo,22)>'') and (FetchElmFNo(RetNo,FNo,23) + FetchElmFNo(RetNo,FNo,24) ='') then
      SaveDiagnostic(RetNo,'CBCR',23,'E-CBCR-Indicate whether you are filing on behalf of all constituent entities of the MNE group that are resident in Canada by selecting Yes, otherwise select No');
    if FetchElmFNo(RetNo,FNo,21)+FetchElmFNo(RetNo,FNo,22)>'' then
    begin
      if FetchElmFNo(RetNo,FNo,25)='' then
        SaveDiagnostic(RetNo,'CBCR',25,'E-CBCR-Enter the name of the Ultimate Parent Entity of the MNE Group');
      if FetchElmFNo(RetNo,FNo,26)='' then
        SaveDiagnostic(RetNo,'CBCR',26,'E-CBCR-Enter the country code of the country of residence of the ultimate parent entity of the MNE group. Use code "X5" for entities deemed not to be resident in any tax jurisdiction for tax purposes');
    end;
    if FetchElmFNo(RetNo,FNo,27)='' then
      SaveDiagnostic(RetNo,'CBCR',27,'E-CBCR-Enter the name of the authorized individual who certifies the completeness and accuracy of the information reported in this form');
    if FetchElmFNo(RetNo,FNo,29)='' then
      SaveDiagnostic(RetNo,'CBCR',29,'E-CBCR-Enter the position or title of the Certifier');
    if FetchElmFNo(RetNo,FNo,30)='' then
      SaveDiagnostic(RetNo,'CBCR',30,'E-CBCR-Enter the telephone code of the Certitier');
    if FetchElmFNo(RetNo,FNo,31)='' then
      SaveDiagnostic(RetNo,'CBCR',31,'E-CBCR-Enter the telephone number of the Certitier');

    k:= 620;
    repeat
      s := FetchElmFNo(RetNo,FNo,k);

      if (s > '') and (uppercase(s) <> 'NOTIN') then
      begin

        //jz vt49 - if trust number, validate it
        If (uppercase(s[1]) = 'T') and (IsValidTrustNo(s)= false) then
          SaveDiagnostic(RetNo,'CBCR',k,'W-CBCR Invalid Trust No');


        //jz vt49 - check for duplicates if not NOTIN
        j := 620;
        repeat
            ss := FetchElmFNo(RetNo,FNo,j);
            if k <> j then
            begin
              if s=ss then
                SaveDiagnostic(RetNo,'CBCR',k,'W-CBCR Duplicate');
            end;
            inc(j,21);
        until j >= 1544;

      end;

      inc(k,21);
      until k >= 1544;

  end;
end;



end.



