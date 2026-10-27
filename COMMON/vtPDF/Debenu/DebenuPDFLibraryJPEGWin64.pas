{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryJPEGWin64.pas                          }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryJPEGWin64;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Windows, SysUtils, Classes, Graphics,
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
    property PixelFormat: TJPEGPixelFormat read FPixelFormat write SetPixelFormat;
    property ColorManager: TPDFColorManager read FColorManager write SetColorManager;
    property DPI: Integer read FDPI write FDPI;
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

procedure DebenuPDFLibraryJPEGInitialization;

implementation

uses
  Math,
  DebenuPDFLibraryExtra;

// Set the enumeration size to 4 bytes
{$Z4}

// Set the field alignment to 8 bytes
{$A8}

type
  // 64-bit for size_t
  TQPLJPEGSize = Int64;

  // 32-bit boolean
  TQPLJPEGBoolean = LongBool;

const
  JPEG_LIB_VERSION = 80;
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

  jpeg_marker_parser_method = function(cinfo: j_decompress_ptr): TQPLJPEGBoolean;

  jpeg_saved_marker_ptr = ^jpeg_marker_struct;

  jpeg_marker_struct = record
    next: jpeg_saved_marker_ptr;
    marker: Byte;
    original_length: LongWord;
    data_length: LongWord;
    data: JOCTETPTR;
  end;

  jpeg_marker_reader_ptr = ^jpeg_marker_reader;
  jpeg_marker_reader = record
    reset_marker_reader: procedure(cinfo: j_decompress_ptr);

    read_markers: function (cinfo: j_decompress_ptr): Integer;
    read_restart_marker: jpeg_marker_parser_method;
    saw_SOI: TQPLJPEGBoolean;
    saw_SOF: TQPLJPEGBoolean;
    next_restart_num: Integer;
    discarded_bytes: UINT;

    process_COM: jpeg_marker_parser_method;
    process_APPn: array[0..15] of jpeg_marker_parser_method;

    length_limit_COM: Cardinal;
    length_limit_APPn: array[0..15] of Cardinal;

    cur_marker: jpeg_saved_marker_ptr;
    bytes_read: Cardinal;
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
    free_in_buffer: TQPLJPEGSize;
    init_destination: procedure (cinfo: j_compress_ptr);
    empty_output_buffer: function (cinfo: j_compress_ptr): TQPLJPEGBoolean;
    term_destination: procedure (cinfo: j_compress_ptr);
  end;

  jpeg_source_mgr_ptr = ^jpeg_source_mgr;
  jpeg_source_mgr = record
    next_input_byte: JOCTETptr;
    bytes_in_buffer: TQPLJPEGSize;
    init_source: procedure (cinfo: j_decompress_ptr);
    fill_input_buffer: function (cinfo: j_decompress_ptr): TQPLJPEGBoolean;
    skip_input_data: procedure (cinfo: j_decompress_ptr; num_bytes: Integer);
    resync_to_restart: function (cinfo: j_decompress_ptr;
                                  desired: Integer): TQPLJPEGBoolean;
    term_source: procedure (cinfo: j_decompress_ptr);

    infile: TStream;
    buffer: PByte;
    start_of_file: Boolean;
  end;

  jpeg_memory_mgr_ptr = ^jpeg_memory_mgr;
  jpeg_memory_mgr = record
    alloc_small: function (cinfo: j_common_ptr;
                            pool_id: Integer; sizeofobject: TQPLJPEGSize): pointer;
    alloc_large: function (cinfo: j_common_ptr;
                            pool_id: Integer; sizeofobject: TQPLJPEGSize): pointer;
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
    is_decompressor: TQPLJPEGBoolean;
    global_state: Integer;
  end;

  jpeg_progress_mgr = record
    progress_monitor: procedure(const cinfo: jpeg_common_struct);
    pass_counter: Integer;
    pass_limit: Integer;
    completed_passes: Integer;
    total_passes: Integer;
