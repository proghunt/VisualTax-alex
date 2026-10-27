{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryJPEG.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryJPEG;

{$I DebenuPDFLibraryDefines.inc}

interface

{$IFDEF QPL_NOVCL}
  {$IFDEF QPL_OS_WINDOWS}
    {$DEFINE GDIPLUSJPEG}
  {$ELSE}
    {$DEFINE NOJPEG}
  {$ENDIF}
{$ENDIF}

{$IFNDEF QPL_NOVCL}
  {$DEFINE JPEGOBJ}
{$ENDIF}

{$IFDEF GDIPLUSJPEG}
uses
  Windows, SysUtils, Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Graphics,
{$ENDIF}
  DebenuPDFLibraryColorManagement,
  DebenuPDFLibraryGDIPlus, DebenuPDFLibraryTypes;

type
  TPDFJPEGImage = class
  private
    FColorManager: TPDFColorManager;
    FExternalColorManager: Boolean;
    FQuality: Integer;
    FDPI: Integer;
    FToken: TQPLIntPtr;
    FImage: TQPLIntPtr;
    FJPEGEncoder: TGUID;
    FBMPEncoder: TGUID;
    FWidth: Integer;
    FHeight: Integer;
    FGDIPlus: TDQPLGDIPlus;
    procedure SetColorManager(NewColorManager: TPDFColorManager);
  public
    constructor Create;
    destructor Destroy; override;
    procedure InvertCMYK;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure SaveBitmapToStream(Stream: TStream);
    procedure LoadFromBitmap(Source: TBitmap);
    property ColorManager: TPDFColorManager read FColorManager write SetColorManager;
    property CompressionQuality: Integer read FQuality write FQuality;
    property DPI: Integer read FDPI write FDPI;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
  end;
{$ENDIF}

{$IFDEF NOJPEG}
uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils, Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Graphics,
{$ENDIF}
  DebenuPDFLibraryColorManagement,
  DebenuPDFLibraryGDIPlus, DebenuPDFLibraryTypes;

type
  TPDFJPEGImage = class
  private
    FColorManager: TPDFColorManager;
    //FExternalColorManager: Boolean;
    FQuality: Integer;
    FDPI: Integer;
    //FToken: TQPLIntPtr;
    //FImage: TQPLIntPtr;
    //FJPEGEncoder: TGUID;
    //FBMPEncoder: TGUID;
    procedure SetColorManager(NewColorManager: TPDFColorManager);
  public
    constructor Create;
    destructor Destroy; override;
    procedure InvertCMYK;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure SaveBitmapToStream(Stream: TStream);
    procedure LoadFromBitmap(Source: TBitmap);
    property ColorManager: TPDFColorManager read FColorManager write SetColorManager;
    property CompressionQuality: Integer read FQuality write FQuality;
    property DPI: Integer read FDPI write FDPI;
  end;
{$ENDIF}

{$IFDEF JPEGOBJ}
uses
  Windows, SysUtils, Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryColorManagement, DebenuPDFLibraryTypes;

type
  TJPEGData = class(TSharedImage)
  private
    FData: TCustomMemoryStream;
    FHeight: Integer;
    FWidth: Integer;
    FGrayscale: Boolean;
  protected
    procedure FreeHandle; override;
  public
    destructor Destroy; override;
  end;

  TJPEGQualityRange = 1..100;
  TJPEGPerformance = (jpBestQuality, jpBestSpeed);
  TJPEGScale = (jsFullSize, jsHalf, jsQuarter, jsEighth);
  TJPEGPixelFormat = (jf24Bit, jf8Bit);

  TPDFJPEGImage = class(TGraphic)
  private
    FImage: TJPEGData;
    FBitmap: TBitmap;
    FScaledWidth: Integer;
    FScaledHeight: Integer;
    FTempPal: HPalette;
    FSmoothing: Boolean;
    FGrayScale: Boolean;
    FPixelFormat: TJPEGPixelFormat;
    FQuality: TJPEGQualityRange;
    FDPI: Integer;
    FProgressiveEncoding: Boolean;
    FPerformance: TJPEGPerformance;
    FScale: TJPEGScale;
    FNeedRecalc: Boolean;
    FInverted: Boolean;
    FColorManager: TPDFColorManager;
    FExternalColorManager: Boolean;
    procedure CalcOutputDimensions;
    function GetBitmap: TBitmap;
    function GetGrayscale: Boolean;
    procedure SetGrayscale(Value: Boolean);
    procedure SetPixelFormat(Value: TJPEGPixelFormat);
    procedure ConvertFromCMYK(Invert: Boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure Changed(Sender: TObject); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function Equals(Graphic: TGraphic): Boolean; override;
    procedure FreeBitmap;
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure NewBitmap;
    procedure NewImage;
    procedure ReadData(Stream: TStream); override;
    procedure ReadStream(Size: Integer; Stream: TStream);
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
    procedure WriteData(Stream: TStream); override;
    property Bitmap: TBitmap read GetBitmap;
    procedure SetColorManager(NewColorManager: TPDFColorManager);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Compress;
    procedure JPEGNeeded;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromClipboardFormat(AFormat: Word; AData: THandle;
      APalette: HPALETTE); override;
    procedure SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
      var APalette: HPALETTE); override;
    procedure InvertCMYK;
    procedure SaveBitmapToStream(Stream: TStream);
    procedure LoadFromBitmap(Source: TBitmap);
    property Grayscale: Boolean read GetGrayscale write SetGrayscale;
    property CompressionQuality: TJPEGQualityRange read FQuality write FQuality;
    property DPI: Integer read FDPI write FDPI;
    property PixelFormat: TJPEGPixelFormat read FPixelFormat write SetPixelFormat;
    property ColorManager: TPDFColorManager read FColorManager write SetColorManager;
  end;

  TJPEGDefaults = record
    CompressionQuality: TJPEGQualityRange;
    DPI: Integer;
    Grayscale: Boolean;
    Performance: TJPEGPerformance;
    PixelFormat: TJPEGPixelFormat;
    ProgressiveDisplay: Boolean;
    ProgressiveEncoding: Boolean;
    Scale: TJPEGScale;
    Smoothing: Boolean;
  end;

var
  JPEGDefaults: TJPEGDefaults = (
    CompressionQuality: 90;
    DPI: 96;
    Grayscale: False;
    Performance: jpBestQuality;
    PixelFormat: jf24Bit;
    ProgressiveDisplay: False;
    ProgressiveEncoding: False;
    Scale: jsFullSize;
    Smoothing: True;
  );

function DumpJPEG(Source: TStream): AnsiString; overload;
function DumpJPEG(const FileName: WideString): AnsiString; overload;
procedure DebenuPDFLibraryJPEGInitialization;
{$ENDIF}

implementation

{$IFDEF GDIPLUSJPEG}
uses
  ActiveX, DebenuPDFLibraryPicasso;

constructor TPDFJPEGImage.Create;
var
  StartupInput: TGdiplusStartupInput;
  Status: TGPStatus;
begin
  FColorManager := TPDFSimpleColorManager.Create;
  FExternalColorManager := False;
  FQuality := 90;
  FImage := 0;
  FDPI := 96;
  FWidth := 0;
  FHeight := 0;

  FGDIPlus := TDQPLGDIPlus.Create;
  if FGDIPlus.GDIPlusLoad('gdiplus.dll', True) = gpReady then
  begin
    StartupInput.GdiplusVersion := 1;
    StartupInput.DebugEventCallback := 0;
    StartupInput.SuppressBackgroundThread := False;
    StartupInput.SuppressExternalCodecs := True;
    Status := FGDIPlus.GdiplusStartup(FToken, @StartupInput, nil);

    if (Status = gsOk) then
    begin
      if (not FGDIPlus.GetEncoderClsid('image/bmp', FBMPEncoder)) then
      begin
        FillChar(FBMPEncoder, SizeOf(FBMPEncoder), 0);
      end;
      if (not FGDIPlus.GetEncoderClsid('image/jpeg', FJPEGEncoder)) then
      begin
        FillChar(FJPEGEncoder, SizeOf(FJPEGEncoder), 0);
      end;
    end;
  end;
end;

destructor TPDFJPEGImage.Destroy;
begin
  FGDIPlus.GdiplusShutdown(FToken);
  FGDIPlus.Free;
  if not FExternalColorManager then FColorManager.Free;
  inherited Destroy;
end;

procedure TPDFJPEGImage.InvertCMYK;
begin

end;

procedure TPDFJPEGImage.LoadFromStream(Stream: TStream);
var
  SA: TImageBytesStreamAdapter;
  SWidth: Single;
  SHeight: Single;
begin
  if (FImage <> 0) then
  begin
    FGDIPlus.GdipDisposeImage(FImage);
    FImage := 0;
  end;
  SA := TImageBytesStreamAdapter.Create(Stream, soReference);
  try
    if (FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage) <> gsOk) then
    begin
      FGDIPlus.GdipDisposeImage(FImage);
      FImage := 0;
    end else
    begin
      FGDIPlus.GdipGetImageDimension(FImage, SWidth, SHeight);
      FWidth := Trunc(FWidth);
      FHeight := Trunc(FHeight);
    end;
  finally
  end;
