{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryQVer.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryIntelligentMailBarcode;

interface

uses
  DebenuPDFLibraryTypes;

type
  TOneCodeBars = class
  private
    table2of13: TQPLIntegerArray; // = OneCodeInfo(1);
    table5of13: TQPLIntegerArray; // = OneCodeInfo(2);
    table2of13Size: Integer; // = 78;
    table5of13Size: Integer; // = 1287;
    entries2of13: Int64; // = 1287;
    entries5of13: Int64; // = 78;

    //table2of13ArrayPtr = table2of13;
    //table5of13ArrayPtr = table5of13;
    codewordArray: array[0..10, 0..1] of Double; // = OneCodeInfo();
    FEncoded: WideString;
    function OneCodeMathMultiply(var bytearray: TQPLIntegerArray; i, j: Integer): Boolean;
    function OneCodeMathAdd(var bytearray: TQPLIntegerArray; i, j: Integer): Boolean;
    function OneCodeMathFcs(bytearray: TQPLIntegerArray): Integer;
    //procedure OneCodeMathDivide(var byteArray: TQPLIntegerArray; d: Integer);
    procedure OneCodeMathDivideStr(const v: WideString);
    function OneCodeInfo(topic: Integer): TQPLIntegerArray;
    function OneCodeInitializeNof13Table(var ai: TQPLIntegerArray; i, j: Integer): Boolean;
    function OneCodeMathReverse(i: Integer): Integer;
  public
    constructor Create(const Source: WideString);
    property Encoded: WideString read FEncoded;
  end;

implementation

uses
  SysUtils;

const
  BarTopCharacterIndexArray: array[0..64] of Integer = (4, 0, 2, 6, 3, 5, 1,
    9, 8, 7, 1, 2, 0, 6, 4, 8, 2, 9, 5, 3, 0, 1, 3, 7, 4, 6, 8, 9, 2, 0, 5,
    1, 9, 4, 3, 8, 6, 7, 1, 2, 4, 3, 9, 5, 7, 8, 3, 0, 2, 1, 4, 0, 9, 1, 7,
    0, 2, 4, 6, 3, 7, 1, 9, 5, 8);

  BarBottomCharacterIndexArray: array[0..64] of Integer = (7, 1, 9, 5, 8, 0, 2,
    4, 6, 3, 5, 8, 9, 7, 3, 0, 6, 1, 7, 4, 6, 8, 9, 2, 5, 1, 7, 5, 4, 3, 8, 7,
    6, 0, 2, 5, 4, 9, 3, 0, 1, 6, 8, 2, 0, 4, 5, 9, 6, 7, 5, 2, 6, 3, 8, 5, 1,
    9, 8, 7, 4, 0, 2, 6, 3);

  BarTopCharacterShiftArray: array[0..64] of Integer = (3, 0, 8, 11, 1, 12, 8,
    11, 10, 6, 4, 12, 2, 7, 9, 6, 7, 9, 2, 8, 4, 0, 12, 7, 10, 9, 0, 7, 10,
    5, 7, 9, 6, 8, 2, 12, 1, 4, 2, 0, 1, 5, 4, 6, 12, 1, 0, 9, 4, 7, 5, 10,
    2, 6, 9, 11, 2, 12, 6, 7, 5, 11, 0, 3, 2);

  BarBottomCharacterShiftArray: array[0..64] of Integer = (2, 10, 12, 5, 9, 1,
    5, 4, 3, 9, 11, 5, 10, 1, 6, 3, 4, 1, 10, 0, 2, 11, 8, 6, 1, 12, 3, 8, 6,
    4, 4, 11, 0, 6, 1, 9, 11, 5, 3, 7, 3, 10, 7, 11, 8, 2, 10, 3, 5, 8, 0, 3,
    12, 11, 8, 4, 5, 1, 3, 0, 7, 12, 9, 8, 10);


(*
//   Copyright 2007 Vassilis Petroulias [drdigit]
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

using System;
using System.Diagnostics;

public static class Test
{
    static void Main()
    {
        String bars = "00 700 905016001 174945 57325052828".OneCodeBars(), code = bars.OneCodeDecode();
        Debug.WriteLine(bars);
        Debug.WriteLine(code);
    }
}

public static class OneCode
{
    // for more information and specs check
    // http://ribbs.usps.gov/onecodesolution/USPS-B-3200D001.pdf
    private static Int32 table2of13Size = 78;
    private static Int32 table5of13Size = 1287;
    private static Int64 entries2of13 = table5of13Size;
    private static Int64 entries5of13 = table2of13Size;
    private static Int32[] table2of13 = OneCodeInfo(1);
    private static Int32[] table5of13 = OneCodeInfo(2);
    private static Int32[] table2of13ArrayPtr = table2of13;
    private static Int32[] table5of13ArrayPtr = table5of13;
    private static Decimal[][] codewordArray = OneCodeInfo();
    private static Int32[] BarTopCharacterIndexArray = new Int32[] { 4, 0, 2, 6, 3, 5, 1, 9, 8, 7, 1, 2, 0, 6, 4, 8, 2, 9, 5, 3, 0, 1, 3, 7, 4, 6, 8, 9, 2, 0, 5, 1, 9, 4, 3, 8, 6, 7, 1, 2, 4, 3, 9, 5, 7, 8, 3, 0, 2, 1, 4, 0, 9, 1, 7, 0, 2, 4, 6, 3, 7, 1, 9, 5, 8 };
    private static Int32[] BarBottomCharacterIndexArray = new Int32[] { 7, 1, 9, 5, 8, 0, 2, 4, 6, 3, 5, 8, 9, 7, 3, 0, 6, 1, 7, 4, 6, 8, 9, 2, 5, 1, 7, 5, 4, 3, 8, 7, 6, 0, 2, 5, 4, 9, 3, 0, 1, 6, 8, 2, 0, 4, 5, 9, 6, 7, 5, 2, 6, 3, 8, 5, 1, 9, 8, 7, 4, 0, 2, 6, 3 };
    private static Int32[] BarTopCharacterShiftArray = new Int32[] { 3, 0, 8, 11, 1, 12, 8, 11, 10, 6, 4, 12, 2, 7, 9, 6, 7, 9, 2, 8, 4, 0, 12, 7, 10, 9, 0, 7, 10, 5, 7, 9, 6, 8, 2, 12, 1, 4, 2, 0, 1, 5, 4, 6, 12, 1, 0, 9, 4, 7, 5, 10, 2, 6, 9, 11, 2, 12, 6, 7, 5, 11, 0, 3, 2 };
    private static Int32[] BarBottomCharacterShiftArray = new Int32[] { 2, 10, 12, 5, 9, 1, 5, 4, 3, 9, 11, 5, 10, 1, 6, 3, 4, 1, 10, 0, 2, 11, 8, 6, 1, 12, 3, 8, 6, 4, 4, 11, 0, 6, 1, 9, 11, 5, 3, 7, 3, 10, 7, 11, 8, 2, 10, 3, 5, 8, 0, 3, 12, 11, 8, 4, 5, 1, 3, 0, 7, 12, 9, 8, 10 };
*)


//    public static String OneCodeBars(this String source)
constructor TOneCodeBars.Create(const Source: WideString);
var
  ValidSource: Boolean;
  SourceLength: Integer;
  SourceX: Integer;
  Zip: WideString;
  l: Int64;
  v: Double;
  ds: WideString;
  byteArray: TQPLIntegerArray;
  i: Integer;
  fcs: Integer;
  ai: array[0..64] of Integer;
  ai1: array[0..64] of Integer;
  ad: array[0..10, 0..1] of Double;
  a: Integer;
begin
  table2of13Size := 78;
  table5of13Size := 1287;
  entries2of13 := 1287;
  entries5of13 := 78;

  table2of13 := OneCodeInfo(1);
  table5of13 := OneCodeInfo(2);

  ValidSource := True;

//        if (String.IsNullOrEmpty(source)) return null;
  if (Source = '') then
  begin
    ValidSource := False;
  end;

//        source = TrimOff(source, " -.");
//        if (!System.Text.RegularExpressions.Regex.IsMatch(source, "^[0-9][0-4](([0-9]{18})|([0-9]{23})|([0-9]{27})|([0-9]{29}))$")) return String.Empty;
  SourceLength := Length(Source);
  if ((SourceLength <> 20) and (SourceLength <> 25) and (SourceLength <> 29) and (SourceLength <> 31)) then
  begin
    ValidSource := False;
  end else
  begin
    for SourceX := 1 to SourceLength do
    begin
      if ((Source[SourceX] < '0') or (Source[SourceX] > '9')) then
      begin
        ValidSource := False;
      end;
    end;
    if (Source[2] > '4') then
    begin
    ValidSource := False;
    end;
  end;

  if (ValidSource) then
  begin

//        String encoded = String.Empty;
    FEncoded := '';

//        Int64 l = 0L;
//        String zip = source.Substring(20);
    l := 0;
    Zip := Copy(Source, 21, MaxInt);

//        switch (zip.Length)
//        {
//            case 5:
//                l = Int64.Parse(zip) + 1;
//                break;
//            case 9:
//                l = Int64.Parse(zip) + 100001;
//                break;
//            case 11:
//                l = Int64.Parse(zip) + 1000100001;
//                break;
//        }
    case Length(Zip) of
      5: l := StrToInt64(Zip) + 1;
      9: l := StrToInt64(Zip) + 100001;
      11: l := StrToInt64(Zip) + 1000100001;
    end;

//        Decimal v = l;
    v := l;

//        v = v * 10 + Int32.Parse(source.Substring(0, 1));
//        v = v * 5 + Int32.Parse(source.Substring(1, 1));
//        String ds = v.ToString() + source.Substring(2, 18);
    v := v * 10 + StrToInt(Copy(Source, 1, 1));
    v := v * 5 + StrToInt(Copy(Source, 2, 1));
    ds := FloatToStr(v) + Copy(Source, 3, 18);

//        Int32[] byteArray = new Int32[13];
    SetLength(byteArray, 13);

//        byteArray[12] = (Int32)(l & 255);
//        byteArray[11] = (Int32)(l >> 8 & 255);
//        byteArray[10] = (Int32)(l >> 16 & 255);
//        byteArray[9] = (Int32)(l >> 24 & 255);
//        byteArray[8] = (Int32)(l >> 32 & 255);
    byteArray[12] := Integer(l and 255);
    byteArray[11] := Integer((l shr 8) and 255);
    byteArray[10] := Integer((l shr 16) and 255);
    byteArray[9] := Integer((l shr 24) and 255);
    byteArray[8] := Integer((l shr 32) and 255);

//        OneCodeMathMultiply(ref byteArray, 13, 10);
//        OneCodeMathAdd(ref byteArray, 13, Int32.Parse(source.Substring(0, 1)));
//        OneCodeMathMultiply(ref byteArray, 13, 5);
//        OneCodeMathAdd(ref byteArray, 13, Int32.Parse(source.Substring(1, 1)));
    OneCodeMathMultiply(byteArray, 13, 10);
    OneCodeMathAdd(byteArray, 13, StrToInt(Copy(Source, 1, 1)));
    OneCodeMathMultiply(byteArray, 13, 5);
    OneCodeMathAdd(byteArray, 13, StrToInt(Copy(Source, 2, 1)));

//        for (var i = 2; i <= 19; i++)
//        {
//            OneCodeMathMultiply(ref byteArray, 13, 10);
//            OneCodeMathAdd(ref byteArray, 13, Int32.Parse(source.Substring(i, 1)));
//        }
    for i := 2 to 19 do
    begin
      OneCodeMathMultiply(byteArray, 13, 10);
      OneCodeMathAdd(byteArray, 13, StrToInt(Copy(Source, i + 1, 1)));
    end;

//        Int32 fcs = OneCodeMathFcs(byteArray);
//        for (var i = 0; i <= 9; i++)
//        {
//            codewordArray[i][0] = entries2of13 + entries5of13;
//            codewordArray[i][1] = 0;
//        }
//        codewordArray[0][0] = 659;
//        codewordArray[9][0] = 636;
    fcs := OneCodeMathFcs(byteArray);
    for i := 0 to 9 do
    begin
      codewordArray[i][0] := entries2of13 + entries5of13;
      codewordArray[i][1] := 0;
    end;
    codewordArray[0][0] := 659;
    codewordArray[9][0] := 636;

//        OneCodeMathDivide(ds);
//        codewordArray[9][1] *= 2;
//        if (fcs >> 10 != 0) codewordArray[0][1] += 659;
    OneCodeMathDivideStr(ds);
    codewordArray[9][1] := codewordArray[9][1] * 2;
    if ((fcs shr 10) <> 0) then
    begin
      codewordArray[0][1] := codewordArray[0][1] + 659;
    end;

//        Int32[] ai = new Int32[65], ai1 = new Int32[65];
//        Decimal[][] ad = new Decimal[11][];
//        for (var i = 0; i <= 9; i++) ad[i] = new Decimal[2];

//        for (var i = 0; i <= 9; i++)
//        {
//            if (codewordArray[i][1] >= (Decimal)(entries2of13 + entries5of13)) return String.Empty;
//            ad[i][0] = 8192;
//            if (codewordArray[i][1] >= (Decimal)entries2of13) ad[i][1] = table2of13[(Int32)(codewordArray[i][1] - entries2of13)];
//            else ad[i][1] = table5of13[(Int32)codewordArray[i][1]];
//        }
    for i := 0 to 9 do
    begin
      if (codewordArray[i][1] >= entries2of13 + entries5of13) then
      begin
        // Raise some error here
      end;
      ad[i][0] := 8192;
      if (codewordArray[i][1] >= entries2of13) then
      begin
        ad[i][1] := table2of13[Trunc(codewordArray[i][1] - entries2of13)];
      end else
      begin
        ad[i][1] := table5of13[Trunc(codewordArray[i][1])];
      end;
    end;

//        for (var i = 0; i <= 9; i++) if ((fcs & 1 << i) != 0) ad[i][1] = ~(Int32)ad[i][1] & 8191;
    for i := 0 to 9 do
    begin
      if ((fcs and (1 shl i)) <> 0) then
      begin
        a := Trunc(ad[i][1]);
        ad[i][1] := (not a) and 8191;
      end;
    end;

//        for (var i = 0; i <= 64; i++)
//        {
//            ai[i] = (Int32)ad[BarTopCharacterIndexArray[i]][1] >> BarTopCharacterShiftArray[i] & 1;
//            ai1[i] = (Int32)ad[BarBottomCharacterIndexArray[i]][1] >> BarBottomCharacterShiftArray[i] & 1;
//        }
    for i := 0 to 64 do
    begin
      ai[i] := (Trunc(ad[BarTopCharacterIndexArray[i]][1]) shr BarTopCharacterShiftArray[i]) and 1;
      ai1[i] := (Trunc(ad[BarBottomCharacterIndexArray[i]][1]) shr BarBottomCharacterShiftArray[i]) and 1;
    end;

//        encoded = "";
//        // T: track, D: descender, A: ascender, F: full bar
//        for (var i = 0; i <= 64; i++)
//        {
//            if (ai[i] == 0) encoded += (ai1[i] == 0) ? "T" : "D";
//            else encoded += (ai1[i] == 0) ? "A" : "F";
//        }
    FEncoded := '';
    for i := 0 to 64 do
    begin
      if (ai[i] = 0) then
      begin
        if (ai1[i] = 0) then
        begin
          FEncoded := FEncoded + 'T';
        end else
        begin
          FEncoded := FEncoded + 'D';
        end;
      end else
      begin
        if (ai1[i] = 0) then
        begin
          FEncoded := FEncoded + 'A';
        end else
        begin
          FEncoded := FEncoded + 'F';
        end;
      end;
    end;
  end;
end;

(*
    public static String OneCodeDecode(this String source)
    {
        if (!System.Text.RegularExpressions.Regex.IsMatch(source, "^[ADFT]{65}$")) return String.Empty;
        Int32[] ad = new Int32[10], byteArray = new Int32[13];
        Int32 r = 0;
        System.Text.StringBuilder bin = new System.Text.StringBuilder();
        String result = String.Empty;
        for (var i = 0; i <= 64; i++)
        {
            if (source[i] == 'T') bin.Append("00");
            else if (source[i] == 'D') bin.Append("01");
            else if (source[i] == 'A') bin.Append("10");
            else bin.Append("11");
        }
        String bits = bin.ToString();
        for (var i = 0; i <= 128; i += 2)
        {
            Int32 v = Convert.ToInt32(bits.Substring(i, 2), 2), k = i / 2;
            if ((v > 1)) ad[BarTopCharacterIndexArray[k]] += 1 << BarTopCharacterShiftArray[k];
            if ((v % 2 == 1)) ad[BarBottomCharacterIndexArray[k]] += 1 << BarBottomCharacterShiftArray[k];
        }
        for (var i = 0; i <= 9; i++)
        {
            Int32 test = ad[i], index = Array.IndexOf(table5of13, test);
            if ((index < 0))
            {
                test = ~test & 8191;
                index = Array.IndexOf(table5of13, test);
                if ((index < 0))
                {
                    index = Array.IndexOf(table2of13, test);
                    index += 1287;
                }
            }
            ad[i] = index;
        }
        ad[9] = (Int32)ad[9] / 2;
        if ((ad[0] > 658)) ad[0] -= 659;
        OneCodeMathAdd(ref byteArray, 13, ad[0]);
        for (var i = 1; i <= 8; i++)
        {
            OneCodeMathMultiply(ref byteArray, 13, 1365);
            OneCodeMathAdd(ref byteArray, 13, ad[i]);
        }
        OneCodeMathMultiply(ref byteArray, 13, 636);
        OneCodeMathAdd(ref byteArray, 13, ad[9]);
        r = OneCodeMathMod(byteArray, 10);
        result = r.ToString() + result;
        for (var i = 2; i <= 19; i++)
        {
            OneCodeMathAdd(ref byteArray, 13, -r);
            OneCodeMathDivide(ref byteArray, 10);
            r = OneCodeMathMod(byteArray, 10);
            result = r.ToString() + result;
        }
        OneCodeMathAdd(ref byteArray, 13, -r);
        OneCodeMathDivide(ref byteArray, 5);
        r = OneCodeMathMod(byteArray, 5);
        result = r.ToString() + result;
        OneCodeMathAdd(ref byteArray, 13, -r);
        OneCodeMathDivide(ref byteArray, 10);
        Byte[] restBytes = new Byte[8];
        for (var i = 12; i >= 5; i += -1) restBytes[12 - i] = (Byte)byteArray[i];
        Int64 rest = BitConverter.ToInt64(restBytes, 0);
        if (rest > 1000100001) result += (rest - 1000100001).ToString().PadLeft(11, '0');
        else if (rest > 100001) result += (rest - 100001).ToString().PadLeft(9, '0');
        else if (rest > 0) result += (rest - 1).ToString().PadLeft(5, '0');
        return result;
    }
*)

//    private static Int32[] OneCodeInfo(Int32 topic)
function TOneCodeBars.OneCodeInfo(topic: Integer): TQPLIntegerArray;
begin
  case topic of
    1:
    begin
//                Int32[] a = new Int32[table2of13Size + 2];
//                OneCodeInitializeNof13Table(ref a, 2, table2of13Size);
//                entries5of13 = table2of13Size;
//                return a;
      SetLength(Result, table2of13Size + 2);
      OneCodeInitializeNof13Table(Result, 2, table2of13Size);
      entries5of13 := table2of13Size
    end;
    2:
    begin
//                Int32[] b = new Int32[table5of13Size + 2];
//                OneCodeInitializeNof13Table(ref b, 5, table5of13Size);
//                entries2of13 = table5of13Size;
//                return b;
      SetLength(Result, table5of13Size + 2);
      OneCodeInitializeNof13Table(Result, 5, table5of13Size);
      entries2of13 := table5of13Size;
    end;
  else
//          return new int[2];
    SetLength(Result, 2);
  end;
end;

(*    private static Decimal[][] OneCodeInfo()
    {
        Decimal[][] da = new Decimal[11][];
        try
        {
            for (var i = 0; i <= 9; i++) da[i] = new Decimal[2];
            return da;
        }
        finally
        {
            da = null;
        }
    }
*)

//    private static Boolean OneCodeInitializeNof13Table(ref Int32[] ai, Int32 i, Int32 j)
function TOneCodeBars.OneCodeInitializeNof13Table(var ai: TQPLIntegerArray; i, j: Integer): Boolean;
var
  i1: Integer;
  j1: Integer;
  k: Integer;
  k1: Integer;
  l: Integer;
  l1: Integer;
  flag: Boolean;
begin
//  Int32 i1 = 0, j1 = j - 1;
//  for (var k = 0; k <= 8191; k++)
  i1 := 0;
  j1 := j - 1;
  for k := 0 to 8191 do
  begin

//      Int32 k1 = 0;
//      for (var l1 = 0; l1 <= 12; l1++) if ((k & 1 << l1) != 0) k1 += 1;
    k1 := 0;
    for l1 := 0 to 12 do
    begin
      if ((k and (1 shl l1)) <> 0) then
      begin
        Inc(k1, 1);
      end;
    end;

//      if (k1 == i)
    if (k1 = i) then
    begin
      l := OneCodeMathReverse(k) shr 3;
      flag := (k = l);
      if (l >= k) then
      begin
        if (flag) then
        begin
          ai[j1] := k;
          Dec(j1, 1);
        end else
        begin
          ai[i1] := k;
          Inc(i1, 1);
          ai[i1] := l;
          Inc(i1, 1);
        end;
      end;
    end;
  end;

//  return i1 == j1 + 1;
  Result := i1 = (j1 + 1);
end;

function TOneCodeBars.OneCodeMathAdd(var bytearray: TQPLIntegerArray; i, j: Integer): Boolean;
var
  carry: Integer;
begin
//        if (j == 0) return true;
//        if (bytearray == null) return false;
//        if (i < 1) return false;
  if (j = 0) then
  begin
    Result := True;
    Exit;
  end;

  if (i < 1) then
  begin
    Result := False;
    Exit;
  end;

//        i -= 1;
//        bytearray[i] += j;
//        Int32 carry = 0;
  Dec(i, 1);
  Inc(bytearray[i], j);
//  carry := 0;

//        if (j > 0)
//        {
//            while (i > 0 & bytearray[i] > 255)
//            {
//                carry = (bytearray[i] >> 8);
//                bytearray[i] = bytearray[i] % 256;
//                i -= 1;
//                bytearray[i] += carry;
//            }
//        }
//        else
//        {
//            while (i > 0 & bytearray[i] < 0)
//            {
//                carry = 1;
//                bytearray[i] += 256;
//                i -= 1;
//                bytearray[i] -= carry;
//            }
//        }
  if (j > 0) then
  begin
    while ((i > 0) and (bytearray[i] > 255)) do
    begin
      carry := (bytearray[i] shr 8);
      bytearray[i] := bytearray[i] mod 256;
      Dec(i, 1);
      Inc(bytearray[i], carry);
    end;
  end else
  begin
    while ((i > 0) and (bytearray[i] < 0)) do
    begin
      carry := 1;
      Inc(bytearray[i], 256);
      Dec(i, 1);
      Dec(bytearray[i], carry);
    end;
  end;

//        return true;
  Result := True;
end;
 (*
    private static Int32 OneCodeMathMod(Int32[] byteArray, Int32 d)
    {
        Int32 i = 0, r = 0, l = byteArray.Length;
        while ((i < 13))
        {
            r <<= 8;
            r = r | byteArray[i];
            r = r % d;
            i += 1;
        }
        return r;
    }
*)

//    private static void OneCodeMathDivide(ref Int32[] byteArray, Int32 d)
(*procedure TOneCodeBars.OneCodeMathDivide(var byteArray: TQPLIntegerArray; d: Integer);
var
  i: Integer;
  r: Integer;
  l: Integer;
begin
//        Int32 i = 0, r = 0, l = byteArray.Length;
  i := 0;
  r := 0;
  l := Length(byteArray);

//        while ((i < l))
//        {
//            r <<= 8;
//            r = r | byteArray[i];
//            byteArray[i] = (int)r / d;
//            r = r % d;
//            i += 1;
//        }
  while (i < l) do
  begin
    r := r shl 8;
    r := r or byteArray[i];
    byteArray[i] := r div d;
    r := r mod d;
    Inc(i, 1);
  end;
end;*)

//    private static void OneCodeMathDivide(String v)
procedure TOneCodeBars.OneCodeMathDivideStr(const v: WideString);
var
  j: Integer;
  n: WideString;
  k: Integer;
  r: WideString;
  scopy: WideString;
  left: WideString;
  divident: Integer;
  divider: Integer;
  i: Integer;
  l: Integer;
begin
//        // back to school - you may change it to use shitfing
//        Int32 j = 10;
//        String n = v;
  j := 10;
  n := v;

//        for (var k = j - 1; k >= 1; k += -1)
  k := j - 1;
  while (k >= 1) do
  begin
//            String r = String.Empty, copy = n, left = "0";
//            Int32 divider = (Int32)codewordArray[k][0], l = copy.Length;
    r := '';
    scopy := n;
    left := '0';
    divider := Trunc(codewordArray[k][0]);
    l := Length(scopy);

//            for (var i = 1; i <= l; i++)
    i := 1;
    while (i <= l) do
    begin
      divident := StrToInt(Copy(scopy, 1, i));

      while ((divident < divider) and (i < (l - 1))) do
      begin
        r := r + '0';
        Inc(i, 1);
        divident := StrToInt(Copy(scopy, 1, i));
      end;
      r := r + IntToStr((divident div divider));
      left := IntToStr(divident mod divider);
      while (Length(left) < i) do
      begin
        left := '0' + left;
      end;
      scopy := left + Copy(scopy, i + 1, MaxInt);
      Inc(i);
    end;

//        n = r.TrimStart('0');
    n := r;
    while (Copy(n, 1, 1) = '0') do
    begin
      Delete(n, 1, 1);
    end;

//    if (String.IsNullOrEmpty(n)) n = "0";
    if (n = '') then
    begin
      n := '0';
    end;

    codewordArray[k][1] := StrToInt(left);
    if (k = 1) then
    begin
      codewordArray[0][1] := StrToInt(r);
    end;
    Dec(k);
  end;
end;


//    private static Int32 OneCodeMathFcs(Int32[] bytearray)
function TOneCodeBars.OneCodeMathFcs(bytearray: TQPLIntegerArray): Integer;
var
  c: Integer;
  i: Integer;
  j: Integer;
  b: Integer;
  k: Integer;
  l: Integer;
begin
//        Int32 c = 3893, i = 2047, j = bytearray[0] << 5;
  c := 3893;
  i := 2047;
  j := bytearray[0] shl 5;

//        for (var b = 2; b <= 7; b++)
//        {
//            if (((i ^ j) & 1024) != 0) i = (i << 1) ^ c;
//            else i = i << 1;
//            i = i & 2047;
//            j = j << 1;
//        }
  for b := 2 to 7 do
  begin
    if (((i xor j) and 1024) <> 0) then
    begin
      i := (i shl 1) xor c;
    end else
    begin
       i := i shl 1;
    end;
    i := i and 2047;
    j := j shl 1;
  end;


//        for (var l = 1; l <= 12; l++)
//        {
//            Int32 k = bytearray[l] << 3;
//            for (var b = 0; b <= 7; b++)
//            {
//                if (((i ^ k) & 1024) != 0) i = (i << 1) ^ c;
//                else i = i << 1;
//                i = i & 2047;
//                k = k << 1;
//            }
//        }
  for l := 1 to 12 do
  begin
    k := bytearray[l] shl 3;
    for b := 0 to 7 do
    begin
      if (((i xor k) and 1024) <> 0) then
      begin
        i := (i shl 1) xor c;
      end else
      begin
        i := i shl 1;
      end;
      i := i and 2047;
      k := k shl 1;
    end;
  end;

//        return i;
  Result := i;
end;

function TOneCodeBars.OneCodeMathMultiply(var bytearray: TQPLIntegerArray; i, j: Integer): Boolean;
var
  x: Integer;
  l: Integer;
  k: Integer;
begin
//        if (bytearray == null) return false;
//        if (i < 1) return false;
  if (i < 1) then
  begin
    Result := False;
    Exit;
  end;

//        Int32 l = 0, k = 0;
//        for (k = i - 1; k >= 1; k += -2)
//        {
//            Int32 x = (bytearray[k] | (bytearray[k - 1] << 8)) * j + l;
//            bytearray[k] = x & 255;
//            bytearray[k - 1] = x >> 8 & 255;
//            l = x >> 16;
//        }
  l := 0;
  k := i - 1;
  while (k >= 1) do
  begin
    x := (bytearray[k] or (bytearray[k - 1] shl 8)) * j + l;
    bytearray[k] := x and 255;
    bytearray[k - 1] := (x shr 8) and 255;
    l := x shr 16;
    Dec(k, 2);
  end;

//        if (k == 0) bytearray[0] = (bytearray[0] * j + l) & 255;
//        return true;
  if (k = 0) then
  begin
    bytearray[0] := (bytearray[0] * j + l) and 255;
  end;
  Result := True;
end;

function TOneCodeBars.OneCodeMathReverse(i: Integer): Integer;
var
  j: Integer;
  k: Integer;
begin
  j := 0;
  for k := 0 to 15 do
  begin
    j := j shl 1;
    j := j or (i and 1);
    i := i shr 1;
  end;
  Result := j;
end;

(*    private static String TrimOff(String source, String bad)
    {
        Int32 l = bad.Length - 1;
        for (var i = 0; i <= l; i++) source = source.Replace(bad.Substring(i, 1), String.Empty);
        return source;
    }

}*)

end.
