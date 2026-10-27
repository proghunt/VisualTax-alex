unit UAuthor;
(*
 Each year in this program:
 1. Change ONLY PgmFactors in the LoadProducts procedure (i.e increase all by 1)
 2. and Factor2 in MakeHashString procedure  (increase all by 1)

 In the UAuthorization unit of by each program (T1,T2,TF,T4, FP, TR, AND WebSites):
 1. Copy the loadproducts from this program into the loadproducts in UAuthorization
 2. Change factor2 in Makehashstring as per this program

 Also in MCLNT:
  1 replace LoadProducts in unit uKeys.pas of MCLNT with the one of this program
  2 MakeHashstring (in ukeys.pas)as per this program
*)                



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,Printers;

Const AppYear = '2016'; //20161026

type
  TAuthorFrm = class(TForm)
    GroupBox1: TGroupBox;
    CreateKeyBtn: TBitBtn;
    KeyBox: TEdit;
    Label1: TLabel;
    ValidateBtn: TBitBtn;
    SaveKeyBtn: TBitBtn;
    FileNameBox: TEdit;
    ResultBox: TEdit;
    Label2: TLabel;
    PrintDialog1: TPrintDialog;
    Label6: TLabel;
    Panel1: TPanel;
    ListBox4: TListBox;
    GenKeysBtn: TBitBtn;
    PrintBtn: TBitBtn;
    NumKeys: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ExitBtn: TBitBtn;
    ListBox3: TListBox;
    Label5: TLabel;
    Label7: TLabel;

    Procedure Delay(ms:LongInt);
    procedure LoadProducts;
    Function GetProductId(Pgm:String):String;
    Function GetRandomNum(BaseNum:Integer):Integer;
    Function MakeHashString(TheKey:String):String;
    Function GetProductFactor(ProductId:String):Integer;
    Function MakeAKey(ProductId:String):String;

    function LTrim(Const Str: String): String;
    function RTrim(Str: String): String;
    function MTrim(S: String): String;  {remove middle spaces}
    function AllTrim(Str: String):  String;
    function RightStr(Const Str: String; Size: Word): String;
    function LeftStr(Const Str: String; Size: Word): String;
    function MidStr(Const Str: String; StartPos :Word; Size: Word): String;
    Function MyStrToInt(s: string):integer;
    Function Space(Count: Word):String;  {Returns a string of count spaces}
    Function VL(s: string):Real;
    procedure FormCreate(Sender: TObject);
    procedure ValidateBtnClick(Sender: TObject);
    procedure CreateKeyBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    Function ValidateKey(AKey:String):Boolean;
    procedure SaveKeyBtnClick(Sender: TObject);
    procedure OptionsBoxClick(Sender: TObject);
    Function  GetCheck1(Pgm:String;VersionNum:Integer):String;
    Function  GetCheck2(Pgm:String;VersionNum:Integer):String;
    procedure GenKeysBtnClick(Sender: TObject);
    Function PrintLabels:boolean;
    Procedure PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
    procedure PrintBtnClick(Sender: TObject);
    Function FilledStr(Count: Word; ch: char):String;
    Function PaddZero(S:string;MaxLength:Integer):string;
    Function PaddCount(s: string;maxLength: integer):Integer;
    procedure ListBox1DblClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AuthorFrm: TAuthorFrm;
  PgmNames,ProductIds, PgmFactors:Tstringlist;

  Pgm:String;
  PgmId:String;
  TheKey :String;
  Base1,Base2 :String[4];
  BaseString: String[7];
  Version :String;
implementation

{$R *.DFM}
 function TAuthorFrm.LTrim(Const Str: String): String;
  var len: Byte absolute Str;
      i: Integer;
  begin
    i := 1;
    while (i <= len) and (Str[i] = Space(1)) do Inc(i);
    LTrim := Copy(Str,i,len);
  end {LTrim};

  function TAuthorFrm.MTrim(S: String): String;
  var i,len:Integer;
  begin
    Result :='';
    Len :=Length(s);
    i := 1;
    while i <= len do
    begin
     If S[i] <> Space(1) then Result :=Result+S[i];
     Inc(i);
    end;
  end {MTrim};

  function TAuthorFrm.RTrim(Str: String): String;
  var len: Byte absolute Str;
  begin
    while (Str[len] = Space(1)) do Dec(len);
     Result := Str;
    {RTrim := Str}
  end {RTrim};

  function TAuthorFrm.AllTrim(Str: String): String;
  begin
    Result := LTrim(RTrim(Str))
  end {Trim};

  function TAuthorFrm.RightStr(Const Str: String; Size: Word): String;
  var len: Byte absolute Str;
  begin
    if Size > len then Size := len;
    Result := Copy(Str,len-Size+1,Size)
  end {RightStr};

  function TAuthorFrm.LeftStr(Const Str: String; Size: Word): String;
  begin
    Result := Copy(Str,1,Size)
  end {LeftStr};

