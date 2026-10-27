unit TR_2026Utils;

interface

uses
  SysUtils, Windows, Forms, Classes, Dialogs, StrUtils;

Function PaddR(S: string; MaxLength: integer): String;
Procedure Delay(ms:Cardinal);
Function ExtractFileNameFromUrl(Url: String): String;
procedure ParseWords(S: string; Delim: string; var WList: TstringList);
Function PaddZero(S: string; MaxLength: integer): String;
function Crypt(const s: string): string;
function GetErrorByCodde(ACode: Integer): String;
function ExecAndWait(const FileName, Params: String; const WinState: Word): boolean;

implementation

Function PaddZero(S: string; MaxLength: integer): String;
begin
  Result := s;
  if Length(Result) < MaxLength then
    Result := Result + StringOfChar('0', MaxLength - Length(Result));
end;

Function PaddR(S: string; MaxLength: integer): String;
begin
  Result := LeftStr(Trim(s), MaxLength);
  if Length(Result) < MaxLength then
    Result := Result + StringOfChar(' ', MaxLength - Length(Result));
end;

Procedure Delay(ms:Cardinal);
Var
  TheTime: Cardinal;
begin
  TheTime := GetTickCount + Ms;
  While GetTickCount < TheTime do
    Application.ProcessMessages;
end;

procedure ParseWords(S: string; Delim: string; var WList: TstringList);
var
  i, FromI, ToI: Integer;
  Wrd: string;
{when calling s:=s+delimiter may need a delimiter at the end in case tere is no last value}
begin
  try
    S := Trim(S);
    WList.Clear;
    if S = '' then
      exit;
    i := 1;
    FromI := 1;
    ToI := Length(S);
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
  except
    ShowMessage('Parsing failed');
   //on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end; //try
end;

Function ExtractFileNameFromUrl(Url: String): String;
Var
  i: Integer;
  s: String;
begin
  s := '';
  i := Length(Url);
  repeat
    s := Url[i] + s;
    Dec(i, 1);
  until (Url[i] = '/') or (Url[i] = '\') or (i < 1);
end;

function Crypt(const s: string): string;
var
  i: integer;
begin
  SetLength(Result, Length(s));
  for i := 1 to Length(s) do
    Result[i] := chr(ord(s[i]) xor $F); //no ctrl chars!
end;

function GetErrorByCodde(ACode: Integer): String;
begin
  case ACode of
    0:
      Result := 'The operating system is out of memory or resources.';
    2:
      Result := 'The specified file was not found';
    3:
      Result := 'The specified path was not found.';
    5:
      Result := 'Windows 95 only: The operating system denied ' + 'access to the specified file';
    8:
      Result := 'Windows 95 only: There was not enough memory to ' + 'complete the operation.';
    10:
      Result := 'Wrong Windows version';
    11:
      Result := 'The .EXE file is invalid (non-Win32 .EXE or ' + 'error in .EXE image).';
    12:
      Result := 'Application was designed for a different operating system';
    13:
      Result := 'Application was designed for MS-DOS 4.0';
    15:
      Result := 'Attempt to load a real-mode program';
    16:
      Result := 'Attempt to load a second instance of ' + 'an application with non-readonly data segments';
    19:
      Result := 'Attempt to load a compressed application file';
    20:
      Result := 'Dynamic-link library (DLL) file failure';
    26:
      Result := 'A sharing violation occurred.';
    27:
      Result := 'The filename association is incomplete or invalid.';
    28:
      Result := 'The DDE transaction could not be completed ' + 'because the request timed out.';
    29:
      Result := 'The DDE transaction failed.';
    30:
      Result := 'The DDE transaction could not be completed because ' + 'other DDE transactions were being processed.';
    31:
      Result := 'There is no application associated with ' + 'the given filename extension.';
    32:
      Result := 'Windows 95 only: The specified dynamic-link ' + 'library was not found.'       else
    Result := 'undocumented'
  end;
end;

function ExecAndWait(const FileName, Params: String; const WinState: Word): boolean;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: String;
begin
  CmdLine := '"' + Filename + '" ' + Params;
  ZeroMemory(@StartInfo, SizeOf(StartInfo));
  with StartInfo do
  begin
    cb := SizeOf(TStartUpInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;
  Result := CreateProcess(nil, PWideChar(CmdLine), nil, nil, false,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                          PChar(ExtractFileDir(Filename)), StartInfo, ProcInfo);
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

end.
