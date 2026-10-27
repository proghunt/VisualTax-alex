unit T2_2027CalcSers;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,vtDynData, Math,
  T2_2027TrimStr;

  Procedure T2054(RetNo:integer;FName:string;FNo:integer);
  procedure T2057(RetNo:integer;FName:string;FNo:integer);
  procedure T2058(RetNo:integer;FName:string;FNo:integer);
  procedure T2059(RetNo:integer;FName:string;FNo:integer);
  procedure UHT2900(RetNo:integer;FName:string;FNo:integer);
  procedure T217(RetNo:integer;FName:string;FNo:integer);
  procedure S89(RetNo: integer;FName: string;FNo: integer); //20240726 Igor
  // 20250826 Igor >>>
  procedure FillAppendixALineNumbers(RetNo: integer; FNo: integer; aIdx1, aIdx2, aIdx3, aIdx4, aIdx5, aIdx6, aIdx7, aIdx8, aIdx9, aIdx10, aIdx11, aIdx12: Integer);
  procedure FillAppendixALineMonthes(RetNo: integer; FNo: integer; aIdx1, aIdx2, aIdx3, aIdx4, aIdx5, aIdx6, aIdx7, aIdx8, aIdx9, aIdx10, aIdx11, aIdx12: Integer);
  procedure CalcAppendixATotals(RetNo: integer; FNo: integer; aIdx1, aIdx2, aIdx3, aIdx4, aIdx5, aIdx6, aIdx7, aIdx8, aIdx9, aIdx10, aIdx11, aIdx12,
                                aIdx21, aIdx22, aIdx23, aIdx24, aIdx25, aIdx26, aIdx27, aIdx28, aIdx29, aIdx30, aIdx31, aIdx32, aTotalIdx1, aTotalIdx2: Integer);
  procedure T2311(RetNo: integer; FName: string; FNo: integer);
  procedure T1521(RetNo: integer; FName: string; FNo: integer);
  // 20250826 Igor <<<
  procedure T2055(RetNo: Integer; FName: string; FNo: Integer); // 20250901 Igor
  procedure T2123(RetNo: Integer; FName: string; FNo: Integer); // 20250901 Igor
  procedure T2107(RetNo: Integer; FName: string; FNo: Integer); // 20251028 Igor
  // to be addd soon
  //Procedure T2183(RetNo:integer;FName:string;FNo:integer);
  //later
  //Procedure T2142(RetNo:integer;FName:string;FNo:integer);
  //Procedure T2156(RetNo:integer;FName:string;FNo:integer);

implementation

uses
  T2_2027, vtShared, vtCommon, vtTrimStr, T2_2027Common2, T2_2027Common,
  T2_2027Declare, vtMulti; //20251128  vtmulti to get licenselevel

procedure T2054(RetNo: integer; FName: String; FNo: integer);
var
  i: integer;
  ArrayNumber: integer;
  RowCount: integer;
  Elm: integer;
  s, xs: string;
  x5, x6, x7: double;
begin
  LoadTv(RetNo, FName, FNo);
  //20241128
  //if LicenseLevel<>llEnterprise then exit; //Enterprise then exit; //allow only for enterprise liccnse //20241128
   //
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);
    Strings[2] := GetCorpBusNo(RetNo);
    Strings[3] := FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[15] := FetchElm(RetNo, 'T2', 16);
    Strings[4] := FetchElm(RetNo, 'T2', 17);
    Strings[113] := FetchElm(RetNo, 'T2', 20);

    Strings[5] := FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742);
    Strings[6] := FetchElm(RetNo, 'T2', 755);
    Strings[7] := FetchElm(RetNo, 'T2', 746);
//    Strings[6] := FetchElm(RetNo, 'T2', 55);
//    Strings[7] := FetchElm(RetNo, 'T2', 46);
    Tv[11] := MaxR(0, Tv[9] - Tv[10]);
    if Strings[90] + Strings[91] = '' then
      Strings[91] := 'X';
    if Strings[92] + Strings[93] = '' then
      Strings[93] := 'X';
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    // Part 8 follows panalties  //20231231
    Tv[97] := Tv[9];
    Tv[98] := RoundCorrect(Tv[97] * 1 / 100);
    Strings[100] := FormatFloat('##0.00', Vl(Strings[99]) / 12);
    Tv[101] := Round(Tv[98] * Vl(Strings[100]));
    Strings[102] := Strings[99];
    Tv[103] := 500 * (Vl(Strings[102]) / 12);

    Tv[104] := MinR(Tv[101], Tv[103]);

    // part 9
    Tv[105] := Tv[11];
    Tv[225] := Tv[105];
    Tv[224] := Round(Tv[225] * (60 / 100));

    // Part 10
    Tv[106] := Tv[104];
    Tv[107] := Tv[224];
    Tv[108] := Tv[106] + Tv[107];
    XX := Tv[108]; // debugging statement  xx is global variable
    if Tv[108] = 0 then
      Tv[109] := 0; // 20240131

    // Part 11
