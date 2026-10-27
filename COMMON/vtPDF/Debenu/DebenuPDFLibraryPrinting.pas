{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryPrinting.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryPrinting;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
  WinSpool,
{$ENDIF}
  SysUtils,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
  DebenuPDFLibraryPrinters,
{$ELSE}
  Vcl.Graphics,
  Vcl.Printers,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Types,
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
{$IFDEF QPL_XE3_HIGHER}
  System.Types,
{$ENDIF}
{$ENDIF}
  DebenuPDFLibraryExtra,
  Classes;

type
  TPDFCustomPrinter = class
  private
    Fields: Cardinal;
    FOriginalPrinterName: WideString;
    PaperSize: Integer;      // Set to <0 for default, or DMPAPER_xxx (1 to 68), not zero
    PaperLength: Integer;    // Set to <0 for default, or length in mm/10
    PaperWidth: Integer;     // Set to <0 for default, or length in mm/10
    Copies: Integer;         // Set to <0 for default, or number of copies, not zero
    PrintQuality: Integer;   // Set to <0 for default, or 1 for high, 2 for medium, 3 for low, 4 for draft, not zero
    Color: Integer;          // Set to <0 for default, or 1 for monochrome, 2 for color, not zero
    Duplex: Integer;         // Set to <0 for default, or 1 for simplex, 2 for duplex horizontal, 3 for duplex vertical, not zero
    Collate: Integer;        // Set to <0 for default, or 0 for no, 1 for yes
    DefaultSource: Integer;  // Set to <0 for default, or DMBIN_xxx (1 or greater)
    MediaType: Integer;      // Set to <0 for default, 1 for standard, 2 for transparency, 3 for glossy (1 or greater)
    Orientation: Integer;    // Set to <0 for default, 1 for portrait, 2 for landscape
  public
    constructor Create(const AOriginalPrinterName: WideString);
    function Setup(Setting, Value: Integer): Boolean;
    procedure SetPrinter(APrinter: TPrinter; const DevModeString: AnsiString);
    property OriginalPrinterName: WideString read FOriginalPrinterName;
  end;

  TLocalCanvas = class(TCanvas)
  private
    FPrinter: TPrinter;
  public
    DC: HDC;
    constructor Create(APrinter: TPrinter); reintroduce;
    destructor Destroy; override;
    procedure CreateHandle; override;
    procedure UpdateFont;
    procedure Changing; override;
  end;

  TQPLPrinter = class
  protected
    FPrinter: TPrinter;
    FCanvas: TCanvas;
    FLocalDC: HDC;
    FFileName: WideString;
    FUseLocal: Boolean;
    FPrinterJobID: Integer;
    FPrinterName: AnsiString;
    FStartPaused: Boolean;
    FPreviewBitmap: TBitmap;
    FPreviewScale: Double;
    function GetTitle: string;
    procedure SetTitle(const NewTitle: string);
    function GetCanvas: TCanvas;
    function GetAborted: Boolean;
    function GetHandle: HDC;
    function GetPageHeight: Integer;
    function GetPageWidth: Integer;
    function GetFullPageHeight: Integer;
    function GetFullPageWidth: Integer;
    function GetPrintOffsetX: Integer;
    function GetPrintOffsetY: Integer;
    function GetPrinting: Boolean;
    function GetHasPreview: Boolean;
  public
    constructor Create(Printer: TPrinter; const FileName: WideString; UseLocal: Boolean);
    destructor Destroy; override;
    procedure BeginDoc;
    procedure EndDoc;
    procedure NewPage;
    procedure SetupPreview(MaxDimension: Integer);
    procedure SetStartPaused(StartPaused: Boolean);
    function SavePreviewToString: AnsiString;
    function GetDPI: Integer;
    property PrinterJobID: Integer read FPrinterJobID;
    property PrinterName: AnsiString read FPrinterName;
    property Title: string read GetTitle write SetTitle;
    property Canvas: TCanvas read GetCanvas;
    property Aborted: Boolean read GetAborted;
    property Handle: HDC read GetHandle;
    property PageHeight: Integer read GetPageHeight;
    property PageWidth: Integer read GetPageWidth;
    property PrintOffsetX: Integer read GetPrintOffsetX;
    property PrintOffsetY: Integer read GetPrintOffsetY;
    property FullPageWidth: Integer read GetFullPageWidth;
    property FullPageHeight: Integer read GetFullPageHeight;
    property Printing: Boolean read GetPrinting;
    property PreviewScale: Double read FPreviewScale;
    property HasPreview: Boolean read GetHasPreview;
  end;

function GetPrinterBins(APrinter: TPrinter): AnsiString;

function GetPrinterMediaTypes(APrinter: TPrinter): AnsiString;

function GetPrintJobStatus(StatusCode, JobID: Integer; const PrinterName: AnsiString): Integer;

function GetDevModeToString(APrinter: TPrinter): AnsiString;

procedure SetDevModeFromString(APrinter: TPrinter; const DevModeString: AnsiString);

procedure GetPrinterList(List: TQuickPDFStringList);

function GetDefaultPrinter: WideString;

function PrintRaw24BitBGRData(PrinterDevice: HDC; BM: TBitmap;
  DrawLeft, DrawTop, DrawWidth, DrawHeight, PrintMode: Integer): Boolean;
procedure PrintRaw24BitBGRRect(PrinterDevice: HDC; Data: Pointer;
  OffsetX, OffsetY, DataWidth, DataHeight, Left, Top, Width, Height: Integer;
  PrintMode: Integer);

function PrinterStretchDIBCaps(PrinterDevice: HDC): Boolean;
function PrinterJPEGCaps(PrinterDevice: HDC): Boolean;
function PrinterPNGCaps(PrinterDevice: HDC): Boolean;

implementation

uses
{$IFDEF WIN64}
  DebenuPDFLibraryJPEGWin64,
{$ELSE}
  DebenuPDFLibraryJPEG,
{$ENDIF}
  DebenuPDFLibraryPNG;

var
  FCanvasPrinters: TThreadList;

{ TPDFCustomPrinter }

constructor TPDFCustomPrinter.Create(const AOriginalPrinterName: WideString);
begin
  FOriginalPrinterName := AOriginalPrinterName;
  PaperSize := -1;
  PaperLength := -1;
  PaperWidth := -1;
  Copies := -1;
  PrintQuality := -1;
  Color := -1;
  Duplex := -1;
  Collate := -1;
  DefaultSource := -1;
  MediaType := -1;
  Orientation := -1;
  Fields := 0;
end;

procedure TPDFCustomPrinter.SetPrinter(APrinter: TPrinter; const DevModeString: AnsiString);
var
  ADevice, ADriver, APort: array[0..255] of Char;
  DeviceHandle: THandle;
  DevMode: PDeviceMode;
  DevModeLen: Integer;
begin
  APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  if DeviceHandle = 0 then
  begin
    APrinter.PrinterIndex := APrinter.PrinterIndex;
    APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  end;

  if DeviceHandle <> 0 then
  begin
    DevMode := GlobalLock(DeviceHandle);

    DevModeLen := DevMode^.dmSize + DevMode^.dmDriverExtra;
    if (DevModeLen <> 0) and (DevModeLen = Length(DevModeString)) then
    begin
      Move(DevModeString[1], DevMode^, DevModeLen);
    end;

    DevMode^.dmFields := DevMode^.dmFields or Fields;
    if PaperSize > 0 then DevMode^.dmPaperSize := PaperSize;
    if PaperLength > 0 then DevMode^.dmPaperLength := PaperLength;
    if PaperWidth > 0 then DevMode^.dmPaperWidth := PaperWidth;
    if Copies > 0 then DevMode^.dmCopies := Copies;
    case PrintQuality of
      1: DevMode^.dmPrintQuality := -4;
      2: DevMode^.dmPrintQuality := -3;
      3: DevMode^.dmPrintQuality := -2;
      4: DevMode^.dmPrintQuality := -1;
    else
      if (PrintQuality > 10) then
      begin
        DevMode^.dmPrintQuality := PrintQuality;
        DevMode^.dmYResolution := PrintQuality;
        DevMode^.dmFields := DevMode^.dmFields or DM_YRESOLUTION;
      end;
    end;
    if Color > 0 then DevMode^.dmColor := Color;
    if Duplex > 0 then DevMode^.dmDuplex := Duplex;
    if Collate >= 0 then DevMode^.dmCollate := Collate;
    if DefaultSource > 0 then DevMode^.dmDefaultSource := DefaultSource; 
    if MediaType > 0 then DevMode^.dmMediaType := MediaType;
    if Orientation > 0 then DevMode^.dmOrientation := Orientation;
    GlobalUnLock(DeviceHandle);
  end;
end;

function TPDFCustomPrinter.Setup(Setting, Value: Integer): Boolean;
begin
  Result := False;
  case Setting of
    1: if (Value >= 0) and (Value <= 68) then
    begin
      Result := True;
      PaperSize := Value;
      Fields := Fields or DM_PAPERSIZE;
    end;
    2: if (Value > 0) then
    begin
      Result := True;
      PaperLength := Value;
      Fields := Fields or DM_PAPERLENGTH;
    end;
    3: if (Value > 0) then
    begin
      Result := True;
      PaperWidth := Value;
      Fields := Fields or DM_PAPERWIDTH;
    end;
    4: if (Value > 0) then
    begin
      Result := True;
      Copies := Value;
      Fields := Fields or DM_COPIES;
    end;
    5: if (Value >= 1) and (Value <= 4800) then
    begin
      Result := True;
      PrintQuality := Value;
      Fields := Fields or DM_PRINTQUALITY;
    end;
    6: if (Value >= 1) and (Value <= 2) then
    begin
      Result := True;
      Color := Value;
      Fields := Fields or DM_COLOR;
    end;
    7: if (Value >= 1) and (Value <= 3) then
    begin
      Result := True;
      Duplex := Value;
      Fields := Fields or DM_DUPLEX;
    end;
    8: if (Value >= 0) and (Value <= 1) then
    begin
      Result := True;
      Collate := Value;
      Fields := Fields or DM_COLLATE;
    end;
    9: if (Value > 0) then
    begin
      Result := True;
      DefaultSource := Value;
      Fields := Fields or DM_DEFAULTSOURCE;
    end;
    10: if (Value > 0) then
    begin
      Result := True;
      MediaType := Value;
      Fields := Fields or DM_MEDIATYPE;
    end;
    11: if (Value >= 1) and (Value <= 2) then
    begin
      Result := True;
      Orientation := Value;
      Fields := Fields or DM_ORIENTATION;
    end;
  end;
end;

type
  TBinName = array[0..23] of AnsiChar;
  TBinNameArray = array[1..1000] of TBinName;
  PBinnameArray = ^TBinNameArray;
  TBinArray = array[1..1000] of Word;
  PBinArray = ^TBinArray;

function GetPrinterBins(APrinter: TPrinter): AnsiString;
var
  ADevice, ADriver, APort: array[0..255] of Char;
  SDevice, SPort: AnsiString;
  DeviceHandle: THandle;
  X: Integer;
  BinNameCount: Integer;
  BinCount: Integer;
  BinNames: PBinnameArray;
  Bins: PBinArray;
begin
  Result := '';
  APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  if DeviceHandle = 0 then
  begin
    APrinter.PrinterIndex := APrinter.PrinterIndex;
    APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  end;

  if DeviceHandle <> 0 then
  begin
    BinNameCount := {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilities(ADevice, APort, DC_BINNAMES, nil, nil);
    BinCount := {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilities(ADevice, APort, DC_BINS, nil, nil);
    if (BinNameCount = BinCount) and (BinCount > 0) then
    begin
      GetMem(BinNames, BinNameCount * SizeOf(TBinName));
      GetMem(Bins, BinCount * SizeOf(Word));
      try
        SDevice := AnsiString(ADevice);
        SPort := AnsiString(APort);
        {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilitiesA(PAnsiChar(SDevice), PAnsiChar(SPort), DC_BINNAMES, PAnsiChar(BinNames), nil);
        {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilitiesA(PAnsiChar(SDevice), PAnsiChar(SPort), DC_BINS, PAnsiChar(Bins), nil);
        for X := 1 to BinNameCount do
          Result := Result + QPLIntToStr(Bins^[X]) + ',"' +
            BinNames^[X] + '"'#13#10;
      finally
        FreeMem(BinNames);
        FreeMem(Bins);
      end;
    end;
  end;
end;

const
  QPL_DC_MEDIATYPENAMES = 34;
  QPL_DC_MEDIATYPES = 35;

type
  TMediaTypeName = array[0..63] of AnsiChar;
  TMediaTypeNameArray = array[1..1000] of TMediaTypeName;
  PMediaTypenameArray = ^TMediaTypeNameArray;
  TMediaTypeArray = array[1..1000] of DWord;
  PMediaTypeArray = ^TMediaTypeArray;

function GetPrinterMediaTypes(APrinter: TPrinter): AnsiString;
var
  ADevice, ADriver, APort: array[0..255] of Char;
  SDevice, SPort: AnsiString;
  DeviceHandle: THandle;
  X: Integer;
  MediaTypeNameCount: Integer;
  MediaTypeCount: Integer;
  MediaTypeNames: PMediaTypenameArray;
  MediaTypes: PMediaTypeArray;
begin
  Result := '';
  APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  if DeviceHandle = 0 then
  begin
    APrinter.PrinterIndex := APrinter.PrinterIndex;
    APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  end;

  if DeviceHandle <> 0 then
  begin
    MediaTypeNameCount := {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilities(ADevice, APort, QPL_DC_MEDIATYPENAMES, nil, nil);
    MediaTypeCount := {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilities(ADevice, APort, QPL_DC_MEDIATYPES, nil, nil);
    if (MediaTypeNameCount = MediaTypeCount) and (MediaTypeCount > 0) then
    begin
      GetMem(MediaTypeNames, MediaTypeNameCount * SizeOf(TMediaTypeName));
      GetMem(MediaTypes, MediaTypeCount * SizeOf(Word));
      try
        SDevice := AnsiString(ADevice);
        SPort := AnsiString(APort);
        {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilitiesA(PAnsiChar(SDevice), PAnsiChar(SPort), QPL_DC_MEDIATYPENAMES, PAnsiChar(MediaTypeNames), nil);
        {$IFNDEF QPL_NOVCL}WinSpool.{$ENDIF}DeviceCapabilitiesA(PAnsiChar(SDevice), PAnsiChar(SPort), QPL_DC_MEDIATYPES, PAnsiChar(MediaTypes), nil);
        for X := 1 to MediaTypeNameCount do
          Result := Result + QPLIntToStr(MediaTypes^[X]) + ',"' +
            MediaTypeNames^[X] + '"'#13#10;
      finally
        FreeMem(MediaTypeNames);
        FreeMem(MediaTypes);
      end;
    end;
  end;
end;

{ TQPLPrinter }

function AbortProc(Prn: HDC; Error: Integer): Bool; stdcall;
var
  l_idx: Integer;
  l_templist: TList;
  l_printer: TQPLPrinter;
begin
  Result := False;
{$IFNDEF QPL_CPP}
  l_templist := FCanvasPrinters.LockList;
  try
    for l_idx := 0 to l_templist.Count - 1 do
    begin
      l_printer := TQPLPrinter(l_templist.Items[l_idx]);
      if Assigned(l_printer) then
      begin
        if l_printer.Handle = Prn then
        begin
          Result := not l_printer.Aborted;
          Break;
        end;
      end;
    end;
  finally
    FCanvasPrinters.UnlockList;
  end;
{$ENDIF}
end;

{$IFDEF QPL_NOVCL}
type
  TDocInfoW = record
    cbSize: Integer;
    lpszDocName: PWideChar;
    lpszOutput: PWideChar;
    lpszDatatype: PWideChar;
    fwType: DWORD;
  end;

{$IFDEF QPL_OS_WINDOWS}
function StartDocW(DC: HDC; const p2: TDocInfoW): Integer; stdcall; external 'gdi32.dll';
{$ENDIF}

{$ENDIF}

{$IFNDEF QPL_OS_WINDOWS}
procedure TQPLPrinter.BeginDoc;
begin
end;
{$ELSE}
procedure TQPLPrinter.BeginDoc;
var
  DocInfo: TDocInfoW;
  ADevice, ADriver, APort: array[0..255] of Char;
  NIndex: Integer;
  ADeviceMode: THandle;
  WTitle: WideString;
  DevMode: PDeviceMode;
begin
  if (Assigned(FPrinter) and (not Assigned(FPreviewBitmap))) then
  begin
    if not FUseLocal then
    begin
      FPrinter.BeginDoc;
    end else
    begin
      GetCanvas;
      FPrinter.GetPrinter(ADevice, ADriver, APort, ADeviceMode);
      FPrinterName := '';
      NIndex := 0;
      while (NIndex < Length(ADevice)) and (Ord(ADevice[NIndex]) <> 0) do
      begin
        FPrinterName := FPrinterName + AnsiChar(Ord(ADevice[NIndex]) and $FF);
        Inc(NIndex);
      end;
      DevMode := GlobalLock(ADeviceMode);
      try
        FLocalDC := CreateDC(ADriver, ADevice, APort, DevMode);
      finally
        GlobalUnlock(ADeviceMode);
      end;
      TLocalCanvas(FCanvas).DC := FLocalDC;
      FCanvas.Handle := 0;
      FCanvas.Handle := FLocalDC;

      FCanvas.Refresh;
      TLocalCanvas(FCanvas).UpdateFont;

      WTitle := Title;
      FillChar(DocInfo, SizeOf(DocInfo), 0);
      with DocInfo do
      begin
        cbSize := SizeOf(DocInfo);
        if WTitle <> '' then
          lpszDocName := @WTitle[1];
        if FFileName <> '' then
          lpszOutput := @FFileName[1];
      end;
      SetAbortProc(FLocalDC, AbortProc);
      FPrinterJobID := StartDocW(FLocalDC, DocInfo);

      if FStartPaused then
      begin
        GetPrintJobStatus(401, FPrinterJobID, FPrinterName);
      end;

      StartPage(FLocalDC);
    end;
  end;
end;
{$ENDIF}

constructor TQPLPrinter.Create(Printer: TPrinter; const FileName: WideString;
  UseLocal: Boolean);
begin
  FFileName := FileName;
  FUseLocal := UseLocal;
  FPrinter := Printer;
  FPrinterName := '';
  FCanvas := nil;
  FLocalDC := 0;
  FStartPaused := False;
  FPreviewBitmap := nil;
  FPreviewScale := 1;
{$IFNDEF QPL_CPP}
  FCanvasPrinters.LockList;
  try
    FCanvasPrinters.Add(Self);
  finally
    FCanvasPrinters.UnlockList;
  end;
{$ENDIF}
end;

destructor TQPLPrinter.Destroy;
begin
{$IFNDEF QPL_CPP}
  FCanvasPrinters.LockList;
  try
    FCanvasPrinters.Remove(Self);
  finally
    FCanvasPrinters.UnlockList;
  end;
  if Assigned(FCanvas) then
  begin
    FCanvas.Free;
  end;
  if Assigned(FPreviewBitmap) then
  begin
    FPreviewBitmap.Free;
  end;
{$IFDEF QPL_OS_WINDOWS}
  if (FLocalDC > 0) then
  begin
    DeleteDC(FLocalDC);
  end;
{$ENDIF}
  inherited;
{$ENDIF}
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TQPLPrinter.EndDoc;
begin
end;
{$ELSE}
procedure TQPLPrinter.EndDoc;
begin
  if (Assigned(FPrinter) and (not Assigned(FPreviewBitmap))) then
  begin
    if not FUseLocal then
    begin
      FPrinter.EndDoc;
    end else
    begin
      EndPage(FLocalDC);
      if not FPrinter.Aborted then Windows.EndDoc(FLocalDC);
    end;
  end;
end;
{$ENDIF}

function TQPLPrinter.GetAborted: Boolean;
begin
  if Assigned(FPrinter) then
    Result := FPrinter.Aborted
  else
    Result := False;
end;

function TQPLPrinter.GetCanvas: TCanvas;
begin
  if Assigned(FPrinter) then
  begin
    if (Assigned(FPreviewBitmap)) then
    begin
      Result := FPreviewBitmap.Canvas;
    end else
    begin
      if not FUseLocal then
      begin
        Result := FPrinter.Canvas;
      end else
      begin
        if not Assigned(FCanvas) then
          FCanvas := TLocalCanvas.Create(FPrinter);
        Result := FCanvas;
      end;
    end;
  end else
    Result := nil;
end;

function TQPLPrinter.GetDPI: Integer;
var
{$IFDEF QPL_OS_WINDOWS}
  RealHandle: THandle;
{$ENDIF}
  hSize: Double;
  hRes: Double;
begin
  if (Assigned(FPreviewBitmap)) then
  begin
{$IFDEF QPL_OS_WINDOWS}
    if Assigned(FPrinter) then
    begin
      if not FUseLocal then
      begin
        RealHandle := FPrinter.Handle;
      end else
      begin
        RealHandle := FLocalDC;
      end;
    end else
      RealHandle := 0;

    hSize := GetDeviceCaps(RealHandle, HORZSIZE);
    hRes := GetDeviceCaps(RealHandle, HORZRES);
{$ELSE}
    hSize := 0;
    hRes := 0;
{$ENDIF}

    Result := Trunc(hRes / hSize * 25.4 * FPreviewScale);
  end else
  begin
    Result := Canvas.Font.PixelsPerInch;
  end;
end;

function TQPLPrinter.GetFullPageHeight: Integer;
begin
{$IFDEF QPL_OS_WINDOWS}
  if (Assigned(FPreviewBitmap)) then
  begin
    Result := Trunc(GetDeviceCaps(Handle, PHYSICALHEIGHT) * FPreviewScale);
  end else
  begin
    Result := GetDeviceCaps(Handle, PHYSICALHEIGHT);
  end;
{$ELSE}
  Result := PageWidth;
{$ENDIF}
end;

function TQPLPrinter.GetFullPageWidth: Integer;
begin
{$IFDEF QPL_OS_WINDOWS}
  if (Assigned(FPreviewBitmap)) then
  begin
    Result := Trunc(GetDeviceCaps(Handle, PHYSICALWIDTH) * FPreviewScale);
  end else
  begin
    Result := GetDeviceCaps(Handle, PHYSICALWIDTH);
  end;
{$ELSE}
  Result := PageHeight;
{$ENDIF}
end;

function TQPLPrinter.GetHandle: HDC;
begin
  if Assigned(FPrinter) then
  begin
    if not FUseLocal then
    begin
      Result := FPrinter.Handle;
    end else
    begin
      Result := FLocalDC;
    end;
  end else
    Result := 0;
end;

function TQPLPrinter.GetHasPreview: Boolean;
begin
  Result := Assigned(FPreviewBitmap);
end;

function TQPLPrinter.GetPageHeight: Integer;
begin
  if Assigned(FPrinter) then
  begin
    if (Assigned(FPreviewBitmap)) then
    begin
      Result := Trunc(FPrinter.PageHeight * FPreviewScale);
    end else
    begin
      Result := FPrinter.PageHeight;
    end;
  end else
    Result := 0;
end;

function TQPLPrinter.GetPageWidth: Integer;
begin
  if Assigned(FPrinter) then
  begin
    if (Assigned(FPreviewBitmap)) then
    begin
      Result := Trunc(FPrinter.PageWidth * FPreviewScale);
    end else
    begin
      Result := FPrinter.PageWidth;
    end;
  end else
    Result := 0;
end;

function TQPLPrinter.GetPrinting: Boolean;
begin
  if (Assigned(FPreviewBitmap)) then
  begin
    Result := True;
  end else
  begin
    if FUseLocal then
    begin                        /// Don't know if this Check is needed
      Result := (FLocalDC <> 0) {and (GetPrintJobStatus(303,FPrinterJobID,FPrinterName) <> 1)};
    end else
    begin
      if Assigned(FPrinter) then
        Result := FPrinter.Printing
      else
        Result := False;
    end;
  end;
end;

function TQPLPrinter.GetPrintOffsetX: Integer;
begin
{$IFDEF QPL_OS_WINDOWS}
  if (Assigned(FPreviewBitmap)) then
  begin
    Result := Trunc(GetDeviceCaps(Handle, PHYSICALOFFSETX) * FPreviewScale);
  end else
  begin
    Result := GetDeviceCaps(Handle, PHYSICALOFFSETX);
  end;
{$ELSE}
  Result := 0;
{$ENDIF}
end;

function TQPLPrinter.GetPrintOffsetY: Integer;
begin
{$IFDEF QPL_OS_WINDOWS}
  if (Assigned(FPreviewBitmap)) then
  begin
    Result := Trunc(GetDeviceCaps(Handle, PHYSICALOFFSETY) * FPreviewScale);
  end else
  begin
    Result := GetDeviceCaps(Handle, PHYSICALOFFSETY);
  end;
{$ELSE}
  Result := 0;
{$ENDIF}
end;

function TQPLPrinter.GetTitle: string;
begin
  if Assigned(FPrinter) then
    Result := FPrinter.Title
  else
    Result := '';
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TQPLPrinter.NewPage;
begin
end;
{$ELSE}
procedure TQPLPrinter.NewPage;
begin
  if Assigned(FPrinter) then
  begin
    if not FUseLocal then
    begin
      FPrinter.NewPage;
    end else
    begin
      EndPage(FLocalDC);
      StartPage(FLocalDC);
      FCanvas.Refresh;
    end;
  end;
end;
{$ENDIF}

function TQPLPrinter.SavePreviewToString: AnsiString;
var
  TempStream: TMemoryStream;
begin
  Result := '';
  if (Assigned(FPreviewBitmap)) then
  begin
    TempStream := TMemoryStream.Create;
    try
      FPreviewBitmap.Canvas.Lock;
      try
        FPreviewBitmap.SaveToStream(TempStream);
      finally
        FPreviewBitmap.Canvas.Unlock;
      end;
      TempStream.Seek(0, soFromBeginning);
      if (TempStream.Size > 0) then
      begin
        SetLength(Result, TempStream.Size);
        TempStream.Read(Result[1], Length(Result));
      end;
    finally
      TempStream.Free;
    end;
  end;
end;

procedure TQPLPrinter.SetStartPaused(StartPaused: Boolean);
begin
  FStartPaused := StartPaused;
end;

procedure TQPLPrinter.SetTitle(const NewTitle: string);
begin
  if Assigned(FPrinter) then
    FPrinter.Title := NewTitle;
end;

procedure TQPLPrinter.SetupPreview(MaxDimension: Integer);
var
  PreviewWidth: Integer;
  PreviewHeight: Integer;
begin
  if (Assigned(FPreviewBitmap)) then
  begin
    FPreviewBitmap.Free;
    FPreviewBitmap := nil;
  end;

  if (FullPageWidth > FullPageHeight) then
  begin
    FPreviewScale := (MaxDimension / FullPageWidth);
  end else
  begin
    FPreviewScale := (MaxDimension / FullPageHeight);
  end;

  PreviewWidth := Trunc(FullPageWidth * FPreviewScale);
  PreviewHeight := Trunc(FullPageHeight * FPreviewScale);

  FPreviewBitmap := TBitmap.Create;
  FPreviewBitmap.PixelFormat := pf24bit;
  FPreviewBitmap.Width := PreviewWidth;
  FPreviewBitmap.Height := PreviewHeight;
end;

{ TLocalCanvas }

procedure TLocalCanvas.Changing;
begin
  inherited Changing;
  UpdateFont;
end;

constructor TLocalCanvas.Create(APrinter: TPrinter);
begin
  inherited Create;
  FPrinter := APrinter;
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TLocalCanvas.CreateHandle;
begin
end;
{$ELSE}
procedure TLocalCanvas.CreateHandle;
var
  ADevice, ADriver, APort: array[0..255] of Char;
  ADeviceMode: THandle;
  DevMode: PDeviceMode;
begin
  FPrinter.GetPrinter(ADevice, ADriver, APort, ADeviceMode);
  DevMode := GlobalLock(ADeviceMode);
  try
    Handle := CreateIC(ADriver, ADevice, APort, DevMode);
  finally
    GlobalUnlock(ADeviceMode);
  end;
  UpdateFont;
end;
{$ENDIF}

destructor TLocalCanvas.Destroy;
begin
  
  inherited;
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TLocalCanvas.UpdateFont;
begin
end;
{$ELSE}
procedure TLocalCanvas.UpdateFont;
var
  FontSize: Integer;
begin
  if GetDeviceCaps(DC, LOGPIXELSY) <> Font.PixelsPerInch then
  begin
    FontSize := Font.Size;
    Font.PixelsPerInch := GetDeviceCaps(DC, LOGPIXELSY);
    Font.Size := FontSize;
  end;
end;
{$ENDIF}

const
  QPL_JOB_STATUS_COMPLETE = $1000;
  QPL_JOB_STATUS_RETAINED = $2000;

{$IFNDEF QPL_OS_WINDOWS}
type
  PSecurityDescriptor = ^TSecurityDescriptor;
  TSecurityDescriptor = record
    Revision: Integer;
  end;
{$ENDIF}

{$IFDEF QPL_NOVCL}
type
  PPrinterDefaultsA = ^TPrinterDefaultsA;
  TPrinterDefaultsA = record
    pDatatype: PAnsiChar;
    pDevMode: PDeviceModeA;
    DesiredAccess: ACCESS_MASK;
  end;

  PJobInfo1A = ^TJobInfo1A;
  TJobInfo1A = record
   JobId: DWORD;
   pPrinterName: PAnsiChar;
   pMachineName: PAnsiChar;
   pUserName: PAnsiChar;
   pDocument: PAnsiChar;
   pDatatype: PAnsiChar;
   pStatus: PAnsiChar;
   Status: DWORD;
   Priority: DWORD;
   Position: DWORD;
   TotalPages: DWORD;
   PagesPrinted: DWORD;
   Submitted: TSystemTime;
  end;

  PPrinterInfo2W = ^TPrinterInfo2W;
  TPrinterInfo2W = record
    pServerName: PAnsiChar;
    pPrinterName: PAnsiChar;
    pShareName: PAnsiChar;
    pPortName: PAnsiChar;
    pDriverName: PAnsiChar;
    pComment: PAnsiChar;
    pLocation: PAnsiChar;
    pDevMode: PDeviceModeA;
    pSepFile: PAnsiChar;
    pPrintProcessor: PAnsiChar;
    pDatatype: PAnsiChar;
    pParameters: PAnsiChar;
    pSecurityDescriptor: PSecurityDescriptor;
    Attributes: DWORD;
    Priority: DWORD;
    DefaultPriority: DWORD;
    StartTime: DWORD;
    UntilTime: DWORD;
    Status: DWORD;
    cJobs: DWORD;
    AveragePPM: DWORD;
  end;

{$IFDEF QPL_OS_WINDOWS}
function OpenPrinterA(pPrinterName: PAnsiChar; var phPrinter: THandle; pDefault: PPrinterDefaultsA): BOOL; stdcall; external 'winspool.drv';
{$ENDIF}

{$ENDIF}

{$IFNDEF QPL_OS_WINDOWS}
function GetPrintJobStatus(StatusCode, JobID: Integer; const PrinterName: AnsiString): Integer;
begin
  Result := 0;
end;
{$ELSE}
function GetPrintJobStatus(StatusCode, JobID: Integer; const PrinterName: AnsiString): Integer;
var
{$IFDEF QPL_XE2_HIGHER}
  PrinterHandle: NativeUInt;
{$ELSE}
  PrinterHandle: Cardinal;
{$ENDIF}
  PrinterDefaults: TPrinterDefaultsA;
  Buffer: array of Byte;
  BoolResult: Integer;
  BytesNeeded: Cardinal;
  JobInfo: PJobInfo1A;
  DataType: AnsiString;

  function CheckMask(Value, Mask: Cardinal): Integer;
  begin
    if Value and Mask = Mask then Result := 1 else Result := 0;
  end;

begin
  Result := 0;
  if Length(PrinterName) > 0 then
  begin
    PrinterDefaults.pDatatype := nil;
    PrinterDefaults.pDevMode := nil;
    PrinterDefaults.DesiredAccess := PRINTER_ACCESS_USE;
    BoolResult := Integer(OpenPrinterA(@PrinterName[1], PrinterHandle, @PrinterDefaults));
    if BoolResult > 0 then
    begin
      BytesNeeded := 0;
      BoolResult := Integer(GetJobA(PrinterHandle, JobID, 1, nil, 0, @BytesNeeded));
      if (BoolResult = 0) and (BytesNeeded > 0) then
      begin
        SetLength(Buffer, BytesNeeded);
        BoolResult := Integer(GetJobA(PrinterHandle, JobID, 1, @Buffer[0],
          Length(Buffer), @BytesNeeded));
        if (BoolResult > 0) then
        begin
          JobInfo := @Buffer[0];
          case StatusCode of
            200: Result := 1;
            201: Result := JobInfo^.JobId;
            202: Result := JobInfo^.Priority;
            203: Result := JobInfo^.Position;
            204: Result := JobInfo^.TotalPages;
            205: Result := JobInfo^.PagesPrinted;
            206: Result := QPLMillisecondsSinceSystemTime(JobInfo^.Submitted, True);
            207:
            begin
              DataType := JobInfo^.pDatatype;
              DataType := QPLUpperCase(DataType);

              if (Result = 0) and (QPLPos('RAW', DataType) > 0) then Result := 1;
              if (Result = 0) and (QPLPos('EMF', DataType) > 0) then Result := 2;
              if (Result = 0) and (QPLPos('TEXT', DataType) > 0) then Result := 3;
              if (Result = 0) and (QPLPos('XPS', DataType) > 0) then Result := 4;
            end;
            300: Result := JobInfo^.Status;
            301: Result := CheckMask(JobInfo^.Status, JOB_STATUS_PAUSED);
            302: Result := CheckMask(JobInfo^.Status, JOB_STATUS_ERROR);
            303: Result := CheckMask(JobInfo^.Status, JOB_STATUS_DELETING);
            304: Result := CheckMask(JobInfo^.Status, JOB_STATUS_SPOOLING);
            305: Result := CheckMask(JobInfo^.Status, JOB_STATUS_PRINTING);
            306: Result := CheckMask(JobInfo^.Status, JOB_STATUS_OFFLINE);
            307: Result := CheckMask(JobInfo^.Status, JOB_STATUS_PAPEROUT);
            308: Result := CheckMask(JobInfo^.Status, JOB_STATUS_PRINTED);
            309: Result := CheckMask(JobInfo^.Status, JOB_STATUS_DELETED);
            310: Result := CheckMask(JobInfo^.Status, JOB_STATUS_BLOCKED_DEVQ);
            311: Result := CheckMask(JobInfo^.Status, JOB_STATUS_USER_INTERVENTION);
            312: Result := CheckMask(JobInfo^.Status, JOB_STATUS_RESTART);
            313: Result := CheckMask(JobInfo^.Status, QPL_JOB_STATUS_COMPLETE);
            314: Result := CheckMask(JobInfo^.Status, QPL_JOB_STATUS_RETAINED);

            401:
            begin
              SetJobA(PrinterHandle, JobID, 0, nil, JOB_CONTROL_PAUSE);
              Result := 1;
            end;
            402:
            begin
              SetJobA(PrinterHandle, JobID, 0, nil, JOB_CONTROL_RESUME);
              Result := 1;
            end;
            403:
            begin
              SetJobA(PrinterHandle, JobID, 0, nil, JOB_CONTROL_DELETE);
              Result := 1;
            end;
          end;
        end;
      end;
    end;
  end;
end;
{$ENDIF}

function GetDevModeToString(APrinter: TPrinter): AnsiString;
var
  ADevice, ADriver, APort: array[0..255] of Char;
  DeviceHandle: THandle;
  DevMode: PDeviceMode;
  DevModeLen: Integer;
begin
  APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  if DeviceHandle = 0 then
  begin
    APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  end;

  Result := '';
  if DeviceHandle <> 0 then
  begin
    DevMode := GlobalLock(DeviceHandle);
    if (SizeOf(DevMode^) = DevMode^.dmSize) then
    begin
      DevModeLen := DevMode^.dmSize + DevMode^.dmDriverExtra;
      SetLength(Result, DevModeLen);
      if (DevModeLen > 0) then
      begin
        Move(DevMode^, Result[1], DevModeLen);
      end;
    end;
    GlobalUnlock(DeviceHandle);
  end;
end;

procedure SetDevModeFromString(APrinter: TPrinter; const DevModeString: AnsiString);
var
  ADevice, ADriver, APort: array[0..255] of Char;
  DeviceHandle: THandle;
  DevMode: PDeviceMode;
  DevModeLen: Integer;
begin
  APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  if DeviceHandle = 0 then
  begin
    APrinter.GetPrinter(ADevice, ADriver, APort, DeviceHandle);
  end;

  if DeviceHandle <> 0 then
  begin
    DevMode := GlobalLock(DeviceHandle);
    DevModeLen := DevMode^.dmSize + DevMode^.dmDriverExtra;
    if (DevModeLen = Length(DevModeString)) then
    begin
      Move(DevModeString[1], DevMode^, DevModeLen);
    end;
    GlobalUnlock(DeviceHandle);
  end;
end;

{$IFDEF QPL_NOVCL}
{$IFDEF QPL_OS_WINDOWS}
function EnumPrintersW(Flags: DWORD; Name: PWideChar; Level: DWORD;
  pPrinterEnum: Pointer; cbBuf: DWORD; var pcbNeeded, pcReturned: DWORD): BOOL; stdcall; external 'winspool.drv';
{$ENDIF}
{$ENDIF}

{$IFNDEF QPL_OS_WINDOWS}
procedure GetPrinterList(List: TQuickPDFStringList);
begin
end;
{$ELSE}
procedure GetPrinterList(List: TQuickPDFStringList);
var
  I: Integer;
  PPrinterEnumArray, PLocator: PPrinterInfo2W;
  ArraySize, BufferSize: Cardinal;
  strBuffer: WideString;
begin
  ArraySize := 0;
  BufferSize := 0;
  EnumPrintersW(PRINTER_ENUM_LOCAL or PRINTER_ENUM_CONNECTIONS, nil, 2, nil, 0, BufferSize, ArraySize);
  PPrinterEnumArray := AllocMem(BufferSize);
  try
    if EnumPrintersW(PRINTER_ENUM_LOCAL or PRINTER_ENUM_CONNECTIONS, nil, 2, PPrinterEnumArray, BufferSize, BufferSize, ArraySize) then
    begin
      PLocator := PPrinterEnumArray;
      if ArraySize > 0 then
      begin
        for I := 0 to ArraySize - 1 do
        begin
          strBuffer := WideString(PLocator^.pPrinterName);
          List.Add(QPLUTF8Encode(strBuffer));
          Inc(PLocator);
        end;
      end;
    end;
  finally
    FreeMem(PPrinterEnumArray);
  end;
end;
{$ENDIF}

{$IFDEF QPL_OS_WINDOWS}
function GetDefaultPrinterW(Buffer: PWideChar; var BufferSize: DWORD): BOOL; stdcall; external 'winspool.drv';
{$ENDIF}

{$IFNDEF QPL_OS_WINDOWS}
function GetDefaultPrinter: WideString;
begin
  Result := '';
end;
{$ELSE}
function GetDefaultPrinter: WideString;
var
  BufferSize: Cardinal;
begin
  BufferSize := 2048;
  SetLength(Result, BufferSize);
  if (GetDefaultPrinterW(@Result[1], BufferSize)) then
  begin
    if (BufferSize >= 1) then
    begin
      SetLength(Result, BufferSize - 1);
    end;
  end else
  begin
    Result := '';
  end;
end;
{$ENDIF}

{$IFNDEF QPL_OS_WINDOWS}
function PrintRaw24BitBGRData(PrinterDevice: HDC; BM: TBitmap;
  DrawLeft, DrawTop, DrawWidth, DrawHeight, PrintMode: Integer): Boolean;
begin
  Result := False;
end;

procedure PrintRaw24BitBGRRect(PrinterDevice: HDC; Data: Pointer;
  OffsetX, OffsetY, DataWidth, DataHeight, Left, Top, Width, Height: Integer;
  PrintMode: Integer);
begin

end;

function PrinterStretchDIBCaps(PrinterDevice: HDC): Boolean;
begin
  Result := False;
end;

function PrinterJPEGCaps(PrinterDevice: HDC): Boolean;
begin
  Result := False;
end;

function PrinterPNGCaps(PrinterDevice: HDC): Boolean;
begin
  Result := False;
end;
{$ELSE}
function PrintRaw24BitBGRData(PrinterDevice: HDC; BM: TBitmap;
  DrawLeft, DrawTop, DrawWidth, DrawHeight, PrintMode: Integer): Boolean;
var
  UseJPEG: Boolean;
  UsePNG: Boolean;
  BitsInfo: TBitmapInfo;
  DrawResult: Integer;
  TempJPEG: TPDFJPEGImage;
  TempPNG: TPNGWriter;
  MS: TMemoryStream;
  JPEGData: array of Byte;
  PNGData: array of Byte;
begin
  try
    BM.Canvas.Lock;

    UseJPEG := PrinterJPEGCaps(PrinterDevice) and (PrintMode < 1);
    if (not UseJPEG) then
    begin
      UsePNG := PrinterPNGCaps(PrinterDevice) and (PrintMode < 2);
    end else
    begin
      UsePNG := False;
    end;

    DrawResult := Integer(GDI_ERROR);

    if (UseJPEG) then
    begin
      FillChar(BitsInfo, SizeOf(BitsInfo), 0);
      BitsInfo.bmiHeader.biSize := SizeOf(BitsInfo);
      BitsInfo.bmiHeader.biWidth := BM.Width;
      BitsInfo.bmiHeader.biHeight := BM.Height;
      BitsInfo.bmiHeader.biPlanes := 1;
      BitsInfo.bmiHeader.biBitCount := 0;
      BitsInfo.bmiHeader.biCompression := 4; // BI_JPEG;

      TempJPEG := TPDFJPEGImage.Create;
      try
{$IFNDEF QPL_NOVCL}
        TempJPEG.Assign(BM);
{$ENDIF}
        MS := TMemoryStream.Create;
        try
          TempJPEG.SaveToStream(MS);
          SetLength(JPEGData, MS.Size);
          BitsInfo.bmiHeader.biSizeImage := MS.Size;
          MS.Seek(0, soFromBeginning);
          MS.Read(JPEGData[0], Length(JPEGData));
        finally
          MS.Free;
        end;
      finally
        TempJPEG.Free;
      end;

      DrawResult := StretchDIBits(PrinterDevice,
        DrawLeft, DrawTop, DrawWidth, DrawHeight,
        0, 0, BM.Width, BM.Height,
        @JPEGData[0], BitsInfo, DIB_RGB_COLORS, SRCCOPY);
    end else
    if (UsePNG) then
    begin
      FillChar(BitsInfo, SizeOf(BitsInfo), 0);
      BitsInfo.bmiHeader.biSize := SizeOf(BitsInfo);
      BitsInfo.bmiHeader.biWidth := BM.Width;
      BitsInfo.bmiHeader.biHeight := BM.Height;
      BitsInfo.bmiHeader.biPlanes := 1;
      BitsInfo.bmiHeader.biBitCount := 0;
      BitsInfo.bmiHeader.biCompression := 5; // BI_PNG;

      TempPNG := TPNGWriter.Create(BM);
      try
        MS := TMemoryStream.Create;
        try
          TempPNG.SaveToStream(MS);
          SetLength(PNGData, MS.Size);
          BitsInfo.bmiHeader.biSizeImage := MS.Size;
          MS.Seek(0, soFromBeginning);
          MS.Read(PNGData[0], Length(PNGData));
        finally
          MS.Free;
        end;
      finally
        TempPNG.Free;
      end;

      DrawResult := StretchDIBits(PrinterDevice,
        DrawLeft, DrawTop, DrawWidth, DrawHeight,
        0, 0, BM.Width, BM.Height,
        @PNGData[0], BitsInfo, DIB_RGB_COLORS, SRCCOPY);
    end;

    Result := (UseJPEG or UsePNG) and (DrawResult <> Integer(GDI_ERROR));

    {if not Result then
    begin
      // problem with AQUO LIFE SPRING 2007.pdf
      if (DrawWidth = BM.Width) and (DrawHeight = BM.Height) then
      begin
        BitBlt(PrinterDevice, DrawLeft, DrawTop,
          DrawWidth, DrawHeight, BM.Canvas.Handle, 0, 0, SRCCOPY);
      end else
      begin
        FillChar(BitsInfo, SizeOf(BitsInfo), 0);
        BitsInfo.bmiHeader.biSize := SizeOf(BitsInfo);
        BitsInfo.bmiHeader.biWidth := BM.Width;
        BitsInfo.bmiHeader.biHeight := BM.Height;
        BitsInfo.bmiHeader.biPlanes := 1;
        BitsInfo.bmiHeader.biBitCount := 0;
        BitsInfo.bmiHeader.biCompression := BI_RGB;

        DrawResult := StretchDIBits(PrinterDevice,
          DrawLeft, DrawTop, DrawWidth, DrawHeight,
          0, 0, BM.Width, BM.Height,
          BM.Scanline[BM.Height-1], BitsInfo, DIB_RGB_COLORS, SRCCOPY);
      end;
    end;   }
  finally
     BM.Canvas.Unlock;
  end;
end;

procedure PrintRaw24BitBGRRect(PrinterDevice: HDC; Data: Pointer;
  OffsetX, OffsetY, DataWidth, DataHeight, Left, Top, Width, Height: Integer;
  PrintMode: Integer);
var
  StripBitmap: TBitmap;
  SourceRow: Integer;
  StripRow: Integer;
  UseJPEG: Boolean;
  UsePNG: Boolean;
  BitsInfo: TBitmapInfo;
  DrawResult: Integer;
  TempJPEG: TPDFJPEGImage;
  TempPNG: TPNGWriter;
  MS: TMemoryStream;
  JPEGData: array of Byte;
  PNGData: array of Byte;
begin
  StripBitmap := TBitmap.Create;
  try
    StripBitmap.PixelFormat := pf24bit;
    StripBitmap.Width := Width;
    StripBitmap.Height := Height;
    StripBitmap.Canvas.Lock;

    UseJPEG := PrinterJPEGCaps(PrinterDevice) and (PrintMode < 1);
    if (not UseJPEG) then
    begin
      UsePNG := PrinterPNGCaps(PrinterDevice) and (PrintMode < 2);
    end else
    begin
      UsePNG := False;
    end;

    Inc(PByte(Data), (DataHeight - Top - 1) * (DataWidth*3) + Left * 3);

    StripRow := 0;
    for SourceRow := Height - 1 downto 0 do
    begin
      Move(Data^, StripBitmap.ScanLine[StripRow]^, Width * 3);
      Inc(StripRow);
      Dec(PByte(Data), DataWidth*3);
    end;

    DrawResult := Integer(GDI_ERROR);
    if (UseJPEG) then
    begin
      FillChar(BitsInfo, SizeOf(BitsInfo), 0);
      BitsInfo.bmiHeader.biSize := SizeOf(BitsInfo);
      BitsInfo.bmiHeader.biWidth := Width;
      BitsInfo.bmiHeader.biHeight := StripBitmap.Height;
      BitsInfo.bmiHeader.biPlanes := 1;
      BitsInfo.bmiHeader.biBitCount := 0;
      BitsInfo.bmiHeader.biCompression := 4; // BI_JPEG;

      TempJPEG := TPDFJPEGImage.Create;
      try
{$IFNDEF QPL_NOVCL}
        TempJPEG.Assign(StripBitmap);
{$ENDIF}
        MS := TMemoryStream.Create;
        try
          TempJPEG.SaveToStream(MS);
          SetLength(JPEGData, MS.Size);
          BitsInfo.bmiHeader.biSizeImage := MS.Size;
          MS.Seek(0, soFromBeginning);
          MS.Read(JPEGData[0], Length(JPEGData));
        finally
          MS.Free;
        end;
      finally
        TempJPEG.Free;
      end;

      DrawResult := StretchDIBits(PrinterDevice,
        Left + OffsetX, Top + OffsetY, Width, StripBitmap.Height,
        0, 0, Width, StripBitmap.Height,
        @JPEGData[0], BitsInfo, DIB_RGB_COLORS, SRCCOPY);
    end else
    if (UsePNG) then
    begin
      FillChar(BitsInfo, SizeOf(BitsInfo), 0);
      BitsInfo.bmiHeader.biSize := SizeOf(BitsInfo);
      BitsInfo.bmiHeader.biWidth := Width;
      BitsInfo.bmiHeader.biHeight := StripBitmap.Height;
      BitsInfo.bmiHeader.biPlanes := 1;
      BitsInfo.bmiHeader.biBitCount := 0;
      BitsInfo.bmiHeader.biCompression := 5; // BI_PNG;

      TempPNG := TPNGWriter.Create(StripBitmap);
      try
        MS := TMemoryStream.Create;
        try
          TempPNG.SaveToStream(MS);
          SetLength(PNGData, MS.Size);
          BitsInfo.bmiHeader.biSizeImage := MS.Size;
          MS.Seek(0, soFromBeginning);
          MS.Read(PNGData[0], Length(PNGData));
        finally
          MS.Free;
        end;
      finally
        TempPNG.Free;
      end;

      DrawResult := StretchDIBits(PrinterDevice,
        Left + OffsetX, Top + OffsetY, Width, StripBitmap.Height,
        0, 0, Width, StripBitmap.Height,
        @PNGData[0], BitsInfo, DIB_RGB_COLORS, SRCCOPY);
    end;

    if (((not UseJPEG) and (not UsePNG)) or (DrawResult = Integer(GDI_ERROR))) then
    begin
      BitBlt(PrinterDevice, Left + OffsetX, Top + OffsetY,
        Width, Height, StripBitmap.Canvas.Handle, 0, 0, SRCCOPY);
    end;

    StripBitmap.Canvas.Unlock;
  finally
    StripBitmap.Free;
  end;
end;

function PrinterStretchDIBCaps(PrinterDevice: HDC): Boolean;
begin
  Result := GetDeviceCaps(PrinterDevice, RASTERCAPS) and RC_STRETCHDIB = RC_STRETCHDIB;
end;

function PrinterJPEGCaps(PrinterDevice: HDC): Boolean;
var
  ul: Integer;
begin
  ul := $1017; // CHECKJPEGFORMAT;
  Result := ExtEscape(PrinterDevice, QUERYESCSUPPORT, sizeof(ul), @ul, 0, nil) > 0;
end;

function PrinterPNGCaps(PrinterDevice: HDC): Boolean;
var
  ul: Integer;
begin
  ul := $1018; // CHECKPNGFORMAT;
  Result := ExtEscape(PrinterDevice, QUERYESCSUPPORT, sizeof(ul), @ul, 0, nil) > 0;
end;
{$ENDIF}


initialization
  FCanvasPrinters := TThreadList.Create;
finalization
  FCanvasPrinters.Free;
  FCanvasPrinters := nil;
end.
