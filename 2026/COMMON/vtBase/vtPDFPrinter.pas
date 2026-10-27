unit vtPDFPrinter;

interface

uses
  System.SysUtils, System.Classes, Windows, Forms, Graphics, Controls, ShellAPI,
  synpdf, SynCommons, Vcl.ComCtrls, Variants, //20171224 Igor
  vtMulti, vtTrimStr, vtShared,
  vtForm, vtChild, vtCommon,
  vtShape, vtGroupBox, vtLabel, vteditbox, ExtCtrls, StdCtrls, vtMemoBox, //20161212 Igor
  vtPrints, Math, Data.DB, mORMotReport, //20170307 Igor //20170311 Igor
  RichEdit, RxRichEd, VCL.Grids, Vcl.Printers; //20170518 Igor


type
  TOnAfterReadComponent = reference to Procedure(AForm: TForm; AFormName: String);
  TPrintEditBoxProc  = reference to Procedure(ARetNo: Integer; AEditBox: TvtEdit; AFormName: String;
    AFormNo: Integer; AHdc: THandle; ACanvas: TCanvas; ADTop: Integer; ADLeft: Integer;
    AisSynPDF: Boolean);
  TPrepareRichEditProc = reference to Procedure(ARetNo: Integer; AFormName: String; ARichEdit: TRichEdit);
  TPrintImageProc = reference to Procedure(ARetNo: Integer; AFormName: String; AImage: TImage; ACanvas: TCanvas;
    ADTop: Integer; ADLeft: Integer);
  TPrintHeaderProc = reference to Procedure(ACanvas: TCanvas; ARetNo: Integer; AFormName: String; AFormNo: Integer;
    PageNumber: Integer; APageHeight, APageWidth: Integer; //20161130 Igor
    ADTop: Integer; ADLeft: Integer);

  TFooterRecord = record
    vtLbl: TvtLabel;
    deltaH: Integer;
  end;

  TvtPDFPrinter = class(TObject)
  private
    FPDFDocument: TPDFDocumentGDI;
    FPDFPage: TPdfPage;

    FApp: TApp;
    FReturn: TRetData;
    FForm: TFrec;
    FFullForm: TvtScrollBox;

    FFormCountPages: Integer;
    FCurrPage: Integer; //20230519 Igor
    FFormName: String;

    FPrintEditBox: TPrintEditBoxProc;
    FPrepareRichEdit: TPrepareRichEditProc;
    FPrintImage: TPrintImageProc;
    FPrintHeader: TPrintHeaderProc;
    FisLetter: Boolean;
    FisDynamic: boolean; //20161115 Igor
    FlblArr: Array of TFooterRecord;
    FPageFooterHeight: Integer;
    FProblemText: String; //20161212 Igor
    FRealPageHeight: Integer; //20170307 Igor
    FRealPageWidth: Integer;  //20170307 Igor

    function CalcBottomMargin(RichEdit: TRichEdit): Integer;
    procedure SetupPageBreaks;
    procedure PrintFormPage(APageNumber: Integer);
    procedure CustomPrintEditBox(ARetNo: Integer; AEditBox: TvtEdit; AFormName: String;
      AFormNo: Integer; AHdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0);
    procedure AppendRichEdit(RichEdit: TRichEdit; ADTop, ADLeft, AStartPageY, AEndPageY: Integer); //20170127 Igor
    procedure AppendMemo(AMemo: TMemo; ADTop, ADLeft, AStartPageY, AEndPageY: Integer); //20161212 Igor //20170127 Igor
    procedure NewPageInternal(AStartPageY, AEndPageY: Integer); //20170127 Igor
    procedure SetupEveryPageLabel;
    procedure AddPrintProblem(AText: String);//20161212 Igor
    procedure SetupFonts;  //20170212 Igor

  public
    constructor Create(AApp: TApp);
    destructor Destroy; override;
    property PDFDocument: TPDFDocumentGDI read FPDFDocument;

    function PrintForm(ARetNo: integer; AFormName: String; AWhichPage: Integer;
      AAfterReadComponent: TOnAfterReadComponent; APrintEditBox: TPrintEditBoxProc;
      APrepareRichEdit: TPrepareRichEditProc; APrintImage: TPrintImageProc;
      APrintHeader: TPrintHeaderProc): Boolean;

    procedure SaveToFile(const AFileName: String; AShow: Boolean = True);
    procedure Show;
    procedure CalcScaleXY; //20170212 Igor
    procedure PrintDataSet(AReportName, ATitle: string; ATitle2,
      AColumnTitles, AFieldNames: array of String; AColumnWidth: array of Integer;
      ADataSet: TDataSet; APreview: Boolean = True;
      AOrientation: TPrinterOrientation = poPortrait); //20171221 Igor
    procedure PrintStringGrid(AReportName, ATitle: string; ATitle2: array of String;
      AStringGrid: TStringGrid; APreview: Boolean = True; AutoSaveToFile: string = ''); //20170523 Igor
    procedure PrintLestView(AReportName, ATitle: string; ATitle2: array of String;
      AListView: TListView; APreview: Boolean = True; AutoSaveToFile: string = '';
      AOrientation: TPrinterOrientation = poPortrait); //20170729 Igor
  end;

  function ToPDFUnit(AValue: Extended): Integer;
 //20170212 Igor>>>
function LM: Integer;
function RM: Integer;
function TM: Integer;
function BM: Integer;
 //20170212 Igor<<<
implementation

const
  MxFrmHeight = 1050;
  MxFrmWidth  = 655;
  PDFUnit = 72;
 //20170212 Igor>>>
var
  FLM: Integer = 0;
  FRM: Integer = 0;
  FTM: Integer = 0;
  FBM: Integer = 0;
  FWFS: Integer = 0;

function WFS: Integer;
begin
  if FWFS = 0 then
    FWFS := Round((GetWindowsFontSize(Application.MainForm.Handle) / 96) * 100);
  Result := FWFS;
end;

function LM: Integer;
begin
  if FLM = 0 then
    FLM := 18 * WFS div 100;
  result := FLM;
end;

function RM: Integer;
begin
  if FRM = 0 then
    FRM := 18 * WFS div 100;
  result := FRM;
end;

function TM: Integer;
begin
  if FTM = 0 then
    FTM := 18 * WFS div 100;
  result := FTM;
end;

function BM: Integer;
begin
  if FBM = 0 then
    FBM := 18 * WFS div 100;
  result := FBM;
end;

function ToPDFUnit(AValue: Extended): Integer;
begin
  Result := Round(AValue / PDFUnit * WFS);
end;
 //20170212 Igor<<<

{ TvtPDFPrinter }

