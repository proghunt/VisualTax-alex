unit T1F;
{=============================================================}
interface
{=============================================================}

uses
  SysUtils;
  {,WinProcs,Graphics,WinTypes,Forms,Classes,Dialogs;}

function MinR(X, Y: Integer): Integer; export;
function MaxR(X, Y: Integer): Integer; export;

{-----------------------------------------}

implementation

function MinR(X, Y: Integer): Integer;
  begin
   if X < Y then MinR := X else MinR := Y;
  end;

function MaxR(X, Y: Integer): Integer;
  begin
    if X > Y then MaxR := X else MaxR := Y;
  end;

  end.




