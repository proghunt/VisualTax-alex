unit T4T5_2026print;

// 20170123 Igor Update all pas (print T4 => T4T5)

(*
  FName = 'OPG_2' then BmpName := 'ONPG2l.BMP'
  Else If FName = 'OS101_1' then BmpName := 'ONSchAL.BMP'
  Else If FName = 'OS101_2' then BmpName := 'ONSchBL.BMP'
  Else If FName = 'OS101_3' then BmpName := 'ONSchDL.BMP'
  Else If FName = 'OS113' then BmpName := 'ONSchFL.BMP'
  else If FName = 'OPGS_2' then BmpName := 'ONPG2S.BMP'
  Else If FName = 'OSFG'   then BmpName := 'ONSchfS.BMP';
  SomeImage.LoadFromFile(AppDir+'\'+BmpName);
  Printer.Canvas.StretchDraw(R,SomeImage);
  SomeImage.Free;
*)

interface

uses SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics,
  Controls,
  Forms, StdCtrls, Dialogs, Printers, extctrls, vtEditBox, vtShape, vtLabel,
  RichEdit, ComCtrls,
  vtGroupBox, vtForm, vtDataBase, // 20160407 Igor
  vtPDFPrinter, uADCompClient, // 20171221 Igor

  rxRichEd; // 20160819 Igor (Must be last)

// 20170212 Igor >>>
type
  TSlipType = (stGovernment, stEmployee, stPreparer);
  TSlipTypes = set of TSlipType;

const
  stDefault = [stGovernment, stEmployee, stPreparer];

  // 20170212 Igor <<<
type
  // 20170123 Igor >>>
  TPrintFormSetting = record
    FormName: string;
    FormInst: string;
    FormNo: Integer;
    FormHeight: Integer;
    RootForm: string;
    DFM: string;
    Parts: Integer;
    PartsInPage: Integer; // 20171228 Igor
    ElementInParts: Integer;
    SlipType: TSlipType; // 20171226 Igor
    BottomColontitulElm: Integer; // 20171228 Igor
    BottomColontitulText: TArray<string>; // 20171228 Igor
  end;

  TPrintFormSettings = array of TPrintFormSetting;

  // 20170123 Igor <<<
Const
  MxFrmHeight = 1050; // 1050; //980; //960;

Const
  MxFrmWidth = 655;

CONST
  RTF_INDENT_LEFT = 80; // 20160210 Igor
  RTF_INDENT_RIGHT = 60; // 20160210 Igor

Procedure AfterReadComponentForPrint(AForm: TForm;
  APrintFormSetting: TPrintFormSetting);
Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0;
  ADLeft: Integer = 0; AOnlyValue: Boolean = False); // 20170212 Igor
Procedure PrintBarcodeBitmap(RetNo: Integer; Canvas: TCanvas;
  BarCodeImage1: TImage; BarCodeImage2: TImage);
Procedure PrintSFDBarcodeBitmap(RetNo: Integer; Canvas: TCanvas;
  SFDBarCodeImage1: TImage; SFDBarCodeImage2: TImage);

// Function PrintQuickReport(RetNo: integer; FName: string;WhichPage:integer): boolean;
{ Procedure PrintALetter(RetNo:Integer;LetterName:String); }

procedure PrintForm(RetNo: Integer; FName: string; WhichPage: Integer;
  LastFormToPrint: String; ASlipsTypes: TSlipTypes = stDefault;
  AOnlyValue: Boolean = False); // 20170212 Igor
procedure PrintFormPage(RetNo: Integer; FName: string; AForm: TForm;
  numPagePrinting, formNumPages: Integer; formPagebreakHeight: Integer;
  LastFormToPrint: String; AOnlyValue: Boolean; pStart, pEnd: Integer);
// 20170212 Igor//20171228 Igor
Procedure PrintDynamicForm(RetNo: Integer; FName: String); // 20160901 Igor
{ Function PDFPrintFormPage(RetNo: integer; FName: string): boolean; }

Function adjustForCertif(Text: String; FName: String; FieldId: Integer): String;

function GetPrintFormSettings(AFormName: String; ASlipsTypes: TSlipTypes)
  : TPrintFormSettings; // 20170123 //20170210 igor

procedure PrintEmployerIssuer; // 20171221 Igor
function GenerateEmployerIssueSQL: string; // 20171223 Igor
procedure PrintT4Audit(const ARetNo: Integer); // 20171226 Igor
procedure PrintT4AAudit(const ARetNo: Integer); // 20171226 Igor
procedure PrintT5Audit(const ARetNo: Integer); // 20171226 Igor
procedure PrintEmployersList; // 20171227 Igor

Var
  // ScaleX, ScaleY : Word;
  PFile: TextFile;
  HeaderType: string; // [1];
  PRINTCNT, PGNO: Integer;
  ThisMccrA: string; // [10];

  maxBarDataLength: Integer;

  NeedNewPage: Boolean; // 20160901 Igor

implementation

uses
  vtMulti, vtCommon, vtMain, vtDialogs, uFlagFrameCan,
  T4T5_2026, T4T5_2026TrimStr,
  T4T5_2026Declare, T4T5_2026Common, T4T5_2026Common2, T4T5_2026Progres,
  T4T5_2026Calc,
  T4T5_2026ChildWinNew, T4T5_2026Main, vtPrints, vtTrimStr, vtShared
  {,RegularExpressions} , vtChild,
  // 20151214 Igor //20160405 Igor //20160903 Igor
  vtDynData, IOUtils; // 20160901 Igor//20171226 Igor

// 20171228 Igor>>>
type
  TFormT4T5_2026Ex = class(TFormT4T5_2026)
  private
    FDFM: string;
    PartNo: Integer;
  end;

var
  FullFormToPrint: TFormT4T5_2026Ex = nil;
  FGlob: TForm = nil;

procedure FillData(AForm: TForm; APrintForm: TFormT4T5_2026Ex;
  APrintFormSetting: TPrintFormSetting; APageID: Integer; APrintIfFull: TProc);
var
  I, J, FieldId: Integer;
  E1: TvtEdit;
  E2: TComponent;
  procedure SetText(AFieldID: Integer; AText: String);
  var
    E: TComponent;
  begin
    E := APrintForm.FindComponent('vtEdit' + IntToStr(AFieldID));
    if (E <> nil) and (E is TvtEdit) then
      TvtEdit(E).Text := AText;
  end;
// 20171226 Igor>>>
  function SkipValue(AEdit: TvtEdit): Boolean;
  begin
    Result := False;
    if APrintFormSetting.SlipType = stEmployee then
    Begin
      // 20180107 CON
      If (APrintFormSetting.RootForm = 'T4') and (AEdit.FieldId = 5) then
      begin
        Result := True;
        Exit;
      End
      Else If (APrintFormSetting.RootForm = 'T4A') and (AEdit.FieldId = 3) then
      begin
        Result := True;
        Exit;
      End
    end;

    (*
      Result := SameText(APrintFormSetting.RootForm, 'T4')
      and
      (APrintFormSetting.SlipType = stEmployee)
      and
      (AEdit.FieldId = 5);
    *)
  end;

// 20171226 Igor<<<
begin
  // Fill data to bottom part
  for I := 0 to APrintFormSetting.Parts - 1 do
  begin
    if APrintForm.PartNo = APrintFormSetting.PartsInPage then
      if Assigned(APrintIfFull) then
        APrintIfFull;
    for J := 0 to AForm.ComponentCount - 1 do
    begin
      if AForm.Components[J] is TvtEdit then
      begin
        E1 := AForm.Components[J] as TvtEdit;
        FieldId := GetFieldId(E1.Name);
        if (APrintFormSetting.ElementInParts = 0) or
          (FieldId <= APrintFormSetting.ElementInParts) then
        begin
          E2 := APrintForm.FindComponent
            ('vtEdit' + IntToStr((APrintForm.PartNo *
            APrintFormSetting.ElementInParts) + FieldId));
          if SkipValue(E1) then
            E1.Text := ''
          else if (E2 <> nil) and (E2 is TvtEdit) then // 20171226 Igor
            TvtEdit(E2).Text := E1.Text;
        end;
      end;
    end;
    if (APrintFormSetting.BottomColontitulElm <> 0) and
      (Length(APrintFormSetting.BottomColontitulText) > I) then
      SetText(APrintFormSetting.BottomColontitulElm +
        (APrintForm.PartNo * APrintFormSetting.ElementInParts),
        APrintFormSetting.BottomColontitulText[I]);
    APrintForm.PartNo := APrintForm.PartNo + 1;
  end;
end;

Procedure PrintClientLetter(RetNo: Integer);
Var
  LtrName: String;
begin
  LtrName := GetClientLettersDir + '\' + MkClientLetterName(RetNo);
  If not FileExists(LtrName) then
    LtrName := AppDir + '\' + 'DefaultCover.LTR';
end;

procedure DoPrintForm(RetNo, WhichPage: Integer; LastFormToPrint: string;
  AOnlyValue: Boolean);
var
  PagebreakPos: array of Integer;
  formNumPages, PagebreakHeight: Integer;
  MyLabel: TvtLabel;
  MyEditBox: TvtEdit;
  MyVtShape: TvtShape;

  I, J, tmp: Integer;
  endPage, startPage: Integer;
  procedure Clear(AWinControl: TWinControl);
  var
    I: Integer;
  begin
    for I := 0 to AWinControl.ControlCount - 1 do
    begin
      if AWinControl.Controls[I] is TWinControl then
        Clear(AWinControl.Controls[I] as TWinControl);
      if FullFormToPrint.Controls[I] is TvtEdit then
        (FullFormToPrint.Controls[I] as TvtEdit).Text := '';
      //20221222 Igor >>>
      {if FullFormToPrint.Controls[I] is TRichEdit then
        (FullFormToPrint.Controls[I] as TRichEdit).Text := '';}
      //20221222 Igor <<<
     // if FullFormToPrint.Controls[I] is TRichEdit then (FullFormToPrint.Controls[I] as TRichEdit).Text := '';
    end;
  end;

begin
  SetLength(PagebreakPos, 1);
  formNumPages := 0;
  PagebreakPos[0] := 0;

  // determine if multiple pages
  for I := 0 to FullFormToPrint.ControlCount - 1 do
  begin
    If FullFormToPrint.Controls[I] is TRichEdit then
      IncRichEditFontSize(TRichEdit(FullFormToPrint.Controls[I]),
        2 * MainOptions.Prn_FontIncr,
        IsFormAClientLetter(FullFormToPrint.FormName)); // 20170204 Igor
    If FullFormToPrint.Controls[I] is TvtShape then
    begin
      if (FullFormToPrint.Controls[I] as TvtShape).vtPageBreak then
      begin
        MyVtShape := FullFormToPrint.Controls[I] as TvtShape;
        SetLength(PagebreakPos, Length(PagebreakPos) + 1);
        formNumPages := formNumPages + 1;
        MyVtShape.Name := MyVtShape.Name;
        PagebreakPos[formNumPages] :=
          (FullFormToPrint.Controls[I] as TvtShape).Top;
      end
      else // avoid shape printing covering other components
        (FullFormToPrint.Controls[I] as TvtShape).SendToBack;
    end;

    // 20130219
    // give TImage in TFlagFrameCan unique name to avoid "already exists" error when more than one TFlagFrameCan
    if FullFormToPrint.Controls[I] is TFlagFrameCan then
    begin
      // showmessage(TFlagFrameCan(FullForm.Controls[i]).name);//showmessage(FullForm.Controls[i].Components[0].name);
      FullFormToPrint.Controls[I].Components[0].Name :=
        TFlagFrameCan(FullFormToPrint.Controls[I]).Name +
        FullFormToPrint.Controls[I].Components[0].Name;
    end;

  end; // i components

  // sort array
  for I := high(PagebreakPos) - 1 Downto low(PagebreakPos) do
  begin
    for J := I to high(PagebreakPos) - 1 do
    begin
      if PagebreakPos[J] > PagebreakPos[J + 1] then
      begin
        tmp := PagebreakPos[J];
        PagebreakPos[J] := PagebreakPos[J + 1];
        PagebreakPos[J + 1] := tmp;
      end;
    end;
  end;

  if formNumPages = 0 then
  begin
    formNumPages := 1;
    SetLength(PagebreakPos, 2);
    PagebreakPos[1] := GetFormHeight(FullFormToPrint.FormName);
  end;
  if (WhichPage > 0) and (WhichPage <> 99) then
  begin
    // settings to print one page
    startPage := WhichPage - 1;
    endPage := WhichPage - 1;
  end
  else
  begin
    startPage := 0;
    endPage := formNumPages - 1;
  end;

  /// ///Start of one page multi form printing -------------------------------------

  for J := startPage to endPage do
  begin
    PagebreakHeight := PagebreakPos[J + 1] - PagebreakPos[J];

    PrintFormPage(RetNo, FullFormToPrint.FormName, TForm(FullFormToPrint), J,
      formNumPages, PagebreakHeight, LastFormToPrint, AOnlyValue,
      PagebreakPos[J], PagebreakPos[J + 1]); // 20170212 Igor
  end; // end for j:=startPage to endPage

  FullFormToPrint.PartNo := 0;
  Clear(FullFormToPrint);
end;

procedure PrintForm(RetNo: Integer; FName: string; WhichPage: Integer;
  LastFormToPrint: String; ASlipsTypes: TSlipTypes = stDefault;
  AOnlyValue: Boolean = False); // 20170212 Igor
Var
  I, J, n: Integer;
  Root: string;
  SubstFrm: string; // [12];
  FullForm: TvtScrollBox;

  PrintFormSettings: TPrintFormSettings;
  printStep: Integer;
  FLoc: TForm;
  FNo: Integer; // 20180205
begin
  FLoc := nil;
  if FName.ToUpper.StartsWith('T4#') or FName.ToUpper.StartsWith('T4A#') or
    FName.ToUpper.StartsWith('T5#') then
    WhichPage := 0;
  PrintFormSettings := GetPrintFormSettings(FName, ASlipsTypes);

  // 20180105
  if LeftStr(FName, 5) = 'T4A_2' then
  begin
    FNo := GetFormNo(FName);
    if FNo > 0 then
      StoreElm(RetNo, FNo, 3, '');
    // 20180105 Hide employers Acount from Employes slips
  end;

  for printStep := Low(PrintFormSettings) to High(PrintFormSettings) do
  Begin
    Try
      If FileExists(PrintFormSettings[printStep].DFM) = False then
        Exit;
      if not Assigned(FLoc) then
      begin
        FLoc := TForm.Create(Application);
        FLoc.visible := False;
      end;
      FullForm := TFormT4T5_2026.Create(FLoc, RetNo,
        PrintFormSettings[printStep].FormNo);
      if ReadComponentResFile(PrintFormSettings[printStep].DFM, FullForm) = nil
      then
      begin
        FreeAndNil(FullForm);
        FreeAndNil(FLoc);
        Exit;
      end;
      AfterReadComponentForPrint(TForm(FullForm), PrintFormSettings[printStep]);
      FullForm.AfterOpenForm(vtdPrint);
      FullForm.PopulateFormWithData;

      if Assigned(FullFormToPrint) and
        ((FullFormToPrint.FDFM <> PrintFormSettings[printStep].DFM) or
        (FullFormToPrint.RetNo <> RetNo)) then
        FreeAndNil(FullFormToPrint);
      if Not Assigned(FGlob) then
      begin
        FGlob := TForm.Create(Nil);
        FGlob.visible := False;
      end;
      if Not Assigned(FullFormToPrint) then
      begin
        FullFormToPrint := TFormT4T5_2026Ex.Create(FGlob, RetNo,
          PrintFormSettings[printStep].FormNo);
        FullFormToPrint.FDFM := PrintFormSettings[printStep].DFM;
        if ReadComponentResFile(PrintFormSettings[printStep].DFM,
          FullFormToPrint) = nil then
        begin
          FreeAndNil(FullFormToPrint);
          FreeAndNil(FullForm);
          FreeAndNil(FLoc);
          FreeAndNil(FGlob);
          Exit;
        end;
        AfterReadComponentForPrint(TForm(FullFormToPrint),
          PrintFormSettings[printStep]);
      end;
      FullFormToPrint.FormName := FName;

      FullForm.AfterOpenForm(vtdPrint);

      FillData(TForm(FullForm), FullFormToPrint, PrintFormSettings[printStep],
        printStep,
        procedure
        begin
          DoPrintForm(RetNo, WhichPage, LastFormToPrint, AOnlyValue);
        end);

      FullFormToPrint.vertscrollbar.position := 0;
      FullFormToPrint.horzscrollbar.position := 0;

      if (FullFormToPrint.PartNo = PrintFormSettings[printStep].PartsInPage) or
        ((FullFormToPrint.PartNo > 0) and ((LastFormToPrint = '') or
        (LastFormToPrint = FName))) then
        DoPrintForm(RetNo, WhichPage, LastFormToPrint, AOnlyValue);
      FreeAndNil(FullForm);
      FreeAndNil(FLoc);
    Except
      ShowMessage(FName + ' encountered printing problem'); // 20101208
    end;
  End;
