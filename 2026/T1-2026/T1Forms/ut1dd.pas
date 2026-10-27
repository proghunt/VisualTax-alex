unit ut1dd;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtShape,
  vtLabel, uFlagFrameCan, Buttons, vtGroupBox;
type
TT1DD = class(TForm)
    vtShape3:TvtShape;
    vtShape6: TvtShape;
    vtShape23: TvtShape;
    vtLabel3: TvtLabel;
    T1DDWEBBTN: TBitBtn;
    PageBreak: TvtShape;
    vtShape12: TvtShape;
    vtLabel4: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel15: TvtLabel;
    vtLabel16: TvtLabel;
    vtLabel18: TvtLabel;
    vtLabel1: TvtLabel;
    procedure FormCreate(Sender: TObject);
    procedure vtLabel161Click(Sender: TObject);
    procedure vtGroupBox1Click(Sender: TObject);
    procedure vtGroupBox1Click(Sender: TObject);
    procedure vtLabel44Click(Sender: TObject);
    procedure vtLabel45Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
T1DD: TT1DD;
implementation
{$R *.DFM}




end.
