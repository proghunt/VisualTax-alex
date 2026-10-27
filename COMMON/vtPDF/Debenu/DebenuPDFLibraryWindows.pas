{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryWindows.pas                            }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryWindows;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Types, SysUtils;

type
{$IFDEF QPL_CPP}
  TPoint = record
    X, Y: Integer;
  end;

  TRect = record
  case Integer of
    0: (Left, Top, Right, Bottom: Longint);
    1: (TopLeft, BottomRight: TPoint);
  end;
{$ENDIF}
  HPALETTE = type LongWord;
  HBITMAP = type LongWord;
  HDC = THandle;
  BOOL = LongBool;
  ULONGLONG = UInt64;
  SHORT = Smallint;
  PWChar = PWideChar;
  FARPROC = Pointer;
  UINT = LongWord;
  ACCESS_MASK = DWORD;
  LPCSTR = PAnsiChar;
  LPWSTR = PWideChar;

const
  DEFAULT_CHARSET = 1;
  TIME_ZONE_ID_UNKNOWN  = 0;
  TIME_ZONE_ID_STANDARD = 1;
  TIME_ZONE_ID_DAYLIGHT = 2;
  GENERIC_READ = DWORD($80000000);
  GENERIC_WRITE = $40000000;
  FILE_SHARE_READ = $00000001;
  FILE_SHARE_WRITE = $00000002;
  OPEN_EXISTING = 3;
  FILE_ATTRIBUTE_NORMAL = $00000080;
  CREATE_ALWAYS = 2;
  INVALID_HANDLE_VALUE = DWORD(-1);
  FILE_ATTRIBUTE_DIRECTORY = $00000010;
  PC_EXPLICIT = 2;

  OEM_CHARSET = 255;
  THAI_CHARSET = 222;
  SHIFTJIS_CHARSET = $80;
  GB2312_CHARSET = 134;
  HANGEUL_CHARSET = 129;
  CHINESEBIG5_CHARSET = 136;
  EASTEUROPE_CHARSET = 238;
  RUSSIAN_CHARSET = 204;
  ANSI_CHARSET = 0;
  SYMBOL_CHARSET = 2;
  GREEK_CHARSET = 161;
  TURKISH_CHARSET = 162;
  HEBREW_CHARSET = 177;
  ARABIC_CHARSET = 178;
  BALTIC_CHARSET = 186;
  VIETNAMESE_CHARSET = 163;
  JOHAB_CHARSET = 130;

  TMPF_FIXED_PITCH = 1;

  CCHDEVICENAME = 32;
  CCHFORMNAME = 32;
  DM_ORIENTATION = 1;
  DM_PAPERSIZE = 2;
  DM_PAPERLENGTH = 4;
  DM_PAPERWIDTH = 8;
  DM_COPIES = $100;
  DM_DEFAULTSOURCE = $200;
  DM_PRINTQUALITY = $400;
  DM_COLOR = $800;
  DM_DUPLEX = $1000;
  DM_COLLATE = $8000;
  DM_MEDIATYPE = $8000000;
  DM_YRESOLUTION = $2000;
  DC_BINS = 6;
  DC_BINNAMES = 12;
  LOGPIXELSX = 88;
  LOGPIXELSY = 90;

type
  PALETTEENTRY = packed record
    peRed: Byte;
    peGreen: Byte;
    peBlue: Byte;
    peFlags: Byte;
  end;

  TFixed = packed record
    fract: Word;
    value: SHORT;
  end;

  TPointFX = packed record
    x: TFixed;
    y: TFixed;
  end;

{$IFDEF QPL_OS_MAC}
const
  RT_RCDATA = PChar(10);
  DLL_PROCESS_ATTACH = 1;
  DLL_PROCESS_DETACH = 0;

type
  PDWORD = ^DWORD;
  DWORD = LongWord;

  TSystemTime = record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;
{$ENDIF}

