unit TF_2026print;

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

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,Printers,extctrls,vtEditBox,vtShape,vtLabel,
  RichEdit, ComCtrls,
  vtGroupBox, vtForm, //20160407 Igor
  vtMulti, //20170628 Igor

  rxRichEd; //20160819 Igor (Must be last)


Const MxFrmHeight = 1050; //1050; //980; //960;
Const MxFrmWidth  = 655;
CONST
  RTF_INDENT_LEFT  = 80;//20160210 Igor
  RTF_INDENT_RIGHT = 60;//20160210 Igor

{$IFDEF single}
Const DesignPixelsPerInch = 96; //96;
Const ScMult = 100;  {Scale Multiplier to get accuracy}

type
  TMargins = record
    Left,
    Top,
    Right,
    Bottom: Double
end;
{$ELSE}
{$ENDIF}



Procedure AfterReadComponentForPrint(AForm:TForm;FName:String);
Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String; FNo: Integer;
  hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0; AisSynPDF: Boolean = False); //20180503 Igor
{$IFDEF single}
Procedure PrintMemo(RetNo:Integer;AMemo:TMemo;ACanvas:TCanvas);
Procedure PrintVtShape(MyVtShape:TVtShape;ACanvas:TCanvas);
Procedure PrintLabel(MyLabel:TvtLabel;ACanvas:TCanvas);
Procedure PrintImage(RetNo:Integer;AImage:TImage;hdc:THandle;ACanvas:TCanvas);
Procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);

Procedure PrintRichEdit(RetNo:Integer;ARichEdit:TwwDbRichEdit;ACanvas:TCanvas);

procedure DrawShape(TopLeft, BottomRight: TPoint; PenWidth: Integer;ACanvas:TCanvas);
procedure DrawTriangle(MyVtShape:TVtShape;ACanvas:TCanvas;R:TRect);
procedure DrawArrow(MyVtShape:TVtShape;ACanvas:TCanvas;R:TRect);
procedure DrawOthers(MyVtShape:TVtShape;ACanvas:TCanvas;R:TRect);
Procedure PausePrinting;
Function ScalePrBox(R: TRect):TRect;
Function ScalePrX(X: Longint):LongInt;
Function ScalePrY(Y: Longint):LongInt;
{$ELSE}
{$ENDIF}
Procedure PrintBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; BarCodeImage1:TImage; BarCodeImage2:TImage);
Procedure PrintSFDBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; SFDBarCodeImage1:TImage; SFDBarCodeImage2:TImage);

//Function PrintQuickReport(RetNo: integer; FName: string;WhichPage:integer): boolean;
{Procedure PrintALetter(RetNo:Integer;LetterName:String);}

procedure PrintForm(RetNo: integer; FName: string;WhichPage:integer; LastFormToPrint:String);
procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;formPagebreakHeight:Integer;LastFormToPrint:String);
Procedure PrintDynamicForm(RetNo:Integer;FName:String); //20160901 Igor
{Function PDFPrintFormPage(RetNo: integer; FName: string): boolean;}

Function adjustForCertif(Text:String;FName:String;FieldId:Integer):String;

procedure PrintNR4(ARetNo, APrintKind: Integer; ASelectedForms: TFRecArray);

Var
//ScaleX, ScaleY : Word;
PFile    : TextFile;
HeaderType : string; //[1];
PRINTCNT, PGNO : Integer;
ThisMccrA:string; //[10];

maxBarDataLength : Integer;

NeedNewPage: Boolean; //20160901 Igor

implementation

uses
  {vtMulti,}vtCommon,vtMain,vtDialogs,uFlagFrameCan, //20170628 Igor
  TF_2026,TF_2026TrimStr,
  TF_2026Declare,TF_2026Common,TF_2026Common2,TF_2026Progres,TF_2026Calc,
  TF_2026ChildWinNew,TF_2026Main,vtPrints,vtTrimStr,vtShared
 {,RegularExpressions}, vtChild, // 20151214 Igor //20160405 Igor //20160903 Igor
  vtDynData; //20160901 Igor
Procedure PrintClientLetter(RetNo: integer);
Var LtrName:String;
begin
  LtrName:=GetClientLettersDir+'\'+MkClientLetterName(RetNo);
  If not FileExists(LtrName) then
    LtrName := AppDir+'\'+'DefaultCover.LTR';
end;

procedure PrintForm(RetNo: integer; FName: string;WhichPage:integer; LastFormToPrint:String);
Var i,j,n:integer;Root,FInst :string;
  FrmNm,SubstFrm : string; //[12];
  DfmFileName:String;
  FullForm:TvtScrollBox; //20160405 Igor
  F: TForm;
  PagebreakPos: array of Integer;
  formNumPages,PagebreakHeight:Integer;
  MyLabel:TvtLabel;
  MyEditBox:tvtEdit;
  MyVtShape:TvtShape;

  tmp:integer;
  endPage,startPage:integer;

//  Match: TMatch;          // 20151214 Igor //20160903 Igor
//  strem:TStringStream;    // 20151214 Igor //20160903 Igor
//  newRichText :AnsiString; // 20151214 Igor //20160903 Igor
begin
  If LeftStr(FName,5) = 'LETR_' then begin PrintClientLetter(RetNo); exit; end;

  If LeftStr(Fname,5)='PS50#' then begin MainFormTF.PrintT5013PS50(RetNo); Exit; end;  //20120304
  If IsFormDynamic(RetNo,FName) then //20160901 Igor
  Begin
    PrintDynamicForm(RetNo,FName);
    Exit;
  End; 

Try
  FrmNm := FName;
  FInst := ExtractFormInst(FrmNm);
  DfmFileName:=GetDFMFileName(FrmNm);
  If FileExists(DfmFileName) = false then exit;  //20100113
  //If Ret[RetNo]^.LastYearData = True then DfmFileName:=GetLastYearDfmFileName(FName);
  F := TForm.Create(Application); //20160405 Igor
  F.visible := False; //20160405 Igor
  FullForm := TFormTF_2026.Create(F,RetNo,GetFormNo(FrmNm)); //20160405 Igor
  //FullForm:=TForm.Create(Application); //20160405 Igor
  if ReadComponentResFile(DfmFileName, FullForm) = nil then
  begin
     //ShowMessage('Form '+DfmFileName +' is damaged. Contact VisualTax');
    FullForm.free;
    F.Free; //20160405 Igor
    exit;
  end;
  AfterReadComponentForPrint(TForm(FullForm),FrmNm); //20160405 Igor
  FullForm.AfterOpenForm(vtdPrint);  //20160405 Igor //20160407 Igor
  FullForm.vertscrollbar.position := 0;
  FullForm.horzscrollbar.position := 0;

  SetLength(PagebreakPos, 1);

  formNumPages := 0;
  PagebreakPos[0] := 0;

  //determine if multiple pages
  for i := 0 to FullForm.ControlCount - 1 do
  begin
    // 20151214 Igor
    If FullForm.Controls[i] is TRichEdit then
      IncRichEditFontSize(TRichEdit(FullForm.Controls[i]), 2 * MainOptions.Prn_FontIncr,
        IsFormAClientLetter(FName)); //20160903 Igor //20170204 Igor

    If FullForm.Controls[i] is TVtShape then
    begin
       if (FullForm.Controls[i] as TVtShape).vtPageBreak then
       begin
         MyVtShape := FullForm.Controls[i] as TVtShape;
         SetLength(PagebreakPos, length(PagebreakPos)+1);
         formNumPages := formNumPages + 1;
         MyVtShape.Name := MyVtShape.Name;
         //PagebreakPos[formNumPages] := (FullForm.Components[i] as TVtShape).Top; //old 20151106 Igor
         PagebreakPos[formNumPages] := (FullForm.Controls[i] as TVtShape).Top;     //new 20151106 Igor
       end
       else //avoid shape printing covering other components
         //(FullForm.Components[i] as TVtShape).SendToBack; //old 20151106 Igor
         (FullForm.Controls[i] as TVtShape).SendToBack;     //new 20151106 Igor
    end;

    //20130219
    //give TImage in TFlagFrameCan unique name to avoid "already exists" error when more than one TFlagFrameCan
    if FullForm.Controls[i] is TFlagFrameCan then
    begin
        //showmessage(TFlagFrameCan(FullForm.Controls[i]).name);//showmessage(FullForm.Controls[i].Components[0].name);
        FullForm.Controls[i].Components[0].name := TFlagFrameCan(FullForm.Controls[i]).name + FullForm.Controls[i].Components[0].name;
    end;

  end;  //i components

  //sort array
  for i := high(PagebreakPos)-1 Downto low(PagebreakPos) do
  begin
   for j := i to high(PagebreakPos)-1 do
   begin
    if PagebreakPos[j] > PagebreakPos[j + 1] then
    begin
     tmp := PagebreakPos[j];
     PagebreakPos[j] := PagebreakPos[j + 1];
     PagebreakPos[j + 1] := tmp;
    end;
   end;
  end;

  if formNumPages = 0 then
  begin
    formNumPages := 1;
    PagebreakPos[1] := GetFormHeight(FrmNm);
  end;
  // else
  // begin
    if (whichPage > 0) and (whichPage <> 99) then
    begin
        //settings to print one page
        startPage:= WhichPage-1;
        endPage:=WhichPage-1;
    end
    else
    begin
        startPage:= 0;
        endPage:=formNumPages-1;
    end;

   //////Start of one page multi form printing -------------------------------------

   for j:=startPage to endPage do
   begin
      if FullForm = nil then
      begin
        F := TForm.Create(Application); //20160405 Igor
        F.Visible := False; //20160405 Igor
        FullForm:= TFormTF_2026.Create(F,RetNo,GetFormNo(FrmNm)); //20160405 Igor
//        FullForm:=TForm.Create(Application); //20160405 Igor
        ReadComponentResFile(DfmFileName, FullForm);
        AfterReadComponentForPrint(TForm(FullForm),FName); //20160405 Igor
        FullForm.AfterOpenForm(vtdPrint);  //20160405 Igor //20160407 Igor
        FullForm.vertscrollbar.position := 0;
        FullForm.horzscrollbar.position := 0;
        //20170204 Igor >>>
        for  i := FullForm.ControlCount - 1 downto 0 do
        begin
          If FullForm.Controls[i] is TRichEdit then
            IncRichEditFontSize(TRichEdit(FullForm.Controls[i]), 2 * MainOptions.Prn_FontIncr,
              IsFormAClientLetter(FName)); //20160903 Igor
        end;
        //20170204 Igor <<<
      end;

        PagebreakHeight := PagebreakPos[j+1] - PagebreakPos[j];

        for  i := FullForm.ControlCount - 1 downto 0 do
        begin
            //showmessage((FullForm.Controls[i]).classname);

            if ( FullForm.Controls[i].Top >= PagebreakPos[j] ) and
               ( FullForm.Controls[i].Top < PagebreakPos[j+1] )
            then
            begin
                FullForm.Controls[i].Top := FullForm.Controls[i].Top - PagebreakPos[j];
(* //20170204 Igor
              //20170203 Igor >>>
              If FullForm.Controls[i] is TRichEdit then
                IncRichEditFontSize(TRichEdit(FullForm.Controls[i]), 2 * MainOptions.Prn_FontIncr); //20160903 Igor
              //20170203 Igor <<<
*)
            end
            else
            begin
                //if not(FullForm.Controls[i] is TwwDBRichEdit) then
                    FullForm.Controls[i].Free;
            end;
        end;

