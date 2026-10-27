{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryExtractor.pas                          }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryExtractor;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  Classes, DebenuPDFLibraryFont, DebenuPDFLibraryType1,
  DebenuPDFLibraryFontRasterizer, DebenuPDFLibraryFontConst, DebenuPDFLibraryExtra;

type
  TPDFExtractor = class
  private
    FontColor: AnsiString;
    FResourcesDict: TPDFDictionary;
    FStructure: TPDFStructure;
    FOnFindObject: TPDFFindObjectEvent;
    FBaseFontKeys: TQuickPDFStringList;
    FBaseFontValues: TQuickPDFStringList;
    FFontCol: TPDFFontCollection;
    FResFont: TPDFDictionary;
    function GetBaseFont(const FontName: AnsiString): AnsiString;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
    function GetFontRef(const FontName: AnsiString): TPDFIndRef;
  protected
    CSN: TPDFCharsetNames;  
  public
    constructor Create(AResourcesDict: TPDFDictionary; FontCol: TPDFFontCollection);
    destructor Destroy; override;
    procedure Clear;
    function ExtractTextW(const S: AnsiString; Options: Integer = 0): WideString;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
  end;

implementation

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils;

{ TPDFExtractor }

procedure TPDFExtractor.Clear;
begin
end;

constructor TPDFExtractor.Create(AResourcesDict: TPDFDictionary; FontCol: TPDFFontCollection);
begin
  FFontCol := FontCol;
  FResourcesDict := AResourcesDict;
  if Assigned(FResourcesDict) then
    FStructure := AResourcesDict.Owner;
  FOnFindObject := nil;
  FBaseFontValues := TQuickPDFStringList.Create;
  FBaseFontKeys := TQuickPDFStringList.Create;
end;

destructor TPDFExtractor.Destroy;
begin
  FBaseFontValues.Free;
  FBaseFontKeys.Free;
  inherited;
end;

{$WARNINGS OFF}
function TPDFExtractor.ExtractTextW(const S: AnsiString; Options: Integer): WideString;
var
  Tok: AnsiString;
  Buffer: AnsiString;
  ArrayBuffer: AnsiString;
  ATok: array[1..6] of AnsiString;
  FontSize: Double;
  Scale: Double;
  Leading: Double;
  FontName: AnsiString;
  Widths: TPDFCharsetWidths;
  CharMap: TPDFCharsetWide;
  LeftEdge: Double;
  BottomEdge: Double;
  XPos: Double;
  YPos: Double;
  ArrayXPos: Double;
  OldYPos: Double;
  OldXPos: Double;
  Change: Double;
  DecString: AnsiString;
  CX: Integer;
  BaseFont: AnsiString;
  CharSpace: Double;
  WordSpace: Double;
  Obj: TPDFObject;
  TokPos: Integer;
  MaxLen: Integer;
  SpaceChar: Integer;
  SpaceCharWidth: Double;
  RemappedText: WideString;
  Z: Double;
const
  WhiteSpace: WideString = #32#13#10;
  CRLF: WideString = #13#10;
  LineSpacingLimit = 1.7;

  function TextWidth(const S: AnsiString): Double;
  var
    CX: Integer;
  begin
    Result := 0;
    for CX := 1 to Length(S) do
    begin
      Result := Result + Widths[Ord(S[CX])];
      if Ord(S[CX]) = SpaceChar then Result := Result + WordSpace;
      Result := Result + CharSpace;
    end;
     Result := Result * FontSize * Scale / 1000;
  end;

  function NextToken: AnsiString;
  var
    InWhitespace: Boolean;
    TokStart: Integer;
    TokEnd: Integer;
    InStr: Integer;
    InSlash: Boolean;
  begin
    if TokPos < MaxLen then
    begin
      repeat
        InWhitespace := False;
        case S[TokPos] of
          #0,#9,#10,#12,#13,#32:
          begin
            InWhitespace := True;
            Inc(TokPos);
          end;
        end;
      until (not InWhitespace) or (TokPos > MaxLen);
      if TokPos = MaxLen then
      begin
        Result := S[TokPos];
        TokPos := MaxLen + 1;
      end else
      if TokPos < MaxLen then
      begin
        TokStart := TokPos;
        if S[TokStart] = '(' then
        begin
          InStr := 1;
          InSlash := False;
          repeat
            Inc(TokPos);
            if InSlash then
            begin
              InSlash := False;
            end else
            case S[TokPos] of
              '\': InSlash := True;
              ')': Dec(InStr);
              '(': Inc(InStr);
            end;
          until (InStr = 0) or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end else
        if (S[TokStart] = '[') or (S[TokStart] = ']') then
        begin
          Result := S[TokStart];
          Inc(TokPos);
        end else
        if (S[TokStart] = '<') then
        begin
          repeat
            Inc(TokPos);
          until (S[TokPos] = '>') or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end else
        begin
          repeat
            Inc(TokPos);
            InWhitespace := False;
            case S[TokPos] of
              #0,#9,#10,#12,#13,#32,#40,#47,#60,#91,#93: InWhitespace := True;
            end;
          until (InWhitespace) or (TokPos >= MaxLen);
          if TokPos = MaxLen then Inc(TokPos);
          TokEnd := TokPos - 1;
          Result := QPLCopy(S, TokStart, TokEnd - TokStart + 1);
        end;
      end else
        Result := '';
    end else
      Result := '';
  end;

  function Remap(const S: AnsiString): WideString;
  var
    X: Integer;
    CodeList: TQuickPDFCodeList;
  begin
    Result := '';
    if FFontCol.FoundFontData.IsComposite then
    begin
      FFontCol.GetCodeList(S, CodeList);
      for X := 0 to Length(CodeList) - 1 do
        Result := Result + FFontCol.GetWideMap(CodeList[X]);
    end else
    begin
      for X := 1 to Length(S) do
        Result := Result + FFontCol.GetWideMap(Ord(S[X]));
    end;
  end;

  function LineEndResult(const Test: WideString): Boolean;
  begin
    if Length(Test) >= 2 then
    begin
      Result := (Test[Length(Test) - 1] = WideChar(13)) and
        (Test[Length(Test)] = WideChar(10));
    end else
      Result := False;
  end;