//    Strings[110] := FetchElm(RetNo, 'T2', 743) + ' ' +
//      FetchElm(RetNo, 'T2', 742);
//    Strings[111] := FetchElm(RetNo, 'T2', 744);
    If Strings[112] = '' then
      Strings[112] := FormatDateTime('yyyy/mm/dd', Date);
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    for ArrayNumber := 1 to 4 do
    begin
      BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, IntToStr(i + 1));
      end;
    end;
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[4];
    for ArrayNumber := 3 to 3 do
    begin
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        x5 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
        x6 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 7) + i * BoxesPerRow;
        x7 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        if RoundTo(x5 - x6 - x7, -2) <> 0 then
          xs := FormatFloat('########.##', x5 - x6 - x7)
        else
          xs := '';
        Elm := (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, xs);
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure UHT2900(RetNo:integer;FName:string;FNo:integer);
var
  ArrayNumber: integer;
  RowCount: integer;
  Elm: Integer;
  i: Integer;
  s: string;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    for ArrayNumber := 1 to 1 do
    begin
      BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, IntToStr(i + 1));
      end;
    end;
  end;

  LoadTv(RetNo, FName, FNo);

  //if LicenseLevel<>llEnterprise then exit; //Enterprise then exit; //allow only for enterprise liccnse //20241128

  with Ret[RetNo].Frm[FNo] do
  begin
{ //jz 20241129 comment out as most of the fetchElms are from the wrong place
    Strings[2] := Appyear;
    Strings[3] := FetchElmFNo(RetNo, T2FNo, 2) + ' ' + FetchElmFNo(RetNo, T2FNo, 5); //20240717 Igor - test not work if field not empty
    Strings[4] := GetBN(RetNo);
    if FetchElmFNo(RetNo, T2FNo, 22) > '' then
      s := '-'
    else
      s := '';
    If Strings[5] = '' then
      Strings[5] := FetchElmFNo(RetNo, T2FNo, 22) + s + FetchElmFNo(RetNo, T2FNo, 6) + ' ' + FetchElmFNo(RetNo, T2FNo, 68) +
        ' ' + FetchElmFNo(RetNo, T2FNo, 63) + ' ' + FetchElmFNo(RetNo, T2FNo, 10);

    If Strings[8] = '' then
      Strings[8] := FetchElmFNo(RetNo, T2FNo, 15);
    If Strings[9] = '' then
      Strings[9] := FetchElmFNo(RetNo, T2FNo, 54) + ' ' + FetchElmFNo(RetNo, T2FNo, 55);
    If Strings[10] = '' then
      Strings[10] := FetchElmFNo(RetNo, T2FNo, 113);
}

    if Tv[41] = 0 then
      Tv[41] := 100;
    if Tv[41] > 100 then
      Tv[41] := 100;

    Tv[70] := MaxR(Tv[68], Tv[69]);

    Strings[107] := FormatFloat('###', Vl(Strings[99]) + Vl(Strings[101]) + Vl(Strings[103]) + Vl(Strings[105]) - Vl(Strings[106]));
    if Vl(Strings[107]) < 0 then
      Strings[107] := '';

    if Strings[126] > '' then
      Tv[130] := Tv[128]
    Else
      Tv[130] := Tv[70];

    Tv[131] := Tv[41];
    Tv[132] := Tv[130] * Tv[131] / 100;
    Tv[133] := Tv[132];
    Tv[134] := Tv[133] * 1 / 100;
    Tv[135] := Tv[134];
    if Strings[138] = '' then
      Strings[138] := FormatDateTime('yyyy-mm-dd', Now);
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure T2057(RetNo: integer; FName: String; FNo: integer);
Var
  i, ArrayNumber, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: integer;
  // 20240604 Igor >>>
  x4, x5: extended;
  xs: string;
  // 20240604 Igor <<<
  // AccountNumbers, ForeignAffiliates: TList<string>;
  // IncorrectElmIDs: TList<Integer>;
  // Value:Real;
  // MyScrollBox: TvtScrollBox;
begin
  LoadTv(RetNo, FName, FNo);
