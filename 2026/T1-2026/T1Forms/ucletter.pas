unit uCLetter;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, ComCtrls,
  vtLabel, jpeg, vtShape, Buttons, wwriched, wwrichedspell;
type
TCLetter = class(TForm)
    LetterPanel: TPanel;
    vtLabel1: TvtLabel;
    LetterDesignBtn: TBitBtn;
    PrintLetterBtn: TBitBtn;
    wwDBRichEdit1: TwwDBRichEdit;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    MSWORDBTN: TBitBtn;
    PageBreak: TvtShape;
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
