unit UAuthorization;

interface
uses
 SysUtils,
 WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
 UDeclare;

 Function  GetAuthorizationKey:String;
 Procedure GetLicenseLevel;
 Function  ValidateKey(AKey:String;PgmNames,ProductIds,PgmFactors:TStringList):Boolean;
 Function  MakeHashString(TheKey:String;PgmNames,ProductIds,PgmFactors:TStringList):String;
 procedure LoadProducts(PgmNames,ProductIds,PgmFactors:TStringList);
 Function  GetProductId(Pgm:String;PgmNames,ProductIds,PgmFactors:TStringList):String;
 Function  GetProductFactor(ProductId:String;PgmNames,ProductIds,PgmFactors:TStringList):Integer;
 Function  GetProductName(ProductId:String;PgmNames,ProductIds,PgmFactors:TstringList):String;

implementation
Uses TrimStr,UAskForKey;

Procedure GetLicenseLevel;
  Const ActivationFile = 'LVerf.EX_';
  Var SomeString: TstringList;
  PgmNames,ProductIds,PgmFactors:TstringList;

Begin
 LicenseLevel:='';
 { Result :='';} {default to no key}
  PgmNames:=TstringList.Create;
  ProductIds:=TstringList.Create;
  PgmFactors:=TstringList.Create;
  LoadProducts(PgmNames,ProductIds,PgmFactors);
  SomeString := TstringList.Create;
  If FileExists(AppDir+'\'+ActivationFile) then
    SomeString.LoadFromFile(AppDir+'\'+ActivationFile)
  else
    begin
     SomeString.add('1111-1111-1111-1111');   {no zeros must be invalid}
     SomeString.add('  ');
    end;

  If ValidateKey(SomeString[0],PgmNames,ProductIds,PgmFactors) = false then
  begin
   ExecuteForm(TAskForKey);
   {Result:=AskForKey.Edit1.Text;}
  end
  else
  begin
   LicenseLevel:= GetProductName(LeftStr(SomeString[0],4),PgmNames,ProductIds,PgmFactors);
   Licensee := MidStr(SomeString[0],41,30);
   SomeString.Free;
  end;
  PgmNames.Free;
  ProductIds.Free;
  PgmFactors.Free;
end;

Function ValidateKey(AKey:String;PgmNames,ProductIds,PgmFactors:TStringList):Boolean;
begin
 If MidStr(AKey,16,4) = MakeHashString(AKey,PgmNames,ProductIds,PgmFactors) then
   result:=True
 else
   result:=False;
 If UpperCase(LeftStr(AKey,2)) <> UpperCase(LeftStr(AppName,2)) then
   result:=False;  {T1 key goes with T1, etc}

end;

Function MakeHashString(TheKey:String;PgmNames,ProductIds,PgmFactors:TStringList):String;
Var PgmId,PgmNum,Random1,Random2:String;
Factor,factor2,HashNum:Integer;
begin
 PgmNum :=MidStr(TheKey,3,2);
 Random1:=MidStr(TheKey,6,4);
 Random2:=MidStr(TheKey,11,4);

 PgmId  := LeftStr(TheKey,4);
 Factor:=GetProductFactor(PgmId,PgmNames,ProductIds,PgmFactors);
 If      LeftStr(PgmId,2)='T1' then Factor2:=31
 else If LeftStr(PgmId,2)='T2' then Factor2:=32
 else If LeftStr(PgmId,2)='TF' then Factor2:=33
 else If LeftStr(PgmId,2)='T4' then Factor2:=34
 else If LeftStr(PgmId,2)='FP' then Factor2:=35;

 (*2003
 If      LeftStr(PgmId,2)='T1' then Factor2:=10
 else If LeftStr(PgmId,2)='T2' then Factor2:=20
 else If LeftStr(PgmId,2)='TF' then Factor2:=30
 else If LeftStr(PgmId,2)='T4' then Factor2:=40
 else If LeftStr(PgmId,2)='FP' then Factor2:=50;
 *)

 HashNum :=  (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor+Factor2)
           +  Factor2
           + (StrToInt(Random1[1])+ StrToInt(Random1[2])
           +  StrToInt(Random1[3])+ StrToInt(Random1[4])) * Factor
           + (StrToInt(Random2[1])+ StrToInt(Random2[2])
           +  StrToInt(Random2[3])+ StrToInt(Random2[4])) * Factor;
 Result:=PaddZero(AllTrim(IntToStr(HashNum)),4);
end;

procedure LoadProducts(PgmNames,ProductIds,PgmFactors:TStringList);
begin
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('67');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('68');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('69');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T103'); PgmFactors.Add('70');
 PgmNames.Add('T1 Power');       ProductIds.Add('T104'); PgmFactors.Add('71');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T105'); PgmFactors.Add('72');


 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('73');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('74');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('75');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('76');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('77');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('78');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('79');


 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('80');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('81');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('82');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('83');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('84');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('85');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('86');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('87');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('88');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('89');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('90');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('91');

 (* 2003
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('1');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('2');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('3');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T103'); PgmFactors.Add('4');
 PgmNames.Add('T1 PaperFile');   ProductIds.Add('T104'); PgmFactors.Add('5');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('6');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('7');


 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('8');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('9');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T202'); PgmFactors.Add('10');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T203'); PgmFactors.Add('11');
 PgmNames.Add('T2 Dfile');       ProductIds.Add('T204'); PgmFactors.Add('12');
 PgmNames.Add('T2 Efile');       ProductIds.Add('T205'); PgmFactors.Add('13');
 PgmNames.Add('T2 MultiDFile');  ProductIds.Add('T206'); PgmFactors.Add('14');
 PgmNames.Add('T2 MultiEfile');  ProductIds.Add('T207'); PgmFactors.Add('15');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('16');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('17');

 PgmNames.Add('T4 Demo');        ProductIds.Add('TF00'); PgmFactors.Add('18');
 PgmNames.Add('T4 Standard');    ProductIds.Add('TF01'); PgmFactors.Add('19');
 PgmNames.Add('T4 Dfile');       ProductIds.Add('T402'); PgmFactors.Add('20');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('21');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP01'); PgmFactors.Add('22');
 PgmNames.Add('FP Agent');       ProductIds.Add('FP02'); PgmFactors.Add('23');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP03'); PgmFactors.Add('24');
 *)
end;

Function GetProductId(Pgm:String;PgmNames,ProductIds,PgmFactors:TStringList):String;
Var i:Integer;
begin
 result:='';
 For i:=0 to PgmNames.count-1 do
 begin
  If Pgm = PgmNames[i] then
  begin
   result := ProductIds[i];
   exit;
  end;
 end;
 ShowMessage('Program Id not found'+
           Chr(13)+'The Authorization key is incorrect');
end;

Function GetProductFactor(ProductId:String;PgmNames,ProductIds,PgmFactors:TstringList):Integer;
Var i:Integer;
begin
 For i:=0 to ProductIds.count-1 do
 begin
  If ProductId = ProductIds[i] then
  begin
   result := StrToInt(PgmFactors[i]);
   exit;
  end;
 end;
 ShowMessage('Product Id not found'+
   Chr(13)+'Authorization key is incorrect');
end;


Function GetProductName(ProductId:String;PgmNames,ProductIds,PgmFactors:TstringList):String;
Var i:Integer;
begin
 For i:=0 to ProductIds.count-1 do
 begin
  If ProductId = ProductIds[i] then
  begin
   result := PgmNames[i];
   exit;
  end;
 end;
 ShowMessage('Product Id not found'+
   Chr(13)+'Authorization key is incorrect');
end;

(*
Function ValidateKey(ThisKey:String):Boolean;
Var S1,S2:String;VersionNum:ShortInt; AChar:Char;
begin
 AChar := ThisKey[9];
 VersionNum := StrToInt(AChar);
 s1:=IntToStr(VersionNum*2+2);
 s2:=IntToStr(VersionNum+3);
 If (ThisKey[13] <>S1[1]) or (ThisKey[14] <>S2[1]) then
   result:=False
 else
   result := True;
end;
*)


Function GetAuthorizationKey:String;
  Const ActivationFile = 'LVerf.EX_';
  Var SomeString: TstringList;
Begin
  Result :='N/A'; {default to no key}
  SomeString := TstringList.Create;
  If FileExists(AppDir+'\'+ActivationFile) then
   begin
    SomeString.LoadFromFile(AppDir+'\'+ActivationFile);
    Result:= SomeString[0];
   end;
  SomeString.Free;
end;


end.