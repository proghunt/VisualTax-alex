unit T2_2027Print;
// revision 2014-07-29

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

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Dialogs, Printers, {QuickRpt,qrextra,} extctrls, ComCtrls,
  vtEditBox,
  vtDynData,  //20150817
  vtShape, vtLabel, vtMemoBox, RichEdit,
  vtChild,vtForm,     //20150817
  vtControlIntf, //20230411 Igor
  vtGroupBox, //20160407 Igor

  rxRichEd; //20160819 Igor (Must be last)

const
  MxFrmHeight = 1050; //1050; //980; //960;
const
  MxFrmWidth = 655;

function PrintQuickReport(RetNo: integer; FName: string; WhichPage: integer): boolean;

procedure AfterReadComponentForPrint(AForm: TForm; FName: string);
procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: string;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0;
  AisSynPDF: Boolean = False); //20161211 Igor
procedure PrintvtMemoBox(RetNo: Integer; MyMemoBox: TvtMemo; FName: string;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0);
procedure PrintBarcodeBitmap(RetNo: Integer; Canvas: TCanvas; BarCodeImage1: TImage;
  BarCodeImage2: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);
procedure PrintSFDBarcodeBitmap(RetNo: Integer; Canvas: TCanvas; SFDBarCodeImage1: TImage;
  SFDBarCodeImage2: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);

//Function PrintQuickReport(RetNo: integer; FName: string;WhichPage:integer): boolean;
{Procedure PrintALetter(RetNo:Integer;LetterName:String);}

//Function PrintForm(RetNo: integer; FName: string;WhichPage:integer): boolean;
//Function PrintForm(RetNo: integer; FName: string;WhichPage:integer; LastFormToPrint:String): boolean;

function GetQRContentsForT7DR(RetNo: Integer): string;
procedure AttachQRCode(AQRContents: string; Canvas: TCanvas;
  QRCodeImage: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);

procedure PrintForm(RetNo: integer; FName: string; WhichPage: integer; LastFormToPrint: string);

//Function PrintFormPage(RetNo: integer; FName: string; AForm: TForm;formNumPages:Integer;formPagebreakHeight:Integer): boolean;
//Function PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;formPagebreakHeight:Integer;LastFormToPrint:String): boolean;
//procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;formPagebreakHeight:Integer;LastFormToPrint:String);
//Function PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;isPageLandscape:boolean;formPagebreakHeight:Integer;LastFormToPrint:String): boolean;
procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm; numPagePrinting, formNumPages: Integer; isPageLandscape: boolean; formPagebreakHeight: Integer; LastFormToPrint: string);

Procedure PrintDynamicForm(RetNo:Integer;FName:String);  //added 20150817

procedure PrepareRichEdit(ARetNo: Integer; AFormName: String; ARichEdit: TRichEdit); //20161211 Igor
procedure PrintImageT2(ARetNo: Integer; AFormName: String; AImage: TImage; ACanvas: TCanvas; //20161211 Igor
    ADTop: Integer = 0; ADLeft: Integer = 0);
procedure PrintHeader(ACanvas: TCanvas; ARetNo: Integer; AFormName: String; AFormNo: Integer;
   APageNumber: Integer; APageHeight, APageWidth: Integer;
   ADTop: Integer = 0; ADLeft: Integer = 0); //20161211 Igor

{Function PDFPrintFormPage(RetNo: integer; FName: string): boolean;}

var
  //ScaleX, ScaleY : Word;
  PFile: TextFile;
  HeaderType: string; //[1];
  PRINTCNT, PGNO: Integer;
  ThisMccrA: string; //[10];

  maxBarDataLength: Integer;

  NeedNewPage: Boolean; //20160829 Igor

implementation

uses vtMulti, vtMain, vtCommon, T2_2027, T2_2027Main, T2_2027TrimStr, T2_2027Declare,
  T2_2027Common, T2_2027Common2, fProgres, T2_2027Calc, {T2_2027QrFsIs,T2_2027QrFsBs,}
  T2_2027ChildWinNew, vtPrints, vtTrimStr, vtShared, T2_2027BarDataGen;
// ,RegularExpressions; // 20151214 Igor //20160903 Igor

var //unused???
  WhiteBoxes: Boolean;

procedure PrintClientLetter(RetNo: integer);
var
  LtrName: string;
begin
  LtrName := GetClientLettersDir + '\' + MkClientLetterName(RetNo);
  if not FileExists(LtrName) then
    LtrName := AppDir + '\' + 'DefaultCover.LTR';
end;

function PrintQuickReport(RetNo: integer; FName: string; WhichPage: integer): boolean;
//Var  Report : TQuickRep;
begin
  UndefMsg('PrintQuickReport');
  Result := False;
end;

//20121107
//Function PrintForm(RetNo: integer; FName: string;WhichPage:integer; LastFormToPrint:String): boolean;

procedure PrintForm(RetNo: integer; FName: string; WhichPage: integer; LastFormToPrint: string);
var
  i, j, n: integer;
  Root, FInst: string;
  FrmNm, SubstFrm: string; //[12];
  DfmFileName: string;
  F: TForm; //20160407 Igor
  FullForm: TFormT2_2027; //20160407 Igor  //20160518 Igor

  PagebreakPos: array of Integer;
  formNumPages, PagebreakHeight: Integer;
  MyLabel: TvtLabel;
  MyEditBox: tvtEdit;
  MyVtShape: TvtShape;
  startpage, endpage: integer;

  isPageLandscape: boolean;

