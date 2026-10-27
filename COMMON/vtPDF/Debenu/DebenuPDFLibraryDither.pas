{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryDither.pas                             }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryDither;

{$I DebenuPDFLibraryDefines.inc}

{$RANGECHECKS OFF}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryTypes;

procedure Dither(Input, Output: TBitmap; Levels: Integer);

var
  Threshold: Cardinal;

implementation

{$IFDEF WIN64}
type
  OSPtr = IntPtr;
{$ELSE}
type
  OSPtr = Integer;
{$ENDIF}

// Based on dithering code in TGIFImage code by Anders Melander
type
  TColorLookup = class(TObject)
  private
    FColors: Integer;
  public
    constructor Create(Palette: hPalette); virtual;
    function Lookup(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar; virtual; abstract;
    property Colors: Integer read FColors;
  end;

  TMonochromeLookup = class(TColorLookup)
  public
    constructor Create(Palette: hPalette); override;
    function Lookup(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar; override;
  end;

  TDitherEngine = class
  private
  protected
    FDirection: Integer;
    FColumn: Integer;
    FLookup: TColorLookup;
    Width: Integer;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); virtual;
    function Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar; virtual;
    procedure NextLine; virtual;
    procedure NextColumn;
    property Direction: Integer read FDirection;
    property Column: Integer read FColumn;
  end;

  TErrorTerm = Integer;
  TErrors = array[0..0] of TErrorTerm;
  PErrors = ^TErrors;

  TFloydSteinbergDitherer = class(TDitherEngine)
  private
    ErrorsR: PErrors;
    ErrorsG: PErrors;
    ErrorsB: PErrors;
    ErrorR: PErrors;
    ErrorG: PErrors;
    ErrorB: PErrors;
    CurrentErrorR: TErrorTerm;
    CurrentErrorG: TErrorTerm;
    CurrentErrorB: TErrorTerm;
    BelowErrorR: TErrorTerm;
    BelowErrorG: TErrorTerm;
    BelowErrorB: TErrorTerm;
    BelowPrevErrorR: TErrorTerm;
    BelowPrevErrorG: TErrorTerm;
    BelowPrevErrorB: TErrorTerm;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); override;
    destructor Destroy; override;
    function Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar; override;
    procedure NextLine; override;
  end;

  T5by3Ditherer = class(TDitherEngine)
  private
    ErrorsR0: PErrors;
    ErrorsG0: PErrors;
    ErrorsB0: PErrors;
    ErrorsR1: PErrors;
    ErrorsG1: PErrors;
    ErrorsB1: PErrors;
    ErrorsR2: PErrors;
    ErrorsG2: PErrors;
    ErrorsB2: PErrors;
    ErrorR0: PErrors;
    ErrorG0: PErrors;
    ErrorB0: PErrors;
    ErrorR1: PErrors;
    ErrorG1: PErrors;
    ErrorB1: PErrors;
    ErrorR2: PErrors;
    ErrorG2: PErrors;
    ErrorB2: PErrors;
    FDirection2: Integer;
  protected
    FDivisor: Integer;
    procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: Integer); virtual; abstract;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); override;
    destructor Destroy; override;
    function Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar; override;
    procedure NextLine; override;
  end;

  TStuckiDitherer = class(T5by3Ditherer)
  protected
    procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: Integer); override;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); override;
  end;

  TSierraDitherer = class(T5by3Ditherer)
  protected
    procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: Integer); override;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); override;
  end;

  TJaJuNiDitherer = class(T5by3Ditherer)
  protected
    procedure Propagate(Errors0, Errors1, Errors2: PErrors; Error: Integer); override;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); override;
  end;

  TSteveArcheDitherer = class(TDitherEngine)
  private
    ErrorsR0: PErrors;
    ErrorsG0: PErrors;
    ErrorsB0: PErrors;
    ErrorsR1: PErrors;
    ErrorsG1: PErrors;
    ErrorsB1: PErrors;
    ErrorsR2: PErrors;
    ErrorsG2: PErrors;
    ErrorsB2: PErrors;
    ErrorsR3: PErrors;
    ErrorsG3: PErrors;
    ErrorsB3: PErrors;
    ErrorR0: PErrors;
    ErrorG0: PErrors;
    ErrorB0: PErrors;
    ErrorR1: PErrors;
    ErrorG1: PErrors;
    ErrorB1: PErrors;
    ErrorR2: PErrors;
    ErrorG2: PErrors;
    ErrorB2: PErrors;
    ErrorR3: PErrors;
    ErrorG3: PErrors;
    ErrorB3: PErrors;
    FDirection2: Integer;
    FDirection3: Integer;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); override;
    destructor Destroy; override;
    function Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar; override;
    procedure NextLine; override;
  end;

  TBurkesDitherer = class(TDitherEngine)
  private
    ErrorsR0: PErrors;
    ErrorsG0: PErrors;
    ErrorsB0: PErrors;
    ErrorsR1: PErrors;
    ErrorsG1: PErrors;
    ErrorsB1: PErrors;
    ErrorR0: PErrors;
    ErrorG0: PErrors;
    ErrorB0: PErrors;
    ErrorR1: PErrors;
    ErrorG1: PErrors;
    ErrorB1: PErrors;
    FDirection2: Integer;
  public
    constructor Create(AWidth: Integer; Lookup: TColorLookup); override;
    destructor Destroy; override;
    function Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar; override;
    procedure NextLine; override;
  end;

