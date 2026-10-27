unit UMyEdit;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TMyEdit = class(TEdit)
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
  BorderStyle := bsNone;
  {Font.Name := 'Ms Sans Serif';}
  {Font.Size := 8;}
 { FontStyle := Bold;}

  Height := 14;
  MaxLength := 12;
  end;
procedure Register;
begin
  RegisterComponents('Standard', [TMyEdit]);
end;

end.