end;
// 20171228 Igor<<<

procedure PrintFormPage(RetNo: Integer; FName: string; AForm: TForm;
numPagePrinting, formNumPages: Integer; formPagebreakHeight: Integer;
LastFormToPrint: String; AOnlyValue: Boolean; pStart, pEnd: Integer);
// 20170212 igor//20171228 Igor
var
  // FldRec: PFieldList; //LblRec : PLabelList;  LnRec : PLineList;
  dpiAdjustment, FrmHeight, PenWidth, FNo, d, k, x, y, XPos, YPos: Integer;
  PageX, PageY: LongInt;
  S, Astring, FormattedAmount: string;
  R: TRect;
  Point1, Point2: TPoint;
  PixelsPerInch: TPoint;
  NullString: Array [0 .. 20] of Char;
  { Null terminated string variable/ c type }
  hdc: THandle;
  TempShadeSw: Boolean;
  Ht, Wt: Real; // height and width
  PFName: PChar;
  ImageRect: TRect;
  BarCodeBmp, SomeImage: TBitMap;
  ARichEdit: TRichEdit;
  DfmFileName: String;
  ACanvas: TCanvas;
  MyLabel: TvtLabel;
  MyEditBox: TvtEdit;
  AImage, AImage1, ASFDImage, ASFDImage1: TImage;
  MyShape: TShape;
  MyVtShape: TvtShape;
  MyVtGroupBox: TvtGroupBox; // 20160407 Igor

  MyFrame: TFrame;
  MyBitmap: TBitMap;
  MyImage: TImage;

  Wmf: TMetafile;
  WmfCanvas: TMetafileCanvas;
  WinFontSize: Integer;
  DC: THandle;
  xExtraDPIAdjustment, yExtraDPIAdjustment: Integer;
  lCurrPageisLandscape: Boolean; // 20170127 igor

  RealHeight, RealWidth: Integer; // 20170301 Igor
  // 20171228 Igor>>>
  function inCurrentPage(AControl: TControl): Boolean;
  begin
    Result := (AControl.Top >= pStart) AND (AControl.Top < pEnd);
  end;
// 20171228 Igor<<<
  procedure PrintControls(AControl: TWinControl; ADTop, ADLeft: Integer);
  // 20160407 Igor
  var
    kk, I, b, J: Integer;
  Begin
    kk := AControl.ControlCount - 1;
    // print TvtLabels that are black boxes first
    if not AOnlyValue then // 20170212 Igor
      for I := 0 to kk do
      begin
        // 20171228 Igor>>>
        if not inCurrentPage(AControl.Controls[I]) then
          Continue;
        // 20171228 Igor<<<
        If AControl.Controls[I] is TvtLabel then
        begin // print the shape
          MyLabel := AControl.Controls[I] as TvtLabel;

          if (MyLabel.vtBlackBox) and (MyLabel.vtIsPrintable) then
          begin
            PrintLabel(MyLabel, ACanvas, DefFontName, ADTop, ADLeft);
          end;
        end
      end;

    // print rest of TvtShapes before other elements to avoid printing over other elements
    if not AOnlyValue then // 20170212 Igor
      for I := 0 to kk do
      begin
        // 20171228 Igor>>>
        if not inCurrentPage(AControl.Controls[I]) then
          Continue;
        // 20171228 Igor<<<
        If AControl.Controls[I] is TvtShape then
        begin // print the shape
          MyVtShape := AControl.Controls[I] as TvtShape;
          if MyVtShape.vtIsPrintable then
          begin
            PrintVtShape(MyVtShape, ACanvas, ADTop, ADLeft);
          end;
        end
      end;

    for I := kk downto 0 do
    begin
      // 20171228 Igor>>>
      if not inCurrentPage(AControl.Controls[I]) then
        Continue;
      // 20171228 Igor<<<
      if AControl.Controls[I] is TvtGroupBox then
      begin // print the GroupBox
        MyVtGroupBox := AControl.Controls[I] as TvtGroupBox;
        if MyVtGroupBox.vtIsPrintable then
        begin
          if not AOnlyValue then // 20170212 Igor
            PrintvtGroupBox(MyVtGroupBox, ACanvas, ADTop, ADLeft);
          PrintControls(MyVtGroupBox, MyVtGroupBox.Top + ADTop,
            MyVtGroupBox.Left + ADLeft)
        end;
      end
      else if (AControl.Controls[I] is TvtLabel) and not AOnlyValue then
      // 20170212 Igor
      begin // print the label
        MyLabel := AControl.Controls[I] as TvtLabel;
        if (MyLabel.vtIsPrintable) and (not MyLabel.vtBlackBox) then
          PrintLabel(MyLabel, ACanvas, DefFontName, ADTop, ADLeft);
      end
      else if AControl.Controls[I] is TvtEdit then
      begin // print the editbox
        MyEditBox := AControl.Controls[I] as TvtEdit;
        if MyEditBox.vtIsPrintable then
        begin
          PrintEditBox(RetNo, MyEditBox, FName, FNo, hdc, ACanvas, ADTop,
            ADLeft, AOnlyValue); // 20170212 Igor
        end;
      end // tvedit
      else if (AControl.Controls[I] is TRichEdit) and not AOnlyValue then
      // RichEdit //20170212 Igor
      begin
        ARichEdit := AControl.Controls[I] as TRichEdit;
        if Assigned(ARichEdit.Parent) then
        begin // 20151016 igor
          if IsFormAClientLetter(FName) then
          begin
            GetInterpetedRichEdit(RetNo, GetLetterFileName(RetNo, FName),
              ARichEdit);
            yield; // Delay(50);
          end;
          PrintRichEdit(RetNo, ARichEdit, ACanvas, ADTop, ADLeft,
            IsFormAClientLetter(FName)); // 20170109 Igor
        end;
      end // richedit
      else if (AControl.Controls[I] is TMemo) and not AOnlyValue then
      // TMemo //20170212 Igor
      begin
        PrintMemo(RetNo, AControl.Controls[I] as TMemo, ACanvas, ADTop, ADLeft);
      end // memo
      else
        // 20171226 Igor>>>
        if (AControl.Controls[I] is TImage) and not AOnlyValue then
        begin // print the image
          MyImage := AControl.Controls[I] as TImage;
          R.Left := ScalePrX(MyImage.Left + ADLeft); // ScalePrX(MyImage.Left) +
          R.Top := ScalePrY(MyImage.Top + ADTop); // ScalePrY(MyImage.Top)  +
          R.Right := R.Left + ScalePrX(MyImage.Width);
          // ScalePrX(MyFrame.Width);
          R.Bottom := R.Top + ScalePrY(MyImage.Height);
          // ScalePrY(MyFrame.Height);
          PrintBitmap(ACanvas, R, MyImage.Picture.Bitmap);
        end
        else
          // 20171226 Igor<<<
          if (AControl.Controls[I] is TFrame) and not AOnlyValue then
          // 20170212 Igor
          begin // search in the frame
            MyFrame := AControl.Controls[I] as TFrame;
            for J := 0 to MyFrame.ComponentCount - 1 do
            begin
              if MyFrame.Components[J] is TImage then
              begin // print the image
                MyImage := MyFrame.Components[J] as TImage;
                // PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
                R.Left := ScalePrX(MyFrame.Left + ADLeft);
                // ScalePrX(MyImage.Left) +
                R.Top := ScalePrY(MyFrame.Top + ADTop);
                // ScalePrY(MyImage.Top)  +
                R.Right := R.Left + ScalePrX(MyImage.Width); // 20171226 Igor
                R.Bottom := R.Top + ScalePrY(MyImage.Height); // 20171226 Igor
                PrintBitmap(ACanvas, R, MyImage.Picture.Bitmap);
              end;
            end;
          end;
    end; // i Controls
  End;

begin
  FName := UpperCase(Ltrim(RTrim(FName)));
  FNo := GetFormNo(FName);
  If FNo = 0 then
  begin
    If Printer.Printing then
      Printer.EndDoc;
    Exit;
  end;
  If AbortSw then
  Begin
    If Printer.Printing then
      Printer.EndDoc;
    Exit;
  end;

  if (Printer.Printing) and (FastPrint = False) then
  begin
    if MessageDlg('Printer temporarily busy. Try again?', mtInformation,
      [mbYes, mbNo], 0) = mrNo then
      Exit;
  end;
  WhiteBoxes := GetWhiteBoxesIndicator(FName);
  lCurrPageisLandscape := CurrentPageIsLanscape(AForm, IsLandscape(FName),
    MxFrmWidth, pStart, pEnd, RealHeight, RealWidth); // 20171228 Igor
  if ((Printer.Orientation = poLandscape) <>
    lCurrPageisLandscape { IsLandscape(FName) } ) then // 20170127 Igor
  begin
    if Printer.Printing then
      Printer.EndDoc;

    If lCurrPageisLandscape { IsLandscape(FName) } Then // 20170127 Igor
      Printer.Orientation := poLandscape
    else
      Printer.Orientation := poPortrait;
    Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo);
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  If not Printer.Printing then
  begin
    Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo);
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  if NeedNewPage then
    Printer.NewPage;

  If Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);

  hdc := Printer.Canvas.Handle;
  ACanvas := Printer.Canvas;

  dpiAdjustment := (GetWindowsFontSize(Application.MainForm.Handle) * 100)
    div DesignPixelsPerInch;
  // 20170212 Igor>>>
  CalcScaleXY(RealHeight, RealWidth); // 20170301 igor
  // PageX := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
  // PageY := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
  //
  // (*  //20170127 Igor
  // If Printer.Orientation = poLandscape then
  // begin
  // PageX:=Round(PageX * 2 / 3);
  // end;
  // *)
  // xExtraDPIAdjustment := 0;
  // yExtraDPIAdjustment := 60;
  //
  // if dpiAdjustment > 125 then //doesnt need adjust at 125 and possibly higher
  // xExtraDPIAdjustment := trunc( (-2.20 * dpiAdjustment) + 220.00);
  //
  // if dpiAdjustment >= 125 then
  // begin
  // yExtraDPIAdjustment := trunc((-8.70 * dpiAdjustment) + 930.00);
  // if Printer.Orientation = poLandscape then
  // begin
  // yExtraDPIAdjustment := yExtraDPIAdjustment * 3 div 4;
  // end
  // else
  // begin
  // if formPagebreakHeight < 1200 then
  // formPagebreakHeight := 1200; //try yo fix forms that are too short
  // end;
  // end;
  //
  // //20170127 Igor >>>
  // If Printer.Orientation = poLandscape then
  // ScaleX := (PageX * ScMult) div ( ( (MxFrmHeight + xExtraDPIAdjustment) * dpiAdjustment) div 100)
  // else
  // //20170127 Igor <<<
  // ScaleX := (PageX * ScMult) div ( ( (MxFrmWidth + xExtraDPIAdjustment) * dpiAdjustment ) div 100); //to get the decimals
  // ScaleY := (PageY * ScMult) div (((formPagebreakHeight + yExtraDPIAdjustment) * dpiAdjustment) div 100); //to get the decimals
  // 20170212 Igor<<<
  If LicenseLevel = llDemo then // demo
    PrintAtAngle('For Demo Purposes Only', ACanvas, 200,
      Printer.PageHeight div 2 - 100, 30, 100);

  // 20201216 CON
 // if isDraft then  PrintAtAngle('D R A F T', ACanvas, 200, Printer.PageHeight div 2 - 100, 80, 100);

  { Print Form Header }
  ACanvas.Font.size := 8;
  ACanvas.Brush.Color := clWhite;
  { remove switches later }

  { Print Header }
  If (OptRec.Prn_NameH) and (IsShowHdrIndicator(FName)) then
    ACanvas.TextOut(ScalePrX(10), ScalePrY(0), GetRetName(RetNo) + Space(5) +
      'Y/E ' + GetYearEnd(RetNo));
  If (OptRec.Prn_DateH) and (IsShowHdrIndicator(FName)) then
    ACanvas.TextOut(ScalePrX(270), ScalePrY(0),
      ' Date Printed: ' + DateToMonthDayYear(Date));
  If ShowFieldIdSw then
    ACanvas.TextOut(ScalePrX(400), ScalePrY(0), FName);

  If ((OptRec.Prn_NameH) or (OptRec.Prn_DateH) or (OptRec.Prn_SinH)) and
    IsShowHdrIndicator(FName) then
  begin
    ACanvas.MoveTo(ScalePrX(10), ScalePrY(12)); // 20170212 Igor
    ACanvas.LineTo(ScalePrX(600), ScalePrY(12)) // 20170212 Igor
  end;

  PrintControls(AForm, -pStart, 0); // 20171228 Igor

  If FastPrint then
    NeedNewPage := True
  else
    Printer.EndDoc;
End;

Procedure PausePrinting;
begin
  ShowMessage('Temporary pause..' + Chr(13) +
    'When ready, press any key to resume printing...');
  PauseSw := False;
end;

(* //20170212 Igor
  procedure DrawALine(x1,y1,w,h,PenWidth: Integer);
  begin
  with Printer.Canvas do
  begin
  Pen.Width := PenWidth;
  If (PenWidth >1) or (w=2) or (h=2) then pen.Width :=8;
  MoveTo(x1 * ScaleX div ScMult,y1 * ScaleY Div ScMult);
  If h <3 then LineTo((x1+w)* ScaleX Div ScMult, Y1* ScaleY Div ScMult)
  else LineTo(x1 * ScaleX div ScMult,(y1+h)*ScaleY Div ScMult);
  end;
  end;

  Function ScalePrBox(R: TRect):TRect;
  Begin
  R.Left := (R.Left * ScaleX) div ScMult;
  R.Top := (R.Top * ScaleY) div ScMult;
  R.Right := (R.Right * ScaleX) div ScMult;
  R.Bottom := (R.Bottom * ScaleY) div ScMult;
  Result := R;
  end;

  Function ScalePrX(X: Longint):LongInt;
  Begin
  Result := (X * ScaleX) div ScMult;
  end;

  Function ScalePrY(Y: Longint):LongInt;
  Begin
  Result := (Y * ScaleY) div ScMult;
  end;
*)
Procedure AfterReadComponentForPrint(AForm: TForm;
APrintFormSetting: TPrintFormSetting);
Var
  I: Integer;
  prnL, prnR: Real;
  iCode: Integer;
CONST
  pxl = 96; // 20160204 Igor
begin
  If IsFormAClientLetter(APrintFormSetting.FormName) then
  begin
    for I := 0 to AForm.ComponentCount - 1 do
    begin
      If AForm.Components[I] is TPanel then
        (AForm.Components[I] as TPanel).visible := False;

      If (AForm.Components[I] is TRichEdit) AND
        ((AForm.Components[I] as TRichEdit).align = alClient) then
      Begin
        with TRichEdit(AForm.Components[I]) do
        Begin
          align := alNone;

          SetBounds(ROUND(MainOptions.Prn_LMargin * pxl), Top,
            Width - ROUND(MainOptions.Prn_LMargin * pxl) -
            ROUND(MainOptions.Prn_RMargin * pxl), Height);
        end;
      end;
    end;
  end;
