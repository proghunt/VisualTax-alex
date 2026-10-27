unit T3_2026cnterr;

interface

uses
  System.Classes, vtDynData; //20260115 Igor

  procedure CountDiagnostics(RetNo: integer);
  Procedure ValidateT1135(RetNo:Integer;Fno:Integer); //20160314 Igor
  Procedure RemoveT1135SectionAdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  Procedure RemoveT1135SectionBdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  Procedure ValidateT1135SectionAdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  Procedure ValidateT1135SectionBdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  Procedure ValidateT3(RetNo:Integer;FNo:Integer); //20180317
  Procedure ValidateT183TRUST(RetNo: integer; Fno: integer); //20220120 Igor
  Procedure ValidateT1135MaxYearEnd(RetNo: integer; Fno: integer); //20239214
  Procedure ValidateS15PartB(RetNo: integer; Fno: integer; Inst:String); //20220120 Igor
  procedure ValidateT1134(RetNo: Integer; Fno: Integer); //20260115 Igor
  procedure ValidateT1134S(RetNo: Integer; Fno, FInst: Integer); //20260115 Igor
  procedure ValidateT106(RetNo: Integer); //20260817 Alex
  procedure ValidateT106SL(RetNo: Integer); //20260817 Alex
  procedure ValidateAT106SLip(RetNo: Integer; SlFName: string; SlipFNo: Integer); //20260817 Alex

implementation

uses
  SysUtils, vtCommon, Controls, //20231223
  vtMulti, //20260115 Igor
  T3_2026, T3_2026TrimStr, T3_2026Declare, T3_2026Common, T3_2026Common2,
  Masks, //20220128 Igor
  vtTrimStr, vtShared;


procedure CountDiagnostics(RetNo: integer);
Var i,j,k,Page1FNo,FNo,ElmNo:integer;S:String; X:Real; FrmNm : string[12];
ErrMsg : string[50];
Inst:String;
//Templist:TStringList;
begin
  If RetNo=0 then exit;
  If RetInMem < 1 then exit;
  Ret[RetNo].AuditList.Clear;

  //20160207
  If IsT3Return(RetNo) = True then  //20180107
  begin
   if FetchElm(RetNo,'T3',43)+ FetchElm(RetNo,'T3',45)+FetchElm(RetNo,'T3',81)='' then
   Begin
    SaveDiagnostic(RetNo,'T3',43,'E-Trust Type is required. Select one of the highlighted boxes');
    SaveDiagnostic(RetNo,'T3',45,'E-Trust Type is required. Select one of the highlighted boxes');
    SaveDiagnostic(RetNo,'T3',81,'E-Trust Type is required. Select one of the highlighted boxes');
   End;
  end;

 (*
  //20231213
  if (IsEnterpriseVersion=false) and (GetEfilerNo<>'B0865') then
  Begin
   With TempList do
   Begin
    TstringList.Create;
    add('T1061');
    add('T2000');
    add('T3ATH');
    add('T3D');
    add('T3GR');
    add('T3M');
    add('T3P');
    add('T3PRP');
    add('T3RCA');
    add('T3RI');
    add('T3S');
   End;
   for i:=0 to templist.Count-1 do
   Begin
    FrmNm:=templist[i];
    if Ret[RetNo].FrmHasData[GetFormNo(FrmNm)]= True then
      s:='M-Form '+FrmNm+' is supported only in the Enterprise version of the tax moudule.'
       +'Please Rightclick and select clear or contact VisualTax by Email';
    SaveDiagnostic(RetNo,FrmNm,1,s);
   end;
   templist.Free;
  End;
 *)

  //jz//20260320
  if FetchElm(RetNo,'T3',10).length > 2 then
    SaveDiagnostic(RetNo,'T3',10,'E-Value must be a 2 digit code included the dropdown');

  //20180124
  if (FetchElm(RetNo,'T3',43)+ FetchElm(RetNo,'T3',45)>'') then
  Begin
   If FetchElm(RetNo,'T3',81)>'' then
      SaveDiagnostic(RetNo,'T3',81,'E-Trust Type. You can not have QRE/QDT and also Other type of Trust. Delete one of them'); //20190324
  End;

  //20230312
  if (FetchElm(RetNo,'T3',81)='335')
  Or (FetchElm(RetNo,'T3',81)='336') then //t3 type
  Begin
   If FetchElm(RetNo,'T3',51)='' then //date trust created
      SaveDiagnostic(RetNo,'T3',51,'W-Enter Date Trust was created. It is mandatory for T3 types 335 and 336'); //20190324
  End;


  If IsT3Return(RetNo) = True then
  begin
   FNo:=GetFormNo('T3');
   if FetchElm(RetNo,'T183TRUST',17)>'' then  //20240327
      ValidateT3(RetNo,FNo);
  End;

   //20170326
  if Vl(FetchElm(RetNo,'S11A',11))>0 then
  Begin
    if Vl(FetchElm(RetNo,'S11A',15))=0 then
     SaveDiagnostic(RetNo,'S11A',15,'E-S11A Donations entered but No claim');  //20220325

    if Vl(FetchElm(RetNo,'S11A',15))> Vl(FetchElm(RetNo,'S11A',11)) then
     SaveDiagnostic(RetNo,'S11A',15,'W-S11A Donations claim exceeds available donations');
  End;

  If GetT3AccountNumber(RetNo)>'' then
  Begin
    FNo:=GetFormNo('EFMEMO');
    If (FetchElmFNo(RetNo,FNo,2) = '') then SaveDiagnostic(RetNo,'EFMEMO',2,'E-EFMEMO-Select PreAssessment Review Indicator');
    If (FetchElmFNo(RetNo,FNo,3) = '') then SaveDiagnostic(RetNo,'EFMEMO',3,'E-EFMEMO-Select PostAssessment Review Indicator');

    if FetchElm(RetNo,'EFMEMO',51)='' then  //20230209
      SaveDiagnostic(RetNo,'EFMEMO',51,'E-EFMEMO-Indicate that you have reviewed the EFMemo additional questionnaire');
  End;

  FNo:=GetFormNo('T3AO');  //20240329
  If Ret[RetNo].FrmHasData[Fno] then
  Begin
    If FetchElmFNo(RetNo,FNo,8)='' then
      SaveDiagnostic(RetNo,'T3AO',8,'W-T3AO-Enter Trust Account number');
    If (FetchElmFNo(RetNo,FNo,66)='') then
      SaveDiagnostic(RetNo,'T3AO',66,'W-T3AO-Enter Name and Address of Payer');
  End;
  {
  FNo:=GetFormNo('T7DRQR');  //20230311
  If Ret[RetNo].FrmHasData[Fno] then
  Begin
    If FetchElmFNo(RetNo,FNo,8)='' then
      SaveDiagnostic(RetNo,'T7DRQR',8,'W-T7DRQR-Enter Trust Account number');
    If (FetchElmFNo(RetNo,FNo,66)='') then
      SaveDiagnostic(RetNo,'T7DRQR',66,'W-T7DRQR-Enter Name and Address of Payer');
  End;
  }

 { //20240327
  //20220403
  If FetchElm(RetNo,'T7DRQR',8)>'' then
  Begin
   If (midStr(FetchElm(RetNo,'T7DRQR',8),4,1)<>'-')
   or (midStr(FetchElm(RetNo,'T7DRQR',8),8,1)<>'-')
   then
     SaveDiagnostic(RetNo,'T7DRQR',8,'E-T7DRQR-Enter SIN in proper format');
  End;
 }

   //20220322
   if vl(fetchElm(RetNo,'S9',3))>0 then      //benefiaries
   Begin
    X:=vl(FetchElm(RetNo,'T3',243));
    S:=FormatFloat('##,###,###.##',X);
    If (X>0) and (Vl(FetchElm(RetNo,'AVLBLE',46))=0) then
     SaveDiagnostic(RetNo,'AVLBLE',46,'W-AVLBLE-Allocate deductions from Total Income $'+S+' to the proper lines');
    if ((X=0) and (Vl(FetchElm(RetNo,'AVLBLE',46))>0)) then
      SaveDiagnostic(RetNo,'AVLBLE',46,'W-AVLBLE-Total Expenses should be zero)')
    Else
    Begin
     If Vl(FetchElm(RetNo,'AVLBLE',46))>X then
      SaveDiagnostic(RetNo,'AVLBLE',46,'E-AVLBLE-Total Expenses cannot be more than $'+S);
    End;
   End;

   //20220316
   FNo:=GetFormNo('T1055');
   If Ret[RetNo].FrmHasData[Fno] then
   Begin
    If FetchElmFNo(RetNo,FNo,51)+FetchElmFNo(RetNo,FNo,52)+FetchElmFNo(RetNo,FNo,53)='' then
    Begin
      SaveDiagnostic(RetNo,'T1055',51,'E-T1055-Select the applicable situation option');
      SaveDiagnostic(RetNo,'T1055',52,'E-T1055-Select the applicable situation option');
      SaveDiagnostic(RetNo,'T1055',53,'E-T1055-Select the applicable situation option');
    End;
   End;

  {20180317

   If (AnyCorpsInT3Slips(RetNo)) and (FetchElm(RetNo,'S9',123) ='') then //20120330
   Begin
    If Vl(FetchElm(RetNo,'S9',17))+Vl(FetchElm(RetNo,'S9',112))>0
    then  //dividends
     SaveDiagnostic(RetNo,'S9',123,'W-T3-S9-Corporations are beneficiaries. Any adjustments?');
   end;

   //20170321
   if Vl(FetchElm(RetNo,'S11',24))<>0 then
   Begin
    SaveDiagnostic(RetNo,'S11',24,'W-S11 Check line 12. Delete amount unless you entered it');
   End;


   //20170326
   if Vl(FetchElm(RetNo,'S11A',5))>0 then
   Begin
    if Vl(FetchElm(RetNo,'S11A',15))=0 then
     SaveDiagnostic(RetNo,'S11A',15,'W-S11A Donations entered but No claim');

    if Vl(FetchElm(RetNo,'S11A',15))> Vl(FetchElm(RetNo,'S11A',5)) then
     SaveDiagnostic(RetNo,'S11A',15,'W-S11A Donations claim exceeds available donations');
   End;


   If Length(FetchElmFNo(RetNo,FNo,5)) <> 3 then  //20120218
     SaveDiagnostic(RetNo,'T3',5,'E-T3 Enter Area code in format 999');
   If Length(FetchElmFNo(RetNo,FNo,6)) <> 8 then
     SaveDiagnostic(RetNo,'T3',6,'E-T3 Enter phone in format 999-9999');

   If FetchElmFNo(RetNo,FNo,1) = '' then
    SaveDiagnostic(RetNo,'T3',1,'E-T3 Name is missing');

   If (isTestamentary(RetNo)=False)
   and (IsIntervivos(RetNo)=False) then
     SaveDiagnostic(RetNo,'T3',23,'E-T3 Trust type not defined');


   //If RY =1 then SaveDiagnostic(RetNo,'T3',17,'W-'+IntToStr(StrToInt(AppYear)+1)+' tax rates not available in the program yet');
   If RY =1 then SaveDiagnostic(RetNo,'T3',17,'W-'+IntToStr(StrToInt(AppYear)+1)+' tax rates for the new year not available yet'); //20180315

   If (FetchElm(RetNo,'T3',14) = '')
      or (FetchElmFNo(RetNo,FNo,17) = '') then
     SaveDiagnostic(RetNo,'T3',14,'E-T3 Year End missing');


   If Vl(FetchElm(RetNo,'T3',246)) <> Vl(FetchElm(RetNo,'AVLBLE',46)) then
     SaveDiagnostic(RetNo,'AVLBLE',2,'W-allocate expenses of $'
       +FormatFloat('###,###.##',Vl(FetchElm(RetNo,'T3',246)))
       +' against income');


   If Vl(FetchElm(RetNo,'T3DON',172)) > 0 then
   begin
    If Vl(FetchElm(RetNo,'T3DON',173))=0 then
     SaveDiagnostic(RetNo,'T3DON',173,'W-T3DON-Cultural/Ecological gifts not claimed');
   end;

   If FetchElm(RetNo,'S10',21) >'' then
   begin
    If UpperCase(LeftStr(FetchElm(RetNo,'S10',21),2)) <> 'NR' then
      SaveDiagnostic(RetNo,'S10',21,'W-S10-Remittance number should start with NR');
   end;

   For j:=1 to 20 do
   begin
    FNo:=GetFormNo('T3INCOME#'+AllTrim(IntToStr(j)), False);
    if FNo < 1 then break;
    If ((Vl(FetchElmFNo(RetNo,FNo,8))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,9))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,14))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,15))>0))
    and (FetchElmFNo(RetNo,FNo,5)='') then
      SaveDiagnostic(RetNo,'T3INCOME#'+AllTrim(IntToStr(j)),5,'E-T3Income-Complete Country/Currency section');
   end;

   For j:=1 to 3 do
   begin
    FNo:=GetFormNo('T5INCOME#'+AllTrim(IntToStr(j)),False);
    if FNo < 1 then break;
    If ((Vl(FetchElmFNo(RetNo,FNo,9))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,10))>0))
    and (FetchElmFNo(RetNo,FNo,5)='') then
      SaveDiagnostic(RetNo,'T5INCOME#'+AllTrim(IntToStr(j)),5,'E-T5Income-Complete Country/Currency section');

   If ((Vl(FetchElmFNo(RetNo,FNo,31))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,32))>0))
    and (FetchElmFNo(RetNo,FNo,27)='') then
      SaveDiagnostic(RetNo,'T5INCOME#'+AllTrim(IntToStr(j)),27,'E-T5Income-Complete Country/Currency section');

   If ((Vl(FetchElmFNo(RetNo,FNo,53))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,54))>0))
    and (FetchElmFNo(RetNo,FNo,49)='') then
      SaveDiagnostic(RetNo,'T5INCOME#'+AllTrim(IntToStr(j)),49,'E-T5Income-Complete Country/Currency section');

   If ((Vl(FetchElmFNo(RetNo,FNo,75))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,76))>0))
    and (FetchElmFNo(RetNo,FNo,71)='') then
      SaveDiagnostic(RetNo,'T5INCOME#'+AllTrim(IntToStr(j)),71,'E-T5Income-Complete Country/Currency section');

   If ((Vl(FetchElmFNo(RetNo,FNo,97))>0)
    or (Vl(FetchElmFNo(RetNo,FNo,98))>0))
    and (FetchElmFNo(RetNo,FNo,93)='') then
      SaveDiagnostic(RetNo,'T5INCOME#'+AllTrim(IntToStr(j)),93,'E-T5Income-Complete Country/Currency section');
   end;
 end;  //T3

 //t3 supplementaries     //20110521
   k:=GetHighestT3SuplInstance(RetNo);
   For j:=1 to k do
   begin
    FNo:=GetFormNo('T3SUPL#'+AllTrim(IntToStr(j)));
    If Ret[RetNo].FrmHasData[Fno] then
    begin
       //20120403
       s:=FetchElmFNo(RetNo,FNo,46);

       If Length(s) = 0 then  //20120405
        SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),46,'W-T3 Beneficiary-Recipient id is missing');

       // If (Length(s)=9) and (UpperCase(LeftStr(s,1))<>'T') then
       If FetchElmFNo(RetNo,FNo,4)<'3' then  //201210405
       begin
         If (ValidSin(s) = false) or (Length(s)<>9) then   //20120405
          SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),46,'W-T3 Beneficiary-SIN is incorrect');
       end;

       If Length(s)=15 then
       begin
         If ValidBusNumber(RetNo,s) = false then
          SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),46,'W-T3 Beneficiary-Business number is incorrect');
       end;

       If FetchElmFNo(RetNo,FNo,4)>'2' then  //t20120404
       begin
        If FetchElmFNo(RetNo,FNo,64)>'' then
         SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),64,'W-T3 Beneficiary-Leave Given Name blank unless individual');
       end;

       If FetchElmFNo(RetNo,FNo,4)='3' then  //t20120404
       begin
        If Length(FetchElmFNo(RetNo,FNo,46))<>15 then
         SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),46,'W-T3 Beneficiary-Enter 15 character Business Number');
       end;

       If FetchElmFNo(RetNo,FNo,4)='4' then  //t20120405
       begin
        If UpperCase(LeftStr(FetchElmFNo(RetNo,FNo,46),1))='T' then
        Begin
         If Length(FetchElmFNo(RetNo,FNo,46))<>9 then
         SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),46,'W-T3 Beneficiary-Trust Recipient Id is incorrect');
        end
        else if (ValidSin(s) = false) and (ValidBusNumber(RetNo,s) = false) then
         SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),46,'W-T3 Beneficiary-Recipient Id may be incorrect')

       end;

       If FetchElmFNo(RetNo,FNo,64)='' then  //20120404    //first nm
       begin
        If FetchElmFNo(RetNo,FNo,4)<'3' then
         SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),64,'W-T3 Beneficiary-First Name missing');
       end;

       If FetchElmFNo(RetNo,FNo,26)='' then SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),26,'E-T3 Beneficiary-Last Name missing');
       If FetchElmFNo(RetNo,FNo,27)='' then SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),27,'E-T3 Beneficiary-Street missing');
       If FetchElmFNo(RetNo,FNo,28)='' then SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),28,'E-T3 Beneficiary-City missing');
       If FetchElmFNo(RetNo,FNo,29)='' then SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),29,'E-T3 Beneficiary-Province missing');
       If FetchElmFNo(RetNo,FNo,65)='' then SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),65,'E-T3 Beneficiary-Postal code missing');
       If (UpperCase(FetchElmFNo(RetNo,FNo,3))<>'O')
       and (UpperCase(FetchElmFNo(RetNo,FNo,3))<>'A')
       and (UpperCase(FetchElmFNo(RetNo,FNo,3))<>'C')
       then SaveDiagnostic(RetNo,'T3SUPL#'+AllTrim(IntToStr(j)),3,'E-T3 Beneficiary-Reporting code must be O, A or C');
    end;
   end;

   ErrMsg := 'E-NAICS Industry Code is invalid';
   } // {? put more}

   If (Ret[RetNo].FrmHasData[GetFormNo('T2125#1')]) and
       (Length(FetchElm(RetNo,'T2125#1',12)) <6) then
       SaveDiagnostic(RetNo,'T2125#1',12,ErrMsg+'-T2125');
   If (Ret[RetNo].FrmHasData[GetFormNo('T2042#1')]) and
       (Length(FetchElm(RetNo,'T2042#1',17)) <6) then
       SaveDiagnostic(RetNo,'T2042#1',17,ErrMsg+'-T2042');
   If (Ret[RetNo].FrmHasData[GetFormNo('T2121#1')]) and
       (Length(FetchElm(RetNo,'T2121#1',11)) <6) then
       SaveDiagnostic(RetNo,'T2121#1',11,ErrMsg+'-T2121');


   for i:=1 to 5 do  //20230402
   Begin
    FNo:=GetFormNo('T776#'+IntToStr(i));
    If (Ret[RetNo].FrmHasData[FNo]) then
    begin
     If FetchElmFNo(RetNo,FNo,15)>'' then  //bn
     Begin
      If Length(FetchElmFNo(RetNo,FNo,15)) <>15 then
         SaveDiagnostic(RetNo,'T776#'+IntToStr(i),15,'E-T776-Business number must be 15 characters');
     end;
    If FetchElmFNo(RetNo,FNo,111)>'' then  //bn
     Begin
      If Length(FetchElmFNo(RetNo,FNo,111))<>6 then
         SaveDiagnostic(RetNo,'T776#'+IntToStr(i),111,'E-T776-Postal Code must be 6 characters long');
     end;
    end;
   End;


  If (Ret[RetNo].FrmHasData[GetFormNo('T2125#1')]) then
  begin
   If FetchElm(RetNo,'T2125#1',19)>'' then
   Begin
    If Length(FetchElm(RetNo,'T2125#1',19)) <>15 then
       SaveDiagnostic(RetNo,'T2125#1',19,'E-T2125-Account number must be 15 characters');
   end;
  end;

  If (Ret[RetNo].FrmHasData[GetFormNo('T2042#1')]) then
  begin
   If FetchElm(RetNo,'T2042#1',21)>'' then
   Begin
    If Length(FetchElm(RetNo,'T2042#1',21)) <>15 then
       SaveDiagnostic(RetNo,'T2042#1',21,'E-T2042-Account number must be 15 characters');
   end;
  end;

  If (Ret[RetNo].FrmHasData[GetFormNo('T2121#1')]) then
  begin
   If FetchElm(RetNo,'T2121#1',15)>'' then
   Begin
    If Length(FetchElm(RetNo,'T2121#1',15)) <>15 then
       SaveDiagnostic(RetNo,'T2121#1',15,'E-T2121-Account number must be 15 characters');
   end;
  end;

  //s15
  FNo:=GetFormNo('S15#1');
  if (Ret[RetNo].FrmHasData[FNo]= True)
  and (GetYearEnd(Retno)<'2023-12-31') then //20240313
  Begin
   SaveDiagnostic(RetNo,'S15#1',1,'E-S15: Right click it and select Clear Current form. It is only for Year Ends after Dec 30, 2023');
  end;

  if (Ret[RetNo].FrmHasData[GetFormNo('S15#1')]= True) then
  Begin
   for i:=1 to 40 do
   Begin
     Inst:='#'+IntToStr(i);
     FNo:=GetFormNo('S15'+Inst);
     if FNo>0 then ValidateS15PartB(RetNo,FNo, Inst); //20240310
    end;
  End;

  FNo:=GetFormNo('T1135'); //20160314 Igor
  ValidateT1135(RetNo,FNo);  //20160314 Igor

  ValidateT106(RetNo); //20260817 Alex
  ValidateT106SL(RetNo); //20260817 Alex

  //20260115 Igor >>>
  FNo:= GetFormNo('T1134');
  ValidateT1134(RetNo, FNo);

  for i:= 1 to 10 do
  begin
    FNo:= GetFormNo('T1134S#' + IntToStr(i));

    if (FNo > 0) then ValidateT1134S(RetNo, FNo, i);
  end;
  //20260115 Igor <<<

  FNo:=GetFormNo('INVOICE');
  If (FetchElmFNo(RetNo,FNo,223)+FetchElmFNo(RetNo,FNo,224)
  +FetchElmFNo(RetNo,FNo,225)='')
  and (OptRec.ShowInvoiceWarning = True)
  then
    SaveDiagnostic(RetNo,'INVOICE',223,'W-Invoice (paid by) has not been prepared');

    {Review Marks}
  for i:=0 to (ReviewList.Count - 1) do
  begin
  ReviewRec := ReviewList.Items[i];
  if (ReviewRec.RetNo = RetNo) then
   SaveDiagnostic(RetNo,GetFormName(ReviewRec.FormNo),ReviewRec.FieldId,'R-RvMark'+' '+ GetFormName(ReviewRec.FormNo));
  end;

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

       //SaveDiagnostic(RetNo,FrmNm,126,'D-Tape'+' '+FetchElm(RetNo,FrmNm,121));
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

  //20220120 Igor >>>
  Fno := GetFormNo('T183TRUST');
  ValidateT183TRUST(RetNo, Fno);
  //20220120 Igor <<<

  //Result := ErrorCount;
