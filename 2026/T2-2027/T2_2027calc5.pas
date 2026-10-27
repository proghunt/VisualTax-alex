unit T2_2027calc5;

interface
{
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T2_2020,UDeclare,common, common2,TrimStr;
}

 Uses Classes, System.Generics.Collections, vtScrollBox, vtChild; //20230510 Igor

 Procedure T1521(RetNo: integer; FName: String;FNo: integer); //20250812
 Procedure FASSET(RetNo:integer;FName:string;FNo:integer);

 Procedure CBCR(RetNo: integer; FName: String;FNo: integer);
 //20171124
 Procedure T1134(RetNo: integer; FName: String;FNo: integer);
 Procedure T1134S(RetNo: integer; FName: String;FNo: integer);

 Procedure T1135(RetNo:integer;FName:string;FNo:integer);
 Procedure T1141(RetNo:integer;FName:string;FNo:integer);
 Procedure T1142(RetNo:integer;FName:string;FNo:integer);
 Procedure T1145(RetNo:integer;FName:string;FNo:integer);
 Procedure T1146(RetNo:integer;FName:string;FNo:integer);
 Procedure T1174(RetNo:integer;FName:string;FNo:integer);

 //procedure S10(RetNo: integer;FName: string;FNo: integer);
// procedure S10OLD(RetNo: integer;FName: string;FNo: integer);  //20190421
 procedure S13(RetNo: integer;FName: string;FNo: integer);
 procedure S14(RetNo: integer;FName: string;FNo: integer);
 procedure S15(RetNo: integer;FName: string;FNo: integer);

 procedure S18(RetNo: integer;FName: string;FNo: integer);
 //procedure S18_1(RetNo: integer;FName: string;FNo: integer);
 //procedure S18_2(RetNo: integer;FName: string;FNo: integer);
 procedure S19(RetNo: integer;FName: string;FNo: integer);
 procedure T5004(RetNo: integer;FName: string;FNo: integer);
 Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo:Integer); //20160124 //20160202 Igor

implementation

Uses
  SysUtils,
  vtMulti,vtCommon,
  T2_2027,T2_2027Declare,T2_2027common, T2_2027common2,T2_2027TrimStr,
  T2_2027Calc,T2_2027Calc1,
  vtTrimStr, vtShared,
  vtDynData;   //20150329