function TAuthorFrm.MidStr(Const Str: String;StartPos: Word; Size: Word): String;
  var len: Byte absolute Str;
  begin
    Result := Copy(Str,StartPos,Size);
  end {MidStr};

Function TAuthorFrm.MyStrToInt(s: string):Integer;
begin
 Result := Trunc(Vl(s));
end;

 Function TAuthorFrm.Space(Count: Word):String;
   {returns a string with Count spaces}
    var
     S: String[80];
    begin
     { Set a string to all spaces }
      FillChar(S, Count+1, ' ');
      S[0] := Chr(Count); 		{ Set length byte }
      Result := S;
  end;

Function TAuthorFrm.VL(s: string):Real;
Var
Code : integer;
begin
 If s ='' then begin Result := 0; exit;end;
 Val(s,Result,Code);
end;


procedure TAuthorFrm.FormCreate(Sender: TObject);
Var i:Integer;
begin
LoadProducts;
For i:=0 to PgmNames.count-1 do
begin
 ListBox1.Items.Add(PgmNames[i]);
 ListBox2.Items.Add(ProductIds[i]);
 ListBox3.Items.Add(PgmFactors[i]);
end;
NumKeys.Text := '50';
ListBox1.ItemIndex:=-1;

FileNameBox.Text := 'A:\LVerf.EX_';
end;


procedure TAuthorFrm.CreateKeyBtnClick(Sender: TObject);
Var ProductId:String;
begin
 If ListBox1.ItemIndex<0 then begin ShowMessage('Select product first'); exit;end;
 ResultBox.text:='';
 ProductId:=GetProductId(ListBox1.items[ListBox1.ItemIndex]);
 KeyBox.Text:=MakeAKey(ProductId);
end;

Function TAuthorFrm.MakeAKey(ProductId:String):String;
Var k:String;
begin
 k:=ProductId
    +'-'+PaddZero(IntToStr(GetRandomNum(9999)),4)
    +'-'+PaddZero(IntToStr(GetRandomNum(8888)),4);
 Result:=k+'-'+MakeHashString(k);
end;


procedure TAuthorFrm.LoadProducts;
begin
 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;


//2016-2017    //20161026
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
 //20170628
 PgmNames.Add('T2 - Limited to 1 return');  ProductIds.Add('T208'); PgmFactors.Add('29');
 PgmNames.Add('T2 - Limited to 2 returns');  ProductIds.Add('T209'); PgmFactors.Add('30');
 PgmNames.Add('T2 - Limited to 3 returns');  ProductIds.Add('T210'); PgmFactors.Add('31');
 PgmNames.Add('T2 - Limited to 4 returns');  ProductIds.Add('T211'); PgmFactors.Add('32');
 PgmNames.Add('T2 - Limited to 5 returns');  ProductIds.Add('T212'); PgmFactors.Add('33');

 
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
end;

Function TAuthorFrm.GetProductId(Pgm:String):String;
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

Function TAuthorFrm.GetProductFactor(ProductId:String):Integer;
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

Function TAuthorFrm.GetCheck1(Pgm:String;VersionNum:Integer):String;
begin
 result :='0';
 If Pgm = 'T1' then Result:=IntToStr(VersionNum*2+1)
 Else If Pgm = 'T2' then result:=IntToStr(VersionNum*2+2)
 Else If Pgm = 'TF' then result:=IntToStr(VersionNum*2+2)
 Else If Pgm = 'T4' then result:=IntToStr(VersionNum*2+3)
 Else If Pgm = 'FP' then result:=IntToStr(VersionNum*2+1);
end;


Function TAuthorFrm.GetCheck2(Pgm:String;VersionNum:Integer):String;
begin
 Result :='0';
 If Pgm = 'T1' then result:=IntToStr(VersionNum+3)
 Else If Pgm = 'T2' then result:= IntToStr(VersionNum+3)
 Else If Pgm = 'TF' then result:= IntToStr(VersionNum+4)
 Else If Pgm = 'T4' then result:= IntToStr(VersionNum+1)
 Else If Pgm = 'FP' then result:= IntToStr(VersionNum+4);
end;


Procedure TAuthorFrm.ValidateBtnClick(Sender: TObject);
Begin
 If ValidateKey(KeyBox.Text) then
  ResultBox.Text := 'Good!'
 else
  ResultBox.Text := 'INVALID';
end;

