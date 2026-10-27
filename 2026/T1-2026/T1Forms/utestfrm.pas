unit utestfrm;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uacbframe, UDummyFrame, Buttons, Grids;
type
TTestFrm = class(TForm)
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
    vtEdit12: TvtEdit;
    vtEdit13: TvtEdit;
    vtEdit14: TvtEdit;
    vtEdit010001: TvtEdit;
    vtEdit010002: TvtEdit;
    vtEdit010003: TvtEdit;
    vtEdit010006: TvtEdit;
    vtEdit010007: TvtEdit;
    vtEdit010008: TvtEdit;
    vtEdit010009: TvtEdit;
    vtEdit010010: TvtEdit;
    vtEdit010011: TvtEdit;
    vtShape1: TvtShape;
    vtLabel12: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtShape4: TvtShape;
    vtShape3: TvtShape;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel32: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel39: TvtLabel;
    vtShape5: TvtShape;
    vtShape6: TvtShape;
    vtLabel40: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel45: TvtLabel;
    vtLabel1x: TvtLabel;
    vtLabel48: TvtLabel;
    vtLabel50: TvtLabel;
    vtLabel53: TvtLabel;
    vtEdit010012: TvtEdit;
    vtLabel54: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel58: TvtLabel;
    vtEdit010004: TvtEdit;
    vtLabel59: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel64: TvtLabel;
    vtEdit010005: TvtEdit;
    vtShape9: TvtShape;
    vtShape10: TvtShape;
    vtLabel65: TvtLabel;
    vtLabel2: TvtLabel;
    vtShape11: TvtShape;
    vtLabel11: TvtLabel;
    vtEdit1: TvtEdit;
    vtEdit24: TvtEdit;
    vtEdit25: TvtEdit;
    vtShape2: TvtShape;
    vtShape7: TvtShape;
    vtLabel69: TvtLabel;
    vtLabel100: TvtLabel;
    vtEdit29: TvtEdit;
    vtEdit30: TvtEdit;
    vtLabel13: TvtLabel;
    vtLabel24: TvtLabel;
    vtEdit020001: TvtEdit;
    vtEdit020002: TvtEdit;
    AddRowBtn: TBitBtn;
    RemoveRowBtn: TBitBtn;
    vtEdit15: TvtEdit;
    vtLabel1: TvtLabel;
    vtEdit16: TvtEdit;
    vtLabel46: TvtLabel;
    vtEdit17: TvtEdit;
    vtEdit18: TvtEdit;
    vtLabel47: TvtLabel;
    vtLabel49: TvtLabel;
    vtEdit19: TvtEdit;
    vtLabel51: TvtLabel;
    vtEdit20: TvtEdit;
    vtLabel52: TvtLabel;
    vtLabel66: TvtLabel;
    vtEdit21: TvtEdit;
    vtLabel67: TvtLabel;
    vtEdit22: TvtEdit;
    vtLabel68: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
TestFrm: TTestFrm
implementation
{$R *.DFM}
end.
