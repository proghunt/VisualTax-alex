unit ut1099;
 
interface 
 
uses 
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, 
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape, 
  vtLabel; 
 
type 
  Tt1099 = class(TForm) 

    vtShapePB1: TvtShape;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    vtLabel11: TvtLabel;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel22: TvtLabel;
    vtLabel24: TvtLabel;
    vtLabel25: TvtLabel;
    vtLabel36: TvtLabel;
    vtLabel37: TvtLabel;
    vtLabel38: TvtLabel;
    vtLabel39: TvtLabel;
    vtLabel40: TvtLabel;
    vtLabel41: TvtLabel;
    vtLabel42: TvtLabel;
    vtLabel44: TvtLabel;
    vtLabel45: TvtLabel;
    vtLabel46: TvtLabel;
    vtLabel47: TvtLabel;
    vtLabel48: TvtLabel;
    vtLabel87: TvtLabel;
    vtLabel88: TvtLabel;
    vtLabel89: TvtLabel;
    vtLabel93: TvtLabel;
    vtLabel94: TvtLabel;
    vtLabel95: TvtLabel;
    vtLabel307: TvtLabel;
    vtLabel308: TvtLabel;
    Image1: TImage;
    vtLabel96: TvtLabel;
    vtRC145Shape7: TvtShape;
    vtRC145Shape5: TvtShape;
    vtPAGE_1Label8: TvtLabel;
    VTLABELUPAGE_1_8: TvtLabel;
    vtLabel1: TvtLabel;
    vtShape10: TvtShape;
    vtShape11: TvtShape;
    vtRC145Label16: TvtLabel;
    vtRC145Label15: TvtLabel;
    vtRC145Label14: TvtLabel;
    vtLabel923: TvtLabel;
    vtLabel924: TvtLabel;
    vtLabel925: TvtLabel;
    vtLabel168: TvtLabel;
    VTEDIT1: TvtEdit;
    vtEdit2: TvtEdit;
    vtEdit4: TvtEdit;
    vtEdit5: TvtEdit;
    vtShape1: TvtShape;
    vtRC145Label13: TvtLabel;
    vtEdit3: TvtEdit;
    vtEdit6: TvtEdit;
    vtEdit7: TvtEdit;
    vtEdit8: TvtEdit;
    vtEdit9: TvtEdit;
    vtShape38: TvtShape;
    vtEdit10: TvtEdit;
    vtShape140: TvtShape;
    vtLabel49: TvtLabel;
    vtLabel50: TvtLabel;
    vtShape2: TvtShape;
    vtEdit11: TvtEdit;
    vtShape3: TvtShape;
    vtLabel2: TvtLabel;
    vtLabel12: TvtLabel;
    vtLabel13: TvtLabel;
    vtShape4: TvtShape;
    vtEdit12: TvtEdit;
    vtShape5: TvtShape;
    vtLabel16: TvtLabel;
    vtLabel17: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel19: TvtLabel;
    vtLabel20: TvtLabel;
    vtLabel21: TvtLabel;
    vtLabel23: TvtLabel;
    vtShape6: TvtShape;
    vtEdit13: TvtEdit;
    vtShape7: TvtShape;
    vtLabel26: TvtLabel;
    vtLabel27: TvtLabel;
    vtLabel28: TvtLabel;
    vtLabel29: TvtLabel;
    vtLabel30: TvtLabel;
    vtLabel31: TvtLabel;
    vtLabel32: TvtLabel;
    vtShape8: TvtShape;
    vtEdit14: TvtEdit;
    vtShape9: TvtShape;
    vtLabel33: TvtLabel;
    vtLabel34: TvtLabel;
    vtLabel35: TvtLabel;
    vtLabel43: TvtLabel;
    vtLabel51: TvtLabel;
    vtLabel52: TvtLabel;
    vtLabel53: TvtLabel;
    vtShape12: TvtShape;
    vtEdit15: TvtEdit;
    vtShape13: TvtShape;
    vtLabel54: TvtLabel;
    vtLabel55: TvtLabel;
    vtLabel56: TvtLabel;
    vtLabel57: TvtLabel;
    vtLabel58: TvtLabel;
    vtLabel59: TvtLabel;
    vtLabel60: TvtLabel;
    vtEdit16: TvtEdit;
    vtEdit17: TvtEdit;
    vtEdit18: TvtEdit;
    vtEdit19: TvtEdit;
    vtEdit20: TvtEdit;
    vtEdit21: TvtEdit;
    vtEdit22: TvtEdit;
    vtEdit23: TvtEdit;
    vtEdit24: TvtEdit;
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
    vtShape14: TvtShape;
    vtLabel61: TvtLabel;
    vtShape15: TvtShape;
    vtLabel83: TvtLabel;
    vtEdit64: TvtEdit;
    vtShape16: TvtShape;
    vtLabel62: TvtLabel;
    vtEdit65: TvtEdit;
    vtShape17: TvtShape;
    vtLabel63: TvtLabel;
    vtEdit66: TvtEdit;
    vtShape18: TvtShape;
    vtLabel64: TvtLabel;
    vtEdit67: TvtEdit;
    vtShape23: TvtShape;
  private 
      { Private declarations } 
    public 
      { Public declarations } 
    end; 
 
 var    t1099: Tt1099; 
  implementation 
 
  {$R *.dfm} 
 
  end.
