unit T4T5_2026cnterr;

interface
procedure CountDiagnostics(RetNo: integer);
Procedure ValidateEmpl(RetNo,FNo:Integer);
Procedure ValidateT4(RetNo:Integer; FName:String; FNo:Integer);
Procedure ValidateT4A(RetNo:Integer; FName:String; FNo:Integer);
Procedure ValidateT5(RetNo:Integer; FName:String; FNo:Integer);

//20180101
Function T4HasAmounts(RetNo:Integer;FName:String;FNo:Integer):Boolean;
Function T4AHasAmounts(RetNo:Integer;FName:String;FNo:Integer):Boolean;
Function T5HasAmounts(RetNo:Integer;FName:String;FNo:Integer):Boolean;

implementation
{
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,StdCtrls,Dialogs,
  T4T5_2026TrimStr,T4T5_2026Declare,T4T5_2026Common,T4T5_2026Common2;
}
uses
  SysUtils,
  vtCommon,
  T4T5_2026, T4T5_2026TrimStr,T4T5_2026Declare,T4T5_2026Common,T4T5_2026Common2,
  vtTrimStr, vtShared;


//Function CountDiagnostics(RetNo: integer):Integer;
procedure CountDiagnostics(RetNo: integer);
Const MaxSlips=500;
Var i,k,FNo:integer; FrmName:string;
ErrMsg : string;x:real;s:String;
FInst:String;
begin

  If RetNo=0 then exit;
  If RetInMem < 1 then exit;
  Ret[RetNo].AuditList.Clear;

  FNo:=GetFormNo('EMPL');
  ValidateEmpl(RetNo,FNo);

  //20210203
  FrmName:='T4SUM';
  FNo:=GetFormNo(FrmName);
  if (FetchElmFNo(RetNo,Fno,34)>'')
  and (FetchElmFNo(RetNo,Fno,34)<FormatDateTime('yyyy-mm-dd',Now))
  then SaveDiagnostic(RetNo,FrmName,34,'W-T4 Summary signed prior than today. Please check');

  FrmName:='T4ASUM';
  FNo:=GetFormNo(FrmName);
  if (FetchElmFNo(RetNo,Fno,34)>'')
  and (FetchElmFNo(RetNo,Fno,34)<FormatDateTime('yyyy-mm-dd',Now))
  then  SaveDiagnostic(RetNo,FrmName,34,'W-T4A Summary signed prior than today. Please check');


  FrmName:='T5SUM';  //20200208
  FNo:=GetFormNo(FrmName);
  if (FetchElmFNo(RetNo,Fno,43)>'')
  and (FetchElmFNo(RetNo,Fno,43)<FormatDateTime('yyyy-mm-dd',Now))
  then  SaveDiagnostic(RetNo,FrmName,43,'W-T5 Summary signed prior than today. Please check');



  //20170910
  //validate slips How many?
//  k:=CountSlips(RetNo,'T4');    //k causes problems???  does not do it?
  for i:=1 to MaxSlips do  //20180223 500
  Begin
   Finst:='#'+AllTrim(IntToStr(i));  //20190221
   FrmName:='T4'+FInst;
   FNo:=GetFormNo(FrmName);
   if FNo>0 then ValidateT4(RetNo,FrmName,FNo);
  end;

 // k:=CountSlips(RetNo,'T4A'); //20180114
  for i:=1 to MaxSlips do //20180223
  Begin
   Finst:='#'+AllTrim(IntToStr(i));  //20190221
   FrmName:='T4A'+FInst;
   FNo:=GetFormNo(FrmName);
   if FNo>0 then ValidateT4A(RetNo,FrmName,FNo);
  end;

 // k:=CountSlips(RetNo,'T5'); //20180114
  for i:=1 to MaxSlips do  //20180223
  Begin
   Finst:='#'+Alltrim(IntToStr(i));
   FrmName:='T5'+FInst;
   FNo:=GetFormNo(FrmName);
   if FNo>0 then ValidateT5(RetNo,FrmName,FNo);
  end;


    {FldTapes/FLDMEM}
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec.FormName = 'FLDTAPE' then
   begin
     FrmName:=Frec.FormName+FRec.FormInst;
     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
     begin
       //20170728 Igor>>>
       If FetchElmFNo(RetNo,Frec.Formno, 123)='' then
         SaveDiagnostic(RetNo,FrmName,123,'W-Tape'+'-'+FrmName+ 'has amounts but is set to NO posting');

       SaveDiagnostic(RetNo,FrmName,126,'D-Tape'+' '+PaddR(FetchElm(RetNo,FrmName,121),12)+' '+FetchElm(RetNo,FrmName,122));
     end;
  end;
 end;