//  Match: TMatch;          // 20151214 Igor //20160903 Igor
//  strem:TStringStream;    // 20151214 Igor //20160903 igor
//  newRichText:AnsiString; // 20151214 Igor //20160903 igor
begin
  {If LeftStr(FName,5) = 'LETR_' then
   begin PrintClientLetter(RetNo); exit; end;

  If LeftStr(FName,7)='GIFIIS#' then
  begin
   If (Vl(FetchGifiElm(RetNo,FName,'8299')) <> 0)
   or (Vl(FetchGifiElm(RetNo,FName,'9367')) <> 0)
   or (Vl(FetchGifiElm(RetNo,FName,'9659')) <> 0)
   or (Vl(FetchGifiElm(RetNo,FName,'9898')) <> 0)   then
   Begin
    //MainForm.GifiIsBtnClick(Application);
    GifiStmNoToPrint:=MyStrToInt(RightStr(FName,1));
    GifiRetNo := RetNo;
    Application.CreateForm(TQRFSIST2_2027,QRFSIS);
    AQrReport := QRFSIS.QuickRep1;
    QRFSIS.QuickRep1.PrinterSettings.PrinterIndex:= Printer.PrinterIndex;
    //AQrReport.Preview;
    AQrReport.Print;
    QRFSIS.Free;

   end;
   Exit;
  end;

  If LeftStr(FName,7)='GIFIBS#' then
  begin
     If (Vl(FetchGifiElm(RetNo,FNAME,'2599'))>0)
     or (Vl(FetchGifiElm(RetNo,FNAME,'3849')) <> 0) then
     begin
      GifiStmNoToPrint:=MyStrToInt(RightStr(FName,1));
      GifiRetNo := RetNo;
      Application.CreateForm(TQRFSBST2_2027,QRFSBS);
      AQrReport := QRFSBS.QuickRep1;
      QRFSBS.QuickRep1.PrinterSettings.PrinterIndex:= Printer.PrinterIndex;
      AQrReport.Print; //Preview;
      QRFSBS.Free;
     end;
     Exit;
  end;

  If ShowFieldIdSw = false then
  begin

    If (FName = 'OPG_1')
    or (Fname = 'OPG_18')
    or (Fname = 'OPG_19')
    or (Fname = 'OPG_20')
    or (LeftStr(Fname,6) = 'OMCCRA')
    or (FName = 'OPGS_1') or (Fname = 'OPGS_7') or (Fname = 'OPGS_8')
    then
    begin
     PrintQuickReport(RetNo,FName,WhichPage);
     exit;
    end;

  end;

  //delete the BarCodedata file
  If FileExists(appdir + '\BarCodedata.txt') then SysUtils.DeleteFile(appdir + '\BarCodedata.txt');

    FrmNm := FName;
    //FrmNm := SubstituteForm(RetNo,FrmNm);
    FInst := ExtractFormInst(FrmNm);
    DfmFileName:=GetDFMFileName(FrmNm);
    If fileExists(DfmFileName) = False then exit;

    FullForm:=TForm.Create(Application);
    {
    //20130329 does nor work
    FullForm.Font.Height := -13;
    FullForm.Font.Name   := 'System';
    }
   {if ReadComponentResFile(DfmFileName, FullForm) = nil then
   begin
      //ShowMessage('Form '+DfmFileName +' is damaged. Contact VisualTax');
     FullForm.free;
     exit;
   end;
    AfterReadComponentForPrint(FullForm,FrmNm);
    FullForm.vertscrollbar.position := 0;
    FullForm.horzscrollbar.position := 0;

    {
    //20130329 does nor work
    FullForm.Font.Height := -13;
    FullForm.Font.Name   := 'System';
    }

  //20150817  Copied from T1_2014
  FrmNm := FName;

  If IsFormDynamic(RetNo,FName) then Begin PrintDynamicForm(RetNo,FName);Exit;End; //20120110  //20160829 Igor
 // FrmNm := SubstituteForm(RetNo,FrmNm);  //20150817
  FInst := ExtractFormInst(FrmNm);
  DfmFileName:=GetDFMFileName(FrmNm);
//  If Ret[RetNo].IsLastYearRetNo then DfmFileName:=GetLastYearDfmFileName(FName);  //20150817
  If FileExists(DfmFileName) = false then exit;  //20100113

  //20160407 Igor >>>
  F:=TForm.Create(Application);
  F := TForm.Create(Application);
  F.visible := False;
  FullForm := TFormT2_2027.Create(F,RetNo,GetFormNo(FrmNm));
//  FullForm:=TForm.Create(Application);
  //20160407 Igor <<<
  if ReadComponentResFile(DfmFileName, FullForm) = nil then
  begin
     //ShowMessage('Form '+DfmFileName +' is damaged. Contact VisualTax');
    FullForm.free;
    exit;
  end;
  FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
 // ReadComponentResFile(DfmFileName, FullForm);
  AfterReadComponentForPrint(TForm(FullForm),FrmNm);
  FullForm.vertscrollbar.position := 0;
  FullForm.horzscrollbar.position := 0;
  //-------------------------------------
  SetLength(PagebreakPos, 20);

  formNumPages := 1;
  PagebreakPos[0] := 0;

  //20160905 Igor >>>
  for i := 0 to FullForm.ControlCount - 1 do
  begin
    // 20151214 Igor
    If FullForm.Controls[i] is TRichEdit then
      IncRichEditFontSize(TRichEdit(FullForm.Controls[i]), 2 * MainOptions.Prn_FontIncr,
        IsFormAClientLetter(FName)); //20160903 Igor //20170204 Igor

    if FullForm.Controls[i] is TVtShape then
      if (FullForm.Controls[i] as TVtShape).vtPageBreak then
      begin
        formNumPages := formNumPages + 1;
        PagebreakPos[formNumPages] := (FullForm.Controls[i] as TVtShape).Top;
      end
      else
        (FullForm.Controls[i] as TVtShape).SendToBack;
  end; //i controls
  //20160905 Igor <<<

  isPageLandscape := false;
  formNumPages := formNumPages - 1;

  if formNumPages = 0 then
  begin
    formNumPages := 1;
    //PagebreakPos[1] := GetFormHeight(FrmNm);
  end;
  // else
  // begin
  if (whichPage > 0) and (whichPage <> 99) then
  begin
    //settings to print one page
    startPage := WhichPage; //-1;
    endPage := WhichPage; //-1;
  end
  else
  begin
    startPage := 1;
    endPage := formNumPages; //-1;
  end;

  //for j := 1 to formNumPages do
  for j := startPage to endPage do
  begin
    if FullForm = nil then
    begin
      //FullForm := TForm.Create(Application); //20160407 Igor
      FullForm := TFormT2_2027.Create(F,RetNo,GetFormNo(FrmNm)); //20160407 Igor
      ReadComponentResFile(DfmFileName, FullForm);
      FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
      AfterReadComponentForPrint(TForm(FullForm), FName);
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

    for i := FullForm.ComponentCount - 1 downto 0 do
    begin

      PagebreakHeight := PagebreakPos[j + 1] - PagebreakPos[j];

      //if FullForm.Components[i] is TRichEdit then
      //   showmessage('TRichEdit: ' + inttostr((FullForm.Components[i] as TControl).Top));

      if ((FullForm.Components[i] as TControl).Top >= PagebreakPos[j]) and
        ((FullForm.Components[i] as TControl).Top <= PagebreakPos[j + 1]) then
      begin
        (FullForm.Components[i] as TControl).Top := (FullForm.Components[i] as TControl).Top - PagebreakPos[j];
(* //20170204 Igor
       //20170203 Igor >>>
         If FullForm.Controls[i] is TRichEdit then
           IncRichEditFontSize(TRichEdit(FullForm.Controls[i]), 2 * MainOptions.Prn_FontIncr); //20160903 Igor
      //20170203 Igor <<<
*)

//20160208 Igor
        //20130401
//        if FullForm.Components[i] is TVtShape then
//          if ((FullForm.Components[i] as TVtShape).vtPageBreak) and ((FullForm.Components[i] as TVtShape).vtPageBreakType = vtPageBreakLandscape) then
//            isPageLandscape := true
//          else
//            isPageLandscape := false;
      end
      else
      begin
        (FullForm.Components[i] as TControl).Free;
      end;
    end;

    isPageLandscape := IsLandscape(FName);//20160208 Igor

{   leave it as is untll
    //jz 20240626 <<<
    isPageLandscape := false;
    for i := FullForm.ComponentCount - 1 downto 0 do
    begin
        if FullForm.Components[i] is TVtShape then
          if ((FullForm.Components[i] as TVtShape).vtPageBreak) and ((FullForm.Components[i] as TVtShape).vtPageBreakType = vtPageBreakLandscape) then
            begin isPageLandscape := true; showmessage((FullForm.Components[i] as TVtShape).name); end
    end;
    //jz 20240626 >>>
}

    PrintFormPage(RetNo, FName, TForm(FullForm), j, formNumPages, isPageLandscape, PagebreakHeight, LastFormToPrint);
    FreeAndNil(FullForm); //force reload at begin of loop
  end; //end for

  FullForm.Free;
  F.Free;
  //if FileExists(PFormFileName) then SysUtils.DeleteFile(PFormFileName);
end;

(*
  long comment deleted
*)

//20121107
//Function PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;formPagebreakHeight:Integer;LastFormToPrint:String): boolean;

procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm;
  numPagePrinting, formNumPages: Integer; isPageLandscape: boolean;
  formPagebreakHeight: Integer; LastFormToPrint: string);
var
  //FldRec: PFieldList; //LblRec : PLabelList;  LnRec : PLineList;
  dpiAdjustment, FrmHeight, PenWidth, FNo, d,  k, x, y, XPos, YPos: Integer;
  //PageX, PageY: LongInt; //20170212 Igor
  S, Astring, FormattedAmount: string;
  R: TRect;
  Point1, Point2: TPoint;
  PixelsPerInch: TPoint;
  NullString: array[0..20] of Char; {Null terminated string variable/ c type}
  hdc: THandle;
  TempShadeSw: Boolean;
  Ht, Wt: Real; //height and width
  PFName: PChar;
  ImageRect: TRect;
  BarCodeBmp, SomeImage: TBitMap;
  ARichEdit: TRichEdit;
  DfmFileName: string;
  ACanvas: TCanvas;
  MyLabel: TvtLabel;
  MyEditBox: tvtEdit;
  MyMemoBox: TvtMemo;
  AImage, AImage1, ASFDImage, ASFDImage1: TImage;
  MyShape: TShape;
  MyVtShape: TvtShape;
  MyVtGroupBox: TvtGroupBox; //20160407 Igor

  MyFrame: TFrame;
  MyBitmap: TBitmap;
  MyImage: TImage;

  Wmf: TMetafile;
  WmfCanvas: TMetafileCanvas;

  Margins: TMargins;

  WinFontSize: Integer;
  DC: THandle;

  //xExtraDPIAdjustment, yExtraDPIAdjustment: integer; //20170212 Igor
  lCurrPageisLandscape: Boolean; //20170127 igor

  RealHeight, RealWidth: Integer; //20170307 Igor
  efiledElmNo, amendedElmNo, refiledElmNo :integer; // 20250709 Igor

  procedure PrintControls(AControl: TWinControl; ADTop, ADLeft: Integer); //20160407 Igor
  var
    kk, i, b, j: Integer;
  Begin
    kk := AControl.ControlCount - 1;
    for i := 0 to kk do
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
      if AControl.Controls[i] is TVtShape then
      begin //print the shape
        MyVtShape := AControl.Controls[i] as TVtShape;
        if MyVtShape.vtIsPrintable then
        begin
          PrintVtShape(MyVtShape, ACanvas, ADTop, ADLeft);
        end;
      end
      else
      if AControl.Controls[i] is TvtLabel then
      begin //print the label
        MyLabel := AControl.Controls[i] as TvtLabel;
        if MyLabel.vtIsPrintable then
          PrintLabel(MyLabel, ACanvas, DefFontName, ADTop, ADLeft);
      end
      else
      if AControl.Controls[i] is TvtEdit then
      begin //print the editbox
        MyEditBox := AControl.Controls[i] as TvtEdit;
        if MyEditBox.vtIsPrintable then
        begin
          PrintEditBox(RetNo, MyEditBox, FName, FNo, Hdc, ACanvas, ADTop, ADLeft);
        end;
      end //tvedit
      else
      if AControl.Controls[i] is TVtMemo then //TMemo
      begin
        MyMemoBox := AControl.Controls[i] as TvtMemo;
        PrintvtMemoBox(RetNo, MyMemoBox, FName, FNo, Hdc, ACanvas, ADTop, ADLeft);
      end //tvtmemo

      //IMAGE  //20200325
      else
      if AControl.Controls[i] is TImage then
      begin

        ASFDImage := AControl.Controls[i] as TImage;
        AImage:=AControl.Controls[i] as TImage;  //20200326
        if ((OptRec.NoBarCode = False) and (AImage.name = 'barcodePlaceHolder1')) then
        begin
          for b := 0 to AControl.ControlCount - 1 do
          begin
            if AControl.Controls[b] is TImage then
            begin
              AImage1 := AControl.Controls[b] as TImage;
              if AImage1.name = 'barcodePlaceHolder2' then
              begin
                PrintBarcodeBitmap(RetNo, ACanvas, AImage, AImage1, ADTop, ADLeft);
                break;
              end;
            end;
          end;
        end

        else
        if (OptRec.NoBarCode = False) and (ASFDImage.name = 'SFDbarcodePlaceHolder1') then
        begin
          for b := 0 to AControl.ControlCount - 1 do
          begin
            if AControl.Controls[b] is TImage then
            begin
              ASFDImage1 := AControl.Controls[b] as TImage;
              if ASFDImage1.name = 'SFDbarcodePlaceHolder2' then
                PrintSFDBarcodeBitmap(RetNo, ACanvas, ASFDImage, ASFDImage1, ADTop, ADLeft);
            end;
          end;
        end


       //20221008  //con  as done in T1
       else if (AImage.name = 'QRCodePlaceHolder') then
       begin
         AttachQRCode(GetQRContentsForT7DR(RetNo), ACanvas, AImage, ADTop, ADLeft);
       end

      else
      if (UpperCase(AImage.Name)= 'E_SIGNATUREHOLDER')  //201200326
      then
      Begin
         if UpperCase(FetchElm(RetNo,'T2',270)) ='Y' then  //20200326
         Begin
          s:=GetSignatureFilePath(RetNo);
          If s>'' then
          Begin
           R.Left := ScalePrX(AImage.Left + ADLeft);  //20160407 Igor
           R.Top := ScalePrY(AImage.Top + ADTop);      //20160407 Igor
           AImage.Picture.LoadFromFile(s);
           R.Width := ScalePrX(AImage.Picture.Width);
           R.Height := ScalePrY(AImage.Picture.Height);
           if R.Height > ScalePrY(AImage.Height) then
           begin
             R.Width := Trunc(R.Width * ScalePrY(AImage.Height) / R.Height);
             R.Height := ScalePrY(AImage.Height);
           end;
           ACanvas.StretchDraw(R, AImage.Picture.Graphic);
          End;
         end;
      end  //end e-signature

      Else
        begin
          R.Left := ScalePrX(AImage.Left+ADLeft);
          R.Top := ScalePrY(AImage.Top + ADTop);
          R.Right := ScalePrX(AImage.Left + ADLeft + AImage.Width);
          R.Bottom := ScalePrY(AImage.Top + ADTop + AImage.Height);
          if Pos('FLAGFRAME', UpperCase(AImage.Parent.name)) = 0 then
            PrintBitmap(ACanvas, R, AImage.Picture.Bitmap);
        end;
      end  //Timage

      else
      if AControl.Controls[i] is TFrame then
      begin //search in the frame
        MyFrame := AControl.Controls[i] as TFrame;
        for j := 0 to MyFrame.ComponentCount - 1 do
        begin
          if MyFrame.Components[j] is TImage then
          begin //print the image

            MyImage := MyFrame.Components[j] as TImage;
            //PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);

            //find left and top in ralation to form scaling
            R.Left := ScalePrX(MyFrame.Left + ADLeft);
            R.Top := ScalePrY(MyFrame.Top + ADTop);

            //consistant height and width scaling
            PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
            PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
            R.Right := R.Left + (MyImage.Picture.Width * (PixelsPerInch.x)) div ScMult; //ScalePrX(MyFrame.Width);
            R.Bottom := R.Top + (MyImage.Picture.Height * (PixelsPerInch.y)) div ScMult; //ScalePrY(MyFrame.Height);

            {                   R.Left   := ScalePrX(MyFrame.Left); //ScalePrX(MyImage.Left) +
            R.Top    := ScalePrY(MyFrame.Top);  //ScalePrY(MyImage.Top)  +
            R.Right  := R.Left +  ScalePrX(MyImage.Picture.Width); //ScalePrX(MyFrame.Width);
            R.Bottom := R.Top  +  ScalePrY(MyImage.Picture.Height); //ScalePrY(MyFrame.Height);
  }
            //showmessage('Parent: ' + MyImage.Parent.Name + ' Owner: ' + MyImage.Parent.Name);
            if Pos('FLAGFRAME', UpperCase(MyImage.Parent.name)) > 0 then
              PrintBitmap(ACanvas, R, MyImage.Picture.Bitmap);

          end;
        end;
      end //tframe

      else
      if AControl.Controls[i] is TRichEdit then //RichEdit
      begin
        ARichEdit := AControl.Controls[i] as TRichEdit;
        if Assigned(ARichEdit.Parent) then begin   // 20151016 igor
          if IsFormAClientLetter(FName) then
          begin
            GetInterpetedRichEdit(RetNo, GetLetterFileName(RetNo, FName), ARichEdit);
            Delay(50);
          end;
          PrintRichEdit(RetNo, ARichEdit, ACanvas, ADTop, ADLeft,
            IsFormAClientLetter(FName)); //20170109 Igor
        end;
      end //richedit
      else
      if AControl.Controls[i] is TMemo then //TMemo
      begin
        //AMemo:=AForm.Components[i] as TMemo;
        PrintMemo(RetNo, AControl.Controls[i] as TMemo, ACanvas, ADTop, ADLeft);
      end; //memo
    end; //i components
  End; //print controls

begin
  //  does not work
  (*
  If Printer.Orientation = poLandscape then
  begin
   ScaleX := Round(ScaleX * 3/4);
   ScaleY := Round(ScaleY * 3/2);
  end;
  *)

  //2013/03/22
  //----------------------------------------------------------------------------

  FName := UpperCase(Ltrim(RTrim(Fname)));
   //20160901 Igor >>>
//  if AbortSw then
//    exit;
  FNo := RetList[RetNo].GetFormNo(FName); //20160829 Igor
   If FNo = 0 then
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
  if (Printer.Printing) and (FastPrint = False) then
  begin
    if MessageDlg('Printer temporarily busy. Try again?',
      mtInformation, [mbYes, mbNo], 0) = mrNo then
      exit;
  end;
  WhiteBoxes := GetWhiteBoxesIndicator(FName);
  //20160829 Igor >>>

  lCurrPageisLandscape := CurrentPageIsLanscape(AForm, IsLandscape(FName), MxFrmWidth, 0, maxInt, RealHeight, RealWidth); //20170127 Igor //20170307 Igor
  //lCurrPageisLandscape := CurrentPageIsLanscape(AForm, isPageLandscape, MxFrmWidth, 0, maxInt, RealHeight, RealWidth); //jz 20240626

  if ((Printer.Orientation = poLandscape) <> lCurrPageisLandscape{IsLandscape(FName)}) then //20170127 Igor
  begin
    if Printer.Printing then
      Printer.EndDoc;

    If lCurrPageisLandscape {IsLandscape(FName)} Then  //20170127 Igor
      Printer.Orientation := poLandscape
    else
      Printer.Orientation := poPortrait;
    Printer.Title :=  GetFormRlName(FNo) + ' : ' + GetCorpName(RetNo); //20160905 Igor
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  If not Printer.Printing then
  begin
    Printer.Title :=  GetFormRlName(FNo) + ' : ' + GetCorpName(RetNo); //20160905 Igor
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  if NeedNewPage then
    Printer.NewPage;

  //20160829 Igor <<<

  if Ret[RetNo].Frm[FNo].Count = 0 then
    InitFormData(RetNo, FNo);
//  Printer.Title := GetCorpName(RetNo); //20160905 Igor

  hdc := Printer.Canvas.Handle;
  ACanvas := Printer.Canvas;

  //20121206
  DC := GetDC(MainForm.Handle);
  WinFontSize := GetDeviceCaps(DC, LOGPIXELSX);
  ReleaseDC(MainForm.Handle, DC);
  dpiAdjustment := (WinFontSize * 100) div DesignPixelsPerInch;

  hdc := Printer.Canvas.Handle;
  ACanvas := Printer.Canvas;

  CalcScaleXY(RealHeight, RealWidth); //20170307 Igor

  // If 'T1134' Summary, See PrintDynamic  //20180712

  //20180721
  If FName='CBCR' then             //original Efiled
  begin
      If (FetchElm(RetNo,Fname,569)>'')   //Efiled //do not use FNAME here
      and  (FetchElm(RetNo,Fname,604)='')  //amended
      and (FetchElm(RetNo,Fname,570)='')  //not re-transmitted
      then  //thre is Efile confirmaqtion
      begin
       PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
       PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
     end
  Else //amended
      If (FetchElm(RetNo,Fname,569)>'')   //Efiled
      and (FetchElm(RetNo,Fname,604)>'')  //amended
      and (FetchElm(RetNo,Fname,570)='')  //not re-transmitted
      then  //there is Efile confirmaqtion
      begin
       PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
     end
  //efiled after amended
  Else
    If (FetchElm(RetNo,Fname,569)>'')   //Efiled
    and (FetchElm(RetNo,Fname,604)>'')  //amended
    and (FetchElm(RetNo,Fname,570)>'')  //not re-transmitted
    then  //there is Efile confirmaqtion
      begin
       PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
       PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
     end;
  end;


    //20180721
  If LeftStr(FName,4)='T106' then             //original Efiled
  begin
      If (FetchElm(RetNo,'T106',64)>'')   //Efiled //do not use FNAME here
      and  (FetchElm(RetNo,'T106',1)='')  //amended
      and (FetchElm(RetNo,'T106',63)='')  //not re-transmitted
      then  //thre is Efile confirmaqtion
      begin
          PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
          PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
      end
      Else //amended
        If (FetchElm(RetNo,'T106',64)>'')   //Efiled
        and (FetchElm(RetNo,'T106',1)>'')  //amended
        and (FetchElm(RetNo,'T106',63)='')  //not re-transmitted
        then  //there is Efile confirmaqtion
        begin
          PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
       end
      //efiled after amended
      Else
        If (FetchElm(RetNo,'T106',64)>'')   //Efiled
        and (FetchElm(RetNo,'T106',1)>'')  //amended
        and (FetchElm(RetNo,'T106',63)>'')  //not re-transmitted
        then  //there is Efile confirmaqtion
        begin
          PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
          PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
        end;
  end;


  //20160712
  If LeftStr(FName,7)='T1134S#' then             //original Efiled
  begin
      If (FetchElm(RetNo,'T1134',26)>'')   //Efiled //do not use FNAME here
      and  (FetchElm(RetNo,'T1134',99)='')  //amended
      and (FetchElm(RetNo,'T1134',27)='')  //not re-transmitted
      then  //thre is Efile confirmaqtion
      begin
       PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
       PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
     end
  Else //amended
      If (FetchElm(RetNo,'T1134',26)>'')   //Efiled
      and (FetchElm(RetNo,'T1134',99)>'')  //amended
      and (FetchElm(RetNo,'T1134',27)='')  //not re-transmitted
      then  //there is Efile confirmaqtion
      begin
       PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
     end
  //efiled after amended
  Else
    If (FetchElm(RetNo,'T1134',26)>'')   //Efiled
    and (FetchElm(RetNo,'T1134',99)>'')  //amended
    and (FetchElm(RetNo,'T1134',27)>'')  //not re-transmitted
    then  //there is Efile confirmaqtion
      begin
       PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
       PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
     end;
  end;

  // 20250709 Igor >>>
  if FName.Equals('T217') or
     (LeftStr(FName, 4) = 'UHT#')
  then
  begin
    if (LeftStr(FName, 4) = 'T217') then
    begin
      efiledElmNo:= 59;
      amendedElmNo:= 23;
      refiledElmNo:= 61;
    end;
    if (LeftStr(FName, 4) = 'UHT#') then
    begin
      efiledElmNo:= 59;
      amendedElmNo:= 1;
      refiledElmNo:= 61;
    end;

    if not FetchElm(RetNo, Fname, efiledElmNo).IsEmpty and
        FetchElm(RetNo, Fname, amendedElmNo).IsEmpty and
        FetchElm(RetNo, Fname, refiledElmNo).IsEmpty then
    begin
      PrintAtAngle('DUPLICATE', ACanvas, 180, Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 50, 240);
      PrintAtAngle('DO NOT SEND BY MAIL', ACanvas, 300, Trunc(Printer.PageHeight - (Printer.PageHeight / 3) + (Printer.PageHeight / 9) - 200), 50, 240);
    end else //amended
    if not FetchElm(RetNo, Fname, efiledElmNo).IsEmpty and
       not FetchElm(RetNo, Fname, amendedElmNo).IsEmpty and
       FetchElm(RetNo, Fname, refiledElmNo).IsEmpty and
       not FName.Equals('T217') then
    begin
      PrintAtAngle('AMENDED ON ' + FormatDateTime('yyyy-mm-dd', Date), ACanvas, 180, Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 50, 240);
    end else //refiled
    if not FetchElm(RetNo, Fname, efiledElmNo).IsEmpty and
       not FetchElm(RetNo, Fname, amendedElmNo).IsEmpty and
       not FetchElm(RetNo, Fname, refiledElmNo).IsEmpty and
       not FName.Equals('T217') then
    begin
      PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180, Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 25, 240);
      PrintAtAngle('SENT ON ' + FormatDateTime('yyyy-mm-dd', Date) + '-DO NOT SEND BY MAIL', ACanvas, 300, Trunc(Printer.PageHeight - (Printer.PageHeight / 3) + (Printer.PageHeight / 9) - 200), 25, 240);
    end;
  end;
  // 20250709 Igor <<<

 //20170212 Igor<<<
  //If UpperCase(LeftStr(LicenseLevel,7)) = 'T1 DEMO' then {demo}
  if LicenseLevel = llDEMO then {demo}
  begin
    PrintAtAngle('For Demo Purposes Only', ACanvas, 200, Printer.PageHeight div 2 - 100, 30, 100)
  end
  else //production  //20121213
  begin
    // If (LeftStr(FName,5) = 'T2038') then
   // PrintAtAngle('D R A F T',ACanvas, 200,Printer.PageHeight div 2-100,100,100);  //20130115
  end;


  //----------------------------------------------------------------------------

  if LicenseLevel = llDemo then {demo}
  begin
    PrintAtAngle('For Demo Purposes Only', ACanvas, 200, Printer.PageHeight div 2 - 100, 30, 100)
  end
  else
  begin
  end;
  //20161212 Igor >>>
  if isDraft then
    PrintAtAngle('D R A F T',ACanvas, 200,Printer.PageHeight div 2-100,100,100);


  //20161212 Igor <<<
  {Print Form Header}
  ACanvas.Font.size := 8;
  {remove switches later}

  {Print Header}
  ACanvas.Brush.Style := bsClear; //20230522 Igor
  if (OptRec.Prn_NameH) and (IsShowHdrIndicator(FName)) then
    ACanvas.TextOut(ScalePrX(10), ScalePrY(0), GetRetName(RetNo));
  if (OptRec.Prn_DateH) and (IsShowHdrIndicator(FName)) then
    ACanvas.TextOut(
      ScalePrX(270), ScalePrY(0), ' Date: ' + DateToMonthDayYear(Date));
  if ShowFieldIdSw then
    ACanvas.TextOut(ScalePrX(400), ScalePrY(0), FName)
  else if (OptRec.Prn_SinH) and (IsShowHdrIndicator(FName)) then
    ACanvas.TextOut(ScalePrX(535), ScalePrY(0), ' BN: '+ LeftStr(GetCorpBusNo(RetNo),9)); //20230522
  //If IsShowHdrIndicator(FName) then
  if ((OptRec.Prn_NameH)
    or (OptRec.Prn_DateH)
    or (OptRec.Prn_SinH))
    and IsShowHdrIndicator(FName) then
  begin
    ACanvas.MoveTo(ScalePrX(10), ScalePrY(12)); //20170212 Igor
    ACanvas.LineTo(ScalePrX(610), ScalePrY(12)) //20170212 Igor  //20231022
  end;

  PrintControls(AForm, 0, 0); //20160407 Igor

   If FastPrint=True then
     NeedNewPage := True
   else
     Printer.EndDoc;
   //20160829 Igor <<<
