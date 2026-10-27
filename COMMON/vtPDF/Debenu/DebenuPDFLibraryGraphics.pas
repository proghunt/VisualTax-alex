{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryGraphics.pas                           }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryGraphics;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Types,
{$ENDIF}
  SysUtils, Classes;

type
  TColor = Cardinal;

  TBrushStyle = (bsSolid, bsClear);

  TBrush = class
  private
    FColor: TColor;
    FStyle: TBrushStyle;
  public
    property Color: TColor read FColor write FColor;
    property Style: TBrushStyle read FStyle write FStyle;
  end;

  TPenStyle = (psSolid, psClear);

  TPen = class
  private
    FColor: TColor;
    FStyle: TPenStyle;
    FWidth: Integer;
  public
    property Color: TColor read FColor write FColor;
    property Style: TPenStyle read FStyle write FStyle;
    property Width: Integer read FWidth write FWidth;
  end;

  TFont = class;
  TGraphic = class;

  TCanvas = class
  private
    FHandle: THandle;
    FBrush: TBrush;
    FPen: TPen;
    FFont: TFont;
    function GetPixel(X, Y: Integer): TColor;
    procedure SetPixel(X, Y: Integer; Value: TColor);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CreateHandle; virtual;
    procedure Changing; virtual;
    procedure CopyRect(const Dest: TRect; Canvas: TCanvas; const Source: TRect);
    procedure StretchDraw(const Rect: TRect; Graphic: TGraphic);
    procedure FillRect(const Rect: TRect);
    procedure Draw(X, Y: Integer; Graphic: TGraphic);
    procedure Refresh;
    procedure TextOut(X, Y: Integer; const Text: WideString);
    procedure Lock; {$IFNDEF QPL_NOINLINE} inline; {$ENDIF}
    procedure Unlock; {$IFNDEF QPL_NOINLINE} inline; {$ENDIF}
    property Handle: THandle read FHandle write FHandle;
    property Brush: TBrush read FBrush;
    property Pen: TPen read FPen;
    property Font: TFont read FFont;
    property Pixels[X, Y: Integer]: TColor read GetPixel write SetPixel;
  end;

  TProgressStage = (psStarting, psRunning, psEnding);
  TProgressEvent = procedure (Sender: TObject; Stage: TProgressStage;
    PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string) of object;

  EInvalidGraphic = class(Exception);

  TGraphic = class(TPersistent)
  private
    FEmpty: Boolean;
    FOnProgress: TProgressEvent;
    FPaletteModified: Boolean;
  protected
    procedure Changed(Sender: TObject); virtual;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); virtual;
    function GetEmpty: Boolean; virtual;
    function GetHeight: Integer; virtual;
    function GetWidth: Integer; virtual;
    procedure ReadData(Stream: TStream); virtual;
    procedure SetHeight(Value: Integer); virtual;
    procedure SetWidth(Value: Integer); virtual;
    procedure WriteData(Stream: TStream); virtual;
    function Equals(Graphic: TGraphic): Boolean; reintroduce; overload; virtual;
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create; virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); virtual;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); virtual;
  public
    property Empty: Boolean read FEmpty;
    property Progress: TProgressEvent read FOnProgress;
    property PaletteModified: Boolean read FPaletteModified write FPaletteModified;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  end;

  TPixelFormat = (pf1bit, pf4bit, pf8bit, pf15bit, pf16bit, pf24bit, pf32bit, pfCustom);

  TBitmap = class(TGraphic)
  private
    FPixelFormat: TPixelFormat;
    FWidth: Integer;
    FHeight: Integer;
    FCanvas: TCanvas;
    FHandle: HBITMAP;
    FPalette: HPALETTE;
    FData: array of Byte;
    function GetScanline(Row: Integer): Pointer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure SaveToStream(Stream: TStream); override;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property PixelFormat: TPixelFormat read FPixelFormat write FPixelFormat;
    property ScanLine[Row: Integer]: Pointer read GetScanLine;
    property Canvas: TCanvas read FCanvas;
    property Handle: HBITMAP read FHandle write FHandle;
    property Palette: HPALETTE read FPalette write FPalette;
  end;

  TMetafile = class(TGraphic)
  private
    FEnhanced: Boolean;
    FMMWidth: Integer;
    FMMHeight: Integer;
  public
    procedure Clear;
    property Enhanced: Boolean read FEnhanced write FEnhanced;
    property MMWidth: Integer read FMMWidth write FMMWidth;
    property MMHeight: Integer read FMMHeight write FMMHeight;
  end;

  TMetafileCanvas = class(TCanvas)
  public
    constructor Create(AMetafile: TMetafile; ReferenceDevice: HDC); reintroduce;
  end;

  TFontStyle = (fsBold, fsItalic, fsUnderline, fsStrikeOut);
  TFontStyles = set of TFontStyle;

  TFont = class
  private
    FName: string;
    FSize: Integer;
    FHandle: THandle;
    FCharset: Byte;
    FColor: TColor;
    FHeight: Integer;
    FStyle: TFontStyles;
    FPixelsPerInch: Integer;
  public
    procedure Assign(Obj: TObject);
    property Name: string read FName write FName;
    property Size: Integer read FSize write FSize;
    property Handle: THandle read FHandle;
    property Charset: Byte read FCharset write FCharset;
    property Color: TColor read FColor write FColor;
    property Height: Integer read FHeight write FHeight;
    property Style: TFontStyles read FStyle write FStyle;
    property PixelsPerInch: Integer read FPixelsPerInch write FPixelsPerInch;
  end;

  TSharedImage = class
  private
    FRefCount: Integer;
  protected
    procedure Reference;
    procedure Release;
    procedure FreeHandle; virtual; abstract;
    property RefCount: Integer read FRefCount;
  public
    destructor Destroy; override;
  end;