function TvtPDFPrinter.CalcBottomMargin(RichEdit: TRichEdit): Integer;
begin
  Result := 24;
end;

procedure TvtPDFPrinter.CalcScaleXY; //20170212 Igor
begin
//20170307 Igor >>>
  If PDFDocument.Canvas.Page.PageLandscape then
  begin
    ScaleX := (ToPDFUnit(PDFDocument.Canvas.Page.PageWidth) - LM - RM) / Max(MxFrmHeight, FRealPageHeight);
    ScaleY := (ToPDFUnit(PDFDocument.Canvas.Page.PageHeight) - TM - BM) / Max(MxFrmWidth, FRealPageWidth);
  end
  else
  begin
    ScaleX := (ToPDFUnit(PDFDocument.Canvas.Page.PageWidth) - LM - RM) / Max(MxFrmWidth, FRealPageWidth);
    ScaleY := (ToPDFUnit(PDFDocument.Canvas.Page.PageHeight) - TM - BM) / Max(MxFrmHeight, FRealPageHeight);
  end;
  //20170307 Igor <<<
end;

constructor TvtPDFPrinter.Create(AApp: TApp);
begin
  inherited Create;
  FPDFDocument := TPDFDocumentGDI.Create;
  FPDFDocument.DefaultPaperSize := SynPdf.psA4; //20170311 Igor
  FApp := AApp;
end;

Function ExtractIntegerPart(S: string): string;
var
  i: integer;
Begin
  I := 1;
  while (i <= Length(s)) and not (S[i] ='.') do
    inc(i);
  Result := Ltrim(LeftStr(s, i-1));
end;

Function ExtractDecimalPart(S: string): string;
var
  i :integer;
Begin
  i := Length(S);
  while (i > 0) and not CharInSet(s[i], ['.']) do//20170811 Igor
    dec(i);
  If (i > 0) and (s[i] = '.') then
    result := Copy(s, i + 1, 255)
  else
    result := '';
end;

Function InsertCommas(s: string): String;
Var
  SignPart: string;
begin
  S := LTrim(s);
  If LeftStr(S, 1) = '-' then
  begin
    SignPart := '-';
    s := RightStr(s, Length(s) - 1);
  end
  else
    SignPart := '';

  Result := SignPart + s;
  Case Length(s) of
    4: Result := SignPart + LeftStr(S, 1) + ',' + RightStr(S, 3);
    5: Result := SignPart + LeftStr(S, 2) + ',' + RightStr(S, 3);
    6: Result := SignPart + LeftStr(S, 3) + ',' + RightStr(S, 3);
    7: Result := SignPart + Leftstr(s, 1) + ',' + MidStr(S, 2, 3) + ',' + RightStr(S, 3);
    8: Result := SignPart + Leftstr(s, 2) + ',' + MidStr(S, 3, 3) + ',' + RightStr(S, 3);
  end;
end;

Function FormatAmount(s: string; VerticalSeparator: Boolean): string;
var
  SignPart: string;
  IntegerPart : string;
  DecimalPart : string;
begin
  s := LTrim(s);
  IntegerPart := ExtractIntegerPart(s);
  DecimalPart := ExtractDecimalPart(s);
  If length(DecimalPart) = 0 then
    DecimalPart := '00'
  else
  if length(DecimalPart) = 1 then
    DecimalPart := DecimalPart + '0'
  else
    DecimalPart := Copy(DecimalPart, 1, 2);
  If VerticalSeparator = True then
    Result := InsertCommas(IntegerPart)+'  '+DecimalPart
  else
    Result := InsertCommas(IntegerPart)+'.'+DecimalPart;
end;

procedure TvtPDFPrinter.CustomPrintEditBox(ARetNo: Integer; AEditBox: TvtEdit;
  AFormName: String; AFormNo: Integer; AHdc: THandle; ACanvas: TCanvas; ADTop,
  ADLeft: Integer);
Var
  FieldId: Integer;
  R: TRect;
  s: String;
  FormattedAmount: string;
  x, y: LongInt;
  PenWidth: Integer;
  AlignTopBottomVar, tempPos: Integer;
  MyEditHandle: THandle;
  PrintText, tempPrintText: String;
