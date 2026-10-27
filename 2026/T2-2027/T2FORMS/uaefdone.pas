unit uaEfDone;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, uFlagFrameAB, Buttons;
type
TAEFDone = class(TForm)
    vtAS1_1Shape2:TvtShape;
    vtAS1_1Label4:TvtLabel;
    vtAS1_1Label6:TvtLabel;
    vtAS1_1Label7:TvtLabel;
    vtAS1_1Label17:TvtLabel;
    vtAS1_1Shape1:TvtShape;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    FlagFrameAB1: TFlagFrameAB;
    vtLabel1: TvtLabel;
    AEFDonePrintBtn: TBitBtn;
    AEFDoneCloseBtn: TBitBtn;
    vtEdit3: TvtEdit;
    vtEdit4: TvtEdit;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtEdit5: TvtEdit;
    vtShapePB1: TvtShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
AEFDone: TAEFDone;
implementation
{$R *.DFM}
end.
