unit UT5013WS;
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, GTSize32, DisplayChange, jpeg, ComCtrls, vtLabel,
  Mask, vteditbox, vtShape, Buttons;
  TT5013Ws = class(TForm)
    Label2: TvtLabel;
    Label27: TvtLabel;
    Label45: TvtLabel;
    Label49: TvtLabel;
    Label50: TvtLabel;
    Label51: TvtLabel;
    Label52: TvtLabel;
    Label53: TvtLabel;
    Label56: TvtLabel;
    Label57: TvtLabel;
    Label58: TvtLabel;
    Label61: TvtLabel;
    Label62: TvtLabel;
    Label63: TvtLabel;
    Label64: TvtLabel;
    Label67: TvtLabel;
    Label68: TvtLabel;
    Label69: TvtLabel;
    Label70: TvtLabel;
    Label71: TvtLabel;
    Label72: TvtLabel;
    Label73: TvtLabel;
    Label74: TvtLabel;
    Label75: TvtLabel;
    Label76: TvtLabel;
    Label77: TvtLabel;
    Label78: TvtLabel;
    Label79: TvtLabel;
    Label80: TvtLabel;
    Label81: TvtLabel;
    Label82: TvtLabel;
    Label85: TvtLabel;
    Label88: TvtLabel;
    Label89: TvtLabel;
    Label90: TvtLabel;
    Label91: TvtLabel;
    Label92: TvtLabel;
    Label93: TvtLabel;
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
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
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
    vtLabel58: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel64: TvtLabel;
    vtLabel65: TvtLabel;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel71: TvtLabel;
    vtLabel72: TvtLabel;
    vtLabel74: TvtLabel;
    vtLabel75: TvtLabel;
    vtLabel77: TvtLabel;
    vtLabel78: TvtLabel;
    vtLabel79: TvtLabel;
    vtLabel80: TvtLabel;
    vtLabel81: TvtLabel;
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
    Label96: TvtLabel;
    vtLabel99: TvtLabel;
    vtLabel100: TvtLabel;
    vtLabel101: TvtLabel;
    vtLabel102: TvtLabel;
    vtLabel103: TvtLabel;
    vtLabel104: TvtLabel;
    vtLabel105: TvtLabel;
    vtLabel106: TvtLabel;
    vtLabel107: TvtLabel;
    vtLabel108: TvtLabel;
    vtLabel109: TvtLabel;
    vtLabel110: TvtLabel;
    vtLabel111: TvtLabel;
    vtLabel112: TvtLabel;
    vtLabel113: TvtLabel;
    vtLabel114: TvtLabel;
    vtLabel115: TvtLabel;
    vtLabel116: TvtLabel;
    vtLabel117: TvtLabel;
    vtLabel120: TvtLabel;
    vtLabel121: TvtLabel;
    vtLabel122: TvtLabel;
    vtLabel123: TvtLabel;
    vtLabel124: TvtLabel;
    vtLabel125: TvtLabel;
    vtLabel126: TvtLabel;
    vtLabel127: TvtLabel;
    vtLabel128: TvtLabel;
    vtLabel129: TvtLabel;
    vtLabel130: TvtLabel;
    vtLabel133: TvtLabel;
    vtLabel135: TvtLabel;
    vtLabel136: TvtLabel;
    vtLabel137: TvtLabel;
    vtLabel138: TvtLabel;
    vtLabel139: TvtLabel;
    vtLabel140: TvtLabel;
    vtLabel141: TvtLabel;
    vtLabel142: TvtLabel;
    vtLabel143: TvtLabel;
    vtLabel144: TvtLabel;
    vtLabel145: TvtLabel;
    vtLabel146: TvtLabel;
    vtLabel147: TvtLabel;
    vtLabel148: TvtLabel;
    vtLabel149: TvtLabel;
    vtLabel150: TvtLabel;
    vtLabel151: TvtLabel;
    vtLabel152: TvtLabel;
    vtLabel155: TvtLabel;
    vtLabel156: TvtLabel;
    vtLabel158: TvtLabel;
    vtLabel159: TvtLabel;
    vtLabel160: TvtLabel;
    vtLabel161: TvtLabel;
    vtLabel162: TvtLabel;
    vtLabel163: TvtLabel;
    vtLabel164: TvtLabel;
    vtLabel165: TvtLabel;
    vtLabel167: TvtLabel;
    vtLabel168: TvtLabel;
    vtLabel169: TvtLabel;
    vtLabel170: TvtLabel;
    vtLabel171: TvtLabel;
    vtLabel172: TvtLabel;
    vtLabel173: TvtLabel;
    vtLabel174: TvtLabel;
    vtLabel175: TvtLabel;
    vtLabel176: TvtLabel;
    vtLabel177: TvtLabel;
    vtLabel178: TvtLabel;
    vtLabel179: TvtLabel;
    vtLabel182: TvtLabel;
    vtLabel183: TvtLabel;
    vtLabel184: TvtLabel;
    vtLabel185: TvtLabel;
    vtLabel186: TvtLabel;
    vtLabel187: TvtLabel;
    Label97: TvtLabel;
    Label98: TvtLabel;
    Label99: TvtLabel;
    Label100: TvtLabel;
    Label101: TvtLabel;
    Label102: TvtLabel;
    Label103: TvtLabel;
    Label104: TvtLabel;
    Label105: TvtLabel;
    Label108: TvtLabel;
    Label109: TvtLabel;
    Label110: TvtLabel;
    Label111: TvtLabel;
    Label112: TvtLabel;
    Label113: TvtLabel;
    Label114: TvtLabel;
    Label115: TvtLabel;
    vtLabel188: TvtLabel;
    vtLabel191: TvtLabel;
    vtLabel192: TvtLabel;
    vtLabel193: TvtLabel;
    vtLabel194: TvtLabel;
    vtLabel195: TvtLabel;
    vtLabel196: TvtLabel;
    vtLabel197: TvtLabel;
    vtLabel198: TvtLabel;
    vtT5013Label56: TvtLabel;
    vtEdit251: TvtEdit;
    PageBreak: TvtShape;
    vtShape1: TvtShape;
    vtShape2: TvtShape;
    vtLabel3: TvtLabel;
    vtLabel19: TvtLabel;
    T5013INSTBTN: TBitBtn;
    vtLabel2: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel40: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel76: TvtLabel;
    vtLabel95: TvtLabel;
    vtLabel96: TvtLabel;
    vtLabel118: TvtLabel;
    vtLabel119: TvtLabel;
    vtLabel131: TvtLabel;
    vtLabel132: TvtLabel;
    vtLabel153: TvtLabel;
    vtLabel154: TvtLabel;
    vtLabel157: TvtLabel;
    vtLabel166: TvtLabel;
    vtLabel180: TvtLabel;
    vtLabel181: TvtLabel;
    vtLabel189: TvtLabel;
    vtLabel190: TvtLabel;
    vtLabel199: TvtLabel;
    vtLabel200: TvtLabel;
    vtLabel201: TvtLabel;
    vtLabel202: TvtLabel;
    vtLabel203: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel212: TvtLabel;
    vtLabel1: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel39: TvtLabel;
    vtEdit4: TvtEdit;
    vtEdit3: TvtEdit;
    vtEdit5: TvtEdit;
    vtEdit6: TvtEdit;
    vtEdit7: TvtEdit;
    vtEdit8: TvtEdit;
    vtEdit9: TvtEdit;
    vtEdit10: TvtEdit;
    vtEdit11: TvtEdit;
    vtEdit12: TvtEdit;
    vtEdit17: TvtEdit;
    vtEdit18: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
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
    vtEdit45: TvtEdit;
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
    vtEdit73: TvtEdit;
    vtEdit74: TvtEdit;
    vtEdit79: TvtEdit;
    vtEdit80: TvtEdit;
    vtEdit81: TvtEdit;
    vtEdit82: TvtEdit;
    vtEdit83: TvtEdit;
    vtEdit84: TvtEdit;
    vtEdit86: TvtEdit;
    vtEdit87: TvtEdit;
    vtEdit88: TvtEdit;
    vtEdit90: TvtEdit;
    vtEdit92: TvtEdit;
    vtEdit93: TvtEdit;
    vtEdit94: TvtEdit;
    vtEdit95: TvtEdit;
    vtEdit96: TvtEdit;
    vtEdit97: TvtEdit;
    vtEdit98: TvtEdit;
    vtEdit99: TvtEdit;
    vtEdit100: TvtEdit;
    vtEdit101: TvtEdit;
    vtEdit102: TvtEdit;
    vtEdit103: TvtEdit;
    vtEdit104: TvtEdit;
    vtEdit105: TvtEdit;
    vtEdit106: TvtEdit;
    vtEdit107: TvtEdit;
    vtEdit108: TvtEdit;
    vtEdit109: TvtEdit;
    vtEdit110: TvtEdit;
    vtEdit111: TvtEdit;
    vtEdit112: TvtEdit;
    vtEdit113: TvtEdit;
    vtEdit114: TvtEdit;
    vtEdit115: TvtEdit;
    vtEdit116: TvtEdit;
    vtEdit117: TvtEdit;
    vtEdit118: TvtEdit;
    vtEdit119: TvtEdit;
    vtEdit120: TvtEdit;
    vtEdit121: TvtEdit;
    vtEdit122: TvtEdit;
    vtEdit123: TvtEdit;
    vtEdit124: TvtEdit;
    vtEdit125: TvtEdit;
    vtEdit126: TvtEdit;
    vtEdit127: TvtEdit;
    vtEdit128: TvtEdit;
    vtEdit129: TvtEdit;
    vtEdit130: TvtEdit;
    vtEdit131: TvtEdit;
    vtEdit132: TvtEdit;
    vtEdit133: TvtEdit;
    vtEdit134: TvtEdit;
    vtEdit135: TvtEdit;
    vtEdit136: TvtEdit;
    vtEdit137: TvtEdit;
    vtEdit138: TvtEdit;
    vtEdit139: TvtEdit;
    vtEdit140: TvtEdit;
    vtEdit141: TvtEdit;
    vtEdit142: TvtEdit;
    vtEdit143: TvtEdit;
    vtEdit144: TvtEdit;
    vtEdit145: TvtEdit;
    vtEdit146: TvtEdit;
    vtEdit147: TvtEdit;
    vtEdit148: TvtEdit;
    vtEdit149: TvtEdit;
    vtEdit150: TvtEdit;
    vtEdit151: TvtEdit;
    vtEdit152: TvtEdit;
    vtEdit153: TvtEdit;
    vtEdit154: TvtEdit;
    vtEdit155: TvtEdit;
    vtEdit156: TvtEdit;
    vtEdit157: TvtEdit;
    vtEdit158: TvtEdit;
    vtEdit159: TvtEdit;
    vtEdit160: TvtEdit;
    vtEdit161: TvtEdit;
    vtEdit162: TvtEdit;
    vtEdit163: TvtEdit;
    vtEdit164: TvtEdit;
    vtEdit165: TvtEdit;
    vtEdit166: TvtEdit;
    vtEdit167: TvtEdit;
    vtEdit168: TvtEdit;
    vtEdit169: TvtEdit;
    vtEdit170: TvtEdit;
    vtEdit171: TvtEdit;
    vtEdit172: TvtEdit;
    vtEdit173: TvtEdit;
    vtEdit174: TvtEdit;
    vtEdit175: TvtEdit;
    vtEdit176: TvtEdit;
    vtEdit177: TvtEdit;
    vtEdit178: TvtEdit;
    vtEdit179: TvtEdit;
    vtEdit180: TvtEdit;
    vtEdit181: TvtEdit;
    vtEdit182: TvtEdit;
    vtEdit183: TvtEdit;
    vtEdit184: TvtEdit;
    vtEdit185: TvtEdit;
    vtEdit186: TvtEdit;
    vtEdit187: TvtEdit;
    vtEdit188: TvtEdit;
    vtEdit189: TvtEdit;
    vtEdit190: TvtEdit;
    vtEdit191: TvtEdit;
    vtEdit192: TvtEdit;
    vtEdit193: TvtEdit;
    vtEdit194: TvtEdit;
    vtEdit195: TvtEdit;
    vtEdit196: TvtEdit;
    vtEdit197: TvtEdit;
    vtEdit198: TvtEdit;
    vtEdit199: TvtEdit;
    vtEdit200: TvtEdit;
    vtEdit201: TvtEdit;
    vtEdit202: TvtEdit;
    vtEdit203: TvtEdit;
    vtEdit204: TvtEdit;
    vtEdit205: TvtEdit;
    vtEdit206: TvtEdit;
    vtEdit207: TvtEdit;
    vtEdit208: TvtEdit;
    vtEdit209: TvtEdit;
    vtEdit210: TvtEdit;
    vtEdit211: TvtEdit;
    vtEdit212: TvtEdit;
    vtEdit213: TvtEdit;
    vtEdit214: TvtEdit;
    vtEdit215: TvtEdit;
    vtEdit216: TvtEdit;
    vtEdit217: TvtEdit;
    vtEdit218: TvtEdit;
    vtEdit219: TvtEdit;
    vtEdit220: TvtEdit;
    vtEdit221: TvtEdit;
    vtEdit222: TvtEdit;
    vtEdit223: TvtEdit;
    vtEdit224: TvtEdit;
    vtEdit225: TvtEdit;
    vtEdit226: TvtEdit;
    vtEdit227: TvtEdit;
    vtEdit228: TvtEdit;
    vtEdit229: TvtEdit;
    vtEdit230: TvtEdit;
    vtEdit231: TvtEdit;
    vtEdit232: TvtEdit;
    vtEdit233: TvtEdit;
    vtEdit234: TvtEdit;
    vtEdit235: TvtEdit;
    vtEdit236: TvtEdit;
    vtEdit237: TvtEdit;
    vtEdit238: TvtEdit;
    vtEdit239: TvtEdit;
    vtEdit240: TvtEdit;
    vtLabel41: TvtLabel;
    vtEdit1: TvtEdit;
    vtLabel63: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel94: TvtLabel;
    vtLabel69: TvtLabel;
    vtLabel70: TvtLabel;
    vtLabel73: TvtLabel;
    vtLabel97: TvtLabel;
    vtLabel98: TvtLabel;
    vtLabel134: TvtLabel;
    vtLabel204: TvtLabel;
    vtEdit241: TvtEdit;
    vtEdit242: TvtEdit;
    vtEdit243: TvtEdit;
    vtEdit244: TvtEdit;
    vtEdit245: TvtEdit;
    vtEdit246: TvtEdit;
    vtLabel205: TvtLabel;
    vtEdit247: TvtEdit;
    vtEdit248: TvtEdit;
    vtEdit249: TvtEdit;
    vtEdit250: TvtEdit;
    vtLabel206: TvtLabel;
    vtLabel207: TvtLabel;
    vtLabel208: TvtLabel;
    vtEdit13: TvtEdit;
    vtEdit14: TvtEdit;
    vtEdit15: TvtEdit;
    vtEdit16: TvtEdit;
    vtLabel209: TvtLabel;
    vtLabel210: TvtLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  T5013Ws: TT5013Ws;
