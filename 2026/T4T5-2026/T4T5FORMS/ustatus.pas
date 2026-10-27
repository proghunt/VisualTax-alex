unit USTATUS;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape;
type
  TSTATUS = class(TForm)
    Label1: TvtLabel;
    Label2: TvtLabel;
    vtEdit1:TvtEdit;
    Label5: TvtLabel;
    vtEdit3:TvtEdit;
    Label6: TvtLabel;
    vtEdit4:TvtEdit;
    Label10: TvtLabel;
    vtEdit11:TvtEdit;
    vtEdit12:TvtEdit;
    vtEdit13:TvtEdit;
    Label21: TvtLabel;
    Label22: TvtLabel;
    Label23: TvtLabel;
    vtLabel1: TvtLabel;
    vtEdit14: TvtEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
STATUS: TSTATUS;
implementation
{$R *.DFM}
end.