Begin
  FieldId:=GetFieldId(AEditBox.Name);
  ACanvas.Font.Height := abs(ROUND(AEditBox.Font.Height * AEditBox.Font.PixelsPerInch / 96)); //20170212 Igor
  R.Left := AEditBox.Left + ADLeft;
  R.Top := AEditBox.Top + ADTop;
  R.Right := AEditBox.Left + ADLeft + AEditBox.Width;
  R.Bottom := AEditBox.Top + ADTop + AEditBox.Height;

  ACanvas.Font.Color := clBlack;
  ACanvas.Font.Style := [];
  ACanvas.Brush.Style := bsClear;
  ACanvas.Font.Name := AFormName;

  If PauseSw then
    PausePrinting;

  If ShowFieldIdSw then
  begin
    if AEditBox.vtInputType = vtDollar then
      PrintText := '['+IntToStr(FieldId)+'n]'
    else
      PrintText := '['+IntToStr(FieldId)+']';
    ACanvas.Textout(ScalePrX(R.Left + 2), ScalePrY(R.Top + 2), PrintText);
  end
  else
  begin
    with AEditBox do
    Begin
      if vtInputType = vtDollar then
      begin
        PrintText := FormatAmount(FetchElmFNo(FReturn.RetNo, FForm.FormNo, FieldId), AEditBox.vtVertSeparator);
        if AEditBox.vtDecimalPlaces = 1 then
          PrintText := leftstr(PrintText, length(PrintText)-3);
        tempPrintText := StringReplace(PrintText, '  ', '.', [rfReplaceAll, rfIgnoreCase]);
        if Vl(tempPrintText) = 0 then
          PrintText := '';
        if leftstr(PrintText, 1) = ' ' then
          PrintText := '0' + PrintText;
      end
      else
      if vtInputType = vtSin then
        PrintText := reFormatSin(FetchElmFNo(FReturn.RetNo, FForm.FormNo, FieldId))
      else
        PrintText := FetchElmFNo(FReturn.RetNo, FForm.FormNo, FieldId);

      if vtLayout = vtTop then
        AlignTopBottomVar := ScalePrY(R.Top + 1)
      else
      if vtLayout = vtMiddle then
      begin
        tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
        AlignTopBottomVar := ScalePrY(R.Top) + tempPos - (ACanvas.TextHeight(PrintText) div 2);
      end
      else
      //if vtLayout = vtBottom then//20170811 Igor
      begin
        AlignTopBottomVar := ScalePrY(R.Bottom) - ACanvas.TextHeight(PrintText);
      end;

      if vtAlignment = taLeftJustify then
      begin
        ACanvas.Textout(ScalePrX(R.Left) + 2, AlignTopBottomVar, PrintText);
      end
      else
      if vtAlignment = taRightJustify then
      begin
        ACanvas.Textout(ScalePrX(R.Right) - ACanvas.TextWidth(PrintText) - 3, AlignTopBottomVar, PrintText)
      end
      else
      if vtAlignment = System.Classes.taCenter then //20170311 Igor
      begin
        tempPos := ((ScalePrX(R.Right) - ScalePrX(R.Left)) - ACanvas.TextWidth(PrintText)) div 2;
        ACanvas.Textout(ScalePrX(R.Left) + tempPos , AlignTopBottomVar,PrintText)
      end;

      if vtinputType = vtDollar then
      begin
        ACanvas.Textout(ScalePrX(R.Left), AlignTopBottomVar, vtPrefix);
        if vtVertSeparator = True then
        begin
          if vtBorderType = vtDoubleUnderLine then
          begin
            ACanvas.Pen.Width := 2;
            ACanvas.MoveTo(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2, ScalePrY(R.Top));
            ACanvas.LineTo(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2, ScalePrY(R.Bottom) - 2);
          end
          else
          begin
            ACanvas.Pen.Width := 1;
            ACanvas.MoveTo(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 1, ScalePrY(R.Top));
            ACanvas.LineTo(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 1, ScalePrY(R.Bottom) - 2);
          end;
        end;
      end;

      if AEditBox.vtBorderType = vtNoBorder then
      begin
      end
      else if AEditBox.vtBorderType = vtFull then
      begin
        ACanvas.Pen.Width := AEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Top));
      end
      else
      if AEditBox.vtBorderType = vtsides then
      begin
        ACanvas.Pen.Width := AEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
      end
      else
      if AEditBox.vtBorderType = vtUnderline then
      begin
        ACanvas.Pen.Width := AEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
      end
      else
      if AEditBox.vtBorderType = vtDoubleUnderLine then
      begin
        ACanvas.Pen.Width := AEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom)+1);
        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom)+1);
      end
      else
      if AEditBox.vtBorderType = vtTopBottomLine then
      begin
        ACanvas.Pen.Width := AEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Top));
        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Top));
        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
      end;
    end;
  end;
  If ReviewOn(FReturn.RetNo, FForm.FormNo, FieldId) then
  begin
    DrawingTool := dtEllipse;
    PenWidth := 3;
    ACanvas.Brush.Style := bsClear;
    DrawShape(Point(ScalePrX(R.Left-7), ScalePrY(R.Top-5)),
    Point(ScalePrX(R.Right+7), ScalePrY(R.Bottom+7)), PenWidth, ACanvas);
  end;
  ACanvas.Font.Style := [];
  ACanvas.Pen.Width := 1;
end;

destructor TvtPDFPrinter.Destroy;
begin
  FApp := nil;
  FPDFDocument.Free;
  inherited;
end;

procedure TvtPDFPrinter.NewPageInternal(AStartPageY, AEndPageY: Integer);//20170127 Igor
begin
  FPDFPage := FPDFDocument.AddPage;
  FPDFPage.PageLandscape := CurrentPageIsLanscape(FFullForm, FForm.Landscape, MxFrmWidth, AStartPageY, AEndPageY,
    FRealPageHeight, FRealPageWidth); //20170127 Igor //20170307 Igor
  if FPDFDocument.Info.Title = '' then
  begin
    FPDFDocument.Info.Title := FReturn.PrintTitle(FForm);
    FPDFDocument.Info.Author := 'vt-2015';
  end;
end;

procedure TvtPDFPrinter.PrintDataSet(AReportName, ATitle: string; ATitle2,
  AColumnTitles, AFieldNames: array of String; AColumnWidth: array of Integer;
  ADataSet: TDataSet; APreview: Boolean = True; AOrientation: TPrinterOrientation = poPortrait);//20171221 Igor
var
  P: TGDIPages;
  I: Integer;
  Row: array of String;
begin
  if not Assigned(ADataSet) then Exit;
  if not ADataSet.Active then
    ADataSet.Open;

  Assert(Length(AColumnTitles) = Length(AFieldNames));
  Assert(Length(AColumnTitles) = Length(AColumnWidth));
  Assert(ADataSet.FieldCount >= Length(AColumnWidth));
  P := TGDIPages.Create(nil);
  try
    // the title of the report
    P.Caption := AReportName;
    P.Orientation := AOrientation;//20171221 Igor
    // now we add some content to the report
    P.BeginDoc;
      // header and footer
    P.AddTextToHeader(AReportName);
    P.SaveLayout;
    P.Font.Style := [fsItalic];
    P.TextAlign := taRight;
    P.AddTextToFooterAt('VisualTax',P.RightMarginPos);
    P.RestoreSavedLayout;
    P.Font.Size := 9;
    P.AddTextToFooter(DateTimeToStr(Now));
    // main content (automaticaly split on next pages)
    P.NewHalfLine;
    P.DrawTitle(ATitle, true);
    for I := 0 to Length(ATitle2) - 1 do
      P.DrawText(ATitle2[I]);
    P.NewLine;
    P.AddColumns(AColumnWidth);
    P.AddColumnHeaders(AColumnTitles, true, true);
    ADataSet.DisableControls;
    try
      ADataSet.First;
      SetLength(Row, Length(AColumnTitles));
      while not ADataSet.Eof do
      begin
        for I := Low(AColumnTitles) to High(AColumnTitles) do
          Row[I] := VarToStr(ADataSet.FieldByName(AFieldNames[I]).Value);//20171224 Igor
        P.DrawTextAcrossCols(Row);
        ADataSet.Next;
      end;
    finally
      ADataSet.EnableControls;
    end;
    P.NewLine;
    P.EndDoc;
    // this method will show a preview form, and allow basic actions
    // by using the right click menu
    if APreview then
      P.ShowPreviewForm
    else
      P.PrintPages(-1,-1)  ;
  finally
    P.Free;
  end;
end;

procedure TvtPDFPrinter.PrintStringGrid(AReportName, ATitle: string;
  ATitle2: array of String;
  AStringGrid: TStringGrid; APreview: Boolean = True; AutoSaveToFile: string = ''); //20170523 Igor
var
  P: TGDIPages;
  ICol, IRow: Integer;
  Row: array of String;
  ColumnWidth: Array of Integer;
  ColumnTitles: Array of String;