End;

//20170903
Procedure ValidateEmpl(RetNo,FNo:Integer);
Var i:Integer;s:String;
Begin
  if Ret[RetNo].FrmHasData[Fno] then
  Begin
   for i:=1 to 13 do
   begin
      if FetchElm(RetNo,FNo,i) = '' then
       SaveDiagnostic(RetNo,'EMPL',i,'E-EMPL-Enter ALL highlighted Employer Information');
   End;

   //20170902
   for i:=7 to 15 do
   begin
      if FetchElm(RetNo,FNo,i) = '' then
       SaveDiagnostic(RetNo,'EMPL',i,'E-EMPL-Enter all the highlighted Employer Information');
   End;

   if (FetchElm(RetNo,FNo,22)='')
   And (FetchElm(RetNo,FNo,24)='')
   And (FetchElm(RetNo,FNo,31)='')
   then
     SaveDiagnostic(RetNo,'EMPL',22,'E-EMPL-One of the Accounts (T4, T4A, T5) must be entered');

   (*
   if Length(FetchElm(RetNo,FNo,22)) > 0 then
   Begin
    if Length(FetchElm(RetNo,FNo,22))<> 15 then
      SaveDiagnostic(RetNo,'EMPL',22,'E-EMPL-The T4 Account must be 15 characters');
   end;
   *)

  //20180109
  if Length(FetchElm(RetNo,FNo,22)) > 0 then
   Begin
    if Length(FetchElm(RetNo,FNo,22))<> 15 then
      SaveDiagnostic(RetNo,'EMPL',22,'E-EMPL-The T4 Account must be 15 characters');
   end;

  if Length(FetchElm(RetNo,FNo,24)) > 0 then
   Begin
    if Length(FetchElm(RetNo,FNo,24))<> 15 then
      SaveDiagnostic(RetNo,'EMPL',24,'E-EMPL-The T4A Account must be 15 characters');
   end;

   if Length(FetchElm(RetNo,FNo,31)) > 0 then
   Begin
    if Length(FetchElm(RetNo,FNo,31))<> 15 then
      SaveDiagnostic(RetNo,'EMPL',31,'E-EMPL-The T5 Account must be 15 characters');
   end;


   If ValidPostal(MyStrToInt(FetchElmFNo(RetNo,FNo,6)),FetchElmFNo(RetNo,FNo,5))= false then
   SaveDiagnostic(RetNo,'EMPL',5,'E-EMPL-Postal code is invalid');


  If Length(FetchElmFNo(RetNo,FNo,9)) <> 3 then
   SaveDiagnostic(RetNo,'EMPL',9,'E-EMPL-A three digit Telephone Area is required');

  If (Length(FetchElmFNo(RetNo,FNo,10))<> 8)
  Or (MidStr(FetchElmFNo(RetNo,FNo,10),4,1)<>'-') then
  begin
   SaveDiagnostic(RetNo,'EMPL',10,'E-EMPL-Phone format must be 999-9999');
  end;


  If Length(FetchElmFNo(RetNo,FNo,14)) <> 3 then
   SaveDiagnostic(RetNo,'EMPL',14,'E-EMPL-A three digit Telephone Area is required');

  If (Length(FetchElmFNo(RetNo,FNo,15))<> 8)
  Or (MidStr(FetchElmFNo(RetNo,FNo,15),4,1)<>'-') then
  begin
   SaveDiagnostic(RetNo,'EMPL',15,'E-EMPL-Phone Format must be 999-9999');
  end;

  If FetchElmFNo(RetNo,FNo,6) = '' then
   SaveDiagnostic(RetNo,'EMPL',6,'E-EMPL-Country missing i.e. CAN for Canada');

  If FetchElmFNo(RetNo,FNo,18)=''then
  begin
   If FetchElmFNo(RetNo,FNo,18)='' then
      SaveDiagnostic(RetNo,'EMPL',18,'E-EMPL-Enter Tax Centre');
  end;

  if FetchElm(RetNo,FNo,22)>'' then
  Begin
  If ValidateBusNo(FetchElmFNo(RetNo,FNo,22)) = false then
   SaveDiagnostic(RetNo,'EMPL',22,'E-EMPL-T4 Account Number (Check Number and use Format 999999999RP9999');
  End;

  if FetchElm(RetNo,FNo,24)>'' then
  Begin
   If ValidateT5Filer(FetchElmFNo(RetNo,FNo,24)) = false then
    SaveDiagnostic(RetNo,'EMPL',24,'E-T4A Account Number must be 15 characters');
  end;

  if FetchElm(RetNo,FNo,31)>'' then
  Begin
   If ValidateT5Filer(FetchElmFNo(RetNo,FNo,31)) = false then
    SaveDiagnostic(RetNo,'EMPL',31,'E-T5 Account Number must be 15 characters');
  end;

  If ValidSin(FetchElmFNo(RetNo,FNo,29)) = False then
   SaveDiagnostic(RetNo,'EMPL',29,'E-EMPL-Proprietor SIN is invalid');

  If ValidSin(FetchElmFNo(RetNo,FNo,30)) = False then
   SaveDiagnostic(RetNo,'EMPL',30,'E-EMPL-Proprietor SIN is invalid');
  end; //empl
