unit Drawflor;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  Troom = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  room: Troom;

implementation

{$R *.DFM}

procedure Troom.Button1Click(Sender: TObject);
var i,x1,y1,x2,y2, TileWidth: integer;
hdc : THandle;
begin
 {Draw Floor}
 hdc := Canvas.Handle;
 Canvas.Brush.Color := clSilver;
 TileWidth := (Width div 7);
 For i :=0 to 6 do
 begin
   x1 := I * TileWidth;
   y1 := Height ;
   Canvas.MoveTo(x1,Y1);
   x2 := x1 +(Width div 16)*6;
   Y2 := 2 *(Y1 div 3);
   Canvas.LineTo(x2,y2);
   end;
 For i :=0 to 5 do
 begin
   x1 := 0;
   y1 := Height - i * (TileWidth div 3) ;
   Canvas.MoveTo(x1,Y1);
   x2 := Width;
   Y2 := Y1;
   Canvas.LineTo(x2,y2);
   end;

end;

procedure Troom.FormActivate(Sender: TObject);
begin
 WindowState := wsMaximized;
end;

end.
