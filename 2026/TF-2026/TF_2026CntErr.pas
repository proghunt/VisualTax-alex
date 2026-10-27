unit TF_2026cnterr;

interface

uses
  System.Classes, vtDynData; //20260817 Alex

  procedure CountDiagnostics(RetNo: integer);
  procedure ValidateT1135(RetNo:Integer;Fno:Integer); //20160314 Igor
  procedure RemoveT1135SectionAdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  procedure RemoveT1135SectionBdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  procedure ValidateT1135SectionAdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  procedure ValidateT1135SectionBdata(RetNo:Integer;Fno:Integer); //20160314 Igor
  procedure ValidateNR4Det(RetNo:Integer;Fno:Integer;FInst:String); //20180315
  procedure ValidateT1134(RetNo: Integer; Fno: Integer); //20260817 Alex
  procedure ValidateT1134S(RetNo: Integer; Fno, FInst: Integer); //20260817 Alex
procedure ValidateT5013Slips(RetNo: Integer; Fno:Integer; FInst: String);

implementation

uses
  SysUtils, vtCommon, TF_2026, TF_2026TrimStr, TF_2026Declare, TF_2026Common,
  TF_2026Common2, vtTrimStr, vtShared, vtMulti; //20260817 Alex

//Function CountDiagnostics(RetNo: integer):Integer;
procedure CountDiagnostics(RetNo: integer);
Var i,j,k,Page1FNo,FNo,ElmNo : integer; FrmNm : string[12];
j1,J2,J3:Integer;
ErrMsg : string[50];x:real;s:String;
FInst:String;
begin
  If RetNo=0 then exit;
  If RetInMem < 1 then exit;
  Ret[RetNo].AuditList.Clear;


  //20190113
  FNo:= GetFormNo('T2054');
  If Ret[RetNo].FrmHasData[Fno] then  //20180316
  begin
    If (Vl(FetchElmFNo(RetNo,FNo,101))>0)
    and (FetchElmFNo(RetNo,FNo,104)='')
     then SaveDiagnostic(RetNo,'T2054',104,'W-T2054-Enter Number of Days');
  end;


  //20180216
  FNo:= GetFormNo('NR4SUM');
  s:=FetchElmFNo(RetNo,FNo,3); //acc no
  If S > '' then
  begin
    If (Length(S)<>9) //(Or (UpperCase(LeftStr(S,2))<>'NR'))
    then
     SaveDiagnostic(RetNo,'NR4SUM',3,'W-NR4 Account must be 3 alpha charracters plus 6 digits');
  end;
  If Ret[RetNo].FrmHasData[Fno] then  //20180316
  begin
    If FetchElmFNo(RetNo,FNo,4)='' then SaveDiagnostic(RetNo,'NR4SUM',4,'E-NR4SUM-Enter Payer Name');
    If FetchElmFNo(RetNo,FNo,5)='' then SaveDiagnostic(RetNo,'NR4SUM',5,'E-NR4-Enter Payer address street');
    If FetchElmFNo(RetNo,FNo,7)='' then SaveDiagnostic(RetNo,'NR4SUM',7,'E-NR4-Enter Payer City');
    If FetchElmFNo(RetNo,FNo,8)='' then SaveDiagnostic(RetNo,'NR4SUM',8,'E-NR4-Enter Payer Postal');
    If FetchElmFNo(RetNo,FNo,26)='' then SaveDiagnostic(RetNo,'NR4SUM',26,'E-NR4-Enter Payer Country');
  end;

  //20260817 Alex >>>
  FNo:= GetFormNo('T1134');
  ValidateT1134(RetNo, FNo);

  for i:= 1 to 10 do
  begin
    FNo:= GetFormNo('T1134S#' + IntToStr(i));

    if (FNo > 0) then ValidateT1134S(RetNo, FNo, i);
  end;
  //20260817 Alex <<<

  //------------------
  // T3010 //20131231
  FNo:= GetFormNo('T3010');
  If (Ret[RetNo].FrmHasData[FNo]) then
  begin
   If (FetchElmFNo(RetNo,FNo,1)>'') and (FetchElmFNo(RetNo,FNo,1)<='2023-12-30') then //20231226
   begin
     SaveDiagnostic(RetNo,'T3010',1,'E-T3010-For year end of Dec 30, 2023 or before, use the previous year program');
   end;
   {
   If (FetchElmFNo(RetNo,FNo,1)>'') and (FetchElmFNo(RetNo,FNo,1)<'2013-01-01') then
   begin
     SaveDiagnostic(RetNo,'T3010',1,'E-T3010-Charity Y/E must be 2013-01-01 or later');
   end;
   }
  //20200105
   if (FetchElmFNo(RetNo,FNo,92)>'') and (Vl(FetchElmFNo(RetNo,FNo,149))=0) then
      SaveDiagnostic(RetNo,'T3010',149,'E-T3010-Activities Outside Canada-Please complete Schedule 2');

   if (FetchElmFNo(RetNo,FNo,92)='') and (Vl(FetchElmFNo(RetNo,FNo,149))>0) then
      SaveDiagnostic(RetNo,'T3010',92,'E-T3010-Activities Outside Canada-Please enter X');


   if (FetchElmFNo(RetNo,FNo,94)>'') and (Vl(FetchElm(RetNo,'T1236#1',77))=0) then
      SaveDiagnostic(RetNo,'T1236',94,'E-T3010-Please complete schedule T1236');

   if (FetchElmFNo(RetNo,FNo,94)='') and (Vl(FetchElm(RetNo,'T1236#1',77))>0) then
      SaveDiagnostic(RetNo,'T3010',94,'E-T3010-Please enter X for qualified donees related to T1236'); //please mispelled //20220109

   //----------------

   If (FetchElmFNo(RetNo,FNo,37) > '') then
   begin
    If FetchElmFNo(RetNo,FNo,1)='' then
     SaveDiagnostic(RetNo,'T3010',1,'E-T3010-Enter fiscal year end');
   end;
   {If FetchElmFNo(RetNo,FNo,1)<'2010-03-04' then
     SaveDiagnostic(RetNo,'T3010',1,'E-T3010-Year End must be March 4, 2010 or later');
   }
   If (FetchElmFNo(RetNo,FNo,2) > '') then
   begin
    If ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,2)) = false then
     SaveDiagnostic(RetNo,'T3010',2,'E-T3010-Business number is invalid. Format expected ia 999999999RR0001');   //20201211
   end;
   If (FetchElmFNo(RetNo,FNo,12) > '') then
   begin
    If ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,12)) = false then
     SaveDiagnostic(RetNo,'T3010',12,'E-T3010-Business number is invalid. Format expected ia 999999999RR0001');  //20201211
   end;
   If (Vl(FetchElmFNo(RetNo,FNo,300)) <> 0) then
   begin
    If FetchElmFNo(RetNo,FNo,301)='' then
     SaveDiagnostic(RetNo,'T3010',301,'E-T3010-Provide description');
   end;
   If (Vl(FetchElmFNo(RetNo,FNo,316)) <> 0) then
   begin
    If FetchElmFNo(RetNo,FNo,317)='' then
     SaveDiagnostic(RetNo,'T3010',317,'E-T3010-Provide description');
   end;

   {//removed //20230706 CON
   If Vl(FetchElmFNo(RetNo,FNo,286)) >0 then  //20131231
   begin
    If FetchElmFNo(RetNo,FNo,382)+FetchElmFNo(RetNo,FNo,383)+FetchElmFNo(RetNo,FNo,384)='' then
         SaveDiagnostic(RetNo,'T3010',382,'E-T3010-Provide details for political activity');
   end;
   }

   If Vl(FetchElmFNo(RetNo,FNo,318)) <>
     +Vl(FetchElmFNo(RetNo,FNo,319))
     +Vl(FetchElmFNo(RetNo,FNo,320))
     +Vl(FetchElmFNo(RetNo,FNo,321))
     //+Vl(FetchElmFNo(RetNo,FNo,322))  //jz//20230706
     +Vl(FetchElmFNo(RetNo,FNo,323))
   then
   Begin   //20230706 CON  Treat it as warning
     SaveDiagnostic(RetNo,'T3010',319,'W-T3010-Ln 4950 must equal sum of Ln 5000 to L5040 ');
     SaveDiagnostic(RetNo,'T3010',320,'W-T3010-Ln 4950 must equal sum of Ln 5000 to L5040 ');
     SaveDiagnostic(RetNo,'T3010',321,'W-T3010-Ln 4950 must equal sum of Ln 5000 to L5040 ');
     //SaveDiagnostic(RetNo,'T3010',322,'E-T3010-Ln 4950 must equal sum of Ln 5000 to L5040 '); //jz//20230706
     SaveDiagnostic(RetNo,'T3010',323,'W-T3010-Ln 4950 must equal sum of Ln 5000 to L5040 ');
   end;
  end; //t3010



  //T1235
  For i:=1 to 4 do
  begin
   FNo:=GetFormNo('T1235#'+AllTrim(IntToStr(i)),False);
   if FNo < 1 then break;
   If FNo>0 then
   begin
    If Ret[RetNo].FrmHasData[FNo] then
    begin
     j:=1;
     Repeat
     If FetchElmFno(RetNo,FNo,j)>'' then
     begin
       If (FetchElmFNo(RetNo,FNo,j+1) = '')
       or (FetchElmFNo(RetNo,FNo,j+9) = '')
       or (FetchElmFNo(RetNo,FNo,j+3) = '')
       then
       begin
        SaveDiagnostic(RetNo,'T1235#'+AllTrim(IntToStr(i)),j,'E-T1235 Complete all Public and Confidential data');
       end;
     end;
     Inc(j,12);
     until j>73;
    end;
   end;
  end;

  //T1236
  For i:=1 to 4 do
  begin
   FNo:=GetFormNo('T1236#'+AllTrim(IntToStr(i)),False);
   If FNo>0 then
   begin
    If Ret[RetNo].FrmHasData[FNo] then
    begin
     j:=4;
     Repeat
     If FetchElmFno(RetNo,FNo,j)>'' then
     begin
       If ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,j)) = false then
        SaveDiagnostic(RetNo,'T1236#'+AllTrim(IntToStr(i)),j,'W-T1236-Business number may be invalid');
     end;
     If (vl(FetchElmFno(RetNo,FNo,j+1))+vl(FetchElmFno(RetNo,FNo,j+2))+vl(FetchElmFno(RetNo,FNo,j+3))>0)
     and (vl(FetchElmFno(RetNo,FNo,j+4))=0) then
     begin
        SaveDiagnostic(RetNo,'T1236#'+AllTrim(IntToStr(i)),j+4,'E-T1236-Enter total gifts');
     end;

     Inc(j,8);
     until j>68;
    end;
   end;
  end;


  FNo:= GetFormNo('T5013FIN');
  If (Ret[RetNo].FrmHasData[FNo]) then
  begin
   If (FetchElmFNo(RetNo,FNo,1) > '')
   and (Length(FetchElmFNo(RetNo,FNo,1)) < 15)
   then SaveDiagnostic(RetNo,'T5013FIN',1,'E-Enter a Filer account number (15 characters)');

   If LeftStr(FetchElmFNo(RetNo,FNo,39),4) > IntToStr(StrToInt(AppYear)+1) then
    SaveDiagnostic(RetNo,'T5013FIN',39,'M-YearEnd Date entered not supported by this program version');
  end;

  If ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,1))=False then
     SaveDiagnostic(RetNo,'T5013FIN',1,'E-Enter a valid account number (15 characters)');  //20240318

  If FetchElmFNo(RetNo,FNo,1)>'' then
  Begin
   If (UpperCase(MidStr(FetchElmFNo(RetNo,FNo,1),10,1)) <> 'R')
   and (UpperCase(MidStr(FetchElmFNo(RetNo,FNo,1),11,1)) <> 'Z')
    then SaveDiagnostic(RetNo,'T5013FIN',1,'E-Enter a Filer account number (RZ)');
  end;

  If (FetchElmFNo(RetNo,FNo,65)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS9#1')]) then
    SaveDiagnostic(RetNo,'T5013FIN',65,'W-T5013-Indicator sb set to Yes, as S9 completed');

  If (FetchElmFNo(RetNo,FNo,71)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS2#1')]) then
    SaveDiagnostic(RetNo,'T5013FIN',71,'W-T5013-Indicator s/b set to Yes, as S2 completed');

  If (FetchElmFNo(RetNo,FNo,73)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS5')]) then
    SaveDiagnostic(RetNo,'T5013FIN',73,'W-T5013-Indicator s/b set to Yes, as S5 completed');

  If (FetchElmFNo(RetNo,FNo,75)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS6')]) then
    SaveDiagnostic(RetNo,'T5013FIN',75,'W-T5013-Indicator s/b set to Yes, as S6 completed');

  If (FetchElmFNo(RetNo,FNo,77)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS8#1')]) then
    SaveDiagnostic(RetNo,'T5013FIN',77,'W-T5013-Indicator s/b set to Yes, as S8 completed');

  If (FetchElmFNo(RetNo,FNo,79)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS10#1')]) then
    SaveDiagnostic(RetNo,'T5013FIN',79,'W-T5013-Indicator s/b set to Yes, as S10 completed');

  If (FetchElmFNo(RetNo,FNo,81)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS12')]) then
    SaveDiagnostic(RetNo,'T5013FIN',81,'W-T5013-Indicator s/b set to Yes, as S12 completed');

  If (FetchElmFNo(RetNo,FNo,87)='') and (Ret[RetNo].FrmHasData[GetFormNo('PS52')]) then
    SaveDiagnostic(RetNo,'T5013FIN',87,'W-T5013-Indicator s/b set to Yes, as S52 completed');

  //20180422
  If (FetchElmFNo(RetNo,FNo,89)='') and (Ret[RetNo].FrmHasData[GetFormNo('T1135')]) then
    SaveDiagnostic(RetNo,'T5013FIN',89,'W-T5013-Indicator s/b set to Yes, as T1135 completed');


  //20160209
  FNo:=GetFormNo('T5013FIN');
  If FNo>0 then
  Begin
    If (Ret[RetNo].FrmHasData[FNo]) then
    x:=0;
    for j :=0 to (Flist.Count-1) do
    begin
      FRec := FList.Items[j];
      if Frec.FormName = 'PS50' then
      begin
       FNo :=Frec.FormNo;
       FInst:=Frec.FormInst;
       If Ret[Retno].FrmHasData[Frec.FormNo] then
       begin
         X:=X+Vl(FetchElmFNo(RetNo,Frec.FormNo,16));
         If Vl(FetchElmFNo(RetNo,Frec.FormNo,16))=0 then  //20260903
            SaveDiagnostic(RetNo,Frec.FormName+Frec.FormInst,16,'E-T5013-S50-Partner % must be entered');
         If Vl(FetchElmFNo(RetNo,Frec.FormNo,16))>100 then
            SaveDiagnostic(RetNo,Frec.FormName+Frec.FormInst,16,'E-T5013-S50-Partner % exceeds 100');
         If FetchElmFNo(RetNo,Frec.FormNo,15)='2' then  //20260830
         Begin
          if Vl(FetchElm(RetNo,'PS1',155))=0 then
           SaveDiagnostic(RetNo,'PS1',155,'W-T5013-Sch 1-Line 504-No amount allocated to general partner');
         End;
         If (FetchElmFNo(RetNo,Frec.FormNo,11)>'')  //20260910
         and (FetchElmFNo(RetNo,Frec.FormNo,13)='')
          then SaveDiagnostic(RetNo,Frec.FormName+Frec.FormInst,13,'E-T5013-S50-PartnerId is required');


       end;
      end;
    end;
    If X>100 then SaveDiagnostic(RetNo,'PS50#1',16,'E-T5013-S50-Total percent of ALL partners is over 100('+FormatFloat('#####',X)+'%)');
    If (Ret[RetNo].FrmHasData[GetFormNo('PS50#1')]) and (X<100)  //20170308
       then SaveDiagnostic(RetNo,'PS50#1',16,'W-T5013-S50-Total percent of ALL partners is not 100 ('+FormatFloat('#####',X)+'%)');
  end;

  FNo:=GetFormNo('PS65');
  If FNo>0 then
  Begin
   if Vl(FetchElmFNo(RetNo,Fno,40))> Vl(FetchElmFNo(RetNo,Fno,22)) then
      SaveDiagnostic(RetNo,'PS65',40,'E-T5013-PS65-Total allocated to partners exceeds amount on box 510');
  end;
  //----------------
  //PS8 validation  //20200228
  for k:=1 to 3 do
  Begin
   FNo:=GetFormNo('PS8#'+IntToStr(k));

   If Ret[RetNo].FrmHasData[FNo] then
   begin
    i:=6;
    j:=236;
    j1:=371;
    J2:=356;  //aiip flag
    J3:=252;
    repeat
     //20190705
       if FetchElmFNo(RetNo,FNo,i)>'' then  //cls
       Begin
        s:=FetchElmFNo(RetNo,FNo,j); //purch date s/b yyyy/mm/dd
        //20190710
        if AllTrim(s)='' then
        Begin
         if FetchElmFNo(RetNo,FNo,i)<>'10.1' then  //20190710
           SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j,'W-S8-Purchase date assumed prior to Nov 21,2018, or enter actual date') ;
        End;
           // so no Enter the purchase date in the format: yyyy/mm/dd');
        If AllTrim(s)>'' then  //20190706
        Begin
          If EditDate(LeftStr(FetchElmFNo(RetNo,FNo,j),10),AppYearInt-50,AppYearInt+50) = false then
           SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Purchase date is invalid, it must be in format yyyy/mm/dd');
        End;
       End;

     //-----------  all forced to ener date purchases
      //20190622
      if AllTrim(FetchElmFNo(RetNo,FNo,i))='10.1' then
      begin
        s:=FetchElmFNo(RetNo,FNo,j); //purch date s/b yyyy/mm/dd
        if AllTrim(s)='' then  SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j,'E-S8-Class 10.1: Enter the purchase date in the format: yyyy/mm/dd');

       //If (s>'2018/11/20')
       If Vl(FetchElmFNo(RetNo,FNo,i+2))>0 //additions
       then //20190622
       begin
        if Vl(FetchElmFNo(RetNo,FNo,i+2))<34000 then  //20230322
        //if Vl(FetchElmFNo(RetNo,FNo,i+2))<30000 then  //20190706
          SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),I+2,'E-S8 Class 10.1 s/b at least $34,000 and on its own line'); //20190707
       end;
      end;

      //20190806
      If Vl(FetchElmFNo(RetNo,FNo,i+2))>0 //additions
      then
      Begin
       if (FetchElmFNo(RetNo,FNo,J2)>'') and  (Vl(FetchElmFNo(RetNo,FNo,J3))=0) then //aiip and not amount for aiip
        SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),J3,'W-S8 Any amount for AIIP column?');
      End;

      //---------------------------
      if LeaseHold(AllTrim(FetchElmFNo(RetNo,FNo,i))) then
      //if AllTrim(FetchElmFNo(RetNo,FNo,i))='13' then
      begin
       if Vl(FetchElmFNo(RetNo,FNo,j1))=0 then  //20190613
        SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j1,'E-S8 Lease/Franchise Original Cost must be entered'); //20190806

       s:=FetchElmFNo(RetNo,FNo,j); //it should be yyyy/mm/dd-yyyy/mm/dd
       if AllTrim(s)='' then
         SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j,'E-S8 Lease/Franchise From-To dates must be in format: yyyy/mm/dd-yyyy/mm/dd');//20190806
       If EditDate(LeftStr(FetchElmFNo(RetNo,FNo,j),10),AppYearInt-50,AppYearInt+50) = false then
        SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Lease/Franchise start date is invalid (Dates Format: yyyy/mm/dd-yyyy/mm/dd)');

       If EditDate(MidStr(FetchElmFNo(RetNo,FNo,j),12,10),AppYearInt-50,AppYearInt+50) = false then
        SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Lease/Franchise end date is invalid (Dates Format: yyyy/mm/dd-yyyy/mm/dd)');

       If LeftStr(FetchElmFNo(RetNo,FNo,j),10) >= MidStr(FetchElmFNo(RetNo,FNo,j),12,10) then
        SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),j,'E-S8'+IntToStr(k)+' Lease/Franchise End date less than Start date (Dates Format: yyyy/mm/dd-yyyy/mm/dd)');
      end;

      //check for gaps   //20190831
      If (i<=166) and (FetchElmFNo(RetNo,FNo,i)>'') and (FetchElmFNo(RetNo,FNo,i+16)='') and (FetchElmFNo(RetNo,FNo,i+32)>'') then
      Begin
       SaveDiagnostic(RetNo,'PS8#'+IntToStr(k),i+16,'E-S8'+IntToStr(k)+' You cannot leave blank lines in between. Please complete lines in sequence.');
      End;

    Inc(i,16);
    Inc(j,1);
    Inc(j1,1);
    Inc(j2,1);
    Inc(j3,1);
    until i>198;
   end;
  end;



  //T5018S
  FNo:= GetFormNo('T5018S');
  If FetchElm(RetNo,'T5018S',2) >'' then
  begin
   If FetchElm(RetNo,'T5018S',9) = 'CAN' then
   begin
    if not ValidPostal(RetNo,FetchElm(RetNo,'T5018S',9)) then
        SaveDiagnostic(RetNo,'T5018S',2,'E-T5018 Summary-Invalid Postal Code');
   end;


   If ValidPhoneNo(FetchElm(RetNo,'T5018S',17))=false then
        SaveDiagnostic(RetNo,'T5018S',17,'E-T5018 Summary-Invalid Telephone No.');

   If ValidBusNumber(RetNo,FetchElm(RetNo,'T5018S',2))=false then
        SaveDiagnostic(RetNo,'T5018S',2,'E-T5018 Summary-Invalid Business No.');

   If FetchElmFNo(RetNo,FNo,14) = '' then
    SaveDiagnostic(RetNo,'T5018S',14,'E-T5018 Summary-Complete Contact Information');
   If FetchElmFNo(RetNo,FNo,15) = '' then
    SaveDiagnostic(RetNo,'T5018S',15,'E-T5018 Summary-Complete Contact Information');
   If FetchElmFNo(RetNo,FNo,16) = '' then
    SaveDiagnostic(RetNo,'T5018S',16,'E-T5018 Summary-Complete Contact Information');
   If FetchElmFNo(RetNo,FNo,17) = '' then
    SaveDiagnostic(RetNo,'T5018S',17,'E-T5018 Summary-Complete Contact Information');

   If MidStr(FetchElmFNo(RetNo,FNo,17),4,1) <> '-' then  //20170306
   //If FetchElmFNo(RetNo,FNo,17)[4] <> '-' then
    SaveDiagnostic(RetNo,'T5018S',17,'E-T5018 Summary-Phone Number Format Incorrect (nnn-nnnn)');
  end;
  //T5018S end

   //T5018L
   //For j:=1 to 100 do
   k:=200;   //CountT5018Slips(RetNo);  //20130204
   For j:=1 to k do
   begin
    FNo:=GetFormNo('T5018L#'+AllTrim(IntToStr(j)),False);

    //20130325
    If (Fno>0) and (Ret[RetNo].FrmHasData[FNo]) and (Vl(FetchElmFNo(RetNo,FNo,2))=0) then  //20131230 if Fno>0
      SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),2,'E-T5018 No Payment entered. Enter it or clear the slip'); //20170621

    If Vl(FetchElmFNo(RetNo,FNo,2))>0  then
    begin
      If FetchElmFNo(RetNo,FNo,1) = '' then
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),1,'E-T5018 slips-Enter Period Ending');

      If FetchElmFNo(RetNo,FNo,3) + FetchElmFNo(RetNo,FNo,4)= '' then //+ FetchElmFNo(RetNo,FNo,5) = '' then  //20200112
      begin
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),3,'E-T5018 slips-Enter BN or SIN');
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),4,'E-T5018 slips-Enter BN or SIN');
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),5,'E-T5018 slips-Enter BN or SIN');
      end;

      If ((FetchElmFNo(RetNo,FNo,3)>'') and (FetchElmFNo(RetNo,FNo,4) >'')) then
      begin
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),3,'E-T5018 slips-Enter only one of BN or SIN');
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),4,'E-T5018 slips-Enter only one of BN or SIN');
      end;

      {20200112
      If ((FetchElmFNo(RetNo,FNo,3)>'') and (FetchElmFNo(RetNo,FNo,5) >'')) then
      begin
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),3,'E-T5018 slips-Enter only one of BN, SIN or FIN');
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),5,'E-T5018 slips-Enter only one of BN, SIN or FIN');
      end;

      If ((FetchElmFNo(RetNo,FNo,4)>'') and (FetchElmFNo(RetNo,FNo,5) >'')) then
      begin
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),4,'E-T5018 slips-Enter only one of BN, SIN or FIN');
       SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),5,'E-T5018 slips-Enter only one of BN, SIN or FIN');
      end;
      }
     If FetchElmFNo(RetNo,FNo,3) >'' then
     begin
      If (ValidBusNumber(RetNo,FetchElmFNo(RetNo,FNo,3))=false)
      or (Length(FetchElmFNo(RetNo,FNo,3))<>15)  //20130402
       then
        SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),3,'E-T5018 slips-Invalid Business No.- Use Format NNNNNNNNNAANNNN');
     end;


     If FetchElmFNo(RetNo,FNo,4) >'' then
     begin
      If ValidSin(FetchElmFNo(RetNo,FNo,4))= false then
        SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),4,'E-T5018 slips-Invalid SIN');
     end;

     If (FetchElmFNo(RetNo,FNo,9)='') and (FetchElmFNo(RetNo,FNo,3) + FetchElmFNo(RetNo,FNo,5) > '') then
     begin
        SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),9,'E-T5018 slips-Name');
     end;
     If ( (FetchElmFNo(RetNo,FNo,6)='') or (FetchElmFNo(RetNo,FNo,7)='') ) and (FetchElmFNo(RetNo,FNo,4)>'') then
     begin
        if (FetchElmFNo(RetNo,FNo,6)='') then
            SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),6,'E-T5018 slips-First Name');
        if (FetchElmFNo(RetNo,FNo,7)='') then
            SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),7,'E-T5018 slips-Last Name');
     end;

     If (FetchElmFNo(RetNo,FNo,10)='') and (FetchElmFNo(RetNo,FNo,11)='') then
        SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),10,'E-T5018 slips-Enter Address');
     if (FetchElmFNo(RetNo,FNo,12)='') then SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),12,'E-T5018 slips-Enter City');
     if (FetchElmFNo(RetNo,FNo,13)='') then SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),13,'E-T5018 slips-Enter Province');
     if (FetchElmFNo(RetNo,FNo,14)='') then SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),14,'E-T5018 slips-Enter Postal Code');
     If FetchElmFNo(RetNo,FNo,15) = 'CAN' then
     begin
      if not ValidPostal(RetNo,FetchElmFNo(RetNo,FNo,14)) then
        SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),14,'E-T5018 Summary-Invalid Postal Code');
     end;

     if (FetchElmFNo(RetNo,FNo,15)='') then SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),15,'E-T5018 slips-Enter Country Code');
     if Length(FetchElmFNo(RetNo,FNo,15))<3  then
         SaveDiagnostic(RetNo,'T5018L#'+AllTrim(IntToStr(j)),15,'E-T5018 slips-Country must be 3 characters');
    end;
   end;
   //T5018L end

  //PS141  ------------
  If Uppercase(FetchElm(RetNo,'T5013SUM',182))='X' then //paid someone
  begin
   FNo:=GetFormNo('PS141');
   If (Ret[RetNo].FrmHasData[GetFormNo('PS141')]= False) then
    SaveDiagnostic(RetNo,'PS141',6,'E-Notes checklist not completed');

   If FetchElmFNo(RetNo,Fno,6)+FetchElmFNo(RetNo,FNo,7) = '' then
    SaveDiagnostic(RetNo,'PS141',6,'E-Notes-Professional designation missing');

   If FetchElmFNo(RetNo,Fno,32)+FetchElmFNo(RetNo,FNo,33) = '' then
    SaveDiagnostic(RetNo,'PS141',32,'E-Notes-Practitioner connection missing');

   If ((FetchElmFNo(RetNo,Fno,6)>'') and (FetchElmFNo(RetNo,Fno,33)>''))
   and (FetchElmFNo(RetNo,Fno,34)+FetchElmFNo(RetNo,FNo,35)+FetchElmFNo(RetNo,FNo,36) = '')
   then
   begin
    SaveDiagnostic(RetNo,'PS141',34,'E-Notes-Type of involvement required');
    SaveDiagnostic(RetNo,'PS141',35,'E-Notes-Type of involvement required');
    SaveDiagnostic(RetNo,'PS141',36,'E-Notes-Type of involvement required');
   end;

   If ((FetchElmFNo(RetNo,Fno,34)>'') or (FetchElmFNo(RetNo,Fno,35)>''))
   and (FetchElmFNo(RetNo,Fno,38)+FetchElmFNo(RetNo,FNo,39) = '')
   then
    SaveDiagnostic(RetNo,'PS141',38,'E-Notes-Practitioner reservation missing');

   If (FetchElmFNo(RetNo,Fno,26) > '')
   and (FetchElmFNo(RetNo,Fno,28) +FetchElmFNo(RetNo,Fno,29) = '')
   then
    SaveDiagnostic(RetNo,'PS141',28,'E-Notes-Joint ventures indicator missing');
  end; //Ps141

  k:=GetNumberofPartnersfromPs50(RetNo);
  For j:=1 to k do
  begin
   FInst:='#'+AllTrim(IntToStr(j));
   FNo:=GetFormNo('T5013'+FInst);
   ValidateT5013Slips(RetNo,FNo,FInst);  //20160314 Igor
  end;

  //20180315
  k:=200;
  For j:=1 to k do
  begin
   FInst:='#'+AllTrim(IntToStr(j));
   FNo:=GetFormNo('NR4DET'+FInst);
   ValidateNR4DET(RetNo,FNo,FInst);  //20160314 Igor
  end;

  FNo:=GetFormNo('T1135'); //20160314 Igor
  ValidateT1135(RetNo,FNo);  //20160314 Igor

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
      SaveDiagnostic(RetNo,FrmNm,126,'D-Tape'+' '+FetchElm(RetNo,FrmNm,121));
     end;
   end;
