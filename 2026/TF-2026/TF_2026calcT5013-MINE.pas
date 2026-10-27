unit TF_2026calcT5013;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,
  TF_2026Declare, TF_2026common, TF_2026common2, TF_2026TrimStr;

  //20260905 new riutines
  //Procedure CalcAllT5013Slips(RetNo: integer);  //20260903
 // Procedure T5013Single(RetNo: integer; PartnerId:String);  // Same with T5013 for now 7:47 pm Ausept 2
  Procedure PrepareAllT5013Slips(RetNo:Integer);
  Procedure UpdateT5013PartnersList(RetNo:Integer);
  Procedure DeleteT5013Slips(RetNo:Integer); //create any new slips and enter ParterId on them
  Procedure CreateNewT5013Slips(RetNo:Integer); //create any new slips and enter ParterId on them
  Procedure RemoveAllT5013SlipData(RetNo:Integer);  //20260908CZ
  //Procedure RemoveAllT5013SlipData(RetNo:Integer;SlipFNo:Integer);
 // Function  GetT5013FNoFromPartnerId(RetNo:integer;PartnerId:String):Integer;
  //Procedure RevisePartnerIdOfSlips(RetNo:Integer); //create any new slips and enter ParterId on them

  procedure PS56(RetNo: Integer; FName: string; FNo: Integer);  //20260816
  function GetBoxTotalsFromAllT5013(RetNo:Integer;BoxNo:String):Real;
  function GetTheBoxNoOfT5013Ws(AmtElm:String):String;
  function FindEmptyBoxInT5013(RetNo:Integer;FNo:Integer):Integer;
  procedure T5013WS(RetNo:integer;FName:string;FNo:integer);
  function GetT5013YearEndYYYY(RetNo:Integer):Integer;
  function GetT5013FiscalPeriodEnd(RetNo:Integer):String;
  function GetT5013AccountNo(RetNo:Integer):String;

  procedure GenerateT5013Ps50Pg1Pg2Forms(RetNo:Integer);
  procedure GenerateT5013PS50PG3Forms(RetNo:Integer);

  procedure T5013FIN(RetNo: integer; FName: String;FNo: integer);
  procedure PS5(RetNo:integer;FName:string;FNo:integer);
  procedure PS9(RetNo:integer;FName:string;FNo:integer);

  procedure T661(RetNo:integer;FName:string;FNo:integer);

  function CountPS125(RetNo:Integer):Integer;
  function GetT5013SlipType(RetNo:Integer):String;
  //Procedure PT1135(RetNo:integer;FName:string;FNo:integer);  //20180422
  function ClaimedRenouncedresources(RetNo:Integer):Boolean;
  //Function IsLimitedPartnership(RetNo:Integer):Boolean;
  //Function CountT5013Slips(RetNo:Integer):Integer;
  function IsT5013Shelter(RetNo:Integer):Boolean;
  procedure ClearAllT5013Slips(RetNo:Integer);
  //Procedure POTHINFO(RetNo: integer; FName: String;FNo: integer);
  function GetEmptyCodeInT5013Sum(RetNo, FNo: Integer):Integer;
  function GetEmptyDescrInT5013Sum(RetNo:Integer):Integer;
  procedure CalcPCCA(Cls:string;UccStart:real;
                   Additions:real;Adjustments:real;Proceeds:real;
                   Var UCC:real;Var HalfRuleAmount:real; Var UCCReduced:real;
                   OverrideIndic:String;HalfYearIndic:String;TermLossIndic:String;
                   Rate:string;
                   Var Recapture:Real;Var TerminalLoss:Real;
                   Var CCA:real;Var UccEnd:real;
                   DaysinTaxYear:integer);

  procedure T5013SUM(RetNo:integer;FName:string;FNo:integer); {slip}
  procedure PS1(RetNo:integer;FName:string;FNo:integer);
  procedure PS2(RetNo:integer;FName:string;FNo:integer);
  procedure PS6(RetNo:integer;FName:string;FNo:integer);
  procedure PS6DTL1(RetNo:integer;FName:string;FNo:integer);
  procedure PS6DTL2(RetNo:integer;FName:string;FNo:integer);
  procedure PS6DTL3(RetNo:integer;FName:string;FNo:integer);
  procedure PS8(RetNo:integer;FName:string;FNo:integer);
  //Procedure PS10(RetNo:integer;FName:string;FNo:integer);
  procedure PS12(RetNo:integer;FName:string;FNo:integer);
  //Procedure PS19(RetNo:integer;FName:string;FNo:integer);
  //Procedure PS25(RetNo:integer;FName:string;FNo:integer);
  procedure PS50(RetNo:integer;FName:string;FNo:integer);
  procedure PS52(RetNo:integer;FName:string;FNo:integer);
  procedure PS100(RetNo:integer;FName:string;FNo:integer);
  procedure PS125(RetNo:integer;FName:string;FNo:integer);
  procedure PS141(RetNo: integer; FName: String;FNo: integer);
  procedure T5013(RetNo:integer;FName:string;FNo:integer); //20260903
 // procedure T5013A(RetNo:integer;FName:string;FNo:integer); {slip}

  procedure FillT5013Slip(RetNo,PS50PageNo,PS50Elm:integer;SlipFNo:Integer);
 // procedure GenerateT5013Slips(RetNo:Integer);
  //Procedure GenerateSomeT5013Slips(RetNo:integer;PS50PageNo:integer;Var SlipPageNo:Integer);
  procedure T5011(RetNo: integer; FName: String;FNo: integer);

implementation

uses
  TF_2026Calc, vtShared, TF_2026, vtCommon, vtTrimStr;

Procedure T5013SUM(RetNo: integer; FName: String;FNo: integer);
Var  i,j: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  Strings[1]:=FetchElm(RetNo,'T5013FIN',7);
  Strings[2]:=FetchElm(RetNo,'T5013FIN',18);
  Strings[3]:=FetchElm(RetNo,'T5013FIN',38);
  Strings[4]:=FetchElm(RetNo,'T5013FIN',39);
  Strings[5]:=FetchElm(RetNo,'T5013FIN',1);

  Strings[8]:=IntToStr(CountT5013Partners(RetNo));
  If Strings[18]='' then Strings[18]:= FormatDateTime('yyyy/mm/dd',Date);  //20140101
  If Strings[21]='' then Strings[21]:= FormatDateTime('yyyy/mm/dd',Date);


  If FetchElm(RetNo,'T5013FIN',62)>'' then
  begin
   Strings[12]:='Y';
   Strings[13]:='TS'+FetchElm(RetNo,'T5013FIN',62);
  end
  Else
  begin
   Strings[12]:='';
   Strings[13]:='';
  end;
  Tv[14]:=TotMultiple(RetNo,'T5013',7);
  Tv[15]:=TotMultiple(RetNo,'T5013',9);
  Tv[264]:=TotMultiple(RetNo,'T5013',12);
  Tv[266]:=TotMultiple(RetNo,'T5013',27);

  Tv[7]:=GetBoxTotalsFromAllT5013(RetNo,'110');
  Tv[91]:=GetBoxTotalsFromAllT5013(RetNo,'120');
  Tv[149]:=GetBoxTotalsFromAllT5013(RetNo,'190');
  Tv[150]:=GetBoxTotalsFromAllT5013(RetNo,'191');
  Tv[154]:=GetBoxTotalsFromAllT5013(RetNo,'194');
  Tv[140]:=GetBoxTotalsFromAllT5013(RetNo,'210');

  Tv[155]:=Vl(FetchElm(RetNo,'PS1',155));


 {
  If Ret[RetNo].FrmHasData[GetFormNo('PS12')] then  //20110315
  begin Strings[191]:='';Strings[192]:='X'; end
  Else Begin Strings[191]:='X';Strings[192]:=''; end;


  If Ret[RetNo].FrmHasData[GetFormNo('PS19')] then  //20110315
  begin Strings[197]:='';Strings[198]:='X'; end
  Else Begin Strings[197]:='X';Strings[198]:=''; end;

  If Ret[RetNo].FrmHasData[GetFormNo('PT1135')] then
  begin Strings[203]:='';Strings[204]:='X'; end
  Else Begin Strings[203]:='X';Strings[204]:=''; end;
  }
 // If Strings[236]='' then Strings[236]:=FormatDateTime('yyyy/mm/dd',Date);
 end;
 SaveTv(RetNo,FName,FNo);
end;



Procedure T5013FIN(RetNo: integer; FName: String;FNo: integer);
Var  i,j: integer; s:String;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  //Left side
 // If Strings[2]+Strings[3]='' then Strings[3]:='X';
  If Strings[11]+Strings[12]='' then Strings[12]:='X';

  If Strings[46]+Strings[157]='' then Strings[46]:='X';  //20170306
  //right hand side
  //Strings[45]:=IntToStr(CountT5013Slips(RetNo));
  If Strings[36]+Strings[37]='' then Strings[37]:='X';
    If Strings[38]='' then
  begin
    Strings[38]:=Appyear+'/01/01';
    Strings[39]:=Appyear+'/12/31';
  end;
  If Strings[39]>'' then  //20130217
  begin
   If Strings[39]> IntToStr(MyStrToInt(AppYear)+1)+'/12/31' then
   begin
     Strings[1]:='';
     Strings[38]:='';
     Strings[39]:='';
     Exit;
   end;
  end;

  SetNumDays(RetNo); //20200228

  If Strings[40]+Strings[41]='' then Strings[40]:='X';
  If Strings[42]+Strings[43]='' then Strings[43]:='X';
  If Strings[158]+Strings[159]='' then Strings[159]:='X';  //20170306

  //s:=IntToStr(CountT5013Partners(RetNo));
  Strings[45]:=IntToStr(CountT5013Partners(RetNo));

  {
  Strings[45]:='';Strings[46]:='';
  If (IsT5013Shelter(RetNo)=True) Or (ClaimedRenouncedResources(RetNo)=True) then
      begin Strings[46]:=s; Strings[45]:='';end
  Else
      begin Strings[45]:=s; Strings[46]:='';end;
  }
  If Strings[47]+Strings[48]='' then Strings[48]:='X';
 // If Strings[50]+Strings[51]='' then Strings[51]:='X';  //20170306

  //Page 2
  Strings[63]:=GetT5013AccountNo(RetNo);
  Strings[64]:=GetT5013FiscalPeriodEnd(RetNo);

  //complety automaticaly
  i:=65;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2)
  until i>89;

  If Strings[3]+Strings[4]='' then begin Strings[3]:='';Strings[3]:='X';end; //20210303


  Tv[132]:=Vl(FetchElm(RetNo,'PS52',118));

  //Page 3  ??
  Strings[91]:=GetT5013AccountNo(RetNo);
  Strings[92]:=GetT5013FiscalPeriodEnd(RetNo);

  i:=93;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2);
  until i>105;

  i:=109;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2);
  until i>123;

  i:=126;
  Repeat
   If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
   Inc(i,2);
  until i>128;


  //Page 4  ??
  Strings[134]:=GetT5013AccountNo(RetNo);
  Strings[135]:=GetT5013FiscalPeriodEnd(RetNo);
  //???  auto
  If Strings[145]='' then Strings[145]:= FormatDateTime('yyyy/mm/dd',Date);
  If Strings[148]+Strings[149]='' then Strings[148]:='X';
  If Strings[153]+Strings[154]='' then Strings[153]:='X';

 end;


 SaveTv(RetNo,FName,FNo);
end;

Function GetEmptyCodeInT5013Sum(RetNo, FNo: Integer):Integer;
Var i:Integer;
begin
 Result:=0;
 i:=270;
 Repeat
  If Ret[RetNo].Frm[FNo].Tv[i]=0 then begin result:=i-2;exit;end;
  Inc(i,4);
 until i>382;
end;

Function GetEmptyDescrInT5013Sum(RetNo:Integer):Integer;
Var i:Integer;AFNo:Integer;
begin
 Result:=0;
 AFNo:=GetFormNo('T5013SUM');
 i:=384;
 Repeat
  If FetchElmFNo(RetNo,AFNo,i)='' then begin result:=i;exit;end;
  Inc(i,2);
 until i>402;
end;


Function FindEmptyBoxInT5013(RetNo:Integer;FNo:Integer):Integer;
Var i:Integer;
Begin
  Result:=0;
  i:=34;
  Repeat
   If Vl(FetchElmFNo(RetNo,FNo,i))=0 then begin result:=i;Exit;End;
   Inc(i,3);
  until i>89; //67;  //20260913
end;


Procedure GenerateT5013PS50Pg1Pg2Forms(RetNo:Integer);   //pg1 and pg2
Var FName:string;i,j,FNo, FromFNo:Integer;NumberOfPartners,ParnersWithDisposition:Integer;
PagePrinting:Integer;
Cnt:Integer;
WhichCopy,WhichInst:integer;
InstancesRequired:Integer;
NumOfPages:Integer;
begin
 //2026906
 //Clear printout forms
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If Frec.FormName='' then  begin  For j:=1 to 133 do Begin StoreElm(RetNo,Frec.FormNo,j,'');end;end;
  If Frec.FormName='PS50PG2' then
  begin
   For j:=1 to 133 do
   Begin
    StoreElm(RetNo,Frec.FormNo,j,'');end;
    Ret[retNo].FrmHasData[Frec.FormNo]:=False;   //20120324
   end;
  end;

 NumberOfPartners:=CountT5013Partners(RetNo);
 If Odd(NumberOfPartners) then
   NumOfPages:=NumberOfPartners div 2 +1
 Else
   NumOfPages:=NumberOfPartners div 2;


 If CertificationMode=True then NumberOfPartners:=3;  //20120318
 If NumberOfPartners=0 then exit;

 If NumberofPartners<3 then
  InstancesRequired:=0
 else
  InstancesRequired:=(NumberOfPartners-2) Div 2 +1;  //for pg2  //20140318

 FName:='PS50PG2';
 For WhichInst:=2 to InstancesRequired do
 Begin
  FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
  If FNo = 0 then
  begin
   AddPageInstance(RetNo,FName,'#'+IntToStr(WhichInst));
   FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
   InitFormData(RetNo,FNo);          //20120323
  end;
 end;

 //populate the printoutes from ps50

 Cnt:=0;
 WhichCopy:=0;
 for i:=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName='PS50')
   and (Ret[RetNo].FrmHasData[Frec.FormNo])
   then
   Begin
     //Calc(RetNo,Frec.FormName);  //20140325
     FromFNo:=Frec.FormNo;
     Cnt:=Cnt+1;
     If Cnt=1 then
     Begin
      FName:='PS50PG1';
      FNo:=GetFormNo(FName);
      For j:=1 to 33 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); End; //copy to top part
      StoreElm(RetNo, FNo,10,IntToStr(1));
      StoreElm(RetNo, FNo,135,'1'); //pg number //20140325
      StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
      If CertificationMode then
      begin
       StoreElm(RetNo, FNo,10,'1');
       StoreElm(RetNo, FNo,110,'1');
      end;
     end

     Else If Cnt=2 then
     Begin
         Inc(WhichCopy);
         FName:='PS50PG1';
         For j:=10 to 33 do begin StoreElm(RetNo, FNo,j+100, FetchElmFNo(RetNo,FromFNo,j)); End; //copy to bottom part
         StoreElm(RetNo, FNo,110,'2');   //20140318
         StoreElm(RetNo, FNo,135,'1'); //pg number //20140325
         StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
         If CertificationMode then StoreElm(RetNo, FNo,110,'2');
         WhichCopy:=0;  //initialize it
     end

     Else If Cnt>2 then  //it uses the pg2 format
     Begin
        //20140319
        if odd(Cnt) then
        begin
            WhichCopy:=1;
            WhichInst:=(Cnt Div 2);
        end
        else
        begin
            WhichCopy:=2;
            WhichInst:=((Cnt-1) Div 2);
        end;

        FName:='PS50PG2';
        FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
        If FNo = 0 then
        begin
          AddPageInstance(RetNo,FName,'#'+IntToStr(WhichInst));
          FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
          InitFormData(RetNo,FNo);
          Ret[retNo].FrmHasData[FNo]:=False;   //20120324
        end;

        //populate it
        If WhichCopy=1 then
        begin
         For j:=1 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=10 to 33 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j));end;

         StoreElm(RetNo, FNo,10,IntToStr(Cnt));
         StoreElm(RetNo, FNo,135,IntToStr(WhichInst+1)); //pg number //20140325
         StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
         Ret[RetNo].FrmHasData[FNo]:=True;   //20120324
         If CertificationMode then StoreElm(RetNo, FNo,10,'1');
        end;

        If WhichCopy=2 then
        begin
         For j:=1 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=10 to 33 do begin StoreElm(RetNo, FNo,j+100, FetchElmFNo(RetNo,FromFNo,j)); end;
         StoreElm(RetNo, FNo,110,IntToStr(Cnt));
         StoreElm(RetNo, FNo,135,IntToStr(WhichInst+1)); //pg number //20140325
         StoreElm(RetNo, FNo,136,IntToStr(NumOfPages));  //20140325
         Ret[RetNo].FrmHasData[FNo]:=True;   //20120324
         If CertificationMode then StoreElm(RetNo, FNo,110,'2');
        end;

     end;  //cnt >2
   end; //has data
 end;  //i
end;


