unit T2_2027CALC;

interface

uses Math; //20260501 Alex

Procedure InitT1Constants; // 20200810

Procedure T7DRQR(RetNo: integer; FName: String; FNo: integer);
// 20230628
Procedure S432(RetNo: integer; FName: String; FNo: integer); // 20130505
// 20220509
Procedure S59(RetNo: integer; FName: String; FNo: integer); // 20220508
Procedure S63(RetNo: integer; FName: String; FNo: integer); // 20220508
//Procedure S65(RetNo: integer; FName: String; FNo: integer); // 20220508  //20260526
Procedure S351(RetNo: integer; FName: String; FNo: integer); // 20220508

Procedure SbdAlloc(RetNo: integer; FName: String; FNo: integer); // 20200728
Procedure PopulateS7SBDAlloc(RetNo: integer; RNo: integer);
Procedure CalcAllSbdAllocCompanies(RetNo: integer);

Procedure EMAILINFO(RetNo: integer; FName: String; FNo: integer); // 20150816
Procedure S100(RetNo: integer; FName: String; FNo: integer); // 20150816
Procedure S101(RetNo: integer; FName: String; FNo: integer);
Procedure S100CommonCalc(RetNo: integer; FName: String; FNo: integer);
Procedure S125(RetNo: integer; FName: String; FNo: integer); // 20150721
Procedure S88(RetNo: integer; FName: String; FNo: integer);
// 20140401   //20150527
Procedure EFConfirm(RetNo: integer; FName: String; FNo: integer);
Procedure TESTFRM(RetNo: integer; FName: String; FNo: integer);
Procedure S430(RetNo: integer; FName: String; FNo: integer); // 20130505

Function GetS54Adj(RetNo: integer; Dt: String): Real;
Function GetRunningExcessive(RetNo, UpTo: integer): Real;
Procedure T1131(RetNo: integer; FName: String; FNo: integer);
// Procedure S393(RetNo: integer; FName: String;FNo: integer); //20130505
Procedure S394(RetNo: integer; FName: String; FNo: integer); // 20140408
Procedure S392(RetNo: integer; FName: String; FNo: integer);
// 20130505      //20221123

Procedure S5I(RetNo: integer; FName: String; FNo: integer);
procedure T183CP(RetNo: integer; FName: string; FNo: integer);
Procedure UsedFrm(RetNo: integer; FName: String; FNo: integer);
Procedure CalcUsedFrm(RetNo: integer);

procedure S12(RetNo: integer; FName: string; FNo: integer);

Procedure S32Assist(RetNo: integer; FName: String; FNo: integer);
Procedure AefDone(RetNo: integer; FName: String; FNo: integer);

Procedure SetQuestionnaire(RetNo: integer; Frm: String; i: integer; j: integer);
Procedure Recalc(RetNo: integer; FName: String);
Procedure CalcForeignCredits(RetNo: integer);
Procedure CalcMultiPageForm(RetNo: integer; FName: string);
Function FedPolCredit(PolContr: Real): Real;
// 20171031 Igor>>>
// Procedure CalcAffectedBy(RetNo: integer; FName: String);
// 20171031 Igor<<<
procedure T2(RetNo: integer; FName: string; FNo: integer);
procedure AMEND(RetNo: integer; FName: string; FNo: integer);

procedure S141(RetNo: integer; FName: string; FNo: integer);
// 20150829 instead od FNot1
procedure FNOTE2(RetNo: integer; FName: string; FNo: integer);

Procedure BLimit(RetNo: integer; FName: String; FNo: integer);
Procedure S53(RetNo: integer; FName: String; FNo: integer);
Procedure S53ADJ(RetNo: integer; FName: String; FNo: integer);
Procedure S53ADD06(RetNo: integer; FName: String; FNo: integer);
Procedure S54(RetNo: integer; FName: String; FNo: integer);
Procedure S54WS1(RetNo: integer; FName: String; FNo: integer);
Procedure S54WS2(RetNo: integer; FName: String; FNo: integer);
Procedure S54ADJ(RetNo: integer; FName: String; FNo: integer);
Procedure S55(RetNo: integer; FName: String; FNo: integer);

Procedure CalcFed(RetNo: integer);
Procedure CALCONT(RetNo: integer);
Procedure CALCALB(RetNo: integer);

Procedure LETR_1(RetNo: integer; FName: String; FNo: integer);
Procedure LETR_2(RetNo: integer; FName: String; FNo: integer);
procedure NPAD(RetNo: integer; FName: String; FNo: integer);
procedure PRIVAT(RetNo: integer; FName: String; FNo: integer);
procedure NPADC(RetNo: integer; FName: String; FNo: integer);
procedure ADDINFO(RetNo: integer; FName: String; FNo: integer);
procedure SUPPL(RetNo: integer; FName: String; FNo: integer);
procedure STATUS(RetNo: integer; FName: String; FNo: integer);
procedure TAXSUM(RetNo: integer; FName: String; FNo: integer);
procedure COMPSUM(RetNo: integer; FName: String; FNo: integer);
procedure CalcCommonS2(RetNo: integer; FName: string; FNo: integer);
procedure CalCCommonS13(RetNo: integer; FName: string; FNo: integer);
Procedure FldMEM(RetNo: integer; FName: String; FNo: integer);
Procedure FLDTAPE(RetNo: integer; FName: String; FNo: integer);
Procedure T106(RetNo: integer; FName: String; FNo: integer);
Procedure T106SL(RetNo: integer; FName: String; FNo: integer);
Procedure T2002(RetNo: integer; FName: String; FNo: integer);
Procedure S428(RetNo: integer; FName: String; FNo: integer);
Procedure S429(RetNo: integer; FName: String; FNo: integer);
Procedure S387(RetNo: integer; FName: String; FNo: integer);
Procedure S390(RetNo: integer; FName: String; FNo: integer);
// Procedure S391(RetNo: integer; FName: String;FNo: integer);
// Procedure S490(RetNo: integer; FName: String;FNo: integer);  //20170525

// 20160424
Procedure S309(RetNo: integer; FName: String; FNo: integer);
Procedure S348(RetNo: integer; FName: String; FNo: integer);


//jz 20240424 - adding new forms S56 S572 T2047 <<<
Procedure S56(RetNo: integer; FName: String; FNo: integer);
Procedure S572(RetNo: integer; FName: String; FNo: integer);
Procedure T2047(RetNo: integer; FName: String; FNo: integer);
//jz 20240424 - adding new forms S56 S572 T2047 >>>


{ I M P L E M E N T A T I O N }
implementation

Uses
  SysUtils, ComCtrls,
  Dialogs, // 20150824 useful for showmessage
  vtMulti, vtCommon, vtMain,
  // ChildWinNew,
  T2_2027, T2_2027Multi,
  T2_2027Declare, T2_2027common, T2_2027common2, T2_2027TrimStr,
  T2_2027Calc1, T2_2027Calc2, T2_2027Calc3, T2_2027Calc4, T2_2027Calc5,
  T2_2027CalcPdf,
  vtShared, vtTrimStr,
  vtDynData; // 20150721;

// 20200810
Procedure InitT1Constants;
Begin
  T1Constant[0].CPPRate := 0.0525; // for t12019
  T1Constant[1].CPPRate := 0.0525; // ??
  // T1BasicCPPExempt    := 3500;  //3500
  T1Constant[0].MaxCppPremium := 2898;
  T1Constant[1].MaxCppPremium := 2898;

  T1Constant[0].MaxCppEarnings := 58700;
  T1Constant[1].MaxCppEarnings := 58700;

  T1Constant[0].EligDivGrossUpRate := 1.38; // actual
  T1Constant[1].EligDivGrossUpRate := 1.38; // actual

  T1Constant[0].NonEligDivGrossUpRate := 1.15; // actual
  T1Constant[1].NonEligDivGrossUpRate := 1.15; // actual
End;

Procedure CalcMultiPageForm(RetNo: integer; FName: string);
Var
  i, n: integer;
  Root: string; // [10]; //20150701//Root:string[10];
begin
  n := GetFormMxPg(FName);
  Root := ExtractFormRootName(FName);
  For i := 1 to n do
    Calc(RetNo, Root + '_' + IntToStr(i) + ExtractFormInst(FName));
end;
// 20171031 Igor>>>
(*
  Procedure CalcAffectedBy(RetNo: integer;FName: string);
  var
  i,k,FNo : integer;
  NonInst : string;//[10]; //20150701
  FInst : string;//[4]; //20150701
  begin
  NonInst := ExtractNonInstFormName(FName);
  {following before normal affected}
  K :=11;
  with FList do begin
  For i := 0 to AffectedList.Count - 1 do
  begin
  If NonInst = Rtrim(LeftStr(AffectedList[i],10)) then
  begin
  Finst := ExtractFormInst(FName);
  Repeat
  If RTrim(MidStr(AffectedList[i],k,9)) > '' then
  begin
  FNo := GetFormNo(RTrim(MidStr(AffectedList[i],k,9)));
  If Fno >0 then  {effected is single}
  Calc(RetNo,RTrim(MidStr(AffectedList[i],k,9)))
  else
  Calc(RetNo,RTrim(MidStr(AffectedList[i],k,9))+FInst);
  end;
  K := K+10;
  until k > 81;
  end;
  end;
  end //with
  end;
*)
// 20171031 Igor<<<