{$IFDEF single}
     PFormFileName := AppDir + '\TempPrintForm.dfm';
     WriteComponentResFile(PFormFileName, FullForm);
     FullForm.free;
     PForm:=TForm.Create(Application);

     Try  //20101216
       ReadComponentResFile(PFormFileName, PForm);
     Except
       ShowMessage('Form '+PFormFileName + ' may be damaged. Contact VisualTax');
     end;
     AfterReadComponentForPrint(PForm,FName);

     FrmNm := FName;
     FInst := ExtractFormInst(FrmNm);
     PrintFormPage(RetNo,FrmNm,PForm,j,formNumPages,PagebreakHeight,LastFormToPrint);
     PForm.Free;

     FullForm:=TForm.Create(Application);

     Try  //20101216
       ReadComponentResFile(DfmFileName, FullForm);
     Except
       ShowMessage('Form '+DfmFileName + ' is damaged. Contact VisualTax');
     end;

     FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
     AfterReadComponentForPrint(FullForm,FName);
     FullForm.vertscrollbar.position := 0;
     FullForm.horzscrollbar.position := 0;
{$ELSE}
    PrintFormPage(RetNo,FName,TForm(FullForm),j,formNumPages,PagebreakHeight,LastFormToPrint); //20160405 Igor
    FreeAndNil(FullForm); //force reload at begin of loop
{$ENDIF}
   end; //end for j:=startPage to endPage

   freeAndNil(FullForm); //.Free; //20160901 Igor
   FreeAndNil(F);//.Free; //20160405 Igor //20160901 Igor
   //if FileExists(PFormFileName) then SysUtils.DeleteFile(PFormFileName);
 Except
  ShowMessage(Fname +' encountered printing problem');  //20101208
 end;
end;

{$IFDEF single}
procedure GetPrinterMargins(var Margins: TMargins);
var
  PixelsPerInch: TPoint;
  PhysPageSize: TPoint;
  OffsetStart: TPoint;
  PageRes: TPoint;
begin
  PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  Escape(Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
  PageRes.y := GetDeviceCaps(Printer.Handle, VERTRES);
  PageRes.x := GetDeviceCaps(Printer.Handle, HORZRES);
  // Top Margin
  Margins.Top := OffsetStart.y / PixelsPerInch.y;
  // Left Margin
  Margins.Left := OffsetStart.x / PixelsPerInch.x;
  // Bottom Margin
  Margins.Bottom := ((PhysPageSize.y - PageRes.y) / PixelsPerInch.y) -
    (OffsetStart.y / PixelsPerInch.y);
  // Right Margin
  Margins.Right := ((PhysPageSize.x - PageRes.x) / PixelsPerInch.x) -
    (OffsetStart.x / PixelsPerInch.x);
end;
{$ELSE}
{$ENDIF}

procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;formPagebreakHeight:Integer;LastFormToPrint:String);
var
  //FldRec: PFieldList; //LblRec : PLabelList;  LnRec : PLineList;
  dpiAdjustment, FrmHeight,PenWidth,FNo,d,k,x,y,XPos,YPos : Integer;
  PageX, PageY : LongInt;
  S,Astring, FormattedAmount : string;
  R : TRect;
  Point1,Point2 : TPoint;
  PixelsPerInch: TPoint;
  NullString : Array [0..20] of Char;  {Null terminated string variable/ c type}
  hdc: THandle;
  TempShadeSw :Boolean;
  Ht,Wt:Real; //height and width
  PFName  : PChar;
  ImageRect : TRect;
  BarCodeBmp,SomeImage : TBitMap;
  ARichEdit:TRichEdit;
  DfmFileName:String;
  ACanvas:TCanvas;
  MyLabel:TvtLabel;
  MyEditBox:tvtEdit;
  AImage,AImage1,ASFDImage,ASFDImage1:TImage;
  MyShape:TShape;
  MyVtShape:TvtShape;
  MyVtGroupBox: TvtGroupBox; //20160407 Igor

  MyFrame:TFrame;
  MyBitmap:TBitmap;
  MyImage:TImage;

  Wmf : TMetafile;
  WmfCanvas: TMetafileCanvas;
{$IFDEF single}
  Margins: TMargins;
{$ELSE}
{$ENDIF}

  WinFontSize:Integer;
  DC:THandle;
  xExtraDPIAdjustment,yExtraDPIAdjustment:integer;
  lCurrPageisLandscape: Boolean; //20170127 igor

  RealHeight, RealWidth: Integer; //20170307 Igor

  procedure PrintControls(AControl: TWinControl; ADTop, ADLeft: Integer); //20160407 Igor
  var
    kk, i, b, j: Integer;
  Begin
    kk := AControl.ControlCount-1;
    //print TvtLabels that are black boxes first
    for i := 0 to kk do
    begin
      If AControl.Controls[i] is TvtLabel then
      begin //print the shape
        MyLabel:=AControl.Controls[i] as TvtLabel;

        if (MyLabel.vtBlackBox) and (MyLabel.vtIsPrintable) then
        begin
          PrintLabel(MyLabel,ACanvas, DefFontName, ADTop, ADLeft);
        end;
      end

    end;

    //20110315
    //print rest of TvtShapes before other elements to avoid printing over other elements
    for i := 0 to kk do
    begin
      If AControl.Controls[i] is TVtShape then
      begin //print the shape
        MyVtShape:=AControl.Controls[i] as TVtShape;

        //if MyVtShape.name = 'vtShape17' then showmessage(MyVtShape.name);

        if MyVtShape.vtIsPrintable then
        begin
          PrintVtShape(MyVtShape,ACanvas, ADTop, ADLeft);
        end;
      end
   end;

   for i := kk downto 0 do
   begin
     if AControl.Controls[i] is TvtGroupBox then
     begin //print the GroupBox
       MyVtGroupBox := AControl.Controls[i] as TvtGroupBox;
       if MyVtGroupBox.vtIsPrintable then
       begin
         PrintvtGroupBox(MyvtGroupBox, ACanvas, ADTop, ADLeft);
         PrintControls(MyvtGroupBox, MyvtGroupBox.Top+ADTop, MyvtGroupBox.Left+ADLeft)
       end;
     end
     else
     if AControl.Controls[i] is TvtLabel then
      begin //print the label
        MyLabel:=AControl.Controls[i] as TvtLabel;
        if (MyLabel.vtIsPrintable) and (not MyLabel.vtBlackBox) then
          PrintLabel(MyLabel, ACanvas, DefFontName, ADTop, ADLeft);
      end
      else
      if AControl.Controls[i] is TvtEdit then
      begin //print the editbox
        MyEditBox:=AControl.Controls[i] as TvtEdit;
        if MyEditBox.vtIsPrintable then
        begin
         PrintEditBox(RetNo,MyEditBox,FName,FNo,Hdc,ACanvas,ADTop, ADLeft);
        end;
      end //tvedit
      else
      if AControl.Controls[i] is TRichEdit then //RichEdit
      begin
        ARichEdit:=AControl.Controls[i] as TRichEdit;
        if Assigned(ARichEdit.Parent) then
        begin   // 20151016 igor
          if IsFormAClientLetter(FName) then
          begin
            GetInterpetedRichEdit(RetNo,GetLetterFileName(RetNo,FName),ARichEdit);
            yield; //Delay(50);
          end;
          PrintRichEdit(RetNo, ARichEdit, ACanvas, ADTop, ADLeft,
            IsFormAClientLetter(FName)); //20170109 Igor
        end;
      end //richedit
      else
      if AControl.Controls[i] is TMemo then //TMemo
      begin
        //AMemo:=AControl.Controls[i] as TMemo;
        PrintMemo(RetNo,AControl.Controls[i] as TMemo,ACanvas, ADTop, ADLeft);
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
            //PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
            R.Left   := ScalePrX(MyFrame.Left + ADLeft); //ScalePrX(MyImage.Left) +
            R.Top    := ScalePrY(MyFrame.Top + ADTop);  //ScalePrY(MyImage.Top)  +
            R.Right  := R.Left +  ScalePrX(MyImage.Picture.Width); //ScalePrX(MyFrame.Width);
            R.Bottom := R.Top  +  ScalePrY(MyImage.Picture.Height); //ScalePrY(MyFrame.Height);
            PrintBitmap(ACanvas,R,MyImage.Picture.Bitmap);
          end;
        end;
      end //frame
      //20170122
      else
      if AControl.Controls[i] is TImage then
      begin //search in the frame
            MyImage := AControl.Controls[i] as TImage; //MyFrame.Components[j] as TImage;
            R.Left   := ScalePrX(MyImage.Left + ADLeft); //ScalePrX(MyImage.Left) +
            R.Top    := ScalePrY(MyImage.Top + ADTop);  //ScalePrY(MyImage.Top)  +
            R.Right  := R.Left +  ScalePrX(MyImage.Picture.Width); //ScalePrX(MyFrame.Width);
            R.Bottom := R.Top  +  ScalePrY(MyImage.Picture.Height); //ScalePrY(MyFrame.Height);
            PrintBitmap(ACanvas,R,MyImage.Picture.Bitmap);
      end; //Timage
   end;  //i Controls
  End;
begin
   FName := UpperCase(Ltrim(RTrim(Fname)));
   //20160901 Igor >>>
   FNo := GetFormNo(FName);
   If FNo=0 then
   begin
     If Printer.Printing then
       Printer.EndDoc;
     exit;
   end;
   If AbortSw then
   Begin
     If Printer.Printing then
       Printer.EndDoc;
     exit;
   end;
   //20160901 Igor <<<

   if (Printer.Printing) and (FastPrint=False) then
   begin
    if MessageDlg('Printer temporarily busy. Try again?',
      mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;
   end;
   WhiteBoxes := GetWhiteBoxesIndicator(FName);

    //20160901 Igor >>>
    lCurrPageisLandscape := CurrentPageIsLanscape(AForm, IsLandscape(FName), MxFrmWidth, 0, maxInt, RealHeight, RealWidth); //20170127 Igor //20170307 Igor
    if ((Printer.Orientation = poLandscape) <> lCurrPageisLandscape{IsLandscape(FName)}) then //20170127 Igor
    begin
      if Printer.Printing then
        Printer.EndDoc;

      If lCurrPageisLandscape {IsLandscape(FName)} Then  //20170127 Igor
        Printer.Orientation := poLandscape
      else
        Printer.Orientation := poPortrait;
      Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo); //20160905 Igor
      Printer.BeginDoc;
      NeedNewPage := False;
    end;
    If not Printer.Printing then
    begin
      Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo); //20160905 Igor
      Printer.BeginDoc;
      NeedNewPage := False;
    end;
    if NeedNewPage then
      Printer.NewPage;

//   If FastPrint = false then
//   begin
//    If IsLandscape(FName) Then
//      Printer.Orientation := poLandscape
//    else
//      Printer.Orientation := poPortrait;
//   end
//   Else
//    ;//Printer.Orientation := poPortrait;  //fst print
//
//
//   //ShowMessage('Bfr begindoc= '+IntToStr(GetGDIResources));
//   If FastPrint=false then
//     Printer.BeginDoc;

   //ShowMessage('aftr begindoc= '+IntToStr(GetGDIResources));
//   FNo := GetFormNo(FName);
//   If FNo=0 then
//    begin
//     If FastPrint =false then Printer.EndDoc;
//     exit;
//    end;
    //20160901 Igor <<<


   If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
//   Printer.Title := GetRetName(RetNo); //GetReturnName(RetNo);  //20160905

   hdc :=  Printer.Canvas.Handle;
   ACanvas:=Printer.Canvas;

   CalcScaleXY(RealHeight, RealWidth); //20170307 Igor
    //20170212 Igor>>>
//   dpiAdjustment := ( GetWindowsFontSize(Application.MainForm.Handle) * 100) div DesignPixelsPerInch;
//
//   PageX := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);  //Printer.PageWidth;
//   PageY := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT); //Printer.PageHeight;

(*  //20170127 Igor
   If Printer.Orientation = poLandscape then
   begin
   //20160115 Igor
     PageX:=Round(PageX * 2/3);  //3/4 dot not go wide enough //20160901 Igor
//     PageX:=Round(PageX * 3/4); //20160901 Igor
     //PageY:=Round(PageY * 4/3);
//     PageY:=Round(PageY * 2); //20160901 Igor
   end;
*)
//   xExtraDPIAdjustment := 0;
//   yExtraDPIAdjustment := 60;
//
//   //20130326
//   //y-y1=m(X-X1)
//   //use linear equaution y = mx + b
//
//   //x
//   if dpiAdjustment > 125 then //doesnt need adjust at 125 and possibly higher
//        xExtraDPIAdjustment := trunc( (-2.20 * dpiAdjustment) + 220.00); //-110;
//
//   //y
//   if dpiAdjustment >= 125 then
//   begin
//        yExtraDPIAdjustment := trunc( (-8.70*dpiAdjustment) + 930.00); //-375;
//        if Printer.Orientation = poLandscape then
//        begin
//                yExtraDPIAdjustment := yExtraDPIAdjustment * 3 div 4;
//        end
//        else
//        begin
//                if formPagebreakHeight < 1200 then
//                        formPagebreakHeight := 1200; //try yo fix forms that are too short
//        end;
//
//   end;

