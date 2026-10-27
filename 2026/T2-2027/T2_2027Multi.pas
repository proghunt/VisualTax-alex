unit T2_2027Multi;

// This init is not in use  //20160508
(* This unit contains multi-app versions of production routines.
  It's intended to support/simplify parallel updates to both versions.

Current contents:
- added routines for new tax forms (Calc and support)
- routines with logical improvements
*)


interface

uses
  Classes,
  vtMulti;

function GetLastYearLnValue(RetNo: integer; const Ln, FName: string): string;

//added/removed TrimStr
Function CountAlbErrors(AuditList:TAuditList):Integer;
Function AnyInvalidEFCharacters(s:string):boolean;
Function RemoveInvalidEFCharacters(s:string):string;
Procedure ConvertS4(RetNo:Integer;FName:String;FNo:Integer;Fld:Integer;Valu:String;S4WsFNo:Integer);
Function DaysIn2013(RetNo:Integer):Integer;
function PosHex(const SubStr: AnsiString; const StrStream: TMemoryStream): Integer;
//Function Daysafter2012(RetNo:Integer):Integer;
Function DaysbeforeJan2014(RetNo:Integer):Integer;
Function DaysafterJan2014(RetNo:Integer):Integer;
//Function Daysafter2012(RetNo:Integer):Integer;
//Procedure CopyS501FromS23(RetNo:Integer);
//Procedure CopyMCTFromS23(RetNo:Integer);  20130608
Function ValidRTNumber(RetNo:Integer;Bn:String):boolean; //20140530
Function GetEfilerNo:String; //20130505
Function ReplaceHexCharacters(S: AnsiString): AnsiString;

implementation

uses
  SysUtils,
  vtCommon,
  T2_2027,T2_2027Declare,T2_2027common,T2_2027common2,T2_2027TrimStr,
  vtShared, vtTrimStr;