end;

procedure AfterReadComponentForPrint(AForm: TForm; FName: string);
var
  i: Integer; //AImage:TImage;
CONST
  pxl = 96; //20160204 Igor
begin
  if IsFormAClientLetter(FName) then
  begin
    //get the image
    for i := 0 to AForm.ComponentCount - 1 do
    begin
{$IFDEF NOP}
      AImage := nil;
      if aForm.Components[i] is TImage then
      begin
        if UpperCase((aForm.Components[i] as TImage).Name) = 'LOGOIMAGE' then
        begin
          AImage := AForm.Components[i] as TImage;
        end;
      end;
{$ELSE}
{$ENDIF}
      if aForm.Components[i] is TPanel then
        (aForm.Components[i] as TPanel).Visible := False;

      If (aForm.Components[i] is TRichEdit) AND //20160819 igor
         ((aForm.Components[i] as TRichEdit).align = alClient) then //20160203 Igor //20160819 igor
      Begin
        with TRichEdit(aForm.Components[i]) do //20160819 igor
        Begin
          Align := alNone;

          SetBounds(ROUND(MainOptions.Prn_LMargin*pxl),Top,
            Width - ROUND(MainOptions.Prn_LMargin*pxl) - ROUND(MainOptions.Prn_RMargin*pxl),Height); //20160204 Igor
        end;
      end;
    end;
  end;
