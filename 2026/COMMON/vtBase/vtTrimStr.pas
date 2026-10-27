unit vtTrimStr;
(* Really basic routines for common use
*)

interface

uses
  Classes, Controls,
  vtMulti,
  ShellAPI, Winapi.ShlObj, ActiveX, SHFolder, //20160523 Igor;
  IdHTTP, MSHTML, IdSSLOpenSSL, IdSSLOpenSSLHeaders, //20220411 Igor
  ComObj, CommCtrl, Windows, Vcl.Clipbrd, VirtualUI_Mediator;//20170927 Igor

procedure Busy(fOn: boolean = True); //busy cursor on/off
procedure Done;

function AllTrim(const Str: string): string;
function AllTrimAnsi(const Str: string): string;
function LTrim(const S: string): string;
function RTrim(const S: string): string;
function MTrim(const S: string): string;
function LeftStr(const Str: string; Size: Integer): string;
function LeftAnsiStr(const Str: string; Size: Integer): string;
function MidStr(const Str: string; StartPos, Size: Integer): string;
function MidAnsiStr(const Str: string; StartPos, Size: Integer): string;
function RightStr(const Str: string; Size: integer): string;

function RemoveChar(const S, Ch: string): string;
function ReplaceChar(const S: string; FromChar, ToChar: char): string; overload;
function ReplaceChar(const S: string; FromChar: char; ToChar: string): string; overload;
function ReplaceStr(const OriginalString, SubStr, NewStr: string): string;

function AddLeadingZeros(const S: string; MaxLength: Integer): string;
function RmvLeadingZeros(const S: string): string;

function AddLeadingSpaces(const S: string; MaxLength: Integer): string; //20180307 Igor

function FilledStr(Count: integer; ch: char): string;
function FillLeftZeros(S: string; MaxLength: integer): string;
function Space(Count: integer): string;

function JustRight(const S: string; MaxLength: integer): string;
function PaddCount(const s: string; maxLength: integer): Integer;
function PaddR(S: string; MaxLength: integer): string;
function PaddRZero(S: string; MaxLength: integer): string;
function PaddZero(S: string; MaxLength: Integer): string;

function MyStrToInt(const s: string): Integer;
function GetFieldId(EditBoxName: string): Integer;
function VL(s: string): Real;

function StringToBoolean(const AString: string): Boolean;
function BooleanToString(ABoolean: Boolean): string;
function FromYesToX(const YesNo: string): string;

function Min(a, b: integer): integer;
function MaxR(V1: real; V2: real): real;
function MinR(V1: real; V2: real): real;
function MaxString(const S1, S2: string): string;
function MinString(const S1, S2: string): string;

function EditDateYMD(S: string; MnYear, MxYear: integer; delim: char): Boolean;
function EditDateDMY(S: string; MnYear, MxYear: integer; delim: char): Boolean;
//Function InDateYYYYMMDDonly(Value:string;MxYear:integer):Boolean;
function InDateYMDonly(Value: string; MnYear, MxYear: integer; delim: char): Boolean;

function ConvertToProper(s: string): string;
procedure ParseWords(S: String; Delim: string; WList: Tstrings); //20150701
function InValuesOnly(s, Value: string): Boolean;
procedure IsAnyWhereInList(Astring: string; AList, ResultsList: Tstrings);
function IsExactlyInList(Astring: string; SomeList: Tstrings): Integer;
function IsInList(Astring: string; SomeList: Tstrings): Integer; overload; //20160523 Igor
function IsInList(Astring: string; SomeList: Tstrings; var AIndex: Integer): boolean; overload; //20160523 Igor

function IsInRange(Num, FromNum, ToNum, byNum: Integer): Boolean;
function InNumRangeOnly(Value, Lowval, HighVal: integer): Boolean; overload;
function InNumRangeOnly(Value: string; Lowval, HighVal: integer): Boolean; overload;
function NumbersOnly(S: string): Boolean;
function Numeric(const S: string): Boolean;
function RealNumeric(const S: string): Boolean;
function IsRealValue(const S: string): Boolean;
function InStringRange(const Val, LowVal, HighVal: string): boolean;
function InNumRange(ValStr: string; LowVal, HighVal: integer): boolean; overload;
function ValidSin(const SiNum: string): boolean;
function ChkDigit(const SiNum8: string): Integer;
function NegativeOnly(Value: string): Boolean;
function XOnly(Value: string): Boolean;

//Function FormatAmount(s: string;Decimals:Integer): string;
function ReformatSin(S: string): string;

function ValidPostal(RetNo: Integer; PostCode: string; Country: string = ''): Boolean;

function ExtractFormInst(FName: string): string;
function ExtractFormInstNo(FName: string): integer;
function ExtractNonInstFormName(FName: string): string;
function ExtractFormPageNo(FormName: string): integer;
function GetPrevFormPage(FormName: string): string;
function ExtractFormRootName(FormName: string): string;
function ExtractFormSlashField(S: string; var TargetLinkedField: Integer): string;
function IsFormMultiInst(FormName: string): Boolean;
function IsFormMultiPage(FormName: string): Boolean;

//common procedures depending on implementation details
//make old code working with the class reference
procedure CalcName(RetNo: integer; const FName: string);
procedure CalcNo(RetNo: integer; FNo: integer);
procedure CalcAll(RetNo: integer);
procedure CalcFullReturn(RetNo: integer);
procedure ReCalcEveryThing(RetNo: integer);
procedure CountDiagnostics(RetNo: integer);
function CountErrorType(AuditList: TAuditList; Category: char): Integer;
//procedure SignOffAWarning(RetNo:Integer;ErrMsg:String);
//procedure SignOffAWarning(RetNo:Integer;r:TAuditRec=nil);
//Function SignOffAWarning(RetNo:Integer;ErrMsg:String):Boolean;

//also expected in TrimStr
function CopyDB(const DBName, SourceDir, DestDir: string; out Msg: String): boolean;//20170802 Igor
function CopyFile(const SourceFile, DestinationFile: string): BOOLEAN;

procedure SetDefaultPrinter(PrinterName: string);
function IsPrinterInstalled(PrinterName: string): Boolean;
function GetDefaultPrinterName: string;
procedure GetPrinterDriversNames(AList: TStringList);

function DateToMonthDayYear(dt: TDateTime): string;
function DateToYYYYMMDD(Dt: TDateTime): string;
function DateDiff(dfrom, dto: TDate): integer;
function DateDiffMDY(D1: string; D2: string): Integer; //DateDiff(
function DateDiffYMD(D1: string; D2: string): Integer; //DtDiff
function DMYtoDate(InputDate: string): TDate;
function MDYtoDate(InputDate: string): TDate;
function YMDtoDate(InputDate: string): TDate;
function DMYtoMDY(InputDate: string; delim: string = '-'): string;
//Function DD_MM_YYYYToMMDDYYYY(InputDate:String):string; '/'
function DMYtoYMD(InputDate: string; delim: string = '-'): string;
function YMDtoMDY(InputDate: string; delim: string = '-'): string;
//Function YYYY_mm_ddToMMDDYYYY(InputDate:String):string; '/'

{candidates - search for TwwDBRichEdit
Procedure AddDisplayFormatToRtf(ARichEdit:TwwDBRichEdit;KeyWList:TStringList);
Procedure GetDelimiterPositionsInRtf(ARichEdit: TwwDbRichEdit; SearchText: string;Var DelimList:TStringList);
procedure InsertBackFunction(ARichEdit:TwwDbRichEdit;InSearch, InSecondSearch, InReplace: string);
Procedure ReplaceRtfDelimiters(ARichEdit:TwwDbRichEdit;FromDelim,ToDelim:String);

Procedure ReadTheValue(TempList:TstringList;FrmNm:String;Elm1,Elm2:Integer;Var Val1:String;Var Val2:String);
}
Function IsAlbTaxExempt(RetNo:Integer):Boolean; //20160208 Igor
Function GetTimeToMilliSec(Dt:tDateTime):String; //201605823 Igor

Function ReplaceReservedXMLCharacters(s:String):String;    //20160523 Igor
Function ReplaceReservedXMLCharactersAndTruncate(s:String;maxLength:integer):String;    //JZ 20230228

function GetFileNameFromLink(const LinkFileName: string;var FileName: string): Boolean; //20160523 Igor
function ExistsPrevKey(const AAppId: String; var APrevKey: String): Boolean;//20160721 Igor
function ExistsPrevOption(const AAppId: String; var APrevOptionsPath: String): Boolean; //20160523 Igor
function GetVTLinks(AMask: String = ''): TStringList; //20160719 Igor
function GetAppIdFromExeName(AExeName: String): String; //20160719 Igor
procedure CompareOptions(ASrc: TStringList; ADstPath: String); //220160523 Igor
Function IncrementlastBackUpDir(ALastBackUp, ABackUpDir: String): String; //20160602 Igor
function StuffString(const AText: string; AStart, ALength: Cardinal; //20160903 Igor
  const ASubText: string): String;
function IncRTFFontSize(const AText: String; AInc: Integer): String; //20160903 igor
function CorrectRTFFontSize(const AText: String; APixelsPerInch: Integer): String; //20170212 Igor

//procedure AdjustFinePrintRegistrySettings(PDFFullfileName: String; //20160905 Igor
//  ShowDlgValue: Integer; PdfActionValue: Integer; CollectJobsValue: Integer); overload;
procedure AdjustFinePrintRegistrySettings(APDFFullfileName: String); //20160910 Igor
procedure StartWait(ACaption: String = 'Please, wait..'); //20200218 Igor
procedure SetWaitCaption(ACaption: string); //20200218 Igor
procedure EndWait;
function GetCorrectFileName(AFileName: String): String; //20161227 Igor

//20170728 Igor>>>
function DatePartsIsCorrect(const AY, AM, AD: String; var AYY, AMM, ADD: Integer): Boolean;
function TryYYYYMMDDToDate(ADateStr: string; var ADate: TDateTime): Boolean;
function TryDDMMYYYYToDate(ADateStr: string; var ADate: TDateTime): Boolean;
function TryMMDDYYYYTodate(ADateStr: string; var ADate: TDateTime): Boolean;
function YYYYMMDDToDate(ADateStr: string): TDateTime;
function DDMMYYYYToDate(ADateStr: string): TDateTime;
function MMDDYYYYTodate(ADateStr: string): TDateTime;
//20170728 Igor<<<
function SamePath(const APath1, APath2: String): Boolean;//20170803 Igor
function OSTest: String;//20170901 Igor

//20170904 Igor>>>
Function GetTrFolder: String;
Function IsTrLoaded: Boolean;
Procedure LoadTr(TrFolder: String);
Function GetTrHandle: HWND;
Procedure LinkToTR(SearchItem: String);
procedure SetupTrFolder;
//20170904 Igor<<<
//20170927 Igor>>>
procedure OpenAnyFile(PgmPath, PgmFile: String);
procedure ShowPDF(PgmPath, PDFFile: String);
//20170927 Igor<<<

function DefaultDataDir(FApp: TApp): string;

function RemoveDiacriticChars(AText: string): string; // 20180307 Igor

function HTMLEscape(const Str: string): string; // 20180709 Igor

function NormalizeFileName(AFileName: string; AReplaceStr: string = '_'): string; //20200914 Igor

Function IsInTapesList(RetNo: Integer; Fname: String; elm: Integer): Boolean; //20220121 Igor

procedure GetFileWithNoCache(AUrl, AFileName: string); //20220411 Igor
function IsInternetConnectionActive: Boolean; //20220512 Igor

function ProcessMessageText(AText: string): string; //20230216 Igor

implementation

