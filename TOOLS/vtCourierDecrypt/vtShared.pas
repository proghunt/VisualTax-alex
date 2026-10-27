unit vtShared;

// fake vtShared, if some function are absent, they should be copied from original vtShared

interface

uses Windows;

procedure Checkupdates(WindowHandle: HWND; AppTitle: string);
function UrlVersionFile: String;

implementation

procedure Checkupdates(WindowHandle: HWND; AppTitle: string);
begin

end;

function UrlVersionFile: String;
begin
  Result := '';
end;

end.