//20241128
  //if LicenseLevel<>llEnterprise then exit; //Enterprise then exit; //allow only for enterprise liccnse //20241128
  with Ret[RetNo].Frm[FNo] do
  Begin
    // 20240519
    // 20240703 Igor >>
    // Strings[10001]:='1';
    // Strings[20001]:='1';
    // Strings[30001]:='1';
    // Strings[40001]:='1';
    // Strings[50001]:='1';
    // Strings[60001]:='1';
    // Strings[70001]:='1';
    // Strings[80001]:='1';
    // Strings[90001]:='1';
    // Strings[100001]:='1';
    // Strings[110001]:='1';
    // Strings[120001]:='1';
    // 20240703 Igor <<

    // xx:=MaxR(0,Tv[23] - Tv[24]);
    Tv[25] := MaxR(0, Tv[23] - Tv[24]);
    Tv[26] := Tv[25];
    Tv[27] := (Tv[26] / 4) * 0.01 * Vl(Strings[32]); // Tv[28]; //20100412
    If Tv[27] > 8000 then
      Tv[27] := 8000;
    Strings[33] := Strings[32];
    Tv[29] := 100 * Vl(Strings[33]);
    Tv[30] := MinR(Tv[27], Tv[29]);

    // summarize the very bottm total from all ptrior arrays
    Tv[43] := 0; // Tv[31]:=0;
    ArrayNumber := 4; // start from 40000
    BoxesPerRow := 11;
    // T1135RemoveColumnsUnlessFirstColumn(RetNo,FNo,ArrayNo);  //20160124
    Elm := ArrayNumber * 10000 + BoxesPerRow;
    // for field id 10003 on the first row i form
    // Elm:=ArrayNo*10000+StrToInt(BoxesperRow); //for field id 10003 on the first row i form
    xx := Vl(FetchElmFNo(RetNo, FNo, Elm)); // NOT Tv[elm]; //
    For i := 0 to MaxDynamicElmsPerForm do
    begin
      Tv[43] := Tv[43] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      // Vl(FetchElmFNo(RetNo,FNo,Elm));
      Elm := Elm + BoxesPerRow;
    end;

    // 20240531 Igor >>>
    // Summurize 53 - 57

    // 20240703 Igor >>
    with Ret[RetNo].Frm[FNo] do
    begin
      for ArrayNumber := 1 to 12 do
      begin
        BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
        RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
        For i := 0 to RowCount - 1 do
        begin
          Elm := (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
          StoreElmFNo(RetNo, FNo, Elm, IntToStr(i + 1));
        end;
      end;
    end;
    // 20240703 Igor <<

    Tv[53] := 0;
    Tv[54] := 0;
    Tv[55] := 0;
    Tv[56] := 0;
    Tv[57] := 0;
    Tv[58] := 0;
    BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[4];
    for ArrayNumber := 4 to 12 do
    begin
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
        Tv[53] := Tv[53] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
        x4 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        x5 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Tv[54] := Tv[54] + x5;
        if RoundTo(x5 - x4, -2) <> 0 then
          xs := FormatFloat('########.##', x5 - x4)
        else
          xs := '';
        Elm := (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, xs);
        Tv[55] := Tv[55] + x5 - x4;
        Elm := (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
        Tv[56] := Tv[56] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
        Tv[58] := Tv[58] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 11) + i * BoxesPerRow;
        Tv[57] := Tv[57] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      end;
    end;
    // 20240531 Igor <<<


    // repeat...
    // ...

    (*
      //summarize the very bottm total from all ptrior arrays
      //20240519
      Tv[43]:=0;
      // individuals
      ArrayNo := 3;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For I := 0 to RowCount - 1 do
      ArrayNo := 1;
      BoxesPerRow := RetList[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNo];
      Elm := ArrayNo * 10000 + 10;
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNo);
      For i := 0 to RowCount - 1 do
      begin
      Value := Vl(FetchElmFNo(RetNo, FNo, Elm));
      Tv[43]:=Tv[43]+Value;
      //if not Value.IsEmpty and (AccountNumbers.IndexOf(Value) = -1) then AccountNumbers.Add(Value);
      Elm := Elm + BoxesPerRow;
      end;
      //repeat for all other arays to the end;
      //...array 4 etc..
      end;
    *)
  end;
  SaveTv(RetNo, FName, FNo);
end;

procedure T2058(RetNo: integer; FName: String; FNo: integer); { slip }
Var
  i, j: integer;
  // 20240613 Igor >>>
  ArrayNumber, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: integer;
  x4, x5: extended;
  xs: string;
begin
  LoadTv(RetNo, FName, FNo);