//  //20170127 Igor >>>
//  If Printer.Orientation = poLandscape then
//    ScaleX := (PageX * ScMult) div ( ( (MxFrmHeight + xExtraDPIAdjustment) * dpiAdjustment ) div 100)
//  else
//  //20170127 Igor <<<
//    ScaleX := (PageX * ScMult) div ( ( (MxFrmWidth + xExtraDPIAdjustment) * dpiAdjustment ) div 100); //to get the decimals
//   ScaleY := (PageY * ScMult) div (((formPagebreakHeight + yExtraDPIAdjustment) * dpiAdjustment) div 100); //to get the decimals
   {
   if formNumPages > 1 then
     ScaleY := (PageY * ScMult) div (((formPagebreakHeight + yExtraDPIAdjustment) * dpiAdjustment) div 100) //to get the decimals
   else
     ScaleY := (PageY * ScMult) div (((GetFormHeight(Fname) + yExtraDPIAdjustment) * dpiAdjustment) div 100); //to get the decimals
   }

 //20170212 Igor<<<
   If LicenseLevel = llDemo then //demo
     PrintAtAngle('For Demo Purposes Only',ACanvas, 200,Printer.PageHeight div 2-100,30,100);

   //20251217
  if isDraft then
    PrintAtAngle('DRAFT - Not for filing',ACanvas, 200,Printer.PageHeight div 2-100,50,50); //20242312

  (*
  //20140101
  If GetFormType(FName)='PA' then
   ShowMessage('Please avoid printing/filing T5013 forms)'
   +Chr(13)+'We are waiting completion of CRA review');
  *)
  // PrintAtAngle('D R A F T',ACanvas, 200,Printer.PageHeight div 2-100,80,100);

  {Print Form Header}
  ACanvas.Font.size := 8;
  ACanvas.Brush.Color:=clWhite;
  {remove switches later}

  {Print Header}
   If (OptRec.Prn_NameH) and (IsShowHdrIndicator(FName)) then
     ACanvas.TextOut(ScalePrX(10),ScalePrY(0),GetRetName(RetNo)+Space(5)+'Y/E '+GetYearEnd(RetNo));
   If (OptRec.Prn_DateH) and (IsShowHdrIndicator(FName)) then
     ACanvas.TextOut(
       ScalePrX(270),ScalePrY(0), ' Date Printed: '+DateToMonthDayYear(Date));
   {
   If ShowFieldIdSw then
       ACanvas.TextOut(ScalePrX(400),ScalePrY(0), FName)
   else
       If (OptRec.Prn_SinH) and (IsShowHdrIndicator(FName)) then
         ACanvas.TextOut(ScalePrX(520),ScalePrY(0), ' BN: '
             + GetCorpBusNo(RetNo));
   }
   If ShowFieldIdSw then ACanvas.TextOut(ScalePrX(400),ScalePrY(0), FName);



   If ((OptRec.Prn_NameH)
   or (OptRec.Prn_DateH)
   or (OptRec.Prn_SinH))
   and IsShowHdrIndicator(FName) then
   begin
    ACanvas.MoveTo(ScalePrX(10), ScalePrY(12)); //20170212 Igor
    ACanvas.LineTo(ScalePrX(600), ScalePrY(12)) //20170212 Igor
   end;
   PrintControls(AForm, 0, 0); //20160407 Igor
//20160901 Igor>>>
//   If FastPrint=True then
//   begin
//    Printer.NewPage;
//   end;
//
//   If FastPrint=False then
//   begin
//    Printer.EndDoc;
//   end;
  If FastPrint then
    NeedNewPage := True
  else
    Printer.EndDoc;
//20160901 Igor<<<
End;


Procedure PausePrinting;
begin
  ShowMessage('Temporary pause..'+Chr(13)+
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
    MoveTo(Round(x1 * ScaleX){ div ScMult},Round(y1 * ScaleY){ Div ScMult});
    If h <3 then LineTo(Round((x1+w)* ScaleX){ Div ScMult}, Round(Y1* ScaleY){ Div ScMult})
     else LineTo(Round(x1 * ScaleX){ div ScMult},Round((y1+h)*ScaleY){ Div ScMult});
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
Procedure AfterReadComponentForPrint(AForm:TForm;FName:String);
Var i:Integer;AImage:TImage;
  prnL, prnR : real; //201602110 Igor
  iCode: Integer;    //20160210 Igor
CONST
  pxl = 96; //20160204 Igor
begin

   for i := 0 to AForm.ComponentCount - 1 do
   begin
      If aForm.Components[i] is TvtLabel then
      begin
         If (aForm.Components[i] as TvtLabel).font.name = 'Wingdings' then
         begin
            //send to back so prints on top of other label
            (aForm.Components[i] as TvtLabel).sendtoback;
         end;
      end;
   end;



   AImage:=Nil;
   If IsFormAClientLetter(FName) then
   begin
     //get the image
     for i := 0 to AForm.ComponentCount - 1 do
     begin
      If aForm.Components[i] is TImage then
      begin
         If UpperCase((aForm.Components[i] as TImage).Name) = 'LOGOIMAGE' then
         begin
           AImage:=AForm.Components[i] as TImage;
         end;
      end;
      If aForm.Components[i] is TPanel then
       (aForm.Components[i] as TPanel).Visible:=False;

      If (aForm.Components[i] is TRichEdit) AND //20160819 Igor
         ((aForm.Components[i] as TRichEdit).align = alClient) then //20160819 Igor
      Begin
        with TRichEdit(aForm.Components[i]) do //20160819 Igor
        Begin
          Align := alNone;

          SetBounds(ROUND(MainOptions.Prn_LMargin*pxl),Top,
            Width - ROUND(MainOptions.Prn_LMargin*pxl) - ROUND(MainOptions.Prn_RMargin*pxl),Height);
        end;
      end;

     end;
   end;
end;

{$IFDEF single}
Procedure PrintLabel(MyLabel:TvtLabel;ACanvas:TCanvas);
var
 R:TRect;
 tempPos,AlignTopBottomVar:integer;
 thisCaption:String;
begin

      ACanvas.Font.Name := DefFontName;
      ACanvas.Font.Size := MyLabel.Font.Size +MyStrToInt(OptRec.Prn_FontIncr);
      ACanvas.Font.Style := MyLabel.Font.Style;

    (*
     //temp change to print black boxes extended  //20120216
      If MyLabel.color = clblack then
      Begin
      if ((MyLabel.width >22) and (MyLabel.width <=30))
      or (MyLabel.width =30)
      or (MyLabel.Caption ='101')
      then
      begin
        MyLabel.width := MyLabel.Width+10; //40;
        MyLabel.AutoSize := false;
        MyLabel.vtBorderType := vtlblfull;
        MyLabel.Alignment := taLeftJustify;
        MyLabel.sendtoback;
      end;
      end;
     *)
      R.Left   := MyLabel.Left;
      R.Top    := MyLabel.Top;
      R.Right  := MyLabel.Left + MyLabel.Width;
      R.Bottom := MyLabel.Top + MyLabel.Height;
      //R := ScalePrBox(R);

      thisCaption := MyLabel.Caption;

      if MyLabel.Transparent = false then
      begin
        if MyLabel.Color = clWhite then
        begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsClear;
        end
        else if MyLabel.Color = clBlack then
        begin
          ACanvas.Font.Color := clWhite;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := clBlack;
        end
        else
        begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := PrintShade; //RGB(245,245,245);//clSilver;
        end;
      end
      else
      begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsClear;
      end;

      if MyLabel.vtBorderType = vtlblUnderline then
      begin
        ACanvas.Pen.Width := 1;
        ACanvas.Pen.Color := clBlack;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom)  - 1 , ScalePrX(R.Right), ScalePrY(R.Bottom));
      end
      else if MyLabel.vtBorderType = vtlblFull then
      begin
        ACanvas.Pen.Width := 1;
        ACanvas.Pen.Color := clBlack;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom), ScalePrX(R.Right), ScalePrY(R.Top));
      end;

     if MyLabel.Layout = tlTop then
        AlignTopBottomVar := ScalePrY(R.Top + 1)
      else if MyLabel.Layout = tlCenter then
      begin
        tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
        AlignTopBottomVar := ScalePrY(R.Top) + tempPos - (ACanvas.TextHeight(thisCaption) div 2);
      end
      else if MyLabel.Layout = tlBottom then
      begin
        AlignTopBottomVar := ScalePrY(R.Bottom) - ACanvas.TextHeight(thisCaption);
      end;

      if MyLabel.Alignment = taLeftJustify then
      begin
        ACanvas.Textout(ScalePrX(R.Left),AlignTopBottomVar,thisCaption);
      end
      else if MyLabel.Alignment = taRightJustify then
      begin
        ACanvas.Textout(ScalePrX(R.Right) - ACanvas.TextWidth(thisCaption) , AlignTopBottomVar , thisCaption)
      end
      else if MyLabel.Alignment = taCenter then
      begin
        tempPos := ((ScalePrX(R.Right) - ScalePrX(R.Left)) - ACanvas.TextWidth(thisCaption)) div 2;
        ACanvas.Textout(ScalePrX(R.Left) + tempPos , AlignTopBottomVar,thisCaption)
      end;
end;
{$ELSE}
{$ENDIF}

Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String;
  FNo: Integer; hdc: THandle; ACanvas:TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0; AisSynPDF: Boolean = False); //20180503 Igor
Var FieldId:Integer; R:TRect;aString,s:String;FormattedAmount : string;
x,y:LongInt; PenWidth:Integer;AlignTopBottomVar,tempPos:Integer; MyEditHandle:THandle;
HowToFormat:Integer;
nPrintTextHeight: integer; //20180126 Igor
//20180221 Igor >>>
WrapTextRect: TRect;
DrawStyle: Word;
//20180221 Igor <<<

