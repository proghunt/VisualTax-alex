Unit vtColorPatternSelect;

//20201207 Igor a lot of changes in unit

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Printers, vtVirtualTaxOffice, System.UITypes, Vcl.ComCtrls, Jpeg, Vcl.ImgList,
  Vcl.Menus, UIConsts, GraphUtil;

type
  TColorRecord = record
    Number: string;
    Hex: string;
    Color: TColor;
    Name: string;
  end;

type
  TBasicColor = record
    Color: TColor;
    X: integer;
    Y: integer;
  end;

type
  TvtColorPatternSelect = class(TForm)
    pnlButtons: TPanel;
    pgMain: TPageControl;
    tabColor: TTabSheet;
    tabPattern: TTabSheet;
    btnSave: TButton;
    btnCancel: TButton;
    sbNavigation: TScrollBox;
    pnlColorInfo: TPanel;
    lbColorName: TLabel;
    sgColors: TStringGrid;
    meColors: TMemo;
    pbColors: TPaintBox;
    pnlContainer: TPanel;
    edColorNumber: TEdit;
    Label1: TLabel;
    edColorHex: TEdit;
    Label2: TLabel;
    edColorName: TEdit;
    lvPatterns: TListView;
    pbPattern: TPaintBox;
    pmPatterns: TPopupMenu;
    Reloadpatterns1: TMenuItem;
    tabBasicColor: TTabSheet;
    btnSearchColor: TSpeedButton;
    pbBasicColors: TPaintBox;
    pbBrightness: TPaintBox;
    pnlBasicColors: TPanel;
    lbBrightness: TLabel;
    shBasicColor: TShape;
    lbBasicColor: TLabel;
    lbHue: TLabel;
    edHue: TEdit;
    lbSat: TLabel;
    edSat: TEdit;
    lbLum: TLabel;
    edLum: TEdit;
    lbRed: TLabel;
    lbGreen: TLabel;
    lbBlue: TLabel;
    edBlue: TEdit;
    edGreen: TEdit;
    edRed: TEdit;
    lbBasicColorsCaption: TLabel;
    sgBasicColors: TStringGrid;
    pnlDrawBackground: TPanel;
    sgCustomPatColors: TStringGrid;
    btnAddCustom: TButton;
    procedure pgMainResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pbColorsPaint(Sender: TObject);
    procedure pbColorsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sgColorsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgColorsClick(Sender: TObject);
    procedure pbPatternPaint(Sender: TObject);
    procedure lvPatternsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure Reloadpatterns1Click(Sender: TObject); //20210304 Igor
    procedure btnSearchColorClick(Sender: TObject);
    procedure pbBasicColorsPaint(Sender: TObject);
    procedure pbBrightnessPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbBrightnessMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbBrightnessMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbBrightnessMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbBasicColorsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbBasicColorsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbBasicColorsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sgBasicColorsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgBasicColorsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure pbBrightnessMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbBrightnessMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbBrightnessMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure BasicColorManualHLSChange(Sender: TObject);
    procedure BasicColorManualRGBChange(Sender: TObject);
    procedure pgMainChange(Sender: TObject); //20210312 Igor
    //20210330 Igor >>>
    procedure sgCustomPatColorsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnAddCustomClick(Sender: TObject);
    procedure sgCustomPatColorsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    //20210330 Igor <<<
  private
    { Private declarations }
    FColors: TArray<TColorRecord>;
    FCurrColumn: integer;
    FCellWidth: integer;
    FCellHeight: integer;
    FSelectedValue: string;
    arrBasicColors: array[0..239,0..240] of TBasicColor;
    arrBasicPalette: array[0..47] of TColor;
    FBrightnessMoving: boolean;
    FBrightnessPaintBoxMoving: boolean;
    FBrightnessOldY: integer;
    FBasicColorX, FBasicColorY: integer;
    FBasicColorMoving: boolean;
    FBasicColorH, FBasicColorW: integer;
    SkipBasicColorPositioning: boolean;
    FBasicColorBackground: TBitmap;
    SkipBasicColorsEditsChange: boolean;
    function GetBasicColor: TColor;
    procedure SetBasicColor(const Value: TColor);
  protected
    procedure Init(AValue: string; AHidePatterns: boolean = false);
    procedure InitValue(AValue: string); //20210330 Igor
    procedure InitColors;
    procedure RefreshColorInfo;
    procedure InitPatterns;
    procedure InitBasicColors;
    procedure InitBasicPalette;
    procedure ShowBasicColor;
    procedure AdjustBasicColorPositions;
    procedure ProcessBasicColorsClick(X, Y: integer);
    procedure UpdateBrightness;
    procedure InitBasicColorCoordinates;
  public
    { Public declarations }
    property BasicColor: TColor read GetBasicColor write SetBasicColor;
  end;

  function RunColorPatternSelect(var AValue: string): boolean;
  function RunOnlyColorSelect(var AColor: TColor): boolean;

implementation

{$R *.dfm}

Uses
  Variants, Math, vtCommon;

