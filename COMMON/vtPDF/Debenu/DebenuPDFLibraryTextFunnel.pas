{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTextFunnel.pas                         }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTextFunnel;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryMatrix, DebenuPDFLibraryExtra, DebenuPDFLibraryTextList;

type
  PPDFTextFunnelBlock = ^TPDFTextFunnelBlock;

  TPDFTextFunnelBlock = record
    P1, P2, P3, P4: TPDFDoublePoint;
    Text: WideString;
    DXoffsets: array of Double;
    FontName: AnsiString;
    MatDump: AnsiString;
    Color: AnsiString;
    TextSize: Double;
    Left, Top, Right, Bottom, Width, Height: Integer;
    LeftLine, RightLine, UpLine, DownLine: Integer;
    Used: Boolean;
    HCentre, VCentre: Integer;
    ColorArray: array of Double;
  end;

  TPDFIntPair = record
    VCentre: Integer;
    Index: Integer;
  end;

  PPDFLineInfo = ^TPDFLineInfo;
  TPDFLineInfo = record
    Index: Integer;
    Top: Integer;
  end;

  TPDFTextFunnelImage = record
    XObjectName: AnsiString;
    XObjectObjRef: AnsiString;
    P1, P2, P3, P4: TPDFDoublePoint;
  end;

  TPDFTextFunnel = class
  private
    FTextBlocks: array of TPDFTextFunnelBlock;
    SList: TList;
    FImages: array of TPDFTextFunnelImage;
    FOrigin: Integer;
    FScale: Double;
    FPageWidth: Double;
    FPageHeight: Double;
    FSplitWords: Boolean;
    FOutputWidths: Boolean;
    FMatch: Boolean;
    FNeedImages: Boolean;
    FWordGap: Double;
    FIgnoreFont: Boolean;
    FIgnoreColor: Boolean;
    FIgnoreBlocks: Boolean;
    FSortBlocks: Boolean;
    FIgnoreDescenders: Boolean;
    FIgnoreOverlaps: Boolean;
    FIgnoreDuplicates: Boolean;
    FSplitOnDoubleSpace: Boolean;
    FTrimCharsOutsideArea: Boolean;
    FSpecialMatch: Boolean;
    FIgnoreRotated: Boolean;
    FTrimWhitespace: Boolean;
    FOutputNonAscii: Boolean;
    FRemoveUnderscoreLines: Boolean;
    FHasArea: Boolean;
    FAreaLeft, FAreaTop, FAreaRight, FAreaBottom: Double;
    FOutputCMYK: Boolean;
    FVertScaleFactor: Double;
    FHorzScaleFactor: Double;
    function TX(X: Double): AnsiString;
    function TY(Y: Double): AnsiString;
    function PublishImage(Image: TPDFTextFunnelImage): AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    function GetCSV: WideString;
    function GetRawText: WideString;
    procedure GetTextInArea(Left, Top, Width, Height: Double; List: TQuickPDFStringList; Partial: Boolean = False);
    procedure AddText(Mat: TPDFXForm; const AText: WideString; Color: TPDFTextColor;
      const Font: AnsiString; TextSize, X, Y: Double; Width, Height: Double;
      ADXoffsets: array of Double);
    procedure AddImage(Image: TPDFTextFunnelImage);
    procedure GetImagesInArea(Left, Top, Width, Height: Double; List: TQuickPDFStringList; Partial: Boolean = False);
    procedure Clear;
    procedure SetNextMatch(Match: Boolean);
    procedure SetNeedImages;
    function TextBlock(I: Integer): PPDFTextFunnelBlock;
    procedure UpdateSList;
    procedure SetTokenAdjacency;
    function CreateTextLines: WideString;
    function GetTextList: TPDFTextList;
    function BlockCount: Integer;
    function GetBlock(Index: Integer): TPDFTextFunnelBlock;
    function ImageCount: Integer;
    function GetImage(Index: Integer): TPDFTextFunnelImage;
    procedure SetArea(Left, Top, Width, Height: Double);
    property Origin: Integer read FOrigin write FOrigin;
    property Scale: Double read FScale write FScale;
    property PageWidth: Double read FPageWidth write FPageWidth;
    property PageHeight: Double read FPageHeight write FPageHeight;
    property SplitWords: Boolean read FSplitWords write FSplitWords;
    property OutputWidths: Boolean read FOutputWidths write FOutputWidths;
    property NeedImages: Boolean read FNeedImages;
    property WordGap: Double read FWordGap write FWordGap;
    property IgnoreFont: Boolean read FIgnoreFont write FIgnoreFont;
    property IgnoreColor: Boolean read FIgnoreColor write FIgnoreColor;
    property IgnoreBlocks: Boolean read FIgnoreBlocks write FIgnoreBlocks;
    property SortBlocks: Boolean read FSortBlocks write FSortBlocks;
    property IgnoreDescenders: Boolean read FIgnoreDescenders write FIgnoreDescenders;
    property IgnoreOverlaps: Boolean read FIgnoreOverlaps write FIgnoreOverlaps;
    property IgnoreDuplicates: Boolean read FIgnoreDuplicates write FIgnoreDuplicates;
    property OutputCMYK: Boolean read FOutputCMYK write FOutputCMYK;
    property SplitOnDoubleSpace: Boolean read FSplitOnDoubleSpace write FSplitOnDoubleSpace;
    property TrimCharsOutsideArea: Boolean read FTrimCharsOutsideArea write FTrimCharsOutsideArea;
    property SpecialMatch: Boolean read FSpecialMatch write FSpecialMatch;
    property IgnoreRotated: Boolean read FIgnoreRotated write FIgnoreRotated;
    property TrimWhitespace: Boolean read FTrimWhitespace write FTrimWhitespace;
    property OutputNonAscii: Boolean read FOutputNonAscii write FOutputNonAscii;
    property RemoveUnderscoreLines: Boolean read FRemoveUnderscoreLines write FRemoveUnderscoreLines;
    property HorzScaleFactor: Double read FHorzScaleFactor write FHorzScaleFactor;
    property VertScaleFactor: Double read FVertScaleFactor write FVertScaleFactor;
  end;

