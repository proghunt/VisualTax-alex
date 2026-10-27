Unit T2_2027calc3;

interface
{
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 UDeclare,common, common2,TrimStr;
}
 {Ontario}
 {Function GetOntTxblIncBeforeDonations(RetNo:Integer):real;}
 //from Cal5

 procedure S500(RetNo: integer;FName: string;FNo: integer);
 procedure S502(RetNo: integer;FName: string;FNo: integer);
 procedure S504(RetNo: integer;FName: string;FNo: integer);
 procedure S506(RetNo: integer;FName: string;FNo: integer);
 procedure S507(RetNo: integer;FName: string;FNo: integer);
 procedure S508(RetNo: integer;FName: string;FNo: integer);
 procedure S510(RetNo: integer;FName: string;FNo: integer);
 procedure S511(RetNo: integer;FName: string;FNo: integer);
 procedure S512(RetNo: integer;FName: string;FNo: integer);
 procedure S513(RetNo: integer;FName: string;FNo: integer);
 procedure S517(RetNo: integer;FName: string;FNo: integer);
 procedure S524(RetNo: integer;FName: string;FNo: integer);
 procedure S525(RetNo: integer;FName: string;FNo: integer);

 //procedure S546(RetNo: integer;FName: string;FNo: integer);
 //procedure S547(RetNo: integer;FName: string;FNo: integer);
 //procedure S548(RetNo: integer;FName: string;FNo: integer);
 procedure S550(RetNo: integer;FName: string;FNo: integer);
 procedure S552(RetNo: integer;FName: string;FNo: integer);
 procedure S554(RetNo: integer;FName: string;FNo: integer);
 procedure S556(RetNo: integer;FName: string;FNo: integer);
 procedure S558(RetNo: integer;FName: string;FNo: integer);
 procedure S560(RetNo: integer;FName: string;FNo: integer);
 procedure S562(RetNo: integer;FName: string;FNo: integer);
 procedure S564(RetNo: integer;FName: string;FNo: integer);
 procedure S566(RetNo: integer;FName: string;FNo: integer);
 procedure S568(RetNo: integer;FName: string;FNo: integer);
 procedure S569(RetNo: integer;FName: string;FNo: integer);
 procedure S570(RetNo: integer;FName: string;FNo: integer);


 Function GetStudentRate(Salaries:Real):Real;
 Procedure GetOntAssociations(RetNo:integer;
    Var AssocTxbl:real; Var AssocAssets:real;
    Var AssocRevCap:real; Var AssocTxblCap:real);


implementation

uses
  SysUtils, vtMulti,vtCommon, T2_2027, T2_2027Multi, T2_2027Declare, T2_2027common,
  T2_2027common2, T2_2027TrimStr, T2_2027Calc, T2_2027Calc1, T2_2027Calc5, vtTrimStr,
  vtShared;

Function GetStudentRate(Salaries:real):Real;
begin
   If Salaries <= 400000 then begin result := 0.15;exit;end;
   If Salaries >= 600000 then begin result := 0.10;exit;end;
   If (Salaries > 400000) and (Salaries < 600000) then
    result := 0.15-(0.05 * (salaries-400000)/200000);
end;

Procedure GetOntAssociations(RetNo:integer;
    Var AssocTxbl:real; Var AssocAssets:real;
    Var AssocRevCap:real; Var AssocTxblCap:real);

Var i,FNo:Integer;
begin
  If IsAmalgamatedOntario(RetNo)=True then Exit;
  FNo := GetFormNo('OT2013');
  AssocTxbl:=0;AssocAssets:=0;AssocRevCap:=0;AssocTxblCap:=0;
  i:=11;
  Repeat
   AssocTxbl  := AssocTxbl+Vl(FetchElmFNo(RetNo,FNo,i));
   AssocAssets:=AssocAssets+Vl(FetchElmFNo(RetNo,FNo,i+1));
   AssocRevCap:=AssocRevCap+Vl(FetchElmFNo(RetNo,FNo,i+2));
   AssocTxblCap:=AssocTxblCap+Vl(FetchElmFNo(RetNo,FNo,i+3));
   Inc(i,7);
  until i> 81;
end;

//20260903 Alex >>>
procedure S500(RetNo: integer;FName: string;FNo: integer);
var
  i, j: Integer;
  x, x1, x2: Real;
  SbdRate: string;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    if ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True)) or (IsMJWithOntario(RetNo)) then //continue
    else
    begin
      for i:= 4 to 95 do
      begin
        Strings[i]:= '';
        Tv[i]:= 0;
      end;
      //does not work?  ClearForm(RetNo,FName);
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    //Page 1
    Tv[4]:= GetTxblIncomeInProv(RetNo, 'ON');
    Strings[95]:= '11.5';
    Tv[5]:= Round(Tv[4] * Vl(Strings[95]) / 100);

    Tv[6]:= Ret[RetNo].Ln[400];
    Tv[7]:= Ret[RetNo].Ln[405];
    Tv[25]:= Ret[RetNo].Ln[410];
    Tv[26]:= Ret[RetNo].Ln[415];

    //202301004 //20260903 Alex //Not using any more
    {if GetTaxationYearStart(retNo) < '2022/04/07' then
    begin
     Tv[27]:= Tv[25];
     Tv[23]:= Tv[26];
     Tv[28]:= Round(Tv[27] * Tv[23] / 11250);
     Tv[8]:= 0;
     Tv[53]:= 0;
     Tv[54]:= 0;
    end else
    begin
      Tv[8]:= Tv[25];
      Tv[53]:= Tv[26];
      Tv[54]:= Round(Tv[8] * Tv[53] / 90000);
      Tv[27]:= 0;
      Tv[23]:= 0;
      Tv[28]:= 0;
    end;}
    Tv[8]:= Tv[25];
    Tv[53]:= Tv[26];
    Tv[54]:= Round(Tv[8] * Tv[53] / 90000);

    //Tv[55]:= MaxR(Tv[28], Tv[54]);    //202301004 //20260903 Alex //Not using any more
    Tv[29]:= Vl(FetchElm(RetNo, 'T2', 87)); //Ret[RetNo].Ln[515];  LN  does not work ?//20230630
    //Tv[30]:= MaxR(0,Tv[25]-Tv[55]-Tv[29]);      //202301004
    Tv[30]:= MaxR(0, Tv[25] - Tv[54] - Tv[29]); //20260903 Alex
    Tv[31]:= Tv[30];
    Tv[32]:= MinR(MinR(Tv[6], Tv[7]), Tv[31]);
    Tv[36]:= Tv[32];

    Tv[10]:= Tv[4];
    Tv[11]:= GetTxblIncomeInAllProv(RetNo); //GetTxblIncome(RetNo);
    Strings[12]:= GetOntDomesticFactor(RetNo);
    Tv[45]:= Round(Tv[36] * Vl(Strings[12]));
    Tv[46]:= Tv[4];
    Tv[17]:= MinR(Tv[45], Tv[46]);
    Tv[13]:= Tv[17];
    Tv[14]:= Tv[13];
    Tv[27]:= Tv[13]; //20260903 Alex
    strings[9]:= IntToStr(GetNumDays(RetNo, '01-07-2026', 'B')); //20260903 Alex
    Strings[16]:= IntToStr(Ret[RetNo].DaysInYear); //20260903 Alex
    strings[18]:= IntToStr(GetNumDays(RetNo, '30-06-2026', 'A')); //20260903 Alex
    Strings[19]:= IntToStr(Ret[RetNo].DaysInYear); //20260903 Alex
    Tv[15]:= Round(Tv[14] * (Vl(Strings[16])/Ret[RetNo].DaysInYear) * 0.083); //20260903 Alex
    Tv[28]:= Round(Tv[27] * (Vl(Strings[18])/Ret[RetNo].DaysInYear) * 0.093); //20260903 Alex
    Tv[21]:= Tv[15] + Tv[28]; //20260903 Alex
    Tv[20]:= Tv[21]; //20260903 Alex
    {
    Tv[41]:=Tv[13];
    //20211019
    Strings[16]:=IntToStr(GetNumDays(RetNo,'01-01-2020','B'));
    Strings[18]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[21]:=Round(Tv[41]* (Vl(Strings[16])/Ret[RetNo].DaysInYear) * 8/100);

    Tv[14]:=Tv[13];
    Strings[19]:=IntToStr(GetNumDays(RetNo,'01-01-2019','A'));
    Strings[20]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[9]:=Tv[14]* (Vl(Strings[19])/Ret[RetNo].DaysInYear) * 8.3/100;

    Tv[22]:=Tv[21]+Tv[9];
    Tv[15]:=Tv[22];
    }
    (*
    Tv[20]:=Tv[13];
    Strings[21]:=IntToStr(GetNumDays(RetNo,'31-12-2019','A'));
    Strings[22]:=IntToStr(Ret[RetNo].DaysInYear);
    Tv[9]:=Tv[20]* (Vl(Strings[21])/Ret[RetNo].DaysInYear) * 8.3/100;

    Tv[59]:=Tv[8]+Tv[9]+Tv[19];
    Tv[15]:=Tv[59];
    *)

    //Page 2
    if Ret[RetNo].CorpType <> CCPC then Tv[33]:= 0 else Tv[33]:= MinR(Tv[4], Tv[36]);

    if IsCreditUnion(RetNo) then  //20231004
    begin
      Tv[34]:= Vl(FetchElm(RetNo, 'S17', 117)); //20231109
      //Tv[34]:=Vl(FetchElm(RetNo,'S17',61));
      Tv[35]:= Tv[33];
      Tv[24]:= MaxR(0, Tv[34] - Tv[35]);  //20231004
      Tv[37]:= Tv[24]; //MaxR(0,Tv[34]-Tv[35]);
      Tv[44]:= Tv[37];
      Tv[41]:= Tv[37]; //20260903 Alex
      strings[22]:= IntToStr(GetNumDays(RetNo, '01-07-2026', 'B')); //20260903 Alex
      Strings[38]:= IntToStr(Ret[RetNo].DaysInYear); //20260903 Alex
      strings[42]:= IntToStr(GetNumDays(RetNo, '30-06-2026', 'A')); //20260903 Alex
      Strings[47]:= IntToStr(Ret[RetNo].DaysInYear); //20260903 Alex
      Tv[43]:= Round(Tv[44] * (Vl(Strings[22])/Ret[RetNo].DaysInYear) * 0.083); //20260903 Alex
      Tv[50]:= Round(Tv[41] * (Vl(Strings[42])/Ret[RetNo].DaysInYear) * 0.093); //20260903 Alex
      Tv[48]:= Tv[43] + Tv[50]; //20260903 Alex
      Tv[49]:= Tv[48]; //20260903 Alex

      //Tv[52]:=Tv[37];
      //Strings[47]:=IntToStr(GetNumDays(RetNo,'01-01-2020','B'));
      //Strings[48]:=IntToStr(Ret[RetNo].DaysInYear);
      //Tv[50]:=Tv[52]* (Vl(Strings[47])/Ret[RetNo].DaysInYear) * 8/100;
      //Tv[44]:=Tv[37];
      //Strings[49]:=IntToStr(GetNumDays(RetNo,'01-01-2019','A')); //-GetNumDays(RetNo,'01-01-2018','B'));//IntToStr(GetNumDays(RetNo,'01-01-2020','B'));
      //Strings[42]:=IntToStr(Ret[RetNo].DaysInYear);
      //Tv[43]:=Round(Tv[44]* 8.3/100); //(Vl(Strings[49])/Ret[RetNo].DaysInYear) * 8.3/100; //20260903 Alex
      //Tv[51]:=Tv[50]+Tv[43];
      //Tv[38]:=Tv[51];
      Strings[39]:= Strings[12];
      //Tv[40]:= Round(Tv[43] * Vl(Strings[39])); //20260903 Alex
      Tv[40]:= Round(Tv[49] * Vl(Strings[39])); //20260903 Alex
    end else
    begin
      for i:= 34 to 35 do Tv[i]:= 0;
      Tv[24]:= 0; Tv[37]:= 0; Tv[43]:= 0; Tv[39]:= 0; Tv[40]:= 0;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260903 Alex <<<

