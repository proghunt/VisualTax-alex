{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryLayout.pas                             }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryLayout;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryPainter;

type
  TPDFTableCellAlignment = (caTopLeft, caTopCenter, caTopRight,
    caMiddleLeft, caMiddleCenter, caMiddleRight, caBottomLeft,
    caBottomCenter, caBottomRight);

  TPDFTableBorder = record
    Width: Double;
    Color: array of Double;
    Padding: Double;
  end;

  TPDFTableCell = record
    Alignment: TPDFTableCellAlignment;
    Borders: array[0..3] of TPDFTableBorder;
    BackgroundColor: array of Double;
    HTMLText: WideString;
    MeasuredHeight: Double;
    DrawnLeft: Double;
    DrawnTop: Double;
    DrawnWidth: Double;
    DrawnHeight: Double;
    ColumnSpan: Integer;
    RowSpan: Integer;
    IgnoreMerge: Boolean;
    TextSize: Double;
    TextColor: array of Double;
  end;

  TPDFTable = class
  private
    FCells: array of array of TPDFTableCell;
    FColumnWidths: array of Double;
    FRowHeights: array of Double;
    FMeasuredRowHeights: array of Double;
    FTableBorders: array[0..3] of TPDFTableBorder;
    FLastDrawnRow: Integer;
    FThinBorders: Boolean;
    FThinBorderColor: array of Double;
    function ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn: Integer): Boolean;
    function GetBorderRange(BorderIndex: Integer; var FirstBorder, LastBorder: Integer): Boolean;
    procedure MeasureRows(P: TPDFPainter);
    function MakeCellPrefix(Cell: TPDFTableCell): WideString;
    function CellColorToHex(Cell: TPDFTableCell): WideString;
    procedure SetupDefaultRow(Row, Column: Integer);
  public
    constructor Create(RowCount, ColumnCount: Integer);
    destructor Destroy; override;
    function GetTotalWidth: Double;
    function SetCellAlignment(FirstRow, FirstColumn, LastRow, LastColumn, NewCellAlignment: Integer): Boolean;
    function SetTextColor(FirstRow, FirstColumn, LastRow, LastColumn: Integer; Red, Green, Blue: Double): Boolean;
    function SetTextColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn: Integer; C, M, Y, K: Double): Boolean;
    function SetTextSize(FirstRow, FirstColumn, LastRow, LastColumn: Integer; NewTextSize: Double): Boolean;
    function SetBackgroundColor(FirstRow, FirstColumn, LastRow, LastColumn: Integer; Red, Green, Blue: Double): Boolean;
    function SetBackgroundColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn: Integer; C, M, Y, K: Double): Boolean;
    function SetBorderColor(FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; Red, Green, Blue: Double): Boolean;
    function SetBorderColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; C, M, Y, K: Double): Boolean;
    function SetBorderWidth(FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; NewWidth: Double): Boolean;
    function SetBorderPadding(FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; NewPadding: Double): Boolean;
    function SetTableBorderColor(BorderIndex: Integer; Red, Green, Blue: Double): Boolean;
    function SetTableBorderColorCMYK(BorderIndex: Integer; C, M, Y, K: Double): Boolean;
    function SetTableBorderWidth(BorderIndex: Integer; NewWidth: Double): Boolean;
    function SetCellContent(RowNumber, ColumnNumber: Integer; HTMLText: WideString): Boolean;
    function SetColumnWidth(FirstColumn, LastColumn: Integer; NewWidth: Double): Boolean;
    function SetRowHeight(FirstRow, LastRow: Integer; NewHeight: Double): Boolean;
    function MergeCells(FirstRow, FirstColumn, LastRow, LastColumn: Integer): Boolean;
    function DrawTableRows(Left, Top, Height: Double; FirstRow, LastRow: Integer; Doc: TObject): Double;
    function GetLastDrawnRow: Integer;
    function GetCellStrProperty(RowNumber, ColumnNumber, Tag: Integer): WideString;
    function GetCellIntProperty(RowNumber, ColumnNumber, Tag: Integer): Integer;
    function GetCellDblProperty(RowNumber, ColumnNumber, Tag: Integer): Double;
    function GetRowCount: Integer;
    function GetColumnCount: Integer;
    function InsertRows(Position, NewRowCount: Integer): Integer;
    function InsertColumns(Position, NewColumnCount: Integer): Integer;
    procedure SetThinBorders(NewThinBorders: Boolean; Red, Green, Blue: Double);
    procedure SetThinBordersCMYK(NewThinBorders: Boolean; C, M, Y, K: Double);
  end;

implementation

uses
  DebenuPDFLibraryDocument, DebenuPDFLibraryExtra;

{ TPDFTable }

constructor TPDFTable.Create(RowCount, ColumnCount: Integer);
var
  Row: Integer;
  Column: Integer;
begin
  FLastDrawnRow := 0;
  if (RowCount > 0) and (ColumnCount > 0) then
  begin
    SetLength(FRowHeights, RowCount);
    SetLength(FColumnWidths, ColumnCount);
    SetLength(FCells, RowCount);
    for Row := 1 to RowCount do
      SetLength(FCells[Row - 1], ColumnCount);
    for Row := 1 to RowCount do
      for Column := 1 to ColumnCount do
      begin
        SetupDefaultRow(Row, Column);
      end;
  end;
end;

procedure TPDFTable.SetupDefaultRow(Row, Column: Integer);
var
  Border: Integer;
