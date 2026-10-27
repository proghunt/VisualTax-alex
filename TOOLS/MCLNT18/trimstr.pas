unit TrimStr;
{$B-}

interface
 uses
 SysUtils,FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB, DBTables,
 UDeclare,IniFiles, MAPI,ShellAPI,Registry,Clipbrd,
 NMsmtp, //20151110
 upopList,ActiveX; //20180917 Igor

{Const}
{Space = #$20;}

//20151105
Function GetTaxRate(Prov:String):Real;
Function ValidDate(s:String):Boolean;
Function PureNumeric(S:string):Boolean;  //20141013

//20151110 Igor
function SendSMTPMail(const Subject, Body, FileName, SenderName, SenderEMail, RecipientName, RecipientEMail, Host, UserID: string): Integer;

Function GenerateRandomNumber(MaxInt:LongInt):LongInt;
Function GenerateRandomString(MaxLength:Integer):String;

Procedure AnalyseEfileLog(FlName:String);
Procedure AnalyseEfileLogT2(FlName:String);
Function GetDefaultEmailAddress:String;
Function GetHtmlInvoiceContent(SourceName: string; Var DestinationBuffer:WideString): boolean;
procedure EMailInvoice(SomeSubject,SomeText,SomeAttachment,SomeRecipientEMail:String);
function SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
Function AppendAFile(SourceName: string; DestinationName: string): boolean;
//procedure MergeFiles(FirstSplitFileName, OutFileName : TFileName) ;
function GetFileList(FDirectory, Filter: TFileName): TStringList;
Procedure ShowTimedMsg(Msg:String;DelayTime:Integer);
Procedure Delay(ms:LongInt);
Function PrintListing(DataDir,FileNm:String):boolean;
Procedure PrintALine(LabelPosX,LabelPosY:integer;Line1:String);
Function RemoveChar(S:string;Ch:String):string;
Function FindWord(ThisWord,Ln:String):Integer;
Procedure ParseWords(S:String;Delim:String;Var WList:TstringList);
Function PrintLabels(DataDir,FileNm:String):boolean;
Procedure PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
Procedure GetEmployerList(Var EmplList: TstringList);
Procedure ApplyRange(Table1:TTable;EmployerNo:String);

Function OpenIt(ThisTable:TTable):Boolean;
Function GotoThisSlip(Tbl:TTable;EmployerNo:String;Sin:string):Boolean;
Function GetEmplRecByNo(EmployerNo:String;Var EmplRec:TEmplRec):Boolean;
Function GetEmplRecByName(EmployerName:String;Var EmplRec:TEmplRec):Boolean;
Procedure FillEmplRec(Tbl:TTable; Var EmplRec:TEmplRec);
Function MakeDataDirectory(DataDir:string): integer;
Function CopyBlankDBFS(AppDir: string; DataDir: string): boolean;
Function InQuotes(S:String):String;
function GetRetColor(RetNo: Integer): Longint;
Function GetWinIniString(IniFileName:String;Sect:String;Ident:String):String;
Function MMDDYYYYToWinFormat(Dt:String):string;
Function GetFormType(FormName:string):String;
Function RemoveSpaces(S:string):string;
Function RemoveHyphens(S:string):string;

Function RemoveCommas(s: string):String;
Function ValidAccount(Account: string):boolean;
Function GetPrvYear(ThisYear:String;No:integer):String;
Function ReformatAccount(S: string;PrefixLtr:string):String;
Function GetFormFee(FormName:String;Qty:integer):Real;
Function GetTotalFee(RetNo:Integer):Real;
Procedure GetListInvoiceForms(RetNo:Integer;Var Frms:TStringList;
  Var HowMany:TstringList);
Function CountPagesGenerated(RetNo:Integer):Integer;
Function DDMMYYYYToMMDDYYYY(DDMMYYYY:String):string;
Procedure FillHeader(RetNo,FormNo,NameElm,AccountElm,YearEndElm:Integer);
Function MyStrToFloat(AString:String):Real;
Function GetReturnName (RetNo:Integer):String;
Function GetAccountNumber (RetNo:Integer):String;
Function GetYearEnd(RetNo:Integer):String;

Procedure AllowLinesForLogo(Var LetterLines:TstringList);
Procedure ExpandTabs(Var AList:TstringList);
Procedure ResolveConditions(Var AList:TstringList);
Function InvalidAmountInLetter(s:string):boolean;
Function IsInList(Astring:String; SomeList: TstringList):Boolean;
Procedure CountMulties(RetNo:Integer;Var frms:TStringList;Var HowMany:TstringList);

Function CountKeystrokePoints(RetNo:Integer):Integer;
Function ClcR(FieldId:integer;
              PgmValue:real;
              FormOvrSw:boolean;
              RetNo:integer;
              FormNo:integer):Real;
Function EditDate(S:String;MxYear:string):Boolean;
Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;

function IsShowFlagIndicator(FName: String):Boolean;
function IsShowHdrIndicator(FName: String):Boolean;
Procedure RemoveLastEmptyLines(Var TempList:TstringList);
Function ValidateTextLine(
      Txt:String; Var Cursor_position:integer; Var KeyWLength:Integer):boolean;
Procedure RemoveEmptyLines(Var TempList:TstringList);
Procedure LoadLetter(Var TempList:TstringList;LetterName:String);
procedure InterpretTextLine(Var Txt:String);
Procedure ReplaceKeyWord(
     Var Txt:String;Cursor_Position:Integer;
     KeyWLength:integer;ReplaceString:String);
procedure ConditionEvaluator(CStr:string;
                   var CCheck:boolean; var error:boolean);

Procedure ReplaceText(LetterBody:TMemo;Cursor_Position:Integer;
         KeyWLength : Byte; ReplaceText: string);
function GetDataDictElmNo(KeyW: String):Integer;
function GetDataDictFormName(KeyW: String):String;
function InDataDict(KeyW: String):Boolean;
Function InsertPenniesDot(S: string):String;
function GetWhiteBoxesIndicator(FName: String):Boolean;
function GetFormHandle(RetNo: Integer; FormNo: integer):THandle;
Function RmvLeadingZeros(S:string):string;
Function Numeric(S:string):Boolean;
Function FetchElmFNo(RetNo : integer; FNo:integer;Elm :integer): string;
Procedure StoreElm(RetNo:Integer;FNo:Integer;Elm:integer;Valu:String);
Procedure InfoOn;  {just repaint mdi status panel}
Procedure InfoOff;
Function CalcDaysInCan(RetNo:integer):Integer;
Function DateDiff(D1: String; D2 : string):Integer;
Function DateToMonthDayYear(dt:TDateTime):string;
Function DateToYYYYMMDD(Dt: TDateTime):String;
Function GetNumbFields(FName: string):integer;
Function WhichCreditForm(RetNo: integer;ShortPrv:string):String;
Function RemovePenniesDot(S: string):String;
Function MakeEFFileName(LicenseLevel:string):string;

Function JustRight(S:String;MaxLength: integer): string;
Function EditLongPrv(Value: string):Boolean;
Function ChkDigit(SiNum8: string):Integer;
Function ValidSin(SiNum: string):Boolean;
Function InStringRange(Val: string;LowVal: String; HighVal: string):boolean;
Function InNumRange(Val: string; LowVal: String; HighVal: string):boolean;
Procedure GetCalendar;
Function FormatAmount(s: string): string;
Procedure SetDateFormat;  {to DMY}
{File i/o}
Function FileNameValid(FlName: string): boolean;
Function CopyReturn(DataDir:String;FileName:String;DestinationDir:string):boolean;
Function GetUserProfile(UserName:string): boolean;
Procedure ShowOpenReturnFailure(FailCode: integer;DataDir: String; FlName: string);
Function CopyFile(SourceName: string; DestinationName: string): boolean;
function LoadDataDict: boolean;
Function InitParms: boolean;
Procedure ShowHelp(Helptopic: string);

  Function MinR(V1: real; V2: real): real;
  Function MaxR(V1: real; V2: real): real;
  Procedure SwapStrings(S1: string; S2: string);
  Function ExtractDecimalPart(S: string): string;
  Function ExtractIntegerPart(S: string): string;
  function LTrim(Const Str: String): String;
  function RTrim(Str: String): String;
  function AllTrim(Str: String):  String;
  function RightStr(Const Str: String; Size: Word): String;
  function LeftStr(Const Str: String; Size: Word): String;
  function MidStr(Const Str: String; StartPos :Word; Size: Word): String;
  Function FilledStr(Count: Word; ch: char):String;  {mine Returns a string of x chars}
  Function Space(Count: Word):String;  {Returns a string of count spaces}
  Function PaddCount(s: string; maxLength: integer):Integer;
  Function PaddR(S: string;MaxLength: integer):String;
  Function PaddZero(S:string;MaxLength:Integer):string;
  Function InsertSeparators(s: string;Sep:String):String;
  Function VL(s: string):Real;
  Function MyStrToInt(s: string):integer;
  Function ValidateNumericField(s: Char):boolean;
  Function ValidateAmountField(s: Char):boolean;
  function GenerateGUID: String; // 20180917 Igor

implementation

uses UTimedMsg;

function GenerateGUID: String; // 20180917 Igor
var
  MyGUID: TGUID;
  MyWideChar: array[0..100] of WideChar;
begin
  {First, generate the GUID}
  CoCreateGUID(MyGUID);
  {Now convert it to a wide-character string}
  StringFromGUID2(MyGUID, MyWideChar, 39);
  {Now convert it to a Delphi string}
  Result := WideCharToString(MyWideChar);
  {Get rid of the left and right brackets in the string:}
  while Pos( '{', Result ) > 0 do
    Delete( Result, Pos( '{', Result ), 1 );
  while Pos( '}', Result ) > 0 do
    Delete( Result, Pos( '}', Result ), 1 );
end;

Function MyStrToFloat(AString:String):Real;
begin
 If AString='' then result :=0 else result := StrToFloat(AString);
end;

Procedure FillHeader(RetNo,FormNo,NameElm,AccountElm,YearEndElm:Integer);
Begin
  With Ret[RetNo]^.Frm[FormNo] do
  begin
  Strings[NameElm] := GetReturnName(RetNo);
  Strings[AccountElm] := GetAccountNumber(RetNo);
  Strings[YearEndElm] := GetYearEnd(RetNo);
  end;
end;

Function FetchElmFNo(RetNo : integer; FNo:integer;Elm :integer): string;
{FNo is coming as parameter,not Fname}
begin
  Result :='';
  If Ret[RetNo]^.Frm[Fno].Count >0 then
     Result := Ret[RetNo]^.Frm[FNo].strings[elm];
end;



Function GetReturnName(RetNo:Integer):String;
Var s:string;
Begin
 result := '(Un-named)';
end;


Function GetAccountNumber (RetNo:Integer):String;
Var s:string;
begin
 result := '';
end;

Function GetYearEnd(RetNo:Integer):String;
Var s:string;
{Returns Taxation Year as Input in PAGE_1}
Begin
 result := '';
end;



Function IsInList(Astring:String; SomeList: TstringList):Boolean;
var
i : integer;
begin
   Result := False;
   For i := 0 to SomeList.Count-1 do
   if Astring = SomeList[i] then
    begin Result := True; exit end;
end;

Procedure AllowLinesForLogo(Var LetterLines:TstringList);
Var i:Integer; TempList:tstringlist;
begin
 Templist := TstringList.create;
 If CfgRec.Prn_Logo then
    For i :=1 to CfgRec.Prn_LogoLn do Templist.Add(' ');
 For i:=0 to LetterLines.Count-1 do
   Templist.Add(LetterLines[i]);
 LetterLines.clear;
 LetterLines.Addstrings(Templist);
 Templist.free;
end;

Function CountPagesGenerated(RetNo:Integer):Integer;
Var I:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo]^.FrmHasData[Frec^.FormNo] then inc(Result);
 end;
end;

Function IsFormMultiPage(FormName: String): Boolean;
Var
I : integer;
begin
 Result := False;
 i := Length(FormName);
 While i >0 do
  begin
   If FormName[i] = '_' then begin Result := True; exit; end;
   Dec(i);
  end;
end;

Procedure CountMulties(RetNo:Integer;Var Frms:TStringList;Var HowMany:TstringList);
Var i,j:integer;
begin
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo]^.FrmHasData[Frec^.FormNo] then
   begin
     If IsFormMultiPage(Frec^.FormName) then  {Multipage}
     begin
      If (RightStr(Frec^.FormName,2) = '_1') and (Frec^.FormInst = '#1') then
       begin Frms.Add(Frec^.FormName); HowMany.Add('1'); end
       else
       If (RightStr(Frec^.FormName,2) = '_1') and (Frec^.FormInst > '#1') then
        for j :=0 to Frms.Count-1 do
        If Frec^.FormName = Frms[j] then
         HowMany[j] := IntToStr(StrToInt(HowMany[j]) +1);
     end
     else {Single Page}
     begin
      If (Frec^.FormInst = '#1') then
         begin Frms.Add(Frec^.FormName); HowMany.Add('1'); end
      else
        for j :=0 to Frms.Count-1 do
         If Frec^.FormName = Frms[j] then
          HowMany[j] := IntToStr(StrToInt(HowMany[j]) +1);
     end;
   end;
 end;
end;

Function MultiPage1(Frm:string;Inst:string;MxPg:Integer):Boolean;
{frm is noninstance}
begin
 result := false;
 If (Inst = '#1') then
  if (RightStr(Frm,2) = '-1')
       or (MxPg <2) then
  result :=true;
end;

Function MultiPage23(Frm:string;Inst:string;MxPg:Integer):Boolean;
{frm is noninstance}
begin
 result := false;
 If (Inst > '#1') then
  if (RightStr(Frm,2) = '-1') or (MxPg <2) then
  result :=true;
end;


Function CountKeystrokePoints(RetNo:Integer):Integer;
Var I:integer;Table1:TTable;
begin
 Result:=0;
 Table1 := TTable.Create(Application);
 If not Table1.Active then
  begin
   Table1.DataBaseName := AppDir;
   Table1.TableName    := 'Fees.DBF';
   Table1.Open; Table1.IndexName := 'FORMNAME';
  end;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo]^.FrmHasData[Frec^.FormNo] then
   begin
    if Table1.FindKey([Frec^.FormName]) then
    begin {Table1.FieldByName(Template).AsString;} end;
   end;
 end;
 Table1.Close;
 Table1.Free;
end;




Procedure DeEnlistFormNo(RetNo : integer; FormNo : integer);
var
 i : integer;
begin
  for i :=0 to (FormList.Count - 1) do
    begin
      FormRec := FormList.Items[i];
      if (FormRec^.RetNo = RetNo)  and (FormRec^.FormNo = FormNo) then
        begin
         FormList.Remove(FormRec); FormList.Pack;
         Exit;
        end
    end;
end;


function GetFormHandle(RetNo: Integer; FormNo: integer):THandle;
var
FrmName : String[10];
FrmRec   : PFormList;
i: Integer;
begin
   Result := 0;  {the old forno in case it fails}
   FrmName := UpperCase(FrmName);
   for i :=0 to (FormList.Count - 1) do
   begin
        FrmRec := FormList.Items[i];
        if (FrmRec^.FormNo = FormNo) and (FrmRec^.RetNo = RetNo)then
          begin
           Result := FrmRec^.FormHandle;
           exit;
          end;
   end;
end;

function IsShowHdrIndicator(FName: String):Boolean;
Var I :integer;
begin
Result :=False;
for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If FName = FRec^.FormName + FRec^.FormInst
      then Result := FRec^.ShowHdr;
   end;
End;

function IsShowFlagIndicator(FName: String):Boolean;
Var I :integer;
begin
Result :=False;
for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If FName = FRec^.FormName + FRec^.FormInst
      then Result := FRec^.ShowFlag;
   end;
End;


function GetWhiteBoxesIndicator(FName: String):Boolean;
Var I :integer;
begin
Result :=False;

for i :=0 to (FList.Count - 1) do
  begin
     FRec := FList.Items[i];
     If FName = FRec^.FormName + FRec^.FormInst
      then Result := FRec^.WhiteBoxes;
   end;
End;

function GetFName(AbrevName: String):String;
var
 i: Integer;
 begin
 Result := '';
 AbrevName := RTrim(AbrevName);
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if LeftStr(FRec^.FormAbrev,Length(AbrevName)) = AbrevName then
        begin Result := FRec^.FormName+FRec^.FormInst;exit;end;
    end;
 end;

function GetFormName(FormNo: integer):String;
var
 i: Integer;
 begin
 Result := '';
  for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if FRec^.FormNo = FormNo then
        begin
         Result := FRec^.FormName+FRec^.FormInst;exit;
         WhiteBoxes := FRec^.WhiteBoxes;
        end;
    end;
 end;