procedure S13(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   i:=5;
   Tv[28]:=0;Tv[29]:=0;Tv[30]:=0;
   Repeat
    Tv[28] := Tv[28]+Tv[i];
    Tv[29] := Tv[29]+Tv[i+1];
    Tv[30] := Tv[30]+Tv[i+2];
    Inc(i,4);
   until i>25;

   {
   i:=31;
   Tv[52]:=0;Tv[53]:=0;Tv[54]:=0;
   Repeat
    Tv[52] := Tv[52]+Tv[i];
    Tv[53] := Tv[53]+Tv[i+1];
    Tv[54] := Tv[54]+Tv[i+2];
    Inc(i,3);
   until i>49;
   }
   //20120530
   Tv[52]:=0;Tv[53]:=0;Tv[54]:=0;
   i:=31;
   Tv[52]:=0;Tv[53]:=0;Tv[54]:=0;
   Repeat
    Tv[52] := Tv[52]+Tv[i];
    Tv[53] := Tv[53]+Tv[i+1];
    Tv[54] := Tv[54]+Tv[i+2];
    Inc(i,3);
   until i>37;

   i:=43;
   Repeat
    Tv[52] := Tv[52]+Tv[i];
    Tv[53] := Tv[53]+Tv[i+1];
    Tv[54] := Tv[54]+Tv[i+2];
    Inc(i,3);
   until i>49;

   Tv[62]:=Tv[57]+Tv[60];
   Tv[63]:=Tv[58]+Tv[61];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


procedure S14(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  FillHeader(RetNo,FNo,1,2,3);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S15(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
   i:=5; Tv[154] :=0;
   Repeat
    Tv[154] := Tv[154]+Tv[i];
    Inc(i,10);
   until i>145;
   If Tv[155]=0 then
     Tv[155]:=TotGifiMultiple(RetNo,'S125','8623');//TotGifiMultiple(RetNo,'GIFIIS','8623'); //20150826
   Tv[156]:=MaxR(0,Tv[154]-Tv[155]);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//new for 2009
procedure S18(RetNo: integer;FName: string;FNo: integer);
Var i:integer;TxblInc,CgRefund,HighRate:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
   begin
   If (IsMutualFundCorp(RetNo))
   or (IsInvestmentCorp(RetNo)) then
   {continue}
   else
   begin
    For i:= 4 to 38 do Tv[i] :=0;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;
   FillHeader(RetNo,FNo,1,2,3);
   Tv[5] := GetTxblIncome(RetNo);
   Tv[6] := Tv[5] * 0.28;
   //If Tv[7] :=Vl(FetchElm(RetNo,'T2',628));
   Tv[7]:=Vl(FetchElm(RetNo,'S6',685));  //20180502
   Tv[8] := Tv[7] *0.28;
   Tv[9]:=Tv[6]+Tv[8];
   Tv[10] := MinR(Tv[6], MinR(Tv[8],Tv[9]));
   Tv[12] := Tv[4]+Tv[10]+Tv[11];
   Tv[14] := MaxR(0,Tv[12] - Tv[13]);

   If IsMutualFundCorp(RetNo)then
   begin
    Tv[15] := Tv[14];
   // Strings[40]:='14';   /20180517
    Tv[16] := Tv[15] * (100/14); //(Vl(Strings[40])));
    Tv[19] := Tv[17]+Tv[18];
    Tv[20] := Tv[19];
    Tv[23] := Tv[21]+Tv[22];
    Tv[24] := Tv[23];
    Tv[25] := MaxR(0,Tv[20]-Tv[24]);
    Tv[26] := Tv[25];
    Tv[27] := Tv[16]+Tv[26];
    Tv[99]:=Tv[28]+Tv[98];
    Tv[100]:=Tv[99];
    Tv[29] := Tv[100];
    Tv[30] := Tv[27];

    Tv[32] := Tv[100];
    Tv[33]:=Tv[17];

    If Tv[32] + Tv[33]>0 then
      Tv[31] := (Tv[29]*Tv[30]) / (Tv[32] + Tv[33])
    else
      Tv[31] :=0;
   end
   else
   begin
    Tv[15] := 0;
    Strings[40]:='';
    Tv[16] := 0;
    Tv[19] := 0;
    Tv[20] := 0;
    Tv[23] := 0;
    Tv[24] := 0;
    Tv[25] := 0;
    Tv[26] := 0;
    Tv[27] := 0;
    Tv[29] := 0;
    Tv[30] := 0;
    Tv[32] := 0;
    Tv[33] := 0;
    Tv[31] :=0;
   end;

   If (IsMutualFundCorp(RetNo))
   or (IsInvestmentCorp(RetNo))
   then
   begin
    Tv[35] := Tv[31];
    Tv[36] := Tv[34]+Tv[35];
    Tv[37] := Tv[36] * 0.14;
    Tv[38] := MinR(Tv[14],Tv[37]);
   end
   Else
   Begin
    Tv[35] := 0;
    Tv[36] := 0;
    Tv[37] := 0;
    Tv[38] := 0;
   end;
   //page 2 Ontario
   If IsAmalgamatedOntario(RetNo) then
   begin
    If Ret[RetNo].Province = 'ON' then
    begin
      Strings[44]:='1.0000';
      Tv[41]:=0;Tv[42]:=0;
      Strings[43]:='';
    end
    Else
    Begin
      If Ret[RetNo].Province = 'MJ' then
      begin
       Tv[41]:=GetTxblIncomeInProv(RetNo,'ON');
       Tv[42]:=GetTxblIncome(RetNo);
       If Tv[42]=0 then Tv[42]:=1000;
       If Tv[42]>0 then Strings[43]:=FormatFloat('##0.0000',Tv[41]/Tv[42]) else Strings[43]:='';
       Strings[44]:=Strings[43]; //20100521
      end;
    end;

    Tv[46]:=GetTxblIncome(RetNo);
    Strings[47]:=Strings[44];
    Strings[39]:=GetOntBasicTaxRate(RetNo);
    Tv[48]:=Tv[46] * Vl(Strings[47]) * Vl(Strings[39])/100;

    Tv[49]:=Tv[7];
    Strings[50]:=Strings[44];
    Strings[92]:=GetOntBasicTaxRate(RetNo);
    Tv[51]:=Tv[49] * Vl(Strings[50]) * Vl(Strings[92])/100;
    Tv[52]:=Vl(FetchElm(RetNo,'S5',623));
    Tv[53]:=Vl(FetchElm(RetNo,'S5',642));
    Tv[54]:=MaxR(0,Tv[52]-Tv[53]);
    Tv[55]:=MinR(Tv[48],MinR(Tv[51],Tv[54]));
    Tv[57]:=Tv[54]+Tv[55]+Tv[56];
    Tv[59]:=MaxR(0,Tv[57]-Tv[58]);
    Tv[60]:=Tv[34];
    Tv[61]:=Tv[31];
    Tv[62]:=Tv[60]+Tv[61];
    Tv[63]:=Tv[62];
    Strings[64]:=Strings[44];
    Strings[93]:=GetOntBasicTaxRate(RetNo);
    Tv[65]:=Tv[63] * Vl(Strings[64]) * (Vl(Strings[93])/100) * 0.5;
    Tv[66]:=MinR(Tv[59],Tv[65]);
   end //amalg ontario
   Else
    For i:=41 to 66 do Tv[i]:=0;


   //MB
   If (IsMutualFundCorp(RetNo))  or (IsInvestmentCorp(RetNo))
   then
   begin
    If Strings[68]='' then Strings[68]:='14.0000';
    Tv[69]:=GetTxblIncomeInProv(RetNo,'MB');
    Tv[70]:=GetTxblIncome(RetNo);
    If Tv[70]>0 then
     Strings[71]:=FormatFloat('##0.0000',Tv[69]/Tv[70])
    else
     Strings[71]:='';
    Strings[72]:=Strings[71];
    Tv[74]:=Tv[70];
    Strings[94]:=Strings[68];
    Tv[75]:=Tv[74] * Vl(Strings[94])/100;
    Tv[76]:=Tv[7];
    Strings[95]:=Strings[68];
    Tv[77]:=Tv[76] * Vl(Strings[95])/100;
    Tv[78]:=Vl(FetchElm(RetNo,'S5',720));
    Tv[79]:=Vl(FetchElm(RetNo,'S5',751));
    Tv[80]:=MaxR(0,Tv[78]-Tv[79]);
    Tv[81]:=MinR(Tv[80],MinR(Tv[75],Tv[77]));
    Tv[82]:=Tv[73]+Tv[81];
    Tv[84]:=MaxR(0,Tv[82]-Tv[83]);
    Tv[85]:=Tv[34];
    Tv[86]:=Tv[31];
    Tv[87]:=Tv[85]+Tv[86];
    Tv[88]:=Tv[87];
    Strings[96]:=Strings[68];
    Strings[97]:=Strings[72];
    Tv[89]:=Tv[88]* (Vl(Strings[96])/100) *0.5 * Vl(Strings[97]);
    Tv[90]:=MinR(Tv[84],Tv[89]);
   end
   else
   begin
    for i:=69 to 97 do Begin Tv[i]:=0;Strings[i]:='';end;
   end;

   //Page 3
   If (IsMutualFundCorp(RetNo))
   or (IsInvestmentCorp(RetNo)) then
   {continue}
   else
   begin
    For i:= 102 to 161 do Tv[i] :=0;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;

   TxblInc:=GetTxblIncome(RetNo);
   If TxblInc<=0 then
   begin
    i:=105;
    Repeat
     Tv[i]:=0;
     Inc(i,5);
    until i>156;

    Tv[161]:=0;
    SaveTv(RetNo,FName,FNo);
    exit;
   end;
   CgRefund:=Vl(FetchElm(RetNo,'S18',38));

   Strings[101]:='XO';
   Strings[106]:='NL';
   Strings[111]:='PE';
   Strings[116]:='NO';
   Strings[121]:='NS';
   Strings[126]:='NB';
//   Strings[131]:='MB';
   Strings[136]:='SK';
   Strings[141]:='BC';
   Strings[146]:='NT';
   Strings[151]:='YT';
   Strings[156]:='NU';

   I:=101;
   Repeat
    If GetTxblIncomeInProv(RetNo,Strings[i])>0 then
    begin
     Tv[I+1]:=GetTxblIncomeInProv(RetNo,Strings[i]);
     Tv[i+2]:=TxblInc;
     Tv[I+3]:=CgRefund;
     HighRate:=GetHighRate(RetNo,GetPrvNdx(Strings[i]));
     If (TxblInc>0) then
      Tv[i+4]:=(Tv[i+1]/TxblInc) * CgRefund *
       (HighRate/28)
     else
      Tv[i+4]:=0;
    end
    else //no txbl in prov
    begin
     Tv[i+1]:=0;
     Tv[i+2]:=0;
     Tv[i+3]:=0;
     Tv[i+4]:=0;
    end;
    Inc(i,5);
   until i>156;

   (*
   //remove prov if not refund
   I:=101;
   Repeat
    If Tv[i+4]=0 then Strings[i]:='';
    Inc(i,5);
   Until i>156;
   *)
   //clear mb
   For i:=132 to 135 do Tv[i]:=0;
   //it does not work in RSI with gaps

   //total
   i:=105;Tv[161]:=0;
   Repeat
     Tv[161]:=Tv[161]+Tv[i];
     Inc(i,5);
   until i>156;
   Tv[67]:=Tv[66];
   Tv[91]:=Tv[90];
   Tv[161]:=Tv[161]+Tv[67];
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure S19(RetNo: integer;FName: string;FNo: integer);
Var i:integer; x:Real;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   FillHeader(RetNo,FNo,1,2,3);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

procedure T5004(RetNo: integer;FName: string;FNo: integer);
Var i:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
   Strings[69] := LeftStr(FetchElm(RetNo,'T2',11),4);
   Strings[2] := FetchElm(RetNo,'T2',3);
   Strings[7] := FetchElm(RetNo,'T2',1);
   Strings[3] := FetchElm(RetNo,'T2',12);
   Strings[4] := FetchElm(RetNo,'T2',13);
   Strings[5] := FetchElm(RetNo,'T2',16);
   Strings[6] := FetchElm(RetNo,'T2',17)+' '
                 +FetchElm(RetNo,'T2',20);

   Tv[68] :=0;
   I:=11;
   Repeat
    Tv[68] := Tv[68]+Tv[i];
    Inc(i,4);
   until i>67;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

//20180507
Procedure T1134(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
    //20230510 Igor >>>
    ArrayNo, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: Integer;
    AccountNumbers, ForeignAffiliates: TList<string>;
    IncorrectElmIDs: TList<Integer>;
    Value: string;
    MyScrollBox: TvtScrollBox;
    //20230510 Igor <<<
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   for i:=1 to 5 do begin Strings[i]:='';end;
   for i:=9 to 14 do begin Strings[i]:='';end;
   Strings[6]:='X';
   Strings[7]:=GetCorpName(RetNo);
   Strings[8]:=GetCorpBusNo(RetNo);

   Strings[15]:=FetchElm(RetNo,'T2',12); //str
   Strings[16]:=FetchElm(RetNo,'T2',16); //City
   Strings[17]:=FetchElm(RetNo,'T2',17); //prov
   Strings[18]:=FetchElm(RetNo,'T2',20); //Postal

   Strings[19]:=FetchElm(RetNo,'T2',10); //Fisc start
   Strings[20]:=FetchElm(RetNo,'T2',11); //Fisc end;

   if Strings[141]=''then Strings[141]:='CAN';  //20180703 CON  (normally  this would come from T2 elm
   //otherwise user must select from FCounty.d (No need to maintain anothe table of countries for 2 to 3 char conversion
   // it is an incostistency by CRA

   Strings[142]:=IntToStr(CountMultipleInstances(RetNo,'T1134S')); //20180612

  // Strings[143]:= FetchElm(RetNo,'T2',743); //fname
  // Strings[144]:= FetchElm(RetNo,'T2',742); //Ln
   //Strings[147]:= date
   If Strings[148]='' then Strings[148]:= FetchElm(RetNo,'T2',744); //Position

   If Strings[23]='' then Strings[23]:=UpperCase(FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742));

    //20230510 Igor >>>
    AccountNumbers := TList<String>.Create;
    ForeignAffiliates := TList<String>.Create;
    IncorrectElmIDs := TList<Integer>.Create;
    try
      if Assigned(RetList[RetNo].MyChild) and
         (RetList[RetNo].MyChild.ActiveForm <> nil) and
         SameText(RetList[RetNo].MyChild.ActiveForm.FormName, 'T1134') then
        MyScrollBox := RetList[RetNo].MyChild.ActiveForm;

      // reporting taxpayer account number
      AccountNumbers.Add(Strings[8]);

      // individuals
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 10;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // corporations
      ArrayNo := 2;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // trusts
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // partnerships
      ArrayNo := 4;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then
          AccountNumbers.Add(Value);
        Elm := Elm + BoxesPerRow;
      end;

      // pre populate B other information
      ArrayNo := 5;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 1;
      LastElm := Elm;
      // remove existing account numbers and collect ids with incorrect account numbers
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (AccountNumbers.IndexOf(Value) >= 0) then
            AccountNumbers.Remove(Value)
          else
            IncorrectElmIDs.Add(Elm);
        end
        else
          IncorrectElmIDs.Add(Elm);
        Elm := Elm + BoxesPerRow;
        LastElm := Elm;
      end;

      // remove rows with incorrect account numbers
      For i := IncorrectElmIDs.Count - 1 downto 0 do
        if IncorrectElmIDs[i] < LastElm then
          RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      // add new AccountNumbers
      For i := 0 to AccountNumbers.Count - 1 do
      begin
        Strings[LastElm] := AccountNumbers.Items[i];
        LastElm := LastElm + BoxesPerRow;
      end;

      IncorrectElmIDs.Clear;

      // collect foreign affiliates for 3.D section
      // related corporations
      ArrayNo := 6;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 3;
      ElmDormancy := ArrayNo * 10000 + 8;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        //20230601 Igor >>> in case if we will need to auto populate these values
        //Strings[Elm + 1] := GetT1134ForeignAffiliatesIdentificationNumber(RetNo, Value);
        //Strings[Elm + 2] := GetT1134ForeignAffiliatesCountryCode(RetNo, Value);
        //20230601 Igor <<<
        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then
          ForeignAffiliates.Add(Value);
        Elm := Elm + BoxesPerRow;
        ElmDormancy := ElmDormancy + BoxesPerRow;
      end;

      // foreign affiliate
      ArrayNo := 7;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 1;
      ElmDormancy := ArrayNo * 10000 + 9;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        Value := FetchElmFNo(RetNo, FNo, Elm + 3); //20230601 Igor   we need to use other FA in dormant section
        if not Value.IsEmpty and (ForeignAffiliates.IndexOf(Value) = -1) and (FetchElmFNo(RetNo, FNo, ElmDormancy) = 'X') then
          ForeignAffiliates.Add(Value);
        Elm := Elm + BoxesPerRow;
        ElmDormancy := ElmDormancy + BoxesPerRow;
      end;

      // pre populate 3.D dormant foreign affiliates
      ArrayNo := 10;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 1;
      LastElm := Elm;
      // remove existing account numbers and collect ids with incorrect account numbers
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
        Value := FetchElmFNo(RetNo, FNo, Elm);
        if not Value.IsEmpty then
        begin
          if (ForeignAffiliates.IndexOf(Value) >= 0) then
            ForeignAffiliates.Remove(Value)
          else
            IncorrectElmIDs.Add(Elm);
        end
        else
          IncorrectElmIDs.Add(Elm);
        Elm := Elm + BoxesPerRow;
        LastElm := Elm;
      end;

      // remove rows with incorrect foreign affiliate names
      For i := IncorrectElmIDs.Count - 1 downto 0 do
        if IncorrectElmIDs[i] < LastElm then
          RetList[RetNo].Frm[FNo].DeleteRowData(IncorrectElmIDs[i]);

      // add new foreign affiliate names
      For i := 0 to ForeignAffiliates.Count - 1 do
      begin
        Strings[LastElm] := ForeignAffiliates.Items[i];
        LastElm := LastElm + BoxesPerRow;
      end;

      // refresh dynamic rows
      if Assigned(MyScrollBox) then
        MyScrollBox.RebuildDynamicRows;
    finally
      FreeAndNil(AccountNumbers);
      FreeAndNil(ForeignAffiliates);
      FreeAndNil(IncorrectElmIDs);
    end;
    //20230510 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
end;

//20180612
Procedure T1134S(RetNo: integer; FName: String;FNo: integer); //20230510 Igor
Var i, j, ArrayNo, BoxesPerRow, Elm, RowCount:Integer;
    ArrGroupList: TArray<T1134GroupItem>;
    Value, v: string;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin

    //20230718 //JZ  shouldnt be done here but did it so to not distrirb the efile for now>>>
    Strings[167] := ExtractFormInst(FName) + ' of ' + inttostr(CountMultipleInstances(RetNo,ExtractNonInstFormName(FName))); // NonInstFormName

    v := '';
    if      trim(Strings[3]) = '1' then v:= 'New'
    else if trim(Strings[3]) = '2' then v:= 'Unmodified'
    else if trim(Strings[3]) = '3' then v:= 'Amended'
    else if trim(Strings[3]) = '4' then v:= 'Delete (Close)';
    Strings[168] := v;

    v := '';
    if      trim(Strings[175]) = '1' then v:= 'Duplicate'
    else if trim(Strings[175]) = '2' then v:= 'Filed in Error'
    else if trim(Strings[175]) = '3' then v:= 'Other';
    Strings[169] := v;
    // <<<


    //20230411 Igor >>>
    Strings[4] := GetT1134ForeignAffiliatesIdentificationNumber(RetNo, Strings[35]);

    ArrGroupList := GetT1134GroupList(RetNo);

    ArrayNo := 1;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1] := '';
      Strings[Elm + 2] := '';
      Strings[Elm + 3] := '';
      Strings[Elm + 4] := '';
      if not Value.IsEmpty then
        for j := 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2] := ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3] := ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4] := ArrGroupList[j].AccountNumber
            end;
            break;
          end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 4;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      Strings[Elm + 1] := '';
      Strings[Elm + 2] := '';
      Strings[Elm + 3] := '';
      Strings[Elm + 4] := '';
      if not Value.IsEmpty then
        for j := 0 to Length(ArrGroupList) - 1 do
          if SameText(Value, ArrGroupList[j].Name) then
          begin
            case ArrGroupList[j].AccountType of
              atIndividual: Strings[Elm + 2] := ArrGroupList[j].AccountNumber;
              atCorporation: Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
              atTrust: Strings[Elm + 3] := ArrGroupList[j].AccountNumber;
              atPartnership: Strings[Elm + 4] := ArrGroupList[j].AccountNumber
            end;
            break;
          end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 12;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 13;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    ArrayNo := 15;
    BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
    Elm := ArrayNo * 10000 + 1;
    RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
    For i := 0 to RowCount - 1 do
    begin
      Value := FetchElmFNo(RetNo, FNo, Elm);
      for j := 0 to Length(ArrGroupList) - 1 do
        if SameText(Value, ArrGroupList[j].Name) then
        begin
          Strings[Elm + 1] := ArrGroupList[j].AccountNumber;
          break;
        end;
      Elm := Elm + BoxesPerRow;
    end;

    Tv[78]:=Tv[74]+Tv[75];
    Tv[82]:=Tv[80]+Tv[81];
    Tv[86]:=Tv[84]+Tv[85];
    Tv[90]:=Tv[88]+Tv[89];
    Tv[94]:=Tv[92]+Tv[93];
    Tv[98]:=Tv[96]+Tv[97];
    Tv[102]:=Tv[100]+Tv[101];
    Tv[106]:=Tv[104]+Tv[105];
    Tv[110]:=Tv[108]+Tv[109];

    Tv[145]:=0;
    for i in [58,128,130,132,134,136,138,140,142,144] do Tv[145]:=Tv[145]+Tv[i];
    Tv[146]:=0;
    for i in [59,129,131,133,135,137,139,141,143] do Tv[146]:=Tv[146]+Tv[i];
    //20230411 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