begin
  FCells[Row - 1][Column - 1].Alignment := caTopLeft;
  FCells[Row - 1][Column - 1].IgnoreMerge := False;
  FCells[Row - 1][Column - 1].ColumnSpan := 1;
  FCells[Row - 1][Column - 1].RowSpan := 1;
  FCells[Row - 1][Column - 1].TextSize := 0;
  SetLength(FCells[Row - 1][Column - 1].TextColor, 0);

  for Border := 1 to 4 do
  begin
    FTableBorders[Border - 1].Width := 1;
    SetLength(FTableBorders[Border - 1].Color, 3);
          
    FCells[Row - 1][Column - 1].Borders[Border - 1].Width := 1;
    FCells[Row - 1][Column - 1].Borders[Border - 1].Padding := 2;
    SetLength(FCells[Row - 1][Column - 1].Borders[Border - 1].Color, 3);
    if (Border = 1) or (Border = 2) then
    begin
      FTableBorders[Border - 1].Color[0] := 0.8;
      FTableBorders[Border - 1].Color[1] := 0.8;
      FTableBorders[Border - 1].Color[2] := 0.8;

      FCells[Row - 1][Column - 1].Borders[Border - 1].Color[0] := 0.5;
      FCells[Row - 1][Column - 1].Borders[Border - 1].Color[1] := 0.5;
      FCells[Row - 1][Column - 1].Borders[Border - 1].Color[2] := 0.5;
    end else
    begin
      FTableBorders[Border - 1].Color[0] := 0.5;
      FTableBorders[Border - 1].Color[1] := 0.5;
      FTableBorders[Border - 1].Color[2] := 0.5;

      FCells[Row - 1][Column - 1].Borders[Border - 1].Color[0] := 0.8;
      FCells[Row - 1][Column - 1].Borders[Border - 1].Color[1] := 0.8;
      FCells[Row - 1][Column - 1].Borders[Border - 1].Color[2] := 0.8;
    end;
  end;
end;

destructor TPDFTable.Destroy;
begin
  inherited;
end;

function TPDFTable.DrawTableRows(Left, Top, Height: Double; FirstRow,
  LastRow: Integer; Doc: TObject): Double;
var
  D: TPDFDocument;
  P: TPDFPainter;
  Row, Column, Border: Integer;
  XPos: Double;
  YPos: Double;
  Cell: TPDFTableCell;
  WrapWidth: Double;
  DrawBorder: Boolean;
  AlignOffset: Double;
  CellWidth: Double;
  CellHeight: Double;
  TotalWidth: Double;
  TotalHeight: Double;
  SpanCount: Integer;
  StylePrefix: WideString;

  function Round3(D: Double): Integer;
  begin
    Result := Round(D * 1000);
  end;