end;

procedure PrintvtMemoBox(RetNo: Integer; MyMemoBox: TvtMemo; FName: string;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0);
var
  i, MNo, memolineCount, spacer, spacerIncAmount, FieldId, FInst: integer;
  Astring: string;
  S60Spacer: Integer;
  R: TRect;
begin
  (* Use TextRec (DrawText?) for TextOut?
  *)
  spacer := 0;
  spacerIncAmount := 13; //20101130  //11
  S60Spacer := 13; //20101130

  //FieldId:=GetFieldId(MyMemoBox.Name);
  ACanvas.Font.Name := DefFontName;
  if Fname = 'FNOTE2' then //20101126
    ACanvas.Font.Name := MyMemoBox.Font.Name;

  ACanvas.Font.Size := 8; //6;   //20101129
  ACanvas.Font.Style := []; //20161212 Igor
  if LeftStr(Fname, 4) = 'S60#' then //20101130
  begin
    ACanvas.Font.Name := 'Arial';
    ACanvas.Font.Size := 9;
  end;
  if FName = 'FNOTE2' then
    ACanvas.Font.Size := 8; //20090610
  //ACanvas.Brush.Color := clWhite;
  ACanvas.Brush.Style := bsClear;

  R.Left := MyMemoBox.Left + ADLeft;
  R.Top := MyMemoBox.Top + ADTop;
  R.Right := MyMemoBox.Left+ ADLeft + MyMemoBox.Width;
  R.Bottom := MyMemoBox.Top + ADTop + MyMemoBox.Height;

  if PauseSw then
    PausePrinting;

  if ShowFieldIdSw then
  begin
    Astring := '[' + IntToStr(FieldId) + 'm]';
    ACanvas.Textout(ScalePrX(R.Left), ScalePrY(R.Top), Astring);
    exit; //all done?
  end;

  MNo := GetFieldId(MyMemoBox.Name);
  MyMemoBox.Text := Ret[RetNo].Frm[FNo].Memos[MNo]; //.GifiNotesMemo;
  if MyMemoBox.Text = '' then
    exit; //really empty

  //problem with Lines.Count!
  if MyMemoBox.Lines.Count = 0 then
  begin //sync memo
    //MyMemoBox.Lines.Text := Ret[RetNo].Frm[FNo].Memos[MNo]; //.GifiNotesMemo;
    SomeList.Text := MyMemoBox.Text;
    MyMemoBox.Lines.Assign(SomeList);
    if MyMemoBox.Lines.Count = 0 then
      ErrorMsg('wrong line count: ' + IntToStr(SomeList.Count));
  end;

  memolineCount := 0;

  if FName = 'FNOTE2' then //20121002
  begin
    if UpperCase(MyMemoBox.Name) = 'VTMEMOBOX1' then
    begin
      //MyMemoBox.Text := Ret[RetNo].GifiNotesMemo;
      begin
        for i := 0 to MyMemoBox.Lines.count - 1 do
        begin
          AString := MyMemoBox.Lines[i];
          ACanvas.Textout(ScalePrX(R.Left), ScalePrY(R.Top + spacer), Astring);
          inc(spacer, spacerIncAmount);
          inc(memolineCount, 1);
          if (memolineCount = 74) and (i <> MyMemoBox.Lines.count - 1) then
          begin
            printer.newpage;
            spacer := 0;
            memolineCount := 0;
          end;
        end;
      end; //with
    end;
  end
  else //all other memo boxes
    //if LeftStr(FName,3) = 'S60' then
  begin
    for i := 0 to MyMemoBox.Lines.count - 1 do
    begin
      Astring := MyMemoBox.Lines[i];
      ACanvas.Textout(ScalePrX(R.Left), ScalePrY(R.Top + spacer), Astring);
      inc(spacer, S60Spacer);
    end;
  end;