implementation

uses
  SysUtils;

function SortByLeftThenTop(i,  j: Pointer): Integer;
begin
  if PPDFTextFunnelBlock(i).Left < PPDFTextFunnelBlock(j).Left then
    Result := -1
  else if PPDFTextFunnelBlock(i).Left > PPDFTextFunnelBlock(j).Left then
    Result := 1
  else if PPDFTextFunnelBlock(i).Top < PPDFTextFunnelBlock(j).Top then  // Origin is as Bottom Left
    Result := -1
  else if PPDFTextFunnelBlock(i).Top > PPDFTextFunnelBlock(j).Top then
    Result := 1
  else
    Result := 0;
end;

function SortByTopThenLeft(i,  j: Pointer): Integer;
begin
  if PPDFTextFunnelBlock(i).Top < PPDFTextFunnelBlock(j).Top then
    Result := -1
  else if PPDFTextFunnelBlock(i).Top > PPDFTextFunnelBlock(j).Top then
    Result := 1
  else if PPDFTextFunnelBlock(i).Left < PPDFTextFunnelBlock(j).Left then
    Result := -1
  else if PPDFTextFunnelBlock(i).Left > PPDFTextFunnelBlock(j).Left then
    Result := 1
  else
    Result := 0;
end;

{ TPDFTextFunnel }

procedure TPDFTextFunnel.AddImage(Image: TPDFTextFunnelImage);
begin
  SetLength(FImages, Length(FImages) + 1);
  FImages[Length(FImages) - 1] := Image;
end;

procedure TPDFTextFunnel.AddText(Mat: TPDFXForm; const AText: WideString;
  Color: TPDFTextColor; const Font: AnsiString; TextSize, X, Y, Width, Height: Double;
  ADXoffsets: array of Double);
var
  DX: Integer;
  TX, TY: Double;
  P1: TPDFDoublePoint;
  P2: TPDFDoublePoint;
  P3: TPDFDoublePoint;
  P4: TPDFDoublePoint;
  D: Double;
  DI: Integer;
  TestMat: AnsiString;
  SameLine: Boolean;
  SameWord: Boolean;
  AllSpaces: Boolean;
  Processed: Boolean;
  I, StartPos, EndPos: Integer;
  Matched: Boolean;
  DXOffsets: array of Double;
  Text: WideString;
  IsItalic: Boolean;

  function Distance(P1, P2: TPDFDoublePoint): Double;
  begin
    Result := Sqrt((P2.X - P1.X) * (P2.X - P1.X) +
      (P2.Y - P1.Y) * (P2.Y - P1.Y));
  end;

  procedure T(X, Y: Double);
  begin
    TX := Mat.eM11 * X + Mat.eM21 * Y + Mat.eDx;
    TY := Mat.eM12 * X + Mat.eM22 * Y + Mat.eDy;
  end;

  function DumpMat: AnsiString;
  begin
    Result := QPLDoubleToStr(Mat.eM11, 4) +
      QPLDoubleToStr(Mat.eM12, 4) +
      QPLDoubleToStr(Mat.eM21, 4) +
      QPLDoubleToStr(Mat.eM22, 4);
  end;