End;

// 20160123
Procedure RemoveT1135SectionAdata(RetNo: integer; Fno: integer);
Var
  i: integer;
  S: String;
Begin
  For i := 46 to 50 do
  begin
    If FetchElmFNo(RetNo, Fno, i) > '' then
      SaveDiagnostic(RetNo, 'T1135', i,
        'E-T1135-Remove Type of property in Part A');
  end;
  If FetchElmFNo(RetNo, Fno, 53) > '' then
    SaveDiagnostic(RetNo, 'T1135', 53,
      'E-T1135-Remove Type of property in Part A');
  If FetchElmFNo(RetNo, Fno, 55) > '' then
    SaveDiagnostic(RetNo, 'T1135', 55,
      'E-T1135-Remove Type of property in Part A');

  If FetchElmFNo(RetNo, Fno, 57) > '' then
    SaveDiagnostic(RetNo, 'T1135', 57, 'E-T1135-Remove Country code in Part A');
  If FetchElmFNo(RetNo, Fno, 58) > '' then
    SaveDiagnostic(RetNo, 'T1135', 58, 'E-T1135-Remove Country code in Part A');
  If FetchElmFNo(RetNo, Fno, 59) > '' then
    SaveDiagnostic(RetNo, 'T1135', 59, 'E-T1135-Remove Country code in Part A');
  If FetchElmFNo(RetNo, Fno, 60) > '' then
    SaveDiagnostic(RetNo, 'T1135', 60, 'E-T1135-Remove Income in Part A');
  If FetchElmFNo(RetNo, Fno, 64) > '' then
    SaveDiagnostic(RetNo, 'T1135', 64, 'E-T1135-Remove Gain/Loss in Part A');

end;

Procedure RemoveT1135SectionBdata(RetNo: integer; Fno: integer);
Var
  i: integer;