function GetLastYearLnValue(RetNo: integer; const Ln, FName: string): string;
(* Purpose is the unified access to Ln values stored in
  LASTYRBS#1 and  LASTYRIS#1.
  For use (not only) in GIFI BS/IS edit forms.
  It's assumed that fields of an odd ElmNo contain an Ln string,
  ElmNo+1 contains the according value.
Note:  The use of only the first instance (#1) is questionable!
*)
var
  FNo, i, limit: integer;
begin
  Result:='0';
  FNo:=GetFormNo(FName); //('LASTYRIS#1');
  If FNo=0 then
  begin
    BugMsg('Unknown form '+FName);
    Exit;
  end;

  i:=1;
  limit := RetList[RetNo].Frm[FNo].Count - 3; //almost empty?
  Repeat
     If AllTrim(FetchElmFNo(RetNo,FNo,i))=Ln then
     begin
       result:=FormatFloat('###,###,###',Vl(FetchElmFNo(RetNo,FNo,i+1)));
       exit;
     end;
     Inc(i,2);
  Until i>limit; //FieldsLimit-3;
end;


// ---------- added/removed TrimStr -------------------

Procedure ConvertS4(RetNo:Integer;FName:String;FNo:Integer;Fld:Integer;Valu:String;S4WsFNo:Integer);
Var newfld:Integer;
//going form 7 or 10 rows to 20 rows of historical losses
begin
 //20140605 StoreElm(RetNo,FNo,Fld,Valu);  //temp only to be deleted (store it as part of the S4 also for COMPARISON
 If Fld=729 then begin NewFld:=500; StoreElm(RetNo,S4WSFNo,NewFld,Valu); end; //auto indicator

 If Fld=731 then begin NewFld:=593; StoreElm(RetNo,S4WSFNo,NewFld,Valu); end;
 If Fld=732 then begin NewFld:=597; StoreElm(RetNo,S4WSFNo,NewFld,Valu); end;
 If ((Fld>=502) and (Fld<=545)) then  //non cap loss
 begin
  NewFld:=Fld + 98;
  StoreElm(RetNo,S4WSFNo,NewFld,Valu);
  Exit;
 end;
 //farm losses
 If Fld=734 then begin NewFld:=733; StoreElm(RetNo,S4WSFNo,NewFld,Valu); end;
 If Fld=735 then begin NewFld:=737; StoreElm(RetNo,S4WSFNo,NewFld,Valu); end;
 If ((Fld>=564) and (Fld <=628)) then
 begin
  NewFld:=Fld+176;
  StoreElm(RetNo,S4WSFNo,NewFld,Valu);
  exit;
 end;
 //Restricted farm losses
 If Fld=737 then begin NewFld:=894; StoreElm(RetNo,S4WSFNo,NewFld,Valu); end;
 If Fld=738 then begin NewFld:=898; StoreElm(RetNo,S4WSFNo,NewFld,Valu); end;
 If ((Fld>=647) and (Fld <=711))
 then
 begin
  NewFld:=Fld+254;
  StoreElm(RetNo,S4WSFNo,NewFld,Valu);
  exit;
 end;
 //LISTED PROPERTY LOSSES
 If (Fld>=44) and (Fld<=100) then
 begin
  NewFld:=Fld;
  StoreElm(RetNo,S4WSFNo,NewFld,Valu);
  exit;
 end;

end;

Function CountAlbErrors(AuditList:TAuditList):Integer;
Var i:Integer;
  r: TAuditRec;
begin
 Result:=0;
 For i:=0 to AuditList.Count-1 do
 begin
  r := AuditList[i];
  If (r.Category = 'E')
  and (Pos('Alb', r.Description) = 1) then // = 'E-Alb' then
    Inc(Result);
 end;
end;

Function ValidRTNumber(RetNo:Integer;Bn:String):boolean;
Var i:integer;
begin
 Result := True;
 If LeftStr(Bn,1)='0' then begin Result:=False;exit;end;
 If (Length(Bn) <>15) then begin Result:=False;exit;end;
 If UpperCase(BN[10]+Bn[11]) <>'RT' then begin Result:=False;exit;end;

 For i:=1 to 9 do
  If Not Numeric(Bn[i]) then begin Result:=False;exit;end;

 For i:=12 to 15 do
  If Not Numeric(Bn[i]) then begin Result:=False;exit;end;

 If ValidSin(LeftStr(Bn,9)) = False  then
  begin Result:=False;exit;end;
end;

{
Function Daysafter2012(RetNo:Integer):Integer;
begin
 Result:=GetNumDays(RetNo,DateToddmmyyyy('2012/12/31'),'A')
end;
}
Function DaysafterJan2014(RetNo:Integer):Integer;
begin
 Result:=GetNumDays(RetNo,DateToddmmyyyy('2013/12/31'),'A')
end;

Function DaysbeforeJan2014(RetNo:Integer):Integer;
begin
 Result:=GetNumDays(RetNo,DateToddmmyyyy('2014/01/01'),'B');
end;

Function DaysIn2013(RetNo:Integer):Integer;  //20131216
begin
 Result:=GetNumDays(RetNo,DateToddmmyyyy('2012/12/31'),'A')-GetNumDays(RetNo,DateToddmmyyyy('2013/12/31'),'A');
end;

Function GetEfilerNo:String;     //20130505
Var OnLineNo,PassWord,Url,NetFileDir:String;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 Result:=OnlineNo;
end;

Function ReplaceHexCharacters(S: AnsiString): AnsiString;
var
  CharToBeTested : AnsiChar; //20150623
  i:Integer;
  NewString: AnsiString;
begin
 Result:=s;
 NewString:=S;
 For i:=1 to Length(NewString) do
 Begin
  If i>Length(NewString) then break;
  CharToBeTested:=NewString[I];

  if (CharToBeTested in ['0'..'9','A'..'Z','a'..'z', ' ',
   ',',
   '[',
   '(',
   ')',
   '!',
   '@',
   '%',
   '&',
   '*',
   '+',
   '=',
   '?',
   '/',
   ';',
   '@',
   '!',
   '?',
   '$',
   '#',
   '%'])     // '<', '>', '~', '`', '^', '-', '_', '"',
  then
  Begin
   //do nothing
  end
  else
  Begin
   NewString:='Invalid charactes detected'; //LeftStr(NewString,i-1)+' '+MidStr(NewString,I+1,255);
   //Exit; //??? returns old string!!!
   Break; { TODO -oCon : verify } //DoDi 20141114
  end;
 end;
 Result:=NewString;
end;

function PosHex(const SubStr: AnsiString; const StrStream: TMemoryStream): Integer;
var
  SubLen, SrcLen, Len, I, J: Integer;
  C1: AnsiChar;
  Str: PAnsiChar;
begin
  SrcLen := StrStream.Size;
  SubLen := Length(SubStr);

  Result := 0;
  if (SubLen <= 0) or (SrcLen <= 0) or (SrcLen < SubLen) then Exit;

  StrStream.Position := 0;
  Str := StrStream.Memory;

  Len := SrcLen - SubLen + 1;
  C1 := SubStr[1];
  for I := 1 to Len do
  begin
    if Str[I] = C1 then
    begin
      Result := I;
      for J := 1 to SubLen-1 do
      begin
        if Str[I+J] <> SubStr[1+J] then
        begin
          Result := 0;
          break;
        end;
      end;
      if Result <> 0 then Exit;
    end;
  end;
end;


Function AnyInvalidEFCharacters(s:string):boolean;
var
 i,j:integer;
 isValid:boolean;
begin
 result := false;
 For i:=1 to Length(s) do
 begin
        if not (CharInSet(s[i], acceptedEFSet)) then
        begin
                result := true;
                break;
        end;
 end;
end;

//20140704
Function RemoveInvalidEFCharacters(s:string):string;
var
 i,j:integer;
 isValid:boolean;
 //acceptedSet : set of char;
begin
 For i:=1 to Length(s) do
 begin
        if not (CharInSet(s[i], acceptedEFSet)) then
        begin
                     s[i] :=' ';   //20140703
                     //showmessage('new string: ' + s);
        end;
 end;
 result := s;
end;

end.
