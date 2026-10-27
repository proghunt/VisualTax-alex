unit uLastYrBS;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape;
type
TLastYrBS = class(TForm)
    vtGIFIBSLabel1:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    PageBreak: TvtShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
LastYrBS: TLastYrBS;
implementation
{$R *.DFM}
end.
