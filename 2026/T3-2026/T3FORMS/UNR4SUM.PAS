unit UNR4SUM;
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, GTSize32, DisplayChange, jpeg, ComCtrls, vtLabel,
  Mask, vtEditBox, vtShape, uFlagFrameCan, Buttons;
  TNR4SUM = class(TForm)
    Label2: TvtLabel;
    Label3: TvtLabel;
    Label4: TvtLabel;
    Label10: TvtLabel;
    Label11: TvtLabel;
    Label12: TvtLabel;
    Label13: TvtLabel;
    Label14: TvtLabel;
    Label15: TvtLabel;
    Label22: TvtLabel;
    Label27: TvtLabel;
    Label28: TvtLabel;
    Label30: TvtLabel;
    Label32: TvtLabel;
    Label34: TvtLabel;
    Label35: TvtLabel;
    Label37: TvtLabel;
    Label38: TvtLabel;
    Label39: TvtLabel;
    Label41: TvtLabel;
    Label42: TvtLabel;
    Label44: TvtLabel;
    Label45: TvtLabel;
    Label47: TvtLabel;
    Label49: TvtLabel;
    Label50: TvtLabel;
    Label52: TvtLabel;
    Label54: TvtLabel;
    Label64: TvtLabel;
    Label65: TvtLabel;
    Label68: TvtLabel;
    Label69: TvtLabel;
    Label75: TvtLabel;
    Label84: TvtLabel;
    Label86: TvtLabel;
    Label87: TvtLabel;
    Label91: TvtLabel;
    Label93: TvtLabel;
    Label94: TvtLabel;
    Label95: TvtLabel;
    Label96: TvtLabel;
    Label97: TvtLabel;
    Label98: TvtLabel;
    Label101: TvtLabel;
    Label102: TvtLabel;
    Label117: TvtLabel;
    Label121: TvtLabel;
    Label122: TvtLabel;
    Label123: TvtLabel;
    Label124: TvtLabel;
    Label125: TvtLabel;
    Label126: TvtLabel;
    Label127: TvtLabel;
    Label129: TvtLabel;
    Label130: TvtLabel;
    Label136: TvtLabel;
    Label139: TvtLabel;
    Label142: TvtLabel;
    Label143: TvtLabel;
    Label145: TvtLabel;
    Label149: TvtLabel;
    Label150: TvtLabel;
    Label152: TvtLabel;
    Label153: TvtLabel;
    Label164: TvtLabel;
    Label165: TvtLabel;
    FlagFrameCan1: TFlagFrameCan;
    vtShape9: TvtShape;
    vtShape2: TvtShape;
    vtEdit1: TvtEdit;
    vtShape1: TvtShape;
    vtShape3: TvtShape;
    vtShape4: TvtShape;
    vtShape7: TvtShape;
    vtShape8: TvtShape;
    vtShape10: TvtShape;
    vtShape11: TvtShape;
    vtShape12: TvtShape;
    vtShape13: TvtShape;
    vtShape14: TvtShape;
    vtShape15: TvtShape;
    vtShape16: TvtShape;
    vtShape17: TvtShape;
    vtShape18: TvtShape;
    vtShape19: TvtShape;
    vtShape20: TvtShape;
    vtShape21: TvtShape;
    vtShape22: TvtShape;
    vtShape23: TvtShape;
    vtShape24: TvtShape;
    vtShape25: TvtShape;
    vtShape27: TvtShape;
    vtShape28: TvtShape;
    vtShape30: TvtShape;
    vtShape31: TvtShape;
    vtShape32: TvtShape;
    vtShape33: TvtShape;
    vtShape34: TvtShape;
    vtLabel2: TvtLabel;
    vtShape35: TvtShape;
    vtShape38: TvtShape;
    vtShape40: TvtShape;
    vtShape41: TvtShape;
    vtShape42: TvtShape;
    vtShape43: TvtShape;
    vtShape44: TvtShape;
    vtShape45: TvtShape;
    vtShape46: TvtShape;
    vtShape47: TvtShape;
    vtLabel7: TvtLabel;
    vtShape48: TvtShape;
    vtShape49: TvtShape;
    vtShape50: TvtShape;
    vtShape51: TvtShape;
    vtShape52: TvtShape;
    vtShape53: TvtShape;
    vtShape54: TvtShape;
    vtShape56: TvtShape;
    vtShape57: TvtShape;
    vtShape58: TvtShape;
    vtShape59: TvtShape;
    vtShape60: TvtShape;
    vtShape61: TvtShape;
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
    vtEdit14: TvtEdit;
    vtEdit15: TvtEdit;
    vtEdit16: TvtEdit;
    vtEdit17: TvtEdit;
    vtEdit18: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
    vtEdit21: TvtEdit;
    vtLabel8: TvtLabel;
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtLabel9: TvtLabel;
    vtEdit24: TvtEdit;
    vtEdit25: TvtEdit;
    vtShape62: TvtShape;
    vtShape63: TvtShape;
    vtLabel3: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel4: TvtLabel;
    vtShape64: TvtShape;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtShape29: TvtShape;
    vtShape65: TvtShape;
    vtShape66: TvtShape;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtShape67: TvtShape;
    vtShape68: TvtShape;
    vtLabel26: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel32: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel1: TvtLabel;
    vtEdit26: TvtEdit;
    vtLabel38: TvtLabel;
    vtLabel39: TvtLabel;
    NR4CRAGUIDEBTN: TBitBtn;
    vtLabel726: TvtLabel;
    vtLabel727: TvtLabel;
    vtLabel735: TvtLabel;
    vtLabel736: TvtLabel;
    vtShape5: TvtShape;
    vtShape6: TvtShape;
    vtLabel37: TvtLabel;
    NR4BTN: TBitBtn;
    vtShape26: TvtShape;
    vtLabel27: TvtLabel;
    VTSHAPEUT1159_1_38: TvtShape;
    vtShape36: TvtShape;
    vtLabel29: TvtLabel;
    procedure vtShape12Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  NR4SUM: TNR4SUM;
implementation
{$R *.DFM}
procedure TNR4SUM.vtShape12Click(Sender: TObject);
begin
object VTSHAPEUT1159_1_38: TvtShape
  Left = 441
  Top = 364
  Width = 29
  Height = 22
  Brush.Color = clBtnFace
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