function RunColorPatternSelect(var AValue: string): boolean;
var FvtColorPatternSelect: TvtColorPatternSelect;
begin
  FvtColorPatternSelect := TvtColorPatternSelect.Create(Screen.ActiveForm);
  try
    FvtColorPatternSelect.Init(AValue);
    Result := FvtColorPatternSelect.ShowModal = mrOk;
    if Result then
      AValue := FvtColorPatternSelect.FSelectedValue;
  finally
    FvtColorPatternSelect.Free;
  end;
end;

function RunOnlyColorSelect(var AColor: TColor): boolean;
var FvtColorPatternSelect: TvtColorPatternSelect;
begin
  FvtColorPatternSelect := TvtColorPatternSelect.Create(Screen.ActiveForm);
  try
    FvtColorPatternSelect.Init(TColorToWeb(AColor), true);
    Result := FvtColorPatternSelect.ShowModal = mrOk;
    if Result then
      AColor := WebToTColor(FvtColorPatternSelect.FSelectedValue);
  finally
    FvtColorPatternSelect.Free;
  end;
end;

procedure TvtColorPatternSelect.AdjustBasicColorPositions;
begin
  TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil,
          procedure
             begin
               BasicColor := BasicColor;
             end)
      end).Start;
end;

procedure TvtColorPatternSelect.btnAddCustomClick(Sender: TObject); //20210330 Igor
var
  _value: String;
begin
  _value := _value.Empty;

  if pgMain.ActivePage = tabColor then
    _value := edColorHex.Text
  else
    if pgMain.ActivePage = tabBasicColor then
      _value := TColorToWeb(BasicColor)
    else
      if Assigned(lvPatterns.Selected) then
        _value := VirtualTaxOfficeInfo.Patterns[lvPatterns.Selected.ImageIndex].FileName
      else
        ShowMessage('Please, select pattern');

  if not _value.IsEmpty then
  begin
    with VirtualTaxOfficeInfo.CustomPatColors do
    begin
      if Count = 10 then
        Delete(0);

      Append(_value);
    end;

    sgCustomPatColors.Invalidate;
  end;
end;

procedure TvtColorPatternSelect.btnSaveClick(Sender: TObject);
begin
  if pgMain.ActivePage = tabColor then
    FSelectedValue := edColorHex.Text
  else if pgMain.ActivePage = tabBasicColor then
    FSelectedValue := TColorToWeb(BasicColor)
  else
  begin
    if not Assigned(lvPatterns.Selected) then
    begin
      ShowMessage('Please, select pattern');
      Exit;
    end;
    FSelectedValue := VirtualTaxOfficeInfo.Patterns[lvPatterns.Selected.ImageIndex].FileName;
  end;
  ModalResult := mrOk;
end;

procedure TvtColorPatternSelect.btnSearchColorClick(Sender: TObject); //20210312 Igor
var cSearch: string;
    I, nIndex: integer;
begin
  cSearch := '';
  if not InputQuery('Enter Color Number or Name', 'Color Number or Name', cSearch) then Exit;
  nIndex := -1;
  for I := 0 to Length(FColors) - 1 do
    if SameText(FColors[I].Hex, cSearch) or
       SameText(FColors[I].Name, cSearch) or
       SameText(FColors[I].Number, cSearch) then
    begin
      nIndex := I;
      break;
    end;
  if nIndex <> -1 then
  begin
    FCurrColumn := nIndex div sgColors.RowCount;
    if FCurrColumn + sgColors.ColCount > Ceil(Length(FColors) / sgColors.RowCount) then
      FCurrColumn := Ceil(Length(FColors) / sgColors.RowCount) - sgColors.ColCount;
    sgColors.Col := (nIndex - FCurrColumn * sgColors.RowCount) div sgColors.RowCount;
    sgColors.Row := (nIndex - FCurrColumn * sgColors.RowCount) mod sgColors.RowCount;
    pbColors.Repaint;
    sgColors.Repaint;
    RefreshColorInfo;
  end
  else
    ShowMessage('Color was not found');
end;

function CheckValue(AValue, AMax: integer): integer;
begin
  if AValue > AMax then
    AValue := AMax;
  if AValue < 0 then
    AValue := 0;
  Result := AValue;
end;

procedure TvtColorPatternSelect.BasicColorManualRGBChange(Sender: TObject);
var R, G, B: Byte;
begin
  if SkipBasicColorsEditsChange then Exit;
  R := CheckValue(StrToIntDef(edRed.Text, 0), 255);
  G := CheckValue(StrToIntDef(edGreen.Text, 0), 255);
  B := CheckValue(StrToIntDef(edBlue.Text, 0), 255);
  BasicColor := Rgb(R, G, B);
end;

procedure TvtColorPatternSelect.BasicColorManualHLSChange(Sender: TObject);
var H, L, S: Word;
begin
  if SkipBasicColorsEditsChange then Exit;
  H := CheckValue(StrToIntDef(edHue.Text, 0), 239);
  L := CheckValue(StrToIntDef(edLum.Text, 0), 240);
  S := CheckValue(StrToIntDef(edSat.Text, 0), 240);
  BasicColor := ColorHLSToRGB(H, L, S);