end;

//20170903
Procedure ValidateT4(RetNo:Integer; FName:String; FNo:Integer);
Var i:Integer;s:String;EmplCode:String;Sin:String;
SlipName:String;
Begin
  with Ret[RetNo].Frm[FNo] do
  begin
  // if FetchElm(RetNo,'EMPL',1) = '' then SaveDiagnostic(RetNo,FName,1,'E-T4-Please complete the Employer information first');

   //20171228
   Sin:=FetchElmFNo(RetNo,FNo,7);
   SlipName:=UpperCase(FetchElmFNo(RetNo,FNo,11)+' '+FetchElmFNo(RetNo,FNo,12))+' '+Fname;  //20190223
   if (SIN='') and (FetchElmFNo(RetNo,FNo,11)='') then Exit;  //20180109

   If (Sin>'') and (ValidSin(Sin) = False) then SaveDiagnostic(RetNo,FName,7,'E-T4-SIN is invalid, OR enter 9 zeros if unknown -'+SlipName);

   //20211218
   If (Sin='') and (Vl(FetchElmFNo(RetNo,FNo,18))>0) then SaveDiagnostic(RetNo,FName,7,'E-T4-SIN is required OR enter 9 zeros if unknown -'+SlipName);

   If Sin>'' then
   Begin
    If Sin='000000000'  then  //20190226
      SaveDiagnostic(RetNo,FName,7,'W-T4-Failure to supply a valid SIN may result in CRA penalties. See the Guide  -'+SlipName)
    Else
     If CheckSINforDuplicates(RetNo, FNo, 'T4', Sin)=False then
        SaveDiagnostic(RetNo,FName,7,'W-T4-SIN already exists for this employer  -'+SlipName);   //20200113
      // SaveDiagnostic(RetNo,FName,7,'E-T4-SIN already exists for this employer  -'+SlipName);
   End;

   if (Sin>'') or (FetchElmFNo(RetNo,FNo,11)>'') then //sin or name
   Begin
    if FetchElmFNo(RetNo,FNo,5)='' then
     SaveDiagnostic(RetNo,FName,5,'E-T4-You must enter the T4 Account Number on the EMPL form   -'+SlipName);

    if T4HasAmounts(RetNo,FName,FNo)=False then
    Begin
     SaveDiagnostic(RetNo,FName,18,'E-T4-The slip does not have any amounts. If too many, click + then click the scrollbar   -'+SlipName);
    End;
   End;
   if Ret[RetNo].FrmHasData[Fno] = False then Exit;  //20171223

   If FetchElmFNo(RetNo,FNo,2)='2023' then  //20231231
   Begin
    //if FetchElmFNo(RetNo,FNo,49)>'' then SaveDiagnostic(RetNo,FName,49,'W-T4-Do not complete box 45 in 2023 - Dental by employer unless you are paper filing   -'+SlipName);
     if FetchElmFNo(RetNo,FNo,47)>'' then SaveDiagnostic(RetNo,FName,47,'E-T4-Do not complete box 16A for the T2023 tax year  -'+SlipName);
    if FetchElmFNo(RetNo,FNo,48)>'' then SaveDiagnostic(RetNo,FName,48,'E-T4-Do not complete box 17A for the T2023 tax year  -'+SlipName);
   End;

  If FetchElmFNo(RetNo,FNo,11)='' then //If FieldByName('LASTNAME').AsString = '' then
   SaveDiagnostic(RetNo,FName,11,'E-T4-Last Name is required   -'+SlipName);

  if Vl(FetchElmFNo(RetNo,FNo,101))=0 then //20171223
   SaveDiagnostic(RetNo,FName,101,'E-T4-Pensionable periods cannot be zero   -'+SlipName);

  if Vl(FetchElmFNo(RetNo,FNo,101))>Vl(FetchElmFNo(RetNo,FNo,102)) then
     SaveDiagnostic(RetNo,FName,101,'E-T4-Pensionable periods cannot exceed Total periods in year   -'+SlipName);

  EmplCode:=FetchElmFNo(RetNo,FNo,10);

  if EmplCode='' then
   SaveDiagnostic(RetNo,FName,10,'E-T4-Employment code is required   -'+SlipName);

  if Tv[18]<>0 then
  Begin
   if (EmplCode='11')
   or (EmplCode='12')
   or (EmplCode='13')
   or (EmplCode='17') then
     SaveDiagnostic(RetNo,FName,18,'E-T4-Box 14 must be zero (blank) if Employment code is 11,12,13 or 17   -'+SlipName);
  End;

  //20171223
  If Vl(FetchElmFNo(RetNo,FNo,105)) <> Vl(FetchElm(RetNo,FNo,106)) then
  Begin
   SaveDiagnostic(RetNo,FName,105,'W-T4 CPP entered on Box 16/16A differs from calculated amount, by $'+FormatFloat('#######.##',Tv[107])+' -'+SlipName);//20250122
   // 20250122 SaveDiagnostic(RetNo,FName,19,'W-T4 CPP entered on Box 16 differs from calculated amount, by $'+FormatFloat('#######.##',Tv[107])+'  -'+SlipName);
  End;

  If Vl(FetchElmFNo(RetNo,FNo,108)) <> Vl(FetchElm(RetNo,FNo,109)) then
  Begin
   SaveDiagnostic(RetNo,FName,108,'W-T4 EI entered on Box 18 differs from calculated amount, by $'+FormatFloat('#######.##',Tv[110])+'  -'+SlipName);
   SaveDiagnostic(RetNo,FName,21,'W-T4 EI entered on Box 18 differs from calculated amount, by $'+FormatFloat('#######.##',Tv[110])+'  -'+SlipName);
  End;
  //-----------------

  If FetchElmFNo(RetNo,FNo,14)='' then
   SaveDiagnostic(RetNo,FName,14,'E-T4-Street is required   -'+SlipName);

  If FetchElmFNo(RetNo,FNo,15)='' then
   SaveDiagnostic(RetNo,FName,15,'E-T4-City is required   -'+SlipName);

  If Length(FetchElmFNo(RetNo,FNo,17))<>2 then
   SaveDiagnostic(RetNo,FName,17,'E-T4-Valid Province Code is required   -'+SlipName);

  If ValidPostal(MyStrToInt(FetchElmFNo(RetNo,FNo,43)),FetchElmFNo(RetNo,FNo,16))= false then
   SaveDiagnostic(RetNo,FName,16,'W-T4-Postal code is invalid   -'+SlipName);  //20200302


  If (Vl(FetchElmFNo(RetNo,FNo,25)) > MaxEIEarnings) then
     SaveDiagnostic(RetNo,FName,25,'E-T4-EI Earnings exceed Maximum ('+
    FormatFloat('##,###,###.00',MaxEIEarnings) +'). Please correct   -'+SlipName);

   If (Vl(FetchElmFNo(RetNo,FNo,26)) > CPP2MaxCPPEarnings) then
    SaveDiagnostic(RetNo,FName,26,'E-T4-CPP Earnings exceed Maximum ('+
     FormatFloat('##,###,###.00',CPP2MaxCppEarnings) +'). Please correct   -'+SlipName); //20241221
  end;