//    instance: TPDFJPEGImage;
//    last_pass: Integer;
//    last_pct: Integer;
//    last_time: Integer;
//    last_scanline: Integer;
  end;

  jpeg_compress_struct = record
    common: jpeg_common_struct;
    dest: jpeg_destination_mgr_ptr;

    image_width: JDIMENSION;
    image_height: JDIMENSION;
    input_components: Integer;
    in_color_space: J_COLOR_SPACE;
    input_gamma: double;

    scale_num, scale_denom: Cardinal;
    jpeg_width: JDIMENSION;
    jpeg_height: JDIMENSION;

    data_precision: Integer;
    num_components: Integer;
    jpeg_color_space: J_COLOR_SPACE;
    comp_info: Pointer;
    quant_tbl_ptrs: array[0..NUM_QUANT_TBLS-1] of Pointer;

    q_scale_factor: array[0..NUM_QUANT_TBLS-1] of Integer;

    dc_huff_tbl_ptrs: array[0..NUM_HUFF_TBLS-1] of Pointer;
    ac_huff_tbl_ptrs: array[0..NUM_HUFF_TBLS-1] of Pointer;
    arith_dc_L: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_dc_U: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_ac_K: array[0..NUM_ARITH_TBLS-1] of UINT8;
    num_scans: Integer;
    scan_info: Pointer;
    raw_data_in: TQPLJPEGBoolean;
    arith_code: TQPLJPEGBoolean;
    optimize_coding: TQPLJPEGBoolean;
    CCIR601_sampling: TQPLJPEGBoolean;
    do_fancy_downsampling: TQPLJPEGBoolean;
    smoothing_factor: Integer;
    dct_method: J_DCT_METHOD;
    restart_interval: UINT;
    restart_in_rows: Integer;

    write_JFIF_header: TQPLJPEGBoolean;
    JFIF_major_version: UINT8;
    JFIF_minor_version: UINT8;
    density_unit: UINT8;
    X_density: UINT16;
    Y_density: UINT16;
    write_Adobe_marker: TQPLJPEGBoolean;

    next_scanline: JDIMENSION;

    progressive_mode: TQPLJPEGBoolean;

    max_h_samp_factor: Integer;
    max_v_samp_factor: Integer;

    min_DCT_h_scaled_size: Integer;
    min_DCT_v_scaled_size: Integer;

    total_iMCU_rows: JDIMENSION;
    comps_in_scan: Integer;
    cur_comp_info: array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
    MCUs_per_row: JDIMENSION;
    MCU_rows_in_scan: JDIMENSION;
    blocks_in_MCU: Integer;
    MCU_membership: array[0..C_MAX_BLOCKS_IN_MCU-1] of Integer;
    Ss, Se, Ah, Al: Integer;

    block_size: Integer;
    natural_order: Pointer;
    lim_Se: Integer;

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
    buffered_image: TQPLJPEGBoolean;
    raw_data_out: TQPLJPEGBoolean;
    dct_method: J_DCT_METHOD;
    do_fancy_upsampling: TQPLJPEGBoolean;
    do_block_smoothing: TQPLJPEGBoolean;
    quantize_colors: TQPLJPEGBoolean;
    dither_mode: J_DITHER_MODE;
    two_pass_quantize: TQPLJPEGBoolean;
    desired_number_of_colors: Integer;
    enable_1pass_quant: TQPLJPEGBoolean;
    enable_external_quant: TQPLJPEGBoolean;
    enable_2pass_quant: TQPLJPEGBoolean;

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
    is_baseline: TQPLJPEGBoolean;
    progressive_mode: TQPLJPEGBoolean;
    arith_code: TQPLJPEGBoolean;

    arith_dc_L: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_dc_U: array[0..NUM_ARITH_TBLS-1] of UINT8;
    arith_ac_K: array[0..NUM_ARITH_TBLS-1] of UINT8;

    restart_interval: UINT;

    saw_JFIF_marker: TQPLJPEGBoolean;
    JFIF_major_version: UINT8;
    JFIF_minor_version: UINT8;
    density_unit: UINT8;

    X_density: UINT16;
    Y_density: UINT16;

    saw_Adobe_marker: TQPLJPEGBoolean;
    Adobe_transform: UINT8;
    CCIR601_sampling: TQPLJPEGBoolean;

    marker_list: jpeg_saved_marker_ptr;

    max_h_samp_factor: Integer;
    max_v_samp_factor: Integer;
    min_DCT_h_scaled_size: Integer;
    min_DCT_v_scaled_size: Integer;
    total_iMCU_rows: JDIMENSION;

    sample_range_limit: Pointer;

    comps_in_scan: Integer;

    cur_comp_info: array[0..MAX_COMPS_IN_SCAN-1] of Pointer;
    MCUs_per_row: JDIMENSION;
    MCU_rows_in_scan: JDIMENSION;
    blocks_in_MCU: JDIMENSION;
    MCU_membership: array[0..D_MAX_BLOCKS_IN_MCU-1] of Integer;
    Ss, Se, Ah, Al: Integer;

    block_size: Integer;
    natural_order: Pointer;
    lim_Se: Integer;

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
    FinalTwoPassQuant: TQPLJPEGBoolean;
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