const
  clWhite = TColor($FFFFFF);
  clBlack = TColor($000000);

function CopyPalette(Palette: HPALETTE): HPALETTE;

implementation

function CopyPalette(Palette: HPALETTE): HPALETTE;
begin
  Result := 0;
end;

procedure TBitmap.Assign(Source: TPersistent);
begin

end;

procedure TBitmap.AssignTo(Dest: TPersistent);
begin

end;

constructor TBitmap.Create;
begin
  inherited;
  FCanvas := TCanvas.Create;
  SetLength(FData, 0);
end;

destructor TBitmap.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

function TBitmap.GetScanline(Row: Integer): Pointer;
var
  Stride: Integer;
begin
  case FPixelFormat of
    pf1bit: Stride := FWidth div 8;
    pf4bit: Stride := FWidth div 4;
    pf8bit: Stride := FWidth;
    pf15bit: Stride := FWidth * 2;
    pf16bit: Stride := FWidth * 2;
    pf24bit: Stride := FWidth * 3;
    pf32bit: Stride := FWidth * 4;
  else
    Stride := FWidth;
  end;
  if (Length(FData) = 0) then
  begin
    SetLength(FData, Stride * FHeight);
  end;
  if (Row < FHeight) then
  begin
    Result := @FData[Row * Stride];
  end else
  begin
    Result := nil;
  end;
end;

procedure TBitmap.SaveToStream(Stream: TStream);
var
  Header: AnsiString;
  UI32: Cardinal;
  UI16: Word;
