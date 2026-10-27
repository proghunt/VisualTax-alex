unit uSaveAsPdf;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, Buttons;
type
TSaveAsPdf = class(TForm)
    vtShape1:TvtShape;
    vtShape4: TvtShape;
    vtLabel37: TvtLabel;
    vtShape3: TvtShape;
    vtLabel42: TvtLabel;
    vtShape7: TvtShape;
    vtLabel3: TvtLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    vtShape2: TvtShape;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtEdit2: TvtEdit;
    vtLabel7: TvtLabel;
    vtEdit3: TvtEdit;
    vtLabel8: TvtLabel;
    vtEdit4: TvtEdit;
    vtLabel9: TvtLabel;
    vtEdit5: TvtEdit;
    vtLabel10: TvtLabel;
    vtEdit6: TvtEdit;
    vtLabel11: TvtLabel;
    vtEdit7: TvtEdit;
    vtLabel12: TvtLabel;
    vtEdit8: TvtEdit;
    vtLabel14: TvtLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
SaveAsPdf: TSaveAsPdf;
implementation
{$R *.DFM}
end.
