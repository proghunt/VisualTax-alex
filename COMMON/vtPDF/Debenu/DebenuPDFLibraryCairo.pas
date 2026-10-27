{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryCairo.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

{$OPTIMIZATION ON}

unit DebenuPDFLibraryCairo;

{$I DebenuPDFLibraryDefines.inc}

(* cairo - a vector graphics library with display and print output
 *
 * Copyright © 2002 University of Southern California
 * Copyright © 2005 Red Hat, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it either under the terms of the GNU Lesser General Public
 * License version 2.1 as published by the Free Software Foundation
 * (the "LGPL") or, at your option, under the terms of the Mozilla
 * Public License Version 1.1 (the "MPL"). If you do not alter this
 * notice, a recipient may use your version of this file under either
 * the MPL or the LGPL.
 *
 * You should have received a copy of the LGPL along with this library
 * in the file COPYING-LGPL-2.1; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 * You should have received a copy of the MPL along with this library
 * in the file COPYING-MPL-1.1
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY
 * OF ANY KIND, either express or implied. See the LGPL or the MPL for
 * the specific language governing rights and limitations.
 *
 * The Original Code is the cairo graphics library.
 *
 * The Initial Developer of the Original Code is University of Southern
 * California.
 *
 * Contributor(s):
 *	Carl D. Worth <cworth@cworth.org>

 *  This FreePascal binding generated August 26, 2005
 *  by Jeffrey Pohlmeyer <yetanothergeek@yahoo.com>

  - Updated to cairo version 1.4
  - Grouped OS specific fuctions in separated units
  - Organized the functions by group and ordered exactly as the c header
  - Cleared parameter list syntax according to pascal standard

  By Luiz Américo Pereira Câmara
  October 2007
*)

{
    This file is part of the Free Pascal libraries.
    Copyright (c) 2003-2008 by the Free Pascal development team

    Translation of cairo-win32.h

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************

Translation of cairo-win32.h version 1.4 by Luiz Américo Pereira Câmara 2007

For consistency with the other cairo header files, this file is dual
licensed LGPL-MPL see the file cairo.pp for the full license.
}

{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2004 by Marco van de Voort, member of the
    Free Pascal development team

    Implements C types for in header conversions

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


 **********************************************************************}

interface

uses
  Windows, DebenuPDFLibraryTypes;

type
  // Cairo types

  Pcairo_t = ^cairo_t;

  cairo_t = record
  end;

  Pcairo_surface_t = ^cairo_surface_t;

  cairo_surface_t = record
  end;

  Pcairo_matrix_t = ^cairo_matrix_t;

  cairo_pattern_t = record
  end;

  Pcairo_pattern_t = ^cairo_pattern_t;

  cairo_matrix_t = record
    xx : Double;
    yx : Double;
    xy : Double;
    yy : Double;
    x0 : Double;
    y0 : Double;
  end;


  // Enumerations

  cairo_format_t = (
    CAIRO_FORMAT_ARGB32,
    CAIRO_FORMAT_RGB24,
    CAIRO_FORMAT_A8,
    CAIRO_FORMAT_A1
  );

  cairo_line_cap_t = (
    CAIRO_LINE_CAP_BUTT,
    CAIRO_LINE_CAP_ROUND,
    CAIRO_LINE_CAP_SQUARE
  );

  cairo_line_join_t = (
    CAIRO_LINE_JOIN_MITER,
    CAIRO_LINE_JOIN_ROUND,
    CAIRO_LINE_JOIN_BEVEL
  );

  cairo_status_t = (
    CAIRO_STATUS_SUCCESS,
    CAIRO_STATUS_NO_MEMORY,
    CAIRO_STATUS_INVALID_RESTORE,
    CAIRO_STATUS_INVALID_POP_GROUP,
    CAIRO_STATUS_NO_CURRENT_POINT,
    CAIRO_STATUS_INVALID_MATRIX,
    CAIRO_STATUS_INVALID_STATUS,
    CAIRO_STATUS_NULL_POINTER,
    CAIRO_STATUS_INVALID_STRING,
    CAIRO_STATUS_INVALID_PATH_DATA,
    CAIRO_STATUS_READ_ERROR,
    CAIRO_STATUS_WRITE_ERROR,
    CAIRO_STATUS_SURFACE_FINISHED,
    CAIRO_STATUS_SURFACE_TYPE_MISMATCH,
    CAIRO_STATUS_PATTERN_TYPE_MISMATCH,
    CAIRO_STATUS_INVALID_CONTENT,
    CAIRO_STATUS_INVALID_FORMAT,
    CAIRO_STATUS_INVALID_VISUAL,
    CAIRO_STATUS_FILE_NOT_FOUND,
    CAIRO_STATUS_INVALID_DASH
  );

  cairo_operator_t = (
    CAIRO_OPERATOR_CLEAR,

    CAIRO_OPERATOR_SOURCE,
    CAIRO_OPERATOR_OVER,
    CAIRO_OPERATOR_IN,
    CAIRO_OPERATOR_OUT,
    CAIRO_OPERATOR_ATOP,

    CAIRO_OPERATOR_DEST,
    CAIRO_OPERATOR_DEST_OVER,
    CAIRO_OPERATOR_DEST_IN,
    CAIRO_OPERATOR_DEST_OUT,
    CAIRO_OPERATOR_DEST_ATOP,

    CAIRO_OPERATOR_XOR,
    CAIRO_OPERATOR_ADD,
    CAIRO_OPERATOR_SATURATE,

    CAIRO_OPERATOR_MULTIPLY,
    CAIRO_OPERATOR_SCREEN,
    CAIRO_OPERATOR_OVERLAY,
    CAIRO_OPERATOR_DARKEN,
    CAIRO_OPERATOR_LIGHTEN,
    CAIRO_OPERATOR_COLOR_DODGE,
    CAIRO_OPERATOR_COLOR_BURN,
    CAIRO_OPERATOR_HARD_LIGHT,
    CAIRO_OPERATOR_SOFT_LIGHT,
    CAIRO_OPERATOR_DIFFERENCE,
    CAIRO_OPERATOR_EXCLUSION,
    CAIRO_OPERATOR_HSL_HUE,
    CAIRO_OPERATOR_HSL_SATURATION,
    CAIRO_OPERATOR_HSL_COLOR,
    CAIRO_OPERATOR_HSL_LUMINOSITY
  );

  cairo_fill_rule_t = (
    CAIRO_FILL_RULE_WINDING,
    CAIRO_FILL_RULE_EVEN_ODD
  );

  cairo_extend_t = (
    CAIRO_EXTEND_NONE,
    CAIRO_EXTEND_REPEAT,
    CAIRO_EXTEND_REFLECT,
    CAIRO_EXTEND_PAD
  );


  cairo_content_t = Integer;


const
  CAIRO_CONTENT_COLOR = $1000;
  CAIRO_CONTENT_ALPHA = $2000;
  CAIRO_CONTENT_COLOR_ALPHA = $3000;


type

  // Callback function type

  cairo_read_func_t = function (closure: Pointer; data: PByte; length: LongWord): cairo_status_t; cdecl;


  // Function import types

  Tcairo_win32_surface_create_with_dib = function(format: cairo_format_t; width, height: longint): Pcairo_surface_t; cdecl;
  Tcairo_create = function(target: Pcairo_surface_t): Pcairo_t; cdecl;
  Tcairo_set_source_rgba = procedure(cr: Pcairo_t; red, green, blue, alpha: Double); cdecl;
  Tcairo_paint = procedure(cr: Pcairo_t); cdecl;
  Tcairo_move_to = procedure(cr: Pcairo_t; x, y: Double); cdecl;
  Tcairo_line_to = procedure(cr: Pcairo_t; x, y: Double); cdecl;
  Tcairo_close_path = procedure(cr: Pcairo_t); cdecl;
  Tcairo_fill = procedure(cr: Pcairo_t); cdecl;
  Tcairo_destroy = procedure(cr: Pcairo_t); cdecl;
  Tcairo_win32_surface_get_dc = function(surface: pcairo_surface_t): HDC; cdecl;
  Tcairo_surface_destroy = procedure(surface: Pcairo_surface_t); cdecl;
  Tcairo_win32_surface_create = function(hdc: HDC): Pcairo_surface_t; cdecl;
  Tcairo_new_path = procedure(cr: Pcairo_t); cdecl;
  Tcairo_stroke = procedure(cr: Pcairo_t); cdecl;
  Tcairo_curve_to = procedure(cr: Pcairo_t; x1, y1, x2, y2, x3, y3: Double); cdecl;
  Tcairo_set_line_width = procedure(cr: Pcairo_t; width: Double); cdecl;
  Tcairo_set_line_cap = procedure(cr: Pcairo_t; line_cap: cairo_line_cap_t); cdecl;
  Tcairo_set_line_join = procedure(cr: Pcairo_t; line_join: cairo_line_join_t); cdecl;
  Tcairo_set_dash = procedure(cr: Pcairo_t; dashes: PDouble; num_dashes: LongInt; offset: Double); cdecl;
  Tcairo_set_miter_limit = procedure(cr: Pcairo_t; limit: Double); cdecl;
  Tcairo_image_surface_create_from_png_stream = function(read_func: cairo_read_func_t; closure: pointer): Pcairo_surface_t; cdecl;
  Tcairo_set_source_surface = procedure(cr: Pcairo_t; surface: Pcairo_surface_t; x, y: Double); cdecl;
  Tcairo_rectangle = procedure(cr: Pcairo_t; x, y, width, height: Double); cdecl;
  Tcairo_set_matrix = procedure(cr: Pcairo_t; matrix: Pcairo_matrix_t); cdecl;
  Tcairo_identity_matrix = procedure(cr: Pcairo_t); cdecl;
  Tcairo_transform = procedure(cr: Pcairo_t; matrix: Pcairo_matrix_t); cdecl;
  Tcairo_image_surface_get_width = function(surface: Pcairo_surface_t): Integer; cdecl;
  Tcairo_image_surface_get_height = function(surface: Pcairo_surface_t): Integer; cdecl;
  Tcairo_push_group = procedure(cr: Pcairo_t); cdecl;
  Tcairo_pop_group_to_source = procedure(cr: Pcairo_t); cdecl;
  Tcairo_paint_with_alpha = procedure(cr: Pcairo_t; alpha: Double); cdecl;
  Tcairo_set_operator = procedure(cr: Pcairo_t; op: cairo_operator_t); cdecl;
  Tcairo_surface_create_similar = function(other: Pcairo_surface_t; content: cairo_content_t; width, height: LongInt): Pcairo_surface_t; cdecl;
  Tcairo_mask_surface = procedure(cr: Pcairo_t; surface: Pcairo_surface_t; x, y: Double); cdecl;
  Tcairo_pattern_create_linear = function(x0, y0, x1, y1: Double): Pcairo_pattern_t; cdecl;
  Tcairo_pattern_add_color_stop_rgb = procedure(pattern: Pcairo_pattern_t; offset, red, green, blue: Double); cdecl;
  Tcairo_set_source = procedure(cr: Pcairo_t; pattern: Pcairo_pattern_t); cdecl;
  Tcairo_pattern_set_matrix = procedure(pattern: Pcairo_pattern_t; matrix: Pcairo_matrix_t); cdecl;
  Tcairo_matrix_invert = function(matrix: Pcairo_matrix_t): cairo_status_t; cdecl;
  Tcairo_save = procedure(cr: Pcairo_t); cdecl;
  Tcairo_restore = procedure(cr: Pcairo_t); cdecl;
  Tcairo_fill_preserve = procedure(cr: Pcairo_t); cdecl;
  Tcairo_status = function(cr: Pcairo_t): cairo_status_t; cdecl;
  Tcairo_clip = procedure(cr: Pcairo_t); cdecl;
  Tcairo_clip_preserve = procedure(cr: Pcairo_t); cdecl;
  Tcairo_stroke_preserve = procedure(cr: Pcairo_t); cdecl;
  Tcairo_set_fill_rule = procedure(cr: Pcairo_t; fillrule: cairo_fill_rule_t); cdecl;
  Tcairo_clip_extents = procedure(cr: Pcairo_t; var x1, y1, x2, y2: Double); cdecl;
  Tcairo_surface_status = function(surface: Pcairo_surface_t): cairo_status_t; cdecl;
  Tcairo_pattern_set_extend = procedure(pattern: Pcairo_pattern_t; extend: cairo_extend_t); cdecl;


  // Wrapper DLL

  TCairoDLL = class
  private
    DLLHandle: HMODULE;
  public
    cairo_win32_surface_create_with_dib: Tcairo_win32_surface_create_with_dib;
    cairo_create: Tcairo_create;
    cairo_set_source_rgba: Tcairo_set_source_rgba;
    cairo_paint: Tcairo_paint;
    cairo_move_to: Tcairo_move_to;
    cairo_line_to: Tcairo_line_to;
    cairo_close_path: Tcairo_close_path;
    cairo_fill: Tcairo_fill;
    cairo_destroy: Tcairo_destroy;
    cairo_win32_surface_get_dc: Tcairo_win32_surface_get_dc;
    cairo_surface_destroy: Tcairo_surface_destroy;
    cairo_win32_surface_create: Tcairo_win32_surface_create;
    cairo_new_path: Tcairo_new_path;
    cairo_stroke: Tcairo_stroke;
    cairo_curve_to: Tcairo_curve_to;
    cairo_set_line_width: Tcairo_set_line_width;
    cairo_set_line_cap: Tcairo_set_line_cap;
    cairo_set_line_join: Tcairo_set_line_join;
    cairo_set_dash: Tcairo_set_dash;
    cairo_set_miter_limit: Tcairo_set_miter_limit;
    cairo_image_surface_create_from_png_stream: Tcairo_image_surface_create_from_png_stream;
    cairo_set_source_surface: Tcairo_set_source_surface;
    cairo_rectangle: Tcairo_rectangle;
    cairo_set_matrix: Tcairo_set_matrix;
    cairo_identity_matrix: Tcairo_identity_matrix;
    cairo_transform: Tcairo_transform;
    cairo_image_surface_get_width: Tcairo_image_surface_get_width;
    cairo_image_surface_get_height: Tcairo_image_surface_get_height;
    cairo_push_group: Tcairo_push_group;
    cairo_pop_group_to_source: Tcairo_pop_group_to_source;
    cairo_paint_with_alpha: Tcairo_paint_with_alpha;
    cairo_set_operator: Tcairo_set_operator;
    cairo_surface_create_similar: Tcairo_surface_create_similar;
    cairo_mask_surface: Tcairo_mask_surface;
    cairo_pattern_create_linear: Tcairo_pattern_create_linear;
    cairo_pattern_add_color_stop_rgb: Tcairo_pattern_add_color_stop_rgb;
    cairo_set_source: Tcairo_set_source;
    cairo_pattern_set_matrix: Tcairo_pattern_set_matrix;
    cairo_matrix_invert: Tcairo_matrix_invert;
    cairo_save: Tcairo_save;
    cairo_restore: Tcairo_restore;
    cairo_fill_preserve: Tcairo_fill_preserve;
    cairo_status: Tcairo_status;
    cairo_clip: Tcairo_clip;
    cairo_clip_preserve: Tcairo_clip_preserve;
    cairo_set_fill_rule: Tcairo_set_fill_rule;
    cairo_stroke_preserve: Tcairo_stroke_preserve;
    cairo_clip_extents: Tcairo_clip_extents;
    cairo_surface_status: Tcairo_surface_status;
    cairo_pattern_set_extend: Tcairo_pattern_set_extend;

    constructor Create;
    destructor Destroy; override;
    function Attach(const DLLFileName: WideString): Boolean;
    function GetBlendMode(PDFBlendMode: TPDFBlendMode): cairo_operator_t;
  end;

function CairoStreamRead(closure: Pointer; data: PByte; length: LongWord): cairo_status_t; cdecl;

implementation

uses
  Classes;

function CairoStreamRead(closure: Pointer; data: PByte; length: LongWord): cairo_status_t; cdecl;
begin
  if (TStream(closure).Read(data^, length) = Integer(length)) then
  begin
    Result := CAIRO_STATUS_SUCCESS;
  end else
  begin
    Result := CAIRO_STATUS_READ_ERROR;
  end;
end;

{ TCairoDLL }

function TCairoDLL.Attach(const DLLFileName: WideString): Boolean;
begin
  Result := False;
  if (DLLFileName <> '') then
  begin
    DLLHandle := LoadLibraryW(@DLLFileName[1]);
    if (DLLHandle > 0) then
    begin
      Result := True;
      cairo_win32_surface_create_with_dib := GetProcAddress(DLLHandle,'cairo_win32_surface_create_with_dib');
      cairo_create := GetProcAddress(DLLHandle, 'cairo_create');
      cairo_set_source_rgba := GetProcAddress(DLLHandle, 'cairo_set_source_rgba');
      cairo_paint := GetProcAddress(DLLHandle, 'cairo_paint');
      cairo_move_to := GetProcAddress(DLLHandle, 'cairo_move_to');
      cairo_line_to := GetProcAddress(DLLHandle, 'cairo_line_to');
      cairo_close_path := GetProcAddress(DLLHandle, 'cairo_close_path');
      cairo_fill := GetProcAddress(DLLHandle, 'cairo_fill');
      cairo_destroy := GetProcAddress(DLLHandle, 'cairo_destroy');
      cairo_win32_surface_get_dc := GetProcAddress(DLLHandle, 'cairo_win32_surface_get_dc');
      cairo_surface_destroy := GetProcAddress(DLLHandle, 'cairo_surface_destroy');
      cairo_win32_surface_create := GetProcAddress(DLLHandle, 'cairo_win32_surface_create');
      cairo_new_path := GetProcAddress(DLLHandle, 'cairo_new_path');
      cairo_stroke := GetProcAddress(DLLHandle, 'cairo_stroke');
      cairo_curve_to := GetProcAddress(DLLHandle, 'cairo_curve_to');
      cairo_set_line_width := GetProcAddress(DLLHandle, 'cairo_set_line_width');
      cairo_set_line_cap := GetProcAddress(DLLHandle, 'cairo_set_line_cap');
      cairo_set_line_join := GetProcAddress(DLLHandle, 'cairo_set_line_join');
      cairo_set_dash := GetProcAddress(DLLHandle, 'cairo_set_dash');
      cairo_set_miter_limit := GetProcAddress(DLLHandle, 'cairo_set_miter_limit');
      cairo_image_surface_create_from_png_stream := GetProcAddress(DLLHandle, 'cairo_image_surface_create_from_png_stream');
      cairo_set_source_surface := GetProcAddress(DLLHandle, 'cairo_set_source_surface');
      cairo_rectangle := GetProcAddress(DLLHandle, 'cairo_rectangle');
      cairo_set_matrix := GetProcAddress(DLLHandle, 'cairo_set_matrix');
      cairo_identity_matrix := GetProcAddress(DLLHandle, 'cairo_identity_matrix');
      cairo_transform := GetProcAddress(DLLHandle, 'cairo_transform');
      cairo_image_surface_get_width := GetProcAddress(DLLHandle, 'cairo_image_surface_get_width');
      cairo_image_surface_get_height := GetProcAddress(DLLHandle, 'cairo_image_surface_get_height');
      cairo_push_group := GetProcAddress(DLLHandle, 'cairo_push_group');
      cairo_pop_group_to_source := GetProcAddress(DLLHandle, 'cairo_pop_group_to_source');
      cairo_paint_with_alpha := GetProcAddress(DLLHandle, 'cairo_paint_with_alpha');
      cairo_set_operator := GetProcAddress(DLLHandle, 'cairo_set_operator');
      cairo_surface_create_similar := GetProcAddress(DLLHandle, 'cairo_surface_create_similar');
      cairo_mask_surface := GetProcAddress(DLLHandle, 'cairo_mask_surface');
      cairo_pattern_create_linear := GetProcAddress(DLLHandle, 'cairo_pattern_create_linear');
      cairo_pattern_add_color_stop_rgb := GetProcAddress(DLLHandle, 'cairo_pattern_add_color_stop_rgb');
      cairo_set_source := GetProcAddress(DLLHandle, 'cairo_set_source');
      cairo_pattern_set_matrix := GetProcAddress(DLLHandle, 'cairo_pattern_set_matrix');
      cairo_matrix_invert := GetProcAddress(DLLHandle, 'cairo_matrix_invert');
      cairo_save := GetProcAddress(DLLHandle, 'cairo_save');
      cairo_restore := GetProcAddress(DLLHandle, 'cairo_restore');
      cairo_fill_preserve := GetProcAddress(DLLHandle, 'cairo_fill_preserve');
      cairo_status := GetProcAddress(DLLHandle, 'cairo_status');
      cairo_clip := GetProcAddress(DLLHandle, 'cairo_clip');
      cairo_clip_preserve := GetProcAddress(DLLHandle, 'cairo_clip_preserve');
      cairo_set_fill_rule := GetProcAddress(DLLHandle, 'cairo_set_fill_rule');
      cairo_stroke_preserve := GetProcAddress(DLLHandle, 'cairo_stroke_preserve');
      cairo_clip_extents := GetProcAddress(DLLHandle, 'cairo_clip_extents');
      cairo_surface_status := GetProcAddress(DLLHandle, 'cairo_surface_status');
      cairo_pattern_set_extend := GetProcAddress(DLLHandle, 'cairo_pattern_set_extend');
    end;
  end;
end;

constructor TCairoDLL.Create;
begin
  DLLHandle := 0;
end;

destructor TCairoDLL.Destroy;
begin
  if (DLLHandle <> 0) then
  begin
    FreeLibrary(DLLHandle);
  end;
  inherited;
end;

function TCairoDLL.GetBlendMode(PDFBlendMode: TPDFBlendMode): cairo_operator_t;
begin
  case PDFBlendMode of
    bmNormal: Result := CAIRO_OPERATOR_OVER;
    bmMultiply: Result := CAIRO_OPERATOR_MULTIPLY;
    bmScreen: Result := CAIRO_OPERATOR_SCREEN;
    bmOverlay: Result := CAIRO_OPERATOR_OVERLAY;
    bmDarken: Result := CAIRO_OPERATOR_DARKEN;
    bmLighten: Result := CAIRO_OPERATOR_LIGHTEN;
    bmColorDodge: Result := CAIRO_OPERATOR_COLOR_DODGE;
    bmColorBurn: Result := CAIRO_OPERATOR_COLOR_BURN;
    bmHardLight: Result := CAIRO_OPERATOR_HARD_LIGHT;
    bmSoftLight: Result := CAIRO_OPERATOR_SOFT_LIGHT;
    bmDifference: Result := CAIRO_OPERATOR_DIFFERENCE;
    bmExclusion: Result := CAIRO_OPERATOR_EXCLUSION;
    bmHue: Result := CAIRO_OPERATOR_HSL_HUE;
    bmSaturation: Result := CAIRO_OPERATOR_HSL_SATURATION;
    bmColor: Result := CAIRO_OPERATOR_HSL_COLOR;
    bmLuminosity: Result := CAIRO_OPERATOR_HSL_LUMINOSITY;
  else
    Result := CAIRO_OPERATOR_OVER;
  end;
end;

end.
