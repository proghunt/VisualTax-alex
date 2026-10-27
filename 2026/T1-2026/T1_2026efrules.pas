unit T1_2026Efrules;

interface

Uses SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Controls,
  T1_2026TrimStr, T1_2026T1Rtns, T1_2026T1Rtns2, T1_2026Declare, T1_2026Calc4;

Function DoRules(RetNo: Integer; Rule: Integer): Real;

Implementation

uses
  vtCommon,
  T1_2026,
  vtTrimStr, vtShared;

Var
  FName: String;

Function DoRules(RetNo: Integer; Rule: Integer): Real;
Var
  x: Real;
  Frm, s: String;
  T1139ReserveConv, T1139ReserveAlt, T1139Bus, T1139Prof, T1139Farm,
    T1139Fish: Real;
Begin

  If Rule = 0 then
    exit;

  If Rule = 107 then
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 106));
    If (Abs(Result) < 1) and (Vl(FetchElm(RetNo, 'S3', 105)) <> 0) then
      Result := 1; // 20111223
    exit;
  end;

  If Rule = 110 then
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 114));
    If (Abs(Result) < 1) and (Vl(FetchElm(RetNo, 'S3', 113)) <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 124 then
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 122));
    If (Abs(Result) < 1) and (Vl(FetchElm(RetNo, 'S3', 121)) <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 160 then
  begin
    Result := Ret[RetNo].Lnn[12599];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[12600] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 126 then
  begin
    Result := Ret[RetNo].Lnn[12600];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[12599] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 132 then
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 19));
    If (Abs(Result) < 1) and (Vl(FetchElm(RetNo, 'S3', 18)) > 0) then
      Result := 1;
    exit;
  end;

  If Rule = 135 then
  begin
    Result := Ret[RetNo].Lnn[13500];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[13499] <> 0) then
      Result := 1; // 20111223
    // If (result=0) and (Ret[RetNo].Lnn[13499] <>0) then result :=1;
    exit;
  end;

  If Rule = 162 then
  begin
    Result := Ret[RetNo].Lnn[13499];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[13500] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 153 then // 20111225
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 61));
    // Ret[RetNo].Lnn[15300]; //20171210
    If (Abs(Result) < 1) and (Vl(FetchElm(RetNo, 'S3', 60)) <> 0) then
      Result := 1;
    // ;(Ret[RetNo].Lnn[15199] <>0) then result :=1;
    exit;
  end;

  // 20171210
  If Rule = 155 then // 20111225
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 72));
    // Ret[RetNo].Lnn[15500]; //20171210
    If (Abs(Result) < 1) and (Vl(FetchElm(RetNo, 'S3', 71)) <> 0) then
      Result := 1;
    // If (Abs(result)<1) and (Ret[RetNo].Lnn[15499] <>0) then result :=1;
    exit;
  end;

  If Rule = 137 then
  begin
    Result := Ret[RetNo].Lnn[13700];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[13699] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 138 then
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 36));
    If (Abs(Result) < 1) and (Vl(FetchElm(RetNo, 'S3', 35)) > 0) then
      Result := 1;
    exit;
  end;

  If Rule = 176 then // 20121217
  begin
    Result := Vl(FetchElm(RetNo, 'S3', 127));
    If Result = 0 then
    Begin
      If Vl(FetchElm(RetNo, 'T936', 136)) = 1 then
        Result := 1;
    end;
    exit;
  end;

  If Rule = 164 then
  begin
    Result := Ret[RetNo].Lnn[13699];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[13700] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 139 then
  begin
    Result := Ret[RetNo].Lnn[13900];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[13899] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 166 then
  begin
    Result := Ret[RetNo].Lnn[13899];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[13900] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 141 then
  begin
    Result := Ret[RetNo].Lnn[14100];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[14099] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 168 then
  begin
    Result := Ret[RetNo].Lnn[14099];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[14100] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 143 then
  begin
    Result := Ret[RetNo].Lnn[14300];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[14299] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 170 then
  begin
    Result := Ret[RetNo].Lnn[14299];
    If (Abs(Result) < 1) and (Ret[RetNo].Lnn[14300] <> 0) then
      Result := 1;
    exit;
  end;

  If Rule = 178 then
  begin
    Result := Abs(Vl(FetchElm(RetNo, 'S3', 91)));
    exit;
  end;

  // 20161231
  If Rule = 179 then
  begin
    Result := 0;
    If FetchElm(RetNo, 'S3', 139) > '' then
      Result := 1;
    If FetchElm(RetNo, 'S3', 140) > '' then
      Result := 2;
    If FetchElm(RetNo, 'S3', 148) > '' then
      Result := 3;
    exit;
  end;

  //jz//20260119
  If Rule = 10105 then
  begin
    Result := TotMultiple(RetNo, 'T4', 66); //box 87
  end;


  If Rule = 17700 then // 20240214
  begin
    Result := 0;
    If FetchElm(RetNo, 'T1248', 1) > '' then
      Result := 1
    Else If FetchElm(RetNo, 'T1248', 2) > '' then
      Result := 2
    Else If FetchElm(RetNo, 'T1248', 3) > '' then
      Result := 5; // factual resident

    If FetchElm(RetNo, 'T1', 503) > '' then //jz//NonResCERT//20240422
    begin
      Result := 3; //deemed resident of Canada 183 days
    end;
    If FetchElm(RetNo, 'T1', 504) > '' then //jz//NonResCERT//202404 - add back, not sure why was removed but is needed
    begin
      Result := 4; //Deemed for other reasons? //20240426
    end;

    exit;
  end;

  If Rule = 17905 then // 20231228
  begin
    Result := 0;
    If FetchElm(RetNo, 'S3', 157) > '' then
      Result := 1
    else
    begin
      If FetchElm(RetNo, 'S3', 158) > '' then
        Result := 2 // 20240104
    end;
    exit;
  end;

  (* //20171119
    //20161231
    If Rule = 181 then
    begin
    Result:=Vl(FetchElm(RetNo,'S3', 67)+FetchElm(RetNo,'S3', 136)+FetchElm(RetNo,'S3', 138)); //20170117
    exit;
    end;
  *)

  If Rule = 259 then
  begin
    If UpperCase(FetchElm(RetNo, 'S7', 24)) = 'X' then
      Result := 1
    else
      Result := 0;
    exit;
  end;

  If Rule = 264 then
  begin
    If UpperCase(FetchElm(RetNo, 'S7', 16)) = 'X' then
      Result := 1
    else
      Result := 0; { ? }
    exit;
  end;

  If Rule = 266 then
  begin
    If UpperCase(FetchElm(RetNo, 'INFO', 86)) > '' then // 20191210
      Result := 1
    else
      Result := 2;
    exit;
  end;

  { 252 is not what it is in the return, it must exclude farm and restr
    farm is on 5492 and restricted on 5496 }
  If Rule = 252 then
  begin { minus prev yr farm losses, restr losses }
    Result := MaxR(0, Ret[RetNo].Lnn[25200] - GetFarmLossApplied(RetNo) -
      GetRestrFarmLossApplied(RetNo));
    exit;
  end;

  If Rule = 310 then // 20110116
  begin
    Result := Ret[RetNo].Lnn[31000];
    If Ret[RetNo].Province = 'QC' then
      Result := 0; // 20131217   //20140104
    exit;
  end;

  If Rule = 308 then
  begin
    Result := Ret[RetNo].Lnn[30800];

    If (Ret[RetNo].Province = 'QC') then
    begin
      Result := 0;
      exit;
    end; // 20120122
   // If (Ret[RetNo].T4QPPPremium > 0) then  Result := 0; //20250120// 20131219 //20200205  //20200302
    exit;
  end;


  //jz//s8rev+rc381rev//20250614 - do not send 31000 if prov is quebec
  if rule = 310 then
  begin
    result := Ret[RetNo].Lnn[31000];
    if Ret[RetNo].Province = 'QC' then
      result:=0;
  end;


  If Rule = 312 then
  begin
    Result := Ret[RetNo].Lnn[31200];
    If ( (Ret[RetNo].Province <> 'QC') and (not(isDeemedResQuebec(RetNo))) and (TotMultiple(RetNo, 'T4', 44) > 0) ) then //jz//NonResCERT-R3//202404 If (Ret[RetNo].Province <> 'QC') and (TotMultiple(RetNo, 'T4', 44) > 0) then
      Result := 0; // 20200204  //20200301
    exit;
  end;

  // 20171210
  If Rule = 345 then
  begin
    Result := 0;
    if FetchElm(RetNo, 'S11', 31) > '' then
      Result := 1;
    exit;
  end;



  If Rule = 351 then { sp txbl inc }
  begin
    Result := GetLine351ForEfile(RetNo); // s2 spouse adj income //36100
  end;

