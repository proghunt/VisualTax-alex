unit uT3SUM;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, uFlagFrameCan, Buttons;
type
TT3SUM = class(TForm)
    vtT3SUMShape3:TvtShape;
    vtT3SUMShape7:TvtShape;
    vtT3SUMShape6:TvtShape;
    vtT3SUMShape68:TvtShape;
    vtT3SUMShape55:TvtShape;
    vtT3SUMShape36:TvtShape;
    vtT3SUMLabel2:TvtLabel;
    vtT3SUMLabel3:TvtLabel;
    vtT3SUMLabel11:TvtLabel;
    vtT3SUMLabel14:TvtLabel;
    vtT3SUMLabel15:TvtLabel;
    vtT3SUMLabel16:TvtLabel;
    vtT3SUMLabel17:TvtLabel;
    vtT3SUMLabel18:TvtLabel;
    vtT3SUMLabel21:TvtLabel;
    vtT3SUMLabel23:TvtLabel;
    vtT3SUMLabel25:TvtLabel;
    vtT3SUMLabel27:TvtLabel;
    vtT3SUMLabel30:TvtLabel;
    vtT3SUMLabel31:TvtLabel;
    vtT3SUMLabel32:TvtLabel;
    vtT3SUMLabel34:TvtLabel;
    vtT3SUMLabel35:TvtLabel;
    vtT3SUMLabel38:TvtLabel;
    vtT3SUMLabel39:TvtLabel;
    vtT3SUMLabel44:TvtLabel;
    vtT3SUMLabel45:TvtLabel;
    vtT3SUMLabel48:TvtLabel;
    vtT3SUMLabel49:TvtLabel;
    vtT3SUMLabel52:TvtLabel;
    vtT3SUMLabel53:TvtLabel;
    vtT3SUMLabel54:TvtLabel;
    vtT3SUMLabel75:TvtLabel;
    vtT3SUMLabel76:TvtLabel;
    vtT3SUMLabel103:TvtLabel;
    vtT3SUMLabel104:TvtLabel;
    vtT3SUMLabel107:TvtLabel;
    vtT3SUMLabel108:TvtLabel;
    vtT3SUMLabel109:TvtLabel;
    vtT3SUMLabel12:TvtLabel;
    vtT3SUMLabel116:TvtLabel;
    vtT3SUMLabel26:TvtLabel;
    vtT3SUMLabel138:TvtLabel;
    vtT3SUMLabel13:TvtLabel;
    vtT3SUMLabel24:TvtLabel;
    vtT3SUMLabel82:TvtLabel;
    vtT3SUMLabel84:TvtLabel;
    vtT3SUMLabel85:TvtLabel;
    vtT3SUMLabel64:TvtLabel;
    vtT3SUMLabel86:TvtLabel;
    vtT3SUMLabel89:TvtLabel;
    vtT3SUMLabel9:TvtLabel;
    vtT3SUMLabel5:TvtLabel;
    vtT3SUMLabel7:TvtLabel;
    vtT3SUMLabel8:TvtLabel;
    vtT3SUMLabel40:TvtLabel;
    vtT3SUMLabel50:TvtLabel;
    vtT3SUMLabel37:TvtLabel;
    vtT3SUMLabel10:TvtLabel;
    vtT3SUMLabel46:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    vtEdit3:TvtEdit;
    vtEdit4:TvtEdit;
    vtEdit5:TvtEdit;
    vtEdit6:TvtEdit;
    vtEdit7:TvtEdit;
    vtEdit8:TvtEdit;
    vtEdit9:TvtEdit;
    vtEdit12:TvtEdit;
    vtEdit15:TvtEdit;
    vtEdit16:TvtEdit;
    vtEdit18:TvtEdit;
    vtEdit21:TvtEdit;
    vtEdit22:TvtEdit;
    vtEdit24:TvtEdit;
    vtEdit33:TvtEdit;
    vtEdit11:TvtEdit;
    vtEdit13:TvtEdit;
    vtEdit36:TvtEdit;
    vtEdit37:TvtEdit;
    vtEdit38:TvtEdit;
    vtEdit14:TvtEdit;
    vtEdit17:TvtEdit;
    vtShape1: TvtShape;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtEdit10: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
    vtLabel9: TvtLabel;
    vtLabel11: TvtLabel;
    vtShape2: TvtShape;
    T3Sum2Btn: TBitBtn;
    vtLabel12: TvtLabel;
    vtT3SUMShape1: TvtShape;
    vtLabel13: TvtLabel;
    vtLabel14: TvtLabel;
    vtShape3: TvtShape;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtShape4: TvtShape;
    vtLabel22: TvtLabel;
    vtShape5: TvtShape;
    vtLabel30: TvtLabel;
    vtLabel23: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtT3Sl1Label2: TvtLabel;
    vtT3Sl1Label1: TvtLabel;
    vtLabel100: TvtLabel;
    vtLabel124: TvtLabel;
    Image1: TImage;
    e_SignatureHolder: TImage;
    vtLabel5: TvtLabel;
    vtLabel18: TvtLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
T3SUM: TT3SUM;
implementation
{$R *.DFM}
end.
