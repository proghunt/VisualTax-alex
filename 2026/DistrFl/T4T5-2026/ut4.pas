unit ut4;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uFlagFrameCan, vtGroupBox, Buttons;
type
  TT4 = class(TForm)
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
    Label30: TvtLabel;
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
    vtEdit43: TvtEdit;
    vtEdit45: TvtEdit;
    vtEdit46: TvtEdit;
    vtEdit44: TvtEdit;
    vtEdit24: TvtEdit;
    vtEdit11: TvtEdit;
    vtShape13: TvtShape;
    vtShape14: TvtShape;
    vtLabel6: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtEdit101: TvtEdit;
    vtEdit102: TvtEdit;
    vtEdit103: TvtEdit;
    vtEdit104: TvtEdit;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtShape3: TvtShape;
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
    vtEdit105: TvtEdit;
    vtEdit106: TvtEdit;
    vtEdit107: TvtEdit;
    vtEdit108: TvtEdit;
    vtEdit109: TvtEdit;
    vtEdit110: TvtEdit;
    vtShape4: TvtShape;
    vtLabel22: TvtLabel;
    vtShape5: TvtShape;
    vtLabel23: TvtLabel;
    vtShape6: TvtShape;
    vtShape7: TvtShape;
    vtShape9: TvtShape;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel74: TvtLabel;
    vtLabel76: TvtLabel;
    vtLabel77: TvtLabel;
    vtLabel78: TvtLabel;
    FlagFrameCan1: TFlagFrameCan;
    vtGroupBox1: TvtGroupBox;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtEdit111: TvtEdit;
    vtLabel1: TvtLabel;
    vtEdit112: TvtEdit;
    vtLabel7: TvtLabel;
    T4CRAGUIDEBTN: TBitBtn;
    vtLabel21: TvtLabel;
    APPLYTOTAXBTN: TBitBtn;
    vtLabel20: TvtLabel;
    vtEdit50: TvtEdit;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtEdit49: TvtEdit;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel32: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel36: TvtLabel;
    vtEdit47: TvtEdit;
    vtEdit48: TvtEdit;
    vtLabel37: TvtLabel;
    vtLabel39: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
T4: TT4;
implementation
{$R *.DFM}
end.