//20241128
  //if LicenseLevel<>llEnterprise then exit; //Enterprise then exit; //allow only for enterprise liccnse //20241128

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);
    Strings[2] := GetBN(RetNo);
  end;

  // T2058 pg 2 -----------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  Begin
    Tv[25] := MaxR(0, Tv[23] - Tv[24]); { negative ? }
    Tv[26] := (Tv[25] / 4) * 0.01 * Tv[32];
    Tv[27] := 100;
    Tv[28] := Tv[27] * Tv[32];
    If Tv[28] > 8000 then
      Tv[28] := 8000;
    Tv[29] := MinR(Tv[26], Tv[28]);
  end;

  // 20240613 Igor >>>
  // Summurize
  with Ret[RetNo].Frm[FNo] do
  begin
    for ArrayNumber := 1 to 10 do
    begin
      BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, IntToStr(i + 1));
      end;
    end;

    Tv[53] := 0;
    Tv[54] := 0;
    Tv[55] := 0;
    Tv[56] := 0;
    Tv[57] := 0;
    Tv[58] := 0;
    BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[4];
    for ArrayNumber := 4 to 10 do
    begin
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
        Tv[53] := Tv[53] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
        x4 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        x5 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Tv[54] := Tv[54] + x5;
        if RoundTo(x5 - x4, -2) <> 0 then
          xs := FormatFloat('########.##', x5 - x4)
        else
          xs := '';
        Elm := (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, xs);
        Tv[55] := Tv[55] + x5 - x4;
        Elm := (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
        Tv[56] := Tv[56] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
        Tv[58] := Tv[58] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 11) + i * BoxesPerRow;
        Tv[57] := Tv[57] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      end;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
  // 202406013 Igor <<<
end;

//20240723 Igor >>>
procedure T217(RetNo:integer;FName:string;FNo:integer);
begin
  LoadTv(RetNo, FName, FNo);
//20241128
  //if LicenseLevel<>llEnterprise then exit; //Enterprise then exit; //allow only for enterprise liccnse //20241128

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);  //20240726 Igor
    Strings[2] := GetBN(RetNo);  //20240726 Igor
  end;
end;
//20240723 Igor <<<

// 20240614 Igor >>>
procedure T2059(RetNo: integer; FName: String; FNo: integer); { slip }
Var
  i, j: integer;
  ArrayNumber, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: integer;
  x4, x5: extended;
  xs: string;
begin
  LoadTv(RetNo, FName, FNo);
//20241128
  //if LicenseLevel<>llEnterprise then exit; //Enterprise then exit; //allow only for enterprise liccnse //20241128
  //20240725 Igor >>>
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[1] := GetCorpName(RetNo);
    Strings[2] := GetBN(RetNo);
  end;
  //20240725 Igor >>>

  with Ret[RetNo].Frm[FNo] do
  Begin
    Tv[24] := MaxR(0, Tv[22] - Tv[23]); { negative ? }
    Tv[25] := Tv[24];
    Tv[26] := (Tv[25] / 4) * 0.01 * Tv[32];
    Tv[27] := 100;
    Tv[28] := Tv[27] * Tv[32];
    If Tv[28] > 8000 then
      Tv[28] := 8000;
    Tv[29] := MinR(Tv[26], Tv[28]);
  end;

  // T2059 pg 2 -----------------------------------------------------------------

  // T2059 pg 3 -----------------------------------------------------------------
  with Ret[RetNo].Frm[FNo] do
  Begin
    i := 203;
    Repeat
      Tv[i + 3] := Tv[i + 2] - Tv[i + 1];
      Inc(i, 8);
    until i > 307;

    i := 323;
    Repeat
      Tv[i + 3] := Tv[i + 2] - Tv[i + 1];
      Inc(i, 8);
    until i > 323;

    i := 344;
    Repeat
      Tv[i + 3] := Tv[i + 2] - Tv[i + 1];
      Inc(i, 8);
    until i > 352;
  end;

  with Ret[RetNo].Frm[FNo] do
  Begin
    for ArrayNumber := 1 to 9 do
    begin
      BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, IntToStr(i + 1));
      end;
    end;

    Tv[53] := 0;
    Tv[54] := 0;
    Tv[55] := 0;
    Tv[56] := 0;
    Tv[57] := 0;
    Tv[58] := 0;
    BoxesPerRow := Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[4];
    for ArrayNumber := 4 to 9 do
    begin
      RowCount := DynamicRowCount(RetNo, FNo, ArrayNumber);
      For i := 0 to RowCount - 1 do
      begin
        Elm := (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
        Tv[53] := Tv[53] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
        x4 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        x5 := Vl(FetchElmFNo(RetNo, FNo, Elm));
        Tv[54] := Tv[54] + x5;
        if RoundTo(x5 - x4, -2) <> 0 then
          xs := FormatFloat('########.##', x5 - x4)
        else
          xs := '';
        Elm := (ArrayNumber * 10000 + 6) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, xs);
        Tv[55] := Tv[55] + x5 - x4;
        Elm := (ArrayNumber * 10000 + 8) + i * BoxesPerRow;
        Tv[56] := Tv[56] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 10) + i * BoxesPerRow;
        Tv[58] := Tv[58] + Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm := (ArrayNumber * 10000 + 11) + i * BoxesPerRow;
        Tv[57] := Tv[57] + Vl(FetchElmFNo(RetNo, FNo, Elm));
      end;
    end;
  end;
  SaveTv(RetNo, FName, FNo);
