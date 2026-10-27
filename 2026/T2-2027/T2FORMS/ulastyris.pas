unit uLastYrIS;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape;
type
TLastYrIS = class(TForm)
    vtGIFIISLabel1:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    PageBreak: TvtShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
LastYrIS: TLastYrIS;
implementation
{$R *.DFM}
end.