end;

procedure TvtColorPatternSelect.FormCreate(Sender: TObject);
begin
  FBrightnessMoving := false;
  FBrightnessPaintBoxMoving := false;
  SkipBasicColorPositioning := false;
  SkipBasicColorsEditsChange := false;
  FBasicColorX := 2;
  FBasicColorY := 2;
  FBasicColorMoving := false;
  pbBasicColors.ControlStyle := pbBasicColors.ControlStyle + [csOpaque];
  pnlBasicColors.ControlStyle := pnlBasicColors.ControlStyle + [csOpaque];
end;

procedure TvtColorPatternSelect.FormDestroy(Sender: TObject);
begin
  if Assigned(FBasicColorBackground) then
    FreeAndNil(FBasicColorBackground);
end;

procedure TvtColorPatternSelect.FormShow(Sender: TObject);
begin
  FBasicColorW := pbBasicColors.Width;
  FBasicColorH := pbBasicColors.Height;
  pgMainResize(nil);
  if (pgMain.ActivePage = tabPattern) and Assigned(lvPatterns.Selected) then
    lvPatterns.Items[lvPatterns.Selected.Index].MakeVisible(false);
  TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil,
          procedure
             begin
               BasicColor := BasicColor;
             end)
      end).Start;
end;

function TvtColorPatternSelect.GetBasicColor: TColor;
begin
  Result := shBasicColor.Brush.Color;
end;

procedure TvtColorPatternSelect.Init(AValue: string; AHidePatterns: boolean = false);
begin
  InitBasicColors;
  InitBasicPalette;
  InitColors;
  InitPatterns;
  FCurrColumn := 0;
  BasicColor := Rgb(255, 0, 0);
  if AHidePatterns then
    tabPattern.TabVisible := false;
  InitValue(AValue); //20210330 Igor
end;

procedure TvtColorPatternSelect.InitBasicColorCoordinates;
var Hue, Lum, Sat: Word;
begin
  if (FBasicColorX = 0) or (FBasicColorY = 0) then
  begin
    ColorRGBToHLS(ColorToRGB(BasicColor), Hue, Lum, Sat);
    FBasicColorX := arrBasicColors[Hue, Sat].X;
    FBasicColorY := arrBasicColors[Hue, Sat].Y;
  end;
end;

procedure TvtColorPatternSelect.InitBasicColors;
var I, J: integer;
    Hue, Lum, Sat: Word;
begin
  Lum := 120;
  for Hue := 0 to 239 do
    for Sat := 0 to 240 do
      arrBasicColors[Hue, Sat].Color := ColorHLSToRGB(Hue, Lum, Sat);
end;

procedure TvtColorPatternSelect.InitBasicPalette;
begin
  arrBasicPalette[0] := Rgb(255, 128, 128);
  arrBasicPalette[1] := Rgb(255, 255, 128);
  arrBasicPalette[2] := Rgb(128, 255, 128);
  arrBasicPalette[3] := Rgb(0, 255, 128);
  arrBasicPalette[4] := Rgb(128, 255, 255);
  arrBasicPalette[5] := Rgb(0, 128, 255);
  arrBasicPalette[6] := Rgb(255, 128, 192);
  arrBasicPalette[7] := Rgb(255, 128, 255);

  arrBasicPalette[8] := Rgb(255, 0, 0);
  arrBasicPalette[9] := Rgb(255, 255, 0);
  arrBasicPalette[10] := Rgb(128, 255, 0);
  arrBasicPalette[11] := Rgb(0, 255, 64);
  arrBasicPalette[12] := Rgb(0, 255, 255);
  arrBasicPalette[13] := Rgb(0, 128, 192);
  arrBasicPalette[14] := Rgb(128, 128, 192);
  arrBasicPalette[15] := Rgb(255, 0, 255);

  arrBasicPalette[16] := Rgb(128, 64, 64);
  arrBasicPalette[17] := Rgb(255, 128, 64);
  arrBasicPalette[18] := Rgb(0, 255, 0);
  arrBasicPalette[19] := Rgb(0, 128, 128);
  arrBasicPalette[20] := Rgb(0, 64, 128);
  arrBasicPalette[21] := Rgb(128, 128, 255);
  arrBasicPalette[22] := Rgb(128, 0, 64);
  arrBasicPalette[23] := Rgb(255, 0, 128);

  arrBasicPalette[24] := Rgb(128, 0, 0);
  arrBasicPalette[25] := Rgb(255, 128, 0);
  arrBasicPalette[26] := Rgb(0, 128, 0);
  arrBasicPalette[27] := Rgb(0, 128, 64);
  arrBasicPalette[28] := Rgb(0, 0, 255);
  arrBasicPalette[29] := Rgb(0, 0, 160);
  arrBasicPalette[30] := Rgb(128, 0, 128);
  arrBasicPalette[31] := Rgb(128, 0, 255);

  arrBasicPalette[32] := Rgb(64, 0, 0);
  arrBasicPalette[33] := Rgb(128, 64, 0);
  arrBasicPalette[34] := Rgb(0, 64, 0);
  arrBasicPalette[35] := Rgb(0, 64, 64);
  arrBasicPalette[36] := Rgb(0, 0, 128);
  arrBasicPalette[37] := Rgb(0, 0, 64);
  arrBasicPalette[38] := Rgb(64, 0, 64);
  arrBasicPalette[39] := Rgb(64, 0, 128);

  arrBasicPalette[40] := Rgb(0, 0, 0);
  arrBasicPalette[41] := Rgb(128, 128, 0);
  arrBasicPalette[42] := Rgb(128, 128, 64);
  arrBasicPalette[43] := Rgb(128, 128, 128);
  arrBasicPalette[44] := Rgb(64, 128, 128);
  arrBasicPalette[45] := Rgb(192, 192, 192);
  arrBasicPalette[46] := Rgb(64, 0, 64);
  arrBasicPalette[47] := Rgb(255, 255, 255);