procedure S502(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[Fno] do
 begin
   //LoadTv(RetNo,FName,FNo);
   FillHeader(RetNo,FNo,1,2,3);
   If Strings[28]='' then Strings[28]:='N';
   If GetTxblIncomeInProv(RetNo,'ON')<=0 then
   begin
    For i:=4 to 58 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;
   If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
   or (IsMJWithOntario(RetNo))
   then
   else
   begin
   For i:=4 to 58 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
   exit;
  end;

  If UpperCase(Strings[28])='N' then
  begin
    For i:=4 to 58 do begin Strings[i]:='';Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
   exit;
  end;
  // Part 5 needed first
  Tv[52]:=Tv[56]+Tv[57]+Tv[58]+Tv[31]+Tv[51];
  Tv[54]:=MaxR(0,Tv[52]-Tv[53]);

  Tv[4]:=Vl(FetchElm(RetNo,'S27',4));  //line 100
  If Vl(FetchElm(RetNo,'S27',13))>0 then Tv[4]:=Vl(FetchElm(RetNo,'S27',13));
  Tv[30]:=Tv[54];
  Tv[55]:=Tv[4]+Tv[30];

  Tv[8]:=MaxR(0,Tv[55]-Tv[61]); //MaxR(0,Tv[6]-Tv[7]); //20231212

  If Tv[8]<=250000 then Strings[46]:='X' else Strings[46]:='';
  //
  Tv[9]:=Vl(FetchElm(RetNo,'S27',213));
  Tv[10]:=MaxR(0,Vl(FetchElm(RetNo,'S27',401))-Tv[9]);
  Tv[11]:=Tv[37];
  Tv[12]:=Tv[45];
  //20100418
  If Strings[46]>'' then
   Tv[13]:=Tv[8]
  else
   Tv[13]:=Tv[9]+Tv[10]+Tv[11]+Tv[12];
  If (UpperCase(Strings[46])='X') and (UpperCase(Strings[47])='X') then Tv[13]:=Tv[8];
  Tv[14]:=Vl(FetchElm(RetNo,'S500',33));
  Tv[15]:=MaxR(0,Tv[13]-Tv[14]);
  Tv[16]:=Tv[15];
  Tv[17]:=MaxR(0,GetTxblIncome(RetNo)+Tv[5]-Tv[7]);

  Tv[18]:=Tv[14];
  Tv[19]:=GetTxblIncomeInAllProv(RetNo);//-GetTxblIncomeInProv(RetNo,'ZZ');
  Tv[20]:=GetTxblIncome(RetNo);
  If Tv[20]>0 then
   Tv[21]:=Round(Tv[17] * (1 - (Tv[19]/Tv[20])))
  else
   Tv[21]:=0;
  Tv[21]:=MaxR(0,Tv[21]);
  Tv[22]:=Ret[RetNo].Ln[440];
  Tv[23]:=Tv[18]+Tv[21]+Tv[22];
  Tv[24]:=Tv[23];
  Tv[25]:=MaxR(0,Tv[17]-Tv[24]);
  Tv[26]:=Tv[25];

  If IsNonResidentCorp(RetNo) then begin For i:=18 to 26 do Tv[i]:=0;end;

  Tv[27]:=MinR(Tv[26],MinR(Tv[8],Tv[16]));
  //Tv[28]:=Tv[27];
  Tv[29]:=Tv[27]; //20220509

  Tv[48]:=GetTxblIncomeInProv(RetNo,'ON');
  Tv[49]:=GetTxblIncomeInAllProv(RetNo); //-GetTxblIncomeInProv(RetNo,'ZZ');
  if Tv[49]>0 then  //20231212
  begin
  Tv[50]:= Tv[29]*(Tv[48]/Tv[49]);
  Tv[50]:= Tv[50]*1.5/100;
  end
  Else
   Tv[50]:=0;
   // Tv[50]:= (Tv[29]*(Tv[48]/Tv[49])*1.5)/100 else Tv[50]:=0;
  {
  If Tv[49]>0 then
   Strings[50]:=FormatFloat('##0.0000',(Tv[48]/Tv[49]))
  Else
   Strings[50]:='0.0000';
  }
  {
  Tv[51]:=Tv[27];
  Tv[54]:=Tv[51]*Vl(Strings[50]);

  Tv[55]:=Tv[54];
  Strings[52]:=IntToStr(GetNumDays(RetNo,'01-07-2011','B'));
  Strings[53]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[56]:=Tv[55]* (Vl(Strings[52])/Ret[RetNo].DaysInYear) * 2/100;

  Tv[57]:=Tv[54];
  Strings[58]:=IntToStr(GetNumDays(RetNo,'30-06-2011','A'));
              // -GetNumDays(RetNo,'30-06-2012','A'));
  Strings[59]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[60]:=Tv[57]* (Vl(Strings[58])/Ret[RetNo].DaysInYear) * 1.5/100;

  Tv[31]:=Tv[56]+Tv[60]; //+Tv[64];
  }
  If Tv[8] >250000 then
  begin
   If Tv[35]+Tv[36]>0 then
    Tv[37]:=Round(Tv[32] * (Tv[33]+Tv[34]) / (Tv[35]+Tv[36]))
   Else
    Tv[37]:=0;

   If Tv[42]+Tv[43]>0 then
    Tv[44]:=Round(Tv[39] * (Tv[40]+Tv[41]) / (Tv[42]+Tv[43]))
   Else
    Tv[44]:=0;
   Tv[45]:=Tv[38]+Tv[44];
  end
  else
   For i:=32 to 45 do Tv[i]:=0;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;



procedure S504(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
 //20160603  a lot of changes
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsMJWithOntario(RetNo)) then
 //or (Ret[RetNo].Province = 'MJ') then
 //continue
 else
 begin
  For i:=4 to 39 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  //jz 2019 new part 1, all other parts removed
  //part 1
  Tv[42]:=Tv[10]+Tv[11];
  Tv[22]:=Tv[42];

  Tv[44]:=Vl(FetchElm(RetNo,'S5',611));
  Tv[53]:=MinR(Tv[22],Tv[44]);
  Tv[39]:=MaxR(0,Tv[22]-Tv[53]); //jz 2019 negative allowed??  NO
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S506(RetNo: integer;FName: string;FNo: integer);
Var i,k:Integer;s:String; ADate,BDate:TDateTime; D1:String; nMonths:Integer;
    S507FNo:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
  //continue
  else
  begin
   For i:=4 to 172 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end; //20100530
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  with Ret[RetNo].Frm[Fno] do
  begin
  //part 1 - Federal
   If Strings[174]='' then Strings[174]:='N';

   If DateWithinTaxYear('2009/01/01',RetNo) = false then  //20091115
   begin
    For i:=4 to 14 do Tv[i]:=0;
    For i:=15 to 25 do Tv[i]:=0;  //20101108
   end
   Else
   begin
    If UpperCase(Strings[173]) <> 'Y' then Tv[4]:=GetTotBegBalS8(RetNo);
    Tv[5]:=Vl(FetchElm(RetNo,'S2',4));
    Tv[6]:=Vl(FetchElm(RetNo,'S2',103));
    Tv[7]:=Vl(FetchElm(RetNo,'S2',111));
    Tv[8]:=Vl(FetchElm(RetNo,'S2',119));
    Tv[9]:=Vl(FetchElm(RetNo,'S2',140));
    Tv[10]:=Vl(FetchElm(RetNo,'S10',4))+Vl(FetchElm(RetNo,'S10',24));
    Tv[11]:=Vl(FetchElm(RetNo,'T661',132)); //SR&ED
    Tv[12]:=Vl(FetchElm(RetNo,'S12',101));
    Tv[13]:=Vl(FetchElm(RetNo,'S12',201));
    Tv[14]:=Vl(FetchElm(RetNo,'S12',301));

    Tv[16]:=Vl(FetchElm(RetNo,'S4',17));
    Tv[17]:=(Vl(FetchElm(RetNo,'S4',101)) + Vl(FetchElm(RetNo,'S4',102))) * 50/100;
    //tv[18], 19, 20 from last year ontario ??
    Tv[23]:=AddColumns(4,14,1);
    Tv[23]:=Tv[23]+Tv[15]+AddColumns(16,22,1);
    Tv[24]:=MinR(Tv[68],Tv[71]);
    Tv[25]:=Tv[23]-Tv[24];
   end;
   //part 2
   If DateWithinTaxYear('2009/01/01',RetNo) = false then
   begin
    For i:=26 to 45 do Tv[i]:=0;
   end
   Else
   Begin
    If UpperCase(Strings[174])<> 'Y' then
    begin
     Tv[26]:=Tv[4];
     Tv[27]:=Tv[5];
     Tv[28]:=Tv[6];
     Tv[29]:=Tv[7];
     Tv[30]:=Tv[8];
     Tv[31]:=Tv[9];
     Tv[32]:=Tv[10];
     Tv[33]:=Tv[11];
     Tv[35]:=Tv[12];
     Tv[36]:=Tv[13];
     Tv[37]:=Tv[14];
     Tv[38]:=Tv[16];
     Tv[39]:=Tv[17];
    end;
    Tv[45]:=AddColumns(26,44,1);
   end;
   S507FNo:=GetFormNo('S507');
   //part 3
   If DateWithinTaxYear('2009/01/01',RetNo) = true then Tv[46]:=Tv[25];
   Tv[47]:=Vl(FetchElmFNo(RetNo,S507FNo,9));
   Tv[48]:=Vl(FetchElmFNo(RetNo,S507FNo,23));
   Tv[49]:=Vl(FetchElmFNo(RetNo,S507FNo,32));
   Tv[50]:=Vl(FetchElmFNo(RetNo,S507FNo,34));

   Tv[54]:=Vl(FetchElmFNo(RetNo,S507FNo,15));
   Tv[55]:=Vl(FetchElmFNo(RetNo,S507FNo,31));
   Tv[56]:=Vl(FetchElmFNo(RetNo,S507FNo,33));
   Tv[57]:=Vl(FetchElmFNo(RetNo,S507FNo,35));

   Tv[51]:=AddColumns(46,50,1);
   Tv[52]:=Tv[51];
   //Tv[53]:=Tv[45];
   If DateWithinTaxYear('2009/01/01',RetNo) = True then Tv[53]:=Tv[45];
   Tv[58]:=AddColumns(53,57,1);
   Tv[59]:=Tv[58];
   Tv[60]:=TV[52]-Tv[59];

   //part 4
   If Strings[61]>'' then
   begin
    Tv[63]:=Tv[11];
    Tv[66]:=Tv[64]+Tv[65];
    Tv[67]:=Tv[66];
    Tv[68]:=MaxR(0,Tv[63]-Tv[67]);
    Tv[69]:=Tv[23];
    Tv[70]:=Tv[45];
    Tv[71]:=MaxR(0,Tv[69]-Tv[70]);
   end
   else
   begin
    for i:=63 to 71 do Tv[i]:=0;
   end;




   //20150321
   If Strings[178]<>'Y' then Strings[72]:='1825';  //20150318
   If Strings[180]<>'Y' then Strings[73]:='0';  //20150318

   Tv[80]:=GetTxblIncomeInProv(RetNo,'ON');
   Tv[81]:=GetTxblIncome(RetNo);
   If Tv[80]=0 then Tv[80]:=1000;
   If Tv[81]=0 then Tv[81]:=1000;
   Tv[82]:=RoundN(Tv[80]/Tv[81],4);
   Strings[82]:=FormatFloat('##0.0000',Tv[82]);
   Strings[83]:=Strings[82];

   //part 6
   If Tv[60]>0 then
   begin
    Tv[84]:=Tv[60];
    Strings[181]:=GetOntBasicTaxRate(RetNo);  //20100518
    Tv[85]:=Tv[84] * vl(Strings[181])/100; //14/100;
    Tv[86]:=Tv[85] * Vl(Strings[83]);

    Strings[87]:='0';
    If Strings[79]>'' then
     Strings[87]:=Strings[79]
    else
     Strings[87]:=Strings[73];  //IntToStr(Ret[RetNo].DaysInYear); //20150321

    Strings[88]:=Strings[72];
    If Vl(Strings[88])>0 then
      Strings[89]:=FormatFloat('##0.0000',Vl(Strings[87])/Vl(Strings[88]))
    else
      Strings[89]:='';
    Tv[90]:=Tv[86] * Vl(Strings[89]);
    Tv[91]:= Tv[147];
    Tv[92]:=Tv[168];
    Tv[93]:=MinR(Tv[91],Tv[92]);
    Tv[94]:=Tv[90]+Tv[93];
   end
   Else
   Begin
    For i:=84 to 94 do Tv[i]:=0;
   end;

  //part 8
  If Tv[60]<0 then
  begin
  Tv[95]:=Vl(FetchElm(RetNo,'S5',611));
  Tv[96]:=Vl(FetchElm(RetNo,'S5',612));
  Tv[97]:=Vl(FetchElm(RetNo,'S5',613));
  Tv[98]:=Vl(FetchElm(RetNo,'S5',614));
  Tv[99]:=Vl(FetchElm(RetNo,'S5',615));
  Tv[100]:=AddColumns(96,99,1);
  Tv[101]:=Tv[100];
  Tv[102]:=Tv[95]-Tv[101];
  Strings[103]:=Strings[73];
  Strings[104]:=IntToStr(Ret[RetNo].DaysInYear);
  If DateWithinTaxYear('2012/02/29',RetNo) = true then Strings[104]:=IntToStr(Ret[RetNo].DaysInYear-1);  //20111102

  If Vl(Strings[104])>0 then
   Tv[105]:=Vl(Strings[103])/Vl(Strings[104])
  else
   Tv[105]:=0;
  Strings[105]:=FormatFloat('##0.0000',Tv[105]);
  Tv[106]:=Tv[102] * Tv[105];

  Tv[107]:=ABS(Tv[60]);
  Strings[177]:=GetOntBasicTaxRate(RetNo);
  Tv[108]:=Tv[107] * Vl(Strings[177])/100;
  Tv[109]:=Tv[108] * Vl(Strings[83]);
  Strings[110]:=Strings[79];
  If Strings[110]='' then Strings[110]:=Strings[73];
  Strings[111]:=Strings[72];
  If Vl(Strings[111])>0 then
   Tv[112]:=Vl(Strings[110])/Vl(Strings[111])
  else
   Tv[112]:=0;
  Strings[112]:=FormatFloat('##0.0000',Tv[112]);
  Tv[113]:=Tv[109] * Tv[112];
  Tv[114]:=MaxR(0,Tv[106]-Tv[113]);
  Tv[115]:=MinR(Tv[106],Tv[113]);
  Tv[116]:=MinR(Tv[121],Tv[114]);
  Tv[117]:=Tv[115]+Tv[116];
  end
  Else
  begin
   For i:=95 to 117 do Tv[i]:=0;
  end;

  //Part 9   //20090526
  Tv[120]:=Tv[118]+Tv[119];
  Tv[121]:=Tv[120];
  Tv[122]:=Tv[113];
  Tv[182]:=TV[121]+Tv[122];
  Tv[123]:=Tv[117];
  Tv[124]:=MaxR(0,Tv[182]-Tv[123]); //MaxR(0,Tv[121]+Tv[122]-Tv[123]);  //20100518

  If UpperCase(Strings[176])<>'Y' then //no election made
  begin
   For i:=125 to 168 do begin Strings[i]:='';Tv[i]:=0;end;
  end
  Else
  begin
   Tv[125]:=Vl(FetchElm(RetNo,'T661',121));
   Tv[126]:=Vl(FetchElm(RetNo,'T661',122));
   Tv[127]:=Vl(FetchElm(RetNo,'T661',169));
   Tv[128]:=Vl(FetchElm(RetNo,'T661',134));
   Tv[129]:=AddColumns(125,128,1);
   Tv[130]:=Tv[129];
  // Tv[131]:=Vl(FetchElm(RetNo,'T661',125));   //20100419
   Tv[132]:=Vl(FetchElm(RetNo,'T661',128));
   Tv[133]:=Tv[131]+Tv[132];
   Tv[134]:=Tv[133];
   Tv[135]:=Tv[130]-Tv[134];

   Strings[136]:=Strings[83];
   Strings[139]:=FormatFloat('###.####',(MaxR(MaxR(Vl(Strings[136]),Vl(Strings[137])),Vl(Strings[138]))*100));
   //Part 12
   If Tv[135]<0 then
    Tv[140]:=ABS(Tv[135])
   else
   Tv[140]:=0;
   Tv[141]:=Vl(FetchElm(RetNo,'T661',136));
   Tv[142]:=Tv[160];
   Tv[143]:=MaxR(0,Tv[141]-Tv[142]);
   Tv[144]:=Tv[143];
   Tv[145]:=Tv[140]+Tv[144];
   //Strings[180]:=GetOntBasicTaxRate(RetNo); //20100518
   Tv[146]:=Tv[145]*14/100; //Vl(Strings[180])/100;  //20100501
   Tv[147]:=Tv[146] * Vl(Strings[139])/100;

   //Part 13
   If Tv[135]>0 then
    Tv[148]:=Tv[135]
   else
    Tv[148]:=0;
   Tv[150]:=Tv[148]+Tv[149];
   Tv[154]:=MaxR(0,Tv[152]-Tv[153]);
   Tv[155]:=Tv[154];
  // Strings[178]:=GetOntBasicTaxRate(RetNo);  //20100518
   Strings[156]:=FormatFloat('##0.0000', (Vl(Strings[139])/100) *14/100); //20100518 //20100501
   If Vl(Strings[156])>0 then
    Tv[157]:=Tv[155]/Vl(Strings[156])
   else
    Tv[157]:=0;
   Tv[158]:=MaxR(0,Tv[151]-Tv[157]);
   Tv[159]:=Tv[158];
   Tv[160]:=MaxR(0,Tv[150]-Tv[159]);
   //Part 14
  // Tv[161]:=Tv[24];

   Tv[162]:=Tv[161] * Vl(Strings[175])/100;
   Strings[179]:=GetOntBasicTaxRate(RetNo);
   Tv[163]:=Tv[162] * Vl(Strings[179])/100; //20100501
   Tv[164]:=Tv[163];
   Tv[166]:=Tv[164]+Tv[165];
   Tv[168]:=Tv[166]+Tv[167];
  end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S507(RetNo: integer;FName: string;FNo: integer);
Var i,j:Integer; ThisYearEnd:String;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
 //or (Ret[RetNo].Province = 'MJ') then
 //continue
 else
 begin
  For i:=4 to 35 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;
 with Ret[RetNo].Frm[Fno] do
 begin
   If Vl(Strings[6])>0 then
     Strings[7]:=FormatFloat('##0.0000',Vl(Strings[5])/Vl(Strings[6]))
   else
     Strings[7]:='';
   If Vl(Strings[7])>1 then Strings[7]:='1.0000';
   Strings[8]:=FormatFloat('##0.0000',1-Vl(Strings[7]));
   Tv[9]:=Tv[4] * Vl(Strings[8]);
  //part 2
   If Vl(Strings[12])>0 then
     Strings[13]:=FormatFloat('##0.0000',Vl(Strings[11])/Vl(Strings[12]))
   else
     Strings[13]:='';
   If Vl(Strings[13])>1 then Strings[13]:='1.0000';
   Strings[14]:=FormatFloat('##0.0000',1-Vl(Strings[13]));
   Tv[15]:=Tv[10] * Vl(Strings[14]);
  //part 3
   If Vl(Strings[18])>0 then
     Strings[19]:=FormatFloat('##0.0000',Vl(Strings[17])/Vl(Strings[18]))
   else
     Strings[19]:='';
   If Vl(Strings[19])>1 then Strings[19]:='1.0000';

   If Vl(Strings[21])>0 then
     Strings[22]:=FormatFloat('##0.0000',Vl(Strings[20])/Vl(Strings[21]))
   else
     Strings[22]:='';
   If Vl(Strings[22])>1 then Strings[22]:='1.0000';
   If (Strings[19]='') and (strings[22]='') then
     Tv[23]:=Tv[16]
   else
     Tv[23]:=Tv[16] * Vl(Strings[19]) * Vl(Strings[22]);

  //part 4
   If Vl(Strings[26])>0 then
     Strings[27]:=FormatFloat('##0.0000',Vl(Strings[25])/Vl(Strings[26]))
   else
     Strings[27]:='';
   If Vl(Strings[27])>1 then Strings[27]:='1.0000';

   If Vl(Strings[29])>0 then
     Strings[30]:=FormatFloat('##0.0000',Vl(Strings[28])/Vl(Strings[29]))
   else
     Strings[30]:='';
   If Vl(Strings[30])>1 then Strings[30]:='1.0000';
   If (Strings[27]='') and (strings[30]='') then
     Tv[31]:=Tv[24]
   else
     Tv[31]:=Tv[24] * Vl(Strings[27]) * Vl(Strings[30]);
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


//20170305 all changed
procedure S508(RetNo: integer;FName: string;FNo: integer);
Var i,j:Integer; ThisYearEnd:String;s:String;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
 //or (Ret[RetNo].Province = 'MJ') then
 //continue
 else
 begin
  For i:=4 to 38 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  For i:=140 to 177 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;
 with Ret[RetNo].Frm[Fno] do
 begin
  For i:=4 to 139 do begin If Tv[i]<0 then Tv[i]:=0;end; //no negatives
  //20171201
  if (Ret[RetNo].Province='ON') and (Strings[15]='') then Strings[15]:='Y';
  If UpperCase(Strings[15])='Y' then //all Ontario
  Begin
     Tv[4]:= Vl(FetchElm(RetNo,'T661',145));//20210325  //Vl(FetchElm(RetNo,'T661',170));  //20200203 //Vl(FetchElm(RetNo,'T661',145)); //20200201
    //Tv[4]:= Vl(FetchElm(RetNo,'T661',123))- Vl(FetchElm(RetNo,'T661',13));  //20210201  obsolete boxes
    // If FetchElm(RetNo,'T661',104)>'' then Tv[4]:=Tv[4]+Vl(FetchElm(RetNo,'T661',141)); //proxy amount //20210201?
  End;

  Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
  Tv[8]:=Tv[6]+Tv[7]; //MaxR(0,Tv[6]-Tv[7]);  //20110927
  Tv[9]:=Tv[8];
  Tv[11]:=MaxR(0,Tv[9]-Tv[10]);

  Tv[13]:=Round(Tv[12] * 4.5/100);
  //20170606
  if (GetTaxationYearEnd(RetNo)>='2016/06/01')
  and (DateWithinTaxYear('20160531',RetNo)) then
  Begin
   if Tv[147]=0 then
   Begin
    Strings[140]:='';
    Strings[142]:='';
    Strings[141]:='';

    Strings[143]:='';
    Strings[144]:='';
    Strings[145]:='';

    Strings[146]:='';
    Strings[178]:='';
    Tv[148]:=0;
   End
   Else
   Begin
    Strings[140]:=IntToStr(GetNumDays(RetNo,'01-06-2016','B'));
    Strings[142]:=IntToStr(Ret[RetNo].DaysInYear);
    Strings[141]:=FormatFloat('##0.0000',(Vl(Strings[140])/Ret[RetNo].DaysInYear)*4.5);

    Strings[143]:=IntToStr(GetNumDays(RetNo,'31-05-2016','A'));
    Strings[144]:=IntToStr(Ret[RetNo].DaysInYear);
    Strings[145]:=FormatFloat('##0.0000',(Vl(Strings[143])/Ret[RetNo].DaysInYear)*3.5);

    Strings[146]:=FormatFloat('##0.0000',Vl(Strings[141])+Vl(Strings[145]));
    Strings[178]:=Strings[146];
    Tv[148]:=Round(Tv[147]*Vl(Strings[178])/100);
   End;
  end
  Else
  Begin
   for i:=140 to 148 do begin Strings[i]:='';Tv[i]:=0;end;
  End;

  //Part2
  if (GetTaxationYearStart(RetNo)>='2016/05/31') then
  //ok
  Else
   Tv[149]:=0;

  Tv[150]:=Round(Tv[149] * 3.5/100);
  Tv[152]:=Round(Tv[151]/4);
  Tv[153]:=Round(Tv[152] * (4.5/100));
  Tv[154]:=Tv[13]+Tv[148]+Tv[150]+Tv[153];
  //Part3
  //ending before June 1, 2016
  if GetTaxationYearEnd(RetNo)<'2016/06/01' then
  Begin
   Tv[155]:=Tv[11];
   Tv[156]:=Round(Tv[155]*(4.5/100));
   Tv[158]:=Tv[154];
   Tv[159]:=Tv[156]+Tv[157]+Tv[158];
  End
  else
  begin
   For i:=155 to 159 do Tv[i]:=0;
  end;

  if (GetTaxationYearEnd(RetNo)>='2016/06/01')
  and (DateWithinTaxYear('2016/05/31',RetNo)) then
  Begin
   Strings[160]:=IntToStr(GetNumDays(RetNo,'01-06-2016','B'));
   Strings[161]:=IntToStr(Ret[RetNo].DaysInYear);
   Strings[162]:=FormatFloat('##0.0000',(Vl(Strings[160])/Ret[RetNo].DaysInYear)*4.5);

   Strings[163]:=IntToStr(GetNumDays(RetNo,'31-05-2016','A'));
   Strings[164]:=IntToStr(Ret[RetNo].DaysInYear);
   Strings[165]:=FormatFloat('##0.0000',(Vl(Strings[163])/Ret[RetNo].DaysInYear)*3.5);

   Strings[166]:=FormatFloat('##0.0000',Vl(Strings[162])+Vl(Strings[165]));
   Tv[167]:=TV[11];
   Strings[168]:=Strings[166];
   Tv[169]:=Round(Tv[167]*Vl(Strings[168])/100);
   Tv[171]:=Tv[154];
   TV[172]:=Tv[169]+Tv[170]+Tv[171];
  End
  Else
  Begin
   for i:=160 to 172 do begin Tv[i]:=0;Strings[i]:=''; end;
  End;

  if GetTaxationYearStart(RetNo)>'2016/05/31' then   //20180203
  begin
   Tv[173]:=Tv[11];
   Tv[174]:=Round(Tv[173] * (3.5/100));
   Tv[176]:=Tv[154];
   Tv[177]:=Tv[174]+Tv[175]+Tv[176];
  end
  Else
  Begin
   for i:=173 to 177 do Tv[i]:=0;
  End;

  //PART 4 FIRST
  ThisYearEnd:=GetTaxationYearEnd(RetNo);
  Strings[38]:=GetPrevYearEnd(ThisYearEnd,1);
  Strings[40]:=GetPrevYearEnd(ThisYearEnd,2);
  Strings[42]:=GetPrevYearEnd(ThisYearEnd,3);
  Tv[44]:=Tv[39]+Tv[41]+Tv[43];
  //part 3
  Tv[23]:=MaxR(0,Tv[21]-Tv[22]);

  Tv[25]:=MaxR(Tv[159],Tv[172]);
  Tv[25]:=MaxR(Tv[25],Tv[177]);  //max of 3)

  If Strings[26]+Strings[27]='' then Strings[27]:='X'; //20100501
  If UpperCase(Strings[26])='' then Tv[28]:=0;
  Tv[29]:=MaxR(0,Tv[25]-Tv[28]);
  Tv[30]:=Tv[29];
  Tv[31]:=Tv[23]+Tv[24]+Tv[30];
  Tv[32]:=Tv[31];
  if Tv[33]>Tv[32]Then Tv[33]:=Tv[32];  //20181122

  if UpperCase(Strings[14])<>'Y' then  //20171201
  Begin
   Tv[33]:=Tv[32];  //default claim to it?
   If Tv[33]>Vl(FetchElm(RetNo,'S5',619)) then Tv[33]:=Vl(FetchElm(RetNo,'S5',619));  //20100911//20170605
  end;

  Tv[34]:=Tv[44];
  Tv[35]:=Tv[33]+Tv[34];
  Tv[36]:=Tv[35];
  Tv[37]:=MaxR(0,Tv[32]-Tv[36]);
  //part 5
  Tv[85]:=AddColumns(66,84,2);

  //Part 6
  i:=86;
  Tv[101]:=0;
  Repeat
   Tv[i+2]:=MinR(Tv[i],Tv[i+1]);
   Tv[101]:=Tv[101]+Tv[i+2];
   Inc(i,3);
  until i>98;

  i:=102;
  j:=117;
  Tv[132]:=0;
  Repeat
    Tv[j]:=MaxR(0,Round(Tv[i] * Tv[i+1]-Tv[i+2])); //20101121
    Tv[J+2]:=MinR(Tv[j],Tv[J+1]);
    Tv[132]:=Tv[132]+Tv[j+2];
    Inc(i,3);
  until i>114;

  //part 7
  Tv[134]:=Tv[101];
  Tv[135]:=Tv[132];
  Tv[136]:=Tv[134]+Tv[135];
  Tv[137]:=Round(Tv[136] * 23.56/100);
  Tv[138]:=Tv[133];
  Tv[139]:=Tv[137]+Tv[138];

 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;



procedure S510(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If (UpperCase(Ret[RetNo].Frm[FNo].Strings[143])='Y') then  //exempt
 begin
  For i:=4 to 142 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  Ret[RetNo].Frm[FNo].Strings[154]:='N';
  SaveTv(RetNo,FName,FNo);
  exit;
 end;
 //20110410
 If IsAmalgamatedOntario(RetNo)=False then
 begin
  For i:=4 to 142 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  Ret[RetNo].FrmHasData[FNo]:=False;
  exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[143]='' then Strings[143]:='N';

  If UseGifi(RetNo) then Tv[4]:=Vl(FetchElm(RetNo,'S100',89)); //total assets bal sheet
  //20150826 Vl(FetchGifiElm(RetNo,'GIFIBS#1','2599')); //total assets bal sheet
  If Tv[4]<0 then Tv[4]:=0; //20110322
  If Tv[5]<0 then Tv[5]:=0;
  //Tv[5]:=partnerships/joint ventures??
  Tv[6]:=Vl(FetchElm(RetNo,'S511',84));
  //tv[7]:=
  Tv[8]:=Tv[4]+Tv[5]+Tv[6];
  //tor revenues Tv[9], 10
  If UseGifi(RetNo) then
  begin
   Tv[9]:=Vl(FetchElm(RetNo,'S125#1',14))+Vl(FetchElm(RetNo,'S125#1',29)); //total revenue
   //Vl(FetchGifiElm(RetNo,'GIFIIS#1','8299'))+Vl(FetchGifiElm(RetNo,'GIFIIS#1','9659')); //total revenue

   If Ret[RetNo].DaysInYear <357 then Tv[9]:=Round(Tv[9] * 365/Ret[RetNo].DaysInYear);
  end;
  If Tv[9]<0 then Tv[9]:=0;
  Tv[11]:=Vl(FetchElm(RetNo,'S511',85));
  Tv[13]:=Tv[9]+Tv[10]+Tv[11];

  //part 2
  Tv[14]:=Vl(FetchElm(RetNo,'S1',4));
  If Vl(FetchElm(RetNo,'S1',5))>0 then
    Tv[15]:=Vl(FetchElm(RetNo,'S1',5))  //current inc tax
  else
    Tv[15]:=0;
  If Vl(FetchElm(RetNo,'S1',6))>0 then
   Tv[16]:=Vl(FetchElm(RetNo,'S1',6)) //provision deferred inc tax
  else
   Tv[16]:=0;

  Tv[17]:=MaxR(0,Vl(FetchElm(RetNo,'S1',14)));  //equity losses
  Tv[18]:=MaxR(0,Vl(FetchElm(RetNo,'S1',105)));  //loss from partnerships/joint ventures
  ////20220601 Not automatic. Creates miscalculation CRX has it manual
  //If UpperCase(Strings[151]) <> 'Y' then Tv[19]:=Vl(FetchElm(RetNo,'S3',251));//Vl(FetchElm(RetNo,'S1',14));  //equity losses

  Tv[26]:=AddColumns(15,23,1);
  Tv[27]:=Tv[26];

  If Vl(FetchElm(RetNo,'S1',5))>0 then
   Tv[28]:=0
  else
   Tv[28]:=ABS(Vl(FetchElm(RetNo,'S1',5)));

  If Vl(FetchElm(RetNo,'S1',6))>0 then
   Tv[29]:=0
  else
   Tv[29]:=Abs(Vl(FetchElm(RetNo,'S1',6))); //provision deferred inc tax
  Tv[30]:=Vl(FetchElm(RetNo,'S1',207));
  Tv[31]:=Vl(FetchElm(RetNo,'S1',206));
  Tv[32]:=Vl(FetchElm(RetNo,'T2',219));
  Tv[33]:=Vl(FetchElm(RetNo,'S1',36));
  Tv[48]:=AddColumns(28,47,1);
  Tv[54]:=Tv[48];
  Tv[55]:=Tv[14]+Tv[27]-Tv[54];

  //part 3
  //OAF
  Tv[69]:=GetTxblIncomeInProv(RetNo,'ON');
  Tv[70]:=GetTxblIncome(RetNo);
  If Ret[RetNo].Province='ON' then
  begin
   Tv[71]:=1;
   Strings[71]:='1.0000';
  end
  else
  begin
   If Tv[70]=0 then Tv[70]:=1000;
   Tv[71]:=RoundN(Tv[69]/Tv[70],4);
   Strings[71]:=FormatFloat('##0.0000',Tv[71]);
  end;
  Strings[72]:=Strings[71];
  Tv[56]:=MaxR(0,Tv[55]);

  If SubjectToCmt(RetNo) = False then Tv[56]:=0;

  Tv[57]:=Tv[116];
  Tv[59]:=MaxR(0,Tv[57]-Tv[58]);
  Tv[60]:=Tv[59];
  Tv[61]:=MaxR(0,Tv[56]-Tv[60]);
  Tv[7]:=Tv[61];
  Strings[12]:=IntToStr(GetNumDays(RetNo,'01-07-2010','B'));
  Strings[144]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[145]:=Round(Tv[7]* (MyStrToInt(Strings[12])/Ret[RetNo].DaysInYear)) *4/100;

  Tv[146]:=Tv[61];
  Strings[147]:=IntToStr(GetNumDays(RetNo,'30-06-2010','A'));
  Strings[148]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[149]:=Round(Tv[146]* (MyStrToInt(Strings[147])/Ret[RetNo].DaysInYear)) *2.7/100;
  Tv[150]:=Tv[145]+Tv[149];
  Tv[62]:=Tv[150];
  Strings[63]:=Strings[72];
  Tv[64]:=Tv[62] * Vl(Strings[63]); // * 4/100;

  If FetchElm(RetNo,'T2',62)= 'Life Insurance Corporation' then
   Tv[65]:=0
  else
   Tv[65]:=TotMultiple(RetNo,'S21P',104);

  Tv[66]:=MaxR(0,Tv[64]-Tv[65]);
  Tv[67]:=Vl(FetchElm(RetNo,'S5',621));
  Tv[68]:=MaxR(0,Tv[66]-Tv[67]);


  //part 4
  Tv[75]:=MaxR(0,Tv[73]-Tv[74]);
  Tv[76]:=Tv[75];
  Tv[78]:=Tv[76]+Tv[77];
  Tv[79]:=Tv[97];
  Tv[80]:=MaxR(0,Tv[78]-Tv[79]);
  Tv[81]:=Tv[68];
  //TV[82] ?? //S512 life ins
  Tv[83]:=Tv[81]+Tv[82];
  Tv[84]:=Tv[83];
  Tv[85]:=Tv[80]+Tv[84];
  //part 5
  Tv[86]:=Tv[78];
  Tv[87]:= Vl(FetchElm(RetNo,'S5',621));
  //20100528
  If IsLifeInsuranceCorp(RetNo) = false then
  begin
   Tv[88]:=Tv[66];
   Tv[152]:=0;Tv[89]:=0;Tv[153]:=0;
   Tv[190]:=Tv[88];
  end
  Else
  Begin
   Tv[88]:=0;
   Tv[152]:=Tv[64];
   Tv[89]:= Vl(FetchElm(RetNo,'S512',65));
   Tv[153]:=MaxR(Tv[152],Tv[89]);
   Tv[90]:=Tv[153];
  end;
  Tv[91]:=MaxR(0,Tv[87]-Tv[90]);
  Tv[92]:=Tv[91];
  Tv[93]:=Vl(FetchElm(RetNo,'S5',621));
  Tv[94]:=Vl(FetchElm(RetNo,'S5',642));
  Tv[95]:=MaxR(0,Tv[93]-Tv[94]);
  Tv[96]:=Tv[95];
  If Strings[98]+Strings[99]='' then Strings[99]:='X';
  Tv[97]:=MinR(Tv[96],MinR(Tv[86],Tv[92]));
  //part 6
  If DateWithinTaxYear('2009/01/01',RetNo)=false then  //20100501
  begin
   For i:=100 to 109 do TV[i]:=0;
  end;

  Tv[110]:=AddColumns(100,109,1);
  //part 7
  Tv[113]:=MaxR(0,Tv[111]-Tv[112]);
  Tv[114]:=Tv[113];
  Tv[116]:=Tv[114]+Tv[115];
  Tv[117]:=MinR(MaxR(0,Tv[55]),Tv[60]);
  Tv[118]:=MaxR(0,Tv[116]-Tv[117]);
  If Tv[55]<0 then  Tv[119]:=ABS(Tv[55]) else Tv[119]:=0;
  Tv[120]:=Tv[118]+Tv[119];

  //part 8
  If DateWithinTaxYear('2009/01/01',RetNo)=false then  //20100501
  begin
   For i:=121 to 138 do TV[i]:=0;
  end;
  Tv[141]:=AddColumns(121,137,2);  //20140608
  Tv[142]:=AddColumns(122,140,2);

  //20111130
  If UpperCase(Strings[143])='Y' then Strings[154]:='N'; //exempt

  If IncludeS510InFiling(RetNo) then Strings[154]:='Y' Else Strings[154]:='N';


 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S511(RetNo: integer;FName: string;FNo: integer);
Var i,j:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo))
  then
   //continue
  else
  begin
   If IsAssociated(RetNo)=false then  //20220627
   Begin
    For i:=4 to 85 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;
  end;

  //20220627
  (*
  If UpperCase(FetchElm(RetNo,'S510',154))<>'Y' then
  begin
   For i:=4 to 85 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;
  *)
  If IsNonResidentCorp(RetNo) = False then CopyS511FromS23(RetNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[84]:=0;
   Tv[85]:=0;
   i:=6;
   Repeat
    If Tv[i]<0 then Tv[i]:=0;
    If Tv[i+1]<0 then Tv[i+1]:=0;
    Tv[i]:=Round(Tv[i]);  //20110401
    Tv[i+1]:=Round(Tv[i+1]); //20110401
    Tv[84]:=Tv[84]+Tv[i];
    Tv[85]:=Tv[85]+Tv[i+1];
    Inc(i,4);
   until i>82;
   If Strings[4]+Strings[8]>'' then Ret[RetNo].FrmHasData[FNo] :=True;  //20120604
   If IsAssociated(RetNo) = False then
   begin
    Ret[RetNo].FrmHasData[FNo] :=False;  //20120604
    For i:=4 to 85 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   end;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S512(RetNo: integer;FName: string;FNo: integer);
Var i,j:Integer;
begin
 // FillHeader(RetNo,FNo,1,2,3);
  If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
  //or (Ret[RetNo].Province = 'MJ') then
  //continue
  else
  begin
   If FNo=0 then exit;
   For i:=4 to 200 do begin
    StoreElm(RetNo,FNo,i,'');
    Ret[RetNo].Frm[Fno].Tv[i]:=0;
    end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   If IsLifeInsuranceCorp(RetNo) = false then
   begin
    For i:=4 to 200 do Tv[i]:=0;
    SaveTv(RetNo,FName,FNo);
    Exit;
   end;
   If IsCorpResident(RetNo) then
   begin
    Tv[9]:=AddColumns(4,8,1);
    Tv[10]:=Tv[9];
    Tv[13]:=Tv[11]+Tv[12];
    Tv[14]:=Tv[13];
    Tv[15]:=MaxR(0,Tv[10]-Tv[14]);

    Tv[16]:=Tv[15];
    Tv[17]:=Tv[199];
    Tv[18]:=Tv[16]+Tv[17];

    Tv[20]:=Tv[200];
    Tv[21]:=Tv[19]+Tv[20];

    Tv[23]:=Tv[22];
    Tv[24]:=Tv[21];
    Tv[25]:=Tv[18];
    If Tv[24]>0 then
     Tv[26]:=(Tv[23]/Tv[24]) * Tv[25]
    else
     Tv[26]:=0;
    Tv[28]:=Tv[26]+Tv[27];
   end
   else
   For i:=4 to 28 do Tv[i]:=0;

   //page 2 non res life ins
   If IsNonResidentCorp(RetNo) then
   begin
    Tv[32]:=MaxR(Tv[30],Tv[31]);
    Tv[33]:=Tv[32];
    Tv[37]:=Tv[34]+Tv[35]+Tv[36];
    Tv[38]:=Tv[37];
    Tv[39]:=Tv[33]+Tv[38];
   end
   Else
    For i:=29 to 39 do Tv[i]:=0;

   //part 4
   Tv[45]:=10000000;
   Tv[50]:=AddColumns(46,49,1);
   Tv[51]:=Tv[50];
   Tv[52]:=Tv[45]+Tv[51];

   If Strings[40]>'' then
   begin
     For i:=45 to 52 do tv[i]:=0;
     If UpperCase(Strings[201]) <>'Y' then Tv[53]:=Vl(FetchElm(RetNo,'S513',6));
   end
   else
   begin
    If UpperCase(Strings[201]) <>'Y' then Tv[53]:=Tv[52];
   end;
   //PAGE 3
   //Part 5
   Tv[54]:=MaxR(Tv[28],Tv[39]); //one of them is zero
   Tv[55]:=Tv[53];
   Tv[56]:=MaxR(0,Tv[54]-Tv[55]);
   Tv[57]:=Tv[56];

   Tv[58]:= GetTxblIncomeInProv(RetNo,'ON');
   Tv[59]:=GetTxblIncome(RetNo);
   If Tv[59]>0 then Tv[60]:=Tv[58]/Tv[59]
   else
    Tv[60]:=0;
   Strings[60]:=FormatFloat('##0.0000',Tv[60]);
   Tv[61]:=Tv[57] * Vl(Strings[60]);

   Tv[62]:=Tv[61];
   Tv[63]:=Tv[62];
   If Ret[RetNo].DaysInYear> 365 then
     Strings[64]:='365'
   else
    Strings[64]:=IntToStr(Ret[RetNo].DaysInYear);
   Tv[65]:=Tv[63]* (1.25/100) * Vl(Strings[64])/365;
   Tv[66]:=Vl(FetchElm(RetNo,'S5',623));
   Tv[67]:=Vl(FetchElm(RetNo,'S5',624));
   Tv[68]:=Tv[66]+Tv[67];
   Tv[69]:=Tv[68];
   Tv[70]:=MaxR(0,Tv[65]-Tv[69]);

   //page 4
   i:=72;
   Repeat
    Tv[i+4]:=Tv[i]+Tv[i+2]+Tv[i+3];
    Tv[i+7]:=Tv[i+4]-Tv[i+5]+Tv[i+6];
    Inc(i,9);
   until i>135;

   i:=143;
   j:=71;
   Tv[199]:=0;
   Tv[200]:=0;
   repeat
    Strings[i]:=Strings[j];
    Tv[i+1]:=Tv[j+8];
    Tv[i+5]:=MaxR(0,Tv[i+1]-Tv[i+2]-Tv[i+3]-Tv[i+4]);
    Tv[199]:=Tv[199]+Tv[i+5];
    Tv[200]:=Tv[200]+Tv[i+6];
    Inc(i,7);
    Inc(j,9);
   until i>192;

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S513(RetNo: integer;FName: string;FNo: integer);
Var i,j:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  If IsLifeInsuranceCorp(RetNo)=False then
  begin
   For i:=4 to 64 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;
  If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
  //or (Ret[RetNo].Province = 'MJ') then
  //continue
  else
  begin
   For i:=4 to 64 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  CopyS513FromS9(RetNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[64]:=0;
   i:=6;
   Repeat
    Tv[64]:=Tv[64]+Tv[i];
    Inc(i,3);
   until i>63;
  //Tv[64 limits ??
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;




procedure S517(RetNo: integer;FName: string;FNo: integer);
Var i,j:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
  //or (Ret[RetNo].Province = 'MJ') then
  //continue
  else
  begin
   For i:=4 to 109 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
  end;

  CopyS517FromS23(RetNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[104]:=0;
   Tv[105]:=0;
   i:=5;
   Repeat
    If Tv[i+2]>0 then
      Tv[i+3]:=Tv[i]*Tv[i+1]/Tv[i+2]
    else
      Tv[i+3]:=0;
    Tv[104]:=Tv[104]+Tv[i];
    Tv[105]:=Tv[105]+Tv[i+3];
    Inc(i,5);
   until i>100;

   If Ret[RetNo].Province='ON' then
   begin
   for i:=106 to 108 do Tv[i]:=0;
   Tv[109]:=1;
   end
   else
   begin
    Tv[106]:=GetTxblIncomeInProv(RetNo,'ON');
    Tv[107]:=GetTxblIncome(RetNo);
    If Tv[106]=0 then Tv[106]:=1000;
    If Tv[107]=0 then Tv[107]:=1000;
    If Tv[107]>0 then
      Tv[108]:=RoundN(Tv[106]/Tv[107],4)
    else
      Tv[108]:=0;
   end;
   Strings[108]:=FormatFloat('##0.0000',Tv[108]);
   Strings[109]:=Strings[108];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S524(RetNo: integer;FName: string;FNo: integer);
Var i:Integer; done:Boolean;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);

 If ((Ret[RetNo].Province = 'ON')  or (IsMJWithOntario(RetNo))) then
 begin
  If (DateWithinTaxYear('2009/01/01',RetNo))
  Or (FetchElm(RetNo,'T2',28)+FetchElm(RetNo,'T2',30)>'') //first yr
  then
  //continue
 end
 else
 begin
  For i:=4 to 26 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  Ret[RetNo].Frm[FNo].Strings[27]:='';
  SaveTv(RetNo,FName,FNo);
  exit;
 end;
 Done:=false;
 with Ret[RetNo].Frm[Fno] do
 begin
 // Strings[27]:='';
  For i:=4 to 26 do
  begin
   If Strings[i]>''then
   begin
    Done:=True;
    If i=4 then Strings[27]:='01'
    else If i=5 then Strings[27]:='02'
    else If i=6 then  Strings[27]:='03'
    else If i=7 then Strings[27]:='04'
    else If i=9 then Strings[27]:='06'
    else If i=11  then Strings[27]:='08'
    else If i= 12 then Strings[27]:='09'
    else If i= 13 then Strings[27]:='10'
    else If i= 14 then Strings[27]:='11'
    else If i= 15 then Strings[27]:='12'
    else If i= 16 then Strings[27]:='13'
    else If i= 17 then Strings[27]:='14'
    else If i= 18 then Strings[27]:='15'
    else If i= 19 then Strings[27]:='16'
    else If i= 20 then Strings[27]:='17'
    else If i= 21 then Strings[27]:='18'
    else If i= 22 then Strings[27]:='19'
    else If i= 23 then Strings[27]:='20'
    else If i= 24 then Strings[27]:='21'
    else If i= 25 then Strings[27]:='22'
    else If i= 26 then Strings[27]:='99';
    If Strings[27]>'' then
    begin
     Ret[RetNo].FrmHasData[Fno] := True;  //20100530
     Break;
    end;
   end;
  end; {End with}
//  If Done=false then Strings[26]:='X';  //20100428
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure S525(RetNo: integer;FName: string;FNo: integer);
Var i:Integer; S5FNo:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
 else
 begin
 For i:=4 to 43 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
  SaveTv(RetNo,FName,FNo);
  exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
   Tv[6]:=MaxR(0,Tv[4]-Tv[5]);
   Tv[8]:=Tv[6]+Tv[7];
   Tv[9]:=Tv[8];
   Tv[10]:=Tv[19];  //20100408  Tv[13];
   Tv[11]:=MaxR(0,Tv[9]-Tv[10]);

   Tv[12]:=Tv[9];
   Tv[13]:=MinR(19950,Tv[12]);
   Strings[42]:=GetOntBasicTaxRate(RetNo);
   Tv[14]:=Round(Tv[13] * (Vl(Strings[42])/100));
   S5FNo:=GetFormNo('S5');
   Tv[15]:=MaxR(0,
            Vl(FetchElmFNo(RetNo,S5FNo,611))
           -Vl(FetchElmFNo(RetNo,S5FNo,612))
           -Vl(FetchElmFNo(RetNo,S5FNo,613))
           -Vl(FetchElmFNo(RetNo,S5FNo,614))
           -Vl(FetchElmFNo(RetNo,S5FNo,615))); //20171105
           //    -Vl(FetchElmFNo(RetNo,S5FNo,616)));
   Tv[16]:=MinR(Tv[14],Tv[15]);
   If UpperCase(Strings[41])<> 'Y' then  Tv[17]:=Tv[16];
   If Tv[17]>Tv[16] then Tv[17]:=Tv[16];
   Tv[18]:=Tv[17];
   Strings[43]:=GetOntBasicTaxRate(RetNo);
   //20100501
   If Strings[43]>''  then
   begin
     Tv[19]:=Round(Tv[18]/(Vl(Strings[43])/100));
     If Tv[19]>Tv[12] then Tv[19]:=Tv[12];
     If ABS(Tv[19]-Tv[12]) < 2.1 then Tv[19]:=Tv[12]; //approximation //20100903
   end
   else
     Tv[19]:=0;

  // Tv[40]:=AddColumns(20,39,1);   //20120503  gone

 end;
 SaveTv(RetNo,FName,FNo);
end;

(*
procedure S546(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsOntarioIncorporated(retNo))     //20120201
 or (IsMJWithOntario(RetNo)) then
 //or (Ret[RetNo].Province = 'MJ') then
  //continue
 else
 begin
   For i:=4 to 94 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;
 with Ret[RetNo].Frm[Fno] do
 begin
  Strings[4]:=GetCorpName(RetNo);
  //Strings[5]:= ?? inc/amalg date
  // strings[6]:= Ont Corp number
  //Strings[7]:= c/o  //??
  If Strings[6]>'' then Strings[6]:=RemoveNonNumericChars(Strings[6]);  //20141124
  If Strings[41]+Strings[42]='XX' then Strings[42]:='';
  If Strings[8]='' then Strings[8]:=FetchElm(RetNo,'T2',12);
  If Length(Strings[8])>8 then Strings[8]:=LeftStr(Strings[8],8);
  //Strings[11]:=??
  If Strings[12]='' then Strings[12]:=FetchElm(RetNo,'T2',16); //city
  If Strings[13]='' then Strings[13]:=FetchElm(RetNo,'T2',17); //prov
  If Strings[14]='' then Strings[14]:='CA';
  If Strings[15]='' then Strings[15]:=FetchElm(RetNo,'T2',20); //postal

 // If Strings[68]='' then Strings[68]:='1';

  If Strings[16]='' then Strings[16]:=FetchElm(RetNo,'T2',742);  //last nm
  If Strings[17]='' then Strings[17]:=FetchElm(RetNo,'T2',743);  //first nm  //20141124
  If Strings[17]>'' then Strings[17]:=LeftStr(Strings[17],20);        //20141124

  If Strings[69]='' then
  Begin
   If UpperCase(FetchElm(RetNo,'T2',744))='DIRECTOR' then
     Strings[69]:='1';
  end;


  If Strings[68]='1' then Strings[29]:=''; //no change
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S547(RetNo: integer;FName: string;FNo: integer);
Var i,S546FNo:Integer;Finst:String;
begin
 FInst:=ExtractFormInst(FName);
 If FInst='#1' Then
 begin
  S546FNo:=GetFormNo('S546');
  For i:=30 to 94 do StoreElm(RetNo,FNo,i,FetchElmFNo(RetNo,S546FNo,i));
 end;

 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsOntarioIncorporated(RetNo))
 or (IsMJWithOntario(RetNo)) then
  //continue
 else
 begin
   For i:=30 to 94 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;
 with Ret[RetNo].Frm[Fno] do
 begin
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S548(RetNo: integer;FName: string;FNo: integer);
Var i:Integer; Page1FNo:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo))
  or (Ret[RetNo].Province ='OC')
  then
  //continue
 else
 begin
   For i:=4 to 54 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;
 Page1FNo:=GetFormNo('T2');
 with Ret[RetNo].Frm[Fno] do
 begin
  Strings[4]:=GetCorpName(RetNo);
 // Strings[7]:= FetchElmFNo(RetNo,Page1FNo,
  If Strings[8]='' then Strings[8]:= FetchElmFNo(RetNo,Page1FNo,12);
  If Length(Strings[8])>8 then Strings[8]:=LeftStr(Strings[8],8);  //20141124
  If Strings[12]='' then Strings[12]:=FetchElmFNo(RetNo,Page1FNo,16);
  If Strings[13]='' then Strings[13]:=FetchElmFNo(RetNo,Page1FNo,17);
  If Strings[14]='' then Strings[14]:=FetchElmFNo(RetNo,Page1FNo,19);
  If Strings[15]='' then Strings[15]:=FetchElmFNo(RetNo,Page1FNo,20);
  { cannot be used
  If InValuesOnly('1,2',RetNo,FormName,68,Strings[68]) = false then
   Strings[68]:='2';
  }
  if Strings[16]='' then Strings[16]:=FetchElm(RetNo,'T2',742);  //last nm
  If Strings[17]='' then Strings[17]:=FetchElm(RetNo,'T2',743);  //first nm


  Strings[26]:='Ontario';
  Strings[27]:='Canada';
  If Strings[43]>'' then
  begin
   Strings[55]:='ON';
   Strings[56]:='CA';
  end
  else
  begin
   Strings[55]:='';
   Strings[56]:='';
  end;
  //Strings[28]:=FetchElm(RetNo,'T2',35);
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;
*)