end;

Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String;
FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0;
ADLeft: Integer = 0; AOnlyValue: Boolean = False); // 20170212 Igor
Var
  FieldId: Integer;
  R: TRect;
  Astring, S: String;
  FormattedAmount: string;
  x, y: LongInt;
  PenWidth: Integer;
  AlignTopBottomVar, tempPos: Integer;
  MyEditHandle: THandle;
  PrintText, tempPrintText: String;
  nPrintTextHeight: Integer; // 20180126 Igor
  // 20180221 Igor >>>
  WrapTextRect: TRect;
  DrawStyle: Word;
  // 20180221 Igor <<<
Begin
  FieldId := GetFieldId(MyEditBox.Name);
  R.Left := MyEditBox.Left + ADLeft;
  R.Top := MyEditBox.Top + ADTop;
  R.Right := MyEditBox.Left + ADLeft + MyEditBox.Width;
  R.Bottom := MyEditBox.Top + ADTop + MyEditBox.Height;

  // set font
  ACanvas.Font.size := MyEditBox.Font.size;
  ACanvas.Font.Color := clBlack;
  ACanvas.Font.Style := MyEditBox.Font.Style;
  // needed to print edits with bolds,italics, underline etc...
  ACanvas.Brush.Style := bsClear;
  ACanvas.Font.Name := DefFontName;

  If PauseSw then
    PausePrinting;

  If ShowFieldIdSw then
  begin
    if MyEditBox.vtInputType = vtDollar then
      Astring := '[' + IntToStr(FieldId) + 'n]'
    else
      Astring := '[' + IntToStr(FieldId) + ']';

    If (MyEditBox.visible) or (ShowFieldIdSw = True) then
      ACanvas.TextOut(ScalePrX(R.Left), ScalePrY(R.Top + 2), Astring);
  end
  else
  begin
    if not AOnlyValue then // 20170212 Igor
    begin // 20170212 Igor
      // fill the editbox with color--------------------------------
      if MyEditBox.Color <> clWhite then
      begin
        ACanvas.Pen.Width := 0;
        ACanvas.Pen.Style := psClear;
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Brush.Color := RGB(236, 236, 236);
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right),
          ScalePrY(R.Bottom));
      end
      else
      begin
        ACanvas.Pen.Width := 0;
        ACanvas.Pen.Style := psClear;
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Brush.Color := clWhite;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right),
          ScalePrY(R.Bottom));
      end;

      if MyEditBox.vtShadedDec = True then
      begin
        ACanvas.Pen.Width := 0;
        ACanvas.Pen.Style := psClear;
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Brush.Color := RGB(236, 236, 236); // PrintShade;
        ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 1,
          ScalePrY(R.Top + 1), ScalePrX(R.Right), ScalePrY(R.Bottom));
        ACanvas.Brush.Style := bsClear;
      end;
    end; // 20170212 Igor

    if MyEditBox.vtInputType = vtDollar then
    begin
      PrintText := FormatAmount(MyEditBox.Text, MyEditBox.vtVertSeparator);
      if LeftStr(PrintText, 2) = '0 ' then
        PrintText := ' ' + midstr(PrintText, 3, 20);

      tempPrintText := StringReplace(PrintText, '  ', '.',
        [rfReplaceAll, rfIgnoreCase]);
      if Vl(tempPrintText) = 0 then
        PrintText := '';

      if LeftStr(PrintText, 1) = ' ' then
        PrintText := '0' + PrintText;
    end
    else if MyEditBox.vtInputType = vtSin then
      PrintText := reFormatSin(MyEditBox.Text)
    else
      PrintText := MyEditBox.Text;

    // 20180221 Igor >>>
    if MyEditBox.vtWordWrap then
    begin
      WrapTextRect.Left := 0;
      WrapTextRect.Top := 0;
      WrapTextRect.Right := ScalePrX(R.Right) - ScalePrX(R.Left);
      WrapTextRect.Bottom := 0;

      DrawText(ACanvas.Handle, PChar(PrintText), Length(PrintText),
        WrapTextRect, DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
      nPrintTextHeight := WrapTextRect.Bottom - WrapTextRect.Top;
      if nPrintTextHeight = 0 then
        nPrintTextHeight := ACanvas.TextHeight('0');

      if MyEditBox.vtLayout = vtTop then
      begin
        WrapTextRect.Top := ScalePrY(R.Top);
        WrapTextRect.Bottom := WrapTextRect.Top + nPrintTextHeight;
      end
      else if MyEditBox.vtLayout = vtMiddle then
      begin
        tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
        WrapTextRect.Top := ScalePrY(R.Top) + tempPos -
          (nPrintTextHeight div 2);
        WrapTextRect.Bottom := WrapTextRect.Top + nPrintTextHeight;
      end
      else if MyEditBox.vtLayout = vtBottom then
      begin
        WrapTextRect.Bottom := ScalePrY(R.Bottom);
        WrapTextRect.Top := WrapTextRect.Bottom - nPrintTextHeight;
      end;

      WrapTextRect.Left := ScalePrX(R.Left);
      WrapTextRect.Right := ScalePrX(R.Right);

      if MyEditBox.vtAlignment = taLeftJustify then
        DrawStyle := DT_LEFT or DT_WORDBREAK
      else if MyEditBox.vtAlignment = taRightJustify then
        DrawStyle := DT_RIGHT or DT_WORDBREAK
      else if MyEditBox.vtAlignment = taCenter then
        DrawStyle := DT_CENTER or DT_WORDBREAK;
      DrawText(ACanvas.Handle, PChar(PrintText), Length(PrintText),
        WrapTextRect, DrawStyle);
    end
    else
    begin
      // 20180126 Igor >>>
      nPrintTextHeight := ACanvas.TextHeight(PrintText);
      if nPrintTextHeight = 0 then
        nPrintTextHeight := ACanvas.TextHeight('0');

      if MyEditBox.vtLayout = vtTop then
      begin
        AlignTopBottomVar := ScalePrY(R.Top + 1);
      end
      else if MyEditBox.vtLayout = vtMiddle then
      begin
        tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
        AlignTopBottomVar := ScalePrY(R.Top) + tempPos -
          (nPrintTextHeight div 2);
      end
      else if MyEditBox.vtLayout = vtBottom then
        AlignTopBottomVar := ScalePrY(R.Bottom) - nPrintTextHeight;
      // 20180126 Igor <<<

      if MyEditBox.vtAlignment = taLeftJustify then
        ACanvas.TextOut(ScalePrX(R.Left) + 2, AlignTopBottomVar, PrintText)
      else if MyEditBox.vtAlignment = taRightJustify then
        ACanvas.TextOut(ScalePrX(R.Right) - ACanvas.TextWidth(PrintText) - 3,
          AlignTopBottomVar, PrintText)
      else if MyEditBox.vtAlignment = taCenter then
      begin
        tempPos := ((ScalePrX(R.Right) - ScalePrX(R.Left)) -
          ACanvas.TextWidth(PrintText)) div 2;
        ACanvas.TextOut(ScalePrX(R.Left) + tempPos, AlignTopBottomVar,
          PrintText)
      end;
    end;
    // 20180221 Igor <<<

    if not AOnlyValue then // 20170212 Igor
    begin
      ACanvas.Pen.Style := psSolid;
      if MyEditBox.vtInputType = vtDollar then
      begin
        ACanvas.TextOut(ScalePrX(R.Left), ScalePrY(AlignTopBottomVar),
          MyEditBox.vtPrefix);
        if MyEditBox.vtVertSeparator = True then
        begin
          ACanvas.Pen.Width := 1;
          if MyEditBox.vtBorderType = vtDoubleUnderLine then
            ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 1,
              ScalePrY(R.Top), ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2,
              ScalePrY(R.Bottom) - 3)
          else
            ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 1,
              ScalePrY(R.Top), ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2,
              ScalePrY(R.Bottom));
        end;
      end;

      if MyEditBox.vtBorderType = vtNoBorder then
      begin
        // no action
      end
      else if MyEditBox.vtBorderType = vtFull then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness;
        ACanvas.Pen.Color := clBlack;
        ACanvas.Brush.Style := bsClear;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right),
          ScalePrY(R.Bottom));
      end
      else if MyEditBox.vtBorderType = vtsides then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top),
          ScalePrX(R.Left) + 1, ScalePrY(R.Bottom));
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom),
          ScalePrX(R.Right), ScalePrY(R.Bottom) - 1);
        ACanvas.Rectangle(ScalePrX(R.Right) - 1, ScalePrY(R.Top),
          ScalePrX(R.Right), ScalePrY(R.Bottom));
      end
      else if MyEditBox.vtBorderType = vtUnderline then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) - 1,
          ScalePrX(R.Right), ScalePrY(R.Bottom));
      end
      else if MyEditBox.vtBorderType = vtDoubleUnderLine then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) - 1,
          ScalePrX(R.Right), ScalePrY(R.Bottom));
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) - 3,
          ScalePrX(R.Right), ScalePrY(R.Bottom) - 2);
      end
      else if MyEditBox.vtBorderType = vtTopBottomLine then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) - 1,
          ScalePrX(R.Right), ScalePrY(R.Bottom));
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top) + 1,
          ScalePrX(R.Right), ScalePrY(R.Top));
      end;
    end; // 20170212 Igor
  end; // else

  ACanvas.Font.Style := [];
end;

Procedure PrintImage(RetNo: Integer; AImage: TImage; hdc: THandle;
ACanvas: TCanvas);
Var
  R: TRect;
begin
  If PauseSw then
    PausePrinting;
  R.Left := ScalePrX(AImage.Left);
  R.Top := ScalePrY(AImage.Top);
  R.Right := ScalePrX(AImage.Left + AImage.Width);
  R.Bottom := ScalePrY(AImage.Top + AImage.Height);

  If UpperCase(AImage.Name) = 'LOGOIMAGE' then
  begin
    // AImage.Picture.Tranparent:=False;
    // AImage.Autosize:=True;
    // AImage.Stretch:=False;
    R.Left := ScalePrX(AImage.Left);
    R.Top := ScalePrY(AImage.Top);
    R.Right := AImage.Left + ScalePrX(AImage.Picture.Width);
    R.Bottom := AImage.Top + ScalePrY(AImage.Picture.Height);
    ACanvas.StretchDraw(R, AImage.Picture.Graphic);
    // ACanvas.Draw(R.Left,R.Top,AImage.Picture.Graphic);
  end
  else
    ACanvas.StretchDraw(R, AImage.Picture.Graphic);
end;

Procedure PrintBarcodeBitmap(RetNo: Integer; Canvas: TCanvas;
BarCodeImage1: TImage; BarCodeImage2: TImage);
var
  PixelsPerInch: TPoint;
  Ht, Wt: Real;
  d: Integer;
  BarCodeBmp: TBitMap;
  R: TRect;