{ TDitherEngine}

constructor TDitherEngine.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create;
  FLookup := Lookup;
  Width := AWidth;
  FDirection := 1;
  FColumn := 0;
end;

function TDitherEngine.Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar;
begin
  Result := FLookup.Lookup(Red, Green, Blue, R, G, B);
  NextColumn;
end;

procedure TDitherEngine.NextLine;
begin
  FDirection := -FDirection;
  if (FDirection = 1) then
    FColumn := 0
  else
    FColumn := Width - 1;
end;

procedure TDitherEngine.NextColumn;
begin
  Inc(FColumn, FDirection);
end;

{ TFloydSteinbergDitherer }

constructor TFloydSteinbergDitherer.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create(AWidth, Lookup);
  GetMem(ErrorsR, SizeOf(TErrorTerm) * (Width + 2));
  GetMem(ErrorsG, SizeOf(TErrorTerm) * (Width + 2));
  GetMem(ErrorsB, SizeOf(TErrorTerm) * (Width + 2));
  FillChar(ErrorsR^, SizeOf(TErrorTerm) * (Width + 2), 0);
  FillChar(ErrorsG^, SizeOf(TErrorTerm) * (Width + 2), 0);
  FillChar(ErrorsB^, SizeOf(TErrorTerm) * (Width + 2), 0);
  ErrorR := ErrorsR;
  ErrorG := ErrorsG;
  ErrorB := ErrorsB;
  CurrentErrorR := 0;
  CurrentErrorG := CurrentErrorR;
  CurrentErrorB := CurrentErrorR;
  BelowErrorR := CurrentErrorR;
  BelowErrorG := CurrentErrorR;
  BelowErrorB := CurrentErrorR;
  BelowPrevErrorR := CurrentErrorR;
  BelowPrevErrorG := CurrentErrorR;
  BelowPrevErrorB := CurrentErrorR;
end;

destructor TFloydSteinbergDitherer.Destroy;
begin
  FreeMem(ErrorsR);
  FreeMem(ErrorsG);
  FreeMem(ErrorsB);
  inherited Destroy;
end;

function TFloydSteinbergDitherer.Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar;
var
  BelowNextError: TErrorTerm;
  Delta: TErrorTerm;
begin
  CurrentErrorR := Red + (CurrentErrorR + ErrorR[0] + 8) div 16;
  if (CurrentErrorR < 0) then
    CurrentErrorR := 0
  else if (CurrentErrorR > 255) then
    CurrentErrorR := 255;

  CurrentErrorG := Green + (CurrentErrorG + ErrorG[0] + 8) div 16;
  if (CurrentErrorG < 0) then
    CurrentErrorG := 0
  else if (CurrentErrorG > 255) then
    CurrentErrorG := 255;

  CurrentErrorB := Blue + (CurrentErrorB + ErrorB[0] + 8) div 16;
  if (CurrentErrorB < 0) then
    CurrentErrorB := 0
  else if (CurrentErrorB > 255) then
    CurrentErrorB := 255;

  Result := inherited Dither(CurrentErrorR, CurrentErrorG, CurrentErrorB, R, G, B);

  CurrentErrorR := CurrentErrorR - R;
  if (CurrentErrorR <> 0) then
  begin
    BelowNextError := CurrentErrorR;
    Delta := CurrentErrorR * 2;
    Inc(CurrentErrorR, Delta);
    ErrorR[0] := BelowPrevErrorR + CurrentErrorR;
    Inc(CurrentErrorR, Delta);
    BelowPrevErrorR := BelowErrorR + CurrentErrorR;
    BelowErrorR := BelowNextError;
    Inc(CurrentErrorR, Delta);
  end;

  CurrentErrorG := CurrentErrorG - G;
  if (CurrentErrorG <> 0) then
  begin
    BelowNextError := CurrentErrorG;
    Delta := CurrentErrorG * 2;
    Inc(CurrentErrorG, Delta);
    ErrorG[0] := BelowPrevErrorG + CurrentErrorG;
    Inc(CurrentErrorG, Delta);
    BelowPrevErrorG := BelowErrorG + CurrentErrorG;
    BelowErrorG := BelowNextError;
    Inc(CurrentErrorG, Delta);
  end;

  CurrentErrorB := CurrentErrorB - B;
  if (CurrentErrorB <> 0) then
  begin
    BelowNextError := CurrentErrorB;
    Delta := CurrentErrorB * 2;
    Inc(CurrentErrorB, Delta);
    ErrorB[0] := BelowPrevErrorB + CurrentErrorB;
    Inc(CurrentErrorB, Delta);
    BelowPrevErrorB := BelowErrorB + CurrentErrorB;
    BelowErrorB := BelowNextError;
    Inc(CurrentErrorB, Delta);
  end;

  if (Direction = 1) then
  begin
    Inc(OSPtr(ErrorR), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB), SizeOf(TErrorTerm));
  end else
  begin
    Dec(OSPtr(ErrorR), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB), SizeOf(TErrorTerm));
  end;
