unit ut4asum;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uFlagFrameCan, Buttons;
type
  Tt4Asum = class(TForm)
    Label3: TvtLabel;
    Label4: TvtLabel;
    Label7: TvtLabel;
    Label9: TvtLabel;
    Label10: TvtLabel;
    Label17: TvtLabel;
    Label20: TvtLabel;
    Label25: TvtLabel;
    Label27: TvtLabel;
    Label28: TvtLabel;
    Label30: TvtLabel;
    Label31: TvtLabel;
    Label33: TvtLabel;
    Label34: TvtLabel;
    Label36: TvtLabel;
    Label37: TvtLabel;
    Label39: TvtLabel;
    Label40: TvtLabel;
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
    Label54: TvtLabel;
    Label55: TvtLabel;
    Label57: TvtLabel;
    Label59: TvtLabel;
    Label60: TvtLabel;
    Label61: TvtLabel;
    Label62: TvtLabel;
    Label67: TvtLabel;
    Label68: TvtLabel;
    Label69: TvtLabel;
    Label70: TvtLabel;
    Label71: TvtLabel;
    Label72: TvtLabel;
    Label73: TvtLabel;
    Label74: TvtLabel;
    Label75: TvtLabel;
    Label79: TvtLabel;
    Label80: TvtLabel;
    Label84: TvtLabel;
    Label85: TvtLabel;
    Label86: TvtLabel;
    Label87: TvtLabel;
    Label137: TvtLabel;
    Shape4: TvtShape;
    Label150: TvtLabel;
    Label153: TvtLabel;
    Shape38: TvtShape;
    Shape39: TvtShape;
    Shape1: TvtShape;
    Shape26: TvtShape;
    Label11: TvtLabel;
    vtEdit1: TvtEdit;
    vtEdit3: TvtEdit;
    vtEdit4: TvtEdit;
    vtEdit5: TvtEdit;
    vtEdit6: TvtEdit;
    vtEdit7: TvtEdit;
    vtEdit8: TvtEdit;
    vtEdit9: TvtEdit;
    vtEdit10: TvtEdit;
    vtEdit11: TvtEdit;
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
    vtEdit24: TvtEdit;
    vtEdit23: TvtEdit;
    vtEdit25: TvtEdit;
    vtEdit27: TvtEdit;
    vtEdit26: TvtEdit;
    vtEdit29: TvtEdit;
    vtEdit30: TvtEdit;
    vtEdit31: TvtEdit;
    vtEdit32: TvtEdit;
    vtEdit34: TvtEdit;
    vtEdit35: TvtEdit;
    Shape85: TvtShape;
    Shape92: TvtShape;
    Shape93: TvtShape;
    Shape95: TvtShape;
    Shape96: TvtShape;
    Shape97: TvtShape;
    Shape98: TvtShape;
    Shape99: TvtShape;
    Shape102: TvtShape;
    Shape103: TvtShape;
    Shape109: TvtShape;
    Label65: TvtLabel;
    Label124: TvtLabel;
    Label125: TvtLabel;
    Label127: TvtLabel;
    Label128: TvtLabel;
    Label129: TvtLabel;
    Label130: TvtLabel;
    Label132: TvtLabel;
    Label133: TvtLabel;
    Label135: TvtLabel;
    Label138: TvtLabel;
    Label140: TvtLabel;
    Label152: TvtLabel;
    Label157: TvtLabel;
    Label162: TvtLabel;
    Label163: TvtLabel;
    Label166: TvtLabel;
    Label167: TvtLabel;
    Label168: TvtLabel;
    Label169: TvtLabel;
    Label170: TvtLabel;
    Label172: TvtLabel;
    Label173: TvtLabel;
    Label174: TvtLabel;
    Label175: TvtLabel;
    Label176: TvtLabel;
    Label177: TvtLabel;
    Label178: TvtLabel;
    Label179: TvtLabel;
    Label180: TvtLabel;
    Label181: TvtLabel;
    Label182: TvtLabel;
    Label183: TvtLabel;
    Shape110: TvtShape;
    Label184: TvtLabel;
    Shape111: TvtShape;
    Shape114: TvtShape;
    Shape115: TvtShape;
    Shape116: TvtShape;
    Shape117: TvtShape;
    Shape118: TvtShape;
    Shape120: TvtShape;
    Shape121: TvtShape;
    Shape122: TvtShape;
    Shape129: TvtShape;
    Shape130: TvtShape;
    Shape131: TvtShape;
    Shape132: TvtShape;
    Shape133: TvtShape;
    Shape135: TvtShape;
    Shape136: TvtShape;
    Shape40: TvtShape;
    Shape42: TvtShape;
    Label89: TvtLabel;
    Label90: TvtLabel;
    Label92: TvtLabel;
    Label93: TvtLabel;
    Label95: TvtLabel;
    Label97: TvtLabel;
    Label56: TvtLabel;
    vtEdit28: TvtEdit;
    vtEdit38: TvtEdit;
    vtEdit39: TvtEdit;
    Label8: TvtLabel;
    Label14: TvtLabel;
    Label82: TvtLabel;
    Shape43: TvtShape;
    Shape64: TvtShape;
    Label15: TvtLabel;
    Shape17: TvtShape;
    Label6: TvtLabel;
    Label12: TvtLabel;
    Label13: TvtLabel;
    Label16: TvtLabel;
    vtEdit33: TvtEdit;
    vtEdit36: TvtEdit;
    Shape18: TvtShape;
    PageBreak: TvtShape;
    Shape27: TvtShape;
    vtShape1: TvtShape;
    vtShape2: TvtShape;
    vtShape3: TvtShape;
    vtShape4: TvtShape;
    vtShape6: TvtShape;
    vtShape7: TvtShape;
    vtShape10: TvtShape;
    vtShape11: TvtShape;
    vtShape12: TvtShape;
    vtShape13: TvtShape;
    vtShape14: TvtShape;
    vtShape15: TvtShape;
    vtShape17: TvtShape;
    vtShape18: TvtShape;
    vtShape5: TvtShape;
    vtShape8: TvtShape;
    vtShape9: TvtShape;
    vtLabel3: TvtLabel;
    vtShape16: TvtShape;
    vtShape19: TvtShape;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtShape20: TvtShape;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel69: TvtLabel;
    FlagFrameCan1: TFlagFrameCan;
    vtShape21: TvtShape;
    vtShape22: TvtShape;
    vtShape23: TvtShape;
    vtShape24: TvtShape;
    vtLabel1: TvtLabel;
    T4ASumiBtn: TBitBtn;
    vtLabel2: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel164: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
t4Asum: Tt4Asum;
implementation
{$R *.DFM}
end.