Begin
  i := 1;
  Repeat
    If (FetchElmFNo(RetNo, Fno, i * 10001) > '') then
      SaveDiagnostic(RetNo, 'T1135', i * 10001,
        'E-T1135-Delete all data from Part B');
    Inc(i, 1);
  until i > 7;
end;

Procedure ValidateT1135SectionAdata(RetNo: integer; Fno: integer);
Var
  i: integer;
  S: String;
Begin
  S := '';
  For i := 46 to 50 do
  begin
    S := S + FetchElmFNo(RetNo, Fno, i);
  End;
  S := S + FetchElmFNo(RetNo, Fno, 53) + FetchElmFNo(RetNo, Fno, 55);
  If S = '' then
  begin
    SaveDiagnostic(RetNo, 'T1135', 46,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 47,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 48,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 49,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 50,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 53,
      'E-T1135-Part A: please select at least one Type of property');
    SaveDiagnostic(RetNo, 'T1135', 55,
      'E-T1135-Part A: please select at least one Type of property');
  end;
  S := FetchElmFNo(RetNo, Fno, 57) + FetchElmFNo(RetNo, Fno, 58) +
    FetchElmFNo(RetNo, Fno, 59);
  If S = '' then
  begin
    SaveDiagnostic(RetNo, 'T1135', 57,
      'E-T1135-Part A: Please select at least one Country code');
    SaveDiagnostic(RetNo, 'T1135', 58,
      'E-T1135-Part A: Please select at least one Country code');
    SaveDiagnostic(RetNo, 'T1135', 59,
      'E-T1135-Part A: Please select at least one Country code');
  end;

  (* not efective
    //20180506
    If (FetchElmFNo(RetNo,FNo,34)+FetchElmFNo(RetNo,FNo,86)>'')
    and (FetchElmFNo(RetNo,FNo,36)+FetchElmFNo(RetNo,FNo,42)='') then
    Begin
    SaveDiagnostic(RetNo,'T1135',36,'E-T1135-Please select a box  on the left side');
    SaveDiagnostic(RetNo,'T1135',42,'E-T1135-Please select a box  on the left side');
    End;
  *)

  If FetchElmFNo(RetNo, Fno, 60) = '' then
    SaveDiagnostic(RetNo, 'T1135', 60,
      'E-T1135-Part A: please enter an amount in the Income from all' + Chr(13)
      + ' specified foreign property field. If nil enter 0.');

  If FetchElmFNo(RetNo, Fno, 64) = '' then
    SaveDiagnostic(RetNo, 'T1135', 64,
      'E-T1135-Part A: please enter an amount in the Gain/Loss from the disposition from'
      + Chr(13) + 'all specified foreign property field. If nil enter 0.');

end;

Procedure ValidateT1135SectionBdata(RetNo: integer; Fno: integer);
Var
  i: integer;
  S: String;
  Cnt: integer;
Begin
  Cnt := 0; // count entries in section B
  i := 1;
  Repeat
    If (FetchElmFNo(RetNo, Fno, i * 10000 + 1) > '') then
      Cnt := Cnt + 1; // 20160325 //20160505 Igor
    Inc(i, 1);
  until i > 7;
  If Cnt = 0 then
    SaveDiagnostic(RetNo, 'T1135', 10001,
      'E-T1135-Specified foreign property has been divided into 7 categories. At least one row must be fully completed in one of the 7 tables provided');
  // 20160325 //20160505 Igor
  // check country code
  i := 1;
  Repeat
    If (FetchElmFNo(RetNo, Fno, i * 10000 + 1) > '') and
      (FetchElmFNo(RetNo, Fno, i * 10000 + 2) = '') then
      SaveDiagnostic(RetNo, 'T1135', 0,
        'E-T1135-Part B: If you enter Name, you must also enter Country Code');
    Inc(i, 1);
  until i > 7;
end;

Procedure ValidateT1135(RetNo: integer; Fno: integer);
// Var s:String;
begin
  // T1135  brand new 20160124  REDO
  If Ret[RetNo].FrmHasData[Fno] = True then
  Begin
   
    //20220325
    if (FetchElmFNo(RetNo,FNo,22)>'') and (UpperCase(LeftStr(FetchElmFNo(RetNo, Fno, 65),1))<>'R') then //amended but no revision
       SaveDiagnostic(RetNo, 'T1135', 65, 'E-T1135-Please enter revision id R1 or R2, etc');

    If FetchElmFNo(RetNo, Fno, 15) = '' then
      SaveDiagnostic(RetNo, 'T1135', 15, 'E-T1135-Street address is required');
    If FetchElmFNo(RetNo, Fno, 17) = '' then
      SaveDiagnostic(RetNo, 'T1135', 17, 'E-T1135-City is required');
    If FetchElmFNo(RetNo, Fno, 63) = '' then
      SaveDiagnostic(RetNo, 'T1135', 63,
        'E-T1135-Province or territory is required');
    If FetchElmFNo(RetNo, Fno, 16) = '' then
      SaveDiagnostic(RetNo, 'T1135', 16,
        'E-T1135-Postal or Zip code is required');
    If FetchElmFNo(RetNo, Fno, 28) = '' then
      SaveDiagnostic(RetNo, 'T1135', 28, 'E-T1135-Country Code is required');
    If FetchElmFNo(RetNo, Fno, 28) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 28,
        'E-T1135-Country Code cannot be OTH in Address');

    //if Ret[RetNo].Frm then

    If FetchElmFNo(RetNo, Fno, 363) > '' then  //foreign property //20230606
    Begin
     If FetchElmFNo(RetNo, Fno, 70) = '' then
       SaveDiagnostic(RetNo, 'T1135', 70,
         'E-T1135-Certification section - Name is required');
    End;

    // tbl 1
    If FetchElmFNo(RetNo, Fno, 10002) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 10002,
        'E-T1135-Country Code cannot be OTH in Part B-Table 1'); // 20160123
    If FetchElmFNo(RetNo, Fno, 10007) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 10007,
        'E-T1135-Country Code cannot be OTH in Part B-Table 1'); // 20160123
    If FetchElmFNo(RetNo, Fno, 10012) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 10012,
        'E-T1135-Country Code cannot be OTH in Part B-Table 1'); // 20160123
    // tbl 5
    If FetchElmFNo(RetNo, Fno, 50002) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 50002,
        'E-T1135-Country Code cannot be OTH in Part B-Table 5'); // 20160123
    If FetchElmFNo(RetNo, Fno, 50007) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 50007,
        'E-T1135-Country Code cannot be OTH in Part B-Table 5'); // 20160123
    If FetchElmFNo(RetNo, Fno, 50012) = 'OTH' then
      SaveDiagnostic(RetNo, 'T1135', 50012,
        'E-T1135-Country Code cannot be OTH in Part B-Table 5'); // 20160123
    // -----------------------

    If FetchElmFNo(RetNo, Fno, 363) > '' then  //foreign property //20230606
    Begin
     If FetchElmFNo(RetNo, Fno, 36) + FetchElmFNo(RetNo, Fno, 42) = '' then
       // if not B select A or the election to use B
       SaveDiagnostic(RetNo, 'T1135', 36,
         'E-T1135-Please check the appropriate box; Total Cost of foreign property exceeds $100,000 but less than $250,000 OR Total Cost of foreign property is $250,000 or more.');
    end;

    If (FetchElmFNo(RetNo, Fno, 36) > '') And (FetchElmFNo(RetNo, Fno, 86) = '')
    // Strictly A
    then
    begin
      RemoveT1135SectionBdata(RetNo, Fno); // 20160123
      ValidateT1135SectionAdata(RetNo, Fno); // 20160123
    end;

    // use section B
    If (FetchElmFNo(RetNo, Fno, 42) > '') // >=$250,000
      Or ((FetchElmFNo(RetNo, Fno, 36) > '') And (FetchElmFNo(RetNo, Fno, 86) > '')) then
    Begin
      RemoveT1135SectionAdata(RetNo, Fno);
      ValidateT1135SectionBdata(RetNo, Fno);
       ValidateT1135MaxYearEnd(RetNo, Fno); //20230214
    end;
    //20200505
    if UpperCase(FetchElmFNo(RetNo, Fno, 29)) = 'Y' then
    Begin
     If FetchElmFNo(RetNo, Fno, 75)='' then SaveDiagnostic(RetNo, 'T1135', 75,'E-T1135-Preparer Address is required');
     If FetchElmFNo(RetNo, Fno, 76)='' then SaveDiagnostic(RetNo, 'T1135', 76,'E-T1135-Preparer Postal or zip is required');
    End;

    // 20190417
    //20220128 Igor >>>
    if FetchElmFNo(RetNo, Fno, 72) > '' then
      //if Length(FetchElmFNo(RetNo, Fno, 72)) < 14 then
      if not MatchesMask(FetchElmFNo(RetNo, Fno, 72), '[1]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') then
        SaveDiagnostic(RetNo, 'T1135', 72,
          'E-T1135-Phone must be in the format 1-999-999-9999');

    if FetchElmFNo(RetNo, Fno, 77) > '' then
      //if Length(FetchElmFNo(RetNo, Fno, 77)) < 14 then
      if not MatchesMask(FetchElmFNo(RetNo, Fno, 77), '[1]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]') then
        SaveDiagnostic(RetNo, 'T1135', 77,
          'E-T1135-Phone must be in the format 1-999-999-9999');
    //20220128 Igor <<<
  end;
end;