procedure S550(RetNo: integer;FName: string;FNo: integer);
Var i,j,j1,j2,jj1,jj2:Integer; Percent1,Percent2:Real;WpBegin,WpEnd:String;WBef,WTot:Real;
begin
 WBef := 0; //20150701
 WTot := 0; //20150701

 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsMJWithOntario(RetNo))
 //or (Ret[RetNo].Province = 'MJ')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[12])='')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[13])='')
 then
  //continue
 else
 begin
   For i:=4 to 76 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
  If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
  If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);
  If Tv[10]=0 then Tv[10]:=100;
  If Strings[11]+Strings[12]='' then Strings[11]:='X';
  If Strings[13]+Strings[14]='' then Strings[14]:='X';
  If Strings[7]+Strings[8]='' then Strings[8]:='X';

  If Tv[15]<=400000 then Percent1:=15
  else If Tv[15]>=600000 then Percent1:=10
  else Percent1:=Round(15 - (5 * (MaxR(0,400000))/200000));
  Tv[16]:=Percent1;

  If Tv[15]<=400000 then Percent2:=30
  else If Tv[15]>=600000 then Percent2:=25
  else Percent2:=Round(30 - (5 * (MaxR(0,400000))/200000));
  Tv[77]:=Percent2;

  //page 2
  i:=23;j:=78; //j=after merch 26
  j1:=21;J2:=22;
  jj1:=83; JJ2:=88;  //num of weeks
  Tv[73]:=0;
  Repeat
   Tv[i+1]:=Round(Tv[i]*Percent1/100+Tv[j]*Percent2/100);
   If (Strings[j1] > '2009/03/26') or (Tv[i]=0) then Strings[jj1]:=''; //no expend before march 27, 2009
   WpBegin:=Strings[j1];
   WpEnd:=Strings[j2];
   If DateWithinDates('2009/03/26',WpBegin,WpEnd) then
   begin

     Wbef:=Trunc(DateDiffYMD(WpBegin,'2009/03/26')/7);    // divide by 7 days to get weeks
     WTot:=Trunc(DateDiffYMD(WpBegin,WpEnd)/7);

     Strings[jj1]:=FormatFloat('###.##',WBef);
     Strings[jj2]:=FormatFloat('###.##',WTot);
   end;

   Tv[i+2]:=Tv[i+1];
   If WpEnd<'2009/03/27' then Tv[i+2]:=1000
   else If Wpbegin>'2009/03/26' then Tv[i+2]:=3000
   else if ((Wpbegin<'2009/03/27') and (WpEnd>'2009/03/26')) then
   begin
    If WTot>0 then
      Tv[i+2]:=1000*(Wbef/WTot) + 3000 *(WTot-WBef)/WTot
    Else
      Tv[i+2]:=0;
   end;
   If Tv[i+1]=0 then Tv[i+2]:=0;


   Tv[i+3]:=MinR(Tv[i+1],Tv[i+2]);
   If Tv[i+4]=0 then Tv[i+5]:=Tv[i+3] else Tv[i+5]:=Tv[i+4];
   Tv[73]:=Tv[73]+Tv[i+5];
   Inc(i,11);
   Inc(j1,11);
   Inc(j2,11);
   Inc(j,1);
   Inc(jj1,1);
   Inc(jj2,1);
  until i>67;

  If Strings[7]>'' then
  begin
   Tv[74]:=Tv[73];
   Tv[75]:=Tv[10];
   Tv[76]:=Round(Tv[74] * Tv[75]/100);
   Tv[17]:=Tv[76];
  end
  Else
  begin
   Tv[74]:=0;
   Tv[75]:=0;
   Tv[76]:=0;
   Tv[17]:=Tv[73];
  end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;