end;

procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: string; FNo: Integer;
  hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0;
  AisSynPDF: Boolean = False); //20161211 Igor
var
  FieldId: Integer;
  R: TRect;
  aString, s: string;
  FormattedAmount: string;
  x, y: LongInt;
  PenWidth: Integer;
  AlignTopBottomVar, tempPos: Integer;
  MyEditHandle: THandle;
  HowToFormat: Integer;
  n: Integer;
  i: Integer;
  TextMargin: Integer; //20161212 Igor
  nPrintTextHeight: integer; //20180126 Igor
  //20180221 Igor >>>
  WrapTextRect: TRect;
  DrawStyle: Word;
  //20180221 Igor <<<
begin
  //20161212 Igor >>>
  if AisSynPDF then
    TextMargin := 2
  else
    TextMargin := 6;
  //20161212 Igor <<<
  FieldId := GetFieldId(MyEditBox.Name);
  //  If (Fname='T2') and (fieldid=725) then showmessage('disclaimer');
  //20161211 Igor>>>
  if not AisSynPdf then
    ACanvas.Font.Size := MyEditBox.Font.Size + MainOptions.Prn_FontIncr //9; //10
  else
    ACanvas.Font.Size := MyEditBox.Font.Size;
  //20161211 Igor <<<
  if leftStr(Fname, 1) = 'O' then
    ACanvas.Font.Size := ACanvas.Font.Size + 1;
  ACanvas.Font.Color := MyEditBox.Font.Color;
  ACanvas.Font.Style := MyEditBox.Font.Style;
  R.Left := MyEditBox.Left + ADLeft;
  R.Top := MyEditBox.Top + ADTop;
  R.Right := MyEditBox.Left + ADLeft + MyEditBox.Width;
  R.Bottom := MyEditBox.Top + ADTop + MyEditBox.Height;

  //If LeftStr(Fname,5)='T4SUM' then  ACanvas.Font.Name := 'Courier New' else
  ACanvas.Font.Name := DefFontName;
  ACanvas.Brush.Style := bsClear;

  if PauseSw then
    PausePrinting;

  if ShowFieldIdSw then
  begin
    if MyEditBox.vtInputType = vtDollar then
      Astring := '[' + IntToStr(FieldId) + 'n]'
    else
      Astring := '[' + IntToStr(FieldId) + ']';

    if (MyEditBox.Visible) or
      (ShowFieldIdSw = True) then
      ACanvas.Textout(
        ScalePrX(MyEditBox.Left + ADLeft),
        ScalePrY(MyEditBox.Top + ADTop + 2),
        Astring);
  end
  else
  begin
    with MyEditBox do
    begin
      //fill the editbox with color--------------------------------
      if MyEditBox.Color <> clwhite then
      begin
        ACanvas.Pen.Width := 0;
        ACanvas.Pen.Style := psClear;
        ACanvas.Brush.Style := bsSolid;
        ACanvas.Brush.Color := PrintShade; //RGB(238,238,238); //MyEditBox.Color;
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom));
      end;
      //fill the editbox withcolor---------------------------------

      //ACanvas.Pen.Width := MyEditBox.vtPenThickness;
      ACanvas.Brush.Style := bsClear;
      ACanvas.Pen.Style := psSolid;
      ACanvas.Pen.Color := clBlack;
      if vtInputType = vtDollar then
      begin
        HowToFormat := GetHowToFormat(FName, FieldId);
        Text := FormatAmount(FName, Ret[RetNo].Frm[FNo].Strings[FieldId], HowToFormat);
        if leftstr(Text, 2) = '0 ' then
          Text := ' ' + midstr(Text, 3, 20);
        if Vl(Text) = 0 then
          Text := '';
        if leftstr(text, 1) = ' ' then
          text := '0' + text; //2005 to retain space and 0.78
        if Fname = 'S511' then //20120531
        begin
          case FieldId of
            6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 66, 70, 74, 78, 82: if (FetchElmFNo(RetNo, FNo, FieldId - 2) > '') and (Vl(FetchElmFNo(RetNo, FNo, FieldId)) = 0) then
                text := '0';
            7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 79, 83: if (FetchElmFNo(RetNo, FNo, FieldId - 2) > '') and (Vl(FetchElmFNo(RetNo, FNo, FieldId)) = 0) then
                text := '0';
          end; //case;
          {
           i:=4;
           Repeat
            If (FetchElmFNo(RetNo,FNo,i)>'') and (Vl(FetchElmFNo(RetNo,FNo,i+2))=0) then Text:='0';
            If (FetchElmFNo(RetNo,FNo,i)>'') and (Vl(FetchElmFNo(RetNo,FNo,i+3))=0) then Text:='0';
            Inc(i,4)
           until i>80;
           }
        end;

        if leftstr(Fname,6) = 'T106SL' then //20241212 show 0 if calc done, as per cra email during T106 cert
        begin
          if FieldId = 114 then
          begin
            //showmessage('114:' + FetchElm(RetNo,Fname,114) + '> 111:' + FetchElm(RetNo,Fname,111) + '> 112:' + FetchElm(RetNo,Fname,112) + '> 113:' + FetchElm(RetNo,Fname,113));
            if FetchElm(RetNo,Fname,114) = '' then
            begin
              if (FetchElm(RetNo,Fname,111)>'') or (FetchElm(RetNo,Fname,112)>'') or (FetchElm(RetNo,Fname,113)>'') then
                begin text := '0'; end;
            end;
          end
          else if FieldId = 118 then
          begin
            if (FetchElm(RetNo,Fname,118)='') and (  (FetchElm(RetNo,Fname,115)>'')  or
                                                        (FetchElm(RetNo,Fname,116)>'') or
                                                        (FetchElm(RetNo,Fname,117)>'')  )then begin text := '0'; end;
          end;
        end;

      end
      else if vtInputType = vtSin then
        Text := reFormatSin(Ret[RetNo].Frm[FNo].Strings[FieldId])
      else
        Text := AllTrim(Ret[RetNo].Frm[FNo].Strings[FieldId]); //20111127
      //else Text := Ret[RetNo].Frm[FNo].Strings[FieldId];

      if Length(Text) > 60 then
        vtAlignment := taLeftJustify; //20111127

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
        if vtAlignment = taLeftJustify then //set to leftjustify above if text >60
        begin
          if ((FName = 'INVOICE') or (LeftStr(FName, 4) = 'NPAD') //???
            or (LeftStr(FName, 6) = 'PRIVAT')) //20120201 //20120124
          or ((FName = 'T2') and ((FieldId = 65) or (FieldId = 3) or (FieldId = 725))) {//20130205} then
          begin
            ACanvas.Textout(ScalePrX(R.Left) + TextMargin, AlignTopBottomVar, Text) //normal print //20161212 Igor
          end
          else begin
            //20190225 Igor >>>
            if ACanvas.TextWidth(Text) > (ScalePrX(R.Right) - ScalePrX(R.Left)) then //20121129
            begin
              if FName = 'T2' then
                ACanvas.Font.Size := 8
              else
                ACanvas.Font.Size := 7;
              WrapTextRect.Left := ScalePrX(R.Left) + TextMargin;
              WrapTextRect.Top := AlignTopBottomVar;
              WrapTextRect.Width := ScalePrX(R.Right) - ScalePrX(R.Left);
              WrapTextRect.Height := ScalePrX(R.Bottom) - ScalePrX(R.Top);
              DrawText(ACanvas.Handle, PChar(Text), Length(Text), WrapTextRect, DT_LEFT or DT_END_ELLIPSIS);

              //ACanvas.Textout(ScalePrX(R.Left) + TextMargin, AlignTopBottomVar, LeftStr(Text, 60) + '...'); //20161212 Igor
            end
            //20190225 Igor <<<
            else
              ACanvas.Textout(ScalePrX(R.Left) + TextMargin, AlignTopBottomVar, Text) //normal print
          end;
        end
        else if vtAlignment = taRightJustify then
        begin
          //ACanvas.Textout(ScalePrX(R.Right) - ACanvas.TextWidth(Text) - TextMargin - 1, AlignTopBottomVar, Text) //20161212 Igor
          ACanvas.Textout(ScalePrX(R.Right) - ACanvas.TextWidth(Text) - TextMargin - 4, AlignTopBottomVar, Text) //20180522 CON
        end
        else if vtAlignment = taCenter then
        begin
          tempPos := ((ScalePrX(R.Right) - ScalePrX(R.Left)) - ACanvas.TextWidth(Text)) div 2;
          ACanvas.Textout(ScalePrX(R.Left) + tempPos, AlignTopBottomVar, Text)
        end;
      end;
      //20180221 Igor >>>

      //add vertSeporator and paint prefix if vtDollar
      if vtinputType = vtDollar then
      begin
        ACanvas.Textout(ScalePrX(R.Left+2), AlignTopBottomVar, vtPrefix); //20180522
        //ACanvas.Textout(ScalePrX(R.Left), AlignTopBottomVar, vtPrefix); //20120118
      end;
      //20090526
      if UpperCase(AllTrim(MyEditBox.Text)) = UpperCase(RSIApprovalCode) then //'VT19' then
        MyEditBox.vtBorderType := VtNoBorder;
      if MyEditBox.vtBorderType = vtNoBorder then
      begin
        //
      end
      else if MyEditBox.vtBorderType = vtFull then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness * 2;
        ACanvas.Brush.Style := bsClear;
        //20161211 Igor >>>
        if not AIsSynPDF then
          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom))
        else
        begin
          ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
          ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
          ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
          ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
          ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
          ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Top));
        end;
        //20161211 Igor <<<
      end
      else if MyEditBox.vtBorderType = vtsides then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        //20161211 Igor
        if not AIsSynPDF then
        begin
          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Left) + 1, ScalePrY(R.Bottom)); //R.Left, R.Top, R.Left + 1, R.Bottom);
          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom), ScalePrX(R.Right), ScalePrY(R.Bottom) - 1); //R.Left, R.Bottom, R.Right, R.Bottom - 1);
          ACanvas.Rectangle(ScalePrX(R.Right) - 1, ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom)); //R.Right - 1, R.Top, R.Right, R.Bottom);
        end
        else
        begin
          ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
          ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
          ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
          ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
          ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
        end;
        //20161211 Igor<<<
      end
      else if MyEditBox.vtBorderType = vtUnderline then
      begin
        ACanvas.Pen.Width := 1;
        ACanvas.Pen.Mode := pmCopy;
        ACanvas.Pen.Color := clBlack;
        //20161211 Igor >>>
        if not AIsSynPDF then 
        begin
          ACanvas.Brush.Color := clBlack;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) + 1, ScalePrX(R.Right), ScalePrY(R.Bottom) + 2 + MyEditBox.vtPenThickness);
        end
        else
        begin
          ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
          ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
          ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
        end;
        //20161211 Igor <<<
      end
      else if MyEditBox.vtBorderType = vtDoubleUnderLine then
      begin
        ACanvas.Pen.Width := 1;
        //20161211 Igor >>>
        if not AIsSynPDF then
        begin
          ACanvas.Pen.Mode := pmCopy;
          ACanvas.Pen.Color := clBlack;
          ACanvas.Brush.Color := clBlack;
          ACanvas.Brush.Style := bsSolid;

          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) + 1, ScalePrX(R.Right), ScalePrY(R.Bottom) + 2 + MyEditBox.vtPenThickness);
          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) + 10, ScalePrX(R.Right), ScalePrY(R.Bottom) + 11 + MyEditBox.vtPenThickness);
        end
        else
        begin
          ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
          ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
          ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
          ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom)+1);
          ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom)+1);
        end;
        //20161211 Igor <<<
      end
      else if MyEditBox.vtBorderType = vtTopBottomLine then
      begin
        ACanvas.Pen.Width := MyEditBox.vtPenThickness;
        ACanvas.Brush.Style := bsClear;
        //20161211 Igor >>>
        if not AIsSynPDF then
        begin
          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) - 1, ScalePrX(R.Right), ScalePrY(R.Bottom));
          ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top) + 1, ScalePrX(R.Right), ScalePrY(R.Top));
        end
        else
        begin
          ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
          ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Top));
          ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Top));
          ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
          ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
        end;
        //20161211 Igor <<<
      end;
    end; //with MyEditBox
  end; //else

  // Draw review marks
  if ReviewOn(RetNo, FNo, FieldId) then
  begin
    DrawingTool := dtEllipse;
    PenWidth := 3;
    ACanvas.Brush.Style := bsClear;
    DrawShape(Point(ScalePrX(R.Left - 7), ScalePrY(R.Top - 5)),
      Point(ScalePrX(R.Right + 7), ScalePrY(R.Bottom + 7)), PenWidth, ACanvas);
  end;

  ACanvas.Font.Style := [];
