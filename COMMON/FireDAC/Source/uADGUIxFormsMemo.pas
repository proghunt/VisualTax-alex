{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                FireDAC GUIx Forms memo                }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsMemo;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages, Registry,
{$ENDIF}
  Classes, Controls, Graphics, StdCtrls
{$IFDEF AnyDAC_SynEdit}
  , synedit, synmemo, synhighlightersql, synedithighlighter
{$ENDIF}
  , uADStanIntf;

type
  {----------------------------------------------------------------------------}
  { TADGUIxFormsMemo                                                           }
  {----------------------------------------------------------------------------}
{$IFDEF AnyDAC_SynEdit}
  TADGUIxFormsMemo = class(TSynMemo)
  private
    function GetCaretPos: TPoint;
    procedure SetCaretPos(const AValue: TPoint);
    function GetRDBMSKind: TADRDBMSKind;
    procedure SetRDBMSKind(const AValue: TADRDBMSKind);
  public
    constructor Create(AOwner: TComponent); override;
    property CaretPos: TPoint read GetCaretPos write SetCaretPos;
    property RDBMSKind: TADRDBMSKind read GetRDBMSKind write SetRDBMSKind;
  end;
{$ELSE}
  TADGUIxFormsMemo = class(TMemo)
  private
    FRDBMSKind: TADRDBMSKind;
  {$IFNDEF AnyDAC_D6Base}
    procedure SetCaretPos(const AValue: TPoint);
  {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
  {$IFNDEF AnyDAC_D6Base}
    property CaretPos write SetCaretPos;
  {$ENDIF}
    property RDBMSKind: TADRDBMSKind read FRDBMSKind write FRDBMSKind;
  end;
{$ENDIF}

implementation

uses
  SysUtils, TypInfo,
  uADStanUtil;

{$IFDEF AnyDAC_SynEdit}
{------------------------------------------------------------------------------}
{ TADGUIxFormsHilighter                                                        }
{------------------------------------------------------------------------------}
type
  TADGUIxFormsHilighter = class(TSynSQLSyn)
  private
  {$IFDEF MSWINDOWS}
    FReg: TRegistry;
  {$ENDIF}
    FFontName: String;
    FFontSize: Integer;
  {$IFDEF MSWINDOWS}
    function GetEditorKey: String;
    procedure LoadAttr(AAttrs: TSynHighlighterAttributes; const AKind: String);
    procedure LoadSettings;
    function ReadBool(const AIdent: string): Boolean;
  {$ENDIF}
    function GetRDBMSKind: TADRDBMSKind;
    procedure SetRDBMSKind(const AValue: TADRDBMSKind);
  public
    constructor Create(AOwner: TComponent); override;
    property RDBMSKind: TADRDBMSKind read GetRDBMSKind write SetRDBMSKind;
  end;

{------------------------------------------------------------------------------}
constructor TADGUIxFormsHilighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$IFDEF MSWINDOWS}
  FReg := TRegistry.Create;
  try
    FReg.RootKey := HKEY_CURRENT_USER;
    LoadSettings;
  finally
    ADFree(FReg);
  end;
  {$ENDIF}