Begin
  FieldId:=GetFieldId(MyEditBox.Name);

  //if FieldId = 71 then
  //  showmessage('vtEdit71');
  //20180503 Igor >>>
  if not AisSynPdf then
    ACanvas.Font.Size := MyEditBox.Font.Size +MainOptions.Prn_FontIncr
  else
    ACanvas.Font.Size := Round(Abs(MyEditBox.Font.Height) *72/96) + MainOptions.Prn_FontIncr;
  //20180503 Igor <<<
  If leftStr(Fname,1)='O' then ACanvas.Font.Size:=ACanvas.Font.Size+1;
  ACanvas.Font.Color := MyEditBox.Font.Color;
  ACanvas.Font.Style := MyEditBox.Font.Style;
  R.Left   := MyEditBox.Left + ADLeft;
  R.Top    := MyEditBox.Top + ADTop;
  R.Right  := MyEditBox.Left + ADLeft + MyEditBox.Width;
  R.Bottom := MyEditBox.Top + ADTop + MyEditBox.Height;


  //If LeftStr(Fname,5)='T4SUM' then  ACanvas.Font.Name := 'Courier New' else
  ACanvas.Font.Name := DefFontName;
  ACanvas.Brush.Style := bsClear;

  If PauseSw then PausePrinting;

  If ShowFieldIdSw then
  begin
       if MyEditBox.vtInputType = vtDollar then
         Astring := '['+IntToStr(FieldId)+'n]'
       else
         Astring := '['+IntToStr(FieldId)+']';

       If (MyEditBox.Visible) or
        (ShowFieldIdSw =True)  then
          ACanvas.Textout(
                    ScalePrX(MyEditBox.Left + ADLeft),
                    ScalePrY(MyEditBox.Top + ADTop + 2),
                    Astring);
  end
  else
  begin
        with MyEditBox do
        Begin
                //fill the editbox with color--------------------------------
                if MyEditBox.Color <> clwhite then
                begin
                 ACanvas.Pen.Width := 0;
                 ACanvas.Pen.Style := psClear;
                 ACanvas.Brush.Style := bsSolid;
                 ACanvas.Brush.Color := PrintShade; //RGB(238,238,238); //MyEditBox.Color;
                 ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top),ScalePrX(R.Right),ScalePrY(R.Bottom));
                end;
                //fill the editbox withcolor---------------------------------
                If GetFormType(Fname)='PA' then
                begin
                 If ((LeftStr(Fname,6) <> 'T5013#') and (LeftStr(Fname,7) <> 'T5013A#')) then
                  vtShadedDec:=False;  //20120306

                end;
                if vtShadedDec = True then
                begin
                    ACanvas.Pen.Width := 0;
                    ACanvas.Pen.Style := psClear;
                    ACanvas.Brush.Style := bsSolid;
                    ACanvas.Brush.Color := PrintShade;
                    ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') -1 , ScalePrY(R.Top+1),ScalePrX(R.Right),ScalePrY(R.Bottom));
                end;



                //ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                ACanvas.Brush.Style := bsClear;
                ACanvas.Pen.Style := psSolid;
                ACanvas.Pen.Color := clBlack;
                if vtInputType = vtDollar then
                begin
                        HowToFormat :=GetHowToFormat(FName,FieldId);
                        Text := FormatAmount(FName,Ret[RetNo].Frm[FNo].Strings[FieldId],HowToFormat);
                        if leftstr(Text,2) = '0 'then Text := ' ' + midstr(Text, 3, 20);
                        if Vl(Text) = 0 then
                        begin
                          Text := '';
                        end
                        else //not if Text=''
                        if leftstr(text,1) = ' ' then text := '0' + text;  //2005 to retain space and 0.78

                end
                else if vtInputType = vtSin then
                    Text := reFormatSin(Ret[RetNo].Frm[FNo].Strings[FieldId])
                else
                    Text := Ret[RetNo].Frm[FNo].Strings[FieldId];


                If CertificationMode then
                  Text := adjustForCertif(Text,FName,FieldId);

                //20180221 Igor >>>
                if vtWordWrap then
                begin
                  WrapTextRect.Left := 0;
                  WrapTextRect.Top := 0;
                  WrapTextRect.Right := ScalePrX(R.Right) - ScalePrX(R.Left);
                  WrapTextRect.Bottom := 0;

                  DrawText(ACanvas.Handle, PChar(Text), Length(Text), WrapTextRect, DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
                  nPrintTextHeight := WrapTextRect.Bottom - WrapTextRect.Top;
                  if nPrintTextHeight = 0 then
                    nPrintTextHeight := ACanvas.TextHeight('0');

                  if vtLayout = vtTop then
                  begin
                    WrapTextRect.Top := ScalePrY(R.Top);
                    WrapTextRect.Bottom := WrapTextRect.Top + nPrintTextHeight;
                  end
                  else
                  if vtLayout = vtMiddle then
                  begin
                    tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
                    WrapTextRect.Top := ScalePrY(R.Top) + tempPos - (nPrintTextHeight div 2);
                    WrapTextRect.Bottom := WrapTextRect.Top + nPrintTextHeight;
                  end
                  else
                  if vtLayout = vtBottom then
                  begin
                    WrapTextRect.Bottom := ScalePrY(R.Bottom);
                    WrapTextRect.Top := WrapTextRect.Bottom - nPrintTextHeight;
                  end;

                  WrapTextRect.Left := ScalePrX(R.Left);
                  WrapTextRect.Right := ScalePrX(R.Right);

                  if vtAlignment = taLeftJustify then
                    DrawStyle := DT_LEFT or DT_WORDBREAK
                  else if vtAlignment = taRightJustify then
                    DrawStyle := DT_RIGHT or DT_WORDBREAK
                  else if vtAlignment = taCenter then
                    DrawStyle := DT_CENTER or DT_WORDBREAK;
                  DrawText(ACanvas.Handle, PChar(Text), Length(Text), WrapTextRect, DrawStyle);
                end
                else
                begin
                  //20180126 Igor >>>
                  nPrintTextHeight := ACanvas.TextHeight(Text);
                  if nPrintTextHeight = 0 then
                    nPrintTextHeight := ACanvas.TextHeight('0');

                  if vtLayout = vtTop then
                         AlignTopBottomVar := ScalePrY(R.Top + 1)
                  else if vtLayout = vtMiddle then
                  begin
                          tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
                          AlignTopBottomVar := ScalePrY(R.Top) + tempPos - (nPrintTextHeight div 2);
                  end
                  else if vtLayout = vtBottom then
                  begin
                         AlignTopBottomVar := ScalePrY(R.Bottom) - nPrintTextHeight;
                  end;
                  //20180126 Igor <<<

                 (*
                  if vtLayout = vtTop then
                         AlignTopBottomVar := ScalePrY(R.Top + 1)
                  else if vtLayout = vtMiddle then
                  begin
                          tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
                          AlignTopBottomVar := ScalePrY(R.Top) + tempPos - (ACanvas.TextHeight(Text) div 2);
                  end
                  else if vtLayout = vtBottom then
                  begin
                         AlignTopBottomVar := ScalePrY(R.Bottom) - ACanvas.TextHeight(Text);
                  end;
                  *)
                  if vtAlignment = taLeftJustify then
                  begin
                         ACanvas.Textout(ScalePrX(R.Left) + 2,AlignTopBottomVar,Text);
                  end
                  else if vtAlignment = taRightJustify then
                  begin
                         ACanvas.Textout(ScalePrX(R.Right) - ACanvas.TextWidth(Text) - 3,AlignTopBottomVar,Text)
                  end
                  else if vtAlignment = taCenter then
                  begin
                         tempPos := ((ScalePrX(R.Right) - ScalePrX(R.Left)) - ACanvas.TextWidth(Text)) div 2;
                         ACanvas.Textout(ScalePrX(R.Left) + tempPos , AlignTopBottomVar,Text)
                  end;
                end;
                //20180221 Igor <<<

                //add vertSeporator and paint prefix if vtDollar or vtString
                if (vtinputType = vtDollar) or (vtinputType = vtString) then
                begin
                       if vtPrefix > '' then
                        ACanvas.Textout(ScalePrX(R.Left),ScalePrY(R.bottom) - ACanvas.TextHeight(vtPrefix),vtPrefix);

                       if vtVertSeparator = True then
                       begin
                          ACanvas.Pen.Width := 1;
                          ACanvas.Pen.Style := psSolid;
                          ACanvas.Brush.Style := bsClear;

                          if vtBorderType = vtDoubleUnderLine then
                          begin
                                ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00')-1, ScalePrY(R.Top) , ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2 , ScalePrY(R.Bottom) - 3);
                          end
                          else
                          begin
                                ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00')-1, ScalePrY(R.Top) , ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2 , ScalePrY(R.Bottom));
                          end;
                       end;
                end;

                if MyEditBox.vtBorderType = vtNoBorder then
                begin
                        //
                end
                else if MyEditBox.vtBorderType = vtFull then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness * 2;
                     ACanvas.Brush.Style := bsClear;

                     ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right),ScalePrY(R.Bottom));
                end
                else if MyEditBox.vtBorderType = vtsides then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     ACanvas.Rectangle(ScalePrX(R.Left)      , ScalePrY(R.Top)   , ScalePrX(R.Left)+ 1  , ScalePrY(R.Bottom)); //R.Left, R.Top, R.Left + 1, R.Bottom);
                     ACanvas.Rectangle(ScalePrX(R.Left)      , ScalePrY(R.Bottom), ScalePrX(R.Right)    , ScalePrY(R.Bottom) - 1); //R.Left, R.Bottom, R.Right, R.Bottom - 1);
                     ACanvas.Rectangle(ScalePrX(R.Right) - 1 , ScalePrY(R.Top)   , ScalePrX(R.Right)    , ScalePrY(R.Bottom));     //R.Right - 1, R.Top, R.Right, R.Bottom);
                     //ACanvas.Rectangle(0, -5, 0 + MyEditBox.Width , 0 + MyEditBox.Height);
                end
                else if MyEditBox.vtBorderType = vtUnderline then
                begin
                     ACanvas.Pen.Width := 1;
                     ACanvas.Pen.Mode := pmCopy;
                     ACanvas.Pen.Color := clBlack;
                     ACanvas.Brush.Color := clBlack;
                     ACanvas.Brush.Style := bsSolid;

                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) + 1, ScalePrX(R.Right) , ScalePrY(R.Bottom) + 2 + MyEditBox.vtPenThickness);
{
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) - 1 , ScalePrX(R.Right) , ScalePrY(R.Bottom));
}
                end
                else if MyEditBox.vtBorderType = vtDoubleUnderLine then
                begin
{
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) - 1  , ScalePrX(R.Right) , ScalePrY(R.Bottom));
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom)  - 3 , ScalePrX(R.Right) , ScalePrY(R.Bottom) - 2);
}
                     ACanvas.Pen.Width := 1;
                     ACanvas.Pen.Mode := pmCopy;
                     ACanvas.Pen.Color := clBlack;
                     ACanvas.Brush.Color := clBlack;
                     ACanvas.Brush.Style := bsSolid;

                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) + 1, ScalePrX(R.Right) , ScalePrY(R.Bottom) + 2 + MyEditBox.vtPenThickness);
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) + 10, ScalePrX(R.Right) , ScalePrY(R.Bottom) + 11 + MyEditBox.vtPenThickness);
                 end
                else if MyEditBox.vtBorderType = vtTopBottomLine then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) -1 , ScalePrX(R.Right) , ScalePrY(R.Bottom));
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Top) + 1   , ScalePrX(R.Right) , ScalePrY(R.Top));
                end;
        end; //with MyEditBox
  end;  //else

  If ReviewOn(RetNo,FNo,FieldId) then
  begin
     DrawingTool := dtEllipse; PenWidth := 3;
     ACanvas.Brush.Style := bsClear;
     DrawShape(Point(ScalePrX(R.Left-7), ScalePrY(R.Top-5)),
     Point(ScalePrX(R.Right+7),ScalePrY(R.Bottom+7)),PenWidth,ACanvas);
  end;

  ACanvas.Font.Style := [];
end;

{$IFDEF single}

Procedure PrintMemo(RetNo:Integer;AMemo:TMemo;ACanvas:TCanvas);
Var i:Integer;ARichEdit:TRichEdit;
begin
 ARichEdit:=TRichEdit.Create(Application);
 ARichEdit.Parent:=MainFormTF;
 ARichEdit.Top:=AMemo.Top;
 ARichEdit.Left:=AMemo.Left;
 ARichEdit.PlainText:=True;
 //needs more as it prints in blue.... font info
 For i:=0 to AMemo.lines.count-1 do
 begin
  ARichEdit.Lines.Add(AMemo.Lines[i]);
  // ACanvas.Textout(ScalePrX(MyEditBox.Left),ScalePrY(MyEditBox.Top+2),AMemo.Lines[i]);
 end;
 PrintRichEdit(RetNo,ARichEdit,ACanvas);
 ARichEdit.Free;
end;

Procedure PrintVtShape(MyVtShape:TVtShape;ACanvas:TCanvas);
Var FieldId:Integer; R:TRect;aString,s:String;FormattedAmount : string;
x,y:LongInt; PenWidth,Edge:Integer;

   poly: array[0..2] of TPoint;
   i:integer;
   w2,w3,w4,w8,w16,h2,h3,h4,h8,h16,xw,yh:integer;