end;

procedure PrintBarcodeBitmap(RetNo: Integer; Canvas: TCanvas; BarCodeImage1: TImage;
  BarCodeImage2: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);
var
  PixelsPerInch: TPoint;
  Ht, Wt: Real;
  d: integer;
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

             R.Left:=ScalePrX(BarCodeImage1.Left + ADLeft);
             R.Top:=ScalePrY(BarCodeImage1.Top + ADTop);
             R.Right:=ScalePrX(BarCodeImage1.Left+ADLeft+BarCodeImage1.Width);
             R.Bottom:=ScalePrY(BarCodeImage1.Top+ADTop+BarCodeImage1.Height);

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

procedure PrintSFDBarcodeBitmap(RetNo: Integer; Canvas: TCanvas; SFDBarCodeImage1: TImage;
  SFDBarCodeImage2: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);
var
  PixelsPerInch: TPoint;
  Ht, Wt: Real;
  i, d: integer;
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

             R.Left:=ScalePrX(SFDBarCodeImage1.Left+ADLeft);
             R.Top:=ScalePrY(SFDBarCodeImage1.Top + ADTop);
             R.Right:=ScalePrX(SFDBarCodeImage1.Left+ADLeft+SFDBarCodeImage1.Width);
             R.Bottom:=ScalePrY(SFDBarCodeImage1.Top+ADTop+SFDBarCodeImage1.Height);

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

Procedure PrintDynamicForm(RetNo:Integer;FName:String); //20230411 Igor
Var
  i, j, p, footerIdx, oldTop, CurrPage, TotalPages: integer;
  ACanvas:TCanvas;
  DfmFileName:String;
  hdc: THandle;
  s: String;
  FNo:Integer;
  //MyChild:TMyChild;
  F: TForm;
  MyScrollBox:TvtScrollBox;
  R : TRect;       //20160608 Igor
  PixelsPerInch: TPoint; //20160608 Igor
  MyFrame: TFrame;//20160608 Igor
  MyImage: TImage;//20160608 Igor

  efiledElmNo,amendedElmNo,refiledElmNo :integer; //JZ//20250706

  function PrepareLabelText(AText: string): string;
  begin
    Result := ReplaceStr(AText, '[#page]', IntToStr(CurrPage));
    Result := ReplaceStr(Result, '[#pagecount]', IntToStr(TotalPages));
  end;

  procedure PrintControls(APageBreak, ANextPageBreak: TPageBreak);
  var i, j, OldLeft, OldTop: integer;
      OldCaption: string;
  begin
    for i := 0 to MyScrollBox.ControlCount - 1 do
    begin
      if ( (MyScrollBox.Controls[i].Top + MyScrollBox.Controls[i].Height) >= APageBreak.Pos  ) and //20160404 igor
         ( (MyScrollBox.Controls[i].Top + MyScrollBox.Controls[i].Height) < ANextPageBreak.Pos )     //20160404 igor
      then
      begin
        OldTop := MyScrollBox.Controls[i].Top;
        OldLeft := MyScrollBox.Controls[i].Left;
        if APageBreak.IsFooter then
        begin
          if APageBreak.Width <> PrinterPageWidth then
            MyScrollBox.Controls[i].Left := Trunc(MyScrollBox.Controls[i].Left * PrinterPageWidth / APageBreak.Width);
          MyScrollBox.Controls[i].Top := PrinterPageHeight - (ANextPageBreak.Pos - MyScrollBox.Controls[i].Top)
        end
        else
          MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - APageBreak.Pos; //20160404 Igor
        if (MyScrollBox.Controls[i] is TvtEdit) AND
           (MyScrollBox.Controls[i] as TvtEdit).vtIsPrintable then
        begin

          PrintEditBox(RetNo,MyScrollBox.Controls[i] as TvtEdit,FName,FNo,hdc,ACanvas); //PrintEditBox(RetNo,AvtEditBox,FName,FNo,hdc,ACanvas);
        end; //tvedit
        if (MyScrollBox.Controls[i] is TvtLabel) AND
           (MyScrollBox.Controls[i] as TvtLabel).vtIsPrintable  then
        begin
          OldCaption := TvtLabel(MyScrollBox.Controls[i]).Caption;
          TvtLabel(MyScrollBox.Controls[i]).Caption := PrepareLabelText(TvtLabel(MyScrollBox.Controls[i]).Caption);
          PrintLabel(MyScrollBox.Controls[i] as TvtLabel,ACanvas);
          TvtLabel(MyScrollBox.Controls[i]).Caption := OldCaption;
        end;
        //20160905 Igor >>>
        if MyScrollBox.Controls[i] is TRichEdit then //RichEdit
        begin
          if Assigned((MyScrollBox.Controls[i] as TRichEdit).Parent) then
          begin

            PrintRichEdit(RetNo, (MyScrollBox.Controls[i] as TRichEdit), ACanvas);
          end;
        end; //richedit
        //20160905 Igor <<<

        if (MyScrollBox.Controls[i] is TvtShape) AND
           (MyScrollBox.Controls[i] as TvtShape).vtIsPrintable then
        begin

          PrintVtShape(MyScrollBox.Controls[i] As TvtShape,ACanvas);
        end;
        //20160608 Igor >>>>>
        if MyScrollBox.Controls[i] is TImage then
        begin

          //E_sign
           //20200421 Igor >>>
          MyImage := (MyScrollBox.Controls[i] as TImage);
          if (UpperCase(MyImage.Name)= 'E_SIGNATUREHOLDER') then
          begin
            if UpperCase(FetchElm(RetNo,'T2',270)) ='Y' then  //20200326
            begin
              s:=GetSignatureFilePath(RetNo);
              If s>'' then
              Begin
                R.Left := ScalePrX(MyImage.Left);  //20160407 Igor
                R.Top := ScalePrY(MyImage.Top);      //20160407 Igor
                MyImage.Picture.LoadFromFile(s);
                R.Width := ScalePrX(MyImage.Picture.Width);
                R.Height := ScalePrY(MyImage.Picture.Height);
                if R.Height > ScalePrY(MyImage.Height) then
                begin
                  R.Width := Trunc(R.Width * ScalePrY(MyImage.Height) / R.Height);
                  R.Height := ScalePrY(MyImage.Height);
                end;
                ACanvas.StretchDraw(R, MyImage.Picture.Graphic);
              end;
            end;
            continue;
          end;
          //20200421 Igor <<<

          with MyScrollBox.Controls[i] as TImage do
          begin
            R.Left := ScalePrX(Left);
            R.Top := ScalePrY(Top);
            R.Right := ScalePrX(Left + Width);
            R.Bottom := ScalePrY(Top + Height);
            PrintBitmap(ACanvas, R, (MyScrollBox.Controls[i] as TImage).Picture.Bitmap);
          end;
        end;
        if MyScrollBox.Controls[i] is TFrame then
        begin //search in the frame
          MyFrame := MyScrollBox.Controls[i] as TFrame;
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

        MyScrollBox.Controls[i].Top := OldTop;
        MyScrollBox.Controls[i].Left := OldLeft;
      end;
      //20160608 Igor <<<<<
    end;  //For ControlCount
  end;