begin
  {

    If FileExists(AppDir+'\'+'BarCode.BMP') then SysUtils.DeleteFile(AppDir+'\'+'BarCode.BMP');
    If FileExists(AppDir+'\'+'BarCode1.BMP') then SysUtils.DeleteFile(AppDir+'\'+'BarCode1.BMP');
    PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
    ht:=1.75 * PixelsPerInch.y;
    Wt:=3.5 * PixelsPerInch.x;

    maxBarDataLength := 877;
    if (PixelsPerInch.y < 360) or (PixelsPerInch.y < 360) then
    maxBarDataLength := 850;

    if not CreateBarCodeBmp(RetNo,AppDir+'\'+'BarCode.BMP',AppDir+'\'+'BarCode1.BMP',Ht,Wt,maxBarDataLength) then
    begin
    exit;
    end;

    for d:= 0 to 100 do
    begin
    if not FileExists(AppDir+'\'+'BarCode.BMP') then Delay(200);
    end;
    if not FileExists(AppDir+'\'+'BarCode.BMP') then
    begin
    ShowMessage('Barcode could not be created');
    end
    else
    begin
    BarCodeImage1.Picture.LoadFromFile(AppDir+'\'+'BarCode.BMP');
    BarCodeImage1.Transparent := True;
    BarCodeImage1.AutoSize := false; //important for proper size

    R.Left:=ScalePrX(BarCodeImage1.Left);
    R.Top:=ScalePrY(BarCodeImage1.Top);
    R.Right:=ScalePrX(BarCodeImage1.Left+BarCodeImage1.Width);
    R.Bottom:=ScalePrY(BarCodeImage1.Top+BarCodeImage1.Height);

    Canvas.StretchDraw(R,BarCodeImage1.Picture.Graphic);
    BarCodeImage1.Picture := nil;
    //second bar code if necessary
    If FileExists(AppDir+'\'+'BarCode1.BMP') then
    begin
    BarCodeImage2.Picture.LoadFromFile(AppDir+'\'+'BarCode1.BMP');
    BarCodeImage2.Transparent := True;
    BarCodeImage2.AutoSize := false; //important for proper size

    R.Left:=ScalePrX(BarCodeImage2.Left);
    R.Top:=ScalePrY(BarCodeImage2.Top);
    R.Right:=ScalePrX(BarCodeImage2.Left+BarCodeImage2.Width);
    R.Bottom:=ScalePrY(BarCodeImage2.Top+BarCodeImage2.Height);

    Canvas.StretchDraw(R,BarCodeImage2.Picture.Graphic);
    BarCodeImage2.Picture := nil;
    end;
    end;
  }
end;

Procedure PrintSFDBarcodeBitmap(RetNo: Integer; Canvas: TCanvas;
SFDBarCodeImage1: TImage; SFDBarCodeImage2: TImage);
var
  PixelsPerInch: TPoint;
  Ht, Wt: Real;
  I, d: Integer;
  BarCodeBmp: TBitMap;
  R: TRect;
begin
  {
    If FileExists(AppDir+'\'+'SFDBarCode.BMP') then SysUtils.DeleteFile(AppDir+'\'+'SFDBarCode.BMP');
    If FileExists(AppDir+'\'+'SFDBarCode1.BMP') then SysUtils.DeleteFile(AppDir+'\'+'SFDBarCode1.BMP');
    PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
    PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);

    ht:=1.75 * PixelsPerInch.y;
    Wt:=3.5 * PixelsPerInch.x;

    maxBarDataLength := 877;
    if (PixelsPerInch.y < 360) or (PixelsPerInch.y < 360) then
    maxBarDataLength := 850;

    if not CreateSFDBarCodeBmp(RetNo,AppDir+'\'+'SFDBarCode.BMP',AppDir+'\'+'SFDBarCode1.BMP',Ht,Wt,maxBarDataLength) then
    begin
    exit;
    end;

    for d:= 0 to 100 do
    begin
    if not FileExists(AppDir+'\'+'SFDBarCode.BMP') then Delay(200);
    end;

    if not FileExists(AppDir+'\'+'SFDBarCode.BMP') then
    begin
    ShowMessage('Barcode could not be created');
    end
    else
    begin
    SFDBarCodeImage1.Picture.LoadFromFile(AppDir+'\'+'SFDBarCode.BMP');
    SFDBarCodeImage1.Transparent := True;
    SFDBarCodeImage1.AutoSize := false; //important for proper size

    R.Left:=ScalePrX(SFDBarCodeImage1.Left);
    R.Top:=ScalePrY(SFDBarCodeImage1.Top);
    R.Right:=ScalePrX(SFDBarCodeImage1.Left+SFDBarCodeImage1.Width);
    R.Bottom:=ScalePrY(SFDBarCodeImage1.Top+SFDBarCodeImage1.Height);

    Canvas.StretchDraw(R,SFDBarCodeImage1.Picture.Graphic);
    SFDBarCodeImage1.Picture := nil;
    //second bar code if necessary
    If FileExists(AppDir+'\'+'SFDBarCode1.BMP') then
    begin
    SFDBarCodeImage2.Picture.LoadFromFile(AppDir+'\'+'SFDBarCode1.BMP');
    SFDBarCodeImage2.Transparent := True;
    SFDBarCodeImage2.AutoSize := false; //important for proper size

    R.Left:=ScalePrX(SFDBarCodeImage2.Left);
    R.Top:=ScalePrY(SFDBarCodeImage2.Top);
    R.Right:=ScalePrX(SFDBarCodeImage2.Left+SFDBarCodeImage2.Width);
    R.Bottom:=ScalePrY(SFDBarCodeImage2.Top+SFDBarCodeImage2.Height);

    Canvas.StretchDraw(R,SFDBarCodeImage2.Picture.Graphic);
    SFDBarCodeImage2.Picture := nil;
    end;
    end;
  }
end;

Procedure PrintRichEdit(RetNo: Integer; ARichEdit: TRichEdit; ACanvas: TCanvas);
// 1440 = 1 inch
// keeps track of each page where to start, end and rect of printing
Type
  TPageOffset = Record
    mStart: LongInt;
    mEnd: LongInt;
    rendRect: TRect;
  end;

var
  wPage, hPage, xPPI, yPPI, wTwips, hTwips: Integer;
  pageRect, rendRect: TRect;
  po: TPageOffset;
  fr: TFormatRange;
  lastOffset, currPage, pageCount: Integer;
  xOffset, yOffset: Integer;
  FPageOffsets: array of TPageOffset;
  TextLenEx: TGetTextLengthEx;
  firstPage: Boolean;

  // Mine
  XPos, YPos: Integer; // rich edit position
  ImageCanvas: TCanvas;

  dpiPercent, dpiAdjust: Integer;
begin
  // First, get the size of a printed page in printer device units
  wPage := GetDeviceCaps(ACanvas.Handle, PHYSICALWIDTH);
  hPage := GetDeviceCaps(ACanvas.Handle, PHYSICALHEIGHT);

  // adjust for dpi //20130315
  dpiPercent := (GetWindowsFontSize(MainForm.Handle) * 100)
    div DesignPixelsPerInch;
  if dpiPercent >= 150 then
    dpiAdjust := 122
  else if dpiPercent >= 125 then
    dpiAdjust := 121
  else if dpiPercent >= 104 then
    dpiAdjust := (4 * dpiPercent) - 377
  else
    dpiAdjust := 0;

  // Next, get the device units per inch for the printer
  xPPI := GetDeviceCaps(ACanvas.Handle, LOGPIXELSX) { - dpiAdjust };
  yPPI := GetDeviceCaps(ACanvas.Handle, LOGPIXELSY);
  // mine
  XPos := ScalePrX(ARichEdit.Left); // x whre to start the richedit
  YPos := ScalePrY(ARichEdit.Top); // y whre to top richedit
  ImageCanvas := ACanvas; // Printer.Canvas;
  // Convert the page size from device units to twips
  wTwips := { Trunc(WPage * 1440 div xPPI); // } MulDiv(wPage, 1440, xPPI);
  hTwips := { Trunc(HPage * 1440 div yPPI); // } MulDiv(hPage, 1440, yPPI);
  // Save the page size in twips
  with pageRect do
  begin
    Left := 0;
    Top := 0;
    Right := wTwips;
    Bottom := hTwips;
  end;
  // Next, calculate the size of the rendering rectangle in twips
  with rendRect do // tpoint
  begin
    // mine
    // Left:=Trunc(XPos * 1440 div xPPI)+(1440 div 2); //add half inch
    Left := Trunc(XPos * 1440 div xPPI) + 1440 * ROUND(MainOptions.Prn_LMargin);
    // add full inch
    Top := Trunc(YPos * 1440 div yPPI);
    // Right:=Trunc((XPos+(ScalePrX(ARichEdit.Width))) * 1440 div xPPI)-(1440 div 2); //less half inch
    Right := Trunc((XPos + (ScalePrX(ARichEdit.Width))) * 1440 div xPPI) - 1440
      * ROUND(MainOptions.Prn_RMargin); // less full inch
    Bottom := pageRect.Bottom - ROUND(1440 * 0.50);
    // ---
    // Rememeber - two inch margins are hardcoded, so the below code
    // reduces the width of the output by four inches
    // Top := 0;
    // Left := 0;
    // Right := pageRect.Right - (1440 * 4);
    // Bottom := pageRect.Bottom - (1440 * 4);
  end;
  // Define a single page and set starting offset to zero
  po.mStart := 0;
  // Define and initialize a TFormatRange structure. This structure is passed
  // to the TRichEdit with a request to format as much text as will fit on a
  // page starting with the chrg.cpMin offset and ending with the chrg.cpMax.
  // Initially, we tell the RichEdit control to start at the beginning
  // (cpMin = 0) and print as much as possible (cpMax = -1). We also tell it
  // to render to the printer
  with fr do
  begin
    hdc := ACanvas.Handle;
    hdcTarget := ACanvas.Handle;
    chrg.cpMin := po.mStart;
    chrg.cpMax := -1;
  end;
  // In order to recognize when the last page is rendered, we need to know how
  // much text is in the control.

  with TextLenEx do
  begin
    flags := GTL_DEFAULT;
    codepage := CP_ACP;
  end;
  lastOffset := SendMessage(ARichEdit.Handle, EM_GETTEXTLENGTHEX,
    wParam(@TextLenEx), 0);
  (* //cannot use RichEditVersion. Assume 2 or higher
    if RichEditVersion >= 2 then
    begin
    with TextLenEx do
    begin
    flags := GTL_DEFAULT;
    codepage := CP_ACP;
    end;
    lastOffset := SendMessage(ARichEdit.Handle, EM_GETTEXTLENGTHEX, wParam(@TextLenEx), 0)
    end
    else
    lastOffset := SendMessage(ARichEdit.Handle, WM_GETTEXTLENGTH, 0, 0);
  *)
  // As a precaution, clear the formatting buffer
  SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  // Printers frequently cannot print at the absolute top-left position on the
  // page. In other words, there is usually a minimum margin on each edge of the
  // page. When rendering to the printer, RichEdit controls adjust the top-left
  // corner of the rendering rectangle for the amount of the page that is
  // unprintable. Since we are printing with two-inch margins, we are presumably
  // already within the printable portion of the physical page.
  SaveDC(fr.hdc);
  SetMapMode(fr.hdc, MM_TEXT);

  { me
    xOffset := GetDeviceCaps(ACanvas.Handle, PHYSICALOFFSETX);
    yOffset := GetDeviceCaps(ACanvas.Handle, PHYSICALOFFSETY);
    xOffset := MulDiv(1440 + 1440, xPPI, 1440);
    yOffset := MulDiv(1440 + 1440, yPPI, 1440);
    SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);
  }
  // build a table of page entries, one entry for each page that would be printed.
  while ((fr.chrg.cpMin <> -1) and (fr.chrg.cpMin < lastOffset)) do
  begin
    If High(FPageOffsets) <> -1 then // not first page  MINE
      rendRect.Top := 0; // causes second page to start from top
    fr.rc := rendRect;
    fr.rcPage := pageRect;
    po.mStart := fr.chrg.cpMin;
    fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0,
      LongInt(@fr));
    po.mEnd := fr.chrg.cpMin - 1;
    po.rendRect := fr.rc;
    if High(FPageOffsets) = -1 then
      SetLength(FPageOffsets, 1)
    else
      SetLength(FPageOffsets, Length(FPageOffsets) + 1); // dynamic array
    FPageOffsets[High(FPageOffsets)] := po; // po is the page offset record
  end;

  pageCount := Length(FPageOffsets);
  SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  // ME
  // RestoreDC(fr.hdc, - 1);
  // Now, we are almost ready to actually print.
  // Printer.BeginDoc;

  fr.hdc := ACanvas.Handle;
  fr.hdcTarget := ACanvas.Handle;
  // ME
  // SaveDC(fr.hdc);
  // SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);

  // here we print
  firstPage := True;
  currPage := 0;
  while (currPage < pageCount) do
  begin
    If firstPage then
      firstPage := False
    else
      Printer.NewPage;
    // SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);  //me
    fr.rc := FPageOffsets[currPage].rendRect;
    fr.rcPage := pageRect;
    fr.chrg.cpMin := FPageOffsets[currPage].mStart;
    fr.chrg.cpMax := FPageOffsets[currPage].mEnd;
    fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 1,
      LongInt(@fr));
    Inc(currPage);
  end;

  // At this point, we have finished rendering the contents of the RichEdit
  // control. Now we restore the printer's HDC settings and tell Windows that
  // we are through printing this document
  // RestoreDC(fr.hdc, - 1);  //me
  // Printer.EndDoc;
  // Finally, we clear the RichEdit control's formatting buffer and delete
  // the saved page table information
  // fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  Finalize(FPageOffsets); // de-allocates memory
end;

(*
  const
  RichEditVersion: TRichEditVersion;
  Description
  RichEditVersion indicates which version of rich edit control DLL is installed.
  The appearance and behavior of rich edit control varies depending on which
  version of rich edit library (riched32.dll or riched20.dll) is installed.
  Use RichEditVersion variable to determine which version is installed.
  Windows NT
  Microsoft® Windows NT® version 4.0 ships rich edit libraries 1.0 and 2.0.
  Windows NT version 5.0 ships rich edit library 3.0 with Rich Edit 1.0 emulation.
  Windows 95
  Microsoft® Windows® 95 ships only Riched32.dll. However, Riched20.dll is
  compatible with Windows 95 and may be present if an application that
  uses Rich Edit 2.0 has been installed on the system.
  Windows 98
  Microsoft® Windows® 98 ships Riched32.dll and Riched20.dll.
  This Riched20.dll is the Rich Edit 2.0 version.
*)

procedure DrawShape(TopLeft, BottomRight: TPoint; PenWidth: Integer;
ACanvas: TCanvas);
begin
  with ACanvas do
  begin
    { Pen.Mode := AMode; }
    Pen.Width := PenWidth;
    case DrawingTool of
      dtLine:
        begin
          MoveTo(TopLeft.x, TopLeft.y);
          LineTo(BottomRight.x, BottomRight.y);
        end;
      dtRectangle:
        Rectangle(TopLeft.x, TopLeft.y, BottomRight.x, BottomRight.y);
      dtEllipse:
        Ellipse(TopLeft.x, TopLeft.y, BottomRight.x, BottomRight.y);
      dtRoundRect:
        RoundRect(TopLeft.x, TopLeft.y, BottomRight.x, BottomRight.y,
          (TopLeft.x - BottomRight.x) div 2, (TopLeft.y - BottomRight.y) div 2);
    end;
  end;
  ACanvas.Pen.Width := 1; { back to Default }
end;

procedure DrawTriangle(MyVtShape: TvtShape; ACanvas: TCanvas; R: TRect);
var
  poly: array [0 .. 2] of TPoint;
  rpoly: array [0 .. 2] of TPoint;
  I: Integer;
  w2, w3, w4, w8, w16, h2, h3, h4, h8, h16, xw, yh: Integer;
begin
  w2 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 2;
  w3 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 3;
  w4 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 4;
  w8 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 8;
  w16 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 16;
  h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
  h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 3;
  h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 4;
  h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 8;
  h16 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 16;
  xw := ScalePrX(R.Left) + (ScalePrX(R.Right) - ScalePrX(R.Left)) - 1;
  yh := ScalePrY(R.Top) + (ScalePrY(R.Bottom) - ScalePrY(R.Top)) - 1;

  case MyVtShape.Shape of
    vtTriangleRight:
      begin
        poly[0] := point(ScalePrX(R.Left), ScalePrY(R.Top));
        poly[1] := point(xw, ScalePrY(R.Top) + h2);
        poly[2] := point(ScalePrX(R.Left), yh);
      end;
    vtTriangleUp:
      begin
        poly[0] := point(ScalePrX(R.Left) + w2, ScalePrY(R.Top));
        poly[1] := point(xw, yh);
        poly[2] := point(ScalePrX(R.Left), yh);
      end;
    vtTriangleLeft:
      begin
        poly[0] := point(xw, ScalePrY(R.Top));
        poly[1] := point(xw, yh);
        poly[2] := point(ScalePrX(R.Left), ScalePrY(R.Top) + h2);
      end;
    vtTriangleDown:
      begin
        poly[0] := point(ScalePrX(R.Left), ScalePrY(R.Top));
        poly[1] := point(xw, ScalePrY(R.Top));
        poly[2] := point(ScalePrX(R.Left) + w2, yh);
      end;
  end;
  for I := 0 to 2 do
  begin
    rpoly[I].x := R.Left + poly[I].x;
    rpoly[I].y := R.Top + poly[I].y;
  end;
  ACanvas.polygon(slice(poly, 3));
end;

procedure DrawArrow(MyVtShape: TvtShape; ACanvas: TCanvas; R: TRect);
var
  poly: array [0 .. 6] of TPoint;
  rpoly: array [0 .. 6] of TPoint;
  I: Integer;
  w, w2, w3, w4, w8, w16, h, h2, h3, h4, h8, h16, xw, yh: Integer;
begin
  w := (ScalePrX(R.Right) - ScalePrX(R.Left));
  w2 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 2;
  w3 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 3;
  w4 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 4;
  w8 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 8;
  w16 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 16;
  h := (ScalePrY(R.Bottom) - ScalePrY(R.Top));
  h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
  h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 3;
  h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 4;
  h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 8;
  h16 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 16;
  xw := ScalePrX(R.Left) + (ScalePrX(R.Right) - ScalePrX(R.Left)) - 1;
  yh := ScalePrY(R.Top) + (ScalePrY(R.Bottom) - ScalePrY(R.Top)) - 1;

  case MyVtShape.Shape of
    vtArrowRight:
      begin
        poly[0] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 2) -
          (h div 16));
        poly[1] := point(ScalePrX(R.Left) + w - 1 - (w div 4),
          ScalePrY(R.Top) + (h div 2) - (h div 16));
        poly[2] := point(ScalePrX(R.Left) + w - 1 - (w div 4), ScalePrY(R.Top));
        poly[3] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 2));
        poly[4] := point(ScalePrX(R.Left) + w - 1 - (w div 4),
          ScalePrY(R.Top) + h - 1);
        poly[5] := point(ScalePrX(R.Left) + w - 1 - (w div 4),
          ScalePrY(R.Top) + (h div 2) + (h div 16));
        poly[6] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 2) +
          (h div 16));
      end;
    vtArrowLeft:
      begin
        poly[0] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 2) -
          (h div 16));
        poly[1] := point(ScalePrX(R.Left) + (w div 4),
          ScalePrY(R.Top) + (h div 2) - (h div 16));
        poly[2] := point(ScalePrX(R.Left) + (w div 4), ScalePrY(R.Top));
        poly[3] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 2));
        poly[4] := point(ScalePrX(R.Left) + (w div 4), ScalePrY(R.Top) + h - 1);
        poly[5] := point(ScalePrX(R.Left) + (w div 4),
          ScalePrY(R.Top) + (h div 2) + (h div 16));
        poly[6] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 2) +
          (h div 16));
      end;
    vtArrowUp:
      begin
        poly[0] := point(ScalePrX(R.Left) + (w div 2) - (w div 16),
          ScalePrY(R.Top) + h - 1);
        poly[1] := point(ScalePrX(R.Left) + (w div 2) - (w div 16),
          ScalePrY(R.Top) + (h div 4));
        poly[2] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 4));
        poly[3] := point(ScalePrX(R.Left) + (w div 2), ScalePrY(R.Top));
        poly[4] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 4));
        poly[5] := point(ScalePrX(R.Left) + (w div 2) + (w div 16),
          ScalePrY(R.Top) + (h div 4));
        poly[6] := point(ScalePrX(R.Left) + (w div 2) + (w div 16),
          ScalePrY(R.Top) + h - 1);
      end;
    vtArrowDown:
      begin
        poly[0] := point(ScalePrX(R.Left) + (w div 2) - (w div 16),
          ScalePrY(R.Top));
        poly[1] := point(ScalePrX(R.Left) + (w div 2) - (w div 16),
          ScalePrY(R.Top) + h - 1 - (h div 4));
        poly[2] := point(ScalePrX(R.Left), ScalePrY(R.Top) + h - 1 - (h div 4));
        poly[3] := point(ScalePrX(R.Left) + (w div 2), ScalePrY(R.Top) + h - 1);
        poly[4] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + h - 1 -
          (h div 4));
        poly[5] := point(ScalePrX(R.Left) + (w div 2) + (w div 16),
          ScalePrY(R.Top) + h - 1 - (h div 4));
        poly[6] := point(ScalePrX(R.Left) + (w div 2) + (w div 16),
          ScalePrY(R.Top));
      end;
  end;
  for I := 0 to 6 do
  begin
    rpoly[I].x := R.Left + poly[I].x;
    rpoly[I].y := R.Right + poly[I].y;
  end;
  ACanvas.polygon(poly);