*)

   If Frec.FormName = 'FLDMEM' then
   begin
     FrmNm:=Frec.FormName+FRec.FormInst;
     If Ret[RetNo].FrmHasData[FRec.FormNo] = True then
     begin
      SaveDiagnostic(RetNo,FrmNm,17,'N-Note'+' '+FetchElm(RetNo,FrmNm,17));
     end;
   end;
  end; {i}
  //Result := ErrorCount;
End;

Procedure ValidateT1135(RetNo:Integer;Fno:Integer); //20160314 Igor
//Var s:String;
begin
   {//20240725
  If (FetchElmFNo(RetNo,FNo,13)>'') and (FetchElmFNo(RetNo,FNo,12)='') then //20240318
   SaveDiagnostic(RetNo,'T1135',12,'E-T1135-Please tick the Partnership box'); //20240318
  }

   //T1135  brand new 20160124  REDO
  //
  if Fetchelm(RetNo,'T1135',12)>'' then //20240725
  //If Ret[RetNo].FrmHasData[FNo] = True then
  Begin
   //20180210
   if FetchElmFNo(RetNo,FNo,12)='' then SaveDiagnostic(RetNo,'T1135',12,'E-T1135-Please tick the Partnership box'); //20240318
   If FetchElmFNo(RetNo,FNo,13)='' then SaveDiagnostic(RetNo,'T1135',13,'E-T1135-Partnership''s name is required');
   If FetchElmFNo(RetNo,FNo,14)+FetchElmFNo(RetNo,FNo,35)='' then
   Begin
    SaveDiagnostic(RetNo,'T1135',14,'E-T1135-Partnership Account number is required');
    SaveDiagnostic(RetNo,'T1135',35,'E-T1135-Partnership Account number is required');
   End;
   //20180210
   If FetchElmFNo(RetNo,FNo,25)+FetchElmFNo(RetNo,FNo,26)+FetchElmFNo(RetNo,FNo,27)='' then
   Begin
    SaveDiagnostic(RetNo,'T1135',25,'E-T1135-Partnership Code is required');
    SaveDiagnostic(RetNo,'T1135',26,'E-T1135-Partnership Code is required');
    SaveDiagnostic(RetNo,'T1135',27,'E-T1135-Partnership Code is required');
   End;

  //20160314 Igor <<<<
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
   if FetchElmFNo(RetNo,FNo,72)>'' then
    if Length(FetchElmFNo(RetNo,FNo,72))<14 then SaveDiagnostic(RetNo,'T1135',72,'E-T1135-Date must be in the format 9(999)999-9999');
   if FetchElmFNo(RetNo,FNo,77)>'' then
    if Length(FetchElmFNo(RetNo,FNo,77))<14 then SaveDiagnostic(RetNo,'T1135',77,'E-T1135-Date must be in the format 9(999)999-9999');
  end;