begin
  DI := -1;
  TestMat := DumpMat;
  SameLine := False;
  SameWord := False;
  IsItalic := False;

  Text := AText;
  SetLength(DXOffsets, Length(Text));
  for I := 0 to Length(Text) - 1 do
    DXOffsets[I] := ADXOffsets[I] - ADXOffsets[0];

  if (IgnoreRotated) then
  begin
    if (Mat.eM12 <> 0) or (Mat.eM21 <> 0) then
    begin
      if (Mat.eM21 < 0.005) then  // Allow for italic character drawn at a slight angle.
        IsItalic := True
      else
        Exit
    end
  end;

  if (FTrimWhitespace) then
  begin
    StartPos := 0;
    while (StartPos < Length(Text)) and (Text[StartPos+1] = ' ') do
      Inc(StartPos);

    EndPos := Length(Text) - 1;
    while (EndPos >= StartPos) and (Text[EndPos+1] = ' ') do
      Dec(EndPos);

    if (StartPos > EndPos) then
      Exit;

    X := X + DXoffsets[Startpos];

    if (EndPos < Length(Text) - 1) then
      Width := DXoffsets[Endpos + 1] - DXoffsets[Startpos]
    else
      Width := Width - DXoffsets[Startpos];

    Delete(Text, EndPos + 2, MaxInt);     // EndPos is 0 based.
    Delete(Text, 1, StartPos);            // StartPos is 0 based.

    SetLength(DXOffsets, EndPos - StartPos + 1);

    for I := StartPos to EndPos do
      DXoffsets[I - StartPos] := ADXoffsets[I] - ADXoffsets[StartPos];

    for I := StartPos to EndPos do
      ADXOffsets[I - StartPos] := ADXOffsets[I] - ADXOffsets[StartPos];
  end;

  // Working code for 11.11
  // Underscore removal
  if (FRemoveUnderscoreLines) then
  begin
    I := 1;
    while (I <= Length(Text)) and (Text[I] = '_') do
      Inc(I);

    if (I > Length(Text)) then
      Exit;
  end;

  T(X, Y);
  if (FHasArea) then
  begin
    if (TY > FAreaTop) or (TY < FAreaBottom) then
      Exit;

    if (not TrimCharsOutsideArea) and ((TX < FAreaLeft) or (TX > FAreaRight)) then
      Exit;

    if (TrimCharsOutsideArea) then    // Trim the characters outside the HasArea box.
    begin
      StartPos := -1;
      EndPos := -1;
      if (TY < FAreaTop) and (TY > FAreaBottom) then
      begin
        for I := 0 to Length(Text) - 1 do
        begin
          D := TX + DXoffsets[i] * Mat.eM11;
          if (D > FAreaLeft) and (D < FAreaRight) then
          begin
            if (StartPos = -1) then
              StartPos := I;
            EndPos := I;
          end;
        end;
      end;

      if (StartPos = -1) then
        Exit;

      X := X + DXoffsets[Startpos];

      if (EndPos < Length(Text) - 1) then
        Width := DXoffsets[Endpos + 1] - DXoffsets[Startpos]
      else
        Width := Width - DXoffsets[Startpos];

      Delete(Text, EndPos + 2, MaxInt);     // EndPos is 0 based.
      Delete(Text, 1, StartPos);            // StartPos is 0 based.

      SetLength(DXOffsets, EndPos - StartPos + 1);

      for I := StartPos to EndPos do
        DXoffsets[I - StartPos] := ADXoffsets[I] - ADXoffsets[StartPos];
    end;
  end;

  if (FIgnoreOverlaps) then
  begin
    DX := 0;

    AllSpaces := True;

    for I := 1 to Length(Text) do
      if Text[i] <> ' ' then
        AllSpaces := false;

    if (AllSpaces) then  // Just a test...  Let QPL determine the spaces.
      Exit;

    T(X + Width/2, Y+Height/2);
    while (DX < Length(FTextBlocks)) do
    begin
      P1.X := FTextBlocks[DX].P1.X;  // Left point of stored word
      P1.Y := FTextBlocks[DX].P1.Y;

      P2.X := FTextBlocks[DX].P3.X;  // Right point of stored word
      P2.Y := FTextBlocks[DX].P3.Y;

      if (IsItalic) then
      begin
        P2.X := P2.X - (P2.X - P1.X) * 0.10;
      end;

      if (TX >= P1.X) and ( TX <= P2.X) and (TY >= P1.Y) and (TY <= P2.Y) then  // We have an overlap
      begin
        if FIgnoreDuplicates then
        begin
          if (Text = FTextBlocks[DX].Text) then
            Exit;
        end else
          Exit;
      end;

      INC(DX);
    end;
  end;

  if FMatch then
  begin
    DX := 0;

    if (FSpecialMatch) then
    begin
      DX := Length(FTextBlocks) - 1;
      if (DX < 0) then
        DX := 0;
    end;

    while (DI < 0) and (DX < Length(FTextBlocks)) do
    begin
      P1.X := FTextBlocks[DX].P1.X;  // Left point of stored word
      P1.Y := FTextBlocks[DX].P1.Y;

      P2.X := FTextBlocks[DX].P2.X;  // Right point of stored word
      P2.Y := FTextBlocks[DX].P2.Y;

      T(X, Y);
      P3.X := TX;  // Current block
      P3.Y := TY;
      D := Distance(P2, P3);

      // Overcome invalid widths
      if ((P3.X > P1.X) and (P3.X < P2.X) and (P2.Y = P3.Y)) then
      begin
        D := 0;
      end;

      Matched := True;
      if (not FIgnoreFont) then
      begin
        Matched := Matched and (FTextBlocks[DX].FontName = Font);
      end;
      if (not FIgnoreColor) then
      begin
        Matched := Matched and (FTextBlocks[DX].Color = Color.HexColor);
      end;
      if (not FIgnoreBlocks) then
      begin
        Matched := Matched and (FTextBlocks[DX].MatDump = TestMat);
      end;
      if ((Matched) and (D < (TextSize / 10))) then
      begin
        DI := DX;
      end;

      Inc(DX);
    end;

    if DI < 0 then
    begin
      DX := 0;

      if (FSpecialMatch) then
      begin
        DX := Length(FTextBlocks) - 1;
        if (DX < 0) then
          DX := 0;
      end;

      while (DI < 0) and (DX < Length(FTextBlocks)) do
      begin
        P1.X := FTextBlocks[DX].P2.X;
        P1.Y := FTextBlocks[DX].P2.Y;
        T(X, Y);
        P2.X := TX;
        P2.Y := TY;
        D := Distance(P1, P2);

        Matched := True;
        if (not FIgnoreFont) then
        begin
          Matched := Matched and (FTextBlocks[DX].FontName = Font);
        end;
        if (not FIgnoreColor) then
        begin
          Matched := Matched and (FTextBlocks[DX].Color = Color.HexColor);
        end;
        if (not FIgnoreBlocks) then
        begin
          Matched := Matched and (FTextBlocks[DX].MatDump = TestMat);
        end;

        if ((Matched) and (Abs(P1.Y - P2.Y) < 2) and (D < TextSize * (FWordGap / 0.7))) then
        begin
          DI := DX;
          SameLine := True;
          if (D < TextSize * (FWordGap / 0.7) * 0.15) then
          begin
            SameWord := True;
          end;
        end;
        Inc(DX);
      end;
    end;
  end;

  T(X, Y);
  P1.X := TX;
  P1.Y := TY;
  T(X + Width, Y);
  P2.X := TX;
  P2.Y := TY;
  T(X + Width, Y + Height);
  P3.X := TX;
  P3.Y := TY;
  T(X, Y + Height);
  P4.X := TX;
  P4.Y := TY;

  Processed := False;
  if (DI >= 0) then
  begin

    if (SameLine) and (not SplitWords) then
    begin
      if not SameWord then
      begin
        EndPos := Length(FTextBlocks[DI].DXoffsets);
        // Allow for the extra space
        SetLength(FTextBlocks[DI].DXoffsets, EndPos + Length(DXoffsets) + 1);
        FTextBlocks[DI].DXoffsets[EndPos] := FTextBlocks[DI].P2.X;  // Calc the start value of the space character.

        for I := 0 to Length(DXoffsets) - 1 do
        begin
          FTextBlocks[DI].DXoffsets[EndPos + I + 1] := P1.X + (DXoffsets[I] - DXoffsets[0]) * Mat.eM11;
        end;

        FTextBlocks[DI].Text := FTextBlocks[DI].Text + ' ' + Text;
        FTextBlocks[DI].P2 := P2;
        FTextBlocks[DI].P3 := P3;
        Processed := True;
      end else
      begin
        EndPos := Length(FTextBlocks[DI].DXoffsets);
        SetLength(FTextBlocks[DI].DXoffsets, EndPos + Length(DXoffsets));

        for I := 0 to Length(DXoffsets) - 1 do
        begin
          FTextBlocks[DI].DXoffsets[EndPos + I] := P1.X + (DXoffsets[i] - DXoffsets[0]) * Mat.eM11;
        end;

        FTextBlocks[DI].Text := FTextBlocks[DI].Text + Text;
        FTextBlocks[DI].P2 := P2;
        FTextBlocks[DI].P3 := P3;
        Processed := True;
      end;
    end;

    if (SameLine and SameWord and (not Processed)) then
    begin
      EndPos := Length(FTextBlocks[DI].DXoffsets);
      SetLength(FTextBlocks[DI].DXoffsets, EndPos + Length(DXoffsets));

      FTextBlocks[DI].DXoffsets[EndPos] := FTextBlocks[DI].P2.X;
      for I := 1 to Length(DXoffsets) - 1 do
      begin
        FTextBlocks[DI].DXoffsets[EndPos + I] := P1.X + (DXoffsets[I] - DXoffsets[0]) * Mat.eM11;
      end;

      FTextBlocks[DI].Text := FTextBlocks[DI].Text + Text;
      FTextBlocks[DI].P2 := P2;
      FTextBlocks[DI].P3 := P3;
      Processed := True;
    end;

    if ((not SameLine) and (not Processed)) then
    begin
      EndPos := Length(FTextBlocks[DI].DXoffsets);
      SetLength(FTextBlocks[DI].DXoffsets, EndPos + Length(DXoffsets));

      FTextBlocks[DI].DXoffsets[EndPos] := P1.X;
      for I := 1 to Length(DXoffsets) - 1 do
      begin
        FTextBlocks[DI].DXoffsets[EndPos + I] := P1.X + (DXoffsets[I] - DXoffsets[0]) * Mat.eM11;
      end;

      FTextBlocks[DI].Text := FTextBlocks[DI].Text + Text;
      FTextBlocks[DI].P2 := P2;
      FTextBlocks[DI].P3 := P3;
      Processed := True;
    end;
  end;

  if (not Processed) then
  begin
    SetLength(FTextBlocks, Length(FTextBlocks) + 1);
    FTextBlocks[Length(FTextBlocks) - 1].Text := Text;
    FTextBlocks[Length(FTextBlocks) - 1].P1 := P1;
    FTextBlocks[Length(FTextBlocks) - 1].P2 := P2;
    FTextBlocks[Length(FTextBlocks) - 1].P3 := P3;
    FTextBlocks[Length(FTextBlocks) - 1].P4 := P4;
    FTextBlocks[Length(FTextBlocks) - 1].FontName := Font;
    FTextBlocks[Length(FTextBlocks) - 1].MatDump := TestMat;
    FTextBlocks[Length(FTextBlocks) - 1].Color := Color.HexColor;
    FTextBlocks[Length(FTextBlocks) - 1].TextSize := TextSize;
    SetLength(FTextBlocks[Length(FTextBlocks) - 1].ColorArray, Length(Color.Color));
    for I := 0 to Length(Color.Color) - 1 do
      FTextBlocks[Length(FTextBlocks) - 1].ColorArray[I] := Color.Color[I];

    SetLength(FTextBlocks[Length(FTextBlocks) - 1].DXoffsets, Length(DXoffsets));
    for I := 0 to Length(DXoffsets) - 1 do
    begin
      FTextBlocks[Length(FTextBlocks) - 1].DXoffsets[I] := P1.X + (DXoffsets[I] - DXoffsets[0]) * Mat.eM11;
    end;
  end;

  FMatch := True;