end;

//20240726 Igor >>>
procedure S89(RetNo: integer; FName: string; FNo: integer);
var
  i, ArrayNo, Elm: integer;
  v: Real;
  T2FNo: integer;
begin
  T2FNo := GetFormNo('T2');
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillHeader(RetNo, FNo, 1, 2, 3);
    // If Strings[3]=''  then
    Strings[3] := FetchElmFNo(RetNo, T2FNo, 12);
    // If Strings[11]='' then
    Strings[11] := FetchElmFNo(RetNo, T2FNo, 16);
    // If Strings[12]='' then
    Strings[12] := FetchElmFNo(RetNo, T2FNo, 17);
    // If Strings[13]='' then
    Strings[13] := FetchElmFNo(RetNo, T2FNo, 20);
    // If Strings[14]='' then
    Strings[14] := trim(FetchElmFNo(RetNo, T2FNo, 743) + ' ' + FetchElmFNo(RetNo, T2FNo, 742));
    // If Strings[9]=''  then
    Strings[9] := FetchElmFNo(RetNo, T2FNo, 756) + FetchElmFNo(RetNo, T2FNo, 750);

    if Strings[5] + Strings[6] = '' then
      Strings[5] := 'X';
    if Strings[7] + Strings[8] = '' then
      Strings[8] := 'X';

    // part 1
    ArrayNo := 1;
    Elm := ArrayNo * 10000 + 3; // for field id 10003 on the first row i form
    Tv[38] := SumOfColumn(RetNo, FNo, Elm);
    Tv[39] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[40] := SumOfColumn(RetNo, FNo, Elm + 2);
    Tv[41] := SumOfColumn(RetNo, FNo, Elm + 3);
    Tv[42] := SumOfColumn(RetNo, FNo, Elm + 4);
    Tv[48] := SumOfColumn(RetNo, FNo, Elm + 5);
    Tv[67] := SumOfColumn(RetNo, FNo, Elm + 6); //20260903 Alex

    // part  2B   //20190828
    ArrayNo := 2;
    Elm := ArrayNo * 10000 + 2; // for field id 10003 on the first row i form
    Tv[43] := SumOfColumn(RetNo, FNo, Elm);
    Tv[44] := SumOfColumn(RetNo, FNo, Elm + 1);
    Tv[45] := SumOfColumn(RetNo, FNo, Elm + 2);
    Tv[46] := SumOfColumn(RetNo, FNo, Elm + 3);
    Tv[47] := SumOfColumn(RetNo, FNo, Elm + 4);
    Tv[65] := SumOfColumn(RetNo, FNo, Elm + 5);
    Tv[68] := SumOfColumn(RetNo, FNo, Elm + 6); //20260903 Alex

    {
      If SplitDynId(RetNo, FNo, i) then  //SplitDynId establishes MaxElm and BoxesPerRpw, etc
      Begin
      Tv[15]:=0;  //column total
      while i <= MaxElm+ArrayNo*10000 do
      begin
      V := Vl(Strings[i-2]) - Vl(Strings[i-1]);  //TV does not work, use VL
      Tv[15]:=Tv[15]+V;    //add to column
      Strings[i] := formatfloat('###,####.00',V); //show value on the screen
      inc(i, BoxesPerRow);   //next row of the table
      end;
    }

    // ==Part 4 ======================
    Tv[16] := Tv[38] + Tv[43];
    Tv[17] := Tv[39] + Tv[44];
    Tv[19] := Tv[40] + Tv[45];
    Tv[21] := Tv[41] + Tv[46];
    Tv[22] := Tv[42] + Tv[47];
    // Tv[23]: user
    Tv[24] := Tv[48] + Tv[65]; //20260903 Alex
    Tv[69] := Tv[16] + Tv[17] + Tv[18] + Tv[19] + Tv[20] + Tv[21] + Tv[22] + Tv[23]; //20260903 Alex
    Tv[25] := Tv[67] + Tv[68]; //20260903 Alex
    Tv[26] := MaxR(0, Tv[69] - Tv[25]);//MaxR(0, Tv[24] - Tv[25]); //20260903 Alex
  end;
  SaveTv(RetNo, FName, FNo);
end;
//20240726 Igor <<<

