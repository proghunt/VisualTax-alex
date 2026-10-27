unit Ukeys;
{$B-}

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,Printers,
  Udeclare, TrimStr, uEncrypt; //20191015 Igor

  Procedure Delay(ms:LongInt);
  procedure LoadProducts;
  Function GetProductId(Pgm:String):String;
  Function GetRandomNum(BaseNum:Integer):Integer;
  Function MakeHashString(TheKey:String):String;
  Function GetProductFactor(ProductId:String):Integer;
  Function MakeAKey(ProductId:String):String;
  Function MakeADemoKey(ProductId: String; ADateExp: TDateTime):String; // 20180904 Igor
  //20190306 Igor >>>
  Function MakeHelperKey(ProductId:String; ACloudOptions: integer):String;
  Function MakeHelperDemoKey(ProductId: String; ADateExp: TDateTime; ACloudOptions: integer):String;
  Procedure GetHelperFactors(ProductId: String; out AF1, AF2: integer);
  //20190306 Igor <<<
  Function PaddZero(S:string;MaxLength:Integer):string;
  Function IsLimited(S: string): boolean; //20191021 Igor

//20191015 Igor >>>  
type
  TBNList = class(TStringList)
  protected
    function GetEncryptedText: string;
    function NormalizeFileName(AFileName: string): string;
  public
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;
    property EncryptedText: string read GetEncryptedText;
  end;

const
  BNListKey = 'T6kYmS9b?A$=9yChLYCG';

//20191015 Igor <<<

//20200611 Igor >>>

type
  TLicenseList = class(TStringList)
  private
    FChanged: Boolean;
    FLicenseFile: string;
    procedure SetPassword(const Value: string);
    function GetPassword: string;
    function GetKeys(const AppId: string): string;
    procedure SetKeys(const AppId, Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: string); override;
    procedure SaveToFile(const FileName: string); override;
    procedure Save;
    procedure Load;
    property Password: string read GetPassword write SetPassword;
    property Keys[const AppId: string]: string read GetKeys write SetKeys;
    property Changed: Boolean read FChanged;
  end;

//20200611 Igor <<<

Var
  Pgm:String;
  PgmId:String;
  TheKey :String;
  Base1,Base2 :String[4];
  BaseString: String[7];
  Version :String;


implementation

Function IsLimited(S: string): boolean; //20191021 Igor
begin
  Result := (S = '1') or (S = '2') or (S = '3') or (S = '4') or (S = '5') or (S = '6');
end;

Function MakeAKey(ProductId:String):String;
Var k:String;
begin
 k:=ProductId
    +'-'+PaddZero(IntToStr(GetRandomNum(9999)),4)
    +'-'+PaddZero(IntToStr(GetRandomNum(8888)),4);
 Result:=k+'-'+MakeHashString(k);
end;

procedure MyXOR(var S: String; const r1, r2, r3: Integer); overload; // 20180904 Igor //20190306 Igor
var
  X: Integer;
begin
  X := r1 * 1000 + r2 * 100 + r3 * 10 + r2 + r1 + ((r1 + r2 + r3) mod 5) * 10000;
  S := PaddZero(IntToStr(StrToInt(S) xor X), 5);
end;

procedure MyXOR(var S: String; const r1, r2: Integer); overload; //20190306 Igor
var
  X: Integer;
begin
  X := r1 * 10 + r2;
  S := PaddZero(IntToStr(StrToInt(S) xor X), 2);
end;

procedure GenerateMid(ADate: TDateTime; out ARandom1, ARandom2: String); // 20180904 Igor
var
  S: String;
  r1, r2, r3: Integer;
begin
  repeat
    S := IntToStr(Trunc(ADate));
    randomize;
    r1 := Random(9);
    r2 := Random(9);
    r3 := Random(9);
    MyXOR(S, r1, r2, r3);
  until Length(S) = 5;

  ARandom1 := copy(S, 1, 4);
  ARandom2 := copy(S, 5, 1) + IntToStr(r1) + IntToStr(r2) +IntToStr(r3);
end;

Function MakeADemoKey(ProductId: String; ADateExp: TDateTime):String; // 20180904 Igor
Var k:String;
    Random1, Random2: String;
begin
  GenerateMid(ADateExp, Random1, Random2);
  k:=ProductId
    +'-'+Random1
    +'-'+Random2;
  Result:=k+'-'+MakeHashString(k);
end;

function GetHelperHash(const AID, ARandom1, ARandom2, ARandom3: String; Factor, Factor2: Integer): String; //20190306 Igor
var
  HashNum: Integer;
begin
  HashNum :=  (StrToInt(AID[3]) + StrToInt(AID[4])) * (Factor + Factor2)
           + Factor2
           + (StrToInt(ARandom1[1]) + StrToInt(ARandom1[2]) + StrToInt(ARandom1[3]) + StrToInt(ARandom1[4])) * Factor
           + (StrToInt(ARandom2[1]) + StrToInt(ARandom2[2]) + StrToInt(ARandom2[3]) + StrToInt(ARandom2[4])) * Factor
           + (StrToInt(ARandom3[1]) + StrToInt(ARandom3[2]) + StrToInt(ARandom3[3]) + StrToInt(ARandom3[4]));
  Result := PaddZero(Trim(IntToStr(HashNum)),4);
end;

function HelperMakeKey(const AID, ARandom1, ARandom2, ARandom3: String; Factor, Factor2: Integer): String; //20190306 Igor
begin
  Result := AID + '-' + ARandom1 + '-' + ARandom2 + '-' + ARandom3 + '-' + GetHelperHash(AID, ARandom1, ARandom2, ARandom3, Factor, Factor2);
end;

function GenerateCloudOptions(ACloudOptions: Integer): string; //20190306 Igor
var
  S: String;
  r1, r2: Integer;
begin
  repeat
    S := IntToStr(ACloudOptions);
    randomize;
    r1 := Random(9);
    r2 := Random(9);
    MyXOR(S, r1, r2);
  until Length(S) = 2;

  Result := S + IntToStr(r1) + IntToStr(r2);
end;

Function MakeHelperKey(ProductId:String; ACloudOptions: integer):String; //20190306 Igor
var AF1, AF2: Integer;
begin
  GetHelperFactors(ProductId, AF1, AF2);
  Result := HelperMakeKey(ProductId, PaddZero(IntToStr(GetRandomNum(8888)), 4), PaddZero(IntToStr(GetRandomNum(7777)), 4), PaddZero(GenerateCloudOptions(ACloudOptions), 4), AF1, AF2);
end;

Function MakeHelperDemoKey(ProductId: String; ADateExp: TDateTime; ACloudOptions: integer):String; //20190306 Igor
var
  Random1, Random2: String;
  AF1, AF2: Integer;