var
  _fltused: Cardinal = 1;

var
  __turboFloat: LongBool = False;

function _ftol: Integer; external 'MSVCRT.dll';

function sscanf(s, format: PAnsiChar): Integer;
begin
  Result := 0;
end;

function getenv(name: PAnsiChar): PAnsiChar;
begin
  Result := nil;
end;

function fseek(stream: TStream; offset, origin: Integer): Integer;
begin
  if (origin = 0) then
  begin
    stream.Seek(offset, soFromBeginning);
  end else
  if (origin = 1) then
  begin
    stream.Seek(offset, soFromCurrent);
  end else
  if (origin = 2) then
  begin
    stream.Seek(offset, soFromEnd);
  end;
  Result := 0;
end;

function fclose(stream: THandle): Integer;
begin
  Result := 0;
end;

function strncpy(s1, s2: PAnsiChar; maxlen: Integer): PAnsiChar; external 'MSVCRT.dll';
function tmpfile: THandle; external 'MSVCRT.dll';
function malloc(size: Int64): Pointer; external 'MSVCRT.dll';
procedure free(P: Pointer); external 'MSVCRT.dll';
function memset(P: Pointer; B: Integer; Count: Int64): Pointer; external 'MSVCRT.dll';
function memcpy(dest, source: Pointer; count: TQPLJPEGSize): Pointer; external 'MSVCRT.dll';


// stdio to TStream interface

function fread(var buf; recsize, reccount: TQPLJPEGSize; S: TStream): Integer;
begin
  Result := S.Read(buf, recsize * reccount);
end;

function fwrite(const buf; recsize, reccount: TQPLJPEGSize; S: TStream): Integer;
begin
  Result := S.Write(buf, recsize * reccount);
end;

function fflush(S: TStream): Integer; cdecl;
begin
  Result := 0;
end;

function ferror(FileHandle: THandle): Integer; cdecl;
begin
  Result := 0;
end;


// Error handling

procedure JpegError(cinfo: j_common_ptr);
begin

end;

procedure EmitMessage(cinfo: j_common_ptr; msg_level: Integer);
begin

end;

procedure OutputMessage(cinfo: j_common_ptr);
begin

end;

procedure FormatMessage(cinfo: j_common_ptr; buffer: PAnsiChar);
begin

end;

procedure ResetErrorMgr(cinfo: j_common_ptr);
begin
  if (Assigned(cinfo)) then
  begin
    if (Assigned(cinfo^.err)) then
    begin
      cinfo^.err^.num_warnings := 0;
      cinfo^.err^.msg_code := 0;
    end;
  end;
end;