end;

procedure TFloydSteinbergDitherer.NextLine;
begin
  ErrorR[0] := BelowPrevErrorR;
  ErrorG[0] := BelowPrevErrorG;
  ErrorB[0] := BelowPrevErrorB;
  CurrentErrorR := 0;
  CurrentErrorG := CurrentErrorR;
  CurrentErrorB := CurrentErrorG;
  BelowErrorR := CurrentErrorG;
  BelowErrorG := CurrentErrorG;
  BelowErrorB := CurrentErrorG;
  BelowPrevErrorR := CurrentErrorG;
  BelowPrevErrorG := CurrentErrorG;
  BelowPrevErrorB := CurrentErrorG;

  inherited NextLine;

  if (Direction = 1) then
  begin
    ErrorR := ErrorsR;
    ErrorG := ErrorsG;
    ErrorB := ErrorsB;
  end else
  begin
    ErrorR := @ErrorsR[Width + 1];
    ErrorG := @ErrorsG[Width + 1];
    ErrorB := @ErrorsB[Width + 1];
  end;
end;

{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

constructor T5by3Ditherer.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create(AWidth, Lookup);

  GetMem(ErrorsR0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsR1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsR2, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG2, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB2, SizeOf(TErrorTerm) * (Width + 4));
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsR1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsR2^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG2^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB2^, SizeOf(TErrorTerm) * (Width + 4), 0);

  FDivisor := 1;
  FDirection2 := 2 * Direction;
  ErrorR0 := PErrors(LongInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
  ErrorG0 := PErrors(LongInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
  ErrorB0 := PErrors(LongInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
  ErrorR1 := PErrors(LongInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
  ErrorG1 := PErrors(LongInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
  ErrorB1 := PErrors(LongInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
  ErrorR2 := PErrors(LongInt(ErrorsR2) + 2 * SizeOf(TErrorTerm));
  ErrorG2 := PErrors(LongInt(ErrorsG2) + 2 * SizeOf(TErrorTerm));
  ErrorB2 := PErrors(LongInt(ErrorsB2) + 2 * SizeOf(TErrorTerm));
end;

destructor T5by3Ditherer.Destroy;
begin
  FreeMem(ErrorsR0);
  FreeMem(ErrorsG0);
  FreeMem(ErrorsB0);
  FreeMem(ErrorsR1);
  FreeMem(ErrorsG1);
  FreeMem(ErrorsB1);
  FreeMem(ErrorsR2);
  FreeMem(ErrorsG2);
  FreeMem(ErrorsB2);
  inherited Destroy;
end;

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
function T5by3Ditherer.Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar;
var
  ColorR: Integer;
  ColorG: Integer;
  ColorB: Integer;
begin
  // Apply red component error correction
  ColorR := Red + (ErrorR0[0] + FDivisor div 2) div FDivisor;
  if (ColorR < 0) then
    ColorR := 0
  else if (ColorR > 255) then
    ColorR := 255;

  // Apply green component error correction
  ColorG := Green + (ErrorG0[0] + FDivisor div 2) div FDivisor;
  if (ColorG < 0) then
    ColorG := 0
  else if (ColorG > 255) then
    ColorG := 255;

  // Apply blue component error correction
  ColorB := Blue + (ErrorB0[0] + FDivisor div 2) div FDivisor;
  if (ColorB < 0) then
    ColorB := 0
  else if (ColorB > 255) then
    ColorB := 255;

  // Map color to palette
  Result := inherited Dither(ColorR, ColorG, ColorB, R, G, B);

  // Propagate red component error
  Propagate(ErrorR0, ErrorR1, ErrorR2, ColorR - R);
  // Propagate green component error
  Propagate(ErrorG0, ErrorG1, ErrorG2, ColorG - G);
  // Propagate blue component error
  Propagate(ErrorB0, ErrorB1, ErrorB2, ColorB - B);

  // Move on to next column
  if (Direction = 1) then
  begin
    Inc(OSPtr(ErrorR0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorR1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorR2), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG2), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB2), SizeOf(TErrorTerm));
  end else
  begin
    Dec(OSPtr(ErrorR0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorR1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorR2), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG2), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB2), SizeOf(TErrorTerm));
  end;
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
procedure T5by3Ditherer.NextLine;
var
  TempErrors: PErrors;
begin
  FillChar(ErrorsR0^, SizeOf(TErrorTerm)*(Width+4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm)*(Width+4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm)*(Width+4), 0);

  // Swap lines
  TempErrors := ErrorsR0;
  ErrorsR0 := ErrorsR1;
  ErrorsR1 := ErrorsR2;
  ErrorsR2 := TempErrors;

  TempErrors := ErrorsG0;
  ErrorsG0 := ErrorsG1;
  ErrorsG1 := ErrorsG2;
  ErrorsG2 := TempErrors;

  TempErrors := ErrorsB0;
  ErrorsB0 := ErrorsB1;
  ErrorsB1 := ErrorsB2;
  ErrorsB2 := TempErrors;

  inherited NextLine;

  FDirection2 := 2 * Direction;
  if (Direction = 1) then
  begin
    ErrorR0 := PErrors(LongInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
    ErrorG0 := PErrors(LongInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
    ErrorB0 := PErrors(LongInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
    ErrorR1 := PErrors(LongInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
    ErrorG1 := PErrors(LongInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
    ErrorB1 := PErrors(LongInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
    ErrorR2 := PErrors(LongInt(ErrorsR2) + 2 * SizeOf(TErrorTerm));
    ErrorG2 := PErrors(LongInt(ErrorsG2) + 2 * SizeOf(TErrorTerm));
    ErrorB2 := PErrors(LongInt(ErrorsB2) + 2 * SizeOf(TErrorTerm));
  end else
  begin
    ErrorR0 := @ErrorsR0[Width + 1];
    ErrorG0 := @ErrorsG0[Width + 1];
    ErrorB0 := @ErrorsB0[Width + 1];
    ErrorR1 := @ErrorsR1[Width + 1];
    ErrorG1 := @ErrorsG1[Width + 1];
    ErrorB1 := @ErrorsB1[Width + 1];
    ErrorR2 := @ErrorsR2[Width + 1];
    ErrorG2 := @ErrorsG2[Width + 1];
    ErrorB2 := @ErrorsB2[Width + 1];
  end;
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

// TStuckiDitherer
constructor TStuckiDitherer.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create(AWidth, Lookup);
  FDivisor := 42;
end;

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
procedure TStuckiDitherer.Propagate(Errors0, Errors1, Errors2: PErrors; Error: Integer);
begin
  if (Error = 0) then Exit;

  Inc(Errors2[FDirection2], Error);
  Inc(Errors2[-FDirection2], Error);

  Error := Error + Error;
  Inc(Errors1[FDirection2], Error);
  Inc(Errors1[-FDirection2], Error);
  Inc(Errors2[Direction], Error);
  Inc(Errors2[-Direction], Error);

  Error := Error + Error;
  Inc(Errors0[FDirection2], Error);
  Inc(Errors1[-Direction], Error);
  Inc(Errors1[Direction], Error);
  Inc(Errors2[0], Error);

  Error := Error + Error;
  Inc(Errors0[Direction], Error);
  Inc(Errors1[0], Error);
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

// TSierraDitherer
constructor TSierraDitherer.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create(AWidth, Lookup);
  FDivisor := 32;
end;

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
procedure TSierraDitherer.Propagate(Errors0, Errors1, Errors2: PErrors; Error: Integer);
var
  TempError: Integer;
begin
  if (Error = 0) then Exit;

  TempError := Error + Error;
  Inc(Errors1[FDirection2], TempError);
  Inc(Errors1[-FDirection2], TempError);
  Inc(Errors2[Direction], TempError);
  Inc(Errors2[-Direction], TempError);

  Inc(TempError, Error);
  Inc(Errors0[FDirection2], TempError);
  Inc(Errors2[0], TempError);

  Inc(TempError, Error);
  Inc(Errors1[-Direction], TempError);
  Inc(Errors1[Direction], TempError);

  Inc(TempError, Error);
  Inc(Errors0[Direction], TempError);
  Inc(Errors1[0], TempError);
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

// TJaJuNiDitherer
constructor TJaJuNiDitherer.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create(AWidth, Lookup);
  FDivisor := 38;
end;

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
procedure TJaJuNiDitherer.Propagate(Errors0, Errors1, Errors2: PErrors; Error: Integer);
var
  TempError: Integer;
begin
  if (Error = 0) then Exit;

  Inc(Errors2[FDirection2], Error);
  Inc(Errors2[-FDirection2], Error);

  TempError := Error + Error;
  Inc(Error, TempError);
  Inc(Errors1[FDirection2], Error);
  Inc(Errors1[-FDirection2], Error);
  Inc(Errors2[Direction], Error);
  Inc(Errors2[-Direction], Error);

  Inc(Error, TempError);
  Inc(Errors0[FDirection2], Error);
  Inc(Errors1[-Direction], Error);
  Inc(Errors1[Direction], Error);
  Inc(Errors2[0], Error);

  Inc(Error, TempError);
  Inc(Errors0[Direction], Error);
  Inc(Errors1[0], Error);
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

// TSteveArcheDitherer
constructor TSteveArcheDitherer.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create(AWidth, Lookup);

  GetMem(ErrorsR0, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG0, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB0, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsR1, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG1, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB1, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsR2, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG2, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB2, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsR3, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsG3, SizeOf(TErrorTerm) * (Width + 6));
  GetMem(ErrorsB3, SizeOf(TErrorTerm) * (Width + 6));
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsR1^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG1^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB1^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsR2^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG2^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB2^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsR3^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsG3^, SizeOf(TErrorTerm) * (Width + 6), 0);
  FillChar(ErrorsB3^, SizeOf(TErrorTerm) * (Width + 6), 0);

  FDirection2 := 2 * Direction;
  FDirection3 := 3 * Direction;

  ErrorR0 := PErrors(LongInt(ErrorsR0) + 3 * SizeOf(TErrorTerm));
  ErrorG0 := PErrors(LongInt(ErrorsG0) + 3 * SizeOf(TErrorTerm));
  ErrorB0 := PErrors(LongInt(ErrorsB0) + 3 * SizeOf(TErrorTerm));
  ErrorR1 := PErrors(LongInt(ErrorsR1) + 3 * SizeOf(TErrorTerm));
  ErrorG1 := PErrors(LongInt(ErrorsG1) + 3 * SizeOf(TErrorTerm));
  ErrorB1 := PErrors(LongInt(ErrorsB1) + 3 * SizeOf(TErrorTerm));
  ErrorR2 := PErrors(LongInt(ErrorsR2) + 3 * SizeOf(TErrorTerm));
  ErrorG2 := PErrors(LongInt(ErrorsG2) + 3 * SizeOf(TErrorTerm));
  ErrorB2 := PErrors(LongInt(ErrorsB2) + 3 * SizeOf(TErrorTerm));
  ErrorR3 := PErrors(LongInt(ErrorsR3) + 3 * SizeOf(TErrorTerm));
  ErrorG3 := PErrors(LongInt(ErrorsG3) + 3 * SizeOf(TErrorTerm));
  ErrorB3 := PErrors(LongInt(ErrorsB3) + 3 * SizeOf(TErrorTerm));
end;

destructor TSteveArcheDitherer.Destroy;
begin
  FreeMem(ErrorsR0);
  FreeMem(ErrorsG0);
  FreeMem(ErrorsB0);
  FreeMem(ErrorsR1);
  FreeMem(ErrorsG1);
  FreeMem(ErrorsB1);
  FreeMem(ErrorsR2);
  FreeMem(ErrorsG2);
  FreeMem(ErrorsB2);
  FreeMem(ErrorsR3);
  FreeMem(ErrorsG3);
  FreeMem(ErrorsB3);
  inherited Destroy;
end;

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
function TSteveArcheDitherer.Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar;
var
  ColorR: Integer;
  ColorG: Integer;
  ColorB: Integer;

  procedure Propagate(Errors0, Errors1, Errors2, Errors3: PErrors; Error: Integer);
  var
    TempError: Integer;
  begin
    if (Error = 0) then Exit;

    TempError := 5 * Error;
    Inc(Errors3[FDirection3], TempError);
    Inc(Errors3[-FDirection3], TempError);

    TempError := 12 * Error;
    Inc(Errors1[-FDirection3], TempError);
    Inc(Errors2[-FDirection2], TempError);
    Inc(Errors2[FDirection2], TempError);
    Inc(Errors3[-Direction], TempError);
    Inc(Errors3[Direction], TempError);

    Inc(Errors1[FDirection3], 16 * TempError);

    TempError := 26 * Error;
    Inc(Errors1[-Direction], TempError);
    Inc(Errors2[0], TempError);

    Inc(Errors1[Direction], 30 * Error);

    Inc(Errors0[FDirection2], 32 * Error);
  end;

begin
  // Apply red component error correction
  ColorR := Red + (ErrorR0[0] + 100) div 200;
  if (ColorR < 0) then
    ColorR := 0
  else if (ColorR > 255) then
    ColorR := 255;

  // Apply green component error correction
  ColorG := Green + (ErrorG0[0] + 100) div 200;
  if (ColorG < 0) then
    ColorG := 0
  else if (ColorG > 255) then
    ColorG := 255;

  // Apply blue component error correction
  ColorB := Blue + (ErrorB0[0] + 100) div 200;
  if (ColorB < 0) then
    ColorB := 0
  else if (ColorB > 255) then
    ColorB := 255;

  // Map color to palette
  Result := inherited Dither(ColorR, ColorG, ColorB, R, G, B);

  // Propagate red component error
  Propagate(ErrorR0, ErrorR1, ErrorR2, ErrorR3, ColorR - R);
  // Propagate green component error
  Propagate(ErrorG0, ErrorG1, ErrorG2, ErrorG3, ColorG - G);
  // Propagate blue component error
  Propagate(ErrorB0, ErrorB1, ErrorB2, ErrorB3, ColorB - B);

  // Move on to next column
  if (Direction = 1) then
  begin
    Inc(OSPtr(ErrorR0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorR1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorR2), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG2), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB2), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorR3), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG3), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB3), SizeOf(TErrorTerm));
  end else
  begin
    Dec(OSPtr(ErrorR0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorR1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorR2), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG2), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB2), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorR3), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG3), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB3), SizeOf(TErrorTerm));
  end;
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
procedure TSteveArcheDitherer.NextLine;
var
  TempErrors: PErrors;
