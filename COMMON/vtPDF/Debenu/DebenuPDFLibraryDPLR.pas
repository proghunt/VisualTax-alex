{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryDPLR.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryDPLR;

{$OPTIMIZATION ON}

interface

uses Windows, DebenuPDFLibraryTypes, DebenuPDFLibraryPatterns, DebenuPDFLibraryFunctions ,
  DebenuPDFLibraryColorManagement, DebenuPDFLibrarySoftmask;

type
  DPLR_line_cap_t = (
    DPLR_LINE_CAP_BUTT,
    DPLR_LINE_CAP_ROUND,
    DPLR_LINE_CAP_SQUARE
  );

  DPLR_line_join_t = (
    DPLR_LINE_JOIN_MITER,
    DPLR_LINE_JOIN_ROUND,
    DPLR_LINE_JOIN_BEVEL
  );

  DPLR_fill_rule_t = (
    DPLR_FILL_RULE_WINDING,
    DPLR_FILL_RULE_EVEN_ODD
  );

 DPLR_operator_t = (
    DPLR_OPERATOR_NORMAL,
    DPLR_OPERATOR_MULTIPLY,
    DPLR_OPERATOR_SCREEN,
    DPLR_OPERATOR_OVERLAY,
    DPLR_OPERATOR_DARKEN,
    DPLR_OPERATOR_LIGHTEN,
    DPLR_OPERATOR_COLOR_DODGE,
    DPLR_OPERATOR_COLOR_BURN,
    DPLR_OPERATOR_HARD_LIGHT,
    DPLR_OPERATOR_SOFT_LIGHT,
    DPLR_OPERATOR_DIFFERENCE,
    DPLR_OPERATOR_EXCLUSION,
    DPLR_OPERATOR_HSL_HUE,
    DPLR_OPERATOR_HSL_SATURATION,
    DPLR_OPERATOR_HSL_COLOR,
    DPLR_OPERATOR_HSL_LUMINOSITY
  );

  DPLR_rendererFormat_t = (
    DPLR_FORMAT
  );

  DPLR_status_t = (
    DPLR_ERROR,
    DPLR_SUCCESS
  );

type
  // Callback function type
  DPLR_shading_func_t = function (sh: Pointer; data: PDouble; length: Integer; red, green, blue: PDouble): DPLR_status_t; cdecl;
  DPLR_softmask_func_t = function (sm: Pointer; data: Double; value: PDouble): DPLR_status_t; cdecl;

  // Renderer
  TDPLR_renderer_destroy = procedure(dr: PDPLR_renderer_t ); cdecl;
  TDPLR_renderer_win32_create = function(hdc: HDC): PDPLR_renderer_t; cdecl;
  TDPLR_renderer_create = function(w: Integer; h: Integer): PDPLR_renderer_t; cdecl;
  TDPLR_renderer_draw_to_DC = function(dr: PDPLR_renderer_t; hdc: HDC; w: Integer; h: Integer; bpp: Integer):DPLR_status_t; cdecl;
  TDPLR_renderer_draw_to_memory = function(dr: PDPLR_renderer_t; data: PByte; width, height, bpp: Integer): DPLR_status_t; cdecl;
  TDPLR_renderer_group_create = function(parent: PDPLR_renderer_t; transparency: Integer; knockout: Integer; isolated: Integer):PDPLR_renderer_t; cdecl;
  TDPLR_renderer_blend_group = function(dr: PDPLR_renderer_t; alpha:Double; blending: Integer):DPLR_status_t; cdecl;
  TDPLR_renderer_clear_surface = function(dr: PDPLR_renderer_t; red, green, blue, alpha: Double):DPLR_status_t; cdecl;
  TDPLR_renderer_set_softmask = function(dr: PDPLR_renderer_t; sType: Integer; func: DPLR_softmask_func_t; sh: Pointer):DPLR_status_t; cdecl;
  TDPLR_renderer_clear_softmask = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_renderer_tile_create = function(width, height: Integer):PDPLR_renderer_t; cdecl;
  TDPLR_renderer_tile_copy_buffer = procedure(dr: PDPLR_renderer_t; tb: PByte); cdecl;
  TDPLR_renderer_has_softmask = function(dr: PDPLR_renderer_t):Integer; cdecl;

  TDPLR_save = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_restore = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_set_matrix = procedure(dr: PDPLR_renderer_t; sx: Double; shy: Double; shx: Double; sy: Double; tx: Double; ty: Double); cdecl;
  TDPLR_set_page_matrix = procedure(dr: PDPLR_renderer_t; sx: Double; shy: Double; shx: Double; sy: Double; tx: Double; ty: Double); cdecl;
  TDPLR_set_clip = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_set_bin_clip = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_set_image_clip = function(dr: PDPLR_renderer_t; data: PByte; width, height, stride, interpolate: Integer; palette: PByte):DPLR_status_t; cdecl;
  TDPLR_intersect_clip = function(dr: PDPLR_renderer_t; left, top, right, bottom : Double):Integer; cdecl;
  TDPLR_has_clip = function(dr: PDPLR_renderer_t):Integer; cdecl;

  TDPLR_set_text_clip = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_add_to_text_clip = procedure(dr: PDPLR_renderer_t); cdecl;
  TDPLR_clear_text_clip = procedure(dr: PDPLR_renderer_t); cdecl;

  // Path
  TDPLR_new_path = procedure(dr: PDPLR_renderer_t); cdecl;
  TDPLR_clear_path = procedure(dr: PDPLR_renderer_t); cdecl;
  TDPLR_move_to = procedure(dr: PDPLR_renderer_t; x: Double; y: Double); cdecl;
  TDPLR_line_to = procedure(dr: PDPLR_renderer_t; x: Double; y: Double); cdecl;
  TDPLR_curve_to = procedure(dr: PDPLR_renderer_t; x1: Double; y1: Double;
      x2: Double; y2: Double; x3: Double; y3: Double); cdecl;
  TDPLR_rectangle = procedure(dr: PDPLR_renderer_t; x: Double; y: Double; width: Double; height: Double); cdecl;
  TDPLR_close_path = procedure(dr: PDPLR_renderer_t); cdecl;
  TDPLR_fill_path = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_stroke_path = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;
  TDPLR_stroke_and_fill_path = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;

  // Image
  TDPLR_draw_image = function(dr: PDPLR_renderer_t; data: PByte; width, height, stride, format, interpolate: Integer; minC, maxC: Integer):DPLR_status_t; cdecl;
  TDPLR_draw_palette_image = function(dr: PDPLR_renderer_t; data: PByte; width, height, stride, format, interpolate: Integer; palette: PByte; minC, maxC: Integer):DPLR_status_t; cdecl;

  // Shading
  TDPLR_shading_init = procedure(dr: PDPLR_renderer_t; sType: Integer; shType: Integer); cdecl;
  TDPLR_shading_set_bBox = procedure(dr: PDPLR_renderer_t; sType: Integer; bBox: Integer; left: Double; top: Double; right: Double; bottom: Double); cdecl;
  TDPLR_shading_set_background_color = procedure(dr: PDPLR_renderer_t; sType: Integer; red: Double; green: Double; blue: Double); cdecl;
  TDPLR_shading_set_domain = procedure(dr: PDPLR_renderer_t; sType: Integer; xmin: Double; xmax: Double; ymin: Double; ymax: Double); cdecl;
  TDPLR_shading_set_coords = procedure(dr: PDPLR_renderer_t; sType: Integer; coord0: Double; coord1: Double; coord2: Double; coord3: Double; coord4: Double; coord5: Double); cdecl;
  TDPLR_shading_set_extend = procedure(dr: PDPLR_renderer_t; sType: Integer; e0: Integer; e1: Integer); cdecl;
  TDPLR_shading_set_matrix = procedure(dr: PDPLR_renderer_t; sType: Integer; sx: Double; shy: Double; shx: Double; sy: Double; tx: Double; ty: Double); cdecl;
  TDPLR_shading_set_shading_matrix = procedure(dr: PDPLR_renderer_t; sType: Integer; sx: Double; shy: Double; shx: Double; sy: Double; tx: Double; ty: Double); cdecl;
  TDPLR_shading_set_function = procedure(dr: PDPLR_renderer_t; sType: Integer; func: DPLR_shading_func_t; sh: Pointer); cdecl;
  TDPLR_shading_set_color_components = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Integer); cdecl;
  TDPLR_shading_set_bitsPerCoordinate = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Integer); cdecl;
  TDPLR_shading_set_bitsPerComponent = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Integer); cdecl;
  TDPLR_shading_set_bitsPerFlag = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Integer); cdecl;
  TDPLR_shading_set_verticesPerRow = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Integer); cdecl;
  TDPLR_shading_set_decode = procedure(dr: PDPLR_renderer_t; sType: Integer; decode: PDouble; length: Integer); cdecl;
  TDPLR_shading_set_stream = procedure(dr: PDPLR_renderer_t; sType: Integer; stream: AnsiString; length: Integer); cdecl;
  TDPLR_draw_shading = function(dr: PDPLR_renderer_t):DPLR_status_t; cdecl;

  // Pattern
  TDPLR_pattern_init = procedure(dr: PDPLR_renderer_t; sType: Integer; ptType: Integer); cdecl;
  TDPLR_pattern_set_matrix = procedure(dr: PDPLR_renderer_t; sType: Integer; sx: Double; shy: Double; shx: Double; sy: Double; tx: Double; ty: Double); cdecl;
  TDPLR_pattern_set_bBox = procedure(dr: PDPLR_renderer_t; sType: Integer; bBox: Integer; left: Double; top: Double; right: Double; bottom: Double); cdecl;
  TDPLR_pattern_set_stepX = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Double); cdecl;
  TDPLR_pattern_set_stepY = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Double); cdecl;
  TDPLR_pattern_set_tilingType = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Integer); cdecl;
  TDPLR_pattern_set_paintType = procedure(dr: PDPLR_renderer_t; sType: Integer; value: Integer); cdecl;
  TDPLR_pattern_set_tile_buffer =  procedure(dr: PDPLR_renderer_t; sType: Integer; tb: PByte); cdecl;
  TDPLR_pattern_set_tile_size = procedure(dr: PDPLR_renderer_t; sType: Integer; w,h: Integer); cdecl;
  // Graphics state
  TDPLR_gState_init = procedure(dr: PDPLR_renderer_t); cdecl;
  TDPLR_set_fill_rgba = procedure(dr: PDPLR_renderer_t; red, green, blue: Double); cdecl;
  TDPLR_set_stroke_rgba = procedure(dr: PDPLR_renderer_t; red, green, blue: Double); cdecl;
  TDPLR_set_line_width = procedure(dr: PDPLR_renderer_t; width: Double); cdecl;
  TDPLR_set_line_cap = procedure(dr: PDPLR_renderer_t; line_cap: DPLR_line_cap_t); cdecl;
  TDPLR_set_line_join = procedure(dr: PDPLR_renderer_t; line_join: DPLR_line_join_t); cdecl;
  TDPLR_set_dash = procedure(dr: PDPLR_renderer_t; dashes: PDouble; num_dashes: Integer; offset: Double); cdecl;
  TDPLR_set_miter_limit = procedure(dr: PDPLR_renderer_t; limit: Double); cdecl;
  TDPLR_set_fill_alpha = procedure(dr: PDPLR_renderer_t; alpha: Double); cdecl;
  TDPLR_set_stroke_alpha = procedure(dr: PDPLR_renderer_t; alpha: Double); cdecl;
  TDPLR_set_operator = procedure(dr: PDPLR_renderer_t; op: Integer); cdecl;

  TDPLR_set_fill_rule = procedure(dr: PDPLR_renderer_t; fillRule: DPLR_fill_rule_t); cdecl;


  // Wrapper DLL

  TDebenuPDFLibraryDPLR = class
  private
    DLLHandle: HMODULE;
  public
    DPLR_renderer_destroy : TDPLR_renderer_destroy;
    DPLR_renderer_win32_create : TDPLR_renderer_win32_create;
    DPLR_renderer_create : TDPLR_renderer_create;
    DPLR_renderer_draw_to_DC : TDPLR_renderer_draw_to_DC;
    DPLR_renderer_draw_to_memory : TDPLR_renderer_draw_to_memory;
    DPLR_renderer_group_create : TDPLR_renderer_group_create;
    DPLR_renderer_blend_group : TDPLR_renderer_blend_group;
    DPLR_renderer_clear_surface : TDPLR_renderer_clear_surface;
    DPLR_renderer_set_softmask : TDPLR_renderer_set_softmask;
    DPLR_renderer_clear_softmask : TDPLR_renderer_clear_softmask;
    DPLR_renderer_tile_create : TDPLR_renderer_tile_create;
    DPLR_renderer_tile_copy_buffer : TDPLR_renderer_tile_copy_buffer;
    DPLR_renderer_has_softmask : TDPLR_renderer_has_softmask;

    DPLR_save : TDPLR_save;
    DPLR_restore : TDPLR_restore;
    DPLR_set_matrix : TDPLR_set_matrix;
    DPLR_set_page_matrix : TDPLR_set_page_matrix;
    DPLR_set_clip : TDPLR_set_clip;
    DPLR_set_bin_clip : TDPLR_set_bin_clip;
    DPLR_set_image_clip : TDPLR_set_image_clip;
    DPLR_intersect_clip : TDPLR_intersect_clip;
    DPLR_has_clip : TDPLR_has_clip;

    DPLR_set_text_clip : TDPLR_set_text_clip;
    DPLR_add_to_text_clip : TDPLR_add_to_text_clip;
    DPLR_clear_text_clip : TDPLR_clear_text_clip;

    DPLR_new_path : TDPLR_new_path;
    DPLR_clear_path : TDPLR_clear_path;
    DPLR_move_to : TDPLR_move_to;
    DPLR_line_to : TDPLR_line_to;
    DPLR_curve_to :TDPLR_curve_to;
    DPLR_rectangle : TDPLR_rectangle;
    DPLR_close_path : TDPLR_close_path;
    DPLR_fill_path : TDPLR_fill_path;
    DPLR_stroke_path : TDPLR_stroke_path;
    DPLR_stroke_and_fill_path : TDPLR_stroke_and_fill_path;

    DPLR_draw_image : TDPLR_draw_image;
    DPLR_draw_palette_image : TDPLR_draw_palette_image;

    DPLR_shading_init : TDPLR_shading_init;
    DPLR_shading_set_bBox : TDPLR_shading_set_bBox;
    DPLR_shading_set_background_color : TDPLR_shading_set_background_color;
    DPLR_shading_set_domain : TDPLR_shading_set_domain;
    DPLR_shading_set_coords : TDPLR_shading_set_coords;
    DPLR_shading_set_extend : TDPLR_shading_set_extend;
    DPLR_shading_set_matrix : TDPLR_shading_set_matrix;
    DPLR_shading_set_shading_matrix : TDPLR_shading_set_shading_matrix;
    DPLR_shading_set_function : TDPLR_shading_set_function;
    DPLR_shading_set_color_components : TDPLR_shading_set_color_components;
    DPLR_shading_set_bitsPerCoordinate : TDPLR_shading_set_bitsPerCoordinate;
    DPLR_shading_set_bitsPerComponent : TDPLR_shading_set_bitsPerComponent;
    DPLR_shading_set_bitsPerFlag : TDPLR_shading_set_bitsPerFlag;
    DPLR_shading_set_verticesPerRow : TDPLR_shading_set_verticesPerRow;
    DPLR_shading_set_decode : TDPLR_shading_set_decode;
    DPLR_shading_set_stream : TDPLR_shading_set_stream;
    DPLR_draw_shading : TDPLR_draw_shading;

    DPLR_pattern_init : TDPLR_pattern_init;
    DPLR_pattern_set_matrix : TDPLR_pattern_set_matrix;
    DPLR_pattern_set_bBox : TDPLR_pattern_set_bBox;
    DPLR_pattern_set_stepX : TDPLR_pattern_set_stepX;
    DPLR_pattern_set_stepY : TDPLR_pattern_set_stepY;
    DPLR_pattern_set_tilingType : TDPLR_pattern_set_tilingType;
    DPLR_pattern_set_paintType : TDPLR_pattern_set_paintType;
    DPLR_pattern_set_tile_size: TDPLR_pattern_set_tile_size;
    DPLR_pattern_set_tile_buffer: TDPLR_pattern_set_tile_buffer;

    DPLR_gState_init : TDPLR_gState_init;
    DPLR_set_fill_rgba : TDPLR_set_fill_rgba;
    DPLR_set_stroke_rgba : TDPLR_set_stroke_rgba;
    DPLR_set_line_width : TDPLR_set_line_width;
    DPLR_set_line_cap : TDPLR_set_line_cap;
    DPLR_set_line_join : TDPLR_set_line_join;
    DPLR_set_dash : TDPLR_set_dash;
    DPLR_set_miter_limit : TDPLR_set_miter_limit;
    DPLR_set_fill_alpha : TDPLR_set_fill_alpha;
    DPLR_set_stroke_alpha : TDPLR_set_stroke_alpha;
    DPLR_set_operator : TDPLR_set_operator;

    DPLR_set_fill_rule : TDPLR_set_fill_rule;

    constructor Create;
    destructor Destroy; override;
    function Attach(const DLLFileName: WideString): Boolean;
    function GetBlendMode(PDFBlendMode: TPDFBlendMode): Integer;
  end;