//20250826 Igor >>>
procedure FillAppendixALineNumbers(RetNo: integer; FNo: integer; aIdx1, aIdx2, aIdx3, aIdx4, aIdx5, aIdx6, aIdx7, aIdx8, aIdx9, aIdx10, aIdx11, aIdx12: Integer);
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[aIdx1]:= '1';
    Strings[aIdx2]:= '2';
    Strings[aIdx3]:= '3';
    Strings[aIdx4]:= '4';
    Strings[aIdx5]:= '5';
    Strings[aIdx6]:= '6';
    Strings[aIdx7]:= '7';
    Strings[aIdx8]:= '8';
    Strings[aIdx9]:= '9';
    Strings[aIdx10]:= '10';
    Strings[aIdx11]:= '11';
    Strings[aIdx12]:= '12';
  end;
end;

procedure FillAppendixALineMonthes(RetNo: integer; FNo: integer; aIdx1, aIdx2, aIdx3, aIdx4, aIdx5, aIdx6, aIdx7, aIdx8, aIdx9, aIdx10, aIdx11, aIdx12: Integer);
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[aIdx1]:= 'January';
    Strings[aIdx2]:= 'February';
    Strings[aIdx3]:= 'March';
    Strings[aIdx4]:= 'April';
    Strings[aIdx5]:= 'May';
    Strings[aIdx6]:= 'June';
    Strings[aIdx7]:= 'July';
    Strings[aIdx8]:= 'August';
    Strings[aIdx9]:= 'September';
    Strings[aIdx10]:= 'October';
    Strings[aIdx11]:= 'November';
    Strings[aIdx12]:= 'December';
  end;
end;

procedure CalcAppendixATotals(RetNo: integer; FNo: integer; aIdx1, aIdx2, aIdx3, aIdx4, aIdx5, aIdx6, aIdx7, aIdx8, aIdx9, aIdx10, aIdx11, aIdx12,
                              aIdx21, aIdx22, aIdx23, aIdx24, aIdx25, aIdx26, aIdx27, aIdx28, aIdx29, aIdx30, aIdx31, aIdx32, aTotalIdx1, aTotalIdx2: Integer);
var
  s71, s81, s91, s101, s115, s125, s135, s145, s155, s165, s175, s185, s187: Double;
  s72, s82, s92, s102, s116, s126, s136, s146, s156, s166, s176, s186, s188: Double;
begin
  with Ret[RetNo].Frm[FNo] do
  begin
    s71:= Tv[aIdx1];
    s81:= Tv[aIdx2];
    s91:= Tv[aIdx3];
    s101:= Tv[aIdx4];
    s115:= Tv[aIdx5];
    s125:= Tv[aIdx6];
    s135:= Tv[aIdx7];
    s145:= Tv[aIdx8];
    s155:= Tv[aIdx9];
    s165:= Tv[aIdx10];
    s175:= Tv[aIdx11];
    s185:= Tv[aIdx12];

    s72:= Tv[aIdx21];
    s82:= Tv[aIdx22];
    s92:= Tv[aIdx23];
    s102:= Tv[aIdx24];
    s116:= Tv[aIdx25];
    s126:= Tv[aIdx26];
    s136:= Tv[aIdx27];
    s146:= Tv[aIdx28];
    s156:= Tv[aIdx29];
    s166:= Tv[aIdx30];
    s176:= Tv[aIdx31];
    s186:= Tv[aIdx32];

    s187:= RoundTo(s71 + s81 + s91 + s101 + s115 + s125 + s135 + s145 + s155 + s165 + s175 + s185, -2);
    s188:= RoundTo(s72 + s82 + s92 + s102 + s116 + s126 + s136 + s146 + s156 + s166 + s176 + s186, -2);
    Tv[aTotalIdx1]:= s187;
    Tv[aTotalIdx2]:= s188;
//    Strings[aTotalIdx1]:= FormatFloat('##0.00', s187);
//    Strings[aTotalIdx2]:= FormatFloat('##0.00', s188);
  end;
end;

procedure T2311(RetNo: integer; FName: string; FNo: integer);
var
  i: integer;
  ArrayNumber: integer;
  RowCount: integer;
  Elm: integer;
  x130, x140: double;
  x150: string;

begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[7]:= GetCorpName(RetNo);
    Strings[8]:= GetCorpBusNo(RetNo);
    Strings[9]:= FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[10]:= FetchElm(RetNo, 'T2', 17);
    Strings[15]:= FetchElm(RetNo, 'T2', 16);
    Strings[113]:= FetchElm(RetNo, 'T2', 20);
    Strings[11]:= FetchElm(RetNo, 'T2', 10);
    Strings[12]:= FetchElm(RetNo, 'T2', 11);
    Strings[13]:= FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742);
    Strings[14]:= FetchElm(RetNo, 'T2', 744);

    Strings[20]:= FetchElm(RetNo, 'T2', 755) + FetchElm(RetNo, 'T2', 746);
    Strings[54]:= FormatFloat('##0.00', Vl(Strings[53]) * 100);

    FillAppendixALineNumbers(RetNo, FNo, 62, 73, 83, 93, 103, 117, 127, 137, 147, 157, 167, 177);
    FillAppendixALineNumbers(RetNo, FNo, 189, 199, 209, 219, 229, 239, 249, 259, 269, 279, 289, 299);

    FillAppendixALineMonthes(RetNo, FNo, 64, 74, 84, 94, 104, 118, 128, 138, 148, 158, 168, 178);
    FillAppendixALineMonthes(RetNo, FNo, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300);

    CalcAppendixATotals(RetNo, FNo, 71, 81, 91, 101, 115, 125, 135, 145, 155, 165, 175, 185, 72, 82, 92, 102, 116, 126, 136, 146, 156, 166, 176, 186, 187, 188);
    CalcAppendixATotals(RetNo, FNo, 197, 207, 217, 227, 237, 247, 257, 267, 277, 287, 297, 307, 198, 208, 218, 228, 238, 248, 258, 268, 278, 288, 298, 308, 309, 310);
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    for ArrayNumber:= 1 to 3 do
    begin
      BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);

      for i:= 0 to pred(RowCount) do
      begin
        Elm:= (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, IntToStr(succ(i)));
      end;
    end;
  end;

  with Ret[RetNo].Frm[FNo] do
  begin
    BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[2];

    for ArrayNumber:= 2 to 2 do
    begin
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);

      for i:= 0 to pred(RowCount) do
      begin
        Elm:= (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
        x130:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
        x140:= Vl(FetchElmFNo(RetNo, FNo, Elm));

        if RoundTo(x130 - x140, -2) <> 0 then
        begin
          if RoundTo(x130 - x140, -2) < 0 then
            x150:= '0'
          else
          x150:= FormatFloat('########.##', x130 - x140);
        end else
          x150:= '';

        Elm:= (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, x150);
      end;
    end;
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure T1521(RetNo: integer; FName: string; FNo: integer);
var
  i: integer;
  ArrayNumber: integer;
  RowCount: integer;
  Elm: integer;
  x130, x140: double;
  x150: string;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[7]:= GetCorpName(RetNo);
    Strings[8]:= GetCorpBusNo(RetNo);
    Strings[9]:= FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[16]:= FetchElm(RetNo, 'T2', 16);
    Strings[17]:= FetchElm(RetNo, 'T2', 17);
    Strings[10]:= FetchElm(RetNo, 'T2', 20);
    Strings[11]:= FetchElm(RetNo, 'T2', 10);
    Strings[12]:= FetchElm(RetNo, 'T2', 11);
    Strings[19]:= FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742);
    Strings[13]:= FetchElm(RetNo, 'T2', 744);
    Strings[20]:= FetchElm(RetNo, 'T2', 755) + FetchElm(RetNo, 'T2', 746);
    Tv[54]:= (Tv[53] * 100);

    // Dynamic tables >>>
    for ArrayNumber:= 1 to 1 do
    begin // Auto increment line number
      BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[ArrayNumber];
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);

      for i:= 0 to pred(RowCount) do
      begin
        Elm:= (ArrayNumber * 10000 + 1) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, IntToStr(succ(i)));
      end;
    end;

    BoxesPerRow:= Ret[RetNo].Frm[FNo].FormDataRec.BoxesPerRow[1];

    // Working withe first dynamic table
    for ArrayNumber:= 1 to 1 do
    begin // Total calculation by the lines
      RowCount:= DynamicRowCount(RetNo, FNo, ArrayNumber);

      for i:= 0 to pred(RowCount) do
      begin
        Elm:= (ArrayNumber * 10000 + 3) + i * BoxesPerRow;
        x130:= Vl(FetchElmFNo(RetNo, FNo, Elm));
        Elm:= (ArrayNumber * 10000 + 4) + i * BoxesPerRow;
        x140:= Vl(FetchElmFNo(RetNo, FNo, Elm));

        if RoundTo(x130 - x140, -2) <> 0 then
        begin
          if RoundTo(x130 - x140, -2) < 0 then
            x150:= '0'
          else
          x150:= FormatFloat('########.##', x130 - x140);
        end else
          x150:= '';

        Elm:= (ArrayNumber * 10000 + 5) + i * BoxesPerRow;
        StoreElmFNo(RetNo, FNo, Elm, x150);
      end;
    end;
    // Dynamic tables <<<

    FillAppendixALineNumbers(RetNo, FNo, 142, 152, 162, 172, 182, 192, 202, 212, 222, 232, 242, 252);
    FillAppendixALineNumbers(RetNo, FNo, 264, 274, 284, 294, 304, 315, 325, 335, 345, 355, 365, 375);

    FillAppendixALineMonthes(RetNo, FNo, 143, 153, 163, 173, 183, 193, 203, 213, 223, 233, 243, 253);
    FillAppendixALineMonthes(RetNo, FNo, 265, 275, 285, 295, 305, 316, 326, 336, 346, 356, 366, 376);

    CalcAppendixATotals(RetNo, FNo, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 151, 161, 171, 181, 191, 201, 211, 221, 231, 241, 251, 261, 262, 263);
    CalcAppendixATotals(RetNo, FNo, 272, 282, 292, 302, 313, 323, 333, 343, 353, 363, 373, 383, 273, 283, 293, 303, 314, 324, 334, 344, 354, 364, 374, 384, 385, 386);
  end;

  SaveTv(RetNo, FName, FNo);