end;

procedure TPDFJPEGImage.SaveToStream(Stream: TStream);
var
  OutputStreamAdapter: TImageBytesStreamAdapter;
  SaveResult: TGPStatus;
begin
  OutputStreamAdapter := TImageBytesStreamAdapter.Create(Stream, soReference);
  try
    SaveResult := FGDIPlus.GdipSaveImageToStream(FImage, OutputStreamAdapter as IStream,
      @FJPEGEncoder, nil);
    if (SaveResult <> gsOk) then
    begin
      FImage := 0;
    end;
  finally
  end;
end;

procedure TPDFJPEGImage.SaveBitmapToStream(Stream: TStream);
var
  OutputStreamAdapter: TImageBytesStreamAdapter;
begin
  OutputStreamAdapter := TImageBytesStreamAdapter.Create(Stream, soReference);
  try
    FGDIPlus.GdipSaveImageToStream(FImage, OutputStreamAdapter as IStream,
      @FBMPEncoder, nil);
  finally
  end;
end;

procedure TPDFJPEGImage.LoadFromBitmap(Source: TBitmap);
var
  LoadResult: TGPStatus;
begin
  LoadResult := FGDIPlus.GdipCreateBitmapFromHBITMAP(Source.Handle, Source.Palette, FImage);
  if (LoadResult <> gsOk) then
  begin
    FGDIPlus.GdipDisposeImage(FImage);
    FImage := 0;
  end;
end;

procedure TPDFJPEGImage.SetColorManager(NewColorManager: TPDFColorManager);
begin
  if Assigned(NewColorManager) then
  begin
    if not FExternalColorManager then FColorManager.Free;
    FColorManager := NewColorManager;
    FExternalColorManager := True;
  end;
end;
{$ENDIF}

{$IFDEF NOJPEG}
constructor TPDFJPEGImage.Create;
begin
end;

destructor TPDFJPEGImage.Destroy;
begin
  inherited Destroy;
end;

procedure TPDFJPEGImage.InvertCMYK;
begin
end;

procedure TPDFJPEGImage.LoadFromStream(Stream: TStream);
begin
end;

procedure TPDFJPEGImage.SaveToStream(Stream: TStream);
begin
end;

procedure TPDFJPEGImage.SaveBitmapToStream(Stream: TStream);
begin
end;

procedure TPDFJPEGImage.LoadFromBitmap(Source: TBitmap);
begin
end;

procedure TPDFJPEGImage.SetColorManager(NewColorManager: TPDFColorManager);
begin
end;
{$ENDIF}

{$IFDEF JPEGOBJ}
uses
  Math, DebenuPDFLibraryExtra;

{$Z4}
{$ALIGN OFF}

function DumpJPEG(const FileName: WideString): AnsiString;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := '';
  if QPLFileExists(FileName) then
  begin
    FS := QPLCreateFileStream(FileName, fmOpenRead);
    try
      Result := Result + DumpJPEG(FS);
    finally
      FS.Free;
    end;
  end;
end;

function DumpJPEG(Source: TStream): AnsiString;
var
  SOI: Word;
  Seg: Word;
  AtEnd: Boolean;
  SegLen: Word;
  NextSegPos: Integer;
  Data: AnsiString;

  function ReadWord: Word;
  begin
    if Source.Read(Result, 2) < 2 then
    begin
      Result := $FFD9;
    end else
      Result := (Result and $FF) shl 8 + (Result and $FF00) shr 8;
  end;

begin
  Result := '';
  SOI := ReadWord;
  if SOI = $FFD8 then
  begin
    Result := Result + 'Found SOI'#13#10;
    AtEnd := False;
    Seg := ReadWord;
    while (not AtEnd) and (Seg and $FF00 = $FF00) do
    begin
      case Seg of
        $FFC0..$FFC7: Result := Result + 'SOF' + QPLIntToStr(Seg and $FF - $C0) + ' Marker Found'#13#10;
        $FFDA: Result := Result + 'SOS Marker Found'#13#10;
        $FFDB: Result := Result + 'DQT Marker Found'#13#10;
        $FFDC: Result := Result + 'DNL Marker Found'#13#10;
        $FFDD: Result := Result + 'DRI Marker Found'#13#10;
        $FFDE: Result := Result + 'DHP Marker Found'#13#10;
        $FFDF: Result := Result + 'EXP Marker Found'#13#10;
        $FFE0..$FFEF: Result := Result + 'APP' + QPLIntToStr(Seg and $FF - $E0) + ' Marker Found'#13#10;
      else
        Result := Result + 'Unknown Marker: $' + QPLIntToHex(Seg, 4) + #13#10;
      end;
      SegLen := ReadWord - 2;
      NextSegPos := Source.Position + SegLen;

      if Seg = $FFED then
      begin
        SetLength(Data, SegLen);
        Source.Read(Data[1], SegLen);
        Result := Result + 'APP13=' + Data + #13#10;
      end;

      if Seg = $FFEE then
      begin
        SetLength(Data, SegLen);
        Source.Read(Data[1], SegLen);
        Result := Result + 'APP14=' + Data + #13#10;
      end;

      Source.Seek(NextSegPos, soFromBeginning);
      Seg := ReadWord;
      if Seg = $FFD9 then AtEnd := True;
    end;
  end else
    Result := Result + 'Could not find SOI'#13#10;
end;

const
  JPEG_LIB_VERSION = 62;
  JPEG_RST0 = $D0;
  JPEG_EOI = $D9;
  JPEG_APP0 = $E0;
  JPEG_COM = $FE;

  DCTSIZE = 8;
  DCTSIZE2 = 64;
  NUM_QUANT_TBLS = 4;
  NUM_HUFF_TBLS = 4;
  NUM_ARITH_TBLS = 16;
  MAX_COMPS_IN_SCAN = 4;
  MAX_SAMP_FACTOR = 4;
  C_MAX_BLOCKS_IN_MCU = 10;
  D_MAX_BLOCKS_IN_MCU = 10;
  MAX_COMPONENTS = 10;

  MAXJSAMPLE = 255;
  CENTERJSAMPLE = 128;