//20160508  JOHN
procedure S552(RetNo: integer;FName: string;FNo: integer);
Var i,I1,I2,j,J1,j2,H1,H2,E1,k:Integer; Percent1,Percent2:Real;Dt:String; //e1=Program started
    BeforeApr24:Boolean;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo))
 //or (Ret[RetNo].Province = 'MJ')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[12])='')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[13])='')
 then
  //continue
 else
 begin
   For i:=4 to 95 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
  If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
  If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);
  If Strings[7]+Strings[8]='' then Strings[8]:='X';
  If Tv[10]=0 then Tv[10]:=100;
  If Strings[11]+Strings[12]='' then Strings[11]:='X';
  If Strings[13]+Strings[14]='' then Strings[14]:='X';

  //calc 2 percentages
  Tv[81]:=MaxR(0,Tv[15]-400000);  //20160515
  If Tv[15]<=400000 then Percent1:=45 //30 //jz percent changed
  else if Tv[15]>=600000 then percent1:=35//25 //jz percent changed
  else Percent1:=45-10 * Round(Tv[81]/200000); ////jz percent formula changed
  Tv[16]:=Percent1;

  Tv[87]:=MaxR(0,Tv[15]-400000);  //20160515  //Tv[15];
  If Tv[15]<=400000 then Percent2:=30 //45 //jz percent changed
  else if Tv[15]>=600000 then percent2:=25 //35 //jz percent changed
  else Percent2:=30-5 * Round(Tv[87]/200000);
  Tv[117]:=Percent2;

  //20130603  Pg2
  i2:=20;
  Repeat
   Strings[i2]:=LeftStr(Strings[i2],12);
   Inc(i2,4);
  until i2>36;



  //page 2
  i:=38;
  i2:=20;
  j:=40;
  H1:=107;
  H2:=112;
  E1:=37;
  Repeat
   If UpperCase(Strings[63]) <> 'Y' then   //ovveride
   begin
    Strings[H1]:='';
    Strings[H2]:='';
    if (Strings[i]>'') and (Strings[i+1]='')  then Strings[i+1]:=GetBegYearEnd(RetNo);  //20160515
    if Strings[E1]<'2015/04/24' then
      BeforeApr24:=True
    else
      BeforeApr24:=False;

    if BeforeApr24=True then  //20160604
    begin
     Strings[H1]:=IntToStr(DateDiffYMD(Strings[i],Strings[i+1]));  //20160515
     If Strings[i]='' then Strings[H1]:='';
     Strings[H2]:='';   //20160610
    end
    Else
    begin
     Strings[H2]:=IntToStr(DateDiffYMD(Strings[i],Strings[i+1]));
     If Strings[i]='' then Strings[H2]:='';
     Strings[H1]:='';
    end;
   end;
   If Vl(Strings[H1])<0 then Strings[H1]:='';
   If Vl(Strings[H2])<0 then Strings[H2]:='';

   if Strings[i2]>''  then //contract exists   //20160515
   begin
     Tv[i+3]:=Round(10000 * MyStrToInt(Strings[H1])/365+ 5000 *MyStrToInt(Strings[H2])/365); //20160620
     //If UpperCase(Strings[123])='Y' then
     If (CurrentYearIsLeap(RetNo)) and (DateWithinTaxYear('2016/02/29',RetNo)) then //20160612
      Tv[i+3]:=Round(10000 * MyStrToInt(Strings[H1])/366+ 5000 *MyStrToInt(Strings[H2])/366); //20160620
   end
   Else
    Tv[i+3]:=0;

   Inc(i,5);
   Inc(i2,4);
   Inc(H1,1);
   Inc(H2,1);
   Inc(E1,5);
  until i>58;

  //20160515
  H1:=107;
  H2:=112;
  I:=41;
  E1:=37;
  J1:=97;
  J2:=102;
  K:=64;
  Tv[92]:=0;
  Repeat

 //  Tv[i]:= 10000 * MyStrToInt(Strings(H1))/365+ 5000 * MyStrToInt(Strings(H2))/365; //one of the  //20160612
   Tv[k]:=Tv[j1] * Percent1/100 + Tv[J2] * Percent2/100;
   Tv[k+1]:=MinR(Tv[i],Tv[k]);
   If Tv[k+2]=0 then Tv[K+3]:=Tv[k+1] else Tv[K+3]:=Tv[k+2];
   Tv[92]:=Tv[92]+Tv[k+3];
   Inc(H1,1);
   Inc(H2,2);
   Inc(i,5);
   Inc(j1,1);
   Inc(J2,1);
   Inc(k,6);
   Inc(E1,5);
  until H1>111;

  If Strings[7]>'' then
  begin
  Tv[93]:=Tv[92];
  Tv[94]:=Tv[10];
  Tv[95]:=Round(Tv[93] * Tv[94]/100);
  Tv[96]:=Tv[95];
  end
  Else
  begin
   Tv[93]:=0;
   Tv[94]:=0;
   Tv[95]:=0;
   Tv[96]:=Tv[92];
  end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

