unit uas9sup;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, uFlagFrameAB, Buttons;
type
TAS9SUP = class(TForm)
    vtAS10Shape85:TvtShape;
    vtAS10Label4:TvtLabel;
    vtAS10Label5:TvtLabel;
    vtAS10Label6:TvtLabel;
    vtAS10Label7:TvtLabel;
    vtAS10Label8:TvtLabel;
    vtAS10Label10:TvtLabel;
    vtAS10Label12:TvtLabel;
    vtAS10Label16:TvtLabel;
    vtAS10Label17:TvtLabel;
    vtAS10Label114:TvtLabel;
    vtAS10Label92:TvtLabel;
    vtAS10Label67:TvtLabel;
    vtAS10Label71:TvtLabel;
    vtEdit2:TvtEdit;
    vtEdit3:TvtEdit;
    vtLabel3: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel1: TvtLabel;
    vts381_1Label125: TvtLabel;
    vtEdit4: TvtEdit;
    vtLabel2: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtEdit5: TvtEdit;
    vtLabel21: TvtLabel;
    vtLabel22: TvtLabel;
    vtEdit6: TvtEdit;
    vtLabel23: TvtLabel;
    vtLabel24: TvtLabel;
    vtEdit7: TvtEdit;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtEdit8: TvtEdit;
    vtLabel31: TvtLabel;
    vtLabel32: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel51: TvtLabel;
    vtLabel52: TvtLabel;
    vtLabel53: TvtLabel;
    vtLabel54: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel60: TvtLabel;
    vtLabel61: TvtLabel;
    vtLabel62: TvtLabel;
    vtLabel63: TvtLabel;
    vtLabel68: TvtLabel;
    vtLabel69: TvtLabel;
    vtLabel72: TvtLabel;
    vtEdit9: TvtEdit;
    vtEdit10: TvtEdit;
    vtEdit11: TvtEdit;
    vtEdit12: TvtEdit;
    vtEdit13: TvtEdit;
    vtEdit14: TvtEdit;
    vtEdit15: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
    vtEdit22: TvtEdit;
    vtLabel155: TvtLabel;
    vtShape30: TvtShape;
    vtLabel148: TvtLabel;
    vtLabel150: TvtLabel;
    vtLabel156: TvtLabel;
    vtLabel157: TvtLabel;
    vtLabel158: TvtLabel;
    vtLabel159: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel36: TvtLabel;
    vtEdit1: TvtEdit;
    vtEdit16: TvtEdit;
    vtEdit17: TvtEdit;
    vtLabel8: TvtLabel;
    vtEdit21: TvtEdit;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    vtShape2: TvtShape;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel40: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel45: TvtLabel;
    VTEDIT23: TvtEdit;
    vtShape20: TvtShape;
    vtShape1: TvtShape;
    vtShape3: TvtShape;
    vtAT1_1Label5: TvtLabel;
    vtLabel46: TvtLabel;
    vtLabel47: TvtLabel;
    FlagFrameAB1: TFlagFrameAB;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
AS9SUP: TAS9SUP;
implementation
{$R *.DFM}
end.