begin
     If PauseSw then PausePrinting;

     if MyVtShape.Pen.Width >= 2 then
       ACanvas.Pen.Width := MyVtShape.Pen.Width * 5 //*5 to make show more bold in printing
     else
       ACanvas.Pen.Width := MyVtShape.Pen.Width;

     ACanvas.Pen.Color   := MyVtShape.Pen.Color;
     ACanvas.Brush.Color := MyVtShape.Brush.Color; //clWhite; {Self.Color;}
     ACanvas.Brush.Style := MyVtShape.Brush.Style; //bsClear;
     R.Left   := MyVtShape.Left;
     R.Top    := MyVtShape.Top;
     R.Right  := MyVtShape.Left + MyVtShape.Width;
     R.Bottom := MyVtShape.Top + MyVtShape.Height;
     //R := ScalePrBox(R);


    (*
     //temp change to print certain black circles as white  //20120216
     if ( MyVtShape.Shape = vtRectangle) and ( (MyVtShape.height = 4) and (MyVtShape.width = 4 ) ) then
     begin
        MyVtShape.Brush.Style := bsSolid;
        MyVtShape.Brush.Color := clWhite;
        MyVtShape.Top := MyVtShape.Top - 10;  //5
        MyVtShape.bringtoFront;

     end;

     if (MyVtShape.Shape = vtCircle) and ( (MyVtShape.height = 4) and (MyVtShape.width = 4 ) ) then
     begin
        MyVtShape.Width:=3;      //20120216
        MyVtShape.Brush.Style := bsSolid;
        MyVtShape.Brush.Color := clWhite;
        MyVtShape.Top := MyVtShape.Top - 10;  //5
        MyVtShape.bringtoFront;
     end;
   *)

   //20120216
    if (MyVtShape.Shape = vtCircle) and ( (MyVtShape.height = 4) and (MyVtShape.width = 4 ) ) then
     begin
        MyVtShape.Width:=3;      //20120216
     end;

{
      if MyVtShape.Brush.Style = bsSolid then
      begin
        if MyVtShape.Brush.Color = clWhite then
        begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsClear;
        end
        else if MyVtShape.Brush.Color = clBlack then
        begin
          ACanvas.Font.Color := clWhite;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := clBlack;
        end
        else
        begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := PrintShade; //RGB(245,245,245); //clSilver;
        end;
      end
      else
      begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsClear;
      end;
}
     if MyVtShape.Width < MyVtShape.Height then Edge := MyVtShape.Width else Edge := MyVtShape.Height;

     if MyVtShape.Brush.Style = bsSolid then
     begin
        if MyVtShape.Brush.Color = clWhite then
        begin
          ACanvas.Font.Color := clBlack;
          //ACanvas.Brush.Style := bsClear; //clear does not 'paint' over black
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := clWhite;

        end
        else if MyVtShape.Brush.Color = clBlack then
        begin
          ACanvas.Font.Color := clWhite;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := clBlack;
        end
        else
        begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := PrintShade; //RGB(245,245,245); //clSilver;
        end;
      end
      else
      begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsClear;
      end;

      //20130202
      //for over blackbox
      if  MyVtShape.Pen.Color = clWhite then
      begin
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := clWhite;
          ACanvas.Pen.Color := clWhite;
      end;


     case MyVtShape.Shape of
       vtRectangle, vtSquare: ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom));
       vtRoundRect, vtRoundSquare: ACanvas.RoundRect(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom), Edge div 4, Edge div 4);
       vtCircle, vtEllipse: ACanvas.Ellipse(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom));
       vtTriangleRight,vtTriangleleft,vtTriangleUp,vtTriangleDown: DrawTriangle(MyVtShape,ACanvas,R);
       vtArrowRight,vtArrowLeft,vtArrowDown,vtArrowUp: DrawArrow(MyVtShape,ACanvas,R);
       vtDiamond: DrawOthers(MyVtShape,ACanvas,R);
       vtOctagon: DrawOthers(MyVtShape,ACanvas,R);
       vtHexagon,vtHexagonFlat: DrawOthers(MyVtShape,ACanvas,R);  //DrawHexagon;
       vtUBarUp,vtUBarDown,vtUBarRight,vtUBarLeft: DrawOthers(MyVtShape,ACanvas,R);  //DrawUBar;
       vtWaggle: DrawOthers(MyVtShape,ACanvas,R);  //DrawWaggle;
       vtCloudLeft,vtCloudRight: DrawOthers(MyVtShape,ACanvas,R);  //DrawCloud;
     end;
end;

Procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
  VAR
    BitmapHeader:  pBitmapInfo;
    BitmapImage :  POINTER;
    HeaderSize  :  DWORD;    // Use DWORD for D3-D5 compatibility
    ImageSize   :  DWORD;
BEGIN
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  TRY
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_COLORS,
                  SRCCOPY)
  FINALLY
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  END
END {PrintBitmap};
{$ELSE}
{$ENDIF}

Procedure PrintImage(RetNo:Integer;AImage:TImage;hdc:THandle;ACanvas:TCanvas);
Var R:TRect;
begin
  If PauseSw then PausePrinting;
  R.Left:=ScalePrX(AImage.Left);
  R.Top:=ScalePrY(AImage.Top);
  R.Right:=ScalePrX(AImage.Left+AImage.Width);
  R.Bottom:=ScalePrY(AImage.Top+AImage.Height);

  If UpperCase(AImage.Name) = 'LOGOIMAGE' then
  begin
   //AImage.Picture.Tranparent:=False;
   //AImage.Autosize:=True;
   //AImage.Stretch:=False;
   R.Left:=ScalePrX(AImage.Left);
   R.Top:=ScalePrY(AImage.Top);
   R.Right:=AImage.Left+ScalePrx(AImage.Picture.Width);
   R.Bottom:=AImage.Top+ScalePrY(AImage.Picture.Height);
   ACanvas.StretchDraw(R,AImage.Picture.Graphic);
   //ACanvas.Draw(R.Left,R.Top,AImage.Picture.Graphic);
  end
  else
   ACanvas.StretchDraw(R,AImage.Picture.Graphic);
end;

Procedure PrintBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; BarCodeImage1:TImage; BarCodeImage2:TImage);
var
 PixelsPerInch: TPoint;
 Ht,Wt:Real;
 d:integer;
 BarCodeBmp:TBitMap;
 R:TRect;
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

Procedure PrintSFDBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; SFDBarCodeImage1:TImage; SFDBarCodeImage2:TImage);
var
 PixelsPerInch: TPoint;
 Ht,Wt:Real;
 i,d:integer;
 BarCodeBmp:TBitMap;
 R:TRect;
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


Procedure PrintRichEdit(RetNo:Integer;ARichEdit:TRichEdit;ACanvas:TCanvas);
// 1440 = 1 inch
 //keeps track of each page where to start, end and rect of printing
 Type
  TPageOffset = Record
  mStart : LongInt;
  mEnd   : LongInt;
  rendRect : TRECT;
 end;

var
  wPage, hPage, xPPI, yPPI, wTwips, hTwips: integer;
  pageRect, rendRect: TRect;
  po: TPageOffset;
  fr: TFormatRange;
  lastOffset, currPage, pageCount: integer;
  xOffset, yOffset: integer;
  FPageOffsets: array of TPageOffset;
  TextLenEx: TGetTextLengthEx;
  firstPage: boolean;

  //Mine
  XPos,YPos:Integer; //rich edit position
  ImageCanvas:TCanvas;

  dpiPercent,dpiAdjust:integer;
begin
  //First, get the size of a printed page in printer device units
  wPage := GetDeviceCaps(ACanvas.Handle, PHYSICALWIDTH);
  hPage := GetDeviceCaps(ACanvas.Handle, PHYSICALHEIGHT);

  //adjust for dpi //20130315
  dpiPercent := ( GetWindowsFontSize(MainForm.Handle) * 100) div DesignPixelsPerInch;
  if dpiPercent >= 150 then dpiAdjust := 122
  else if dpiPercent >= 125 then dpiAdjust := 121
  else if dpiPercent >= 104 then dpiAdjust := (4*dpiPercent)-377
  else dpiAdjust := 0;

  //Next, get the device units per inch for the printer
  xPPI := GetDeviceCaps(ACanvas.Handle, LOGPIXELSX){ - dpiAdjust};
  yPPI := GetDeviceCaps(ACanvas.Handle, LOGPIXELSY);
  //mine
  XPos:=ScalePrX(ARichEdit.Left);  //x whre to start the richedit
  YPos:=ScalePrY(ARichEdit.Top);   //y whre to top richedit
  ImageCanvas := ACanvas; //Printer.Canvas;
  //Convert the page size from device units to twips
  wTwips := {Trunc(WPage * 1440 div xPPI); //}MulDiv(wPage, 1440, xPPI);
  hTwips := {Trunc(HPage * 1440 div yPPI); //}MulDiv(hPage, 1440, yPPI);
  //Save the page size in twips
  with pageRect do
  begin
    Left := 0;
    Top := 0;
    Right := wTwips;
    Bottom := hTwips;
  end;
  //Next, calculate the size of the rendering rectangle in twips
  with rendRect do //tpoint
  begin
    // mine
    //Left:=Trunc(XPos * 1440 div xPPI)+(1440 div 2); //add half inch
    Left:=Trunc(XPos * 1440 div xPPI)+1440 * Round(MainOptions.Prn_LMargin); //add full inch
    Top:= Trunc(YPos * 1440 div yPPI);
    //Right:=Trunc((XPos+(ScalePrX(ARichEdit.Width))) * 1440 div xPPI)-(1440 div 2); //less half inch
    Right:=Trunc((XPos+(ScalePrX(ARichEdit.Width))) * 1440 div xPPI)-1440 * Round(MainOptions.Prn_RMargin); //less full inch
    Bottom:=PageRect.Bottom - Round(1440 * 0.50);
    // ---
    //Rememeber - two inch margins are hardcoded, so the below code
    //reduces the width of the output by four inches
    //Top := 0;
    //Left := 0;
    //Right := pageRect.Right - (1440 * 4);
    //Bottom := pageRect.Bottom - (1440 * 4);
  end;
  //Define a single page and set starting offset to zero
  po.mStart := 0;
  //Define and initialize a TFormatRange structure. This structure is passed
  //to the TRichEdit with a request to format as much text as will fit on a
  //page starting with the chrg.cpMin offset and ending with the chrg.cpMax.
  //Initially, we tell the RichEdit control to start at the beginning
  //(cpMin = 0) and print as much as possible (cpMax = -1). We also tell it
  //to render to the printer
  with fr do
  begin
    hdc := ACanvas.Handle;
    hdcTarget  := ACanvas.Handle;
    chrg.cpMin := po.mStart;
    chrg.cpMax := -1;
  end;
  //In order to recognize when the last page is rendered, we need to know how
  //much text is in the control.

  with TextLenEx do
  begin
      flags := GTL_DEFAULT;
      codepage := CP_ACP;
  end;
  lastOffset := SendMessage(ARichEdit.Handle, EM_GETTEXTLENGTHEX, wParam(@TextLenEx), 0);
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
  //As a precaution, clear the formatting buffer
  SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  //Printers frequently cannot print at the absolute top-left position on the
  //page. In other words, there is usually a minimum margin on each edge of the
  //page. When rendering to the printer, RichEdit controls adjust the top-left
  //corner of the rendering rectangle for the amount of the page that is
  //unprintable. Since we are printing with two-inch margins, we are presumably
  //already within the printable portion of the physical page.
  SaveDC(fr.hdc);
  SetMapMode(fr.hdc, MM_TEXT);

  { me
  xOffset := GetDeviceCaps(ACanvas.Handle, PHYSICALOFFSETX);
  yOffset := GetDeviceCaps(ACanvas.Handle, PHYSICALOFFSETY);
  xOffset := MulDiv(1440 + 1440, xPPI, 1440);
  yOffset := MulDiv(1440 + 1440, yPPI, 1440);
  SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);
  }
  //build a table of page entries, one entry for each page that would be printed.
  while ((fr.chrg.cpMin <> -1) and (fr.chrg.cpMin < lastOffset)) do
  begin
    If High(FPageOffsets) <> -1 then //not first page  MINE
     RendRect.Top:=0; //causes second page to start from top
    fr.rc := rendRect;
    fr.rcPage := pageRect;
    po.mStart := fr.chrg.cpMin;
    fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, Longint(@fr));
    po.mEnd := fr.chrg.cpMin - 1;
    po.rendRect := fr.rc;
    if High(FPageOffsets) = -1 then SetLength(FPageOffsets, 1)
    else
      SetLength(FPageOffsets, Length(FPageOffsets) + 1);   //dynamic array
    FPageOffsets[High(FPageOffsets)] := po;   //po is the page offset record
  end;

  pageCount := Length(FPageOffsets);
  SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  //ME
 // RestoreDC(fr.hdc, - 1);
 //Now, we are almost ready to actually print.
 // Printer.BeginDoc;

  fr.hdc := ACanvas.Handle;
  fr.hdcTarget := ACanvas.Handle;
  //ME
  // SaveDC(fr.hdc);
  //SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);

  //here we print
  firstPage := True;
  CurrPage:=0;
  while (currPage < pageCount) do
  begin
    If FirstPage then
      FirstPage:=False
    else
     Printer.NewPage;
    // SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);  //me
    fr.rc := FPageOffsets[currPage].rendRect;
    fr.rcPage := pageRect;
    fr.chrg.cpMin := FPageOffsets[currPage].mStart;
    fr.chrg.cpMax := FPageOffsets[currPage].mEnd;
    fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 1, Longint(@fr));
    Inc(currPage);
  end;

  //At this point, we have finished rendering the contents of the RichEdit
  //control. Now we restore the printer's HDC settings and tell Windows that
  //we are through printing this document
