{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTypes.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTypes;

{$I DebenuPDFLibraryDefines.inc}

interface

type
  TQPLByteArray = array of Byte;
  TQPLPByte = ^Byte;

  TQPLWordArray = array of Word;
  TQPLIntegerArray = array of Integer;
  TQPLDoubleArray = array of Double;

  TQPLExtractionOptions = record
    WordGap: Double;
    IgnoreFont: Boolean;
    IgnoreColor: Boolean;
    IgnoreBlocks: Boolean;
    SortBlocks: Boolean;
    SplitOnDoubleSpace: Boolean;
    TrimCharsOutsideArea: Boolean;
    SpecialMatch: Boolean;
    IgnoreRotated: Boolean;
    TrimWhitespace: Boolean;
    OutputNonAscii: Boolean;
    RemoveUnderscoreLines: Boolean;
    HasArea: Boolean;
    AreaLeft: Double;
    AreaTop: Double;
    AreaWidth: Double;
    AreaHeight: Double;
    OutputCMYK: Boolean;
    IgnoreDescenders: Boolean;
    IgnoreOverlaps: Boolean;
    IgnoreDuplicates: Boolean;
    HorzScaleFactor: Double;
    VertScaleFactor: Double;
  end;

{$IFDEF WIN64}
  TQPLIntPtr = IntPtr;
{$ELSE}
  TQPLIntPtr = Integer;
{$ENDIF}

  TPDFBlendMode = (bmNormal, bmMultiply, bmScreen, bmOverlay, bmDarken,
    bmLighten, bmColorDodge, bmColorBurn, bmHardLight, bmSoftLight,
    bmDifference, bmExclusion, bmHue, bmSaturation, bmColor, bmLuminosity);

type
  PQPLFloat = ^TQPLFloat;
  TQPLFloat = double;

  PQPLFloatArray = ^TQPLFloatArray;
  TQPLFloatArray = array[0..0] of TQPLFloat;
  PQPLFloatArray2 = ^TQPLFloatArray2;
  TQPLFloatArray2 = array[0..1] of TQPLFloat;
  PQPLFloatArray3 = ^TQPLFloatArray3;
  TQPLFloatArray3 = array[0..2] of TQPLFloat;
  PQPLFloatArray4 = ^TQPLFloatArray4;
  TQPLFloatArray4 = array[0..3] of TQPLFloat;
  PQPLFloatArray6 = ^TQPLFloatArray6;
  TQPLFloatArray6 = array[0..5] of TQPLFloat;
  PQPLFloatArray8 = ^TQPLFloatArray8;
  TQPLFloatArray8= array[0..7] of TQPLFloat;

type
  PQPLFloatPoint = ^TQPLFloatPoint;
  TQPLFloatPoint = packed record
    x : TQPLFloat;
    y : TQPLFloat;
  end;

  PQPLFloatPointArray = ^TQPLFloatPointArray;
  TQPLFloatPointArray = array[0..0] of TQPLFloatPoint;
  PQPLFloatPointArray2 = ^TQPLFloatPointArray2;
  TQPLFloatPointArray2 = array[0..1] of TQPLFloatPoint;
  PQPLFloatPointArray3 = ^TQPLFloatPointArray3;
  TQPLFloatPointArray3 = array[0..2] of TQPLFloatPoint;
  PQPLFloatPointArray4 = ^TQPLFloatPointArray4;
  TQPLFloatPointArray4 = array[0..3] of TQPLFloatPoint;
  PQPLFloatPointArray6 = ^TQPLFloatPointArray6;
  TQPLFloatPointArray6 = array[0..5] of TQPLFloatPoint;
  PQPLFloatPointArray8 = ^TQPLFloatPointArray8;
  TQPLFloatPointArray8= array[0..7] of TQPLFloatPoint;

type
  PQPLFloatRect = ^TQPLFloatRect;
  TQPLFloatRect = packed record
    x : TQPLFloat;
    y : TQPLFloat;
    w : TQPLFloat;
    h : TQPLFloat;
  end;

  PQPLFloatRectArray = ^TQPLFloatRectArray;
  TQPLFloatRectArray = array[0..0] of TQPLFloatRect;

type
  PQPLFloatBBox = ^TQPLFloatBBox;
  TQPLFloatBBox = packed record
    Left   : TQPLFloat;
    Bottom : TQPLFloat;
    Right  : TQPLFloat;
    Top    : TQPLFloat;
  end;

  PQPLFloatBBoxArray = ^TQPLFloatBBoxArray;
  TQPLFloatBBoxArray = array[0..0] of TQPLFloatBBox;

type
  PQPLFloatQuad = ^TQPLFloatQuad;
  TQPLFloatQuad = packed record
    LowerLeft  : TQPLFloatPoint;
    UpperLeft  : TQPLFloatPoint;
    UpperRight : TQPLFloatPoint;
    LowerRight : TQPLFloatPoint;
  end;

  PQPLFloatQuadArray = ^TQPLFloatQuadArray;
  TQPLFloatQuadArray = array[0..0] of TQPLFloatQuad;

type
  PQPLFloatMatrix = ^TQPLFloatMatrix;
  TQPLFloatMatrix = packed record
    eM11 : TQPLFloat;
    eM12 : TQPLFloat;
    eM21 : TQPLFloat;
    eM22 : TQPLFloat;
    eDx  : TQPLFloat;
    eDy  : TQPLFloat;
  end;

  PQPLFloatMatrixArray = ^TQPLFloatMatrixArray;
  TQPLFloatMatrixArray = array[0..0] of TQPLFloatMatrix;

type
  TQuickPDFInt128 = array[0..3] of Cardinal;

type
// DPLR types
  PDPLR_renderer_t = ^DPLR_renderer_t;
  DPLR_renderer_t = record
  end;

{$IFDEF VER120}
  PInteger = ^Integer;
{$ENDIF}

{$IFDEF VER130}
  PInteger = ^Integer;
{$ENDIF}

implementation

end.
