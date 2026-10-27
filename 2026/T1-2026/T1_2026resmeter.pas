(******************************************************************************)
(*                                                                            *)
(*    Unit Name        : ResMeter.pas                                         *)
(*    Unit Version     : 1.0.3.5                                              *)
(*    Author           : Chua Wen Kiat                                        *)
(*    Website          : http://www.geocities.com/chuawenkiat/resmeter        *)
(*    Email            : chuawenkiat@hotmail.com                              *)
(*                                                                            *)
(******************************************************************************)

unit T1_2026resmeter;

interface

uses Windows,SysUtils;

function GetSystemResources: Integer;
function GetGDIResources: Integer;
function GetUserResources: Integer;
function RunningLowOnResources: Boolean;

implementation {***************************************************************}

var
  hKernel32_Dll: HWND;
  _QT_Thunk: procedure; cdecl;
  hUser_Exe: HWND;
  _GetFreeSystemResources: function(const nResourceType: Word): Word; stdcall;

function _LoadLibrary16(pLibraryName: PChar): HWND; stdcall; external kernel32 index 35;
procedure _FreeLibrary16(hInstance: HWND); stdcall; external kernel32 index 36;
function _GetProcAddress16(hInstance: HWND; pProcName: PChar): Pointer; stdcall; external kernel32 index 37;

function GetFreeSystemResources(const nResourceType: Word): Integer;
var
  aThunk: array[0..32] of Word;
  nFreeSystemResources: Word;
begin
  Result := -1;
  if Win32Platform <> VER_PLATFORM_WIN32_NT then
  begin
    if Assigned(_GetFreeSystemResources) then
    begin
      aThunk[0] := hUser_Exe;
      asm
        push nResourceType
        mov edx, _GetFreeSystemResources
        call _QT_Thunk
        mov nFreeSystemResources, ax
      end;
      Result := nFreeSystemResources;
    end;
  end;
end;

function GetSystemResources;
begin
  Result := GetFreeSystemResources(0);
end;

function GetGDIResources;
begin
  Result := GetFreeSystemResources(1);
end;

function GetUserResources;
begin
  Result := GetFreeSystemResources(2);
end;

function RunningLowOnResources;
begin
  Result := False;
  if Win32Platform <> VER_PLATFORM_WIN32_NT then
    Result := ((GetSystemResources <= 10) and (GetSystemResources > -1)) or ((GetGDIResources <= 10) and (GetGDIResources > -1)) or ((GetUserResources <= 10) and (GetUserResources > -1));
end;

initialization
//2015027
begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT then
  {begin
    hKernel32_Dll := LoadLibrary(kernel32);
    if hKernel32_Dll > 0 then
    begin
      @_QT_Thunk := GetProcAddress(hKernel32_Dll, 'QT_Thunk');
      if Assigned(_QT_Thunk) then
      begin
        hUser_Exe := _LoadLibrary16('user.exe');
        if hUser_Exe >= 32 then
          @_GetFreeSystemResources := _GetProcAddress16(hUser_Exe, 'GetFreeSystemResources');
      end;
    end;
  end; }
end;

finalization
begin
  if Win32Platform <> VER_PLATFORM_WIN32_NT then
  begin
    if hKernel32_Dll > 0 then
    begin
      if hUser_Exe >= 32 then
        _FreeLibrary16(hUser_Exe);
      FreeLibrary(hKernel32_Dll);
    end;
  end;
end;

end.