End;

Procedure ValidateT4A(RetNo:Integer; FName:String; FNo:Integer);
Var i:Integer;s:String;EmplCode:String;SIN:String;
SlipName:String;
Begin
 // if FetchElm(RetNo,'EMPL',2) = '' then SaveDiagnostic(RetNo,FName,2,'E-T4A-Please complete the Payer information first');

  //20171228
  Sin:=FetchElmFNo(RetNo,FNo,4);
  SlipName:=UpperCase(FetchElmFNo(RetNo,FNo,6)+' '+FetchElmFNo(RetNo,FNo,7))+' '+Fname;  //20190221
  if (Sin='') and (FetchElmFNo(RetNo,FNo,6)='')  then exit;  //20180108


  If (Sin>'') and (ValidSin(Sin) = False) then  SaveDiagnostic(RetNo,FName,4,'E-T4A-SIN is invalid, OR enter 9 zeros if unknown   -'+SlipName);

  If Sin>'' then
   Begin
    If Sin='000000000'  then  //20190226
      SaveDiagnostic(RetNo,FName,4,'W-T4A-Failure to supply a valid SIN may result in CRA penalties. See the Guide  -'+SlipName)
    Else
     If CheckSINforDuplicates(RetNo, FNo, 'T4A', Sin)=False then
       SaveDiagnostic(RetNo,FName,4,'W-T4A-SIN already exists for this employer  -'+SlipName);  //20200210
   End;

  {
  //20190226
  If (Sin>'') and (SIN<>'000000000') and (not CheckSINforDuplicates(RetNo, FNo, 'T4A', Sin)) then SaveDiagnostic(RetNo,FName,4,'E-T4A-SIN already exists for this employer   -'+SlipName);

   If Sin='000000000' then  //20190226
      SaveDiagnostic(RetNo,FName,4,'W-T4A-Failure to supply a valid SIN may result in CRA penalties. See the Guide  -'+SlipName);
  }
  //20180101
  if (Sin>'') Or (FetchElmFNo(RetNo,FNo,6)>'') then
  Begin
   if FetchElmFNo(RetNo,FNo,3)='' then
     SaveDiagnostic(RetNo,FName,3,'E-T4A-You must enter the T4A Account Number on the EMPL form   -'+SlipName);
   if T4AHasAmounts(RetNo,FName,FNo)=False then
   Begin
    SaveDiagnostic(RetNo,FName,14,'E-T4A-The slip does not have any amounts. If too many, click + then click the scrollbar   -'+SlipName);
   End;
  End;

  if Ret[RetNo].FrmHasData[Fno] = False then Exit;  //20171223

  If (FetchElmFNo(RetNo,FNo,5)>'') and (Length(FetchElmFNo(RetNo,FNo,5))<>15) then //Recipuent account
   SaveDiagnostic(RetNo,FName,5,'E-T4A-Recipient Account must in the format NNNNNNNNNXXNNNN-'+SlipName);

  If FetchElmFNo(RetNo,FNo,1)='2023' then  //20231231
   Begin
    if FetchElmFNo(RetNo,FNo,45)>'' then
      SaveDiagnostic(RetNo,FName,45,'W-T4A-Do not complete box 015 in 2023 - Dental by employer unless you are paper filing   -'+SlipName);
   End;

  If FetchElmFNo(RetNo,FNo,6)='' then //If FieldByName('LASTNAME').AsString = '' then
   SaveDiagnostic(RetNo,FName,6,'E-T4A-Recipient Name is required   -'+SlipName);

  If FetchElmFNo(RetNo,FNo,9)='' then
   SaveDiagnostic(RetNo,FName,9,'E-T4A-Street is required   -'+SlipName);

  If FetchElmFNo(RetNo,FNo,10)='' then
   SaveDiagnostic(RetNo,FName,10,'E-T4A-City is required   -'+SlipName);

  If Length(FetchElmFNo(RetNo,FNo,11))<>2 then
   SaveDiagnostic(RetNo,FName,11,'E-T4A-Valid Province Code is required   -'+SlipName);

  If FetchElmFNo(RetNo,FNo,12)='' then SaveDiagnostic(RetNo,FName,12,'E-T4A-Postal Code missing   -'+SlipName);
  If ValidPostal(MyStrToInt(FetchElmFNo(RetNo,FNo,13)),FetchElmFNo(RetNo,FNo,12))= false then
   SaveDiagnostic(RetNo,Fname,12,'W-T4A-Postal code is invalid -'+SlipName); //20190221  //fname  //20200302

  If Length(FetchElmFNo(RetNo,FNo,13))<>3 then
   SaveDiagnostic(RetNo,FName,13,'E-T4A-Valid Country Code is required   -'+SlipName);