{$IFDEF QPL_CPP}
const
  RT_RCDATA = PChar(10);
  DLL_PROCESS_ATTACH = 1;
  DLL_PROCESS_DETACH = 0;

type
  PDWORD = ^DWORD;
  DWORD = LongWord;

  TSystemTime = record
    wYear: Word;
    wMonth: Word;
    wDayOfWeek: Word;
    wDay: Word;
    wHour: Word;
    wMinute: Word;
    wSecond: Word;
    wMilliseconds: Word;
  end;
{$ENDIF}

  TTimeZoneInformation = record
    Bias: Longint;
    StandardName: array[0..31] of WideChar;
    StandardDate: TSystemTime;
    StandardBias: Longint;
    DaylightName: array[0..31] of WideChar;
    DaylightDate: TSystemTime;
    DaylightBias: Longint;
  end;

  PSecurityAttributes = ^TSecurityAttributes;
  TSecurityAttributes = record
    nLength: DWORD;
    lpSecurityDescriptor: Pointer;
    bInheritHandle: LongBool;
  end;

  TFileTime = record
    dwLowDateTime: DWORD;
    dwHighDateTime: DWORD;
  end;

  TBitmapInfoHeader = packed record
    biSize: DWORD;
    biWidth: Longint;
    biHeight: Longint;
    biPlanes: Word;
    biBitCount: Word;
    biCompression: DWORD;
    biSizeImage: DWORD;
    biXPelsPerMeter: Longint;
    biYPelsPerMeter: Longint;
    biClrUsed: DWORD;
    biClrImportant: DWORD;
  end;
  BITMAPINFOHEADER = TBitmapInfoHeader;

  TBitmapFileHeader = packed record
    bfType: Word;
    bfSize: DWORD;
    bfReserved1: Word;
    bfReserved2: Word;
    bfOffBits: DWORD;
  end;


  TRGBQuad = packed record
    rgbBlue: Byte;
    rgbGreen: Byte;
    rgbRed: Byte;
    rgbReserved: Byte;
  end;

  PBitmapInfo = ^TBitmapInfo;
  TBitmapInfo = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..0] of TRGBQuad;
  end;

  TPanose = packed record
    bFamilyType: Byte;
    bSerifStyle: Byte;
    bWeight: Byte;
    bProportion: Byte;
    bContrast: Byte;
    bStrokeVariation: Byte;
    bArmStyle: Byte;
    bLetterform: Byte;
    bMidline: Byte;
    bXHeight: Byte;
  end;

  TTextMetricW = record
    tmHeight: Longint;
    tmAscent: Longint;
    tmDescent: Longint;
    tmInternalLeading: Longint;
    tmExternalLeading: Longint;
    tmAveCharWidth: Longint;
    tmMaxCharWidth: Longint;
    tmWeight: Longint;
    tmOverhang: Longint;
    tmDigitizedAspectX: Longint;
    tmDigitizedAspectY: Longint;
    tmFirstChar: WideChar;
    tmLastChar: WideChar;
    tmDefaultChar: WideChar;
    tmBreakChar: WideChar;
    tmItalic: Byte;
    tmUnderlined: Byte;
    tmStruckOut: Byte;
    tmPitchAndFamily: Byte;
    tmCharSet: Byte;
  end;

  TOutlineTextMetricW = record
    otmSize: UINT;
    otmTextMetrics: TTextMetricW;
    otmFiller: Byte;
    otmPanoseNumber: TPanose;
    otmfsSelection: UINT;
    otmfsType: UINT;
    otmsCharSlopeRise: Integer;
    otmsCharSlopeRun: Integer;
    otmItalicAngle: Integer;
    otmEMSquare: UINT;
    otmAscent: Integer;
    otmDescent: Integer;
    otmLineGap: UINT;
    otmsCapEmHeight: UINT;
    otmsXHeight: UINT;
    otmrcFontBox: TRect;
    otmMacAscent: Integer;
    otmMacDescent: Integer;
    otmMacLineGap: UINT;
    otmusMinimumPPEM: UINT;
    otmptSubscriptSize: TPoint;
    otmptSubscriptOffset: TPoint;
    otmptSuperscriptSize: TPoint;
    otmptSuperscriptOffset: TPoint;
    otmsStrikeoutSize: UINT;
    otmsStrikeoutPosition: Integer;
    otmsUnderscoreSize: Integer;
    otmsUnderscorePosition: Integer;
    otmpFamilyName: PAnsiChar;
    otmpFaceName: PAnsiChar;
    otmpStyleName: PAnsiChar;
    otmpFullName: PAnsiChar;
  end;

  TKerningPair = packed record
    wFirst: Word;
    wSecond: Word;
    iKernAmount: Integer;
  end;

  TOutlineTextMetricA = TOutlineTextMetricW;

  PRGBTriple = ^TRGBTriple;
  TRGBTriple = record
    rgbtBlue: Byte;
    rgbtGreen: Byte;
    rgbtRed: Byte;
  end;