type
  JSAMPLE = Byte;
  GETJSAMPLE = Integer;
  JCOEF = Integer;
  JCOEF_PTR = ^JCOEF;
  UINT8 = Byte;
  UINT16 = Word;
  UINT = Cardinal;
  INT16 = SmallInt;
  INT32 = Integer;
  INT32PTR = ^INT32;
  JDIMENSION = Cardinal;
  JOCTET = Byte;
  jTOctet = 0..(MaxInt div SizeOf(JOCTET)) - 1;
  JOCTET_FIELD = array[jTOctet] of JOCTET;
  JOCTET_FIELD_PTR = ^JOCTET_FIELD;
  JOCTETPTR = ^JOCTET;
  JSAMPLE_PTR = ^JSAMPLE;
  JSAMPROW_PTR = ^JSAMPROW;
  jTSample = 0..(MaxInt div SIZEOF(JSAMPLE)) - 1;
  JSAMPLE_ARRAY = array[jTSample] of JSAMPLE;
  JSAMPROW = ^JSAMPLE_ARRAY;
  jTRow = 0..(MaxInt div SIZEOF(JSAMPROW)) - 1;
  JSAMPROW_ARRAY = array[jTRow] of JSAMPROW;
  JSAMPARRAY = ^JSAMPROW_ARRAY;
  jTarray = 0..(MaxInt div SIZEOF(JSAMPARRAY)) - 1;
  JSAMP_ARRAY = array[jTarray] of JSAMPARRAY;
  JSAMPIMAGE = ^JSAMP_ARRAY;

const
  CSTATE_START = 100;
  CSTATE_SCANNING = 101;
  CSTATE_RAW_OK = 102;
  CSTATE_WRCOEFS = 103;
  DSTATE_START = 200;
  DSTATE_INHEADER = 201;
  DSTATE_READY = 202;
  DSTATE_PRELOAD = 203;
  DSTATE_PRESCAN = 204;
  DSTATE_SCANNING = 205;
  DSTATE_RAW_OK = 206;
  DSTATE_BUFIMAGE = 207;
  DSTATE_BUFPOST = 208;
  DSTATE_RDCOEFS = 209;
  DSTATE_STOPPING = 210;

type
  J_COLOR_SPACE = (JCS_UNKNOWN, JCS_GRAYSCALE, JCS_RGB, JCS_YCbCr,
    JCS_CMYK, JCS_YCCK);

  J_DCT_METHOD = (JDCT_ISLOW, JDCT_IFAST, JDCT_FLOAT);

  J_DITHER_MODE = (JDITHER_NONE, JDITHER_ORDERED, JDITHER_FS);

const
  JMSG_LENGTH_MAX  = 200;
  JMSG_STR_PARM_MAX = 80;

  JPOOL_PERMANENT = 0;
  JPOOL_IMAGE = 1;