//20260903 Alex >>>
procedure S554(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  FillHeader(RetNo, FNo, 1, 2, 3);

  If (Ret[RetNo].Province = 'ON') or (IsMJWithOntario(RetNo)) then //ok to continue
  else
  begin
    for i:= 4 to 67 do
    begin
      Ret[RetNo].Frm[FNo].Strings[i]:= '';
      Ret[RetNo].Frm[FNo].Tv[i]:= 0;
    end;
    SaveTv(RetNo, FName, FNo);
    exit;
  end;

  with Ret[RetNo].Frm[Fno] do
  begin
    if Strings[10] + Strings[11] = '' then Strings[10]:= 'X';
    if Strings[12] + Strings[13] = '' then Strings[13]:= 'X';
    if Strings[14] + Strings[15] = '' then Strings[15]:= 'X';
    if Strings[16] + Strings[17] = '' then Strings[17]:= 'X';

    //Page 2
    Tv[49]:= Tv[43] + Tv[45] + Tv[46] + Tv[47] + Tv[48];
    Tv[50]:= Tv[49];
    Tv[54]:= MaxR(0, Tv[50] - Tv[53]);
    Tv[58]:= Tv[56];
    Tv[66]:= Tv[54];
    Tv[67]:= Tv[57];
    if Tv[67] > 0 then Tv[59]:= Round(Tv[58] * Tv[66] / Tv[67]) else Tv[59]:= 0;
    Tv[60]:= Tv[55] + Tv[59];

    //Page 3
    Tv[24]:= Tv[18] + Tv[42] + Tv[40] + Tv[41] + Tv[23]; //jz Tv[22] line removed
    Tv[25]:= Tv[24];
    Tv[68]:= MaxR(0, Tv[25] - Tv[28] + Tv[21]); //20260903 Alex
    Tv[39]:= Tv[68]; //20260903 Alex
    Tv[29]:= MaxR(0, Tv[39] - Tv[69]); //20260903 Alex
    //Tv[29]:= MaxR(0,TV[25]-TV[28]); //20260903 Alex

    //Part 7
    Tv[30]:= Tv[39]; //20260903 Alex
    Tv[70]:= Tv[69]; //20260903 Alex
    Tv[71]:= Tv[30] - Tv[70]; //20260903 Alex
    Tv[72]:= Tv[71]; //20260903 Alex
    Tv[73]:= Tv[69]; //20260903 Alex
    Tv[74]:= Tv[31] - Tv[73]; //20260903 Alex
    Tv[33]:= Tv[74]; // Tv[31]; //20260903 Alex
    Tv[34]:= Tv[39]; //Tv[29]; //20260903 Alex
    Tv[35]:= Tv[32];

    if Tv[35] > 0 then Tv[36]:= Tv[33] * Tv[34] / Tv[35] else Tv[36]:= 0;
    Tv[37]:= Tv[72] + Tv[36];//Tv[30] + Tv[36]; //20260903 Alex

    //Page 4. Part 8
    Tv[61]:= MaxR(0, Tv[29] - Tv[37]); //20160601
    Tv[62]:= MaxR(0, Tv[54] - Tv[60]); //20160601
    //Tv[63]:= Round(Tv[61] * 20/100); //20260903 Alex
    if (Tv[61] > 0) then //20260903 Alex
      Tv[64]:= Round(Tv[61] * 0.18) //20260903 Alex
    else //20260903 Alex
      Tv[64]:= Round(Tv[62] * 0.18); //20260903 Alex

    //Tv[65]:= Tv[63] + Tv[64]; //20260903 Alex
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260903 Alex <<<

procedure S556(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;FirstTimeProduction:Boolean;Qle:Real;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo))
 //or (Ret[RetNo].Province = 'MJ')
 Or (Ret[RetNo].Frm[FNo].Strings[31]='')
 then
  //continue
 else
 begin
   For i:=4 to 106 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
  If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
  If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);

  If Strings[10]+Strings[11]='' then Strings[10]:='X';
  If Strings[12]+Strings[13]='' then Strings[13]:='X';
  If Strings[14]+Strings[15]='' then Strings[15]:='X';
  If Strings[16]+Strings[17]='' then Strings[17]:='X';

  If Strings[10]>'' then FirstTimeProduction:=true else FirstTimeProduction:=False;
  If Ret[RetNo].CorpType = CCPC then
  begin
   Strings[9]:='X';
   Strings[20]:='';
  end
  Else
  begin
   Strings[9]:='';
   Strings[20]:='X';
  end;

  If Strings[21]+Strings[22]='' then Strings[21]:='X';
  If Strings[23]+Strings[24]='' then Strings[23]:='X';
  If Strings[25]+Strings[26]='' then Strings[26]:='X';
  If Strings[27]+Strings[28]='' then Strings[28]:='X';
  If Strings[29]+Strings[30]='' then Strings[30]:='X';

  If Strings[31]+Strings[32]='' then Strings[32]:='X';
  Tv[39]:=AddColumns(34,38,1);
  Tv[40]:=Tv[39];
  Tv[43]:=Tv[33]+Tv[40];
  Qle:=Tv[45];
  //part 5
  If Tv[49]>0 then
  begin
   Tv[50]:=Tv[48];
   Tv[51]:=MaxR(0,Tv[62]-Tv[64]);
   Tv[52]:=Tv[49];
   Tv[53]:=RoundCorrect(Tv[50] * (Tv[51]/Tv[52]));
  end
  Else
   Tv[53]:=0;

  Tv[54]:=Tv[47]+Tv[53];

  //20100518
  Tv[73]:=Tv[119]+Tv[55]+Tv[120];
  Tv[84]:=Tv[73];
  Tv[56]:=MaxR(0,TV[54]-Tv[84]); //MaxR(0,TV[54]-Tv[55]);

  Tv[57]:=Tv[43];
  Tv[60]:=MaxR(0,Tv[58]-Tv[59]);
  Tv[61]:=Tv[60];
  Tv[62]:=Tv[57]+Tv[61];
  Tv[63]:=Tv[56];
  Tv[65]:=Tv[63]+Tv[64];
  Tv[66]:=Tv[65];
  Tv[67]:=MaxR(0,Tv[62]-Tv[66]);

  //page 4 conditional ??
  //If FirstTimeProduction Strings[11]>'' then Strings[107]:='N';
  If UpperCase(Strings[107])='N' then
  begin
   For i:=70 to 72 do Tv[i]:=0;  //20120331
   For i:=74 to 83 do Tv[i]:=0;  //20120331
   For i:=87 to 93 do Tv[i]:=0;  //20120331
   For i:=110 to 110 do Tv[i]:=0;//For i:=110 to 115 do Tv[i]:=0;
  end
  else
  Begin
   Tv[71]:=240000;
   Tv[72]:=Tv[59];
   Tv[110]:=MaxR(0,Tv[71]-Tv[72]);
   {
   Tv[70]:=Tv[68];
   Tv[74]:=MinR(Tv[110],Tv[70]);
   Tv[75]:=MaxR(0,Tv[70]-Tv[74]);
   Tv[76]:=Tv[75]*30/100;
 //  Tv[73]:=MaxR(0,Tv[71]-Tv[72]);    //20120331
   Tv[77]:=Tv[74];
   Tv[78]:=Tv[77]*40/100;
   }
   Tv[79]:=Tv[67];
   Tv[80]:=MinR(Tv[79],Tv[110]);
   Tv[87]:=MaxR(0,Tv[79]-Tv[80]);
   Tv[88]:=Round(Tv[87]*35/100);
   Tv[89]:=Tv[80];
   Tv[90]:=Round(Tv[89]*40/100);
   If FirstTimeProduction then
   begin
     Tv[91]:=Tv[67];
     Tv[92]:=Round(Tv[91]*10/100);
     Tv[93]:=Tv[88]+Tv[90]+Tv[92];
   end;
  end;
  //Page 5
  //part 8 conditional ??
 // If Strings[11]>'' then Strings[108]:='N';
  If UpperCase(Strings[108])='N' then
  begin
   For i:=94 to 99 do Tv[i]:=0;
  end
  Else
  Begin
   Tv[94]:=MinR(50000,Tv[67]);
   //Tv[95]:=  ??              //user?
   Tv[97]:=MaxR(0,TV[95]-Tv[96]);
   Tv[98]:=Tv[97];
   Tv[99]:=MinR(Tv[94],Tv[98]);
  end;
  //Part 9
  If FirstTimeProduction = True then
  begin
   Tv[116]:=0; Tv[117]:=0;
   Tv[104]:=0; Tv[105]:=0;
  end
  Else
  Begin
   Tv[116]:=Tv[67];
   Tv[117]:=Round(Tv[116]*35/100);
   If Strings[12]>'' then  //regional bonus  //20120331
   Begin
    Tv[104]:=Tv[67];
    Tv[105]:=Round(Tv[104]*10/100);
   End
   Else
   Begin
    Tv[104]:=0;
    Tv[105]:=0;
   End;
  end;
  Tv[106]:=Tv[117]+Tv[105];
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