Function TAuthorFrm.MakeHashString(TheKey:String):String;
Var PgmId,PgmNum,Random1,Random2:String;
Factor,factor2,HashNum:Integer;
begin
 PgmNum :=MidStr(TheKey,3,2);
 Random1:=MidStr(TheKey,6,4);
 Random2:=MidStr(TheKey,11,4);

 PgmId  := LeftStr(TheKey,4);
 Factor:=GetProductFactor(PgmId);

 //2016-2017   //20161026
 If      LeftStr(PgmId,2)='T1' then Factor2:=46
 else If LeftStr(PgmId,2)='T2' then Factor2:=47
 else If LeftStr(PgmId,2)='TF' then Factor2:=48
 else If LeftStr(PgmId,2)='T4' then Factor2:=49
 else If LeftStr(PgmId,2)='FP' then Factor2:=50
 else If LeftStr(PgmId,2)='TR' then Factor2:=51
 else If LeftStr(PgmId,2)='S1' then Factor2:=52
 else If LeftStr(PgmId,2)='S2' then Factor2:=53;


 (* 2015-2016   //20151208
 If      LeftStr(PgmId,2)='T1' then Factor2:=45
 else If LeftStr(PgmId,2)='T2' then Factor2:=46
 else If LeftStr(PgmId,2)='TF' then Factor2:=47
 else If LeftStr(PgmId,2)='T4' then Factor2:=48
 else If LeftStr(PgmId,2)='FP' then Factor2:=49
 else If LeftStr(PgmId,2)='TR' then Factor2:=50
 else If LeftStr(PgmId,2)='S1' then Factor2:=51
 else If LeftStr(PgmId,2)='S2' then Factor2:=52;
 *)
 HashNum :=  (StrToInt(PgmNum[1]) + StrToInt(PgmNum[2])) * (Factor+Factor2)
           + Factor2
           + (StrToInt(Random1[1])+ StrToInt(Random1[2])
           +  StrToInt(Random1[3])+ StrToInt(Random1[4])) * Factor
           + (StrToInt(Random2[1])+ StrToInt(Random2[2])
           +  StrToInt(Random2[3])+ StrToInt(Random2[4])) * Factor;

 Result:=PaddZero(AllTrim(IntToStr(HashNum)),4);
end;

Function TAuthorFrm.ValidateKey(AKey:String):Boolean;
begin
 If MidStr(AKey,16,4) = MakeHashString(AKey) then
   result:=True
 else
   result:=False;
end;

procedure TAuthorFrm.ExitBtnClick(Sender: TObject);
begin
PgmNames.Free;
ProductIds.Free;
Close;
end;

procedure TAuthorFrm.SaveKeyBtnClick(Sender: TObject);
Var TempList:TstringList;
begin
 If (KeyBox.Text ='')
 or (ResultBox.Text = 'INVALID')
 then
 begin
  ShowMessage('Key cannot be saved');
  exit;
 end;
 TempList := TstringList.Create;
 TempList:=TStringList.Create;
 TempList.Add(KeyBox.Text);
 TempList.SaveToFile(FileNameBox.Text);
 TempList.Free;
 ShowMessage('Key saved');
end;

procedure TAuthorFrm.OptionsBoxClick(Sender: TObject);
begin
KeyBox.Text :='';
ResultBox.Text :='';
end;


procedure TAuthorFrm.GenKeysBtnClick(Sender: TObject);
Var i,j,BaseNum:Integer;InputBase:String;NewBaseString:String;
ProductId:String; AKey:String;
begin
 If ListBox1.ItemIndex<0 then begin ShowMessage('Select product first'); exit;end;
 ResultBox.text:='';
 ProductId:=GetProductId(ListBox1.items[ListBox1.ItemIndex]);
 ListBox4.Clear;
 Screen.Cursor:=crHourGlass;
 For i:=1 to StrToInt(NumKeys.Text) do
 begin
  Delay(100);
  AKey:=MakeAKey(ProductId);
  ListBox4.Items.Add(AKey);
 end;
 Screen.Cursor:=crDefault;
end;


Function TAuthorFrm.PrintLabels:boolean;
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
  ProductNm:=ListBox1.items[ListBox1.ItemIndex];
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
end;

Procedure TAuthorFrm.PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
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


procedure TAuthorFrm.PrintBtnClick(Sender: TObject);
begin
 PrintLabels;
end;

Function TAuthorFrm.PaddZero(S:string;MaxLength:Integer):string;
Begin
  Result := FilledStr(PaddCount(S,MaxLength), '0')+S;
End;

Function TAuthorFrm.FilledStr(Count: Word; ch: char):String;
   {returns a string with Count spaces, or other character}
    var
     S: String[80];
    begin
     { Set a string to all spaces }
      FillChar(S, Count+1, ch);
      S[0] := Chr(Count); 		{ Set length byte }
      Result := S;
  end;