implementation
{$R *.DFM}
procedure TT5013Ws.FormCreate(Sender: TObject);
begin
object vtT5013Label56: TvtLabel
  Left = 383
  Top = 70
  Width = 99
  Height = 12
  Alignment = taRightJustify
  Caption = 'Override amounts (Y/N) '
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -9
  Font.Name = 'Arial'
  Font.Style = [fsItalic]
  ParentFont = False
  Transparent = True
  vtIsPrintable = False
  vtBorderType = vtlblNoBorder
end
object vtEdit1: TvtEdit
  Left = 483
  Top = 70
  Width = 14
  Height = 14
  Cursor = crHandPoint
  AutoSize = False
  BorderStyle = bsNone
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  vtPopData.vtPopFieldLength = 0
  vtAlignment = taCenter
  vtColorOnEnter = clBlack
  vtTabOnEnter = False
  vtIsPrintable = False
  vtDataSource = vtUser
  vtTypeAhead = vtNoTypeAhead
  vtInputType = vtYesOrNo
  vtOldBackColor = clBlack
  vtBorderType = vtFull
  vtPenThickness = 0
  vtDecimalPlaces = 0
  vtLayout = vtTop
  BorderColor = clBlack
  BorderFocusColor = clBlack
  vtLVars.vtTableNum = 0
  vtLVars.vtTableColumnNum = 0
  vtLVars.vtTableRowNum = 0
end

end;

end.
