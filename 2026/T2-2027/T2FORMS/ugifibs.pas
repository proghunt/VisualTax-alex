unit uGIFIBS;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel;
type
TGIFIBS = class(TForm)
    vtGIFIBSLabel1:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
GIFIBS: TGIFIBS;
implementation
{$R *.DFM}
end.