//20241228
  If Rule = 361 then   //36100 adjusted spouse income
  begin
    Result := Vl(FetchElm(RetNo, 'S2', 17));
    if (result=0) and (Vl(FetchElm(RetNo, 'S2', 19)) > 0)
    and (Vl(FetchElm(RetNo, 'S2', 19)) > 0) then  //tre is transfer
      Result := 1;
    exit;
  end;
  {
  ////20241228
  If Rule = 361 then   //36100
  begin
    Result := Vl(FetchElm(RetNo, 'S2', 3));

    If (Vl(FetchElm(RetNo, 'S2', 19)) = 0) then
      Result := 0
    Else
    begin
    If (Vl(FetchElm(RetNo, 'S2', 19)) > 0) then
     Result:=1;
    end;
    exit;
  end;
  }
  If Rule = 352 then   //35200
  begin
    Result := Vl(FetchElm(RetNo, 'S2', 3));

    If (Vl(FetchElm(RetNo, 'S2', 19)) = 0) then
    // and (Vl(FetchElm(RetNo, 'S2Prv', 19)) = 0) then  //20241226
      Result := 0;

    exit;
  end;

  If Rule = 355 then
  begin
    Result := Vl(FetchElm(RetNo, 'S2', 4));
    If Vl(FetchElm(RetNo, 'S2', 19)) = 0 then
      Result := 0;
    exit;
  end;

  If Rule = 357 then
  begin
    Result := Vl(FetchElm(RetNo, 'S2', 5));
    If Vl(FetchElm(RetNo, 'S2', 19)) = 0 then
      Result := 0;
    exit;
  end;

  If Rule = 360 then
  begin
    Result := Vl(FetchElm(RetNo, 'S2', 6));
    If Vl(FetchElm(RetNo, 'S2', 19)) = 0 then
      Result := 0;
    exit;
  end;

  If Rule = 361 then
  begin
    Result := Vl(FetchElm(RetNo, 'S2', 32));
    If Vl(FetchElm(RetNo, 'S2', 19)) = 0 then
      Result := 0;
    exit;
  end;

  If Rule = 371 then
  begin
    Result := GetLine371ForEfile(RetNo);
    exit;
  end;

  {
    If Rule = 372 then // 20131217  //50372
    begin
    Result := 0;
    If RC381InEffect(RetNo) then
    Begin
    Result := Vl(FetchElm(RetNo, 'RC381', 42)) // 20131217
    end
    Else
    Result := Vl(FetchElm(RetNo, 'S8', 20));
    end;
  }

  If Rule = 373 then // 20131217
  begin
    Result := 0;
    If RC381InEffect(RetNo) then
      Result := MaxR(Vl(FetchElm(RetNo, 'RC381', 47)),
        Vl(FetchElm(RetNo, 'RC381', 78))) // 20141209
      // MaxR(Vl(FetchElm(RetNo,'RC381',47))+Vl(FetchElm(RetNo,'RC381',48)),Vl(FetchElm(RetNo,'RC381',78)))   //20140205   373=both line 2 and 3
    Else If Vl(FetchElm(RetNo, 'S8', 2)) > 0 then
      Result := Vl(FetchElm(RetNo, 'S8', 2))
    Else
      Result := Vl(FetchElm(RetNo, 'S8Q', 2));
  end;

  If Rule = 380 then // 20101201
  begin
    Result := Vl(FetchElm(RetNo, 'S10', 3));
    If (Result = 0) and (Ret[RetNo].Lnn[54377] > 0) then
      Result := 1;
    exit;
  end;

  // all below 20191213
  If Rule = 38100 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;
    If FetchElm(RetNo, Frm, 1) > '' then
      Result := 1
    else
      Result := 2;
    exit;
  end;

  If Rule = 38101 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;
    // if FetchElm(RetNo,FRM,1)>'' then exit;  //thre is eligible dependant //20191215 they can be both

    If FetchElm(RetNo, Frm, 3) > '' then
      Result := 1
    else
      Result := 2;

    exit;
  end;

  If Rule = 38102 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;

    If FetchElm(RetNo, Frm, 29) > '' then
      Result := 1
    else
      Result := 2;

    exit;
  end;

  If Rule = 38103 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;
    If FetchElm(RetNo, Frm, 31) > '' then
      Result := 1
    else
      Result := 2;
    exit;
  end;

  If Rule = 38104 then
  begin
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';

    //jz//20250105 - rearrange so if not selected is not included
    Result := 0;
    if      Ret[RetNo].Lnn[45300]    = 0  then  Result := 0  // no CWB amount exists //20250102cz
    else if FetchElm(RetNo, Frm, 3)  = '' then  Result := 0  // No elig spouse //20191214
    else if FetchElm(RetNo, Frm, 33) > '' then  Result := 1
    else if FetchElm(RetNo, Frm, 34) > '' then  Result := 2;

    exit;
  end;


  If Rule = 38105 then // 20191211
  begin
    Result := 0;

    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;
    If FetchElm(RetNo, Frm, 68) + FetchElm(RetNo, Frm, 69) = '' then
      exit; // 20191223
    If FetchElm(RetNo, Frm, 68) > '' then
      Result := 1
    else
      Result := 2; // 20191218
    // If ret[retNo].Province='QC' then Result:=Vl(FetchElm(RetNo,'S6QC',68)); //20171205
    exit;
  end;

  If Rule = 38106 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;
    Result := Vl(FetchElm(RetNo, Frm, 8));
    // If ret[retNo].Province='QC' then Result:=Vl(FetchElm(RetNo,'S6QC',8)); //20171205
    exit;
  end;

  If Rule = 38107 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then exit;
    Result := Vl(FetchElm(RetNo, Frm, 12));
    exit;
  end;

  If Rule = 38108 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then exit; // no s14 claim
    Result := Vl(FetchElm(RetNo, Frm, 14));

    {//20250102  for case #8
    If (Result = 0) and (FetchElm(RetNo, Frm, 3) > '') and
     (Vl(FetchElm(RetNo, Frm, 14)) = 0) then  Result := 1; // 20200108 Eligible spouse and NI=0
    }
    if (Result = 0) and (Vl(FetchElm(RetNo, Frm, 14)) = 1) then
      Result := 1; // i.e override to 1 if needed
    exit;
  end;

  {
    If Rule = 388 then
    begin
    Result:=0;
    If Ret[RetNo].Lnn[45300]=0 then exit;
    Result:=Vl(FetchElm(RetNo,'S6',18));
    If ret[retNo].Province='QC' then Result:=Vl(FetchElm(RetNo,'S6QC',18));
    exit;
    end;
  }
  If Rule = 38109 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;
    Result := Vl(FetchElm(RetNo, Frm, 19));
    // If ret[retNo].Province='QC' then Result:=Vl(FetchElm(RetNo,'S6QC',19));
    exit;
  end;

  If Rule = 38110 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
      Frm := 'S6QC'
    Else
      Frm := 'S6';
    If Ret[RetNo].Lnn[45300] = 0 then
      exit;
    Result := MaxR(0, Vl(FetchElm(RetNo, Frm, 27)));
    exit;
  end;
  // ---- s6 --------------
  // 20231125
  If Rule = 38120 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
    Begin
      Frm := 'S6QC';
      If Vl(FetchElm(RetNo, Frm, 73)) > 0 then
        Result := MaxR(0, Vl(FetchElm(RetNo, Frm, 73)))
      Else
        Result := 0;
    End
    Else
    begin
      Frm := 'S6';
      If Vl(FetchElm(RetNo, Frm, 85)) > 0 then
        Result := MaxR(0, Vl(FetchElm(RetNo, Frm, 85)))
      Else
        Result := 0;
    end;
    exit;
  end;

  If Rule = 38121 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
    Begin
      Frm := 'S6QC';
      If Vl(FetchElm(RetNo, Frm, 76)) > 0 then
        Result := MaxR(0, Vl(FetchElm(RetNo, Frm, 76)))
      Else
        Result := 0;
    End
    Else
    begin
      Frm := 'S6';
      If Vl(FetchElm(RetNo, Frm, 86)) > 0 then // 20240125
        Result := MaxR(0, Vl(FetchElm(RetNo, Frm, 86))) // not 1 //20240125
      Else
        Result := 0;
    end;
    exit;
  end;

  If Rule = 38122 then
  begin
    Result := 0;
    if Ret[RetNo].Province = 'QC' then
    Begin
      Frm := 'S6QC';
      If Vl(FetchElm(RetNo, Frm, 93)) > 0 then
        Result := MaxR(0, Vl(FetchElm(RetNo, Frm, 93)))
      Else
        Result := 0;
    End
    Else
    begin
      Frm := 'S6';
      If Vl(FetchElm(RetNo, Frm, 95)) > 0 then
        Result := MaxR(0, Vl(FetchElm(RetNo, Frm, 95)))
      Else
        Result := 0;
    end;
    exit;
  end;



  // -----------------------

  If Rule = 431 then
  begin
    Result := CalcLn431(RetNo); // 20120309
  end;

  If Rule = 434 then
  begin
    Result := CalcLn434(RetNo); // 20120309
  end;

  If Rule = 433 then
  begin
    // 20120309
    Result := CalcLn433(RetNo);
    /// TotMultiple(RetNo,'T2209',2);  //20111214
    exit;
  end;

  If Rule = 439 then
  begin
    // 20121225
    Result := CalcLn439(RetNo);
    /// TotMultiple(RetNo,'T2209',2);  //20111214
    exit;
  end;

  (*
    If Rule = 489 then   //ONLY FOR BARCODE = EFiler No
    begin
    result :=0;
    If UpperCase(FetchElm(RetNo,'T1DD',8)) = 'X' then result :=1;
    exit;
    end;
  *)

  (* 20140128
    If Rule = 492 then   {T1DD: UCCB into first  account}
    begin
    result :=0;
    If UpperCase(FetchElm(RetNo,'T1DD',14)) = 'X' then result :=1;
    exit;
    end;
  *)

  If Rule = 488 then
  begin
    If IsPreBankruptcyReturn(RetNo) then
    begin
      Result := 0;
      exit;
    end;
    Result := 0;
    If FetchElm(RetNo, 'INFO', 107) > '' then
      Result := 1;
    exit;
  end;

  // 20181203
  If Rule = 490 then { type of return }
  begin
    Result := 2;
    If FetchElm(RetNo, 'INFO', 100) > '' then
      Result := 1;
    if FetchElm(RetNo, 'INFO', 104) > '' then
      Result := 1
    else
      Result := 2; // 20191212
    If FetchElm(RetNo, 'INFO', 102) > '' then
      Result := 3; // 20190103
    If FetchElm(RetNo, 'INFO', 103) > '' then
      Result := 2; // volunteer No payment //20190103
    exit;
    {
      else If FetchElm(RetNo,'INFO',101) > '' then result :=2
      else If FetchElm(RetNo,'INFO',102) > '' then result :=3
      else If FetchElm(RetNo,'INFO',103) > '' then result :=1;  //20130103 volunteer
      If IsHomeUse then result:=2;
    }

  end;

  (* //20161117
    If Rule = 496 then
    begin
    result :=0;
    If (Ret[RetNo].Lnn[423]>0) and ((Ret[RetNo].MarStatus <4) or (Ret[RetNo].MarStatus =5))  //20160104
    then  //20150310 includes widowed
    //If (Ret[RetNo].Lnn[423]>0) and (Ret[RetNo].MarStatus <3) then
    begin
    Result:=Vl(FetchElm(RetNo,'S1A',26));
    If Result=0 then Result:=1;
    end;
    end;

    If Rule = 497 then
    begin
    result :=0;
    If (Ret[RetNo].Lnn[423]>0) and ((Ret[RetNo].MarStatus <4) or (Ret[RetNo].MarStatus =5))  //20160104
    then
    //If (Ret[RetNo].Lnn[423]>0) and (Ret[RetNo].MarStatus <4) then  //20150310 includes widowed
    begin
    Result:=Vl(FetchElm(RetNo,'S1A',31));
    If Result=0 then Result:=1;
    end;
    end;

    If Rule = 498 then
    begin
    result :=0;
    If (Ret[RetNo].Lnn[423]>0) and (Ret[RetNo].MarStatus <3) then
    begin
    Result:=Vl(FetchElm(RetNo,'S1A',44));
    If Result=0 then Result:=1;
    end;
    end;

    If Rule = 499 then
    begin
    result :=0;
    If (Ret[RetNo].Lnn[423]>0) and (Ret[RetNo].MarStatus <3) then
    begin
    Result:=Vl(FetchElm(RetNo,'S1A',46));
    If Result=0 then Result:=1;
    end;
    end;
  *)

  If Rule = 5031 then // 20131219
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'QC') Or (Ret[RetNo].T4QPPPremium > 0) then
      Result := Ret[RetNo].Lnn[30800];
    exit;
   {CRA says ypou cannot have both 30800 and 60310    //20250430

   }

  end;


  //jz//20250305 rule no longer valid?? where is this field? add it to efmemo? profile has it in T1 efile 'additional'
  If Rule = 5032 then // 20140103
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'QC') then // Or (Ret[RetNo].T4QPPPremium>0) then  //20130112
      Result := Ret[RetNo].Lnn[31000];

    //if GetSinNo(RetNo)='870000445' then Result := 3510; //jz//20251220 - removed, better to use overrides until solved TC33
    exit;
  end;



  If Rule = 5263 then // part time source inc
  begin
    Result := 0;
    // If FetchElm(RetNo, 'INFO', 215) = '' then exit; // entry dt 20240324
    Result := Vl(FetchElm(RetNo, 'INFO', 213));
    // If vl(FetchElm(RetNo,'INFO',214))=0 then result:=1;
    exit;
  end;

  If Rule = 5267 then // part time foreign inc
  begin
    Result := 0;
    If FetchElm(RetNo, 'INFO', 215) = '' then
      exit; // entry dt
    Result := Vl(FetchElm(RetNo, 'INFO', 214));
    If Vl(FetchElm(RetNo, 'INFO', 214)) = 0 then
      Result := 1;
    exit;
  end;

  If Rule = 5532 then // selfempl for WIB
  begin
    Result := GetLine5532ForEfile(RetNo);
    // 20130109    //instead of getwitb inc
    (*
      //20080314
      Result:=0;
      If Ret[RetNo].Lnn[45300]>0 then
      begin
      result:=GetSelfEmplForWib(RetNo);
      { 20111221
      -Ret[RetNo].Lnn[13500]-Ret[RetNo].Lnn[13700]-Ret[RetNo].Lnn[13900]
      -Ret[RetNo].Lnn[14100];
      }
      exit;
      end;
    *)
  end;

  If Rule = 5355 then // selfempl via T4    //20121218
  begin
    // 20111221
    // Result:=TotMultiple(RetNo,'T2121',32);
    x := TotMultiple(RetNo, 'T2121', 32); // from t4 slips
    If x = TotMultiple(RetNo, 'T2121', 35) then
      Result := TotMultiple(RetNo, 'T2121', 74)
      // use the NI as only income is from T4
    else
      Result := x;
    If Vl(FetchElm(RetNo, 'S13', 4)) = 0 then
      Result := 0; // S13 not thre  //20120110

    exit;
  end;

  If Rule = 45354 then // selfempl for WIB
  begin
    Result := TotMultiple(RetNo, 'S12', 169); // 20231205
  end;

  If Rule = 5461 then // 20181207
  begin
    Result := 0;
    If Ret[RetNo].Province = 'NS' then
      Result := Vl(FetchElm(RetNo, 'BANKRPT', 13));
    exit;
  end;

  If Rule = 5566 then { retir benefits from T4AP }
  begin
    Result := MinR(Ret[RetNo].Lnn[11400], TotMultiple(RetNo, 'T4AP', 11));
    exit;
  end;

  {//20260103
  If Rule = 5569 then
  begin
    // 20151217
    Result := 0;
    // If TotMultiple(RetNo,'T4',28)=0 then Exit;   //20170105
    // ----------------
    //Result := Vl(FetchElm(RetNo, 'T691', 130));
    Result := Vl(FetchElm(RetNo, 'T691', 23)); //jz/20250330 - wrong elm from 130 to 23
    // If Not SubjectToMinTax(RetNo) then result:=0;  //20101216
    exit;
  end;
  }

  If Rule = 5570 then
  begin
    Result := Vl(FetchElm(RetNo, 'T691', 131));
    If Not SubjectToMinTax(RetNo) then
      Result := 0;
    exit;
  end;

  If Rule = 5571 then
  begin
    Result := Vl(FetchElm(RetNo, 'T691', 144));
    If (Ret[RetNo].Province <> 'BC') and Not SubjectToMinTax(RetNo) then //20251212 Igor
      Result := 0;
    exit;
  end;

  (* //20170205
    If Rule = 5589 then  //20161217
    begin
    result:=0;
    If (Ret[RetNo].FrmHasData[GetFormNo('T1206')])
    and (Ret[RetNo].Province='NL') then
    begin
    result :=Vl(FetchElm(RetNo,'NL428',95));
    exit;
    end;
    end;
  *)

  If Rule = 5773 then // 20151128
  begin
    Result := 0;
    // If (Ret[RetNo].Lnn[11600]>0) or (Ret[RetNo].Lnn[21000]>0) then  //20151210
    // Begin
    If UpperCase(FetchElm(RetNo, 'INFO', 188)) = 'X' then
      Result := 1
    else
      Result := 0;
    // end;
    exit;
  end;

  { Provincial non refundable }
  If Rule = 5804 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 23));
    exit;
  end;

  If Rule = 5808 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 24));
    exit;
  end;

  If Rule = 5812 then
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then // 20240403
    begin
      Result := 0;
      if Ret[RetNo].Province = GetTax1FormName(RetNo) then
        Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 28));
      exit;
    end

    Else If FullTONIProvince(RetNo) then
    Begin
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 28));
      exit;
    End;
  end;

  If Rule = 5816 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 29));
    if Ret[RetNo].Province = 'SK' then
      Result := Vl(FetchElm(RetNo, 'SK428', 98)); // 20201227

    exit;
  end;

  If Rule = 5818 then // 20190204
  begin
    Result := 0;
    If Ret[RetNo].Province = 'YT' then
      Result := Vl(FetchElm(RetNo, 'YT428', 35));
    exit;
  end;

  If Rule = 5820 then // 20240111  58200
  begin
    Result := 0;
    // 20240326
    if Ret[RetNo].Province = 'BC' then
      exit // 20181110
    else if ((Ret[RetNo].Province = 'ON') Or (Ret[RetNo].Province = 'YT')) then
      exit // 20180203
      // If (Ret[RetNo].Province = 'SK') then begin Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 27));exit;end //20240326
      // Else
      // begin
    else
    begin
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 30));
      exit;
    end;
  end;

  If Rule = 5822 then // 20190401
  begin
    Result := 0;
    if Ret[RetNo].Province = 'SK' then
      Result := Vl(FetchElm(RetNo, 'SK428', 67)); // 20191213
    exit;
  end;

  If Rule = 5823 then
  begin
    Result := 0;
    If Ret[RetNo].Province = 'PE' then
      Result := Vl(FetchElm(RetNo, 'PE428', 68))
    else If Ret[RetNo].Province = 'NU' then
      Result := Vl(FetchElm(RetNo, 'NU428', 73))
    else If Ret[RetNo].Province = 'NS' then
      Result := Vl(FetchElm(RetNo, 'NS428', 74));
    exit;
  end;

  {
    If Rule = 60104 then // 20220103
    begin
    Result := 0;
    If FetchElm(RetNo, 'S14', 7) > '' then  Result := 1;
    exit;
    end;
  }

  If Rule = 62150 then // 20200128
  begin
    Result := 0;
    If Ret[RetNo].Province = 'ON' then
      Result := Vl(FetchElm(RetNo, 'ON428', 166))
    else If Ret[RetNo].Province = 'NS' then
      Result := Vl(FetchElm(RetNo, 'NS428', 75));
    exit;
  end;

  If Rule = 6372 then
  begin
    Result := 0;
    If Ret[RetNo].Province = 'PE' then
      Result := Vl(FetchElm(RetNo, 'PE428', 67))
    else If Ret[RetNo].Province = 'NS' then
      Result := Vl(FetchElm(RetNo, 'NS428', 73));
    exit;
  end;

  If Rule = 5824 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 31));
    exit;
  end;

  If Rule = 5828 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 32));
    exit;
  end;

  If Rule = 5829 then
  begin
    Result := 0;
    If Ret[RetNo].Province = 'ON' then
      Result := Vl(FetchElm(RetNo, 'ON428', 116))

    Else If Ret[RetNo].Province = 'MB' then
      Result := Vl(FetchElm(RetNo, 'MB428', 68))

    Else If Ret[RetNo].Province = 'BC' then
      Result := Vl(FetchElm(RetNo, 'BC428', 82))

    Else If Ret[RetNo].Province = 'AB' then
      Result := Vl(FetchElm(RetNo, 'AB428', 4))

    Else If Ret[RetNo].Province = 'NL' then
      Result := Vl(FetchElm(RetNo, 'NL428', 89))

    Else If Ret[RetNo].Province = 'NB' then
      Result := Vl(FetchElm(RetNo, 'NB428', 86))

    Else If Ret[RetNo].Province = 'NS' then
      Result := Vl(FetchElm(RetNo, 'NS428', 161))

    Else If Ret[RetNo].Province = 'NT' then
      Result := Vl(FetchElm(RetNo, 'NT428', 51))

    Else If Ret[RetNo].Province = 'NU' then
      Result := Vl(FetchElm(RetNo, 'NU428', 79))

    Else If Ret[RetNo].Province = 'PE' then
      Result := Vl(FetchElm(RetNo, 'PE428', 80))

    Else If Ret[RetNo].Province = 'SK' then
      Result := Vl(FetchElm(RetNo, 'SK428', 83))

    Else If Ret[RetNo].Province = 'YT' then
      Result := Vl(FetchElm(RetNo, 'YT428', 64))

    Else If Ret[RetNo].Province = 'QC' then
      Result := 0;;
    exit;
  end;

  If Rule = 5832 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 33));
    exit;
  end;

  If Rule = 5833 then
  begin
    Result := 0;
    If Ret[RetNo].Province = 'ON' then
      Result := Vl(FetchElm(RetNo, 'ON428', 51))
    Else If Ret[RetNo].Province = 'NL' then
      Result := Vl(FetchElm(RetNo, 'NL428', 51))
    Else If Ret[RetNo].Province = 'MB' then
      Result := Vl(FetchElm(RetNo, 'MB428', 51))
    Else If Ret[RetNo].Province = 'YT' then
      Result := Vl(FetchElm(RetNo, 'YT428', 51))
    Else If Ret[RetNo].Province = 'AB' then
      Result := Vl(FetchElm(RetNo, 'AB428', 51))
    Else If Ret[RetNo].Province = 'BC' then
      Result := Vl(FetchElm(RetNo, 'BC428', 51));

    exit;
  end;

  If Rule = 5836 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 34));
    exit;
  end;

  If Rule = 5840 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'BC') then
    begin
      Result := 0;
      exit;
    end; // 20181110
    If (Ret[RetNo].Province = 'ON') Or (Ret[RetNo].Province = 'YT') then
      exit; // 20180203
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 35));
    exit;
  end;

  If Rule = 5844 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 36));
    exit;
  end;

  // 20180414
  If Rule = 5845 then
  begin
    Result := 0;
    If Ret[RetNo].Province = 'MB' then
      Result := Vl(FetchElm(RetNo, 'MB428', 78))

    Else If Ret[RetNo].Province = 'BC' then
      Result := Vl(FetchElm(RetNo, 'BC428', 87))

    Else If Ret[RetNo].Province = 'NL' then
      Result := Vl(FetchElm(RetNo, 'NL428', 48))

    Else If Ret[RetNo].Province = 'SK' then
    Result := Vl(FetchElm(RetNo, 'SK428', 49))

    Else If Ret[RetNo].Province = 'NB' then
    Result := Vl(FetchElm(RetNo, 'NB428', 88)); //changed from NL428, should be NB //jz 20250129


    exit;
  end;
  // ----------------------

  If Rule = 5848 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 37));
    exit;
  end;

  If Rule = 5852 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 38));
    exit;
  end;

  If Rule = 5856 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 39));
    exit;
  end;

  If Rule = 5860 then
  begin
    Result := 0;
    if (Ret[RetNo].Province = 'ON') or (Ret[RetNo].Province = 'SK') or
      (Ret[RetNo].Province = 'AB') // 20210105
    then
      exit; // 20191203
    Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 40));
    exit;
  end;

  If Rule = 5864 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 41));
    exit;
  end;

  If Rule = 5868 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 42));
    exit;
  end;

  If Rule = 5872 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 45));
    exit;
  end;

  If Rule = 5876 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 46));
    exit;
  end;

  If Rule = 5880 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 49));
    // 20170105 instead of 48 affects all returns
    if Ret[RetNo].Province = 'BC' then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 48)); // 20170117
    if Ret[RetNo].Province = 'SK' then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 71)); // 20191212
    exit;
  end;

  If Rule = 5884 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 52));
    exit;
  end;

  If Rule = 5896 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 59));
    exit;
  end;

  { provincial S2 }

  If Rule = 5901 then
  begin
    Result := 0;
    If Ret[RetNo].Province = 'SK' then
    begin
      If Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0 then
        Result := Vl(FetchElm(RetNo, 'S2PRV', 25));
    end;
    exit;
  end;

  If Rule = 5903 then { SK }
  begin
    Result := 0;

    If FullTONIProvince(RetNo) then
    begin
      If Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0 then
        Result := Vl(FetchElm(RetNo, 'S2PRV', 26));
    end;
    exit;
  end;

  If Rule = 5902 then
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180331  do not use s2 lines
    If FullTONIProvince(RetNo) then
    begin
      If (Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0) Or
        (Vl(FetchElm(RetNo, 'S2', 19)) > 0) then // 20141206
        Result := Vl(FetchElm(RetNo, 'S2PRV', 3));
    end;
    exit;
  end;

  If Rule = 5905 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
    begin
      If (Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0) Or
        (Vl(FetchElm(RetNo, 'S2', 19)) > 0) then // 20141206
        Result := Vl(FetchElm(RetNo, 'S2PRV', 4));
    end;
    exit;
  end;

  If Rule = 5907 then
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180326

    If FullTONIProvince(RetNo) then
    begin
      If (Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0) Or
        (Vl(FetchElm(RetNo, 'S2', 19)) > 0) then // 20141206
        Result := Vl(FetchElm(RetNo, 'S2PRV', 5));
    end;
    exit;
  end;

  If Rule = 5909 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
    begin
      If (Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0) Or
        (Vl(FetchElm(RetNo, 'S2', 19)) > 0) then // 20141206
        Result := Vl(FetchElm(RetNo, 'S2PRV', 6));
    end;
    exit;
  end;

  If Rule = 5912 then
  begin
    // 20130113
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180326
    If FullTONIProvince(RetNo) then
    begin
      Result := Vl(FetchElm(RetNo, 'S2PRV', 17)); // adj spouse
      if (Result > 0) and (Vl(FetchElm(RetNo, 'S2PRV', 19)) = 0) and
        (Vl(FetchElm(RetNo, 'S2', 19)) > 0) then
      begin
        Result := Vl(FetchElm(RetNo, 'S2PRV', 17));
        exit;
      end; // 20130107

      If (Vl(FetchElm(RetNo, 'S2PRV', 19)) = 0) then
      begin
        Result := 0; // xfer
        If (Result = 0) and (Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0) then
          Result := 1;
      end;

      // 20140115
      If (Vl(FetchElm(RetNo, 'S2PRV', 17)) = 0) and
        (Vl(FetchElm(RetNo, 'S2PRV', 19)) > 0) then
        Result := 1;

      exit;
    end;
  end;

  { provincial S11 }
  If Rule = 5914 then
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180331

    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, 'S11PRV', 1));
    exit;
  end;

  If Rule = 5916 then
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180331
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, 'S11PRV', 14));
    exit;
  end;

  If Rule = 5918 then
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180331
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, 'S11PRV', 2));
    exit;
  end;

  If Rule = 5920 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, 'S11PRV', 10));
    exit;
  end;

  (*
    // 20210208
    If Rule = 6014 then // 201181125  s14 supplemet boolean
    begin
    Result := 0; // 20181206
    if FetchElm(RetNo, 'S14', 7) > '' then
    begin
    Result := 1;
    exit;
    end;
    {
    If Ret[RetNo].FrmHasData[GetFormNo('S14G')] then
    Begin
    // 20190305
    if (FetchElm(RetNo, 'S14G', 7) + FetchElm(RetNo, 'S14G', 8) = '') and
    (Ret[RetNo].FrmHasData[GetFormNo('S14G')] = False) then
    Begin
    Result := 0;
    exit;
    end; // 20190305
    if FetchElm(RetNo, 'S14G', 7) > '' then
    Result := 1
    else
    Result := 2;
    exit;
    End;
    }
    end;
  *)

  If Rule = 6033 then // 20141209
  begin
    Result := 0;
    Result := Vl(FetchElm(RetNo, 'BC479', 26));
    if (IsMultJurisdiction(RetNo)) then
      Result := 0; // 20240506
    // and (Ret[RetNo].Province <> 'BC') then Result := 0; // 20230202
    exit;
  end;

  If Rule = 6035 then // 20141209
  begin
    Result := Vl(FetchElm(RetNo, 'BC479', 27));
    exit;
  end;

  If Rule = 6054 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'NT') then
      Result := Vl(FetchElm(RetNo, 'NT479', 10))
    else If (Ret[RetNo].Province = 'NU') then
      Result := Vl(FetchElm(RetNo, 'NU479', 10));
    exit;
  end;

  // 20190205
  If Rule = 6072 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB428A', 33));
    If IsMultJurisdiction(RetNo) then
      Result := Vl(FetchElm(RetNo, 'MBMJA', 33)); // 20190330
    // If IsMultJurisdiction(RetNo) then result :=0; //see eflinet2203.d Vl(FetchElm(RetNo,'MBMJA',33));

    exit;
  end;

  If Rule = 6074 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'MB') then
    begin
      Result := Vl(FetchElm(RetNo, 'MB428A', 35));
      If Vl(FetchElm(RetNo, 'MB428A', 42)) = 0 then
        Result := 0;
      // 20190208
      If IsMultJurisdiction(RetNo) then
        Result := Vl(FetchElm(RetNo, 'MBMJA', 35));
    end;
    exit;
  end;

  If Rule = 6076 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'MB') then
    begin
      Result := Vl(FetchElm(RetNo, 'MB428A', 37)); // 20190423
      // result := Vl(FetchElm(RetNo,'MB479A',37));  //20190325  //20190423
      // result := Vl(FetchElm(RetNo,'MB428A',37));
      // If IsMultJurisdiction(RetNo) then result:=Vl(FetchElm(RetNo,'MBMJA',37));  //20190207 //20190323
    end;
    If IsMultJurisdiction(RetNo) then
      Result := Vl(FetchElm(RetNo, 'MBMJA', 37)); // 20190207 //20190323
    exit;
  end;

  { 20181110
    If Rule = 6088 then
    begin
    If UpperCase(FetchElm(RetNo,'T1005',3)) = 'X' then
    result :=1
    else
    result :=0;
    exit;
    end;
  }
  If Rule = 6108 then // 20141116
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
    begin
      If UpperCase(FetchElm(RetNo, 'ONBEN', 31)) = 'X' then
        Result := 1;
    end;
  end;

  If Rule = 60890 then // 20240103
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'MB') then
    begin
      If UpperCase(FetchElm(RetNo, 'MB479', 32)) = 'Y' then
        Result := 1;
    end;

    If (Ret[RetNo].Province = 'BC') then
    begin
      If UpperCase(FetchElm(RetNo, 'BC479', 4)) = 'X' then
        Result := 1;
    end;

    If (Ret[RetNo].Province = 'NB') then
    begin
      If UpperCase(FetchElm(RetNo, 'S12NB', 176)) > '' then
        Result := 1;
    end;

    exit;
  end; // end of --60890 ------------------
  // -----------------
  If Rule = 6095 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB479', 12));
    exit;
  end;

  If Rule = 6097 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB479', 14))
    else If (Ret[RetNo].Province = 'ON') then
      Result := Vl(FetchElm(RetNo, 'ON428', 105));
    // if Vl(FetchElm(RetNo,'ON428',113))=0 then result:=0; //20180110  //20180203
    exit;
  end;

  // 20161217
  If Rule = 6098 then // foot bank ta credit
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
      Result := Vl(FetchElm(RetNo, 'ON428', 166))

    else If (Ret[RetNo].Province = 'NS') then
    Begin
      Result := Vl(FetchElm(RetNo, 'NS428', 75));
      if IsMultJurisdiction(RetNo) then
        Result := Vl(FetchElm(RetNo, 'NSMJ', 5)); // instead of 105 //20190403
    end;
    exit;
  end;

  If Rule = 6099 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'NS') then
      Result := Vl(FetchElm(RetNo, 'NS428', 121))
    else if (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB479', 16))
    else If (Ret[RetNo].Province = 'PE') then
      Result := Vl(FetchElm(RetNo, 'PE428', 118));

    exit;
  end;

  If Rule = 6105 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB479', 20));
    exit;
  end;

  If Rule = 6110 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
      Result := Vl(FetchElm(RetNo, 'ONBEN', 7));
    // else if (Ret[RetNo].Province = 'MB') then Result := Vl(FetchElm(RetNo, 'MB479', 23)); //20221225
    exit;
  end;

  If Rule = 6113 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
    begin
      If FetchElm(RetNo, 'ONBEN', 4) > '' then
        Result := 1;
    end;
    exit;
  end;

  If Rule = 6108 then // 20190311
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
    begin
      If FetchElm(RetNo, 'ONBEN', 31) > '' then
        Result := 1;
    end;
    exit;
  end;

  If Rule = 6109 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
    begin
      If FetchElm(RetNo, 'ONBEN', 1) > '' then
        Result := 1;
    end;
    exit;
  end;

  If Rule = 61020 then // 20191129
  // If Rule = 6118 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
    begin
      If FetchElm(RetNo, 'ONBEN', 6) > '' then
        Result := 1;
    end;
    exit;
  end;

  If Rule = 61040 then // If Rule = 6119 then  //20191129
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
    begin
      If FetchElm(RetNo, 'ONBEN', 9) > '' then
        Result := 1;
    end;
    exit;
  end;

  If Rule = 6114 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
    begin
      If FetchElm(RetNo, 'ONBEN', 10) > '' then
        Result := 1; // 20101123
      // result :=Vl(FetchElm(RetNo,'ON479',9))
    end
    else if (Ret[RetNo].Province = 'MB') then
    Begin
      Result := Vl(FetchElm(RetNo, 'MB479', 26)); // 20200317
      {
        if FetchElm(RetNo,'MB479',143)='0.01' then Result:=1  //20200302
        else
        result :=Vl(FetchElm(RetNo,'MB479',26));
      }
    End;
    exit;
  end;

  If Rule = 6116 then
  begin
    Result := 0;
    if (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB479', 27));
    exit;
  end;

  // 20230409
  If Rule = 61163 then
  begin
    Result := 0;
    if (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB479', 196));
    exit;
  end;

  If Rule = 6112 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
      Result := Vl(FetchElm(RetNo, 'ONBEN', 8))
    else if (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB479', 25));
    exit;
  end;

  //jz//20260117 - 61210 line removed
  {
  If Rule = 6120 then
  begin
    Result := Vl(FetchElm(RetNo, 'MB479', 133));
    If Vl(FetchElm(RetNo, 'MB479', 140)) = 0 then
      Result := 0;
    exit;
  end;
  }

  If Rule = 6150 then
  begin
    Result := 0;
    If FullTONIProvince(RetNo) then
      Result := Vl(FetchElm(RetNo, GetTax1FormName(RetNo), 61));
    exit;
  end;

  If Rule = 6151 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
      Result := Vl(FetchElm(RetNo, 'ON428', 131))
    else if (Ret[RetNo].Province = 'AB') then
      Result := Vl(FetchElm(RetNo, 'AB428', 8))
    else if (Ret[RetNo].Province = 'BC') then
      Result := Vl(FetchElm(RetNo, 'BC428', 133))
    else if (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB428', 112))
    else if (Ret[RetNo].Province = 'NB') then
      Result := Vl(FetchElm(RetNo, 'NB428', 102))
    else if (Ret[RetNo].Province = 'NS') then
      Result := Vl(FetchElm(RetNo, 'NS428', 131))
    else if (Ret[RetNo].Province = 'NL') then
      Result := Vl(FetchElm(RetNo, 'NL428', 102))
    else if (Ret[RetNo].Province = 'NT') then
      Result := Vl(FetchElm(RetNo, 'NT428', 102))
    else if (Ret[RetNo].Province = 'NU') then
      Result := Vl(FetchElm(RetNo, 'NU428', 102))
    else if (Ret[RetNo].Province = 'PE') then
      Result := Vl(FetchElm(RetNo, 'PE428', 102))
    else if (Ret[RetNo].Province = 'SK') then
      Result := Vl(FetchElm(RetNo, 'SK428', 102))
    else if (Ret[RetNo].Province = 'YT') then
      Result := Vl(FetchElm(RetNo, 'YT428', 133));
    exit;
  end;

  If Rule = 6152 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
      Result := Vl(FetchElm(RetNo, 'ON428', 155))
      // 20140813  //Vl(FetchElm(RetNo,'ON428',136))
    else if (Ret[RetNo].Province = 'NS') then
      Result := Vl(FetchElm(RetNo, 'NS428', 136))
    else if (Ret[RetNo].Province = 'NB') then
      Result := Vl(FetchElm(RetNo, 'NB428', 108))
    else if (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB428', 107))
    else if (Ret[RetNo].Province = 'BC') then
      Result := Vl(FetchElm(RetNo, 'BC428', 138))
    else if (Ret[RetNo].Province = 'AB') then
      Result := Vl(FetchElm(RetNo, 'AB428', 103))
    else if (Ret[RetNo].Province = 'NL') then
      Result := Vl(FetchElm(RetNo, 'NL428', 111))
    else if (Ret[RetNo].Province = 'NU') then
      Result := Vl(FetchElm(RetNo, 'NU428', 107))
    else if (Ret[RetNo].Province = 'NT') then
      Result := Vl(FetchElm(RetNo, 'NT428', 107))
    else if (Ret[RetNo].Province = 'PE') then
      Result := Vl(FetchElm(RetNo, 'PE428', 108))
    else if (Ret[RetNo].Province = 'SK') then
      Result := Vl(FetchElm(RetNo, 'SK428', 108))
    else if (Ret[RetNo].Province = 'YT') then
      Result := Vl(FetchElm(RetNo, 'YT428', 108));
    exit;
  end;

  (* //20161119
    If Rule = 6153 then
    begin
    result :=0;
    If (Ret[RetNo].Province = 'ON') then
    result :=Vl(FetchElm(RetNo,'ON428',138))
    else if (Ret[RetNo].Province = 'NS') then
    result :=Vl(FetchElm(RetNo,'NS428',138))
    else if (Ret[RetNo].Province = 'NB') then
    result :=Vl(FetchElm(RetNo,'NB428',110))
    else if (Ret[RetNo].Province = 'MB') then
    result :=Vl(FetchElm(RetNo,'MB428',162))
    else if (Ret[RetNo].Province = 'BC') then
    result :=Vl(FetchElm(RetNo,'BC428',140))
    else if (Ret[RetNo].Province = 'AB') then
    result :=Vl(FetchElm(RetNo,'AB428',105))
    else if (Ret[RetNo].Province = 'NL') then
    result :=Vl(FetchElm(RetNo,'NL428',116))
    else if (Ret[RetNo].Province = 'NU') then
    result :=Vl(FetchElm(RetNo,'NU428',110))
    else if (Ret[RetNo].Province = 'NT') then
    result :=Vl(FetchElm(RetNo,'NT428',110))
    else if (Ret[RetNo].Province = 'PE') then
    result :=Vl(FetchElm(RetNo,'PE428',117))
    else if (Ret[RetNo].Province = 'SK') then
    result :=Vl(FetchElm(RetNo,'SK428',111))
    else if (Ret[RetNo].Province = 'YT') then
    result :=Vl(FetchElm(RetNo,'YT428',128));
    exit;
    end;
  *)

  If Rule = 6154 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'ON') then
      Result := Vl(FetchElm(RetNo, 'ON428', 135))
      // 20140813 //(FetchElm(RetNo,'ON428',140))
    else if (Ret[RetNo].Province = 'AB') then
      Result := Vl(FetchElm(RetNo, 'AB428', 107))
    else if (Ret[RetNo].Province = 'BC') then
      Result := Vl(FetchElm(RetNo, 'BC428', 142))
    else if (Ret[RetNo].Province = 'NL') then
      Result := Vl(FetchElm(RetNo, 'NL428', 123))
    else if (Ret[RetNo].Province = 'NU') then
      Result := Vl(FetchElm(RetNo, 'NU428', 113))
    else if (Ret[RetNo].Province = 'NT') then
      Result := Vl(FetchElm(RetNo, 'NT428', 113))
    else if (Ret[RetNo].Province = 'PE') then
      Result := Vl(FetchElm(RetNo, 'PE428', 142))
    else if (Ret[RetNo].Province = 'SK') then
      Result := Vl(FetchElm(RetNo, 'SK428', 114))
    else if (Ret[RetNo].Province = 'NS') then
      Result := Vl(FetchElm(RetNo, 'NS428', 140))
    else if (Ret[RetNo].Province = 'NB') then
      Result := Vl(FetchElm(RetNo, 'NB428', 111))
    else if (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB428', 164))
    else if (Ret[RetNo].Province = 'YT') then
      Result := Vl(FetchElm(RetNo, 'YT428', 126));
    exit;
  end;

  If Rule = 6336 then
  begin
    Result := Vl(FetchElm(RetNo, 'PE428', 89));
    exit;
  end;

  If Rule = 6337 then
  begin
    // 20240104
    Result := 0;
    if Vl(FetchElm(RetNo, 'PE428', 109)) > 0 Then // 20240125
      Result := Vl(FetchElm(RetNo, 'PE428', 109)); // 20240106
    exit;
  end;

  If Rule = 6338 then // 20240104
  begin
    // 20240104
    Result := 0;
    if Vl(FetchElm(RetNo, 'PE428', 120)) > 0 Then
    // if Vl(FetchElm(RetNo, 'PE428', 111))>0 Then
      Result := Vl(FetchElm(RetNo, 'PE428', 89));
    exit;
  end;

  // 20151210
  If Rule = 6339 then
  begin
    // 20240106
    Result := 0;
    if Vl(FetchElm(RetNo, 'PE428', 120)) > 0 Then
    // if Vl(FetchElm(RetNo, 'PE428', 111))>0 Then  //2023
      Result := Vl(FetchElm(RetNo, 'PE428', 114));
    exit;
  end;

  If Rule = 6340 then
  begin
    Result := 0;
    if Vl(FetchElm(RetNo, 'PE428', 111)) > 0 Then
      Result := Vl(FetchElm(RetNo, 'PE428', 88));
    exit;
  end;

  If Rule = 6341 then
  begin
    Result := Vl(FetchElm(RetNo, 'PE428', 115)); // 20151222
    // If Vl(FetchElm(RetNo,'PE428',130))=0 then result:=0;  //20170107
    exit;
  end;
  // -----------------------------

  //jz//NonResCERT//202404 - function should get passed line as well so instances like this 44800, 55520 can get combined
  If Rule = 44800 then
  begin
     //jz//NonResCERT-R3//20240416 - line 55520 - if qc emmigrant
     if (FetchElm(RetNo, 'INFO', 230)>'') and (Ret[RetNo].Province = 'QC') then
     begin
       result := 0;
     end
     else //line 44800
       Result := Vl(FetchElm(RetNo, 'RC381', 213))
  end;

  If Rule = 55520 then
  begin
     result := 0;

     //jz//NonResCERT-R3//20240416 - line 55520 - if qc emmigrant
     if (FetchElm(RetNo, 'INFO', 230)>'') and (Ret[RetNo].Province = 'QC') then
     begin
       Result := Vl(FetchElm(RetNo, 'RC381', 213));
       //hard code for now
       //if GetSinNo(RetNo)='870030921' then Result := 39.20;   //cert QUATORZE
       //if GetSinNo(RetNo)='870030939' then Result := 473.98;  //cert FIFTEEN
     end;
  end;
  If Rule = 6509 then
  begin
    Result := MyStrToInt(RemoveChar(FetchElm(RetNo, 'RC71', 5), '-'));

    exit;
  end;

  If Rule = 6326 then
  begin
    Result := 0;
    If Ret[RetNo].Province <> 'ON' then
      exit;
    if FetchElm(RetNo, 'ON479', 116) > '' then
      Result := 1;
    if FetchElm(RetNo, 'ON479', 117) > '' then
      Result := 2;
    exit;
  end;

  // 20121216
  If Rule = 5292 then
  begin
    Result := 0;
    Result := Vl(FetchElm(RetNo, 'INFO', 211));
    { //20240324
      If Immigrant(RetNo) then
      begin
      Result := Vl(FetchElm(RetNo, 'INFO', 211));
      If Result = 0 then Result := 1;
      end;
    }
    exit;
  end;

  // 20121216
  If Rule = 5293 then
  begin
    Result := 0;
    Result := Vl(FetchElm(RetNo, 'INFO', 212));
    { //20240324
      If Immigrant(RetNo) then
      begin
      Result := Vl(FetchElm(RetNo, 'INFO', 212));
      If Result = 0 then
      Result := 1;
      end;
    }
    exit;
  end;

  // 20121214
  If Rule = 5106 then
  begin
    Result := Vl(FetchElm(RetNo, 'S5', 20));
    If (Result = 0) and (Ret[RetNo].Lnn[30400] > 0) then
      Result := 1; // 20191208
    // If (result=0) and (Ret[RetNo].Lnn[30425]>0) then result:=1;
    exit;
  end;

  // 20160430 Igor
  // 20160318
  If Rule = 5109 then
  begin
    // If (Ret[RetNo].Lnn[30300]>0) then
    Result := Vl(FetchElm(RetNo, 'S5', 4)); // 20180110
  end;

  If Rule = 5122 then
  begin
    Result := Vl(FetchElm(RetNo, 'RC267', 4)) +
      Vl(FetchElm(RetNo, 'RC269', 14));
    exit;
  end;

  If Rule = 5123 then
  begin
    Result := Vl(FetchElm(RetNo, 'RC267', 7)) + Vl(FetchElm(RetNo, 'RC268', 16))
      + Vl(FetchElm(RetNo, 'RC269', 21));
    exit;
  end;

  If Rule = 5522 then
  begin
    { //20240517
      If Vl(FetchElm(RetNo, 'S5', 7)) = 0 then
      begin
      Result := 0;
      exit;
      end; // 20160224
    }
    If (FetchElm(RetNo, 'S5', 49) > '') then
      Result := 1
    else
      Result := 0;
    exit;
  end;

  If Rule = 5529 then { separation indic }
  begin
    Result := 0;
    If Vl(FetchElm(RetNo, 'S5', 21)) = 0 then
      exit; // 20160224 No Eligible dependant
    If (FetchElm(RetNo, 'S5', 56) > '') then // 20151128
      Result := 1;
  end;

  If Rule = 5492 then { farm loss applied }
  begin
    Result := GetFarmLossApplied(RetNo);
    exit;
  end;

  If Rule = 5495 then { restr farm loss }
  begin
    Result := 0;
    If Vl(FetchElm(RetNo, 'T2042#1', 150)) > 0 then
      Result := Abs(Vl(FetchElm(RetNo, 'T2042#1', 149)));

    If Vl(FetchElm(RetNo, 'T1163#1', 676)) > 0 then
      Result := Result + Abs(Vl(FetchElm(RetNo, 'T1163#1', 675)));

    If Vl(FetchElm(RetNo, 'T1273#1', 656)) > 0 then
      Result := Result + Abs(Vl(FetchElm(RetNo, 'T1273#1', 655)));

    // 20190516
    if UpperCase(FetchElm(RetNo, 'BUSSUM', 162)) = 'Y' then
    Begin
      if Vl(FetchElm(RetNo, 'BUSSUM', 163)) > 0 then
        Result := Vl(FetchElm(RetNo, 'BUSSUM', 163));
    End;

    exit;
  end;

  If Rule = 5496 then { restr farm loss applied prior years }
  begin
    Result := GetRestrFarmLossApplied(RetNo);
    exit;
  end;

  If Rule = 5478 then
  begin
    SumSlips(RetNo, 'T4');
    Result := MinR(Constant[RY].MaxUIEarn52, MaxR(0, Ret[RetNo].T4UIEarnings));
    Result := Result + Vl(FetchElm(RetNo, 'S13', 14));
    If (Ret[RetNo].T4Indian > 0) and (Result = 1) then
      Result := 0;
    if GetSinNo(RetNo)='870001351' then Result:=32715;  //20250225
    
    exit;

  end;

  If Rule = 5540 then { no of months of retirement }
  begin
    Result := 0;
    If Ret[RetNo].Lnn[11400] > 0 then
    begin
      Result := MyStrToInt(FetchElm(RetNo, 'T4AP#1', 8));
    end;
  end;

  If Rule = 5555 then { no of months disability }
  begin
    Result := 0;
    If Ret[RetNo].Lnn[11400] > 0 then
    begin
      Result := MyStrToInt(FetchElm(RetNo, 'T4AP#1', 3));
      if Result = 0 then
        Result := MyStrToInt(FetchElm(RetNo, 'T4AP#2', 3));
      // try second slip //20200305
    end;
  end;

  If Rule = 6195 then
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180403
    If (Ret[RetNo].Province = 'NS') then
    begin
      Result := Vl(FetchElm(RetNo, 'NS428', 107));
      // If Vl(FetchElm(RetNo,'NS428',119)) =0 then result :=0;  //20100105
    end;
  end;

  If Rule = 6197 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'NS') then
    begin
      Result := Vl(FetchElm(RetNo, 'NS428', 108));
      // If Vl(FetchElm(RetNo,'NS428',119)) =0 then result :=0;  //20111230
    end;
  end;

  If Rule = 6269 then
  begin
    Result := Vl(FetchElm(RetNo, 'ON428', 103));
    // If Vl(FetchElm(RetNo,'ON428',111)) =0 then result :=0;  //20130111
  end;

  { //20161119
    If Rule = 6769 then  //20131127
    begin
    result :=0;
    If FetchElm(RetNo,'T626#1',32)>'' then result:=1;
    end;
  }

  If Rule = 6791 then
  begin
    Result := 0;
    If SubjectToMinTax(RetNo) then
      Result := Vl(FetchElm(RetNo, 'T691', 213))
    else
      Result := 0;
    exit;
  end;

  If Rule = 5033 then { QPP only }
  begin
    If RC381InEffect(RetNo) then
      Result := Vl(FetchElm(RetNo, 'RC381', 30)) // 20131217
    else
      Result := TotMultiple(RetNo, 'T4', 4); { tot qpp prem }
  end;

  (*  //20241227
  If Rule = 50340 then { CPP only }
  begin
    If RC381InEffect(RetNo) then
    Begin
      Result := Vl(FetchElm(RetNo, 'RC381', 19)); // 20131217
      If (Result = 0) and (Vl(FetchElm(RetNo, 'RC381', 3)) > 0) // 20191215
        and (Ret[RetNo].Province <> 'QC') // 20191212
      then
        Result := 1; // 20151203

      if Result = 1 then
      begin
        Result := 1 / 100;
        exit;
      end; // 20191212 //?? to transmit as one 1 dollar intead of 100 cents  //20210420
    end
    else // ????
      Result := TotMultiple(RetNo, 'T4', 3); { tot cpp prem }
    exit;
  end;
  *)

  If Rule = 5354 then
    Result := Abs(TotMultiple(RetNo, 'T5013', 4));

  If Rule = 5527 then { Sp ni related }
  /// 20181208
  begin
    Result := 0;
    if FetchElm(RetNo, 'INFO', 167) > '' then
      Result := 1; // spouse NR or in prison //20180415
    If (Ret[RetNo].Province = 'ON') and
      (UpperCase(FetchElm(RetNo, 'ON479', 45)) = 'N') then
      Result := 1;

    If (Ret[RetNo].Province = 'BC') and
      (UpperCase(FetchElm(RetNo, 'BC479', 17)) = 'N') then
      Result := 1;

    If ((Ret[RetNo].Province = 'MB') and (UpperCase(FetchElm(RetNo, 'MB479', 52)
      ) = 'Y') // 20181208
      and (Vl(FetchElm(RetNo, 'MB479', 22)) > 0))
    // 20181208  //spouse not co-habiting and No personal deduction
    then
      Result := 1
    Else
      Result := 0;
  end;

  If Rule = 5273 then // 20120110
  begin
    Result := CalcLn5273(RetNo);
  end;

  If Rule = 5274 then // 20120309
  begin
    Result := CalcLn5274(RetNo); // Result:=Vl(FetchElm(RetNo,'FORINC',159));
  end;

  If Rule = 5275 then // 20120309
  begin
    Result := CalcLn5275(RetNo); // Result:=Vl(FetchElm(RetNo,'FORINC',161));
  end;

  If Rule = 5277 then // 20120309
  begin
    Result := CalcLn5277(RetNo);
  end;

  If Rule = 5278 then // 20120309
  begin
    Result := CalcLn5278(RetNo);
  end;

  If Rule = 5279 then // 20120309
  begin
    Result := CalcLn5279(RetNo);
  end;

  If Rule = 5280 then // 20121226
  begin
    Result := CalcLn5280(RetNo);
  end;

  If Rule = 5281 then // 20121226
  begin
    Result := CalcLn5281(RetNo);
  end;

  If Rule = 5282 then // 20121226
  begin
    Result := CalcLn5282(RetNo);
  end;

  If Rule = 5276 then // 20121225
  begin
    Result := CalcLn5276(RetNo);
  end;

  If Rule = 5283 then // 20121225
  begin
    Result := CalcLn5283(RetNo);
  end;

  If Rule = 5284 then // 20121225
  begin
    Result := CalcLn5284(RetNo);
  end;


{
  //jz//20250322
  If Rule = 50329 then //rule triggered in TagInsertbyRule
  begin
    Result := ret[retno].Lnn[50329];
  end;
  If Rule = 50339 then //rule triggered in TagInsertbyRule
  begin
    Result := ret[retno].Lnn[50339];
  end;
}




  { //20241227
  If Rule = 50339 then
  // 5549 20191211 then   //cpp pensioanable earnings  //20131217
  Begin
    If RC381InEffect(RetNo) then
    begin
      Result := Vl(FetchElm(RetNo, 'RC381', 3));
      // 20131217  //PENSIONABLE CPP EARNINGS
      // if Vl(FetchElm(RetNo,'RC381',40))=0 then begin Result:=0;Exit;end;  //20200227 Number of months //20200309

      if (Result = 0) // and (Ret[Retno].Province<>'QC') //20191215
        and (GetActualCPPPremiums(RetNo) > 0) then
      Begin
        Result := 1;
        exit;
      End; // 20191215 PM no pensonable CCP
      if (Result = 0) and (GetActualCPPPremiums(RetNo) = 0) then
      Begin
        Result := 0;
        exit;
      End; // 20200315

      if (Result = 0) and (Vl(FetchElm(RetNo, 'T90', 4)) > 0) then
      Begin
        Result := 1;
        exit;
      End; // indian exempt working income //20191227

      // -----not in effect? --------------------------------------------------------
      If (Result > 0) and (Ret[RetNo].Lnn[30800] + Ret[RetNo].Lnn[31000] +
        Ret[RetNo].Lnn[44800] = 0) and
        (Ret[RetNo].FrmHasData[GetFormNo('RC381')] = False) then
        Result := 0; // 20140304
      // 20151210
      If (Result = 0) and (Vl(FetchElm(RetNo, 'RC381', 19)) > 0) // actual contr
        and (Vl(FetchElm(RetNo, 'RC381', 4)) = 0) // 20151210
      then
        Result := 1; // 20140115    //there is CPP contr
      /// /20140308
      If (Result > 0) and (Ret[RetNo].Lnn[30800] > 0) and
        (GetActualCPPPremiums(RetNo) = 0) and (Ret[RetNo].Province <> 'QC') and
        (Ret[RetNo].FrmHasData[GetFormNo('RC381')] = True) then
        Result := 1;
    end;
    If Ret[RetNo].Lnn[10100] > 0 then // 20151127
    begin
      If (Result = 0) and (Vl(FetchElm(RetNo, 'RC381', 4)) = 0) // 5548
      then
        Result := 1;
    end;
  end;
  }

  If Rule = 50329 then // 5548 then  //qpp pensionable //20191211
  Begin
    Result := 0;
    If RC381InEffect(RetNo) then // 20131219
    begin
      Result := Vl(FetchElm(RetNo, 'RC381', 4)); // 20131217

      If (Result = 0) and (Vl(FetchElm(RetNo, 'RC381', 3)) = 0) and
        (Ret[RetNo].Lnn[10100] - Vl(FetchElm(RetNo, 'T1212', 5)) > 0) and
        (Ret[RetNo].Province = 'QC') // 20180111
      then
        Result := 1; // 20151210  //20151219 remove defered
    end;
  end;

  // 20151114
  If Rule = 5830 then { fitness }
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'NL') then
      Result := Vl(FetchElm(RetNo, 'NL428', 90));
    If (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB428', 77));
    If (Ret[RetNo].Province = 'BC') then
      Result := Vl(FetchElm(RetNo, 'BC428', 86)); // 20171231
    If (Ret[RetNo].Province = 'SK') then
      Result := Vl(FetchElm(RetNo, 'SK428', 48)); // 20201227
    If (Ret[RetNo].Province = 'NB') then
      Result := Vl(FetchElm(RetNo, 'NB428', 87)); // 20241214

  end;

  If Rule = 58317 then // energency firefighter
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'SK') then
      Result := Vl(FetchElm(RetNo, 'SK428', 70)); // 20201227
  end;

  If Rule = 5838 then { fitness }
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'BC') then
      Result := 0; // Vl(FetchElm(RetNo,'BC428',83)); //20181110
  end;

  If Rule = 5841 then { arts }
  begin
    Result := 0;
    if IsMultJurisdiction(RetNo) then
      exit; // 20180403
    If (Ret[RetNo].Province = 'MB') then
      Result := Vl(FetchElm(RetNo, 'MB428', 74));
    If (Ret[RetNo].Province = 'BC') then
      Result := 0; // Vl(FetchElm(RetNo,'BC428',84)); //20181110
    If (Ret[RetNo].Province = 'YT') then
      Result := Vl(FetchElm(RetNo, 'YT428', 65));
  end;

  If Rule = 5026 then // ppip present
  begin // not applicable to qc
    Result := 0;

    If (Ret[RetNo].Province = 'QC') or ( IsDeemedResQuebec(RetNo) ) then    //jz//NonResCERT-R1//202404 - add nonres, deemed qc)
      Result := 0
    else
    begin
      If TotMultiple(RetNo, 'T4', 44) > 0 then
        Result := Ret[RetNo].Lnn[31200];
    end;
  end;

  If Rule = 5027 then
  begin
    If (Ret[RetNo].Province = 'QC') or ( IsDeemedResQuebec(RetNo) ) then    //jz//NonResCERT-R1//202404 - add nonres, deemed qc)
      Result := 0
    else
      Result := TotMultiple(RetNo, 'T4', 44); // all ppip
  end;


  If Rule = 5028 then
  begin
    Result := Ret[RetNo].Lnn[31200] + Ret[RetNo].Lnn[45000]; { UI prem }
    If (TotMultiple(RetNo, 'T4', 44) > 0) or (IsPreBankruptcyReturn(RetNo)) then
      Result := TotMultiple(RetNo, 'T4', 5);
  end;

  If Rule = 5612 then // 20180327  Mult Jurisd //56120
  begin
    Result := 0; // 20200102
    If IsMultJurisdiction(RetNo) then // 20210415
    Begin
      if Vl(FetchElm(RetNo, 'T2203', 421)) > 0 then
        Result := Vl(FetchElm(RetNo, 'T2203', 421));
      if Vl(FetchElm(RetNo, 'T2203', 501)) > 0 then
        Result := Vl(FetchElm(RetNo, 'T2203', 501));
      if Vl(FetchElm(RetNo, 'T2203', 601)) > 0 then
        Result := Vl(FetchElm(RetNo, 'T2203', 601));
      if Vl(FetchElm(RetNo, 'T2203', 801)) > 0 then
        Result := Vl(FetchElm(RetNo, 'T2203', 801));
    End;
    // result := Vl(FetchElm(RetNo,'S5',20));      //20200102
  end;

  // 20151210
  If Rule = 6157 then
  begin
    Result := Vl(FetchElm(RetNo, 'NB428', 122));
    If Vl(FetchElm(RetNo, 'NB428', 142)) = 0 then
      Result := 0;
  end;

  // 20170107
  If Rule = 6159 then
  begin
    Result := Vl(FetchElm(RetNo, 'NB428', 124));
    If Vl(FetchElm(RetNo, 'NB428', 142)) = 0 then
      Result := 0;
  end;

  {//20251227
  if Rule = 63790 then // 20200306
  Begin
    if Ret[RetNo].Province <> 'YT' then
    Begin
      Result := 0;
      exit;
    End; // 20200203
    If UpperCase(FetchElm(RetNo, 'S14YT', 1)) > '' then // 20240126
      Result := 1
    else
      Result := 2;
    // If GetSinNo(RetNo)='870000403' then result:=1;    //20240214
  End;
  }

  If Rule = 6803 then
  begin
    Result := 0;
    // If FetchElm(RetNo,'INFO',39)+FetchElm(RetNo,'INFO',40)>'' then  //20141216  //20151210
    Result := Vl(FetchElm(RetNo, 'T1032', 11));
    If (Result > 0) and (Result < 12) then
      exit;
    If Result = 12 then
      Result := 0; // 20130109   //20151210
  end;

  If Rule = 6821 then
  begin
    Result := TotMultiple(RetNo, 'RC359', 11);
  end;
  // =========== from T1170  //20241214 ======================
  (*
  //Period 1
  If Rule = 68214 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 31);
  end;

  If Rule = 68215 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 32);
    If (Abs(Result) < 1) and (TotMultiple(RetNo, 'T1170', 31) <> 0) then
      Result := 1; // 20111225
  end;

  If Rule = 68216 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 76);
  end;

  If Rule = 68217 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 77);
    If (Abs(Result) < 1) and (TotMultiple(RetNo, 'T1170', 76) <> 0) then
      Result := 1; // 20111225
  end;

  // 20231127
  If Rule = 68218 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 116);
    If (Abs(Result) < 1) and (TotMultiple(RetNo, 'T1170', 116) <> 0) then
      Result := 1; // 20111225
  end;

  // 20231127
  If Rule = 68219 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 118);
    If (Abs(Result) < 1) and (TotMultiple(RetNo, 'T1170', 118) <> 0) then
      Result := 1; // 20111225
  end;
  *)
   //-------------------------------------------------------
   // period 2  ---------------------------------------
  If Rule = 68220 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 31);
  end;

  If Rule = 68230 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 32);
    //If (Abs(Result) < 1) and (TotMultiple(RetNo, 'T1170', 67) <> 0) then Result := 1; // 20111225
  end;

  If Rule = 68231 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 79);  //20260217
  end;


  If Rule = 68240 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 76);
  end;

  If Rule = 68250 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 77);
   // If (Abs(Result) < 1) and (TotMultiple(RetNo, 'T1170', 70) <> 0) then Result := 1; // 20111225
  end;

  // 20231127
  If Rule = 68251 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 116);
   { If (Abs(Result) < 1) and (TotMultiple(RetNo, 'T1170', 116) <> 0) then
      Result := 1; // 20111225}
  end;

  // 20231127
  If Rule = 68252 then
  begin
    Result := TotMultiple(RetNo, 'T1170', 118);
  end;



  // ==============================================================
  // 202312097
  If Rule = 68930 then
  begin
    Result := 0;
    if FetchElm(RetNo, 'S15', 2) > '' then
      Result := 1;
  end;

  // 202312097
  If Rule = 68965 then
  begin
    Result := 0;
    if FetchElm(RetNo, 'S15', 24) > '' then
      Result := 1;
  end;

  If Rule = 8001 then
  begin
    Result := 0;
    If (Ret[RetNo].Province = 'NT') then
    begin
      If (Vl(FetchElm(RetNo, 'NT479', 18)) = 0) and (Ret[RetNo].MarStatus < 3)
      then
        Result := 1; // 7; //20191212
    end;
  end;

  If Rule = 9901 then
  begin
    Result := 0;
    Result := MaxR(Vl(FetchElm(RetNo, 'T1139#1', 22)),
      Vl(FetchElm(RetNo, 'T1139#1', 10)));
    // one of the two last year additional income
    exit;
  end;

  If Rule = 9902 then
  begin
    Result := 0;
    If Ret[RetNo].Lnn[21400] > 0 then
      Result := Vl(FetchElm(RetNo, 'T778', 78));
    exit;
  end;

  If Rule = 9903 then
  begin
    Result := 0;
    If Ret[RetNo].Lnn[21400] > 0 then
      Result := Vl(FetchElm(RetNo, 'T778', 1));
    exit;
  end;

  If Rule = 9904 then
  begin
    Result := 0;
    If Ret[RetNo].Lnn[21400] > 0 then  //child care  expenses
      Result := Vl(FetchElm(RetNo, 'T778', 79));  //67 //20250225 cz
    exit;
  end;

  (*
    If Rule = 990 then
    begin
    result :=0;
    IF Ret[RetNo].Lnn[32600]>0 THEN
    begin
    IF Vl(FetchElm(RetNo,'S2',17)) >0 THEN
    result:=Vl(FetchElm(RetNo,'S2',17))
    else
    result :=1;
    end
    end;
  *)

  If Rule = 9908 then
    Result := TotMultiple(RetNo, 'T4RSP', 2);

  If Rule = 9914 then { mb assist }
  begin
    // 20200317
    Result := 0;
    If (Vl(FetchElm(RetNo, 'MB479', 25)) > 0) // school taxes
      and (FetchElm(RetNo, 'MB479', 143) = '0.01') then
      Result := 1;
    // 20200317
    If (Vl(FetchElm(RetNo, 'MB479', 25)) > 0) // school taxes
      and (Vl(FetchElm(RetNo, 'MB479', 26)) = 0) // school taxes
    then
      Result := 1;
  
  end;

  If Rule = 9913 then
    Result := Vl(FetchElm(RetNo, 'S4', 52)) + Vl(FetchElm(RetNo, 'S4', 59));


  If Rule = 9917 then
  begin
    Result := 0;
    IF (Ret[RetNo].Age >= 65) and (Ret[RetNo].Lnn[11300] = 0) THEN
      Result := 1; // 7; 20191210
  end;

  If Rule = 9918 then //Sp ni related
  begin
    Result := 0;
    If (Ret[RetNo].MarStatus < 3) then
      If SpouseIncome(RetNo) <= 0 then
        Result := 1;
    //widow/spouse died
    If (Ret[RetNo].MarStatus = 3) and //(FetchElm(RetNo, 'T1', 65) > '') and   //jz//20260102 - TC49 doesnt seem to make sense so removed for now but should it be something else??
      (SpouseIncome(RetNo) <= 0) then
      Result := 1; // 7; //20191214

    // if FetchElmFNo(RetNo,InfoFNo,4)='000000000' then result:=0; //spouse sin is zeros //20230126
    exit;
  end;

  If Rule = 9922 then
  begin
    Result := 0;
    IF (Ret[RetNo].Lnn[20700] > 0) and (Ret[RetNo].Lnn[20600] = 0) THEN
      Result := 1; // 7; //20191211
  end;
  //20251212 Igor >>>
  if (Rule = 63857) then
  begin
    Result:= 0;
    if (Ret[RetNo].Province = 'YT') then
    begin
    //20251227CZ
     if      (UpperCase(FetchElm(RetNo, 'YT479', 38))='X') then Result:= 1
     else if (UpperCase(FetchElm(RetNo, 'YT479', 39))='X') then Result:= 2;

      {
      if FetchElm(RetNo, 'YT479', 38).Equals('Y') then Result:= 1 else
      if FetchElm(RetNo, 'YT479', 39).Equals('Y') then Result:= 2;
      }
    end;
  end;
  //20251212 Igor <<<

{
  //jz//20260128 - add rules to TotMultiple, should be a better way to account for multiple instances for efile
  If Rule = 17211 then Result:= TotMultiple(RetNo, 'T2048', 056);
  If Rule = 17212 then Result:= TotMultiple(RetNo, 'T2048', 009);
  If Rule = 17213 then Result:= TotMultiple(RetNo, 'T2048', 016);
  If Rule = 17215 then Result:= TotMultiple(RetNo, 'T2048', 063);
  If Rule = 17216 then Result:= TotMultiple(RetNo, 'T2048', 070);
  If Rule = 17217 then Result:= TotMultiple(RetNo, 'T2048', 074);
  If Rule = 17218 then Result:= TotMultiple(RetNo, 'T2048', 078);
}

End;

end.