end;

procedure TvtColorPatternSelect.InitColors;
var A: TArray<string>;
    I: integer;
begin
  SetLength(FColors, meColors.Lines.Count);
  for I := 0 to meColors.Lines.Count - 1 do
  begin
    A := meColors.Lines.Strings[I].Split(['|']);
    if Length(A) < 3 then
      raise Exception.Create('Incorrect value for color record ('+ IntToStr(I) +'): '+ meColors.Lines.Strings[I]);
    FColors[I].Number := A[0];
    FColors[I].Hex := A[1];
    FColors[I].Name := A[2];
    FColors[I].Color := WebToTColor(A[1]);
  end;
end;

procedure TvtColorPatternSelect.InitPatterns;
var I: integer;
    FItem: TListItem;
begin
  lvPatterns.Clear; //20210304 Igor
  with VirtualTaxOfficeInfo do
  begin
    for I := 0 to Length(Patterns) - 1 do
    begin
      FItem := lvPatterns.Items.Add;
      FItem.Caption := Patterns[I].Name;
      FItem.ImageIndex := I;
    end;
    lvPatterns.LargeImages := PatternsList;
  end;
end;

procedure TvtColorPatternSelect.InitValue(AValue: string); //20210330 Igor
var I, nIndex: integer;
begin
  if AValue.StartsWith('#') or AValue.IsEmpty then
  begin
    nIndex := -1;
    for I := 0 to Length(FColors) - 1 do
      if SameText(FColors[I].Hex, AValue) then
      begin
        nIndex := I;
        break;
      end;
    if nIndex <> -1 then
    begin
      pgMain.ActivePage := tabColor;
      FCurrColumn := nIndex div sgColors.RowCount;
      if FCurrColumn + sgColors.ColCount > Ceil(Length(FColors) / sgColors.RowCount) then
        FCurrColumn := Ceil(Length(FColors) / sgColors.RowCount) - sgColors.ColCount;
      sgColors.Col := (nIndex - FCurrColumn * sgColors.RowCount) div sgColors.RowCount;
      sgColors.Row := (nIndex - FCurrColumn * sgColors.RowCount) mod sgColors.RowCount;
      //20210330 Igor >>>
      pbColors.Repaint;
      sgColors.Repaint;
      // To scroll navigator
      if FCurrColumn * FCellWidth > sbNavigation.Width + sbNavigation.HorzScrollBar.ScrollPos then
        sbNavigation.HorzScrollBar.Position := (FCurrColumn + sgColors.ColCount) * FCellWidth - sbNavigation.Width + pbColors.Margins.Left
      else
        if FCurrColumn * FCellWidth < sbNavigation.HorzScrollBar.ScrollPos - pbColors.Margins.Left then
          sbNavigation.HorzScrollBar.Position := FCurrColumn * FCellWidth + pbColors.Margins.Left;
      //20210330 Igor <<<
    end
    else
    begin
      pgMain.ActivePage := tabBasicColor;
    end;
    BasicColor := WebToTColor(AValue);
  end
  else
    if tabPattern.TabVisible then  //20210330 Igor
    begin
      pgMain.ActivePage := tabPattern;
      for I := 0 to lvPatterns.Items.Count - 1 do
        if SameText(VirtualTaxOfficeInfo.Patterns[lvPatterns.Items.Item[I].ImageIndex].FileName, AValue) then
        begin
          lvPatterns.Items.Item[I].Selected := true;
          break;
        end;
    end;
  RefreshColorInfo;
end;

procedure TvtColorPatternSelect.lbBrightnessMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FBrightnessMoving := true;
  FBrightnessOldY := Y;
end;

procedure TvtColorPatternSelect.lbBrightnessMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var NewY: integer;
begin
  if not FBrightnessMoving then Exit;
  NewY := lbBrightness.Top - (FBrightnessOldY - Y);
  if (NewY < pbBrightness.Top - lbBrightness.Height div 2) or
     (NewY > pbBrightness.Top + pbBrightness.Height  - lbBrightness.Height div 2) then Exit;
  lbBrightness.Top := NewY;
  UpdateBrightness;
end;

procedure TvtColorPatternSelect.lbBrightnessMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FBrightnessMoving := false;
end;