begin
  Header := 'BM';
  Stream.Write(Header[1], 2);
  UI32 := Length(FData) + 54;
  Stream.Write(UI32, 4);
  UI16 := 0;   // Unused
  Stream.Write(UI16, 2);
  Stream.Write(UI16, 2);
  UI32 := 54;  // Pixel data offset
  Stream.Write(UI32, 4);

  UI32 := 40;  // DIB header size
  Stream.Write(UI32, 4);
  UI32 := FWidth;
  Stream.Write(UI32, 4);
  UI32 := FHeight;
  Stream.Write(UI32, 4);
  UI16 := 1;  // Color planes
  Stream.Write(UI16, 2);

  case FPixelFormat of
    pf1bit: UI16 := 1;
    pf4bit: UI16 := 4;
    pf8bit: UI16 := 8;
    pf16bit: UI16 := 16;
    pf24bit: UI16 := 24;
    pf32bit: UI16 := 32;
  end;
  Stream.Write(UI16, 2);

  UI32 := 0;  // BI_RGB
  Stream.Write(UI32, 4);
  UI32 := Length(FData);
  Stream.Write(UI32, 4);
  UI32 := 3779;
  Stream.Write(UI32, 4);  // HDPI
  Stream.Write(UI32, 4);  // VDPI
  UI32 := 0;
  Stream.Write(UI32, 4);  // Colors in palette
  Stream.Write(UI32, 4);  // Important colors
  if (Length(FData) > 0) then
  begin
    Stream.Write(FData[1], Length(FData));
  end;
end;

{ TFont }

procedure TFont.Assign(Obj: TObject);
begin

end;

{ TCanvas }

procedure TCanvas.Changing;
begin

end;

procedure TCanvas.CopyRect(const Dest: TRect; Canvas: TCanvas;
  const Source: TRect);
begin

end;

constructor TCanvas.Create;
begin
  FFont := TFont.Create;
  FBrush := TBrush.Create;
  FPen := TPen.Create;
end;

procedure TCanvas.CreateHandle;
begin

end;

destructor TCanvas.Destroy;
begin
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  inherited;
end;

procedure TCanvas.Draw(X, Y: Integer; Graphic: TGraphic);
begin

end;

procedure TCanvas.FillRect(const Rect: TRect);
begin

end;

procedure TCanvas.StretchDraw(const Rect: TRect; Graphic: TGraphic);
begin

end;

procedure TCanvas.TextOut(X, Y: Integer; const Text: WideString);
begin

end;

procedure TCanvas.Unlock;
begin
  // Not implemented
end;

function TCanvas.GetPixel(X, Y: Integer): TColor;
begin
  Result := 0;
end;

procedure TCanvas.Lock;
begin
  // Not implemented
end;

procedure TCanvas.Refresh;
begin

end;

procedure TCanvas.SetPixel(X, Y: Integer; Value: TColor);
begin

end;

{ TSharedImage }

destructor TSharedImage.Destroy;
begin
  inherited Destroy;
end;

procedure TSharedImage.Reference;
begin
  Inc(FRefCount);
end;

procedure TSharedImage.Release;
begin
  if Self <> nil then
  begin
    Dec(FRefCount);
    if FRefCount = 0 then
    begin
      FreeHandle;
      Free;
    end;
  end;
end;

{ TGraphic }

constructor TGraphic.Create;
begin

end;

function TGraphic.Equals(Graphic: TGraphic): Boolean;
begin
  Result := False;
end;

procedure TGraphic.AssignTo(Dest: TPersistent);
begin

end;

procedure TGraphic.Changed(Sender: TObject);
begin

end;

procedure TGraphic.Draw(ACanvas: TCanvas; const Rect: TRect);
begin

end;

function TGraphic.GetEmpty: Boolean;
begin
  Result := False;
end;

function TGraphic.GetHeight: Integer;
begin
  Result := 0;
end;

function TGraphic.GetWidth: Integer;
begin
  Result := 0;
end;

procedure TGraphic.ReadData(Stream: TStream);
begin

end;

procedure TGraphic.SetHeight(Value: Integer);
begin

end;

procedure TGraphic.SetWidth(Value: Integer);
begin

end;

procedure TGraphic.WriteData(Stream: TStream);
begin

end;

procedure TGraphic.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin

end;

procedure TGraphic.LoadFromStream(Stream: TStream);
begin

end;

procedure TGraphic.SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPALETTE);
begin

end;

procedure TGraphic.SaveToStream(Stream: TStream);
begin

end;


{ TMetafile }

procedure TMetafile.Clear;
begin

end;

{ TMetafileCanvas }

constructor TMetafileCanvas.Create(AMetafile: TMetafile; ReferenceDevice: HDC);
begin

end;

end.
