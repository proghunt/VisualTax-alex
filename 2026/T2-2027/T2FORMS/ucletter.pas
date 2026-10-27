unit uCLetter;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, ComCtrls,
  vtLabel, jpeg, vtShape, Buttons, //wwriched, wwrichedspell,
  vtRichmemobox;
type
TCLetter = class(TForm)
    LetterPanel: TPanel;
    vtLabel1: TvtLabel;
    LetterDesignBtn: TBitBtn;
    PrintLetterBtn: TBitBtn;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    MSWORDBTN: TBitBtn;
    vtShapePB1: TvtShape;
    vtRichMemo1: TvtRichMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
CLetter: TCLetter;

implementation
{$R *.DFM}
end.
