unit T3_2026calc3;

interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 T3_2026Declare, T3_2026common, T3_2026common2, T3_2026TrimStr;


Procedure RC145(RetNo:integer;FName:string;FNo:integer);
procedure PrepLetter(RetNo: integer; FName: String;FNo: integer;Pg:integer);

Procedure T3QDT(RetNo: integer; FName: String;FNo: integer);

implementation
Uses T3_2026Calc, vtShared, T3_2026, vtCommon, vtTrimStr;

procedure PrepLetter(RetNo: integer; FName: String;FNo: integer;Pg:integer);
Var  i,LinesInPage1,MaxLinesInPage,Ltr2FNo: integer;AList :TstringList;Txt :string;
    CleanList:TstringList;CoverLetterFile:String;
begin
If LetterType = 'Cover' then {calc only if cover}
 begin
  LoadTv(RetNo,FName,FNo);

  with Ret[RetNo].Frm[Fno] do
  Begin
   For i:=1 to 60 do Strings[i] :='';
   LoadDataDict;
   AList := TStringList.Create;
   CoverLetterFile := 'COVER1.LTR';
   If FileExists(AppDir+'\'+CoverLetterFile) then
      AList.LoadFromFile(AppDir+'\'+CoverLetterFile);
   For i :=0 to AList.Count-1 do {first pass:conditions stay in}
    begin
     txt := AList[i];
     InterpretTextLine(txt);
     AList[i] := txt; {put it back}
    end;
   ResolveConditions(AList);  {second pass}
   ExpandTabs(AList);
   AllowLinesForLogo(Alist);

   MaxLinesInPage := 59;
   Ltr2FNo := GetFormNo('LETR_2');
   If AList.Count >MaxLinesInPage then
    begin LinesInPage1:=MaxLinesInPage; Ret[RetNo].FrmHasData[Ltr2FNo] := True;end
   else
    begin LinesInPage1:=AList.Count;Ret[RetNo].FrmHasData[Ltr2FNo] := False;end;
   InitFormData(RetNo,GetFormNo('LETR_1'));
   InitFormData(RetNo,GetFormNo('LETR_2'));
   for i:=0 to LinesInPage1-1 do
     Ret[RetNo].Frm[GetFormNo('LETR_1')].Strings[i+1] := AList[i];
   for i:=LinesInPage1 to AList.Count-1 do
     Ret[RetNo].Frm[GetFormNo('LETR_2')].Strings[i-MaxLinesInPage+1] := AList[i];
  end;  {with}
  AList.Free;
 end; {end if Cover}
end;


Procedure GST20(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin

  LoadTv (RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[17] := Tv[111]; //Vl(FetchElm(RetNo,'GST20_1',11));
    If UpperCase(Strings[28]) = 'Y' then Tv[17] := Tv[29];
  end; { end with}


  //GST20 pg2 ------------------------------------------------------------------

  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[108] := Tv[102]+Tv[103]+Tv[104]+Tv[105]+Tv[106];
    Tv[109] := MaxR(0,Tv[101] - Tv[108]);
    If Vl(Strings[112])=0 then Strings[112] :='365';
    If Vl(Strings[112]) >0 then Tv[110] := Tv[109]/Vl(Strings[112]) else Tv[110] :=0;
    Tv[111]:=Tv[110] * 365;

  end; { end with}

  SaveTv (RetNo, Fname, FNo);
end;

Procedure GST20I(RetNo:integer;FName:string;FNo:integer);
Var i:Integer; //instructions
begin
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
  end; { end with}
  SaveTv (RetNo, Fname, FNo);
end;

Procedure GST70(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    {?}
  end; { end with}
  SaveTv (RetNo, Fname, FNo);
end;

Procedure GST71 (RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    {?}
  end; { end with}
  SaveTv (RetNo, Fname, FNo);
end;

Procedure GST74(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    {?}
  end; { end with}
  SaveTv (RetNo, Fname, FNo);
end;

Procedure GS176(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    Tv[25] := Tv[20]+Tv[23];
    {
    Tv[21] := Tv[15]+Tv[17];
    Tv[22] := Tv[16]+Tv[18];
    Tv[23] := Tv[21]+Tv[22];
    }
  end; { end with}

  with Ret[RetNo].Frm[FNo] do
  begin
    {?}
  end; { end with}

  SaveTv (RetNo, Fname, FNo);
end;


Procedure GS303(RetNo:integer;FName:string;FNo:integer);
Var i:Integer;
begin
  LoadTv (RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    {?}
  end; { end with}

  with Ret[RetNo].Frm[FNo] do
  begin
    {?}
  end; { end with}

  with Ret[RetNo].Frm[FNo] do
  begin
    {?}
  end; { end with}

  SaveTv (RetNo, Fname, FNo);
end;


Procedure T5018L(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Strings[1] := FetchElm(RetNo,'T5018S',1);
  Strings[16] := FetchElm(RetNo,'T5018S',3);
  Strings[17] := ''; //BN/account number for payer must not be shown

  if Strings[3] + Strings[5] > '' then
  begin
    Strings[6] := '';
    Strings[7] := '';
    Strings[8] := '';
  end;
  if Strings[4] > '' then
    Strings[9] := '';

  Strings[31] := Strings[1];
  Tv[32] :=  Tv[2];
  for i:=3 to 17 do
  begin
    Strings[i+30] := Strings[i];
  end;
 //20110317
 if (Strings[15]='') or (length(Strings[15])<3) then
        Strings[15]:='CAN';

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure T5018G(RetNo: integer; FName: String;FNo: integer);
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure RC145(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  //
 end;
 SaveTv(RetNo,FName,FNo);
end;

//jz//20260322
Procedure T3QDT(RetNo: integer; FName: String;FNo: integer);
var
  T3elmsOption1,T3elmsOption2,T3elmsSelected:TArray<Integer>;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  Begin                                   //0   1   2   3   4   5   6   7   8   9
    T3elmsOption1 := TArray<Integer>.Create(001,002,003,053,017,004,007,067,023,008);
    T3elmsOption2 := TArray<Integer>.Create(001,002,055,060,017,064,065,066,073,074);

    if fetchElm(RetNo,'T3',136) > '' then T3elmsSelected := T3elmsOption1  //option 1 - individual
    else                                  T3elmsSelected := T3elmsOption2; //option 2 - non-individual

    strings[1]  := FetchElm(RetNo,'T3',T3elmsSelected[0]);  //name of trust
    strings[2]  := FetchElm(RetNo,'T3',T3elmsSelected[1]);  //trust account number
    strings[3]  := FetchElm(RetNo,'T3',T3elmsSelected[2]);  //first name of trustee
    strings[4]  := FetchElm(RetNo,'T3',T3elmsSelected[3]);  //last name of trustee
    strings[5]  := FetchElm(RetNo,'T3',T3elmsSelected[4]);  //date
    strings[41] := FetchElm(RetNo,'T3',T3elmsSelected[5]);  //address of trustee
    strings[42] := FetchElm(RetNo,'T3',T3elmsSelected[6]);  //city of trustee
    strings[43] := FetchElm(RetNo,'T3',T3elmsSelected[7]);  //province of trustee
    strings[44] := FetchElm(RetNo,'T3',T3elmsSelected[8]);  //country  of trustee
    strings[45] := FetchElm(RetNo,'T3',T3elmsSelected[9]);  //postal of trustee

  end;
  SaveTv(RetNo,FName,FNo);
end;

(*
//jz//20260320
Procedure T3QDT(RetNo: integer; FName: String;FNo: integer);
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[FNo] do
  Begin
    strings[1]  := FetchElm(RetNo,'T3',1);  //name of trust
    strings[2]  := FetchElm(RetNo,'T3',2);  //trust account number
    strings[3]  := FetchElm(RetNo,'T3',3);  //first name of trustee
    strings[4]  := FetchElm(RetNo,'T3',53); //last name of trustee
    strings[5]  := FetchElm(RetNo,'T3',17); //date
    strings[41] := FetchElm(RetNo,'T3',4);  //address of trustee
    strings[42] := FetchElm(RetNo,'T3',7);  //city of trustee
    strings[43] := FetchElm(RetNo,'T3',67); //provence of trustee
    strings[44] := FetchElm(RetNo,'T3',23); //country  of trustee
    strings[45] := FetchElm(RetNo,'T3',8);  //postal of trustee
  end;
  SaveTv(RetNo,FName,FNo);
end;
*)



end.