end;

procedure DrawOthers(MyVtShape: TvtShape; ACanvas: TCanvas; R: TRect);
var
  poly: array [0 .. 15] of TPoint;
  rpoly: array [0 .. 15] of TPoint;
  I: Integer;
  StartPos, EndPos: Integer;
  w, w2, w3, w4, w8, w16, h, h2, h3, h4, h8, h16, x, y, xw, yh: Integer;
begin
  w := (ScalePrX(R.Right) - ScalePrX(R.Left));
  w2 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 2;
  w3 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 3;
  w4 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 4;
  w8 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 8;
  w16 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 16;
  h := (ScalePrY(R.Bottom) - ScalePrY(R.Top));
  h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
  h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 3;
  h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 4;
  h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 8;
  h16 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 16;

  x := ScalePrX(R.Left);
  y := ScalePrY(R.Top);
  xw := ScalePrX(R.Left) + (ScalePrX(R.Right) - ScalePrX(R.Left)) - 1;
  yh := ScalePrY(R.Top) + (ScalePrY(R.Bottom) - ScalePrY(R.Top)) - 1;

  StartPos := 0;
  EndPos := 0;
  case MyVtShape.Shape of
    vtDiamond:
      begin
        poly[0] := point(x + (w div 2), y);
        poly[1] := point(x + w - 1, y + (h div 2));
        poly[2] := point(x + (w div 2), y + h - 1);
        poly[3] := point(x, y + (h div 2));
        EndPos := 3;
      end;
    vtOctagon:
      begin
        poly[0] := point(x + (w div 3), y);
        poly[1] := point(x + w - 1 - (w div 3), y);
        poly[2] := point(x + w - 1, y + (h div 3));
        poly[3] := point(x + w - 1, y + h - 1 - (h div 3));
        poly[4] := point(x + w - 1 - (w div 3), y + h - 1);
        poly[5] := point(x + (w div 3), y + h - 1);
        poly[6] := point(x, y + h - 1 - (h div 3));
        poly[7] := point(x, y + (h div 3));
        EndPos := 7;
      end;
    vtHexagon:
      begin
        poly[0] := point(x + w2, y);
        poly[1] := point(xw, y + h4);
        poly[2] := point(xw, yh - h4);
        poly[3] := point(x + w2, yh);
        poly[4] := point(x, yh - h4);
        poly[5] := point(x, y + h4);
        EndPos := 5;
      end;
    vtHexagonFlat:
      begin
        poly[0] := point(x + w4, y);
        poly[1] := point(xw - w4, y);
        poly[2] := point(xw, y + h2);
        poly[3] := point(xw - w4, yh);
        poly[4] := point(x + w4, yh);
        poly[5] := point(x, y + h2);
        EndPos := 5;
      end;
    vtUBarUp:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x, yh);
        poly[2] := point(xw, yh);
        poly[3] := point(xw, y);
        poly[4] := point(xw - w4, y);
        poly[5] := point(xw - w4, yh - h4);
        poly[6] := point(x + w4, yh - h4);
        poly[7] := point(x + w4, y);
        EndPos := 7;
      end;
    vtUBarLeft:
      begin
        poly[0] := point(x, y);
        poly[1] := point(xw, y);
        poly[2] := point(xw, yh);
        poly[3] := point(x, yh);
        poly[4] := point(x, yh - h4);
        poly[5] := point(xw - w4, yh - h4);
        poly[6] := point(xw - w4, y + h4);
        poly[7] := point(x, y + h4);
        EndPos := 7;
      end;
    vtUBarDown:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x, yh);
        poly[2] := point(x + w4, yh);
        poly[3] := point(x + w4, y + h4);
        poly[4] := point(xw - w4, y + h4);
        poly[5] := point(xw - w4, yh);
        poly[6] := point(xw, yh);
        poly[7] := point(xw, y);
        EndPos := 7;
      end;
    vtUBarRight:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x, yh);
        poly[2] := point(xw, yh);
        poly[3] := point(xw, yh - h4);
        poly[4] := point(x + w4, yh - h4);
        poly[5] := point(x + w4, y + h4);
        poly[6] := point(xw, y + h4);
        poly[7] := point(xw, y);
        EndPos := 7;
      end;
    vtWaggle:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x + w4, y + h8);
        poly[2] := point(x + w2, y);
        poly[3] := point(xw - w4, y + h8);
        poly[4] := point(xw, y);
        poly[5] := point(xw - w8, y + h4);
        poly[6] := point(xw, y + h2);
        poly[7] := point(xw - w8, yh - h4);
        poly[8] := point(xw, yh);
        poly[9] := point(xw - w4, yh - h8);
        poly[10] := point(x + w2, yh);
        poly[11] := point(x + w4, yh - h8);
        poly[12] := point(x, yh);
        poly[13] := point(x + w8, yh - h4);
        poly[14] := point(x, y + h2);
        poly[15] := point(x + w8, y + h4);
        EndPos := 15;
      end;
    vtCloudLeft:
      begin
        ACanvas.Ellipse(x, y, xw - w4, yh - h4);
        ACanvas.Ellipse(x + w4, y + h4, xw, yh);
        EndPos := 0;
      end;
    vtCloudRight:
      begin
        ACanvas.Ellipse(x + w4, y, xw, yh - h4);
        ACanvas.Ellipse(x, y + h4, xw - w4, yh);
        EndPos := 0;
      end;
  end;

  for I := StartPos to EndPos do
  begin
    rpoly[I].x := R.Left + poly[I].x;
    rpoly[I].y := R.Top + poly[I].y;
  end;
  ACanvas.polygon(slice(poly, EndPos + 1));
end;

Function adjustForCertif(Text: String; FName: String; FieldId: Integer): String;
begin
  Result := Text;

  If (FName = 'T3') then
  begin
    if (FieldId = 14) or (FieldId = 17) then // remove dates
      Result := '';
  end;

  If FName = 'S5' then
  begin
    if FieldId = 46 then
      Result := '250,000  00';
    if FieldId = 63 then
      Result := '375,000  00';
  end;

  // 0.00 to "tax on income base" and political "base credit"
  If (FName = 'S11') and (FieldId = 17) then
    Result := '0.00';
  If (FName = 'T3AB') and (FieldId = 107) then
    Result := '0.00';
  If (FName = 'T3BC') then
  begin
    if (FieldId = 17) or (FieldId = 107) then
      Result := '0.00';
  end;
  If (FName = 'T3MB') then
  begin
    if (FieldId = 17) or (FieldId = 107) then
      Result := '0.00';
  end;
  If (FName = 'T3NB') and (FieldId = 17) then
    Result := '0.00';
  If (FName = 'T3NL') and (FieldId = 17) then
    Result := '0.00';
  If (FName = 'T3NS') and (FieldId = 17) then
    Result := '0.00';
  If (FName = 'T3NT') then
  begin
    if (FieldId = 17) or (FieldId = 107) then
      Result := '0.00';
  end;
  If (FName = 'T3NU') then
  begin
    if (FieldId = 17) or (FieldId = 107) then
      Result := '0.00';
  end;
  If (FName = 'T3ON') and (FieldId = 17) then
    Result := '0.00';
  If (FName = 'T3PE') then
  begin
    if (FieldId = 17) or (FieldId = 107) then
      Result := '0.00';
  end;
  If (FName = 'T3SK') then
  begin
    if (FieldId = 17) or (FieldId = 107) then
      Result := '0.00';
  end;
  If (FName = 'T3YT') then
  begin
    if (FieldId = 17) or (FieldId = 107) then
      Result := '0.00';
  end;
end;

Procedure PrintDynamicForm(RetNo: Integer; FName: String); // 20160901 Igor
type
  TFooterRecord = record
    vtLbl: TvtLabel;
    deltaH: Integer;
  end;
Var
  h, I, J, k, p, CtrlIndex, T1CFNo: Integer;
  ACanvas: TCanvas;
  DfmFileName: String;
  ALabel: TvtLabel;
  AvtEditBox: TvtEdit;
  ATag: Integer;
  FieldId: Integer;
  AShape: TvtShape;
  // PageX, PageY : LongInt; //20170212 Igor
  hdc: THandle;
  S: String;
  VerticalAdvance: Integer;
  CurrentTop: LongInt;
  FNo: Integer;
  // MyChild:TMyChild;
  F: TForm;
  MyScrollBox: TvtScrollBox;

  formNumPages, tmp, lastPageBreakPos, LastComponentDifferencial,
    PageBreaksToAdd: Integer;
  PagebreakPos: array of Integer;
  PFHeight, OldTop: Integer; // 20160404 Igor
  lblArr: Array of TFooterRecord;
  NeedBreak: Boolean;
  R: TRect; // 20160608 Igor
  PixelsPerInch: TPoint; // 20160608 Igor
  MyFrame: TFrame; // 20160608 Igor
  MyImage: TImage; // 20160608 Igor
