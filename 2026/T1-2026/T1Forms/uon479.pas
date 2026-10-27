unit uon479;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, uFlagFrameON, Buttons;
type
Ton479_1 = class(TForm)
    vtLabel1:TvtLabel;
    vtLabel2:TvtLabel;
    vtLabel11:TvtLabel;
    vtLabel152: TvtLabel;
    vtLabel153: TvtLabel;
    vtLabel154: TvtLabel;
    vtLabel155: TvtLabel;
    vtLabel157: TvtLabel;
    vtLabel159: TvtLabel;
    vtLabel164: TvtLabel;
    vtLabel165: TvtLabel;
    vtLabel166: TvtLabel;
    vtLabel167: TvtLabel;
    vtShape15: TvtShape;
    vtLabel169: TvtLabel;
    vtLabel170: TvtLabel;
    vtLabel172: TvtLabel;
    vtLabel173: TvtLabel;
    vtLabel174: TvtLabel;
    vtLabel175: TvtLabel;
    vtLabel177: TvtLabel;
    vtLabel179: TvtLabel;
    vtLabel181: TvtLabel;
    vtLabel183: TvtLabel;
    vtEdit128: TvtEdit;
    vtEdit127: TvtEdit;
    vtEdit103: TvtEdit;
    vtEdit102: TvtEdit;
    vtEdit126: TvtEdit;
    vtEdit120: TvtEdit;
    vtEdit118: TvtEdit;
    vtEdit117: TvtEdit;
    vtEdit116: TvtEdit;
    vtEdit113: TvtEdit;
    vtShape2: TvtShape;
    vtLabel163: TvtLabel;
    vtShape12: TvtShape;
    vtLabel195: TvtLabel;
    vtLabel197: TvtLabel;
    vtLabel77: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel78: TvtLabel;
    vtLabel119: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtEdit6: TvtEdit;
    vtEdit7: TvtEdit;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel9: TvtLabel;
    vtShape3: TvtShape;
    vtLabel12: TvtLabel;
    vtLabel10: TvtLabel;
    vtShape1: TvtShape;
    vtEdit1: TvtEdit;
    Image3: TImage;
    vtLabel18: TvtLabel;
    vtShape4: TvtShape;
    vtShape21: TvtShape;
    vtLabel41: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel45: TvtLabel;
    vtShape9: TvtShape;
    vtShape10: TvtShape;
    vtLabel46: TvtLabel;
    vtLabel47: TvtLabel;
    vtShape11: TvtShape;
    vtLabel48: TvtLabel;
    vtLabel53: TvtLabel;
    vtLabel49: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtEdit4: TvtEdit;
    vtEdit5: TvtEdit;
    vtLabel32: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel50: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel72: TvtLabel;
    vtLabel85: TvtLabel;
    vtLabel86: TvtLabel;
    vtLabel88: TvtLabel;
    vtLabel93: TvtLabel;
    vtLabel94: TvtLabel;
    vtLabel95: TvtLabel;
    vtLabel98: TvtLabel;
    vtLabel99: TvtLabel;
    vtLabel100: TvtLabel;
    vtLabel101: TvtLabel;
    vtLabel102: TvtLabel;
    vtLabel103: TvtLabel;
    vtLabel104: TvtLabel;
    vtEdit13: TvtEdit;
    vtEdit15: TvtEdit;
    vtLabel107: TvtLabel;
    vtEdit16: TvtEdit;
    vtLabel106: TvtLabel;
    vtEdit17: TvtEdit;
    vtLabel108: TvtLabel;
    vtLabel109: TvtLabel;
    vtLabel110: TvtLabel;
    vtEdit18: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
    vtEdit21: TvtEdit;
    vtLabel111: TvtLabel;
    vtLabel112: TvtLabel;
    vtEdit22: TvtEdit;
    vtLabel114: TvtLabel;
    vtLabel115: TvtLabel;
    vtLabel116: TvtLabel;
    vtEdit23: TvtEdit;
    vtShape6: TvtShape;
    vtEdit24: TvtEdit;
    vtEdit25: TvtEdit;
    vtShape7: TvtShape;
    vtEdit26: TvtEdit;
    vtLabel89: TvtLabel;
    vtLabel90: TvtLabel;
    vtLabel92: TvtLabel;
    vtLabel113: TvtLabel;
    vtEdit14: TvtEdit;
    vtLabel118: TvtLabel;
    vtEdit27: TvtEdit;
    vtLabel120: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel21: TvtLabel;
    vtShape8: TvtShape;
    vtLabel8: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel39: TvtLabel;
    vtEdit2: TvtEdit;
    vtLabel40: TvtLabel;
    vtLabel51: TvtLabel;
    vtLabel52: TvtLabel;
    vtLabel54: TvtLabel;
    vtEdit3: TvtEdit;
    vtLabel59: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel64: TvtLabel;
    vtLabel65: TvtLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
on479_1: Ton479_1;
implementation
{$R *.DFM}
procedure Ton479_1.FormCreate(Sender: TObject);
begin
object vtEdit2: TvtEdit
  Left = 413
  Top = 189
  Width = 14
  Height = 14
  Cursor = crHandPoint
  BorderStyle = bsNone
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  MaxLength = 1
  ParentFont = False
  ParentShowHint = False
  ReadOnly = True
  ShowHint = True
  TabOrder = 1
  vtPopData.vtPopFieldLength = 0
  vtAlignment = taCenter
  vtColorOnEnter = clWhite
  vtTabOnEnter = True
  vtDataSource = vtUser
  vtTypeAhead = vtNoTypeAhead
  vtInputType = vtCheckBox
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
