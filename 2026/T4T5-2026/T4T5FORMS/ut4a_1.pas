unit Ut4a_1;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uFlagFrameCan;
type
  TT4A_1 = class(TForm)
    Label9: TvtLabel;
    Label11: TvtLabel;
    Label12: TvtLabel;
    Label19: TvtLabel;
    Label20: TvtLabel;
    Label31: TvtLabel;
    Label32: TvtLabel;
    Label35: TvtLabel;
    Label36: TvtLabel;
    Label38: TvtLabel;
    Label39: TvtLabel;
    Label71: TvtLabel;
    Label17: TvtLabel;
    Label18: TvtLabel;
    Label23: TvtLabel;
    Label40: TvtLabel;
    Label41: TvtLabel;
    Shape12: TvtShape;
    Label4: TvtLabel;
    Label61: TvtLabel;
    Label138: TvtLabel;
    Label179: TvtLabel;
    Label63: TvtLabel;
    Label57: TvtLabel;
    Label58: TvtLabel;
    Label124: TvtLabel;
    Label2: TvtLabel;
    Label6: TvtLabel;
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
    vtEdit12: TvtEdit;
    vtEdit13: TvtEdit;
    vtEdit14: TvtEdit;
    vtEdit15: TvtEdit;
    vtEdit16: TvtEdit;
    vtEdit17: TvtEdit;
    vtEdit18: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
    vtEdit21: TvtEdit;
    Label3: TvtLabel;
    Label7: TvtLabel;
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtEdit24: TvtEdit;
    vtEdit25: TvtEdit;
    vtEdit26: TvtEdit;
    vtEdit27: TvtEdit;
    Label8: TvtLabel;
    Label10: TvtLabel;
    vtEdit28: TvtEdit;
    vtEdit29: TvtEdit;
    Label15: TvtLabel;
    Label16: TvtLabel;
    vtEdit30: TvtEdit;
    Label21: TvtLabel;
    Label24: TvtLabel;
    Label26: TvtLabel;
    Label27: TvtLabel;
    Label89: TvtLabel;
    Shape22: TvtShape;
    Label90: TvtLabel;
    Label91: TvtLabel;
    Label93: TvtLabel;
    Label94: TvtLabel;
    Label95: TvtLabel;
    Label96: TvtLabel;
    Label97: TvtLabel;
    Label98: TvtLabel;
    Label99: TvtLabel;
    Label100: TvtLabel;
    Label101: TvtLabel;
    Label102: TvtLabel;
    Shape24: TvtShape;
    Shape25: TvtShape;
    Label13: TvtLabel;
    Shape1: TvtShape;
    vtEdit31: TvtEdit;
    vtEdit32: TvtEdit;
    vtEdit33: TvtEdit;
    vtEdit34: TvtEdit;
    vtEdit35: TvtEdit;
    vtEdit36: TvtEdit;
    vtEdit37: TvtEdit;
    vtEdit38: TvtEdit;
    vtEdit39: TvtEdit;
    vtEdit40: TvtEdit;
    vtEdit41: TvtEdit;
    vtEdit42: TvtEdit;
    vtEdit43: TvtEdit;
    vtEdit44: TvtEdit;
    vtEdit46: TvtEdit;
    vtEdit47: TvtEdit;
    vtEdit48: TvtEdit;
    vtEdit49: TvtEdit;
    vtEdit50: TvtEdit;
    Shape2: TvtShape;
    Shape3: TvtShape;
    Shape4: TvtShape;
    Shape5: TvtShape;
    Label25: TvtLabel;
    Label28: TvtLabel;
    Label29: TvtLabel;
    Label30: TvtLabel;
    Label33: TvtLabel;
    Label34: TvtLabel;
    Label37: TvtLabel;
    Label42: TvtLabel;
    Label43: TvtLabel;
    Label44: TvtLabel;
    Label45: TvtLabel;
    Label46: TvtLabel;
    Label47: TvtLabel;
    Label48: TvtLabel;
    Label49: TvtLabel;
    Label50: TvtLabel;
    Label51: TvtLabel;
    Label52: TvtLabel;
    Label55: TvtLabel;
    Label56: TvtLabel;
    Label62: TvtLabel;
    Label64: TvtLabel;
    Label65: TvtLabel;
    Label66: TvtLabel;
    Label67: TvtLabel;
    Label68: TvtLabel;
    Label69: TvtLabel;
    Label70: TvtLabel;
    Label72: TvtLabel;
    Label73: TvtLabel;
    Label74: TvtLabel;
    Label75: TvtLabel;
    Label76: TvtLabel;
    Label77: TvtLabel;
    Label78: TvtLabel;
    Label80: TvtLabel;
    Label81: TvtLabel;
    Label82: TvtLabel;
    Label83: TvtLabel;
    Label84: TvtLabel;
    Label85: TvtLabel;
    Label86: TvtLabel;
    Label87: TvtLabel;
    Label88: TvtLabel;
    Label92: TvtLabel;
    Label103: TvtLabel;
    Label104: TvtLabel;
    Label105: TvtLabel;
    Shape21: TvtShape;
    vtEdit51: TvtEdit;
    vtEdit52: TvtEdit;
    vtEdit53: TvtEdit;
    vtEdit54: TvtEdit;
    vtEdit55: TvtEdit;
    vtEdit56: TvtEdit;
    vtEdit57: TvtEdit;
    vtEdit58: TvtEdit;
    vtEdit59: TvtEdit;
    vtEdit60: TvtEdit;
    vtEdit61: TvtEdit;
    vtEdit62: TvtEdit;
    vtEdit63: TvtEdit;
    vtEdit64: TvtEdit;
    vtEdit65: TvtEdit;
    vtEdit66: TvtEdit;
    vtEdit67: TvtEdit;
    vtEdit68: TvtEdit;
    vtEdit69: TvtEdit;
    vtEdit70: TvtEdit;
    vtEdit71: TvtEdit;
    vtEdit72: TvtEdit;
    vtEdit73: TvtEdit;
    vtEdit74: TvtEdit;
    vtEdit75: TvtEdit;
    vtEdit76: TvtEdit;
    vtEdit77: TvtEdit;
    vtEdit78: TvtEdit;
    vtEdit79: TvtEdit;
    vtEdit80: TvtEdit;
    vtEdit81: TvtEdit;
    vtEdit82: TvtEdit;
    vtEdit83: TvtEdit;
    vtEdit84: TvtEdit;
    vtEdit85: TvtEdit;
    vtEdit86: TvtEdit;
    vtEdit87: TvtEdit;
    vtEdit88: TvtEdit;
    vtEdit89: TvtEdit;
    vtEdit90: TvtEdit;
    vtEdit91: TvtEdit;
    vtEdit92: TvtEdit;
    vtEdit93: TvtEdit;
    vtEdit94: TvtEdit;
    vtEdit96: TvtEdit;
    vtEdit97: TvtEdit;
    vtEdit98: TvtEdit;
    vtEdit99: TvtEdit;
    vtEdit100: TvtEdit;
    PageBreak: TvtShape;
    vtLabel10: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel5: TvtLabel;
    vtShape14: TvtShape;
    vtShape1: TvtShape;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel69: TvtLabel;
    FlagFrameCan1: TFlagFrameCan;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    FlagFrameCan2: TFlagFrameCan;
    vtLabel6: TvtLabel;
    vtShape2: TvtShape;
    vtShape4: TvtShape;
    vtShape5: TvtShape;
    vtShape6: TvtShape;
    vtShape3: TvtShape;
    vtShape7: TvtShape;
    vtShape8: TvtShape;
    vtShape9: TvtShape;
    vtShape10: TvtShape;
    vtLabel12: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtEdit45: TvtEdit;
    vtEdit95: TvtEdit;
    vtLabel62: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel96: TvtLabel;
    vtLabel7: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
T4A_1: TT4A_1;
implementation
{$R *.DFM}
end.