begin
  Result := 0;
  if Doc is TPDFDocument then
  begin
    D := TPDFDocument(Doc);
    P := D.PageTree.Painter;

    if Length(FMeasuredRowHeights) = 0 then
      MeasureRows(P);

    TotalHeight := 0;
    TotalWidth := GetTotalWidth;

    YPos := Top;
    Row := FirstRow;
    if LastRow < 1 then LastRow := Length(FRowHeights);
    if (FirstRow >= 1) and (LastRow <= Length(FRowHeights)) and (FirstRow <= LastRow) then
    begin
      while (Row <= LastRow) and (Round3(YPos) >= Round3(Top - Height)) do
      begin
        if Round3(YPos - FMeasuredRowHeights[Row - 1]) < Round3(Top - Height) then
        begin
          Row := LastRow + 1;
        end else
        if (FMeasuredRowHeights[Row - 1] > 0) then
        begin
          XPos := Left;
          for Column := 1 to Length(FColumnWidths) do
          begin
            Cell := FCells[Row - 1][Column - 1];
            if not Cell.IgnoreMerge then
            begin
              CellWidth := 0;
              CellHeight := 0;
              for SpanCount := 1 to Cell.ColumnSpan do
              begin
                if (Column + SpanCount - 1) <= Length(FColumnWidths) then
                  CellWidth := CellWidth + FColumnWidths[Column + SpanCount - 2];
              end;
              for SpanCount := 1 to Cell.RowSpan do
              begin
                if (Row + SpanCount - 1) <= Length(FRowHeights) then
                  CellHeight := CellHeight + FMeasuredRowHeights[Row + SpanCount - 2];
              end;

              FCells[Row - 1][Column - 1].DrawnLeft := XPos;
              FCells[Row - 1][Column - 1].DrawnTop := YPos;
              FCells[Row - 1][Column - 1].DrawnWidth := CellWidth;
              FCells[Row - 1][Column - 1].DrawnHeight := CellHeight;

              if Length(Cell.BackgroundColor) = 3 then
              begin
                P.SetFillColor(Cell.BackgroundColor[0], Cell.BackgroundColor[1],
                  Cell.BackgroundColor[2]);
                P.Rectangle(XPos + Cell.Borders[0].Width / 2,
                  YPos - Cell.Borders[1].Width / 2,
                  CellWidth - Cell.Borders[0].Width / 2 - Cell.Borders[3].Width / 2,
                  CellHeight - Cell.Borders[1].Width / 2 - Cell.Borders[3].Width / 2,
                  True, False);
              end else
              if Length(Cell.BackgroundColor) = 4 then
              begin
                P.SetFillColor(Cell.BackgroundColor[0], Cell.BackgroundColor[1],
                  Cell.BackgroundColor[2], Cell.BackgroundColor[3]);
                P.Rectangle(XPos + Cell.Borders[0].Width / 2,
                  YPos - Cell.Borders[1].Width / 2,
                  CellWidth - Cell.Borders[0].Width / 2 - Cell.Borders[3].Width / 2,
                  CellHeight - Cell.Borders[1].Width / 2 - Cell.Borders[3].Width / 2,
                  True, False);
              end;
              WrapWidth := CellWidth -
                Cell.Borders[0].Padding - Cell.Borders[2].Padding;

              if WrapWidth > 1 then
              begin
                StylePrefix := MakeCellPrefix(Cell);

                if Cell.MeasuredHeight = 0 then
                begin
                  Cell.MeasuredHeight := P.GetHTMLLimitedTextHeight(WrapWidth,
                    FMeasuredRowHeights[Row - 1] - Cell.Borders[1].Padding -
                    Cell.Borders[3].Padding, StylePrefix + Cell.HTMLText);
                end;

                if (Cell.Alignment >= caMiddleLeft) and (Cell.Alignment <= caMiddleRight) then
                begin
                  AlignOffset := (CellHeight -
                    Cell.Borders[1].Padding - Cell.Borders[3].Padding - Cell.MeasuredHeight) / 2;
                end else
                if (Cell.Alignment >= caBottomLeft) and (Cell.Alignment <= caBottomRight) then
                begin
                  AlignOffset := (CellHeight -
                    Cell.Borders[1].Padding - Cell.Borders[3].Padding - Cell.MeasuredHeight);
                end else
                  AlignOffset := 0;

                if (Cell.Alignment = caTopCenter) or (Cell.Alignment = caMiddleCenter) or
                  (Cell.Alignment = caBottomCenter) then
                begin
                  StylePrefix := '<p align=center>' + StylePrefix;
                end;

                if (Cell.Alignment = caTopRight) or (Cell.Alignment = caMiddleRight) or
                  (Cell.Alignment = caBottomRight) then
                begin
                  StylePrefix := '<p align=right>' + StylePrefix;
                end;

                if FRowHeights[Row - 1] = 0 then
                begin
                  P.DrawHTMLText(XPos + Cell.Borders[0].Padding,
                    YPos - Cell.Borders[1].Padding - AlignOffset, CellWidth -
                    Cell.Borders[0].Padding - Cell.Borders[2].Padding,
                    StylePrefix + Cell.HTMLText);
                end else
                begin
                  P.DrawHTMLTextBox(XPos + Cell.Borders[0].Padding,
                    YPos - Cell.Borders[1].Padding - AlignOffset, CellWidth -
                    Cell.Borders[0].Padding - Cell.Borders[2].Padding,
                    CellHeight - Cell.Borders[1].Padding - Cell.Borders[3].Padding,
                    StylePrefix + Cell.HTMLText);
                end;
              end;
              for Border := 1 to 4 do
              begin
                if (FThinBorders) then
                begin
                  P.SetLineWidth(0);
                  if (Length(FThinBorderColor) = 3) then
                  begin
                    P.SetLineColor(FThinBorderColor[0], FThinBorderColor[1],
                      FThinBorderColor[2]);
                  end else
                  if (Length(FThinBorderColor) = 4) then
                  begin
                    P.SetLineColor(FThinBorderColor[0], FThinBorderColor[1],
                      FThinBorderColor[2], FThinBorderColor[3]);
                  end;

                  // Right and bottom are drawn as the table border
                  case Border of
                    1: // Left border
                    begin
                      P.StartPath(XPos, YPos);
                      P.AddLineToPath(XPos, YPos - CellHeight);
                      P.DrawPath(False, True);
                    end;
                    2: // Top border
                    begin
                      P.StartPath(XPos, YPos);
                      P.AddLineToPath(XPos + CellWidth, YPos);
                      P.DrawPath(False, True);
                    end;
                  end;
                end else
                begin
                  DrawBorder := False;
                  if Cell.Borders[Border - 1].Width > 0 then
                  begin
                    if Length(Cell.Borders[Border - 1].Color) = 3 then
                    begin
                      P.SetFillColor(Cell.Borders[Border - 1].Color[0],
                        Cell.Borders[Border - 1].Color[1],
                        Cell.Borders[Border - 1].Color[2]);
                      DrawBorder := True;
                    end else
                    if Length(Cell.Borders[Border - 1].Color) = 4 then
                    begin
                      P.SetFillColor(Cell.Borders[Border - 1].Color[0],
                        Cell.Borders[Border - 1].Color[1],
                        Cell.Borders[Border - 1].Color[2],
                        Cell.Borders[Border - 1].Color[3]);
                      DrawBorder := True;
                    end;
                  end;
                  if DrawBorder then
                  begin
                    case Border of
                      1: // Left border
                      begin
                        P.StartPath(XPos, YPos);
                        P.AddLineToPath(XPos, YPos - CellHeight);
                        P.AddLineToPath(XPos + Cell.Borders[0].Width,
                          YPos - CellHeight + Cell.Borders[3].Width);
                        P.AddLineToPath(XPos + Cell.Borders[0].Width,
                          YPos - Cell.Borders[1].Width);
                        P.ClosePath;
                        P.DrawPath(True, False);
                      end;
                      2: // Top border
                      begin
                        P.StartPath(XPos, YPos);
                        P.AddLineToPath(XPos + CellWidth, YPos);
                        P.AddLineToPath(XPos + CellWidth - Cell.Borders[3].Width,
                          YPos - Cell.Borders[1].Width);
                        P.AddLineToPath(XPos + Cell.Borders[0].Width,
                          YPos - Cell.Borders[1].Width);
                        P.ClosePath;
                        P.DrawPath(True, False);
                      end;
                      3: // Right border
                      begin
                        P.StartPath(XPos + CellWidth, YPos);
                        P.AddLineToPath(XPos + CellWidth, YPos - CellHeight);
                        P.AddLineToPath(XPos + CellWidth - Cell.Borders[2].Width,
                          YPos - CellHeight + Cell.Borders[3].Width);
                        P.AddLineToPath(XPos + CellWidth - Cell.Borders[2].Width,
                          YPos - Cell.Borders[1].Width);
                        P.ClosePath;
                        P.DrawPath(True, False);
                      end;
                      4: // Bottom border
                      begin
                        P.StartPath(XPos, YPos - CellHeight);
                        P.AddLineToPath(XPos + CellWidth, YPos - CellHeight);
                        P.AddLineToPath(XPos + CellWidth - Cell.Borders[3].Width,
                          YPos - CellHeight + Cell.Borders[3].Width);
                        P.AddLineToPath(XPos + Cell.Borders[0].Width,
                          YPos - CellHeight + Cell.Borders[3].Width);
                        P.ClosePath;
                        P.DrawPath(True, False);
                      end;
                    end;
                  end;
                end;
              end;
            end else
            begin
              FCells[Row - 1][Column - 1].DrawnLeft := 0;
              FCells[Row - 1][Column - 1].DrawnTop := 0;
              FCells[Row - 1][Column - 1].DrawnWidth := 0;
              FCells[Row - 1][Column - 1].DrawnHeight := 0;
            end;
            XPos := XPos + FColumnWidths[Column - 1];
          end;
          FLastDrawnRow := Row;
          YPos := YPos - FMeasuredRowHeights[Row - 1];
          Result := Top - YPos; 
          TotalHeight := TotalHeight + FMeasuredRowHeights[Row - 1];
        end;
        Row := Row + 1;
      end;

      // Draw the table border
      for Border := 1 to 4 do
      begin
        if (FThinBorders) then
        begin
          P.SetLineWidth(0);
          if (Length(FThinBorderColor) = 3) then
          begin
            P.SetLineColor(FThinBorderColor[0], FThinBorderColor[1],
              FThinBorderColor[2]);
          end else
          if (Length(FThinBorderColor) = 4) then
          begin
            P.SetLineColor(FThinBorderColor[0], FThinBorderColor[1],
              FThinBorderColor[2], FThinBorderColor[3]);
          end;

          // Left and top are drawn by the cell
          case Border of
            3: // Right border
            begin
              P.StartPath(Left + TotalWidth, Top);
              P.AddLineToPath(Left + TotalWidth, Top - TotalHeight);
              P.DrawPath(False, True);
            end;
            4: // Bottom border
            begin
              P.StartPath(Left, Top - TotalHeight);
              P.AddLineToPath(Left + TotalWidth, Top - TotalHeight);
              P.DrawPath(False, True);
            end;
          end;
        end else
        begin
          DrawBorder := False;
          if FTableBorders[Border - 1].Width > 0 then
          begin
            if Length(FTableBorders[Border - 1].Color) = 3 then
            begin
              P.SetFillColor(FTableBorders[Border - 1].Color[0],
                FTableBorders[Border - 1].Color[1],
                FTableBorders[Border - 1].Color[2]);
              DrawBorder := True;
            end else
            if Length(FTableBorders[Border - 1].Color) = 4 then
            begin
              P.SetFillColor(FTableBorders[Border - 1].Color[0],
                FTableBorders[Border - 1].Color[1],
                FTableBorders[Border - 1].Color[2],
                FTableBorders[Border - 1].Color[3]);
              DrawBorder := True;
            end;
          end;
          if DrawBorder then
          begin
            case Border of
              1: // Left border
              begin
                P.StartPath(Left, Top);
                P.AddLineToPath(Left, Top - TotalHeight);
                P.AddLineToPath(Left - FTableBorders[0].Width,
                  Top - TotalHeight - FTableBorders[3].Width);
                P.AddLineToPath(Left - FTableBorders[0].Width,
                  Top + FTableBorders[1].Width);
                P.ClosePath;
                P.DrawPath(True, False);
              end;
              2: // Top border
              begin
                P.StartPath(Left, Top);
                P.AddLineToPath(Left + TotalWidth, Top);
                P.AddLineToPath(Left + TotalWidth + FTableBorders[3].Width,
                  Top + FTableBorders[1].Width);
                P.AddLineToPath(Left - FTableBorders[0].Width,
                  Top + FTableBorders[1].Width);
                P.ClosePath;
                P.DrawPath(True, False);
              end;
              3: // Right border
              begin
                P.StartPath(Left + TotalWidth, Top);
                P.AddLineToPath(Left + TotalWidth, Top - TotalHeight);
                P.AddLineToPath(Left + TotalWidth + FTableBorders[2].Width,
                  Top - TotalHeight - FTableBorders[3].Width);
                P.AddLineToPath(Left + TotalWidth + FTableBorders[2].Width,
                  Top + FTableBorders[1].Width);
                P.ClosePath;
                P.DrawPath(True, False);
              end;
              4: // Bottom border
              begin
                P.StartPath(Left, Top - TotalHeight);
                P.AddLineToPath(Left + TotalWidth, Top - TotalHeight);
                P.AddLineToPath(Left + TotalWidth + FTableBorders[3].Width,
                  Top - TotalHeight - FTableBorders[3].Width);
                P.AddLineToPath(Left - FTableBorders[0].Width,
                  Top - TotalHeight - FTableBorders[3].Width);
                P.ClosePath;
                P.DrawPath(True, False);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFTable.GetBorderRange(BorderIndex: Integer;
  var FirstBorder, LastBorder: Integer): Boolean;