begin
  FNo := GetFormNo(FName);
  VerticalAdvance := 14;
  // MyStrToInt(InputBox('Vertical line height','Enter', '14'));
  CurrentTop := 20;

  // 20160829 Igor >>>
  // if FastPrint = False then
  // Printer.BeginDoc;
  if ((Printer.Orientation = poLandscape) <> IsLandscape(FName)) then
  begin
    if Printer.Printing then
      Printer.EndDoc;

    If IsLandscape(FName) Then
      Printer.Orientation := poLandscape
    else
      Printer.Orientation := poPortrait;
    Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo);
    // 20160905 Igor
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  If not Printer.Printing then
  begin
    Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo);
    // 20160905 Igor
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  if NeedNewPage then
    Printer.NewPage;
  // 20170212 Igor>>>
  CalcScaleXY;
  // PageX  := Printer.PageWidth;
  // PageY  := Printer.PageHeight;
  // ScaleX := (PageX * ScMult) div 614; {to get the decimals}
  // ScaleY := (PageY * ScMult) div MxFrmHeight; {FrmHeight;}
  // 20170212 Igor<<<
  hdc := Printer.Canvas.Handle;
  ACanvas := Printer.Canvas;
  ACanvas.Brush.Style := bsClear; // 20111222
  ACanvas.Font.Color := clBlack; // 20111222

  DfmFileName := GetDFMFileName(FName);
  If not FileExists(DfmFileName) then
  Begin
    ShowMessage('DFM File problem =' + DfmFileName);
    Exit;
  end;

  F := TForm.Create(Application); // 20160407 Igor
  F.visible := False; // 20160407 Igor
  MyScrollBox := TFormT4T5_2026.Create(F, RetNo, FNo);
  // 20150817 //20160407 Igor
  ReadComponentResFile(DfmFileName, MyScrollBox);
  // MyScrollBox.Rescale(100, DfmFileName); //???
  MyScrollBox.AfterOpenForm(vtdPrint); // 20160407 Igor


  // 20160707

  // 20160619
  // 20160119
  If FName = 'T1135' then // original Efiled
  begin
    If (FetchElm(RetNo, FName, 39) > '') and (FetchElm(RetNo, FName, 22) = '')
    // amended
    then // thre is Efile confirmaqtion
    begin
      PrintAtAngle('DUPLICATE', ACanvas, 180,
        Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 50, 240);
      // 20141229
      PrintAtAngle('DO NOT SEND BY MAIL', ACanvas, 300,
        Trunc(Printer.PageHeight - (Printer.PageHeight / 3) +
        (Printer.PageHeight / 9) - 200), 50, 240); // 20160707
    end;
  end;

  // 20160119
  If FName = 'T1135' then // amended
  begin
    If (FetchElm(RetNo, FName, 39) > '') and (FetchElm(RetNo, FName, 22) > '')
    // amended
      and (FetchElm(RetNo, FName, 34) = '') // original after amend
    then // there is Efile confirmaqtion
    begin
      PrintAtAngle('AMENDED ON ' + FormatDateTime('yyyy-mm-dd', Date), ACanvas,
        180, Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 50, 240);
      // 20141229
    end;
  end;

  // 20160707  Efiled after amended?

  If FName = 'T1135' then // amended
  begin
    If (FetchElm(RetNo, FName, 39) > '') and (FetchElm(RetNo, FName, 22) > '')
    // amended
      and (FetchElm(RetNo, FName, 34) > '') // retransmission
    then // there is Efile confirmaqtion
    begin
      PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,
        Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 25, 240);
      // 20141229  //font smaller 20160707
      PrintAtAngle('SENT ON ' + FormatDateTime('yyyy-mm-dd', Date) +
        '-DO NOT SEND BY MAIL', ACanvas, 300,
        Trunc(Printer.PageHeight - (Printer.PageHeight / 3) +
        (Printer.PageHeight / 9) - 200), 25, 240); // 20141229
    end;
  end;

  lastPageBreakPos := 0;
  // 20160404 Igor >>>
  PFHeight := 0;
  OldTop := MaxInt;
  for I := 0 to MyScrollBox.ControlCount - 1 do
  begin
    if (MyScrollBox.Controls[I] is TvtLabel) and
      ((MyScrollBox.Controls[I] as TvtLabel).PrintEveryPage) then
    Begin
      SetLength(lblArr, Length(lblArr) + 1);
      lblArr[Length(lblArr) - 1].vtLbl := (MyScrollBox.Controls[I] as TvtLabel);
      if PFHeight < ((MyScrollBox.Controls[I] as TvtLabel).Top +
        (MyScrollBox.Controls[I] as TvtLabel).Height) then
        PFHeight := ((MyScrollBox.Controls[I] as TvtLabel).Top +
          (MyScrollBox.Controls[I] as TvtLabel).Height);
      if OldTop > (MyScrollBox.Controls[I] as TvtLabel).Top then
        OldTop := (MyScrollBox.Controls[I] as TvtLabel).Top;
    End;
  end;
  for I := 0 to Length(lblArr) - 1 do
  Begin
    lblArr[I].deltaH := lblArr[I].vtLbl.Top - OldTop;
  End;
  if (PFHeight <> 0) or (OldTop <> MaxInt) then
    PFHeight := PFHeight - OldTop;
  // 20160404 Igor <<<

  // find last page break
  for I := 0 to MyScrollBox.ControlCount - 1 do
  begin
    // 20160905 igor >>>
    If MyScrollBox.Controls[I] is TRichEdit then
      IncRichEditFontSize(TRichEdit(MyScrollBox.Controls[I]),
        2 * MainOptions.Prn_FontIncr, IsFormAClientLetter(FName));
    // 20170204 Igor
    // 20160905 igor <<<
    If (MyScrollBox.Controls[I] is TvtShape) and
      ((MyScrollBox.Controls[I] as TvtShape).vtPageBreak) then
    begin
      MyScrollBox.Controls[I].Top := MyScrollBox.Controls[I].Top - PFHeight;
      // 20160404 Igor

      if (MyScrollBox.Controls[I].Top + MyScrollBox.Controls[I].Height) > lastPageBreakPos
      then
        lastPageBreakPos := MyScrollBox.Controls[I].Top + MyScrollBox.Controls
          [I].Height;
    end;
  end;

  // 20160404 Igor <<<<
  // find if component after last page break and how far past
  LastComponentDifferencial := -1;
  for I := 0 to MyScrollBox.ControlCount - 1 do
  begin
    if MyScrollBox.Controls[I].Top > lastPageBreakPos then
    begin
      LastComponentDifferencial := MyScrollBox.Controls[I].Top -
        lastPageBreakPos;
    end;
  end;

  PageBreaksToAdd := 0;
  if not LastComponentDifferencial < 0 then
    PageBreaksToAdd := (LastComponentDifferencial div (1000 - PFHeight)) + 1;
  // 20160404 Igor

  for I := 1 to PageBreaksToAdd do
  begin
    AShape := TvtShape.Create(MyScrollBox);
    AShape.Parent := MyScrollBox;
    AShape.vtPageBreak := True;
    AShape.Top := lastPageBreakPos + ((1000 - PFHeight) * I); // 20160404 Igor
  end;

  SetLength(PagebreakPos, 1);
  formNumPages := 0;
  PagebreakPos[0] := 0;

  // determine if multiple pages, load PagebreakPos array
  for I := 0 to MyScrollBox.ControlCount - 1 do
  begin
    If MyScrollBox.Controls[I] is TvtShape then
    begin
      if (MyScrollBox.Controls[I] as TvtShape).vtPageBreak then
      begin
        SetLength(PagebreakPos, Length(PagebreakPos) + 1);
        PagebreakPos[formNumPages] := (MyScrollBox.Controls[I] as TvtShape).Top;
        Inc(formNumPages, 1)
      end;
    end;
  end; // i components

  // sort PagebreakPos array
  for I := high(PagebreakPos) - 1 Downto low(PagebreakPos) do
  begin
    for J := I to high(PagebreakPos) - 1 do
    begin
      if PagebreakPos[J] > PagebreakPos[J + 1] then
      begin
        tmp := PagebreakPos[J];
        PagebreakPos[J] := PagebreakPos[J + 1];
        PagebreakPos[J + 1] := tmp;
      end;
    end;
  end;

  for I := Length(PagebreakPos) - 1 downto 1 do
  begin
    if ((PagebreakPos[I] - PagebreakPos[I - 1]) > (100 - PFHeight)) then
    begin
      OldTop := PagebreakPos[I - 1] + (1000 - PFHeight);
      while OldTop < PagebreakPos[I] do
      Begin
        NeedBreak := False;
        for J := 0 to MyScrollBox.ControlCount - 1 do
        Begin
          if ((MyScrollBox.Controls[J].Top) >= OldTop) and
            ((MyScrollBox.Controls[J].Top) < PagebreakPos[I]) and
            (MyScrollBox.Controls[J].visible) then
          Begin
            if ((MyScrollBox.Controls[I] is TvtEdit) AND
              (MyScrollBox.Controls[I] as TvtEdit).vtIsPrintable) or
              ((MyScrollBox.Controls[I] is TvtLabel) AND
              (MyScrollBox.Controls[I] as TvtLabel).vtIsPrintable) or
              ((MyScrollBox.Controls[I] is TvtShape) AND
              (MyScrollBox.Controls[I] as TvtShape).vtIsPrintable) then
            Begin
              NeedBreak := True;
              break;
            End;
          End;
        End;
        if NeedBreak then
        Begin
          SetLength(PagebreakPos, Length(PagebreakPos) + 1);
          PagebreakPos[Length(PagebreakPos) - 1] := OldTop;
          OldTop := OldTop + (1000 - PFHeight);
        End
        else
          break;
      end;
    end;
  end;

  for I := high(PagebreakPos) - 1 Downto low(PagebreakPos) do
  begin
    for J := I to high(PagebreakPos) - 1 do
    begin
      if PagebreakPos[J] > PagebreakPos[J + 1] then
      begin
        tmp := PagebreakPos[J];
        PagebreakPos[J] := PagebreakPos[J + 1];
        PagebreakPos[J + 1] := tmp;
      end;
    end;
  end;

  for p := 0 to high(PagebreakPos) - 1 do
  begin

    (* Possible pagebreak problem:
      Only recognized components are printed!
    *)
    for I := 0 to MyScrollBox.ControlCount - 1 do
    begin
      if (MyScrollBox.Controls[I] is TvtEdit) AND
        (MyScrollBox.Controls[I] as TvtEdit).vtIsPrintable then
      begin
        if ((MyScrollBox.Controls[I].Top) >= PagebreakPos[p]) and
        // 20160404 igor
          ((MyScrollBox.Controls[I].Top) < PagebreakPos[p + 1]) // 20160404 igor
        then
        begin
          MyScrollBox.Controls[I].Top := MyScrollBox.Controls[I].Top -
            PagebreakPos[p]; // 20160404 Igor
          PrintEditBox(RetNo, MyScrollBox.Controls[I] as TvtEdit, FName, FNo,
            hdc, ACanvas);
          // PrintEditBox(RetNo,AvtEditBox,FName,FNo,hdc,ACanvas);
        end;
      end; // tvedit
      if (MyScrollBox.Controls[I] is TvtLabel) AND
        (MyScrollBox.Controls[I] as TvtLabel).vtIsPrintable then
      begin
        if not(MyScrollBox.Controls[I] as TvtLabel).PrintEveryPage then
        Begin
          if ((MyScrollBox.Controls[I].Top) >= PagebreakPos[p]) and
          // 20160404 Igor
            ((MyScrollBox.Controls[I].Top) < PagebreakPos[p + 1])
          // 20160404 Igor
          then
          begin
            MyScrollBox.Controls[I].Top := MyScrollBox.Controls[I].Top -
              PagebreakPos[p]; // 20160404 Igor
            PrintLabel(MyScrollBox.Controls[I] as TvtLabel, ACanvas);
          end;
        End;
      end;
      // 20160905 Igor >>>
      if MyScrollBox.Controls[I] is TRichEdit then // RichEdit
      begin
        if Assigned((MyScrollBox.Controls[I] as TRichEdit).Parent) then
        begin
          if ((MyScrollBox.Controls[I].Top) >= PagebreakPos[p]) and
            ((MyScrollBox.Controls[I].Top) < PagebreakPos[p + 1]) then
          begin
            MyScrollBox.Controls[I].Top := MyScrollBox.Controls[I].Top -
              PagebreakPos[p];
            PrintRichEdit(RetNo,
              (MyScrollBox.Controls[I] as TRichEdit), ACanvas);
          end;
        end;
      end; // richedit
      // 20160905 Igor <<<
      if (MyScrollBox.Controls[I] is TvtShape) AND
        (MyScrollBox.Controls[I] as TvtShape).vtIsPrintable then
      begin
        if ((MyScrollBox.Controls[I].Top) >= PagebreakPos[p]) and
        // 20160404 Igor
          ((MyScrollBox.Controls[I].Top) < PagebreakPos[p + 1]) // 20160404 Igor
        then
        begin
          MyScrollBox.Controls[I].Top := MyScrollBox.Controls[I].Top -
            PagebreakPos[p]; // 20160404 Igor
          PrintVtShape(MyScrollBox.Controls[I] As TvtShape, ACanvas);
        end;
      end;
      // 20160608 Igor >>>>>
      if MyScrollBox.Controls[I] is TImage then
      begin
        if ((MyScrollBox.Controls[I].Top) >= PagebreakPos[p]) and
          ((MyScrollBox.Controls[I].Top) < PagebreakPos[p + 1]) then
        begin
          MyScrollBox.Controls[I].Top := MyScrollBox.Controls[I].Top -
            PagebreakPos[p]; // 20160404 Igor
          with MyScrollBox.Controls[I] as TImage do
          begin
            R.Left := ScalePrX(Left);
            R.Top := ScalePrY(Top);
            R.Right := ScalePrX(Left + Width);
            R.Bottom := ScalePrY(Top + Height);
            PrintBitmap(ACanvas, R, (MyScrollBox.Controls[I] as TImage)
              .Picture.Bitmap);
          end;
        end;
      end;
      if MyScrollBox.Controls[I] is TFrame then
      begin // search in the frame
        MyFrame := MyScrollBox.Controls[I] as TFrame;
        if ((MyScrollBox.Controls[I].Top) >= PagebreakPos[p]) and
          ((MyScrollBox.Controls[I].Top) < PagebreakPos[p + 1]) then
        begin
          for J := 0 to MyFrame.ComponentCount - 1 do
          begin
            if MyFrame.Components[J] is TImage then
            begin // print the image

              MyImage := MyFrame.Components[J] as TImage;
              // PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);

              // find left and top in ralation to form scaling
              R.Left := ScalePrX(MyFrame.Left);
              R.Top := ScalePrY(MyFrame.Top);

              // consistant height and width scaling
              PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
              PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
              R.Right := R.Left + (MyImage.Picture.Width * (PixelsPerInch.x))
                div ScMult; // ScalePrX(MyFrame.Width);
              R.Bottom := R.Top + (MyImage.Picture.Height * (PixelsPerInch.y))
                div ScMult; // ScalePrY(MyFrame.Height);

              // showmessage('Parent: ' + MyImage.Parent.Name + ' Owner: ' + MyImage.Parent.Name);
              if Pos('FLAGFRAME', UpperCase(MyImage.Parent.Name)) > 0 then
                PrintBitmap(ACanvas, R, MyImage.Picture.Bitmap);

            end;
          end;
        end;
      end
      // 20160608 Igor <<<<<
    end; // For ControlCount
    // 20160404 Igor >>>
    for I := 0 to Length(lblArr) - 1 do
    Begin
      OldTop := lblArr[I].vtLbl.Top;
      lblArr[I].vtLbl.Top := PagebreakPos[p + 1] - PagebreakPos[p] +
        lblArr[I].deltaH + 15; // 20160404 Igor
      S := lblArr[I].vtLbl.Caption;
      if lblArr[I].vtLbl.PrintEveryPageText <> '' then
      Begin
        lblArr[I].vtLbl.Caption :=
          ReplaceStr(lblArr[I].vtLbl.PrintEveryPageText, '[#page]',
          IntToStr(p + 1));
        lblArr[I].vtLbl.Caption := ReplaceStr(lblArr[I].vtLbl.Caption,
          '[#pagecount]', IntToStr(high(PagebreakPos)));
      End;
      PrintLabel(lblArr[I].vtLbl, ACanvas);
      lblArr[I].vtLbl.Caption := S;
      lblArr[I].vtLbl.Top := OldTop;
    End;
    // 20160404 Igor <<<

    if p < high(PagebreakPos) - 1 then
      Printer.NewPage;
  end; // for pagebreak

  if FastPrint then // 20160829 Igor
    NeedNewPage := True; // 20160829 Igor
  if FastPrint = False then
    Printer.EndDoc;
  MyScrollBox.Free;
End;

function GetPrintFormSettings(AFormName: String; ASlipsTypes: TSlipTypes)
  : TPrintFormSettings; // 20170123 //20170214 Igor (all function)
var
  myFormName: string;
begin
  myFormName := ExtractNonInstFormName(AFormName);
  // 20171228 Igor>>>
  if SameText(myFormName, 'T4') then
  begin
    if stGovernment in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T4_1';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        FormHeight := GetFormHeight(AFormName);
        RootForm := myFormName;
        DFM := GetDFMFileName('T4_1');
        Parts := 1;
        PartsInPage := 2;
        ElementInParts := 50;
        SlipType := stGovernment; // 20171226 Igor
        BottomColontitulElm := T4_BOTTOMCOLONTITUL;
        BottomColontitulText := TArray<String>.Create
          ('              1 - Return with T4 Summary');
      end;
    end;

    if stEmployee in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T4_2';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        FormHeight := GetFormHeight(AFormName);
        RootForm := myFormName;
        DFM := GetDFMFileName('T4_2');
        Parts := 2;
        PartsInPage := 2;
        ElementInParts := 50;
        SlipType := stEmployee; // 20171226 Igor
        BottomColontitulElm := T4_BOTTOMCOLONTITUL;
        BottomColontitulText := TArray<String>.Create
          ('   2  - Attach to your income tax return',
          '          3 - To be kept by the employee');
      end;
    end;

    if stPreparer in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T4_1';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        FormHeight := GetFormHeight(AFormName);
        RootForm := myFormName;
        DFM := GetDFMFileName('T4_1');
        Parts := 1;
        PartsInPage := 2;
        ElementInParts := 50;
        SlipType := stPreparer; // 20171226 Igor
        BottomColontitulElm := T4_BOTTOMCOLONTITUL;
        BottomColontitulText := TArray<String>.Create
          (' 4 - To be kept by the employer or payer');
      end;
    end;
  end
  else if SameText(myFormName, 'T4A') then
  begin
    if stGovernment in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T4A_1';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        RootForm := myFormName;
        FormHeight := GetFormHeight(AFormName);
        DFM := GetDFMFileName('T4A_1');
        Parts := 1;
        PartsInPage := 2;
        ElementInParts := 50;
        SlipType := stGovernment; // 20171226 Igor
        BottomColontitulElm := T4A_BOTTOMCOLONTITUL;
        BottomColontitulText := TArray<String>.Create
          ('1 - Return with T4A Summary return');
      end;
    end;

    if stEmployee in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T4A_2';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        RootForm := myFormName;
        FormHeight := GetFormHeight(AFormName);
        DFM := GetDFMFileName('T4A_2');
        Parts := 2;
        PartsInPage := 2;
        ElementInParts := 50;
        SlipType := stEmployee; // 20171226 Igor
        BottomColontitulElm := T4A_BOTTOMCOLONTITUL;
        BottomColontitulText := TArray<String>.Create
          ('2 - Attach to your income tax return',
          '3 - To be kept by the employee');
      end;
    end;

    if stPreparer in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T4A_1';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        RootForm := myFormName;
        FormHeight := GetFormHeight(AFormName);
        DFM := GetDFMFileName('T4A_1');
        Parts := 1;
        PartsInPage := 2;
        ElementInParts := 50;
        SlipType := stPreparer; // 20171226 Igor
        BottomColontitulElm := T4A_BOTTOMCOLONTITUL;
        BottomColontitulText := TArray<String>.Create
          ('4 - To be kept by the employer or payer');
      end;
    end;
  end
  else if SameText(myFormName, 'T5') then
  begin
    if stGovernment in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T5_1';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        RootForm := myFormName;
        FormHeight := GetFormHeight(AFormName);
        DFM := GetDFMFileName('T5_1');
        Parts := 1;
        PartsInPage := 3;
        ElementInParts := 34;
        SlipType := stGovernment; // 20171226 Igor
        BottomColontitulElm := T5_BOTTOMCOLONTITUL2;
        BottomColontitulText := TArray<String>.Create
          ('              1 - Return with T5 Summary');
      end;
    end;

    if stEmployee in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T5_2';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        RootForm := myFormName;
        FormHeight := GetFormHeight(AFormName);
        DFM := GetDFMFileName('T5_2');
        Parts := 2;
        PartsInPage := 2;
        ElementInParts := 34;
        SlipType := stEmployee; // 20171226 Igor
        BottomColontitulElm := T5_BOTTOMCOLONTITUL2;
        BottomColontitulText := TArray<String>.Create
          ('   2  - Attach to your income tax return',
          '   3 - To be kept by the employee');
      end;
    end;

    if stPreparer in ASlipsTypes then
    begin
      SetLength(Result, Length(Result) + 1);
      with Result[Length(Result) - 1] do
      begin
        FormName := 'T5_1';
        FormInst := ExtractFormInst(AFormName);
        FormNo := GetFormNo(AFormName);
        RootForm := myFormName;
        FormHeight := GetFormHeight(AFormName);
        DFM := GetDFMFileName('T5_1');
        Parts := 1;
        PartsInPage := 3;
        ElementInParts := 34;
        SlipType := stPreparer; // 20171226 Igor
        BottomColontitulElm := T5_BOTTOMCOLONTITUL2;
        BottomColontitulText := TArray<String>.Create
          (' 4 - To be kept by the employer or payer');
      end;
    end;
  end
  else
  begin
    SetLength(Result, 1);
    with Result[0] do
    begin
      FormName := AFormName;
      FormInst := ExtractFormInst(AFormName);
      FormNo := GetFormNo(AFormName);
      RootForm := myFormName;
      FormHeight := GetFormHeight(AFormName);
      DFM := GetDFMFileName(AFormName);
      Parts := 1;
      PartsInPage := 1;
      ElementInParts := 0;
    end;
  end;
  // 20171228 Igor<<<
end;

