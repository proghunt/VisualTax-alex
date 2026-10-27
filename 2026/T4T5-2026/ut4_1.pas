unit Ut4_1;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uFlagFrameCan;
type
  TT4_1 = class(TForm)
    PageBreak: TvtShape;
    Shape18: TvtShape;
    Shape58: TvtShape;
    Label3: TvtLabel;
    Label4: TvtLabel;
    Label7: TvtLabel;
    Label8: TvtLabel;
    Label9: TvtLabel;
    Label11: TvtLabel;
    Label13: TvtLabel;
    Label14: TvtLabel;
    Label15: TvtLabel;
    Label24: TvtLabel;
    Label29: TvtLabel;
    Label45: TvtLabel;
    Label47: TvtLabel;
    Label50: TvtLabel;
    Label51: TvtLabel;
    Label54: TvtLabel;
    Label44: TvtLabel;
    Label25: TvtLabel;
    Label46: TvtLabel;
    Label55: TvtLabel;
    Label56: TvtLabel;
    Label57: TvtLabel;
    Label58: TvtLabel;
    Label59: TvtLabel;
    Label60: TvtLabel;
    Label64: TvtLabel;
    Label65: TvtLabel;
    Label28: TvtLabel;
    Label69: TvtLabel;
    Label87: TvtLabel;
    Label88: TvtLabel;
    Label89: TvtLabel;
    Label6: TvtLabel;
    Label5: TvtLabel;
    Label12: TvtLabel;
    Label96: TvtLabel;
    Label43: TvtLabel;
    Label104: TvtLabel;
    Label16: TvtLabel;
    Label17: TvtLabel;
    Label21: TvtLabel;
    Label18: TvtLabel;
    Label22: TvtLabel;
    Label23: TvtLabel;
    Label26: TvtLabel;
    Label27: TvtLabel;
    Label31: TvtLabel;
    Label32: TvtLabel;
    Label34: TvtLabel;
    Label35: TvtLabel;
    Label36: TvtLabel;
    Label38: TvtLabel;
    Label48: TvtLabel;
    Label49: TvtLabel;
    Label66: TvtLabel;
    Label68: TvtLabel;
    Label70: TvtLabel;
    Label37: TvtLabel;
    Label1: TvtLabel;
    Label39: TvtLabel;
    Label40: TvtLabel;
    Label20: TvtLabel;
    Label90: TvtLabel;
    Label105: TvtLabel;
    Label116: TvtLabel;
    Label121: TvtLabel;
    vtShape1: TvtShape;
    vtShape2: TvtShape;
    vtShape5: TvtShape;
    vtShape6: TvtShape;
    vtShape3: TvtShape;
    vtShape7: TvtShape;
    vtShape8: TvtShape;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
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
    vtLabel24: TvtLabel;
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
    vtLabel40: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel45: TvtLabel;
    vtLabel46: TvtLabel;
    vtLabel47: TvtLabel;
    vtLabel48: TvtLabel;
    vtLabel49: TvtLabel;
    vtLabel50: TvtLabel;
    vtLabel51: TvtLabel;
    vtLabel52: TvtLabel;
    vtLabel53: TvtLabel;
    vtLabel54: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel64: TvtLabel;
    vtLabel65: TvtLabel;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel69: TvtLabel;
    vtShape9: TvtShape;
    vtShape10: TvtShape;
    vtShape11: TvtShape;
    vtShape12: TvtShape;
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
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtEdit25: TvtEdit;
    vtEdit26: TvtEdit;
    vtEdit27: TvtEdit;
    vtEdit28: TvtEdit;
    vtEdit29: TvtEdit;
    vtEdit30: TvtEdit;
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
    vtEdit45: TvtEdit;
    vtEdit46: TvtEdit;
    vtEdit44: TvtEdit;
    vtEdit24: TvtEdit;
    vtEdit11: TvtEdit;
    vtEdit50: TvtEdit;
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
    vtEdit75: TvtEdit;
    vtEdit76: TvtEdit;
    vtEdit77: TvtEdit;
    vtEdit78: TvtEdit;
    vtEdit79: TvtEdit;
    vtEdit81: TvtEdit;
    vtEdit83: TvtEdit;
    vtEdit85: TvtEdit;
    vtEdit86: TvtEdit;
    vtEdit87: TvtEdit;
    vtEdit88: TvtEdit;
    vtEdit89: TvtEdit;
    vtEdit90: TvtEdit;
    vtEdit91: TvtEdit;
    vtEdit92: TvtEdit;
    vtEdit95: TvtEdit;
    vtEdit96: TvtEdit;
    vtEdit94: TvtEdit;
    vtEdit74: TvtEdit;
    vtEdit61: TvtEdit;
    vtEdit100: TvtEdit;
    vtEdit80: TvtEdit;
    vtEdit82: TvtEdit;
    vtEdit84: TvtEdit;
    vtEdit82x: TvtEdit;
    vtShape14: TvtShape;
    vtShape4: TvtShape;
    vtShape16: TvtShape;
    vtLabel70: TvtLabel;
    vtShape13: TvtShape;
    vtLabel1: TvtLabel;
    vtLabel79: TvtLabel;
    vtLabel80: TvtLabel;
    vtLabel81: TvtLabel;
    FlagFrameCan1: TFlagFrameCan;
    vtLabel41: TvtLabel;
    vtLabel71: TvtLabel;
    vtLabel72: TvtLabel;
    vtLabel73: TvtLabel;
    FlagFrameCan2: TFlagFrameCan;
    vtLabel74: TvtLabel;
    vtLabel76: TvtLabel;
    vtLabel77: TvtLabel;
    vtLabel78: TvtLabel;
    vtLabel82: TvtLabel;
    vtLabel83: TvtLabel;
    vtLabel84: TvtLabel;
    vtLabel85: TvtLabel;
    vtLabel86: TvtLabel;
    vtLabel87: TvtLabel;
    vtLabel88: TvtLabel;
    vtLabel89: TvtLabel;
    vtLabel90: TvtLabel;
    vtLabel91: TvtLabel;
    vtLabel92: TvtLabel;
    vtLabel93: TvtLabel;
    vtLabel94: TvtLabel;
    vtLabel95: TvtLabel;
    vtShape15: TvtShape;
    vtEdit47: TvtEdit;
    vtEdit48: TvtEdit;
    vtEdit49: TvtEdit;
    vtEdit99: TvtEdit;
    vtEdit97: TvtEdit;
    vtEdit98: TvtEdit;
    vtLabel6: TvtLabel;
    vtLabel75: TvtLabel;
    vtLabel96: TvtLabel;
    vtLabel97: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
T4_1: TT4_1;
implementation
{$R *.DFM}
end.