Function TAuthorFrm.PaddCount(s: string;maxLength: integer):Integer;
{how many characters to reach to mx length}
begin
 Result := MaxLength - Length(s);
 If Result <0 then result := 0;
end;


Function TAuthorFrm.GetRandomNum(BaseNum:Integer):Integer;
begin
 Randomize;
 Result:=Random(BaseNum);
end;

procedure TAuthorFrm.ListBox1DblClick(Sender: TObject);
begin
CreateKeyBtnClick(Sender);
end;

 (*
 If  ProductId = 'T100'  then Factor
 Else If      Pgm = 'T1 Limited'     then   Result:= '3574216'
 Else If      Pgm = 'T1 Standard'    then   Result:= '2494235'
 Else If      Pgm = 'T1 Paper'       then   Result:= '9794417'
 Else If      Pgm = 'T1 Power'       then   Result:= '6694234'
 Else If      Pgm = 'T1 MultiOffice' then   Result:= '5594242'


 Else If Pgm = 'T2 Limited'          then    Result:= '6132762'
 Else If Pgm = 'T2 Standard'         then    Result:= '4761673'
 Else If Pgm = 'T2 Dfile'            then    Result:= '5143022'
 Else If Pgm = 'T2 Efile'            then    Result:= '0593875'


 Else If Pgm = 'TF Standard'         then  Result:= '6964826'

 Else If Pgm = 'T4 Standard'         then  Result:= '0492563'
 Else If Pgm = 'T4 Dfile'            then  Result:= '9492552'

 Else If Pgm = 'FP Standard'         then  Result:= '8281959'
 Else If Pgm = 'FP Agent'            then  Result:= '4439841';
 *)



 (*
{TheKey    := '1234-6789-1234-6789';}
 TheKey    := 'NNNN-NNNV-OOOO-OCCC';
 {N=Number base number pgm gen, V=Volume, C := Check digits}
 For i:=1 to 4 do TheKey[i] := BaseString[i];
 TheKey[5]:='-';
 For i:=6 to 8 do TheKey[i] := BaseString[i-1];


 If UnlimitedBox.Checked then
   TheKey[9]:='9'
 else
   TheKey[9]:='0';

 TheKey[10]:='-';

 If Networkbox.Checked then
   TheKey[11]:='9'
 else
   TheKey[11]:='0';

 If T1EfileBox.Checked then
   TheKey[12]:='9'
 else
   TheKey[12]:='0';

 If T2DfileBox.Checked then
   TheKey[12]:='9'
 else
   TheKey[12]:='0';

 If T1EfOnlineBox.Checked then
   TheKey[13]:='9'
 else
   TheKey[13]:='0';

 If T2EfileBox.Checked then
   TheKey[13]:='9'
 else
   TheKey[13]:='0';

 If T1MultiOfficeBox.Checked then
   TheKey[14]:='9'
 else
   TheKey[14]:='0';

 If T2MultiOfficeBox.Checked then
   TheKey[14]:='9'
 else
   TheKey[14]:='0';

 TheKey[15]:='-';
 TheKey[16]:= '4'; {unused}

 GetHashString(TheKey);


 If LeftStr(Pgm,2)  ='T4' then
 begin
   If Pgm  ='T4 Standard' then
     Version:='1'
   else
     Version:='2';
   For i:=1 to 4 do TheKey[i] := BaseString[i];
   For i:=6 to 8 do TheKey[i] := BaseString[i-1];
   TheKey[9] :=Version[1];
   VersionNum := StrToInt(Version);
   S1:=GetCheck1(Pgm,VersionNum);
   S2:=GetCheck2(Pgm,VersionNum);
   TheKey[13] :=S1[1];
   TheKey[14] :=S2[1];
 end;
 Result:=TheKey;
 *)

 (*
 Version := IntToStr(OptionsBox.ItemIndex);
 For i:=1 to 4 do TheKey[i] := BaseString[i];
 For i:=6 to 8 do TheKey[i] := BaseString[i-1];
 TheKey[9] :=Version[1];
 VersionNum := StrToInt(Version);
 S1:=GetCheck1(Pgm,VersionNum);
 S2:=GetCheck2(Pgm,VersionNum);

 {If ExpiryBox.Text>'' then TheKey[17] := S3[1];}
 TheKey[13] :=S1[1];
 TheKey[14] :=S2[1];
 Result:=TheKey;
*)

Procedure TAuthorFrm.Delay(ms:LongInt);
Var TheTime :LongInt;
begin
 TheTime :=GetTickCount+Ms;
 While GetTickCount < TheTime do Application.ProcessMessages;
end;


end.