function DPLR_shading_read(sh: Pointer; data: PDouble; length: Integer; red, green, blue: PDouble): DPLR_status_t; cdecl;
function DPLR_softmask_read(sm: Pointer; data: Double; value: PDouble): DPLR_status_t; cdecl;


implementation

uses
  Classes;

{ callbacks }
//function DPLR_shading_read(closure: Pointer; data: PByte; length: LongWord): DPLR_status_t; cdecl;
function DPLR_shading_read(sh: Pointer; data: PDouble; length: Integer; red, green, blue: PDouble): DPLR_status_t; cdecl;
var
  ShadingP: PTQPLPattern;
  FunctionInput: TPDFDoubleArray;
  RGBColor: TPDFRGBColor;
  I: Integer;
begin
  if (true) then
  //if (TStream(closure).Read(data^, length) = Integer(length)) then
  begin
      ShadingP := PTQPLPattern(sh);
      SetLength(FunctionInput,  length);
      for I := 0 to length-1 do
      begin
        FunctionInput[I] := data^;
        Inc(data);
      end;
      RGBColor := ShadingP^.GetFunctionColor(FunctionInput);
      red^ := RGBColor.Red;
      green^ := RGBColor.Green;
      blue^ := RGBColor.Blue;
      Result := DPLR_ERROR;
  end else
  begin
    //Result := DPLR_STATUS_READ_ERROR;
  end;