{Binary Search}
(*

if ListBox1.Items.IndexOf('AUTOEXEC.BAT') > -1 then  found
function GetFormNo(FormName: String):Integer; {Binary search}
var
i, FNdx,LNdx: Integer;
begin
   FormName := UpperCase(FormName);
   Result := 0;
   FNdx := 0: LNdx := XRefList.Count;
   Repeat
   If FormName >= XRefList.Items[LNdx Div 2] then
      FNdx := LNdx Div 2
   else
      LInx := LNdx Div 2;
   until LNdx < FNdx;


   for i :=0 to (FList.Count - 1) do
   begin
        FRec := FList.Items[i];
        if FRec^.FormName+FRec^.FormInst
           = UpperCase(FormName) then
          begin Result := FRec^.FormNo; exit; end;
   end;
 end;
*)



Function Numeric(S:string):Boolean;
Var i:integer;
begin
 If s ='' then begin Result := false;exit;end;
 For i:= 1 to Length(S) do
 If S[i] in ['-','0','1','2','3','4','5','6','7','8','9'] then
   Result := True
  else
   begin Result := False;Exit; end;
end;


Procedure InfoOn;
begin
  SendMessage(MDIHandle,WM_PAINT,0,0);
end;

Procedure InfoOff;
begin
   InfoMsg :='';
   SendMessage(MDIHandle,WM_PAINT,0,0);
end;

Function RetNoOfSpouse(
  RetNo:integer;SpouseSin1:String;SpouseSin2:string):Integer;
Var I,RNo:integer;
begin
 Result := 0;
 If SpouseSin1+SpouseSin2 ='' then exit;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   Rno := RetRec^.RetNo;
   If (Ret[RNo]^.Frm[1].Strings[3] = SpouseSin2) and
      (Ret[RNo]^.Frm[1].Strings[4] = SpouseSin1)
    then begin Result := RNo;exit;end;
 end;
end;

Function CalcDaysInCan(RetNo:integer):Integer;
Var D1,D2 : string[20];
begin
 With Ret[RetNo]^ do
 begin
 If (Frm[1].Strings[26] > '') and
     (Frm[1].Strings[27] > '') and
     (Frm[1].Strings[28] > '') and
     (Frm[1].Strings[29] > '')  then
   begin
     D1 := Frm[1].Strings[26]+'/'+Frm[1].Strings[25]+'/'+Appyear;
     D2 := Frm[1].Strings[28]+'/'+Frm[1].Strings[27]+'/'+Appyear;
     Result := DateDiff(D1,D2);
   end
  else
    Result := Constant[RY].FullYear;
 end;
end;

Function GetNumbFields(FName: string):integer;
Var i :integer;
begin
 result := 0;
  for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    if Fname = FRec^.FormName+FRec^.FormInst then
      begin result := Frec^.FormFields;exit;end;
   end;
end;

Function DateDiff(D1: string; D2 : string):Integer;
Var
  Date1, Date2 : TDateTime;
begin
  D1 := MMDDYYYYToWinFormat(D1);
  D2 := MMDDYYYYToWinFormat(D2);
  If (D1>'') and (d2 >'') then
  begin
   Date1 := StrToDateTime(D1);
   Date2 := StrToDateTime(D2);
   Result := StrToInt(FloatToStr(Date2-Date1))+1;
  end
  else result :=0;

end;

Function WhichCreditForm(RetNo: integer;ShortPrv:string):String;
begin

 if      ShortPrv = 'NF' then result := 'NFTAX'
 else if ShortPrv = 'PE' then result := 'PETAX'
 else if ShortPrv = 'NS' then result := 'NSCR'
 else if ShortPrv = 'NB' then result := 'NBTAX'
 else if ShortPrv = 'QC' then result := ''
 else if ShortPrv = 'ON' then result := 'ONCR_1'
 else if ShortPrv = 'MB' then result := 'MANCR_1'
 else if ShortPrv = 'SK' then result := 'SKTAX'
 else if ShortPrv = 'AB' then result := 'ALTAX'
 else if ShortPrv = 'BC' then result := 'BCCR'
 else if ShortPrv = 'NT' then result := 'NWTAX'
 else if ShortPrv = 'YT' then result := 'YKTAX'
 else if ShortPrv = 'ZZ' then result := ''
end;

Procedure ShowHelp(Helptopic: string);
begin
 Application.HelpFile := 'T4Help.HLP';
 Application.HelpJump(HelpTopic);
end;


Function DDMMYYYYToMMDDYYYY(DDMMYYYY:String):string;
{input date in form dd-mm-yyyy, output as mm/dd/yyyy}
begin
 result :='';
 If DDMMYYYY ='' then exit;
 Result := MidStr(DDMMYYYY,4,2)+'/'+LeftStr(DDMMYYYY,2)+
           '/'+MidStr(DDMMYYYY,7,4);
end;


Function DateToMonthDayYear(dt:TDateTime):string;
begin
  result :=FormatDateTime('mmmm d, yyyy',Dt);
end;


Function DateToYYYYMMDD(Dt: TDateTime):String;
 Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SSec : string[2];SYYYY : string[4];
begin
  DecodeDate(Dt,YYYY,MM,DD);
  DecodeTime(Dt,Hour,Min,Sec,Msec);
  SYYYY := LTrim(RTrim(IntToStr(YYYY)));
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  Result :=SYYYY+'/'+SMM+'/'+SDD;
end;

Function MakeEFFileName(LicenseLevel:string):string;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SSec : string[2];
begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  If Vl(LicenseLevel) = 3 then
   Result := User.M_Office+SDD+SSec
  Else
   Result := SMM + SDD+ SSec;
end;

Procedure GetCalendar;
Begin
  (*
  Application.CreateForm(TCalndr,Calndr);
  Calndr.ShowModal;
  Calndr.Free;
  *)
end;

Function EditDate(S:String;MxYear:string):Boolean;
{In form dd-mm-yyyy}
begin
 Result := true;
 If s ='' then exit;
 If (s[3] <>'-') or (S[6] <> '-')
 or (not InNumRange(LeftStr(s,2),'01','31'))
 or (not InNumRange(MidStr(s,4,2),'01','12'))
 or (not InNumRange(RightStr(s,4),'1880',MxYear))
 or (Vl(RightStr(s,4)) > Vl(MxYear)) then
  Result := False;
end;


Function InNumRange(Val: string; LowVal: String; HighVal: string):boolean;
begin
 Result := True;
 If (vl(Val) < Vl(LowVal)) or
  (Vl(Val) > Vl(HighVal)) then result := false;
end;

Function InStringRange(Val: string; LowVal: String; HighVal: string):boolean;
begin
 Result := True;
 If (Val < LowVal) or (Val > HighVal) then result := false;
end;


 Function EditLongPrv(Value: string):Boolean;
 Var i: integer;
 begin
   Result := False;
   For i := Low(PrvLong) to High(PrvLong) do
    begin
     If Value = PrvLong[i] then
       begin Result:= True;exit;end;
    end;
 end;

Function GetRowFromSlip(RetNo: integer;FormName: string;
  Row:integer;ExchRow:integer; ShareRow: integer): Real;
Var i,FNo : integer;
ExchRate, SharePercent : real;
begin
  Result :=0;
  for i :=0 to (FList.Count - 1) do
  begin
    FRec := FList.Items[i];
    if FRec^.FormName = FormName then
    begin
     FNo := FRec^.FormNo;
     If Ret[RetNo]^.FrmHasData[FNo] then
     begin
      If ExchRow >0 then
         ExchRate := Vl(Ret[RetNo]^.Frm[FNo].Strings[ExchRow])
       else
         ExchRate :=1;
      if ExchRate > 0 then  {exch rate}
        Result := Result +(Vl(Ret[RetNo]^.Frm[FNo].Strings[Row])) * ExchRate
       else
        Result := Result+Vl(Ret[RetNo]^.Frm[FNo].Strings[Row]);
      If (ShareRow > 0) and
         (Ltrim(Rtrim(Ret[RetNo]^.Frm[FNo].Strings[ShareRow])) > '') then
         begin
           SharePercent := Vl(Ret[RetNo]^.Frm[FNo].Strings[ShareRow]);
           Result := Result * SharePercent /100;
         end;
      end;
     end;
   end;
end;


 Function MinR(V1: real; V2: real): real;
 begin
  result := V1;
  If V2 < V1 then result := V2;
 end;

 Function MaxR(V1: real; V2: real): real;
 begin
  result := V1;
  If V2 > V1 then result := V2;
 end;


  function LTrim(Const Str: String): String;
  var len: Byte; //20190116 Igor
      i: Integer;
  begin
    len := Length(Str); //20190116 Igor
    i := 1;
    while (i <= len) and (Str[i] = Space(1)) do Inc(i);
    LTrim := Copy(Str,i,len);
  end {LTrim};

  function RTrim(Str: String): String;
  var len: Byte; //20190116 Igor
  begin
    len := Length(Str); //20190116 Igor
    while (Length(Str) > 0) AND (Str[len] = Space(1)) do Dec(len);
     Result := Str;
    {RTrim := Str}
  end {RTrim};

  function AllTrim(Str: String): String;
  begin
    Result := LTrim(RTrim(Str))
  end {Trim};

  function RightStr(Const Str: String; Size: Word): String;
  var len: Byte; //20190116 Igor
  begin
    len := Length(Str); //20190116 Igor
    if Size > len then Size := len;
    Result := Copy(Str,len-Size+1,Size)
  end {RightStr};

  function LeftStr(Const Str: String; Size: Word): String;
  begin
    Result := Copy(Str,1,Size)
  end {LeftStr};

  function MidStr(Const Str: String;StartPos: Word; Size: Word): String;
  var len: Byte; //20190116 Igor
  begin
    len := Length(Str); //20190116 Igor
    Result := Copy(Str,StartPos,Size);
  end {MidStr};

  Function FilledStr(Count: Word; ch: char):String;
   {returns a string with Count spaces, or other character}
    var
     S: String[80];
    begin
     { Set a string to all spaces }
      FillChar(S, Count+1, ch);
      S[0] := Chr(Count); 		{ Set length byte }
      Result := S;
  end;

 Function Space(Count: Word):String;
   {returns a string with Count spaces}
    var
     S: String[80];
    begin
     { Set a string to all spaces }
      FillChar(S, Count+1, ' ');
      S[0] := Chr(Count); 		{ Set length byte }
      Result := S;
  end;

Function JustRight(S:String;MaxLength: integer): string;
begin
 S := Ltrim(RTrim(s));
 Result := FilledStr(PaddCount(S,MaxLength),' ') + S;
end;

Function PaddCount(s: string;maxLength: integer):Integer;
{how many characters to reach to mx length}
begin
 Result := MaxLength - Length(s);
 If Result <0 then result := 0;
end;

Function PaddR(S: string;MaxLength: integer):String;
{Fill to the end with blanks}
begin
 S := Ltrim(RTrim(s));
 Result := s + FilledStr(PaddCount(S,MaxLength), ' ');
end;

Function PaddZero(S:string;MaxLength:Integer):string;
Begin
  Result := FilledStr(PaddCount(S,MaxLength), '0')+S;
End;

Function RmvLeadingZeros(S:string):string;
Var I:integer;
Begin
 Result := S;
 For i := 1 to Length(S) do
  If S[i] ='0' then Result := MidStr(S,i+1,255) else exit;
End;

Function RemoveCommas(s: string):String;
Var i:integer;
begin
 For i:=1 to Length(s) do
 begin  If S[i] =',' then S[i] := ' ';end;
 Result := s;
end;

Function InsertSeparators(s: string;Sep:String):String;
Var SignPart: string[1];
begin
 S := LTrim(s);
 If LeftStr(S,1) = '-' then
  begin SignPart := '-'; s := RightStr(s,Length(s)-1);end
 else
  SignPart :='';

 Result := SignPart+s;
 Case Length(s) of
  4 : Result := SignPart+LeftStr(S,1)+Sep+RightStr(S,3);
  5 : Result := SignPart+LeftStr(S,2)+Sep+RightStr(S,3);
  6 : Result := SignPart+LeftStr(S,3)+Sep+RightStr(S,3);
  7 : Result := SignPart+Leftstr(s,1)+Sep+MidStr(S,2,3)+Sep+RightStr(S,3);
  8 : Result := SignPart+Leftstr(s,2)+Sep+MidStr(S,3,3)+Sep+RightStr(S,3);
  9 : Result := SignPart+Leftstr(s,3)+Sep+MidStr(S,4,3)+Sep+RightStr(S,3);
 end;
end;


Function ExtractIntegerPart(S: string): string;
var
i :integer;
IntegerPart, DecimalPart : String[20];
Begin
 I :=1;
 while (i <= Length(s)) and not (S[i] ='.') do inc(i);
 Result := LeftStr(s,i-1); {copy(s[i],1,i-1);}
end;

Function ExtractDecimalPart(S: string): string;
var
i :integer;
Begin
 i := Length(S);
 while (i>0) and not (s[i] in ['.']) do dec(i);
 If (i>0) and (s[i] = '.') then
   result := Copy(s,i+1,255)
 else
   result := '';
end;

Function InsertPenniesDot(S: string):String;
begin
 S :=Ltrim(RTrim(s));
 Result := s;
 If MidStr(s,Length(s)-2,1) = ' ' then
  Result := Concat(LeftStr(s,Length(s)-3), '.', RightStr(s,2));
end;

Function RemovePenniesDot(S: string):String;
begin
 Result := s;
 If MidStr(s,Length(s)-2,1) = '.' then
  Result := Concat(LeftStr(s,Length(s)-3), ' ', RightStr(s,2));
end;

Function FormatAmount(s: string): string;
var
SignPart: String[1];
IntegerPart : String[15];
DecimalPart : String[2];
{SignPart, IntegerPart, DecimalPart : String[20];}
begin
 s := LTrim(s);
 IntegerPart := ExtractIntegerPart(s);
 DecimalPart := ExtractDecimalPart(s);
 If length(DecimalPart) =0 then DecimalPart := '00'
 else if length(DecimalPart) =1 then DecimalPart := DecimalPart +'0'
 else DecimalPart := Copy(DecimalPart,1,2);
 Result := InsertSeparators(IntegerPart,',')+' '+DecimalPart;
end;


Function ValidateAmountField(s: Char):boolean;
begin
 Result := False;
 If ((s >= '0') and (s <= '9')) or
   (s = '.') or (s = '-') then Result := True;
end;

Procedure SwapStrings(S1: string; S2: string);
var s: string;
begin
 s := S1; S1 := S2; S2 := s;
end;


Function ValidateNumericField(s: Char):boolean;
begin
 Result := False;
 If ((s >= '0') and (s <= '9')) or (s ='-') then Result := True;
end;

Function VL(s: string):Real;
Var
Code : integer;
begin
 If s ='' then begin Result := 0; exit;end;
 Val(s,Result,Code);
end;

Function MyStrToInt(s: string):Integer;
begin
 Result :=0;
 s:= AllTrim(S);
 If Numeric(s) then Result := StrToInt(s);
end;


Procedure SetDateFormat;
 Begin
 {
  DateOrder := doDMY;
  DateSeparator := '-';
  DateFullYear := True;
  DateLeadZero := True;
  }
end;

Function FileNameValid(FlName: string): boolean;
Var i : Integer;
begin
 Result := True;
 If (Length(FlName) >12)  or (Length(FlName) = 0)
  or (Length(ExtractFilePath(FlName)) > 0)
  or (Length(ExtractFileExt(FlName)) > 4) {includes .}
  then
   result := false;
end;

Function CopyReturn(DataDir:String;FileName:String;DestinationDir:string):boolean;
begin
  ShowMessage('Copying: '+FileName);
end;

