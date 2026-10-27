unit Usplash;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TSplash = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Image1: TImage;
    BitBtn1: TBitBtn;
    procedure Panel1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Splash: TSplash;

implementation

{$R *.DFM}

procedure TSplash.Panel1DblClick(Sender: TObject);
begin
close;
end;

end.