begin
  if not Assigned(AStringGrid) then Exit;
  P := TGDIPages.Create(nil);
  try
    P.Orientation := poLandscape;
    P.WordWrapLeftCols := True;
    // the title of the report
    P.Caption := AReportName;
    // now we add some content to the report
    P.BeginDoc;
      // header and footer
    P.AddTextToHeader(AReportName);
    P.SaveLayout;
    P.Font.Style := [fsItalic];
    P.TextAlign := taRight;
    P.AddTextToFooterAt('VisualTax',P.RightMarginPos);
    P.RestoreSavedLayout;
    P.Font.Size := 9;
    P.AddTextToFooter(DateTimeToStr(Now));
    // main content (automaticaly split on next pages)
    P.NewHalfLine;
    P.DrawTitle(ATitle, true);
    for ICol := 0 to Length(ATitle2) - 1 do
      P.DrawText(ATitle2[ICol]);
    P.NewLine;
    SetLength(ColumnWidth, AStringGrid.ColCount);
    for ICol := 0 to AStringGrid.ColCount - 1 do
      ColumnWidth[ICol] := AStringGrid.ColWidths[ICol];
    P.AddColumns(ColumnWidth);
    SetLength(ColumnTitles, AStringGrid.ColCount);
    for ICol := 0 to AStringGrid.ColCount - 1 do
      ColumnTitles[ICol] := AStringGrid.Cells[ICol, 0];
    P.AddColumnHeaders(ColumnTitles, true, true);
    SetLength(Row, AStringGrid.ColCount);
    for IRow := 1 to AStringGrid.RowCount - 1 do
    begin
      for ICol := 0 to AStringGrid.ColCount - 1 do
        Row[ICol] := AStringGrid.Cells[ICol, IRow];
      P.DrawTextAcrossCols(Row);
    end;
    P.NewLine;
    P.EndDoc;
    // this method will show a preview form, and allow basic actions
    // by using the right click menu
    if AutoSaveToFile <> '' then
      P.ExportPDF(AutoSaveToFile, True, APreview)
    else
      if APreview then
        P.ShowPreviewForm
      else
        P.PrintPages(-1,-1)  ;
  finally
    P.Free;
  end;
end;

function TvtPDFPrinter.PrintForm(ARetNo: integer; AFormName: String; AWhichPage: Integer;
  AAfterReadComponent: TOnAfterReadComponent; APrintEditBox: TPrintEditBoxProc;
  APrepareRichEdit: TPrepareRichEditProc; APrintImage: TPrintImageProc;
  APrintHeader: TPrintHeaderProc): Boolean;
var
  lDfmFileName: String;
  lFormInstanse: Integer;
  lDummyForm: TForm;
  C: TComponent;
  I, J, tmp, lStartPage, lEndPage: Integer;