(* 20150703
  Procedure CalcAffectedBy(RetNo: integer;FName: string);
  var
  i,k,FNo : integer;NonInst : string[10]; FInst : string[4];
  begin
  NonInst := ExtractNonInstFormName(FName);
  {following before normal affected}
  K :=11;
  For i := 0 to AffectedList.Count - 1 do
  begin
  If NonInst = Rtrim(LeftStr(AffectedList[i],10)) then
  begin
  Finst := ExtractFormInst(FName);
  Repeat
  If RTrim(MidStr(AffectedList[i],k,9)) > '' then
  begin
  FNo := GetFormNo(RTrim(MidStr(AffectedList[i],k,9)));
  If Fno >0 then  {effected is single}
  Calc(RetNo,RTrim(MidStr(AffectedList[i],k,9)))
  else
  Calc(RetNo,RTrim(MidStr(AffectedList[i],k,9))+FInst);
  end;
  K := K+10;
  until k > 81;
  end;
  end;
  end;
*)
Procedure S141(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If Strings[4] + Strings[9] = '' then
    begin
      Strings[4] := 'X';
      Strings[9] := '';
    end; // 20220628

    { //20220628
      If FetchElm(RetNo,'T2',51)>'' then   //20220509
      begin Strings[4]:='X';Strings[9]:='';end
      Else
      begin Strings[4]:='';Strings[9]:='X';end;
    }


    //default all in part 4 to NO //jz 20240523

    If Strings[12] + Strings[13] = '' then Strings[13] := 'X';

    If Strings[18] + Strings[19] = '' then Strings[19] := 'X';
    If Strings[20] + Strings[21] = '' then Strings[21] := 'X';
    If Strings[22] + Strings[23] = '' then Strings[23] := 'X';
    If Strings[24] + Strings[25] = '' then Strings[25] := 'X';

    If Strings[26] + Strings[27] = '' then Strings[27] := 'X';


    { //jz 20240523 formed changed, doenst make sense??
    i := 14;
    If Strings[12] > '' then
      Repeat
        If Strings[i] + Strings[i + 1] = '' Then
          Strings[i + 1] := 'X';
        Inc(i, 2);
      until i > 24
    else
    begin
      i := 14;
      repeat
        Strings[i] := '';
        Strings[i + 1] := '';
        Inc(i, 2);
      until i > 24;
    end;
    }

    //20231001
    If Strings[34]+Strings[35] = '' then
    begin
      Strings[38] := '';
      Strings[39] := '';
    end;

   {//20231001
    If (Strings[7] > '') or (Strings[32] > '') then
    begin
      // Strings[34]:='';Strings[35]:='';Strings[36]:='';
      Strings[38] := '';
      Strings[39] := '';
    end;

    If Strings[36] > '' then
    begin
      Strings[38] := '';
      Strings[39] := '';
    end;
   }
    If Strings[52] + Strings[51] = '' then
      Strings[51] := 'X'; // 20111011
  end;

  SaveTv(RetNo, FName, FNo);

end;

Procedure FNOTE2(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    LoadTv(RetNo, FName, FNo);
    with Ret[RetNo].Frm[FNo] do
    begin
      FillHeader(RetNo, FNo, 1, 2, 3); // 20121211
      Strings[4] :=
        'You can copy and paste from a pure Text file (TXT) (maximum 5 pages or 500 lines)';
      // 20121211
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20220918 version

Procedure T2(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
  { Pg2FNo, } FNoS1: integer;
  BegYear: string; // [10]; //20150701 //BegYear :string[10];
  ReductionRate, Ln632: Real;
  Rd,x: Real;
  S3FNo, S53FNo, S7FNo: integer;  //20231109
begin
  FormatSettings.DecimalSeparator := '.'; // 20130604   //20150703
  LoadTv(RetNo, FName, FNo);
  // T2 pg1-----------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    if UpperCase(Strings[270]) = '' then Strings[270] := 'N'; //2025o703

    Strings[1] := FixBusinessNumberMissingRC(Strings[1]); // 20190820
    // if Strings[2]='MJ' then Strings[2]:='Multiple';     //20190823

   if Strings[81]<> 'Y' then Strings[81]:='';  //20221213

    if UpperCase(Strings[81]) = 'Y' then // 20221116 T183 completed
    Begin
      if Strings[82] = '' then
        Strings[82] := FormatDateTime('yyyy/mm/dd', Now);
      if Strings[80] = '' then
        Strings[80] := FormatDateTime('HH:MM:SS', Now);
    End
    Else
    Begin
      Strings[82] := '';
      Strings[80] := '';
    End;

    // 20171201
    If Strings[10] = '' then
    begin
      // 20231109
      Strings[10] := '2025/01/01'; ////20260313 202505m31
      Strings[11] := '2025/12/31'; //
    end;
    If Strings[11] = '' then
      Strings[11] := '2024/12/31'; // 202505m31
    // 20190805
    Strings[10] := ReplaceChar(Strings[10], '-', '/');
    Strings[11] := ReplaceChar(Strings[11], '-', '/');

    If Length(Strings[1]) = 9 then
      Strings[1] := Strings[1] + 'RC0001';
    Strings[1] := RemoveChar(Strings[1], ' ');
    // 20170525
    if UpperCase(Strings[216]) = 'Y' then
    begin
      Strings[177] := FormatFiscalStartTime(RetNo, Strings[177]);
      Strings[207] := FormatFiscalEndTime(RetNo, Strings[207]);
    end
    Else
    Begin
      Strings[177] := '';
      Strings[207] := '';
    End;

    if Strings[18] > '' then // change of control date entered
    begin
      Strings[77] := 'Y';
      Strings[78] := Strings[177];
      Strings[55] := Strings[207];
    end
    Else
    Begin
      Strings[77] := '';
      Strings[78] := '';
      Strings[55] := '';
    End;

    if UpperCase(Strings[77]) <> 'Y' then
    begin
      Strings[78] := '';
      Strings[55] := '';
    end;

    // ---------------

    If Strings[73] = '' then
      Strings[73] := 'Y'; // fees charged

    // 20130525
    If Strings[43] > '' then
      Strings[170] := ''; // dissolution

    If Strings[76] = '' then
    begin
      If OptRec.Nfl_Efile = True then
        Strings[76] := 'Y';
    end;

    If IsNonResidentCorp(RetNo)=True then Strings[72]:=''; //20240707  cz
    {  //20240707 cz
    {
    If Strings[72] > '' then // 20140602
    begin
      If (Strings[72] < '01') or (Strings[72] > '04') then
        Strings[72] := '';
      if Strings[49] > '' then
        Strings[72] := '';
      // 20161115  If Non res corp then functional currency not allowd
    end;
    }
    Strings[74] := GetEfilerNo;
    // 20160201  //if UpperCase(Strings[73])='Y' then Strings[74]:= GetEfilerNo else Strings[74]:='';
    If Strings[75] > '' then
      Strings[74] := ''; // 20160201

    If UpperCase(Strings[66]) <> 'Y' then
      Strings[66] := 'N'; // 20130201

    // gifi use indicator
    If Strings[71] = '' then
      Strings[71] := 'Y';
    If Strings[66] = '' then
      Strings[66] := 'N';

    If Length(Strings[3]) > 72 then
      Strings[3] := LeftStr(Strings[3], 72);

    // 20160427  //email data from T183CP but invisible in t2, so it is used for efile only
    Strings[6] := FetchElm(RetNo, 'T183CP', 28);
    Strings[5] := FetchElm(RetNo, 'T183CP', 18);

    If Strings[63] + Strings[64] = '' then
      Strings[64] := 'X'; { NR treaty }
    If UpperCase(Strings[67] + Strings[68]) = 'XX' then
      Strings[68] := ''; { loc of books change }
    If Strings[67] + Strings[68] = '' then
      Strings[68] := 'X'; { loc of books change }
    If Strings[69] + Strings[70] = '' then
      Strings[70] := 'X'; { loc of books change }

    if IsAmendedReturn(RetNo) then
    begin
      Strings[5] := '';
    end; // 20160605  Email info

    If Strings[8] + Strings[9] = '' then
      Strings[9] := 'X'; { adres chng }
    If UpperCase(Strings[8] + Strings[9]) = 'XX' then
      Strings[9] := ''; { adres chng }
    If Strings[21] + Strings[22] = '' then
      Strings[22] := 'X'; { mail adres chng }

    If Strings[14] + Strings[15] = '' then
      Strings[15] := 'X'; { chng of control }
    If UpperCase(Strings[14] + Strings[15]) = 'XX' then
      Strings[15] := 'X';
    If Strings[24] + Strings[25] = '' then
      Strings[25] := 'X';
    If UpperCase(Strings[24] + Strings[25]) = 'XX' then
      Strings[25] := '';
    If UpperCase(Strings[28] + Strings[29]) = 'XX' then
      Strings[29] := '';
    If UpperCase(Strings[30] + Strings[31]) = 'XX' then
      Strings[31] := '';
    If Strings[36] + Strings[37] = '' then
      Strings[37] := 'X';
    If UpperCase(Strings[36] + Strings[37]) = 'XX' then
      Strings[37] := '';
    If Strings[39] + Strings[40] = '' then
      Strings[40] := 'X';
    If UpperCase(Strings[39] + Strings[40]) = 'XX' then
      Strings[40] := '';
    If Strings[42] + Strings[43] = '' then
      Strings[43] := 'X';
    If UpperCase(Strings[42] + Strings[43]) = 'XX' then
      Strings[43] := '';
    If Strings[48] + Strings[49] = '' then
      Strings[48] := 'X';
    If Strings[52] + Strings[56] + Strings[57] + Strings[59] > '' then
      Strings[51] := '';
    If Strings[51] = '1' then
      Strings[51] := 'X';
    If Strings[62] = '' then
      Strings[62] := 'N/A';
    If UpperCase(Strings[48] + Strings[49]) = 'XX' then
      Strings[48] := '';
    If UpperCase(Strings[63] + Strings[64]) = 'XX' then
      Strings[64] := '';
    If UpperCase(Strings[21] + Strings[22]) = 'XX' then
      Strings[22] := '';
    { city, province }
    If Strings[16] = '' then
      Strings[16] := OptRec.Nfl_City;
    { prv vs country }
    If (Strings[17] = '') And (Strings[19] = 'CA') then
      Strings[17] := PrvShort[GetPrvNdx(OptRec.Nfl_Prov)];
    Strings[17] := LeftStr(Strings[17], 2);
    If Strings[2] = '' then
    Begin
      Ret[RetNo].Province := OptRec.Nfl_Prov;
      Strings[2] := PrvLong[GetPrvNdx(Ret[RetNo].Province)];
    end
    else
    begin
      Ret[RetNo].Province := GetShortPrv(Strings[2]);
      Strings[2] := PrvLong[GetPrvNdx(Ret[RetNo].Province)];
    end;

    SetNumDays(RetNo);
    If Strings[51] + Strings[52] + Strings[56] + Strings[57] + Strings[59] = ''
    then
      Strings[51] := 'X'; // CCPC
    SetCorpType(RetNo);

    { addresses }
    If Strings[38] = '' then
      Strings[38] := Strings[12];

    If Strings[47] = '' then
      Strings[47] := Strings[20];
    Strings[33] := LeftStr(Strings[33], 2);
    Strings[19] := LeftStr(Strings[19], 2);
    Strings[34] := LeftStr(Strings[34], 2);
    Strings[45] := LeftStr(Strings[45], 2);
    Strings[46] := LeftStr(Strings[46], 2);
    Strings[50] := LeftStr(Strings[50], 2);
    If Strings[48] > '' then
      Strings[50] := '';
    // CAPITALIZE etc.
    Strings[1] := UpperCase(Strings[1]);
    If OptRec.Capitalization = 'UpperCase' then
    begin
      Strings[3] := UpperCase(Strings[3]);
      Strings[65] := UpperCase(Strings[65]);
      // ho
      Strings[12] := UpperCase(Strings[12]);
      Strings[13] := UpperCase(Strings[13]);
      Strings[16] := UpperCase(Strings[16]);
      Strings[20] := UpperCase(Strings[20]);
      // mailing
      Strings[23] := UpperCase(Strings[23]);
      Strings[26] := UpperCase(Strings[26]);
      Strings[27] := UpperCase(Strings[27]);
      Strings[32] := UpperCase(Strings[32]);
      Strings[35] := UpperCase(Strings[35]);
      // books
      Strings[38] := UpperCase(Strings[38]);
      Strings[41] := UpperCase(Strings[41]);
      Strings[44] := UpperCase(Strings[44]);
      Strings[47] := UpperCase(Strings[47]);
    end
    else If OptRec.Capitalization = 'ProperCase' then
    begin
      Strings[3] := ConvertToProper(Strings[3]);
      Strings[65] := ConvertToProper(Strings[65]);
      // ho
      Strings[12] := ConvertToProper(Strings[12]);
      Strings[13] := ConvertToProper(Strings[13]);
      Strings[16] := ConvertToProper(Strings[16]);
      // mailing
      Strings[23] := ConvertToProper(Strings[23]);
      Strings[26] := ConvertToProper(Strings[26]);
      Strings[27] := ConvertToProper(Strings[27]);
      Strings[32] := ConvertToProper(Strings[32]);
      // books
      Strings[38] := ConvertToProper(Strings[38]);
      Strings[41] := ConvertToProper(Strings[41]);
      Strings[44] := ConvertToProper(Strings[44]);
    end;
  end;

  // T2 pg2-------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    // 20130515
    If Ret[RetNo].FrmHasData[GetFormNo('S9')] then
      Strings[101] := 'X'
    else
      Strings[101] := '';

    SetQuestionnaire(RetNo, 'S19', 103, 4);

    If ((Ret[RetNo].FrmHasData[GetFormNo('S23')]) and
      (Ret[RetNo].CorpType = CCPC)) then
      Strings[105] := 'X'
    else
      Strings[105] := '';

    If Ret[RetNo].FrmHasData[GetFormNo('S49')] then
      Strings[107] := 'X'
    else
      Strings[107] := '';
    If Vl(FetchElm(RetNo, 'S49', 127)) = 0 then
      Strings[107] := '';

    SetQuestionnaire(RetNo, 'S11', 109, 10);
    SetQuestionnaire(RetNo, 'S44', 111, 12);
    SetQuestionnaire(RetNo, 'S14', 113, 14);
    SetQuestionnaire(RetNo, 'S15', 115, 16);
    SetQuestionnaire(RetNo, 'T5004', 117, 18);
    SetQuestionnaire(RetNo, 'S22', 121, 22);
    SetQuestionnaire(RetNo, 'S25', 123, 24);
    SetQuestionnaire(RetNo, 'S29', 125, 26);

    If Ret[RetNo].FrmHasData[GetFormNo('S88')] // 20140401
    then
      Strings[196] := 'X'
    else
      Strings[196] := '';

    SetQuestionnaire(RetNo, 'S50', 131, 32);

    // non resident
    If UpperCase(FetchElm(RetNo, 'S20', 24)) = 'Y' then
      Strings[161] := 'X'
    else
      Strings[161] := '';

    // S1    top per fncl and bottom net income differ

    FNoS1 := GetFormNo('S1');
    If ((Vl(FetchElmFNo(RetNo, FNoS1, 34)) = 0) and
      (Vl(FetchElmFNo(RetNo, FNoS1, 53)) = 0) and
      (Vl(FetchElmFNo(RetNo, FNoS1, 4)) = Vl(FetchElmFNo(RetNo, FNoS1, 54))))
    then
      Strings[133] := ''
    else
      Strings[133] := 'X';

    if IsLifeInsuranceCorp(RetNo) then
      Strings[133] := ''; // 20161213

    SetQuestionnaire(RetNo, 'S2', 135, 36);
    SetQuestionnaire(RetNo, 'S3', 137, 38);
    If Vl(FetchElm(RetNo, 'S3', 250)) > 0 then
      Strings[137] := 'X';
    //202308/10

    if ((ABS(Vl(FetchElm(RetNo,'S4',40)))>0)  //thre is non-caploss
    and (Vl(FetchElm(RetNo,'S4',34))>0))      //closing still bal >0 not vaaried back
    or (Vl(FetchElm(RetNo,'S4',21))>0)   //20241028
    Or (Vl(FetchElm(RetNo,'S4',22))>0)    //20241028
    then
      Strings[139]:='X'
    Else
     Strings[139]:='';
   //SetQuestionnaire(RetNo, 'S4', 139, 40);

    If ShouldFileS5(RetNo) = True then
      Strings[141] := 'X'
    else
      Strings[141] := '';

    SetQuestionnaire(RetNo, 'S6', 143, 44);

    //20231026  'S7'        //20231109 as per T2-2023
    if UpperCase(Strings[85]) ='Y' then  //20231206
       Strings[145]:='X'
    Else
    Begin
     if (Vl(FetchElmFNo(RetNo,S7FNo,18))>0)
     or (Vl(FetchElmFNo(RetNo,S7FNo,13))>0)
     or (Vl(FetchElmFNo(RetNo,S7FNo,147))>0)
     or (Vl(FetchElmFNo(RetNo,S7FNo,258))>0)
     or (Vl(FetchElmFNo(RetNo,S7FNo,261))>0)
     then Strings[145]:='X'
    Else
     Strings[145]:='';
    End;
    {//20231026
    SetQuestionnaire(RetNo, 'S7', 145, 46);
    If Ret[RetNo].Ln[440] > 0 then Strings[145] := 'X';
    }
    SetQuestionnaire(RetNo, 'S8#1', 147, 48);
    SetQuestionnaire(RetNo, 'S10', 149, 50);
    SetQuestionnaire(RetNo, 'S12', 151, 52);
    If RsiS13HasData(RetNo) then
      Strings[153] := 'X'
    else
      Strings[153] := '';
    SetQuestionnaire(RetNo, 'S16', 155, 56);
    SetQuestionnaire(RetNo, 'S18', 159, 60);
    SetQuestionnaire(RetNo, 'S21', 163, 64);
    SetQuestionnaire(RetNo, 'S27', 167, 68);

    If (Vl(FetchElm(RetNo, 'T2', 636)) > 0) or
      (Vl(FetchElm(RetNo, 'T2', 715)) > 0)
    // If (Vl(FetchElm(RetNo,'PAGE_7',36)) >0) or (Vl(FetchElm(RetNo,'PAGE_8',15)) >0)
    then // credit available
      StoreElm(RetNo, FNo, 169, 'X')
    else
      StoreElm(RetNo, FNo, 169, '');

    SetQuestionnaire(RetNo, 'T661', 171, 72);

    // 20160603  Taxable capital
    if Vl(FetchElm(RetNo, 'S33', 114)) > 10000000 then
    Begin
      StoreElm(RetNo, FNo, 173, 'X');
      StoreElm(RetNo, FNo, 194, 'X');
    end; // 20160603
    if Vl(FetchElm(RetNo, 'S34', 108)) > 10000000 then
    Begin
      StoreElm(RetNo, FNo, 173, 'X');
      StoreElm(RetNo, FNo, 194, 'X');
    end; // 20160603
    if Vl(FetchElm(RetNo, 'S35', 229)) > 10000000 then
    Begin
      StoreElm(RetNo, FNo, 173, 'X');
      StoreElm(RetNo, FNo, 194, 'X');
    end; // 20160603

    // If Ret[RetNo].FrmHasData[GetFormNo('S37')] then Strings[177]:='X' else Strings[177]:='';  //20161112
    SetQuestionnaire(RetNo, 'S38', 179, 80);
    // SetQuestionnaire(RetNo,'S42',81,82);  //set manually

    If (Vl(FetchElm(RetNo, 'T2', 705)) > 0) or
      (Vl(FetchElm(RetNo, 'T2', 707)) > 0)
    // If (Vl(FetchElm(RetNo,'PAGE_8',5)) >0) or (Vl(FetchElm(RetNo,'PAGE_8',7)) >0)
    then
      Strings[183] := 'X'
    else
      Strings[183] := '';

    SetQuestionnaire(RetNo, 'S45', 185, 86);
    SetQuestionnaire(RetNo, 'S46', 187, 88);
    SetQuestionnaire(RetNo, 'S39', 189, 90);

    If Ret[RetNo].FrmHasData[GetFormNo('S48#1')] then
      Strings[191] := 'X'
    else
      Strings[191] := '';

    If Ret[RetNo].FrmHasData[GetFormNo('S58')] then // 20201111
      Strings[233] := 'X'
    else
      Strings[233] := '';

    If Ret[RetNo].FrmHasData[GetFormNo('S63')] then // 20220509
      Strings[256] := 'X'
    else
      Strings[256] := '';


    // s47 not supported
    If Ret[RetNo].FrmHasData[GetFormNo('T1131#1')] then
      Strings[195] := 'X'
    else
      Strings[195] := '';
    // xiii.1 tax
    If Vl(FetchElm(RetNo, 'T2', 759)) > 0 then
    // If Vl(FetchElm(RetNo,'PAGE_8',59)) >0 then
      Strings[193] := 'X'
    else
      Strings[193] := '';
  end;


  // T2 pg3 ----------------------------------------------------------------------

  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 235, 236, 237);
    If Numeric(Strings[203]) = false then
      Strings[203] := ''; // 20130602
    If RealNumeric(Strings[209]) = false then
      Strings[209] := ''; // 20121205
    If RealNumeric(Strings[211]) = false then
      Strings[211] := ''; // 20121205
    If RealNumeric(Strings[213]) = false then
      Strings[213] := ''; // 20121205

    If (Vl(Strings[209]) > 100) or (Vl(Strings[209]) < 0) then
      Strings[209] := '';
    If (Vl(Strings[211]) > 100) or (Vl(Strings[211]) < 0) then
      Strings[211] := '';
    If (Vl(Strings[213]) > 100) or (Vl(Strings[213]) < 0) then
      Strings[213] := '';

    If Ret[RetNo].FrmHasData[GetFormNo('T1135')] then
      Strings[241] := 'X'
    else
      Strings[241] := '';

    If Ret[RetNo].FrmHasData[GetFormNo('T1141#1')] then
      Strings[242] := 'X'
    else
      Strings[242] := '';
    If Ret[RetNo].FrmHasData[GetFormNo('T1142#1')] then
      Strings[243] := 'X'
    else
      Strings[243] := '';
    If Ret[RetNo].FrmHasData[GetFormNo('T1145#1')] then
      Strings[245] := 'X'
    else
      Strings[245] := '';
    If Ret[RetNo].FrmHasData[GetFormNo('T1146#1')] then
      Strings[246] := 'X'
    else
      Strings[246] := '';
    If Ret[RetNo].FrmHasData[GetFormNo('T1174#1')] then
      Strings[247] := 'X'
    else
      Strings[247] := '';

    If Vl(FetchElm(RetNo, 'S55', 4)) + Vl(FetchElm(RetNo, 'S55', 9)) > 0 then
      Strings[227] := 'X'
    else
      Strings[227] := '';

    If FetchElm(RetNo, 'T2002', 20) > '' then
      Strings[238] := 'X'
    else
      Strings[238] := '';

    If FetchElm(RetNo, 'T2002', 21) > '' then
      Strings[253] := 'X'
    else
      Strings[253] := '';

    If Ret[RetNo].FrmHasData[GetFormNo('S53')] then
      Strings[254] := 'X'
    else
      Strings[254] := '';
    if UpperCase(Strings[62]) = 'CREDIT UNION' then
      Strings[254] := ''; // 20181104

    If Ret[RetNo].FrmHasData[GetFormNo('S54')] then
      Strings[255] := 'X'
    else
      Strings[255] := ''; // 20111117

    //should lines 273, 274, 275,276 also have similar code? //jz

    If Ret[RetNo].FrmHasData[GetFormNo('S56')] then //jz 20240611
      Strings[124] := 'X'
    else
      Strings[124] := '';






    If Strings[201] + Strings[202] = '' then
      Strings[202] := 'X';
    If Strings[248] + Strings[249] = '' then
      Strings[249] := 'X';
    If Strings[250] + Strings[251] = '' then
      Strings[251] := 'X';

    If (Strings[252] > '') and (UpperCase(Strings[252]) <> 'X') then
      Strings[252] := 'X'; // 20130201
    If Strings[259] + Strings[252] = '' then
      Strings[252] := 'X';

    If UpperCase(Strings[204]) = 'X' then  Strings[205] := '';

    { Section: Taxable income and base amount of Part I tax }
    Tv[214] := Vl(FetchElm(RetNo, 'S1', 54));
    Tv[215] := Vl(FetchElm(RetNo, 'S2', 10)); // 24{donations}
    Tv[217] := Vl(FetchElm(RetNo, 'S2', 115)); { cult gifts }
    Tv[218] := Vl(FetchElm(RetNo, 'S2', 123)); { ecol gifts }
    //Tv[256] := Vl(FetchElm(RetNo, 'S2', 156)); { medicinie gifts } //jz vt49 line removed
    Tv[219] := Vl(FetchElm(RetNo, 'S3', 146)); { div }
    // Vl (FetchElm (RetNo, 'S3', 95)); {div}  //20190428

    // 20110611
    Tv[220] := RoundCorrect(3.5 * Vl(FetchElm(RetNo, 'S43', 124)));
    // 20141115//3.2 * Vl (FetchElm (RetNo, 'S43',124));
    If GetTaxationYearEndYYYY(RetNo) < 2010 then
      Tv[220] := RoundCorrect(3 * Vl(FetchElm(RetNo, 'S43', 124)));
    If GetTaxationYearEndYYYY(RetNo) > 2011 then
      Tv[220] := RoundCorrect(3.5 * Vl(FetchElm(RetNo, 'S43', 124)));

    Tv[221] := Vl(FetchElm(RetNo, 'S4', 21)); { non cap }
    Tv[222] := Vl(FetchInclusionRateString(RetNo)) *  Vl(FetchElm(RetNo, 'S4', 108));
    Tv[223] := Vl(FetchElm(RetNo, 'S4', 207)); // restr
    Tv[224] := Vl(FetchElm(RetNo, 'S4', 123)); { farm }
    Tv[225] := Vl(FetchElm(RetNo, 'S4', 407)); { limited partn }

    TV[134]:=Vl(FetchElm(RetNo, 'S4', 52));  //20250624

    // 20171105
    Tv[229] := Tv[215]; // + Tv[256]; //jz vt49 line removed
    // 20180417 Igor >>>
    For i := 217 to 228 do
      if i <> 227 then
        Tv[229] := Tv[229] + Tv[i];

    // 20180417 Igor <<<
    Tv[229] := Tv[229] + Tv[271]+Tv[134]; // 20250517 CZ


    Tv[244] := Tv[229];
    Tv[230] := MaxR(0, Tv[214] - Tv[244]); // 20200926
    Tv[232] := Tv[230] + Tv[231];
    Ret[RetNo].Ln[300] := Tv[214];
    Ret[RetNo].Ln[311] := Tv[215];
    Ret[RetNo].Ln[313] := Tv[217];
    Ret[RetNo].Ln[314] := Tv[218];
    //Ret[RetNo].Ln[315] := Tv[256]; //jz vt49 line removed
    Ret[RetNo].Ln[320] := Tv[219];
    Ret[RetNo].Ln[325] := Tv[220];
    Ret[RetNo].Ln[331] := Tv[221];
    Ret[RetNo].Ln[332] := Tv[222];
    Ret[RetNo].Ln[333] := Tv[223];
    Ret[RetNo].Ln[334] := Tv[224];
    Ret[RetNo].Ln[335] := Tv[225];
    Ret[RetNo].Ln[340] := Tv[226];
    Ret[RetNo].Ln[350] := Tv[228];
    Ret[RetNo].Ln[355] := Tv[231];
    Ret[RetNo].Ln[360] := Tv[232];
  end;

  // T2 pg4 ----------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    if (Ret[RetNo].CorpType = CCPC)
    and (IsSubstantiveCCPC(RetNo)=false)  //20240707
    then
    begin
      Tv[335] := MaxR(0, Vl(FetchElm(RetNo, 'S7', 162)));
      If Vl(FetchElm(RetNo, 'S16', 125)) > 0 then
        Tv[335] := Vl(FetchElm(RetNo, 'S16', 125));
      Ret[RetNo].Ln[400] := Tv[335]; // 20160506
      // 20120329
      Ret[RetNo].Ln[632] := Vl(FetchElm(RetNo, 'S21', 103));
      Ret[RetNo].Ln[636] := Vl(FetchElm(RetNo, 'S21', 100));

      Ln632 := Ret[RetNo].Ln[632];
      If GetTaxationYearStart(RetNo) > '2011/10/31' then
        Ln632 := (GetNumDays(RetNo, DateToddmmyyyy(GetTaxationYearStart(RetNo)),
          'A') - GetNumDays(RetNo, '31-10-2011', 'A')) / Ret[RetNo].DaysInYear +
          (GetNumDays(RetNo, '31-10-2011', 'A') - GetNumDays(RetNo,
          DateToddmmyyyy(GetTaxationYearEnd(RetNo)), 'A')) / Ret[RetNo]
          .DaysInYear;

      // 20220623
      Tv[336] := RoundCorrect(MaxR(0, Ret[RetNo].Ln[360] - (100 / 28) *
        Ret[RetNo].Ln[632] // 20120604 //20121027
        - 4 * Ret[RetNo].Ln[631]));

     // bizlimit
      Tv[337] := 500000; // Tv[333];  //20111129 //20141101
      If IsAssociated(RetNo) then
        Tv[337] := Vl(FetchElm(RetNo, 'S23', 10));
      If Ret[RetNo].DaysInYear < 357 then
        Tv[337] := RoundCorrect(Tv[337] * Ret[RetNo].DaysInYear / 365);
      BegYear := FetchElm(RetNo, 'T2', 10); // FetchElm(RetNo,'PAGE 1',10);

      //20240705
      Tv[340]:=Tv[337];
      //Tv[338] from whwere?
      Tv[339]:=Roundcorrect(Tv[340]*Tv[338]/90000);  //20250517
      if UpperCase(Strings[234]) = 'Y' then Tv[92] := Tv[269];  //override is Y
      Tv[93] := MaxR(0, Tv[92] - 50000);
      Tv[94] := Tv[337];
      Tv[95] := Tv[93];
      Tv[98] := Round((Tv[94] / 100000) * Tv[95]);
      Tv[99] := MaxR(Tv[339],Tv[98]);  //20250517

      Tv[84] := MaxR(0, Tv[337] - Tv[99]);
      // ----- do the specified table first //20161112
      // 20170410
      Tv[86] := 0;
      Tv[87] := 0;
      i := 272;
      Repeat
        if Strings[i] = '' then
        begin
          Strings[i + 1] := '';
          Tv[i + 2] := 0;
        end; // Tv[i+3]:=0;end;
        Tv[86] := Tv[86] + Tv[i + 1];
        Tv[87] := Tv[87] + Tv[i + 2];
        Inc(i, 4);
      until i > 304;

      Ret[RetNo].Ln[510]:=Tv[86];  //20250517  //30630 Cz
      Ret[RetNo].Ln[515]:=Tv[87];  //20230630 CON\
      // ------------------

      Tv[116] := Tv[87];
      Tv[112] := MaxR(0, Tv[84] - Tv[116]);
      Tv[55] := MinR(MinR(Tv[335], Tv[336]), MinR(Tv[337], Tv[112]));
      Tv[343] := Tv[55] * 0.19;

      Ret[RetNo].Ln[400] := Tv[335];
      Ret[RetNo].Ln[405] := Tv[336];
      Ret[RetNo].Ln[410] := Tv[337];
      Ret[RetNo].Ln[415] := Tv[338];
      Ret[RetNo].Ln[417] := Tv[92];
      Ret[RetNo].Ln[422] := Tv[99];
      Ret[RetNo].Ln[426] := Tv[84];
      Ret[RetNo].Ln[428] := Tv[112];
      Ret[RetNo].Ln[430] := Tv[343];
    end
    Else // no CCPC
    Begin        // remove specified SBD
      for i:=335 to 340 do Begin Tv[i]:=0;end;
      Tv[92]:=0;Tv[93]:=0;Tv[98]:=0;Tv[99]:=0;
      Tv[84]:=0;Tv[116]:=0;Tv[112]:=0;Tv[55]:=0;Tv[343]:=0;
      Ret[RetNo].Ln[400] := 0;
      Ret[RetNo].Ln[405] := 0;
      Ret[RetNo].Ln[410] := 0;
      Ret[RetNo].Ln[415] := 0;
      Ret[RetNo].Ln[417] := 0;
      Ret[RetNo].Ln[422] := 0;
      Ret[RetNo].Ln[426] := 0;
      Ret[RetNo].Ln[428] := 0;
      Ret[RetNo].Ln[430] := 0;

     { //20250517
      i := 272;
      Repeat
        Strings[i] := '';
        Tv[i + 1] := 0;
        Tv[i + 2] := 0;
        Inc(i, 4);
      Until i > 304;
      Tv[86] := 0;
      Tv[87] := 0;

      // zero out other fields
      Tv[335] := 0;
      Tv[335] := 0;
      Ret[RetNo].Ln[400] := 0;
      // 20120329
      Ret[RetNo].Ln[632] := 0;
      Ret[RetNo].Ln[636] := 0;
      Ln632 := 0;
      Tv[336] := 0;
      Tv[336] := 0;
      Tv[337] := 0;
      Tv[341] := 0;
      Tv[340] := 0;
      Tv[339] := 0;
      Tv[93] := 0;
      Tv[94] := 0;
      Tv[95] := 0;
      Tv[98] := 0;
      Tv[99] := 0;
      Tv[84] := 0;
      // ------------------
      Tv[116] := 0;
      Tv[112] := 0;
      Tv[343] := 0;
      Ret[RetNo].Ln[400] := 0;
      Ret[RetNo].Ln[405] := 0;
      Ret[RetNo].Ln[410] := 0;
      Ret[RetNo].Ln[415] := 0;
      Ret[RetNo].Ln[417] := 0;
      Ret[RetNo].Ln[422] := 0;
      Ret[RetNo].Ln[426] := 0;
      Ret[RetNo].Ln[428] := 0;
      Ret[RetNo].Ln[430] := 0;
      }
    End;
  end; // with pg4


  // T2 pg5 ----------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin // gen tax reduction
    if (Ret[RetNo].CorpType = CCPC)
    Or (IsSubstantiveCCPC(RetNo)=True) //20240707
    then
    begin
      Tv[401] := Ret[RetNo].Ln[360];
      Tv[403] := MinR(Vl(FetchElm(RetNo, 'S27', 216)),
        Vl(FetchElm(RetNo, 'S27', 224)));
      Tv[407] := MinR(MinR(Ret[RetNo].Ln[400], Ret[RetNo].Ln[405]),
        MinR(Ret[RetNo].Ln[410], Ret[RetNo].Ln[428]));
      Tv[408] := Vl(FetchElm(RetNo, 'T2', 504));
      Tv[410] := Tv[403] + Tv[404] + Tv[419] + Tv[407] + Tv[408]; // +Tv[433]
      Tv[411] := Tv[410];
      Tv[412] := MaxR(0, Tv[401] - Tv[411]);
      Tv[417] := RoundCorrect(Tv[412] * 13 / 100);
      Tv[419] := Vl(FetchElm(RetNo, 'S7', 157));
      Ret[RetNo].Ln[638] := Tv[417]; // 20120329
      Ret[RetNo].Ln[432] := Tv[419]; // 20120603
    end
    Else
    Begin
      Tv[401] := 0;
      Tv[403] := 0;
      Tv[407] := 0;
      Tv[408] := 0;
      Tv[410] := 0;
      Tv[411] := 0;
      Tv[412] := 0;
      Tv[417] := 0;
      Ret[RetNo].Ln[638] := 0;
      Ret[RetNo].Ln[432] := 0;
    End;
  end; // with

  with Ret[RetNo].Frm[FNo] do
  begin
    if (Ret[RetNo].CorpType = CCPC) or (Ret[RetNo].CorpType = Other) and
      (IsCooperativeCorp(RetNo)) // 20120512
    Or (isSubstantiveCCPC(RetNo)=True)   //20240707
    then
    begin
      Tv[418] := 0;
      Tv[420] := 0;
      Tv[424] := 0;
      Tv[444] := 0;
      Tv[425] := 0;
      Tv[426] := 0;
      Tv[427] := 0;
      Tv[432] := 0;
      Ret[RetNo].Ln[639] := 0;
      Ret[RetNo].Ln[434] := 0;
    end
    Else
    begin
      Tv[418] := RoundCorrect(MaxR(0, Ret[RetNo].Ln[360]));
      // RoundCorrect(MaxR(0,Vl(FetchElm(RetNo,'T2',234))));
      Tv[420] := MinR(Vl(FetchElm(RetNo, 'S27', 216)),
        Vl(FetchElm(RetNo, 'S27', 224)));
      If IsCreditUnion(RetNo) then
        Tv[424] := Vl(FetchElm(RetNo, 'S17', 81))
      Else
        Tv[424] := 0;
      Tv[444] := Vl(FetchElm(RetNo, 'S7', 157)); // 20161116
      Tv[425] := Tv[420] + Tv[421] + Tv[444] + Tv[424]; // 20120603
      Tv[426] := Tv[425];
      Tv[427] := MaxR(0, Tv[418] - Tv[426]);
      Tv[432] := RoundCorrect(Tv[427] * 13 / 100);
      // 20141101Tv[428]+Tv[436]+Tv[423]+Tv[468];
      Ret[RetNo].Ln[639] := Tv[432]; // 20120329
      Ret[RetNo].Ln[434] := Tv[444]; // 20120603
    end; // ccpc and other
  end; // with

  // T2 pg6 ----------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 501, 502, 503);
    If (Ret[RetNo].CorpType = CCPC)
    Or (IsSubstantiveCCPC(RetNo)=True)  //20240707
    then
    begin
      // several 20161112
      Tv[504] := Vl(FetchElm(RetNo, 'S7', 48));
      If IsCreditUnion(RetNo) then
        Tv[504] := 0; // 20210927
      Tv[83] := Tv[504];
      Tv[106] := RoundCorrect(Tv[504] * (30.66667 / 100)); // 20180502

      Tv[506] := Vl(FetchElm(RetNo, 'T2', 630));
      Tv[507] := Vl(FetchElm(RetNo, 'S7', 46));
      If IsCreditUnion(RetNo) then
        Tv[507] := 0; // 20210927
      Tv[102] := RoundCorrect(Tv[507] * (8 / 100));
      Tv[505] := MaxR(0, Tv[506] - Tv[102]);
      Tv[97] := Tv[505];
      Tv[104] := MaxR(0, Tv[106] - Tv[97]); // 20190417

      Tv[512] := Vl(FetchElm(RetNo, 'T2', 232));
      Tv[513] := GetIncForSmBusDed(RetNo);
      Tv[516] := Tv[630]; // instead of 631  //20190417 box from 632
      Tv[136] := Tv[516] * (75 / 29); // 4;
      Tv[508] := Tv[631]; // from box 636
      Tv[100] := RoundCorrect(Tv[508] * 4);
      Tv[110] := Tv[513] + Tv[136] + Tv[100];
      Tv[108] := Tv[110];
      Tv[83] := MaxR(0, Tv[512] - Tv[108]);
      Tv[96] := RoundCorrect(Tv[83] * (30.66667 / 100));
      // 20180530 CON added rounding
      Tv[525] := MaxR(0, Vl(FetchElm(RetNo, 'T2', 701)) -
        Vl(FetchElm(RetNo, 'T2', 715)));
      Tv[526] := MinR(Tv[104], MinR(Tv[96], Tv[525]));
      If IsCreditUnion(RetNo) then
        Tv[526] := 0; // 20210927
    end // 20180711  (CCPC
    Else // 20180723
    Begin
      Tv[504] := 0;
      Tv[83] := 0;
      Tv[106] := 0;
      Tv[506] := 0;
      Tv[507] := 0;
      Tv[102] := 0;
      Tv[505] := 0;
      Tv[97] := 0;
      Tv[104] := 0;

      Tv[512] := 0;
      Tv[513] := 0;
      Tv[516] := Vl(FetchElm(RetNo, 'T2', 631));
      Tv[136] := 0;
      Tv[508] := 0;
      Tv[100] := 0;
      Tv[110] := 0;
      Tv[108] := 0;
      Tv[83] := 0;
      Tv[96] := 0;
      Tv[525] := 0;
      Tv[526] := 0;
    End;
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    if GetBegYearEnd(RetNo) < '2019/01/01' then // 20190416
    Begin
      { DTOH }
      Tv[529] := MaxR(0, Tv[527] - Tv[528]);
      Tv[530] := Tv[529];
      Tv[531] := Tv[526];
      Tv[532] := Vl(FetchElm(RetNo, 'S3', 209));
      Tv[534] := Tv[531] + Tv[532] + Tv[533];
      Tv[535] := Tv[534];
      Tv[536] := Tv[530] + Tv[535];
    end
    Else
    Begin
      for i := 527 to 528 do
      begin
        Tv[i] := 0;
      End; // 20190626  RDTOH
      for i := 529 to 532 do
      begin
        Tv[i] := 0;
      End;
      for i := 531 to 534 do
      begin
        Tv[i] := 0;
      End;
      Tv[535] := 0; // 20190507
      Tv[536] := 0;
    End;

    if GetBegYearEnd(RetNo) < '2019/01/01' then // 20190416
    Begin
      { div refund }
      Tv[538] := Vl(FetchElm(RetNo, 'S3', 252));
      Tv[158] := RoundCorrect(Tv[538] * 38.3333) / 100;
      Tv[539] := Tv[536];
      Tv[540] := MinR(Tv[158], Tv[539]);
    End
    Else
    Begin
      Tv[538] := 0;
      Tv[158] := 0;
      Tv[539] := 0;
      Tv[540] := 0;
    End;
  end;

  // T2 pg7 20190419 ---------------------------------------------
  S3FNo := GetFormNo('S3');
  S53FNo := GetFormNo('S53');
  with Ret[RetNo].Frm[FNo] do
  begin
    // 152, 154 is usr entry, rolled over from previuos yr
    Tv[156] := Vl(FetchElmFNo(RetNo, S3FNo, 161)); // 2G
    Tv[160] := Vl(FetchElmFNo(RetNo, S3FNo, 164));
    Tv[162] := Tv[156] + Tv[160];
    Tv[164] := Tv[162];
    Tv[168] := Tv[526];

    Tv[172] := Vl(FetchElmFNo(RetNo, S3FNo, 262));
    Tv[174] := Tv[164];
    // Tv[175]:=FetchElm(RetNo,'S43', ???  Fix 43 first
    Tv[176] := MaxR(0, Tv[172] - Tv[174] - Tv[175]);
    Tv[178] := Tv[176];

    Tv[184] := Vl(FetchElmFNo(RetNo, S3FNo, 158)); // 2D
    Tv[149] := MaxR(0, Tv[178] - Tv[184]); // 20190613
    Tv[186] := MaxR(0, Tv[154] + Tv[168] + Tv[180] + Tv[149] - Tv[182]);
    Tv[188] := MaxR(0, Tv[164] - MaxR(0, Tv[184] - Tv[178]));
    Tv[190] := MaxR(0, Tv[152] + Tv[165] + Tv[188] - Tv[166]); // 20190613

    Tv[192] := Vl(FetchElmFNo(RetNo, S3FNo, 177)); // * 38.3333)/100; //20190708
    Tv[197] := Tv[190];
    xx:=tv[197];
    Tv[198] := MinR(Tv[192], Tv[197]);
    yy:=tv[198];
    Tv[204] := Vl(FetchElmFNo(RetNo, S3FNo, 178)); // * 38.3333)/100;
    Tv[205] := Tv[186];
    Tv[235] := MinR(Tv[204], Tv[205]);
    Tv[236] := MaxR(0, Tv[204] - Tv[205]);
    Tv[237] := MaxR(0, Tv[197] - Tv[198]);
    Tv[239] := MinR(Tv[236], Tv[237]); // MaxR(0,Tv[236]-Tv[237]);  //20190720
    Tv[240] := Tv[198] + Tv[235] + Tv[239];
  End;

  // T2 pg 8 first  ----------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[604] := RoundCorrect(Tv[232] * 0.38); // 20211018 //20200926
    // Tv[604] := RoundCorrect(Ret[RetNo].Ln[360] * 0.38);  //20200926
    If IsTaxExempt(RetNo) then
      Tv[604] := 0;

    Tv[206] := RoundCorrect(Tv[200] * 5 / 100); // 20180502

    Tv[114]:=Vl(FetchElm(RetNo, 'S68', 65));  //20230604
    //20251117 Igor >>>
//    if (ToTMultiple(RetNo, 'S74', 31) > 0) then
      Tv[130]:= ToTMultiple(RetNo, 'S74', 31);
//    else
//      Tv[130]:= ToTMultiple(RetNo, 'S78', 169); //20250610  /
    //20251117 Igor <<<

    If (Ret[RetNo].CorpType = CCPC)
    Or (Ret[Retno].CorpType = OtherPrivate)  //20250424
    then
    begin
      Tv[642] := Vl(FetchElm(RetNo, 'S31', 1411));
      Tv[617] := Vl(FetchElm(RetNo, 'T2', 504));
      Tv[618] := GetTxblIncome(RetNo);
      Tv[619] := GetIncForSmBusDed(RetNo);
      Tv[620] := MaxR(0, Tv[618] - Tv[619]);
      Tv[621] := Tv[620];
      Tv[199] := RoundCorrect(MinR(Tv[617], Tv[621]) * (10.66667 / 100));
      // Tv[622]; //20180603
    end
    else
    Begin
      For i := 617 to 621 do
        Tv[i] := 0;
    End;

    Tv[623] := Tv[604] + Tv[206] + Tv[114] + Tv[642] + Tv[199] + Tv[130];  //20230601 CON  //jz VT49 added line 580
    Tv[624] := Vl(FetchElm(RetNo, 'T2', 343));
    // Vl(FetchElm(RetNo,'PAGE_4',43));
    { base for abatement : reduce by non-prov allocated taxable }
    { get taxable income outside canada }
    Tv[625] := Round(MaxR(0, GetTxblIncome(RetNo) - Vl(FetchElm(RetNo, 'S5',
      263))) * 0.10); // less outside canada
    If Ret[RetNo].Province = 'OC' then
      Tv[625] := 0;
    Tv[626] := Vl(FetchElm(RetNo, 'S27', 225));
    // Tv[628]:=Vl(FetchElm(RetNo,'S6',685));     //20180509     //20180528
    // Tv[629] := Vl(FetchElm(RetNo,'S17',63));   //20110302
    Tv[630] := Round(Vl(FetchElm(RetNo, 'S21', 103)));
    Tv[644] := Vl(FetchElm(RetNo, 'T2', 417));
    // Vl(FetchElm(RetNo,'PAGE_5',17));
    Tv[645] := Vl(FetchElm(RetNo, 'T2', 432));
    // Vl(FetchElm(RetNo,'PAGE_5',32));
    Tv[631] := Vl(FetchElm(RetNo, 'S21', 100)); { ? or lesser }
    Tv[632] := Vl(FetchElm(RetNo, 'S21', 283)); { ? or lesser }
    Tv[636] := Vl(FetchElm(RetNo, 'S31', 1467));
    // Vl(FetchElm(RetNo,'S31',735));
    Tv[639] := 0;
    For i := 624 to 627 do
      Tv[639] := Tv[639] + Tv[i];
    Tv[639] := Tv[639] + Tv[630] + Tv[631] + Tv[644] + Tv[645] + Tv[632] +
      Tv[633] + Tv[635] + Tv[636]; // 20190421
    Tv[640] := Tv[639];
    Tv[641] := MaxR(0, RoundCorrect(Tv[623]) - Round(Tv[640]));
  End;

  // T2 pg9 ----------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[757] := RsiApprovalCode;
    Strings[760] := RsiVersion;
    Strings[725] := OptRec.Prn_Disclm;
    Strings[710] := Ret[RetNo].Province; // FetchElm(RetNo,'PAGE 1',2);}
    // 20141116 {English}
    // DO NOT DEFAULT the language It must be 1 or 2
    // If (Strings[751]='') or (Strings[751]='X') then Strings[751] := '1';  // If Strings[751]+Strings[752]='' then Strings[751] := 'X'; {English}
    // If (Vl(Strings[751])<1) or (Vl(Strings[751])>2) then Strings[751]:='1';  //20141116

    If Strings[740] + Strings[741] = '' then
    begin
      Strings[740] := '';
      Strings[741] := '';
      if Ret[RetNo].CorpType = CCPC then
      begin
        Strings[740] := 'X';
        Strings[741] := '';
      end;
    end;
    If Strings[747] + Strings[748] = '' then
      Strings[747] := 'X';
    If UpperCase(Strings[747]) = 'X' then
    begin
      Strings[749] := '';
      Strings[750] := '';
      Strings[756] := '';
    end;
    // Aug 2008
    If Strings[745] = '' then
      Strings[745] := FormatDateTime('yyyy/mm/dd', Date);

    Tv[722] := 0; // not in effect
    Tv[701] := Vl(FetchElm(RetNo, 'T2', 641));
    // Vl(FetchElm(RetNo,'PAGE_7',41));

    Tv[126] := Vl(FetchElm(RetNo, 'S56', 15)); //jz 20240611

    Tv[704] := Vl(FetchElm(RetNo, 'S3', 209));
    Tv[705] := Vl(FetchElm(RetNo, 'S43', 130));

    Tv[706] := Vl(FetchElm(RetNo, 'S38', 320)); // 20221206
    // Tv[706] := Vl(FetchElm(RetNo,'S38_8',3));  //??
    Tv[707] := Vl(FetchElm(RetNo, 'S43', 124));
    Tv[118]:=Vl(FetchElm(RetNo, 'S67', 67)); //20230604
    Tv[138]:=Vl(FetchElm(RetNo, 'S78', 252)); //20250531
    Tv[708] := Vl(FetchElm(RetNo, 'S20', 124));
    Tv[722] := Vl(FetchElm(RetNo, 'S55', 8)) + Vl(FetchElm(RetNo, 'S55', 11));
    If IsNonResidentCorp(RetNo) = false then
      Tv[708] := 0;

    Tv[709] := 0;
    Tv[709] := Tv[701];
    For i := 704 to 708 do
      Tv[709] := Tv[709] + Tv[i]; // 20190613
    Tv[709] := Tv[709] + Tv[126] + Tv[722] + Tv[118] + Tv[759]  //20230627 CON //jz 20240617 added Tv[126]
               +Tv[138];  //20250517
    Strings[744] := AllTrim(LeftStr(Strings[744], 30)); // 20140602
    Strings[755] := AllTrim(LeftStr(Strings[755], 3)); // 20140602
    Strings[746] := AllTrim(LeftStr(Strings[746], 10)); // 20140602

    { Get provincial tax }
    Ret[RetNo].OntAlloc := GetOntAlloc(RetNo);
    Ret[RetNo].AlbAlloc := GetAlbAlloc(RetNo);

    If Ret[RetNo].Province = 'MJ' then
      Tv[711] := MaxR(0, GetTotNetPrvTaxes(RetNo))
    else { no multiple allocations }
    begin
      If (Ret[RetNo].Province = 'ON') then
      begin
        If IsAmalgamatedOntario(RetNo) = True then
          Tv[711] := MaxR(0, GetTotNetPrvTaxes(RetNo))
        else
          Tv[711] := 0
      end
      Else if (Ret[RetNo].Province = 'AB') then
        Tv[711] := 0
      else
        Tv[711] := MaxR(0, GetTotNetPrvTaxes(RetNo));
    end; // mj

    If IsTaxExempt(RetNo) then
      Tv[711] := 0;

    Tv[714] := Tv[709] + Tv[711]; // 20150315 //Tv[709]+Tv[713];

    Tv[715] := GetLn780(RetNo); // 20171202

    Tv[716] := Tv[240]; // 20200926//in pg7
    Tv[717] := Vl(FetchElm(RetNo, 'S18', 38));
    If Vl(FetchElm(RetNo, 'S5', 935)) <= 0 then
      Tv[724] := ABS(Vl(FetchElm(RetNo, 'S5', 935)))
    else
      Tv[724] := 0;

    // Tv[724]:=GetRefundableTaxCreditsAllProvinces(RetNo); //Could be better?

    Tv[727] := Vl(FetchElm(RetNo, 'T7B', 52));
    Tv[754] := TotMultiple(RetNo, 'S48', 48);
    Tv[763] := TotMultiple(RetNo, 'S58', 18); // 20200608
    Tv[723] := Vl(FetchElm(RetNo, 'S18', 161));
    If Tv[718] < 0 then
      Tv[718] := 0;

    Tv[734] := Vl(FetchElm(RetNo, 'S63', 97)); // 20220509 Fuel
     Tv[719] := TotMultiple(RetNo, 'T1131', 78);
    If Tv[719] < 0 then
      Tv[719] := 0;
    If Tv[720] < 0 then
      Tv[720] := 0;
    If Tv[754] < 0 then
      Tv[754] := 0;

    Tv[728] := 0;
    For i := 715 to 719 do
      Tv[728] := Tv[728] + Tv[i];
    Tv[728] := Tv[728] + Tv[734]; //+ Tv[735]; //jz VT49 removed line 799
    // 20220628 //Tv[428]:=Tv[728]+Tv[734]+Tv[735];
    Tv[728] := Tv[728] + Tv[754] + Tv[720] + Tv[723] + Tv[724] + Tv[727] +
      Tv[763]; // added 763 for s58

    Tv[729] := Tv[728];
    Tv[730] := Tv[714] - Tv[729];
    If Tv[730] < 0 then
    begin
      Tv[732] := ABS(Tv[730]);
      Tv[733] := 0;
    end
    else
    begin
      Tv[732] := 0;
      Tv[733] := Tv[730];
    end;
    Strings[758] := GetEfilerNo;
    Strings[120]:=OptRec.Prp_repid; //20230601
    // 20160201 Strings[758]:=Strings[74]; //20130606
    If UpperCase(Strings[73]) <> 'Y' then
      Strings[758] := ''; // 20160201
    // If UpperCase(Strings[763])='Y' then Tv[734]:=Tv[733];  //20130916  Enclosed payment //20141115


    Ret[RetNo].Ln[440] := Tv[504];
    Ret[RetNo].Ln[445] := Tv[507];
    Ret[RetNo].Ln[450] := Tv[526];
    Ret[RetNo].Ln[460] := Tv[527];
    Ret[RetNo].Ln[465] := Tv[528];
  //  Ret[RetNo].Ln[480] := Tv[533];  //20251204
    Ret[RetNo].Ln[485] := Tv[536];

    Ret[RetNo].Ln[550] := Tv[604];
    Ret[RetNo].Ln[600] := 0; // Tv[16];   //20110506
    Ret[RetNo].Ln[602] := Tv[642];
    Ret[RetNo].Ln[604] := Tv[199]; // Tv[622]; //20190710
    Ret[RetNo].Ln[608] := Tv[625];
    Ret[RetNo].Ln[616] := Tv[626];
    Ret[RetNo].Ln[620] := Tv[627];
    Ret[RetNo].Ln[624] := Tv[628];

    // Ret[RetNo].Ln[628] := Tv[629];   //20190710
    Ret[RetNo].Ln[632] := Tv[630];
    Ret[RetNo].Ln[636] := Tv[631];
    Ret[RetNo].Ln[638] := Tv[644];
    Ret[RetNo].Ln[639] := Tv[645];
    Ret[RetNo].Ln[640] := Tv[632];
    Ret[RetNo].Ln[648] := Tv[635];
    Ret[RetNo].Ln[652] := Tv[636];

    Ret[RetNo].Ln[700] := Tv[701];
    Ret[RetNo].Ln[704] := Tv[702];
    Ret[RetNo].Ln[705] := Tv[126];  //20241029
    Ret[RetNo].Ln[708] := Tv[703];
    Ret[RetNo].Ln[710] := Tv[722];
    Ret[RetNo].Ln[712] := Tv[704];
    Ret[RetNo].Ln[716] := Tv[705];
    Ret[RetNo].Ln[720] := Tv[706];
    Ret[RetNo].Ln[724] := Tv[707];
    Ret[RetNo].Ln[725] := Tv[118];  //20230606
    Ret[RetNo].Ln[726] := Tv[138];  //20250531
    Ret[RetNo].Ln[728] := Tv[708];

    Ret[RetNo].Ln[760] := Tv[711];
    Ret[RetNo].Ln[765] := 0; // Tv[712];  //20190628
    Ret[RetNo].Ln[770] := Tv[714];
    Ret[RetNo].Ln[780] := Tv[715];
    Ret[RetNo].Ln[784] := Tv[716];
    Ret[RetNo].Ln[788] := Tv[717];
    Ret[RetNo].Ln[792] := Tv[718];
    Ret[RetNo].Ln[795] := Tv[734]; // 20220509
    Ret[RetNo].Ln[796] := Tv[719];
    Ret[RetNo].Ln[797] := Tv[754];
    Ret[RetNo].Ln[798] := Tv[763]; // 20200608
//    Ret[RetNo].Ln[799] := Tv[735]; // 20220509 //jz VT49 removed line 799
    Ret[RetNo].Ln[800] := Tv[720];
    Ret[RetNo].Ln[801] := Tv[721];

    Ret[RetNo].Ln[804] := 0; // Tv[22];   //20090605
    Ret[RetNo].Ln[808] := Tv[723];
    Ret[RetNo].Ln[812] := Tv[724];
    // Ret[RetNo].Ln[815] := Tv[25];
    Ret[RetNo].Ln[816] := 0; // Ret[RetNo].Ln[816] := Tv[26]; //jun 25 2008

    Ret[RetNo].Ln[840] := Tv[727];
    Ret[RetNo].Ln[890] := Tv[728];

  End; // with

  SaveTv(RetNo, FName, FNo);
end;



Procedure SetQuestionnaire(RetNo: integer; Frm: String; i: integer; j: integer);
Var
  FNo: integer;
  Pg2FNo: integer;
begin
  FNo := GetFormNo(Frm);
  Pg2FNo := GetFormNo('T2');
  If FNo = 0 then
    exit;
  If Ret[RetNo].FrmHasData[FNo] then
    StoreElm(RetNo, Pg2FNo, i, 'X')
  else
    StoreElm(RetNo, Pg2FNo, i, '');
end;

procedure TAXSUM(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo); { needed for initialization }
  with Ret[RetNo].Frm[FNo] do
  begin
    // If Strings[2] ='' then
    Strings[2] := FetchElm(RetNo, 'T2', 745);
    // 20110302  //DateToMonthDayYear(Date);
    // Strings[1] := GetCorpName(RetNo);
    // Strings[4] :=GetAccountNumber(RetNo);
    FillHeader(RetNo, FNo, 1, 4, 3);
    // Strings[62]:= FetchElm(RetNo,'S546',6); //20110424 //FetchElm(RetNo,'OPG_1',1);

    Strings[63] := FetchElm(RetNo, 'AT1', 9);

    Strings[14] := FetchElm(RetNo, 'T2', 12); { addr1 }
    Strings[85] := FetchElm(RetNo, 'T2', 13); { addr2 }
    Strings[86] := FetchElm(RetNo, 'T2', 16) + ', ' + FetchElm(RetNo, 'T2', 17)
      + ', ' + FetchElm(RetNo, 'T2', 20);
    Strings[17] := FetchElm(RetNo, 'T2', 755) + ' ' + FetchElm(RetNo, 'T2',
      746); { tel }
    Strings[19] := FetchElm(RetNo, 'T2', 749); { contact }
    Strings[3] := GetTaxationYearEnd(RetNo);
    Strings[6] := IntToStr(Ret[RetNo].DaysInYear);
    Strings[7] := FetchElm(RetNo, 'T2', 2);
    Strings[21] := User.UserName; // 20170112 Igor
  end;
  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    { GIFI }
    // 20150826
    Tv[89] := Vl(FetchElm(RetNo, 'S100', 89)); // '2599'));
    Tv[91] := Vl(FetchElm(RetNo, 'S100', 8)); // 3499
    Tv[92] := Vl(FetchElm(RetNo, 'S100', 54)); // '3849'));
    Tv[90] := TotMultiple(RetNo, 'S125', 14); // 'GIFIIS','8299'); {15}
    Tv[94] := Vl(FetchElm(RetNo, 'S100', 29)); // 'GIFIBS#1','3500')); {60}

    Tv[93] := Vl(FetchElm(RetNo, 'S125#1', 8));
    // 'GIFIBS#1','9999')); {5}       //20120207

    if CountMultipleInstances(RetNo, 'S125') > 1
    // if CountS125IncStatements(RetNo)>1  //20160506
    then
      Tv[93] := Vl(FetchElm(RetNo, 'S140', 25));

    (*
      Tv[89] := Vl(FetchGifiElm(RetNo,'GIFIBS#1','2599')); {41}
      Tv[91] := Vl(FetchGifiElm(RetNo,'GIFIBS#1','3499')); {59}
      Tv[92] := Vl(FetchGifiElm(RetNo,'GIFIBS#1','3849'));  {70}
      Tv[90] := TotGifiMultiple(RetNo,'GIFIIS','8299'); {15}
      Tv[94] := Vl(FetchGifiElm(RetNo,'GIFIBS#1','3500')); {60}
      Tv[93] := Vl(FetchGifiElm(RetNo,'GIFIBS#1','9999')); {5}       //20120207
    *)
    Tv[24] := Ln[300];
    Tv[26] := Ln[311];
    // Tv[28] := Ln[312];   //20161113
    Tv[30] := Ln[320];
    Tv[32] := Ln[325];
    Tv[35] := Ln[333];
    Tv[37] := Ln[331];
    Tv[38] := Ln[332];
    Tv[39] := Ln[334];
    Tv[40] := Ln[360];

    Tv[61] := Ln[400];

    Tv[23] := Ln[708];
    Tv[96] := Ln[710];
    // Tv[56] := Ln[765]; //???  //20190628

    Tv[42] := Ln[700];
    Tv[08] := Ln[704];
    Tv[10] := Ln[705]; //20241103
    Tv[44] := Ln[712];
    Tv[46] := Ln[716];
    Tv[48] := Ln[720];
    Tv[09] := Ln[724];
    Tv[50] := Ln[728];
    Tv[54] := Ln[760]; // 20190628
    Tv[58] := Ln[770];
    { PartI }
    Tv[5] := Ln[550];
    // Tv[10] := Ln[600];   //20110508

    Tv[12] := Ln[430];
    Tv[15] := Ln[620];
    Tv[16] := Ln[648];
    Tv[18] := Ln[628];
    Tv[20] := Ln[608];
    Tv[22] := Ln[616];

    Tv[67] := Ln[604];
    Tv[25] := Ln[632];
    Tv[27] := Ln[636];
    Tv[95] := Ln[638];
    Tv[29] := Ln[640];
    Tv[31] := Ln[644];
    Tv[33] := Ln[656];
    Tv[34] := Ln[660];
    Tv[36] := Ln[652];
    Tv[41] := Ln[700];
    { refunds/credits }
    Tv[43] := Ln[840];
    Tv[45] := Ln[780];
    Tv[47] := Ln[784];
    Tv[49] := Ln[788];
    Tv[51] := Ln[808];
    Tv[57] := Ln[792];
    Tv[70] := Ln[797];
    Tv[71] := 0; // Ln[816];
    Tv[53] := Ln[804];
    Tv[11] := Ln[812];
    Tv[13] := Ln[796];
    Tv[55] := Ln[800];
    { v[61] := Ln[150]+Ln[170]+Ln[171]+Ln[172]+Ln[173]+Ln[174]; }
    Tv[59] := Ln[890];
    { FEd Taxes/enclosed }
    Tv[60] := Vl(FetchElm(RetNo, 'T2', 730));
    Tv[80] := Ln[898];
    { Alb }
    Tv[65] := Vl(FetchElm(RetNo, 'AT1', 125));
    Tv[69] := Vl(FetchElm(RetNo, 'AT1', 126));
    Tv[88] := Ret[RetNo].AlbAlloc;
    Frm[FNo].Strings[88] := FormatFloat('###.####', Tv[88]);

    { Carry Forward }
    Tv[87] := Ln[450];
    { Tv[84] := ?? }
    Tv[72] := Vl(FetchElm(RetNo, 'S4', 34)); { Non Cap losses }
    Tv[74] := Vl(FetchElm(RetNo, 'S4', 116)); { Net Cap losses }
    Tv[76] := Vl(FetchElm(RetNo, 'S4', 135)); { farm losses }
    Tv[78] := Vl(FetchElm(RetNo, 'S4', 216)); { restr. farm losses }
    Tv[52] := Vl(FetchElm(RetNo, 'S4', 229)); { lpp losses }
    Tv[73] := Vl(FetchElm(RetNo, 'S31', 258)); { ITC }
    Tv[75] := Vl(FetchElm(RetNo, 'S2', 237)) { char don }
      + Vl(FetchElm(RetNo, 'S2', 271)) + Vl(FetchElm(RetNo, 'S2', 305)) +
      Vl(FetchElm(RetNo, 'S2', 339));

    Tv[77] := Vl(FetchElm(RetNo, 'T2', 190)); { ERDTOH }
    // Vl(FetchElm(RetNo,'T2',536)); //20211206   {ERDTOH}
    Tv[53] := Vl(FetchElm(RetNo, 'T2', 186)); { NERDTOH }
    // 20211206   {NERDTOH}
    Tv[87] := Vl(FetchElm(RetNo, 'T2', 526));
    Tv[97] := Vl(FetchElm(RetNo, 'S31', 1155)); // 20121229
    Tv[98] := Vl(FetchElm(RetNo, 'S31', 539)); // 20121229
    Tv[99] := Vl(FetchElm(RetNo, 'S31', 1023)); // 20121229
    { preparer }
    Frm[FNo].Strings[79] := OptRec.Prp_Name;
    Frm[FNo].Strings[81] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure COMPSUM(RetNo: integer; FName: String; FNo: integer);
var
  ii, k, TSumFNo: integer;
  ThisYearEnd: String;
  yr: String;
begin
  k := 0;
  TSumFNo := GetFormNo('TAXSUM');
  LoadTv(RetNo, FName, FNo); { needed for initialization }
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    ThisYearEnd := GetTaxationYearEnd(RetNo);
    Strings[4] := ThisYearEnd;
    Strings[5] := GetPrevYearEnd(ThisYearEnd, 1);
    Strings[6] := GetPrevYearEnd(ThisYearEnd, 2);
    Strings[7] := GetPrevYearEnd(ThisYearEnd, 3);
    Strings[8] := GetPrevYearEnd(ThisYearEnd, 4);

    yr := LeftStr(Strings[4], 4);
    Strings[9] := LeftStr(GetCorpBusNo(RetNo), 8) + '.' + MidStr(yr, 3, 2);

    yr := LeftStr(Strings[5], 4);
    If Strings[10] = '' then
      Strings[10] := LeftStr(GetCorpBusNo(RetNo), 8) + '.' + MidStr(yr, 3, 2);

    yr := LeftStr(Strings[6], 4);
    If Strings[11] = '' then
      Strings[11] := LeftStr(GetCorpBusNo(RetNo), 8) + '.' + MidStr(yr, 3, 2);

    yr := LeftStr(Strings[7], 4);
    If Strings[12] = '' then
      Strings[12] := LeftStr(GetCorpBusNo(RetNo), 8) + '.' + MidStr(yr, 3, 2);

    yr := LeftStr(Strings[8], 4);
    If Strings[13] = '' then
      Strings[13] := LeftStr(GetCorpBusNo(RetNo), 8) + '.' + MidStr(yr, 3, 2);

    Tv[19 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 24)); // ni
    Tv[24 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 26)) // charit
      + Vl(FetchElmFNo(RetNo, TSumFNo, 28)) +
      Vl(FetchElmFNo(RetNo, TSumFNo, 68));
    Tv[29 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 30)); // div
    Tv[34 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 35)) // losses
      + Vl(FetchElmFNo(RetNo, TSumFNo, 37)) + Vl(FetchElmFNo(RetNo, TSumFNo, 38)
      ) + Vl(FetchElmFNo(RetNo, TSumFNo, 39));
    Tv[39 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 32)); // oth adj part vi.1 tax
    Tv[44 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 40)); // txbl

    Tv[49 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 61)); // actv bus
    Tv[54 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 5)); // 38%
    Tv[59 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 10)); // surtax
    Tv[64 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 67)); // refundable
    Tv[74 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 12)); // sbd
    Tv[79 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 20)); // fed abat
    Tv[84 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 22)); // mp ded
    Tv[89 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 25)) // foreign tax cr
      + Vl(FetchElmFNo(RetNo, TSumFNo, 27));
    Tv[94 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 31)); // polit
    Tv[99 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 36)); // itc
    Tv[104 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 15)) // other invsm corp
      + Vl(FetchElmFNo(RetNo, TSumFNo, 18)) // credit unions
      + Vl(FetchElmFNo(RetNo, TSumFNo, 29)) // logging
      + Vl(FetchElmFNo(RetNo, TSumFNo, 16)) // envoronm trust
      + Vl(FetchElmFNo(RetNo, TSumFNo, 33)) // prt vi
      + Vl(FetchElmFNo(RetNo, TSumFNo, 34)); // part i.3
    Tv[109 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 41)); // part i tax

    Tv[114 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 42)); // part i tax
    Tv[119 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 8)); // part i.3
    Tv[124 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 44)); // part iv
    Tv[129 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 23)) // other tax part ii
      + Vl(FetchElmFNo(RetNo, TSumFNo, 46)) // iv.1
      + Vl(FetchElmFNo(RetNo, TSumFNo, 48)) // vi
      + Vl(FetchElmFNo(RetNo, TSumFNo, 9)) // vi.1
      + Vl(FetchElmFNo(RetNo, TSumFNo, 50)) // xiv
      + Vl(FetchElm(RetNo, 'T2', 759)); // xiii.1

    Tv[134 + k] := Vl(FetchElm(RetNo, 'T2', 709)); // subtotal
    Tv[139 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 54)); // prv tax
    Tv[144 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 56)); // tax on large corp
    Tv[149 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 58)); // tax payable

    Tv[154 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 43)); // instalm
    Tv[159 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 45)); // itc refund
    Tv[164 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 47)); // div refund
    Tv[169 + k] := Vl(FetchElmFNo(RetNo, TSumFNo, 49)) // cap gains ref
      + Vl(FetchElmFNo(RetNo, TSumFNo, 57)) // envir
      + Vl(FetchElmFNo(RetNo, TSumFNo, 13)) // cand film
      + Vl(FetchElmFNo(RetNo, TSumFNo, 70)) // film video
      + Vl(FetchElmFNo(RetNo, TSumFNo, 55)) // tax at source
      + Vl(FetchElmFNo(RetNo, TSumFNo, 53)) // non res invstm
      + Vl(FetchElmFNo(RetNo, TSumFNo, 51)) // prv cap gains refund
      + Vl(FetchElmFNo(RetNo, TSumFNo, 11)) // prv refund cr
      + Vl(FetchElmFNo(RetNo, TSumFNo, 71)); // suncrude
    Tv[174 + k] := Vl(FetchElm(RetNo, 'T2', 730)); // balance
    Tv[179 + k] := Vl(FetchElm(RetNo, 'AT1', 118)); // 20110617
    { Vl(FetchElm(RetNo,'OPG_17',35)) }

    Tv[184 + k] := Vl(FetchElm(RetNo, 'OPG_17', 36)) // on min tax
      + Vl(FetchElm(RetNo, 'OPG_17', 37)) // on cap tax
      + Vl(FetchElm(RetNo, 'OPG_17', 38)); // on prem tax}
    Tv[184 + 0] := 0; // 20110617

    Tv[189 + k] := Vl(FetchElm(RetNo, 'OPG_17', 40)) // on payments
      + Vl(FetchElm(RetNo, 'OPG_17', 41)) // on cap gains refund
      + Vl(FetchElm(RetNo, 'OPG_17', 42)) // environm trust
      + Vl(FetchElm(RetNo, 'OPG_17', 43)) // specified tax credits
      + Vl(FetchElm(RetNo, 'AT1', 124)); // ab instlm and credits
    Tv[189 + 0] := Vl(FetchElm(RetNo, 'AT1', 124));
    // ab instlm and credits  //20110617
    For ii := 0 to 4 do
    begin
      Tv[194 + ii] := Tv[179 + ii] + Tv[184 + ii] - Tv[189 + ii];
      // total ab,on,qc
      Tv[199 + ii] := Tv[174 + ii] + Tv[194 + ii]; // total taxes
    end;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure STATUS(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 27, 3); // 20111125
    Strings[1] := GetCorpName(RetNo);
    Strings[3] := GetTaxationYearEnd(RetNo);
    Strings[4] := Ret[RetNo].PrpStatus;
    Strings[23] := PRPStatusDescr[MyStrToInt(Ret[RetNo].PrpStatus)];
    Strings[24] := GetEFileConfirmationNo(RetNo);

    Strings[15] := OptRec.Prp_Name;
    Strings[16] := OptRec.Prp_Street;
    Strings[17] := OptRec.Prp_City;
    Strings[18] := OptRec.Prp_Prov;
    Strings[19] := OptRec.Prp_Postal;
    Strings[20] := OptRec.Prp_Area + ' ' + OptRec.Prp_Tel;
    Strings[21] := OptRec.Prp_Fax;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure LETR_1(RetNo: integer; FName: String; FNo: integer);
