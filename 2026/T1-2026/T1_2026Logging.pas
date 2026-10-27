unit T1_2026Logging;
{$B-}

interface
uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB,ShellApi,
  T1_2026Declare;
 {
 SysUtils,FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB, IniFiles,
 UDeclare;
 }

Procedure AddRecordToLog(RetNo:Integer);
Function AlreadyInLog(LogRec:TLogRec;LogList:TStringList):Boolean;
Procedure MkLogRec(RetNo:integer);
Function MkLogDirName(OfficeCode,AgentCode:String):String;
Function ConvertMonthToAlpha(MM:Integer):string;
Function MkLogFileName(OfficeCode,AgentCode:String):String;
Function MkLogDirectory(OfficeCode,AgentCode:String):boolean;
Function ReformatPayDt(Dt:String):String;
{Function OpenIt(ThisTable:TADTable):Boolean;}

Var
 OfficeCode,AgentCode: string; //[4];

implementation

uses vtCommon,vtMulti,T1_2026TrimStr,vtTrimStr,vtShared;

Procedure AddRecordToLog(RetNo:Integer);
Var LogDir,FullLogName,DailyLogName:string;
LogList : TstringList;
PaymentDt,TodaysDate,Office,Agent,s:String;
{added only if:
 Payment date = Todays date
 Pay amount >0
 SIN not in log already
}
begin
//  EXIT;  //20170106 //20170130 Igor
  TodaysDate := FormatDateTime('yyyy-mm-dd', Date);
   {DateToYYYYMMDD(Date);}
  PaymentDt  := FetchElm(RetNo, 'INVOICE', 209);

  If PaymentDt <> TodaysDate then exit; {do not log}
  MkLogRec(RetNo);

  If Vl(LogRec.Pay_amount) =0 then exit; {do not log}

  Office := User.M_Office;
  Agent  := User.Code; //20170112
  LogDir       := MkLogDirName(Office,Agent);
  DailyLogName := MkLogFileName(Office,Agent);
  If not DirectoryExists(LogDir) then
  begin
   If not MkLogDirectory(Office,Agent) then
   begin
    ShowMessage('Cannot create your Log directory');
    exit;
   end;
  end;

  FullLogName := LogDir+'\'+DailyLogName;

  LogList := TstringList.Create;
  If FileExists(FullLogName) then LogList.LoadFromFile(FullLogName);

    s:='';
    s := s
         +PaddR(LogRec.Pay_dt,10)
         +PaddR(LogRec.OfficeCode,4)
         +PaddR(LogRec.AgentCode,4)
         +PaddR(LogRec.Pay_InvNo,14)
         +PaddR(LogRec.Pay_Type,7)
         +PaddR(LogRec.Pay_amount,9)
         +PAddR(LogRec.ReturnType,1)
         +PAddr(LogRec.RefundOrDue,9)
         +PaddR(LogRec.LastName,30)
         +PaddR(LogRec.FirstName,10)
         +PaddR(LogRec.SinNo,9)
         +PaddR(LogRec.Phone,13)
         +Space(20);

  If AlreadyInLog(LogRec,LogList) then  {do not log}
  begin
   LogList.Free;
   exit;
  end
  else
  begin
   LogList.Add(S);
   LogList.SaveToFile(FullLogName);
   LogList.Free;
  end;
end;

Function AlreadyInLog(LogRec:TLogRec;LogList:TStringList):Boolean;
Var I:integer;
begin
  Result := False;
  For i := 0 to LogList.Count-1 do
  begin
    if LogRec.SinNo = MidStr(LogList[i],99,9) then
     begin result :=true;exit;end;
  end;
end;

Procedure MkLogRec(RetNo:integer);
Var s:string; //[150];
 TodaysDate:string; //[10];