Procedure GenerateT5013PS50PG3Forms(RetNo:Integer);  //pg3
Var FName:string;i,j,FNo, FromFNo:Integer;NumberOfPartners,ParnersWithDisposition:Integer;
PagePrinting:Integer; Cnt,AllCnt,InstancesRequired:Integer;
WhichInst,WhichCopy:Integer;
begin
 //2026906
 //Clear any pre-existing Pg3 printout forms
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];  //20120324  WAS MISSING!!
   If Frec.FormName='PS50PG3' then
    begin
     For j:=1 to 180 do Begin StoreElm(RetNo,Frec.FormNo,j,'');end;
     Ret[RetNo].FrmHasData[Frec.FormNo]:=False;   //20110324
    end;
 end;
 // create all required instances
 AllCnt:=CountT5013PartnersWithDisposition(RetNo);
 InstancesRequired:=(AllCnt Div 3)+1;
 FName:='PS50PG3';
 For WhichInst:=2 to InstancesRequired do
 Begin
  FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
  If FNo = 0 then
  Begin
    AddPageInstance(RetNo,FName,'#'+IntToStr(WhichInst));
    FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
    InitFormData(RetNo,FNo);                         //20120323
    Ret[RetNo].FrmHasData[FNo]:=False;   //20110324
  end;
 end;
 //populate Pg3 instances printout form
 Cnt:=0;
 WhichCopy:=0;
 for i:=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName='PS50') and (Ret[RetNo].FrmHasData[Frec.FormNo]) and (FetchElmFNo(RetNo,Frec.FormNo,41)>'') then  //has disp date 20120303
   Begin
        Cnt:=Cnt+1;
        //20120324


        Case cnt of
          1..3: WhichInst:=1;
          4..6: WhichInst:=2;
          7..9: WhichInst:=3;
          10..12: WhichInst:=4;
          13..15: WhichInst:=5;
          16..18: WhichInst:=6;
          19..21: WhichInst:=7;
          22..24: WhichInst:=8;
          25..27: WhichInst:=9;
          28..30: WhichInst:=10;
          31..33: WhichInst:=11;
          34..36: WhichInst:=12;
          37..39: WhichInst:=13;
          40..42: WhichInst:=14;
          43..45: WhichInst:=15;
          46..48: WhichInst:=16;
          49..51: WhichInst:=17;
          52..54: WhichInst:=18;
          55..57: WhichInst:=19;
          58..60: WhichInst:=20;
          61..63: WhichInst:=21;
          64..66: WhichInst:=22;
          67..69: WhichInst:=23;
          70..72: WhichInst:=24;
          73..75: WhichInst:=25;
          76..78: WhichInst:=26;
          79..81: WhichInst:=27;
          82..84: WhichInst:=28;
          85..87: WhichInst:=29;
          88..90: WhichInst:=30;
          91..93: WhichInst:=31;
        end;

       {
        WhichInst:= (Cnt Div 3)+1;  //20120324 // WhichInst:= (Cnt Div 3); // +1;  //integer part)
        If WhichInst=0 then WhichInst:=1;  //20120324
        }
        WhichCopy:=WhichCopy+1;
      //  If WhichCopy>3 then WhichCopy:=1;  //back to 1 if exceeds 3   //20120324  //moved below in copy 3
        FromFNo := Frec.FormNo;
        FName:='PS50PG3';
        FNo:=GetFormNo(FName+'#'+IntToStr(WhichInst));
        //populate instance FNo with data
        If WhichCopy=1 then
        begin
         For j:=2 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=35 to 60 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j));end;
         StoreElm(RetNo, FNo,35,IntToStr(Cnt));
         Ret[RetNo].FrmHasData[FNo]:=True;  //20110324
        end
        else if WhichCopy=2 then
        begin
         For j:=2 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
         For j:=35 to 60 do begin StoreElm(RetNo, FNo,j+60, FetchElmFNo(RetNo,FromFNo,j)); end;
         StoreElm(RetNo, FNo,95,IntToStr(Cnt));
         Ret[RetNo].FrmHasData[FNo]:=True;  //20110324
        end
        else if WhichCopy=3 then
        begin
          For j:=2 to 3 do begin StoreElm(RetNo, FNo,j, FetchElmFNo(RetNo,FromFNo,j)); end;   //20120303
          For j:=35 to 60 do begin StoreElm(RetNo, FNo,j+120, FetchElmFNo(RetNo,FromFNo,j));end;
          StoreElm(RetNo, FNo,155,IntToStr(Cnt));
          WhichCopy:=0;  //initialize  //20120324
          Ret[RetNo].FrmHasData[FNo]:=True;  //20110324
        end;
   end; //has data
 end;  //i
end;

Procedure FillT5013Slip(RetNo,PS50PageNo,PS50Elm:integer;SlipFNo:Integer);
Var i,FromFNo:integer;FromForm:String[10];Percent:Real;
begin
 FromForm := 'PS50#'+IntToStr(PS50PageNo);
 FromFNo:=GetFormNo(FromForm);
 i:=PS50Elm-4; //if ps50elm is 4 then i=0 so we can use i+elm in From PS50 for readability
 StoreElm(RetNo,SlipFNo,10,FetchElmFNo(RetNo,FromFNo,i+20)); {country}
 StoreElm(RetNo,SlipFNo,11,FetchElmFNo(RetNo,FromFNo,i+6)); {member}
 StoreElm(RetNo,SlipFNo,12,FetchElmFNo(RetNo,FromFNo,i+8)); {units held}
 StoreElm(RetNo,SlipFNo,13,FetchElmFNo(RetNo,FromFNo,i+9)); {percent}
 StoreElm(RetNo,SlipFNo,14,FetchElmFNo(RetNo,FromFNo,i+5)); {partner id}
 // 175??
 StoreElm(RetNo,SlipFNo,15,FetchElmFNo(RetNo,FromFNo,i+4)); {Name}
 StoreElm(RetNo,SlipFNo,16,FetchElmFNo(RetNo,FromFNo,i+16)); {str}
 StoreElm(RetNo,SlipFNo,17,FetchElmFNo(RetNo,FromFNo,i+17)); {city}
 StoreElm(RetNo,SlipFNo,18,FetchElmFNo(RetNo,FromFNo,i+18)); {prov}
 StoreElm(RetNo,SlipFNo,19,FetchElmFNo(RetNo,FromFNo,i+19)); {postal}
 StoreElm(RetNo,SlipFNo,20,FetchElmFNo(RetNo,FromFNo,i+20)); {country}
end;