procedure TvtColorPatternSelect.lvPatternsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  pbPattern.Repaint;
end;

procedure TvtColorPatternSelect.pbBasicColorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ProcessBasicColorsClick(X, Y);
  FBasicColorMoving := true;
end;

procedure TvtColorPatternSelect.pbBasicColorsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FBasicColorMoving then Exit;
  ProcessBasicColorsClick(X, Y);
end;

procedure TvtColorPatternSelect.pbBasicColorsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FBasicColorMoving := false;
end;

procedure TvtColorPatternSelect.pbBasicColorsPaint(Sender: TObject);
var I, J, W, H, DiffW, DiffH: integer;
    CurrI, CurrJ, CurrW, CurrH: integer;
    B: TBitmap;
begin
  if (pbBasicColors.Width <= 0) or (pbBasicColors.Height < 0) then Exit;
  if not Assigned(FBasicColorBackground) then
  begin
    FBasicColorBackground := TBitmap.Create;
    FBasicColorBackground.Width := pbBasicColors.Width;
    FBasicColorBackground.Height := pbBasicColors.Height;
    W := FBasicColorBackground.Width div 240;
    H := FBasicColorBackground.Height div 241;
    DiffW := FBasicColorBackground.Width - W * 240;
    DiffH := FBasicColorBackground.Height - H * 241;
    CurrJ := 0;

    for J := 0 to 240 do
    begin
      CurrI := 0;
      CurrH := H;
      if J < DiffH then
        CurrH := CurrH + 1;
      for I := 0 to 239 do
      begin
        CurrW := W;
        if I <= DiffW then
          CurrW := CurrW + 1;
        FBasicColorBackground.Canvas.Brush.Color := arrBasicColors[I, 240-J].Color;
        FBasicColorBackground.Canvas.FillRect(Rect(CurrI,
                               CurrJ,
                               CurrI + CurrW,
                               CurrJ + CurrH));
        arrBasicColors[I, 240-J].X := CurrI + CurrW div 2;
        arrBasicColors[I, 240-J].Y := CurrJ + CurrH div 2;
        CurrI := CurrI + CurrW;
      end;
      CurrJ := CurrJ + CurrH;
    end;
  end;
  InitBasicColorCoordinates;
  B := TBitmap.Create;
  try
    B.Width := pbBasicColors.Width;
    B.Height := pbBasicColors.Height;
    B.Canvas.Draw(0, 0, FBasicColorBackground);
    B.Canvas.Brush.Color := clBlack;
    B.Canvas.FrameRect(Rect(0, 0, B.Width, B.Height));
    B.Canvas.Pen.Color := clBlack;
    B.Canvas.Pen.Width := 2;
    B.Canvas.MoveTo(FBasicColorX - 10, FBasicColorY);
    B.Canvas.LineTo(FBasicColorX - 5, FBasicColorY);
    B.Canvas.MoveTo(FBasicColorX + 5, FBasicColorY);
    B.Canvas.LineTo(FBasicColorX + 10, FBasicColorY);
    B.Canvas.MoveTo(FBasicColorX, FBasicColorY - 10);
    B.Canvas.LineTo(FBasicColorX, FBasicColorY - 5);
    B.Canvas.MoveTo(FBasicColorX, FBasicColorY + 5);
    B.Canvas.LineTo(FBasicColorX, FBasicColorY + 10);
    pbBasicColors.Canvas.Draw(0, 0, B);
  finally
    B.Free;
  end;
end;

procedure TvtColorPatternSelect.pbBrightnessMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Y < 0) or (Y > pbBrightness.Height) then Exit;
  lbBrightness.Top := pbBrightness.Top + Y - lbBrightness.Height div 2;
  UpdateBrightness;
  FBrightnessPaintBoxMoving := true;
end;

procedure TvtColorPatternSelect.pbBrightnessMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FBrightnessPaintBoxMoving then Exit;
  if (Y < 0) or (Y > pbBrightness.Height) then Exit;
  lbBrightness.Top := pbBrightness.Top + Y - lbBrightness.Height div 2;
  UpdateBrightness;
end;

procedure TvtColorPatternSelect.pbBrightnessMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FBrightnessPaintBoxMoving := false;
end;

procedure TvtColorPatternSelect.pbBrightnessPaint(Sender: TObject);
var B: TBitmap;
    H, DiffH, CurrH, J, CurrJ: integer;
    Hue, Sat, Lum: Word;
begin
  InitBasicColorCoordinates;
  ColorRGBToHLS(ColorToRGB(pbBasicColors.Canvas.Pixels[FBasicColorX, FBasicColorY]), Hue, Lum, Sat);
  B := TBitmap.Create;
  try
    B.Width := pbBrightness.Width;
    B.Height := pbBrightness.Height;
    H := B.Height div 30;
    DiffH := B.Height - H * 30;
    CurrJ := 0;
    Lum := 240;
    for J := 29 downto 0 do
    begin
      CurrH := H;
      if J < DiffH then
        CurrH := CurrH + 1;
      B.Canvas.Brush.Color := ColorHLSToRGB(Hue, Lum, Sat);
      B.Canvas.FillRect(Rect(0,
                             CurrJ,
                             B.Width,
                             CurrJ + CurrH));
      CurrJ := CurrJ + CurrH;
      if Lum >= 8 then
        Lum := Lum - 8;
    end;
    B.Canvas.Brush.Color := clBlack;
    B.Canvas.FrameRect(Rect(0, 0, B.Width, B.Height));
    pbBrightness.Canvas.Draw(0, 0, B);
  finally
    B.Free;
  end;