function GenerateEmployerIssueSQL: string; // 20171223 Igor
begin
  Result := 'Select' + #13#10 + '  C.CORP_NAME,' + #13#10 + '  C.ACCOUNT, ' +
    #13#10 + '  CAST(T4Count.Value as VARCHAR) as T4CountValue,' + #13#10 +
    '  CAST(T4Status.Value as VARCHAR) as T4StatusValue,' + #13#10 +
    '  CAST(T4ACount.Value as VARCHAR) as T4ACountValue,' + #13#10 +
    '  CAST(T4AStatus.Value as VARCHAR) as T4AStatusValue,' + #13#10 +
    '  CAST(T5Count.Value as VARCHAR) as T5CountValue,' + #13#10 +
    '  CAST(T5Status.Value as VARCHAR) as T5StatusValue,' + #13#10 +
    '  C.CONTACT,' + #13#10 + '  C.AREA || '' '' || C.PHONE AS PHONE, ' + #13#10
    + '  C.File_Name' + #13#10 + 'from Clients C' + #13#10 +
    '  Left Outer Join FormsInfo as T4Count   ON C.File_Name = T4Count.File_Name '
    + #13#10 + '    AND T4Count.Kind   = ' + QuotedStr(c_FormInfoKind_Count) +
    '  AND T4Count.Form_name   = ''T4''' + #13#10 +
    '  Left Outer Join FormsInfo as T4STATUS  ON C.File_Name = T4Status.File_Name'
    + #13#10 + '    AND T4Status.Kind  = ' + QuotedStr(c_FormInfoKind_Status) +
    ' AND T4Status.Form_name  = ''T4''' + #13#10 +
    '  Left Outer Join FormsInfo as T4ACount  ON C.File_Name = T4ACount.File_Name'
    + #13#10 + '    AND T4ACount.Kind  = ' + QuotedStr(c_FormInfoKind_Count) +
    '  AND T4ACount.Form_name  = ''T4A''' + #13#10 +
    '  Left Outer Join FormsInfo as T4AStatus ON C.File_Name = T4AStatus.File_Name'
    + #13#10 + '    AND T4AStatus.Kind = ' + QuotedStr(c_FormInfoKind_Status) +
    ' AND T4AStatus.Form_name = ''T4A''' + #13#10 +
    '  Left Outer Join FormsInfo as T5Count   ON C.File_Name = T5Count.File_Name'
    + #13#10 + '    AND T5Count.Kind   = ' + QuotedStr(c_FormInfoKind_Count) +
    '  AND T5Count.Form_name   = ''T5''' + #13#10 +
    '  Left Outer Join FormsInfo as T5Status  ON C.File_Name = T5Status.File_Name'
    + #13#10 + '    AND T5Status.Kind  = ' + QuotedStr(c_FormInfoKind_Status) +
    ' AND T5Status.Form_name  = ''T5''' + #13#10 + 'ORDER BY' + #13#10 +
    '  C.CORP_NAME';
end;

procedure PrintEmployerIssuer; // 20171221 Igor
var
  Con: TADConnection;
  Q: TADQuery;
begin
  Con := TADConnection.Create(nil);
  try
    SetConnection(Con, OptRec.Dir_Cur + '\' + ClientsDBLite, 'Clients',
      False, False);
    Q := TADQuery.Create(Nil);
    try
      Q.Connection := Con;
      // 20171223 Igor >>>
      Q.SQL.Text := GenerateEmployerIssueSQL;
      // 20171223 Igor <<<
      Q.Open;
      with TvtPDFPrinter.Create(AppT4T5_2026) do
        try
          // 20171224CON change issuer to Payer for consistency with other places
          // 20171223 Igor >>>
          PrintDataSet('Employer / Payer', 'Employer / Payer', [],
            ['Corporation Name', 'Account', 'T4 Count', 'T4 Status',
            'T4A Count', 'T4A Status', 'T5 Count', 'T5 Status', 'Contact',
            'Phone'], ['CORP_NAME', 'ACCOUNT', 'T4CountValue', 'T4StatusValue',
            'T4ACountValue', 'T4AStatusValue', 'T5CountValue', 'T5StatusValue',
            'CONTACT', 'PHONE'], [22, 12, 10, 15, 10, 15, 10, 15, 20, 20], Q,
            True, poLandscape);
          // 20171223 Igor <<<
        finally
          Free;
        end;
    finally
      Q.Free;
    end;
  finally
    Con.Free;
  end;
end;

procedure qSortFRecByElmFNo(var A: TFRecArray; min, max: Integer;
RetNo, ElmFNo: Integer); // 20180221 Igor
var
  I, J: Integer;
  supp, tmp: TFRec;
begin
  supp := A[max - ((max - min) div 2)];
  I := min;
  J := max;
  while I < J do
  begin
    while CompareText(FetchElmFNo(RetNo, A[I].FormNo, ElmFNo),
      FetchElmFNo(RetNo, supp.FormNo, ElmFNo)) < 0 do
      I := I + 1;
    while CompareText(FetchElmFNo(RetNo, A[J].FormNo, ElmFNo),
      FetchElmFNo(RetNo, supp.FormNo, ElmFNo)) > 0 do
      J := J - 1;
    if I <= J then
    begin
      tmp := A[I];
      A[I] := A[J];
      A[J] := tmp;
      I := I + 1;
      J := J - 1;
    end;
  end;
  if min < J then
    qSortFRecByElmFNo(A, min, J, RetNo, ElmFNo);
  if I < max then
    qSortFRecByElmFNo(A, I, max, RetNo, ElmFNo);
end;

procedure PrintT4Audit(const ARetNo: Integer); // 20171226 Igor
var
  FileNm, Hdr1, Hdr2, Hdr3: string;
  F1: TextFile;
  S: string;
  TBox14, TBox16, TBox17, TBox18, TBox20, TBox22, TBox30, TBox32, TBox34,
    TBox36: Real;
  TBox38, TBox40, TBox42, TBox44, TBox46, TBox52, TNetPay, TNetCalc: Real;
  T4Cnt: Integer;
  I: Integer;
  F: TFRecArray;
  R: TFRec;
begin
  TBox14 := 0;
  TBox16 := 0;
  TBox17 := 0;
  TBox18 := 0;
  TBox20 := 0;
  TBox22 := 0;
  TBox30 := 0;
  TBox32 := 0;
  TBox34 := 0;
  TBox36 := 0;
  TBox38 := 0;
  TBox40 := 0;
  TBox42 := 0;
  TBox44 := 0;
  TBox46 := 0;
  TBox52 := 0;
  TNetPay := 0;
  TNetCalc := 0;
  T4Cnt := 0;
  Hdr1 := Space(30) + FetchElm(ARetNo, 'EMPL', EMPL_EMPL_NAME) +
    ' - T4 Audit List' + PaddR(' ', 15) + PaddR(DateToMonthDayYear(Date), 20);
  Hdr2 := PaddR('SIN', 10) + PaddR('Name', 17) + PaddR('Gross', 12) +
    PaddR('CPP/QPP', 9) + PaddR('EI Prem', 12) + PaddR('RPP', 12) +
    PaddR('Tax', 10) + PaddR('EI Inrbl', 11) + PaddR('Othr boxes', 11) +
    PaddR('Un/Don', 10);
  { Space(20)+PaddR('Name',55)+PaddR('Area',4)+PaddR('Telephone',8); }
  Hdr3 := FilledStr(80, '=') + FilledStr(34, '=');
  { open output file }
  FileNm := TPath.Combine(AppDir, 'TempFile');
  AssignFile(F1, FileNm);
  Rewrite(F1);
  F := Ret[ARetNo].FList.GetAllInstForms('T4');
  // 20180221 Igor >>>
  if Length(F) > 0 then
    qSortFRecByElmFNo(F, 0, High(F), ARetNo, T4_LASTNAME);
  // 20180221 Igor <<<
  for R in F do
  begin
    if not RetList[ARetNo].FrmHasData[R.FormNo] then
      Continue;
    Inc(T4Cnt);
    TBox14 := TBox14 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX14));
    // R. FieldByName('Box14').AsFloat;
    TBox16 := TBox16 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX16));
    // FieldByName('Box16').AsFloat;
    TBox17 := TBox17 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX17));
    // FieldByName('Box17').AsFloat;
    TBox18 := TBox18 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX18));
    // FieldByName('Box18').AsFloat;
    TBox20 := TBox20 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX20));
    // FieldByName('Box20').AsFloat;
    TBox22 := TBox22 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX22));
    // FieldByName('Box22').AsFloat;
    // TBox30 := TBox30 + VL(FetchElmFNo(ARetNo, R.FormNo, T4_BOX30)); //FieldByName('Box30').AsFloat;
    // TBox32 := TBox32 + VL(FetchElmFNo(ARetNo, R.FormNo, T4_BOX32)); //FieldByName('Box32').AsFloat;
    // TBox34 := TBox34 + VL(FetchElmFNo(ARetNo, R.FormNo, T4_BOX34)); //FieldByName('Box34').AsFloat;
    // TBox36 := TBox36 + VL(FetchElmFNo(ARetNo, R.FormNo, T4_BOX36)); //FieldByName('Box36').AsFloat;
    // TBox38 := TBox38 + VL(FetchElmFNo(ARetNo, R.FormNo, T4_BOX38)); //FieldByName('Box38').AsFloat;
    // TBox40 := TBox40 + VL(FetchElmFNo(ARetNo, R.FormNo, T4_BOX40)); //FieldByName('Box40').AsFloat;
    // TBox42 := TBox42 + VL(FetchElmFNo(ARetNo, R.FormNo, T4_BOX42)); //FieldByName('Box42').AsFloat;
    TBox44 := TBox44 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX44));
    // FieldByName('Box44').AsFloat;
    TBox46 := TBox46 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX46));
    // FieldByName('Box46').AsFloat;
    TBox52 := TBox52 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX52));
    // FieldByName('Box52').AsFloat;
    TNetPay := TNetPay + Vl(FetchElmFNo(ARetNo, R.FormNo, 103));
    // FieldByName('NetPay').AsFloat;
    TNetCalc := TNetCalc + Vl(FetchElmFNo(ARetNo, R.FormNo, 104));
    // FieldByName('NetCalc').AsFloat;

    S := PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo,
      T4_SIN) { FieldByName('SIN').AsString } ), 9), 9) + '  ' +
      PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4_FIRSTNAME)
      { FieldByName('FirstNAME').AsString } ), 1), 1) + '.' +
      PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4_LASTNAME)
      { FieldByName('LASTNAME').AsString } ), 15), 15) + ' ';
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX14))
      { FieldByName('Box14').AsFloat } ), 11), 11) +
      JustRight(PaddR(FormatFloat('#,###.00', Vl(FetchElmFNo(ARetNo, R.FormNo,
      T4_BOX16)) { FieldByName('Box16').AsFloat } + Vl(FetchElmFNo(ARetNo,
      R.FormNo, T4_BOX17)) { FieldByName('Box17').AsFloat } ), 11), 11) +
      JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX18))
      { FieldByName('Box18').AsFloat } ), 10), 10) +
      JustRight(PaddR(FormatFloat('###,###.00', Vl(FetchElmFNo(ARetNo, R.FormNo,
      T4_BOX20)) { FieldByName('Box20').AsFloat } ), 11), 11);
    S := S + JustRight(PaddR(FormatFloat('##,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX22))
      { FieldByName('Box22').AsFloat } ), 10), 10) +
      JustRight(PaddR(FormatFloat('##,###.00', Vl(FetchElmFNo(ARetNo, R.FormNo,
      T4_BOX24)) { FieldByName('Box24').AsFloat } ), 10), 10);
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4_AMOUNT1))
      { FieldByName('Amount1').AsFloat } + Vl(FetchElmFNo(ARetNo, R.FormNo,
      T4_AMOUNT2)) { FieldByName('Amount2').AsFloat } + Vl(FetchElmFNo(ARetNo,
      R.FormNo, T4_AMOUNT3)) { FieldByName('Amount3').AsFloat } +
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4_AMOUNT4))
      { FieldByName('Amount4').AsFloat } + Vl(FetchElmFNo(ARetNo, R.FormNo,
      T4_AMOUNT5)) { FieldByName('Amount5').AsFloat } + Vl(FetchElmFNo(ARetNo,
      R.FormNo, T4_AMOUNT6)) { FieldByName('Amount6').AsFloat } ), 11), 11);
    S := S + JustRight(PaddR(FormatFloat('##,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4_BOX44))
      { FieldByName('Box44').AsFloat } + Vl(FetchElmFNo(ARetNo, R.FormNo,
      T4_BOX46)) { FieldByName('Box46').AsFloat } ), 9), 9);
    WriteLn(F1, S);
    S := FilledStr(80, ' ');
    WriteLn(F1, S);
  end;
  S := FilledStr(80, '=') + FilledStr(34, '=');
  WriteLn(F1, S);
  S := FilledStr(80, ' ');
  WriteLn(F1, S);
  S := 'TOTALS PER BOX';
  WriteLn(F1, S);
  S := FilledStr(80, '=') + FilledStr(34, '=');
  WriteLn(F1, S);

  S := PaddR('Box 14 - Gross pay', 40) +
    JustRight(FormatFloat('####,###.00', TBox14), 12);
  WriteLn(F1, S);

  S := PaddR('Box 16 - CPP', 40) +
    JustRight(FormatFloat('####,###.00', TBox16), 12);
  WriteLn(F1, S);

  S := PaddR('Box 17 - QPP', 40) +
    JustRight(FormatFloat('####,###.00', TBox17), 12);
  WriteLn(F1, S);
  S := PaddR('Box 18 - EI Premiums', 40) +
    JustRight(FormatFloat('####,###.00', TBox18), 12);
  WriteLn(F1, S);

  S := PaddR('Box 20 - RPP', 40) +
    JustRight(FormatFloat('####,###.00', TBox20), 12);
  WriteLn(F1, S);

  S := PaddR('Box 22 - Income Tax', 40) +
    JustRight(FormatFloat('####,###.00', TBox22), 12);
  WriteLn(F1, S);

  S := PaddR('Box 44 - Union dues', 40) +
    JustRight(FormatFloat('####,###.00', TBox44), 12);
  WriteLn(F1, S);

  S := PaddR('Box 46 - Charitable donations', 40) +
    JustRight(FormatFloat('####,###.00', TBox46), 12);
  WriteLn(F1, S);

  S := PaddR('Box 52 - Pension adjustment', 40) +
    JustRight(FormatFloat('####,###.00', TBox52), 12);
  WriteLn(F1, S);

  S := PaddR('Net Pay Entered', 40) +
    JustRight(FormatFloat('####,###.00', TNetPay), 12);
  WriteLn(F1, S);

  S := PaddR('Net Pay calculated by program', 40) +
    JustRight(FormatFloat('####,###.00', TNetCalc), 12);
  WriteLn(F1, S);

  S := FilledStr(80, ' ');
  WriteLn(F1, S);

  S := PaddR('Number of Employees', 40) + JustRight(IntToStr(T4Cnt), 12);
  WriteLn(F1, S);

  CloseFile(F1);
  if PrintAListing(FileNm, Hdr1, Hdr2, Hdr3) = True then
    ShowMessage('Printing Completed');
end;

procedure PrintT4AAudit(const ARetNo: Integer); // 20171226 Igor
var
  FileNm, Hdr1, Hdr2, Hdr3: string;
  F1: TextFile;
  S: string;
  TBox16, TBox18, TBox20, TBox22, TBox24, TBox26, TBox27, TBox28, TBox30: Real;
  TBox34, TBox40, TBox42, TBox46, TBox48: Real;
  T4ACnt: Integer;
  I: Integer;
  F: TFRecArray;
  R: TFRec;
