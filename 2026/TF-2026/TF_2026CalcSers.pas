unit TF_2026CalcSers;

interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,vtDynData, Math,
 TF_2026Declare, TF_2026common, TF_2026common2, TF_2026TrimStr;

Procedure T2054(RetNo:integer;FName:string;FNo:integer);
procedure T2057(RetNo:integer;FName:string;FNo:integer);
procedure T2058(RetNo:integer;FName:string;FNo:integer);
procedure T2059(RetNo:integer;FName:string;FNo:integer); //20240615
procedure UHT2900(RetNo:integer;FName:string;FNo:integer);
// to be addd soon
//Procedure T217(RetNo:integer;FName:string;FNo:integer);
//Procedure T2183(RetNo:integer;FName:string;FNo:integer);
//Procedure UHT(RetNo:integer;FName:string;FNo:integer);
//Procedure T1521(RetNo:integer;FName:string;FNo:integer);
//Procedure T2Sch89(RetNo:integer;FName:string;FNo:integer);
//later
//Procedure T2123(RetNo:integer;FName:string;FNo:integer);
//Procedure T2311(RetNo:integer;FName:string;FNo:integer);
//Procedure T2142(RetNo:integer;FName:string;FNo:integer);
//Procedure T2156(RetNo:integer;FName:string;FNo:integer);


implementation
Uses TF_2026, TF_2026Calc, vtShared, vtCommon, vtTrimStr;

{elections}
Procedure T2054(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Tv[14] := MaxR(0,Tv[12] - Tv[13]);
  Tv[23] := Tv[112]; //Vl(FetchElm(RetNo,'T2054_2',12));
 end;

 //T2054 pg 2
 with Ret[RetNo].Frm[FNo] do
 Begin
  //If Strings[14] ='' then strings[14] := DateToMonthDayYear(Date);
  Tv[101] := Tv[12]; //Vl(FetchElm(RetNo,'T2054_1',12));
  Tv[103] := Tv[101] * 0.01;
  Strings[20]:=FormatFloat('0.00000',Vl(Strings[104])/12);
  Tv[21]:=Tv[103]*Vl(Strings[20]);
  Strings[22]:=Strings[104];
  Tv[42]:=500 * Vl(Strings[22])/12;
  Tv[11]:=MinR(Tv[21],Tv[42]);

  {
  Tv[104] := Tv[102];
  Tv[105] := (500 * Tv[104])/12;
  Tv[106] := MinR(Tv[103],Tv[105]);
  }
  Tv[107] := Tv[14]; //Vl(FetchElm(RetNo,'T2054_1',14));
  Tv[108] := Tv[107];
  Tv[109] := Tv[108] * 0.60;

  Tv[110] := Tv[11];
  Tv[111] := Tv[109];
  Tv[112] := Tv[110]+Tv[111];
  If Strings[114]='' then Strings[114]:= FormatDateTime('yyyy-mm-dd',Now);
 end;

 SaveTv(RetNo,FName,FNo);
end;

procedure UHT2900(RetNo:integer;FName:string;FNo:integer);
var
  ArrayNumber: integer;
  RowCount: integer;
  Elm: Integer;
  i: Integer;
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
  with Ret[RetNo].Frm[FNo] do
  Begin
    // 20240519
    // 20240703 Igor >>>
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
    // 20240703 Igor <<<

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

  // T2058 pg 2 -----------------------------------------------------------------

  // T2058 pg 3 -----------------------------------------------------------------
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

// 20240614 Igor >>>
procedure T2059(RetNo: integer; FName: String; FNo: integer); { slip }
Var
  i, j: integer;
  ArrayNumber, BoxesPerRow, Elm, ElmDormancy, LastElm, RowCount: integer;
  x4, x5: extended;
  xs: string;
begin
  LoadTv(RetNo, FName, FNo);

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

end.