End;

Procedure ValidateT5(RetNo:Integer; FName:String; FNo:Integer);
Var i:Integer;s:String;EmplCode:String;SIN:String;
SlipName:String;  //20190223
Begin
//  if FetchElm(RetNo,'EMPL',24) = '' then SaveDiagnostic(RetNo,FName,24,'E-T5-Please complete the Payer information first');


  //20171228
  If (FetchElmFNo(RetNo,FNo,11)='') and (FetchElmFNo(RetNo,FNo,19)='') then exit; //sin /id and last name

  Sin:=FetchElmFNo(RetNo,FNo,11); //20191221
  SlipName:=UpperCase(FetchElmFNo(RetNo,FNo,19))+' '+Fname;  //20190223
  If (Sin>'') and (ValidSin(Sin) = False)
  And (FetchElmFNo(RetNo,FNo,12) <'3')  //individual or joint
  then  SaveDiagnostic(RetNo,FName,11,'E-T5-SIN is invalid, OR temporarily enter 9 zeros if unknown -'+SlipName);
  If Sin>'' then
  Begin
    If Sin='000000000'  then  //20190226
      SaveDiagnostic(RetNo,FName,11,'W-T5-Failure to supply a valid SIN may result in CRA penalties. See the Guide  -'+SlipName)
    Else
     If CheckSINforDuplicates(RetNo, FNo, 'T5', Sin)=False then
       SaveDiagnostic(RetNo,FName,11,'W-T5-SIN already exists for this employer  -'+SlipName); //20200210
  End;

  //20191221 recipient is B/N or trust
  If (FetchElmFNo(RetNo,FNo,12) ='3') then //or (FetchElmFNo(RetNo,FNo,12) ='4') then//Corp or trust //20200124
  begin
   If (Length(FetchElmFNo(RetNo,FNo,11))<>15)
   or (ValidSin(LeftStr(FetchElmFNo(RetNo,FNo,11),9)) = False)
    then
     SaveDiagnostic(RetNo,FName,11,'E-T5-The Recipient is invalid. Enter a valid 15 character Business number -'+SlipName);  //202001
  end;




  {
  If (Sin>'')  and (not CheckSINforDuplicates(RetNo, FNo, 'T5', Sin)) then
  Begin
   If SIN<>'000000000' then
    SaveDiagnostic(RetNo,FName,11,'E-T5-SIN already exists for this employer  -'+SlipName);
  End;

  If Sin='000000000' then  //20190226
      SaveDiagnostic(RetNo,FName,11,'W-T5-Failure to supply a valid SIN may result in CRA penalties. See the Guide  -'+SlipName);
  }

  //20180106 no good
  //If (Sin>'') and (ValidSin(Sin) = False)
  {
  If (FetchElmFNo(RetNo,FNo,12) ='3')  //individual or joint)
  and (Length(Sin) <>12)
  then  SaveDiagnostic(RetNo,FName,11,'W-T5-Corporate Recipient Number (Account) may be invalid');
  }
  //-------------------------
    //20180101
  if (Sin>'') or (FetchElmFNo(RetNo,FNo,19)>'') then
  Begin
   if T5HasAmounts(RetNo,FName,FNo)=False then
   Begin
    SaveDiagnostic(RetNo,FName,2,'E-T5-The slip does not have any amounts. If too many, click + then click the scrollbar  -'+SlipName);
   End;
  End;

  if Ret[RetNo].FrmHasData[Fno] = False then
       Exit;  //20171223

  If FetchElmFNo(RetNo,FNo,19)='' then
   SaveDiagnostic(RetNo,FName,19,'E-T5-Recipient Name is required  -'+SlipName);

  //20171228
  If (FetchElmFNo(RetNo,FNo,19)>'')
  and (FetchElmFNo(RetNo,FNo,11)='')
  then //name entered
   SaveDiagnostic(RetNo,FName,11,'E-T5-Recipient Id is required  -'+SlipName);

  If FetchElmFNo(RetNo,FNo,20)='' then
   SaveDiagnostic(RetNo,FName,20,'E-T5-Street is required   -'+SlipName);

  If FetchElmFNo(RetNo,FNo,21)='' then
   SaveDiagnostic(RetNo,FName,21,'E-T5-City is required   -'+SlipName);

  If Length(FetchElmFNo(RetNo,FNo,22))<>2 then //20171223
   SaveDiagnostic(RetNo,FName,22,'E-T5-Valid Province Code is required   -'+SlipName);

  If FetchElmFNo(RetNo,FNo,23)='' then   //postal
   SaveDiagnostic(RetNo,FName,23,'E-T5-Postal Code is required   -'+SlipName);

  If ValidPostal(MyStrToInt(FetchElmFNo(RetNo,FNo,32)),FetchElmFNo(RetNo,FNo,23))= false then  //Fname was 'T5' 20180223  //pass country and postal
   SaveDiagnostic(RetNo,Fname,23,'W-T5-Postal code is invalid   -'+SlipName);     //20200302

   {20171224
  If Length(FetchElmFNo(RetNo,FNo,32))<>3 then //20171223
   SaveDiagnostic(RetNo,FName,32,'E-T5-Valid Country Code is required');
   }
