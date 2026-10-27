unit vtTrimStr;

// fake vtTrimStr, if some function are absent, they should be copied from original vtTrimStr

interface

uses Windows;

function Min(a, b: integer): integer;

implementation

function Min(a, b: integer): integer;
begin
  if a < b then
    Result := a
  else
    Result := b
end;

end.
