unit ut4a_2;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uFlagFrameCan;
type
  TT4A_2 = class(TForm)
    Label204: TvtLabel;
    Label216: TvtLabel;
    Label221: TvtLabel;
    Label223: TvtLabel;
    Label224: TvtLabel;
    Label225: TvtLabel;
    Label227: TvtLabel;
    Label228: TvtLabel;
    Label229: TvtLabel;
    Label233: TvtLabel;
    Label235: TvtLabel;
    Label237: TvtLabel;
    Label141: TvtLabel;
    Label144: TvtLabel;
    Label146: TvtLabel;
    Label149: TvtLabel;
    Label186: TvtLabel;
    Label142: TvtLabel;
    Label198: TvtLabel;
    Label199: TvtLabel;
    Label203: TvtLabel;
    Label207: TvtLabel;
    Label200: TvtLabel;
    Label206: TvtLabel;
    Label202: TvtLabel;
    Label208: TvtLabel;
    Label209: TvtLabel;
    Label213: TvtLabel;
    Label138: TvtLabel;
    Label157: TvtLabel;
    Label148: TvtLabel;
    Label153: TvtLabel;
    Label160: TvtLabel;
    Label126: TvtLabel;
    Label164: TvtLabel;
    Label166: TvtLabel;
    Label113: TvtLabel;
    Label116: TvtLabel;
    Shape33: TvtShape;
    Shape34: TvtShape;
    Shape35: TvtShape;
    Label129: TvtLabel;
    Shape40: TvtShape;
    Label130: TvtLabel;
    Shape41: TvtShape;
    Shape42: TvtShape;
    Label135: TvtLabel;
    Label136: TvtLabel;
    Shape57: TvtShape;
    Label137: TvtLabel;
    Shape61: TvtShape;
    Shape62: TvtShape;
    Shape64: TvtShape;
    Shape66: TvtShape;
    Shape68: TvtShape;
    Shape72: TvtShape;
    Shape73: TvtShape;
    Shape74: TvtShape;
    Shape76: TvtShape;
    Shape77: TvtShape;
    Shape78: TvtShape;
    PageBreak: TvtShape;
    Shape12: TvtShape;
    Shape4: TvtShape;
    Shape25: TvtShape;
    Shape24: TvtShape;
    Shape22: TvtShape;
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
    Label14: TvtLabel;
    Label71: TvtLabel;
    Label17: TvtLabel;
    Label18: TvtLabel;
    Label22: TvtLabel;
    Label23: TvtLabel;
    Label40: TvtLabel;
    Label41: TvtLabel;
    Label61: TvtLabel;
    vtLabel1: TvtLabel;
    Label179: TvtLabel;
    Label63: TvtLabel;
    Label57: TvtLabel;
    Label58: TvtLabel;
    Label124: TvtLabel;
    Label2: TvtLabel;
    Label6: TvtLabel;
    Label3: TvtLabel;
    Label7: TvtLabel;
    Label8: TvtLabel;
    Label10: TvtLabel;
    Label15: TvtLabel;
    Label16: TvtLabel;
    Label21: TvtLabel;
    Label24: TvtLabel;
    Label26: TvtLabel;
    Label27: TvtLabel;
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
    Label13: TvtLabel;
    Shape1: TvtShape;
    Shape2: TvtShape;
    Shape3: TvtShape;
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
    Label53: TvtLabel;
    Label55: TvtLabel;
    Label56: TvtLabel;
    Label59: TvtLabel;
    Label60: TvtLabel;
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
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtEdit24: TvtEdit;
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
    vtEdit43: TvtEdit;
    vtEdit44: TvtEdit;
    vtEdit46: TvtEdit;
    vtEdit47: TvtEdit;
    vtEdit48: TvtEdit;
    vtEdit49: TvtEdit;
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
    vtShape1: TvtShape;
    vtShape7: TvtShape;
    vtShape8: TvtShape;
    vtShape9: TvtShape;
    vtShape11: TvtShape;
    vtShape12: TvtShape;
    vtShape14: TvtShape;
    vtShape15: TvtShape;
    vtShape16: TvtShape;
    vtShape17: TvtShape;
    vtShape18: TvtShape;
    vtLabel15: TvtLabel;
    Label4: TvtLabel;
    Label89: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel21: TvtLabel;
    vtShape22: TvtShape;
    vtLabel19: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel24: TvtLabel;
    vtShape23: TvtShape;
    vtLabel25: TvtLabel;
    vtShape24: TvtShape;
    vtShape25: TvtShape;
    vtLabel26: TvtLabel;
    vtShape26: TvtShape;
    vtLabel27: TvtLabel;
    vtShape19: TvtShape;
    vtLabel30: TvtLabel;
    vtLabel29: TvtLabel;
    vtShape28: TvtShape;
    vtLabel6: TvtLabel;
    vtShape2: TvtShape;
    vtShape3: TvtShape;
    vtShape20: TvtShape;
    vtLabel31: TvtLabel;
    vtShape21: TvtShape;
    vtShape27: TvtShape;
    vtShape29: TvtShape;
    vtShape30: TvtShape;
    vtShape4: TvtShape;
    vtShape5: TvtShape;
    vtShape31: TvtShape;
    vtShape32: TvtShape;
    vtLabel38: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel69: TvtLabel;
    FlagFrameCan1: TFlagFrameCan;
    vtLabel5: TvtLabel;
    vtLabel7: TvtLabel;
    FlagFrameCan2: TFlagFrameCan;
    vtShape33: TvtShape;
    vtLabel32: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel34: TvtLabel;
    vtShape34: TvtShape;
    vtLabel35: TvtLabel;
    vtShape35: TvtShape;
    vtLabel36: TvtLabel;
    vtShape36: TvtShape;
    vtLabel37: TvtLabel;
    vtShape37: TvtShape;
    vtLabel40: TvtLabel;
    vtShape38: TvtShape;
    vtLabel41: TvtLabel;
    vtShape39: TvtShape;
    vtLabel42: TvtLabel;
    vtShape40: TvtShape;
    vtLabel43: TvtLabel;
    vtLabel44: TvtLabel;
    vtShape41: TvtShape;
    vtLabel46: TvtLabel;
    vtShape42: TvtShape;
    vtLabel47: TvtLabel;
    vtLabel49: TvtLabel;
    vtLabel50: TvtLabel;
    vtLabel51: TvtLabel;
    vtLabel52: TvtLabel;
    vtShape43: TvtShape;
    vtLabel3: TvtLabel;
    vtLabel10: TvtLabel;
    vtShape44: TvtShape;
    vtShape6: TvtShape;
    vtShape45: TvtShape;
    vtLabel57: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel56: TvtLabel;
    vtShape10: TvtShape;
    vtLabel64: TvtLabel;
    vtLabel65: TvtLabel;
    vtLabel70: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel54: TvtLabel;
    vtLabel72: TvtLabel;
    vtLabel73: TvtLabel;
    vtShape46: TvtShape;
    vtLabel48: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel75: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel76: TvtLabel;
    vtLabel77: TvtLabel;
    vtLabel78: TvtLabel;
    vtLabel79: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel80: TvtLabel;
    vtLabel81: TvtLabel;
    vtLabel82: TvtLabel;
    vtLabel83: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel84: TvtLabel;
    vtLabel85: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel86: TvtLabel;
    vtLabel87: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel88: TvtLabel;
    vtLabel89: TvtLabel;
    vtLabel90: TvtLabel;
    vtLabel91: TvtLabel;
    vtLabel92: TvtLabel;
    vtLabel93: TvtLabel;
    vtLabel94: TvtLabel;
    vtLabel96: TvtLabel;
    vtLabel97: TvtLabel;
    vtLabel98: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel45: TvtLabel;
    vtLabel53: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel99: TvtLabel;
    vtLabel100: TvtLabel;
    vtLabel101: TvtLabel;
    vtLabel102: TvtLabel;
    vtLabel103: TvtLabel;
    vtLabel104: TvtLabel;
    vtLabel74: TvtLabel;
    vtLabel95: TvtLabel;
    vtEdit45: TvtEdit;
    vtEdit95: TvtEdit;
    vtLabel14: TvtLabel;
    vtLabel71: TvtLabel;
    vtLabel105: TvtLabel;
    vtLabel106: TvtLabel;
    vtLabel107: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
T4A_2: TT4A_2;
implementation
{$R *.DFM}
end.
