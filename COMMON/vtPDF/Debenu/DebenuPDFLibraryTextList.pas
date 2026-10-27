{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTextList.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTextList;

{$I DebenuPDFLibraryDefines.inc}

interface

//uses
//  DebenuPDFLibraryMatrix;

uses DebenuPDFLibraryExtra;

type
  TPDFTextListItem = record
    Bounds: array[0..7] of Double;
    Text: WideString;
    Color: TPDFTextColor;
    FontName: AnsiString;
    FontSize: Double;
    Widths: array of Double;
  end;

  TPDFTextList = class
  private
    FTexts: array of TPDFTextListItem;
  public
    procedure AddText(Item: TPDFTextListItem);
    function TextCount: Integer;
    function TextString(TextIndex: Integer): WideString;
    function TextBounds(TextIndex: Integer; BoundsIndex: Integer): Double;
    function TextFontName(TextIndex: Integer): AnsiString;
    function TextFontSize(TextIndex: Integer): Double;
    function TextColorType(TextIndex: Integer): Integer;
    function TextColor(TextIndex: Integer; ColorComponent: Integer): Double;
    function TextCharWidth(TextIndex: Integer; Position: Integer): Double;
    function TextBlockAsString(Index, Origin: Integer; PageWidth, PageHeight, Scale: Double): WideString;
  end;

implementation

{ TPDFTextList }

procedure TPDFTextList.AddText(Item: TPDFTextListItem);
begin
  SetLength(FTexts, Length(FTexts) + 1);
  FTexts[Length(FTexts) - 1] := Item;
end;

function TPDFTextList.TextCount: Integer;
begin
  Result := Length(FTexts);
end;

function TPDFTextList.TextString(TextIndex: Integer): WideString;
begin
  Result := '';
  if (TextIndex >= 1) and (TextIndex <= Length(FTexts)) then
  begin
    Result :=  FTexts[TextIndex - 1].Text;
  end;
end;

function TPDFTextList.TextBounds(TextIndex: Integer; BoundsIndex: Integer): Double;
begin
  Result := -1;
  if (TextIndex >= 1) and (TextIndex <= Length(FTexts)) then
  begin
    if (BoundsIndex >= 1) and (BoundsIndex <= 8) then
      Result :=  FTexts[TextIndex - 1].Bounds[BoundsIndex - 1];
  end;
end;

function TPDFTextList.TextFontName(TextIndex: Integer): AnsiString;
begin
  Result := '';
  if (TextIndex >= 1) and (TextIndex <= Length(FTexts)) then
    Result :=  FTexts[TextIndex - 1].FontName;
end;

function TPDFTextList.TextFontSize(TextIndex: Integer): double;
begin

  Result := -1;
  if (TextIndex >= 1) and (TextIndex <= Length(FTexts)) then
    Result :=  FTexts[TextIndex - 1].FontSize;
end;

function TPDFTextList.TextColorType(TextIndex: Integer): Integer;
begin
  Result := -1;
  if (TextIndex >= 1) and (TextIndex <= Length(FTexts)) then
  begin
    Result := Length(FTexts[TextIndex - 1].Color.Color);
  end;
end;

function TPDFTextList.TextColor(TextIndex: Integer; ColorComponent: Integer): Double;
begin
  Result := -1;
  if (TextIndex >= 1) and (TextIndex <= Length(FTexts)) then
  begin
    if (ColorComponent >= 1) and (ColorComponent <= Length(FTexts[TextIndex - 1].Color.Color)) then
      Result := FTexts[TextIndex - 1].Color.Color[ColorComponent - 1];
  end;
end;

function TPDFTextList.TextCharWidth(TextIndex: Integer; Position: Integer): Double;
var
  TextLen: Integer;
begin

  Result := -1;
  if (TextIndex >= 1) and (TextIndex <= Length(FTexts)) then
  begin
    TextLen := Length(FTexts[TextIndex - 1].Text);
    if (TextLen > 0) and (Position >= 1) and (Position <= TextLen) then
      Result := FTexts[TextIndex - 1].Widths[Position - 1];
  end;
end;

function TPDFTextList.TextBlockAsString(Index, Origin: Integer; PageWidth, PageHeight, Scale: Double): WideString;
var
  TextLen: Integer;
  I, X: Integer;
  TX, TY: Double;
begin

  Result := '';
  if (Index >= 1) and (Index <= Length(FTexts)) then
  begin
    X := Index - 1;
    TextLen := Length(FTexts[X].Text);

    // Fontname, Fontsize, Textcolor
    Result := Result + 'CNT:' + WideString(QPLIntToStr(TextLen)) + #13#10;
    Result := Result + 'FNT:' + WideString(FTexts[X].FontName) + #13#10;
    Result := Result + 'SIZ:' + WideString(QPLDoubleToStr(FTexts[X].FontSize, 2)) + #13#10;
    Result := Result + 'CLR:' + WideString(FTexts[X].Color.HexColor) + #13#10;

    // Bounding Box X1,Y1,X2,Y2 ...
    for I := 0 to 3 do
    begin
      TX := FTexts[X].Bounds[I * 2];
      TY := FTexts[X].Bounds[I * 2 + 1];

      if (Origin = 1) or (Origin = 2) then  // Y values
        TY := PageHeight - TY;
      if (Origin = 2) or (Origin = 3) then  // X values
        TX := PageWidth - TX;

      TX := TX * Scale;
      TY := TY * Scale;

      Result := Result + 'TX' + WideString(QPLIntToStr(I+1)) + ':' + WideString(QPLDoubleToStr(TX, 4)) + #13#10;
      Result := Result + 'TY' + WideString(QPLIntToStr(I+1)) + ':' + WideString(QPLDoubleToStr(TY, 4)) + #13#10;
    end;

    // Character Widths
    Result := Result + 'WID:';
    for I := 1 to TextLen - 1 do
      Result := Result + WideString(QPLDoubleToStr(FTexts[X].Widths[I-1], 4)) + ',';

    Result := Result + WideString(QPLDoubleToStr(FTexts[X].Widths[TextLen-1], 4)) + #13#10;

    // TXT: - should always be the last in the list due to Non ASCII data etc..
    Result := Result + 'TXT:' + WideString(FTexts[X].Text);

  end;
end;

end.
