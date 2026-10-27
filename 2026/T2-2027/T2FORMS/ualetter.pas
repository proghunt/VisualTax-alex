unit UAletter;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, ComCtrls,
  vtLabel, jpeg, vtShape, wwriched, Buttons, vtRichmemobox;
type
TAletter = class(TForm)
    //wwDBRichEdit1: TwwDBRichEdit;
    LetterPanel: TPanel;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    LetterDesignBtn: TBitBtn;
    PrintLetterBtn: TBitBtn;
    vtShapePB1: TvtShape;
    vtRichMemo1: TvtRichMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
Aletter: TAletter;

implementation
{$R *.DFM}
end.