begin
  { PrepLetter(RetNo,FName,FNo,1); }
end;

procedure LETR_2(RetNo: integer; FName: String; FNo: integer);
begin
  { PrepLetter(RetNo,FName,FNo,2); }
end;

procedure PRIVAT(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  Begin
    FillHeader(RetNo, FNo, 39, 40, 41);
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure NPAD(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  Begin
    FillHeader(RetNo, FNo, 1, 4, 2);
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure NPADC(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  Begin
    FillHeader(RetNo, FNo, 2, 3, 1);
    If Tv[30] = 0 then
      Tv[30] := 100;
    If Tv[58] = 0 then
      Tv[58] := 100;
    If Tv[75] = 0 then
      Tv[75] := 100;
    Tv[29] := 0;
    i := 6;
    Repeat
      Tv[29] := Tv[29] + Tv[i];
      Inc(i, 2);
    until i > 28;
    Tv[31] := Tv[29] * Tv[30] / 100;

    Tv[57] := 0;
    i := 34;
    Repeat
      Tv[57] := Tv[57] + Tv[i];
      Inc(i, 2);
    until i > 56;
    Tv[59] := Tv[57] * Tv[58] / 100;

    Tv[74] := 0;
    i := 61;
    Repeat
      Tv[74] := Tv[74] + Tv[i];
      Inc(i, 2);
    until i > 73;
    Tv[76] := Tv[74] * Tv[75] / 100;
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure ADDINFO(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo] do
  Begin
    Frm[FNo].Strings[31] := FetchElm(RetNo, 'T2', 3) { Name }
      + ', ' + FetchElm(RetNo, 'T2', 1);
    Ret[RetNo].Frm[FNo].Strings[1] := OptRec.Prp_Name;
    Ret[RetNo].Frm[FNo].Strings[2] := User.Prep_Name;
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure SUPPL(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo] do
  Begin
    { ? }

    Frm[FNo].Strings[1] := FetchElm(RetNo, 'T2', 3) { Name }
      + ', ' + FetchElm(RetNo, 'T2', 1);
    If Frm[FNo].Strings[18] = '' then
      Frm[FNo].Strings[18] := '00';
    If Frm[FNo].Strings[19] = '' then
      Frm[FNo].Strings[19] := '0';
    If Frm[FNo].Strings[5] = '' then
      If OptRec.Nfl_Efile then
        Frm[FNo].Strings[5] := 'Y'
      else
        Frm[FNo].Strings[5] := 'N';

    If Frm[FNo].Strings[6] = '' then
      Frm[FNo].Strings[6] := '1'

  end;
  SaveTv(RetNo, FName, FNo);

end;

Function FedPolCredit(PolContr: Real): Real;
begin
  Result := 0;
  If (PolContr > 0) and (PolContr <= 100) then
  begin
    Result := 75;
    exit;
  end
  else If (PolContr > 100) and (PolContr <= 550) then
  begin
    Result := 75 + (PolContr - 100) * 0.50;
    exit;
  end
  else If (PolContr > 550) then
  begin
    Result := MinR(500, 300 + (PolContr - 550) * 0.33);
    exit;
  end;
end;

(* Pattern
  begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  {?}
  end; {End with}
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure CalcFed(RetNo: integer);
Var
  i, k: integer;
begin
  if not AppT2.CheckAllowedBN(RetNo, True) then
    exit; // 20191015 Igor
  With Ret[RetNo] do
  begin
    SetAddOnStatus;  //20231031
    // If FetchElm(RetNo,'T183CP',21)>'' then  LockReturn(RetNo);
    InitPrvRates(RetNo); // 20150703
    { txbl inc before losses from prior years }

    // 20160506
    S125(RetNo, 'S125#1', GetFormNo('S125#1'));
    // needed as we may switch from S125to S140
    S100(RetNo, 'S100', GetFormNo('S100'));
    S140(RetNo, 'S140', GetFormNo('S140')); // 20160503

    T2(RetNo, 'T2', GetFormNo('T2'));
    // Page 1(RetNo,'PAGE 1',GetFormNo('PAGE 1'));


    // S10(RetNo,'S10',GetFormNo('S10'));  //20170730

    S8(RetNo, 'S8#1', GetFormNo('S8#1'));
    S8All(RetNo, 'S8ALL', GetFormNo('S8ALL')); // 20090817

    S6(RetNo, 'S6', GetFormNo('S6'));

    S51(RetNo, 'S51', GetFormNo('S51')); // ???

    S51CRN(RetNo, 'S51CRN', GetFormNo('S51CRN'));

    S1(RetNo, 'S1', GetFormNo('S1')); // S1_3(RetNo,'S1_3',GetFormNo('S1_3'));

    // 20100501
    If IsCooperativeCorp(RetNo) then
    begin
      S16(RetNo, 'S16', GetFormNo('S16'));
    end;

    S1(RetNo, 'S1', GetFormNo('S1'));
    S4(RetNo, 'S4', GetFormNo('S4'));
    S4WS(RetNo, 'S4WS', GetFormNo('S4WS'));
    S4(RetNo, 'S4', GetFormNo('S4'));
    S3(RetNo, 'S3', GetFormNo('S3'));
    T2(RetNo, 'T2', GetFormNo('T2'));
    // Page_3(RetNo,'PAGE_3',GetFormNo('PAGE_3'));

    S2(RetNo, 'S2', GetFormNo('S2')); // ???
    S7(RetNo, 'S7', GetFormNo('S7'));
    { dependancies }

    S27(RetNo, 'S27', GetFormNo('S27'));
    T2(RetNo, 'T2', GetFormNo('T2'));
    // Page_3(RetNo,'PAGE_3',GetFormNo('PAGE_3'));
    // If Vl(FetchElm(RetNo,'S7',152)) >0 then S70(RetNo,'S70',GetFormNo('S70'));  //20180526
    S23(RetNo, 'S23', GetFormNo('S23'));

    T2(RetNo, 'T2', GetFormNo('T2'));

    { again }
    S27RATE(RetNo, 'S27RATE', GetFormNo('S27RATE'));

    S27(RetNo, 'S27', GetFormNo('S27')); // ???

    If IsCreditUnion(RetNo) then
      S17(RetNo, 'S17', GetFormNo('S17')); // 20191028
    T2(RetNo, 'T2', GetFormNo('T2')); // 20120329
    CalcForeignCredits(RetNo);
    If IsAssociated(RetNo) then
      S49(RetNo, 'S49', GetFormNo('S49'));

    S52(RetNo, 'S52', GetFormNo('S52')); //20261006 Alex
    S32Assist(RetNo, 'S32ASSIST', GetFormNo('S32ASSIST'));
    T661(RetNo, 'T661', GetFormNo('T661'));
    S31(RetNo, 'S31', GetFormNo('S31'));
    T661(RetNo, 'T661', GetFormNo('T661'));
    // ???
    T2(RetNo, 'T2', GetFormNo('T2'));
    // Page_7(RetNo,'PAGE_7',GetFormNo('PAGE_7'));

    S60(RetNo, 'S60#1', GetFormNo('S60#1'));
    // S547(RetNo,'S547#1',GetFormNo('S547#1'));

    //UHT(RetNo, 'UHT#1', GetFormNo('UHT#1'));  //20231020  //20240726 Igor

    { bfr page 6 }
    If IsAmalgamatedOntario(RetNo) then
    begin
      S500(RetNo, 'S500', GetFormNo('S500'));
      S502(RetNo, 'S502', GetFormNo('S502'));
      S500(RetNo, 'S500', GetFormNo('S500')); // again
      S510(RetNo, 'S510', GetFormNo('S510')); // again  //20120604
      S511(RetNo, 'S511', GetFormNo('S511')); // again
    end;

    S5(RetNo, 'S5', GetFormNo('S5')); { Mult jurisd }

    S33(RetNo, 'S33', GetFormNo('S33')); { large part i3 tax }
    S38(RetNo, 'S38', GetFormNo('S38')); // 20221206
    // S37(RetNo,'S37',GetFormNo('S37'));  //20170525
    //20260508 Alex >>>
    {S12(RetNo, 'S12', GetFormNo('S12'));
    S21(RetNo, 'S21', GetFormNo('S21'));
    S56(RetNo, 'S56', GetFormNo('S56'));
    S75(RetNo, 'S75', GetFormNo('S75'));
    S76(RetNo, 'S76', GetFormNo('S76'));
    S77(RetNo, 'S77', GetFormNo('S77'));
    S78(RetNo, 'S78', GetFormNo('S78'));
    S150(RetNo, 'S150', GetFormNo('S150'));
    S572(RetNo, 'S572', GetFormNo('S572'));}
    //20260508 Alex <<<

    If (Ret[RetNo].Province = 'BC') or (Ret[RetNo].Province = 'MJ') then
    begin
      S427(RetNo, 'S427', GetFormNo('S427'));

      S420(RetNo, 'S420', GetFormNo('S420'));

      S421(RetNo, 'S421', GetFormNo('S421'));
      // S426(RetNo,'S426',GetFormNo('S426'));     //20170525
      S425(RetNo, 'S425', GetFormNo('S425'));
    end
    Else // 20120329
    begin
      ClearForm(RetNo, 'S427');
      ClearForm(RetNo, 'S420');
      ClearForm(RetNo, 'S421');
      // ClearForm(RetNo,'S426');  //20170525
      ClearForm(RetNo, 'S425');
    end;

    If (Ret[RetNo].Province = 'ON') or (Ret[RetNo].Province = 'MJ') then
    begin
      If IsAmalgamatedOntario(RetNo) = True then
      begin
        S5(RetNo, 'S5', GetFormNo('S5'));
        S500(RetNo, 'S500', GetFormNo('S500'));
      end;
    end;

    If (Ret[RetNo].Province = 'MB') or (Ret[RetNo].Province = 'MJ') then
    begin
      S383(RetNo, 'S383', GetFormNo('S383'));
      S387(RetNo, 'S387', GetFormNo('S387'));
      S380(RetNo, 'S380', GetFormNo('S380'));
      S390(RetNo, 'S390', GetFormNo('S390'));
    end
    Else // 20120329
    begin
      ClearForm(RetNo, 'S383');
      ClearForm(RetNo, 'S387');
      ClearForm(RetNo, 'S380');
      ClearForm(RetNo, 'S390');
    end;

    If (Ret[RetNo].Province = 'NB') or (Ret[RetNo].Province = 'MJ') then
    begin
      S366(RetNo, 'S366', GetFormNo('S366'));
      S360(RetNo, 'S360', GetFormNo('S360'));
    end
    Else // 20120329
    begin
      ClearForm(RetNo, 'S366');
      ClearForm(RetNo, 'S360');
    end;

    If (Ret[RetNo].Province = 'NL') or (Ret[RetNo].Province = 'MJ') then
    begin
      // S300(RetNo,'S300',GetFormNo('S300'));  //20181114
      S301(RetNo, 'S301', GetFormNo('S301'));
      S307(RetNo, 'S307', GetFormNo('S307')); // 20130601
      S308(RetNo, 'S308', GetFormNo('S308')); // 20171120
    end
    Else
    begin
      // ClearForm(RetNo,'S300');  //20181114
      ClearForm(RetNo, 'S301');
      ClearForm(RetNo, 'S307'); // 20130601
      ClearForm(RetNo, 'S308'); // 20171120
    end;

    // 290131026
    If (Ret[RetNo].Province = 'NT') or (Ret[RetNo].Province = 'MJ') then
    begin
      S461(RetNo, 'S461', GetFormNo('S461'));
    end
    Else
    Begin
      ClearForm(RetNo, 'S461');
    end;

    If (Ret[RetNo].Province = 'NU') or (Ret[RetNo].Province = 'MJ') then
    begin
      // S480(RetNo,'S480',GetFormNo('S480'));
      S481(RetNo, 'S481', GetFormNo('S481')); // 20130601
    end
    Else
    Begin
      // ClearForm(RetNo,'S480');
      ClearForm(RetNo, 'S481'); // 20130601
    end;

    If (Ret[RetNo].Province = 'PE') or (Ret[RetNo].Province = 'MJ') then
    begin
      S321(RetNo, 'S321', GetFormNo('S321'));
      S322(RetNo, 'S322', GetFormNo('S322')); // 20130601
    end
    Else
    Begin
      ClearForm(RetNo, 'S321');
      ClearForm(RetNo, 'S322'); // 20130601
    end;

    If (Ret[RetNo].Province = 'SK') or (Ret[RetNo].Province = 'MJ') then
    begin
      S402(RetNo, 'S402', GetFormNo('S402'));
      S403(RetNo, 'S403', GetFormNo('S403'));
      S404(RetNo, 'S404', GetFormNo('S404'));
      S411(RetNo, 'S411', GetFormNo('S411'));
    end
    Else // 20120329
    Begin
      ClearForm(RetNo, 'S402');
      ClearForm(RetNo, 'S403');
      ClearForm(RetNo, 'S404');
      ClearForm(RetNo, 'S411');
    end;

    If (Ret[RetNo].Province = 'YT') or (Ret[RetNo].Province = 'MJ') then
    begin
      S440(RetNo, 'S440', GetFormNo('S440'));
      S442(RetNo, 'S442', GetFormNo('S442'));
      S443(RetNo, 'S443', GetFormNo('S443'));
    end
    Else // 20120329
    Begin
      ClearForm(RetNo, 'S440');
      // ClearForm(RetNo,'S441');
      ClearForm(RetNo, 'S443');
    end;

    If (Ret[RetNo].Province = 'SK') or (Ret[RetNo].Province = 'MJ') then
      S400(RetNo, 'S400', GetFormNo('S400')); // sk rebate

    If (Ret[RetNo].Province = 'NS') or (Ret[RetNo].Province = 'NO') or
      (Ret[RetNo].Province = 'MJ') then
    begin
      S353(RetNo, 'S353', GetFormNo('S353')); // 20220917
      S352(RetNo, 'S352', GetFormNo('S352')); // 20220917
      S346(RetNo, 'S346', GetFormNo('S346'));
      S340(RetNo, 'S340', GetFormNo('S340'));
      S341(RetNo, 'S341', GetFormNo('S341'));
      S400(RetNo, 'S400', GetFormNo('S400')); // sk rebate
    end
    Else // 20120329
    Begin
      ClearForm(RetNo, 'S346');
      ClearForm(RetNo, 'S340');
      ClearForm(RetNo, 'S341');
      ClearForm(RetNo, 'S400');
    end;

    If (Ret[RetNo].Province = 'NB') or (Ret[RetNo].Province = 'MJ') then
    begin
      S360(RetNo, 'S360', GetFormNo('S360'));
      S366(RetNo, 'S366', GetFormNo('S366'));
    end
    Else // 20120329
    Begin
      ClearForm(RetNo, 'S360');
      ClearForm(RetNo, 'S62');
      ClearForm(RetNo, 'S366');
    end;

    If IsNonResidentCorp(RetNo) = True then
    begin
      S20(RetNo, 'S20', GetFormNo('S20')); // ???
    end;

    S4(RetNo, 'S4', GetFormNo('S4'));
    S7(RetNo, 'S7', GetFormNo('S7')); // 20160506
    T2(RetNo, 'T2', GetFormNo('T2'));
    // Page_3(RetNo,'PAGE_3',GetFormNo('PAGE_3'));  //20100108
    CalcForeignCredits(RetNo); // 20120329
    Calc(RetNo, 'S63'); // 20220510  Fuel
    //Calc(RetNo, 'S65'); // 20220510  Air  //20260526

    T2(RetNo, 'T2', GetFormNo('T2'));

    CalcForeignCredits(RetNo); // 20120329  depends on 5

    T661(RetNo, 'T661', GetFormNo('T661'));
    S31(RetNo, 'S31', GetFormNo('S31'));
    S5(RetNo, 'S5', GetFormNo('S5'));
    Ret[RetNo].Ln[780] := GetLn780(RetNo); // 20171202
    // ------------------------

    // 20090227
    S27RATE(RetNo, 'S27RATE', GetFormNo('S27RATE'));

    S27(RetNo, 'S27', GetFormNo('S27')); // ???
    S5(RetNo, 'S5', GetFormNo('S5'));
    T2(RetNo, 'T2', GetFormNo('T2'));
    { finally Page 2 questionnaire }
    // SPECIAL
    T2(RetNo, 'T2', GetFormNo('T2')); { questionnare }
    // INSTLM(RetNo,'INSTLM',GetFormNo('INSTLM'));  //20171129
    if CountMultipleInstances(RetNo, 'S125') > 1 then // 20160506
      S140(RetNo, 'S140', GetFormNo('S140'));
    CDA(RetNo, 'CDA', GetFormNo('CDA'));
    //S89(RetNo, 'S89', GetFormNo('S89')); // 20190823 Igor  //20240726 Igor

    //T2054(RetNo, 'T2054', GetFormNo('T2054')); //20240728 Igor
   {
    If Vl(FetchElm(RetNo, 'T2054', 9)) > 0 then
    begin
      T2054(RetNo, 'T2054', GetFormNo('T2054'));
      // T2054_2(RetNo,'T2054_2',GetFormNo('T2054_2'));
    end;
    }
    Calc(RetNo, 'T1134'); // 20180612

    Calc(RetNo, 'S141'); // 20121002

    Calc(RetNo, 'S53');
    Calc(RetNo, 'S54');
    Calc(RetNo, 'S55');
    //20230609
    Calc(RetNo, 'S67');
    Calc(RetNo, 'S68');

    Calc(RetNo, 'GROUPINFO'); // 20170715

    T183CP(RetNo, 'T183CP', GetFormNo('T183CP'));
    // If IsEFiled(RetNo) then T183CP(RetNo,'T183CP',GetFormNo('T183CP'));
    T1135(RetNo, 'T1135', GetFormNo('T1135')); // 20180113
    RC59(RetNo, 'RC59', GetFormNo('RC59')); // 20180803
    RC59X(RetNo, 'RC59X', GetFormNo('RC59X')); // 20180803
    CBCR(RetNo, 'CBCR', GetFormNo('CBCR')); // 20180803
    // 20180627
    if Ret[RetNo].FrmHasData[GetFormNo('T106')] then // 20220718
    Begin
      T106(RetNo, 'T106', GetFormNo('T106'));
      for i := 1 to 20 do
      Begin
        k := GetFormNo('T106SL' + '#' + AllTrim(IntToStr(i)));
        if Ret[RetNo].FrmHasData[k] then
          Calc(RetNo, 'T106SL#' + AllTrim(IntToStr(i)), k);
      End;
    End;

    Calc(RetNo, 'FASSET'); // 20160812
    Calc(RetNo, 'STATUS'); // 20100528
    Calc(RetNo, 'TAXSUM'); // 20160503

    CONSENT(RetNo, 'CONSENT#1', GetFormNo('CONSENT'));

    INSTLM(RetNo, 'INSTLM', GetFormNo('INSTLM')); // 20171129
    T7DRQR(RetNo, 'T7DRQR', GetFormNo('T7DRQR')); // 20220614

    Ret[RetNo].FedCalcStatus := True;
    Ret[RetNo].OntCalcStatus := false;
    Ret[RetNo].AlbCalcStatus := false;
    UpdateAllDataIndicators(RetNo);
    // MyChild.UpdateChildTaxPanel(GetCurrentRetNo);
    // UpdateChildTaxPanel(GetCurrentRetNo); //20150703   CANNOT USE IT HERE ??

  end;

end;

Procedure CalcForeignCredits(RetNo: integer);
Var
  i, k, FNo: integer;
  FInst: String; // [4]; //20150701//FInst:String[4];
begin
  // ???
  // S21_3(RetNo,'S21_3',GetFormNo('S21_3'));
  // S21_2(RetNo,'S21_2',GetFormNo('S21_2'));
  S21(RetNo, 'S21', GetFormNo('S21'));

  InitFormData(RetNo, GetFormNo('OFTC#1'));
  // provincial
  S21P(RetNo, 'S21P#1', GetFormNo('S21P#1')); // first inst
  FNo := GetFormNo('S21');
  i := 13; // remaining countries
  k := 2; // second and remaining instances
  repeat
    If FetchElmFNo(RetNo, FNo, i) > '' then
    begin
      FInst := '#' + AllTrim(IntToStr(k));
      AddPageInstance(RetNo, 'S21P', FInst); // 20150703
      S21P(RetNo, 'S21P' + FInst, GetFormNo('S21P' + FInst)); // first inst
      Inc(k);
    end;
    Inc(i, 9);
  until i > 40;
end;

Procedure CALCONT(RetNo: integer);
Var
  i: integer;
begin
  if not AppT2.CheckAllowedBN(RetNo, True) then
    exit; // 20191015 Igor
  If GetTaxationYearEnd(RetNo) = '' then
    exit;

  S524(RetNo, 'S524', GetFormNo('S524')); // 20100530
  S558(RetNo, 'S558#1', GetFormNo('S558#1')); // 20160515
  // 20100530
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    If FRec.FormType = 'ON' then
      Calc(RetNo, FRec.FormName + FRec.FormInst); // 20160510
    // Calc(RetNo,Frec.FormName);
  end;
  S500(RetNo, 'S500', GetFormNo('S500'));
  // 20100530
  Calc(RetNo, 'S5');
  Calc(RetNo, 'T2'); // Calc(RetNo,'PAGE_8');

end;

Procedure CALCALB(RetNo: integer);
begin
  if not AppT2.CheckAllowedBN(RetNo, True) then
    exit; // 20191015 Igor

  If Ret[RetNo].AlbAlloc > 0 then
  begin
    ACAPDRE(RetNo, 'ACAPDRE', GetFormNo('ACAPDRE'));

    ACAPD(RetNo, 'ACAPD', GetFormNo('ACAPD'));
    AS15(RetNo, 'AS15', GetFormNo('AS15'));
    AS51(RetNo, 'AS51', GetFormNo('AS51'));
    POLIT(RetNo, 'POLIT', GetFormNo('POLIT'));
    AT1(RetNo, 'AT1', GetFormNo('AT1'));
    AS1(RetNo, 'AS1', GetFormNo('AS1'));

    // ???
    AS1(RetNo, 'AS1', GetFormNo('AS1'));
    AS2(RetNo, 'AS2', GetFormNo('AS2'));
    AT1(RetNo, 'AT1', GetFormNo('AT1')); // was pg2
    AS5(RetNo, 'AS5', GetFormNo('AS5')); // ???

    AS6(RetNo, 'AS6', GetFormNo('AS6'));
    AS7(RetNo, 'AS7', GetFormNo('AS7'));
    AS8(RetNo, 'AS8', GetFormNo('AS8')); // ??? order?

    AS9L(RetNo, 'AS9L', GetFormNo('AS9L'));

    AS29(RetNo, 'AS29', GetFormNo('AS29')); // 20210713

    AS10(RetNo, 'AS10', GetFormNo('AS10'));

    AS11(RetNo, 'AS11', GetFormNo('AS11'));
    AS13(RetNo, 'AS13#1', GetFormNo('AS13#1'));

    AS14(RetNo, 'AS14', GetFormNo('AS14'));
    AS14WS(RetNo, 'AS14WS', GetFormNo('AS14WS'));

    AS15(RetNo, 'AS15', GetFormNo('AS15'));
    AS16(RetNo, 'AS16', GetFormNo('AS16'));
    AS17(RetNo, 'AS17', GetFormNo('AS17'));

    AS18(RetNo, 'AS18', GetFormNo('AS18'));
    AS20WS(RetNo, 'AS20WS', GetFormNo('AS20WS'));
    AS20(RetNo, 'AS20', GetFormNo('AS20'));
    AS21(RetNo, 'AS21', GetFormNo('AS21'));
    AS12SUP(RetNo, 'AS12SUP', GetFormNo('AS12SUP'));

    AS12(RetNo, 'AS12', GetFormNo('AS12'));
    AS21(RetNo, 'AS21', GetFormNo('AS21'));
    AS29(RetNo, 'AS29', GetFormNo('AS29')); // 20210530
    AS29L(RetNo, 'AS29L', GetFormNo('AS29L')); // 20210603
    AT1(RetNo, 'AT1', GetFormNo('AT1')); // was Pg2
    AS11(RetNo, 'AS11', GetFormNo('AS11'));
    // ???
    AS1(RetNo, 'AS1', GetFormNo('AS1'));
    AS3(RetNo, 'AS3', GetFormNo('AS3')); // 20170624
    AS4(RetNo, 'AS4', GetFormNo('AS4'));
    AT1(RetNo, 'AT1', GetFormNo('AT1')); // was pg2
    INSTLM(RetNo, 'INSTLM', GetFormNo('INSTLM'));
    Ret[RetNo].AlbCalcStatus := True;
  end;
end;

Procedure AUTOEXP(RetNo: integer; FName: String; FNo: integer);
begin
  { CalcAutoExp(RetNo,FName,FNo,'O'); }  { other }
end;

procedure CalcCommonS2(RetNo: integer; FName: string; FNo: integer);
Var
  i, k: integer;
  NI, DonLim: Real;
  DonRate, GiftRate: string; // [3]; //20150701
  // DonRate,GiftRate:string[3];
begin
  DonRate := '75';
  GiftRate := '25';
  If RightStr(GetBegYearEnd(RetNo), 4) < '1997' then
  begin
    DonRate := '50';
    GiftRate := '50';
  end;
  If RightStr(GetBegYearEnd(RetNo), 4) < '1996' then
  begin
    DonRate := '20';
    GiftRate := '20';
  end;
  If FName = 'OS2' then
    NI := MaxR(0, Vl(FetchElm(RetNo, 'OPG_15', 55)))
  else
    NI := MaxR(0, Vl(FetchElm(RetNo, 'S1', 68)));

  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[1] = '' then
      Strings[1] := RightStr(GetTaxationYearEnd(RetNo), 4);
    Strings[100] := DonRate;
    Strings[99] := GiftRate;
    Tv[48] := 0;
    i := 4;
    Repeat
      Tv[48] := Tv[48] + Tv[i];
      Inc(i, 3);
    until i > 46;
    Tv[48] := Tv[48] + Tv[47];
    { Analysis }
    { zero out current year history }
    i := 49;
    k := 5;
    Repeat
      Strings[i] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), k);
      Inc(i, 6);
      Dec(k);
    until i > 73;
    Strings[79] := GetTaxationYearEnd(RetNo);

    For i := 80 to 89 do
      Tv[i] := 0;
    Tv[81] := Tv[48];

    i := 51;
    Repeat
      Tv[i] := 0;
      Inc(i, 6);
    until i > 75;
    { autoapply }
    DonLim := NI * Vl(DonRate) / 100 + Tv[94] * Vl(GiftRate) / 100;
    i := 50;
    Repeat
      Tv[i + 2] := MinR(DonLim, Tv[i] + Tv[i + 1]);
      If i = 50 then
        Tv[i + 3] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2]);
      DonLim := MaxR(0, DonLim - Tv[i + 2] - Tv[i + 3]);
      Tv[i + 4] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2] - Tv[i + 3]);
      Tv[85] := Tv[85] + Tv[i];
      Tv[86] := Tv[86] + Tv[i + 1];
      Tv[87] := Tv[87] + Tv[i + 2];
      Tv[88] := Tv[88] + Tv[i + 3];
      Tv[89] := Tv[89] + Tv[i + 4];
      Inc(i, 6);
    until i > 80;

    Tv[90] := Tv[48];
    Tv[91] := Tv[85];
    Tv[92] := Tv[90] + Tv[91];
    Tv[93] := (Vl(DonRate) / 100) * NI;
    If Tv[93] < 0 then
      Tv[93] := 0;
    Tv[95] := Tv[94] * (Vl(GiftRate) / 100);
    Tv[96] := Tv[93] + Tv[95];
    Tv[97] := MinR(Tv[92], Tv[96]);
    Tv[98] := Tv[89];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure CalCCommonS13(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    For i := 74 to 77 do
      Tv[i] := 0;
    { Horizontal }
    i := 3;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] + Tv[i + 2];
      Inc(i, 6);
    until i > 69;
    { Vertical }
    For j := 0 to 3 do
    begin
      i := 3;
      Repeat
        Tv[74 + j] := Tv[74 + j] + Tv[i + j];
        Inc(i, 6);
      until i > 69;
    end;
    { other reserves }
    for i := 160 to 164 do
      Tv[i] := 0;
    For i := 115 to 118 do
      Tv[i] := 0;
    i := 79;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] + Tv[i + 2];
      If Strings[i + 4] = '' then
      begin
        Tv[160] := Tv[160] + Tv[i];
        Tv[161] := Tv[161] + Tv[i + 3];
      end;
      Inc(i, 6);
    until i > 109;

    { Vertical }
    For j := 0 to 3 do
    begin
      i := 79;
      Repeat
        Tv[115 + j] := Tv[115 + j] + Tv[i + j];
        Inc(i, 6);
      until i > 109;
    end;

    For i := 156 to 159 do
      Tv[i] := 0;
    i := 121;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] + Tv[i + 2];
      If Strings[i + 4] > '' then
      begin
        Tv[163] := Tv[163] + Tv[i + 3];
        Tv[164] := Tv[164] + Tv[i];
        Tv[162] := Tv[163] - Tv[164];
      end;
      Inc(i, 6);
    until i > 151;

    { Vertical }
    For j := 0 to 3 do
    begin
      i := 121;
      Repeat
        Tv[156 + j] := Tv[156 + j] + Tv[i + j];
        Inc(i, 6);
      until i > 151;
    end;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure Recalc(RetNo: integer; FName: String);