const
  jpeg_std_error: jpeg_error_mgr = (
    error_exit: JpegError;
    emit_message: EmitMessage;
    output_message: OutputMessage;
    format_message: FormatMessage;
    reset_error_mgr: ResetErrorMgr);


  // Expansion of the V() macro from the C source

  jpeg_aritab: array[0..113] of Integer = (
    $5A1D0181, $2586020E, $11140310, $080B0412, $03D80514, $01DA0617,
    $00E50719, $006F081C, $0036091E, $001A0A21, $000D0B23, $00060C09,
    $00030D0A, $00010D0C, $5A7F0F8F, $3F251024, $2CF21126, $207C1227,
    $17B91328, $1182142A, $0CEF152B, $09A1162D, $072F172E, $055C1830,
    $04061931, $03031A33, $02401B34, $01B11C36, $01441D38, $00F51E39,
    $00B71F3B, $008A203C, $0068213E, $004E223F, $003B2320, $002C0921,
    $5AE125A5, $484C2640, $3A0D2741, $2EF12843, $261F2944, $1F332A45,
    $19A82B46, $15182C48, $11772D49, $0E742E4A, $0BFB2F4B, $09F8304D,
    $0861314E, $0706324F, $05CD3330, $04DE3432, $040F3532, $03633633,
    $02D43734, $025C3835, $01F83936, $01A43A37, $01603B38, $01253C39,
    $00F63D3A, $00CB3E3B, $00AB3F3D, $008F203D, $5B1241C1, $4D044250,
    $412C4351, $37D84452, $2FE84553, $293C4654, $23794756, $1EDF4857,
    $1AA94957, $174E4A48, $14244B48, $119C4C4A, $0F6B4D4A, $0D514E4B,
    $0BB64F4D, $0A40304D, $583251D0, $4D1C5258, $438E5359, $3BDD545A,
    $34EE555B, $2EAE565C, $299A575D, $25164756, $557059D8, $4CA95A5F,
    $44D95B60, $3E225C61, $38245D63, $32B45E63, $2E17565D, $56A860DF,
    $4F466165, $47E56266, $41CF6367, $3C3D6468, $375E5D63, $52316669,
    $4C0F676A, $4639686B, $415E6367, $56276AE9, $50E76B6C, $4B85676D,
    $55976D6E, $504F6B6F, $5A106FEE, $55226D70, $59EB6FF0, $5A1D7171);

{$L obj64\jaricom.obj}
{$L obj64\jcapimin.obj}
{$L obj64\jcapistd.obj}
{$L obj64\jcarith.obj}
{$L obj64\jccoefct.obj}
{$L obj64\jccolor.obj}
{$L obj64\jcdctmgr.obj}
{$L obj64\jchuff.obj}
{$L obj64\jcinit.obj}
{$L obj64\jcmainct.obj}
{$L obj64\jcmarker.obj}
{$L obj64\jcmaster.obj}
{$L obj64\jcomapi.obj}
{$L obj64\jcparam.obj}
{$L obj64\jcprepct.obj}
{$L obj64\jcsample.obj}
{$L obj64\jctrans.obj}
{$L obj64\jdapimin.obj}
{$L obj64\jdapistd.obj}
{$L obj64\jdarith.obj}
{$L obj64\jdatadst.obj}
{$L obj64\jdatasrc.obj}
{$L obj64\jdcoefct.obj}
{$L obj64\jdcolor.obj}
{$L obj64\jddctmgr.obj}
{$L obj64\jdhuff.obj}
{$L obj64\jdinput.obj}
{$L obj64\jdmainct.obj}
{$L obj64\jdmarker.obj}
{$L obj64\jdmaster.obj}
{$L obj64\jdmerge.obj}
{$L obj64\jdpostct.obj}
{$L obj64\jdsample.obj}
{$L obj64\jdtrans.obj}

// jerror.obj is not needed because we provide our own
// error handler
// {$L obj64\jerror.obj}

{$L obj64\jfdctflt.obj}
{$L obj64\jfdctfst.obj}
{$L obj64\jfdctint.obj}
{$L obj64\jidctflt.obj}
{$L obj64\jidctfst.obj}
{$L obj64\jidctint.obj}
{$L obj64\jmemmgr.obj}
{$L obj64\jquant1.obj}
{$L obj64\jquant2.obj}
{$L obj64\jutils.obj}

// Internal test function
// {$L obj64\QuickPDFLibJPEG.obj}