begin
  FNo:=GetFormNo(FName);
  DfmFileName:=GetDFMFileName(FName);
  If not FileExists(DfmFileName) then
  Begin
    ShowMessage('DFM File problem ='+DfmFileName);
    Exit;
  end;

  F := TForm.Create(Application); //20160407 Igor
  F.visible := False; //20160407 Igor
  MyScrollBox := TFormT2_2027.Create(F,RetNo,FNo);  //20150817 //20160407 Igor
  ReadComponentResFile(DfmFileName,MyScrollBox);
  //MyScrollBox.Rescale(100, DfmFileName); //???
  MyScrollBox.AfterOpenForm(vtdPrint); //20160407 Igor

  for i := 0 to MyScrollBox.ControlCount - 1 do
  begin
    //20160905 igor >>>
    If MyScrollBox.Controls[i] is TRichEdit then
      IncRichEditFontSize(TRichEdit(MyScrollBox.Controls[i]), 2 * MainOptions.Prn_FontIncr,
        IsFormAClientLetter(FName)); //20170204 Igor
    //20160905 igor <<<
  end;

  MyScrollBox.PrepareDynamicFormForPrint(IsLandscape(FName));

  if Printer.Printing then
    Printer.EndDoc;
  Printer.Orientation := MyScrollBox.PagebreakPos[0].Orientation;
  CalcScaleXY;
  Printer.Title :=  GetFormRlName(FNo) + ' : ' + GetCorpName(RetNo);
  Printer.BeginDoc;
  hdc := Printer.Canvas.Handle;
  ACanvas := Printer.Canvas;
  ACanvas.Brush.Style := bsClear;
  ACanvas.Font.Color := clBlack;

  TotalPages := 0;
  for p := 0 to high(MyScrollBox.PagebreakPos) - 1 do
    if not MyScrollBox.PagebreakPos[p].IsFooter then
      inc(TotalPages);

  CurrPage := 1;
  for p := 0 to high(MyScrollBox.PagebreakPos) - 1 do
  begin
    if MyScrollBox.PagebreakPos[p].IsFooter then continue;

    if (Printer.Orientation <> MyScrollBox.PagebreakPos[p].Orientation) then
    begin
      if Printer.Printing then
        Printer.EndDoc;
      Printer.Orientation := MyScrollBox.PagebreakPos[p].Orientation;
      Printer.Title :=  GetFormRlName(FNo) + ' : ' + GetCorpName(RetNo);
      Printer.BeginDoc;
      CalcScaleXY;
    end
    else if p > 0 then
      Printer.NewPage;

    // print of first page
    if p = 0 then
    BEGIN

      //JZ//20250706 - T2054 SERS WATERMARK -->
      If FName='T2054' then             //original Efiled
      BEGIN
            efiledElmNo  :=89;
            amendedElmNo :=19;
            refiledElmNo :=18;

            If (FetchElm(RetNo,Fname,  efiledElmNo)>'')    //Efiled //do not use FNAME here
            and  (FetchElm(RetNo,Fname,amendedElmNo)='')  //amended
            and (FetchElm(RetNo,Fname, refiledElmNo)='')   //not re-transmitted
            then  //thre is Efile confirmaqtion
            begin
               PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);
               PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);
            end
            Else //amended
              If (FetchElm(RetNo,Fname,  efiledElmNo)>'')   //Efiled
              and (FetchElm(RetNo,Fname, amendedElmNo)>'')  //amended
              and (FetchElm(RetNo,Fname, refiledElmNo)='')  //not re-transmitted
              then  //there is Efile confirmaqtion
              begin
               PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);
            end
            //efiled after amended
            Else
              If (FetchElm(RetNo,Fname,  efiledElmNo)>'')   //Efiled
              and (FetchElm(RetNo,Fname, amendedElmNo)>'')  //amended
              and (FetchElm(RetNo,Fname, refiledElmNo)>'')  //not re-transmitted
              then  //there is Efile confirmaqtion
              begin
               PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);
               PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);
              end;
      END;//JZ//20250706 - T2054 SERS WATERMARK - END

      // 20250709 Igor >>>
      if (LeftStr(FName, 5) = 'T2057') or
         FName.Equals('T2058') or
         FName.Equals('T2059') or
         (LeftStr(FName, 4) = 'UHT#')
      then
      begin
        if (LeftStr(FName, 5) = 'T2057') then
        begin
          efiledElmNo:= 59;
          amendedElmNo:= 5;
          refiledElmNo:= 61;
        end;
        if (LeftStr(FName, 5) = 'T2058') then
        begin
          efiledElmNo:= 89;
          amendedElmNo:= 6;
          refiledElmNo:= 65;
        end;
        if (LeftStr(FName, 5) = 'T2059') then
        begin
          efiledElmNo:= 59;
          amendedElmNo:= 5;
          refiledElmNo:= 61;
        end;
        if (LeftStr(FName, 4) = 'UHT#') then
        begin
          efiledElmNo:= 59;
          amendedElmNo:= 1;
          refiledElmNo:= 61;
        end;

        if not FetchElm(RetNo, Fname, efiledElmNo).IsEmpty and
            FetchElm(RetNo, Fname, amendedElmNo).IsEmpty and
            FetchElm(RetNo, Fname, refiledElmNo).IsEmpty then
        begin
          PrintAtAngle('DUPLICATE', ACanvas, 180, Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 50, 240);
          PrintAtAngle('DO NOT SEND BY MAIL', ACanvas, 300, Trunc(Printer.PageHeight - (Printer.PageHeight / 3) + (Printer.PageHeight / 9) - 200), 50, 240);
        end else //amended
        if not FetchElm(RetNo, Fname, efiledElmNo).IsEmpty and
           not FetchElm(RetNo, Fname, amendedElmNo).IsEmpty and
           FetchElm(RetNo, Fname, refiledElmNo).IsEmpty then
        begin
          PrintAtAngle('AMENDED ON ' + FormatDateTime('yyyy-mm-dd', Date), ACanvas, 180, Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 50, 240);
        end else //refiled
        if not FetchElm(RetNo, Fname, efiledElmNo).IsEmpty and
           not FetchElm(RetNo, Fname, amendedElmNo).IsEmpty and
           not FetchElm(RetNo, Fname, refiledElmNo).IsEmpty then
        begin
          PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180, Trunc(Printer.PageHeight - (Printer.PageHeight / 3)), 25, 240);
          PrintAtAngle('SENT ON ' + FormatDateTime('yyyy-mm-dd', Date) + '-DO NOT SEND BY MAIL', ACanvas, 300, Trunc(Printer.PageHeight - (Printer.PageHeight / 3) + (Printer.PageHeight / 9) - 200), 25, 240);
        end;
      end;
      // 20250709 Igor <<<


      //20160712
      If FName='T1134' then             //original Efiled
      BEGIN
        If (FetchElm(RetNo,'T1134',26)>'')   //Efiled already
          and  (FetchElm(RetNo,'T1134',99)='')  //amended
          and (FetchElm(RetNo,'T1134',27)='')  //not re-transmitted
          then  //thre is Efile confirmaqtion
        begin
           PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
           PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
        end
        Else
          If (FetchElm(RetNo,'T1134',26)>'')    //Efiled
          and (FetchElm(RetNo,'T1134',99)>'')  //amended
          and (FetchElm(RetNo,'T1134',27)='')  //not re-transmitted
          then  //there is Efile confirmaqtion
          begin
            PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
        end
        //efiled after amended
        Else
          If (FetchElm(RetNo,'T1134',26)>'')  //efiled
          and (FetchElm(RetNo,'T1134',99)>'')  //amended
          and (FetchElm(RetNo,'T1134',27)>'')  //Re-transmitted after amended
          then  //there is Efile confirmaqtion
          begin
            PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
            PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
         end;
      END;

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

    END; //END if p = 0

    (* Possible pagebreak problem:
    Only recognized components are printed!
    *)
    PrintControls(MyScrollBox.PagebreakPos[p], MyScrollBox.PagebreakPos[p+1]);

    // footer
    for footerIdx := 0 to Length(MyScrollBox.PagebreakPos) - 2 do
    if MyScrollBox.PagebreakPos[footerIdx].IsFooter then
    begin
      PrintControls(MyScrollBox.PagebreakPos[footerIdx], MyScrollBox.PagebreakPos[footerIdx+1]);
      break;
    end;

    Inc(CurrPage);

  end; //for pagebreak

  if FastPrint then      //20160829 Igor
    NeedNewPage := true; //20160829 Igor
  if FastPrint = False then
    Printer.EndDoc;
  MyScrollBox.Free;
