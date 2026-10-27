unit T4T5_2026calc;

interface

uses
  SysUtils, Vcl.ComCtrls;


//Function CalcCpp2(EmplAmount:Real):Real; //20260111
Function GetT4aFootNoteAmount(RetNo:Integer;FootNoteBox:String):Real; //20171210
Function GetT4aFootNote101(RetNo:Integer;FootNoteBox:String):Real;
//20170903
Function CalcCppPremium(PensEarnings:Real;CPPPeriods,TotPeriods:Integer):Real;
Function CalcEIPremium(Prv:String;EIEarnings:Real;EIPeriods,TotPeriods:Integer):Real;
//
Procedure CalcUsedFrm(RetNo: integer);
Procedure CalcMultiPageForm(RetNo: integer; FName: string);
Procedure CALCALL(RetNo: integer);

procedure EMPL(RetNo: integer; FName: String; FNo: integer);
procedure STATUS(RetNo: integer; FName: String; FNo: integer);
procedure T4(RetNo: integer; FName: String; FNo: integer);
procedure T4A(RetNo: integer; FName: String; FNo: integer);//20170126 igor
procedure T5(RetNo: integer; FName: String; FNo: integer); //20170126 igor

//20171219
procedure T4SUM(RetNo: integer; FName: String; FNo: integer);
procedure T4ASUM(RetNo: integer; FName: String; FNo: integer);
procedure T5SUM(RetNo: integer; FName: String; FNo: integer);

Procedure FldMEM(RetNo: integer; FName: String; FNo: integer); //????

Procedure FLDTAPE(RetNo: integer; FName: String;FNo: integer); //20220121 Igor

implementation

uses
  T4T5_2026Common, T4T5_2026, T4T5_2026Declare,
  T4T5_2026TrimStr,  //20170906
  vtTrimStr, vtShared, vtCommon, vtChild, vtMulti;

 Var
  //CppRate : real;
  PensEarnings,
  CPPIn,CppCalcd,CalcCPPAdj,
  EIEarnings,EIIn,EICalcd,CalcEIAdj : Real;

Procedure CalcUsedFrm(RetNo: integer);
Var
  i, FNo: Integer;
  FName: String;
  MyPageControl: TPageControl;
  MyTabSheet : TTabSheet;
begin
  FName := 'USEDFRM';
  FNo := GetFormNo(FName);
  if (FNo > 0) AND (GetChild(RetNo) <> nil) AND (GetChild(RetNo).Pages <> nil) then//20180102 Igor
    Try
      MyPageControl := GetChild(RetNo).Pages;
      LoadTv(RetNo, FName, FNo);
      with ret[RetNo].Frm[FNo] do
      begin
        For i := 1 to 30 do
          Strings[i] := '';
        For i := 0 to MyPageControl.PageCount - 1 do
        begin
          if I > 30 then
            Break;
          MyTabSheet := MyPageControl.Pages[i];
          Strings[i + 1] := MyTabSheet.Caption;
        end;
        Strings[31] := MyPageControl.ActivePage.Caption;
      end;
      SaveTv(RetNo, FName, FNo);
    Except
    end;
End;

Procedure CalcMultiPageForm(RetNo: integer; FName: string);
Var
  i, n: integer;
  Root: string[10];
begin
   n := GetFormMxPg(FName);
   Root := ExtractFormRootName(FName);
   If Root = 'PAGE_' then
   begin
     Calc(RetNo,FName);
     exit;
   end;
   For i:=1 to n do
     Calc(RetNo,Root+'_'+IntToStr(i)+ExtractFormInst(FName));
End;

//20170006
Procedure CALCALL(RetNo: integer);
begin
 Calc(RetNo,'EMPL'); //20171231

 RecalcAllSlips(RetNo,'T4');
 RecalcAllSlips(RetNo,'T4A');
 RecalcAllSlips(RetNo,'T5');
 //20171210
 Calc(RetNo,'T4SUM');
 Calc(RetNo,'T4ASUM');
 Calc(RetNo,'T5SUM');
 //Calc(RetNo,'CalcUsedFrm');//20180102 Igor
 //20171231
 //20180102 Igor>>>
 Calc(RetNo,'PRIVAT');
 Calc(RetNo,'NPADC');
 Calc(RetNo,'NPAD');
 Calc(RetNo, 'Invoice');
 Calc(RetNo, 'InvForms');
 CalcUsedFrm(RetNo);
 //20180102 Igor<<<
end;

procedure EMPL(RetNo: integer; FName: String; FNo: integer);
begin
   (*
    //IGOR
    Strings[T4_EMPL_NAME] := FetchElm(RetNo, 'EMPL', EMPL_EMPL_NAME);  //company name
    Strings[T4_ACCOUNT] := FetchElm(RetNo, 'EMPL', EMPL_ACCOUNTT4);  //T4 Account number
    Strings[T4_YEAR] := AppT4T5_2026.AppYear;  //T4 Account number
   *)

 LoadTv (RetNo, Fname, FNo);
 //20170903
 With Ret[Retno].Frm[Fno] do
 Begin
  if Strings[4]='' then Strings[4]:=OptRec.Prp_Prov;
  if Strings[6]='' then Strings[6]:='CAN';
  if Strings[17]='' then Strings[17]:='WIP';
  if Strings[39]='' then Strings[39]:='WIP';
  if Strings[40]='' then Strings[40]:='WIP';

  if Strings[42]='' then Strings[42]:='Y';  //20171225

  if Strings[20]='' then Strings[20]:='52';  //20180107
  Strings[21]:='1.40'; //20251219 //20251207 '1.40';  //of employees rate //20191230
  if Strings[21]='' then Strings[21]:='1.40'; //20260108

  //copy signing ifor from contact
  if UpperCase(Strings[42])='Y' then
  begin
   Strings[11]:=Strings[7];
   Strings[12]:=Strings[8];
   Strings[14]:=Strings[9];
   Strings[15]:=Strings[10];
   Strings[32]:=Strings[41];
  end;
 end;
 SaveTv (RetNo, Fname, FNo);