end;

function DPLR_softmask_read(sm: Pointer; data: Double; value: PDouble): DPLR_status_t; cdecl;
var
  SoftmaskP: PTQPLSoftmask;
begin
    SoftmaskP := PTQPLSoftmask(sm);
    {$If DEFINED(VER320) OR DEFINED(VER330)} //10.2 Tokio
    value^ := SoftmaskP^.GetFunctionValue(TPDFDoubleArray(@data));
    {$ELSE}
    value^ := SoftmaskP^.GetFunctionValue(@data);
    {$ENDIF};
    Result := DPLR_SUCCESS;
end;

{ TDebenuPDFLibraryDPLR }
function TDebenuPDFLibraryDPLR.Attach(const DLLFileName: WideString): Boolean;
begin
  Result := False;
  if (DLLFileName <> '') then
  begin
    DLLHandle := LoadLibraryW(@DLLFileName[1]);
    if (DLLHandle > 0) then
    begin
      Result := True;
      DPLR_renderer_destroy := GetProcAddress(DLLHandle, 'DPLR_renderer_destroy');
      DPLR_renderer_win32_create := GetProcAddress(DLLHandle, 'DPLR_renderer_win32_create');
      DPLR_renderer_create := GetProcAddress(DLLHandle, 'DPLR_renderer_create');
      DPLR_renderer_draw_to_DC := GetProcAddress(DLLHandle, 'DPLR_renderer_draw_to_DC');
      DPLR_renderer_draw_to_memory := GetProcAddress(DLLHandle, 'DPLR_renderer_draw_to_memory');
      DPLR_renderer_group_create := GetProcAddress(DLLHandle, 'DPLR_renderer_group_create');
      DPLR_renderer_blend_group := GetProcAddress(DLLHandle, 'DPLR_renderer_blend_group');
      DPLR_renderer_clear_surface := GetProcAddress(DLLHandle, 'DPLR_renderer_clear_surface');
      DPLR_renderer_set_softmask := GetProcAddress(DLLHandle, 'DPLR_renderer_set_softmask');
      DPLR_renderer_clear_softmask := GetProcAddress(DLLHandle, 'DPLR_renderer_clear_softmask');
      DPLR_renderer_tile_create := GetProcAddress(DLLHandle, 'DPLR_renderer_tile_create');
      DPLR_renderer_tile_copy_buffer := GetProcAddress(DLLHandle, 'DPLR_renderer_tile_copy_buffer');
      DPLR_renderer_has_softmask := GetProcAddress(DLLHandle, 'DPLR_renderer_has_softmask');

      DPLR_save := GetProcAddress(DLLHandle, 'DPLR_save');
      DPLR_restore := GetProcAddress(DLLHandle, 'DPLR_restore');
      DPLR_set_matrix := GetProcAddress(DLLHandle, 'DPLR_set_matrix');
      DPLR_set_page_matrix := GetProcAddress(DLLHandle, 'DPLR_set_page_matrix');
      DPLR_set_clip := GetProcAddress(DLLHandle, 'DPLR_set_clip');
      DPLR_set_bin_clip := GetProcAddress(DLLHandle, 'DPLR_set_bin_clip');
      DPLR_set_image_clip := GetProcAddress(DLLHandle, 'DPLR_set_image_clip');
      DPLR_intersect_clip := GetProcAddress(DLLHandle, 'DPLR_intersect_clip');
      DPLR_has_clip := GetProcAddress(DLLHandle, 'DPLR_has_clip');

      DPLR_set_text_clip := GetProcAddress(DLLHandle, 'DPLR_set_text_clip');
      DPLR_add_to_text_clip := GetProcAddress(DLLHandle, 'DPLR_add_to_text_clip');
      DPLR_clear_text_clip := GetProcAddress(DLLHandle, 'DPLR_clear_text_clip');

      DPLR_new_path := GetProcAddress(DLLHandle, 'DPLR_new_path');
      DPLR_clear_path := GetProcAddress(DLLHandle, 'DPLR_clear_path');
      DPLR_move_to := GetProcAddress(DLLHandle, 'DPLR_move_to');
      DPLR_line_to := GetProcAddress(DLLHandle, 'DPLR_line_to');
      DPLR_curve_to := GetProcAddress(DLLHandle, 'DPLR_curve_to');
      DPLR_rectangle := GetProcAddress(DLLHandle, 'DPLR_rectangle');
      DPLR_close_path := GetProcAddress(DLLHandle, 'DPLR_close_path');
      DPLR_fill_path := GetProcAddress(DLLHandle, 'DPLR_fill_path');
      DPLR_stroke_path := GetProcAddress(DLLHandle, 'DPLR_stroke_path');
      DPLR_stroke_and_fill_path := GetProcAddress(DLLHandle, 'DPLR_stroke_and_fill_path');

      DPLR_draw_image := GetProcAddress(DLLHandle, 'DPLR_draw_image');
      DPLR_draw_palette_image := GetProcAddress(DLLHandle, 'DPLR_draw_palette_image');

      DPLR_shading_init := GetProcAddress(DLLHandle, 'DPLR_shading_init');
      DPLR_shading_set_bBox := GetProcAddress(DLLHandle, 'DPLR_shading_set_bBox');
      DPLR_shading_set_background_color := GetProcAddress(DLLHandle, 'DPLR_shading_set_background_color');
      DPLR_shading_set_domain := GetProcAddress(DLLHandle, 'DPLR_shading_set_domain');
      DPLR_shading_set_coords := GetProcAddress(DLLHandle, 'DPLR_shading_set_coords');
      DPLR_shading_set_extend := GetProcAddress(DLLHandle, 'DPLR_shading_set_extend');
      DPLR_shading_set_matrix := GetProcAddress(DLLHandle, 'DPLR_shading_set_matrix');
      DPLR_shading_set_shading_matrix := GetProcAddress(DLLHandle, 'DPLR_shading_set_shading_matrix');
      DPLR_shading_set_function := GetProcAddress(DLLHandle, 'DPLR_shading_set_function');
      DPLR_shading_set_color_components := GetProcAddress(DLLHandle, 'DPLR_shading_set_color_components');
      DPLR_shading_set_bitsPerCoordinate := GetProcAddress(DLLHandle, 'DPLR_shading_set_bitsPerCoordinate');
      DPLR_shading_set_bitsPerComponent := GetProcAddress(DLLHandle, 'DPLR_shading_set_bitsPerComponent');
      DPLR_shading_set_bitsPerFlag := GetProcAddress(DLLHandle, 'DPLR_shading_set_bitsPerFlag');
      DPLR_shading_set_verticesPerRow := GetProcAddress(DLLHandle, 'DPLR_shading_set_verticesPerRow');
      DPLR_shading_set_decode := GetProcAddress(DLLHandle, 'DPLR_shading_set_decode');
      DPLR_shading_set_stream := GetProcAddress(DLLHandle, 'DPLR_shading_set_buffer');
      DPLR_draw_shading := GetProcAddress(DLLHandle, 'DPLR_draw_shading');

      DPLR_pattern_init := GetProcAddress(DLLHandle, 'DPLR_pattern_init');
      DPLR_pattern_set_matrix := GetProcAddress(DLLHandle, 'DPLR_pattern_set_matrix');
      DPLR_pattern_set_bBox := GetProcAddress(DLLHandle, 'DPLR_pattern_set_bBox');
      DPLR_pattern_set_stepX := GetProcAddress(DLLHandle, 'DPLR_pattern_set_stepX');
      DPLR_pattern_set_stepY := GetProcAddress(DLLHandle, 'DPLR_pattern_set_stepY');
      DPLR_pattern_set_tilingType := GetProcAddress(DLLHandle, 'DPLR_pattern_set_tilingType');
      DPLR_pattern_set_paintType := GetProcAddress(DLLHandle, 'DPLR_pattern_set_paintType');
      DPLR_pattern_set_tile_buffer :=  GetProcAddress(DLLHandle, 'DPLR_pattern_set_tile_buffer');
      DPLR_pattern_set_tile_size := GetProcAddress(DLLHandle, 'DPLR_pattern_set_tile_size');

      DPLR_gState_init := GetProcAddress(DLLHandle, 'DPLR_gState_init');
      DPLR_set_fill_rgba := GetProcAddress(DLLHandle, 'DPLR_set_fill_rgba');
      DPLR_set_stroke_rgba := GetProcAddress(DLLHandle, 'DPLR_set_stroke_rgba');
      DPLR_set_line_width := GetProcAddress(DLLHandle, 'DPLR_set_line_width');
      DPLR_set_line_cap := GetProcAddress(DLLHandle, 'DPLR_set_line_cap');
      DPLR_set_line_join := GetProcAddress(DLLHandle, 'DPLR_set_line_join');
      DPLR_set_dash := GetProcAddress(DLLHandle, 'DPLR_set_dash');
      DPLR_set_miter_limit := GetProcAddress(DLLHandle, 'DPLR_set_miter_limit');
      DPLR_set_fill_alpha := GetProcAddress(DLLHandle, 'DPLR_set_fill_alpha');
      DPLR_set_stroke_alpha := GetProcAddress(DLLHandle, 'DPLR_set_stroke_alpha');
      DPLR_set_operator := GetProcAddress(DLLHandle, 'DPLR_set_operator');

      DPLR_set_fill_rule := GetProcAddress(DLLHandle, 'DPLR_set_fill_rule');

    end;
  end;