begin
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) *(Width + 6), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) *(Width + 6), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) *(Width + 6), 0);

  // Swap lines
  TempErrors := ErrorsR0;
  ErrorsR0 := ErrorsR1;
  ErrorsR1 := ErrorsR2;
  ErrorsR2 := ErrorsR3;
  ErrorsR3 := TempErrors;

  TempErrors := ErrorsG0;
  ErrorsG0 := ErrorsG1;
  ErrorsG1 := ErrorsG2;
  ErrorsG2 := ErrorsG3;
  ErrorsG3 := TempErrors;

  TempErrors := ErrorsB0;
  ErrorsB0 := ErrorsB1;
  ErrorsB1 := ErrorsB2;
  ErrorsB2 := ErrorsB3;
  ErrorsB3 := TempErrors;

  inherited NextLine;

  FDirection2 := 2 * Direction;
  FDirection3 := 3 * Direction;

  if (Direction = 1) then
  begin
    ErrorR0 := PErrors(LongInt(ErrorsR0) + 3 * SizeOf(TErrorTerm));
    ErrorG0 := PErrors(LongInt(ErrorsG0) + 3 * SizeOf(TErrorTerm));
    ErrorB0 := PErrors(LongInt(ErrorsB0) + 3 * SizeOf(TErrorTerm));
    ErrorR1 := PErrors(LongInt(ErrorsR1) + 3 * SizeOf(TErrorTerm));
    ErrorG1 := PErrors(LongInt(ErrorsG1) + 3 * SizeOf(TErrorTerm));
    ErrorB1 := PErrors(LongInt(ErrorsB1) + 3 * SizeOf(TErrorTerm));
    ErrorR2 := PErrors(LongInt(ErrorsR2) + 3 * SizeOf(TErrorTerm));
    ErrorG2 := PErrors(LongInt(ErrorsG2) + 3 * SizeOf(TErrorTerm));
    ErrorB2 := PErrors(LongInt(ErrorsB2) + 3 * SizeOf(TErrorTerm));
    ErrorR3 := PErrors(LongInt(ErrorsR3) + 3 * SizeOf(TErrorTerm));
    ErrorG3 := PErrors(LongInt(ErrorsG3) + 3 * SizeOf(TErrorTerm));
    ErrorB3 := PErrors(LongInt(ErrorsB3) + 3 * SizeOf(TErrorTerm));
  end else
  begin
    ErrorR0 := @ErrorsR0[Width + 2];
    ErrorG0 := @ErrorsG0[Width + 2];
    ErrorB0 := @ErrorsB0[Width + 2];
    ErrorR1 := @ErrorsR1[Width + 2];
    ErrorG1 := @ErrorsG1[Width + 2];
    ErrorB1 := @ErrorsB1[Width + 2];
    ErrorR2 := @ErrorsR2[Width + 2];
    ErrorG2 := @ErrorsG2[Width + 2];
    ErrorB2 := @ErrorsB2[Width + 2];
    ErrorR3 := @ErrorsR2[Width + 2];
    ErrorG3 := @ErrorsG2[Width + 2];
    ErrorB3 := @ErrorsB2[Width + 2];
  end;
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

