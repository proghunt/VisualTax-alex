unit urc360;
interface
uses
    SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
    Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
    vtShape, Buttons, uFlagFrameCan, uFlagFrameSK, jpeg;
type
Trc360 = class(TForm)
   VTSHAPEUT778_1_4: TVTSHAPE;
   VTSHAPEUT778_1_1: TVTSHAPE;
   VTLABELUT778_1_50: TVTLABEL;
   VTLABELUT778_1_11: TVTLABEL;
   VTLABELUT778_1_63: TVTLABEL;
   VTLABELUT778_1_13: TVTLABEL;
   VTLABELUT778_1_7: TVTLABEL;
   VTLABELUT778_1_3: TVTLABEL;
   VTLABELUT778_1_2: TVTLABEL;
   VTLABELUT778_1_92: TVTLABEL;
    VTEDIT1: TvtEdit;
   vtShapePB1: TvtShape;
    vtLabel3: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel46: TvtLabel;
    vtLabel47: TvtLabel;
    vtLabel48: TvtLabel;
    vtLabel50: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel49: TvtLabel;
    vtLabel51: TvtLabel;
    vtLabel54: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel61: TvtLabel;
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
    vtLabel2: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel63: TvtLabel;
    vtEdit14: TvtEdit;
    vtLabel64: TvtLabel;
    vtEdit15: TvtEdit;
    vtLabel65: TvtLabel;
    vtEdit17: TvtEdit;
    vtLabel66: TvtLabel;
    vtEdit18: TvtEdit;
    vtLabel74: TvtLabel;
    vtEdit19: TvtEdit;
    vtLabel75: TvtLabel;
    vtEdit20: TvtEdit;
    vtLabel76: TvtLabel;
    vtEdit21: TvtEdit;
    vtLabel67: TvtLabel;
    vtEdit22: TvtEdit;
    vtLabel68: TvtLabel;
    vtEdit23: TvtEdit;
    vtLabel69: TvtLabel;
    vtLabel70: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel78: TvtLabel;
    vtLabel45: TvtLabel;
    vtLabel1: TvtLabel;
    vtLabel79: TvtLabel;
    vtLabel80: TvtLabel;
    vtLabel81: TvtLabel;
    vtLabel82: TvtLabel;
    vtLabel72: TvtLabel;
    vtLabel73: TvtLabel;
    vtLabel77: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel52: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel53: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel84: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel71: TvtLabel;
    vtLabel22: TvtLabel;
    vtShape2: TvtShape;
    vtLabel44: TvtLabel;
    vtLabel85: TvtLabel;
    vtLabel86: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel40: TvtLabel;
    vtLabel83: TvtLabel;
    vtLabel87: TvtLabel;
    vtLabel88: TvtLabel;
    Image2: TImage;
    vtLabel32: TvtLabel;
    vtLabel89: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel90: TvtLabel;
    vtLabel91: TvtLabel;
    vtLabel92: TvtLabel;
    vtLabel93: TvtLabel;
    vtLabel94: TvtLabel;
    vtLabel95: TvtLabel;
private
  { Private declarations }
public
  { Public declarations }
end;
var
rc360: Trc360;
implementation
{$R *.DFM}
end.