begin
  Result := False;
  if (BorderIndex >= 0) and (BorderIndex <= 4) then
  begin
    if BorderIndex = 0 then
    begin
      FirstBorder := 1;
      LastBorder := 4;
    end else
    begin
      FirstBorder := BorderIndex;
      LastBorder := BorderIndex;
    end;
    Result := True;
  end;
end;

function TPDFTable.ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn: Integer): Boolean;
begin
  Result := (FirstRow >= 1) and (FirstColumn >= 1) and
    (LastRow <= Length(FRowHeights)) and (LastColumn <= Length(FColumnWidths)) and
    (LastRow >= FirstRow) and (LastColumn >= FirstColumn);
end;

function TPDFTable.GetTotalWidth: Double;
var
  Column: Integer;
begin
  Result := 0;
  for Column := 1 to Length(FColumnWidths) do
    Result := Result + FColumnWidths[Column - 1]; 
end;

function TPDFTable.InsertColumns(Position, NewColumnCount: Integer): Integer;
var
  Row: Integer;
  Column: Integer;
begin
  if NewColumnCount >= 1 then
  begin
    // Reset the table measurements
    SetLength(FMeasuredRowHeights, 0);

    // Insert the extra columns into the FColumnWidths array
    SetLength(FColumnWidths, Length(FColumnWidths) + NewColumnCount);
    for Column := Length(FColumnWidths) downto Position + NewColumnCount do
    begin
      FColumnWidths[Column - 1] := FColumnWidths[Column - 1 - NewColumnCount];
    end;
    for Column := Position to Position + NewColumnCount - 1 do
      FColumnWidths[Column - 1] := 0;

    // Insert the extra columns into the FCells array
    for Row := 1 to Length(FRowHeights) do
    begin
      SetLength(FCells[Row - 1], Length(FColumnWidths));
      for Column := Length(FColumnWidths) downto Position + NewColumnCount do
      begin
        FCells[Row - 1, Column - 1] := FCells[Row - 1, Column - 1 - NewColumnCount];
      end;
    end;

    for Row := 1 to Length(FRowHeights) do
    begin
      for Column := Position to Position + NewColumnCount - 1 do
      begin
        SetupDefaultRow(Row, Column);
      end;
    end;
  end;

  Result := Length(FColumnWidths);
end;

function TPDFTable.InsertRows(Position, NewRowCount: Integer): Integer;
var
  Row: Integer;
  Column: Integer;