// Neither jmemansi.obj and jmemnobs.obj are needed because
// we use malloc/free from MSVCRT
// {$L obj64\jmemansi.obj}
// {$L obj64\jmemnobs.obj}

procedure jpeg_suppress_tables(cinfo: Pointer; suppress: TQPLJPEGBoolean); cdecl; external;
procedure jinit_huff_encoder(cinfo: Pointer); cdecl; external;
procedure jinit_arith_encoder(cinfo: Pointer); cdecl; external;
procedure jinit_forward_dct(cinfo: Pointer); cdecl; external;
procedure jinit_color_converter(cinfo: Pointer); cdecl; external;
function jpeg_alloc_quant_table(cinfo: Pointer): Pointer; cdecl; external;
procedure jinit_c_coef_controller(cinfo: Pointer; need_full_buffer: TQPLJPEGBoolean); cdecl; external;
procedure jpeg_core_output_dimensions(cinfo: Pointer); cdecl; external;
procedure jinit_d_main_controller(cinfo: Pointer; need_full_buffer: TQPLJPEGBoolean); cdecl; external;
procedure jinit_d_coef_controller(cinfo: Pointer; need_full_buffer: TQPLJPEGBoolean); cdecl; external;
procedure jinit_huff_decoder(cinfo: Pointer); cdecl; external;
procedure jinit_arith_decoder(cinfo: Pointer); cdecl; external;
procedure jinit_color_deconverter(cinfo: Pointer); cdecl; external;
procedure jinit_inverse_dct(cinfo: Pointer); cdecl; external;


// Memory interface
function jpeg_get_small(cinfo: Pointer; sizeofobject: Int64): Pointer; cdecl;
begin
  Result := malloc(sizeofobject);
end;

function jpeg_get_large(cinfo: Pointer; sizeofobject: Int64): Pointer; cdecl;
begin
  Result := malloc(sizeofobject);
end;

procedure jpeg_open_backing_store(cinfo, info: Pointer; total_bytes_needed: Integer); cdecl;
begin

end;

function jpeg_mem_available(cinfo: Pointer; min_bytes_needed, max_bytes_needed, already_allocated: Integer): Integer; cdecl;
begin
  Result := 10000000;
end;

procedure jpeg_free_small(cinfo, aobject: Pointer; sizeofobject: Int64); cdecl;
begin
  free(aobject);
end;

procedure jpeg_free_large(cinfo, aobject: Pointer; sizeofobject: Int64); cdecl;
begin
  free(aobject);
end;

procedure jpeg_mem_term(cinfo: Pointer); cdecl;
begin

end;

function jpeg_mem_init(cinfo: Pointer): Integer; cdecl;
begin
  Result := 10000000;
end;

