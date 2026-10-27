unit fStatBox;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, StdCtrls,
  ExtCtrls, Forms;

type
  TStatusBox = class(TForm)
    MsgLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  FStatusBox: TStatusBox;

implementation

{$R *.DFM}

procedure TStatusBox.FormCreate(Sender: TObject);
begin
end;

procedure TStatusBox.FormActivate(Sender: TObject);
begin
  {MsgLabel.Caption := SomeCaption;}
end;

end.

