unit uENGAGE;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, ComCtrls,
  vtLabel, jpeg, vtShape, Buttons, vtRichmemobox;
type
TENGAGE = class(TForm)
    LetterPanel: TPanel;
    vtLabel1: TvtLabel;
    LetterDesignBtn: TBitBtn;
    PrintLetterBtn: TBitBtn;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtShapePB1: TvtShape;
    vtRichMemo1: TvtRichMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
ENGAGE: TENGAGE;

implementation
{$R *.DFM}
end.
