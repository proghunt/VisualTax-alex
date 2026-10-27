unit T2_2027calc1;
{ ? need polit contr from POLIT }

interface

uses
  dialogs, Math, vtDynData, StrUtils; //20251028 Igor

  Procedure S150(RetNo:integer;FName:string;FNo:integer); //20231006
  Procedure S151(RetNo:integer;FName:string;FNo:integer); //20231006
  Procedure S310(RetNo:integer;FName:string;FNo:integer); //20231006
  Procedure S311(RetNo:integer;FName:string;FNo:integer); //20231006
  //20230603
  Procedure S67(RetNo:integer;FName:string;FNo:integer); //20230603
  Procedure S68(RetNo:integer;FName:string;FNo:integer); //20230603
  Procedure S444(RetNo:integer;FName:string;FNo:integer); //20230603
  Procedure AFRBAL(RetNo: integer; FName: string; FNo: integer);
  procedure S58(RetNo: integer; FName: string; FNo: integer); // 20200607
  Procedure T1273(RetNo: integer; FName: string; FNo: integer);
  Procedure T1273A1(RetNo: integer; FName: string; FNo: integer);
  Procedure T1273A2(RetNo: integer; FName: string; FNo: integer);
  // procedure MCT(RetNo: integer;FName: string;FNo: integer);
  procedure S51(RetNo: integer; FName: string; FNo: integer);
  procedure S51P(RetNo: integer; FName: string; FNo: integer);
  procedure S51CRN(RetNo: integer; FName: string; FNo: integer);
  procedure T400A(RetNo: integer; FName: string; FNo: integer);
  Function GetLine5K(Yr: String): Real;
  Function GetLine6K(Yr: String): Real;
  Function GetLine7K(Yr: String): Real;
  procedure CDA(RetNo: integer; FName: string; FNo: integer);
  procedure S7RENT(RetNo: integer; FName: string; FNo: integer);
  procedure S1AUTO(RetNo: integer; FName: string; FNo: integer);
  Procedure CalcS1Auto(RetNo: integer; FName: string; FNo: integer; Stm: string);
  procedure T1163(RetNo: integer; FName: string; FNo: integer);
  procedure S48(RetNo: integer; FName: string; FNo: integer);
  procedure S140(RetNo: integer; FName: string; FNo: integer);
  Function GetTxblIncBeforeDonations(RetNo: integer): Real;
  Procedure ApplyByYear(RetNo, FNo: Integer; Var LossByYear: Array of Real; ToBeApplied: Real;
    StartNdx, EndNdx, Increm: integer);
  procedure CalcCommonS8LH(RetNo: integer; FName: string; FNo: integer);
  procedure S21P(RetNo: integer; FName: string; FNo: integer);
  procedure S21SP(RetNo: integer; FName: string; FNo: integer);
  procedure S38(RetNo: integer; FName: string; FNo: integer);
  procedure S1(RetNo: integer; FName: string; FNo: integer);
  procedure S2(RetNo: integer; FName: string; FNo: integer);
  procedure S3(RetNo: integer; FName: string; FNo: integer);
  procedure S4(RetNo: integer; FName: string; FNo: integer);
  procedure S4WS(RetNo: integer; FName: string; FNo: integer);
  procedure S5(RetNo: integer; FName: string; FNo: integer);
  procedure S6(RetNo: integer; FName: string; FNo: integer);
  procedure S6RE(RetNo: integer; FName: string; FNo: integer);
  // procedure S7OLD(RetNo: integer;FName: string;FNo: integer);
  procedure S7(RetNo: integer; FName: string; FNo: integer);
  procedure S8(RetNo: integer; FName: string; FNo: integer);
  procedure S8LH(RetNo: integer; FName: string; FNo: integer);
  procedure S8ALL(RetNo: integer; FName: string; FNo: integer);
  procedure S8FREE(RetNo: integer; FName: string; FNo: integer);
  procedure S8LFREE(RetNo: integer; FName: string; FNo: integer);
  procedure S9(RetNo: integer; FName: string; FNo: integer);
  procedure S11(RetNo: integer; FName: string; FNo: integer);
  Procedure AddS2Spreadsheet(RetNo, FNo, FromElm, ToElm: integer);
  procedure S74(RetNo: Integer; FName: string; FNo: Integer); //20251028 Igor

implementation

uses
  SysUtils,
  vtMulti, vtCommon,
  T2_2027, T2_2027Declare, T2_2027common, T2_2027common2, T2_2027TrimStr,
  vtTrimStr, vtShared;
// Uses UCalc;

(* pattern
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  Tv[10] := Tv[1]+Tv[2];
  Strings[1] := FetchElm(RetNo,FirstFormName,2);
  Ret[RetNo].Ln[162] := Tv[32]
  end; {End with}

  SaveTv(RetNo,FName,FNo);
*)

procedure S21P(RetNo: integer; FName: string; FNo: integer);
Var
  i, k: integer; // Prv:String[2];FInst:String[4];
  Prv: String; // [2]; //20150701
  FInst: String; // [4]; //20150701
begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Strings[6] := 'NL';
    Strings[15] := 'PE';
    Strings[24] := 'NS';
    Strings[33] := 'NB';
    Strings[42] := 'MB';
    Strings[51] := 'SK';
    Strings[60] := 'BC';
    Strings[69] := 'YT';
    Strings[78] := 'NT';
    Strings[87] := 'NU';
    If GetTaxationYearEnd(RetNo) > '2008/12/31' then
      Strings[96] := 'ON'
    else
    begin
      Strings[96] := '';
      For i := 97 to 104 do
        Tv[i] := 0;
    end;

    i := 6;
    Tv[105] := 0;
    k := 0; // 20150701
    If FInst = '#1' then
      k := 4; // ndx to S21
    If FInst = '#2' then
      k := 13; // ndx to S21
    If FInst = '#3' then
      k := 22; // ndx to S21
    If FInst = '#4' then
      k := 31; // ndx to S21
    If FInst = '#5' then
      k := 40; // ndx to S21
    Repeat
      Strings[4] := FInst;
      Strings[5] := FetchElm(RetNo, 'S21', k);

      Prv := Strings[i];
      If Prv > '' then
        Strings[i + 1] := GetPrvAllocForFtc(RetNo, Prv);
      If Vl(Strings[i + 1]) > 0 then
      begin
        If Prv = 'ON' then
          Strings[i + 2] := FetchElm(RetNo, 'S500', 95) // '8.5'    //20181103
        else
          Strings[i + 2] := FormatFloat('###.##',
            GetHighRate(RetNo, GetPrvNdx(Prv)));
        Tv[i + 3] := Vl(FetchElm(RetNo, 'S21', k + 1)); // forign non-bus inc
        Tv[i + 4] := Round(Vl(Strings[i + 1]) * Vl(Strings[i + 2]) * Tv[i + 3] /
          100 / 100);
        Tv[i + 5] := Vl(FetchElm(RetNo, 'S21', k + 4)); // forign non-bus tax
        Tv[i + 6] := Vl(FetchElm(RetNo, 'S21', k + 8)); // forign non-bus tax
        Tv[i + 7] := Round(Vl(Strings[i + 1]) *
          (MaxR(0, Tv[i + 5] - Tv[i + 6])) / 100);
        Tv[i + 8] := MinR(Tv[i + 4], Tv[i + 7]);
        Tv[105] := Tv[105] + Tv[i + 8];
      end
      else
      begin
        Strings[i + 2] := '';
        Tv[i + 2] := 0;
        Tv[i + 3] := 0;
        Tv[i + 4] := 0;
        Tv[i + 5] := 0;
        Tv[i + 6] := 0;
        Tv[i + 7] := 0;
        Tv[i + 8] := 0;
      end;
      Inc(i, 9);
    until i > 96;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure S21SP(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    { ? }
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure ApplyByYear(RetNo, FNo: Integer; Var LossByYear: Array of Real; ToBeApplied: Real;
  StartNdx, EndNdx, Increm: integer);
Var
  i, j: integer;
begin
  with ret[RetNo].Frm[FNo] do
  begin
    { Initialize lossby year array }
    For i := Low(LossByYear) to High(LossByYear) do
      LossByYear[i] := 0;
    i := 1;
    j := StartNdx;
    Repeat
      LossByYear[i] := Tv[j];
      Inc(j, Increm);
      Inc(i, 1);
    until j > EndNdx;
    { now apply the loss }
    i := 1;
    Repeat
      If LossByYear[i] > ToBeApplied then
      begin
        LossByYear[i] := MaxR(0, LossByYear[i] - ToBeApplied);
        ToBeApplied := 0;
      end
      else
      begin
        ToBeApplied := MaxR(0, ToBeApplied - LossByYear[i]);
        LossByYear[i] := 0;
      end;
      Inc(i);
    until (ToBeApplied <= 0) or (i > High(LossByYear));

    { now copy it back to TV }
    i := 1;
    j := StartNdx;
    Repeat
      Tv[j] := LossByYear[i];
      Inc(j, Increm);
      Inc(i, 1);
    until j > EndNdx;
  end;
end;

procedure S1(RetNo: integer; FName: string; FNo: integer);
Var
  i, S125FNo: integer;
  x: Real;
  CopyFromGifi: Boolean;
  // elm:Integer;
  lASum: Double; // 20250908 Igor
  S150FNo: Integer; // 20250908 Igor
begin
  CopyFromGifi := UseGifi(RetNo);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    { bring from other schedules }
    // 20150824
    If CopyFromGifi then
    begin
      S125FNo := GetFormNo('S125#1');
      // directly from fixed lines
      // 20250908 Igor >>>
      S150FNo:= GetFormNo('S150');
      lASum:= Vl(FetchElmFNo(RetNo, S150FNo, 13));
      if lASum > 0 then
        Tv[4]:= lASum
      else
      // 20250908 Igor <<<
      Tv[4] := Vl(FetchElmFNo(RetNo, S125FNo, 8)); // 9999 income
      Tv[5] := Vl(FetchElmFNo(RetNo, S125FNo, 77)); // 9990 Current Income taxes
      Tv[6] := Vl(FetchElmFNo(RetNo, S125FNo, 80));
      // 9995 future Income tax provision

      if CountMultipleInstances(RetNo, 'S125') > 1 then // 20160506
      begin
        Tv[4] := Vl(FetchElm(RetNo, 'S140', 25)); // 9999 income
        Tv[5] := Vl(FetchElm(RetNo, 'S140', 14)); // 9990 Current Income taxes
        Tv[6] := Vl(FetchElm(RetNo, 'S140', 16));
        // 9995 future Income tax provision
      end;
    end;

    If UpperCase(Strings[56]) <> 'Y' then
      Tv[8] := TotAmortOfTangible(RetNo);
    // 20160715
    Tv[9] := TotAmortOfNatRes(RetNo);
    If UpperCase(Strings[73]) <> 'Y' then
      Tv[10] := TotAmortOfInTangible(RetNo); // 20210927
    Tv[11] := TotMultiple(RetNo, 'S8', 230);

    // 20190423  Line 108 out
    // Tv[12] := Vl(FetchElm(RetNo,'S10',21)); if Vl(FetchElm(RetNo,'S10',82))>0 then Tv[12]:=Vl(FetchElm(RetNo,'S10',82));

    x := TotLossInEquity(RetNo);
    If x < 0 then
      Tv[14] := ABS(x)
    else
      Tv[14] := 0;

    if UpperCase(Strings[39]) = 'Y' then // 20210921
      // leave for user entry
    Else
    Begin
      x := TotGainLossOnDisposal(RetNo);
      if x < 0 then
      begin
        Tv[15] := ABS(x);
        if UpperCase(Strings[39]) <> 'Y' then
          Tv[35] := 0; // gain on disposal
      end
      else
      begin
        Tv[15] := 0;
        if UpperCase(Strings[39]) <> 'Y' then
          Tv[35] := x;
      end;
    End;

    Tv[16] := Vl(FetchElm(RetNo, 'S2', 473)) + Vl(FetchElm(RetNo, 'S2', 489)) +
      Vl(FetchElm(RetNo, 'S2', 505)) + Vl(FetchElm(RetNo, 'S2', 521)) +
      Vl(FetchElm(RetNo, 'S2', 528)) // 20141116
      + Vl(FetchElm(RetNo, 'S2', 144));

    Tv[17] := MaxR(0, Vl(FetchElm(RetNo, 'S6', 685)));
    Tv[18] := Vl(FetchElm(RetNo, 'POLIT', 123));
    If UpperCase(Strings[58]) <> 'Y' then
    begin
      If CopyFromGifi then
        Tv[22] := Vl(FetchGifiElm(RetNo, 'S125#1', '9282'));
      // Vl(FetchGifiElm(RetNo,'GIFIIS#1','9282'));   //r&D //20150826
      // if Tv[22]=0 then Tv[22]:=Vl(FetchElm(RetNo,'T661',121));   //20181104  //put it back
    end;

    If CopyFromGifi then
      Try
        Tv[55] := TotGifiMultiple(RetNo, 'S125', '8523'); // 20210928
      except
      end;

    If Strings[59] = '' then
      Strings[59] := '50';
    If Vl(Strings[59]) > 100 then
      Strings[59] := '100';
    If UpperCase(Strings[74]) <> 'Y' then
      Tv[25] := RoundCorrect(Tv[55] * Vl(Strings[59]) / 100); // 20210928
    x := TotMultiple(RetNo, 'S1AUTO', 24);
    Tv[26] := MaxR(0, x);
    Tv[29] := Vl(FetchElm(RetNo, 'S13', 52)) + Vl(FetchElm(RetNo, 'S13', 53));
    Tv[30] := Vl(FetchElm(RetNo, 'S13', 63));
    Tv[32] := Vl(FetchElm(RetNo, 'S1', 148));
    if UpperCase(Strings[72]) = 'Y' then;
    // do nothing just let user enter it //20210921
    // leave for user entry
    Tv[36] := Vl(FetchElm(RetNo, 'S3', 94));
    Tv[37] := TotMultiple(RetNo, 'S8', 232);
    Tv[38] := TotMultiple(RetNo, 'S8', 231);
    Tv[39] := Vl(FetchElm(RetNo, 'S10', 47));
    If Vl(FetchElm(RetNo, 'S6', 686)) < 0 then
      Tv[40] := ABS(Vl(FetchElm(RetNo, 'S6', 686)))
    else
      Tv[40] := 0;

    Tv[41] := Vl(FetchElm(RetNo, 'S21', 101));
    Tv[46] := Vl(FetchElm(RetNo, 'S13', 54));
    If UpperCase(FetchElm(RetNo, 'T2', 71)) = 'Y' then // use GIFI
      Tv[45] := MaxR(0, Vl(FetchElm(RetNo, 'T661', 136)));
    Tv[47] := Vl(FetchElm(RetNo, 'S13', 62));
    Tv[49] := Vl(FetchElm(RetNo, 'S16', 136)); // Vl(FetchElm(RetNo,'S16',30));
    Tv[50] := Vl(FetchElm(RetNo, 'S15', 156)); // 20140608

    Tv[51] := Vl(FetchElm(RetNo, 'S1', 234));
    If Tv[57] < 0 then
      Tv[57] := 0;
    Tv[33] := 0;
    For i := 5 to 11 do
      Tv[33] := Tv[33] + Tv[i];
    For i := 14 to 32 do
      Tv[33] := Tv[33] + Tv[i];

    // 20160621
    Tv[60] := Vl(FetchElm(RetNo, 'S73', 502)) + Vl(FetchElm(RetNo, 'S73', 504))
      + Vl(FetchElm(RetNo, 'S73', 512)); // Vl(FetchElm(RetNo,'S73',438));
    Tv[61] := Vl(FetchElm(RetNo, 'S73', 510));

    Tv[33] := Tv[33] + Tv[57] + Tv[48] + Tv[60] + Tv[61] + Tv[62]; // 20121007
    Tv[34] := Tv[33];
    Tv[63] := Tv[4] + Tv[34];

    Tv[52] := 0;
    For i := 35 to 38 do
      Tv[52] := Tv[52] + Tv[i];
    For i := 40 to 47 do
      Tv[52] := Tv[52] + Tv[i];
    // For i:=35 to 47 do Tv[52] :=Tv[52]+Tv[i];  //20180521 rempve vt39 line 405 S10

    For i := 49 to 51 do
      Tv[52] := Tv[52] + Tv[i];
    Tv[52] := Tv[52] + Tv[71]; // 20171121

    Tv[53] := Tv[52];

    Tv[54] := Tv[63] - Tv[53]; // Tv[4]+Tv[34]-Tv[53]; //20121007

  end; { End with }
  // SaveTv(RetNo,FName,FNo);

  // S1 pg 2 --------------------------------------------------------------------

  // LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    // 20161112
    Tv[67] := 0;
    x := TotGifiMultiple(RetNo, 'S125', '8234');
    // TotGifiMultiple(RetNo,'GIFIIS','8234'); //20150826
    if x < 0 then
      Tv[67] := Tv[67] + ABS(x);

    Tv[68] := 0;
    x := TotGifiMultiple(RetNo, 'S125', '8235');
    if x < 0 then
    begin
      If UseGifi(RetNo) then
        Tv[68] := Tv[68] + ABS(x);
    end;

    Tv[122] := Vl(FetchElm(RetNo, 'S4', 336)); { lim partn loss }
    Tv[133] := Vl(FetchElm(RetNo, 'S4', 205)); { restr loss }
    // 20160505 //put back 20160514 CRA wrong

    Tv[131] := Vl(FetchElm(RetNo, 'T661', 391)); // recapture
    // 20220525
    x := TotMultiple(RetNo, 'S125', 62); // comprehensive income
    if x < 0 then
      Tv[150] := ABS(x)
    else
      Tv[150] := 0;

    //20260625
    Tv[79]:= Vl(FetchElm(RetNo, 'S130', 399)); // 20260624 Alex //Tv[79]:=Vl(FetchElm(RetNo,'S130',454));
    Tv[80]:= Vl(FetchElm(RetNo, 'S130', 454)); // 20260624 Alex //Tv[80]:=Vl(FetchElm(RetNo,'S130',399));

    // 20211010
    {//Covid related?  //20250517
    i := 136;
    repeat
      Strings[i] := LeftStr(Strings[i], 60);
      if (LeftStr(UpperCase(Strings[i]), 4)) = 'CEWS' then
      begin
        Tv[i + 1] := 0;
        Strings[i + 1] := '';
      end; // 20211026
      Inc(i, 2);
    until i > 146;
    }


    // 20161112
    Tv[66] := Tv[137] + Tv[139] + Tv[141] + Tv[143] + Tv[145] + Tv[147];
    Tv[64] := Tv[66];

    Tv[148] := 0;
    For i := 101 to 104 do
      Tv[148] := Tv[148] + Tv[i]; // 20111011 removed fld 7 line 207
    Tv[148] := Tv[148] + Tv[106];
    For i := 108 to 122 do
      Tv[148] := Tv[148] + Tv[i]; // 20160514 skip 223 removed
    For i := 124 to 124 do
      Tv[148] := Tv[148] + Tv[i]; // 20160514 skip 223  removed
    For i := 126 to 131 do
      Tv[148] := Tv[148] + Tv[i];

    // 20211010
    For i := 132 to 135 do
      Tv[148] := Tv[148] + Tv[i];
    Tv[148] := Tv[148] + Tv[75] + Tv[76];
    Tv[148] := Tv[148] + Tv[149] + Tv[150] + Tv[67] + Tv[68]+ Tv[77]  //jz vt49 added line 250
                +Tv[79]+ Tv[80]+Tv[81]+ Tv[82]+Tv[64];  //20250517

  end; { End with }

  // S1 pg 3 --------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    // 20161112
    If UseGifi(RetNo) then
      Tv[69] := 0;
    x := TotGifiMultiple(RetNo, 'S125', '8234');
    // TotGifiMultiple(RetNo,'GIFIIS','8234');
    if x > 0 then
      Tv[69] := Tv[69] + x;

    Tv[70] := 0;
    x := TotGifiMultiple(RetNo, 'S125', '8235');
    // TotGifiMultiple(RetNo,'GIFIIS','8235');
    if x > 0 then
    begin
      If UseGifi(RetNo) then
        Tv[70] := Tv[70] + x;
    end;
    Tv[216] := Vl(FetchElm(RetNo, 'S17', 56)); // 20210927

    Tv[221] := Vl(FetchElm(RetNo, 'S12', 29));
    // 20150531  //Vl(FetchElm(RetNo,'S12',12))+Vl(FetchElm(RetNo,'S12',11))+Vl(FetchElm(RetNo,'S12',20));
    Tv[218] := Vl(FetchElm(RetNo, 'S12', 35));
    // 20150531 //Vl(FetchElm(RetNo,'S12',121))+Vl(FetchElm(RetNo,'S12',122));v[216] := Vl(FetchElm(RetNo,'S17',56));
    Tv[217] := Vl(FetchElm(RetNo, 'S12', 38));
    // 20150531 //Vl(FetchElm(RetNo,'S12',223))+Vl(FetchElm(RetNo,'S12',224));
    Tv[219] := Vl(FetchElm(RetNo, 'S12', 41));
    // 20150531 //Vl(FetchElm(RetNo,'S12',319))+Vl(FetchElm(RetNo,'S12',320));
    Tv[222] := Vl(FetchElm(RetNo, 'S12', 48));
    // 20150531 //Vl(FetchElm(RetNo,'S12',411))+Vl(FetchElm(RetNo,'S12',412))+Vl(FetchElm(RetNo,'S12',596))+              Vl(FetchElm(RetNo,'S12',597))+
    // Vl(FetchElm(RetNo,'S12',696))+Vl(FetchElm(RetNo,'S12',697));

    i := 224;
    repeat
      Strings[i] := LeftStr(Strings[i], 60);
      Inc(i, 2);
    until i > 232;

    // 20220525
    x := TotMultiple(RetNo, 'S125', 62); // comprehensive income
    if x >= 0 then
      Tv[223] := ABS(x)
    else
      Tv[223] := 0;

    // only positive
    i := 225;
    Repeat
      Tv[i] := MaxR(0, Tv[i]);
      Inc(i, 2);
    until i > 233;

    // 20161112
    Tv[65] := Tv[225] + Tv[227] + Tv[229] + Tv[231] + Tv[233];
    Tv[13] := Tv[65];

    Tv[234] := 0;
    For i := 201 to 205 do
      Tv[234] := Tv[234] + Tv[i]; // 20090906   skip 209 deleted
    Tv[234] := Tv[234] + Tv[207] + Tv[208];
    For i := 210 to 216 do
      Tv[234] := Tv[234] + Tv[i]; // 20090906
    Tv[234] := Round(Tv[234] + Tv[235] + +Tv[223] + Tv[69] + Tv[70] + Tv[78] + Tv[217] + //jz vt49 line 350 added
      Tv[218] + Tv[219] + Tv[221] + Tv[222] + Tv[13]);

  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

Procedure AddS2Spreadsheet(RetNo, FNo, FromElm, ToElm: integer);
Var
  i: integer;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    { horizontal }
    i := FromElm;
    Repeat
      Tv[i + 4] := MaxR(0, Tv[i] - Tv[i + 2] - Tv[i + 3]);
      Inc(i, 5);
    until i > ToElm;

    For i := ToElm to ToElm + 3 do
    begin
      Tv[i] := AddColumns(i - 29, i - 4, 5);
    end;
  end;
end;

procedure S2(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, k, Yr: integer;
  DonLim: Real;
  mm, dd: String;
begin
  // 20141109 SIGNIFICANT CHANGES
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 25, 26, 1);
    Tv[12] := Round(Vl(FetchElm(RetNo, 'S1', 54)) * 0.75);
    Tv[18] := MinR(Tv[16], Tv[17]);
    Tv[19] := MinR(Tv[15], Tv[18]);
    Tv[20] := Tv[13] + Tv[14] + Tv[19];
    // Tv[21] := Tv[20];
    Tv[22] := Round(Tv[20] * 0.25);
    Tv[23] := Tv[12] + Tv[22]; // MaxR(0,Tv[12] - Tv[22]);

    Tv[24] := MinR(Tv[9], MinR(Tv[23], GetNetInc(RetNo)));
    Tv[24] := MaxR(0, MinR(Tv[24], GetTxblIncBeforeDonations(RetNo)));

    Tv[2] := MaxR(0, Vl(FetchElm(RetNo, 'S2', 234)) - Vl(FetchElm(RetNo, 'S2',
      230)) - Vl(FetchElm(RetNo, 'S2', 340)));
    Tv[3] := Vl(FetchElm(RetNo, 'S2', 207)) + Vl(FetchElm(RetNo, 'S2', 341));
    // Tv[4] :=MaxR(0,Tv[2]-Tv[3]);
    Tv[29] := MaxR(0, Tv[2] - Tv[3]); // 20141109
    Tv[6] := Vl(FetchElm(RetNo, 'S2', 473)) + Vl(FetchElm(RetNo, 'S2', 147));
    Tv[7] := Tv[5] + Tv[6];
    Tv[8] := Tv[7];
    Tv[27] := Tv[29] + Tv[8];
    Tv[9] := MaxR(0, Tv[27] - Tv[28]); // MaxR(0,Tv[29]+Tv[8]-Tv[28]);

    // 20141203
    // If UpperCase(Strings[21]) <> 'Y' then Tv[10] := Tv[24];
    Tv[10] := Tv[235]; // 20141203

    Tv[11] := MaxR(0, Tv[9] - Tv[10]);
    // 20141109
    If Tv[30] > Tv[10] then
      Tv[30] := Tv[10];
    Tv[31] := Round(Tv[30] * 25 / 100);

    if Tv[4] > Tv[10] then
      Tv[4] := Tv[10];
    Tv[45] := Round(Tv[4] * 25 / 100);

    if Tv[46] > Tv[10] then
      Tv[46] := Tv[10];
    Tv[47] := Round(Tv[46] * 25 / 100);

  end; { End with }

  // S2 pg 2---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    (*
      {gifts to can}
      Tv[101] :=  MaxR(0,Vl(FetchElm(RetNo,'S2',268))
      - Vl(FetchElm(RetNo,'S2',264)));
      Tv[102] :=  Vl(FetchElm(RetNo,'S2',241));
      //Tv[103] := MaxR(0,Tv[101]-Tv[102]);
      Tv[126]:=MaxR(0,Tv[101]-Tv[102]); //Tv[103];
      Tv[105] := Vl(FetchElm(RetNo,'S2',489));
      Tv[106] := Tv[104]+Tv[105];
      Tv[127]:=Tv[106];
      Tv[44]:=Tv[126]+Tv[127];
      //Tv[129]:=MaxR(0,Tv[126]+Tv[127]-Tv[128]);
      //20141203
      //If UpperCase(Strings[158]) <> 'Y' then Tv[107] := Vl(FetchElm(RetNo,'S2',269));
      Tv[107] := Vl(FetchElm(RetNo,'S2',269));

      Tv[32]:=Tv[128]+Tv[107];
      Tv[33]:=Tv[32];
      Tv[108] :=MaxR(0,Tv[44]-Tv[33]); //MaxR(0,Tv[129]-Tv[107]);
    *)
    { cultural to can }
    Tv[109] := MaxR(0, Vl(FetchElm(RetNo, 'S2', 302)) -
      Vl(FetchElm(RetNo, 'S2', 298)));
    Tv[110] := Vl(FetchElm(RetNo, 'S2', 275));
    // Tv[111] := MaxR(0,Tv[109]-Tv[110]);
    Tv[130] := MaxR(0, Tv[109] - Tv[110]); // Tv[111];
    Tv[113] := Vl(FetchElm(RetNo, 'S2', 505));
    Tv[114] := Tv[112] + Tv[113];
    Tv[131] := Tv[114];
    Tv[34] := Tv[130] + Tv[131]; // 20141109

    // 20141203
    // If UpperCase(Strings[159]) <> 'Y' then Tv[115] := Vl(FetchElm(RetNo,'S2',303));
    Tv[115] := Vl(FetchElm(RetNo, 'S2', 303));

    Tv[35] := Tv[132] + Tv[115];
    Tv[36] := Tv[35];
    Tv[116] := MaxR(0, Tv[34] - Tv[36]); // MaxR(0,Tv[133]-Tv[115]);
    { ecological }
    Tv[117] := MaxR(0, Vl(FetchElm(RetNo, 'S2', 336)) -
      Vl(FetchElm(RetNo, 'S2', 332)));
    Tv[118] := Vl(FetchElm(RetNo, 'S2', 309));
    // Tv[119] := MaxR(0,Tv[117]-Tv[118]);
    Tv[134] := MaxR(0, Tv[117] - Tv[118]); // Tv[119];
    // Tv[121] := Vl(FetchElm(RetNo,'S2',528)); //20190421 Tv[37] := Vl(FetchElm(RetNo,'S2',521));
    Tv[122] := Tv[120] + Tv[37]; // 20141109
    Tv[135] := Tv[122];
    Tv[38] := Tv[134] + Tv[135];
    // 20141203
    // If UpperCase(Strings[160]) <> 'Y' then Tv[123] := Vl(FetchElm(RetNo,'S2',337));
    Tv[123] := Vl(FetchElm(RetNo, 'S2', 337));

    Tv[39] := Tv[136] + Tv[123];
    Tv[40] := Tv[39];
    Tv[124] := MaxR(0, Tv[38] - Tv[40]); // Tv[124] := MaxR(0,Tv[137]-Tv[123]);

    // medicine
    Tv[141] := MaxR(0, Tv[138] - Tv[139]);
    // Tv[141]:=Tv[140];
    Tv[145] := MaxR(0, Tv[143] - Tv[144]);
    Tv[146] := Round(Tv[145] * 50 / 100);
    // Tv[147]:=??
    Tv[148] := MinR(Tv[144], Tv[146]);
    Tv[149] := Tv[147];
    Tv[150] := Tv[143];
    If Tv[150] > 0 then
      Tv[151] := Tv[148] * Tv[149] / Tv[150]
    else
      Tv[151] := 0;
    Tv[152] := Tv[142] + Tv[151];
    Tv[153] := Tv[152];
    Tv[41] := Tv[141] + Tv[153];

    // 20141203
    // If UpperCase(Strings[161]) <> 'Y' then Tv[156]:=Tv[41];
    Tv[156] := Tv[373];

    Tv[42] := Tv[154] + Tv[156];
    Tv[43] := Tv[42];
    Tv[157] := MaxR(0, Tv[41] - Tv[43]); // MaxR(0,Tv[155]-Tv[156]);

    // 20170612
    // Part 6 - summary
    i := 551;
    j := 204;
    Repeat
      Strings[i] := Strings[j];
      Inc(i, 6);
      Inc(j, 5);
    Until i > 581; // dates
    i := 552;
    j := 208;
    Repeat
      Tv[i] := Tv[j];
      Inc(i, 6);
      Inc(j, 5);
    Until i > 582;
    Tv[587] := Tv[237]; // CR don
    i := 553;
    j := 276;
    Repeat
      Tv[i] := Tv[j];
      Inc(i, 6);
      Inc(j, 5);
    Until i > 583;
    Tv[588] := Tv[305]; // cultural
    i := 555;
    j := 310;
    Repeat
      Tv[i] := Tv[j];
      Inc(i, 6);
      Inc(j, 5);
    Until i > 585;
    Tv[590] := Tv[339]; // cultural after feb 14
    i := 554;
    j := 242;
    Repeat
      Tv[i] := Tv[j];
      Inc(i, 6);
      Inc(j, 5);
    Until i > 584;
    Tv[589] := Tv[271]; // cultural bfr feb 11
    i := 556;
    j := 346;
    Repeat
      Tv[i] := Tv[j];
      Inc(i, 6);
      Inc(j, 5);
    Until i > 591;
    Tv[591] := Tv[375]; // gifts of medicine
    // summaries
  end; { End with }
  // S2 pg 3---------------------------------------------------------------------

  mm := MidStr(GetTaxationYearEnd(RetNo), 6, 2);
  dd := RightStr(GetTaxationYearEnd(RetNo), 2);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 201, 202, 203);
    Yr := GetTaxationYearEndYYYY(RetNo);
    { put years in all categories }
    i := 204;
    k := -5;
    Repeat
      Strings[i] := IntToStr(Yr + k) + '/' + mm + '/' + dd;
      Strings[i + 34] := Strings[i];
      Strings[i + 68] := Strings[i];
      Strings[i + 102] := Strings[i];
      Strings[i + 138] := Strings[i];
      Inc(i, 5);
      k := k + 1;
    until i > 229;

    { current year donations }
    Tv[230] := Vl(FetchElm(RetNo, 'S2', 473));
    Tv[264] := Vl(FetchElm(RetNo, 'S2', 489)) + Vl(FetchElm(RetNo, 'S2', 104));
    Tv[298] := Vl(FetchElm(RetNo, 'S2', 505)) + Vl(FetchElm(RetNo, 'S2', 112));
    Tv[332] := Vl(FetchElm(RetNo, 'S2', 521)) + Vl(FetchElm(RetNo, 'S2', 528)) +
      Vl(FetchElm(RetNo, 'S2', 120)); // 20141116
    // Tv[368] := no details
    { Char don }
    DonLim := Vl(FetchElm(RetNo, 'S2', 24)); { as calculated }
    i := 205;
    Repeat
      If UpperCase(Strings[530]) <> 'Y' then
        Tv[i + 1] := MinR(DonLim, Tv[i]); // 20141202
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      DonLim := MaxR(0, DonLim - Tv[i + 1]);
      Inc(i, 5);
    until i > 230;

    AddS2Spreadsheet(RetNo, FNo, 205, 234);

    Tv[234] := Tv[234] + Tv[340];
    Tv[236] := Tv[236] + Tv[341];
    Tv[341] := Tv[340];
    { Gifts to can }
    DonLim := MaxR(0, MinR(GetTxblIncBeforeDonations(RetNo),
      MinR(Vl(FetchElm(RetNo, 'S2', 129)), GetNetInc(RetNo) - Tv[235])));
    i := 239;
    Repeat
      If UpperCase(Strings[531]) <> 'Y' then
        Tv[i + 1] := MinR(DonLim, Tv[i]); // 20141202
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      DonLim := MaxR(0, DonLim - Tv[i + 1]);
      Inc(i, 5);
    until i > 264;

    AddS2Spreadsheet(RetNo, FNo, 239, 268);

    { Gifts of cultural }
    DonLim := MaxR(0, MinR(GetTxblIncBeforeDonations(RetNo),
      MinR(Vl(FetchElm(RetNo, 'S2', 133)), GetNetInc(RetNo) - Tv[235] -
      Tv[269])));
    i := 273;
    Repeat
      If UpperCase(Strings[532]) <> 'Y' then
        Tv[i + 1] := MinR(DonLim, Tv[i]); // 20141202
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      DonLim := MaxR(0, DonLim - Tv[i + 1]);
      Inc(i, 5);
    until i > 298;

    AddS2Spreadsheet(RetNo, FNo, 273, 302);

    { Gifts of ecological sensitive land }
    DonLim := MaxR(0, MinR(GetTxblIncBeforeDonations(RetNo),
      MaxR(0, GetNetInc(RetNo) - Tv[235] - Tv[269] - Tv[303]))); // 20150422
    // MinR(Vl(FetchElm(RetNo,'S2',137)),GetNetInc(RetNo)-Tv[235]-Tv[269]-Tv[303])));

    i := 307;
    Repeat
      If UpperCase(Strings[533]) <> 'Y' then
        Tv[i + 1] := MinR(DonLim, Tv[i]); // 20141202
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      DonLim := MaxR(0, DonLim - Tv[i + 1]);
      Inc(i, 5);
    until i > 332;

    AddS2Spreadsheet(RetNo, FNo, 307, 336);

    // 20141202
    i := 343;
    Repeat
      If UpperCase(Strings[534]) <> 'Y' then
        Tv[i + 1] := MinR(DonLim, Tv[i]); // 20141202
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      DonLim := MaxR(0, DonLim - Tv[i + 1]);
      Inc(i, 5);
    until i > 368;

    AddS2Spreadsheet(RetNo, FNo, 343, 372);

  end; { End with }
  // S2 pg 4---------------------------------------------------------------------

  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 401, 402, 403);
    i := 406;
    Tv[473] := 0;
    Repeat
      Tv[473] := Tv[473] + Tv[i];
      Inc(i, 3);
    until i > 472;
    Tv[473] := Tv[473] + Tv[522];

    i := 476;
    Tv[489] := 0;
    Repeat
      Tv[489] := Tv[489] + Tv[i];
      Inc(i, 3);
    until i > 488;

    i := 492;
    Tv[505] := 0;
    Repeat
      Tv[505] := Tv[505] + Tv[i];
      Inc(i, 3);
    until i > 504;
    // 20141109
    i := 523;
    Tv[528] := 0;
    Repeat
      Tv[528] := Tv[528] + Tv[i];
      Inc(i, 1);
    until i > 527;

    i := 508;
    Tv[521] := 0;
    Repeat
      Tv[521] := Tv[521] + Tv[i];
      Inc(i, 3);
    until i > 520;

  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

// 20200127 brought from T2-2019
// 20161106  Replaced due to extensive form changes
procedure S3(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, K210, K220, K240, K242, { K241, } K250, K260, K265, { K270, } K275
    : integer;
  kApply: integer; // pinters /subscripts for columns
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Tv[144] := 0;
    Tv[145] := 0;
    Tv[146] := 0;
    Tv[147] := 0;
    Tv[148] := 0; // 20190704
    Tv[149] := 0;
    Tv[150] := 0;
    Tv[153] := 0;
    Tv[154] := 0;
    Tv[112] := 0; // 20190710
    Tv[114]:=0;    //20230815

    K210 := 6;
    K220 := 7;
    kApply := 100;
    K240 := 9;
    K242 := 119;
    /// /K241:=119; //20190704
    K250 := 10;
    K260 := 11;
    K275 := 129;
    K265 := 12; // K270:=12; //20190704
    Repeat
      If Tv[K240] < 0 then
        Tv[K240] := 0; // not negative
      If Strings[K265 - 8] = '' then
        Strings[K265 - 7] := '';
      // 20120530 if no name then  no code 1 or 2 //270 -> 265
      if Tv[K242] > Tv[K240] then
        Tv[K242] := Tv[K240];
      // 20190704  //if Tv[K241]>Tv[K240] then Tv[K241]:=Tv[K240];

      If Strings[K210 - 1] = '1' then { connected }
      begin
        if Tv[K250] > 0 then
          Tv[K265] := Round(Tv[K242] * Tv[K260] / Tv[K250])
          // Round((Tv[K241]* Tv[K260]) / Tv[K250])
        Else
          Tv[265] := 0; // 20190709
        if Tv[K250] = 0 then
          Tv[K265] := 0; // 20190809

        if Tv[K250] > 0 then
          Tv[K275] := Round(Tv[K260] * Tv[K240] / Tv[K250])
        Else
          Tv[K275] := 0;
        // 20170704 //Tv[K275]:=Round(Tv[K260] * (Tv[K240]-Tv[K241])/Tv[K250]) Else Tv[k275]:=0;  //20170630

        if UpperCase(Strings[kApply]) = 'N' then // no IV tax  //20211006
        begin
          Tv[K265] := 0;
          Tv[K275] := 0;
        end;
        // 20190427
        Tv[144] := Tv[144] + Tv[K240];
        // Tv[145]:=Tv[145]+Tv[K240]; //20220622 {connected}
        Tv[147] := Tv[147] + Tv[K242]; // Tv[K241]; //20190704
        Tv[149] := Tv[149] + Tv[K275];
        Tv[153] := Tv[153] + Tv[K265]; // 20190704
        Tv[112] := Tv[112] + Tv[K240]; //
        Tv[114] := Tv[114]+Tv[K240];   //20230815
      end
      else // NON connected '' or '2'?
      begin
        Strings[K210] := '';
        Strings[K220] := ''; // bn and tax year end
        Tv[K250] := 0;
        Tv[K260] := 0; // paid by connected
        Tv[K265] := Round(Tv[K242] * 38.33333 / 100);
        // 20161113 //Round(Tv[K241] * 1/3);   //20190704
        Tv[K275] := Round(Tv[K240] * 38.33333 / 100);
        // 20190704//Round((Tv[K240]-Tv[K241]) * 38.33333/100);
        // 20190709  moved from below
        If UpperCase(Strings[kApply]) = 'N' then
        begin
          Tv[K265] := 0;
          Tv[K275] := 0;
        end;
        If IsTaxExempt(RetNo) then
        Begin
          Tv[K265] := 0;
          Tv[K275] := 0;
        end;

        Tv[145] := Tv[145] + Tv[K240]; // 20220622
        Tv[148] := Tv[148] + Tv[K242]; // Tv[148]+Tv[K241];  //20190704
        Tv[150] := Tv[150] + Tv[K275];
        Tv[154] := Tv[154] + Tv[K265];
      end;
      // 20190709
      { move above
        If UpperCase(Strings[KApply])='N' then begin Tv[K265]:=0;Tv[K275]:=0;end;
        If IsTaxExempt(RetNo) then Begin Tv[K265]:=0;Tv[k275]:=0;end;
      }
      Inc(kApply, 1);
      Inc(K210, 9);
      Inc(K220, 9);
      Inc(K240, 9);
      Inc(K242, 1); // Inc(k241,1);
      Inc(K250, 9);
      Inc(K260, 9);
      Inc(K265, 9);
      Inc(K275, 1);
    until K265 > 93;

    Tv[146] := Tv[144] + Tv[145]; // 20190427
    Tv[94] := AddColumns(8, 89, 9);
    Tv[112]:= AddColumns(9,90,9); // 20230609
    Tv[99] := AddColumns(119, 128, 1); // 20190708
    // second page
    Tv[96] := AddColumns(10, 91, 9);
    Tv[97] := AddColumns(11, 92, 9);
    Tv[98] := AddColumns(12, 93, 9);
    Tv[139] := AddColumns(129, 138, 1);
    Tv[191] := AddColumns(181, 190, 1);
  end; { End with }
  // Part 2 ---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[151] := Tv[149] + Tv[150];
    Tv[152] := Tv[151];
    Tv[155] := Tv[153] + Tv[154];
    Tv[156] := Tv[155];
    Tv[157] := MaxR(0, Tv[152] - Tv[156]);


    Tv[262] := Tv[152]; // Tv[98];
    Tv[201] := Vl(FetchElm(RetNo, 'S43', 131));
    // 20190626  //Vl(FetchElm(RetNo,'S43',128));  //20190421
    Tv[110] := MaxR(0, Tv[262] - Tv[201]);
    Tv[111] := Tv[110];
  
   Tv[203] := Vl(FetchElm(RetNo, 'S4WS', 652));
   //why removed the below?  ceck profile
   if UpperCase(Strings[113])<>'Y'  then  //20230214
      Tv[204] := MaxR(0, Vl(FetchElm(RetNo, 'S4', 22))); //20240122
   Tv[205] := Vl(FetchElm(RetNo, 'S4', 124)); //20240122

   Tv[207]:=Tv[203]+Tv[204]+Tv[205]+Tv[206]; //20240122
   Tv[158]:=Round((Tv[207] * 38.3334)/100);  //20240226


   Tv[209] := MaxR(0, Tv[111] - Tv[158]);  //20230815

   if GetBegYearEnd(RetNo) > '2018/12/31' Then
    Begin
      Tv[159] := Tv[191]; // Tv[149];  //20210517
      Tv[160] := Vl(FetchElm(RetNo, 'S43', 22));
      Tv[161] := MaxR(0, Tv[159] - Tv[160]);
      // part of pg3
      Tv[162] := Tv[154];
      Tv[163] := Vl(FetchElm(RetNo, 'S43', 38));
      Tv[164] := MaxR(0, Tv[162] - Tv[163]); // 20190704
    End
    Else
    Begin
      Tv[159] := 0;
      Tv[160] := 0;
      Tv[161] := 0;
      // 20190708
      Tv[162] := 0;
      Tv[163] := 0;
      Tv[164] := 0;
    End;

  // part 3  ----------------------------
    i := 213;
    j := 165;
    Tv[250] := 0;
    Tv[95] := 0;
    Repeat
      Tv[250] := Tv[250] + Tv[i];
      Tv[95] := Tv[95] + Tv[j];
      Inc(i, 4);
      Inc(j, 1);
    until i > 249;

    Tv[252] := Tv[250] + Tv[251];
    Tv[175] := Tv[95] + Tv[143];
    Tv[176] := MaxR(0, Tv[252] - Tv[175]);
    Tv[177] := Round(Tv[175] * 38.33334 / 100);
    Tv[178] := Round(Tv[176] * 38.33334 / 100);
  //----------------------------------------------
   {
   // pg3
   if Strings[115]>'' then  //20250918
   Begin
    i := 213;
    j := 165;
    Tv[250] := 0;
    Tv[95] := 0;
    Repeat
      Tv[250] := Tv[250] + Tv[i];
      Tv[95] := Tv[95] + Tv[j];
      Inc(i, 4);
      Inc(j, 1);
    until i > 249;

    Tv[252] := Tv[250] + Tv[251];
    Tv[175] := Tv[95] + Tv[143];
    Tv[176] := MaxR(0, Tv[252] - Tv[175]);
    Tv[177] := Round(Tv[175] * 38.33334 / 100);
    Tv[178] := Round(Tv[176] * 38.33334 / 100);
   End
   Else
   Begin
    for i:=210 to 249 do Begin Ret[RetNo].Frm[FNo].Strings[i]:='';Tv[i]:=0; end;
    for i:=165 to 177 do Begin Tv[i]:=0; end;
    Tv[95]:=0;
    Tv[143]:=0;
    for i:=251 to 252 do Begin Tv[i]:=0; end;
   End;
  }
    // Part 4
    Tv[259] := 0;
    For i := 254 to 257 do
      Tv[259] := Tv[259] + Tv[i];
    Tv[260] := Tv[259];

    If Tv[259] <> 0 then
    begin
      Tv[253] := Tv[252] + Tv[259];
      Tv[260] := Tv[259];
      Tv[261] := MaxR(0, Tv[253] - Tv[260]);
    end
    else
    begin
      Tv[253] := 0;
      Tv[261] := 0;
    end;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure S4(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, k, S4WSFNo: integer;
  x: Real;
  Yr: integer;
  TxblGains, RemGains, NetApplied, Adjusted, Faktor, TxblIncome,
    FarmIncome: Real;
  AutoSw: Boolean;
  TaxationMMDD: String;
  ThisYearEnd: String;
begin
  S4WSFNo := GetFormNo('S4WS');
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    For i := 23 to 32 do // 20110924
    begin
      If Tv[i] < 0 then
        Tv[i] := 0;
    end;
    Tv[4] := GetNetInc(RetNo);
    Tv[5] := Vl(FetchElm(RetNo, 'T2', 222));
    { net cap losses deducted this yr? }
    Tv[6] := Vl(FetchElm(RetNo, 'T2', 219));
    Tv[7] := Vl(FetchElm(RetNo, 'T2', 220));
    Tv[8] := Vl(FetchElm(RetNo, 'T2', 227));
    Tv[9] := Vl(FetchElm(RetNo, 'T2', 228));
    Tv[42] := Tv[5] + Tv[6] + Tv[7] + Tv[9] + Tv[44]; // 20210616
    Tv[10] := Tv[42]; // Tv[5]+Tv[6]+Tv[7]+Tv[9];    //20210616
    Tv[36] := Tv[4] - Tv[10];
    If Tv[36] > 0 then
      Tv[36] := 0;
    Tv[11] := Vl(FetchElm(RetNo, 'T2', 231));
    Tv[12] := Tv[36] - Tv[11];

    x := TotMultiple(RetNo, 'S125', 35); { 63 }
    // TotGifiMultiple(RetNo,'GIFIIS','9899');  {63}  //20150826
    If x < 0 then
      Tv[13] := ABS(x)
    else
      Tv[13] := 0;
    If Tv[37] > 0 then
      Tv[13] := Tv[37];
    Tv[14] := Tv[12] + Tv[13];
    If Tv[39] > Tv[13] then
      Tv[39] := Tv[13];
    If Tv[14] > 0 then
      Tv[14] := 0; { no loss }

    Tv[15] := MaxR(0, Vl(FetchElmFNo(RetNo, S4WSFNo, 656)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 649)));
    // Vl(FetchElmFNo(RetNo,S4WSFNo,502))

    Tv[16] := Vl(FetchElmFNo(RetNo, S4WSFNo, 660));

    Tv[21] := MaxR(0, Vl(FetchElmFNo(RetNo, S4WSFNo, 658)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 651)));
    Tv[22] := Vl(FetchElmFNo(RetNo, S4WSFNo, 659));

    Tv[17] := MaxR(0, Tv[15] - Tv[16]);
    Tv[8] := Tv[17];
    Tv[18] := Vl(FetchElmFNo(RetNo, S4WSFNo, 657));
    Tv[19] := ABS(Tv[14]);
    Tv[35] := Tv[18] + Tv[19];
    Tv[20] := Tv[35];
    Tv[38] := Tv[8] + Tv[20];
    Tv[25] := Tv[21] + Tv[22] + Tv[23] + Tv[24];
    Tv[26] := Tv[25];
    Tv[40] := MaxR(0, Tv[38] - Tv[26]);
    If Tv[30] < 0 then
      Tv[30] := 0;
    If Tv[14] > 0 then
    begin
      For i := 27 to 32 do
        Tv[i] := 0;
    end;

    Tv[33] := 0;
    For i := 27 to 32 do
      Tv[33] := Tv[33] + Tv[i];
    Tv[41] := Tv[33];
    Tv[34] := MaxR(0, Tv[40] - Tv[41]);
  end; { End with }
  // S4 pg 2---------------------------------------------------------------------

  with Ret[RetNo].Frm[FNo] do
  begin
    // 20110924
    If Tv[101] < 0 then
      Tv[101] := 0;
    If Tv[102] < 0 then
      Tv[102] := 0;
    If Tv[110] < 0 then
      Tv[110] := 0;
    If Tv[109] < 0 then
      Tv[109] := 0;
    If Tv[151] < 0 then
      Tv[151] := 0;
    If Tv[152] < 0 then
      Tv[152] := 0;
    If Tv[112] < 0 then
      Tv[112] := 0;
    If Tv[113] < 0 then
      Tv[113] := 0;
    If Tv[114] < 0 then
      Tv[114] := 0;
    If Tv[120] < 0 then
      Tv[120] := 0;
    If Tv[125] < 0 then
      Tv[125] := 0;
    If Tv[126] < 0 then
      Tv[126] := 0;
    For i := 129 to 134 do
    begin
      If Tv[i] < 0 then
        Tv[i] := 0;
    end;

    Tv[137] := Tv[101] + Tv[102];
    Tv[105] := Tv[137];
    Tv[138] := Tv[110] + Tv[109];
    Tv[136] := Tv[138];
    Tv[150] := MaxR(0, Tv[105] - Tv[136]); // -Tv[49];  //20090629

    // 20140511
    Tv[103] := ABS(Vl(FetchElm(RetNo, 'S6', 697)));
    Tv[153] := MinR(Tv[151], Tv[152]);
    Tv[106] := Tv[153] * 2; // Vl(Strings[104]);  //20160709
    Tv[107] := Tv[150] + Tv[103] + Tv[106];

    {
      x:=Vl(FetchElm(RetNo,'S6',678)); If x<0 then x:=0; //txbl cap gains this year
      If Tv[108]>MinR(Tv[107],x) then Tv[108]:=MinR(Tv[107],x); //least of txb gains this year and cap losses
      Tv[108]:=MinR(Tv[108],GetTxblIncBfrNetCapLosses(RetNo)*2);
    }
    x := Vl(FetchElm(RetNo, 'S6', 678));
    If x < 0 then
      x := 0; // txbl cap gains this year
    If Tv[108] > MinR(Tv[107], x) then
      Tv[108] := MinR(Tv[107], x);
    // least of txb gains this year and cap losses
    Tv[108] := MinR(Tv[108], GetTxblIncBfrNetCapLosses(RetNo) * 2);
    If UpperCase(Strings[146]) = 'Y' then
      Tv[108] := Tv[147]; // 20140920

    Tv[111] := MaxR(0, Tv[107] - Tv[108]);
    Tv[115] := Tv[112] + Tv[113] + Tv[114];
    Tv[139] := Tv[115];
    Tv[116] := MaxR(0, Tv[111] - Tv[139]);
    { farm loss }

    Tv[117] := MaxR(0, Vl(FetchElmFNo(RetNo, S4WSFNo, 817)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 810)));
    // Vl(FetchElmFNo(RetNo,S4WSFNo,663))
    Tv[118] := Vl(FetchElmFNo(RetNo, S4WSFNo, 821));

    Tv[123] := MaxR(0, Vl(FetchElmFNo(RetNo, S4WSFNo, 819)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 812)));
    Tv[124] := MaxR(0, Vl(FetchElmFNo(RetNo, S4WSFNo, 820)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 813)));

    Tv[119] := MaxR(0, Tv[117] - Tv[118]);
    Tv[142] := Tv[119];
    // figure out farming loss
    Tv[121] := MaxR(0, Vl(FetchElm(RetNo, 'S4', 13)) -
      Vl(FetchElm(RetNo, 'S4', 39)));
    If Tv[121] > ABS(Vl(FetchElm(RetNo, 'S4', 12))) then
      Tv[121] := ABS(Vl(FetchElm(RetNo, 'S4', 12)));

    Tv[120] := Vl(FetchElmFNo(RetNo, S4WSFNo, 818));
    Tv[122] := Tv[120] + Tv[121];
    Tv[143] := Tv[122];
    Tv[144] := Tv[142] + Tv[143];

    Tv[127] := 0;
    For i := 123 to 126 do
      Tv[127] := Tv[127] + Tv[i];
    Tv[140] := Tv[127];
    Tv[128] := MaxR(0, Tv[144] - Tv[140]);

    Tv[145] := 0;
    For i := 129 to 134 do
      Tv[145] := Tv[145] + Tv[i];
    Tv[141] := Tv[145];
    Tv[135] := MaxR(0, Tv[128] - Tv[141]);

  end; { End with }

  // S4 pg 3---------------------------------------------------------------------

  with Ret[RetNo].Frm[FNo] do
  begin
    // restricted farm loss
    Tv[236] := Vl(FetchElm(RetNo, 'S4', 39));
    If Tv[208] < 0 then
      Tv[208] := 0;
    If Tv[209] < 0 then
      Tv[209] := 0;
    For i := 212 to 214 do
    begin
      If Tv[i] < 0 then
        Tv[i] := 0;
    end; // 20110924
    For i := 217 to 219 do
    begin
      If Tv[i] < 0 then
        Tv[i] := 0;
    end; // 20110924
    If Tv[223] < 0 then
      Tv[223] := 0;
    For i := 226 to 228 do
    begin
      If Tv[i] < 0 then
        Tv[i] := 0;
    end; // 20110924

    Tv[247] := 2500; // 20210622
    // 20131005
    If Tv[236] <> 0 then // 20110610
    begin
      Tv[238] := Tv[236];
      Tv[239] := MaxR(0, Tv[238] - 2500) / 2;
      If GetTaxationYearEnd(RetNo) < '2013/03/21' then
        Tv[240] := MinR(6250, Tv[239])
      Else
        Tv[240] := MinR(15000, Tv[239]);

      Tv[241] := Tv[240];
      Tv[247] := 2500;
      // If Tv[241]>Tv[239] then Tv[240]:=Tv[239];
      Tv[43] := Tv[241] + Tv[247];
      Tv[242] := Tv[43];
      Tv[243] := MaxR(0, Tv[236] - Tv[242]);
    end
    else
    begin
      For i := 238 to 243 do
        Tv[i] := 0;
      Tv[43] := 0;
    end;

    Tv[201] := MaxR(0, Vl(FetchElmFNo(RetNo, S4WSFNo, 978)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 971)));
    // Vl(FetchElmFNo(RetNo,S4WSFNo,824))
    Tv[202] := Vl(FetchElmFNo(RetNo, S4WSFNo, 982));
    Tv[203] := MaxR(0, Tv[201] - Tv[202]);
    Tv[231] := Tv[203];

    Tv[205] := Tv[243];
    Tv[204] := Vl(FetchElmFNo(RetNo, S4WSFNo, 979));
    Tv[206] := Tv[204] + Tv[205];
    Tv[232] := Tv[206];
    Tv[233] := Tv[231] + Tv[232];

    Tv[207] := MaxR(0, Vl(FetchElmFNo(RetNo, S4WSFNo, 980)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 973)));
    If Tv[208] < 0 then
      Tv[208] := 0;
    If Tv[209] < 0 then
      Tv[209] := 0;
    Tv[210] := Tv[207] + Tv[208] + Tv[209];
    Tv[234] := Tv[210];
    Tv[211] := MaxR(0, Tv[233] - Tv[234]);

    Tv[215] := Tv[212] + Tv[213] + Tv[214];
    Tv[235] := Tv[215];
    Tv[216] := MaxR(0, Tv[211] - Tv[235]);
    //=== end of page 4
    { listed pers }

    //page 5
    Tv[217] := MaxR(0, +Vl(FetchElmFNo(RetNo, S4WSFNo, 93)) -
      Vl(FetchElmFNo(RetNo, S4WSFNo, 87))); // Vl(FetchElmFNo(RetNo,S4WSFNo,98))
    Tv[218] := Vl(FetchElmFNo(RetNo, S4WSFNo, 96));

    Tv[219] := MaxR(0, Tv[217] - Tv[218]);
    Tv[244] := Tv[219];
    If Vl(FetchElm(RetNo, 'S6', 533)) < 0 then
      Tv[220] := ABS(Vl(FetchElm(RetNo, 'S6', 533)))
    else
      Tv[220] := 0;
    Tv[221] := Tv[244] + Tv[220];

    Tv[222] := MinR(Vl(FetchElm(RetNo, 'S6', 633)), Tv[221]);
    Tv[224] := Tv[222] + Tv[223];
    Tv[245] := Tv[224];
    Tv[225] := MaxR(0, Tv[221] - Tv[245]);

    Tv[230] := Tv[226] + Tv[227] + Tv[228];
    Tv[246] := Tv[230];
    Tv[229] := MaxR(0, Tv[225] - Tv[246]);
  end; { End with }


  //page 6
  with Ret[RetNo].Frm[FNo] do
  begin
    i := 307;
    Tv[336] := 0;
    Repeat
      If Tv[i - 4] < 0 then
        Tv[i - 4] := 0; // 20110924
      If Tv[i - 3] < 0 then
        Tv[i - 3] := 0; // 20110924
      If Tv[i - 2] < 0 then
        Tv[i - 2] := 0; // 20110924
      Tv[i - 1] := MaxR(0, Tv[i - 3] - Tv[i - 2]);
      Tv[i] := MaxR(0, Tv[i - 4] - Tv[i - 1]);
      Tv[336] := Tv[336] + Tv[i];
      Inc(i, 7);
    until i > 335;

    i := 342;
    Repeat
      If Tv[i - 3] < 0 then
        Tv[i - 3] := 0; // 20110924
      If Tv[i - 2] < 0 then
        Tv[i - 2] := 0; // 20110924
      If Tv[i - 1] < 0 then
        Tv[i - 1] := 0; // 20110924
      Tv[i] := MaxR(0, Tv[i - 2] - Tv[i - 1]);
      Tv[i + 1] := MinR(Tv[i - 3], Tv[i]);
      Inc(i, 7);
    until i > 370;

    i := 301;
    Repeat
      Strings[i + 36] := Strings[i];
      Strings[i + 37] := Strings[i + 1];
      Strings[i + 71] := Strings[i];
      Strings[i + 72] := Strings[i + 1];
      Inc(i, 7);
    until i > 329;

    Tv[407] := 0;
    Tv[408] := 0;
    Tv[409] := 0; // 20121211
    k := 0;
    For i := 301 to 305 do // for 5 lines varying K
    begin
      Tv[373 + k] := Tv[339 + k]; // addedd 300 to xx+k  //20110929
      Tv[375 + k] := Tv[307 + k];
      If Strings[410] <> 'Y' then
        Tv[376 + k] := MinR(Tv[343 + k], GetFedTxblBfrLosses(RetNo, FNo));
      Tv[377 + k] := MaxR(0, Tv[373 + k] + Tv[374 + k] + Tv[375 + k] -
        Tv[376 + k]);
      Tv[407] := Tv[407] + Tv[376 + k];
      Tv[408] := Tv[408] + Tv[377 + k];
      Tv[409] := Tv[409] + Tv[373 + k];
      Inc(k, 7);
    end;
  end; { End with }
  //emd of page 6
  // S4 pg 5 Loss Analysis---------------------------------------------------------------------
  ThisYearEnd := GetTaxationYearEnd(RetNo);
  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  Begin
    k := 20; // 20130929
    i := 501;
    Repeat
      Frm[FNo].Strings[i] := GetPrevYearEnd(ThisYearEnd, k);
      Inc(i, 5);
      k := k - 1;
    until i > 601;

    For i := 607 to 610 do
      Tv[i] := 0; // totals
    // Non cap loss
    i := 502;
    j := 514; // not 507
    Repeat
      Tv[i] := Vl(FetchElmFNo(RetNo, S4WSFNo, j)); // Non caploss
      Tv[607] := Tv[607] + Tv[i];
      Inc(i, 5);
      Inc(j, 7)
    until i > 602;

    // Farm loss
    i := 503;
    j := 675; // second row
    Repeat
      Tv[i] := Vl(FetchElmFNo(RetNo, S4WSFNo, j)); // Non caploss
      Tv[608] := Tv[608] + Tv[i];
      Inc(i, 5);
      Inc(j, 7)
    until i > 603;

    // Restr Farm loss
    i := 504;
    j := 836; // second row
    Repeat
      Tv[i] := Vl(FetchElmFNo(RetNo, S4WSFNo, j)); // Non caploss
      Tv[609] := Tv[609] + Tv[i];
      Inc(i, 5);
      Inc(j, 7)
    until i > 604;

    // Listed  property
    i := 570;
    j := 49;
    Repeat
      Tv[i] := Vl(FetchElmFNo(RetNo, S4WSFNo, j)); // Non caploss
      Tv[610] := Tv[610] + Tv[i];
      Inc(i, 5);
      Inc(j, 6);
    until i > 605;

    (*
      //????  listed properties  //20131027
      Yr :=GetTaxationYearEndYYYY(RetNo)-7;
      i := 44;
      Repeat
      Frm[FNo].Strings[i] := IntToStr(Yr)+TaxationMMDD;;
      Inc(i,6);
      Yr := Yr+1;
      until i > 86;
      Frm[FNo].Strings[92]:=GetPrevYearEnd(Frm[FNo].Strings[44],1);
      Tv[99]:=Tv[98];

      {apply Listed property}
      If AutoSw then
      begin
      i := 45;
      Repeat
      Tv[i+2] := MinR(Tv[i]+Tv[i+1]-Tv[i+3], TxblIncome);
      TxblIncome := MaxR(0,TxblIncome- Tv[i+2]);
      Inc(i,6);
      until i>81;
      end;
    *)

    (*
      {calc listed prop losses}
      i:= 45;
      repeat
      Tv[i+4] := MaxR(0,Tv[i]+Tv[i+1] - Tv[i+2]-Tv[i+3]);
      Inc(i,6);
      until i>87;
      Tv[93] := AddColumns(45,87,6);
      Tv[94] := AddColumns(46,88,6);
      Tv[95] := AddColumns(47,89,6);
      Tv[96] := AddColumns(48,90,6);
      Tv[97] := AddColumns(49,91,6);
      //Tv[91] := MaxR(0,Tv[87]+Tv[88] - Tv[89]);
    *)


    //RIFE  part 8  //20250624
    Tv[49]:=Tv[46]+Tv[47]+Tv[48];
    Tv[50]:=Tv[49];
    Tv[51]:=VL(FetchElm(RetNo,'S130',459));//20260625cz  //20260625//VL(FetchElm(RetNo,'S4',51])); //20260625
    //TV[52];
    Tv[53]:=MaxR(0,Tv[50]+Tv[51]-Tv[52]);

  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure S4WS(RetNo: integer; FName: string; FNo: integer);
Var
  i, k, S4FNo, Yr: integer;
  x: Real;
  TxblGains, RemGains, NetApplied, Adjusted, Faktor, TxblIncome,
    FarmIncome: Real; // Yr: integer;
  AutoSw: Boolean;
  ThisYearEnd: String;
begin
  S4FNo := GetFormNo('S4');
  ThisYearEnd := GetTaxationYearEnd(RetNo);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  Begin
    If Frm[FNo].Strings[500] = '' then
      Frm[FNo].Strings[500] := 'Y'; // 20130929
    If UpperCase(Frm[FNo].Strings[500]) = 'N' then
      AutoSw := False
    else
      AutoSw := True;

    k := 21; // 20130929
    i := 501;
    Repeat
      Frm[FNo].Strings[i] := GetPrevYearEnd(ThisYearEnd, k);
      Inc(i, 7);
      k := k - 1;
    until i > 648;
    Tv[506] := Tv[502]; // Tv[732]:=Tv[731];  //20130929  expiry
    { Enter years in non farm loss }
    k := 21;
    i := 662;
    Repeat
      If Tv[i + 11] < 0 then
        Tv[i + 11] := 0; // 20110924
      If Tv[i + 13] < 0 then
        Tv[i + 13] := 0; // 20110924
      Frm[FNo].Strings[i] := GetPrevYearEnd(ThisYearEnd, k);
      Inc(i, 7);
      k := k - 1; // Yr := Yr+1;
    until i > 809;
    Tv[667] := Tv[663]; // 20130929   expiry

    { Enter years in restr farm loss }
    k := 21;
    i := 823;
    Repeat
      Frm[FNo].Strings[i] := GetPrevYearEnd(ThisYearEnd, k); // IntToStr(Yr);
      Inc(i, 7);
      k := k - 1;
    until i > 970;
    Tv[828] := Tv[824]; // expiry
    { current year loss }
    If Vl(FetchElmFNo(RetNo, S4FNo, 14)) < 0 then
      Tv[649] := ABS(Vl(FetchElmFNo(RetNo, S4FNo, 14))) { non-cap }
    else
      Tv[649] := 0;

    Tv[810] := Vl(FetchElmFNo(RetNo, S4FNo, 121)); { current yr farm cap }
    Tv[971] := Vl(FetchElmFNo(RetNo, S4FNo, 243));
    { current yr restr farm loss }

    { Loss C/B }
    Tv[651] := Vl(FetchElmFNo(RetNo, S4FNo, 27)) { non-cap }
      + Vl(FetchElmFNo(RetNo, S4FNo, 28)) + Vl(FetchElmFNo(RetNo, S4FNo, 29)) +
      Vl(FetchElmFNo(RetNo, S4FNo, 30)) { non-cap c/b part iv-4 }
      + Vl(FetchElmFNo(RetNo, S4FNo, 31)) + Vl(FetchElmFNo(RetNo, S4FNo, 32));
    // If Tv[652] > Vl(FetchElm(RetNo,'S3',95)) then Tv[652] := Vl(FetchElm(RetNo,'S3',95)); {max is div part iv}  //20190713

    Tv[812] := Vl(FetchElmFNo(RetNo, S4FNo, 129)) { farm loss carry back }
      + Vl(FetchElmFNo(RetNo, S4FNo, 130)) + Vl(FetchElmFNo(RetNo, S4FNo, 131));

    If Tv[813] > Tv[810] then
      Tv[813] := Tv[810];
    Tv[973] := Vl(FetchElmFNo(RetNo, S4FNo, 215)); { restr farm }

    // listed properties
    k := 7;
    i := 44;
    Repeat
      Frm[FNo].Strings[i] := GetPrevYearEnd(ThisYearEnd, k);
      // IntToStr(Yr)+TaxationMMDD;;
      Inc(i, 6);
      k := k - 1;
    until i > 86;
    Frm[FNo].Strings[92] := GetPrevYearEnd(Frm[FNo].Strings[44], 1);

    Tv[99] := Tv[98];

    { calc txbl income against wich to apply non cap/farm losses }
    TxblIncome := GetTxblIncBfrLosses(RetNo);

    { apply non cap losses }
    If AutoSw then
    begin
      i := 509;
      Repeat
        Tv[i + 2] := MinR(Tv[i] + Tv[i + 1] - Tv[i + 3] - Tv[i + 4],
          TxblIncome);
        TxblIncome := MaxR(0, TxblIncome - Tv[i + 2]);
        Inc(i, 7);
      until i > 642;
    end;

    { apply farm losses }
    If AutoSw then
    begin
      i := 670;
      Repeat
        Tv[i + 2] := MinR(Tv[i] + Tv[i + 1] - Tv[i + 3] - Tv[i + 4],
          TxblIncome);
        TxblIncome := MaxR(0, TxblIncome - Tv[i + 2]);
        Inc(i, 7);
      until i > 803;
    end;

    { apply restricted farm losses }
    FarmIncome := TotMultiple(RetNo, 'S125', 35); { 63 }
    // TotGifiMultiple(RetNo,'GIFIIS','9899'); {63}  //20150826
    If FarmIncome < 0 then
      FarmIncome := 0; { apply only if positive farm income }
    If AutoSw then
    begin
      i := 831;
      Repeat
        Tv[i + 2] := MinR(Tv[i] + Tv[i + 1] - Tv[i + 4], FarmIncome);
        FarmIncome := MaxR(0, FarmIncome - Tv[i + 2]);
        Inc(i, 7);
      until i > 964;
    end;

    { calc section non cap losses }
    i := 502;
    repeat
      If Tv[i + 3] < 0 then
        Tv[i + 3] := 0; // 20130603
      Tv[i + 5] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2] - Tv[i + 3] -
        Tv[i + 4]);
      Inc(i, 7);
    until i > 642;
    Tv[656] := AddColumns(502, 649, 7);
    Tv[657] := AddColumns(510, 650, 7);
    Tv[658] := AddColumns(504, 651, 7);
    Tv[654] := MaxR(0, Tv[649] + Tv[650] - Tv[651] - Tv[652]);
    Tv[659] := AddColumns(512, 652, 7);
    Tv[660] := AddColumns(506, 653, 7);
    Tv[661] := AddColumns(507, 654, 7);

    { calc section farm losses }
    i := 670;
    repeat
      Tv[i + 5] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2] - Tv[i + 3] -
        Tv[i + 4]);
      Inc(i, 7);
    until i > 803;
    Tv[817] := AddColumns(663, 810, 7);
    Tv[818] := AddColumns(671, 811, 7);
    Tv[819] := AddColumns(672, 812, 7);
    Tv[820] := AddColumns(673, 813, 7);
    Tv[821] := AddColumns(667, 814, 7);
    Tv[822] := AddColumns(675, 815, 7);

    Tv[815] := MaxR(0, Tv[810] + Tv[811] - Tv[812] - Tv[813]);

    { calc section restr losses }
    i := 831;
    repeat
      Tv[i + 5] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2] - Tv[i + 3] -
        Tv[i + 4]);
      Inc(i, 7);
    until i > 964;
    Tv[978] := AddColumns(824, 971, 7);
    Tv[979] := AddColumns(832, 972, 7);
    Tv[980] := AddColumns(833, 973, 7);
    Tv[981] := AddColumns(834, 974, 7);
    Tv[982] := AddColumns(828, 975, 7);
    Tv[983] := AddColumns(836, 976, 7);

    Tv[976] := MaxR(0, Tv[971] + Tv[972] - Tv[973]);

    { apply Listed property }
    If AutoSw then
    begin
      i := 45;
      Repeat
        Tv[i + 2] := MinR(Tv[i] + Tv[i + 1] - Tv[i + 3], TxblIncome);
        TxblIncome := MaxR(0, TxblIncome - Tv[i + 2]);
        Inc(i, 6);
      until i > 81;
    end;

    // {calc listed prop losses}
    i := 45;
    repeat
      Tv[i + 4] := MaxR(0, Tv[i] + Tv[i + 1] - Tv[i + 2] - Tv[i + 3]);
      Inc(i, 6);
    until i > 87;
    Tv[93] := Tv[98];
    Tv[96] := Tv[99];
    Tv[93] := Tv[93] + AddColumns(45, 87, 6);
    Tv[94] := AddColumns(46, 88, 6);
    Tv[95] := AddColumns(47, 89, 6);
    Tv[96] := Tv[96] + AddColumns(48, 90, 6);
    Tv[97] := AddColumns(49, 91, 6);
  end;
  SaveTv(RetNo, FName, FNo);
end;

(*
  procedure S4New(RetNo: integer;FName: string;FNo: integer);
  Var i,k:integer;x:real;
  Yr: integer; TxblGains,RemGains,NetApplied,Adjusted,Faktor,TxblIncome,FarmIncome:Real;
  AutoSw :boolean;
  begin

  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  FillHeader(RetNo,FNo,1,2,3);
  For i:=23 to 32 do         //20110924
  begin
  If Tv[i]<0 then Tv[i]:=0;
  end;
  Tv[4] := GetNetInc(RetNo);
  Tv[5] := Vl(FetchElm(RetNo,'T2',222)); {net cap losses deducted this yr?}
  Tv[6] := Vl(FetchElm(RetNo,'T2',219));
  Tv[7]:= Vl(FetchElm(RetNo,'T2',220));
  Tv[8]:= Vl(FetchElm(RetNo,'T2',227));
  Tv[9]:= Vl(FetchElm(RetNo,'T2',228));
  Tv[10]:=Tv[5]+Tv[6]+Tv[7]+Tv[9];
  Tv[36] := Tv[4] - Tv[10];
  If Tv[36] >0 then Tv[36] :=0;
  Tv[11]:= Vl(FetchElm(RetNo,'T2',231));
  Tv[12] := Tv[36]-Tv[11];

  x:=TotGifiMultiple(RetNo,'GIFIIS','9899');  {63}
  If x<0 then Tv[13] :=ABS(x) else Tv[13] :=0;
  If Tv[37] >0 then Tv[13]:=Tv[37];
  Tv[14] := Tv[12]+Tv[13];
  If Tv[39]>Tv[13] then Tv[39]:=Tv[13];
  If Tv[14]>0 then Tv[14] :=0; {no loss}

  //pg 5
  //20130929
  Tv[15] := MaxR(0, Tv[502]+TV[656]-Tv[649]);
  Tv[16] :=Tv[506]+Tv[513];

  Tv[21] := MaxR(0, TV[658]-Tv[651]);
  Tv[22] :=Tv[659];
  //----

  Tv[17] := MaxR(0,Tv[15] - Tv[16]);
  Tv[8]:=Tv[17];
  Tv[18] := Vl(FetchElm(RetNo,'S4',657));  //20130929
  Tv[19] := Abs(Tv[14]);
  Tv[35] := Tv[18]+Tv[19];
  Tv[20]:=Tv[35];
  Tv[38]:=Tv[8]+Tv[20];
  Tv[25] := Tv[21]+Tv[22]+Tv[23]+Tv[24];
  Tv[26]:=Tv[25];
  Tv[40] := MaxR(0,Tv[38] - Tv[26]);
  If Tv[30]<0 then Tv[30]:=0;
  If Tv[14]>0 then
  begin
  For i:=27 to 32 do Tv[i]:=0;
  end;

  Tv[33] :=0; For i:=27 to 32 do Tv[33] := Tv[33]+Tv[i];
  Tv[41]:=Tv[33];
  Tv[34] := MaxR(0,Tv[40] - Tv[41]);
  end; {End with}
  //S4 pg 2---------------------------------------------------------------------

  with Ret[RetNo].Frm[Fno] do
  begin
  //20110924
  If Tv[101]<0 then Tv[101]:=0;
  If Tv[102]<0 then Tv[102]:=0;
  If Tv[110]<0 then Tv[110]:=0;
  If Tv[109]<0 then Tv[109]:=0;
  If Tv[151]<0 then Tv[151]:=0;
  If Tv[152]<0 then Tv[152]:=0;
  If Tv[112]<0 then Tv[112]:=0;
  If Tv[113]<0 then Tv[113]:=0;
  If Tv[114]<0 then Tv[114]:=0;
  If Tv[120]<0 then Tv[120]:=0;
  If Tv[125]<0 then Tv[125]:=0;
  If Tv[126]<0 then Tv[126]:=0;
  For i:=129 to 134 do begin If Tv[i]<0 then Tv[i]:=0;end;


  Tv[137]:=Tv[101]+Tv[102];
  Tv[105]:=Tv[137];
  Tv[138]:=Tv[110]+Tv[109];
  Tv[136]:=Tv[138];
  // Tv[149]:=MaxR(0,Tv[101]+Tv[102]-Tv[110]-Tv[109]);
  Tv[150]:=MaxR(0,Tv[105]-Tv[136]); //-Tv[49];  //20090629
  If Vl(FetchElm(RetNo,'S6',678))<0 then
  Tv[103] := ABs(Vl(FetchElm(RetNo,'S6',678)))
  else
  Tv[103]:=0;
  Tv[153]:=MinR(Tv[151],Tv[152]);
  Tv[106]:=Tv[153] * Vl(Strings[104]);
  Tv[107]:=Tv[150]+Tv[103]+Tv[106];

  // Tv[108] :=0;
  //20121216
  {Leave manual
  If Vl(FetchElm(RetNo,'S6',697))>0 then Tv[108]:=MinR(Tv[107],Vl(FetchElm(RetNo,'S6',697)));
  Tv[108]:=MinR(Tv[108],GetTxblIncBfrNetCapLosses(RetNo)*2);
  If UpperCase(Strings[146]) ='Y' then Tv[108] := Tv[147];
  }
  //20121216
  If Tv[108]>MinR(Tv[107],Vl(FetchElm(RetNo,'S6',697))) then
  Tv[108]:=MinR(Tv[107],Vl(FetchElm(RetNo,'S6',697)));


  Tv[111]:=MaxR(0,Tv[107]-Tv[108]);
  Tv[115]:=Tv[112]+Tv[113]+Tv[114];
  Tv[139]:=Tv[115];
  Tv[116] := MaxR(0,Tv[111]-Tv[139]);
  {farm loss}

  //20130929
  //   S4WSFNo:= GetFormNo('S4'); //pg5
  Tv[117] := MaxR(0, Tv[663]+Tv[817]-Tv[810]);
  Tv[118] :=Tv[667];


  Tv[123] := MaxR(0, Tv[819]-Tv[812]);
  Tv[124] := MaxR(0, Tv[820]-Tv[813]);
  //--
  Tv[119] := MaxR(0,Tv[117]-Tv[118]);
  Tv[142]:=Tv[119];
  // figure out farming loss
  Tv[121] := MaxR(0,Vl(FetchElm(RetNo,'S4',13))-Vl(FetchElm(RetNo,'S4',39)));
  If Tv[121]>Abs(Vl(FetchElm(RetNo,'S4',12))) then
  Tv[121]:=Abs(Vl(FetchElm(RetNo,'S4',12)));

  Tv[120] := Vl(FetchElm(RetNo,'S4',818));  //20130929
  Tv[122] := Tv[120]+Tv[121];
  Tv[143]:=Tv[122];
  Tv[144]:=Tv[142]+Tv[143];

  Tv[127]:=0; For i:=123 to 126 do Tv[127]:=Tv[127]+Tv[i];
  Tv[140]:=Tv[127];
  Tv[128] := MaxR(0,Tv[144] - Tv[140]);

  Tv[145] :=0; For i:=129 to 134 do Tv[145] := Tv[145]+Tv[i];
  Tv[141]:=Tv[145];
  Tv[135] := MaxR(0,Tv[128]-Tv[141]);

  ({ ???
  {restr loss}
  Tv[37]:=2500;
  Tv[38] := Tv[36];
  Tv[39] := MaxR(0,Tv[38]-2500)/2;
  Tv[40] := 6250;
  Tv[41] := MinR(Tv[39],Tv[40]);
  Tv[42] := Tv[37]+Tv[41];  //Tv[41]
  Tv[43] := MaxR(0,Tv[36]-Tv[42]);
  }
  end; {End with}
  //  SaveTv(RetNo,FName,FNo);

  //S4 pg 3---------------------------------------------------------------------

  //  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  //restricted farm loss
  Tv[236]:=Vl(FetchElm(RetNo,'S4',39));
  If Tv[208]<0 then Tv[208]:=0;
  If Tv[209]<0 then Tv[209]:=0;
  For i:=212 to 214 do begin If Tv[i]<0 then Tv[i]:=0;end; //20110924
  For i:=217 to 219 do begin If Tv[i]<0 then Tv[i]:=0;end; //20110924
  If Tv[223]<0 then Tv[223]:=0;
  For i:=226 to 228 do begin If Tv[i]<0 then Tv[i]:=0;end; //20110924
  If Tv[236]<>0 then  //20110610
  begin
  // Tv[237]:=2500;
  Tv[238]:=Tv[236];
  Tv[239]:=MaxR(0,Tv[238]-2500)/2;
  Tv[240]:=6250;
  Tv[241]:=MinR(Tv[239],Tv[240]);
  Tv[247]:=Tv[237]+Tv[241];
  Tv[242]:=Tv[247];
  Tv[243]:=MaxR(0,Tv[236]-Tv[242]);
  end
  else
  begin
  For i:=237 to 243 do Tv[i]:=0;
  Tv[247]:=0;
  end;


  // S4WSFNo:= GetFormNo('S4'); //pg5
  Tv[201] := MaxR(0, Tv[824]+Tv[978]-Tv[971]); //??
  Tv[202] :=Tv[828];
  Tv[203] := MaxR(0, Tv[201] - Tv[202]);
  Tv[231]:=Tv[203];

  Tv[205] := Tv[243];
  Tv[204] := Vl(FetchElm(RetNo,'S4',979));
  Tv[206] := Tv[204]+Tv[205];
  Tv[232]:=Tv[206];
  Tv[233]:=Tv[231]+Tv[232];

  Tv[207] := MaxR(0, Tv[980]-Tv[973]);
  If Tv[208]<0 then Tv[208]:=0;
  If Tv[209]<0 then Tv[209]:=0;
  Tv[210] := Tv[207]+Tv[208]+Tv[209];
  Tv[234]:=Tv[210];
  Tv[211] := MaxR(0,Tv[233] - Tv[234]);

  Tv[215] := Tv[212]+Tv[213]+Tv[214];
  Tv[235]:=Tv[215];
  Tv[216] :=MaxR(0,Tv[211]-Tv[235]);

  {listed pers}
  Tv[219] := MaxR(0,Tv[217]-Tv[218]);
  Tv[244]:=Tv[219];
  If Vl(FetchElm(RetNo,'S6',533))<0 then
  Tv[220] := ABS(Vl(FetchElm(RetNo,'S6',533)))
  else
  Tv[220] := 0;
  Tv[221] := Tv[244]+Tv[220];

  Tv[222]:=MinR(Vl(FetchElm(RetNo,'S6',633)), Tv[221]);
  Tv[224] := Tv[222]+Tv[223];
  Tv[245]:=Tv[224];
  Tv[225] := MaxR(0,Tv[221] - Tv[245]);

  Tv[230]:=Tv[226]+Tv[227]+Tv[228];
  Tv[246]:=Tv[230];
  Tv[229] := MaxR(0,Tv[225]-Tv[246]);
  end; {End with}
  //S4 pg 4---------------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
  i:=307;
  Tv[336] :=0;
  Repeat
  If Tv[i-4] <0 then Tv[i-4]:=0; //20110924
  If Tv[i-3] <0 then Tv[i-3]:=0; //20110924
  If Tv[i-2] <0 then Tv[i-2]:=0; //20110924
  Tv[i-1] := MaxR(0,Tv[i-3]-Tv[i-2]);
  Tv[i] := MaxR(0,Tv[i-4]-Tv[i-1]);
  Tv[336] := Tv[336]+Tv[i];
  Inc(i,7);
  until i>335;

  i:=342;
  Repeat
  If Tv[i-3]<0 then Tv[i-3]:=0; //20110924
  If Tv[i-2]<0 then Tv[i-2]:=0; //20110924
  If Tv[i-1]<0 then Tv[i-1]:=0; //20110924
  Tv[i] := MaxR(0,Tv[i-2]-Tv[i-1]);
  Tv[i+1] := MinR(Tv[i-3],Tv[i]);
  Inc(i,7);
  until i>370;


  i:=301;
  Repeat
  Strings[i+36]:=Strings[i];
  Strings[i+37]:=Strings[i+1];
  Strings[i+71]:=Strings[i];
  Strings[i+72]:=Strings[i+1];
  Inc(i,7);
  until i>329;

  Tv[407]:=0; Tv[408]:=0; Tv[409]:=0; //20121211
  k:=0;
  For i:=301 to 305 do  //for 5 lines varying K
  begin
  Tv[373+k]:=Tv[339+k]; //addedd 300 to xx+k  //20110929
  Tv[375+k]:=Tv[307+k];
  If Strings[410]<> 'Y' then
  Tv[376+k]:=MinR(Tv[343+k],GetFedTxblBfrLosses(RetNo));
  Tv[377+k]:=MaxR(0,Tv[373+k]+Tv[374+k]+Tv[375+k]-Tv[376+k]);
  Tv[407]:=Tv[407]+Tv[376+k];
  Tv[408]:=Tv[408]+Tv[377+k];
  Tv[409]:=Tv[409]+Tv[373+k];
  Inc(k,7);
  end;

  end; {End with}
  //S4 pg 5---------------------------------------------------------------------

  with Ret[RetNo]^ do
  Begin
  If Frm[FNo].Strings[999] ='' then Frm[FNo].Strings[999]:='Y';  //20130929
  If UpperCase(Frm[FNo].Strings[999]) ='N' then
  AutoSw := False
  else
  AutoSw := True;
  {Enter years in non cap loss}
  Yr := GetTaxationYearEndYYYY(RetNo)-21; //20130929
  i := 501;
  Repeat
  Frm[FNo].Strings[i] := IntToStr(Yr);
  Inc(i,7);
  Yr := Yr+1;
  until i > 648;
  // Frm[FNo].Strings[730]:=IntToStr(GetTaxationYearEndYYYY(RetNo)-21); //GetPrevYearEnd(Frm[FNo].Strings[1],1);  //20130929 //20121216
  Tv[506]:=Tv[502]; //Tv[732]:=Tv[731];  //20130929
  {Enter years in non farm loss}
  Yr :=GetTaxationYearEndYYYY(RetNo)-21;
  i := 662;
  Repeat
  If Tv[i+11]<0 then Tv[i+11]:=0; //20110924
  If Tv[i+13]<0 then Tv[i+13]:=0; //20110924
  Frm[FNo].Strings[i] := IntToStr(Yr);
  Inc(i,7);
  Yr := Yr+1;
  until i > 809;
  //   Frm[FNo].Strings[633]:=GetPrevYearEnd(Frm[FNo].Strings[670],1);
  Tv[667]:=Tv[663];    //20130929

  {Enter years in restr farm loss}
  Yr :=GetTaxationYearEndYYYY(RetNo)-21;
  i := 823;
  Repeat
  Frm[FNo].Strings[i] := IntToStr(Yr);
  Inc(i,7);
  Yr := Yr+1;
  until i > 970;
  //  Frm[FNo].Strings[818736]:=GetPrevYearEnd(Frm[FNo].Strings[646],1);
  Tv[828]:=Tv[824];
  {current year loss}
  If Vl(FetchElm(RetNo,'S4',14)) <0 then
  Tv[649] := ABS(Vl(FetchElm(RetNo,'S4',14))) {non-cap}
  else
  Tv[649] :=0;

  Tv[810] := Vl(FetchElm(RetNo,'S4',121)); {current yr farm cap}
  Tv[971] := Vl(FetchElm(RetNo,'S4',243)); {current yr restr farm loss}

  {Loss C/B}
  Tv[651] := Vl(FetchElm(RetNo,'S4',27)) {non-cap}
  +Vl(FetchElm(RetNo,'S4',28))
  +Vl(FetchElm(RetNo,'S4',29))
  +Vl(FetchElm(RetNo,'S4',30)) {non-cap c/b part iv-4}
  +Vl(FetchElm(RetNo,'S4',31))
  +Vl(FetchElm(RetNo,'S4',32));
  If Tv[652] > Vl(FetchElm(RetNo,'S3',95)) then
  Tv[652] := Vl(FetchElm(RetNo,'S3',95)); {max is div part iv}

  Tv[812] := Vl(FetchElm(RetNo,'S4',129)) {farm loss carry back}
  +Vl(FetchElm(RetNo,'S4',130))
  +Vl(FetchElm(RetNo,'S4',131));

  If Tv[813]>Tv[810] then Tv[813]:=Tv[810];
  Tv[973] := Vl(FetchElm(RetNo,'S4',215)); {restr farm }
  {calc txbl income against wich to apply non cap/farm losses}
  TxblIncome := GetTxblIncBfrLosses(RetNo);

  {apply non cap losses}
  If AutoSw then
  begin
  i := 509;
  Repeat
  Tv[i+2] := MinR(Tv[i]+Tv[i+1]-Tv[i+3], TxblIncome);
  TxblIncome := MaxR(0,TxblIncome- Tv[i+2]);
  Inc(i,7);
  until i>642;
  end;

  {apply farm losses}
  If AutoSw then
  begin
  i := 670;
  Repeat
  Tv[i+2] := MinR(Tv[i]+Tv[i+1]-Tv[i+3], TxblIncome);
  TxblIncome := MaxR(0,TxblIncome- Tv[i+2]);
  Inc(i,7);
  until i>803;
  end;

  {apply restricted farm losses}
  FarmIncome := TotGifiMultiple(RetNo,'GIFIIS','9899'); {63}
  If FarmIncome <0 then FarmIncome :=0; {apply only if positive farm income}
  If AutoSw then
  begin
  i := 831;
  Repeat
  Tv[i+2] := MinR(Tv[i]+Tv[i+1], FarmIncome);
  FarmIncome := MaxR(0,FarmIncome- Tv[i+2]);
  Inc(i,7);
  until i>964;
  end;

  {calc section non cap losses}
  i:= 502;
  repeat
  If Tv[i+3]<0 then Tv[i+3]:=0;   //20130603
  Tv[i+5] := MaxR(0,Tv[i]+Tv[i+1] - Tv[i+2]-Tv[i+3]-Tv[i+4]);
  Inc(i,7);
  until i>642;
  Tv[656] := AddColumns(509,649,7);
  Tv[657] := AddColumns(510,650,7);
  Tv[658] := AddColumns(504,651,7);
  Tv[654] := MaxR(0,Tv[649]+Tv[650] - Tv[651]-Tv[652]);
  Tv[659] := AddColumns(512,652,7);
  Tv[660] := AddColumns(513,653,7);
  Tv[661] := AddColumns(507,654,7);

  {calc section farm losses}
  i:= 670;
  repeat
  Tv[i+5] := MaxR(0,Tv[i]+Tv[i+1] - Tv[i+2]-Tv[i+3]-Tv[i+4]);
  Inc(i,7);
  until i>803;
  Tv[817] := AddColumns(670,810,7);
  Tv[818] := AddColumns(671,811,7);
  Tv[819] := AddColumns(672,812,7);
  Tv[820] := AddColumns(673,813,7);
  Tv[821] := AddColumns(674,814,7);
  Tv[822] := AddColumns(675,815,7);

  //  Tv[817] := AddColumns(676,809,7);  ??

  Tv[815] := MaxR(0,Tv[810]+Tv[811] - Tv[812]-Tv[813]);


  {calc section restr losses}
  i:= 831;
  repeat
  Tv[i+5] := MaxR(0,Tv[i]+Tv[i+1] - Tv[i+2]-Tv[i+3]-Tv[i+4]);
  Inc(i,7);
  until i>964;
  Tv[978] := AddColumns(831,971,7);
  Tv[979] := AddColumns(832,972,7);
  Tv[980] := AddColumns(833,973,7);
  Tv[981] := AddColumns(834,974,7);
  Tv[982] := AddColumns(835,975,7);
  Tv[983] := AddColumns(836,976,7);

  Tv[976] := MaxR(0,Tv[971]+Tv[972] - Tv[973]);
  end;
  SaveTv(RetNo,FName,FNo);
  end;
*)

// 20190920
Procedure S5(RetNo: integer; FName: string; FNo: integer);

var
  i, PrvNdx, S500FNo: integer;
  PrvAlloc, SmBusLimit, TxblIncome, x: Real;
  Prv: String;
begin
  LoadTv(RetNo, FName, FNo);
  // S5 pg 2---------------------------------------------------------------------

  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 101, 102, 103);
    For i := 270 to 276 do
      Tv[i] := 0;

    If Tv[105] + Tv[107] > 0 then
      Frm[FNo].Strings[289] := 'X';
    If Tv[248] + Tv[250] > 0 then
      Frm[FNo].Strings[290] := 'X';
    If Tv[116] + Tv[118] > 0 then
      Frm[FNo].Strings[291] := 'X';
    If Tv[127] + Tv[129] > 0 then
      Frm[FNo].Strings[292] := 'X';
    If Tv[237] + Tv[239] > 0 then
      Frm[FNo].Strings[293] := 'X';
    If Tv[138] + Tv[140] > 0 then
      Frm[FNo].Strings[294] := 'X';
    If Tv[149] + Tv[151] > 0 then
      Frm[FNo].Strings[295] := 'X';
    If Tv[160] + Tv[162] > 0 then
      Frm[FNo].Strings[296] := 'X';
    If Tv[171] + Tv[173] > 0 then
      Frm[FNo].Strings[297] := 'X';
    If Tv[182] + Tv[184] > 0 then
      Frm[FNo].Strings[298] := 'X';
    If Tv[193] + Tv[195] > 0 then
      Frm[FNo].Strings[299] := 'X';
    If Tv[204] + Tv[206] > 0 then
      Frm[FNo].Strings[300] := 'X';
    If Tv[215] + Tv[217] > 0 then
      Frm[FNo].Strings[301] := 'X';
    If Tv[226] + Tv[228] > 0 then
      Frm[FNo].Strings[302] := 'X';
    If Tv[277] + Tv[279] > 0 then
      Frm[FNo].Strings[303] := 'X';
    If Tv[259] + Tv[261] > 0 then
      Frm[FNo].Strings[304] := 'X';

    { Add Column B Tot salaries }
    i := 105;
    Repeat
      If Tv[i] < 0 then
        Tv[i] := 0;
      If Tv[i + 2] < 0 then
        Tv[i + 2] := 0;
      Tv[270] := Tv[270] + Tv[i];
      Inc(i, 11);
    until i > 259;
    If Tv[277] < 0 then
      Tv[277] := 0;
    If Tv[279] < 0 then
      Tv[279] := 0;
    Tv[270] := Tv[270] + Tv[277]; // nu

    { Calc Column C }
    i := 105;
    Repeat
      If Tv[270] > 0 then
        Tv[i + 1] := Round(Tv[i] * GetTxblIncome(RetNo) / Tv[270])
      else
        Tv[i + 1] := 0;
      If IsTaxExempt(RetNo) then
        Tv[i + 1] := 0;
      Inc(i, 11);
    until i > 259;
    // nu
    If Tv[270] > 0 then
      Tv[278] := Round(Tv[277] * GetTxblIncome(RetNo) / Tv[270])
    else
      Tv[278] := 0;
    If IsTaxExempt(RetNo) then
      Tv[278] := 0;

    { add column C }
    i := 106;
    Repeat
      Tv[271] := Tv[271] + Tv[i];
      Inc(i, 11);
    until i > 260;
    Tv[271] := Tv[271] + Tv[278]; // nu

    { Add  Column D }
    i := 107;
    Repeat
      Tv[272] := Tv[272] + Tv[i];
      Inc(i, 11);
    until i > 261;
    Tv[272] := Tv[272] + Tv[279]; // nu

    { Calc Column E }
    i := 107;
    Repeat
      If Tv[272] > 0 then
        Tv[i + 1] := Round(Tv[i] * GetTxblIncome(RetNo) / Tv[272])
      else
        Tv[i + 1] := 0;
      If IsTaxExempt(RetNo) then
        Tv[i + 1] := 0;
      Inc(i, 11);
    until i > 261;
    If Tv[272] > 0 then
      Tv[280] := Round(Tv[279] * GetTxblIncome(RetNo) / Tv[272]) // nu
    else
      Tv[280] := 0;
    If IsTaxExempt(RetNo) then
      Tv[280] := 0;
    { Add  Column E }
    i := 108;
    Repeat
      Tv[273] := Tv[273] + Tv[i];
      Inc(i, 11);
    until i > 262;
    Tv[273] := Tv[273] + Tv[280]; // nu

    { Calc Column F }
    i := 106;
    Repeat
      If (Tv[270] = 0) or (Tv[272] = 0) then
        Tv[i + 3] := Tv[i] + Tv[i + 2]
      else
        Tv[i + 3] := (Tv[i] + Tv[i + 2]) / 2; // 20090711
      Inc(i, 11);
    until i > 260;

    If (Tv[270] = 0) or (Tv[272] = 0) then
      Tv[281] := Tv[278] + Tv[280] // nu
    else
      Tv[281] := (Tv[278] + Tv[280]) / 2; // 20090711

    { Add  Column F }
    i := 109;
    Repeat
      Tv[274] := Tv[274] + Tv[i];
      Inc(i, 11);
    until i > 263;
    Tv[274] := Tv[274] + Tv[281]; // nu

    { Columns i and k }
    SmBusLimit := GetIncForSmBusDed(RetNo);
    TxblIncome := GetTxblIncomeInAllProv(RetNo);
    // GetTxblIncome(RetNo);  20090708

    i := 109;
    PrvNdx := 1; // 20120930
    repeat

      If i = 109 then
        Prv := 'NL'
      else If i = 252 then
        Prv := 'XO'
      else If i = 120 then
        Prv := 'PE'
      else If i = 131 then
        Prv := 'NS'
      else If i = 241 then
        Prv := 'NO'
      else If i = 142 then
        Prv := 'NB'
      else If i = 153 then
        Prv := 'QC'
      else If i = 164 then
        Prv := 'ON'
      else If i = 175 then
        Prv := 'MB'
      else If i = 186 then
        Prv := 'SK'
      else If i = 197 then
        Prv := 'AB'
      else If i = 208 then
        Prv := 'BC'
      else If i = 219 then
        Prv := 'YT'
      else If i = 230 then
        Prv := 'NT'
      else If i = 281 then
        Prv := 'NU'
      else If i = 263 then
        Prv := 'OC';

      PrvNdx := GetPrvNdx(Prv);
      If ((PrvNdx = 1) or (PrvNdx = 15)) and
        (GetBegYearEnd(RetNo) >= '2010/04/01') then
        PrvLowRate[1] := 4; // nl  //20121208
      Frm[FNo].Strings[i + 1] := FormatFloat('##.##', PrvLowRate[PrvNdx]);
      Frm[FNo].Strings[i + 3] := FormatFloat('##.##', PrvHighRate[PrvNdx]);
      PrvAlloc := Tv[i];
      If TxblIncome > 0 then
      begin
        Tv[i + 2] := GetLowTax(PrvNdx, TxblIncome, PrvAlloc, SmBusLimit);
        Tv[i + 4] := GetHighTax(PrvNdx, TxblIncome, PrvAlloc, SmBusLimit);
      end
      else
      begin
        Tv[i + 2] := 0;
        Tv[i + 4] := 0;
      end;

      // 20130927
      If i = 120 then // PE
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S322', 18));
        Tv[i + 4] := 0;
      end;

      // 20130927
      If i = 109 then // NL
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S307', 21));
        Tv[i + 4] := 0;
      end;

      // 20130927
      If i = 230 then // NT
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S461', 18));
        Tv[i + 4] := 0;
      end;

      If i = 208 then // bc
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S427', 25));
        Tv[i + 4] := 0;
      end;

      If i = 131 then // NS
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S346', 46));
        // 20190626 //Tv[i+2]:= Vl(FetchElm(RetNo,'S346',62));
        Tv[i + 4] := 0;
      end;

      If i = 186 then // SK
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S411', 189));
        // Vl(FetchElm(RetNo,'S411_2',26));
        Tv[i + 4] := 0;
      end;

      If i = 142 then // NB
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S366', 217));
        Tv[i + 4] := 0;
      end;

      If i = 164 then // ON
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S500', 5));
        Tv[i + 4] := 0;
      end;

      If i = 175 then // MB
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S383', 6)); // 20210922
        Tv[i + 4] := 0;
      end;

      If i = 219 then // YT
      begin
        Frm[FNo].Strings[i + 1] := '';
        Frm[FNo].Strings[i + 3] := '';
        Tv[i + 2] := Vl(FetchElm(RetNo, 'S443', 217));
        Tv[i + 4] := 0;
      end;

      Inc(i, 11);
      Inc(PrvNdx);
    until i > 252; // exclude outside canada? //164

    // 20130927
    i := 281; // NU
    Frm[FNo].Strings[i + 1] := '';
    Frm[FNo].Strings[i + 3] := '';
    Tv[i + 2] := Vl(FetchElm(RetNo, 'S481', 18));
    Tv[i + 4] := 0;

    Tv[155] := 0; { Que }
    Tv[199] := 0; { Alb }

    { Add  Column k }
    Tv[276] := 0;
    Tv[276] := Tv[111] + Tv[113] + Tv[254] + Tv[256] + Tv[122] + Tv[124] +
      Tv[133] + Tv[135] + Tv[243] + Tv[245] + Tv[144] + Tv[146] + Tv[166];
    Tv[276] := Tv[276] + Tv[177] + Tv[179] + Tv[188] + Tv[190] + Tv[210] +
      Tv[221] + Tv[223] + Tv[232] + Tv[234] + Tv[283] + Tv[285];

  end; { End with }

  // S5 pg 3---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    { NF }
    PrvNdx := GetPrvNdx('NL');
    // 20210705
    Tv[401] := GetPrvTaxBfrCredits(RetNo, Ret[RetNo].Province, 'NL');
    Tv[402] := Vl(FetchElm(RetNo, 'S307', 20));

    If IsTaxExempt(RetNo) then
      Tv[402] := 0;

    Tv[403] := Tv[401] + Tv[402];
    Tv[404] := Tv[403];
    Tv[406] := Vl(FetchElm(RetNo, 'POLIT', 112));
    Tv[405] := GetPolitCredit(Tv[406]);
    Tv[407] := TotMultiple(RetNo, 'S21P', 14);
    // Tv[408] := Vl(FetchElm(RetNo,'S300',11));
    Tv[433] := Vl(FetchElm(RetNo, 'S304', 22));
    Tv[458]:= Vl(FetchElm(RetNo, 'S310', 27));  //20231006
    Tv[424]:= Vl(FetchElm(RetNo, 'S308', 21)); //20260501 Alex
    Tv[434]:= Vl(FetchElm(RetNo, 'S303', 24)); //20260501 Alex
    Tv[457]:= Vl(FetchElm(RetNo, 'S311', 89)); //20260501 Alex
    Tv[458]:= Vl(FetchElm(RetNo, 'S310', 27)); //20260501 Alex

    Tv[409] := Tv[405] + Tv[407] + Tv[424] + Tv[434] + Tv[433] + Tv[457] + Tv[458]; // 20220907

    Tv[410] := Tv[409]; // Tv[49];   //20140913
    Tv[418] := MaxR(0, Tv[404] - Tv[410]);
    If GetBegYearEnd(RetNo) > '2008/10/31' then // nl cap tax
      Tv[423] := Vl(FetchElm(RetNo, 'S305', 33)) // 20170606
    else
      Tv[423] := 0;
    Tv[411] := Tv[418] + Tv[423];
    Tv[459]:=Vl(FetchElm(RetNo,'S310',34)); //20231006
    Tv[462]:=Vl(FetchElm(RetNo,'S311',95)); //20231006

    Tv[412] := Vl(FetchElm(RetNo, 'S301', 11));
    // Tv[453] := Vl(FetchElm(RetNo,'S302',42)); //20120429
    //Tv[434] := Vl(FetchElm(RetNo, 'S303', 24)); //20260501 Alex
    // 20160426
    Tv[460] := Vl(FetchElm(RetNo, 'S309', 64));
    Tv[455] := Tv[459] + Tv[462] + Tv[412] + Tv[453] + Tv[460]; // 20220907
    // ----------
    Tv[456] := Tv[455];
    Tv[413] := Tv[411] - Tv[456];
    { PE }
    PrvNdx := GetPrvNdx('PE');
    Tv[414] := GetPrvTaxBfrCredits(RetNo, Ret[RetNo].Province, 'PE');
    //29250918
   // Tv[416] := Vl(FetchElm(RetNo, 'POLIT', 52));
   // Tv[415] := GetPolitCredit(Tv[416]);
    Tv[419] := Vl(FetchElm(RetNo, 'S321', 34));
    Tv[417] := TotMultiple(RetNo, 'S21P', 23);
    Tv[420] := Tv[415] + Tv[417] + Tv[419];
    Tv[421] := Tv[420];
    Tv[422] := MaxR(0, Tv[414] - Tv[421]);

  end; { End with }

  // S5 pg 4-----//ns----------------------------------------------------------------
  with Ret[RetNo], Ret[RetNo].Frm[FNo] do
  begin
    { NS }
    PrvNdx := GetPrvNdx('NS');
    Tv[523] := Vl(FetchElm(RetNo, 'S346', 29));  //20260628

    If Vl(FetchElm(RetNo, 'S5', 241))>0 then //txbl in NS Off shore
      Tv[524] :=  Vl(FetchElm(RetNo, 'S346', 28)) //20260628
    Else
      Tv[524]:=0;  //20260628
       //Vl(FetchElm(RetNo, 'S346', 29)); //2026062851016
      // //Vl(FetchElm(RetNo, 'S5', 243)) + Vl(FetchElm(RetNo, 'S5', 245));
    If IsTaxExempt(RetNo) then  Tv[524] := 0;
    Tv[557] := Vl(FetchElm(RetNo, 'S340', 221));
    Tv[525] := Tv[523] + Tv[524] + Tv[557];
    Tv[526] := Tv[525];
    Tv[528] := Vl(FetchElm(RetNo, 'POLIT', 82));
    Tv[527] := GetPolitCredit(Tv[528]);
    Tv[529] := TotMultiple(RetNo, 'S21P', 32);

    // <--- jz 2019
    // Tv[558]:= Vl(FetchElm(RetNo,'S349',00)); //jz 2019 T2SCH349 ??? not done ???
    // Tv[559]:= Vl(FetchElm(RetNo,'S350',00)); //jz 2019 T2SCH350 ??? not done ???
    // --->

    Tv[556] := Vl(FetchElm(RetNo, 'S2', 45)); // 20161112
    if Tv[556] > Tv[526] then
      Tv[556] := Tv[526]; // 20170613

    // Tv[542] :=Vl(FetchElm(RetNo,'S340',10));  //Tv[543] :=Vl(FetchElm(RetNo,'S344',34)); //20121207
    Tv[530] := Vl(FetchElm(RetNo, 'S341', 18));  //20250918
    // 20191013
    Tv[558] := Vl(FetchElm(RetNo, 'S349', 24));
    Tv[559] := Vl(FetchElm(RetNo, 'S349', 21));

    Tv[544] := Tv[529] + Tv[558] + Tv[559] + Tv[556] + Tv[530];
    // jz 20190924

    Tv[545] := Tv[544];
    Tv[546] := MaxR(0, Tv[526] - Tv[545]);
    Tv[548] := Vl(FetchElm(RetNo, 'S352', 26)); // 20220918
    Tv[555] := Tv[546] + Tv[548]; // 20220919
    // If Vl(FetchElm(RetNo,'S345',34)) >0 then  {sch completed}  //20220509
    // Tv[547] :=Vl(FetchElm(RetNo,'S345',34));
    Tv[549] := Vl(FetchElm(RetNo, 'S340', 13));
    Tv[518] := Vl(FetchElm(RetNo, 'S347', 42));

    // 20160426
    Tv[533] := Vl(FetchElm(RetNo, 'S348', 64));
    Tv[550] := Tv[547] + Tv[549] + Tv[518] + Tv[532] + Tv[533]; // 20160426
    // ---------------
    Tv[551] := Tv[550];
    Tv[552] := MaxR(0, Tv[555] - Tv[551]); // 20220918
    // end NS

    { NB }
    PrvNdx := GetPrvNdx('NB');
    Tv[516] := Vl(FetchElm(RetNo, 'S366', 217));
    Tv[514] := Vl(FetchElm(RetNo, 'S360', 236));
    Tv[542] := Tv[516] + Tv[514];
    Tv[504] := Tv[542];
    // Tv[513] := Vl(FetchElm(RetNo,'POLIT',92));  //20181104 //20190925


    // <--- jz 2019 removed
    // Tv[515] := GetPolitCredit(Tv[513]); //GetPolitCredit(Tv[503]);   //20181104 //jz 2019
    // if GetTaxationYearStart(RetNo)>='2017/06/01' then Tv[515]:=0; //20181108 before june 1
    // --->

    (*
      if getBN(RetNo)='982486292RC0001' then
      Begin
      Tv[515]:=Round(Tv[515]*3/12);
      //GetNumDays(RetNo,'31-12-2005','A')-GetNumDays(RetNo,'31-12-2006','A')
      End;
    *)

    Tv[512] := TotMultiple(RetNo, 'S21P', 41);
    Tv[517] := Vl(FetchElm(RetNo, 'S367', 22)); // 20150328

    Tv[506] := Tv[512] + Tv[517];
    // Tv[506] := Tv[515]+Tv[512]+Tv[517]; //jz 2019 Tv[515] removed

    x := Tv[512]; // without the credit on 517 //20190925

    Tv[507] := Tv[506];
    Tv[508] := MaxR(0, Tv[504] - Tv[507]);

    Tv[553] := MaxR(0, Tv[504] - x);
    // to be used in S367 //jz 2019 ??? Tv[553] not visible, x based on Tv[515] but has been removed ???

    // Tv[509] := Vl(FetchElm(RetNo,'S365',30));  //20220509
    Tv[503] := Vl(FetchElm(RetNo, 'S360', 109));
    Tv[502] := Tv[509] + Tv[503];
    Tv[501] := Tv[502];
    Tv[511] := Tv[508] - Tv[501];
    // end NB
  end;

  // S5 pg 5---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    PrvNdx := GetPrvNdx('ON');
    S500FNo := GetFormNo('S500');
    PrvNdx := GetPrvNdx('ON');
    Tv[601] := Vl(FetchElmFNo(RetNo, S500FNo, 5));
    Tv[602] := Vl(FetchElmFNo(RetNo, S500FNo, 15));
    Tv[603] := MaxR(0, Tv[601] - Tv[602]);
    Tv[604] := Tv[603];
    // Tv[605]:=Vl(FetchElmFNo(RetNo,S500FNo,28));
    // Tv[606]:=Vl(FetchElm(RetNo,'S504',30));  // 20190421
    Tv[607] := Vl(FetchElm(RetNo, 'S506', 94));
    Tv[608] := Vl(FetchElm(RetNo, 'S508', 139));
    Tv[609] := Tv[607] + Tv[608]+Tv[647]; //20250918
    Tv[610] := Tv[609];
    Tv[611] := Tv[604] + Tv[610];

    Tv[612] := MaxR(Vl(FetchElm(RetNo, 'S504', 53)),
      Vl(FetchElm(RetNo, 'S504', 55)));
    // Vl(FetchElm(RetNo,'S504',23));  //20160603
    Tv[613] := Vl(FetchElm(RetNo, 'S502', 50)); // 20220509
    Tv[614] := TotMultiple(RetNo, 'S21P', 104);
    Tv[615] := Vl(FetchElmFNo(RetNo, S500FNo, 40));
    Tv[616] := Vl(FetchElm(RetNo, 'S506', 117));
    Tv[644] := Vl(FetchElm(RetNo, 'S525', 17));
    Tv[617] := AddColumns(613, 615, 1)+Tv[644]; //20221128 //AddColumns(612, 616, 1);
    //Tv[617] := Tv[617] + Tv[644]; // 20090906

    Tv[618] := Tv[617];
    Tv[619] := MaxR(0, Tv[611] - Tv[618]);

    Tv[620] := Vl(FetchElm(RetNo, 'S508', 33));
    Tv[621] := MaxR(0, Tv[619] - Tv[620]);
    Tv[622] := Vl(FetchElm(RetNo, 'S510', 97));
    Tv[645] := Vl(FetchElm(RetNo, 'S2', 31)); // 20161112
    if Tv[645] > Tv[621] then Tv[645] := Tv[621]; // 20170613

    Tv[8] :=Vl(FetchElm(RetNo,'S572',233)); //20260524
    Tv[6] :=Vl(FetchElm(RetNo,'S572',117)); //20260524

    // Tv[625]:= Vl(FetchElm(RetNo,'S2',31)); //20141109  WRONG! //20161112
    Tv[623] := MaxR(0, Tv[621] - Tv[622] - Tv[645]-Tv[8]); // 20260524CZ
    Tv[624] := Vl(FetchElm(RetNo, 'S510', 68));
    Tv[625] := Vl(FetchElm(RetNo, 'S512', 70)); // 20161112
    // Tv[645]:=Vl(FetchElm(RetNo,'S512',70));  //wrong 20161112
    Tv[627] := Tv[624] + Tv[625]; // +Tv[626];
    Tv[628] := Tv[627];
    Tv[629] := Tv[623] + Tv[628];

    // Tv[30]:=??
    Tv[631] := TotMultiple(RetNo, 'S550', 17);
    Tv[632] := TotMultiple(RetNo, 'S552', 96);
    Tv[633] := TotMultiple(RetNo, 'S554', 65);
    // TotMultiple(RetNo,'S554',39);  //20160507
    Tv[634] := TotMultiple(RetNo, 'S556', 93) + TotMultiple(RetNo, 'S556', 99) +
      TotMultiple(RetNo, 'S556', 106);
    Tv[635] := TotMultiple(RetNo, 'S558', 104);
    // 20160510 //TotMultiple(RetNo,'S558',57);
    Tv[636] := TotMultiple(RetNo, 'S560', 86);
    // Tv[637]:=TotMultiple(RetNo,'S562',82);   //20190421
    Tv[638] := TotMultiple(RetNo, 'S564', 57);
    Tv[639] := Vl(FetchElm(RetNo, 'S566', 179));
    Tv[640] := Vl(FetchElm(RetNo, 'S568', 80));
    Tv[8] := Vl(FetchElm(RetNo, 'S572', 200)); // 20260524
    Tv[646] := Vl(FetchElm(RetNo, 'S570', 27)); // 20210919

    Tv[6] := Vl(FetchElm(RetNo, 'S572', 117)); //jz 20240611

    Tv[641] := AddColumns(630, 636, 1) + AddColumns(638, 640, 1) + Tv[646] + Tv[6] + Tv[9]; //Tv[8]; //20260501 Alex
    Tv[642] := Tv[641];
    Tv[643] := Tv[629] - Tv[642];
  end; // with

  // S5 pg 6---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    { MB }
    PrvNdx := GetPrvNdx('MB');
    Tv[712] := Vl(FetchElm(RetNo, 'S383', 6)); // 20210922
    Tv[713] := Vl(FetchElm(RetNo, 'S380', 34));
    Tv[716] := Vl(FetchElm(RetNo, 'S381', 34));
    Tv[717] := Vl(FetchElm(RetNo, 'S380', 44));
    Tv[715] := TotMultiple(RetNo, 'S21P', 50);
    Tv[762] := Vl(FetchElm(RetNo, 'S394', 131)); // 20140408
    // Tv[747]:=TotMultiple(RetNo,'S384',11); //Vl(FetchElm(RetNo,'S384#1',11)); //20160507
    Tv[748] := Vl(FetchElm(RetNo, 'S385', 24)); // 20131026
    Tv[726] := Vl(FetchElm(RetNo, 'S387', 22));
    Tv[701] := Vl(FetchElm(RetNo, 'S390', 15)); // 20120426

    // Tv[703] := Vl(FetchElm(RetNo,'S391',15)); //20121010 //jz 2019 removed
    Tv[718] := Tv[715] + Tv[762] + Tv[716] + Tv[717] + Tv[748] + Tv[726] +
      Tv[701]; // jz 2019 removed +Tv[703]  //20190421  +Tv[747]+
    Tv[719] := Tv[718];
    Tv[720] := MaxR(0, Tv[712] - Tv[719]);

    Tv[721] := TotMultiple(RetNo, 'S388', 73); // 20090530
    Tv[749] := Vl(FetchElm(RetNo, 'S381', 68));
    Tv[752] := TotMultiple(RetNo, 'S384', 180);
    // Vl(FetchElm(RetNo,'S384#1',180));  //co-op     //20160507
    Tv[753] := Vl(FetchElm(RetNo, 'S385', 31)); // odour

    // Tv[702] := Vl(FetchElm(RetNo,'S390',8)); //jz 2019 removed //dev cr  //20120426

    Tv[757] := Vl(FetchElm(RetNo, 'S389', 67)); // book publishing

    Tv[750] := Tv[704] + Tv[713] + Tv[756] + Tv[757] + Tv[755] + Tv[721] +
      Tv[749] + Tv[752] + Tv[764] + Tv[766] + Tv[7];    //20250918 out 324 box elm 579 //jz 20241122 added line 329 //20221128
    // 20190924 added TV[766
    // jz 2019 removed +Tv[702]+Tv[759]+Tv[760]  //20130831  //20141101
    Tv[751] := Tv[750];
    Tv[723] := Tv[720] - Tv[751]; // Tv[21];

    { SK }
    PrvNdx := GetPrvNdx('SK');
    Tv[724] := Vl(FetchElm(RetNo, 'S411', 189));
    // Vl(FetchElm(RetNo,'S411_2',26));
    // GetPrvTaxBfrCredits(RetNo,Ret[RetNo].Province,'SK');
    Tv[741] := Vl(FetchElm(RetNo, 'POLIT', 127));
    If GetTaxationYearEnd(RetNo) < '2001/01/01' then
      Tv[741] := 0;
    Tv[740] := GetSKPolitCredit(RetNo, Tv[741]); // 20150703

    Tv[728] := Vl(FetchElm(RetNo, 'S400', 42)); // jz 2019 ??? is no 728 ???
    // Tv[727] := Vl(FetchElm(RetNo,'S402',34)); //jz 2019 removed
    Tv[738] := Vl(FetchElm(RetNo, 'S403', 130));
    // Vl(FetchElm(RetNo,'S403',24));
    Tv[739] := Vl(FetchElm(RetNo, 'S404', 88));
    Tv[738] := Vl(FetchElm(RetNo, 'S403', 24));
    Tv[725] := TotMultiple(RetNo, 'S21P', 59);

    Tv[729] := Tv[740] + Tv[725] + Tv[739] + Tv[738];
    // jz 2019 removed +Tv[727] //20160426 //Tv[729] := Tv[725]+Tv[727]+Tv[738]+Tv[739]+Tv[740]+Tv[728];
    Tv[730] := Tv[729];

    Tv[733] := MaxR(0, Tv[724] - Tv[730]);

    // Tv[734] := Vl(FetchElm(RetNo,'S410',42));   //20170525
    Tv[754] := Vl(FetchElm(RetNo, 'S402', 66));
    Tv[758] := Vl(FetchElm(RetNo, 'S403', 10));
    // Tv[734]:=Vl(FetchElm(RetNo,'S410',42));  //20161216 //20170525
    Tv[735] := Tv[731] + Tv[754] + Tv[758];
    // 20170618 //20161216 //Tv[731]+Tv[734]+Tv[754]+Tv[758];   //20161216
    // Tv[735] :=Tv[731]+Tv[734]+Tv[754]+Tv[758];
    Tv[736] := Tv[735]; // Tv[31]+Tv[34];
    Tv[732] := Tv[733] - Tv[736];
  end; { End with }

  // S5 pg 7---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    { BC }
    PrvNdx := GetPrvNdx('BC');
    (*
      If (Ret[RetNo].Province = 'BC') or (GetTxblIncomeFromS5(RetNo,'BC')<>0) then
      //ok
      else
      begin  //unprotected fields
      Tv[2]:=0;Tv[3]:=0;Tv[5]:=0;Tv[9]:=0;Tv[10]:=0;Tv[11]:=0;Strings[12]:='';
      Tv[17]:=0;
      //Tv[21]:=0;
      end;
    *)

    Tv[801] := Vl(FetchElm(RetNo, 'S427', 25));
    Tv[802] := TotMultiple(RetNo, 'S21P', 68);
    Tv[841] := MaxR(0, Vl(FetchElm(RetNo, 'S425', 347)));
    // Vl(FetchElm(RetNo,'S425',316)); //20090720
    Tv[842] := Tv[801] + Tv[841];
    Tv[843] := Tv[842];
    Tv[803] := Vl(FetchElm(RetNo, 'S21', 273)) / 3;
    Tv[804] := Vl(FetchElm(RetNo, 'S429', 32));  //20250018
    // 20210616
    // Tv[806] := Vl(FetchElm(RetNo,'POLIT',72));
    // Tv[805] := GetPolitCredit(Tv[806]);
    Tv[850] := Vl(FetchElm(RetNo, 'S2', 47)); // 20161112
    if Tv[850] > Tv[843] then Tv[850] := Tv[843]; // 20170613

    // Tv[844] := Vl(FetchElm(RetNo,'S426',134));  //20131005 //back on 20140515 //20170525
    Tv[845] := Vl(FetchElm(RetNo, 'S425', 120));
    // Tv[851]:= Vl(FetchElm(RetNo,'S426',134));  //20161216 //20170525
    Tv[814] := Tv[802] + Tv[803] + Tv[850] + Tv[809] + Tv[845];
    // 20170618 +Tv[851]; //20161216 //+Tv[844]; //20160426  //20210616 805 out
    Tv[815] := Tv[814];
    Tv[816] := MaxR(0, Tv[843] - Tv[815]);

    Tv[838] := Vl(FetchElm(RetNo, 'S421', 125));
    Tv[837] := TotMultiple(RetNo, 'S423', 76);
    Tv[846] := Vl(FetchElm(RetNo, 'S425', 106));
    Tv[813] := TotMultiple(RetNo, 'S422', 121); // 20110416
    Tv[807] := TotMultiple(RetNo, 'S428', 160);
    // Vl(FetchElm(RetNo,'S428',160)); //june 23 2009
    // Tv[20]:=Tv[21] * 90/100;  //put as worning
    If Tv[820] > Tv[821] * 90 / 100 then
      Tv[820] := Tv[821] * 90 / 100;
    Tv[847] := Vl(FetchElm(RetNo, 'S430', 161));
    Tv[2]:=Vl(FetchElm(RetNo, 'S432', 71));  //20230628
    Tv[822] := Tv[817] + Tv[813] + Tv[837] + Tv[838] + Tv[846] + Tv[820] +
      Tv[807] + Tv[804] + Tv[847]+Tv[2]+Tv[844]; //20221128 for Tv[844]
    Tv[839] := Tv[822]; // Tv[17]+Tv[13]+Tv[37]+Tv[38]+Tv[46]+Tv[20]+Tv[7];
    Tv[818] := Tv[816] - Tv[839];

    { YT }
    PrvNdx := GetPrvNdx('YT');
    Tv[831] := Vl(FetchElm(RetNo, 'S443', 217));
    Tv[830] := GetPolitCredit(Tv[829]); // 20120930
    Tv[829] := Vl(FetchElm(RetNo, 'POLIT', 122));
    Tv[828] := TotMultiple(RetNo, 'S21P', 77);
    Tv[824] := Tv[830] + Tv[828] + Tv[826];
    Tv[836] := Tv[824];
    Tv[825] := MaxR(0, Tv[831] - Tv[836]);

    Tv[819] := Vl(FetchElm(RetNo, 'S442', 15));
    Tv[848] := Vl(FetchElm(RetNo,'S444',218)); //20220704
    Tv[840] := Vl(FetchElm(RetNo,'S444',8)); //20220704
    Tv[849] := Tv[819] + Tv[848]+Tv[840];  //20230704
    Tv[851] := Tv[849]; // 201909
    Tv[827] := Tv[825] - Tv[851]; // Tv[819];

  end; { End with }
  // S5 pg 8---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 901, 902, 903);
    { NT }
    PrvNdx := GetPrvNdx('NT');
    Tv[928] := Vl(FetchElm(RetNo, 'S461', 18));
    // 20211022 //GetPrvTaxBfrCredits(RetNo,Ret[RetNo].Province,'NT');

    Tv[930] := Vl(FetchElm(RetNo, 'POLIT', 62));
    Tv[929] := GetPolitCredit(Tv[930]);
    // Tv[940] :=  Vl(FetchElm(RetNo,'S460',18));   //20181114
    Tv[931] := TotMultiple(RetNo, 'S21P', 86);
    Tv[932] := Tv[929] + Tv[931]; // +Tv[940]; //20181114
    Tv[933] := Tv[932];
    Tv[934] := MaxR(0, Tv[928] - Tv[933]);

    { NU }
    PrvNdx := GetPrvNdx('NU');
    Tv[905] := GetPrvTaxBfrCredits(RetNo, Ret[RetNo].Province, 'NU');
    Tv[907] := Vl(FetchElm(RetNo, 'POLIT', 131)); // 20100517
    Tv[906] := GetNUPolitCredit(Tv[907]);
    // Tv[913] :=  Vl(FetchElm(RetNo,'S480',18));   //20130602
    Tv[908] := TotMultiple(RetNo, 'S21P', 95);
    // Tv[912]:=Vl(FetchElm(RetNo,'S460',23));
    Tv[909] := Tv[906] + Tv[908]; // +Tv[912]; //+Tv[913];//+Tv[14]; //20130602
    Tv[910] := Tv[909];

    // 20161216
    // Tv[936]:=MaxR(0,Tv[905]-Tv[910]);  //20170618
    // Tv[937]:=TotMultiple(RetNo,'S490', 16);  //20161216 //20170525
    Tv[911] := Tv[905] - Tv[910];
    // 20160618 //20160426 //Tv[936]-Tv[937];  //20160426

    // 20171201
    Tv[935] := Tv[413] { NL }
      + Tv[422] { PE }
      + Tv[552] { ns }
      + Tv[511] { nb }
      + Tv[723] { mn }
      + Tv[732] { sk }
      + Tv[643] { ON }
      + Tv[818] { bc }
      + Tv[827] { YT }
      + Tv[934] { nw }
      + Tv[911]; // nu
  end;
  SaveTv(RetNo, FName, FNo);

end;

Procedure S6RE(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    { Real Est }
    i := 8;
    Tv[309] := 0;
    Tv[310] := 0;
    Tv[311] := 0;
    Tv[312] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[309] := Tv[309] + Tv[i];
      Tv[310] := Tv[310] + Tv[i + 1];
      Tv[311] := Tv[311] + Tv[i + 2];
      Tv[312] := Tv[312] + Tv[i + 3];
      Inc(i, 11);
    until i > 305;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

//as of last yest T2-2024. Retain until mew T2-2026 is certified by CRA
Procedure S6(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, S6ReFno: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If Strings[4] + Strings[5] = '' then Strings[5] := 'X';
    { Shares }
    i := 10;
    Tv[214] := 0;
    Tv[215] := 0;
    Tv[216] := 0;
    Tv[217] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[214] := Tv[214] + Tv[i];
      Tv[215] := Tv[215] + Tv[i + 1];
      Tv[216] := Tv[216] + Tv[i + 2];
      Tv[217] := Tv[217] + Tv[i + 3];
      Inc(i, 8);
    until i > 210;

    Tv[219] := Tv[217] + Tv[218];

    { RE }
    S6ReFno := GetFormNo('S6RE');
    Tv[247] := Vl(FetchElmFNo(RetNo, S6ReFno, 309));
    Tv[248] := Vl(FetchElmFNo(RetNo, S6ReFno, 310));
    Tv[249] := Vl(FetchElmFNo(RetNo, S6ReFno, 311));
    Tv[250] := Vl(FetchElmFNo(RetNo, S6ReFno, 312));
  end; { End with }
  // S6 pg 2---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 476, 477, 478);
    { Bonds }
    i := 306;
    Tv[375] := 0;
    Tv[376] := 0;
    Tv[483] := 0;
    Tv[484] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[375] := Tv[375] + Tv[i];
      Tv[483] := Tv[483] + Tv[i + 1];
      Tv[484] := Tv[484] + Tv[i + 2];
      Tv[376] := Tv[376] + Tv[i + 3];
      Inc(i, 9);
    until i > 369;

    { Other prop }
    i := 380;
    Tv[421] := 0;
    Tv[422] := 0;
    Tv[487] := 0;
    Tv[488] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[421] := Tv[421] + Tv[i];
      Tv[487] := Tv[487] + Tv[i + 1];
      Tv[488] := Tv[488] + Tv[i + 2];
      Tv[422] := Tv[422] + Tv[i + 3];
      Inc(i, 7);
    until i > 415;

    { Pers use }
    i := 425;
    Tv[443] := 0;
    Tv[444] := 0;
    Tv[491] := 0;
    Tv[492] := 0;
    Repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      Tv[443] := Tv[443] + Tv[i];
      Tv[491] := Tv[491] + Tv[i + 1];
      Tv[492] := Tv[492] + Tv[i + 2];
      Tv[444] := Tv[444] + Tv[i + 3];
      Inc(i, 6);
    until i > 437;
  end; { End with }
  // S6 pg 3---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 501, 502, 503);
    { Listed prop }
    i := 507;
    Tv[530] := 0;
    Tv[531] := 0;
    Tv[532] := 0;
    Tv[533] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[530] := Tv[530] + Tv[i];
      Tv[531] := Tv[531] + Tv[i + 1];
      Tv[532] := Tv[532] + Tv[i + 2];
      Tv[533] := Tv[533] + Tv[i + 3];
      Inc(i, 7);
    until i > 521;

    Tv[534] := Vl(FetchElm(RetNo, 'S4', 222));

    Tv[535] := Tv[533] - Tv[534];
  end;
  // S6 pg 4---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 601, 602, 603);
    { abil }
    i := 607;
    Tv[667] := 0;
    Tv[668] := 0;
    Tv[669] := 0;
    Tv[670] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2]; { Tv[I+1]+Tv[i+2]-TV[i]; }
      If Tv[i + 3] > 0 then
        Tv[i + 3] := 0;
      Tv[667] := Tv[667] + Tv[i];
      Tv[668] := Tv[668] + Tv[i + 1];
      Tv[669] := Tv[669] + Tv[i + 2];
      Tv[670] := Tv[670] + Tv[i + 3];
      Inc(i, 7);
    until i > 663;

    Tv[698] := Tv[670];
    Tv[686] := Round(Tv[698] / 2);

    Tv[680] := Vl(FetchElm(RetNo, 'S6', 219)) + Vl(FetchElm(RetNo, 'S6', 250)) +
      Vl(FetchElm(RetNo, 'S6', 376)) + Vl(FetchElm(RetNo, 'S6', 422)) +
      Vl(FetchElm(RetNo, 'S6', 444)) + MaxR(0, Vl(FetchElm(RetNo, 'S6', 535)));

    Tv[681] := Vl(FetchElm(RetNo, 'S13', 28)) + Vl(FetchElm(RetNo, 'S13', 29));
    If Tv[679] < 0 then
      Tv[679] := 0; // 20141124
    Tv[682] := Tv[680] + Tv[679] + Tv[681];
    Tv[683] := Vl(FetchElm(RetNo, 'S13', 30));
    Tv[684] := Tv[682] - Tv[683];
    // page 4
    Tv[672] := Tv[684];
    Tv[699] := Tv[674] + Tv[677];
    Tv[700] := Tv[699];
    Tv[252] := Tv[672] - Tv[700];

    Tv[696] := MinR(Tv[246], Tv[251]);
    Tv[701] := Vl(FetchElm(RetNo, 'S73', 503));
    Tv[702] := Tv[701] * 2;
    Tv[703] := Tv[252] + Tv[696] + Tv[702];
    Tv[704] := Vl(FetchElm(RetNo, 'S73', 511));
    Tv[705] := Tv[704] * 2;
    Tv[253] := Tv[703] + Tv[705]; // 2021098
    If Tv[255] > 0 then
      Tv[254] := 2 * Tv[255];
    Tv[678] := Tv[253] - Tv[254]; // 20210908 //Tv[703]-Tv[705];
    // 20140511
    Tv[697] := 0;
    Tv[685] := 0;
    If Tv[678] < 0 then
      Tv[697] := Tv[678];
    If Tv[678] >= 0 then
      Tv[685] := RoundUp(Tv[678] / 2); // insted of round
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;




(* Activate this T2-2026 New S6 Procedure only when CRA approves it
Procedure S6(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, S6ReFno: integer;
  DispositionDate:String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    //Shares
    Tv[214] := 0;
    Tv[215] := 0;
    Tv[216] := 0;
    Tv[217] := 0;
    i := 10;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[214] := Tv[214] + Tv[i];
      Tv[215] := Tv[215] + Tv[i + 1];
      Tv[216] := Tv[216] + Tv[i + 2];
      Tv[217] := Tv[217] + Tv[i + 3];
      Inc(i, 8);
    until i > 210;

    Tv[219] := Tv[217] + Tv[218];

  //---------------------------------------
  //20251107
   //SHARES By period
  //break dispositions by date
   Tv[253]:=0;   //A1
   Tv[256]:=0;    //A2

   i := 10; //proceeds first index
   j := 220;  //Date of dispostion first Index
   Repeat
    if ((GetTaxationYearStart(RetNo)<'2024/06/25')
    and (GetTaxationYearEnd(RetNo)>'2024/06/24')) then
    Begin
     If Strings[j]<'2024/06/25' then
      Tv[253]:=Tv[253]+Tv[i+3]   //A1
     Else
      Tv[256]:=Tv[256]+Tv[i+3];    //A2
    // Inc(i,8);   //proceeds increment
    // Inc(j,1);   //date col incrment
    End
    Else
    begin
     Tv[253]:=0;   //a1
     Tv[256]:=0;   //a2
    end;
    Inc(i,8);   //proceeds increment
    Inc(j,1);   //date col incrment
   Until i>210;  //last proceeds

  //--------------------------------
    { RE }
    S6ReFno := GetFormNo('S6RE');
    Tv[247] := Vl(FetchElmFNo(RetNo, S6ReFno, 309));
    Tv[248] := Vl(FetchElmFNo(RetNo, S6ReFno, 310));
    Tv[249] := Vl(FetchElmFNo(RetNo, S6ReFno, 311));
    Tv[250] := Vl(FetchElmFNo(RetNo, S6ReFno, 312));

  end; { End with }


  // S6 pg 2---------------------------------------------------------------------

  //BONDS
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 476, 477, 478);
    { Bonds }
    i := 306;
    Tv[375] := 0;
    Tv[376] := 0;
    Tv[483] := 0;
    Tv[484] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[375] := Tv[375] + Tv[i];
      Tv[483] := Tv[483] + Tv[i + 1];
      Tv[484] := Tv[484] + Tv[i + 2];
      Tv[376] := Tv[376] + Tv[i + 3];
      Inc(i, 9);
    until i > 369;

   //BONDS By period  /20241112
  //break dispositions by date
   Tv[259]:=0;   //C1
   Tv[260]:=0;    //C2

   i := 306; //proceeds first index
   j := 446;  //Date of dispostion first Index
   Repeat
    if ((GetTaxationYearStart(RetNo)<'2024/06/25')
    and (GetTaxationYearEnd(RetNo)>'2024/06/24')) then
    Begin
     If Strings[j]<'2024/06/25' then
      Tv[259]:=Tv[259]+Tv[i+3]   //C1
     Else
      Tv[260]:=Tv[260]+Tv[i+3];    //c2
   //  Inc(i,9);   //proceeds increment
   //  Inc(j,1);   //date col incrment
    End
    Else
    begin
     Tv[259]:=0;   //c1
     Tv[260]:=0;   //c2
    end;

    Inc(i,9);   //proceeds increment
    Inc(j,1);   //date col incrment
   Until i>369;  //last proceeds

    { Other prop }
    i := 380;
    Tv[421] := 0;
    Tv[422] := 0;
    Tv[487] := 0;
    Tv[488] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[421] := Tv[421] + Tv[i];
      Tv[487] := Tv[487] + Tv[i + 1];
      Tv[488] := Tv[488] + Tv[i + 2];
      Tv[422] := Tv[422] + Tv[i + 3];
      Inc(i, 7);
    until i > 415;


   //Oth prop By period  /20241112
  //break dispositions by date
   Tv[261]:=0;   //D1
   Tv[262]:=0;    //D2

   i := 380; //proceeds first index
   j := 455;  //Date of dispostion first Index
   Repeat
    if ((GetTaxationYearStart(RetNo)<'2024/06/25')
    and (GetTaxationYearEnd(RetNo)>'2024/06/24')) then
    Begin
     If Strings[j]<'2024/06/25' then
      Tv[261]:=Tv[261]+Tv[i+3]   //d1
     Else
      Tv[262]:=Tv[260]+Tv[i+3];    //d2
   //  Inc(i,7);   //proceeds increment
   //  Inc(j,1);   //date col incrment
    End
    Else
    begin
     Tv[261]:=0;   //c1
     Tv[262]:=0;   //c2
    end;

    Inc(i,7);   //proceeds increment
    Inc(j,1);   //date col incrment
    Until i>421;  //last proceeds

    { Pers use }
    i := 425;
    Tv[443] := 0;
    Tv[444] := 0;
    Tv[491] := 0;
    Tv[492] := 0;
    Repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      Tv[443] := Tv[443] + Tv[i];
      Tv[491] := Tv[491] + Tv[i + 1];
      Tv[492] := Tv[492] + Tv[i + 2];
      Tv[444] := Tv[444] + Tv[i + 3];
      Inc(i, 6);
    until i > 437;
  end; { End with }

  // S6 pg 3---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 501, 502, 503);
    { Listed prop }
    i := 507;
    Tv[530] := 0;
    Tv[531] := 0;
    Tv[532] := 0;
    Tv[533] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[530] := Tv[530] + Tv[i];
      Tv[531] := Tv[531] + Tv[i + 1];
      Tv[532] := Tv[532] + Tv[i + 2];
      Tv[533] := Tv[533] + Tv[i + 3];
      Inc(i, 7);
    until i > 521;

    Tv[534] := Vl(FetchElm(RetNo, 'S4', 222));

    Tv[535] := Tv[533] - Tv[534];
  end;
  // S6 pg 4---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 601, 602, 603);
    { abil }
    i := 607;
    Tv[667] := 0;
    Tv[668] := 0;
    Tv[669] := 0;
    Tv[670] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2]; { Tv[I+1]+Tv[i+2]-TV[i]; }
      If Tv[i + 3] > 0 then
        Tv[i + 3] := 0;
      Tv[667] := Tv[667] + Tv[i];
      Tv[668] := Tv[668] + Tv[i + 1];
      Tv[669] := Tv[669] + Tv[i + 2];
      Tv[670] := Tv[670] + Tv[i + 3];
      Inc(i, 7);
    until i > 663;

    Tv[698] := Tv[670];
    Tv[686] := Round(Tv[698] / 2);

    Tv[680] := Vl(FetchElm(RetNo, 'S6', 219)) + Vl(FetchElm(RetNo, 'S6', 250)) +
      Vl(FetchElm(RetNo, 'S6', 376)) + Vl(FetchElm(RetNo, 'S6', 422)) +
      Vl(FetchElm(RetNo, 'S6', 444)) + MaxR(0, Vl(FetchElm(RetNo, 'S6', 535)));

    Tv[681] := Vl(FetchElm(RetNo, 'S13', 28)) + Vl(FetchElm(RetNo, 'S13', 29));
    If Tv[679] < 0 then
      Tv[679] := 0; // 20141124
    Tv[682] := Tv[680] + Tv[679] + Tv[681];
    Tv[683] := Vl(FetchElm(RetNo, 'S13', 30));
    Tv[684] := Tv[682] - Tv[683];
    // page 4
    Tv[672] := Tv[684];
    Tv[699] := Tv[674] + Tv[677];
    Tv[700] := Tv[699];
    Tv[252] := Tv[672] - Tv[700];

    Tv[696] := MinR(Tv[246], Tv[251]);
    Tv[701] := Vl(FetchElm(RetNo, 'S73', 503));
    Tv[702] := Tv[701] * 2;
    Tv[703] := Tv[252] + Tv[696] + Tv[702];
    Tv[704] := Vl(FetchElm(RetNo, 'S73', 511));
    Tv[705] := Tv[704] * 2;
  //  Tv[253] := Tv[703] + Tv[705]; // 2021098
    If Tv[255] > 0 then
      Tv[254] := 2 * Tv[255];
    Tv[678] := Tv[253] - Tv[254]; // 20210908 //Tv[703]-Tv[705];
    // 20140511
    Tv[697] := 0;
    Tv[685] := 0;
    If Tv[678] < 0 then
      Tv[697] := Tv[678];
    If Tv[678] >= 0 then
      Tv[685] := RoundUp(Tv[678] / 2); // insted of round
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;
*)

(*  This may be last year's T2-2024
Procedure S6(RetNo: integer; FName: string; FNo: integer);
Var
  i, j, S6ReFno: integer;
  DispositionDate:String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    //Shares
    Tv[214] := 0;
    Tv[215] := 0;
    Tv[216] := 0;
    Tv[217] := 0;
    i := 10;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[214] := Tv[214] + Tv[i];
      Tv[215] := Tv[215] + Tv[i + 1];
      Tv[216] := Tv[216] + Tv[i + 2];
      Tv[217] := Tv[217] + Tv[i + 3];
      Inc(i, 8);
    until i > 210;

    Tv[219] := Tv[217] + Tv[218];




  //---------------------------------------
  //20251107
  //break share dispositions by date
   Tv[253]:=0;
   Tv[256]:=0;
   //DispositionDate:=Strings[220];
   i := 10; //gains column index
   j := 220;  //dispostion Index
   Repeat
    if ((GetTaxationYearStart(RetNo)<'2024/06/25')
    and (GetTaxationYearEnd(RetNo)>'2024/06/24')) then
    Begin
     If (Strings[j]>'') and (Strings[j]<'2024/06/25') then
     begin
      Tv[253]:=Tv[253]+Tv[i+3];
      //xx:=Tv[253];
     end
     Else if (Strings[j]>'') then
     begin
      Tv[256]:=Tv[256]+Tv[i+3];
      //xx:=Tv[256];
     end;
//     Inc(i,8); //jz 20241113 was here, bever get heres, causes infinite loop
//     Inc(j,1);
    End
    Else
    begin
     Tv[253]:=0;
     Tv[256]:=0;
    end;

    //jz 20241113 moved here so that it always increments
    Inc(i,8);
    Inc(j,1);

    Until i>210;


{
  //---------------------------------------
  //20251107
  //break share dispositions by date
   Tv[253]:=0;
   Tv[256]:=0;
   //DispositionDate:=Strings[220];
   i := 10; //gains column index
   j := 220;  //dispostion Index
   Repeat
    if ((GetTaxationYearStart(RetNo)<'2024/06/25')
    and (GetTaxationYearEnd(RetNo)>'2024/06/24')) then
    Begin
     If Strings[j]<'2024/06/25' then
      Tv[253]:=Tv[253]+Tv[i+3]
     Else
      Tv[256]:=Tv[256]+Tv[i+3];
     Inc(i,8);
     Inc(j,1);
    End
    Else
    begin
     Tv[253]:=0;
     Tv[256]:=0;
    end;
    Until i>210;

}








  //--------------------------------
    { RE }
    S6ReFno := GetFormNo('S6RE');
    Tv[247] := Vl(FetchElmFNo(RetNo, S6ReFno, 309));
    Tv[248] := Vl(FetchElmFNo(RetNo, S6ReFno, 310));
    Tv[249] := Vl(FetchElmFNo(RetNo, S6ReFno, 311));
    Tv[250] := Vl(FetchElmFNo(RetNo, S6ReFno, 312));

  // need more code her to pick up B1 and B2 from S6RE

  end; { End with }

  //showmessage(floattostr(Ret[1].Frm[103].Tv[256]));
  //OutputDebugString('test');
  //OutputDebugString(pchar(floattostr(Ret[1].Frm[103].Tv[256])));

  // S6 pg 2---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 476, 477, 478);
    { Bonds }
    i := 306;
    Tv[375] := 0;
    Tv[376] := 0;
    Tv[483] := 0;
    Tv[484] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[375] := Tv[375] + Tv[i];
      Tv[483] := Tv[483] + Tv[i + 1];
      Tv[484] := Tv[484] + Tv[i + 2];
      Tv[376] := Tv[376] + Tv[i + 3];
      Inc(i, 9);
    until i > 369;

    { Other prop }
    i := 380;
    Tv[421] := 0;
    Tv[422] := 0;
    Tv[487] := 0;
    Tv[488] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[421] := Tv[421] + Tv[i];
      Tv[487] := Tv[487] + Tv[i + 1];
      Tv[488] := Tv[488] + Tv[i + 2];
      Tv[422] := Tv[422] + Tv[i + 3];
      Inc(i, 7);
    until i > 415;

    { Pers use }
    i := 425;
    Tv[443] := 0;
    Tv[444] := 0;
    Tv[491] := 0;
    Tv[492] := 0;
    Repeat
      Tv[i + 3] := MaxR(0, Tv[i] - Tv[i + 1] - Tv[i + 2]);
      Tv[443] := Tv[443] + Tv[i];
      Tv[491] := Tv[491] + Tv[i + 1];
      Tv[492] := Tv[492] + Tv[i + 2];
      Tv[444] := Tv[444] + Tv[i + 3];
      Inc(i, 6);
    until i > 437;

  end; { End with }



  // S6 pg 3---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 501, 502, 503);
    { Listed prop }
    i := 507;
    Tv[530] := 0;
    Tv[531] := 0;
    Tv[532] := 0;
    Tv[533] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[530] := Tv[530] + Tv[i];
      Tv[531] := Tv[531] + Tv[i + 1];
      Tv[532] := Tv[532] + Tv[i + 2];
      Tv[533] := Tv[533] + Tv[i + 3];
      Inc(i, 7);
    until i > 521;

    Tv[534] := Vl(FetchElm(RetNo, 'S4', 222));

    Tv[535] := Tv[533] - Tv[534];
  end;
  // S6 pg 4---------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 601, 602, 603);
    { abil }
    i := 607;
    Tv[667] := 0;
    Tv[668] := 0;
    Tv[669] := 0;
    Tv[670] := 0;
    Repeat
      Tv[i + 3] := Tv[i] - Tv[i + 1] - Tv[i + 2]; { Tv[I+1]+Tv[i+2]-TV[i]; }
      If Tv[i + 3] > 0 then
        Tv[i + 3] := 0;
      Tv[667] := Tv[667] + Tv[i];
      Tv[668] := Tv[668] + Tv[i + 1];
      Tv[669] := Tv[669] + Tv[i + 2];
      Tv[670] := Tv[670] + Tv[i + 3];
      Inc(i, 7);
    until i > 663;

    Tv[698] := Tv[670];
    Tv[686] := Round(Tv[698] / 2);

    Tv[680] := Vl(FetchElm(RetNo, 'S6', 219)) + Vl(FetchElm(RetNo, 'S6', 250)) +
      Vl(FetchElm(RetNo, 'S6', 376)) + Vl(FetchElm(RetNo, 'S6', 422)) +
      Vl(FetchElm(RetNo, 'S6', 444)) + MaxR(0, Vl(FetchElm(RetNo, 'S6', 535)));

    Tv[681] := Vl(FetchElm(RetNo, 'S13', 28)) + Vl(FetchElm(RetNo, 'S13', 29));
    If Tv[679] < 0 then
      Tv[679] := 0; // 20141124
    Tv[682] := Tv[680] + Tv[679] + Tv[681];
    Tv[683] := Vl(FetchElm(RetNo, 'S13', 30));
    Tv[684] := Tv[682] - Tv[683];
    // page 4
    Tv[672] := Tv[684];
    Tv[699] := Tv[674] + Tv[677];
    Tv[700] := Tv[699];
    Tv[252] := Tv[672] - Tv[700];

    Tv[696] := MinR(Tv[246], Tv[251]);
    Tv[701] := Vl(FetchElm(RetNo, 'S73', 503));
    Tv[702] := Tv[701] * 2;
    Tv[703] := Tv[252] + Tv[696] + Tv[702];
    Tv[704] := Vl(FetchElm(RetNo, 'S73', 511));
    Tv[705] := Tv[704] * 2;

    //Tv[253] := Tv[703] + Tv[705]; // 2021098
    //xx:=Tv[703];
    //xx:=Tv[705];
    //xx:=Tv[253];

    If Tv[255] > 0 then
      Tv[254] := 2 * Tv[255];
    Tv[678] := Tv[253] - Tv[254]; // 20210908 //Tv[703]-Tv[705];
    // 20140511
    Tv[697] := 0;
    Tv[685] := 0;
    If Tv[678] < 0 then
      Tv[697] := Tv[678];
    If Tv[678] >= 0 then
      Tv[685] := RoundUp(Tv[678] / 2); // insted of round

  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;
*)




procedure S7(RetNo: integer; FName: string; FNo: integer); // s7new
Var
  i, j, k: integer;
  BaseAmount, TheNeg, x, y: Real;
  iB1, iC1, iD1, iE1, iF1, iG1, iH1, iI1, iJ1, iK1, iH2, iF3: integer;
  // 20170523

begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    // pg1
    FillHeader(RetNo, FNo, 1, 2, 3);
   //20250524
    XX:= RoundCorrect(Vl(FetchElm(RetNo, 'S6', 685)));
    If XX>0 then Tv[6] := XX else Tv[6]:=0;

    XX:=Vl(FetchElm(RetNo, 'S6', 697));  //amount q for losses
    If XX<0 then Tv[9] :=Abs(XX) else Tv[9]:=0;

    Tv[12] := Vl(FetchElm(RetNo, 'T2', 222));
    Tv[8] := Tv[9] + Tv[12];
    Tv[15] := Tv[8];
    Tv[18] := MaxR(0, Tv[6] - Tv[15]);

    Tv[30] := Tv[227];
    Tv[11] := Tv[24] + Tv[27] + Tv[30] + Tv[33];
    Tv[14] := Tv[11];
    Tv[17] := Tv[21] - Tv[14];
    Tv[36] := Tv[17];
    Tv[42] := Tv[18] + Tv[36];
    // 20141203
    Tv[45] := Tv[261]; // 20200805
    Tv[48] := MaxR(0, Tv[42] - Tv[45]);

    Tv[39] := MaxR(0, Tv[35] - Tv[38]);
    Tv[309] := Vl(FetchElm(RetNo, 'S3', 114)); // 20190710 instead of 112 ONLY if CONNECTED for box 370
    Tv[311] := Tv[44] + Tv[47] + Tv[309] + Tv[310];
    Tv[312] := Tv[311];
    // 20200805
    Tv[313] := Tv[21];
    Tv[41] := Tv[313] + Tv[336]; // Tv[41]:=Tv[21];  //20190710

    Tv[314] := MaxR(0, Tv[41] - Tv[312]); // Tv[41]+Tv[312];  //20190710
    Tv[315] := Tv[314];
    Tv[316] := Tv[39] + Tv[315];

    // 20200805
    Tv[337] := Tv[45];
    Tv[317] := Tv[337] + Tv[338]; // 20200805

    Tv[319] := MaxR(0, Tv[316] - Tv[317] + Tv[318]);

    (*  //20250918
    // ??? Enter Y ??
    if GetBegYearEnd(RetNo) > '2018/12/31' then // ????? //20190507
    Begin
      Tv[322] := MaxR(0, Tv[320] - Tv[321]);
      Tv[328] := Tv[324] + Tv[325] + Tv[326] + Tv[327];
      // insead of 316 //20190507
      Tv[329] := Tv[328];
      Tv[330] := MaxR(0, Tv[323] - Tv[329]);
      Tv[331] := Tv[330];
      Tv[332] := Tv[322] + Tv[331];
      Tv[335] := MaxR(0, Tv[332] - Tv[333] + Tv[334]);
    End
    Else
    Begin
      Tv[322] := 0;
      Tv[328] := 0;
      Tv[329] := 0;
      Tv[330] := 0;
      Tv[331] := 0;
      Tv[332] := 0;
      Tv[335] := 0;
    End;
   *)
    // pg3
    Tv[13] := MaxR(0, Tv[4] - Tv[7]);
    Tv[19] := MaxR(0, Tv[257] - Tv[260]);
    Tv[21] := MaxR(0, Tv[258]);
    Tv[22] := Tv[250];
    Tv[28] := Tv[226];
    Tv[31] := Tv[244];
    Tv[20] := Tv[22] + Tv[28] + Tv[31];
    Tv[34] := Tv[20];
    Tv[23] := Tv[19] - Tv[34];
    Tv[37] := Tv[23];
    Tv[40] := Tv[13] + Tv[37];
    // 20141203
    If Tv[260] > Tv[257] then
      Tv[43] := Tv[260] - Tv[257]
    else
      Tv[43] := 0;
    Tv[46] := MaxR(0, Tv[40] - Tv[43]);
  end; { End with }

  // -----------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[141] := 0;
    Tv[142] := 0;
    TheNeg := 0;
    Tv[145] := 0;
    // 20170523
    // F1 320 calc
    i := 105;
    TheNeg := 0;
    iC1 := 103;
    iD1 := 49;
    iE1 := 104;
    // Tv[141]:=0;  duplicate
    Repeat
      if GetTaxationYearStart(RetNo) < '2016/03/22' then
        Tv[iD1] := 0; // ?? needs activation
      Tv[i] := Tv[iC1] + Tv[iD1] + Tv[iE1];
      if Tv[i] < 0 then
        TheNeg := TheNeg + Tv[i];
      Tv[141] := Tv[141] + Tv[i];
      Inc(i, 8);
      Inc(iC1, 8);
      Inc(iD1, 1);
      Inc(iE1, 8);
    Until i > 137;

    // H1 330 calc
    i := 107;
    iB1 := 102;
    iC1 := 103;
    iG1 := 106;
    Repeat
      if (Tv[iB1] = 0) Or (Tv[iC1] < 0) then
        Tv[i] := 0
      Else
        Tv[i] := (Tv[iC1] / Tv[iB1]) *
          (500000 * (MyStrToInt(Strings[iG1]) / 365));
      Inc(i, 8);
      Inc(iB1, 8);
      Inc(iC1, 8);
      Inc(iG1, 8);
    Until i > 139;

    // I1  335 calc
    i := 54;
    iH2 := 176; // from table2
    Repeat
      Tv[i] := Tv[iH2];
      Inc(i, 1);
      Inc(iH2, 1);
    Until i > 58;

    // J1 336 calc
    i := 59;
    iF3 := 288;
    Repeat
      // Tv[i]:=Tv[iF3];   //do it manually Add F3's with same name  //20170613
      Inc(i, 1);
      Inc(iF3, 1);
    Until i > 63;

    // K1 calc
    i := 64;
    iH1 := 107;
    iI1 := 54;
    iJ1 := 59;
    Repeat
      Tv[i] := Tv[iH1] + Tv[iI1] - Tv[iJ1];
      Inc(i, 1);
      Inc(iH1, 8);
      Inc(iI1, 1);
      Inc(iJ1, 1);
    Until i > 68;

    // L1 calc
    i := 166;
    iF1 := 105;
    iK1 := 64;
    Tv[145] := 0;
    Repeat
      Tv[i] := MaxR(0, Tv[iF1] - Tv[iK1]);
      Tv[145] := Tv[145] + Tv[i];
      Inc(i, 1);
      Inc(iF1, 8);
      Inc(iK1, 1);
    Until i > 170;

    // M1 calc
    i := 108;
    iF1 := 105;
    iK1 := 64;
    Tv[142] := 0;
    Repeat
      if Tv[iF1] < 0 then
        Tv[i] := 0
      Else
        Tv[i] := MinR(Tv[iF1], Tv[iK1]);
      Tv[142] := Tv[142] + Tv[i];
      Inc(i, 8);
      Inc(iF1, 8);
      Inc(iK1, 1);
    Until i > 140;

    Tv[144] := ABS(TheNeg);
    Tv[164] := Tv[143] + Tv[144];
    Tv[146] := MinR(Tv[145], Tv[164]);
    Tv[147] := Tv[142] + Tv[146];

    // PART 3
    // No calculation  but it needs validtion of dates etcB/N

    // PART 4

    Tv[148] := Tv[141];
    { Net Adj }
    Tv[149] := Tv[144];
    Tv[150] := Tv[148] + Tv[149];
    Tv[151] := Tv[147];
    Tv[152] := MaxR(0, Tv[150] - Tv[151]);
    if Tv[148] < 0 then
      Tv[152] := 0;

    Tv[153] := GetNetInc(RetNo);
    // 20130606
    Tv[10] := Vl(FetchElm(RetNo, 'S1', 40));
    Tv[16] := Tv[153] + Tv[10]; // 20130606
    Tv[25] := Tv[16];

    Tv[155] := Vl(FetchElm(RetNo, 'S1', 17));
    // 20141203
    Tv[156] := Tv[21] // Vl(FetchElm(RetNo,'S7',21))
      - Tv[24] // -Vl(FetchElm(RetNo,'S7',24))
      - Tv[27] // -Vl(FetchElm(RetNo,'S7',27))
      - Tv[45]; // -Vl(FetchElm(RetNo,'S7',45));
    Tv[161] := Tv[154] + Tv[155] + Tv[156] + Tv[157]; // 20130831
    Tv[158] := Tv[161];
    Tv[159] := Tv[25] - Tv[158]; // Tv[153] - Tv[158];    //20130606
    Tv[160] := Tv[152];

    Tv[100] := Tv[308]; // 20170601

    Tv[29] := Tv[160] + Tv[26] + Tv[99] + Tv[100];
    // jz //Tv[29]:=Tv[160]+Tv[26];
    Tv[32] := Tv[29];

    // jz
    // part 6
    // line 615
    Tv[308] := 0;
    for i := 298 to 302 do
      Tv[308] := Tv[308] + Tv[i];
    // jz
    // line 625
    Tv[262] := 0;
    for i := 303 to 307 do
      Tv[262] := Tv[262] + Tv[i];

    Tv[165] := Tv[262]; // jz

    Tv[162] := MaxR(0, Tv[159] - Tv[32] + Tv[165]); // jz

    // ??????????????
    // TV[163]:=Tv[162]; //20160609 Hidden box to capture the Active business income when not CCPC to be used in S27

  end; { End with }

  with Ret[RetNo].Frm[FNo] do
  begin
    if (Ret[RetNo].CorpType = CCPC)
    Or (Ret[RetNo].CorpType=OtherPrivate)    //20250524
    then
      // continue
    else
    begin
      For i := 1 to 82 do
        Tv[i] := 0;
      For i := 1 to 162 do
        Tv[i] := 0; // 20150120
      SaveTv(RetNo, FName, FNo);
      Exit;
    end;

    // rental
    x := TotMultiple(RetNo, 'S7RENT', 71);
    y := TotMultiple(RetNo, 'S7RENT', 72);
    Tv[201] := x;
    Tv[202] := y;
    // If x+y<>0 then begin Tv[1]:=x;Tv[2]:=y;end;

    Tv[221] := Vl(FetchElm(RetNo, 'T2', 219));
    Tv[219] := MaxR(0, Tv[221] - Tv[220]);

    For i := 256 to 261 do
      Tv[i] := 0;

    { Vertical }
    i := 201;
    Repeat
      Tv[i + 6] := Tv[i] - Tv[i + 3]; { First column net }
      Tv[i + 1 + 6] := Tv[i + 1] - Tv[i + 1 + 3]; { second column net }
      Inc(i, 9);
    until i > 243;

    { Get totals col }
    i := 201;
    repeat
      Tv[i + 2] := Tv[i] + Tv[i + 1];
      Inc(i, 3);
    until i > 243;

    { other income section }
    i := 246;
    repeat
      Tv[i + 2] := Tv[i] + Tv[i + 1];
      Inc(i, 3);
    until i > 249;

    Tv[255] := Tv[253] + Tv[254];
    Tv[266] := Tv[264] + Tv[265];
    Tv[270] := Tv[268] + Tv[269];

    Tv[274] := Tv[272] + Tv[273];
    Tv[278] := Tv[276] + Tv[277];
    Tv[282] := Tv[280] + Tv[281];

    // other losses as positive
    Tv[272] := MaxR(0, Tv[272]);
    Tv[273] := MaxR(0, Tv[273]);
    Tv[276] := MaxR(0, Tv[276]);
    Tv[277] := MaxR(0, Tv[277]);
    Tv[280] := MaxR(0, Tv[280]);
    Tv[281] := MaxR(0, Tv[281]);

    { grand totals }
    i := 207;
    repeat
      If Tv[i] > 0 then
        Tv[256] := Tv[256] + Tv[i]
      else
        Tv[259] := Tv[259] + ABS(Tv[i]);
      If Tv[i + 1] > 0 then
        Tv[257] := Tv[257] + Tv[i + 1]
      else
        Tv[260] := Tv[260] + ABS(Tv[i + 1]);
      If Tv[i + 2] > 0 then
        Tv[258] := Tv[258] + Tv[i + 2]
      else
        Tv[261] := Tv[261] + ABS(Tv[i + 2]);
      Inc(i, 9);
    until i > 243;

    i := 246;
    Repeat
    begin
      If Tv[i] > 0 then
        Tv[256] := Tv[256] + Tv[i]
      else
        Tv[259] := Tv[259] + ABS(Tv[i]);
      If Tv[i + 1] > 0 then
        Tv[257] := Tv[257] + Tv[i + 1]
      else
        Tv[260] := Tv[260] + ABS(Tv[i + 1]);
      If Tv[i + 2] > 0 then
        Tv[258] := Tv[258] + Tv[i + 2]
      else
        Tv[261] := Tv[261] + ABS(Tv[i + 2]);
    end;
    Inc(i, 3);
    until i > 249;

    i := 253;
    If Tv[i] > 0 then
      Tv[256] := Tv[256] + Tv[i]
    else
      Tv[259] := Tv[259] + ABS(Tv[i]);
    If Tv[i + 1] > 0 then
      Tv[257] := Tv[257] + Tv[i + 1]
    else
      Tv[260] := Tv[260] + ABS(Tv[i + 1]);
    If Tv[i + 2] > 0 then
      Tv[258] := Tv[258] + Tv[i + 2]
    else
      Tv[261] := Tv[261] + ABS(Tv[i + 2]);

    i := 264;
    If Tv[i] > 0 then
      Tv[256] := Tv[256] + Tv[i]
    else
      Tv[259] := Tv[259] + ABS(Tv[i]);
    If Tv[i + 1] > 0 then
      Tv[257] := Tv[257] + Tv[i + 1]
    else
      Tv[260] := Tv[260] + ABS(Tv[i + 1]);
    If Tv[i + 2] > 0 then
      Tv[258] := Tv[258] + Tv[i + 2]
    else
      Tv[261] := Tv[261] + ABS(Tv[i + 2]);

    i := 268;
    If Tv[i] > 0 then
      Tv[256] := Tv[256] + Tv[i]
    else
      Tv[259] := Tv[259] + ABS(Tv[i]);
    If Tv[i + 1] > 0 then
      Tv[257] := Tv[257] + Tv[i + 1]
    else
      Tv[260] := Tv[260] + ABS(Tv[i + 1]);
    If Tv[i + 2] > 0 then
      Tv[258] := Tv[258] + Tv[i + 2]
    else
      Tv[261] := Tv[261] + ABS(Tv[i + 2]);

    Tv[259] := Tv[259] + Tv[272] + Tv[276] + Tv[280];
    Tv[260] := Tv[260] + Tv[273] + Tv[277] + Tv[281];
    Tv[261] := Tv[261] + Tv[274] + Tv[278] + Tv[282];

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure S8LH(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    CalcCommonS8LH(RetNo, FName, FNo);
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure CalcCommonS8LH(RetNo: integer; FName: string; FNo: integer);
Var
  i, j: integer;
  Yr1, Yr2, LeaseTerm: integer;
  AdjUCC, CCARate: Real;
  DaysInTaxYear: integer;
begin
  LoadTv(RetNo, FName, FNo);
  DaysInTaxYear := Ret[RetNo].DaysInYear;
  If DaysInTaxYear > 365 then
    DaysInTaxYear := 365;

  with Ret[RetNo].Frm[FNo] do
  begin
    For i := 141 to 148 do
      Tv[i] := 0;
    i := 0;
    j := 151;
    Repeat
      If UpperCase(Strings[149]) <> 'Y' then // override
      begin

        Yr1 := MyStrToInt(LeftStr(Strings[i + 1], 4));
        Yr2 := MyStrToInt(LeftStr(Strings[i + 2], 4));
        { LeaseTerm :=Yr2-Yr1+1; }
        If UpperCase(Strings[j]) = 'Y' then
          Tv[i + 4] := Tv[i + 3];

        LeaseTerm := DateDiffYMD(Strings[i + 1], Strings[i + 2]) div 365;
        If (LeaseTerm > 0) and (LeaseTerm < 5) then
          LeaseTerm := 5;
        If (Yr1 = 0) or (Yr2 = 0) then
          LeaseTerm := 0;
        If LeaseTerm > 0 then
          CCARate := 100 / LeaseTerm
        else
          CCARate := 0;
        If DateWithinTaxYear(Strings[i + 1], RetNo) then
          CCARate := CCARate / 2; { first year }
        Tv[i + 7] := Tv[i + 3] + Tv[i + 5] - Tv[i + 6]; { AdjOrigCost }
        Strings[i + 8] := FormatFloat('###.##', CCARate);
        AdjUCC := MaxR(0, Tv[i + 4] + Tv[i + 5] - Tv[i + 6]);
        { adjucc=start+adj-proceeds }
        Tv[i + 9] := Round((Tv[i + 7] * CCARate) / 100) * (DaysInTaxYear / 365);
        { CCA claim }

        If Tv[i + 9] > AdjUCC then
          Tv[i + 9] := AdjUCC;
        If (Tv[i + 3] = 0) or (Tv[i + 4] = 0) then
          Tv[i + 9] := 0;
        Tv[i + 10] := AdjUCC - Tv[i + 9]; { ucc=adjucc-cca }
        If Tv[i + 10] < 0 then
          Tv[i + 10] := 0; // 20100906
      end
      else
      begin
        // (* IT DOES NOT WORK
        // AdjUCC := MaxR(0,Tv[i+4]+Tv[i+5]-Tv[i+6]);  {adjucc=start+adj-proceeds} //20110526
        // Tv[i+10] := AdjUCC - Tv[i+9];        {ucc=adjucc-cca}  //20110526
        If Tv[i + 10] < 0 then
          Tv[i + 10] := 0; // 20100906
      end;
      Inc(i, 11);
    until i > 122;

    Tv[163] := 0;
    Tv[164] := 0; // invisible totals
    i := 0;
    j := 151;
    Repeat
      Tv[141] := Tv[141] + Tv[i + 3];
      Tv[142] := Tv[142] + Tv[i + 4];
      // 20101121
      If UpperCase(Strings[j]) = 'Y' then
        Tv[164] := Tv[164] + Tv[i + 4]
      Else
        Tv[163] := Tv[163] + Tv[i + 4];
      Tv[143] := Tv[143] + Tv[i + 5];
      Tv[144] := Tv[144] + Tv[i + 6];
      Tv[145] := Tv[145] + Tv[i + 7];
      Tv[147] := Tv[147] + Tv[i + 9];
      Tv[148] := Tv[148] + Tv[i + 10];
      Inc(i, 11);
      Inc(j, 1);
    until i > 122;
    Tv[141] := Tv[141] + Tv[133];
    Tv[142] := Tv[142] + Tv[134];
    Tv[143] := Tv[143] + Tv[135];
    Tv[144] := Tv[144] + Tv[136];
    Tv[145] := Tv[145] + Tv[137];
    Tv[147] := Tv[147] + Tv[139];
    Tv[148] := Tv[148] + Tv[140];
  end;
  SaveTv(RetNo, FName, FNo);
end;

//jz//20260525
procedure S8ALL(RetNo: integer; FName: string; FNo: integer);
Var
  n: integer;

  s8Inst, totalS8Instances, FNoS8, FNoS8H   : integer;

  s8line, s8LineInc    : integer;
  s8Allline, s8AllLineInc : integer;

  s8200, s8201, s8203, s8225, s8226, s8205, s8221, s8222,  s8207,
  s8224, s8212, s8213, s8215,s8217, s8220: integer; // index to S8)
  s8232, s8234, s8236, s8238: integer; // 20220907 immexpensing7

  s8All200, s8All201, s8All203, s8All225, s8All226, s8All205, s8All221, s8All222,
  s8All207,  s8All224, s8All212, s8All213, s8All215,s8All217, s8All220: integer; // index to S8)

begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    FillHeader(RetNo, FNo, 948, 949, 950); // 20180526

    For n := 21 to 725 do
    begin
      Strings[n] := '';
      Tv[n] := 0;
    end;

    //init S8 and S8All indxes
    s8LineInc    := 22;
    s8AllLineInc := 1;
    Tv[947]:=0; //total CCA

    //s8 indeces
    s8200 := 6;  s8201 := 7;  s8203 := 8;  s8225 := 9;  s8226 := 10; s8205 := 11;  s8221 := 12;  s8222 := 13;
    s8207 := 14;  s8224 := 22; s8212 := 23; s8213 := 24; s8215 := 25; s8217 := 26; s8220 := 27;
    //s8ALL indeces
    s8All200 := 21;  s8All201 := 68;  s8All203 := 115;  s8All225 := 162;  s8All226 := 209;  s8All205 := 256;  s8All221 :=303;  s8All222 := 350;
    s8All207 := 397; s8All224 := 444; s8All212 := 491; s8All213 := 538; s8All215 := 585; s8All217 := 632; s8All220 := 679;

    { //s8ALL form had to be changed as elms where not in proper order
    s8All200  := 6;  s8All201 := 7;  s8All203 := 8;  s8All225 := 9;  s8All226 := 10;  s8All205 := 11;  s8All221 :=12;  s8All222 := 13;
    s8All207 := 14;
    s8All224 := 15; s8All212 := 16; s8All213 := 17; s8All215 := 18; s8All217 := 19; s8All220 := 20;
    }

    totalS8Instances := CountMultipleInstances(RetNo,'S8');  // 4; //index to s8 instances 5 of them
    For s8Inst := 1 to totalS8Instances do
    begin
      FNoS8 := GetFormNo('S8#' + AllTrim(IntToStr(s8Inst))); // s8Inst goes to next s8

      If Ret[RetNo].FrmHasData[FNoS8] then
      begin
        If s8Inst = 1 then
        begin
          Strings[4] := FetchElmFNo(RetNo, FNoS8, 4); // 20221103
          Strings[5] := FetchElmFNo(RetNo, FNoS8, 5);
        end;

        s8line:=0;

        repeat //go line by line
          If FetchElmFNo(RetNo, FNoS8, s8200+(s8line*s8LineInc)) > '' then //source has CCA class
          begin
            Strings[s8All200+(s8Allline*s8AllLineInc)] :=    FetchElmFNo(RetNo, FNoS8, s8200+(s8line*s8lineInc));
            Tv[s8All201+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8201+(s8line*s8lineInc)));
            Tv[s8All203+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8203+(s8line*s8lineInc)));
            Tv[s8All225+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8225+(s8line*s8lineInc)));
            Tv[s8All226+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8226+(s8line*s8lineInc)));
            Tv[s8All205+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8205+(s8line*s8lineInc)));
            Tv[s8All221+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8221+(s8line*s8lineInc)));
            Tv[s8All222+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8222+(s8line*s8lineInc)));

            Tv[s8All207+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8207+(s8line*s8lineInc)));

            Tv[s8All224+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8224+(s8line*s8lineInc)));

            Strings[s8All212+(s8Allline*s8AllLineInc)] :=    FetchElmFNo(RetNo, FNoS8, s8212+(s8line*s8lineInc));

            if LeaseHold(Strings[s8200+(s8line*s8lineInc)]) then
              Strings[s8All212+(s8Allline*s8AllLineInc)] := 'NA';

            Tv[s8All213+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8213+(s8line*s8lineInc)));
            Tv[s8All215+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8215+(s8line*s8lineInc)));
            Tv[s8All217+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8217+(s8line*s8lineInc)));

            Tv[947]:=Tv[947]+Tv[s8All217+(s8Allline*s8AllLineInc)];

            Tv[s8All220+(s8Allline*s8AllLineInc)]      := Vl(FetchElmFNo(RetNo, FNoS8, s8220+(s8line*s8lineInc)));

            // incr s8Allline - only when amounts is entered
            Inc(s8Allline,1);

            If s8Allline > 67 then
            Begin
              UserMsg('S8 - CCA Maximum entries exceed 46 - entries 47 and above will not be sent through Efile');
              Break;
            End;

          end;
          // incr s8line everytime a line is checked
          Inc(s8line, 1);
        until s8200+(s8line*s8lineInc) > 204;
      end; { F has data }
    end; { end of all S8 schedules }
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;



(* mine unfinished)
procedure S8ALL(RetNo: integer; FName: string; FNo: integer);
Var
  i, k, L, FNoS8, FNoS8H: integer;
  J200, j201, J203, j225, j226, j205, j221, j222, j207, j224, j212, j213,
  j215,j217, j220: integer; // index to S8)
  j232, j234, j236, j238: integer; // 20220907 immexpensing7
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    FillHeader(RetNo, FNo, 948, 949, 950); // 20180526
    For i := 6 to 898 do //544 do  20231031
    begin
      Strings[i] := '';
      Tv[i] := 0;
    end; // 20101128 //i = Index to S8All

    //init S8 and S8All indxes

    i := 0;
    Tv[947]:=0; //total CCA
     // 20210318 Igor <<<
    For L := 1 to 4 do // index to s8 instances 5 of them
    begin
      FNoS8 := GetFormNo('S8#' + AllTrim(IntToStr(L))); // L goes to next s8
      If Ret[RetNo].FrmHasData[FNoS8] then
      begin
        If L = 1 then
        begin
          Strings[4] := FetchElmFNo(RetNo, FNoS8, 4); // 20221103
          Strings[5] := FetchElmFNo(RetNo, FNoS8, 5);
        end;
        // 20210318 Igor >>>
        // i:pointer to S8ALL, j pointers to S8
        //s8 indeces
        J200 := 6;
        j201 := 7;
        J203 := 8;
        j225 := 9;
        j226 := 10;
        j205 := 11;
        j221 := 12;
        j222 := 13;
        j207 := 14;
        j224 := 22;
        j212 := 23;
        j213 := 24;
        j215 := 25;
        j217 := 26;
        j220 := 27;
        {
        //s8all rtarting indeces are the same as above
        i200 := 6;
        i201 := 7;
        i203 := 8;
        i225 := 9;
        i226 := 10;
        i205 := 11;
        i221 := 12;
        i222 := 13;
        i207 := 14;
        i224 := 15;
        i212 := 16;
        i213 := 17;
        i215 := 18;
        i217 := 19;
        i220 := 20;
        }
        repeat
          If FetchElmFNo(RetNo, FNoS8, J200) > '' then { source has CCA class }
          begin
            Strings[i + 6] := FetchElmFNo(RetNo, FNoS8, J200);
            Tv[i + 7] := Vl(FetchElmFNo(RetNo, FNoS8, j201));
            Tv[i + 8] := Vl(FetchElmFNo(RetNo, FNoS8, j203));
            Tv[i + 9] := Vl(FetchElmFNo(RetNo, FNoS8, j225));
            Tv[i + 10] := Vl(FetchElmFNo(RetNo, FNoS8, j205));
            Tv[i + 11] := Vl(FetchElmFNo(RetNo, FNoS8, j221));
            Tv[i + 12] := Vl(FetchElmFNo(RetNo, FNoS8, j222));
            Tv[i + 13] := Vl(FetchElmFNo(RetNo, FNoS8, j207));
         //   Tv[i + 14] := Vl(FetchElmFNo(RetNo, FNoS8, j211));  //???
            Tv[i + 15] := Vl(FetchElmFNo(RetNo, FNoS8, j224));
            // Tv[i+13] := Vl(FetchElmFNo(RetNo,FNoS8,j207)); //20220907 duplicate
            Strings[i + 16] := FetchElmFNo(RetNo, FNoS8, j212);
            if LeaseHold(Strings[i + 6]) then
              Strings[i + 16] := 'NA'; // 20190622 //20190806
            Tv[i + 17] := Vl(FetchElmFNo(RetNo, FNoS8, j213));
            Tv[i + 18] := Vl(FetchElmFNo(RetNo, FNoS8, j215));
            Tv[i + 19] := Vl(FetchElmFNo(RetNo, FNoS8, j217));
            Tv[947]:=Tv[947]+Tv[i+19];
            Tv[i + 20] := Vl(FetchElmFNo(RetNo, FNoS8, j220));
            //Tv[i + 21] := Vl(FetchElmFNo(RetNo, FNoS8, j232));
            //Tv[i + 22] := Vl(FetchElmFNo(RetNo, FNoS8, j234));
            //Tv[i + 23] := Vl(FetchElmFNo(RetNo, FNoS8, j236));
            //Tv[i + 24] := Vl(FetchElmFNo(RetNo, FNoS8, j238));
            // incr both i and j indexes
            Inc(i, 15);//Inc(i, 19); // 20220907
            If i > 880 then //894 then // 20220907  //20231231
            Begin                      UserMsg('S8 - CCA Maximum entries exceed 46 - please correct');  //20231231
              Break;
            End;
            Inc(J200, 19);
            Inc(j201, 19);
            Inc(J203, 19);
            Inc(j225, 19);
            Inc(j226, 19);
            Inc(j205, 19);
            Inc(j221, 19);
            Inc(j222, 19);
            Inc(j207, 19);
            Inc(j224, 19);
            Inc(j212, 19);
            Inc(j213, 19);
            Inc(j215, 19);
            Inc(j217, 19);
            Inc(j220, 19);
          end { string[i] has data }
          else
          begin
            // incr only j indexes as above
            Inc(J200, 16);
            Inc(J200, 16);
            Inc(j201, 16);
            Inc(J203, 16);
            Inc(j225, 1);
            Inc(j205, 16);
            Inc(j221, 16);
            Inc(j222, 16);
            Inc(j207, 16);
           // Inc(j211, 16);     ???????????
            Inc(j224, 16);
            Inc(j212, 16);
            Inc(j213, 16);
            Inc(j215, 16);
            Inc(j215, 16);
            Inc(j217, 16);
            Inc(j220, 16);
            // 20220907
            Inc(j232, 1);
            Inc(j234, 1);
            Inc(j236, 1);
            Inc(j238, 1);
          end;
        until J200 > 198;
      end; { F has data }
    end; { end of all S8 schedules }
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

(*
//20260524 NO good
procedure S8ALL(RetNo: integer; FName: string; FNo: integer);
Var
  i, k, L, FNoS8, FNoS8H: integer;
  J200, j201, J203, j225, j226, j205, j221, j222, j207, j224, j212, j213,
  j215,j217, j220: integer; // index to S8)
  j232, j234, j236, j238: integer; // 20220907 immexpensing7
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    FillHeader(RetNo, FNo, 948, 949, 950); // 20180526
    For i := 6 to 898 do //544 do  20231031
    begin
      Strings[i] := '';
      Tv[i] := 0;
    end; // 20101128 //i = Index to S8All
    i := 0;
    Tv[947]:=0; //total CCA

    // 20210318 Igor <<<
    For L := 1 to 4 do // index to s8 instances 5 of them
    begin
      FNoS8 := GetFormNo('S8#' + AllTrim(IntToStr(L))); // L goes to next s8
      If Ret[RetNo].FrmHasData[FNoS8] then
      begin
        If L = 1 then
        begin
          Strings[4] := FetchElmFNo(RetNo, FNoS8, 4); // 20221103
          Strings[5] := FetchElmFNo(RetNo, FNoS8, 5);
        end;
        // 20210318 Igor >>>
        // i:pointer to S8ALL, j pointers to S8
        //s8 indeces
        J200 := 6;
        j201 := 7;
        J203 := 8;
        j225 := 9;
        j226 := 10;
        j205 := 11;
        j221 := 12;
        j222 := 13;
        j207 := 14;
        j224 := 22;
        j212 := 23;
        j213 := 24;
        j215 := 25;
        j217 := 26;
        j220 := 27;
        //s8all indeces
        i200 := 6;
        i201 := 7;
        i203 := 8;
        i225 := 9;
        i226 := 10;
        i205 := 11;
        i221 := 12;
        i222 := 13;
        i207 := 14;
        i224 := 15;
        i212 := 16;
        i213 := 17;
        i215 := 18;
        i217 := 19;
        i220 := 20;

        repeat
          If FetchElmFNo(RetNo, FNoS8, J200) > '' then { source has CCA class }
          begin
            Strings[i + 6] := FetchElmFNo(RetNo, FNoS8, J200);
            Tv[i + 7] := Vl(FetchElmFNo(RetNo, FNoS8, j201));
            Tv[i + 8] := Vl(FetchElmFNo(RetNo, FNoS8, j203));
            Tv[i + 9] := Vl(FetchElmFNo(RetNo, FNoS8, j225));
            Tv[i + 10] := Vl(FetchElmFNo(RetNo, FNoS8, j205));
            Tv[i + 11] := Vl(FetchElmFNo(RetNo, FNoS8, j221));
            Tv[i + 12] := Vl(FetchElmFNo(RetNo, FNoS8, j222));
            Tv[i + 13] := Vl(FetchElmFNo(RetNo, FNoS8, j207));
            Tv[i + 14] := Vl(FetchElmFNo(RetNo, FNoS8, j211));
            Tv[i + 15] := Vl(FetchElmFNo(RetNo, FNoS8, j224));
            // Tv[i+13] := Vl(FetchElmFNo(RetNo,FNoS8,j207)); //20220907 duplicate
            Strings[i + 16] := FetchElmFNo(RetNo, FNoS8, i212);
            if LeaseHold(Strings[i + 6]) then
              Strings[i + 16] := 'NA'; // 20190622 //20190806
            Tv[i + 17] := Vl(FetchElmFNo(RetNo, FNoS8, j213));
            Tv[i + 18] := Vl(FetchElmFNo(RetNo, FNoS8, j215));
            Tv[i + 19] := Vl(FetchElmFNo(RetNo, FNoS8, j217));
            Tv[947]:=Tv[947]+Tv[i+19];
            Tv[i + 20] := Vl(FetchElmFNo(RetNo, FNoS8, j220));
            //Tv[i + 21] := Vl(FetchElmFNo(RetNo, FNoS8, j232));
            //Tv[i + 22] := Vl(FetchElmFNo(RetNo, FNoS8, j234));
            //Tv[i + 23] := Vl(FetchElmFNo(RetNo, FNoS8, j236));
            //Tv[i + 24] := Vl(FetchElmFNo(RetNo, FNoS8, j238));
            // incr both i and j indexes
            Inc(i, 15);//Inc(i, 19); // 20220907
            If i > 880 then //894 then // 20220907  //20231231
            Begin                      UserMsg('S8 - CCA Maximum entries exceed 46 - please correct');  //20231231
              Break;
            End;
            Inc(J200, 19);
            Inc(j201, 19);
            Inc(J203, 19);
            Inc(j225, 19;
            Inc(j205, 19);
            Inc(j221, 19;
            Inc(j222, 19;
            Inc(j207, 19);
            Inc(j211, 19);
            Inc(j224, 19;
            Inc(j212, 19);
            Inc(j213, 19);
            Inc(j215, 19);
            Inc(j217, 19);
            Inc(j220, 19);
            // 20220997 ImmExpensing
            //c(j232, 1);
            //c(j234, 1);
            //c(j236, 1);
            //c(j238, 1);
          end { string[i] has data }
          else
          begin
            // incr only j indexes as above
            Inc(J200, 16);
            Inc(J200, 16);
            Inc(j201, 16);
            Inc(J203, 16);
            Inc(j225, 1);
            Inc(j205, 16);
            Inc(j221, 1);
            Inc(j222, 1);
            Inc(j207, 16);
            Inc(j211, 16);
            Inc(j224, 1);
            Inc(j212, 16);
            Inc(j213, 16);
            Inc(j215, 16);
            Inc(j215, 16);
            Inc(j217, 16);
            Inc(j220, 16);
            // 20220907
            Inc(j232, 1);
            Inc(j234, 1);
            Inc(j236, 1);
            Inc(j238, 1);
          end;
        until J200 > 198;
      end; { F has data }
    end; { end of all S8 schedules }
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;
*)


(* //20260524  last year's
// 20190428
procedure S8ALL(RetNo: integer; FName: string; FNo: integer);
Var
  i, k, L, FNoS8, FNoS8H: integer;
  J200, j201, J203, j225, j205, j221, j222, j207, j211, j224, j212, j213, j215,
    j217, j220: integer; // index to S8)
  j232, j234, j236, j238: integer; // 20220907 immexpensing7
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    FillHeader(RetNo, FNo, 948, 949, 950); // 20180526
    For i := 6 to 898 do //544 do  20231031
    begin
      Strings[i] := '';
      Tv[i] := 0;
    end; // 20101128 //i = Index to S8All
    i := 0;
    Tv[947]:=0; //total CCA
    // 20210318 Igor <<<
    For L := 1 to 4 do // index to s8 instances 5 of them
    begin
      FNoS8 := GetFormNo('S8#' + AllTrim(IntToStr(L))); // L goes to next s8
      If Ret[RetNo].FrmHasData[FNoS8] then
      begin
        If L = 1 then
        begin
          Strings[4] := FetchElmFNo(RetNo, FNoS8, 4); // 20221103
          Strings[5] := FetchElmFNo(RetNo, FNoS8, 5);
        end;
        // 20210318 Igor >>>
        // i:pointer to S8ALL, j pointers to S8
        J200 := 6;
        j201 := 7;
        J203 := 8;
        j232 := 463;
        j205 := 9;
        j221 := 265;
        j222 := 278;
        j207 := 10;
        j234 := 400;
        j236 := 424;
        j238 := 437;
        j225 := 252;
        j224 := 330; // j211:=12;
        j212 := 17;
        j213 := 18;
        j215 := 19;
        j217 := 20;
        j220 := 21;
        // 20210318 Igor <<<
        repeat
          If FetchElmFNo(RetNo, FNoS8, J200) > '' then { source has CCA class }
          begin
            Strings[i + 6] := FetchElmFNo(RetNo, FNoS8, J200);
            Tv[i + 7] := Vl(FetchElmFNo(RetNo, FNoS8, j201));
            Tv[i + 8] := Vl(FetchElmFNo(RetNo, FNoS8, J203));
            Tv[i + 9] := Vl(FetchElmFNo(RetNo, FNoS8, j225));
            Tv[i + 10] := Vl(FetchElmFNo(RetNo, FNoS8, j205));
            Tv[i + 11] := Vl(FetchElmFNo(RetNo, FNoS8, j221));
            Tv[i + 12] := Vl(FetchElmFNo(RetNo, FNoS8, j222));
            Tv[i + 13] := Vl(FetchElmFNo(RetNo, FNoS8, j207));
            Tv[i + 14] := Vl(FetchElmFNo(RetNo, FNoS8, j211));
            Tv[i + 15] := Vl(FetchElmFNo(RetNo, FNoS8, j224));
            // Tv[i+13] := Vl(FetchElmFNo(RetNo,FNoS8,j207)); //20220907 duplicate
            Strings[i + 16] := FetchElmFNo(RetNo, FNoS8, j212);
            if LeaseHold(Strings[i + 6]) then
              Strings[i + 16] := 'NA'; // 20190622 //20190806
            Tv[i + 17] := Vl(FetchElmFNo(RetNo, FNoS8, j213));
            Tv[i + 18] := Vl(FetchElmFNo(RetNo, FNoS8, j215));
            Tv[i + 19] := Vl(FetchElmFNo(RetNo, FNoS8, j217));
            Tv[947]:=Tv[947]+Tv[i+19];

            Tv[i + 20] := Vl(FetchElmFNo(RetNo, FNoS8, j220));
            Tv[i + 21] := Vl(FetchElmFNo(RetNo, FNoS8, j232));
            Tv[i + 22] := Vl(FetchElmFNo(RetNo, FNoS8, j234));
            Tv[i + 23] := Vl(FetchElmFNo(RetNo, FNoS8, j236));
            Tv[i + 24] := Vl(FetchElmFNo(RetNo, FNoS8, j238));
            // incr both i and j indexes
            Inc(i, 19); // 20220907
            If i > 880 then //894 then // 20220907  //20231231
            Begin                      UserMsg('S8 - CCA Maximum entries exceed 46 - please correct');  //20231231
              Break;
            End;
            Inc(J200, 16);
            Inc(j201, 16);
            Inc(J203, 16);
            Inc(j225, 1);
            Inc(j205, 16);
            Inc(j221, 1);
            Inc(j222, 1);
            Inc(j207, 16);
            Inc(j211, 16);
            Inc(j224, 1);
            Inc(j212, 16);
            Inc(j213, 16);
            Inc(j215, 16);
            Inc(j217, 16);
            Inc(j220, 16);
            // 20220997 ImmExpensing
            Inc(j232, 1);
            Inc(j234, 1);
            Inc(j236, 1);
            Inc(j238, 1);
          end { string[i] has data }
          else
          begin
            // incr only j indexes as above
            Inc(J200, 16);
            Inc(J200, 16);
            Inc(j201, 16);
            Inc(J203, 16);
            Inc(j225, 1);
            Inc(j205, 16);
            Inc(j221, 1);
            Inc(j222, 1);
            Inc(j207, 16);
            Inc(j211, 16);
            Inc(j224, 1);
            Inc(j212, 16);
            Inc(j213, 16);
            Inc(j215, 16);
            Inc(j215, 16);
            Inc(j217, 16);
            Inc(j220, 16);
            // 20220907
            Inc(j232, 1);
            Inc(j234, 1);
            Inc(j236, 1);
            Inc(j238, 1);
          end;
        until J200 > 198;
      end; { F has data }
    end; { end of all S8 schedules }
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;
*)
procedure S9(RetNo: integer; FName: string; FNo: integer);
Var
  i, k: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    if Strings[184] = '' then
      Strings[184] := 'N'; // no t fot template  //20170716
    if UpperCase(Strings[184]) <> 'Y' then
      Strings[186] := ''; // 20170726

    i := 4;
    Repeat // remove line
      If Strings[i] = '' then
      begin
        For k := 1 to 8 do
        begin
          Strings[i + k] := '';
          Tv[i + k] := 0;
        end;
      end;
      Inc(i, 9);
    until i > 175;

    i := 9;
    Repeat
      Strings[i - 3] := FixBusinessNumberMissingRC(Strings[i - 3]);
      // 20190822 //20190820  BN
      If RealNumeric(Strings[i]) = False then
        Strings[i] := '';
      ; // 20121205
      If RealNumeric(Strings[i + 2]) = False then
        Strings[i + 2] := ''; // 20121205
      If Tv[i + 3] < 0 then
        Tv[i + 3] := 0; // 20130602
      If Vl(Strings[i]) > 100 then
        Strings[i] := '100';
      If Vl(Strings[i + 2]) > 100 then
        Strings[i + 2] := '100';
      Inc(i, 9);
    until i > 180;
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure S11(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    i := 8;
    Repeat
      If Tv[i] = 0 then
      begin
        Strings[i + 1] := '';
        Strings[i + 2] := '';
      end;
      If Tv[i - 1] < 0 then
        Tv[i - 1] := 0;
      If Tv[i - 3] < 0 then
        Tv[i - 3] := 0;
      Inc(i, 7);
    until i > 92;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Function GetTxblIncBeforeDonations(RetNo: integer): Real;
begin
  With Ret[RetNo] do
    result := MaxR(0, Ln[300] - Ln[320] - Ln[325] - Ln[331] - Ln[332] - Ln[333]
      - Ln[334] - Ln[335] - Ln[340] - Ln[345] - Ln[350]);
end;

procedure S38(RetNo: integer; FName: string; FNo: integer);
Var
  i, j,jj,jjj: integer;  //20231001
  x: Real;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If IsLifeInsuranceCorp(RetNo) then Strings[52]:='Y';  //20231231 Value: It could T2 page 1 a Financial institution but Life Insurance
    If (IsCreditUnion(RetNo)) or ((IsLifeInsuranceCorp(RetNo)) and
      (FetchElm(RetNo, 'T2', 49) > '')) then
    begin
      For i := 5 to 20 do
        Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      Exit;
    end;
    If Strings[22] = '' then
      Strings[22] := 'Y';
    If Strings[21] = '' then
      Strings[21] := 'N';
    If (IsFedFnclInstitution(RetNo)) then
    begin
      If Strings[22] <> 'N' then
        Tv[5] := Vl(FetchElm(RetNo, 'S34', 5));
      If Strings[22] <> 'N' then
        Tv[6] := Vl(FetchElm(RetNo, 'S34', 6));
      If Strings[22] <> 'N' then
        Tv[7] := GetCapitalStock(RetNo);
      If Strings[22] <> 'N' then
        Tv[8] := GetRetainedEarnings(RetNo);
      If Strings[22] <> 'N' then
        Tv[9] := GetContributedSurplus(RetNo);
      If Strings[22] <> 'N' then
        Tv[10] := GetOtherSurpluses(RetNo);
    end;
    Tv[11] := AddColumns(5, 10, 1);
    Tv[12] := Tv[11];
    If Strings[22] <> 'N' then
      Tv[13] := Vl(FetchElm(RetNo, 'S34', 13));
    If Strings[22] <> 'N' then
      Tv[14] := Vl(FetchElm(RetNo, 'S34', 14));
    Tv[15] := Tv[13] + Tv[14];
    Tv[16] := Tv[15];
    Tv[17] := MaxR(0, Tv[12] - Tv[16]);
    If IsForeignAuthorizedBank(RetNo) then
      for i := 5 to 17 do Tv[i] := 0;

    If ((UpperCase(Strings[52])='Y') and (IsNonResidentCorp(RetNo))) then  //20231231
    //If ((IsLifeInsuranceCorp(RetNo)) and (IsNonResidentCorp(RetNo))) then
      for i := 5 to 17 do Tv[i] := 0;

    //Part 1 //20231231
    If (UpperCase(Strings[52])='Y') and (IsNonResidentCorp(RetNo)=false) then  //20231231 resident life insurance
    begin
     Tv[11]:=AddColumns(5,10,1);
     Tv[12]:=Tv[11];
     Tv[5]:=Tv[13]+Tv[14];
     Tv[16]:=Tv[15];
     Tv[17]:= MaxR(0,Tv[12]-Tv[16]);
     //Part 1 continue next pg
     Tv[32]:=AddColumns(24,31,1);
     Tv[33]:=Tv[32];
     Tv[35]:=MaxR(0,Tv[33]-Tv[34]);
    end
    Else
    begin
      for i:=5 to 17 do Tv[i]:=0;
      for i:=24 to 35 do Tv[i]:=0;
    end;

    //20231231
    If IsForeignAuthorizedBank(RetNo) then
     Tv[20] := Tv[18] + Tv[19]
    Else
      for i := 18 to 20 do Tv[i] := 0;
  end; { End with }

  // S38 pg 3 -------------------------------------------------------------------
   with Ret[RetNo].Frm[FNo] do
  begin
    if (UpperCase(Strings[52])='Y') and (IsNonResidentCorp(RetNo)=True) then
     Begin
     Tv[4]:=MaxR(Tv[118],Tv[119]);
     Tv[110]:=Tv[4];
     Tv[122]:=Tv[110]+Tv[120]+Tv[121];
     End
     Else
     begin //20231231
      Tv[4]:=0;
      Tv[110]:=0;
      for i:=118 to 122 do Tv[i]:=0;
     end;
    {
    If IsCreditUnion(RetNo) then
    begin
      For i := 101 to 122 do Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      Exit;
    end;

    If (IsFedFnclInstitution(RetNo)) then
      // ok   //20220913
    Else
    begin
      For i := 101 to 122 do Tv[i] := 0;
      SaveTv(RetNo, FName, FNo);
      Exit;
    end;
   }

   {
    if (UpperCase(Strings[52])='Y')  //life insurance //20231231
    Or ((IsLifeInsuranceCorp(RetNo)) and (IsNonResidentCorp(RetNo))) then
    begin
      Tv[4]   := MaxR(Tv[118], Tv[119]); //jz 20230530 //Tv[110] := MaxR(Tv[118], Tv[119]);
      Tv[110] := Tv[4];
      Tv[122] := Tv[110] + Tv[120] + Tv[121];
    end
    else
    begin
      for i := 118 to 122 do Tv[i] := 0;
      Tv[110] := 0;
    end;
    }
    Tv[101] := Vl(FetchElm(RetNo, 'S34', 109));
    Tv[102] := Vl(FetchElm(RetNo, 'S34', 110));
    Tv[103] := Tv[101] + Tv[102];
    Tv[104] := Tv[103];
    Tv[106] := Tv[104] + Tv[105];

    Tv[107] := MaxR(Tv[122], // 20110514 MaxR(Vl(FetchElm(RetNo,'S38',109)),
      MaxR(Tv[17], Tv[20]));
    Tv[108] := Vl(FetchElm(RetNo, 'S38', 106));
    Tv[109] := MaxR(0, Tv[107] - Tv[108]);
  end; { End with }

  // S38 pg 4 -------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    if (UpperCase(Strings[52])='Y')  //20231231
   // If (FetchElm(RetNo, 'T2', 62) = 'Life Insurance Corporation') and
    and (FetchElm(RetNo, 'T2', 48) > '') then { canadian resident lif ins }
    begin
      Tv[207] := Tv[206];
      Tv[208] := Tv[468];   //20231231
      Tv[209] := Tv[207] + Tv[208];
      Tv[210] := Tv[469];   //20231231
      Tv[211] := MaxR(0, Tv[209] - Tv[210]);
      Tv[212] := Tv[211];

      Tv[215] := Tv[470];     //20231231
      Tv[55]:=Tv[212];
      Tv[53]:=Tv[213];
      Tv[54]:=Tv[214]+Tv[215];

      //20231231
      If Tv[54] > 0 then
        Tv[216] :=Round(Tv[55] * Tv[53] / Tv[54])
      else
        Tv[216] := 0;
    end
    Else
    Begin
      For i := 207 to 216 do
        Tv[i] := 0;
    end;

    If (IsFedFnclInstitution(RetNo)) and (Strings[52]<>'Y') //(IsLifeInsuranceCorp(RetNo) = False)
    then
    begin
      Tv[217] := Tv[109]; // Tv[206];  //20170601
      Tv[218] := Vl(FetchElm(RetNo, 'S34', 104));
      Tv[219] := Vl(FetchElm(RetNo, 'S34', 106));
      If Tv[219] > 0 then
        Tv[220] := Tv[217] * Tv[218] / Tv[219]
      else
        Tv[220] := 0;
    end
    Else
      for i := 217 to 220 do
        Tv[i] := 0;

    If (FetchElm(RetNo, 'T2', 62) = 'Life Insurance Corporation') and
      (FetchElm(RetNo, 'T2', 48) = '') then { canadian non-resident lif ins }
      Tv[221] := Tv[206]
    else
      Tv[221] := 0;

    // 20110514
    If ((IsLifeInsuranceCorp(RetNo)) and (IsNonResidentCorp(RetNo))) then
      Tv[221] := Vl(FetchElm(RetNo, 'S38', 109));

    // Part IV tax
    Tv[204] := MaxR(Tv[216], MaxR(Tv[220], Tv[221]));

    If Ret[RetNo].FrmHasData[GetFormNo('S39')] then
      Tv[205] := Vl(FetchElm(RetNo, 'S39', 7))
    else
      Tv[205] := 1000000000;
    Tv[206] := MaxR(0, Tv[204] - Tv[205]);
    // 20110514 Tv[3]:=MaxR(0,Tv[4]-Tv[5]);
    Tv[225] := Tv[206];
    Tv[222] := Tv[225] * 0.0125;
    Tv[224] := Tv[222];
    If Ret[RetNo].DaysInYear < (51 * 7) then
    begin
      Tv[226] := Tv[222];
      Strings[227] := IntToStr(Ret[RetNo].DaysInYear);
      Tv[223] := Tv[226] * Vl(Strings[227]) / 365;
      Tv[224] := Tv[223];
    end;
  end; { End with }
  // S38 pg 4 -------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin

   /// FillHeader(RetNo, FNo, 328, 329, 331); // 20110514

    Tv[301] := Vl(FetchElm(RetNo, 'S38', 224));
    Tv[306] := Ret[RetNo].Ln[700];

    Tv[23] := Ret[RetNo].Ln[725];  //20230606 CON //Vl(FetchElm(RetNo, 'T2', 118)); //jz 20230530
    Tv[302] := MaxR(0, Tv[301] - Tv[306] + Tv[23]);  //jz 20230530 //  Tv[302] := MaxR(0, Tv[301] - Tv[306]);

    Tv[303] := Vl(FetchElm(RetNo, 'S42', 14));
    Tv[305] := MinR(Tv[302], Tv[303]);

    Tv[314] := Vl(FetchElm(RetNo, 'S38', 224));
    Tv[315] := MinR(Tv[314], Tv[306]);
    If Tv[316] > Tv[305] then
      Tv[316] := Tv[305];

    Tv[317]:=Ret[RetNo].Ln[725]; //20230606 CON //Vl(FetchElm(RetNo,'T2',118));  //jz 20230530

    Tv[318] := Tv[315] + Tv[316] + Tv[317]; //jz
    Tv[319] := Tv[318];
    Tv[320] := MaxR(0, Tv[314] - Tv[319]);

    Tv[309] := Ret[RetNo].Ln[700];
    Tv[311] := Vl(FetchElm(RetNo, 'S38', 224));
    Tv[325] := MaxR(0, Tv[309] - Tv[311]);
  end; { End with }
  // S38 pg 5 -------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin

    FillHeader(RetNo, FNo, 401, 402, 403);

    i := 404;
    j := 471;
    jj:=43; //20231001
    jjj:=51;
    Tv[468] := 0;
    Tv[469] := 0;
    Tv[470] := 0;
    repeat
      Strings[j] := Strings[i];
      Tv[j + 5] := Tv[j + 1] + Tv[j + 2] + Tv[j + 3] + Tv[jj]+Tv[jjj]+Tv[j+4]; //20231001 col8
      Tv[j + 8] := MaxR(0, Tv[j + 5] + Tv[j + 7]);  //2023101 col 10
      Tv[i + 1] := Tv[j + 8];
      Tv[i + 5] := MaxR(0, Tv[i + 1] - Tv[i + 2]  - Tv[i + 3] - Tv[i + 4]);  //20231001
      Tv[i + 6] := MaxR(0, Tv[i + 3] + Tv[i + 4] - Tv[i + 1]);  //20231001
      Tv[468] := Tv[468] + Tv[i + 5];
      Tv[469] := Tv[469] + Tv[i + 6];
      Tv[470] := Tv[470] + Tv[i + 7];
      Inc(i, 8);
      Inc(j, 9);
      //20231001
      Inc(jj,-1);
      Inc(jjj,-1);
    until i > 460;
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

(* //20150822  Replaced with new routine
  procedure S140(RetNo: integer;FName: string;FNo: integer);
  Var i:integer;
  begin
  If CountIncStatements(RetNo) < 2 then exit;
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  FillHeader(RetNo,FNo,1,2,3);
  Tv[4] := TotGifiMultiple(RetNo,'GIFIBS','9970');
  Tv[5] := TotGifiMultiple(RetNo,'GIFIBS','9975');
  Tv[6] := TotGifiMultiple(RetNo,'GIFIBS','9976');
  Tv[7] := TotGifiMultiple(RetNo,'GIFIBS','9980');
  Tv[8] := TotGifiMultiple(RetNo,'GIFIBS','9985');
  Tv[9] := TotGifiMultiple(RetNo,'GIFIBS','9990');
  Tv[10] := TotGifiMultiple(RetNo,'GIFIBS','9995');
  //201111160      //comprehensive income
  Tv[12] :=  TotGifiMultiple(RetNo,'GIFIIS','7000')
  +TotGifiMultiple(RetNo,'GIFIIS','7002')
  +TotGifiMultiple(RetNo,'GIFIIS','7004')
  +TotGifiMultiple(RetNo,'GIFIIS','7006')
  +TotGifiMultiple(RetNo,'GIFIIS','7008')
  +TotGifiMultiple(RetNo,'GIFIIS','7010')
  +TotGifiMultiple(RetNo,'GIFIIS','7020');

  Tv[11] := TotGifiMultiple(RetNo,'GIFIBS','9999');
  end; {End with}
  SaveTv(RetNo,FName,FNo);
  end;
*)

// 20150822
Procedure S140(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  if CountMultipleInstances(RetNo, 'S125') < 2 then // 20160506
  // If CountS125IncStatements(RetNo) < 2 then
  begin
    for i := 4 to 26 do
    begin
      Ret[RetNo].Frm[FNo].Tv[i] := 0;
    end;
    SaveTv(RetNo, FName, FNo);
    Exit;
  end;
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    Tv[4] := TotMultiple(RetNo, 'S125', 38); // ni
    Tv[5] := TotMultiple(RetNo, 'S125', 39); // ni prior yr
    { manual entry
      Tv[6] := TotMultiple(RetNo,'S125',65);
      Tv[8] := TotMultiple(RetNo,'S125',68);
      Tv[10] := TotMultiple(RetNo,'S125',71);
      Tv[12] := TotMultiple(RetNo,'S125',74);
      Tv[14] := TotMultiple(RetNo,'S125',77);
      Tv[16] := TotMultiple(RetNo,'S125',80);
    }
    Tv[18] := TotMultiple(RetNo, 'S125', 62); // tot other comprehensive income
    Tv[19] := TotMultiple(RetNo, 'S125', 63);
    // tot other comprehensive income prior
    {
      Tv[7] := TotMultiple(RetNo,'S125',66);
      Tv[9] := TotMultiple(RetNo,'S125',69);
      Tv[11] := TotMultiple(RetNo,'S125',72);
      Tv[13] := TotMultiple(RetNo,'S125',75);
      Tv[15] := TotMultiple(RetNo,'S125',78);
      Tv[17] := TotMultiple(RetNo,'S125',81);
    }

    Tv[25] := Tv[4] - Tv[6] - Tv[8] + Tv[10] - Tv[12] - Tv[14] - Tv[16]
      + Tv[18];
    Tv[26] := Tv[5] - Tv[7] - Tv[9] + Tv[11] - Tv[13] - Tv[15] - Tv[17]
      + Tv[19];

    (* old calcs
      Tv[4] := TotGifiMultiple(RetNo,'GIFIBS','9970');
      Tv[5] := TotGifiMultiple(RetNo,'GIFIBS','9975');
      Tv[6] := TotGifiMultiple(RetNo,'GIFIBS','9976');
      Tv[7] := TotGifiMultiple(RetNo,'GIFIBS','9980');
      Tv[8] := TotGifiMultiple(RetNo,'GIFIBS','9985');
      Tv[9] := TotGifiMultiple(RetNo,'GIFIBS','9990');
      Tv[10] := TotGifiMultiple(RetNo,'GIFIBS','9995');
      //201111160      //comprehensive income
      Tv[12] :=  TotGifiMultiple(RetNo,'GIFIIS','7000')
      +TotGifiMultiple(RetNo,'GIFIIS','7002')
      +TotGifiMultiple(RetNo,'GIFIIS','7004')
      +TotGifiMultiple(RetNo,'GIFIIS','7006')
      +TotGifiMultiple(RetNo,'GIFIIS','7008')
      +TotGifiMultiple(RetNo,'GIFIIS','7010')
      +TotGifiMultiple(RetNo,'GIFIIS','7020');

      Tv[11] := TotGifiMultiple(RetNo,'GIFIBS','9999');
    *)

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure S48(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 5);
    If Strings[3] = '' then
      Strings[3] := FetchElm(RetNo, 'T2', 743) + ' ' +
        FetchElm(RetNo, 'T2', 742);
    If Strings[4] = '' then
      Strings[4] := FetchElm(RetNo, 'T2', 755);
    // +' '+FetchElm(RetNo,'T2',746);
    If Strings[15] = '' then
      Strings[15] := FetchElm(RetNo, 'T2', 746);
    // +' '+FetchElm(RetNo,'T2',746);
    // Strings[5]:=GetBegYearEnd(RetNo);
    If Strings[27] = '' then
      Strings[28] := ''; // 20101201

    If Strings[7] + Strings[8] = '' then
      Strings[7] := 'X';
    If Strings[9] + Strings[10] = '' then
      Strings[10] := 'X';
    If Strings[11] + Strings[12] = '' then
      Strings[12] := 'X';
    If Strings[13] + Strings[14] = '' then
      Strings[14] := 'X';

    Tv[38] := Tv[32] + Tv[33] + Tv[34] + Tv[35] + Tv[36] + Tv[37];
    Tv[39] := Tv[38];
    Tv[41] := Tv[39] + Tv[40];
    Tv[45] := Tv[42] + Tv[43] + Tv[44];
    Tv[46] := Tv[45];
    Tv[47] := MaxR(0, Tv[41] - Tv[46]);
    Tv[48] := Tv[47] * 16 / 100;

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

// 20200607
procedure S58(RetNo: integer; FName: string; FNo: integer);
Var
  i,j,x: integer;
  d: double;

  numDaysQJ0:string;
  amountAElm, amountBElm : integer;
  numDaysQJOBefore2023Elm, numDaysQJOAfter2022Elm: integer;
  curtxyr, amountA, amountB, col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11 : integer;

  FInst: String;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FInst := UpperCase(ExtractFormInst(FName));
    FillHeader(RetNo, FNo, 1, 2, 3);
    if Strings[4] + Strings[5] = '' then
      Strings[4] := 'X';

    if (Strings[5] > '') then
    Begin
      Strings[10] := '';
      Strings[11] := '';
      Strings[12] := '';
      Strings[19] := ''; // 20200609
    end
    Else
    Begin
      if Strings[10] = '' then
        Strings[10] := GetBegYearEnd(RetNo);
      if Strings[11] = '' then
        Strings[11] := GetTaxationYearEnd(RetNo);

      Strings[19] := IntToStr(DateDiffYMD(Strings[10], Strings[11]));

      // 20200609 Days qualified
      if strtoint(Strings[19]) > 365 then //jz 20241117 if Strings[19] > '365' then
        Strings[19] := '365'; // 20201016

      numDaysQJ0 := Strings[19];

      numDaysQJOBefore2023Elm :=6;
      Strings[numDaysQJOBefore2023Elm] := numDaysQJ0;

      numDaysQJOAfter2022Elm  :=9;
      Strings[numDaysQJOAfter2022Elm]  := numDaysQJ0;
    end;

    //jz 20241117 <<
    //showmessage(Strings[10]);
    //numDaysQJOBefore2023Elm
    if Strings[10] > '2022/12/31' then
      Strings[numDaysQJOBefore2023Elm] := '0'
    else if Strings[11] < '2023/01/01' then
      Strings[numDaysQJOBefore2023Elm] := numDaysQJ0
    else //if (Strings[10] < '2023/01/01') and  (x > 0) then
    begin
      x := DateDiffYMD('2023/01/01', Strings[11]); //the order of dates matters
      Strings[numDaysQJOBefore2023Elm] := inttostr( strtoint(numDaysQJ0) - x);
    end;
    //showmessage(Strings[numDaysQJOBefore2023Elm]);

    //numDaysQJOAfter2022Elm
    if Strings[10] > '2022/12/31' then
      Strings[numDaysQJOAfter2022Elm]  := numDaysQJ0
    else if Strings[11] < '2023/01/01' then    //program doesnt allow date, cannot test
      Strings[numDaysQJOAfter2022Elm]  := '0'
    else //if (Strings[10] < '2023/01/01') and  (x > 0) then
    begin
      x := DateDiffYMD(Strings[10],'2022/12/31'); //the order of dates matters
      Strings[numDaysQJOAfter2022Elm] := inttostr( strtoint(numDaysQJ0) - x);
    end;
    //showmessage(Strings[numDaysQJOAfter2022Elm]);



    Strings[7]  := numDaysQJ0;
    Strings[20] := numDaysQJ0;

    //do not divide by zero or by nothing
    amountAElm :=8 ; amountBElm := 21;
    if (strings[numDaysQJOBefore2023Elm] > '') and (strings[7] > '') and (strings[7] <> '0') then
    begin
      d := strtofloat(strings[6]) / strtoint(strings[7]);
      strings[amountAElm]   := FormatFloat('#.##', d);
    end;
    if (strings[numDaysQJOAfter2022Elm] > '') and (strings[20] > '') and (strings[20] <> '0') then
    begin
      d := strtofloat(strings[9]) / strtoint(strings[20]);
      strings[amountBElm]  := FormatFloat('#.##', d);
    end;
    //if (numDaysQJ0 = '') or (numDaysQJ0 = '0') then make everything 0



    if strings[6]  = '' then
      strings[6]  := '0';
    if strings[7]  = '' then
      strings[7]  := '0';
    if strings[8]  = '' then
      strings[8]  := '0';
    if strings[9]  = '' then
      strings[9]  := '0';
    if strings[19] = '' then
      strings[20] := '0';
    if strings[20] = '' then
      strings[20] := '0';
    if strings[21] = '' then
      strings[21] := '0';

    Tv[14] := 0;
    i := 27;
    j := 252;
    Repeat
      col1:=i+1; col2:=i+2; col3:=i+3; col4:=i+4; col5:=i+5; col6:=i+6; col7:=j; col8:=j+28; col9:=j+56; col10:=i+7; col11:=i+8;

      //??
      if (Strings[col1] = '') or (Strings[col2] = '') then
        Tv[col3] := 0;

      if Strings[col1] > '' then // name entered
      begin

        if GetTaxationYearStartYYYY(RetNo) > 2022 then  //if start after 2022 zero at amount A and col5,6,7
        begin
         strings[8]  := '0'; Tv[col5] := 0; Tv[col6] := 0; Tv[col7] := 0;
        end
        else
        begin
          Tv[col5] := MaxR(0, Tv[col3] - Tv[col4]);
          Tv[col6] := 55000 * (StrToInt(Strings[19]) / 365);
          Tv[col7] := MinR(Tv[col5], Tv[col6]); //Tv[col10] := MinR(Tv[col5], Tv[col6]);
        end;

        Tv[col8] := Round( (Tv[col3] - Tv[col4]) * strtofloat(strings[21]) );
        Tv[col9] := 85000 * (StrToInt(Strings[9])/ 365);
        Tv[col10] := MinR(Tv[col8], Tv[col9]);
        Tv[col11] := Round(Tv[col7] * 0.25) + Round(Tv[col10] * 0.35);
      end
      Else
      begin Tv[col5] := 0; Tv[col6] := 0; Tv[col7] := 0; Tv[col8] := 0; Tv[col9] := 0; Tv[col10] := 0; Tv[col11] := 0; end;

      Tv[14] := Tv[14] + Tv[col11];

      Inc(i, 8);
      Inc(j, 1);
    Until i > 244;


    //jz 20241117 >>

    Tv[13] := TotMultiple(RetNo, 'S58', 13) - Tv[13]; // exclude the #1
    Tv[14] := Tv[14] + Tv[13];
    Tv[16] := Tv[14] + Tv[15];
    Tv[18] := MaxR(0, Tv[16] - Tv[17]);

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

(*
  //20200607
  procedure S58(RetNo: integer;FName: string;FNo: integer);
  Var i:integer;FInst:String;
  begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  Finst:=UpperCase(ExtractFormInst(FName));
  FillHeader(RetNo,FNo,1,2,3);
  if Strings[4]+Strings[5]='' then Strings[4]:='X';
  if Strings[6]+Strings[7]='' then Strings[7]:='X';
  if (Strings[5]>'') or (Strings[6]>'') then
  Begin
  Strings[10]:='';
  Strings[11]:='';
  Strings[12]:='';
  end
  Else
  Begin
  if Strings[10]='' then Strings[10]:=GetBegYearEnd(RetNo);
  if Strings[11]='' then Strings[11]:=GetTaxationYearEnd(RetNo);
  end;

  if Strings[19]='' then
  Begin
  Strings[19]:=IntToStr(Ret[RetNo].DaysInYear);
  End;

  Tv[14]:=0;
  i:=27;
  Repeat
  if (Strings[I+1]='') or (Strings[i+2]='') then Tv[I+3]:=0;

  Tv[i+5]:=MaxR(0,Tv[i+3]-Tv[i+4]);
  if Strings[i+1]>'' then //name entered
  Tv[i+6]:=55000 * (StrToInt(Strings[19])/365)
  Else
  Tv[i+6]:=0;
  Tv[i+7]:=MinR(Tv[i+5],Tv[i+6]);
  Tv[i+8]:=Round(Tv[i+7]*0.25);
  Tv[14]:=Tv[14]+Tv[i+8];
  Inc(i,8);
  Until i>244;

  Tv[13]:=TotMultiple(RetNo,'S58',13)-Tv[13]; //exclude the #1
  Tv[14]:=Tv[14]+Tv[13];
  Tv[16]:=Tv[14]+Tv[15];
  Tv[18]:=MaxR(0,Tv[16]-Tv[17]);

  end; {End with}
  SaveTv(RetNo,FName,FNo);
  end;
*)

procedure S7RENT(RetNo: integer; FName: string; FNo: integer);
Var
  i, k: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    If Strings[75] = '' then
      Strings[75] := 'N';
    If Strings[76] = '' then
      Strings[76] := 'N';
    If Strings[77] = '' then
      Strings[77] := 'N';
    k := 0;
    Repeat
      Tv[9 + k] := Tv[7 + k] + Tv[8 + k];
      Tv[25 + k] := 0;
      For i := 10 to 24 do
        Tv[25 + k] := Tv[25 + k] + Tv[i + k];
      Inc(k, 22);
    until k > 49;
    Tv[26] := Tv[9] - Tv[25];
    Tv[48] := Tv[31] - Tv[47];
    Tv[70] := Tv[53] - Tv[69];
    Tv[71] := 0;
    Tv[72] := 0;
    If UpperCase(Strings[75]) <> 'Y' then
      Tv[71] := Tv[71] + Tv[26]
    else
      Tv[72] := Tv[72] + Tv[26];

    If UpperCase(Strings[76]) <> 'Y' then
      Tv[71] := Tv[71] + Tv[48]
    else
      Tv[72] := Tv[72] + Tv[48];

    If UpperCase(Strings[77]) <> 'Y' then
      Tv[71] := Tv[71] + Tv[70]
    else
      Tv[72] := Tv[72] + Tv[70];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1163(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  x: Real; // FInst : String[4];
  FInst: String; // [4]; //20150701
Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    If Strings[21] = '' then
      Strings[21] := LeftStr(GetTaxationYearEnd(RetNo), 4);
    // '2008'; //20100530
    CaisYrT1163 := Strings[21];
    Strings[41] := CaisYrT1163 + ' Statement A';
    Strings[22] := RightStr(FInst, 1);
    Strings[7] := IntToStr(CountT1163(RetNo));
    If FInst > '#1' then
      Exit;
    Strings[37] := GetCorpName(RetNo);
    Strings[34] := GetCorpBusNo(RetNo);

    if Strings[5] = '' then
      Strings[5] := FetchElm(RetNo, 'T2', 26) + ' ' + FetchElm(RetNo, 'T2', 27);
    If Strings[8] = '' then
      Strings[8] := FetchElm(RetNo, 'T2', 32);
    If Strings[9] = '' then
      Strings[9] := FetchElm(RetNo, 'T2', 33);
    If Strings[10] = '' then
      Strings[10] := FetchElm(RetNo, 'T2', 35);

    If Strings[1] = '' then
      Strings[1] := FetchElm(RetNo, 'T2', 755);
    If Strings[2] = '' then
      Strings[2] := FetchElm(RetNo, 'T2', 746);
    If Strings[35] + Strings[36] = '' then
      Strings[35] := 'X';
  end;
  // T1163 pg2 -----------------------------------------------------------------
  x := 0;
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin

    If MidStr(FInst, 2, 2) = '1' then // ???
      Strings[253] := CaisYrT1163 + ' Statement A'
    else
      Strings[253] := CaisYrT1163 + ' Statement B';

    Strings[154] := MidStr(FInst, 2, 2); // ???
    Strings[107] := IntToStr(CountT1163(RetNo));
    Strings[113] := GetBegYearEnd(RetNo);
    Strings[114] := GetTaxationYearEnd(RetNo);

    i := 120;
    Repeat
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      Inc(i, 3);
    until i > 204;

    Tv[209] := Tv[255] + Tv[256];
    Tv[205] := AddColumns(120, 204, 3);
    x := AddColumns(221, 248, 3);
    Tv[218] := x;
    Tv[249] := AddColumns(206, 218, 1);
    Tv[250] := Tv[205];
    Tv[251] := Tv[249];
    Tv[252] := Tv[250] + Tv[251];
  end;
  // T1163 pg3 -----------------------------------------------------------------

  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then // ???
      Strings[495] := CaisYrT1163 + ' Statement A'
    else
      Strings[495] := CaisYrT1163 + ' Statement B';

    Strings[491] := MidStr(FInst, 2, 2); // ???
    Strings[371] := IntToStr(CountT1163(RetNo));

    i := 303;
    Repeat
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      Inc(i, 3);
    until i > 357;

    Tv[358] := AddColumns(303, 357, 3);
    Tv[412] := AddColumns(359, 370, 1) + Tv[492] + AddColumns(375, 411, 3);
    Tv[486] := AddColumns(442, 484, 3);
    Tv[485] := AddColumns(413, 439, 1) + Tv[486];
    Tv[487] := Tv[358];
    Tv[488] := Tv[412];
    Tv[489] := Tv[485]; // Tv[385]; 20130629
    Tv[490] := Tv[487] + Tv[488] + Tv[489];
  end;
  // T1163 pg4 -----------------------------------------------------------------

  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin

    If MidStr(FInst, 2, 2) = '1' then // ???
      Strings[517] := CaisYrT1163 + ' Statement A'
    else
      Strings[517] := CaisYrT1163 + ' Statement B';

    Strings[504] := MidStr(FInst, 2, 2); // ???

    Strings[507] := IntToStr(CountT1163(RetNo));
    Tv[501] := Tv[252]; // Vl(FetchElm(RetNo,'T1163'+FInst,252)); //20140904
    Tv[502] := Tv[490]; // Vl(FetchElm(RetNo,'T1163'+FInst,490)); //20140904
    Tv[503] := Tv[501] - Tv[502];
    Tv[505] := Tv[503];
    Tv[513] := Tv[505] + Tv[508] + Tv[510];
    Tv[516] := Tv[513];
    Tv[513] := Tv[515] - Tv[518];
  end;
  SaveTv(RetNo, FName, FNo);

end;

(*
  Procedure T1163(RetNo:integer;FName:string;FNo:integer);
  var i,k: integer; x:real; FInst : String[4];
  Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  With Ret[RetNo].Frm[Fno] do
  begin
  If Strings[21]='' then Strings[21]:=LeftStr(GetTaxationYearEnd(RetNo),4); //'2008'; //20100530
  CaisYrT1163:=Strings[21];
  Strings[41]:=CaisYrT1163+' Statement A';
  Strings[22]:=RightStr(FInst,1);
  Strings[7]:=IntToStr(CountT1163(RetNo));
  If FInst > '#1' then exit;
  Strings[37]:=GetCorpName(RetNo);
  Strings[34]:=GetCorpBusNo(RetNo);

  if Strings[5]='' then Strings[5]:=FetchElm(RetNo,'T2',26)+' '+FetchElm(RetNo,'T2',27);
  If Strings[8]='' then Strings[8]:=FetchElm(RetNo,'T2',32);
  If Strings[9]='' then Strings[9]:=FetchElm(RetNo,'T2',33);
  If Strings[10]='' then Strings[10]:=FetchElm(RetNo,'T2',35);

  If Strings[1] ='' then Strings[1]:=FetchElm(RetNo,'T2',755);
  If Strings[2] ='' then Strings[2]:=FetchElm(RetNo,'T2',746);
  If Strings[35]+Strings[36]='' then Strings[35]:='X';
  end;
  //T1163 pg2 -----------------------------------------------------------------
  x:=0;
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[Fno] do
  begin

  If MidStr(Finst,2,2) ='1' then //???
  Strings[253] := CaisYrT1163+' Statement A'
  else
  Strings[253] := CaisYrT1163+' Statement B';

  Strings[154]:=MidStr(Finst,2,2); //???
  Strings[107]:=IntToStr(CountT1163(RetNo));
  Strings[113] := GetBegYearEnd(RetNo);
  Strings[114] := GetTaxationYearEnd(RetNo);

  i:=120;
  Repeat
  If Strings[i-1]='' then Tv[i]:=0;
  Inc(i,3);
  until i>204;

  Tv[209]:=Tv[255]+Tv[256];
  Tv[205]:=AddColumns(120,204,3);
  x:=AddColumns(221,248,3);
  Tv[218]:=x;
  Tv[249]:=AddColumns(206,218,1);
  Tv[250]:=Tv[205];
  Tv[251]:=Tv[249];
  Tv[252]:=Tv[250]+Tv[251];
  end;
  //T1163 pg3 -----------------------------------------------------------------

  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[Fno] do
  begin
  If MidStr(Finst,2,2) ='1' then //???
  Strings[495] := CaisYrT1163+' Statement A'
  else
  Strings[495] := CaisYrT1163+' Statement B';

  Strings[491]:=MidStr(Finst,2,2); //???
  Strings[371]:=IntToStr(CountT1163(RetNo));

  i:=303;
  Repeat
  If Strings[i-1]='' then Tv[i]:=0;
  Inc(i,3);
  until i>357;

  Tv[358]:=AddColumns(303,357,3);
  Tv[412]:=AddColumns(359,370,1)+Tv[492]+AddColumns(375,411,3);
  Tv[486]:=AddColumns(442,484,3);
  Tv[485]:=AddColumns(413,439,1)+Tv[486];
  Tv[487]:=Tv[358];
  Tv[488]:=Tv[412];
  Tv[489]:=Tv[485]; //Tv[385]; 20130629
  Tv[490]:=Tv[487]+Tv[488]+Tv[489];
  end;
  //T1163 pg4 -----------------------------------------------------------------

  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[Fno] do
  begin

  If MidStr(Finst,2,2) ='1' then //???
  Strings[517] := CaisYrT1163+' Statement A'
  else
  Strings[517] := CaisYrT1163+' Statement B';

  Strings[504]:=MidStr(FInst,2,2); //???

  Strings[507]:=IntToStr(CountT1163(RetNo));
  Tv[501] := Vl(FetchElm(RetNo,'T1163'+FInst,252));
  Tv[502] := Vl(FetchElm(RetNo,'T1163'+FInst,490));
  Tv[503] := Tv[501] - Tv[502];
  Tv[505] := Tv[503];
  Tv[513] := Tv[505]+Tv[508]+Tv[510];
  Tv[516] := Tv[513];
  Tv[513] := Tv[515]-Tv[518];
  end;
  SaveTv(RetNo,FName,FNo);

  end;
*)

procedure S1AUTO(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 4, 5, 6);
    CalcS1Auto(RetNo, FName, FNo, 'O'); { other }
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure CalcS1Auto(RetNo: integer; FName: string; FNo: integer; Stm: string);
Var
  i: integer;
  FInst: String[4];
  k, Gst, Pst: Real;
  Line5K, Line6K, Line7K: Real;
  Yr: String[4];
Begin
  Line5K := 0;
  Line6K := 0;
  Line7K := 0;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    { Interest }
    For i := 0 to 2 do
    begin
      If Strings[20 + i] = '' then
        Strings[20 + i] := '10.00';
      Tv[32 + i] := Round(Vl(Strings[16 + i]) * Vl(Strings[20 + i]));
      Tv[35 + i] := MinR(Tv[13 + i], Tv[32 + i]);
      Tv[7 + i] := MaxR(0, Tv[13 + i] - Tv[35 + i]);
    end;
    Tv[19] := Tv[7] + Tv[8] + Tv[9];

    { Lease }
    For i := 0 to 0  do //2 do  //20251020
    begin
      Yr := LeftStr(Strings[57 + i], 4);
      Line5K := GetLine5K(Yr);
      If Tv[126 + i] = 0 then
        Tv[126 + i] := 7;
      If Yr = '' then
        Tv[126 + i] := 0;
      Gst := Roundcorrect(Line5K * Tv[126 + i] / 100);
      Pst := Roundcorrect(Line5K * Vl(Strings[63 + i]) / 100);
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;

      k := Line5K + Gst + Pst;
      Tv[25]:=k; Tv[26]:=Tv[25];
      Tv[78 + i] := Roundcorrect(MaxR(k, Tv[75 + i]) * 0.85);
      //-----------------
      Line6K := GetLine6K(Yr);
      Gst := Roundcorrect(Line6K * Tv[126 + i] / 100);
      Pst := Roundcorrect(Line6K * Vl(Strings[63 + i]) / 100);
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line6K + Gst + Pst;
      Tv[27]:=k; //Line6k; //+GST+Pst; Tv[28]:=Tv[27];
      Tv[81 + i] := Roundcorrect(MaxR(0, ((k * Tv[72 + i]) / 30) - Tv[69 + i]));
      //----------
      Line7K := GetLine7K(Yr);
      Tv[29]:=Line7k; Tv[30]:=Tv[29];
      Gst := Roundcorrect(Line7K * Tv[126 + i] / 100);
      Pst := Roundcorrect(Line7K * Vl(Strings[63 + i]) / 100);
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line7K + Gst + Pst;
      If Tv[78 + i] > 0 then
        Tv[84 + i] := Roundcorrect(k * Tv[66 + i] / Tv[78 + i])
      else
        Tv[84 + i] := 0;
      Tv[99 + i] := MinR(Tv[81 + i], Tv[84 + i]);
      Tv[10 + i] := MaxR(0, Tv[66 + i] - Tv[99 + i]);  //20251021
    end;
    Tv[23] := Tv[10] + Tv[11] + Tv[12];
    Tv[24] := Tv[19] + Tv[23];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
End;

//20251020
Function GetLine5K(Yr: String): Real;
begin
  result := -1; // 20150701
  If Yr >= '2001' then
    result := 35294; { 2000 and till now }
  If Yr = '2000' then
    result := 31765; { 2000 and till now }
  If (Yr > '1997') and (Yr < '2000') then
    result := 30588;
  If Yr = '1997' then
    result := 29412;
  If (Yr > '1990') and (Yr < '1997') then
    result := 28235;
  If Yr < '1990' then
    result := 23529;

  if Yr='2024' then result:=43529;
  if Yr='2023' then result:=35294;

  If Yr = '' then
    result := 0;
end;

//20251020
Function GetLine6K(Yr: String): Real;
begin
  result := -1; // 20150701
  If Yr >= '2001' then
    result := 800;
  If Yr = '2000' then
    result := 700;
  If (Yr > '1997') and (Yr < '2000') then
    result := 650;
  If Yr = '1997' then
    result := 550;
  If (Yr > '1990') and (Yr < '1997') then
    result := 650;
  If Yr < '1990' then
    result := 600;
  If Yr = '' then
    result := 0;
  //20251021
  if Yr='2025' then result:=1100;
  if Yr='2024' then result:=1050;
  if Yr='2023' then result:=950;
  if Yr='2022' then result:=800;
end;

//20251020
Function GetLine7K(Yr: String): Real;
begin
  result := -1; // 20150701
  If Yr >= '2001' then
    result := 30000;
  If Yr = '2000' then
    result := 27000;
  If (Yr > '1997') and (Yr < '2000') then
    result := 26000;
  If Yr = '1997' then
    result := 25000;
  If (Yr > '1990') and (Yr < '1997') then
    result := 24000;
  If Yr < '1990' then
    result := 20000;
  If Yr = '' then result := 0;

  if Yr='2025' then result:=38000;
  if Yr='2024' then result:=37000;
  if Yr='2023' then result:=36000;
  if Yr='2022' then result:=34000;
end;



(* //20251110  Replaced bt the logic in T202025 fron T202025
Procedure CalcS1Auto(RetNo: integer; FName: string; FNo: integer; Stm: string);
Var
  i: integer;
  FInst: String[4];
  k, Gst, Pst: Real;
  Line5K, Line6K, Line7K: Real;
  Yr: String[4];
Begin
  Line5K := 0;
  Line6K := 0;
  Line7K := 0;
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    { Interest }
    For i := 0 to 2 do
    begin
      If Strings[20 + i] = '' then
        Strings[20 + i] := '10.00';
      Tv[32 + i] := Round(Vl(Strings[16 + i]) * Vl(Strings[20 + i]));
      Tv[35 + i] := MinR(Tv[13 + i], Tv[32 + i]);
      Tv[7 + i] := MaxR(0, Tv[13 + i] - Tv[35 + i]);
    end;
    Tv[19] := Tv[7] + Tv[8] + Tv[9];

    { Lease }
    For i := 0 to 2 do
    begin
      Yr := LeftStr(Strings[57 + i], 4);
      Line5K := GetLine5K(Yr);
      If Tv[126 + i] = 0 then
        Tv[126 + i] := 7;
      If Yr = '' then
        Tv[126 + i] := 0;
      Gst := Round(Line5K * Tv[126 + i] / 100);
      Pst := Round(Line5K * Vl(Strings[63 + i]) / 100);
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;

      k := Line5K + Gst + Pst;
      Tv[78 + i] := Round(MaxR(k, Tv[75 + i]) * 0.85);

      Line6K := GetLine6K(Yr);
      Gst := Round(Line6K * Tv[126 + i] / 100);
      Pst := Round(Line6K * Vl(Strings[63 + i]) / 100);
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line6K + Gst + Pst;
      Tv[81 + i] := Round(MaxR(0, ((k * Tv[72 + i]) / 30) - Tv[69 + i]));

      Line7K := GetLine7K(Yr);
      Gst := Round(Line7K * Tv[126 + i] / 100);
      Pst := Round(Line7K * Vl(Strings[63 + i]) / 100);
      If Yr < '1991' then
      begin
        Gst := 0;
        Pst := 0;
      end;
      k := Line7K + Gst + Pst;
      If Tv[78 + i] > 0 then
        Tv[84 + i] := Round(k * Tv[66 + i] / Tv[78 + i])
      else
        Tv[84 + i] := 0;
      Tv[99 + i] := MinR(Tv[81 + i], Tv[84 + i]);
      Tv[10 + i] := MaxR(0, Tv[66 + i] - Tv[99 + i]);
    end;
    Tv[23] := Tv[10] + Tv[11] + Tv[12];
    Tv[24] := Tv[19] + Tv[23];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
End;

Function GetLine5K(Yr: String): Real;
begin
  result := -1; // 20150701
  If Yr >= '2001' then
    result := 35294; { 2000 and till now }
  If Yr = '2000' then
    result := 31765; { 2000 and till now }
  If (Yr > '1997') and (Yr < '2000') then
    result := 30588;
  If Yr = '1997' then
    result := 29412;
  If (Yr > '1990') and (Yr < '1997') then
    result := 28235;
  If Yr < '1990' then
    result := 23529;
  If Yr = '' then
    result := 0;
end;

Function GetLine6K(Yr: String): Real;
begin
  result := -1; // 20150701
  If Yr >= '2001' then
    result := 800;
  If Yr = '2000' then
    result := 700;
  If (Yr > '1997') and (Yr < '2000') then
    result := 650;
  If Yr = '1997' then
    result := 550;
  If (Yr > '1990') and (Yr < '1997') then
    result := 650;
  If Yr < '1990' then
    result := 600;
  If Yr = '' then
    result := 0;
end;

Function GetLine7K(Yr: String): Real;
begin
  result := -1; // 20150701
  If Yr >= '2001' then
    result := 30000;
  If Yr = '2000' then
    result := 27000;
  If (Yr > '1997') and (Yr < '2000') then
    result := 26000;
  If Yr = '1997' then
    result := 25000;
  If (Yr > '1990') and (Yr < '1997') then
    result := 24000;
  If Yr < '1990' then
    result := 20000;
  If Yr = '' then
    result := 0;
end;
*)
procedure S8FREE(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer; // FInst :String[4];
  FInst: String; // [4]; //20150701
begin
  Exit; // 20190606
  (*
    FInst := ExtractFormInst(FName);
    LoadTv(RetNo,FName,FNo);
    with Ret[RetNo].Frm[Fno] do
    begin
    FillHeader(RetNo,FNo,1,2,3);
    If Strings[4]+Strings[5] = '' then Strings[5] := 'X';
    {CCA}
    For i:=230 to 232 do Tv[i] :=0;
    I := 6;
    Repeat
    //20160905
    if Uppercase(Strings[i+8])='O' then Strings[i+8]:='Y';
    if Uppercase(Strings[i+9])='H' then Strings[i+9]:='Y';
    if Uppercase(Strings[i+10])='T' then Strings[i+10]:='Y';

    If Uppercase(Strings[i+8]) <> 'Y' then Strings[i+11] := GetCCARate(Strings[i]); //20190605
    If (Strings[i] > '') and (Strings[i+9] ='') then {half year indic}
    Strings[i+9] := 'Y';  {half year}   //20190605
    If UpperCase(Strings[i+8]) = 'Y' then {override}   //20190605
    begin
    If Tv[i+2]=0 then
    Tv[i+15] := MaxR(0,Tv[i+7]-Tv[i+14])
    else
    Tv[i+15] := MaxR(0,Tv[i+5]-Tv[i+14]);
    end
    {no action}
    else
    begin
    CalcCCA(Strings[i],Tv[i+1],Tv[i+2],Tv[i+3],Tv[i+4],
    Tv[i+5],Tv[i+6],Tv[i+7],
    Strings[i+8],Strings[i+9],Strings[i+10],
    Strings[i+11],
    Tv[i+12],Tv[i+13],Tv[i+14],Tv[i+15],
    Ret[RetNo].DaysInYear);
    end;
    If (AllTrim(Strings[i]) = '29') and (Vl(Strings[i+11])=0) then
    Strings[i+11] :='N/A';
    Tv[230] := Tv[230] + Tv[I+12];
    Tv[231] := Tv[231] + Tv[I+13];
    Tv[232] := Tv[232] + Tv[I+14];
    I := i+16;
    until i > 198;
    {bring from S8LH}
    If Finst = '#1' then
    begin
    Tv[215] := Vl(FetchElm(RetNo,'S8LH',142)); {ucc}
    Tv[217] := Vl(FetchElm(RetNo,'S8LH',143)); {adj}
    Tv[218] := Vl(FetchElm(RetNo,'S8LH',144)); {Disp}
    Tv[221] := Vl(FetchElm(RetNo,'S8LH',145)); {reduced UCC}
    Tv[228] := Vl(FetchElm(RetNo,'S8LH',147)); {CCA}
    Tv[229] := Vl(FetchElm(RetNo,'S8LH',148)); {ending ucc}
    If Tv[228] >0 then Strings[214] := '13';
    end;
    {total CCA}
    Tv[232] := Tv[232] + Tv[228];
    Tv[234] := AddColumns(8,200,16)+Tv[216];
    Tv[235] := AddColumns(10,202,16)+Tv[218];
    end; {End with}
    SaveTv(RetNo,FName,FNo);
  *)
end;

procedure S8LFREE(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    CalcCommonS8LH(RetNo, FName, FNo);
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure CDA(RetNo: integer; FName: string; FNo: integer);
Var
  i, k: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Tv[5] := GetNonTaxableGainsLosses(RetNo);
    Tv[6] := Tv[4] + Tv[5];
    Tv[8] := Vl(FetchElm(RetNo, 'S1', 40));
    Tv[9] := Tv[7] + Tv[8];
    Tv[10] := MaxR(0, Tv[4] - Tv[7]);
    Tv[12] := MaxR(0, Tv[6] - Tv[9]);
    If (Tv[10] = 0) and (Tv[12] = 0) then
      Tv[11] := 0;

    Tv[14] := Vl(FetchElm(RetNo, 'S1', 36));
    Tv[15] := Tv[13] + Tv[14];
    // ECP
    Tv[64] := Tv[63];
    Tv[59] := Vl(FetchElm(RetNo, 'S10', 38));
    Tv[60] := Tv[59];
    Tv[62] := Tv[61];
    Tv[28] := Tv[63];
    Tv[29] := MaxR(0, Tv[59] - Tv[61]);
    Tv[30] := Tv[28] + Tv[29];
    // life ins
    Tv[33] := Tv[31] + Tv[32];
    Tv[36] := Tv[34] + Tv[35];
    Tv[37] := MaxR(0, Tv[31] - Tv[34]);
    Tv[38] := MaxR(0, Tv[32] - Tv[35]);
    Tv[39] := Tv[37] + Tv[38];
    // Distr list
    Tv[51] := Tv[49] + Tv[50];
    Tv[54] := Tv[52] + Tv[53];
    Tv[57] := Tv[55] + Tv[56];
    Tv[40] := Tv[10] + Tv[13] + Tv[28] + Tv[37] + Tv[49] + Tv[52] + Tv[55];
    // Tv[41]:=Tv[11]+Tv[14]+Tv[29]+Tv[38]+Tv[50]+Tv[53]+Tv[56];
    Tv[42] := Tv[12] + Tv[15] + Tv[30] + Tv[39] + Tv[51] + Tv[54] + Tv[57];
    // Tv[42]:=Tv[40]+Tv[41];
    Tv[44] := ABS(Vl(FetchElm(RetNo, 'S3', 254))); //20230921   //positvive only 20230921
    //Tv[44] := Vl(FetchElm(RetNo, 'S3', 254));
    Tv[45] := Tv[43] + Tv[44];
    Tv[46] := MaxR(0, Tv[40] - Tv[43]);
    // Tv[47]:=MaxR(0,Tv[41]-Tv[44]);
    Tv[48] := MaxR(0, Tv[42] - Tv[45]);

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure T400A(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    If Strings[1] = '' then
      Strings[1] := FetchElm(RetNo, 'T2', 743) + ' ' +
        FetchElm(RetNo, 'T2', 742);

    If Strings[48] = '' then
      Strings[48] := FetchElm(RetNo, 'T2', 755);
    If Strings[49] = '' then
      Strings[49] := FetchElm(RetNo, 'T2', 746);
    Strings[15] := GetTaxationYearEnd(RetNo);
    Strings[16] := GetCorpBusNo(RetNo);
    If FillSignatureDates = True then
      Strings[50] := FormatDateTime('yyyy/mm/dd', Date);

  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure S51(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

  end; { End with }
  // S51 pg2 --------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 101, 102, 103);

    Tv[118] := AddColumns(104, 116, 2);
    Tv[119] := AddColumns(105, 117, 2);
    Tv[122] := Tv[118] + Tv[120];
    Tv[123] := Tv[119] + Tv[121];
    // expenses
    Tv[142] := Tv[122] - AddColumns(124, 140, 2);
    Tv[143] := Tv[123] - AddColumns(125, 141, 2);
    Tv[144] := TotMultiple(RetNo, 'S51P', 50); // ???
    Tv[145] := TotMultiple(RetNo, 'S51P', 51); // ???
    Tv[146] := Tv[142] + Tv[144];
    Tv[147] := Tv[143] + Tv[145];
    Tv[154] := Tv[146] - Tv[148] - Tv[150] - Tv[152];
    Tv[155] := Tv[147] - Tv[149] - Tv[151] - Tv[153];
    Tv[156] := Tv[154] + Tv[155];
    Tv[160] := Tv[154] - Tv[157];
    Tv[161] := Tv[155];
    Tv[162] := Tv[156] + Tv[159];

    If Tv[162] < 0 then
      Tv[163] := Round(ABS(Tv[162]) * 0.25)
    else
      Tv[163] := 0;

    Tv[164] := Round(MaxR(0, Tv[160] * 0.25));
    Tv[165] := Round(Tv[161] * 0.25);
    If (Tv[162] < 0) and (Tv[161] > 0) then
      Tv[165] := Round(Tv[161] * 0.25);
    If (Tv[162] < 0) and (Tv[161] < 0) then
      Tv[169] := 0;
    If Vl(FetchElm(RetNo, 'S12', 22)) < 0 then
      Tv[166] := ABS(Vl(FetchElm(RetNo, 'S12', 22)))
    else
      Tv[166] := 0;
    If Vl(FetchElm(RetNo, 'S12', 23)) < 0 then
      Tv[167] := ABS(Vl(FetchElm(RetNo, 'S12', 23)))
    else
      Tv[167] := 0;

    Tv[168] := Tv[164] - Tv[166];
    Tv[169] := Tv[165] - Tv[167];
    Tv[170] := Tv[168] + Tv[169];
    If Tv[163] > 0 then
      For i := 164 to 170 do
        Tv[i] := 0;

  end; { End with }
  // S51 pg3 --------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 201, 202, 203);

    Tv[204] := Vl(FetchElm(RetNo, 'S51', 154));
    Tv[205] := Vl(FetchElm(RetNo, 'S51', 155));
    Tv[206] := 0;
    If Vl(FetchElm(RetNo, 'S12', 120)) < 0 then
      Tv[206] := Tv[206] + ABS(Vl(FetchElm(RetNo, 'S12', 120)));
    If Vl(FetchElm(RetNo, 'S12', 221)) < 0 then
      Tv[206] := Tv[206] + ABS(Vl(FetchElm(RetNo, 'S12', 221)));
    Tv[210] := Vl(FetchElm(RetNo, 'S51', 150));
    Tv[211] := Vl(FetchElm(RetNo, 'S51', 151));
    Tv[212] := Vl(FetchElm(RetNo, 'S51', 152));
    Tv[213] := Vl(FetchElm(RetNo, 'S51', 153));
    Tv[220] := AddColumns(204, 214, 2) - Tv[216] + Tv[218];
    Tv[221] := Tv[205] + Tv[207] + AddColumns(211, 215, 2) - Tv[217] + Tv[219];
    Tv[222] := Vl(FetchElm(RetNo, 'S51', 327));
    Tv[223] := Vl(FetchElm(RetNo, 'S51', 349));
    Tv[232] := Tv[220] - AddColumns(222, 230, 2);
    Tv[233] := Tv[221] - AddColumns(223, 231, 2);
    Tv[234] := Vl(FetchElm(RetNo, 'S12', 121)); // cee expl
    Tv[236] := Vl(FetchElm(RetNo, 'S12', 223)) + Vl(FetchElm(RetNo, 'S12', 224)
      ); // cde dev
    Tv[238] := Vl(FetchElm(RetNo, 'S12', 319)); // cogpe
    Tv[242] := Tv[232] - AddColumns(234, 240, 2);
    Tv[243] := Tv[233] - AddColumns(235, 241, 2);
    Tv[244] := Tv[242] + Tv[243];
    Tv[245] := Tv[223];
    Tv[247] := Tv[244] + Tv[245] - Tv[246];
    If Tv[243] > 0 then
      Tv[248] := Round(Tv[243] * 0.25);
    Tv[249] := MinR(Tv[248], Vl(FetchElm(RetNo, 'S12', 23)));
    Tv[250] := Round(4 * Tv[249]);
    Tv[251] := Tv[247] - Tv[250];
    If Tv[251] > 0 then
      Tv[252] := Round(Tv[251] * 0.25)
    else
      Tv[252] := 0;
    Tv[253] := MinR(Tv[252], Vl(FetchElm(RetNo, 'S12', 22)));

  end; { End with }
  // S51 pg4 --------------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 301, 302, 303);
    Tv[304] := Vl(FetchElm(RetNo, 'S51', 168));
    If (Tv[304] = 0) and (Vl(FetchElm(RetNo, 'S51', 160)) < 0) then
      Tv[304] := Round(Vl(FetchElm(RetNo, 'S51', 160)) * 0.25);

    Tv[305] := Vl(FetchElm(RetNo, 'S51', 169));
    If (Tv[305] = 0) and (Vl(FetchElm(RetNo, 'S51', 161)) < 0) then
      Tv[305] := Round(Vl(FetchElm(RetNo, 'S51', 161)) * 0.25);

    Tv[307] := Tv[304];
    Strings[308] := IntToStr(GetNumDays(RetNo, '01-01-2003', 'B'));
    Strings[309] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[310] := Round(Tv[7] * (Vl(Strings[308]) / Vl(Strings[309])) * 1.00);

    Tv[311] := Tv[304];
    Strings[312] := IntToStr(GetNumDays(RetNo, '31-12-2002', 'A') -
      GetNumDays(RetNo, '31-12-2003', 'A'));
    Strings[313] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[314] := Round(Tv[311] * (Vl(Strings[312]) / Vl(Strings[313])) * 0.90);

    Tv[315] := Tv[304];
    Strings[316] := IntToStr(GetNumDays(RetNo, '31-12-2003', 'A') -
      GetNumDays(RetNo, '31-12-2004', 'A'));
    Strings[317] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[318] := Round(Tv[315] * (Vl(Strings[316]) / Vl(Strings[317])) * 0.75);

    Tv[319] := Tv[304];
    Strings[320] := IntToStr(GetNumDays(RetNo, '31-12-2004', 'A') -
      GetNumDays(RetNo, '31-12-2005', 'A'));
    Strings[321] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[322] := Round(Tv[319] * (Vl(Strings[320]) / Vl(Strings[321])) * 0.65);

    Tv[323] := Tv[304];
    Strings[324] := IntToStr(GetNumDays(RetNo, '31-12-2005', 'A') -
      GetNumDays(RetNo, '31-12-2006', 'A'));
    Strings[325] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[326] := Round(Tv[323] * (Vl(Strings[324]) / Vl(Strings[325])) * 0.35);

    Tv[327] := AddColumns(310, 326, 4);

    i := 329;
    Repeat
      Tv[i] := Tv[305];
      Strings[i + 2] := IntToStr(Ret[RetNo].DaysInYear);
      Inc(i, 4);
    until i > 345;
    Strings[330] := Strings[308];
    Strings[334] := Strings[312];
    Strings[338] := Strings[316];
    Strings[342] := Strings[320];
    Strings[346] := Strings[324];
    Tv[332] := Round(Tv[329] * (Vl(Strings[330]) / Vl(Strings[331])) * 1.00);
    Tv[336] := Round(Tv[333] * (Vl(Strings[334]) / Vl(Strings[335])) * 0.90);
    Tv[340] := Round(Tv[337] * (Vl(Strings[338]) / Vl(Strings[339])) * 0.75);
    Tv[344] := Round(Tv[341] * (Vl(Strings[342]) / Vl(Strings[343])) * 0.65);
    Tv[348] := Round(Tv[345] * (Vl(Strings[346]) / Vl(Strings[347])) * 0.35);

    Tv[349] := AddColumns(332, 348, 4);
    Tv[306] := Tv[327] + Tv[349];
    // txbl res
    Tv[328] := Tv[304];
    Tv[350] := Round(Tv[304] * 3);

    Tv[352] := { Vl(FetchElm(RetNo,'S12',12))
      +Vl(FetchElm(RetNo,'S12',20)) }
      +Vl(FetchElm(RetNo, 'S12', 121)) + Vl(FetchElm(RetNo, 'S12', 223)) +
      Vl(FetchElm(RetNo, 'S12', 319));

    Tv[359] := { Vl(FetchElm(RetNo,'S12',11)) }
      +Vl(FetchElm(RetNo, 'S12', 122)) + Vl(FetchElm(RetNo, 'S12', 224)) +
      Vl(FetchElm(RetNo, 'S12', 320));

    Tv[355] := MaxR(0, Tv[350] + Tv[351] - Tv[352] + Tv[354]);

    Tv[356] := Tv[305];
    Tv[357] := Round(Tv[356] * 3);
    Tv[362] := MaxR(0, Tv[357] + Tv[358] - Tv[359] + Tv[361]);
    Tv[364] := Tv[355] + Tv[362];
    Tv[365] := Ret[RetNo].Ln[360]; // - (100/16) * (Ret[RetNo].Ln[430]);
    Tv[363] := MaxR(0, Tv[364] - Tv[365]); // Tv[55]+Tv[62];
  end; { End with }
  SaveTv(RetNo, FName, FNo);

end;

procedure S51CRN(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);

    Tv[4] := Vl(FetchElm(RetNo, 'AS7', 3)) + Vl(FetchElm(RetNo, 'AS7', 4)) +
      Vl(FetchElm(RetNo, 'AS7', 19)) + Vl(FetchElm(RetNo, 'AS7', 20));
    Tv[6] := Vl(FetchElm(RetNo, 'S400', 15));
    Tv[8] := AddColumns(4, 7, 1);
    Tv[13] := AddColumns(9, 12, 1);
    Tv[18] := AddColumns(14, 17, 1);
    Tv[23] := AddColumns(19, 22, 1);
    Tv[24] := Vl(FetchElm(RetNo, 'S420', 7));
    Tv[98] := Tv[24];
    Tv[25] := Vl(FetchGifiElm(RetNo, 'S125#1', '8441'));
    // Vl(FetchGifiElm(RetNo,'GIFIIS#1','8441')); //20150826
    Tv[99] := Tv[25];
    Tv[31] := AddColumns(27, 30, 1);
    Tv[37] := AddColumns(33, 36, 1);
    Tv[43] := AddColumns(39, 42, 1);

    Tv[44] := AddColumns(8, 23, 5) + Tv[98] + Tv[99] + AddColumns(31, 43, 5);

    // adjusted
    Tv[58] := Tv[44];
    Strings[59] := IntToStr(GetNumDays(RetNo, '01-01-2003', 'B'));
    Strings[60] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[61] := Round(Tv[58] * (Vl(Strings[59]) / Vl(Strings[60])) * 1.00);

    Tv[62] := Tv[44];
    Strings[63] := IntToStr(GetNumDays(RetNo, '31-12-2002', 'A') -
      GetNumDays(RetNo, '31-12-2003', 'A'));
    Strings[64] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[65] := Round(Tv[62] * (Vl(Strings[63]) / Vl(Strings[64])) * 0.90);

    Tv[66] := Tv[44];
    Strings[67] := IntToStr(GetNumDays(RetNo, '31-12-2003', 'A') -
      GetNumDays(RetNo, '31-12-2004', 'A'));
    Strings[68] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[69] := Round(Tv[66] * (Vl(Strings[67]) / Vl(Strings[68])) * 0.75);

    Tv[70] := Tv[44];
    Strings[71] := IntToStr(GetNumDays(RetNo, '31-12-2004', 'A') -
      GetNumDays(RetNo, '31-12-2005', 'A'));
    Strings[72] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[73] := Round(Tv[70] * (Vl(Strings[71]) / Vl(Strings[72])) * 0.65);

    Tv[122] := Tv[44];
    Strings[123] := IntToStr(GetNumDays(RetNo, '31-12-2005', 'A') -
      GetNumDays(RetNo, '31-12-2006', 'A'));
    Strings[124] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[125] := Round(Tv[122] * (Vl(Strings[123]) / Vl(Strings[124])) * 0.35);

    Tv[95] := AddColumns(61, 73, 4) + Tv[125];

    // --
    Tv[45] := Tv[95];

    Tv[47] := Vl(FetchElm(RetNo, 'AS6', 12));
    Tv[48] := Tv[46] + Tv[47];
    // adjusted ARTC
    Tv[74] := Tv[48];
    Strings[75] := IntToStr(GetNumDays(RetNo, '31-12-2002', 'A') -
      GetNumDays(RetNo, '31-12-2003', 'A'));
    Strings[76] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[77] := Round(Tv[74] * (Vl(Strings[75]) / Vl(Strings[76])) * 0.05);

    Tv[78] := Tv[48];
    Strings[79] := IntToStr(GetNumDays(RetNo, '31-12-2003', 'A') -
      GetNumDays(RetNo, '31-12-2004', 'A'));
    Strings[80] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[81] := Round(Tv[78] * (Vl(Strings[79]) / Vl(Strings[80])) * 0.1205);

    Tv[82] := Tv[48];
    Strings[83] := IntToStr(GetNumDays(RetNo, '31-12-2004', 'A') -
      GetNumDays(RetNo, '31-12-2005', 'A'));
    Strings[84] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[85] := Round(Tv[82] * (Vl(Strings[83]) / Vl(Strings[84])) * 0.1750);

    Tv[86] := Tv[48];
    Strings[87] := IntToStr(GetNumDays(RetNo, '31-12-2005', 'A') -
      GetNumDays(RetNo, '31-12-2006', 'A'));
    Strings[88] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[89] := Round(Tv[86] * (Vl(Strings[87]) / Vl(Strings[88])) * 0.3250);

    Tv[90] := Tv[48];
    Strings[91] := IntToStr(GetNumDays(RetNo, '31-12-2006', 'A') -
      GetNumDays(RetNo, '31-12-2007', 'A'));
    Strings[92] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[93] := Round(Tv[90] * (Vl(Strings[91]) / Vl(Strings[92])) * 0.5000);

    Tv[116] := Vl(FetchElm(RetNo, 'AS7', 3));
    Tv[117] := Vl(FetchElm(RetNo, 'AS7', 19));
    Tv[118] := Tv[116] + Tv[117];
    Tv[119] := 2000000;
    Tv[120] := MaxR(0, Tv[118] - Tv[119]);

    Tv[96] := AddColumns(77, 93, 4);
    If Tv[121] > 0 then
      Tv[96] := Tv[121];
    Tv[49] := Tv[96];

    Tv[54] := AddColumns(50, 52, 2);

    // C adjusted
    Tv[100] := Tv[54];
    Strings[101] := IntToStr(GetNumDays(RetNo, '31-12-2002', 'A') -
      GetNumDays(RetNo, '31-12-2003', 'A'));
    Strings[102] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[103] := Round(Tv[100] * (Vl(Strings[101]) / Vl(Strings[102])) * 0.10);

    Tv[104] := Tv[54];
    Strings[105] := IntToStr(GetNumDays(RetNo, '31-12-2003', 'A') -
      GetNumDays(RetNo, '31-12-2004', 'A'));
    Strings[106] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[107] := Round(Tv[104] * (Vl(Strings[105]) / Vl(Strings[106])) * 0.25);

    Tv[108] := Tv[54];
    Strings[109] := IntToStr(GetNumDays(RetNo, '31-12-2004', 'A') -
      GetNumDays(RetNo, '31-12-2005', 'A'));
    Strings[110] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[111] := Round(Tv[108] * (Vl(Strings[109]) / Vl(Strings[110])) * 0.35);

    Tv[112] := Tv[54];
    Strings[113] := IntToStr(GetNumDays(RetNo, '31-12-2005', 'A') -
      GetNumDays(RetNo, '31-12-2006', 'A'));
    Strings[114] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[115] := Round(Tv[112] * (Vl(Strings[113]) / Vl(Strings[114])) * 0.65);

    Tv[57] := AddColumns(103, 115, 4);
    Tv[55] := Tv[57];

    Tv[94] := Tv[45] + Tv[49] - Tv[55] - Tv[56];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

procedure S51P(RetNo: integer; FName: string; FNo: integer);
Var
  i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Tv[18] := AddColumns(4, 16, 2);
    Tv[19] := AddColumns(5, 17, 2);
    Tv[22] := Tv[18] + Tv[20];
    Tv[23] := Tv[19] + Tv[21];
    Tv[42] := Tv[22] - AddColumns(24, 40, 2);
    Tv[43] := Tv[23] - AddColumns(25, 41, 2);
    Tv[50] := Tv[42] - Tv[46] - Tv[48];
    Tv[51] := Tv[43] - Tv[47] - Tv[49];
    // Tv[52]:=
    Tv[55] := Tv[46];
    Tv[56] := Tv[47];
    Tv[57] := Tv[48];
    Tv[58] := Tv[49];
    Tv[67] := Tv[50] + Tv[53] + Tv[55] + Tv[57] - Tv[59] - Tv[61] -
      Tv[63] - Tv[65];
    Tv[68] := Tv[51] + Tv[54] + Tv[56] + Tv[58] - Tv[60] - Tv[62] -
      Tv[64] - Tv[66];
  end; { End with }
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1273(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  FInst: String; // [4]; //20150701
  AFNo: integer;
  x: Real;

Begin
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);

  With Ret[RetNo].Frm[FNo] do
  begin
    If Strings[39] = '' then
      Strings[39] := LeftStr(GetTaxationYearEnd(RetNo), 4);
    // '2008'; //20100530'2008';

    CaisYrT1273 := Strings[39];
    Strings[40] := CaisYrT1273 + ' Statement A';
    Strings[92] := CaisYrT1273;
    Strings[89] := CaisYrT1273;
    Strings[90] := CaisYrT1273;
    // Strings[91]:=CaisYrT1273;

    Strings[80] := MidStr(FInst, 2, 2);
    Strings[81] := IntToStr(CountT1273(RetNo));

    // Strings[22]:=RightStr(FInst,1);

    Strings[6] := GetCorpName(RetNo);
    If Strings[66] = '' then
      Strings[66] := GetCorpName(RetNo);
    Strings[5] := FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[8] := FetchElm(RetNo, 'T2', 16);
    Strings[9] := FetchElm(RetNo, 'T2', 17);
    Strings[10] := FetchElm(RetNo, 'T2', 20);
    Strings[1] := FetchElm(RetNo, 'T2', 755);
    Strings[2] := FetchElm(RetNo, 'T2', 746);
    Strings[34] := GetCorpBusNo(RetNo);
    Strings[27] := 'X';
    If Strings[35] + Strings[36] = '' then
      Strings[35] := 'X';
    If Strings[32] = '' then
      Strings[32] := FetchElm(RetNo, 'T2', 17);
    If Strings[23] + Strings[24] = '' then
      Strings[24] := 'X';
  end;
  // T1273 pg 2 ----------------------------------------------------------------

  x := 0;
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[101] := CaisYrT1273 + ' Statement A'
    else
      Strings[101] := CaisYrT1273 + ' Statement B';

    Strings[102] := MidStr(FInst, 2, 2);
    Strings[103] := IntToStr(CountT1273(RetNo));
    If Strings[107] + Strings[108] = '' then
      Strings[107] := 'X';
    If Strings[112] = '' then
      Strings[112] := '2';
    Strings[113] := GetBegYearEnd(RetNo);
    Strings[114] := GetTaxationYearEnd(RetNo);

    i := 120;
    Repeat
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      Inc(i, 3);
    until i > 204;

    Tv[209] := Tv[255] + Tv[256];
    Tv[205] := AddColumns(120, 204, 3);
    x := AddColumns(221, 248, 3);
    Tv[218] := x;
    Tv[249] := AddColumns(206, 218, 1);
    Tv[250] := Tv[205];
    Tv[251] := Tv[249];
    Tv[252] := Tv[250] + Tv[251];
  end;
  // T1273 pg 3 ----------------------------------------------------------------
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[495] := CaisYrT1273 + ' Statement A'
    else
      Strings[495] := CaisYrT1273 + ' Statement B';

    Strings[491] := MidStr(FInst, 2, 2);
    Strings[375] := FetchElm(RetNo, 'T1273' + FInst, 103);
    Strings[374] := FetchElm(RetNo, 'T1273' + FInst, 20); // 20121209
    i := 303;
    Repeat
      If Strings[i - 1] = '' then
        Tv[i] := 0;
      Inc(i, 3);
    until i > 357;

    Tv[358] := AddColumns(303, 357, 3);
    Tv[412] := AddColumns(359, 371, 1) + AddColumns(378, 411, 3);
    Tv[486] := AddColumns(442, 484, 3);
    Tv[485] := AddColumns(413, 439, 1) + Tv[486];
    Tv[487] := Tv[358];
    Tv[488] := Tv[412];
    Tv[489] := Tv[485];
    Tv[490] := Tv[487] + Tv[488] + Tv[489];
  end;
  // T1273 pg 4 ----------------------------------------------------------------
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[517] := CaisYrT1273 + ' Statement A'
    else
      Strings[517] := CaisYrT1273 + ' Statement B';

    Strings[504] := MidStr(FInst, 2, 2);
    Strings[578] := FetchElm(RetNo, 'T1273' + FInst, 103);
    Tv[501] := Vl(FetchElm(RetNo, 'T1273' + FInst, 252));
    Tv[502] := Vl(FetchElm(RetNo, 'T1273' + FInst, 490));
    Tv[503] := Tv[501] - Tv[502];
    Tv[505] := Tv[503];
    Tv[513] := Tv[505] + Tv[508] + Tv[510];
    Tv[516] := Tv[513];
    Tv[513] := Tv[515] - Tv[518];
  end;
  // T1273 pg 5 ----------------------------------------------------------------
  FormatSettings.DecimalSeparator := '.'; // 20150620
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
    Strings[601] := FetchElm(RetNo, 'T1273' + FInst, 20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[602] := CaisYrT1273 + ' Statement A'
    else
      Strings[602] := CaisYrT1273 + ' Statement B';

    Strings[603] := MidStr(FInst, 2, 2);
    Strings[604] := FetchElm(RetNo, 'T1273' + FInst, 103);
    // If Strings[11]+Strings[12]='' then strings[12]:='X';

    i := 609;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      Inc(i, 4);
    until i > 657;

    i := 662;
    Repeat
      Strings[i - 1] := LeftStr(Strings[i - 1], 2);
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Not RealNumeric(Strings[i + 1]) then
        Strings[i + 1] := '';
      If Strings[i + 1] > '' then
        Strings[i + 1] := FormatT1273Decimals(Strings[i + 1]);
      If Not RealNumeric(Strings[i + 2]) then
        Strings[i + 2] := '';
      If Strings[i + 2] > '' then
        Strings[i + 2] := FormatT1273Decimals(Strings[i + 2]);

      Inc(i, 7);
    until i > 746;

    // unfarmable
    For i := 758 to 761 do
    begin
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Vl(Strings[i]) = 0 then
        Strings[i] := '';
    end;
  end;
  // T1273 pg 6 ----------------------------------------------------------------
  FormatSettings.DecimalSeparator := '.'; // 20150620
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
    Strings[801] := FetchElm(RetNo, 'T1273' + FInst, 20);

    If MidStr(FInst, 2, 2) = '1' then
      Strings[802] := CaisYrT1273 + ' Statement A'
    else
      Strings[802] := CaisYrT1273 + ' Statement B';

    Strings[803] := MidStr(FInst, 2, 2);
    Strings[804] := FetchElm(RetNo, 'T1273' + FInst, 103);
    Strings[892] := CaisYrT1273;
    Strings[801] := CaisYrT1273;
    Strings[891] := CaisYrT1273;
    Strings[893] := CaisYrT1273;
    Strings[892] := CaisYrT1273;
    Strings[894] := IntToStr(StrToInt(CaisYrT1273) + 1);

    i := 877;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      Inc(i, 1);
    until i > 891;
  end;
  // T1273 pg 7 ----------------------------------------------------------------
  FInst := ExtractFormInst(FName);
  With Ret[RetNo].Frm[FNo] do
  begin
    If MidStr(FInst, 2, 2) = '1' then
      Strings[1001] := CaisYrT1273 + ' Statement A'
    else
      Strings[1001] := CaisYrT1273 + ' Statement B';

    Strings[1002] := MidStr(FInst, 2, 2);
    Strings[1003] := FetchElm(RetNo, 'T1273' + FInst, 103);
  end;
  SaveTv(RetNo, FName, FNo);

end;

Procedure T1273A1(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  x: Real;
  FInst: String; // [4]; //20150701
Begin
  FormatSettings.DecimalSeparator := '.'; // 20150620
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := FetchElm(RetNo, 'T1273' + FInst, 20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[2] := CaisYrT1273 + ' Statement A'
    else
      Strings[2] := CaisYrT1273 + ' Statement B';
    Strings[3] := MidStr(FInst, 2, 2);
    Strings[4] := FetchElm(RetNo, 'T1273' + FInst, 104);

    i := 9;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      Inc(i, 4);
    until i > 57;

    i := 62;
    Repeat
      Strings[i - 1] := LeftStr(Strings[i - 1], 2);
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Not RealNumeric(Strings[i + 1]) then
        Strings[i + 1] := '';
      If Strings[i + 1] > '' then
        Strings[i + 1] := FormatT1273Decimals(Strings[i + 1]);
      If Not RealNumeric(Strings[i + 2]) then
        Strings[i + 2] := '';
      If Strings[i + 2] > '' then
        Strings[i + 2] := FormatT1273Decimals(Strings[i + 2]);
      Inc(i, 7);
    until i > 146;

    // unfarmable
    For i := 158 to 161 do
    begin
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      If Vl(Strings[i]) = 0 then
        Strings[i] := '';
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure T1273A2(RetNo: integer; FName: string; FNo: integer);
var
  i, k: integer;
  x: Real;
  FInst: String; // [4]; //20150701
Begin
  FormatSettings.DecimalSeparator := '.'; // 20150620
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := FetchElm(RetNo, 'T1273' + FInst, 20);
    If MidStr(FInst, 2, 2) = '1' then
      Strings[2] := CaisYrT1273 + ' Statement A'
    else
      Strings[2] := CaisYrT1273 + ' Statement B';
    Strings[3] := MidStr(FInst, 2, 2);
    Strings[4] := FetchElm(RetNo, 'T1273' + FInst, 104);

    i := 95;
    Repeat
      If Not RealNumeric(Strings[i]) then
        Strings[i] := '';
      If Strings[i] > '' then
        Strings[i] := FormatT1273Decimals(Strings[i]);
      Inc(i, 4);
    until i > 111;
  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure AFRBAL(RetNo: integer; FName: string; FNo: integer);
Begin
  LoadTv(RetNo, FName, FNo);
  With Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
  end;
  SaveTv(RetNo, FName, FNo);
end;


procedure S8(RetNo: integer; FName: string; FNo: integer);

                function availableForUSE(aPeriod:string;aYearUser,aYear:integer):boolean;
                begin
                  result:= false;
                  if length(inttostr(aYearUser)) = 4 then
                  begin
                    if      lowercase(aPeriod) = 'before' then
                                                                begin if aYearUser < aYear then result:= true; end
                    else if lowercase(aPeriod) = 'after'  then
                                                                begin if aYearUser > aYear then result:= true; end
                    else if lowercase(aPeriod) = 'in'     then
                                                                begin if aYearUser = aYear then result:= true; end;
                  end;
                end;

                function acquired(aPeriod:string;aYearUser,aYear:integer):boolean;
                begin
                  result:= false;
                  if length(inttostr(aYearUser)) = 4 then
                  begin
                    if      lowercase(aPeriod) = 'before' then
                                                                begin if aYearUser < aYear then result:= true; end
                    else if lowercase(aPeriod) = 'after'  then
                                                                begin if aYearUser > aYear then result:= true; end
                    else if lowercase(aPeriod) = 'in'     then
                                                                begin if aYearUser = aYear then result:= true; end;
                  end;
                end;


                function FractionToReal(const S: string): Real;
                var
                  BarPos: Integer;
                  NumStr, DenomStr: string;
                  Num, Denom: Real;
                begin
                  BarPos := Pos('/', S); //Check for the division operator

                  // If no fraction bar, just convert as standard float
                  if BarPos = 0 then
                  begin
                    Result := StrToFloat(S);Exit;
                  end;

                  // Extract numerator and denominator
                  NumStr   := Trim(Copy(S, 1, BarPos - 1));
                  DenomStr := Trim(Copy(S, BarPos + 1, Length(S)));

                  // Convert to Real and perform division
                  Num := StrToFloat(NumStr);
                  Denom := StrToFloat(DenomStr);

                  if Denom = 0 then
                    raise EConvertError.Create('Denominator cannot be zero');

                  Result := Num / Denom;
                end;

Var
  i,j, k, K1: integer;
  FInst: String;
  S8FNo: integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;
  Rate: String;
  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  Diep:Boolean;   //20231017
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;
  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  PurchaseDate: String;
  LeaseMaxCca: Real;
  x: Real;
  y: Real;
  lTotalValof_19: Currency; //20260501 Alex
  lTotalValof_20: Currency; //20260501 Alex
  lTotalValof_21: Currency; //20260501 Alex
  //20260519 Alex >>>
  lCol1: Integer;
  lCol2: Integer;
  lCol3: Integer;
  lCol4: Integer;
  lCol5: Integer;
  lCol6: Integer;
  lCol7: Integer;
  lCol8: Integer;
  lCol9: Integer;
  lCol10: Integer;
  lCol11: Integer;
  lCol12: Integer;
  lCol13: Integer;
  lCol14: Integer;
  lCol15: Integer;
  lCol16: Integer;
  lCol17: Integer;
  lCol18: Integer;
  lCol19: Integer;
  lCol20: Integer;
  lCol21: Integer;
  lCol22: Integer;
  lCls: string;
  //20260519 Alex <<<
  lColAquiredDate  : Integer;
  lColAvailalbeDate: Integer;

  AquiredYr, AvailYr,
  AquiredDt, AvailDt  : Integer;

  lCol15factor    :integer;
  lCol15factorVal :string;
  lCol16factor    :integer;
  lCol16factorVal :string;

begin
  //x:= Vl(FetchElm(RetNo, FNo, 232)); // 20220726
  DaysInTaxYear:= Ret[RetNo].DaysInYear;
  if DaysInTaxYear > 365 then DaysInTaxYear:= 365;
  S8FNo:= GetFormNo('S8#1'); // 20220826
  FInst:= ExtractFormInst(FName);

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Strings[227]:=S8ApplicableVersion; //230260531 //'2026/05/31'; //Date Form after wich it was saved with the new format
    if Strings[4] + Strings[5] = '' then Strings[5] := 'X';

    //New calculation 2026 year. //20260519 Alex >>>
    lTotalValof_19:= 0;
    lTotalValof_20:= 0;
    lTotalValof_21:= 0;

    lColAquiredDate   := 233;
    lColAvailalbeDate := 243;
    lCol15factor      := 263;
    lCol16factor      := 253;

    i:= 7;
    repeat
      lCol1:= i - 1;
      lCol2:= i;
      lCol3:= i + 1;
      lCol4:= i + 2;
      lCol5:= i + 3;
      lCol6:= i + 4;
      lCol7:= i + 5;
      lCol8:= i + 6;
      lCol9:= i + 7;
      lCol10:= i + 8;
      lCol11:= i + 9;
      lCol12:= i + 10;
      lCol13:= i + 11;
      lCol14:= i + 12;
      lCol15:= i + 13;
      lCol16:= i + 14;
      lCol17:= i + 15;
      lCol18:= i + 16;
      lCol19:= i + 17;
      lCol20:= i + 18;
      lCol21:= i + 19;
      lCol22:= i + 20;
      lCls:= trim(Strings[lCol1]);

      Tv[lCol10]:= Tv[lCol2] + Tv[lCol3] + Tv[lCol6] - Tv[lCol9]; // Column 10
      Tv[lCol11]:= MaxR(0, Tv[lCol7]  + Tv[lCol9] - Tv[lCol3] + Tv[lCol4] + Tv[lCol5] - Tv[lCol8]); // Column 11
      Tv[lCol12]:= MaxR(0, Tv[lCol4]  - Tv[lCol11]);  // Column 12
      Tv[lCol13]:= MaxR(0, Tv[lCol11] - Tv[lCol4]);   // Column 13
      Tv[lCol14]:= MaxR(0, Tv[lCol5]  - Tv[lCol13]);  // Column 14

      //populate AquiredYr and AvailYr, used for col15 and col16, if find is used for other cols before these may need to be moved up to be before those

      AquiredDt := 0;
      AvailDt   := 0;

      AquiredYr := 0;
      AvailYr   := 0;

      //for some reason fails when is '' (blank)
      if strings[lColAquiredDate]   > ''  then AquiredDt := strtoint( StringReplace(strings[lColAquiredDate]   , '/', '', [rfReplaceAll, rfIgnoreCase]) );
      if strings[lColAvailalbeDate] > ''  then AvailDt   := strtoint( StringReplace(strings[lColAvailalbeDate] , '/', '', [rfReplaceAll, rfIgnoreCase]) );

      if strings[lColAquiredDate]   > ''  then AquiredYr := strtoint(LeftStr(strings[lColAquiredDate]  ,4));
      //if strings[lColAvailalbeDate] > ''  then AvailYr   := strtoint(LeftStr(strings[lColAvailalbeDate],4)); //20260702 Removed

      lCol15factorVal := '0';

      //jz//20260604
      // Column 15 START -->

      if (lCls > '') and (Tv[lCol12] > 0) then
      begin

        if        ( lCls.Equals('43.1') or
                    lCls.Equals('54')   or
                    lCls.Equals('56') ) then
                                              begin
                                                if      (availableForUSE('in'    ,AvailYr,2024)) or
                                                        (availableForUSE('in'    ,AvailYr,2025))      then lCol15factorVal := '3/2'
                                                else if (availableForUSE('after' ,AvailYr,2025))      then lCol15factorVal := '5/6';
                                              end
        else if   lCls.Equals('55')     then
                                              begin
                                                if      (availableForUSE('in'    ,AvailYr,2024)) or
                                                        (availableForUSE('in'    ,AvailYr,2025))      then lCol15factorVal := '7/8'
                                                else if (availableForUSE('after' ,AvailYr,2025))      then lCol15factorVal := '3/8';
                                              end

        //jz ??? not sure what eas this for?? //if      lCls.Equals('43.2') or lCls.Equals('44') or (Strings[i - 1]).Equals('53.3')   then lCol15factorVal := '1/2'  else //If available after April 15, 2024

        else if   lCls.Equals('43.2') or
                  lCls.Equals('53.3') then
                                              begin
                                                if      (availableForUSE('in'    ,AvailYr,2024)) or
                                                        (availableForUSE('in'    ,AvailYr,2025))      then lCol15factorVal := '1/2'
                                                else if (availableForUSE('after' ,AvailYr,2025))      then lCol15factorVal := '1/10';
                                              end

        else if   lCls.Equals('44')   then
                                              begin                               //If available after April 15, 2024????? change yr field to date filed
                                                if      (availableForUSE('after', AvailDt,20240415)) and
                                                        (availableForUSE('before',AvailYr,2027))      then lCol15factorVal := '3'
                                                else if (availableForUSE('after' ,AvailYr,2026))      then lCol15factorVal := '0';
                                              end

        else if   lCls.Equals('46')   then
                                              begin                               //If available after April 15, 2024????? change yr field to date filed
                                                if      (availableForUSE('after', AvailDt,20240415)) and
                                                        (availableForUSE('before',AvailYr,2027))      then lCol15factorVal := '7/3'
                                                else if (availableForUSE('after' ,AvailYr,2026))      then lCol15factorVal := '0';
                                              end
        else if   lCls.Equals('50')   then
                                              begin                               //If available after April 15, 2024????? change yr field to date filed
                                                if      (availableForUSE('after', AvailDt,20240415)) and
                                                        (availableForUSE('before',AvailYr,2027))      then lCol15factorVal := '9/11'
                                                else if (availableForUSE('after' ,AvailYr,2026))      then lCol15factorVal := '0';
                                              end

        else if   lCls.Equals('12') or lCls.Equals('13') or lCls.Equals('14') or //????? or this --> as well as properties that are Canadian vessels included in paragraph 1100(1)(v) of the Regulations (see note 16 for additional information
                  lCls.Equals('15') or lCls.Equals('59')                                              then lCol15factorVal := '0'

        //what does this sentence mean???
        //                    0 for all other property (including property in Class 10.1) that is an AIIP (other than property in Classes 44, 46 or 50) that became available for use after 2023
        //                    just put all else at 0 for now
        else                                                                                               lCol15factorVal := '0'; //If available after 2026 year
      end;

      strings[lCol15factor]  := lCol15factorVal;
      Tv[lCol15]             := Tv[lCol12] * FractionToReal(strings[lCol15factor]);

      inc(lCol15factor,1);
      // Column 15 END <--

      //jz//20260603
      // Column 16 START -->
      lCol16factorVal := '0';

      if (lCls > '') and (Tv[lCol14] > 0) then
      begin

        if      (lCls.Equals('43.1') or lCls.Equals('54') or lCls.Equals('56')) and
                (availableForUSE('before',AvailYr,2030))                                        then lCol16factorVal := '7/3' //2 1/3
        else if (lCls.Equals('55')) and (availableForUSE('before',AvailYr,2030))                then lCol16factorVal := '3/2' //1 1/2
        else if (lCls.Equals('53'))                                                             then lCol16factorVal := '1'
        else if (lCls.Equals('43')) and (availableForUSE('before',AvailYr,2030))                then lCol16factorVal := '7/3' //not sure what this means?? if such property would have been included in Class 53 if it had been acquired in 2025

        else if (lCls.Equals('44')) then  begin
                                            if      (availableForUSE('before',AvailYr,2027))    then lCol16factorVal := '3'
                                            else if (availableForUSE('after' ,AvailYr,2026))    then lCol16factorVal := '0';
                                          end
        else if (lCls.Equals('46')) then  begin
                                            if      (availableForUSE('before',AvailYr,2027))    then lCol16factorVal := '7/3' //2 1/3
                                            else if (availableForUSE('after' ,AvailYr,2026))    then lCol16factorVal := '0';
                                          end
        else if (lCls.Equals('50')) then
                                          begin
                                            if      (availableForUSE('before',AvailYr,2027))    then lCol16factorVal := '9/11'
                                            else if (availableForUSE('after' ,AvailYr,2026))    then lCol16factorVal := '0';
                                          end
        else if ( lCls.Equals('12') or lCls.Equals('13') or lCls.Equals('14') or
                  lCls.Equals('15')  or lCls.Equals('59') )                                     then lCol16factorVal := '0' //?? as well as properties that are Canadian vessels included in paragraph 1100(1)(v) of the Regulations (see note 16 for additional information)

        else if (lCls.Equals('10.1')) then  begin
                                              if (availableForUSE('before',AvailYr,2030))       then lCol16factorVal := '1/2'  //0.5 was causing error?
                                              else if (availableForUSE('after' ,AvailYr,2029))  then lCol16factorVal := '0';
                                            end
        else                                                                                         lCol16factorVal := '1/2'; //0.5 was causing error?

      end;

      strings[lCol16factor]  := lCol16factorVal;
      Tv[lCol16]             := Tv[lCol14] * FractionToReal(strings[lCol16factor]);

      inc(lCol16factor,1);
      // Column 16 END <--

      inc(lColAquiredDate  ,1);
      inc(lColAvailalbeDate,1);



      Tv[lCol17]:= MaxR(0, 0.5 * Tv[lCol3] - Tv[lCol4] - Tv[lCol5] + Tv[lCol8] - Tv[lCol7] - Tv[lCol9]); // Column 17 //(0.5 multiplied by the result of column 3 minus column 4 minus column 5 plus column 8 minus column 7 minus column 9)
      // Column 19
      if not lCls.Equals('10.1') and (Tv[lCol10] < 0) then Tv[lCol19]:= Abs(Tv[lCol10]) else Tv[lCol19]:= 0; //Enter the negative amount from column 10 in column 19 as a positive. The recapture rules do not apply to passenger vehicles in Class 10.1.
      // Column 20
      if not lCls.Equals('10.1') and not lCls.Equals('14') and not lCls.Equals('14.1') and (Tv[lCol10] > 0) then Tv[lCol20]:= Abs(Tv[lCol10]) else Tv[lCol20]:= 0; //enter the positive amount from column 10 in column 20.
      //The terminal loss rules do not apply to: Class 10.1, 14.1, 14.
      Tv[lCol18]:= Vl(GetCCARate(lCls)); //20260519 Alex

      if DaysInTaxYear < 365 then
        Tv[lCol21]:= ((Tv[lCol10] + Tv[lCol15] + Tv[lCol16] - Tv[lCol17]) * (Tv[lCol18] / 100)) * (DaysInTaxYear / 365) // Column 21 //If the tax year is shorter than 365 days, prorate the CCA claim.//20260519 Alex
      else
        Tv[lCol21]:= (Tv[lCol10] + Tv[lCol15] + Tv[lCol16] - Tv[lCol17]) * (Tv[lCol18] / 100); // Column 21 //20260519 Alex
      // Column 22
      Tv[lCol22]:= Tv[lCol10] - Tv[lCol21];

      //----------------------------------------
      //20260519cz   thre are dispositions
      Tv[lCol19]:=0; //init recapture
      Tv[lCol20]:=0; //init terminal loss
      if (Tv[lCol9]>0) then //and lCls.Equals('10.1') then //NO DISPOSITIONS
      Begin
       If (Tv[lCol10]>0) then  //terminal loss
       begin
        Tv[lCol20]:= ABS(Tv[lCol10]);  //recapture
        Tv[lCol21]:=0; //cca zero
        Tv[lCol22]:=0;
       end
       Else  //recapture
       Begin
        Tv[lCol19]:= ABS(Tv[lCol10]);
        Tv[lCol21]:=0; //cca zero
        Tv[lCol22]:= 0;
       end;
      End;
      //--------------------------------------
      //Totals calculation
      lTotalValof_19:= lTotalValof_19 + Tv[lCol19];
      lTotalValof_20:= lTotalValof_20 + Tv[lCol20];
      lTotalValof_21:= lTotalValof_21 + Tv[lCol21];
      Inc(i, 22);
    until i > 209;

     //20260607
    //copy class from first section to other 2 sections for readbility;
    i:=6;
    j:=273;
    Repeat
     Strings[j]:=Strings[i];
     Strings[j+10]:=Strings[i]; //second section showing classes
     Inc(i,22);
     Inc(j,1);
    Until i>204;

    //20260519cz
    Tv[230]:= lTotalValof_19;
    Tv[231]:= lTotalValof_20;
    Tv[232]:= lTotalValof_21;
    { Changed the total Element numbers to be like they used to be before //20260519
    Tv[226]:= lTotalValof_19;
    Tv[227]:= lTotalValof_20;
    Tv[228]:= lTotalValof_21;
    //20260519 Alex <<<
    }
  end; // with?

  SaveTv(RetNo, FName, FNo);
end;








// 20230530
Procedure S67(RetNo: integer; FName: String; FNo: integer);
var i: integer;
begin
  LoadTv(RetNo, FName, FNo);


  with Ret[RetNo].Frm[FNo] do
  begin
    if UpperCase(strings[72])<>'Y' then  //20230614
    begin
     for i:=1 to 71 do Begin Tv[i]:=0;Strings[i]:='';end;
     SaveTv(RetNo, FName, FNo);
     Exit;
    end;

    FillHeader(RetNo, FNo, 1, 2, 3);

    Tv[54]:=0;  //con
    i := 11;
    Repeat
      Tv[54] := Tv[54] + Tv[i];
      Inc(i,3);
    until i>53;

    Tv[54] := MinR(1000000000, Tv[54]);
    Tv[55] := Tv[11];  //20230609

    Tv[58] := Tv[56] + Tv[57];
    Tv[5]  := Tv[58];

    TV[59]:=Tv[5]; //con
    Tv[60] := Tv[59] * 0.5;

    //Tv[61] := //Tv[55];  //leave for user //Con
    Tv[62]:=Tv[60]; //con
    Tv[63]:=Tv[61]; //con
    Tv[64] := MaxR(0, Tv[62] - Tv[63]);
    Tv[65]:=Tv[64]; //con
    Tv[66] := Tv[65] * 0.15;

    Tv[67]:= Tv[6];  //20230606

    Tv[4] := Tv[66];
    Tv[6] := Round(Tv[4]/5); //* 0.25; //20230616
    //20230616 Con  jz???
    Tv[67] :=Tv[6];
    Tv[68] :=Tv[6];
    Tv[69] :=Tv[6];
    Tv[70] :=Tv[6];
    Tv[71] :=Tv[6];

  end;
  SaveTv(RetNo, FName, FNo);
end;

Procedure S68(RetNo: integer; FName: String; FNo: integer);
var i: integer;
begin
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    if UpperCase(strings[72])<>'Y' then  //20230614
    begin
     for i:=1 to 71 do Begin Tv[i]:=0;Strings[i]:='';end;
     SaveTv(RetNo, FName, FNo);
     Exit;

    end;

    FillHeader(RetNo, FNo, 1, 2, 3);

    i := 12;
    Tv[58]:=0;  //con
    Repeat
      Tv[58] := Tv[58] + Tv[i];
      Inc(i,3);
    until i>57;
    Tv[58] := MinR(Tv[58], 1000000000); //jz 20230605

   // Tv[61]:=MaxR(0,Tv[59]-Tv[60]);  //con  //20230623

    // jz ??? user? notes?
    Tv[59] :=Ret[RetNo].LN[360];  //20230606 CON
    Tv[60] := 100000000;
    if Tv[12]>0 then Tv[60]:=Tv[12]; //20230606 CON
    Tv[61] := MaxR(0,Tv[59] - Tv[60]);  //20230623

    Tv[62]  := Tv[61];
    //???
    strings[63] := IntToStr(GetNumDays(RetNo, '07-04-2022', 'A')); //20230616
    strings[64] := IntToStr(Ret[RetNo].DaysInYear);
    Tv[65]  := Tv[62] * (Vl(strings[63]) / Ret[RetNo].DaysInYear) * 0.015; //con
  end;

  SaveTv(RetNo, FName, FNo);
end;

//20230529
Procedure S444(RetNo:integer;FName:string;FNo:integer); //20201023
var
  i:integer;
  x:real;
  s,s0,s1:string;
Begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[Fno] do
 begin
  //20250812
  If (Ret[RetNo].Province <> 'YT') or (Ret[RetNo].Province <> 'MJ') then
  Begin
   for i:=9 to 415 do begin Tv[0]:=0;Strings[i]:='';end;
   SaveTv(RetNo,FName,FNo);
   Exit;
  End;

  FillHeader(RetNo,FNo,1,2,3);
  Tv[9]:=0;
  //k:=21;
  i:=0; //k-1;
  Repeat
   //Strings[i+22]?
   if Strings[i+23]='' then Strings[i+23]:='1';  //20201026
   if Strings[i+21]='' then Strings[i+23]:=''; //20221115

   Tv[i+26]:=Tv[i+24]+Tv[i+25];
   Tv[i+27]:=(Vl(Strings[i+22])/100) *Vl(Strings[i+23]) *Tv[i+26];  //20231109 no divide by 100
   Tv[9]:=Tv[9]+Tv[i+27];  //20220511
   //Inc(k,7);
   i:=i+7;
  until i+21>210;   //jz 20230530

  //jz 20230530
  Tv[12] := Tv[9];

  //jz 20241120 as per note 4
  //if Strings[13]='' then  begin //why with this? makes it not work if date change
    If GetTaxationYearEnd(RetNo) < '2024/04/01' then
      strings[13] := '4';
    If GetTaxationYearEnd(RetNo) > '2024/03/31' then
      strings[13] := '2';
  //end;
  If strings[416] > '' then
    strings[13] := '1';


  Tv[14] := Tv[12] * strtoint(strings[13]);

  //20220511
  Tv[5]:=Tv[14]+Tv[4]; //jz 20230530
  Tv[6]:=Tv[5];

  //if Strings[7]='' then begin   //why with this? makes it not work if date change
  if GetTaxationYearEnd(RetNo)<'2024/04/01' then
    Strings[7]:='0.02108'  //jz 20241120 '0.00881' as per note 7
  Else
    Strings[7]:='0.03647';  //jz 20241120 '0.03962';
  //end;

  Tv[8]:=Tv[6]*vl(Strings[7]);


  //jz 20230530
  //pg2 ---------------------------------------------------------------

  Tv[415]:=0;
  i:=0;
  Repeat
   if Strings[i+221]='' then Strings[i+221]:='1';
   if Strings[i+219]='' then Strings[i+221]:='';

   Tv[i+224]:=Tv[i+222]+Tv[i+223];
   Tv[i+225]:=(Vl(Strings[i+220])) *Vl(Strings[i+221]) *Tv[i+224];  //20231109 no devide by 100
   Tv[415]:=Tv[415]+Tv[i+225];
   i:=i+7;
  until i+219>408;

  Tv[16]:=0;
  i:=0;
  Repeat
   s := trim(Strings[i+21]);   //jz 20230605
   if (s <> '41') and (s <> '41.2') then
    Tv[16] := Tv[16] + Tv[i+27];
   i:=i+7;
  until i+21>210;

  //Tv[15] := //where does this come from?? //jz 20230605
  Tv[17] := Tv[415] + Tv[15]; // + Tv[16]; //jz vt49 Tv[16] removed

  //Tv[18] := Tv[5];  // how to know if eligible?? //jz 20230605
  //Tv[19] := MaxR(0, Tv[17] - Tv[18]); //jz vt49 tv[19],tv[18] removed
  //Tv[20] := Tv[19];                   //jz vt49 tv[19] removed

  Tv[20] := Tv[17]; //jz vt49

  //if Strings[217]='' then Begin  //why with this? makes it not work if date change
   if GetTaxationYearEnd(RetNo)<'2024/04/01' then
    Strings[217]:='0.02189' //'0.03962'
   Else
    Strings[217]:='0.02220'; //'0.02189';
  //end;

  Tv[218] := Tv[20] * Vl(Strings[217]); //jz 20230605

 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure S310(RetNo:integer;FName:string;FNo:integer); //20231006
var
  i,j:integer;
Begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);
  Tv[20]:=0;
  i:=93;
  Repeat
   Tv[20]:=Tv[20]+Tv[i];
   Inc(i,4);
  until i>117;

  Tv[23]:=MaxR(0,TV[21]-Tv[22]);
  Tv[89]:=Tv[20];
  Tv[24]:=Round(Tv[89]*10/100);
  Tv[25]:=Tv[23]+TV[24];
  Tv[26]:=Tv[25];
  Tv[27]:=MinR(Tv[26],Tv[5]);  //20231009
  If TV[27]>Tv[26] then Tv[27]:=Tv[26];

  If Ret[RetNo].CorpType = CCPC then
   begin Strings[28]:='X';Strings[29]:='';end
  else
   begin Strings[28]:='';Strings[29]:='X';end;

 if Strings[28]>'' then
 Begin
  Tv[30]:=Tv[24];
  Tv[31]:=MaxR(0,Tv[30]-Tv[4]);
  Tv[32]:=Tv[24];
  Tv[33]:=Round(Tv[32] * 40/100);
  Tv[34]:=MinR(Tv[31],Tv[33]);
 End
 Else
 Begin
  for i:=31 to 34 do Tv[i]:=0;
 End;

 Tv[36]:=Tv[27]+Tv[34]+Tv[35];
 Tv[37]:=Tv[36];
 if Tv[37]>TV[26] then Tv[37]:=Tv[26];
 Tv[38]:=MaxR(0,Tv[26]-Tv[37]);

 Strings[39]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
 Strings[41]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
 Strings[43]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
 Tv[45]:=Tv[40]+Tv[42]+Tv[44];


 i:=46;
 j:=20;
 Repeat
  Strings[i]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),j);
  Inc(i,1);
  Inc(j,-1);
 until i>66;
 Tv[88]:=AddColumns(47,57,2);
 end;
 SaveTv(RetNo,FName,FNo);
end;


//2023106
Procedure S311(RetNo:integer;FName:string;FNo:integer); //20231006
var
  i,j:integer;
Begin
 LoadTv(RetNo,FName,FNo);
 With Ret[RetNo].Frm[Fno] do
 begin
  FillHeader(RetNo,FNo,1,2,3);

  if Strings[4]+Strings[5]='' then Strings[5]:='X';

  Tv[36]:=0;
  if Strings[4]>'' then
  Begin
   Strings[6]:=GetCorpName(RetNo);
   Strings[7]:=GetCorpBusNo(RetNo);
   i:=8;
   Repeat
    Tv[36]:=Tv[36]+Tv[i];
    Inc(i,3);
   until i>35;
  End
  Else
  begin
   Strings[6]:='';
   Strings[7]:='';
   i:=8;
   Repeat
    Tv[i]:=0;
    Inc(i,3);
   until i>35;
  end;

  if Strings[4]>'' then Tv[37]:=Round(1000000 * Tv[8]/100);  //associated then 1 mil * pe4rcentage
  If Tv[36]>100 then Tv[37]:=0;

  Tv[78]:=0;
  i:=41;
  Repeat
   Tv[78]:=Tv[78]+Tv[i];
   Inc(i,4);
  until i>77;

  Tv[81]:=MaxR(0,TV[79]-Tv[80]);
  Tv[82]:=Tv[81];
  Tv[83]:=Tv[78];
  Tv[84]:=Round(Tv[83]*20/100);
  If Tv[85]=0 then Tv[85]:=Tv[37];
  Tv[86]:=MinR(Tv[84],Tv[85]);
  Tv[87]:=Tv[86];
  Tv[88]:=Tv[81]+Tv[87];
  //Tv[89]:=???

  Tv[90]:=Tv[87];
  //Tv[91[:=??
  Tv[92]:=MaxR(0,Tv[90]-Tv[91]);
  Tv[93]:=Tv[87];
  Tv[94]:= Round(Tv[93]*40/100);
  Tv[95]:=MinR(Tv[92],Tv[94]);

  Tv[106]:=Tv[101]+Tv[103]+Tv[105]; //c/b amount
  Tv[96]:=Tv[106];
  Tv[97]:=Tv[89]+Tv[95]+Tv[96];
  Tv[98]:=Tv[97];
  Tv[99]:=Maxr(0,Tv[88]-Tv[98]);

  (*
  Tv[25]:=Tv[23]+TV[24];
  Tv[26]:=Tv[25];
  Tv[27]:=Tv[26];
  If TV[27]>Tv[26] then Tv[27]:=Tv[26];
  If Ret[RetNo].CorpType = CCPC then
   begin Strings[28]:='X';Strings[29]:='';end
  else
   begin Strings[28]:='';Strings[29]:='X';end;

 if Strings[28]>'' then
 Begin
  Tv[30]:=Tv[24];
  Tv[31]:=MaxR(0,Tv[30]-Tv[4]);
  Tv[32]:=Tv[24];
  Tv[33]:=Round(Tv[32] * 40/100);
  Tv[34]:=MinR(Tv[31],Tv[33]);
 End
 Else
 Begin
  for i:=31 to 34 do Tv[i]:=0;
 End;

 Tv[36]:=Tv[27]+Tv[34]+Tv[35];
 Tv[37]:=Tv[36];
 if Tv[37]>TV[26] then Tv[37]:=Tv[26];
 Tv[38]:=MaxR(0,Tv[26]-Tv[37]);
 *)

 Strings[100]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),1);
 Strings[102]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),2);
 Strings[104]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),3);
 Tv[106]:=Tv[101]+Tv[103]+Tv[105];

 i:=107;
 j:=20;
 Repeat
  Strings[i]:=GetPrevYearEnd(GetTaxationYearEnd(RetNo),j);
  Inc(i,1);
  Inc(j,-1);
 until i>127;
 Tv[149]:=AddColumns(128,148,1);
 end;
 SaveTv(RetNo,FName,FNo);
end;

//20250908 Igor >>>
procedure S150(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);
  if Licenselevel <> llEnterprise then exit; //20231031

  with Ret[RetNo].Frm[Fno] do
  begin
    //20250101 CZ
    if Strings[679]<>'Y' then
    begin
     for i:=1 to 678 do begin Tv[i]:=0;end;
     SaveTv(RetNo,FName,FNo);
     Exit;
    end;
    FillHeader(RetNo, FNo, 1, 2, 3);

    {//folowing not good,  They could have 0 in Canada
    i:=14; //If tptal column<>0 then Canada Column default
    Repeat
    if (Tv[i]<>0) and (Tv[i+1]=0) then Tv[i+1]:=Tv[i];
    Inc(i,2);
    Until i>50;

    i:=52; //If tptal column<>0 then Canada Column default
    Repeat
    if (Tv[i]<>0) and (Tv[i+1]=0) then Tv[i+1]:=Tv[i];
    Inc(i,2);
    Until i>34;
    }
   //---CZ---------------------------------------

    // Page 2
    Tv[50]:= Tv[14] + Tv[16] + Tv[18] + Tv[20] + Tv[22] + Tv[24] + Tv[26] + Tv[28] + Tv[30] + Tv[32] + Tv[34] + Tv[36] + Tv[38] + Tv[40] + Tv[42] + Tv[44] + Tv[46] + Tv[48];
    Tv[51]:= Tv[15] + Tv[17] + Tv[19] + Tv[21] + Tv[23] + Tv[25] + Tv[27] + Tv[29] + Tv[31] + Tv[33] + Tv[35] + Tv[37] + Tv[39] + Tv[41] + Tv[43] + Tv[45] + Tv[47] + Tv[49];
    Tv[98]:= Tv[52] + Tv[54] + Tv[56] + Tv[58] + Tv[60] + Tv[62] + Tv[64] + Tv[66] + Tv[68] + Tv[70] + Tv[72] + Tv[74] + Tv[76] + Tv[78] + Tv[80] + Tv[82] + Tv[84] + Tv[86] + Tv[88] + Tv[90] + Tv[92] + Tv[94] + Tv[96];
    Tv[99]:= Tv[53] + Tv[55] + Tv[57] + Tv[59] + Tv[61] + Tv[63] + Tv[65] + Tv[67] + Tv[69] + Tv[71] + Tv[73] + Tv[75] + Tv[77] + Tv[79] + Tv[81] + Tv[83] + Tv[85] + Tv[87] + Tv[89] + Tv[91] + Tv[93] + Tv[95] + Tv[97];

    // Page 3
    Tv[132]:= Tv[100] + Tv[102] + Tv[104] + Tv[106] + Tv[108] + Tv[110] + Tv[112] + Tv[114] + Tv[116] + Tv[118] + Tv[120] + Tv[122] + Tv[124] + Tv[126] + Tv[128] + Tv[130];
    Tv[133]:= Tv[101] + Tv[103] + Tv[105] + Tv[107] + Tv[109] + Tv[111] + Tv[113] + Tv[115] + Tv[117] + Tv[119] + Tv[121] + Tv[123] + Tv[125] + Tv[127] + Tv[129] + Tv[131];
    Tv[134]:= Tv[98] + Tv[132];
    Tv[135]:= Tv[99] + Tv[133];

    // Page 5
    Tv[170]:= Tv[167] + Tv[168] + Tv[169];
    Tv[173]:= Tv[170] - Tv[171] - Tv[172];
    Tv[178]:= Tv[174] + Tv[175] + Tv[176] + Tv[177];
    Tv[183]:= Tv[178] + Tv[179] + Tv[180] + Tv[181] + Tv[182];

    // Page 7
    Tv[265]:= Tv[194] + Tv[195] + Tv[196] + Tv[197] + Tv[198] + Tv[199] + Tv[200] + Tv[201] + Tv[202] + Tv[203] + Tv[204] + Tv[205] + Tv[206] + Tv[207] + Tv[208] + Tv[209] + Tv[210] + Tv[238] + Tv[240] + Tv[242] + Tv[244] + Tv[246] + Tv[248] + Tv[250] + Tv[252] + Tv[254] + Tv[256] + Tv[258] + Tv[263];
    Tv[266]:= Tv[211] + Tv[212] + Tv[213] + Tv[214] + Tv[215] + Tv[216] + Tv[217] + Tv[218] + Tv[219] + Tv[220] + Tv[221] + Tv[222] + Tv[223] + Tv[224] + Tv[225] + Tv[226] + Tv[227] + Tv[228] + Tv[229] + Tv[230] + Tv[231] + Tv[232] + Tv[233] + Tv[234] + Tv[235] + Tv[236] + Tv[237] + Tv[239] + Tv[241] + Tv[243] + Tv[245] + Tv[247] + Tv[249] + Tv[251] + Tv[253] + Tv[255] + Tv[257] + Tv[259] + Tv[260] + Tv[261] + Tv[262] + Tv[264];
    Tv[282]:= Tv[267] + Tv[269] + Tv[271] + Tv[273] + Tv[275] + Tv[277] + Tv[280];
    Tv[283]:= Tv[268] + Tv[270] + Tv[272] + Tv[274] + Tv[276] + Tv[278] + Tv[279] + Tv[281];
    Tv[296]:= Tv[265] - Tv[282] + Tv[284] - Tv[290];
    Tv[289]:= Tv[285] + Tv[286] + Tv[287] + Tv[288];
    Tv[295]:= Tv[291] + Tv[292] + Tv[293] + Tv[294];
    Tv[297]:= Tv[266] - Tv[283] + Tv[289] - Tv[295];

    // Page 8
    Tv[307]:= Tv[298] + Tv[299] + Tv[300] + Tv[301] + Tv[302] + Tv[303] + Tv[304] + Tv[305] + Tv[306]; // Calc 480

    // Page 5
    Tv[186]:= Tv[307]; // Copy from 480
    Tv[187]:= Tv[184] + Tv[185] - Tv[186];
    Tv[188]:= Tv[173] + Tv[183] + Tv[187];
    Tv[191]:= Tv[188] - Tv[189] - Tv[190];
    Tv[193]:= Tv[191] + Tv[192];
    Tv[136]:= Tv[193]; // Copy to line 251

    // Page 4
    Tv[153]:= Tv[137] + Tv[138] + Tv[139] + Tv[140] + Tv[141] + Tv[142] + Tv[143] + Tv[144] + Tv[145] + Tv[146] + Tv[147] + Tv[148] + Tv[149] + Tv[150] + Tv[151] + Tv[152];
    Tv[154]:= Tv[136] + Tv[153];
    Tv[166]:= Tv[155] + Tv[156] + Tv[157] + Tv[158] + Tv[159] + Tv[160] + Tv[161] + Tv[162] + Tv[163] + Tv[164] + Tv[165];

    // Page 9
    Tv[328]:= Tv[312] + Tv[314] + Tv[316] { - D ???} + Tv[319] + Tv[321] + Tv[323] - Tv[325] { + I ???};
    Tv[329]:= Tv[313] + Tv[315] + Tv[317] - Tv[318] + Tv[320] + Tv[322] + Tv[324] - Tv[326] + Tv[327] - Tv[680]; //20260508 Alex
    Tv[338]:= Tv[330] + Tv[332] {- C ???} - Tv[335] { + E ???};
    Tv[339]:= Tv[331] + Tv[333] - Tv[334] - Tv[336] + Tv[337];
    Tv[340]:= Tv[328] + Tv[338];
    Tv[341]:= Tv[329] + Tv[339];
    Tv[347]:= Tv[340] - Tv[345];
    Tv[344]:= Tv[340] + Tv[342];
    if (Tv[344] > Tv[341]) then // Note 4: The current year deduction on line 558 cannot exceed the total reserve reported on line 555.
      Tv[344]:= Tv[341];
    Tv[348]:= Tv[344] - Tv[346];

    // Page 10
    // Totals
    Tv[352]:= Tv[349] + Tv[350] + Tv[351];
    Tv[356]:= Tv[353] + Tv[354] + Tv[355];
    Tv[364]:= Tv[361] + Tv[362] + Tv[363];
    Tv[368]:= Tv[365] + Tv[366] + Tv[367];
    Tv[372]:= Tv[369] + Tv[370] + Tv[371];
    Tv[376]:= Tv[373] + Tv[374] + Tv[375];
    Tv[380]:= Tv[377] + Tv[378] + Tv[379];
    Tv[384]:= Tv[381] + Tv[382] + Tv[383];
    Tv[388]:= Tv[385] + Tv[386] + Tv[387];
    Tv[392]:= Tv[389] + Tv[390] + Tv[391];
    Tv[396]:= Tv[393] + Tv[394] + Tv[395];
    Tv[404]:= Tv[401] + Tv[402] + Tv[403];
    Tv[408]:= Tv[405] + Tv[406] + Tv[407];

    Tv[357]:= Tv[349] + Tv[353];
    Tv[358]:= Tv[350] + Tv[354];
    Tv[359]:= Tv[351] + Tv[355];
    Tv[360]:= Tv[352] + Tv[356];
    Tv[397]:= Tv[357] + Tv[361] + Tv[365] + Tv[369] + Tv[373] + Tv[377] + Tv[381] + Tv[385] + Tv[389] + Tv[393];
    Tv[398]:= Tv[358] + Tv[362] + Tv[366] + Tv[370] + Tv[374] + Tv[378] + Tv[382] + Tv[386] + Tv[390] + Tv[394];
    Tv[399]:= Tv[359] + Tv[363] + Tv[367] + Tv[371] + Tv[375] + Tv[379] + Tv[383] + Tv[387] + Tv[391] + Tv[395];
    Tv[400]:= Tv[360] + Tv[364] + Tv[368] + Tv[372] + Tv[376] + Tv[380] + Tv[384] + Tv[388] + Tv[392] + Tv[396];
    Tv[409]:= Tv[401] + Tv[405];
    Tv[410]:= Tv[402] + Tv[406];
    Tv[411]:= Tv[403] + Tv[407];
    Tv[412]:= Tv[404] + Tv[408];

    // Page 11
    // Totals
    Tv[416]:= Tv[413] + Tv[414] + Tv[415];
    Tv[420]:= Tv[417] + Tv[418] + Tv[419];
    Tv[428]:= Tv[425] + Tv[426] + Tv[427];
    Tv[432]:= Tv[429] + Tv[430] + Tv[431];
    Tv[436]:= Tv[433] + Tv[434] + Tv[435];
    Tv[440]:= Tv[437] + Tv[438] + Tv[439];
    Tv[444]:= Tv[441] + Tv[442] + Tv[443];
    Tv[448]:= Tv[445] + Tv[446] + Tv[447];
    Tv[452]:= Tv[449] + Tv[450] + Tv[451];
    Tv[456]:= Tv[453] + Tv[454] + Tv[455];
    Tv[460]:= Tv[457] + Tv[458] + Tv[459];
    Tv[464]:= Tv[461] + Tv[462] + Tv[463];
    Tv[472]:= Tv[469] + Tv[470] + Tv[471];
    Tv[476]:= Tv[473] + Tv[474] + Tv[475];

    Tv[421]:= Tv[413] + Tv[417];
    Tv[422]:= Tv[414] + Tv[418];
    Tv[423]:= Tv[415] + Tv[419];
    Tv[424]:= Tv[416] + Tv[420];
    Tv[465]:= Tv[421] + Tv[425] + Tv[429] + Tv[433] + Tv[437] + Tv[441] + Tv[445] + Tv[449] + Tv[453] + Tv[457] + Tv[461];
    Tv[466]:= Tv[422] + Tv[426] + Tv[430] + Tv[434] + Tv[438] + Tv[442] + Tv[446] + Tv[450] + Tv[454] + Tv[458] + Tv[462];
    Tv[467]:= Tv[423] + Tv[427] + Tv[431] + Tv[435] + Tv[439] + Tv[443] + Tv[447] + Tv[451] + Tv[455] + Tv[459] + Tv[463];
    Tv[468]:= Tv[424] + Tv[428] + Tv[432] + Tv[436] + Tv[440] + Tv[444] + Tv[448] + Tv[452] + Tv[456] + Tv[460] + Tv[464];
    Tv[477]:= Tv[469] + Tv[473];
    Tv[478]:= Tv[470] + Tv[474];
    Tv[479]:= Tv[471] + Tv[475];
    Tv[480]:= Tv[472] + Tv[476];

    // Page 12
    // Totals
    Tv[486]:= Tv[481] + Tv[482] + Tv[483] + Tv[484] + Tv[485];
    Tv[492]:= Tv[487] + Tv[488] + Tv[489] + Tv[490] + Tv[491];
    Tv[504]:= Tv[499] + Tv[500] + Tv[501] + Tv[502] + Tv[503];
    Tv[510]:= Tv[505] + Tv[506] + Tv[507] + Tv[508] + Tv[509];
    Tv[516]:= Tv[511] + Tv[512] + Tv[513] + Tv[514] + Tv[515];
    Tv[522]:= Tv[517] + Tv[518] + Tv[519] + Tv[520] + Tv[521];
    Tv[528]:= Tv[523] + Tv[524] + Tv[525] + Tv[526] + Tv[527];
    Tv[534]:= Tv[529] + Tv[530] + Tv[531] + Tv[532] + Tv[533];
    Tv[540]:= Tv[535] + Tv[536] + Tv[537] + Tv[538] + Tv[539];
    Tv[546]:= Tv[541] + Tv[542] + Tv[543] + Tv[544] + Tv[545];
    Tv[552]:= Tv[547] + Tv[548] + Tv[549] + Tv[550] + Tv[551];
    Tv[564]:= Tv[559] + Tv[560] + Tv[561] + Tv[562] + Tv[563];
    Tv[570]:= Tv[565] + Tv[566] + Tv[567] + Tv[568] + Tv[569];

    Tv[493]:= Tv[481] + Tv[487];
    Tv[494]:= Tv[482] + Tv[488];
    Tv[495]:= Tv[483] + Tv[489];
    Tv[496]:= Tv[484] + Tv[490];
    Tv[497]:= Tv[485] + Tv[491];
    Tv[498]:= Tv[486] + Tv[492];
    Tv[553]:= Tv[493] + Tv[499] + Tv[505] + Tv[511] + Tv[517] + Tv[523] + Tv[529] + Tv[535] + Tv[541] + Tv[547];
    Tv[554]:= Tv[494] + Tv[500] + Tv[506] + Tv[512] + Tv[518] + Tv[524] + Tv[530] + Tv[536] + Tv[542] + Tv[548];
    Tv[555]:= Tv[495] + Tv[501] + Tv[507] + Tv[513] + Tv[519] + Tv[525] + Tv[531] + Tv[537] + Tv[543] + Tv[549];
    Tv[556]:= Tv[496] + Tv[502] + Tv[508] + Tv[514] + Tv[520] + Tv[526] + Tv[532] + Tv[538] + Tv[544] + Tv[550];
    Tv[557]:= Tv[497] + Tv[503] + Tv[509] + Tv[515] + Tv[521] + Tv[527] + Tv[533] + Tv[539] + Tv[545] + Tv[551];
    Tv[558]:= Tv[498] + Tv[504] + Tv[510] + Tv[516] + Tv[522] + Tv[528] + Tv[534] + Tv[540] + Tv[546] + Tv[552];
    Tv[571]:= Tv[559] + Tv[565];
    Tv[572]:= Tv[560] + Tv[566];
    Tv[573]:= Tv[561] + Tv[567];
    Tv[574]:= Tv[562] + Tv[568];
    Tv[575]:= Tv[563] + Tv[569];
    Tv[576]:= Tv[564] + Tv[570];

    // Page 13
    // Totals
    Tv[582]:= Tv[577] + Tv[578] + Tv[579] + Tv[580] + Tv[581];
    Tv[588]:= Tv[583] + Tv[584] + Tv[585] + Tv[586] + Tv[587];
    Tv[600]:= Tv[595] + Tv[596] + Tv[597] + Tv[598] + Tv[599];
    Tv[606]:= Tv[601] + Tv[602] + Tv[603] + Tv[604] + Tv[605];
    Tv[612]:= Tv[607] + Tv[608] + Tv[609] + Tv[610] + Tv[611];
    Tv[618]:= Tv[613] + Tv[614] + Tv[615] + Tv[616] + Tv[617];
    Tv[624]:= Tv[619] + Tv[620] + Tv[621] + Tv[622] + Tv[623];
    Tv[630]:= Tv[625] + Tv[626] + Tv[627] + Tv[628] + Tv[629];
    Tv[636]:= Tv[631] + Tv[632] + Tv[633] + Tv[634] + Tv[635];
    Tv[642]:= Tv[637] + Tv[638] + Tv[639] + Tv[640] + Tv[641];
    Tv[648]:= Tv[643] + Tv[644] + Tv[645] + Tv[646] + Tv[647];
    Tv[654]:= Tv[649] + Tv[650] + Tv[651] + Tv[652] + Tv[653];
    Tv[666]:= Tv[661] + Tv[662] + Tv[663] + Tv[664] + Tv[665];
    Tv[672]:= Tv[667] + Tv[668] + Tv[669] + Tv[670] + Tv[671];

    Tv[589]:= Tv[577] + Tv[583];
    Tv[590]:= Tv[578] + Tv[584];
    Tv[591]:= Tv[579] + Tv[585];
    Tv[592]:= Tv[580] + Tv[586];
    Tv[593]:= Tv[581] + Tv[587];
    Tv[594]:= Tv[582] + Tv[588];
    Tv[655]:= Tv[589] + Tv[595] + Tv[601] + Tv[607] + Tv[613] + Tv[619] + Tv[625] + Tv[631] + Tv[637] + Tv[643] + Tv[649];
    Tv[656]:= Tv[590] + Tv[596] + Tv[602] + Tv[608] + Tv[614] + Tv[620] + Tv[626] + Tv[632] + Tv[638] + Tv[644] + Tv[650];
    Tv[657]:= Tv[591] + Tv[597] + Tv[603] + Tv[609] + Tv[615] + Tv[621] + Tv[627] + Tv[633] + Tv[639] + Tv[645] + Tv[651];
    Tv[658]:= Tv[592] + Tv[598] + Tv[604] + Tv[610] + Tv[616] + Tv[622] + Tv[628] + Tv[634] + Tv[640] + Tv[646] + Tv[652];
    Tv[659]:= Tv[593] + Tv[599] + Tv[605] + Tv[611] + Tv[617] + Tv[623] + Tv[629] + Tv[635] + Tv[641] + Tv[647] + Tv[653];
    Tv[660]:= Tv[594] + Tv[600] + Tv[606] + Tv[612] + Tv[618] + Tv[624] + Tv[630] + Tv[636] + Tv[642] + Tv[648] + Tv[654];
    Tv[673]:= Tv[661] + Tv[667];
    Tv[674]:= Tv[662] + Tv[668];
    Tv[675]:= Tv[663] + Tv[669];
    Tv[676]:= Tv[664] + Tv[670];
    Tv[677]:= Tv[665] + Tv[671];
    Tv[678]:= Tv[666] + Tv[672];

    // Page 1
    Tv[4]:= Tv[154]; // Copy to 101
    Tv[5]:= Tv[296] * (-1); // Note 1: If amount on line 390 is positive, report this amount as a negative on line 102. If amount on line 390 is negative, report this amount as a positive on line 102.
    Tv[6]:= Tv[297]; // Copy to 103
    Tv[7]:= Tv[347]; // Copy to 104
    Tv[8]:= Tv[348] * (-1); // Note 5: If amount on line 560 is positive, report this amount as a negative on line 105. If amount on line 560 is negative, report this amount as a positive on line 105.

    // 106
    // Note 2: An income inclusion per subsection 138(16) is to be entered as a positive amount on line 106. An income deduction per subsection 138(17) is to be entered as a negative amount on line 106.
    if (Tv[308] > 0) and (Tv[309] = 0) then
      Tv[9]:= Tv[308]
    else
    if (Tv[308] = 0) and (Tv[309] > 0) then
      Tv[9]:= Tv[309] * (-1)
    else
    if (Tv[308] > 0) and (Tv[309] > 0) then
      Tv[9]:= Tv[308] - Tv[309]
    else
      Tv[9]:= 0;

    // 107
    // Note 3: An income inclusion reversal per subsection 138(18) is to be entered as a negative amount on line 107. An income deduction reversal per subsection 138(19) is to be entered as a positive amount on line 107.
    if (Tv[310] > 0) and (Tv[311] = 0) then
      Tv[10]:= Tv[310]
    else
    if (Tv[310] = 0) and (Tv[311] > 0) then
      Tv[10]:= Tv[311] * (-1)
    else
    if (Tv[310] > 0) and (Tv[311] > 0) then
      Tv[10]:= Tv[310] - Tv[311]
    else
      Tv[10]:= 0;

    Tv[11]:= Tv[4] + Tv[5] + Tv[6] + Tv[7] + Tv[8] + Tv[9] + Tv[10]; // Calc 108
    Tv[13]:= Tv[11] + Tv[12]; // Calc 110
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250908 Igor <<<
//20250901 Igor >>>
procedure S151(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  //if Licenselevel <> llEnterprise then exit;

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    //20250101 CZ
    if Strings[414]<>'Y' then
    begin
     for i:=1 to 413 do begin Tv[i]:=0;end;
     SaveTv(RetNo,FName,FNo);
     Exit;
    end;

    FillHeader(RetNo, FNo, 1, 2, 3);
    // Page 1
    Tv[7]:= Tv[4] + Tv[5] + Tv[6];
    Tv[22]:= Tv[19] + Tv[20] + Tv[21];
    Tv[14]:= Tv[7] - Tv[8] + Tv[9] + Tv[10] - Tv[11] - Tv[12] + Tv[13];
    Tv[29]:= Tv[22] - Tv[23] + Tv[24] + Tv[25] - Tv[26] - Tv[27] + Tv[28];
    Tv[18]:= Tv[14] + Tv[15] + Tv[16] + Tv[17];
    Tv[32]:= Tv[29] + Tv[30] + Tv[31];
    // Page 2
    Tv[37]:= Tv[33] - Tv[34] - Tv[35] + Tv[36];
    Tv[42]:= Tv[38] - Tv[39] - Tv[40] + Tv[41];
    Tv[47]:= Tv[43] - Tv[44] - Tv[45] + Tv[46];
    Tv[52]:= Tv[48] - Tv[49] - Tv[50] + Tv[51];
    Tv[53]:= Tv[37] * 3;
    Tv[55]:= Tv[47] * 1;
    Tv[56]:= Tv[42] * 3;
    Tv[58]:= Tv[52] * 1;
    Tv[54]:= Tv[53] +  Tv[55];
    Tv[57]:= Tv[56] +  Tv[58];
    // Page 3 //20251114 Igor >>>
    Tv[64]:= Tv[59] +  Tv[60] + Tv[61] + Tv[62] +  Tv[63];
    Tv[94]:= Tv[89] +  Tv[90] + Tv[91] + Tv[92] -  Tv[93];
    Tv[124]:= Tv[119] +  Tv[120] + Tv[121] + Tv[122] +  Tv[123];
    Tv[154]:= Tv[149] +  Tv[150] + Tv[151] + Tv[152] -  Tv[153];
//    Tv[184]:= Tv[179] +  Tv[180] + Tv[181] + Tv[182] +  Tv[183];
//    Tv[215]:= Tv[209] +  Tv[210] + Tv[211] + Tv[212] -  Tv[214];
    Tv[74]:= Tv[65] +  Tv[66] + Tv[67] + Tv[68] +  Tv[69] +  Tv[70] + Tv[71] + Tv[72] +  Tv[73];
    Tv[134]:= Tv[125] +  Tv[126] + Tv[127] + Tv[128] +  Tv[129] +  Tv[130] + Tv[131] + Tv[132] +  Tv[133];
//    Tv[194]:= Tv[185] +  Tv[186] + Tv[187] + Tv[188] +  Tv[189] +  Tv[190] + Tv[191] + Tv[192] +  Tv[193];
    Tv[104]:= Tv[95] +  Tv[96] + Tv[97] + Tv[98] +  Tv[99] + Tv[100] + Tv[101] + Tv[102] -  Tv[103];
    Tv[164]:= Tv[155] +  Tv[156] + Tv[157] + Tv[158] + Tv[159] +  Tv[160] + Tv[161] + Tv[162] -  Tv[163];
//    Tv[225]:= Tv[216] +  Tv[217] + Tv[218] + Tv[219] + Tv[220] +  Tv[221] + Tv[222] + Tv[223] -  Tv[224];

    for i:= 179 to 194 do Tv[i]:= Tv[i - 120] + Tv[i - 60];
    for i:= 209 to 212 do Tv[i]:= Tv[i - 120] + Tv[i - 60];//20251120 Igor
    for i:= 214 to 225 do Tv[i]:= Tv[i - 121] + Tv[i - 61];//20251120 Igor

    // Page 4
    Tv[87]:= Tv[75] +  Tv[76] + Tv[77] + Tv[78] +  Tv[79] +  Tv[80] + Tv[81] + Tv[82] +  Tv[83] + Tv[84] + Tv[85] +  Tv[86];
    Tv[147]:= Tv[135] +  Tv[136] + Tv[137] + Tv[138] +  Tv[139] +  Tv[140] + Tv[141] + Tv[142] +  Tv[143] + Tv[144] + Tv[145] +  Tv[146];
//    Tv[207]:= Tv[195] +  Tv[196] + Tv[197] + Tv[198] +  Tv[199] +  Tv[200] + Tv[201] + Tv[202] +  Tv[203] + Tv[204] + Tv[205] +  Tv[206];
    Tv[117]:= Tv[105] +  Tv[106] + Tv[107] + Tv[108] +  Tv[109] + Tv[110] + Tv[111] + Tv[112] + Tv[113] + Tv[114] + Tv[115] -  Tv[116];
    Tv[177]:= Tv[165] +  Tv[166] + Tv[167] + Tv[168] + Tv[169] +  Tv[170] + Tv[171] + Tv[172] + Tv[173] + Tv[174] + Tv[175] -  Tv[176];
//    Tv[238]:= Tv[226] +  Tv[227] + Tv[228] + Tv[229] + Tv[230] +  Tv[231] + Tv[232] + Tv[233] + Tv[234] + Tv[235] + Tv[236] -  Tv[237];
    Tv[88]:= Tv[64] + Tv[74] + Tv[87];
    Tv[118]:= Tv[94] + Tv[104] + Tv[117];
    Tv[148]:= Tv[124] + Tv[134] + Tv[147];
    Tv[178]:= Tv[154] + Tv[164] + Tv[177];
//    Tv[208]:= Tv[184] + Tv[194] + Tv[207];
//    Tv[239]:= Tv[215] + Tv[225] + Tv[238];

    for i:= 195 to 208 do Tv[i]:= Tv[i - 120] + Tv[i - 60];
    for i:= 226 to 239 do Tv[i]:= Tv[i - 121] + Tv[i - 61];

    // Page 5 //20251114 Igor <<<
    Tv[259]:= Tv[29];
    Tv[247]:= Tv[241] + ((Tv[242] - Tv[243] + Tv[244]) * (Tv[245] / Tv[246]));
    Tv[266]:= Tv[260] + ((Tv[261] - Tv[262] + Tv[263]) * (Tv[264] / Tv[265]));
    Tv[256]:= (Tv[248] - Tv[249] - Tv[250] + Tv[251] + Tv[252] + Tv[253]) * (Tv[254] / Tv[255]);
    Tv[275]:= (Tv[267] - Tv[268] - Tv[269] + Tv[270] + Tv[271] + Tv[272]) * (Tv[273] / Tv[274]);
    Tv[257]:= MaxR(Tv[247], Tv[256]);
    Tv[276]:= MaxR(Tv[266], Tv[275]);
    Tv[258]:= Tv[240] + Tv[257];
    Tv[277]:= Tv[259] + Tv[276];
    Tv[278]:= 0.5 * (Tv[247] + Tv[266]);
    Tv[280]:= Tv[278] + Tv[279];
    // Page 6
    Tv[295]:= Tv[32];
    Tv[284]:= Tv[282] + Tv[283];
    Tv[298]:= Tv[296] + Tv[297];
    Tv[289]:= Tv[285] + Tv[286] + Tv[287] - Tv[288];
    Tv[303]:= Tv[299] + Tv[300] + Tv[301] - Tv[302];
    Tv[312]:= 0.075 * (Tv[304] + Tv[305] + Tv[306] + Tv[307] - Tv[308] - Tv[309]) + 0.5 * (Tv[310] + Tv[311]);
    Tv[315]:= 0.5 * (Tv[313] + Tv[314]);
    Tv[317]:= Tv[312] + Tv[315] + Tv[316];
    Tv[319]:= 0.5 * (Tv[290] + Tv[318]);
    Tv[320]:= Tv[312] + Tv[319];
    Tv[291]:= MaxR(Tv[284], Tv[289]);
    Tv[292]:= MaxR(Tv[284], Tv[289]);
    Tv[321]:= MaxR(Tv[298], Tv[303]);
    Tv[321]:= MaxR(Tv[321], Tv[317]);
    Tv[322]:= MaxR(Tv[298], Tv[303]);
    Tv[322]:= MaxR(Tv[322], Tv[320]);
    Tv[293]:= Tv[281] + Tv[291];
    Tv[323]:= Tv[295] + Tv[321];
    Tv[294]:= Tv[281] + Tv[292];
    Tv[324]:= Tv[295] + Tv[322];
    Tv[325]:= 0.5 * (Tv[293] + Tv[323]);
    if (Tv[325] < (Tv[294] + Tv[324])) then
      Tv[325]:= 0.5 * (Tv[294] + Tv[324]);
    Tv[327]:= Tv[325] + Tv[326];
    // Page 7
    Tv[355]:= Tv[352] + Tv[353] + Tv[354];
    Tv[337]:= Tv[336] * Tv[57] / Tv[54];
    Tv[339]:= MaxR(0, (Tv[337] - Tv[338]));
    Tv[340]:= Tv[32];
    Tv[357]:= 0.25 * Tv[356];
    Tv[341]:= 0.25 * Tv[312];
    Tv[342]:= Tv[341] + Tv[357];
    Tv[344]:= Tv[343] * Tv[57] / Tv[54];
    Tv[345]:= 0.08 * Tv[327];
    Tv[346]:= MaxR(Tv[344], Tv[345]);
    Tv[348]:= Tv[32];
    Tv[359]:= 0.25 * Tv[358];
    Tv[349]:= 0.25 * Tv[312];
    Tv[350]:= Tv[346] + Tv[359] + Tv[349];
    Tv[351]:= Tv[347] + Tv[359] + Tv[349];
    Tv[213]:= MaxR(Tv[350], Tv[351]); // (line 758 or 759 minus line 306) (cannot be less than 0)
    Tv[213]:= MaxR(0, (Tv[213] - Tv[64])); // (line 758 or 759 minus line 306) (cannot be less than 0)
    // Page 8
    Tv[382]:= Tv[370] * Tv[376];
    Tv[383]:= Tv[371] * Tv[377];
    Tv[384]:= Tv[372] * Tv[378];
    Tv[385]:= Tv[373] * Tv[379];
    Tv[386]:= Tv[374] * Tv[380];
    Tv[387]:= Tv[375] * Tv[381];
    Tv[388]:= MinR((Tv[382] + Tv[383] + Tv[384]), (Tv[385] + Tv[386] + Tv[387]));
    Tv[412]:= Tv[405] + Tv[406] + Tv[407] + Tv[408] + Tv[409] + Tv[410] +  Tv[411];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20250901 Igor <<<

//20251117 Igor >>>
procedure S74(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
  ArrayNumber: Integer;
  RowCount: Integer;
  Elm: Integer;
  x130, x135, x140, x145d, x150, x160, x155, x165, x170, x175, x180, Total_T1: double;
  x615, x620, x625, x630, x635, x640, Total_T2: double;
  x740, x745, x750, x755, Total_T3: double;
begin
  //if Licenselevel <> llEnterprise then exit;

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    //Page 1
    Strings[5]:= ifthen((Strings[5] <> '') and (length(Strings[5]) > 2), Copy(Strings[5], 1, 2), Strings[5]); //20251120 Igor

    // Page 2
    for ArrayNumber:= 1 to 3 do
    begin
      BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);

      for i:= 0 to pred(RowCount) do
      begin
        Elm:= (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, IntToStr(succ(i)));

        if (ArrayNumber = 1) then
        begin
          Elm:= (ArrayNumber * 10000 + 11) + i * BoxesPerRow;
          StoreElmFNo(RetNo, FNo, Elm, IntToStr(succ(i)));
        end;
      end;
    end;

    //Calculation by dyn table 1
    for ArrayNumber:= 1 to 1 do
    begin
      BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);
      Total_T1:= 0;

      for i:= 0 to pred(RowCount) do
      begin
        //Get values from the calls of dynamic table 1 for next calculations
        Elm:= (ArrayNumber * 10000 + 7) + i * BoxesPerRow;
        x130:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
        x135:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 9) + i * BoxesPerRow;
        x140:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 4) + i * BoxesPerRow; //20251120 Igor
        Strings[Elm]:= ifthen((Strings[Elm] <> '') and (length(Strings[Elm]) > 2), Copy(Strings[Elm], 1, 2), Strings[Elm]); //20251120 Igor

        //Filling column 1I
        Elm:= (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, ifThen(RoundTo(x130 - x135 + x140, -2) = 0, '', ifThen(RoundTo(x130 - x135 + x140, -2) < 0, '0', FormatFloat('########.##', x130 - x135 + x140)) ));

        //Get values from the calls of dynamic table 1 for next calculations
        Elm:= (1 * 10000 + 10) + i * BoxesPerRow;
        x145d:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 2) + i * BoxesPerRow;
        x150:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        x155:= RoundTo(x145d * (x150 / 100), -2);

        //Filling column 1I
        Elm:= (ArrayNumber * 10000 + 13) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, ifThen(RoundTo(x155, -2) = 0, '', ifThen(RoundTo(x155, -2) < 0, '0', FormatFloat('########.##', x155)) ));

        //Get values from the calls of dynamic table 1 for next calculations
        Elm:= (ArrayNumber * 10000 + 14) + i * BoxesPerRow;
        x160:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 15) + i * BoxesPerRow;
        x165:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 16) + i * BoxesPerRow;
        x170:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 17) + i * BoxesPerRow;
        x175:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        x180:= RoundTo( (x155 * (x160 / 100) * (x170 / 100)) + (x155 * (x165 / 100) * (x175 / 100)), -2);
        Total_T1:= Total_T1 + x180;

        //Filling column 1I
        Elm:= (ArrayNumber * 10000 + 18) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, ifThen(RoundTo(x180, -2) = 0, '', ifThen(RoundTo(x180, -2) < 0, '0', FormatFloat('########.##', x180)) ));
      end;
    end;

    Tv[14]:= Total_T1;
    Tv[16]:= Tv[14] + Tv[15];

    //Page 3
    if (Strings[17] = '') then Strings[17]:= FetchElm(RetNo, 'T2', 742);
    if (Strings[18] = '') then Strings[18]:= FetchElm(RetNo, 'T2', 743);
    if (Strings[19] = '') then Strings[19]:= FetchElm(RetNo, 'T2', 744);
    if (Strings[21] = '') then Strings[21]:= FetchElm(RetNo, 'T2', 755) + ' ' + FetchElm(RetNo, 'T2', 746);

    Tv[26]:= Tv[25] * 20;
    Tv[29]:= (Tv[27] - Tv[28]) * 50; //20251204 Igor  //Tv[29]:= (Tv[27] - Tv[25]) * 50;
    Tv[31]:= Tv[26] + Tv[29] + Tv[30];

    //Page 5
    //Calculation by dyn table 2
    for ArrayNumber:= 2 to 2 do
    begin
      Total_T2:= 0;
      BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);

      for i:= 0 to pred(RowCount) do
      begin
        Elm:= (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        x615:= Vl(FetchElmFNo(RetNo, FNo, Elm)); //D col
        Elm:= (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
        x620:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 7) + i * BoxesPerRow;
        x625:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
        x630:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        x635:= RoundTo(x615 - x620, -2);
        x640:= RoundTo((x635 * x625) / x630, -2);
        Total_T2:= Total_T2 + x640;

        Elm:= (ArrayNumber * 10000 + 4) + i * BoxesPerRow; //20251120 Igor
        Strings[Elm]:= ifthen((Strings[Elm] <> '') and (length(Strings[Elm]) > 2), Copy(Strings[Elm], 1, 2), Strings[Elm]); //20251120 Igor

        Elm:= (ArrayNumber * 10000 + 9) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, ifThen(RoundTo(x635, -2) = 0, '', ifThen(RoundTo(x635, -2) < 0, '0', FormatFloat('########.##', x635)) ));

        Elm:= (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, ifThen(RoundTo(x640, -2) = 0, '', ifThen(RoundTo(x640, -2) < 0, '0', FormatFloat('########.##', x640)) ));
      end;
    end;
    Tv[60]:= Total_T2;
    Tv[62]:= Tv[60] + Tv[61];

    //Page 6
    //Calculation by dyn table 3
    for ArrayNumber:= 3 to 3 do
    begin
      Total_T3:= 0;
      BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);

      for i:= 0 to pred(RowCount) do
      begin
        Elm:= (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        x740:= Vl(FetchElmFNo(RetNo, FNo, Elm)); //D col
        Elm:= (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
        x745:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 7) + i * BoxesPerRow;
        x750:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        x755:= RoundTo((x740 * x745) - x750, -2);
        Total_T3:= Total_T3 + x755;

        Elm:= (ArrayNumber * 10000 + 4) + i * BoxesPerRow; //20251120 Igor
        Strings[Elm]:= ifthen((Strings[Elm] <> '') and (length(Strings[Elm]) > 2), Copy(Strings[Elm], 1, 2), Strings[Elm]); //20251120 Igor

        Elm:= (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, ifThen(RoundTo(x755, -2) = 0, '', ifThen(RoundTo(x755, -2) < 0, '0', FormatFloat('########.##', x755)) ));
      end;
    end;
    Tv[69]:= Total_T3;
    Tv[71]:= Tv[69] + Tv[70];
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251117 Igor <<<

end.



(* s8 bfr IMMEXPENSE
  //20220619
  procedure S8(RetNo: integer;FName: string;FNo: integer);
  Var i,k,K1:integer;
  FInst :String;
  S8FNo:Integer;
  Cls,s,S1,S2:String;
  OriginalCost:Real;
  UccStart,Additions,Adjustments,Proceeds,UCC,HalfRuleAmount,UCCReduced:Real;
  OverrideIndic,HalfYearIndic,TermLossIndic: String;
  Rate:String;
  Recapture, TerminalLoss,CCA,UCCEnd:Real;
  DaysInTaxYear:Integer; // > 365 then DaysInTaxYear := 365;
  //cls 13 relted
  AssetInfo: String;
  //additional fields after aiip
  Aiip:Boolean;
  AdditionsAiip, AssistanceReceived, RepaidAmount,
  ProceedsAiip,NetCapCostAdditionsAiip,UccAdjustmentAiip, UccAdjustmentNONAiip:Real;
  Aiipfactor:String;

  OverrideBox,HalfRuleBox,TerminalLossBox:String;
  HalfYearAmount:Real;

  LeaseStart,LeaseEnd: string; LeaseTerm:Real; LeaseAdjustedCost:Real; // RemainingLeaseTerm:Real;
  PurchaseDate:String;
  LeaseMaxCca:Real;
  x:real;
  y:Real;
  begin
  x:=Vl(FetchElm(RetNo,FNo,232));   //20220618
  DaysInTaxYear:=Ret[RetNo].DaysInYear;
  If DaysInTaxYear > 365 then DaysInTaxYear := 365;

  FInst := ExtractFormInst(FName);
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  FillHeader(RetNo,FNo,1,2,3);
  If Strings[4]+Strings[5] = '' then Strings[5] := 'X';

  //INIT Totals //20190614
  Tv[249]:=0;Tv[234]:=0;Tv[250]:=0;Tv[235]:=0;
  Tv[230]:=0;Tv[231]:=0;Tv[232]:=0;Tv[251]:=0;

  for I:=384 to 396 do Strings[i]:='';  //initialize the botom classes, then copy them //20190705

  for k:=0 to 12 do  //k=01 etc to pick up the right row
  Begin
  Cls:=AllTrim(Strings[6+k*16]);  //20190719 //alltrim
  Strings[384+k*1]:=Cls; //20190705
  Rate:=GetCCARate(Cls);  //string //20190614
  //20190605
  If UpperCase(Strings[14+k*16])='O' then Strings[14+k*16]:='Y'; //override
  If UpperCase(Strings[15+k*16])='H' then Strings[15+k*16]:='Y';  //half year
  if vl(Rate)=100 then Strings[15+k*16]:='N';  //20190614 No half year rule for fast write off //20190614
  If UpperCase(Strings[16+k*16])='T' then Strings[16+k*16]:='Y';  //Term loss

  If UpperCase(Strings[14+k*16])='X' then Strings[14+k*16]:='Y'; //override
  If UpperCase(Strings[15+k*16])='X' then Strings[15+k*16]:='Y';  //half year
  If UpperCase(Strings[16+k*16])='X' then Strings[16+k*16]:='Y';  //Term loss

  OriginalCost:=Tv[371+k*1];
  AssetInfo:=Strings[236+k*1];

  UccStart:=Tv[7+k*16];
  Additions:=Tv[8+k*16];
  Adjustments:=Tv[9+k*16];

  Tv[10+k*16]:=MaxR(0,Tv[10+k*16]);  //20220621
  Proceeds:=Tv[10+k*16];

  if (LeaseHold(Cls)) and (UCCStart>0) Then begin Additions:=0;Tv[8+k*16]:=0;end;  //do not allow additions to 13 //20190705
  //20190809  accept yyymmdd in case they entered yyyy/mm/dd
  If (Cls>'') then
  begin
  if Not LeaseHold(Cls) then
  Begin
  //replace yyymmdd with yyy/mm/dd for date
  s:=LeftStr(Strings[236+k*1],8);
  if (Length(s)=8) and (Numeric(s)) then
  Strings[236+k*1]:=LeftStr(s,4)+'/'+MidStr(S,6,2)+'/'+RightStr(s,2);
  End
  Else //leasehold //cls='13')
  Begin
  s:=Strings[236+k*1];
  s:=RemoveChar(s,'/');
  s:=RemoveChar(s,'-');
  s:=LeftStr(s,16);
  if (Length(s)=16) and (Numeric(s)) then
  Begin
  s1:=LeftStR(S,8);  //from date
  S1:=LeftStr(s1,4)+'/'+MidStr(S1,5,2)+'/'+RightStr(s1,2);
  S2:=RightStr(S,8); //to date
  S2:=LeftStr(s2,4)+'/'+MidStr(S2,5,2)+'/'+RightStr(s2,2);
  Strings[236+k*1]:=S1+'-'+S2;
  End;
  End;
  end;


  //AIIP indicator//20190621
  //20190705
  Strings[356+k*1]:='';
  if (Additions>0) and (Cls>'') then
  Begin
  s:=ReplaceChar(AssetInfo,',','');
  PurchaseDate:=LeftStr(S,10);
  if (PurchaseDate>'2018/11/20')
  or (GetTaxationYearStart(RetNo)>'2018/11/20') //20220619 additions made after the Aiip date of 2018
  then
  Strings[356+k*1]:='X'  //then 10.1 is aiip
  Else
  Strings[356+k*1]:='';  //20190705
  end;

  if (GetTaxationYearEnd(RetNo)>'2027/12/31') then Strings[356+k*1]:='';  //NO AIIP after 2027? Check it then IF ALIVE! //20190704
  If Strings[356+k*1]>'' then Aiip:=True else Aiip:=False;   //20190614
  if cls='56' then Begin  Aiip:=False;Strings[356+k*1]:='';end;  //20220531

  //20190607
  if (Aiip=False) and (cls>'') then
  Begin
  If Strings[15+k*16]='' then Strings[15+k*16]:='Y';  //20190605 half yer rule by default
  End;
  if Aiip=True then Strings[15+k*16]:='';    //20190614 in O-H-T
  If (cls='24')  or (cls='27') or(cls='29') or (cls='34') then Strings[15+k*16]:=''; //fast write off NO half year rule

  OverrideIndic:=UpperCase(Strings[14+k*16]);
  HalfYearIndic:=UpperCase(Strings[15+k*16]);
  TermLossIndic:=UpperCase(Strings[16+k*16]);

  If Uppercase(OverrideIndic) <> 'Y' then Rate:=GetCCARate(Cls);

  //Inpout validations
  if Cls='10.1' then  //20190622
  Begin
  if PurchaseDate < GetTaxationYearStart(RetNo) then Tv[8+k*16]:=0; //no additions allowed
  End;

  If (Aiip=False)
  and (cls<>'56') //20220531
  then Tv[252+k*1]:=0;  //aiip portion of col 3

  AdditionsAiip:=Tv[252+k*1];
  //assistance part of col 5
  // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
  Tv[265+k*1]:=MaxR(0,Tv[265+k*1]);   //20220621
  AssistanceReceived:=Tv[265+k*1];
  //repaid part of col 5
  //If Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=Tv[9+k*16]; //repaid   //20220621
  Tv[278+k*1]:=MaxR(0,Tv[278+k*1]);   //20220621
  RepaidAmount:=Tv[278+k*1];
  {
  //both
  If Tv[9+k*16]>0 then  //20220621
  Begin
  If Tv[265+k*1] + Tv[278+k*1]>Tv[9+k*16] then Tv[278+k*1]:=0;  //one has to go
  end;
  }

  //aiip  related
  If Aiip=False then
  Begin
  Tv[291+k*1]:=0;
  Tv[304+k*1]:=0;
  Tv[343+k*1]:=0;
  Tv[317+k*1]:=0;
  Tv[330+k*1]:=0;
  End;
  if Aiip=True then  //20190705
  Begin
  //fast write off //20190608
  if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then
  Begin
  Tv[8+k*16]:=0; //additions
  End;


  //20210328
  // Aiipfactor
  AiipFactor:='';
  Strings[343+k*1]:='';
  if Cls='' then Aiipfactor:=''; //20190622
  if Aiip=False then Aiipfactor := '';  //default

  if cls = '43.1' then Aiipfactor := '2.33333'
  Else if Cls = '43.2' then Aiipfactor := '1'
  Else if Cls = '53' then Aiipfactor := '1'

  Else if (Cls = '54') then
  Begin
  if Strings[236+k] > '2019/03/18' then
  begin
  Strings[356+k] := 'X';
  Aiipfactor := '2.33333333';
  end
  Else If Strings[236+k] > '2018/11/20' then
  begin
  Strings[356+k] := 'X';
  Aiipfactor := '0.5';
  end;
  End
  Else if (Cls = '55') and (Strings[236+k] > '2019/03/18') then Aiipfactor := '1.5'
  Else if (Cls = '56') then Aiipfactor := '2.333331'    //20210927
  Else if (cls='12') or (Leasehold(cls)) or (cls='14') or (cls='15') then Aiipfactor:=''  //20190806
  Else  Aiipfactor := '0.5';

  if cls='' then begin AiipFactor:='';Strings[343+k*1]:='';end;
  End;
  Strings[343+k*1]:=AiipFactor;

  ProceedsAiip:=Tv[291+k*1];

  HalfRuleAmount:=0;
  UCC:=0;
  UCCReduced:=0;
  Recapture:=0;
  TerminalLoss:=0;


  //get lease and orinal cost from decr box
  If Leasehold(cls) then //if Cls='13' then
  begin
  LeaseTerm:=5; //Default;
  //for class 13: 1234567890-1234567890
  s:=ReplaceChar(AssetInfo,',','');
  LeaseStart:=LeftStr(S,10);
  LeaseEnd:=MidStr(S,12,10);
  if (Length(LeaseStart)<>10) or (Length(LeaseEnd)<>10) then
  LeaseTerm :=0
  Else
  begin
  LeaseTerm := DateDiffYMD(LeaseStart,LeaseEnd) div 365;
  If (LeaseTerm>0) and (LeaseTerm<5) then LeaseTerm :=5;
  End;
  LeaseMaxCCA:=OriginalCost/LeaseTerm;  //20190611
  Rate:=FormatFloat('####.##',100/LeaseTerm);      //20190601
  Strings[17*k*16]:=Rate;
  end;

  if Cls = '' then
  begin
  UCC := 0;
  HalfRuleAmount := 0;
  UccReduced := 0;
  Recapture := 0;
  TerminalLoss := 0;
  CCA := 0;
  UCCEnd := 0;
  end;

  Ucc := UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount - Proceeds; //20190606pm
  if (Cls='10.1') and (Proceeds>0) then UCC:=UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount; //20190820 Get the CCA on disposal

  If LeaseHold(Cls) then //if cls='13' then //20190611
  Begin
  LeaseAdjustedCost:=OriginalCost-UccStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
  UccReduced:=UCCStart + Additions + Adjustments - AssistanceReceived + RepaidAmount;
  End;

  if AiiP=False then  //20190706
  Begin
  if UpperCase(HalfYearIndic) = 'Y' then   ////20190605
  begin
  if UpperCase(OverrideIndic) <> 'Y' then  //20190605
  begin
  HalfRuleAmount := MaxR(0, 0.5 * (Additions-AssistanceReceived+RepaidAmount-Proceeds));
  if LeaseHold(Cls) then HalfRuleAmount := MaxR(0, 0.5 * (Additions-Proceeds)); //20190613
  HalfRuleAmount := RoundCorrect(HalfRuleAmount);
  end;
  end
  else
  HalfRuleAmount := 0;
  //from below  //20220619
  if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34')  //fast write off //20190622
  then UccAdjustmentNONAiip:=0; //20190622
  UCCReduced := UCC - HalfRuleAmount;
  if LeaseHold(Cls) then UccReduced:=UCC;  //20190611
  ProceedsAiip:=0;
  NetCapCostAdditionsAiip:=0;
  UccAdjustmentAiip:=0;
  end   //20220619

  Else  //If (Aiip=True) then
  Begin
  HalfRuleAmount:=0;   //20190608
  //20190707
  ProceedsAiip:=MaxR(0,Proceeds+AssistanceReceived-Additions+AdditionsAiiP-RepaidAmount);
  NetCapCostAdditionsAiip:=MaxR(0,AdditionsAiip-ProceedsAiip);
  if (cls='10.1') and (Proceeds>0) then NetCapCostAdditionsAiip:=AdditionsAiip;

  UccAdjustmentAiip:=NetCapCostAdditionsAiip*vl(AiipFactor);
  UccAdjustmentNONAiip:=MaxR(0,0.5 * (Additions-AdditionsAiip-AssistanceReceived+RepaidAmount-Proceeds)); //20190622 moved from below

  if (CLS='12') OR (CLS='52') Or (cls='24')  or (cls='27') or(cls='29') or (cls='34') then UccAdjustmentNONAiip:=0; //20190622  //fast write off //20190622

  UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount-Proceeds;
  if (cls='10.1') and (Proceeds>0) then UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount; //without proceeds //20220619
  //UCCReduced:=ucc;

  End; //20220619
  //put amounts on the S8 form
  Tv[12+k*16]:=HalfRuleAmount;
  if AiiP then Tv[12+k*16]:=0;   //remove half ruleamount
  Tv[11+k*16]:=UCCReduced;
  Strings[17+k*16]:=Rate;

  Tv[291+k*1]:=ProceedsAiip; //UccAdjustmentNONAiip;
  Tv[304+k*1]:=NetCapCostAdditionsAiip;
  Strings[343+k*1]:=AiipFactor;
  if Cls='' then Strings[343+k*1]:='';

  Tv[317+k*1]:=UccAdjustmentAiip;
  If Cls>'' then Tv[330+k*1]:=UccAdjustmentNONAiip;  //20190622

  //cca calcs
  if UCCReduced < 0 then
  begin
  CCA := 0;
  TerminalLoss := 0;
  Recapture := ABS(UCCReduced);
  if Cls = '10.1' then Recapture:=0;
  end
  else  //positive ucc = CCA or Terminal loss upon disposal
  begin
  TerminalLoss := 0;
  Recapture := 0;

  //20190313
  if Aiip then
  CCA:=Round((UCCReduced+UccAdjustmentAiip-UccAdjustmentNONAiip) * Vl(Rate)/100)
  else
  CCA:=Round(UCCReduced * Vl(Rate) / 100);

  if (LeaseHold(Cls)) and (AIIP=False) then  //20190613
  CCA := MinR(UCCReduced, LeaseMaxCCA);

  if (Leasehold(Cls)) then
  Begin
  If (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
  then
  CCA:=Round(CCA/2); //20190705
  end;

  If (LeaseHold(Cls)) Then  //20190725
  Begin
  If (Aiip=true)
  and (LeftStr(LeaseStart,4)=LeftStr(GetBegYearEnd(RetNo),4))
  and (AdditionsAiip>0)
  then  CCA:=CCA *3; //first year  //20190725
  end;


  if (cls='24')  or (cls='27') or(cls='29') or (cls='34') then CCA:=UccReduced; //fast wrire offs 20190609
  if (cls='12') then CCA:=UccReduced; //20210623

  //20210726
  if (isLeapYear(GetTaxationYearEndYYYY(RetNo))
  and (GetTaxationYearEnd(RetNo)>'2020/02/28')) then
  CCA:=CCA * Ret[RetNo].DaysInYear / 366
  Else
  CCA:=CCA * Ret[RetNo].DaysInYear / 365;

  if (cls='12') or (cls='24')  or (cls='27') or(cls='29') or (cls='34') then CCA:=UccReduced; //fast wrire offs 20210623

  if OverrideIndic='Y' then CCA:=Tv[20+k*16];

  if TermLossIndic='Y' then
  Begin
  TerminalLoss:=UccReduced+UCCAdjustmentNONAIIp; //20190626    //TerminalLoss:=UccReduced;
  Tv[19+k*16]:=TerminalLoss;
  Recapture:=0;
  Tv[18+k*16]:=0;
  CCA:=0;
  UccEnd :=0;
  End;


  UccEnd := MaxR(0, UCCReduced - CCA);

  if AiiP=False then
  UccEnd:=MaxR(0,UCCReduced-CCA+HalfRuleAmount)        //20190622
  Else //Aiip is true
  Begin
  UccEnd:=MaxR(0,UccReduced-CCA); //20220618//+UCCAdjustmentNONAIIp-UCCAdjustmentAIIp);  //20190707
  //If Cls='10.1' then UccEnd:=MaxR(0,UCCReduced-CCA-UCCAdjustmentNONAIIp);  //20190707  //2022017
  end;
  end;
  if (cls = '10.1') then begin TerminalLoss := 0;Recapture := 0;end; //20190607

  if (cls = '10.1') and (proceeds > 0)
  and (OverrideIndic<>'Y')   //20220619
  then
  begin
  CCA := Round(CCA/2);
  UccEnd := 0;
  end;

  //20190626
  if (Recapture>0) or (TerminalLoss>0) then UCcEnd:=0;

  Tv[20+k*16]:=CCA;
  Tv[21+k*16]:=UccEnd;
  Tv[18+k*16]:=Recapture;
  Tv[19+k*16]:=TerminalLoss;

  //add to totals //20190614
  Tv[249]:=Tv[249]+uccStart;
  Tv[234]:=Tv[234]+Additions;
  Tv[250]:=Tv[250]+Adjustments;
  Tv[235]:=Tv[235]+Proceeds;

  Tv[230]:=Tv[230]+Recapture;
  Tv[231]:=Tv[231]+TerminalLoss;
  Tv[232]:=Tv[232]+CCA;
  Tv[251]:=Tv[251]+UccEnd;

  End; //k 0 to 12
  End; //with?
  SaveTv(RetNo,FName,FNo);
  y:=Vl(fetchElmFNo(RetNo,FNo,232));
  end;
*)


(*
//20260501 Alex >>>
procedure S8(RetNo: integer; FName: string; FNo: integer);
// columns first row index

{
 //20260519
Const
  col1 = 6;
  col2 = 7;
  col3 = 8;
  col4 = 463;
  col5 = 9;
  col6 = 265;
  col7 = 278;
  col8 = 10;
  col9 = 400;
  col10 = 11;
  col11 = 424;
  col12 = 437;
  col13 = 450;
  col14 = 252;
  col15 = 476;
  col16 = 291;
  col17 = 304;
  col18 = 317;
  col19 = 330;
  col20 = 17;
  col21 = 18;
  col22 = 19;
  col23 = 20;
  col24 = 21;
}
Var
  i,j, k, K1: integer;
  FInst: String;
  S8FNo: integer;
  Cls, s, S1, S2: String;
  TotColumn4: Real;
  OriginalCost: Real;
  UccStart, Additions, Adjustments, Proceeds, UCC, HalfRuleAmount,
    UCCReduced: Real;

  ImmediateExpensing: Real; // 20220730

  OverrideIndic, HalfYearIndic, TermLossIndic: String;
  Rate: String;
  Recapture, TerminalLoss, CCA, UCCEnd, z: Real;
  DaysInTaxYear: integer; // > 365 then DaysInTaxYear := 365;
  // cls 13 relted
  AssetInfo: String;
  // additional fields after aiip
  Aiip: Boolean;
  Diep:Boolean;   //20231017
  AdditionsAiip, AssistanceReceived, RepaidAmount, ProceedsAiip,
    NetCapCostAdditionsAiip, UccAdjustmentAiip, UccAdjustmentNONAiip: Real;
  Aiipfactor: String;

  OverrideBox, HalfRuleBox, TerminalLossBox: String;
  HalfYearAmount: Real;

  LeaseStart, LeaseEnd: string;
  LeaseTerm: Real;
  LeaseAdjustedCost: Real; // RemainingLeaseTerm:Real;
  PurchaseDate: String;
  LeaseMaxCca: Real;
  x: Real;
  y: Real;
  lTotalValof_19: Currency; //20260501 Alex
  lTotalValof_20: Currency; //20260501 Alex
  lTotalValof_21: Currency; //20260501 Alex
  //20260519 Alex >>>
  lCol1: Integer;
  lCol2: Integer;
  lCol3: Integer;
  lCol4: Integer;
  lCol5: Integer;
  lCol6: Integer;
  lCol7: Integer;
  lCol8: Integer;
  lCol9: Integer;
  lCol10: Integer;
  lCol11: Integer;
  lCol12: Integer;
  lCol13: Integer;
  lCol14: Integer;
  lCol15: Integer;
  lCol16: Integer;
  lCol17: Integer;
  lCol18: Integer;
  lCol19: Integer;
  lCol20: Integer;
  lCol21: Integer;
  lCol22: Integer;
  lCls: string;
  //20260519 Alex <<<
begin
  //x:= Vl(FetchElm(RetNo, FNo, 232)); // 20220726
  DaysInTaxYear:= Ret[RetNo].DaysInYear;
  if DaysInTaxYear > 365 then DaysInTaxYear:= 365;
  S8FNo:= GetFormNo('S8#1'); // 20220826
  FInst:= ExtractFormInst(FName);

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    Strings[227]:=S8ApplicableVersion; //230260531 //'2026/05/31'; //Date Form after wich it was saved with the new format
    if Strings[4] + Strings[5] = '' then Strings[5] := 'X';

    //New calculation 2026 year. //20260519 Alex >>>
    lTotalValof_19:= 0;
    lTotalValof_20:= 0;
    lTotalValof_21:= 0;
    i:= 7;
    repeat
      lCol1:= i - 1;
      lCol2:= i;
      lCol3:= i + 1;
      lCol4:= i + 2;
      lCol5:= i + 3;
      lCol6:= i + 4;
      lCol7:= i + 5;
      lCol8:= i + 6;
      lCol9:= i + 7;
      lCol10:= i + 8;
      lCol11:= i + 9;
      lCol12:= i + 10;
      lCol13:= i + 11;
      lCol14:= i + 12;
      lCol15:= i + 13;
      lCol16:= i + 14;
      lCol17:= i + 15;
      lCol18:= i + 16;
      lCol19:= i + 17;
      lCol20:= i + 18;
      lCol21:= i + 19;
      lCol22:= i + 20;
      lCls:= Strings[lCol1];

      Tv[lCol10]:= Tv[lCol2] + Tv[lCol3] + Tv[lCol6] - Tv[lCol9]; // Column 10
      Tv[lCol11]:= MaxR(0, Tv[lCol7] + Tv[lCol9] - Tv[lCol3] + Tv[lCol4] + Tv[lCol5] - Tv[lCol8]); // Column 11
      Tv[lCol12]:= MaxR(0, Tv[lCol4] - Tv[lCol11]); // Column 12
      Tv[lCol13]:= MaxR(0, Tv[lCol11] - Tv[lCol4]); // Column 13
      Tv[lCol14]:= MaxR(0, Tv[lCol5] - Tv[lCol13]); // Column 14
      // Column 15
      {if lCls.Equals('43.1') or lCls.Equals('54') or lCls.Equals('56') then Tv[lCol15]:= Tv[lCol12] * (3/2) else //If available in the 2024 or 2025 years
      if lCls.Equals('55') then Tv[lCol15]:= Tv[lCol12] * (7/8) else //If available in the 2024 or 2025 years
      if lCls.Equals('43.2') or lCls.Equals('44') or (Strings[i - 1]).Equals('53.3') then Tv[lCol15]:= Tv[lCol12] * (1/2) else //If available after April 15, 2024
      if lCls.Equals('46') then Tv[lCol15]:= Tv[lCol12] * (7/3) else //If available after April 15, 2024
      if lCls.Equals('50') then Tv[lCol15]:= Tv[lCol12] * (9/11) else //If available after April 15, 2024
      if lCls.Equals('12') or lCls.Equals('13') or lCls.Equals('14') or lCls.Equals('15') or lCls.Equals('59') then Tv[lCol15]:= Tv[lCol12] * (0) else //If available after 2026 year
      Tv[lCol15]:= Tv[lCol12] * (0);
      // Column 16
      if lCls.Equals('43.1') or lCls.Equals('54') or lCls.Equals('56') then Tv[lCol16]:= Tv[lCol14] * (7/3) else //If available until 2030 year
      if lCls.Equals('55') then Tv[lCol16]:= Tv[lCol14] * (3/2) else //If available until 2030 year
      if lCls.Equals('53') then Tv[lCol16]:= Tv[lCol14] * 1 else //If available until 2030 year
      if lCls.Equals('43') then Tv[lCol16]:= Tv[lCol14] * (4/3) else //If available until 2030 year
      if lCls.Equals('44') then Tv[lCol16]:= Tv[lCol14] * 3 else //If available until 2027 year or 0 if it became available for use after 2026
      if lCls.Equals('46') then Tv[lCol16]:= Tv[lCol14] * (7/3) else //If available until 2027 year or 0 if it became available for use after 2026
      if lCls.Equals('50') then Tv[lCol16]:= Tv[lCol14] * (9/11) else //If available until 2027 year or 0 if it became available for use after 2026
      if lCls.Equals('12') or lCls.Equals('14') or lCls.Equals('14') or lCls.Equals('15') or lCls.Equals('59') then Tv[lCol16]:= Tv[lCol14] * (0) else //If available after 2026 year
      Tv[lCol16]:= Tv[lCol14] * (0.5);
      }
      {
      Tv[lCol17]:= MaxR(0, 0.5 * Tv[lCol3] - Tv[lCol4] - Tv[lCol5] + Tv[lCol8] - Tv[lCol7] - Tv[lCol9]); // Column 17 //(0.5 multiplied by the result of column 3 minus column 4 minus column 5 plus column 8 minus column 7 minus column 9)
      // Column 19
      if not lCls.Equals('10.1') and (Tv[lCol10] < 0) then Tv[lCol19]:= Abs(Tv[lCol10]) else Tv[lCol19]:= 0; //Enter the negative amount from column 10 in column 19 as a positive. The recapture rules do not apply to passenger vehicles in Class 10.1.
      // Column 20
      if not lCls.Equals('10.1') and not lCls.Equals('14') and not lCls.Equals('14.1') and (Tv[lCol10] > 0) then Tv[lCol20]:= Abs(Tv[lCol10]) else Tv[lCol20]:= 0; //enter the positive amount from column 10 in column 20.
      //The terminal loss rules do not apply to: Class 10.1, 14.1, 14.
      Tv[lCol18]:= Vl(GetCCARate(lCls)); //20260519 Alex

      if DaysInTaxYear < 365 then
        Tv[lCol21]:= ((Tv[lCol10] + Tv[lCol15] + Tv[lCol16] - Tv[lCol17]) * (Tv[lCol18] / 100)) * (DaysInTaxYear / 365) // Column 21 //If the tax year is shorter than 365 days, prorate the CCA claim.//20260519 Alex
      else
        Tv[lCol21]:= (Tv[lCol10] + Tv[lCol15] + Tv[lCol16] - Tv[lCol17]) * (Tv[lCol18] / 100); // Column 21 //20260519 Alex
      // Column 22
      Tv[lCol22]:= Tv[lCol10] - Tv[lCol21];

      //----------------------------------------
      //20260519cz   thre are dispositions
      Tv[lCol19]:=0; //init recapture
      Tv[lCol20]:=0; //init terminal loss
      if (Tv[lCol9]>0) then //and lCls.Equals('10.1') then //NO DISPOSITIONS
      Begin
       If (Tv[lCol10]>0) then  //terminal loss
       begin
        Tv[lCol20]:= ABS(Tv[lCol10]);  //recapture
        Tv[lCol21]:=0; //cca zero
        Tv[lCol22]:=0;
       end
       Else  //recapture
       Begin
        Tv[lCol19]:= ABS(Tv[lCol10]);
        Tv[lCol21]:=0; //cca zero
        Tv[lCol22]:= 0;
       end;
      End;
      //--------------------------------------
      //Totals calculation
      lTotalValof_19:= lTotalValof_19 + Tv[lCol19];
      lTotalValof_20:= lTotalValof_20 + Tv[lCol20];
      lTotalValof_21:= lTotalValof_21 + Tv[lCol21];
      Inc(i, 22);
    until i > 209;
    //20260519cz
    Tv[230]:= lTotalValof_19;
    Tv[231]:= lTotalValof_20;
    Tv[232]:= lTotalValof_21;
    { Changed the total Element numbers to be like they used to be before //20260519
    Tv[226]:= lTotalValof_19;
    Tv[227]:= lTotalValof_20;
    Tv[228]:= lTotalValof_21;
    //20260519 Alex <<<
    }






    {
    //If Strings[216] = '' then Strings[216] := 'N'; // 20231017
    //If Strings[217] = '' then Strings[217] := 'Y';  // 20231017
    //INIT Totals //20190614

    i := 530;
    z := 0;
    Repeat
     if Strings[i-2]='' then Strings[i-1]:=''; //20230309

     z := z + Vl(Strings[i]);

     Inc(i, 3); // 20220912
    Until i > 599;
    Tv[13] := z; //Strings[13] := FormatFloat('###.####', z);


    If Tv[13] > 100 then
    begin
      Tv[29]  := 0;
      Tv[600] := 0;       //jz 20240529
      for i := 601 to 625 do tv[i] := 0;
    end
    else
    Begin
      //jz 20240529
      i := 601;
      j := 530;
      z := 0;
      Repeat

        Tv[i] := 1500000*Vl(Strings[j])/100;

        z := z + Tv[i];      //z := z + Vl(Strings[i]);

        Inc(i, 1);
        Inc(j, 3);

      Until i > 624;
      Tv[625] := z; //Strings[625] := FormatFloat('###.####', z);


      // the first on the list
      Tv[29] := Tv[601]; //FormatFloat('##,###,###', y);

      y := (Ret[RetNo].DaysInYear / 365) * Tv[601]; //y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      Tv[600] := y; //strings[29] := FormatFloat('##,###,###', y);
    end;


    Tv[77] := 0;
    Tv[93] := 0; // DIEP UCC plus ImmeeditateExpensing column //20220730
    Tv[249] := 0;
    Tv[234] := 0;
    Tv[250] := 0;
    Tv[235] := 0;
    Tv[230] := 0;
    Tv[231] := 0;
    Tv[232] := 0;
    Tv[251] := 0;

    for i := 384 to 396 do
      Strings[i] := '';
    // initialize the bottom class numbers, then copy them //20190705
    for i := 515 to 527 do
      Strings[i] := '';
    // initialize the botom class numbers, then copy them //20190705
    for k := 0 to 12 do // 12 do
    Begin
      // repeate class for each section from Part 2
      Cls := AllTrim(Strings[col1 + k * 16]); // 20190719 //alltrim
      Strings[384 + k * 1] := Cls; // 20190705
      Strings[515 + k * 1] := Cls; // 20220730 //dupl/copy cless

      // set up override indicator
      If UpperCase(Strings[14 + k * 16]) = 'O' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'H' then
        Strings[15 + k * 16] := 'Y'; // half year
      if Vl(Rate) = 100 then    //jz ??? rate is set after this , causes erroneous N in empty next column
        Strings[15 + k * 16] := 'N';
      // 20190614 No half year rule for fast write off //20190614
      If UpperCase(Strings[16 + k * 16]) = 'T' then
        Strings[16 + k * 16] := 'Y'; // Term loss
      If UpperCase(Strings[14 + k * 16]) = 'X' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'X' then
        Strings[15 + k * 16] := 'Y'; // half year
      If UpperCase(Strings[16 + k * 16]) = 'X' then
        Strings[16 + k * 16] := 'Y'; // Term loss

      //20221121 from further below
      OverrideIndic := UpperCase(Strings[14 + k * 16]);
      HalfYearIndic := UpperCase(Strings[15 + k * 16]);
      TermLossIndic := UpperCase(Strings[16 + k * 16]);


      //moved to above
      // Rate := GetCCARate(Cls); //20221121
      If  Strings[489+k*1] <> 'Y' then   //override rate
        Strings[17+k*16]:=GetCCARate(Cls); //20221121
      Rate:=Strings[17+k*16];


      OriginalCost := Tv[371 + k * 1];
      AssetInfo := Strings[236 + k * 1];
      // calculate each Column mow
      UccStart := Tv[col2 + k * 16]; // col2
      Additions := Tv[col3 + k * 16]; // col3
      if DiepClass(Cls) = False then Tv[col4 + k * 1] := 0; //20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then Tv[col9 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5 + k * 16]; // cpl 5

      if (LeaseHold(Cls)) and (UccStart > 0) Then
      begin
      end; // do not allow additions to 13 //20190705
      // 20190809  accept yyymmdd in case they entered yyyy/mm/dd
      If (Cls > '') then
      begin
        if Not LeaseHold(Cls) then
        Begin
          // replace yyymmdd with yyy/mm/dd for date
          s := LeftStr(Strings[236 + k * 1], 8);
          if (Length(s) = 8) and (Numeric(s)) then
            Strings[236 + k * 1] := LeftStr(s, 4) + '/' + MidStr(s, 6, 2) + '/'
              + RightStr(s, 2);
        End
        Else // leasehold //cls='13')
        Begin
          s := Strings[236 + k * 1];
          s := RemoveChar(s, '/');
          s := RemoveChar(s, '-');
          s := LeftStr(s, 16);
          if (Length(s) = 16) and (Numeric(s)) then
          Begin
            S1 := LeftStr(s, 8); // from date
            S1 := LeftStr(S1, 4) + '/' + MidStr(S1, 5, 2) + '/' +
              RightStr(S1, 2);
            S2 := RightStr(s, 8); // to date
            S2 := LeftStr(S2, 4) + '/' + MidStr(S2, 5, 2) + '/' +
              RightStr(S2, 2);
            Strings[236 + k * 1] := S1 + '-' + S2;
          End;
        End;
      end; // cls>''

      // AIIP indicator//20190621
      // 20190705


     { //20259520
     // Strings[356 + k * 1] := '';  //20250512
      if (Additions > 0) and (Cls > '') then
      Begin
        s := ReplaceChar(AssetInfo, ',', '');
        PurchaseDate := LeftStr(s, 10);
        If GetTaxationYearEnd(RetNo)>'2023/12/01' then
          Strings[356 + k * 1] := '' //20250512
        Else
          Strings[356 + k * 1] := 'X'; //20250512
      end;
     }
     {
      if (Additions = 0) then Strings[356 + k * 1] := '';  //20259520
      if (GetTaxationYearEnd(RetNo) > '2027/12/31') then Strings[356 + k * 1] := '';
      // NO AIIP after 2027? Check it then IF ALIVE! //20190704

      //20231017
      If Tv[Col4 + k * 1] > 0 then
        Diep := True
      Else
        Diep:=false;

      If Strings[356 + k * 1] > '' then
        Aiip := True
      else
        Aiip := False; // 20190614
      {//20250522
      if Cls = '54' Or Cls= 56 then
      Begin
        Aiip := False;
        Strings[356 + k * 1] := '';
      end; // 20220531
      }
      {
      // 20190607  Override section elms starting 14, 15, 16
      if (Aiip = False) and (Cls > '') then
      Begin
        If Strings[15 + k * 16] = '' then
          Strings[15 + k * 16] := 'Y'; // 20190605 half yer rule by default
      End;

      if Aiip = True then
        Strings[15 + k * 16] := ''; // 20190614 in O-H-T

      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Strings[15 + k * 16] := ''; // fast write off NO half year rule

      {//20250611
      // Inpout validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3 + k * 16] := 0; // no additions allowed
      End;
      }
      {
      AdditionsAiip := Tv[col14 + k * 1];
      // assistance part of col 5
      Tv[col6 + k * 1] := MaxR(0, Tv[col6 + k * 1]); // col6 //20220621
      AssistanceReceived := Tv[col6 + k * 1];
      Tv[col7 + k * 1] := MaxR(0, Tv[col7 + k * 1]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8 + k * 16] := MaxR(0, Tv[col8 + k * 16]);

      // aiip  related
      If Aiip = False then
      Begin
        Tv[col16 + k * 1] := 0;
        Tv[col17 + k * 1] := 0;
        Tv[343 + k * 1] := 0;
        Tv[col18 + k * 1] := 0;
        Tv[col19 + k * 1] := 0;
      End;

           //20250524
     if (AIIP=True) and (Strings[236 + k *1]>'2023/12/31')  then
       Tv[Col14 + k *1]:=Tv[Col13 + k *1]
     Else
       Tv[Col14 + k *1]:=0;

     AdditionsAiip := Tv[col14 + k * 1];

      //20250524
      If (Aiip = True) and (cls='54') Or (cls='55') or (cls='56') then
      Begin
       Tv[col16 + k * 1]:=Maxr(0,Tv[col8 + k * 16]+Tv[col6 + k * 1]-Tv[col12 + k * 1]);
      End;


     if (Tv[Col4+k*1]>0) and (cls<>'54') and (cls<>'56') then //is diep etc
       Tv[col19 + k * 1] := 0; //20231016


      if Aiip = True then // 20190705
      Begin
        // fast write off //20190608
        if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Begin
          Tv[col3 + k * 16] := 0; // additions
        End;
        // 20210328
        // Aiipfactor
        Aiipfactor := '';
        Strings[343 + k * 1] := '';
        // if Cls = '' then Aiipfactor := ''; // 20190622
        if (Cls = '') or (Aiip = False) then
          Aiipfactor := ''; // default //20220801

        if Cls = '43.1' then
          Aiipfactor := '2.33333'
        Else if Cls = '43.2' then
          Aiipfactor := '1'
        Else if Cls = '53' then
          Aiipfactor := '1'
        Else if (Cls = '54') then
        Begin
          if Strings[236 + k] > '2019/03/18' then
          begin
            Strings[356 + k] := 'X';
            Aiipfactor := '2.33333333';
          end
          Else If Strings[236 + k] > '2018/11/20' then
          begin
            Strings[356 + k] := 'X';
            Aiipfactor := '0.5';
          end;
        End // aiip true
        Else if (Cls = '55') and (Strings[236 + k] > '2019/03/18') then
          Aiipfactor := '1.5'
        Else if (Cls = '56') then
          Aiipfactor := '2.333331' // 20210927
        Else if (Cls = '12') or (LeaseHold(Cls)) or (Cls = '14') or (Cls = '15')
        then
          Aiipfactor := '' // 20190806
        Else
          Aiipfactor := '0.5';
      End;

      Strings[343 + k * 1] := Aiipfactor;
      ProceedsAiip := Tv[col16 + k * 1];

      HalfRuleAmount := 0;
      UCC := 0;
      UCCReduced := 0;
      Recapture := 0;
      TerminalLoss := 0;

      // get lease and orinal cost from decr box
      If LeaseHold(Cls) then // if Cls='13' then
      begin
        LeaseTerm := 5; // Default;
        // for class 13: 1234567890-1234567890
        s := ReplaceChar(AssetInfo, ',', '');
        LeaseStart := LeftStr(s, 10);
        LeaseEnd := MidStr(s, 12, 10);
        if (Length(LeaseStart) <> 10) or (Length(LeaseEnd) <> 10) then
          LeaseTerm := 0
        Else
        begin
          LeaseTerm := DateDiffYMD(LeaseStart, LeaseEnd) div 365;
          If (LeaseTerm > 0) and (LeaseTerm < 5) then
            LeaseTerm := 5;
        End;

        LeaseMaxCca := OriginalCost / LeaseTerm; // 20190611

        If  Strings[489+k*1] <> 'Y' then   //jz 20240609 allow to override rate even if class 13
        begin
          Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601

          // if rate='INF' then ShowMessage('inf rate');
          if Rate='INF' then Rate := '20';
          Strings[col20 * k * 16] := Rate;
        end;


        // end;
      end;

      if Cls = '' then
      begin
        UCC := 0;
        HalfRuleAmount := 0;
        UCCReduced := 0;
        Recapture := 0;
        TerminalLoss := 0;
        CCA := 0;
        UCCEnd := 0;
      end;

      UCC := UccStart + Additions + Adjustments - AssistanceReceived +
        RepaidAmount - Proceeds; // 20190606pm
      if (Cls = '10.1') and (Proceeds > 0) then
        UCC := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount; // 20190820 Get the CCA on disposal

      If LeaseHold(Cls) then // if cls='13' then //20190611
      Begin
        LeaseAdjustedCost := OriginalCost - UccStart + Additions + Adjustments -
          AssistanceReceived + RepaidAmount;
        UCCReduced := UccStart + Additions + Adjustments - AssistanceReceived +
          RepaidAmount;
      End;

      if Aiip = False then // 20190706
      Begin
        if UpperCase(HalfYearIndic) = 'Y' then
        /// /20190605
        begin
          if UpperCase(OverrideIndic) <> 'Y' then // 20190605
          begin
            HalfRuleAmount :=
              MaxR(0, 0.5 * (Additions - AssistanceReceived + RepaidAmount -
              Proceeds));
            if LeaseHold(Cls) then
              HalfRuleAmount := MaxR(0, 0.5 * (Additions - Proceeds));
            // 20190613
            HalfRuleAmount := RoundCorrect(HalfRuleAmount);
          end;
        end
        else
          HalfRuleAmount := 0;
        // from below  //20220619
        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') // fast write off //20190622
        then
          UccAdjustmentNONAiip := 0; // 20190622
        UCCReduced := UCC - HalfRuleAmount;
        if LeaseHold(Cls) then
          UCCReduced := UCC; // 20190611
        ProceedsAiip := 0;
        NetCapCostAdditionsAiip := 0;
        UccAdjustmentAiip := 0;
      end // 20220619
      Else // If (Aiip=True) then
      Begin
        HalfRuleAmount := 0; // 20190608
        // 20190707
        ProceedsAiip := MaxR(0, Proceeds + AssistanceReceived - Additions +
          AdditionsAiip - RepaidAmount);
        NetCapCostAdditionsAiip := MaxR(0, AdditionsAiip - ProceedsAiip);
        if (Cls = '10.1') and (Proceeds > 0) then
          NetCapCostAdditionsAiip := AdditionsAiip;

        UccAdjustmentAiip := NetCapCostAdditionsAiip * Vl(Aiipfactor);
        UccAdjustmentNONAiip :=
          MaxR(0, 0.5 * (Additions - AdditionsAiip - AssistanceReceived +
          RepaidAmount - Proceeds)); // 20190622 moved from below

        if (Cls = '12') OR (Cls = '52') Or (Cls = '24') or (Cls = '27') or
          (Cls = '29') or (Cls = '34') then
          UccAdjustmentNONAiip := 0; // 20190622  //fast write off //20190622
      End; // 20220619
      // put amounts on the S8 form
      Tv[12 + k * 16] := HalfRuleAmount; // ???
      if Aiip then
        Tv[12 + k * 16] := 0; // remove half ruleamount

      // Col2
      Tv[249] := Tv[249] + Tv[col2 + k * 16];

      // Col3
      Tv[234] := Tv[234] + Tv[col3 + k * 16];

      // Col4
      if Tv[col4 + k * 1] > Tv[col3 + k * 16] then //jz 20240529 Tv[col3 + k * 1] to Tv[col3 + k * 16]
        Tv[col4 + k * 1] := Tv[col3 + k * 16];

      // Col8                                 -
      Tv[235] := Tv[235] + Tv[col8 + k * 16];
      // col9  user inout
      if Tv[col9 + k * 1] > Tv[col8 + k * 16] then
        Tv[col9 + k * 1] := Tv[col8 + k * 16];
      // col10
      Tv[col10 + k * 16] := Tv[col2 + k * 16] + Tv[col3 + k * 16] + Tv[col5 + k * 16] - Tv[col8 + k * 16];




      // col11  //20131017
    // if UpperCase(Strings[216])='Y' then
    // begin

     if Diep=true then   //20231017
     begin
       Tv[col11+k*1]:=MaxR(0,Tv[col4+k*1]
       +Tv[Col5+k*16]         //20231016
       -Tv[Col8+k*16]);        //20231016
     end
     Else
      Tv[col11+k*1]:=0;
     x:=Tv[col11+k*1];  //for debugging

      if diep=True  then
      Begin
        If (Tv[col4 + k * 1] > 0) then  // and (Tv[col12 + k * 1] = 0) then //20231017
           Tv[col12 + k * 1] := Tv[col11 + k * 1]; // 20221017
      end;
      if Tv[col12 + k * 1] > Tv[col11 + k * 1] then Tv[col12 + k * 1] := Tv[col11 + k * 1]; //20230618
      if Ret[RetNo].CorpType<>CCPC then Tv[col12 + k * 1]:=0; //20221115

      Tv[77] := Tv[77] + Tv[col11 + k * 1];    //tot col11
      ImmediateExpensing := Tv[col12 + k * 1]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // col13
      Tv[col13 + k * 1] :=MaxR(0, Tv[col3 + k * 16] - Tv[Col4 +K*1] + Tv[Col11+K*1] - Tv[col12 + k * 1]);

       //20240217
      // col14  user input
      if (Aiip = True)    // and (cls='54')  // or (cls='55')
      then
       Tv[col14 + k * 1] := MaxR(0, Tv[col13 + k * 1])
      else
       Tv[col14 + k * 1] := 0;

      Tv[col15 + k * 1] := MaxR(0, Tv[col10 + k * 16] - Tv[col12 + k * 1]);
      // col16
      if Aiip = True then  //20231009 //2092311091
        Tv[col16 + k * 1] := MaxR(0, Tv[col8 + k * 16] - Tv[col9 + k * 1]
          +Tv[col6 + k * 1] - Tv[col13 + k * 1] + Tv[col14 + k * 1]
          - Tv[col7 + k * 1]) // 54 and 56?
      else
        Tv[col16 + k * 1] := 0;

      if Aiip = True then
        Tv[col17 + k * 1] := MaxR(0, Tv[col14 + k * 1] - Tv[col16 + k * 1])
        // ? 54 and 56?
      else
        Tv[col17 + k * 1] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[343 + k * 1] := ''; // aiip factor
      end;

      // col18
      Tv[col18 + k * 1] := Tv[col17 + k * 1] * Vl(Strings[343 + k * 1]);
      //20250524   AIIP terminated on Dec 31, 2023
      if (AIIP=True) and (Strings[236 + k *1]>'2023/12/31')  then Tv[Col18 + k *1]:=0;

      if (Aiip = True) Or ((cls='54') OR (cls='55') OR (cls='56')) then //  //20231017
         Tv[col18 + k * 1]:=0;
      //20231017
      if (Aiip = True) Or ((cls='54') OR (cls='55') OR (cls='56')) then //is diep etc  //20250709
         Tv[col19 + k * 1]:=0
      Else
        Tv[col19 + k * 1] :=MaxR(0, Tv[col13 + k * 1] - Tv[col14 + k * 1]
        - Tv[col6 + k * 1] + Tv[col17 + k * 1] -Tv[col8 + k * 16]) * 0.5; // ? 54 and 56?  //+Tv[col9 + k * 1]  //20250709
      //xx:=Tv[col19 + k * 1];
      //if (Aiip = False) or (Cls='54') or (cls='56') then  Tv[col19 + k * 1]:=0;  //20250521
      //xx:=Tv[col19 + k * 1];
      // col20
      Strings[col20 + k * 16] := Rate;
      // col21 recapture
      Tv[col21 + k * 16] := 0;
      if Tv[col10 + k * 16] < 0 then
        Tv[col21 + k * 16] := ABS(Tv[col10 + k * 16]);

      if (cls='10.1') then Tv[col21 + k * 16]:=0;  //20230516

      Tv[230] := Tv[230] + Tv[col21 + k * 16];

      // col22 Terminal loss
      Tv[col22 + k * 16] := 0;
      if (UpperCase(Strings[16 + k * 16]) = 'Y') and (Tv[col10 + k * 16] > 0)
      then
        Tv[col22 + k * 16] := Tv[col10 + k * 16];
      if (cls='10.1') then Tv[col22 + k * 16]:=0;  //20230516
      Tv[231] := Tv[231] + Tv[col22 + k * 16];

      //col23 CCA
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then Rate := '100'; // fast write off //20220802

      //There is CCA
      If (Tv[col21 + k * 16] = 0) and (Tv[col22 + k * 16] = 0) then  //NO  Term loss Or Recapture both zero
      begin    //normal CCA no terminal loss or  recapture
        if UpperCase(Strings[14 + k * 16]) <> 'Y' then // no override);
        Begin
          Tv[col23 + k * 16] := (Tv[col15 + k * 1] + Tv[col18 + k * 1]
                               -Tv[col19 + k * 1]) * Vl(Rate) / 100 + Tv[col12 + k * 1];
          //showmessage( '('+floattostr(Tv[col15 + k * 1])+' + '+floattostr(Tv[col18 + k * 1])+ ' + ' + floattostr(Tv[col14+K*1])+' - '+floattostr(Tv[col19 + k * 1])+' *'+ Rate +'/ 100 ' + floattostr(Tv[col12 + k * 1]) );
          CCA:=Tv[col23 + k * 16];  //20230322
          if Ret[RetNo].DaysInYear<365 then
          Begin
           CCA := CCA * Ret[RetNo].DaysInYear / 365;
           Tv[col23 + k * 16]:=CCA;
          End;
        End;
      end
      Else  //case: recapture  or Term loss>0 //20230512
      begin
        CCA:=0;
        Tv[col23 + k * 16] := 0; // if recapture or term loss then CCA =0
        //proration:?
        if Ret[RetNo].DaysInYear<365 then
        Begin
          //Tv[col21 + k * 16]:=Tv[col21 + k * 16]/ 365;  //recapture
          //Tv[col22 + k * 16]:=Tv[col22 + k * 16] / 365; //terminal loss
         End;
      end;

      Tv[232] := Tv[232] + Tv[col23 + k * 16];

      if UpperCase(Strings[16 + k * 16]) = 'Y' // term loss
      then
        Tv[col24 + k * 16] := 0 // no UCC end eny more
      Else
        Tv[col24 + k * 16] := MaxR(0, Tv[col10 + k * 16] - Tv[col23 + k * 16]);

      Tv[251] := Tv[251] + Tv[col24 + k * 16];

    End; // k 0 to 12  //k is the wow bing processed starts from k=0
    }
  end; // with?

  SaveTv(RetNo, FName, FNo);
end;
//20260501 Alex <<<
*)


//20260501 Alex >>>
//jz - updated with year acquired / used for col 16 factor , still needs similar for col15 and maybe others
//   - BUT may want to make more like last years as update was poorly done and important info was removed