begin
  TBox16 := 0;
  TBox18 := 0;
  TBox20 := 0;
  TBox22 := 0;
  TBox24 := 0;
  TBox26 := 0;
  TBox27 := 0;
  TBox28 := 0;
  TBox30 := 0;
  TBox34 := 0;
  TBox46 := 0;
  TBox40 := 0;
  TBox42 := 0;
  TBox48 := 0;
  T4ACnt := 0;
  Hdr1 := Space(30) + FetchElm(ARetNo, 'EMPL', EMPL_EMPL_NAME) +
    ' - T4A Audit List' + PaddR(' ', 15) + PaddR(DateToMonthDayYear(Date), 20);
  Hdr2 := PaddR('SIN', 10) + PaddR('Name', 20) + PaddR('Pension', 12) +
    PaddR('Lump-sum', 12) + PaddR('S/E Comm', 12) + PaddR('Tax', 12) +
    PaddR('Annuities', 12) + PaddR('Fees/Serv', 12);
  // +PaddR('Oth Inc', 12);
  Hdr3 := FilledStr(80, '=') + FilledStr(34, '=');
  { open output file }
  FileNm := TPath.Combine(AppDir, 'TempFile');
  AssignFile(F1, FileNm);
  Rewrite(F1);
  F := Ret[ARetNo].FList.GetAllInstForms('T4A');
  // 20180221 Igor >>>
  if Length(F) > 0 then
    qSortFRecByElmFNo(F, 0, High(F), ARetNo, T4A_LASTNAME);
  // 20180221 Igor <<<
  for R in F do
  begin
    if not RetList[ARetNo].FrmHasData[R.FormNo] then
      Continue;
    Inc(T4ACnt);
    TBox16 := TBox16 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX16));
    // FieldByName('Box16').AsFloat;
    TBox18 := TBox18 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX18));
    // FieldByName('Box18').AsFloat;
    TBox20 := TBox20 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX20));
    // FieldByName('Box20').AsFloat;
    TBox22 := TBox22 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX22));
    // FieldByName('Box22').AsFloat;
    TBox24 := TBox24 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX24));
    // FieldByName('Box24').AsFloat;
    TBox48 := TBox48 + Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX48));
    // FieldByName('Box48').AsFloat;

    S := PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_SIN)
      { FieldByName('SIN').AsString } ), 9), 9) + '  ' +
      PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_FIRSTNAME)
      { FieldByName('FirstNAME').AsString } ), 1), 1) + '.' +
      PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo, T4A_LASTNAME)
      { FieldByName('LASTNAME').AsString } ), 15), 15) + ' ';
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX16))
      { FieldByName('Box16').AsFloat } ), 11), 11) +
      JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX18))
      { FieldByName('Box18').AsFloat } ), 11), 11) +
      JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX20))
      { FieldByName('Box20').AsFloat } ), 11), 11);
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX22))
      { FieldByName('Box22').AsFloat } ), 11), 11) +
      JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX24))
      { FieldByName('Box24').AsFloat } ), 11), 11);
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX48))
      { FieldByName('Box48').AsFloat } ), 11), 11);
    // S := S + JustRight(PaddR(FormatFloat('####,###.00', VL(FetchElmFNo(ARetNo, R.FormNo, T4A_BOX28)){FieldByName('Box28').AsFloat}), 11), 11);

    WriteLn(F1, S);
    S := FilledStr(80, ' ');
    WriteLn(F1, S);
  end;
  S := FilledStr(80, '=') + FilledStr(34, '=');
  WriteLn(F1, S);
  S := FilledStr(80, ' ');
  WriteLn(F1, S);
  S := 'TOTALS PER BOX';
  WriteLn(F1, S);
  S := FilledStr(80, '=') + FilledStr(34, '=');
  WriteLn(F1, S);

  S := PaddR('Box 16 - Pension or Superannuation', 40) +
    JustRight(FormatFloat('####,###.00', TBox16), 12);
  WriteLn(F1, S);

  S := PaddR('Box 18 - Lump-sum payments', 40) +
    JustRight(FormatFloat('####,###.00', TBox18), 12);
  WriteLn(F1, S);

  S := PaddR('Box 20 - Self-employed commissions', 40) +
    JustRight(FormatFloat('####,###.00', TBox20), 12);
  WriteLn(F1, S);
  S := PaddR('Box 22 - Income tax', 40) +
    JustRight(FormatFloat('####,###.00', TBox22), 12);
  WriteLn(F1, S);
  S := PaddR('Box 24 - Annuities', 40) +
    JustRight(FormatFloat('####,###.00', TBox24), 12);
  WriteLn(F1, S);
  S := PaddR('Box 48 - Fees for services', 40) +
    JustRight(FormatFloat('####,###.00', TBox48), 12);
  WriteLn(F1, S);

  // S := PaddR('Box 26 - Eligible retiring allowances', 40) + JustRight(FormatFloat('####,###.00', TBox26), 12); WriteLn(F1, S);

  // S := PaddR('Box 27 - Non-eligible retiring allowances', 40) + JustRight(FormatFloat('####,###.00', TBox27), 12); WriteLn(F1, S);

  // S := PaddR('Box 28 - Other income',40) + JustRight(FormatFloat('####,###.00', TBox28), 12); WriteLn(F1, S);

  // S := PaddR('Box 30 - Patronate allocations', 40) + JustRight(FormatFloat('####,###.00', TBox30), 12); WriteLn(F1, S);
  // S := PaddR('Box 34 - Pension adjustment', 40) + JustRight(FormatFloat('####,###.00', TBox34), 12); WriteLn(F1, S);

  // S := PaddR('Box 40 - RESP accum. income payments', 40) + JustRight(FormatFloat('####,###.00', TBox40), 12); WriteLn(F1, S);
  // S := PaddR('Box 42 - RESP educational assistance payments', 40) + JustRight(FormatFloat('####,###.00', TBox42), 12); WriteLn(F1,S);

  // S := PaddR('Box 46 - Charitable donations', 40) + JustRight(FormatFloat('####,###.00', TBox46), 12); WriteLn(F1, S);

  S := FilledStr(80, ' ');
  WriteLn(F1, S);
  S := PaddR('Number of slips', 40) + JustRight(IntToStr(T4ACnt), 12);
  WriteLn(F1, S);

  CloseFile(F1);
  If PrintAListing(FileNm, Hdr1, Hdr2, Hdr3) = True then
    ShowMessage('Printing Completed');
end;

procedure PrintT5Audit(const ARetNo: Integer); // 20171226 Igor
var
  FileNm, Hdr1, Hdr2, Hdr3: string;
  F1: TextFile;
  S: string;
  TBox10, TBox11, TBox12, TBox13, TBox14, TBox15, TBox16, TBox17: Real;
  TBox24, TBox25, TBox26, TBox18, TBox19: Real;
  T5Cnt: Integer;
  I: Integer;
  F: TFRecArray;
  R: TFRec;
begin
  TBox10 := 0;
  TBox11 := 0;
  TBox12 := 0;
  TBox24 := 0;
  TBox25 := 0;
  TBox26 := 0;
  TBox13 := 0;
  TBox14 := 0;
  TBox15 := 0;
  TBox16 := 0;
  TBox17 := 0;
  TBox18 := 0;
  TBox19 := 0;
  // TBox20 := 0;
  T5Cnt := 0;
  Hdr1 := Space(30) + FetchElm(ARetNo, 'EMPL', EMPL_EMPL_NAME) +
    ' - T5 Audit List' + PaddR(' ', 15) + PaddR(DateToMonthDayYear(Date), 20);
  Hdr2 := PaddR('SIN', 10) + PaddR('Name', 20) + PaddR('ActDiv-Non Elig', 17) +
    PaddR('ActDiv-Eligible', 17) + PaddR('Interest', 12) +
    PaddR('OthIncome', 12) + PaddR('C/GainsDiv', 12) + PaddR('Annuities', 12);
  Hdr3 := FilledStr(80, '=') + FilledStr(34, '=');
  { open output file }
  FileNm := TPath.Combine(AppDir, 'TempFile');
  AssignFile(F1, FileNm);
  Rewrite(F1);
  F := Ret[ARetNo].FList.GetAllInstForms('T5');
  // 20180221 Igor >>>
  if Length(F) > 0 then
    qSortFRecByElmFNo(F, 0, High(F), ARetNo, T5_LASTNAME_FIRSTNAME);
  // 20180221 Igor <<<
  for R in F do
  begin
    if not RetList[ARetNo].FrmHasData[R.FormNo] then
      Continue;
    Inc(T5Cnt);
    TBox10 := TBox10 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX10));
    // FieldByName('Box10').AsFloat;
    TBox11 := TBox11 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX11));
    // FieldByName('Box11').AsFloat;
    TBox12 := TBox12 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX12));
    // FieldByName('Box12').AsFloat;
    TBox24 := TBox24 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX24));
    // FieldByName('Box24').AsFloat;
    TBox25 := TBox25 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX25));
    // FieldByName('Box25').AsFloat;
    TBox26 := TBox26 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX26));
    // FieldByName('Box26').AsFloat;
    TBox13 := TBox13 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX13));
    // FieldByName('Box13').AsFloat;
    TBox14 := TBox14 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX14));
    // FieldByName('Box14').AsFloat;
    TBox15 := TBox15 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX15));
    // FieldByName('Box15').AsFloat;
    // TBox16 := TBox16 + VL(FetchElmFNo(ARetNo, R.FormNo, T5_BOX16)); //FieldByName('Box16').AsFloat;
    TBox17 := TBox17 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX17));
    // FieldByName('Box17').AsFloat;
    TBox18 := TBox18 + Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX18));
    // FieldByName('Box18').AsFloat;
    // TBox19 := TBox19 + VL(FetchElmFNo(ARetNo, R.FormNo, T5_BOX19)); //FieldByName('Box19').AsFloat;
    // TBox20 := TBox20 + VL(FetchElmFNo(ARetNo, R.FormNo, T5_BOX20)); //FieldByName('Box20').AsFloat;

    S := PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo,
      T5_SIN) { FieldByName('SIN').AsString } ), 9), 9) + '  ' +
      PaddR(LeftStr(AllTrim(FetchElmFNo(ARetNo, R.FormNo, T5_LASTNAME_FIRSTNAME)
      { FieldByName('FirstNAME').AsString } ), 16), 16);
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX10))
      { FieldByName('Box10').AsFloat } ), 12), 17);
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX24))
      { FieldByName('Box24').AsFloat } ), 12), 17);
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX13))
      { FieldByName('Box13').AsFloat } ), 12), 12) +
      JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX14))
      { FieldByName('Box14').AsFloat } ), 12), 12);
    S := S + JustRight(PaddR(FormatFloat('####,###.00',
      Vl(FetchElmFNo(ARetNo, R.FormNo, T5_BOX18))
      { FieldByName('Box18').AsFloat } ), 12), 12);
    // S := S + JustRight(PaddR(FormatFloat('####,###.00', VL(FetchElmFNo(ARetNo, R.FormNo, T5_BOX19)){FieldByName('Box19').AsFloat}), 12), 12);

    WriteLn(F1, S);
    S := FilledStr(80, ' ');
    WriteLn(F1, S);
  end;
  S := FilledStr(80, '=') + FilledStr(34, '=');
  WriteLn(F1, S);
  S := FilledStr(80, ' ');
  WriteLn(F1, S);
  S := 'TOTALS PER BOX';
  WriteLn(F1, S);
  S := FilledStr(80, '=') + FilledStr(34, '=');
  WriteLn(F1, S);

  S := PaddR('Box 10 - Actual Dividends - Other than eligible', 60) +
    JustRight(FormatFloat('####,###.00', TBox10), 12);
  WriteLn(F1, S);

  S := PaddR('Box 11 - Taxable Dividends - Other than eligible', 60) +
    JustRight(FormatFloat('####,###.00', TBox11), 12);
  WriteLn(F1, S);

  S := PaddR('Box 12 - Federal dividend tax credit - Other than eligible', 60) +
    JustRight(FormatFloat('####,###.00', TBox12), 12);
  WriteLn(F1, S);

  S := PaddR('Box 13 - Interest from cdn sources', 60) +
    JustRight(FormatFloat('####,###.00', TBox13), 13);
  WriteLn(F1, S);

  S := PaddR('Box 14 - Other income from cnd sources', 60) +
    JustRight(FormatFloat('####,###.00', TBox14), 12);
  WriteLn(F1, S);

  S := PaddR('Box 15 - Foreign income', 60) +
    JustRight(FormatFloat('####,###.00', TBox15), 12);
  WriteLn(F1, S);

  { TODO -oIgor -cCheck: Box 16 – Foreign tax paid
    We use this amount to calculate your foreign tax credit. For more information, see line 405 of your tax guide.
    Box 17 – Royalties from Canadian sources
    If royalties are from a work or invention of yours with no associated expenses, enter the amount on line 104 of your return.
    Enter on line 135 your royalties that have expenses associated with them. Enter on line 121 of your return all other royalties.

    S := PaddR('Box 16 - Foreign tax paid', 60) + JustRight(FormatFloat('####,###.00', TBox16), 12);
    WriteLn(F1, S);
  }

  S := PaddR('Box 17 - Royalties from canadian sources', 60) +
    JustRight(FormatFloat('####,###.00', TBox17), 12);
  WriteLn(F1, S);

  S := PaddR('Box 18 - Capital gains dividends', 60) +
    JustRight(FormatFloat('####,###.00', TBox18), 12);
  WriteLn(F1, S);

  // S := PaddR('Box 19 - Accrued income: Annuities', 60) + JustRight(FormatFloat('####,###.00',TBox19),12);
  // WriteLn(F1, S);

  // S := PaddR('Box 20 - Eligible for res. allow. ded.', 60) + JustRight(FormatFloat('####,###.00', TBox20), 12);
  // WriteLn(F1, S);

  S := PaddR('Box 24 - Actual Dividends - Eligible', 60) +
    JustRight(FormatFloat('####,###.00', TBox24), 12);
  WriteLn(F1, S);

  S := PaddR('Box 25 - Taxable Dividends - Eligible', 60) +
    JustRight(FormatFloat('####,###.00', TBox25), 12);
  WriteLn(F1, S);

  S := PaddR('Box 26 - Federal dividend tax credit - Eligible', 60) +
    JustRight(FormatFloat('####,###.00', TBox26), 12);
  WriteLn(F1, S);

  S := FilledStr(80, ' ');
  WriteLn(F1, S);
  S := PaddR('Number of slips', 60) + JustRight(IntToStr(T5Cnt), 12);
  WriteLn(F1, S);

  CloseFile(F1);
  If PrintAListing(FileNm, Hdr1, Hdr2, Hdr3) = True then
    ShowMessage('Printing Completed');
end;

procedure PrintEmployersList; // 20171226 Igor
var
  FileNm, Hdr1, Hdr2, Hdr3: string;
  F1: TextFile;
  S: string;
  Con: TADConnection;
  Q: TADQuery;
begin
  Hdr1 := Space(40) + 'Employer Listing' + PaddR(' ', 15) +
    PaddR(DateToMonthDayYear(Date), 20);
  Hdr2 := PaddR('Code', 6) + PaddR('Name', 35) + PaddR('Bus. Number', 18) +
    PaddR('Contact', 21) + PaddR('Telephone', 13);
  { Space(20)+PaddR('Name',55)+PaddR('Area',4)+PaddR('Telephone',8); }
  Hdr3 := FilledStr(80, '=') + FilledStr(14, '=');
  { open output file }
  FileNm := TPath.Combine(AppDir, 'TempFile');
  AssignFile(F1, FileNm);
  Rewrite(F1);

  Con := TADConnection.Create(nil);
  Q := TADQuery.Create(Nil);
  try
    SetConnection(Con, OptRec.Dir_Cur + '\' + ClientsDBLite, 'Clients',
      False, False);
    Q.Connection := Con;
    Q.SQL.Text :=
      'select CORP_Name, ACCOUNT, CONTACT, AREA, PHONE from Clients C';
    Q.Open;
    Q.First;
    while not Q.Eof do
    begin
      S := PaddR('' { LeftStr(AllTrim(Q.FieldByName('EmplNo').AsString), 3) } ,
        4) + '  ';
      S := S + PaddR(LeftStr(AllTrim(Q.FieldByName('CORP_Name').AsString), 30),
        30) + ' ';
      S := S + PaddR(LeftStr(AllTrim(Q.FieldByName('ACCOUNT').AsString), 18),
        18) + ' ';
      S := S + PaddR(LeftStr(AllTrim(Q.FieldByName('CONTACT').AsString), 21),
        21) + ' ' + PaddR(LeftStr(AllTrim(Q.FieldByName('AREA').AsString), 4),
        4) + ' ' +
        PaddR(LeftStr(AllTrim(Q.FieldByName('PHONE').AsString), 8), 8);
      WriteLn(F1, S);
      Q.Next;
    end;
  finally
    Q.Free;
    Con.Free;
  end;
  CloseFile(F1);
  If PrintAListing(FileNm, Hdr1, Hdr2, Hdr3) = True then
    ShowMessage('Printing Completed');
end;

// 20171228 Igor>>>
initialization

finalization

FreeAndNil(FullFormToPrint);
FreeAndNil(FGlob);
// 20171228 Igor<<<

end.