end;

Procedure RemoveT1135SectionAdata(RetNo:Integer;Fno:Integer); //20160314 Igor
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

Procedure RemoveT1135SectionBdata(RetNo:Integer;Fno:Integer); //20160314 Igor
Var i:Integer;
Begin
  i:=1;
  Repeat
    If (FetchElmFNo(RetNo,FNo,i*10001)>'') then SaveDiagnostic(RetNo,'T1135',i*10001,'E-T1135-Delete all data from Part B');
    Inc(i,1);
  until i>7;
end;

Procedure ValidateT1135SectionAdata(RetNo:Integer;Fno:Integer); //20160314 Igor
Var i:Integer;s:String;
Begin
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

Procedure ValidateT1135SectionBdata(RetNo:Integer;Fno:Integer); //20160314 Igor
Var i:Integer;s:String;
  Cnt:Integer;
Begin
  Cnt:=0;  //count entries in section B
  i:=1;
  Repeat
    If (FetchElmFNo(RetNo,FNo,i*10001)>'') then Cnt:=Cnt+1;
    Inc(i,1);
  until i>7;
  If Cnt=0 then SaveDiagnostic(RetNo,'T1135',10001,'E-T1135-Specified foreign property has been divided into 7 categories. At least one row must be fully completed in one of the 7 tables provided');
