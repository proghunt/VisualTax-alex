{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryHTMLRender.pas                         }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryHTMLRender;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, SysUtils, DebenuPDFLibraryPainter, DebenuPDFLibraryExtra;

type
  THTMLElement = class
    Position: Integer;
    function Output: AnsiString; virtual; abstract;
  end;

  THTMLTag = class(THTMLElement)
  public
    TagType: AnsiString;
    Attributes: TQuickPDFStringList;
    constructor Create; virtual;
    destructor Destroy; override;
    function Output: AnsiString; override;
  end;

  THTMLWords = class(THTMLElement)
  public
    Words: TQuickPDFStringList;
    constructor Create; virtual;
    destructor Destroy; override;
    function Output: AnsiString; override;
  end;

  THTMLParser = class
  public
    IsWide: Boolean;
    Elements: array of THTMLElement;
    HTMLTextInput: AnsiString;
    procedure NewTagElement(const Source: AnsiString; Position: Integer);
    procedure NewWideTagElement(const Source: AnsiString; Position: Integer);
    procedure NewWordsElement(const Source: AnsiString; Position: Integer);
    procedure NewWideWordsElement(const Source: AnsiString; Position: Integer);
    procedure Parse(const Input: AnsiString);
    procedure WideParse(const Input: AnsiString);
    procedure Init;
    destructor Destroy; override;
  end;

  THTMLRenderer = class
  private
    FPainter: TPDFPainter;
    FParser: THTMLParser;
    FRenderedWidth: Double;
    FRenderedLineCount: Integer;
    FLastMaxDescent: Double;    
    function WideTrim(const Source: AnsiString): AnsiString;
    function ToWide(const Source: AnsiString): WideString;
  public
    constructor Create(Painter: TPDFPainter);
    destructor Destroy; override;
    function Render(const HTMLText: AnsiString; Settings: THTMLSettings;
      Test: Boolean; MaxHeight: Double; var Extra: AnsiString): Double;
    property RenderedWidth: Double read FRenderedWidth;
    property RenderedLineCount: Integer read FRenderedLineCount;
    property LastMaxDescent: Double read FLastMaxDescent;    
  end;

const
  ColorConstants: array[1..140, 1..2] of AnsiString = (
    ('aliceblue','F0F8FF'), ('antiquewhite','FAEBD7'), ('aqua','00FFFF'),
    ('aquamarine','7FFFD4'), ('azure','F0FFFF'), ('beige','F5F5DC'),
    ('bisque','FFE4C4'), ('black','000000'), ('blanchedalmond','FFEBCD'),
    ('blue','0000FF'), ('blueviolet','8A2BE2'), ('brown','A52A2A'),
    ('burlywood','DEB887'), ('cadetblue','5F9EA0'), ('chartreuse','7FFF00'),
    ('chocolate','D2691E'), ('coral','FF7F50'), ('cornflowerblue','6495ED'),
    ('cornsilk','FFF8DC'), ('crimson','DC143C'), ('cyan','00FFFF'),
    ('darkblue','00008B'), ('darkcyan','008B8B'), ('darkgoldenrod','B8860B'),
    ('darkgray','A9A9A9'), ('darkgreen','006400'), ('darkkhaki','BDB76B'),
    ('darkmagenta','8B008B'), ('darkolivegreen','556B2F'), ('darkorange','FF8C00'),
    ('darkorchid','9932CC'), ('darkred','8B0000'), ('darksalmon','E9967A'),
    ('darkseagreen','8FBC8F'), ('darkslateblue','483D8B'), ('darkslategray','2F4F4F'),
    ('darkturquoise','00CED1'), ('darkviolet','9400D3'), ('deeppink','FF1493'),
    ('deepskyblue','00BFFF'), ('dimgray','696969'), ('dodgerblue','1E90FF'),
    ('firebrick','B22222'), ('floralwhite','FFFAF0'), ('forestgreen','228B22'),
    ('fuchsia','FF00FF'), ('gainsboro','DCDCDC'), ('ghostwhite','F8F8FF'),
    ('gold','FFD700'), ('goldenrod','DAA520'), ('gray','808080'), ('green','008000'),
    ('greenyellow','ADFF2F'), ('honeydew','F0FFF0'), ('hotpink','FF69B4'),
    ('indianred','CD5C5C'), ('indigo','4B0082'), ('ivory','FFFFF0'),
    ('khaki','F0E68C'), ('lavender','E6E6FA'), ('lavenderblush','FFF0F5'),
    ('lawngreen','7CFC00'), ('lemonchiffon','FFFACD'), ('lightblue','ADD8E6'),
    ('lightcoral','F08080'), ('lightcyan','E0FFFF'), ('lightgoldenrodyellow','FAFAD2'),
    ('lightgreen','90EE90'), ('lightgrey','D3D3D3'), ('lightpink','FFB6C1'),
    ('lightsalmon','FFA07A'), ('lightseagreen','20B2AA'), ('lightskyblue','87CEFA'),
    ('lightslategray','778899'), ('lightsteelblue','B0C4DE'), ('lightyellow','FFFFE0'),
    ('lime','00FF00'), ('limegreen','32CD32'), ('linen','FAF0E6'), ('magenta','FF00FF'),
    ('maroon','800000'), ('mediumaquamarine','66CDAA'), ('mediumblue','0000CD'),
    ('mediumorchid','BA55D3'), ('mediumpurple','9370DB'), ('mediumseagreen','3CB371'),
    ('mediumslateblue','7B68EE'), ('mediumspringgreen','00FA9A'), ('mediumturquoise','48D1CC'),
    ('mediumvioletred','C71585'), ('midnightblue','191970'), ('mintcream','F5FFFA'),
    ('mistyrose','FFE4E1'), ('moccasin','FFE4B5'), ('navajowhite','FFDEAD'),
    ('navy','000080'), ('oldlace','FDF5E6'), ('olive','808000'), ('olivedrab','6B8E23'),
    ('orange','FFA500'), ('orangered','FF4500'), ('orchid','DA70D6'),
    ('palegoldenrod','EEE8AA'), ('palegreen','98FB98'), ('paleturquoise', 'AFEEEE'), ('palevioletred','DB7093'),
    ('papayawhip','FFEFD5'), ('peachpuff','FFDAB9'), ('peru','CD853F'),
    ('pink','FFC0CB'), ('plum','DDA0DD'), ('powderblue','B0E0E6'), ('purple','800080'),
    ('red','FF0000'), ('rosybrown','BC8F8F'), ('royalblue','4169E1'),
    ('saddlebrown','8B4513'), ('salmon','FA8072'), ('sandybrown','F4A460'),
    ('seagreen','2E8B57'), ('seashell','FFF5EE'), ('sienna','A0522D'),
    ('silver','C0C0C0'), ('skyblue','87CEEB'), ('slateblue','6A5ACD'),
    ('slategray','708090'), ('snow','FFFAFA'), ('springgreen','00FF7F'),
    ('steelblue','4682B4'), ('tan','D2B48C'), ('teal','008080'), ('thistle','D8BFD8'),
    ('tomato','FF6347'), ('turquoise','40E0D0'), ('violet','EE82EE'), ('wheat','F5DEB3'),
    ('white','FFFFFF'), ('whitesmoke','F5F5F5'), ('yellow','FFFF00'), ('yellowgreen','9ACD32'));

implementation

uses
  DebenuPDFLibraryFont, DebenuPDFLibraryPageTree, DebenuPDFLibraryTypes;

function FindHTMLColor(const IC: AnsiString): AnsiString;
var
  X: Integer;
  LC: AnsiString;
  TC: AnsiString;
  SX, EX: Integer;
  MX: Integer;
  J: Integer;
  FI: Integer;
begin
  LC := QPLLowerCase(QPLTrim(IC));
  if (Length(LC) > 0) and (LC[1] >= 'a') and (LC[1] <= 'z') then
  begin
    SX := 1;
    EX := Length(ColorConstants);
    J := 0;
    FI := 0;
    repeat
      Inc(J);
      MX := SX + (EX - SX) div 2;
      if (ColorConstants[SX, 1] = LC) then
      begin
        FI := SX;
      end else
      if (ColorConstants[MX, 1] = LC) then
      begin
        FI := MX;
      end else
      if (ColorConstants[EX, 1] = LC) then
      begin
        FI := EX;
      end else
      begin
        TC := ColorConstants[MX, 1];
        if LC > TC then
        begin
          SX := MX + 1;
        end else
        begin
          EX := MX - 1;
        end;
      end;
    until (FI > 0) or (J = 3);
    if FI = 0 then
    begin
      X := SX;
      repeat
        TC := ColorConstants[X, 1];
        if LC = TC then FI := X;
        X := X + 1;
      until (X > EX) or (FI > 0);
    end;
    if FI > 0 then Result := '##' + ColorConstants[FI, 2] else Result := IC;
  end else
    Result := IC;
