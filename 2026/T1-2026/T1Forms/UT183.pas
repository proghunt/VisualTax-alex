unit ut183;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, Buttons, uFlagFrameCan, uFrameOnlineMail, jpeg, vtGroupBox; //20151226
type
TT183 = class(TForm)
    PageBreak: TvtShape;
    vtShape7: TvtShape;
    vtShape16: TvtShape;
    vtShape14: TvtShape;
    vtShape13: TvtShape;
    vtShape10: TvtShape;
    vtShape9: TvtShape;
    vtShape24: TvtShape;
    vtShape1: TvtShape;
    vtShape8: TvtShape;
    vtShape11: TvtShape;
    vtShape6: TvtShape;
    vtLabel48: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel49: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel66: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel65: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel1: TvtLabel;
    vtLabel79: TvtLabel;
    vtLabel80: TvtLabel;
    vtLabel81: TvtLabel;
    vtLabel82: TvtLabel;
    vtLabel83: TvtLabel;
    vtLabel76: TvtLabel;
    vtLabel94: TvtLabel;
    vtEdit27: TvtEdit;
    vtEdit24: TvtEdit;
    vtEdit21: TvtEdit;
    vtEdit20: TvtEdit;
    vtEdit8: TvtEdit;
    vtEdit7: TvtEdit;
    vtEdit6: TvtEdit;
    vtEdit5: TvtEdit;
    vtEdit4: TvtEdit;
    vtEdit3: TvtEdit;
    vtEdit2: TvtEdit;
    vtEdit1: TvtEdit;
    vtEdit28: TvtEdit;
    vtEdit29: TvtEdit;
    vtEdit30: TvtEdit;
    vtEdit31: TvtEdit;
    vtEdit32: TvtEdit;
    vtEdit33: TvtEdit;
    FlagFrameCan1: TFlagFrameCan;
    vtEdit35: TvtEdit;
    vtEdit9: TvtEdit;
    T183IBtn: TBitBtn;
    vtLabel19: TvtLabel;
    vtEdit10: TvtEdit;
    vtLabel43: TvtLabel;
    CanadaBottomSmallFlag: TImage;
    vtLabel22: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel47: TvtLabel;
    vtShape15: TvtShape;
    vtEdit11: TvtEdit;
    vtEdit15: TvtEdit;
    vtEdit14: TvtEdit;
    vtLabel57: TvtLabel;
    MKDCNBTN: TBitBtn;
    vtShape27: TvtShape;
    vtLabel23: TvtLabel;
    vtLabel84: TvtLabel;
    vtShape35: TvtShape;
    vtShape37: TvtShape;
    vtShape38: TvtShape;
    vtShape33: TvtShape;
    vtShape40: TvtShape;
    vtLabel6: TvtLabel;
    vtLabel29: TvtLabel;
    vtShape28: TvtShape;
    TodaysDateBtn2: TBitBtn;
    vtLabel36: TvtLabel;
    vtLabel33: TvtLabel;
    vtEdit36: TvtEdit;
    vtEdit37: TvtEdit;
    vtLabel46: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel92: TvtLabel;
    vtShape30: TvtShape;
    vtLabel96: TvtLabel;
    vtEdit13: TvtEdit;
    vtEdit19: TvtEdit;
    vtLabel18: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel44: TvtLabel;
    VTLABELUT2121_1_4: TvtLabel;
    VTLABELUT2121_1_1: TvtLabel;
    vtLabel30: TvtLabel;
    vtShape2: TvtShape;
    vtLabel27: TvtLabel;
    vtLabel50: TvtLabel;
    vtLabel55: TvtLabel;
    vtShape4: TvtShape;
    vtLabel10: TvtLabel;
    vtEdit17: TvtEdit;
    vtLabel32: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel9: TvtLabel;
    e_SignatureHolder: TImage;
    E_SignatureHelpBTN: TBitBtn;
    vtLabel7: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel40: TvtLabel;
    E_SignatureRequestBTN: TBitBtn;
    vtLabel42: TvtLabel;
    vtEdit12: TvtEdit;
    vtShape3: TvtShape;
    vtLabel45: TvtLabel;
    vtLabel56: TvtLabel;
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtLabel60: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel64: TvtLabel;
    vtLabel68: TvtLabel;
    vtShape12: TvtShape;
    vtShape17: TvtShape;
    vtEdit16: TvtEdit;
    vtEdit25: TvtEdit;
    vtEdit26: TvtEdit;
    vtLabel41: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel54: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
T183: TT183
implementation
{$R *.DFM}

end.

