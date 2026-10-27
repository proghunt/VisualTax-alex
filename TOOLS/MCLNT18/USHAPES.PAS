unit Ushapes;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TShapes = class(TForm)
    tab: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    table: TButton;
    Edit1: TEdit;
    procedure tabClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure tableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Shapes: TShapes;

implementation

{$R *.DFM}

procedure TShapes.tabClick(Sender: TObject);
var
 Hdc : THandle;
 TabLength, TabWidth : integer;
 i,TabX, TabY,StartTextY : integer;
 TabColor : TColor;
 TabText : string[10];
 {TabPosition, TabColor}
begin
TabColor := clRed;
TabX := 100; TabY := 100;
Canvas.Brush.Color := TabColor;
Hdc := Canvas.Handle;
TabText := 'FILTaaaaa';
TabLength := Length(TabText) * 15; TabWidth := 20;
Canvas.Polygon([
     Point(TabX,TabY),
     Point(TabX+TabWidth,TabY+(TabLength div 8)),
     Point(TabX+TabWidth,TabY+TabLength-(TabLength div 8)),
     Point(TabX,TabY+TabLength)
     ]);
Canvas.Font.Name := 'Arial';
Canvas.Font.Size := 8;
Canvas.Font.Style := [FsBold];
StartTextY := TabY + TabLength div 10;
Canvas.Textout(TabX + TabWidth div 2,StartTextY,TabText[1]);
for i :=2 to Length(TabText) do
    Canvas.Textout(TabX + TabWidth div 2,StartTextY+12*(i-1),TabText[i]);

Canvas.Polygon([Point(10, 30), Point(10+30, 30-20),
    Point(10+70, 30-20), Point(10+70, 30)]);
end;

procedure TShapes.Button2Click(Sender: TObject);
begin
close;
end;

procedure TShapes.Button3Click(Sender: TObject);
begin
 Canvas.Brush.Color := clTeal;

  {Canvas.Polygon([Point(10, 10), Point(30, 10),
    Point(130, 30), Point(240, 120)]);}
end;

procedure TShapes.Button4Click(Sender: TObject);
begin
 Canvas.Brush.Color := clRed;
 Form1.Canvas.Pie(10, 10, 200, 200, 61, 3, 200, 61);
 {Form1.Canvas.Pie(10, 10, 200, 200, 61, 3, 200, 61);}
end;

procedure TShapes.Button5Click(Sender: TObject);
begin
Canvas.Brush.Color := clLime;
 Canvas.Ellipse(0, 0, ClientWidth, ClientHeight);
end;

procedure TShapes.tableClick(Sender: TObject);
var
StartX,StartY,TableHeight, TableWidth, TableDepth : integer;
begin
Startx := 50; StartY := ClientHeight-20;
TableHeight := ClientHeight div 2;
TableWidth := ClientWidth div 2;TableDepth := ClientHeight div 4;
{leg1}
Canvas.Polygon([
    Point(Startx,StartY),
    Point(StartX, StartY-TableHeight),
    Point(StartX+TableWidth div 3, StartY-TableHeight),
    Point(StartX+TableWidth div 3, StartY)
    ]);
{leg2}
  Canvas.Polygon([
    Point(Startx+(3*TableWidth) div 4,StartY),
    Point(StartX+(3*TableWidth) div 4, StartY-TableHeight),
    Point(StartX+(3*TableWidth) div 4+TableWidth div 3,
      StartY-TableHeight),
    Point(StartX+(3*TableWidth) div 4+TableWidth div 3, StartY)
    ]);
 {Top}
 Canvas.Polygon([
    Point(Startx-40, StartY-TableHeight),
    Point(StartX+TableWidth div 2,
        StartY-TableHeight-TableDepth),
    Point(StartX+TableWidth+TableWidth div 2,
       StartY-TableHeight-TableDepth),
    Point(StartX+TableWidth+40, StartY-TableHeight)
    ]);
end;

procedure TShapes.FormCreate(Sender: TObject);
begin
Form1.WindowState := WsMaximized;
end;

end.