begin
  if NewRowCount >= 1 then
  begin
    // Reset the table measurements
    SetLength(FMeasuredRowHeights, 0);

    // Insert the extra rows into the FRowHeights array
    SetLength(FRowHeights, Length(FRowHeights) + NewRowCount);
    for Row := Length(FRowHeights) downto Position + NewRowCount do
    begin
      FRowHeights[Row - 1] := FRowHeights[Row - 1 - NewRowCount];
    end;
    for Row := Position to Position + NewRowCount - 1 do
      FRowHeights[Row - 1] := 0;

    // Insert the extra rows into the FCells array
    SetLength(FCells, Length(FCells) + NewRowCount);
    for Row := Length(FCells) downto Position + NewRowCount do
    begin
      SetLength(FCells[Row - 1], Length(FColumnWidths));
      for Column := 1 to Length(FColumnWidths) do
      begin
        FCells[Row - 1, Column - 1] := FCells[Row - 1 - NewRowCount, Column - 1];
      end;
    end;

    for Row := Position to Position + NewRowCount - 1 do
    begin
      SetLength(FCells[Row - 1], Length(FColumnWidths));
      for Column := 1 to Length(FColumnWidths) do
      begin
        SetupDefaultRow(Row, Column);
      end;
    end;
  end;

  Result := Length(FRowHeights);
end;

procedure TPDFTable.MeasureRows(P: TPDFPainter);
var
  Row: Integer;
  TestRow: Integer;
  Column: Integer;
  Cell: TPDFTableCell;
  Height: Double;
  WrapWidth: Double;
  StylePrefix: WideString;
  SpanCount: Integer;
  TargetHeight: Double;
  TotalRowHeight: Double;
  AdjustRows: array of Integer;
  RowHeightDifference: Double;
  RowIndex: Integer;
begin
  SetLength(FMeasuredRowHeights, Length(FRowHeights));
  for Row := 1 to Length(FRowHeights) do
  begin
    if FRowHeights[Row - 1] = 0 then
    begin
      FMeasuredRowHeights[Row - 1] := 0;
      for Column := 1 to Length(FColumnWidths) do
      begin
        Cell := FCells[Row - 1][Column - 1];
        if not Cell.IgnoreMerge then
        begin
          WrapWidth := 0;
          for SpanCount := 1 to Cell.ColumnSpan do
          begin
            if (Column + SpanCount - 1) <= Length(FColumnWidths) then
              WrapWidth := WrapWidth + FColumnWidths[Column + SpanCount - 2];
          end;
          WrapWidth := WrapWidth -
            Cell.Borders[0].Padding - Cell.Borders[2].Padding;

          if WrapWidth > 1 then
          begin
            StylePrefix := MakeCellPrefix(Cell);
          
            if (Cell.Alignment = caTopCenter) or (Cell.Alignment = caMiddleCenter) or
              (Cell.Alignment = caBottomCenter) then
            begin
              StylePrefix := '<p align=center>' + StylePrefix;
            end;

            if (Cell.Alignment = caTopRight) or (Cell.Alignment = caMiddleRight) or
              (Cell.Alignment = caBottomRight) then
            begin
              StylePrefix := '<p align=right>' + StylePrefix;
            end;

            Cell.MeasuredHeight := P.GetHTMLTextHeightWithDescent(WrapWidth, StylePrefix + Cell.HTMLText);
            Height := Cell.MeasuredHeight + Cell.Borders[1].Padding + Cell.Borders[3].Padding;
          end else
            Height := 0;

          if Cell.RowSpan = 1 then
          begin
            if Height > FMeasuredRowHeights[Row - 1] then
              FMeasuredRowHeights[Row - 1] := Height;
          end;
          FCells[Row - 1][Column - 1] := Cell;
        end;
      end;
    end else
    begin
      FMeasuredRowHeights[Row - 1] := FRowHeights[Row - 1];
      for Column := 1 to Length(FColumnWidths) do
      begin
        Cell := FCells[Row - 1][Column - 1];
        Cell.MeasuredHeight := 0;
        FCells[Row - 1][Column - 1] := Cell;
      end;
    end;
  end;

  for Row := 1 to Length(FRowHeights) do
  begin
    for Column := 1 to Length(FColumnWidths) do
    begin
      Cell := FCells[Row - 1][Column - 1];
      if Cell.RowSpan > 0 then
      begin
        SetLength(AdjustRows, 0);      
        TargetHeight := Cell.MeasuredHeight + Cell.Borders[1].Padding + Cell.Borders[3].Padding;
        TotalRowHeight := 0;
        for TestRow := Row to Row + Cell.RowSpan - 1 do
        begin
          if FRowHeights[TestRow - 1] = 0 then
          begin
            SetLength(AdjustRows, Length(AdjustRows) + 1);
            AdjustRows[Length(AdjustRows) - 1] := TestRow;
            TotalRowHeight := TotalRowHeight + FMeasuredRowHeights[TestRow - 1];
          end;
        end;
        RowHeightDifference := TargetHeight - TotalRowHeight;
        if (RowHeightDifference > 0) and (Length(AdjustRows) > 0) then
        begin
          RowHeightDifference := RowHeightDifference / Length(AdjustRows);
          for RowIndex := 0 to Length(AdjustRows) - 1 do
          begin
            FMeasuredRowHeights[AdjustRows[RowIndex] - 1] :=
              FMeasuredRowHeights[AdjustRows[RowIndex] - 1] +
              RowHeightDifference;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFTable.MergeCells(FirstRow, FirstColumn, LastRow, LastColumn: Integer): Boolean;
var
  Row, Column: Integer;
  RowSpan, ColumnSpan: Integer;
  Cell: TPDFTableCell;
begin
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    Result := True;

    RowSpan := LastRow - FirstRow + 1;
    ColumnSpan := LastColumn - FirstColumn + 1;

    Cell := FCells[FirstRow - 1][FirstColumn - 1];

    for Row := FirstRow to FirstRow + Cell.RowSpan - 1 do
      for Column := FirstColumn to FirstColumn + Cell.ColumnSpan - 1 do
      begin
        if (Row <> FirstRow) or (Column <> FirstColumn) then
          FCells[Row - 1][Column - 1].IgnoreMerge := False;
      end;

    Cell.RowSpan := RowSpan;
    Cell.ColumnSpan := ColumnSpan;

    for Row := FirstRow to FirstRow + Cell.RowSpan - 1 do
      for Column := FirstColumn to FirstColumn + Cell.ColumnSpan - 1 do
      begin
        if (Row <> FirstRow) or (Column <> FirstColumn) then
          FCells[Row - 1][Column - 1].IgnoreMerge := True;
      end;

    FCells[FirstRow - 1][FirstColumn - 1] := Cell;
  end else
    Result := False;
