unit uGIFIIS;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel;
type
TGIFIIS = class(TForm)
    vtGIFIISLabel1:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
GIFIIS: TGIFIIS;
implementation
{$R *.DFM}
end.