end;

constructor TDebenuPDFLibraryDPLR.Create;
begin
  DLLHandle := 0;
end;

destructor TDebenuPDFLibraryDPLR.Destroy;
begin
  if (DLLHandle <> 0) then
  begin
    FreeLibrary(DLLHandle);
  end;
  inherited;
end;

function TDebenuPDFLibraryDPLR.GetBlendMode(PDFBlendMode: TPDFBlendMode): Integer;
begin
  case PDFBlendMode of
    bmNormal: Result := Ord(DPLR_OPERATOR_NORMAL);
    bmMultiply: Result := Ord(DPLR_OPERATOR_MULTIPLY);
    bmScreen: Result := Ord(DPLR_OPERATOR_SCREEN);
    bmOverlay: Result := Ord(DPLR_OPERATOR_OVERLAY);
    bmDarken: Result := Ord(DPLR_OPERATOR_DARKEN);
    bmLighten: Result := Ord(DPLR_OPERATOR_LIGHTEN);
    bmColorDodge: Result := Ord(DPLR_OPERATOR_COLOR_DODGE);
    bmColorBurn: Result := Ord(DPLR_OPERATOR_COLOR_BURN);
    bmHardLight: Result := Ord(DPLR_OPERATOR_HARD_LIGHT);
    bmSoftLight: Result := Ord(DPLR_OPERATOR_SOFT_LIGHT);
    bmDifference: Result := Ord(DPLR_OPERATOR_DIFFERENCE);
    bmExclusion: Result := Ord(DPLR_OPERATOR_EXCLUSION);
    bmHue: Result := Ord(DPLR_OPERATOR_HSL_HUE);
    bmSaturation: Result := Ord(DPLR_OPERATOR_HSL_SATURATION);
    bmColor: Result := Ord(DPLR_OPERATOR_HSL_COLOR);
    bmLuminosity: Result := Ord(DPLR_OPERATOR_HSL_LUMINOSITY);
  else
    Result := Ord(DPLR_OPERATOR_NORMAL);
  end;
end;

end.