Procedure ValidateT3(RetNo:Integer;FNo:Integer); //20180317
Var Prv:String;
Begin
   If (FetchElmFNo(RetNo,FNo,1) > '')  and
      (GetT3AccountNumber(RetNo) = '')
   then
      SaveDiagnostic(RetNo,'T3',2,'E-T3 Trust Account is required');

   //20250118
   If (FetchElmFNo(RetNo,FNo,11)='')  then //Not in Canada
   begin
    If(FetchElmFNo(RetNo,FNo,9)='') then
      SaveDiagnostic(RetNo,'T3',9,'E-T3 Province code is required');
   end;

   If (FetchElmFNo(RetNo,FNo,11)>'')  then //Not in Canada
   begin
    If (FetchElmFNo(RetNo,FNo,9)>'') then
      SaveDiagnostic(RetNo,'T3',9,'E-T3 Remove Province code');
   end;

   //20231121
   Prv:=FetchElm(RetNo,'T3',67);  //20240327
   if (Prv>'') and (IsCanadianProvince(Prv)=True) then //20240327
   begin
    if ValidPostal(RetNo,FetchElm(RetNo,'T3',8))=false then
      SaveDiagnostic(RetNo,'T3',8,'E-T3 Postal code is invalid');
   end;

  { //20240227
   if FetchElm(RetNo,'T3',23)>'' then
   Begin
    if ValidPostal(RetNo,FetchElm(RetNo,'T3',23))=false then
     SaveDiagnostic(RetNo,'T3',23,'E-T3 Postal code is invalid');
   End;
  }


   If FetchElmFNo(RetNo,FNo,1)='' then SaveDiagnostic(RetNo,'T3',1,'E-T3 Name of trust is required'); //20220401
   If Length(FetchElmFNo(RetNo,FNo,1))>60 then SaveDiagnostic(RetNo,'T3',1,'E-T3 Trust name exceeds 60 characters. Reduce it for Efiling'); //20220503
   //20220331
   If (FetchElmFNo(RetNo,FNo,43) >'') then //graduated
   begin
     If (FetchElmFNo(RetNo,FNo,20) = '') then
      SaveDiagnostic(RetNo,'T3',20,'E-T3 Date of Death is required');
     If (FetchElmFNo(RetNo,FNo,25) = '') then
      SaveDiagnostic(RetNo,'T3',25,'E-T3 SIN is required');
   end;

   If (FetchElmFNo(RetNo,FNo,45) >'') then //qaul disab
   begin
     If (FetchElmFNo(RetNo,FNo,20) = '') then
      SaveDiagnostic(RetNo,'T3',20,'E-T3 Date of Death is required');
     If (FetchElmFNo(RetNo,FNo,25) = '') then
      SaveDiagnostic(RetNo,'T3',25,'E-T3 SIN is required');
   end;


   If (FetchElmFNo(RetNo,FNo,81) > '') then //20220331
   Begin
     If (FetchElmFNo(RetNo,FNo,81) = '900') or
        (FetchElmFNo(RetNo,FNo,81) = '903') or
        (FetchElmFNo(RetNo,FNo,81) = '904') or
        (FetchElmFNo(RetNo,FNo,81) = '905')
     then //20220331
     begin
      If (FetchElmFNo(RetNo,FNo,20) = '') then
        SaveDiagnostic(RetNo,'T3',20,'E-T3 Date of Death is required');
      If (FetchElmFNo(RetNo,FNo,25) = '') then
        SaveDiagnostic(RetNo,'T3',25,'E-T3 SIN is required');
     end;
   end;

   If (FetchElmFNo(RetNo,FNo,81) > '') then //20220503
   begin
    if (FetchElmFNo(RetNo,FNo,81) = '901') then   //20220503
    begin
     If (FetchElmFNo(RetNo,FNo,20) = '') then
       SaveDiagnostic(RetNo,'T3',20,'E-T3 Date of Death is required');
    end;
   end;


   //jz//20260324
   //trustCreationDate - efile error if TrustCreationDate in JSON for a trust other than type 300 series
   if (pos('3',FetchElm(RetNo,'T3',81)) <> 1) and (FetchElm(RetNo,'T3',51)>'') then
    SaveDiagnostic(RetNo,'T3',51,'E-TrustCreationDate with a non 300 series trust type may cause Efiling errors');
   //jz//20260324 - did these but they already seem to be handled above? leave out for now
   {
   //testatorDeathDate - mandatory if 900 series
   if ( (pos('9',FetchElm(RetNo,'T3',81)) = 1)  or
        (FetchElm(RetNo,'T3',43)>'')            or
        (FetchElm(RetNo,'T3',45)>'')
      )                                         and
     (FetchElm(RetNo,'T3',20)='') then
     SaveDiagnostic(RetNo,'T3',20,'E-TestatorDeathDate is mandatory with a 900 series trust type code ');
   //deceasedSocialInsuranceNumber -mandatory if the trust type is 903
   if (FetchElm(RetNo,'T3',43) > '') and (FetchElm(RetNo,'T3',25)='') then
     SaveDiagnostic(RetNo,'T3',25,'E-DeceasedSocialInsuranceNumber is mandatory if the trust type is 903');


   {Tricky
    Else
    begin
    If (FetchElmFNo(RetNo,FNo,51) = '') then
     SaveDiagnostic(RetNo,'T3',51,'E-T3 Date trust was created is required');
    end;
    }




   //2022401
   if FetchElmFNo(RetNo,FNo,136)>'' then //OPTION 1
   Begin
    If (FetchElmFNo(RetNo,FNo,3) = '') then SaveDiagnostic(RetNo,'T3',3,'E-T3 Trustee First Name is required');
    If (FetchElmFNo(RetNo,FNo,53) = '') then SaveDiagnostic(RetNo,'T3',53,'E-T3 Trustee Last Name is required');
    If (FetchElmFNo(RetNo,FNo,4) = '') then SaveDiagnostic(RetNo,'T3',4,'E-T3 Trustee Street is required');
    If (FetchElmFNo(RetNo,FNo,7)='') then SaveDiagnostic(RetNo,'T3',7,'E-T3 Trustee City is required required');
   // If (FetchElmFNo(RetNo,FNo,5) = '') then SaveDiagnostic(RetNo,'T3',5,'W-T3 Trustee Telephone are is required');
   // If (FetchElmFNo(RetNo,FNo,6) = '') then SaveDiagnostic(RetNo,'T3',6,'W-T3 Trustee Telephone is required');
    If (FetchElmFNo(RetNo,FNo,67)= '') then SaveDiagnostic(RetNo,'T3',67,'E-T3 Trustee Province code is required');
   End;

   if FetchElmFNo(RetNo,FNo,137)>'' then //option 2  //20211102
   Begin
    If (FetchElmFNo(RetNo,FNo,143) = '') then SaveDiagnostic(RetNo,'T3',143,'E-T3 Name of non-individual trustee is required');
    If (FetchElmFNo(RetNo,FNo,55) = '') then SaveDiagnostic(RetNo,'T3',55,'E-T3 Contact First Name is required');
    If (FetchElmFNo(RetNo,FNo,55) = '') then SaveDiagnostic(RetNo,'T3',55,'E-T3 Contact First Name is required');
    If (FetchElmFNo(RetNo,FNo,60) = '') then SaveDiagnostic(RetNo,'T3',60,'E-T3 Contact Last Name is required');
    If (FetchElmFNo(RetNo,FNo,64) = '') then SaveDiagnostic(RetNo,'T3',64,'E-T3 Contact Street is required');
    If (FetchElmFNo(RetNo,FNo,65) = '') then SaveDiagnostic(RetNo,'T3',65,'E-T3 Contact City is required');
    If (FetchElmFNo(RetNo,FNo,66)= '')  then SaveDiagnostic(RetNo,'T3',66,'E-T3 Contact Province code is required');
    //If (FetchElmFNo(RetNo,FNo,73) = '') then SaveDiagnostic(RetNo,'T3',73,'W-T3 Contact Country code is required');
   End;


   If FetchElmFNo(RetNo,FNo,26)>'' then
   Begin
     If FetchElmFNo(RetNo,FNo,28)='' then SaveDiagnostic(RetNo,'T3',28,'E-T3 Enter last year filed');  //20220309
   End;
   //20180124

   If FetchElmFNo(RetNo,FNo,68)>'' then
   Begin If Length(FetchElmFNo(RetNo,FNo,68))<>2 then SaveDiagnostic(RetNo,'T3',68,'E-T3 A valid province code is required');End;

   If ValidSin(FetchElm(RetNo,'T3',25)) = false then SaveDiagnostic(RetNo,'T3',25,'E-T3-SIN is incorrect');
   If ValidSin(FetchElm(RetNo,'T3',50)) = false then SaveDiagnostic(RetNo,'T3',50,'E-T3-SIN is incorrect');

   If (FetchElmFNo(RetNo,FNo,49)>'') and (FetchElmFNo(RetNo,FNo,48)>'') then  //20160207
    SaveDiagnostic(RetNo,'T3',49,'E-This return may have been filed last year as final.');

   //20180317
   If (FetchElmFNo(RetNo,FNo,12)>'') and (Length(FetchElmFNo(RetNo,FNo,12))<>3) then  //20160207
    SaveDiagnostic(RetNo,'T3',12,'E-T3 Phone area must be 3 digits');

   If (FetchElmFNo(RetNo,FNo,13)>'') and (Length(FetchElmFNo(RetNo,FNo,13))<>8) then  //20160207
    SaveDiagnostic(RetNo,'T3',13,'E-T3-Phone must be in the format 999-99999');

   If FetchElmFNo(RetNo,FNo,21)>'' then //mailing address
   Begin
    If FetchElmFNo(RetNo,FNo,12)='' then SaveDiagnostic(RetNo,'T3',12,'E-T3-Provide full address data');
    If FetchElmFNo(RetNo,FNo,13)='' then SaveDiagnostic(RetNo,'T3',13,'E-T3-Provide full address data');
    If FetchElmFNo(RetNo,FNo,57)='' then SaveDiagnostic(RetNo,'T3',57,'E-T3-Provide full address data');
    If FetchElmFNo(RetNo,FNo,68)='' then SaveDiagnostic(RetNo,'T3',68,'E-T3-Provide full address data');
    If FetchElmFNo(RetNo,FNo,58)='' then SaveDiagnostic(RetNo,'T3',58,'E-T3-Provide full address data');
   End;

//removed old code //20230101
end;

Procedure ValidateT183TRUST(RetNo: integer; Fno: integer); //20220120 Igor
Var
  i: integer;
  S: String;
Begin
  SaveDiagnostic(RetNo, 'T183TRUST', 999, 'W-   ');
  SaveDiagnostic(RetNo, 'T183TRUST', 999,
    'W-*** ----------T183TRUST DIAGNOSTICS FOR TAX PREPARER-------------***');


  if FetchElmFNo(RetNo, Fno, 21) > '' then
  Begin
    if ValidateDCN(RetNo) = false then
      SaveDiagnostic(RetNo, 'T183TRUST', 21,
        'E-The DCN Number is incorrect. Please correct before Efiling');
  End;

  SaveDiagnostic(RetNo, 'T183TRUST', 999,
    'W------------------------------------------------------------------------------');
end;


Procedure ValidateT1135MaxYearEnd(RetNo: integer; Fno: integer); //20230214
Var
  ArrayNo,BoxesPerRow,i: integer;  //array number
  Elm1,Elm2:Integer;
  S: String;
  Cnt: integer;
Begin
  ArrayNo := 1;
  BoxesPerRow := 5;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Funds held at year end must not exceed Maximum funds during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;
  // second form   I can see the logic now....  So I will contnue  its not hard
  ArrayNo := 2;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: The cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

  ArrayNo := 3;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Indebtedness owed by non-resident cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

 ArrayNo := 3;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Indebtedness owed by non-resident cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

  ArrayNo := 4;
  BoxesPerRow := 7;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Interests in non-resident trusts cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;


 ArrayNo := 5;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Real property outside Canada cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;

 ArrayNo := 6;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Other property outside Canada cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;


 ArrayNo := 7;
  BoxesPerRow := 6;
  Elm1 := ArrayNo * 10000 + 3;
  Elm2 := ArrayNo * 10000 + 4;
  For i := 0 to MaxDynamicElmsPerForm do
  begin
    If Vl(FetchElmFNo(RetNo, FNo, Elm2))>Vl(FetchElmFNo(RetNo, FNo, Elm1)) then
      SaveDiagnostic(RetNo, 'T1135',Elm2,'E-T1135-Part B: Property held in an account with a Canadian registered securities dealer or a Canadian trust company cost amount at year-end cannot exceed Maximum cost amount during the year');
    Inc(Elm1,BoxesPerRow);
    Inc(Elm2,BoxesPerRow);
  end;
end;

//20240310
Procedure ValidateS15PartB(RetNo: integer; Fno: integer; Inst:String);
Var
  i: integer;
  S,FName: String;
Begin
  if FetchElm(RetNo,'S15#1',33)>'' then Exit;  //large beno

  if FetchElm(RetNo,'S15#1',1)+FetchElm(RetNo,'S15#1',2)='' then
  Begin
   SaveDiagnostic(RetNo, 'S15#1',1,'E-S15-Please select first time or not');
   SaveDiagnostic(RetNo, 'S15#1',2,'E-S15-Please select first time or not');
  End;


  if FetchElm(RetNo,'S15#1',2)+FetchElm(RetNo,'S15#1',4)='XX' then
  //ok
  Else
  Begin
   if FetchElm(RetNo,'S15#1',5)+FetchElm(RetNo,'S15#1',6)='' then
   Begin
    SaveDiagnostic(RetNo, 'S15#1',5,'E-S15-Please select Add or Modify');
    SaveDiagnostic(RetNo, 'S15#1',6,'E-S15-Please select Add or Modify');
   End;
  End;

  if FetchElm(RetNo,'S15#1',62)>'' then
  Begin
   If (FetchElm(RetNo,'S15#1',1)='') and (FetchElm(RetNo,'S15#1',2)='') then
   Begin
    SaveDiagnostic(RetNo, 'S15#1',3,'E-S15-Please select yes or No on the first time question');
   End;
  End;


  If (FetchElm(RetNo,'S15#1',2)>'') then //NO
  Begin
   if FetchElm(RetNo,'S15#1',3)+FetchElm(RetNo,'S15#1',4)='' then
   Begin
     SaveDiagnostic(RetNo, 'S15#1',3,'E-S15-Please answer the question below');
     //SaveDiagnostic(RetNo, 'S15#1',4,'E-S15-Please answer the question below');                                                                          '
   End;
  end;

  if (FetchElm(RetNo,'S15#1',1)>'')      //first time  beno
  Or (FetchElm(RetNo,'S15#1',3)>'') then    //beno changed
  Begin //validate section B
   FName:='S15'+Inst;

   if (FetchElmFNo(RetNo,FNo,5)>'') or (FetchElmFNo(RetNo,FNo,6)>'') then   //add or modify
   Begin
    if FetchElmFNo(RetNo,FNo,7)+FetchElmFNo(RetNo,FNo,8)+FetchElmFNo(RetNo,FNo,9)+FetchElmFNo(RetNo,FNo,10)='' then
    begin
     SaveDiagnostic(RetNo, 'S15'+Inst,7,'E-Part B: Select Reportable Entity Type');
     SaveDiagnostic(RetNo, 'S15'+Inst,8,'E-Part B: Select Reportable Entity Type');
     SaveDiagnostic(RetNo, 'S15'+Inst,9,'E-Part B: Select Reportable Entity Type');
     SaveDiagnostic(RetNo, 'S15'+Inst,10,'E-Part B: Select Reportable Entity Type');
    end;

    if FetchElmFNo(RetNo,FNo,11)+FetchElmFNo(RetNo,FNo,12)+FetchElmFNo(RetNo,FNo,13)+FetchElmFNo(RetNo,FNo,14)='' then
    begin
     SaveDiagnostic(RetNo, 'S15'+Inst,11,'E-Part B: Select Entity Classification');
     SaveDiagnostic(RetNo, 'S15'+Inst,12,'E-Part B: Select Entity Classification');
     SaveDiagnostic(RetNo, 'S15'+Inst,13,'E-Part B: Select Entity Classification');
     SaveDiagnostic(RetNo, 'S15'+Inst,14,'E-Part B: Select Entity Classification');
    end;

    if FetchElmFNo(RetNo,FNo,19)+FetchElmFNo(RetNo,FNo,20)+FetchElmFNo(RetNo,FNo,21)+FetchElmFNo(RetNo,FNo,22)
     +FetchElmFNo(RetNo,FNo,23)+FetchElmFNo(RetNo,FNo,24)='' then
     Begin
       SaveDiagnostic(RetNo, 'S15'+Inst,19,'E-Part B: Select Tax Identification number');
       SaveDiagnostic(RetNo, 'S15'+Inst,20,'E-Part B: Select Tax Identification number');
       SaveDiagnostic(RetNo, 'S15'+Inst,21,'E-Part B: Select Tax Identification number');
       SaveDiagnostic(RetNo, 'S15'+Inst,22,'E-Part B: Select Tax Identification number');
       SaveDiagnostic(RetNo, 'S15'+Inst,23,'E-Part B: Select Tax Identification number');
       SaveDiagnostic(RetNo, 'S15'+Inst,24,'E-Part B: Select Tax Identification number');
     End;

     //20250729
    if (FetchElmFNo(RetNo,FNo,19)>'') and (FetchElmFNo(RetNo,FNo,64)='') then
      SaveDiagnostic(RetNo, 'S15'+Inst,64,'E-Part B: Enter Tax Identification number');
    if (FetchElmFNo(RetNo,FNo,22)>'') and (FetchElmFNo(RetNo,FNo,65)='') then
      SaveDiagnostic(RetNo, 'S15'+Inst,65,'E-Part B: Enter Tax Identification number');
    if (FetchElmFNo(RetNo,FNo,20)>'') and (FetchElmFNo(RetNo,FNo,66)='') then
      SaveDiagnostic(RetNo, 'S15'+Inst,66,'E-Part B: Enter Tax Identification number');
    if (FetchElmFNo(RetNo,FNo,23)>'') and (FetchElmFNo(RetNo,FNo,67)='') then
      SaveDiagnostic(RetNo, 'S15'+Inst,67,'E-Part B: Enter Tax Identification number');
    if (FetchElmFNo(RetNo,FNo,21)>'') and (FetchElmFNo(RetNo,FNo,28)='') then
      SaveDiagnostic(RetNo, 'S15'+Inst,28,'E-Part B: Enter Tax Identification number');
    if (FetchElmFNo(RetNo,FNo,24)>'') and (FetchElmFNo(RetNo,FNo,68)='') then
      SaveDiagnostic(RetNo, 'S15'+Inst,68,'E-Part B: Enter Tax Identification number');

    if FetchElmFNo(RetNo,FNo,25)+FetchElmFNo(RetNo,FNo,26)+FetchElmFNo(RetNo,FNo,27)='' then
     begin
       SaveDiagnostic(RetNo, 'S15'+Inst,25,'E-Part B: Select Country of Residence');
       SaveDiagnostic(RetNo, 'S15'+Inst,26,'E-Part B: Select Country of Residence');
       SaveDiagnostic(RetNo, 'S15'+Inst,27,'E-Part B: Select Country of Residence');
     end;

     if (FetchElmFNo(RetNo,FNo,26)>'') Or (FetchElmFNo(RetNo,FNo,27)>'') then
     begin
       if (FetchElmFNo(RetNo,FNo,30)='CAN') or (FetchElmFNo(RetNo,FNo,30)='') then
        SaveDiagnostic(RetNo, 'S15'+Inst,30,'E-Part B: Select Country');
     end;

     if (FetchElmFNo(RetNo,FNo,26)>'') Or (FetchElmFNo(RetNo,FNo,27)>'') then
     begin
       if IsCanadianProvince(FetchElmFNo(RetNo,FNo,32)) or (FetchElmFNo(RetNo,FNo,32)='') then
        SaveDiagnostic(RetNo, 'S15'+Inst,32,'E-Part B: Select Province/State');
     end;

     if (FetchElmFNo(RetNo,FNo,25)>'') then  //canadian
     begin
       if IsCanadianProvince(FetchElmFNo(RetNo,FNo,32))=false then
        SaveDiagnostic(RetNo, 'S15'+Inst,32,'E-Part B: Select Canadian Province');
     end;

     if (FetchElmFNo(RetNo,FNo,27)>'') then
     begin
       if FetchElmFNo(RetNo,FNo,60)='' then
       SaveDiagnostic(RetNo, 'S15'+Inst,60,'E-Part B: Enter Other Country name');
     end;


    if FetchElmFNo(RetNo,FNo,11)>'' then  //natural person
    begin
     If FetchElmFNo(RetNo,FNo,16)='' then SaveDiagnostic(RetNo, 'S15'+Inst,16,'E-Part B: Enter First Name');
     If FetchElmFNo(RetNo,FNo,17)='' then SaveDiagnostic(RetNo, 'S15'+Inst,17,'E-Part B: Enter Last Name');
     If FetchElmFNo(RetNo,FNo,18)='' then SaveDiagnostic(RetNo, 'S15'+Inst,18,'E-Part B: Enter Birthdate');
    end;

    if FetchElmFNo(RetNo,FNo,19)>''  then //SIN
    Begin
     If ValidSin(FetchElmFNo(RetNo,FNo,64))=false then   //20250729
        SaveDiagnostic(RetNo, 'S15'+Inst,64,'E-Part B: Invalid SIN Number');
    End;

    if FetchElmFNo(RetNo,FNo,22)>''  then //BN
    Begin
     If ValidBusNumberFull(RetNo,FetchElmFNo(RetNo,FNo,65))=false then  //20250729
        SaveDiagnostic(RetNo, 'S15'+Inst,65,'E-Part B: Invalid Business Number');  //20250729
    End;

    if FetchElmFNo(RetNo,FNo,23)>''  then //T3 = TN
    Begin
     if LeftStr(FetchElmFNo(RetNo,FNo,67),1) <> 'T'  then
        SaveDiagnostic(RetNo, 'S15'+Inst,67,'W-Part B: Enter a valid TrustNumber'); //20250729
    End;

    if FetchElmFNo(RetNo,FNo,27)>''  then //country other
    Begin
     if FetchElmFNo(RetNo,FNo,30) = ''  then
        SaveDiagnostic(RetNo, 'S15'+Inst,30,'E-Part B: Enter Country of residence Name');
    End;


    //address validation
    if (FetchElmFNo(RetNo,FNo,29)='') then
       SaveDiagnostic(RetNo, 'S15'+Inst,29,'E-Part B: Enter the address street');

    if (FetchElmFNo(RetNo,FNo,31)='') then
       SaveDiagnostic(RetNo, 'S15'+Inst,31,'E-Part B: Enter City');

    if (FetchElmFNo(RetNo,FNo,30)='') then
       SaveDiagnostic(RetNo, 'S15'+Inst,30,'E-Part B: Enter Country');

    if (FetchElmFNo(RetNo,FNo,32)='') then
       SaveDiagnostic(RetNo, 'S15'+Inst,32,'E-Part B: Enter Province');



    if (FetchElmFNo(RetNo,FNo,61)='') then
       SaveDiagnostic(RetNo, 'S15'+Inst,61,'E-Part B: Enter Postal Code');

    if FetchElmFNo(RetNo,FNo,12)+FetchElmFNo(RetNo,FNo,13)+FetchElmFNo(RetNo,FNo,14)>'' then
    Begin
     if FetchElmFNo(RetNo,FNo,15)='' then
      SaveDiagnostic(RetNo, 'S15'+Inst,15,'E-Part B: Enter Entity Name');
    End;
   End; //aed/modify entity
  End; //validate B
end;

//20260115 Igor >>>
procedure ValidateT1134(RetNo: Integer; Fno: Integer);
var
  ArrayNo, BoxesPerRow, RowCount, I, Elm: Integer;
  Value: string;
  UniqueList: TStringList;

  function MandatoryCheck(AElmId: Integer; AError: string): boolean;
  begin
    Result:= True;

    if FetchElmFNo(RetNo, FNo, AElmId).Equals('') then
    begin
      SaveDiagnostic(RetNo, 'T1134', AElmId, 'E-T1134-' + AError);
      Result:= False;
    end;
  end;

  function MandatoryYesNoCheck(AElm1Id, AElm2Id: Integer; AError: string): boolean;
  begin
    Result:= True;

    if (FetchElmFNo(RetNo, FNo, AElm1Id) + FetchElmFNo(RetNo, FNo, AElm2Id)).Equals('') then
    begin
      SaveDiagnostic(RetNo, 'T1134', AElm1Id, 'E-T1134-' + AError);
      Result:= False;
    end;
  end;

begin
  UniqueList:= TStringList.Create;
  try
    if Ret[RetNo].FrmHasData[FNo] then
    begin
      MandatoryCheck(25, 'Action is required'); //20230601 Igor

      if (FetchElmFNo(RetNo, FNo, 31) + FetchElmFNo(RetNo, FNo, 32)).Equals('') then SaveDiagnostic(RetNo, 'T1134', 31, 'E-T1134-You must specify if the T1134 Summary is filed for one entity or a group');

      MandatoryCheck(30, 'Address number is required');
      MandatoryCheck(15, 'Street Address is required');
      MandatoryCheck(16, 'City is required');
      MandatoryCheck(17, 'Province or territory is required');

      if MandatoryCheck(18, 'Postal or Zip code is required') and not ValidPostal(RetNo, FetchElmFNo(RetNo, FNo, 18), FetchElmFNo(RetNo, FNo, 141)) then SaveDiagnostic(RetNo, 'T1134', 18, 'E-T1134-Postal-Invalid Format of Postal/Zip code, please try again');

      MandatoryCheck(141, 'Country is required');

      if (FetchElmFNo(RetNo, FNo, 40) + FetchElmFNo(RetNo, FNo, 41) + FetchElmFNo(RetNo, FNo, 42) + FetchElmFNo(RetNo, FNo, 43)).Equals('') then SaveDiagnostic(RetNo, 'T1134', 40, 'E-T1134-At least 1 valid NAICS code is required');

      MandatoryCheck(19, 'Taxation Year “From” Date is required');
      MandatoryCheck(20, 'Taxation Year “To” Date is required');
      MandatoryYesNoCheck(21, 22, 'YES or NO is required');
      MandatoryCheck(143, 'First Name is required');
      MandatoryCheck(144, 'Last Name is required');

      if (FetchElmFNo(RetNo, FNo, 145) + FetchElmFNo(RetNo, FNo, 146)).Equals('') then SaveDiagnostic(RetNo, 'T1134', 145, 'E-T1134-Telephone Number is required');

      MandatoryCheck(23, 'Certifier Name is required');
      MandatoryCheck(147, 'Date of signature is required');
      MandatoryCheck(148, ' Title of Certifier is required');
      UniqueList.Add(FetchElmFNo(RetNo, FNo, 8));

      // individuals check
      ArrayNo:= 1;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
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
          Value:= FetchElmFNo(RetNo, FNo, Elm + 10);

          if not ValidSin(Value) then SaveDiagnostic(RetNo, 'T1134', Elm + 10, 'E-T1134-SIN is not valid') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, 'T1134', Elm + 10, 'E-T1134-SIN is already used in the list') else UniqueList.Add(Value);
        end;

        Elm:= Elm + BoxesPerRow;
      end;

      // corporation check
      ArrayNo:= 2;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
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
          Value:= FetchElmFNo(RetNo, FNo, Elm + 8);

          if not ValidBusNumber(RetNo, Value) then SaveDiagnostic(RetNo, 'T1134', Elm + 8, 'E-T1134-Business Number is not valid') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, 'T1134', Elm + 8, 'E-T1134-Business Number is already used in the list') else UniqueList.Add(Value);
        end;
        if (FetchElmFNo(RetNo,FNo,Elm + 9) + FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12)).Equals('') then SaveDiagnostic(RetNo, 'T1134', Elm + 9, 'E-T1134-At least 1 valid NAICS code is required');

        Elm:= Elm + BoxesPerRow;
      end;

      // trust check
      ArrayNo:= 3;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
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
          Value:= FetchElmFNo(RetNo, FNo, Elm + 8);

          if not IsValidTrustNo(Value) then SaveDiagnostic(RetNo, 'T1134', Elm + 8, 'E-T1134-Trust Account Number is not valid') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, 'T1134', Elm + 8, 'E-T1134-Trust Account Number is already used in the list') else UniqueList.Add(Value);
        end;
        if (FetchElmFNo(RetNo,FNo,Elm + 9) + FetchElmFNo(RetNo,FNo,Elm + 10) + FetchElmFNo(RetNo,FNo,Elm + 11) + FetchElmFNo(RetNo,FNo,Elm + 12)).Equals('') then SaveDiagnostic(RetNo, 'T1134', Elm + 9, 'E-T1134-At least 1 valid NAICS code is required');

        Elm:= Elm + BoxesPerRow;
      end;

      // partnership check
      ArrayNo:= 4;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        MandatoryCheck(Elm + 1, 'Name of Partnerships within related group is required');
        MandatoryCheck(Elm + 2, 'Address number is required');
        MandatoryCheck(Elm + 3, 'Street is required');
        MandatoryCheck(Elm + 4, 'City is required');
        MandatoryCheck(Elm + 5, 'Province/Territory is required');
        MandatoryCheck(Elm + 6, 'Postal Code is required');
        MandatoryCheck(Elm + 7, 'Country Code is required');
        {
        if MandatoryCheck(Elm + 8, 'Partnership''s Number is required') then
        begin
          Value:= FetchElmFNo(RetNo, FNo, Elm + 8);

          if not ValidPartnershipNumber(RetNo, Value) then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Partnership''s Number is not valid')
          else if UniqueList.IndexOf(Value) > -1 then
            SaveDiagnostic(RetNo,'T1134',Elm + 8,'E-T1134-Partnership''s Number is already used in the list')
          else
            UniqueList.Add(Value);
        end;
        MandatoryCheck(Elm + 9, 'Partnership Code is required');
        }
        if (FetchElmFNo(RetNo, FNo, Elm + 10) + FetchElmFNo(RetNo, FNo, Elm + 11) + FetchElmFNo(RetNo, FNo, Elm + 12) + FetchElmFNo(RetNo, FNo, Elm + 13)).Equals('') then SaveDiagnostic(RetNo, 'T1134', Elm + 10, 'E-T1134-At least 1 valid NAICS code is required');

        Elm:= Elm + BoxesPerRow;
      end;

      // each entity information
      ArrayNo:= 5;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Was the entity directly involved in a subsection 85(1) rollover?');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Was the entity directly or indirectly involved in a subsection 85.1(3) transaction?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the entity file a section 86.1 election?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Was the entity involved in a section 87 amalgamation?');
        MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Was the entity involved in a subsection 88(1) winding up?');

        Elm:= Elm + BoxesPerRow;
      end;

      MandatoryYesNoCheck(28, 29, 'Response to If the reporting entity is submitting a group Org chart');
      UniqueList.Clear;

      // related corporation
      ArrayNo:= 6;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        MandatoryCheck(Elm + 1, 'Name of related corporation is required');
        MandatoryCheck(Elm + 2, 'Country code of residence of corporation is required');
        Value:= FetchElmFNo(RetNo, FNo, Elm + 3);

        if MandatoryCheck(Elm + 3, 'Name of FA is required') then
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, 'T1134', Elm + 3, 'E-T1134-Name of FA is already used in the list') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 5, 'Country code of residence of FA is required');
        MandatoryCheck(Elm + 6, 'Corporation''s equity % in FA is required');
        MandatoryCheck(Elm + 7, 'Corporation''s direct equity % in FA is required');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Supplement NOT filed due to dormancy threshold?');

        Elm:= Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // related affiliate
      ArrayNo:= 7;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm + 1);

        if MandatoryCheck(Elm + 1, 'Name of FA is required') then
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, 'T1134', Elm + 1, 'E-T1134-Name of FA is already used in the list') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 3, 'Country code of residence of FA is required');
        MandatoryCheck(Elm + 4, 'Name of other FAs is required');
        MandatoryCheck(Elm + 6, 'Country code of residence of other FAs is required');
        MandatoryCheck(Elm + 7, 'FA''s equity percentage in other FA is required');
        MandatoryCheck(Elm + 8, 'FA''s direct equity percentage in other FA is required');
        MandatoryYesNoCheck(Elm + 9, Elm + 10, 'Supplement NOT filed due to dormancy threshold?');

        Elm:= Elm + BoxesPerRow;
      end;

      UniqueList.Clear;

      // partner
      ArrayNo:= 8;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        MandatoryCheck(Elm + 1, 'Name of partnership within related group is required');
        MandatoryCheck(Elm + 2, 'Address of partner is required');
        MandatoryCheck(Elm + 3, 'Country code of country of residence is required');

        Elm:= Elm + BoxesPerRow;
      end;

      // partnership foreign affiliate
      ArrayNo:= 9;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        MandatoryCheck(Elm + 1, 'Partnership name is required');
        MandatoryCheck(Elm + 2, 'Address of partnership is required');
        MandatoryCheck(Elm + 3, 'Country code of country of residence is required');
        MandatoryCheck(Elm + 4, 'Foreign affiliate is required');
        MandatoryCheck(Elm + 5, 'FA''s interest percentage in the partnership is required');

        Elm:= Elm + BoxesPerRow;
      end;

      // dormant foreign affiliate
      ArrayNo:= 10;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        MandatoryCheck(Elm + 2, 'Cost Amount is required');
        MandatoryCheck(Elm + 3, 'Gross receipts is required');
        MandatoryCheck(Elm + 4, 'Gross revenue is required');

        Elm:= Elm + BoxesPerRow;
      end;

      // NonControlledForeignAffiliate
      ArrayNo:= 11;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm + 1);

        if MandatoryCheck(Elm + 1, 'Name of FA is required') then
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, 'T1134', Elm + 1, 'E-T1134-Name of FA is already used in the list') else UniqueList.Add(Value);

        Elm:= Elm + BoxesPerRow;
      end;
    end;
  finally
    UniqueList.Free;
  end;