end;
// 20250826 Igor <<<

// 20250901 Igor >>>
procedure T2055(RetNo: Integer; FName: string; FNo: Integer);
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[7]:= GetCorpName(RetNo);
    Strings[8]:= GetCorpBusNo(RetNo);
    Strings[9]:= FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[16]:= FetchElm(RetNo, 'T2', 16);
    Strings[17]:= FetchElm(RetNo, 'T2', 17);
    Strings[10]:= FetchElm(RetNo, 'T2', 20);
    Strings[19]:= FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742);
    Strings[20]:= FetchElm(RetNo, 'T2', 755) + FetchElm(RetNo, 'T2', 746);

    Strings[110]:= FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742);
    Strings[111]:= FetchElm(RetNo, 'T2', 744);
    Strings[112]:= FetchElm(RetNo, 'T2', 745);

    Tv[3]:= MinR(Tv[1], Tv[2]);
    Tv[4]:= Tv[1];
    Tv[6]:= (Tv[4] * 0.01 * Tv[5]) / 12;
    Tv[14]:= (500 * Tv[13]) / 12;
    Tv[15]:= MinR(Tv[6], Tv[14]);
    Tv[18]:= Tv[1] - Tv[2];
    Tv[22]:= MaxR(0, Tv[18] * 0.6);
    Tv[23]:= Tv[22];
    Tv[24]:= Tv[15];
    Tv[25]:= MaxR(0, Tv[23] + Tv[24]);
  end;

  SaveTv(RetNo, FName, FNo);
end;

procedure T2123(RetNo: Integer; FName: string; FNo: Integer);
var
  i: integer;
  ArrayNumber: integer;
  RowCount: integer;
  Elm: integer;
  x130, x140: double;
  x150: string;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Strings[7]:= GetCorpName(RetNo);
    Strings[8]:= GetCorpBusNo(RetNo);
    Strings[9]:= FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[16]:= FetchElm(RetNo, 'T2', 16);
    Strings[17]:= FetchElm(RetNo, 'T2', 17);
    Strings[10]:= FetchElm(RetNo, 'T2', 20);
    Strings[11]:= FetchElm(RetNo, 'T2', 10);
    Strings[12]:= FetchElm(RetNo, 'T2', 11);
    Strings[19]:= FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742);
    Strings[13]:= FetchElm(RetNo, 'T2', 744);
    Strings[20]:= FetchElm(RetNo, 'T2', 755) + FetchElm(RetNo, 'T2', 746);

    Tv[54]:= (Tv[56] * 100);

  end;

  SaveTv(RetNo, FName, FNo);
end;
// 20250901 Igor <<<
//20251028 Igor >>>
procedure T2107(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  if Licenselevel <> llEnterprise then exit;

  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[Fno] do
  begin
    //Page 1
    Strings[7]:= GetCorpName(RetNo);
    Strings[8]:= GetCorpBusNo(RetNo);
    Strings[9]:= FetchElm(RetNo, 'T2', 12) + ' ' + FetchElm(RetNo, 'T2', 13);
    Strings[10]:= FetchElm(RetNo, 'T2', 17);
    Strings[15]:= FetchElm(RetNo, 'T2', 16);
    Strings[113]:= FetchElm(RetNo, 'T2', 20);
    if Strings[12].Equals('') then Strings[12]:= FetchElm(RetNo, 'T2', 11); //FetchElm(RetNo, 'T2', 10);
    Strings[13]:= FetchElm(RetNo, 'T2', 743) + ' ' + FetchElm(RetNo, 'T2', 742);
    //Strings[14]:= FetchElm(RetNo, 'T2', 744);
    Strings[20]:= FetchElm(RetNo, 'T2', 755) + FetchElm(RetNo, 'T2', 746);

    //Page 2
    Tv[38]:= Tv[36] * Tv[37];
    Tv[3]:= Tv[38];
    Tv[5]:= Tv[3] * 0.25 * 0.01 * Tv[4];
    Tv[11]:= MinR(8000, 100 * Tv[6]);
    Tv[14]:= MinR(Tv[5], Tv[11]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20251028 Igor <<<

end.