begin
  FPrintEditBox := APrintEditBox;
  FPrepareRichEdit := APrepareRichEdit;
  FPrintImage := APrintImage;
  FPrintHeader:= APrintHeader;
  FProblemText := ''; //20161212 Igor
  //get return
  FReturn := RetList[ARetNo];
  //Get working form name
  FFormName := FReturn.SubstituteForm(AFormName);
  //Get working form
  FForm := FReturn.FList.ByFormName(FFormName);
  if FForm.FormNo = 0 then
    exit(False);//20170811 Igor
  //get form instance
  lFormInstanse := ExtractFormInstNo(FFormName);
  // get dfm file name
  lDfmFileName := FReturn.GetDFMFileName(FFormName);
  // check exists dfm file
  If not FileExists(lDfmFileName) then
    exit(False);//20170811 Igor
  //create dummy for for TvtScrollbox
  lDummyForm := TForm.Create(Application);
  try
    lDummyForm.visible := False;
    //create childForm
    FFullForm := FReturn.FormClass.Create(lDummyForm, ARetNo, FForm.FormNo);
    try
      //read components
      if ReadComponentResFile(lDfmFileName, FFullForm) = nil then
        exit(False);//20170811 Igor
      //Call method afetr read component (hide panels in Letter and other)
      if Assigned(AAfterReadComponent) then
        AAfterReadComponent(TForm(FFullForm), FFormName);
      FisLetter := FReturn.IsLetterForm(FFormName);
      FisDynamic :=  FReturn.Form[FFormName].Dyn <> nil; //20161115 Igor
      // Call After open form (fill data, create dynamic rows and other)
      FFullForm.AfterOpenForm(vtdPrint);
      // Set forms scrollbar to 0
      FFullForm.vertscrollbar.position := 0;
      FFullForm.horzscrollbar.position := 0;

      //20230519 Igor >>>
      if FisDynamic then
      begin
        SetLength(FFullForm.PagebreakPos, 0);
        FFullForm.PrepareDynamicFormForPrint(FisLetter);
        FFormCountPages := 0;
        for I := 0 to high(FFullForm.PagebreakPos) - 1 do
          if not FFullForm.PagebreakPos[I].IsFooter then
            inc(FFormCountPages);
      end;
      if Length(FFullForm.PagebreakPos) = 0 then
        SetupPageBreaks;
      //20230519 Igor <<<

      SetupFonts; //20170212 Igor
      //Get print diapason
      if (AWhichPage > 0) and (AWhichPage <> 99) then
      begin
        lStartPage := AWhichPage - 1;
        lEndPage := AWhichPage - 1;
      end
      else
      begin
        lStartPage := 0;
        lEndPage := FFormCountPages - 1;
      end;

      FCurrPage := 1; //20230519 Igor
      //print pages
      for I := lStartPage to lEndPage do
        Self.PrintFormPage(I);
      Result := True;//20170811 Igor
    finally
      FreeAndNil(FFullForm);
    end;
  finally
    FreeAndNil(lDummyForm);
  end;
  //20161212 Igor
  if FProblemText <> '' then
    UserMsg('Warning! Print problem:'+#13 + FProblemText);
  //20161212 Igor
end;

procedure TvtPDFPrinter.PrintFormPage(APageNumber: Integer);
var
  WhiteBoxes: Boolean;
  //PageX, PageY: Integer; //20170212 Igor
  //WinFontSize, dpiAdjustment: Integer; //20170212 Igor
  xExtraDPIAdjustment, yExtraDPIAdjustment: Integer;
  lPageHeight: Integer;
  StartPageY, EndPageY, I, FooterHeight: Integer; //20230519 Igor
  const
    DefFontName = 'Arial';
  function inCurrentPage(AControl: TControl): Boolean;
  begin
    Result := (AControl.Top >= StartPageY) AND (AControl.Top < EndPageY);
  end;

  function PrepareLabelText(AText: string): string; //20230519 Igor
  begin
    Result := ReplaceStr(AText, '[#page]', IntToStr(FCurrPage));
    Result := ReplaceStr(Result, '[#pagecount]', IntToStr(FFormCountPages));
  end;

  procedure PrintControls(AControl: TWinControl; ADTop, ADLeft: Integer);
  var
    kk, i, b, j: Integer;
    MyVtGroupBox: TvtGroupBox;
    MyVtShape: TVtShape;
    MyLabel: TvtLabel;
    MyEditBox: TvtEdit;
    MyImage: TImage;
    MyRichEdit: TRichEdit;
    MyMemo: TMemo;
    MyFrame: TFrame;
    R: TRect;
    s: String;
    OldTop: Integer;
    OldCaption: String; //20230519 Igor
  Begin
    kk := AControl.ControlCount-1;
    for i := 0 to kk do
    begin
      if not inCurrentPage(AControl.Controls[i]) then
        continue;
      if AControl.Controls[i] is TvtGroupBox then
      begin //print the GroupBox
        MyVtGroupBox := AControl.Controls[i] as TvtGroupBox;
        if MyVtGroupBox.vtIsPrintable then
        begin
          PrintvtGroupBox(MyvtGroupBox, FPDFDocument.VCLCanvas, ADTop, ADLeft);
          PrintControls(MyvtGroupBox, MyvtGroupBox.Top+ADTop, MyvtGroupBox.Left+ADLeft)
        end;
      end

      else
      If AControl.Controls[i] is TVtShape then
      begin //print the shape
        MyVtShape:=AControl.Controls[i] as TVtShape;
        if MyVtShape.vtIsPrintable then
          PrintVtShape(MyVtShape, FPDFDocument.VCLCanvas, ADTop, ADLeft, True);
      end

      else
      if AControl.Controls[i] is TvtLabel then
      begin //print the label
        MyLabel:=AControl.Controls[i] as TvtLabel;
        //20230519 Igor >>>
        if MyLabel.vtIsPrintable then
        begin
          OldCaption := MyLabel.Caption;
          MyLabel.Caption := PrepareLabelText(MyLabel.Caption);
          PrintLabel(MyLabel, FPDFDocument.VCLCanvas, DefFontName, ADTop, ADLeft, True);
          MyLabel.Caption := OldCaption;
        end;
        //20230519 Igor <<<
      end

      else
      if AControl.Controls[i] is TvtEdit then
      begin //print the editbox
        MyEditBox:=AControl.Controls[i] as TvtEdit;
        if MyEditBox.vtIsPrintable then
          if Assigned(FPrintEditBox) then
            FPrintEditBox(FReturn.RetNo, MyEditBox, FFormName, FForm.FormNo, FPDFDocument.VCLCanvas.Handle,
              FPDFDocument.VCLCanvas, ADTop, ADLeft, True)
          else
            CustomPrintEditBox(FReturn.RetNo, MyEditBox, FFormName, FForm.FormNo, FPDFDocument.VCLCanvas.Handle,
              FPDFDocument.VCLCanvas, ADTop, ADLeft);
      end //tvedit

      else
      if AControl.Controls[i] is TImage then
      begin
        MyImage := AControl.Controls[i] as TImage;
        if Assigned(FPrintImage) then
          FPrintImage(FReturn.RetNo, FForm.FormName, MyImage, FPDFDocument.VCLCanvas, ADTop, ADLeft)
        else
          PrintImage(FReturn.RetNo, MyImage, FPDFDocument.VCLCanvas.Handle, FPDFDocument.VCLCanvas, ADTop, ADLeft);
      end

      else
      if AControl.Controls[i] is TRichEdit then
      begin
        MyRichEdit := AControl.Controls[i] as TRichEdit;
        if Assigned(MyRichEdit.Parent) then
        begin
          if Assigned(FPrepareRichEdit) then
            FPrepareRichEdit(FReturn.RetNo, FFormName, MyRichEdit);
          AppendRichEdit(MyRichEdit, ADTop, ADLeft, StartPageY, EndPageY); //20170127 Igor
//          PrintRichEdit(FReturn.RetNo, MyRichEdit, FPDFDocument.VCLCanvas, ADTop, ADLeft, FPDFDocument);
        end;
      end //richedit

      else
      if AControl.Controls[i] is TMemo then //TMemo
      begin
        MyMemo := AControl.Controls[i] as TMemo;
        AppendMemo(MyMemo, ADTop, ADLeft, StartPageY, EndPageY); //20161212 Igor //20170127 Igor
      end //memo

      else
      if AControl.Controls[i] is TFrame then
      begin //search in the frame
        MyFrame:=AControl.Controls[i] as TFrame;
        for j := 0 to MyFrame.ComponentCount - 1 do
        begin
          if MyFrame.Components[j] is TImage then
          begin //print the image
            MyImage := MyFrame.Components[j] as TImage;
            R.Left   := ScalePrX(MyFrame.Left + ADLeft);
            R.Top    := ScalePrY(MyFrame.Top + ADTop);
            R.Right  := R.Left +  ScalePrX(MyImage.Picture.Width);
            R.Bottom := R.Top  +  ScalePrY(MyImage.Picture.Height);
            PrintBitmap(FPDFDocument.VCLCanvas, R, MyImage.Picture.Bitmap);
          end;
        end;
      end;
    end;  //i components
    for I := 0 to length(FlblArr) - 1 do
    Begin
      //20230519 Igor >>>
      oldTop := FlblArr[I].vtLbl.Top;
      FlblArr[I].vtlbl.Top := FFullForm.PagebreakPos[APageNumber+1].Pos - FFullForm.PagebreakPos[APageNumber].Pos + FlblArr[I].deltaH + 15;
      s := FlblArr[I].vtLbl.Caption;
      if FlblArr[I].vtLbl.PrintEveryPageText <> '' then
      Begin
        FlblArr[I].vtLbl.Caption := ReplaceStr(FlblArr[I].vtLbl.PrintEveryPageText,'[#page]',IntToStr(APageNumber+1));
        FlblArr[I].vtLbl.Caption := ReplaceStr(FlblArr[I].vtLbl.Caption,'[#pagecount]',IntToStr(high(FFullForm.PagebreakPos)));
      End;
      PrintLabel(FlblArr[I].vtLbl, FPDFDocument.VCLCanvas);
      FlblArr[I].vtLbl.Caption := s;
      FlblArr[I].vtlbl.Top := oldTop;
      //20230519 Igor <<<
    End;
  End;
begin
  If AbortSw then exit;
  if FFullForm.PagebreakPos[APageNumber].IsFooter then Exit; //20230519 Igor
  WhiteBoxes := FForm.WhiteBoxes;

  //20230519 Igor >>>
  StartPageY := FFullForm.PagebreakPos[APageNumber].Pos;
  EndPageY := FFullForm.PagebreakPos[APageNumber + 1].Pos;
  FooterHeight := 0;
  // footer
  for I := 0 to Length(FFullForm.PagebreakPos) - 2 do
    if FFullForm.PagebreakPos[I].IsFooter then
    begin
      FooterHeight := FFullForm.PagebreakPos[I + 1].Pos - FFullForm.PagebreakPos[I].Pos;
      break;
    end;
  //20230519 Igor <<<

  lPageHeight := EndPageY - StartPageY;
  if not FForm.Landscape then
    if lPageHeight < (MxFrmHeight * 0.9) then
      lPageHeight := round(MxFrmHeight * 0.9);

  NewPageInternal(StartPageY, EndPageY + FooterHeight); //20170127 Igor //20230519 Igor

  If FReturn.Frm[FForm.FormNo].Count = 0 then
    InitFormData(FReturn.RetNo, FForm.FormNo);
     //20170212 Igor>>>
  Self.CalcScaleXY;
//  PageX := ToPDFUnit(FPDFPage.PageWidth - LM - RM);
//  PageY := ToPDFUnit(FPDFPage.PageHeight - TM - BM);
//
//  WinFontSize := GetWindowsFontSize(Application.MainForm.Handle);
//  dpiAdjustment := (WinFontSize * 100) div DesignPixelsPerInch;
(*20161211 Igor
  If FPDFPage.PageLandscape then
  begin
    PageX := Round(PageX * 3/4);
    PageY := Round(PageY * 1.9);
  end;
*)
//  xExtraDPIAdjustment := 0;
//  yExtraDPIAdjustment := 60;
//  if dpiAdjustment >= 119 then
//    yExtraDPIAdjustment := 50;
//  if dpiAdjustment >= 125 then
//    xExtraDPIAdjustment := (-660*dpiAdjustment)+82500;
////20161211 Igor >>>
//  If FPDFPage.PageLandscape then
//    ScaleX := (PageX * ScMult) div ( (MxFrmHeight  * dpiAdjustment + xExtraDPIAdjustment) div 100)
//  else
////20161211 Igor <<<
//    ScaleX := (PageX * ScMult) div ( (MxFrmWidth  * dpiAdjustment + xExtraDPIAdjustment) div 100);
//
//  if WinFontSize > 100 then
//    ScaleY := (PageY * ScMult) div ((((lPageHeight + yExtraDPIAdjustment) * 100 div dpiAdjustment) * dpiAdjustment) div 100)
//  else
//    ScaleY := (PageY * ScMult) div (((lPageHeight + yExtraDPIAdjustment) * dpiAdjustment) div 100);
 //20170212 Igor<<<
  If FApp.LicenseLevel = llDemo then
    PrintAtAngle('For Demo Purposes Only', FPDFDocument.VCLCanvas, 200, FPDFPage.PageHeight div 2-100,30,100);

  {Print Form Header}
  FPDFDocument.VCLCanvas.Font.Size := 8;
  {remove switches later}
  FPDFDocument.VCLCanvas.Font.Color := clBlack;
  FPDFDocument.VCLCanvas.Brush.Style := bsClear;
  {Print Header}
  if assigned(FPrintHeader) then
    FPrintHeader(FPDFDocument.VCLCanvas, FReturn.RetNo, FForm.FormName, FForm.FormNo,
      APageNumber, FPDFPage.PageHeight, FPDFPage.PageWidth, LM, TM);
  PrintControls(FFullForm, -StartPageY + TM, LM);

  //20230519 Igor >>>
  // footer
  for I := 0 to Length(FFullForm.PagebreakPos) - 2 do
    if FFullForm.PagebreakPos[I].IsFooter then
    begin
      StartPageY := FFullForm.PagebreakPos[I].Pos;
      EndPageY := FFullForm.PagebreakPos[I + 1].Pos;
      PrintControls(FFullForm, -StartPageY + lPageHeight + FooterHeight - TM, LM);
      break;
    end;
  Inc(FCurrPage);
  //20230519 Igor <<<
end;

procedure TvtPDFPrinter.PrintLestView(AReportName, ATitle: string;
  ATitle2: array of String; AListView: TListView; APreview: Boolean;
  AutoSaveToFile: string; AOrientation: TPrinterOrientation);//20170729 Igor
var
  P: TGDIPages;
  ICol, IRow: Integer;
  Row: array of String;
  ColumnWidth: Array of Integer;
  ColumnTitles: Array of String;
begin
  if not Assigned(AListView) then Exit;
  P := TGDIPages.Create(nil);
  try
    P.Orientation := AOrientation;
    P.WordWrapLeftCols := True;
    // the title of the report
    P.Caption := AReportName;
    // now we add some content to the report
    P.BeginDoc;
      // header and footer
    P.AddTextToHeader(AReportName);
    P.SaveLayout;
    P.Font.Style := [fsItalic];
    P.TextAlign := taRight;
    P.AddTextToFooterAt('VisualTax',P.RightMarginPos);
    P.RestoreSavedLayout;
    P.Font.Size := 9;
    P.AddTextToFooter(DateTimeToStr(Now));
    // main content (automaticaly split on next pages)
    P.NewHalfLine;
    P.DrawTitle(ATitle, true);
    for ICol := 0 to Length(ATitle2) - 1 do
      P.DrawText(ATitle2[ICol]);
    P.NewLine;
    SetLength(ColumnWidth, AListView.Columns.Count);
    for ICol := 0 to AListView.Columns.Count - 1 do
      ColumnWidth[ICol] := AListView.Columns.Items[ICol].Width;
    P.AddColumns(ColumnWidth);
    SetLength(ColumnTitles, AListView.Columns.Count);
    for ICol := 0 to AListView.Columns.Count - 1 do
      ColumnTitles[ICol] := AListView.Columns.Items[ICol].Caption;
    P.AddColumnHeaders(ColumnTitles, true, true);
    SetLength(Row, AListView.Columns.Count);
    for IRow := 1 to AListView.Items.Count - 1 do
    begin
      for ICol := 0 to AListView.Columns.Count - 1 do
      begin
        if ICol = 0 then
          Row[ICol] := AListView.Items.Item[IRow].Caption
        else
        if AListView.Items.Item[IRow].SubItems.Count >= ICol then
          Row[ICol] := AListView.Items.Item[IRow].SubItems[ICol - 1]
        else
          Row[ICol] := '';
      end;
      P.DrawTextAcrossCols(Row);
    end;
    P.NewLine;
    P.EndDoc;
    // this method will show a preview form, and allow basic actions
    // by using the right click menu
    if AutoSaveToFile <> '' then
      P.ExportPDF(AutoSaveToFile, True, APreview)
    else
      if APreview then
        P.ShowPreviewForm
      else
        P.PrintPages(-1,-1)  ;
  finally
    P.Free;
  end;
end;

procedure TvtPDFPrinter.SaveToFile(const AFileName: String; AShow: Boolean = True);
begin
  FPDFDocument.SaveToFile(AFileName);
  if AShow then
     ShellExecute(0, 'open', PWideChar(AFileName), PWideChar(''), PWideChar(ExtractFileDir(AFileName)), 1);
end;

procedure TvtPDFPrinter.SetupEveryPageLabel;
var
  I: Integer;
  L: TvtLabel;
  OldTop: Integer;
begin
  FPageFooterHeight := 0;
  OldTop := MaxInt;
  SetLength(FlblArr, 0); //20161211 Igor
  for i := 0 to FFullForm.ControlCount - 1 do
  begin
    if (FFullForm.Controls[i] is TVtLabel) then
    begin
      L := FFullForm.Controls[i] as TVtLabel;
      if L.PrintEveryPage then
      Begin
        SetLength(FlblArr, Length(FlblArr) + 1);
        FlblArr[length(FlblArr)-1].vtLbl := L;
        if FPageFooterHeight < (L.Top + L.Height) then
          FPageFooterHeight := (L.Top + L.Height);
        if OldTop > L.Top then
          OldTop := L.Top;
      End;
    end;
  end;
  for I := 0 to Length(FlblArr) - 1 do
  Begin
    FlblArr[I].deltaH := FlblArr[I].vtLbl.top - OldTop;
  End;
  if (FPageFooterHeight <> 0) or (OldTop <> MaxInt)  then
    FPageFooterHeight := FPageFooterHeight - OldTop;
end;

procedure TvtPDFPrinter.SetupFonts; //20170212 Igor
var
  I: Integer;
begin
  for i := 0 to FFullForm.ControlCount - 1 do
//20170213 Igor >>>  
//  if FFullForm.Controls[i] is TvtLabel then
//    (FFullForm.Controls[i] as TvtLabel).Font.Size :=
//       Round(-(FFullForm.Controls[i] as TvtLabel).Font.Height * 72 / 96)
//  else
//  if FFullForm.Controls[i] is TvtEdit then
//    (FFullForm.Controls[i] as TvtEdit).Font.Size :=
//       Round(-(FFullForm.Controls[i] as TvtEdit).Font.Height * 72 / 96)
//  else
    If FFullForm.Controls[i] is TRichEdit then
      CorrectRichEditFontSize(TRichEdit(FFullForm.Controls[i]), FisLetter);
//20170213 Igor <<<
end;

procedure TvtPDFPrinter.SetupPageBreaks; //20230519 Igor
var
  C: TComponent;
  I, J, LastComponentDifferencial, lastPageBreakPos,
  PageBreaksToAdd, oldTop: Integer;
  NeedBreak: Boolean;
  tmp: TPageBreak;
  procedure SortArray; //20230519 Igor
  var
    A, B: Integer;
  begin
    for A := high(FFullForm.PagebreakPos)-1 Downto low(FFullForm.PagebreakPos) do
    begin
      for B := A to high(FFullForm.PagebreakPos)-1 do
      begin
        if FFullForm.PagebreakPos[B].Pos > FFullForm.PagebreakPos[B + 1].Pos then
        begin
          tmp := FFullForm.PagebreakPos[B];
          FFullForm.PagebreakPos[B] := FFullForm.PagebreakPos[B + 1];
          FFullForm.PagebreakPos[B + 1] := tmp;
        end;
      end;
    end;
  end;
begin
  lastPageBreakPos := 0;
  for C in FFullForm do
    If C is TVtShape and (C as TVtShape).vtPageBreak then
    begin
      (C as TVtShape).Top := (C as TVtShape).Top - FPageFooterHeight;
      if ((C as TVtShape).Top + (C as TVtShape).Height) > lastPageBreakPos then
        lastPageBreakPos := (C as TVtShape).Top + (C as TVtShape).Height;
    end;

  //find if component after last page break and how far past
  LastComponentDifferencial := -1;
  for i := 0 to FFullForm.ControlCount - 1 do
  begin
    if FFullForm.Controls[i].top > lastPageBreakPos then
    begin
      LastComponentDifferencial := FFullForm.Controls[i].top - lastPageBreakPos;
    end;
  end;

  PageBreaksToAdd := 0;
  if LastComponentDifferencial >= 0 then
    PageBreaksToAdd := (LastComponentDifferencial div (1000 - FPageFooterHeight)) + 1;


  for i := 1 to PageBreaksToAdd do
  begin
    with TvtShape.create(FFullForm) do
    begin
      Parent := FFullForm;
      vtPageBreak := true;
      Top := lastPageBreakPos + ((1000 - FPageFooterHeight) * i);
    end;
  end;

  //first break
  SetLength(FFullForm.PagebreakPos, 1);
  FFormCountPages := 0;
  FFullForm.PagebreakPos[0].Pos := 0;
  //determine if multiple pages
  for C in FFullForm do
  begin
    If C is TVtShape then
    begin
      if (C as TVtShape).vtPageBreak then
      begin
        SetLength(FFullForm.PagebreakPos, length(FFullForm.PagebreakPos)+1);
        FFormCountPages := FFormCountPages + 1;
        FFullForm.PagebreakPos[FFormCountPages].Pos := (C as TVtShape).Top;
      end
      else
        (C as TVtShape).SendToBack;
    end;
  end; //C in lFullForm

  //sort array
  SortArray;

  //if not multipage
  if FFormCountPages = 0 then
  begin
    FFormCountPages := 1;
    SetLength(FFullForm.PagebreakPos, 2);
    FFullForm.PagebreakPos[1].Pos := FForm.FormHeight;
  end;
  //split long pages (only dynamic form)
  if FisDynamic then //20161115 Igor
  begin
    for i := length(FFullForm.PagebreakPos)-1 downto 1 do
    begin
      if ((FFullForm.PagebreakPos[I].Pos -FFullForm. PagebreakPos[I-1].Pos) > (1000 - FPageFooterHeight)) then  //20161115 Igor
      begin
        oldTop := FFullForm.PagebreakPos[I-1].Pos + (1000 - FPageFooterHeight);
        while oldTop < FFullForm.PagebreakPos[I].Pos do
        Begin
          NeedBreak:= False;
          for j := 0 to FFullForm.ControlCount - 1 do
          Begin
            if ((FFullForm.Controls[j].Top) >= oldTop) and
               ((FFullForm.Controls[j].Top) < FFullForm.PagebreakPos[I].Pos) and
                (FFullForm.Controls[j].Visible) then
            Begin
              if ((FFullForm.Controls[i] is TvtEdit) AND
                  (FFullForm.Controls[i] as TvtEdit).vtIsPrintable) or
                 ((FFullForm.Controls[i] is TvtLabel) AND
                  (FFullForm.Controls[i] as TvtLabel).vtIsPrintable) or
                 ((FFullForm.Controls[i] is TvtShape) AND
                  (FFullForm.Controls[i] as TvtShape).vtIsPrintable) then
              Begin
                NeedBreak := True;
                break;
              End;
            End;
          End;
          if NeedBreak then
          Begin
            SetLength(FFullForm.PagebreakPos, length(FFullForm.PagebreakPos)+1);
            FFullForm.PagebreakPos[length(FFullForm.PagebreakPos)-1].Pos := oldTop;
            oldTop := OldTop + (1000 - FPageFooterHeight);
            inc(FFormCountPages);
          End
          else
            break;
        end;
      end;
    end;
  end;
  //sort array
  SortArray;
end;

procedure TvtPDFPrinter.Show;
var
  tmpFileName: String;

  function MyGetTempFile(const APrefix: string): string;
  var
    MyBuffer, MyFileName: array[0..MAX_PATH] of char;
  begin
    FillChar(MyBuffer, MAX_PATH, 0);
    FillChar(MyFileName, MAX_PATH, 0);
    GetTempPath(SizeOf(MyBuffer), MyBuffer);
    GetTempFileName(MyBuffer, PWideChar(APrefix), 0, MyFileName);
    Result := MyFileName;
  end;
begin
  tmpFileName := MyGetTempFile('vtp')+'.pdf';
  ShellExecute(0, 'open', PWideChar(tmpFileName), PWideChar(''), PWideChar(ExtractFileDir(tmpFileName)), 1);
end;

procedure TvtPDFPrinter.AddPrintProblem(AText: String); //20161212
begin
  if FProblemText <> '' then
    FProblemText := FProblemText + #13;
  FProblemText := FProblemText + AText;
end;

procedure TvtPDFPrinter.AppendMemo(AMemo: TMemo; ADTop, ADLeft, AStartPageY, AEndPageY: Integer); //20161212 Igor //20170127 Igor
var
  LineNo, MemoNo, Spacer: Integer;
  AllowMultiPage: Boolean;
const
  SpacerIncAmount: integer = 13;
begin
  MemoNo := GetFieldId(AMemo.Name);
  AMemo.Text := FReturn.Frm[FForm.FormNo].Memos[MemoNo];
  Spacer := AMemo.Top + ADTop;
  FPDFDocument.VCLCanvas.Font.Assign(AMemo.Font);
  if AMemo is TvtMemo then
    AllowMultiPage := (SpacerIncAmount * TvtMemo(AMemo).vtMaxLines) > ToPDFUnit(FPDFPage.PageHeight)
  else
    AllowMultiPage := False;
  for LineNo := 0 to AMemo.Lines.count - 1 do
  begin
    FPDFDocument.VCLCanvas.Textout(ScalePrX(AMemo.Left + ADLeft), ScalePrY(Spacer), AMemo.Lines[LineNo]);
    inc(Spacer, SpacerIncAmount);
    if (Spacer + SpacerIncAmount) > AMemo.Top + ADTop + AMemo.Height then
    begin
      if Not AllowMultiPage then
      begin
        AddPrintProblem('Text memo has been truncated! [Form: '+FForm.FormName + '; Memo: '+IntToStr(MemoNo)+']');
        break;
      end
      else
      begin
        NewPageInternal(AStartPageY, AEndPageY); //20170127 Igor
        Spacer := TM;
      end;
    end;
  end;
end;

procedure TvtPDFPrinter.AppendRichEdit(RichEdit: TRichEdit; ADTop, ADLeft, AStartPageY, AEndPageY: Integer); //20170127 igor
var Range: TFormatRange;
    LogX, LogY, LastChar, MaxLen, OldMap: integer;
    TextLenEx: TGetTextLengthEx; // RichEdit 2.0 Window Class
    oldFontName: String;
    oldFontSize, oldFontColor, oldDC: Integer;
    oldFontStyle: TFontStyles;
begin
  if (Self<>nil) and (FPDFDocument.VCLCanvas<>nil) then
  begin
    OldDC := SaveDC(FPDFDocument.VCLCanvas.Handle);
    try
      with Range do
      begin
        LogX := GetDeviceCaps(FPDFDocument.VCLCanvas.Handle, LOGPIXELSX);
        LogY := GetDeviceCaps(FPDFDocument.VCLCanvas.Handle, LOGPIXELSY);
        rcPage.Left := (ScalePrX(RichEdit.Left + ADLeft) * 1440) div LogX;
        rcPage.Right := (ScalePrX(RichEdit.Left + ADLeft + RichEdit.Width) * 1440) div LogX;
        if not FisLetter then
          rcPage.Right := rcPage.Right + round((rcPage.Right - rcPage.Left)*0.1); //+ 10% to space
        rcPage.Top := (ScalePrY(RichEdit.Top + ADTop) * 1440) div LogY;
        //20161115 Igor >>>
        if not FisLetter then
          rcPage.Bottom := ScalePrY(RichEdit.Top + ADTop + RichEdit.Height) * 1440 div LogY
        else
          rcPage.Bottom := (ToPDFUnit(FPDFPage.PageHeight) - BM) * 1440 div LogY;
        //20161115 Igor <<<
        rc := rcPage;
        LastChar := 0;
        with TextLenEx do begin
          flags := GTL_DEFAULT;
          codepage := CP_ACP;
        end;
        MaxLen := SendMessage(RichEdit.Handle, EM_GETTEXTLENGTHEX, Integer(@TextLenEx), 0);
        chrg.cpMax := -1;
        OldMap := SetMapMode(hdc, MM_TEXT);
        try
          SendMessage(RichEdit.Handle, EM_FORMATRANGE, 0, 0);
          repeat
            chrg.cpMin := LastChar;
            hdc := FPDFDocument.VCLCanvas.Handle;
            hdcTarget := hdc;
            LastChar := SendMessage(RichEdit.Handle, EM_FORMATRANGE, 1, Integer(@Range));
            if (cardinal(LastChar)>=cardinal(MaxLen)) or not FisLetter then
              break;
            NewPageInternal(AStartPageY, AEndPageY); //20170127 Igor
            rc := rcPage;
          until false;
        finally
          SendMessage(RichEdit.Handle, EM_FORMATRANGE, 0, 0);
          SetMapMode(hdc, OldMap);
        end;
      end;
    finally
      RestoreDC(FPDFDocument.VCLCanvas.Handle, OldDC);
    end;
  end;
end;

end.
