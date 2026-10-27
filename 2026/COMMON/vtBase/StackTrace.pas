unit StackTrace;

interface

uses SysUtils, Classes, JclDebug;

procedure EnableExceptionStackTrace;
procedure DisableExceptionStackTrace;

implementation

{$HINTS OFF}
function GetExceptionStackInfoJCL(P: PExceptionRecord): Pointer;
const
  cDelphiException = $0EEDFADE;  // 1
const
  MaxEntries = 40;
  SkipFrames = 1;
  TextBufSize = 1024 * 1024;
var
  Stack : TJclStackInfoList;
  Str : TStringList;
  Trace: String;
  Sz: Integer;

  LReturnAddresses : array[0..MaxEntries - 1] of NativeUInt;
  LTextBuffer : Pointer;
begin
  if P^.ExceptionCode = cDelphiException then
    Stack := JclCreateStackList(False, 3, P^.ExceptAddr)
  else
    Stack := JclCreateStackList(False, 3, P^.ExceptionAddress);
  try
    Str := TStringList.Create;
    try
      Stack.AddToStrings(Str, True, True, True, True);
      Trace := Str.Text;
    finally
      FreeAndNil(Str);
    end;
  finally
    FreeAndNil(Stack);
  end;

  if Trace <> '' then
  begin
    Sz := (Length(Trace) + 1) * SizeOf(Char);
    GetMem(Result, Sz);
    Move(Pointer(Trace)^, Result^, Sz);
  end else
    Result := nil;
end;

function GetStackInfoStringJCL(Info: Pointer): string;
begin
  if(Assigned(Info)) then
    Result := PChar(Info)
  else
    Result := 'EMPTY';
end;

procedure CleanUpStackInfoJCL(Info: Pointer);
begin
  if(Assigned(Info)) then
    FreeMem(Info);
end;

{$HINTS ON}

// -------------------------------------------------------------------------------------------------

procedure EnableExceptionStackTrace;
begin
  Exception.GetExceptionStackInfoProc := GetExceptionStackInfoJCL;
  Exception.GetStackInfoStringProc := GetStackInfoStringJCL;
  Exception.CleanUpStackInfoProc := CleanUpStackInfoJCL;
end;

procedure DisableExceptionStackTrace;
begin
  Exception.GetExceptionStackInfoProc := nil;
  Exception.GetStackInfoStringProc := nil;
  Exception.CleanUpStackInfoProc := nil;
end;

initialization
  EnableExceptionStackTrace;

finalization
  DisableExceptionStackTrace;

end.
