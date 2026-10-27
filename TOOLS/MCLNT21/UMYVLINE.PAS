unit UMyVLine;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,ExtCtrls;

type
  TMyVLine = class(TShape)
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

constructor TMyVline.Create(AOwner: TComponent);
begin
 inherited Create(Aowner);
  {color := clRed;}
  Height := 200;
  Width  := 1;
end;

procedure Register;
begin
  RegisterComponents('Standard', [TMyVLine]);
end;

end.