begin
  GenerateMid(ADateExp, Random1, Random2);
  GetHelperFactors(ProductId, AF1, AF2);
  Result := HelperMakeKey(ProductId, Random1, Random2, GenerateCloudOptions(ACloudOptions), AF1, AF2);
end;

Procedure GetHelperFactors(ProductId: String; out AF1, AF2: integer); //20190306 Igor
begin
  AF1:=GetProductFactor(ProductId);
  // factor2 for 2018 year
  If LeftStr(ProductId,2)='DB' then AF2:=155;
end;

procedure LoadProducts;  //must have exact des ription
begin
 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;

// 20220801 Igor >>>
//T1-2025
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('22');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('23');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('24');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('25');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('26');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('27');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('29');
 PgmNames.Add('T1 Enterprise');  ProductIds.Add('T107'); PgmFactors.Add('30');  //20230611 Igor

 //T2-2026
 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('32');
 PgmNames.Add('T2 - Limited to 1 return');  ProductIds.Add('T208'); PgmFactors.Add('39');
 PgmNames.Add('T2 - Limited to 2 returns'); ProductIds.Add('T209'); PgmFactors.Add('40');
 PgmNames.Add('T2 - Limited to 3 returns'); ProductIds.Add('T210'); PgmFactors.Add('41');
 PgmNames.Add('T2 - Limited to 4 returns'); ProductIds.Add('T211'); PgmFactors.Add('42');
 PgmNames.Add('T2 - Limited to 5 returns'); ProductIds.Add('T212'); PgmFactors.Add('43');
 PgmNames.Add('T2 - Limited to 6 returns'); ProductIds.Add('T213'); PgmFactors.Add('44');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('35');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('36');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('37');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('38');
 PgmNames.Add('T2 Enterprise');  ProductIds.Add('T214'); PgmFactors.Add('45');

//T3-2025
 PgmNames.Add('T3 Demo');        ProductIds.Add('T300'); PgmFactors.Add('42');
 PgmNames.Add('T3 Standard');    ProductIds.Add('T301'); PgmFactors.Add('43');
 PgmNames.Add('T3 Power');       ProductIds.Add('T302'); PgmFactors.Add('44');
 PgmNames.Add('T3 Enterprise');  ProductIds.Add('T303'); PgmFactors.Add('45'); //20231211 Igor

//TF-2025
 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('43');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('44');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('45');
 PgmNames.Add('TF Enterprise');  ProductIds.Add('TF04'); PgmFactors.Add('47'); //20231211 Igor

 //T4T5-2025
 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('55');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('56');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('57');
 PgmNames.Add('T4 Enterprise');  ProductIds.Add('T404'); PgmFactors.Add('59'); //20231211 Igor

 //FP-2026
 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('62');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('63');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('64');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('65');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('66');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('67');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('68');
 PgmNames.Add('FP Enterprise');  ProductIds.Add('FP07'); PgmFactors.Add('69'); //20231211 Igor

 //TR-2025
 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('71');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('72');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('73');

 //S-2020  vtscan
 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('81');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('82');

 // vtCloud
 PgmNames.Add('Cloud');          ProductIds.Add('CL01'); PgmFactors.Add('19');

 // DropBox
 PgmNames.Add('DropBox Demo');   ProductIds.Add('DB00'); PgmFactors.Add('169');
 PgmNames.Add('DropBox');        ProductIds.Add('DB01'); PgmFactors.Add('170');

 //Archives //20241024 Igor >>>
 PgmNames.Add('Archives for T1');    ProductIds.Add('A101'); PgmFactors.Add('83');
 PgmNames.Add('Archives for T2');    ProductIds.Add('A201'); PgmFactors.Add('84');
 //20241024 Igor <<<


// 20220801 Igor <<<
(*
// 2020-2021 season CON
// 20200611 Igor >>>
//T1-2020
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('16');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('17');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('18');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('19');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('20');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('21');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('22');

 //T2-2021
 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('26');
 PgmNames.Add('T2 - Limited to 1 return');  ProductIds.Add('T208'); PgmFactors.Add('33');
 PgmNames.Add('T2 - Limited to 2 returns'); ProductIds.Add('T209'); PgmFactors.Add('34');
 PgmNames.Add('T2 - Limited to 3 returns'); ProductIds.Add('T210'); PgmFactors.Add('35');
 PgmNames.Add('T2 - Limited to 4 returns'); ProductIds.Add('T211'); PgmFactors.Add('36');
 PgmNames.Add('T2 - Limited to 5 returns'); ProductIds.Add('T212'); PgmFactors.Add('37');
 PgmNames.Add('T2 - Limited to 6 returns'); ProductIds.Add('T213'); PgmFactors.Add('38');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('29');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('30');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('31');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('32');
 PgmNames.Add('T2 Enterprise');  ProductIds.Add('T214'); PgmFactors.Add('39');

//T3-2020
 PgmNames.Add('T3 Demo');        ProductIds.Add('T300'); PgmFactors.Add('36');
 PgmNames.Add('T3 Standard');    ProductIds.Add('T301'); PgmFactors.Add('37');
 PgmNames.Add('T3 Power');       ProductIds.Add('T302'); PgmFactors.Add('38');

//TF-2020
 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('37');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('38');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('39');

 //T4T5-2020
 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('49');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('50');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('51');

 //FP-2021
 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('56');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('57');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('58');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('59');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('60');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('61');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('62');

 //TR-2020
 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('65');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('66');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('67');

 //S-2020  vtscan
 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('76');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('77');

 // vtCloud
 PgmNames.Add('Cloud');          ProductIds.Add('CL01'); PgmFactors.Add('13'); 

 // DropBox
 PgmNames.Add('DropBox Demo');   ProductIds.Add('DB00'); PgmFactors.Add('164');
 PgmNames.Add('DropBox');        ProductIds.Add('DB01'); PgmFactors.Add('165');
// 20200611 Igor <<< 
*) 
 
