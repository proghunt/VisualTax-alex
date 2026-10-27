{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryRegistry.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryRegistry;

{$I DebenuPDFLibraryDefines.inc}

interface

{$IFDEF QPL_OS_WINDOWS}
uses
  Windows;
{$ENDIF}

function ReadRegString(const Key: AnsiString): AnsiString;

implementation

{$IFNDEF QPL_OS_WINDOWS}
function ReadRegString(const Key: AnsiString): AnsiString;
begin
  Result := '';
end;
{$ELSE}
uses
{$IFDEF QPL_XE4_HIGHER}
  AnsiStrings,
{$ENDIF}
  SysUtils, DebenuPDFLibraryExtra;

function ReadRegString(const Key: AnsiString): AnsiString;
var
  OpenKey: HKEY;
  RootKey: HKEY;
  ValueName: AnsiString;
  S: AnsiString;
  X: Integer;
  L: Integer;
  DataType: Integer;    
begin
  Result := '';
  S := Key;
  RootKey := HKEY_CURRENT_USER;
  if QPLCopy(S, 1, 19) = 'HKEY_LOCAL_MACHINE\' then
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    Delete(S, 1, 19);
  end;
  X := Length(S) + 1;
  repeat
    Dec(X);
  until (S[X] = '\') or (X = 1);
  if QPLCopy(S, X, 1) = '\' then
  begin
    ValueName := QPLCopy(S, X + 1, MaxInt);
    Delete(S, X, MaxInt);
    if RegOpenKeyExA(RootKey, PAnsiChar(S), 0, KEY_READ, OpenKey) = ERROR_SUCCESS then
    begin
      if RegQueryValueExA(OpenKey, PAnsiChar(ValueName), nil, @DataType, nil, @L) = ERROR_SUCCESS then
      begin
        if L > 0 then
        begin
          SetLength(Result, L);
          DataType := REG_NONE;
          if RegQueryValueExA(OpenKey, PAnsiChar(ValueName), nil, @DataType, @Result[1],
            @L) = ERROR_SUCCESS then
          begin
            if DataType = REG_SZ then
            begin
{$IFDEF QPL_XE4_HIGHER}
              SetLength(Result, AnsiStrings.StrLen(PAnsiChar(Result)));
{$ELSE}
              SetLength(Result, StrLen(PAnsiChar(Result)));
{$ENDIF}
            end else
              Result := '';
          end else
            Result := '';
        end;
      end;
      RegCloseKey(OpenKey);
    end;
  end;
end;
{$ENDIF}

end.
