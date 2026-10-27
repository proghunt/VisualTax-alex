unit UMyHLine;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TMyHLine = class(TShape)
  public
    constructor create(AOwner: TComponent); override;
  private
    { Private declarations }
  protected
    { Protected declarations }
  public

  published
    { Published declarations }
  end;

procedure Register;

implementation

constructor TMyHline.Create(AOwner: TComponent);
begin
 inherited Create(Aowner);
  {color := clRed;}
 Height := 1;
 Width  := 400;
  end;
procedure Register;
begin
  RegisterComponents('Standard', [TMyHLine]);
end;

end.