end;

//20180103
procedure STATUS(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   //FillHeader(RetNo,FNo,1,27,3);  //20111125
   Strings[1] := FetchElm(RetNo,'EMPL',1);
   Strings[3] := AppYear;
   //Strings[4] := Ret[RetNo].PrpStatus;
  // Strings[23]:= PRPStatusDescr[MyStrToInt(Ret[RetNo].PrpStatus)];
  // Strings[24]:= GetEFileConfirmationNo(RetNo);

   {
   Strings[15] :=OptRec.Prp_Name;
   Strings[16] :=OptRec.Prp_Street;
   Strings[17] :=OptRec.Prp_City;
   Strings[18] :=OptRec.Prp_Prov;
   Strings[19] :=OptRec.Prp_Postal;
   Strings[20] :=OptRec.Prp_Area+' '+OptRec.Prp_Tel;
   Strings[21] :=OptRec.Prp_Fax;
   }
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure FldMEM(RetNo: integer; FName: String; FNo: integer);
begin
 LoadTv (RetNo, Fname, FNo);

 SaveTv (RetNo, Fname, FNo);
end;

procedure T4(RetNo: integer; FName: String; FNo: integer); //20170126 igor

//Var CPP2:Real; //20250122
Begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[Fno]  do
  begin
   // xx:=Tv[19];   //debug to see the value of box 16 20250124
    //20170903
    Strings[1]:=FetchElm(RetNo,'EMPL',1);  //Employer's Name
    Strings[2]:=AppT4T5_2026.AppYear; //if Strings[2]='' then Strings[2]:='2016';
    Strings[5]:=FetchElm(RetNo,'EMPL',22);  //t4 Account number
    if Strings[6]='' then Strings[6]:=FetchElm(RetNo,'EMPL',4);  //province
    if Strings[102]='' then Strings[102]:=FetchElm(RetNo,'EMPL',20); //periods in year
    if Strings[101]='' then Strings[101]:=Strings[102]; //periods
      //If Strings[2]='2023' then strings[49]:=''; //201231 allow it but error unless paper filing
    if Strings[10]='' then Strings[10]:='00';
    if Strings[43]='' then Strings[43]:='CAN';  //20180106
     //Options  20180121 changed to No
    if Strings[111]='' then Strings[111]:='Y'; //auton CPP  //20181216
    if Strings[112]='' then Strings[112]:='Y'; // auto EI

    //20180121
    if (UpperCase(Strings[111])<>'Y')
    and (Tv[26]=0)
    and (Strings[8]='')
    then  //20180104
    Begin
     Tv[26]:= Tv[18]; //pensiable cpp earnings FieldByName('Box14').AsFloat;
     Tv[26]:=MinR(MaxCPPEarnings, Tv[26]);//FieldByName('Box26').AsFloat :=MinR(MaxCPPEarnings, FieldByName('Box26').AsFloat);
    End;

    if (UpperCase(Strings[112])<>'Y')
    And (Tv[25]=0)
    And (Strings[9]='')
    then  //20180104
     Begin
      Tv[25]:=Tv[18]; //20171223 ei earnings Pensianable earnings //FieldByName('Box24').AsFloat :=FieldByName('Box14').AsFloat;
      Tv[25]:=MinR(MaxEIEarnings,Tv[25]);//FieldByName('Box24').AsFloat :=MinR(MaxEIEarnings,FieldByName('Box24').AsFloat);
     end;
   //-------------------------
    //20171223
    //20211218
    PensEarnings:=Tv[26]; //20250210
    if UpperCase(Strings[111])='Y' then
    begin
     CppCalcd:=CalcCPPPremium(PensEarnings,MyStrToInt(Strings[101]),MyStrToInt(Strings[102])); //20260110
      //CalcCPPPremium(PensEarnings,MyStrToInt(Strings[101]),MyStrToInt(Strings[102])); //20250123
     Tv[19]:=CppCalcd; //Box 16 //20250123 //Tv[19]:=Tv[106];
     Tv[47]:=CalcCPP2(Tv[18]); //Cpp2; //Box 16A //20250123 //Tv[19]:=Tv[106];
    end;
    if UpperCase(Strings[112])='Y' then
    begin
      Tv[109]:=CalcEiPremium(Strings[6],EIEarnings, MyStrtoInt(Strings[101]),MyStrtoInt(Strings[102]));  //20250123
      Tv[21]:=Tv[109];  //20250123
    end;

    (* converted to button
    //apply difference to tax  //20180121
    if UpperCase(Strings[113])='Y' then
    Begin
      If UpperCase(Strings[111])<>'Y' then Tv[24]:=Tv[24] + Tv[107];
      If UpperCase(Strings[112])<>'Y' then Tv[24]:=Tv[24] + Tv[110];
    End;
    *)

   (* //20250123
    //net pay
    Tv[104]:=Tv[18] //Box14 empl inc
            -Tv[19]  //'Box16 CPP
            -Tv[47]  //Box 16A //20250123
            -Tv[20] //Box17 QPP
            -Tv[21]  //Box18 EI
            -Tv[22]  //Box20 RPP
            -Tv[24] //Box22 Tax deducted
            -Tv[27] //Box44 Union dues
            -Tv[28]; //Box46 Char donations
   *)

     //[18] is Empl income
     if UpperCase(Strings[111])='Y' then  //20180104  //if autocalc cpp
     Begin
      Tv[26]:= Tv[18]; //pensiable cpp earnings FieldByName('Box14').AsFloat;
      Tv[26]:=MinR(CPP2MaxCppEarnings, Tv[26]); //20241220 //MinR(MaxCPPEarnings, Tv[26]);

      If (Tv[18]>MaxCPPEarnings) then //and (Tv[18]<CPP2MaxCppEarnings) then //20241221
      begin
       Tv[47]:=MinR(MaxCpp2,(Tv[18]-MaxCPPEarnings)*4/100); //20251216
       //Tv[48] for QPP ???
      end
      Else
      begin
       Tv[47]:=0;  //20241221
       //qpp
      end;
     end;

     if UpperCase(Strings[112])='Y' then  //20180104     //autocalc ei
     Begin
      Tv[25]:=Tv[18]; //20171223 ei earnings Pensianable earnings //FieldByName('Box24').AsFloat :=FieldByName('Box14').AsFloat;
      Tv[25]:=MinR(MaxEIEarnings,Tv[25]);//FieldByName('Box24').AsFloat :=MinR(MaxEIEarnings,FieldByName('Box24').AsFloat);
     end;

    //exempt
    If Strings[8]>'' then //CPP exempt box28A
     Tv[26]:=0; //Box26

    If Strings[8]>'' then Tv[47]:=0;  //cpp2 //20250127


    If Strings[9]>'' then //Box28B ei exempt
      Tv[25]:=0; //Box24

    If Strings[44]>'' then //Box28C
    begin
     Tv[45]:=0; //Box55
     Tv[46]:=0; //Box56
    end;

    //calc adjustments
    PensEarnings := Tv[26]; //20180105 Tv[18]; //FieldByName('Box14').AsFloat;
    If Tv[26]>0 then //FieldByName('Box26').AsFloat >0 then
      PensEarnings := Tv[26]; //FieldByName('Box26').AsFloat;
    PensEarnings := MinR(MaxCPPEarnings,PensEarnings);
    If Strings[8]>'' then PensEarnings :=0; //if cppexempt
    CppIn := Tv[19] + Tv[47]; //Add 16A //20250121
    CppCalcd :=CalcCPPPremium(PensEarnings,MyStrToInt(Strings[101]),MyStrToInt(Strings[102]));

    {
    //20260111
    Tv[105]:=CppIn;   //includes box 16 and 16a normalCPP plus CPP2 box
    Tv[106]:=CppCalcd+CalcCpp2(Tv[18]); // GetCMinR(MaxCpp2,(Tv[18]-MaxCPPEarnings)*4/100);
      //CppCalcd; //+CalcCpp2(Tv[18]);   //includes cpp2  //20250127
    }

    Tv[105]:=CppIn;   //includes box 16 and 16a normalCPP plus CPP2 box
    Tv[106]:=CppCalcd; //+CalcCpp2(Tv[18]);   //includes cpp2  //20250127

    If Strings[8]='' then Tv[106]:=Tv[106]+CalcCpp2(Tv[18]); //20250127    //if cpp exempt
    CalcCPPAdj := Tv[105]-Tv[106]; //CppIn - CppCalcd - CalcCpp2(Tv[18]);  //20250122
    Tv[107]:=CalcCPPAdj;

    EIEarnings := Tv[25]; // FieldByName('Box24').AsFloat;
    If Strings[0]>'' then EIEarnings :=0; //UpperCase(FieldByName('Box28B').AsString) = 'X' then EIEarnings :=0;
    EIIn := Tv[21]; //20250123
    EICalcd := CalcEiPremium(Strings[6],EIEarnings, MyStrtoInt(Strings[101]),MyStrtoInt(Strings[102]));    //strings[6] = prov
    if UpperCase(Strings[112])='Y' then //20250123
    Begin
     Tv[21]:=EICalcd;  //20250123
     EIIn := Tv[21]; //20250123
    end;
    //EICalcd := CalcEiPremium(FieldByName('Province').AsString,EIEarnings, MyStrToInt(FieldByName('UIPeriods').AsString),
    CalcEIAdj := EIIn - EICalcd;
    Tv[108]:=EiIn;
    Tv[109]:=EiCalcd;
    Tv[110]:=CalcEiAdj;


   //20250123
    //net pay
    Tv[104]:=Tv[18] //Box14 empl inc
            -Tv[19]  //'Box16 CPP
            -Tv[47]  //Box 16A //20250123
            -Tv[20] //Box17 QPP
            -Tv[21]  //Box18 EI
            -Tv[22]  //Box20 RPP
            -Tv[24] //Box22 Tax deducted
            -Tv[27] //Box44 Union dues
            -Tv[28]; //Box46 Char donations

    //20250210 CZ
     CppCalcd:=CalcCPPPremium(PensEarnings,MyStrToInt(Strings[101]),MyStrToInt(Strings[102])); //20250123
     If Strings[8]>'' then CPPCalcd:=0; //cpp exempt
     Tv[105]:=Tv[19]+Tv[47]; //CppCalcd+CalcCPP2(Tv[18]);
     Tv[107]:=Tv[105]-Tv[106];

     //--------------------
    (*
     //20250124 Igor >>>
    if UpperCase(Strings[111])='Y' then
    begin
     CppCalcd:=CalcCPPPremium(PensEarnings,MyStrToInt(Strings[101]),MyStrToInt(Strings[102])); //20250123
     Tv[19]:=CppCalcd; //Box 16 //20250123 //Tv[19]:=Tv[106];
     If Strings[8]='' then  //20250137
        Tv[47]:=CalcCPP2(Tv[18]); //Cpp2; //Box 16A //20250123 //Tv[19]:=Tv[106];
    end;
    *)

    if UpperCase(Strings[112])='Y' then
    begin
      Tv[109]:=CalcEiPremium(Strings[6],EIEarnings, MyStrtoInt(Strings[101]),MyStrtoInt(Strings[102]));  //20250123
      Tv[21]:=Tv[109];  //20250123
    end;
  end;
 // Ret[RetNo].Changed := True;   //20250124  MUST use in T4 slips as TV[19] is lost
  SaveTv(RetNo,FName,FNo);
End;

procedure T4A(RetNo: integer; FName: String; FNo: integer); //20170126 igor
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[Fno]  do
 begin
    //20170910
    Strings[2]:=FetchElm(RetNo,'EMPL',1);  //Employer's Name
    Strings[1]:=AppT4T5_2026.AppYear; //if Strings[2]='' then Strings[2]:='2016';
    Strings[3]:=FetchElm(RetNo,'EMPL',24);  //t4A Account number
    if Strings[13]='' then Strings[13]:='CAN'; //20180106

    //remove amounts from slip unless thre is a foot code
    i:=20;
    Repeat
     if Strings[i]='' then Tv[i+1]:=0;
     Inc(i,2);
    Until i>42;

    {IGOR
    Strings[T4A_EMPL_NAME] := FetchElm(RetNo, 'EMPL', EMPL_EMPL_NAME);  //company name
    Strings[T4A_ACCOUNT] := FetchElm(RetNo, 'EMPL', EMPL_ACCOUNTT4A);  //t4a Account number
    Strings[T4A_YEAR] := AppT4T5_2026.AppYear;
    }
 end;
 SaveTv(RetNo,FName,FNo);
End;

procedure T5(RetNo: integer; FName: String; FNo: integer); //20170126 igor
Var EmplFNo:Integer;
begin
   {IGOR
    Strings[T5_YEAR] := AppT4T5_2026.AppYear;  //company name
    Strings[T5_EMPL_NAME] := FetchElm(RetNo, 'EMPL', EMPL_EMPL_NAME);  //company name
    Strings[T5_EMPL_STREET] := FetchElm(RetNo, 'EMPL', EMPL_STREET);   //Street
    Strings[T5_EMPL_CITY] := FetchElm(RetNo, 'EMPL', EMPL_CITY);       //City
    Strings[T5_EMPL_PROV_POSTAL] := FetchElm(RetNo, 'EMPL', EMPL_PROV)+' '+
                                    FetchElm(RetNo, 'EMPL', EMPL_POSTAL)+' '+
                                    FetchElm(RetNo, 'EMPL', EMPL_COUNTRY); //Province Postal and Country
   }

  //20170910
 With Ret[RetNo].Frm[Fno]  do
 begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[Fno]  do
  begin
   //if Strings[1]='' then  //20181220
   Strings[1]:=AppT4T5_2026.AppYear;
   if Strings[10]='' then Strings[10]:='O';
   if Strings[12]='' then Strings[12]:='1';
   If Strings[22]='' then Strings[22]:=FetchElm(RetNo,'EMPL',4);  //province
   if Strings[1]='2023' then Strings[45]:=''; //20231229
   

   //payer
   EmplFNo:=GetFormNo('EMPL');
   Strings[24]:=FetchElmFNo(RetNo,EMPLFNo,1);  //payer name
   Strings[25]:=FetchElmFNo(RetNo,EMPLFNo,2);  //street
   Strings[26]:=FetchElmFNo(RetNo,EMPLFNo,3);  //City
   Strings[27]:=FetchElmFNo(RetNo,EMPLFNo,4);  //Prov
   Strings[28]:=FetchElmFNo(RetNo,EMPLFNo,5)+' '+FetchElmFNo(RetNo,EMPLFNo,6); //postal and country

   if Strings[32]='' then Strings[32]:='CAN';  //20180106

   //calcs 20181215
   Tv[3]:=Tv[2]*1.38; //Tv[3]:=Box25
   Tv[4]:=RoundToTwo(Tv[3] * 15.0198/100); //RoundToTwo(Tv[2] * 20.73/100); //tv[4]=Box26
   //20161120
   Tv[8]:=Tv[7]*1.15; //20191220//Tv[7]*1.16; //20181215  Tv[8]=Box 11 /
   Tv[9]:=RoundToTwo(Tv[7]*10.38462/100);//20191220 //Tv[9]=Box12//RoundToTwo(Tv[7]*12.31/100); //RoundToTwo(Tv[8]*10.0313/100); //Tv[9]=Box12//RoundToTwo(Tv[7]*12.31/100);
   If (Strings[12]='3') or (Strings[12]='5') then // Corp or Goverment //20171215
   begin
    Tv[3]:=0; //Table1.FieldByName('Box25').AsFloat :=0;
    Tv[4]:=0; //Table1.FieldByName('Box26').AsFloat :=0;
    Tv[8]:=0; //Table1.FieldByName('Box11').AsFloat :=0;
    Tv[9]:=0; //Table1.FieldByName('Box12').AsFloat :=0;
   end;

  End;
 end;
 SaveTv(RetNo,FName,FNo);
end;

//20170903
Function CalcCppPremium(PensEarnings:Real;CPPPeriods,TotPeriods:Integer):Real;
Var GrossPerPeriod,ExemptPerPeriod, CPPPerPeriod:Real;
ProrBasicExemption:real;
 Begin
  ExemptPerPeriod := BasicCPPExempt/TotPeriods;  //20171223
  ProrBasicExemption := ExemptPerPeriod * CPPPeriods;
  result := MaxR(0,PensEarnings - ProrBasicExemption) * CppRate;
  if Abs(result - MaxCppPremium) <0.02 then result := MaxCppPremium;
  Result:= MinR(Result,MaxCppPremium);
end;

{
Function CalcCpp2(EmplAmount:Real):Real;
Var LowerCppEarnings,excess:Real;
begin
 if EmplAmount<=71300 then
   begin result:=0;exit;end
 else
 begin
   excess:=EmplAmount-81200;
   result:=MaxR(0,excess * 4/100);
 end;
end;
}

Function CalcEIPremium(Prv:String;EIEarnings:Real;EIPeriods,TotPeriods:Integer):Real;
Var x: real;
begin
 If EiEarnings < 0.02 then begin Result:=0;Exit;end;
 //If EiEarnings < CfgRec.Opr_EIExmt then begin result :=0;exit;end;
 If UpperCase(Prv) <>'QC' then
 begin
 Result := EiEarnings * EiRate; {required}
 Result :=MinR(MaxEiPremium,result);
 end
 Else  //QC
 begin
   Result :=EiEarnings * QppEiRate; //2017209 1.39/100;
   Result :=MinR(QPPMaxEiPremium,result); //MinR(587.52,result);
 end;
end;


//20171210 CON
procedure T4SUM(RetNo: integer; FName: String; FNo: integer);
Var i:Integer;EmployerEi:Real;
begin
// EmployerEi:=Vl(FetchElm(RetNo,'EMPL',21)); //20171228  //20180222
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[Fno]  do
 begin
  {now store elms in form}
   Strings[1]:=FetchElm(RetNo,'EMPL',22);//StoreElm(RetNo,FNo,1,EmplRec.Bus_Number);
   Strings[3]:=FetchElm(RetNo,'EMPL',1);//StoreElm(RetNo,FNo,3,EmplRec.Empl_Name);
  // Strings[2]:=FetchElm(RetNo,'EMPL',2);//StoreElm(RetNo,FNo,2,EmplRec.TaxCentre);
   Strings[4]:=FetchElm(RetNo,'EMPL',2);//StoreElm(RetNo,FNo,4,EmplRec.Street);
   Strings[5]:=FetchElm(RetNo,'EMPL',3)+' '+FetchElm(RetNo,'EMPL',4);  //20180103 //city and Prov
   Strings[6]:=FetchElm(RetNo,'EMPL',5) + ' '+FetchElm(RetNo,'EMPL',6);  //20180106 //Postal and country EmplRec.Postal);

   //StoreElm(RetNo,FNo,24,' ');  {US?}

    Strings[7]:=IntToStr(CountSlips(RetNo,'T4')); //StoreElm(RetNo,FNo,7,IntToStr(NumSlips));
    Tv[8]:=TotMultiple(RetNo,'T4',18); //StoreElm(RetNo,FNo,8,JustRight(FormatFloat('########.00',TotBox14),14));
    Tv[9]:=TotMultiple(RetNo,'T4',22); //StoreElm(RetNo,FNo,9,JustRight(FormatFloat('########.00',TotBox20),14));
    Tv[10]:=TotMultiple(RetNo,'T4',23); //StoreElm(RetNo,FNo,10,JustRight(FormatFloat('########.00',TotBox52),14));
    //StoreElm(RetNo,FNo,11,JustRight(FormatFloat('########.00',TotBox24),14));
    Tv[12]:=TotMultiple(RetNo,'T4',19); //StoreElm(RetNo,FNo,12,JustRight(FormatFloat('########.00',TotBox16),14));
    Tv[13]:=Tv[12]; //TotMultiple(RetNo,'T4',12); //StoreElm(RetNo,FNo,13,JustRight(FormatFloat('########.00',EmployerCPP),14));
    Tv[14]:=TotMultiple(RetNo,'T4',21); //StoreElm(RetNo,FNo,14,JustRight(FormatFloat('########.00',TotBox18),14));
    Tv[15]:=Tv[14]*Vl(FetchElm(RetNo,'EMPL', 21)); //20191221 //Tv[14]*1.40;  //20171230
    //Tv[15]:=TotMultiple(RetNo,'T4',25) * EmployerEi/100; //20171228
    //Tv[15]:=TotMultiple(RetNo,'T4',18) * EmployerEi/100; //20171228
   // Tv[15]:=TotMultiple(RetNo,'T4',20); //StoreElm(RetNo,FNo,15,JustRight(FormatFloat('########.00',EmployerEI),14));
    Tv[16]:=TotMultiple(RetNo,'T4',24); //StoreElm(RetNo,FNo,16,JustRight(FormatFloat('########.00',TotBox22),14));

    Tv[25]:=TotMultiple(RetNo,'T4',47); //20231217
    Tv[30]:=TotMultiple(RetNo,'T4',47); //20231217 not 48 //20241221

    Tv[17]:=Tv[12]+Tv[13]+Tv[14]+Tv[15]+Tv[16]
            +Tv[25]+Tv[30];  //20231217

    Tv[18]:=Vl(FetchElm(RetNo,'EMPL',23));//StoreElm(RetNo,FNo,18,JustRight(FormatFloat('########.00',T4Remit),14));
    Tv[20]:=Tv[17]-Tv[18];
    //StoreElm(RetNo,FNo,37,JustRight(FormatFloat('########.00',SubTot),14));
    if Tv[20]<0 then
     begin Tv[21]:=Abs(Tv[20]);Tv[22]:=0;end
    Else
     begin Tv[21]:=0;Tv[22]:=Tv[20];end;

    {
    StoreElm(RetNo,FNo,20,JustRight(FormatFloat('########.00',Diff),14));
    StoreElm(RetNo,FNo,21,JustRight(FormatFloat('########.00',OverPay),14));
    StoreElm(RetNo,FNo,22,JustRight(FormatFloat('########.00',Balance),14));
    }
   //??? StoreElm(RetNo,FNo,23,JustRight(FormatFloat('########.00',EmplRec.EncloseT4),14));

   Strings[27]:=FetchElm(RetNo,'EMPL',29);//StoreElm(RetNo,FNo,27,EmplRec.PropSin1);
   Strings[28]:=FetchElm(RetNo,'EMPL',30);//StoreElm(RetNo,FNo,28,EmplRec.PropSin2);
   Strings[29]:=FetchElm(RetNo,'EMPL',11)+' '+FetchElm(RetNo,'EMPL',12);//StoreElm(RetNo,FNo,29,EmplRec.FirstName+' '+EmplRec.LastName);
   Strings[31]:=FetchElm(RetNo,'EMPL',14); //StoreElm(RetNo,FNo,31,EmplRec.AreaCode);
   Strings[26]:=FetchElm(RetNo,'EMPL',15); //StoreElm(RetNo,FNo,26,EmplRec.Telephone);
   Strings[2]:=FetchElm(RetNo,'EMPL',32); // //StoreElm(RetNo,FNo,2,EmplRec.Extension);  ??? need field
 //  StoreElm(RetNo,FNo,33,EmplRec.AuthName);
   Strings[35]:=FetchElm(RetNo,'EMPL',13); //StoreElm(RetNo,FNo,35,EmplRec.Position);
   if Strings[34]='' then Strings[34]:=FormatDateTime('yyyy-mm-dd',Date);
   //StoreElm(RetNo,FNo,36,IntToStr(WhichCopy)); ??
 end;
 SaveTv(RetNo,FName,FNo);
End;

procedure T4ASUM(RetNo: integer; FName: String; FNo: integer);
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[Fno]  do
 begin
  {now store elms in form}
   Strings[1]:=FetchElm(RetNo,'EMPL',22);//StoreElm(RetNo,FNo,1,EmplRec.Bus_Number);
   Strings[3]:=FetchElm(RetNo,'EMPL',1);//StoreElm(RetNo,FNo,3,EmplRec.Empl_Name);
  // Strings[2]:=FetchElm(RetNo,'EMPL',2);//StoreElm(RetNo,FNo,2,EmplRec.TaxCentre);
   Strings[4]:=FetchElm(RetNo,'EMPL',2);//StoreElm(RetNo,FNo,4,EmplRec.Street);
   Strings[5]:=FetchElm(RetNo,'EMPL',3)+' '+FetchElm(RetNo,'EMPL',4); //+' '+FetchElm(RetNo,'EMPL',5);//20180103
   //;//StoreElm(RetNo,FNo,5,EmplRec.City);
   Strings[6]:=FetchElm(RetNo,'EMPL',5)+ ' '+FetchElm(RetNo,'EMPL',6);//20180106

   //StoreElm(RetNo,FNo,24,' ');  {US?}

    Strings[7]:=IntToStr(CountSlips(RetNo,'T4A')); //StoreElm(RetNo,FNo,7,IntToStr(NumSlips));
    Tv[8]:=TotMultiple(RetNo,'T4A',14); //StoreElm(RetNo,FNo,8,JustRight(FormatFloat('########.00',TotBox16),14));
    Tv[9]:=TotMultiple(RetNo,'T4A',15); //StoreElm(RetNo,FNo,9,JustRight(FormatFloat('########.00',TotBox18),14));
    Tv[10]:=TotMultiple(RetNo,'T4A',18); //StoreElm(RetNo,FNo,10,JustRight(FormatFloat('########.00',TotBox20),14));
    Tv[11]:=TotMultiple(RetNo,'T4A',16); //StoreElm(RetNo,FNo,11,JustRight(FormatFloat('########.00',TotBox24),14));
    Tv[33]:=TotMultiple(RetNo,'T4A',19);  //20180105 //box 48 //StoreElm(RetNo,FNo,33,JustRight(FormatFloat('########.00',TotBox48),14));
    //???
    Tv[13]:=GetT4aFootNoteAmount(RetNo,'028'); //StoreElm(RetNo,FNo,13,JustRight(FormatFloat('########.00',TotBox28),14));
    Tv[14]:=GetT4aFootNoteAmount(RetNo,'030'); //StoreElm(RetNo,FNo,14,JustRight(FormatFloat('########.00',TotBox30),14));
    Tv[15]:=GetT4aFootNoteAmount(RetNo,'032'); //StoreElm(RetNo,FNo,15,JustRight(FormatFloat('########.00',TotBox32),14));
    Tv[16]:=GetT4aFootNoteAmount(RetNo,'034'); //StoreElm(RetNo,FNo,16,JustRight(FormatFloat('########.00',TotBox34),14));
    Tv[38]:=GetT4aFootNoteAmount(RetNo,'040'); //StoreElm(RetNo,FNo,38,JustRight(FormatFloat('########.00',TotBox40),14));
    Tv[39]:=GetT4aFootNoteAmount(RetNo,'042'); //StoreElm(RetNo,FNo,39,JustRight(FormatFloat('########.00',TotBox42),14));

    Tv[36]:=GetT4AFootNote101(RetNo,'101');  //StoreElm(RetNo,FNo,36,JustRight(FormatFloat('########.00',TotBox101),14));

    Tv[17]:=TotMultiple(RetNo,'T4A',17); //inc tax deducted
    Tv[18]:=Vl(FetchElm(RetNo,'EMPL',25));  //remit
    Tv[19]:=Tv[17]-Tv[18];
    if Tv[19]<0  then
    Begin
      Tv[20]:=Abs(Tv[19]);
      Tv[21]:=0;
    end
    Else
    Begin
      Tv[20]:=0;
      Tv[21]:=Tv[19];
    end;

    {
    TotMultiple(RetNo,'T4A',16); //StoreElm(RetNo,FNo,17,JustRight(FormatFloat('########.00',TotDed),14));
    StoreElm(RetNo,FNo,18,JustRight(FormatFloat('########.00',T4ARemit),14));
    StoreElm(RetNo,FNo,19,JustRight(FormatFloat('########.00',Diff),14));
    StoreElm(RetNo,FNo,20,JustRight(FormatFloat('########.00',OverPay),14));
    StoreElm(RetNo,FNo,21,JustRight(FormatFloat('########.00',Balance),14));
    StoreElm(RetNo,FNo,22,JustRight(FormatFloat('########.00',T4AEnclosed),14));
   }

   Strings[23]:=FetchElm(RetNo,'EMPL',26); //StoreElm(RetNo,FNo,23,EmplRec.RppNum1);
   Strings[24]:=FetchElm(RetNo,'EMPL',27); //StoreElm(RetNo,FNo,24,EmplRec.RppNum2);
   Strings[25]:=FetchElm(RetNo,'EMPL',28); //StoreElm(RetNo,FNo,25,EmplRec.RppNum3);
   Strings[26]:=FetchElm(RetNo,'EMPL',29); //StoreElm(RetNo,FNo,26,EmplRec.PropSin1);
   Strings[27]:=FetchElm(RetNo,'EMPL',30); //StoreElm(RetNo,FNo,27,EmplRec.PropSin2);

   //20180103
   Strings[29]:=FetchElm(RetNo,'EMPL',7);
   Strings[30]:=FetchElm(RetNo,'EMPL',8);
   Strings[31]:=FetchElm(RetNo,'EMPL',9);
   Strings[32]:=FetchElm(RetNo,'EMPL',10);
   Strings[28]:=FetchElm(RetNo,'EMPL',41);

   if Strings[34]='' then Strings[34]:=FormatDateTime('yyyy-mm-dd',Date);
   Strings[35]:=FetchElm(RetNo,'EMPL',13); //StoreElm(RetNo,FNo,35,EmplRec.Position);
  end;
 SaveTv(RetNo,FName,FNo);
end;

procedure T5SUM(RetNo: integer; FName: String; FNo: integer);
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[Fno]  do
 begin
   Strings[2]:=AppYear;
   Strings[11]:=FetchElm(RetNo,'EMPL',31);//StoreElm(RetNo,FNo,1,EmplRec.Bus_Number);
   Strings[4]:=FetchElm(RetNo,'EMPL',1);//StoreElm(RetNo,FNo,3,EmplRec.Empl_Name);
  // Strings[2]:=FetchElm(RetNo,'EMPL',2);//StoreElm(RetNo,FNo,2,EmplRec.TaxCentre);
   Strings[5]:=FetchElm(RetNo,'EMPL',2);//StoreElm(RetNo,FNo,4,EmplRec.Street);
   Strings[7]:=FetchElm(RetNo,'EMPL',3);//StoreElm(RetNo,FNo,5,EmplRec.City);
   Strings[8]:=FetchElm(RetNo,'EMPL',4); //StoreElm(RetNo,FNo,6,EmplRec.Prov
   Strings[9]:=FetchElm(RetNo,'EMPL',5);//EmplRec.Postal);

   if UpperCase(FetchElm(RetNo,'EMPL',35))='Y' then
    Strings[44]:='X'  //20230303
   Else
    Strings[44]:='';  //20230303

   //20180116
   if UpperCase(FetchElm(RetNo,'EMPL',36))='Y' then
   begin
    Strings[12]:='X';
    Strings[13]:='';
   end
   Else
   begin
    Strings[12]:='';
    Strings[13]:='X';
   end;


  {
  If EmplRec.T5_Before = 'N' then
  begin
   StoreElm(RetNo,FNo,12,'');
   StoreElm(RetNo,FNo,13,'X');
  end
  Else
  Begin
   StoreElm(RetNo,FNo,12,'X');
   StoreElm(RetNo,FNo,13,'');
  end;
  }
  Strings[14]:='X'; //StoreElm(RetNo,FNo,14,'X');   //lang
  Tv[22]:=TotMultiple(RetNo,'T5',7); //StoreElm(RetNo,FNo,22,JustRight(FormatFloat('########.00',T5Sum.TotBox10),14));
  Tv[23]:=TotMultiple(RetNo,'T5',8); //StoreElm(RetNo,FNo,23,JustRight(FormatFloat('########.00',T5Sum.TotBox11),14));
  Tv[24]:=TotMultiple(RetNo,'T5',9); //StoreElm(RetNo,FNo,24,JustRight(FormatFloat('########.00',T5Sum.TotBox12),14));
  Tv[25]:=TotMultiple(RetNo,'T5',5); //StoreElm(RetNo,FNo,25,JustRight(FormatFloat('########.00',T5Sum.TotBox13),14));

  //20180103
  Tv[26]:=TotBox(RetNo,'14'); //box14
  Tv[27]:=TotBox(RetNo,'15');
  Tv[28]:=TotBox(RetNo,'16');
  Tv[30]:=TotBox(RetNo,'17');
  Tv[33]:=TotBox(RetNo,'19');

  //box
  Tv[10]:=TotMultiple(RetNo,'T5',3); //StoreElm(RetNo,FNo,10,JustRight(FormatFloat('########.00',T5Sum.TotBox25),14));
  Tv[21]:=TotMultiple(RetNo,'T5',4); //StoreElm(RetNo,FNo,21,JustRight(FormatFloat('########.00',T5Sum.TotBox26),14));

  Tv[31]:=TotMultiple(RetNo,'T5',6); //StoreElm(RetNo,FNo,31,JustRight(FormatFloat('########.00',T5Sum.TotBox18),14));
  Tv[34]:=TotMultiple(RetNo,'T5',2); //StoreElm(RetNo,FNo,34,JustRight(FormatFloat('########.00',T5Sum.TotBox24),14));
  //20180104
  Tv[36]:=Vl(FetchElm(RetNo,'EMPL',37)); //StoreElm(RetNo,FNo,36,JustRight(FormatFloat('########.00',EmplRec.T5_UnclDiv),14));
  Tv[37]:=TotMultiple(RetNo,'EMPL',38); //StoreElm(RetNo,FNo,37,JustRight(FormatFloat('########.00',EmplRec.T5_UnclTax),14));

  Strings[38]:=IntToStr(CountSlips(RetNo,'T5')); //StoreElm(RetNo,FNo,38,JustRight(IntToStr(T5Sum.NumSlips),14));
  //ContactY;
  Strings[39]:=FetchElm(RetNo,'EMPL',11)+' '+FetchElm(RetNo,'EMPL',12); //StoreElm(RetNo,FNo,39,EmplRec.FirstName+' '+EmplRec.LastName);
  Strings[40]:=FetchElm(RetNo,'EMPL',14); //,EmplRec.AreaCode);
  Strings[41]:=FetchElm(RetNo,'EMPL',15); //StoreElm(RetNo,FNo,41,EmplRec.Telephone);
  Strings[42]:=FetchElm(RetNo,'EMPL',13); //EmplRec.Position);
  if Strings[43]='' then Strings[43]:=FormatDateTime('yyyy-mm-dd',Date);
 end;
 SaveTv(RetNo,FName,FNo);
End;

Function GetT4aFootNoteAmount(RetNo:Integer;FootNoteBox:String):Real;
Var i,j:Integer;T4AFNo:Integer;
Begin
  Result:=0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    T4AFNo:=Frec.FormNo;
    j:=20; //footnote box      //20180104
    If FRec.FormName = 'T4A' then
    begin
      repeat
       if FetchElmFNo(RetNo,T4AFNo,j)=FootnoteBox then result:=Result+Vl(FetchElmFNo(RetNo,T4AFNo,j+1));
       Inc(j,2);
      until j>42;
    end;
  end;  //i
end;

Function GetT4aFootNote101(RetNo:Integer;FootNoteBox:String):Real;
//101 cathes all boxes above 101 and it goes to T4Asum  +TotBox26+TotBox27+TotBox46;
Var i,j:Integer;T4AFNo:Integer;
Begin
  Result:=0;
  for I := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[I];
    T4AFNo:=Frec.FormNo;
    j:=20; //footnote box
    If FRec.FormName = 'T4A' then
    begin
      repeat
       //20180105
       //if (FetchElmFNo(RetNo,T4AFNo,j)>FootnoteBox)
       If (Length(FootNoteBox)=3)
       Or (FetchElmFNo(RetNo,T4AFNo,j)='026')
       Or (FetchElmFNo(RetNo,T4AFNo,j)='027')
       Or (FetchElmFNo(RetNo,T4AFNo,j)='046')
       then result:=Result+Vl(FetchElmFNo(RetNo,T4AFNo,j+1));
       Inc(j,2);
      until j>42;
    end;
  end;  //i
end;

Procedure FLDTAPE(RetNo: integer; FName: String;FNo: integer); //20220121 Igor
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
    //If UpperCase(LeftStr(Strings[121],3))='MED' then begin Strings[123]:='';Strings[124]:='X';end;
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

(*
//20170903
Procedure CalcAdjustments;
Begin
 With Table1 do
 begin
  Table1.Edit;
  Table1.FieldByName('AdjCPP').AsFloat := 0;
  Table1.FieldByName('AdjUI').AsFloat  := 0;
  Table1.FieldByName('AdjTax').AsFloat  := 0;

  PensEarnings := FieldByName('Box14').AsFloat;
  If FieldByName('Box26').AsFloat >0 then
    PensEarnings := FieldByName('Box26').AsFloat;
  PensEarnings := MinR(MaxCPPEarnings,PensEarnings);
  If UpperCase(FieldByName('Box28A').AsString) = 'X' then
    PensEarnings :=0;
  CppIn := FieldByName('Box16').AsFloat;
  CppCalcd :=CalcCPPPremium(PensEarnings,
      MyStrToInt(FieldByName('CPPPeriods').AsString),
      MyStrToInt(FieldByName('TotPeriods').AsString));
  CalcCPPAdj := CppIn - CppCalcd;

  EIEarnings :=  FieldByName('Box24').AsFloat;
  If UpperCase(FieldByName('Box28B').AsString) = 'X' then
    EIEarnings :=0;

  EIIn := FieldByName('Box18').AsFloat;
  EICalcd := CalcEiPremium(FieldByName('Province').AsString,EIEarnings,
            MyStrToInt(FieldByName('UIPeriods').AsString),
                 MyStrToInt(FieldByName('TotPeriods').AsString));
  CalcEIAdj := EIIn - EICalcd;

  Table1.Edit;
  Table1.FieldByName('AdjCPP').AsFloat := CalcCppAdj;
  Table1.FieldByName('AdjUI').AsFloat  := CalcEIAdj;
  Table1.FieldByName('AdjTax').AsFloat  := CalcCppAdj+CalcEIAdj;
 end;
end;
*)

exports
  EMPL,
  STATUS,
  T4,
  T4A, //20170126 igor
  T5,  //20170126 igor
  //20171215 Igor>>>
  T5SUM,
  T4ASUM,
  T4SUM,
  FLDTAPE, //20220121 Igor
  CalcUsedFrm;
  //20171215 Igor<<<

end.