uses
  {Windows, }Messages, Forms, Printers, //cursor//20170904 Igor
  SysUtils, {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}, Dialogs,//20170811 Igor
  vtCommon, vtShared, vtDialogs,
  RegularExpressions, iniFiles, //20160602 Igor //20160811 Igor
  Registry, //20160905 Igor
  TR_2026Engine, //20200914 Igor
  WinInet, //20220512 Igor
  Xml.XMLDoc, Xml.XMLIntf, StrUtils, //20230216 Igor
  StdCtrls, DateUtils, IOUtils, Types;//20170901 Igor

var
  WaitForm: TForm;

function IsInternetConnectionActive: Boolean; //20220512 Igor
var origin : cardinal;
begin
  Result := InternetGetConnectedState(@origin,0);
  //connections origins by origin value
  //NO INTERNET CONNECTION              = 0;
  //INTERNET_CONNECTION_MODEM           = 1;
  //INTERNET_CONNECTION_LAN             = 2;
  //INTERNET_CONNECTION_PROXY           = 4;
  //INTERNET_CONNECTION_MODEM_BUSY      = 8;
end;

procedure GetFileWithNoCache(AUrl, AFileName: string); //20220411 Igor
var HTTP: TIdHTTP;
    FS: TFileStream;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  if FileExists(AFileName) then
    DeleteFile(AFileName);
  if AUrl.IsEmpty then Exit; //20201117 Igor
  FS := TFileStream.Create(AFileName, fmCreate);
  HTTP := TIdHTTP.Create(nil);
  IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));//20200914 Igor
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210628 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    HTTP.HandleRedirects := True;
    HTTP.AllowCookies := True;
    //20190513 Igor >>>
    HTTP.ConnectTimeout := HTTP_TimeOut;
    HTTP.ReadTimeout := HTTP_TimeOut;
    //20190513 Igor <<<
    with HTTP do
    begin
      Request.UserAgent := 'Mozilla/4.0';
      Request.Connection := 'Keep-Alive';
      Request.ProxyConnection := 'Keep-Alive';
      Request.CacheControl := 'no-cache';
    end;
    HTTP.Get(AUrl, FS);
  finally
    IdSSLIOHandlerSocket.Free;
    FS.Free;
    HTTP.Free;
  end;
end;

function NormalizeFileName(AFileName: string; AReplaceStr: string): string; //20200914 Igor
var
  I: integer;
begin
  for I := Low(TPath.GetInvalidFileNameChars) to High(TPath.GetInvalidFileNameChars) do
    AFileName := ReplaceStr(AFileName, TPath.GetInvalidFileNameChars[I], AReplaceStr);
  Result := AFileName;
end;

function HTMLEscape(const Str: string): string; // 20180709 Igor
var
  i: Integer;
begin
  Result := '';
  for i := Low(Str) to High(Str) do
  begin
    case Str[i]  of
    '<' : Result := Result + '&lt;';    { Do not localize }
    '>' : Result := Result + '&gt;';    { Do not localize }
    '&' : Result := Result + '&amp;';   { Do not localize }
    '"' : Result := Result + '&quot;';  { Do not localize }
{$IFNDEF UNICODE}
    #92, Char(160) .. #255 : Result := Result + '&#' + IntToStr(Ord(Str[ i ])) +';';  { Do not localize }
{$ELSE}
    // NOTE: Not very efficient
    #$0080..#$FFFF : Result := Result + '&#' + IntToStr(Ord(Str[ i ])) +';'; { Do not localize }
{$ENDIF}
    else
      Result := Result + Str[i];
    end;
  end;
end;


function RemoveDiacriticChars(AText: string): string; // 20180307 Igor
var i: integer;

type TDiacritic_Char = record
    CharValue: WideChar;
    CharReplace: string;
  end;

const Diacritic_CharsCount = 26;

const Diacritic_Chars: array[0..Diacritic_CharsCount - 1] of TDiacritic_Char =
    (
      (CharValue : 'À'; CharReplace : 'A'),
      (CharValue : 'Â'; CharReplace : 'A'),
      (CharValue : 'à'; CharReplace : 'a'),
      (CharValue : 'â'; CharReplace : 'a'),
      (CharValue : 'É'; CharReplace : 'E'),
      (CharValue : 'È'; CharReplace : 'E'),
      (CharValue : 'Ê'; CharReplace : 'E'),
      (CharValue : 'Ë'; CharReplace : 'E'),
      (CharValue : 'è'; CharReplace : 'e'),
      (CharValue : 'é'; CharReplace : 'e'),
      (CharValue : 'ê'; CharReplace : 'e'),
      (CharValue : 'ë'; CharReplace : 'e'),
      (CharValue : 'Î'; CharReplace : 'I'),
      (CharValue : 'Ï'; CharReplace : 'I'),
      (CharValue : 'î'; CharReplace : 'i'),
      (CharValue : 'ï'; CharReplace : 'i'),
      (CharValue : 'Ô'; CharReplace : 'O'),
      (CharValue : 'Ö'; CharReplace : 'O'),
      (CharValue : 'ô'; CharReplace : 'o'),
      (CharValue : 'ö'; CharReplace : 'o'),
      (CharValue : 'Ù'; CharReplace : 'U'),
      (CharValue : 'Û'; CharReplace : 'U'),
      (CharValue : 'ù'; CharReplace : 'u'),
      (CharValue : 'û'; CharReplace : 'u'),
      (CharValue : 'Ç'; CharReplace : 'C'),
      (CharValue : 'ç'; CharReplace : 'c')
    );

const
  AllowedChars = ['0'..'9', 'a'..'z', 'A'..'Z'];

begin
  for I := 0 to Diacritic_CharsCount - 1 do
    AText := ReplaceStr(AText, Diacritic_Chars[I].CharValue, Diacritic_Chars[I].CharReplace);
  for I := Low(AText) to High(AText) do
    if not (AText[I] in AllowedChars) then
      AText[I] := ' ';
  Result := AText;
end;

function AllTrim(const Str: string): string;
begin
  Result := LTrim(RTrim(Str));
end {Trim};

function AllTrimAnsi(const Str: string): string;
begin
  Result := LTrim(RTrim(Str));
end {Trim};