end;

procedure TvtColorPatternSelect.pbColorsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FCurrColumn := X div FCellWidth;
  if FCurrColumn + sgColors.ColCount > Ceil(Length(FColors) / sgColors.RowCount) then
    FCurrColumn := Ceil(Length(FColors) / sgColors.RowCount) - sgColors.ColCount;
  pbColors.Repaint;
  sgColors.Repaint;
  RefreshColorInfo;
end;

procedure TvtColorPatternSelect.pbColorsPaint(Sender: TObject);
var I, nRow, nCol: integer;
    B: TBitmap;
begin
  B := TBitmap.Create;
  try
    B.Width := pbColors.ClientWidth;
    B.Height := pbColors.ClientHeight;
    B.Canvas.Rectangle(pbColors.ClientRect);
    FCellHeight := Floor(pbColors.ClientHeight / sgColors.RowCount);
    FCellWidth := Floor(pbColors.ClientWidth / Ceil(Length(FColors) / sgColors.RowCount));
    for I := 0 to Length(FColors) - 1 do
    begin
      nRow := I mod sgColors.RowCount;
      nCol := I div sgColors.RowCount;
      B.Canvas.Brush.Style := bsSolid;
      B.Canvas.Brush.Color := FColors[I].Color;
      B.Canvas.FillRect(Rect(nCol * FCellWidth,
                             nRow * FCellHeight,
                             nCol * FCellWidth + FCellWidth,
                             nRow * FCellHeight + FCellHeight));
    end;
    B.Canvas.Brush.Style := bsClear;
    B.Canvas.Pen.Width := 2;
    B.Canvas.Pen.Color := clBlack;
    B.Canvas.Rectangle(FCurrColumn * FCellWidth,
                       0,
                       (FCurrColumn + sgColors.ColCount) * FCellWidth,
                       sgColors.RowCount * FCellHeight);
    pbColors.Canvas.Draw(0, 0, B);
  finally
    B.Free;
  end;
end;

procedure TvtColorPatternSelect.pbPatternPaint(Sender: TObject);
var I: integer;
begin
  if Assigned(lvPatterns.Selected) then
  begin
    I := lvPatterns.Selected.ImageIndex;
    pbPattern.Canvas.Brush.Bitmap := VirtualTaxOfficeInfo.Patterns[lvPatterns.Selected.ImageIndex].Bitmap
  end
  else
  begin
    pbPattern.Canvas.Brush.Bitmap := nil;
    pbPattern.Canvas.Brush.Color := clWhite;
  end;
  pbPattern.Canvas.Brush.Style := bsSolid;
  pbPattern.Canvas.FillRect(pbPattern.ClientRect);
end;

procedure TvtColorPatternSelect.pgMainChange(Sender: TObject);
begin
  if pgMain.ActivePage = tabBasicColor then
    BasicColor := BasicColor;
end;

procedure TvtColorPatternSelect.pgMainResize(Sender: TObject);
var W, H, I: integer;
begin
  W := Floor(sgColors.ClientWidth / sgColors.ColCount);
  H := Floor(sgColors.ClientHeight / sgColors.RowCount);
  for I := 0 to sgColors.ColCount - 2 do
    sgColors.ColWidths[I] := W;
  sgColors.ColWidths[sgColors.ColCount - 1] := sgColors.ClientWidth - W * (sgColors.ColCount - 1) - sgColors.GridLineWidth * 5;
  for I := 0 to sgColors.RowCount - 2 do
    sgColors.RowHeights[I] := H;
  sgColors.RowHeights[sgColors.RowCount - 1] := sgColors.ClientHeight - H * (sgColors.RowCount - 1) - sgColors.GridLineWidth * 5;
  if Assigned(FBasicColorBackground) then
    FreeAndNil(FBasicColorBackground);
  AdjustBasicColorPositions;
end;

procedure TvtColorPatternSelect.ProcessBasicColorsClick(X, Y: integer);
begin
  if X < 1 then
    X := 1;
  if X >= pbBasicColors.Width - 2 then
    X :=  pbBasicColors.Width - 2;
  if Y < 1 then
    Y := 1;
  if Y >= pbBasicColors.Height - 2 then
    Y :=  pbBasicColors.Height - 2;
  FBasicColorX := X;
  FBasicColorY := Y;
  pbBasicColors.Repaint;
  //ShowBasicColor;
  BasicColor := pbBasicColors.Canvas.Pixels[FBasicColorX, FBasicColorY];
end;

