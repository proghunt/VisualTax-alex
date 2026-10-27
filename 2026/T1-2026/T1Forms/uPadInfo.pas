unit uPadInfo;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, Buttons, vtGroupBox;
type
TPadInfo = class(TForm)
    Shape1:TShape;
    vtShape4: TvtShape;
    vtLabel87: TvtLabel;
    vtGroupBox1: TvtGroupBox;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtEdit3: TvtEdit;
    vtEdit2: TvtEdit;
    vtEdit1: TvtEdit;
    vtGroupBox2: TvtGroupBox;
    vtLabel4: TvtLabel;
    vtEdit4: TvtEdit;
    vtLabel5: TvtLabel;
    vtEdit5: TvtEdit;
    Shape2: TShape;
    vtShape7: TvtShape;
    vtLabel23: TvtLabel;
    T185BTN: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
PadInfo: TPadInfo
implementation
{$R *.DFM}
end.