type
  jpeg_error_mgr_ptr = ^jpeg_error_mgr;
  jpeg_progress_mgr_ptr = ^jpeg_progress_mgr;

  j_common_ptr = ^jpeg_common_struct;
  j_compress_ptr = ^jpeg_compress_struct;
  j_decompress_ptr = ^jpeg_decompress_struct;

  jpeg_marker_parser_method = function(cinfo: j_decompress_ptr): LongBool;

  jpeg_saved_marker_ptr = ^jpeg_marker_struct;

  jpeg_marker_struct = record
    next: jpeg_saved_marker_ptr;
    marker: Byte;
    dummy: array[1..3] of Byte;
    original_length: LongWord;
    data_length: LongWord;
    data: JOCTETPTR;
  end;

  jpeg_marker_reader_ptr = ^jpeg_marker_reader;
  jpeg_marker_reader = record
    reset_marker_reader: procedure(cinfo: j_decompress_ptr);

    read_markers: function (cinfo: j_decompress_ptr): Integer;
    read_restart_marker: jpeg_marker_parser_method;
    process_COM: jpeg_marker_parser_method;
    process_APPn: array[0..15] of jpeg_marker_parser_method;
    saw_SOI: LongBool;
    saw_SOF: LongBool;
    next_restart_num: Integer;
    discarded_bytes: UINT;
  end;

  int8array = array[0..7] of Integer;

  jpeg_error_mgr = record
    error_exit: procedure  (cinfo: j_common_ptr);
    emit_message: procedure (cinfo: j_common_ptr; msg_level: Integer);
    output_message: procedure (cinfo: j_common_ptr);
    format_message: procedure  (cinfo: j_common_ptr; buffer: PAnsiChar);
    reset_error_mgr: procedure (cinfo: j_common_ptr);

    msg_code: Integer;

    msg_parm: record
      case Byte of
        0:(i: int8array);
        1:(s: array[0..JMSG_STR_PARM_MAX - 1] of AnsiChar);
    end;
    trace_level: Integer;
    num_warnings: Integer;
    jpeg_message_table: ^PAnsiChar;
    last_jpeg_message: Integer;
    addon_message_table: ^PAnsiChar;
    first_addon_message: Integer;
    last_addon_message: Integer;
  end;

  jpeg_destination_mgr_ptr = ^jpeg_destination_mgr;
  jpeg_destination_mgr = record
    next_output_byte: JOCTETptr;
    free_in_buffer: Integer;
    init_destination: procedure (cinfo: j_compress_ptr);
    empty_output_buffer: function (cinfo: j_compress_ptr): LongBool;
    term_destination: procedure (cinfo: j_compress_ptr);
  end;


  jpeg_source_mgr_ptr = ^jpeg_source_mgr;
  jpeg_source_mgr = record
    next_input_byte: JOCTETptr;
    bytes_in_buffer: Integer;
    init_source: procedure (cinfo: j_decompress_ptr);
    fill_input_buffer: function (cinfo: j_decompress_ptr): LongBool;
    skip_input_data: procedure (cinfo: j_decompress_ptr; num_bytes: Integer);
    resync_to_restart: function (cinfo: j_decompress_ptr;
                                  desired: Integer): LongBool;
    term_source: procedure (cinfo: j_decompress_ptr);
  end;

  jpeg_memory_mgr_ptr = ^jpeg_memory_mgr;
  jpeg_memory_mgr = record
    alloc_small: function (cinfo: j_common_ptr;
                            pool_id, sizeofobject: Integer): pointer;
    alloc_large: function (cinfo: j_common_ptr;
                            pool_id, sizeofobject: Integer): pointer;
    alloc_sarray: function (cinfo: j_common_ptr; pool_id: Integer;
                             samplesperrow: JDIMENSION;
                             numrows: JDIMENSION): JSAMPARRAY;
    alloc_barray: pointer;
    request_virt_sarray: pointer;
    request_virt_barray: pointer;
    realize_virt_arrays: pointer;
    access_virt_sarray: pointer;
    access_virt_barray: pointer;
    free_pool: pointer;
    self_destruct: pointer;
    max_memory_to_use: Integer;
    max_alloc_chunk: Integer;
  end;

  jpeg_common_struct = record
    err: jpeg_error_mgr_ptr;
    mem: jpeg_memory_mgr_ptr;
    progress: jpeg_progress_mgr_ptr;
    client_data: Pointer;
    is_decompressor: LongBool;
    global_state: Integer;
  end;

  jpeg_progress_mgr = record
    progress_monitor: procedure(const cinfo: jpeg_common_struct);
    pass_counter: Integer;
    pass_limit: Integer;
    completed_passes: Integer;
    total_passes: Integer;
    instance: TPDFJPEGImage;
    last_pass: Cardinal;
    last_pct: Cardinal;
    last_time: Cardinal;
    last_scanline: Integer;
  end;

  jpeg_compress_struct = record
    common: jpeg_common_struct;
    dest: jpeg_destination_mgr_ptr;

    image_width: JDIMENSION;
    image_height: JDIMENSION;
    input_components: Integer;
    in_color_space: J_COLOR_SPACE;
    input_gamma: double;

    data_precision: Integer;
    num_components: Integer;
    jpeg_color_space: J_COLOR_SPACE;
    comp_info: Pointer;
    quant_tbl_ptrs: array[0..NUM_QUANT_TBLS-1] of Pointer;
    dc_huff_tbl_ptrs: array[0..NUM_HUFF_TBLS-1] of Pointer;
    ac_huff_tbl_ptrs: array[0..NUM_HUFF_TBLS-1] of Pointer;
    arith_dc_L: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_dc_U: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_ac_K: array[0..NUM_ARITH_TBLS-1] of UINT8;
    num_scans: Integer;
    scan_info: Pointer;
    raw_data_in: LongBool;
    arith_code: LongBool;
    optimize_coding: LongBool;
    CCIR601_sampling: LongBool;
    smoothing_factor: Integer;
    dct_method: J_DCT_METHOD;
    restart_interval: UINT;
    restart_in_rows: Integer;

    write_JFIF_header: LongBool;
    JFIF_major_version: UINT8;
    JFIF_minor_version: UINT8;
    density_unit: UINT8;
    padding: UINT8;
    X_density: UINT16;
    Y_density: UINT16;
    write_Adobe_marker: LongBool;

    next_scanline: JDIMENSION;

    progressive_mode: LongBool;
    max_h_samp_factor: Integer;
    max_v_samp_factor: Integer;
    total_iMCU_rows: JDIMENSION;
    comps_in_scan: Integer;
    cur_comp_info: array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
    MCUs_per_row: JDIMENSION;
    MCU_rows_in_scan: JDIMENSION;
    blocks_in_MCU: Integer;
    MCU_membership: array[0..C_MAX_BLOCKS_IN_MCU-1] of Integer;
    Ss, Se, Ah, Al: Integer;

    master: Pointer;
    main: Pointer;
    prep: Pointer;
    coef: Pointer;
    marker: Pointer;
    cconvert: Pointer;
    downsample: Pointer;
    fdct: Pointer;
    entropy: Pointer;
    script_space: Pointer;
    script_space_size: Integer;
  end;


  jpeg_decompress_struct = record
    common: jpeg_common_struct;
    src: jpeg_source_mgr_ptr;

    image_width: JDIMENSION;
    image_height: JDIMENSION;
    num_components: Integer;
    jpeg_color_space: J_COLOR_SPACE;

    out_color_space: J_COLOR_SPACE;
    scale_num, scale_denom: uint;
    output_gamma: double;
    buffered_image: LongBool;
    raw_data_out: LongBool;
    dct_method: J_DCT_METHOD;
    do_fancy_upsampling: LongBool;
    do_block_smoothing: LongBool;
    quantize_colors: LongBool;
    dither_mode: J_DITHER_MODE;
    two_pass_quantize: LongBool;
    desired_number_of_colors: Integer;
    enable_1pass_quant: LongBool;
    enable_external_quant: LongBool;
    enable_2pass_quant: LongBool;

    output_width: JDIMENSION;
    output_height: JDIMENSION;
    out_color_components: Integer;
    output_components: Integer;

    rec_outbuf_height: Integer;

    actual_number_of_colors: Integer;
    colormap: JSAMPARRAY;

    output_scanline: JDIMENSION;

    input_scan_number: Integer;
    input_iMCU_row: JDIMENSION;

    output_scan_number: Integer;
    output_iMCU_row: Integer;

    coef_bits: Pointer;

    quant_tbl_ptrs: array[0..NUM_QUANT_TBLS-1] of Pointer;
    dc_huff_tbl_ptrs: array[0..NUM_HUFF_TBLS-1] of Pointer;
    ac_huff_tbl_ptrs: array[0..NUM_HUFF_TBLS-1] of Pointer;

    data_precision: Integer;
    comp_info: Pointer;
    progressive_mode: LongBool;
    arith_code: LongBool;
    arith_dc_L: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_dc_U: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_ac_K: array[0..NUM_ARITH_TBLS-1] of UINT8;

    restart_interval: UINT;

    saw_JFIF_marker: LongBool;
    JFIF_major_version: UINT8;
    JFIF_minor_version: UINT8;
    density_unit: UINT8;
    padding: UINT8;    
    X_density: UINT16;
    Y_density: UINT16;
    saw_Adobe_marker: LongBool;
    Adobe_transform: UINT8;
    padding2: UINT8;
    padding3: UINT8;
    padding4: UINT8;

    CCIR601_sampling: LongBool;

    marker_list: jpeg_saved_marker_ptr;

    max_h_samp_factor: Integer;
    max_v_samp_factor: Integer;
    min_DCT_scaled_size: Integer;
    total_iMCU_rows: JDIMENSION;
    sample_range_limit: Pointer;

    comps_in_scan: Integer;
    cur_comp_info: array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
    MCUs_per_row: JDIMENSION;
    MCU_rows_in_scan: JDIMENSION;
    blocks_in_MCU: JDIMENSION;
    MCU_membership: array[0..D_MAX_BLOCKS_IN_MCU-1] of Integer;
    Ss, Se, Ah, Al: Integer;
    unread_marker: Integer;
    master: Pointer;
    main: Pointer;
    coef: Pointer;
    post: Pointer;
    inputctl: Pointer;
    marker: Pointer;
    entropy: Pointer;
    idct: Pointer;
    upsample: Pointer;
    cconvert: Pointer;
    cquantize: Pointer;
  end;

  TJPEGContext = record
    err: jpeg_error_mgr;
    progress: jpeg_progress_mgr;
    FinalDCT: J_DCT_METHOD;
    FinalTwoPassQuant: Boolean;
    FinalDitherMode: J_DITHER_MODE;
    case byte of
      0: (common: jpeg_common_struct);
      1: (d: jpeg_decompress_struct);
      2: (c: jpeg_compress_struct);
  end;

const
  JPEG_SUSPENDED              = 0;
  JPEG_HEADER_OK              = 1;
  JPEG_HEADER_TABLES_ONLY     = 2;

  JPEG_REACHED_SOS            = 1;
  JPEG_REACHED_EOI            = 2;
  JPEG_ROW_COMPLETED          = 3;
  JPEG_SCAN_COMPLETED         = 4;

function _malloc(size: Integer): Pointer; cdecl;
begin
  GetMem(Result, size);
end;

procedure _free(P: Pointer); cdecl;
begin
  FreeMem(P);
end;

procedure _memset(P: Pointer; B: Byte; count: Integer);cdecl;
begin
  FillChar(P^, count, B);
end;

procedure _memcpy(dest, source: Pointer; count: Integer);cdecl;
begin
  Move(source^, dest^, count);
end;

function _fread(var buf; recsize, reccount: Integer; S: TStream): Integer; cdecl;
begin
  Result := S.Read(buf, recsize * reccount);
end;

function _fwrite(const buf; recsize, reccount: Integer; S: TStream): Integer; cdecl;
begin
  Result := S.Write(buf, recsize * reccount);
end;

function _fflush(S: TStream): Integer; cdecl;
begin
  Result := 0;
end;

function __ftol: Integer;
var
  f: double;
begin
  asm
    lea    eax, f
    fstp  qword ptr [eax]
  end;
  Result := Integer(Trunc(f));
end;