procedure TvtColorPatternSelect.RefreshColorInfo;
var I: integer;
begin
  I := FCurrColumn * sgColors.RowCount + sgColors.Selection.Left * sgColors.RowCount + sgColors.Selection.Top;
  edColorNumber.Text := FColors[I].Number;
  edColorHex.Text := FColors[I].Hex;
  edColorName.Text := FColors[I].Name;
end;

procedure TvtColorPatternSelect.Reloadpatterns1Click(Sender: TObject); //20210304 Igor
begin
  Screen.Cursor := crHourGlass;
  try
    VirtualTaxOfficeInfo.LoadPatterns(true);
    InitPatterns;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TvtColorPatternSelect.SetBasicColor(const Value: TColor);
var R, G, B: Byte;
    H, S, L: Word;
    H2, L2, S2: Word;
begin
  shBasicColor.Brush.Color := Value;
  R := GetRValue(Value);
  G := GetGValue(Value);
  B := GetBValue(Value);
  ColorRGBToHLS(ColorToRGB(Value), H, L, S);
  SkipBasicColorsEditsChange := true;
  try
    if not SameText(edHue.Text, IntToStr(H)) then
      edHue.Text := IntToStr(H);
    if not SameText(edSat.Text, IntToStr(S)) then
      edSat.Text := IntToStr(S);
    if not SameText(edLum.Text, IntToStr(L)) then
      edLum.Text := IntToStr(L);
    if not SameText(edRed.Text, IntToStr(R)) then
      edRed.Text := IntToStr(R);
    if not SameText(edGreen.Text, IntToStr(G)) then
      edGreen.Text := IntToStr(G);
    if not SameText(edBlue.Text, IntToStr(B)) then
      edBlue.Text := IntToStr(B);
  finally
    SkipBasicColorsEditsChange := false;
  end;
  lbBrightness.Top := Trunc((240 - L) * pbBrightness.Height / 240) - lbBrightness.Height div 2;
  ColorRGBToHLS(ColorToRGB(pbBasicColors.Canvas.Pixels[FBasicColorX, FBasicColorY]), H2, L2, S2);
  if not SkipBasicColorPositioning then
    if (H <> H2) or (S <> S2) or
       (FBasicColorY = 0) or (FBasicColorX = 0) or
       (FBasicColorY > pbBasicColors.Height - 2) or (FBasicColorX > pbBasicColors.Width - 2) then
    begin
      FBasicColorX := arrBasicColors[H, S].X;
      FBasicColorY := arrBasicColors[H, S].Y;
      pbBasicColors.Repaint;
    end;
  pbBrightness.Repaint;
  sgBasicColors.Repaint;
end;

procedure TvtColorPatternSelect.sgBasicColorsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var B: TBitmap;
    R: TRect;

  procedure BevelRect(ACanvas: TCanvas; R: TRect);
  begin
    with ACanvas do
    begin
      Pen.Color := clBtnShadow;
      PolyLine([Point(R.Left, R.Bottom), Point(R.Left, R.Top),
        Point(R.Right, R.Top)]);
      Pen.Color := clBtnHighlight;
      PolyLine([Point(R.Right, R.Top), Point(R.Right, R.Bottom),
        Point(R.Left, R.Bottom)]);
    end;
  end;

begin
  B := TBitmap.Create;
  try
    B.Width := Rect.Width + 1;
    B.Height := Rect.Height + 1;
    R.Left := 0;
    R.Top := 0;
    R.Width := Rect.Width;
    R.Height := Rect.Height;
    pnlDrawBackground.PaintTo(B.Canvas, 0, 0);
    InflateRect(R, -2, -2);
    if (gdSelected in State) and (arrBasicPalette[ARow * 8 + ACol] = shBasicColor.Brush.Color) then
      B.Canvas.DrawFocusRect(R);
    InflateRect(R, -3, -3);
    B.Canvas.Brush.Color := arrBasicPalette[ARow * 8 + ACol];
    B.Canvas.FillRect(R);
    BevelRect(B.Canvas, R);
    InflateRect(R, -1, -1);
    BevelRect(B.Canvas, R);
    sgBasicColors.Canvas.Draw(Rect.Left, Rect.Top, B);
  finally
    B.Free;
  end;
end;

procedure TvtColorPatternSelect.sgBasicColorsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  BasicColor := arrBasicPalette[ARow * 8 + ACol];
end;

procedure TvtColorPatternSelect.sgColorsClick(Sender: TObject);
begin
  RefreshColorInfo;
end;

procedure TvtColorPatternSelect.sgColorsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var I: integer;
begin
  I := FCurrColumn * sgColors.RowCount + ACol * sgColors.RowCount + ARow;
  sgColors.Canvas.Brush.Style := bsSolid;
  sgColors.Canvas.Brush.Color := FColors[I].Color;
  sgColors.Canvas.FillRect(Rect);
  sgColors.Canvas.Brush.Style := bsClear;
  sgColors.Canvas.Pen.Width := 1;
  sgColors.Canvas.Pen.Color := clSilver;
  sgColors.Canvas.Rectangle(Rect);
  if gdSelected in State then
  begin
    sgColors.Canvas.Brush.Style := bsClear;
    sgColors.Canvas.Pen.Width := 2;
    sgColors.Canvas.Pen.Color := clBlack;
    sgColors.Canvas.Rectangle(Rect.Left + 2,
                              Rect.Top + 2,
                              Rect.Right - 1,
                              Rect.Bottom - 1);
  end;
