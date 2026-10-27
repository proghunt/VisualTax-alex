unit Acletter;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, ComCtrls,
  vtLabel, jpeg, vtShape;
type
TAletter = class(TForm)
    LogoImage: TImage;
    vtEdit3: TRichEdit;
    LetterPanel: TPanel;
    vtLabel1: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel3: TvtLabel;
    vtEdit1: TvtEdit;
    vtLabel2: TvtLabel;
    vtShape1: TvtShape;
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