var
  __turboFloat: LongBool = False;

{$L obj\jdapimin.obj}
{$L obj\jmemmgr.obj}
{$L obj\jmemnobs.obj}
{$L obj\jdinput.obj}
{$L obj\jdatasrc.obj}
{$L obj\jdapistd.obj}
{$L obj\jdmaster.obj}
{$L obj\jdphuff.obj}
{$L obj\jdhuff.obj}
{$L obj\jdmerge.obj}
{$L obj\jdcolor.obj}
{$L obj\jquant1.obj}
{$L obj\jquant2.obj}
{$L obj\jdmainct.obj}
{$L obj\jdcoefct.obj}
{$L obj\jdpostct.obj}
{$L obj\jddctmgr.obj}
{$L obj\jdsample.obj}
{$L obj\jidctflt.obj}
{$L obj\jidctfst.obj}
{$L obj\jidctint.obj}
{$L obj\jidctred.obj}
{$L obj\jdmarker.obj}
{$L obj\jutils.obj}
{$L obj\jcomapi.obj}

procedure jpeg_CreateDecompress (var cinfo: jpeg_decompress_struct; version: integer; structsize: integer); external;
procedure jpeg_stdio_src(var cinfo: jpeg_decompress_struct; input_file: TStream); external;
procedure jpeg_read_header(var cinfo: jpeg_decompress_struct; RequireImage: LongBool); external;
procedure jpeg_calc_output_dimensions(var cinfo: jpeg_decompress_struct); external;
procedure jpeg_save_markers(var cinfo: jpeg_decompress_struct; marker_code: Integer; length_limit: UINT); external;
function jpeg_start_decompress(var cinfo: jpeg_decompress_struct): Longbool; external;
function jpeg_read_scanlines(var cinfo: jpeg_decompress_struct; scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; external;
function jpeg_finish_decompress(var cinfo: jpeg_decompress_struct): Longbool; external;
procedure jpeg_destroy_decompress (var cinfo: jpeg_decompress_struct); external;
function jpeg_has_multiple_scans(var cinfo: jpeg_decompress_struct): Longbool; external;
function jpeg_consume_input(var cinfo: jpeg_decompress_struct): Integer; external;
function jpeg_start_output(var cinfo: jpeg_decompress_struct; scan_number: Integer): Longbool; external;
function jpeg_finish_output(var cinfo: jpeg_decompress_struct): LongBool; external;
procedure jpeg_destroy(var cinfo: jpeg_common_struct); external;

{$IFDEF QPL_NOVCL}
{$L obj\fpc-jdatadst.obj}
{$L obj\fpc-jcparam.obj}
{$L obj\fpc-jcapistd.obj}
{$L obj\fpc-jcapimin.obj}
{$L obj\fpc-jcinit.obj}
{$L obj\fpc-jcmarker.obj}
{$L obj\fpc-jcmaster.obj}
{$L obj\fpc-jcmainct.obj}
{$L obj\fpc-jcprepct.obj}
{$L obj\fpc-jccoefct.obj}
{$L obj\fpc-jccolor.obj}
{$L obj\fpc-jcsample.obj}
{$L obj\fpc-jcdctmgr.obj}
{$L obj\fpc-jcphuff.obj}
//{$L obj\fpc-jfdctint.obj}
{$L obj\fpc-jfdctfst.obj}
{$L obj\fpc-jfdctflt.obj}
{$L obj\fpc-jchuff.obj}
{$ELSE}
{$L obj\jdatadst.obj}
{$L obj\jcparam.obj}
{$L obj\jcapistd.obj}
{$L obj\jcapimin.obj}
{$L obj\jcinit.obj}
{$L obj\jcmarker.obj}
{$L obj\jcmaster.obj}
{$L obj\jcmainct.obj}
{$L obj\jcprepct.obj}
{$L obj\jccoefct.obj}
{$L obj\jccolor.obj}
{$L obj\jcsample.obj}
{$L obj\jcdctmgr.obj}
{$L obj\jcphuff.obj}
{$L obj\jfdctint.obj}
{$L obj\jfdctfst.obj}
{$L obj\jfdctflt.obj}
{$L obj\jchuff.obj}
{$ENDIF}

procedure jpeg_CreateCompress (var cinfo: jpeg_compress_struct;
  version: integer; structsize: integer); external;
procedure jpeg_stdio_dest(var cinfo: jpeg_compress_struct;
  output_file: TStream); external;
procedure jpeg_set_defaults(var cinfo: jpeg_compress_struct); external;
procedure jpeg_set_quality(var cinfo: jpeg_compress_struct; Quality: Integer;
  Baseline: Longbool); external;
procedure jpeg_set_colorspace(var cinfo: jpeg_compress_struct;
  colorspace: J_COLOR_SPACE); external;
procedure jpeg_simple_progression(var cinfo: jpeg_compress_struct); external;
procedure jpeg_start_compress(var cinfo: jpeg_compress_struct;
  WriteAllTables: LongBool); external;
function jpeg_write_scanlines(var cinfo: jpeg_compress_struct;
  scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; external;
procedure jpeg_finish_compress(var cinfo: jpeg_compress_struct); external;

type
  EJPEG = class(EInvalidGraphic);

procedure InvalidOperation(const Msg: AnsiString); {$IFNDEF QPL_NOVCL}near;{$ENDIF}
begin
  //!!
end;

procedure JpegError(cinfo: j_common_ptr);
begin
  //!!
end;

procedure EmitMessage(cinfo: j_common_ptr; msg_level: Integer);
begin
  //!!
end;

procedure OutputMessage(cinfo: j_common_ptr); 
begin
  //!!
end;

procedure FormatMessage(cinfo: j_common_ptr; buffer: PAnsiChar); 
begin
  //!!
end;

procedure ResetErrorMgr(cinfo: j_common_ptr); 
begin
  cinfo^.err^.num_warnings := 0;
  cinfo^.err^.msg_code := 0;
end;

const
  jpeg_std_error: jpeg_error_mgr = (
    error_exit: JpegError;
    emit_message: EmitMessage;
    output_message: OutputMessage;
    format_message: FormatMessage;
    reset_error_mgr: ResetErrorMgr);

{ TJPEGData }

destructor TJPEGData.Destroy;
begin
  FData.Free;
  inherited Destroy;
end;

procedure TJPEGData.FreeHandle;
begin
end;

{ TPDFJPEGImage }

constructor TPDFJPEGImage.Create;
begin
  inherited Create;
  NewImage;
  FQuality := JPEGDefaults.CompressionQuality;
  FDPI := JPEGDefaults.DPI;
  FGrayscale := JPEGDefaults.Grayscale;
  FPerformance := JPEGDefaults.Performance;
  FPixelFormat := JPEGDefaults.PixelFormat;
  FProgressiveEncoding := JPEGDefaults.ProgressiveEncoding;
  FScale := JPEGDefaults.Scale;
  FSmoothing := JPEGDefaults.Smoothing;
  FInverted := False;
  FColorManager := TPDFSimpleColorManager.Create;
end;

destructor TPDFJPEGImage.Destroy;
begin
  if FTempPal <> 0 then DeleteObject(FTempPal);
  FBitmap.Free;
  FImage.Release;
  if not FExternalColorManager then FColorManager.Free;
  inherited Destroy;
end;

procedure TPDFJPEGImage.Assign(Source: TPersistent);
begin
  if Source is TPDFJPEGImage then
  begin
    FImage.Release;
    FImage := TPDFJPEGImage(Source).FImage;
    FImage.Reference;
    if TPDFJPEGImage(Source).FBitmap <> nil then
    begin
      NewBitmap;
      FBitmap.Assign(TPDFJPEGImage(Source).FBitmap);
    end;
  end
  else if Source is TBitmap then
  begin
    NewImage;
    NewBitmap;
    FBitmap.Assign(Source);
  end
  else
    inherited Assign(Source);
end;

procedure ProgressCallback(const cinfo: jpeg_common_struct); 
var
  Ticks: Cardinal;
  R: TRect;
  temp: Cardinal;
begin
  if (cinfo.progress = nil) or (cinfo.progress^.instance = nil) then Exit;
  with cinfo.progress^ do
  begin
    Ticks := GetTickCount;
    if (Ticks - last_time) < 500 then Exit;
    temp := last_time;
    last_time := Ticks;
    if temp = 0 then Exit;
    if cinfo.is_decompressor then
      with j_decompress_ptr(@cinfo)^ do
      begin
        R := Rect(0, last_scanline, output_width, output_scanline);
        if R.Bottom < last_scanline then
          R.Bottom := output_height;
      end
    else
      R := Rect(0, 0, 0, 0);
    temp := Cardinal(Trunc(100.0*(completed_passes + (pass_counter/pass_limit))/total_passes));
    if temp = last_pct then Exit;
    last_pct := temp;
    if cinfo.is_decompressor then
      last_scanline := j_decompress_ptr(@cinfo)^.output_scanline;
    instance.Progress(instance, psRunning, temp, (R.Bottom - R.Top) >= 4, R, '');
  end;
end;

procedure ReleaseContext(var jc: TJPEGContext);
begin
  if jc.common.err = nil then Exit;
  jpeg_destroy(jc.common);
  jc.common.err := nil;
end;

procedure InitDecompressor(Obj: TPDFJPEGImage; var jc: TJPEGContext);
begin
  FillChar(jc, sizeof(jc), 0);
  jc.err := jpeg_std_error;
  jc.common.err := @jc.err;

  jpeg_CreateDecompress(jc.d, JPEG_LIB_VERSION, sizeof(jc.d));
  jpeg_save_markers(jc.d, JPEG_APP0 + 14, 256);  
  with Obj do
  try
    jc.progress.progress_monitor := ProgressCallback;
    jc.progress.instance := Obj;
    jc.common.progress := @jc.progress;

    Obj.FImage.FData.Position := 0;
    jpeg_stdio_src(jc.d, FImage.FData);
    jpeg_read_header(jc.d, TRUE);

    jc.d.scale_num := 1;
    jc.d.scale_denom := 1 shl Byte(FScale);
    jc.d.do_block_smoothing := FSmoothing;

    if FGrayscale then jc.d.out_color_space := JCS_GRAYSCALE;
    if (PixelFormat = jf8Bit) or (jc.d.out_color_space = JCS_GRAYSCALE) then
    begin
      jc.d.quantize_colors := True;
      jc.d.desired_number_of_colors := 236;
    end;

    if FPerformance = jpBestSpeed then
    begin
      jc.d.dct_method := JDCT_IFAST;
      jc.d.two_pass_quantize := False;
      jc.d.dither_mode := JDITHER_ORDERED;
    end;

    jc.FinalDCT := jc.d.dct_method;
    jc.FinalTwoPassQuant := jc.d.two_pass_quantize;
    jc.FinalDitherMode := jc.d.dither_mode;
  except
    ReleaseContext(jc);
    raise;
  end;
end;

procedure TPDFJPEGImage.CalcOutputDimensions;
var
  jc: TJPEGContext;
begin
  if not FNeedRecalc then Exit;
  InitDecompressor(Self, jc);
  try
    jc.common.progress := nil;
    jpeg_calc_output_dimensions(jc.d);
    FScaledWidth := jc.d.output_width;
    FScaledHeight := jc.d.output_height;
    FProgressiveEncoding := jpeg_has_multiple_scans(jc.d);
  finally
    ReleaseContext(jc);
  end;
end;

procedure TPDFJPEGImage.Changed(Sender: TObject);
begin
  inherited Changed(Sender);
end;

procedure TPDFJPEGImage.Compress;
var
  LinesWritten, LinesPerCall: Integer;
  SrcScanLine: Pointer;
  PtrInc: Integer;
  jc: TJPEGContext;
  Src: TBitmap;
begin
  FillChar(jc, sizeof(jc), 0);
  jc.err := jpeg_std_error;
  jc.common.err := @jc.err;

  jpeg_CreateCompress(jc.c, JPEG_LIB_VERSION, sizeof(jc.c));
  try
    try
      jc.progress.progress_monitor := ProgressCallback;
      jc.progress.instance := Self;
      jc.common.progress := @jc.progress;

      if FImage.FData <> nil then NewImage;
      FImage.FData := TMemoryStream.Create;
      FImage.FData.Position := 0;
      jpeg_stdio_dest(jc.c, FImage.FData);

      if (FBitmap = nil) or (FBitmap.Width = 0) or (FBitmap.Height = 0) then Exit;
      jc.c.image_width := FBitmap.Width;
      FImage.FWidth := FBitmap.Width;
      jc.c.image_height := FBitmap.Height;
      FImage.FHeight := FBitmap.Height;
      jc.c.input_components := 3;
      jc.c.in_color_space := JCS_RGB;

      Src := TBitmap.Create;
      try
        Src.Assign(FBitmap);
        Src.PixelFormat := pf24bit;

        jpeg_set_defaults(jc.c);

        jc.c.density_unit := 1;    // 1 = dpi
        jc.c.X_density := FDPI;
        jc.c.Y_density := FDPI;

        jpeg_set_quality(jc.c, FQuality, True);

        if FGrayscale then
        begin
          FImage.FGrayscale := True;
          jpeg_set_colorspace(jc.c, JCS_GRAYSCALE);
        end;

        SrcScanline := Src.ScanLine[0];
        if (Src.Height > 1) then
        begin
          PtrInc := TQPLIntPtr(Src.ScanLine[1]) - TQPLIntPtr(SrcScanline);
        end else
        begin
          PtrInc := 0;
        end;

        if (PtrInc > 0) and ((PtrInc and 3) = 0) then
          LinesPerCall := jc.c.image_height
        else
          LinesPerCall := 1;

        Progress(Self, psStarting, 0, False, Rect(0, 0, 0, 0), '');
        try
          jpeg_start_compress(jc.c, True);

          while (jc.c.next_scanline < jc.c.image_height) do
          begin
            LinesWritten := jpeg_write_scanlines(jc.c, @SrcScanline, LinesPerCall);
            Inc(TQPLIntPtr(SrcScanline), PtrInc * LinesWritten);
          end;

          jpeg_finish_compress(jc.c);
        finally
          if ExceptObject = nil then
            PtrInc := 100
          else
            PtrInc := 0;
          Progress(Self, psEnding, PtrInc, False, Rect(0, 0, 0, 0), '');
        end;
      finally
        Src.Free;
      end;
    except
      on EAbort do
        NewImage;
    end;
  finally
    ReleaseContext(jc);
  end;
end;

procedure TPDFJPEGImage.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  Bitmap.Canvas.Lock;
  try
    ACanvas.StretchDraw(Rect, Bitmap);
  finally
    Bitmap.Canvas.Unlock;
  end;
end;

function TPDFJPEGImage.Equals(Graphic: TGraphic): Boolean;
begin
  Result := False;
  if not (Graphic is TPDFJPEGImage) then Exit;
  if (FImage.FData <> nil) and (TPDFJPEGImage(Graphic).FImage.FData <> nil) then
    Result := inherited Equals(Graphic)
  else
    Result := (FImage = TPDFJPEGImage(Graphic).FImage);
end;

procedure TPDFJPEGImage.FreeBitmap;
begin
  FBitmap.Free;
  FBitmap := nil;
end;

function BuildPalette(const cinfo: jpeg_decompress_struct; Invert: Boolean): HPalette;
var
  Pal: TMaxLogPalette;
  I: Integer;
  C: Byte;
begin
  Pal.palVersion := $300;
  Pal.palNumEntries := cinfo.actual_number_of_colors;
  if cinfo.out_color_space = JCS_GRAYSCALE then
  begin
    for I := 0 to Pal.palNumEntries-1 do
    begin
      C := cinfo.colormap^[0]^[I];
      if Invert then C := not C;
      Pal.palPalEntry[I].peRed := C;
      Pal.palPalEntry[I].peGreen := C;
      Pal.palPalEntry[I].peBlue := C;
      Pal.palPalEntry[I].peFlags := 0;
    end;
  end else
  begin
    for I := 0 to Pal.palNumEntries-1 do
    begin
      Pal.palPalEntry[I].peRed := cinfo.colormap^[2]^[I];
      Pal.palPalEntry[I].peGreen := cinfo.colormap^[1]^[I];
      Pal.palPalEntry[I].peBlue := cinfo.colormap^[0]^[I];
      Pal.palPalEntry[I].peFlags := 0;
    end;
  end;
  Result := CreatePalette(PLogPalette(@Pal)^);
end;

procedure BuildColorMap(var cinfo: jpeg_decompress_struct; P: HPalette);
var
  Pal: TMaxLogPalette;
  Count, I: Integer;
begin
  Count := GetPaletteEntries(P, 0, 256, Pal.palPalEntry);
  if Count = 0 then Exit;
  cinfo.colormap := cinfo.common.mem.alloc_sarray(@cinfo.common, JPOOL_IMAGE, Count, 3);
  cinfo.actual_number_of_colors := Count;
  for I := 0 to Count-1 do
  begin
    Byte(cinfo.colormap^[2]^[I]) := Pal.palPalEntry[I].peRed;
    Byte(cinfo.colormap^[1]^[I]) := Pal.palPalEntry[I].peGreen;
    Byte(cinfo.colormap^[0]^[I]) := Pal.palPalEntry[I].peBlue;
  end;
end;

function TPDFJPEGImage.GetBitmap: TBitmap;
var
  LinesPerCall, LinesRead: Integer;
  DestScanLine: PAnsiChar;
  PtrInc: TQPLIntPtr;
  jc: TJPEGContext;
  GeneratePalette: Boolean;
begin
  Result := FBitmap;
  if Result <> nil then Exit;
  if (FBitmap = nil) then FBitmap := TBitmap.Create;
  Result := FBitmap;
  GeneratePalette := True;

  InitDecompressor(Self, jc);
  try
    try
      FBitmap.Handle := 0;
      if (PixelFormat = jf8Bit) or (jc.d.out_color_space = JCS_GRAYSCALE) then
        FBitmap.PixelFormat := pf8bit
      else
      if (jc.d.out_color_space = JCS_CMYK) then
        FBitmap.PixelFormat := pf32bit
      else
        FBitmap.PixelFormat := pf24bit;

      Progress(Self, psStarting, 0, False, Rect(0, 0, 0, 0), '');
      try
        if (FTempPal <> 0) then
        begin
          if (FPixelFormat = jf8Bit) then
          begin
            BuildColorMap(jc.d, FTempPal);
            FBitmap.Palette := CopyPalette(FTempPal);
            GeneratePalette := False;
          end
          else
          begin
            DeleteObject(FTempPal);
            FTempPal := 0;
          end;
        end;

        jpeg_start_decompress(jc.d);

        with FBitmap do
        begin
          Handle := 0;
          Width := jc.d.output_width;
          Height := jc.d.output_height;
          DestScanline := ScanLine[0];
          if Height > 1 then
            PtrInc := TQPLIntPtr(ScanLine[1]) - TQPLIntPtr(DestScanline)
          else
            PtrInc := 0;
          if (PtrInc > 0) and ((PtrInc and 3) = 0) then
            LinesPerCall := jc.d.rec_outbuf_height
          else
            LinesPerCall := 1;
        end;

        if jc.d.buffered_image then
        begin
          while jpeg_consume_input(jc.d) <> JPEG_REACHED_EOI do
          begin
            jpeg_start_output(jc.d, jc.d.input_scan_number);
            if (jc.common.progress^.completed_passes = 0) and (jc.d.colormap <> nil)
              and (FBitmap.PixelFormat = pf8bit) and GeneratePalette then
            begin
              FBitmap.Palette := BuildPalette(jc.d, FInverted);
              PaletteModified := True;
            end;
            DestScanLine := FBitmap.ScanLine[0];
            while (jc.d.output_scanline < jc.d.output_height) do
            begin
              LinesRead := jpeg_read_scanlines(jc.d, @DestScanline, LinesPerCall);
              Inc(TQPLIntPtr(DestScanline), PtrInc * LinesRead);
            end;
            jpeg_finish_output(jc.d);
          end;
          jc.d.dct_method := jc.FinalDCT;
          jc.d.dither_mode := jc.FinalDitherMode;
          if jc.FinalTwoPassQuant then
          begin
            jc.d.two_pass_quantize := True;
            jc.d.colormap := nil;
          end;
          jpeg_start_output(jc.d, jc.d.input_scan_number);
          DestScanLine := FBitmap.ScanLine[0];
        end;

        if (not jc.d.buffered_image or jc.FinalTwoPassQuant) and
          (jc.d.colormap <> nil) and GeneratePalette then
        begin
          FBitmap.Palette := BuildPalette(jc.d, FInverted);
          PaletteModified := True;
          DestScanLine := FBitmap.ScanLine[0];
        end;

        while (jc.d.output_scanline < jc.d.output_height) do
        begin
          LinesRead := jpeg_read_scanlines(jc.d, @DestScanline, LinesPerCall);
          Inc(TQPLIntPtr(DestScanline), PtrInc * LinesRead);
        end;

        if jc.d.out_color_space = JCS_CMYK then ConvertFromCMYK(FInverted);

        if jc.d.buffered_image then jpeg_finish_output(jc.d);
        jpeg_finish_decompress(jc.d);
      finally
        if ExceptObject = nil then
          PtrInc := 100
        else
          PtrInc := 0;
        Progress(Self, psEnding, PtrInc, PaletteModified, Rect(0, 0, 0, 0), '');
        if PaletteModified then
          Changed(Self);
      end;
    except
      on EAbort do ;
    end;
  finally
    ReleaseContext(jc);
  end;
end;

function TPDFJPEGImage.GetEmpty: Boolean;
begin
  Result := (FImage.FData = nil) and ((FBitmap = nil) or FBitmap.Empty);
end;

function TPDFJPEGImage.GetGrayscale: Boolean;
begin
  Result := FGrayscale or FImage.FGrayscale;
end;

function TPDFJPEGImage.GetHeight: Integer;
begin
  if FBitmap <> nil then
    Result := FBitmap.Height
  else if FScale = jsFullSize then
    Result := FImage.FHeight
  else
  begin
    CalcOutputDimensions;
    Result := FScaledHeight;
  end;
end;

function TPDFJPEGImage.GetWidth: Integer;
begin
  if FBitmap <> nil then
    Result := FBitmap.Width
  else if FScale = jsFullSize then
    Result := FImage.FWidth
  else
  begin
    CalcOutputDimensions;
    Result := FScaledWidth;
  end;
end;

procedure TPDFJPEGImage.JPEGNeeded;
begin
  if FImage.FData = nil then
    Compress;
end;

procedure TPDFJPEGImage.LoadFromBitmap(Source: TBitmap);
begin
  Self.Assign(Source);
end;

procedure TPDFJPEGImage.LoadFromClipboardFormat(AFormat: Word; AData: THandle;
  APalette: HPALETTE);
begin
  FBitmap.LoadFromClipboardFormat(AFormat, AData, APalette);
end;

procedure TPDFJPEGImage.LoadFromStream(Stream: TStream);
begin
  ReadStream(Stream.Size - Stream.Position, Stream);
end;

procedure TPDFJPEGImage.NewBitmap;
begin
  FBitmap.Free;
  FBitmap := TBitmap.Create;
end;

procedure TPDFJPEGImage.NewImage;
begin
  if FImage <> nil then FImage.Release;
  FImage := TJPEGData.Create;
  FImage.Reference;
end;

procedure TPDFJPEGImage.ReadData(Stream: TStream);
var
  Size: Integer;
begin
  Stream.Read(Size, SizeOf(Size));
  ReadStream(Size, Stream);
end;

procedure TPDFJPEGImage.ReadStream(Size: Integer; Stream: TStream);
var
  jerr: jpeg_error_mgr;
  cinfo: jpeg_decompress_struct;
begin
  NewImage;
  FBitmap.Free;
  FBitmap := nil;
  with FImage do
  begin
    FData := TMemoryStream.Create;
    FData.Size := Size;
    Stream.ReadBuffer(FData.Memory^, Size);
    if Size > 0 then
    begin
      jerr := jpeg_std_error;  
      cinfo.common.err := @jerr;
      jpeg_CreateDecompress(cinfo, JPEG_LIB_VERSION, sizeof(cinfo));
      try
        FData.Position := 0;
        jpeg_stdio_src(cinfo, FData);
        jpeg_read_header(cinfo, TRUE);
        FWidth := cinfo.image_width;
        FHeight := cinfo.image_height;
        FGrayscale := cinfo.jpeg_color_space = JCS_GRAYSCALE;
        FProgressiveEncoding := jpeg_has_multiple_scans(cinfo);
      finally
        jpeg_destroy_decompress(cinfo);
      end;
    end;
  end;
  PaletteModified := True;
  Changed(Self);
end;

procedure TPDFJPEGImage.SaveBitmapToStream(Stream: TStream);
var
  BM: TBitmap;
begin
  BM := TBitmap.Create;
  try
    BM.Assign(Self);
    BM.Canvas.Lock;
    try
      BM.SaveToStream(Stream);
    finally
      BM.Canvas.Unlock;
    end;
  finally
    BM.Free;
  end;
end;

procedure TPDFJPEGImage.SaveToClipboardFormat(var AFormat: Word; var AData: THandle;
  var APalette: HPALETTE);
begin
  Bitmap.SaveToClipboardFormat(AFormat, AData, APalette);
end;

procedure TPDFJPEGImage.SaveToStream(Stream: TStream);
begin
  JPEGNeeded;
  with FImage.FData do
    Stream.Write(Memory^, Size);
end;

procedure TPDFJPEGImage.SetGrayscale(Value: Boolean);
begin
  if FGrayscale <> Value then
  begin
    FreeBitmap;
    FGrayscale := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

procedure TPDFJPEGImage.SetHeight(Value: Integer);
begin
  //!!
end;

procedure TPDFJPEGImage.SetPixelFormat(Value: TJPEGPixelFormat);
begin
  if FPixelFormat <> Value then
  begin
    FreeBitmap;
    FPixelFormat := Value;
    PaletteModified := True;
    Changed(Self);
  end;
end;

procedure TPDFJPEGImage.SetWidth(Value: Integer);
begin
  //!!
end;

procedure TPDFJPEGImage.WriteData(Stream: TStream);
var
  Size: Integer;
begin
  Size := 0;
  if Assigned(FImage.FData) then Size := FImage.FData.Size;
  Stream.Write(Size, Sizeof(Size));
  if Size > 0 then Stream.Write(FImage.FData.Memory^, Size);
end;

procedure InitDefaults;
var
  DC: HDC;
begin
  DC := GetDC(0);
  if (GetDeviceCaps(DC, BITSPIXEL) * GetDeviceCaps(DC, PLANES)) <= 8 then
    JPEGDefaults.PixelFormat := jf8Bit
  else
    JPEGDefaults.PixelFormat := jf24Bit;
  ReleaseDC(0, DC);
end;

procedure TPDFJPEGImage.ConvertFromCMYK(Invert: Boolean);
var
  Row: Integer;
  Col: Integer;
  Offset: Integer;
  ScanLine: array of Byte;
  RowSize: Integer;
  CMYK: TPDFCMYKColor;
  RGB: TPDFRGBColor;
  PreCalc: array[0..255] of Double;
  MinusPreCalc: array[0..255] of Double;
begin
  for Col := 0 to 255 do
  begin
    PreCalc[Col] := Col / 255;
    MinusPreCalc[Col] := 1 - PreCalc[Col];
  end;

  RowSize := FBitmap.Width * 4;
  SetLength(ScanLine, RowSize);
  for Row := 0 to FBitmap.Height - 1 do
  begin
    Move(FBitmap.ScanLine[Row]^, ScanLine[0], RowSize);
    Offset := 0;
    for Col := 0 to FBitmap.Width - 1 do
    begin
      if Invert then
      begin
        CMYK.Cyan := PreCalc[ScanLine[Offset + 0]];
        CMYK.Magenta := PreCalc[ScanLine[Offset + 1]];
        CMYK.Yellow := PreCalc[ScanLine[Offset + 2]];
        CMYK.Black := PreCalc[ScanLine[Offset + 3]];
      end else
      begin
        CMYK.Cyan := MinusPreCalc[ScanLine[Offset + 0]];
        CMYK.Magenta := MinusPreCalc[ScanLine[Offset + 1]];
        CMYK.Yellow := MinusPreCalc[ScanLine[Offset + 2]];
        CMYK.Black := MinusPreCalc[ScanLine[Offset + 3]];
      end;
      RGB := FColorManager.CMYK2RGB(CMYK);
      ScanLine[Offset + 3] := 0;
      ScanLine[Offset + 0] := Round(RGB.Blue * 255);
      ScanLine[Offset + 1] := Round(RGB.Green * 255);
      ScanLine[Offset + 2] := Round(RGB.Red * 255);

      Inc(Offset, 4);
    end;
    Move(ScanLine[0], FBitmap.ScanLine[Row]^, RowSize);
  end;
  FBitmap.PixelFormat := pf24bit;
end;

procedure TPDFJPEGImage.InvertCMYK;
begin
  if not FInverted then
  begin
    FBitmap.Free;
    FBitmap := nil;
    FInverted := True;
    GetBitmap;
  end;
end;

procedure TPDFJPEGImage.AssignTo(Dest: TPersistent);
begin
  if Dest is TBitmap then
    Dest.Assign(Bitmap)
  else
    inherited AssignTo(Dest);
end;

procedure TPDFJPEGImage.SetColorManager(NewColorManager: TPDFColorManager);
begin
  if Assigned(NewColorManager) then
  begin
    if not FExternalColorManager then FColorManager.Free;
    FColorManager := NewColorManager;
    FExternalColorManager := True;
  end;
end;

procedure DebenuPDFLibraryJPEGInitialization;
begin
  InitDefaults;
end;
{$ENDIF}

{$IFDEF JPEGOBJ}
initialization
  DebenuPDFLibraryJPEGInitialization;
{$ENDIF}
end.
