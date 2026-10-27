unit us125;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uFlagFrameCan, Buttons, vtPanel;
type
TS125 = class(TForm)
    vtS10Shape23:TvtShape;
    vtS10Label3:TvtLabel;
    vtS10Label8:TvtLabel;
    vtS10Label13:TvtLabel;
    vtS10Shape21:TvtShape;
    vtS10Label4:TvtLabel;
    vtS10Label9:TvtLabel;
    vtS10Label64:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    vtEdit3:TvtEdit;
    vtShape1: TvtShape;
    vtShapePB1: TvtShape;
    vtLabel2: TvtLabel;
    vtS1_1Label22: TvtLabel;
    vtS1_1Label23: TvtLabel;
    vtLabel1: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtEdit4: TvtEdit;
    vtEdit5: TvtEdit;
    vtEdit6: TvtEdit;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel32: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel37: TvtLabel;
    vtEdit10001: TvtEdit;
    vtEdit10002: TvtEdit;
    vtEdit10003: TvtEdit;
    vtEdit10004: TvtEdit;
    vtEdit20001: TvtEdit;
    vtEdit20002: TvtEdit;
    vtEdit20003: TvtEdit;
    vtEdit20004: TvtEdit;
    vtEdit30001: TvtEdit;
    vtEdit30002: TvtEdit;
    vtEdit30003: TvtEdit;
    vtEdit30004: TvtEdit;
    vtEdit40001: TvtEdit;
    vtEdit40002: TvtEdit;
    vtEdit40003: TvtEdit;
    vtEdit40004: TvtEdit;
    vtEdit50001: TvtEdit;
    vtEdit50002: TvtEdit;
    vtEdit50003: TvtEdit;
    vtEdit50004: TvtEdit;
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
    vtShape2: TvtShape;
    vtLabel38: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel39: TvtLabel;
    vtEdit40: TvtEdit;
    vtEdit41: TvtEdit;
    vtEdit42: TvtEdit;
    vtLabel40: TvtLabel;
    vtEdit43: TvtEdit;
    vtEdit44: TvtEdit;
    vtEdit45: TvtEdit;
    vtLabel41: TvtLabel;
    vtEdit46: TvtEdit;
    vtEdit47: TvtEdit;
    vtEdit48: TvtEdit;
    vtLabel42: TvtLabel;
    vtEdit49: TvtEdit;
    vtEdit50: TvtEdit;
    vtEdit51: TvtEdit;
    vtLabel43: TvtLabel;
    vtEdit52: TvtEdit;
    vtEdit53: TvtEdit;
    vtEdit54: TvtEdit;
    vtLabel44: TvtLabel;
    vtEdit55: TvtEdit;
    vtEdit56: TvtEdit;
    vtEdit57: TvtEdit;
    vtLabel45: TvtLabel;
    vtEdit58: TvtEdit;
    vtEdit59: TvtEdit;
    vtEdit60: TvtEdit;
    vtLabel46: TvtLabel;
    vtEdit61: TvtEdit;
    vtEdit62: TvtEdit;
    vtEdit63: TvtEdit;
    vtLabel47: TvtLabel;
    vtLabel48: TvtLabel;
    vtEdit64: TvtEdit;
    vtEdit65: TvtEdit;
    vtEdit66: TvtEdit;
    vtLabel49: TvtLabel;
    vtEdit67: TvtEdit;
    vtEdit68: TvtEdit;
    vtEdit69: TvtEdit;
    vtLabel51: TvtLabel;
    vtEdit70: TvtEdit;
    vtEdit71: TvtEdit;
    vtEdit72: TvtEdit;
    vtLabel52: TvtLabel;
    vtEdit73: TvtEdit;
    vtEdit74: TvtEdit;
    vtEdit75: TvtEdit;
    vtLabel53: TvtLabel;
    vtEdit76: TvtEdit;
    vtEdit77: TvtEdit;
    vtEdit78: TvtEdit;
    vtLabel54: TvtLabel;
    vtEdit79: TvtEdit;
    vtEdit80: TvtEdit;
    vtEdit81: TvtEdit;
    vtLabel55: TvtLabel;
    vtEdit82: TvtEdit;
    vtEdit83: TvtEdit;
    vtEdit84: TvtEdit;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel11: TvtLabel;
    vtEdit7: TvtEdit;
    vtEdit8: TvtEdit;
    vtEdit9: TvtEdit;
    vtEdit60001: TvtEdit;
    vtEdit60002: TvtEdit;
    vtEdit60003: TvtEdit;
    vtEdit60004: TvtEdit;
    vtLabel24: TvtLabel;
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtEdit24: TvtEdit;
    vtLabel59: TvtLabel;
    vtEdit88: TvtEdit;
    vtEdit89: TvtEdit;
    vtEdit90: TvtEdit;
    vtLabel58: TvtLabel;
    S125BTN: TBitBtn;
    S100BTN: TBitBtn;
    S101BTN: TBitBtn;
    S140BTN: TBitBtn;
    CRAGifiGuideBtn: TBitBtn;
    S141BTN: TBitBtn;
    FNOTE2BTN: TBitBtn;
    vtShape3: TvtShape;
    vtEdit85: TvtEdit;
    IMPORTGIFIBTN: TBitBtn;
    vtLabel50: TvtLabel;
    vtShape4: TvtShape;
    vtLabel60: TvtLabel;
    Image1: TImage;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel64: TvtLabel;
    vtLabel65: TvtLabel;
    vtEdit86: TvtEdit;
    vtLabel66: TvtLabel;
    vtLabel67: TvtLabel;
    Label21: TvtLabel;
    vtLabel109: TvtLabel;
    procedure vtLabel7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
S125: TS125;
implementation
{$R *.DFM}

procedure TS125.vtLabel7Click(Sender: TObject);
begin
object vtS1_1Label22: TvtLabel
  Left = 21
  Top = 147
  Width = 243
  Height = 12
  Caption = 'Opeating name, if different than the corpration legal name'
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -9
  Font.Name = 'Arial'
  Font.Style = []
  ParentFont = False
  Transparent = True
  vtBorderType = vtlblNoBorder
end

end;

end.
