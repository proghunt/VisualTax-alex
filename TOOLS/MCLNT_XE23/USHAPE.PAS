unit Ushape;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,
  TrimStr;

type
  Tfshape = class(TForm)
    tab: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    table: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    ToBinary: TButton;
    ToText: TButton;
    procedure tabClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure tableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    Function VL(s: string):Real;
    Function InsertCommas(s: string):String;
    procedure ToBinaryClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fshape: Tfshape;

implementation

{$R *.DFM}

procedure Tfshape.tabClick(Sender: TObject);
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

procedure Tfshape.Button2Click(Sender: TObject);
begin
close;
end;

procedure Tfshape.Button3Click(Sender: TObject);
begin
 Canvas.Brush.Color := clTeal;

  {Canvas.Polygon([Point(10, 10), Point(30, 10),
    Point(130, 30), Point(240, 120)]);}
end;

procedure Tfshape.Button4Click(Sender: TObject);
begin
 Canvas.Brush.Color := clRed;
 Fshape.Canvas.Pie(10, 10, 200, 200, 61, 3, 200, 61);
 {Form1.Canvas.Pie(10, 10, 200, 200, 61, 3, 200, 61);}
end;

procedure Tfshape.Button5Click(Sender: TObject);
begin
Canvas.Brush.Color := clLime;
 Canvas.Ellipse(0, 0, ClientWidth, ClientHeight);
end;

procedure Tfshape.tableClick(Sender: TObject);
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

procedure Tfshape.FormCreate(Sender: TObject);
begin
Fshape.WindowState := WsMaximized;
end;

procedure Tfshape.BitBtn1Click(Sender: TObject);
var
FormattedAmount : String[15];
S1 :String[15];
begin

Str(vl(Edit1.Text)
  :(Length(Edit1.Text)-2):2,FormattedAmount);

S1 := LeftStr(FormattedAmount,Length(FormattedAmount)-3);

FormattedAmount := InsertCommas(s1)+RightStr(FormattedAmount,3);
Label1.Caption := FormattedAmount;

end;


Function TfShape.VL(s: string):Real;
Var
Code : integer;
r    : Real;
begin
  Val(s,Result,Code);
end;

Function TfShape.InsertCommas(s: string):String;
Var S1 : string[10];
i : integer;
begin
 Result := s;
 Case Length(s) of
  4 : Result := LeftStr(S,1)+','+RightStr(S,3);
  5 : Result := LeftStr(S,2)+','+RightStr(S,3);
  6 : Result := LeftStr(S,3)+','+RightStr(S,3);
  7 : Result := Leftstr(s,1)+','+MidStr(S,3,3)+','+RightStr(S,3);
  8 : Result := Leftstr(s,2)+','+MidStr(S,3,3)+','+RightStr(S,3);
 end;



 {
  i := Length(s);
    while (i >0) do
     begin
     S1[i] := S[i];
     Dec(i);
     end;
  }
   { LTrim := Copy(Str,i,len)}
  {S1 := RightStr(s,3);}
 { Result := S;}
end;
procedure Tfshape.ToBinaryClick(Sender: TObject);
Var InputStream, OutputStream : TStream;
begin
InputStream  := TFileStream.Create('c:\delphi\t1\test.txt', fmOpenRead);
OutputStream := TFileStream.Create('c:\delphi\t1\test.bin', fmCreate);
ObjectTextToBinary(InputStream,OutputStream);
{
ObjectBinaryToText(InputStream,OutputStream);
}
end;

end.
