unit TF_2026calc3;

interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 TF_2026Declare, TF_2026common, TF_2026common2, TF_2026TrimStr;


Procedure NR4SUM(RetNo:integer;FName:String;FNo:integer);
Procedure NR4DET(RetNo:integer;FName:string;FNo:integer);
Procedure T5018G(RetNo: integer; FName: String;FNo: integer);
Procedure T5018L(RetNo: integer; FName: String;FNo: integer); {slip}
Procedure T5018S(RetNo: integer; FName: String;FNo: integer); {slip}
Procedure RC145(RetNo:integer;FName:string;FNo:integer);



Procedure GST20(RetNo:integer;FName:string;FNo:integer);
Procedure GST20i(RetNo:integer;FName:string;FNo:integer);

Procedure GST70(RetNo:integer;FName:string;FNo:integer);

Procedure GST71(RetNo:integer;FName:string;FNo:integer);

Procedure GST74(RetNo:integer;FName:string;FNo:integer);

Procedure GS176(RetNo:integer;FName:string;FNo:integer);

Procedure GS303(RetNo:integer;FName:string;FNo:integer);

procedure PrepLetter(RetNo: integer; FName: String;FNo: integer;Pg:integer);

implementation
Uses TF_2026Calc, vtShared, TF_2026, vtCommon, vtTrimStr;

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

Procedure NR4DET(RetNo:integer;FName:string;FNo:integer);
Var i:Integer; Nr4SumFNo:Integer;
begin
  Nr4SumFNo:=GetFormNo('NR4SUM');
  LoadTv (RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    if strings[101]+Strings[102]+Strings[103]='' then Strings[101]:='X'; //20180315
    If Strings[1]='' then Strings[1]:=AppYear;
    If Strings[6]>'' then begin If Strings[7]='' then Strings[7]:='CAD';end;
    If Strings[11]>'' then begin If Strings[12]='' then Strings[12]:='CAD';end;
    Strings[36]:=Strings[3];
    Strings[35]:=FetchElmFNo(RetNo,Nr4SumFNo,3);  //20180216


    Strings[28]:=FetchElmFNo(RetNo,Nr4SumFNo,4);
    Strings[29]:=FetchElmFNo(RetNo,Nr4SumFNo,5); //str
    Strings[31]:=FetchElmFNo(RetNo,Nr4SumFNo,6); //City
    Strings[32]:=FetchElmFNo(RetNo,Nr4SumFNo,7); //Prov
    Strings[33]:= FetchElmFNo(RetNo,Nr4SumFNo,8); //Postal
    Strings[34]:= FetchElmFNo(RetNo,Nr4SumFNo,26); //Country


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


Procedure T5018S(RetNo: integer; FName: String;FNo: integer); {slip}
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  If Strings[10]+Strings[11] = '' then Strings[10] :='X';
  Strings[12] := IntToStr(CountT5018Slips(RetNo));
  Tv[13] := TotMultiple(RetNo,'T5018L',2);
  If Strings[19]='' then Strings[19]:=FormatDateTime('yyyy-mm-dd',Now);
  Strings[17]:=RemoveChar(Strings[17],' ');
 // if (Strings[22]='') then Strings[22]:='CAN';
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

//20170610
Procedure NR4SUM(RetNo:integer;FName:String;FNo:integer);
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  if Strings[1]='' then Strings[1]:=AppYear;  //20170729

  Strings[9]:=IntToStr(CountNR4Slips(RetNo));
  Tv[10]:=TotMultiple(RetNo,'NR4DET',8)+TotMultiple(RetNo,'NR4DET',13);  //gross
  Tv[11]:=TotMultiple(RetNo,'NR4DET',9)+TotMultiple(RetNo,'NR4DET',14);  //tax withheld
  Tv[14]:=Tv[10]+Tv[12];
  Tv[15]:=Tv[11]+Tv[13];
  Tv[17]:=Tv[15]-Tv[16];
  if Tv[17]>0 then
  begin
   Tv[18]:=0;
   Tv[19]:=ABS(Tv[17]);
  end
  Else
  Begin
   Tv[18]:=ABS(Tv[17]);
   Tv[19]:=0;
  End;
  if Strings[24]='' then Strings[24]:=FormatDateTime('YYYY-MM-DD',Now);
 end;
 SaveTv(RetNo,FName,FNo);
end;

end.
