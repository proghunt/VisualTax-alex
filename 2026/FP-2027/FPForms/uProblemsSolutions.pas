unit uProblemsSolutions;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, UAssetsFrame, ComCtrls, wwriched;
type
TProblemsSolutions = class(TForm)
    Homes: TvtLabel;
    vtShape4: TvtShape;
    vtEdit1: TvtEdit;
    wwDBRichEdit1: TwwDBRichEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
ProblemsSolutions: TProblemsSolutions;
implementation
{$R *.DFM}
end.