(* 
// 2019-2020 season CON
// 20190705 Igor >>>
//T1-2019
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('15');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('16');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('17');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('18');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('19');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('20');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('21');

 //T2-2020
 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('25');
 PgmNames.Add('T2 - Limited to 1 return');  ProductIds.Add('T208'); PgmFactors.Add('32');
 PgmNames.Add('T2 - Limited to 2 returns'); ProductIds.Add('T209'); PgmFactors.Add('33');
 PgmNames.Add('T2 - Limited to 3 returns'); ProductIds.Add('T210'); PgmFactors.Add('34');
 PgmNames.Add('T2 - Limited to 4 returns'); ProductIds.Add('T211'); PgmFactors.Add('35');
 PgmNames.Add('T2 - Limited to 5 returns'); ProductIds.Add('T212'); PgmFactors.Add('36');
 PgmNames.Add('T2 - Limited to 6 returns'); ProductIds.Add('T213'); PgmFactors.Add('37');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('28');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('29');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('30');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('31');

//T3-2019
 PgmNames.Add('T3 Demo');        ProductIds.Add('T300'); PgmFactors.Add('35');
 PgmNames.Add('T3 Standard');    ProductIds.Add('T301'); PgmFactors.Add('36');
 PgmNames.Add('T3 Power');       ProductIds.Add('T302'); PgmFactors.Add('37');

//TF-2019
 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('36');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('37');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('38');

 //T4T5-2019
 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('48');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('49');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('50');

 //FP-2020
 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('55');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('56');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('57');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('58');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('59');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('60');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('61');

 //TR-2019
 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('64');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('65');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('66');

 //S-2018  vtscan
 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('75');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('76');

 // vtCloud
 PgmNames.Add('Cloud');          ProductIds.Add('CL01'); PgmFactors.Add('12'); 
// 20180904 Igor <<<

 //20190306 Igor >>>
 // DropBox
 PgmNames.Add('DropBox Demo');   ProductIds.Add('DB00'); PgmFactors.Add('163');
 PgmNames.Add('DropBox');        ProductIds.Add('DB01'); PgmFactors.Add('164');
 //20190705 Igor <<<
 *)
 
 (*
 // 2018-2019 season CON
// 20180904 Igor >>>
//T1-2018
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('14');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('15');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('16');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('17');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('18');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('19');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('20');

 //T2-2019
 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('24');
 PgmNames.Add('T2 - Limited to 1 return');  ProductIds.Add('T208'); PgmFactors.Add('31');
 PgmNames.Add('T2 - Limited to 2 returns'); ProductIds.Add('T209'); PgmFactors.Add('32');
 PgmNames.Add('T2 - Limited to 3 returns'); ProductIds.Add('T210'); PgmFactors.Add('33');
 PgmNames.Add('T2 - Limited to 4 returns'); ProductIds.Add('T211'); PgmFactors.Add('34');
 PgmNames.Add('T2 - Limited to 5 returns'); ProductIds.Add('T212'); PgmFactors.Add('36');
 PgmNames.Add('T2 - Limited to 6 returns'); ProductIds.Add('T213'); PgmFactors.Add('37');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('27');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('28');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('29');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('30');

//T3-2018
 PgmNames.Add('T3 Demo');        ProductIds.Add('T300'); PgmFactors.Add('34');
 PgmNames.Add('T3 Standard');    ProductIds.Add('T301'); PgmFactors.Add('35');
 PgmNames.Add('T3 Power');       ProductIds.Add('T302'); PgmFactors.Add('36');

//TF-2018
 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('35');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('36');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('37');

 //T4T5-2018
 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('47');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('48');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('49');

 //FP-2019
 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('54');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('55');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('56');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('57');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('58');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('59');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('60');

 //TR-2018
 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('63');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('64');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('65');

 //S-2018  vtscan
 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('74');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('75');

 // vtCloud
 PgmNames.Add('Cloud');          ProductIds.Add('CL01'); PgmFactors.Add('11'); //20180917 Igor
// 20180904 Igor <<<

 //20190306 Igor >>>
 // DropBox
 PgmNames.Add('DropBox Demo');   ProductIds.Add('DB00'); PgmFactors.Add('163');
 PgmNames.Add('DropBox');        ProductIds.Add('DB01'); PgmFactors.Add('164');
 //20190306 Igor <<<
 *)

 (* 2017-2018 tax season
//T1-2017
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('13');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('14');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('15');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('16');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('17');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('18');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('19');

 //T2-2018
 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('23');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('24');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('25');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('26');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('27');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('28');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('29');
 PgmNames.Add('T2 - Limited to 1 return');  ProductIds.Add('T208'); PgmFactors.Add('30');   //20170627
 PgmNames.Add('T2 - Limited to 2 returns'); ProductIds.Add('T209'); PgmFactors.Add('31');   //20170627
 PgmNames.Add('T2 - Limited to 3 returns'); ProductIds.Add('T210'); PgmFactors.Add('32');   //20170627
 PgmNames.Add('T2 - Limited to 4 returns'); ProductIds.Add('T211'); PgmFactors.Add('33');   //20170627
 PgmNames.Add('T2 - Limited to 5 returns'); ProductIds.Add('T212'); PgmFactors.Add('34');   //20170627

//T3-2017
 PgmNames.Add('T3 Demo');        ProductIds.Add('T300'); PgmFactors.Add('33');
 PgmNames.Add('T3 Standard');    ProductIds.Add('T301'); PgmFactors.Add('34');
 PgmNames.Add('T3 Power');       ProductIds.Add('T302'); PgmFactors.Add('35');

//TF-2017
 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('34');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('35');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('36');

 //T4T5-2017
 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('46');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('47');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('48');

 //FP-2018
 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('53');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('54');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('55');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('56');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('57');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('58');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('59');

 //TR-2017
 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('63');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('64');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('65');

 //S-2017
 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('73');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('74');

*)
(*
//2016-2017    //20161102
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('12');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('13');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('14');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('15');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('16');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('17');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('18');

 //T2-2017
 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('22');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('23');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('24');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('25');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('26');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('27');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('28');
 //20170628
 PgmNames.Add('T2 - Limited to 1 return');  ProductIds.Add('T208'); PgmFactors.Add('29');   //20170627
 PgmNames.Add('T2 - Limited to 2 returns'); ProductIds.Add('T209'); PgmFactors.Add('30');   //20170627
 PgmNames.Add('T2 - Limited to 3 returns'); ProductIds.Add('T210'); PgmFactors.Add('31');   //20170627
 PgmNames.Add('T2 - Limited to 4 returns'); ProductIds.Add('T211'); PgmFactors.Add('32');   //20170627
 PgmNames.Add('T2 - Limited to 5 returns'); ProductIds.Add('T212'); PgmFactors.Add('33');   //20170627

//TF-2016
 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('32');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('33');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('34');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('42');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('43');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('44');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('52');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('53');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('54');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('55');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('56');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('57');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('58');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('62');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('63');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('64');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('72');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('73');
*)

 (*
 //2015-2016    //20151208
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('11');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('12');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('13');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('14');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('15');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('16');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('17');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('21');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('22');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('23');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('24');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('25');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('26');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('27');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('31');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('32');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('33');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('41');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('42');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('43');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('51');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('52');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('53');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('54');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('55');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('56');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('57');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('61');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('62');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('63');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('71');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('72');
*)
(*
 //2014-2015    //20141107
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('10');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('11');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('12');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('13');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('14');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('15');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('16');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('20');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('21');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('22');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('23');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('24');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('25');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('26');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('30');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('31');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('32');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('40');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('41');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('42');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('50');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('51');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('52');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('53');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('54');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('55');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('56');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('60');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('61');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('62');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('70');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('71');
*)
 (*
//2013-2014
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('21');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('22');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('23');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('24');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('25');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('26');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('27');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('21');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('22');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('23');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('24');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('25');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('26');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('27');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('41');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('42');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('43');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('31');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('32');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('33');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('61');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('62');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('63');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('64');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('65');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('66');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('67');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('51');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('52');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('53');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('74');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('75');
*)
 (*
  //2012-2013
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('25');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('26');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('27');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('28');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('29');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('30');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('31');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('32');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('33');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('34');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('35');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('36');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('37');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('38');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('39');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('40');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('41');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('45');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('46');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('47');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('48');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('49');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('50');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('51');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('52');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('53');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('54');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('55');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('56');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('57');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('58');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('59');
*)