//  RestoreDC(fr.hdc, - 1);  //me
//  Printer.EndDoc;
  //Finally, we clear the RichEdit control's formatting buffer and delete
  //the saved page table information
 // fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  Finalize(FPageOffsets); //de-allocates memory
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

procedure DrawShape(TopLeft, BottomRight: TPoint; PenWidth: Integer;ACanvas:TCanvas);
begin
  with ACanvas do
  begin
    {Pen.Mode := AMode;}
    Pen.Width := PenWidth;
    case DrawingTool of
      dtLine: begin
                MoveTo(TopLeft.X, TopLeft.Y);
                LineTo(BottomRight.X, BottomRight.Y);
              end;
      dtRectangle: Rectangle(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y);
      dtEllipse: Ellipse(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y);
      dtRoundRect: RoundRect(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y,
        (TopLeft.X - BottomRight.X) div 2, (TopLeft.Y - BottomRight.Y) div 2);
    end;
  end;
  ACanvas.Pen.Width := 1;  {back to Default}
end;

procedure DrawTriangle(MyVtShape:TVtShape;ACanvas:TCanvas;R:TRect);
var
   poly: array[0..2] of TPoint;
   rpoly: array[0..2] of TPoint;
   i:integer;
   w2,w3,w4,w8,w16,h2,h3,h4,h8,h16,xw,yh:integer;