end;

(*
//20180507
Procedure T1134(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   for i:=1 to 5 do begin Strings[i]:='';end;
   for i:=9 to 14 do begin Strings[i]:='';end;
   Strings[6]:='X';
   Strings[7]:=GetCorpName(RetNo);
   Strings[8]:=GetCorpBusNo(RetNo);

   Strings[15]:=FetchElm(RetNo,'T2',12); //str
   Strings[16]:=FetchElm(RetNo,'T2',16); //City
   Strings[17]:=FetchElm(RetNo,'T2',17); //prov
   Strings[18]:=FetchElm(RetNo,'T2',20); //Postal

   Strings[19]:=FetchElm(RetNo,'T2',10); //Fisc start
   Strings[20]:=FetchElm(RetNo,'T2',11); //Fisc end;

   if Strings[141]=''then Strings[141]:='CAN';  //20180703 CON  (normally  this would come from T2 elm
   //otherwise user must select from FCounty.d (No need to maintain anothe table of countries for 2 to 3 char conversion
   // it is an incostistency by CRA

   Strings[142]:=IntToStr(CountMultipleInstances(RetNo,'T1134S')); //20180612

  // Strings[143]:= FetchElm(RetNo,'T2',743); //fname
  // Strings[144]:= FetchElm(RetNo,'T2',742); //Ln
   //Strings[147]:= date
   If Strings[148]='' then Strings[148]:= FetchElm(RetNo,'T2',744); //Position

   If Strings[23]='' then Strings[23]:=UpperCase(FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742));


   //20230411 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
end;

//20180612
Procedure T1134S(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   //20230411 Igor >>>

   Tv[145]:=0;
   for i in [58,128,130,132,134,136,138,140,142,144] do Tv[145]:=Tv[145]+Tv[i];
   Tv[146]:=0;
   for i in [59,129,131,133,135,137,139,141,143] do Tv[146]:=Tv[146]+Tv[i];
   //20230411 Igor <<<
  end;
  SaveTv(RetNo,FName,FNo);
end;
*)

Procedure T1141(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin
   for i:=1 to 5 do begin Strings[i]:='';end;
   for i:=9 to 11 do begin Strings[i]:='';end;
   Strings[6]:='X';
   Strings[7]:=GetCorpName(RetNo);
   Strings[8]:=GetCorpBusNo(RetNo);
   Strings[12]:=FetchElm(RetNo,'T2',13); //str
   Strings[13]:=FetchElm(RetNo,'T2',16); //City
   Strings[14]:=FetchElm(RetNo,'T2',17); //prov
   Strings[15]:=FetchElm(RetNo,'T2',20); //Postal

   Tv[74]  := Tv[61] + Tv[67] + Tv[73];
   Tv[93]  := Tv[80] + Tv[86] + Tv[92];
   Tv[105] := Tv[98] + Tv[99] + Tv[104];
   Tv[125] := Tv[122]+ Tv[123] + Tv[124];


   If Strings[132]='' then Strings[132]:=
     FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); //sign nm
   If Strings[133]='' then Strings[133]:=FetchElm(RetNo,'T2',744); //position
   If Strings[134]='' then Strings[134]:=FetchElm(RetNo,'T2',755); //Area
   If Strings[135]='' then Strings[135]:=FetchElm(RetNo,'T2',746); //Area
   If Strings[136]='' then Strings[136]:=FormatDateTime('yyyy/mm/dd',Date);

   If Strings[137]='' then Strings[137]  := OptRec.Prp_Name;
   If Strings[138]='' then Strings[138]  := OptRec.Prp_Street;
   If Strings[139]='' then Strings[139]  :=OptRec.Prp_City;
   If Strings[140]='' then Strings[140]  :=OptRec.Prp_Prov;
   If Strings[141]='' then Strings[141] :=OptRec.Prp_Postal;
   If Strings[142]='' then Strings[142] :=OptRec.Prp_Area;
   If Strings[143]='' then Strings[143] :=OptRec.Prp_Tel;

   end;
   SaveTv(RetNo,FName,FNo);
end;

Procedure T1142(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[FNo] do
 begin
   for i:=1 to 5 do begin Strings[i]:='';end;
   for i:=9 to 11 do begin Strings[i]:='';end;
   for i:=90 to 92 do begin Strings[i]:='';end;
   Strings[6]:='X';
   Strings[7]:=GetCorpName(RetNo);
   Strings[8]:=GetCorpBusNo(RetNo);
   Strings[12]:=FetchElm(RetNo,'T2',13); //str
   Strings[13]:=FetchElm(RetNo,'T2',16); //City
   Strings[14]:=FetchElm(RetNo,'T2',17); //prov
   Strings[15]:=FetchElm(RetNo,'T2',20); //Postal

     //part III
     Tv[48]  := Tv[28] + Tv[33] + Tv[38] + Tv[43];
     Tv[49]  := Tv[30] + Tv[35] + Tv[40] + Tv[45];
     //part IV
     Tv[74]  := Tv[51] + Tv[57] + Tv[63] + Tv[69];
     Tv[75]  := Tv[52] + Tv[58] + Tv[64] + Tv[70];
     Tv[76]  := Tv[53] + Tv[59] + Tv[65] + Tv[71];

    If Strings[77]='' then Strings[77]:=
      FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); //sign nm
    If Strings[78]='' then Strings[78]:=FetchElm(RetNo,'T2',744); //position
    If Strings[79]='' then Strings[79]:=FetchElm(RetNo,'T2',755); //Area
    If Strings[80]='' then Strings[80]:=FetchElm(RetNo,'T2',746); //Area
    If Strings[81]='' then Strings[81]:=FormatDateTime('yyyy/mm/dd',Date);


    If Strings[82]='' then Strings[82]  := OptRec.Prp_Name;
    If Strings[83]='' then Strings[83]  := OptRec.Prp_Street;
    If Strings[84]='' then Strings[84]  :=OptRec.Prp_City;
    If Strings[85]='' then Strings[85]  :=OptRec.Prp_Prov;
    If Strings[87]='' then Strings[87] :=OptRec.Prp_Postal;
    If Strings[88]='' then Strings[88] :=OptRec.Prp_Area;
    If Strings[89]='' then Strings[89] :=OptRec.Prp_Tel;
   end;
   SaveTv(RetNo,FName,FNo);
end;


Procedure T1145(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[FNo] do
 begin
   Strings[17]:=GetCorpName(RetNo);
   Strings[18]:=GetCorpBusNo(RetNo);
   Strings[21]:=GetTaxationYearEnd(RetNo);
   If Strings[4]+Strings[5]='' then Strings[5]:= 'X';
   If Strings[29]+Strings[30]='' then Strings[30]:= 'X';
   If Strings[22]='' then Strings[22]:= FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); //sign nm
  // If Strings[23]='' then Strings[23]:=FetchElm(RetNo,'T2',755); //Area
  // If Strings[24]='' then Strings[24]:=FetchElm(RetNo,'T2',746); //Area
   If Strings[27]='' then Strings[27]:=FetchElm(RetNo,'T2',744); //position
   If Strings[28]='' then Strings[28]:= FormatDateTime('yyyy/mm/dd',Date);
   If Strings[19]='' then Strings[19]:=FetchElm(RetNo,'T2',12)+' '+FetchElm(RetNo,'T2',13)
       + ' '+ FetchElm(RetNo,'T2',16)+ ' '+FetchElm(RetNo,'T2',17)+ ' '+FetchElm(RetNo,'T2',20);
   SaveTv(RetNo,FName,FNo);
 end;
end;

Procedure T1146(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
   FillHeader(RetNo,FNo,44,45,46);
   //20100404
   If Strings[12]+Strings[13]='' then Strings[13]:='X';
   If Strings[14]+Strings[22]='' then Strings[22]:='X';
   If Strings[5]>'' then
   begin
    Strings[6]:=GetCorpName(RetNo);
    Strings[8]:=FetchElm(RetNo,'T2',13) + ' '+ FetchElm(RetNo,'T2',16)
                   + ' '+FetchElm(RetNo,'T2',17)+ ' '+FetchElm(RetNo,'T2',20);
    If Strings[10]='' then Strings[10]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); //sign nm
    Strings[7]:=GetCorpBusNo(RetNo);
    Strings[9]:=GetTaxationYearEnd(RetNo);
    If Strings[15]='' then Strings[15]:=FetchElm(RetNo,'T2',744); //title
    If Strings[16]='' then Strings[16]:=FormatDateTime('yyyy/mm/dd',Date);
   end;
   If Strings[11]>'' then
   begin
    Strings[17]:=GetCorpName(RetNo);
    Strings[19]:=FetchElm(RetNo,'T2',13) + ' '+ FetchElm(RetNo,'T2',16)
                   + ' '+FetchElm(RetNo,'T2',17)+ ' '+FetchElm(RetNo,'T2',20);
    If Strings[4]='' then Strings[4]:=FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); //sign nm
    Strings[18]:=GetCorpBusNo(RetNo);
    Strings[21]:=GetTaxationYearEnd(RetNo);
    If Strings[27]='' then Strings[27]:=FetchElm(RetNo,'T2',744); //title
    If Strings[28]='' then Strings[28]:=FormatDateTime('yyyy/mm/dd',Date);
   end;

   Tv[34] := MaxR(0,Tv[32] - Tv[33]);

   Tv[38]:=Tv[35]+Tv[37];
   Tv[41]:=Tv[39]+Tv[40];
   If Tv[41]>0 then
    Strings[42]:=FormatFloat('###0.0000',Tv[38]/Tv[41])
   else
    Strings[42]:='';

   Tv[43]:=Tv[34] * vl(Strings[42]);

   Tv[29]:=Tv[43];
   Tv[30]:=MinR(Tv[20],Tv[29]);
   If UpperCase(Strings[24])<>'Y' then Tv[31]:=Tv[30];
   If Tv[31]>Tv[30] then Tv[31]:=Tv[30];

   Tv[1]:=Tv[31];
   //20100404
   If Tv[2]+Tv[3]=0 then Tv[2]:=Tv[1];
   If Tv[3]>Tv[1] then Tv[3]:=Tv[1];
   Tv[2]:=MaxR(0,Tv[1]-Tv[3]);
  end;
  SaveTv(RetNo,FName,FNo);
