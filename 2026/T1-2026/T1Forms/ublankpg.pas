unit ublankpg;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, ComCtrls,
  vtLabel, jpeg, vtShape;
type
TBlankPg = class(TForm)
    vtEdit1: TvtEdit;
    vtShape5: TvtShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
BlankPg: TBlankPg
implementation
{$R *.DFM}
end.