End;


//201780101
Function T4HasAmounts(RetNo:Integer;FName:String;FNo:Integer):Boolean;
Var i:Integer;X:Real;
Begin
 Result:=False;
 x:=0;
 for i:=18 to 23 do X:=X+Vl(FetchElmFNo(RetNo,FNo,i));
 for i:=24 to 28 do X:=X+Vl(FetchElmFNo(RetNo,FNo,i));

 i:=31;
 Repeat
  X:=X+Vl(FetchElmFNo(RetNo,FNo,i));
  Inc(i,2);
 Until i>41;

 if X>0 then Result:=True;
End;

//201780101
Function T4AHasAmounts(RetNo:Integer;FName:String;FNo:Integer):Boolean;
Var i:Integer;X:Real;
Begin
 Result:=False;
 x:=0;
 for i:=14 to 19 do X:=X+Vl(FetchElmFNo(RetNo,FNo,i));

 i:=14;
 Repeat
  X:=X+Vl(FetchElmFNo(RetNo,FNo,i));
  Inc(i,2);
 Until i>43;

 if X>0 then Result:=True;
End;

//201780101
Function T5HasAmounts(RetNo:Integer;FName:String;FNo:Integer):Boolean;
Var i:Integer;X:Real;
Begin
 Result:=False;
 x:=0;
 for i:=2 to 9 do X:=X+Vl(FetchElmFNo(RetNo,FNo,i));

 i:=14;
 Repeat
  X:=X+Vl(FetchElmFNo(RetNo,FNo,i));
  Inc(i,2);
 Until i>18;

 if X>0 then Result:=True;
End;

end.