end;

  {$IFDEF MSWINDOWS}
{------------------------------------------------------------------------------}
function TADGUIxFormsHilighter.GetEditorKey: String;
begin
{$IFDEF AnyDAC_D15}
  Result := '\SOFTWARE\Embarcadero\';
  {$IFDEF AnyDAC_D17}
    Result := Result + 'BDS\10.0\';
  {$ELSE}
    {$IFDEF AnyDAC_D16}
    Result := Result + 'BDS\9.0\';
    {$ELSE}
      {$IFDEF AnyDAC_D15}
      Result := Result + 'BDS\8.0\';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ELSE}
  {$IFDEF AnyDAC_D12}
  Result := '\SOFTWARE\Codegear\';
    {$IFDEF AnyDAC_D14}
    Result := Result + 'BDS\7.0\';
    {$ELSE}
    Result := Result + 'BDS\6.0\';
    {$ENDIF}
  {$ELSE}
  Result := '\SOFTWARE\Borland\';
    {$IFDEF AnyDAC_D11}
    Result := Result + 'BDS\5.0\';
    {$ELSE}
      {$IFDEF AnyDAC_D10}
      Result := Result + 'BDS\4.0\';
      {$ELSE}
        {$IFDEF AnyDAC_D9}
        Result := Result + 'BDS\3.0\';
        {$ELSE}
          {$IFDEF AnyDAC_D7}
          Result := Result + 'Delphi\7.0\';
          {$ELSE}
            {$IFDEF AnyDAC_D6}
            Result := Result + 'Delphi\6.0\';
            {$ELSE}
              {$IFDEF AnyDAC_D5}
            Result := Result + 'Delphi\5.0\';
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  Result := Result + 'Editor';
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsHilighter.ReadBool(const AIdent: string): Boolean;
const
  C_BoolArr: array [Boolean] of String = ('False', 'True');
begin
  Result := FReg.ReadString(AIdent) = C_BoolArr[True];
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsHilighter.LoadAttr(AAttrs: TSynHighlighterAttributes;
  const AKind: String);
var
  eStyles: TFontStyles;
  s: String;