(*
//2011
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('12');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('13');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('14');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('15');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('16');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('17');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('18');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('22');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('23');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('24');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('25');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('26');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('27');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('28');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('32');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('33');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('34');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('42');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('43');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('44');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('52');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('53');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('54');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('55');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('56');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('57');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('58');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('62');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('63');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('64');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('73');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('74');
*)

 (*
 2010
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('11');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('12');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('13');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('14');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('15');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('16');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('17');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('21');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('22');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('23');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('24');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('25');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('26');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('27');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('31');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('32');
 PgmNames.Add('TF Power');       ProductIds.Add('TF02'); PgmFactors.Add('33');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('41');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('42');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('43');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('51');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('52');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('53');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('54');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('55');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('56');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('57');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('61');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('62');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('63');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('72');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('73');
*)

 (*
 //2009
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('10');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('11');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('12');
 PgmNames.Add('T1 Limited Efile');ProductIds.Add('T103'); PgmFactors.Add('13');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('14');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('15');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('16');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('20');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('21');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('22');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('23');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('24');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('25');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('26');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('30');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('31');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('40');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('41');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('42');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('50');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('51');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('52');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('53');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('54');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('55');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('56');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('60');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('61');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('62');

 PgmNames.Add('S1 Standard');    ProductIds.Add('S101'); PgmFactors.Add('71');
 PgmNames.Add('S2 Standard');    ProductIds.Add('S201'); PgmFactors.Add('72');
*)
end;
(*
 //2008 (one more than 6
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('13');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('14');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('15');
 PgmNames.Add('T1 Limited Efile');    ProductIds.Add('T103'); PgmFactors.Add('16');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T104'); PgmFactors.Add('17');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('18');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('19');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('23');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('24');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('25');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('26');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('27');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('28');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('29');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('33');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('34');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('35');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('36');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('37');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('38');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('39');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('40');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('41');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('42');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('43');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('44');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('45');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('46');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('47');
end;
*)
 (*
 //2007 (one more than 6
 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('12');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('13');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('14');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T103'); PgmFactors.Add('15');
 PgmNames.Add('T1 Power');       ProductIds.Add('T104'); PgmFactors.Add('16');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T105'); PgmFactors.Add('17');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('22');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('23');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('24');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('25');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('26');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('27');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('28');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('32');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('33');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('34');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('35');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('36');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('37');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('38');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('39');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('40');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('41');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('42');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('43');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('44');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('45');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('46');

end;
*)

(*2006
procedure LoadProducts;
begin
 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;

 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('11');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('12');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('13');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T103'); PgmFactors.Add('14');
 PgmNames.Add('T1 Power');       ProductIds.Add('T104'); PgmFactors.Add('15');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T105'); PgmFactors.Add('16');

 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('21');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('22');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('23');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('24');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('25');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('26');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('27');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('31');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('32');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('33');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('34');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('35');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('36');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('37');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('38');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('39');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('40');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('41');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('42');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('43');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('44');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('45');
end;
*)
(*
 //2005
 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;

 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('10');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('11');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('12');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T103'); PgmFactors.Add('13');
 PgmNames.Add('T1 Power');       ProductIds.Add('T104'); PgmFactors.Add('14');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T105'); PgmFactors.Add('15');


 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('20');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('21');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('22');
 //PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('23');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('24');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('25');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('26');


 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('30');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('31');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('32');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('33');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('34');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('35');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('36');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('37');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('38');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('39');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('40');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('41');

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('42');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('43');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('44');
end;
*)
(*2004
 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;

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

 PgmNames.Add('TR Demo');        ProductIds.Add('TR00'); PgmFactors.Add('92');
 PgmNames.Add('TR Standard');    ProductIds.Add('TR01'); PgmFactors.Add('93');
 PgmNames.Add('TR Power');       ProductIds.Add('TR02'); PgmFactors.Add('94');

end;
*)
(* 2003
procedure LoadProducts;
begin
 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;

 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('20');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('21');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('22');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T103'); PgmFactors.Add('23');
 PgmNames.Add('T1 Power');       ProductIds.Add('T104'); PgmFactors.Add('24');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T105'); PgmFactors.Add('25');


 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('30');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('31');
 PgmNames.Add('T2 Limited With Efile');  ProductIds.Add('T203'); PgmFactors.Add('32');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T204'); PgmFactors.Add('33');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T205'); PgmFactors.Add('34');
 PgmNames.Add('T2 Power');       ProductIds.Add('T206'); PgmFactors.Add('35');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('36');


 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('40');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('41');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('50');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('51');
 PgmNames.Add('T4 Power');       ProductIds.Add('T402'); PgmFactors.Add('52');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('60');
 PgmNames.Add('FP Limited');     ProductIds.Add('FP01'); PgmFactors.Add('61');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP02'); PgmFactors.Add('62');
 PgmNames.Add('FP Power');       ProductIds.Add('FP03'); PgmFactors.Add('63');
 PgmNames.Add('FP AgStandard');  ProductIds.Add('FP04'); PgmFactors.Add('64');
 PgmNames.Add('FP AgPower');     ProductIds.Add('FP05'); PgmFactors.Add('65');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP06'); PgmFactors.Add('66');