end;

procedure TvtColorPatternSelect.sgCustomPatColorsDrawCell(Sender: TObject; ACol,  //20210330 Igor
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  _bmp: TBitmap;

type
  PRGB32Array = ^TRGB32Array;
  TRGB32Array = packed array[0..MaxInt div SizeOf(TRGBQuad)-1] of TRGBQuad;

  procedure MakeGrey(Bitmap: TBitmap);
  var
    w, h: integer;
    y: Integer;
    sl: PRGB32Array;
    x: Integer;
    grey: byte;
  begin
    Bitmap.PixelFormat := pf32bit;
    w := Bitmap.Width;
    h := Bitmap.Height;
    for y := 0 to h - 1 do
    begin
      sl := Bitmap.ScanLine[y];
      for x := 0 to w - 1 do
        with sl[x] do
        begin
          grey := (rgbBlue + rgbGreen + rgbRed) div 3;
          rgbBlue := grey;
          rgbGreen := grey;
          rgbRed := grey;
        end;
    end;
  end;
begin
  with Sender as TStringGrid, VirtualTaxOfficeInfo do
  begin
    // Cell content
    Canvas.Brush.Style := bsSolid;

    if (CustomPatColors.Count > 0) and (ACol < CustomPatColors.Count) then
    begin
      if CustomPatColors[ACol].StartsWith('#') then // Is it color or patter
      begin
        Canvas.Brush.Color := WebToTColor(CustomPatColors[ACol]);
        Canvas.FillRect(Rect);
      end
      else
        begin
          _bmp := FindPatternByFileName(CustomPatColors[ACol]);
          if not Assigned(_bmp) then
          begin
            Canvas.Brush.Color := clWhite;
            Canvas.FillRect(Rect);
            Canvas.Pen.Color := clRed;
            Canvas.MoveTo(Rect.Left, Rect.Top);
            Canvas.LineTo(Rect.Right, Rect.Bottom);
            Canvas.MoveTo(Rect.Left, Rect.Bottom);
            Canvas.LineTo(Rect.Right, Rect.Top);
          end
          else
          begin
            if not tabPattern.TabVisible then
              MakeGrey(_bmp);
            Canvas.StretchDraw(Rect, _bmp);
          end;
        end;
    end
    else
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.FillRect(Rect);
    end;

    // Cell bounds rectangle
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clSilver;
    Canvas.Rectangle(Rect);

    // Cell focus rectangle
    if gdSelected in State then
    begin
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Width := 2;
      Canvas.Pen.Color := clBlack;
      Rect.Inflate(-2, -2, -1, -1);
      Canvas.Rectangle(Rect);
    end;
  end;
end;

procedure TvtColorPatternSelect.sgCustomPatColorsSelectCell(Sender: TObject;  //20210330 Igor
  ACol, ARow: Integer; var CanSelect: Boolean);
var
  _val: String;
begin
  _val := _val.Empty;
  with VirtualTaxOfficeInfo do
    if (CustomPatColors.Count > 0) and (ACol < CustomPatColors.Count) then
      _val := CustomPatColors[ACol];

  if not _val.IsEmpty then
  begin
    if not _val.StartsWith('#') and not tabPattern.TabVisible then
      Exit;
    InitValue(_val);
  end;
end;

procedure TvtColorPatternSelect.ShowBasicColor;
var R, G, B: Byte;
    H, S, L: Word;
begin
  shBasicColor.Brush.Color := pbBasicColors.Canvas.Pixels[FBasicColorX, FBasicColorY];
  R := GetRValue(shBasicColor.Brush.Color);
  G := GetGValue(shBasicColor.Brush.Color);
  B := GetBValue(shBasicColor.Brush.Color);
  ColorRGBToHLS(ColorToRGB(shBasicColor.Brush.Color), H, L, S);
  edHue.Text := FloatToStr(H);
  edSat.Text := FloatToStr(S);
  edLum.Text := FloatToStr(L);
  edRed.Text := IntToStr(R);
  edGreen.Text := IntToStr(G);
  edBlue.Text := IntToStr(B);
  lbBrightness.Top := Trunc(L * pbBrightness.Height / 240) - lbBrightness.Height div 2;
end;

procedure TvtColorPatternSelect.UpdateBrightness;
var FColor: TColor;
    Hue, Lum, Sat: Word;
begin
  ColorRGBToHLS(ColorToRGB(pbBasicColors.Canvas.Pixels[FBasicColorX, FBasicColorY]), Hue, Lum, Sat);
  Lum := 240 - Trunc((lbBrightness.Top + lbBrightness.Height div 2 - 2) / pbBrightness.Height * 240);
  SkipBasicColorPositioning := true;
  try
    BasicColor := ColorHLSToRGB(Hue, Lum, Sat);
  finally
    SkipBasicColorPositioning := false;
  end;
end;

end.