function DeleteDC(DC: HDC): BOOL; stdcall;
function CreateFileW(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall;

function GetTimeZoneInformation(var lpTimeZoneInformation: TTimeZoneInformation): DWORD; stdcall;
function GetFullPathNameW(lpFileName: PWideChar; nBufferLength: DWORD;
  lpBuffer: PWideChar; var lpFilePart: PWideChar): DWORD; stdcall;
function Win32Check(RetVal: BOOL): BOOL;
function SetEndOfFile(hFile: THandle): BOOL; stdcall;
procedure GetSystemTimeAsFileTime(var lpSystemTimeAsFileTime: TFileTime); stdcall;
function SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL; stdcall;
function LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall;

function GlobalLock(hMem: HGLOBAL): Pointer; stdcall;
function GlobalUnlock(hMem: HGLOBAL): BOOL; stdcall;

function MultiByteToWideChar(CodePage: UINT; dwFlags: DWORD;
  const lpMultiByteStr: LPCSTR; cchMultiByte: Integer;
  lpWideCharStr: LPWSTR; cchWideChar: Integer): Integer; stdcall;

implementation

function DeleteDC(DC: HDC): BOOL; stdcall;
begin
  Result := True;
end;

function SetEndOfFile(hFile: THandle): BOOL; stdcall;
begin
  Result := False;
end;

function Win32Check(RetVal: BOOL): BOOL;
begin
  //if not RetVal then RaiseLastOSError;
  Result := RetVal;
end;

function GetTimeZoneInformation(var lpTimeZoneInformation: TTimeZoneInformation): DWORD; stdcall;
begin
  Result := 0;
end;

function GetFullPathNameW(lpFileName: PWideChar; nBufferLength: DWORD;
  lpBuffer: PWideChar; var lpFilePart: PWideChar): DWORD; stdcall;
begin
  Result := 0;
end;

function CreateFileW(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall;
begin
  Result := 0;
end;

procedure GetSystemTimeAsFileTime(var lpSystemTimeAsFileTime: TFileTime); stdcall;
begin

end;

function SystemTimeToFileTime(const lpSystemTime: TSystemTime; var lpFileTime: TFileTime): BOOL; stdcall;
begin
  Result := False;
end;

function LocalFileTimeToFileTime(const lpLocalFileTime: TFileTime; var lpFileTime: TFileTime): BOOL; stdcall;
begin
  Result := False;
end;

function GlobalLock(hMem: HGLOBAL): Pointer; stdcall;
begin
  Result := nil;
end;

function GlobalUnlock(hMem: HGLOBAL): BOOL; stdcall;
begin
  Result := True;
end;

function MultiByteToWideChar(CodePage: UINT; dwFlags: DWORD;
  const lpMultiByteStr: LPCSTR; cchMultiByte: Integer;
  lpWideCharStr: LPWSTR; cchWideChar: Integer): Integer; stdcall;
begin
  Result := 0;
end;

end.