end;
*)
(*
// 2002 and T2-2003
procedure LoadProducts;
begin
 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;

 PgmNames.Add('T1 Demo');        ProductIds.Add('T100'); PgmFactors.Add('10');
 PgmNames.Add('T1 NetFile');     ProductIds.Add('T101'); PgmFactors.Add('11');
 PgmNames.Add('T1 Limited');     ProductIds.Add('T102'); PgmFactors.Add('12');
 PgmNames.Add('T1 Standard');    ProductIds.Add('T103'); PgmFactors.Add('13');
 PgmNames.Add('T1 PaperFile');   ProductIds.Add('T104'); PgmFactors.Add('14');
 PgmNames.Add('T1 Power');       ProductIds.Add('T105'); PgmFactors.Add('15');
 PgmNames.Add('T1 MultiOffice'); ProductIds.Add('T106'); PgmFactors.Add('16');


 PgmNames.Add('T2 Demo');        ProductIds.Add('T200'); PgmFactors.Add('17');
 PgmNames.Add('T2 Limited');     ProductIds.Add('T201'); PgmFactors.Add('18');
 PgmNames.Add('T2 Standard');    ProductIds.Add('T202'); PgmFactors.Add('19');
 PgmNames.Add('T2 MultiOffice'); ProductIds.Add('T203'); PgmFactors.Add('20');
 //PgmNames.Add('T2 Dfile');       ProductIds.Add('T204'); PgmFactors.Add('21');
 PgmNames.Add('T2 Power');       ProductIds.Add('T205'); PgmFactors.Add('22');
 //PgmNames.Add('T2 MultiDFile');  ProductIds.Add('T206'); PgmFactors.Add('23');
 PgmNames.Add('T2 MultiPower');  ProductIds.Add('T207'); PgmFactors.Add('24');

 PgmNames.Add('TF Demo');        ProductIds.Add('TF00'); PgmFactors.Add('25');
 PgmNames.Add('TF Standard');    ProductIds.Add('TF01'); PgmFactors.Add('26');

 PgmNames.Add('T4 Demo');        ProductIds.Add('T400'); PgmFactors.Add('27');
 PgmNames.Add('T4 Standard');    ProductIds.Add('T401'); PgmFactors.Add('28');
 PgmNames.Add('T4 Dfile');       ProductIds.Add('T402'); PgmFactors.Add('29');

 PgmNames.Add('FP Demo');        ProductIds.Add('FP00'); PgmFactors.Add('30');
 PgmNames.Add('FP Standard');    ProductIds.Add('FP01'); PgmFactors.Add('31');
 PgmNames.Add('FP Agent');       ProductIds.Add('FP02'); PgmFactors.Add('32');
 PgmNames.Add('FP Dealer');      ProductIds.Add('FP03'); PgmFactors.Add('33');
end;
*)
(* 2001
procedure LoadProducts;
begin
 PgmNames.Free;
 ProductIds.Free;
 PgmFactors.Free;

 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;

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

end;
*)
Function GetProductId(Pgm:String):String;
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
 ShowMessage('Product not found');
end;

Function GetProductFactor(ProductId:String):Integer;
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
 ShowMessage('Product not found');
end;

Function MakeHashString(TheKey:String):String;
Var PgmId,PgmNum,Random1,Random2:String;
Factor,factor2,HashNum:Integer;
begin
 PgmNum :=MidStr(TheKey,3,2);
 Random1:=MidStr(TheKey,6,4);
 Random2:=MidStr(TheKey,11,4);

 PgmId  := LeftStr(TheKey,4);
 Factor:=GetProductFactor(PgmId);

 //2022-2024
 // 20220801 Igor >>>
 If      LeftStr(PgmId,2)='T1' then Factor2:=56
 else If LeftStr(PgmId,2)='T2' then Factor2:=57
 else If LeftStr(PgmId,2)='T3' then Factor2:=58
 else If LeftStr(PgmId,2)='TF' then Factor2:=59
 else If LeftStr(PgmId,2)='FP' then Factor2:=60
 else If LeftStr(PgmId,2)='T4' then Factor2:=61
 else If LeftStr(PgmId,2)='TR' then Factor2:=63
 else If LeftStr(PgmId,2)='S1' then Factor2:=62
 else If LeftStr(PgmId,2)='CL' then Factor2:=20
 else If LeftStr(PgmId,2)='S2' then Factor2:=63
 else If LeftStr(PgmId,2)='A1' then Factor2:=85
 else If LeftStr(PgmId,2)='A2' then Factor2:=86;
 // 20220801 Igor <<<
 (*
 //2021-2022
 // 20210820 Igor >>>
 If      LeftStr(PgmId,2)='T1' then Factor2:=51
 else If LeftStr(PgmId,2)='T2' then Factor2:=52
 else If LeftStr(PgmId,2)='T3' then Factor2:=53
 else If LeftStr(PgmId,2)='TF' then Factor2:=54
 else If LeftStr(PgmId,2)='FP' then Factor2:=55
 else If LeftStr(PgmId,2)='T4' then Factor2:=56
 else If LeftStr(PgmId,2)='TR' then Factor2:=58
 else If LeftStr(PgmId,2)='S1' then Factor2:=57
 else If LeftStr(PgmId,2)='CL' then Factor2:=15
 else If LeftStr(PgmId,2)='S2' then Factor2:=58;
 // 20210820 Igor <<< 
 *)
 (*
 //2020-2019
 // 20200611 Igor >>>
 If      LeftStr(PgmId,2)='T1' then Factor2:=50
 else If LeftStr(PgmId,2)='T2' then Factor2:=51
 else If LeftStr(PgmId,2)='T3' then Factor2:=52
 else If LeftStr(PgmId,2)='TF' then Factor2:=53
 else If LeftStr(PgmId,2)='FP' then Factor2:=54
 else If LeftStr(PgmId,2)='T4' then Factor2:=55
 else If LeftStr(PgmId,2)='TR' then Factor2:=57
 else If LeftStr(PgmId,2)='S1' then Factor2:=56
 else If LeftStr(PgmId,2)='CL' then Factor2:=14
 else If LeftStr(PgmId,2)='S2' then Factor2:=57;
 // 20200611 Igor <<<  
 *)
 
 (*
 //2019-2020
 // 20190705 Igor >>>
 If      LeftStr(PgmId,2)='T1' then Factor2:=49
 else If LeftStr(PgmId,2)='T2' then Factor2:=50
 else If LeftStr(PgmId,2)='T3' then Factor2:=51
 else If LeftStr(PgmId,2)='TF' then Factor2:=52
 else If LeftStr(PgmId,2)='FP' then Factor2:=53
 else If LeftStr(PgmId,2)='T4' then Factor2:=54
 else If LeftStr(PgmId,2)='TR' then Factor2:=56
 else If LeftStr(PgmId,2)='S1' then Factor2:=55
 else If LeftStr(PgmId,2)='CL' then Factor2:=13
 else If LeftStr(PgmId,2)='S2' then Factor2:=56;
 // 20190705 Igor <<< 
 *)

 (*
 //2018-2019  //20190829 CON
 // 20180904 Igor >>>
 If      LeftStr(PgmId,2)='T1' then Factor2:=48
 else If LeftStr(PgmId,2)='T2' then Factor2:=49
 else If LeftStr(PgmId,2)='T3' then Factor2:=50
 else If LeftStr(PgmId,2)='TF' then Factor2:=51
 else If LeftStr(PgmId,2)='FP' then Factor2:=52
 else If LeftStr(PgmId,2)='T4' then Factor2:=53
 else If LeftStr(PgmId,2)='TR' then Factor2:=55
 else If LeftStr(PgmId,2)='S1' then Factor2:=54
 else If LeftStr(PgmId,2)='S2' then Factor2:=55
 else If LeftStr(PgmId,2)='CL' then Factor2:=12; //20180917 Igor
 // 20180904 Igor <<<
 *)

 (*
//2017-2018
 If      LeftStr(PgmId,2)='T1' then Factor2:=47
 else If LeftStr(PgmId,2)='T2' then Factor2:=48
 else If LeftStr(PgmId,2)='T3' then Factor2:=49
 else If LeftStr(PgmId,2)='TF' then Factor2:=50
 else If LeftStr(PgmId,2)='FP' then Factor2:=51
 else If LeftStr(PgmId,2)='T4' then Factor2:=52
 else If LeftStr(PgmId,2)='TR' then Factor2:=55
 else If LeftStr(PgmId,2)='S1' then Factor2:=53
 else If LeftStr(PgmId,2)='S2' then Factor2:=54;
*)
(*
 //2016-2017   //20161026
 If      LeftStr(PgmId,2)='T1' then Factor2:=46
 else If LeftStr(PgmId,2)='T2' then Factor2:=47
 else If LeftStr(PgmId,2)='TF' then Factor2:=48
 else If LeftStr(PgmId,2)='T4' then Factor2:=49
 else If LeftStr(PgmId,2)='FP' then Factor2:=50
 else If LeftStr(PgmId,2)='TR' then Factor2:=51
 else If LeftStr(PgmId,2)='S1' then Factor2:=52
 else If LeftStr(PgmId,2)='S2' then Factor2:=53;
*)