// TBurkesDitherer
constructor TBurkesDitherer.Create(AWidth: Integer; Lookup: TColorLookup);
begin
  inherited Create(AWidth, Lookup);

  GetMem(ErrorsR0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB0, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsR1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsG1, SizeOf(TErrorTerm) * (Width + 4));
  GetMem(ErrorsB1, SizeOf(TErrorTerm) * (Width + 4));
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsR1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG1^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB1^, SizeOf(TErrorTerm) * (Width + 4), 0);

  FDirection2 := 2 * Direction;
  ErrorR0 := PErrors(LongInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
  ErrorG0 := PErrors(LongInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
  ErrorB0 := PErrors(LongInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
  ErrorR1 := PErrors(LongInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
  ErrorG1 := PErrors(LongInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
  ErrorB1 := PErrors(LongInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
end;

destructor TBurkesDitherer.Destroy;
begin
  FreeMem(ErrorsR0);
  FreeMem(ErrorsG0);
  FreeMem(ErrorsB0);
  FreeMem(ErrorsR1);
  FreeMem(ErrorsG1);
  FreeMem(ErrorsB1);
  inherited Destroy;
end;

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
function TBurkesDitherer.Dither(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar;
var
  ErrorR: Integer;
  ErrorG: Integer;
  ErrorB: Integer;

  procedure Propagate(Errors0, Errors1: PErrors; Error: Integer);
  begin
    if (Error = 0) then Exit;

    Inc(Error, Error);
    Inc(Errors1[FDirection2], Error);
    Inc(Errors1[-FDirection2], Error);

    Inc(Error, Error);
    Inc(Errors0[FDirection2], Error);  
    Inc(Errors1[-Direction], Error);  
    Inc(Errors1[Direction], Error);

    Inc(Error, Error);
    Inc(Errors0[Direction], Error);
    Inc(Errors1[0], Error);
  end;

begin
  // Apply red component error correction
  ErrorR := Red + (ErrorR0[0] + 16) div 32;
  if (ErrorR < 0) then
    ErrorR := 0
  else if (ErrorR > 255) then
    ErrorR := 255;

  // Apply green component error correction
  ErrorG := Green + (ErrorG0[0] + 16) div 32;
  if (ErrorG < 0) then
    ErrorG := 0
  else if (ErrorG > 255) then
    ErrorG := 255;

  // Apply blue component error correction
  ErrorB := Blue + (ErrorB0[0] + 16) div 32;
  if (ErrorB < 0) then
    ErrorB := 0
  else if (ErrorB > 255) then
    ErrorB := 255;

  // Map color to palette
  Result := inherited Dither(ErrorR, ErrorG, ErrorB, R, G, B);

  // Propagate red component error
  Propagate(ErrorR0, ErrorR1, ErrorR - R);
  // Propagate green component error
  Propagate(ErrorG0, ErrorG1, ErrorG - G);
  // Propagate blue component error
  Propagate(ErrorB0, ErrorB1, ErrorB - B);

  // Move on to next column
  if (Direction = 1) then
  begin
    Inc(OSPtr(ErrorR0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB0), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorR1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorG1), SizeOf(TErrorTerm));
    Inc(OSPtr(ErrorB1), SizeOf(TErrorTerm));
  end else
  begin
    Dec(OSPtr(ErrorR0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB0), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorR1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorG1), SizeOf(TErrorTerm));
    Dec(OSPtr(ErrorB1), SizeOf(TErrorTerm));
  end;
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}

{$IFOPT R+}
  {$DEFINE R_PLUS}
  {$RANGECHECKS OFF}
{$ENDIF}
procedure TBurkesDitherer.NextLine;
var
  TempErrors: PErrors;
begin
  FillChar(ErrorsR0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsG0^, SizeOf(TErrorTerm) * (Width + 4), 0);
  FillChar(ErrorsB0^, SizeOf(TErrorTerm) * (Width + 4), 0);

  // Swap lines
  TempErrors := ErrorsR0;
  ErrorsR0 := ErrorsR1;
  ErrorsR1 := TempErrors;

  TempErrors := ErrorsG0;
  ErrorsG0 := ErrorsG1;
  ErrorsG1 := TempErrors;

  TempErrors := ErrorsB0;
  ErrorsB0 := ErrorsB1;
  ErrorsB1 := TempErrors;

  inherited NextLine;

  FDirection2 := 2 * Direction;
  if (Direction = 1) then
  begin
    ErrorR0 := PErrors(LongInt(ErrorsR0) + 2 * SizeOf(TErrorTerm));
    ErrorG0 := PErrors(LongInt(ErrorsG0) + 2 * SizeOf(TErrorTerm));
    ErrorB0 := PErrors(LongInt(ErrorsB0) + 2 * SizeOf(TErrorTerm));
    ErrorR1 := PErrors(LongInt(ErrorsR1) + 2 * SizeOf(TErrorTerm));
    ErrorG1 := PErrors(LongInt(ErrorsG1) + 2 * SizeOf(TErrorTerm));
    ErrorB1 := PErrors(LongInt(ErrorsB1) + 2 * SizeOf(TErrorTerm));
  end else
  begin
    ErrorR0 := @ErrorsR0[Width + 1];
    ErrorG0 := @ErrorsG0[Width + 1];
    ErrorB0 := @ErrorsB0[Width + 1];
    ErrorR1 := @ErrorsR1[Width + 1];
    ErrorG1 := @ErrorsG1[Width + 1];
    ErrorB1 := @ErrorsB1[Width + 1];
  end;
end;
{$IFDEF R_PLUS}
  {$RANGECHECKS ON}
  {$UNDEF R_PLUS}
{$ENDIF}


{ TColorLookup}

constructor TColorLookup.Create(Palette: HPalette);
begin
  inherited Create;
end;

{ TMonochromeLookup }

constructor TMonochromeLookup.Create(Palette: HPalette);
begin
  inherited Create(Palette);
  FColors := 2;
end;

function TMonochromeLookup.Lookup(Red, Green, Blue: Byte; var R, G, B: Byte): AnsiChar;
begin
  if ((Blue * 29 + Green * 150 + Red * 77) > Threshold) then
  begin
    Result := #1;
    R := 255;
    G := 255;
    B := 255;
  end else
  begin
    Result := #0;
    R := 0;
    G := 0;
    B := 0;
  end;
end;

procedure Dither(Input, Output: TBitmap; Levels: Integer);
var
  Row: Integer;
  Ditherer: TDitherEngine;
  Lookup: TMonochromeLookup;
  SrcScanline: PRGBTriple;
  DstScanline: PAnsiChar;
  Src: PRGBTriple;
  Dst: PAnsiChar;
  BGR: TRGBTriple;
begin
  Lookup := TMonochromeLookup.Create(Output.Palette);
  try
    Ditherer := TStuckiDitherer.Create(Input.Width, Lookup);
    try
      Row := 0;
      while (Row < Input.Height) do
      begin
        SrcScanline := Input.ScanLine[Row];
        DstScanline := Output.ScanLine[Row];

        Src := Pointer(TQPLIntPtr(SrcScanLine) + Ditherer.Column * SizeOf(TRGBTriple));
        Dst := Pointer(TQPLIntPtr(DstScanLine) + Ditherer.Column);

        while (Ditherer.Column < Ditherer.Width) and (Ditherer.Column >= 0) do
        begin
          BGR := Src^;
          Dst^ := Ditherer.Dither(BGR.rgbtRed, BGR.rgbtGreen, BGR.rgbtBlue,
            BGR.rgbtRed, BGR.rgbtGreen, BGR.rgbtBlue);
          Inc(Src, Ditherer.Direction);
          Inc(Dst, Ditherer.Direction);
        end;

        Inc(Row);
        Ditherer.NextLine;
      end;
    finally
      Ditherer.Free;
    end;
  finally
    Lookup.Free;
  end;
end;

initialization
  Threshold := 32512;
end.