end;

Procedure T1174(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin
     If GetTaxationYearEndYYYY(RetNo) = 2004 then Tv[42] := 40500
     else If GetTaxationYearEndYYYY(RetNo) = 2005 then Tv[42] := 41100
     else If GetTaxationYearEndYYYY(RetNo) = 2006 then Tv[42] := 42100;
     Strings[21]:=IntToStr(GetTaxationYearEndYYYY(RetNo));
     I:=6;
     Repeat
      If Tv[i]>Tv[i-1] then Tv[i]:=Tv[i-1];
      If Tv[i]>5 * Tv[42] then Tv[i]:=5 * Tv[42];
      Inc(i,4);
     until i>18;

     I:=27;
     Repeat
      If Tv[i]>Tv[i-1] then Tv[i]:=Tv[i-1];
      If Tv[i]>5 * Tv[42] then Tv[i]:=5 * Tv[42];
      Inc(i,4);
     until i>39;
     Tv[19]  := Tv[5]  + Tv[9]  + Tv[13] + Tv[17];
     Tv[20]  := Tv[6]  + Tv[10] + Tv[14] + Tv[18];
     Tv[40]  := Tv[26] + Tv[30] + Tv[34] + Tv[38];
     Tv[41]  := Tv[27] + Tv[31] + Tv[35] + Tv[39];
   end;
   SaveTv(RetNo,FName,FNo);
end;

//20150705
//20130720
Procedure T1135(RetNo: integer; FName: String;FNo: integer);
Var i,Elm,ArrayNo:Integer;BoxesPerRow:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    If Strings[21]='' then Strings[21]:='CAD';
    Strings[1] := '';

    Strings[23]:='';
    Strings[24]:='';

    Strings[6] := 'X';
    Strings[7] := GetCorpName(RetNo);
    Strings[8] := LeftStr(FetchElm(RetNo,'T2',1),9); //Copy(FetchElm(RetNo,'T2',1),1,9); //20180113
    Strings[30]:= RightStr(FetchElm(RetNo,'T2',1),4); //'0001'; //20180113

    if Strings[42]>'' then begin Strings[34]:='';Strings[86]:='X';end; //20180422

    //20160417
    Strings[15]:= FetchElm(RetNo,'T2',12)+' '+FetchElm(RetNo,'T2',13); //street
    Strings[17]:= FetchElm(RetNo,'T2',16); //city
    Strings[63]:= FetchElm(RetNo,'T2',17); //Province
    Strings[16]:= FetchElm(RetNo,'T2',20); //Province
    Strings[28]:= FetchElm(RetNo,'T2',19); //Province
    if Strings[28]='' then Strings[28]:='CAN';  //20160617

    //20160617
    Strings[19]:=GetTaxationYearStart(RetNo);
    Strings[20]:=GetTaxationYearEnd(RetNo);

    (* Did not work
    //20210630
    if Tv[60]>0 then Tv[60]:=Round(Tv[60]);
    if Tv[64]>0 then Tv[64]:=Round(Tv[64]);
    *)
    //------------------------------------

    ArrayNo:=1;
    BoxesPerRow:=5;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
    Tv[18]:=0;Tv[31]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     //If Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))=0 then StoreElmDynamic(RetNo,FNo,elm,FormatFloat('########0',Round(Vl(FetchElmFNoDynamic(RetNo,FNo,Elm))))); //??  20160124
     Tv[18]:=Tv[18]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[31]:=Tv[31]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;


    ArrayNo:=2;
    BoxesPerRow:=6; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
    Tv[32]:=0;Tv[33]:=0;Tv[43]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[32]:=Tv[32]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[33]:=Tv[33]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[43]:=Tv[43]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=3;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);            //20160124
    Tv[40]:=0;Tv[41]:=0;Tv[45]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[40]:=Tv[40]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[41]:=Tv[41]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[45]:=Tv[45]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=4;
    BoxesPerRow:=7;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);    //20160124
    Tv[51]:=0;Tv[52]:=0;Tv[54]:=0;Tv[56]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[51]:=Tv[51]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[52]:=Tv[52]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[54]:=Tv[54]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('7');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[56]:=Tv[56]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=5;
    BoxesPerRow:=6; //GetDynamicBoxesPerRow(FName,???StrToInt(IntTostr(ArrayNo)+'0001'));
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[61]:=0;Tv[62]:=0;Tv[68]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[61]:=Tv[61]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[62]:=Tv[62]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[68]:=Tv[68]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    ArrayNo:=6;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[81]:=0;Tv[82]:=0;Tv[85]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[81]:=Tv[81]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[82]:=Tv[82]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[85]:=Tv[85]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    //20150103
    ArrayNo:=7;
    BoxesPerRow:=6;
    T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);
    Tv[37]:=0;Tv[38]:=0;Tv[44]:=0;
    Elm:=ArrayNo*10000+StrToInt('4'); //for field id 10003 on the first row i form
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[37]:=Tv[37]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('5');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[38]:=Tv[38]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;
    Elm:=ArrayNo*10000+StrToInt('6');
    For i:=0 to MaxDynamicElmsPerForm do
    begin
     Tv[44]:=Tv[44]+Vl(FetchElmFNo(RetNo,FNo,Elm));
     Elm:=Elm+BoxesPerRow;
    end;

    //20160526
    If Strings[70] = '' then Strings[70] := FetchElm(RetNo,'T2',743)+' '+FetchElm(RetNo,'T2',742); //20160526  Contact pg 8
    If Strings[71] = '' then Strings[71] := FetchElm(RetNo,'T2',744);  //20160526
    If Strings[72] = '' then Strings[72] :='1'+ '('+FetchElm(RetNo,'T2',755)+')'+FetchElm(RetNo,'T2',746);  //20160529
    If Strings[73] = '' then Strings[73] := ReplaceChar(FormatDateTime('yyyy/mm/dd',Now),' ','');  //20180113 //not slashes, In T1135Efile is converted to dashes
    Strings[73] := ReplaceChar(Strings[73],'/','-'); //20190625
    //If Strings[73] = '' then Strings[73] := FormatDateTime('yyyy/mm/dd',Now);  //not slashes, In T1135Efile is converted to dashes

    If UpperCase(Strings[29])='Y' then
    Begin
     Strings[74] := OptRec.Prp_Name;
     Strings[75] := OptRec.Prp_Street;
     Strings[78] := OptRec.Prp_City;
     Strings[79] := OptRec.Prp_Prov;
     Strings[76] := OptRec.Prp_Postal;
     Strings[77]:=ReplaceChar(Strings[77],' ','');   //20180113
