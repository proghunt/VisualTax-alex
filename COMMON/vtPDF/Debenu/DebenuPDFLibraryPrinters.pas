{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryPrinters.pas                           }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryPrinters;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics;
{$ELSE}
  Graphics;
{$ENDIF}

type
  TPrinter = class
  private
    FPrinterIndex: Integer;
    FAborted: Boolean;
    FCanvas: TCanvas;
    FHandle: HDC;
    FPageWidth: Integer;
    FPageHeight: Integer;
    FTitle: string;
    FPrinters: TStrings;
    FPrinting: Boolean;
  public
    procedure Abort;
    procedure BeginDoc;
    procedure EndDoc;
    procedure NewPage;
    procedure Refresh;
    procedure GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
    procedure SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
    property Aborted: Boolean read FAborted;
    property Canvas: TCanvas read FCanvas;
    property Handle: HDC read FHandle;
    property PrinterIndex: Integer read FPrinterIndex write FPrinterIndex;
    property PageHeight: Integer read FPageHeight;
    property PageWidth: Integer read FPageWidth;
    property Title: string read FTitle write FTitle;
    property Printers: TStrings read FPrinters;
    property Printing: Boolean read FPrinting;
  end;

{$IFNDEF QPL_OS_WINDOWS}
  PDeviceMode = ^TDeviceModeW;
  PDeviceModeA = ^TDeviceModeA;
  PDeviceModeW = ^TDeviceModeW;

  TDeviceModeA = record
    dmDeviceName: array[0..CCHDEVICENAME - 1] of AnsiChar;
    dmSpecVersion: Word;
    dmDriverVersion: Word;
    dmSize: Word;
    dmDriverExtra: Word;
    dmFields: DWORD;
    dmOrientation: SHORT;
    dmPaperSize: SHORT;
    dmPaperLength: SHORT;
    dmPaperWidth: SHORT;
    dmScale: SHORT;
    dmCopies: SHORT;
    dmDefaultSource: SHORT;
    dmPrintQuality: SHORT;
    dmColor: SHORT;
    dmDuplex: SHORT;
    dmYResolution: SHORT;
    dmTTOption: SHORT;
    dmCollate: SHORT;
    dmFormName: array[0..CCHFORMNAME - 1] of AnsiChar;
    dmLogPixels: Word;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDisplayFlags: DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmICCManufacturer: DWORD;
    dmICCModel: DWORD;
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
  end;

  TDeviceModeW = record
    dmDeviceName: array[0..CCHDEVICENAME - 1] of WideChar;
    dmSpecVersion: Word;
    dmDriverVersion: Word;
    dmSize: Word;
    dmDriverExtra: Word;
    dmFields: DWORD;
    dmOrientation: SHORT;
    dmPaperSize: SHORT;
    dmPaperLength: SHORT;
    dmPaperWidth: SHORT;
    dmScale: SHORT;
    dmCopies: SHORT;
    dmDefaultSource: SHORT;
    dmPrintQuality: SHORT;
    dmColor: SHORT;
    dmDuplex: SHORT;
    dmYResolution: SHORT;
    dmTTOption: SHORT;
    dmCollate: SHORT;
    dmFormName: array[0..CCHFORMNAME - 1] of WideChar;
    dmLogPixels: Word;
    dmBitsPerPel: DWORD;
    dmPelsWidth: DWORD;
    dmPelsHeight: DWORD;
    dmDisplayFlags: DWORD;
    dmDisplayFrequency: DWORD;
    dmICMMethod: DWORD;
    dmICMIntent: DWORD;
    dmMediaType: DWORD;
    dmDitherType: DWORD;
    dmICCManufacturer: DWORD;
    dmICCModel: DWORD;
    dmPanningWidth: DWORD;
    dmPanningHeight: DWORD;
  end;

function DeviceCapabilities(pDevice, pPort: PChar; fwCapability: Word;
  pOutput: PChar; DevMode: PDeviceMode): Integer; stdcall;
function DeviceCapabilitiesA(pDevice, pPort: PAnsiChar; fwCapability: Word;
  pOutput: PAnsiChar; DevMode: PDeviceModeA): Integer; stdcall;
function DeviceCapabilitiesW(pDevice, pPort: PWideChar; fwCapability: Word;
  pOutput: PWideChar; DevMode: PDeviceModeW): Integer; stdcall;
{$ELSE}
function DeviceCapabilities(pDevice, pPort: PChar; fwCapability: Word;
  pOutput: PChar; DevMode: PDeviceMode): Integer; stdcall; external 'winspool.drv' name 'DeviceCapabilitiesW';
function DeviceCapabilitiesA(pDevice, pPort: PAnsiChar; fwCapability: Word;
  pOutput: PAnsiChar; DevMode: PDeviceModeA): Integer; stdcall; external 'winspool.drv';
function DeviceCapabilitiesW(pDevice, pPort: PWideChar; fwCapability: Word;
  pOutput: PWideChar; DevMode: PDeviceModeW): Integer; stdcall; external 'winspool.drv';
{$ENDIF}

var
  Printer: TPrinter;

implementation

{$IFNDEF QPL_OS_WINDOWS}
function DeviceCapabilities(pDevice, pPort: PChar; fwCapability: Word;
  pOutput: PChar; DevMode: PDeviceMode): Integer; stdcall;
begin
  Result := 0;
end;

function DeviceCapabilitiesA(pDevice, pPort: PAnsiChar; fwCapability: Word;
  pOutput: PAnsiChar; DevMode: PDeviceModeA): Integer; stdcall;
begin
  Result := 0;
end;

function DeviceCapabilitiesW(pDevice, pPort: PWideChar; fwCapability: Word;
  pOutput: PWideChar; DevMode: PDeviceModeW): Integer; stdcall;
begin
  Result := 0;
end;
{$ENDIF}

{ TPrinter }

procedure TPrinter.Abort;
begin

end;

procedure TPrinter.BeginDoc;
begin

end;

procedure TPrinter.EndDoc;
begin

end;

procedure TPrinter.GetPrinter(ADevice, ADriver, APort: PChar;
  var ADeviceMode: THandle);
begin

end;

procedure TPrinter.NewPage;
begin

end;

procedure TPrinter.Refresh;
begin

end;

procedure TPrinter.SetPrinter(ADevice, ADriver, APort: PChar;
  ADeviceMode: THandle);
begin

end;

end.