Var
  FrmType: String;
begin
  if not AppT2.CheckAllowedBN(RetNo, True) then
    exit; // 20191015 Igor
  FrmType := GetFormType(FName);
  If (FrmType <> 'ON') and (FrmType <> 'AL') and
    (Ret[RetNo].FedCalcStatus = false) then
  begin
    CalcFed(RetNo);
    Ret[RetNo].FedCalcStatus := True;
  end
  else If (FrmType = 'ON') and (Ret[RetNo].OntCalcStatus = false) then
  begin
    CALCONT(RetNo);
    Ret[RetNo].OntCalcStatus := True;
  end
  else If (FrmType = 'AL') and (Ret[RetNo].AlbCalcStatus = false) then
  begin
    CalcFed(RetNo);
    CALCALB(RetNo);
    Ret[RetNo].FedCalcStatus := True;
    Ret[RetNo].AlbCalcStatus := True;
  end;
  TAXSUM(RetNo, 'TAXSUM', GetFormNo('TAXSUM'));
  COMPSUM(RetNo, 'COMPSUM', GetFormNo('COMPSUM'));
end;

// 20191024
procedure S12(RetNo: integer; FName: string; FNo: integer);
Var
  i, k: integer;
  lVal_A: Currency; //20260501 Alex
  lVal_B: Currency; //20260501 Alex
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    Tv[22] := Tv[4] + Tv[6] - Tv[9];
    Tv[23] := Tv[5] + Tv[7] + Tv[8] - Tv[10];
    If UpperCase(Strings[25]) <> 'Y' then
    begin
      Tv[12] := MaxR(0, Tv[22]);
      Tv[11] := MaxR(0, Tv[23]);
    end;
    Tv[13] := MaxR(0, Tv[22] - Tv[12]);
    Tv[14] := MaxR(0, Tv[23] - Tv[11]);

    Tv[24]:= Tv[16] + Tv[17]; //20260501 Alex
    Tv[27]:= Tv[24]; //20260501 Alex
    Tv[28]:= Tv[15] + Tv[27]; //20260501 Alex
    Tv[19]:= Tv[28] - Tv[18]; //20260501 Alex

    if UpperCase(Strings[26]) <> 'Y' then
      Tv[20] := MaxR(0, Tv[19]);
    { Mx := 0.25 * (MaxR(0,GetNetInc(RetNo) - Tv[12]-Tv[11])); }
    { If Tv[20] > Mx then Tv[20] :=Mx; }
    Tv[21] := MaxR(0, Tv[19] - Tv[20]);

    // 20150531
    Tv[32] := Tv[12];
    Tv[31] := Tv[11];
    Tv[30] := Tv[20];
    Tv[29] := RoundCorrect(Tv[32] + Tv[31] + Tv[30]); // 20150531

  end; // End with

  // S12 pg 2--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[120] := Tv[101] + Tv[103] + Tv[104] + Tv[106] + Tv[109] + Tv[111] +
      Tv[126] - Tv[113] - Tv[115] - Tv[117] - Tv[118] - Tv[127];
    Tv[125] := Tv[102] + Tv[105] + Tv[107] + Tv[108] - Tv[116] - Tv[119];
    If UpperCase(Strings[112]) <> 'Y' then // 20131006
    begin
      Tv[121] := MaxR(0, Tv[120]);
      Tv[122] := MaxR(0, Tv[125]);
    end;
    Tv[123] := MaxR(0, Tv[120] - Tv[121]);
    Tv[124] := MaxR(0, Tv[125] - Tv[122]);

    // 20150531
    Tv[33] := Tv[121];
    Tv[34] := Tv[122];
    Tv[35] := Tv[33] + Tv[34];
  end; // End with

  // S12 pg 3--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[211] := Vl(FetchElm(RetNo, 'S12', 105));

    If Vl(FetchElm(RetNo, 'S12', 317)) < 0 then
      Tv[214] := ABS(Vl(FetchElm(RetNo, 'S12', 317)))
    else
      Tv[214] := 0;
    // 20191116
    // Tv[221] := Tv[201]+Tv[203]+Tv[204]+Tv[206]+Tv[228]-Tv[208]-Tv[210]-Tv[212]-Tv[214]-Tv[216]-Tv[220]-Tv[218]-Tv[229];
    // Tv[222] := Tv[202]+Tv[205]+Tv[207]-Tv[211]-Tv[217]-Tv[219]-Tv[209];

    // 20191024 moved fro below
    If (Tv[222] < 0) and (IsS12Designation(RetNo) = false) then
      Tv[216] := ABS(Tv[222])
    else
      Tv[216] := 0;

    // jz 2019 <--
    Tv[231] := Tv[203] + Tv[228] + Tv[206];
    // Tv[232] := MaXR(0,Tv[231]-Tv[230]);
    Tv[233] := Tv[208] + Tv[210] + Tv[212] + Tv[214] + Tv[216] + Tv[218]
      + Tv[229];
    Tv[234] := MaxR(0, Tv[233] - Tv[232]);
    Tv[235] := MaxR(0, Tv[230] - Tv[234]);
    // --> jz 2019

    {
      //20191024 moved above
      If (Tv[222]<0) and (IsS12Designation(RetNo) =false) then
      Tv[216]:=Abs(Tv[222])
      else
      Tv[216]:=0;
    }
    //TV[49]:  usder
    Tv[50]:= Tv[231] - Tv[49]; //20260501 Alex
    Tv[51]:= MaxR(0, Tv[233] - Tv[50]); //20260501 Alex
    Tv[52]:= Tv[49] - Tv[51]; //20260501 Alex
    // 20191116
    //Tv[223]:  User
    Tv[225] := MaxR(0, Tv[221] - Tv[223]);
    Tv[226] := MaxR(0, Tv[222] - Tv[224]);

    { //20191116
      If UpperCase(Strings[227])<> 'Y' then
      begin
      Tv[223]:= RoundCorrect(MaxR(0,Tv[221] * 0.30)); //20180610
      Tv[224]:= RoundCorrect(MaxR(0,Tv[222] * 0.30));              //20180610
      end;
      Tv[225] := MaxR(0,Tv[221] - Tv[223]);
      Tv[226] := MaxR(0,Tv[222] - Tv[224]);
    }

    // 20150531
    Tv[36] := Tv[223];
    Tv[37] := Tv[224];
    Tv[38] := Tv[36] + Tv[37];

  end; // End with

  // S12 pg 4--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[317] := Tv[301] + Tv[303] + Tv[304] + Tv[307] - Tv[309] - Tv[311] -
      Tv[313] - Tv[315];
    Tv[318] := Tv[302] + Tv[305] + Tv[306] - Tv[310] - Tv[314] - Tv[316];

    // jz 2019 <--
    Tv[325] := Tv[303] + Tv[307];
    Tv[326] := MaxR(0, Tv[325] - Tv[324]);
    Tv[327] := Tv[309] + Tv[311] + Tv[315];
    Tv[328] := MaxR(0, Tv[327] - Tv[326]);
    Tv[329] := MaxR(0, Tv[324] - Tv[328]);
    // --> jz 2019

    If (Tv[318] < 0) and (IsS12Designation(RetNo) = false) then
      Tv[315] := ABS(Tv[318])
    else
      Tv[315] := 0;

    Tv[54]:= Tv[325] - Tv[53]; //20260501 Alex
    Tv[56]:= MaxR(0, Tv[327] - Tv[54]); //20260501 Alex
    Tv[55]:= Tv[53] - Tv[56]; //20260501 Alex
    If UpperCase(Strings[323]) <> 'Y' then
    begin
      Tv[319] := RoundCorrect(MaxR(0, Tv[317] * 0.10)); // 20180610
      Tv[320] := RoundCorrect(MaxR(0, Tv[318] * 0.10)); // 20180610
    end;
    Tv[321] := MaxR(0, Tv[317] - Tv[319]);
    Tv[322] := MaxR(0, Tv[318] - Tv[320]);

    // 20150531
    Tv[39] := Tv[319];
    Tv[40] := Tv[320];
    Tv[41] := Tv[39] + Tv[40];
  end; // End with

  // S12 pg 5--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[409] := Tv[401] + Tv[404] - Tv[407];
    Tv[410] := Tv[402] + Tv[405] + Tv[406] - Tv[408];

    If UpperCase(Strings[418]) <> 'Y' then
    begin
      Tv[411] := RoundCorrect(MaxR(0, Tv[409] * 0.10)); // 20180610
      Tv[412] := RoundCorrect(MaxR(0, Tv[410] * 0.10)); // 20180610
    end;
    Tv[413] := MaxR(0, Tv[409] - Tv[411]);
    Tv[414] := MaxR(0, Tv[410] - Tv[412]);
    // 20150531
    Tv[42] := Tv[411];
    Tv[43] := Tv[412];
    Tv[44] := Tv[596];
    Tv[45] := Tv[597];
    Tv[46] := Tv[696];
    Tv[47] := Tv[697];
    Tv[48] := 0;
    For i := 42 to 47 do
      Tv[48] := Tv[48] + Tv[i];
  end; // End with
  // S12 pg 6--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260501 Alex >>>
    i:= 505;
    k:= 501;
    Tv[596]:= 0;
    repeat
      Tv[i]:= Tv[k] + Tv[k + 1] + Tv[k + 2] - Tv[k + 3]; //Column 6

      //Column 7
      {If an amount in column 6 is negative, include it as income in the "Other additions" area on page 3 of Schedule 1, and enter "0" in the corresponding row entries for lines 620 and 625.
       The maximum deduction for regular expenses is the lesser of:
       – the total of all amounts available in column 6, and
       – the greater of the total of all amounts in column 9 and 10% of the total of all amounts available in column 6 (for a fiscal period of less than 51 weeks, 10% is prorated based on the number of days in the tax year divided by 365).}
      if (Tv[i] < 0) then
      begin
        Tv[i + 1]:= 0; //Column 7 (620)
      end else
        Tv[i + 1]:= MinR(Tv[i], Tv[i + 3] + (Tv[i] * 0.1));
      //Column 8
      Tv[i + 2]:= Tv[i] - Tv[i + 1];
      if (Tv[i] < 0) then Tv[i + 2]:= 0; //Column 8 (625)

      Tv[596]:= Tv[596] + Tv[i + 1];
      Inc(i, 9);
      Inc(k, 9);
    until i > 586;
    //20260501 Alex <<<
    //Old logic before 2026 changes //20260501 Alex
    {i := 501;
    k := 500;
    Tv[596] := 0;
    Tv[597] := 0;
    Repeat
      Tv[31 + k] := Tv[6 + k] + Tv[16 + k] + Tv[21 + k] - Tv[26 + k];
      If Tv[36 + k] > Tv[31 + k] then
        Tv[36 + k] := Tv[31 + k];
      If Tv[31 + k] < 0 then
      begin
        Tv[36 + k] := 0;
        Tv[41 + k] := 0;
      end
      else
      begin
        Tv[41 + k] := MaxR(0, Tv[31 + k] - Tv[36 + k]);
      end;

      Tv[76 + k] := Tv[56 + k] + Tv[61 + k] + Tv[66 + k] - Tv[71 + k];
      If Tv[81 + k] > Tv[76 + k] then
        Tv[81 + k] := Tv[76 + k];
      If Tv[76 + k] < 0 then
      begin
        Tv[81 + k] := 0;
        Tv[86 + k] := 0;
      end
      else
      begin
        Tv[86 + k] := MaxR(0, Tv[76 + k] - Tv[81 + k]);
      end;

      Tv[596] := Tv[596] + Tv[36 + k];
      Tv[597] := Tv[597] + Tv[81 + k];
      Inc(i);
      Inc(k);
    until i > 505;}
  end; // End with}

  // S12 pg 7--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260501 Alex >>>
    i:= 606;
    k:= 602;
    Tv[692]:= 0;
    repeat
      Tv[i]:= Tv[k] + Tv[k + 1] + Tv[k + 2] - Tv[k + 3]; //Column 7

      //Column 7
      {If an amount in column 6 is negative, include it as income in the "Other additions" area on page 3 of Schedule 1, and enter "0" in the corresponding row entries for lines 670 and 675.
       The maximum deduction for successor expenses is the lesser of:
       – the total of all amounts available in column 6, and
       – the total of all amounts in column 9 attributable to successored properties [foreign resource income is calculated according to paragraph 66.7(2)(b)].}
      if (Tv[i] < 0) then
      begin
        Tv[i + 1]:= 0; //Column 7 (670)
      end else
        Tv[i + 1]:= MinR(Tv[i], Tv[i + 3]);
      //Column 8
      Tv[i + 2]:= Tv[i] - Tv[i + 1];
      if (Tv[i] < 0) then Tv[i + 2]:= 0; //Column 8 (675)

      Tv[692]:= Tv[692] + Tv[i + 1];
      Inc(i, 9);
      Inc(k, 9);
    until i > 688;
    //20260501 Alex <<<
    //Old logic before 2026 changes //20260501 Alex
    {i := 601;
    k := 600;
    Tv[696] := 0;
    Tv[697] := 0;
    Repeat
      Tv[31 + k] := Tv[6 + k] + Tv[11 + k] + Tv[16 + k] + Tv[21 + k] -
        Tv[26 + k];
      // TotAvlbl:=TotAvlbl+Tv[31+k];
      // Tv[36+k]:= MinR(TV[31+k],  ??
      If Tv[31 + k] < 0 then
      begin
        Tv[36 + k] := 0;
        Tv[41 + k] := 0;
      end
      else
      begin
        Tv[41 + k] := MaxR(0, Tv[31 + k] - Tv[36 + k]);
      end;

      Tv[76 + k] := Tv[56 + k] + Tv[61 + k] + Tv[66 + k] - Tv[71 + k];
      If Tv[31 + k] < 0 then
      begin
        Tv[36 + k] := 0;
        Tv[41 + k] := 0;
      end
      else
      begin
        Tv[41 + k] := MaxR(0, Tv[31 + k] - Tv[36 + k]);
      end;

      Tv[696] := Tv[696] + Tv[36 + k];
      Tv[697] := Tv[697] + Tv[81 + k];
      Inc(i);
      Inc(k);
    until i > 605;}
  end; // End with
  //20260501 Alex >>>
  // S12 pg 8--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260501 Alex >>>
    i:= 707;
    k:= 702;
    Tv[696]:= 0;
    repeat
      Tv[i]:= Tv[k] + Tv[k + 1] + Tv[k + 2] - Tv[k + 3]; //Column 7

      //Column 7
      {If an amount in column 7 is negative, include it as income in the "Other additions" area on page 3 of Schedule 1, and enter "0" in the corresponding row entries for lines 720 and 725.
       The maximum deduction for regular expenses is the total of amount A and amount B where:
        A = the greater of:
        – 10% of the amount available in column 7, and
        – the least of the following amounts:
        a) 30% of the amount available in column 7
        b) the foreign resource income in column 10 for the particular country calculated according to subparagraph 66.21(4)(a)(ii), or
        c) the total of all amounts in column 10.
        B = the lesser of:
        – the amount in column 7 minus amount A above, and
        – the global foreign resource limit for the year designated for that country.}
      if (Tv[i] < 0) then
      begin
        Tv[i + 1]:= 0; //Column 8 (720)
      end else
      begin
        lVal_A:= MinR(Tv[i] * 0.3, MinR(Tv[i + 3], (Tv[710] + Tv[720] + Tv[730] + Tv[740] + Tv[750] + Tv[760] + Tv[770] + Tv[780] + Tv[790] + Tv[800]) ));
        lVal_A:= MaxR(Tv[i] * 0.1, lVal_A);
        lVal_B:= Tv[i] - lVal_A;
        //lVal_B:= MinR(lVal_B, {the global foreign resource limit for the year designated for that country});

        Tv[i + 1]:= lVal_A + lVal_B;
      end;
      //Column 9
      Tv[i + 2]:= Tv[i] - Tv[i + 1];
      if (Tv[i] < 0) then Tv[i + 2]:= 0; //Column 9 (725)

      Tv[696]:= Tv[696] + Tv[i + 1];
      Inc(i, 10);
      Inc(k, 10);
    until i > 797;
  end;

  // S12 pg 9--------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    //20260501 Alex >>>
    i:= 806;
    k:= 802;
    Tv[697]:= 0;
    repeat
      Tv[i]:= Tv[k] + Tv[k + 1] + Tv[k + 2] - Tv[k + 3]; //Column 6

      //Column 7
      {If an amount in column 6 is negative, include it as income in the "Other additions" area on page 3 of Schedule 1, and enter "0" in the corresponding row entries for lines 770 and 775.
       The maximum deduction for successor expenses is the lesser of:
        – 30% of the amount available in column 6, and
        – the foreign resource income in column 9 attributable to successored properties [foreign resource income is calculated according to paragraph 66.7(2.3)(b)].}
      if (Tv[i] < 0) then
      begin
        Tv[i + 1]:= 0; //Column 7 (770)
      end else
        Tv[i + 1]:= MinR((Tv[i] * 0.3), Tv[i + 3]);
      //Column 8
      Tv[i + 2]:= Tv[i] - Tv[i + 1];
      if (Tv[i] < 0) then Tv[i + 2]:= 0; //Column 8 (775)

      Tv[697]:= Tv[697] + Tv[i + 1];
      Inc(i, 9);
      Inc(k, 9);
    until i > 887;
  end;
  //20260501 Alex <<<
  SaveTv(RetNo, FName, FNo);
end;