end;

procedure PrepareRichEdit(ARetNo: Integer; AFormName: String; ARichEdit: TRichEdit); //20161211 Igor
begin
  if IsFormAClientLetter(AFormName) then
  begin
    GetInterpetedRichEdit(ARetNo, GetLetterFileName(ARetNo, AFormName), ARichEdit);
    Delay(50);
  end;
end;

procedure PrintImageT2(ARetNo: Integer; AFormName: String; AImage: TImage; ACanvas: TCanvas; //20161211 Igor
    ADTop: Integer = 0; ADLeft: Integer = 0);
var
  mySFDImage, mySFDImage1, myImage1: TImage;
  b: Integer;
  s:String;
  R:Trect;
begin
  mySFDImage := AImage;
  if ((OptRec.NoBarCode = False) and
      (AImage.name = 'barcodePlaceHolder1')) then
  begin
    for b := 0 to AImage.Parent.ControlCount - 1 do
    begin
      if AImage.Parent.Controls[b] is TImage then
      begin
        myImage1 := AImage.Parent.Controls[b] as TImage;
        if myImage1.name = 'barcodePlaceHolder2' then
        begin
          PrintBarcodeBitmap(ARetNo, ACanvas, AImage, myImage1, ADTop, ADLeft);
          break;
        end;
      end;
    end;
  end

  else
  if (OptRec.NoBarCode = False) and (mySFDImage.name = 'SFDbarcodePlaceHolder1') then
  begin
    for b := 0 to AImage.Parent.ControlCount - 1 do
    begin
      if AImage.Parent.Controls[b] is TImage then
      begin
        mySFDImage1 := AImage.Parent.Controls[b] as TImage;
        if mySFDImage1.name = 'SFDbarcodePlaceHolder2' then
          PrintSFDBarcodeBitmap(ARetNo, ACanvas, mySFDImage, mySFDImage1, ADTop, ADLeft);
      end;
    end;
  end

  Else //20200507
  if (UpperCase(LeftStr(AImage.Name,17))= 'E_SIGNATUREHOLDER') then
  Begin
    s:=GetSignatureFilePath(aRetNo);
    If S >'' then    //client document
    Begin
        R.Left := ScalePrX(AImage.Left + ADLeft);  //20160407 Igor
        R.Top := ScalePrY(AImage.Top + ADTop);      //20160407 Igor
        AImage.Picture.LoadFromFile(s);
        R.Width := ScalePrX(AImage.Picture.Width);
        R.Height := ScalePrY(AImage.Picture.Height);
        if R.Height > ScalePrY(AImage.Height) then
        begin
          R.Width := Trunc(R.Width * ScalePrY(AImage.Height) / R.Height);
          R.Height := ScalePrY(AImage.Height);
        end;
        ACanvas.StretchDraw(R, AImage.Picture.Graphic);
        aImage.Picture:=Nil;    //20200422
    End;
  end

  else
  begin
    if Pos('FLAGFRAME', UpperCase(AImage.Parent.name)) = 0 then
      PrintImage(ARetNo, AImage, ACanvas.Handle, ACanvas, ADTop, ADLeft);
  end;
end;

procedure PrintHeader(ACanvas: TCanvas; ARetNo: Integer; AFormName: String; AFormNo: Integer;
   APageNumber: Integer; APageHeight, APageWidth: Integer;
   ADTop: Integer = 0; ADLeft: Integer = 0); //20161211 Igor
begin
  If not IsFormDynamic(ARetNo, AFormName) then //20161107 Igor
  Begin
    ACanvas.Font.size := 8;
    ACanvas.Font.Color:=clBlack;
    ACanvas.Brush.Style := bsClear;
    If (OptRec.Prn_NameH) and (IsShowHdrIndicator(AFormName)) then
      ACanvas.TextOut(ScalePrX(10 + ADLeft), ScalePrY(0 + ADTop), GetRetName(ARetNo));
    If (OptRec.Prn_DateH) and (IsShowHdrIndicator(AFormName)) then  //gettaxatioyearend //20240303
     ACanvas.TextOut(ScalePrX(225 + ADLeft), ScalePrY(0 + ADTop), 'Tax Year: '+IntToStr(GetTaxationYearEndYYYY(aRetNo))+'     Date Printed: '+DateToMonthDayYear(Date));
      //ACanvas.TextOut(ScalePrX(225 + ADLeft), ScalePrY(0 + ADTop), 'Tax Year: '+AppYear+'     Date Printed: '+DateToMonthDayYear(Date));
    If ShowFieldIdSw then
      ACanvas.TextOut(ScalePrX(400 + ADLeft), ScalePrY(0 + ADTop), AFormName + '  Fno='+IntToStr(AFormNo))
    else
    If (OptRec.Prn_SinH) and (IsShowHdrIndicator(AFormName)) then
      ACanvas.TextOut(ScalePrX(520 + ADLeft),ScalePrY(0 + ADTop), ' BN: ' + LeftStr(GetCorpBusNo(ARetNo),9));  //20230522
    If ((OptRec.Prn_NameH) or (OptRec.Prn_DateH) or (OptRec.Prn_SinH)) and IsShowHdrIndicator(AFormName) then
    begin
      ACanvas.MoveTo(ScalePrX(10 + ADLeft), ScalePrY(12 + ADTop));
      ACanvas.LineTo(ScalePrX(600 + ADLeft), ScalePrY(12 + ADTop));
    end;
  End;
  //20161107 Igor >>>
  if APageNumber = 1 then
  begin
    If AFormName = 'T1135' then
    begin
      If (FetchElm(ARetNo, AFormName, 39) > '') and
         (FetchElm(ARetNo, AFormName, 22) = '') then  //thre is Efile confirmaqtion
      begin
        PrintAtAngle('DUPLICATE', ACanvas, 180, Trunc(APageHeight - (APageHeight / 3)), 50, 240);
        PrintAtAngle('DO NOT SEND BY MAIL', ACanvas, 100,
          Trunc(APageHeight - (APageHeight / 3) + (APageHeight / 9) - 200), 50, 240);
      end;

      If (FetchElm(ARetNo, AFormName, 39) > '') and
         (FetchElm(ARetNo, AFormName, 22) > '') and
         (FetchElm(ARetNo, AFormName, 34) = '') then  //there is Efile confirmaqtion
      begin
        PrintAtAngle('AMENDED ON ' + FormatDateTime('yyyy-mm-dd', Date), ACanvas,
          100, Trunc(APageHeight - (APageHeight / 3)), 50, 240);
      end;

      If (FetchElm(ARetNo, AFormName, 39) > '') and
         (FetchElm(ARetNo, AFormName, 22) > '') and
         (FetchElm(ARetNo, AFormName, 34) > '') then  //there is Efile confirmaqtion
      begin
         PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,
           Trunc(APageHeight-(APageHeight / 3)), 25, 240);
         PrintAtAngle('SENT ON ' + FormatDateTime('yyyy-mm-dd', Date) + '-DO NOT SEND BY MAIL',
           ACanvas, 100, Trunc(APageHeight-(APageHeight / 3) + (APageHeight / 9) - 200), 25, 240);
      end;
    end;
  end;
  //20161107 Igor <<<

  //20161130 Igor >>>
  if isDraft then
    PrintAtAngle('D R A F T', ACanvas, 100, (APageHeight div 2) - 50, 100, 100);

  If LicenseLevel = llDemo then {demo}
    PrintAtAngle('For Demo Purposes Only', ACanvas, 100, (APageHeight div 2) + 50, 30, 100)
  //20161130 Igor <<<
end;

//20221008
function GetQRContentsForT7DR(RetNo: Integer): string; //20180308 Igor
var QRContents, ClientName: string;SIN:String;T7DRFNo:Integer;
begin
  //Note  The T1 uses the INFO form to get clent SIN and ClientName
  //From T1: Elm 3=SIN =T7DR[], 2 and 5=First and last name
  QRContents := '063491087721000037CRAINDIVIDUALARC';
  SIN:=ReplaceChar(AllTrim(FetchElmFNo(RetNo, T7drFNo, 8)),'-','');
  QRContents := QRContents + RightStr(SIN,4);
  QRContents := QRContents + RightStr(SIN,4); // +RightStr(FetchElm(RetNo, 'INFO', 3), 4);
  QRContents := QRContents + '01';
  ClientName := FetchElmFNo(RetNo, T7drFNo, 66); //FetchElm(RetNo, 'INFO', 2) + ' ' + FetchElm(RetNo, 'INFO', 5);
  ClientName := AddLeadingSpaces(LeftStr(RemoveDiacriticChars(ClientName), 35), 35);//AddLeadingSpaces(LeftStr(RemoveDiacriticChars(ClientName), 35), 35);
  QRContents := QRContents + ClientName;
  QRContents := QRContents +AddLeadingSpaces(SIN,15); //AddLeadingSpaces(FetchElm(RetNo, 'INFO', 3), 15);
  QRContents := QRContents + '1017';
  QRContents := QRContents + RightStr(AppYear, 2) + '1231';
  Result := QRContents;
end;

//20221008
procedure AttachQRCode(AQRContents: string; Canvas: TCanvas;
  QRCodeImage: TImage; ADTop: Integer = 0; ADLeft: Integer = 0); //20180307 Igor
var R: TRect;
begin
  R.Left := ScalePrX(QRCodeImage.Left + ADLeft);
  R.Top := ScalePrY(QRCodeImage.Top + ADTop);
  R.Right := R.Left + ScalePrX(QRCodeImage.Width);
  R.Bottom := R.Top + ScalePrX(QRCodeImage.Width);
  DrawQRCode(AQRContents, Canvas, R);  //20221008  ?? temp not found
end;

end.