begin
  With LogRec do
   begin
    Pay_Dt       := FetchElm(RetNo,'INVOICE',209);
    OfficeCode   := User.M_Office;
    Agentcode    := User.Code;
    LastName     := GetLastName(RetNo);
    FirstName    := GetFirstName(RetNo);
    SinNo        := GetSinNo(RetNo);
    Phone        := FetchElm(RetNo,'T1',54)+
                    '-'+FetchElm(RetNo,'T1',55);
    ReturnType   := FetchElm(RetNo,'T1',47);
    RefundOrDue  := FormatFloat('00000.00',vl(FetchElm(RetNo,'T1',429)));
    Pay_InvNo    := FetchElm(RetNo,'INVOICE',210);

    Pay_Type     := '';
    If FetchElm(RetNo,'INVOICE',223) > '' then Pay_Type := 'Cash'
    else If FetchElm(RetNo,'INVOICE',224) > '' then Pay_Type := 'Cheque'
    else If FetchElm(RetNo,'INVOICE',225) > '' then Pay_Type := 'Visa';
    If (FetchElm(RetNo,'INVOICE',223) > '') or
        (FetchElm(RetNo,'INVOICE',224) > '') or
       (FetchElm(RetNo,'INVOICE',225) > '')  then
       Pay_Amount := FormatFloat('00000.00',vl(FetchElm(RetNo,'INVOICE',222)))
    Else
       Pay_Amount:= FormatFloat('00000.00',0);

 end;
end;


Function MkLogDirName(OfficeCode,AgentCode:String):String;
begin
 Result := 'C:\'+OfficeCode+AgentCode;
end;

Function ConvertMonthToAlpha(MM:Integer):string;
begin
  result :='';
  If      MM = 1 then result := 'A'
  Else If MM = 2 then result := 'B'
  Else If MM = 3 then result := 'C'
  Else If MM = 4 then result := 'D'
  Else If MM = 5 then result := 'E'
  Else If MM = 6 then result := 'F'
  Else If MM = 7 then result := 'G'
  Else If MM = 8 then result := 'H'
  Else If MM = 9 then result := 'I'
  Else If MM = 10 then result := 'J'
  Else If MM = 11 then result := 'K'
  Else If MM = 12 then result := 'L';
end;

Function MkLogFileName(OfficeCode,AgentCode:String):String;
Var TodaysDate, SMonth,SDay:String;MM:Integer;
begin
 TodaysDate := DateToYYYYMMDD(Date);
 SDay := RightStr(TodaysDate,2);
 MM  := MyStrToInt(MidStr(TodaysDate,6,2));
 SMonth :=ConvertMonthToAlpha(MM);
 Result := OfficeCode+AgentCode+'.'+SMonth+SDay;
end;

Function MkLogDirectory(OfficeCode,AgentCode:String):boolean;
Var LogDir:String;
begin
  result :=True;
  LogDir := 'C:\'+OfficeCode+AgentCode;
  If DirectoryExists(LogDir) then exit;
  {$I-}   {so that the ioresult can be effective}
  MkDir(LogDir);
  if IOResult <> 0 then  begin result := false; exit; end;
end;

(*
Function OpenIt(ThisTable:TADTable):Boolean;
begin
 Result := True;
 Try
  ThisTable.Open;
   except
  on EdataBaseError
     do
      begin
      Result := False;
      end;
     end;
end;
*)

Function ReformatPayDt(Dt:String):String;
Var I :integer;MM,DD,YYYY:String;
{input as m/d/yy from windows, output as YYYY/MM/DD}
begin
 mm:='';
 For i:=1 to Length(Dt) do
 begin
  If Dt[i] = '/' then break;
  Mm:=MM+Dt[i];
 end;

 Dt := MidStr(Dt,i+1,10); {starting at D}
 DD:='';
 For i:=1 to Length(Dt) do
 begin
  If Dt[i] = '/' then break;
  DD:=DD+Dt[i];
 end;

 Dt := MidStr(Dt,i+1,10); {starting at D}
 YYYY:='';
 For i:=1 to Length(Dt) do
 begin
  If Dt[i] = '/' then break;
  YYYY:=YYYY+Dt[i];
 end;
If Length(yyyy)=2 then YYYY:='19'+YYYY;
Result := PaddZero(YYYY,4)+'/'+PaddZero(MM,2)+'/'+PaddZero(DD,2);
end;


end.