end;

procedure ValidateT1134S(RetNo: Integer; Fno, FInst: Integer);
var
  ArrayNo, BoxesPerRow, RowCount, I, J, Elm, Temp, LastElm, FormNo: Integer;
  FName, Value: string;
  UniqueList, GroupList: TStringList;

  function MandatoryCheck(AElmId: Integer; AError: string): boolean;
  begin
    Result:= true;

    if FetchElmFNo(RetNo, FNo, AElmId).Equals('') then
    begin
      SaveDiagnostic(RetNo, FName, AElmId, 'E-T1134S-' + AError);
      Result:= false;
    end;
  end;

  function MandatoryYesNoCheck(AElm1Id, AElm2Id: Integer; AError: string): boolean;
  begin
    Result:= true;

    if (FetchElmFNo(RetNo, FNo, AElm1Id) + FetchElmFNo(RetNo, FNo, AElm2Id)).Equals('') then
    begin
      SaveDiagnostic(RetNo, FName, AElm1Id, 'E-T1134S-' + AError);
      Result:= false;
    end;
  end;

begin
  FName:= 'T1134S#' + IntToStr(FInst);

  if Ret[RetNo].FrmHasData[FNo] then
  begin
    MandatoryCheck(3, 'Action is required');
    Value:= FetchElmFNo(RetNo, FNo, 35);

    for i:= 1 to 10 do
    begin
      if i = FInst then continue;

      FormNo:= GetFormNo('T1134S#' + IntToStr(i));

      if (FormNo > 0) and SameText(FetchElmFNo(RetNo, FormNo, 35), Value) then
      begin
        SaveDiagnostic(RetNo, FName, 35, 'E-T1134S-Foreing affiliate name is already used in T1134S#' + IntToStr(i));
        Break;
      end;
    end;

    UniqueList:= TStringList.Create;
    GroupList:= TStringList.Create;
    try
      PopulateT1134GroupList(RetNo, GroupList, false); //20230619 Igor

      if (Trim(FetchElmFNo(RetNo,FNo,3)) = '4') then MandatoryCheck(175, 'Reason for the deletion of this supplement must be selected');
      MandatoryCheck(35, 'Name of FA is required');
      MandatoryCheck(36, 'Address of Head Office is required');

      if (FetchElmFNo(RetNo, FNo, 40) + FetchElmFNo(RetNo, FNo, 41) + FetchElmFNo(RetNo, FNo, 42) + FetchElmFNo(RetNo, FNo, 43)).Equals('') then SaveDiagnostic(RetNo, FName, 40, 'E-T1134S-At least 1 valid NAICS code is required');
      if (FetchElmFNo(RetNo, FNo, 44) + FetchElmFNo(RetNo, FNo, 45) + FetchElmFNo(RetNo, FNo, 46) + FetchElmFNo(RetNo,FNo,47)).Equals('') then SaveDiagnostic(RetNo, FName, 44, 'E-T1134S-At least one country code is required for where the foreign affiliate either carries on a business or has other income earning activity');
      if (FetchElmFNo(RetNo, FNo, 5) + FetchElmFNo(RetNo, FNo, 6) + FetchElmFNo(RetNo, FNo, 7) + FetchElmFNo(RetNo, FNo, 8)).Equals('') then SaveDiagnostic(RetNo, FName, 5, 'E-T1134S-At least one Country code to which income tax was paid/payable is required');

      MandatoryCheck(48, 'The country code of residence for the foreign affiliate is required');
      MandatoryYesNoCheck(1, 2, 'First time the reporting entity has filed form T1134 for this foreign affiliate is required.');
      MandatoryYesNoCheck(49, 50, 'Is it a controlled foreign affiliate as defined in subsection 95(1) is required.');
      MandatoryYesNoCheck(9, 10, ' Does the FA have more than one tax year ended in the RE''s tax year?');

      // direct share holders
      ArrayNo:= 1;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        for J in [2, 3, 4, 5] do
        begin
          Value:= FetchElmFNo(RetNo, FNo, Elm + J);
          if not Value.IsEmpty then Break;
        end;
        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-At least one account number is required per row') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 6, 'Year Corporation became a foreign affiliate is required');
        MandatoryYesNoCheck(Elm + 7, Elm + 8, 'Did the corporation cease to be a foreign affiliate of the reporting entity in the year is required');
        MandatoryYesNoCheck(Elm + 9, Elm + 10, 'Was a subsection 93(1) or 93(1.2) election made or will such an election be made for the disposition of shares of the foreign affiliate?');

        if not FetchElmFNo(RetNo, FNo, Elm + 9).IsEmpty then
        begin
          MandatoryCheck(Elm + 11, 'Please provide the actual or estimate amount elected on');
          MandatoryCheck(Elm + 12, 'The currency code of the Elected amount on is required');
        end;

        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      // common shares
      ArrayNo:= 2;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, succ(Elm));

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Ownership % is required');
        MandatoryCheck(Elm + 3, 'ACB of Common Shares is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the ACB increase at any time during the tax year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the ACB decrease at any time during the tax year?');

        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      // preferred shares
      ArrayNo:= 3;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, succ(Elm));

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Ownership % is required');
        MandatoryCheck(Elm + 3, 'ACB of Preferred Shares is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the ACB increase at any time during the tax year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the ACB decrease at any time during the tax year?');

        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      // foreign affiliate other information
      ArrayNo:= 5;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, succ(Elm));

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 2, 'Percentage is required');
        MandatoryCheck(Elm + 3, 'Percentage is required');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Qualifying Interest in the FA at beginning of year?');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Qualifying Interest in the FA at the end of year?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Has the gross amount the RE owed to the FA been reported on a T106?');

        if not FetchElmFNo(RetNo, FNo, Elm + 9).IsEmpty then MandatoryCheck(Elm + 10, 'Gross amount of debt is required');

        MandatoryYesNoCheck(Elm + 11, Elm + 12, 'Has the gross amount the FA owed to the RE been reported on a T106?');

        if not FetchElmFNo(RetNo, FNo, Elm + 12).IsEmpty then MandatoryCheck(Elm + 13, 'Gross amount of debt is required');

        MandatoryYesNoCheck(Elm + 16, Elm + 17, 'Did the reporting entity have a "tracking interest" in this foreign affiliate as defined in subsection 95(8) at any time in the year?');
        MandatoryYesNoCheck(Elm + 18, Elm + 19, 'Was this foreign affiliate a controlled foreign affiliate of the reporting entity because of subsection 95(11)?');
        MandatoryYesNoCheck(Elm + 20, Elm + 21, 'Was this foreign affiliate a controlled foreign affiliate of the reporting entity because of subsection 95(12)?');
        MandatoryYesNoCheck(Elm + 22, Elm + 23, 'Is this reporting entity a party to a joint election under subsection 91(1.4) of the Act?');

        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      // foreign dumping rules
      ArrayNo:= 6;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, succ(Elm));

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, succ(Elm), 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did 212.3(2) apply in respect of an investment in the FA during the year?');
        MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of the 75% threshold');
        MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of 212.3(16)?');
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Did 212.3(2) not apply in respect of an investment in the FA during the year because of 212.3(18)?');
        MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Did any member of the related group file with the Minister the information required in subparagraph 212.3(7)(d)(i) in respect of the FA during the year?');
        MandatoryYesNoCheck(Elm + 12, Elm + 13, 'Was a dividend under 212.3(7)(d)(ii) deemed to have been paid in respect of an investment in the FA in the year?');
        MandatoryYesNoCheck(Elm + 14, Elm + 15, 'Was PUC of any class of shares of the FA increased under 212.3(9) in the year?');
        MandatoryYesNoCheck(Elm + 16, Elm + 17, 'Did the RE make an investment in the year in preferred shares of the FA that are described in subsection 212.3(19)?');

        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      MandatoryCheck(62, 'Taxation year (From) of the FA is required.');
      MandatoryCheck(63, 'Taxation year (To) of the FA is required.');
      MandatoryYesNoCheck(64, 65, 'Does the RE or any member of the related group hold at least 20% of the voting shares in this FA?');

      if not FetchElmFNo(RetNo,FNo, 64).IsEmpty then MandatoryYesNoCheck(11, 12, 'Are the unconsolidated FS (including the notes to the FS) available to you as a shareholder at the time this information return is filed?');
      if not FetchElmFNo(RetNo,FNo, 11).IsEmpty then  MandatoryYesNoCheck(13, 14, 'Have you attached the unconsolidated FS (including notes to the FS) of the FA with this information return?');

      MandatoryYesNoCheck(76, 77, 'Did the reporting entity receive a dividend on a share of the capital stock of the foreign affiliate any time within the taxation year?');

      // exempt surplus
      ArrayNo:= 7;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm + 2);

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of exempt surplus is required');
        Elm:= Elm + BoxesPerRow;
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
        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      // taxable surplus
      ArrayNo:= 9;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm + 2);

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of taxable surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5900(2)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(1.1)?');
        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      // preacquisition surplus
      ArrayNo:= 10;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm + 2);

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryCheck(Elm + 1, 'Amount of pre-acquisition surplus is required');
        MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Was any election made pursuant to Regulation 5901(2)(b)?');
        MandatoryYesNoCheck(Elm + 5, Elm + 6, 'Was any election made pursuant to Regulation 5901(2.1)?');
        MandatoryYesNoCheck(Elm + 7, Elm + 8, 'Was any qualifying return of capital (QROC) election made pursuant to Regulation 5911(6) as defined in subsection 90(3)?');
        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      if not FetchElmFNo(RetNo,FNo, 76).IsEmpty then
      begin
        MandatoryCheck(15, 'Amount of dividends in Cash or in Kind is required');
        MandatoryCheck(16, 'Currency Code is required');
        MandatoryCheck(17, 'Amount of dividend in stock');
        MandatoryCheck(18, 'Currency Code is required');
      end;

      MandatoryYesNoCheck(19, 20, 'Was the FA involved in ant transaction in respect of which 93(1.11)/(1.3) applied?');

      // upstream loan rules
      ArrayNo:= 11;
      BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm:= ArrayNo * 10000;
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

      for I:= 0 to pred(RowCount) do
      begin
        Value:= FetchElmFNo(RetNo, FNo, Elm + 1);

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is required') else
        if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is already in the list') else
        if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

        MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did a "specified debtor" (as defined in subsection 90(15)) in respect of the reporting entity or of any member of the Canadian related group owe an amount to the FA or a partnership of which the FA was a member?');
        if not FetchElmFNo(RetNo,FNo, Elm + 2).IsEmpty then
        begin
          MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did subsection 90(6) apply to that debt?');
          if not FetchElmFNo(RetNo,FNo, Elm + 5).IsEmpty then MandatoryYesNoCheck(Elm + 6, Elm + 7, 'If subsection 90(6) did not apply, was that because of subsection 90(8)?');
        end;
        MandatoryYesNoCheck(Elm + 8, Elm + 9, 'Was the FA an ''eligible bank affiliate'' that is owed an ''upstream deposit''?');
        if not FetchElmFNo(RetNo,FNo, Elm + 8).IsEmpty then MandatoryYesNoCheck(Elm + 10, Elm + 11, 'Was the FA deemed to make a loan to a reporting entity under subsection 90(8.1)');
        MandatoryYesNoCheck(Elm + 12, Elm + 13, 'Was the FA involved in an upstream loan arrangement in respect of which a deduction under subsection 90(9) was claimed?');
        MandatoryYesNoCheck(Elm + 14, Elm + 15, 'Was the FA involved in an upstream loan arrangement in respect of which an income inclusion under subsection 90(12) was required?');
        Elm:= Elm + BoxesPerRow;
      end;
      UniqueList.Clear;

      if not FetchElmFNo(RetNo,FNo, 49).IsEmpty then
      begin
        MandatoryYesNoCheck(21, 22, 'Was the reporting entity involved in a subsection 88(3) liquidation and dissolution in respect of the FA?');
        if not FetchElmFNo(RetNo,FNo, 21).IsEmpty then
          MandatoryYesNoCheck(23, 24, 'Was a subsection 88(3.1), 88(3.3), or 88(3.5) election made?');
        MandatoryYesNoCheck(25, 26, 'Was the reporting entity involved in a section 51 convertible property exchange in respect of the FA?');

        // transaction involved entity
        ArrayNo:= 12;
        BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm:= ArrayNo * 10000;
        RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

        for I:= 0 to pred(RowCount) do
        begin
          Value:= FetchElmFNo(RetNo, FNo, Elm + 2);

          if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is required') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is already in the list') else
          if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

          Elm:= Elm + BoxesPerRow;
        end;
        UniqueList.Clear;

        if not (FetchElmFNo(RetNo, FNo, 13).IsEmpty) then
        begin
          SaveDiagnostic(RetNo, FName, 13, 'W-You have selected “Yes” to the question “Unconsolidated Financial Statements attached?” on the T1134 Supplement ' +
          '(section 3). Do you want to submit the supporting documentation electronically? If yes, you must attach the ' + ' financial statements of the foreign affiliate file(s).');
        end;

        MandatoryYesNoCheck(27, 28, 'Part II, Section 3(B), Q2 YES or NO is required');

        // foreign affiliate transaction involved entity
        ArrayNo:= 13;
        BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm:= ArrayNo * 10000;
        RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

        for I:= 0 to pred(RowCount) do
        begin
          Value:= FetchElmFNo(RetNo, FNo, Elm + 2);

          if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is required') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is already in the list') else
          if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

          Elm:= Elm + BoxesPerRow;
        end;
        UniqueList.Clear;

        if not FetchElmFNo(RetNo, FNo, 27).IsEmpty then
        begin
          MandatoryYesNoCheck(29, 30, 'Was subsection 91(1.1) applicable with respect to the foreign affiliate?');
          MandatoryYesNoCheck(31, 32, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(c) was applicable?');
          MandatoryYesNoCheck(33, 34, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(d) was applicable?');
          MandatoryYesNoCheck(37, 38, 'Was the foreign affiliate involved in any transaction in respect of which paragraph 95(2)(e) was applicable?');
          MandatoryYesNoCheck(39, 51, 'Was an election filed in respect of the relevant cost base (as defined in subsection 95(4)) of any property of the foreign affiliate pursuant to Regulation 5911(5)?');
        end;

        // changes in entity and surplus entitlement percentage
        ArrayNo:= 14;
        BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm:= ArrayNo * 10000;
        RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

        for I:= 0 to pred(RowCount) do
        begin
          Value:= FetchElmFNo(RetNo, FNo, Elm + 1);

          if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is required') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is already in the list') else
          if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

          MandatoryYesNoCheck(Elm + 2, Elm + 3, 'Did the reporting entity''s surplus entitlement percentage in this foreign affiliate change?');
          MandatoryYesNoCheck(Elm + 4, Elm + 5, 'Did the equity percentage of a foreign affiliate of the reporting entity in respect of this foreign affiliate increase or decrease at any time?');
          MandatoryYesNoCheck(Elm + 6, Elm + 7, 'Did the equity percentage of this foreign affiliate in respect of another foreign affiliate of the reporting entity increase or decrease at any time?');
          Elm:= Elm + BoxesPerRow;
        end;
        UniqueList.Clear;

        MandatoryYesNoCheck(52, 53, 'Did the FA dispose of a share in another FA that was excluded property or an interest in a partnership that was excluded property?');
        MandatoryYesNoCheck(54, 55, 'Did the FA dispose of capital property that was excluded property?');
        MandatoryYesNoCheck(56, 57, 'Was the reporting entity or any foreign affiliate of the reporting entity involved in?');

        // other transaction entity list
        ArrayNo:= 15;
        BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm:= ArrayNo * 10000;
        RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

        for I:= 0 to pred(RowCount) do
        begin
          Value:= FetchElmFNo(RetNo, FNo, Elm + 2);

          if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is required') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is already in the list') else
          if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo, FName, Elm + 2, 'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

          Elm:= Elm + BoxesPerRow;
        end;
        UniqueList.Clear;

        Value:= '';
        for J in [60, 61, 66, 67, 68, 69] do Value:= Value + FetchElmFNo(RetNo, FNo, J);

        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, 60, 'E-T1134S-Number of Employees is required');

        MandatoryYesNoCheck(70, 71, 'Did the operator rely on the services?');
        MandatoryYesNoCheck(72, 73, 'Indicate if you are providing a breakdown of each income category between arm''s length and non-arm''s length sources');

        if not (FetchElmFNo(RetNo,FNo,74) + FetchElmFNo(RetNo,FNo,75) + FetchElmFNo(RetNo,FNo,78)).IsEmpty then MandatoryCheck(79, 'Gross Revenue Currency Code is empty');
        if not (FetchElmFNo(RetNo,FNo,80) + FetchElmFNo(RetNo,FNo,81) + FetchElmFNo(RetNo,FNo,82)).IsEmpty then MandatoryCheck(83, 'Interest Currency Code is required');
        if not (FetchElmFNo(RetNo,FNo,84) + FetchElmFNo(RetNo,FNo,85) + FetchElmFNo(RetNo,FNo,86)).IsEmpty then MandatoryCheck(87, 'Dividends Currency Code is required');
        if not (FetchElmFNo(RetNo,FNo,88) + FetchElmFNo(RetNo,FNo,89) + FetchElmFNo(RetNo,FNo,90)).IsEmpty then MandatoryCheck(91, 'Royalties Currency Code is required');
        if not (FetchElmFNo(RetNo,FNo,92) + FetchElmFNo(RetNo,FNo,93) + FetchElmFNo(RetNo,FNo,94)).IsEmpty then MandatoryCheck(95, 'Rental & Leasing Currency Code is required');
        if not (FetchElmFNo(RetNo,FNo,96) + FetchElmFNo(RetNo,FNo,97) + FetchElmFNo(RetNo,FNo,98)).IsEmpty then MandatoryCheck(99, 'Loans or Lending Currency Code is required');
        if not (FetchElmFNo(RetNo,FNo,100) + FetchElmFNo(RetNo,FNo,101) + FetchElmFNo(RetNo,FNo,102)).IsEmpty then MandatoryCheck(103, 'Insurance or reinsurance Currency Code is required');
        if not (FetchElmFNo(RetNo,FNo,104) + FetchElmFNo(RetNo,FNo,105) + FetchElmFNo(RetNo,FNo,106)).IsEmpty then MandatoryCheck(107, 'Factoring of trade accounts receivable Currency Code is required');
        if not (FetchElmFNo(RetNo,FNo,108) + FetchElmFNo(RetNo,FNo,109) + FetchElmFNo(RetNo,FNo,110)).IsEmpty then MandatoryCheck(111, 'Disposition of Investment Property Currency Code is required');

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
        ArrayNo:= 16;
        BoxesPerRow:= RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
        Elm:= ArrayNo * 10000;
        RowCount:= DynamicRowCount(RetNo, FNo, ArrayNo);

        for I:= 0 to pred(RowCount) do
        begin
          Value:= FetchElmFNo(RetNo, FNo, Elm + 1);

          if Value.IsEmpty then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is required') else
          if (UniqueList.IndexOf(Value) > -1) then SaveDiagnostic(RetNo, FName, Elm + 1, 'E-T1134S-Account number is already in the list') else
          if (GroupList.IndexOf(Value) = -1) then SaveDiagnostic(RetNo,FName,Elm + 1,'E-T1134S-Account number is incorrect') else UniqueList.Add(Value);

          MandatoryCheck(Elm + 2, 'Reporting entity (-ies) total participating percentage is required');
          MandatoryYesNoCheck(Elm + 3, Elm + 4, 'Did the participating percentage of the reporting entity or member of the related Canadian group in respect of this FA increase or decrease at any time?');

          Elm:= Elm + BoxesPerRow;
        end;
        UniqueList.Clear;

        MandatoryYesNoCheck(147, 148, 'Part III, Section 4, Q1 YES or NO is required');
        if not FetchElmFNo(RetNo, FNo, 147).IsEmpty then
        begin
          MandatoryYesNoCheck(149, 150, 'Because of subparagraph 95(2)(a)(i) to 95(2)(a)(vi) of the Act?');
          MandatoryYesNoCheck(151, 152, 'Because of type of business carried on… 95(1) of the Act?');
          MandatoryYesNoCheck(153, 154, 'Because of subparagraph 95(2)(I)(i) to (iii) of the Act?');
        end;
        MandatoryYesNoCheck(155, 156, 'Part III, Section 4, Q2 YES or NO is required');
        if not FetchElmFNo(RetNo, FNo, 155).IsEmpty then
        begin
          MandatoryYesNoCheck(157, 158, 'Because of 90% test in paragraphs 95(2)(a.1) through (a.4) of the Act?');
          MandatoryYesNoCheck(159, 160, 'Because of subsection 95(2.3) of the Act?');
          MandatoryYesNoCheck(161, 162, 'Because of subsection 95(2.4) of the Act?');
          MandatoryYesNoCheck(163, 164, 'Because of subsection 95(3)?');
          MandatoryYesNoCheck(165, 166, 'Because of subsection 95(3.01)?');
        end;
      end;

      MandatoryYesNoCheck(288, 289, 'Is any information requested in this return not available?');
      if not FetchElmFNo(RetNo, FNo, 288).IsEmpty then
      begin
        Value:= FetchElmFNo(RetNo, FNo, 290) + FetchElmFNo(RetNo, FNo, 291) + FetchElmFNo(RetNo, FNo, 292) + FetchElmFNo(RetNo, FNo, 293);
        if Value.IsEmpty then SaveDiagnostic(RetNo, FName, 290, 'E-T1134S- Please specify information not available.');
      end;
    finally
      UniqueList.Free;
    end;
  End;
