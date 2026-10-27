unit UT1134;
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, GTSize32, DisplayChange, jpeg, ComCtrls, vtLabel,
  Mask, vtEditBox, vtShape, uFlagFrameCan, Buttons, vtGroupBox;
  TT2SCH570 = class(TForm)
    Label12: TvtLabel;
    Label19: TvtLabel;
    Label20: TvtLabel;
    Label21: TvtLabel;
    Label69: TvtLabel;
    Label70: TvtLabel;
    Label73: TvtLabel;
    Label76: TvtLabel;
    vtShape5: TvtShape;
    vtShape6: TvtShape;
    vtShape7: TvtShape;
    vtShape8: TvtShape;
    vtShape9: TvtShape;
    vtEdit2: TvtEdit;
    vtShape25: TvtShape;
    vtShape31: TvtShape;
    vtLabel109: TvtLabel;
    vtLabel106: TvtLabel;
    vtShape17: TvtShape;
    vtShape38: TvtShape;
    vtShape40: TvtShape;
    vtShape42: TvtShape;
    vtLabel123: TvtLabel;
    vtLabel122: TvtLabel;
    vtShape50: TvtShape;
    vtLabel133: TvtLabel;
    vtLabel134: TvtLabel;
    vtLabel135: TvtLabel;
    vtLabel150: TvtLabel;
    vtLabel152: TvtLabel;
    vtShape63: TvtShape;
    vtLabel85: TvtLabel;
    vtLabel86: TvtLabel;
    vtLabel385: TvtLabel;
    vtLabel386: TvtLabel;
    vtShape19: TvtShape;
    vtShape20: TvtShape;
    vtLabel20: TvtLabel;
    Image1: TImage;
    vtLabel32: TvtLabel;
    vtLabel34: TvtLabel;
    vtShape23: TvtShape;
    vtLabel27: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel51: TvtLabel;
    vtShape27: TvtShape;
    vtLabel53: TvtLabel;
    vtLabel54: TvtLabel;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel64: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel61: TvtLabel;
    vtShape45: TvtShape;
    vtLabel148: TvtLabel;
    vtLabel1236: TvtLabel;
    vtLabel1237: TvtLabel;
    vtLabel1239: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel1240: TvtLabel;
    vtLabel1241: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel157: TvtLabel;
    vtLabel220: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel221: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel40: TvtLabel;
    vtLabel440: TvtLabel;
    vtLabel1242: TvtLabel;
    vtLabel1243: TvtLabel;
    vtLabel1244: TvtLabel;
    vtLabel1245: TvtLabel;
    vtLabel1246: TvtLabel;
    vtLabel1247: TvtLabel;
    vtLabel1248: TvtLabel;
    vtLabel1249: TvtLabel;
    vtLabel1250: TvtLabel;
    vtLabel1251: TvtLabel;
    vtLabel1252: TvtLabel;
    vtLabel1253: TvtLabel;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtEdit1: TvtEdit;
    vtLabel7: TvtLabel;
    vtEdit3: TvtEdit;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel45: TvtLabel;
    vtLabel46: TvtLabel;
    vtShape1: TvtShape;
    vtLabel47: TvtLabel;
    vtLabel116: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel118: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel65: TvtLabel;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel69: TvtLabel;
    vtLabel119: TvtLabel;
    vtLabel120: TvtLabel;
    vtLabel121: TvtLabel;
    vtLabel124: TvtLabel;
    vtLabel125: TvtLabel;
    vtLabel126: TvtLabel;
    vtLabel127: TvtLabel;
    vtLabel128: TvtLabel;
    vtLabel129: TvtLabel;
    vtLabel130: TvtLabel;
    vtLabel131: TvtLabel;
    vtLabel132: TvtLabel;
    vtLabel136: TvtLabel;
    vtLabel149: TvtLabel;
    vtLabel1238: TvtLabel;
    vtLabel1254: TvtLabel;
    vtLabel1255: TvtLabel;
    vtLabel1257: TvtLabel;
    vtLabel1256: TvtLabel;
    vtLabel1258: TvtLabel;
    vtLabel1259: TvtLabel;
    vtLabel1260: TvtLabel;
    vtLabel1261: TvtLabel;
    vtLabel1262: TvtLabel;
    vtLabel1263: TvtLabel;
    vtLabel214: TvtLabel;
    vtLabel1264: TvtLabel;
    vtLabel1265: TvtLabel;
    vtLabel1266: TvtLabel;
    vtLabel1267: TvtLabel;
    vtLabel1268: TvtLabel;
    vtLabel1269: TvtLabel;
    vtLabel1270: TvtLabel;
    vtLabel1271: TvtLabel;
    vtLabel1272: TvtLabel;
    vtLabel1273: TvtLabel;
    vtLabel1274: TvtLabel;
    vtLabel1275: TvtLabel;
    vtLabel1276: TvtLabel;
    vtLabel1277: TvtLabel;
    vtLabel1278: TvtLabel;
    vtShape3: TvtShape;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel23: TvtLabel;
    vtShape2: TvtShape;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtShape4: TvtShape;
    vtShape10: TvtShape;
    vtShape11: TvtShape;
    vtLabel48: TvtLabel;
    vtShape12: TvtShape;
    vtLabel49: TvtLabel;
    vtShape13: TvtShape;
    vtLabel50: TvtLabel;
    vtShape14: TvtShape;
    vtLabel52: TvtLabel;
    vtLabel70: TvtLabel;
    vtShape15: TvtShape;
    vtLabel71: TvtLabel;
    vtShape16: TvtShape;
    vtLabel72: TvtLabel;
    vtLabel73: TvtLabel;
    vtLabel74: TvtLabel;
    vtLabel75: TvtLabel;
    vtLabel76: TvtLabel;
    vtLabel77: TvtLabel;
    vtShape18: TvtShape;
    vtLabel78: TvtLabel;
    vtLabel79: TvtLabel;
    vtShape21: TvtShape;
    vtLabel80: TvtLabel;
    vtLabel81: TvtLabel;
    vtShape22: TvtShape;
    vtLabel82: TvtLabel;
    vtLabel83: TvtLabel;
    vtLabel84: TvtLabel;
    vtShape24: TvtShape;
    vtLabel87: TvtLabel;
    vtLabel88: TvtLabel;
    vtShape26: TvtShape;
    vtLabel89: TvtLabel;
    vtLabel90: TvtLabel;
    vtShape28: TvtShape;
    vtLabel91: TvtLabel;
    vtShape29: TvtShape;
    vtLabel92: TvtLabel;
    vtLabel93: TvtLabel;
    vtLabel94: TvtLabel;
    vtShape30: TvtShape;
    vtLabel95: TvtLabel;
    vtLabel96: TvtLabel;
    vtShape32: TvtShape;
    vtLabel97: TvtLabel;
    vtLabel98: TvtLabel;
    vtLabel99: TvtLabel;
    vtShape33: TvtShape;
    vtLabel100: TvtLabel;
    vtShape34: TvtShape;
    vtLabel101: TvtLabel;
    vtLabel102: TvtLabel;
    vtShape35: TvtShape;
    vtLabel103: TvtLabel;
    vtLabel104: TvtLabel;
    vtShape36: TvtShape;
    vtLabel105: TvtLabel;
    vtLabel107: TvtLabel;
    vtLabel108: TvtLabel;
    vtShape37: TvtShape;
    vtLabel110: TvtLabel;
    vtLabel111: TvtLabel;
    vtShape39: TvtShape;
    vtLabel112: TvtLabel;
    vtShape41: TvtShape;
    vtLabel113: TvtLabel;
    vtShape43: TvtShape;
    vtLabel114: TvtLabel;
    vtShape44: TvtShape;
    vtLabel115: TvtLabel;
    vtLabel117: TvtLabel;
    vtLabel137: TvtLabel;
    vtShape46: TvtShape;
    vtLabel138: TvtLabel;
    vtLabel139: TvtLabel;
    vtShape47: TvtShape;
    vtLabel140: TvtLabel;
    vtLabel141: TvtLabel;
    vtLabel142: TvtLabel;
    vtLabel143: TvtLabel;
    vtLabel144: TvtLabel;
    vtShape48: TvtShape;
    vtLabel145: TvtLabel;
    vtLabel146: TvtLabel;
    vtShape49: TvtShape;
    vtShape51: TvtShape;
    vtShape52: TvtShape;
    vtLabel147: TvtLabel;
    vtLabel151: TvtLabel;
    vtLabel153: TvtLabel;
    vtLabel154: TvtLabel;
    vtShape53: TvtShape;
    vtLabel155: TvtLabel;
    vtLabel156: TvtLabel;
    vtLabel158: TvtLabel;
    vtLabel159: TvtLabel;
    vtShape54: TvtShape;
    vtShape55: TvtShape;
    vtLabel160: TvtLabel;
    vtLabel161: TvtLabel;
    vtLabel162: TvtLabel;
    vtLabel163: TvtLabel;
    vtLabel164: TvtLabel;
    procedure vtLabel80Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  T2SCH570: TT2SCH570;
implementation
{$R *.DFM}
procedure TT2SCH570.vtLabel80Click(Sender: TObject);
begin
object vtShape21: TvtShape
  Left = 7
  Top = 460
  Width = 568
  Height = 1
  Brush.Style = bsClear
  GradientColor = clBlack
  FillDirection = vtUpFill
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  CaptionX = 0
  CaptionY = 0
  CaptionCentered = True
  CaptionAngle = 0
  byUser = True
  vtPageBreak = False
  vtIsPrintable = True
  vtPageFooter = False
end

end;

end.