Function GetUserProfile(UserName:string): boolean;
Var
Table1 : TTable;
begin
  Result := True;
  Table1 := TTable.Create(Application);
  Table1.DataBaseName := AppDir; 
  Table1.TableName := 'Users.dbf';
  Table1.IndexName := 'Name';
  Table1.Open;
  if Table1.FindKey([UserName]) = false then
    begin Result := false; exit; end;
  With Table1 do
   begin
   User.M_Office  := FieldByName('M_Office').AsString;
   User.Branch    := FieldByName('Branch').AsString;
   User.Prep_Intls:= FieldByName('Prep_Intls').AsString;
   User.Login_Id  := FieldByName('Login_Id').AsString;
   User.Pswd      := FieldByName('Pswd').AsString;
   User.Auth_Level:= FieldByName('Auth_Level').AsString;
   User.Inv_No    := FieldByName('Inv_No').AsInteger;
   User.Prep_Name := FieldByName('Prep_Name').AsString;
   User.Tax_dir   := FieldByName('Tax_dir').AsString;
   User.EFile_Dir := FieldByName('EFile_dir').AsString;
   User.CrProfile := FieldByName('Cr_Profile').AsBoolean;
   User.CrReturn  := FieldByName('Cr_Return').AsBoolean;
   User.PrReturn  := FieldByName('Pr_Return').AsBoolean;
   User.PrInvoice := FieldByName('Pr_Invoice').AsBoolean;
   User.PrReport  := FieldByName('Pr_Report').AsBoolean;
   User.MkAppoint := FieldByName('Mk_Appoint').AsBoolean;
   User.CrRtu     := FieldByName('Cr_Rtu').AsBoolean;
   User.EFile     := FieldByName('Efile').AsBoolean;
   User.Upload    := FieldByName('Upload').AsBoolean;
   User.MkPay     := FieldByName('Mk_Pay').AsBoolean;
   Table1.Free;
   end;
end;


Function MakeDataDirectory(DataDir:string): integer;
{return codes
 0 : OK
 -1 : Directory exists
 -3 : cannot be created
 }
begin
  result :=0;
  If DirectoryExists(DataDir) then begin result := -1; exit; end;

  {now create the dir}
  {$I-}   {so that the ioresult can be effective}
  MkDir(DataDir);
  if IOResult <> 0 then
       begin result := -3; exit; end;
end;