procedure jpeg_CreateDecompress (var cinfo: jpeg_decompress_struct; version: integer; structsize: TQPLJPEGSize); cdecl; external;
procedure jpeg_stdio_src(var cinfo: jpeg_decompress_struct; input_file: TStream); cdecl; external;
procedure jpeg_read_header(var cinfo: jpeg_decompress_struct; RequireImage: TQPLJPEGBoolean); cdecl; external;
procedure jpeg_calc_output_dimensions(var cinfo: jpeg_decompress_struct); cdecl; external;
procedure jpeg_save_markers(var cinfo: jpeg_decompress_struct; marker_code: Integer; length_limit: UINT); cdecl; external;
function jpeg_start_decompress(var cinfo: jpeg_decompress_struct): TQPLJPEGBoolean; cdecl; external;
function jpeg_read_scanlines(var cinfo: jpeg_decompress_struct; scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; cdecl; external;
function jpeg_finish_decompress(var cinfo: jpeg_decompress_struct): TQPLJPEGBoolean; cdecl; external;
procedure jpeg_destroy_decompress (var cinfo: jpeg_decompress_struct); cdecl; external;
function jpeg_has_multiple_scans(var cinfo: jpeg_decompress_struct): TQPLJPEGBoolean; cdecl; external;
function jpeg_consume_input(var cinfo: jpeg_decompress_struct): Integer; cdecl; external;
function jpeg_start_output(var cinfo: jpeg_decompress_struct; scan_number: Integer): TQPLJPEGBoolean; cdecl; external;
function jpeg_finish_output(var cinfo: jpeg_decompress_struct): TQPLJPEGBoolean; cdecl; external;
procedure jpeg_destroy(var cinfo: jpeg_common_struct); cdecl; external;

procedure jpeg_CreateCompress (var cinfo: jpeg_compress_struct;
  version: integer; structsize: TQPLJPEGSize); external;
procedure jpeg_stdio_dest(var cinfo: jpeg_compress_struct;
  output_file: TStream); external;
procedure jpeg_set_defaults(var cinfo: jpeg_compress_struct); external;
procedure jpeg_set_quality(var cinfo: jpeg_compress_struct; Quality: Integer;
  Baseline: TQPLJPEGBoolean); external;
procedure jpeg_set_colorspace(var cinfo: jpeg_compress_struct;
  colorspace: J_COLOR_SPACE); external;
procedure jpeg_simple_progression(var cinfo: jpeg_compress_struct); external;
procedure jpeg_start_compress(var cinfo: jpeg_compress_struct;
  WriteAllTables: TQPLJPEGBoolean); external;
function jpeg_write_scanlines(var cinfo: jpeg_compress_struct;
  scanlines: JSAMPARRAY; max_lines: JDIMENSION): JDIMENSION; external;
procedure jpeg_finish_compress(var cinfo: jpeg_compress_struct); external;

{type
  EJPEG = class(EInvalidGraphic);

procedure InvalidOperation(const Msg: AnsiString);
begin
  //!!
end;}


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
begin
  if (cinfo.progress = nil) then Exit;
  with cinfo.progress^ do
  begin

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
//    jc.progress.progress_monitor := ProgressCallback;
//    jc.progress.instance := Obj;
//    jc.common.progress := @jc.progress;

    Obj.FImage.FData.Position := 0;
    jpeg_stdio_src(jc.d, FImage.FData);
    jpeg_read_header(jc.d, TQPLJPEGBoolean(TRUE));

    jc.d.scale_num := 1;
    jc.d.scale_denom := 1 shl Byte(FScale);
    jc.d.do_block_smoothing := TQPLJPEGBoolean(FSmoothing);

    if FGrayscale then jc.d.out_color_space := JCS_GRAYSCALE;
    if (PixelFormat = jf8Bit) or (jc.d.out_color_space = JCS_GRAYSCALE) then
    begin
      jc.d.quantize_colors := TQPLJPEGBoolean(True);
      jc.d.desired_number_of_colors := 236;
    end;

    if FPerformance = jpBestSpeed then
    begin
      jc.d.dct_method := JDCT_IFAST;
      jc.d.two_pass_quantize := TQPLJPEGBoolean(False);
      jc.d.dither_mode := JDITHER_ORDERED;
    end;

    jc.FinalDCT := jc.d.dct_method;
    jc.FinalTwoPassQuant := TQPLJPEGBoolean(jc.d.two_pass_quantize);
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
    FProgressiveEncoding := Boolean(jpeg_has_multiple_scans(jc.d));
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
  LinesWritten: Integer;
  SrcScanLine: Pointer;
  jc: TJPEGContext;
  Src: TBitmap;
  Row: Integer;
  SwapData: array of Byte;
  Temp: Byte;
  Col: Integer;
begin
  FillChar(jc, sizeof(jc), 0);
  jc.err := jpeg_std_error;
  jc.common.err := @jc.err;

  jpeg_CreateCompress(jc.c, JPEG_LIB_VERSION, sizeof(jc.c));
  try
    try
//      jc.progress.progress_monitor := ProgressCallback;
//      jc.progress.instance := Self;
//      jc.common.progress := @jc.progress;

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

        SetLength(SwapData, Src.Width * 3);

        jpeg_set_defaults(jc.c);

        jc.c.density_unit := 1;    // 1 = dpi
        jc.c.X_density := FDPI;
        jc.c.Y_density := FDPI;

        jpeg_set_quality(jc.c, FQuality, TQPLJPEGBoolean(True));

        if FGrayscale then
        begin
          FImage.FGrayscale := True;
          jpeg_set_colorspace(jc.c, JCS_GRAYSCALE);
        end;

        Progress(Self, psStarting, 0, False, Rect(0, 0, 0, 0), '');
        try
          jpeg_start_compress(jc.c, TQPLJPEGBoolean(True));

          for Row := 0 to Src.Height - 1 do
          begin
            Move(Src.ScanLine[Row]^, SwapData[0], Src.Width * 3);
            for Col := 0 to Src.Width - 1 do
            begin
              Temp := SwapData[Col * 3];
              SwapData[Col * 3] := SwapData[Col * 3 + 2];
              SwapData[Col * 3 + 2] := Temp;
            end;

            SrcScanLine := @SwapData[0];
            LinesWritten := jpeg_write_scanlines(jc.c, @SrcScanLine, 1);
          end;

          jpeg_finish_compress(jc.c);
        finally
          Progress(Self, psEnding, 100, False, Rect(0, 0, 0, 0), '');
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

        if Boolean(jc.d.buffered_image) then
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
          if Boolean(jc.FinalTwoPassQuant) then
          begin
            jc.d.two_pass_quantize := TQPLJPEGBoolean(True);
            jc.d.colormap := nil;
          end;
          jpeg_start_output(jc.d, jc.d.input_scan_number);
          DestScanLine := FBitmap.ScanLine[0];
        end;

        if (not Boolean(jc.d.buffered_image) or Boolean(jc.FinalTwoPassQuant)) and
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

        if Boolean(jc.d.buffered_image) then jpeg_finish_output(jc.d);
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
        jpeg_read_header(cinfo, TQPLJPEGBoolean(TRUE));
        FWidth := cinfo.image_width;
        FHeight := cinfo.image_height;
        FGrayscale := cinfo.jpeg_color_space = JCS_GRAYSCALE;
        FProgressiveEncoding := Boolean(jpeg_has_multiple_scans(cinfo));
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
  ScanLine: array of Byte;
  RowSize: Integer;
  CMYK: TPDFCMYKColor;
  RGB: TPDFRGBColor;
begin
  RowSize := FBitmap.Width * 4;
  SetLength(ScanLine, RowSize);
  for Row := 0 to FBitmap.Height - 1 do
  begin
    Move(FBitmap.ScanLine[Row]^, ScanLine[0], RowSize);
    for Col := 0 to FBitmap.Width - 1 do
    begin
      if Invert then
      begin
        CMYK.Cyan := ScanLine[Col * 4 + 0] / 255;
        CMYK.Magenta := ScanLine[Col * 4 + 1] / 255;
        CMYK.Yellow := ScanLine[Col * 4 + 2] / 255;
        CMYK.Black := ScanLine[Col * 4 + 3] / 255;
      end else
      begin
        CMYK.Cyan := 1 - ScanLine[Col * 4 + 0] / 255;
        CMYK.Magenta := 1 - ScanLine[Col * 4 + 1] / 255;
        CMYK.Yellow := 1 - ScanLine[Col * 4 + 2] / 255;
        CMYK.Black := 1 - ScanLine[Col * 4 + 3] / 255;
      end;
      RGB := FColorManager.CMYK2RGB(CMYK);
      ScanLine[Col * 4 + 3] := 0;
{$IFDEF WIN64}
      ScanLine[Col * 4 + 0] := Round(RGB.Blue * 255);
      ScanLine[Col * 4 + 1] := Round(RGB.Green * 255);
      ScanLine[Col * 4 + 2] := Round(RGB.Red * 255);
{$ELSE}
      ScanLine[Col * 4 + 0] := Round(RGB.Red * 255);
      ScanLine[Col * 4 + 1] := Round(RGB.Green * 255);
      ScanLine[Col * 4 + 2] := Round(RGB.Blue * 255);
{$ENDIF}
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

initialization
  DebenuPDFLibraryJPEGInitialization;
end.