end;

function TPDFTextFunnel.BlockCount: Integer;
begin
  Result := Length(FTextBlocks);
end;

procedure TPDFTextFunnel.Clear;
begin
  SetLength(FTextBlocks, 0);
  SetLength(FImages, 0);
end;

constructor TPDFTextFunnel.Create;
begin
  FScale := 1;
  FOrigin := 0;
  FPageWidth := 0;
  FPageHeight := 0;
  FSplitWords := False;
  FOutputWidths := False;
  FMatch := True;
  FNeedImages := False;
  FWordGap := 0.7;
  FHasArea := False;
  FOutputCMYK := False;
  FHorzScaleFactor := 5;
  FVertScaleFactor := 8;

  SList := TList.Create;
end;

function TPDFTextFunnel.GetBlock(Index: Integer): TPDFTextFunnelBlock;
begin
  Result := FTextBlocks[Index];
end;

function TPDFTextFunnel.GetCSV: WideString;
var
  X: Integer;
  WS: WideString;
  ResultLength: Integer;
  I, Len: Integer;

  function B(const SS: AnsiString): AnsiString;
  var
    SSX: Integer;
  begin
    Result := '';
    for SSX := 1 to Length(SS) do
    begin
      if SS[SSX] >= #32 then
      begin
        if SS[SSX] = '"' then
        begin
          Result := Result + '\"';
        end else
        begin
          Result := Result + SS[SSX];
        end;
      end;
    end;
  end;

  procedure AppendWide(const NewText: WideString; Comma: Boolean = True);
  begin
    if (Length(NewText) > 0) or Comma then
    begin
      // Increase the buffer size if it's getting close to full
      if (ResultLength + Length(NewText) + 20) > Length(Result) then
      begin
        SetLength(Result, Length(Result) + Length(NewText) + 1024);
      end;
      // Copy the new text into the buffer
      Move(NewText[1], Result[ResultLength + 1], Length(NewText) * 2);
      Inc(ResultLength, Length(NewText));
      if Comma then
      begin
        Inc(ResultLength);
        Result[ResultLength] := WideChar(',');
      end;
    end;
  end;

  procedure AppendAnsi(const NewText: AnsiString; Comma: Boolean = True);
  var
    WideNew: WideString;
    WideX: Integer;
  begin
    SetLength(WideNew, Length(NewText));
    for WideX := 1 to Length(NewText) do
    begin
      WideNew[WideX] := WideChar(Byte(NewText[WideX]));
    end;
    AppendWide(WideNew, Comma);
  end;

  procedure NormalizeWideString(var Text : WideString);
  var
    I: Integer;
  begin
    for I := 1 to Length(Text) do
    begin
      if Text[I] = WideChar($2013) then Text[I] := '-';
      if Text[I] = WideChar($2014) then Text[I] := '-';
      if Text[I] = WideChar($2018) then Text[I] := #39;
      if Text[I] = WideChar($2019) then Text[I] := #39;
      if Text[I] = WideChar($201C) then Text[I] := '"';
      if Text[I] = WideChar($201D) then Text[I] := '"';
      if Text[I] = WideChar($2039) then Text[I] := '<';
      if Text[I] = WideChar($203A) then Text[I] := '>';
      if Text[I] = WideChar($02DC) then Text[I] := '~';
    end;
  end;