function LTrim(const S: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
  begin
    if s[i] <> ' ' then
    begin
      result := copy(s, i, length(s));
      exit;
    end;
  end;
  //nothing but spaces
  Result := '';
end;

function RTrim(const S: string): string;
begin
  result := TrimRight(S);
end;

function MTrim(const S: string): string;
begin
  //remove all spaces
  Result := RemoveChar(S, ' ');
end;

function LeftStr(const Str: string; Size: Integer): string;
begin
  Result := Copy(Str, 1, Size);
end;

function LeftAnsiStr(const Str: string; Size: Integer): string;
begin
  Result := Copy(Str, 1, Size);
end;

function MidStr(const Str: string; StartPos, Size: Integer): string;
begin
  Result := Copy(Str, StartPos, Size);
end;

function MidAnsiStr(const Str: string; StartPos, Size: Integer): string;
begin
  Result := Copy(Str, StartPos, Size);
end;

function RightStr(const Str: string; Size: integer): string;
var
  len: Integer; //Byte absolute Str;
begin
  Len := Length(Str);
  if Size > len then
    Size := len;
  Result := Copy(Str, len - Size + 1, Size)
end {RightStr};

function RemoveChar(const S, Ch: string): string;
begin
  Result := StringReplace(S, ch, '', [rfreplaceAll]);
end;

function RemoveHyphens(const S: string): string;
begin
  Result := RemoveChar(S, '-');
end;

function ReplaceChar(const S: string; FromChar, ToChar: char): string;
var
  i: Integer;
begin
  result := s;
  for i := 1 to Length(Result) do
    if Result[i] = FromChar then
      Result[i] := Tochar;
end;

function ReplaceChar(const S: string; FromChar: char; ToChar: string): string;
begin
  Result := StringReplace(s, FromChar, ToChar, [rfReplaceAll]);
end;

function ReplaceStr(const OriginalString, SubStr, NewStr: string): string;
begin
  Result := StringReplace(OriginalString, SubStr, NewStr, [rfReplaceAll]);
end;

function VL(s: string): Real;
var
  Code: integer;
begin
  if s = '' then
  begin Result := 0;
    exit;
  end;
  s := StringReplace(s, ',', '', [rfReplaceAll, rfIgnoreCase]);
  Val(s, Result, Code);
end;

function NoDecimal(const S: string): string;
var
  x: real;
begin
  X := VL(s);
  X := X * 100 + 50;
  X := X / 100;
  X := INT(X);
  Result := FloatToSTR(X);
end;

function Min(a, b: integer): integer;
begin
  if a < b then
    Result := a
  else
    Result := b
end;

function MaxR(V1: real; V2: real): real;
begin
  if V2 > V1 then
    result := V2
  else
    result := V1;
end;

function MinR(V1: real; V2: real): real;
begin
  if V2 < V1 then
    result := V2
  else
    result := V1;
end;

function MinString(const S1, S2: string): string;
begin
  if RTrim(S2) < RTrim(S1) then
    result := S2
  else
    Result := S1;
end;

function MaxString(const S1, S2: string): string;
begin
  if RTrim(S2) > RTrim(S1) then
    result := S2
  else
    Result := S1;
end;

const
  NumberChars = ['0'..'9'];
  NumericChars = NumberChars + ['-'];
  RealChars = NumberChars + ['.'];

function IsRealValue(const S: string): Boolean;
var
  i: integer;
begin
  Result := false;
  if s = '' then
    exit;
  for i := 1 to Length(S) do
    if not (CharInSet(S[i], ['-', '.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])) then //20150701
      exit;
  Result := True
end;

function Numeric(const S: string): Boolean;
var
  i: integer;
begin
  Result := false;
  if s = '' then
    exit;
  for i := 1 to Length(S) do
    if not (CharInSet(S[i], ['-', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])) then  //20150701
      Exit;
  Result := True;
end;

function NumbersOnly(S: string): Boolean;
var
  i: integer;
begin
  Result := false;
  if s = '' then
    exit;
  for i := 1 to Length(S) do
    if not (CharInSet(S[i], NumberChars)) then //20150701
      Exit;
  Result := True;
end;

function RealNumeric(const S: string): Boolean;
var
  i: integer;
begin
  Result := False;
  if s = '' then
    exit;
  for i := 1 to Length(S) do
    if not (CharInSet(S[i], RealChars)) then //20150701
      Exit; //False
  Result := True;
end;

function ChkDigit(const SiNum8: string): Integer;
{Returns the check digit}
var
  Dig1, Dig2, Dig3, Dig4, Dig5, Dig6, Dig7, Dig8: char;//string[1]; //20150701
  Dg0, Dg1, Dg2, Dg3, Dg4, Dg5: char;//string[1];  //20150701
  UnitNum: string;//[4]; //20150701
  i, UnitNumb, x, y, z, w, NextNum: integer;
  Tot: string;
begin
  Result := -1; {False}
  //20150702 mine
 // DIG1:=''; DIG2:='';DIG3:='';DIG4:=''; DIG5:='';DIG6:='';DIG7:='';DIG8:='';
 // Dg0:='';Dg1:='';Dg2:='';Dg3:='';Dg4:='';Dg5:='';
  //----------------------------
  if Length(SiNum8) <> 8 then
    exit;
  for i := 1 to 8 do
  begin
    if (MidStr(SiNum8, i, 1) < '0') or
      (MidStr(SiNum8, i, 1) > '9') then
      exit;
  end;

  DIG1 := LEFTStr(SINUM8, 1)[1]; //20150701
  DIG2 := MIDStr(SINUM8, 2, 1)[1]; //20150701
  DIG3 := MIDStr(SINUM8, 3, 1)[1]; //20150701
  DIG4 := MIDStr(SINUM8, 4, 1)[1]; //20150701
  DIG5 := MIDStr(SINUM8, 5, 1)[1]; //20150701
  DIG6 := MIDStr(SINUM8, 6, 1)[1]; //20150701
  DIG7 := MIDStr(SINUM8, 7, 1)[1]; //20150701
  DIG8 := MIDStr(SINUM8, 8, 1)[1]; //20150701
  { DIG9 := MIDStr(SINUM, 9, 1);}
  UNITNUM := DIG2 + DIG4 + DIG6 + DIG8;
  UNITNUMB := StrToInt(UNITNUM);
  UNITNUMB := UNITNUMB * 2;
  TOT := IntToStr(UNITNUMB);

  Tot:=PaddRZero(Tot,6);  //20150702 Mine    otherize following statements fail

  {dg0 and dg5 are dummies for sign and provision for larger length}
  DG0 := LEFTStr(TOT, 1)[1];
  DG1 := MIDStr(TOT, 2, 1)[1];
  DG2 := MIDStr(TOT, 3, 1)[1];
  DG3 := MIDStr(TOT, 4, 1)[1];
  DG4 := MIDStr(TOT, 5, 1)[1];
  DG5 := MIDStr(TOT, 6, 1)[1];
  //following If statements do not seem to do anything  50150702 Mine
  if Dg0 = '' then
    Dg0 := '0';
  if Dg1 = '' then
    Dg1 := '0';
  if Dg2 = '' then
    Dg2 := '0';
  if Dg3 = '' then
    Dg3 := '0';
  if Dg4 = '' then
    Dg4 := '0';
  if Dg5 = '' then
    Dg5 := '0';
  X := StrToInt(DG0) + StrToInt(DG1) + StrToInt(DG2) +
    StrToInt(DG3) + StrToInt(DG4) + StrToInt(DG5);

  Y := StrToInt(DIG1) + StrToInt(DIG3) + StrToInt(DIG5) + StrToInt(DIG7);
  Z := X + Y;
  {REM PRINT X,Y,Z}
  W := Z div 10;
  NEXTNUM := (W * 10);
  if NEXTNUM < Z then
    NEXTNUM := NEXTNUM + 10;
  Result := NEXTNUM - Z;
  {CHECKDG := NEXTNUM - Z;}
  {IF CHECKDG = StrToInt(DIG9) THEN Result := True;}
end;

function ValidSin(const SiNum: string): boolean;
begin
  Result := True;
  if SiNum = '' then
    exit;

  if (Length(SiNum) <> 9)
    //If Ret[RetNo].Province = 'ZZ' then begin Result := true;exit;end; {non-resident}
  or not RealNumeric(SiNum)
    or (ChkDigit(LeftStr(SiNum, 8)) <> MyStrToInt(RightStr(SiNum, 1))) then
    Result := false;
end;

function MyStrToInt(const s: string): Integer;
begin
  Result := 0;
  try
    //If Numeric(s) then Result := StrToInt(s)
    Result := Trunc(Vl(s));
  except
    ShowMessage(S);
  end;
end;

function PaddR(S: string; MaxLength: integer): string;
{Fill to the end with blanks}
begin
  S := Ltrim(RTrim(s));
  Result := LeftStr(s, MaxLength) + FilledStr(PaddCount(S, MaxLength), ' ');
end;

function AddLeadingZeros(const S: string; MaxLength: Integer): string;
var
  i, k: integer;
  zz: string;
begin
  zz := '';
  k := MaxLength - Length(s);
  if k > 0 then
  begin
    for i := 1 to k do
      zz := zz + '0';
  end;
  Result := zz + s;
end;

function RmvLeadingZeros(const S: string): string;
var
  I: integer;
begin
  Result := S;
  for i := 1 to Length(S) do
    if S[i] = '0' then
      Result := MidStr(S, i + 1, 255)
    else
      exit;
end;

function AddLeadingSpaces(const S: string; MaxLength: Integer): string; //20180307 Igor
var
  i, k: integer;
  zz: string;
begin
  zz := '';
  k := MaxLength - Length(s);
  if k > 0 then
  begin
    for i := 1 to k do
      zz := zz + ' ';
  end;
  Result := zz + s;
end;

function FilledStr(Count: integer; ch: char): string;
{returns a string with Count spaces, or other character}
begin
  { Set a string to all spaces }
  Result := StringOfChar(ch, Count);
end;

function FillLeftZeros(S: string; MaxLength: integer): string;
begin
  S := Ltrim(RTrim(s));
  Result := FilledStr(PaddCount(S, MaxLength), '0') + S;
end;

function JustRight(const S: string; MaxLength: integer): string;
begin
  Result := Trim(s);
  Result := FilledStr(PaddCount(Result, MaxLength), ' ') + Result;
end;

function PaddCount(const s: string; maxLength: integer): Integer;
{how many characters to reach to mx length}
begin
  Result := MaxLength - Length(s);
  if Result < 0 then
    result := 0;
end;

function PaddRZero(S: string; MaxLength: integer): string;
{Fill to the end with zeros}
begin
  S := Ltrim(RTrim(s));
  Result := LeftStr(s, MaxLength) + FilledStr(PaddCount(S, MaxLength), '0');
end;

function Space(Count: integer): string;
{returns a string with Count spaces}
begin
  { Set a string to all spaces }
  Result := stringofChar(' ', Count);
end;

function PaddZero(S: string; MaxLength: Integer): string;
begin
  Result := FilledStr(PaddCount(S, MaxLength), '0') + S;
end;

function NegativeOnly(Value: string): Boolean;
begin
  Result := Vl(Value) <= 0;
  if not Result then
    UserMsg('Only negative values allowed');
end;

function BooleanToString(ABoolean: Boolean): string;
begin
  if ABoolean = True then
    result := 'X'
  else
    Result := '';
end;

function FromYesToX(const YesNo: string): string;
begin
  if UpperCase(YesNo) = 'Y' then
    result := 'X'
  else
    result := '';
end;

function XOnly(Value: string): Boolean;
begin
  Result := (Value = '') or (UpperCase(Value) = 'X');
  if not Result then
    UserMsg('Enter X or blank');
end;

function StringToBoolean(const AString: string): Boolean;
begin
  Result := (UpperCase(AString) = 'X')
    or (UpperCase(AString) = 'Y')
end;

function InValuesOnly(s, Value: string): Boolean;
var
  i, j, k, NumOfElms: Integer;
  s2: string;
  DataElm: array[1..30] of string; //[10];
begin
  Result := (Value = '');
  if Result then
    exit;
  {Parse/Find comma delimited elms/put into array}
  s2 := S + ','; {add comma at the end}
  for k := 1 to High(DataElm) do
    DataElm[k] := '';
  k := 1; {Comma position index}
  for j := 1 to Length(s2) do
  begin
    if midStr(s2, j, 1) = ',' then
      inc(k)
    else
      DataElm[k] := DataElm[k] + midstr(s2, j, 1);
  end;
  NumOfElms := k - 1;
  {now validate}
  Result := True;
  for i := 1 to NumOfElms do
    if (UpperCase(Value) = UpperCase(DataElm[i])) then
      exit;
  //not found
  ShowMessage('Acceptable values: ' + S);
  Result := False;
end;

function InStringRange(const Val, LowVal, HighVal: string): boolean;
begin
  Result := (Val >= LowVal) and (Val <= HighVal);
end;

function InNumRange(Val, LowVal, HighVal: integer): boolean; overload;
begin
  Result := (Val >= LowVal) and (Val <= HighVal);
end;

function InNumRange(ValStr: string; LowVal, HighVal: integer): boolean; overload;
var
  Val: integer;
begin
  Val := StrToIntDef(ValStr, 0);
  Result := (Val >= LowVal) and (Val <= HighVal);
end;

function InNumRangeOnly(Value, Lowval, HighVal: integer): Boolean;
begin
  Result := InNumRange(Value, LowVal, HighVal);
  if not Result then
    UserMsg('Acceptable values: ' + IntToStr(LowVal) + ' to ' + IntToStr(HighVal));
end;

function InNumRangeOnly(Value: string; Lowval, HighVal: integer): Boolean;
var IntVal: Integer; //20160310 Igor
begin
  //20160310 Igor >>>>
  if Value = '' then
  Begin
    result := true;
    exit;
  End;
  if not tryStrToInt(Value,IntVal) then
  Begin
    UserMsg('Incorrect integer value');
    result := False;
  End;
  Result := InNumRange(IntVal, LowVal, HighVal);
  //20160310 Igor <<<<
  if not Result then
    UserMsg('Acceptable values: ' + IntToStr(LowVal) + ' to ' + IntToStr(HighVal));
end;

function InDateYMDonly(Value: string; MnYear, MxYear: integer; delim: char): Boolean;
begin
  Result := EditDateYMD(Value, MnYear, MxYear, delim);
  if Result then
    exit;
  case delim of
    '/': UserMsg('Invalid Date (YYYY/MM/DD) or out of range');
  else
    UserMsg('Invalid Date (YYYY-MM-DD) or out of range');
  end; //case
end;

function IsInList(Astring: string; SomeList: Tstrings): Integer;
var
  i, LengthOfKeyWord: Integer;
begin
  Result := -1;
  if SomeList.Count = 0 then
    exit;
  AString := UpperCase(AllTrim(AString));
  LengthOfKeyWord := Length(AString);
  for i := 0 to SomeList.Count - 1 do
    if Astring = UpperCase(LeftStr(AllTrim(SomeList[i]), LengthOfKeyWord)) then
    begin
      Result := i;
      exit;
    end;
end;

function IsInList(Astring: string; SomeList: Tstrings; var AIndex: Integer): boolean; overload; //20160523 Igor
Begin
  AIndex := IsInList(Astring, SomeList);
  result := AIndex <> -1;
End;

function IsExactlyInList(Astring: string; SomeList: Tstrings): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to SomeList.Count - 1 do
    if AllTrim(Astring) = AllTrim(SomeList[i]) then
    begin
      Result := i;
      exit;
    end;
end;

procedure IsAnyWhereInList(Astring: string; AList, ResultsList: Tstrings);
var
  i: Integer;
  S: string;
begin
  AString := UpperCase(AllTrim(AString));
  for i := 0 to AList.Count - 1 do
  begin
    if Pos(AString, UpperCase(AList[i])) > 0 then
    begin
      s := PaddR(AllTrim(IntToStr(i)), 4);
      ResultsList.AddObject(s + AList[i], AList.Objects[i]);
    end;
  end;
end;

function IsInRange(Num, FromNum, ToNum, byNum: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (Num < FromNum) or (Num > ToNum) then
    Exit;
  Result := True;
  i := FromNum;
  repeat
    if Num = i then
      Exit; //found
    Inc(i, ByNum);
  until i > ToNum;
  //not found
  Result := False;
end;

function GetFieldId(EditBoxName: string): Integer;
//get numercic part from Editnnn
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to length(EditBoxName) do
    if CharInSet(EditBoxName[i], ['0'..'9']) then //20150701
      Result := Result * 10 + ord(EditBoxName[i]) - ord('0')
    else
      Result := 0; //restart with next digit
end;

procedure Busy(fOn: boolean);
begin
  if fOn then
    Screen.Cursor := crHourGlass
  else
    Screen.Cursor := crDefault;
  if windowlocks = 0 then
    Application.ProcessMessages; //forces window updates???
end;

procedure Done;
begin
  Busy(False);
end;

procedure CalcName(RetNo: integer; const FName: string);
begin
  RetList[RetNo].Calc(RetNo, FName);
end;

procedure CalcNo(RetNo: integer; FNo: integer);
begin
  if not(RetList[RetNo].IsLastYearReturn or RetList[RetNo].isAppendix) then //20160314 Igor
    RetList[RetNo].Calc(RetNo, RetList[RetNo].GetFormName(FNo), FNo);
end;

(* What's the difference between CalcAll and CalcFullReturn?
  CalcAll ALSO recalcs spouse and parent returns!
*)

procedure CalcAll(RetNo: integer);
begin
  RetList[RetNo].CalcAll;
end;

procedure CalcFullReturn(RetNo: integer);
begin
  RetList[RetNo].CalcFullReturn;
  //UpdateAllOpenForms;
end;

procedure ReCalcEveryThing(RetNo: integer);
begin
  RetList[RetNo].ReCalcEveryThing;
end;

procedure CountDiagnostics(RetNo: integer);
begin
  if RetNo < 1 then
    Exit; //20150518
  RetList[RetNo].CountDiagnostics;
end;

function CountErrorType(AuditList: TAuditList; Category: char): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to AuditList.Count - 1 do
  begin
    if AuditList[i].Category = Category then
      Inc(Result);
  end;
end;

function ExtractNonInstFormName(FName: string): string;
var
  i: integer;
begin
  i := Pos('#', FName);
  if i > 1 then
    Result := copy(FName, 1, i - 1)
  else
    Result := FName;
end;

function ExtractFormInst(FName: string): string;
var
  i: integer;
begin
  //return #nnn part
  i := Pos('#', FName);
  if i > 1 then
    Result := copy(FName, i, 255)
  else
    Result := '';
end;

function ExtractFormInstNo(FName: string): integer;
var
  i: integer;
begin
  Result := 0;
  //return #nnn part
  i := Pos('#', FName);
  if i >= 1 then //20170118 Igor
  begin
    inc(i);
    Result := ord(FName[i]) - ord('0');
    for i := i + 1 to Length(FName) do
      Result := Result * 10 + ord(FName[i]) - ord('0');
  end;
end;

function IsFormMultiPage(FormName: string): Boolean;
begin
  Result := Pos('_', FormName) > 0;
end;

function IsFormMultiInst(FormName: string): Boolean;
var
  I: Integer;
begin
  Result := (Pos('#', FormName) > 0) AND
    tryStrToInt(copy(FormName, Pos('#', FormName) + 1, 255), I); //20160616 Igor
end;

function GetPrevFormPage(FormName: string): string;
var
  i: Integer;
begin
  Result := FormName;
  i := Pos('_', FormName) + 1;
  if i < 1 then
    exit; //unpaged
  if FormName[i] < '2' then
    exit; //page _1 has no pred
  FormName[i] := Pred(FormName[i]);
end;

function ExtractFormPageNo(FormName: string): integer;
var
  i: integer;
begin
  i := Pos('_', FormName);
  if i > 0 then
    Result := ord(FormName[i + 1]) - ord('0') // StrToInt(copy(FormName,i+1,1))
  else
    Result := 0;
end;

function ExtractFormRootName(FormName: string): string;
var
  i: integer;
begin
  (* T2125_1#2  yields T2125
  *)
  Result := ExtractNonInstFormName(FormName); //20100612
  i := Pos('_', Result);
  if i > 1 then
    SetLength(Result, i - 1);
end;

function ExtractFormSlashField(S: string; var TargetLinkedField: Integer): string;
// comes as ffffff#n/5
var
  SlashPos: Integer;
begin
  s := AllTrim(s);
  SlashPos := Pos('/', S);
  if SlashPos = 0 then
  begin
    Result := AllTrim(S); //AllTrim(ExtractNonInstFormName(S));
    TargetLinkedField := 0;
  end
  else
  begin
    Result := AllTrim(LeftStr(S, SlashPos - 1));
    TargetLinkedField := MyStrToInt(AllTrim(MidStr(s, SlashPos + 1, 4))); //MyStrToInt(AllTrim(MidStr(s,SlashPos+1,3))); //20121229
  end;
end;

function FormatAmount(s: string; Decimals: Integer): string;
var
  x: Real;
begin
  FormatSettings.DecimalSeparator := '.';
  s := LTrim(s);
  x := Vl(S);
  //result:=FormatFloat('###,###,###',x);
  //result:=FormatFloat('###,###,###.00',x);
  case Decimals of
    -2: result := FormatFloat('###,###,###.00', x);
    1: result := FormatFloat('###,###,###.#', x);
    2: result := FormatFloat('###,###,###.##', x);
    3: result := FormatFloat('###,###,###.###', x);
    4: result := FormatFloat('###,###,###.####', x);
  else //0
    x := Round(x);
    result := FormatFloat('###,###,###', x);
  end; //case
end;

function ReformatSin(S: string): string;
begin
  Result := LeftStr(s, 3) + '-' + MidStr(s, 4, 3) + '-' + RightStr(s, 3);
  if Result = '--' then
    Result := '';
end;

function CopyDB(const DBName, SourceDir, DestDir: string; out Msg: String): boolean;//20170802 Igor
begin
  if not SysUtils.ForceDirectories(DestDir) then
  begin
    Msg := Format('Could not create data directory "%s".' + #13 +
                  'Eror message: %s', [DestDir, SysErrorMessage(GetLastError)]);

    Exit(False);
  end;
  if not CopyFile(IncludeTrailingPathDelimiter(SourceDir) + DBName,
                  IncludeTrailingPathDelimiter(DestDir) + DBName) then
  Begin
    Msg := Format('Could not copy file "%s" from "%s" to "%s".' + #13 +
                  'Eror message: %s', [DBName, SourceDir, DestDir, SysErrorMessage(GetLastError)]);

    Exit(False);
  End;
  Result := True;
end;

// Wrapper for Windows API CopyFile

function CopyFile(const SourceFile, DestinationFile: string): BOOLEAN;
begin
  RESULT := Windows.CopyFile(pChar(SourceFile),
    pChar(DestinationFile),
    False); //alow override
end {CopyFile};

procedure SetDefaultPrinter(PrinterName: string); //20160811 Igor
var
  IniFile: TIniFile;
  TempStr1, TempStr2: string;
  S: array[0..64] of char;
begin
  with Printer do
  begin
    //20160829 >>>
    if Printer.Printing then  //20160830 Igor
      if (MessageDlg('Printing is progress. Cancel the previous print (if it is hung)?', mtConfirmation, [mbYes, mbCancel], 0, mbCancel) = mrYes) then
      begin
        try
          Printer.Abort;
          //Printer.EndDoc; //20160910 Igor
        except
        end;
      end
      else
        raise Exception.Create('Printing is progress');
    //20160829 <<<
    // Set the new printer based on the ComboBox's selected printer
    PrinterIndex := printer.Printers.IndexOf(PrinterName);
    // Store the printer name into a temporary string
    TempStr1 := Printers[PrinterIndex];
    // Delete the unnecessary portion of the printer name
    System.Delete(TempStr1, Pos(' on ', TempStr1), Length(TempStr1));
    // Create a TIniFile class
    IniFile := TIniFile.Create('WIN.INI');
    try
      // Retrieve the device name of the selected printer
      TempStr2 := IniFile.ReadString('Devices', TempStr1, '');
      // Change the default printer to that chosen by the user
      IniFile.WriteString('windows', 'device', TempStr1 + ',' + TempStr2);
      // Tell all windows that the default printer changed.
      StrCopy(S, 'windows');
      SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, LongInt(@S));
    finally
      IniFile.Free;
    end;
  end;
end;
(* //20160811 Igor
procedure SetDefaultPrinter(PrinterName: string);
var
  j: Integer;
  Device: PChar;
  Driver: Pchar;
  Port: Pchar;
  HdeviceMode: Thandle;
  aPrinter: TPrinter;

  arrWindows: array[0..64] of Char;
  //AList:TStringList;
  NDX: Integer;
begin
  NDX := printer.Printers.IndexOf(PrinterName);
  if Ndx < 0 then
  begin
    UserMsg('Printer driver ' + PrinterName + ' is not installed');
    Exit;
  end;

  PrinterName := printer.Printers[Ndx]; //exact name

  Printer.PrinterIndex := -1;
  getmem(Device, 255);
  getmem(Driver, 255);
  getmem(Port, 255);
  aPrinter := TPrinter.create;
  for j := 0 to Printer.printers.Count - 1 do
  begin
    if Printer.printers[j] = PrinterName then
    begin
      aprinter.printerindex := j;
      aPrinter.getprinter(device, driver, port, HdeviceMode);
      StrCat(Device, ',');
      StrCat(Device, Driver);
      StrCat(Device, Port);
      WriteProfileString('windows', 'device', Device);
      StrCopy(Device, 'windows');
      StrCopy(arrWindows, 'windows');
      SendMessage(HWND_BROADCAST, WM_WININICHANGE, 0, LongInt(@arrWindows));
    end;
  end;
  Freemem(Device, 255);
  Freemem(Driver, 255);
  Freemem(Port, 255);
  aPrinter.Free;
end;*)

function IsPrinterInstalled(PrinterName: string): Boolean;
begin
  Result := printer.Printers.IndexOf(PrinterName) >= 0;
end;

function GetDefaultPrinterName: string;
begin
  if (Printer.PrinterIndex >= 0) then //20160811 Igor
  begin
    Result := Printer.Printers[Printer.PrinterIndex];
  end
  else
    Result := '';
end;

procedure GetPrinterDriversNames(AList: TStringList);
//Var i:Integer;
begin
  AList.Assign(printer.Printers);
end;

// --------- Date/Time conversions --------------

function DateToMonthDayYear(dt: TDateTime): string;
begin
  result := FormatDateTime('mmmm d, yyyy', Dt);
end;

function DateToYYYYMMDD(Dt: TDateTime): string;
var
  YYYY, MM, DD: word;
  //SMM, SDD, SYYYY : string;
begin
  DecodeDate(Dt, YYYY, MM, DD);
  Result := Format('%4.4d/%2.2d/%2.2d', [YYYY, MM, DD]);
end;

function DateDiff(dfrom, dto: TDate): integer;
begin
//20170728 Igor>>>
  Result := DateUtils.DaysBetween(dto, dfrom) * CompareDate(dto, dfrom); //20170729 Igor
//  Result := trunc(dto) - trunc(dfrom);
//20170728 Igor<<<
end;

function DateDiffMDY(D1: string; D2: string): Integer;
//Function  DateDiff(D1: string; D2 : string): Integer;
begin
  {D1,D2 as mm/dd/yyyy }
  Result := DateDiff(MDYtoDate(D1), MDYtoDate(D2));
end;

function DateDiffYMD(D1: string; D2: string): Integer;
//Function  DtDiff(D1: string; D2 : string): Integer;
begin
  {D1,D2 in form YYYYMMDD}
  Result := DateDiff(YMDtoDate(D1), YMDtoDate(D2))
    +1;  //20150704
end;

function DMYtoMDY(InputDate: string; delim: string): string;
//Function DD_MM_YYYYToMMDDYYYY(InputDate:String):string;
{input date in form dd-mm-yyyy, output as mm/dd/yyyy}
begin
  if InputDate = '' then
    result := ''
  else
    Result := MidStr(InputDate, 4, 2) + delim + LeftStr(InputDate, 2) +
      delim + MidStr(InputDate, 7, 4);
end;

function ToInt(const s: string; i, n: integer): integer;
begin
  Result := ord(s[i]) - ord('0');
  repeat
    inc(i);
    Result := Result * 10 + ord(s[i]) - ord('0');
    dec(n);
  until n < 2;
end;

const
  Digits = ['0'..'9'];
  DateDelims = ['-', '/'];

function DateToInt(const s: string; var d, m, y: integer): boolean;
var
  pc: PChar;
  c: char;
  v: integer;
begin
  Result := False;
  if length(s) <> 10 then
    exit;

  pc := @s[1];

  v := 0;
  c := pc^;
  inc(pc);
  while CharInSet(c, digits) do //20150701
  begin
    v := v * 10 + ord(c) - ord('0');
    c := pc^;
    inc(pc);
  end;
  if not (CharInSet(c, datedelims)) then  //20150701
    exit;
  d := v;

  v := 0;
  c := pc^;
  inc(pc);
  while CharInSet(c, digits) do //20150701
  begin
    v := v * 10 + ord(c) - ord('0');
    c := pc^;
    inc(pc);
  end;
  if not (CharInSet(c, datedelims)) then  //20150701
    exit;
  m := v;

  v := 0;
  c := pc^;
  inc(pc);
  while CharInSet(c, digits) do //20150701
  begin
    v := v * 10 + ord(c) - ord('0');
    c := pc^;
    inc(pc);
  end;
  //if not (c in datedelims) then exit;
  y := v;
  //check number chars processed
  Result := pc - 11 = @s[1];
end;

function IsValidDate(dd, mm, yy: integer): boolean;
begin
  case mm of //days in month
    1, 3, 5, 7, 8, 10, 12: Result := dd <= 31; // in [1..31];
    2: Result := InNumRange(dd, 1, 28 + ord(IsLeapYear(yy)));
  else
    Result := dd <= 30; // in [1..30];
  end;
end;

function EditDateYMD(S: string; MnYear, MxYear: integer; delim: char): Boolean;
{In form yyyy/mm/dd}
var
  dd, mm, yy: integer;
begin
  (* skip check for delim='?'
  *)
  Result := s = '';
  if Result then
    exit; //accept empty fields
  Result := (Length(s) = 10)
    and ((delim = '?') or ((s[5] = delim) and (S[8] = delim)))
    and DateToInt(s, yy, mm, dd) {In form yyyy/mm/dd}
    and InNumRange(yy, MnYear, MxYear)
    and InNumRange(mm, 1, 12) //20160422 Igor
    and IsValidDate(dd, mm, yy);
end;

function EditDateDMY(S: string; MnYear, MxYear: integer; delim: char): Boolean;
{In form dd-mm-yyyy}
var
  dd, mm, yy: integer;
begin
  Result := s = '';
  if Result then
    exit; //accept empty fields
  Result := (Length(s) = 10)
    and ((delim = '?') or ((s[3] = delim) and (S[6] = delim)))
    and DateToInt(s, dd, mm, yy) {In form dd-mm-yyyy}
  and InNumRange(yy, MnYear, MxYear)
    and IsValidDate(dd, mm, yy);
end;

(* yyyy-mm-dd  mm-dd-yyyy
   1    6  9   1  4  7
*)

function DMYtoDate(InputDate: string): TDate;
var
  d, m, y: integer;
begin
  if DateToInt(InputDate, d, m, y) then
    Result := EncodeDate(y, m, d)
  else
    Result := 0;
end;

function MDYtoDate(InputDate: string): TDate;
var
  d, m, y: integer;
begin
  if DateToInt(InputDate, m, d, y) then
    Result := EncodeDate(y, m, d)
  else
    Result := 0;
end;

function YMDtoDate(InputDate: string): TDate;
var
  d, m, y: integer;
begin
  if DateToInt(InputDate, y, m, d) then
    Result := EncodeDate(y, m, d)
  else
    Result := 0;
end;

{
Function DateFromDDMMYYYtoYYYYMMDD(dt:String):String;
// in as dd-mm-yyyy out as yyyy-mm-dd
begin
  result:=RightStr(Dt,4)+'-'+MidStr(Dt,4,2)+'-'+LeftStr(Dt,2);
end;
}

function DMYtoYMD(InputDate: string; delim: string): string;
{from DD-MM-YYYY to YYYY-MM-DD}
begin
  if InputDate = '' then
    result := ''
  else
    Result := MidStr(InputDate, 7, 4) + delim + MidStr(InputDate, 4, 2) +
      delim + MidStr(InputDate, 1, 2);
end;

function YMDtoMDY(InputDate: string; delim: string): string;
//Function YYYY_mm_ddToMMDDYYYY(InputDate:String):string;
{input date in form yyyy-mm-dd, output as mm/dd/yyyy}
begin
  if InputDate = '' then
    result := ''
  else
    Result := MidStr(InputDate, 6, 2) + delim + RightStr(InputDate, 2) +
      delim + LeftStr(InputDate, 4);
end;

function ValidPostal(RetNo: Integer; PostCode: string; Country: string): Boolean;
var
  PostalCode: string; //[10];
begin
  if UpperCase(Country) = 'US' then
  begin
    if ((Numeric(PostCode)
      and
      ((Length(PostCode) = 5) or (Length(PostCode) = 9)))) then
    begin Result := True;
      Exit;
    end
    else
    begin Result := False;
      Exit;
    end;
  end;

  if (Country <> 'CA') and (Country <> '') then
  begin Result := True;
    Exit;
  end;

  Result := true;
  //PostalCode := AllTrim(MTrim(PostCode));
  PostalCode := StringReplace(PostCode, ' ', '', [rfReplaceAll]);
  if (Length(PostalCode) <> 6) or
    (Numeric(PostalCode[1])) or
    (Numeric(PostalCode[3])) or
    (Numeric(PostalCode[5])) or
    (not Numeric(PostalCode[2])) or
    (not Numeric(PostalCode[4])) or
    (not Numeric(PostalCode[6])) then
    result := false;
end;

procedure ParseWords(S: String; Delim: string; WList: Tstrings); //20150701
var
  i, FromI, ToI: Integer;
  Wrd: string;
begin
  s := AllTrim(S);
  Wlist.Clear;
  if s = '' then
    exit;
  i := 1;
  FromI := 1;
  ToI := Length(s);
  repeat
    if (i > ToI) or (S[i] = Delim) then
    begin
      Wrd := MidStr(S, FromI, i - FromI);
      WList.Add(Wrd);
      FromI := i + 1;
      Inc(i);
      if (FromI > ToI) or (i > ToI) then
        break;
    end
    else
      Inc(i);
  until i > ToI + 1;
end;

function ConvertToProper(s: string): string;
var
  i, iLen: integer;
  WList: TStringList;
  SBuffer: string;
begin

  Result := '';
  iLen := Length(s);
  if iLen = 0 then
    exit;
  s := Uppercase(MidStr(s, 1, 1)) + Lowercase(MidStr(s, 2, iLen));

  Wlist := TStringList.Create;
  ParseWords(s, ' ', WList);
  for i := 0 to Wlist.count - 1 do
  begin
    SBuffer := WList[i];
    sBuffer := UpperCase(MidStr(sBuffer, 1, 1)) + Lowercase(MidStr(SBuffer, 2, Length(Sbuffer)));
    WList[i] := sBuffer;
    //o'connor
    if midstr(SBuffer, 2, 1) = Chr(39) then
      WList[i] := LeftStr(sBuffer, 2) + UpperCase(MidStr(sBuffer, 3, 1)) + midStr(Sbuffer, 4, 100)
        //RR
    else if UpperCase(LeftStr(SBuffer, 2)) = 'RR' then
      WList[i] := UpperCase(leftStr(sBuffer, 2)) + midStr(Sbuffer, 3, 100)
    else if Length(SBuffer) = 2 then
    begin
      if (UpperCase(LeftStr(SBuffer, 2)) = 'NE')
        or (UpperCase(LeftStr(SBuffer, 2)) = 'SE')
        or (UpperCase(LeftStr(SBuffer, 2)) = 'NW')
        or (UpperCase(LeftStr(SBuffer, 2)) = 'SW') then
        WList[i] := UpperCase(leftStr(sBuffer, 2) + midStr(Sbuffer, 3, 100))
    end;
  end;

  result := '';
  for i := 0 to Wlist.count - 1 do
    Result := Result + Wlist[i] + ' ';
  Result := AllTrim(Result);
  Wlist.Free;
end;

Function IsAlbTaxExempt(RetNo:Integer):Boolean; //20160208
Begin
  Result := false;
  If (FetchElm(RetNo,'AT1',16) > '')    //20151116
  then result := True;
end;

Function GetTimeToMilliSec(Dt:tDateTime):String; //20160523 Igor
Var SHours, SMinutes,SSeconds : string;//[2];//20170811 Igor
    Hour,Min,Sec,Msec :word;
begin
  DecodeTime(Now,Hour,Min,Sec,Msec);
  sHours := IntToStr(Hour);
  sMinutes := IntToStr(Min);
  sSeconds := IntToStr(Sec);
  If Length(SHours)   =1 then SHours   := '0'+SHours;
  If Length(sMinutes) =1 then SMinutes := '0'+SMinutes;
  If Length(SSeconds) =1 then SSeconds := '0'+SSeconds;
  Result := sHours+':'+SMinutes+':'+SSeconds;
end;

Function ReplaceReservedXMLCharacters(s:String):String;    //20160523 Igor
Const k=60;
begin
    s:=LeftStr(AllTrim(s),40);
    If Length(s) <k then s :=StringReplace(s,'&','&amp;', [rfReplaceAll]);
    If Length(s) <k then s :=StringReplace(s,'"','&quot;', [rfReplaceAll]);
    If Length(s) <k then s :=StringReplace(s,'''','&apos;', [rfReplaceAll]);
    If Length(s) <k then s :=StringReplace(s,'<','&lt;', [rfReplaceAll]);
    If Length(s) <k then s :=StringReplace(s,'>','&gt;', [rfReplaceAll]);
    result := AllTrim(s);
end;


Function ReplaceReservedXMLCharactersAndTruncate(s:String;maxLength:integer):String;    //JZ 20230228
const
   reservedXMLChar     : array[1..5] of string = ('&'     , '"'      , ''''     , '<'   , '>');
   replacementXMLChar  : array[1..5] of string = ('&amp;' , '&quot;' , '&apos;' , '&lt;', '&gt;');
var i,j,c,sPos,replacementXMLCharLength: integer;
begin

    s:=LeftStr(AllTrim(s),maxLength);

    //replace reservedXMLChar
    for i := 1 to 5 do
    begin
      s :=StringReplace(s,reservedXMLChar[i],replacementXMLChar[i], [rfReplaceAll]);
    end;

    //if reservedXMLChar replaced want to re truncate, but first check for replacementXMLChar so not to trunc in the middle of one
    if length(s) > maxLength then
    begin
      for i := 1 to 5 do
      begin

        j := 1;
        replacementXMLCharLength := length(replacementXMLChar[i]);
        sPos := s.IndexOf(replacementXMLChar[i],j);
        while not (sPos = -1) do
        begin
          if ( sPos + replacementXMLCharLength) > maxLength then
          begin
           //blank out replacementXMLChar one char at a time
           for c := 1 to replacementXMLCharLength do
            s[sPos+c] := ' ';
          end;
          j := sPos+1; // check for more after that one
          sPos := s.IndexOf(replacementXMLChar[i],j);
        end;

      end;

      {
      //only looks for first one so does not account for multiple instances of the same replacementXMLChar, works but not ideal
      if ( Pos(replacementXMLChar[i], s) +  replacementXMLCharLength) > maxLength then
        s := StringReplace(s,replacementXMLChar[i],stringofChar(' ', replacementXMLCharLength), [rfReplaceAll]);
      }

      s:=LeftStr(AllTrim(s),maxLength);
    end;

    result := s;
end;





function GetFileNameFromLink(const LinkFileName: string; //20160808 Igor
  var FileName: string): Boolean;
type
  PShellLinkInfoStruct = ^TShellLinkInfoStruct;
  TShellLinkInfoStruct = record
    FullPathAndNameOfLinkFile: array[0..MAX_PATH] of Char;
    FullPathAndNameOfFileToExecute: array[0..MAX_PATH] of Char;
    ParamStringsOfFileToExecute: array[0..MAX_PATH] of Char;
    FullPathAndNameOfWorkingDirectroy: array[0..MAX_PATH] of Char;
    Description: array[0..MAX_PATH] of Char;
    FullPathAndNameOfFileContiningIcon: array[0..MAX_PATH] of Char;
    IconIndex: Integer;
    HotKey: Word;
    ShowCommand: Integer;
    FindData: TWIN32FINDDATA;
  end;
var
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  AnObj: IUnknown;

  LinkInfo: TShellLinkInfoStruct;
  I: Integer;
begin
  try
    FillChar(LinkInfo, SizeOf(LinkInfo), #0);
    for I := 1 to length(LinkFileName) do
      LinkInfo.FullPathAndNameOfLinkFile[I-1] := LinkFileName[I];
    // access to the two interfaces of the object
    AnObj       := CreateComObject(CLSID_ShellLink);
    ShellLink   := AnObj as IShellLink;
    PersistFile := AnObj as IPersistFile;

    // Opens the specified file and initializes an object from the file contents.
    PersistFile.Load(PWChar(WideString(LinkInfo.FullPathAndNameOfLinkFile)), 0);
    with ShellLink do
    begin
      // Retrieves the path and file name of a Shell link object.
      GetPath(LinkInfo.FullPathAndNameOfFileToExecute,
        SizeOf(LinkInfo.FullPathAndNameOfLinkFile),
        LinkInfo.FindData,
        SLGP_UNCPRIORITY);
    end;
    FileName := LinkInfo.FullPathAndNameOfFileToExecute;
    Result := FileExists(FileName);
  except
   result := False;
  end;
end;

(*
function GetFileNameFromLink(const LinkFileName: string; //20160523 Igor
  var FileName: string): Boolean;
const
  IID_IPersistFile: TGUID = '{0000010B-0000-0000-C000-000000000046}';
var
  LResult: HRESULT;
  LSHellLink: IShellLink;
  LPersistFile: IPersistFile;
  LFindData: TWin32FindData;
  C: PChar;
begin
  Result := False;
  LResult := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IID_IShellLinkW, LShellLink);

  if LResult = S_OK then
    if Supports(LShellLink, IID_IPersistFile, LPersistFile) then
    begin
      LResult := LPersistFile.Load(PChar(LinkFileName), STGM_READ);
      if LResult = S_OK then
      begin
        LResult := LShellLink.Resolve(0, 0);
        if LResult = S_OK then
        begin
          GetMem(C,Max_Path);
          LResult := LSHellLink.GetPath(C, MAX_PATH, LFindData, SLGP_UNCPRIORITY);
          Result := LResult = S_OK;
          if Result then
            FileName := String(C);
          FreeMem(C);
        end;
      end;
    end;
end;
*)
function isVtLink(ALink, AMask: String; out AExeFile: String): Boolean; //20160719 Igor
var
  MyFileName: String;
begin
  if AMask = '' then
    AMask := '\\(T1|T2|TF|FP|vt)\d{4,4}\.exe$'; //20161212 Igor
  if GetFileNameFromLink(ALink, MyFileName) then
  begin
    result := TRegEx.IsMatch(MyFileName , AMask, [roIgnoreCase])
  end
  else
    result := False;
  if result then
    AExeFile := MyFileName;
end;

function GetAppIdFromExeName(AExeName: String): String; //20160719 Igor
begin
  if pos('\',AExeName)>0 then
    AExeName := ExtractFileName(AExeName);
  ChangeFileExt(AExeName, '');
  result := Copy(AExeName,1,2)+'-'+Copy(AExeName,3,4);
end;

function GetVTLinks(AMask: String = ''): TStringList; //20160719 Igor
var
  LStr: array[0 .. MAX_PATH] of Char;
  searchResult: TSearchRec;
  J: Integer;
  MyPath, AExeFile: String;
const
  CSIDL: array [0..6] of integer = (CSIDL_PROGRAMS, CSIDL_DESKTOP, CSIDL_FAVORITES, CSIDL_STARTMENU, CSIDL_DESKTOPDIRECTORY,
           CSIDL_COMMON_PROGRAMS, CSIDL_COMMON_DESKTOPDIRECTORY);
//20161102 Igor >>>
  function ScanDirectory(const ADirectory: String; AFullScan: Boolean = False): Boolean;
  var
    searchResult: TSearchRec;
    iResult: Integer;
  begin
    iResult := FindFirst(ADirectory + '\*.*', faAnyFile, searchResult);
    try
      while iResult = 0 do
      begin
        if (searchResult.Attr = faDirectory) then
        begin
          if AFullScan then
            if (searchResult.Name <> '.') and (searchResult.Name <> '..') then
            //20170811 Igor>>>
              if ScanDirectory(ADirectory+'\'+searchResult.Name, AFullScan) then
                exit(true);
            //20170811 Igor<<<
        end
        else
        begin
          if SameText(ExtractFileExt(searchResult.Name), '.lnk') then
          begin
            if isVtLink(ADirectory + '\' + searchResult.Name, AMask, AExeFile) then
            begin
              GetVTLinks.Add(ADirectory + '\' + searchResult.Name);
              GetVTLinks.Add(AExeFile);
              if AMask <> '' then
                exit(true);
            end;
          end;
        end;
        iResult := FindNext(searchResult);
      end;
    finally
      FindClose(searchResult);
    end;
    Result := False;//20170811 Igor
  end;

begin
  result := TStringList.Create;
  SetLastError(ERROR_SUCCESS);
  //get all link
  for J := low(CSIDL) to High(CSIDL) do
  begin
    if SHGetFolderPath(0, CSIDL[J], 0, 0, @LStr) = S_OK then
    begin
      MyPath := LStr;
      if ScanDirectory(MyPath, False) and (AMask <> '') then
        exit;
      if SysUtils.DirectoryExists(MyPath + '\VisualTax') then//20170811 Igor
        if ScanDirectory(MyPath + '\VisualTax', True) and (AMask <> '') then
          exit;
    end;
  end;
//20161102 Igor <<<
end;

function ExistsPrevOption(const AAppId: String; var APrevOptionsPath: String): Boolean; //20160523 Igor //20160719 Igor
var
  MyListLinks: TStringList;
  MyFileName, MyMask: String;
  J: Integer;
Begin
  result := False;
  APrevOptionsPath := '';
  MyMask := '\\' + ReplaceStr(AAppId,'-','')+'\.exe$';
  MyListLinks := GetVTLinks(MyMask);
  try
    //find vt link
    if MyListLinks.Count >= 2 then
    begin
      APrevOptionsPath := ExtractFilePath(MyListLinks[1]) + OptionsFlName;
      result := true;
    end;
  finally
    MyListLinks.Free;
  end;
End;

function ExistsPrevKey(const AAppId: String; var APrevKey: String): Boolean;//20160721 Igor
var
  MyListLinks: TStringList;
  MyFileName, MyMask: String;
  J: Integer;
  KeyFile: String;
  LVERF: TStringList;
Begin
  result := False;
  APrevKey := '';
  MyMask := '\\' + ReplaceStr(AAppId,'-','')+'\.exe$';
  MyListLinks := GetVTLinks(MyMask);
  try
    //find vt link
    if MyListLinks.Count >= 2 then
    begin
      KeyFile := ExtractFilePath(MyListLinks[1]) + LicenseFile;
      if FileExists(KeyFile) then
      begin
        LVERF := TStringList.Create;
        try
          LVERF.LoadFromFile(KeyFile);
          if LVERF.Count > 0 then
          begin
            APrevKey := copy(LVERF[0],1,19);
            result := true;
          end;
        finally
          LVERF.free;
        end;
      end;
    end;
  finally
    MyListLinks.Free;
  end;
end;

procedure CompareOptions(ASrc: TStringList; ADstPath: String); //220160523 Igor
var
  I: integer;
  FieldNm: String;
  TempList: TStringList;
Begin
  TempList:=TStringList.Create;
  if FileExists(ADstPath) then
    TempList.LoadFromFile(ADstPath);
  for I := 0 to ASrc.Count - 1 do
  begin
    FieldNm := trim(LeftStr(ASrc[i],20));
    if IsInList(FieldNm, TempList) = -1 then
      Templist.Add(PaddR(UpperCase(FieldNm),20) + MidStr(ASrc[I], 21, 250));
  end;
  TempList.SaveToFile(ADstPath);
  TempList.Free;
End;

Function IncrementlastBackUpDir(ALastBackUp, ABackUpDir: String): String; //20160602 Igor
Var
  OrdNo: Integer;
const
  c_Backup = 'BackUp';
  c_DigitEnd = '\d{1,}$';
begin
  if (ALastBackUp = '') or (ALastBackUp = ABackUpDir) or not TRegEx.IsMatch(ALastBackUp, c_DigitEnd) then
    Result := IncludeTrailingPathDelimiter(ABackUpDir) + c_Backup + '1'
  else
  begin
    OrdNo := StrToInt(TRegEx.Match(ALastBackUp, c_DigitEnd).Value) + 1;
    Result := TRegEx.Replace(ALastBackUp, c_DigitEnd, IntToStr(OrdNo));
  end;
end;

function StuffString(const AText: string; AStart, ALength: Cardinal; //20160903 Igor
  const ASubText: string): string;
begin
  Result := Copy(AText, 1, AStart - 1) +
            ASubText +
            Copy(AText, AStart + ALength, MaxInt);
end;

function IncRTFFontSize(const AText: String; AInc: Integer): String;  //20160903 Igor
Begin
  result := '\fs'+IntToStr(strToInt(copy(AText, 4, MaxInt)) + AInc);
End;

function CorrectRTFFontSize(const AText: String; APixelsPerInch: Integer): String; //20170212 Igor
var
  f: Integer;
Begin
//20170213 Igor >>>
  if APixelsPerInch <> 96 then
    f := Round(strToInt(copy(AText, 4, MaxInt)) * APixelsPerInch / 96) + 1
  else
    f := Round(strToInt(copy(AText, 4, MaxInt)) + 2);
//20170213 Igor <<<
  result := '\fs'+IntToStr(f);
End;

(*
procedure AdjustFinePrintRegistrySettings(PDFFullfileName: String;  //20160905 Igor
  ShowDlgValue: Integer; PdfActionValue: Integer; CollectJobsValue: Integer);
var
  i,j : Integer;
  Reg: TRegistry;
  PDFfilePath, PDFfileName: String;
  keyName, keyName2, keyNameTemp, PDFFactoryVersion, PDFFactoryVersion2: String;
  Val, Val2: TStringList;

  procedure AdjustForPDFstd(PDFFullfileName: String; ShowDlgValue: Integer;
    PdfActionValue: Integer; CollectJobsValue: Integer);
  begin
    keyNameTemp := keyName + '\' + PDFFactoryVersion;
    If Reg.OpenKey(keyNameTemp, False) = True then //False because we do not want to create it if it doesn’t exist
    Begin
      if PDFFullfileName = '' then
      begin
        reg.WriteString('OutputFilePerm', '');      //20160906 Igor
        reg.WriteString('OutputFile', '');          //20160906 Igor
//        reg.DeleteValue('OutputFilePerm');      //20160905 Igor //20160906 Igor
//        reg.DeleteValue('OutputFile');          //20160905 Igor //20160906 Igor
//        reg.DeleteKey('OutputFilePerm');      //20160905 Igor
//        reg.DeleteKey('OutputFile');          //20160905 Igor
        reg.WriteString('CurDir', PDFfilePath);
        reg.WriteString('AutoSaveDir', PDFfilePath);
      end
      else
      begin
        reg.WriteString('OutputFilePerm', PDFFullfileName);
        reg.WriteString('OutputFile', PDFFullfileName);
        reg.WriteString('CurDir', PDFfilePath);
        reg.WriteString('AutoSaveDir', PDFfilePath);
      end;
    End
    else
      ShowMessage('Cannot find '+keyNameTemp);

    keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' + PDFFactoryVersion2;
    If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
    Begin
      reg.WriteInteger('ShowDlg', ShowDlgValue);
      reg.WriteInteger('PdfAction', PdfActionValue);
      reg.WriteInteger('CollectJobs', CollectJobsValue);
    end
    else
      ShowMessage('Cannot find '+keyNameTemp);
  end;

  procedure AdjustForPDfpro(PDFFullfileName: String; ShowDlgValue,
    PdfActionValue, CollectJobsValue: Integer);
  begin
    keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' +
      PDFFactoryVersion2 + '\PrinterDriverData';
    If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
    Begin
      reg.WriteInteger('ShowDlg', ShowDlgValue);
      reg.WriteInteger('PdfAction', PdfActionValue);
      reg.WriteString('CurDir', PDFfilePath);
    end
    else
    begin
      ShowMessage('Cannot find ' + keyNameTemp);
    end;

    keyNameTemp := keyName + '\' + PDFFactoryVersion;
    If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
    Begin
      reg.WriteString('OutputFilePerm', PDFFullfileName);
      reg.WriteString('OutputFile', PDFFullfileName);
      reg.WriteString('CurDir', PDFfilePath);
      reg.WriteString('AutoSaveDir', PDFfilePath);
    end
    else
    begin
      ShowMessage('Cannot find '+keyNameTemp);
    end;

    keyNameTemp := keyName + '\' + PDFFactoryVersion + '\FinePrinters\' + PDFFactoryVersion2;
    If Reg.OpenKey(keyNameTemp,False) = True then //False because we do not want to create it if it doesn’t exist
    Begin
      reg.WriteInteger('ShowDlg', ShowDlgValue);
      reg.WriteInteger('PdfAction', PdfActionValue);
      reg.WriteInteger('CollectJobs', CollectJobsValue);
    end
    else
    begin
      ShowMessage('Cannot find '+keyNameTemp);
    end;
  end;
begin
  PDFfilePath := ExtractFilePath(PDFFullfileName);
  PDFfileName := ExtractFileName(PDFFullfileName);

  Reg := TRegistry.Create;

  try
    Val := TStringList.Create;
    Val2 := TStringList.Create;
    try
      Reg.RootKey := HKEY_CURRENT_USER; // Section to look for within the registry
      keyName := '\Software\FinePrint Software';
      if not Reg.OpenKey(keyName,False) then
        ShowMessage('Error opening key')
      else
      begin
        Reg.GetKeyNames(Val);
        for i := 0 to Val.Count-1 do
        begin
          PDFFactoryVersion := Val.Strings[i];
          keyName2 := keyName + '\' + PDFFactoryVersion + '\FinePrinters';
          if not Reg.OpenKey(keyName2, False) then
            ShowMessage('Error opening key')
          else
          begin
            Reg.GetKeyNames(Val2);
            for j := 0 to Val2.Count-1 do
            begin
              if Pos('PDFFACTORY',uppercase(Val2.Strings[j])) > 0 then
              begin
                PDFFactoryVersion2 := Val2.Strings[j];
              end;
            end;
          end;

          AdjustForPDFstd(PDFFullfileName, ShowDlgValue, PdfActionValue, CollectJobsValue);
        end;
      end;
    finally
      Val.Free;
    end;
  finally
    Reg.Free;
  end;
end;*)

procedure AdjustFinePrintRegistrySettings(APDFFullfileName: String); //20160910 Igor
var
  Reg : TRegistry;
  slVerions, slPro: TStringList;
  I: Integer;
  PDFFactoryVersion: String;
  J: Integer;

const
  c_rootKey = '\Software\FinePrint Software';
Begin
  Reg := TRegistry.Create;
  if APDFFullfileName = '' then
    StartWait('Please wait. The document is being saved to disk'); //20160913
  try
    Reg.RootKey := HKEY_CURRENT_USER; // Section to look for within the registry
    if not Reg.OpenKey(c_RootKey,False) then
    begin
      ShowMessage('Error opening key');
      exit;
    end;
    slVerions := TStringList.Create;
    try
      Reg.GetKeyNames(slVerions);
      for i := 0 to slVerions.Count-1 do
      begin
        if not reg.OpenKey(c_rootKey + '\' + slVerions[I] + '\FinePrinters', False) then
          Continue;
        slPro := TStringList.Create;
        try
          Reg.GetKeyNames(slPro);
          for J := 0 to slPro.Count - 1 do
          begin
            if Pos('PDFFACTORY', uppercase(slPro[j])) = 0 then
              continue;
            if not Reg.OpenKey(c_rootKey + '\' + slVerions[I] + '\FinePrinters\'+slPro[j], false) then
              continue;
            if APDFFullfileName = '' then
            begin
              if not((reg.ReadInteger('CollectJobs') = 999) or Printer.Aborted) then
              begin
                reg.WriteInteger('CollectJobs', -1); //show UI after spooling
                if Printer.Printing then
                  Printer.EndDoc;
                Printer.BeginDoc;
                Printer.EndDoc;
                repeat
                  sleep(500);
                until reg.ReadInteger('CollectJobs') = 0; //Wait save
              end
              else
                reg.WriteInteger('CollectJobs', 0);
              reg.WriteInteger('ShowDlg', 1); //show UI after spooling
              reg.WriteInteger('PdfAction', 0);
            end
            else
            begin
              reg.WriteInteger('ShowDlg', 2); //do not show UI, do not email, do not view PDF file
              reg.WriteInteger('PdfAction', 0);
              reg.WriteInteger('CollectJobs', 999);
            end;
          end;
        finally
          slPro.Free;
        end;
        reg.OpenKey(c_rootKey + '\' + slVerions[I], False);
        if (APDFFullfileName = '') then
        begin
          if (reg.ValueExists('OutputFile'))  then
            reg.DeleteValue('OutputFile');
        end
        else
          reg.WriteString('OutputFile', APDFFullfileName);
      end;
    finally
      slVerions.Free;
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
    if APDFFullfileName = '' then
      EndWait;
  end;
End;

procedure StartWait(ACaption: String); //20160910 Igor //20200218 Igor
var
  L: TLabel;
begin
  if CheckIsCloud(true) then Exit; //20200305 Igor
  if assigned(WaitForm) then
    exit;
  WaitForm := TForm.CreateNew(Application);
  WaitForm.Height := 150;
  WaitForm.Width := 400;
  WaitForm.Position := poMainFormCenter;
  WaitForm.BorderStyle := bsNone;
  WaitForm.FormStyle := fsStayOnTop;
  WaitForm.Color := RGB(50, 50, 100);
  L := TLabel.Create(WaitForm);
  L.Name := 'lbWaitFormCaption'; //20200218 Igor
  L.Parent := WaitForm;
  L.Align := alClient;
  L.Font.Size := 14;
  L.Alignment := taCenter;
  L.Layout := tlCenter;
  L.AlignWithMargins := True;
  L.Margins.Top := 10;
  L.Margins.Left := 10;
  L.Margins.Right := 10;
  L.Margins.Bottom := 10;
  L.Transparent := False;
  L.Color := RGB(250, 250, 250);
  L.Caption := ACaption;
  WaitForm.Show;
  WaitForm.Refresh;
end;

procedure SetWaitCaption(ACaption: string); //20200218 Igor
var I: integer;
begin
  if CheckIsCloud(true) then Exit; //20200305 Igor
  if not Assigned(WaitForm) then
    exit;
  for I := 0 to WaitForm.ComponentCount - 1 do
    if WaitForm.Components[I] is TLabel then
      if SameText(TLabel(WaitForm.Components[I]).Name, 'lbWaitFormCaption') then
      begin
        TLabel(WaitForm.Components[I]).Caption := ACaption;
        WaitForm.Refresh;
        break;
      end;
end;

procedure EndWait; //20160910 Igor
begin
  if CheckIsCloud(true) then Exit; //20200305 Igor
  if not assigned(WaitForm) then
    exit;
  WaitForm.Close;
  FreeAndNil(WaitForm);
end;

function GetCorrectFileName(AFileName: String): String; //20161227 Igor
var
  I: Integer;
Begin
  Result := AFileName;
  for I := 1 to Length(Result) do
    if CharInSet(Result[I], ['\','/',':','*','?','"','<','>','|']) then
      Result[I] := '_';
End;

//20170728 Igor<<<
function DatePartsIsCorrect(const AY, AM, AD: String; var AYY, AMM, ADD: Integer): Boolean;
begin
  Result := tryStrToInt(AY, AYY) AND
            tryStrToInt(AM, AMM)  AND
            tryStrToInt(AD, ADD) AND
            (AYY > 1900) AND
            (AYY < YearOf(Now) + 100) AND
            (AMM >= 1) AND
            (AMM <= 12) AND
            (ADD >= 1) AND
            (ADD <= DayOf(IncDay(IncMonth(EncodeDate(AYY, AMM, 1), 1), - 1)));
end;

function TryYYYYMMDDToDate(ADateStr: string; var ADate: TDateTime): Boolean;
var
  sYYYY, sMM, sDD: String;
  iYYYY, iMM, iDD: Integer;
begin
  if length(ADateStr) <> 8 then
    exit(false);
  sYYYY := Copy(ADateStr, 1, 4);
  sMM := Copy(ADateStr, 5, 2);
  sDD := Copy(ADateStr, 5, 2);
  Result := DatePartsIsCorrect(sYYYY, sMM, sDD, iYYYY, iMM, iDD);
  if Result then
    ADate := EncodeDate(iYYYY, iMM, iDD);
end;

function TryDDMMYYYYToDate(ADateStr: string; var ADate: TDateTime): Boolean;
var
  sYYYY, sMM, sDD: String;
  iYYYY, iMM, iDD: Integer;
begin
  if length(ADateStr) <> 8 then
    exit(false);
  sDD := Copy(ADateStr, 1, 2);
  sMM := Copy(ADateStr, 3, 2);
  sYYYY := Copy(ADateStr, 5, 4);
  Result := DatePartsIsCorrect(sYYYY, sMM, sDD, iYYYY, iMM, iDD);
  if Result then
    ADate := EncodeDate(iYYYY, iMM, iDD);
end;

function TryMMDDYYYYTodate(ADateStr: string; var ADate: TDateTime): Boolean;
var
  sYYYY, sMM, sDD: String;
  iYYYY, iMM, iDD: Integer;
begin
  if length(ADateStr) <> 8 then
    exit(false);
  sMM := Copy(ADateStr, 1, 2);
  sDD := Copy(ADateStr, 3, 2);
  sYYYY := Copy(ADateStr, 5, 4);
  Result := DatePartsIsCorrect(sYYYY, sMM, sDD, iYYYY, iMM, iDD);
  if Result then
    ADate := EncodeDate(iYYYY, iMM, iDD);
end;

function YYYYMMDDToDate(ADateStr: string): TDateTime;
begin
  if not TryYYYYMMDDToDate(ADateStr, Result) then
    raise Exception.Create(Format('Invalid formatted date value "%s".', [ADateStr]));
end;

function DDMMYYYYToDate(ADateStr: string): TDateTime;
begin
  if not TryDDMMYYYYToDate(ADateStr, Result) then
    raise Exception.Create(Format('Invalid formatted date value "%s".', [ADateStr]));
end;

function MMDDYYYYTodate(ADateStr: string): TDateTime;
begin
  if not TryMMDDYYYYTodate(ADateStr, Result) then
    raise Exception.Create(Format('Invalid formatted date value "%s".', [ADateStr]));
end;

//20170728 Igor>>>

function SamePath(const APath1, APath2: String): Boolean;//20170803 Igor
begin
//20170811 Igor>>>
  if (APath1 <> '') and (APath2 <> '') then
    Result := SameText(ExcludeTrailingPathDelimiter(TPath.GetFullPath(APath1)),
                       ExcludeTrailingPathDelimiter(TPath.GetFullPath(APath2)))
  else
    Result := False;
//20170811 Igor<<<
end;

//20170901 Igor>>>
procedure NormalizeSize(const D: Int64; out F: real; out S: String); overload;
begin
  if D < 1024 then
  begin
    S := 'b';
    F := D;
  end
  else
  if D < (1024 * 1024) then
  begin
    S := 'Kb';
    F := D / 1024;
  end
  else
  if D < (1024 * 1024 * 1024) then
  begin
    S := 'Mb';
    F := D / 1024 / 1024;
  end
  else
  begin
    S := 'Gb';
    F := D / 1024 / 1024 / 1024;
  end;
end;

procedure NormalizeSize(const D: UInt64; out F: real; out S: String); overload;
begin
  if D < 1024 then
  begin
    S := 'b';
    F := D;
  end
  else
  if D < (1024 * 1024) then
  begin
    S := 'Kb';
    F := D / 1024;
  end
  else
  if D < (1024 * 1024 * 1024) then
  begin
    S := 'Mb';
    F := D / 1024 / 1024;
  end
  else
  begin
    S := 'Gb';
    F := D / 1024 / 1024 / 1024;
  end;
end;

function MakeDrivesStr(A: TStringDynArray): String;
var
  S: String;
  D1, D2: Int64;
  F1, F2, F3: Real;
  S1, S2: String;
begin
  Result := '';
  for S in A do
  begin
  //20170909 Igor>>>
    if not GetDiskFreeSpaceExW(PChar(S), D1, D2, nil) then
      Continue;
  //20170909 Igor<<<
    if D2 > 0 then
    begin
      F3 := (d1 / d2) * 100;
      NormalizeSize(D1, F1, S1);
      NormalizeSize(D2, F2, S2);
      Result := Result + Format('    %s    %.2f %s free of %.2f %s (%2.2f%%);',
        [S, F1, S1, F2, S2, F3]) + #13#10;
    end
    else
      Result := Result + Format('    %s', [S]) + #13#10;
  end;
end;

function MakeMemoryStr: String;
var
  MStatus: TMemoryStatusEx;
  F1, F2, F3: Real;
  S1, S2: String;
begin
  MStatus.dwLength:=SizeOf(MStatus);
  GlobalMemoryStatusEx(MStatus);
  NormalizeSize(MStatus.ullAvailPhys, F1, S1);
  NormalizeSize(MStatus.ullTotalPhys, F2, S2);
  if MStatus.ullTotalPhys <> 0 then
    F3 := MStatus.ullAvailPhys / MStatus.ullTotalPhys * 100
  else
    F3 := 0;
  Result := Format('    %.2f %s free of %.2f %s (%2.2f%%)',
    [F1, S1, F2, S2, F3]);
end;

function MakeScreenStr: String;
var
  I: Integer;
begin
  Result := '    Pixels Per Inch: ' + IntToStr(Screen.PixelsPerInch) + #13#10;
  for I := 0 to Screen.MonitorCount - 1 do
    Result := Result + Format('    Monitor #%d: %d X %d',
      [Screen.Monitors[I].MonitorNum + 1, Screen.Monitors[I].Width, Screen.Monitors[I].Height]) + #13#10;
end;

function OSTest: String;
begin
  Result :=
    'OS: ' + #13#10 + '    ' + TOSVersion.ToString + #13#10#13#10 +
    'Drives: ' + #13#10 + MakeDrivesStr(TDirectory.GetLogicalDrives) + #13#10 +
    'Memory: ' + #13#10 + MakeMemoryStr + #13#10#13#10 +
    'Screen: ' + #13#10 + MakeScreenStr;
end;
//20170901 Igor<<<


//20170904 Igor>>>
Function GetTrFolder: String;
begin
  //20180201 Igor >>>
  //20180205 Igor >>>
  {if (CurrentApp <> nil) AND TFile.Exists(TPath.Combine(CurrentApp.AppDir, 'TrFolder.d')) then
  begin
    Result := Trim(TFile.ReadAllText(TPath.Combine(CurrentApp.AppDir, 'TrFolder.d')));
    if not FileExists(TPath.Combine(Result, ReplaceStr(ExeYear, 'VT-', 'TR') + '.exe')) then
      Result := ExeDir;
  end
  else}
  //20180205 Igor <<<
    Result := ExeDir;
  //20180201 Igor <<<
end;

Function IsTrLoaded: Boolean;
begin
  Result := GetTrHandle <> 0;
end;

Procedure LoadTr(TrFolder: String); //20200914 Igor
Var
  h: THandle;
  path: string;
begin
  if CheckIsCloud(true) then
  begin
    if not Assigned(EngineTR_2026) then
      EngineTR_2026 := EngineTR_2026.Create(Application);
    EngineTR_2026.Show;
  end
  else
  begin
    path := TPath.Combine(TrFolder, ReplaceStr(ExeYear, 'VT-', 'TR') + '.exe');
    h := ShellExecute(Application.MainForm.Handle, Nil,
                      PChar(path), Nil, '', SW_RESTORE);
    If H <= 32 then
      ShowMessage('The ' + ReplaceStr(ExeYear, 'VT-', 'TR-') + ' was not installed in ' + TrFolder + ' see Configure');
  end;
end;

Function GetTrHandle: HWND;
begin
  result := FindWindow(PChar('TTrEngine'), Nil);
end;

Procedure LinkToTR(SearchItem: String);
Var
  h: THandle;
begin
  TrFolder := GetTrFolder;
  h := GetTrHandle;
  If h <> 0 then
  begin
    ShowWindow(h, SW_MAXIMIZE);
    Clipboard.AsText := 'From ' + CurrentApp.AppName + '|Search|' + SearchItem;
    Application.Minimize;
  end
  else
  begin
    Application.Minimize;
    LoadTr(TrFolder);
  end
end;

procedure SetupTrFolder;
var
  promt: array of string;
begin
  SetLength(promt, 1);
  promt[0] := GetTrFolder;
  if promt[0].IsEmpty then
    promt[0] := ExeDir;
  if not InputQuery('Setup TR folder', ['Enter your TR installation folder'], promt,
      function(const Values: array of string): Boolean
      begin
        if not TFile.Exists(TPath.Combine(Values[0], ReplaceStr(ExeYear, 'VT-', 'TR') + '.exe')) then
          result :=  MessageDlg('The ' + ReplaceStr(ExeYear, 'VT-', 'TR-') + ' was not installed in ' + promt[0] + ' directory!' + #13 +
                                'Do you still want to save this value in the configuration?'  ,
                                mtWarning, [mbYes, mbNo], 0, mbNo) = mrYes
        else
          Result := True;
      end) then
    Exit;
  TFile.WriteAllText(TPath.Combine(CurrentApp.AppDir, 'TrFolder.d'), promt[0]);
end;
//20170904 Igor<<<
//20170927 Igor>>>
procedure OpenAnyFile(PgmPath, PgmFile: String);
Var
  h: Thandle;
  PgmPathS, PgmS, PgmParmsS: String;
  PgmPathZ: Array[0..254] of Char;
  PgmParmsZ: Array[0..254] of Char;
  PgmZ: Array[0..254] of Char;
begin
  if CheckIsCloud(true) then //20180503 Igor
  begin
    if SameText(ExtractFileExt(PgmFile), '.pdf') then
      VUIPrintPDF(TPath.Combine(PgmPath, PgmFile))
    else
      MessageDlg(c_NotAvailable, mtError, [mbOk], 0);
  end
  else
  begin
    StrPCopy(PgmPathZ, PgmPath);
    PgmS := PgmFile;
    StrPCopy(PgmZ, PgmS);
    PgmParmsS := '';
    StrPCopy(PgmParmsZ, PgmParmsS);
    h := ShellExecute(Application.MainForm.Handle, Nil, PgmZ, PgmParmsZ, PgmPathz, SW_RESTORE);
    If H = 31 then
      ShowMessage('There is no file association, or file extension is not visible (Explorer Option)')
    else
    if H < 31 then
      ShowMessage('File not found ');
  end;
end;

procedure ShowPDF(PgmPath, PDFFile: String);
begin
  OpenAnyFile(PgmPath, PDFFile);
end;
//20170927 Igor<<<

function DefaultDataDir(FApp: TApp): string;
begin
  //20180503 Igor >>>
  if CheckIsCloud(true) then //20180503 Igor
  //20190213 Igor >>>
  begin    
    if not SameText(CloudDataDir, '') then
      Result := TPath.Combine(CloudDataDir, FApp.AppId)
    else
      Result := TPath.Combine(CloudDir, FApp.AppId)    
  end
  //20190213 Igor <<<
  else
    Result := TPath.Combine('C:\VT\', FApp.AppId);
  //20180503 Igor <<<
end;

Function IsInTapesList(RetNo: Integer; Fname: String; elm: Integer): Boolean; //20220121 Igor
var
  i: Integer;
  A: TArray<string>;
  TapeFName: String;
  TapeElm: Integer;
begin
  Result := false;
  For i := 0 to RetList[RetNo].TapesList.Count - 1 do
  begin
    A := RetList[RetNo].TapesList[i].Split(['|'], ExcludeEmpty);
    if Length(A) < 2 then continue;
    TapeFName := AllTrim(A[0]);
    TapeElm := MyStrToInt(AllTrim(A[1]));
    If (Fname = TapeFName) and (elm = TapeElm) then
    begin
      Result := True;
      exit;
    end;
  end;
end;

function ProcessMessageText(AText: string): string; //20230216 Igor
var
  X: XML.XMLDoc.TXMLDocument;
  N, TempNode, LinkNode: IXMLNode;
  I, J: Integer;
  HyperlinkText, HyperlinkTarget: String;
  function ClearXML(AXML: String): string;
  begin
    Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
    Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
  end;
begin
  Result := '';
  if AText.IsEmpty then Exit;
  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    X.XML.Clear;
    X.XML.Add(ClearXML(AText));
    if not(X.Active) then
      X.Active := true;
    N := X.DocumentElement;
    // collect all MessageText
    for I := 0 to N.ChildNodes.Count - 1 do
    begin
      TempNode := N.ChildNodes.Nodes[I];
     // if SameText(TempNode.NodeName, 'MessageText') then
      if SameText(TempNode.NodeName, 'MessageText')
      and not TempNode.Text.IsEmpty then //20260311 Igor
    begin
        if not Result.IsEmpty then
          Result := Result + '<br>';
        Result := Result + TempNode.NodeValue;
      end;
    end;
    // apply Hyperlinks to Result
    for I := 0 to N.ChildNodes.Count - 1 do
    begin
      TempNode := N.ChildNodes.Nodes[I];
      if SameText(TempNode.NodeName, 'Hyperlink') then
      begin
        HyperlinkText := '';
        HyperlinkTarget := '';
        for J := 0 to TempNode.ChildNodes.Count - 1 do
          if SameText(TempNode.ChildNodes.Nodes[J].NodeName, 'HyperlinkText') then
            HyperlinkText := TempNode.ChildNodes.Nodes[J].NodeValue
          else if SameText(TempNode.ChildNodes.Nodes[J].NodeName, 'HyperlinkTarget') then
            HyperlinkTarget := TempNode.ChildNodes.Nodes[J].NodeValue;
        if not HyperlinkText.IsEmpty and not HyperlinkTarget.IsEmpty then
          Result := ReplaceText(Result, HyperlinkText, '<a href="'+ HyperlinkTarget +'">'+ HyperlinkText + '</a>');
      end;
    end;
  finally
    X.Free;
  end;
end;

end.