end;

//20180315
Procedure ValidateNR4Det(RetNo:Integer;Fno:Integer;FInst:String); //20160314 Igor
Var FrmNm:String;
begin
  If (Ret[RetNo].FrmHasData[FNo] = True)
  then
  Begin
   FrmNm:='NR4DET'+Finst;
   If FetchElmFNo(RetNo,FNo,2)='' then SaveDiagnostic(RetNo,FrmNm,2,'E-NR4-Enter Recipient code');
   If FetchElmFNo(RetNo,FNo,3)='' then SaveDiagnostic(RetNo,FrmNm,3,'E-NR4-Enter Country code');
   If FetchElmFNo(RetNo,FNo,4)='' then SaveDiagnostic(RetNo,FrmNm,4,'W-NR4-Enter Payer Id');
   If FetchElmFNo(RetNo,FNo,5)='' then SaveDiagnostic(RetNo,FrmNm,5,'E-NR4-Recipient Id number (Foreign/Canadian tax id/SIN');
   If FetchElmFNo(RetNo,FNo,6)='' then SaveDiagnostic(RetNo,FrmNm,6,'E-NR4-Enter Income code');
   If FetchElmFNo(RetNo,FNo,7)='' then SaveDiagnostic(RetNo,FrmNm,7,'E-NR4-Enter Currency code');
   If Vl(FetchElmFNo(RetNo,FNo,8))<=0 then SaveDiagnostic(RetNo,FrmNm,8,'W-NR4-Enter Gross Income');
   If Vl(FetchElmFNo(RetNo,FNo,9))<=0 then SaveDiagnostic(RetNo,FrmNm,9,'W-NR4-Enter Tax witheld');

   If FetchElmFNo(RetNo,FNo,16)='' then SaveDiagnostic(RetNo,FrmNm,16,'E-NR4-Enter Recipient Name');
   If FetchElmFNo(RetNo,FNo,22)='' then SaveDiagnostic(RetNo,FrmNm,22,'E-NR4-Enter Street Address');
   If FetchElmFNo(RetNo,FNo,24)='' then SaveDiagnostic(RetNo,FrmNm,24,'E-NR4-Enter City');
   If FetchElmFNo(RetNo,FNo,25)='' then SaveDiagnostic(RetNo,FrmNm,25,'E-NR4-Enter Province');
   If FetchElmFNo(RetNo,FNo,26)='' then SaveDiagnostic(RetNo,FrmNm,26,'E-NR4-Enter Postal code');
  End;
end;

//20260817 Alex >>>
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

procedure ValidateT5013Slips(RetNo: Integer; Fno:Integer; FInst: String);
Var j,k:integer; FName: String;
Begin
  //k:=GetNumberofPartners(RetNo);
  //for j:=1 to k do
  // begin
   Fname:='T5013'+'#'+IntToStr(k);
   //FNo:=GetFormNo(FName);
   If Ret[RetNo].FrmHasData[Fno] then
   begin
    if FetchElmFNo(RetNo,FNo,30)='' then //no override)
    Begin
        if FetchElmFNo(RetNo,FNo,29)='' then  //use % share needs X
         SaveDiagnostic(RetNo,FName,29,Fname+' Slip - Please select Partner Share % for allocations');
    end;
    // check Atrisk amount Limited partners only
    if FetchElmFNo(RetNo,FNo,11)='0' then //if Limited partner
    begin
     if Vl(FetchElmFNo(RetNo,FNo,82))=0 then //no override)
       SaveDiagnostic(RetNo,Fname,82,'W-Please enter the At Risk amount for this limited partner');
    end;
   end;
 // end; //j loop
end;  //procedure

end.