Function CopyBlankDBFS(AppDir: string; DataDir: string): boolean;
begin
  Result := True;
  {copy the Clients dbf}
  If not FileExists(DataDir+'\'+ ClientsTable) then
  begin
    if (not CopyFile(Appdir+'\'+'Clients.DBF',DataDir+'\'+ 'Clients.DBF'))
     or
   (not CopyFile(Appdir+'\'+'Clients.MDX',DataDir+'\'+ 'Clients.MDX'))
     then  result := False;
  end;

  {now copy the T-Force dbfs}
  If not FileExists(DataDir+'\'+ 'T4.DBF') then
  begin
   if (not CopyFile(Appdir+'\'+'Empl.DBF',DataDir+'\'+ 'EMPL.DBF'))
     or
   (not CopyFile(Appdir+'\'+'Empl.MDX',DataDir+'\'+ 'EMPL.MDX'))
     then result := False;

   if (not CopyFile(Appdir+'\'+'T4.DBF',DataDir+'\'+ 'T4.DBF'))
      or
   (not CopyFile(Appdir+'\'+'T4.MDX',DataDir+'\'+ 'T4.MDX'))
      then result := False;

   if (not CopyFile(Appdir+'\'+'T4A.DBF',DataDir+'\'+ 'T4A.DBF'))
      or
   (not CopyFile(Appdir+'\'+'T4A.MDX',DataDir+'\'+ 'T4A.MDX'))
      then  result := False;

   if (not CopyFile(Appdir+'\'+'T5.DBF',DataDir+'\'+ 'T5.DBF'))
      or
   (not CopyFile(Appdir+'\'+'T5.MDX',DataDir+'\'+ 'T5.MDX'))
      then result := False;
  end;
end;

Procedure ShowOpenReturnFailure(FailCode: integer;DataDir: String; FlName: string);
begin
  Case FailCode of
  -1 :  ShowMessage('File '+ FlName +' does not exist'+
           Chr(13)+'in dir: '+ DataDir);
  -2 :  ShowMessage('File '+FlName +' is not a tax return');
  -3 :  ShowMessage('Exceeds number of maximum returns in memory');
  else ShowMessage('Some error occured');
  end;
end;

Function CopyFile(SourceName: string; DestinationName: string): boolean;
{full path is assumed}
var
  FromF, ToF: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..2048] of Char;
begin
  Result := False;
  If Not FileExists(SourceName) then exit;
  AssignFile(FromF, SourceName);
  Reset(FromF, 1);	{Record size = 1 }
  AssignFile(ToF, DestinationName);	{ Open output file }
  Rewrite(ToF, 1);	{Record size = 1 }
  repeat
   BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
   BlockWrite(ToF, Buf, NumRead, NumWritten);
   until (NumRead = 0) or (NumWritten <> NumRead);
  System.CloseFile(FromF);
  System.CloseFile(ToF);
  Result := True;
end;

function LoadDataDict: boolean;
 var
 i : integer;
 F1 : TextFile;
 {ScrRec : string;}
 Table1 : TTable;
 begin
     {Try}
      DataDictList.Free;
      Table1 := TTable.Create(Application);
      DataDictList  := TList.Create;
      Table1.DataBaseName := AppDir;
      Table1.TableName := 'DataDict.DBF';
      Table1.IndexName := 'Name';
      Table1.Open;
     {load in memory}
     Table1.First;
      while not Table1.EOF do
       begin
        New(DataDictRec);
        DataDictRec^.Name     := Table1.FieldByName('Name').AsString;
        DataDictRec^.FormName := UpperCase(Table1.FieldByName('FormName').AsString);
        DataDictRec^.Elm      := Table1.FieldByName('Elm').AsInteger;
        DataDictRec^.LineNo   := Table1.FieldByName('LineNo').AsInteger;
        DataDictList.Add(DataDictRec);

        Table1.Next;
       end;
        Table1.Close;
      Result := True;
end;

function InDataDict(KeyW: String):Boolean;
Var I :integer;
begin
Result :=False;
for i :=0 to (DataDictList.Count - 1) do
  begin
     DataDictRec := DataDictList.Items[i];
     If KeyW = MidStr(DataDictRec^.Name,2,255)
      then begin Result := True;Exit;End;
   end;
End;

function GetDataDictFormName(KeyW: String):String;
Var I :integer;
begin
Result :='';
for i :=0 to (DataDictList.Count - 1) do
  begin
     DataDictRec := DataDictList.Items[i];
     If KeyW = MidStr(DataDictRec^.Name,2,255)
      then begin Result := DataDictRec^.FormName;Exit;End;
   end;
End;

function GetDataDictElmNo(KeyW: String):Integer;
Var I :integer;
begin
Result :=0;
for i :=0 to (DataDictList.Count - 1) do
  begin
     DataDictRec := DataDictList.Items[i];
     If KeyW = MidStr(DataDictRec^.Name,2,255)
      then begin Result := DataDictRec^.Elm;Exit;End;
   end;
End;

Function InitParms: boolean;
Var SomeString: TstringList;
Begin
  SomeString := TstringList.Create;
  SomeString.LoadFromFile(AppDir+'\'+'T4Parms.d');
  AppVersion := SomeString[0];
  Licensee := SomeString[1];
  LicenseLevel := SomeString[2];
  SomeString.Free;
end;

Function CalcAge(BirthDate: string): Integer;
{birthdate in form dd-mm-yyyy}
Begin
 If Length(BirthDate) =0 then begin Result :=0;exit;end;
 Result := StrToInt(AppYear) - StrToInt(RightStr(BirthDate,4));
end;

Function ValidAccount(Account: string):boolean;
begin
Result := True;
If Length(Account) <> 8 then begin Result := false;exit;end;
end;

Function ValidSin(SiNum: string):boolean;
begin
Result := True;
If Length(SiNum) = 0 then exit;
If Length(SiNum) <> 9 then begin Result := false;exit;end;
If ChkDigit(LeftStr(SiNum,8)) <> StrToInt(RightStr(SiNum,1))
   then Result := false;
end;

Function ChkDigit(SiNum8: string):Integer;
{Returns the check digit}
Var Dig1,Dig2,Dig3,Dig4,Dig5,Dig6,Dig7,Dig8,Dig9 : string[1];
Dg0,Dg1,Dg2,Dg3,Dg4,Dg5 : string[1];
UnitNum : string[4];
i, UnitNumb,x,y,z,w,CheckDg, NextNum : integer;
Tot : string[10];
begin
     {Result := -1;}   {False}
     If Length(SiNum8) <> 8 then exit;
     For i := 1 to 8 do
     begin
      If (MidStr(SiNum8,i,1) <'0') or
         (MidStr(SiNum8,i,1) > '9')
        then exit;
     end;

     DIG1 := LEFTStr(SINUM8, 1);
     DIG2 := MIDStr(SINUM8, 2, 1);
     DIG3 := MIDStr(SINUM8, 3, 1);
     DIG4 := MIDStr(SINUM8, 4, 1);
     DIG5 := MIDStr(SINUM8, 5, 1);
     DIG6 := MIDStr(SINUM8, 6, 1);
     DIG7 := MIDStr(SINUM8, 7, 1);
     DIG8 := MIDStr(SINUM8, 8, 1);
    { DIG9 := MIDStr(SINUM, 9, 1);}
     UNITNUM := DIG2 + DIG4 + DIG6 + DIG8;
     UNITNUMB := StrToInt(UNITNUM);
     UNITNUMB := UNITNUMB * 2;
     TOT := IntToStr(UNITNUMB);
     {dg0 and dg5 are dummies for sign and provision for larger length}
     DG0 := LEFTStr(TOT, 1);
     DG1 := MIDStr(TOT, 2, 1);
     DG2 := MIDStr(TOT, 3, 1);
     DG3 := MIDStr(TOT, 4, 1);
     DG4 := MIDStr(TOT, 5, 1);
     DG5 := MIDStr(TOT, 6, 1);
     If Dg0 = '' then Dg0 := '0';
     If Dg1 = '' then Dg1 := '0';
     If Dg2 = '' then Dg2 := '0';
     If Dg3 = '' then Dg3 := '0';
     If Dg4 = '' then Dg4 := '0';
     If Dg5 = '' then Dg5 := '0';
     X := StrToInt(DG0) + StrToInt(DG1) + StrToInt(DG2) +
         StrToInt(DG3) + StrToInt(DG4) + StrToInt(DG5);

     Y := StrToInt(DIG1) + StrToInt(DIG3) + StrToInt(DIG5) + StrToInt(DIG7);
     Z := X + Y;
     {REM PRINT X,Y,Z}
     W := Z div 10;
     NEXTNUM := (W * 10);
     IF NEXTNUM < Z THEN NEXTNUM := NEXTNUM + 10;
     Result := NEXTNUM - Z;
     {CHECKDG := NEXTNUM - Z;}
     {IF CHECKDG = StrToInt(DIG9) THEN Result := True;}
end;

Function InvalidAmountInLetter(s:string):boolean;
begin
Result :=false;
if ((s<'0') or (s>'9')) and
         (s<>'.') and (s<>' ')and (s<>'-') and
         (s<>',') and
         (s<>'(') and (s<>')') and (s<>'$')
         then
         result := true;
end;
Function GetOvrValue(RetNo:integer;FormNo:integer;FieldId:integer):string;
var i:integer;
begin
    Result := '';
    for i :=0 to (OverList.Count - 1) do
    begin
      OverRec := OverList.Items[i];
      if (OverRec^.RetNo = RetNo) and
         (OverRec^.FormNo = FormNo) and
         (OverRec^.FieldId = FieldId) then
          begin Result := OverRec^.Value;exit;end;
    end;
end;

Function ClcR(FieldId:integer;PgmValue:real;FormOvrSw:boolean;
              RetNo:integer;FormNo:integer):Real;
Var I:integer;
begin
 If FormOvrSw = False then
   Result := PgmValue
 else
   Result := Vl(GetOvrValue(RetNo,FormNo,FieldId));
end;

Function GetFormOvrSw(RetNo:integer;FormNo:Integer):boolean;
Var I:integer;
begin
    Result:=false;
    for i :=0 to (OverList.Count - 1) do
    begin
      OverRec := OverList.Items[i];
      if (OverRec^.RetNo = RetNo) and
         (OverRec^.FormNo = FormNo) then
          begin Result := True;exit;end;
    end;
end;


Procedure ExpandTabs(Var AList:TstringList);
var i,j:integer;TabChar:string[1];s:string;
begin
 exit;  {?}

 TabChar := chr(9);
 for i := 0 to Alist.Count-1 do
  begin
    s := AList[i];
     {Convert tabs to 6 spaces}
    while Pos(TabChar,s) > 0 do
      begin
       j:=Pos(TabChar,s);
       s[j] := ' ';
       s := LeftStr(s,j)+'     '+MidStr(s,j+6,255);
    end;
  end;
end;

Function GetTotalFee(RetNo:Integer):Real;
Var I:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Ret[RetNo]^.FrmHasData[Frec^.FormNo] then
    If Frec^.FormInst >'#1' then
     Result := Result+ Vl(FRec^.FeeAddItem)
    else
     Result := Result+ Vl(FRec^.Fee);
 end;
end;

Procedure GetListInvoiceForms(RetNo:Integer;Var Frms:TStringList;
  Var HowMany:TstringList);
Var i,j:integer;
begin
 {Count non multi-instance forms}
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Ret[RetNo]^.FrmHasData[Frec^.FormNo]) and
     (Vl(Frec^.Fee) >0) and (Frec^.FormInst = '') then
     begin
      Frms.Add(Frec^.FormName);
      HowMany.Add('1');
     end;
 end;   {Flist do}
 {Count multiple forms, add them to the lists}
 CountMulties(RetNo,Frms,HowMany);
end;

Function GetFormFee(FormName:String;Qty:integer):Real;
Var I:integer;
begin
 Result:=0;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If FormName = Frec^.FormName then
    Result := Vl(FRec^.Fee) + (Qty-1)* Vl(FRec^.FeeAddItem);
 end;
end;

(*
Function CalcPolitCredit(Province:String; TotalContrib:Real) :Real;
   Var
      Temp:LongInt;
   begin
   Result := 0.0;
   Temp   := Round (TotalContrib);
   if (Province = 'MN') OR (Province = 'BC') OR (Province = 'PE')
   OR (Province = 'NS') OR (Province = 'YT')
   {Fed political contrib is calculated as if it were MN. If you change MN calculations revise S11 line 1119}
   then
     begin
           case Temp Of
           0..100: result := TotalContrib * 0.75;
           101..550: result:= (100.00 * 0.75) + ((TotalContrib - 100.00) * 0.50);
           else
           result:= MinR (500.00, ( (100.0 * 0.75) +
                                  ( (550 - 100.00) * 0.50) +
                                  ( (TotalContrib - 550.00) * 0.333)) );
           end;
     end;
   if Province = 'AB' then
     begin
           case Temp Of
           0..150: result := TotalContrib * 0.75;
           151..825: result:= (150.0 * 0.75) + ((TotalContrib - 150.00) * 0.50);
           else
           result:= MinR (750.00, ( (150.0 * 0.75) +
                                  ( (825 - 150.00) * 0.50) +
                                  ( (TotalContrib - 825.00) * 0.333)) );
           end;

     end;
   if Province = 'NT' then
     begin
           case Temp Of
           0..100: result := TotalContrib * 1.00;
           else
           result:= MinR (500.00, ( (100.0 * 1.00) +
                                  ( (TotalContrib - 100.00) * 0.50)) );
           end;

     end;
 end;

Function GetPrvForTaxCredit(RetNo:Integer):Real;
begin
  Result :=0;{?}
end;
*)
Function ReformatAccount(S: string;PrefixLtr:string):String;
begin
 If Length(S) <8 then begin result :=s;exit;end;
 Result := PrefixLtr+LeftStr(s,2)+'-'+MidStr(s,3,4)+'-'+RightStr(s,2);
 If Result = '--' then Result := '';
end;

Function GetPrvYear(ThisYear:String;No:integer):String;
Var k:integer;
begin
 k:=MyStrToInt(ThisYear)-No;
 result := IntTostr(k);
end;

Procedure ResolveConditions(Var AList:TstringList);
  var i: Integer;
    errorC:Boolean;
    NetList :TstringList;
    KeyW : string;
    Size:word;
    Buffer, WorkBuffer:Pchar;
    CheckKey:Boolean;
    LineNum:LongInt;
    ConditionStr:string;
    CheckCondition:boolean;
    exchange:string;
    J,K,L,M:integer;
    MaxLine:integer;
    f:TextFile;
begin
 {now Condition interpret}
 (*
  NetList := TstringList.Create;
  errorC:=False;
  MaxLine := AList.Count;
  {Replace condition lines}
  for i := 0 to MaxLine-1 do
    begin
    if LeftStr(AList[i],4)<>'#If ' then
       NetList.Add(Alist[i])
    else
       begin
       LineNum:=I;
       ConditionEvaluator(Alist[LineNum],checkCondition,errorC);
       if errorC=True then
          exit;

       {If If condition is true}
       if checkCondition=True then
           begin
           J:=1; {j counts the lines after a true if}
           while (LeftStr(AList[LineNum+J],5)<>'#Else')
                 and (LeftStr(AList[LineNum+J],6)<>'#Endif') and
                 (LineNum+J<MaxLine) do
                 J:=J+1;

           for K:=1 to J-1 do
                NetList.Add(AList[LineNum+K]); {copy lines after ^If}

           if LeftStr(AList[LineNum+J],5)='#Else' then {after else}
              begin
              L:=J+1;
              while (LeftStr(AList[LineNum+L],6)<>'#Endif') and
                (LineNum+L<MaxLine) do
                 L:=L+1;
              end
           else
              L:=J;

           I:=I+L;
       end;

       if checkCondition=False then
          begin
           J:=1; {j counts the lines after a false if}
           while (LeftStr(AList[LineNum+J],5)<>'#Else')
                 and (LeftStr(AList[LineNum+J],6)<>'#Endif') and
                 (LineNum+J<MaxLine) do
                 J:=J+1;

           if LeftStr(AList[LineNum+J],6)='#Endif' then
              L:=J
           else
              begin
              L:=J+1;
              while (LeftStr(AList[LineNum+L],6)<>'#Endif') and
                (LineNum+L<MaxLine) do
                 L:=L+1;
              for K:=J+1 to L-1 do
                  {writeln(f, LetterBody.Lines[LineNum+K]);}
                  NetList.Add(AList[LineNum+K]);
              end;
           I:=I+L;
          end;
       end;
   end;
   {Closefile(f);}
   {LetterBody.Lines.LoadFromFile('Exchange.txt');}
   AList.Clear;
   For i:=0 to NetList.count -1 do
    AList.Add(NetList[i]);
   NetList.Free;
   *)
end;

procedure InterpretTextLine(Var Txt:String);
Var
 I,size: integer;
 KeyW:string;
 OrdKeyW:integer;
 J,L: integer;
 s:string;
 FrmNm : String;
 ElmNo :integer;
 ReplaceString : string;
 KeyWLength,Cursor_position,LineNumber :integer;
begin
 (*
 Txt :=Rtrim(Txt)+' ';  {one space to allow for logic}
 Size:=Length(Txt)+1;
 KeyW :='';
 for i := 1 to size do
 begin
  if Txt[i] = KeyWDelimiter3 then
  begin
     cursor_position:=I;
     I:=I+1;
     while (Txt[i] <>' ') and (Txt[i] <>'.') and (I<size) do
           begin KeyW:=KeyW+Txt[i]; I:=I+1;end;

     If (InDataDict(KeyW)) and (KeyW<>'If') and
          (KeyW<>'Else') and (KeyW<>'Endif') and
          (KeyW<>'Date') and
          (KeyW<>'This_TaxYear') and
          (KeyW<>'Next_TaxYear') and
          (LeftStr(KeyW,5)<>'Line_') then
     begin
          FrmNm := GetDataDictFormName(KeyW);
          ElmNo :=  GetDataDictElmNo(KeyW);
          KeyWLength:=Length(KeyW);
          ReplaceString:= FetchElm(RetNo,FrmNm,ElmNo);
          ReplaceKeyWord(Txt,Cursor_Position,KeyWLength,ReplaceString);
     end
           else
            begin
               {Replace reserved keyword}
               KeyWLength:=Length(KeyW);
               If KeyW = 'Date' then
                ReplaceString := DateToMonthDayYear(Date)
               else If KeyW = 'This_TaxYear' then
                ReplaceString := AppYear
               else If KeyW = 'Next_TaxYear' then
                ReplaceString := IntToStr(StrToInt(AppYear)+1)
               else
                ReplaceString:='#'+KeyW;
              ReplaceKeyWord(Txt,Cursor_Position,KeyWLength,ReplaceString);
            end;
  KeyW:='';
  i := Cursor_Position+Length(ReplaceString); {i+Length(ReplaceString);}
  Size := Size-KeyWLength+Length(ReplaceString);
  end
  else   {no keyword}
  If i>Size then exit;
      {if I >= Size then exit else Inc(i);}
 end;
 *)
end;


procedure ConditionEvaluator(CStr:string;
                   var CCheck:boolean; var error:boolean);
{cstring comes as: #If   -12000.00 > 0 then}
var n1,n2:real;
    i,count:integer;
    nstr,temp:string;
    great,less,eql:boolean;
    t1,t2:boolean;
    cand,cor:boolean;
    J,N1StartsAt,N2StartsAt:integer;
begin
  (*
  {remove leading spaces before the amount}
  Temp := AllTrim(MidStr(CStr,5,255));
  Temp := AllTrim(Temp);
  If (LeftStr(Temp,1) ='<') or (LeftStr(Temp,1) ='>')
     or (LeftStr(Temp,1) ='=') then {null value came}
     Temp := '0 '+Temp;
  CStr := LeftStr(Cstr,4)+Temp;

  error:=False;
  i:=5;
  great:=false;
  less:=false;
  eql := false;
  nstr:='';  {the string of each number}
  cand:=false;
  cor:=false;
  J:=Length(CStr);
  N1StartsAt :=5;
  {get first number}

  for count:=N1StartsAt to J do {get first number}
  begin
      {Number invalid check}
      if InvalidAmountInLetter(CStr[count]) then
        begin ShowMessage('Invalid Number'); error:=True;exit; end;

      {take number out of the string}
      if ((CStr[count]>='0') and (CStr<='9')) or (CStr[count]='.')
       or (CStr[count]='-')
       then
         nstr:=nstr+CStr[count];
      if Cstr[count]=' ' then
         begin
         i:=count+1;
         count:=Length(CStr);
         If nstr ='' then
           n1:=0
         else
           n1:=Vl(nstr); {StrToFloat(nstr);} {Vl(FormatAmount(nstr));} {no commas}
         nstr:='';
         end;
  end;
  {get > < position}
  for count:=i to J do
      if (CStr[count]='>') or (CStr[count]='<') or (CStr[count]='=')
         or (CStr[count]='-') then
         begin
         if      CStr[count]='>' then great:=True
         else if CStr[count]='<' then less:=true
         else if CStr[count]='=' then eql:=true;
         i:=count;
         count:=Length(CStr);
         end;
  {get second amount}
  If Cstr[i+1] =' ' then N2StartsAt:=i+2 else N2StartsAt:=i+1;
  for count:=N2StartsAt to J do
      begin
        if InvalidAmountInLetter(CStr[count]) then
          begin ShowMessage('Invalid Number');error:=True; exit; end;
      if ((CStr[count]>='0') and (CStr[count]<='9')) or (CStr[count]='.') then
          nstr:=nstr+CStr[count];
      if (Cstr[count]=' ') or (CStr[count]=')') then
         begin
         i:=count;
         count:=Length(CStr);
         n2:=Vl(nstr); {StrToFloat(Ltrim(nstr));} {Vl(FormatAmount(nStr)); {no commas}
         nstr:='';
         end;
      end;
  {Compare the extracted numbers}
  if (great=true) and (n1>n2) then
     t1:=true;
  if (great=true) and (n1<=n2) then
     t1:=False;
  if (less=true) and (n1<n2) then
     t1:=true;
  if (less=true) and (n1>=n2) then
     t1:=false;

  if (eql=true) and (n1=n2) then
     t1:=true;
  if (eql=true) and (n1<>n2) then
     t1:=False;

   CCheck := t1;  {CCheck is true if t1 condition is true}
 *)
end;

Procedure ReplaceText(LetterBody:TMemo;
          Cursor_Position:Integer;
          KeyWLength : Byte;
          ReplaceText: string);
var
i,j,k,PosReturn, SkipChars: Integer;
begin
  With LetterBody do
  begin
   SelStart:=cursor_position-1;
   SelLength:=KeyWLength+1;
   SelText:=ReplaceText;
  end;
end;


Function ValidateTextLine(
  Txt:String;Var Cursor_position:integer;Var KeyWLength:Integer):boolean;
Var
 I,size: integer;
 KeyW:string;
 OrdKeyW:integer;
 J,L: integer;
 s:string;
begin
(*
Result := False;
 Txt :=LTrim(Rtrim(Txt))+' ';  {one space to allow for logic}
 Size:=Length(Txt);

 KeyW :='';
 for i := 1 to size do
  begin
  if Txt[i] = KeyWDelimiter3 then
     begin
     cursor_position:=I;
     I:=I+1;
     while (Txt[i] <>' ') and (Txt[i] <>'.') and (I<size) do
           begin KeyW:=KeyW+Txt[i]; I:=I+1;end;

      If (InDataDict(KeyW) = false) and (LeftStr(KeyW,5)<>'Line_') then
        begin KeyWlength:=Length(KeyW); exit; end

      else if LeftStr(KeyW,5)='Line_' then {Check Line Number}
         begin
           end;
       KeyW:='';
     end;
 end;
 Result :=True;
 *)
end;

Procedure RemoveEmptyLines(Var TempList:TstringList);
Var i:integer;
begin
  I:=0;
  While i < TempList.Count do
   begin
    If LTrim(Rtrim(Templist[i])) = '' then
     Templist.Delete(i)
    else
     Inc(i);
   end;
end;

Procedure RemoveLastEmptyLines(Var TempList:TstringList);
Var i:integer;
begin
  I:=TempList.Count-1;  {start from bottom}
  While i >0 do
  begin
    If LTrim(Rtrim(Templist[i])) > '' then
     exit
    else
    begin
      If LTrim(Rtrim(Templist[i])) = '' then
       begin Templist.Delete(i);Dec(i);end
      else Dec(i);
    end;
  end;
end;

(*
Procedure SelectLetterName(LetterReturnType:String;ParagraphName:String);
begin
  {return type can be PR,PB,PN or FR,FB,FN for efile}
  If ParagraphName      = 'Letterhead' then LetterName := LetterReturnType+'_Hdr.LTR'
  else if ParagraphName = 'Opening' then LetterName := LetterReturnType+'_Open.LTR'
  else if ParagraphName = 'Custom1' then LetterName := LetterReturnType+'_Cust1.LTR'
  else if ParagraphName = 'Signatures' then LetterName := LetterReturnType+'_Sign.LTR'
  else if ParagraphName = 'Attachments' then LetterName := LetterReturnType+'_Attch.LTR'
  else if ParagraphName = 'Instalments' then LetterName := LetterReturnType+'_Instl.LTR'
  else if ParagraphName = 'RRSP' then LetterName := LetterReturnType+'_RRSP.LTR'
  else if ParagraphName = 'Custom2' then LetterName := LetterReturnType+'_Cust2.LTR'
  else if ParagraphName = 'Closing' then LetterName := LetterReturnType+'_Close.LTR'
end;
*)
Procedure LoadLetter(Var TempList:TstringList;LetterName:String);
Var  I :integer;
begin
 If FileExists(AppDir+'\'+LetterName) then
   TempList.LoadFromFile(AppDir+'\'+LetterName)
 else
    For I:=1 to LetterMxParagraphLines do TempList.Add('');
end;

Procedure ReplaceKeyWord(
 Var Txt:String;Cursor_Position:Integer;
 KeyWLength:integer;ReplaceString:String);
begin
 Txt := LeftStr(Txt,Cursor_position-1)
        +ReplaceString
        +MidStr(Txt,Cursor_position+KeyWLength+1,255);
end;

Function RemoveHyphens(S:string):string;
Var i:integer;
begin
 Result:='';
 For i:=1 to Length(s) do
   If s[i] <>'-' then result:=result+s[i];
end;

Function RemoveSpaces(S:string):string;
Var i:integer;
begin
 Result:='';
 For i:=1 to Length(s) do
   If s[i] <>' ' then result:=result+s[i];
end;


Procedure StoreElm(RetNo:Integer;FNo:Integer;Elm:integer;Valu:String);
begin
 If Elm > Ret[RetNo]^.Frm[FNo].Count-1 then exit
 else
  Ret[RetNo]^.Frm[FNo].Strings[Elm] := Valu;
end;

Function GetFormType(FormName:string):String;
Var I:integer;
begin
 Result :='';
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec^.FormName = FormName then
     begin Result := FRec^.FormType;exit;end;
 end;
end;

Function GetWinIniString(IniFileName:String;Sect:String;Ident:String):String;
var
  SomeIniFile: TIniFile;
begin
  SomeIniFile := TIniFile.Create(IniFileName);
  Result :=SomeIniFile.ReadString(Sect,Ident, 'Not Found');
  SomeIniFile.Free;
end;

Function MMDDYYYYToWinFormat(Dt:String):string;
Var WinDateFormat:String;Sep:string[1];
begin
 Result :=Dt;
 WinDateFormat := UpperCase(
     GetWinIniString('c:\windows\Win.Ini','intl','sShortDate'));
 Sep := UpperCase(
     GetWinIniString('C:\windows\Win.Ini','intl','sDate'));

 If LeftStr(WinDateFormat,1)='M' then   {to MMDDYY}
 begin
  Result := Dt;exit;
 end
 else If LeftStr(WinDateFormat,1)='D' then   {to DDMMYY}
 begin
  Result := MidStr(Dt,4,2)+Sep+LeftStr(Dt,2)+Sep+RightStr(Dt,4);
 end
 else If LeftStr(WinDateFormat,1)='Y' then {to YYMMDD}
 begin
  Result :=RightStr(Dt,4)+Sep+LeftStr(Dt,2)+Sep+MidStr(Dt,4,2);
 end;
end;

function GetRetColor(RetNo: Integer): Longint;
var
i: Integer;
begin
 result := RGB(255,255,255);  {if RetNo not found}
 for i :=0 to (RetList.Count - 1) do
    begin
      RetRec := RetList.Items[i];
      if RetRec^.RetNo = RetNo then
        begin
         Result := RetRec^.RetColorRef;
         Exit;
        end
    end;
  end;

Function InQuotes(S:String):String;
{enclose a string in quotes mailnly for SQL statements}
 begin
  result := Chr(39)+S+Chr(39);
 end;

Function GetEmplRecByNo(EmployerNo:String;Var EmplRec:TEmplRec):Boolean;
var Tbl:TTable;
Begin
  Result := false;
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := CfgRec.Dir_Cur;
  Tbl.TableName := 'EMPL.DBF';
  Tbl.Indexname := 'EMPLNO';
 If OpenIt(Tbl) = false then
  begin
   ShowMessage('Employer Data Base not found'+
      Chr(13)+'Define data directories under Config | Data Directories');
   {Close;}
   exit;
  end;
 If Tbl.FindKey([EmployerNo]) then
 begin
    Result := true;
    FillEmplRec(Tbl,EmplRec);
 end;
 Tbl.Close;
 Tbl.Free;
end;

Function GetEmplRecByName(EmployerName:String;Var EmplRec:TEmplRec):Boolean;
var Tbl:TTable;
Begin
  Result := false;
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := CfgRec.Dir_Cur;
  Tbl.TableName := 'EMPL.DBF';
  Tbl.Indexname := 'EMPL_NAME';
 If OpenIt(Tbl) = false then
  begin
   ShowMessage('Employer Data Base not found'+
      Chr(13)+'Define data directories under Config | Data Directories');
   {Close;}
   exit;
  end;
 If Tbl.FindKey([EmployerName]) then
 begin
    Result := true;
    {
    EmployerNo := Tbl.FieldByName('EmplNo').AsString;
    GetEmplRecByNo(EmployerNo,EmplRec);
    }
    FillEmplRec(Tbl,EmplRec);
 end;
 Tbl.Close;
 Tbl.Free;
end;

Procedure FillEmplRec(Tbl:TTable; Var EmplRec:TEmplRec);
begin
 With Tbl do
 begin
   with EmplRec do
   begin
    EmployerNo := FieldByName('EMPLNO').AsString;
    Empl_Name  := FieldByName('EMPL_Name').AsString;
    Bus_Number := FieldByName('Bus_Number').AsString;
    RemitT4    := FieldByName('RemitT4').AsFloat;
    RemitT4A   := FieldByName('RemitT4A').AsFloat;
    NewHires   := FieldByName('NewHires').AsFloat;
    PayPeriods := FieldByName('PayPeriods').AsString;
    {UiPeriods  := FieldByName('UiPeriods').AsInteger;}
    UIRate     := FieldByName('UIRate').AsFloat;
    Street     := FieldByName('Street').AsString;
    City       := FieldByName('City').AsString;
    Prov       := FieldByName('Prov').AsString;
    Postal     := FieldByName('Postal').AsString;
    T2CorpNo   := FieldByName('T2CorpNo').AsString;
    PropSin1   := FieldByName('PropSin1').AsString;
    PropSin2   := FieldByName('PropSin2').AsString;
    RppNum1    := FieldByName('RppNum1').AsString;
    RppNum2    := FieldByName('RppNum2').AsString;
    RppNum3    := FieldByName('RppNum3').AsString;
    AreaCode   := FieldByName('AreaCode').AsString;
    Telephone  := FieldByName('Telephone').AsString;
    FirstName  := FieldByName('FirstName').AsString;
    LastName   := FieldByName('LastName').AsString;
    AuthName   := FieldByName('AuthName').AsString;
    Position   := FieldByName('Position').AsString;
    TaxCentre  := FieldByName('TaxCentre').AsString;

    T5_ammend  := FieldByName('T5_Ammend').AsString;
    T5_Before  := FieldByName('T5_Before').AsString;
    T5_Addit   := FieldByName('T5_Addit').AsString;
    T5_UnclDiv := FieldByName('T5_UnclDiv').AsFloat;
    T5_UnclTax := FieldByName('T5_UnclTax').AsFloat;

    Same_Addr    := FieldByName('Same_Addr').AsString;
    Old_Street   := FieldByName('Old_Street').AsString;
    Old_City     := FieldByName('Old_City').AsString;
    Old_Prov     := FieldByName('Old_Prov').AsString;
    Old_Postal   := FieldByName('Old_Postal').AsString;
    T5Filer      := FieldByName('T5Filer').AsString;
    end;
   end;
end;

Function OpenIt(ThisTable:TTable):Boolean;
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


Procedure CopyT4SlipToForm(Tbl:TTable;FNo:Integer;
          WhichCopy,SlipId:Integer;EmplRec:TEmplRec);
Const SlipElms=42; {number of slip elements}
Var k:Integer; SerialNo:string[20];
begin
  k:=0;
  If SlipId =2 then k:=SlipElms  else If SlipId =3 then k:=SlipElms * 2;
  {
  SerialNo :=IntToStr(Tbl.FieldByName('Serial_No').AsInteger);
  SerialNo := InsertSeparators(SerialNo,'-');
  StoreElm(RetNo,FNo,1+k,SerialNo);
  }
  If UpperCase(Leftstr(Tbl.FieldByName('SIN').AsString,1)) <> 'D' then
   StoreElm(RetNo,FNo,24+k,InsertSeparators(Tbl.FieldByName('SIN').AsString,' '));

  StoreElm(RetNo,FNo,25+k,Tbl.FieldByName('LASTNAME').AsString);
  StoreElm(RetNo,FNo,26+k,Tbl.FieldByName('FIRSTNAME').AsString);
  StoreElm(RetNo,FNo,27+k,Tbl.FieldByName('INITIALS').AsString);

  StoreElm(RetNo,FNo,23+k,Tbl.FieldByName('PROVINCE').AsString); {empl}
  StoreElm(RetNo,FNo,39+k,'RCT Approval: '+ApprovalNo);

  Case WhichCopy of
  1:
    begin
     StoreElm(RetNo,FNo,37+k,'Return with T4 Summary return');
     StoreElm(RetNo,FNo,38+k,'1');
     StoreElm(RetNo,FNo,34+k,EmplRec.Bus_Number);
    end;
  2:
    begin
     StoreElm(RetNo,FNo,37,'Attach to your income tax return'); {top slip}
     StoreElm(RetNo,FNo,38,'2');
     StoreElm(RetNo,FNo,37+k,'To be kept by the employee'); {bottom slip}
     StoreElm(RetNo,FNo,38+k,'3');
     StoreElm(RetNo,FNo,34+k,'XXXXXXXXXXXXXXX');{bus no blank}
    end;
  3:
    begin
     StoreElm(RetNo,FNo,37+k,'To be kept by the employer or payer');
     StoreElm(RetNo,FNo,38+k,'4');
     StoreElm(RetNo,FNo,34+k,EmplRec.Bus_Number);
    end;
  end;

  StoreElm(RetNo,FNo,28+k,Tbl.FieldByName('STREET').AsString);
  StoreElm(RetNo,FNo,29+k,Tbl.FieldByName('CITY').AsString);
  StoreElm(RetNo,FNo,30+k,Tbl.FieldByName('PROV').AsString);
  StoreElm(RetNo,FNo,31+k,Tbl.FieldByName('POSTAL').AsString);

  StoreElm(RetNo,FNo,32+k,Tbl.FieldByName('EMPL_NAME').AsString);
  StoreElm(RetNo,FNo,33+k,Tbl.FieldByName('NUMBER').AsString);

  StoreElm(RetNo,FNo,35+k,Tbl.FieldByName('FOOTNOTE1').AsString);
  StoreElm(RetNo,FNo,36+k,Tbl.FieldByName('FOOTNOTE2').AsString);

  StoreElm(RetNo,FNo,2+k,Tbl.FieldByName('BOX14').AsString);
  StoreElm(RetNo,FNo,3+k,Tbl.FieldByName('BOX16').AsString);
  StoreElm(RetNo,FNo,4+k,Tbl.FieldByName('BOX17').AsString);
  StoreElm(RetNo,FNo,5+k,Tbl.FieldByName('BOX18').AsString);

  StoreElm(RetNo,FNo,6+k,Tbl.FieldByName('BOX20').AsString);
  StoreElm(RetNo,FNo,7+k,Tbl.FieldByName('BOX22').AsString);
  StoreElm(RetNo,FNo,8+k,Tbl.FieldByName('BOX24').AsString);
  StoreElm(RetNo,FNo,9+k,Tbl.FieldByName('BOX26').AsString);
  StoreElm(RetNo,FNo,10+k,Tbl.FieldByName('BOX28A').AsString);
  StoreElm(RetNo,FNo,11+k,Tbl.FieldByName('BOX28B').AsString);
  StoreElm(RetNo,FNo,12+k,Tbl.FieldByName('BOX30').AsString);
  StoreElm(RetNo,FNo,13+k,Tbl.FieldByName('BOX32').AsString);

  StoreElm(RetNo,FNo,14+k,Tbl.FieldByName('BOX34').AsString);
  StoreElm(RetNo,FNo,15+k,Tbl.FieldByName('BOX36').AsString);
  StoreElm(RetNo,FNo,16+k,Tbl.FieldByName('BOX38').AsString);
  StoreElm(RetNo,FNo,17+k,Tbl.FieldByName('BOX40').AsString);
  StoreElm(RetNo,FNo,18+k,Tbl.FieldByName('BOX42').AsString);
  StoreElm(RetNo,FNo,19+k,Tbl.FieldByName('BOX44').AsString);
  StoreElm(RetNo,FNo,20+k,Tbl.FieldByName('BOX46').AsString);
  StoreElm(RetNo,FNo,21+k,Tbl.FieldByName('BOX50').AsString);
  StoreElm(RetNo,FNo,22+k,Tbl.FieldByName('BOX52').AsString);

end;

Procedure CopyT4ASlipToForm(Tbl:TTable;FNo:Integer;
          WhichCopy,SlipId:Integer;EmplRec:TEmplRec);
Const SlipElms=34; {number of slip elements}
Var k:Integer; SerialNo:string[20];
begin
  k:=0;
  If SlipId =2 then k:=SlipElms  else If SlipId =3 then k:=SlipElms * 2;
  {
  SerialNo :=IntToStr(Tbl.FieldByName('Serial_No').AsInteger);
  SerialNo := InsertSeparators(SerialNo,'-');
  StoreElm(RetNo,FNo,31+k,SerialNo);
  }
  StoreElm(RetNo,FNo,24+k,EmplRec.EMPL_Name);
  Case WhichCopy of
  1:
    begin
     StoreElm(RetNo,FNo,28+k,'Return with T4A Summary return');
     StoreElm(RetNo,FNo,29+k,'1');
     StoreElm(RetNo,FNo,23+k,EmplRec.Bus_Number);
    end;
  2:
    begin
     StoreElm(RetNo,FNo,28,'Attach to your income tax return'); {top slip}
     StoreElm(RetNo,FNo,29,'2');
     StoreElm(RetNo,FNo,28+k,'To be kept by the employee'); {bottom slip}
     StoreElm(RetNo,FNo,29+k,'3');
     StoreElm(RetNo,FNo,23+k,'XXXXXXXXXXXXXXX');{bus no blank}
    end;
  3:
    begin
     StoreElm(RetNo,FNo,28+k,'To be kept by the employer or payer');
     StoreElm(RetNo,FNo,29+k,'4');
     StoreElm(RetNo,FNo,23+k,EmplRec.Bus_Number);
    end;
  end;


  StoreElm(RetNo,FNo,22+k,Tbl.FieldByName('PENSIONNO').AsString); {recipient}

  StoreElm(RetNo,FNo,1+k,Tbl.FieldByName('BOX16').AsString);
  StoreElm(RetNo,FNo,2+k,Tbl.FieldByName('BOX18').AsString);
  StoreElm(RetNo,FNo,3+k,Tbl.FieldByName('BOX20').AsString);
  StoreElm(RetNo,FNo,4+k,Tbl.FieldByName('BOX22').AsString);
  StoreElm(RetNo,FNo,5+k,Tbl.FieldByName('BOX24').AsString);
  StoreElm(RetNo,FNo,6+k,Tbl.FieldByName('BOX26').AsString);
  StoreElm(RetNo,FNo,7+k,Tbl.FieldByName('BOX28').AsString);
  StoreElm(RetNo,FNo,8+k,Tbl.FieldByName('BOX30').AsString);
  StoreElm(RetNo,FNo,9+k,Tbl.FieldByName('BOX32').AsString);
  StoreElm(RetNo,FNo,10+k,Tbl.FieldByName('BOX34').AsString);
  StoreElm(RetNo,FNo,11+k,Tbl.FieldByName('BOX36').AsString);
  StoreElm(RetNo,FNo,12+k,Tbl.FieldByName('BOX46').AsString);
  If UpperCase(Leftstr(Tbl.FieldByName('SIN').AsString,1)) <> 'D' then
   StoreElm(RetNo,FNo,13+k,InsertSeparators(Tbl.FieldByName('SIN').AsString,' '));
  StoreElm(RetNo,FNo,14+k,Tbl.FieldByName('FOOT_CODE').AsString);

  StoreElm(RetNo,FNo,15+k,Tbl.FieldByName('LASTNAME').AsString);
  StoreElm(RetNo,FNo,16+k,Tbl.FieldByName('FIRSTNAME').AsString);
  StoreElm(RetNo,FNo,18+k,Tbl.FieldByName('STREET').AsString);
  StoreElm(RetNo,FNo,19+k,Tbl.FieldByName('CITY').AsString);
  StoreElm(RetNo,FNo,20+k,Tbl.FieldByName('PROV').AsString);
  StoreElm(RetNo,FNo,21+k,Tbl.FieldByName('POSTAL').AsString);

  StoreElm(RetNo,FNo,24+k,Tbl.FieldByName('EMPL_NAME').AsString);
  StoreElm(RetNo,FNo,25+k,Tbl.FieldByName('FOOTNOTE1').AsString);
  StoreElm(RetNo,FNo,26+k,Tbl.FieldByName('FOOTNOTE2').AsString);
  StoreElm(RetNo,FNo,27+k,Tbl.FieldByName('FOOTNOTE3').AsString);

  StoreElm(RetNo,FNo,30+k,'RCT Approval: '+ApprovalNo);
end;


Function GotoThisSlip(Tbl:TTable;EmployerNo:String;Sin:string):Boolean;
begin
 Tbl.First;
 Repeat
 Result := False;
  If (Alltrim(Tbl.FieldByName('EMPLNO').AsString) = EmployerNo)
   and
  (Tbl.FieldByName('SIN').AsString = Sin) then
   begin
    Result := True;
    break;
   end;
  Tbl.Next;
 until Tbl.EOF;
end;

(*
Function PrintDBLabels(DbDir,TblNm,FileNm:String):boolean;
var
  Tbl:TTable;
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap
     : Integer;
  Line1,Line2,Line3,Line4:String;
begin
 {Set up label parameters}

  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  TopMargin  := Trunc(0.5 *  PixPerInY);
  LeftMargin := Trunc(1/8 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
  LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}
  HorizLabelGap := Trunc(1/8 *  PixPerInX);

  {open the input file of keys}
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  {start printer}
  Printer.BeginDoc;

  { Get data from data base}
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := DBDir;
  Tbl.TableName := TblNm;
  Tbl.IndexName := 'LASTNAME';

  If Tbl.Active then Tbl.Close;
  Tbl.Open;

  RecNo :=0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    if Tbl.FindKey([InpKey]) then
     begin
      Inc(RecNo);
      If RecNo >30 then begin RecNo :=0; Printer.NewPage; end;
      Line1 := Tbl.FieldByName('LASTNAME').AsString+
         ', '+Tbl.FieldByName('FIRSTNAME').AsString;
      Line2 := Tbl.FieldByName('STREET').AsString;
      Line3 := Tbl.FieldByName('CITY').AsString;
      Line4 := Tbl.FieldByName('PROV').AsString
               +',    '+Tbl.FieldByName('POSTAL').AsString;
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
      PrintALabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4);
     end;
  end; {end while}

  CloseFile(InpFile);
  Tbl.Free;
  Printer.EndDoc;
  Result := True;
end;
*)
(*
Procedure PrintADBLabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 8;
  XPos := LabelPosX +2;
  YPos := LabelPosY+2;
  VertIncr := Trunc(PixPerInY * (1/6));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(XPos,YPos,Line1);
  Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(XPos,YPos+1 * VertIncr,Line2);
  Printer.Canvas.TextOut(XPos,YPos+2 * VertIncr,Line3);
  Printer.Canvas.TextOut(XPos,YPos+3 * VertIncr,Line4);
end;

*)
Procedure ApplyRange(Table1:TTable;EmployerNo:String);
Begin
 with Table1 do
 Begin
  indexname := 'EMPLPLUSLA';
  SetRangeStart;
  FieldByName('EMPLNO').AsString := EmployerNo;
  FieldByName('LASTNAME').AsString := ' ';
  SetRangeEnd;
  FieldByName('EMPLNO').AsString := EmployerNo;
  FieldByName('LASTNAME').AsString := 'z'; {Keep this as lowercase}
  ApplyRange;
 End;
end;

Procedure GetEmployerList(Var EmplList: TstringList);
Var Tbl: TTable;
begin
 EmplList.Clear;
 Tbl := TTable.Create(Application);
 Tbl.DataBaseName := CfgRec.Dir_Cur;
 Tbl.TableName := 'EMPL.DBF';
 Tbl.Indexname := 'EMPL_NAME';

 If OpenIt(Tbl) = false then
  begin
   ShowMessage('Employer Data Base not found'+
      Chr(13)+'Define data directories under Config | Data Directories');
   {Close;}
   exit;
  end;

 Tbl.First;
 Repeat
  EmplList.Add(Tbl.FieldByName('EMPL_NAME').AsString);
  Tbl.next;
 until tbl.EOF;
 Tbl.Close;
 Tbl.Free;
end;

(*
Function GetLastT4SerialUsed(EmployerNo:String):String;
Var EmplRec: TEmplRec; Tbl:TTable;
begin
 {get employer data}
 If GetEmplRecByNo(EmployerNo,EmplRec) = false then
 begin
  ShowMessage('Cannot find Employer');
  exit;
 end;
 {Open t4 db}
 Tbl := TTable.Create(Application);
 if Tbl.active then Tbl.close;
 Tbl.DataBaseName := CfgRec.Dir_Cur;
 Tbl.TableName := 'T4.DBF';
 If OpenIt(Tbl) = false then
  begin
   ShowMessage('Data Base not found'+
      Chr(13)+'Define data directories under Config | Data Directories');
   Tbl.free;
   exit;
  end;
 ApplyRange(Tbl,EmployerNo);

 {Get Last Serial Used}
 Result := '';
 Tbl.First;
  Repeat
     If Tbl.FieldByName('Serial').AsString > result then
      result := Tbl.FieldByName('Serial').AsString;
     Tbl.Next;
  until Tbl.Eof;

Tbl.Free;
end;
*)
(*
Procedure SerializeSlips(EmployerNo,TblName:String;StartingSerial:LongInt);
Var EmplRec: TEmplRec; Tbl:TTable;
LastSerialUsed :LongInt;
begin
 LastSerialUsed := StartingSerial;{CfgRec.OPR_T4Ser;}
 {get employer data}
 If GetEmplRecByNo(EmployerNo,EmplRec) = false then
 begin
  ShowMessage('Cannot find Employer');
  exit;
 end;
 {Open t4 db}
 Tbl := TTable.Create(Application);
 if Tbl.active then Tbl.close;
 Tbl.DataBaseName := CfgRec.Dir_Cur;
 Tbl.TableName := TblName; {'T4.DBF';}
 If OpenIt(Tbl) = false then
  begin
   ShowMessage('Data Base not found'+
      Chr(13)+'Define data directories under Config | Data Directories');
   Tbl.free;
   exit;
  end;
 ApplyRange(Tbl,EmployerNo);
 {Find highest serial in use}
 Tbl.First;
 Repeat
     If Tbl.FieldByName('Serial_No').AsInteger
        > LastSerialUsed then
      LastSerialUsed := Tbl.FieldByName('Serial_No').AsInteger;
      Tbl.Next;
 until Tbl.Eof;

 {Serialize}
 Tbl.First;
 Repeat
     If Tbl.FieldByName('Serial_No').AsInteger = 0 then
       begin
        Tbl.Edit;
        Tbl.FieldByName('Serial_No').AsInteger :=LastSerialUsed+1;
        Inc(LastSerialUsed);
       end;
     Tbl.Next;
 until Tbl.Eof;
Tbl.Close;
Tbl.Free;
end;
*)


Procedure PrintT5Slip(T5PosX,T5PosY:real);
{pos in inches}
Var
  i, XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 9;
  {VertIncr := Trunc(PixPerInY * (1/6));}

  For i := Low(XPosition) to High(XPosition) do
  begin  {convert to pixels}
    XPos := Trunc((T5PosX + XPosition[i])*PixPerInX);
    YPos := Trunc((T5PosY + YPosition[i])*PixPerInY);
    If DataVal[i] <> '.00' then
     Printer.Canvas.TextOut(XPos,YPos,DataVal[i]);
  end;
end;

(*
Procedure GetT5FieldsToPrint(Tbl:TTable;EmplRec:TEmplRec);
Var i:Integer;
{LineY :Array[1..50] of real;} {Y position of each line}
Boxes1Y, Boxes2Y, YrY,NameY,EmployerNmY,Addr1Y, Addr2Y,PostalY,CurrencyY:Real;
VertIncr:real;
begin
  VertIncr := 1/6; {Trunc(PixPerInY * (1/6));}
  {get Y position of each line}
  Boxes1Y   := 0.79;
  Boxes2Y   := Boxes1Y + 3.0 * VertIncr; {1.25;}
  YrY       := Boxes2Y + 3.0 * VertIncr; {1.75;}
  NameY     := YrY + 2.0 * VertIncr; {2.15;}
  EmployerNMY:= NameY+VertIncr;
  Addr1Y    := nameY+2 * VertIncr;      {LineY[10];}
  Addr2Y    := addr1Y+VertIncr; {LineY[11];}
  PostalY   := addr2Y+2 * VertIncr; {LineY[13];}
  CurrencyY := PostalY + 2 * VertIncr; {3.25;}      {LineY[15];}
  {initialize relative y positions of lines in inches}
  For i:=Low(DataField) to High(DataField) do
  begin
   DataField[i] :='';
   XPosition[i] :=0;
   YPosition[i] :=0;
   DataVal[i]   := '';
  end;
  i:=1; DataField[i] := 'Box10';XPosition[i] := 0.25; YPosition[i] :=Boxes1Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box11';XPosition[i] := 1.75; YPosition[i] :=Boxes1Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box12';XPosition[i] := 3.25; YPosition[i] :=Boxes1Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box13';XPosition[i] := 4.50; YPosition[i] :=Boxes1Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box14';XPosition[i] := 6.00; YPosition[i] :=Boxes1Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);

  {second line of boxes}

  Inc(i); DataField[i] := 'Box15';XPosition[i] := 0.25; YPosition[i] := Boxes2Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box16';XPosition[i] := 1.75; YPosition[i] := Boxes2Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box17';XPosition[i] := 3.25; YPosition[i] := Boxes2Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box18';XPosition[i] := 4.50; YPosition[i] := Boxes2Y;
        DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'Box19';XPosition[i] := 6.00; YPosition[i] := Boxes2Y;
          DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);

  {yr line}
  Inc(i); DataField[i] := 'Yr';XPosition[i] := 0; YPosition[i] := YrY;
          DataVal[i]   := RightStr(AppYear,2);
  Inc(i); DataField[i] := 'VOID';XPosition[i] := 3.00; YPosition[i] := YrY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);
  Inc(i); DataField[i] := 'Box20';XPosition[i] := 3.75; YPosition[i] := YrY;
          DataVal[i] :=   FormatFloat('########.00',Tbl.FieldByName(DataField[i]).AsFloat);
  Inc(i); DataField[i] := 'RECCODE';XPosition[i] := 5.00; YPosition[i] := YrY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);
  Inc(i); DataField[i] := 'SIN';XPosition[i] := 5.50; YPosition[i] := YrY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);
  Inc(i); DataField[i] := 'RECTYPE';XPosition[i] := 6.75; YPosition[i] := YrY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);

  Inc(i); DataField[i] := 'Last/First';XPosition[i] := 0; YPosition[i] := NameY;
        DataVal[i] :=   UpperCase(Tbl.FieldByName('LASTNAME').AsString)
        +' '+UpperCase(Tbl.FieldByName('FIRSTNAME').AsString);;
  {addr1 line}
  Inc(i); DataField[i] := 'STREET';XPosition[i] := 0; YPosition[i] := Addr1Y;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);
  Inc(i); DataField[i] := 'Empl name';XPosition[i] := 4.00; YPosition[i] := EmployerNMY;
          DataVal[i] :=   EmplRec.Empl_Name;

   {addr2 line}
  Inc(i); DataField[i] := 'City/Prov';XPosition[i] := 0; YPosition[i] := Addr2Y;
          DataVal[i] :=   UpperCase(Tbl.FieldByName('CITY').AsString)
                         +' '+UpperCase(Tbl.FieldByName('PROV').AsString);
  Inc(i); DataField[i] := 'empl street';XPosition[i] := 4.00; YPosition[i] := Addr1Y;
          DataVal[i] :=   EmplRec.Street;


  Inc(i); DataField[i] := 'empl City/Prov/postal';XPosition[i] := 4.00; YPosition[i] := Addr2Y;
          DataVal[i] :=   EmplRec.City+' '+EmplRec.Prov + ' '+EmplRec.Postal;

  Inc(i); DataField[i] := 'POSTAL';XPosition[i] := 0; YPosition[i] := PostalY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);

  {currency line}
  Inc(i); DataField[i] := 'CURRENCY';XPosition[i] := 1.82; YPosition[i] := CurrencyY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);
  Inc(i); DataField[i] := 'TRANSIT';XPosition[i] := 2.75; YPosition[i] := CurrencyY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);
  Inc(i); DataField[i] := 'RECACCOUNT';XPosition[i] := 4.00; YPosition[i] := CurrencyY;
          DataVal[i] :=   UpperCase(Tbl.FieldByName(DataField[i]).AsString);

end;
*)

Procedure SummarizeT5Slips(EmployerNo:String;Var T5Sum:TT5Sum);
Var EmplRec: TEmplRec; Tbl:TTable;
begin
 {get employer data}
 If GetEmplRecByNo(EmployerNo,EmplRec) = false then
 begin
  ShowMessage('Cannot find Employer');
  exit;
 end;
 {Open t5 db}
 Tbl := TTable.Create(Application);
 if Tbl.active then Tbl.close;
 Tbl.DataBaseName := CfgRec.Dir_Cur;
 Tbl.TableName := 'T5.DBF';
 If OpenIt(Tbl) = false then
  begin
   ShowMessage('Data Base not found'+
      Chr(13)+'Define data directories under Config | Data Directories');
   Tbl.free;
   exit;
  end;
 ApplyRange(Tbl,EmployerNo);

 {initialize global variables}
 With T5Sum do
 begin
  NumSlips:=0;
  TotBox10:=0;TotBox11:=0;TotBox12:=0;
  TotBox13:=0;TotBox14:=0;TotBox15:=0;TotBox16:=0;
  TotBox17:=0;TotBox18:=0;TotBox19:=0;TotBox20:=0;
 end;

 Tbl.First;
 With T5Sum do
 begin
   Repeat
      Inc(NumSlips);
      TotBox10 := TotBox10 + Tbl.FieldByName('Box10').AsFloat;
      TotBox11 := TotBox11 + Tbl.FieldByName('Box11').AsFloat;
      TotBox12 := TotBox12 + Tbl.FieldByName('Box12').AsFloat;
      TotBox13 := TotBox13 + Tbl.FieldByName('Box13').AsFloat;
      TotBox14 := TotBox14 + Tbl.FieldByName('Box14').AsFloat;
      TotBox15 := TotBox15 + Tbl.FieldByName('Box15').AsFloat;
      TotBox16 := TotBox16 + Tbl.FieldByName('Box16').AsFloat;
      TotBox17 := TotBox17 + Tbl.FieldByName('Box17').AsFloat;
      TotBox18 := TotBox18 + Tbl.FieldByName('Box18').AsFloat;
      TotBox19 := TotBox19 + Tbl.FieldByName('Box19').AsFloat;
      TotBox20 := TotBox20 + Tbl.FieldByName('Box20').AsFloat;
      Tbl.Next;
   until Tbl.Eof;
end;
Tbl.Free;
end;


Procedure GetT5SUMFieldsToPrint(Tbl:TTable;EmplRec:TEmplRec;T5Sum:TT5Sum);
Var i:Integer;
  YrY,AmmendY,NameY,Addr1Y,Addr2Y, CityY,T5BfrY,AddrBfrY,CityBfrY :real;
  Box10Y,Box11Y,Box12Y,Box13Y,Box14Y,Box15Y,Box16Y,Box17Y,Box18Y : real;
  Box19Y,Box20Y,Box32Y,Box33Y,ContactY,SignPosY,DateY  : real;
  VertIncr:real;
  BoxesX : real;
  BoxDiff : real;
begin
  VertIncr := 1/6;  {horiz :0.125 per each tick on ruler}
  BoxesX   := 5.50; {4.50;} 
  BoxDiff  := 2 * VertIncr; {0.332;}
  {get Y position of each line}
  YrY       := 1.15;
  AmmendY   := YrY+BoxDiff;
  NameY     := AmmendY+ 2 * BoxDiff;
  Addr1Y    := NameY+BoxDiff;
  Addr2Y    := Addr1Y+BoxDiff;
  CityY     := Addr2Y+BoxDiff;
  T5BfrY    := CityY+BoxDiff;
  AddrBfrY  := T5BfrY+BoxDiff;
  CityBfrY  := AddrBfrY+BoxDiff;
  Box10Y    := CityBfrY+ 3 * BoxDiff;
  Box11Y    := Box10Y+BoxDiff; Box12Y :=Box11Y+BoxDiff;
  Box13Y    := Box12Y+BoxDiff; Box14Y := Box13Y+BoxDiff;
  Box15Y    := Box14Y+BoxDiff;
  Box16Y    := Box15Y+BoxDiff; Box17Y := Box16Y+BoxDiff;
  Box18Y    := Box17Y+BoxDiff;
  Box19Y    := Box18Y+BoxDiff; Box20Y := Box19Y+BoxDiff;
  Box32Y    := Box20Y+BoxDiff; Box33Y    := Box32Y+BoxDiff;
  ContactY  := Box33Y+ 2.5 * BoxDiff;
  SignPosY  := ContactY+ 2.5 * BoxDiff;
  {initialize arrays}
  For i:=Low(DataField) to High(DataField) do
  begin
   DataField[i] :=''; XPosition[i] :=0;
   YPosition[i] :=0;  DataVal[i]   := '';
   RJust[i] := False;
  end;
  i:=1; DataField[i] := 'Yr';XPosition[i] := 2.75; YPosition[i] :=YrY;
        DataVal[i] := RightStr(AppYear,2);
  Inc(i); DataField[i] := 'Filer No';XPosition[i] := 3.50; YPosition[i] :=YrY;
        DataVal[i] :=   EmplRec.T5Filer;
  Inc(i); DataField[i] := 'Empl T5 ammend';XPosition[i] := 2.25; YPosition[i] :=ammendY;
        DataVal[i] :=   UpperCase(EmplRec.T5_Ammend);
  Inc(i); DataField[i] := 'Empl T5 addit';XPosition[i] := 5.00; YPosition[i] :=ammendY;
        DataVal[i] :=   UpperCase(EmplRec.T5_Addit);
  Inc(i); DataField[i] := 'Empl Name';XPosition[i] := 0.25; YPosition[i] :=NameY;
        DataVal[i] :=   UpperCase(EmplRec.Empl_Name);
  Inc(i); DataField[i] := 'Empl str';XPosition[i] := 0.25; YPosition[i] := Addr1Y;
        DataVal[i] :=   UpperCase(EmplRec.Street);
  Inc(i); DataField[i] := 'empl city';XPosition[i] := 0.25; YPosition[i] := CityY;
        DataVal[i] :=   UpperCase(EmplRec.City);
  Inc(i); DataField[i] := 'Empl Prov';XPosition[i] := 3.125; YPosition[i] := CityY;
        DataVal[i] :=   UpperCase(EmplRec.Prov);
  Inc(i); DataField[i] := 'Empl postal';XPosition[i] := 4.00; YPosition[i] := CityY;
          DataVal[i] := UpperCase(EmplRec.Postal);

  Inc(i); DataField[i] := 'Empl busno';XPosition[i] := 5.75; YPosition[i] := CityY;
          DataVal[i] := UpperCase(EmplRec.Bus_Number);

  Inc(i); DataField[i] := 'Empl bfr';YPosition[i] := T5BfrY;
  DataVal[i] := 'X';  XPosition[i] := 1.75;
  If UpperCase(EmplRec.T5_Before) = 'N' then
    XPosition[i] :=  XPosition[i] +0.50;

  {language}
  Inc(i); DataField[i] := 'lang';XPosition[i] := 4.50; YPosition[i] :=  T5BfrY;
          DataVal[i] := 'X';

  Inc(i); DataField[i] := 'eml T2 No';XPosition[i] := 5.75; YPosition[i] :=  T5BfrY+0.10;
          DataVal[i] := UpperCase(EmplRec.T2CorpNo);

  Inc(i); DataField[i] := 'Empl old addr';XPosition[i] := 2.15; YPosition[i] := AddrBfrY;
          DataVal[i] := EmplRec.Old_Street;
  Inc(i); DataField[i] := 'Empl old city';XPosition[i] := 2.15; YPosition[i] := CityBfrY;
          DataVal[i] := EmplRec.Old_City;

  Inc(i); DataField[i] := 'Empl old Prov';XPosition[i] := 5.50; YPosition[i] := CityBfrY;
          DataVal[i] := EmplRec.Old_Prov;

  Inc(i); DataField[i] := 'Empl old Postal';XPosition[i] := 6.50; YPosition[i] := CityBfrY;
          DataVal[i] := EmplRec.Old_Postal;

  {BOXES}
  Inc(i); DataField[i] := 'BOX10';XPosition[i] := BoxesX; YPosition[i] := Box10Y;
          DataVal[i]   :=  FormatFloat('##,###,###.00',T5Sum.TotBox10);
          RJust[i] := True;
  Inc(i); DataField[i] := 'BOX11';XPosition[i] := BoxesX; YPosition[i] := Box11Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox11);
          RJust[i] := True;
  Inc(i); DataField[i] := 'BOX12';XPosition[i] := BoxesX; YPosition[i] := Box12Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox12);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX13';XPosition[i] := BoxesX; YPosition[i] := Box13Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox13);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX14';XPosition[i] := BoxesX; YPosition[i] := Box14Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox14);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX15';XPosition[i] := BoxesX; YPosition[i] := Box15Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox15);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX16';XPosition[i] := BoxesX; YPosition[i] := Box16Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox16);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX17';XPosition[i] := BoxesX; YPosition[i] := Box17Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox17);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX18';XPosition[i] := BoxesX; YPosition[i] := Box18Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox18);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX19';XPosition[i] := BoxesX; YPosition[i] := Box19Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox19);
                    RJust[i] := True;
  Inc(i); DataField[i] := 'BOX20';XPosition[i] := BoxesX; YPosition[i] := Box20Y;
          DataVal[i]   :=   FormatFloat('##,###,###.00',T5Sum.TotBox20);
                    RJust[i] := True;

  Inc(i); DataField[i] := 'Empl t5 uncldiv';XPosition[i] := 4.00; YPosition[i] := Box32Y;
          DataVal[i]   :=  FormatFloat('##,###,###.00',EmplRec.T5_UnclDiv);
                    RJust[i] := True;

  Inc(i); DataField[i] := 'Empl t5 uncltx';XPosition[i] := 4.00; YPosition[i] := Box33Y;
          DataVal[i]   :=  FormatFloat('##,###,###.00',EmplRec.T5_UnclTax);
                    RJust[i] := True;

  {slips filed}
  Inc(i); DataField[i] := 'slips files';XPosition[i] := 7.00; YPosition[i] := Box33Y;
          DataVal[i]   :=  IntToStr(T5Sum.NumSlips);

  Inc(i); DataField[i] := 'empl contact';XPosition[i] := 2.75; YPosition[i] := ContactY;
          DataVal[i]   :=  UpperCase(EmplRec.FirstName+' '+EmplRec.LastName);

  Inc(i); DataField[i] := 'cont area';XPosition[i] := 6.00; YPosition[i] := ContactY;
          DataVal[i]   :=  EmplRec.AreaCode;

  Inc(i); DataField[i] := 'cont tel';XPosition[i] := 6.50; YPosition[i] := ContactY;
          DataVal[i]   :=  EmplRec.Telephone;

  Inc(i); DataField[i] := 'position';XPosition[i] := 3.50; YPosition[i] := SignPosY;
          DataVal[i]   :=  EmplRec.Position;


end;

Procedure PrintT5Sum(T5SumPosX,T5SumPosY:real);
{pos in inches}
Var
  i, XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
  hdc : THandle;
  NullString : Array [0..20] of Char;
begin
  hdc := Printer.Canvas.Handle;
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 9;
  For i := Low(XPosition) to High(XPosition) do
  begin  {convert to pixels}
    XPos := Trunc((T5SumPosX + XPosition[i])*PixPerInX);
    YPos := Trunc((T5SumPosY + YPosition[i])*PixPerInY);
    SetTextAlign(hdc,TA_LEFT);
    Printer.Canvas.Pen.Color := clBlack;
    SelectObject(hdc,Printer.Canvas.Font.handle);
    SetBkMode(hdc,TRANSPARENT);
    If DataVal[i] <> '.00' then
    begin
     If RJust[i] = false then
       TextOut(hdc,XPos,YPos,
                StrPCopy(NullString,DataVal[i]),
                Length(DataVal[i]))
      else
       begin
        SetTextAlign(hdc,TA_RIGHT);
        TextOut(hdc,XPos,YPos,
                StrPCopy(NullString,DataVal[i]),
                Length(FormatAmount(DataVal[i])));
       end;
    end;
    (*
    If RJust[i] = false then
      Printer.Canvas.TextOut(XPos,YPos,DataVal[i])
    else
      begin
       SetTextAlign(hdc,TA_RIGHT);
       Printer.Canvas.TextOut(XPos,YPos,FormatAmount(DataVal[i]));
      end;
    *)
  end;
end;

Function PrintAListing(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
var
  i,LineCnt,MxLinesPerPage,PageCnt:integer;PrnFile: TextFile;
  {TempList:TstringList;}
  XPos :LongInt;PageX, PageY : LongInt;
  ScMult : Integer; s:string;
  F1 :TextFile;
  ScaleX, ScaleY : Word;
  FirstTimeSw:boolean;
begin
  AssignFile(F1, FileNm);
  Reset(F1);

  FirstTimeSw := true;
  LineCnt:=0;PageCnt :=0;MxLinesPerPage :=60;
  {now print}
  Printer.BeginDoc;
  XPos := 25; {100;}
  ScMult :=10;
  PageX:= Printer.PageWidth;
  PageY :=Printer.PageHeight;
  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
  ScaleY := (PageY * ScMult) div 1000; {formheight}

  Repeat
   If (FirstTimeSw) or (LineCnt >MxLinesPerPage) then
   begin  {print headers}
     LineCnt:=1;
     Inc(PageCnt);
     If not FirstTimeSw then Printer.NewPage;

     Printer.Canvas.Font.Name := 'Arial';
     Printer.Canvas.Font.Size := 10;
     Printer.Canvas.Font.Style := [fsBold];
     Printer.Canvas.TextOut(
       (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
        Hdr1+' Page: '+IntToStr(PageCnt));

     Inc(LineCnt); {leave empty line}
     Printer.Canvas.Font.Name := 'Courier New';
     Printer.Canvas.Font.Size := 8;
     Printer.Canvas.Font.Style := [];
     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr2);

     Inc(LineCnt);
     Printer.Canvas.TextOut(
        (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,Hdr3);
     Inc(LineCnt,1);
   end; {headers}
   FirstTimeSw := False;
   Printer.Canvas.Font.Style := [];
   Readln(F1,s);
   Printer.Canvas.TextOut(
    (XPos * ScaleX) div ScMult,(LineCnt*15 * ScaleY) div ScMult,
          s);
   Inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  Result := True;
end;

Function PrintLabels(DataDir,FileNm:String):boolean;
var
  Tbl:TTable;
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap : Integer;

  column1,column2,column3 : Integer;

  Line1,Line2,Line3,Line4,Line5:String;
  Postal,Postal1,Postal2:String;
begin
 {Set up label parameters}

  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);

{
  TopMargin  := Trunc(0.5 *  PixPerInY);
  LeftMargin := Trunc(1/8 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  //1 inch
  LabelWidth := Trunc(2.5 * PixPerInX);  //2.5 inches
  VertIncr :=  Trunc(PixPerInY * (1/6)); //6 lines per inch
  HorizLabelGap := Trunc(1/8 *  PixPerInX);
}

  TopMargin  := Trunc(0.45   *  PixPerInY);
  LabelHeight:= Trunc(1     * PixPerInY);  {1 inch}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}

  //LeftMargin := Trunc(0.126 *  PixPerInY);
  //LabelWidth := Trunc(2.5   * PixPerInX);    {2.5 inches}
  //HorizLabelGap := Trunc(0.1 *  PixPerInX);

  //use fixed columns instead
  column1 := Trunc(0.128 * PixPerInY);
  column2 := Trunc(2.945 * PixPerInY);
  column3 := Trunc(5.655 * PixPerInY);

  {open the input file of keys}
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  {start printer}
  Printer.BeginDoc;
  { Get data from data base}
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := DataDir;
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'NAME';
  If Tbl.Active then Tbl.Close;
  Delay(1000);
  Tbl.Open;
  Tbl.IndexName := 'NAME';  //20110411

  RecNo :=0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    if Tbl.FindKey([InpKey]) then
     begin
      Inc(RecNo);
      If RecNo >30 then begin RecNo :=1; Printer.NewPage; end;
      Line1 := Tbl.FieldByName('NAME').AsString;
      Line2 := Tbl.FieldByName('Contact').AsString;
      Line3 := RemoveChar(UpperCase(Tbl.FieldByName('STREET').AsString),'#');
      Postal:=RemoveChar(Tbl.FieldByName('POSTAL').AsString,' ');
      Postal1:=LeftStr(postal,3);
      Postal2:=MidStr(postal,4,5);
      Line4 := Uppercase(Tbl.FieldByName('CITY').AsString)+
               ' '+UpperCase(Tbl.FieldByName('PROVINCE').AsString)
               +' '+UpperCase(Postal1+' '+Postal2);
      Line5 := 'Tel: ('+
               Tbl.FieldByName('AreaP').AsString+') '+
               Tbl.FieldByName('PHONE').AsString;
      
      If RecNo < 11 then  {left label}
        begin
         LabelPosX := column1; //LeftMargin;//+HorizLabelGap;
         LabelPosY := TopMargin+(RecNo-1)*LabelHeight;
        end;
      If (RecNo >10) and (RecNo < 21) then  {Midle label}
         begin
         LabelPosX := column2; //LeftMargin + LabelWidth + HorizLabelGap;
         LabelPosY := TopMargin+(RecNo-11)*LabelHeight;
         end;
      If (RecNo >20) then  {right label}
          begin
          LabelPosX := column3; //LeftMargin + LabelWidth * 2 + HorizLabelGap * 2;
          LabelPosY := TopMargin+(RecNo-21)*LabelHeight;
          end;
      PrintALabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4,Line5);
     end;
  end; {end while}

  CloseFile(InpFile);
  Tbl.Free;
  Printer.EndDoc;
  Result := True;
end;

Procedure PrintALabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Courier New';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 10;
  XPos := LabelPosX +2;
  YPos := LabelPosY+2;
  VertIncr := Trunc(PixPerInY * (1/6));
  Printer.Canvas.Font.Style := [fsBold];
  Printer.Canvas.TextOut(XPos,YPos,Line1);
  //Printer.Canvas.Font.Style := [];
  Printer.Canvas.TextOut(XPos,YPos+1 * VertIncr,Line2);
  Printer.Canvas.TextOut(XPos,YPos+2 * VertIncr,Line3);
  Printer.Canvas.TextOut(XPos,YPos+3 * VertIncr,Line4);
  Printer.Canvas.TextOut(XPos,YPos+4 * VertIncr,Line5);
end;

Function PrintListing(DataDir,FileNm:String):boolean;
var
  Tbl:TTable;
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap
     : Integer;
  Line1,Line2,Line3,Line4,Line5:String;
  Postal,Postal1,Postal2:String;
begin
 {Set up label parameters}

  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  TopMargin  := Trunc(0.5 *  PixPerInY);
  LeftMargin := Trunc(1/8 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
  LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}
  HorizLabelGap := Trunc(1/8 *  PixPerInX);

  {open the input file of keys}
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  {start printer}
  Printer.BeginDoc;
  { Get data from data base}
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := DataDir;
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'NAME';
  If Tbl.Active then Tbl.Close;
  Tbl.Open;

  RecNo :=0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    if Tbl.FindKey([InpKey]) then
     begin
      Inc(RecNo);
      If RecNo >55 then begin RecNo :=1; Printer.NewPage; end;
      Postal:=RemoveChar(Tbl.FieldByName('POSTAL').AsString,' ');
      Postal1:=LeftStr(postal,3);
      Postal2:=MidStr(postal,4,5);
      Line1 := AllTrim(Tbl.FieldByName('NAME').AsString)+ ' '
          +AllTrim(Tbl.FieldByName('Contact').AsString)+ ' '
          +AllTrim(RemoveChar(UpperCase(Tbl.FieldByName('STREET').AsString),'#'))+' '
          +AllTrim(Uppercase(Tbl.FieldByName('CITY').AsString))+
          ' '+AllTrim(UpperCase(Tbl.FieldByName('PROVINCE').AsString))
          +' '+AllTrim(UpperCase(Postal1+' '+Postal2));
      PrintALine(1,1,Line1);
     end;
  end; {end while}

  CloseFile(InpFile);
  Tbl.Free;
  Printer.EndDoc;
  Result := True;
end;

Procedure PrintALine(LabelPosX,LabelPosY:integer;Line1:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Courier New';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 10;
  XPos := LabelPosX +2;
  YPos := LabelPosY+2;
  VertIncr := Trunc(PixPerInY * (1/6));
  Printer.Canvas.Font.Style := []; //[fsBold];
  Printer.Canvas.TextOut(XPos,YPos,Line1);
  //Printer.Canvas.TextOut(XPos,YPos+1 * VertIncr,Line1);
end;

Procedure ParseWords(S:String;Delim:String;Var WList:TstringList);
Var i,FromI,ToI:Integer;Wrd:String;
{when calling s:=s+delimiter may need a delimiter at the end in case tere is no last value}
begin
 s:=AllTrim(S);
 Wlist.Clear;
 If s ='' then exit;
 i:=1;
 FromI:=1;
 ToI:=Length(s);
 Repeat
    If (i>ToI) or (S[i] = Delim) then
    begin
       Wrd := MidStr(S,FromI,i-FromI);
       WList.Add(Wrd);
       FromI:=i+1;
       Inc(i);
       If (FromI>ToI) or (i>ToI) then break;
    end
    else
     Inc(i);
 until i>ToI+1;
end;

Function FindWord(ThisWord,Ln:String):Integer;
Var Place:Integer;
begin
 Result := pos(UpperCase(ThisWord), Uppercase(Ln));
end;

Function RemoveChar(S:string;Ch:String):string;
Var i:integer;
begin
 Result:='';
 For i:=1 to Length(s) do
   If s[i] <>Ch then result:=result+s[i];
end;


(*
Function TClients.PrintKeyLabels(DataDir,FileNm:String):boolean;
var
  Tbl:TTable;
  i,RecNo,LineCnt,MxLinesPerPage,PageCnt:integer;
  PrnFile: TextFile;
  XPos :LongInt;YPos : LongInt;
  InpFile :TextFile;InpKey:String;
  PixPerInX, PixPerInY : Integer;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap
     : Integer;
  Line1,Line2,Line3,Line4,Line5:String;
begin
 {Set up label parameters}

  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  TopMargin  := Trunc(0.5 *  PixPerInY);
  LeftMargin := Trunc(1/8 *  PixPerInY);
  LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
  LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
  VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}
  HorizLabelGap := Trunc(1/8 *  PixPerInX);

  {open the input file of keys}
  AssignFile(InpFile, FileNm);
  Reset(InpFile);
  {start printer}
  Printer.BeginDoc;
  { Get data from data base}
  Tbl := TTable.Create(Application);
  Tbl.DataBaseName := DataDir;
  Tbl.TableName := 'CLIENTS.DBF';
  Tbl.IndexName := 'NAME';
  If Tbl.Active then Tbl.Close;
  Tbl.Open;

  RecNo :=0;
  while not Eof(InpFile) do
  begin
    ReadLn(InpFile, InpKey);
    if Tbl.FindKey([InpKey]) then
     begin
      Inc(RecNo);
      If RecNo >30 then begin RecNo :=1; Printer.NewPage; end;
      Line1 := '2001 Auth keys '+Tbl.FieldByName('NAME').AsString;
      Line2 := Tbl.FieldByName('T1Key').AsString;
      Line3 := Tbl.FieldByName('T2Key').AsString;
      Line4 := Tbl.FieldByName('TFKey').AsString;
      Line5 := Tbl.FieldByName('FP').AsString;

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
      PrintAKeyLabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4,Line5);
     end;
  end; {end while}

  CloseFile(InpFile);
  Tbl.Free;
  Printer.EndDoc;
  Result := True;
end;

Procedure TClients.PrintAKeyLabel(LabelPosX,LabelPosY:integer;Line1,Line2,Line3,Line4,Line5:String);
{pos in pixels}
Var
XPos, YPos, VertIncr,PixPerInX,PixPerInY : Integer;
begin
  Printer.Canvas.Font.Name := 'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 8;
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
*)

Procedure ShowTimedMsg(Msg:String;DelayTime:Integer);
Begin
  DelayMsg:=Msg;
  Application.CreateForm(TTimedMsg,TimedMsg);
  TimedMsg.Show;
  Delay(DelayTime);
  TimedMsg.CloseBtnClick(Application);
  TimedMsg.Close;
end;

Procedure Delay(ms:LongInt);
Var TheTime :LongInt;
begin
 TheTime :=GetTickCount+Ms;
 While GetTickCount < TheTime do Application.ProcessMessages;
end;

function GetFileList(FDirectory, Filter: TFileName): TStringList;
var
  ARec: TSearchRec;
  Res: Integer;
begin
  if FDirectory[Length(FDirectory)] <> '\' then
    FDirectory := FDirectory + '\';
  Result := TStringList.Create;
  try
    Res := FindFirst(FDirectory + Filter, faAnyFile, ARec);
    while Res = 0 do
    begin
      if FileExists(FDirectory + ARec.Name) then
        Result.Add(FDirectory + ARec.Name);

      Res := FindNext(ARec);
    end;
    SysUtils.FindClose(ARec);
  except
    Result.Free;
  end;
end;


(*
procedure MergeFiles(FirstSplitFileName, OutFileName : TFileName) ;
// FirstSplitFileName == the name of the first piece of the split file
// OutFileName == the name of the resulting merged file
var
   fs, ss: TFileStream;
   cnt: integer;
begin
   cnt := 1;
   fs := TFileStream.Create(OutFileName, fmCreate or fmShareExclusive) ;
   try
     while FileExists(FirstSplitFileName) do
     begin
       ss := TFileStream.Create(FirstSplitFileName, fmOpenRead or fmShareDenyWrite) ;
       try
         fs.CopyFrom(ss, 0) ;
       finally
         ss.Free;
       end;
       Inc(cnt) ;
       FirstSplitFileName := ChangeFileExt(FirstSplitFileName, Format('%s%d', ['._',cnt])) ;
     end;
   finally
     fs.Free;
   end;
end;
*)

Function AppendAFile(SourceName: string; DestinationName: string): boolean;
{full path is assumed}
var
  i:Integer;
  FromF,ToF: Textfile;
  TempList:TStringList;
begin
  TempList:=TStringList.Create;
  Result := False;
  If UpperCase(SourceName) = UpperCase(DestinationName) then exit;
  If Not FileExists(SourceName) then exit;
  TempList.LoadFromFile(SourceName);
  AssignFile(ToF, DestinationName);
  Append(ToF);

  For i:=0 to TempList.count-1 do
   begin
    If LeftStr(TempList[i],16)>'' then Writeln(ToF,TempList[i]);
   end;
  Flush(ToF);  { ensures that the text was actually written to file }
  CloseFile(ToF);
  CloseFile(FromF);
  TempList.Free;
  Result := True;
end;


function SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
// scalabium.com/faq/dct0115.htm
var
  Message: TMapiMessage;
  lpSender, lpRecipient: TMapiRecipDesc;
  FileAttach: TMapiFileDesc;

  SM: TFNMapiSendMail;
  MAPIModule: HModule;
begin
  FillChar(Message, SizeOf(Message), 0);
  with Message do
  begin
    if (Subject <> '') then
      lpszSubject := PChar(''+Subject);

    if (Body <> '') then
      lpszNoteText := PChar(''+Body);

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PChar(''+SenderEMail)
      else
        lpSender.lpszName := PChar(''+SenderName);
      lpSender.lpszAddress := PChar(''+SenderEmail);
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;

      if (RecipientName = '') then
        lpRecipient.lpszName := PChar(''+RecipientEMail)
      else
        lpRecipient.lpszName := PChar(''+RecipientName);

      lpRecipient.lpszAddress := PChar(''+'SMTP:'+RecipientEmail);  //added SMTP: //20111122 //john
      lpRecipient.ulReserved := 0;
      lpRecipient.ulEIDSize := 0;
      lpRecipient.lpEntryID := nil;
      nRecipCount := 1;
      lpRecips := @lpRecipient;
    end
    else
      lpRecips := nil;

    if (FileName = '') then
    begin
      nFileCount := 0;
      lpFiles := nil;
    end
    else
    begin
      FillChar(FileAttach, SizeOf(FileAttach), 0);
      FileAttach.nPosition := Cardinal($FFFFFFFF);
      FileAttach.lpszPathName := PChar(''+FileName);

      nFileCount := 1;
      lpFiles := @FileAttach;
    end;
  end;

  MAPIModule := LoadLibrary(PChar(MAPIDLL));
  Delay(500);
  if MAPIModule = 0 then
    Result := -1
  else
    try
      @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
      if @SM <> nil then
      begin
        Result := SM(0, Application.Handle, Message, MAPI_DIALOG or MAPI_LOGON_UI, 0);
      end
      else
        Result := 1;
    finally
      FreeLibrary(MAPIModule);
    end;

  if Result <> 0 then
    MessageDlg('Error sending mail (' + IntToStr(Result) + ').', mtError,[mbOK], 0);
end;


procedure EMailInvoice(SomeSubject,SomeText,SomeAttachment,SomeRecipientEMail:String);
Var i:Integer;Dir,FlName:String;
SomeSenderEMail:String;
InvoiceContent: Widestring;
RichText: WideString;
h:THandle;
begin
  SomeSenderEmail:='Sales@visualtax.com';
  //Svisualtax@sympatico.ca';

  //temporary
  SomeText:='';
  {
  SomeText:='The program keys will be Email before Dec 15, 2016'
                + Chr(10)+Chr(13)
                + Chr(10)+Chr(13);
  }
  // --------------

  SomeText:= SomeText+'The Invoice/Receipt is attached.'
                + Chr(10)+Chr(13)
                + Chr(10)+Chr(13)
                +'Thank you '
                + Chr(10)+Chr(13)
                +'Microsophic Inc.';


  SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEmail);

 // SendSMTPMail(SomeSubject, SomeText, SomeAttachment, '','','',SomeRecipientEmail, '','');  //fails  //20151115

  (*
----------------------------------------------------------------------------------------

  //20111108 //john using shellexecute, does not attach attachment

  SomeText:=    'Please see attached.'
                + '%0D%0A'
                +'Your program activation keys will be Emailed by Dec 15, 2011'
                + '%0D%0A'
                +'Thank you '
                + '%0D%0A'
                +'Microsophic Inc.';

   // ShellExecute(application.handle,nil,Pchar(''+ 'mailto:'+ SomeRecipientEMail  +'?Subject=' + SomeSubject + '&Body=' + SomeText + '&Attach=' +'&quot;'+ SomeAttachment +'&quot;'), nil, nil, SW_NORMAL);

----------------------------------------------------------------------------------------
  *)

  //20111120  embedded message
  // InvoiceContent:='';GetHtmlInvoiceContent(SomeAttachment,InvoiceContent);  //it does not work with Invoice Content instead of sometext - no email sent
  //h:= ShellExecute(application.handle,nil,Pchar(''+ 'mailto:'+ SomeRecipientEMail  +'?Subject='+SomeSubject + '&Body=' + InvoiceContent + '&Attach=' + SomeAttachment), nil, nil, SW_NORMAL);
  //  ShowMessage(IntTostr(h));

end;


Function GetHtmlInvoiceContent(SourceName: string; Var DestinationBuffer:WideString): boolean;
{full path is assumed}
var
  FromF: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..2048] of Char;
begin
  Result := False;
  AssignFile(FromF, SourceName);
  Reset(FromF, 1);	{Record size = 1 }
 // AssignFile(ToF, DestinationName);	{ Open output file }
 // Rewrite(ToF, 1);	{Record size = 1 }
  repeat
   BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
   DestinationBuffer:=DestinationBuffer+Buf;
   until (NumRead = 0) or (NumWritten <> NumRead);
  System.CloseFile(FromF);
  Result := True;
end;



Function GetDefaultEmailAddress:String;
var
Registry: TRegistry;
AccountStr: string;
begin
 Registry := TRegistry.Create;
 try
 Registry.RootKey := HKEY_CURRENT_USER;
 if Registry.OpenKey('software\microsoft\internet account manager', False) then {}
 begin
  AccountStr := Registry.ReadString('default mail account');
  Registry.CloseKey;
  if (AccountStr <> '') then
  if Registry.OpenKey('software\microsoft\internet account manager\accounts\' + AccountStr, False) then {}
  begin
  //SMTPEdt.Text := Registry.ReadString('SMTP Server');
   Result:= Registry.ReadString('SMTP Email Address');
   Registry.CloseKey;
  end;
 end;
 finally
 Registry.Free;
 end;
end;

Function GenerateRandomNumber(MaxInt:LongInt):LongInt;
begin
 Randomize;
 Result:=Random(MaxInt);
end;

Function GenerateRandomString(MaxLength:Integer):String;
Var Str:String;
begin
 Randomize;
 //string with all possible chars
 str := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
 Result := '';
 repeat
   Result := Result + str[Random(Length(str)) + 1];
 until (Length(Result) = MaxLength)
end;

Procedure AnalyseEfileLog(FlName:String);
Var i:Integer;TempList,TempList2,WList:TStringList;S,Nm,T1Key,PrevT1Key,PrevNm,Addr,PrevAddr:String;
    KeyCnt:Integer; Efiler,PrevEfiler:String;
    h:THandle;
begin
 PrevT1Key:='';
 PrevNm:='';
 PrevAddr:='';
 PrevEfiler:='';
 Templist:=TstringList.Create;
 TempList2:=TstringList.Create;
 WList:=TstringList.Create;
 TempList.LoadFromFile(FlName);

 TempList.Sorted:=True;
 //first rec //not 0
 If TempList.count>0 then  //20150409
  s:=TempList[1]
 else
  s:='';
 //If s='' then s:='||||||||';
 ParseWords(S,'|',WList);
 PrevT1Key:=Wlist[0];
 PrevNm:=UpperCase(Wlist[1]);
 If Wlist.Count>8 then
  PrevEfiler:=UpperCase(Wlist[8])
 else
  PrevEfiler:='';
 For i:=2 to TempList.Count-1 do
 begin
   //If UpperCase(s)='ZZZEND' then break;
   s:=TempList[i]+'|';
   ParseWords(S,'|',WList);
   T1Key:=Wlist[0];
   Nm:=UpperCase(Wlist[1]);
   Addr:=UpperCase(Wlist[2]);
   If Wlist.Count>7 then
    Efiler:=UpperCase(Wlist[8])
   else
    Efiler:='';
   If T1Key=PrevT1Key then
   begin
     If Efiler <> PrevEfiler then
     //(Nm<>PrevNm) or (Addr <> PrevAddr) then
     begin
       TempList2.Add(PrevT1Key+' '+PaddR(PrevNm,30)+' '+PrevAddr+'***'+PrevEfiler);
       TempList2.Add(T1Key+' '+PaddR(Nm,30)+' '+Addr+'***'+Efiler);
       TempList2.Add(' ');
       PrevT1Key:=T1Key;
       PrevNm:=Nm;
       PrevAddr:=Addr;
       PrevEfiler:=Efiler;
     end;
   end
   Else //higher key
   begin
     PrevT1Key:=T1Key;
     PrevNm:=Nm;
     PrevAddr:=Addr;
     PrevEfiler:=Efiler;
   end;
 end;

 TempList2.SaveToFile(T1LogsDir+'\'+'Offenders.txt');
 h:=ShellExecute(Application.Handle,'open','c:\windows\notepad.exe',Pchar(T1LogsDir+'\'+'Offenders.txt'),nil,SW_SHOWNORMAL);
 If h<=32 then ShowMessage('File not found: OffendersT2.txt');
 WList.Free;
 //save sorted all files
 TempList.SaveToFile(FlName);
 TempList.Free;
end;


Procedure AnalyseEfileLogT2(FlName:String);
Var i:Integer;TempList,TempList2,WList:TStringList;S,Nm,T1Key,PrevT1Key,PrevNm,Addr,PrevAddr:String;
    KeyCnt:Integer; Efiler,PrevEfiler:String;
    PFlName:String;
    h:THandle;
begin
 PrevT1Key:='';
 PrevNm:='';
 PrevAddr:='';
 PrevEfiler:='';
 Templist:=TstringList.Create;
 TempList2:=TstringList.Create;
 WList:=TstringList.Create;
 TempList.LoadFromFile(FlName);

 TempList.Sorted:=True;
 //first rec //not 0
 s:=TempList[1];
 //If s='' then s:='||||||||';
 ParseWords(S,'|',WList);
 PrevT1Key:=Wlist[0];
 PrevNm:=UpperCase(Wlist[1]);
 If Wlist.Count>8 then
  PrevEfiler:=UpperCase(Wlist[8])
 else
  PrevEfiler:='';
 For i:=2 to TempList.Count-1 do
 begin
   //If UpperCase(s)='ZZZEND' then break;
   s:=TempList[i]+'|';
   ParseWords(S,'|',WList);
   T1Key:=Wlist[0];
   Nm:=UpperCase(Wlist[1]);
   Addr:=UpperCase(Wlist[2]);
   If Wlist.Count>7 then
    Efiler:=UpperCase(Wlist[8])
   else
    Efiler:='';
   If T1Key=PrevT1Key then
   begin
     If Efiler <> PrevEfiler then
     //(Nm<>PrevNm) or (Addr <> PrevAddr) then
     begin
       TempList2.Add(PrevT1Key+' '+PaddR(PrevNm,30)+' '+PrevAddr+'***'+PrevEfiler);
       TempList2.Add(T1Key+' '+PaddR(Nm,30)+' '+Addr+'***'+Efiler);
       TempList2.Add(' ');
       PrevT1Key:=T1Key;
       PrevNm:=Nm;
       PrevAddr:=Addr;
       PrevEfiler:=Efiler;
     end;
   end
   Else //higher key
   begin
     PrevT1Key:=T1Key;
     PrevNm:=Nm;
     PrevAddr:=Addr;
     PrevEfiler:=Efiler;
   end;
 end;

 TempList2.SaveToFile(T2LogsDir+'\'+'OffendersT2.txt');
 h:=ShellExecute(Application.Handle,'open','c:\windows\notepad.exe',Pchar(T2LogsDir+'\'+'OffendersT2.txt'),nil,SW_SHOWNORMAL);
 If h<=32 then ShowMessage('File not found: OffendersT2.txt');
 WList.Free;
 //save sorted alllogs
 TempList.SaveToFile(FlName);
 TempList.Free;
end;

Function GetTaxRate(Prov:String):Real;
begin
  //20161205
  Result:=5;
  If     (UpperCase(Prov)='ON') then  result:=13
  else if UpperCase(Prov)='PE' then  result:=15
  else if UpperCase(Prov)='NS' then  result:=15
  else if UpperCase(Prov)='NB' then  result:=15
  else if UpperCase(Prov)='NL' then  result:=15;
end;


Function ValidDate(s:String):Boolean;
//expected dt format yyyymmdd
const
 DaysOfMonth: array[1..12] of String = ('31', '29', '31', '30', '31', '30', '31', '31', '30', '31', '30', '31');
Var yyyy,mm,dd:String;
begin
 Result := true;
 If s ='' then exit;
 If (length(s)<>8) or (not Numeric(s)) then Begin Result:=False;Exit;end;
 yyyy:=LeftStr(s,4);
 mm:=MidStr(s,5,2);
 dd:=RightStr(s,2);
 If (not InNumRange(dd,'01','31'))
 or (not InNumRange(mm,'01','12'))
 or (not PureNumeric(mm))
 or (not PureNumeric(dd))
 then Result := False;

 if (not IsLeapYear(StrToInt(yyyy))) and (mm = '02') and (dd = '29') then begin Result:=False;Exit;End;
 if not InNumRange(dd,'01', DaysofMonth[MyStrToInt(mm)]) then begin Result:=False;Exit;End;
end;

Function PureNumeric(S:string):Boolean;  //20141013
Var i:integer;
begin
 If s ='' then begin Result := false;exit;end;
 For i:= 1 to Length(S) do
 If S[i] in ['0','1','2','3','4','5','6','7','8','9'] then
   Result := True
  else
   begin Result := False;Exit; end;
end;

//20151110 Igor
function SendSMTPMail(const Subject, Body, FileName, SenderName, SenderEMail, RecipientName, RecipientEMail, Host, UserID: string): Integer;
var
  Mail: TNMSMTP;
begin
  Mail := TNMSMTP.Create(nil);

  try
    // connect
    Mail.Host := Host;
    Mail.UserID := UserID;
    Mail.Connect;

    // set the fixed part of the header
    Mail.PostMessage.FromAddress := UserID;
    Mail.PostMessage.FromName := SenderName;
    Mail.PostMessage.ToAddress.Clear;
    Mail.PostMessage.ToAddress.Add (RecipientEMail);
    Mail.PostMessage.Subject := Subject;
    Mail.PostMessage.Body.Text := Body;
    if FileName <> '' then
       Mail.PostMessage.Attachments.Add(FileName);

    Mail.SendMail;

    // we're done
    Mail.Disconnect;
  finally
    Mail.Free;
  end;
end;

(*function SendMAPIMail1(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
// scalabium.com/faq/dct0115.htm
var
  Message: TMapiMessage;
  lpSender, lpRecipient: TMapiRecipDesc;
  FileAttach: TMapiFileDesc;

  SM: TFNMapiSendMail;
  MAPIModule: HModule;
begin
  FillChar(Message, SizeOf(Message), 0);
  with Message do
  begin
    if (Subject <> '') then
      lpszSubject := PChar(''+Subject);

    if (Body <> '') then
      lpszNoteText := PChar(''+Body);

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PChar(''+SenderEMail)
      else
        lpSender.lpszName := PChar(''+SenderName);
      lpSender.lpszAddress := PChar(''+SenderEmail);
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;

      if (RecipientName = '') then
        lpRecipient.lpszName := PChar(''+RecipientEMail)
      else
        lpRecipient.lpszName := PChar(''+RecipientName);

      lpRecipient.lpszAddress := PChar(''+'SMTP:'+RecipientEmail);  //added SMTP: //20111122 //john
      lpRecipient.ulReserved := 0;
      lpRecipient.ulEIDSize := 0;
      lpRecipient.lpEntryID := nil;
      nRecipCount := 1;
      lpRecips := @lpRecipient;
    end
    else
      lpRecips := nil;

    if (FileName = '') then
    begin
      nFileCount := 0;
      lpFiles := nil;
    end
    else
    begin
      FillChar(FileAttach, SizeOf(FileAttach), 0);
      FileAttach.nPosition := Cardinal($FFFFFFFF);
      FileAttach.lpszPathName := PChar(''+FileName);

      nFileCount := 1;
      lpFiles := @FileAttach;
    end;
  end;

  MAPIModule := LoadLibrary(PChar(MAPIDLL));
  Delay(500);
  if MAPIModule = 0 then
    Result := -1
  else
    try
      @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
      if @SM <> nil then
      begin
        Result := SM(0, Application.Handle, Message, MAPI_DIALOG or MAPI_LOGON_UI, 0);
      end
      else
        Result := 1;
    finally
      FreeLibrary(MAPIModule);
    end;

  if Result <> 0 then
    MessageDlg('Error sending mail (' + IntToStr(Result) + ').', mtError,[mbOK], 0);
end;*)



end.