(*
  // 2015-2016   //20151208
 If      LeftStr(PgmId,2)='T1' then Factor2:=45
 else If LeftStr(PgmId,2)='T2' then Factor2:=46
 else If LeftStr(PgmId,2)='TF' then Factor2:=47
 else If LeftStr(PgmId,2)='T4' then Factor2:=48
 else If LeftStr(PgmId,2)='FP' then Factor2:=49
 else If LeftStr(PgmId,2)='TR' then Factor2:=50
 else If LeftStr(PgmId,2)='S1' then Factor2:=51
 else If LeftStr(PgmId,2)='S2' then Factor2:=52;
*)


(*
  // 2014-2015   //20141107
 If      LeftStr(PgmId,2)='T1' then Factor2:=44
 else If LeftStr(PgmId,2)='T2' then Factor2:=45
 else If LeftStr(PgmId,2)='TF' then Factor2:=46
 else If LeftStr(PgmId,2)='T4' then Factor2:=47
 else If LeftStr(PgmId,2)='FP' then Factor2:=48
 else If LeftStr(PgmId,2)='TR' then Factor2:=49
 else If LeftStr(PgmId,2)='S1' then Factor2:=50
 else If LeftStr(PgmId,2)='S2' then Factor2:=51;
*)
 (*
 // 13-14
 If      LeftStr(PgmId,2)='T1' then Factor2:=34
 else If LeftStr(PgmId,2)='T2' then Factor2:=35
 else If LeftStr(PgmId,2)='TF' then Factor2:=36
 else If LeftStr(PgmId,2)='T4' then Factor2:=37
 else If LeftStr(PgmId,2)='FP' then Factor2:=38
 else If LeftStr(PgmId,2)='TR' then Factor2:=39
 else If LeftStr(PgmId,2)='S1' then Factor2:=40
 else If LeftStr(PgmId,2)='S2' then Factor2:=41;
*)

(*
 // 12-13
 If      LeftStr(PgmId,2)='T1' then Factor2:=14
 else If LeftStr(PgmId,2)='T2' then Factor2:=15
 else If LeftStr(PgmId,2)='TF' then Factor2:=16
 else If LeftStr(PgmId,2)='T4' then Factor2:=17
 else If LeftStr(PgmId,2)='FP' then Factor2:=18
 else If LeftStr(PgmId,2)='TR' then Factor2:=19
 else If LeftStr(PgmId,2)='S1' then Factor2:=20
 else If LeftStr(PgmId,2)='S2' then Factor2:=21;
*)