end;
//20260115 Igor <<<

//20260817 Alex >>>
procedure ValidateT106(RetNo: Integer);
var
  s: string;
  i, T106FNo: Integer;
begin
  //20171126
  T106FNo:=GetFormNo('T106');
  if UpperCase(FetchElmFNo(RetNo,T106FNo,61))<>'Y' then exit;

  //Section 1- Reporting Person/Partnership Identification ----------------------
  if FetchElmFNo(RetNo, T106FNo, 14) ='' then SaveDiagnostic(RetNo, 'T106', 14, 'E-T106-Summary Information Section 1, Trust Name required');
  if FetchElmFNo(RetNo, T106FNo, 15) ='' then SaveDiagnostic(RetNo, 'T106', 15, 'E-T106-Summary Information Section 1, Trust Account Number required');

  if FetchElmFNo(RetNo,T106FNo,23)=' 'then  SaveDiagnostic(RetNo,'T106',23,'E-T106-Street Address is required');
  if FetchElmFNo(RetNo,T106FNo,24)='' then  SaveDiagnostic(RetNo,'T106',24,'E-T106-Summary - City is required”');
  if FetchElmFNo(RetNo,T106FNo,25)='' then  SaveDiagnostic(RetNo,'T106',25,'E-T106-Summary - Province or territory is required');
  if FetchElmFNo(RetNo,T106FNo,26)='' then  SaveDiagnostic(RetNo,'T106',26,'E-T106-Summary - Postal or Zip code is required');
  if FetchElmFNo(RetNo,T106FNo,2) ='' then  SaveDiagnostic(RetNo,'T106',2,'E-Summary - Country is required');  //20230110 CON

  //Section 2 – Summary Information ---------------------------------------------
  //'Summary – Section 2, Question 1: Taxation Year “To” and "From" Date required'

  s:= FetchElmFNo(RetNo,T106FNo,29) + FetchElmFNo(RetNo,T106FNo,30);
  if s.IsEmpty() then SaveDiagnostic(RetNo,'T106',39,'E-T106-Summary – Section 2, Question 2: Yes or No is required for “Is this the first time you have filed a T106 form?');
  if (FetchElmFNo(RetNo, T106FNo, 30) > '') and (FetchElmFNo(RetNo, T106FNo, 31) = '') then SaveDiagnostic(RetNo,'T106',31,'E-T106-Summary – Section 2, Question 2: Date of last tax year/fiscal period end reporting person/partnership filed a T106 is required');
  if Vl(FetchElmFNo(RetNo,T106FNo,32))=0 then SaveDiagnostic(RetNo,'T106',32,'E-T106-Summary – Section 2: T106 slips need to be prepared');

  s:= FetchElmFNo(RetNo,T106FNo,35) + FetchElmFNo(RetNo,T106FNo,36) + FetchElmFNo(RetNo,T106FNo,37) + FetchElmFNo(RetNo,T106FNo,38);
  if s.IsEmpty() then SaveDiagnostic(RetNo,'T106',35,'E-T106-Summary – Section 2: At least 1 NAICS code is required');

  s:= FetchElmFNo(RetNo,T106FNo,39) + FetchElmFNo(RetNo,T106FNo,40);
  if s.IsEmpty() then SaveDiagnostic(RetNo,'T106',39,'E-T106-Summary – Section 2, Question 7: Yes or No is required');

  //'Summary – Section 2, Question 8: Yes or No is required'
  //'Summary – Section 2, Question 9.1: Yes or No is required'
  if (FetchElmFNo(RetNo,T106FNo,66)>'') and (FetchElmFNo(RetNo,T106FNo,67)='') then //jz 20241206 add and condition //If FetchElmFNo(RetNo,T106FNo,35)='' then
    SaveDiagnostic(RetNo,'T106',67,'E-T106-Summary – Section 2, Question 9.2: Country Code is required');

  //'Summary – Section 2, Question 10.1: Name of the MNE group'
  if (FetchElmFNo(RetNo,T106FNo,68)>'') and (FetchElmFNo(RetNo,T106FNo,73)='')then //jz 20241206 add and condition  //If FetchElmFNo(RetNo,T106FNo,35)='' then
    SaveDiagnostic(RetNo,'T106',73,'E-T106-Summary – Section 2, Question 10.2: Name of the MNE group is required');

  //'Summary – Section 2, Question 10.3: Yes or No is required'
  if (FetchElmFNo(RetNo,T106FNo,70)>'') and (FetchElmFNo(RetNo,T106FNo,72)='') then //jz 20241206 add and condition  //If FetchElmFNo(RetNo,T106FNo,35)='' then
    SaveDiagnostic(RetNo,'T106',72,'E-T106-Summary – Section 2, Question 10.4: Jurisdiction where the CbCR is filed is required');

  //If FetchElmFNo(RetNo,T106FNo,X) ='' then  SaveDiagnostic(RetNo,'T106',X,'
  //'Summary – Section 3, Question 1: Yes or No is required'
  //'Summary – Section 3, Question 2: Yes or No is required'

  if FetchElmFNo(RetNo,T106FNo,45)>'' then
  begin
    if FetchElmFNo(RetNo,T106FNo,47)+FetchElmFNo(RetNo,T106FNo,48)='' then
    begin
      SaveDiagnostic(RetNo,'T106',47,'E-T106 - At least one account number is required');
      SaveDiagnostic(RetNo,'T106',48,'E-T106 - At least one account number is required');
    end;
  end;

  s:= FetchElmFNo(RetNo,T106FNo,47) + FetchElmFNo(RetNo,T106FNo,48)+FetchElmFNo(RetNo,T106FNo,74) + FetchElmFNo(RetNo,T106FNo,75)+FetchElmFNo(RetNo,T106FNo,76) + FetchElmFNo(RetNo,T106FNo,77);
  if (FetchElmFNo(RetNo,T106FNo,45)>'') and (s='') then
    SaveDiagnostic(RetNo,'T106',47,'E-T106-Enter primary account(s)');

  for i:=53 to 59 do
  begin
   if FetchElmFNo(RetNo,T106FNo,i)='' then
     SaveDiagnostic(RetNo,'T106',i,'E-T106-Full Certification data are required');
  end;