end;

function TPDFTable.SetBackgroundColor(FirstRow, FirstColumn, LastRow, LastColumn: Integer;
  Red, Green, Blue: Double): Boolean;
var
  Row, Column: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    Result := True;
    for Row := FirstRow to LastRow do
    begin
      for Column := FirstColumn to LastColumn do
      begin
        SetLength(FCells[Row - 1][Column - 1].BackgroundColor, 3);
        FCells[Row - 1][Column - 1].BackgroundColor[0] := Red;
        FCells[Row - 1][Column - 1].BackgroundColor[1] := Green;
        FCells[Row - 1][Column - 1].BackgroundColor[2] := Blue;
      end;
    end;
  end;
end;

function TPDFTable.SetBackgroundColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn: Integer;
  C, M, Y, K: Double): Boolean;
var
  Row, Column: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    Result := True;
    for Row := FirstRow to LastRow do
    begin
      for Column := FirstColumn to LastColumn do
      begin
        SetLength(FCells[Row - 1][Column - 1].BackgroundColor, 4);
        FCells[Row - 1][Column - 1].BackgroundColor[0] := C;
        FCells[Row - 1][Column - 1].BackgroundColor[1] := M;
        FCells[Row - 1][Column - 1].BackgroundColor[2] := Y;
        FCells[Row - 1][Column - 1].BackgroundColor[3] := K;
      end;
    end;
  end;
end;

function TPDFTable.SetBorderColor(FirstRow, FirstColumn, LastRow, LastColumn,
  BorderIndex: Integer; Red, Green, Blue: Double): Boolean;
var
  FirstBorder, LastBorder: Integer;
  Row, Column, Border: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    if GetBorderRange(BorderIndex, FirstBorder, LastBorder) then
    begin
      Result := True;
      for Row := FirstRow to LastRow do
      begin
        for Column := FirstColumn to LastColumn do
        begin
          for Border := FirstBorder to LastBorder do
          begin
            SetLength(FCells[Row - 1][Column - 1].Borders[Border - 1].Color, 3);
            FCells[Row - 1][Column - 1].Borders[Border - 1].Color[0] := Red;
            FCells[Row - 1][Column - 1].Borders[Border - 1].Color[1] := Green;
            FCells[Row - 1][Column - 1].Borders[Border - 1].Color[2] := Blue;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFTable.SetBorderColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn,
  BorderIndex: Integer; C, M, Y, K: Double): Boolean;
var
  FirstBorder, LastBorder: Integer;
  Row, Column, Border: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    if GetBorderRange(BorderIndex, FirstBorder, LastBorder) then
    begin
      Result := True;
      for Row := FirstRow to LastRow do
      begin
        for Column := FirstColumn to LastColumn do
        begin
          for Border := FirstBorder to LastBorder do
          begin
            SetLength(FCells[Row - 1][Column - 1].Borders[Border - 1].Color, 4);
            FCells[Row - 1][Column - 1].Borders[Border - 1].Color[0] := C;
            FCells[Row - 1][Column - 1].Borders[Border - 1].Color[1] := M;
            FCells[Row - 1][Column - 1].Borders[Border - 1].Color[2] := Y;
            FCells[Row - 1][Column - 1].Borders[Border - 1].Color[3] := K;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFTable.SetBorderPadding(FirstRow, FirstColumn, LastRow, LastColumn,
  BorderIndex: Integer; NewPadding: Double): Boolean;
var
  FirstBorder, LastBorder: Integer;
  Row, Column, Border: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    if GetBorderRange(BorderIndex, FirstBorder, LastBorder) then
    begin
      Result := True;
      for Row := FirstRow to LastRow do
      begin
        for Column := FirstColumn to LastColumn do
        begin
          for Border := FirstBorder to LastBorder do
          begin
            FCells[Row - 1][Column - 1].Borders[Border - 1].Padding := NewPadding;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFTable.SetBorderWidth(FirstRow, FirstColumn, LastRow, LastColumn,
  BorderIndex: Integer; NewWidth: Double): Boolean;
var
  FirstBorder, LastBorder: Integer;
  Row, Column, Border: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    if GetBorderRange(BorderIndex, FirstBorder, LastBorder) then
    begin
      Result := True;
      for Row := FirstRow to LastRow do
      begin
        for Column := FirstColumn to LastColumn do
        begin
          for Border := FirstBorder to LastBorder do
          begin
            FCells[Row - 1][Column - 1].Borders[Border - 1].Width := NewWidth;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFTable.SetCellAlignment(FirstRow, FirstColumn, LastRow, LastColumn,
  NewCellAlignment: Integer): Boolean;
var
  Row, Column: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) and
    (NewCellAlignment >= Ord(Low(TPDFTableCellAlignment))) and
    (NewCellAlignment <= Ord(High(TPDFTableCellAlignment))) then
  begin
    Result := True;
    for Row := FirstRow to LastRow do
    begin
      for Column := FirstColumn to LastColumn do
      begin
        FCells[Row - 1][Column - 1].Alignment := TPDFTableCellAlignment(NewCellAlignment);
      end;
    end;
  end;
end;

function TPDFTable.SetCellContent(RowNumber, ColumnNumber: Integer;
  HTMLText: WideString): Boolean;
begin
  SetLength(FMeasuredRowHeights, 0);
  Result := False;
  if (RowNumber >= 1) and (RowNumber <= Length(FRowHeights)) and
    (ColumnNumber >= 1) and (ColumnNumber <= Length(FColumnWidths)) then
  begin
    Result := True;
    FCells[RowNumber - 1][ColumnNumber - 1].HTMLText := HTMLText;
  end;
end;

function TPDFTable.SetColumnWidth(FirstColumn, LastColumn: Integer;
  NewWidth: Double): Boolean;
var
  Column: Integer;
begin
  SetLength(FMeasuredRowHeights, 0);
  Result := False;

  if (FirstColumn >= 1) and (LastColumn <= Length(FColumnWidths)) and (LastColumn >= FirstColumn) then
  begin
    Result := True;
    for Column := FirstColumn to LastColumn do
    begin
      FColumnWidths[Column - 1] := NewWidth;
    end;
  end;
