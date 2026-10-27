unit us101;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, uFlagFrameCan, Buttons, vtPanel;
type
TS101 = class(TForm)
    vtS10Shape23:TvtShape;
    vtS10Label3:TvtLabel;
    vtS10Label8:TvtLabel;
    vtS10Shape21:TvtShape;
    vtS10Label4:TvtLabel;
    vtS10Label9:TvtLabel;
    vtS10Label64:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    vtEdit3:TvtEdit;
    vtShape1: TvtShape;
    vtLabel6: TvtLabel;
    vtShapePB1: TvtShape;
    vtLabel80: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel35: TvtLabel;
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
    vtEdit10: TvtEdit;
    vtEdit11: TvtEdit;
    vtEdit12: TvtEdit;
    vtEdit13: TvtEdit;
    vtEdit14: TvtEdit;
    vtEdit15: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
    vtEdit21: TvtEdit;
    vtEdit31: TvtEdit;
    vtEdit32: TvtEdit;
    vtEdit33: TvtEdit;
    vtLabel7: TvtLabel;
    vtLabel24: TvtLabel;
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtEdit24: TvtEdit;
    vtLabel59: TvtLabel;
    vtEdit88: TvtEdit;
    vtEdit89: TvtEdit;
    vtEdit90: TvtEdit;
    vtS10Label13: TvtLabel;
    vtLabel2: TvtLabel;
    vtEdit40001: TvtEdit;
    vtEdit40002: TvtEdit;
    vtEdit40003: TvtEdit;
    vtEdit40004: TvtEdit;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtEdit50001: TvtEdit;
    vtEdit50002: TvtEdit;
    vtEdit50003: TvtEdit;
    vtEdit50004: TvtEdit;
    vtEdit60001: TvtEdit;
    vtEdit60002: TvtEdit;
    vtEdit60003: TvtEdit;
    vtEdit60004: TvtEdit;
    vtLabel11: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel1: TvtLabel;
    vtEdit70001: TvtEdit;
    vtEdit70002: TvtEdit;
    vtEdit70003: TvtEdit;
    vtEdit70004: TvtEdit;
    vtLabel15: TvtLabel;
    vtEdit4: TvtEdit;
    vtEdit5: TvtEdit;
    vtEdit6: TvtEdit;
    vtLabel16: TvtLabel;
    vtEdit80001: TvtEdit;
    vtEdit80002: TvtEdit;
    vtEdit80003: TvtEdit;
    vtEdit80004: TvtEdit;
    vtLabel17: TvtLabel;
    vtEdit7: TvtEdit;
    vtEdit8: TvtEdit;
    vtEdit9: TvtEdit;
    vtLabel18: TvtLabel;
    vtLabel21: TvtLabel;
    vtEdit28: TvtEdit;
    vtEdit29: TvtEdit;
    vtEdit30: TvtEdit;
    vtLabel23: TvtLabel;
    vtEdit34: TvtEdit;
    vtEdit35: TvtEdit;
    vtEdit36: TvtEdit;
    vtLabel22: TvtLabel;
    vtEdit37: TvtEdit;
    vtEdit38: TvtEdit;
    vtEdit39: TvtEdit;
    vtLabel26: TvtLabel;
    vtEdit40: TvtEdit;
    vtEdit41: TvtEdit;
    vtEdit42: TvtEdit;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtEdit43: TvtEdit;
    vtEdit44: TvtEdit;
    vtEdit45: TvtEdit;
    vtLabel31: TvtLabel;
    vtEdit50: TvtEdit;
    vtEdit51: TvtEdit;
    vtEdit52: TvtEdit;
    vtLabel32: TvtLabel;
    vtEdit53: TvtEdit;
    vtEdit54: TvtEdit;
    vtEdit55: TvtEdit;
    vtLabel33: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel58: TvtLabel;
    S125BTN: TBitBtn;
    S100BTN: TBitBtn;
    S101BTN: TBitBtn;
    S140BTN: TBitBtn;
    CRAGifiGuideBtn: TBitBtn;
    S141BTN: TBitBtn;
    FNOTE2BTN: TBitBtn;
    vtLabel19: TvtLabel;
    Image1: TImage;
    vtLabel25: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel36: TvtLabel;
    procedure vtLabel7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
S101: TS101;
implementation
{$R *.DFM}

procedure TS101.vtLabel7Click(Sender: TObject);
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