//     Strings[77] := '1'+'('+FetchElm(RetNo,'T2',755)+')'+FetchElm(RetNo,'T2',746); //20160526
    end
    Else
    Begin
     for i:=74 to 79 do Strings[i]:='';
    End;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure FASSET(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
   LoadTv(RetNo,FName,FNo);
   With Ret[RetNo].Frm[FNo] do
   begin
    FillHeader(RetNo,FNo,1,2,3);
    //20150826
    Tv[4] := MaxR(0,Vl(FetchElm(RetNo,'S100',14))    //tot tangible
             -Vl(FetchGifiElm(RetNo,'S100','1600')) //land
             -Vl(FetchGifiElm(RetNo,'S100','1601'))  //20160812 land impr
             +Vl(FetchElm(RetNo,'S100',17)));  //20160812     +Vl(FetchGifiElm(RetNo,'S100','2009')));


    Tv[6] := Tv[4] - Tv[5];
    {B}
    Tv[7] := TotMultiple(RetNo,'S8',228);  //20260714
       //Vl(FetchElm(RetNo,'S8#1',234));
    Tv[18] := TotMultiple(RetNo,'S8',343); //235);   //20260805
      //Vl(FetchElm(RetNo,'S8#1',235));
    Tv[27]:= Vl(FetchElm(RetNo,'S1',8));
    Tv[28]:= Vl(FetchElm(RetNo,'S1',15));
    Tv[29]:= Vl(FetchElm(RetNo,'S1',35));
    Tv[14] := ADDColumns(7,13,1);
    Tv[15] := Tv[14];
    Tv[24] := ADDColumns(18,23,1);
    Tv[25] := Tv[24];
    Tv[31] := Tv[15]-Tv[16]-Tv[25]-Tv[27]-Tv[28]+Tv[29]+Tv[30];
    {C}
    Tv[33] := Tv[6] - Tv[31];
   end;
SaveTv(RetNo,FName,FNo);
end;

//20160526
Procedure T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo:Integer); //20160124 //20160202 Igor
Var j,Elm,Columns:Integer;
Begin
  Elm:= ArrayNo*10000+StrToInt('1'); //firstColumn
  Columns:=5;
  if ArrayNo=1 then Columns:=4;
  if ArrayNo=4 then Columns:=6;
  If FetchElmFNo(RetNo,FNo,Elm)='' then
  begin
       For j:=1 to Columns do Begin StoreElm(RetNo,FNo,Elm+j,'');end;
  end;
