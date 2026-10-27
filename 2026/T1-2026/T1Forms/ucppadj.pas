unit ucppadj;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape;
type
TCppAdj = class(TForm)
    vtEdit1: TvtEdit;
    vtEdit2: TvtEdit;
    vtEdit3: TvtEdit;
    vtEdit4: TvtEdit;
    vtEdit5: TvtEdit;
    vtEdit6: TvtEdit;
    vtEdit7: TvtEdit;
    vtEdit8: TvtEdit;
    vtEdit9: TvtEdit;
    vtEdit10: TvtEdit;
    vtEdit11: TvtEdit;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    PageBreak: TvtShape;
    vtEdit12: TvtEdit;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    vtEdit13: TvtEdit;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel23: TvtLabel;
    vtEdit14: TvtEdit;
    vtLabel24: TvtLabel;
    vtEdit15: TvtEdit;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtEdit16: TvtEdit;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtEdit17: TvtEdit;
    vtLabel30: TvtLabel;
    vtLabel31: TvtLabel;
    vtEdit18: TvtEdit;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel32: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel40: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel45: TvtLabel;
    vtShape4: TvtShape;
    vtLabel47: TvtLabel;
    vtLabel48: TvtLabel;
    vtLabel49: TvtLabel;
    vtLabel51: TvtLabel;
    vtEdit19: TvtEdit;
    vtLabel52: TvtLabel;
    vtLabel53: TvtLabel;
    vtLabel54: TvtLabel;
    vtLabel55: TvtLabel;
    vtShape5: TvtShape;
    vtLabel46: TvtLabel;
    vtShape1: TvtShape;
    vtShape2: TvtShape;
    vtShape3: TvtShape;
    vtLabel56: TvtLabel;
    vtEdit20: TvtEdit;
    vtLabel50: TvtLabel;
    vtLabel16: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
CppAdj: TCppAdj
implementation
{$R *.DFM}
end.