(* //20191024
  procedure S12(RetNo: integer;FName: string;FNo: integer);
  Var i,k:integer;
  begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  FillHeader(RetNo,FNo,1,2,3);

  Tv[22] := Tv[4]+Tv[6]-Tv[9];
  Tv[23] := Tv[5]+Tv[7]+Tv[8]-Tv[10];
  If UpperCase(Strings[25])<> 'Y' then
  begin
  Tv[12] := MaxR(0,Tv[22]);
  Tv[11] := MaxR(0,Tv[23]);
  end;
  Tv[13] := MaxR(0,Tv[22]-Tv[12]);
  Tv[14] := MaxR(0,Tv[23] -Tv[11]);

  Tv[19] := Tv[15]+Tv[16]+Tv[17]-Tv[18];
  If UpperCase(Strings[26])<> 'Y' then
  Tv[20] := MaxR(0,Tv[19]);
  {Mx := 0.25 * (MaxR(0,GetNetInc(RetNo) - Tv[12]-Tv[11]));}
  {If Tv[20] > Mx then Tv[20] :=Mx;}
  Tv[21] := MaxR(0,Tv[19] - Tv[20]);

  //20150531
  Tv[32]:=Tv[12];
  Tv[31]:=Tv[11];
  Tv[30]:=Tv[20];
  Tv[29]:=RoundCorrect(Tv[32]+Tv[31]+Tv[30]); //20150531

  end; {End with}

  //S12 pg 2--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
  Tv[120] := Tv[101]+Tv[103]+Tv[104]+Tv[106]+Tv[109]+Tv[111]+Tv[126]
  -Tv[113]-Tv[115]-Tv[117]-Tv[118]-Tv[127];
  Tv[125] := Tv[102]+Tv[105]+Tv[107]+Tv[108]-Tv[116]-Tv[119];
  If UpperCase(Strings[112])<> 'Y' then  //20131006
  begin
  Tv[121]:=MaxR(0,Tv[120]);
  Tv[122]:=MaxR(0,Tv[125]);
  end;
  Tv[123] := MaxR(0,Tv[120] - Tv[121]);
  Tv[124] := MaxR(0,Tv[125] - Tv[122]);

  //20150531
  Tv[33]:=Tv[121];
  Tv[34]:=Tv[122];
  Tv[35]:=Tv[33]+Tv[34];
  end; {End with}


  //S12 pg 3--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
  Tv[211]:=Vl(FetchElm(RetNo,'S12',105));

  If Vl(FetchElm(RetNo,'S12', 317))<0 then
  Tv[214]:=Abs(Vl(FetchElm(RetNo,'S12', 317)))
  else
  Tv[214]:=0;

  Tv[221] := Tv[201]+Tv[203]+Tv[204]+Tv[206]+Tv[228]-Tv[208]-Tv[210]
  -Tv[212]-Tv[214]-Tv[216]-Tv[220]-Tv[218]-Tv[229];
  Tv[222] := Tv[202]+Tv[205]+Tv[207]-Tv[211]-Tv[217]
  -Tv[219]-Tv[209];

  If (Tv[222]<0) and (IsS12Designation(RetNo) =false) then
  Tv[216]:=Abs(Tv[222])
  else
  Tv[216]:=0;

  If UpperCase(Strings[227])<> 'Y' then
  begin
  Tv[223]:= RoundCorrect(MaxR(0,Tv[221] * 0.30)); //20180610
  Tv[224]:= RoundCorrect(MaxR(0,Tv[222] * 0.30));              //20180610
  end;
  Tv[225] := MaxR(0,Tv[221] - Tv[223]);
  Tv[226] := MaxR(0,Tv[222] - Tv[224]);

  //20150531
  Tv[36]:=Tv[223];
  Tv[37]:=Tv[224];
  Tv[38]:=Tv[36]+Tv[37];

  end; {End with}

  //S12 pg 4--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
  Tv[317] := Tv[301]+Tv[303]+Tv[304]+Tv[307]-Tv[309]-Tv[311]
  -Tv[313]-Tv[315];
  Tv[318] := Tv[302]+Tv[305]+Tv[306]-Tv[310]-Tv[314]
  -Tv[316];

  If (Tv[318]<0) and (IsS12Designation(RetNo) =false) then
  Tv[315]:=Abs(Tv[318])
  else
  Tv[315]:=0;

  If UpperCase(Strings[323])<> 'Y' then
  begin
  Tv[319]:=RoundCorrect(MaxR(0,Tv[317] * 0.10));  //20180610
  Tv[320]:=RoundCorrect(MaxR(0,Tv[318] * 0.10));   //20180610
  end;
  Tv[321] := MaxR(0,Tv[317] - Tv[319]);
  Tv[322] := MaxR(0,Tv[318] - Tv[320]);

  //20150531
  Tv[39]:=Tv[319];
  Tv[40]:=Tv[320];
  Tv[41]:=Tv[39]+Tv[40];
  end; {End with}

  //S12 pg 5--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
  Tv[409] := Tv[401]+Tv[404]-Tv[407];
  Tv[410] := Tv[402]+Tv[405]+Tv[406]-Tv[408];

  If UpperCase(Strings[418])<> 'Y' then
  begin
  Tv[411]:=RoundCorrect(MaxR(0,Tv[409] * 0.10)); //20180610
  Tv[412]:=RoundCorrect(MaxR(0,Tv[410] * 0.10)); //20180610
  end;
  Tv[413] := MaxR(0,Tv[409] - Tv[411]);
  Tv[414] := MaxR(0,Tv[410] - Tv[412]);
  //20150531
  Tv[42]:=Tv[411];
  Tv[43]:=Tv[412];
  Tv[44]:=Tv[596];
  Tv[45]:=Tv[597];
  Tv[46]:=Tv[696];
  Tv[47]:=Tv[697];
  Tv[48]:=0;   For i:=42 to 47 do Tv[48]:=Tv[48]+Tv[i];
  end; {End with}
  //S12 pg 6--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
  i:=501;
  k:=500;
  Tv[596]:=0;
  Tv[597]:=0;
  Repeat
  Tv[31+k]:=Tv[6+k]+Tv[16+k]+Tv[21+k]-Tv[26+k];
  If Tv[36+k]>TV[31+k] then Tv[36+k]:=Tv[31+k];
  If Tv[31+k]<0 then
  begin Tv[36+k]:=0;Tv[41+k]:=0;end
  else
  begin Tv[41+k]:=MaxR(0,Tv[31+k]-Tv[36+k]);end;

  Tv[76+k]:=Tv[56+k]+Tv[61+k]+Tv[66+k]-Tv[71+k];
  If Tv[81+k]>TV[76+k] then Tv[81+k]:=Tv[76+k];
  If Tv[76+k]<0 then
  begin Tv[81+k]:=0;Tv[86+k]:=0;end
  else
  begin Tv[86+k]:=MaxR(0,Tv[76+k]-Tv[81+k]);end;

  Tv[596]:=Tv[596]+Tv[36+k];
  Tv[597]:=Tv[597]+Tv[81+k];
  Inc(i);
  Inc(k);
  until i>505;
  end; {End with}

  //S12 pg 7--------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
  i:=601;
  k:=600;
  Tv[696]:=0;
  Tv[697]:=0;
  Repeat
  Tv[31+k]:=Tv[6+k]+Tv[11+k]+Tv[16+k]+Tv[21+k]-Tv[26+k];
  //TotAvlbl:=TotAvlbl+Tv[31+k];
  //Tv[36+k]:= MinR(TV[31+k],  ??
  If Tv[31+k]<0 then
  begin Tv[36+k]:=0;Tv[41+k]:=0;end
  else
  begin Tv[41+k]:=MaxR(0,Tv[31+k]-Tv[36+k]);end;

  Tv[76+k]:=Tv[56+k]+Tv[61+k]+Tv[66+k]-Tv[71+k];
  If Tv[31+k]<0 then
  begin Tv[36+k]:=0;Tv[41+k]:=0;end
  else
  begin Tv[41+k]:=MaxR(0,Tv[31+k]-Tv[36+k]);end;

  Tv[696]:=Tv[696]+Tv[36+k];
  Tv[697]:=Tv[697]+Tv[81+k];
  Inc(i);
  Inc(k);
  until i>605;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure FLDTAPE(RetNo: integer; FName: String; FNo: integer);
Var
  RefFormName: String;
  // 20220121 Igor >>>
  TapeStr: string;
  Idx: integer;
  // 20220121 Igor <<<
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[125] := AddColumns(1, 60, 1);
    RefFormName := Strings[121];
    // 20220121 Igor >>>
    If (Tv[125] <> 0) and (Strings[123] + Strings[124] = '') then
    begin
      Strings[123] := 'X';
      Strings[124] := '';
    end;
    TapeStr := RefFormName + '|' + Strings[122];
    If (UpperCase(Strings[123]) = 'X') and (RefFormName > '') then
    begin
      StoreElm(RetNo, GetFormNo(RefFormName), MyStrToInt(Strings[122]),
        FormatFloat('########.00', Tv[125]));
      if not Ret[RetNo].TapesList.Find(TapeStr, Idx) then
        Ret[RetNo].TapesList.Add(TapeStr);
    end
    else if Ret[RetNo].TapesList.Find(TapeStr, Idx) then
      Ret[RetNo].TapesList.Delete(Idx);
    // 20220121 Igor <<<
  end;
  SaveTv(RetNo, FName, FNo);
  If (UpperCase(Ret[RetNo].Frm[FNo].Strings[123]) = 'X') and (RefFormName > '')
  then
  begin
    Calc(RetNo, RefFormName);
  end;
  // MainForm.UpdateTaxPanel;
end;

Procedure FldMEM(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T106(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    // FillHeader(RetNo,FNo,1,2,3);    //20171126
    if Strings[3] = '' then
      Strings[3] := '1  New'; // 20180628

    if Strings[3] = '3   Amended' then //jz 20241211 if amended print Amended at top of page
      Strings[78] := 'AMENDED';

    For i := 8 to 22 do
      Strings[i] := '';
    if Strings[110] = '' then
      Strings[110] := '1  New';
    Strings[4] := 'X';
    if Strings[2] = '' then
      Strings[2] := 'CAN'; // 20220718

    Strings[5] := GetCorpName(RetNo);
    Strings[6] := GetAccountNumber(RetNo);
    Strings[23] := FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[24] := FetchElm(RetNo, 'T2', 16);
    Strings[25] := FetchElm(RetNo, 'T2', 17);
    Strings[26] := FetchElm(RetNo, 'T2', 20);

    Strings[27] := GetBegYearEnd(RetNo);
    Strings[28] := GetTaxationYearEnd(RetNo);

    Strings[32] := IntToStr(CountMultipleInstances(RetNo, 'T106SL'));

    // 20180719 Tv[33]:=TotMultiple(RetNo,'T106SL',174);
    Tv[33] := TotMultipleExludingDeletedSlips(RetNo, 'T106SL', 174, 110,
      '4   Delete (Close)');

    Tv[34] := TotMultiple(RetNo, 'S125', 14); // GIFIIS','8299');   //20150826

    // 20180801
    for i := 35 to 38 do
    begin
      Strings[i] := LeftStr(Strings[i], 6);
      // NAICS Replacing CleanUp routine in ChildWinNew
    end;
    Strings[60] := LeftStr(Strings[60], 3);
    // Functional currency Replacing CleanUp routine in ChildWinNew
    Strings[2] := LeftStr(Strings[2], 3);
    // Functional currency Replacing CleanUp routine in ChildWinNew

    // 20171126
    //Section 2
    If Strings[29] + Strings[30] = '' then
      Strings[30] := 'X';
    If Strings[39] + Strings[40] = '' then
      Strings[40] := 'X';
    If Strings[41] + Strings[42] = '' then
      Strings[42] := 'X';

    //If Strings[43] + Strings[44] = '' then //jz 20241126 no longer exists
    //  Strings[44] := 'X';

    //jz 20241126 new fields <<
    If Strings[65] + Strings[66] = '' then
      Strings[66] := 'X';
    If Strings[66] = '' then Strings[67] := '';

    If Strings[68] + Strings[69] = '' then
      Strings[69] := 'X';

    If Strings[70] + Strings[71] = '' then
      Strings[71] := 'X';

    //jz 20241126 >>

    If Strings[45] + Strings[46] = '' then
      Strings[46] := 'X';
    If Strings[49] + Strings[50] = '' then
      Strings[50] := 'X';
    If Strings[51] + Strings[52] = '' then
      Strings[52] := 'X';

    //Certification
    If Strings[53] = '' then
      Strings[53] := FetchElm(RetNo, 'T2', 743);
    If Strings[54] = '' then
      Strings[54] := FetchElm(RetNo, 'T2', 742);
    If Strings[55] = '' then
      Strings[55] := FetchElm(RetNo, 'T2', 755);
    If Strings[56] = '' then
      Strings[56] := FetchElm(RetNo, 'T2', 746);
    If Strings[59] = '' then
      Strings[59] := FetchElm(RetNo, 'T2', 744);
    If Strings[57] = '' then
      Strings[57] := FetchElm(RetNo, 'T2', 743) + ' ' +
        FetchElm(RetNo, 'T2', 742);
    If Strings[58] = '' then
      Strings[58] := FetchElm(RetNo, 'T2', 745);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T106SL(RetNo: integer; FName: String; FNo: integer);
Var
  i, k: integer;
  FInst: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FInst := ExtractFormInst(FName);
    Strings[124] := MidStr(FInst, 2, 3);
    if Strings[110] = '' then
      Strings[110] := '1  New'; // 20180628
    Strings[125] := IntToStr(CountMultipleInstances(RetNo, 'T106SL'));
    // FillHeader(RetNo,FNo,1,2,3);
    Strings[23] := 'X';
    Strings[1] := GetCorpBusNo(RetNo);
    Strings[8] := GetBegYearEnd(RetNo);
    Strings[9] := GetTaxationYearEnd(RetNo);
    if Strings[14] + Strings[15] + Strings[16] = '' then
      Strings[14] := ''; // 20171130

    Tv[92] := Tv[120] + AddColumns(32, 88, 4) + Tv[126] + Tv[130] + Tv[134];
    // 20180719 was missing elms in addition Tv[92]:=Tv[120]+AddColumns(32,88,4);
    Tv[94] := Tv[122] + AddColumns(34, 90, 4) + Tv[128] + Tv[132] + Tv[136];
    // was missing elms in addition Tv[94]:=Tv[122]+AddColumns(34,90,4);

    i := 96;
    Tv[108] := 0;
    Tv[109] := 0;
    Repeat
      Tv[i + 3] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2]);
      Tv[108] := Tv[108] + Tv[i + 1];
      Tv[109] := Tv[109] + Tv[i + 2];
      Inc(i, 4);
    until i > 104;
    // new row //20220618
    Tv[179] := Tv[176] + Tv[177] - Tv[178];
    Tv[108] := Tv[108] + Tv[177];
    Tv[109] := Tv[109] + Tv[178];

    i := 138;
    k := 0;
    Tv[171] := 0;
    Tv[172] := 0;
    Tv[173] := 0;
    Repeat
      k := k + MyStrToInt(Strings[i]);
      Tv[171] := Tv[171] + Tv[i + 1];
      Tv[172] := Tv[172] + Tv[i + 2];
      Tv[173] := Tv[173] + Tv[i + 3];
      Inc(i, 4);
    until i > 166;
    Strings[170] := IntToStr(k);
    Tv[174] := Tv[92] + Tv[94] + Tv[108] + Tv[109] + Tv[172] + Tv[173];
    Tv[114] := Tv[111] + Tv[112] - Tv[113];
    Tv[118] := Tv[115] + Tv[116] - Tv[117];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T183CP(RetNo: integer; FName: String; FNo: integer);
var
  Email: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);
    Strings[2] := GetAccountNumber(RetNo);
    Strings[3] := GetBegYearEnd(RetNo);
    Strings[4] := GetTaxationYearEnd(RetNo);
    Strings[20] := '';
    Strings[27] := 'X';
    // 20220706
    Email := FetchElm(RetNo, 'T2', 263);
    if (UpperCase(Strings[28]) = 'Y') and (Strings[18] = '') and (Email > '')
    then // 20220
      Strings[18] := Email;

    If IsAmendedReturn(RetNo) then
    begin
      Strings[20] := 'X';
      Strings[27] := '';
    end;
    Tv[5]  := Vl(FetchElm(RetNo, 'T2', 214));   //line 300
    Tv[6]  := Vl(FetchElm(RetNo, 'T2', 701));   //line 700
    Tv[19] := Vl(FetchElm(RetNo, 'T2', 126));   //line 705 //jz VT49
    //Tv[8]  := Vl(FetchElm(RetNo, 'T2', 703)); //line 708 //jz 20241127 line 708 removed
    Tv[22] := Vl(FetchElm(RetNo, 'T2', 722));   //line 710
    Tv[9]  := Vl(FetchElm(RetNo, 'T2', 704));   //line 712
    Tv[10] := Vl(FetchElm(RetNo, 'T2', 705));   //line 716
    Tv[11] := Vl(FetchElm(RetNo, 'T2', 706));   //line 720
    Tv[12] := Vl(FetchElm(RetNo, 'T2', 707));   //line 724
    Tv[13] := Vl(FetchElm(RetNo, 'T2', 708));   //line 728
    Tv[14] := Vl(FetchElm(RetNo, 'T2', 711));   //line 760
    Tv[15] := Vl(FetchElm(RetNo, 'T2', 714));   //line 770

    // email 20170626
    if UpperCase(Strings[28]) <> 'Y' then
      Strings[18] := '';
    if (IsEfiled(RetNo) = false) or (IsAmendedReturn(RetNo) = True) // 20171231
    then
    Begin
      Strings[28] := '';
      Strings[18] := '';
    End;
    // ---------

    // 20110417
    Strings[24] := UpperCase(AllTrim(FetchElm(RetNo, 'T2', 742)));
    // auth last nm
    Strings[25] := UpperCase(AllTrim(FetchElm(RetNo, 'T2', 743)));
    // auth first nm
    Strings[26] := AllTrim(FetchElm(RetNo, 'T2', 744)); // position
    Strings[23] := '(' + AllTrim(FetchElm(RetNo, 'T2', 755)) + ') ' +
      AllTrim(FetchElm(RetNo, 'T2', 746)); // auth person phone

    If FillSignatureDates = True then
      Strings[16] := FormatDateTime('yyyy/mm/dd', Date);
    If Strings[17] = '' then
      Strings[17] := OptRec.Prp_Name;
    Strings[7] := GetEfilerNo; // 20140511
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure UsedFrm(RetNo: integer; FName: String; FNo: integer);
begin
  // nothing here
end;

Procedure CalcUsedFrm(RetNo: integer);
Var
  i, FNo: integer;
  FName: String;
  MyPageControl: TPageControl;
  MyTabSheet: TTabSheet;
begin
  FName := 'USEDFRM';
  FNo := GetFormNo(FName);
  Try
    // MyChild:=MainForm.ActiveMDIChild as TMyChild;  //20150703
    MyPageControl := RetList[RetNo].MyChild.MyPageControl;
    // GetPageControl(MyChild); //20150703 //MyPageControl:=GetPageControl(MyChild);
    LoadTv(RetNo, FName, FNo);
    with Ret[RetNo].Frm[FNo] do
    begin
      For i := 1 to 30 do
      begin
        Strings[i] := '';
      end;
      For i := 0 to MyPageControl.PageCount - 1 do
      begin
        MyTabSheet := MyPageControl.Pages[i];
        If i <= 30 then
          // if +1 is removed then the info screen is not included....
          Strings[i + 1] := MyTabSheet.Caption;
      end;
      Strings[31] := MyPageControl.ActivePage.Caption; // 20150813
    end;
    SaveTv(RetNo, FName, FNo);
  Except
  end;
end;