begin
  if not FReg.OpenKeyReadOnly(GetEditorKey + '\Highlight\' + AKind) then
    Exit;

  if not ReadBool('Default Foreground') then begin
    s := FReg.ReadString('Foreground Color New');
    if s <> '' then
      AAttrs.Foreground := StringToColor(s);
  end;

  if not ReadBool('Default Background') then begin
    s := FReg.ReadString('Background Color New');
    if s <> '' then
      AAttrs.Background := StringToColor(s);
  end;

  eStyles := [];
  if ReadBool('Bold') then
    Include(eStyles, fsBold)
  else
    Exclude(eStyles, fsBold);
  if ReadBool('Italic') then
    Include(eStyles, fsItalic)
  else
    Exclude(eStyles, fsItalic);
  if ReadBool('Underline') then
    Include(eStyles, fsUnderline)
  else
    Exclude(eStyles, fsUnderline);
  AAttrs.Style := eStyles;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsHilighter.LoadSettings;
begin
  if not FReg.OpenKeyReadOnly(GetEditorKey + '\Options') then
    Exit;
  if FReg.ValueExists('Editor Font') then
    FFontName := FReg.ReadString('Editor Font')
  else
    FFontName := 'Courier New';
  if FReg.ValueExists('Font Size') then
    FFontSize := FReg.ReadInteger('Font Size')
  else
    FFontSize := 10;
  LoadAttr(SpaceAttri, 'Whitespace');
  LoadAttr(CommentAttribute, 'Comment');
  LoadAttr(CommentAttri, 'Comment');
{$IFNDEF AnyDAC_FPC}
  LoadAttr(ConditionalCommentAttri, 'Preprocessor');
{$ENDIF}
  LoadAttr(KeywordAttribute, 'Reserved word');
  LoadAttr(KeyAttri, 'Reserved word');
  LoadAttr(PLSQLAttri, 'Reserved word');
  LoadAttr(SQLPlusAttri, 'Reserved word');
  LoadAttr(FunctionAttri, 'Reserved word');
  LoadAttr(DataTypeAttri, 'Reserved word');
  LoadAttr(NumberAttri, 'Number');
  LoadAttr(StringAttribute, 'String');
  LoadAttr(StringAttri, 'String');
  LoadAttr(SymbolAttribute, 'Symbol');
  LoadAttr(SymbolAttri, 'Symbol');
  LoadAttr(IdentifierAttribute, 'Identifier');
  LoadAttr(IdentifierAttri, 'Identifier');
{$IFNDEF AnyDAC_FPC}
  LoadAttr(DelimitedIdentifierAttri, 'Identifier');
{$ENDIF}
  LoadAttr(VariableAttri, 'Identifier');
end;
  {$ENDIF}

{------------------------------------------------------------------------------}
function TADGUIxFormsHilighter.GetRDBMSKind: TADRDBMSKind;
var
  sSQLDialect: string;
begin
  sSQLDialect := GetEnumName(TypeInfo(TSQLDialect), Ord(SQLDialect));
  if SameText(sSQLDialect, 'sqlInterbase6') then Result := mkInterbase
  else if SameText(sSQLDialect, 'sqlInterbase6') then Result := mkInterbase
  else if SameText(sSQLDialect, 'sqlMSSQL7') then Result := mkMSSQL
  else if SameText(sSQLDialect, 'sqlMySQL') then Result := mkMySQL
  else if SameText(sSQLDialect, 'sqlOracle') then Result := mkOracle
  else if SameText(sSQLDialect, 'sqlSybase') then Result := mkMSSQL
  else if SameText(sSQLDialect, 'sqlMSSQL2K') then Result := mkMSSQL
  else if SameText(sSQLDialect, 'sqlPostgres') then Result := mkPostgreSQL
  else Result := mkOther;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsHilighter.SetRDBMSKind(const AValue: TADRDBMSKind);
const
  C_RDBMSKind2SQLDialect: array[TADRDBMSKind] of TSQLDialect =
    (sqlStandard, sqlOracle, sqlMSSQL2K, sqlStandard, sqlMySQL,
     sqlStandard, sqlSybase, sqlStandard, sqlInterbase6, sqlStandard, 
     {$IFDEF AnyDAC_Unicode} sqlPostgres {$ELSE} sqlStandard {$ENDIF},
     sqlStandard, sqlStandard, sqlStandard);
begin
  SQLDialect := C_RDBMSKind2SQLDialect[AValue];
end;

{------------------------------------------------------------------------------}
{ TADGUIxFormsMemo                                                             }
{------------------------------------------------------------------------------}
constructor TADGUIxFormsMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Highlighter := TADGUIxFormsHilighter.Create(Self);
  if TADGUIxFormsHilighter(Highlighter).FFontName <> '' then
    Font.Name := TADGUIxFormsHilighter(Highlighter).FFontName;
  if TADGUIxFormsHilighter(Highlighter).FFontSize <> 0 then
    Font.Size := TADGUIxFormsHilighter(Highlighter).FFontSize;
{$IFNDEF AnyDAC_FPC}
  WordWrap := False;
{$ELSE}
  Gutter.Visible := False;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsMemo.GetCaretPos: TPoint;
begin
  Result := Point(CaretX - 1, CaretY - 1);
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsMemo.SetCaretPos(const AValue: TPoint);
begin
  CaretX := AValue.X + 1;
  CaretY := AValue.Y + 1;
end;

{------------------------------------------------------------------------------}
function TADGUIxFormsMemo.GetRDBMSKind: TADRDBMSKind;
begin
  Result := TADGUIxFormsHilighter(Highlighter).RDBMSKind;
end;

{------------------------------------------------------------------------------}
procedure TADGUIxFormsMemo.SetRDBMSKind(const AValue: TADRDBMSKind);
begin
  TADGUIxFormsHilighter(Highlighter).RDBMSKind := AValue;
end;

{$ELSE}

{------------------------------------------------------------------------------}
constructor TADGUIxFormsMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Font.Name := 'Courier New';
  WordWrap := False;
  ScrollBars := ssBoth;
end;

{------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6Base}
procedure TADGUIxFormsMemo.SetCaretPos(const AValue: TPoint);
var
  CharIdx: Integer;
begin
  CharIdx := SendMessage(Handle, EM_LINEINDEX, AValue.y, 0) + AValue.x;
  SendMessage(Handle, EM_SETSEL, CharIdx, CharIdx);
end;
{$ENDIF}

{$ENDIF}

end.