begin
     w2 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 2;
     w3 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 3;
     w4 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 4;
     w8 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 8;
     w16:= (ScalePrX(R.Right) - ScalePrX(R.Left)) div 16;
     h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
     h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 3;
     h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 4;
     h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 8;
     h16:= (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 16;
     xw := ScalePrX(R.Left)  + (ScalePrX(R.Right) - ScalePrx(R.Left)) - 1;
     yh := ScalePrY(R.Top) + (ScalePrY(R.Bottom) - ScalePrY(R.Top)) - 1;

    case MyVtShape.Shape of
       vtTriangleRight:
       begin
        poly[0]:=point(ScalePrX(R.Left) , ScalePrY(R.Top));
        poly[1]:=point(xw               , ScalePrY(R.Top) + h2);
        poly[2]:=point(ScalePrX(R.Left) , yh);
       end;
       vtTriangleUp:
        begin
        poly[0]:=point(ScalePrX(R.Left) + w2 , ScalePrY(R.Top));
        poly[1]:=point(xw                    , yh);
        poly[2]:=point(ScalePrX(R.Left)      , yh);
        end;
       vtTriangleLeft:
        begin
        poly[0]:=point(xw                , ScalePrY(R.Top));
        poly[1]:=point(xw                , yh);
        poly[2]:=point(ScalePrX(R.Left)  , ScalePrY(R.Top)+h2);
        end;
       vtTriangleDown:
        begin
        poly[0]:=point(ScalePrX(R.Left)      , ScalePrY(R.Top));
        poly[1]:=point(xw                    , ScalePrY(R.Top));
        poly[2]:=point(ScalePrX(R.Left) + w2 , yh);
        end;
       end;
    for i := 0 to 2 do
    begin
       rpoly[i].x := R.Left+poly[i].x;
       rpoly[i].y := R.Top+poly[i].y;
    end;
   ACanvas.polygon(slice(poly,3));
end;

procedure DrawArrow(MyVtShape:TVtShape;ACanvas:TCanvas;R:TRect);
var
   poly: array[0..6] of TPoint;
   rpoly: array[0..6] of TPoint;
   i:integer;
   w,w2,w3,w4,w8,w16,h,h2,h3,h4,h8,h16,xw,yh:integer;
begin
     w  := (ScalePrX(R.Right)  - ScalePrX(R.Left));
     w2 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 2;
     w3 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 3;
     w4 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 4;
     w8 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 8;
     w16:= (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 16;
     h  := (ScalePrY(R.Bottom) - ScalePrY(R.Top));
     h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 2;
     h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 3;
     h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 4;
     h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 8;
     h16:= (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 16;
     xw := ScalePrX(R.Left)    + (ScalePrX(R.Right) - ScalePrx(R.Left)) - 1;
     yh := ScalePrY(R.Top)     + (ScalePrY(R.Bottom)- ScalePrY(R.Top)) - 1;

    case MyVtShape.Shape of
       vtArrowRight:
        begin
        poly[0]:=point(ScalePrX(R.Left),ScalePrY(R.Top)+(h div 2)-(h div 16));
        poly[1]:=point(ScalePrX(R.Left)+w-1-(w div 4),ScalePrY(R.Top)+(h div 2)-(h div 16));
        poly[2]:=point(ScalePrX(R.Left)+w-1-(w div 4),ScalePrY(R.Top));
        poly[3]:=point(ScalePrX(R.Left)+w-1,ScalePrY(R.Top)+(h div 2));
        poly[4]:=point(ScalePrX(R.Left)+w-1-(w div 4),ScalePrY(R.Top)+h-1);
        poly[5]:=point(ScalePrX(R.Left)+w-1-(w div 4),ScalePrY(R.Top)+(h div 2)+(h div 16));
        poly[6]:=point(ScalePrX(R.Left),ScalePrY(R.Top)+(h div 2)+(h div 16));
        end;
       vtArrowLeft:
        begin
        poly[0]:=point(ScalePrX(R.Left)+w-1,ScalePrY(R.Top)+(h div 2)-(h div 16));
        poly[1]:=point(ScalePrX(R.Left)+(w div 4),ScalePrY(R.Top)+(h div 2)-(h div 16));
        poly[2]:=point(ScalePrX(R.Left)+(w div 4),ScalePrY(R.Top));
        poly[3]:=point(ScalePrX(R.Left),ScalePrY(R.Top)+(h div 2));
        poly[4]:=point(ScalePrX(R.Left)+(w div 4),ScalePrY(R.Top)+h-1);
        poly[5]:=point(ScalePrX(R.Left)+(w div 4),ScalePrY(R.Top)+(h div 2)+(h div 16));
        poly[6]:=point(ScalePrX(R.Left)+w-1,ScalePrY(R.Top)+(h div 2)+(h div 16));
        end;
       vtArrowUp:
        begin
        poly[0]:=point(ScalePrX(R.Left)+(w div 2)-(w div 16),ScalePrY(R.Top)+h-1);
        poly[1]:=point(ScalePrX(R.Left)+(w div 2)-(w div 16),ScalePrY(R.Top)+(h div 4));
        poly[2]:=point(ScalePrX(R.Left),ScalePrY(R.Top)+(h div 4));
        poly[3]:=point(ScalePrX(R.Left)+(w div 2),ScalePrY(R.Top));
        poly[4]:=point(ScalePrX(R.Left)+w-1,ScalePrY(R.Top)+(h div 4));
        poly[5]:=point(ScalePrX(R.Left)+(w div 2)+(w div 16),ScalePrY(R.Top)+(h div 4));
        poly[6]:=point(ScalePrX(R.Left)+(w div 2)+(w div 16),ScalePrY(R.Top)+h-1);
        end;
       vtArrowDown:
        begin
        poly[0]:=point(ScalePrX(R.Left)+(w div 2)-(w div 16),ScalePrY(R.Top));
        poly[1]:=point(ScalePrX(R.Left)+(w div 2)-(w div 16),ScalePrY(R.Top)+h-1-(h div 4));
        poly[2]:=point(ScalePrX(R.Left),ScalePrY(R.Top)+h-1-(h div 4));
        poly[3]:=point(ScalePrX(R.Left)+(w div 2),ScalePrY(R.Top)+h-1);
        poly[4]:=point(ScalePrX(R.Left)+w-1,ScalePrY(R.Top)+h-1-(h div 4));
        poly[5]:=point(ScalePrX(R.Left)+(w div 2)+(w div 16),ScalePrY(R.Top)+h-1-(h div 4));
        poly[6]:=point(ScalePrX(R.Left)+(w div 2)+(w div 16),ScalePrY(R.Top));
        end;
       end;
    for i := 0 to 6 do
    begin
       rpoly[i].x := R.Left+poly[i].x;
       rpoly[i].y := R.Right+poly[i].y;
    end;
   ACanvas.polygon(poly);
end;

procedure DrawOthers(MyVtShape:TVtShape;ACanvas:TCanvas;R:TRect);
var
   poly: array[0..15] of TPoint;
   rpoly: array[0..15] of TPoint;
   i:integer;
   StartPos, EndPos : Integer;
   w,w2,w3,w4,w8,w16,h,h2,h3,h4,h8,h16,x,y,xw,yh:integer;
begin
     w  := (ScalePrX(R.Right)  - ScalePrX(R.Left));
     w2 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 2;
     w3 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 3;
     w4 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 4;
     w8 := (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 8;
     w16:= (ScalePrX(R.Right)  - ScalePrX(R.Left))  div 16;
     h  := (ScalePrY(R.Bottom) - ScalePrY(R.Top));
     h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 2;
     h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 3;
     h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 4;
     h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 8;
     h16:= (ScalePrY(R.Bottom) - ScalePrY(R.Top))   div 16;

     x  := ScalePrX(R.Left);
     y  := ScalePrY(R.Top);
     xw := ScalePrX(R.Left)    + (ScalePrX(R.Right) - ScalePrx(R.Left)) - 1;
     yh := ScalePrY(R.Top)     + (ScalePrY(R.Bottom)- ScalePrY(R.Top)) - 1;


    StartPos := 0;
    EndPos   := 0;
    case MyVtShape.Shape of
        vtDiamond:
        begin
         poly[0]:=point(x+(w div 2),y);
         poly[1]:=point(x+w-1,y+(h div 2));
         poly[2]:=point(x+(w div 2),y+h-1);
         poly[3]:=point(x,y+(h div 2));
         EndPos := 3;
        end;
        vtOctagon:
        begin
         poly[0]:=point(x+(w div 3),y);
         poly[1]:=point(x+w-1-(w div 3),y);
         poly[2]:=point(x+w-1,y+(h div 3));
         poly[3]:=point(x+w-1,y+h-1-(h div 3));
         poly[4]:=point(x+w-1-(w div 3),y+h-1);
         poly[5]:=point(x+(w div 3),y+h-1);
         poly[6]:=point(x,y+h-1-(h div 3));
         poly[7]:=point(x,y+(h div 3));
         EndPos := 7;
        end;
        vtHexagon:
        begin
         poly[0]:=point(x+w2,y);
         poly[1]:=point(xw,y+h4);
         poly[2]:=point(xw,yh-h4);
         poly[3]:=point(x+w2,yh);
         poly[4]:=point(x,yh-h4);
         poly[5]:=point(x,y+h4);
         EndPos := 5;
        end;
        vtHexagonFlat:
        begin
         poly[0]:=point(x+w4,y);
         poly[1]:=point(xw-w4,y);
         poly[2]:=point(xw,y+h2);
         poly[3]:=point(xw-w4,yh);
         poly[4]:=point(x+w4,yh);
         poly[5]:=point(x,y+h2);
         EndPos := 5;
        end;
       vtUBarUp:
        begin
         poly[0]:=point(x,y);
         poly[1]:=point(x,yh);
         poly[2]:=point(xw,yh);
         poly[3]:=point(xw,y);
         poly[4]:=point(xw-w4,y);
         poly[5]:=point(xw-w4,yh-h4);
         poly[6]:=point(x+w4,yh-h4);
         poly[7]:=point(x+w4,y);
         EndPos := 7;
        end;
       vtUBarLeft:
        begin
         poly[0]:=point(x,y);
         poly[1]:=point(xw,y);
         poly[2]:=point(xw,yh);
         poly[3]:=point(x,yh);
         poly[4]:=point(x,yh-h4);
         poly[5]:=point(xw-w4,yh-h4);
         poly[6]:=point(xw-w4,y+h4);
         poly[7]:=point(x,y+h4);
         EndPos := 7;
        end;
        vtUBarDown:
        begin
         poly[0]:=point(x,y);
         poly[1]:=point(x,yh);
         poly[2]:=point(x+w4,yh);
         poly[3]:=point(x+w4,y+h4);
         poly[4]:=point(xw-w4,y+h4);
         poly[5]:=point(xw-w4,yh);
         poly[6]:=point(xw,yh);
         poly[7]:=point(xw,y);
         EndPos := 7;
        end;
        vtUBarRight:
        begin
         poly[0]:=point(x,y);
         poly[1]:=point(x,yh);
         poly[2]:=point(xw,yh);
         poly[3]:=point(xw,yh-h4);
         poly[4]:=point(x+w4,yh-h4);
         poly[5]:=point(x+w4,y+h4);
         poly[6]:=point(xw,y+h4);
         poly[7]:=point(xw,y);
         EndPos := 7;
        end;
       vtWaggle:
        begin
         poly[0]:=point(x,y);
         poly[1]:=point(x+w4,y+h8);
         poly[2]:=point(x+w2,y);
         poly[3]:=point(xw-w4,y+h8);
         poly[4]:=point(xw,y);
         poly[5]:=point(xw-w8,y+h4);
         poly[6]:=point(xw,y+h2);
         poly[7]:=point(xw-w8,yh-h4);
         poly[8]:=point(xw,yh);
         poly[9]:=point(xw-w4,yh-h8);
         poly[10]:=point(x+w2,yh);
         poly[11]:=point(x+w4,yh-h8);
         poly[12]:=point(x,yh);
         poly[13]:=point(x+w8,yh-h4);
         poly[14]:=point(x,y+h2);
         poly[15]:=point(x+w8,y+h4);
         EndPos := 15;
        end;
       vtCloudLeft:
       begin
        ACanvas.ellipse(x,y,xw-w4,yh-h4);
        ACanvas.ellipse(x+w4,y+h4,xw,yh);
       EndPos := 0;
       end;
       vtCloudRight:
       begin
        ACanvas.ellipse(x+w4,y,xw,yh-h4);
        ACanvas.ellipse(x,y+h4,xw-w4,yh);
        EndPos := 0;
       end;
    end;

    for i := StartPos to EndPos do
    begin
       rpoly[i].x := R.left+poly[i].x;
       rpoly[i].y := R.top+poly[i].y;
    end;
   ACanvas.polygon(slice(poly, EndPos+1));
end;

Function adjustForCertif(Text:String;FName:String;FieldId:Integer):String;
begin
  result := Text;

  If (Fname = 'T3') then
  begin
   if (FieldId = 14) or (FieldId = 17) then //remove dates
        result := '';
  end;

 { 20170122
  If Fname = 'S5' then
  begin
     if FieldId = 46 then
        result := '250,000  00';
     if FieldId = 63 then
        result := '375,000  00';
  end;
  }

  // 0.00 to "tax on income base" and political "base credit"
  If (Fname = 'S11') and (FieldId = 17) then
        result := '0.00';
  If (Fname = 'T3AB') and (FieldId = 107) then
        result := '0.00';
  If (Fname = 'T3BC') then
  begin
   if (FieldId = 17) or (FieldId = 107) then
        result := '0.00';
  end;
  If (Fname = 'T3MB') then
  begin
   if (FieldId = 17) or (FieldId = 107) then
        result := '0.00';
  end;
  If (Fname = 'T3NB') and (FieldId = 17) then
        result := '0.00';
  If (Fname = 'T3NL') and (FieldId = 17) then
        result := '0.00';
  If (Fname = 'T3NS') and (FieldId = 17) then
        result := '0.00';
  If (Fname = 'T3NT') then
  begin
   if (FieldId = 17) or (FieldId = 107) then
        result := '0.00';
  end;
  If (Fname = 'T3NU') then
  begin
   if (FieldId = 17) or (FieldId = 107) then
        result := '0.00';
  end;
  If (Fname = 'T3ON') and (FieldId = 17) then
        result := '0.00';
  If (Fname = 'T3PE') then
  begin
   if (FieldId = 17) or (FieldId = 107) then
        result := '0.00';
  end;
  If (Fname = 'T3SK') then
  begin
   if (FieldId = 17) or (FieldId = 107) then
        result := '0.00';
  end;
  If (Fname = 'T3YT') then
  begin
   if (FieldId = 17) or (FieldId = 107) then
        result := '0.00';
  end;
end;

Procedure PrintDynamicForm(RetNo:Integer;FName:String);  //20160901 Igor
type
  TFooterRecord = record
    vtLbl: TvtLabel;
    deltaH: Integer;
  end;
Var
  h,i,j,k,p,CtrlIndex,T1CFNo:Integer;
  ACanvas:TCanvas; DfmFileName:String;
  ALabel:TvtLabel; AvtEditBox:TvtEdit; ATag:Integer; FieldId:Integer;AShape:TvtShape;
//  PageX, PageY : LongInt; //20170212 Igor
  hdc: THandle;
  s:String;
  VerticalAdvance:Integer;
  CurrentTop:LongInt;
  FNo:Integer;
  //MyChild:TMyChild;
  F: TForm;
  MyScrollBox:TvtScrollBox;

  formNumPages,tmp,lastPageBreakPos,LastComponentDifferencial,PageBreaksToAdd:integer;
  PagebreakPos: array of Integer;
  PFHeight, OldTop : Integer; //20160404 Igor
  lblArr: Array of TFooterRecord;
  NeedBreak: Boolean;
  R : TRect;       //20160608 Igor
  PixelsPerInch: TPoint; //20160608 Igor
  MyFrame: TFrame;//20160608 Igor
  MyImage: TImage;//20160608 Igor
begin
  FNo:=GetFormNo(FName);
  VerticalAdvance:=14; //MyStrToInt(InputBox('Vertical line height','Enter', '14'));
  CurrentTop:=20;

  //20160829 Igor >>>
//  if FastPrint = False then
//    Printer.BeginDoc;
  if ((Printer.Orientation = poLandscape) <> IsLandscape(FName)) then
  begin
    if Printer.Printing then
      Printer.EndDoc;

    If IsLandscape(FName) Then
      Printer.Orientation := poLandscape
    else
      Printer.Orientation := poPortrait;
    Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo); //20160905 Igor
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  If not Printer.Printing then
  begin
    Printer.Title := GetFormRlName(FNo) + ': ' + GetRetName(RetNo); //20160905 Igor
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  if NeedNewPage then
    Printer.NewPage;
     //20170212 Igor>>>
  CalcScaleXY;
//  PageX  := Printer.PageWidth;
//  PageY  := Printer.PageHeight;
//  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
//  ScaleY := (PageY * ScMult) div MxFrmHeight; {FrmHeight;}
 //20170212 Igor<<<
  hdc :=  Printer.Canvas.Handle;
  ACanvas:=Printer.Canvas;
  ACanvas.Brush.Style := bsClear;      //20111222
  ACanvas.Font.color:=clBlack;  //20111222

  DfmFileName:=GetDFMFileName(FName);
  If not FileExists(DfmFileName) then
  Begin
    ShowMessage('DFM File problem ='+DfmFileName);
    Exit;
  end;

  F := TForm.Create(Application); //20160407 Igor
  F.visible := False; //20160407 Igor
  MyScrollBox := TFormTF_2026.Create(F,RetNo,FNo);  //20150817 //20160407 Igor
  ReadComponentResFile(DfmFileName,MyScrollBox);
  //MyScrollBox.Rescale(100, DfmFileName); //???
  MyScrollBox.AfterOpenForm(vtdPrint); //20160407 Igor


//20160707

 //20160619
    //20160119
  If FName='T1135' then             //original Efiled
  begin
      If (FetchElm(RetNo,FName,39)>'')
      and  (FetchElm(RetNo,FName,22)='')  //amended
      then  //thre is Efile confirmaqtion
      begin
       PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
       PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
     end;
  end;

  //20160119
  If FName='T1135' then   //amended
  begin
      If (FetchElm(RetNo,FName,39)>'')
      and (FetchElm(RetNo,FName,22)>'')  //amended
      and (FetchElm(RetNo,FName,34)='')  //original after amend
       then  //there is Efile confirmaqtion
      begin
       PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
     end;
  end;

  //20160707  Efiled after amended?

  If FName='T1135' then   //amended
  begin
      If (FetchElm(RetNo,FName,39)>'')
      and (FetchElm(RetNo,FName,22)>'')  //amended
      and (FetchElm(RetNo,FName,34)>'')  //retransmission
      then  //there is Efile confirmaqtion
      begin
       PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
       PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
     end;
  end;


  lastPageBreakPos := 0;
  //20160404 Igor >>>
  PFHeight := 0;
  OldTop := MaxInt;
  for i := 0 to MyScrollBox.ControlCount - 1 do
  begin
    if (MyScrollBox.Controls[i] is TVtLabel) and ( (MyScrollBox.Controls[i] as TVtLabel).PrintEveryPage)  then
    Begin
      SetLength(lblArr,Length(lblArr)+1);
      lblArr[length(lblArr)-1].vtLbl := (MyScrollBox.Controls[i] as TVtLabel);
      if PFHeight < ((MyScrollBox.Controls[i] as TVtLabel).Top + (MyScrollBox.Controls[i] as TVtLabel).Height) then
        PFHeight := ((MyScrollBox.Controls[i] as TVtLabel).Top + (MyScrollBox.Controls[i] as TVtLabel).Height);
      if OldTop > (MyScrollBox.Controls[i] as TVtLabel).Top then
        OldTop := (MyScrollBox.Controls[i] as TVtLabel).Top;
    End;
  end;
  for I := 0 to Length(lblArr) - 1 do
  Begin
    lblArr[I].deltaH := lblArr[I].vtLbl.top - OldTop;
  End;
  if (PFHeight <> 0) or (OldTop <> MaxInt)  then
    PFHeight := PFHeight - OldTop;
  //20160404 Igor <<<

  //find last page break
  for i := 0 to MyScrollBox.ControlCount - 1 do
  begin
    //20160905 igor >>>
    If MyScrollBox.Controls[i] is TRichEdit then
      IncRichEditFontSize(TRichEdit(MyScrollBox.Controls[i]), 2 * MainOptions.Prn_FontIncr,
        IsFormAClientLetter(FName)); //20170204 Igor
    //20160905 igor <<<
    If (MyScrollBox.Controls[i] is TVtShape) and ( (MyScrollBox.Controls[i] as TVtShape).vtPageBreak) then
    begin
      MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - PFHeight; //20160404 Igor

      if (MyScrollBox.Controls[i].Top + MyScrollBox.Controls[i].Height)> lastPageBreakPos then
        lastPageBreakPos := MyScrollBox.Controls[i].Top + MyScrollBox.Controls[i].Height;
    end;
  end;


  //20160404 Igor <<<<
  //find if component after last page break and how far past
  LastComponentDifferencial := -1;
  for i := 0 to MyScrollBox.ControlCount - 1 do
  begin
    if MyScrollBox.Controls[i].top > lastPageBreakPos then
    begin
      LastComponentDifferencial := MyScrollBox.Controls[i].top - lastPageBreakPos;
    end;
  end;

  PageBreaksToAdd := 0;
  if not LastComponentDifferencial < 0 then
    PageBreaksToAdd := (LastComponentDifferencial div (1000 - PFHeight)) + 1; //20160404 Igor


  for i := 1 to PageBreaksToAdd do
  begin
    AShape := TvtShape.create(MyScrollBox);
    AShape.Parent := MyScrollBox;
    AShape.vtPageBreak := true;
    AShape.Top := lastPageBreakPos + ((1000 - PFHeight) * i); //20160404 Igor
  end;

  SetLength(PagebreakPos, 1);
  formNumPages := 0;
  PagebreakPos[0] := 0;

  //determine if multiple pages, load PagebreakPos array
  for i := 0 to MyScrollBox.ControlCount - 1 do
  begin
    If MyScrollBox.Controls[i] is TVtShape then
    begin
      if (MyScrollBox.Controls[i] as TVtShape).vtPageBreak then
      begin
        SetLength(PagebreakPos, length(PagebreakPos)+1);
        PagebreakPos[formNumPages] := (MyScrollBox.Controls[i] as TVtShape).Top;
        inc(formNumPages,1)
      end;
    end;
  end;  //i components

  //sort PagebreakPos array
  for i := high(PagebreakPos)-1 Downto low(PagebreakPos) do
  begin
    for j := i to high(PagebreakPos)-1 do
    begin
      if PagebreakPos[j] > PagebreakPos[j + 1] then
      begin
        tmp := PagebreakPos[j];
        PagebreakPos[j] := PagebreakPos[j + 1];
        PagebreakPos[j + 1] := tmp;
      end;
    end;
  end;

  for i := length(PagebreakPos)-1 downto 1 do
  begin
    if ((PagebreakPos[I] - PagebreakPos[I-1]) > (100 - PFHeight)) then
    begin
      oldTop := PagebreakPos[I-1] + (1000 - PFHeight);
      while oldTop < PagebreakPos[I] do
      Begin
        NeedBreak:= False;
        for j := 0 to MyScrollBox.ControlCount - 1 do
        Begin
          if ((MyScrollBox.Controls[j].Top) >= oldTop) and
             ((MyScrollBox.Controls[j].Top) < PagebreakPos[I]) and
              (MyScrollBox.Controls[j].Visible) then
          Begin
            if ((MyScrollBox.Controls[i] is TvtEdit) AND
                (MyScrollBox.Controls[i] as TvtEdit).vtIsPrintable) or
               ((MyScrollBox.Controls[i] is TvtLabel) AND
                (MyScrollBox.Controls[i] as TvtLabel).vtIsPrintable) or
               ((MyScrollBox.Controls[i] is TvtShape) AND
                (MyScrollBox.Controls[i] as TvtShape).vtIsPrintable) then
            Begin
              NeedBreak := True;
              break;
            End;
          End;
        End;
        if NeedBreak then
        Begin
          SetLength(PagebreakPos, length(PagebreakPos)+1);
          PagebreakPos[length(PagebreakPos)-1] := oldTop;
          oldTop := OldTop + (1000 - PFHeight);
        End
        else
          break;
      end;
    end;
  end;

  for i := high(PagebreakPos)-1 Downto low(PagebreakPos) do
  begin
    for j := i to high(PagebreakPos)-1 do
    begin
      if PagebreakPos[j] > PagebreakPos[j + 1] then
      begin
        tmp := PagebreakPos[j];
        PagebreakPos[j] := PagebreakPos[j + 1];
        PagebreakPos[j + 1] := tmp;
      end;
    end;
  end;



  for p := 0 to high(PagebreakPos) -1 do
  begin

  (* Possible pagebreak problem:
  Only recognized components are printed!
  *)
    for i := 0 to MyScrollBox.ControlCount - 1 do
    begin
      if (MyScrollBox.Controls[i] is TvtEdit) AND
         (MyScrollBox.Controls[i] as TvtEdit).vtIsPrintable then
      begin
        if ( (MyScrollBox.Controls[i].Top) >= PagebreakPos[p]  ) and //20160404 igor
           ( (MyScrollBox.Controls[i].Top) < PagebreakPos[p+1] )     //20160404 igor
        then
        begin
          MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - PagebreakPos[p]; //20160404 Igor
          PrintEditBox(RetNo,MyScrollBox.Controls[i] as TvtEdit,FName,FNo,hdc,ACanvas); //PrintEditBox(RetNo,AvtEditBox,FName,FNo,hdc,ACanvas);
        end;
      end; //tvedit
      if (MyScrollBox.Controls[i] is TvtLabel) AND
         (MyScrollBox.Controls[i] as TvtLabel).vtIsPrintable  then
      begin
        if not (MyScrollBox.Controls[i] as TvtLabel).PrintEveryPage then
        Begin
          if ( (MyScrollBox.Controls[i].Top) >= PagebreakPos[p]  ) and //20160404 Igor
             ( (MyScrollBox.Controls[i].Top) < PagebreakPos[p+1] )     //20160404 Igor
          then
          begin
            MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - PagebreakPos[p]; //20160404 Igor
            PrintLabel(MyScrollBox.Controls[i] as TvtLabel,ACanvas);
          end;
        End;
      end;
      //20160905 Igor >>>
      if MyScrollBox.Controls[i] is TRichEdit then //RichEdit
      begin
        if Assigned((MyScrollBox.Controls[i] as TRichEdit).Parent) then
        begin
          if ( (MyScrollBox.Controls[i].Top) >= PagebreakPos[p]  ) and
             ( (MyScrollBox.Controls[i].Top) < PagebreakPos[p+1] )
          then
          begin
            MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - PagebreakPos[p];
            PrintRichEdit(RetNo, (MyScrollBox.Controls[i] as TRichEdit), ACanvas);
          end;
        end;
      end; //richedit
      //20160905 Igor <<<
      if (MyScrollBox.Controls[i] is TvtShape) AND
         (MyScrollBox.Controls[i] as TvtShape).vtIsPrintable then
      begin
        if ( (MyScrollBox.Controls[i].Top) >= PagebreakPos[p]  ) and  //20160404 Igor
           ( (MyScrollBox.Controls[i].Top) < PagebreakPos[p+1] )      //20160404 Igor
        then
        begin
          MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - PagebreakPos[p]; //20160404 Igor
          PrintVtShape(MyScrollBox.Controls[i] As TvtShape,ACanvas);
        end;
      end;
      //20160608 Igor >>>>>
      if MyScrollBox.Controls[i] is TImage then
      begin
        if ( (MyScrollBox.Controls[i].Top) >= PagebreakPos[p]  ) and
           ( (MyScrollBox.Controls[i].Top) < PagebreakPos[p+1] )
        then
        begin
          MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - PagebreakPos[p]; //20160404 Igor
          with MyScrollBox.Controls[i] as TImage do
          begin
            R.Left := ScalePrX(Left);
            R.Top := ScalePrY(Top);
            R.Right := ScalePrX(Left + Width);
            R.Bottom := ScalePrY(Top + Height);
            PrintBitmap(ACanvas, R, (MyScrollBox.Controls[i] as TImage).Picture.Bitmap);
          end;
        end;
      end;
      if MyScrollBox.Controls[i] is TFrame then
      begin //search in the frame
        MyFrame := MyScrollBox.Controls[i] as TFrame;
        if ( (MyScrollBox.Controls[i].Top) >= PagebreakPos[p]  ) and
           ( (MyScrollBox.Controls[i].Top) < PagebreakPos[p+1] )
        then
        begin
          for j := 0 to MyFrame.ComponentCount - 1 do
          begin
            if MyFrame.Components[j] is TImage then
            begin //print the image

              MyImage := MyFrame.Components[j] as TImage;
              //PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);

              //find left and top in ralation to form scaling
              R.Left := ScalePrX(MyFrame.Left);
              R.Top := ScalePrY(MyFrame.Top);

              //consistant height and width scaling
              PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
              PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
              R.Right := R.Left + (MyImage.Picture.Width * (PixelsPerInch.x)) div ScMult; //ScalePrX(MyFrame.Width);
              R.Bottom := R.Top + (MyImage.Picture.Height * (PixelsPerInch.y)) div ScMult; //ScalePrY(MyFrame.Height);

              //showmessage('Parent: ' + MyImage.Parent.Name + ' Owner: ' + MyImage.Parent.Name);
              if Pos('FLAGFRAME', UpperCase(MyImage.Parent.name)) > 0 then
                PrintBitmap(ACanvas, R, MyImage.Picture.Bitmap);

            end;
          end;
        end;
      end
      //20160608 Igor <<<<<
    end;  //For ControlCount
    //20160404 Igor >>>
    for I := 0 to length(lblArr) - 1 do
    Begin
      oldTop := lblArr[I].vtLbl.Top;
      lblArr[I].vtlbl.Top := PagebreakPos[p+1] - PagebreakPos[p] + lblArr[I].deltaH + 15; //20160404 Igor
      s := lblArr[I].vtLbl.Caption;
      if lblArr[I].vtLbl.PrintEveryPageText <> '' then
      Begin
        lblArr[I].vtLbl.Caption := ReplaceStr(lblArr[I].vtLbl.PrintEveryPageText,'[#page]',IntToStr(p+1));
        lblArr[I].vtLbl.Caption := ReplaceStr(lblArr[I].vtLbl.Caption,'[#pagecount]',IntToStr(high(PagebreakPos)));
      End;
      PrintLabel(lblArr[I].vtLbl,ACanvas);
      lblArr[I].vtLbl.Caption := s;
      lblArr[I].vtlbl.Top := oldTop;
    End;
    //20160404 Igor <<<

    if p < high(PagebreakPos) - 1 then
      Printer.NewPage;
  end; //for pagebreak

  if FastPrint then      //20160829 Igor
    NeedNewPage := true; //20160829 Igor
  if FastPrint = False then
    Printer.EndDoc;
  MyScrollBox.Free;
End;


procedure PrintNR4(ARetNo, APrintKind: Integer; ASelectedForms: TFRecArray);
var
  DestFormName: String;
  DestFormNo, TopOrBottom: Integer;
  R: TFRec;
  function SwichTopOrBottom: integer;
  begin
    if TopOrBottom > 2 then
      TopOrBottom := 1;
    Result := TopOrBottom;
    inc(TopOrBottom);
  end;
begin
  TopOrBottom := 1;
  case APrintKind of
    0: DestFormName := 'NR4SL1';
    1: DestFormName := 'NR4SL23';
    2: DestFormName := 'NR4SL4';
  else
    exit;
  end;
  DestFormNo := GetFormNo(DestFormName);
  If DestFormNo=0 then
    exit;
  If RetList[ARetNo].Frm[DestFormNo].Count = 0 then
    InitFormData(ARetNo, DestFormNo);

  for R in ASelectedForms do
  begin
    case APrintKind of
      0, 2: CopyNR4SlipToDestForm(ARetNo, R.FormInstName, DestFormNo, SwichTopOrBottom, DestFormName);
      1:
        Begin
          CopyNR4SlipToDestForm(ARetNo, R.FormInstName, DestFormNo, SwichTopOrBottom, DestFormName);
          CopyNR4SlipToDestForm(ARetNo, R.FormInstName, DestFormNo, SwichTopOrBottom, DestFormName);
        end
    end;
    if (TopOrBottom > 2) or (R = ASelectedForms[length(ASelectedForms) - 1]) then
    begin
      PrintForm(ARetNo, DestFormName, 1, '');
      If APrintKind=1 then PrintForm(ARetNo, DestFormName, 2, '');  //20240314
      ClearForm(ARetNo, DestFormName);
    end;
  end;
end;

end.