end;

function TPDFTable.SetRowHeight(FirstRow, LastRow: Integer;
  NewHeight: Double): Boolean;
var
  Row: Integer;
begin
  SetLength(FMeasuredRowHeights, 0);
  Result := False;

  if (FirstRow >= 1) and (LastRow <= Length(FRowHeights)) and (LastRow >= FirstRow) then
  begin
    Result := True;
    for Row := FirstRow to LastRow do
    begin
      FRowHeights[Row - 1] := NewHeight;
    end;
  end;
end;

function TPDFTable.SetTableBorderColor(BorderIndex: Integer; Red, Green,
  Blue: Double): Boolean;
var
  Border: Integer;
  FirstBorder, LastBorder: Integer;
begin
  if GetBorderRange(BorderIndex, FirstBorder, LastBorder) then
  begin
    Result := True;
    for Border := FirstBorder to LastBorder do
    begin
      SetLength(FTableBorders[Border - 1].Color, 3);
      FTableBorders[Border - 1].Color[0] := Red;
      FTableBorders[Border - 1].Color[1] := Green;
      FTableBorders[Border - 1].Color[2] := Blue;
    end;
  end else
    Result := False;
end;

function TPDFTable.SetTableBorderColorCMYK(BorderIndex: Integer; C, M, Y,
  K: Double): Boolean;
var
  Border: Integer;
  FirstBorder, LastBorder: Integer;
begin
  if GetBorderRange(BorderIndex, FirstBorder, LastBorder) then
  begin
    Result := True;
    for Border := FirstBorder to LastBorder do
    begin
      SetLength(FTableBorders[Border - 1].Color, 4);
      FTableBorders[Border - 1].Color[0] := C;
      FTableBorders[Border - 1].Color[1] := M;
      FTableBorders[Border - 1].Color[2] := Y;
      FTableBorders[Border - 1].Color[3] := K;
    end;
  end else
    Result := False;
end;

function TPDFTable.SetTableBorderWidth(BorderIndex: Integer;
  NewWidth: Double): Boolean;
var
  Border: Integer;
  FirstBorder, LastBorder: Integer;
begin
  if GetBorderRange(BorderIndex, FirstBorder, LastBorder) then
  begin
    Result := True;
    for Border := FirstBorder to LastBorder do
      FTableBorders[Border - 1].Width := NewWidth;
  end else
    Result := False;
end;

function TPDFTable.SetTextColor(FirstRow, FirstColumn, LastRow,
  LastColumn: Integer; Red, Green, Blue: Double): Boolean;
var
  Row, Column: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) and
    (Red >= 0) and (Red <= 1) and (Green >= 0) and (Green <= 1) and
    (Blue >= 0) and (Blue <= 1) then
  begin
    Result := True;
    for Row := FirstRow to LastRow do
    begin
      for Column := FirstColumn to LastColumn do
      begin
        SetLength(FCells[Row - 1][Column - 1].TextColor, 3);
        FCells[Row - 1][Column - 1].TextColor[0] := Red;
        FCells[Row - 1][Column - 1].TextColor[1] := Green;
        FCells[Row - 1][Column - 1].TextColor[2] := Blue;
      end;
    end;
  end;
end;

function TPDFTable.SetTextColorCMYK(FirstRow, FirstColumn, LastRow,
  LastColumn: Integer; C, M, Y, K: Double): Boolean;
var
  Row, Column: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) and
    (C >= 0) and (C <= 1) and (M >= 0) and (M <= 1) and (Y >= 0) and
    (Y <= 1) and (K >= 0) and (K <= 1) then
  begin
    Result := True;
    for Row := FirstRow to LastRow do
    begin
      for Column := FirstColumn to LastColumn do
      begin
        SetLength(FCells[Row - 1][Column - 1].TextColor, 4);
        FCells[Row - 1][Column - 1].TextColor[0] := C;
        FCells[Row - 1][Column - 1].TextColor[1] := M;
        FCells[Row - 1][Column - 1].TextColor[2] := Y;
        FCells[Row - 1][Column - 1].TextColor[3] := K;
      end;
    end;
  end;
end;

function TPDFTable.SetTextSize(FirstRow, FirstColumn, LastRow,
  LastColumn: Integer; NewTextSize: Double): Boolean;
var
  Row, Column: Integer;
begin
  Result := False;
  if ValidCellRange(FirstRow, FirstColumn, LastRow, LastColumn) then
  begin
    Result := True;
    for Row := FirstRow to LastRow do
    begin
      for Column := FirstColumn to LastColumn do
      begin
        FCells[Row - 1][Column - 1].TextSize := NewTextSize;
      end;
    end;
  end;
end;

procedure TPDFTable.SetThinBorders(NewThinBorders: Boolean; Red, Green, Blue: Double);
begin
  FThinBorders := NewThinBorders;
  SetLength(FThinBorderColor, 3);
  FThinBorderColor[0] := Red;
  FThinBorderColor[1] := Green;
  FThinBorderColor[2] := Blue;
end;

procedure TPDFTable.SetThinBordersCMYK(NewThinBorders: Boolean; C, M, Y, K: Double);
begin
  FThinBorders := NewThinBorders;
  SetLength(FThinBorderColor, 4);
  FThinBorderColor[0] := C;
  FThinBorderColor[1] := M;
  FThinBorderColor[2] := Y;
  FThinBorderColor[3] := K;
end;

function TPDFTable.MakeCellPrefix(Cell: TPDFTableCell): WideString;
var
  TC: WideString;
begin
  Result := '';
  if Cell.TextSize > 0 then
    Result := '<font size=' + WideString(QPLDoubleToStr(Cell.TextSize, 2)) + 'pt';
  TC := CellColorToHex(Cell);
  if TC <> '' then
  begin
    if Result = '' then Result := '<font';
    Result := Result + ' color=' + TC;
  end;
  if Result <> '' then
    Result := Result + '>';
end;

function TPDFTable.GetLastDrawnRow: Integer;
begin
  Result := FLastDrawnRow;
end;

function TPDFTable.GetCellDblProperty(RowNumber, ColumnNumber,
  Tag: Integer): Double;
