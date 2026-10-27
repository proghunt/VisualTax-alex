{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryPainter.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryPainter;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryImage, DebenuPDFLibraryFont, DebenuPDFLibraryBarcode, DebenuPDFLibraryExtra,
  DebenuPDFLibraryStructure, DebenuPDFLibraryPDF417;

type
  TPDFAlignment = (paLeft, paCenter, paRight, paJustified, paForceJustified, paLastJustified);
  TBarcodeRotation = (brNormal, brClockwise, brAntiClockwise, brUpsideDown);
  TPDFUnderlineStyle = (usNone, usSingle, usDouble, usStrikeout, usOver);
  TPDFHighlightStyle = (hsNone, hsSquare, hsRounded);

  TPDFLineFlags = record
    WordCount: Integer;
    ForcedBreak: Boolean;
    WordBreak: Boolean;
  end;

  TPDFTextBlockFlags = array of TPDFLineFlags;

  TStringPair = record
    S1, S2: AnsiString;
  end;

  THTMLSettings = record
    NormalFont: TPDFFont;
    BoldFont: TPDFFont;
    ItalicFont: TPDFFont;
    BoldItalicFont: TPDFFont;
    Top: Double;
    Left: Double;
    Width: Double;
    TextSpacing: Double;
    EquivalentTags: array of TStringPair;
  end;

  TPDFCapturedPage = class
  public
    XObject: TPDFIndRef;
    XObjectName: AnsiString;
    OriginalWidth: Double;
    OriginalHeight: Double;
    XOffset: Double;
    YOffset: Double;
    procedure SetTransparencyGroup(const CS: AnsiString; IsolateFlag, KnockoutFlag: Boolean);
  end;

  TPDFPainter = class
  private
    FSourceStream: TMemoryStream;
    //FSource: AnsiString;
    FOnChange: TNotifyEvent;
    FSelFont: TPDFFont;
    FTextSize: Double;
    FTextAlign: TPDFAlignment;
    FMetaTextAlign: Integer;
    FFillMode: Integer;
    FTextAngle: Integer;
    FTextSpacing: Double;
    FTextUnderline: TPDFUnderlineStyle;
    FTextHighlight: TPDFHighlightStyle;
    FTextWordSpacing: Double;
    FTextCharSpacing: Double;
    FTextScaling: Double;
    FTextRise: Double;
    FHTMLSettings: THTMLSettings;
    FLastX: Double;
    FLastY: Double;
    FUseKerning: Boolean;
    FParent: TObject;
    FUpdating: Boolean;

    LastX: Double;
    LastY: Double;
    Path: TQuickPDFStringList;
    RipePath: Boolean;
    LineCap: Integer;
    LineJoin: Integer;
    LineWidth: Double;
    MiterLimit: Double;

    procedure WordWrap(Text: AnsiString; List: TQuickPDFStringList; Width: Double;
      const BreakString: AnsiString); overload;
    procedure WordWrap(Text: AnsiString; List: TQuickPDFStringList; Width: Double;
      const BreakString: AnsiString; var Flags: TPDFTextBlockFlags); overload;
    procedure WideWordWrap(Text: WideString; List: TQuickPDFStringList; Width: Double;
      const BreakString: WideString); overload;
    procedure WideWordWrap(Text: WideString; List: TQuickPDFStringList; Width: Double;
      const BreakString: WideString; var Flags: TPDFTextBlockFlags); overload;

  protected
    FontLine: AnsiString;
    FontColorLine: AnsiString;
    FillColorLine: AnsiString;
    LineColorLine: AnsiString;
    LineWidthLine: AnsiString;
    LineDashLine: AnsiString;
    FontScalingLine: AnsiString;
    FontRiseLine: AnsiString;
    FontSpacingLine: AnsiString;
    HighlightColorLine: AnsiString;
    UnderlineColorLine: AnsiString;
    UnderlineCustomDash: AnsiString;
    UnderlineDashOn: Double;
    UnderlineDashOff: Double;
    FUnderlineWidth: Double;
    FUnderlineDistance: Double;
    TextMode: Integer;
    TextModeChanged: Boolean;

    FontChanged: Boolean;
    FontColorChanged: Boolean;
    FillColorChanged: Boolean;
    LineColorChanged: Boolean;
    LineWidthChanged: Boolean;
    LineDashChanged: Boolean;
    FontScalingChanged: Boolean;
    FontRiseChanged: Boolean;
    FontSpacingChanged: Boolean;
    TextAlignChanged: Boolean;

    procedure AddFloat(D: Double);
    function EscapeString(const S: AnsiString): AnsiString;
    procedure AddString(const S: AnsiString; const LineEnd: AnsiString = '');
    procedure RemoveEndText;
    function MakeFloat(D: Double): AnsiString;
    function GetSource: AnsiString;
    procedure RunOnChanged;
    function PrepareHTMLText(const HTMLText: WideString): AnsiString;
  public
    PDFPrecNum: Integer;
    HexColorLine: AnsiString;

    constructor Create(Parent: TObject = nil); virtual;
    destructor Destroy; override;

    procedure Add(const S: AnsiString; C: AnsiChar = #10);
    procedure Clear;
    procedure ChangeAll;
    procedure Reset;
    function GetState: AnsiString;
    procedure SetState(const NewState: AnsiString);
    procedure SetSource(const S: AnsiString);
    procedure DrawImage(Image: TPDFImage; Left, Top, Width, Height: Double);
    procedure DrawRotatedImage(Image: TPDFImage; Left, Bottom, Width, Height,
      Angle: Double);
    procedure DrawShearedImage(Image: TPDFImage; Left, Top, Width, Height,
      ShearX, ShearY: Double);
    procedure DrawImageMatrix(Image: TPDFImage; eM11, eM12, eM21, eM22, eDx,
      eDy: Double);
    procedure DrawXObject(CP: TPDFCapturedPage; Left, Top,
      Width, Height: Double);
    procedure DrawXObjectAngle(const XObjectRef: AnsiString; Left, Bottom, Width,
      Height, OriginalWidth, OriginalHeight, Angle: Double);
    procedure DrawXObjectMatrix(const XObjectRef: AnsiString; eM11, eM12, eM21,
      eM22, eDx, eDy, OriginalWidth, OriginalHeight: Double);
    procedure SelectFont(Font: TPDFFont; Size: Double);
    procedure SetTextColor(Red, Green, Blue: Double); overload;
    procedure SetTextColor(C, M, Y, K: Double); overload;
    procedure SetTextColor(const FontColor: AnsiString); overload;
    procedure SetTextColor(const CS: AnsiString; Tint: Double); overload;
    procedure SetTextShader(const CS: AnsiString);
    procedure SetFillColor(Red, Green, Blue: Double); overload;
    procedure SetFillColor(C, M, Y, K: Double); overload;
    procedure SetFillColor(const FillColor: AnsiString); overload;
    procedure SetFillColor(const CS: AnsiString; Tint: Double); overload;
    procedure SetFillShader(const CS: AnsiString);
    procedure SetFillPattern(const CS: AnsiString);
    procedure SetLineColor(Red, Green, Blue: Double); overload;
    procedure SetLineColor(C, M, Y, K: Double); overload;
    procedure SetLineColor(const LineColor: AnsiString); overload;
    procedure SetLineColor(const CS: AnsiString; Tint: Double); overload;
    procedure SetLineShader(const CS: AnsiString);
    procedure SetLineWidth(Width: Double);
    procedure SetMiterLimit(NewMiterLimit: Double);
    function LineWidthThou: Integer;
    procedure SetLineDash(DashOn, DashOff: Double); overload;
    function SetLineDashEx(const DashValues: AnsiString): Boolean;
    procedure SetCustomLineDash(const DashArray: AnsiString); overload;
    procedure SetLineDash(const LineDash: AnsiString); overload;
    procedure SetLineCap(ALineCap: Integer);
    procedure SetLineJoin(ALineJoin: Integer);
    procedure SetTextSpacing(Spacing: Double);
    procedure SetTextMode(Mode: Integer);
    procedure SetTextScaling(Scaling: Double);
    procedure SetTextRise(Rise: Double);
    procedure DrawText(XPos, YPos: Double; const Text: AnsiString);
    procedure DrawWideText(XPos, YPos: Double; const Text: WideString);
    procedure AppendText(const Text: WideString);
    procedure AppendSpace(Space: Double);
    procedure DrawRotatedText(XPos, YPos, Angle: Double; const Text: AnsiString);
    procedure DrawRotatedWideText(XPos, YPos, Angle: Double; const Text: WideString);
    procedure DrawWrappedText(XPos, YPos, Width: Double;
      const Text, BreakString: AnsiString);
    procedure DrawWrappedWideText(XPos, YPos, Width: Double;
      const Text, BreakString: WideString);
    procedure DrawMultiLineWideText(XPos, YPos: Double;
      const Delimiter, Text: WideString; Width: Double = 0); overload;
    procedure DrawMultiLineWideText(XPos, YPos: Double; const Delimiter,
      Text: WideString; var Flags: TPDFTextBlockFlags; Width: Double = 0); overload;
    procedure DrawMultiLineWideTextMatrix(Width, Height: Double; const Delimiter,
      Text: WideString; eM11, eM12, eM21, eM22, eDx, eDy: Double);
    procedure DrawRotatedMultiLineWideText(XPos, YPos, Angle: Double; const Delimiter,
      Text: WideString);
    procedure DrawMultiLineText(XPos, YPos: Double;
      const Delimiter, Text: AnsiString; Width: Double = 0); overload;
    procedure DrawMultiLineText(XPos, YPos: Double; const Delimiter,
      Text: AnsiString; var Flags: TPDFTextBlockFlags; Width: Double = 0); overload;
    function GetWrappedText(Width: Double; const Text, Delimiter,
      BreakString: AnsiString): AnsiString; overload;
    function GetWrappedWideText(Width: Double; const Text, Delimiter,
      BreakString: WideString): WideString; overload;
    function GetWrappedText(Width: Double; const Text, Delimiter,
      BreakString: AnsiString; var Flags: TPDFTextBlockFlags): AnsiString; overload;
    function GetWrappedWideText(Width: Double; const Text, Delimiter,
      BreakString: WideString; var Flags: TPDFTextBlockFlags): WideString; overload;
    function GetWrappedTextHeight(Width: Double; const Text,
      BreakString: AnsiString): Double; overload;
    function GetWrappedTextHeight(Width: Double; const Text,
      BreakString: AnsiString; var Flags: TPDFTextBlockFlags): Double; overload;
    function GetWrappedWideTextHeight(Width: Double; const Text,
      BreakString: WideString): Double; overload;
    function GetWrappedWideTextHeight(Width: Double; const Text,
      BreakString: WideString; var Flags: TPDFTextBlockFlags): Double; overload;
    function GetWrappedTextLineCount(Width: Double; const Text,
      BreakString: AnsiString): Integer;
    function GetWrappedWideTextLineCount(Width: Double; const Text,
      BreakString: WideString): Integer;
    function GetWrappedTextBreakString(Width: Double; const Text,
      Delimiter, BreakString: AnsiString): AnsiString;
    function GetWrappedWideTextBreakString(Width: Double; const Text,
      Delimiter, BreakString: WideString): WideString;
    procedure DrawSpacedText(XPos, YPos, Angle: Double;
      const Text: WideString; Offsets: array of Double);
    procedure DrawLine(StartX, StartY, EndX, EndY: Double);
    procedure Rectangle(Left, Top, Width, Height: Double; Fill,
      Outline: Boolean);
    procedure RotatedRectangle(Left, Bottom, Width, Height: Double; Angle: Double; Fill,
      Outline: Boolean);
    procedure RoundedRectangle(Left, Top, Width, Height, Radius: Double;
      Fill, Outline: Boolean);
    procedure RoundedRotatedRectangle(Left, Bottom, Width, Height, Radius, Angle: Double;
      Fill, Outline: Boolean);
    procedure RoundedRect(Left, Top, Width, Height, Radius1, Radius2: Double;
      Fill, Outline: Boolean);
    procedure Circle(XPos, YPos, Radius: Double; Fill, Outline: Boolean);
    procedure Ellipse(XPos, YPos, Width, Height: Double; Fill, Outline: Boolean);
    procedure Arc(XPos, YPos, Radius, StartAngle, EndAngle: Double; Pie, Fill,
      Outline, Close: Boolean);
    procedure EllipticArc(XPos, YPos, Width, Height, StartAngle,
      EndAngle: Double; Pie, Fill, Outline, Close: Boolean);
    procedure Scale(Scale: Double);
    procedure SetTextCharSpacing(CharSpacing: Double);
    procedure SetTextWordSpacing(WordSpacing: Double);
    function TextWidth(const Text: AnsiString): Double;
    function WideTextWidth(const Text: WideString): Double;
    function TextHeight: Double;
    function TextAscent: Double;
    function TextDescent: Double;
    function TextAscentTM: Double;
    function TextDescentTM: Double;
    function TextBound(Edge: Integer): Double;
    function GetTextMetrics(MetricType: Integer): Integer;
    procedure DrawBarcode(Left, Top, Width, Height: Double; const Text: AnsiString;
      Barcode, Options: Integer; Rotate: TBarcodeRotation; BarWidthReduction: Boolean);
    function DrawIntelligentMailBarcode(Left, Top, BarWidth, FullBarHeight, TrackerHeight,
      SpaceWidth: Double; const BarcodeData: WideString; Options: Integer;
      Rotate: TBarcodeRotation; BarWidthReduction: Boolean): Integer;
    procedure DrawDataMatrixSymbol(Left, Top, ModuleSize: Double;
      const Text: AnsiString; Encoding, SymbolSize, Options: Integer);
    function DrawPDF417Symbol(Left, Top: Double; const Text: WideString;
      Options, FixedRows, FixedColumns, ErrorLevel: Integer; ModuleSize, HeightWidthRatio: Double): Boolean;
    function DrawQRCode(Left, Top, SymbolSize: Double; const Text: WideString; EncodeOptions, DrawOptions: Integer): Boolean;
    procedure StartPath(StartX, StartY: Double);
    procedure AbortPath;
    procedure ClosePath;
    procedure AddLineToPath(EndX, EndY: Double);
    procedure AddCurveToPath(CtAX, CtAY, CtBX, CtBY, EndX, EndY: Double);
    procedure AddArcToPath(CenterX, CenterY, TotalAngle: Double);
    procedure AddBoxToPath(Left, Top, Width, Height: Double);
    procedure DrawPath(Fill, Outline: Boolean);
    procedure SetClippingPath;
    procedure DrawPathEvenOdd(Fill, Outline: Boolean);
    procedure MovePath(StartX, StartY: Double);
    procedure SetClippingPathEvenOdd;
    procedure SaveState;
    procedure LoadState;
    procedure DrawHTMLText(Left, Top, Width: Double; const HTMLText: WideString);
    function DrawHTMLTextBox(Left, Top, Width, Height: Double;
      const HTMLText: WideString): WideString;
    function DrawHTMLTextBoxMatrix(Width, Height: Double;
      const HTMLText: WideString; eM11, eM12, eM21, eM22, eDx, eDy: Double): WideString;
    function DrawHTMLTextMatrix(Width: Double;
      const HTMLText: WideString; eM11, eM12, eM21, eM22, eDx, eDy: Double): Integer;
    procedure SetHTMLNormalFont(AFont: TPDFFont);
    procedure SetHTMLBoldFont(AFont: TPDFFont);
    procedure SetHTMLItalicFont(AFont: TPDFFont);
    procedure SetHTMLBoldItalicFont(AFont: TPDFFont);
    procedure SetHTMLTagEquivalent(const NewTag, ExistingTag: AnsiString);
    function GetHTMLTextHeight(Width: Double; const HTMLText: WideString): Double;
    function GetHTMLTextHeightWithDescent(Width: Double; const HTMLText: WideString): Double;
    function GetHTMLLimitedTextHeight(Width, Height: Double; const HTMLText: WideString): Double;
    function GetHTMLTextWidth(MaxWidth: Double; const HTMLText: WideString): Double;
    function GetHTMLTextLineCount(Width: Double; const HTMLText: WideString): Integer;
    procedure SetGS(const GSName: AnsiString);
    procedure Rotate(XOffset, YOffset, Angle: Double);
    procedure FitTextBox(Left, Top, Width, Height: Double; const Text: AnsiString;
      Options: Integer; const BreakString: AnsiString = #13#10);
    procedure FitWideTextBox(Left, Top, Width, Height: Double; const Text: WideString;
      Options: Integer; const BreakString: WideString = #13#10);
    procedure Comb(Left, Top, Width, Height: Double; const Text: AnsiString; Blocks: Integer);
    procedure WideComb(Left, Top, Width, Height: Double; const Text: WideString; Blocks: Integer);
    procedure FitRotatedTextBox(Left, Top, Width, Height, Angle: Double;
      const Text: AnsiString; Options: Integer; const BreakString: AnsiString = #13#10);
    procedure FitRotatedWideTextBox(Left, Top, Width, Height, Angle: Double;
      const Text: WideString; Options: Integer; const BreakString: WideString = #13#10);
    function DrawTextBox(Left, Top, Width, Height: Double; const Text: AnsiString;
      Options: Integer; const BreakString: AnsiString = #13#10): Integer;
    function DrawWideTextBox(Left, Top, Width, Height: Double; const Text: WideString;
      Options: Integer; const BreakString: WideString = #13#10): Integer;
    function DrawWideTextBoxMatrix(Width, Height: Double; const Text: WideString;
      Options: Integer; const BreakString: WideString; eM11, eM12, eM21, eM22, eDx, eDy: Double): Integer;
    function DrawRotatedTextBox(Left, Top, Width, Height, Angle: Double;
      const Text: AnsiString; Options: Integer; const BreakString: AnsiString = #13#10): Integer;
    function DrawRotatedWideTextBox(Left, Top, Width, Height, Angle: Double;
      const Text: WideString; Options: Integer; const BreakString: WideString = #13#10): Integer;
    function DrawRotatedWideTextBoxEx(Left, Top, Width, Height, Angle: Double;
      const Text: WideString; Options: Integer; const BreakString: WideString = #13#10; Border: Integer = 0;
      Radius: Integer = 0; Fill: Boolean = False; Outline: Boolean = False): Integer;
    procedure DrawTextArc(XPos, YPos, Radius, Angle: Double; const Text: AnsiString;
      Options: Integer);
    procedure DrawWideTextArc(XPos, YPos, Radius, Angle: Double; const Text: WideString;
      Options: Integer);
    procedure SetHighlightColor(Red, Green, Blue: Double); overload;
    procedure SetHighlightColor(C, M, Y, K: Double); overload;
    procedure SetHighlightColor(const NewColor: AnsiString); overload;
    procedure SetHighlightColor(const CS: AnsiString; Tint: Double); overload;
    procedure SetUnderlineColor(Red, Green, Blue: Double); overload;
    procedure SetUnderlineColor(C, M, Y, K: Double); overload;
    procedure SetUnderlineColor(const NewColor: AnsiString); overload;
    procedure SetUnderlineColor(const CS: AnsiString; Tint: Double); overload;
    procedure SetUnderlineDash(DashOn, DashOff: Double);
    procedure SetUnderlineWidth(NewWidth: Double);
    procedure SetUnderlineDistance(NewDistance: Double);
    procedure SetUnderlineCustomDash(const DashPattern: AnsiString; DashPhase: Double); overload;
    procedure SetUnderlineCustomDashFull(const DashPattern: AnsiString);
    function GetTextMode: Integer;
    function GetLineWidth: Double;
    procedure ClearTextFormatting;
    procedure DrawPSXObject(const PSName: AnsiString);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure HideLineProperties;

    property Source: AnsiString read GetSource;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property TextAlign: TPDFAlignment read FTextAlign write FTextAlign;
    property MetaTextAlign: Integer read FMetaTextAlign write FMetaTextAlign;
    property FillMode: Integer read FFillMode write FFillMode;
    property TextAngle: Integer read FTextAngle write FTextAngle;
    property SelFont: TPDFFont read FSelFont;
    property TextSize: Double read FTextSize write FTextSize;
    property TextColor: AnsiString read FontColorLine;
    property FillColor: AnsiString read FillColorLine;
    property LineColor: AnsiString read LineColorLine;
    property TheLineWidthLine: AnsiString read LineWidthLine;
    property TextHighlight: TPDFHighlightStyle read FTextHighlight write FTextHighlight;
    property TextUnderline: TPDFUnderlineStyle read FTextUnderline write FTextUnderline;
    property TextCharSpacing: Double read FTextCharSpacing;
    property TextWordSpacing: Double read FTextWordSpacing;
    property TextScaling: Double read FTextScaling;
    property TextRise: Double read FTextRise;
    property TextSpacing: Double read FTextSpacing;
    property HighlightColor: AnsiString read HighlightColorLine;
    property UnderlineColor: AnsiString read UnderlineColorLine;
    property TextUnderlineDashOn: Double read UnderlineDashOn;
    property TextUnderlineDashOff: Double read UnderlineDashOff;
    property TextUnderlineCustomDash: AnsiString read UnderlineCustomDash;
    property LineDash: AnsiString read LineDashLine;
    property UnderlineWidth: Double read FUnderlineWidth write SetUnderlineWidth;
    property UnderlineDistance: Double read FUnderlineDistance write SetUnderlineDistance;
    property UseKerning: Boolean read FUseKerning write FUseKerning;
    property Parent: TObject read FParent write FParent;
  end;

function CountWords(Input: AnsiString): Integer;
function CountAnsiWideSpaces(const Input: AnsiString): Integer;
function CountWideWords(const Input: WideString): Integer;

const
  ALTERNATE = 1;
  WINDING = 2;

implementation

uses
  SysUtils, Math, DebenuPDFLibraryHTMLRender, DebenuPDFLibraryTypes,
  DebenuPDFLibraryIntelligentMailBarcode, DebenuPDFLibraryQRCode;

{ TPDFPainter }

procedure TPDFPainter.Add(const S: AnsiString; C: AnsiChar = #10);
begin
  if Length(S) > 0 then
  begin
    FSourceStream.Write(S[1], Length(S));
    if C <> #0 then
      FSourceStream.Write(C, 1);
  end;
end;

procedure TPDFPainter.AddCurveToPath(CtAX, CtAY, CtBX, CtBY, EndX,
  EndY: Double);
begin
  Path.Add(MakeFloat(CtAX) + MakeFloat(CtAY) + MakeFloat(CtBX) +
    MakeFloat(CtBY) + MakeFloat(EndX) + MakeFloat(EndY) + 'c');
  LastX := EndX;
  LastY := EndY;
end;

procedure TPDFPainter.AddFloat(D: Double);
begin
  Add(QPLDoubleToStr(D, PDFPrecNum) + ' ', #0);
end;

procedure TPDFPainter.AddLineToPath(EndX, EndY: Double);
begin
  Path.Add(MakeFloat(EndX) + MakeFloat(EndY) + 'l');
  LastX := EndX;
  LastY := EndY;
end;

procedure TPDFPainter.AddString(const S: AnsiString; const LineEnd: AnsiString);
var
  X: Integer;
  TempSource: AnsiString;
begin
  TempSource := '(';

  for X := 1 to Length(S) do
  begin
    case S[X] of
      #8:  TempSource := TempSource + '\b';
      #9:  TempSource := TempSource + '\t';
      #10: TempSource := TempSource + '\n';
      #12: TempSource := TempSource + '\f';
      #13: TempSource := TempSource + '\r';
      #40: TempSource := TempSource + '\(';
      #41: TempSource := TempSource + '\)';
      #92: TempSource := TempSource + '\\';
    else
      TempSource := TempSource + S[X];
    end;
  end;

  Add(TempSource + ')' + LineEnd, #10);
end;

function TPDFPainter.EscapeString(const S: AnsiString): AnsiString;
var
  X: Integer;
begin
  Result := '';
  for X := 1 to Length(S) do
  begin
    case S[X] of
      #8:  Result := Result + '\b';
      #9:  Result := Result + '\t';
      #10: Result := Result + '\n';
      #12: Result := Result + '\f';
      #13: Result := Result + '\r';
      #40: Result := Result + '\(';
      #41: Result := Result + '\)';
      #92: Result := Result + '\\';
    else
      Result := Result + S[X];
    end;
  end;
end;

procedure TPDFPainter.Arc(XPos, YPos, Radius, StartAngle, EndAngle: Double;
  Pie, Fill, Outline, Close: Boolean);
var
  X1, X2, Y1, Y2: Double;  // End points
  X1S, Y1S: Double;        // Squares of first end point
  CtAX, CtAY: Double;      // First control point
  CtBX, CtBY: Double;      // Second control point
  Kappa: Double;           // Control point distance
  Alpha: Double;           // Start angle, in radians
  Beta: Double;            // End angle, in radians
  AngleNow: Double;        // Current angle, in degrees
  Remaining: Double;       // Remaining angles
  ThisWedge: Double;       // Angle of this wedge
begin
  Alpha := DegToRad(90 - StartAngle);
  X1 := Radius * Cos(Alpha);
  Y1 := Radius * Sin(Alpha);
  if Pie then
  begin
    StartPath(XPos, YPos);
    AddLineToPath(XPos + X1, YPos + Y1);
  end else
    StartPath(XPos + X1, YPos + Y1);

  if (StartAngle>EndAngle) then
    Remaining := 360 - StartAngle + EndAngle
  else
    Remaining := EndAngle - StartAngle;
  AngleNow := StartAngle;

  repeat
    if Remaining > 90 then
      ThisWedge := 90
    else
      ThisWedge := Remaining;
    Remaining := Remaining - ThisWedge;

    Alpha := DegToRad(90 - AngleNow);
    Beta := DegToRad(90 - (AngleNow + ThisWedge));

    // Calculate start and end points
    X1 := Radius * Cos(Alpha);
    Y1 := Radius * Sin(Alpha);
    X2 := Radius * Cos(Beta);
    Y2 := Radius * Sin(Beta);

    // Calculate "kappa"
    X1S := Power(X1, 2);
    Y1S := Power(Y1, 2);
    Kappa := 4 * (Sqrt(2 * (X1S + Y1S) * (X1S + Y1S + X1 * X2 + Y1 * Y2)) -
      (X1S + Y1S + X1 * X2 + Y1 * Y2)) / (3 * (X1 * Y2 - Y1 * X2));

    // Calculate control points
    CtAX := XPos + X1 - Kappa * Y1;
    CtAY := YPos + Y1 + Kappa * X1;
    CtBX := XPos + X2 + Kappa * Y2;
    CtBY := YPos + Y2 - Kappa * X2;

    // Translate (X2,Y2) back to centre
    X2 := XPos + X2;
    Y2 := YPos + Y2;

    // Draw the curve
    AddCurveToPath(CtAX, CtAY, CtBX, CtBY, X2, Y2);

    AngleNow := AngleNow + ThisWedge;
  until Remaining <= 0.000001;

  if Pie or Close then ClosePath;

  // Paint the path
  DrawPath(Fill, Outline);

  FontColorChanged := True;
end;

procedure TPDFPainter.Circle(XPos, YPos, Radius: Double; Fill,
  Outline: Boolean);
var
  Kappa: Double;
begin
  Kappa := (Sqrt(2) - 1) / 3 * 4;

  if Outline and LineColorChanged then Add(LineColorLine);
  if Fill and FillColorChanged then Add(FillColorLine);
  if Outline and LineWidthChanged then Add(LineWidthLine);
  if Outline and LineDashChanged then Add(LineDashLine);

  AddFloat(XPos - Radius);
  AddFloat(YPos);
  Add('m');
  AddFloat(XPos - Radius);
  AddFloat(YPos - Radius * Kappa);
  AddFloat(XPos - Radius * Kappa);
  AddFloat(YPos - Radius);
  AddFloat(XPos);
  AddFloat(YPos - Radius);
  Add('c');

  AddFloat(XPos + Radius * Kappa);
  AddFloat(YPos - Radius);
  AddFloat(XPos + Radius);
  AddFloat(YPos - Radius * Kappa);
  AddFloat(XPos + Radius);
  AddFloat(YPos);
  Add('c');

  AddFloat(XPos + Radius);
  AddFloat(YPos + Radius * Kappa);
  AddFloat(XPos + Radius * Kappa);
  AddFloat(YPos + Radius);
  AddFloat(XPos);
  AddFloat(YPos + Radius);
  Add('c');

  AddFloat(XPos - Radius * Kappa);
  AddFloat(YPos + Radius);
  AddFloat(XPos - Radius);
  AddFloat(YPos + Radius * Kappa);
  AddFloat(XPos - Radius);
  AddFloat(YPos);
  Add('c');

  if Fill and (not Outline) then Add('f');
  if Outline and (not Fill) then Add('S');
  if Outline and Fill then Add('B');
  if (not Fill) and (not Outline) then Add('n');
  
  RunOnChanged;

  if Outline then
  begin
    LineDashChanged := False;
    LineWidthChanged := False;
    LineColorChanged := False;
  end;

  if Fill then
  begin
    FillColorChanged := False;
    FontColorChanged := True;
  end;
end;

procedure TPDFPainter.Clear;
begin
  Reset;
  FSelFont := nil;
  FTextSize := 0;
  FSourceStream.Clear;
  ChangeAll;
  FUpdating := False;
  RunOnChanged;
end;

procedure TPDFPainter.ClosePath;
begin
  if RipePath then
    Path.Add('h');
end;

constructor TPDFPainter.Create(Parent: TObject);
begin
  FParent := Parent;
  FSourceStream := TMemoryStream.Create;
  Clear;
  Path := TQuickPDFStringList.Create;
  RipePath := False;
  LineCap := 0;
  LineJoin := 0;
  LineWidth := 1;
  MiterLimit := 10;
  FUseKerning := False;
end;

destructor TPDFPainter.Destroy;
begin
  Path.Free;
  FSourceStream.Free;
  inherited Destroy;
end;

procedure TPDFPainter.DrawBarcode(Left, Top, Width, Height: Double;
  const Text: AnsiString; Barcode, Options: Integer; Rotate: TBarcodeRotation;
  BarWidthReduction: Boolean);
var
  Bars: TBarArray;
  Bar: Integer;
  TotalWidth: Integer;
  BarWidth: Double;
  BarPos: Double;
  Extend: Double;
  TW: Double;
  ATW: Double;
  PNTop: Double;
  RadAngle: Double;
  Angle: Double;
  SinA: AnsiString;
  CosA: AnsiString;
  NegSinA: AnsiString;
  XPos: Double;
  YPos: Double;
  Temp: Double;
begin
  case Rotate of
    brClockwise:
    begin
      Angle := -90;
      XPos := Left;
      YPos := Top;
      Left := 0;
      Temp := Height;
      Height := Width;
      Width := Temp;
      Top := Height;
    end;

    brAntiClockwise:
    begin
      Angle := 90;
      XPos := Left + Width;
      YPos := Top - Height;
      Left := 0;
      Temp := Height;
      Height := Width;
      Width := Temp;
      Top := Height;
    end;

    brUpsideDown: begin
      Angle := 180;
      XPos := Left + Width;
      YPos := Top;
      Left := 0;
      Top := Height;
    end;
  else
    Angle := 0;
    XPos := Left;
    YPos := Top - Height;
    Left := 0;
    Top := Height;
  end;

  RadAngle := DegToRad(Angle);
  CosA := MakeFloat(Cos(RadAngle));
  SinA := MakeFloat(Sin(RadAngle));
  NegSinA := MakeFloat(-Sin(RadAngle));

  case Barcode of
    1: TotalWidth := Code39(Text, Bars);
    2: TotalWidth := EAN13(Text, Bars);
    3: TotalWidth := Code128(Text, Bars);
    4: TotalWidth := PostNet(Text, Bars);
    5: TotalWidth := Interleaved2of5(Text, Bars);
  else
    TotalWidth := 0;
  end;
  BarPos := Left;
  Extend := (5 / TotalWidth) * Width;

  Add('q');
  Add(FillColorLine);
  Add(CosA + SinA + NegSinA + CosA + ' ' +
    MakeFloat(XPos) + MakeFloat(YPos) + 'cm');

  if (Barcode = 2) and (Options > 1) then
  begin
    FTextSize := 10;
    TW := TextWidth(QPLCopy(Text, 2, 6));
    ATW := (42 / TotalWidth) * Width;
    SelectFont(FSelFont, ATW / TW * FTextSize);
  end;

  if (Barcode <> 4) then
  begin
    for Bar := 0 to Length(Bars) - 1 do
    begin
      BarWidth := (Bars[Bar].Width / TotalWidth) * Width;
      if Bars[Bar].Filled then
      begin
        if BarWidthReduction then
        begin
          AddFloat(BarPos + 0.05 * BarWidth);
          AddFloat(Top);
          AddFloat(BarWidth - 0.1 * BarWidth);
        end else
        begin
          AddFloat(BarPos);
          AddFloat(Top);
          AddFloat(BarWidth);
        end;
        if ((Barcode = 2) and (Options > 0)) then
        begin
          if (Bar = 0) or (Bar = 2) or (Bar = 28) or (Bar = 30) or (Bar = 56) or (Bar = 58) then
            AddFloat(-Height - Extend)
          else
            AddFloat(-Height);
        end else
          AddFloat(-Height);
        Add('re');
      end;
      BarPos := BarPos + BarWidth;
    end;
    if (Barcode = 5) and ((Options = 2) or (Options = 3)) then
    begin
      Add('f');
      AddFloat(Left);
      AddFloat(Top - Bars[0].Width * 3);
      AddFloat(Width);
      AddFloat(Bars[0].Width * 3);
      Add('re f');
      AddFloat(Left);
      AddFloat(Top - Height);
      AddFloat(Width);
      AddFloat(Bars[0].Width * 3);
      Add('re f');      
    end;
  end else
  begin
    BarPos := Left + (Width - (TotalWidth * (0.05 * 72) - (0.03 * 72))) / 2;
    PNTop := Top - (Height - 9) / 2;
    for Bar := 0 to Length(Bars) - 1 do
    begin
      AddFloat(BarPos);
      AddFloat(PNTop - 9);
      AddFloat(0.02 * 72);
      if Bars[Bar].Filled then
        AddFloat(9)
      else
        AddFloat(3.6);
      Add('re');
      BarPos := BarPos + (0.05 * 72);
    end;
  end;

  Add('f');

  if (Barcode = 2) and (Options > 1) then
  begin
    BarPos := Top - Height - TextAscent - Width / TotalWidth;
    TextAlign := paLeft;
    DrawText(Left - (11 / TotalWidth) * Width, BarPos, QPLCopy(Text, 1, 1));
    TextAlign := paCenter;
    DrawText(Left + (24.5 / TotalWidth) * Width,
      BarPos, QPLCopy(Text, 2, 6));
    DrawText(Left + (70.5 / TotalWidth) * Width,
      BarPos, QPLCopy(Text, 8, 6));
    if Options = 3 then
    begin
      TextAlign := paRight;
      TW := (7 / TotalWidth) * Width;
      if ((1 / TotalWidth) * Width + TextWidth('>')) > TW then
        TW := ((1 / TotalWidth) * Width + TextWidth('>'));
      DrawText(Left + Width + TW, BarPos, '>');
    end;
    TextAlign := paLeft;
  end;

  Add('Q');

  RunOnChanged;
end;

procedure TPDFPainter.DrawImage(Image: TPDFImage; Left, Top, Width,
  Height: Double);
begin
  Add('q');
  if (Image.GetMaskType = mtStencilMask) and FillColorChanged then
    Add(FillColorLine);

  if (Image.ImageType <> itEMF) then
  begin
    AddFloat(Width);
    AddFloat(0);
    AddFloat(0);
    AddFloat(Height);
    AddFloat(Left);
    AddFloat(Top - Height);
    Add('cm');
    Add('/' + Image.Name + ' Do');
    Add('Q');
  end else
  begin
    AddFloat(Min(Width, Height));
    AddFloat(0);
    AddFloat(0);
    AddFloat(Min(Width, Height));
    AddFloat(Left);
    AddFloat(Top - Height);
    Add('cm');
    Add('/' + Image.Name + ' Do');
    Add('Q');
  end;

  RunOnChanged;
end;

procedure TPDFPainter.DrawImageMatrix(Image: TPDFImage; eM11, eM12, eM21, eM22,
  eDx, eDy: Double);
begin
  Add('q');
  if (Image.GetMaskType = mtStencilMask) and FillColorChanged then
    Add(FillColorLine);
  AddFloat(eM11);
  AddFloat(eM12);
  AddFloat(eM21);
  AddFloat(eM22);
  AddFloat(eDx);
  AddFloat(eDy);
  Add('cm');
  Add('/' + Image.Name + ' Do');
  Add('Q');
  RunOnChanged;
end;

function TPDFPainter.DrawIntelligentMailBarcode(Left, Top, BarWidth,
  FullBarHeight, TrackerHeight, SpaceWidth: Double;
  const BarcodeData: WideString; Options: Integer; Rotate: TBarcodeRotation;
  BarWidthReduction: Boolean): Integer;
var
  Bar: Integer;
  Width: Double;
  Height: Double;
  BarPos: Double;
  RadAngle: Double;
  Angle: Double;
  SinA: AnsiString;
  CosA: AnsiString;
  NegSinA: AnsiString;
  XPos: Double;
  YPos: Double;
  Encoder: TOneCodeBars;
  Bars: WideString;
  GD: Double;
begin
  Result := 0;

  Encoder := TOneCodeBars.Create(BarcodeData);
  try
    Bars := Encoder.Encoded;
  finally
    Encoder.Free;
  end;

  if (Bars <> '') then
  begin
    Result := 1;

    Width := (BarWidth * 65) + (SpaceWidth * 64);
    Height := FullBarHeight;

    case Rotate of
      brClockwise:
      begin
        Angle := -90;
        XPos := Left;
        YPos := Top;
        Left := 0;
        //Temp := FullBarHeight;
        Height := Width;
        //Width := Temp;
        Top := Height;
      end;

      brAntiClockwise:
      begin
        Angle := 90;
        XPos := Left + Width;
        YPos := Top - Height;
        Left := 0;
        //Temp := Height;
        Height := Width;
        //Width := Temp;
        Top := Height;
      end;

      brUpsideDown:
      begin
        Angle := 180;
        XPos := Left + Width;
        YPos := Top;
        Left := 0;
        Top := Height;
      end;
    else
      Angle := 0;
      XPos := Left;
      YPos := Top - Height;
      Left := 0;
      Top := Height;
    end;

    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));

    Add('q');
    Add(FillColorLine);
    Add(CosA + SinA + NegSinA + CosA + ' ' +
      MakeFloat(XPos) + MakeFloat(YPos) + 'cm');

    GD := (FullBarHeight - TrackerHeight) / 2;

    BarPos := Left;
    for Bar := 1 to 65 do
    begin
      AddFloat(BarPos);
      if (Bars[Bar] = 'F') then
      begin
        AddFloat(Top - FullBarHeight);
        AddFloat(BarWidth);
        AddFloat(FullBarHeight);
      end else
      if (Bars[Bar] = 'A') then
      begin
        AddFloat(Top - FullBarHeight + GD);
        AddFloat(BarWidth);
        AddFloat(TrackerHeight + GD);
      end else
      if (Bars[Bar] = 'D') then
      begin
        AddFloat(Top - FullBarHeight);
        AddFloat(BarWidth);
        AddFloat(TrackerHeight + GD);
      end else
      if (Bars[Bar] = 'T') then
      begin
        AddFloat(Top - FullBarHeight + GD);
        AddFloat(BarWidth);
        AddFloat(TrackerHeight);
      end;
      Add('re');
      BarPos := BarPos + BarWidth + SpaceWidth;
    end;

    Add('f');
    Add('Q');

    RunOnChanged;
  end;
end;

procedure TPDFPainter.DrawLine(StartX, StartY, EndX, EndY: Double);
begin
  if LineColorChanged then Add(LineColorLine);
  if LineWidthChanged then Add(LineWidthLine);
  if LineDashChanged then Add(LineDashLine);
  Add(MakeFloat(StartX) + MakeFloat(StartY) + 'm ' +
    MakeFloat(EndX) + MakeFloat(EndY) + 'l S');
  RunOnChanged;
  LineColorChanged := False;
  LineWidthChanged := False;
  LineDashChanged := False;
end;

function CountWords(Input: AnsiString): Integer;
var
  P: Integer;
begin
  Result := 1;
  P := QPLPos(' ', Input);
  while P > 0 do
  begin
    Inc(Result);
    Delete(Input, 1, P);
    P := QPLPos(' ', Input);
  end;
end;

function CountAnsiWideSpaces(const Input: AnsiString): Integer;
var
  X: Integer;
  W: Word;
begin
  Result := 0;
  for X := 1 to Length(Input) div 2 do
  begin
    W := Ord(Input[X * 2 - 1]) * 256 + Ord(Input[X * 2]);
    if ((W = 32) or (W = 160)) then Inc(Result);
  end;
end;

function CountWideWords(const Input: WideString): Integer;
var
  X: Integer;
begin
  if (Input = '') then
  begin
    Result := 0;
  end else
  begin
    Result := 1;
  end;

  for X := 1 to Length(Input) do
  begin
    if ((Ord(Input[X]) = 32) or (Ord(Input[X]) = 160)) then
    begin
      Inc(Result);
    end;
  end;
end;

procedure TPDFPainter.DrawMultiLineText(XPos, YPos: Double;
  const Delimiter, Text: AnsiString; Width: Double);
var
  DummyFlags: TPDFTextBlockFlags;
begin
  DrawMultiLineText(XPos, YPos, Delimiter, Text, DummyFlags, Width);
end;

procedure TPDFPainter.DrawMultiLineText(XPos, YPos: Double;
  const Delimiter, Text: AnsiString; var Flags: TPDFTextBlockFlags; Width: Double);
var
  List: TQuickPDFStringList;
  Line: Integer;
  TextW: Double;
  Extra: Double;
  MainText: AnsiString;
  WordCount: Integer;
  LastLine: Boolean;
  ThisLine: AnsiString;
  LineTw: Double;
  LineTc: Double;
  LastTw: Double;
  LastTc: Double;
  X, L: Integer;
  YPosOrig: Double;
  LineXPos: Double;
  OldFillColorLine: AnsiString;
  OldLineColorLine: AnsiString;
  OldLineDashLine: AnsiString;
  OldLineWidth: Double;
  ADel: AnsiString;
  RX: Integer;
  RText: AnsiString;
begin
  if FSelFont.FontType = ftCJK then
  begin
    ADel := '';
    for X := 1 to Length(Delimiter) do
      ADel := ADel + #0 + Delimiter[X];
  end else
    ADel := Delimiter;
  YPosOrig := YPos;
  List := TQuickPDFStringList.Create;
  try
    MainText := Text;
    while QPLPos(ADel, MainText) > 0 do
    begin
      List.Add(QPLCopy(MainText, 1, QPLPos(ADel, MainText) - 1));
      Delete(MainText, 1, QPLPos(ADel, MainText));
      Delete(MainText, 1, Length(ADel) - 1);
    end;
    List.Add(MainText);

    L := Length(Flags);
    if L < List.Count then
    begin
      SetLength(Flags, List.Count);
      for X := L to List.Count - 1 do
      begin
        Flags[X].WordCount := 0;
        Flags[X].ForcedBreak := False;
      end;
    end;
    if FTextHighlight <> hsNone then
    begin
      OldFillColorLine := FillColorLine;
      FillColorLine := HighlightColorLine;
      FillColorChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        if Length(List[Line]) > 0 then
        begin
          LastLine := Line = (List.Count - 1);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
          if (FTextAlign = paForceJustified) then
            TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
            TextW := TextWidth(List[Line]) - FTextCharSpacing * (FTextScaling / 100);
          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos - TextW;
          if FTextAlign = paCenter then
             LineXPos := XPos - TextW / 2;
          if FTextHighlight = hsSquare then
            Rectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1,
              TextHeight, True, False);
          if FTextHighlight = hsRounded then
            RoundedRectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1,
              TextHeight, TextHeight / 4, True, False);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      FillColorLine := OldFillColorLine;
      FillColorChanged := True;
      FontColorChanged := True;
      YPos := YPosOrig;
    end;

    LineTw := FTextWordSpacing;
    LineTc := FTextCharSpacing;
    LastTw := LineTw;
    LastTc := LineTc;

    if TextModeChanged then Add(QPLIntToStr(TextMode) + ' Tr');
    if (TextMode = 1) or (TextMode = 2) or (TextMode = 5) or (TextMode = 6) then
    begin
      if LineColorChanged then Add(LineColorLine);
      if LineWidthChanged then Add(LineWidthLine);
      if LineDashChanged then Add(LineDashLine);
      LineColorChanged := False;
      LineWidthChanged := False;
      LineDashChanged := False;
    end;
    TextModeChanged := False;

    if FontChanged then Add(FontLine);
    if FontColorChanged then Add(FontColorLine);
    if FontScalingChanged then Add(FontScalingLine);
    if FontSpacingChanged then Add(FontSpacingLine);
    if FontRiseChanged then Add(FontRiseLine);

    RemoveEndText;

    if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
      (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
    begin
      Extra := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 1000;
      Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos + Extra + FTextSpacing) + 'Tm');
      Add(MakeFloat(Extra + FTextSpacing) + 'TL');
    end;
    for Line := 0 to List.Count - 1 do
    begin
      ThisLine := List[Line];
      LastLine := Line = (List.Count - 1);
      WordCount := CountAnsiWideSpaces(ThisLine);
      LineTw := FTextWordSpacing;
      LineTc := FTextCharSpacing;
      if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
        (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
      begin
        if (FTextAlign = paJustified) and (Width > 0) then
        begin
          Extra := Width - TextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (not LastLine) and (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (not LastLine) and (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;

        end;
        if (FTextAlign = paForceJustified) and (Width > 0) then
        begin
          Extra := Width - TextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if (FTextAlign = paLastJustified) and (Width > 0) then
        begin
          Extra := Width - TextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if LineTw <> LastTw then
        begin
          Add(MakeFloat(LineTw) + 'Tw');
          FontSpacingChanged := True;
        end;
        if LineTc <> LastTc then
        begin
          Add(MakeFloat(LineTc) + 'Tc');
          FontSpacingChanged := True;
        end;
        LastTw := LineTw;
        LastTc := LineTc;
        RText := List[Line];
        for RX := 1 to Length(RText) div 2 do
          if QPLCopy(RText, RX * 2 - 1, 2) = #0#160 then
            RText[RX * 2] := #32;
        List[Line] := RText;
        AddString(List[Line], '''');
      end else
      begin
        TextW := TextWidth(List[Line]) - LineTc * (FTextScaling / 100);
        if FTextAlign = paRight then
          Add('1 0 0 1 ' + MakeFloat(XPos - TextW) + MakeFloat(YPos) + 'Tm');

        if FTextAlign = paCenter then
          Add('1 0 0 1 ' + MakeFloat(XPos - TextW / 2) +
            MakeFloat(YPos) + 'Tm');

        if FSelFont.FontType = ftCJK then
        begin
          RText := List[Line];
          for RX := 1 to Length(RText) div 2 do
            if QPLCopy(RText, RX * 2 - 1, 2) = #0#160 then
              RText[RX * 2] := #32;
          List[Line] := RText;
        end;
        AddString(List[Line], 'Tj');

        YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
          FTextSize / 1000 - FTextSpacing;

      end;
    end;
    Add('ET');
    FontChanged := False;
    FontColorChanged := False;
    FontScalingChanged := False;
    FontSpacingChanged := (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified);
    FontRiseChanged := False;
    YPos := YPosOrig;
    if FTextUnderline <> usNone then
    begin
      OldLineColorLine := LineColorLine;
      OldLineWidth := LineWidth;
      OldLineDashLine := LineDashLine;
      LineColorLine := UnderlineColorLine;
      LineColorChanged := True;

      SetLineWidth(FUnderlineWidth);
      if (UnderlineDashOn = 0) or (UnderlineDashOff = 0) then
      begin
        if LineDashLine <> '[] 0 d' then LineDashLine := '[] 0 d';
      end else
        SetLineDash(UnderlineDashOn * LineWidth, UnderlineDashOff * LineWidth);
      LineDashChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        if Length(List[Line]) > 0 then
        begin
          LastLine := Line = (List.Count - 1);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
          if (FTextAlign = paForceJustified) then
             TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
             TextW := Width
          else
            TextW := TextWidth(List[Line]) - FTextCharSpacing * (FTextScaling / 100);

          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos - TextW;
          if FTextAlign = paCenter then
            LineXPos := XPos - TextW / 2;

          if (FTextUnderline = usSingle) or (FTextUnderline = usDouble) then
            DrawLine(LineXPos, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance,
              LineXPos + TextW, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance);
          if FTextUnderline = usDouble then
            DrawLine(LineXPos, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2,
              LineXPos + TextW, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2);
          if (FTextUnderline = usStrikeout) then
            DrawLine(LineXPos, YPos + FTextSize * 0.3 + FUnderlineDistance,
              LineXPos + TextW, YPos + FTextSize * 0.3 + FUnderlineDistance);
          if (FTextUnderline = usOver) then
            DrawLine(LineXPos, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance,
              LineXPos + TextW, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      SetLineWidth(OldLineWidth);
      LineColorLine := OldLineColorLine;
      LineDashLine := OldLineDashLine;
      LineColorChanged := True;
      LineDashChanged := True;
    end;
  finally
    List.Free;
  end;

  RunOnChanged;
end;

procedure TPDFPainter.DrawMultiLineWideText(XPos, YPos: Double;
  const Delimiter, Text: WideString; Width: Double);
var
  DummyFlags: TPDFTextBlockFlags;
begin
  DrawMultiLineWideText(XPos, YPos, Delimiter, Text, DummyFlags, Width);
end;

procedure TPDFPainter.DrawMultiLineWideText(XPos, YPos: Double;
  const Delimiter, Text: WideString; var Flags: TPDFTextBlockFlags; Width: Double);
var
  List: TQuickPDFStringList;
  Line: Integer;
  TextW: Double;
  Extra: Double;
  MainText: WideString;
  WordCount: Integer;
  LastLine: Boolean;
  ThisLine: WideString;
  LineTw: Double;
  LineTc: Double;
  LastTw: Double;
  LastTc: Double;
  X, L: Integer;
  YPosOrig: Double;
  LineXPos: Double;
  OldFillColorLine: AnsiString;
  OldLineColorLine: AnsiString;
  OldLineDashLine: AnsiString;
  OldLineWidth: Double;
begin
  YPosOrig := YPos;
  List := TQuickPDFStringList.Create;
  try

    // Split the text into lines using the Delimiter parameter
    // Store the strings in UTF-8 format in List
    MainText := Text;
    while Pos(Delimiter, MainText) > 0 do
    begin
      List.Add(QPLUTF8Encode(Copy(MainText, 1, Pos(Delimiter, MainText) - 1)));
      Delete(MainText, 1, Pos(Delimiter, MainText) + Length(Delimiter) - 1);
    end;
    List.Add(QPLUTF8Encode(MainText));

    L := Length(Flags);
    if L < List.Count then
    begin
      SetLength(Flags, List.Count);
      for X := L to List.Count - 1 do
      begin
        Flags[X].WordCount := 0;
        Flags[X].ForcedBreak := False;
      end;
    end;
    if FTextHighlight <> hsNone then
    begin
      OldFillColorLine := FillColorLine;
      FillColorLine := HighlightColorLine;
      FillColorChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        if Length(List[Line]) > 0 then
        begin
          ThisLine := QPLUTF8Decode(List[Line]);
          LastLine := Line = (List.Count - 1);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
          if (FTextAlign = paForceJustified) then
            TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
            TextW := WideTextWidth(ThisLine) - FTextCharSpacing * (FTextScaling / 100);
          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos - TextW;
          if FTextAlign = paCenter then
             LineXPos := XPos - TextW / 2;
          if FTextHighlight = hsSquare then
            Rectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1,
              TextHeight, True, False);
          if FTextHighlight = hsRounded then
            RoundedRectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1,
              TextHeight, TextHeight / 4, True, False);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      FillColorLine := OldFillColorLine;
      FillColorChanged := True;
      FontColorChanged := True;
      YPos := YPosOrig;
    end;

    LineTw := FTextWordSpacing;
    LineTc := FTextCharSpacing;
    LastTw := LineTw;
    LastTc := LineTc;

    if TextModeChanged then Add(QPLIntToStr(TextMode) + ' Tr');
    if (TextMode = 1) or (TextMode = 2) or (TextMode = 5) or (TextMode = 6) then
    begin
      if LineColorChanged then Add(LineColorLine);
      if LineWidthChanged then Add(LineWidthLine);
      if LineDashChanged then Add(LineDashLine);
      LineColorChanged := False;
      LineWidthChanged := False;
      LineDashChanged := False;
    end;
    TextModeChanged := False;

    if FontChanged then Add(FontLine);
    if FontColorChanged then Add(FontColorLine);
    if FontScalingChanged then Add(FontScalingLine);
    if FontSpacingChanged then Add(FontSpacingLine);
    if FontRiseChanged then Add(FontRiseLine);

    RemoveEndText;

    if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
      (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
    begin
      Extra := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 1000;
      Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos + Extra + FTextSpacing) + 'Tm');
      Add(MakeFloat(Extra + FTextSpacing) + 'TL');
    end;
    for Line := 0 to List.Count - 1 do
    begin
      ThisLine := QPLUTF8Decode(List[Line]);
      LastLine := Line = (List.Count - 1);
      WordCount := CountWideWords(ThisLine);
      LineTw := FTextWordSpacing;
      LineTc := FTextCharSpacing;
      if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
        (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
      begin
        if (FTextAlign = paJustified) and (Width > 0) then
        begin
          Extra := Width - WideTextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (not LastLine) and (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (not LastLine) and (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if (FTextAlign = paForceJustified) and (Width > 0) then
        begin
          Extra := Width - WideTextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if (FTextAlign = paLastJustified) and (Width > 0) then
        begin
          Extra := Width - WideTextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if LineTw <> LastTw then
        begin
          Add(MakeFloat(LineTw) + 'Tw');
          FontSpacingChanged := True;
        end;
        if LineTc <> LastTc then
        begin
          Add(MakeFloat(LineTc) + 'Tc');
          FontSpacingChanged := True;
        end;
        LastTw := LineTw;
        LastTc := LineTc;
        AddString(FSelFont.GetCharacterCodes(ThisLine), '''');
      end else
      begin
        ThisLine := QPLUTF8Decode(List[Line]);
        TextW := WideTextWidth(ThisLine) - LineTc * (FTextScaling / 100);
        if FTextAlign = paRight then
          Add('1 0 0 1 ' + MakeFloat(XPos - TextW) + MakeFloat(YPos) + 'Tm');

        if FTextAlign = paCenter then
          Add('1 0 0 1 ' + MakeFloat(XPos - TextW / 2) +
            MakeFloat(YPos) + 'Tm');

        AddString(FSelFont.GetCharacterCodes(ThisLine), 'Tj');

        YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
          FTextSize / 1000 - FTextSpacing;
      end;
    end;

    Add('ET');
    FontChanged := False;
    FontColorChanged := False;
    FontScalingChanged := False;
    FontSpacingChanged := (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified);
    FontRiseChanged := False;
    YPos := YPosOrig;
    if FTextUnderline <> usNone then
    begin
      OldLineColorLine := LineColorLine;
      OldLineWidth := LineWidth;
      OldLineDashLine := LineDashLine;
      LineColorLine := UnderlineColorLine;
      LineColorChanged := True;

      SetLineWidth(FUnderlineWidth);
      if (UnderlineDashOn = 0) or (UnderlineDashOff = 0) then
      begin
        if LineDashLine <> '[] 0 d' then LineDashLine := '[] 0 d';
      end else
        SetLineDash(UnderlineDashOn * LineWidth, UnderlineDashOff * LineWidth);
      LineDashChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        if Length(List[Line]) > 0 then
        begin
          LastLine := Line = (List.Count - 1);
          ThisLine := QPLUTF8Decode(List[Line]);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
          if (FTextAlign = paForceJustified) then
             TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
             TextW := Width
          else
            TextW := WideTextWidth(ThisLine) - FTextCharSpacing * (FTextScaling / 100);

          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos - TextW;
          if FTextAlign = paCenter then
            LineXPos := XPos - TextW / 2;

          if (FTextUnderline = usSingle) or (FTextUnderline = usDouble) then
            DrawLine(LineXPos, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance,
              LineXPos + TextW, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance);
          if FTextUnderline = usDouble then
            DrawLine(LineXPos, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2,
              LineXPos + TextW, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2);
          if (FTextUnderline = usStrikeout) then
            DrawLine(LineXPos, YPos + FTextSize * 0.3 + FUnderlineDistance,
              LineXPos + TextW, YPos + FTextSize * 0.3 + FUnderlineDistance);
          if (FTextUnderline = usOver) then
            DrawLine(LineXPos, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance,
              LineXPos + TextW, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      SetLineWidth(OldLineWidth);
      LineColorLine := OldLineColorLine;
      LineDashLine := OldLineDashLine;
      LineColorChanged := True;
      LineDashChanged := True;
    end;
  finally
    List.Free;
  end;

  RunOnChanged;
end;

procedure TPDFPainter.DrawMultiLineWideTextMatrix(Width, Height: Double; const Delimiter,
  Text: WideString; eM11, eM12, eM21, eM22, eDx, eDy: Double);
var
  DummyFlags: TPDFTextBlockFlags;
begin
  Add('q');
  AddFloat(eM11);
  AddFloat(eM12);
  AddFloat(eM21);
  AddFloat(eM22);
  AddFloat(eDx);
  AddFloat(eDy);
  Add('cm');

  AddFloat(1 / Width);
  AddFloat(0);
  AddFloat(0);
  AddFloat(1 / Height);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  DrawMultiLineWideText(0, Height - TextHeight, Delimiter, Text, DummyFlags, 0);
  Add('Q');
  RunOnChanged;
end;

procedure TPDFPainter.DrawPath(Fill, Outline: Boolean);
var
  PathLine: Integer;
begin

  if RipePath then
  begin
    if LineColorChanged then Add(LineColorLine);
    if FillColorChanged then Add(FillColorLine);
    if LineWidthChanged then Add(LineWidthLine);
    if LineDashChanged then Add(LineDashLine);

    for PathLine := 0 to Path.Count - 1 do
      Add(Path[PathLine]);

    if Fill and (not Outline) then Add('f');
    if Outline and (not Fill) then Add('S');
    if Outline and Fill then Add('B');
    if (not Fill) and (not Outline) then Add('n');

    Path.Clear;
    RunOnChanged;
    RipePath := False;

    FillColorChanged := False;
    LineColorChanged := False;
    LineDashChanged := False;
    LineWidthChanged := False;
  end;
  FontColorChanged := True;
end;

procedure TPDFPainter.DrawRotatedText(XPos, YPos, Angle: Double; const Text: AnsiString);
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  try
    PDFPrecNum := 8;
    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add(CosA + SinA + NegSinA + CosA + ' ' +
      MakeFloat(XPos) + MakeFloat(YPos) + 'cm');
    try
      DrawText(0, 0, Text);
    finally
      RadAngle := DegToRad(-Angle);
      CosA := MakeFloat(Cos(RadAngle));
      SinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(CosA + SinA + NegSinA + CosA + ' ' +
        MakeFloat(0) + MakeFloat(0) + 'cm');
      Add('1 0 0 1 ' + MakeFloat(-XPos) + MakeFloat(-YPos) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

procedure TPDFPainter.DrawRotatedWideText(XPos, YPos, Angle: Double; const Text: WideString);
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  try
    PDFPrecNum := 8;
    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add(CosA + SinA + NegSinA + CosA + ' ' +
      MakeFloat(XPos) + MakeFloat(YPos) + 'cm');
    try
      DrawWideText(0, 0, Text);
    finally
      RadAngle := DegToRad(-Angle);
      CosA := MakeFloat(Cos(RadAngle));
      SinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(CosA + SinA + NegSinA + CosA + ' ' +
        MakeFloat(0) + MakeFloat(0) + 'cm');
      Add('1 0 0 1 ' + MakeFloat(-XPos) + MakeFloat(-YPos) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

procedure TPDFPainter.DrawText(XPos, YPos: Double; const Text: AnsiString);
var
  TextW: Double;
  OldLineWidth: Double;
  OldLineColorLine: AnsiString;
  OldFillColorLine: AnsiString;
  OldLineDashLine: AnsiString;
  TextLine: AnsiString;
  KX: Integer;
  KernAdjust: Integer;
  C1: AnsiChar;
  C2: AnsiChar;
  RX: Integer;
  RText: AnsiString;
begin
  if (FTextHighlight <> hsNone) or (FTextUnderline <> usNone) or (FTextAlign = paCenter) or (FTextAlign = paRight) then
    TextW := TextWidth(Text) - FTextCharSpacing * (FTextScaling / 100)
  else
    TextW := 0;

  case FTextAlign of
    paCenter: XPos := XPos - TextW / 2;
    paRight: XPos := XPos - TextW;
  end;

  if FTextHighlight <> hsNone then
  begin
    OldFillColorLine := FillColorLine;
    FillColorLine := HighlightColorLine;
    FillColorChanged := True;
    if FTextHighlight = hsSquare then
      Rectangle(XPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, True, False);
    if FTextHighlight = hsRounded then
      RoundedRectangle(XPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, TextHeight / 4, True, False);
    FillColorLine := OldFillColorLine;
    FillColorChanged := True;
    FontColorChanged := True;
  end;

  if TextModeChanged then Add(QPLIntToStr(TextMode) + ' Tr');
  if (TextMode = 1) or (TextMode = 2) or (TextMode = 5) or (TextMode = 6) then
  begin
    if LineColorChanged then Add(LineColorLine);
    if LineWidthChanged then Add(LineWidthLine);
    if LineDashChanged then Add(LineDashLine);
    LineColorChanged := False;
    LineWidthChanged := False;
    LineDashChanged := False;
  end;
  TextModeChanged := False;

  if FontChanged then Add(FontLine);
  if FontColorChanged then Add(FontColorLine);
  if FontScalingChanged then Add(FontScalingLine);
  if FontRiseChanged then Add(FontRiseLine);
  if FontSpacingChanged then Add(FontSpacingLine);

  RemoveEndText;

  Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos) + 'Tm');
  if (FSelFont.FontType <> ftCJK) and FUseKerning and (Text <> '') then
  begin
    Add('[');
    C1 := Text[1];
    TextLine := C1;
    for KX := 2 to Length(Text) do
    begin
      C2 := Text[KX];
      KernAdjust := FSelFont.GetKernAmount(WideChar(C1), WideChar(C2));
      if KernAdjust <> 0 then
      begin
        AddString(TextLine);
        AddFloat(KernAdjust);        
        TextLine := C2;
      end else
        TextLine := TextLine + C2;
      C1 := C2;
    end;
    if TextLine <> '' then
      AddString(TextLine, '] TJ')
    else
      Add('] TJ');    
  end else
  begin
    RText := Text;
    if FSelFont.FontType = ftCJK then
    begin
      for RX := 1 to Length(RText) div 2 do
        if QPLCopy(RText, RX * 2 - 1, 2) = #0#160 then
          RText[RX * 2] := #32;
    end;
    AddString(RText, 'Tj');
  end;
  Add('ET');

  FLastX := XPos + TextWidth(Text);
  FLastY := YPos;

  FontChanged := False;
  FontColorChanged := False;
  FontScalingChanged := False;
  FontRiseChanged := False;
  FontSpacingChanged := False;
  if FTextUnderline <> usNone then
  begin
    OldLineColorLine := LineColorLine;
    OldLineDashLine := LineDashLine;
    OldLineWidth := LineWidth;
    LineColorLine := UnderlineColorLine;
    SetLineWidth(FUnderlineWidth);
    LineColorChanged := True;
    if (UnderlineDashOn = 0) or (UnderlineDashOff = 0) then
    begin
      if LineDashLine <> '[] 0 d' then LineDashLine := '[] 0 d';
    end else
      SetLineDash(UnderlineDashOn * LineWidth, UnderlineDashOff * LineWidth);
    LineDashChanged := True;

    if (FTextUnderline = usSingle) or (FTextUnderline = usDouble) then
      DrawLine(XPos, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance,
        XPos + TextW, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance);
    if FTextUnderline = usDouble then
      DrawLine(XPos, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2,
        XPos + TextW, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2);
    if (FTextUnderline = usStrikeout) then
      DrawLine(XPos, YPos + FTextSize * 0.3 + FUnderlineDistance,
        XPos + TextW, YPos + FTextSize * 0.3 + FUnderlineDistance);
    if (FTextUnderline = usOver) then
      DrawLine(XPos, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance,
        XPos + TextW, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance);
    SetLineWidth(OldLineWidth);
    LineDashLine := OldLineDashLine;
    LineDashChanged := True;
    LineColorLine := OldLineColorLine;
    LineColorChanged := True;
  end;
  RunOnChanged;
end;

procedure TPDFPainter.DrawWideText(XPos, YPos: Double; const Text: WideString);
var
  TextW: Double;
  OldLineWidth: Double;
  OldLineColorLine: AnsiString;
  OldFillColorLine: AnsiString;
  OldLineDashLine: AnsiString;
  TextLine, ReplaceStr: AnsiString;
  KX: Integer;
  KernAdjust: Integer;
  C1: AnsiChar;
  C2: AnsiChar;
  RX: Integer;
  RText: WideString;
begin
  if ((FTextHighlight <> hsNone) or (FTextUnderline <> usNone) or
    (FTextAlign = paCenter) or (FTextAlign = paRight)) then
  begin
    TextW := WideTextWidth(Text) - FTextCharSpacing * (FTextScaling / 100);
  end else
  begin
    TextW := 0;
  end;

  case FTextAlign of
    paCenter: XPos := XPos - TextW / 2;
    paRight: XPos := XPos - TextW;
  end;

  if FTextHighlight <> hsNone then
  begin
    OldFillColorLine := FillColorLine;
    FillColorLine := HighlightColorLine;
    FillColorChanged := True;
    if FTextHighlight = hsSquare then
      Rectangle(XPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, True, False);
    if FTextHighlight = hsRounded then
      RoundedRectangle(XPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, TextHeight / 4, True, False);
    FillColorLine := OldFillColorLine;
    FillColorChanged := True;
    FontColorChanged := True;
  end;

  if TextModeChanged then Add(QPLIntToStr(TextMode) + ' Tr');
  if (TextMode = 1) or (TextMode = 2) or (TextMode = 5) or (TextMode = 6) then
  begin
    if LineColorChanged then Add(LineColorLine);
    if LineWidthChanged then Add(LineWidthLine);
    if LineDashChanged then Add(LineDashLine);
    LineColorChanged := False;
    LineWidthChanged := False;
    LineDashChanged := False;
  end;
  TextModeChanged := False;

  if FontChanged then Add(FontLine);
  if FontColorChanged then Add(FontColorLine);
  if FontScalingChanged then Add(FontScalingLine);
  if FontRiseChanged then Add(FontRiseLine);
  if FontSpacingChanged then Add(FontSpacingLine);

  RemoveEndText;

  Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos) + 'Tm');
  if (FSelFont.FontType <> ftCJK) and FUseKerning and (Text <> '') then
  begin
    Add('[');
    C1 := AnsiChar(Text[1]);
    TextLine := C1;
    for KX := 2 to Length(Text) do
    begin
      C2 := AnsiChar(Text[KX]);
      KernAdjust := FSelFont.GetKernAmount(WideChar(C1), WideChar(C2));
      if KernAdjust <> 0 then
      begin
        AddString(TextLine);
        AddFloat(KernAdjust);
        TextLine := C2;
      end else
        TextLine := TextLine + C2;
      C1 := C2;
    end;
    if TextLine <> '' then
      AddString(TextLine, '] TJ')
    else
      Add('] TJ');
  end else
  begin
    RText := Text;
    for RX := 1 to Length(Text) do
      if RText[RX] = #160 then
        RText[RX] := #32;

    if (FTextWordSpacing <> 0) then
    begin
      TextLine := FSelFont.GetCharacterCodes(RText);
      TextLine := EscapeString(TextLine);

      ReplaceStr :=  #0#32 + ')' + QPLIntToStr(-Trunc(FTextWordSpacing * 1000 / FTextSize)) + '(';
      TextLine := QPLStringReplace(TextLine, #0#32, ReplaceStr, [rfReplaceAll]);

      Add('[(' + TextLine + ')]TJ', #10);
    end
    else
      AddString(FSelFont.GetCharacterCodes(RText), 'Tj');
  end;
  Add('ET');

  FLastX := XPos + WideTextWidth(Text);
  FLastY := YPos;

  FontChanged := False;
  FontColorChanged := False;
  FontScalingChanged := False;
  FontRiseChanged := False;
  FontSpacingChanged := False;
  if FTextUnderline <> usNone then
  begin
    OldLineColorLine := LineColorLine;
    OldLineDashLine := LineDashLine;
    OldLineWidth := LineWidth;
    LineColorLine := UnderlineColorLine;
    SetLineWidth(FUnderlineWidth);
    LineColorChanged := True;
    if (UnderlineDashOn = 0) or (UnderlineDashOff = 0) then
    begin
      if LineDashLine <> '[] 0 d' then LineDashLine := '[] 0 d';
    end else
      SetLineDash(UnderlineDashOn * LineWidth, UnderlineDashOff * LineWidth);
    LineDashChanged := True;

    if (FTextUnderline = usSingle) or (FTextUnderline = usDouble) then
      DrawLine(XPos, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance,
        XPos + TextW, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance);
    if FTextUnderline = usDouble then
      DrawLine(XPos, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2,
        XPos + TextW, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2);
    if (FTextUnderline = usStrikeout) then
      DrawLine(XPos, YPos + FTextSize * 0.3 + FUnderlineDistance,
        XPos + TextW, YPos + FTextSize * 0.3 + FUnderlineDistance);
    if (FTextUnderline = usOver) then
      DrawLine(XPos, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance,
        XPos + TextW, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance);
    SetLineWidth(OldLineWidth);
    LineDashLine := OldLineDashLine;
    LineDashChanged := True;
    LineColorLine := OldLineColorLine;
    LineColorChanged := True;
  end;
  RunOnChanged;
end;

procedure TPDFPainter.DrawWideTextArc(XPos, YPos, Radius, Angle: Double;
  const Text: WideString; Options: Integer);
var
  X: Integer;
  C: WideString;
  W: Double;
  CA: Double;
  Circumference: Double;
  AP: Double;
  Alpha: Double;
  Beta: Double;
  X1, Y1: Double;
  X2, Y2: Double;
  ReverseFactor: Integer;
  MaxC: Integer;
  lTextAlignTemp: TPDFAlignment;
begin
  ReverseFactor := 1;
  if Options = 1 then
    ReverseFactor := -1;
  Circumference := 2 * PI * Radius;
  AP := Angle;
  W := WideTextWidth(Text);
  CA := 360 * W / Circumference * ReverseFactor;
  lTextAlignTemp := FTextAlign;
  if FTextAlign = paCenter then
  begin
    AP := Angle - (CA / 2);
    FTextAlign := paLeft;
  end;
  if FTextAlign = paRight then
  begin
    AP := Angle - CA;
    FTextAlign := paLeft;
  end;

  MaxC := Length(Text);

  for X := 1 to MaxC do
  begin
    C := Text[X];
    W := WideTextWidth(C);
    CA := 360 * W / Circumference * ReverseFactor;
    Alpha := DegToRad(90 - AP - CA / 2);
    X1 := Radius * Cos(Alpha);
    Y1 := Radius * Sin(Alpha);
    Beta := DegToRad(90 - AP - CA / 2 + 90);
    if Options = 1 then
      Beta := DegToRad(90 - AP - CA / 2 + 90 + 180);
    X2 := W * Cos(Beta) / 2;
    Y2 := W * Sin(Beta) / 2;
    if Options = 1 then
      DrawRotatedWideText(XPos + X1 + X2, YPos + Y1 + Y2, -AP - CA / 2 + 180, C)
    else
      DrawRotatedWideText(XPos + X1 + X2, YPos + Y1 + Y2, -AP - CA / 2, C);
    AP := AP + CA;
  end;
  FTextAlign := lTextAlignTemp;
end;

procedure TPDFPainter.DrawWrappedText(XPos, YPos, Width: Double; const Text, BreakString: AnsiString);
var
  List: TQuickPDFStringList;
  Line: Integer;
  TextW: Double;
  Extra: Double;
  LastLine: Boolean;
  WordCount: Integer;
  ThisLine: AnsiString;
  LineTw: Double;
  LineTc: Double;
  LastTw: Double;
  LastTc: Double;
  Flags: TPDFTextBlockFlags;
  L, X: Integer;
  YPosOrig: Double;
  LineXPos: Double;
  OldFillColorLine: AnsiString;
  OldLineColorLine: AnsiString;
  OldLineWidth: Double;
  OldLineDashLine: AnsiString;
  RX: Integer;
  RText: AnsiString;
begin
  YPosOrig := YPos;
  List := TQuickPDFStringList.Create;
  try
    WordWrap(Text, List, Width, BreakString, Flags);
    L := Length(Flags);
    if L < List.Count then
    begin
      SetLength(Flags, List.Count);
      for X := L to List.Count - 1 do
      begin
        Flags[X].WordCount := 0;
        Flags[X].ForcedBreak := False;
        Flags[X].WordBreak := False;
      end;
    end;

    if FTextHighlight <> hsNone then
    begin
      OldFillColorLine := FillColorLine;
      FillColorLine := HighlightColorLine;
      FillColorChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        if Length(List[Line]) > 0 then
        begin
          LastLine := Line = (List.Count - 1);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
          if (FTextAlign = paForceJustified) then
             TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
             TextW := Width
          else
            TextW := TextWidth(List[Line]) - FTextCharSpacing * (FTextScaling / 100);
          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos + Width - TextW;
          if FTextAlign = paCenter then
             LineXPos := XPos + (Width - TextW) / 2;
          if FTextHighlight = hsSquare then
            Rectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, True, False);
          if FTextHighlight = hsRounded then
            RoundedRectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, TextHeight / 4, True, False);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      FillColorLine := OldFillColorLine;
      FillColorChanged := True;
      FontColorChanged := True;
      YPos := YPosOrig;
    end;

    LineTw := FTextWordSpacing;
    LineTc := FTextCharSpacing;
    LastTw := LineTw;
    LastTc := LineTc;
    if TextModeChanged then Add(QPLIntToStr(TextMode) + ' Tr');
    if (TextMode = 1) or (TextMode = 2) or (TextMode = 5) or (TextMode = 6) then
    begin
      if LineColorChanged then Add(LineColorLine);
      if LineWidthChanged then Add(LineWidthLine);
      if LineDashChanged then Add(LineDashLine);
      LineColorChanged := False;
      LineWidthChanged := False;
      LineDashChanged := False;
    end;
    TextModeChanged := False;

    if FontChanged then Add(FontLine);
    if FontColorChanged then Add(FontColorLine);
    if FontScalingChanged then Add(FontScalingLine);
    if FontRiseChanged then Add(FontRiseLine);
    if FontSpacingChanged then Add(FontSpacingLine);

    RemoveEndText;

    if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
      (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
    begin
      Extra := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 1000;
      Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos + Extra + FTextSpacing) + 'Tm');
      Add(MakeFloat(Extra + FTextSpacing) + 'TL');
    end;
    for Line := 0 to List.Count - 1 do
    begin
      ThisLine := List[Line];
      LastLine := Line = (List.Count - 1);
      WordCount := Integer(List.Objects[Line]);
      LineTw := FTextWordSpacing;
      LineTc := FTextCharSpacing;
      if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
        (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
      begin
        if (FTextAlign = paJustified) then
        begin
          Extra := Width - TextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (not LastLine) and (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (not LastLine) and (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if (FTextAlign = paForceJustified) and (Width > 0) then
        begin
          Extra := Width - TextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if (FTextAlign = paLastJustified) and (Width > 0) then
        begin
          Extra := Width - TextWidth(ThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if LineTw <> LastTw then
        begin
          Add(MakeFloat(LineTw) + 'Tw');
          FontSpacingChanged := True;
        end;
        if LineTc <> LastTc then
        begin
          Add(MakeFloat(LineTc) + 'Tc');
          FontSpacingChanged := True;
        end;
        LastTw := LineTw;
        LastTc := LineTc;
        if FSelFont.FontType = ftCJK then
        begin
          RText := List[Line];
          for RX := 1 to Length(RText) div 2 do
            if QPLCopy(RText, RX * 2 - 1, 2) = #0#160 then
              RText[RX * 2] := #32;
          List[Line] := RText;
        end;
        AddString(List[Line], '''');
      end else
      begin
        TextW := TextWidth(List[Line]) - LineTc * (FTextScaling / 100);
        if FTextAlign = paRight then
          Add('1 0 0 1 ' + MakeFloat(XPos + Width - TextW) +
            MakeFloat(YPos) + 'Tm');

        if FTextAlign = paCenter then
          Add('1 0 0 1 ' + MakeFloat(XPos + (Width - TextW) / 2) +
            MakeFloat(YPos) + 'Tm');

        if FSelFont.FontType = ftCJK then
        begin
          RText := List[Line];
          for RX := 1 to Length(RText) div 2 do
            if QPLCopy(RText, RX * 2 - 1, 2) = #0#160 then
              RText[RX * 2] := #32;
          List[Line] := RText;
        end;
        AddString(List[Line], 'Tj');

        YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
          FTextSize / 1000 - FTextSpacing;
      end;
    end;
    Add('ET');
    FontChanged := False;
    FontColorChanged := False;
    FontScalingChanged := False;
    FontRiseChanged := False;
    FontSpacingChanged := (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified);
    YPos := YPosOrig;
    if FTextUnderline <> usNone then
    begin
      OldLineColorLine := LineColorLine;
      OldLineWidth := LineWidth;
      OldLineDashLine := LineDashLine;
      LineColorLine := UnderlineColorLine;
      SetLineWidth(FUnderlineWidth);
      LineColorChanged := True;
      if (UnderlineDashOn = 0) or (UnderlineDashOff = 0) then
      begin
        if LineDashLine <> '[] 0 d' then LineDashLine := '[] 0 d';
      end else
        SetLineDash(UnderlineDashOn * LineWidth, UnderlineDashOff * LineWidth);
      LineDashChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        if Length(List[Line]) > 0 then
        begin
          LastLine := Line = (List.Count - 1);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
           TextW := Width
          else           
          if (FTextAlign = paForceJustified) then
             TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
             TextW := Width
          else
           TextW := TextWidth(List[Line]) - FTextCharSpacing * (FTextScaling / 100);
          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos + Width - TextW;
          if FTextAlign = paCenter then
             LineXPos := XPos + (Width - TextW) / 2;
          if (FTextUnderline = usSingle) or (FTextUnderline = usDouble) then
            DrawLine(LineXPos, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance,
              LineXPos + TextW, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance);
          if FTextUnderline = usDouble then
            DrawLine(LineXPos, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2,
              LineXPos + TextW, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2);
          if (FTextUnderline = usStrikeout) then
            DrawLine(LineXPos, YPos + FTextSize * 0.3 + FUnderlineDistance,
              LineXPos + TextW, YPos + FTextSize * 0.3 + FUnderlineDistance);
          if (FTextUnderline = usOver) then
            DrawLine(LineXPos, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance,
              LineXPos + TextW, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      LineDashLine := OldLineDashLine;
      LineDashChanged := True;
      SetLineWidth(OldLineWidth);
      LineColorLine := OldLineColorLine;
      LineColorChanged := True;
    end;
  finally
    List.Free;
  end;

  RunOnChanged;
end;

procedure TPDFPainter.DrawWrappedWideText(XPos, YPos, Width: Double; const Text, BreakString: WideString);
var
  List: TQuickPDFStringList;
  Line: Integer;
  TextW: Double;
  Extra, ExtraTm, ExtraTL: Double;
  LastLine: Boolean;
  WordCount: Integer;
  ThisLine: AnsiString;
  WideThisLine: WideString;
  LineTw: Double;
  LineTc: Double;
  LastTw: Double;
  LastTc: Double;
  Flags: TPDFTextBlockFlags;
  L, X: Integer;
  YPosOrig: Double;
  LineXPos: Double;
  OldFillColorLine: AnsiString;
  OldLineColorLine: AnsiString;
  OldLineWidth: Double;
  OldLineDashLine: AnsiString;
  WideListLine: WideString;
begin
  YPosOrig := YPos;
  List := TQuickPDFStringList.Create;
  try
    WideWordWrap(Text, List, Width, BreakString, Flags);
    L := Length(Flags);
    if L < List.Count then
    begin
      SetLength(Flags, List.Count);
      for X := L to List.Count - 1 do
      begin
        Flags[X].WordCount := 0;
        Flags[X].ForcedBreak := False;
        Flags[X].WordBreak := False;
      end;
    end;

    if FTextHighlight <> hsNone then
    begin
      OldFillColorLine := FillColorLine;
      FillColorLine := HighlightColorLine;
      FillColorChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        WideListLine := QPLUTF8Decode(List[Line]);
        if (Length(WideListLine) > 0) then
        begin
          LastLine := Line = (List.Count - 1);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
            TextW := Width
          else
          if (FTextAlign = paForceJustified) then
             TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
             TextW := Width
          else
            TextW := WideTextWidth(WideListLine) - FTextCharSpacing * (FTextScaling / 100);
          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos + Width - TextW;
          if FTextAlign = paCenter then
             LineXPos := XPos + (Width - TextW) / 2;
          if FTextHighlight = hsSquare then
            Rectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, True, False);
          if FTextHighlight = hsRounded then
            RoundedRectangle(LineXPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, TextHeight / 4, True, False);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      FillColorLine := OldFillColorLine;
      FillColorChanged := True;
      FontColorChanged := True;
      YPos := YPosOrig;
    end;

    LineTw := FTextWordSpacing;
    LineTc := FTextCharSpacing;
    LastTw := LineTw;
    LastTc := LineTc;
    if TextModeChanged then Add(QPLIntToStr(TextMode) + ' Tr');
    if (TextMode = 1) or (TextMode = 2) or (TextMode = 5) or (TextMode = 6) then
    begin
      if LineColorChanged then Add(LineColorLine);
      if LineWidthChanged then Add(LineWidthLine);
      if LineDashChanged then Add(LineDashLine);
      LineColorChanged := False;
      LineWidthChanged := False;
      LineDashChanged := False;
    end;
    TextModeChanged := False;

    if FontChanged then Add(FontLine);
    if FontColorChanged then Add(FontColorLine);
    if FontScalingChanged then Add(FontScalingLine);
    if FontRiseChanged then Add(FontRiseLine);
    if FontSpacingChanged then Add(FontSpacingLine);

    RemoveEndText;

    if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
      (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
    begin
      Extra := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 1000;
      ExtraTm := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 1280;
      ExtraTL := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 1000;
      Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos + ExtraTm + FTextSpacing) + 'Tm');
      Add(MakeFloat(ExtraTL + FTextSpacing) + 'TL');
    end;
    for Line := 0 to List.Count - 1 do
    begin
      WideThisLine := QPLUTF8Decode(List[Line]);
      LastLine := Line = (List.Count - 1);
      WordCount := Integer(List.Objects[Line]);
      LineTw := FTextWordSpacing;
      LineTc := FTextCharSpacing;
      if (FTextAlign = paLeft) or (FTextAlign = paJustified) or
        (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified) then
      begin
        if (FTextAlign = paJustified) then
        begin
          Extra := Width - WideTextWidth(WideThisLine) + LineTc * (FTextScaling / 100);

          if (not LastLine) and (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (not LastLine) and (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(ThisLine) > 1) then
            LineTc := (Extra / (Length(ThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if (FTextAlign = paForceJustified) and (Width > 0) then
        begin
          Extra := Width - WideTextWidth(WideThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (Length(WideThisLine) > 1) then
            LineTc := (Extra / (Length(WideThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if (FTextAlign = paLastJustified) and (Width > 0) then
        begin
          Extra := Width - WideTextWidth(WideThisLine) + LineTc * (FTextScaling / 100);

          if (WordCount > 1) and (not Flags[Line].ForcedBreak) then
            LineTw := (Extra / (WordCount - 1)) / (FTextScaling / 100) + LineTw;

          if (WordCount = 1) and (not Flags[Line].ForcedBreak) and (Length(WideThisLine) > 1) then
            LineTc := (Extra / (Length(WideThisLine) - 1)) / (FTextScaling / 100) + LineTc;
        end;
        if LineTw <> LastTw then
        begin
          Add(MakeFloat(LineTw) + 'Tw');
          FontSpacingChanged := True;
        end;
        if LineTc <> LastTc then
        begin
          Add(MakeFloat(LineTc) + 'Tc');
          FontSpacingChanged := True;
        end;
        LastTw := LineTw;
        LastTc := LineTc;
        AddString(FSelFont.GetCharacterCodes(WideThisLine), '''');
      end else
      begin
        TextW := WideTextWidth(WideThisLine) - LineTc * (FTextScaling / 100);
        ExtraTm := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 4624;
        if FTextAlign = paRight then
          Add('1 0 0 1 ' + MakeFloat(XPos + Width - TextW) +
            MakeFloat(YPos - ExtraTm) + 'Tm');

        if FTextAlign = paCenter then
          Add('1 0 0 1 ' + MakeFloat(XPos + (Width - TextW) / 2) +
            MakeFloat(YPos - ExtraTm) + 'Tm');

        AddString(FSelFont.GetCharacterCodes(WideThisLine), 'Tj');

        YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
          FTextSize / 1000 - FTextSpacing;
      end;
    end;
    Add('ET');
    FontChanged := False;
    FontColorChanged := False;
    FontScalingChanged := False;
    FontRiseChanged := False;
    FontSpacingChanged := (FTextAlign = paForceJustified) or (FTextAlign = paLastJustified);
    YPos := YPosOrig;
    if FTextUnderline <> usNone then
    begin
      OldLineColorLine := LineColorLine;
      OldLineWidth := LineWidth;
      OldLineDashLine := LineDashLine;
      LineColorLine := UnderlineColorLine;
      SetLineWidth(FUnderlineWidth);
      LineColorChanged := True;
      if (UnderlineDashOn = 0) or (UnderlineDashOff = 0) then
      begin
        if LineDashLine <> '[] 0 d' then LineDashLine := '[] 0 d';
      end else
        SetLineDash(UnderlineDashOn * LineWidth, UnderlineDashOff * LineWidth);
      LineDashChanged := True;

      for Line := 0 to List.Count - 1 do
      begin
        if Length(List[Line]) > 0 then
        begin
          LastLine := Line = (List.Count - 1);
          if (FTextAlign = paJustified) and (not LastLine) and (not Flags[Line].ForcedBreak) then
           TextW := Width
          else
          if (FTextAlign = paForceJustified) then
             TextW := Width
          else
          if (FTextAlign = paLastJustified) and (not Flags[Line].ForcedBreak) then
             TextW := Width
          else
           TextW := TextWidth(List[Line]) - FTextCharSpacing * (FTextScaling / 100);
          LineXPos := XPos;
          if FTextAlign = paRight then
            LineXPos := XPos + Width - TextW;
          if FTextAlign = paCenter then
             LineXPos := XPos + (Width - TextW) / 2;
          if (FTextUnderline = usSingle) or (FTextUnderline = usDouble) then
            DrawLine(LineXPos, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance,
              LineXPos + TextW, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance);
          if FTextUnderline = usDouble then
            DrawLine(LineXPos, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2,
              LineXPos + TextW, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2);
          if (FTextUnderline = usStrikeout) then
            DrawLine(LineXPos, YPos + FTextSize * 0.3 + FUnderlineDistance,
              LineXPos + TextW, YPos + FTextSize * 0.3 + FUnderlineDistance);
          if (FTextUnderline = usOver) then
            DrawLine(LineXPos, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance,
              LineXPos + TextW, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance);
          YPos := YPos - (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
            FTextSize / 1000 - FTextSpacing;
        end;
      end;
      LineDashLine := OldLineDashLine;
      LineDashChanged := True;
      SetLineWidth(OldLineWidth);
      LineColorLine := OldLineColorLine;
      LineColorChanged := True;
    end;
  finally
    List.Free;
  end;

  RunOnChanged;
end;

function TPDFPainter.GetSource: AnsiString;
begin
  FSourceStream.Seek(0, soFromBeginning);
  SetLength(Result, FSourceStream.Size);
  if FSourceStream.Size > 0 then
  begin
    FSourceStream.Read(Result[1], Length(Result));
  end;
  if QPLCopy(Result, Length(Result), 1) <> #10 then
  begin
    Result := Result + #10;
  end;
end;

function TPDFPainter.GetWrappedText(Width: Double;
  const Text, Delimiter, BreakString: AnsiString): AnsiString;
var
  DummyFlags: TPDFTextBlockFlags;
begin
  Result := GetWrappedText(Width, Text, Delimiter, BreakString, DummyFlags);
end;

function TPDFPainter.GetWrappedText(Width: Double;
  const Text, Delimiter, BreakString: AnsiString; var Flags: TPDFTextBlockFlags): AnsiString;
var
  List: TQuickPDFStringList;
  Line: Integer;
  ADel: AnsiString;
  X: Integer;
begin
  Result := '';
  List := TQuickPDFStringList.Create;
  try
    WordWrap(Text, List, Width, BreakString, Flags);
    if FSelFont.FontType = ftCJK then
    begin
      ADel := '';
      for X := 1 to Length(Delimiter) do
        ADel := ADel + #0 + Delimiter[X];
      for Line := 0 to List.Count - 1 do
        Result := Result + List[Line] + ADel;
    end else
    begin
      for Line := 0 to List.Count - 1 do
        Result := Result + List[Line] + Delimiter;
    end;
  finally
    List.Free;
  end;
end;

function TPDFPainter.GetWrappedWideText(Width: Double;
  const Text, Delimiter, BreakString: WideString): WideString;
var
  DummyFlags: TPDFTextBlockFlags;
begin
  Result := GetWrappedWideText(Width, Text, Delimiter, BreakString, DummyFlags);
end;

function TPDFPainter.GetWrappedWideText(Width: Double;
  const Text, Delimiter, BreakString: WideString;
  var Flags: TPDFTextBlockFlags): WideString;
var
  List: TQuickPDFStringList;
  Line: Integer;
begin
  Result := '';
  List := TQuickPDFStringList.Create;
  try
    WideWordWrap(Text, List, Width, BreakString, Flags);
    for Line := 0 to List.Count - 1 do
      Result := Result + QPLUTF8Decode(List[Line]) + Delimiter;
  finally
    List.Free;
  end;
end;

function TPDFPainter.GetWrappedTextHeight(Width: Double;
  const Text, BreakString: AnsiString): Double;
var
  DummyFlags: TPDFTextBlockFlags;
begin
  Result:= GetWrappedTextHeight(Width, Text, BreakString, DummyFlags);
end;

function TPDFPainter.GetWrappedTextHeight(Width: Double;
  const Text, BreakString: AnsiString; var Flags: TPDFTextBlockFlags): Double;
var
  List: TQuickPDFStringList;
begin
  List := TQuickPDFStringList.Create;
  try
    WordWrap(Text, List, Width, BreakString, Flags);
    Result := List.Count * (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
      FTextSize / 1000 + (List.Count - 1) * FTextSpacing;
  finally
    List.Free;
  end;
end;

function TPDFPainter.GetWrappedWideTextHeight(Width: Double;
  const Text, BreakString: WideString): Double;
var
  DummyFlags: TPDFTextBlockFlags;
begin
  Result := GetWrappedWideTextHeight(Width, Text, BreakString, DummyFlags);
end;

function TPDFPainter.GetWrappedWideTextHeight(Width: Double;
  const Text, BreakString: WideString; var Flags: TPDFTextBlockFlags): Double;
var
  List: TQuickPDFStringList;
begin
  List := TQuickPDFStringList.Create;
  try
    WideWordWrap(Text, List, Width, BreakString, Flags);
    Result := List.Count * (FSelFont.Bound.Top - FSelFont.Bound.Bottom) *
      FTextSize / 1000 + (List.Count - 1) * FTextSpacing;
  finally
    List.Free;
  end;
end;

function TPDFPainter.GetWrappedTextLineCount(Width: Double;
  const Text, BreakString: AnsiString): Integer;
var
  List: TQuickPDFStringList;
begin
  List := TQuickPDFStringList.Create;
  try
    WordWrap(Text, List, Width, BreakString);
    Result := List.Count;
  finally
    List.Free;
  end;
end;

function TPDFPainter.GetWrappedWideTextLineCount(Width: Double;
  const Text, BreakString: WideString): Integer;
var
  List: TQuickPDFStringList;
begin
  List := TQuickPDFStringList.Create;
  try
    WideWordWrap(Text, List, Width, BreakString);
    Result := List.Count;
  finally
    List.Free;
  end;
end;

function TPDFPainter.MakeFloat(D: Double): AnsiString;
begin
  Result := QPLDoubleToStr(D, PDFPrecNum) + ' ';
end;

procedure TPDFPainter.Rectangle(Left, Top, Width, Height: Double; Fill, Outline: Boolean);
begin
  if LineColorChanged then
    Add(LineColorLine);
  if FillColorChanged then
    Add(FillColorLine);
  if LineWidthChanged then
    Add(LineWidthLine);
  if LineDashChanged then
    Add(LineDashLine);
  AddFloat(Left);
  AddFloat(Top - Height);
  AddFloat(Width);
  AddFloat(Height);
  Add('re');
  if Fill and (not Outline) then Add('f');
  if Outline and (not Fill) then Add('S');
  if Outline and Fill then Add('B');
  if (not Fill) and (not Outline) then Add('n');
  RunOnChanged;
  LineColorChanged := False;
  LineWidthChanged := False;
  LineDashChanged := False;
  FillColorChanged := False;
  FontColorChanged := True;
end;

procedure TPDFPainter.Scale(Scale: Double);
begin
  AddFloat(Scale);
  AddFloat(0);
  AddFloat(0);
  AddFloat(Scale);
  AddFloat(0);
  AddFloat(0);
  Add('cm');
  RunOnChanged;
end;

procedure TPDFPainter.SelectFont(Font: TPDFFont; Size: Double);
begin
  if Size <= 0 then Size := 1;
  if (Font = nil) then Exit;
  
  FSelFont := Font;
  FTextSize := Size;
  FUnderlineWidth := FTextSize * 6.25 / 100;
  FUnderlineDistance := 0;
  FontLine := '/' + Font.Name + ' ' + MakeFloat(Size) + 'Tf';
  FontChanged := True;
  FontColorChanged := True;
  FillColorChanged := True;
end;

procedure TPDFPainter.SetFillColor(Red, Green, Blue: Double);
begin
  if Red > 1 then Red := 1;
  if Red < 0 then Red := 0;
  if Green > 1 then Green := 1;
  if Green < 0 then Green := 0;
  if Blue > 1 then Blue := 1;
  if Blue < 0 then Blue := 0;
  FillColorLine := MakeFloat(Red) + MakeFloat(Green) + MakeFloat(Blue) + 'rg';
  FillColorChanged := True;
  FontColorChanged := True;
end;

procedure TPDFPainter.SetLineColor(Red, Green, Blue: Double);
begin
  if Red > 1 then Red := 1;
  if Red < 0 then Red := 0;
  if Green > 1 then Green := 1;
  if Green < 0 then Green := 0;
  if Blue > 1 then Blue := 1;
  if Blue < 0 then Blue := 0;
  LineColorLine := MakeFloat(Red) + MakeFloat(Green) + MakeFloat(Blue) + 'RG';
  LineColorChanged := True;
end;

procedure TPDFPainter.SetLineColor(C, M, Y, K: Double);
begin
  if C > 1 then C := 1;
  if C < 0 then C := 0;
  if M > 1 then M := 1;
  if M < 0 then M := 0;
  if Y > 1 then Y := 1;
  if Y < 0 then Y := 0;
  if K > 1 then K := 1;
  if K < 0 then K := 0;
  LineColorLine := MakeFloat(C) + MakeFloat(M) + MakeFloat(Y) + MakeFloat(K) + 'K';
  LineColorChanged := True;
end;

procedure TPDFPainter.SetLineWidth(Width: Double);
begin
  LineWidth := Abs(Width);
  LineWidthLine := MakeFloat(MiterLimit) + 'M ' +
    MakeFloat(LineWidth) + 'w ' + QPLIntToStr(LineCap) + ' J ' +
    QPLIntToStr(LineJoin) + ' j';
  LineWidthChanged := True;
end;

procedure TPDFPainter.SetSource(const S: AnsiString);
begin
  FSourceStream.Clear;
  if Length(S) > 0 then
  begin
    FSourceStream.Write(S[1], Length(S));
    if QPLCopy(S, Length(S), 1) <> ' ' then Add(' ', #0);
  end;
end;

procedure TPDFPainter.SetTextColor(Red, Green, Blue: Double);
begin
  if Red > 1 then Red := 1;
  if Red < 0 then Red := 0;
  if Green > 1 then Green := 1;
  if Green < 0 then Green := 0;
  if Blue > 1 then Blue := 1;
  if Blue < 0 then Blue := 0;
  HexColorLine := '#' + QPLIntToHex(Round(Red * 255), 2) +
    QPLIntToHex(Round(Green * 255), 2) + QPLIntToHex(Round(Blue * 255), 2);
  FontColorLine := MakeFloat(Red) + MakeFloat(Green) + MakeFloat(Blue) + 'rg';
  UnderlineColorLine := MakeFloat(Red) + MakeFloat(Green) + MakeFloat(Blue) + 'RG';
  FontColorChanged := True;
  FillColorChanged := True;
end;

procedure TPDFPainter.SetTextColor(C, M, Y, K: Double);
begin
  if C > 1 then C := 1;
  if C < 0 then C := 0;
  if M > 1 then M := 1;
  if M < 0 then M := 0;
  if Y > 1 then Y := 1;
  if Y < 0 then Y := 0;
  if K > 1 then K := 1;
  if K < 0 then K := 0;
  FontColorLine := MakeFloat(C) + MakeFloat(M) + MakeFloat(Y) + MakeFloat(K) + 'k';
  UnderlineColorLine := MakeFloat(C) + MakeFloat(M) + MakeFloat(Y) + MakeFloat(K) + 'K';
  FontColorChanged := True;
  FillColorChanged := True;
end;

procedure TPDFPainter.SetTextMode(Mode: Integer);
begin
  if (Mode < 0) or (Mode > 7) then Mode := 0;
  TextMode := Mode;
  TextModeChanged := True;
end;

procedure TPDFPainter.SetTextSpacing(Spacing: Double);
begin
  FTextSpacing := Spacing;
end;

procedure TPDFPainter.StartPath(StartX, StartY: Double);
begin
  LastX := StartX;
  LastY := StartY;
  Path.Clear;
  RipePath := True;
  Path.Add(MakeFloat(StartX) + MakeFloat(StartY) + 'm');
end;

function TPDFPainter.TextWidth(const Text: AnsiString): Double;
var
  W: Integer;
  X: Integer;
  WordW: Double;
  CharW: Double;
  TempW: Integer;
  TempC: Integer;
begin
  W := 0;
  WordW := 0;
  CharW := 0;
  if Assigned(FSelFont) then
  begin
    if FSelFont.FontType = ftCJK then
    begin
      for X := 1 to Length(Text) div 2 do
      begin
        TempC := Ord(Text[X * 2 - 1]) * 256 + Ord(Text[X * 2]);
        TempW := FSelFont.CharWidth(TempC);
        Inc(W, TempW);
      end;
      if FTextCharSpacing <> 0 then
        CharW := (Length(Text) div 2) * FTextCharSpacing;
      if FTextWordSpacing <> 0 then
        WordW := CountAnsiWideSpaces(Text) * FTextWordSpacing;
    end else
    begin
      for X := 1 to Length(Text) do
        Inc(W, FSelFont.CharWidth(Ord(Text[X])));
      if FTextCharSpacing <> 0 then
        CharW := Length(Text) * FTextCharSpacing;
      if FTextWordSpacing <> 0 then
        WordW := CountAnsiWideSpaces(Text) * FTextWordSpacing;
    end;
    Result := (W * FTextSize / 1000 + CharW + WordW) * FTextScaling / 100;
  end else
    Result := 0;
end;

function TPDFPainter.WideTextWidth(const Text: WideString): Double;
var
  W: Integer;
  X: Integer;
  WordW: Double;
  CharW: Double;
begin
  W := 0;
  WordW := 0;
  CharW := 0;
  if Assigned(FSelFont) then
  begin
    for X := 1 to Length(Text) do
    begin
      Inc(W, FSelFont.CharWidth(Ord(Text[X])));
    end;
    if FTextCharSpacing <> 0 then
      CharW := Length(Text) * FTextCharSpacing;
    if FTextWordSpacing <> 0 then
      WordW := (CountWideWords(Text) - 1) * FTextWordSpacing;
    Result := (W * FTextSize / 1000 + CharW + WordW) * FTextScaling / 100;
  end else
    Result := 0;
end;

procedure TPDFPainter.WordWrap(Text: AnsiString; List: TQuickPDFStringList;
  Width: Double; const BreakString: AnsiString);
var
  DummyFlags: TPDFTextBlockFlags;
begin
  WordWrap(Text, List, Width, BreakString, DummyFlags);
end;

procedure TPDFPainter.WordWrap(Text: AnsiString; List: TQuickPDFStringList;
  Width: Double; const BreakString: AnsiString; var Flags: TPDFTextBlockFlags);
var
  ThisLine: AnsiString;
  TestLine: AnsiString;
  NextWord: AnsiString;
  LineWidth: Double;
  WordCount: Integer;
  ABreakString: AnsiString;
  SCW: Integer;
  GapText: AnsiString;

  function PopWord: AnsiString;
  var
    P: Integer;
    SpacePos: Integer;
    BreakPos: Integer;
  begin
    if (QPLCopy(Text, 1, Length(BreakString)) = BreakString) and (Length(BreakString) > 0) then
    begin
      Result := BreakString;
      Delete(Text, 1, Length(BreakString));
    end else
    begin
      while QPLCopy(Text, 1, 1) = ' ' do
      begin
        Delete(Text, 1, 1);
        GapText := GapText + ' ';
      end;
      SpacePos := QPLPos(' ', Text);
      if Length(BreakString) > 0 then
        BreakPos := QPLPos(BreakString,Text)
      else
        BreakPos := 0;
      P := -1;
      if SpacePos = 0 then P := BreakPos;
      if BreakPos = 0 then P := SpacePos;
      if (SpacePos > 0) and (BreakPos > 0) then
      begin
        if SpacePos < BreakPos then P := SpacePos else P := BreakPos;
      end;
      if P <= 0 then P := Length(Text) + 1;
      Result := QPLCopy(Text, 1, P - 1);
      Delete(Text, 1, Length(Result));
    end;
  end;

  function PopWideWord: AnsiString;
  var
    P: Integer;
    SpacePos: Integer;
    BreakPos: Integer;
  begin
    if (QPLCopy(Text, 1, Length(ABreakString)) = ABreakString) and (Length(ABreakString) > 0) then
    begin
      Result := ABreakString;
      Delete(Text, 1, Length(ABreakString));
    end else
    begin
      GapText := '';
      while QPLCopy(Text, 1, 2) = #0' ' do
      begin
        Delete(Text, 1, 2);
        GapText := GapText + #0' ';
      end;
      SpacePos := QPLPos(#0' ', Text);
      if Length(ABreakString) > 0 then
        BreakPos := QPLPos(ABreakString, Text)
      else
        BreakPos := 0;
      P := -1;
      if SpacePos = 0 then P := BreakPos;
      if BreakPos = 0 then P := SpacePos;
      if (SpacePos > 0) and (BreakPos > 0) then
      begin
        if SpacePos < BreakPos then P := SpacePos else P := BreakPos;
      end;
      if P <= 0 then P := Length(Text) + 1;
      Result := QPLCopy(Text, 1, P - 1);
      Delete(Text, 1, Length(Result));
    end;
  end;

begin
  if FSelFont.FontType = ftCJK then
  begin
    SCW := 2;
    ABreakString := '';
    for WordCount := 1 to Length(BreakString) do
      ABreakString := ABreakString + #0 + BreakString[WordCount];
  end else
  begin
    SCW := 1;
    ABreakString := BreakString;
  end;
  SetLength(Flags, 0);
  List.Clear;
  ThisLine := '';
  while Length(Text) > 0 do
  begin
    TestLine := ThisLine;
    if FSelFont.FontType = ftCJK then
      NextWord := PopWideWord
    else
      NextWord := PopWord;
    if NextWord = ABreakString then
    begin
      WordCount := CountWords(ThisLine);
      List.AddObject(ThisLine, TObject(WordCount));
      SetLength(Flags, Length(Flags) + 1);
      Flags[Length(Flags) - 1].WordCount := WordCount;
      Flags[Length(Flags) - 1].ForcedBreak := True;
      Flags[Length(Flags) - 1].WordBreak := False;
      ThisLine := '';
    end else
    begin
      if TestLine <> '' then
      begin
        TestLine := TestLine + GapText;
      end;
      TestLine := TestLine + NextWord;
      LineWidth := TextWidth(TestLine) - FTextCharSpacing * (FTextScaling / 100);
      if (Length(TestLine) > 1) and (LineWidth > Width) then
      begin
        if ThisLine = '' then
        begin
          repeat
            if FSelFont.FontType = ftCJK then
            begin
              Text := QPLCopy(NextWord, Length(NextWord) - 1, 2) + Text;            
              Delete(NextWord, Length(NextWord) - 1, 2);
            end else
            begin
              Text := QPLCopy(NextWord, Length(NextWord), 1) + Text;            
              Delete(NextWord, Length(NextWord), 1);
            end;
          until ((TextWidth(NextWord) - FTextCharSpacing * (FTextScaling / 100)) <= Width) or (Length(NextWord) = SCW);
          WordCount := CountWords(NextWord);
          List.AddObject(NextWord, TObject(WordCount));
          SetLength(Flags, Length(Flags) + 1);
          Flags[Length(Flags) - 1].WordCount := WordCount;
          Flags[Length(Flags) - 1].ForcedBreak := False;
          Flags[Length(Flags) - 1].WordBreak := True;
          ThisLine := '';
        end else
        begin
          WordCount := CountWords(ThisLine);
          List.AddObject(ThisLine, TObject(WordCount));
          SetLength(Flags, Length(Flags) + 1);
          Flags[Length(Flags) - 1].WordCount := WordCount;
          Flags[Length(Flags) - 1].ForcedBreak := False;
          Flags[Length(Flags) - 1].WordBreak := False;
          Text := NextWord + Text;
          ThisLine := '';
        end;
      end else
        ThisLine := TestLine;
    end;
  end;
  if ThisLine <> '' then
  begin
    WordCount := CountWords(ThisLine);
    List.AddObject(ThisLine, TObject(WordCount));
    SetLength(Flags, Length(Flags) + 1);
    Flags[Length(Flags) - 1].WordCount := WordCount;
    Flags[Length(Flags) - 1].ForcedBreak := False;
    Flags[Length(Flags) - 1].WordBreak := False;
  end;
end;

procedure TPDFPainter.WideWordWrap(Text: WideString; List: TQuickPDFStringList;
  Width: Double; const BreakString: WideString);
var
  DummyFlags: TPDFTextBlockFlags;
begin
  WideWordWrap(Text, List, Width, BreakString, DummyFlags);
end;

procedure TPDFPainter.WideWordWrap(Text: WideString; List: TQuickPDFStringList;
  Width: Double; const BreakString: WideString; var Flags: TPDFTextBlockFlags);
var
  ThisLine: WideString;
  TestLine: WideString;
  NextWord: WideString;
  LineWidth: Double;
  WordCount: Integer;
  ABreakString: WideString;
  SCW: Integer;
  GapText: WideString;

  function PopWord: WideString;
  var
    P: Integer;
    SpacePos: Integer;
    BreakPos: Integer;
  begin
    if (Copy(Text, 1, Length(BreakString)) = BreakString) and (Length(BreakString) > 0) then
    begin
      Result := BreakString;
      Delete(Text, 1, Length(BreakString));
    end else
    begin
      while Copy(Text, 1, 1) = ' ' do
      begin
        Delete(Text, 1, 1);
        GapText := GapText + ' ';
      end;

      SpacePos := Pos(' ', Text);
      if (Pos(';', Text) > 1) then
      begin
        SpacePos := Min(SpacePos, Pos(';', Text) + 1);
      end;

      if Length(BreakString) > 0 then
        BreakPos := Pos(BreakString,Text)
      else
        BreakPos := 0;
      P := -1;
      if SpacePos = 0 then P := BreakPos;
      if BreakPos = 0 then P := SpacePos;
      if (SpacePos > 0) and (BreakPos > 0) then
      begin
        if SpacePos < BreakPos then P := SpacePos else P := BreakPos;
      end;
      if P <= 0 then P := Length(Text) + 1;
      Result := Copy(Text, 1, P - 1);
      Delete(Text, 1, Length(Result));
    end;
  end;

begin
  SCW := 1;
  ABreakString := BreakString;

  SetLength(Flags, 0);
  List.Clear;
  ThisLine := '';
  while Length(Text) > 0 do
  begin
    TestLine := ThisLine;
    NextWord := PopWord;
    if NextWord = ABreakString then
    begin
      WordCount := CountWideWords(ThisLine);
      List.AddObject(QPLUTF8Encode(ThisLine), TObject(WordCount));
      SetLength(Flags, Length(Flags) + 1);
      Flags[Length(Flags) - 1].WordCount := WordCount;
      Flags[Length(Flags) - 1].ForcedBreak := True;
      Flags[Length(Flags) - 1].WordBreak := False;
      ThisLine := '';
    end else
    begin
      if TestLine <> '' then
      begin
        TestLine := TestLine + GapText;
      end;
      TestLine := TestLine + NextWord;
      LineWidth := WideTextWidth(TestLine) - FTextCharSpacing * (FTextScaling / 100);
      if (Length(TestLine) > 1) and (LineWidth > Width) then
      begin
        if ThisLine = '' then
        begin
          repeat
            Text := Copy(NextWord, Length(NextWord), 1) + Text;
            Delete(NextWord, Length(NextWord), 1);
          until ((WideTextWidth(NextWord) - FTextCharSpacing * (FTextScaling / 100)) <= Width) or (Length(NextWord) = SCW);
          WordCount := CountWideWords(NextWord);
          List.AddObject(QPLUTF8Encode(NextWord), TObject(WordCount));
          SetLength(Flags, Length(Flags) + 1);
          Flags[Length(Flags) - 1].WordCount := WordCount;
          Flags[Length(Flags) - 1].ForcedBreak := False;
          Flags[Length(Flags) - 1].WordBreak := True;
          ThisLine := '';
        end else
        begin
          WordCount := CountWideWords(ThisLine);
          List.AddObject(QPLUTF8Encode(ThisLine), TObject(WordCount));
          SetLength(Flags, Length(Flags) + 1);
          Flags[Length(Flags) - 1].WordCount := WordCount;
          Flags[Length(Flags) - 1].ForcedBreak := False;
          Flags[Length(Flags) - 1].WordBreak := False;
          Text := NextWord + Text;
          ThisLine := '';
        end;
      end else
        ThisLine := TestLine;
      GapText := '';
    end;
  end;
  if ThisLine <> '' then
  begin
    WordCount := CountWideWords(ThisLine);
    List.AddObject(QPLUTF8Encode(ThisLine), TObject(WordCount));
    SetLength(Flags, Length(Flags) + 1);
    Flags[Length(Flags) - 1].WordCount := WordCount;
    Flags[Length(Flags) - 1].ForcedBreak := False;
    Flags[Length(Flags) - 1].WordBreak := False;
  end;
end;

procedure TPDFPainter.SetFillColor(C, M, Y, K: Double);
begin
  if C > 1 then C := 1;
  if C < 0 then C := 0;
  if M > 1 then M := 1;
  if M < 0 then M := 0;
  if Y > 1 then Y := 1;
  if Y < 0 then Y := 0;
  if K > 1 then K := 1;
  if K < 0 then K := 0;
  FillColorLine := MakeFloat(C) + MakeFloat(M) + MakeFloat(Y) + MakeFloat(K) + 'k';
  FillColorChanged := True;
  FontColorChanged := True;
end;

function TPDFPainter.TextAscent: Double;
begin
  Result := 0;
  if Assigned(FSelFont) then
    Result := FSelFont.Ascent * FTextSize / 1000;
end;

function TPDFPainter.TextAscentTM: Double;
begin
  Result := 0;
  if Assigned(FSelFont) then
    Result := FSelFont.AscentTM * FTextSize / 1000;
end;

function TPDFPainter.GetTextMetrics(MetricType: Integer): Integer;
begin

  Result := 0;
  if Assigned(FSelFont) then
  begin
    if MetricType = 1 then
      Result := trunc(FSelFont.Ascent);
    if MetricType = 2 then
      Result := trunc(FSelFont.Descent);
    if MetricType = 3 then
      Result := trunc(FSelFont.InternalLeading);
    if MetricType = 4 then
      Result := trunc(FSelFont.ExternalLeading);
    if MetricType = 5 then
      Result := trunc(FSelFont.Ascent + Abs(FSelFont.Descent) - FSelFont.InternalLeading);
    if MetricType = 6 then
       Result := FSelFont.AveCharWidth;
  end;
end;

function TPDFPainter.TextDescent: Double;
begin
  Result := 0;
  if Assigned(FSelFont) then
    Result := FSelFont.Descent * FTextSize / 1000;
end;

function TPDFPainter.TextDescentTM: Double;
begin
  Result := 0;
  if Assigned(FSelFont) then
    Result := FSelFont.DescentTM * FTextSize / 1000;
end;

function TPDFPainter.TextHeight: Double;
begin
  Result := (FSelFont.Bound.Top - FSelFont.Bound.Bottom) * FTextSize / 1000;
end;

function TPDFPainter.TextBound(Edge: Integer): Double;
begin
  Result := 0;
  if Assigned(FSelFont) then
  case Edge of
    1: Result := FSelFont.Bound.Left * FTextSize / 1000;
    2: Result := FSelFont.Bound.Top * FTextSize / 1000;
    3: Result := FSelFont.Bound.Right * FTextSize / 1000;
    4: Result := FSelFont.Bound.Bottom * FTextSize / 1000;
  end;
end;

procedure TPDFPainter.LoadState;
begin
  Add('Q');
  ChangeAll;
  RunOnChanged;
end;

procedure TPDFPainter.SaveState;
begin
  Add('q');
  RunOnChanged;
end;

procedure TPDFPainter.SetClippingPath;
var
  PathLine: Integer;
begin
  if RipePath then
  begin
    for PathLine := 0 to Path.Count - 1 do
      Add(Path[PathLine]);
    Add('W n');
    Path.Clear;
    RunOnChanged;
    RipePath := False;
  end;
end;

procedure TPDFPainter.SetLineDash(DashOn, DashOff: Double);
begin
  if (DashOn < 0.1) or (DashOff < 0.1) then
    LineDashLine := '[] 0 d'
  else
    LineDashLine := '[ ' + MakeFloat(DashOn) + MakeFloat(DashOff) + '] 0 d';

  if (UnderlineCustomDash <> '') then
  begin
    LineDashLine := UnderlineCustomDash;
  end;

  LineDashChanged := True;
end;

procedure TPDFPainter.RoundedRectangle(Left, Top, Width, Height,
  Radius: Double; Fill, Outline: Boolean);
var
  Kappa: Double;
  XPos: Double;
  YPos: Double;
begin
  Kappa := (Sqrt(2) - 1) / 3 * 4;
  Add(LineColorLine);
  Add(FillColorLine);
  Add(LineWidthLine);
  if LineDashChanged then
    Add(LineDashLine);

  XPos := Left + Radius;
  YPos := Top - Height + Radius;
  AddFloat(XPos - Radius);
  AddFloat(YPos);
  Add('m');
  AddFloat(XPos - Radius);
  AddFloat(YPos - Radius * Kappa);
  AddFloat(XPos - Radius * Kappa);
  AddFloat(YPos - Radius);
  AddFloat(XPos);
  AddFloat(YPos - Radius);
  Add('c');

  XPos := Left + Width - Radius;
  YPos := Top - Height + Radius;
  AddFloat(Left + Width - Radius);
  AddFloat(Top - Height);
  Add('l');
  AddFloat(XPos + Radius * Kappa);
  AddFloat(YPos - Radius);
  AddFloat(XPos + Radius);
  AddFloat(YPos - Radius * Kappa);
  AddFloat(XPos + Radius);
  AddFloat(YPos);
  Add('c');

  XPos := Left + Width - Radius;
  YPos := Top - Radius;
  AddFloat(Left + Width);
  AddFloat(Top - Radius);
  Add('l');
  AddFloat(XPos + Radius);
  AddFloat(YPos + Radius * Kappa);
  AddFloat(XPos + Radius * Kappa);
  AddFloat(YPos + Radius);
  AddFloat(XPos);
  AddFloat(YPos + Radius);
  Add('c');

  XPos := Left + Radius;
  YPos := Top - Radius;
  AddFloat(Left + Radius);
  AddFloat(Top);
  Add('l');
  AddFloat(XPos - Radius * Kappa);
  AddFloat(YPos + Radius);
  AddFloat(XPos - Radius);
  AddFloat(YPos + Radius * Kappa);
  AddFloat(XPos - Radius);
  AddFloat(YPos);
  Add('c');

  AddFloat(Left);
  AddFloat(Top - Height + Radius);
  Add('l');

  if Fill and (not Outline) then Add('f');
  if Outline and (not Fill) then Add('S');
  if Outline and Fill then Add('B');
  if (not Fill) and (not Outline) then Add('n');
  RunOnChanged;

  LineDashChanged := False;
  FontColorChanged := True;
end;

procedure TPDFPainter.RoundedRotatedRectangle(Left, Bottom, Width, Height,
  Radius, Angle: Double; Fill, Outline: Boolean);
var
  Kappa: Double;
  XPos: Double;
  YPos: Double;
  CosA: Double;
  SinA: Double;
  RadAngle: Double;
 begin
  RadAngle := DegToRad(Angle);
  CosA := Cos(RadAngle);
  SinA := Sin(RadAngle);
  Kappa := (Sqrt(2) - 1) / 3 * 4;
  Add(LineColorLine);
  Add(FillColorLine);
  Add(LineWidthLine);
  if LineDashChanged then
    Add(LineDashLine);

  XPos := Left + Radius;
  YPos := Bottom + Radius;
  AddFloat(CosA * ((XPos - Radius)-Left) - SinA * (YPos-Bottom) + Left);
  AddFloat(SinA * ((XPos - Radius)-Left) + CosA * (YPos-Bottom) + Bottom);
  Add('m');
  AddFloat(CosA * ((XPos - Radius)-Left) - SinA * ((YPos - Radius * Kappa)-Bottom) + Left);
  AddFloat(SinA * ((XPos - Radius)-Left) + CosA * ((YPos - Radius * Kappa)-Bottom) + Bottom);
  AddFloat(CosA * ((XPos - Radius * Kappa)-Left) - SinA * ((YPos - Radius)-Bottom) + Left);
  AddFloat(SinA * ((XPos - Radius * Kappa)-Left) + CosA * ((YPos - Radius)-Bottom) + Bottom);
  AddFloat(CosA * (XPos-Left) - SinA * ((YPos - Radius)-Bottom) + Left);
  AddFloat(SinA * (XPos-Left) + CosA * ((YPos - Radius)-Bottom) + Bottom);
  Add('c');

  XPos := Left + Width - Radius;
  YPos := Bottom + Radius;
  AddFloat(CosA * ((Left + Width - Radius)-Left) - SinA * (Bottom-Bottom) + Left);
  AddFloat(SinA * ((Left + Width - Radius)-Left) + CosA * (Bottom-Bottom) + Bottom);
  Add('l');
  AddFloat(CosA * ((XPos + Radius * Kappa)-Left) - SinA * ((YPos - Radius)-Bottom) + Left);
  AddFloat(SinA * ((XPos + Radius * Kappa)-Left) + CosA * ((YPos - Radius)-Bottom) + Bottom);
  AddFloat(CosA * ((XPos + Radius)-Left) - SinA * ((YPos - Radius * Kappa)-Bottom) + Left);
  AddFloat(SinA * ((XPos + Radius)-Left) + CosA * ((YPos - Radius * Kappa)-Bottom) + Bottom);
  AddFloat(CosA * ((XPos + Radius)-Left) - SinA * (YPos-Bottom) + Left);
  AddFloat(SinA * ((XPos + Radius)-Left) + CosA * (YPos-Bottom) + Bottom);
  Add('c');

  XPos := Left + Width - Radius;
  YPos := Bottom + Height - Radius;
  AddFloat(CosA * ((Left + Width)-Left) - SinA * ((Bottom + Height - Radius)-Bottom) + Left);
  AddFloat(SinA * ((Left + Width)-Left) + CosA * ((Bottom + Height - Radius)-Bottom) + Bottom);
  Add('l');
  AddFloat(CosA * ((XPos + Radius)-Left) - SinA * ((YPos + Radius * Kappa)-Bottom) + Left);
  AddFloat(SinA * ((XPos + Radius)-Left) + CosA * ((YPos + Radius * Kappa)-Bottom) + Bottom);
  AddFloat(CosA * ((XPos + Radius * Kappa)-Left) - SinA * ((YPos + Radius)-Bottom) + Left);
  AddFloat(SinA * ((XPos + Radius * Kappa)-Left) + CosA * ((YPos + Radius)-Bottom) + Bottom);
  AddFloat(CosA * (XPos-Left) - SinA * ((YPos + Radius)-Bottom) + Left);
  AddFloat(SinA * (XPos-Left) + CosA * ((YPos + Radius)-Bottom) + Bottom);
  Add('c');

  XPos := Left + Radius;
  YPos := Bottom + Height - Radius;
  AddFloat(CosA * ((Left + Radius)-Left) - SinA * ((Bottom + Height)-Bottom) + Left);
  AddFloat(SinA * ((Left + Radius)-Left) + CosA * ((Bottom + Height)-Bottom) + Bottom);
  Add('l');
  AddFloat(CosA * ((XPos - Radius * Kappa)-Left) - SinA * ((YPos + Radius)-Bottom) + Left);
  AddFloat(SinA * ((XPos - Radius * Kappa)-Left) + CosA * ((YPos + Radius)-Bottom) + Bottom);
  AddFloat(CosA * ((XPos - Radius)-Left) - SinA * ((YPos + Radius * Kappa)-Bottom) + Left);
  AddFloat(SinA * ((XPos - Radius)-Left) + CosA * ((YPos + Radius * Kappa)-Bottom) + Bottom);
  AddFloat(CosA * ((XPos - Radius)-Left) - SinA * (YPos-Bottom) + Left);
  AddFloat(SinA * ((XPos - Radius)-Left) + CosA * (YPos-Bottom) + Bottom);
  Add('c');

  AddFloat(CosA * (Left-Left) - SinA * ((Bottom + Radius)-Bottom) + Left);
  AddFloat(SinA * (Left-Left) + CosA * ((Bottom + Radius)-Bottom) + Bottom);
  Add('l');

  if Fill and (not Outline) then Add('f');
  if Outline and (not Fill) then Add('S');
  if Outline and Fill then Add('B');
  if (not Fill) and (not Outline) then Add('n');
  RunOnChanged;
  LineColorChanged := False;
  LineWidthChanged := False;
  LineDashChanged := False;
  FillColorChanged := False;
  FontColorChanged := True;
end;

procedure TPDFPainter.DrawHTMLText(Left, Top, Width: Double;
  const HTMLText: WideString);
var
  Dummy: AnsiString;
  Renderer: THTMLRenderer;
  HTMLTextA: AnsiString;
begin
  HTMLTextA := PrepareHTMLText(HTMLText);
  FHTMLSettings.Left := Left;
  FHTMLSettings.Top := Top;
  FHTMLSettings.Width := Width;
  FHTMLSettings.TextSpacing := FTextSpacing;
  Renderer := THTMLRenderer.Create(Self);
  try
    Dummy := '';
    Renderer.Render(HTMLTextA, FHTMLSettings, False, 0, Dummy);
  finally
    Renderer.Free;
  end;
end;

procedure TPDFPainter.SetHTMLBoldFont(AFont: TPDFFont);
begin
  FHTMLSettings.BoldFont := AFont;
end;

procedure TPDFPainter.SetHTMLNormalFont(AFont: TPDFFont);
begin
  FHTMLSettings.NormalFont := AFont;
end;

procedure TPDFPainter.SetHTMLItalicFont(AFont: TPDFFont);
begin
  FHTMLSettings.ItalicFont := AFont;
end;

procedure TPDFPainter.SetHTMLBoldItalicFont(AFont: TPDFFont);
begin
  FHTMLSettings.BoldItalicFont := AFont;
end;

procedure TPDFPainter.SetGS(const GSName: AnsiString);
begin
  Add('/' + GSName + ' gs');
end;

function TPDFPainter.GetHTMLTextHeight(Width: Double;
  const HTMLText: WideString): Double;
var
  Dummy: AnsiString;
  Renderer: THTMLRenderer;
  HTMLTextA: AnsiString;
begin
  HTMLTextA := PrepareHTMLText(HTMLText);
  FHTMLSettings.Left := 0;
  FHTMLSettings.Top := 0;
  FHTMLSettings.Width := Width;
  FHTMLSettings.TextSpacing := TextSpacing;
  Renderer := THTMLRenderer.Create(Self);
  try
    Dummy := '';
    Result := Renderer.Render(HTMLTextA, FHTMLSettings, True, 0, Dummy);
  finally
    Renderer.Free;
  end;
end;

function TPDFPainter.DrawHTMLTextBox(Left, Top, Width, Height: Double;
  const HTMLText: WideString): WideString;
var
  Renderer: THTMLRenderer;
  HTMLTextA: AnsiString;
  ResultA: AnsiString;
  X: Integer;
begin
  HTMLTextA := PrepareHTMLText(HTMLText);
  FHTMLSettings.Left := Left;
  FHTMLSettings.Top := Top;
  FHTMLSettings.Width := Width;
  FHTMLSettings.TextSpacing := TextSpacing;
  Renderer := THTMLRenderer.Create(Self);
  try
    Renderer.Render(HTMLTextA, FHTMLSettings, False, Height, ResultA);
    SetLength(Result, Length(ResultA) div 2);
    if (Length(ResultA) > 0) then
    begin
      Move(ResultA[1], Result[1], Length(ResultA));
    end;
    for X := 1 to Length(Result) do
    begin
      Result[X] := WideChar(((Ord(Result[X]) and $FF) shl 8) +
        ((Ord(Result[X]) and $FF00) shr 8));
    end;
  finally
    Renderer.Free;
  end;
end;

function TPDFPainter.DrawHTMLTextBoxMatrix(Width, Height: Double;
  const HTMLText: WideString; eM11, eM12, eM21, eM22, eDx,
  eDy: Double): WideString;
begin
  Add('q');
  AddFloat(eM11);
  AddFloat(eM12);
  AddFloat(eM21);
  AddFloat(eM22);
  AddFloat(eDx);
  AddFloat(eDy);
  Add('cm');

  AddFloat(1 / Width);
  AddFloat(0);
  AddFloat(0);
  AddFloat(1 / Height);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  Result := DrawHTMLTextBox(0, Height, Width, Height, HTMLText);
  Add('Q');

  RunOnChanged;
end;

function TPDFPainter.DrawHTMLTextMatrix(Width: Double;
  const HTMLText: WideString; eM11, eM12, eM21, eM22, eDx,
  eDy: Double): Integer;
begin
  Result := 0;
  Add('q');
  AddFloat(eM11);
  AddFloat(eM12);
  AddFloat(eM21);
  AddFloat(eM22);
  AddFloat(eDx);
  AddFloat(eDy);
  Add('cm');

{  AddFloat(1 / Width);
  AddFloat(0);
  AddFloat(0);
  AddFloat(1 / 80);
  AddFloat(0);
  AddFloat(0);
  Add('cm');}

  DrawHTMLText(0, 0, Width, HTMLText);
  Add('Q');

  RunOnChanged;
end;

procedure TPDFPainter.DrawXObject(CP: TPDFCapturedPage; Left, Top,
  Width, Height: Double);
var
  WS: Double;
  HS: Double;
begin
  Add('q');
  WS := Width / CP.OriginalWidth;
  HS := Height / CP.OriginalHeight;

  AddFloat(10 * WS);
  AddFloat(0);
  AddFloat(0);
  AddFloat(10 * HS);
  AddFloat(Left - CP.XOffset * WS);
  AddFloat(Top - Height - CP.YOffset * HS);
  Add('cm');

  AddFloat(0.1);
  AddFloat(0);
  AddFloat(0);
  AddFloat(0.1);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  Add('/' + CP.XObjectName + ' Do');
  Add('Q');

  RunOnChanged;
end;

procedure TPDFPainter.Ellipse(XPos, YPos, Width, Height: Double; Fill,
  Outline: Boolean);
var
  Kappa: Double;
  W2: Double;
  H2: Double;
begin
  Kappa := (Sqrt(2) - 1) / 3 * 4;
  W2 := Width / 2;
  H2 := Height / 2;
  if LineColorChanged then
    Add(LineColorLine);
  if FillColorChanged then
    Add(FillColorLine);
  if LineWidthChanged then
    Add(LineWidthLine);
  if LineDashChanged then
    Add(LineDashLine);
  AddFloat(XPos - W2);
  AddFloat(YPos);
  Add('m');
  AddFloat(XPos - W2);
  AddFloat(YPos - H2 * Kappa);
  AddFloat(XPos - W2 * Kappa);
  AddFloat(YPos - H2);
  AddFloat(XPos);
  AddFloat(YPos - H2);
  Add('c');

  AddFloat(XPos + W2 * Kappa);
  AddFloat(YPos - H2);
  AddFloat(XPos + W2);
  AddFloat(YPos - H2 * Kappa);
  AddFloat(XPos + W2);
  AddFloat(YPos);
  Add('c');

  AddFloat(XPos + W2);
  AddFloat(YPos + H2 * Kappa);
  AddFloat(XPos + W2 * Kappa);
  AddFloat(YPos + H2);
  AddFloat(XPos);
  AddFloat(YPos + H2);
  Add('c');

  AddFloat(XPos - W2 * Kappa);
  AddFloat(YPos + H2);
  AddFloat(XPos - W2);
  AddFloat(YPos + H2 * Kappa);
  AddFloat(XPos - W2);
  AddFloat(YPos);
  Add('c');

  if Fill and (not Outline) then Add('f');
  if Outline and (not Fill) then Add('S');
  if Outline and Fill then Add('B');
  if (not Fill) and (not Outline) then Add('n');
  RunOnChanged;

  FillColorChanged := False;
  LineColorChanged := False;
  LineWidthChanged := False;
  LineDashChanged := False;
  FontColorChanged := True;
end;

procedure TPDFPainter.EllipticArc(XPos, YPos, Width, Height, StartAngle,
  EndAngle: Double; Pie, Fill, Outline, Close: Boolean);
var
  X1, X2, Y1, Y2: Double;  // End points
  X1S, Y1S: Double;        // Squares of first end point
  CtAX, CtAY: Double;      // First control point
  CtBX, CtBY: Double;      // Second control point
  Kappa: Double;           // Control point distance
  Alpha: Double;           // Start angle, in radians
  Beta: Double;            // End angle, in radians
  AngleNow: Double;        // Current angle, in degrees
  Remaining: Double;       // Remaining angles
  ThisWedge: Double;       // Angle of this wedge
  Radius: Double;
begin

  // Changed internally to accept normal angles based on 3 O'Clock
  // being 0 degrees and going anticlockwise.  12 O'Clock = 90 degrees.
  // Code is easier to read and maintain

  if (StartAngle >= EndAngle) then
    EndAngle := EndAngle + 360;

  Radius := Width / 2;

  Alpha := DegToRad(StartAngle);
  X1 := Radius * Cos(Alpha);
  Y1 := Radius * Sin(Alpha);

  if Pie then
  begin
    StartPath(XPos, YPos);
    AddLineToPath(XPos + X1, YPos + Y1 * Height / Width);
  end else
    StartPath(XPos + X1, YPos + Y1 * Height / Width);

  Remaining := Abs(EndAngle - StartAngle);
  AngleNow := StartAngle;

  repeat
    if Remaining > 90 then
      ThisWedge := 90
    else
      ThisWedge := Remaining;
    Remaining := Remaining - ThisWedge;

    Alpha := DegToRad(AngleNow);
    Beta := DegToRad(AngleNow + ThisWedge);

    // Calculate start and end points
    X1 := Radius * Cos(Alpha);
    Y1 := Radius * Sin(Alpha);
    X2 := Radius * Cos(Beta);
    Y2 := Radius * Sin(Beta);

    // Calculate "kappa"
    X1S := Power(X1, 2);
    Y1S := Power(Y1, 2);
    Kappa := 4 * (Sqrt(2 * (X1S + Y1S) * (X1S + Y1S + X1 * X2 + Y1 * Y2)) -
      (X1S + Y1S + X1 * X2 + Y1 * Y2)) / (3 * (X1 * Y2 - Y1 * X2));

    // Calculate control points
    CtAX := XPos + X1 - Kappa * Y1;
    CtAY := YPos + Y1 + Kappa * X1;
    CtBX := XPos + X2 + Kappa * Y2;
    CtBY := YPos + Y2 - Kappa * X2;

    // Translate (X2,Y2) back to centre
    X2 := XPos + X2;
    Y2 := YPos + Y2;

    (*
    // Draw the control points
    SetFillColor(0.4, 0.8, 0.4);
    Rectangle(CtAX - 2, CtAY - 1, 4, 4, True, False);
    Rectangle(CtBX - 2, CtBY - 1, 4, 4, True, False);
    *)

    // Draw the curve
    AddCurveToPath(CtAX, (CtAY - YPos) * Height / Width + YPos,
      CtBX, (CtBY - YPos) * Height / Width + YPos,
      X2, (Y2 - YPos) * Height / Width + YPos);

    AngleNow := AngleNow + ThisWedge;
  until Remaining <= 0.000001;

  if Pie or Close then ClosePath;

  // Paint the path
  DrawPath(Fill, Outline);

  FontColorChanged := True;
end;

procedure TPDFPainter.SetLineCap(ALineCap: Integer);
begin
  LineCap := ALineCap;
  LineWidthLine :=  MakeFloat(MiterLimit) + 'M ' +
    MakeFloat(LineWidth) + 'w ' + QPLIntToStr(LineCap) + ' J ' +
    QPLIntToStr(LineJoin) + ' j';
  LineWidthChanged := True;
end;

procedure TPDFPainter.SetLineJoin(ALineJoin: Integer);
begin
  LineJoin := ALineJoin;
  LineWidthLine :=  MakeFloat(MiterLimit) + 'M ' +
    MakeFloat(LineWidth) + 'w ' + QPLIntToStr(LineCap) + ' J ' +
    QPLIntToStr(LineJoin) + ' j';
  LineWidthChanged := True;
end;

procedure TPDFPainter.MovePath(StartX, StartY: Double);
begin
  LastX := StartX;
  LastY := StartY;
  RipePath := True;
  Path.Add(MakeFloat(StartX) + MakeFloat(StartY) + 'm');
end;

function TPDFPainter.PrepareHTMLText(const HTMLText: WideString): AnsiString;
var
  HX: Integer;
begin
  SetLength(Result, Length(HTMLText) * 2);
  for HX := 1 to Length(HTMLText) do
  begin
    Result[HX * 2 - 1] := AnsiChar((Ord(HTMLText[HX]) and $FF00) shr 8);
    Result[HX * 2] := AnsiChar(Ord(HTMLText[HX]) and $FF);
  end;
end;

procedure TPDFPainter.DrawPathEvenOdd(Fill, Outline: Boolean);
var
  PathLine: Integer;
begin
  if RipePath then
  begin
    if LineColorChanged then
      Add(LineColorLine);
    if FillColorChanged then
      Add(FillColorLine);
    if LineWidthChanged then
      Add(LineWidthLine);
    if LineDashChanged then
      Add(LineDashLine);

    for PathLine := 0 to Path.Count - 1 do
      Add(Path[PathLine]);

    if Fill and (not Outline) then Add('f*');
    if Outline and (not Fill) then Add('S');
    if Outline and Fill then Add('B*');
    if (not Fill) and (not Outline) then Add('n');

    Path.Clear;
    RunOnChanged;
    RipePath := False;
  end;
  FillColorChanged := False;
  LineColorChanged := False;
  LineDashChanged := False;
  LineWidthChanged := False;
  FontColorChanged := True;
end;

function TPDFPainter.DrawPDF417Symbol(Left, Top: Double; const Text: WideString;
  Options, FixedRows, FixedColumns, ErrorLevel: Integer; ModuleSize, HeightWidthRatio: Double): Boolean;
var
  PDF417: TDebenuPDFLibraryPDF417;
  Row: Integer;
  Col: Integer;
  XPos: Double;
  YPos: Double;
  XDeltaCol: Double;
  YDeltaCol: Double;
  XDeltaRow: Double;
  YDeltaRow: Double;
  FullWidth: Double;
  FullHeight: Double;
  VModuleSize: Double;
begin
  VModuleSize := ModuleSize * HeightWidthRatio;
  PDF417 := TDebenuPDFLibraryPDF417.Create;
  try
    PDF417.ErrorLevel := ErrorLevel;
    PDF417.FixedCols := FixedColumns;
    PDF417.FixedRows := FixedRows;
    Result := PDF417.Encode(Text);

    if (Result) then
    begin
      case Options of
        1:
        begin
          XPos := Left;
          YPos := Top - ModuleSize * PDF417.Cols;
          XDeltaCol := 0;
          YDeltaCol := ModuleSize;
          XDeltaRow := VModuleSize;
          YDeltaRow := -ModuleSize * PDF417.Cols;
          FullWidth := VModuleSize * PDF417.Rows;
          FullHeight := ModuleSize * PDF417.Cols;
        end;
        2:
        begin
          XPos := Left + ModuleSize * (PDF417.Cols - 1);
          YPos := Top - VModuleSize * PDF417.Rows;
          XDeltaCol := -ModuleSize;
          YDeltaCol := 0;
          XDeltaRow := ModuleSize * PDF417.Cols;
          YDeltaRow := VModuleSize;
          FullWidth := ModuleSize * PDF417.Cols;
          FullHeight := VModuleSize * PDF417.Rows;
        end;
        3:
        begin
          XPos := Left + VModuleSize * (PDF417.Rows - 1);
          YPos := Top - ModuleSize;
          XDeltaCol := 0;
          YDeltaCol := -ModuleSize;
          XDeltaRow := -VModuleSize;
          YDeltaRow := ModuleSize * PDF417.Cols;
          FullWidth := VModuleSize * PDF417.Rows;
          FullHeight := ModuleSize * PDF417.Cols;
        end;
      else
        XPos := Left;
        YPos := Top - VModuleSize;
        XDeltaCol := ModuleSize;
        YDeltaCol := 0;
        XDeltaRow := -ModuleSize * PDF417.Cols;
        YDeltaRow := -VModuleSize;
        FullWidth := ModuleSize * PDF417.Cols;
        FullHeight := VModuleSize * PDF417.Rows;
      end;

      AddFloat(Left);
      AddFloat(Top);
      AddFloat(FullWidth);
      AddFloat(-FullHeight);
      Add('re');
      Add('1 1 1 rg');
      Add('f');

      for Row := 1 to PDF417.Rows do
      begin
        for Col := 1 to PDF417.Cols do
        begin
          if PDF417.GetModule(Row, Col) then
          begin
            AddFloat(XPos);
            AddFloat(YPos);
            if (Options = 0) or (Options = 2) then
            begin
              AddFloat(ModuleSize);
              AddFloat(VModuleSize);
            end else
            begin
              AddFloat(VModuleSize);
              AddFloat(ModuleSize);
            end;
            Add('re');
          end;
          XPos := XPos + XDeltaCol;
          YPos := YPos + YDeltaCol;
        end;
        XPos := XPos + XDeltaRow;
        YPos := YPos + YDeltaRow;
      end;

      Add(FillColorLine);
      Add('f');
    end;
  finally
    PDF417.Free;
  end;
  RunOnChanged;
end;

procedure TPDFPainter.SetClippingPathEvenOdd;
var
  PathLine: Integer;
begin
  if RipePath then
  begin
    for PathLine := 0 to Path.Count - 1 do
      Add(Path[PathLine]);
    Add('W* n');
    Path.Clear;
    RunOnChanged;
    RipePath := False;
  end;
end;

procedure TPDFPainter.DrawRotatedImage(Image: TPDFImage; Left, Bottom,
  Width, Height, Angle: Double);
var
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  RadAngle: Double;
begin
  RadAngle := DegToRad(Angle);
  CosA := MakeFloat(Cos(RadAngle));
  SinA := MakeFloat(Sin(RadAngle));
  NegSinA := MakeFloat(-Sin(RadAngle));

  Add('q');
  if (Image.GetMaskType = mtStencilMask) and FillColorChanged then
    Add(FillColorLine);
  Add(CosA + SinA + NegSinA + CosA + ' ' +
    MakeFloat(Left) + MakeFloat(Bottom) + 'cm');

  if (Image.ImageType <> itEMF) then
  begin
    AddFloat(Width);
    AddFloat(0);
    AddFloat(0);
    AddFloat(Height);
    AddFloat(0);
    AddFloat(0);
    Add('cm');
    Add('/' + Image.Name + ' Do');
    Add('Q');
  end else
  begin
    AddFloat(Min(Width, Height));
    AddFloat(0);
    AddFloat(0);
    AddFloat(Min(Width, Height));
    AddFloat(0);
    AddFloat(0);
    Add('cm');
    Add('/' + Image.Name + ' Do');
    Add('Q');
  end;

  {
  AddFloat(Width);
  AddFloat(0);
  AddFloat(0);
  AddFloat(Height);
  AddFloat(0);
  AddFloat(0);
  Add('cm');
  Add('/' + Image.Name + ' Do');
  Add('Q');
  }
  RunOnChanged;
end;

procedure TPDFPainter.DrawRotatedMultiLineWideText(XPos, YPos, Angle: Double;
  const Delimiter, Text: WideString);
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  try
    PDFPrecNum := 8;
    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add(CosA + SinA + NegSinA + CosA + ' ' +
      MakeFloat(XPos) + MakeFloat(YPos) + 'cm');
    try
      DrawMultiLineWideText(0, 0, Delimiter, Text);
    finally
      RadAngle := DegToRad(-Angle);
      CosA := MakeFloat(Cos(RadAngle));
      SinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(CosA + SinA + NegSinA + CosA + ' ' +
        MakeFloat(0) + MakeFloat(0) + 'cm');
      Add('1 0 0 1 ' + MakeFloat(-XPos) + MakeFloat(-YPos) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

procedure TPDFPainter.DrawXObjectAngle(const XObjectRef: AnsiString; Left, Bottom,
  Width, Height, OriginalWidth, OriginalHeight, Angle: Double);
var
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  RadAngle: Double;
begin
  RadAngle := DegToRad(Angle);
  CosA := MakeFloat(Cos(RadAngle));
  SinA := MakeFloat(Sin(RadAngle));
  NegSinA := MakeFloat(-Sin(RadAngle));

  Add('q');
  Add(CosA + SinA + NegSinA + CosA + ' ' +
    MakeFloat(Left) + MakeFloat(Bottom) + 'cm');

  AddFloat(10 * Width / OriginalWidth);
  AddFloat(0);
  AddFloat(0);
  AddFloat(10 * Height / OriginalHeight);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  AddFloat(0.1);
  AddFloat(0);
  AddFloat(0);
  AddFloat(0.1);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  Add('/' + XObjectRef + ' Do');
  Add('Q');

  RunOnChanged;
end;

procedure TPDFPainter.DrawXObjectMatrix(const XObjectRef: AnsiString; eM11,
  eM12, eM21, eM22, eDx, eDy, OriginalWidth, OriginalHeight: Double);
begin
  Add('q');

  AddFloat(eM11);
  AddFloat(eM12);
  AddFloat(eM21);
  AddFloat(eM22);
  AddFloat(eDx);
  AddFloat(eDy);
  Add('cm');

  AddFloat(1 / OriginalWidth);
  AddFloat(0);
  AddFloat(0);
  AddFloat(1 / OriginalHeight);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  Add('/' + XObjectRef + ' Do');
  Add('Q');

  RunOnChanged;
end;

procedure TPDFPainter.SetTextScaling(Scaling: Double);
begin
  FontScalingLine := MakeFloat(Scaling) + 'Tz';
  FTextScaling := Scaling;
  FontScalingChanged := True;
end;

procedure TPDFPainter.Rotate(XOffset, YOffset, Angle: Double);
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
begin
  RadAngle := DegToRad(Angle);

  CosA := MakeFloat(Cos(RadAngle));
  SinA := MakeFloat(Sin(RadAngle));
  NegSinA := MakeFloat(-Sin(RadAngle));

  Add(CosA + SinA + NegSinA + CosA + ' ' +
    MakeFloat(XOffset) + MakeFloat(YOffset));
  Add('cm');
end;

procedure TPDFPainter.RotatedRectangle(Left, Bottom, Width, Height,
  Angle: Double; Fill, Outline: Boolean);
var
  CosA: Double;
  SinA: Double;
  RadAngle: Double;
begin
  RadAngle := DegToRad(Angle);
  CosA := Cos(RadAngle);
  SinA := Sin(RadAngle);

  if LineColorChanged then
    Add(LineColorLine);
  if FillColorChanged then
    Add(FillColorLine);
  if LineWidthChanged then
    Add(LineWidthLine);
  if LineDashChanged then
    Add(LineDashLine);
  AddFloat(Left);
  AddFloat(Bottom);
  Add('m');
  AddFloat(Left - SinA * Height);
  AddFloat(Bottom + CosA * Height);
  Add('l');
  AddFloat(Left - SinA * Height + CosA * Width);
  AddFloat(Bottom + CosA * Height + SinA * Width);
  Add('l');
  AddFloat(Left + CosA * Width);
  AddFloat(Bottom + SinA * Width);
  Add('l');
  Add('h');
  if Fill and (not Outline) then Add('f');
  if Outline and (not Fill) then Add('S');
  if Outline and Fill then Add('B');
  if (not Fill) and (not Outline) then Add('n');
  RunOnChanged;
  LineColorChanged := False;
  LineWidthChanged := False;
  LineDashChanged := False;
  FillColorChanged := False;
  FontColorChanged := True;
end;

procedure TPDFPainter.FitTextBox(Left, Top, Width, Height: Double;
  const Text: AnsiString; Options: Integer; const BreakString: AnsiString);
var
  TextSize: Double;
  OldTextSize: Double;
  TestHeight: Double;
  TestWidth: Double;
  Step: Double;
  Count: Integer;
  NoWrap: Boolean;
  NoWordBreak: Boolean;
  TextBlockFlags: TPDFTextBlockFlags;
  X: Integer;
  HasWordBreak: Boolean;
begin
  OldTextSize := FTextSize;
  TextSize := OldTextSize;
  Step := 10;
  Count := 0;
  SetLength(TextBlockFlags, 0);
  NoWordBreak := Options >= 100;
  if NoWordBreak then Options := Options - 100;
  NoWrap := Options > 2;
  if NoWrap then Options := Options - 3;

  if NoWrap then
  begin
    repeat
      repeat
        Inc(Count);
        TestWidth := TextWidth(Text);
        if TestWidth > Width then
        begin
          if TextSize - Step < 0 then Step := TextSize / 4;
          TextSize := TextSize - Step;
          SelectFont(FSelFont, TextSize);
        end;
      until (TestWidth <= Width) or (Count > 30);
      if (Step / 10) >= 0.009 then
      begin
        TextSize := TextSize + Step;
        SelectFont(FSelFont, TextSize);
        Step := Step / 10;
      end;
    until (Step < 0.009) or (Count > 30);
  end;

  Step := 10;
  Count := 0;
  repeat
    repeat
      Inc(Count);
      if NoWrap then
        TestHeight := Self.TextHeight
      else
        TestHeight := GetWrappedTextHeight(Width, Text, BreakString, TextBlockFlags);
         HasWordBreak := false;
         If NoWordBreak then
            begin
               X := 0;
               While (X < Length(TextBlockFlags) - 1) and (Not HasWordBreak) do
                  if TextBlockFlags[X].WordBreak = true then
                    HasWordBreak := True
                  else
                    X := X + 1;
            end;
      if (TestHeight > Height) or (NoWordBreak and HasWordBreak) then
      begin
        if TextSize - Step < 0 then Step := TextSize / 4;
        TextSize := TextSize - Step;
        SelectFont(FSelFont, TextSize);
      end;
    until ((TestHeight <= Height) and not(NoWordBreak and HasWordBreak)) or (Count > 30);
    if (Step / 10) >= 0.009 then
    begin
      TextSize := TextSize + Step;
      if TextSize > OldTextSize then TextSize := OldTextSize;
      SelectFont(FSelFont, TextSize);
      Step := Step / 10;
    end;
  until (Step < 0.009) or (Count > 30);
  DrawTextBox(Left, Top, Width, Height, Text, Options, BreakString);
  SelectFont(FSelFont, OldTextSize);
end;

procedure TPDFPainter.FitWideTextBox(Left, Top, Width, Height: Double;
  const Text: WideString; Options: Integer; const BreakString: WideString);
var
  TextSize: Double;
  OldTextSize: Double;
  TestHeight: Double;
  TestWidth: Double;
  Step: Double;
  Count: Integer;
  NoWrap: Boolean;
  NoWordBreak: Boolean;
  GrowFontSize: Boolean;
  TextBlockFlags: TPDFTextBlockFlags;
  X: Integer;
  HasWordBreak: Boolean;
  Low, High: Double;
begin
  OldTextSize := FTextSize;
  TextSize := OldTextSize;
  Step := 10;
  Count := 0;
  High := 0;
  Low := 0.00001;

  SetLength(TextBlockFlags, 0);

  GrowFontSize := Options >= 1000;
  Options := Options mod 1000;

  NoWordBreak := Options >= 100;
  Options := Options mod 100;

  NoWrap := Options > 2;
  if NoWrap then Options := Options - 3;

  if NoWrap then
  begin
    repeat
      repeat
        Inc(Count);
        TestWidth := WideTextWidth(Text);
        if TestWidth > Width then
        begin
          if TextSize - Step < 0 then Step := TextSize / 4;
          TextSize := TextSize - Step;
          SelectFont(FSelFont, TextSize);
        end;
      until (TestWidth <= Width) or (Count > 30);
      if (Step / 10) >= 0.009 then
      begin
        TextSize := TextSize + Step;
        SelectFont(FSelFont, TextSize);
        Step := Step / 10;
      end;
    until (Step < 0.009) or (Count > 30);
  end;

  Step := 10;
  Count := 0;

  repeat
    Inc(Count);
    if (NoWrap) then
    begin
      TestHeight := Self.TextHeight;
    end else
    begin
      TestHeight := GetWrappedWideTextHeight(Width, Text, BreakString, TextBlockFlags);
    end;

    HasWordBreak := false;
    if (NoWordBreak) then
    begin
      X := 0;
      while (X < Length(TextBlockFlags) - 1) and (not HasWordBreak) do
      begin
        if (TextBlockFlags[X].WordBreak) then
        begin
          HasWordBreak := True;
        end else
        begin
          X := X + 1;
        end;
      end;
    end;
    if (TestHeight > Height) or (NoWordBreak and HasWordBreak) then
    begin
      High := TextSize;
      if (High <> 0) and (Low <> 0) then
        Step := Abs(High - Low) / 2;

      TextSize := TextSize - Step;
      SelectFont(FSelFont, TextSize);
    end else
    begin
      Low := TextSize;
      if (High <> 0) and (Low <> 0) then
        Step := Abs(High - Low) / 2;

      TextSize := TextSize + Step;
      SelectFont(FSelFont, TextSize);
    end;
  until ((Step < 0.001) and not (NoWordBreak and HasWordBreak)) or (Count > 30);

  if (GrowFontSize) then
  begin
    TextSize := Low;
  end else
  begin
    if (Low > OldTextSize) then
    begin
      TextSize := OldTextSize;
    end else
    begin
      TextSize := Low;
    end;
  end;

  SelectFont(FSelFont, TextSize);

  DrawWideTextBox(Left, Top, Width, Height, Text, Options, BreakString);
  SelectFont(FSelFont, OldTextSize);
end;

function TPDFPainter.DrawTextBox(Left, Top, Width, Height: Double;
  const Text: AnsiString; Options: Integer; const BreakString: AnsiString): Integer;
var
  S: AnsiString;
  SL: TQuickPDFStringList;
  H: Double;
  RH: Double;
  DX: Integer;
  XP, YP: Double;
  DE: Integer;
  NoWrap: Boolean;
  TextBlockFlags: TPDFTextBlockFlags;
  NL: Integer;
begin
  SetLength(TextBlockFlags, 0);
  NoWrap := Options > 2;
  if NoWrap then Options := Options - 3;

  SL := TQuickPDFStringList.Create;
  try
    S := GetWrappedText(Width, Text, #13, BreakString, TextBlockFlags);
    if FSelFont.FontType = ftCJK then
    begin
      while QPLPos(#0#13, S) > 0 do
      begin
        SL.Add(QPLCopy(S, 1, QPLPos(#0#13, S) - 1));
        Delete(S, 1, QPLPos(#0#13, S) + 1);
      end;
      if S <> '' then
        SL.Add(S);
    end else
      SL.Text := S;
    H := GetWrappedTextHeight(Width, Text, BreakString);
    if (H > Height) or NoWrap then
    begin
      RH := TextHeight + FTextSpacing;
      if RH > 0 then
      begin
        NL := Trunc(Height / RH);
        if NL * (TextHeight + FTextSpacing) + TextHeight <= Height then
          NL := NL + 1;
      end else
        NL := 0;
      DE := SL.Count - NL;
      if DE <= 0 then DE := 1;
      if NoWrap then DE := SL.Count - 1;
      for DX := 1 to DE do
        if SL.Count > 0 then SL.Delete(SL.Count - 1);
    end;
    while (SL.Count > 1) and (SL[SL.Count - 1] = '') do
      SL.Delete(SL.Count - 1);

    if FSelFont.FontType = ftCJK then
    begin
      S := '';
      for DX := 0 to SL.Count - 1 do
      begin
        S := S + SL[DX];
        if DX < (SL.Count - 1) then S := S + #0#13#0#10;
      end;
      if QPLCopy(S, Length(S) - 3, 4) = #0#13#0#10 then
        Delete(S, Length(S) - 3, 4);
    end else
    begin
      S := SL.Text;
      if QPLCopy(S, Length(S) - 1, 2) = #13#10 then
        Delete(S, Length(S) - 1, 2);
    end;
    if S <> '' then
    begin
      H := GetWrappedTextHeight(Width, S, #13#10);
      XP := Left;
      YP := Top;
      Height := Height;
      H := H;
      case Options of
        1: YP := YP - TextBound(2);
        2: YP := YP - Height + H - TextBound(2);
      else
        YP := YP - (Height - H) / 2 - TextBound(2);
      end;

      case FTextAlign of
        paCenter: XP := XP + Width / 2;
        paRight: XP := XP + Width;
      end;

      DrawMultiLineText(XP, YP, #13#10, S, TextBlockFlags, Width);
    end;
  finally
    Result := SL.Count;  
    SL.Free;
  end;
end;

function TPDFPainter.DrawWideTextBox(Left, Top, Width, Height: Double;
  const Text: WideString; Options: Integer; const BreakString: WideString): Integer;
var
  S: WideString;
  SL: TQuickPDFStringList;
  H: Double;
  RH: Double;
  DX: Integer;
  XP, YP: Double;
  DE: Integer;
  NoWrap: Boolean;
  TextBlockFlags: TPDFTextBlockFlags;
  NL: Integer;
begin
  SetLength(TextBlockFlags, 0);
  NoWrap := Options > 2;
  if NoWrap then Options := Options - 3;

  SL := TQuickPDFStringList.Create;
  try
    WideWordWrap(Text, SL, Width, BreakString, TextBlockFlags);
    H := GetWrappedWideTextHeight(Width, Text, BreakString);
    if (H > Height) or NoWrap then
    begin
      RH := TextHeight + FTextSpacing;
      if RH > 0 then
      begin
        NL := Trunc(Height / RH);
        if NL * (TextHeight + FTextSpacing) + TextHeight <= Height then
          NL := NL + 1;
      end else
        NL := 0;
      DE := SL.Count - NL;
      if DE <= 0 then DE := 1;
      if NoWrap then DE := SL.Count - 1;
      for DX := 1 to DE do
        if SL.Count > 0 then SL.Delete(SL.Count - 1);
    end;
    while (SL.Count > 1) and (SL[SL.Count - 1] = '') do
      SL.Delete(SL.Count - 1);

    S := '';
    for DX := 0 to SL.Count - 1 do
    begin
      S := S + QPLUTF8Decode(SL[DX]) + #13#10;
    end;

    if (Copy(S, Length(S) - 1, 2) = #13#10) then
    begin
      Delete(S, Length(S) - 1, 2);
    end;

    if S <> '' then
    begin
      H := GetWrappedWideTextHeight(Width, S, #13#10);
      XP := Left;
      YP := Top;
      Height := Height;
      H := H;
      case Options of
        1: YP := YP - TextBound(2);
        2: YP := YP - Height + H - TextBound(2);
      else
        YP := YP - (Height - H) / 2 - TextBound(2);
      end;

      case FTextAlign of
        paCenter: XP := XP + Width / 2;
        paRight: XP := XP + Width;
      end;

      DrawMultiLineWideText(XP, YP, #13#10, S, TextBlockFlags, Width);
    end;
  finally
    Result := SL.Count;
    SL.Free;
  end;
end;

function TPDFPainter.DrawWideTextBoxMatrix(Width, Height: Double;
  const Text: WideString; Options: Integer; const BreakString: WideString; eM11,
  eM12, eM21, eM22, eDx, eDy: Double): Integer;
begin
  SaveState();
  Add('q');
  AddFloat(eM11);
  AddFloat(eM12);
  AddFloat(eM21);
  AddFloat(eM22);
  AddFloat(eDx);
  AddFloat(eDy);
  Add('cm');

  AddFloat(1 / Width);
  AddFloat(0);
  AddFloat(0);
  AddFloat(1 / Height);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  Result := DrawWideTextBox(0, Height, Width, Height, Text, Options, BreakString);
  Add('Q');
  LoadState();

  RunOnChanged;
end;

procedure TPDFPainter.AddArcToPath(CenterX, CenterY, TotalAngle: Double);
var
  X1, X2, Y1, Y2: Double;  // End points
  X1S, Y1S: Double;        // Squares of first end point
  CtAX, CtAY: Double;      // First control point
  CtBX, CtBY: Double;      // Second control point
  Kappa: Double;           // Control point distance
  Alpha: Double;           // Start angle, in radians
  Beta: Double;            // End angle, in radians
  AngleNow: Double;        // Current angle, in degrees
  Remaining: Double;       // Remaining angles
  ThisWedge: Double;       // Angle of this wedge
  StartAngle: Double;
  Radius: Double;
  EndAngle: Double;
  DX, DY: Double;
begin
  Radius := Sqrt(Sqr(CenterX - LastX) + Sqr(CenterY - LastY));

  DX := LastX - CenterX;
  DY := LastY - CenterY;

  StartAngle := RadToDeg(ArcSin(DX / Radius));
  if (DY < 0) then StartAngle := 180 - StartAngle;
  EndAngle := StartAngle + TotalAngle;

//  Alpha := DegToRad(90 - StartAngle);
//  X1 := Radius * Cos(Alpha);
//  Y1 := Radius * Sin(Alpha);

  Remaining := EndAngle - StartAngle;
  AngleNow := StartAngle;

  repeat
    if Remaining > 90 then
      ThisWedge := 90
    else if Remaining < -90 then
      ThisWedge := -90
    else
      ThisWedge := Remaining;
    Remaining := Remaining - ThisWedge;

    Alpha := DegToRad(90 - AngleNow);
    Beta := DegToRad(90 - (AngleNow + ThisWedge));

    // Calculate start and end points
    X1 := Radius * Cos(Alpha);
    Y1 := Radius * Sin(Alpha);
    X2 := Radius * Cos(Beta);
    Y2 := Radius * Sin(Beta);

    // Calculate "kappa"
    X1S := Power(X1, 2);
    Y1S := Power(Y1, 2);
    Kappa := 4 * (Sqrt(2 * (X1S + Y1S) * (X1S + Y1S + X1 * X2 + Y1 * Y2)) -
      (X1S + Y1S + X1 * X2 + Y1 * Y2)) / (3 * (X1 * Y2 - Y1 * X2));

    // Calculate control points
    CtAX := CenterX + X1 - Kappa * Y1;
    CtAY := CenterY + Y1 + Kappa * X1;
    CtBX := CenterX + X2 + Kappa * Y2;
    CtBY := CenterY + Y2 - Kappa * X2;

    // Translate (X2,Y2) back to centre
    X2 := CenterX + X2;
    Y2 := CenterY + Y2;

    // Draw the curve
    AddCurveToPath(CtAX, CtAY, CtBX, CtBY, X2, Y2);

    AngleNow := AngleNow + ThisWedge;
  until Abs(Remaining) < 0.000001;
end;

procedure TPDFPainter.AddBoxToPath(Left, Top, Width, Height: Double);
begin
  //DPL-279
  //Path.Add(MakeFloat(Left) + MakeFloat(Top - Height) + MakeFloat(Width) + MakeFloat(Height) + 're');
  Path.Add(MakeFloat(Left) + MakeFloat(Top) + MakeFloat(Width) + MakeFloat(Height) + 're');
  LastX := Left;
  //DPL-279
  //LastY := Top - Height;
  LastY := Top;
end;

procedure TPDFPainter.DrawTextArc(XPos, YPos, Radius, Angle: Double;
  const Text: AnsiString; Options: Integer);
var
  X: Integer;
  C: AnsiString;
  W: Double;
  CA: Double;
  Circumference: Double;
  AP: Double;
  Alpha: Double;
  Beta: Double;
  X1, Y1: Double;
  X2, Y2: Double;
  ReverseFactor: Integer;
  MaxC: Integer;
  CLen: Integer;
  CI: Integer;
begin
  ReverseFactor := 1;
  if Options = 1 then
    ReverseFactor := -1;
  Circumference := 2 * PI * Radius;
  AP := Angle;
  W := TextWidth(Text);
  CA := 360 * W / Circumference * ReverseFactor;
  if FTextAlign = paCenter then
    AP := Angle - (CA / 2);
  if FTextAlign = paRight then
    AP := Angle - CA;

  if FSelFont.FontType = ftCJK then
  begin
    MaxC := Length(Text) div 2;
    CLen := 2;
  end else
  begin
    MaxC := Length(Text);
    CLen := 1;
  end;
  CI := 1;
  for X := 1 to MaxC do
  begin
    C := QPLCopy(Text, CI, CLen);
    Inc(CI, CLen);
    W := TextWidth(C);
    CA := 360 * W / Circumference * ReverseFactor;
    Alpha := DegToRad(90 - AP - CA / 2);
    X1 := Radius * Cos(Alpha);
    Y1 := Radius * Sin(Alpha);
    Beta := DegToRad(90 - AP - CA / 2 + 90);
    if Options = 1 then
      Beta := DegToRad(90 - AP - CA / 2 + 90 + 180);
    X2 := W * Cos(Beta) / 2;
    Y2 := W * Sin(Beta) / 2;
//    Circle(XPos + X1, YPos + Y1, 0.5, True, False);
//    DrawLine(XPos + X1, YPos + Y1, XPos + X1 + X2, YPos + Y1 + Y2);
    if Options = 1 then
      DrawRotatedText(XPos + X1 + X2, YPos + Y1 + Y2, -AP - CA / 2 + 180, C)
    else
      DrawRotatedText(XPos + X1 + X2, YPos + Y1 + Y2, -AP - CA / 2, C);
    AP := AP + CA;
  end;
end;

procedure TPDFPainter.SetHighlightColor(Red, Green, Blue: Double);
begin
  if Red > 1 then Red := 1;
  if Red < 0 then Red := 0;
  if Green > 1 then Green := 1;
  if Green < 0 then Green := 0;
  if Blue > 1 then Blue := 1;
  if Blue < 0 then Blue := 0;
  HighlightColorLine := MakeFloat(Red) + MakeFloat(Green) + MakeFloat(Blue) + 'rg';
end;

procedure TPDFPainter.SetHighlightColor(C, M, Y, K: Double);
begin
  if C > 1 then C := 1;
  if C < 0 then C := 0;
  if M > 1 then M := 1;
  if M < 0 then M := 0;
  if Y > 1 then Y := 1;
  if Y < 0 then Y := 0;
  if K > 1 then K := 1;
  if K < 0 then K := 0;
  HighlightColorLine := MakeFloat(C) + MakeFloat(M) + MakeFloat(Y) + MakeFloat(K) + 'k';
end;

procedure TPDFPainter.SetTextWordSpacing(WordSpacing: Double);
begin
  FTextWordSpacing := WordSpacing;
  FontSpacingLine := MakeFloat(FTextCharSpacing) + 'Tc ' +
    MakeFloat(FTextWordSpacing) + 'Tw';
  FontSpacingChanged := True;
end;

procedure TPDFPainter.SetTextCharSpacing(CharSpacing: Double);
begin
  FTextCharSpacing := CharSpacing;
  FontSpacingLine := MakeFloat(FTextCharSpacing) + 'Tc ' +
    MakeFloat(FTextWordSpacing) + 'Tw';
  FontSpacingChanged := True;
end;

procedure TPDFPainter.ClearTextFormatting;
begin
  FontColorLine := '0 0 0 rg';
  FontColorChanged := True;

  FTextScaling := 100;
  FontScalingLine := '100 Tz';
  FontScalingChanged := True;

  FTextCharSpacing := 0;
  FTextWordSpacing := 0;
  FontSpacingLine := '0 Tc 0 Tw';
  FontSpacingChanged := True;

  FTextRise := 0;
  FontRiseLine := '0 Ts';
  FontRiseChanged := True;

  TextMode := 0;
  TextModeChanged := True;

  UnderlineDashOn := 0;
  UnderlineDashOff := 0;

  HighlightColorLine := '0.5 0.5 0.5 rg';
  UnderlineColorLine := '0 0 0 RG';
  UnderlineCustomDash := '';

  FTextAlign := paLeft;
  FTextSpacing := 0;
  FTextUnderline := usNone;
  FTextHighlight := hsNone;
end;

procedure TPDFPainter.SetUnderlineColor(Red, Green, Blue: Double);
begin
  if Red > 1 then Red := 1;
  if Red < 0 then Red := 0;
  if Green > 1 then Green := 1;
  if Green < 0 then Green := 0;
  if Blue > 1 then Blue := 1;
  if Blue < 0 then Blue := 0;
  UnderlineColorLine := MakeFloat(Red) + MakeFloat(Green) + MakeFloat(Blue) + 'RG';
end;

procedure TPDFPainter.SetUnderlineColor(C, M, Y, K: Double);
begin
  if C > 1 then C := 1;
  if C < 0 then C := 0;
  if M > 1 then M := 1;
  if M < 0 then M := 0;
  if Y > 1 then Y := 1;
  if Y < 0 then Y := 0;
  if K > 1 then K := 1;
  if K < 0 then K := 0;
  UnderlineColorLine := MakeFloat(C) + MakeFloat(M) + MakeFloat(Y) + MakeFloat(K) + 'K';
end;

procedure TPDFPainter.SetUnderlineDash(DashOn, DashOff: Double);
begin
  UnderlineDashOn := DashOn;
  UnderlineDashOff := DashOff;
  UnderlineCustomDash := '';
end;

procedure TPDFPainter.ChangeAll;
begin
  FontChanged := True;
  FontColorChanged := True;
  FillColorChanged := True;
  LineColorChanged := True;
  LineWidthChanged := True;
  LineDashChanged := True;
  FontScalingChanged := True;
  FontSpacingChanged := True;
  TextModeChanged := True;
  FontRiseChanged := True;
  TextAlignChanged := True;
end;

procedure TPDFPainter.Reset;
begin
  FontColorLine := '0 0 0 rg';
  FillColorLine := '1 1 1 rg';
  LineColorLine := '0 0 0 RG';
  LineWidthLine := '1 w';
  LineDashLine := '[] 0 d';
  FTextScaling := 100;
  FontScalingLine := '100 Tz';
  FTextRise := 0;
  FontRiseLine := '0 Ts';
  FTextCharSpacing := 0;
  FTextWordSpacing := 0;
  FontSpacingLine := '0 Tw 0 Tc';
  HighlightColorLine := '0.5 0.5 0.5 rg';
  UnderlineColorLine := '0 0 0 RG';
  UnderlineDashOn := 0;
  UnderlineDashOff := 0;
  TextMode := 0;
  FTextAlign := paLeft;
  FTextSpacing := 0;
  FTextUnderline := usNone;
  FTextHighlight := hsNone;
  FMetaTextAlign := 0;
  FTextAngle := 0;
  FFillMode := ALTERNATE;
end;

function TPDFPainter.GetState: AnsiString;
var
  SelFontHex: string;
begin
  SelFontHex := IntToHex(TQPLIntPtr(FSelFont), 16);
  Result := AnsiString(SelFontHex) + #9;
  Result := Result + QPLDoubleToStr(FTextSize, PDFPrecNum) + #9;
  Result := Result + FontColorLine + #9;
  Result := Result + FillColorLine + #9;
  Result := Result + LineColorLine + #9;
  Result := Result + LineWidthLine + #9;
  Result := Result + LineDashLine + #9;
  Result := Result + QPLDoubleToStr(FTextScaling, PDFPrecNum) + #9;
  Result := Result + FontScalingLine + #9;
  Result := Result + QPLDoubleToStr(FTextCharSpacing, PDFPrecNum) + #9;
  Result := Result + QPLDoubleToStr(FTextWordSpacing, PDFPrecNum) + #9;
  Result := Result + FontSpacingLine + #9;
  Result := Result + HighlightColorLine + #9;
  Result := Result + UnderlineColorLine + #9;
  Result := Result + UnderlineCustomDash + #9;
  Result := Result + QPLDoubleToStr(UnderlineDashOn, PDFPrecNum) + #9;
  Result := Result + QPLDoubleToStr(UnderlineDashOff, PDFPrecNum) + #9;
  Result := Result + QPLIntToStr(TextMode) + #9;
  Result := Result + QPLIntToStr(Ord(FTextAlign)) + #9;
  Result := Result + QPLDoubleToStr(FTextSpacing, PDFPrecNum) + #9;
  Result := Result + QPLIntToStr(Ord(FTextUnderline)) + #9;
  Result := Result + QPLIntToStr(Ord(FTextHighlight)) + #9;
  Result := Result + QPLDoubleToStr(FTextRise, PDFPrecNum) + #9;
  Result := Result + QPLDoubleToStr(FUnderlineWidth, PDFPrecNum) + #9;
  Result := Result + QPLDoubleToStr(FUnderlineDistance, PDFPrecNum) + #9;
  Result := Result + QPLIntToStr(FMetaTextAlign) + #9;
  Result := Result + QPLIntToStr(FTextAngle) + #9;
  Result := Result + QPLIntToStr(FFillMode) + #9;
end;

procedure TPDFPainter.SetState(const NewState: AnsiString);
var
  P: Integer;

  function PopStr: AnsiString;
  var
    OP: Integer;
  begin
    OP := P;
    repeat
      Inc(P);
    until NewState[P] = #9;
    Result := QPLCopy(NewState, OP + 1, P - OP - 1);
  end;

  function PopDouble: Double;
  begin
    Result := TazzToFloat(PopStr)
  end;

  function PopHex: Int64;
  begin
    Result := StrToInt64('$' + string(PopStr));
  end;

begin
  P := 0;
  FSelFont := TPDFFont(TQPLIntPtr(PopHex));
  FTextSize := PopDouble;
  SelectFont(FSelFont, FTextSize);
  FontColorLine := PopStr;
  FillColorLine := PopStr;
  LineColorLine := PopStr;
  LineWidthLine := PopStr;
  LineDashLine := PopStr;
  FTextScaling := PopDouble;
  FontScalingLine := PopStr;
  FTextCharSpacing := PopDouble;
  FTextWordSpacing := PopDouble;
  FontSpacingLine := PopStr;
  HighlightColorLine := PopStr;
  UnderlineColorLine := PopStr;
  UnderlineCustomDash := PopStr;
  UnderlineDashOn := PopDouble;
  UnderlineDashOff := PopDouble;
  TextMode := Round(PopDouble);
  FTextAlign := TPDFAlignment(Round(PopDouble));
  FTextSpacing := PopDouble;
  FTextUnderline := TPDFUnderlineStyle(Round(PopDouble));
  FTextHighlight := TPDFHighlightStyle(Round(PopDouble));
  FTextRise := PopDouble;
  FUnderlineWidth := PopDouble;
  FUnderlineDistance := PopDouble;
  FMetaTextAlign := Round(PopDouble);
  FTextAngle := Round(PopDouble);
  FFillMode := Round(PopDouble);
  ChangeAll;
end;

procedure TPDFPainter.AppendText(const Text: WideString);
var
  OldAlign: TPDFAlignment;
begin
  OldAlign := FTextAlign;
  try
    FTextAlign := paLeft;
    DrawWideText(FLastX, FLastY, Text);
  finally
    FTextAlign := OldAlign;
  end;
end;

procedure TPDFPainter.SetTextColor(const FontColor: AnsiString);
begin
  FontColorLine := FontColor;
  UnderlineColorLine := FontColor;
  FontColorChanged := True;
  FillColorChanged := True;
end;

procedure TPDFPainter.SetHighlightColor(const NewColor: AnsiString);
begin
  HighlightColorLine := NewColor;
end;

procedure TPDFPainter.SetUnderlineColor(const NewColor: AnsiString);
begin
  UnderlineColorLine := NewColor;
end;

function TPDFPainter.DrawRotatedTextBox(Left, Top, Width, Height,
  Angle: Double; const Text: AnsiString; Options: Integer; const BreakString: AnsiString): Integer;
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  PDFPrecNum := 8;
  try
    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add('1 0 0 1 ' + MakeFloat(Left) + MakeFloat(Top) + 'cm');
    Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
    try
      Result := DrawTextBox(0, 0, Width, Height, Text, Options, BreakString);
    finally
      RadAngle := DegToRad(-Angle);
      CosA := MakeFloat(Cos(RadAngle));
      SinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
      Add('1 0 0 1 ' + MakeFloat(-Left) + MakeFloat(-Top) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

function TPDFPainter.DrawRotatedWideTextBox(Left, Top, Width, Height,
  Angle: Double; const Text: WideString; Options: Integer; const BreakString: WideString): Integer;
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  PDFPrecNum := 8;
  try
    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add('1 0 0 1 ' + MakeFloat(Left) + MakeFloat(Top) + 'cm');
    Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
    try
      Result := DrawWideTextBox(0, 0, Width, Height, Text, Options, BreakString);
    finally
      RadAngle := DegToRad(-Angle);
      CosA := MakeFloat(Cos(RadAngle));
      SinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
      Add('1 0 0 1 ' + MakeFloat(-Left) + MakeFloat(-Top) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

function TPDFPainter.DrawRotatedWideTextBoxEx(Left, Top, Width, Height,
  Angle: Double; const Text: WideString; Options: Integer; const BreakString: WideString; Border, Radius: Integer; Fill, Outline: Boolean): Integer;
var
  RadAngle: Double;
  StrCosA: AnsiString;
  StrSinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  PDFPrecNum := 8;
  try
      RadAngle := DegToRad(Angle);
      StrCosA := MakeFloat(Cos(RadAngle));
      StrSinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add('1 0 0 1 ' + MakeFloat(Left) + MakeFloat(Top) + 'cm');
      Add(StrCosA + StrSinA + NegSinA + StrCosA + ' 0 0 cm');
    try
      if Border = 1 then
        Rectangle(0,0, Width, Height, Fill, Outline);
      if Border = 2 then
        RoundedRectangle(0, 0, Width, Height, Radius, Fill, Outline);
      Result := DrawWideTextBox(0, 0, Width, Height, Text, Options, BreakString);
    finally
      RadAngle := DegToRad(-Angle);
      StrCosA := MakeFloat(Cos(RadAngle));
      StrSinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(StrCosA + StrSinA + NegSinA + StrCosA + ' 0 0 cm');
      Add('1 0 0 1 ' + MakeFloat(-Left) + MakeFloat(-Top) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

function TPDFPainter.GetWrappedTextBreakString(Width: Double;
  const Text, Delimiter, BreakString: AnsiString): AnsiString;
var
  L: Integer;
  X: Integer;
  List: TQuickPDFStringList;
  Line: Integer;
  Flags: TPDFTextBlockFlags;
begin
  Result := '';
  List := TQuickPDFStringList.Create;
  try
    WordWrap(Text, List, Width, BreakString, Flags);
    L := Length(Flags);
    if L < List.Count then
    begin
      SetLength(Flags, List.Count);
      for X := L to List.Count - 1 do
      begin
        Flags[X].WordCount := 0;
        Flags[X].ForcedBreak := False;
      end;
    end;
    for Line := 0 to List.Count - 1 do
    begin
      if Flags[Line].ForcedBreak then
        Result := Result + List[Line] + BreakString + Delimiter
      else
        Result := Result + List[Line] + Delimiter;
    end;
  finally
    List.Free;
  end;
end;

function TPDFPainter.GetWrappedWideTextBreakString(Width: Double;
  const Text, Delimiter, BreakString: WideString): WideString;
var
  L: Integer;
  X: Integer;
  List: TQuickPDFStringList;
  Line: Integer;
  Flags: TPDFTextBlockFlags;
begin
  Result := '';
  List := TQuickPDFStringList.Create;
  try
    WideWordWrap(Text, List, Width, BreakString, Flags);
    L := Length(Flags);
    if L < List.Count then
    begin
      SetLength(Flags, List.Count);
      for X := L to List.Count - 1 do
      begin
        Flags[X].WordCount := 0;
        Flags[X].ForcedBreak := False;
      end;
    end;
    for Line := 0 to List.Count - 1 do
    begin
      if Flags[Line].ForcedBreak then
        Result := Result + QPLUTF8Decode(List[Line]) + BreakString + Delimiter
      else
        Result := Result + QPLUTF8Decode(List[Line]) + Delimiter;
    end;
  finally
    List.Free;
  end;
end;

procedure TPDFPainter.SetFillColor(const FillColor: AnsiString);
begin
  FillColorLine := FillColor;
  FillColorChanged := True;
  FontColorChanged := True;
end;

function TPDFPainter.LineWidthThou: Integer;
begin
  Result := Round(LineWidth * 1000);
end;

procedure TPDFPainter.SetLineColor(const LineColor: AnsiString);
begin
  LineColorLine := LineColor;
  LineColorChanged := True;
end;

procedure TPDFPainter.SetTextRise(Rise: Double);
begin
  FontRiseLine := MakeFloat(Rise) + 'Ts';
  FTextRise := Rise;
  FontRiseChanged := True;
end;

procedure TPDFPainter.SetLineDash(const LineDash: AnsiString);
begin
  LineDashLine := LineDash;
  LineDashChanged := True;
end;

function TPDFPainter.SetLineDashEx(const DashValues: AnsiString): Boolean;
var
  TempStructure: TPDFStructure;
  Obj: TPDFObject;
begin
  Result := False;
  if (DashValues = '') then
  begin
    Result := True;
    LineDashLine := '[] 0 d';
    LineDashChanged := True;
  end else
  begin
    TempStructure := TPDFStructure.Create;
    try
      Obj := TempStructure.Decode('[ ' + DashValues + ' ]');
      if (Obj is TPDFArray) then
      begin
        if (TPDFArray(Obj).AllItemsNumeric) then
        begin
          Result := True;
        end;
      end;
    finally
      TempStructure.Free;
    end;

    if (Result) then
    begin
      LineDashLine := '[ ' + DashValues + '] 0 d';
      LineDashChanged := True;
    end;
  end;
end;

function TPDFPainter.GetTextMode: Integer;
begin
  Result := TextMode;
end;

function TPDFPainter.GetLineWidth: Double;
begin
  Result := LineWidth;
end;

procedure TPDFPainter.SetUnderlineWidth(NewWidth: Double);
begin
  FUnderlineWidth := NewWidth;
end;

procedure TPDFPainter.SetUnderlineDistance(NewDistance: Double);
begin
  FUnderlineDistance := NewDistance;
end;

procedure TPDFPainter.SetFillColor(const CS: AnsiString; Tint: Double);
begin
  FillColorLine := '/' + CS + ' cs ' + MakeFloat(Tint) + 'scn';
  FillColorChanged := True;
  FontColorChanged := True;
end;

procedure TPDFPainter.SetLineColor(const CS: AnsiString; Tint: Double);
begin
  LineColorLine := '/' + CS + ' CS ' + MakeFloat(Tint) + 'SCN';
  LineColorChanged := True;
end;

procedure TPDFPainter.SetUnderlineColor(const CS: AnsiString; Tint: Double);
begin
  UnderlineColorLine := '/' + CS + ' CS ' + MakeFloat(Tint) + 'SCN';
end;

procedure TPDFPainter.SetUnderlineCustomDash(const DashPattern: AnsiString;
  DashPhase: Double);
begin
  UnderlineDashOn := 1;
  UnderlineDashOff := 1;
  UnderlineCustomDash := '[ ' + DashPattern + ' ] ' + MakeFloat(DashPhase) + 'd';
end;

procedure TPDFPainter.SetUnderlineCustomDashFull(const DashPattern: AnsiString);
begin
  UnderlineDashOn := 1;
  UnderlineDashOff := 1;
  UnderlineCustomDash := DashPattern;
end;

procedure TPDFPainter.SetHighlightColor(const CS: AnsiString; Tint: Double);
begin
  HighlightColorLine := '/' + CS + ' cs ' + MakeFloat(Tint) + 'scn';
end;

procedure TPDFPainter.SetTextColor(const CS: AnsiString; Tint: Double);
begin
  FontColorLine := '/' + CS + ' cs ' + MakeFloat(Tint) + 'scn';
  UnderlineColorLine := '/' + CS + ' cs ' + MakeFloat(Tint) + 'scn';
  FontColorChanged := True;
  FillColorChanged := True;
end;

procedure TPDFPainter.AppendSpace(Space: Double);
begin
  FLastX := FLastX + Space;
end;

procedure TPDFPainter.FitRotatedTextBox(Left, Top, Width, Height,
  Angle: Double; const Text: AnsiString; Options: Integer;
  const BreakString: AnsiString);
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  PDFPrecNum := 8;
  try
    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add('1 0 0 1 ' + MakeFloat(Left) + MakeFloat(Top) + 'cm');
    Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
    try
      FitTextBox(0, 0, Width, Height, Text, Options, BreakString);
    finally
      RadAngle := DegToRad(-Angle);
      CosA := MakeFloat(Cos(RadAngle));
      SinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
      Add('1 0 0 1 ' + MakeFloat(-Left) + MakeFloat(-Top) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

procedure TPDFPainter.FitRotatedWideTextBox(Left, Top, Width, Height,
  Angle: Double; const Text: WideString; Options: Integer;
  const BreakString: WideString);
var
  RadAngle: Double;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  OldPrec: Integer;
begin
  OldPrec := PDFPrecNum;
  PDFPrecNum := 8;
  try
    RadAngle := DegToRad(Angle);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add('1 0 0 1 ' + MakeFloat(Left) + MakeFloat(Top) + 'cm');
    Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
    try
      FitWideTextBox(0, 0, Width, Height, Text, Options, BreakString);
    finally
      RadAngle := DegToRad(-Angle);
      CosA := MakeFloat(Cos(RadAngle));
      SinA := MakeFloat(Sin(RadAngle));
      NegSinA := MakeFloat(-Sin(RadAngle));
      Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
      Add('1 0 0 1 ' + MakeFloat(-Left) + MakeFloat(-Top) + 'cm');
    end;
    RunOnChanged;
  finally
    PDFPrecNum := OldPrec;
  end;
end;

procedure TPDFPainter.Comb(Left, Top, Width, Height: Double;
  const Text: AnsiString; Blocks: Integer);
var
  Max: Integer;
  X: Integer;
  OldAlign: TPDFAlignment;
  BlockSize: Double;
begin
  OldAlign := FTextAlign;
  try
    FTextAlign := paCenter;
    BlockSize := Width / Blocks;
    if Length(Text) < Blocks then Max := Length(Text) else Max := Blocks;
    for X := 0 to Max - 1 do
      FitTextBox(Left + BlockSize * X, Top, BlockSize, Height, Text[X + 1], 0);
  finally
    FTextAlign := OldAlign;
  end;
end;

procedure TPDFPainter.WideComb(Left, Top, Width, Height: Double;
  const Text: WideString; Blocks: Integer);
var
  Max: Integer;
  X: Integer;
  OldAlign: TPDFAlignment;
  BlockSize: Double;
begin
  OldAlign := FTextAlign;
  try
    FTextAlign := paCenter;
    BlockSize := Width / Blocks;
    if Length(Text) < Blocks then Max := Length(Text) else Max := Blocks;

    if (OldAlign <> paRight) then
    begin
      for X := 0 to Max - 1 do
      begin
        FitWideTextBox(Left + BlockSize * X, Top, BlockSize, Height, Text[X + 1], 0);
      end;
    end else
    begin
      for X := 0 to Max - 1 do
      begin
        FitWideTextBox(Left + BlockSize * (X + Blocks - Max), Top, BlockSize, Height, Text[X + 1], 0);
      end;
    end;
  finally
    FTextAlign := OldAlign;
  end;
end;

procedure TPDFPainter.SetCustomLineDash(const DashArray: AnsiString);
begin
  LineDashLine := DashArray + ' d';
  LineDashChanged := True;
end;

procedure TPDFPainter.DrawDataMatrixSymbol(Left, Top, ModuleSize: Double;
  const Text: AnsiString; Encoding, SymbolSize, Options: Integer);
var
  DM: TPDFDataMatrix;
  Row: Integer;
  Col: Integer;
  XPos: Double;
  YPos: Double;
  XDeltaCol: Double;
  YDeltaCol: Double;
  XDeltaRow: Double;
  YDeltaRow: Double;
  Padding: Integer;
begin

  Padding := Options div 100;
  if (Padding >= 1) then
    Dec(Padding);

  DM := TPDFDataMatrix.Create;
  try
    DM.SymbolSize := TPDFDataMatrixSymbolSize(SymbolSize);
    DM.Encode(Text);

    AddFloat(Left - Padding * ModuleSize);
    AddFloat(Top - ((DM.Rows + Padding) * ModuleSize));
    AddFloat((DM.Cols + Padding * 2) * ModuleSize);
    AddFloat((DM.Rows + Padding * 2) * ModuleSize);

    Add('re');
    Add('1 1 1 rg');
    Add('f');

    case Options of
      1:
      begin
        XPos := Left;
        YPos := Top - ModuleSize * DM.Cols;
        XDeltaCol := 0;
        YDeltaCol := ModuleSize;
        XDeltaRow := ModuleSize;
        YDeltaRow := -ModuleSize * DM.Cols;
      end;
      2:
      begin
        XPos := Left + ModuleSize * DM.Cols;
        YPos := Top - ModuleSize * DM.Rows;
        XDeltaCol := -ModuleSize;
        YDeltaCol := 0;
        XDeltaRow := ModuleSize * DM.Cols;
        YDeltaRow := ModuleSize;
      end;
      3:
      begin
        XPos := Left + ModuleSize * DM.Rows;
        YPos := Top - ModuleSize;
        XDeltaCol := 0;
        YDeltaCol := -ModuleSize;
        XDeltaRow := -ModuleSize;
        YDeltaRow := ModuleSize * DM.Cols;
      end;
    else
      XPos := Left;
      YPos := Top - ModuleSize;
      XDeltaCol := ModuleSize;
      YDeltaCol := 0;
      XDeltaRow := -ModuleSize * DM.Cols;
      YDeltaRow := -ModuleSize;
    end;

    for Row := 1 to DM.Rows do
    begin
      for Col := 1 to DM.Cols do
      begin
        if DM.GetModule(Row, Col) then
        begin
          AddFloat(XPos);
          AddFloat(YPos);
          AddFloat(ModuleSize);
          AddFloat(ModuleSize);
          Add('re');
        end;
        XPos := XPos + XDeltaCol;
        YPos := YPos + YDeltaCol;
      end;
      XPos := XPos + XDeltaRow;
      YPos := YPos + YDeltaRow;
    end;

    Add(FillColorLine);
    Add('f');
  finally
    DM.Free;
  end;
  RunOnChanged;
end;

procedure TPDFPainter.DrawPSXObject(const PSName: AnsiString);
begin
  Add('/' + PSName + ' Do');
  RunOnChanged;
end;

function TPDFPainter.DrawQRCode(Left, Top, SymbolSize: Double;
  const Text: WideString; EncodeOptions, DrawOptions: Integer): Boolean;
var
  QRMatrix: T2DBooleanArray;
  Row: Integer;
  Col: Integer;
  XPos: Double;
  YPos: Double;
  XDeltaCol: Double;
  YDeltaCol: Double;
  XDeltaRow: Double;
  YDeltaRow: Double;
  FullWidth: Double;
  FullHeight: Double;
  VModuleSize: Double;
  Cols: Integer;
  Rows: Integer;
  ModuleSize: Double;
begin
  QRMatrix := GenerateQRCode(Text, EncodeOptions);
  Rows := Length(QRMatrix);
  Result := Rows > 0;

  if (Result) then
  begin
    Cols := Length(QRMatrix[0]);
    if (Cols = Rows) then
    begin
      ModuleSize := SymbolSize / Cols;
      VModuleSize := ModuleSize;

      case DrawOptions of
        1:
        begin
          XPos := Left;
          YPos := Top - ModuleSize * Cols;
          XDeltaCol := 0;
          YDeltaCol := ModuleSize;
          XDeltaRow := VModuleSize;
          YDeltaRow := -ModuleSize * Cols;
          FullWidth := VModuleSize * Rows;
          FullHeight := ModuleSize * Cols;
        end;
        2:
        begin
          XPos := Left + ModuleSize * (Cols - 1);
          YPos := Top - VModuleSize * Rows;
          XDeltaCol := -ModuleSize;
          YDeltaCol := 0;
          XDeltaRow := ModuleSize * Cols;
          YDeltaRow := VModuleSize;
          FullWidth := ModuleSize * Cols;
          FullHeight := VModuleSize * Rows;
        end;
        3:
        begin
          XPos := Left + VModuleSize * (Rows - 1);
          YPos := Top - ModuleSize;
          XDeltaCol := 0;
          YDeltaCol := -ModuleSize;
          XDeltaRow := -VModuleSize;
          YDeltaRow := ModuleSize * Cols;
          FullWidth := VModuleSize * Rows;
          FullHeight := ModuleSize * Cols;
        end;
      else
        XPos := Left;
        YPos := Top - VModuleSize;
        XDeltaCol := ModuleSize;
        YDeltaCol := 0;
        XDeltaRow := -ModuleSize * Cols;
        YDeltaRow := -VModuleSize;
        FullWidth := ModuleSize * Cols;
        FullHeight := VModuleSize * Rows;
      end;

      AddFloat(Left);
      AddFloat(Top);
      AddFloat(FullWidth);
      AddFloat(-FullHeight);
      Add('re');
      Add('1 1 1 rg');
      Add('f');

      for Row := 1 to Rows do
      begin
        for Col := 1 to Cols do
        begin
          if QRMatrix[Col - 1][Row - 1] then
          begin
            AddFloat(XPos);
            AddFloat(YPos);
            if (DrawOptions = 0) or (DrawOptions = 2) then
            begin
              AddFloat(ModuleSize);
              AddFloat(VModuleSize);
            end else
            begin
              AddFloat(VModuleSize);
              AddFloat(ModuleSize);
            end;
            Add('re');
          end;
          XPos := XPos + XDeltaCol;
          YPos := YPos + YDeltaCol;
        end;
        XPos := XPos + XDeltaRow;
        YPos := YPos + YDeltaRow;
      end;

      Add(FillColorLine);
      Add('f');
    end else
    begin
      Result := False;
    end;
  end;
  RunOnChanged;
end;

procedure TPDFPainter.SetHTMLTagEquivalent(const NewTag,
  ExistingTag: AnsiString);
var
  L: Integer;
begin
  L := Length(FHTMLSettings.EquivalentTags);
  SetLength(FHTMLSettings.EquivalentTags, L + 1);
  FHTMLSettings.EquivalentTags[L].S1 := NewTag;
  FHTMLSettings.EquivalentTags[L].S2 := ExistingTag;  
end;

function TPDFPainter.GetHTMLTextWidth(MaxWidth: Double;
  const HTMLText: WideString): Double;
var
  Dummy: AnsiString;
  Renderer: THTMLRenderer;
  HTMLTextA: AnsiString;
begin
  HTMLTextA := PrepareHTMLText(HTMLText);
  FHTMLSettings.Left := 0;
  FHTMLSettings.Top := 0;
  FHTMLSettings.Width := MaxWidth;
  FHTMLSettings.TextSpacing := TextSpacing;
  Renderer := THTMLRenderer.Create(Self);
  try
    Dummy := '';
    Renderer.Render(HTMLTextA, FHTMLSettings, True, 0, Dummy);
    Result := Renderer.RenderedWidth;
  finally
    Renderer.Free;
  end;
end;

function TPDFPainter.GetHTMLTextLineCount(Width: Double;
  const HTMLText: WideString): Integer;
var
  Dummy: AnsiString;
  Renderer: THTMLRenderer;
  HTMLTextA: AnsiString;
begin
  HTMLTextA := PrepareHTMLText(HTMLText);
  FHTMLSettings.Left := 0;
  FHTMLSettings.Top := 0;
  FHTMLSettings.Width := Width;
  FHTMLSettings.TextSpacing := TextSpacing;
  Renderer := THTMLRenderer.Create(Self);
  try
    Dummy := '';
    Renderer.Render(HTMLTextA, FHTMLSettings, True, 0, Dummy);
    Result := Renderer.RenderedLineCount;
  finally
    Renderer.Free;
  end;
end;

procedure TPDFPainter.SetFillShader(const CS: AnsiString);
begin
  FillColorLine := '/Pattern cs /' + CS + ' scn';
  FillColorChanged := True;
  FontColorChanged := True;
end;

procedure TPDFPainter.SetLineShader(const CS: AnsiString);
begin
  FillColorLine := '/Pattern CS /' + CS + ' SCN';
  LineColorChanged := True;
end;

procedure TPDFPainter.SetTextShader(const CS: AnsiString);
begin
  FontColorLine := '/Pattern cs /' + CS + ' scn';
  UnderlineColorLine := '/Pattern cs /' + CS + ' scn';
  FontColorChanged := True;
  FillColorChanged := True;
end;

procedure TPDFPainter.RemoveEndText;
var
  TempS: AnsiString;
begin
  SetLength(TempS, 3);
  FSourceStream.Seek(-3, soFromCurrent);
  FSourceStream.Read(TempS[1], 3);
  if TempS = 'ET'#10 then
  begin
    TempS := '  #10';
    FSourceStream.Seek(-3, soFromCurrent);
    FSourceStream.Write(TempS[1], 3);
    FSourceStream.Seek(-3, soFromCurrent);
  end else
    Add('BT');
end;

procedure TPDFPainter.BeginUpdate;
begin
  FUpdating := True;
end;

procedure TPDFPainter.EndUpdate;
begin
  FUpdating := False;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TPDFPainter.RunOnChanged;
begin
  if (not FUpdating) and Assigned(FOnChange) then FOnChange(Self);
end;

function TPDFPainter.GetHTMLLimitedTextHeight(Width, Height: Double;
  const HTMLText: WideString): Double;
var
  Dummy: AnsiString;
  Renderer: THTMLRenderer;
  HTMLTextA: AnsiString;
begin
  HTMLTextA := PrepareHTMLText(HTMLText);
  FHTMLSettings.Left := 0;
  FHTMLSettings.Top := 0;
  FHTMLSettings.Width := Width;
  FHTMLSettings.TextSpacing := TextSpacing;
  Renderer := THTMLRenderer.Create(Self);
  try
    Dummy := '';
    Result := Renderer.Render(HTMLTextA, FHTMLSettings, True, Height, Dummy);
  finally
    Renderer.Free;
  end;
end;

function TPDFPainter.GetHTMLTextHeightWithDescent(Width: Double;
  const HTMLText: WideString): Double;
var
  Dummy: AnsiString;
  Renderer: THTMLRenderer;
  HTMLTextA: AnsiString;
begin
  HTMLTextA := PrepareHTMLText(HTMLText);
  FHTMLSettings.Left := 0;
  FHTMLSettings.Top := 0;
  FHTMLSettings.Width := Width;
  FHTMLSettings.TextSpacing := TextSpacing;
  Renderer := THTMLRenderer.Create(Self);
  try
    Dummy := '';
    Result := Renderer.Render(HTMLTextA, FHTMLSettings, True, 0, Dummy) +
      Renderer.LastMaxDescent;
  finally
    Renderer.Free;
  end;
end;

procedure TPDFPainter.AbortPath;
begin
  if RipePath then
    Path.Add('n');
end;

procedure TPDFPainter.DrawShearedImage(Image: TPDFImage; Left, Top, Width, Height, ShearX, ShearY: Double);
begin
  Add('q');

  AddFloat(1);
  AddFloat(-ShearX);
  AddFloat(-ShearY);
  AddFloat(1);
  AddFloat(Left);
  AddFloat(Top - Height);
  Add('cm');

  AddFloat(Width);
  AddFloat(0);
  AddFloat(0);
  AddFloat(Height);
  AddFloat(0);
  AddFloat(0);
  Add('cm');

  Add('/' + Image.Name + ' Do');
  Add('Q');

  RunOnChanged;

  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TPDFPainter.DrawSpacedText(XPos, YPos, Angle: Double; const Text: WideString; Offsets: array of Double);
var
  TextW            : Double;
  OldLineWidth     : Double;
  OldLineColorLine : AnsiString;
  OldFillColorLine : AnsiString;
  OldLineDashLine  : AnsiString;
  KX               : Integer;
  C1               : Integer;
  S                : AnsiString;
  I                : Integer;
  RadAngle : Double;
  CosA     : AnsiString;
  SinA     : AnsiString;
  NegSinA  : AnsiString;
  PosChar : Double;
  DSinA, DCosA: Double;
  TextA: AnsiString;

begin
  FSelFont.AddToSubset(Text);

  TextW:=0;
  If Length(OffSets)>0 then
  begin
    for KX := 1 to  Length(Text) do
      TextW:=TextW+Offsets[KX-1];
  end
  else
  begin
    if (TextUnderline <> usNone)then
      FSelFont.UpdateSubsettedFont(False);  // We need the Widths updated.
    TextW := WideTextWidth(Text) - FTextCharSpacing * (FTextScaling / 100);
  end;

  DSinA := Sin((Angle)/ 10 * 3.1415926536 / 180);
  DCosA := Cos((Angle) / 10 * 3.1415926536 / 180);

  case FTextAlign of
    paCenter:
    begin
      XPos := XPos - (TextW / 2) * DCosA;
      YPos := YPos - (TextW / 2) * DSinA;
    end;

    paRight:
    begin
      XPos := XPos - TextW * DCosA;
      YPos := YPos - TextW * DSinA;
    end;
  end;

  if FTextHighlight <> hsNone then
  begin
      OldFillColorLine := FillColorLine;
      FillColorLine    := HighlightColorLine;
      FillColorChanged := True;
      if FTextHighlight = hsSquare then
          Rectangle(XPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, True, False);
      if FTextHighlight = hsRounded then
          RoundedRectangle(XPos - 0.5, YPos + TextBound(2) + FTextRise, TextW + 1, TextHeight, TextHeight / 4, True, False);

      FillColorLine    := OldFillColorLine;
      FillColorChanged := True;
      FontColorChanged := True;
  end;

  if TextModeChanged then
      Add(QPLIntToStr(TextMode) + ' Tr');
  if (TextMode = 1) or (TextMode = 2) or (TextMode = 5) or (TextMode = 6) then
  begin
      if LineColorChanged then
              Add(LineColorLine);
      if LineWidthChanged then
              Add(LineWidthLine);
      if LineDashChanged  then
              Add(LineDashLine);
      LineColorChanged := False;
      LineWidthChanged := False;
      LineDashChanged  := False;
  end;
  TextModeChanged := False;

  if FontChanged        then Add(FontLine);
  if FontColorChanged   then Add(FontColorLine);
  if FontScalingChanged then Add(FontScalingLine);
  if FontRiseChanged    then Add(FontRiseLine);
  if FontSpacingChanged then Add(FontSpacingLine);

  RemoveEndText;

  if Angle<>0 then
  begin
    RadAngle   := DegToRad(Angle/10);
    CosA       := MakeFloat(Cos(RadAngle));
    SinA       := MakeFloat(Sin(RadAngle));
    NegSinA    := MakeFloat(-Sin(RadAngle));
    Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos) + 'cm');
    Add(CosA + SinA + NegSinA + CosA + ' 0 0 cm');
  end
  else
  begin
      Add('1 0 0 1 ' + MakeFloat(XPos) + MakeFloat(YPos) + 'Tm');
  end;

  //if (FSelFont.IsEmbedded) then
  if (FSelFont.IsSubsetted) then
  begin
    if (Length(Offsets)>1) and (Text <> '')  then
    begin
      PosChar := 0;
      for KX := 1 to  Length(Text) do
      begin
        Add(MakeFloat(PosChar)+MakeFloat(0) + 'Td');

        C1 := Ord(Text[KX]);

        S := AnsiChar((C1 and $FF00) shr 8) + AnsiChar(C1 and $00FF);
        AddString(S, 'Tj');

        PosChar:=Offsets[KX-1];
      end;
    end
    else
    begin
      S := '';
      for I := 1 to Length(Text) do
      begin
        C1 := Ord(Text[I]);
        S := S + AnsiChar((C1 and $FF00) shr 8) + AnsiChar(C1 and $00FF);
      end;
      AddString(S, 'Tj');
    end;
  end
  else
  begin
    SetLength(TextA, Length(Text));
    for KX := 1 to  Length(Text) do
      TextA[KX] := AnsiChar(Text[KX]);

    if (Length(Offsets)>1) and (Text <> '')  then
    begin
      PosChar := 0;
      for KX := 1 to  Length(Text) do
      begin
        Add(MakeFloat(PosChar)+MakeFloat(0) + 'Td');
        AddString(TextA[KX], 'Tj');
        PosChar := Offsets[KX-1];
      end;
    end
    else
      AddString(TextA, 'Tj');
    end;

    Add('ET');

    FLastX := XPos + TextW; //TextWidth(Text);
    FLastY := YPos;

    FontChanged := False;
    FontColorChanged := False;
    FontScalingChanged := False;
    FontRiseChanged := False;
    FontSpacingChanged := False;
    if FTextUnderline <> usNone then
    begin
        OldLineColorLine := LineColorLine;
        OldLineDashLine  := LineDashLine;
        OldLineWidth     := LineWidth;
        LineColorLine    := UnderlineColorLine;

        if (QPLPos('[Bold', FSelFont.FontName) <> 0) then
          SetLineWidth(0.8 * FTextSize / 10)
        else
          SetLineWidth(0.4 * FTextSize / 10);

        LineColorChanged := True;
        if (UnderlineDashOn = 0) or (UnderlineDashOff = 0) then
        begin
            if LineDashLine <> '[] 0 d' then
                LineDashLine := '[] 0 d';
        end
        else
            SetLineDash(UnderlineDashOn * LineWidth, UnderlineDashOff * LineWidth);
        LineDashChanged := True;

        if (FTextUnderline = usSingle) or (FTextUnderline = usDouble) then
            DrawLine(XPos, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance,
                XPos + TextW, YPos - FTextSize * 12.5 / 100 - FUnderlineDistance);
        if FTextUnderline = usDouble then
            DrawLine(XPos, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2,
                XPos + TextW, YPos - FTextSize * 25 / 100 - FUnderlineDistance * 2);
        if (FTextUnderline = usStrikeout) then
            DrawLine(XPos, YPos + FTextSize * 0.3 + FUnderlineDistance,
                XPos + TextW, YPos + FTextSize * 0.3 + FUnderlineDistance);
        if (FTextUnderline = usOver) then
            DrawLine(XPos, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance,
                XPos + TextW, YPos + TextAscent + FTextSize * 12.5 / 100 + FUnderlineDistance);
        SetLineWidth(OldLineWidth);
        LineDashLine     := OldLineDashLine;
        LineDashChanged  := True;
        LineColorLine    := OldLineColorLine;
        LineColorChanged := True;
    end;
  If Angle<>0 then
  begin
    RadAngle := DegToRad(-Angle/10);
    CosA := MakeFloat(Cos(RadAngle));
    SinA := MakeFloat(Sin(RadAngle));
    NegSinA := MakeFloat(-Sin(RadAngle));
    Add(CosA + SinA + NegSinA + CosA + ' ' +
                MakeFloat(0) + MakeFloat(0) + 'cm');
    Add('1 0 0 1 ' + MakeFloat(-XPos) + MakeFloat(-YPos) + 'cm');
  end;
    if Assigned(FOnChange) then
        FOnChange(Self);
end;

procedure TPDFPainter.RoundedRect(Left, Top, Width, Height,
  Radius1 , Radius2: Double; Fill, Outline: Boolean);
var
  Kappa: Double;
  XPos: Double;
  YPos: Double;
begin
  if Radius1>Width / 2  then
      Radius1:=Width / 2;
  if Radius2>Height / 2  then
      Radius2:=Height / 2;
  Kappa := (Sqrt(2) - 1) / 3 * 4;
  Add(LineColorLine);
  Add(FillColorLine);
  Add(LineWidthLine);
  if LineDashChanged then
    Add(LineDashLine);

  XPos := Left + Radius1;
  YPos := Top - Height + Radius2;
  AddFloat(XPos - Radius1);
  AddFloat(YPos);
  Add('m');
  AddFloat(XPos - Radius1);
  AddFloat(YPos - Radius2 * Kappa);
  AddFloat(XPos - Radius1 * Kappa);
  AddFloat(YPos - Radius2);
  AddFloat(XPos);
  AddFloat(YPos - Radius2);
  Add('c');

  XPos := Left + Width - Radius1;
  YPos := Top - Height + Radius2;
  AddFloat(Left + Width - Radius1);
  AddFloat(Top - Height);
  Add('l');

  AddFloat(XPos + Radius1 * Kappa);
  AddFloat(YPos - Radius2);
  AddFloat(XPos + Radius1);
  AddFloat(YPos - Radius2 * Kappa);
  AddFloat(XPos + Radius1);
  AddFloat(YPos);
  Add('c');

  XPos := Left + Width - Radius1;
  YPos := Top - Radius2;
  AddFloat(Left + Width);
  AddFloat(Top - Radius2);
  Add('l');

  AddFloat(XPos + Radius1);
  AddFloat(YPos + Radius2 * Kappa);
  AddFloat(XPos + Radius1 * Kappa);
  AddFloat(YPos + Radius2);
  AddFloat(XPos);
  AddFloat(YPos + Radius2);
  Add('c');

  XPos := Left + Radius1;
  YPos := Top - Radius2;
  AddFloat(Left + Radius1);
  AddFloat(Top);
  Add('l');

  AddFloat(XPos - Radius1 * Kappa);
  AddFloat(YPos + Radius2);
  AddFloat(XPos - Radius1);
  AddFloat(YPos + Radius2 * Kappa);
  AddFloat(XPos - Radius1);
  AddFloat(YPos);
  Add('c');

  AddFloat(Left);
  AddFloat(Top - Height + Radius2);
  Add('l');

  if Fill and (not Outline) then Add('f');
  if Outline and (not Fill) then Add('S');
  if Outline and Fill then Add('B');
  if (not Fill) and (not Outline) then Add('n');
  if Assigned(FOnChange) then FOnChange(Self);

  LineDashChanged := False;
  FontColorChanged := True;
end;

procedure TPDFPainter.SetFillPattern(const CS: AnsiString);
begin
  FillColorLine :=  '/Pattern cs /' + CS + ' scn';
  FillColorChanged := True;
end;

procedure TPDFPainter.SetMiterLimit(NewMiterLimit: Double);
begin
  MiterLimit := NewMiterLimit;
  LineWidthLine := MakeFloat(MiterLimit) + 'M ' +
    MakeFloat(LineWidth) + 'w ' + QPLIntToStr(LineCap) + ' J ' +
    QPLIntToStr(LineJoin) + ' j';
  LineWidthChanged := True;
end;

procedure TPDFPainter.HideLineProperties;
begin
  FillColorChanged := False;
  LineColorChanged := False;
  LineWidthChanged := False;
  LineDashChanged := False;
end;

{ TPDFCapturedPage }

procedure TPDFCapturedPage.SetTransparencyGroup(const CS: AnsiString;
  IsolateFlag, KnockoutFlag: Boolean);
var
  GroupDict: TPDFDictionary;
  Obj: TPDFObject;
  XObjectDict: TPDFDictionary;
begin
  Obj := XObject.Obj;
  if (Obj is TPDFStream) then
  begin
    XObjectDict := TPDFStream(Obj).Dictionary;
    Obj := XObjectDict.FindValueByKeyName('Group', True);
    if (Obj is TPDFDictionary) then
    begin
      GroupDict := TPDFDictionary(Obj);
    end else
    begin
      GroupDict := XObjectDict.Owner.NewDictionary;
      XObjectDict.Add('Group', GroupDict);
    end;
    GroupDict.Add('Type', XObjectDict.Owner.NewName('Group'));
    GroupDict.Add('S', XObjectDict.Owner.NewName('Transparency'));
    GroupDict.Add('CS', XObjectDict.Owner.NewName(CS));
    GroupDict.Add('I', XObjectDict.Owner.NewBoolean(IsolateFlag));
    GroupDict.Add('K', XObjectDict.Owner.NewBoolean(KnockoutFlag));
  end;
end;

end.
