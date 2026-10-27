{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryGenericCanvas.pas                      }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryGenericCanvas;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryMatrix;

type
  TPDFGenericShapeCommandType = (ctBegin, ctMove, ctLine, ctBezier, ctQBezier,
    ctClose, ctStroke, ctFill, ctStrokeAndFill);

  TPDFGenericShapeCommand = record
    CommandType: TPDFGenericShapeCommandType;
    X1, Y1: Double;
    X2, Y2: Double;
    X3, Y3: Double;
  end;

  TPDFGenericShape = class
  private
    FCommands: array of TPDFGenericShapeCommand;
    FCommandSize: Integer;
    FCommandCount: Integer;
    procedure AddCommand(Command: TPDFGenericShapeCommand);
  public
    constructor Create;
    procedure MoveTo(NewX, NewY: Double);
    procedure AddLineToPath(EndX, EndY: Double);
    procedure AddBezierToPath(CtAX, CtAY, CtBX, CtBY, EndX, EndY: Double);
    procedure AddQBezierToPath(QX, QY, EndX, EndY: Double);
    procedure ClosePath;
    procedure StrokePath;
    procedure FillPath;
    procedure StrokeAndFillPath;
  end;

  TPDFGenericCanvas = class
  public
    constructor Create;
    procedure BeginPath; virtual; abstract;
    procedure MoveTo(NewX, NewY: Double); virtual; abstract;
    procedure AddLineToPath(EndX, EndY: Double); virtual; abstract;
    procedure AddBezierToPath(CtAX, CtAY, CtBX, CtBY, EndX, EndY: Double); virtual; abstract;
    procedure AddQBezierToPath(QX, QY, EndX, EndY: Double); virtual; abstract;
    procedure ClosePath; virtual; abstract;
    procedure StrokePath; virtual; abstract;
    procedure FillPath; virtual; abstract;
    procedure StrokeAndFillPath; virtual; abstract;
    procedure DrawShape(Shape: TPDFGenericShape; var Mat: TPDFXForm);
    procedure DrawBitmap(BM: TBitmap; var ULX, ULY, URX, URY, LLX, LLY: Double); virtual; abstract;
    procedure SetCurrentXForm(NewCurrentXForm: TPDFXForm); virtual;
    function GetCurrentXForm: TPDFXForm; virtual;
  end;

implementation

{ TPDFGenericShape }

procedure TPDFGenericShape.AddBezierToPath(CtAX, CtAY, CtBX, CtBY, EndX,
  EndY: Double);
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctBezier;
  Command.X1 := CtAX;
  Command.Y1 := CtAY;
  Command.X2 := CtBX;
  Command.Y2 := CtBY;
  Command.X3 := EndX;
  Command.Y3 := EndY;
  AddCommand(Command);
end;

procedure TPDFGenericShape.AddCommand(Command: TPDFGenericShapeCommand);
begin
  FCommands[FCommandCount] := Command;
  Inc(FCommandCount);
  if FCommandCount = FCommandSize then
  begin
    Inc(FCommandSize, 20);
    SetLength(FCommands, FCommandSize);
  end;
end;

procedure TPDFGenericShape.AddLineToPath(EndX, EndY: Double);
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctLine;
  Command.X1 := EndX;
  Command.Y1 := EndY;
  AddCommand(Command);
end;

procedure TPDFGenericShape.AddQBezierToPath(QX, QY, EndX, EndY: Double);
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctQBezier;
  Command.X1 := QX;
  Command.Y1 := QY;
  Command.X2 := EndX;
  Command.Y2 := EndY;
  AddCommand(Command);
end;

procedure TPDFGenericShape.ClosePath;
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctClose;
  AddCommand(Command);
end;

constructor TPDFGenericShape.Create;
begin
  FCommandSize := 20;
  SetLength(FCommands, FCommandSize);
  FCommandCount := 0;
end;

procedure TPDFGenericShape.FillPath;
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctFill;
  AddCommand(Command);
end;

procedure TPDFGenericShape.MoveTo(NewX, NewY: Double);
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctMove;
  Command.X1 := NewX;
  Command.Y1 := NewY;
  AddCommand(Command);
end;

procedure TPDFGenericShape.StrokeAndFillPath;
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctStrokeAndFill;
  AddCommand(Command);
end;

procedure TPDFGenericShape.StrokePath;
var
  Command: TPDFGenericShapeCommand;
begin
  Command.CommandType := ctStroke;
  AddCommand(Command);
end;

{ TPDFGenericCanvas }
constructor TPDFGenericCanvas.Create;
begin
end;

procedure TPDFGenericCanvas.SetCurrentXForm(NewCurrentXForm: TPDFXForm);
begin
end;

function TPDFGenericCanvas.GetCurrentXForm: TPDFXForm;
var
  CMT : TPDFXForm;
begin
  Result := CMT;
end;

procedure TPDFGenericCanvas.DrawShape(Shape: TPDFGenericShape; var Mat: TPDFXForm);
var
  X: Integer;
begin
  for X := 0 to Shape.FCommandCount - 1 do
  with Shape.FCommands[X] do
  begin
    case CommandType of
      ctBegin: BeginPath;
      ctMove: MoveTo(
        Mat.eM11 * X1 + Mat.eM21 * Y1 + Mat.eDx,
        Mat.eM12 * X1 + Mat.eM22 * Y1 + Mat.eDy);
      ctLine: AddLineToPath(
        Mat.eM11 * X1 + Mat.eM21 * Y1 + Mat.eDx,
        Mat.eM12 * X1 + Mat.eM22 * Y1 + Mat.eDy);
      ctBezier: AddBezierToPath(
        Mat.eM11 * X1 + Mat.eM21 * Y1 + Mat.eDx,
        Mat.eM12 * X1 + Mat.eM22 * Y1 + Mat.eDy,
        Mat.eM11 * X2 + Mat.eM21 * Y2 + Mat.eDx,
        Mat.eM12 * X2 + Mat.eM22 * Y2 + Mat.eDy,
        Mat.eM11 * X3 + Mat.eM21 * Y3 + Mat.eDx,
        Mat.eM12 * X3 + Mat.eM22 * Y3 + Mat.eDy);
      ctQBezier: AddQBezierToPath(
        Mat.eM11 * X1 + Mat.eM21 * Y1 + Mat.eDx,
        Mat.eM12 * X1 + Mat.eM22 * Y1 + Mat.eDy,
        Mat.eM11 * X2 + Mat.eM21 * Y2 + Mat.eDx,
        Mat.eM12 * X2 + Mat.eM22 * Y2 + Mat.eDy);
      ctClose: ClosePath;
      ctStroke: StrokePath;
      ctFill: FillPath;
      ctStrokeAndFill: StrokeAndFillPath;
    end;
  end;
end;

end.