var
  Cell: TPDFTableCell;
begin
  Result := 0;
  if (RowNumber >= 1) and (RowNumber <= Length(FRowHeights)) and
    (ColumnNumber >= 1) and (ColumnNumber <= Length(FColumnWidths)) then
  begin
    Cell := FCells[RowNumber - 1][ColumnNumber - 1];
    case Tag of
      101: Result := Cell.DrawnLeft;
      102: Result := Cell.DrawnTop;
      103: Result := Cell.DrawnWidth;
      104: Result := Cell.DrawnHeight;

      105: Result := Cell.TextSize;

      106: if Length(Cell.BackgroundColor) >= 1 then Result := Cell.BackgroundColor[0];
      107: if Length(Cell.BackgroundColor) >= 2 then Result := Cell.BackgroundColor[1];
      108: if Length(Cell.BackgroundColor) >= 3 then Result := Cell.BackgroundColor[2];
      109: if Length(Cell.BackgroundColor) >= 4 then Result := Cell.BackgroundColor[3];

      110: if Length(Cell.TextColor) >= 1 then Result := Cell.TextColor[0];
      111: if Length(Cell.TextColor) >= 2 then Result := Cell.TextColor[1];
      112: if Length(Cell.TextColor) >= 3 then Result := Cell.TextColor[2];
      113: if Length(Cell.TextColor) >= 4 then Result := Cell.TextColor[3];

      114: if Length(Cell.Borders[0].Color) >= 1 then Result := Cell.Borders[0].Color[0];
      115: if Length(Cell.Borders[1].Color) >= 1 then Result := Cell.Borders[1].Color[0];
      116: if Length(Cell.Borders[2].Color) >= 1 then Result := Cell.Borders[2].Color[0];
      117: if Length(Cell.Borders[3].Color) >= 1 then Result := Cell.Borders[3].Color[0];

      118: if Length(Cell.Borders[0].Color) >= 2 then Result := Cell.Borders[0].Color[1];
      119: if Length(Cell.Borders[1].Color) >= 2 then Result := Cell.Borders[1].Color[1];
      120: if Length(Cell.Borders[2].Color) >= 2 then Result := Cell.Borders[2].Color[1];
      121: if Length(Cell.Borders[3].Color) >= 2 then Result := Cell.Borders[3].Color[1];

      122: if Length(Cell.Borders[0].Color) >= 3 then Result := Cell.Borders[0].Color[2];
      123: if Length(Cell.Borders[1].Color) >= 3 then Result := Cell.Borders[1].Color[2];
      124: if Length(Cell.Borders[2].Color) >= 3 then Result := Cell.Borders[2].Color[2];
      125: if Length(Cell.Borders[3].Color) >= 3 then Result := Cell.Borders[3].Color[2];

      126: if Length(Cell.Borders[0].Color) >= 4 then Result := Cell.Borders[0].Color[3];
      127: if Length(Cell.Borders[1].Color) >= 4 then Result := Cell.Borders[1].Color[3];
      128: if Length(Cell.Borders[2].Color) >= 4 then Result := Cell.Borders[2].Color[3];
      129: if Length(Cell.Borders[3].Color) >= 4 then Result := Cell.Borders[3].Color[3];

      130: Result := Cell.Borders[0].Padding;
      131: Result := Cell.Borders[1].Padding;
      132: Result := Cell.Borders[2].Padding;
      133: Result := Cell.Borders[3].Padding;

      134: Result := Cell.Borders[0].Width;
      135: Result := Cell.Borders[1].Width;
      136: Result := Cell.Borders[2].Width;
      137: Result := Cell.Borders[3].Width;
    end;
  end;
end;

function TPDFTable.GetCellIntProperty(RowNumber, ColumnNumber,
  Tag: Integer): Integer;
var
  Cell: TPDFTableCell;
begin
  Result := 0;
  if (RowNumber >= 1) and (RowNumber <= Length(FRowHeights)) and
    (ColumnNumber >= 1) and (ColumnNumber <= Length(FColumnWidths)) then
  begin
    Cell := FCells[RowNumber - 1][ColumnNumber - 1];
    case Tag of
      201: Result := Integer(Cell.Alignment);
      202: Result := Cell.RowSpan;
      203: Result := Cell.ColumnSpan;
      204: Result := Length(Cell.BackgroundColor);
      205: Result := Length(Cell.TextColor);
      206: Result := Length(Cell.Borders[0].Color);
      207: Result := Length(Cell.Borders[1].Color);
      208: Result := Length(Cell.Borders[2].Color);
      209: Result := Length(Cell.Borders[3].Color);
    end;
  end;
end;

function TPDFTable.GetCellStrProperty(RowNumber, ColumnNumber,
  Tag: Integer): WideString;
var
  Cell: TPDFTableCell;
begin
  Result := '';
  if (RowNumber >= 1) and (RowNumber <= Length(FRowHeights)) and
    (ColumnNumber >= 1) and (ColumnNumber <= Length(FColumnWidths)) then
  begin
    Cell := FCells[RowNumber - 1][ColumnNumber - 1];
    case Tag of
      301: Result := Cell.HTMLText;
    end;
  end;
end;

function TPDFTable.CellColorToHex(Cell: TPDFTableCell): WideString;
begin
  Result := '';
  if Length(Cell.TextColor) = 3 then
    Result := WideString('#' + QPLIntToHex(Round(Cell.TextColor[0] * 255), 2) +
      QPLIntToHex(Round(Cell.TextColor[1] * 255), 2) +
      QPLIntToHex(Round(Cell.TextColor[2] * 255), 2));
  if Length(Cell.TextColor) = 4 then
    Result := WideString(QPLIntToHex(Round(Cell.TextColor[0] * 255), 2) +
      QPLIntToHex(Round(Cell.TextColor[1] * 255), 2) +
      QPLIntToHex(Round(Cell.TextColor[2] * 255), 2) +
      QPLIntToHex(Round(Cell.TextColor[3] * 255), 2));
end;

function TPDFTable.GetColumnCount: Integer;
begin
  Result := Length(FColumnWidths);
end;

function TPDFTable.GetRowCount: Integer;
begin
  Result := Length(FRowHeights);
end;

end.
