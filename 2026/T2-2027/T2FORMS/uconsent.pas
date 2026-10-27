unit uCONSENT;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, uFlagFrameCan, Buttons, vtGroupBox;
type
TCONSENT = class(TForm)
    vtRC59_1Label70:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    vtEdit65: TvtEdit;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel7: TvtLabel;
    vtShape1: TvtShape;
    vtShape5: TvtShape;
    vtLabel34: TvtLabel;
    FlagFrameCan1: TFlagFrameCan;
    vtShape6: TvtShape;
    vtLabel73: TvtLabel;
    vtShape8: TvtShape;
    vtLabel91: TvtLabel;
    vtLabel93: TvtLabel;
    vtLabel94: TvtLabel;
    vtEdit12: TvtEdit;
    vtEdit15: TvtEdit;
    vtEdit16: TvtEdit;
    vtEdit17: TvtEdit;
    vtEdit18: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit22: TvtEdit;
    vtEdit53: TvtEdit;
    vtEdit55: TvtEdit;
    vtShape12: TvtShape;
    vtShape16: TvtShape;
    vtEdit23: TvtEdit;
    vtEdit24: TvtEdit;
    vtEdit25: TvtEdit;
    vtEdit26: TvtEdit;
    vtEdit29: TvtEdit;
    vtEdit30: TvtEdit;
    vtLabel71: TvtLabel;
    vtEdit31: TvtEdit;
    vtEdit32: TvtEdit;
    vtEdit33: TvtEdit;
    vtEdit36: TvtEdit;
    vtEdit37: TvtEdit;
    vtLabel74: TvtLabel;
    vtEdit38: TvtEdit;
    vtEdit39: TvtEdit;
    vtEdit40: TvtEdit;
    vtEdit43: TvtEdit;
    vtEdit44: TvtEdit;
    vtLabel76: TvtLabel;
    vtLabel97: TvtLabel;
    vtLabel98: TvtLabel;
    vtLabel125: TvtLabel;
    vtLabel119: TvtLabel;
    vtLabel192: TvtLabel;
    vtLabel193: TvtLabel;
    vtLabel194: TvtLabel;
    vtLabel195: TvtLabel;
    vtLabel196: TvtLabel;
    vtLabel198: TvtLabel;
    vtLabel199: TvtLabel;
    vtLabel200: TvtLabel;
    vtLabel201: TvtLabel;
    vtLabel202: TvtLabel;
    vtLabel203: TvtLabel;
    vtLabel205: TvtLabel;
    vtGroupBox1: TvtGroupBox;
    vtLabel11: TvtLabel;
    vtShape3: TvtShape;
    vtLabel45: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel33: TvtLabel;
    vtEdit10: TvtEdit;
    vtEdit57: TvtEdit;
    EFILECONSENTBTN: TBitBtn;
    vtEdit20: TvtEdit;
    vtEdit21: TvtEdit;
    vtEdit27: TvtEdit;
    vtEdit28: TvtEdit;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtEdit66: TvtEdit;
    vtEdit64: TvtEdit;
    vtLabel3: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel101: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel30: TvtLabel;
    vtShape9: TvtShape;
    vtLabel8: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel46: TvtLabel;
    vtEdit13: TvtEdit;
    vtLabel52: TvtLabel;
    vtEdit34: TvtEdit;
    vtShape10: TvtShape;
    vtShape11: TvtShape;
    vtShape28: TvtShape;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel31: TvtLabel;
    vtEdit35: TvtEdit;
    vtEdit41: TvtEdit;
    vtLabel35: TvtLabel;
    vtLabel114: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel28: TvtLabel;
    vtShape43: TvtShape;
    vtLabel32: TvtLabel;
    vtLabel96: TvtLabel;
    vtLabel95: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel89: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel86: TvtLabel;
    vtLabel87: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel39: TvtLabel;
    vtEdit42: TvtEdit;
    vtEdit45: TvtEdit;
    vtEdit46: TvtEdit;
    vtEdit47: TvtEdit;
    vtEdit48: TvtEdit;
    vtEdit49: TvtEdit;
    vtEdit50: TvtEdit;
    vtEdit51: TvtEdit;
    vtShape2: TvtShape;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel12: TvtLabel;
    vtEdit54: TvtEdit;
    vtLabel13: TvtLabel;
    e_SignatureHolder: TImage;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    AConsentBTN: TBitBtn;
    procedure vtEdit16Change(Sender: TObject);
    procedure vtEdit15Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
CONSENT: TCONSENT;
implementation
{$R *.DFM}



end.