end;

//20251107 Igor >>>
procedure CBCR(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    if (Strings[1]).Equals('01(') then Strings[1]:= 'USD';
    if (Strings[1]).Equals('02(') then Strings[1]:= 'GBP';
    if (Strings[1]).Equals('03(') then Strings[1]:= 'AUD';
    if (Strings[1]).Equals('04(') then Strings[1]:= 'EUR';
    if (Strings[1]).Equals('05(') then Strings[1]:= 'JPY';
    if (Strings[604] + Strings[605]).Equals('') then Strings[605]:= 'X';

   Strings[5]:= GetCorpName(RetNo);
   Strings[6]:= GetCorpBusNo(RetNo);

   if Strings[13].Equals('') then Strings[13]:= FetchElm(RetNo, 'T2', 12);

   Strings[16]:= FetchElm(RetNo, 'T2', 16);
   Strings[17]:= FetchElm(RetNo, 'T2', 17);
   Strings[18]:= FetchElm(RetNo, 'T2', 19);

   if Strings[18].Equals('') then Strings[18]:= 'CA';

   Strings[19]:= FetchElm(RetNo, 'T2', 20);

    i:= 41;
    repeat
      Tv[i]:= Tv[i - 2] + Tv[i - 1];
      inc(i, 11);
    until (i > 558);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251107 Igor <<<

//20250812 CZ
Procedure T1521(RetNo: integer; FName: String;FNo: integer);
Var i:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
   //
   SaveTv(RetNo,FName,FNo);
  end;
end;

end.