(*
 // 11/12
 If      LeftStr(PgmId,2)='T1' then Factor2:=13
 else If LeftStr(PgmId,2)='T2' then Factor2:=14
 else If LeftStr(PgmId,2)='TF' then Factor2:=15
 else If LeftStr(PgmId,2)='T4' then Factor2:=16
 else If LeftStr(PgmId,2)='FP' then Factor2:=17
 else If LeftStr(PgmId,2)='TR' then Factor2:=18
 else If LeftStr(PgmId,2)='S1' then Factor2:=19
 else If LeftStr(PgmId,2)='S2' then Factor2:=20;
*)
(*
  // 2010/11
 If      LeftStr(PgmId,2)='T1' then Factor2:=12
 else If LeftStr(PgmId,2)='T2' then Factor2:=13
 else If LeftStr(PgmId,2)='TF' then Factor2:=14
 else If LeftStr(PgmId,2)='T4' then Factor2:=15
 else If LeftStr(PgmId,2)='FP' then Factor2:=16
 else If LeftStr(PgmId,2)='TR' then Factor2:=17
 else If LeftStr(PgmId,2)='S1' then Factor2:=18
 else If LeftStr(PgmId,2)='S2' then Factor2:=19;
*)
 (*
  // 2009/10
 If      LeftStr(PgmId,2)='T1' then Factor2:=11
 else If LeftStr(PgmId,2)='T2' then Factor2:=12
 else If LeftStr(PgmId,2)='TF' then Factor2:=13
 else If LeftStr(PgmId,2)='T4' then Factor2:=14
 else If LeftStr(PgmId,2)='FP' then Factor2:=15
 else If LeftStr(PgmId,2)='TR' then Factor2:=16
 else If LeftStr(PgmId,2)='S1' then Factor2:=17
 else If LeftStr(PgmId,2)='S2' then Factor2:=18;
*)
(*
 // 2008/09
 If      LeftStr(PgmId,2)='T1' then Factor2:=14
 else If LeftStr(PgmId,2)='T2' then Factor2:=15
 else If LeftStr(PgmId,2)='TF' then Factor2:=16
 else If LeftStr(PgmId,2)='T4' then Factor2:=17
 else If LeftStr(PgmId,2)='FP' then Factor2:=18
 else If LeftStr(PgmId,2)='TR' then Factor2:=19;
*)
 (*
 // 2007/08
 If      LeftStr(PgmId,2)='T1' then Factor2:=13
 else If LeftStr(PgmId,2)='T2' then Factor2:=14
 else If LeftStr(PgmId,2)='TF' then Factor2:=15
 else If LeftStr(PgmId,2)='T4' then Factor2:=16
 else If LeftStr(PgmId,2)='FP' then Factor2:=17
 else If LeftStr(PgmId,2)='TR' then Factor2:=18;
 *)
 (*2006
 If      LeftStr(PgmId,2)='T1' then Factor2:=12
 else If LeftStr(PgmId,2)='T2' then Factor2:=13
 else If LeftStr(PgmId,2)='TF' then Factor2:=14
 else If LeftStr(PgmId,2)='T4' then Factor2:=15
 else If LeftStr(PgmId,2)='FP' then Factor2:=16
 else If LeftStr(PgmId,2)='TR' then Factor2:=17;
 *)
 (*
 //2005
 If      LeftStr(PgmId,2)='T1' then Factor2:=11
 else If LeftStr(PgmId,2)='T2' then Factor2:=12
 else If LeftStr(PgmId,2)='TF' then Factor2:=13
 else If LeftStr(PgmId,2)='T4' then Factor2:=14
 else If LeftStr(PgmId,2)='FP' then Factor2:=15
 else If LeftStr(PgmId,2)='TR' then Factor2:=16;
 *)
 (*2004
 If      LeftStr(PgmId,2)='T1' then Factor2:=31
 else If LeftStr(PgmId,2)='T2' then Factor2:=32
 else If LeftStr(PgmId,2)='TF' then Factor2:=33
 else If LeftStr(PgmId,2)='T4' then Factor2:=34
 else If LeftStr(PgmId,2)='FP' then Factor2:=35
 else If LeftStr(PgmId,2)='TR' then Factor2:=36;
 *)
 (* 2003
 If      LeftStr(PgmId,2)='T1' then Factor2:=21
 else If LeftStr(PgmId,2)='T2' then Factor2:=22
 else If LeftStr(PgmId,2)='TF' then Factor2:=23
 else If LeftStr(PgmId,2)='T4' then Factor2:=24
 else If LeftStr(PgmId,2)='FP' then Factor2:=25;
 *)
 HashNum :=  (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor+Factor2)
           + Factor2
           + (StrToInt(Random1[1])+ StrToInt(Random1[2])
           +  StrToInt(Random1[3])+ StrToInt(Random1[4])) * Factor
           + (StrToInt(Random2[1])+ StrToInt(Random2[2])
           +  StrToInt(Random2[3])+ StrToInt(Random2[4])) * Factor;

 Result:=PaddZero(AllTrim(IntToStr(HashNum)),4);
end;

(*
//2002 and T2-2003
Function MakeHashString(TheKey:String):String;
Var PgmId,PgmNum,Random1,Random2:String;
Factor,factor2,HashNum:Integer;
begin
 PgmNum :=MidStr(TheKey,3,2);
 Random1:=MidStr(TheKey,6,4);
 Random2:=MidStr(TheKey,11,4);

 PgmId  := LeftStr(TheKey,4);
 Factor:=GetProductFactor(PgmId);
 If      LeftStr(PgmId,2)='T1' then Factor2:=11
 else If LeftStr(PgmId,2)='T2' then Factor2:=12
 else If LeftStr(PgmId,2)='TF' then Factor2:=13
 else If LeftStr(PgmId,2)='T4' then Factor2:=14
 else If LeftStr(PgmId,2)='FP' then Factor2:=15;

 HashNum :=  (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor+Factor2)
           + Factor2
           + (StrToInt(Random1[1])+ StrToInt(Random1[2])
           +  StrToInt(Random1[3])+ StrToInt(Random1[4])) * Factor
           + (StrToInt(Random2[1])+ StrToInt(Random2[2])
           +  StrToInt(Random2[3])+ StrToInt(Random2[4])) * Factor;

 Result:=PaddZero(AllTrim(IntToStr(HashNum)),4);
end;
*)

(* 2001
Function MakeHashString(TheKey:String):String;
Var PgmId,PgmNum,Random1,Random2:String;
Factor,factor2,HashNum:Integer;
begin
 PgmNum :=MidStr(TheKey,3,2);
 Random1:=MidStr(TheKey,6,4);
 Random2:=MidStr(TheKey,11,4);

 PgmId  := LeftStr(TheKey,4);
 Factor:=GetProductFactor(PgmId);
 If      LeftStr(PgmId,2)='T1' then Factor2:=10
 else If LeftStr(PgmId,2)='T2' then Factor2:=20
 else If LeftStr(PgmId,2)='TF' then Factor2:=30
 else If LeftStr(PgmId,2)='T4' then Factor2:=40
 else If LeftStr(PgmId,2)='FP' then Factor2:=50;

 HashNum :=  (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor+Factor2)
           + Factor2
           + (StrToInt(Random1[1])+ StrToInt(Random1[2])
           +  StrToInt(Random1[3])+ StrToInt(Random1[4])) * Factor
           + (StrToInt(Random2[1])+ StrToInt(Random2[2])
           +  StrToInt(Random2[3])+ StrToInt(Random2[4])) * Factor;

 Result:=PaddZero(AllTrim(IntToStr(HashNum)),4);
end;
*)

Function ValidateKey(AKey:String):Boolean;
begin
 If MidStr(AKey,16,4) = MakeHashString(AKey) then
   result:=True
 else
   result:=False;
end;


Function KeyPrintLabels:boolean;
var
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap
     : Integer;
  Line1,Line2,Line3,Line4,Line5:String;
  ProductNm:String;
begin
 (*
  ProductNm:=Pgm;
 {Set up label parameters}
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  TopMargin  := Trunc(0.5 *  PixPerInY);
  LeftMargin := Trunc(1/8 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
  LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}
  HorizLabelGap := Trunc(1/8 *  PixPerInX);

  {start printer}
  Printer.BeginDoc;
  RecNo:=0;
  For i:=0 to ListBox4.Items.Count-1 do
  begin
      Inc(RecNo);
      If RecNo >30 then begin RecNo :=1; Printer.NewPage; end;
      If Pgm <> 'T2' then
        Line1 := ProductNm+' - '+AppYear
      else
        Line1 := ProductNm+'-'+IntToStr(StrToInt(AppYear)+1);

      Line2 := 'Authorization Key';
      Line3 := ListBox4.Items[i];
      Line4 := ' ';
      Line5 := ' ';

      If RecNo < 11 then  {left label}
        begin
         LabelPosX := LeftMargin;
         LabelPosY := TopMargin+(RecNo-1)*LabelHeight;
        end;
      If (RecNo >10) and (RecNo < 21) then  {Midle label}
         begin
         LabelPosX := LeftMargin+LabelWidth+HorizLabelGap;
         LabelPosY := TopMargin+(RecNo-11)*LabelHeight;
         end;
      If (RecNo >20) then  {right label}
          begin
          LabelPosX := LeftMargin+2 *LabelWidth+3 * HorizLabelGap;
          LabelPosY := TopMargin+(RecNo-21)*LabelHeight;
          end;
      PrintALabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4,Line5);
  end; {end while}
  Printer.EndDoc;
  Result := True;
  *)