end;

procedure ValidateT106SL(RetNo:Integer);
var
  i, SlipFNo: Integer;
  SlFName: string;
begin
  if UpperCase(FetchElm(RetNo,'T106',61))<>'Y' then Exit; //do not validate

  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];

    if Frec.FormName = 'T106SL' then
    begin
      if Ret[RetNo].FrmHasData[FRec.FormNo] = True then
      begin
        SlFName:=FRec.FormName+Frec.FormInst;
        SlipFNo:=FRec.FormNo;
        //SlipFormInst:=FRec.FormInst;
        if FetchElmFNo(RetNo,SlipFNo,10)>'' then ValidateAT106Slip(RetNo,SlFName,SlipFNo);
      end;
    end;
  end;
end;

procedure ValidateAT106SLip(RetNo: Integer; SlFName: string; SlipFNo: Integer);
var
  i: Integer;
  s: string;
begin
  if FetchElmFNo(RetNo,SlipFNo,10)>'' then   //name entered
  begin
    if FetchElmFNo(RetNo,SlipFNo,110)='' then //action
    begin
      SaveDiagnostic(RetNo,SlFName,110,'E-T106 Slip - Enter action code');
    end;

    if (LeftStr(FetchElmFNo(RetNo,SlipFNo,110),1)='4') {delete slip} and (FetchElmFNo(RetNo,SlipFNo,175)='') then  //delete reason
      SaveDiagnostic(RetNo,SlFName,175,'E-T106 Slip - Enter reason for deleting Country code'); //20171201

    if FetchElmFNo(RetNo,SlipFNo,10)='' then
      SaveDiagnostic(RetNo,SlFName,10,'E-T106 Slip - Enter Non resident Name');

    if FetchElmFNo(RetNo,SlipFNo,11)='' then
      SaveDiagnostic(RetNo,SlFName,11,'E-T106 Slip - Residence address is required');

    if FetchElmFNo(RetNo,SlipFNo,13)='' then
      SaveDiagnostic(RetNo,SlFName,13,'E-T106 Slip - Country Code is required');

    s := FetchElmFNo(RetNo,SlipFNo,185)+FetchElmFNo(RetNo,SlipFNo,186)+FetchElmFNo(RetNo,SlipFNo,187)+FetchElmFNo(RetNo,SlipFNo,188)+FetchElmFNo(RetNo,SlipFNo,189);
    if s='' then SaveDiagnostic(RetNo,SlFName,185,'E-T106 Slip - “Type of non-resident under foreign law governing the non-resident” is required.');

    s := FetchElmFNo(RetNo,SlipFNo,14)+FetchElmFNo(RetNo,SlipFNo,15)+FetchElmFNo(RetNo,SlipFNo,16)+FetchElmFNo(RetNo,SlipFNo,190);
    if s='' then SaveDiagnostic(RetNo,SlFName,14,'E-T106 Slip - Type of Relationship is required');

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

    if FetchElmFNo(RetNo,SlipFNo,19)+FetchElmFNo(RetNo,SlipFNo,20)+FetchElmFNo(RetNo,SlipFNo,21)+FetchElmFNo(RetNo,SlipFNo,22)='' then
      SaveDiagnostic(RetNo,SlFName,19,'E-T106 Slip - At least 1 valid NAICS code is required');

    if FetchElmFNo(RetNo,SlipFNo,24)+FetchElmFNo(RetNo,SlipFNo,25)+FetchElmFNo(RetNo,SlipFNo,26)+FetchElmFNo(RetNo,SlipFNo,27)='' then
      SaveDiagnostic(RetNo,SlFName,24,'E-T106 Slip - At least 1 Country Code is required');

    s := FetchElmFNo(RetNo,SlipFNo,28)+FetchElmFNo(RetNo,SlipFNo,29);
    if s='' then
      SaveDiagnostic(RetNo,SlFName,28,'E-T106 Slip - Please select Yes or No');

    s := FetchElmFNo(RetNo,SlipFNo,30)+FetchElmFNo(RetNo,SlipFNo,31);
    if s='' then
      SaveDiagnostic(RetNo,SlFName,30,'E-T106 Slip - Please select Yes or No');
  end;
end;
//20260817 Alex <<<

end.