begin

  if not Assigned(FResourcesDict) then // No resources so exit.
    exit;

  MaxLen := Length(S);
  TokPos := 1;

  FResFont := nil;
  Obj := FResourcesDict.FindValueByKeyName('Font');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
    FResFont := TPDFDictionary(Obj);

  Result := '';
  Scale := Length(S); 
  Scale := 1;
  Leading := 0;
  FontSize := 12;
  XPos := 0;
  YPos := 0;
  LeftEdge := 0;
  BottomEdge := 0;
  CharSpace := 0;
  WordSpace := 0;
  OldYPos := 0;
  OldXPos := 0;
  ArrayXPos := 0;
  BaseFont := '';
  FontColor := '#000000';

  GetCharsetNames(peStandard, CSN);
  GetUnicode(CSN, CharMap);

  for CX := 0 to 255 do
    Widths[CX] := 750;
  SpaceChar := 32;
  SpaceCharWidth := 280;

  repeat
    try
      Tok := NextToken;
      if Tok <> '' then
      begin
        if Tok[1] = '(' then
        begin
          Buffer := FStructure.DecodeString(Tok);
        end else
        if Tok[1] = '<' then
        begin
          Buffer := FStructure.DecodeHex(Tok);
        end else
        if Tok = '[' then
        begin
          ArrayXPos := XPos;
          repeat
            Tok := NextToken;
            if Tok <> '' then
            begin
              if (Tok[1] = '(') or (Tok[1] = '<') then
              begin
                if Tok[1] = '(' then
                  DecString := FStructure.DecodeString(Tok)
                else
                  DecString := FStructure.DecodeHex(Tok);
                if CharSpace > (SpaceCharWidth * Scale * FontSize) / 1000 then
                for CX := 1 to Length(DecString) - 1 do
                  Insert(AnsiChar(SpaceChar), DecString, CX * 2);
                ArrayBuffer := ArrayBuffer + DecString;
                XPos := XPos + TextWidth(DecString);
              end else
              begin
                if Tok <> ']' then
                begin
                  if TazzIsFloat(Tok) then
                  begin
                    Z := TazzToFloat(Tok);
                    Change := -(Z * Scale * FontSize) / 1000;
                    XPos := XPos + Change;
                    if -Z > (SpaceCharWidth / 2) then
                      ArrayBuffer := ArrayBuffer + AnsiChar(SpaceChar);
                  end;
                end;
              end;
            end;
          until (Tok = ']') or (Tok = '');
        end else
        if Tok = 'rg' then
        begin
          FontColor := '#' + QPLIntToHex(Round(TazzToFloat(ATok[1]) * 255) * 256 * 256 +
            Round(TazzToFloat(ATok[2]) * 255) * 256 +
            Round(TazzToFloat(ATok[3]) * 255), 6);
        end else
        if Tok = 'g' then
        begin
          FontColor := '#' + QPLIntToHex(Round(TazzToFloat(ATok[1]) * 255) * 256 * 256 +
            Round(TazzToFloat(ATok[1]) * 255) * 256 +
            Round(TazzToFloat(ATok[1]) * 255), 6);
        end else
        if Tok = 'BT' then
        begin
          LeftEdge := 0;
          BottomEdge := 0;
        end else
        if Tok = 'Tf' then
        begin
          FontName := ATok[2];
          FontName := QPLCopy(FontName, 2, Length(FontName));
          if Options = 2 then
            BaseFont := GetBaseFont(FontName);
          FFontCol.GetFontData(GetFontRef(FontName));
          Widths := FFontCol.FoundFontData.Widths;
          CharMap := FFontCol.FoundFontData.DisplayCSW;
          if TazzIsFloat(ATok[1]) then
            TazzToFloatVar(ATok[1], FontSize)
          else
            FontSize := 12;
          if CharMap[32] = ' ' then SpaceChar := 32
          else
          begin
            if FFontCol.FoundFontData.LastChar < 255 then
              CharMap[255] := #32;
            SpaceChar := 0;
            while (SpaceChar < 256) and (CharMap[SpaceChar] <> ' ') do
              Inc(SpaceChar);
            if SpaceChar > 255 then SpaceChar := 32;
          end;
          if (CharMap[SpaceChar] <> ' ') or (Widths[SpaceChar] = 750) then
            SpaceCharWidth := 280
          else
            SpaceCharWidth := Widths[SpaceChar];
        end else
        if Tok = 'TJ' then
        begin
          if Options = 0 then
            Result := Result + Remap(ArrayBuffer);
          if Options = 2 then
          begin
            RemappedText := Remap(ArrayBuffer);
            RemappedText := QPLWideStringReplace(RemappedText, WideString('"'),
              WideString('\"'), [rfReplaceAll]);

            Result := Result + WideString(QPLDoubleToStr(ArrayXPos, 2)) +
              WideString(',') +
              WideString(QPLDoubleToStr(YPos, 2)) +
              WideString(',') +
              WideString(FontColor) +
              WideString(',') +
              WideString(QPLDoubleToStr(FontSize, 2)) +
              WideString(',"') +
              WideString(BaseFont) +
              WideString('","') +
              RemappedText +
              WideString('"') +
              CRLF;
          end;
          ArrayBuffer := '';
        end else
        if (Tok = '''') or (Tok = '"') then
        begin
          Tok := 'Tj';
          if Options = 0 then
          begin
            if not LineEndResult(Result) then
              Result := Result + CRLF;
          end;
        end else
        if Tok = 'Tj' then
        begin
          if Options = 0 then
             Result := Result + Remap(Buffer);
          if Options = 2 then
          begin
            RemappedText := Remap(Buffer);
            RemappedText := QPLWideStringReplace(RemappedText, WideString('"'),
              WideString('\"'), [rfReplaceAll]);

            Result := Result + WideString(QPLDoubleToStr(XPos, 2)) +
              WideString(',') +
              WideString(QPLDoubleToStr(YPos, 2)) +
              WideString(',') +
              WideString(FontColor) +
              WideString(',') +
              WideString(QPLDoubleToStr(FontSize, 2)) +
              WideString(',"') +
              WideString(BaseFont) +
              WideString('","') +
              RemappedText +
              WideString('"') +
              CRLF;
          end;
          XPos := XPos + TextWidth(Buffer);
          Buffer := '';
        end else
        if Tok = 'TL' then
        begin
          TazzToFloatVar(ATok[1], Leading);
          Leading := Leading * Scale;
        end else
        if Tok = 'Tw' then
        begin
          TazzToFloatVar(ATok[1], WordSpace);
          WordSpace := WordSpace * Scale;
        end else
        if Tok = 'Tc' then
        begin
          TazzToFloatVar(ATok[1], CharSpace);
          CharSpace := CharSpace * Scale;
        end else
        if Tok = 'Tm' then
        begin
          if (ATok[4] = '0') and (ATok[5] = '0') and (ATok[3] = ATok[6]) then
          if TazzIsFloat(ATok[6]) then
            Scale := TazzToFloat(ATok[6])
          else
            Scale := 1;
          Change := TazzToFloat(ATok[2]);

          if (Options = 0) and (not LineEndResult(Result)) then
          begin
            if Abs(Change - XPos) >= ((SpaceCharWidth / 2) * Scale * FontSize / 1000) then
              Result := Result + WideString(' ');
          end;
          XPos := Change;

          Change := TazzToFloat(ATok[1]);
          if (Options = 0) and (not LineEndResult(Result)) then
          begin
            if Abs(Change - YPos) >= (FontSize * Scale * LineSpacingLimit / 2) then
              Result := Result + CRLF;
            if Abs(Change - YPos) >= (FontSize * Scale * LineSpacingLimit) then
              Result := Result + CRLF;
          end;
          YPos := Change;

          LeftEdge := XPos;
          BottomEdge := YPos;
        end else
        if Tok = 'Td' then
        begin
          XPos := LeftEdge + TazzToFloat(ATok[2]) * Scale;
          YPos := BottomEdge + TazzToFloat(ATok[1]) * Scale;
          LeftEdge := XPos;
          BottomEdge := YPos;

          if (Options = 0) and (not LineEndResult(Result)) then
          begin
            if Abs(XPos - OldXPos) >= ((SpaceCharWidth / 2) * Scale * FontSize / 1000) then
              Result := Result + WideString(' ');
            if Abs(YPos - OldYPos) >= (FontSize * Scale * LineSpacingLimit / 2) then Result := Result + CRLF;
            if (YPos - OldYPos) >= (FontSize * Scale * LineSpacingLimit) then Result := Result + CRLF;
          end;
        end else
        if (Tok = 'TD') then
        begin
          XPos := LeftEdge + TazzToFloat(ATok[2]) * Scale;

          if TazzIsFloat(ATok[1]) then
            Leading := -TazzToFloat(ATok[1]) * Scale
          else
            Leading := 0;
          YPos := BottomEdge - Leading;

          LeftEdge := XPos;
          BottomEdge := YPos;

          if (Options = 0) and (not LineEndResult(Result)) then
          begin
            if (XPos - OldXPos) >= TextWidth(AnsiChar(SpaceChar)) then Result := Result + WideString(' ');
            if Abs(YPos - OldYPos) >= (FontSize * Scale * LineSpacingLimit / 2) then Result := Result + CRLF;
            if (YPos - OldYPos) >= (FontSize * Scale * LineSpacingLimit) then Result := Result + CRLF;
          end;
        end else
        if (Tok = 'T*') then
        begin
          XPos := LeftEdge;
          YPos := YPos - Leading;
          if Options = 0 then Result := Result + #13#10;
          BottomEdge := YPos;
        end else
        if (Tok = 'ID') then
        begin
          while (TokPos < MaxLen) and (QPLCopy(S, TokPos, 2) <> 'EI') do
            Inc(TokPos);
        end;

        OldXPos := XPos;
        OldYPos := YPos;
        ATok[6] := ATok[5];
        ATok[5] := ATok[4];
        ATok[4] := ATok[3];
        ATok[3] := ATok[2];
        ATok[2] := ATok[1];
        ATok[1] := Tok;
      end;
    except
      Tok := Tok + '';
    end;
  until Tok = '';

  while QPLWideStringPos(#13#10' '#13#10, Result) > 0 do
    Delete(Result, QPLWideStringPos(#13#10' '#13#10, Result), 3);

  while QPLWideStringPos(#13#10#13#10#13#10, Result) > 0 do
    Delete(Result, QPLWideStringPos(#13#10#13#10#13#10, Result), 4);

  while QPLWideStringPos(#0, Result) > 0 do
    Result[QPLWideStringPos(#0, Result)] := ' ';

  Result := QPLWideStringTrim(Result)
end;
{$WARNINGS ON}

function TPDFExtractor.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

function TPDFExtractor.GetBaseFont(const FontName: AnsiString): AnsiString;
var
  Res: TPDFDictionary;
  Obj: TPDFObject;
  Fonts: TPDFDictionary;
  Font: TPDFDictionary;
  I: Integer;
begin
  I := FBaseFontKeys.IndexOf(FontName);
  if I >= 0 then Result := FBaseFontValues[I] else
  begin
    Result := '';
    if Assigned(FResourcesDict) then
    begin
      Res := FResourcesDict;
      Obj := Res.FindValueByKeyName('Font', False);
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
      begin
        Fonts := TPDFDictionary(Obj);
        Obj := Fonts.FindValueByKeyName(FontName, False);
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFDictionary then
        begin
          Font := TPDFDictionary(Obj);
          Obj := Font.FindValueByKeyName('BaseFont', False);
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFName then
            Result := TPDFName(Obj).Name;
        end;
      end;
    end;
    FBaseFontKeys.Add(FontName);
    FBaseFontValues.Add(Result);
  end;
end;

function TPDFExtractor.GetFontRef(const FontName: AnsiString): TPDFIndRef;
var
  Obj: TPDFObject;
begin
  Obj := FResFont.FindValueByKeyName(FontName);
  if Obj is TPDFIndRef then Result := TPDFIndRef(Obj) else Result := nil;
end;

end.
