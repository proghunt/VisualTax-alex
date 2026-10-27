unit uS1;
interface
uses
    SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
    Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
    vtShape, Buttons, uFlagFrameCan;
type
TS1 = class(TForm)
   VTLABELUS1_1_1: TVTLABEL;
   VTLABELUS1_1_2: TVTLABEL;
   VTLABELUS1_1_3: TVTLABEL;
   VTLABELUS1_1_4: TVTLABEL;
   VTSHAPEUS1_1_22: TVTSHAPE;
   VTLABELUS1_1_38: TVTLABEL;
   VTLABELUS1_1_40: TVTLABEL;
   VTSHAPEUS1_1_23: TVTSHAPE;
   VTLABELUS1_1_39: TVTLABEL;
   VTLABELUS1_1_6: TVTLABEL;
   VTLABELUS1_1_7: TVTLABEL;
   VTEDIT56: TVTEDIT;
   VTEDIT55: TVTEDIT;
   VTEDIT54: TVTEDIT;
   VTEDIT53: TVTEDIT;
   VTEDIT52: TVTEDIT;
   VTEDIT51: TVTEDIT;
   VTEDIT50: TVTEDIT;
   VTEDIT49: TVTEDIT;
   VTEDIT47: TVTEDIT;
   VTEDIT46: TVTEDIT;
   VTEDIT45: TVTEDIT;
   VTEDIT44: TVTEDIT;
   VTEDIT43: TVTEDIT;
   VTEDIT42: TVTEDIT;
   VTEDIT41: TVTEDIT;
   VTEDIT40: TVTEDIT;
   VTEDIT38: TVTEDIT;
   VTEDIT37: TVTEDIT;
   VTEDIT36: TVTEDIT;
   VTEDIT35: TVTEDIT;
   VTEDIT34: TVTEDIT;
   VTEDIT33: TVTEDIT;
   VTEDIT32: TVTEDIT;
   VTEDIT31: TVTEDIT;
   VTEDIT30: TVTEDIT;
   VTEDIT29: TVTEDIT;
   VTEDIT28: TVTEDIT;
   VTEDIT27: TVTEDIT;
   VTEDIT26: TVTEDIT;
   VTEDIT25: TVTEDIT;
   VTEDIT24: TVTEDIT;
   VTEDIT23: TVTEDIT;
   VTEDIT22: TVTEDIT;
   VTEDIT21: TVTEDIT;
   VTEDIT20: TVTEDIT;
   VTEDIT19: TVTEDIT;
   VTEDIT18: TVTEDIT;
   VTEDIT17: TVTEDIT;
   VTEDIT16: TVTEDIT;
   VTEDIT15: TVTEDIT;
   VTEDIT14: TVTEDIT;
   VTEDIT11: TVTEDIT;
   VTEDIT10: TVTEDIT;
   VTEDIT9: TVTEDIT;
   VTEDIT8: TVTEDIT;
   VTEDIT7: TVTEDIT;
   VTEDIT6: TVTEDIT;
   VTEDIT5: TVTEDIT;
   VTEDIT4: TVTEDIT;
   VTEDIT3: TVTEDIT;
   VTEDIT2: TVTEDIT;
   VTEDIT1: TVTEDIT;
   VTEDIT57: TVTEDIT;
   VTEDIT58: TVTEDIT;
   VTEDIT59: TVTEDIT;
   vtShapePB1: TvtShape;
   VTLABELUS1_2_6: TVTLABEL;
   VTLABELUS1_2_2: TVTLABEL;
   VTLABELUS1_2_3: TVTLABEL;
   VTLABELUS1_2_4: TVTLABEL;
   VTLABELUS1_2_7: TVTLABEL;
   VTEDIT149: TVTEDIT;
   VTEDIT148: TVTEDIT;
   VTEDIT147: TVTEDIT;
   VTEDIT146: TVTEDIT;
   VTEDIT145: TVTEDIT;
   VTEDIT144: TVTEDIT;
   VTEDIT143: TVTEDIT;
   VTEDIT142: TVTEDIT;
   VTEDIT141: TVTEDIT;
   VTEDIT140: TVTEDIT;
   VTEDIT139: TVTEDIT;
   VTEDIT138: TVTEDIT;
   VTEDIT137: TVTEDIT;
   VTEDIT135: TVTEDIT;
   VTEDIT134: TVTEDIT;
   VTEDIT131: TVTEDIT;
   VTEDIT130: TVTEDIT;
   VTEDIT129: TVTEDIT;
   VTEDIT128: TVTEDIT;
   VTEDIT127: TVTEDIT;
   VTEDIT126: TVTEDIT;
   VTEDIT124: TVTEDIT;
   VTEDIT122: TVTEDIT;
   VTEDIT121: TVTEDIT;
   VTEDIT120: TVTEDIT;
   VTEDIT119: TVTEDIT;
   VTEDIT118: TVTEDIT;
   VTEDIT117: TVTEDIT;
   VTEDIT116: TVTEDIT;
   VTEDIT115: TVTEDIT;
   VTEDIT114: TVTEDIT;
   VTEDIT113: TVTEDIT;
   VTEDIT112: TVTEDIT;
   VTEDIT111: TVTEDIT;
   VTEDIT110: TVTEDIT;
   VTEDIT109: TVTEDIT;
   VTEDIT108: TVTEDIT;
   VTEDIT106: TVTEDIT;
   VTEDIT104: TVTEDIT;
   VTEDIT103: TVTEDIT;
   VTEDIT102: TVTEDIT;
   VTEDIT101: TVTEDIT;
   VTEDIT150: TVTEDIT;
   VTEDIT132: TVTEDIT;
   VTLABELUS1_3_6: TVTLABEL;
   VTLABELUS1_3_3: TVTLABEL;
   VTLABELUS1_3_4: TVTLABEL;
   VTEDIT235: TVTEDIT;
   VTEDIT234: TVTEDIT;
   VTEDIT233: TVTEDIT;
   VTEDIT232: TVTEDIT;
   VTEDIT231: TVTEDIT;
   VTEDIT230: TVTEDIT;
   VTEDIT229: TVTEDIT;
   VTEDIT228: TVTEDIT;
   VTEDIT227: TVTEDIT;
   VTEDIT226: TVTEDIT;
   VTEDIT225: TVTEDIT;
   VTEDIT224: TVTEDIT;
   VTEDIT222: TVTEDIT;
   VTEDIT221: TVTEDIT;
   VTEDIT219: TVTEDIT;
   VTEDIT218: TVTEDIT;
   VTEDIT217: TVTEDIT;
   VTEDIT216: TVTEDIT;
   VTEDIT215: TVTEDIT;
   VTEDIT214: TVTEDIT;
   VTEDIT213: TVTEDIT;
   VTEDIT212: TVTEDIT;
   VTEDIT211: TVTEDIT;
   VTEDIT210: TVTEDIT;
   VTEDIT208: TVTEDIT;
   VTEDIT207: TVTEDIT;
   VTEDIT205: TVTEDIT;
   VTEDIT204: TVTEDIT;
   VTEDIT203: TVTEDIT;
   VTEDIT202: TVTEDIT;
   VTEDIT201: TVTEDIT;
   VTEDIT223: TVTEDIT;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtEdit48: TvtEdit;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtEdit60: TvtEdit;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtEdit61: TvtEdit;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtEdit62: TvtEdit;
    vtLabel10: TvtLabel;
    vtEdit63: TvtEdit;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    vtShape2: TvtShape;
    vtShape1: TvtShape;
    vtShape3: TvtShape;
    vtShape4: TvtShape;
    vtS1_2Label67: TvtLabel;
    vtS1_2Label66: TvtLabel;
    VTEDIT133: TvtEdit;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel42: TvtLabel;
    vtShape7: TvtShape;
    vtLabel43: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel45: TvtLabel;
    vtLabel46: TvtLabel;
    vtLabel47: TvtLabel;
    vtLabel48: TvtLabel;
    vtLabel49: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel61: TvtLabel;
    vtShape10: TvtShape;
    vtS1_3Label49: TvtLabel;
    vtLabel50: TvtLabel;
    vtEdit13: TvtEdit;
    vtEdit64: TvtEdit;
    vtEdit65: TvtEdit;
    vtEdit66: TvtEdit;
    vtEdit67: TvtEdit;
    vtEdit68: TvtEdit;
    vtEdit69: TvtEdit;
    vtEdit70: TvtEdit;
    vtLabel62: TvtLabel;
    vtLabel63: TvtLabel;
    vtEdit71: TvtEdit;
    vtLabel64: TvtLabel;
    vtLabel65: TvtLabel;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    vtLabel385: TvtLabel;
    vtLabel386: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtEdit39: TvtEdit;
    vtEdit72: TvtEdit;
    vtLabel9: TvtLabel;
    vtEdit73: TvtEdit;
    vtLabel23: TvtLabel;
    vtEdit74: TvtEdit;
    Image1: TImage;
    vtEdit75: TvtEdit;
    vtEdit76: TvtEdit;
    vtEdit136: TvtEdit;
    vtLabel114: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel52: TvtLabel;
    vtLabel53: TvtLabel;
    vtLabel54: TvtLabel;
    vtEdit77: TvtEdit;
    vtEdit78: TvtEdit;
    vtLabel134: TvtLabel;
    vtShape12: TvtShape;
    vtLabel36: TvtLabel;
    vtLabel51: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel69: TvtLabel;
    vtLabel70: TvtLabel;
    vtLabel71: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel40: TvtLabel;
    vtLabel72: TvtLabel;
    vtLabel73: TvtLabel;
    vtEdit79: TvtEdit;
    vtEdit80: TvtEdit;
    vtEdit81: TvtEdit;
    vtEdit82: TvtEdit;
    vtLabel16: TvtLabel;
    vtLabel32: TvtLabel;
    vtEdit12: TvtEdit;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtEdit83: TvtEdit;
    procedure vtLabel33Click(Sender: TObject);
private
  { Private declarations }
public
  { Public declarations }
end;
var
S1: TS1;
implementation
{$R *.DFM}
procedure TS1.vtLabel33Click(Sender: TObject);
begin
object vtEdit21: TvtEdit
  Left = 497
  Top = 99
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
  ReadOnly = True
  ShowHint = True
  TabOrder = 15
  vtPopData.vtPopFieldLength = 0
  vtAlignment = taCenter
  vtColorOnEnter = clWhite
  vtTabOnEnter = True
  vtIsPrintable = False
  vtDataSource = vtUser
  vtTypeAhead = vtNoTypeAhead
  vtInputType = vtYesOrNo
  vtOldBackColor = clBlack
  vtBorderType = vtFull
  vtDecimalPlaces = 0
  vtLayout = vtTop
  BorderFocusColor = clBlack
  vtLVars.vtTableNum = 0
  vtLVars.vtTableColumnNum = 0
  vtLVars.vtTableRowNum = 0
end

end;

end.