end;

Procedure PrintAKeyLabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 10;
  XPos := LabelPosX +2;
  YPos := LabelPosY+2;
  VertIncr := Trunc(PixPerInY * (1/6));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(XPos,YPos,Line1);
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(XPos,YPos+1 * VertIncr,Line2);
  Printer.Canvas.TextOut(XPos,YPos+2 * VertIncr,Line3);
  Printer.Canvas.TextOut(XPos,YPos+3 * VertIncr,Line4);
  Printer.Canvas.TextOut(XPos,YPos+4 * VertIncr,Line5);
end;

Function PaddZero(S:string;MaxLength:Integer):string;
Begin
  Result := FilledStr(PaddCount(S,MaxLength), '0')+S;
End;

Function GetRandomNum(BaseNum:Integer):Integer;
begin
 Randomize;
 Result:=Random(BaseNum);
end;

Procedure Delay(ms:LongInt);
Var TheTime :LongInt;
begin
 TheTime :=GetTickCount+Ms;
 While GetTickCount < TheTime do Application.ProcessMessages;
end;

{ TBNList }

function TBNList.GetEncryptedText: string; //20191015 Igor
var
  L: TStringList;
  S: string;
  I: integer;
begin
  L := TStringList.Create;
  try
    for I := 0 to Count - 1 do
      begin
        S := uEncrypt.Encrypt(Strings[I], BNListKey);
        L.Add(S);
      end;
    Result := L.Text;
  finally
    L.Free;
  end;
end;

procedure TBNList.LoadFromFile(const FileName: string); //20191015 Igor
var
  L: TStringList;
  S: string;
  I: integer;
begin
  L := TStringList.Create;
  try
    L.LoadFromFile(NormalizeFileName(FileName));
    for I := 0 to L.Count - 1 do
      begin
        S := uEncrypt.Decrypt(L.Strings[i], BNListKey);
        Add(S);
      end;
  finally
    L.Free;
  end;
end;

function TBNList.NormalizeFileName(AFileName: string): string; //20191015 Igor
begin
  Result := AFileName;
  if Pos(':', Result) < 2 then
    Result := ExtractFilePath(ParamStr(0)) + '\' + Result;
end;

procedure TBNList.SaveToFile(const FileName: string); //20191015 Igor
var
  L: TStringList;
  S: string;
  I: integer;
begin
  L := TStringList.Create;
  try
    for I := 0 to Count - 1 do
      begin
        S := uEncrypt.Encrypt(Strings[I], BNListKey);
        L.Add(S);
      end;
    L.SaveToFile(NormalizeFileName(FileName));
  finally
    L.Free;
  end;
end;

{ TLicenseList }

function ReadPgmFile(const FName: string; SomeList: TStrings): boolean;
var
  FileName: string;
begin
  (* Load SomeList from file.
    If fname does not contain an drive specifier, assume file in ExeDir.
  *)
  FileName := FName;
  if Pos(':', FileName) < 2 then
    FileName := ExtractFilePath(ParamStr(0)) + '\' + FileName;
  Result := FileExists(FileName);
  if SomeList = nil then
    exit; //only check for file exists
  if Result then
    SomeList.LoadFromFile(FileName)
  else
    SomeList.Clear;
end;

procedure WritePgmFile(const FName: string; SomeList: TStrings);
var
  FileName: string;
begin
  FileName := FName;
  if Pos(':', FileName) < 2 then
    FileName := ExtractFilePath(ParamStr(0)) + '\' + FileName;
  SomeList.SaveToFile(FileName);
end;

constructor TLicenseList.Create;
begin
  inherited Create;
  FLicenseFile := ExtractFilePath(ParamStr(0)) + '\ActivationKeys\LVerf.EX_';
  {if FileExists(FLicenseFile) then
    LoadFromFile(FLicenseFile);}
end;

destructor TLicenseList.Destroy;
begin
  if FChanged then
    SaveToFile(FLicenseFile);
  inherited;
end;

function Crypt(const s: string): string;
var
  i: integer;
begin
  SetLength(Result, Length(s));
  for i := 1 to Length(s) do
    Result[i] := chr(ord(s[i]) xor $F); //no ctrl chars!
end;

procedure TLicenseList.Load;
begin
  LoadFromFile(FLicenseFile);
end;

procedure TLicenseList.LoadFromFile(const FileName: string);
var
  i: integer;
  s: string;
  lst: TStringList;
begin
  Clear;
  lst := TStringList.Create;
  ReadPgmFile(FileName, lst); //assume encrypted
  for i := 0 to lst.Count - 1 do
  begin
    s := lst.Strings[i];
    s := Crypt(s); // DecryptPsw(s, 9999);
    Add(s); //Strings[i] := s;
  end;
  lst.Free;
  FChanged := False;
end;

procedure TLicenseList.Save;
begin
  SaveToFile(FLicenseFile);
end;

procedure TLicenseList.SaveToFile(const FileName: string);
var
  lst: TStringList;
  s: string;
  i: integer;
begin
  (* save not-empty license list
  *)
  if Count = 0 then
    exit; //don't save empty list
  lst := TStringList.Create;
  for i := 0 to Count - 1 do
  begin
    s := Strings[i];
    s := Crypt(s); // EncryptPsw(s, 9999);
    lst.Add(s);
  end;
  if lst.Count = 0 then
    exit; //don't save empty list
  WritePgmFile(FileName, lst);
  lst.Free;
  FChanged := False;
end;

function TLicenseList.GetPassword: string;
begin
  Result := Values['Password'];
end;

procedure TLicenseList.SetPassword(const Value: string);
begin
  Values['Password'] := Value;
end;

function TLicenseList.GetKeys(const AppId: string): string;
begin
  Result := Values[AppId];
end;

procedure TLicenseList.SetKeys(const AppId, Value: string);
begin
  if Values[AppId] <> Value then
  begin
    Values[AppId] := Value;
    FChanged := True;
  end;
end;

end.