end;

{ THTMLParser }

destructor THTMLParser.Destroy;
var
  X: Integer;
begin
  for X := 0 to Length(Elements) - 1 do
    Elements[X].Free;
  SetLength(Elements, 0);
end;

procedure THTMLParser.Init;
var
  X: Integer;
begin
  for X := 0 to Length(Elements) - 1 do
    Elements[X].Free;
  SetLength(Elements, 0);
end;

procedure THTMLParser.NewTagElement(const Source: AnsiString; Position: Integer);
var
  S: AnsiString;
  A: AnsiString;
  PD: Integer;
  PS: Integer;
  PE: Integer;
  TE: THTMLTag;
begin
  TE := THTMLTag.Create;
  TE.Position := Position;
  SetLength(Elements, Length(Elements) + 1);
  Elements[Length(Elements) - 1] := TE;
  PS := QPLPos(' ', Source);
  if PS = 0 then
  begin
    TE.TagType := QPLLowerCase(QPLCopy(Source, 2, Length(Source) - 2));
    if QPLCopy(TE.TagType, Length(TE.TagType), 1) = '/' then
      Delete(TE.TagType, Length(TE.TagType), 1);
  end else
  begin
    TE.TagType := QPLLowerCase(QPLCopy(Source, 2, PS - 2));
    S := QPLCopy(Source, Length(TE.TagType) + 3, MaxInt);
    Delete(S, Length(S), 1);
    S := QPLTrim(S) + ' ';
    PE := QPLPos('=', S);
    while PE > 0 do
    begin
      PS := QPLPos(' ', S);
      PD := QPLPos('"', S);
      if PD <> PE + 1 then
      begin
        A := QPLCopy(S, 1, PS - 1);
        Delete(S, 1, PS);
        S := QPLTrim(S) + ' ';
      end else
      begin
        S[PD] := #255;
        PD := QPLPos('"', S);
        A := QPLCopy(S, 1, PD);
        PD := QPLPos(#255, A);
        A[PD] := '"';
        Delete(S, 1, Length(A));
        S := QPLTrim(S) + ' ';
      end;
      if (TE.TagType = 'a') then
        TE.Attributes.Add(A)
      else
        TE.Attributes.Add(QPLLowerCase(A));

      PE := QPLPos('=', S);
    end;
  end;
end;

procedure THTMLParser.NewWideTagElement(const Source: AnsiString;
  Position: Integer);
var
  S: AnsiString;
  X: Integer;
  HasUnicode: Boolean;
  WS: WideString;
begin
  S := '';

  // Check for Unicode characters, encode them with UTF-8
  HasUnicode := False;
  for X := 1 to Length(Source) div 2 do
    if (Source[X * 2 - 1] <> #0) then HasUnicode := True;

  if (HasUnicode) then
  begin
    SetLength(WS, Length(Source) div 2);
    for X := 1 to Length(Source) div 2 do
    begin
      WS[X] := WideChar(Ord(Source[X * 2 - 1]) * 256 + Ord(Source[X * 2]));
    end;
    S := QPLUTF8Encode(WS);
  end else
  begin
    for X := 1 to Length(Source) div 2 do
      S := S + Source[X * 2];
  end;
  NewTagElement(S, Position);
end;

procedure THTMLParser.NewWideWordsElement(const Source: AnsiString;
  Position: Integer);
var
  P: Integer;
  S: AnsiString;
  TE: THTMLWords;
  EndSpace: Boolean;
  TS: AnsiString;
begin
  TE := THTMLWords.Create;
  TE.Position := Position;
  SetLength(Elements, Length(Elements) + 1);
  Elements[Length(Elements) - 1] := TE;
  S := Source;
  P := -1;
  repeat
    Inc(P, 2);
    TS := QPLCopy(S, P, 2);
    if TS = #0#9 then
    begin
      S[P + 1] := ' ';
    end else
    if TS = #0#10 then
    begin
      S[P + 1] := ' ';
    end else
    if TS = #0#13 then
    begin
      S[P + 1] := ' ';
    end else
    begin
      TS := QPLCopy(S, P, 4);
      if TS = #0' '#0' ' then
      begin
        Delete(S, P, 2);
      end else
      begin
        TS := QPLCopy(S, P, 8);
        if TS = #0'&'#0'l'#0't'#0';' then
        begin
          S[P + 1] := '<';
          Delete(S, P + 2, 6);
        end else
        if TS = #0'&'#0'g'#0't'#0';' then
        begin
          S[P + 1] := '>';
          Delete(S, P + 2, 6);
        end else
        begin
          TS := QPLCopy(S, P, 12);
          if TS = #0'&'#0'n'#0'b'#0's'#0'p'#0';' then
          begin
            S[P + 1] := #160;            
            Delete(S, P + 2, 10);
          end;
        end;
      end;
    end;
  until P >= (Length(S) - 1);
  if QPLCopy(S, 1, 2) = #0' ' then
  begin
    TE.Words.Add('');
    Delete(S, 1, 2);
  end;
  EndSpace := QPLCopy(S, Length(S) - 1, 2) = #0' ';
  P := QPLPos(#0' ', S);
  while P > 0 do
  begin
    TE.Words.Add(QPLCopy(S, 1, P - 1));
    Delete(S, 1, P + 1);
    P := QPLPos(#0' ', S);
  end;
  if Length(S) > 0 then TE.Words.Add(S);
  if EndSpace then TE.Words.Add('');
end;

procedure THTMLParser.NewWordsElement(const Source: AnsiString; Position: Integer);
var
  P: Integer;
  S: AnsiString;
  TE: THTMLWords;
  EndSpace: Boolean;
begin
  TE := THTMLWords.Create;
  TE.Position := Position;
  SetLength(Elements, Length(Elements) + 1);
  Elements[Length(Elements) - 1] := TE;
  S := QPLStringReplace(Source, #13, ' ', [rfReplaceAll]);
  S := QPLStringReplace(S, #10, ' ', [rfReplaceAll]);
  S := QPLStringReplace(S, #9, ' ', [rfReplaceAll]);
  S := QPLStringReplace(S, '&lt;', '<', [rfReplaceAll]);
  S := QPLStringReplace(S, '&gt;', '>', [rfReplaceAll]);    
  while QPLPos('  ', S) > 0 do
    S := QPLStringReplace(S, '  ', ' ', [rfReplaceAll]);
  if QPLCopy(S, 1, 1) = ' ' then
  begin
    TE.Words.Add('');
    Delete(S, 1, 1);
  end;
  EndSpace := QPLCopy(S, Length(S), 1) = ' ';
  P := QPLPos(' ', S);
  while P > 0 do
  begin
    TE.Words.Add(QPLCopy(S, 1, P - 1));
    Delete(S, 1, P);
    P := QPLPos(' ', S);
  end;
  if Length(S) > 0 then TE.Words.Add(S);
  if EndSpace then TE.Words.Add('');
end;

procedure THTMLParser.Parse(const Input: AnsiString);
var
  P1: Integer;
begin
  if (QPLCopy(Input, 1, 22) =
    #0'<'#0's'#0't'#0'a'#0'c'#0'k'#0'>'#0'<'#0'!'#0'-'#0'-') then
  begin
    IsWide := True;
    P1 := QPLPos(#0'<'#0'/'#0's'#0't'#0'a'#0'c'#0'k'#0'>', Input);
    if P1 > 0 then
      WideParse(QPLCopy(Input, P1 + 16, MaxInt));
  end else
  if (QPLCopy(Input, 1, 24) = #$FE#$FF +
    #0'<'#0's'#0't'#0'a'#0'c'#0'k'#0'>'#0'<'#0'!'#0'-'#0'-') then
  begin
    IsWide := True;
    P1 := QPLPos(#0'<'#0'/'#0's'#0't'#0'a'#0'c'#0'k'#0'>', Input);
    if P1 > 0 then
      WideParse(QPLCopy(Input, P1 + 16, MaxInt));
  end else
  begin
    IsWide := True;
    WideParse(Input);
  end;
end;

procedure THTMLParser.WideParse(const Input: AnsiString);
var
  P1: Integer;
  P2: Integer;
  S: AnsiString;
  Offset: Integer;
begin
  Offset := 1;
  S := Input;
  repeat
    P1 := QPLPos(#0'<', S);
    P2 := QPLPos(#0'>', S);
    if (P2 > P1) and (P1 <> 0) and (P2 <> 0) then
    begin
      if P1 = 1 then
      begin
        NewWideTagElement(QPLCopy(S, 1, P2 + 1), Offset);
        Delete(S, 1, P2 + 1);
        Offset := Offset + P2 + 1;
      end else
      begin
        NewWideWordsElement(QPLCopy(S, 1, P1 - 1), Offset);
        Delete(S, 1, P1 - 1);
        Offset := Offset + P1 - 1;
      end;
    end;
    if (P2 < P1) then
    begin
      NewWideWordsElement(QPLCopy(S, 1, P1 - 1), Offset);
      Delete(S, 1, P1 - 1);
      Offset := Offset + P1 - 1;
    end;
    if (P1 = 0) or (P2 = 0) then
    begin
      NewWideWordsElement(S, Offset);
      Offset := Offset + Length(S);
      S := '';
    end;
  until Length(S) = 0;
  HTMLTextInput := Input;
end;

{ THTMLTag }

constructor THTMLTag.Create;
begin
  Attributes := TQuickPDFStringList.Create;
end;

destructor THTMLTag.Destroy;
begin
  Attributes.Free;
  inherited;
end;

function THTMLTag.Output: AnsiString;
var
  X: Integer;
begin
  Result := '<' + TagType;
  if Attributes.Count > 0 then
  for X := 0 to Attributes.Count - 1 do
    Result := Result + ' ' + Attributes[X];
  Result := Result + '>';
end;

{ THTMLWords }

constructor THTMLWords.Create;
begin
  Words := TQuickPDFStringList.Create;
end;

destructor THTMLWords.Destroy;
begin
  Words.Free;
  inherited;
end;

function THTMLWords.Output: AnsiString;
var
  X: Integer;
begin
  Result := '';
  for X := 0 to Words.Count - 1 do
  begin
    Result := Result + Words[X];
    if X < (Words.Count - 1) then Result := Result + ' ';
  end;
end;

{ THTMLRenderer }

constructor THTMLRenderer.Create(Painter: TPDFPainter);
begin
  FPainter := Painter;
  FParser := THTMLParser.Create;
end;

destructor THTMLRenderer.Destroy;
begin
  FParser.Free;
  inherited;
end;

function THTMLRenderer.ToWide(const Source: AnsiString): WideString;
var
  X: Integer;
begin
  SetLength(Result, Length(Source) div 2);
  for X := 1 to Length(Source) div 2 do
  begin
    Result[X] := WideChar(Ord(Source[X * 2 - 1]) shl 8 + Ord(Source[X * 2]));
  end;
end;

type
  THTMLTextBlock = record
    AFont: TPDFFont;
    ASize: Double;
    AText: AnsiString;
    AXPos: Double;
    AYPos: Double;
    AWidth: Double;
    AColor: AnsiString;
    Underlined: TPDFUnderlineStyle;
    ABackColor: AnsiString;
    AFlags: Cardinal;
    ASpacing: Double;
    SoftHyphen: Boolean;
    StyleExtra: AnsiString;
  end;

  THTMLStackItem = record
    AFont: TPDFFont;
    ASize: Double;
    AColor: AnsiString;
    ABackColor: AnsiString;
    Underlined: TPDFUnderlineStyle;
    AFlags: Cardinal;
    ASpacing: Double;
    StyleExtra: AnsiString;
  end;

  THTMLList = (hlNone, hlOrdered, hlUnordered);

function THTMLRenderer.Render(const HTMLText: AnsiString; Settings: THTMLSettings;
  Test: Boolean; MaxHeight: Double; var Extra: AnsiString): Double;
var
  X: Integer;
  AX: Integer;
  AV: AnsiString;
  TE: THTMLElement;
  XPos: Double;
  YPos: Double;
  WX: Integer;
  ThisWord: AnsiString;
  ThisBlock: AnsiString;
  StartParagraph: Boolean;
  FirstParagraph: Boolean;
  LineTextBlocks: array of THTMLTextBlock;
  LineAlign: TPDFAlignment;
  Flags: Cardinal;
  Stack: array of THTMLStackItem;
  MaxDescent: Double;
  TooBig: Boolean;
  EndSpaceWidth: Double;
  TempStack: THTMLStackItem;
  ExtraWide: AnsiString;
  ExtraWideX: Integer;
  EX: Integer;
  TestWord: AnsiString;
  InList: THTMLList;
  Indent: Double;
  NeedsBullet: Boolean;
  BulletIndex: Integer;
  LastSetColor: AnsiString;
  FStyleExtra: AnsiString;

  function PersistStack: AnsiString;
  var
    X: Integer;
    S: AnsiString;
  begin
    Result := '<stack><!--';
    Result := Result + QPLFormatFloat('00000000', Length(Stack));
    for X := 0 to Length(Stack) - 1 do
    begin
      Result := Result + QPLIntToHex(TQPLIntPtr(Stack[X].AFont), SizeOf(TQPLIntPtr) * 2);
      Result := Result + QPLPaddedDouble(Stack[X].ASize, 8, 3);
      Result := Result + Stack[X].AColor;
      S := Stack[X].ABackColor;
      if S = '' then S := '        ';
      Result := Result + S;

      S := ' ';
      case Stack[X].Underlined of
        usNone: S := 'N';
        usSingle: S := 'U';
        usDouble: S := 'D';
        usStrikeout: S := 'S';
        usOver: S := 'O';
      end;
      Result := Result + S;

      Result := Result + QPLIntToHex(Stack[X].AFlags, 8);
    end;

    S := ' ';
    if LineAlign = paLeft then S := 'L';
    if LineAlign = paRight then S := 'R';
    if LineAlign = paCenter then S := 'C';
    if LineAlign = paJustified then S := 'J';
    if LineAlign = paForceJustified then S := 'F';
    if LineAlign = paLastJustified then S := 'T';
    Result := Result + S;

    S := ' ';
    case InList of
      hlNone: S := 'N';
      hlOrdered: S := 'O';
      hlUnordered: S := 'U';
    end;
    Result := Result + S;

    Result := Result + '--></stack>';
  end;

  procedure RecoverStartList(ListType: THTMLList);
  begin
    XPos := Settings.Left + Indent;
    BulletIndex := 1;
    InList := ListType;
    if (ListType = hlOrdered) then
    begin
      Indent := 20 * FPainter.TextSize / 12;
    end else
    begin
      Indent := 15 * FPainter.TextSize / 12;
    end;
    NeedsBullet := True;
  end;

  procedure RecoverStack;
  var
    P1, P2: Integer;
    S: AnsiString;
    X: Integer;
    C: Integer;
    St: AnsiString;
  begin
    S := '';

    P1 := QPLPos('<stack><!--', HTMLText);
    P2 := QPLPos('--></stack>', HTMLText);
    if (P1 > 0) and (P2 > 0) and (P2 > P1) then
    begin
      S := QPLCopy(HTMLText, P1 + 11, P2 - P1 - 11);
    end;

    P1 := QPLPos(#0'<'#0's'#0't'#0'a'#0'c'#0'k'#0'>'#0'<'#0'!'#0'-'#0'-', HTMLText);
    P2 := QPLPos(#0'-'#0'-'#0'>'#0'<'#0'/'#0's'#0't'#0'a'#0'c'#0'k'#0'>', HTMLText);
    if (S = '') and (P1 > 0) and (P2 > 0) and (P2 > P1) then
    begin
      St := QPLCopy(HTMLText, P1 + 22, P2 - P1 - 22);
      for C := 1 to Length(St) div 2 do
        S := S + St[C * 2];
    end;

    if S <> '' then
    begin
      C := QPLStrToIntDef(QPLCopy(S, 1, 8), 0);
      Delete(S, 1, 8);
      for X := 1 to C do
      begin
        if Length(S) >= (33 + SizeOf(TQPLIntPtr) * 2) then
        begin
          SetLength(Stack, Length(Stack) + 1);
          with Stack[Length(Stack) - 1] do
          begin
            AFont := TPDFFont(QPLStrToIntDef('$' + QPLCopy(S, 1, SizeOf(TQPLIntPtr) * 2), 0));
            Delete(S, 1, SizeOf(TQPLIntPtr) * 2);
            try
              ASize := TazzToFloat(QPLCopy(S, 1, 8));
            except
              ASize := 0;
            end;
            Delete(S, 1, 8);
            AColor := QPLTrim(QPLCopy(S, 1, 8));
            Delete(S, 1, 8);            
            ABackColor := QPLTrim(QPLCopy(S, 1, 8));
            Delete(S, 1, 8);            
            Underlined := usNone;
            if QPLCopy(S, 1, 1) = 'U' then Underlined := usSingle;
            if QPLCopy(S, 1, 1) = 'D' then Underlined := usDouble;
            if QPLCopy(S, 1, 1) = 'S' then Underlined := usStrikeout;
            if QPLCopy(S, 1, 1) = 'O' then Underlined := usOver;
            Delete(S, 1, 1);
            AFlags := QPLStrToIntDef('$' + QPLCopy(S, 1, 8), 0);
            Delete(S, 1, 8);
          end;
        end;
      end;
      if QPLCopy(S, 1, 1) = 'L' then LineAlign := paLeft;
      if QPLCopy(S, 1, 1) = 'R' then LineAlign := paRight;
      if QPLCopy(S, 1, 1) = 'C' then LineAlign := paCenter;
      if QPLCopy(S, 1, 1) = 'J' then LineAlign := paJustified;
      if QPLCopy(S, 1, 1) = 'F' then LineAlign := paForceJustified;
      if QPLCopy(S, 1, 1) = 'T' then LineAlign := paLastJustified;
      Delete(S, 1, 1);
      //if QPLCopy(S, 1, 1) = 'N' then InList := hlNone;
      if QPLCopy(S, 1, 1) = 'O' then RecoverStartList(hlOrdered);
      if QPLCopy(S, 1, 1) = 'U' then RecoverStartList(hlUnordered);
      Delete(S, 1, 1);
    end;
  end;

  procedure SetColor(const AColor: AnsiString);
  var
    PP: AnsiString;
    C: Cardinal;
  begin
    LastSetColor := AColor;
    PP := FindHTMLColor(AColor);
    if Length(PP) = 8 then
    begin
      if QPLCopy(PP, 1, 2) = '##' then
      begin
        C := QPLStrToIntDef('$' + QPLCopy(PP, 3, 6), 0);
        FPainter.SetTextColor(((C and $FF0000) shr 16) / 255,
          ((C and $FF00) shr 8) / 255, (C and $FF) / 255);
      end else
      begin
        FPainter.SetTextColor(QPLStrToIntDef('$' + QPLCopy(PP, 1, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 3, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 5, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 7, 2), 0) / 255);
      end;
    end else
      FPainter.SetTextColor(0, 0, 0);
  end;

  procedure SetBackColor(const AColor: AnsiString);
  var
    PP: AnsiString;
    C: Cardinal;
  begin
    PP := FindHTMLColor(AColor);
    if Length(PP) = 8 then
    begin
      if QPLCopy(PP, 1, 2) = '##' then
      begin
        C := QPLStrToIntDef('$' + QPLCopy(PP, 3, 6), 0);
        FPainter.SetFillColor(((C and $FF0000) shr 16) / 255,
          ((C and $FF00) shr 8) / 255, (C and $FF) / 255);
      end else
      begin
        FPainter.SetFillColor(QPLStrToIntDef('$' + QPLCopy(PP, 1, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 3, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 5, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 7, 2), 0) / 255);
      end;
    end else
      FPainter.SetFillColor(0, 0, 0);
  end;

  procedure SetStyleExtra(const ExtraType, ExtraValue: AnsiString);
  var
    P1: Integer;
    P2: Integer;
  begin
    P1 := QPLPos('<' + ExtraType + '>', FStyleExtra);
    if P1 > 0 then
    begin
      P2 := QPLPos('</' + ExtraType + '>', FStyleExtra);
      if P2 > 0 then
        Delete(FStyleExtra, P1, P2 - P1 + 3 + Length(ExtraType));
    end;
    FStyleExtra := '<' + ExtraType + '>' + ExtraValue + '</' + ExtraType + '>';
  end;

  function GetStyleExtra(const SExtra, ExtraType: AnsiString): AnsiString;
  var
    P: Integer;
  begin
    P := QPLPos('<' + ExtraType + '>', SExtra);
    if P > 0 then
    begin
      Result := QPLCopy(SExtra, P + Length(ExtraType) + 2, MaxInt);
      P := QPLPos('</' + ExtraType + '>', Result);
      if P > 0 then
      begin
        Delete(Result, P, MaxInt);
      end else
        Result := '';
    end else
      Result := '';
  end;

  procedure SetLineColor(const AColor: AnsiString);
  var
    PP: AnsiString;
    C: Cardinal;
  begin
    PP := FindHTMLColor(AColor);
    if Length(PP) = 8 then
    begin
      if QPLCopy(PP, 1, 2) = '##' then
      begin
        C := QPLStrToIntDef('$' + QPLCopy(PP, 3, 6), 0);
        FPainter.SetLineColor(((C and $FF0000) shr 16) / 255,
          ((C and $FF00) shr 8) / 255, (C and $FF) / 255);
      end else
      begin
        FPainter.SetLineColor(QPLStrToIntDef('$' + QPLCopy(PP, 1, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 3, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 5, 2), 0) / 255,
          QPLStrToIntDef('$' + QPLCopy(PP, 7, 2), 0) / 255);
      end;
    end else
      FPainter.SetLineColor(0, 0, 0);
  end;

  procedure DrawLine;
  var
    Block: Integer;
    Offset: Double;
    LineWidth: Double;
    Max: Integer;
    OldFont: TPDFFont;
    OldSize: Double;
    MaxHeight: Double;
    BaseLine: Double;
    ExtraSpace: Double;
    CharExtraSpace: Double;
    WordCount: Integer;
    FullLine: AnsiString;
    BulletStr: AnsiString;
    RX: Integer;
    RL: Integer;
    LinkTo: AnsiString;
    LinkPage: Integer;
    LinkPosition: Double;
  begin
    MaxHeight := 0;
    MaxDescent := 0;
    FLastMaxDescent := MaxDescent;
    OldFont := FPainter.SelFont;
    OldSize := FPainter.TextSize;
    Offset := 0;
    ExtraSpace := 0;
    CharExtraSpace := 0;

    LineWidth := 0;
    Max := Length(LineTextBlocks) - 1;

    if (Max >= 0) and (LineTextBlocks[Max].AText = '') then
    begin
      SetLength(LineTextBlocks, Max);
      Dec(Max);
    end;

    if (Max >= 0) and LineTextBlocks[Max].SoftHyphen then
    begin
      if FParser.IsWide then
      begin
        LineTextBlocks[Max].AText := LineTextBlocks[Max].AText + #0'-';
        LineTextBlocks[Max].AWidth := LineTextBlocks[Max].AWidth + FPainter.WideTextWidth('-');
      end else
      begin
        LineTextBlocks[Max].AText := LineTextBlocks[Max].AText + '-';
        LineTextBlocks[Max].AWidth := LineTextBlocks[Max].AWidth + FPainter.WideTextWidth('-');
      end;
    end;

    for Block := 0 to Max do
    begin
      with LineTextBlocks[Block] do
      begin
        FPainter.SelectFont(AFont, ASize);
        FPainter.SetTextSpacing(ASpacing);
        if AText <> '' then
        begin
          if FPainter.TextHeight > MaxHeight then MaxHeight := FPainter.TextHeight;
          if Abs(FPainter.TextBound(4)) > MaxDescent then
          begin
            MaxDescent := Abs(FPainter.TextBound(4));
            FLastMaxDescent := MaxDescent;
          end;
        end;

        if (Block = Max) and (QPLCopy(AText, Length(AText), 1) = ' ') then
        begin
          if FParser.IsWide then
            Delete(AText, Length(AText) - 1, 2)
          else
            Delete(AText, Length(AText), 1);
          AWidth := FPainter.WideTextWidth(ToWide(AText));
        end;
        LineWidth := LineWidth + AWidth;
      end;
    end;
    if LineWidth > FRenderedWidth then FRenderedWidth := LineWidth;
    if LineAlign = paCenter then
      Offset := (Settings.Width - LineWidth) / 2;
    if LineAlign = paRight then
      Offset := Settings.Width - LineWidth;
    if (LineAlign = paJustified) or (LineAlign = paForceJustified) or (LineAlign = paLastJustified) then
    begin
      ExtraSpace := Settings.Width - LineWidth;
      for Block := 0 to Length(LineTextBlocks) - 1 do
        FullLine := FullLine + LineTextBlocks[Block].AText;

      WordCount := CountAnsiWideSpaces(FullLine);

      if WordCount = 1 then
      begin
        if Length(FullLine) > 1 then
          CharExtraSpace := ExtraSpace / (Length(FullLine) / 2)
        else
          CharExtraSpace := 0;
        ExtraSpace := 0;
      end else
      if WordCount > 1 then
        ExtraSpace := ExtraSpace / WordCount
      else
        ExtraSpace := 0;
    end;
    if MaxHeight > 0 then Inc(FRenderedLineCount);
    BaseLine := MaxHeight - MaxDescent;
    YPos := YPos - MaxHeight - FPainter.TextSpacing;

    for Block := 0 to Length(LineTextBlocks) - 1 do
    begin
      with LineTextBlocks[Block] do
      begin
        FPainter.SelectFont(AFont, ASize);
        FPainter.SetTextSpacing(ASpacing);
        FPainter.TextAlign := paLeft;
        FPainter.SetTextScaling(100);
        FPainter.SetTextRise(0);
        SetColor(AColor);
        SetBackColor(ABackColor);
        FPainter.TextUnderline := Underlined;
        FPainter.SetTextWordSpacing(ExtraSpace);
        FPainter.SetTextCharSpacing(CharExtraSpace);

        AFont.AddToSubset(ToWide(AText));
        AFont.UpdateSubsettedFont(false);

        if ABackColor <> '' then
        begin
          if AFlags and 1 = 1 then
            FPainter.RoundedRectangle(Offset + AXPos, AYPos,
              FPainter.WideTextWidth(ToWide(AText)), MaxHeight, MaxHeight / 3, True, False)
          else
            FPainter.Rectangle(Offset + AXPos, AYPos,
              FPainter.WideTextWidth(ToWide(AText)), MaxHeight, True, False);
        end;
        if AFlags and 2 = 2 then
        begin
          FPainter.UnderlineWidth := (ASize * 3 / 2) * 6.25 / 100;
          FPainter.UnderlineDistance := (ASize * 3 / 2) * 12.5 / 100 * (1 / 3);
          FPainter.SetTextRise(ASize * 2 / 3);
        end;
        if AFlags and 4 = 4 then
        begin
          FPainter.SetTextRise(-ASize / 3);
          FPainter.UnderlineDistance := ASize / 3;
        end;

        if Assigned(FPainter.Parent) then
        begin
          LinkTo := GetStyleExtra(StyleExtra, 'link');
          if QPLCopy(LinkTo, 1, 5) = 'page:' then
          begin
            LinkPosition := TPDFPageTree(FPainter.Parent).PageHeight;
            Delete(LinkTo, 1, 5);
            if QPLPos(',', LinkTo) > 0 then
            begin
              LinkPosition := TazzToFloat(QPLCopy(LinkTo, QPLPos(',', LinkTo) + 1, MaxInt));
              Delete(LinkTo, QPLPos(',', LinkTo), MaxInt);
            end;
            LinkPage := QPLStrToIntDef(LinkTo, 0);
            if (LinkPage > 0) and (not Test) then
            begin
              TPDFPageTree(FPainter.Parent).AddLinkToPage(Offset + AXPos, AYPos,
                FPainter.WideTextWidth(ToWide(AText)), MaxHeight, LinkPage, LinkPosition, 0);
            end;
          end else
          if (QPLCopy(LinkTo, 1, 5) = 'http:') or (QPLCopy(LinkTo, 1, 6) = 'https:') then
          begin
            if (not Test) then
            begin
              TPDFPageTree(FPainter.Parent).AddLinkToWeb(Offset + AXPos, AYPos,
                FPainter.WideTextWidth(ToWide(AText)), MaxHeight, LinkTo, 0);
            end;
          end else
          if (QPLStartsWith(LinkTo, 'file:///')) then
          begin
            if (not Test) then
            begin
              TPDFPageTree(FPainter.Parent).AddLinkToLocalFile(Offset + AXPos, AYPos,
                FPainter.WideTextWidth(ToWide(AText)), MaxHeight, QPLUTF8Decode(QPLCopy(LinkTo, 9, MaxInt)), 0);
            end;
          end else
          if (QPLStartsWith(LinkTo, 'file://')) then
          begin
            if (not Test) then
            begin
              TPDFPageTree(FPainter.Parent).AddLinkToLocalFile(Offset + AXPos, AYPos,
                FPainter.WideTextWidth(ToWide(AText)), MaxHeight, QPLUTF8Decode(QPLCopy(LinkTo, 8, MaxInt)), 0);
            end;
          end else
          if (QPLStartsWith(LinkTo, 'file:')) then
          begin
            if (not Test) then
            begin
              TPDFPageTree(FPainter.Parent).AddLinkToLocalFile(Offset + AXPos, AYPos,
                FPainter.WideTextWidth(ToWide(AText)), MaxHeight, QPLUTF8Decode(QPLCopy(LinkTo, 6, MaxInt)), 0);
            end;
          end;
        end;

        if not Test then
        begin
          FPainter.DrawWideText(Offset + AXPos, AYPos - BaseLine, ToWide(AText));
          if NeedsBullet then
          begin
            NeedsBullet := False;
            if FParser.IsWide then
            begin
              if InList = hlUnordered then
              begin
                FPainter.DrawWideText(Offset + AXPos - FPainter.WideTextWidth(ToWide(#0' '#0' ' + #$20#$22)),
                  AYPos - BaseLine, ToWide(#$20#$22));
              end;
              if InList = hlOrdered then
              begin
                BulletStr := QPLIntToStr(BulletIndex) + '.';
                RL := Length(BulletStr);
                for RX := 1 to RL do
                  Insert(#0, BulletStr, RX * 2 - 1);
                FPainter.DrawWideText(Offset + AXPos - FPainter.WideTextWidth(ToWide(#0' ')) -
                  FPainter.WideTextWidth(ToWide(BulletStr)),
                  AYPos - BaseLine, ToWide(BulletStr));
                Inc(BulletIndex);
              end;
            end else
            begin
              if InList = hlUnordered then
              begin
                FPainter.DrawText(Offset + AXPos - FPainter.WideTextWidth('  ' + #149),
                  AYPos - BaseLine, '•');
              end;
              if InList = hlOrdered then
              begin
                BulletStr := QPLIntToStr(BulletIndex) + '.';
                FPainter.DrawText(Offset + AXPos - FPainter.WideTextWidth(' ') -
                  FPainter.WideTextWidth(ToWide(BulletStr)),
                  AYPos - BaseLine, BulletStr);
                Inc(BulletIndex);
              end;
            end;
          end;
        end;

        if (LineAlign = paJustified) or (LineAlign = paForceJustified) or (LineAlign = paLastJustified) then
          Offset := Offset + ExtraSpace * CountAnsiWideSpaces(AText) +
            CharExtraSpace * (Length(AText) - 1);
        FPainter.TextUnderline := usNone;
        FPainter.TextHighlight := hsNone;
        FPainter.SetTextWordSpacing(0);
        FPainter.SetTextCharSpacing(0);
      end;
    end;
    SetLength(LineTextBlocks, 0);
    FPainter.SelectFont(OldFont, OldSize);
  end;

  function LastStyleExtra: AnsiString;
  begin
    Result := Stack[Length(Stack) - 1].StyleExtra;
  end;

  procedure Push(AFont: TPDFFont; ASize: Double; AColor, ABackColor: AnsiString; Underlined: TPDFUnderlineStyle; Flags: Cardinal; ASpacing: Double; const NewStyleExtra: AnsiString = '');
  var
    LS: AnsiString;
  begin
    if Length(Stack) > 0 then
      LS := LastStyleExtra
    else
      LS := '';
    SetLength(Stack, Length(Stack) + 1);
    Stack[Length(Stack) - 1].AFont := AFont;
    Stack[Length(Stack) - 1].ASize := ASize;
    Stack[Length(Stack) - 1].AColor := AColor; //Copy(AColor + '00000000', 1, 8);
    Stack[Length(Stack) - 1].Underlined := Underlined;
    Stack[Length(Stack) - 1].ABackColor := ABackColor;
    Stack[Length(Stack) - 1].AFlags := Flags;
    Stack[Length(Stack) - 1].ASpacing := ASpacing;    
    if NewStyleExtra = '' then
      Stack[Length(Stack) - 1].StyleExtra := LS
    else
      Stack[Length(Stack) - 1].StyleExtra := NewStyleExtra;
  end;

  function LastFont: TPDFFont;
  begin
    Result := Stack[Length(Stack) - 1].AFont;
  end;

  function LastSpacing: Double;
  begin
    Result := Stack[Length(Stack) - 1].ASpacing;
  end;

  function LastSize: Double;
  begin
    Result := Stack[Length(Stack) - 1].ASize;
  end;

  function LastColor: AnsiString;
  begin
    Result := Stack[Length(Stack) - 1].AColor;
  end;

  function LastUnderlined: TPDFUnderlineStyle;
  begin
    Result := Stack[Length(Stack) - 1].Underlined;
  end;

  function LastBackColor: AnsiString;
  begin
    Result := Stack[Length(Stack) - 1].ABackColor;
  end;

  function LastFlags: Cardinal;
  begin
    Result := Stack[Length(Stack) - 1].AFlags;
  end;

  procedure Pop;
  begin
    if Length(Stack) > 1 then
      SetLength(Stack, Length(Stack) - 1);
    FPainter.SelectFont(LastFont, LastSize);
    SetColor(LastColor);
    SetBackColor(LastBackColor);
    Flags := LastFlags;
    FStyleExtra := LastStyleExtra;
  end;

  procedure StartList(ListType: THTMLList);
  begin
    DrawLine;
    XPos := Settings.Left + Indent;
    BulletIndex := 1;
    InList := ListType;
    if (ListType = hlOrdered) then
    begin
      Indent := 20 * FPainter.TextSize / 12;
    end else
    begin
      Indent := 15 * FPainter.TextSize / 12;
    end;
    NeedsBullet := True;
  end;

  procedure EndList;
  begin
    DrawLine;
    InList := hlNone;
    Indent := 0;
    XPos := Settings.Left + Indent;
  end;

begin
  Indent := 0;
  InList := hlNone;
  FRenderedWidth := 0;
  FRenderedLineCount := 0;
  if MaxHeight < 0.1 then MaxHeight := 999999;
  FParser.Init;
  FParser.Parse(HTMLText);
  for EX := 0 to Length(Settings.EquivalentTags) - 1 do
  begin
    for X := 0 to Length(FParser.Elements) - 1 do
    begin
      if (FParser.Elements[X] is THTMLTag) and
        (THTMLTag(FParser.Elements[X]).TagType = Settings.EquivalentTags[EX].S1) then
        begin
          AV := Settings.EquivalentTags[EX].S2;
          while QPLPos(':', AV) > 0 do
          begin
            ThisBlock := QPLCopy(AV, QPLPos(':', AV) + 1, MaxInt);
            if QPLPos(':', ThisBlock) > 0 then
              Delete(ThisBlock, QPLPos(':', ThisBlock), MaxInt);
            THTMLTag(FParser.Elements[X]).Attributes.Add(ThisBlock);
            Delete(AV, QPLPos(':', AV), Length(ThisBlock) + 1);
          end;
          THTMLTag(FParser.Elements[X]).TagType := AV;
        end;
    end;
  end;

  LineAlign := paLeft;
  Push(Settings.NormalFont, 10, '##000000', '', usNone, 0, 0);
  RecoverStack;
  FPainter.SelectFont(LastFont, LastSize);
  SetColor(LastColor);
  SetBackColor(LastBackColor);

  Extra := '';
  XPos := Settings.Left + Indent;
  YPos := Settings.Top;
  FirstParagraph := True;
  StartParagraph := False;
  SetLength(LineTextBlocks, 0);
  X := 0;
  while X < Length(FParser.Elements) do
  begin
    TE := FParser.Elements[X];
    if Assigned(TE) then
    begin
      if TE is THTMLTag then with TE as THTMLTag do
      begin
        StartParagraph := (TagType = 'p') or (TagType = '/p');
        if (TagType = 'b') or (TagType = 'strong') then
        begin
          if LastFont = Settings.NormalFont then
            FPainter.SelectFont(Settings.BoldFont, LastSize)
          else
          if LastFont = Settings.ItalicFont then
            FPainter.SelectFont(Settings.BoldItalicFont, LastSize);
          Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, LastUnderlined, LastFlags, LastSpacing);
        end;
        if (TagType = '/b') or (TagType = '/strong') then
        begin
          Pop;
        end;
        if (TagType = 'i') or (TagType = 'em') then
        begin
          if LastFont = Settings.NormalFont then
            FPainter.SelectFont(Settings.ItalicFont, LastSize)
          else
          if LastFont = Settings.BoldFont then
            FPainter.SelectFont(Settings.BoldItalicFont, LastSize);
          Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, LastUnderlined, LastFlags, LastSpacing);
        end;
        if (TagType = '/i') or (TagType = '/em') then
        begin
          Pop;
        end;
        if (TagType = 'span') then
        begin
          TempStack.AFont := LastFont;
          TempStack.ASize := LastSize;
          TempStack.AColor := LastColor;
          TempStack.ABackColor := LastBackColor;
          TempStack.Underlined := LastUnderlined;
          TempStack.AFlags := LastFlags;
          TempStack.ASpacing := LastSpacing;
          for AX := 0 to Attributes.Count - 1 do
          begin
            AV := Attributes[AX];
            if QPLCopy(AV, 1, 11) = 'background=' then
            begin
              Delete(AV, 1, 11);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLCopy(AV, 1, 1) = '#' then AV := '#' + AV;
              //AV := QPLCopy(AV + '00000000', 1, 8);
              SetBackColor(AV);
              TempStack.ABackColor := AV;
            end;
            if QPLCopy(AV, 1, 10) = 'roundback=' then
            begin
              Delete(AV, 1, 10);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLLowerCase(AV) = 'yes' then Flags := Flags or 1;
              TempStack.AFlags := Flags;
            end;
          end;
          Push(TempStack.AFont, TempStack.ASize, TempStack.AColor,
            TempStack.ABackColor, TempStack.Underlined, TempStack.AFlags, TempStack.ASpacing);
        end;
        if (TagType = '/span') then
        begin
          Pop;
        end;
        if (TagType = 'a') then
        begin
          TempStack.AFont := LastFont;
          TempStack.ASize := LastSize;
          TempStack.AColor := LastColor;
          TempStack.ABackColor := LastBackColor;
          TempStack.Underlined := LastUnderlined;
          TempStack.AFlags := LastFlags;
          TempStack.ASpacing := LastSpacing;          
          TempStack.StyleExtra := LastStyleExtra; 
          for AX := 0 to Attributes.Count - 1 do
          begin
            AV := Attributes[AX];
            if QPLCopy(AV, 1, 5) = 'href=' then
            begin
              Delete(AV, 1, 5);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              SetStyleExtra('link', AV);
              TempStack.StyleExtra := FStyleExtra;
            end;
          end;
          Push(TempStack.AFont, TempStack.ASize, TempStack.AColor,
            TempStack.ABackColor, TempStack.Underlined, TempStack.AFlags,
            TempStack.ASpacing, TempStack.StyleExtra);
        end;
        if (TagType = '/a') then
        begin
          Pop;
        end;
        if (TagType = 'sup') and (Flags and 2 <> 2) then
        begin
          TempStack.AFont := LastFont;
          TempStack.ASize := LastSize * 2 / 3;
          FPainter.SelectFont(LastFont, TempStack.ASize);          
          TempStack.AColor := LastColor;
          TempStack.ABackColor := LastBackColor;
          TempStack.Underlined := LastUnderlined;
          TempStack.ASpacing := LastSpacing;
          Flags := Flags or 2;
          TempStack.AFlags := Flags;
          Push(TempStack.AFont, TempStack.ASize, TempStack.AColor,
            TempStack.ABackColor, TempStack.Underlined, TempStack.AFlags,
            TempStack.ASpacing);
        end;
        if (TagType = '/sup') then
        begin
          Pop;
        end;
        if (TagType = 'sub') and (Flags and 4 <> 4) then
        begin
          TempStack.AFont := LastFont;
          TempStack.ASize := LastSize * 2 / 3;
          FPainter.SelectFont(LastFont, TempStack.ASize);
          TempStack.AColor := LastColor;
          TempStack.ABackColor := LastBackColor;
          TempStack.Underlined := LastUnderlined;
          TempSTack.ASpacing := LastSpacing;
          Flags := Flags or 4;
          TempStack.AFlags := Flags;
          Push(TempStack.AFont, TempStack.ASize, TempStack.AColor,
            TempStack.ABackColor, TempStack.Underlined, TempStack.AFlags,
            TempStack.ASpacing);
        end;
        if (TagType = '/sub') then
        begin
          Pop;
        end;
        if (TagType = 'u') then
        begin
          if Attributes.IndexOf('style="double"') >= 0 then
            Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, usDouble, LastFlags, LastSpacing)
          else if Attributes.IndexOf('style=double') >= 0 then
            Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, usDouble, LastFlags, LastSpacing)
          else if Attributes.IndexOf('style="strikeout"') >= 0 then
            Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, usStrikeout, LastFlags, LastSpacing)
          else if Attributes.IndexOf('style=strikeout') >= 0 then
            Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, usStrikeout, LastFlags, LastSpacing)
          else if Attributes.IndexOf('style="over"') >= 0 then
            Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, usOver, LastFlags, LastSpacing)
          else if Attributes.IndexOf('style=over') >= 0 then
            Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, usOver, LastFlags, LastSpacing)
          else
            Push(FPainter.SelFont, LastSize, LastColor, LastBackColor, usSingle, LastFlags, LastSpacing);
        end;
        if (TagType = '/u') then
          Pop;
        if TagType = 'p' then
        begin
          DrawLine;
          XPos := Settings.Left + Indent;
          if not FirstParagraph then
            YPos := YPos - LastSize / 2;
          FirstParagraph := False;
          LineAlign := paLeft;
          for AX := 0 to Attributes.Count - 1 do
          begin
            AV := Attributes[AX];
            if QPLCopy(AV, 1, 6) = 'align=' then
            begin
              Delete(AV, 1, 6);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if AV = 'right' then LineAlign := paRight;
              if AV = 'justified' then LineAlign := paJustified;
              if AV = 'center' then LineAlign := paCenter;
              if AV = 'forcejustified' then LineAlign := paForceJustified;
              if AV = 'lastjustified' then LineAlign := paLastJustified;
            end else
            if QPLCopy(AV, 1, 8) = 'spacing=' then
            begin
              Delete(AV, 1, 8);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLCopy(AV, Length(AV) - 1, 2) = 'pt' then
              begin
                Delete(AV, Length(AV) - 1, 2);
                AV := QPLTrim(AV);
                FPainter.SetTextSpacing(TazzToFloat(AV));
                Push(LastFont, LastSize, LastColor, LastBackColor,
                  LastUnderlined, LastFlags, TazzToFloat(AV));
              end;
            end;
          end;
        end;
        if TagType = '/p' then
        begin
          if LineAlign = paJustified then
            LineAlign := paLeft;
          DrawLine;
          LineAlign := paLeft;
          XPos := Settings.Left + Indent;
          FirstParagraph := False;
        end;
        if (TagType = 'isqpsbr') then
        begin
          if (Attributes.IndexOf('hyphen=true') >= 0) or
            (Attributes.IndexOf('hyphen="true"') >= 0) then
          begin
            if (Length(LineTextBlocks) > 0) and (X < Length(FParser.Elements) - 1) then
            begin
              TestWord := LineTextBlocks[Length(LineTextBlocks) - 1].AText;
              if QPLCopy(TestWord, Length(TestWord), 1) <> ' ' then
              begin
                if (FParser.Elements[X + 1]) is THTMLWords then
                begin
                  if THTMLWords(FParser.Elements[X + 1]).Words.Count > 0 then
                  begin
                    TestWord := THTMLWords(FParser.Elements[X + 1]).Words[0];
                    if TestWord <> '' then
                    begin
                      LineTextBlocks[Length(LineTextBlocks) - 1].SoftHyphen := True
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
        if (TagType = 'br') then
        begin
          if (X > 0) and (FParser.Elements[X - 1] is THTMLTag) and
            (THTMLTag(FParser.Elements[X - 1]).TagType = 'br') then
          begin
            SetLength(LineTextBlocks, 1);
            LineTextBlocks[0].AFont := LastFont;
            LineTextBlocks[0].ASize := LastSize;
            LineTextBlocks[0].AXPos := XPos;
            LineTextBlocks[0].AYPos := YPos;
            LineTextBlocks[0].AWidth := 0;
            LineTextBlocks[0].AColor := LastColor;
            LineTextBlocks[0].ABackColor := LastBackColor;
            LineTextBlocks[0].AFlags := LastFlags;
            LineTextBlocks[0].AText := ' ';
            LineTextBlocks[0].SoftHyphen := False;
          end;
          if (Attributes.IndexOf('hyphen=true') >= 0) or
            (Attributes.IndexOf('hyphen="true"') >= 0) then
          begin
            if (Length(LineTextBlocks) > 0) and (X < Length(FParser.Elements) - 1) then
            begin
              TestWord := LineTextBlocks[Length(LineTextBlocks) - 1].AText;
              if QPLCopy(TestWord, Length(TestWord), 1) <> ' ' then
              begin
                if (FParser.Elements[X + 1]) is THTMLWords then
                begin
                  if THTMLWords(FParser.Elements[X + 1]).Words.Count > 0 then
                  begin
                    TestWord := THTMLWords(FParser.Elements[X + 1]).Words[0];
                    if TestWord <> '' then
                    begin
                      LineTextBlocks[Length(LineTextBlocks) - 1].SoftHyphen := True
                    end;
                  end;
                end;
              end;
            end;
          end;
          if LineAlign = paJustified then
          begin
            LineAlign := paLeft;
            DrawLine;
            LineAlign := paJustified;
          end else
          if LineAlign = paLastJustified then
          begin
            LineAlign := paLeft;
            DrawLine;
            LineAlign := paLastJustified;
          end else
            DrawLine;
          XPos := Settings.Left + Indent;
        end;
        if TagType = 'font' then
        begin
          TempStack.AFont := LastFont;
          TempStack.ASize := LastSize;
          TempStack.AColor := LastColor;
          TempStack.ABackColor := LastBackColor;
          TempStack.Underlined := LastUnderlined;
          TempStack.AFlags := LastFlags;
          TempStack.ASpacing := LastSpacing;
          for AX := 0 to Attributes.Count - 1 do
          begin
            AV := Attributes[AX];
            if QPLCopy(AV, 1, 5) = 'size=' then
            begin
              Delete(AV, 1, 5);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLCopy(AV, Length(AV) - 1, 2) = 'pt' then
              begin
                Delete(AV, Length(AV) - 1, 2);
                AV := QPLTrim(AV);
                FPainter.SelectFont(LastFont, TazzToFloat(AV));
              end else
                FPainter.SelectFont(LastFont, (TazzToFloat(AV) + 1) * 2);
              TempStack.ASize := FPainter.TextSize;
            end;
            if QPLCopy(AV, 1, 6) = 'color=' then
            begin
              Delete(AV, 1, 6);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLCopy(AV, 1, 1) = '#' then AV := '#' + AV;
              //AV := QPLCopy(AV + '00000000', 1, 8);
              SetColor(AV);
              TempStack.AColor := AV;
            end;
            if QPLCopy(AV, 1, 11) = 'background=' then
            begin
              Delete(AV, 1, 11);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLCopy(AV, 1, 1) = '#' then AV := '#' + AV;
              //AV := QPLCopy(AV + '00000000', 1, 8);
              SetBackColor(AV);
              TempStack.ABackColor := AV;
            end;
            if QPLCopy(AV, 1, 10) = 'roundback=' then
            begin
              Delete(AV, 1, 10);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLLowerCase(AV) = 'yes' then Flags := Flags or 1;
              TempStack.AFlags := Flags;
            end;
            if QPLCopy(AV, 1, 5) = 'mode=' then
            begin
              Delete(AV, 1, 5);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if (AV >= '0') and (AV <= '7') then
              begin
                FPainter.SetTextMode(QPLStrToIntDef(AV, 0));
              end;
            end;
            if QPLCopy(AV, 1, 13) = 'outlinecolor=' then
            begin
              Delete(AV, 1, 13);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLCopy(AV, 1, 1) = '#' then AV := '#' + AV;
              SetLineColor(AV);
            end;
            if QPLCopy(AV, 1, 13) = 'outlinewidth=' then
            begin
              Delete(AV, 1, 13);
              if QPLCopy(AV, 1, 1) = '"' then AV := QPLCopy(AV, 2, Length(AV) - 2);
              if QPLCopy(AV, Length(AV) - 1, 2) = 'pt' then
              begin
                Delete(AV, Length(AV) - 1, 2);
                AV := QPLTrim(AV);
                FPainter.SetLineWidth(TazzToFloat(AV));
              end;
            end;
          end;
          Push(TempStack.AFont, TempStack.ASize, TempStack.AColor,
            TempStack.ABackColor, TempStack.Underlined, TempStack.AFlags,
            TempStack.ASpacing);
        end;
        if TagType = '/font' then
        begin
          Pop;
        end;
        if TagType = 'ul' then StartList(hlUnordered);
        if TagType = '/ul' then EndList;
        if TagType = 'ol' then StartList(hlOrdered);
        if TagType = '/ol' then EndList;
        if TagType = 'li' then
        begin
          if InList = hlNone then
            StartList(hlUnordered);
          DrawLine;
          NeedsBullet := True;
          XPos := Settings.Left + Indent;
        end;
      end;
      if (TE is THTMLWords) and (THTMLWords(TE).Words.Count > 0) then with TE as THTMLWords do
      begin

        // Add all the words in one font subset operation to improve speed.
        ThisWord := '';
        for WX := 0 to Words.Count - 1 do
          ThisWord := ThisWord + Words[WX];

        FPainter.SelFont.AddToSubset(ToWide(ThisWord));

        // Now draw the blocks
        WX := 0;
        ThisBlock := '';
        TooBig := False;
        repeat
          if FParser.IsWide then
          begin
            ThisWord := WideTrim(Words[WX]);
            ThisWord := QPLStringReplace(ThisWord, #0'&'#0'n'#0'b'#0's'#0'p'#0';',
              #0#160, [rfReplaceAll]);
          end else
          begin
            ThisWord := QPLTrim(Words[WX]);
            ThisWord := QPLStringReplace(ThisWord, '&nbsp;', #160, [rfReplaceAll]);
          end;

          if (XPos = Settings.Left) and (ThisWord = '') then
          begin

          end else
          begin
            if StartParagraph and (ThisWord = '') then
            begin
              StartParagraph := False;
            end else
            begin
              if WX < Words.Count - 1 then
              begin
                if FParser.IsWide then
                begin
                  ThisWord := ThisWord + #0' ';
                  EndSpaceWidth := FPainter.WideTextWidth(' ');
                end else
                begin
                  ThisWord := ThisWord + ' ';
                  EndSpaceWidth := FPainter.WideTextWidth(' ');
                end;
              end else
                EndSpaceWidth := 0;
              ThisBlock := ThisBlock + ThisWord;
              if (Length(ThisBlock) > 1) and (XPos + FPainter.WideTextWidth(ToWide(ThisBlock)) -
                EndSpaceWidth > (Settings.Left + Settings.Width)) then
              begin
                SetLength(LineTextBlocks, Length(LineTextBlocks) + 1);
                with LineTextBlocks[Length(LineTextBlocks) - 1] do
                begin
                  Underlined := LastUnderlined;
                  AFont := FPainter.SelFont;
                  ASize := FPainter.TextSize;
                  AColor := LastColor;
                  ABackColor := LastBackColor;
                  AFlags := LastFlags;
                  ASpacing := LastSpacing;
                  StyleExtra := LastStyleExtra;
                  SoftHyphen := False;
                  if FParser.IsWide then
                  begin
                    if ((QPLPos(#0' ', ThisBlock) = 0) or (QPLPos(#0' ', ThisBlock) = (Length(ThisBlock) - 1))) and (XPos = Settings.Left) then
                    begin
                      Words.Insert(WX + 1, '');
                      repeat
                        Words[WX + 1] := QPLCopy(ThisBlock, Length(ThisBlock) - 1, 2) + Words[WX + 1];
                        Delete(ThisBlock, Length(ThisBlock) - 1, 2);
                      until (Length(ThisBlock) = 2) or ((XPos +
                        FPainter.WideTextWidth(ToWide(ThisBlock))) <=
                        (Settings.Left + Settings.Width));
                      AText := ThisBlock;
                    end else
                    begin
                      AText := QPLCopy(ThisBlock, 1, Length(ThisBlock) - Length(ThisWord));
                      WX := WX - 1;
                    end;
                    if QPLCopy(AText, Length(AText) - 1, 2) = #0' ' then
                      Delete(AText, Length(AText) - 1, 2);
                  end else
                  begin
                    if ((QPLPos(' ', ThisBlock) = 0) or (QPLPos(' ', ThisBlock) = Length(ThisBlock))) and (XPos = Settings.Left) then
                    begin
                      Words.Insert(WX + 1, '');
                      repeat
                        Words[WX + 1] := QPLCopy(ThisBlock, Length(ThisBlock), 1) + Words[WX + 1];
                        Delete(ThisBlock, Length(ThisBlock), 1);
                      until (Length(ThisBlock) = 2) or ((XPos +
                        FPainter.WideTextWidth(ToWide(ThisBlock))) <=
                        (Settings.Left + Settings.Width));
                      AText := ThisBlock;
                    end else
                    begin
                      AText := QPLCopy(ThisBlock, 1, Length(ThisBlock) - Length(ThisWord));
                      WX := WX - 1;
                    end;
                    if QPLCopy(AText, Length(AText), 1) = ' ' then
                      Delete(AText, Length(AText), 1);
                  end;
                  AXPos := XPos;
                  AYPos := YPos;
                  AWidth := FPainter.WideTextWidth(ToWide(AText));

                  if (AWidth > Settings.Width) then
                  begin
                    TooBig := True;
                  end;
                end;
                DrawLine;
                if (Settings.Top - YPos + {MaxDescent +} FPainter.TextHeight +
                  FPainter.TextSpacing) > MaxHeight + 0.05 then TooBig := True;

                XPos := Settings.Left + Indent;
                ThisBlock := '';
              end;
            end;
          end;
          Inc(WX);
        until (WX >= Words.Count) or TooBig;
        if TooBig then
        repeat
          if FParser.IsWide then
            Extra := Extra + Words[WX] + #0' '
          else
            Extra := Extra + Words[WX] + ' ';
          Inc(WX);
        until WX >= Words.Count;

        SetLength(LineTextBlocks, Length(LineTextBlocks) + 1);
        with LineTextBlocks[Length(LineTextBlocks) - 1] do
        begin
          Underlined := LastUnderlined;
          AFont := FPainter.SelFont;
          ASize := FPainter.TextSize;
          AColor := LastColor;
          ABackColor := LastBackColor;
          AFlags := LastFlags;
          ASpacing := LastSpacing;
          StyleExtra := LastStyleExtra;
          AText := ThisBlock;
          AXPos := XPos;
          AYPos := YPos;
          AWidth := FPainter.WideTextWidth(ToWide(AText));
          SoftHyphen := False;
        end;
        XPos := XPos + FPainter.WideTextWidth(ToWide(ThisBlock));
      end;
    end;
    if (Extra <> '') or ((Settings.Top - YPos + {MaxDescent +} FPainter.TextHeight + FPainter.TextSpacing) > MaxHeight + 0.05) then
    begin
      if FParser.IsWide then
      begin
        ExtraWide := PersistStack;
        for ExtraWideX := 1 to Length(ExtraWide) do
          Insert(#0, ExtraWide, ExtraWideX * 2 - 1);
        Extra := ExtraWide + Extra;
        if (X + 1) < Length(FParser.Elements) then
          Extra := Extra + QPLCopy(FParser.HTMLTextInput, FParser.Elements[X + 1].Position, MaxInt);
        X := Length(FParser.Elements);
      end else
      begin
        Extra := PersistStack + Extra;
        if (X + 1) < Length(FParser.Elements) then
          Extra := Extra + QPLCopy(FParser.HTMLTextInput, FParser.Elements[X + 1].Position, MaxInt);
        X := Length(FParser.Elements);
      end;
    end;
    Inc(X);
  end;
  if (Length(LineTextBlocks) > 0) then
    DrawLine;
  Result := Settings.Top - YPos;
end;

function THTMLRenderer.WideTrim(const Source: AnsiString): AnsiString;
var
  SS: AnsiString;
  Kill: Boolean;
begin
  Result := Source;
  Kill := True;
  while Kill and (Length(Result) > 0) do
  begin
    Kill := False;
    SS := QPLCopy(Result, 1, 2);
    if SS = #0' ' then Kill := True;
    if SS = #0#9 then Kill := True;
    if SS = #0#10 then Kill := True;
    if SS = #0#13 then Kill := True;
    if Kill then Delete(Result, 1, 2);
  end;
  Kill := True;
  while Kill and (Length(Result) > 0) do
  begin
    Kill := False;
    SS := QPLCopy(Result, Length(Result) - 1, 2);
    if SS = #0' ' then Kill := True;
    if SS = #0#9 then Kill := True;
    if SS = #0#10 then Kill := True;
    if SS = #0#13 then Kill := True;
    if Kill then Delete(Result, Length(Result) - 1, 2);
  end;
end;

end.