//20160510  John  revised by Con 20160510
procedure S558(RetNo: integer;FName: string;FNo: integer);
Var i:Integer; S5FNo:Integer;
begin
  S5FNo:=GetFormNo('S5');   //20160602
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  //20160510  Initialize it as qualified until user changes the check boxes
  with Ret[RetNo].Frm[Fno] do
  begin
   If Strings[12]+Strings[13]='' then Strings[12]:='X';
   If Strings[14]+Strings[15]='' then Strings[15]:='X';
   If Strings[16]+Strings[17]='' then Strings[17]:='X';
   If Strings[18]+Strings[19]='' then Strings[19]:='X';
   If Strings[20]+Strings[21]='' then Strings[21]:='X';
  end;

   //20160510   //If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  If ((Ret[RetNo].Province = 'ON') or (IsMJWithOntario(RetNo)))
  and (Ret[RetNo].Frm[FNo].Strings[12]>'')
  and (Ret[RetNo].Frm[FNo].Strings[15]>'')
  and (Ret[RetNo].Frm[FNo].Strings[17]>'')
  and (Ret[RetNo].Frm[FNo].Strings[19]>'')
  and (Ret[RetNo].Frm[FNo].Strings[21]>'')
  then
   //continue if above is true
  Else
  begin  //remove all data and save the screen data to arrays
    For i:=4 to 89 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;  //not 57    //20160510 Con
    SaveTv(RetNo,FName,FNo);
    exit;
  end;


  with Ret[RetNo].Frm[Fno] do
  begin
   If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
    //If empty assume contact is the one who signed the T2 on page 8. But user can change it
   Tv[63]:=Tv[56]+Tv[60]+Tv[61]+Tv[62];
   Tv[64]:=Tv[63];
   Tv[91]:=Tv[55]+Tv[64]+Tv[65]+Tv[68];  //20160510
   Tv[69]:=Tv[91]+Tv[90]; //20160510 //Tv[69]:=Tv[55]+Tv[64]+Tv[65]+Tv[68]+Tv[90];  //20121206

   //Part 5
   Tv[72]:=MaxR(0,Tv[70]-Tv[71]);
   Tv[73]:=Tv[72];
   //20160602
   if Tv[55]>0 then
   begin
    Tv[74]:=Ret[RetNo].Ln[796] + Ret[RetNo].Ln[780]; //can film and ITC pg 8
   end
   Else
   begin
    Tv[74]:=0;
    Tv[75]:=0;
   end;

   Tv[76]:=Tv[74]+Tv[75];
   Tv[77]:=Tv[76];
   Tv[88]:=MaxR(0,Tv[73]-Tv[77]);  //20101120
   Tv[78]:=Tv[88];


   //Part 6 //jz many changes / new from here
  // Tv[89]:=Tv[69];   //20160510
   //Tv[79]:=Tv[78]; //jz ?? not sure is valid

   Tv[82]:=Tv[79]+Tv[80]+Tv[22]+Tv[24]; //20160510 //Tv[82]:=Tv[79]+Tv[81]+Tv[22]+Tv[24]  ; //jz Tv[80] removed added 22,24
   Tv[83]:=Tv[82];

   //Tv[84]:=MaxR(0,Tv[89]-Tv[83]);  //jz removed  //20101120

   Tv[29] := Tv[89]+Tv[83]+Tv[25]+Tv[28];

   //jz removed
   //Tv[53]:=Tv[52]; //20140408
   //Tv[85]:=Tv[84];
   //Tv[86]:=Round(Tv[85] * 25/100);
   //Tv[57]:=Tv[86]; //20140408 Tv[54]+Tv[59]+Tv[86];  //20100517

   Tv[31] := Tv[29]+Tv[30];

   //Part 7
   Tv[34] := maxR(0,Tv[32]-Tv[33]);
   Tv[35] := Tv[34];

   //20160602
   if Tv[89]>0  then
   Begin
    Tv[36]:=Ret[RetNo].Ln[796] + Ret[RetNo].Ln[780]; //can film and ITC pg 8
   End
   Else
   begin
    Tv[36]:=0;
    Tv[37]:=0;
   end;

   Tv[38] := Tv[36]+Tv[37];
   Tv[39] := Tv[38];

   Tv[40] := maxR(0,Tv[35]-Tv[39]);
   Tv[41] := Tv[40];

   //part 8
   Tv[42] := Tv[69];
   Tv[43] := Tv[78];

   Tv[46] := Tv[43]+Tv[44]+Tv[45];
   Tv[47] := Tv[46];

   Tv[48] := maxR(0,Tv[42]-Tv[47]);

   //part 9

   Tv[49] := Tv[31];  // All the time regardless of tax fiscal start? //20160510
   Tv[50] := Tv[41];
   Tv[53] := Tv[50]+Tv[51]+Tv[52];
   Tv[54] := Tv[53];
   Tv[58] := maxR(0,Tv[49]-Tv[54]);  //20160609

   Tv[93] := Tv[59]+Tv[87]+Tv[92];
   Tv[94] := Tv[93];
   Tv[95] := Tv[94]*4;
   Tv[96] := Tv[41];

   Tv[57]:=Tv[96]+Tv[23];  //20160516
   Tv[81]:=Tv[57];
   Tv[97] := MaxR(0,Tv[95]-Tv[81]);  //Negative if <0 ??
  // Tv[97] := Tv[95]-Tv[96];  //Negative if <0 ??
   Tv[98] := Tv[97];

   //Part 9: DFM must have had If tax year starts before April 24, 2015 as per PDF  //20160510  (fixed now)
   If GetTaxationYearStart(RetNo) <'2015/04/24' then //20160510 if strings[105] = 'X' then
     Tv[99] := Tv[58]
   else //if strings[106] = 'X' then   //20160510
     Tv[99] := minR(Tv[58],Tv[98]);

   //part 10
   Tv[100] := Tv[48];
   Tv[101] := round(Tv[100]*25/100);

   Tv[102] := Tv[99];
   Tv[103] := round(Tv[102]*21.5/100);

   Tv[104] := Tv[101]+Tv[103];

  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;