Procedure S53(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  GFactor: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    // 20181107
    if UpperCase(FetchElm(RetNo, 'T2', 62)) = 'CREDIT UNION' then // 20181104
    Begin
      for i := 1 to 113 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;

    If GetTaxationYearEnd(RetNo) < '2006/01/01' then
    begin
      For i := 4 to 83 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;
    If Strings[87] = '' then
      Strings[87] := 'N';
    If (Ret[RetNo].CorpType = CCPC) or (IsDic(RetNo) = True) then
      // ok
    else
    begin
      For i := 4 to 82 do
        Tv[i] := 0;
      Tv[83] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    // 20160605
    GFactor := 0.72;
    If DateWithinTaxYear('2006/01/01', RetNo) = True then
      Tv[4] := 0;
    Tv[5] := GetTxblIncome(RetNo);
    If (Tv[5] > 0) and (Tv[5] < 1) then
      Tv[5] := 0; // 20090724
    If IsDic(RetNo) = True then
      Tv[5] := 0;
    // Tv[6]:=Vl(FetchElm(RetNo,'S17',61));
    Tv[7] := GetIncForSmBusDed(RetNo);
    If Ret[RetNo].CorpType = CCPC then
      Tv[8] := Ret[RetNo].Ln[440]
    else
      Tv[8] := 0;
    Tv[19] := Tv[5];
    Tv[83] := MinR(Tv[8], Tv[19]);
    Tv[9] := Tv[7] + Tv[83]; // Tv[6]+  //20180502
    Tv[10] := Tv[9];
    Tv[11] := MaxR(0, Tv[5] - Tv[10]);
    Tv[12] := RoundCorrect(Tv[11] * GFactor); // 20180610
    If (Tv[12] > 0) and (Tv[12] < 1) then
      Tv[12] := 0; // 20090724

    Tv[13] := Vl(FetchElm(RetNo, 'S3', 99)); // 20190708

    Tv[111] := Tv[13] + Tv[14];
    Tv[15] := Tv[111];
    Tv[16] := MaxR(0, TotMultiple(RetNo, 'S53ADJ', 19));
    Tv[17] := TotMultiple(RetNo, 'S53ADJ', 17) +
      TotMultiple(RetNo, 'S53ADJ', 20);
    Tv[18] := TotMultiple(RetNo, 'S53ADJ', 18) +
      TotMultiple(RetNo, 'S53ADJ', 21);
    Tv[112] := Tv[16] + Tv[17] + Tv[18];
    Tv[20] := Tv[112];
    Tv[21] := Tv[4] + Tv[12] + Tv[15] + Tv[20]; // 200906005

    Tv[113] := MaxR(0, Tv[22] - Tv[23]);
    Tv[24] := Tv[113];
    Tv[25] := Tv[21] - Tv[24];
    Tv[26] := Tv[82];
    Tv[27] := MaxR(0, Tv[25] - Tv[26]);
    If (Tv[27] > 0) and (Tv[27] < 1) then
      Tv[27] := 0; // 20090724
    Tv[29] := GetIncForSmBusDed(RetNo); // 20190930
    // part 2
    Tv[32] := Tv[29] + Tv[30] + Tv[31];
    Tv[33] := Tv[32];
    Tv[34] := MaxR(0, Tv[28] - Tv[33]);
    Tv[35] := Tv[34];
    Tv[88] := Vl(FetchElm(RetNo, 'S4', 27)); // non cap loss
    Tv[89] := Vl(FetchElm(RetNo, 'S4', 129)); // farm
    Tv[90] := Vl(FetchElm(RetNo, 'S4', 212)); // rest
    Tv[91] := Vl(FetchElm(RetNo, 'S4', 112)); // cap
    Tv[93] := Tv[88] + Tv[89] + Tv[90] + Tv[91] + Tv[92];

    Tv[36] := MaxR(0, Tv[28] - Tv[93]);
    Tv[37] := GetIncForSmBusDed(RetNo); // 20190930
    // future onseq
    Strings[106] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 1);

    // 20180502
    Tv[40] := Tv[37] + Tv[38];
    Tv[41] := Tv[40];
    Tv[42] := MaxR(0, Tv[36] - Tv[41]);
    Tv[43] := Tv[42];
    Tv[44] := MaxR(0, Tv[35] - Tv[43]);
    Tv[45] := RoundCorrect(Tv[44] * GFactor); // 20180610

    Strings[107] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 2);
    Tv[62] := GetIncForSmBusDed(RetNo); // 20190930
    Tv[59] := Tv[62] + Tv[61] + Tv[60]; // +Tv[19];  20090512
    Tv[58] := Tv[59];
    Tv[57] := MaxR(0, Tv[63] - Tv[58]);
    Tv[58] := Tv[59];

    Tv[57] := MaxR(0, Tv[63] - Tv[58]);
    Tv[56] := Tv[57];

    Tv[94] := Vl(FetchElm(RetNo, 'S4', 28)); // non cap loss
    Tv[95] := Vl(FetchElm(RetNo, 'S4', 130)); // farm
    Tv[96] := Vl(FetchElm(RetNo, 'S4', 213)); // rest
    Tv[97] := Vl(FetchElm(RetNo, 'S4', 113)); // cap
    Tv[99] := Tv[94] + Tv[95] + Tv[96] + Tv[97] + Tv[98];
    Tv[55] := MaxR(0, Tv[63] - Tv[99]);

    Tv[54] := GetIncForSmBusDed(RetNo); // 20190930
    Tv[51] := Tv[54] + Tv[53] + Tv[52]; // +Tv[84];  //20090512
    Tv[50] := Tv[51];
    Tv[49] := MaxR(0, Tv[55] - Tv[50]);
    Tv[48] := Tv[49];
    Tv[47] := MaxR(0, Tv[56] - Tv[48]);
    Tv[46] := RoundCorrect(Tv[47] * GFactor); // 68/100;

    Tv[65] := GetIncForSmBusDed(RetNo); // 20190930
    Tv[68] := Tv[65] + Tv[66] + Tv[67]; // +Tv[85];  //20090512
    Tv[69] := Tv[68];
    Tv[70] := MaxR(0, Tv[64] - Tv[69]);
    Tv[71] := Tv[70];

    Strings[108] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 3);
    Tv[100] := Vl(FetchElm(RetNo, 'S4', 29)); // non cap loss
    Tv[101] := Vl(FetchElm(RetNo, 'S4', 131)); // farm
    Tv[102] := Vl(FetchElm(RetNo, 'S4', 214)); // rest
    Tv[103] := Vl(FetchElm(RetNo, 'S4', 114)); // cap
    Tv[105] := Tv[100] + Tv[101] + Tv[102] + Tv[103] + Tv[104];
    Tv[72] := MaxR(0, Tv[64] - Tv[105]);

    Tv[73] := GetIncForSmBusDed(RetNo); // 20190930
    Tv[76] := Tv[73] + Tv[74] + Tv[75]; // +Tv[86];  //20090512
    Tv[77] := Tv[76];
    Tv[78] := MaxR(0, Tv[72] - Tv[77]);
    Tv[79] := Tv[78];
    Tv[80] := MaxR(0, Tv[71] - Tv[79]);
    Tv[81] := Tv[80] * GFactor; // 68/100;

    Tv[82] := Tv[45] + Tv[46] + Tv[81];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S53ADJ(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Tv[8] := MaxR(0, Tv[6] - Tv[7]);
    Tv[9] := Tv[8];
    Tv[10] := MaxR(0, Tv[5] - Tv[9]);
    Tv[17] := 0;
    Tv[18] := 0;
    If Strings[11] > '' then
      Tv[17] := Tv[10];
    If Strings[12] > '' then
      Tv[18] := Tv[10];

    Tv[96] := AddColumns(91, 95, 1);
    Tv[97] := Tv[96];
    Tv[103] := AddColumns(98, 102, 1);
    Tv[104] := Tv[103];
    Tv[105] := MaxR(0, Tv[97] - Tv[104]);
    Tv[106] := Tv[105];
    Tv[107] := Tv[89] + Tv[90] + Tv[106];

    Tv[113] := AddColumns(108, 112, 1);
    Tv[114] := Tv[113];
    Tv[115] := MaxR(0, Tv[107] - Tv[114]);

    Tv[19] := 0;
    Tv[20] := 0;
    Tv[21] := 0;
    If Strings[16] > '' then
      Tv[19] := Tv[115];
    If Strings[14] > '' then
      Tv[20] := Tv[115];
    If Strings[15] > '' then
      Tv[21] := Tv[115];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S53ADD06(RetNo: integer; FName: String; FNo: integer);
Var
  k, L: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Strings[187] := '2001';
    Strings[188] := '2002';
    Strings[189] := '2003';
    Strings[190] := '2004';
    Strings[191] := '2005';

    Strings[124] := 'Nil';
    Tv[124] := 0;
    Strings[125] := 'Nil';
    Tv[125] := 0;
    Strings[129] := 'Nil';
    Tv[129] := 0;
    Strings[130] := 'Nil';
    Tv[130] := 0;
    Strings[200] := 'Nil';
    Tv[200] := 0;

    k := 0;
    L := 0;
    Repeat
      If Tv[116 + k] < 0 then
        Tv[116 + k] := 0;
      Tv[151 + k] := AddColumns(121 + k, 146 + k, 5) + Tv[196 + L];
      Tv[156 + k] := MaxR(0, Tv[116 + k] - Tv[151 + k]);
      Tv[161 + k] := Tv[156 + k] * 0.63;
      Tv[171 + k] := Tv[161 + k] + Tv[166 + k];
      Tv[181 + k] := Tv[171 + k] - Tv[176 + k];
      Inc(k, 1);
      Inc(L, 1);
    until k > 4;
    Tv[186] := MaxR(0, AddColumns(181, 185, 1));
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S54(RetNo: integer; FName: String; FNo: integer);
Var
  i, j: integer;
  IsItDIC: Boolean;
  Election: Boolean;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If FetchElm(RetNo, 'T2002', 20) > '' then
      Strings[113] := 'Y'
    else
      Strings[113] := 'N';
    If GetTaxationYearEnd(RetNo) < '2006/01/01' then
    begin
      For i := 4 to 109 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    If UpperCase(Strings[62]) = '' then
      Strings[62] := 'N';
    If UpperCase(Strings[63]) = '' then
      Strings[63] := 'N';
    If UpperCase(Strings[62]) = 'Y' then
      IsItDIC := True
    else
      IsItDIC := false;
    If UpperCase(Strings[63]) = 'Y' then
      Election := True
    else
      Election := false;

    If ((Ret[RetNo].CorpType <> CCPC) or (IsItDIC = false)) or (Election = True)
    then
      // ok
    else
    begin
      For i := 4 to 109 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    // Tv[7]:=Tv[5]+Tv[6];  //20210516
    Tv[8] := Tv[6] * 80 / 100;
    Tv[10] := Tv[9] * 4;
    Tv[11] := Tv[4] + Tv[8] + Tv[10];
    // part 2
    i := 12;
    Tv[104] := 0;
    Repeat
      If Strings[i] = '' then
      begin
        For j := i + 1 to i + 8 do
          Tv[j] := 0;
      end;
      If i > 12 then
        Tv[i + 2] := MaxR(0, Tv[i + 2 - 9] + GetS54Adj(RetNo, Strings[i]))
      else
        Tv[i + 2] := MaxR(0, GetS54Adj(RetNo, Strings[i]));
      Tv[i + 3] := Tv[11] + Tv[i + 1] + Tv[i + 2];
      Tv[i + 6] := MaxR(0, Tv[i + 3] - Tv[i + 4] - Tv[i + 5]);
      Tv[i + 8] := MinR(Tv[i + 6], Tv[i + 7]);
      If i > 12 then
        Tv[i + 5] := GetRunningExcessive(RetNo, i + 5 - 6); // 20150703
      If Strings[i] = '' then
      begin
        For j := i + 1 to i + 8 do
          Tv[j] := 0;
      end;
      Tv[104] := Tv[104] + Tv[i + 8];
      Inc(i, 9);
    until i > 95;
    Tv[17] := 0;

    // Part 3
    (* 20111102
      Tv[103]:=0;
      Tv[110]:=0;
      i:=93;
      Repeat
      If Strings[i] >'' then
      begin
      Tv[103]:=Tv[i+6];
      Tv[110]:=Tv[i+8];
      Break;
      end;
      Inc(i,-9);
      until i<12; //12;
    *)
    Tv[103] := MaxR(0, Tv[103]);
    Tv[110] := MaxR(0, Tv[110]);

    Tv[102] := Tv[11];
    Tv[111] := Tv[103] + Tv[110];
    Tv[112] := Tv[111];
    Tv[114] := Tv[102] + Tv[112];

    Tv[115] := Tv[104];
    Tv[116] := Tv[107] + Tv[115];
    Tv[117] := Tv[116];
    Tv[109] := MaxR(0, Tv[114] - Tv[117]);

    // part 4  //20211111
    Tv[123] := 0;
    for i := 118 to 123 do
    begin
      Tv[123] := Tv[123] + Tv[i];
    end;
    Tv[108] := Tv[123];

    Tv[129] := 0;
    for i := 124 to 128 do
    begin
      Tv[129] := Tv[129] + Tv[i];
    end;
    Tv[130] := Tv[129];
    Tv[131] := MaxR(0, Tv[108] - Tv[130]);

    Tv[132] := Tv[131];
    Tv[133] := Tv[105] + Tv[106] + Tv[132];

    Tv[141] := MaxR(0, Tv[139] - Tv[140]);
    Tv[142] := Tv[141];
    Tv[143] := MaxR(0, Tv[138] - Tv[142]);
    Tv[144] := Tv[143];
    Tv[145] := Tv[134] + Tv[135] + Tv[136] + Tv[137] + Tv[144];
    Tv[146] := Tv[145];
    Tv[147] := MaxR(0, Tv[133] - Tv[146]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S54WS1(RetNo: integer; FName: String; FNo: integer);
Var
  i, j: integer;
  IsItDIC: Boolean;
  Election: Boolean;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    // part 5  //20211111
    Tv[11] := 0;
    for i := 6 to 10 do
    begin
      Tv[11] := Tv[11] + Tv[i];
    end;
    Tv[12] := Tv[11];

    Tv[18] := 0;
    for i := 13 to 17 do
    begin
      Tv[18] := Tv[18] + Tv[i];
    end;
    Tv[19] := Tv[18];

    Tv[21] := Tv[20];
    Tv[22] := Tv[4] + Tv[5] + Tv[21];
    Tv[30] := Tv[28] + Tv[29];
    Tv[31] := Tv[30];

    Tv[32] := MaxR(0, Tv[27] - Tv[31]);
    Tv[33] := Tv[32];
    Tv[34] := Tv[23] + Tv[24] + Tv[25] + Tv[26] + Tv[33];
    Tv[35] := Tv[34];
    Tv[36] := MaxR(0, Tv[22] - Tv[35]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S54WS2(RetNo: integer; FName: String; FNo: integer);
Var
  i, j: integer;
  IsItDIC: Boolean;
  Election: Boolean;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    // part 6  //20211111
    Tv[11] := 0;
    for i := 6 to 10 do
    begin
      Tv[11] := Tv[11] + Tv[i];
    end;
    Tv[12] := Tv[11];

    Tv[18] := 0;
    for i := 13 to 17 do
    begin
      Tv[18] := Tv[18] + Tv[i];
    end;
    Tv[19] := Tv[18];

    Tv[21] := Tv[20];
    Tv[22] := Tv[4] + Tv[5] + Tv[21];

    Tv[30] := Tv[28] + Tv[29];
    Tv[31] := Tv[30];

    Tv[32] := MaxR(0, Tv[27] - Tv[31]);
    Tv[33] := Tv[32];

    Tv[34] := Tv[23] + Tv[24] + Tv[25] + Tv[26] + Tv[33];
    Tv[35] := Tv[34];
    Tv[36] := MaxR(0, Tv[22] - Tv[35]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Function GetRunningExcessive(RetNo, UpTo: integer): Real; // 20150703
Var
  i, FNo: integer;
begin
  Result := 0;
  FNo := GetFormNo('S54');
  i := 20;
  Repeat
    Result := Result + Vl(FetchElmFNo(RetNo, FNo, i));
    Inc(i, 9);
  until i > UpTo;
end;

Procedure S54ADJ(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Tv[69] := AddColumns(64, 68, 1);
    Tv[70] := Tv[69];
    Tv[76] := AddColumns(71, 75, 1);
    Tv[77] := Tv[76];
    Tv[78] := MaxR(0, Tv[70] - Tv[77]);
    Tv[79] := Tv[78];
    Tv[80] := Tv[62] + Tv[63] + Tv[79];

    Tv[88] := MaxR(0, Tv[86] - Tv[87]);
    Tv[89] := Tv[88];
    Tv[90] := MaxR(0, Tv[85] - Tv[89]);
    Tv[91] := Tv[90];
    Tv[92] := AddColumns(81, 84, 1) + Tv[91];
    Tv[93] := Tv[92];
    Tv[94] := MaxR(0, Tv[80] - Tv[93]);
    // -------------
    Tv[102] := AddColumns(97, 101, 1);
    Tv[103] := Tv[102];
    Tv[109] := AddColumns(104, 108, 1);
    Tv[110] := Tv[109];
    Tv[111] := MaxR(0, Tv[103] - Tv[110]);
    Tv[112] := Tv[111];
    Tv[113] := Tv[95] + Tv[96] + Tv[112];

    Tv[121] := MaxR(0, Tv[119] - Tv[120]);
    Tv[122] := Tv[121];
    Tv[123] := MaxR(0, Tv[118] - Tv[122]);
    Tv[124] := Tv[123];
    Tv[125] := AddColumns(114, 117, 1) + Tv[124];
    Tv[126] := Tv[125];
    Tv[127] := MaxR(0, Tv[113] - Tv[126]);

    Tv[129] := Tv[127] + Tv[128];

    Tv[137] := AddColumns(132, 136, 1);
    Tv[138] := Tv[137];
    Tv[144] := AddColumns(139, 143, 1);
    Tv[145] := Tv[144];
    Tv[146] := MaxR(0, Tv[138] - Tv[145]);
    Tv[147] := Tv[146];
    Tv[148] := Tv[130] + Tv[131] + Tv[147];

    Tv[156] := MaxR(0, Tv[154] - Tv[153]);
    Tv[157] := Tv[156];
    Tv[158] := MaxR(0, Tv[153] - Tv[157]);
    Tv[159] := Tv[158];
    Tv[160] := AddColumns(149, 152, 1) + Tv[159];
    Tv[161] := Tv[160];
    Tv[162] := MaxR(0, Tv[148] - Tv[161]);

    Tv[164] := Tv[162] + Tv[163];

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S55(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If (Ret[RetNo].CorpType = CCPC) or (IsDic(RetNo) = True) then
    begin
      Tv[4] := Vl(FetchElm(RetNo, 'S3', 252));
      Tv[5] := Vl(FetchElm(RetNo, 'S3', 95)) + Vl(FetchElm(RetNo, 'S3', 143));
      // 20190708
      Tv[6] := MaxR(0, Vl(FetchElm(RetNo, 'S53', 27)));
      Tv[7] := MaxR(0, Tv[5] - Tv[6]);
      Tv[13] := MaxR(0, Tv[7] - Tv[12]);
      Tv[8] := Tv[13] * 20 / 100; // 20120428
      For i := 9 to 11 do
        Tv[i] := 0;
      Tv[14] := 0;
      Tv[15] := 0;
    end
    else
    begin
      Tv[9] := Vl(FetchElm(RetNo, 'S3', 252));
      Tv[10] := Vl(FetchElm(RetNo, 'S54', 104));
      Tv[15] := MaxR(0, Tv[10] - Tv[14]);
      Tv[11] := Tv[15] * 20 / 100; // Tv[10] * 20/100; 20120428
      For i := 4 to 8 do
        Tv[i] := 0;
      Tv[12] := 0;
      Tv[13] := 0;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Function GetS54Adj(RetNo: integer; Dt: String): Real;
Var
  i: integer;
Begin
  Result := 0;
  for i := 0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    IF FRec.FormName = 'S54ADJ' then
    begin
      If Dt = FetchElmFNo(RetNo, FRec.FormNo, 7) then
        Result := Result + Vl(FetchElmFNo(RetNo, FRec.FormNo, 94));
      If Dt = FetchElmFNo(RetNo, FRec.FormNo, 8) then
        Result := Result + Vl(FetchElmFNo(RetNo, FRec.FormNo, 127));
      If Dt = FetchElmFNo(RetNo, FRec.FormNo, 9) then
        Result := Result + Vl(FetchElmFNo(RetNo, FRec.FormNo, 164));
    end;
  end;
end;

Procedure T2002(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);
    Strings[2] := GetCorpBusNo(RetNo);
    If Strings[3] = '' then
      Strings[3] := FetchElm(RetNo, 'T2', 26) + ' ' + FetchElm(RetNo, 'T2', 27)
        + ' ' + FetchElm(RetNo, 'T2', 32) + ' ' + FetchElm(RetNo, 'T2', 33);
    If Strings[4] = '' then
      Strings[4] := FetchElm(RetNo, 'T2', 35);
    If Strings[5] = '' then
      Strings[5] := FetchElm(RetNo, 'T2', 743) + ' ' +
        FetchElm(RetNo, 'T2', 742);
    If Strings[6] = '' then
      Strings[6] := FetchElm(RetNo, 'T2', 755);
    If Strings[7] = '' then
      Strings[7] := FetchElm(RetNo, 'T2', 746);
    If Ret[RetNo].CorpType <> CCPC then
      Strings[20] := ''; // 20150315
    If Strings[20] > '' then
    begin
      Strings[8] := GetTaxationYearEnd(RetNo);
      If Strings[9] + Strings[10] = '' then
        Strings[10] := 'X';
      If Strings[11] = '' then
        Strings[11] := FetchElm(RetNo, 'T2', 743) + ' ' +
          FetchElm(RetNo, 'T2', 742);
      If Strings[12] = '' then
        Strings[12] := FetchElm(RetNo, 'T2', 744);
      If Strings[13] = '' then
        Strings[13] := FormatDateTime('yyyy/mm/dd', Date);
    end
    else
      For i := 8 to 13 do
        Strings[i] := '';

    If Strings[21] > '' then
    begin
      Strings[14] := GetTaxationYearEnd(RetNo);
      If Strings[15] + Strings[16] = '' then
        Strings[16] := 'X';
      If Strings[17] = '' then
        Strings[17] := FetchElm(RetNo, 'T2', 743) + ' ' +
          FetchElm(RetNo, 'T2', 742);
      If Strings[18] = '' then
        Strings[18] := FetchElm(RetNo, 'T2', 744);
      If Strings[19] = '' then
        Strings[19] := FormatDateTime('yyyy/mm/dd', Date);
    end
    else
      For i := 14 to 19 do
        Strings[i] := '';

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S428(RetNo: integer; FName: String; FNo: integer);
Var
  i, j, jj: integer;
  P, Q, R: integer;
  Rate: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 162, 163, 164);
    P := GetNumDays(RetNo, '01-07-2009', 'B');
    Q := GetNumDays(RetNo, '30-06-2009', 'A');
    R := Ret[RetNo].DaysInYear;
    Rate := (P / R) * 10 + (Q / R) * 20;
    i := 3;
    Tv[21] := 0;
    Repeat
      If (Strings[i - 2] = '') or (Strings[i - 1] = '') then
        Tv[i] := 0;
      Tv[i + 1] := Tv[i] * Rate / 100; // 10/100; 20100530
      Tv[i + 2] := MinR(Tv[i + 1], (P / R) * 2000 + (Q / R) * 4000);
      // MinR(Tv[i+1],2000);   //20100530
      Tv[21] := Tv[21] + Tv[i + 2];
      Inc(i, 5);
    until i > 18;

    i := 24;
    Tv[42] := 0;
    Repeat
      If (Strings[i - 2] = '') or (Strings[i - 1] = '') then
        Tv[i] := 0;
      Tv[i + 1] := Tv[i] * 15 / 100;
      Tv[i + 2] := MinR(Tv[i + 1], 2500);
      Tv[42] := Tv[42] + Tv[i + 2];
      Inc(i, 5);
    until i > 39;

    i := 45;
    Tv[63] := 0;
    Repeat
      If (Strings[i - 2] = '') or (Strings[i - 1] = '') then
        Tv[i] := 0;
      Tv[i + 1] := Tv[i] * 15 / 100;
      Tv[i + 2] := MinR(Tv[i + 1], 3000); // MinR(Tv[i+1],2500);
      Tv[63] := Tv[63] + Tv[i + 2];
      Inc(i, 5);
    until i > 60;

    i := 65;
    Tv[84] := 0; // i:=66;Tv[84]:=0;
    j := 161;
    jj := 177;
    Repeat
      If (Strings[i] = '') or (Strings[i - 1] = '') then
        Tv[i] := 0;
      // Tv[i+1]:=Tv[i] * 15/100;
      Tv[jj] := Tv[j] * 5.5 / 100;
      Tv[i + 3] := MinR(Tv[jj], 1000); // MinR(Tv[i+1]+Tv[jj],1000);  //20160709
      Tv[84] := Tv[84] + Tv[i + 3]; // Tv[84]+Tv[i+2];  //20160709
      Inc(i, 5);
      Inc(j, 5);
      Inc(jj, 5)
    until i > 80; // 20160709

    i := 87;
    Tv[105] := 0;
    Rate := (P / R) * 15 + (Q / R) * 30;
    Repeat
      If (Strings[i - 2] = '') or (Strings[i - 1] = '') then
        Tv[i] := 0;
      Tv[i + 1] := Tv[i] * Rate / 100; // 15/100; //20100530
      Tv[i + 2] := MinR(Tv[i + 1], (P / R) * 3000 + (Q / R) * 6000);
      // MinR(Tv[i+1],3000);
      Tv[105] := Tv[105] + Tv[i + 2];
      Inc(i, 5);
    until i > 102;

    i := 108;
    Tv[126] := 0;
    Repeat
      If (Strings[i - 2] = '') or (Strings[i - 1] = '') then
        Tv[i] := 0;
      Tv[i + 1] := Tv[i] * 22.5 / 100;
      Tv[i + 2] := MinR(Tv[i + 1], 3750);
      Tv[126] := Tv[126] + Tv[i + 2];
      Inc(i, 5);
    until i > 123;

    i := 129;
    Tv[147] := 0;
    Repeat
      If (Strings[i - 2] = '') or (Strings[i - 1] = '') then
        Tv[i] := 0;
      Tv[i + 1] := Tv[i] * 22.5 / 100;
      Tv[i + 2] := MinR(Tv[i + 1], 4500);
      Tv[147] := Tv[147] + Tv[i + 2];
      Inc(i, 5);
    until i > 144;

    Tv[148] := Tv[21];
    Tv[149] := Tv[42];
    Tv[150] := Tv[63];
    Tv[151] := Tv[149] + Tv[150];
    Tv[152] := Tv[151];

    Tv[153] := Tv[84];
    Tv[154] := Tv[105];
    Tv[155] := Tv[126];
    Tv[156] := Tv[147];
    Tv[157] := Tv[153] + Tv[154] + Tv[155] + Tv[156];
    Tv[158] := Tv[157];
    Tv[160] := Tv[148] + Tv[152] + Tv[158] + Tv[159];
  end;
  SaveTv(RetNo, FName, FNo);
end;
//20260903 Alex >>>
procedure S387(RetNo: Integer; FName: string; FNo: Integer);
var
  i, k: Integer;
  YEnd: string;
begin
  LoadTv(RetNo, FName, FNo);
  FillHeader(RetNo, FNo, 1, 2, 3);

  with Ret[RetNo].Frm[FNo] do
  begin
    if (Ret[RetNo].Province = 'MB') or (FetchElm(RetNo, 'S5', 297) > '') then // 20220705 // continue
    else
    begin
      for i:= 1 to 56 do
      begin
        Tv[i]:= 0;
        SaveTv(RetNo, FName, FNo);
      End;
      Exit;
    end;

    //Page 1
    Tv[5]:= Tv[7] + Tv[4]; //20260903 Alex
    Tv[17]:= MaxR(0, Tv[15] - Tv[16]);
    Tv[18]:= Tv[17];
    // 20220705
    Tv[20]:= MinR(225000, Tv[5]); //20260903 Alex //MinR(225000, Tv[7]);
    if GetTaxationYearEnd(RetNo) > '2021/04/06' then Tv[20]:= MinR(225000, Tv[5]);//20260903 Alex //MinR(225000, Tv[7]);

    Tv[21]:= Tv[18] + Tv[20];
    Tv[23]:= Tv[33];

    if UpperCase(Strings[8]) <> 'Y' then
    Begin
      Tv[22]:= MaxR(0, Tv[21] - Tv[23]);

      if (GetTaxationYearEnd(RetNo) > '2021/04/06') and (Tv[22] > 120000) then Tv[22]:= 120000;
      if Tv[22] > Vl(FetchElm(RetNo, 'S5', 712)) then Tv[22]:= Vl(FetchElm(RetNo, 'S5', 712)); // otherwise payable
    end;

    Tv[24]:= Tv[22] + Tv[23];
    Tv[25]:= Tv[24];
    Tv[26]:= MaxR(0, Tv[21] - Tv[25]);

    //Page 2
    i:= 27;
    k:= 1;
    YEnd:= GetTaxationYearEnd(RetNo);
    repeat
      if Strings[i] = '' then Strings[i]:= GetPrevYearEnd(YEnd, k);

      Inc(i, 2);
      Inc(k, 1);
    until i > 31;

    Tv[33]:= Tv[28] + Tv[30] + Tv[32];

    i:= 34;
    k:= 10;
    YEnd:= GetTaxationYearEnd(RetNo);
    repeat
      Strings[i]:= GetPrevYearEnd(YEnd, k);

      Inc(i, 2);
      Dec(k, 1);
    until i > 52;
    Strings[54]:= GetTaxationYearEnd(RetNo);

    Tv[56]:= AddColumns(35, 55, 2);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260903 Alex
Procedure S390(RetNo: integer; FName: String; FNo: integer);
Var
  i, k: integer;
  YEnd: String;
begin
  LoadTv(RetNo, FName, FNo);
  FillHeader(RetNo, FNo, 1, 2, 3);
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[20] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 1);
    Strings[21] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 2);
    Strings[22] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 3);

    i := 27;
    k := 10;
    YEnd := GetTaxationYearEnd(RetNo);
    Repeat
      If Strings[i] = '' then
        Strings[i] := GetPrevYearEnd(YEnd, k);
      Inc(i, 2);
      Dec(k, 1);
    until i > 45;

    // 20180512
    Tv[49] := 0;
    i := 28;
    Repeat
      Tv[49] := Tv[49] + Tv[i];
      Inc(i, 2);
    until i > 48;
    Strings[47] := GetTaxationYearEnd(RetNo);
    // pg 2
    Tv[26] := Tv[23] + Tv[24] + Tv[25];

    // pg1
    If Tv[8] > 750 then
      Tv[8] := 750;
    Tv[11] := MaxR(0, Tv[9] - Tv[10]);
    Tv[12] := Tv[11];
    Tv[13] := Tv[7];
    Tv[14] := Tv[12] + Tv[13];
    Tv[15] := MaxR(0, MinR(Tv[14], Vl(FetchElm(RetNo, 'S5', 720)))); // 20120512
    Tv[16] := Tv[26];
    Tv[17] := Tv[15] + Tv[16];
    Tv[18] := Tv[17];
    Tv[19] := MaxR(0, Tv[14] - Tv[18]);
  end;
  SaveTv(RetNo, FName, FNo);
end;

(* 20210516
  Procedure S391(RetNo: integer; FName: String;FNo: integer);
  Var i,k:Integer;YEnd:String;
  begin
  LoadTv(RetNo,FName,FNo);
  FillHeader(RetNo,FNo,1,2,3);
  with Ret[RetNo].Frm[FNo] do
  begin
  //Carry back
  Tv[26]:=Tv[23]+Tv[24]+Tv[25];

  Tv[5]:=Round(Tv[4]*30/100);
  Tv[7]:=Tv[5]+Tv[6];
  Tv[8]:=MinR(Tv[7],15000);

  Tv[11]:=MaxR(0,Tv[9]-Tv[10]);
  Tv[12]:=Tv[11];
  Tv[13]:=Tv[8];
  Tv[14]:=Tv[12]+Tv[13];

  If UpperCase(Strings[50]) <> 'Y' then Tv[15]:=Tv[14];  //20121209
  If Tv[15]>Tv[14] then Tv[15]:=Tv[14];
  If Tv[15]<0 then Tv[15]:=0;
  Tv[16]:=Tv[26];
  Tv[17]:=Tv[15]+Tv[16];
  Tv[18]:=Tv[17];
  Tv[19]:=MaxR(0,Tv[14]-Tv[18]);
  //prev years??
  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure S5I(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S32Assist(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  OverrideSw: Boolean;
  x: Real;
  TotCurrentRdExpenses: Real;
begin

  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If UpperCase(Strings[1]) = 'Y' then
      OverrideSw := True
    else
      OverrideSw := false;
    // ab
    If OverrideSw = false then
    begin
      (* Auto calc of credit made it usr entry  //20210713
        if FetchElm(RetNo,'AS9',101)>'' then  //if step 2
        Begin
        Tv[21]:=Vl(FetchElm(RetNo,'AS9',8)); //Vl(FetchElm(RetNo,'AS9',102));
        Tv[22]:=Vl(FetchElm(RetNo,'AS9',8)); //Vl(FetchElm(RetNo,'AS9',102));
        end;
      *)
      // 20210707
      // if Vl(FetchElm(RetNo,'AS9',102))>0 then  //any pass
      if FetchElm(RetNo, 'AS29', 146) > 'X' then // first step
      Begin
        // 20220710
        Tv[20] := Vl(FetchElm(RetNo, 'AS29', 29));
        Tv[19] := Tv[20];
      End
      Else
      Begin
        // 20220710
        Tv[20] := 0;
        Tv[19] := 0;
      End;

      x := Vl(FetchElm(RetNo, 'T661', 145)) + Vl(FetchElm(RetNo, 'T661', 146));
      If x > 0 then
        Tv[23] := Tv[21] * Vl(FetchElm(RetNo, 'T661', 146)) / x
      else
        Tv[23] := 0;
     // If Tv[23] > 0 then Tv[22] := MaxR(0, Vl(FetchElm(RetNo, 'AS9', 102)) - Tv[23]); //20231024
    end;

    // BC
    If OverrideSw = false then
    begin
      Tv[26] := Vl(FetchElm(RetNo, 'S425', 108)); // *10/100;
      Tv[25] := Tv[26]; // Vl(FetchElm(RetNo,'S425',108));
      // Tv[27]:=Vl(FetchElm(RetNo,'S425',23))*10/100;
    end;

    // MB
    If OverrideSw = false then
    begin
      Tv[30] := Vl(FetchElm(RetNo, 'S380', 10)) +
        Vl(FetchElm(RetNo, 'S380', 46));
      Tv[29] := Tv[30];
      // If Tv[31]>0 then Tv[30]:=MaxR(0,Vl(FetchElm(RetNo,'S380',10))+Vl(FetchElm(RetNo,'S380',46))-Tv[31]);
    end;

    // NB
    If OverrideSw = false then
    begin
      Tv[34] := Vl(FetchElm(RetNo, 'S360', 11));
      Tv[33] := Tv[34];
      // If Tv[35]>0 then Tv[34]:=MaxR(0,Vl(FetchElm(RetNo,'S360',102))-Tv[35]);
    end;

    // NL
    If OverrideSw = false then
    begin
      Tv[38] := Vl(FetchElm(RetNo, 'S301', 6));
      Tv[37] := Tv[38];
      // If Tv[39]>0 then Tv[38]:=MaxR(0,Vl(FetchElm(RetNo,'S301',6))-Tv[39]);
    end;

    // NS
    If OverrideSw = false then
    begin
      Tv[42] := Vl(FetchElm(RetNo, 'S340', 6));
      Tv[41] := Tv[42];
    end;

    // ON
    If OverrideSw = false then
    begin
      If IsAmalgamatedOntario(RetNo) then // 20100304
      begin
        // s566  Oitc
        Tv[80] := Vl(FetchElm(RetNo, 'S566', 179));
        // reduction to pool
        TotCurrentRdExpenses := Vl(FetchElm(RetNo, 'T661', 121));
        Tv[79] := Vl(FetchElm(RetNo, 'S566', 179));
        // 20170527 //TotCurrentRDExpenses * 10/100;

        // s568   obritc
        Tv[83] := Vl(FetchElm(RetNo, 'S568', 80));
        // Tv[82]:=Tv[83];  //20170527

        // s508 ORDTC
        Tv[77] := Vl(FetchElm(RetNo, 'S508', 30));
        Tv[76] := Vl(FetchElm(RetNo, 'S508', 33));
        // 20170527   //MaxR(0,TotCurrentRDExpenses-Tv[79]) * 4.5/100;
        // Tv[78]:=Tv[77];
      end;
    end;

    // SK
    If OverrideSw = false then
    begin
      Tv[66] := Vl(FetchElm(RetNo, 'S403', 17));
      Tv[65] := Tv[66];
    end;

    // YT
    If OverrideSw = false then
    begin
      Tv[70] := Vl(FetchElm(RetNo, 'S442', 6)) + Vl(FetchElm(RetNo, 'S442', 8));
      Tv[69] := Tv[70];
    end;

    if FetchElm(RetNo, 'AS29', 147) > '' then
      Tv[20] := 0
      // Vl(FetchElm(RetNo,'AS29',29)) //20210711 //step 2 add the IEG
    Else
      Tv[20] := 0;
    Tv[19] := Tv[20]; // 20210711

    Tv[5] := 0;
    Tv[6] := 0;

    i := 21;
    Repeat
      Tv[5] := Tv[5] + Tv[i];
      Tv[6] := Tv[6] + Tv[i + 1];
      Inc(i, 4);
    until i > 73;
    Tv[5] := Tv[5] + Tv[76] + Tv[79] + Tv[82] + Tv[19];
    // 20210711 added Alb [19]

    Tv[6] := Tv[6] + Tv[20]; // 20210711 include alb  credit
    Tv[6] := Tv[6] + Tv[80] + Tv[83] + Tv[77];

    Tv[5] := Tv[5] + Tv[2] + Tv[9] + Tv[12];
    Tv[6] := Tv[6] + Tv[3] + Tv[10] + Tv[13];
    // Tv[7]:=Tv[7]+Tv[4]+Tv[11]+Tv[14];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure BLimit(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  BegDate, EndDate: String;
  DaysInTheYear: integer;
begin
  LoadTv(RetNo, FName, FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    BegDate := Strings[2];
    EndDate := Strings[3];
    If EndDate < BegDate then
    begin
      for i := 4 to 10 do
        Tv[i] := 0;
      exit;
    End;
    // DaysInTheYear :=DateDiff(YYYYMMDDToMMDDYYYY(BegDate),YYYYMMDDToMMDDYYYY(EndDate));
    // If DaysInTheYear <= 0 then DaysInTheYear :=365;
    DaysInTheYear := DateDiffYMD(BegDate, EndDate); // 20150703
    If DaysInTheYear > 375 then
      DaysInTheYear := 375;
    If DaysInTheYear > 0 then
    begin
      Strings[4] := IntToStr(GetAnyNumDays(RetNo, BegDate, EndDate,
        '01-01-2009', 'B')); // 20150703

      Strings[5] := IntToStr(DaysInTheYear);
      Tv[6] := 400000 * (Vl(Strings[4])) / DaysInTheYear;

      Strings[7] := IntToStr(GetAnyNumDays(RetNo, BegDate, EndDate,
        '31-12-2008', 'A')); // 20150703
      Strings[8] := IntToStr(DaysInTheYear);
      Tv[9] := 500000 * (Vl(Strings[7])) / DaysInTheYear;

      Tv[10] := Tv[6] + Tv[9];
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
  //20170525
  Procedure S490(RetNo: integer; FName: String;FNo: integer);
  begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  FillHeader(RetNo,FNo,1,2,3);
  Tv[7]:=Tv[6];
  Tv[8]:=Tv[7] * 30/100;
  Tv[9]:=Tv[6];
  If UpperCase(Strings[17])='Y' then
  Tv[10]:=Tv[9]*20/100
  Else
  Tv[10]:=0;

  Tv[11]:=Tv[8]+Tv[10];
  Tv[12]:=MinR(Tv[5],Tv[11]);

  Tv[15]:=Tv[13] * Vl(Strings[14])/100;

  If Tv[15]>0 then Tv[16]:=Tv[15] else Tv[16]:=Tv[12];

  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure T1131(RetNo: integer; FName: String; FNo: integer);
Var
  FInst: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FInst := ExtractFormInst(FName);
    FillHeader(RetNo, FNo, 1, 2, 5);
    If Strings[3] = '' then
      Strings[3] := FetchElm(RetNo, 'T2', 743) + ' ' +
        FetchElm(RetNo, 'T2', 742);
    If Strings[4] = '' then
      Strings[4] := FetchElm(RetNo, 'T2', 755);
    If Strings[6] = '' then
      Strings[6] := FetchElm(RetNo, 'T2', 746);

    If Strings[10] > '' then
      Strings[10] := RemoveChar(Strings[10], '-'); // 20150422

    // If Strings[11]='' then Strings[12]:='';   //20101126
    If Strings[13] + Strings[14] = '' then
      Strings[14] := 'X';
    If Strings[15] + Strings[16] = '' then
      Strings[16] := 'X';
    If Strings[17] + Strings[18] = '' then
      Strings[18] := 'X';

    If Strings[19] + Strings[20] = '' then
      Strings[19] := 'X';
    If Strings[21] + Strings[22] = '' then
      Strings[22] := 'X';
    If Strings[23] + Strings[24] = '' then
      Strings[24] := 'X';
    If Strings[25] + Strings[26] = '' then
      Strings[26] := 'X';
    If Strings[27] + Strings[28] = '' then
      Strings[28] := 'X';

    Strings[31] := Strings[8]; // 20110428

    Tv[59] := MaxR(0, Tv[57] - Tv[58]);
    Tv[79] := Tv[59];
    Tv[60] := Round(Tv[79] * 60 / 100);
    Tv[62] := MaxR(0, Tv[60] - Tv[61]);

    Tv[80] := AddColumns(63, 68, 1); // 20110121
    Tv[69] := Tv[80];
    Tv[81] := Tv[69] + Tv[70];

    Tv[71] := Tv[61]; // 20150422
    Tv[82] := Tv[71] + Tv[75];
    Tv[83] := Tv[82];
    Tv[76] := MaxR(0, Tv[81] - Tv[83]);
    Tv[77] := MinR(Tv[62], Tv[76]);
    Tv[78] := Round(Tv[77] * 25 / 100);

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S429(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    // contact
    If Strings[6] = '' then
      Strings[6] := FetchElm(RetNo, 'T2', 743) + ' ' +
        FetchElm(RetNo, 'T2', 742);
    If Strings[5] = '' then
      Strings[5] := FetchElm(RetNo, 'T2', 755);
    If Strings[7] = '' then
      Strings[7] := FetchElm(RetNo, 'T2', 746);
    If Strings[12] + Strings[11] = '' then
      Strings[12] := 'X';

    If Strings[33] + Strings[34] = '' then
      Strings[34] := 'X';
    If Strings[19] + Strings[20] = '' then
      Strings[20] := 'X';
    If Strings[21] + Strings[22] = '' then
      Strings[22] := 'X';
    If Strings[23] + Strings[24] = '' then
      Strings[24] := 'X';
    If Strings[25] + Strings[26] = '' then
      Strings[26] := 'X';
    If Strings[27] + Strings[28] = '' then
      Strings[28] := 'X';
    If Strings[44] + Strings[45] = '' then
      Strings[45] := 'X';
    If Strings[40] + Strings[41] = '' then
      Strings[41] := 'X';
    If Strings[42] + Strings[43] = '' then
      Strings[43] := 'X';

    If Strings[15] + Strings[33] + Strings[19] + Strings[21] + Strings[23] +
      Strings[25] + Strings[27] + Strings[44] + Strings[40] + Strings[42] > ''
    then
    begin
      Tv[17] := 0;
      Tv[18] := 0;
      Tv[29] := 0;
      Tv[30] := 0;
      Tv[31] := 0;
      Tv[32] :=0;  //20250918
    end
    Else
    Begin
      Tv[29] := MaxR(0, Tv[17] - Tv[18]);
      Tv[9]:=MaxR(0,Tv[4]-Tv[8]);   //20250918
      Tv[10]:=Tv[29];
      Tv[31] := Tv[29] * 17.5 / 100;  //20231020

      TV[13]:=Tv[9];
      Tv[30]:=Tv[13]*25/100;
      Tv[32]:=Tv[31]+Tv[30];
    end;

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure AefDone(RetNo: integer; FName: String; FNo: integer);
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillAlbHeader(RetNo, FNo, 1, 2);
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure AMEND(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If IsAmendedReturn(RetNo) = false then
    begin
      For i := 11 to 71 do
        Strings[i] := '';
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20130831
Procedure S392(RetNo: integer; FName: String; FNo: integer); // 20221123
Var
  i, j: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    FillHeader(RetNo, FNo, 207, 233, 232); // 20160707
    If (Ret[RetNo].Province <> 'MB') and (Ret[RetNo].Province <> 'MJ') then
    // 20130608
    begin
      For i := 4 to 579 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end; // 20160508
      exit;
    end;

    Tv[204] := 0;
    Tv[205] := 0;
    For i := 219 to 222 do
      Tv[i] := 0; // init totals
    i := 7;
    Repeat
      Tv[204] := Tv[204] + Tv[i];
      Tv[205] := Tv[205] + Tv[i + 1];
      If Strings[i - 1] < '2013/07/01' then
      begin
        Tv[219] := Tv[219] + Tv[i];
        Tv[220] := Tv[220] + Tv[i + 1];
      end
      Else
      begin
        Tv[221] := Tv[221] + Tv[i];
        Tv[222] := Tv[222] + Tv[i + 1];
      end;

      Inc(i, 5);
    until i > 102;
    Tv[208] := Tv[219] + Tv[220];
    Tv[206] := Tv[221] + Tv[222];

    Tv[209] := 0;
    Tv[210] := 0;
    for i := 223 to 226 do
      Tv[i] := 0;
    i := 107;
    Repeat
      Tv[209] := Tv[209] + Tv[i];
      Tv[210] := Tv[210] + Tv[i + 1];
      If Strings[i - 1] < '2013/07/01' then
      begin
        Tv[223] := Tv[223] + Tv[i];
        Tv[224] := Tv[224] + Tv[i + 1];
      end
      Else
      begin
        Tv[225] := Tv[225] + Tv[i];
        Tv[226] := Tv[226] + Tv[i + 1];
      end;
      Inc(i, 5);
    until i > 202;

    // Tv[211]:=Tv[209];
    // Tv[212]:=Tv[210];
    Tv[213] := Tv[223] + Tv[224];
    Tv[227] := Tv[225] + Tv[226];
    // ------------------------------------
    // part 3
    Tv[214] := Tv[208];
    Tv[215] := Round(Tv[214] * 4 / 100);

    Tv[228] := Tv[206];
    Tv[229] := Round(Tv[228] * 4.5 / 100);

    Tv[216] := Tv[213];
    Tv[217] := Round(Tv[216] * 7 / 100);

    Tv[230] := Tv[227];
    Tv[231] := Round(Tv[230] * 8 / 100);
    Tv[218] := Tv[215] + Tv[229] + Tv[217] + Tv[231];

    // part 4
    Tv[334] := 0;
    Tv[335] := 0;
    i := 237;
    Repeat
      Tv[334] := Tv[334] + Tv[i];
      Tv[335] := Tv[335] + Tv[i + 1];
      Inc(i, 5);
    until i > 332;
    Tv[336] := Tv[334];
    Tv[337] := Tv[335];
    Tv[338] := Tv[336] + Tv[337];
    Tv[339] := Tv[338];
    Tv[341] := Round(Tv[339] * 8 / 100);

    // Part 5
    // Tv[341]:=Tv[218];
    // Tv[342]:=Tv[340];
    Tv[343] := Tv[341] + Tv[342];

    // Part 6  Data Procesing Centre //201160508
    Tv[410] := 0;
    i := 346; // see the significance below  for coding:  Tv[5+i] means the fifth column of each row
    Repeat
      // if Strings[i+1]='' then For j:=1 to 9 do begin Tv[347+j]:=0;end; //If no cca class in first column all other columns s/b erased
      Tv[5 + i] := Round(Tv[4 + i] * 2.67 / 100);
      // 5th column is fourth column Times 2.67% : easy/clear coding! thats why i starts from 346 not 347
      Tv[6 + i] := Tv[5 + i] * 3;
      Tv[8 + i] := MaxR(0, Tv[6 + i] - Tv[7 + i]);
      Tv[9 + i] := MinR(Tv[5 + i], Tv[8 + i]);
      Tv[410] := Tv[410] + Tv[9 + i];
      Inc(i, 9);
    until i + 1 > 401;

    // Part 6  Data Procesing Centre Building  //201160508

    Tv[495] := 0;
    i := 509; // see the significance below  for coding:  Tv[5+i] means the fifth column of each row
    Repeat
      // if Strings[i+1]='' then For j:=1 to 9 do begin Tv[510+j]:=0;end; //If no cca class in first column all other columns s/b erased
      if Tv[5 + i] > 0 then
        Tv[6 + i] := Round((Tv[4 + i] / Tv[5 + i]) * 4.5 / 100)
      Else
        Tv[6 + i] := 0;
      Tv[7 + i] := Round(Tv[4 + i] * 4.5 / 100);
      Tv[9 + i] := MaxR(0, Tv[7 + i] - Tv[8 + i]);
      Tv[10 + i] := MinR(Tv[6 + i], Tv[9 + i]);
      Tv[495] := Tv[495] + Tv[10 + i];
      Inc(i, 10);
    until i + 1 > 574;

    Tv[496] := Tv[410];
    Tv[497] := Tv[495];
    Tv[499] := Tv[496] + Tv[497] + Tv[498];

    // part 7
    Tv[500] := Tv[218];
    Tv[501] := Tv[343];
    Tv[502] := Tv[499];
    Tv[503] := Tv[500] + Tv[501] + Tv[502];

  End;
  SaveTv(RetNo, FName, FNo);
end;

(*
  Procedure S393(RetNo: integer; FName: String;FNo: integer);
  Var i:Integer;
  begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  FillHeader(RetNo,FNo,1,2,3);
  If (Ret[RetNo].Province <> 'MB') and (Ret[RetNo].Province <> 'MJ') then //20130608
  begin
  For i:=4 to 90 do begin Strings[i]:='';Tv[i]:=0;end;
  Exit;
  end;

  i:=7;
  Tv[90]:=0;
  Repeat
  Tv[90]:=Tv[90]+Tv[i];
  Inc(i,4);
  until i>83;
  Tv[84]:=Tv[90];
  Tv[87]:=Tv[84]+Tv[85]+Tv[86];
  Tv[88]:=Tv[87];
  Tv[89]:=Round(Tv[88]*10/100);
  End;
  SaveTv(RetNo,FName,FNo);
  end;
*)

Procedure S394(RetNo: integer; FName: String; FNo: integer); // 20140408
Var
  i, j, jj: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If (Ret[RetNo].Province <> 'MB') and (Ret[RetNo].Province <> 'MJ') then
    // 20130608
    begin
      For i := 4 to 157 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      exit;
    end;

    i := 5;
    Tv[155] := 0;
    Repeat
      Tv[i + 2] := Round(Tv[i] * 8 / 100);
      Tv[i + 3] := Round(MyStrToInt(Strings[i + 1]) * 12000);
      Tv[i + 4] := MinR(Tv[i + 2], Tv[i + 3]);
      Tv[155] := Tv[155] + Tv[i + 4];
      Inc(i, 6);
    until i > 59;

    // 20150415
    i := 65;
    j := 158;
    jj := 168;
    Tv[124] := 0;
    Repeat
      Tv[i + 2] := Round(Tv[i] * 8 / 100); // Round(Tv[i]*1.6/100);  //20150415
      Tv[i + 3] := Round(MyStrToInt(Strings[i + 1]) * 12000);
      // Round(MyStrToInt(Strings[i+1])*2400);  //20150415
      Tv[jj] := MinR(Tv[i + 2], Tv[i + 3]) / 60;
      Tv[i + 4] := Vl(Strings[j]) * Tv[jj];
      // MinR(Tv[i+2],Tv[i+3]);  //20140415
      Tv[124] := Tv[124] + Tv[i + 4];
      Inc(i, 6);
      Inc(j, 1);
      Inc(jj, 1);
    until i > 119;

    Tv[127] := MaxR(0, Tv[125] - Tv[126]);
    Tv[128] := Tv[127];
    Tv[130] := Tv[124] + Tv[128] + Tv[129];

    If UpperCase(Strings[156]) <> 'Y' then
      Tv[131] := Tv[130];
    Tv[132] := MaxR(0, Tv[130] - Tv[131]);

    i := 133;
    j := 10;
    Tv[157] := 0;
    jj := 134;
    Repeat
      Strings[i] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), j);
      Inc(i, 2);
      Inc(j, -1);
      Inc(jj, 2);
      Tv[157] := Tv[157] + Tv[jj];
    until i > 153;
  End;
  SaveTv(RetNo, FName, FNo);
end;

// 20191024
Procedure S430(RetNo: integer; FName: String; FNo: integer); // 20130505
Var
  i: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If (Ret[RetNo].Province <> 'BC') and (Ret[RetNo].Province <> 'MJ') then
    // 20130608
    begin
      For i := 4 to 167 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      exit;
    end;
    // part 1
    i := 7;
    Tv[162] := Tv[32]; // additional
    Repeat
      // 115           110
      Tv[i] := Round(Tv[i - 1] * 20 / 100);
      // Tv[i+2]:=MaxR(0,5250-Tv[i+1]);       //jz 2019 removed
      // If Strings[i-3]='' then Tv[i+2]:=0; //jz 2019 removed
      // 125           //115
      Tv[i + 3] := MinR(Tv[i], 5250); // MinR(Tv[i],Tv[i+2]); //jz 2019
      Tv[162] := Tv[162] + Tv[i + 3];

      Inc(i, 7);
    until i > 28;

    // part 2,a
    i := 36;
    Tv[163] := Tv[53]; // additional
    Repeat
      Tv[i] := Round(Tv[i - 1] * 20 / 100);
      Tv[i + 1] := MinR(5250, Tv[i]);
      Tv[163] := Tv[163] + Tv[i + 1];
      Inc(i, 5);
    until i > 51;

    // part 2,b
    i := 57;
    Tv[164] := Tv[74]; // additional
    Repeat
      Tv[i] := Round(Tv[i - 1] * 20 / 100);
      Tv[i + 1] := MinR(5250, Tv[i]);
      Tv[164] := Tv[164] + Tv[i + 1];
      Inc(i, 5);
    until i > 72;

    // part 3, a
    i := 78;
    Tv[165] := Tv[103]; // additional
    Repeat
      // 415        //410
      Tv[i] := Round(Tv[i - 1] * 30 / 100);
      // Tv[i+2]:=MaxR(0,7875-Tv[i+1]);      //jz 2019 removed
      // If Strings[i-3]='' then tv[i+2]:=0; //jz 2019 removed
      Tv[i + 3] := MinR(Tv[i], 7875); // MinR(Tv[i],Tv[i+2]); //jz 2019
      Tv[165] := Tv[165] + Tv[i + 3];
      Inc(i, 7);
    until i > 99;

    // part 3, b
    i := 108;
    Tv[166] := Tv[125]; // additional
    Repeat
      Tv[i] := Round(Tv[i - 1] * 30 / 100);
      Tv[i + 1] := MinR(7875, Tv[i]);
      Tv[166] := Tv[166] + Tv[i + 1];
      Inc(i, 5);
    until i > 123;

    // part 3, b
    i := 130;
    Tv[167] := Tv[147]; // additional
    Repeat
      Tv[i] := Round(Tv[i - 1] * 30 / 100);
      Tv[i + 1] := MinR(7875, Tv[i]);
      Tv[167] := Tv[167] + Tv[i + 1];
      Inc(i, 5);
    until i > 145;

    Tv[149] := Tv[162];
    Tv[150] := Tv[163];
    Tv[151] := Tv[164];
    Tv[152] := Tv[150] + Tv[151];
    Tv[153] := Tv[152];

    Tv[154] := Tv[165];
    Tv[155] := Tv[166];
    Tv[156] := Tv[167];
    Tv[157] := Tv[154] + Tv[155] + Tv[156];
    Tv[158] := Tv[157];

    Tv[161] := Tv[149] + Tv[153] + Tv[158] + Tv[160];
  End;
  SaveTv(RetNo, FName, FNo);
end;

// 20130505
Procedure EFConfirm(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  OnlineNo, Password, Url, NetFileDir, WacNumber: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Strings[2] := GetCorpBusNo(RetNo);

    Strings[4] := FetchElm(RetNo, 'T183CP', 21); // confirmation number
    Strings[5] := FetchElm(RetNo, 'STATUS', 28); // Timestamp  //20130622
    // 20130622
    If GetWacNumber(RetNo) > '' then
    begin
      Strings[7] := GetWacNumber(RetNo);
      Strings[6] := '';
    end
    Else
    Begin
      Strings[7] := '';
      Strings[6] := GetEfilerNo;
    end;

    If AllTrim(Strings[4]) = '' then
    begin
      For i := 4 to 7 do
        Strings[i] := '';
      SaveTv(RetNo, FName, FNo);
      exit;
    end;

    // the time stamo via Efle process
  End;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S88(RetNo: integer; FName: String; FNo: integer); // 20140401
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If Vl(Strings[10]) > 100 then
      Strings[10] := '100';
    If Vl(Strings[10]) = 0 then
      Strings[10] := '';
  End;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S367(RetNo: integer; FName: String; FNo: integer); // 20150328
Var
  i, k: integer;
  YEnd: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If Strings[8] = '' then
      Strings[8] := 'N';
    Strings[27] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 1);
    Strings[29] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 2);
    Strings[31] := GetPrevYearEnd(GetTaxationYearEnd(RetNo), 3);

    Tv[7] := MinR(75000, Tv[7]);
    Tv[17] := MaxR(0, Tv[15] - Tv[16]);
    Tv[18] := Tv[17];
    Tv[21] := Tv[7] + Tv[18];
    If Strings[8] <> 'Y' then
    Begin
      Tv[22] := MinR(75000, Tv[21]);
      Tv[22] := MinR(Tv[22], Vl(FetchElm(RetNo, 'S5', 553)));
      // 553 is invisible in S5, holding payable bfore this credit
    end;
    Tv[33] := Tv[28] + Tv[30] + Tv[32]; // carryback
    Tv[23] := Tv[33];
    Tv[24] := Tv[22] + Tv[23];
    Tv[25] := Tv[24];

    Tv[26] := MaxR(0, Tv[21] - Tv[25]);
    i := 40;
    k := 7;
    YEnd := GetTaxationYearEnd(RetNo);
    Tv[56] := 0;
    Repeat
      If Strings[i] = '' then
        Strings[i] := GetPrevYearEnd(YEnd, k);
      Tv[56] := Tv[56] + Tv[i + 1];
      Inc(i, 2);
      Dec(k, 1);
    until i > 54;

    Tv[56] := Tv[41] + Tv[43] + Tv[45] + Tv[47] + Tv[49] + Tv[51] +
      Tv[53] + Tv[55];
  End;
  SaveTv(RetNo, FName, FNo);
end;

// 20150813
Procedure S125(RetNo: integer; FName: String; FNo: integer); // 20150721
Var
  i: integer;
  ArrayNo, Elm: integer;
  x, Y: Real;
  FInst: String;
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Strings[6] := PaddZero(AllTrim(MidStr(FInst, 2, 3)), 2); // 20160619
    // 20150813 guess what should happen
    // revenue
    ArrayNo := 1;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    Strings[10] := '8089'; // tot sales
    Strings[13] := '8299'; // tot revenue
    Tv[11] := SumOfColumn(RetNo, FNo, Elm);
    Tv[12] := SumOfColumn(RetNo, FNo, Elm + 1);

    // other income
    ArrayNo := 2;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    x := SumOfColumn(RetNo, FNo, Elm);
    Y := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[14] := Tv[11] + x;
    Tv[15] := Tv[12] + Y;

    // cost of sales
    ArrayNo := 3;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    Strings[16] := '8518';
    Strings[19] := '8519';

    // 20160503
    i := Elm;
    if not SplitDynId(RetNo, FNo, Elm) then
      // not dynamic so do nothing
    Else
    Begin
      with RetList[RetNo].Frm[FNo] do
        while i <= MaxElm + ArrayNo * 10000 do
        begin
          If (Strings[i - 1] >= '8500') and (Strings[i - 1] <= '8503') then
          // closing inventories
          Begin
            If Vl(Strings[i]) > 0 then
            begin
              If LeftStr(Strings[i], 1) <> '-' then
                Strings[i] := '-' + Strings[i];
            end;
            If Vl(Strings[i + 1]) > 0 then
            Begin
              If LeftStr(Strings[i + 1], 1) <> '-' then
                Strings[i + 1] := '-' + Strings[i + 1];
            end;
          End;
          Inc(i, BoxesPerRow);
        end;
    End;

    Tv[17] := SumOfColumn(RetNo, FNo, Elm); // cost of sales
    Tv[18] := SumOfColumn(RetNo, FNo, Elm + 1); // last yr
    Tv[20] := Tv[11] - Tv[17]; // gross profit
    Tv[21] := Tv[12] - Tv[18]; // gross profit lat yr

    // oper expenses
    ArrayNo := 4;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    Strings[25] := '9367';
    Strings[22] := '9368';
    Strings[88] := '9369';
    Tv[26] := SumOfColumn(RetNo, FNo, Elm) + Tv[86];
    // oper expenses + SalDiv adjustment //20200816

    // Tv[26]:=SumOfColumn(RetNo,FNo,Elm);     //oper expenses
    Tv[27] := SumOfColumn(RetNo, FNo, Elm + 1); // last yr
    Tv[23] := Tv[17] + Tv[26]; // tot expenses
    Tv[24] := Tv[18] + Tv[27]; // last yr
    Tv[89] := Tv[14] - Tv[23];
    Tv[90] := Tv[15] - Tv[24];

    // Farming
    ArrayNo := 5;
    Elm := ArrayNo * 10000 + 3;
    Strings[28] := '9659';
    Tv[29] := SumOfColumn(RetNo, FNo, Elm);
    Tv[30] := SumOfColumn(RetNo, FNo, Elm + 1);

    ArrayNo := 6;
    Elm := ArrayNo * 10000 + 3;
    Strings[31] := '9898';
    Strings[34] := '9899';
    Strings[37] := '9970';
    Tv[32] := SumOfColumn(RetNo, FNo, Elm);
    Tv[33] := SumOfColumn(RetNo, FNo, Elm + 1); // last yr
    Tv[35] := Tv[29] - Tv[32]; // 20160501
    Tv[36] := Tv[30] - Tv[33]; // 20160501
    Tv[38] := Tv[89] + Tv[35]; // net farm inc
    Tv[39] := Tv[90] + Tv[36]; // last yr

    // other comprehensive
    Strings[40] := '7000';
    Strings[43] := '7002';
    Strings[46] := '7004';
    Strings[49] := '7006';
    Strings[52] := '7008';
    Strings[55] := '7010';
    Strings[58] := '7020';
    Strings[61] := '';

    Tv[62] := 0;
    Tv[63] := 0;
    Elm := 41;
    Repeat
      Tv[62] := Tv[62] + Tv[Elm];
      Tv[63] := Tv[63] + Tv[Elm + 1];
      Inc(Elm, 3);
    until Elm > 59;

    // Summary
    Strings[64] := '9975';
    Strings[67] := '9976';
    Strings[70] := '9980';
    Strings[73] := '9985';
    Strings[76] := '9990';
    Strings[79] := '9995';
    Strings[82] := '9998';
    Strings[7] := '9999';

    Tv[8] := 0;
    Tv[9] := 0;
    Tv[83] := Tv[62];
    Tv[84] := Tv[63];

    Tv[8] := Tv[38] - Tv[65] - Tv[68] + Tv[71] - Tv[74] - Tv[77] -
      Tv[80] + Tv[83];

    Tv[9] := Tv[39] - Tv[66] - Tv[69] + Tv[72] - Tv[75] - Tv[78] -
      Tv[81] + Tv[84];

    // 20160712
    Strings[85] := '';
    If OptRec.Prn_Disclm > '' then
      Strings[85] := OptRec.Prn_Disclm;

    (*
      if CountMultipleInstances(RetNo,'S125')>1 then  //20160506
      // if CountS125IncStatements(RetNo)>1 then
      Begin
      i:=65;
      Repeat
      Tv[i]:=0;
      Tv[i+1]:=0;
      Inc(i,3);
      until i>83;
      Tv[8]:=0;
      Tv[9]:=0;
      End;
    *)
  End;
  SaveTv(RetNo, FName, FNo);

  if (CountMultipleInstances(RetNo, 'S125') > 1) then // 20160506
  Begin
    Calc(RetNo, 'S140', GetFormNo('S140'));
  End;

end;

// 20150816
Procedure S100(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  ArrayNo, Elm: integer;
  x, Y: Real;
  FInst: String;
begin
  S100CommonCalc(RetNo, FName, FNo);
end;

Procedure S101(RetNo: integer; FName: String; FNo: integer);
Var
  Page1FNo: integer;
  ArrayNo, Elm: integer;
  x, Y: Real;
  FInst: String;
begin
  // 20160515
  Page1FNo := GetFormNo('T2');
  If ((FetchElmFNo(RetNo, Page1FNo, 28) > '') or (FetchElmFNo(RetNo, Page1FNo,
    30) > '') or (FetchElmFNo(RetNo, Page1FNo, 36) > '')) // ??
  then
    S100CommonCalc(RetNo, FName, FNo)
end;

// 20150816
Procedure S100CommonCalc(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  ArrayNo, Elm: integer;
  x, Y: Real;
  FInst: String;
  TotTangible, TotIntangible, TotTangibleAmortization, TotIntangibleAmortization
    : Real; // 20160428  keep track of Tangible and the amortization
  TotTangiblePrior, TotIntangiblePrior, TotTangibleAmortizationPrior,
    TotIntangibleAmortizationPrior: Real; // 20160520
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    {
      if FInst='#1' then
      Strings[16]:='GIFI - Closing Balance Sheet'
      Else if FInst='#2' then
      Strings[16]:='GIFI - Opening Balance Sheet'
      Else
      Strings[16]:='Do not complete Balance Sheet '+FInst;
    }
    // Curr Assets
    ArrayNo := 1;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    // it could also be elm:=10003 unless we need later the arrayno but even arrayno becomes available after splitDynId  //20150824
    Strings[10] := '1599'; // tot curr ass
    Tv[11] := SumOfColumn(RetNo, FNo, Elm);
    Tv[12] := SumOfColumn(RetNo, FNo, Elm + 1);

    // tangible
    // 20160428  keep track of Tangible and the amortization
    TotTangible := 0;
    TotIntangible := 0;
    TotTangibleAmortization := 0;
    TotIntangibleAmortization := 0;
    // 20160428  keep track of Tangible and the amortization

    TotTangiblePrior := 0;
    TotIntangiblePrior := 0;
    TotTangibleAmortizationPrior := 0;
    TotIntangibleAmortizationPrior := 0;
    // 20160428  keep track of Tangible and the amortization

    ArrayNo := 2;
    Strings[13] := '2008'; // tot tang ass
    Strings[16] := '2009'; // tot amortization
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form

    // 20150818
    i := Elm;
    if not SplitDynId(RetNo, FNo, Elm) then
      // not dynamic so do nothing
    Else
    Begin
      with RetList[RetNo].Frm[FNo] do
        while i <= MaxElm + ArrayNo * 10000 do
        begin
          // 20160428
          If Vl(Strings[i]) >= 0 then
            TotTangible := TotTangible + Vl(Strings[i])
          Else
            TotTangibleAmortization := TotTangibleAmortization + Vl(Strings[i]);

          // 20160520  Prior
          If Vl(Strings[i + 1]) >= 0 then
            TotTangiblePrior := TotTangiblePrior + Vl(Strings[i + 1])
          Else
            TotTangibleAmortizationPrior := TotTangibleAmortizationPrior +
              Vl(Strings[i + 1]);

          If S100LineShouldBeNegative(Strings[i - 1], Strings[i]) then
            Strings[i] := '-' + Strings[i];
          If S100LineShouldBeNegative(Strings[i - 1], Strings[i + 1]) then
            Strings[i + 1] := '-' + Strings[i + 1];
          Inc(i, BoxesPerRow);
        end;
    End;
    // 20160428
    Tv[14] := TotTangible; // SumOfColumn(RetNo,FNo,Elm);
    Tv[17] := TotTangibleAmortization; // SumOfColumn(RetNo,FNo,Elm);
    // Tv[15]:=SumOfColumn(RetNo,FNo,Elm+1);
    Tv[15] := TotTangiblePrior;
    Tv[18] := TotTangibleAmortizationPrior; // SumOfColumn(RetNo,FNo,Elm);

    // Intangible
    ArrayNo := 3;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    Strings[19] := '2178';
    Strings[25] := '2179'; // 20160428
    // 20150818
    i := Elm;
    if not SplitDynId(RetNo, FNo, Elm) then
      // not dynamic so do nothing
    Else
    Begin
      with RetList[RetNo].Frm[FNo] do
        while i <= MaxElm + ArrayNo * 10000 do
        begin
          // 20160428
          If Vl(Strings[i]) >= 0 then
            TotIntangible := TotIntangible + Vl(Strings[i])
          Else
            TotIntangibleAmortization := TotIntangibleAmortization +
              Vl(Strings[i]);

          // 20160521
          If Vl(Strings[i + 1]) >= 0 then
            TotIntangiblePrior := TotIntangiblePrior + Vl(Strings[i + 1])
          Else
            TotIntangibleAmortizationPrior := TotIntangibleAmortizationPrior +
              Vl(Strings[i + 1]);

          If S100LineShouldBeNegative(Strings[i - 1], Strings[i]) then
            Strings[i] := '-' + Strings[i];
          If S100LineShouldBeNegative(Strings[i - 1], Strings[i + 1]) then
            Strings[i + 1] := '-' + Strings[i + 1];
          Inc(i, BoxesPerRow);
        end;
    End;

    Tv[20] := TotIntangible; // SumOfColumn(RetNo,FNo,Elm);     //20160428
    // Tv[21]:=SumOfColumn(RetNo,FNo,Elm+1);   //last yr
    Tv[26] := TotIntangibleAmortization;
    // SumOfColumn(RetNo,FNo,Elm);     //20160428
    // 20160521
    Tv[21] := TotIntangiblePrior;
    Tv[27] := TotIntangibleAmortizationPrior;

    // Long term
    ArrayNo := 4;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    Strings[22] := '2589';
    // 20160311 Igor >>>>
    i := Elm;
    if not SplitDynId(RetNo, FNo, Elm) then
      // not dynamic so do nothing
    Else
    Begin
      with RetList[RetNo].Frm[FNo] do
        while i <= MaxElm + ArrayNo * 10000 do
        begin
          If S100LineShouldBeNegative(Strings[i - 1], Strings[i]) then
            Strings[i] := '-' + Strings[i];
          If S100LineShouldBeNegative(Strings[i - 1], Strings[i + 1]) then
            Strings[i + 1] := '-' + Strings[i + 1];
          Inc(i, BoxesPerRow);
        end;
    End;

    Tv[23] := SumOfColumn(RetNo, FNo, Elm); // cost of sales
    Tv[24] := SumOfColumn(RetNo, FNo, Elm + 1); // last yr

    Strings[46] := '2590';

    // 20160311 Igor <<<<<
    Strings[88] := '2599';
    Tv[89] := Tv[11] + Tv[14] + Tv[17] + Tv[20] + Tv[26] + Tv[23] + Tv[47];
    // tot assets      //20160501
    Tv[90] := Tv[12] + Tv[15] + Tv[18] + Tv[21] + Tv[27] + Tv[24] + Tv[48];
    // 20160501

    // Liabilities
    ArrayNo := 5;
    Elm := ArrayNo * 10000 + 3;
    Strings[31] := '3139';
    Tv[32] := SumOfColumn(RetNo, FNo, Elm);
    Tv[33] := SumOfColumn(RetNo, FNo, Elm + 1);

    ArrayNo := 6;
    Elm := ArrayNo * 10000 + 3;
    Strings[4] := '3450';
    Strings[7] := '3499';
    Strings[56] := '3470'; // 20160501
    Tv[5] := SumOfColumn(RetNo, FNo, Elm);
    Tv[6] := SumOfColumn(RetNo, FNo, Elm + 1); // last yr
    Tv[8] := Tv[32] + Tv[5] + Tv[57]; // tot liab   //20160501
    Tv[9] := Tv[33] + Tv[6] + Tv[58]; // last yr            //20160501

    { relocate below  //20160503
      //Equity
      ArrayNo:=7;
      Elm:=ArrayNo*10000+3;
      Strings[28]:= '3500';
      Strings[34]:= '3600';
      Strings[37]:= '3620';
      Strings[40]:= '3640';

      Tv[35]:=Tv[54];  //2015020
      Tv[36]:=Tv[55];  //2015020

      Tv[38]:=Tv[29]+SumOfColumn(RetNo,FNo,Elm)+Tv[35];
      Tv[39]:=Tv[30]+SumOfColumn(RetNo,FNo,Elm+1)+Tv[36];
      Tv[41]:=Tv[8]+Tv[38];  //20160503
      Tv[42]:=Tv[9]+Tv[39];  //20160503
    }
    // --------------

    // retained earnings
    ArrayNo := 8;
    Elm := ArrayNo * 10000 + 3;
    Strings[43] := '3660';
    Strings[50] := '3680';
    Strings[53] := '3849';

    // 20150818
    i := Elm;
    if not SplitDynId(RetNo, FNo, Elm) then
      // not dynamic so do nothing
    Else
    Begin
      with RetList[RetNo].Frm[FNo] do
        while i <= MaxElm + ArrayNo * 10000 do
        begin
          If S100LineShouldBeNegative(Strings[i - 1], Strings[i]) then
            Strings[i] := '-' + Strings[i];
          If S100LineShouldBeNegative(Strings[i - 1], Strings[i + 1]) then
            Strings[i + 1] := '-' + Strings[i + 1];
          Inc(i, BoxesPerRow);
        end;
    End;
    // Line 3680  //20150822
    // Finst = '#1' then  {Net inc only in closing BS}
    if FName = 'S100' then { Net inc only in closing BS }
    begin
      // 20160506
      if CountMultipleInstances(RetNo, 'S125') > 1 then // 20160506
        Tv[51] := Vl(FetchElm(RetNo, 'S140', 25))
      Else
      Begin
        // 3680:=9999 [8]  +- 9998 [83]compreh
        If TotMultiple(RetNo, 'S125', 83) < 0 then
          Tv[51] := Vl(FetchElm(RetNo, 'S125#1', 8)) -
            Vl(FetchElm(RetNo, 'S125#1', 83))
        Else
          Tv[51] := TotMultiple(RetNo, 'S125', 8) +
            TotMultiple(RetNo, 'S125', 83);
        // original Tv[51]:=TotMultiple(RetNo,'S125',8)+TotMultiple(RetNo,'S125',83); ////not balancing
      end;
    end
    else
    Begin
      Tv[51] := 0;
      Tv[52] := 0;
    end;

    Tv[54] := Round(Tv[44] + Tv[51] + SumOfColumn(RetNo, FNo, Elm));
    // 20160722 use round CON
    // Tv[55]:=Tv[45]+Tv[52]+SumOfColumn(RetNo,FNo,Elm+1);  //20160521 tot r/e 3849

    Tv[62] := 0;
    Tv[63] := 0;
    Elm := 41;
    Repeat
      Tv[62] := Tv[62] + Tv[Elm];
      Tv[63] := Tv[63] + Tv[Elm + 1];
      Inc(Elm, 3);
    until Elm > 59;

    // 20160503
    // Equity
    ArrayNo := 7;
    Elm := ArrayNo * 10000 + 3;
    Strings[28] := '3500';
    Strings[34] := '3600';
    Strings[37] := '3620';
    Strings[40] := '3640';

    Tv[35] := Tv[54]; // 2015020
    Tv[36] := Tv[55]; // 2015020

    Tv[38] := Tv[29] + SumOfColumn(RetNo, FNo, Elm) + Tv[35];
    // Tv[39]:=Tv[30]+SumOfColumn(RetNo,FNo,Elm+1)+Tv[36];  //20160521
    Tv[41] := Tv[8] + Tv[38]; // 20160503
    // Tv[42]:=Tv[9]+Tv[39];  //20160503  //20160521

    // 20160712
    Strings[49] := '';
    If OptRec.Prn_Disclm > '' then
      Strings[49] := OptRec.Prn_Disclm;
  End;
  SaveTv(RetNo, FName, FNo);
end;

// 20160424
Procedure S309(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    i := 5;
    Tv[64] := 0;
    Repeat
      Tv[64] := Tv[64] + Tv[i];
      Inc(i, 2);
    until i > 63;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20160424
Procedure S348(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    i := 5;
    Tv[64] := 0;
    Repeat
      Tv[64] := Tv[64] + Tv[i];
      Inc(i, 2);
    until i > 63;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20160630
Procedure EMAILINFO(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    // 20180116
    if UpperCase(Strings[7]) = 'Y' then
     Strings[6] := FetchElm(RetNo, 'T183CP', 18)
    Else
     Strings[6]:='';    //202402
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure TESTFRM(RetNo: integer; FName: String; FNo: integer);
Var
  i: integer;
  FlName, Dir: String;
  SinNo: String;
  T1Refund, T2Refund: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    // INITIALIZE SOME DATA on the form
    // T2 section
    Strings[1] := FetchElm(RetNo, 'T2', 1);
    Strings[2] := FetchElm(RetNo, 'T2', 3);
    Tv[3] := Vl(FetchElm(RetNo, 'TAXSUM', 93));
    Tv[4] := Vl(FetchElm(RetNo, 'T2', 730));

    // IGOR TO COMPLETE THE FOLLOWING
    // T1 section
    // Upon opening form
    // String[6]:=  get the T1 Data folder from the T1 OptRec.Cur+Dir
    // User enters a T1 file name such as 11111111.8.  If it does not exist issue not found
    // user clicks Open T1 return which opens it with T1RetNo
    // Then Strings[8]:=GetFirstName(T1RetNo)
    // Then Strings[9]:=GetLastName(T1RetNo)

    // User enters 10000 on the Enter Salary box
    // and USER CLICKS CALCULATE BUTTON
    // Now use the T1 calculation engine and get some amount into the current form
    // T1 Calculation:
    // Program stores the salary on the T4#1 slip
    // StoreElm(T1RetNo,'T4#1',2);
    // Program iusues a CalcFullReturn(T1RetNo)
    // after Recalc, bring the T1 final figure into the T2 Form
    // Get the T1 refund amount
    // T1Refund:= Vl(FetchElm(RetNo,'T1',429));

    // progrm now switches to T2
    // Program stores the salary into the T2 GIFI CODE 9060 of S125
    // StoreElm(RetNo,'S125#1', GifiLineToElm(RetNo, GetFormNo('S125#1','89060');
    // program calls Recalc routines
    // CalcFed(RetNo);
    // CalcAlb(RetNo);
    // after therecalcs, bring the refund/balance due to the TESTFRM form
    // T2Refund:=Vl(FetchElm(RetNo,'T2',730))
    // back to testfrm calculation
    // Tv[4]:=T2Refund;

    // Tv[11]:=T1Refund;  //20170722 Igor

    Tv[34] := Tv[4] + Tv[11];
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure SbdAlloc(RetNo: integer; FName: String; FNo: integer);
// 20200727  FORM
Var
  i, j, k, RNo: integer;
  BnFromT2Table: String;
  S7FNo: integer;
  SbdAllocFNo: integer;
Begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    i := 272;
    Repeat
      If Strings[i] = '' then
        Strings[i] := FetchElmFNo(RetNo, T2FNo, i);
      If Tv[i + 1] = 0 then
        Tv[i + 1] := Vl(FetchElmFNo(RetNo, T2FNo, i + 1));
      // Tv[i+2]:=Vl(FetchElmFNo(RetNo,T2FNo,i+2));  //assignment
      // if Tv[i+2]>Tv[i+1] then Tv[i+2]:=Tv[i+1];
      Inc(i, 4);
    Until i > 304;

    if Strings[321] + Strings[322] + Strings[323] + Strings[324] = '' then
      Strings[321] := 'X';
    If Tv[362] > 100 then
      Tv[362] := 100;
    if (Strings[322] > '') and (Tv[362] = 0) then
      Tv[362] := 50;

    If Strings[321] > '' then
    Begin
      i := 274;
      Repeat
        Tv[i] := 0;
        Inc(i, 4);
      until i > 306;
    End;

    If Strings[322] > '' then
    Begin
      i := 274;
      Repeat
        Tv[i] := Round(Tv[i - 1] * Tv[362] / 100);
        Inc(i, 4);
      until i > 306;
    End;

    If Strings[323] > '' then
    Begin
      i := 274;
      Repeat
        Tv[i] := Tv[i - 1];
        Inc(i, 4);
      until i > 306;
    End;
    // add the tax payable
    if Ret[RetNo].Ln[510] > 0 then
      Strings[311] := FetchElmFNo(RetNo, T2FNo, 3) // main corp name
    Else
      Strings[311] := '';

    // 20200728------- Totals to be popoluted after tax returns are calce;
    Tv[86] := 0; // total income paid
    Tv[87] := 0; // toal assigment

    i := 272;
    Repeat
      if Strings[i] = '' then
      begin
        Strings[i + 1] := '';
        Tv[i + 2] := 0;
      end; // Tv[i+3]:=0;end;
      Tv[86] := Tv[86] + Tv[i + 1];
      Tv[87] := Tv[87] + Tv[i + 2];
      Inc(i, 4);
    until i > 304;

    // 20200805 Igor >>>
    Tv[361] := 0; // Total Tax Payable
    Tv[373] := 0; // Total Refund/due
    i := 352;
    repeat
      Tv[361] := Tv[361] + Tv[i];
      Tv[373] := Tv[373] + Tv[i + 12];
      Inc(i);
    until i > 360;
    // 20200805 Igor <<<
  end;
  SaveTv(RetNo, FName, FNo);

  // Put assignments back on the T2
  i := 273;
  Repeat
    StoreElm(RetNo, T2FNo, i, FormatFloat('#######', Ret[RetNo].Frm[FNo].Tv[i]));
    // income(if changed?);
    StoreElm(RetNo, T2FNo, i + 1, FormatFloat('#######', Ret[RetNo].Frm[FNo].Tv[i + 1]));
    // assigned
    Inc(i, 4);
  Until i > 306;
End;

// 20200726
Procedure CalcAllSbdAllocCompanies(RetNo: integer);
Var
  RNo, i, j, SbdAllocFNo: integer;
  BnFromT2Table: String;
  FlName: String;
  FlExt: String;
  FAllocFNo: integer;
  TotPayable, TotRefDue: Real;
Begin
  SbdAllocFNo := GetFormNo('SBDALLOC');
  CalcAll(RetNo); // 20200728
  StoreElm(RetNo, SbdAllocFNo, 351, FormatFloat('#########',
    Ret[RetNo].Ln[770])); // tax
  StoreElm(RetNo, SbdAllocFNo, 363, FetchElmFNo(RetNo, T2FNo, 730)); // refund

  // Open the related returns, and then prepare S7 with the SBD assignment
  FlExt := MidStr(GetTaxationYearEnd(RetNo), 3, 2); // as main retno
  i := 272; // pointer to the various ralated BNumbers in T2
  Repeat
    BnFromT2Table := FetchElmFNo(RetNo, T2FNo, i);
    FlName := LeftStr(BnFromT2Table, 9) + '.' + FlExt;
    RNo := GetRetNoFromBN(BnFromT2Table);
    If BnFromT2Table > '' then
    Begin
      if (RNo = 0) then
      Begin
        RNo := OpenReturn(OptRec.Dir_cur, FlName, True);
        if RNo > 0 then
        begin
          // Busy;  //LockWindowUpdate(Application.MainForm.Handle);
          // CountDiagnostics(RNo);
          try
            OpenForm(RNo, 'T2', 321); // to update the returns list
            // OpenForm(RNo,'S7',293);   // OpenUsedForms(RNo); //does LockWindowUpdate tto much
            MainForm.GuiCommand(gcReturns);
            MainForm.GuiCommand(gcShowLeftPanel);
            // MainForm.LeftPanel.Visible:=True; //20160222 Igor
            OpenForm(RNo, 'SBDAlloc', 321);
          finally; // vtChild.CreateNewMDIChild(RNo, '').ShowAllControls;
          End;
        End;
      end;

      if (RNo > 0) then
      Begin
        (* causes problems : misses rows
          j:=352;  //clear previous tax and refunds in SbdAlloc form
          Repeat
          StoreElm(RetNo,SbdAllocFNo,j,'');
          StoreElm(RetNo,SbdAllocFNo,j,'');
          Inc(j,1);
          Until j>360;
        *)
        PopulateS7SBDAlloc(RetNo, RNo);
      End
      Else
        ShowMessage('Cannot open this return:' + OptRec.Dir_cur + '\' + FlName);
    end;
    Inc(i, 4);
  Until i > 304;

  LoadTv(RetNo,'SBDAlloc',SbdAllocFNo);
  with Ret[RetNo].Frm[SbdAllocFNo] do
  begin
    // 20200728  //PROBLEM: Totals ELM 361 and 373 do not show on the SBDAlloc
    Tv[361] := 0;
    for j := 351 to 360 do
    begin
      Tv[361] := Tv[361] + Vl(FetchElmFNo(RetNo, SbdAllocFNo, j));
    end; // payable
    StoreElm(RetNo, SbdAllocFNo, 361, FetchElmFNo(RetNo, SbdAllocFNo, 361));
    Tv[373] := 0;
    for j := 363 to 372 do
    begin
      Tv[373] := Tv[373] + Vl(FetchElmFNo(RetNo, SbdAllocFNo, j));
    end; // Tot RefDue
  end;
  SaveTv(RetNo,'SBDAlloc',SbdAllocFNo);
  StoreElm(RetNo, SbdAllocFNo, 373, FetchElmFNo(RetNo, SbdAllocFNo, 373));

  OpenForm(RetNo, 'SBDALLOC', 321); // main Corp
End;

Procedure PopulateS7SBDAlloc(RetNo: integer; RNo: integer); // 20200727  //new
// calculates the related companies
Var
  i, j, k, K1, K2, K3, SbdAllocFNo: integer;
  BnFromT2Table, LoadedBn: String;
  TaxPayable, RefundDue: Real;
  Assignment: String;
  S7FNo: integer;
Begin
  S7FNo := GetFormNo('S7');
  SbdAllocFNo := GetFormNo('SBDALLOC');
  i := 272;
  k := 312; // pointer to the various ralated B Names in T2
  K1 := 352; // pointer to T2 Payable
  // K2:=293; //pointer to the first row of S7 BN
  K3 := 364; // pointer to T2 Refund/Due line
  repeat
    BnFromT2Table := FetchElmFNo(RetNo, T2FNo, i);
    if BnFromT2Table = FetchElmFNo(RNo, T2FNo, 1) then // found in retlist
    Begin
      // populate S7 from T2
      StoreElm(RNo, S7FNo, 293, FetchElmFNo(RetNo, T2FNo, 1));
      // bn of receiving main corp
      // 20200728
      StoreElm(RNo, S7FNo, 298, FetchElmFNo(RetNo, SbdAllocFNo, i + 1));
      // income to receiving corp
      Assignment := FetchElmFNo(RetNo, SbdAllocFNo, i + 2); // assignment

      StoreElm(RNo, S7FNo, 303, Assignment);
      StoreElm(RetNo, SbdAllocFNo, k, FetchElm(RNo, T2FNo, 3)); // Bus Name
      CalcAll(RNo); // specific return  //20200728

      TaxPayable := Ret[RNo].Ln[770];
      RefundDue := Vl(FetchElmFNo(RNo, T2FNo, 730));
      StoreElm(RetNo, SbdAllocFNo, K1, FormatFloat('#########', TaxPayable));
      StoreElm(RetNo, SbdAllocFNo, K3, FormatFloat('#########', RefundDue));
      // put assigment back to T2
      StoreElm(RetNo, T2FNo, i + 2, Assignment);
      exit;
    End;
    Inc(i, 4);
    Inc(k, 1);
    Inc(K1, 1);
    Inc(K3, 1);
  Until i > 304;
End;

(*
  // 20190628
  procedure CalcSalDiv(T2RetNo:Integer);
  var I: integer;
  T1RetNo:Integer;
  T1App: TApp;
  V: Real;
  FNo,SalDivFNo:Integer;
  FlName: string; Salary,Dividends: Real;
  T1beforeSalDiv, T1afterSalDiv, T2beforeSalDiv, T2afterSalDiv: Real;

  Sin,CalcBox:String;
  SinNdx,SalNdx,DivNdx, CalcBoxNdx:Integer;
  begin
  //
  End;
*)

Procedure S59(RetNo: integer; FName: String; FNo: integer); // 20220508
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
  end;
  SaveTv(RetNo, FName, FNo);
end;

(* removed //20260526
// 20220914
Procedure S65(RetNo: integer; FName: String; FNo: integer); // 20220508
Var
  i: integer;
  x: Real;
  Affiliated: Boolean;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Affiliated := false;
    If UpperCase(Strings[23]) = 'Y' then
      Affiliated := True;

    // part 1 and 2
    if Ret[RetNo].CorpType = CCPC then
    begin
      Strings[4] := 'X';
      Strings[5] := '';
    end
    else
    begin
      Strings[4] := '';
      Strings[5] := 'X'
    end;

    i := 0;
    Tv[21] := 0;
    Repeat
      if Strings[74 + i] > '' then
      Begin
        Tv[77 + i] := Tv[75 + i] - Tv[76 + i]; // col 4 =col 2 -3
        Tv[80 + i] := Tv[78 + i] + Tv[79 + i]; // col7 =col 5 +8
        Tv[81 + i] := MaxR(0, 10000 - Tv[80 + i]); // col 8=10,000-col 7
        Tv[82 + i] := MinR(Tv[77 + i], Tv[81 + i]);
        // Tv[177+i]+Tv[81+i];    //col 9=least of col 4 and 8 //20221106]
        Tv[83 + i] := Tv[78 + i] + Tv[82 + i]; // col 10= col 5 +9
        Tv[21] := Tv[21] + Tv[82 + i];
      End
      Else
      Begin
        Tv[77 + i] := 0;
        Tv[80 + i] := 0;
        Tv[81 + i] := 0;
        Tv[82 + i] := 0;
        Tv[83 + i] := 0;
      End;
      Inc(i, 10);
    Until i > 244;

    // Part 3
    if Affiliated then
    Begin
      Strings[261] := GetCorpName(RetNo);
      Strings[262] := GetBN(RetNo);
      x := 0;
      i := 266; // start from second entry
      Repeat
        x := x + Tv[i];
        Inc(i, 3);
      Until i > 299;
      Tv[263] := MaxR(0, 100 - x);
      // add up
      Tv[41] := 0;
      i := 263;
      Repeat
        Tv[41] := Tv[41] + Tv[i];
        Inc(i, 3);
      Until i > 299;
    end
    Else // remove affiliated
    Begin
      i := 261;
      Repeat
        Tv[i] := 0;
        Strings[i] := '';
        Inc(i, 1);
      Until i > 299;
      Tv[41] := 0;
    End;
    // Part4
    Tv[10] := Tv[21];
    Tv[11] := 100;
    if Affiliated Then
      Tv[11] := Tv[263];
    Tv[12] := (50000 * Tv[11]) / 100;
    Tv[14] := MaxR(0, Tv[12] - Tv[13]);
    Tv[15] := Tv[14];
    Tv[16] := MinR(Tv[10], Tv[15]);
    Tv[17] := Tv[13] + Tv[16];
    Tv[20] := Tv[16];
    Tv[18] := Tv[20] * 25 / 100;
    Tv[22] := Tv[18] + Tv[19];
  end;
  SaveTv(RetNo, FName, FNo);
end;
*)

Procedure S351(RetNo: integer; FName: String; FNo: integer); // 20220508
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    i := 5;
    Tv[78] := 0;
    Repeat
      Tv[78] := Tv[78] + Tv[i];
      Inc(i, 2);
    until i > 77;
  end;
  SaveTv(RetNo, FName, FNo);
end;

// 20220614
Procedure T7DRQR(RetNo: integer; FName: String; FNo: integer);
var
  i: integer;
  AmountOwing: Real;
  sin, s: String;
  AmountPaid: Real;
Begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  Begin
    AmountOwing := Vl(FetchElm(RetNo, 'T2', 733));
    if AmountOwing <= 1 then
    Begin
      for i := 1 to 66 do
      begin
        Tv[i] := 0;
        Strings[i] := '';
      end;
      exit;
    End;

    AmountPaid := AmountOwing;
    if Strings[11] > '' then
    begin
      AmountPaid := Vl(Strings[11]); // 20180319
      If AmountPaid > AmountOwing then
        AmountPaid := AmountOwing;
      Strings[11] := FormatFloat('#,###,###,0.00', AmountPaid);
    end;

    Strings[23] := justright(FormatFloat('#,###,###.00', AmountPaid), 13);

    // bottom part
    Strings[1] := Strings[8]; // GetSinNo(RetNo); //20180310 CON 9:54 PM
    Strings[4] := '01';
    sin := ReplaceChar(Strings[8], '-', '');
    // leftStr(ReformatSinWithSpaceInBetween(Strings[8]),8);//already spaces
    s := '0100090001000700' + AddLeadingZeros(sin, 15) + '00000000' +
      AddLeadingZeros(IntToStr(Trunc(AmountPaid * 100)), 10) + '010009';
    Strings[10] := s + CalcCheckDigitForT7DROCR(s);
    Strings[10] := s + CalcCheckDigitForT7DROCR(s);
    Strings[2] := justright(FormatFloat('#,###,###.00', AmountPaid), 13);
    Strings[12] := justright(FormatFloat('#,###,###.00', AmountOwing), 13);
  End;
  SaveTv(RetNo, FName, FNo);
End;

Procedure S63(RetNo: integer; FName: String; FNo: integer); // 20220508
const
  NLMJusedElm = 289; NLOFFMJusedElm = 290; PEMJusedElm = 291; NSMJusedElm = 292; NSOFFMJusedElm = 293;
  NBMJusedElm = 294; QMJusedElm     = 295; ONMJusedElm = 296; MBMJusedElm = 297; SKMJusedElm    = 298;
  ABMJusedElm = 299; BCMJusedElm    = 300; YKMJusedElm = 301; NTMJusedElm = 302; NUMJusedElm    = 303; ZZMJused = 304;
Var
  i, k: integer;
  m: double;
  S1FNo, S5FNo: integer;

  //NLMJused, NLOFFMJused, PEMJused, NSMJused, NSOFFMJused,
  //NBMJused, QMJused    , ONMJused, MBMJused, SKMJused,
  //ABMJused, BCMJused   , YKMJused, NTMJused, NUMJused,    ZZMJused : boolean;
begin
  //20250614
  S1FNo := GetFormNo('S1');
  S5FNo := GetFormNo('S5');
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin

    //20250615
    if IsMultJurisdiction(RetNo) = false then // initiaize
    Begin

      for i := 104 to 114 do //NB
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

      for i := 115 to 125 do //NB
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;


      for i := 126 to 136 do //NS
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

      for i := 37 to 149 do //NB
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

      for i := 11 to 21 do //on
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

      for i := 22 to 32 do   //mb
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

      for i := 33 to 43 do  //sk
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      for i := 44 to 54 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;

     for i := 44 to 54 do  //AB
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
    End;

    FillHeader(RetNo, FNo, 1, 2, 3);

    if (Ret[RetNo].Province = 'NL') or (Ret[RetNo].Province = 'PE') or
      (Ret[RetNo].Province = 'NS') or (Ret[RetNo].Province = 'NB') or
      (Ret[RetNo].Province = 'ON') or (Ret[RetNo].Province = 'MB') or
      (Ret[RetNo].Province = 'SK') or (Ret[RetNo].Province = 'AB') Or
      (IsMultJurisdiction(RetNo)) then
      // ok
    Else
    Begin
      for i := 4 to 97 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;

    If UpperCase(Strings[90]) <> 'Y' then  Tv[4] := TotMultiple(RetNo, 'S125', 32);  // 9998 GIFI Farm expenses //20220705
    If Tv[4] < 25000 then
    Begin
      for i := 4 to 97 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      exit;
    End;


    //PART 1 PART 1 PART 1 PART 1 PART 1 PART 1 PART 1 PART 1 PART 1 PART 1 ----

    // Tv[4]:=TotMultiple(RetNo,'S125',32); //9998 GIFI
    Tv[5] := Vl(FetchElmFNo(RetNo, S1FNo, 210));
    Tv[6] := Vl(FetchElmFNo(RetNo, S1FNo, 214));
    // [7]:=? User
    Tv[8] := Tv[5] + Tv[6] + Tv[7];
    Tv[9] := Tv[8];
    Tv[10] := MaxR(0, Tv[4] - Tv[9]);


    //showmessage(Ret[RetNo].Province);

    //jz 20240604
    //PART 2 NL ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'NL') then
    begin
      Tv[104] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, NLMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    Begin
        Tv[104] := 0;                                                  //A
        Tv[105] := Vl(FetchElmFNo(RetNo, S5FNo, 107));                 //B
        Tv[106] := Vl(FetchElmFNo(RetNo, S5FNo, 272));                 //C
        if Tv[106] > 0 then
          Strings[107] := FormatFloat('##0.00000', (Tv[105]/Tv[106]))  //D
        else
          Strings[107] := '';
        Strings[108] := Strings[107];                                  //D

        Tv[109] := Vl(FetchElmFNo(RetNo, S5FNo, 105));                 //E
        Tv[110] := Vl(FetchElmFNo(RetNo, S5FNo, 270));                 //F
        If Tv[110] > 0 then
          Strings[111] := FormatFloat('##0.00000', (Tv[109]/Tv[110]))  //G
        else
          Strings[111] := '';
        Strings[112] := Strings[111];                                   //G

        m := 0.5; if (Tv[106] <= 0) or (Tv[110] <= 0) then m := 1; //do not multiply by * 0.5 as per note
        Strings[113] := FormatFloat('##0.00000',
                       (Vl(Strings[108]) + Vl(Strings[112])) * m);      //H

        Tv[114] := Tv[10] * StrToFloat(Strings[113]);                   //I
    End;



    //jz 20240604
    //PART 3 PE ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'PE') then
    begin
      Tv[115] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, PEMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    Begin
        Tv[115] := 0;                                                  //A
        Tv[116] := Vl(FetchElmFNo(RetNo, S5FNo, 118));                 //B
        Tv[117] := Vl(FetchElmFNo(RetNo, S5FNo, 272));                 //C
        if Tv[117] > 0 then
          Strings[118] := FormatFloat('##0.00000', (Tv[105]/Tv[106]))  //D
        else
          Strings[118] := '';
        Strings[119] := Strings[118];                                  //D

        Tv[120] := Vl(FetchElmFNo(RetNo, S5FNo, 116));                 //E
        Tv[121] := Vl(FetchElmFNo(RetNo, S5FNo, 270));                 //F
        If Tv[121] > 0 then
          Strings[122] := FormatFloat('##0.00000', (Tv[120]/Tv[121]))  //G
        else
          Strings[122] := '';
        Strings[123] := Strings[122];                                   //G

        m := 0.5; if (Tv[117] <= 0) or (Tv[121] <= 0) then m := 1; //do not multiply by * 0.5 as per note
        Strings[124] := FormatFloat('##0.00000',
                       (Vl(Strings[119]) + Vl(Strings[123])) * m);      //H
        Tv[125] := Tv[10] * StrToFloat(Strings[124]);                   //I
      End;

    //jz 20240604
    //PART 4 NS ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'NS') then
    begin
      Tv[126] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, NSMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    begin
        Tv[126] := 0;                                                  //A
        Tv[127] := Vl(FetchElmFNo(RetNo, S5FNo, 129));                 //B
        Tv[128] := Vl(FetchElmFNo(RetNo, S5FNo, 272));                 //C
        if Tv[128] > 0 then
          Strings[129] := FormatFloat('##0.00000', (Tv[127]/Tv[128]))  //D
        else
          Strings[129] := '';
        Strings[130] := Strings[129];                                  //D

        Tv[131] := Vl(FetchElmFNo(RetNo, S5FNo, 127));                 //E
        Tv[132] := Vl(FetchElmFNo(RetNo, S5FNo, 270));                 //F
        If Tv[132] > 0 then
          Strings[133] := FormatFloat('##0.00000', (Tv[131]/Tv[132]))  //G
        else
          Strings[133] := '';
        Strings[134] := Strings[133];                                  //G

        m := 0.5; if (Tv[128] <= 0) or (Tv[132] <= 0) then m := 1; //do not multiply by * 0.5 as per note
        Strings[135] := FormatFloat('##0.00000',
                       (Vl(Strings[130]) + Vl(Strings[134])) * m);     //H
        Tv[136] := Tv[10] * StrToFloat(Strings[135]);                  //I
    end;

    //jz 20240604
    //PART 5 NB ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'NB') then
    begin
      Tv[137] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, NBMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    Begin
        Tv[137] := 0;                                                  //A
        Tv[138] := Vl(FetchElmFNo(RetNo, S5FNo, 140));                 //B
        Tv[139] := Vl(FetchElmFNo(RetNo, S5FNo, 272));                 //C
        if Tv[139] > 0 then
          Strings[140] := FormatFloat('##0.00000', (Tv[138]/Tv[139]))  //D
        else
          Strings[140] := '';
        Strings[141] := Strings[140];                                  //D

        Tv[142] := Vl(FetchElmFNo(RetNo, S5FNo, 138));                 //E
        Tv[143] := Vl(FetchElmFNo(RetNo, S5FNo, 270));                 //F
        If Tv[143] > 0 then
          Strings[145] := FormatFloat('##0.00000', (Tv[142]/Tv[143]))  //G
        else
          Strings[145] := '';
        Strings[146] := Strings[145];                                   //G

        m := 0.5; if (Tv[139] <= 0) or (Tv[143] <= 0) then m := 1; //do not multiply by * 0.5 as per note
        Strings[147] := FormatFloat('##0.00000',
                       (Vl(Strings[141]) + Vl(Strings[146])) * m);      //H
        Tv[149] := Tv[10] * StrToFloat(Strings[147]);                   //I
      End;

    //PART 6 ON ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'ON') then
    Begin
      Tv[11] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, ONMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    Begin
        Tv[11] := 0;                                                    //A
        Tv[12] := Vl(FetchElmFNo(RetNo, S5FNo, 162));                   //B
        Tv[13] := Vl(FetchElmFNo(RetNo, S5FNo, 272));                   //C
        if Tv[13] > 0 then
          Strings[14] := FormatFloat('##0.00000', (Tv[12] / Tv[13]))    //D
        else
          Strings[14] := '';                                            //D
        Strings[15] := Strings[14];                                     //D
        Tv[16] := Vl(FetchElmFNo(RetNo, S5FNo, 160));                   //E
        Tv[17] := Vl(FetchElmFNo(RetNo, S5FNo, 270));                   //F
        If Tv[17] > 0 then
          Strings[18] := FormatFloat('##0.00000', (Tv[16] / Tv[17]))    //G
        else
          Strings[18] := '';                                            //G
        Strings[19] := Strings[18];                                     //G

        m := 0.5; if (Tv[13] <= 0) or (Tv[17] <= 0) then m := 1; //do not multiply by * 0.5 as per note //jz 20240604
        Strings[20] := FormatFloat('##0.00000',
          (Vl(Strings[15]) + Vl(Strings[19])) * m);                     //H
        Tv[21] := Tv[10] * StrToFloat(Strings[20]);                     //I
    End;

    //PART 7 MB ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'MB') then
    begin
      Tv[22] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, MBMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    Begin
      Tv[12] := 0;
      Tv[23] := Vl(FetchElmFNo(RetNo, S5FNo, 173));
      Tv[24] := Vl(FetchElmFNo(RetNo, S5FNo, 272));
      If Tv[24] > 0 then
        Strings[25] := FormatFloat('##0.00000', (Tv[23] / Tv[24]))
      else
        Strings[25] := '';
      Strings[26] := Strings[25];
      Tv[27] := Vl(FetchElmFNo(RetNo, S5FNo, 171));
      Tv[28] := Vl(FetchElmFNo(RetNo, S5FNo, 270));
      If Tv[28] > 0 then
        Strings[29] := FormatFloat('##0.00000', (Tv[27] / Tv[28]))
      else
        Strings[29] := '';
      Strings[30] := Strings[29];

      m := 0.5; if (Tv[24] <= 0) or (Tv[28] <= 0) then m := 1; //do not multiply by * 0.5 as per note  //jz 20240604
      Strings[31] := FormatFloat('##0.00000',
        (Vl(Strings[26]) + Vl(Strings[30])) * m);
      Tv[32] :=Tv[10] * Vl(Strings[31]); //Tv[22] * Vl(Strings[31]);  //20250615
    end;

    //PART 8 Sk ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'SK') then
    Begin
      Tv[33] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, SKMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    Begin
        Tv[33] := 0;
        Tv[34] := Vl(FetchElmFNo(RetNo, S5FNo, 184));
        Tv[35] := Vl(FetchElmFNo(RetNo, S5FNo, 272));
        If Tv[35] > 0 then
          Strings[36] := FormatFloat('##0.00000', (Tv[34] / Tv[35]))
        else
          Strings[36] := '';
        Strings[37] := Strings[36];
        Tv[38] := Vl(FetchElmFNo(RetNo, S5FNo, 182));
        Tv[39] := Vl(FetchElmFNo(RetNo, S5FNo, 270));
        If Tv[39] > 0 then
          Strings[40] := FormatFloat('##0.00000', (Tv[38] / Tv[39]))
        else
          Strings[40] := '';
        Strings[41] := Strings[40];

        m := 0.5; if (Tv[35] <= 0) or (Tv[39] <= 0) then m := 1; //do not multiply by * 0.5 as per note //jz 20240604
        Strings[42] := FormatFloat('##0.00000',
          (Vl(Strings[37]) + Vl(Strings[41])) * m); // (Tv[37]+Tv[41]) * 0.5;
        Tv[43] := Tv[10] * StrToFloat(Strings[42]);
    End;

    //PART 9 AB ----------------------------------------------------------------
    if (Ret[RetNo].Province = 'AB') then
    Begin
      Tv[44] := Tv[10];
    end; //jz 20241120 remove MJ section from within prov if

    if (IsMultJurisdiction(RetNo)) and (FetchElmFNo(RetNo, S5FNo, ABMJusedElm) > '') then //jz 20241120 add check if prov is activated on s5
    Begin
        Tv[44] := 0;
        Tv[45] := Vl(FetchElmFNo(RetNo, S5FNo, 195));
        Tv[46] := Vl(FetchElmFNo(RetNo, S5FNo, 272));
        If Tv[46] > 0 then
          Strings[47] := FormatFloat('##0.00000', (Tv[45] / Tv[46]))
        else
          Strings[47] := '';
        Strings[48] := Strings[47];
        Tv[49] := Vl(FetchElmFNo(RetNo, S5FNo, 193));
        Tv[50] := Vl(FetchElmFNo(RetNo, S5FNo, 270));
        If Tv[50] > 0 then
          Strings[51] := FormatFloat('##0.00000', (Tv[49] / Tv[50]))
        else
          Strings[51] := '';
        Strings[52] := Strings[51];

        m := 0.5; if (Tv[46] <= 0) or (Tv[50] <= 0) then m := 1; //do not multiply by * 0.5 as per note //jz 20240604
        Strings[53] := FormatFloat('##0.00000',
          (Vl(Strings[48]) + Vl(Strings[52])) * m); // (Tv[48]+Tv[52]) * 0.5;
        Tv[54] := Tv[10] * StrToFloat(Strings[53]);
    end;

    //PART 10 ------------------------------------------------------------------

    //20250614

    k :=GetNumDays(RetNo, '31-12-2021', 'A') -  GetNumDays(RetNo, '31-12-2022', 'A');
    if k>0 then  Strings[55] := IntToStr(k) else begin Strings[55]:='';k:=0;end;
    Strings[56] := IntToStr(Ret[RetNo].DaysInYear);
    If Ret[RetNo].DaysInYear>0 then
      Strings[57] := FormatFloat('##0.00000', k / Ret[RetNo].DaysInYear) //20250614
    else
      Strings[57] :='';
    //----------------------------------

    k := GetNumDays(RetNo, '31-12-2022', 'A') - GetNumDays(RetNo, '31-12-2023', 'A');
    Strings[58] := IntToStr(k);
    Strings[59] := IntToStr(Ret[RetNo].DaysInYear);
    Strings[60]:='';
    Strings[60] := FormatFloat('##0.00000', k / Ret[RetNo].DaysInYear);

    //jz 20240604
    k := GetNumDays(RetNo, '31-12-2023', 'A') -  GetNumDays(RetNo, '31-12-2024', 'A');
    Strings[176] := IntToStr(k);
    Strings[177] := IntToStr(Ret[RetNo].DaysInYear);
    If Ret[RetNo].DaysInYear>0 then Strings[178] := FormatFloat('##0.00000', k / Ret[RetNo].DaysInYear);

    k := GetNumDays(RetNo, '31-12-2024', 'A') -  GetNumDays(RetNo, '31-12-2025', 'A');
    Strings[65] := IntToStr(k);
    Strings[91] := IntToStr(Ret[RetNo].DaysInYear);
    If Ret[RetNo].DaysInYear>0 then Strings[64] := FormatFloat('##0.00000', k / Ret[RetNo].DaysInYear);

    //PART 10 NL ----------------------------------------------------------------------
    //10B
    Strings[100] := Strings[60]; //Strings[99]; //20250613
    Tv[101]      := MaxR(Tv[104], Tv[114]);
    Tv[102]:= StrToFloat(Strings[100]) * (Tv[101] * 0.140) / 100;
    //10c
    Strings[193] := Strings[178];
    Tv[98]      := MaxR(Tv[104], Tv[114]);
    Tv[99]:= StrToFloat(Strings[193]) * (Tv[98] * 0.229) / 100;
    //10d
    Strings[194] := Strings[64];
    Tv[179]      := MaxR(Tv[104], Tv[114]);
    Tv[180]:= StrToFloat(Strings[194]) * (Tv[179] * 0.250) / 100;

    Tv[103] := Tv[102]+Tv[99]+Tv[180];
    xx:=Tv[103];

    //PART 10 PE ----------------------------------------------------------------------
    Strings[144] := Strings[60];
    Tv[148]      := MaxR(Tv[115], Tv[125]);
    Tv[150]:= StrToFloat(Strings[144]) * (Tv[148] * 0.140) / 100;

    Strings[195] := Strings[178];
    Tv[181]      := MaxR(Tv[115], Tv[125]);
    Tv[182]:= StrToFloat(Strings[195]) * (Tv[181] * 0.229) / 100;

    Strings[196] := Strings[64];
    Tv[183]      := MaxR(Tv[115], Tv[125]);
    Tv[184]:= StrToFloat(Strings[196]) * (Tv[183] * 0.250) / 100;

    Tv[151] := Tv[150]+Tv[182]+Tv[184];

    //PART 10 NS ------//20250614----------------------------------------------------------------
    Strings[152] := Strings[60];
    Tv[153]      := MaxR(Tv[126], Tv[136]);
    Tv[154]:= StrToFloat(Strings[152]) * (Tv[153] * 0.140) / 100;

    Strings[197] := Strings[178];
    Tv[185]      := MaxR(Tv[126], Tv[136]);
    Tv[186]:= StrToFloat(Strings[197]) * (Tv[185] * 0.229) / 100;

    Strings[198] := Strings[64];
    Tv[187]      := MaxR(Tv[126], Tv[136]);
    Tv[188]:= StrToFloat(Strings[198]) * (Tv[187] * 0.250) / 100;

    Tv[155] := Tv[154]+Tv[186]+Tv[188];

    //PART 10 NB ----------------------------------------------------------------------
    Strings[156] := Strings[60];
    Tv[157]      := MaxR(Tv[137], Tv[149]);
    Tv[158]:= StrToFloat(Strings[156]) * (Tv[157] * 0.140) / 100;

    Strings[199] := Strings[178];
    Tv[189]      := MaxR(Tv[137], Tv[149]);
    Tv[190]:= StrToFloat(Strings[199]) * (Tv[189] * 0.229) / 100;

    Strings[200] := Strings[64];
    Tv[191]      := MaxR(Tv[137], Tv[149]);
    Tv[192]:= StrToFloat(Strings[200]) * (Tv[191] * 0.250) / 100;

    Tv[159] := Tv[158]+Tv[190]+Tv[192];

    //PART 10 ON ----------------------------------------------------------------------
    Strings[61] := Strings[57];
    Tv[62] := MaxR(Tv[11], Tv[21]);
    Tv[63] := StrToFloat(Strings[61]) * (Tv[62] * 0.173) / 100; // 20220611

    Strings[201] := Strings[60];
    Tv[202] := MaxR(Tv[11], Tv[21]);
    Tv[66] := StrToFloat(Strings[201]) * (Tv[202] * 0.186) / 100; // 20220611

    Strings[162] := Strings[178];
    Tv[163] := MaxR(Tv[11], Tv[21]);
    Tv[164] := StrToFloat(Strings[162]) * (Tv[163] * 0.229) / 100;

    Strings[203] := Strings[64];
    Tv[204] := MaxR(Tv[11], Tv[21]);
    Tv[205] := StrToFloat(Strings[203]) * (Tv[204] * 0.250) / 100;

    Tv[67] := Tv[63] + Tv[66] + Tv[164] +Tv[205];

    //20250615
    //PART 10 MB ----------------------------------------------------------------------
    Strings[68] := Strings[57];
    Tv[69] := MaxR(Tv[22], Tv[32]);
    Tv[70] := Vl(Strings[68]) * (Tv[69] * 0.173) / 100;  //20250615A

    Strings[71] := Strings[60];
    Tv[72] := MaxR(Tv[22], Tv[32]);
    Tv[73] := StrToFloat(Strings[71]) * (Tv[72] * 0.186) / 100;

    Strings[160] := Strings[178];
    Tv[161] := MaxR(Tv[22], Tv[32]);
    Tv[165] := StrToFloat(Strings[160]) * (Tv[161] * 0.229) / 100;

    Strings[209] := Strings[64];
    Tv[210] := MaxR(Tv[22], Tv[32]);
    Tv[211] := StrToFloat(Strings[209]) * (Tv[210] * 0.250) / 100;


    Tv[74] := Tv[70] + Tv[73] + Tv[165]+Tv[211];

    //PART 10 SK ----------------------------------------------------------------------
    Strings[75] := Strings[57];
    Tv[76] := MaxR(Tv[33], Tv[43]);
    Tv[77] := StrToFloat(Strings[75]) * (Tv[76] * 0.173) / 100;

    Strings[78] := Strings[60];
    Tv[79] := MaxR(Tv[33], Tv[43]);
    Tv[80] := StrToFloat(Strings[78]) * (Tv[79] * 0.186) / 100;

    Strings[166] := Strings[178];
    Tv[167] := MaxR(Tv[33], Tv[43]);
    Tv[168] := StrToFloat(Strings[166]) * (Tv[167] * 0.229) / 100;

    Tv[81] := Tv[77] + Tv[80] + Tv[168] +Tv[214];

    //PART 10 AB ----------------------------------------------------------------------
    Strings[82] := Strings[57];
    Tv[83] := MaxR(Tv[44], Tv[54]);
    Tv[84] := StrToFloat(Strings[82]) * (Tv[83] * 0.147) / 100;

    Strings[86] := Strings[60];
    Tv[87] := MaxR(Tv[44], Tv[54]);
    Tv[85] := StrToFloat(Strings[86]) * (Tv[87] * 0.186) / 100;

    Strings[169] := Strings[178];
    Tv[170] := MaxR(Tv[44], Tv[54]);
    Tv[171] := StrToFloat(Strings[169]) * (Tv[170] * 0.229) / 100;

    Strings[206] := Strings[64];
    Tv[207] := MaxR(Tv[44], Tv[54]);
    Tv[208] := StrToFloat(Strings[206]) * (Tv[207] * 0.250) / 100;

    Tv[88] := Tv[84] + Tv[85] + Tv[171] +Tv[208];


    //PART 10 TOTALS
    Tv[89] := Tv[103] + Tv[151] + Tv[155] + Tv[159] + Tv[67] + Tv[74] + Tv[81] + Tv[88];

    //PART 11 ------------------------------------------------------------------
    Tv[96] := Tv[172] + Tv[173] + Tv[174] + Tv[175] + Tv[92] + Tv[93] + Tv[94] + Tv[95]; //jz 20240604 added line 350-380
    Tv[97] := Tv[89] + Tv[96];

  end; // with
  SaveTv(RetNo, FName, FNo);

  end;

// 20230628
Procedure S432(RetNo: integer; FName: String; FNo: integer); // 20130505
Var
  i: integer;
Begin
 LoadTv(RetNo, FName, FNo);
 with Ret[RetNo].Frm[FNo] do
 begin
  If (Ret[RetNo].Province <> 'BC') and (Ret[RetNo].Province <> 'MJ') then
  begin
      For i := 1 to 70 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      exit;
  end;
  FillHeader(RetNo, FNo, 175, 174,163);

  Tv[71]:=0;
  i:=2;
  Repeat
   Tv[71]:=Tv[71]+Tv[i];
   Inc(i,2);
  Until i>70;
 end;
  SaveTv(RetNo, FName, FNo);
end;


Procedure S56(RetNo: integer; FName: String; FNo: integer); //jz 20240424 - adding new forms S56 S572 T2047
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    Tv[8] := Tv[6]-Tv[7];
    Tv[9] := Tv[8];

    Tv[4] := Tv[5]+Tv[9];


    Tv[12] := Tv[10]+Tv[11];

    Tv[13] := Tv[12];
    Tv[14] := MaxR(0,Tv[4]-Tv[13]);  //20260524CZ

    Tv[15] := Tv[14] * 0.02;
    if Tv[4] < 1000000 then  //??? how to make prorated?? //or (GetTaxationYe(RetNo)<'2024/12/31'   //20241029 ??? needed
      Tv[15] := 0;

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S572(RetNo: integer; FName: String; FNo: integer); //jz 20240424 - adding new forms S56 S572 T2047
var
  i,x:integer;
  YearDays:integer;
  lBeforeMay15: Currency; //20260518 Alex
  lAfterMay14: Currency; //20260518 Alex
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin

    if (Ret[RetNo].Province <> 'ON') and (Ret[RetNo].Province <> 'MJ') then
    begin
      for i := 1 to 117 do
      begin
        Strings[i] := '';
        Tv[i] := 0;
      end;
      exit;
    end;

    FillHeader(RetNo, FNo, 1, 2, 3);

    Tv[51]:=0;
    i:=8;
    Repeat
     Tv[51]:=Tv[51]+Tv[i];
     Inc(i,3);
    Until i>50;

    x:= 20000000;

    Tv[52] := Tv[8];

    if (Tv[51] > x) or (strings[4] = '') or (strings[5] > '') then
      Tv[52] := 0;

    //Tv[51]:= MinR(Tv[51], x); //cannot be more than 20 million, but needs to be know what to do with other fields??

    Tv[113]:=0;
    i:=56;
    Repeat
     Tv[113]:=Tv[113]+Tv[i];
     Inc(i,4);
    Until i>112;

    if strings[4] > '' then
      Tv[114] := Tv[52]
    else
      Tv[114] := x;

    Tv[115] := MinR(Tv[113],Tv[114]);

    //20260518 Alex >>>
    lBeforeMay15:= 0;
    lAfterMay14:= 0;
    i:= 55;
    repeat
      if (Strings[i] < '2025-05-15') then lBeforeMay15:= lBeforeMay15 + Tv[i + 1];
      if (Strings[i] > '2025-05-14') then lAfterMay14:= lAfterMay14 + Tv[i + 1];
      inc(i, 4);
    until i > 111;

    Tv[116]:= lBeforeMay15; //20260518 Alex
    Tv[121]:= lAfterMay14; //Tv[115]; //20260518 Alex
    //20260518 Alex <<<

    YearDays := 365; //If (IsLeapYear(GetTaxationYearStartYYYY(RetNo))) then YearDays := 366; //leap yr function only works if in single calandar yr
    If isLeapDayWithinReturnDateRange(RetNo) then
      YearDays := 366; //leap yr function didnt work??

    strings[118] := inttostr(Ret[RetNo].DaysInYear);
    strings[119] := inttostr(YearDays);
    Strings[124]:= inttostr(Ret[RetNo].DaysInYear); //20260501 Alex
    Strings[123]:= inttostr(YearDays); //20260501 Alex

    Tv[120]:= Tv[116] * Ret[RetNo].DaysInYear / YearDays * 0.10; //Tv[117] := Tv[116] * Ret[RetNo].DaysInYear / YearDays * 10/100; //20260501 Alex
    Tv[122]:= Tv[121] * Ret[RetNo].DaysInYear / YearDays * 0.15; //Tv[117] := Tv[116] * Ret[RetNo].DaysInYear / YearDays * 10/100; //20260501 Alex
    //Tv[117]:= minr(Tv[117], (x * 1/10)); //20260501 Alex //jz 20240611 //help solve extra day issue since max amount is 20000000 * 10%
                                       //procedure SetNumDays(RetNo: integer); is wrong?
    Tv[117]:= Tv[120] + Tv[122]; //20260501 Alex //If you still need to use this condition: Tv[117]:= MinR(Tv[120] + Tv[122], x * 0.10);

    //20260501 Alex >>>
    //Page 3
    Tv[185]:= 0;
    i:= 128;
    repeat
      Tv[185]:= Tv[185] + Tv[i];
      Inc(i, 4);
    until i > 184;
    if not (Strings[4]).IsEmpty then Tv[186]:= Tv[52] else Tv[186]:= x;
    Tv[187]:= MinR(Tv[185], Tv[186]);

    Tv[188]:= Tv[187];
    Strings[189]:= inttostr(Ret[RetNo].DaysInYear);
    Strings[190]:= inttostr(YearDays);
    Tv[191]:= Tv[188] * Ret[RetNo].DaysInYear / YearDays * 0.15;

    Tv[194]:= Tv[192] - Tv[193];
    Tv[196]:= Tv[191];
    Tv[197]:= Tv[195] + Tv[196];
    Tv[198]:= Tv[197];
    Tv[199]:= Tv[194] + Tv[198];
    Tv[201]:= Tv[199] - Tv[200];

    //Page 4
    Tv[224]:= 0;
    i:= 203;
    repeat
      Tv[224]:= Tv[224] + Tv[i];
      Inc(i, 2);
    until i > 223;

    Tv[228]:= Tv[225];
    Tv[229]:= Tv[226];
    Tv[232]:= Tv[227];
    Tv[230]:= Tv[228] * (Tv[229] / IfThen(Tv[227] <> 0, Tv[227], 1));
    Tv[231]:= Tv[230];
    Tv[233]:= MinR(Tv[225], Tv[230]);
    //20260501 Alex <<<
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T2047(RetNo: integer; FName: String; FNo: integer); //jz 20240424 - adding new forms S56 S572 T2047
var elm:integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    // funds outside canada
    ArrayNo := 1;
    Elm := ArrayNo * 10000 + 4; // for field id 10004 on the first row i form
    Tv[18] := SumOfColumn(RetNo, FNo, Elm);
    Tv[31] := SumOfColumn(RetNo, FNo, Elm + 1);

    // non res corp
    ArrayNo := 2;
    Elm := ArrayNo * 10000 + 4;
    Tv[32] := SumOfColumn(RetNo, FNo, Elm);
    Tv[33] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[43] := SumOfColumn(RetNo, FNo, Elm + 2);

    // indebtedness owed non res
    ArrayNo := 3;
    Elm := ArrayNo * 10000 + 4;
    Tv[40] := SumOfColumn(RetNo, FNo, Elm);
    Tv[41] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[45] := SumOfColumn(RetNo, FNo, Elm + 2);

    //interest non res trust
    ArrayNo := 4;
    Elm := ArrayNo * 10000 + 4;
    Tv[51] := SumOfColumn(RetNo, FNo, Elm);
    Tv[52] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[54] := SumOfColumn(RetNo, FNo, Elm + 2);
    Tv[56] := SumOfColumn(RetNo, FNo, Elm + 3);

    //real property outside canada
    ArrayNo := 5;
    Elm := ArrayNo * 10000 + 4;
    Tv[61] := SumOfColumn(RetNo, FNo, Elm);
    Tv[62] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[68] := SumOfColumn(RetNo, FNo, Elm + 2);

    //other property outside canada
    ArrayNo := 6;
    Elm := ArrayNo * 10000 + 4;
    Tv[81] := SumOfColumn(RetNo, FNo, Elm);
    Tv[82] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[85] := SumOfColumn(RetNo, FNo, Elm + 2);

    // property held in account with cnd registered securities
    ArrayNo := 7;
    Elm := ArrayNo * 10000 + 4;
    Tv[37] := SumOfColumn(RetNo, FNo, Elm);
    Tv[38] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[44] := SumOfColumn(RetNo, FNo, Elm + 2);

  end;
  SaveTv(RetNo, FName, FNo);

end;




end.