begin
  // Start with a buffer size of 1024 wide characters
  ResultLength := 0;
  SetLength(Result, 1024);

  UpdateSList;

  if (FSortBlocks) then
    SList.Sort(SortByTopThenLeft);

  for X := 0 to Length(FTextBlocks) - 1 do
  begin
    WS := TextBlock(X).Text;
    //NormalizeWideString(WS);
    WS := QPLWideStringReplace(WS, WideChar(13), WideChar(32), [rfReplaceAll]);
    WS := QPLWideStringReplace(WS, WideString('"'), WideString('\"'), [rfReplaceAll]);

    AppendAnsi('"' + TextBlock(X).FontName + '"');
    AppendAnsi(TextBlock(X).Color);
    AppendAnsi(QPLDoubleToStr(TextBlock(X).TextSize, 2));
    AppendAnsi(TX(TextBlock(X).P1.X));
    AppendAnsi(TY(TextBlock(X).P1.Y));
    AppendAnsi(TX(TextBlock(X).P2.X));
    AppendAnsi(TY(TextBlock(X).P2.Y));
    AppendAnsi(TX(TextBlock(X).P3.X));
    AppendAnsi(TY(TextBlock(X).P3.Y));
    AppendAnsi(TX(TextBlock(X).P4.X));
    AppendAnsi(TY(TextBlock(X).P4.Y));
    AppendWide(WideString('"') + WS + WideString('"'), False);
    AppendWide(WideString(#13#10), False);

    // Output character widths on a separate line.
    if (OutputWidths) then
    begin
      Len := Length(TextBlock(X).DXoffsets);
      for I := 0 to Len - 2 do
      begin
        AppendAnsi(QPLDoubleToStrConst((TextBlock(X).DXoffsets[I+1] - TextBlock(X).DXoffsets[I]) * FScale, 4));
      end;
      AppendAnsi(QPLDoubleToStrConst((TextBlock(X).P3.X - TextBlock(X).DXoffsets[Len - 1]) * FScale, 4), False);

      AppendWide(WideString(#13#10), False);
    end;
  end;

  SetLength(Result, ResultLength);
end;

function TPDFTextFunnel.GetRawText: WideString;
var
  X: Integer;
  WS: WideString;
  ResultLength: Integer;

  procedure AppendWide(const NewText: WideString);
  begin
    if (Length(NewText) > 0) then
    begin
      // Increase the buffer size if it's getting close to full
      if (ResultLength + Length(NewText) + 20) > Length(Result) then
      begin
        SetLength(Result, Length(Result) + Length(NewText) + 1024);
      end;
      // Copy the new text into the buffer
      Move(NewText[1], Result[ResultLength + 1], Length(NewText) * 2);
      Inc(ResultLength, Length(NewText));
    end;
  end;

begin
  // Start with a buffer size of 1024 wide characters
  ResultLength := 0;
  SetLength(Result, 1024);

  UpdateSList;

  if (FSortBlocks) then
    SList.Sort(SortByTopThenLeft);

  for X := 0 to Length(FTextBlocks) - 1 do
  begin
    WS := TextBlock(X).Text;
    //NormalizeWideString(WS);
    WS := QPLWideStringReplace(WS, WideChar(13), WideChar(32), [rfReplaceAll]);
    WS := QPLWideStringReplace(WS, WideString('"'), WideString('\"'), [rfReplaceAll]);

    AppendWide(WideString(WS));
    AppendWide(WideString(#13#10));
  end;

  SetLength(Result, ResultLength);
end;

function TPDFTextFunnel.GetImage(Index: Integer): TPDFTextFunnelImage;
begin
  Result := FImages[Index];
end;

procedure TPDFTextFunnel.GetImagesInArea(Left, Top, Width, Height: Double;
  List: TQuickPDFStringList; Partial: Boolean);
var
  X: Integer;

  function InBlock(P: TPDFDoublePoint): Boolean;
  begin
    Result := (P.X > Left) and (P.X < (Left + Width)) and
      (P.Y < Top) and (P.Y > (Top - Height));
  end;

begin
  List.Clear;
  for X := 0 to Length(FImages) - 1 do
  begin
    if Partial then
    begin
      if InBlock(FImages[X].P1) or InBlock(FImages[X].P2) or
        InBlock(FImages[X].P3) or InBlock(FImages[X].P4) then
          List.Add(PublishImage(FImages[X]));
    end else
    begin
      if InBlock(FImages[X].P1) and InBlock(FImages[X].P2) and
        InBlock(FImages[X].P3) and InBlock(FImages[X].P4) then
          List.Add(PublishImage(FImages[X]));
    end;
  end;
end;

procedure TPDFTextFunnel.GetTextInArea(Left, Top, Width, Height: Double;
  List: TQuickPDFStringList; Partial: Boolean);
var
  X: Integer;

  procedure AddText;
  begin
    List.Add(QPLUTF8Encode(FTextBlocks[X].Text));
  end;

  function InBlock(P: TPDFDoublePoint): Boolean;
  begin
    Result := (P.X > Left) and (P.X < (Left + Width)) and
      (P.Y < Top) and (P.Y > (Top - Height));
  end;

begin
  List.Clear;
  for X := 0 to Length(FTextBlocks) - 1 do
  begin
    if Partial then
    begin
      if InBlock(FTextBlocks[X].P1) or InBlock(FTextBlocks[X].P2) or
        InBlock(FTextBlocks[X].P3) or InBlock(FTextBlocks[X].P4) then
          AddText;
    end else
    begin
      if InBlock(FTextBlocks[X].P1) and InBlock(FTextBlocks[X].P2) and
        InBlock(FTextBlocks[X].P3) and InBlock(FTextBlocks[X].P4) then
          AddText;
    end;
  end;
end;

function TPDFTextFunnel.ImageCount: Integer;
begin
  Result := Length(FImages);
end;

function TPDFTextFunnel.PublishImage(Image: TPDFTextFunnelImage): AnsiString;
begin
  Result := QPLCopy(Image.XObjectName, 2, MaxInt) + ' ' +
    QPLDoubleToStr(Image.P1.X, 2) + ' ' +
    QPLDoubleToStr(Image.P1.Y, 2) + ' ' +
    QPLDoubleToStrConst(Abs(Image.P2.X - Image.P1.X), 2) + ' ' +
    QPLDoubleToStrConst(Abs(Image.P3.Y - Image.P1.Y), 2);
end;

procedure TPDFTextFunnel.SetArea(Left, Top, Width, Height: Double);
begin
  FHasArea := True;
  FAreaLeft := Left;
  FAreaTop := Top;
  FAreaRight := Left + Width;
  FAreaBottom := Top - Height;
end;

procedure TPDFTextFunnel.SetNeedImages;
begin
  FNeedImages := True;
end;

procedure TPDFTextFunnel.SetNextMatch(Match: Boolean);
begin
  FMatch := Match;
end;

function TPDFTextFunnel.TX(X: Double): AnsiString;
var
  FPageWidthScaled : Double;
begin
  X := X * Scale;
  FPageWidthScaled := FPageWidth * Scale;
  if (FOrigin = 2) or (FOrigin = 3) then
    X := FPageWidthScaled - X;
  Result := QPLDoubleToStr(X, 4);
end;

function TPDFTextFunnel.TY(Y: Double): AnsiString;
var
  FPageHeightScaled : Double;
begin
  Y := Y * Scale;
  FPageHeightScaled := FPageHeight * Scale;
  if (FOrigin = 1) or (FOrigin = 2) then
    Y := FPageHeightScaled - Y;
  Result := QPLDoubleToStr(Y, 4);
end;

function TPDFTextFunnel.TextBlock(I : Integer): PPDFTextFunnelBlock;
begin
  Result := PPDFTextFunnelBlock(SList[I]);   // Retrieve the sorted index
end;

procedure TPDFTextFunnel.UpdateSList;
var
  I: Integer;
begin
  for I := 0 to Length(FTextBlocks) - 1 do
  begin
    FTextBlocks[I].Left := Round(FTextBlocks[I].P1.X);
    FTextBlocks[I].Top := Round(FPageHeight - FTextBlocks[I].P3.Y);
    FTextBlocks[I].Right := Round(FTextBlocks[I].P3.X);
    FTextBlocks[I].Bottom := Round(FPageHeight - FTextBlocks[I].P1.Y);
    FTextBlocks[I].Width := FTextBlocks[I].Right - FTextBlocks[I].Left;
    FTextBlocks[I].Height := FTextBlocks[I].Bottom - FTextBlocks[I].Top;

    FTextBlocks[I].LeftLine := -1;
    FTextBlocks[I].RightLine := -1;
    FTextBlocks[I].DownLine := -1;
    FTextBlocks[I].UpLine := -1;

    FTextBlocks[I].vcentre := FTextBlocks[I].Top + Round(FTextBlocks[I].Height / 2);
    FTextBlocks[I].hcentre := FTextBlocks[I].Left + Round(FTextBlocks[I].Width / 2);
  end;

  SList.Clear;
  for I := 0 to Length(FTextBlocks) - 1 do
    SList.Add(Pointer(@FTextBlocks[i]));          //cast the array index as a Pointer

end;

procedure TPDFTextFunnel.SetTokenAdjacency;
var
  LeftLines: array of Integer;
  TopLines: array of Integer;

  I, J, K: Integer;
  Found: Boolean;
  Height: Integer;
  Lines: array of TPDFIntPair;
  Min, Closest: Integer;
  leftlinecenter: Integer;
  currightcenter: Integer;
  proprightcenter: Integer;
begin

  SetLength(LeftLines, 10000);
  SetLength(TopLines, 10000);

  for I := 0 to Length(LeftLines) - 1 do
    LeftLines[i] := -1;
  for I := 0 to Length(TopLines) - 1 do
    TopLines[i] := -1;

  UpdateSList;

  // Sort the blocks by left, then top.
  SList.Sort(SortByLeftThenTop);

  for I := 0 to Length(FTextBlocks) - 1 do
  begin
    if (TextBlock(I).Height > 175) then
      continue;  // line too tall, do not link with anything

    Found := false;
    Height := 0;

    for J := TextBlock(I).Top to TextBlock(I).Bottom do
    begin
      if (J >= 0) and (J < Length(LeftLines)) then
      begin
        if (leftlines[j] = -1) then
        begin
          LeftLines[j] := I;
          Inc(Height);
          Found := true;
        end;
      end;
    end;

    if (Found) and (Height > TextBlock(i).Height / 2) then   // Must be big enough to add.
    begin
      SetLength(Lines, Length(Lines) + 1);
      Lines[Length(Lines)-1].VCentre := TextBlock(i).vcentre;
      Lines[Length(Lines)-1].Index := i;
    end;
  end;

  for I := 0 to Length(FTextBlocks) - 1 do
  begin
    Min := 9999;
    Closest := -1;

    for k := 0 to Length(lines) - 1 do
    begin
      if (Abs(TextBlock(I).vcentre - lines[k].vcentre) < min) then
      begin
        min := Abs(TextBlock(I).vcentre - lines[k].vcentre);
        closest := lines[k].index;
      end;
    end;

    if (closest <> -1) and (closest <> i) then
    begin
      // there is one to the left, see what must be done to get to this one
      while (TextBlock(closest).rightline <> -1) and (TextBlock(TextBlock(closest).rightline).leftline = closest) do
           closest := TextBlock(closest).rightline;

      if (TextBlock(closest).rightline = i) or (TextBlock(closest).Right >= TextBlock(I).Left + 5) then //already here!
      begin
        // Do nothing
      end
      else if (TextBlock(closest).rightline = -1) then // we have a clear shot, do it!
      begin
        if (TextBlock(I).leftline = -1) then
          TextBlock(I).leftline := closest;

        TextBlock(closest).rightline := i;
      end
      else // another line is already occupying the requisite rightlink. See if this one is better.
      begin
        leftlinecenter := TextBlock(closest).vcentre;
        currightcenter := TextBlock(TextBlock(closest).rightline).vcentre;
        proprightcenter := TextBlock(I).vcentre;

        if (Abs(proprightcenter - leftlinecenter) < Abs(currightcenter - leftlinecenter)) then
        begin
          TextBlock(TextBlock(closest).rightline).leftline := -1;

          TextBlock(I).leftline := closest;
          TextBlock(closest).rightline := i; // it's better, take it
        end;
      end;
    end;
  end;

  // Now fill in leftline and upline to help navigate.
  for I := 0 to Length(FTextBlocks) - 1 do
  begin
    if (TextBlock(I).rightline >= 0) then
      TextBlock(TextBlock(I).rightline).leftline := i;

    if (TextBlock(I).downline >= 0) then
      TextBlock(TextBlock(I).downline).upline := i;
  end;

end;

function SortVertical(i,  j: Pointer): Integer;
begin
  if PPDFLineInfo(i).Top < PPDFLineInfo(j).Top then
    Result := -1
  else if PPDFLineInfo(i).Top > PPDFLineInfo(j).Top then
    Result := 1
  else
    Result := 0;
end;

function TPDFTextFunnel.GetTextList: TPDFTextList;
var
  I, J: Integer;
  Item: TPDFTextListItem;
  Len: Integer;
begin

  UpdateSList;
  if (FSortBlocks) then
    SList.Sort(SortByTopThenLeft);

  Result := TPDFTextList.Create;
  for i := 0 to Length(FTextBlocks) - 1 do
  begin
    Item.Bounds[0] := TextBlock(I).P1.X;
    Item.Bounds[1] := TextBlock(I).P1.Y;
    Item.Bounds[2] := TextBlock(I).P2.X;
    Item.Bounds[3] := TextBlock(I).P2.Y;
    Item.Bounds[4] := TextBlock(I).P3.X;
    Item.Bounds[5] := TextBlock(I).P3.Y;
    Item.Bounds[6] := TextBlock(I).P4.X;
    Item.Bounds[7] := TextBlock(I).P4.Y;

    Item.FontName := TextBlock(I).FontName;
    Item.FontSize := TextBlock(I).TextSize;

    Item.Color.HexColor := TextBlock(I).Color;

    SetLength(Item.Color.Color, Length(TextBlock(I).ColorArray));

    for J := 0 to Length(TextBlock(I).ColorArray) - 1 do
      Item.Color.Color[J] := TextBlock(I).ColorArray[J];

    Item.Text := TextBlock(I).Text;

    Len := Length(TextBlock(I).Text);
    SetLength(Item.Widths, Len);

    for J := 0 to Len - 2 do
      Item.Widths[J] := (TextBlock(I).DXoffsets[J+1] - TextBlock(I).DXoffsets[J]) * FScale;
    Item.Widths[Len-1] := (TextBlock(I).P3.X - TextBlock(I).DXoffsets[Len - 1]) * FScale;

    Result.AddText(Item);
  end;
end;

function TPDFTextFunnel.CreateTextLines: WideString;
var
  MaxChars: Integer;
  currLine: Integer;
  line: WideString;
  arr: array of WideChar;
  LinesList: array of TPDFLineInfo;
  LList: TList;
  I, J: Integer;
  ii, idx, pos, p: Integer;
  lastp, lastx: Integer;
  ResultLength: Integer;

  function LineItem(I: Integer): PPDFLineInfo;
  begin
    Result := PPDFLineInfo(LList[I]);   // Retrieve the sorted index
  end;

  procedure AppendWide(const NewText: WideString);
  begin
    if (Length(NewText) > 0) then
    begin
      // Increase the buffer size if it's getting close to full
      if (ResultLength + Length(NewText) + 200) > Length(Result) then
      begin
        SetLength(Result, Length(Result) + Length(NewText) + MaxChars);
      end;
      // Copy the new text into the buffer
      Move(NewText[1], Result[ResultLength + 1], Length(NewText) * 2);
      Inc(ResultLength, Length(NewText));
    end;
  end;

begin
  MaxChars := Trunc(FPageWidth / HorzScaleFactor) * 4;

  ResultLength := 0;
  SetLength(Result, MaxChars);
  currLine := 1;

  SetLength(arr, MaxChars);
  for j := 0 to MaxChars - 1 do
  begin
    arr[j] := ' ';
  end;

  for i := 0 to Length(FTextBlocks) - 1 do
  begin
    if (TextBlock(I).leftline = -1) then  // Start of a line
    begin
      SetLength(LinesList, Length(LinesList) + 1);
      LinesList[Length(LinesList) - 1].Index := i;
      LinesList[Length(LinesList) - 1].Top := TextBlock(i).Top;
    end;
    FTextBlocks[i].Used := False;
  end;

  // Sort the blocks by left, then top.
  LList := TList.Create;
  try
    for I := 0 to Length(LinesList) - 1 do
    begin
      LList.Add(Pointer(@LinesList[i]));          // cast the array index as a Pointer
    end;

    LList.Sort(SortVertical);

    for i := 0 to LList.Count - 1 do
    begin
      lastp := -1;
      lastx := -1;
      II := PPDFLineInfo(LList[i]).Index;

      pos := Round(TextBlock(II).Top / VertScaleFactor);
      if (currLine < pos) then
      begin
        for j := currLine + 1 to pos - 1 do
        begin
          AppendWide(WideString(#13#10));
        end;
        currLine := pos;
      end;

      repeat
        pos := Round(TextBlock(II).Left / HorzScaleFactor);

        if (pos <= lastp + 1) then
        begin
          if ((TextBlock(II).Left - lastx) >
            (TextBlock(II).Bottom - TextBlock(II).Top) / HorzScaleFactor) then
          begin
            pos := lastp + 2;
          end else
          begin
            pos := lastp + 1;
          end;
        end;

        p := lastp;

        if (not TextBlock(II).Used) then
        begin
          for idx := 1 to Length(TextBlock(II).Text) do
          begin
            p := pos + idx;
            if (p < MaxChars) then
            begin
              arr[p] := TextBlock(II).Text[idx];
            end;
          end;
          TextBlock(II).Used := True;
        end;

        lastp := p;
        lastx := TextBlock(II).Right;

        ii := TextBlock(II).RightLine;
      until (ii = -1);

      line := '';
      for j := 0 to MaxChars - 1 do
      begin
        line := line + arr[j];
      end;

      AppendWide(WideString(TrimRight(line)));
      AppendWide(WideString(#13#10));
      Inc(currLine);   // Move to the next line.

      for j := 0 to MaxChars - 1 do
      begin
        arr[j] := ' ';
      end;
    end;

    SetLength(Result, ResultLength);
  finally
    LList.Free;
  end;
end;

destructor TPDFTextFunnel.Destroy;
begin
  SList.Free;
  inherited;
end;

end.