procedure S560(RetNo: integer;FName: string;FNo: integer);
Var i:Integer; IsQSC:Boolean; IsSpecifiedProduct:Boolean;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo))
 //or (Ret[RetNo].Province = 'MJ')
 or (Ret[RetNo].Frm[FNo].Strings[11]='')
 or (Ret[RetNo].Frm[FNo].Strings[12]='')
 or (Ret[RetNo].Frm[FNo].Strings[14]='')
 or (Ret[RetNo].Frm[FNo].Strings[16]='')
 then
  //continue
 else
 begin
   For i:=4 to 82 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
  If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
  If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);
  If Strings[10]+Strings[11]='' then Strings[10]:='X';
  If Strings[12]+Strings[13]='' then Strings[13]:='X';
  If Strings[14]+Strings[15]='' then Strings[15]:='X';
  If Strings[16]+Strings[17]='' then Strings[17]:='X';
  //page 2
  If Strings[18]+Strings[19]='' then Strings[19]:='X';
  If Strings[20]+Strings[21]='' then Strings[20]:='X';
  IsSpecifiedProduct:=Strings[18]>'';
  IsQsc:=Strings[20]>'';

  {//20180502
  Tv[26]:=Tv[23]+Tv[24]+Tv[25];
  Tv[28]:=Round(Tv[26]*50/100);
  }
 // Tv[28]:=Tv[27];  //20100826
  Tv[90]:=Tv[22]+Tv[87]+Tv[88]+Tv[89]; //28];
  Tv[31]:=Tv[29]+Tv[30];
  Tv[32]:=Tv[31];

  Tv[58]:=Tv[33]+Tv[34];
  Tv[59]:=Tv[58];
  Tv[60]:=MaxR(0,Tv[32]-TV[59]);
  Tv[61]:=Tv[60];
  Tv[62]:=Tv[90]+Tv[61];    //20100906

  Tv[65]:=MaxR(0,TV[63]-TV[64]);
  Tv[66]:=Tv[65];
  Tv[93]:=MaxR(0,TV[62]-Tv[66]);

  //page 3
  If IsSpecifiedProduct = False then
  begin
  Tv[35]:=100000;
  Tv[38]:=Tv[36]+Tv[37];
  Tv[39]:=Tv[38];
  Tv[40]:=MaxR(0,Tv[35]-Tv[39]);
  Tv[41]:=Tv[40];

  Tv[44]:=Tv[42]+Tv[43];
  Tv[45]:=Tv[44];

  Tv[48]:=MaxR(0,Tv[46]-Tv[47]);
  Tv[49]:=Tv[48];

  Tv[52]:=Tv[50]+Tv[51];
  Tv[53]:=Tv[52];

  Tv[56]:=Tv[54]+Tv[55];
  Tv[57]:=Tv[56];
  Tv[70]:=Tv[49]+Tv[53]+Tv[57];
  Tv[71]:=Tv[70];
  Tv[72]:=MaxR(0,Tv[45]-Tv[71]);
  Tv[96]:=MinR(Tv[41],Tv[72]);
  end
  else
  begin
    For i:=35 to 57 do Tv[i]:=0;
    For i:=70 to 72 do Tv[i]:=0;
    Tv[96]:=0;
  end;
  //page 4
  Tv[113]:=Tv[110]+Tv[111]+Tv[112];
  Tv[130]:=Tv[113];

  Tv[116]:=Tv[114]+Tv[115];
  Tv[117]:=Tv[116];
  Tv[124]:=Tv[109]+Tv[130]+Tv[117];

  Tv[120]:=Tv[118]+Tv[119];
  Tv[121]:=Tv[120];
  //20150511
 // Tv[122]:=MaxR(0,Tv[117]-Tv[121]);
 // Tv[123]:=Tv[122];
  //Tv[124]:=Tv[109]+Tv[130]+Tv[117]; //Tv[123];

  Tv[127]:=MaxR(0,Tv[125]-Tv[126]);
  Tv[128]:=Tv[127];
  Tv[129]:=MaxR(0,Tv[124]-Tv[121]-Tv[128]);
  //page 5
  Tv[135]:=Tv[132]+Tv[133]+Tv[134];
  Tv[136]:=Tv[135];
  Tv[137]:=Tv[131]+Tv[136];

  Tv[140]:=MaxR(0,Tv[138]-Tv[139]);
  Tv[141]:=Tv[140];
  Tv[142]:=MaxR(0,Tv[137]-Tv[141]);

  //page 6  //20210531
  If IsSpecifiedProduct = true then
  begin
   Tv[69]:=Tv[93];
   Tv[74]:=Round(Tv[69] * 35/100);
   Tv[81]:=0;
   Tv[82]:=0;
   Tv[103]:=0;
   Tv[104]:=0;
   Tv[85]:=0;
  end
  Else  //non specified product
  Begin
    If isQsc=True then
    Begin
     Tv[81]:=Tv[93]+Tv[96];
     Tv[82]:=Round(Tv[81]*40/100);
     Tv[103]:=0;
     Tv[104]:=0;
    end
    Else
    Begin
      Tv[81]:=0;
      Tv[82]:=0;
      Tv[103]:=Tv[93]+Tv[96];
      Tv[104]:=Round(Tv[103]*40/100);
    end;
  // end
  End;

  Tv[85]:=MaxR(Tv[82],Tv[104]);
  Tv[105]:=Tv[129];
  Tv[106]:=Round(Tv[105]*35/100);
  Tv[107]:=Tv[142];
  Tv[108]:=Round(Tv[107]*35/100);

  Tv[86]:=MaxR(MaxR(Tv[74],Tv[85]), MaxR(Tv[106],Tv[108])); //20210531
  //Tv[86]:=Tv[74]+Tv[85]+Tv[106]+Tv[108];
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


