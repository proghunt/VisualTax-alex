unit Mystr;
{$B-}

interface
 uses
 SysUtils,FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
 Forms, StdCtrls,Dialogs,DBctrls,ExtCtrls,Printers,DB, DBTables,
 UDecl;

{Const}
{Space = #$20;}
{Function UpperFirstLetter(Value:String):string;}
  {Procedure GetTaxEnviron;}

  Function Numeric(S:string):Boolean;
  Function GetTodaysMonth:String;
  Function GetTodaysDay:String;
  Function PrintSomeFile(FileNm: String):boolean;
  Function RmvLeadingZeros(S:string):string;
  Function ChkDigit(SiNum8: string):Integer;
  Function InitParms: boolean;
  Function MakeEFFileName(LicenseLevel:string):string;
  Procedure InitCfgOptions;
  Procedure CfgToMem;
  Procedure InitDataPacScript(EFileHost:String);
  Procedure InitFasPacScript(EFileHost:String);
  Function OpenCfg: boolean;
  Function VL(s: string):Real;

  Function CopyFile(SourceName: string; DestinationName: string): boolean;
  Function JustRight(S:String;MaxLength: integer): string;
  Function IsInList(Astring:String; SomeList: TstringList):Integer;
  function LTrim(Const Str: String): String;
  function RTrim(Str: String): String;
  function AllTrim(Str: String):  String;
  function RightStr(Const Str: String; Size: Word): String;
  function LeftStr(Const Str: String; Size: Word): String;
  {function MidStr(Const Str: String; Size: Word): String;}
  function MidStr(Const Str: String; StartPos :Word; Size: Word): String;
  Function FilledStr(Count: Word; ch: char):String;  {mine Returns a string of x chars}
  Function Space(Count: Word):String;  {Returns a string of count spaces}
  Function PaddCount(s: string; maxLength: integer):Integer;
  Function PaddR(S: string;MaxLength: integer):String;
  Function PaddZero(S:string;MaxLength:Integer):string;
  Function InsertCommas(s: string):String;


implementation
  function LTrim(Const Str: String): String;
  var len: Byte absolute Str;
      i: Integer;
  begin
    i := 1;
    while (i <= len) and (Str[i] = Space(1)) do Inc(i);
    LTrim := Copy(Str,i,len);
  end {LTrim};

  function RTrim(Str: String): String;
  var len: Byte absolute Str;
  begin
    while (Str[len] = Space(1)) do Dec(len);
     Result := Str;
    {RTrim := Str}
  end {RTrim};

  function AllTrim(Str: String): String;
  begin
    Result := LTrim(RTrim(Str))
  end {Trim};

  function RightStr(Const Str: String; Size: Word): String;
  var len: Byte absolute Str;
  begin
    if Size > len then Size := len;
    Result := Copy(Str,len-Size+1,Size)
    {RightStr := Copy(Str,len-Size+1,Size)}
  end {RightStr};

  function LeftStr(Const Str: String; Size: Word): String;
  begin
    {LeftStr := Copy(Str,1,Size)}
    Result := Copy(Str,1,Size)
  end {LeftStr};

  function MidStr(Const Str: String;StartPos: Word; Size: Word): String;
  var len: Byte absolute Str;
  begin
    Result := Copy(Str,StartPos,Size);
  end {MidStr};

 (*
  function MidStr(Const Str: String; Size: Word): String;
  var len: Byte absolute Str;
  begin
    if Size > len then Size := len;
    MidStr := Copy(Str,((len - Size) div 2)+1,Size)
  end {MidStr};
  *)
  Function FilledStr(Count: Word; ch: char):String;
   {returns a string with Count spaces, or other character}
    var
     S: String;
    begin
     { Set a string to all spaces }
     SetLength(S, Count+1);
      FillChar(S, Count+1, ch);
      Result := S;

    end;

 Function Space(Count: Word):String;
   {returns a string with Count spaces}
    var
     S: String;
    begin
     { Set a string to all spaces }
      SetLength(S, Count + 1);
      FillChar(S, Count+1, ' ');
      Result := S;
  end;


Function CopyFile(SourceName: string; DestinationName: string): boolean;
{full path is assumed}
var
  FromF, ToF: file;
  NumRead, NumWritten: integer;
  Buf: array[1..2048] of Char;
begin
  Result := False;
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

Function InsertCommas(s: string):String;
Var SignPart: string[1];
begin
 S := LTrim(s);
 If LeftStr(S,1) = '-' then
  begin SignPart := '-'; s := RightStr(s,Length(s)-1);end
 else
  SignPart :='';

 Result := SignPart+s;
 Case Length(s) of
  4 : Result := SignPart+LeftStr(S,1)+','+RightStr(S,3);
  5 : Result := SignPart+LeftStr(S,2)+','+RightStr(S,3);
  6 : Result := SignPart+LeftStr(S,3)+','+RightStr(S,3);
  7 : Result := SignPart+Leftstr(s,1)+','+MidStr(S,3,3)+','+RightStr(S,3);
  8 : Result := SignPart+Leftstr(s,2)+','+MidStr(S,3,3)+','+RightStr(S,3);
  9 : Result := SignPart+Leftstr(s,3)+','+MidStr(S,3,3)+','+RightStr(S,3);
 { 10: Result := Leftstr(s,3)+','+MidStr(S,3,3)+','+RightStr(S,3);}
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
Function IsInList(Astring:String; SomeList: TstringList):Integer;
var i : integer;
begin
   Result := -1;
   For i := 0 to SomeList.Count-1 do
   if Astring = SomeList[i] then
    begin Result := i; exit end;
end;

Function VL(s: string):Real;
Var
Code : integer;
begin
 If s ='' then begin Result := 0; exit;end;
 Val(s,Result,Code);
end;

(*
Procedure GetTaxEnviron;
Var TempList : TstringList;
begin
 TempList := TstringList.Create;
 TempList.LoadFromFile(AppDir+'\'+'Environ.d');
 TaxPgmDir := Templist[0];
 templist.free;
end;
*)

Procedure InitCfgOptions;
begin
 If OpenCfg = false then
   begin
   ShowMessage('Configuration file cannot be opened');
   Application.Terminate;
   exit;
   end;
 CfgToMem;  {keep cfg in mem}
 CfgTbl.Close;
end;

Procedure InitDataPacScript(EFileHost:String);
var
  TempList: TStrings;	{ declare the list }
  ScriptFile :String;
  i :integer;
begin
  TempList := TStringList.Create;	{ construct the list object }
  ScriptFile := 'DATAPAC.tpl';
  try
    TempList.LoadFromFile (AppDir + '\' + ScriptFile);
    for i := 0 to TempList.Count - 1 do
    begin
         if (Pos ('$DATAPACUSERID$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE=NUI ' + CfgRec.Ef_NUI;
         if (Pos ('$DATAPACPASSWORD$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE=' + CfgRec.Ef_NuiPass;
         if (Pos ('$REVCANNUMBER$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE=' + CfgRec.Ef_TransNo;
         if (Pos ('$REVCANPASSWORD$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE=' + CfgRec.Ef_PsWord;
         if (Pos ('$HOSTNUMBER$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE=' + EfileHost; {CfgRec.Ef_ProdNo;}
    end;
    TempList.SaveToFile (AppDir + '\' + ChangeFileExt(ScriptFile, '.CFG'));
  finally
    TempList.Free;	{ destroy the list object }
  end;
end;

Procedure InitFasPacScript(EFileHost:String);
var
  TempList: TStrings;	{ declare the list }
  ScriptFile :String;
  i :integer;
begin
  TempList := TStringList.Create;	{ construct the list object }
  ScriptFile := 'FASPAC.tpl';
  try
    TempList.LoadFromFile (AppDir + '\' + ScriptFile);
    for i := 0 to TempList.Count - 1 do
    begin
         if (Pos ('$FASPACSTRING$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE='+'N'+CfgRec.Ef_NUI+'-'+EfileHost;
         if (Pos ('$USERNAME$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE=' + CfgRec.Ef_TransNo;
         if (Pos ('$REVCANPASSWORD$',  TempList[i]) <> 0) then
            TempList[i] := 'RESPONSE=' + CfgRec.Ef_PsWord;
    end;
    TempList.SaveToFile (AppDir + '\' + ChangeFileExt(ScriptFile, '.CFG'));
  finally
    TempList.Free;	{ destroy the list object }
  end;
end;


Procedure CfgToMem;
begin
  With CfgTbl do
   begin
   CfgRec.Dir_Cur        :=FieldByName('Dir_Cur').AsString;
   CfgRec.Dir_Deflt      :=FieldByName('Dir_Deflt').AsString;
   CfgRec.Dir_LastYr     :=FieldByName('Dir_LastYr').AsString;
   CfgRec.Dir_AutoFill   :=FieldByName('Dir_AutoFill').AsString;  //20160307
   CfgRec.Dir_PrvLYr     :=FieldByName('Dir_PrvLYr').AsString;
   CfgRec.Dir_Train      :=FieldByName('Dir_Train').AsString;
   CfgRec.Dir_Sample     :=FieldByName('Dir_Sample').AsString;

   CfgRec.Prp_Name       :=FieldByName('Prp_Name').AsString;
   CfgRec.Prp_Street     :=FieldByName('Prp_Street').AsString;
   CfgRec.Prp_City       :=FieldByName('Prp_City').AsString;
   CfgRec.Prp_Prov       :=FieldByName('Prp_Prov').AsString;
   CfgRec.Prp_Postal     :=FieldByName('Prp_Postal').AsString;
   CfgRec.Prp_Countr     :=FieldByName('Prp_Countr').AsString;
   CfgRec.Prp_Area       :=FieldByName('Prp_Area').AsString;
   CfgRec.Prp_Tel        :=FieldByName('Prp_Tel').AsString;
   CfgRec.Prp_Fax        :=FieldByName('Prp_Fax').AsString;
   CfgRec.Prp_DiscNo     :=FieldByName('Prp_DiscNo').AsString;
   CfgRec.Prp_GSTNo      :=FieldByName('Prp_GstNo').AsString;
   CfgRec.Prp_VSFee      :=FieldByName('Prp_VSFee').AsInteger;
   CfgRec.Prp_SFee       :=FieldByName('Prp_SFee').AsInteger;
   CfgRec.Prp_AFee       :=FieldByName('Prp_AFee').AsInteger;
   CfgRec.Prp_CFee       :=FieldByName('Prp_CFee').AsInteger;
   CfgRec.Prp_VCFee      :=FieldByName('Prp_VCFee').AsInteger;
   CfgRec.Prp_Kstrk      :=FieldByName('Prp_Kstrk').AsFloat;
   CfgRec.Prp_Hour       :=FieldByName('Prp_Hour').AsFloat;
   CfgRec.Prp_Bill       :=FieldByName('Prp_Bill').AsString;
   CfgRec.Prp_Elect      :=FieldByName('Prp_Elect').AsBoolean;
   CfgRec.Prp_EfRepr     :=FieldByName('Prp_EfRepr').AsBoolean;
   CfgRec.Prp_Dates      :=FieldByName('Prp_Dates').AsBoolean;

   CfgRec.Nfl_Prov       :=FieldByName('Nfl_Prov').AsString; {New File defqaults}
   CfgRec.Nfl_City       :=FieldByName('Nfl_City').AsString;
   CfgRec.Nfl_Disced     :=FieldByName('Nfl_Disced').AsString;
   CfgRec.Nfl_Efile      :=FieldByName('Nfl_EFile').AsBoolean;

   CfgRec.Ef_PrepNo      :=FieldByName('Ef_PrepNo').AsString;
   CfgRec.Ef_TransNo     :=FieldByName('Ef_TransNo').AsString;
   CfgRec.Ef_PsWord      :=FieldByName('Ef_PsWord').AsString;
   CfgRec.Ef_ProdNo      :=FieldByName('Ef_ProdNo').AsString;
   CfgRec.Ef_TestNo      :=FieldByName('Ef_TestNo').AsString;
   CfgRec.Ef_DataDir     :=FieldByName('Ef_DataDir').AsString;
   CfgRec.Ef_EncDir      :=FieldByName('Ef_EncDir').AsString;
   CfgRec.Ef_DialNo      :=FieldByName('Ef_DialNo').AsString;
   CfgRec.Ef_NUI         :=FieldByName('Ef_NUI').AsString;
   CfgRec.Ef_NuiPass     :=FieldByName('Ef_NuiPass').AsString;
   CfgRec.Ef_Port        :=StrToInt(FieldByName('Ef_Port').AsString);
   CfgRec.Ef_Baud        :=StrToInt(FieldByName('Ef_Baud').AsString);
   CfgRec.Ef_Protocl     :=FieldByName('Ef_Protocl').AsString;
   CfgRec.Ef_Centre      :=FieldByName('Ef_Centre').AsString;
   CfgRec.Ef_PrepId      :=FieldByName('Ef_PrepId').AsString;
   CfgRec.Ef_PrnPort     :=StrToInt(FieldByName('Ef_PrnPort').AsString);
   CfgRec.Ef_Carrier     :=FieldByName('Ef_Carrier').AsString;
   CfgRec.Ef_Stage       :=FieldByName('Ef_Stage').AsString;

   CfgRec.Prn_Shade      :=FieldByName('Prn_Shade').AsBoolean;
   CfgRec.Prn_Head       :=FieldByName('Prn_Head').AsBoolean;
   CfgRec.Prn_NameH      :=FieldByName('Prn_NameH').AsBoolean;
   CfgRec.Prn_SinH       :=FieldByName('Prn_SinH').AsBoolean;
   CfgRec.Prn_DateH      :=FieldByName('Prn_DateH').AsBoolean;
   CfgRec.Prn_Disclm     :=FieldByName('Prn_Disclm').AsString;
   CfgRec.Prn_Logo       :=FieldByName('Prn_Logo').AsBoolean;
   CfgRec.Prn_LogoLn     :=FieldByName('Prn_LogoLn').AsInteger;
   If CfgRec.Prn_LogoLn >15 then CfgRec.Prn_LogoLn :=15;
   If CfgRec.Prn_LogoLn <0 then CfgRec.Prn_LogoLn:=0;
   CfgRec.Opr_Recalc     :=FieldByName('Opr_Recalc').AsBoolean;
   CfgRec.Opr_Close      :=FieldByName('Opr_Close').AsBoolean;
   CfgRec.Opr_FPres      :=FieldByName('Opr_FPres').AsInteger;

   end;

   {Restrict directories}
   If Vl(LicenseLevel) =3 then
   begin
    CfgRec.Dir_Cur :=User.Tax_Dir;
    CfgRec.Dir_Deflt :=User.Tax_Dir;
    CfgRec.Ef_DataDir :=  User.EFile_Dir
   end;
end;


(*
Procedure CfgToMem;
begin
  With CfgTbl do
   begin
   CfgRec.Dir_Cur        :=FieldByName('Dir_Cur').AsString;
   CfgRec.Dir_Deflt      :=FieldByName('Dir_Deflt').AsString;
   CfgRec.Dir_LastYr     :=FieldByName('Dir_LastYr').AsString;
   CfgRec.Dir_PrvLYr     :=FieldByName('Dir_PrvLYr').AsString;
   CfgRec.Dir_Train      :=FieldByName('Dir_Train').AsString;
   CfgRec.Dir_Sample     :=FieldByName('Dir_Sample').AsString;

   CfgRec.Prp_Name       :=FieldByName('Prp_Name').AsString;
   CfgRec.Prp_Street     :=FieldByName('Prp_Street').AsString;
   CfgRec.Prp_City       :=FieldByName('Prp_City').AsString;
   CfgRec.Prp_Prov       :=FieldByName('Prp_Prov').AsString;
   CfgRec.Prp_Postal     :=FieldByName('Prp_Postal').AsString;
   CfgRec.Prp_Countr     :=FieldByName('Prp_Countr').AsString;
   CfgRec.Prp_Area       :=FieldByName('Prp_Area').AsString;
   CfgRec.Prp_Tel        :=FieldByName('Prp_Tel').AsString;
   CfgRec.Prp_Fax        :=FieldByName('Prp_Fax').AsString;
   CfgRec.Prp_DiscNo     :=FieldByName('Prp_DiscNo').AsString;
   CfgRec.Prp_GSTNo      :=FieldByName('Prp_GstNo').AsString;
   CfgRec.Prp_VSFee      :=FieldByName('Prp_VSFee').AsInteger;
   CfgRec.Prp_SFee       :=FieldByName('Prp_SFee').AsInteger;
   CfgRec.Prp_AFee       :=FieldByName('Prp_AFee').AsInteger;
   CfgRec.Prp_CFee       :=FieldByName('Prp_CFee').AsInteger;
   CfgRec.Prp_VCFee      :=FieldByName('Prp_VCFee').AsInteger;
   CfgRec.Prp_Kstrk      :=FieldByName('Prp_Kstrk').AsFloat;
   CfgRec.Prp_Hour       :=FieldByName('Prp_Hour').AsFloat;
   CfgRec.Prp_Bill       :=FieldByName('Prp_Bill').AsString;
   CfgRec.Prp_Elect      :=FieldByName('Prp_Elect').AsBoolean;
   CfgRec.Prp_EfRepr     :=FieldByName('Prp_EfRepr').AsBoolean;
   CfgRec.Prp_Dates      :=FieldByName('Prp_Dates').AsBoolean;

   CfgRec.Nfl_Prov       :=FieldByName('Nfl_Prov').AsString; {New File defqaults}
   CfgRec.Nfl_City       :=FieldByName('Nfl_City').AsString;
   CfgRec.Nfl_Disced     :=FieldByName('Nfl_Disced').AsString;
   CfgRec.Nfl_Efile      :=FieldByName('Nfl_EFile').AsBoolean;

   CfgRec.Ef_PrepNo      :=FieldByName('Ef_PrepNo').AsString;
   CfgRec.Ef_TransNo     :=FieldByName('Ef_TransNo').AsString;
   CfgRec.Ef_PsWord      :=FieldByName('Ef_PsWord').AsString;
   CfgRec.Ef_ProdNo      :=FieldByName('Ef_ProdNo').AsString;
   CfgRec.Ef_TestNo      :=FieldByName('Ef_TestNo').AsString;
   CfgRec.Ef_DataDir     :=FieldByName('Ef_DataDir').AsString;
   CfgRec.Ef_EncDir      :=FieldByName('Ef_EncDir').AsString;
   CfgRec.Ef_DialNo      :=FieldByName('Ef_DialNo').AsString;
   CfgRec.Ef_NUI         :=FieldByName('Ef_NUI').AsString;
   CfgRec.Ef_NuiPass     :=FieldByName('Ef_NuiPass').AsString;
   CfgRec.Ef_Port        :=StrToInt(FieldByName('Ef_Port').AsString);
   CfgRec.Ef_Baud        :=StrToInt(FieldByName('Ef_Baud').AsString);
   CfgRec.Ef_Protocl     :=FieldByName('Ef_Protocl').AsString;
   CfgRec.Ef_Centre      :=FieldByName('Ef_Centre').AsString;
   CfgRec.Ef_PrepId      :=FieldByName('Ef_PrepId').AsString;
   CfgRec.Ef_PrnPort     :=StrToInt(FieldByName('Ef_PrnPort').AsString);

   CfgRec.Prn_Shade      :=FieldByName('Prn_Shade').AsBoolean;
   CfgRec.Prn_Head       :=FieldByName('Prn_Head').AsBoolean;
   CfgRec.Prn_NameH      :=FieldByName('Prn_NameH').AsBoolean;
   CfgRec.Prn_SinH       :=FieldByName('Prn_SinH').AsBoolean;
   CfgRec.Prn_DateH      :=FieldByName('Prn_DateH').AsBoolean;
   CfgRec.Prn_Disclm     :=FieldByName('Prn_Disclm').AsString;
   CfgRec.Prn_Logo       :=FieldByName('Prn_Logo').AsBoolean;
   CfgRec.Prn_LogoLn     :=FieldByName('Prn_LogoLn').AsInteger;
   If CfgRec.Prn_LogoLn >15 then CfgRec.Prn_LogoLn :=15;
   If CfgRec.Prn_LogoLn <0 then CfgRec.Prn_LogoLn:=0;
   CfgRec.Opr_Recalc     :=FieldByName('Opr_Recalc').AsBoolean;
   CfgRec.Opr_Close      :=FieldByName('Opr_Close').AsBoolean;
   CfgRec.Opr_FPres      :=FieldByName('Opr_FPres').AsInteger;
   end;

   {Restrict directories}
   If Vl(LicenseLevel) =3 then
   begin
    CfgRec.Dir_Cur :=User.Tax_Dir;
    CfgRec.Dir_Deflt :=User.Tax_Dir;
    CfgRec.Ef_DataDir :=  User.EFile_Dir
   end;
end;
*)

Function OpenCfg: boolean;
begin
  Result := False;
  CfgTbl := TTable.Create(Application);
  {CfgTbl.DataBaseName := TaxPgmDir;}
  CfgTbl.TableName := AppDir+'\' + 'T1CFG.DBF'; 
  if CfgTbl.State = dsInactive then
  begin
   try
     CfgTbl.Open;
     Result := True;
     CfgToMem;
   except
     on EDataBaseError do
        ShowMessage(CfgTbl.TableName + ' can not be opened');
     end;
  end;

  end;

Function GetTodaysMonth:String;
Var YYYY,MM,DD:word;
begin
  DecodeDate(Now,YYYY,MM,DD);
  result :=PaddZero( LTrim(RTrim(IntToStr(MM))),2);
end;

Function GetTodaysDay:String;
Var YYYY,MM,DD:word;
begin
  DecodeDate(Now,YYYY,MM,DD);
  result := PaddZero(LTrim(RTrim(IntToStr(MM))),2);
end;


Function MakeEFFileName(LicenseLevel:string):string;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec : string[2];
begin
  DecodeDate(Now,YYYY,MM,DD);
  DecodeTime(Now,Hour,Min,Sec,Msec);
  SMM   := LTrim(RTrim(IntToStr(MM)));
  SDD   := Ltrim(Rtrim(IntToStr(dd)));
  SMin  := LTrim(RTrim(IntToStr(Min)));
  SSec := LTrim(RTrim(IntToStr(sec)));
  If Length(SMM)   =1 then SMM   := '0'+SMM;
  If Length(SDD)   =1 then SDD   := '0'+Sdd;
  If Length(SMin)  =1 then SMin  := '0'+SMin;
  If Length(SSec)  =1 then SSec  := '0'+SSec;
  If Vl(LicenseLevel) = 3 then
   Result := User.M_Office+SDD+SSec
  Else
   Result := SMM + SDD+ SMin+SSec;
end;

Function InitParms: boolean;
Var SomeString: TstringList;
Begin
  SomeString := TstringList.Create;
  SomeString.LoadFromFile(AppDir+'\'+'T1Parms.d');
  AppVersion := SomeString[0];
  Licensee := SomeString[1];
  LicenseLevel := SomeString[2];
  SomeString.Free;
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

Function PrintSomeFile(FileNm: String):boolean;
var
  i:integer;PrnFile: TextFile;TempList:TstringList;
begin
  TempList := TstringList.Create;
  TempList.LoadFromFile(FileNm);
  AssignPrn(PrnFile);
  Rewrite(PrnFile);
  For i:=0 To TempList.Count-1 do
   Writeln(PrnFile, TempList[i]);
  System.CloseFile(PrnFile);
end;

Function Numeric(S:string):Boolean;
Var i:integer;
begin
 If s ='' then begin Result := false;exit;end;
 For i:= 1 to Length(S) do
 If S[i] in ['0','1','2','3','4','5','6','7','8','9'] then
   Result := True
  else
   begin Result := False;Exit; end;
end;


end.