Procedure T5011(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  If UpperCase(Strings[5])='X' then Strings[2]:='531390';
  If Strings[50]+Strings[51]='' then Strings[50]:='X';
  If Strings[52]+Strings[53]='' then Strings[52]:='X';
  If Strings[55]+Strings[56]='' then Strings[55]:='X';
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure PS1(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  if Strings[27]+Strings[28]='' then Strings[28]:='X';  //20260821
  FillT5013Header(RetNo,FNo,1,2,3);
  FillT5013Header(RetNo,FNo,1,42,43); //2nd page
  FillT5013Header(RetNo,FNo,1,158,159); //3nd page
  If Strings[150]='' then Strings[150]:='Y';
  Tv[13]:=TotMultiple(RetNo,'PS2',29)+TotMultiple(RetNo,'PS2',54)+TotMultiple(RetNo,'PS2',73)
         +TotMultiple(RetNo,'PS2',92)+TotMultiple(RetNo,'PS2',152);  //20140321
  Tv[14]:=TotMultiple(RetNo,'PS2',111)+TotMultiple(RetNo,'PS2',130)+TotMultiple(RetNo,'PS2',171); //20140321


  Tv[9]:=TotMultiple(RetNo,'PS8',230);
//  Tv[49]:=TotMultiple(RetNo,'PS10',50);
  Tv[87]:=Vl(FetchElm(RetNo,'PS12',72));
  Tv[138]:=TotMultiple(RetNo,'PS10',26);
  //page 2
  //Tv[54]:=AddColumns(46,53,1);
  //Tv[55]:=Tv[54];
  Tv[102]:=AddColumns(56,61,1)+AddColumns(63,79,1)+AddColumns(81,91,1)+Tv[153];
  //Tv[103]:=Tv[102]; //20260821CZ
  Tv[156]:=Tv[93]+Tv[95]+Tv[97]+Tv[99]+Tv[101];
  Tv[157]:=Tv[156];
  Tv[104]:=Tv[102]+Tv[157];   //20260821CZ //Tv[104]:=Tv[103]+Tv[157];

  //page 3
  Tv[132]:=AddColumns(105,121,1)+Tv[123]+Tv[125]+Tv[127]+Tv[129]+Tv[131];
  Tv[133]:=Tv[132];
  Tv[136]:=TotMultiple(RetNo,'PS8',232);
  Tv[137]:=TotMultiple(RetNo,'PS8',231);
 // Tv[138]:=TotMultiple(RetNo,'PS10',24); //20130214 //TotMultiple(RetNo,'PS10',26);
  Tv[147]:=AddColumns(134,137,1)+AddColumns(139,146,1);  //20190218
  //Tv[147]:=AddColumns(134,146,1);

  //+Tv[154];
  Tv[148]:=Tv[147];
  Tv[149]:=Tv[133]+Tv[148];
  //PAGE 1
  If UpperCase(Strings[150])='Y' then Tv[5]:= TotMultiple(RetNo,'PS125',303);
  Tv[32]:=Tv[104];
  //20160305 Igor
   Tv[33]:=Tv[151]+Tv[152]+AddColumns(6,9,1)+AddColumns(11,26,1)+AddColumns(46,48,1)+AddColumns(50,52,1)+Tv[32]; //remove 10, 49 //20190218
 // Tv[33]:=Tv[151]+Tv[152]+AddColumns(6,26,1)+AddColumns(46,52,1)+Tv[32];

  //20160222 //Tv[151]+Tv[152]+AddColumns(6,26,1)+AddColumns(46,53,1)+Tv[32];
  Tv[39]:=Tv[33];
  Tv[40]:=Tv[149];
  Tv[41]:=Tv[5]+Tv[39]-Tv[40];
  Tv[45]:=Tv[41]-Tv[155];
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS2(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillT5013Header(RetNo,FNo,1,2,3);
   If Strings[133]+Strings[4]='' then Strings[133]:='X';
   Tv[29]:=AddColumns(5,23,6);
  // Tv[54]:=AddColumns(30,48,6);    //20210303
   Tv[73]:=AddColumns(55,67,6);
   Tv[92]:=AddColumns(74,86,6);
   Tv[111]:=AddColumns(93,105,6);
   Tv[130]:=AddColumns(112,124,6);

  // Tv[152]:=AddColumns(134,145,6);  //20210303
   Tv[171]:=AddColumns(153,165,6);
 end;
 SaveTv(RetNo,FName,FNo);
end;

//20260907 Alex >>>
procedure PS6(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
  LoadTv(RetNo, FName, FNo);

  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 428, 429, 430);  //20120320

    //headers Account
    //Strings[426]:= FetchElm(RetNo, 'T5013FIN', 1);
    //Strings[427]:= FetchElm(RetNo, 'T5013FIN', 39);
    //Page 1
    for i:= 41 to 44 do Tv[i]:= 0;
    i:= 5;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[41]:= Tv[41] + Tv[i];
      Tv[42]:= Tv[42] + Tv[i + 1];
      Tv[43]:= Tv[43] + Tv[i + 2];
      Tv[44]:= Tv[44] + Tv[i + 3];

      Inc(i, 8);
    until i > 37;

    for i:= 75 to 78 do Tv[i]:= 0;
    i:= 47;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[75]:= Tv[75] + Tv[i];
      Tv[76]:= Tv[76] + Tv[i + 1];
      Tv[77]:= Tv[77] + Tv[i + 2];
      Tv[78]:= Tv[78] + Tv[i + 3];

      Inc(i, 6);
    until i > 71;

    for i:= 114 to 117 do Tv[i]:= 0;
    i:= 82;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[114]:= Tv[114] + Tv[i];
      Tv[115]:= Tv[115] + Tv[i + 1];
      Tv[116]:= Tv[116] + Tv[i + 2];
      Tv[117]:= Tv[117] + Tv[i + 3];

      Inc(i, 7);
    until i > 110;

    //Page 2
    for i:= 158 to 161 do Tv[i]:= 0;
    i:= 122;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[158]:= Tv[158] + Tv[i];
      Tv[159]:= Tv[159] + Tv[i + 1];
      Tv[160]:= Tv[160] + Tv[i + 2];
      Tv[161]:= Tv[161] + Tv[i + 3];

     Inc(i, 8);
    until i > 154;

    //real est
    for i:= 192 to 195 do Tv[i]:= 0;
    i:= 164;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[192]:= Tv[192] + Tv[i];
      Tv[193]:= Tv[193] + Tv[i + 1];
      Tv[194]:= Tv[194] + Tv[i + 2];
      Tv[195]:= Tv[195] + Tv[i + 3];

      Inc(i, 6);
    until i > 188;

    //bonds
    for i:= 236 to 239 do Tv[i]:= 0;
    i:= 200;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[236]:= Tv[236] + Tv[i];
      Tv[237]:= Tv[237] + Tv[i + 1];
      Tv[238]:= Tv[238] + Tv[i + 2];
      Tv[239]:= Tv[239] + Tv[i + 3];

      Inc(i, 8);
    until i > 232;

    //pers use
    for i:= 270 to 273 do Tv[i]:= 0;
    i:= 242;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[270]:= Tv[270] + Tv[i];
      Tv[271]:= Tv[271] + Tv[i + 1];
      Tv[272]:= Tv[272] + Tv[i + 2];
      Tv[273]:= Tv[273] + Tv[i + 3];

      Inc(i, 6);
    until i > 266;

    //Page 3
    //listed
    for i:= 304 to 307 do Tv[i]:= 0;
    i:= 276;
    repeat
     Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
     Tv[304]:= Tv[304] + Tv[i];
     Tv[305]:= Tv[305] + Tv[i + 1];
     Tv[306]:= Tv[306] + Tv[i + 2];
     Tv[307]:= Tv[307] + Tv[i + 3];

     Inc(i, 6);
    until i > 300;

    //other gains
    for i:= 338 to 341 do Tv[i]:= 0;
    i:= 310;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[338]:= Tv[338] + Tv[i];
      Tv[339]:= Tv[339] + Tv[i + 1];
      Tv[340]:= Tv[340] + Tv[i + 2];
      Tv[341]:= Tv[341] + Tv[i + 3];

      Inc(i, 6);
    until i > 334;
    
    //gifts of certain cap prop
    for i:= 412 to 418 do Tv[i]:= 0;
    i:= 373;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[412]:= Tv[412] + Tv[i];
      Tv[413]:= Tv[413] + Tv[i + 1];
      Tv[414]:= Tv[414] + Tv[i + 2];
      Tv[415]:= Tv[415] + Tv[i + 3];
      Tv[416]:= Tv[416] + Tv[i + 4];
      Tv[417]:= Tv[417] + Tv[i + 5];
      Tv[418]:= Tv[418] + Tv[i + 6];

      Inc(i, 8);
    until i > 405;

    //Page 4
    //Qual business xfer   //20250503
    for i:= 500 to 503 do Tv[i]:= 0;
    i:= 464;
    repeat
      Tv[i + 3]:= Tv[i] - Tv[i + 1] - Tv[i + 2];
      Tv[500]:= Tv[500] + Tv[i];
      Tv[501]:= Tv[501] + Tv[i + 1];
      Tv[502]:= Tv[502] + Tv[i + 2];
      Tv[503]:= Tv[503] + Tv[i + 3];

      Inc(i, 8);
    until i > 496;

    //992
    Tv[519]:= (Tv[44] + Tv[78] + Tv[117] + Tv[161] + Tv[195] + Tv[239] + Tv[273] + Tv[307] + Tv[341] + Tv[418] + Tv[419] + Tv[420] + Tv[503]) - (Tv[506] + Tv[507] + Tv[508] + Tv[509]);
  end;

  SaveTv(RetNo, FName, FNo);
end;
//20260907 Alex <<<

(*
Procedure PS6(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillPHeader(RetNo,FNo,1,2,3);
   Tv[5]:=ToTMultiple(RetNo,'PS6DTL1',44);
   Tv[6]:=ToTMultiple(RetNo,'PS6DTL1',78);
   Tv[7]:=ToTMultiple(RetNo,'PS6DTL1',117);
   Tv[8]:=ToTMultiple(RetNo,'PS6DTL1',161);
   Tv[9]:=ToTMultiple(RetNo,'PS6DTL1',195);

   Tv[10]:=ToTMultiple(RetNo,'PS6DTL2',44);
   Tv[11]:=ToTMultiple(RetNo,'PS6DTL2',78);
   Tv[12]:=ToTMultiple(RetNo,'PS6DTL2',112);
   Tv[13]:=ToTMultiple(RetNo,'PS6DTL2',146);
   Tv[14]:=ToTMultiple(RetNo,'PS6DTL2',190);

   Tv[15]:=ToTMultiple(RetNo,'PS6DTL3',7);
 //  Tv[16]:=ToTMultiple(RetNo,'PS6DTL3',6);
   Tv[17]:=ToTMultiple(RetNo,'PS6DTL3',5);
 //  Tv[18]:=ToTMultiple(RetNo,'PS6DTL3',185);

   Tv[21]:=TotMultiple(RetNo,'PS10',8);
   Tv[22]:=AddColumns(5,15,1)+Tv[19]+Tv[20]+Tv[21];

   Tv[23]:=Tv[5];
   Tv[24]:=Tv[6];
   Tv[25]:=Tv[7];
   Tv[26]:=Vl(FetchElm(RetNo,'PS10',65));
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

Procedure PS6DTL1(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
Row,FieldId,Elm:Integer;ArrayNo:Integer;BoxesPerRow:Integer; //needed for dynamic
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  ArrayNo:=1;
  BoxesPerRow:=9;
  Row:=1;
  FieldId:=ArrayNo*10000+StrToInt('9'); //for field id 10003 on the first row i form
  if DynamicRowHasData(RetNo,FName,FieldId) then
   StoreElm(RetNo,FNo,FieldId,IntToStr(Row));
 (* Replaced by dynamic
  For i:=41 to 44 do Tv[i]:=0;
  i:=5;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[41]:=Tv[41]+Tv[i];
   Tv[42]:=Tv[42]+Tv[i+1];
   Tv[43]:=Tv[43]+Tv[i+2];
   Tv[44]:=Tv[44]+Tv[i+3];
   Inc(i,8);
  until i>37;
 *)
  For i:=75 to 78 do Tv[i]:=0;
  i:=47;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[75]:=Tv[75]+Tv[i];
   Tv[76]:=Tv[76]+Tv[i+1];
   Tv[77]:=Tv[77]+Tv[i+2];
   Tv[78]:=Tv[78]+Tv[i+3];
   Inc(i,6);
  until i>71;

  For i:=114 to 117 do Tv[i]:=0;
  i:=82;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[114]:=Tv[114]+Tv[i];
   Tv[115]:=Tv[115]+Tv[i+1];
   Tv[116]:=Tv[116]+Tv[i+2];
   Tv[117]:=Tv[117]+Tv[i+3];
   Inc(i,7);
  until i>110;

  For i:=158 to 161 do Tv[i]:=0;
  i:=122;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[158]:=Tv[158]+Tv[i];
   Tv[159]:=Tv[159]+Tv[i+1];
   Tv[160]:=Tv[160]+Tv[i+2];
   Tv[161]:=Tv[161]+Tv[i+3];
   Inc(i,8);
  until i>154;

  For i:=192 to 195 do Tv[i]:=0;
  i:=164;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[192]:=Tv[192]+Tv[i];
   Tv[193]:=Tv[193]+Tv[i+1];
   Tv[194]:=Tv[194]+Tv[i+2];
   Tv[195]:=Tv[195]+Tv[i+3];
   Inc(i,6);
  until i>188;

 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS6DTL2(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  For i:=41 to 44 do Tv[i]:=0;
  i:=5;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[41]:=Tv[41]+Tv[i];
   Tv[42]:=Tv[42]+Tv[i+1];
   Tv[43]:=Tv[43]+Tv[i+2];
   Tv[44]:=Tv[44]+Tv[i+3];
   Inc(i,8);
  until i>37;

  For i:=75 to 78 do Tv[i]:=0;
  i:=47;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[75]:=Tv[75]+Tv[i];
   Tv[76]:=Tv[76]+Tv[i+1];
   Tv[77]:=Tv[77]+Tv[i+2];
   Tv[78]:=Tv[78]+Tv[i+3];
   Inc(i,6);
  until i>71;

  For i:=109 to 112 do Tv[i]:=0;
  i:=81;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[109]:=Tv[109]+Tv[i];
   Tv[110]:=Tv[110]+Tv[i+1];
   Tv[111]:=Tv[111]+Tv[i+2];
   Tv[112]:=Tv[112]+Tv[i+3];
   Inc(i,6);
  until i>105;

  For i:=143 to 146 do Tv[i]:=0;
  i:=115;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[143]:=Tv[143]+Tv[i];
   Tv[144]:=Tv[144]+Tv[i+1];
   Tv[145]:=Tv[145]+Tv[i+2];
   Tv[146]:=Tv[146]+Tv[i+3];
   Inc(i,6);
  until i>139;

  For i:=187 to 190 do Tv[i]:=0;
  i:=151;
  Repeat
   Tv[i+3]:=Tv[i]-Tv[i+1]-Tv[i+2];
   Tv[187]:=Tv[187]+Tv[i];
   Tv[188]:=Tv[188]+Tv[i+1];
   Tv[189]:=Tv[189]+Tv[i+2];
   Tv[190]:=Tv[190]+Tv[i+3];
   Inc(i,8);
  until i>183;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS6DTL3(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

(*
  Tv[64]:=0;
  Tv[66]:=0;
  i:=8;
  Repeat
   Tv[i+3]:=MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2]); //no losses aloowed
   If Strings[i-1]>'2006-05-01' then Tv[i+5]:=0; //after may 1, 2006
   Tv[i+7]:=MaxR(0,Tv[i+3]-Tv[i+5]); //-Tv[i+6]);
   Tv[64]:=Tv[64]+Tv[i+5];
  // Tv[65]:=Tv[65]+Tv[i+6];
   Tv[66]:=Tv[66]+Tv[i+7];
   Inc(i,12);
  until i>56;

  Tv[127]:=0;Tv[129]:=0;
  i:=71;
  Repeat
   Tv[i+3]:=MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2]); //no losses aloowed
   If Strings[i-1]>'2006-05-01' then Tv[i+5]:=0; //after may 1, 2006
   Tv[i+7]:=MaxR(0,Tv[i+3]-Tv[i+5]); //-Tv[i+6]);
   Tv[127]:=Tv[127]+Tv[i+5];
  // Tv[128]:=Tv[128]+Tv[i+6];
   Tv[129]:=Tv[129]+Tv[i+7];
   Inc(i,12);
  until i>119;

  Tv[180]:=0;
  Tv[182]:=0;
  i:=132;
  Repeat
   Tv[i+3]:=MaxR(0,Tv[i]-Tv[i+1]-Tv[i+2]); //no losses aloowed
   If Strings[i-1]>'2006-05-01' then Tv[i+5]:=0; //after may 1, 2006
   Tv[i+7]:=MaxR(0,Tv[i+3]-Tv[i+5]); //-Tv[i+6]);
   Tv[180]:=Tv[180]+Tv[i+5];
  // Tv[181]:=Tv[181]+Tv[i+6];
   Tv[182]:=Tv[182]+Tv[i+7];
   Inc(i,12);
  until i>172;

  Tv[5]:=Tv[64]+Tv[127]+Tv[180];
 // Tv[6]:=Tv[65]+Tv[128]+Tv[181];
  Tv[7]:=Tv[66]+Tv[129]+Tv[182];

  //?? Tv[185
 *)
 end;
 SaveTv(RetNo,FName,FNo);
end;

(*
Procedure PS10(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 Exit;  //20190224
end;

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillPHeader(RetNo,FNo,1,2,3);
  Strings[69]:=FetchElm(RetNo,'T5013FIN',1);
  Strings[70]:=FetchElm(RetNo,'T5013FIN',39);

 // Tv[5]:=0;
  Tv[8]:=Tv[6]-Tv[7]; //MaxR(0,Tv[6]-Tv[7]);
  If Tv[7]>Tv[6] then Strings[67]:='N';
  If Tv[8]<=0 then Strings[67]:='N';
  If UpperCase(Strings[67])='Y' then
  begin
   If Tv[6]>Tv[7] then Tv[17]:=Tv[7];
  end;


  If Tv[13] <0 then Tv[13] :=0;
  Tv[15] := Tv[14] * 0.75;
  Tv[16] := Tv[13]+Tv[15];
  Tv[20] := Tv[17]+Tv[18]+Tv[19];
  Tv[21] := Tv[20] * 0.75;
  Tv[22] := Tv[16] - Tv[21];
  If Tv[22] >0 then
   begin
    Tv[23]:=Tv[22];
    If strings[58] = '' then
      Strings[5] := '7'
    else
      Strings[5]:=Strings[58];
    Tv[24]:= Tv[23] * Vl(Strings[5])/100 * (GetT5013Days(RetNo)/365);
    Tv[27] := MaxR(0,Tv[22] - Tv[24]);
    For i:=28 to 50 do begin Strings[i]:='';Tv[i]:=0;end;
    Tv[71]:=0;Tv[72]:=0;
   end
  else
   begin
    Tv[23]:=0;
    Tv[24]:=0;
    Strings[5]:='';
   // Tv[25] :=0;
   // Tv[26]:=0;
    Tv[27] :=0; {Abs(Tv[12]);}
   end;


  //page 2
  //If Strings[35] ='' then Strings[45] :='Y';

  If Tv[22]<0 then
   Tv[28] := ABS(Tv[22])
   else
   begin
     For i:=29 to 50 do begin strings[i]:='';Tv[i]:=0;end;
   end;
  Strings[49]:='2/3';
  Tv[49]:=2/3;
  Tv[33] := MaxR(0,Tv[31]-Tv[32]);
  Tv[34] :=Tv[33];
  Tv[35] := Tv[29]+Tv[30]+Tv[34];

  Tv[38] :=Tv[36]+Tv[37];
  Tv[39] := Tv[38];
  Tv[40]:=MaxR(0,Tv[35]-Tv[39]);
  Tv[41]:=Tv[40];
  Tv[71]:=MinR(Tv[28],Tv[41]);

  Tv[42]:=Tv[28];
  Tv[43]:=Tv[41];
  Tv[44] := Tv[34];
  Tv[45] := Tv[44] * 0.50;
  Tv[46] := Tv[43]+Tv[45];
  Tv[47] := Tv[46];
  Tv[48] := MaxR(0,Tv[42] - Tv[47]);
  Tv[50]:= Tv[48] * 2/3;  //Vl(Strings[49])/100;   //20120318
  Tv[72]:=Tv[71]+Tv[50];

  //section c
  Tv[55] := Tv[53]+tv[54];
  Tv[56] := Tv[55];
  Tv[57] := MaxR(0,Tv[52]-Tv[56]);
  Tv[59] := Tv[57] * 0.50;
  Tv[62] := Tv[60]+Tv[61];
  Tv[63] := Tv[62];
  Tv[64] := MaxR(0,Tv[51]+Tv[59]-Tv[63]);
  Tv[65] := MinR(Tv[71],Tv[64]);
 end;
 SaveTv(RetNo,FName,FNo);
*)


Procedure PS12(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillT5013Header(RetNo,FNo,1,2,3);  //20110309
  Strings[76]:=FetchElm(RetNo,'T5013FIN',1);
  Strings[77]:=FetchElm(RetNo,'T5013FIN',39);

  Tv[9]:=AddColumns(5,8,1);
  Tv[10]:=Tv[9];
  Tv[13]:=Tv[11]+Tv[12];
  Tv[14]:=Tv[13];
  Tv[15]:=MaxR(0,Tv[10]-Tv[14]);

  Tv[20]:=AddColumns(17,19,1);
  Tv[21]:=Tv[20];
  Tv[24]:=Tv[22]+Tv[23];
  Tv[25]:=Tv[24];
  Tv[26]:=MaxR(0,Tv[21]-Tv[25]);

  Tv[31]:=AddColumns(28,30,1);
  Tv[32]:=Tv[31];
  Tv[36]:=Tv[34]+Tv[35];//202103403 //Tv[33]+Tv[34]+Tv[35];
  Tv[37]:=Tv[36];
  Tv[38]:=MaxR(0,Tv[32]-Tv[37]);

  i:=41;
  Tv[72]:=0;
  Repeat
   Tv[i+5]:=Tv[i]+Tv[i+1]+Tv[i+2]-Tv[i+3]-Tv[i+4];
   Tv[72]:=Tv[72]+Tv[i+5];
   Inc(i,8);
  until i>65;
  Tv[93]:= Tv[88]+Tv[89]+Tv[90]+Tv[91]; // 20250806 Igor
 end;
 SaveTv(RetNo,FName,FNo);
end;


Procedure PS50(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;x,y:Real;SlipCnt:Integer;TotUnitsHeld:Real;
   FInst:String;
begin
 FInst:=ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillT5013Header(RetNo,FNo,1,2,3);
  Strings[10]:=AllTrim(MidStr(FInst,2,5));
  If Strings[4]+Strings[5]='' then Strings[4]:='X';
  If Strings[14]='' then Strings[14]:='1';
  If Strings[15]='' then Strings[15]:='0';
  If Vl(Strings[16])>100 then Strings[16]:='100';
  If Strings[24]='' then Strings[24]:='CAN';

  //at risk boxes  //20260904
  if strings[15]<>'0' then //not Limited pertner
  begin
   Tv[38]:=0;
   Tv[39]:=0;
  end;

  //top counters
  Strings[6]:=IntToStr(CountT5013Partners(RetNo));
  Strings[7]:=IntToStr(CountT5013PartnersWithDisposition(RetNo));
  If UpperCase(Strings[37])<>'Y' then
   Tv[17]:=Vl(FetchElm(RetNo,'T5013WS',1)) * Vl(Strings[16])/100;  //20140326
  Strings[8]:=IntToStr(CountT5013PartnersNominees(RetNo));
  Tv[9]:= GetT5013AllPartnersNetIncomeShare(RetNo);
 end;
 UpdateT5013PartnersList(RetNo);
 SaveTv(RetNo,FName,FNo);
end;

Procedure PS52(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  FillT5013Header(RetNo,FNo,1,2,3);  //20110309
  FillT5013Header(RetNo,FNo,1,120,121);  //pg2
  //20260827cz ig general partnerno at risk allowed
  if Strings[15]='2'  then
  begin
    Tv[38]:=0;
    Tv[39]:=0;
  end;
  For i:=33 to 35 do Tv[i]:=0;
  i:=12;
  Repeat
   Tv[33]:=Tv[33]+Tv[i];
   Tv[34]:=Tv[34]+Tv[i+1];
   Tv[35]:=Tv[35]+Tv[i+2];
   Inc(i,6);
  until i>30;

  For i:=56 to 57 do Tv[i]:=0;
  i:=39;
  Repeat
   Tv[56]:=Tv[56]+Tv[i];
   Tv[57]:=Tv[57]+Tv[i+1];
   Inc(i,5);
  until i>54;

  For i:=78 to 79 do Tv[i]:=0;
  i:=61;
  Repeat
   Tv[78]:=Tv[78]+Tv[i];
   Tv[79]:=Tv[79]+Tv[i+1];
   Inc(i,5);
  until i>76;

  //20230322
  For i:=130 to 131 do Tv[i]:=0;
  i:=122;
  Repeat
   Tv[130]:=Tv[130]+Tv[i];
   Tv[131]:=Tv[131]+Tv[i+1];
   Inc(i,1);
  until i>125;


  For i:=104 to 105 do Tv[i]:=0;
  Tv[104]:=AddColumns(82,100,6);
  Tv[105]:=AddColumns(83,101,6);
  Tv[106]:=AddColumns(84,102,6);
  Tv[107]:=AddColumns(85,103,6);
  // 20250820 Igor >>>
  Tv[7]:= AddColumns(132, 135, 1);
  Tv[8]:= AddColumns(136, 139, 1);
  Tv[114]:= AddColumns(140, 143, 1);
  Tv[148]:= AddColumns(144, 147, 1);
  // 20250820 Igor <<<

  if Strings[6]>'' then
  Begin
  //Part 2  //20230323
  Tv[109]:=Tv[33];
  Tv[115]:=Tv[34];
  Tv[110]:=(Tv[109]+Tv[115])*0.25/100;
  Tv[5]:=Tv[110];
  if Tv[5]<100 then Tv[5]:=100; //20230322
  if Tv[5]>15000 then Tv[5]:=15000;
  Tv[116]:=Tv[5];

  //Tv[112]:=0;
  Tv[108]:= Tv[56];
  Tv[113]:=Tv[57];
  Tv[111]:=(Tv[108]+Tv[113])*0.25/100;
  Tv[112]:=Tv[111];
  if Tv[112]<100 then Tv[112]:=100;
  if Tv[112]>15000 then Tv[112]:=15000;
  Tv[117]:=Tv[112];
  Tv[118]:=Tv[116]+Tv[117];
  End
  Else
  begin
  Tv[109]:=0;
  Tv[115]:=0;
  Tv[110]:=0;
  Tv[5]:=0;
  Tv[116]:=0;

  Tv[108]:=0;
  Tv[113]:=0;
  Tv[111]:=0;
  Tv[112]:=0;
  Tv[117]:=0;
  Tv[118]:=0;
  end;
 end;
 SaveTv(RetNo,FName,FNo);
end;

//20260813 Alex >>>
procedure PS56(RetNo: Integer; FName: string; FNo: Integer);
var
  i: Integer;
begin
 LoadTv(RetNo, FName, FNo);

 with Ret[RetNo].Frm[FNo] do
 begin
  FillT5013Header(RetNo, FNo, 1, 2, 3);

  Tv[9]:= MaxR(0, Tv[7] - Tv[8]);
  Tv[10]:= Tv[9];
  Tv[11]:= Tv[6] + Tv[10];
  Tv[14]:= Tv[12] + Tv[13];
  Tv[15]:= Tv[14];
  Tv[16]:= MaxR(0, Tv[11] - Tv[15]);
  Tv[17]:= Tv[16] * 0.02;
 end;

 SaveTv(RetNo, FName, FNo);
end;
//20260813 Alex <<<

Procedure PS100(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
//replaced elm 187 with  3575 as opposed to 3620 //20170506
//Replace elm 186 3600 with 3560
begin
 //20170506  major changes
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin

   FillT5013Header(RetNo,FNo,1,2,3);

   i:=6;
   Tv[77]:=0;
   repeat
    Tv[77]:=Tv[77]+Tv[i];
    Inc(i,2);
   until i>76;

   i:=79;
   Tv[150]:=0;
   repeat
    Tv[150]:=Tv[150]+Tv[i];
    Inc(i,2);
   until i>149;

   //20170506
   Tv[218]:=TotMultiple(RetNo,'PS125',303)+TotMultiple(RetNo,'PS125',341);  //9999 + 9998
   i:=212;
   Tv[222]:=0;
   Repeat
    Tv[222]:=Tv[222]+Tv[i];
    Inc(i,1);
   Until i>221;

   i:=223;
   Tv[227]:=0;
   Repeat
    Tv[227]:=Tv[227]+Tv[i];
    Inc(i,1);
   Until i>226;

   i:=228;
   Tv[232]:=0;
   Repeat
    Tv[232]:=Tv[232]+Tv[i];
    Inc(i,1);
   Until i>231;

   Tv[184]:=Tv[217];
   Tv[186]:=Tv[227];
   Tv[187]:=Tv[227]+Tv[232];

  {
   i:=152;
   Tv[187]:=0;
   repeat
    Tv[187]:=Tv[187]+Tv[i];
    Inc(i,2);
   until i>186;

   i:=189;
   Tv[210]:=0;
   repeat
    Tv[210]:=Tv[210]+Tv[i];
    Inc(i,2);
   until i>209;
  }
 end;
 SaveTv(RetNo,FName,FNo);
end;

procedure PS125(RetNo: integer; FName: String;FNo: integer);
// 20250812 Igor >>>
var
  i, j: integer;
  FInst: String;
  lSecNum: string;
// 20250812 Igor <<<
begin
 FInst:=ExtractFormInst(FName);
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillT5013Header(RetNo,FNo,1,2,3);
   FillT5013Header(RetNo,FNo,1,332,333);
   // 20250812 Igor >>>
   Strings[304]:= paddzero(MidStr(FInst, 2, 3), 2);
   lSecNum:= Strings[304];
   if lSecNum.Equals('00') then Strings[304]:= '01';
   // 20250812 Igor <<<
   if Strings[299]+Strings[4]='' then Strings[299]:='X'; //20210326

  // If CertificationMode then Strings[304]:='01'; //20140324 put it direcly on the form
   i:=8;
   Tv[67]:=0;
   repeat
    Tv[67]:=Tv[67]+Tv[i];
    Inc(i,2);
   until i>66;

  i:=69;
  Tv[127]:=0;
  repeat
   Tv[127]:=Tv[127]+Tv[i];
   Inc(i,2);
  until i>125;

  i:=129;
  Tv[185]:=0;
  repeat
   Tv[185]:=Tv[185]+Tv[i];
   Inc(i,2);
  until i>183;

  Tv[187]:=Tv[127]+Tv[185];
  Tv[188]:=Tv[67]-Tv[187];

  i:=190;
  Tv[205]:=0;
  repeat
   Tv[205]:=Tv[205]+Tv[i];
   Inc(i,2);
  until i>204;
  i:=207;         //20140324
  repeat
   Tv[205]:=Tv[205]+Tv[i];
   Inc(i,2);
  until i>231;


  i:=233; //20140324
  Tv[275]:=0;
  repeat
   Tv[275]:=Tv[275]+Tv[i];
   Inc(i,2);
  until i>273;

  Tv[352]:=Tv[205]-Tv[275];  //20231223

  Tv[276]:=Tv[205]-Tv[275];

  i:=334;
  Tv[341]:=0;
  repeat
   Tv[341]:=Tv[341]+Tv[i];
   Inc(i,1);
  until i>340;

  {
  i:=278;
  Tv[302]:=0;
  repeat
   Tv[302]:=Tv[302]+Tv[i];
   Inc(i,2);
  until i>300;
  }
  Tv[300]:=0;
  i:=278;
  Repeat
   Tv[300]:=Tv[300]+Tv[i];
   Inc(i,2);
  until i>298;
  Tv[303]:=Tv[188]+Tv[276]+Tv[300]+Tv[341];  //20170506
  //Tv[303]:=Tv[188]+Tv[276]-Tv[300]+Tv[341];

  For i:=305 to 331 do begin Tv[i]:=0;Strings[i]:='';end;
  For i:=342 to 349 do begin Tv[i]:=0;Strings[i]:='';end;

  If (CountPS125(RetNo)>1) and (FInst='#1') then
  begin
   Tv[305]:=TotMultiple(RetNo,'PS125',188)+TotMultiple(RetNo,'PS125',276);  //9970
   Tv[342]:=TotMultiple(RetNo,'PS125',334);
   Tv[343]:=TotMultiple(RetNo,'PS125',335);
   Tv[344]:=TotMultiple(RetNo,'PS125',336);
   Tv[345]:=TotMultiple(RetNo,'PS125',337);
   Tv[346]:=TotMultiple(RetNo,'PS125',338);
   Tv[347]:=TotMultiple(RetNo,'PS125',339);
   Tv[348]:=TotMultiple(RetNo,'PS125',340);
   Tv[349]:=TotMultiple(RetNo,'PS125',341);

   j:=306;
   Repeat
    Strings[j]:=Strings[j-29];
    Inc(j,2)
   until j>326;

   Tv[307]:=TotMultiple(RetNo,'PS125',278);
   Tv[309]:=TotMultiple(RetNo,'PS125',280);
   Tv[311]:=TotMultiple(RetNo,'PS125',282);
   Tv[313]:=TotMultiple(RetNo,'PS125',284);
   Tv[315]:=TotMultiple(RetNo,'PS125',286);
   Tv[317]:=TotMultiple(RetNo,'PS125',288);
   Tv[319]:=TotMultiple(RetNo,'PS125',290);
   Tv[321]:=TotMultiple(RetNo,'PS125',292);
   Tv[323]:=TotMultiple(RetNo,'PS125',294);
   Tv[325]:=TotMultiple(RetNo,'PS125',296);
   Tv[327]:=TotMultiple(RetNo,'PS125',298);
   Tv[329]:=TotMultiple(RetNo,'PS125',300);
  //tv[330]:=TotMultiple(RetNo,'PS125',338);
   Tv[331]:=TotMultiple(RetNo,'PS125',303);

   (*
   If FInst='#1' then
   begin
    i:=278;j:=307;Tv[330]:=0;
    Repeat
     Strings[j-1]:=Strings[i-1];
     If (Strings[j-1]='') and (FetchElm(RetNo,'PS125#2',i-1)>'') then Strings[j-1]:=FetchElm(RetNo,'PS125#2',i-1);
     If (Strings[j-1]='') and (FetchElm(RetNo,'PS125#3',i-1)>'') then Strings[j-1]:=FetchElm(RetNo,'PS125#3',i-1);
     Tv[j]:=TotMultiple(RetNo,'PS125',i);
     Tv[330]:=Tv[330]+Tv[j];
     Inc(i,2);
     Inc(j,2);
    until i>300;
    Tv[331]:=Tv[305]-Tv[330];
   end;
   *)
  end;
 end;
 SaveTv(RetNo,FName,FNo);
end;


(* //20260828
Procedure T5013A(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin

 GenerateT5013Slips(RetNo);

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  //done in GenerateT5013slip
  If Strings[1]='' then Strings[1]:='N';
  Tv[196]:=Tv[194]*Vl(Strings[195]);
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

Procedure CalcPCCA(Cls:string;UccStart:real;
                 Additions:real;Adjustments:real;Proceeds:real;
                 Var UCC:real;Var HalfRuleAmount:real; Var UCCReduced:real;
                 OverrideIndic:String;HalfYearIndic:String;TermLossIndic:String;
                 Rate:string;
                 Var Recapture:Real;Var TerminalLoss:Real;
                 Var CCA:real;Var UccEnd:real;
                 DaysinTaxYear:integer);

begin
     If Cls='' then
     begin
      UCC :=0;HalfRuleAmount :=0;UccReduced:=0;Recapture:=0;TerminalLoss:=0;
      CCA:=0;UCCEnd:=0;
      exit;
     end;
     If DaysInTaxYear>365 then DaysInTaxYear :=365;
     Ucc      := UccStart + Additions +Adjustments - Proceeds;
     If UpperCase(HalfYearIndic) = 'H' then
       begin
       If UpperCase(OverrideIndic) <> 'O' then
        HalfRuleAmount := Round(MaxR(0, 0.5 * (Additions - Proceeds)));
       end
     else
       HalfRuleAmount :=0;

     UCCReduced  := UCC - HalfRuleAmount;

     If UpperCase(OverrideIndic) = 'O' then exit;


     If UpperCase(TermLossIndic) = 'T' then
     begin
       CCA :=0;
       Recapture :=0;
       TerminalLoss := MaxR(0,UCCReduced);
       UccEnd   := 0;
     end
     else
     begin
      CCA := Round(((UCCReduced * Vl(Rate)) / 100)*(DaysInTaxYear/365));
      If (Cls='13') and (OverrideIndic <> 'O') and (CCA=0) then
       CCA:=Round(UCCReduced * 0.20* DaysInTaxYear/365);
      TerminalLoss :=0;
      Recapture :=0;
      UccEnd   := MaxR(0,UCC - CCA);
     end;

     If UCCReduced <0 then
     begin
      CCA := 0;
      TerminalLoss:=0;
      Recapture := ABS(UCCReduced);
      UCCEnd := 0;
      If Cls='10.1' then
      begin CCA:=ABS(UCCReduced);Recapture:=0;end;
     end;

     If (cls='10.1') and (proceeds>0) then
     begin
      CCA:= Round((UccStart+Adjustments)/2 * Vl(Rate)/100);
      UCC:=0;
      UccReduced:=0;
      TerminalLoss:=0;
      Recapture:=0;
      UccEnd:=0;
     end;
end;

(*
Procedure POTHINFO(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
    Strings[1]:='152';Strings[2]:= 'Last year'+Chr(39)+'s capital gains reserve included in current year';
    Strings[5]:='156';Strings[6] := 'Foreign capital gains (losses)';
    Strings[9]:='157';Strings[10] := 'Foreign capital gains exempt from Canadian tax due to a a tax';
    Strings[13]:='158';Strings[14] := 'Capital gains from gifts of mutual funds/other shares donated to qualified donee';
  {
    Strings[17]:='70-8';Strings[18] := 'Capital gains from gifts of mutual fund units and other shares-eligible amount';
    Strings[21]:='70-9';Strings[22] :=   'Capital gains from gifts of mutual fund units and other shares-advantage';
    Strings[25]:='70-10';Strings[26] := 'Capital gains from gifts of bonds, debentures, promissory notes donated to qualified donee';
    Strings[29]:='70-11';Strings[30] := 'Capital gains from gifts of bonds, debentures, promissory notes-eligible amount';
    Strings[33]:='70-12';Strings[34] := 'Capital gains from gifts of bonds, debentures, promissory notes-advantage';
    Strings[37]:='70-13';Strings[38] := 'Capital gains from gifts of ecologically sensitive land donated to qualified donee';
    Strings[41]:='70-14';Strings[42] := 'Capital gains from gifts of ecologically sensitive land - Eligible amount';
    Strings[45]:='70-15';Strings[46] :=  'Capital gains from gifts of ecologically sensitive land -  Advantage';
    Strings[49]:='70-16';Strings[50] := 'Capital gains (losses) from a subsection 14(1.01)/14(1.02) election';
    Strings[53]:='70-17';Strings[54] := 'Farming and fishing income eligible for the capital gains deduction(QFP or fishing)';
   }
    Strings[57]:='160';Strings[58] := 'Capital gains reserve-QFP/fishing transferred to your child';
    Strings[61]:='161';Strings[62] := 'Capital gains reserve-QSB transferred to your child';
    Strings[65]:='162';Strings[66] := 'Capital gains reserve-other than QFP/Fishing/QSB transferred to your child';
    Strings[69]:='163';Strings[70] := 'Capital gains reserve from other property';
    Strings[73]:='164';Strings[74] := 'Capital gains reserve from capital property disposed of before Nov 13,1981';
    Strings[77]:='165';Strings[78] := 'Capital gains reserve from non-qualifying securities donated to qualified donee';
    Strings[81]:='166';Strings[82] := 'Capital gains reserve from gifts of non-qualifying securities-eligible amount';
    Strings[85]:='167';Strings[86] := 'Capital gains reserve from gifts of non-qualifying securities-advantage';
    Strings[89]:='168';Strings[90] := 'Income tax deducted';
    Strings[93]:='171';Strings[94] := 'Foreign tax paid on non-business income';
    Strings[97]:='172';Strings[98] := 'Foreign tax paid on business income';
    // out Strings[101]:='85-1';Strings[102] := 'Capital cost allowance class for rental or leasing property';

   // Strings[105]:='103-1';Strings[106] := 'Value of the gift';
   // Strings[109]:='104-1';Strings[110] := 'Value of the cultural/ecological gift';
    Strings[165]:='186';Strings[166] := 'Investment tax credit';
    Strings[169]:='187';Strings[170] := 'Investment tax credit transferred under subsection 127(8.3)';
    Strings[173]:='188';Strings[174] :='Excess ITC recapture';
    //descriptive
   {
  //  Strings[177]:='103-2';Strings[178] := 'Name of the gift'#39's recipient';
  //  Strings[180]:='103-3';Strings[181] := 'Date the recipient received the gift';
  //  Strings[183]:='103-4';Strings[184] := 'Description of the gifted property';
  //  Strings[186]:='103-5';Strings[187] := 'Donor'#39's name that the recipient recorded on the receipt';

 //   Strings[189]:='104-2';Strings[190] := 'Name of the gift'#39's recipient';
    Strings[192]:='104-3';Strings[193] := 'Date the recipient received the gift';
    Strings[195]:='104-4';Strings[196] := 'Description of the gifted property';
    Strings[198]:='104-5';Strings[199] := 'Donor'#39's name that the recipient recorded on the receipt';

    Strings[201]:='105-1';Strings[202] := 'Name of the registered party or provincial devision of it';
    Strings[204]:='105-2';Strings[205] := 'Name of the registered constituency association';
    Strings[207]:='105-3';Strings[208] := 'Name of the candidate';
    Strings[210]:='105-4';Strings[211] := 'Date the recipient received the contribution';
    Strings[213]:='105-5';Strings[214] := 'Donor'#39's name that the recipient recorded on the receipt';

    Strings[216]:='106-1';Strings[217] := 'Name of the provincial or territorial registered party';
    Strings[219]:='106-2';Strings[220] := 'Name of the registered constituency association';
    Strings[222]:='106-3';Strings[223] := 'Name of the candidate';
    Strings[225]:='106-4';Strings[226] := 'Date the recipient received the contribution';
    Strings[228]:='106-5';Strings[229] := 'Donor'#39's name that the recipient recorded on the receipt';
    }
    Strings[231]:='138';Strings[232] := 'Name of the Small Business Corporation';
    Strings[234]:='139';Strings[235] := 'Number and class of shares, or type of debt disposed of';
    Strings[237]:='140';Strings[238] := 'Insolvency, bankruptcy or wind-up date';
    Strings[240]:='141';Strings[241] := 'Date the partnership bought the shares or aquired the debt';
    Strings[243]:='142';Strings[244] := 'Proceeds of disposition';
    Strings[246]:='143';Strings[247] := 'Adjusted cost base of the shares or debt';
    Strings[249]:='144';Strings[250] := 'Outlays and expenses on the disposition';

    //has data
    Ret[RetNo].FrmHasData[FNo]:=False;
    i:=4;
    Repeat
     If Tv[i]>0 then begin  Ret[RetNo].FrmHasData[FNo]:=True;Break;End;
     Inc(i,4);
    until i>176;

    i:=179;
    Repeat
     If Strings[i]>'' then begin  Ret[RetNo].FrmHasData[FNo]:=True;Break;End;
     Inc(i,3);
    until i>251;
 end;
 SaveTv(RetNo,FName,FNo);
end;
*)

Procedure RemoveAllT5013SlipData(RetNo:Integer);  //20260908CZ
Var i,j, SlipFNo:Integer;
begin
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (LeftStr(Frec.FormName,6) = 'T5013#')
   then
   begin
    SlipFNo:=FRec.FormNo;
    For j:=2 to 67 do  StoreElm(RetNo,SlipFNo,j,'');
    {
    For j:=2 to 7 do  StoreElm(RetNo,SlipFNo,j,'');
    //do not remove elm 14 that has the Partber id  //20260907CZ
    For j:=9 to 13 do  StoreElm(RetNo,SlipFNo,j,'');
    For j:=15 to 30 do  StoreElm(RetNo,SlipFNo,j,'');
    For j:=33 to 174 do  StoreElm(RetNo,SlipFNo,j,'');
    For j:=176 to 193 do  StoreElm(RetNo,SlipFNo,j,'');
   }
   end;
 end;
end;

Procedure ClearAllT5013Slips(RetNo:Integer);
Var i,j:Integer;
begin
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (LeftStr(Frec.FormName,6) = 'T5013#')
   then
   begin
    If Frec.FormNo>0 then
    begin
      If UpperCase(FetchElmFNo(RetNo,Frec.FormNo,1)) <> 'Y' then
      begin
        For j:=2 to 7 do  StoreElm(RetNo,Frec.FormNo,j,'');
        For j:=9 to 30 do  StoreElm(RetNo,Frec.FormNo,j,'');
        For j:=33 to 174 do  StoreElm(RetNo,Frec.FormNo,j,'');
        For j:=176 to 193 do  StoreElm(RetNo,Frec.FormNo,j,'');
       // For j:=194 to 202 do  StoreElm(RetNo,Frec.FormNo,j,''); //keep it
      end;
    end;
   end;
 end;
end;

(*
Function IsLimitedPartnership(RetNo:Integer):Boolean;
begin
 If FetchElm(RetNo,'T5013FIN',62)>'' then result:=True else result:=False;
end;
*)
Function IsT5013Shelter(RetNo:Integer):Boolean;
begin
 If FetchElm(RetNo,'T5013FIN',62)>'' then result:=True else result:=False;
end;

(*
Function CountT5013Slips(RetNo:Integer):Integer;
Var i,j:Integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormName='PS50' then
   begin
    Result:=Result+MyStrToInt(FetchElmFNo(RetNo,Frec.FormNo,362));
    {
    j:=4;
    Repeat
     If (FetchElmFNo(RetNo,Frec.FormNo,j) >'')
     and (FetchElmFNo(RetNo,Frec.FormNo,j+5) >'')  then Inc(Result);
     Inc(j,17);
    until j>327;
    }
   end;
 end;
end;
*)


Function ClaimedRenouncedResources(RetNo:Integer):Boolean;
Var i,FNo:Integer;x:Real;
begin
 FNo:=GetFormNo('T5013SUM');
 x:=0;
 for i:=149 to 159 do x:=x+Vl(FetchElmFNo(RetNo,FNo,i));
 If X>0 then result:=True else Result:=False;
end;

(* 20180422
Procedure PT1135(RetNo:integer;FName:string;FNo:integer);
var i: integer;
Begin
end;
*)
Procedure PS141(RetNo: integer; FName: String;FNo: integer);
Var  i: integer;
begin
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
   FillT5013Header(RetNo,FNo,1,2,3);
   FillT5013Header(RetNo,FNo,1,10,11);
   If Strings[12]+Strings[13]='' then Strings[13]:='X';
   If Strings[26]+Strings[27]='' then Strings[27]:='X';
   If Strings[27]>'' then begin Strings[28]:='';Strings[29]:='';end;

   i:=18;
   If Strings[12]>'' then
   Repeat
    If Strings[i]+Strings[i+1]= ''  Then Strings[i+1] :='X';
    Inc(i,2);
   until i>24
   else
   begin
    i:=18;
    repeat
    Strings[i]:='';
    Strings[i+1]:='';
    Inc(i,2);
    until i>24;
   end;
   If (Strings[7]>'') or (Strings[32]>'') then
   begin
     Strings[38]:='';Strings[39]:='';
   end;
   If Strings[36]>'' then begin Strings[38]:='';Strings[39]:='';end;
 end;
 SaveTv(RetNo,FName,FNo);
end;

Function GetT5013SlipType(RetNo:Integer):String;
Begin
  Result:='T5013';
  {If (IsT5013Shelter(RetNo)) or (ClaimedRenouncedResources(RetNo)) then result:='T5013A';}
end;

Function CountPs125(RetNo:Integer):Integer;
Var i:Integer;
Begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'PS125') then
   begin
    If Ret[RetNo].FrmHasData[Frec.FormNo] then Inc(Result);
   end;
 end; //i
end;

Procedure T661(RetNo:integer;FName:string;FNo:integer);
Var
    i,k:integer;
    Cnt1,Cnt2:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
  //trings[10]:=RsiApprovalCode;
   
   Strings[1] := FetchElm(RetNo,'T5013SUM',11);
   Strings[2] := FetchElm(RetNo,'T5013SUM',5);
   Strings[3]:=FetchElm(RetNo,'T5013SUM',13)
              +' '+FetchElm(RetNo,'T5013SUM',14);
   Strings[21]:=FetchElm(RetNo,'T5013SUM',15)
              +' '+FetchElm(RetNo,'T5013SUM',16)
              +' '+FetchElm(RetNo,'T5013SUM',17);

   If Strings[11]+Strings[12] = '' then Strings[12] :='X';
   If Strings[25]+Strings[26] = '' then Strings[26] :='X';
   (*
   If Strings[6] = '' then
    Strings[6] := FetchElm(RetNo,'PAGE_8',43)
                  +' '+FetchElm(RetNo,'PAGE_8',42); {contact}

   If Strings[7] = '' then
     Strings[7] := FetchElm(RetNo,'PAGE_8',55)
                 +' '+FetchElm(RetNo,'PAGE_8',46); {tel}
   If Strings[15] ='' then
    Strings[15] := FetchElm(RetNo,'PAGE_8',43)
                  +' '+FetchElm(RetNo,'PAGE_8',42); {signing}
   *)
   If Strings[16]='' then Strings[16]:= FormatDateTime('yyyy/mm/dd',Date);

   Strings[4] := FetchElm(RetNo,'T5013SUM',3);
   Strings[5] := FetchElm(RetNo,'T5013SUM',5);
  end; {End with}

  // T661 pg 2 -----------------------------------------------------------------

  //no calc

  // T661 pg 3 -----------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin

   // Strings[10] := RsiApprovalCode;
   If UpperCase(FetchElm(RetNo,'T661',26)) = 'X' then Tv[251] :=0; //traditional
   If UpperCase(FetchElm(RetNo,'T661',25)) = 'X' then Tv[252] :=0;    //proxy

   Tv[213]:=Vl(FetchElm(RetNo,'T661_9',147))+TotMultiple(RetNo,'T661F',147);
   Tv[248]:=Tv[212]+Tv[213];
   Tv[215]:=Vl(FetchElm(RetNo,'T661_9',148))+TotMultiple(RetNo,'T661F',148);
   Tv[249]:=Tv[214]+Tv[215];

   Tv[253]:=Tv[206]+Tv[244]+Tv[245]+tv[247]+Tv[258]+Tv[248]+Tv[249]+Tv[250]+Tv[251]+Tv[252];

   Tv[254]:=Vl(FetchElm(RetNo,'T661',303)); //+TotMultiple(RetNo,'S30',3); //,T661',552);

   Tv[255]:=Tv[253]+Tv[254];
   Tv[257]:=Tv[255]+Tv[256];

    // Step 2
    Tv[231]:= Tv[257]; // Vl(FetchElm(RetNo,'T661',115));
    Tv[243]:= Vl(FetchElm(RetNo,'T661',503));
    Tv[211]:= Tv[231]-Tv[232]-Tv[234]-Tv[233]+Tv[236]+Tv[242]+Tv[243];
    Tv[238]:=MaxR(0,Tv[211]); //Tv[38]:= Tv[31]-Tv[32]-Tv[34]-Tv[33]+Tv[36]+Tv[42]+Tv[43];
    Tv[239]:=MaxR(0,Tv[211]); //MaxR(0,Tv[38]);
    If UpperCase(Strings[209]) = 'Y' then Tv[239]:=Tv[41];
    If Tv[239]>Tv[211] then Tv[239]:=Tv[211];
    If Tv[239]<0 then Tv[239]:=0;
    Tv[240] :=MaxR(0,Tv[211]-Tv[239]);

    //step 3

    Tv[201] := tv[255]; //Vl(FetchElm(RetNo,'T661',113));
    Tv[202] := Tv[256]; //Vl(FetchElm(RetNo,'T661',114));
    {deductions}
    Tv[204]:=Vl(FetchElm(RetNo,'T661',678));
    Tv[220]:=Vl(FetchElm(RetNo,'T661',510));
    Tv[221]:=Vl(FetchElm(RetNo,'T661',511));
    Tv[222]:=Vl(FetchElm(RetNo,'T661',519));
    Tv[223]:=Vl(FetchElm(RetNo,'T661',520));
    Tv[226]:=MaxR(0,Tv[201]+Tv[203]+Tv[204]+Tv[207]-Tv[218]-Tv[220]-Tv[222]);
    Tv[227]:=MaxR(0,Tv[202]+Tv[205]+Tv[208]-Tv[219]-Tv[221]-Tv[223]);

    Tv[228] := Tv[226]+Tv[227];
    Tv[230] := Tv[228]+Tv[229];
    {for itc done}

  end; {with}



  // T661 pg 4 -----------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[304]:= MaxR(0,Vl(FetchElm(RetNo,'T661',257))
                -Vl(FetchElm(RetNo,'T661',248))
                -Vl(FetchElm(RetNo,'T661',249))
                -Vl(FetchElm(RetNo,'T661',254)));

  end; {with}



  // T661 pg 5 -----------------------------------------------------------------

  //no calc

  // T661 pg 6 -----------------------------------------------------------------
  with Ret[RetNo].Frm[Fno] do
  begin
   Tv[503]:=Tv[501]+Tv[502];
   Tv[510]:=Tv[504]+Tv[505]+Tv[506]+Tv[508];
   Tv[511]:=Tv[507]+Tv[509];

   Tv[514]:=Vl(FetchElm(RetNo,'T661',249));
   Tv[519]:=Tv[512]+Tv[514]+Tv[515]+Tv[517];
   Tv[520]:=Tv[513]+Tv[516]+Tv[518];
  end; {End with}


  // T661 pg 7 -----------------------------------------------------------------
 with Ret[RetNo].Frm[Fno] do
 begin
  If GetT5013YearEndYYYY(RetNo) = 2000 then Tv[677] := 37600
  else If GetT5013YearEndYYYY(RetNo) = 2001  then Tv[677] := 38300
  else If GetT5013YearEndYYYY(RetNo) = 2002  then Tv[677] := 39100
  else If GetT5013YearEndYYYY(RetNo) = 2003  then Tv[677] := 39900
  else If GetT5013YearEndYYYY(RetNo) = 2004  then Tv[677] := 40500
  else If GetT5013YearEndYYYY(RetNo) = 2005  then Tv[677] := 41100
  else If GetT5013YearEndYYYY(RetNo) >= 2006 then Tv[677] := 42100;

  i := 607;k:=67;Tv[683] :=0;
  Repeat
   If (Vl(Strings[i+1]) =0) and (Strings[i-1] >'') then Strings[i+1] := '75';
   If Vl(Strings[i+1]) > 75 then Strings[i+1] := '75';
   Tv[i+2] := Tv[i] * Vl(Strings[i+1]) /100;
   If Tv[i] >0 then
    Tv[i+3] := 2.5 * Tv[77] * (vl(Strings[k])/365)
   else
    Tv[i+3] :=0;
   Tv[i+4]:=MinR(Tv[i+2], Tv[i+3]);
   Tv[83] := Tv[83] +Tv[i+4];
   Inc(i,6);
   Inc(K,1);
  until i>661;

  Tv[601]:= vl(FetchElm(RetNo,'T661',206));
  Tv[666]:=MaxR(0,Tv[601]-Tv[602]);
  Tv[603]:=Tv[683];
  Tv[605]:=Tv[666]+Tv[603];

  Tv[678]:=Tv[605] * 65/100;
  If UpperCase(Strings[680]) = 'Y' then Tv[678] := Tv[681];
  If FetchElm(RetNo,'T661',25) = '' then  {not proxy}
   begin Tv[601]:=0;Tv[602]:=0;Tv[666]:=0;Tv[603]:=0;Tv[605]:=0;Tv[678]:=0;end;
 end; {End with}



  // T661 pg 8 -----------------------------------------------------------------



  // T661 pg 9 -----------------------------------------------------------------
  //exceeds 1000 - Tv's not updated
  //j???
  with Ret[RetNo].Frm[Fno] do
  begin
   Cnt1:=0;
   Cnt2:=0;
   Tv[147]:=0;
   i:=8;
   Repeat
    Tv[147]:=Tv[147]+Tv[i];
    If Tv[i]>0 then Inc(Cnt1);
    Inc(i,6);
   until i>74;

   Tv[148]:=0;
   i:=80;
   Repeat
    Tv[148]:=Tv[148]+Tv[i];
    If Tv[i]>0 then Inc(Cnt2);
    Inc(i,6);
   until i>146;

   Strings[1]:=IntToStr(Cnt1);
   If Strings[1]='0' then Strings[1]:='';
   Strings[2]:=IntToStr(Cnt2);
   If Strings[2]='0' then Strings[2]:='';

  end; {End with}

  SaveTv(RetNo,FName,FNo);
end;


Function GetT5013YearEndYYYY(RetNo:Integer):Integer;
begin
 result:=MyStrToInt(LeftStr(FetchElm(RetNo,'T5013FIN',1),4));
end;

Function GetT5013AccountNo(RetNo:Integer):String;
begin
 result:=FetchElm(RetNo,'T5013FIN',1);
end;

Function GetT5013FiscalPeriodEnd(RetNo:Integer):String;
begin
 result:=FetchElm(RetNo,'T5013FIN',39);
end;


Procedure PS5(RetNo:integer;FName:string;FNo:integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillT5013Header(RetNo,FNo,1,2,3);
    If Strings[68]+Strings[4]='' then Strings[68]:='';
    i:=8;
    Tv[70]:=0;
    Tv[71]:=0;
    Repeat
     If Strings[i-2]+Strings[i-1]='' then Strings[i-1]:='X';
     If UpperCase(Strings[i-1])='X' then begin Tv[i]:=0;Tv[i+1]:=0;end;
     Tv[70]:=Tv[70]+Tv[i];
     Tv[71]:=Tv[71]+Tv[i+1];
     Inc(i,4);
    until i>68;

    i:=74;
    Repeat
     If Strings[i]+Strings[i+1]='' then Strings[i+1]:='X';
     Inc(i,4);
    until i>94;
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;

Procedure PS9(RetNo:integer;FName:string;FNo:integer);
Var i,j:integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    FillT5013Header(RetNo,FNo,1,2,3);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Procedure T5013WS(RetNo:integer;FName:string;FNo:integer);
Var i,j:integer; AFNo:Integer;
begin
  LoadTv(RetNo,FName,FNo);
  with Ret[RetNo].Frm[Fno] do
  begin
    TV[1]:=Vl(FetchElm(RetNo,'PS1',41)); //20140326
    Tv[26]:=TotMultiple(RetNo, 'PS125',67);  //20260828  S125 8299 Gross Total Revenue

    (*
    //dividends //20140615
    If UpperCase(Strings[251]) <> 'Y' then
    Begin
     Tv[70]:=Tv[68]*1.25;  //20140615
     Tv[72]:=Tv[70] * 13.3333/100;
     If LeftStr(FetchElm(RetNo,'T5013FIN',39),4)>'2013' then  Tv[72]:=Tv[70] * 11.0169/100;

     Tv[76]:=Tv[74] * 1.38;
     Tv[78]:=Tv[76] * 15.0198/100;
    end;
    *)
    //box 182
    Tv[190]:=TotMultiple(RetNo,'PS2',29)+TotMultiple(RetNo,'PS2',54);
   //box 183
    Tv[192]:=TotMultiple(RetNo,'PS2',73)+TotMultiple(RetNo,'PS2',92);
    //box 184
    Tv[194]:=TotMultiple(RetNo,'PS2',111);
    //box 185
    Tv[196]:=TotMultiple(RetNo,'PS2',130);
     //box 208
    Tv[200]:=TotMultiple(RetNo,'PS2',152);
     //box 207
    Tv[198]:=TotMultiple(RetNo,'PS2',171);

    //from ps6
    //Box 030 and 151  cap gains losses //same?
    Tv[120]:=TotMultiple(RetNo,'PS6',422);
    Tv[122]:= TotMultiple(RetNo, 'PS6', 519);//TotMultiple(RetNo,'PS6',422); //20260907 Alex
    //Box 153  QSB
    Tv[126]:= TotMultiple(RetNo, 'PS6', 510);//TotMultiple(RetNo,'PS6',423); //20260907 Alex
    //Box 154  QSB
    Tv[128]:= TotMultiple(RetNo, 'PS6', 512);//TotMultiple(RetNo,'PS6',424); //20260907 Alex
   //Box 155  foreclosures
    Tv[130]:= TotMultiple(RetNo, 'PS6', 514);//TotMultiple(RetNo,'PS6',425); //20260907 Alex

    //from ps10
   //Box 158
    Tv[136]:=Vl(FetchElm(RetNo,'PS10',65));

   //from ps12
   //Box 173
   Tv[172]:=Vl(FetchElm(RetNo,'PS12',15));

   //Box 206
   Tv[174]:=Vl(FetchElm(RetNo,'PS12',78));

   //Box 179
   Tv[184]:=Vl(FetchElm(RetNo,'PS12',16));

   //Box 174
   Tv[176]:=Vl(FetchElm(RetNo,'PS12',26));

   //Box 180
   Tv[186]:=Vl(FetchElm(RetNo,'PS12',27));

   //Box 175
   Tv[178]:=Vl(FetchElm(RetNo,'PS12',38));

   //Box 181
   Tv[188]:=Vl(FetchElm(RetNo,'PS12',39));


   //Box 176
   Tv[180]:=Vl(FetchElm(RetNo,'PS12',72));

   //Box 177
   Tv[182]:=Vl(FetchElm(RetNo,'PS12',73));

   Tv[241]:=Vl(FetchElm(RetNo,'PS58',22)); //air quality //20230326
   Strings[245]:='238';


   if Vl(FetchElm(RetNo,'PS63',93))>0 then  //20230329
   begin
    Strings[243]:='237';
    Tv[244]:=Vl(FetchElm(RetNo,'PS63',93));
   end
   Else
   Begin
    Strings[243]:='';
    Tv[244]:=0;
   End;

   If Vl(FetchElm(RetNo,'PS65',22))>0 then //20230329
   Begin
    Strings[245]:='238';
    Tv[246]:=Vl(FetchElm(RetNo,'PS65',22)); //air quality //20230326
   end
   Else
   Begin
    Strings[245]:='';
    Tv[246]:=0;
   End;

   //Box 040 cca
   Tv[166]:=TotMultiple(RetNo,'PS8',232);
  end; {End with}
  SaveTv(RetNo,FName,FNo);
end;


Function GetTheBoxNoOfT5013Ws(AmtElm:String):String;
//Get The box Number corresponding to the amount elm of th T5013Ws
Var i:Integer;TempList:TStringList;
Begin
 Result:='';
 TempList:=TStringList.Create;
 Templist.LoadFromFile(AppDir+'\'+'T5013Boxes.d');
 i:=0;
 Repeat
  If AmtElm=MidStr(TempList[i],5,3) then
  begin
   Result:=LeftStr(TempList[i],3);
   TempList.Free;
   Exit;
  End;
  Inc(i,1);
 Until i>TempList.Count-1;
 TempList.Free;
end;


Function GetBoxTotalsFromAllT5013(RetNo:Integer;BoxNo:String):Real;
Var i,j:Integer; x: real;
Begin
 x:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormName = 'T5013') then
   begin
    If Frec.FormNo>0 then
    begin
      j:=32;
      Repeat
       If FetchElmFNo(RetNo,Frec.FormNo,j)=BoxNo then
         x:=x+Vl(FetchElmFNo(RetNo,Frec.FormNo,j+2));
       Inc(j,3);
      until j>65;
    end;
   end;
 end; //i
 Result:=x;
end;

procedure PS8(RetNo: integer; FName: string; FNo: integer);
// columns first row index
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
  Col12 = 502;  //20230321
  col13 = 437;
  col14 = 450;
  col15 = 252;
  col16 = 476;
  col17 = 291;
  col18 = 304;
  col19 = 317;
  col20 = 330;
  col21 = 17;
  col22 = 18;
  col23 = 19;
  col24 = 20;
  col25 = 21;
Var
  i, k, K1: integer;
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

begin
  // x := Vl(FetchElm(RetNo, FNo, 232)); // 20220726
  DaysInTaxYear := Ret[RetNo].DaysInYear;
  If DaysInTaxYear > 365 then
    DaysInTaxYear := 365;
  S8FNo := GetFormNo('S8#1'); // 20220826
  FInst := ExtractFormInst(FName);
  LoadTv(RetNo, FName, FNo);
  with Ret[RetNo].Frm[FNo] do
  begin
    FillT5013Header(RetNo, FNo, 1, 2, 3);  //20230325
    If Strings[4] + Strings[5] = '' then
      Strings[5] := 'X';
    If Strings[216] = '' then Strings[216] := 'N'; // 20221107
    If Strings[217] = '' then Strings[217] := 'Y';
    // INIT Totals //20190614
    i := 530;
    z := 0;
    Repeat
     if Strings[i-2]='' then Strings[i-1]:=''; //20230309
     z := z + Vl(Strings[i]);
      Inc(i, 3); // 20220912
    Until i > 599;
    Strings[13] := FormatFloat('###.####', z);

    If z > 100 then
      Strings[29] := '0'
    else
    Begin
      y := (Ret[RetNo].DaysInYear / 365) * (1500000 * Vl(Strings[530]) / 100);
      // the first on the list
      Strings[29] := FormatFloat('##,###,###', y);
    end;

    Tv[77] := 0;
    Tv[109]:=0; //20230321
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
    /// /k is the row being processed starts from k=0 //13 rows per section
    Begin
      // repeate class for each section from Part 2
      Cls := AllTrim(Strings[col1 + k * 16]); // 20190719 //alltrim
      Strings[384 + k * 1] := Cls; // 20190705
      Strings[515 + k * 1] := Cls; // 20220730 //dupl/copy cless

     // Rate := GetCCARate(Cls); // string //20190614  see beloq //20221121

      // set up override indicatore
      If UpperCase(Strings[14 + k * 16]) = 'O' then
        Strings[14 + k * 16] := 'Y'; // override
      If UpperCase(Strings[15 + k * 16]) = 'H' then
        Strings[15 + k * 16] := 'Y'; // half year
      if Vl(Rate) = 100 then
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

     // Rate := GetCCARate(Cls); //20221121
      If  Strings[489+k*1] <> 'Y' then
        Strings[17+k*16]:=GetCCARate(Cls); //20221121
      Rate:=Strings[17+k*16];

      OriginalCost := Tv[371 + k * 1];
      AssetInfo := Strings[236 + k * 1];
      // calculate each Column mow
      UccStart := Tv[col2 + k * 16]; // col2
      Additions := Tv[col3 + k * 16]; // col3
      if DiepClass(Cls) = False then Tv[col4 + k * 1] := 0; //20221115 //Tv[col2 + k * 16] := 0; // 20221107
      if DiepClass(Cls) = False then Tv[col9 + k * 1] := 0; // 20221015
      if Strings[216]='' then Strings[216]:='Y';
      //if DiepClass(Cls) = False then Tv[col11 + k * 1] := 0; // 20221015

      Adjustments := Tv[col5 + k * 16]; // cpl 5

    //  if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col5 + k * 1]; //20221108
    //  if Tv[col11+k*1]>Tv[col5 + k * 1] then Tv[col5 + k * 1]:=Tv[col5 + k * 1]; //20221108

      //DiepUcc := Tv[col11 + k * 1]; // 20220826 //20221107
      Tv[77] := Tv[77] + Tv[col11 + k * 1];
      Tv[109]:= Tv[109]+Tv[col12 + k * 1];  //20230321
      ImmediateExpensing := Tv[col13 + k * 1]; // 20220826
      Tv[93] := Tv[93] + ImmediateExpensing;

      // move down
      // Tv[col8+k*16]:=MaxR(0,Tv[col8+k*16]);  //20220621
      // Proceeds:=Tv[col8+k*16];

      if (LeaseHold(Cls)) and (UccStart > 0) Then
      begin
        { //20220913
          Additions := 0;
          Tv[col3 + k * 16] := 0;
        }
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
      Strings[356 + k * 1] := '';
      if (Additions > 0) and (Cls > '') then
      Begin
        s := ReplaceChar(AssetInfo, ',', '');
        PurchaseDate := LeftStr(s, 10);
        if (PurchaseDate > '2018/11/20') or
          (GetTaxationYearStart(RetNo) > '2018/11/20')
        // 20220619 additions made after the Aiip date of 2018
        then
          Strings[356 + k * 1] := 'X' // then 10.1 is aiip
        Else
          Strings[356 + k * 1] := ''; // 20190705
      end;

      if (GetTaxationYearEnd(RetNo) > '2027/12/31') then
        Strings[356 + k * 1] := '';
      // NO AIIP after 2027? Check it then IF ALIVE! //20190704
      If Strings[356 + k * 1] > '' then
        Aiip := True
      else
        Aiip := False; // 20190614
      if Cls = '56' then
      Begin
        Aiip := False;
        Strings[356 + k * 1] := '';
      end; // 20220531

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
      {//20221121
      OverrideIndic := UpperCase(Strings[14 + k * 16]);
      HalfYearIndic := UpperCase(Strings[15 + k * 16]);
      TermLossIndic := UpperCase(Strings[16 + k * 16]);
      }

     // If UpperCase(OverrideIndic) <> 'Y' then Rate := GetCCARate(Cls); //20221121 see in beginning

      // Inpout validations
      if Cls = '10.1' then // 20190622
      Begin
        if PurchaseDate < GetTaxationYearStart(RetNo) then
          Tv[col3 + k * 16] := 0; // no additions allowed
      End;

      If (Aiip = False) and (Cls <> '56') then
        Tv[col15 + k * 1] := 0; // // 20220531 aiip portion of col 3

      AdditionsAiip := Tv[col15 + k * 1];
      // assistance part of col 5
      // If Tv[265+k*1]>Tv[9+k*16] then Tv[265+k*1]:=Tv[9+k*16];  //20220621
      Tv[col6 + k * 1] := MaxR(0, Tv[col6 + k * 1]); // col6 //20220621
      AssistanceReceived := Tv[col6 + k * 1];
      Tv[col7 + k * 1] := MaxR(0, Tv[col7 + k * 1]); // col 7 //20220621
      RepaidAmount := Tv[col7 * 1]; // col7
      Tv[col8 + k * 16] := MaxR(0, Tv[col8 + k * 16]);
      // 20220621  //from aboeve //20220731
      // Proceeds:=Tv[col8+k*16];  //20220731

      // aiip  related
      If Aiip = False then
      Begin
        Tv[col17 + k * 1] := 0;
        Tv[col18 + k * 1] := 0;
        Tv[343 + k * 1] := 0;
        Tv[col19 + k * 1] := 0;
        Tv[col20 + k * 1] := 0;
      End;
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
        Rate := FormatFloat('####.##', 100 / LeaseTerm); // 20190601
        Strings[col21 * k * 16] := Rate;
        // if rate='INF' then ShowMessage('inf rate');

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

        { 20220731
          UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount-Proceeds;
          if (cls='10.1') and (Proceeds>0) then UCCReduced:=UccStart +additions+Adjustments-AssistanceReceived+RePaidAmount; //without proceeds //20220619
        }

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
      if Tv[col4 + k * 1] > Tv[col3 + k * 1] then
        Tv[col4 + k * 1] := Tv[col3 + k * 16];

      // Col5
      Tv[250]:= Tv[250] + Tv[col5 + k * 16]; // 20250820 Igor

      // Col8                                 -
      Tv[235] := Tv[235] + Tv[col8 + k * 16];
      // col9  user inout
      if Tv[col9 + k * 1] > Tv[col8 + k * 16] then
        Tv[col9 + k * 1] := Tv[col8 + k * 16];
      // col10
      Tv[col10 + k * 16] := Tv[col2 + k * 16] + Tv[col3 + k * 16] + Tv[col5 + k * 16] - Tv[col8 + k * 16];

      // col11                    **
      if UpperCase(Strings[216])='Y' then Tv[col11+k*1]:=Tv[col4+k*1]; //20221108
      if Tv[col11+k*1]>Tv[col4+k*1] then Tv[col11+k*1]:=Tv[col4+k*1]; //20221108

      // col12 //semi automatic  //20220827 imm expensing amount = designated
      If UpperCase(Ret[RetNo].Frm[FNo].Strings[217]) = 'Y' then
      // autofill col 12
      Begin
        If (Tv[col4 + k * 1] > 0) and (Tv[col13 + k * 1] = 0) then
          Tv[col13 + k * 1] := Tv[col4 + k * 1]; // 20221017
      end;

      if Tv[col13 + k * 1] > Tv[col4 + k * 1] then Tv[col13 + k * 1] := Tv[col11 + k * 1];
      if Tv[col13 + k * 1]>1500000 then Tv[col13 + k * 1]:=1500000; //20230322

      //if Ret[RetNo].CorpType<>CCPC then Tv[col12 + k * 1]:=0; //20221115  //20230321

      // col14
      Tv[col14 + k * 1] := MaxR(0, Tv[col3 + k * 16] - Tv[col4 + k * 1] +
        Tv[col11 + k * 1] - Tv[col13 + k * 1]); // 20220912 MaxR

      // col15  user input
      if Aiip = True then
        Tv[col15 + k * 1] := MaxR(0, Tv[col14 + k * 1])
      else
        Tv[col15 + k * 1] := 0;

      // col16
      Tv[col16 + k * 1] := MaxR(0, Tv[col10 + k * 16] - Tv[col13 + k * 1]);

      // col17
      if Aiip = True then
        Tv[col17 + k * 1] := MaxR(0, Tv[col8 + k * 16] - Tv[col9 + k * 1] +
          Tv[col6 + k * 1] - Tv[col14 + k * 1] + Tv[col15 + k * 1] -
          Tv[col7 + k * 1]) // ? 54 and 56?
      else
        Tv[col17 + k * 1] := 0;

      // col18
      if Aiip = True then
        Tv[col18 + k * 1] := MaxR(0, Tv[col15 + k * 1] - Tv[col17 + k * 1])
        // ? 54 and 56?
      else
        Tv[col18 + k * 1] := 0;

      if Cls = '' then
      begin
        Aiipfactor := '';
        Strings[343 + k * 1] := ''; // aiip factor
      end;

      // col19
      Tv[col19 + k * 1] := Tv[col18 + k * 1] * Vl(Strings[343 + k * 1]);
      // //? 54 and 56?

      // col20
      Tv[col20 + k * 1] := MaxR(0, Tv[col14 + k * 1] - Tv[col15 + k * 1] -
        Tv[col6 + k * 1] - Tv[col18 + k * 1]); // ? 54 and 56?

      // col21
      Strings[col21 + k * 16] := Rate;

      // col22 recapture
      Tv[col22 + k * 16] := 0;
      if Tv[col10 + k * 16] < 0 then
        Tv[col22 + k * 16] := ABS(Tv[col10 + k * 16]);
      Tv[230] := Tv[230] + Tv[col22 + k * 16];

      // col23 Terminal loss and total
      Tv[col23 + k * 16] := 0;
      if (UpperCase(Strings[16 + k * 16]) = 'Y') and (Tv[col10 + k * 16] > 0)
      then
        Tv[col23 + k * 16] := Tv[col10 + k * 16];
      Tv[231] := Tv[231] + Tv[col23 + k * 16];

      // col23 CCA
      If (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        Rate := '100'; // fast write off //20220802

      If (Tv[col22 + k * 16] = 0) and (Tv[col23 + k * 16] = 0) then
      begin
        if UpperCase(Strings[14 + k * 16]) <> 'Y' then // no override);
           Tv[col24 + k * 16] := (Tv[col16 + k * 1] + Tv[col19 + k * 1] -
          //Tv[col23 + k * 16] := (Tv[col16 + k * 1] + Tv[col19 + k * 1] -
            Tv[col20 + k * 1]) * Vl(Rate) / 100 + Tv[col13 + k * 1];

        //proration -new in 20230320---------
        CCA:=Tv[col24 + k * 16];
        {
        //GetT5013YearEndYYYY(RetNo
        if (IsLeapYear(GetT5013YearEndYYYY(RetNo))
        and (GetT5013YearEndYYYY(RetNo) > '2020'))
        then
          CCA := CCA * Ret[RetNo].DaysInYear / 366
        Else
          CCA := CCA * Ret[RetNo].DaysInYear / 365;
        }
        Tv[col24 + k * 16]:=CCA;
        //proration ---------

      end
      Else
        Tv[col24 + k * 16] := 0; // if recapture or term loss then CCA =0
      Tv[232] := Tv[232] + Tv[col24 + k * 16];

      //col25
      if UpperCase(Strings[16 + k * 16]) = 'Y' // term loss
      then
      Begin
        //20230322
        Tv[col25 + k * 16] := 0; // no UCC end eny more
        Tv[col23 + k * 16]:=Tv[col24 + k* 16];
        Tv[col24 + k * 16]:=0; //no cca
      end
      Else
        Tv[col25 + k* 16] := MaxR(0, Tv[col10 + k * 16] - Tv[col24 + k * 16]);
       Tv[251] := Tv[251] + Tv[col25 + k * 16];

      (* check and apply OUTSTANDING LOGIC
        Tv[col16 + k * 1] := ProceedsAiip; // UccAdjustmentNONAiip;
        Tv[col17 + k * 1] := NetCapCostAdditionsAiip;
        Strings[343 + k * 1] := Aiipfactor;
        if Cls = '' then
        Strings[343 + k * 1] := '';

        Tv[col18 + k * 1] := UccAdjustmentAiip;
        If Cls > '' then
        Tv[col19 + k * 1] := UccAdjustmentNONAiip; // 20190622

        // cca calcs
        if UCCReduced < 0 then
        begin
        CCA := 0;
        TerminalLoss := 0;
        Recapture := ABS(UCCReduced);
        if Cls = '10.1' then
        Recapture := 0;
        end
        else // positive ucc = CCA or Terminal loss upon disposal
        begin
        TerminalLoss := 0;
        Recapture := 0;

        // 20190313
        if Aiip then
        CCA := Round((UCCReduced + UccAdjustmentAiip - UccAdjustmentNONAiip) *
        Vl(Rate) / 100)
        else
        CCA := Round(UCCReduced * Vl(Rate) / 100);

        if (LeaseHold(Cls)) and (Aiip = false) then // 20190613
        CCA := MinR(UCCReduced, LeaseMaxCca);

        if (LeaseHold(Cls)) then
        Begin
        If (LeftStr(LeaseStart, 4) = LeftStr(GetBegYearEnd(RetNo), 4)) then
        CCA := Round(CCA / 2); // 20190705
        end;

        If (LeaseHold(Cls)) Then // 20190725
        Begin
        If (Aiip = True) and
        (LeftStr(LeaseStart, 4) = LeftStr(GetBegYearEnd(RetNo), 4)) and
        (AdditionsAiip > 0) then
        CCA := CCA * 3; // first year  //20190725
        end;

        if (Cls = '24') or (Cls = '27') or (Cls = '29') or (Cls = '34') then
        CCA := UCCReduced; // fast wrire offs 20190609
        if (Cls = '12') then
        CCA := UCCReduced; // 20210623

        // 20210726
        if (IsLeapYear(GetTaxationYearEndYYYY(RetNo)) and
        (GetTaxationYearend(RetNo) > '2020/02/28')) then
        CCA := CCA * Ret[RetNo].DaysInYear / 366
        Else
        CCA := CCA * Ret[RetNo].DaysInYear / 365;

        if (Cls = '12') or (Cls = '24') or (Cls = '27') or (Cls = '29') or
        (Cls = '34') then
        CCA := UCCReduced; // fast wrire offs 20210623

        if OverrideIndic = 'Y' then
        CCA := Tv[col23 + k * 16];

        if TermLossIndic = 'Y' then
        Begin
        TerminalLoss := UCCReduced + UccAdjustmentNONAiip;
        // 20190626    //TerminalLoss:=UccReduced;
        Tv[col22 + k * 16] := TerminalLoss;
        Recapture := 0;
        Tv[col21 + k * 16] := 0;
        CCA := 0;
        UCCEnd := 0;
        End;

        UCCEnd := MaxR(0, UCCReduced - CCA);

        if Aiip = false then
        UCCEnd := MaxR(0, UCCReduced - CCA + HalfRuleAmount) // 20190622
        Else // Aiip is true
        Begin
        UCCEnd := MaxR(0, UCCReduced - CCA);
        // 20220618//+UCCAdjustmentNONAIIp-UCCAdjustmentAIIp);  //20190707
        end;
        end;
        if (Cls = '10.1') then
        begin
        TerminalLoss := 0;
        Recapture := 0;
        end; // 20190607

        if (Cls = '10.1') and (Proceeds > 0) and (OverrideIndic <> 'Y')
        // 20220619
        then
        begin
        CCA := Round(CCA / 2);
        UCCEnd := 0;
        end;

        // 20190626
        if (Recapture > 0) or (TerminalLoss > 0) then
        UCCEnd := 0;

        Tv[col23 + k * 16] := CCA;
        Tv[col24 + k * 16] := UCCEnd;
        Tv[col21 + k * 16] := Recapture;
        Tv[col22 + k * 16] := TerminalLoss;

        // add to totals //20190614
        Tv[249] := Tv[249] + UccStart;
        Tv[234] := Tv[234] + Additions;
        Tv[250] := Tv[250] + Adjustments;
        Tv[235] := Tv[235] + Proceeds;

        Tv[230] := Tv[230] + Recapture;
        Tv[231] := Tv[231] + TerminalLoss;
        Tv[232] := Tv[232] + CCA;
        Tv[251] := Tv[251] + UCCEnd;
      *)
    End; // k 0 to 12  //k is the wow bing processed starts from k=0
  End; // with?
  SaveTv(RetNo, FName, FNo);
end;



Procedure CreateNewT5013Slips(RetNo:Integer); //create any new slips and enter ParterId on them
Var i,k,SlipFNo,T5013FNo:Integer; PartnerId,FInst:String;
Begin
  //ClearAllT5013Slips(RetNo);  //20260903
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If LeftStr(Frec.FormName,6) = 'T5013#' then
   Begin
     k := MyStrToInt(FetchElmFNo(RetNo,Frec.FormNo,10));  //10 is Partner No  1 to  ...
     if k=0 then k:=1;  //20230326 OTHERWISE it uses 0

     Finst:='#'+IntToStr(k);
     SlipFNo:=GetFormNo('T5013'+FInst);
     If SlipFNo=0 then  {slip does not exist}
     begin
      AddPageInstance(RetNo,'T5013','#'+IntToStr(k));
      SlipFno := GetFormNo('T5013'+'#'+IntToStr(k)); {get it again}
      Ret[retNo].FrmHasData[SlipFNo]:=True;  //assuming the RepId has been stored in the T5013form
     end
     Else
     begin
      RemoveAllT5013SlipData(RetNo);  //20260903
      Ret[retNo].FrmHasData[SlipFNo]:=False;  //assuming the RepId has been stored in the T5013form
     //Ret[retNo].FrmHasData[SlipFNo]:=True; //20260903 //assuming the RepId has been stored in the T5013form
     end;

    {
     If SlipFNo > 0 then
      Ret[RetNo].FrmHasData[SlipFNo] := True
     Else
      Ret[RetNo].FrmHasData[SlipFNo]:=False;
     }
   end;
  end;
  //SaveTv(RetNo,FName,FNo); //  DO NOT SAVE it? //20260903
(*
  //add the PartberId to each existing T5013 created
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If LeftStr(Frec.FormName,4) = 'PS50' then
   Begin
    FInst:=ExtractFormInst(Frec.FormName);
    PartnerId:='XXXXXXXXXXX'; //x'FetchElm(RetNo,Frec.FormName,13);  //it could be SIN, Corp BN Ot Trsust Account
    T5013FNo:=GetT5013FNoFromPartnerId(RetNo,PartnerId);
    StoreElm(RetNo,T5013FNo,14,PartnerId);  //store the Part id as it is on the PS50 form
    Ret[RetNo].FrmHasData[T5013FNo] := True;
   end;
  end;
  ShowMessage('T5013 Paertnerid 1= '+ FetchElm(RetNo,'T5013#1',14)); //20
  ShowMessage('T5013 Paertnerid 2= '+ FetchElm(RetNo,'T5013#2',14)); //20
  ShowMessage('T5013 Paertnerid 3= '+ FetchElm(RetNo,'T5013#3',14)); //20
  ShowMessage('T5013 Paertnerid 4= '+ FetchElm(RetNo,'T5013#4',14)); //20
*)
End;

//20260908 //create list with the PS50 Partnerid and Ps50 Form numer
Procedure UpdateT5013PartnersList(RetNo:Integer);
Var j:Integer;
Begin
 //T5013PartnersList.free:
 T5013PartnersList:=TstringList.create;
 for j :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[j];
  If LeftStr(Frec.FormName,5)='PS50#' then
    T5013PartnersList.Add(FetchElm(RetNo,Frec.FormName,13)+','+IntToStr(Frec.FormNo));
 End;
end;

Procedure DeleteT5013Slips(RetNo:Integer); //create any new slips and enter ParterId on them
Var i:Integer;
Begin
 //Purpose: Delete them by faving no data, NO ParterId on o
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If LeftStr(Frec.FormName,6) = 'T5013#' then
  begin
   Ret[RetNo].FrmHasData[Frec.FormNo]:=false; //20260905
   CreateNewT5013Slips(RetNo);
   T5013(RetNo,Frec.FormName,Frec.FormNo);   //20260806
   //StoreElm(RetNo,Frec.FormName,14, ' ');  //delete the slip.Remove the PartnerId for it
  end;
 end;
end;


(* //20260908
Procedure DeleteT5013Slips(RetNo:Integer); //create any new slips and enter ParterId on them
Var i:Integer;
Begin
 //Purpose: Delete them by faving no data, NO ParterId on o
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If LeftStr(Frec.FormName,6) = 'T5013#' then
  begin
   Ret[RetNo].FrmHasData[Frec.FormNo]:=false; //20260905
   CreateNewT5013Slips(RetNo);
   T5013(RetNo,Frec.FormName,Frec.FormNo);   //20260806
   //StoreElm(RetNo,Frec.FormName,14, ' ');  //delete the slip.Remove the PartnerId for it
  end;
 end;
end;
*)


(*
//20260903
Procedure RevisePartnerIdOfSlips(RetNo:Integer); //create any new slips and enter ParterId on them
Var i,j,k,SlipFNo,T5013FNo:Integer; PartnerId,FInst:String;
PS50FormNumbers:TstringList;
PartnerIdList:TStringList;
T5013FormNo:Integer;
Begin
  //Purpose: all T5013 slip must have the same ParterId
  //in both PS50 forms and T513 forms
  // get a list of PS50 ForNumbers and corresponding ParterId
  PS50FormNumbers:=Tstringlist.create;
  PartnerIdList:=TStringList.create;
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If LeftStr(Frec.FormName,5) = 'PS50#' then
   begin
     PS50FormNumbers.Add(IntToStr(Frec.FormNo));
     PartnerId:=FetchElmFNo(RetNo,Frec.FormNo,14);
     PartnerIdList.Add(PartnerId);
   end;
  end;

  k:=GetNumberOfPartnersFromPs50(RetNo);  //how many in PS50 forms
  // now enter the PartnrId into the T5013 slip
  for j:= 1 to k do
  Begin
      T5013FormNo:=GetFormNo('T5013'+'#'+IntToStr(j));
      if T5013FormNo>0 then PartnerId:=FetchElm(RetNo,'PS50'+'#'+IntToStr(j),13);
      If PartnerId>'' then StoreElm(RetNo,Frec.FormNo,14,PartnerId);
      ShowMessage('T5013 stored Partnerid '+PartnerId);
  end;   //j
End;
*)
(*
Function  GetT5013FNoFromPartnerId(RetNo:integer;PartnerId:String):Integer;
Var i: Integer;
begin

  Result:=0;
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If LeftStr(Frec.FormName,4) = 'T5013' then
   Begin
    If PartnerId=FetchElmFNo(RetNo,Frec.FormNo,13) then //Partner Id in the t5013
      Result:=Frec.FormNo;
   end;
  end;
End;
*)


Procedure PrepareallT5013Slips(RetNo:Integer);
begin
  //20260907Night
 if GetNumberOfPartnersFromPS50(RetNo)=0 then
 Begin
  ShowMessage('There are no Partners defined in form PS50');
  Exit;
 End;

 PrepareAllT5013Slips(RetNo:Integer);
 UpdateT5013PartnersList(RetNo:Integer);
 DeleteT5013Slips(RetNo:Integer); //create any new slips and enter ParterId on them
 CreateNewT5013Slips(RetNo:Integer); //create any new slips and enter ParterId on them
 RemoveAllT5013SlipData(RetNo:Integer);  //20260908CZ
end;


Procedure T5013(RetNo: integer; FName: String;FNo: integer); {slip}
Const Fmt='##########.##';
Var i,ii,j,k,SlipFNo,FromFNo, WsFNo:Integer;
FInst,s,s1,BoxNumber,TypeOfPartner,SlipForm,PartnerCode:String;
GrossUp,Percent,CreditPercent,AtRiskAmt,AtRiskAmtAdjusted,ActualNonEligDividends,ActualEligDividends:Real;
PartnerIdInT5013,PartnerIdInPS50 :String;
AllLimitedPartnersIncome, AllGeneralPartnersIncome: Real; //20260911

begin
(*
  //20260907Night
 if GetNumberOfPartnersFromPS50(RetNo)=0 then
 Begin
  ShowMessage('There are no Partners defined in form PS50');
  Exit;
 End;

 if GetFormNo('T5013#1')=0 then
 Begin
  DeleteT5013Slips(RetNo);
  CreateNewT5013Slips(RetNo);
  RemoveAllT5013slipData(RetNo,SlipFNo);
 // RevisePartnerIdOfSlips(RetNo);
  ShowMessage('Try again to Open the T5013 form');
  Exit;
 End
 Else
 Begin  //there is slip
  SlipFNo:=GetFormNo('T5013#1');
  PartnerIdInT5013:=FetchElmFNo(RetNo,SlipFNo,14); //get PartnerId from T5013
  PartnerIdInPs50:=FetchElm(RetNo,'PS50#1'+FInst,13); //get PartnerId from PS50
  If PartnerIdInT5013 <> PartnerIdInPS50 then
  Begin
   StoreElm(RetNo,SlipFNo,14,PartnerIdInPs50);
  End;
 End;
*)
 FNo:=SlipFNo;
 Fname:='T5013#1';

 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  if strings[29]+Strings[30]='' then Strings[29]:='X'; // based on % //20260904
 (*
  SlipForm:='T5013';   //not sliptype //20260903
  WsFNo:=GetFormNo('T5013WS');
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec.FormName = 'PS50' then
   Begin
     k := MyStrToInt(FetchElmFNo(RetNo,Frec.FormNo,10));  //10 is Partner No  1 to  ...
     if k=0 then k:=1;  //20230326 OTHERWISE it uses 0

     SlipFNo:=GetFormNo(SlipForm+'#'+IntToStr(k));   //20260903
     If SlipFNo=0 then  {slip does not exist }
     begin  //20260903
      AddPageInstance(RetNo,SlipForm,'#'+IntToStr(k));
      SlipFno := GetFormNo(SlipForm+'#'+IntToStr(k)); {get it again}
     end;

     If SlipFNo > 0 then
     begin
      Ret[RetNo].FrmHasData[SlipFNo] := True;
     end;
   end;
 //end;
// End;
// SaveTv(RetNo,FName,FNo); //  DO NOT SAVE it? //20260901
// end;  //???? 20260830
  // SaveTv(RetNo,FName,FNo); //  DO NOT SAVE it? //20260830  end;
 *)

 with Ret[RetNo].Frm[FNo] do
 Begin
     //frm PS50
     //FromFNo:=GetFormNo('PS50#'+AllTrim(IntToStr(k)));
     Finst:=ExtractFormInst(FName);  //20260904
     if Finst='' then FInst:='#1';  //20260904
     //=================================================
     FromFNo:=GetFormNo('PS50'+Finst); // AllTrim(IntToStr(k)));
     //------------------
     TypeOfPartner:=FetchElmFNo(RetNo,FromFNo,14);
     Strings[10]:=FetchElmFNo(RetNo,FromFNo,24); {country code}
     If Strings[10]='' then Strings[10]:='CAN';
     Strings[11]:=FetchElmFNo(RetNo,FromFNo,15); //member code 0=limited, 2-General
     ss:=Strings[11];
     AllLimitedPartnersIncome::=Vl(FetchElm(RetMo,'PS1',41)); //PS1 box 503];

     if Strings[11]='0' then  //limited parter
     Begin
      Strings[32]:='105';
      Tv[34]:=AllLimitedPartnersIncome * Tv[13]/100;
      Strings[35]:='105';
      Tv[37]:=AllLimitedPartnersIncome * Tv[13]/100;  //??
      Strings[32]:='105';
      Tv[34]:=AllLimitedPartnersIncome * Tv[13]/100;  //??
     End;
     {//20260911
      //20260904  At risk
     if Strings[11]='0' then  //limited parter
     Begin
      AtRiskAmt:=Vl(FetchElmFNo(RetNo,FromFNo,38));
      AtRiskAmtAdjusted:=Vl(FetchElmFNo(RetNo,FromFNo,39));
      TV[82]:=AtRiskAmt;
      Tv[83]:=AtRiskAmtAdjusted;
      Strings[62]:='105';
      Tv[64]:=AtRiskAmt;
      Strings[65]:='106';
      Tv[67]:=AtRiskAmtAdjusted;
     End
     Else
     Begin   //20260908CZ
      AtRiskAmt:=0;
      AtRiskAmtAdjusted:=0;
      Strings[62]:='';
      Strings[65]:='';
      TV[82]:=0;
      Tv[83]:=0;
      Strings[65]:='';
      Strings[67]:='';
     end;
     }

     //Recipient type  //20260906
     s:=FetchElmFNo(RetNo,FromFNo,14);
     S1:='';
     if (s='1') or (S='5')  then S1:='1';  //individual
     if (s='2') or (S='6')  then S1:='3';  //If Corp then '3'
     if (s='4') or (s='8') or (s='9') then S1:='4';  //Trust or partnersip
     if (s='3') or (s='7') then S1:='4';  //Trust or partnersip
     Strings[28]:=S1;//FetchElmFNo(RetNo,FromFNo,14)); //Recipient type //20210326
     ss:=Strings[28];
     //If FetchElm(RetNo,SlipFNo,11)='4' then StoreElm(RetNo,SlipFNo,28,''); //Recipient type //20210326
   //  StoreElm(RetNo,SlipFNo,12,FetchElmFNo(RetNo,FromFNo,61)); {units held}    ???
     Strings[13]:=FetchElmFNo(RetNo,FromFNo,16); {%}
     Strings[14]:=FetchElmFNo(RetNo,FromFNo,13); {rPartner id  //20260903//} // 13 is the id
    // Strings[204]:=F*etchElmFNo(RetNo,FromFNo,14); {type}  //???

     //recipient address      //slipfno is ps50
     Strings[15]:=FetchElmFNo(RetNo,FromFNo,11); //last name
     Strings[80]:=FetchElmFNo(RetNo,FromFNo,30); //first name
     Strings[81]:=FetchElmFNo(RetNo,FromFNo,34); //initials
     Strings[17]:=FetchElmFNo(RetNo,FromFNo,20); //street
     Strings[18]:=FetchElmFNo(RetNo,FromFNo,21); //city
     Strings[19]:=FetchElmFNo(RetNo,FromFNo,22); //prov
     Strings[20]:=FetchElmFNo(RetNo,FromFNo,23); //postal

     //============================
     FromFNo:=GetFormNo('T5013FIN');
     Strings[2]:=FetchElmFNo(RetNo,FromFNo,39); //Y/e
    // Strings[3]:=MidStr(FetchElmFNo(RetNo,FromFNo,39),6,2); {mm}  //what is this? //20260906
     Strings[4]:=FetchElmFNo(RetNo,FromFNo,1); {filer no}
     Strings[5]:='TS'+FetchElmFNo(RetNo,FromFNo,62); {tax shelter no}
     //20100326
     //Strings[6]:=FetchElmFNo(RetNo,FromFNo,119); {publicly}  //Yes or NO? //20260906
     //If Strings[8]='' then Strings[8]:='0';  //type of slip  //???         //20260906
     //Strings[9]:=''; //partnship code - blank by specs //20260906
    //?? HOW StoreElm(RetNo,SlipFNo,194,FetchElmFNo(RetNo,FromFNo,61)); //num units //20260906
    //partnership info
     Strings[21]:=FetchElmFNo(RetNo,FromFNo,7); {p name}
     Strings[23]:=FetchElmFNo(RetNo,FromFNo,13); {p str}
     Strings[24]:=FetchElmFNo(RetNo,FromFNo,15); {p city}
     Strings[26]:=FetchElmFNo(RetNo,FromFNo,16); {p prov}  //20260830
     Strings[25]:=FetchElmFNo(RetNo,FromFNo,18); {p postal}
    // Strings[26]:=FetchElmFNo(RetNo,FromFNo,17); {p country}
     //Strings[27]:=FetchElmFNo(RetNo,FromFNo,18); //postal zip
      //================================
     If FetchElmFNo(RetNo,SlipFNo,29) >'' then  //based on partners interest
     Begin
      For j:=32 to 67 do begin StoreElm(RetNo,SlipFNo,j,'');end;  //initialize boxes/amounts

      (*
      //20260908
      If AtRiskAmt>0  then //at risk //20260908
      Begin
       Strings[62]:='105'; //StoreElm(RetNo,SlipFNo,82,'105'); //20260908
       Tv[64]:=AtRiskAmt; //StoreElm(RetNo,SlipFNo,84,FormatFloat('#########.##',AtRiskAmt)); {at risk}
       //xx:=Vl(FetchElm(RetNo,SlipFNo,34));
      end;
      //20260825cz
      If AtRiskAmtadjusted>0  then //at risk  adjusted 1ode 106
      Begin
       Strings[65]:='106'; //StoreElm(RetNo,SlipFNo,83,'106');
       Tv[67]:=AtRiskAmtAdjusted; //StoreElm(RetNo,SlipFNo,40,FormatFloat('#########.##',AtRiskAmtAdjusted));
       //xx:=Vl(FetchElm(RetNo,SlipFNo,34));
      end;
      *)

      //================================
      WsFNo:=GetFormNo('T5013WS');  //2026009006
      //20260830
      Percent:=Vl(FetchElmFNo(RetNo,SlipFNo,13))/100;
      Tv[7]:=Vl(FetchElmFNo(RetNo,WsFNo,4)) * Percent; //StoreElm(RetNo,SlipFNo,7,FormatFloat('#########.##',Vl(FetchElmFNo(RetNo,WsFNo,4))* Percent));  //bx 10
      if Strings[11]='2'   then  //generalpartner
       Tv[9]:=Vl(FetchElm(RetNo,'PS1',155)); // ??? ise %?
    //  Tv[9]:=Vl(FetchElmFNo(RetNo,WsFNo,26))* Percent; //bx 20


      Tv[12]:=Vl(FetchElmFNo(RetNo,WsFNo,120))* Percent; //bx 30
      Tv[27]:=Vl(FetchElmFNo(RetNo,WsFNo,166))* Percent; //bx 40

      //Get Other amounts from t5013ws
      j:=4; //amount index to t53ws
      Repeat
       If (j<>4) and (j<>26) and (j<>120) and (j<>166)
       then  //codes 010,020,030,040 already done above
       Begin
        If Vl(FetchElmFNo(RetNo,WsFNo,j))<>0 then
        begin
         k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
         If (k>0) and (k<68) then  //low and upper elms of slip boxes
         begin
           Tv[k]:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;   //amount of ws j  to amount of t5013 slip k index
           Strings[k-1]:=FetchElmFNo(RetNo,WsFNo,j-1);
           BoxNumber:=GetTheBoxNoOfT5013Ws(PaddZero(IntToStr(j),3));
           Strings[k-2]:=BoxNumber;//StoreElm(RetNo,SlipFNo,k-2,BoxNumber);
           If BoxNumber='129' then ActualNonEligDividends:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;
           If BoxNumber='132' then ActualEligDividends:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;
         end;
        end;
       end;
       Inc(j,2);
      until j>246; //12; //j>240;  //20230326
     end;
     //20140615
     //Now add taxable dividends and Dividend tax credit if not Corp partner
     GrossUp:=1.25;
     CreditPercent:=13.3333;
     If LeftStr(FetchElm(RetNo,'T5013FIN',39),4)>'2013' then
     begin
        Grossup:=1.18;
        CreditPercent:=11.0169;
     end;

     If (ActualNonEligDividends>0)
     and ((TypeofPartner ='1') or (TypeofPartner ='3') Or (TypeofPartner ='4')) then //box 129
     begin
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualNonEligDividends * GrossUp;
         Strings[k-2]:='130';  //taxable
       end;
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualNonEligDividends * GrossUp * CreditPercent/100;
         Strings[K-2]:='131';  //taxable
       end;
     end;

     If (ActualEligDividends>0)
     and ((TypeofPartner ='1') or (TypeofPartner ='3') Or (TypeofPartner ='4')) then //box 129
     begin
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualEligDividends * 1.38;
         Strings[k-2]:='133';  //taxable
       end;
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualEligDividends * 1.38 * 15.0198/100;
         Strings[k-2]:='134';  //taxable
       end;
     end;

     //201160209
     j:=32;
     Repeat
      If Tv[j]=0 then Strings[j+2]:=''; //StoreElm(RetNo,SlipFNo,j+2,'');  //20160209
      //If Vl(FetchElmFNo(RetNo,SlipFNo,j))=0 then StoreElm(RetNo,SlipFNo,j+2,'');  //20160209
      Inc(j,3);
     until j>41;

      //20260827 Alex >>>
      if (FetchElmFNo(RetNo, SlipFNo, 30) > '') then
      begin
        //20231019  fix what belongs to limited partnercode=0 vs GeneralPartnerCode=2
        j:=32;
        Repeat
          If IsLimitedPartner(RetNo,PartnerCode)=false then
          Begin
            If (Strings[j]='104') or (Strings[j]='105') or (Strings[j]='106') then
            begin
              Strings[j]:='';  //20160209
              Strings[j+1]:='';  //20160209
              Strings[J+2]:='';  //20160209
            end;
          end;
          Inc(j,3);
        until j>77;
      end;
      //20260827 Alex <<<
  //  end;
  //end; //i
 end;  //20260830
 SaveTv(RetNo,FName,FNo);
 end;
end;

end.

(*
//20260831
Procedure T5013(RetNo: integer; FName: String;FNo: integer); {slip}
Const Fmt='##########.##';
Var i,ii,j,k,SlipFNo,FromFNo, WsFNo:Integer;
SlipType:String;
begin
 SlipFNo:=FNo;   //20260830
 //FInst:='1';
 LoadTv(RetNo,FName,FNo);
 with Ret[RetNo].Frm[FNo] do
 Begin
  SlipType:='T5013';
  WsFNo:=GetFormNo('T5013WS');
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec.FormName = 'PS50' then
   Begin
     k := MyStrToInt(FetchElmFNo(RetNo,Frec.FormNo,10));  //10 is Partner No  1 to  ...
     if k=0 then k:=1;  //20230326 OTHERWISE it uses 0

     SlipFNo:=GetFormNo(SlipType+'#'+IntToStr(k));
     If SlipFNo=0 then  {slip does not exist}
     begin
      AddPageInstance(RetNo,SlipType,'#'+IntToStr(k));
      SlipFno := GetFormNo(SlipType+'#'+IntToStr(k)); {get it again}
     end;

     If SlipFNo > 0 then
     begin
      Ret[RetNo].FrmHasData[SlipFNo] := True;
     end;
   end;
  end;
 End;
 SaveTv(RetNo,FName,FNo); //  DO NOT SAVE it? //20260901
 end;  //???? 20260830
  // SaveTv(RetNo,FName,FNo); //  DO NOT SAVE it? //20260830  end;

    (*
     FromFNo:=GetFormNo('T5013FIN');
     Strings[2]:=FetchElmFNo(RetNo,FromFNo,39); //Y/e
     Strings[3]:=MidStr(FetchElmFNo(RetNo,FromFNo,39),6,2); {mm}
     Strings[4]:=FetchElmFNo(RetNo,FromFNo,1); {filer no}
     Strings[5]:='TS'+FetchElmFNo(RetNo,FromFNo,62); {tax shelter no}
     //20100326
     Strings[6]:=FetchElmFNo(RetNo,FromFNo,119); {publicly}  //Yes or NO?
     If Strings[8]='' then Strings[8]:='0';  //type of slip
     Strings[9]:=''; //partnship code - blank by specs
     //  --------------------------
     FromFNo:=GetFormNo('PS50#'+AllTrim(IntToStr(k)));
     TypeOfPartner:=FetchElmFNo(RetNo,FromFNo,14);
     Strings[10]:=FetchElmFNo(RetNo,FromFNo,24); {country code}
     If Strings[10]='' then Strings[10]:='CAN';
     Strings[11]:=FetchElmFNo(RetNo,FromFNo,15); {member code}
     //Recipoient type
     s:=FetchElmFNo(RetNo,FromFNo,14);
     S1:='';
     if s='1'  then S1:='1';  //individual
     if s='2'  then S1:='3';  //If Corp then '3'
     if s='3'  then S1:='3';  //If Corp then '3'
     if s='4'  then S1:='4';  //If Corp then '3'
     Strings[28]:=S1;//FetchElmFNo(RetNo,FromFNo,14)); //Recipient type //20210326
     //If FetchElm(RetNo,SlipFNo,11)='4' then StoreElm(RetNo,SlipFNo,28,''); //Recipient type //20210326
   //  StoreElm(RetNo,SlipFNo,12,FetchElmFNo(RetNo,FromFNo,61)); {units held}    ???
     Strings[13]:=FetchElmFNo(RetNo,FromFNo,16); {%}
     Strings[14]:=FetchElmFNo(RetNo,FromFNo,13); {recipient id  ????}
     Strings[204]:=FetchElmFNo(RetNo,FromFNo,14); {type}

     //recipient address      //slipfno is ps50
     Strings[15]:=FetchElmFNo(RetNo,FromFNo,11); //last name
     Strings[80]:=FetchElmFNo(RetNo,FromFNo,30); //first name
     Strings[81]:=FetchElmFNo(RetNo,FromFNo,34); //initials
     Strings[17]:=FetchElmFNo(RetNo,FromFNo,20); //street
     Strings[18]:=FetchElmFNo(RetNo,FromFNo,21); //city
     Strings[19]:=FetchElmFNo(RetNo,FromFNo,22); //prov
     Strings[20]:=FetchElmFNo(RetNo,FromFNo,23); //postal

     //AtRiskAmt:=Vl(FetchElmFNo(RetNo,FromFNo,31));
     AtRiskAmt:=Tv[38];
     AtRiskAmtAdjusted:=Tv[39];
     //-----------------------------------------------------
    //?? HOW StoreElm(RetNo,SlipFNo,194,FetchElmFNo(RetNo,FromFNo,61)); //num units //20131230
    //partnership info
     FromFNo:=GetFormNo('T5013FIN');
     Strings[21]:=FetchElmFNo(RetNo,FromFNo,7); {p name}
     Strings[23]:=FetchElmFNo(RetNo,FromFNo,13); {p str}
     Strings[24]:=FetchElmFNo(RetNo,FromFNo,15); {p city}
     Strings[26]:=FetchElmFNo(RetNo,FromFNo,16); {p prov}  //20260830
     Strings[25]:=FetchElmFNo(RetNo,FromFNo,18); {p postal}
    // Strings[26]:=FetchElmFNo(RetNo,FromFNo,17); {p country}
     //Strings[27]:=FetchElmFNo(RetNo,FromFNo,18); //postal zip


      //================================
     (*
     // AT risk  Put it back
     If FetchElmFNo(RetNo,SlipFNo,29) >'' then  //based on partners interest
     Begin
      For j:=32 to 67 do begin StoreElm(RetNo,SlipFNo,j,'');end;  //initialize boxes/amounts
      If AtRiskAmt>0  then //at risk
      Begin
       StoreElm(RetNo,SlipFNo,82,'105');
       StoreElm(RetNo,SlipFNo,84,FormatFloat('#########.##',AtRiskAmt)); {at risk}
       xx:=Vl(FetchElm(RetNo,SlipFNo,34));
      end;
      //20260825cz
      If AtRiskAmtadjusted>0  then //at risk  adjusted 1ode 106
      Begin
       StoreElm(RetNo,SlipFNo,83,'106');
       StoreElm(RetNo,SlipFNo,40,FormatFloat('#########.##',AtRiskAmtAdjusted));
       xx:=Vl(FetchElm(RetNo,SlipFNo,34));
      end;

      //================================
      //20260830
      Percent:=Vl(FetchElmFNo(RetNo,SlipFNo,13))/100;
      Tv[7]:=Vl(FetchElmFNo(RetNo,WsFNo,4)) * Percent; //StoreElm(RetNo,SlipFNo,7,FormatFloat('#########.##',Vl(FetchElmFNo(RetNo,WsFNo,4))* Percent));  //bx 10
      Tv[9]:=Vl(FetchElmFNo(RetNo,WsFNo,26))* Percent; //bx 20
      Tv[12]:=Vl(FetchElmFNo(RetNo,WsFNo,120))* Percent; //bx 30
      Tv[27]:=Vl(FetchElmFNo(RetNo,WsFNo,166))* Percent; //bx 40

      //Get Other amounts from t5013ws
      j:=4; //amount index to t53ws
      Repeat
       If (j<>4) and (j<>26) and (j<>120) and (j<>166)
       then  //codes 010,020,030,040 already done above
       Begin
        If Vl(FetchElmFNo(RetNo,WsFNo,j))<>0 then
        begin
         k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
         If (k>0) and (k<68) then  //low and upper elms of slip boxes
         begin
           Tv[k]:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;   //amount of ws j  to amount of t5013 slip k index
           Strings[k-1]:=FetchElmFNo(RetNo,WsFNo,j-1);
           BoxNumber:=GetTheBoxNoOfT5013Ws(PaddZero(IntToStr(j),3));
           Strings[k-2]:=BoxNumber;//StoreElm(RetNo,SlipFNo,k-2,BoxNumber);
           If BoxNumber='129' then ActualNonEligDividends:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;
           If BoxNumber='132' then ActualEligDividends:=Vl(FetchElmFNo(RetNo,WsFNo,j))* Percent;
         end;
        end;
       end;
       Inc(j,2);
      until j>246; //12; //j>240;  //20230326
     end;
     //20140615
     //Now add taxable dividends and Dividend tax credit if not Corp partner
     GrossUp:=1.25;
     CreditPercent:=13.3333;
     If LeftStr(FetchElm(RetNo,'T5013FIN',39),4)>'2013' then
     begin
        Grossup:=1.18;
        CreditPercent:=11.0169;
     end;

     If (ActualNonEligDividends>0)
     and ((TypeofPartner ='1') or (TypeofPartner ='3') Or (TypeofPartner ='4')) then //box 129
     begin
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualNonEligDividends * GrossUp;
         Strings[k-2]:='130';  //taxable
       end;
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualNonEligDividends * GrossUp * CreditPercent/100;
         Strings[K-2]:='131';  //taxable
       end;
     end;

     If (ActualEligDividends>0)
     and ((TypeofPartner ='1') or (TypeofPartner ='3') Or (TypeofPartner ='4')) then //box 129
     begin
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualEligDividends * 1.38;
         Strings[k-2]:='133';  //taxable
       end;
       k:=FindEmptyBoxInT5013(RetNo,SlipFNo);
       If (k>0) and (k<68) then  //low and upper elms of slip boxes
       begin
         Tv[k]:=ActualEligDividends * 1.38 * 15.0198/100;
         Strings[k-2]:='134';  //taxable
       end;
     end;

     //201160209
     j:=32;
     Repeat
      If Tv[j]=0 then Strings[j+2]:=''; //StoreElm(RetNo,SlipFNo,j+2,'');  //20160209
      //If Vl(FetchElmFNo(RetNo,SlipFNo,j))=0 then StoreElm(RetNo,SlipFNo,j+2,'');  //20160209
      Inc(j,3);
     until j>41;

      //20260827 Alex >>>
      if (FetchElmFNo(RetNo, SlipFNo, 30) > '') then
      begin
        //20231019  fix what belongs to limited partnercode=0 vs GeneralPartnerCode=2
        j:=32;
        Repeat
          If IsLimitedPartner(RetNo,PartnerCode)=false then
          Begin
            If (Strings[j]='104') or (Strings[j]='105') or (Strings[j]='106') then
            begin
              Strings[j]:='';  //20160209
              Strings[j+1]:='';  //20160209
              Strings[J+2]:='';  //20160209
            end;
          end;
          Inc(j,3);
        until j>77;
      end;
      //20260827 Alex <<<
    end;
  end; //i
 //end;  //???? 20260830
 SaveTv(RetNo,FName,FNo);
end;
*)