procedure S562(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
 //or (Ret[RetNo].Province = 'MJ') then
  //continue
 else
 begin
   For i:=4 to 81 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
  If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);
  If Strings[8]+Strings[9]='' then Strings[9]:='X';
  If Tv[11]=0 then Tv[11]:=100;
  //page 2
  If Ret[RetNo].CorpType = CCPC then
  begin
   Strings[18]:='X';
   Strings[19]:='';
  end
  Else
  begin
   Strings[18]:='';
   Strings[19]:='X';
  end;
  If Strings[20]+Strings[21]='' then Strings[21]:='X';
  If Strings[22]+Strings[23]='' then Strings[22]:='X';
  If Strings[24]+Strings[25]='' then Strings[25]:='X';

  Tv[36]:=AddColumns(26,35,1);
  Tv[61]:=AddColumns(39,59,2);
  Tv[62]:=AddColumns(40,60,2);
  //page 3
  Tv[63]:=Tv[36]+Tv[37]+Tv[61];
  Tv[64]:=Tv[38]+Tv[62];

  Tv[65]:=Tv[64];
  Tv[66]:=Round(Tv[65]*50/100);
  Tv[68]:=Tv[66]+Tv[67];
  Tv[69]:=Tv[68];
  Tv[70]:=TV[63]+Tv[69];
  Tv[71]:=Tv[70];
  Tv[74]:=Tv[72]+Tv[73];
  Tv[75]:=Tv[74];
  Tv[76]:=MaxR(0,Tv[71]-TV[75]);

  Tv[77]:=TV[76];
  Tv[78]:=Round(Tv[77]*20/100);
  If Strings[8]>'' then
  begin
   Tv[79]:=Tv[78];
   Strings[80]:=Strings[11];
   Tv[81]:=Round(Tv[79] * Vl(strings[80])/100);
   Tv[82]:=Tv[81];
  end
  else
  begin
   Tv[79]:=0;
   Tv[80]:=0;
   Tv[81]:=0;
   Tv[82]:=Tv[78];
  end;
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S564(RetNo: integer;FName: string;FNo: integer);
Var i:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsMJWithOntario(RetNo))
 //or (Ret[RetNo].Province = 'MJ')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[19]) = '')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[21]) = '')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[22]) = '')
 or (UpperCase(Ret[RetNo].Frm[FNo].Strings[24]) = '')
 then
  //continue
 else
 begin
   For i:=4 to 56 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[7]='' then Strings[7]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
  If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
  If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);
  If Strings[8]+Strings[9]='' then Strings[9]:='X';
  If Tv[11]=0 then Tv[11]:=100;
  If Strings[9]>'' then Tv[11]:=0;
  If Ret[RetNo].CorpType = CCPC then
  begin
   Strings[18]:='X';
   Strings[19]:='';
  end
  Else
  begin
   Strings[18]:='';
   Strings[19]:='X';
  end;
  If Strings[20]+Strings[21]='' then Strings[20]:='X';
  If Strings[22]+Strings[23]='' then Strings[23]:='X';
  If Strings[24]+Strings[25]='' then Strings[25]:='X';
  //page 2
  Tv[30]:=Tv[27]+Tv[28]+Tv[29]+Tv[58];//Tv[27]+Tv[28]+Tv[29]; //20100517
  Tv[31]:=Tv[30];
  Tv[33]:=Round(Tv[32] * 50/100);
  Tv[36]:=Round(Tv[35] * 50/100);
  Tv[39]:=Tv[34]+Tv[36]+Tv[37]+Tv[38];
  Tv[40]:=Tv[39];
  Tv[41]:=Tv[26]+Tv[31]+Tv[33]+Tv[40];

  Tv[44]:=Tv[42]+Tv[43];
  Tv[45]:=Tv[44];
  Tv[46]:=MaxR(0,Tv[41]-Tv[45]);

  Tv[47]:=Tv[46];
  Tv[48]:=Round(Tv[47] * 30/100);
  Tv[49]:=Tv[48];
  Tv[51]:=MaxR(0,Tv[49]-Tv[50]);
  Tv[52]:=Tv[51];
  Tv[53]:=MinR(Tv[48],Tv[52]);
  If Tv[11]>0 then
  begin
   Tv[54]:=Tv[53];
   Tv[55]:=Tv[11];
   Tv[56]:=Tv[54] * Tv[55]/100;
  end
  Else
  begin
   Tv[54]:=0;
   Tv[55]:=0;
   Tv[56]:=0;
  end;
  Tv[57]:=MaxR(Tv[53],Tv[56]);
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S566(RetNo: integer;FName: string;FNo: integer);
Var i,j:Integer; AA,BB,x:Real; CC,DD:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
  or (IsMJWithOntario(RetNo)) then
 //or (Ret[RetNo].Province = 'MJ') then
  //continue
 else
 begin
   For i:=4 to 282 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;
 with Ret[RetNo].Frm[Fno] do
 begin
    //Part 1
    If Strings[4]+Strings[5]='' then Strings[4]:='X';
    If Strings[6]+Strings[7]='' then Strings[7]:='X';
    If Strings[8]+Strings[9]='' then Strings[8]:='X';
    If Strings[10]+Strings[11]='' then Strings[10]:='X';
    If Strings[12]+Strings[13]='' then Strings[12]:='X';

    //Part 2
    //20171201
    if (Ret[RetNo].Province='ON') and (Strings[15]='') then Strings[15]:='Y';
    If UpperCase(Strings[15])='Y' then //all Ontario
    Begin
     If UpperCase(Strings[14])<>'Y' then Tv[17]:=Vl(FetchElm(RetNo,'S508',4));  //202020131
     {
     Tv[17]:= Vl(FetchElm(RetNo,'T661',123));
     If FetchElm(RetNo,'T661',104)>'' then Tv[17]:=Tv[17]+Vl(FetchElm(RetNo,'T661',141)); //if proxy amount
     }
    End;
    //20170110
    {
    Tv[16] := Tv[15] * 0.40;
    Tv[17] := Tv[14] + Tv[16];
    }

    //Part 3
    Tv[21] := Tv[20] * 25/100;
    Tv[22] := Tv[19] + Tv[21];
    Tv[23] := Tv[22] * 0.4;
    Tv[24] := Tv[18] + Tv[23];

    If isAssociated(RetNo) then
       CopyS566FromS23(RetNo)
    else
    begin
     For i:=48 to 169 do begin Strings[i]:='';Tv[i]:=0;end;
    end;
    If isAssociated(RetNo) then
    begin
     i:=48;
     j:=109;
     Repeat
      Strings[j]:=Strings[i];
      Strings[j+1]:=Strings[i+1];
      Inc(i,3);
      Inc(j,3);
     until i>105;
    end;
    //Part 4
    Tv[25]:=Vl(FetchElm(RetNo,'S31',311));

    If IsAssociated(RetNo)= False then
    Begin
    Tv[33] := 8000000;
    Tv[26] := MaxR(Tv[25], 500000);
    Tv[27] := Tv[26] * 10;
    Tv[28] := MaxR(0, 8000000 - Tv[27]);    //20161112
   {
   AA:=MaxR(0,7000000-(10 * MaxR(Tv[25],400000)));
    BB:=MaxR(0,8000000 - (10 * MaxR(Tv[25],500000)));
    CC:=GetNumDays(RetNo,'01-01-2010','B');
    DD:=Ret[RetNo].DaysInYear;
    Tv[28]:=BB-(MaxR(0,BB-AA) * (CC /DD));
   }
    Tv[29] := Tv[46];
    Tv[30] := MaxR(0, Tv[29] - 25000000);
    Tv[31] := MaxR(0, 25000000 - Tv[30]);
    Tv[32] := (Tv[28] * Tv[31]) / 25000000;
    If Tv[32]>3000000 then Tv[32]:=3000000;
    end
    Else
    begin
     For i:=25 to 28 do Tv[i]:=0;
     For i:=30 to 33 do Tv[i]:=0;
    End;

    If IsAssociated(RetNo)= True then
    Begin
     Tv[34] :=8000000; //7000000;  //20210225
     If Tv[35]<0 then Tv[35]:=0;  //20130603
     Tv[36] := MaxR(400000,Tv[35]);
     Tv[37] := Tv[36] * 10;
     //20161112
     Tv[38]:=MaxR(0,8000000-Tv[37]);
     Tv[39] := Tv[47];
     Tv[40] := MaxR(0,Tv[39] - 25000000);
     Tv[41] := MaxR(0,25000000 - Tv[40]);
     Tv[42] := Tv[38] * Tv[41]/25000000;
     Tv[43] := Tv[111];
    end
    Else
    Begin
     For i:=34 to 43 do Tv[i]:=0;
    end;

    //short years
    Strings[242]:=IntToStr(Ret[RetNo].DaysInYear);
    If IsAssociated(RetNo)=False then
     Tv[44]:=Tv[32]
    else
     Tv[44]:=Tv[43];

    If Ret[RetNo].DaysInYear < 357 then
      Tv[45] :=Tv[44] * Ret[RetNo].DaysInYear/365
    Else
    begin
     Tv[44]:=0;
     Tv[45]:=0;
    end;

   //Part 5

   Tv[108] := AddColumns(50,107,3);
   Tv[47] := Tv[108];
   //Part 6
   Tv[169] := AddColumns(111,168,3);
   //Part 7

   //20170111
   if GetTaxationYearEnd(RetNo) <'2016/06/01' then
   Begin
   Tv[170] := Tv[17];
   Tv[171] := Tv[24];
   Tv[172] := Tv[170] + Tv[171];
   Tv[173] := MaxR(MaxR(Tv[32],Tv[43]),Tv[45]);
   Tv[174] := MinR(Tv[172],Tv[173]);
   Tv[175] := Tv[174] * 10/100;
   End
   Else
   Begin
     for i:=170 to 175 do begin TV[i]:=0;end;
   End;
   // 20161112
   if ((GetTaxationYearEnd(RetNo) >='2016/06/01') and (DateWithinTaxYear('2016/05/31',RetNo))) then
   Begin
    Tv[240]:= Tv[17];
    Tv[291]:= Tv[24];

    Strings[241] :=IntToStr(GetNumDays(RetNo,'01-06-2016','B'));
    Strings[283] :=IntToStr(Ret[RetNo].DaysInYear);
    x:=(Vl(Strings[241])/Ret[RetNo].DaysInYear)*10;
    Strings[284]:=FormatFloat('###.0000',x);

    Strings[285] :=IntToStr(GetNumDays(RetNo,'31-05-2016','A'));
    Strings[286] :=IntToStr(Ret[RetNo].DaysInYear);
    X:=(Vl(Strings[285])/Ret[RetNo].DaysInYear) *8;
    Strings[287]:=FormatFloat('###.0000',x);

    X:=Vl(Strings[284])+Vl(Strings[287]);
    Strings[288]:=FormatFloat('###.0000',x);

    Tv[289]:=Tv[291];
    Strings[290]:=Strings[288];
    if vl(Strings[290])>0 then
      Tv[292]:=Round(Tv[289] * 0.10/(Vl(Strings[290])/100))  //20170620
    Else
      Tv[292]:=0;

    Tv[293]:=Tv[240]+Tv[292];  //20170111

    Tv[294]:=MaxR(Tv[32],MaxR(Tv[43],Tv[45]));  //??? check it
    Tv[295]:=MinR(Tv[293],Tv[294]);
    Tv[296]:= Round(Tv[295] * Vl(Strings[288])/100);   //20170111
   End
   Else
   Begin
    Tv[240]:=0;
    Tv[293]:=0;
    Tv[295]:=0;
    Tv[296]:=0;
   End;


  if GetTaxationYearStart(RetNo) >'2016/05/31' then
   Begin
    Tv[297]:= Tv[17];
    //Tv[298]:= Tv[24]; unprotect
    //tv[299 unprotect

    Strings[300] :=IntToStr(GetNumDays(RetNo,'01-06-2016','B'));
    Strings[301] :=IntToStr(Ret[RetNo].DaysInYear);
    Strings[302]:=FormatFloat('###.0000',(Vl(Strings[300])/Ret[RetNo].DaysInYear) *10);

    Strings[303] :=IntToStr(GetNumDays(RetNo,'31-05-2016','A'));
    Strings[304] :=IntToStr(Ret[RetNo].DaysInYear);
    Strings[305]:=FormatFloat('###.0000',(Vl(Strings[303])/Ret[RetNo].DaysInYear) *8);
    Strings[306]:=FormatFloat('###.0000',Vl(Strings[302])+Vl(Strings[305]));

    Tv[307]:=Tv[299];
    Strings[308]:=Strings[306];
    Tv[310]:=Round(Tv[307] * Vl(Strings[308])/(8/100));

    Tv[309]:=Tv[24];
    Tv[311]:=Round(Tv[309]*1.25);
    Tv[312]:=Tv[297]+Tv[298]+Tv[310]+Tv[311];
    Tv[313]:=MaxR(Tv[32],MaxR(Tv[43],Tv[45]));  //??? check it
    Tv[314]:=MinR(Tv[312],Tv[313]);
    Tv[315]:= Round(Tv[314] * 8/100);
   End
   Else
   Begin
    for i:=297 to 315 do begin Tv[i]:=0; Strings[i]:='';End;
   End;


   If Strings[176]+Strings[177]='' then Strings[177]:='X';
   If Strings[176]='' then Tv[178]:=0;
   Tv[179]:= MaxR(Tv[175],MaxR(Tv[296],Tv[315]));
   Tv[179]:=MaxR(0,Tv[179]-Tv[178]);
   //Tv[179] := MaxR(0,Tv[175] - Tv[178]);
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S568(RetNo: integer;FName: string;FNo: integer);
Var i:Integer; x:Real;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsMJWithOntario(RetNo))
 then
  //continue
 else
 begin
   For i:=4 to 80 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 If  (Ret[RetNo].Frm[FNo].Strings[4]>'')
 and (Ret[RetNo].Frm[FNo].Strings[7]>'') then
 //continue
 else
 begin
   For i:=8 to 80 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If IsAssociated(RetNo) then
  begin
   Strings[8]:='X';
   Strings[9]:='';
  end
  Else
  Begin
   Strings[8]:='';
   Strings[9]:='X';
  end;

  If UpperCase(Strings[9])='X' then
    Tv[10]:=20000000
  else
    Tv[10]:=Tv[17];

  //20170603
  if IsShortYear(RetNo) then
  Begin
  Tv[11]:=Tv[10];
  Strings[12]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[13]:=Tv[11] * Vl(Strings[12])/365;
  Tv[14]:=Tv[13];
  End
  Else
  Begin
   Tv[14]:=Tv[10];
   Tv[11]:=0;
   Strings[12]:='';
   Tv[13]:=0;
  end;
  //Part 3
  If Strings[8]>'' then
  begin
  CopyS568FromS23(RetNo);
  i:=20;
  x:=0;
  Repeat
   x:=x+Tv[i];
   Inc(i,3);
  until i>74;
  Tv[17]:=MaxR(0,20000000-x);
  Tv[77]:=X+Tv[17];
  end
  Else
  begin
   For i:=15 to 74 do begin Strings[i]:='';Tv[i]:=0;end;
   Tv[77]:=0;
  end;
  Strings[75]:=IntToStr(GetS568NumProjects(RetNo));
  Tv[76]:=TotMultiple(RetNo,'S569',41);
  Tv[78]:=Tv[14];
  Tv[79]:=MinR(Tv[76],Tv[78]);
  Tv[80]:=Round(Tv[79] * 20/100);
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S569(RetNo: integer;FName: string;FNo: integer);
Var I:Integer;
begin
 LoadTv(RetNo,FName,FNo);
 FillHeader(RetNo,FNo,1,2,3);
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsMJWithOntario(RetNo)) then
 //or (Ret[RetNo].Province = 'MJ') then
  //continue
 else
 begin
   For i:=4 to 41 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;

 with Ret[RetNo].Frm[Fno] do
 begin
  If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742);
  If Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',755);
  If Strings[6]='' then Strings[6]:=FetchElm(RetNo,'T2',746);

 // If Strings[10]+Strings[11]='' then Strings[11]:='X';
  If Strings[10]+Strings[11]='XX' then Strings[11]:='';
  If Strings[9]>='2007/07/10' then begin Strings[10]:='';Strings[11]:='';end; //07/10 insted of 08/10
  If Strings[14]+Strings[15]='' then Strings[15]:='X';
  If Tv[19]=0 then Tv[19]:=100;

  //page 2
  If Strings[20]+Strings[21]='' then Strings[20]:='X';
  If Strings[22]+Strings[23]='' then Strings[22]:='X';
  If Strings[20]+Strings[21]='' then Strings[20]:='X';

  If Strings[26]+Strings[27]='' then Strings[26]:='X';
  If Strings[28]+Strings[29]='' then Strings[28]:='X';
  If Strings[30]+Strings[31]='' then Strings[30]:='X';
  If Strings[32]+Strings[33]='' then Strings[32]:='X';
  Tv[35]:=Tv[34];
  Strings[58]:=Strings[19];
  Tv[36]:=Round(Tv[35]*Vl(Strings[58])/100);

  If Tv[36]>0 then Tv[38]:=Tv[36] else Tv[38]:=Tv[34];
  Strings[39]:=Strings[37];
  Strings[40]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[41]:=Tv[38]*Vl(Strings[39])/Vl(Strings[40]);
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;

procedure S570(RetNo: integer;FName: string;FNo: integer);  //20210918
Var I:Integer; LeapDays:Integer;
begin
 LoadTv(RetNo,FName,FNo);

 FillHeader(RetNo,FNo,1,2,3);
 {
 If ((Ret[RetNo].Province = 'ON') and (IsAmalgamatedOntario(RetNo) = True))
 or (IsMJWithOntario(RetNo)
 or (Ret[RetNo].CorpType=CCPC)
 }
 If UpperCase(FetchElm(RetNo,FName, 48))='Y'
 then
 //continue
 else
 begin
   For i:=4 to 260 do begin ret[RetNo].Frm[FNo].Strings[i]:='';ret[RetNo].Frm[FNo].Tv[i]:=0;end;
   SaveTv(RetNo,FName,FNo);
   exit;
 end;
 //Part 1
 with Ret[RetNo].Frm[Fno] do
 begin
  if (isLeapYear(GetTaxationYearEndYYYY(RetNo)) and (GetTaxationYearEnd(RetNo)>'2020/02/28')) then
   LeapDays:=366
  Else
   LeapDays:=365;

  Tv[4]:=0;
  //Tv[28]:=0;
  i:=66;
  repeat
   Tv[4]:=Tv[4]+Tv[i+4];
   //if Strings[3] >'2021/03/23' then Tv[28]:=Tv[28]+Tv[i+4];  //20211111
   Inc(i,5);
  until I>146;

  Tv[5]:=MaxR(0,Tv[4]-50000);
  Tv[6]:=MinR(Tv[5],450000);
  Tv[7]:=Tv[6];
  Strings[8]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[9]:=Round(Tv[7]* Ret[RetNo].DaysInYear/LeapDays);

  //Pat 2   //20211111
  Tv[12]:=0;
  i:=175;
  Repeat
   Tv[12]:=Tv[12]+Tv[i];
   inc(i,5);
  Until i>260;
  Tv[13]:=MaxR(0,Tv[12]-50000);
  Tv[14]:=MinR(450000,Tv[13]);

  Strings[39]:=FormatFloat('####',MaxR(0,(365-Vl(Strings[15]))));
  Strings[40]:=IntToStr(Ret[RetNo].DaysInYear);

  Strings[16]:=FormatFloat('0.####',Vl(Strings[39])/Leapdays);
  Strings[17]:=FormatFloat('0.####',Vl(Strings[40])/LeapDays);

  Strings[18]:=Strings[16];
  if Strings[17]<Strings[18] then Strings[18]:=Strings[17];

  Tv[19]:=Tv[14];
  Strings[20]:=Strings[18];
  Tv[21]:=Round(Tv[19]*Vl(Strings[20]));

  //Part 3
  Tv[22]:=Round(Tv[9] * 10/100);
  //Tv[23]:=?  //all appicable short years
  Tv[24]:=Tv[22]+Tv[23];
  Strings[25]:=IntToStr(Ret[RetNo].DaysInYear);
  Tv[26]:=Round((450000 * Ret[RetNo].DaysInYear/LeapDays) * 10/100);
  Tv[27]:=MinR(Tv[24],Tv[26]);

  (* 20250918
  Tv[43]:=MinR(Tv[24],Tv[26]);
  Tv[44]:=Round(Tv[33]*10/100);   //??
  //Tv[45]:=?  al short years
  Tv[46]:=Tv[44]+Tv[45];
  Tv[47]:=MinR(Tv[46],Tv[26]);
  Tv[27]:=Tv[43]+Tv[47];
 *)
 end; {End with}
 SaveTv(RetNo,FName,FNo);
end;


end.

