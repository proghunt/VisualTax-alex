unit UMyLine;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TMyLine = class(TShape)
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

constructor TMyEdit.Create(AOwner: TComponent);
begin
 inherited Create(Aowner);
  {color := clRed;}
  end;
procedure Register;
begin
  RegisterComponents('Standard', [TMyLine]);
end;

end.
