unit uFPInfo;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape;
type
TFPInfo = class(TForm)
    vtLabel1:TvtLabel;
    vtLabel2:TvtLabel;
    vtLabel3:TvtLabel;
    vtLabel4:TvtLabel;
    vtLabel5:TvtLabel;
    vtLabel6:TvtLabel;
    vtLabel7:TvtLabel;
    vtLabel9:TvtLabel;
    vtLabel10:TvtLabel;
    vtEdit1:TvtEdit;
    vtShape5: TvtShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
FPInfo: TFPInfo;
implementation
{$R *.DFM}
end.
