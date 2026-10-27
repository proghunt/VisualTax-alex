unit T1_2026Print;
(* Beware: this is the T1-2012 version!
*)
{ TODO : new printing }

interface


uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,Printers,ComCtrls,extctrls,RichEdit,vtChild,
  vtEditBox,vtShape,vtLabel,vtForm,
  math, //20191216 CON to pikup ceil
  vtGroupBox,//20160407 Igor
  vtPDFPrinter, Clipbrd,
  System.Generics.Collections, System.Generics.Defaults, System.Types, //20220107 Igor
  RxRichEd; //20160819 Igor (It must be the last)

Const MxFrmHeight = 1050; //980; //960;
Const MxFrmWidth  = 655;

CONST
  RTF_INDENT_LEFT  = 80;//20160203 Igor
  RTF_INDENT_TOP   = 15;//20160203 Igor
  RTF_INDENT_RIGHT = 60;//20160203 Igor
  RTF_INDENT_BOTTOM= 15;//20160203 Igor

TYPE
 TSRTYPE  = Record
  TRANSMTYPE      :string; //[2];
  TRANSMITTERNO   :string; //[5];
  PREPARERID      :string; //[5];
  INDRES1         :string; //[10];
  INDRES2         :string; //[10];
  TRANSMDATE      :string; //[8];
  TRANSMTIME      :string; //[6];
  TRANSFLNO       :string; //[8];
  RETURNS         :string; //[4];
  SFDRECS         :string; //[4];
  ERRCODE1        :string; //[2];
  ERRCODE2        :string; //[2];
  ERRCODE3        :string; //[2];
 END;

TYPE
 ERRTYPE  = Record
  TRANSMTYPE      :string; //[2];
  TRANSMITTERNO   :string; //[5];
  PREPARERID      :string; //[5];
  INDRES1         :string; //[10];
  INDRES2         :string; //[10];
  TRANSMDATE      :string; //[8];
  TRANSMTIME      :string; //[6];
  TRANSFLNO       :string; //[8];
  ERRCODE         :string; //[2];
 END;

 TYPE
  ACKHTYPE    = record
  RECLEN            :string; //[4];
  RECTYPE           :string; //[2];
  TRANSMTYPE        :string; //[2];
  TRANSMITTERNO     :string; //[5];
  PREPARERID        :string; //[5];
  INDRES1           :string; //[10];
  INDRES2           :string; //[10];
  TRANSMDATE        :string; //[8];
  TRANSMTIME        :string; //[6];
  TRANSFLNO         :string; //[8];
  ACKINDICATOR      :string; //[1];
  TRANSCODE         :string; //[2];
  TRANSMRECS        :string; //[4];
  ACCEPTEDRECS      :string; //[4];
  NONACCEPTEDRECS   :string; //[4];
  FILLER            :string; //[62];
 END;

 TYPE
  ACKATYPE   = Record
  RECLEN      :string; //[4];
  RECTYPE     :string; //[2];
  DOCUMENTNO  :string; //[13];
  NAME        :string; //[60];
  FILLER      :string; //[9];
 END;


 TYPE
  ACKNTYPE = record
  RECLEN         :string; //[4];
  RECTYPE        :string; //[2];
  DOCUMENTNO     :string; //[13];
  NAME           :string; //[60];
  FILLER         :string; //[9];
  ERRCODE1       :string; //[6];
  ERRCODE2       :string; //[6];
  ERRCODE3       :string; //[6];
  ERRCODE4       :string; //[6];
  ERRCODE5       :string; //[6];
  ERRCODE6       :string; //[6];
  ERRCODE7       :string; //[6];
  ERRCODE8       :string; //[6];
 END;


 TYPE
  ACKTTYPE  = Record
  RECLEN         :string; //[4];
  RECTYPE        :string; //[2];
 END;


//for t1c condenced printing
Procedure PrintFilingCopy(RetNo:Integer);  //20120110
Procedure PrintAllInstancesOf(RetNo:Integer;FName:String);
Procedure PrintT1C(RetNo:Integer;FName:String; APDFPrinter: TvtPDFPrinter = nil); //20161105 Igor
//Procedure PrintDynamicForm(RetNo:Integer;FName:String; WhichPage: Integer); //20160203 Igor //20160204 Igor
Procedure PrintCondensedFormLines(RetNo:Integer;T1CFNo:Integer;ALabel:TvtLabel;AvtEditBox:TvtEdit;StartingLeft,Displacement:Integer;Var CurrentTop:Integer;verticalAdvance:integer;hdc:THandle;ACanvas:TCanvas;FrmNm:string;formDisplayName:string);
Function SubstituteT1CForm(RetNo:Integer;FrmNm:String):String;
Procedure InitT1CLabel(Var ALabel:TvtLabel;CurrentTop:Integer;StartingLeft:Integer);
Function GetExceptionalValue(RetNo:Integer;Fname:string;LLine:Integer; LValue:String):String;
Function AnyFormsForT1c(RetNo:Integer):Boolean;

procedure addnewPageHeader(headerLabel: TvtLabel;headerTop,headerLeft,RetNo:integer; FName:string; ACanvas: TCanvas );

Function GetLineValue(RetNo:Integer;LLine:Integer):String;
Procedure GetScheduleRelatedLines(RetNo:Integer;FrmNm:String;Var ScheduleRelatedLines:TStringList);
//

Procedure SortFormComponentsTopToBottom(MyScrollBox:TvtScrollBox;TempList:TStringList);




Procedure AttachBarCode(RetNo: Integer; Canvas: TCanvas; BarCodeImage1: TImage
;
  ADTop: Integer = 0; ADLeft: Integer = 0);
Procedure AttachSFDBarCode(RetNo: Integer; Canvas: TCanvas; BarCodeImage1: TImage;
  ADTop: Integer = 0; ADLeft: Integer = 0);
Procedure Attach1013BarCode(RetNo: Integer; FName: String; Canvas: TCanvas;
  BarCodeImage1: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);
procedure PaintBarCode(ACanvas: TCanvas; Var BarCodeImageArray: Array of TImage;
  BarCodeImage1:TImage; ADTop: Integer = 0; ADLeft: Integer = 0);
Procedure PrintT7DRA(RetNo:Integer;XAdj,YAdj:Real;Vers:String;PrintOwing:Boolean);
Procedure AfterReadComponentForPrint(AForm:TForm;FName:String);
Function PrintAuditList(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
Procedure SubstituteData(FName:String;Fld:Integer;Var s:string);
//20180308 Igor >>>
function GetQRContentsForT7DR(RetNo: Integer): string;
procedure AttachQRCode(AQRContents: string; Canvas: TCanvas;
  QRCodeImage: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);
//function CalcCheckDigitForT7DROCR(ALine: string): string;  // 20180310 Moved to TrimStr of T1
//20180307 Igor <<<

procedure PrintForm(RetNo: integer; FName: string;WhichPage:integer; LastFormToPrint:String);
procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;formPagebreakHeight:Integer;LastFormToPrint:String);
Procedure PrintDynamicForm(RetNo:Integer;FName:String); //20160901 Igor
function doIwantThisPageToPrint(RetNo:integer;FName:string;pageIndex:integer):Boolean;

//Procedure InterpetLetter(RetNo:Integer;LetterName:String;ARichEdit:TRichEdit);
Procedure PrintSFDBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; SFDBarCodeImage1:TImage; SFDBarCodeImage2:TImage);
Procedure PrintBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; BarCodeImage1:TImage; BarCodeImage2:TImage);
Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0;
  AisSynPDF: Boolean = False); //20161103 Igor
procedure PrepareRichEdit(ARetNo: Integer; AFormName: String; ARichEdit: TRichEdit); //20161104 Igor
procedure PrintImageT1(ARetNo: Integer; AFormName: String; AImage: TImage; ACanvas: TCanvas; //20161104 Igor
    ADTop: Integer = 0; ADLeft: Integer = 0);

procedure PrintHeader(ACanvas: TCanvas; ARetNo: Integer; AFormName: String; AFormNo: Integer;
   APageNumber: Integer; APageHeight, APageWidth: Integer; //20161130 Igor
   ADTop: Integer = 0; ADLeft: Integer = 0); //20161105 Igor //20161107 Igor

procedure applyWaterMarks(var ACanvas:TCanvas;Printer:TPrinter;ppage,RetNo:Integer;FName:string);

{ Functions for EFile}
Procedure BreakTrl(A:string);
Procedure BreakTsr(A:string);
Procedure BREAKERR(A:string);
Procedure BreakHdr(A:string);
Procedure BreakOkRec(A:string);
Procedure BreakNotOkRec(A:string);
Procedure RTUReport(FlName:string);
Procedure TSRReport(FlName:String);
Procedure ERRReport(FlName:string);
Procedure AccSubHeader;
Procedure NonSubHeader;
Procedure AccReport(FlName:string);
Procedure AccNonAcceptedReport(FlName:string);
Procedure AccAcceptedReport(FlName:string);

{-----------------------------------------}
Var
//ScaleX, ScaleY : Word;
TSR      : TSRTYPE;
ERR      : ERRType;
HDR      : ACKHTYPE;
OKREC    : ACKATYPE;
NOTOKREC : ACKNTYPE;
TRL      : ACKTTYPE;
PFile    : TextFile;
HeaderType : string; //[1];
PRINTCNT, PGNO : Integer;
maxBarDataLength : Integer;

NeedNewPage: Boolean;

implementation

uses
  vtMulti,vtCommon,vtDialogs,vtRichText,
  T1_2026,T1_2026TrimStr,T1_2026T1Rtns,
  T1_2026ChildWinNew,T1_2026Declare,T1_2026Common,T1_2026Common2,T1_2026Calc,
  T1_2026ResMeter,T1_2026build813,T1_2026BarDataGen,T1_2026Main, vtPrints,
  vtDynData,vtTrimStr,vtShared;
// ,RegularExpressions; // 20151214 Igor //20160903 igor

{-----------------------------------------}

Procedure RTUReport(FlName:string);
var
  i,k:integer;
  F1, PrnFile: TextFile;
  Ch: Char;
  s:string;
begin
  AssignFile(F1, FlName);
  Reset(F1);
  AssignPrn(PrnFile);
  Rewrite(PrnFile);
  WriteLn(PrnFile,'Contents of transmitted file: '+FlName);
  WriteLn(PrnFile,'==============================================');
  s:='';
  while not Eof(F1) do
  begin
      Read(F1, Ch);
      If Length(s) <80 then
        s:=s+Ch
      else
       begin WriteLn(PrnFile,s);s:='';s:=s+Ch;end;
  end;
  If Length(s)>0 then WriteLn(PrnFile,s);
  CloseFile(PrnFile);
  ShowMessage('Printing completed');
end;

procedure PrintForm(RetNo: integer; FName: string;WhichPage:integer; LastFormToPrint:String);
Var i,j,n,endPage,startPage:integer;Root,FInst :string; //[3];
  FrmNm,SubstFrm : string; //[12];
  DfmFileName:String;
  F: TForm; //20160204 Igor
  FullForm: TvtScrollBox; //20160204 Igor
  PagebreakPos: array of Integer;
  formNumPages,PagebreakHeight:Integer;
  MyLabel:TvtLabel;
  MyEditBox:tvtEdit;
  MyVtShape:TvtShape;
  tmp:integer;
//  Match: TMatch;          // 20151214 Igor //20160903 igor
//  strem:TStringStream;    // 20151214 Igor //20160903 Igor
//  newRichText:AnsiString; // 20151214 Igor //21060903 Igor
begin
 
Try
  FrmNm := FName;

  If IsFormDynamic(RetNo,FName) then //20160901 Igor
  Begin
    PrintDynamicForm(RetNo,FName);
    Exit;
  End; //20120110  //20160203 Igor //20160204 Igor

  FrmNm := SubstituteForm(RetNo,FrmNm);
  FInst := ExtractFormInst(FrmNm);
  DfmFileName:=GetDFMFileName(FrmNm);
  If Ret[RetNo].IsLastYearReturn then DfmFileName:=GetLastYearDfmFileName(FName); //20160314 Igor
  If FileExists(DfmFileName) = false then exit;  //20100113

  //CalcPrintJacket(RetNo);   //20200222

  F := TForm.Create(Application); //20160204 Igor
  F.visible := False; //20160204 Igor
  FullForm := TFormT1_2026.Create(F,RetNo,GetFormNo(FrmNm,RetNo)); //20160204 Igor
  if ReadComponentResFile(DfmFileName, FullForm) = nil then
  begin
     //ShowMessage('Form '+DfmFileName +' is damaged. Contact VisualTax');
    FullForm.free;
    F.Free; //20160204 Igor
    exit;
  end;
 // ReadComponentResFile(DfmFileName, FullForm);

  AfterReadComponentForPrint(TForm(FullForm),FrmNm); //20160204 Igor
  FullForm.AfterOpenForm(vtdPrint); //20160204 Igor //20160407 Igor

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
        IsFormAClientLetter(FName)); //20160903 Igor /20170204 Igor

    If FullForm.Controls[i] is TVtShape then
    begin
       if (FullForm.Controls[i] as TVtShape).vtPageBreak then
       begin
         MyVtShape := FullForm.Controls[i] as TVtShape;
         SetLength(PagebreakPos, length(PagebreakPos)+1);
         formNumPages := formNumPages + 1;
         //MyVtShape.Name := MyVtShape.Name;
         //PagebreakPos[formNumPages] := (FullForm.Components[i] as TVtShape).Top; //old 20151014 Igor
         PagebreakPos[formNumPages] := (FullForm.Controls[i] as TVtShape).Top;     //new 20151014 Igor
       end
       else
         //(FullForm.Components[i] as TVtShape).SendToBack; //old 20151014 Igor
         (FullForm.Controls[i] as TVtShape).SendToBack;     //new 20151014 Igor
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

    //for j := 0 to formNumPages-1 do
    for j:=startPage to endPage do
    begin
      if FullForm = nil then
      begin
        F := TForm.Create(Application); //20160204 Igor
        F.Visible := False; //20160204 Igor
        FullForm:= TFormT1_2026.Create(F,RetNo,GetFormNo(FrmNm,RetNo)); //20160204 Igor
        ReadComponentResFile(DfmFileName, FullForm);
        AfterReadComponentForPrint(TForm(FullForm),FName); //20160204 Igor
        FullForm.AfterOpenForm(vtdPrint);  //20160204 Igor //20160407 Igor
        FullForm.vertscrollbar.position := 0;
        FullForm.horzscrollbar.position := 0;
        //20170204 Igor >>>
        for  i := FullForm.ControlCount - 1 downto 0 do
        begin
          If FullForm.Controls[i] is TRichEdit then
            IncRichEditFontSize(TRichEdit(FullForm.Controls[i]), 2 * MainOptions.Prn_FontIncr,
              IsFormAClientLetter(FName)); //20160903 Igor //20170204 Igor
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
(* //20170204 Igor
            //20170203 Igor >>>
              If FullForm.Controls[i] is TRichEdit then
                IncRichEditFontSize(TRichEdit(FullForm.Controls[i]), 2 * MainOptions.Prn_FontIncr); //20160903 Igor
            //20170203 Igor <<<
*)
                FullForm.Controls[i].Top := FullForm.Controls[i].Top - PagebreakPos[j];
            end
            else
            begin
                //if not(FullForm.Controls[i] is TwwDBRichEdit) then
                    FullForm.Controls[i].Free;
            end;
        end;

   //for printing NR with EMPL //20180429
   If ((LeftStr(FName,4) = 'T1C_') Or (FName='T1'))
   and ((FetchElm(RetNo,'INFO',276)>'') and (Ret[RetNo].Province <> 'ZZ')) then  //276 empl income from a province
    StoreElm(RetNo,GetFormNo(FName),1,'OTHER');

   {20260315 not good not finished
   //for printing NR with Deemed Resident //20260315     //276 empl income from a province
   If ((LeftStr(FName,4) = 'T1C_') Or (FName='T1'))
   and (Ret[RetNo].Province <> 'ZZ')) then
   and (FetchElmFNo(RetNo,INfoFNo,7,'DEEMED NONRESIDENT') then
   Begin
    SubstruteForm(Fname,'T1R');
   end;
   }


   if doIwantThisPageToPrint(RetNo,FName,j) then  //jz 20190602
   begin
    PrintFormPage(RetNo,FName,TForm(FullForm),j,formNumPages,PagebreakHeight,LastFormToPrint); //20160204 Igor
   end;

    FreeAndNil(FullForm); //force reload at begin of loop
    FreeAndNil(F);

   end; //end for (all pages)
   FreeAndNil(FullForm); //force reload at begin of loop
   FreeAndNil(F);
   //if FileExists(PFormFileName) then SysUtils.DeleteFile(PFormFileName);

 Except
  ShowMessage(Fname +' encountered printing problem');  //20101208
 end;
end;


function doIwantThisPageToPrint(RetNo:integer;FName:string;pageIndex:integer):Boolean; //jz 20190602
begin
  result := true;

  if (FName = 'T2203') and
   //(not (( pageIndex = 0) or (pageIndex >= 13 )) ) then // always print first and last 2 pages //20210422
    (not (( pageIndex = 0) or (pageIndex = 1) or (pageIndex >= 11 )) ) then // always print first and last 2 pages
  begin
    result := false; //otherwise don't print other pages unless they have data:



    if pageIndex = 2 then
    begin
        result := true
    end

    else if (pageIndex = 3) or (pageIndex = 4) then
    begin
      if (FetchElm(RetNo,FName,8)  > '') or //NL
         (FetchElm(RetNo,FName,15) > '') or //PE
         (FetchElm(RetNo,FName,22) > '')    //NS
      then
        result := true
    end

    else if (pageIndex = 5) or (pageIndex = 6) then
    begin
      if (FetchElm(RetNo,FName,29) > '') or //NB
         (FetchElm(RetNo,FName,43) > '') or //ON
         (FetchElm(RetNo,FName,50) > '')    //MB
      then
        result := true
    end

    else if (pageIndex = 7) or (pageIndex = 8) then
    begin
      if (FetchElm(RetNo,FName,57) > '') or  //SK
         (FetchElm(RetNo,FName,64) > '') or  //AB
         (FetchElm(RetNo,FName,71) > '')     //BC
      then
        result := true
    end

    else if (pageIndex = 9) or (pageIndex = 10) then
    begin
      if (FetchElm(RetNo,FName,78)  > '') or  //YT
         (FetchElm(RetNo,FName,85)  > '') or  //NT
         (FetchElm(RetNo,FName,106) > '')     //NU
      then
        result := true
    end;
  end;
end;




procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm;numPagePrinting,formNumPages:Integer;formPagebreakHeight:Integer;LastFormToPrint:String);
var
  //FldRec: PFieldList; //LblRec : PLabelList;  LnRec : PLineList;
  {dpiAdjustment,} FrmHeight,PenWidth,FNo,d,k,x,y,XPos,YPos : Integer; //20170212 Igor
  //PageX, PageY : LongInt; //20170212 Igor
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
  ARichEdit:TRichEdit; // 20151016 Igor
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

{$IFDEF print}
  Margins: TMargins;
{$ELSE}
{$ENDIF}

//  WinFontSize:Integer; //20170212 Igor
  DC:THandle; //dc;

  //xExtraDPIAdjustment,yExtraDPIAdjustment:integer; //20170212 Igor
  lCurrPageisLandscape: Boolean; //20170127 igor

  RealHeight, RealWidth: Integer; //20170307 Igor

          procedure PrintControls(AControl: TWinControl; ADTop, ADLeft: Integer); //20160407 Igor
          var
            kk, i, b, j: Integer;
          Begin
            kk := AControl.ControlCount-1;
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
              If AControl.Controls[i] is TVtShape then
              begin //print the shape
                MyVtShape:=AControl.Controls[i] as TVtShape;
                if MyVtShape.vtIsPrintable then
                  PrintVtShape(MyVtShape, ACanvas, ADTop, ADLeft);
              end

              else
              if AControl.Controls[i] is TvtLabel then
              begin //print the label
                MyLabel:=AControl.Controls[i] as TvtLabel;
                if MyLabel.vtIsPrintable then
                  PrintLabel(MyLabel, ACanvas, DefFontName, ADTop, ADLeft);
              end

              else
              if AControl.Controls[i] is TvtEdit then
              begin //print the editbox
                MyEditBox:=AControl.Controls[i] as TvtEdit;
                if MyEditBox.vtIsPrintable then
                  PrintEditBox(RetNo,MyEditBox,FName,FNo,Hdc,ACanvas, ADTop, ADLeft);
              end //tvedit

              else
              if AControl.Controls[i] is TImage then
              begin
                 PrintImageT1(RetNo, FName, TImage(AControl.Controls[i]), ACanvas, ADTop, ADLeft);
              end

              else
              if AControl.Controls[i] is TRichEdit then //TwwDbRichEdit
              begin
                ARichEdit:=AControl.Controls[i] as TRichEdit;
                if Assigned(ARichEdit.Parent) then
                begin   // 20151016 igor
                  if IsFormAClientLetter(FName) then
                  begin
                    GetInterpetedRichEdit(RetNo,GetLetterFileName(RetNo,FName),ARichEdit);
                    Delay(50);
                  end;
                  PrintRichEdit(RetNo, ARichEdit, ACanvas, ADTop, ADLeft,
                    IsFormAClientLetter(FName)); //20170109 Igor
                end;
              end //richedit

              else
              if AControl.Controls[i] is TMemo then //TMemo
              begin
                PrintMemo(RetNo,AControl.Controls[i] as TMemo, ACanvas, ADTop, ADLeft);
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
                    R.Left   := ScalePrX(MyFrame.Left + ADLeft); //ScalePrX(MyImage.Left) +
                    R.Top    := ScalePrY(MyFrame.Top + ADTop);  //ScalePrY(MyImage.Top)  +
                    R.Right  := R.Left +  ScalePrX(MyImage.Picture.Width); //ScalePrX(MyFrame.Width);
                    R.Bottom := R.Top  +  ScalePrY(MyImage.Picture.Height); //ScalePrY(MyFrame.Height);
                    PrintBitmap(ACanvas,R,MyImage.Picture.Bitmap);
                  end;
                end;
              end;
            end;  //i components

          End;

var
LFontSize: Integer; //20191216 Igor

begin
   If AbortSw then exit;

   FName := UpperCase(Ltrim(RTrim(Fname)));
   FNo := GetFormNo(FName);
   If FNo=0 then exit;

   if (Printer.Printing) and (FastPrint=False) then
   begin
    if MessageDlg('Printer temporarily busy. Try again?',
      mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;
   end;
   WhiteBoxes := GetWhiteBoxesIndicator(FName);
    //20160721 Igor >>>
    lCurrPageisLandscape := CurrentPageIsLanscape(AForm, IsLandscape(FName), MxFrmWidth, 0, maxInt,
      RealHeight, RealWidth); //20170127 Igor //20170307 Igor
    if ((Printer.Orientation = poLandscape) <> lCurrPageisLandscape{IsLandscape(FName)}) then //20170127 Igor
    begin
      if Printer.Printing then
        Printer.EndDoc;

      If lCurrPageisLandscape {IsLandscape(FName)} Then  //20170127 Igor
        Printer.Orientation := poLandscape
      else
        Printer.Orientation := poPortrait;
      Printer.Title :=  GetFormRlName(FNo) + ' : '+ GetLastName(RetNo)+ ', ' + GetFirstName(RetNo); //20160905 Igor
      Printer.BeginDoc;
      NeedNewPage := False;
    end;
    If not Printer.Printing then
    begin
      Printer.Title :=  GetFormRlName(FNo) + ' : '+ GetLastName(RetNo)+ ', ' + GetFirstName(RetNo); //20160905 Igor
      Printer.BeginDoc;
      NeedNewPage := False;
    end;
    if NeedNewPage then
      Printer.NewPage;
    //20160721 Igor <<<

   If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
 //20170212 Igor>>>
  CalcScaleXY(RealHeight, RealWidth); //20170307 Igor

  hdc :=  Printer.Canvas.Handle;
  ACanvas:=Printer.Canvas;

 //20170212 Igor<<<
  If LicenseLevel = llDemo then {demo}
  begin
    PrintAtAngle('For Demo Purposes Only',ACanvas, 200,Printer.PageHeight div 2-100,30,100)
  end
  else //production  //20121213
  begin
  end;



  //jz//20260325 - NEED TO REVISIT TO ADD THE BELOW WATERMARK CODE TO applyWaterMarks PROCEDURE

  //20190211
  //20260103CZ  Some slight changes to the watermarks angles

  If LeftStr(FName,4)='T1C_' then
  begin
   //20240217
   if (FetchElm(RetNo,'T183',37)>'') //efiled
   and (FetchElm(RetNo,'INFO',223)='')  //no refile  //20240217
   then   //efiled
   begin
       PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,550); //jz//20250304 240 to 550 to move the watermark up out of the barcode  //20141229
       PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,550); //jz//20250304 240  //20160707
    end;

   //20190127
   if (FetchElm(RetNo,'T183',37)>'')  //efiled
   and (FetchElm(RetNo,'INFO',223)='')  //no refile
   then  //efiled confirmation number
   begin
     // to be able to submit barcoded tests to CRA, remove these lines //20230108
     //20240217
    // PrintAtAngle('Duplicate',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),40,240);   //20141229
    // PrintAtAngle('Do not send by Mail',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-350),40,240);   //20160707
   end;

  //20190127
   if (FetchElm(RetNo,'T183',37)>'')  //Efiled
   and (UpperCase(FetchElm(RetNo,'INFO',223))='R1')  //refiled  R1
   then  //efiled confirmation number
   begin
       PrintAtAngle('Amended on date '+FetchElm(RetNo,'STATUS',22),ACanvas, 100,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),40,200); //20141229  //180  50 240
   end;

   //20190127
   if (FetchElm(RetNo,'T183',37)>'')  //Efiled
   and (UpperCase(FetchElm(RetNo,'INFO',223))>'R1')  //refiled
   then  //efiled confirmation number
   begin
       PrintAtAngle('Duplicate of amended return ',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),40,200);   //20141229
       PrintAtAngle('sent on date '+FetchElm(RetNo,'STATUS',22),ACanvas, 300,
          Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-500),40,200);   //20160707
       PrintAtAngle('     Do not send by Mail',ACanvas, 400,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),40,200);   //not 30
   end;
  end;

 //20170123
  If LeftStr(FName,6)='T1013#' then             //original Efiled
  begin
      If (FetchElm(RetNo,FName,39)>'')
      then  //thre is Efile confirmaqtion
      begin
       PrintAtAngle('Retain for your records',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,200);  //not 240 //202660103
       PrintAtAngle('Do Not forward to CRA',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);
     end;
  end;

  //20191216 Igor >>>
  if WaterMarkText>''  then //(OptRec.Prn_Watermark <> '') then CON
  begin
     LFontSize := Ceil(Printer.PageHeight / WatermarkText.Length * 1.6 / 10); //20191216  CON
     PrintAtAngle(WaterMarkText,ACanvas, 200,Printer.PageHeight div 2-700,LFontSize,100);
  end;
  //20191216 Igor <<<


  //jz//20260325 - isDraft watermark is already done in applyWaterMarks
  {
  //20161130 Igor
  if isDraft then
  begin
   PrintAtAngle('DRAFT - Not for filing',ACanvas, 200,Printer.PageHeight div 2-100,50,50); //20242312
  end;
  }

  //*** APPLY ALL WATERMARKS HERE***
  applyWaterMarks(ACanvas,Printer,0,RetNo,FName); //jz//20260325 - REVISIT TO ADD THE REST ABOVE TO applyWaterMarks PROCEDURE





  {Print Form Header}
  ACanvas.Font.size := 8;
  {remove switches later}
  ACanvas.Font.Color:=clBlack;      //20111222
  ACanvas.Brush.Style := bsClear;   //20130124

  //20190213 Igor >>>
  if not SameText(FName, 'T7DRQR') then
  begin
    {Print Header}
     If (OptRec.Prn_NameH) and (IsShowHdrIndicator(FName)) then
       ACanvas.TextOut(ScalePrX(10),ScalePrY(0),GetRetName(RetNo));
     If (OptRec.Prn_DateH) and (IsShowHdrIndicator(FName)) then
       ACanvas.TextOut(
         ScalePrX(225),ScalePrY(0), 'Tax Year: '+AppYear+'     Date Printed: '+DateToMonthDayYear(Date));  //20160421 //20160505 Igor
     If ShowFieldIdSw then
         ACanvas.TextOut(ScalePrX(400),ScalePrY(0), FName + '  Fno='+IntToStr(FNo))
     else
     Begin
         s:=ReformatSin(GetSinno(RetNo));
         if (HideSin(RetNo)) and (IsSignatureForm(FName)) then s:=GetHiddenSin(GetSinNo(RetNo));
         //if (HideSin(RetNo)) and (Fmame='T183') and (elm:=23) then s:=GetHiddenRepId(GetSinNo(RetNo)); //20230216
         If (OptRec.Prn_SinH) and (IsShowHdrIndicator(FName)) then
         Begin
           if OptRec.Prn_HideSin=False then
             ACanvas.TextOut(ScalePrX(530),ScalePrY(0), ' SIN: '+ s)
           Else
             ACanvas.TextOut(ScalePrX(530),ScalePrY(0), ' SIN: '+ GetHiddenSin(GetSinNo(RetNo))); //20200529
         end;
     end;


     If ((OptRec.Prn_NameH)
     or (OptRec.Prn_DateH)
     or (OptRec.Prn_SinH))
     and IsShowHdrIndicator(FName) then
     begin
      ACanvas.MoveTo(ScalePrX(10), ScalePrY(12)); //20170212 Igor
      ACanvas.LineTo(ScalePrX(610), ScalePrY(12)) //20170212 Igor  //20200120
     end;
   end;

  //20190213 Igor <<<
   PrintControls(AForm, 0, 0); //20160407 Igor

   If FastPrint=True then
   begin
     NeedNewPage := True; //20160721 Igor
   end;

   If FastPrint=False then
   begin
    Printer.EndDoc;
   end;

End;


Procedure TSRReport(FlName:string);
 Var
     F1 : TextFile;
     hdc: THandle;
     A : string;
     //PageX, PageY : LongInt; //20170212 Igor
     Msg,TransDate, TransTime : string;
     x,y, YIncr : Longint;
Begin
  Assign(F1,FlName);
  Reset(F1);

  Printer.BeginDoc; {Not needed/causes trouble}
  {
  AssignPrn(PFile);
  Rewrite(PFile);
  }
  ReadLn(F1,A);
  BreakTsr(A);
   //20170212 Igor>>>
  CalcScaleXY;

//  PageX  := Printer.PageWidth;
//  PageY  := Printer.PageHeight;
//  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
//  ScaleY := (PageY * ScMult) div MxFrmHeight; {FrmHeight;}
 //20170212 Igor<<<
  hdc :=  Printer.Canvas.Handle;
  Printer.Canvas.Font.Name := DefFontName;
  YIncr := 20;
  With Printer.Canvas do
  begin
    Font.Size := 12; Font.Style := [fsBold];
    X := 20; Y :=20;
    TextOut(ScalePrX(200),ScalePrY(Y),'TRANSMISSION STATUS REPORT');
    Font.Size := 10; Font.Style := [];
    Y := Y+Yincr;
    TextOut(ScalePrX(200),ScalePrY(Y),'Transmission File Number: '
                          + TSR.TRANSFLNO);
    Y := Y+Yincr;
    Textout(ScalePrX(240),ScalePrY(Y),'for Transmitted file: ' +
            LEFTSTR(TSR.INDRES1,8));
    TRANSDATE :=LEFTStr(TSR.TRANSMDATE,4)+'-'+MIDStr(TSR.TRANSMDATE,5,2)+
                '-'+RIGHTStr(TSR.TRANSMDATE,2);
    TRANSTIME :=LEFTStr(TSR.TRANSMTIME,2)+'-'+MIDStr(TSR.TRANSMTIME,3,2)+
                '-'+RIGHTStr(TSR.TRANSMTIME,2);
    Y := Y+Yincr*2;
    Textout(ScalePrX(x),ScalePrY(Y),'Transmitter ' +
                 TSR.TRANSMITTERNO +
        ' submitted an RTU of ' + LTRIM(TSR.RETURNS) +
        ' T1 records and');
    Y := Y+Yincr;
    Textout(ScalePrX(x),ScalePrY(Y),
         LTRIM(TSR.SFDRECS) + ' selected Financial Data records on (YYYY-MM-DD) ' +
            TRANSDATE + ' at (HH:MM:SS) ' + TRANSTIME + ' (EST)');
    Y := Y+Yincr;
    Textout(ScalePrX(x),ScalePrY(Y),'for preparer agent ' +
              TSR.PREPARERID);

    IF VL(TSR.ERRCODE1)=0 THEN
       MSG :='TRANSMISSION WAS SUCCESSFUL.'
    ELSE
       MSG :='*** TRANSMISSION UNSUCCESSFUL. ERRORS: '+
          TSR.ERRCODE1+ ' '+TSR.ERRCODE2+' '+TSR.ERRCODE3;
    Y := Y+ Yincr * 3;
    Textout(ScalePrX(x),ScalePrY(Y),MSG);
  end;
  CloseFile(F1);
  {System.CloseFile(PFile);}
  Printer.EndDoc;
end;

Procedure ERRReport(FlName:string);
 Var
     F1 : TextFile;
     hdc: THandle;
     A : string;
//     PageX, PageY : LongInt; //20170212 Igor
     Msg,TransDate, TransTime : string;
     x,y, YIncr : Longint;
Begin
  Assign(F1,FlName);
  Reset(F1);

  Printer.BeginDoc; {Not needed/causes trouble}
  ReadLn(F1,A);
  BreakERR(A);
   //20170212 Igor>>>
  CalcScaleXY;
//  PageX  := Printer.PageWidth;
//  PageY  := Printer.PageHeight;
//  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
//  ScaleY := (PageY * ScMult) div MxFrmHeight; {FrmHeight;}
 //20170212 Igor<<<
  hdc :=  Printer.Canvas.Handle;
  Printer.Canvas.Font.Name := DefFontName;
  YIncr := 20;
  With Printer.Canvas do
  begin
    Font.Size := 12; Font.Style := [fsBold];
    X := 20; Y :=20;
    TextOut(ScalePrX(200),ScalePrY(Y),'ENCRYPTION ERROR REPORT');
    Font.Size := 10; Font.Style := [];
    Y := Y+Yincr;
    TextOut(ScalePrX(200),ScalePrY(Y),'Transmission File Number: '
                          + ERR.TRANSFLNO);
    Y := Y+Yincr;
    Textout(ScalePrX(240),ScalePrY(Y),'for transmitted file: ' +
            LEFTSTR(ERR.INDRES1,8));
    TRANSDATE :=LEFTStr(ERR.TRANSMDATE,4)+'-'+MIDStr(ERR.TRANSMDATE,5,2)+
                '-'+RIGHTStr(ERR.TRANSMDATE,2);
    TRANSTIME :=LEFTStr(ERR.TRANSMTIME,2)+'-'+MIDStr(ERR.TRANSMTIME,3,2)+
                '-'+RIGHTStr(ERR.TRANSMTIME,2);
    Y := Y+Yincr*2;
    Textout(ScalePrX(x),ScalePrY(Y),'Transmitter ' +
                 ERR.TRANSMITTERNO +
        ' submitted an encryped RTU on '+
          TRANSDATE + ' at (HH:MM:SS) ' + TRANSTIME + ' (EST)');
    Y := Y+Yincr;
    Textout(ScalePrX(x),ScalePrY(Y),'for preparer agent ' +
              ERR.PREPARERID);
    Y := Y+Yincr;
    Textout(ScalePrX(x),ScalePrY(Y),'CCRA was unable to decrypt the RTU.');
    (*
    IF VL(TSR.ERRCODE1)=0 THEN
       MSG :='TRANSMISSION WAS SUCCESSFUL.'
    ELSE
       MSG :='*** TRANSMISSION UNSUCCESSFUL. ERRORS: '+
          TSR.ERRCODE1+ ' '+TSR.ERRCODE2+' '+TSR.ERRCODE3;
    Y := Y+ Yincr * 3;
    Textout(ScalePrX(x),ScalePrY(Y),MSG);
    *)
  end;
  CloseFile(F1);
  {System.CloseFile(PFile);}
  Printer.EndDoc;
end;



Procedure AccReport(FlName:string);
Var  F1 : TextFile; A : string;
Begin
  Assign(F1,FlName);
  Reset(F1);
  ReadLn(F1, A);  {Hdr}
  BreakHdr(A);
  CloseFile(F1);
  If StrToInt(HDR.ACCEPTEDRECS) > 0 then
    AccAcceptedReport(FlName); {open doc here}

  Assign(F1,FlName);
  Reset(F1);
  ReadLn(F1, A);  {Hdr}
  BreakHdr(A);
  CloseFile(F1);
  If StrToInt(HDR.NonACCEPTEDRECS) > 0 then
    AccNonAcceptedReport(FlName);  {close doc here}
end;


Procedure AccAcceptedReport(FlName:string);
 Var
     F1 : TextFile;
     hdc: THandle;
//     PageX, PageY : LongInt; //20170212 Igor
     Msg,TransDate, TransTime : string;
     x,y, YIncr : Longint;
     A : string;
     MXCNT, TOTPAGES: Integer;
     Tab1,Tab2,Tab3,Tab4 : integer;
     DateTime : string; //[30];
     Title1 : string; //[30];
Begin
  Assign(F1,FlName);
  Reset(F1);

 if Printer.Printing then
   begin
    if MessageDlg('Acc report. Printer temporarily busy. Try again?',
      mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;
   end;

 Printer.BeginDoc;
 Try
  //20170212 Igor>>>
 CalcScaleXY;
//  PageX  := Printer.PageWidth;
//  PageY  := Printer.PageHeight;
//  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
//  ScaleY := (PageY * ScMult) div MxFrmHeight;
 //20170212 Igor<<<
  hdc :=  Printer.Canvas.Handle;
  Printer.Canvas.Font.Name := DefFontName;
  YIncr := 20;
  X := 20; Y :=20;

  With Printer.Canvas do
  begin
  PGNO := 0; MXCNT := 35;  {single lines on page}
  ReadLn(F1, A);  {Hdr}
  BreakHdr(A);
  If Hdr.TransmType > '10' then Title1 := 'SEND RESULTS'
   else Title1 :='ACCEPTED RECORDS';

  TOTPAGES := StrToInt(HDR.ACCEPTEDRECS) div MXCNT + 1;
  PRINTCNT :=0; PGNO := PGNO + 1;
  Font.Size := 10; Font.Style := [];
  TextOut(ScalePrX(x),ScalePrY(Y),DateToYYYYMMDD(NOW));
  Font.Size := 12; Font.Style := [fsBold];
  TextOut(ScalePrX(230),ScalePrY(Y),Title1);
  Font.Size := 10; Font.Style := [];
  TextOut(ScalePrX(500),ScalePrY(Y),
     'Page ' + IntToStr(PgNo) + ' of ' + IntToStr(TOTPAGES));
  y := Y + YIncr;
  TextOut(ScalePrX(200),ScalePrY(Y), 'TRANSMISSION FILE NUMBER ' +
            HDR.TRANSFLNO); y := Y + YIncr;
  TextOut(ScalePrX(250),ScalePrY(Y), 'For transmitted file: ' +
           LeftStr(HDR.INDRES1,8));
  Font.Size := 10; Font.Style := [];
  y := Y + YIncr *2;
  Tab1 := 100; Tab2 := 200; Tab3 := 300; Tab4 := 400;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Transmitter');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Preparer');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Transmission');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'Number of Returns');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Date & Time ');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'Accepted');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'============');

  {ACCSUBHEADER; }
  DATETIME := MidStr(HDR.TRANSMDATE, 1, 4) + '/'
           + MidStr(HDR.TRANSMDATE, 5, 2) +
           '/' + RIGHTStr(HDR.TRANSMDATE, 2) + ' ' +
           LeftStr(HDR.TRANSMTIME, 2) + ':' +
           MidStr(HDR.TRANSMTIME, 3, 2) + ':' +
           RIGHTStr(HDR.TRANSMTIME, 2);
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), HDR.TRANSMITTERNO);
  TextOut(ScalePrX(Tab2),ScalePrY(Y), HDR.PREPARERID);
  TextOut(ScalePrX(Tab3),ScalePrY(Y), DATETIME);
  TextOut(ScalePrX(Tab4),ScalePrY(Y),
    '     '+FormatAccNonAccRecordCnt(HDR.ACCEPTEDRECS));
  y := Y + YIncr * 2;
  Tab1 := 50; Tab2 := 200; Tab3 := 400; {Tab4 := 400;}
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Document Control');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), 'Client'+Chr(39)+'s First Name');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), 'Client'+Chr(39)+'s Last Name');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Number');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), '================');
  Repeat
   ReadLn(F1, A);
   IF MIDStr(A, 5, 2) = '05' THEN
     begin
      BREAKOKREC(A);
      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y),OKREC.DOCUMENTNO);
      TextOut(ScalePrX(Tab2),ScalePrY(Y),RTRIM(LEFTStr(OKREC.NAME,30)));
      TextOut(ScalePrX(Tab3),ScalePrY(Y),RTRIM(RightStr(OKREC.NAME,30)));
      PRINTCNT := PRINTCNT + 1;
      IF PRINTCNT >= MXCNT THEN
       begin
         X := 20; Y :=20;
         Printer.NewPage;
         PrintCnt :=0;
         Inc(PgNo);
        If Hdr.TransmType > '10' then Title1 := 'SEND RESULTS'
            else Title1 :='ACCEPTED RECORDS';
          Font.Size := 10; Font.Style := [];
         TextOut(ScalePrX(x),ScalePrY(Y),DateToYYYYMMDD(NOW));
         Font.Size := 12; Font.Style := [fsBold];
          TextOut(ScalePrX(230),ScalePrY(Y),Title1);
         Font.Size := 10; Font.Style := [];
         TextOut(ScalePrX(500),ScalePrY(Y),
          'Page ' + IntToStr(PgNo) + ' of ' + IntToStr(TOTPAGES));
          y := Y + YIncr;
          TextOut(ScalePrX(200),ScalePrY(Y), 'TRANSMISSION FILE NUMBER ' +
               HDR.TRANSFLNO); y := Y + YIncr;
          TextOut(ScalePrX(250),ScalePrY(Y), 'For transmitted file: ' +
            LeftStr(HDR.INDRES1,8));
          Font.Size := 10; Font.Style := [];
  y := Y + YIncr *2;
  Tab1 := 100; Tab2 := 200; Tab3 := 300; Tab4 := 400;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Transmitter');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Preparer');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Transmission');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'Number of Returns');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Date & Time ');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'Accepted');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'============');

  {ACCSUBHEADER; }
  DATETIME := MidStr(HDR.TRANSMDATE, 1, 4) + '/'
           + MidStr(HDR.TRANSMDATE, 5, 2) +
           '/' + RIGHTStr(HDR.TRANSMDATE, 2) + ' ' +
           LeftStr(HDR.TRANSMTIME, 2) + ':' +
           MidStr(HDR.TRANSMTIME, 3, 2) + ':' +
           RIGHTStr(HDR.TRANSMTIME, 2);
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), HDR.TRANSMITTERNO);
  TextOut(ScalePrX(Tab2),ScalePrY(Y), HDR.PREPARERID);
  TextOut(ScalePrX(Tab3),ScalePrY(Y), DATETIME);
  TextOut(ScalePrX(Tab4),ScalePrY(Y),
   '    '+FormatAccNonAccRecordCnt(HDR.ACCEPTEDRECS));
  y := Y + YIncr * 2;
  Tab1 := 50; Tab2 := 200; Tab3 := 400; {Tab4 := 400;}
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Document Control');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), 'Client'+Chr(39)+'s First Name');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), 'Client'+Chr(39)+'s Last Name');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Number');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), '================');
        end;
     end
     ELSE
       IF MIDStr(A, 5, 2) = '99' THEN BREAKTRL(A);
 until EOF(F1);
 end;
 CloseFile(F1);
 //Printer.NewPage; {to print the next Non accepted}
 Printer.EndDoc; //Do not close here}
 except
   on E: Exception do ExceptMsg(e); // MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;


Procedure AccNonAcceptedReport(FlName:string);
 Var
     F1 : TextFile;
     hdc: THandle;
//     PageX, PageY : LongInt; //20170212 Igor
     Msg,TransDate, TransTime : string;
     x,y, YIncr : Longint;
     A : string;
     MXCNT, TOTPAGES: Integer;
     Tab1,Tab2,Tab3,Tab4 : integer;
     DateTime : string; //[30];
     Title1, Title2 : string; //[30];
Begin
  Assign(F1,FlName);
  Reset(F1);

  Printer.BeginDoc;
   //20170212 Igor>>>
  CalcScaleXY;
//  PageX  := Printer.PageWidth;
//  PageY  := Printer.PageHeight;
//  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
//  ScaleY := (PageY * ScMult) div MxFrmHeight;
 //20170212 Igor<<<
  hdc :=  Printer.Canvas.Handle;
  Printer.Canvas.Font.Name := DefFontName;
  YIncr := 20;
  X := 20; Y :=20;

  With Printer.Canvas do
  begin
  HEADERTYPE := 'A';
  PGNO := 0; MXCNT := 12;
  ReadLn(F1, A);  {Hdr}
  BreakHdr(A);
  If Hdr.TransmType > '10' then
   begin Title1 := 'SEND RESULTS'; Title2 := ' ';end
   else begin Title1 :='NON-ACCEPTED RECORDS';Title2:= 'Not accepted';end;

  TOTPAGES := StrToInt(HDR.NonACCEPTEDRECS) div MXCNT + 1;
  PRINTCNT :=0; PGNO := PGNO + 1;
  Font.Size := 10; Font.Style := [];
  TextOut(ScalePrX(x),ScalePrY(Y),DateToYYYYMMDD(NOW));
  Font.Size := 12; Font.Style := [fsBold];
  TextOut(ScalePrX(230),ScalePrY(Y),Title1);
  Font.Size := 10; Font.Style := [];
  TextOut(ScalePrX(500),ScalePrY(Y),
     'Page ' + IntToStr(PgNo) + ' of ' + IntToStr(TOTPAGES));
  y := Y + YIncr;
  TextOut(ScalePrX(200),ScalePrY(Y), 'TRANSMISSION FILE NUMBER ' +
            HDR.TRANSFLNO); y := Y + YIncr;
  TextOut(ScalePrX(250),ScalePrY(Y), 'For transmitted file: ' +
           LeftStr(HDR.INDRES1,8));
  Font.Size := 10; Font.Style := [];
  y := Y + YIncr *2;
  Tab1 := 100; Tab2 := 200; Tab3 := 300; Tab4 := 400;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Transmitter');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Preparer');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Transmission');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'Number of Returns');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Date & Time ');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'Not accepted');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'============');

  {ACCSUBHEADER; }
  DATETIME := MidStr(HDR.TRANSMDATE, 1, 4) + '/'
           + MidStr(HDR.TRANSMDATE, 5, 2) +
           '/' + RIGHTStr(HDR.TRANSMDATE, 2) + ' ' +
           LeftStr(HDR.TRANSMTIME, 2) + ':' +
           MidStr(HDR.TRANSMTIME, 3, 2) + ':' +
           RIGHTStr(HDR.TRANSMTIME, 2);
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), HDR.TRANSMITTERNO);
  TextOut(ScalePrX(Tab2),ScalePrY(Y), HDR.PREPARERID);
  TextOut(ScalePrX(Tab3),ScalePrY(Y), DATETIME);
  TextOut(ScalePrX(Tab4),ScalePrY(Y),
      '     '+FormatAccNonAccRecordCnt(HDR.NonACCEPTEDRECS));
  y := Y + YIncr * 2;
  Tab1 := 50; Tab2 := 200; Tab3 := 400; {Tab4 := 400;}
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Document Control');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), 'Client'+Chr(39)+'s First Name');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), 'Client'+Chr(39)+'s Last Name');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Number');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), '================');
  Repeat
   ReadLn(F1, A);
   IF MIDStr(A, 5, 2) = '06' THEN
     begin
      BREAKNotOKREC(A);
      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y),NotOKREC.DOCUMENTNO);
      TextOut(ScalePrX(Tab2),ScalePrY(Y),RTRIM(LEFTStr(NotOKREC.NAME,30)));
      TextOut(ScalePrX(Tab3),ScalePrY(Y),RTRIM(RightStr(NotOKREC.NAME,30)));
      y := Y + YIncr;
      TextOut(ScalePrX(Tab1),ScalePrY(Y),'Error Codes');
      NOTOKREC.ERRCODE1 := IntToStr(StrToInt(NOTOKREC.ERRCODE1));
      NOTOKREC.ERRCODE2 := IntToStr(StrToInt(NOTOKREC.ERRCODE2));
      NOTOKREC.ERRCODE3 := IntToStr(StrToInt(NOTOKREC.ERRCODE3));
      NOTOKREC.ERRCODE4 := IntToStr(StrToInt(NOTOKREC.ERRCODE4));
      NOTOKREC.ERRCODE5 := IntToStr(StrToInt(NOTOKREC.ERRCODE5));
      NOTOKREC.ERRCODE6 := IntToStr(StrToInt(NOTOKREC.ERRCODE6));
      If Vl(NOTOKREC.ERRCODE1) = 0 then NOTOKREC.ERRCODE1 := '';
      If Vl(NOTOKREC.ERRCODE2) = 0 then NOTOKREC.ERRCODE2 := '';
      If Vl(NOTOKREC.ERRCODE3) = 0 then NOTOKREC.ERRCODE3 := '';
      If Vl(NOTOKREC.ERRCODE4) = 0 then NOTOKREC.ERRCODE4 := '';
      If Vl(NOTOKREC.ERRCODE5) = 0 then NOTOKREC.ERRCODE5 := '';
      If Vl(NOTOKREC.ERRCODE6) = 0 then NOTOKREC.ERRCODE6 := '';
      TextOut(ScalePrX(Tab2),ScalePrY(Y),
             NOTOKREC.ERRCODE1+ '  '+
             NOTOKREC.ERRCODE2+ '  '+
             NOTOKREC.ERRCODE3+ '  '+
             NOTOKREC.ERRCODE4+ '  '+
             NOTOKREC.ERRCODE5+ '  '+
             NOTOKREC.ERRCODE6);
      y := Y + YIncr;
         PRINTCNT := PRINTCNT + 1;
      IF PRINTCNT >= MXCNT THEN
       begin
         Printer.NewPage;
         PrintCnt :=0;
         X := 20; Y :=20;

  PRINTCNT :=0; Inc(PgNo);
  Font.Size := 10; Font.Style := [];
  TextOut(ScalePrX(x),ScalePrY(Y),DateToYYYYMMDD(NOW));
  Font.Size := 12; Font.Style := [fsBold];
  TextOut(ScalePrX(230),ScalePrY(Y),Title1);
  Font.Size := 10; Font.Style := [];
  TextOut(ScalePrX(500),ScalePrY(Y),
     'Page ' + IntToStr(PgNo) + ' of ' + IntToStr(TOTPAGES));
  y := Y + YIncr;
  TextOut(ScalePrX(200),ScalePrY(Y), 'TRANSMISSION FILE NUMBER ' +
            HDR.TRANSFLNO); y := Y + YIncr;
  TextOut(ScalePrX(250),ScalePrY(Y), 'For transmitted file: ' +
           LeftStr(HDR.INDRES1,8));
  Font.Size := 10; Font.Style := [];
  y := Y + YIncr *2;
  Tab1 := 100; Tab2 := 200; Tab3 := 300; Tab4 := 400;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Transmitter');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Preparer');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Transmission');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'Number of Returns');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'Number');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'Date & Time ');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),Title2);
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab2),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab3),ScalePrY(Y),'============');
  TextOut(ScalePrX(Tab4),ScalePrY(Y),'============');

  {ACCSUBHEADER; }
  DATETIME := MidStr(HDR.TRANSMDATE, 3, 2) + '/'
           + MidStr(HDR.TRANSMDATE, 5, 2) +
           '/' + RIGHTStr(HDR.TRANSMDATE, 2) + ' ' +
           LeftStr(HDR.TRANSMTIME, 2) + ':' +
           MidStr(HDR.TRANSMTIME, 3, 2) + ':' +
           RIGHTStr(HDR.TRANSMTIME, 2);
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), HDR.TRANSMITTERNO);
  TextOut(ScalePrX(Tab2),ScalePrY(Y), HDR.PREPARERID);
  TextOut(ScalePrX(Tab3),ScalePrY(Y), DATETIME);
  TextOut(ScalePrX(Tab4),ScalePrY(Y),
    '    '+FormatAccNonAccRecordCnt(HDR.NonACCEPTEDRECS));
  y := Y + YIncr * 2;
  Tab1 := 50; Tab2 := 200; Tab3 := 400; {Tab4 := 400;}
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Document Control');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), 'Client'+Chr(39)+'s First Name');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), 'Client'+Chr(39)+'s Last Name');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), 'Number');
  y := Y + YIncr;
  TextOut(ScalePrX(Tab1),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab2),ScalePrY(Y), '================');
  TextOut(ScalePrX(Tab3),ScalePrY(Y), '================');

        end;
     end
     ELSE
       IF MIDStr(A, 5, 2) = '99' THEN BREAKTRL(A);
 until EOF(F1);
 end;
 CloseFile(F1);
 Printer.EndDoc;
end;




Procedure ACCSUBHEADER;
Var DateTime : string;
Begin
  DATETIME := MidStr(HDR.TRANSMDATE, 3, 2) + '/'
           + MidStr(HDR.TRANSMDATE, 5, 2) +
           '/' + RIGHTStr(HDR.TRANSMDATE, 2) + ' ' +
           LeftStr(HDR.TRANSMTIME, 2) + ':' +
           MidStr(HDR.TRANSMTIME, 3, 2) + ':' +
           RIGHTStr(HDR.TRANSMTIME, 2);
End;

Procedure NONSUBHEADER;
Var DateTime : string;
Begin
  DATETIME := LEFTStr(HDR.TRANSMDATE, 4) + '/' +
           MidStr(HDR.TRANSMDATE, 5, 2) +
           '/' + RightStr(HDR.TRANSMDATE, 2) +
            ' ' + LeftStr(HDR.TRANSMTIME, 2) +
           ':' + MidStr(HDR.TRANSMTIME, 3, 2) +
            ':' + RightStr(HDR.TRANSMTIME, 2);
End;

Procedure BREAKTSR(A:string);
begin
  TSR.TRANSMTYPE    := MidStr(A, 1, 2);
  TSR.TRANSMITTERNO := MidStr(A, 3, 5);
  TSR.PREPARERID    := MidStr(A, 8, 5);
  TSR.INDRES1    := MidStr(A,13,10);
  TSR.INDRES2    := MidStr(A,23,10);
  TSR.TRANSMDATE := MidStr(A, 33, 8);
  TSR.TRANSMTIME := MidStr(A, 41, 6);
  TSR.TRANSFLNO  := MidStr(A, 47, 8);
  TSR.RETURNS := MidStr(A, 55, 4);
  TSR.SFDRECS := MidStr(A, 59, 4);
  TSR.ERRCODE1 := MidStr(A, 63, 2);
  TSR.ERRCODE2 := MidStr(A, 65, 2);
  TSR.ERRCODE3 := MidStr(A, 67, 2);

end;

Procedure BREAKERR(A:string);
begin
  With Err do
  begin
  TRANSMTYPE    := MidStr(A, 1, 2);
  TRANSMITTERNO := MidStr(A, 3, 5);
  PREPARERID    := MidStr(A, 8, 5);
  INDRES1    := MidStr(A,13,10);
  INDRES2    := MidStr(A,23,10);
  TRANSMDATE := MidStr(A, 33, 8);
  TRANSMTIME := MidStr(A, 41, 6);
  TRANSFLNO  := MidStr(A, 47, 8);
  ERRCode    := MidStr(A, 55, 2);
  end;
end;


Procedure BREAKHDR(A:string);
begin
  HDR.RECLEN        := MidStr(A, 1, 4);
  HDR.RECTYPE       := MidStr(A, 5, 2);
  HDR.TRANSMTYPE    := MidStr(A, 7, 2);
  HDR.TRANSMITTERNO := MidStr(A, 9, 5);
  HDR.PREPARERID    := MidStr(A, 14, 5);
  HDR.INDRES1       := MidStr(A, 19,10);
  HDR.INDRES2       := MidStr(A, 29,10);
  HDR.TRANSMDATE    := MidStr(A, 39, 8);
  HDR.TRANSMTIME    := MidStr(A, 47, 6);
  HDR.TRANSFLNO     := MidStr(A, 53, 8);
  HDR.ACKINDICATOR  := MidStr(A, 61, 1);
  HDR.TRANSCODE     := MidStr(A, 62, 2);
  HDR.TRANSMRECS    := MidStr(A, 64, 4);
  HDR.ACCEPTEDRECS  := MidStr(A, 68, 4);
  HDR.NONACCEPTEDRECS := MidStr(A, 72, 4);
end;

Procedure BREAKOKREC(A:string);
begin
  OKREC.RECLEN     := MidStr(A, 1, 4);
  OKREC.RECTYPE    := MidStr(A, 5, 2);
  OKREC.DOCUMENTNO := MidStr(A, 7, 13);
  OKREC.NAME       := MidStr(A, 20, 60);
end;


Procedure BREAKNOTOKREC(A:string);
begin
  NOTOKREC.RECLEN     := MidStr(A, 1, 4);
  NOTOKREC.RECTYPE    := MidStr(A, 5, 2);
  NOTOKREC.DOCUMENTNO := MidStr(A, 7, 13);
  NOTOKREC.NAME       := MidStr(A, 20, 60);
  NOTOKREC.ERRCODE1   := MidStr(A, 89, 6);
  NOTOKREC.ERRCODE2   := MidStr(A, 95, 6);
  NOTOKREC.ERRCODE3   := MidStr(A, 101, 6);
  NOTOKREC.ERRCODE4   := MidStr(A, 107, 6);
  NOTOKREC.ERRCODE5   := MidStr(A, 113, 6);
  NOTOKREC.ERRCODE6   := MidStr(A, 119, 6);
  NOTOKREC.ERRCODE7   := MidStr(A, 125, 6);
  NOTOKREC.ERRCODE8   := MidStr(A, 131, 6);
end;

Procedure BREAKTRL(A:string);
Begin
  TRL.RECLEN       := MidStr(A, 1, 4);
  TRL.RECTYPE      := MidStr(A, 5, 2);
end;


Procedure SubstituteData(FName:String;Fld:Integer;Var s:string);
Var RetNo:Integer;
begin
 If FName <> 'T1' then exit;
 RetNo:=GetCurrentRetNo;
 If UpperCase(FetchElm(RetNo,'INFO',48)) = 'X' then {c/o preparer}
  begin
    If fld = 8 then begin s:=OptRec.Prp_Name;exit;end; {c/o}
    If fld = 6 then begin s:=OptRec.Prp_Street;exit;end; {street}
    If fld = 10 then begin s:=OptRec.Prp_City;exit;end; {city}
    If fld = 14 then begin s:=OptRec.Prp_Prov;exit;end; {prov}
    If fld = 15 then begin s:=OptRec.Prp_Postal;exit;end; {prov}
    If fld = 22 then begin s:='';exit;end; {Apart No}
  end;
end;

Function PrintAuditList(FileNm,Hdr1,Hdr2,Hdr3: String):boolean;
var
  i,LineCnt,MxLinesPerPage,PageCnt:integer;PrnFile: TextFile;
  {TempList:TstringList;}
  XPos :LongInt;
//  PageX, PageY : LongInt; //20170212 Igor
  ScMult : Integer; s:string;
  F1 :TextFile;
//  ScaleX, ScaleY : Word; //20170212 Igor
  FirstTimeSw:boolean;
begin
  AssignFile(F1, FileNm);
  Reset(F1);

  FirstTimeSw := true;
  LineCnt:=0;PageCnt :=0;MxLinesPerPage :=60;
  {now print}
  Printer.BeginDoc;
  XPos := 30;
  ScMult :=10;
   //20170212 Igor>>>
  CalcScaleXY;
//  PageX:= Printer.PageWidth;
//  PageY :=Printer.PageHeight;
//  ScaleX := (PageX * ScMult) div 614; {to get the decimals}
//  ScaleY := (PageY * ScMult) div 1000; {formheight}
 //20170212 Igor<<<
  Repeat
   If (FirstTimeSw) or (LineCnt >MxLinesPerPage) then
   begin  {print headers}
     LineCnt:=1;
     Inc(PageCnt);
     If not FirstTimeSw then Printer.NewPage;

     Printer.Canvas.Font.Name := defFontName; //'Arial';  //20180124
     Printer.Canvas.Font.Size := 10;
     Printer.Canvas.Font.Style := [fsBold];
     Printer.Canvas.Font.Color := clBlack;
     Printer.Canvas.TextOut(
       ScalePrX(XPos),ScalePrX(LineCnt*15), //20170212 Igor
        Hdr1+' Page: '+IntToStr(PageCnt));

     Inc(LineCnt); {leave empty line}
     Printer.Canvas.Font.Name := 'Courier New';
     Printer.Canvas.Font.Size := 10;
     Printer.Canvas.Font.Style := [fsBold];
     {Printer.Canvas.Font.Style := [];}
     Printer.Canvas.Font.Color := clBlack;
     Inc(LineCnt);
     Printer.Canvas.TextOut(
        ScalePrX(XPos),ScalePrX(LineCnt*15),Hdr2); //20170212 Igor

     Inc(LineCnt);
     Printer.Canvas.TextOut(
        ScalePrX(XPos),ScalePrX(LineCnt*15),Hdr3); //20170212 Igor
     Inc(LineCnt,1);
   end; {headers}
   FirstTimeSw := False;
   Printer.Canvas.Font.Style := [];
   Readln(F1,s);
   Printer.Canvas.Font.Style := [fsBold];
   Printer.Canvas.Font.Color := clBlack;
   Printer.Canvas.TextOut(
    ScalePrX(XPos), ScalePrX(LineCnt*15), //20170212 Igor
          s);
   Inc(LineCnt);

   s:= ' ';
   Printer.Canvas.TextOut(
    ScalePrX(XPos), ScalePrX(LineCnt*15), //20170212 Igor
          s);
   Inc(LineCnt);
  until Eof(F1);
  CloseFile(F1);
  Printer.EndDoc;
  Result := True;
end;


Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0;
  AisSynPDF: Boolean = False);  //20161103 Igor
Var FieldId:Integer; R:TRect;aString,s:String;FormattedAmount : string;
x,y:LongInt; PenWidth:Integer;AlignTopBottomVar,tempPos:Integer; MyEditHandle:THandle;
PrintText,tempPrintText:String;
OldBrColor: TColor; //20170207 Iogr
nPrintTextHeight: integer; //20180126 Igor
//20180221 Igor >>>
WrapTextRect: TRect;
DrawStyle: Word;
//20180221 Igor <<<
Begin
  FieldId:=GetFieldId(MyEditBox.Name);
  if not AisSynPdf then
    ACanvas.Font.Size := MyEditBox.Font.Size + MainOptions.Prn_FontIncr //9; //10
  else
    ACanvas.Font.Size := Round(Abs(MyEditBox.Font.Height) *72/96) + MainOptions.Prn_FontIncr; //20170212 Igor


  R.Left   := MyEditBox.Left + ADLeft;
  R.Top    := MyEditBox.Top + ADTop;
  R.Right  := MyEditBox.Left + ADLeft + MyEditBox.Width;
  R.Bottom := MyEditBox.Top + ADTop + MyEditBox.Height;

//set font
  //20170207 Iogr >>>
  if (MyEditBox.vtInputType = vtCheckBox) AND (FetchElmFNo(RetNo,FNo,FieldId)  = '') then
  Begin
    OldBrColor := ACanvas.Brush.Color;
    ACanvas.Brush.Color := MyEditBox.Color;
    ACanvas.Brush.Style := bsSolid;
    ACanvas.FillRect(Rect(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom)));
    ACanvas.Brush.Color := OldBrColor;
  End;
  //20170207 Iogr <<<

  ACanvas.Font.Color := clBlack;
  ACanvas.Font.Style := [];
  //*** //20200129
  if PrintingCondensed=True then
  Begin
   if MyEditBox.Font.Style=[fsBold] then ACanvas.Font.Style := [fsBold]; //needs refinements to use only bolded lines by FieldId
  End;

  ACanvas.Brush.Style := bsClear;


  //20170205  //CRA requirement t1c_XX forms  must be bold edit boxes
  if (LeftStr(FName,4)='T1C_')
  then
  Begin
   if Fname='T1C_3' then
   Begin
    if FieldId<>121 //(FieldId<>59)  //20220101
    then  //this lnn[23600] Netincome, not a keying field //20200204
      ACanvas.Font.style:=[fsBold];  //20200128
    if FieldId=59 then //box 23600 //remove bold  //20220115
      ACanvas.Font.style:=[];

   end;

   If LeftStr(FName,5)<>'T1C_3' then  //this is the dynamic third page name tht gets inserted
   Begin
    if (PrintingCondensed=True) and (MyEditBox.Font.Style=[fsBold]) then ACanvas.Font.Style := [fsBold]; //20200130

    {
    //first page edit boxes only of T1C_XX
     if (FieldId<164) and (FieldId<>43) and (fieldId<>44) then  ACanvas.Font.Style := [fsBold]
     Else
      ACanvas.Font.Style := [fsBold]; // ACanvas.Font.Style := [];  //20200130
    }
   End;
  End;


  If LeftStr(Fname,5)='T4SUM' then
  begin
    ACanvas.Font.Name := 'Courier New';
    ACanvas.Font.Style:=[fsBold];
  end
  else
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
                if vtInputType = vtDollar then
                begin
                       PrintText := FormatAmount(FetchElmFNo(RetNo,FNo,FieldId),MyEditBox.vtVertSeparator);  //20111230
                       if MyEditBox.vtDecimalPlaces = 1 then
                       begin PrintText := leftstr(PrintText, length(PrintText)-3) end;

                       If LeftStr(FName,5)='T1273' then
                                PrintText := FormatPrintAmountForT1273(FetchElmFNo(RetNo,FNo,FieldId),MyEditBox.vtVertSeparator,FName,FieldId); //20111230
                       If isT1273NoDecimalSection(Fname,FieldId) then  PrintText:=FormatNoDecimals(FetchElmFNo(RetNo,FNo,FieldId),0);  //20120123
                       tempPrintText  := StringReplace(PrintText, '  ', '.',[rfReplaceAll, rfIgnoreCase]);
                       if Vl(tempPrintText) = 0 then
                       begin
                         If FName='T1C_3' then
                          PrintText:='0 .00'  //20111227
                         else
                          PrintText := '';
                       end;
                       if leftstr(PrintText,1) = ' ' then PrintText := '0' + PrintText;  //2005 to retain space and 0.78

                      //20240210
                     if leftStr(Fname,4)='T1C_' then //all condensed jackets do not print aeros forspuse SIN
                     Begin
                      if PrintText='1.00' then PrintText :='1';
                      if PrintText='0.00' then PrintText :='0';
                      if PrintText='0 .00' then PrintText :='0';
                     end;
               end

                else if vtInputType = vtSin then  //20200529
                begin
                 //PrintText := reFormatSin(FetchElmFNo(RetNo,FNo,FieldId)); //20111230 Ret[RetNo].Frm[FNo].Strings[FieldId])
                 if OptRec.Prn_HideSin=True then  //20200529
                   PrintText:=GetHiddenSin(FetchElmFNo(RetNo,FNo,FieldId))
                 Else
                   PrintText := reFormatSin(FetchElmFNo(RetNo,FNo,FieldId));
                end
                Else
                 PrintText := FetchElmFNo(RetNo,FNo,FieldId);
                //20180307 Igor >>>

                //20240210
                if leftStr(Fname,4)='T1C_' then //all condensed jackets do not print aeros forspuse SIN
                Begin
                 if fieldid=4 then
                 begin
                   if FetchElmFNo(RetNo,InfoFNo,4) = '000000000'  then PrintText :='';
                 end;
                end;


                //jz //20230217
                if (OptRec.Prn_HideSin=True)
                and (FName = 'T183')
                and (FieldId = 23) then
                begin
                  PrintText := GetHiddenRepId(FetchElmFNo(RetNo,FNo,FieldId));
                end;

                if FName = 'T7DRQR' then
                begin
                  if FieldId in [1, 8]  then
                    PrintText :=ReformatSinWithSpaceInBetween(GetSinNo(RetNo)) //FetchElm(RetNo, 'INFO', 3) //20180310 CON 9:48PM
                  else if FieldId in [2, 23] then
                    PrintText := FormatFloat('#,###,###.00',Vl(FetchElm(RetNo,'T7DRQR',2))) //20180319
                    //PrintText := FormatFloat('#,###,###.00', Ret[RetNo].Lnn[48500]) //20180310
                  else if FieldId = 66 then
                    PrintText := FetchElm(RetNo, 'INFO', 2) + ' ' + FetchElm(RetNo, 'INFO', 5)
                  else if FieldId = 5 then
                    PrintText := FetchElm(RetNo, 'INFO', 6)
                  else if FieldId = 6 then
                    PrintText := FetchElm(RetNo, 'INFO', 10)
                  else if FieldId = 7 then
                    PrintText := FetchElm(RetNo, 'INFO', 14)
                  else if FieldId = 9 then
                    PrintText := FetchElm(RetNo, 'INFO', 15)
                  else if FieldId = 4 then
                    PrintText := '01'
                  else if FieldId = 3 then
                    PrintText := '7'
                  else if FieldId = 10 then
                  begin
                    PrintText := '0100090001000700';
                    PrintText := PrintText + AddLeadingZeros(FetchElm(RetNo, 'INFO', 3), 15);
                    PrintText := PrintText + '00000000';  //20180310 Con 9:30 PM
                    //PrintText := PrintText + '0000';
                    PrintText := PrintText + AddLeadingZeros(IntToStr(Trunc(Vl(FetchElm(RetNo,'T7DRQR',2))*100)), 10); //20180319
                    //PrintText := PrintText + AddLeadingZeros(IntToStr(Trunc(Vl(FetchElm(RetNo,'T7DRQR',2)))*100), 10); //20180319
                   // PrintText := PrintText + AddLeadingZeros(IntToStr(Trunc(Ret[RetNo].Lnn[48500] * 100)), 10); //20180310
                    PrintText := PrintText + '010009';
                    PrintText := PrintText + CalcCheckDigitForT7DROCR(PrintText);

                    ACanvas.Font.Name := 'OCRA';
                  end;
                end;
                //20180307 Igor <<<

                //20180221 Igor >>>
                if vtWordWrap then
                begin
                  WrapTextRect.Left := 0;
                  WrapTextRect.Top := 0;
                  WrapTextRect.Right := ScalePrX(R.Right) - ScalePrX(R.Left);
                  WrapTextRect.Bottom := 0;

                  DrawText(ACanvas.Handle, PChar(PrintText), Length(PrintText), WrapTextRect, DT_LEFT or DT_WORDBREAK or DT_CALCRECT);
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
                  DrawText(ACanvas.Handle, PChar(PrintText), Length(PrintText), WrapTextRect, DrawStyle);
                end
                else
                begin
                  //20180126 Igor >>>
                  nPrintTextHeight := ACanvas.TextHeight(PrintText);
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
                             (* OUT?   20180126
                  if vtLayout = vtTop then
                         AlignTopBottomVar := ScalePrY(R.Top + 1)
                  else if vtLayout = vtMiddle then
                  begin
                          tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
                          AlignTopBottomVar := ScalePrY(R.Top) + tempPos - (ACanvas.TextHeight(PrintText) div 2);
                  end
                  else if vtLayout = vtBottom then
                  begin
                         AlignTopBottomVar := ScalePrY(R.Bottom) - ACanvas.TextHeight(PrintText);
                  end;
                  *)
                  if vtAlignment = taLeftJustify then
                  begin
                         //20190103 Igor >>>
                         if MyEditBox.vtBorderType in [vtFull, vtSides] then
                          ACanvas.Textout(ScalePrX(R.Left + 3),AlignTopBottomVar,PrintText)
                         else
                          ACanvas.Textout(ScalePrX(R.Left),AlignTopBottomVar,PrintText);
                         //20190103 Igor <<<
                  end
                  else if vtAlignment = taRightJustify then
                  begin
                         //20190103 Igor >>>
                         if MyEditBox.vtBorderType in [vtFull, vtSides] then
                          ACanvas.Textout(ScalePrX(R.Right - 3) - ACanvas.TextWidth(PrintText) - 3,AlignTopBottomVar,PrintText)
                         else
                          ACanvas.Textout(ScalePrX(R.Right) - ACanvas.TextWidth(PrintText) - 3,AlignTopBottomVar,PrintText);
                         //20190103 Igor <<<
                  end
                  else if vtAlignment = taCenter then
                  begin
                         tempPos := ((ScalePrX(R.Right) - ScalePrX(R.Left)) - ACanvas.TextWidth(PrintText)) div 2;
                         ACanvas.Textout(ScalePrX(R.Left) + tempPos , AlignTopBottomVar,PrintText)
                  end;
                end;
                //20180221 Igor <<<

                //add vertSeporator and paint prefix if vtDollar
                if vtinputType in [vtDollar, vtNumber] then //20180128 Igor
                begin
                       ACanvas.Textout(ScalePrX(R.Left),AlignTopBottomVar,vtPrefix); //20120118
                       if vtVertSeparator = True then
                       begin
                          //20161103 Igor >>>
                          if not AisSynPDF then
                          begin
                            ACanvas.Pen.Width := 1;
                            if vtBorderType = vtDoubleUnderLine then
                            begin
                                 ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') -1 , ScalePrY(R.Top) , ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2 , ScalePrY(R.Bottom) - 3)
                            end
                            else
                            begin
                                  ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 1, ScalePrY(R.Top) , ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2 , ScalePrY(R.Bottom));
                            end;
                          end
                          else
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
                          //20161103 Igor<<<
                       end;
                end;

                if MyEditBox.vtBorderType = vtNoBorder then
                begin
                  //
                end
                else if MyEditBox.vtBorderType = vtFull then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     //20161103 Igor>>>
                     if not AIsSynPDF then
                       ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right),ScalePrY(R.Bottom))
                     else
                     begin
                        ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
                        ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
                        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
                        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
                        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
                        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Top));
                     end;
                end
                else if MyEditBox.vtBorderType = vtsides then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     if not AIsSynPDF then
                     begin
                       ACanvas.Rectangle(ScalePrX(R.Left)      , ScalePrY(R.Top)   , ScalePrX(R.Left)+ 1  , ScalePrY(R.Bottom)); //R.Left, R.Top, R.Left + 1, R.Bottom);
                       ACanvas.Rectangle(ScalePrX(R.Left)      , ScalePrY(R.Bottom), ScalePrX(R.Right)    , ScalePrY(R.Bottom) - 1); //R.Left, R.Bottom, R.Right, R.Bottom - 1);
                       ACanvas.Rectangle(ScalePrX(R.Right) - 1 , ScalePrY(R.Top)   , ScalePrX(R.Right)    , ScalePrY(R.Bottom));     //R.Right - 1, R.Top, R.Right, R.Bottom);
                     end
                     else
                     begin
                        ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
                        ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
                        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
                        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
                        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
                     end;
                end
                else if MyEditBox.vtBorderType = vtUnderline then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     if not AIsSynPDF then
                       ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) - 1 , ScalePrX(R.Right) , ScalePrY(R.Bottom))
                     else
                     begin
                        ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
                        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
                        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
                     end;
                end
                else if MyEditBox.vtBorderType = vtDoubleUnderLine then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     if not AIsSynPDF then
                     begin
                       ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) - 1  , ScalePrX(R.Right) , ScalePrY(R.Bottom));
                       ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom)  - 3 , ScalePrX(R.Right) , ScalePrY(R.Bottom) - 2);
                     end
                     else
                     begin
                        ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
                        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
                        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
                        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom)+1);
                        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom)+1);
                     end;
                end
                else if MyEditBox.vtBorderType = vtTopBottomLine then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     if not AIsSynPDF then
                     begin
                       ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) -1 , ScalePrX(R.Right) , ScalePrY(R.Bottom));
                       ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Top) + 1   , ScalePrX(R.Right) , ScalePrY(R.Top));
                     end
                     else
                     begin
                        ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
                        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Top));
                        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Top));
                        ACanvas.MoveTo(ScalePrX(R.Left) , ScalePrY(R.Bottom));
                        ACanvas.LineTo(ScalePrX(R.Right) , ScalePrY(R.Bottom));
                     end;
                     //20161103 Igor<<<
                end;

        end; //with MyEditBox
  end;  //else

{$IFDEF globalForm}
  If ReviewOn(RetNo,FormNo,FieldId) then
{$ELSE}
  If ReviewOn(RetNo,FNo,FieldId) then { TODO 1 -oCon : check }
{$ENDIF}
  begin
     DrawingTool := dtEllipse; PenWidth := 3;
     ACanvas.Brush.Style := bsClear;
     DrawShape(Point(ScalePrX(R.Left-7), ScalePrY(R.Top-5)),
     Point(ScalePrX(R.Right+7),ScalePrY(R.Bottom+7)),PenWidth,ACanvas);
  end;

  (*
  {Draw review marks}
  If ReviewOn(RetNo,FormNo,FieldId) then
  begin
     DrawingTool := dtEllipse; PenWidth := 3;
     ACanvas.Brush.Style := bsClear;
     DrawShape(Point(R.Left-7, R.Top-5),
     Point(R.Right+7,R.Bottom+7),PenWidth,ACanvas);
  end;
 *)
  ACanvas.Font.Style := [];
  ACanvas.Pen.Width := 1; //20161103 Igor
end;

(*
Procedure PrintShape(MyShape:TShape;ACanvas:TCanvas);
Var FieldId:Integer; R:TRect;aString,s:String;FormattedAmount : string;
x,y:LongInt; PenWidth:Integer;

begin
  {Show Shapes}
  {incr := LineProperties;} {SizeOf(LnRec);}  {returns words = 16 bits}
     If PauseSw then PausePrinting;
     ACanvas.Pen.Width := MyShape.Pen.Width;
     ACanvas.Brush.Color := MyShape.Brush.color; //clWhite; {Self.Color;}
     ACanvas.Brush.Style := MyShape.Brush.Style; //bsClear;
     R.Left   := MyShape.Left;
     R.Top    := MyShape.Top;
     R.Right  := MyShape.Left + MyShape.Width;
     R.Bottom := MyShape.Top + MyShape.Height;
     R := ScalePrBox(R);

     If MyShape.Visible then
     begin
      Case  MyShape.tag of 0,6,7: //Shape {MyShape.ShapeStyle}        //?????????????????????????
       {stRectangle, stRoundRect, stRoundSquare://} {rect and roundrect}
        Begin
         If (MyShape.Width  = 1) or (MyShape.Height =1) then
         begin
          // DrawALine(MyShape.Top,MyShape.Left,MyShape.Width,MyShape.Height,MyShape.Pen.Width)
           DrawARectangle(R, MyShape.Brush.Color, MyShape.Pen.Width,ACanvas);
         end
         else
           DrawARectangle(R, MyShape.Brush.Color, MyShape.Pen.Width,ACanvas);
        end;
       {stCircle} 1: Begin DrawACircle(R, MyShape.Brush.Color, MyShape.Pen.Width,ACanvas);end;
       2..5: Begin DrawATriangle(R,MyShape.Brush.Color, MyShape.Pen.Width,0,ACanvas);End;
       100:
          begin
{          If FileExists(AppDir+'\'+'BarCode.BMP') then SysUtils.DeleteFile(AppDir+'\'+'BarCode.BMP');
          If FileExists(AppDir+'\'+'BarCode1.BMP') then SysUtils.DeleteFile(AppDir+'\'+'BarCode1.BMP');
          PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
          PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
          ht:=1.75 * PixelsPerInch.y;
          Wt:=3.5 * PixelsPerInch.x;

          CreateBarCodeBmp(RetNo,AppDir+'\'+'BarCode',Ht,Wt);
          Delay(500);
          for d:= 0 to 100 do
          begin
           if not FileExists(AppDir+'\'+'BarCode.BMP') then Delay(200);
          end;
          if not FileExists(AppDir+'\'+'BarCode.BMP') then
          begin
           ShowMessage('Barcode could not be created');
}          end
          else
          begin
{           BarCodeBmp := TBitmap.Create;
           BarCodeBmp.LoadFromFile(AppDir+'\'+'BarCode.BMP');
           //ACanvas.StretchDraw(R,BarCodeBmp);
           ACanvas.Draw(R.Left,R.Top,BarCodeBmp);
           BarCodeBmp.Free;
}        end;
     end;
   end;    {end do block}
end;
*)

Procedure PrintSFDBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; SFDBarCodeImage1:TImage; SFDBarCodeImage2:TImage);
var
 PixelsPerInch: TPoint;
 Ht,Wt:Real;
 i,d:integer;
 BarCodeBmp:TBitMap;
 R:TRect;
begin
          If FileExists(AppDir+'\'+'SFDBarCode.BMP') then SysUtils.DeleteFile(AppDir+'\'+'SFDBarCode.BMP');
          If FileExists(AppDir+'\'+'SFDBarCode1.BMP') then SysUtils.DeleteFile(AppDir+'\'+'SFDBarCode1.BMP');
          PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
          PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);

          ht:=1.75 * PixelsPerInch.y;
          Wt:=3.5 * PixelsPerInch.x;

          maxBarDataLength := 877;
          if (PixelsPerInch.y < 360) or (PixelsPerInch.y < 360) then
           maxBarDataLength := 850;


          //if not CreateSFDBarCodeBmp(RetNo,AppDir+'\'+'SFDBarCode.BMP',AppDir+'\'+'SFDBarCode1.BMP',Ht,Wt,maxBarDataLength) then
          //begin
          // exit;
          //end;

          for d:= 0 to 100 do
          begin
           if not FileExists(AppDir+'\'+'SFDBarCode.BMP') then Delay(300); //200  //20201213
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
end;

Procedure PrintBarcodeBitmap(RetNo:Integer;Canvas: TCanvas; BarCodeImage1:TImage; BarCodeImage2:TImage);
var
 PixelsPerInch: TPoint;
 Ht,Wt:Real;
 d:integer;
 BarCodeBmp:TBitMap;
 R:TRect;
begin
          If FileExists(AppDir+'\'+'BarCode.BMP') then SysUtils.DeleteFile(AppDir+'\'+'BarCode.BMP');
          If FileExists(AppDir+'\'+'BarCode1.BMP') then SysUtils.DeleteFile(AppDir+'\'+'BarCode1.BMP');
          PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
          PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
          ht:=1.75 * PixelsPerInch.y;
          Wt:=3.5 * PixelsPerInch.x;

          maxBarDataLength := 877;
          if (PixelsPerInch.y < 360) or (PixelsPerInch.y < 360) then
           maxBarDataLength := 850;

//          if not CreateBarCodeBmp(RetNo,AppDir+'\'+'BarCode.BMP',AppDir+'\'+'BarCode1.BMP',Ht,Wt,maxBarDataLength) then
//          begin
//           exit;
//          end;

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
end;


Procedure AfterReadComponentForPrint(AForm:TForm;FName:String);
Var i:Integer;
CONST
  pxl = 96; //20160204 Igor
begin
  If IsFormAClientLetter(FName) then
  begin
    //get the image
    for i := 0 to AForm.ComponentCount - 1 do
    begin
      If aForm.Components[i] is TPanel then
        (aForm.Components[i] as TPanel).Visible:=False;

      If (aForm.Components[i] is TRichEdit) AND //20160819 Igor
         ((aForm.Components[i] as TRichEdit).align = alClient) then //20160203 Igor //20160819 Igor
      Begin
        with TRichEdit(aForm.Components[i]) do //20160819 Igor
        Begin
          Align := alNone;

          SetBounds(ROUND(MainOptions.Prn_LMargin*pxl),Top,
            Width - ROUND(MainOptions.Prn_LMargin*pxl) - ROUND(MainOptions.Prn_RMargin*pxl),Height); //20160204 Igor
        end;
      end;
    end;
  end;
end;

Procedure PrintT7DRA(RetNo:Integer;XAdj,YAdj:Real;Vers:String;PrintOwing:Boolean);
{pos in inches}
Var
  i,j, PixPerInX,PixPerInY : Integer;
  hdc : THandle;
  NullString : Array [0..100] of Char;
  tempSIN,tempPostal,tempProv:String;
  s:string; //[100];
  VertIncr:real;
  Col1X,Col2X : real;
 // InitPosX, InitPosY:Real;
  LastXPos:Real;
  FNumSlips:real;
  XPos,YPos :Real;
  CommonFmt :string; //[20];
  AmtLength : integer;
  DataField : Array[1..60] of string; {inches}
  DataVal :   Array[1..60] of string; {inches}
  XPosition : Array[1..60] of real; {inches}
  YPosition : Array[1..60] of real; {inches}
  RJust     : Array[1..60] of boolean; {for right justif of amounts in summ}
  Frmt      : Array[1..60] of string; //[20]; {inches}

begin
  Printer.Canvas.Font.Name := 'Courier New';
  Printer.Canvas.Font.Size := 8;
  //InitPosX:=XAdj;
  //InitPosY:=YAdj;
  VertIncr := 1/6;  {horiz :0.125 per each tick on ruler}
  AmtLength := 12;
 {initialize arrays}
  For i:=Low(DataField) to High(DataField) do
  begin
   DataField[i] :=''; XPosition[i] :=0;
   YPosition[i] :=0;  DataVal[i]   := '';
   RJust[i] := False;
   Frmt[i] :='';
  end;
  Col1X :=XAdj+2+1.5/8;
  Col2X :=XAdj+6+2.3/8;

  //Col1X :=InitPosX+2.1;
  //Col2X :=Col1X+4.12;

  //YPos:=YAdj+1+2/8;
  if vers='0' then
    YPos :=YAdj+1+1.5/8
  else
    YPos := YAdj+1+2/8;

  i:=0;
  LastXPos := 0;
  tempSin := alltrim(GetSinNo(RetNo));
  for j := 1 to length(tempSin) do
  begin
    DataField[i+j] :='first SIN';
    XPosition[i+j] := Col2X + LastXPos;//Col2X - 0.035 + LastXPos;
    LastXPos := LastXPos + 0.20;
    YPosition[i+j] := YPos;
    DataVal[i+j] := tempSin[j];
  end;
  i := i + j;
  //YPos := YAdj+2+2/8;  //2.4167 + YAdj;
  if vers='0' then
    YPos := YAdj+2+1.3/8  //2.4167 + YAdj;
  else
    YPos := YAdj+2+2/8;  //2.4167 + YAdj;

  Inc(i); DataField[i] := 'Due';
          If PrintOwing=False then
           DataVal[i] := FormatFloat('###,###,###',trunc(Ret[RetNo].Lnn[48600]))
          else
           DataVal[i] := FormatFloat('###,###,###',trunc(Ret[RetNo].Lnn[48500]));
          XPosition[i] := Col1X + 5.40 - length(DataVal[i]) * 0.065; //Col1X + 5.35 - length(DataVal[i]) * 0.065;
          YPosition[i] := YPos;

  Inc(i); DataField[i] := 'Due';
          If PrintOwing=False then
            DataVal[i] :=FormatFloat('###,###,###.00',Ret[RetNo].Lnn[48600])
          else
            DataVal[i] := FormatFloat('###,###,###.00',Ret[RetNo].Lnn[48500]);

          DataVal[i] := rightstr(DataVal[i],2);
          XPosition[i] := Col1X + 5.5;
          YPosition[i] := YPos;

  YPos := 4.25 + YAdj;
  Inc(i); DataField[i] :='First name';XPosition[i] := Col1X+1/16;
          YPosition[i] := YPos;
          DataVal[i] := GetFirstName(RetNo);

  Inc(i);
  LastXPos := 0;
  for j := 1 to length(tempSin) do
  begin
    DataField[j+i] :='second SIN';
    XPosition[j+i] := Col2X + LastXPos;
    LastXPos := LastXPos + 0.20;
    YPosition[j+i] := YPos;
    DataVal[j+i] := tempSin[j];
  end;
  i := i + j;

  YPos := 4.583 + YAdj;
  Inc(i); DataField[i] := 'Last Nm';XPosition[i] := Col1X+1/16;
          YPosition[i] := YPos;
          DataVal[i] := GetLastName(RetNo);

  YPos := 4.9167 + YAdj;
  Inc(i); DataField[i] := 'Street';XPosition[i] := Col1X+1/16;
          YPosition[i] := YPos;
          DataVal[i] := FetchElm(RetNo,'INFO',6)+' '+FetchElm(RetNo,'INFO',22);

  YPos := 5.25 + YAdj;
  Inc(i); DataField[i] := 'RR box';XPosition[i] := Col1X+1/16;
          YPosition[i] := YPos;
          DataVal[i] := FetchElm(RetNo,'INFO',68);

  YPos := 5.583 + YAdj;
  Inc(i); DataField[i] := 'CITY';XPosition[i] := Col1X+1/16;
          YPosition[i] := YPos;
          DataVal[i] := FetchElm(RetNo,'INFO',10);

  Inc(i);
  LastXPos := 0;
  tempProv := alltrim(FetchElm(RetNo,'INFO',14));
  for j := 1 to length(tempProv) do
  begin
          DataField[i+j] := 'PROV';
          XPosition[i+j] := Col1X + 2.05 + LastXPos; //Col1X + 1.965 + LastXPos;
          LastXPos := LastXPos + 0.20;
          YPosition[i+j] := YPos;
          DataVal[i+j] := tempProv[j];
  end;
  i := i + j;

  Inc(i);
  LastXPos := 0;
  tempPostal := alltrim(RemoveChar(FetchElm(RetNo,'INFO',15),' '));
  for j := 1 to length(tempPostal) do
  begin
          DataField[i+j] := 'Postal';
          XPosition[i+j] := Col1X + 2.6 + LastXPos;//Col1X + 2.5 + LastXPos;
          LastXPos := LastXPos + 0.20;
          YPosition[i+j] := YPos;
          DataVal[i+j] := tempPostal[j];
  end;
  i := i + j;

  Inc(i); DataField[i] := 'Due';
          If PrintOwing=False then
           DataVal[i] := FormatFloat('###,###,###',trunc(Ret[RetNo].Lnn[48600]))
          else
           DataVal[i] := FormatFloat('###,###,###',trunc(Ret[RetNo].Lnn[48500]));
          XPosition[i] := Col1X + 5.38 - length(DataVal[i]) * 0.065;
          YPosition[i] := YPos;

  Inc(i); DataField[i] := 'Due';
          If PrintOwing=False then
            DataVal[i] :=FormatFloat('###,###,###.00',Ret[RetNo].Lnn[48600])
          else
            DataVal[i] := FormatFloat('###,###,###.00',Ret[RetNo].Lnn[48500]);
          DataVal[i] := PaddRZero(rightstr(DataVal[i],2),2);
          If (Ret[RetNo].Lnn[48600]=0) and (Ret[RetNo].Lnn[48500]=0) then
              DataVal[i]:=Space(14);
          XPosition[i] := Col1X+5.55;
          YPosition[i] := YPos;

  Printer.Canvas.Font.Name := defFontName; //'Arial';  //20180124'Arial';
  PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
  PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
  Printer.Canvas.Font.Size := 10;
  hdc := Printer.Canvas.Handle;

  For i := Low(XPosition) to High(XPosition) do
  begin  {convert to pixels}
    XPos := ConvertToPixelsX(XPosition[i],PixPerInX);
    YPos := ConvertToPixelsY(YPosition[i],PixPerInY);
    SetTextAlign(hdc,TA_LEFT);
    Printer.Canvas.Pen.Color := clBlack;
    SelectObject(hdc,Printer.Canvas.Font.handle);
    SetBkMode(hdc,TRANSPARENT);
    SetTextAlign(hdc,TA_LEFT);
    TextOut(hdc,Round(XPos),Round(YPos),StrPCopy(NullString,DataVal[i]),
                Length(DataVal[i]));
   end;
end;

Procedure AttachBarCode(RetNo: Integer; Canvas: TCanvas; BarCodeImage1: TImage;
  ADTop: Integer = 0; ADLeft: Integer = 0);
var
  i,j,TotalRsiWithData,maxBarDataElements,TotalBarCodeCount:Integer;
  tempBarData:AnsiString;

  SplitBarDataArray:Array of AnsiString;
  BarCodeImageArray:Array of TImage;
begin
  PrepareT1Rec(RetNo);

  AppendT1Rec;
  tempBarData := barData;

  //for testing.................
  ClipBoard.AsText := barData;
//  tempBarData := ''; for i:=0 to 1750 do  tempBarData := tempBarData + '0';



  maxBarDataElements := 876; //735;
  TotalBarCodeCount := 0;

  j := 1;
  while tempBarData > '' do
  begin
   setLength(SplitBarDataArray,j);
   SplitBarDataArray[j - 1] := leftStr(tempbarData,maxBarDataElements);
   tempBarData := midStr(tempbarData,maxBarDataElements + 1,length(tempbarData) - maxBarDataElements);
   inc(j,1);
   inc(TotalBarCodeCount,1);
  end;

  If TotalBarCodeCount > 0 then
  begin

   SetLength(BarCodeImageArray, TotalBarCodeCount);
   CreateBarCode(SplitBarDataArray,BarCodeImageArray);
   PaintBarCode(Canvas, BarCodeImageArray, BarCodeImage1, ADTop, ADLeft);

  end;
end;

Procedure AttachSFDBarCode(RetNo: Integer; Canvas: TCanvas; BarCodeImage1: TImage;
  ADTop: Integer = 0; ADLeft: Integer = 0);
var
i,j,maxBarDataElements,TotalBarCodeCount:Integer;
SfdFormName:String;
BarFormNames:TStringList;
SFDBarDataArray:Array of AnsiString;
BarCodeImageArray:Array of TImage;
begin
  BarFormNames:=TStringList.Create;
  SfdRecNumber := 0;
  FindSFDFormNamesForBarCode(RetNo,BarFormNames);

  maxBarDataElements := 876; //735;

  TotalBarCodeCount := 0;

  For i:=0 to BarFormNames.count-1 do
  begin
   BarData:='';
   SfdFormName:=BarFormNames[i];
   PrepareSFDRec(RetNo,SFDFormName);
   AppendSFDRec(RetNo,SfdFormName);

   setLength(SFDBarDataArray,i+1);
   SFDBarDataArray[i] := barData;

   //for testing.................
   //  tempBarData := ''; for i:=0 to 1750 do  tempBarData := tempBarData + '0';

   inc(TotalBarCodeCount,1);
  end;


  If TotalBarCodeCount > 0 then
  begin
   SetLength(BarCodeImageArray, TotalBarCodeCount);
   CreateSFDBarCode(SFDBarDataArray, BarCodeImageArray);
   PaintBarCode(Canvas, BarCodeImageArray, BarCodeImage1, ADTop, ADLeft);
  end;
end;

Procedure Attach1013BarCode(RetNo: Integer; FName: String; Canvas: TCanvas;
  BarCodeImage1: TImage; ADTop: Integer = 0; ADLeft: Integer = 0);
var
i,j,TotalRsiWithData,maxBarDataElements,TotalBarCodeCount:Integer;
tempBarData:String;

SplitBarDataArray:Array of AnsiString;
BarCodeImageArray:Array of TImage;
begin
  Prepare1013Rec(RetNo,FName);
  Append1013Rec;

  tempBarData := barData;

//for testing.................
//  tempBarData := ''; for i:=0 to 1750 do  tempBarData := tempBarData + '0';

  maxBarDataElements := 876; //735;
  TotalBarCodeCount := 0;

  j := 1;
  while tempBarData > '' do
  begin
   setLength(SplitBarDataArray,j);
   SplitBarDataArray[j - 1] := leftStr(tempbarData,maxBarDataElements);
   tempBarData := midStr(tempbarData,maxBarDataElements + 1,length(tempbarData) - maxBarDataElements);
   inc(j,1);
   inc(TotalBarCodeCount,1);
  end;

  If TotalBarCodeCount > 0 then
  begin
   SetLength(BarCodeImageArray, TotalBarCodeCount);
   CreateBarCode(SplitBarDataArray,BarCodeImageArray);
   PaintBarCode(Canvas, BarCodeImageArray,BarCodeImage1, ADTop, ADLeft);
  end;
end;

//20190129 margins
procedure PaintBarCode(ACanvas: TCanvas; Var BarCodeImageArray: Array of TImage;
  BarCodeImage1:TImage; ADTop: Integer = 0; ADLeft: Integer = 0);

var
i,dpiAdjustment, barscaleWidthAdjustment, barscaleHeightAdjustment:Integer;
PageX, PageY : LongInt;
 barcodeTopPos:Integer; //20180201
R : TRect;
hdc: THandle;
RetNo,barCodePos:Integer;

  strm: TMemoryStream; //20170307 Igor
  B: TBitmap;          //20170307 Igor
begin
 barCodePos:=1;

 for i :=  high(BarCodeImageArray) downto low(BarCodeImageArray) do
 begin
   if BarCodeImageArray[i] <> nil then
   begin
     barcodeTopPos := BarCodeImage1.Top;
     if i = 1 then
     begin
      BarCodeImageArray[i].Top  := barcodeTopPos;
      BarCodeImageArray[i].Left := 25;
     end
     else
     begin
      BarCodeImageArray[i].Top  := barcodeTopPos;
      BarCodeImageArray[i].Left := 300; //20230125 to keep it no more than .50 inces from the first one //330; //20190129 Con
   end;


   (* 20180201
    if i = 0 then
    begin
     BarCodeImageArray[i].Top  := BarCodeImage1.Top;    //BarCodeTopArray[barCodePos];
     BarCodeImageArray[i].Left := 11;                   //20180124 //BarCodeImage1.Left; //BarCodeLeftArray[barCodePos];
     //showmessage('BarCodeImage1.Top; ' + inttostr(BarCodeImageArray[i].top));
    end
    else
    begin
     BarCodeImageArray[i].Top  := BarCodeImageArray[i-1].Top;   //BarCodeImage2.Top;   //BarCodeTopArray[barCodePos];
     BarCodeImageArray[i].Left := 300;                          //20180124 //BarCodeImageArray[i-1].Left - 312; //+ 312;  //BarCodeImage2.Left; //BarCodeLeftArray[barCodePos];
     //showmessage('BarCodeImageArray[i-1].Top; ' + inttostr(BarCodeImageArray[i].top));
    end;
   *)
    R.Left := ScalePrX(BarCodeImageArray[i].Left + ADLeft);
    R.Top := ScalePrY(BarCodeImageArray[i].Top + ADTop);
    R.Right := ScalePrX(BarCodeImageArray[i].Left + ADLeft + BarCodeImageArray[i].Width - 100);
    R.Bottom := ScalePrY(BarCodeImageArray[i].Top + ADTop + BarCodeImageArray[i].Height - 50);
    //20170307 Igor >>>
    B := TBitmap.Create;
    try
      B.Height := BarCodeImageArray[i].Height;
      B.Width := BarCodeImageArray[i].Width;
      strm := TMemoryStream.Create;
      try
        BarCodeImageArray[i].Picture.Graphic.SaveToStream(strm);
        strm.Position := 0;
        B.LoadFromStream(strm);
      finally
        strm.Free;
      end;
      ACanvas.StretchDraw(R, B);
    finally
      B.Free;
    end;
    //ACanvas.StretchDraw(R, BarCodeImageArray[i].Picture.Graphic);
    //20170307 Igor <<<
    inc(barCodePos,1);
   end //end if nil
 end; // end for
end;

function GetQRContentsForT7DR(RetNo: Integer): string; //20180308 Igor
var QRContents, ClientName: string;
begin
  QRContents := '063491087721000037CRAINDIVIDUALARC';
  QRContents := QRContents + RightStr(FetchElm(RetNo, 'INFO', 3), 4);
  QRContents := QRContents + '01';
  ClientName := FetchElm(RetNo, 'INFO', 2) + ' ' + FetchElm(RetNo, 'INFO', 5);
  ClientName := AddLeadingSpaces(LeftStr(RemoveDiacriticChars(ClientName), 35), 35);
  QRContents := QRContents + ClientName;
  QRContents := QRContents + AddLeadingSpaces(FetchElm(RetNo, 'INFO', 3), 15);
  QRContents := QRContents + '1017';
  QRContents := QRContents + RightStr(AppYear, 2) + '1231';
  Result := QRContents;
end;

procedure AttachQRCode(AQRContents: string; Canvas: TCanvas;
  QRCodeImage: TImage; ADTop: Integer = 0; ADLeft: Integer = 0); //20180307 Igor
var R: TRect;
begin
  R.Left := ScalePrX(QRCodeImage.Left + ADLeft);
  R.Top := ScalePrY(QRCodeImage.Top + ADTop);
  R.Right := R.Left + ScalePrX(QRCodeImage.Width);
  R.Bottom := R.Top + ScalePrX(QRCodeImage.Width);
  DrawQRCode(AQRContents, Canvas, R);
end;

(*  20180310 Moved to TrimStr of T1
function CalcCheckDigitForT7DROCR(ALine: string): string; //20180307 Igor
var cLine1, cLine2, cLine3, cLine4: string;
    nTotalSum: integer;

    function SumLine(ASumLine: string; AStartWeight: integer): integer;
    var i, nSum, weight: integer;
    begin
      Result := 0;
      weight := AStartWeight;
      for i := Low(ASumLine) to High(ASumLine) do
      begin
        nSum := StrToInt(ASumLine[i]) * weight;
        if nSum >= 10 then
          nSum := nSum div 10 + nSum mod 10;
        Result := Result + nSum;
        if weight = 2 then
          weight := 1
        else
          weight := 2;
      end;
    end;

begin
  Result := '';
  cLine1 := Copy(ALine, 1, 16);
  cLine2 := Copy(ALine, 17, 15);
  cLine3 := Copy(ALine, 32, 18);
  cLine4 := Copy(ALine, 50, 6);
  nTotalSum := SumLine(cLine1, 2) + SumLine(cLine2, 2)
             + SumLine(cLine3, 1) + SumLine(cLine4, 1);
  Result := IntToStr(10 - nTotalSum mod 10);
end;
*)
Function GetLineValue(RetNo:Integer;LLine:Integer):String;
Var i,k:Integer;Eflines:TStringList;sLine:String;s:String;
   Rule, ElmNo:integer; LType, FName :string; //[12];
  // LLineString:string; //[4];
   Efline:Integer;
begin
 //if lline=50339 then showmessage('50339');
 Result:='';
 Eflines := TstringList.Create;
 EfLines.LoadFromFile(AppDir+'\'+GetEfileDname(RetNo)); //'EFLINE.D');
 SLine:=IntToStr(LLine);  //incoming line number as string
 For i := 0 to Eflines.Count - 1 do
 begin
   s:='';  //Result
  // Efline:=AllTrim(LeftStr(Eflines[i],4));
   k:=IsInList(Sline,EfLines);
   If K>=0 then   //exists on Eflines
   begin
    EFLine := MyStrToInt(AllTrim(LeftStr(Eflines[K],5))); //20191229 //5 not 4

    If EfLine = 99999 then break; // ? last line of eflines
    // 20191229reposition the column numbers
    LType := UpperCase(MidStr(Eflines[k],6,1));
    FName :=AllTrim(MidStr(Eflines[k],8,9));
    ElmNo := MyStrToInt(AllTrim(MidStr(Eflines[k],18,3)));
    If MidStr(Eflines[k],22,1) = 'R' then
      Rule := MyStrToInt(AllTrim(MidStr(Eflines[k],23,5)))  //5 instead of 4
    else
      Rule := 0;
    If LLine>0 then //20191129
    begin
       S := GetNetFileAmount(RetNo,EfLine,LType,FName,ElmNo,Rule);
       if (LLine=31000) and (Ret[RetNo].Province='QC') then Begin LType:='C';s:=L50320Val;End; //20200206
       IF (LType='C') and (Length(s)>2) then s:=FormatFloat('#######.00',Vl(S)/100); // 20111223
        //  s:=LeftStr(s,Length(s)-2);  //comes multiplied by 100 //FormatFloat('#,###,###.##',Vl(S)/100); // **

       If (EfLine>0) and (LType='C') and (Vl(s) =0) then s:='';
       If (EfLine>0) and (LType<>'N') and (s>'') then s:=FormatFloat('########.##',Vl(s)); //20111222
       If (EfLine>0) and (LType='$') and (Vl(s) =0) then s:='';
       //20251227CZ
       {
       //20200205
       If EfLine=63790 then
       Begin
        if Ret[RetNo].Province='YT' then
        begin
         if UpperCase(FetchElm(retNo,'S14YT',1))='X' then s:='1' else s:='2';
        end
        Else
         s:='';
       End;
       }
       //---------------
    end;
   end; //found on list
   Result:=s;
   s:='';
   Eflines.Free;
   Exit;
  end;  //i
  Eflines.Free;
end;

//jz//20250305 - added RetNo to pass along to GetEfileDname(RetNo)
Procedure GetScheduleRelatedLines(RetNo:Integer;FrmNm:String;Var ScheduleRelatedLines:TStringList);
Var
i,j:Integer;
s:string;
wlist,Eflines:TStringList;
Begin
 WList := TstringList.Create;
 Eflines := TstringList.Create;
 //no retno available
 //EfLines.LoadFromFile(AppDir+'\'+GetEfileDname(1)); //jz//20250305 //'EFLINE.D'); //no retno available use 1
 EfLines.LoadFromFile(AppDir+'\'+GetEfileDname(RetNo)); //jz//20250305 for some reason you keep puting '1' instead of RetNo, STOP DOING THIS

 //If FrmNm='RC381' then Showmessage ('RC381');  //20220113
 For i := 0 to Eflines.Count - 1 do   //build the Schedule related lines from the EFlines.d
 begin
     s := AllTrim(MidStr(Eflines[i],31,29)); //20191229 //AllTrim(MidStr(Eflines[i],30,29));
     ParseWords(s,',',WList);
     for j:=0 to WList.count - 1 do
     begin
       //if Wlist[j]='RC381' then ShowMessage('RC381');  //20220113
       if FrmNm=WList[j] then
       begin
         ScheduleRelatedLines.Add(AllTrim(LeftStr(Eflines[i],5))+AllTrim(MidStr(Eflines[i],6,1)));
       end;
     end;
 end;
 ScheduleRelatedLines.SaveToFile(AppDir+'\'+'Schedulelines.txt');  //20120122
 WList.free;
 Eflines.free;
end;

//20111220 currenttop should be VAR as it is being changed by this routine
Procedure PrintCondensedFormLines(RetNo:Integer;T1CFNo:Integer;ALabel:TvtLabel;AvtEditBox:TvtEdit;StartingLeft,Displacement:Integer;Var CurrentTop:Integer;verticalAdvance:integer;hdc:THandle;ACanvas:TCanvas;FrmNm:string;formDisplayName:string);
var
 i,k,FrmFNo:integer;
 ScheduleRelatedLines:TStringList;
 DummyCRALines:TStringList;
 LLine:Integer;
 LType:string; //[1];
 LValue:String;
 AShape:TvtShape;
 FName: string;   //20170217
  //FieldId:Integer;
begin
 DummyCraLines:=TStringList.Create;

 //20200114
 If Ret[RetNo].Province='NL' then  DummyCRALines.Add('56000');
 If Ret[RetNo].Province='PE' then  DummyCRALines.Add('56010');
 If Ret[RetNo].Province='NS' then  DummyCRALines.Add('56020');
 If Ret[RetNo].Province='NB' then  DummyCRALines.Add('56030');
 If Ret[RetNo].Province='ON' then  DummyCRALines.Add('56050');
 If Ret[RetNo].Province='MB' then  DummyCRALines.Add('56060'); //20200211
 If Ret[RetNo].Province='SK' then  DummyCRALines.Add('56070');
 If Ret[RetNo].Province='AB' then  DummyCRALines.Add('56080'); //20130124
// If Ret[RetNo].Province='??' then  DummyCRALines.Add('5608');  //QC?  //20130124
 If Ret[RetNo].Province='BC' then  DummyCRALines.Add('56090');
 If Ret[RetNo].Province='NT' then  DummyCRALines.Add('56100');
 If Ret[RetNo].Province='YT' then  DummyCRALines.Add('56110');
 If Ret[RetNo].Province='NU' then  DummyCRALines.Add('56140');

  CurrentTop:=CurrentTop+VerticalAdvance *2;   //20111220 to leave space after each section
       //Displacement:=115;  //pixels //moved to calling function 20130316
       //print section header
       ALabel.Caption:=formDisplayName;
      // ALabel.Font.style:=[];   //20180115
       Alabel.Left:=StartingLeft;
       ALabel.Top:=CurrentTop;
       PrintLabel(ALabel,ACanvas);
       CurrentTop:=CurrentTop+Alabel.height;

       //print related lines
       ScheduleRelatedLines:=TStringList.Create;
       If FrmNm='FORM428' then
       begin
         For k:=0 to DummyCRAlines.count-1 do ScheduleRelatedLines.add(DummyCRAlines[k]);
       end;

       GetScheduleRelatedLines(RetNo,FrmNm,ScheduleRelatedLines);

       //20220125
       if FrmNm='T1DUMMY' then
       Begin
        ScheduleRelatedLines.Add('40600');
        ScheduleRelatedLines.Add('41800');
        ScheduleRelatedLines.Add('55295');
       End;


        //20111225
       If FrmNm='T691' then
       begin
        DummyCRALines.Clear;DummyCRALines.Add('67900');  //20200114
        ScheduleRelatedLines.add('67900');  //20111225
       end;

       If FrmNm='T1A' then  //20111225
       begin
        DummyCRALines.Clear;DummyCRALines.Add('66550');
        ScheduleRelatedLines.add('66550');  //20111225
       end;

       If FrmNm='T936' then
       begin
        DummyCRALines.Clear;DummyCRALines.Add('68130');
        ScheduleRelatedLines.add('68130');
       end;

       k:=0; //boxes index in a row;
       For i:=0 to ScheduleRelatedLines.count-1 do
       begin
         LLine:=StrToInt(LeftStr(ScheduleRelatedLines[i],Length(ScheduleRelatedLines[i])-1));
         if LLine=4060 then LLine:=40600;  //202220125 for some reason is truncated
         if LLine=4180 then LLine:=41800;   //??? 20230125 for some reason is truncated
         if LLine=5529 then LLine:=55295;

         If IsinList(IntToStr(LLine),DummyCRALines)>-1 then
           LLINE:=StrToInt(LeftStr(ScheduleRelatedLines[i],Length(ScheduleRelatedLines[i])));

         LType:=UpperCase(RightStr(ScheduleRelatedLines[i],1));
         if LLine=40600 then LType:='C'; //20230225
         if LLine=41800 then LType:='C'; //20230225

         LValue:=GetLineValue(RetNo,LLine);

         //20220125
         If LLine=40600 then LValue:=FormatFloat('#########.##',Ret[RetNo].Lnn[40600]);
         If LLine=41800 then LValue:=FormatFloat('#########.##',Ret[RetNo].Lnn[41800]);
         If LLine=42800 then LValue:=FormatFloat('#########.##',Ret[RetNo].Lnn[42800]);
         //If LLine=55295 then LValue:=  in S5
         //=================

         If (Ret[RetNo].Province='QC')
         Or (vl(FetchElm(RetNo,'EFMEMO',49))>0)  //20130123
         then  //20120111
         begin
          //20200112
           If LLine=30800 then LValue:=FormatFloat('#########.##',Ret[RetNo].Lnn[30800]);
           If LLine=31000 then LValue:=FormatFloat('#########.##',Ret[RetNo].Lnn[31000]);
           If LLine=31200 then LValue:=FormatFloat('#########.##',Ret[RetNo].Lnn[31200]);
           If LLine=22300 then LValue:=FetchElm(RetNo,'S10',27); //20120123
         end;

         If (Lline=61140) and (Ret[RetNo].Province='MB') then Ltype:='$'; //20120309
         Lvalue:=GetExceptionalValue(RetNo,FrmNm,LLine,Lvalue); //20111225

         //iF (Lline=38108) and (GetSinNo(RetNo)='870002029') then begin Lvalue:='1';LType:='$';end; //20220428
        // If (Lline=38108) and (GetSinNo(RetNo)='870002029') then begin Lvalue:='1';LType:='N';end; //20220428 //20240104

        // If (Lline=38108) and (Vl(Lvalue)=1) then Lvalue:='';  //20190114 //for s6
        // If (Lline=38108) and (GetSinNo(RetNo)='870000148') then begin Lvalue:='1';LType:='N';end; //20210218 //20240104

         //20200213
         if (LLine=50372) then
         begin
          if Lvalue>'' then LValue:=AddleadingZeros(LValue,2); //needs 2 digits //20200211 //20200213
         end;

         //20190123
         If (Lline=67820) and (Vl(Lvalue)<1) then Lvalue:='';  //20130130 //for t691
         If (Lline=67840) and (Vl(Lvalue)<1) then Lvalue:='';  //20130130
         If (Lline=67860) and (Vl(Lvalue)<1) then Lvalue:='';  //20130130

         If (LValue>'') or (IsinList(IntToStr(LLine),DummyCRALines)>-1) then
         begin
           With ALabel do
           begin
             Left:=StartingLeft+displacement * k;
             Top:=CurrentTop;
             Font.size:=8;
             Font.style:=[fsBold];
             Caption:=IntToStr(LLine);
             PrintLabel(ALabel,ACanvas);
           end;

           With AvtEditBox do
           begin
             Left:=StartingLeft+29+displacement * k;
             Top:=CurrentTop;
             Font.size:=8;
             Font.style:=[fsBold];
             //20111222
             If LType='$' then vtInputType:=vtDollar
             Else If Ltype='N' then vtInputType:=vtNumber
             Else If Ltype='C' then vtInputType:=vtDollar
             Else vtInputType:=vtString;
             vtVertSeparator:=False;    //20111223
             vtBorderType:=vtUnderline;
             vtAlignment:=taRightJustify;
             If Ltype='N' then
             begin
               vtInputType:=vtNumber;
               vtAlignment:=taCenter;
             end;
             Text:=LValue;
             //FieldId:=aVtEditBox.fieldId;
             StoreElm(RetNo,T1CFNo,FieldId,LValue);
             PrintEditBox(RetNo,aVtEditBox,'T1C_3',T1CFNo,Hdc,ACanvas);//20111227 tell edit box it deals with Condensed printing
           end;
           // star if ltype is cents
           If Ltype='C' then
           begin
             aShape:=TvtShape.Create(Application);
             With AShape do  //20121123
             begin
               Shape:=vtCircle;
               FillDirection:=vtUpFill;
               Left:=AvtEditBox.Left + AvtEditBox.width+3;
               Top:=CurrentTop+5; //20111223
               Font.size:=8;    //20111223
               Height:=4;
               Width:=3;
               Brush.Style:=bsSolid;
               Brush.color:=clBlack;
               GradientColor:=clBlack;
               Font.Style:=[fsBold];
               Font.Name:=defFontName; //'Arial';  //20180124'Arial';
               PrintvtShape(AShape,ACanvas);
               //put it back  //20111223
               Brush.Style:=bsClear;
               Brush.color:=clWhite;
               GradientColor:=clWhite;
               aShape.free;
             end;
           end;
         Inc(k);
       end;
       If k>4 then begin k:=0;CurrentTop:=CurrentTop+VerticalAdvance; end;

       If CurrentTop>900 then //end of page, make a new page and add page header
       begin
        Printer.NewPage;
        ALabel.Left:=7;
        CurrentTop:=20;
        addNewPageHeader(ALabel,CurrentTop, ALabel.Left, RetNo, 'T1C_3', ACanvas);

        //20200213  add protected when completed
        CurrentTop:=CurrentTop+15; //3*VerticalAdvance;
        ALabel.Top:=CurrentTop;
        ALabel.Left:=450;
        ALabel.Font.Style:=[fsBold];
        ALabel.Font.Size:=9;  //20130128
        ALabel.Caption:='Protected B when completed';
        PrintLabel(ALabel,ACanvas);
        //---------------------
        CurrentTop:=CurrentTop+VerticalAdvance+2*VerticalAdvance;

       end;

    end;
    ScheduleRelatedLines.Free;  //20121220 //must be freed after use
    DummyCRALines.Free;
end;


//20200212 JOHN?
procedure addnewPageHeader(headerLabel: TvtLabel;headerTop,headerLeft,RetNo:integer; FName:string; ACanvas: TCanvas );
begin
  With headerLabel do
  begin
   //SIN date header
   If (OptRec.Prn_NameH) and (IsShowHdrIndicator(FName)) then  //20120209
   Begin
    InitT1CLabel(headerLabel,headerTop,headerLeft);
    Font.Style:=[];
    Caption:=GetRetName(RetNo);
    PrintLabel(headerLabel,ACanvas);
   end;

   If (OptRec.Prn_DateH) and (IsShowHdrIndicator(FName)) then
   Begin
    InitT1CLabel(headerLabel,headerTop,headerLeft);
    Font.Style:=[];
    Left:=200;
    Caption:='Tax Year: '+AppYear+'    Date printed: '+DateToMonthDayYear(Date);
    PrintLabel(headerLabel,ACanvas);//CurrentTop:=CurrentTop+VerticalAdvance;
   end;

   If (OptRec.Prn_SinH) and (IsShowHdrIndicator(FName)) then
   Begin
    InitT1CLabel(headerLabel,headerTop,headerLeft);
    Font.Style:=[];
    Left:=510;  //20130123
    if OptRec.Prn_HideSin=False then
     Caption:= ' SIN: '+ ReformatSin(GetSinno(RetNo))
    Else
     Caption:= ' SIN: '+ GetHiddenSin(GetSinno(RetNo));
    PrintLabel(headerLabel,ACanvas);
   end;
  end;
end;


Function SubstituteT1CForm(RetNo:Integer;FrmNm:String):String;
Var NR_Prov_With_Empl:string; FileAsOther:Boolean;
begin
 result := FrmNm;

 If FetchElmFNo(RetNo,INFOFNO,249)>'' Then NR_Prov_With_Empl:=FetchElmFNo(RetNo,INFOFNO,249)
                                      else NR_Prov_With_Empl:=''; //20260502   //i.e NR_

 If NR_Prov_With_Empl>'' then FileAsOther := true; //FetchElmFNo(RetNo,INFOFNO,220)>''; //20260506

 If FileAsOther=True
 then
 begin
    CopySubstitute(RetNo,'T1','T1C_NR');    // picks up the T1C_NR laypot / heasder
    StoreElm(RetNo,GetFormNo('T1C_NR'),1,'Other');
    StoreElm(RetNo,GetFormNo('T1C_NR'),186,FetchElm(RetNo,'INFO',186));  //mail address country
    StoreElm(RetNo,GetFormNo('T1C_NR'),81,FetchElm(RetNo,'INFO',81));
    StoreElm(RetNo,GetFormNo('T1C_NR'),82,FetchElm(RetNo,'INFO',82));
    StoreElm(RetNo,GetFormNo('T1C_NR'),83,FetchElm(RetNo,'INFO',83));
    StoreElm(RetNo,GetFormNo('T1C_NR'),84,FetchElm(RetNo,'INFO',84));
    StoreElm(RetNo,GetFormNo('T1C_NR'),450,GetLine489EfileNo(RetNo)); //20121226
    StoreElm(RetNo,GetFormNo('T1C_NR'),524,FetchElm(RetNo,'INFO',69)); //20220224
    result := 'T1C_NR';
    exit;   //20260506
 end;


 (* //20260506
                  CZ
 //20260503
// If FetchElmFNo(RetNo,INFOFNO,249)>'' Then NR_Prov_With_Empl:=FetchElmFNo(RetNo,INFOFNO,249)
//   else NR_Prov_With_Empl:=''; //20260502   //i.e NR_
 result := FrmNm;
 FileAsOther:=True;
 If (FileAsOther=True)   //20260503  //If FetchElmFNo(RetNo,INFOFNO,220)>'')
 and (NR_Prov_With_Empl>'')          //or (NR_Prov_With_Empl>'')//20260502
 then
 begin
 // CopySubstitute(RetNo,'T1',NR_Prov_With_Empl);    ////20260503  picks up the T1C_xx laypot / heasder
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),1,'Other');
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),186,FetchElm(RetNo,'INFO',186));  //mail address country
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),81,FetchElm(RetNo,'INFO',81));
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),82,FetchElm(RetNo,'INFO',82));
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),83,FetchElm(RetNo,'INFO',83));
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),84,FetchElm(RetNo,'INFO',84));
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),450,GetLine489EfileNo(RetNo)); //20121226
    StoreElm(RetNo,GetFormNo('T1C_'+NR_Prov_With_Empl),524,FetchElm(RetNo,'INFO',69)); //20220224
    result := 'T1C_'+NR_Prov_With_Empl;
    exit;
 end;
 *)

 If FrmNm = 'T1' then
 begin
     If (Ret[RetNo].Province = 'ON')
     Or (NR_Prov_With_Empl='ON')  //20260502
     then
     begin
      CopySubstitute(RetNo,'T1','T1C_ON');
      StoreElm(RetNo,GetFormNo('T1C_ON'),454,GetLine489EfileNo(RetNo)); //20121226    //NOT 450!!! as in other provinces
      StoreElm(RetNo,GetFormNo('T1C_ON'),33,FetchElmFNo(RetNo,InfoFNo,198)); //20230109
      StoreElm(RetNo,GetFormNo('T1C_ON'),32,FetchElm(RetNo,'T1',505)); //20230109   //share organs
      StoreElm(RetNo,GetFormNo('T1C_ON'),37,FetchElm(RetNo,'T1',506)); //20230109   //share organs
      StoreElm(RetNo,GetFormNo('T1C_ON'),37,FetchElm(RetNo,'T1',506)); //20230109   //share organs
      StoreElm(RetNo,GetFormNo('T1C_ON'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_ON'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      result := 'T1C_ON';
      exit;
     end
     Else If Ret[RetNo].Province = 'YT' then
     begin
      CopySubstitute(RetNo,'T1','T1C_YT');
      StoreElm(RetNo,GetFormNo('T1C_YT'),33,FetchElm(RetNo,'INFO',1));  //20240213
      StoreElm(RetNo,GetFormNo('T1C_YT'),32,FetchElm(RetNo,'INFO',2));  //20230313
      StoreElm(RetNo,GetFormNo('T1C_YT'),132,FetchElm(RetNo,'INFO',132));
      StoreElm(RetNo,GetFormNo('T1C_YT'),138,FetchElm(RetNo,'INFO',138));
      StoreElm(RetNo,GetFormNo('T1C_YT'),41,FetchElm(RetNo,'INFO',41)); //first nation
      StoreElm(RetNo,GetFormNo('T1C_YT'),42,FetchElm(RetNo,'INFO',42)); //first nation ID
      StoreElm(RetNo,GetFormNo('T1C_YT'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_YT'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_YT'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      result := 'T1C_YT';
      exit;
     end

    //20250218  from john
    Else If Ret[RetNo].Province = 'BC' then
    begin
     CopySubstitute(RetNo,'T1','T1C_BC');
     StoreElm(RetNo,GetFormNo('T1C_BC'),132,FetchElm(RetNo,'INFO',132));
     StoreElm(RetNo,GetFormNo('T1C_BC'),138,FetchElm(RetNo,'INFO',138));
     StoreElm(RetNo,GetFormNo('T1C_BC'),450,GetLine489EfileNo(RetNo)); //20121226

     //20180315
    StoreElm(RetNo,GetFormNo('T1C_BC'),275,FetchElm(RetNo,'INFO',202)); //275 only in BC
    StoreElm(RetNo,GetFormNo('T1C_BC'),37,FetchElm(RetNo,'INFO',203));
    StoreElm(RetNo,GetFormNo('T1C_BC'),38,FetchElm(RetNo,'INFO',204));
    StoreElm(RetNo,GetFormNo('T1C_BC'),39,FetchElm(RetNo,'INFO',205));

    //tsawwa
    StoreElm(RetNo,GetFormNo('T1C_BC'),190,FetchElm(RetNo,'INFO',190));
    StoreElm(RetNo,GetFormNo('T1C_BC'),193,FetchElm(RetNo,'INFO',193));

    StoreElm(RetNo,GetFormNo('T1C_BC'),194,FetchElm(RetNo,'INFO',194));
    StoreElm(RetNo,GetFormNo('T1C_BC'),195,FetchElm(RetNo,'INFO',195));

    StoreElm(RetNo,GetFormNo('T1C_BC'),32,FetchElm(RetNo,'T1',505)); //jz//20250216 //share organs
    StoreElm(RetNo,GetFormNo('T1C_BC'),33,FetchElm(RetNo,'T1',506)); //jz//20250216 //share organs

    StoreElm(RetNo,GetFormNo('T1C_BC'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
    StoreElm(RetNo,GetFormNo('T1C_BC'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change

    result := 'T1C_BC';
    exit;
    end

    else If (Ret[RetNo].Province = 'NT') then
    begin
     CopySubstitute(RetNo,'T1','T1C_NT');
     //StoreElm(RetNo,GetFormNo('T1C_NT'),90,FetchElm(RetNo,'INFO',90));
     //StoreElm(RetNo,GetFormNo('T1C_NT'),137,FetchElm(RetNo,'INFO',137));
     StoreElm(RetNo,GetFormNo('T1C_NT'),164,FetchElm(RetNo,'INFO',164));
     StoreElm(RetNo,GetFormNo('T1C_NT'),165,FetchElm(RetNo,'INFO',165));
     StoreElm(RetNo,GetFormNo('T1C_NT'),450,GetLine489EfileNo(RetNo)); //20121226
     StoreElm(RetNo,GetFormNo('T1C_NT'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
     StoreElm(RetNo,GetFormNo('T1C_NT'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
     result := 'T1C_NT';
     exit;
    end
    Else If Ret[RetNo].Province = 'NL' then
    begin
     CopySubstitute(RetNo,'T1','T1C_NL');
     StoreElm(RetNo,GetFormNo('T1C_NL'),127,FetchElm(RetNo,'INFO',127));
     StoreElm(RetNo,GetFormNo('T1C_NL'),136,FetchElm(RetNo,'INFO',136));
     StoreElm(RetNo,GetFormNo('T1C_NL'),450,GetLine489EfileNo(RetNo)); //20121226
     StoreElm(RetNo,GetFormNo('T1C_NL'),33,FetchElmFNo(RetNo,InfoFNo,198)); //20230109
     StoreElm(RetNo,GetFormNo('T1C_NL'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
     StoreElm(RetNo,GetFormNo('T1C_NL'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
     result := 'T1C_NL';
     exit;
    end

    Else If Ret[RetNo].Province = 'NS' then
    begin
     CopySubstitute(RetNo,'T1','T1C_NS');
     StoreElm(RetNo,GetFormNo('T1C_NS'),127,FetchElm(RetNo,'INFO',127));
     StoreElm(RetNo,GetFormNo('T1C_NS'),136,FetchElm(RetNo,'INFO',136));
     StoreElm(RetNo,GetFormNo('T1C_NS'),450,GetLine489EfileNo(RetNo)); //20121226
     StoreElm(RetNo,GetFormNo('T1C_NS'),33,FetchElmFNo(RetNo,InfoFNo,198)); //20230109
     StoreElm(RetNo,GetFormNo('T1C_NS'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
     StoreElm(RetNo,GetFormNo('T1C_NS'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
     result := 'T1C_NS';
     exit;
    end

    Else If Ret[RetNo].Province = 'SK' then
    begin
     CopySubstitute(RetNo,'T1','T1C_SK');
     StoreElm(RetNo,GetFormNo('T1C_SK'),127,FetchElm(RetNo,'INFO',127));
     StoreElm(RetNo,GetFormNo('T1C_SK'),136,FetchElm(RetNo,'INFO',136));
     StoreElm(RetNo,GetFormNo('T1C_SK'),450,GetLine489EfileNo(RetNo)); //20121226
     StoreElm(RetNo,GetFormNo('T1C_SK'),33,FetchElmFNo(RetNo,InfoFNo,198)); //20230109
     StoreElm(RetNo,GetFormNo('T1C_SK'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
     StoreElm(RetNo,GetFormNo('T1C_SK'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
     result := 'T1C_SK';
     exit;
    end

    Else If (Ret[RetNo].Province = 'ZZ') then  //non res province
    begin
      CopySubstitute(RetNo,'T1','T1C_NR');
      StoreElm(RetNo,GetFormNo('T1C_NR'),1,'Other');
      StoreElm(RetNo,GetFormNo('T1C_NR'),186,FetchElm(RetNo,'INFO',186));  //mail address country
      StoreElm(RetNo,GetFormNo('T1C_NR'),81,FetchElm(RetNo,'INFO',81));
      StoreElm(RetNo,GetFormNo('T1C_NR'),82,FetchElm(RetNo,'INFO',82));
      StoreElm(RetNo,GetFormNo('T1C_NR'),83,FetchElm(RetNo,'INFO',83));
      StoreElm(RetNo,GetFormNo('T1C_NR'),84,FetchElm(RetNo,'INFO',84));
      StoreElm(RetNo,GetFormNo('T1C_NR'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_NR'),524,FetchElm(RetNo,'INFO',69)); //20220224
      StoreElm(RetNo,GetFormNo('T1C_NR'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_NR'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      result := 'T1C_NR';
      exit;
    end
    Else If (Ret[RetNo].Province = 'QC') then
    begin
      CopySubstitute(RetNo,'T1','T1C_QC');
      StoreElm(RetNo,GetFormNo('T1C_QC'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_QC'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_QC'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      result := 'T1C_QC';
      exit;
    end
    //20190101
    Else If (Ret[RetNo].Province = 'MB') then
    begin
      CopySubstitute(RetNo,'T1','T1C_MB');
      StoreElm(RetNo,GetFormNo('T1C_MB'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_MB'),33,FetchElmFNo(RetNo,InfoFNo,198)); //20230109
      StoreElm(RetNo,GetFormNo('T1C_MB'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_MB'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      result := 'T1C_MB';
      exit;
    end
    //20190105
    Else If (Ret[RetNo].Province = 'PE') then
    begin
      CopySubstitute(RetNo,'T1','T1C_PE');
      StoreElm(RetNo,GetFormNo('T1C_PE'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_PE'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_PE'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      result := 'T1C_PE';
      exit;
    end

    Else If (Ret[RetNo].Province = 'NB') then
    begin
      CopySubstitute(RetNo,'T1','T1C_NB');
      StoreElm(RetNo,GetFormNo('T1C_NB'),198,FetchElmFNo(RetNo,InfoFNo,198)); //20240213
      StoreElm(RetNo,GetFormNo('T1C_NB'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_NB'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_NB'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      result := 'T1C_NB';
      exit;
    end

    Else If (Ret[RetNo].Province = 'AB') then
    begin
      CopySubstitute(RetNo,'T1','T1C_AB');
      StoreElm(RetNo,GetFormNo('T1C_AB'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_AB'),33,FetchElmFNo(RetNo,InfoFNo,198)); //20230109
      StoreElm(RetNo,GetFormNo('T1C_AB'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_AB'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      StoreElm(RetNo,GetFormNo('T1C_AB'),32,FetchElm(RetNo,'T1',505)); //jz//20260201 //share organs
      StoreElm(RetNo,GetFormNo('T1C_AB'),37,FetchElm(RetNo,'T1',506)); //jz//20260201 //share organs
      result := 'T1C_AB';
      exit;
    end

    Else If (Ret[RetNo].Province = 'NU') then
    begin
      CopySubstitute(RetNo,'T1','T1C_NU');
      StoreElm(RetNo,GetFormNo('T1C_NU'),450,GetLine489EfileNo(RetNo)); //20121226
      StoreElm(RetNo,GetFormNo('T1C_NU'),78,FetchElm(RetNo,'T1',78)); //20260102   //mm od mar status change
      StoreElm(RetNo,GetFormNo('T1C_NU'),79,FetchElm(RetNo,'T1',79)); //20260102   //dd od mar status change
      //jz//20250216 doesn't need explicit organ transfer lines as elms are the same, so then handled in CopySubstitute
      result := 'T1C_NU';
      exit;
    end;
 end;  //end if frm T1
End;

Function AnyFormsForT1c(RetNo:Integer):Boolean;
Var FName:String;
Begin
    result:=False;
    FName           := 'T1A';
    If Ret[RetNo].FormHasData[FName] then result:=True;


    FName           := 'T691';
    If (Ret[RetNo].FormHasData[FName])
    and ((Vl(FetchElm(RetNo,'T691',10))>1)   //20130130
    Or (Vl(FetchElm(RetNo,'T691',23))>1)   //20130130
    Or (Vl(FetchElm(RetNo,'T691',16))>1)   //20130130
    Or (Vl(FetchElm(RetNo,'T691',18))>=1)   //20190123
    Or (Vl(FetchElm(RetNo,'T691',40))>=1)   //20200211
    Or (SubjectToMinTax(RetNo)))   //20130130
    then result:=True;

    FName           := 'T778';
    If (FetchElm(RetNo,FName,71) >'')  //20111222
    or (FetchElm(RetNo,FName,60) >'')
    or (FetchElm(RetNo,FName,115) >'')
    or (FetchElm(RetNo,FName,123) >'')  then  Result:=True;

    FName           := 'T936';
    If (FetchElm(RetNo,FName,6) >'')  //20111222
    or (FetchElm(RetNo,FName,13) >'')
    or (FetchElm(RetNo,FName,14) >'')
    or (FetchElm(RetNo,FName,134) >'')
    or (FetchElm(RetNo,FName,136) >'')
    then result:=True;

    FName           := 'T1170#1';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'T1206';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'T1212';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'T2017';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'T2209#1';  //20121226
    If (CalcLn433(RetNo)>0) or (CalcLn431(RetNo)>0)
    or (CalcLn439(RetNo)>0) or (CalcLn434(RetNo)>0)
    then result:=True;

    FName           := 'T2222';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'T5004';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'RC267';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'RC268';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'RC269';
    If Ret[RetNo].FormHasData[FName] then result:=True;

    FName           := 'RC359#1';
    If Ret[RetNo].FormHasData[FName] then result:=True;

end;

Procedure InitT1CLabel(Var ALabel:TvtLabel;CurrentTop:Integer;StartingLeft:Integer);
Begin
 With ALabel do
 Begin
  Font.Name:=defFontName; //'Arial';  //20180124'Arial';   //20180124
  Font.Color:=clBlack;
  ALabel.Font.Style:=[fsBold];
  vtTransparent:=True;
  Transparent:=True;
 // Font.Size:=9;  //20180124
  Top:=CurrentTop;
  Left:=StartingLeft;
 end;
end;

//jz//20250408 - added passed var fname
Function GetExceptionalValue(RetNo:Integer;Fname:string;LLine:Integer; LValue:String):String;
Begin
 Result:=LValue;
 If (LLine=15000) and (LValue='') then begin result:='0.00';Exit;end;
 If (LLine=23600) and (LValue='') then begin result:='0.00';Exit;end;
 If (LLine=26000) and (LValue='') then begin result:='0.00';Exit;end;

 If LLine=6655 then
 begin
  result:=RemoveChar(RemoveChar(FetchElm(RetNo,'T1A',154),'-'),'-');exit;
 end;

 //Bus inv loss
 If (Lline=21699) {228} and (LValue='') and (Ret[RetNo].Lnn[21700]<>0) then begin result:='0.00';Exit;end;
 If (Lline=21700) and (LValue='') and (Ret[RetNo].Lnn[21699]<>0) then begin result:='0.00';Exit;end;

 //Support payment pair
 If (Lline=21999) {230} and (LValue='') and (Ret[RetNo].Lnn[22000]<>0) then begin result:='0.00';Exit;end;
 If (Lline=22000) and (LValue='') and (Ret[RetNo].Lnn[21999]<>0) then begin result:='0.00';Exit;end;

 //if lline=107 then showmessage('107');
 //handle pairs
 //look only the ones that have value of '1'

  //20200112
  If Lvalue='1' then
  Begin
    //'1' is in the LValue as it came from getnetfilevalue
    If (Lline=12599) {160} or (LLine=12600) or
       (Lline=12799) {156} or (LLine=12800) or
       (Lline=13499) {162} or (LLine=13500) or
       (Lline=13699) {164} or (LLine=13700) or
       (Lline=13899) {166} or (LLine=13900) or
       (Lline=14099) {168} or (LLine=14100) or
       (Lline=14299) {170} or (LLine=14300) or
       (Lline=10699) {106} or (LLine=10700) or
       (Lline=10999) or (LLine=11000) or
       (Lline=12399) or (LLine=12400) or
       //(Lline=13199) or (LLine=13200) or //jz//20250408 why is this? remove for cert8
       (Lline=13600) or (LLine=13800) or
       (Lline=15199) or (LLine=15300) or
       (Lline=14599) {154} or (LLine=15500) or
       (Lline=68220) or (LLine=68230) or
       (Lline=68240) or (LLine=68250)
    then result:='0.00';
  end;

  If Lline=60890 then
  begin
    If LValue='1' then result:=Space(3);
  end;


  //jz//20250408 - remove s8 lines cra complains about, cert8, cert22
  if (fname='S8') and
     ( (Lline=31000) or (LLine=22200) or
       (Lline=30800) or (LLine=22215) or
       (Lline=42100) )
  then
    begin result := ''; end;


  If ((Lline=25900) and (FetchElm(RetNo,'S7',24)>''))  //20130128
  or ((Lline=26400) and (FetchElm(RetNo,'S7',16)>''))  //20130128
   then result:=Space(3); //20120309

  If ((Lline=26400) and (FetchElm(RetNo,'S7',16)>''))  //20210218 conflict with the above
   then result:='1';

 If (Lline=67900)
 then  //internal CRA fields
 begin
   result:=Space(2)+'1'; //20200129 jz
 end;

 If (Lline=68130)   //for T936  //20200129
 then  //internal CRA fields
 begin
   result:=Space(2)+'1'; //20200129 jz
 end;

end;

function GetSortedComponents(AForm: TForm): TList<TControl>; //20220107 Igor
var I: integer;
    Comparison: TComparison<TControl>;
begin
  Result := TList<TControl>.Create;
  for I := 0 to AForm.ComponentCount - 1 do
    if AForm.Components[I] is TControl then
      Result.Add(TControl(AForm.Components[I]));
  Comparison :=
    function(const C1, C2: TControl): Integer
    begin
      Result := EqualsValue;
      if C1.Top < C2.Top then
        Result := LessThanValue
      else if C1.Top > C2.Top then
        Result := GreaterThanValue
      else
      begin
        if C1.Left < C2.Left then
          Result := LessThanValue
        else if C1.Left > C2.Left then
          Result := GreaterThanValue;
      end;
    end;
  Result.Sort(TComparer<TControl>.Construct(Comparison));
end;

Procedure PrintT1C(RetNo: Integer; FName: String; APDFPrinter: TvtPDFPrinter = nil); //20161105 Igor
Var h,i,j,k,CompIndex,T1CFNo:Integer;
Fno:Integer;
 AForm:TForm; ACanvas:TCanvas; DfmFileName:String;
 ALabel:TvtLabel; AvtEditBox:TvtEdit; AVtShape:TVtShape; ATag:Integer; FieldId:Integer;
// PageX, PageY : LongInt; //20170212 Igor
 hdc: THandle;
 s:String;
 VerticalAdvance:Integer;
 CurrentTop:LongInt;
 StartingLeft:LongInt;
 FrmNm,formDisplayName:String;
 FrmSectionNm:String;
 FrmFNo:Integer;
 ScheduleRelatedLines:TStringList;
 LLine:Integer;
 LType:string; //[1];
 LValue:String;
 Displacement:Integer;
 dpiPercent,xDPIAdjust,VertAdvDPIAdjust,DisplaceDPIAdust:integer;
 FControls: TList<TControl>; //20220107 Igor
 UseS8InFormDisplayName:Boolean;

begin
  {
  //20220126
  UseS8InFormDisplayName:=True;
  If (Ret[RetNo].Province='QC')
  Or (GetQCT4Box14(RetNo)>0) then UseS8InFormDisplayName:=False;
  }
  //20250205
  //If GetSinNo(RetNo)='870000445' then UseS8InFormDisplayName:=True;  //20220126 //case 33

 Screen.Cursor := crHourGlass;
 dpiPercent := ( GetWindowsFontSize(Application.MainForm.Handle) * 100) div DesignPixelsPerInch; //GetWindowsFontSize in trimstr, was comment, uncommented

 xDPIAdjust:= 0;vertAdvDPIAdjust := 0;displaceDPIAdust := 0;

 if dpiPercent >= 119 then //sudden change in dpi effect at 119???
 begin
   xDPIAdjust:= 1000;vertAdvDPIAdjust := 3;displaceDPIAdust := 30;
 end
 else if dpiPercent >= 105 then //adjustment lower than 119 not needed?
 begin
   //xDPIAdjust:= 400;vertAdvDPIAdjust := 2;displaceDPIAdust := 15;
 end;

 Displacement     := 115 + displaceDPIAdust;
 VerticalAdvance  := 14  + vertAdvDPIAdjust; //MyStrToInt(InputBox('Vertical line height','Enter', '14'));
 Displacement     := Trunc(Displacement * 100 / dpiPercent); //20181114 Igor

 CurrentTop:=20;
 StartingLeft:=7;

 if not assigned(APDFPrinter) then    //20161105 Igor
 begin
  //20160805 Igor >>>
  if ((Printer.Orientation = poLandscape) <> IsLandscape(FName)) then
  begin
    if Printer.Printing then
      Printer.EndDoc;

    If IsLandscape(FName) Then
      Printer.Orientation := poLandscape
    else
      Printer.Orientation := poPortrait;
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  If not Printer.Printing then
  begin
    Printer.BeginDoc;
    NeedNewPage := False;
  end;
  if NeedNewPage then
    Printer.NewPage;
  //20160805 Igor <<<
 //20170212 Igor>>>
  CalcScaleXY;
//   PageX  := Printer.PageWidth;
//   PageY  := Printer.PageHeight;
 end
 else
 begin
   with APDFPrinter.PDFDocument.AddPage do
   begin
     PageLandscape := IsLandscape(FName);
     APDFPrinter.CalcScaleXY;
   end;
 end;

 //20170212 Igor<<<
 if not assigned(APDFPrinter) then  //20161105 igor
 begin
   hdc :=  Printer.Canvas.Handle;
   ACanvas:=Printer.Canvas;
 end
 else
 begin
   hdc := APDFPrinter.PDFDocument.VCLCanvas.Handle;
   ACanvas:=APDFPrinter.PDFDocument.VCLCanvas;
 end;

 ACanvas.Brush.Style := bsClear;      //20111222
 ACanvas.Font.color:=clBlack;  //20111222
 ACanvas.Font.Size:=9;  //20180124 default unless changed line by line
 //print Fixed headings
  AForm:=TForm.Create(Application);
  ALabel:=TvtLabel.Create(AForm);


  With ALabel do
  begin
   Parent:=AForm;
   Name:='lbl0';

   addNewPageHeader(ALabel,CurrentTop, StartingLeft, RetNo, FName, ACanvas); //jz 20200212

   CurrentTop:=CurrentTop+VerticalAdvance*1; //2  //20200213

   //20130123
   Top:=CurrentTop+1;
   ALabel.Parent:=AForm;
   ALabel.Name:='xlbl1';
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Font.Style:=[fsBold];
   Font.Size:=9;  //20130128
   Left:=450;
   Caption:='Protected B when completed';
   PrintLabel(ALabel,ACanvas);CurrentTop:=CurrentTop+VerticalAdvance;


   ALabel.Parent:=AForm;
   ALabel.Name:='lbl1';
   Font.Size:=9;  //20200120
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Caption:='Attach this form inside your return along with any other forms, schedules,';    //20130111
   PrintLabel(ALabel,ACanvas);CurrentTop:=CurrentTop+VerticalAdvance;

   ALabel:=TvtLabel.Create(AForm);
   ALabel.Parent:=AForm;
   ALabel.Name:='lbl2';
   Font.Size:=9;  //20200120
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Top:=CurrentTop+2;
   Caption:='information slips receipts, and documents that you need to include.';   //20130111
   PrintLabel(ALabel,ACanvas);CurrentTop:=CurrentTop+VerticalAdvance*2;

   ALabel:=TvtLabel.Create(AForm);
   ALabel.Parent:=AForm;
   Font.Size:=10;  //20200120
   ALabel.Name:='lbl3';
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Caption:='T1-2025';PrintLabel(ALabel,ACanvas); //jz//20250307 changed to 2024 from 2023//Caption:='T1-2012';PrintLabel(ALabel,ACanvas);  //20161127 //20181114 Igor
   ALabel:=TvtLabel.Create(AForm);
   ALabel.Parent:=AForm;
   ALabel.Name:='lbl5';
   Font.Size:=14; //12;  //20180124
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Left:=200; //280;   //20200127
   Caption:='T1-KFS (Keying Field Summary)';   //20200127
   PrintLabel(ALabel,ACanvas);
   CurrentTop:=CurrentTop+VerticalAdvance*2;

   Top:=CurrentTop;
   Left:=StartingLeft;
   ALabel.Name:='lbl6';
   Font.Size:=11; //10;  //20170205 //20180124
   CurrentTop:=CurrentTop+VerticalAdvance;  //20191231
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Caption:='Total income';PrintLabel(ALabel,ACanvas);
   CurrentTop:=CurrentTop+VerticalAdvance;

   //20170205
   ALabel.Parent:=AForm;
   ALabel.Name:='lbl17';
   Font.Size:=9;  //20170205
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Caption:='As a resident of Canada, you have to report your income from all sources both inside and outside Canada.';
   PrintLabel(ALabel,ACanvas);CurrentTop:=CurrentTop+VerticalAdvance;

   ALabel.Parent:=AForm;
   ALabel.Name:='lbl18';
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   Caption:='When you come to a line on the return that applies to you, go to the line number in the guide for more information.';
   PrintLabel(ALabel,ACanvas);CurrentTop:=CurrentTop+VerticalAdvance;
   CurrentTop:=CurrentTop+VerticalAdvance;
   //------------------------------------------------
  end;
  AForm.free;

 DfmFileName:=GetDfmFileName(FName);
 //ShowMessage('printing '+FName); // 20230106
 //T1CFNo:=GetFormNo(FName);  //20111220  not needed here
 AForm:=TForm.Create(Application);
 If FileExists(DfmFileName) then
 Begin
  Try
      ReadComponentResFile(DfmFileName,AForm);
  Except
    Begin
     ShowMessage('DFM File problem ='+DfmFileName);
     AForm.Free;
    end;
  end;
 end;

 T1CFNo:=GetFormNo(FName);  //changed from fno to T1CFno to make it clear from other FNumbers //20111120

 //**********  Print applicable edit boxes and labels of form T1C-3 DYNAMICALLY  *******
 //20220107 Igor >>>
 FControls := GetSortedComponents(AForm);
 try
   for CompIndex := 0 to FControls.Count - 1 do
   begin
      if FControls[CompIndex] is TvtEdit then
      begin
        AVtEditBox:=FControls[CompIndex] As TvtEdit;
        LLine:= AvtEditBox.Tag;  //this is the actual tax returb field code i.e, 11100
        LValue:=GetLineValue(RetNo,LLine);
        If LLine=23600 then LValue:=FormatFloat('########.00',Ret[RetNo].Lnn[23600]); //not available via EFLINE.D

        Lvalue:=GetExceptionalValue(RetNo,FName,LLine,Lvalue);
        aVtEditBox.Text:=LValue;
       // if LeftStr(LValue,2)='//' then ShowMessage('Fname '+FName+' LLINE'+IntToStr(Lline));

        FieldId:=GetFieldId(aVtEditBox.Name);



        StoreElm(RetNo,T1CFNo,FieldId,LValue);     //populate the t1c_3 with values?
        //required lines for printing in all cases
        if (LLine=12600) and (Ret[RetNo].Lnn[12599]>0) and (Ret[RetNo].Lnn[12600]=0) then Lvalue:='0';
        if (LLine=12800) and (Ret[RetNo].Lnn[12799]>0) and (Ret[RetNo].Lnn[12800]=0) then Lvalue:='0';
        if (LLine=13500) and (Ret[RetNo].Lnn[13499]>0) and (Ret[RetNo].Lnn[13500]=0) then Lvalue:='0';
        if (LLine=14100) and (Ret[RetNo].Lnn[14099]>0) and (Ret[RetNo].Lnn[14100]=0) then Lvalue:='0';
        if (LLine=14300) and (Ret[RetNo].Lnn[14299]>0) and (Ret[RetNo].Lnn[14300]=0) then Lvalue:='0';
        if (LLine=21700) and (Ret[RetNo].Lnn[21699]>0) and (Ret[RetNo].Lnn[21700]=0) then Lvalue:='0';
        if (LLine=22000) and (Ret[RetNo].Lnn[21999]>0) and (Ret[RetNo].Lnn[22000]=0) then Lvalue:='0';

        //  ----------
        If LValue >'' then //value in edit box then it must print on the printout
        begin
          aVtEditBox.Top:=CurrentTop;
          aVtEditBox.vtVertSeparator:=True;
          //20181114 Igor >>>
          AVtEditBox.Left := Trunc(AVtEditBox.Left * 100 / dpiPercent);
          AVtEditBox.Width := Trunc(AVtEditBox.Width * 100 / dpiPercent);
          //20181114 Igor <<<
          PrintEditBox(RetNo,aVtEditBox,FName,T1CFNo,Hdc,ACanvas);
          //**** PRINT related labels on the same row as the value if they have the same tag ***
          ALabel := nil; //20170206 Igor

          For j:=0 to FControls.Count-1 do
          Begin
           if FControls[j] is TvtLabel then  //20111228
           begin
           //20170206 Igor >>>
           //   ALabel:=Aform.Components[j] as TvtLabel;
             If TvtLabel(FControls[j]).Tag=LLine then
             begin
              ALabel:=FControls[j] as TvtLabel;
              ALabel.Top:=CurrentTop;
              if not (fsBold in ALabel.Font.Style) then
                ALabel.Font.Size := Trunc(ALabel.Font.Size * dpiPercent / 100);
              If LLine=23600 then ALabel.Font.Style:=[];    //20120228 NO bold
              ALabel.Left := Trunc(ALabel.Left * 100 / dpiPercent);
              ALabel.Width := Trunc(ALabel.Width * 100 / dpiPercent);
              PrintLabel(ALabel,ACanvas);
             end;
            end;

           if FControls[j] is TvtShape then  //20120111
           begin
             AvtShape:=FControls[j] as TvtShape;
             If AvtShape.Tag=LLine then
             begin
              AvtShape.Top:=CurrentTop;
              If AvtShape.Shape=vtCircle then AvtShape.Top:=CurrentTop+5; //this is the black indicator //20120111
              //20181114 Igor >>>
              AvtShape.Left := Trunc(AvtShape.Left * 100 / dpiPercent);
              AvtShape.Width := Trunc(AvtShape.Width * 100 / dpiPercent);
              //20181114 Igor <<<
              PrintvtShape(AvtShape,ACanvas);
             end;
            end;
          end; //j


          //20191229
          //advance print line unless it is the gross box in a pair of boxes such as rental 160 and 126
          // business and bus inv loss and support payments
          If (LLine<>12599) and (LLine<>12799)
              and (LLine<>13499) and (LLine<>13699) and (LLine<>13899)
              and (LLine<>14099) and (LLine<>14299)
              and (LLine<>21699) and (LLine<>21999) then
               CurrentTop:=CurrentTop+VerticalAdvance;

           //fixed headings
           //20170206 Igor >>>>
           if not assigned(ALabel) then
           begin
             ALabel := TvtLabel.Create(AForm);
             ALabel.Parent := AForm;
           end;
           //20170206 Igor <<<
           With ALabel do
           Begin
            If LLine=15000 then
            Begin
             CurrentTop:=CurrentTop+VerticalAdvance;
             Font.size:=11;vtBorderType:= vtlblNoBorder;  ////20180124 from 9 size
             Font.Style := [fsBold]; //20170206 Igor
             Left:=StartingLeft-5;  //20111222
             Caption:='Net income';Top:=CurrentTop;PrintLabel(ALabel,ACanvas);
             CurrentTop:=CurrentTop+VerticalAdvance;
            end;

            If LLine=23600 then
            Begin
             CurrentTop:=CurrentTop+VerticalAdvance *2;
             Left:=StartingLeft-6;   //20180124 instead of -4
             Font.size:=11;vtBorderType:= vtlblNoBorder;  //20180124 from size 9
             Font.Style := [fsBold]; //20170206 Igor
             Caption:='Taxable income'; Top:=CurrentTop;PrintLabel(ALabel,ACanvas);
             CurrentTop:=CurrentTop+VerticalAdvance;
            end;

            if LLine=26000 then  //20191229  //after taxable income
            Begin
             // 20191231
             ALabel:=TvtLabel.Create(AForm);  //new lbl to be used for all boxes
             InitT1CLabel(ALabel,CurrentTop,StartingLeft);
             ALabel.Parent:=AForm;
             Font.Size:=11;
             Font.Style := [fsBold];
             Caption:='Federal tax (formerly Schedule 1)'; Top:=CurrentTop;PrintLabel(ALabel,ACanvas);
             CurrentTop:=CurrentTop+VerticalAdvance;  //20191231
             //---
             CurrentTop:=CurrentTop+VerticalAdvance;
             Font.Size:=9; //9
             Font.Style := [];
             Left:=StartingLeft;  //20191230
             Caption:='Part A - Federal non-refundable tax credits)'; Top:=CurrentTop;PrintLabel(ALabel,ACanvas);
             CurrentTop:=CurrentTop+VerticalAdvance*2;
            end;

            if LLine=35000 then  //20191229  //after non refundable
            Begin
             //20200118
             if  (Ret[RetNo].Lnn[40424]=0)
             and (Ret[RetNo].Lnn[40425]=0)
             and (Ret[RetNo].Lnn[40427]=0)
             and (Ret[RetNo].Lnn[40900]=0)
             and (Ret[RetNo].Lnn[41000]=0)
             and (Ret[RetNo].Lnn[41200]=0)
             and (Ret[RetNo].Lnn[42300]=0)
             and (Ret[RetNo].Lnn[41400]=0)
             and (Ret[RetNo].Lnn[41450]=0)
             and (Ret[RetNo].Lnn[41500]=0)
             then
             Begin
              //do not print
             end
             Else
             Begin
              ALabel:=TvtLabel.Create(AForm);  //new lbl to be used for all boxes
              InitT1CLabel(ALabel,CurrentTop,StartingLeft);
              ALabel.Parent:=AForm;
              Font.Size:=11;
              Font.Style := [fsBold];
              Caption:='Federal tax (formerly Schedule 1)'; Top:=CurrentTop;PrintLabel(ALabel,ACanvas);
              CurrentTop:=CurrentTop+VerticalAdvance*2;  //20191231
              Font.Size:=9; //9
              Font.Style := [];
              Left:=StartingLeft;  //20191230
              Caption:='Part C - Net Federal tax';
              Top:=CurrentTop;
              PrintLabel(ALabel,ACanvas)
             End;
             CurrentTop:=CurrentTop+VerticalAdvance*2;
            end;
           end;
         end;
      end; //tvedit
    End;  //compIndex
  finally
    FControls.Free;
  end;
  //20220107 Igor <<<


   //Schedules------------------------------------------------------------------------------------------------------------
   CurrentTop:=CurrentTop+VerticalAdvance*2;

   ALabel:=TvtLabel.Create(AForm);  //new lbl to be used for all boxes
   ALabel.Font.Size:=11;  //20180124
   ALabel.Caption:= 'Federal Schedules';
   InitT1CLabel(ALabel,CurrentTop,StartingLeft);
   ALabel.Parent:=AForm;
   PrintLabel(ALabel,ACanvas);


   //20220125
   If (Ret[RetNo].Lnn[40600]>1) Or (Ret[RetNo].Lnn[41800]>1) Or (Ret[RetNo].Lnn[42800]>1) then
   //If (Ret[RetNo].Lnn[40600]>0) Or (Ret[RetNo].Lnn[41800]>0) Or (Ret[RetNo].Lnn[42800]>0) then
   Begin
    formDisplayName := 'T1 General';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124

    FName           := 'T1DUMMY';   //for a few dummy fields
    PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
   end;
   //20220125

   // s2 <<< ------------------------------------------------------------------------------------
   //jz//MJCERT2024 - not sure why did not print s2 for MJ previously but 2024 testcase2 requies S2 print out on the KFS and assume should always be printed when present
   //if IsMultJurisdiction(RetNo)=false then  //20240515
   if true then
   Begin

    FName           := 'S2';
    formDisplayName := 'Schedule 2'; //jz 20240212

    //jz//MJCERT2024 - not sure what hte point of this is???? leave for now
    If (GetSinNo(retno)='870000221')  //case #16     //Or (ret[retno].lnn[36100]>0)    //20240210
    Or (FetchElm(RetNo,FName,19)>'')
    then  //20130123
       formDisplayName := 'Schedule 2';


    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    if  (FetchElm(RetNo,FName,3)  > '') or (FetchElm(RetNo,FName,32) > '') or (FetchElm(RetNo,FName,4)  > '') or
        (FetchElm(RetNo,FName,5)  > '') or (FetchElm(RetNo,FName,6)  > '') or (FetchElm(RetNo,FName,17) > '') or
        (FetchElm(RetNo,FName,19) > '')
    then
    begin
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
    end;
   End;
   // s2 >>> ------------------------------------------------------------------------------------

   FName           := 'S3';
   formDisplayName := 'Schedule 3';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
   If Ret[RetNo].FormHasData[FName] then
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);


   If Ret[RetNo].Lnn[45300]>0 then //20190114
   Begin
    if Ret[RetNo].Province <> 'QC' then
    Begin
     FName           := 'S6';
     formDisplayName := 'Schedule 6';
     ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
     If Ret[RetNo].Lnn[45300]>0 then //20111220
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
    end
    Else  //qc
    Begin
     FName           := 'S6QC';
     formDisplayName := 'Schedule 6';
     ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
     If Ret[RetNo].Lnn[45300]>0 then //20111220
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
    end;
   End;

   FName           := 'S7';
   formDisplayName := 'Schedule 7';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
   If Ret[RetNo].Lnn[20800]>0 then //20111220
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);


   // note: RC381 further below
   //20250205
   FName           := 'S8';
   formDisplayName := 'Schedule 8';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
   If Ret[RetNo].FormHasData[FName] then  //Ret[RetNo].Lnn[20800]>0 then //20111220  //jz//20250306 why 20800? use FormHasData like others
    PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

   FName           := 'S9';
   formDisplayName := 'Schedule 9';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
   If Ret[RetNo].FormHasData[FName] then
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

   FName           := 'S10';
   formDisplayName := 'Schedule 10';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
   If Ret[RetNo].FormHasData[FName] then
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

   //20240210
   FName           := 'S11';
   formDisplayName := 'Schedule 11';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
   //20240210
   FNo:=GetFormNo('S11');
   if (FetchElmFNo(RetNo,FNo,1)>'')
   or (FetchElmFNo(RetNo,FNo,2)>'')
   or (FetchElmFNo(RetNo,FNo,31)>'')
   or (FetchElmFNo(RetNo,FNo,35)>'')
   or (FetchElmFNo(RetNo,FNo,42)>'')
   or (FetchElmFNo(RetNo,FNo,40)>'')
   then
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

   FName := 'S12#1';             //20240120
   If (Vl(FetchElm(RetNo,Fname,169))>0)
   then    //20240213
   Begin
    formDisplayName := 'Schedule 12';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
   End;

   FName           := 'S13';
   formDisplayName := 'Schedule 13';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
   If (FetchElm(RetNo,FName,2)>'')
   or (FetchElm(RetNo,FName,3)>'')
   or (FetchElm(RetNo,FName,6)>'') then
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

   //20210208
   if FetchElm(RetNo,'S14',7)>'' then
   Begin
    FName           := 'S14';   //20220112 climate indicator
    formDisplayName := 'Schedule 14';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
   end;

   FName           := 'S15';  //20240120
   formDisplayName := 'Schedule 15';
   ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then //20240120
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);


   //Forms --------------------------------------------------------------------------------------------------------------
   //20111220  Below changed from AND to OR   //also changed T2209 to T2209#1
   if  AnyFormsForT1c(RetNo) then
   begin
    CurrentTop:=CurrentTop+VerticalAdvance *2;
    ALabel:=TvtLabel.Create(AForm);  //new lbl to be used for all boxes
    ALabel.Font.Size:=11;  //20180125
    ALabel.Caption:= 'Forms';
    InitT1CLabel(ALabel,CurrentTop,StartingLeft);
    ALabel.Parent:=AForm;
    PrintLabel(ALabel,ACanvas);

    FName           := 'T1A';
    formDisplayName := 'T1A';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'T691'; formDisplayName := 'T691';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName]    //20130130
    and ((Vl(FetchElm(RetNo,'T691',10))>0)   //20130130
    Or (Vl(FetchElm(RetNo,'T691',40))>0)   //20200205
    Or (Vl(FetchElm(RetNo,'T691',16))>0)   //20130130
    Or (Vl(FetchElm(RetNo,'T691',23))>0)   //20130130
    Or (Vl(FetchElm(RetNo,'T691',18))>0)   //20190123
    Or (SubjectToMinTax(RetNo)))   //20130130
    then
    begin
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
    end;

    FName           := 'T778'; formDisplayName := 'T778';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If (FetchElm(RetNo,FName,71) >'')  //20111222
    or (FetchElm(RetNo,FName,60) >'')
    or (FetchElm(RetNo,FName,115) >'')
    or (FetchElm(RetNo,FName,123) >'')  then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'T936'; formDisplayName := 'T936';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If (FetchElm(RetNo,FName,6) >'')  //20111222
    or (FetchElm(RetNo,FName,13) >'')
    or (FetchElm(RetNo,FName,14) >'')
    or (FetchElm(RetNo,FName,134) >'')
    or (FetchElm(RetNo,FName,136) >'')
    then
    Begin
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
    end;

    FName           := 'T1170#1'; formDisplayName := 'T1170'; //20111222
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'T1206'; formDisplayName := 'T1206';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'T1212'; formDisplayName := 'T1212';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'T2017'; formDisplayName := 'T2017';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);


    //20121226
    FName           := 'T2209#1'; formDisplayName := 'T2209'; //20121226
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If (CalcLn433(RetNo)>0) or (CalcLn431(RetNo)>0)
    or (CalcLn439(RetNo)>0) or (CalcLn434(RetNo)>0)
    then
    begin
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
    end;

    FName           := 'T2222'; formDisplayName := 'T2222';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'T5004';
    formDisplayName := 'T5004';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'RC267';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    formDisplayName := 'RC267';
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'RC268';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    formDisplayName := 'RC268';
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'RC269';  formDisplayName := 'RC269';
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);

    FName           := 'RC359#1';  formDisplayName := 'RC359';  //20121226
    ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
    If Ret[RetNo].FormHasData[FName] then
      PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
   end;  //the End goes her 20111220


   //20250205                   should check if has data? doesnt have in test case so leave it out for now
   if ( ( Rc381InEffect(RetNo) ) and ( Ret[RetNo].FrmHasData[GetFormNo('RC381')] ) ) or (GetSinNo(RetNo)='870000445')
   // and (useS8InFormDisplayName=False)   //20220126
   then
   Begin
     FName           := 'RC381';
     formDisplayName := 'RC381';
     ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
     PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
   end;

   If (Ret[RetNo].Province <> 'QC')  //not QC
   and (GetSinNo(RetNo)<>'870002003')   //20240515 testcase 2 mary two
   then   //normal returm (no Multiple jurisdiction)
   begin
      //Provincial and Territorial Schedules----------------------------------------------------------------------------------
     If (Vl(FetchElm(RetNo,'S2PRV',19))>0)  //20120111   If (Ret[RetNo].FrmHasData[GetFormNo('S2PRV')])
     Or (Ret[RetNo].FormHasData['S11PRV'])
     Or (GetLine351ForEfile(RetNo)=1)   //20120115
     or (Ret[RetNo].Province='YT')  //20200205
     then
     Begin
      CurrentTop:=CurrentTop+VerticalAdvance*2;
      ALabel:=TvtLabel.Create(AForm);
      ALabel.Font.Size:=11;  //20180124
      ALabel.Caption:= 'Provincial and Territorial Schedules';
      InitT1CLabel(ALabel,CurrentTop,StartingLeft);
      ALabel.Parent:=AForm;
      PrintLabel(ALabel,ACanvas);

      if IsMultJurisdiction(RetNo)=False then //20240515
      Begin
       FName           := 'S2PRV';
       formDisplayName := 'Schedule (S2)';
       ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
       If (Vl(FetchElm(RetNo,'S2PRV',19))>0)
       Or (GetLine351ForEfile(RetNo)=1)   //20120115
       or (UpperCase(GetLastName(RetNo)) ='SIXTYTWO')   //20120120
       then //20120112
       begin
           PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
       end;
      End;

      //20190123
      FName           := 'S12NB';
      formDisplayName := 'Schedule (S12-NB)';
      ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
      If Ret[RetNo].FormHasData['S12NB']
      then //20120112
      begin
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
      end;

      If Ret[RetNo].Province <> 'QC' then  //20111227
      begin
       FName           := 'S11PRV';
       FNo:=GetFormNo(Fname);
       formDisplayName := 'Schedule (S11)';
       ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
       if (FetchElmFNo(RetNo,FNo,1)>'')
       or (FetchElmFNo(RetNo,FNo,14)>'')
       or (FetchElmFNo(RetNo,FNo,2)>'')
       or (FetchElmFNo(RetNo,FNo,10)>'')
       then
        PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
      end;
    end;

     //Provincial and Territorial forms ----------------------------------------------------------------------------------
    If (Ret[RetNo].Province <> 'QC')   //NOT QC
    and (GetSinNo(RetNo)<>'870002003')   //20240515 testcase 2 mary two
    then //20111227
    begin
     CurrentTop:=CurrentTop+VerticalAdvance*2;
     ALabel:=TvtLabel.Create(AForm);  //new lbl to be used for all boxes
     ALabel.Font.Size:=11;  //20180124
     ALabel.Caption:= 'Provincial and Territorial forms';
     InitT1CLabel(ALabel,CurrentTop,StartingLeft);
     ALabel.Parent:=AForm;
     PrintLabel(ALabel,ACanvas);

     If (Ret[RetNo].Province <> 'QC') then //20111227
     Begin
      formDisplayName := 'Form 428';
      ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
      FName           := WhichTaxForm(RetNo,Ret[RetNo].Province);
      If Ret[RetNo].FormHasData[FName] then
      begin
        Fname:='FORM428';  //20111220  go back to generic form
        ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180125
        PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
      end;
     End;

    if IsMultJurisdiction(RetNo)=false then  //20240515
    Begin
     //these prov have 479
     If (Ret[RetNo].Province = 'NL')  //20240210
     or (Ret[RetNo].Province = 'NS')  //20120123
     or (Ret[RetNo].Province = 'ON')
     or (Ret[RetNo].Province = 'PE')
     or (Ret[RetNo].Province = 'QC')
     or (Ret[RetNo].Province = 'SK')   //20170215
     then
      Begin
      formDisplayName := 'Form 479';
      FName:= WhichCreditForm(RetNo,Ret[RetNo].Province);
      ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
      If Ret[RetNo].FormHasData[FName] then
      begin
        Fname:='FORM479';  //20111220  go back to generic form
        PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
      end;
    end;

    //20220513
    //on479A needed in MJ //20220511
     if (IsMultJurisdiction(RetNo)) and (Ret[RetNo].Province='ON') Then
     Begin
      If Ret[RetNo].FormHasData['ON479A'] then
      begin
       formDisplayName := 'Form ON479-A';
       ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
       FName           := 'ON479A'; //WhichCreditForm(RetNo,Ret[RetNo].Province);

       If ScheduleRelatedLines=Nil then ScheduleRelatedLines:=TStringList.Create; //20220513
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
       GetScheduleRelatedLines(RetNo,FrmNm,ScheduleRelatedLines); //???? aleady done?
       //dummy this out if MJ
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
      end;
     End;
    End;

    If Ret[RetNo].Province = 'ON' then //20111228
    Begin
     FName           := 'ONBEN';
     formDisplayName := 'ON-BEN';
     ALabel.Font.Size:=9; ALabel.Font.Style:=[fsBold];  //20180124
     If Ret[RetNo].FormHasData[FName] then
       PrintCondensedFormLines(RetNo,T1cFNo,ALabel,AvtEditBox,startingLeft,Displacement,currentTop,verticalAdvance,hdc,ACanvas,FName,formDisplayName);
    end;
  end;
  //20190123
    CurrentTop:=900;
    ALabel.Parent:=AForm;
    ALabel.Name:='lblPriv';
    Alabel.Font.Size:=9;  //20170205
    InitT1CLabel(ALabel,CurrentTop,StartingLeft);
    Alabel.Caption:='See the privacy notice on your return.';
    PrintLabel(ALabel,ACanvas);CurrentTop:=CurrentTop+VerticalAdvance;
   end;

  AForm.Free;
  if not assigned(APDFPrinter) then //20161105 Igor
  begin
    //20160805 Igor >>>
    If FastPrint = True then
      NeedNewPage := True
    else
      Printer.EndDoc;
  end;

 Screen.Cursor := crDefault;
 end;


Procedure PrintAllInstancesOf(RetNo:Integer;FName:String);
Var i:Integer;
Begin
 for i :=0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[i];
    If Frec.FormName =ExtractNonInstFormName(FName) then
    begin
       If Ret[RetNo].FormHasData[Frec.FormName+Frec.FormInst] then  //20160813
         MainFormT1.StartPrintForm(Retno,Frec.FormInstName,99);
    end;
 end;
end;

Procedure PrintFilingCopy(RetNo:Integer);
Var i:Integer;MoreForms:TStringList;
Begin
 With MainFormT1 do
 Begin
  FastPrint:=True;
  StartPrintForm(Retno,SubstituteT1CForm(RetNo,'T1'),1);
  StartPrintForm(Retno,SubstituteT1CForm(RetNo,'T1'),2);
 // PrintForm(RetNo,'T1C_3',1,'');
 // StartPrintForm(Retno,'T1C_3',99);
  PrintT1C(RetNo,'T1C_3');  //fails not currently printing
  StartPrintForm(Retno,SubstituteT1CForm(RetNo,'T1'),3);  //20111222  instead of page 4

  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   //If (UpperCase(Frec.AddInT1C)='Y')
   If Frec.AddInT1C
   and (Ret[RetNo].FormHasData[Frec.FormName+Frec.FormInst])   //20160813
   then  PrintAllInstancesOf(RetNo,Frec.FormName);
  end;
  end;
end;


Procedure SortFormComponentsTopToBottom(MyScrollBox:tVtScrollBox;TempList:TStringList);
Var CompIndex:Integer;TopLocation,CompTop:Integer;
begin
 TopLocation:=0;
 for CompIndex := 0 to MyScrollBox.ComponentCount - 1 do
 begin
    if MyScrollBox.Components[CompIndex] is TvtShape then
    Begin
     CompTop:=(MyScrollBox.Components[CompIndex] as TvtShape).Top;
     TempList.Add(AddLeadingZeros(IntToStr(CompTop),5)+' Shape');
    end
    Else If MyScrollBox.Components[CompIndex] is TvtEdit then
    begin
     CompTop:=(MyScrollBox.Components[CompIndex] as TvtEdit).Top;
     TempList.Add(AddLeadingZeros(IntToStr(CompTop),5)+' Edit');
    end
    Else If MyScrollBox.Components[CompIndex] is TvtLabel then
    begin
     CompTop:=(MyScrollBox.Components[CompIndex] as TvtLabel).Top;
     TempList.Add(AddLeadingZeros(IntToStr(CompTop),5)+' Label');
    end;
  end;
 TempList.Sorted:=True;
//  Templist.SaveToFile('C:\test\SortedComponents.txt'); //20120112  //20170115
end;


procedure PrintDynamicForm(RetNo:Integer;FName:String);
var
  p: integer;
  ACanvas:TCanvas;
  DfmFileName:String;
  hdc: THandle;
  FNo:Integer;
  F: TForm;
  MyScrollBox:TvtScrollBox;
  TotalPages: Integer;
  CurrPage: Integer;
  footerIdx: integer;

  function PrepareLabelText(AText: string): string;
  begin
    Result := ReplaceStr(AText, '[#page]', IntToStr(CurrPage));
    Result := ReplaceStr(Result, '[#pagecount]', IntToStr(TotalPages));
  end;

  procedure PrintControls(APageBreak, ANextPageBreak: TPageBreak);
  var
    i: integer;
    MyImage: TImage;
    s: string;
    R: TRect;
    MyFrame: TFrame;
    PixelsPerInch: TPoint;
    j: Integer;
    oldTop: integer;
    OldCaption: string;
    OldLeft: Integer;
  begin
    for i := 0 to MyScrollBox.ControlCount - 1 do
    begin
      if (MyScrollBox.Controls[i].Top + MyScrollBox.Controls[i].Height >= APageBreak.Pos) and (MyScrollBox.Controls[i].Top + MyScrollBox.Controls[i].Height < ANextPageBreak.Pos) then
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
          MyScrollBox.Controls[i].Top := MyScrollBox.Controls[i].Top - APageBreak.Pos;

        if (MyScrollBox.Controls[i] is TvtEdit) AND TvtEdit(MyScrollBox.Controls[i]).vtIsPrintable then
        begin
          begin
            PrintEditBox(RetNo,MyScrollBox.Controls[i] as TvtEdit,FName,FNo,hdc,ACanvas);
          end;
        end;

        if (MyScrollBox.Controls[i] is TvtLabel) AND TvtLabel(MyScrollBox.Controls[i]).vtIsPrintable then
        begin
          Begin
            begin
              OldCaption := TvtLabel(MyScrollBox.Controls[i]).Caption;
              TvtLabel(MyScrollBox.Controls[i]).Caption := PrepareLabelText(TvtLabel(MyScrollBox.Controls[i]).Caption);
              PrintLabel(MyScrollBox.Controls[i] as TvtLabel,ACanvas);
              TvtLabel(MyScrollBox.Controls[i]).Caption := OldCaption;
            end;
          End;
        end;

        if MyScrollBox.Controls[i] is TRichEdit then
        begin
          if Assigned((MyScrollBox.Controls[i] as TRichEdit).Parent) then
          begin
            begin
              PrintRichEdit(RetNo, (MyScrollBox.Controls[i] as TRichEdit), ACanvas);
            end;
          end;
        end;

        if (MyScrollBox.Controls[i] is TvtShape) AND (MyScrollBox.Controls[i] as TvtShape).vtIsPrintable then
        begin
          begin
            PrintVtShape(MyScrollBox.Controls[i] As TvtShape,ACanvas);
          end;
        end;

        if MyScrollBox.Controls[i] is TImage then
        begin
          begin
            MyImage := (MyScrollBox.Controls[i] as TImage);
            if (UpperCase(MyImage.Name)= 'E_SIGNATUREHOLDER') Or (UpperCase(MyImage.Name)= 'E_PREPARERSIGNATUREHOLDER') then
            begin
              if UpperCase(FetchElmFNo(RetNo,InfoFNo,144))='Y' then  //INFO Electronic sign = yes
              begin
                s:=GetSignatureFilePath(GetLastName(Retno),GetFirstName(RetNo));
                If UpperCase(MyImage.Name)= 'E_PREPARERSIGNATUREHOLDER' then
                    s:=GetPreparerSignatureFilePath;
                If s>'' then
                Begin
                  R.Left := ScalePrX(MyImage.Left);
                  R.Top := ScalePrY(MyImage.Top);
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
        begin
          MyFrame := MyScrollBox.Controls[i] as TFrame;
          begin
            for j := 0 to MyFrame.ComponentCount - 1 do
            begin
              if MyFrame.Components[j] is TImage then
              begin
                MyImage := MyFrame.Components[j] as TImage;
                R.Left := ScalePrX(MyFrame.Left);
                R.Top := ScalePrY(MyFrame.Top);
                PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
                PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
                R.Right := R.Left + (MyImage.Picture.Width * (PixelsPerInch.x)) div ScMult;
                R.Bottom := R.Top + (MyImage.Picture.Height * (PixelsPerInch.y)) div ScMult;
                if Pos('FLAGFRAME', UpperCase(MyImage.Parent.name)) > 0 then
                  PrintBitmap(ACanvas, R, MyImage.Picture.Bitmap);
              end;
            end;
          end;
        end;
        MyScrollBox.Controls[i].Top := OldTop;
        MyScrollBox.Controls[i].Left := OldLeft;
      end;
    end;
  end;

begin
  FNo:=GetFormNo(FName);
  DfmFileName:=GetDFMFileName(FName);
  If not FileExists(DfmFileName) then
  Begin
    ShowMessage('DFM File problem ='+DfmFileName);
    Exit;
  end;

  F := TForm.Create(Application);
  F.visible := False;
  MyScrollBox := TFormT1_2026.Create(F,RetNo,FNo);
  ReadComponentResFile(DfmFileName,MyScrollBox);
  MyScrollBox.AfterOpenForm(vtdPrint);

  for p := 0 to MyScrollBox.ControlCount - 1 do
    If MyScrollBox.Controls[p] is TRichEdit then
      IncRichEditFontSize(TRichEdit(MyScrollBox.Controls[p]), 2 * MainOptions.Prn_FontIncr, IsFormAClientLetter(FName));


  MyScrollBox.PrepareDynamicFormForPrint(IsLandscape(FName));

  if Printer.Printing then
    Printer.EndDoc;
  Printer.Orientation := MyScrollBox.PagebreakPos[0].Orientation;
  CalcScaleXY;
  Printer.Title := GetFormRlName(FNo) + ' : ' + GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
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
    if MyScrollBox.PagebreakPos[p].IsFooter then
      continue;

    if (Printer.Orientation <> MyScrollBox.PagebreakPos[p].Orientation) then
    begin
      if Printer.Printing then
        Printer.EndDoc;
      Printer.Orientation := MyScrollBox.PagebreakPos[p].Orientation;
      Printer.Title := GetFormRlName(FNo) + ' : ' + GetLastName(RetNo) + ', ' + GetFirstName(RetNo);
      Printer.BeginDoc;
      CalcScaleXY;
    end
    else if p > 0 then
      Printer.NewPage;


    applyWaterMarks(ACanvas,Printer,p,RetNo,FName);

    {
    //jz//20260225 - MOVED TO applyWaterMarks PROCEDURE
    //jz//20260220 - cleaned up the code a bit
    // print of first page
    if p = 0 then
    begin
      If FName='T1135' then
      begin
          //original Efiled
          If   (FetchElm(RetNo,FName,39)>'') and  //there is Efile confirmation #
                 (FetchElm(RetNo,FName,22)='')      //not amended
          then
          begin
            PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
            PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
          end

          //amended
          else if (FetchElm(RetNo,FName,39)>'') and             //there is Efile confirmation #
                  (FetchElm(RetNo,FName,22)>'') and             //is amended
                  (UpperCase(FetchElm(RetNo,FName,65))<='R1')   //original //20190212
          then  //there is Efile confirmaqtion
          begin
           PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
          end
          //Efiled after amended?
          else if (FetchElm(RetNo,FName,39)>'') and               //there is Efile confirmation #
                  (FetchElm(RetNo,FName,22)>'') and               //amended
                  (UpperCase(FetchElm(RetNo,Fname,65))>='R2')     //retransmission
          then  //there is Efile confirmaqtion
          begin
           PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
           PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
         end;
      end; //end If FName='T1135'

      If FName='T1134' then
      begin
          //original Efiled
          If   (FetchElm(RetNo,FName,26)>'') and                //has Confirmation #
               (FetchElm(RetNo,FName,99)='')                    //is not amended
          then
          begin
           PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
           PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
          end
          //amended
          else if (FetchElm(RetNo,FName,26)>'') and             //has Confirmation #
                  (FetchElm(RetNo,FName,99)>'') and             //is amended
                  (UpperCase(FetchElm(RetNo,FName,27))<='R1')   //original //20190212
          then  //there is Efile confirmaqtion
          begin
           PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
          end
          //Efiled after amended?
          else if (FetchElm(RetNo,FName,26)>'') and             //has Confirmation #
                  (FetchElm(RetNo,FName,99)>'') and             //is amended
                  (UpperCase(FetchElm(RetNo,Fname,27))>='R2')   //retransmission
          then  //there is Efile confirmaqtion
          begin
           PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
           PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
         end;
      end; //end If FName='T1134'
    end;   //end Page 0

    if isDraft then
      PrintAtAngle('DRAFT',ACanvas, 200,Printer.PageHeight div 2-100,50,50);
    }

    PrintControls(MyScrollBox.PagebreakPos[p], MyScrollBox.PagebreakPos[p+1]);

    for footerIdx := p to Length(MyScrollBox.PagebreakPos) - 2 do
    if MyScrollBox.PagebreakPos[footerIdx].IsFooter then
    begin
      PrintControls(MyScrollBox.PagebreakPos[footerIdx], MyScrollBox.PagebreakPos[footerIdx+1]);
      break;
    end;

    Inc(CurrPage);
  end;

  if FastPrint then
    NeedNewPage := true
  else
    Printer.EndDoc;
  MyScrollBox.Free;
end;
//20240904 Igor <<<

procedure PrepareRichEdit(ARetNo: Integer; AFormName: String; ARichEdit: TRichEdit);
Begin
  if IsFormAClientLetter(AFormName) then
  begin
    GetInterpetedRichEdit(ARetNo, GetLetterFileName(ARetNo, AFormName), ARichEdit);
    Delay(50);
  end;
End;


//20190129
procedure PrintImageT1(ARetNo: Integer; AFormName: String; AImage: TImage; ACanvas: TCanvas;
                       ADTop: Integer = 0; ADLeft: Integer = 0);
Var s:String; R:Trect;
begin
  if IsNonResident(ARetNo) = True then
    OptRec.NoBarcode := True;

  if ((OptRec.NoBarCode = False)
      and (IsReadyForBarCode(ARetNo) = True)
      and (AImage.name = 'barcodePlaceHolder1')) then
  begin
    AttachBarCode(ARetNo, ACanvas, AImage, ADTop, ADLeft);
  end //end if (AImage.name = 'barcodePlaceHolder1'))

  else if (OptRec.NoBarCode=False)
     and (IsReadyForBarCode(ARetNo) = True) and (AImage.name = 'SFDbarcodePlaceHolder1')
     and (GetNumberOfSFDsForBarcode(ARetNo) > 0) and (GetNumberOfSFDsForBarcode(ARetNo) < 3)
  then
  begin
      //note: does not seem to print barcode when there is a debug breakpoint for some reason
      AttachSFDBarCode(ARetNo, ACanvas, AImage, ADTop, ADLeft);
  end //end if (AImage.name = 'SFDbarcodePlaceHolder1')

  else if (AImage.name = 'barcodePlaceHolder1013') and (true) then
  begin
      Attach1013BarCode(ARetNo, AFormName, ACanvas, AImage, ADTop, ADLeft);
  end

  //20180307 Igor >>>
  else if (AImage.name = 'QRCodePlaceHolder') then
  begin
      AttachQRCode(GetQRContentsForT7DR(ARetNo), ACanvas, AImage, ADTop, ADLeft);
  end
  //20180307 Igor <<<

  Else //20200318
  if (UpperCase(LeftStr(AImage.Name,17))= 'E_SIGNATUREHOLDER')
  Or (UpperCase(LeftStr(AImage.Name,25))= 'E_PREPARERSIGNATUREHOLDER')  //20200627
  then
  Begin
    if UpperCase(FetchElmFNo(aRetNo,InfoFNo,144))='Y' then  //20200326 //use signature
    Begin
      if (AFormName<>'T1032') then  //all except t1032 i.e. anyother form
      Begin
       s:=GetSignatureFilePath(GetLastName(Aretno),GetFirstName(ARetNo));  //20200419
       If (UpperCase(LeftStr(AImage.Name,25))= 'E_PREPARERSIGNATUREHOLDER') then
       Begin
        s:=GetPreparerSignatureFilePath;  //20200627
       End;

 if ((aFormName='T183') and (FetchElm(ARetNo,'T183',15)='') And (UpperCase(AImage.Name)= 'E_SIGNATUREHOLDER1')) then //PAD has no date //20200422
            s:=''; //pas suppress unless needed
      end

      Else if AFormName='T1032' then
      Begin
        if UpperCase(AImage.Name)= 'E_SIGNATUREHOLDER' then  ////20200419
        begin
          s:=GetSignatureFilePath(FetchElm(aRetNo,'T1032',2),FetchElm(aRetNo,'T1032',3));   //transferring spouse last/first nm
          If s>'' then AImage.Picture.LoadFromFile(s);
          If UpperCase(FetchElm(ARetNo,'T1032',34))<>'Y' then s:=''; //aImage.Picture:=Nil; not eligible
        end
        Else if UpperCase(AImage.Name)= 'E_SIGNATUREHOLDER1' then  //20200419  spoese's signature
        Begin
          s:=GetSignatureFilePath(FetchElm(aRetNo,'T1032',6),FetchElm(aRetNo,'T1032',7));   //transferring spouse last/first nm
          If s>'' then AImage.Picture.LoadFromFile(s);
          If UpperCase(FetchElm(ARetNo,'T1032',34))<>'Y' then s:=''; //not eliginle
        End;
      End;

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
      end;
    End;
  end

  Else //20200318  any other image name
  begin  //stretched drawing

    PrintImage(ARetNo, AImage, ACanvas.Handle, ACanvas, ADTop, ADLeft);
  end;

end;

{
procedure PrintImageT1(ARetNo: Integer; AFormName: String; AImage: TImage; ACanvas: TCanvas;
    ADTop: Integer = 0; ADLeft: Integer = 0);
var
  mySFDImage, mySFDImage1, myImage1: TImage;
  b: Integer;

begin
  If IsNonResident(ARetNo) = True then
    OptRec.NoBarcode := True;
  mySFDImage := AImage;
  //20180124
  if (OptRec.NoBarCode=False)
     and (IsReadyForBarCode(ARetNo) = True)
     and (mySFDImage.name = 'barcodePlaceHolder1')
  then

  begin
    For b := 0 to AImage.Parent.ControlCount - 1 do
    begin
      if AImage.Parent.Controls[b] is TImage then
      begin
        myImage1 := AImage.Parent.Controls[b] as TImage;
        if myImage1.name = 'barcodePlaceHolder2' then
        begin
          AttachBarCode(ARetNo, ACanvas, AImage, ADTop, ADLeft);
          break;
        end;
      end;
    end;
  end
  else
  if (OptRec.NoBarCode=False)
     and (IsReadyForBarCode(ARetNo) = True)
     and (mySFDImage.name = 'SFDbarcodePlaceHolder1')
     and (GetNumberOfBarCodeSFDs(ARetNo) > 0)
     and (GetNumberOfBarCodeSFDs(ARetNo) < 3)
  then
  begin
    For b := 0 to AImage.Parent.ControlCount - 1 do
    begin
      if AImage.Parent.Controls[b] is TImage then
      begin
        mySFDImage1 := AImage.Parent.Controls[b] as TImage;
        if mySFDImage1.name = 'SFDbarcodePlaceHolder2' then
          AttachSFDBarCode(ARetNo, ACanvas, mySFDImage, ADTop, ADLeft);
      end;
    end;
  end
  else
  if (AImage.name = 'barcodePlaceHolder1013') and (true) then
  begin
    Attach1013BarCode(ARetNo, AFormName, ACanvas, mySFDImage, ADTop, ADLeft);
  end
  //20180307 Igor >>>
  else if (AImage.name = 'QRCodePlaceHolder') then
  begin
    AttachQRCode(GetQRContentsForT7DR(ARetNo), ACanvas, AImage, ADTop, ADLeft);
  end
  //20180307 Igor <<<
  else
  begin
    PrintImage(ARetNo, AImage, ACanvas.Handle, ACanvas, ADTop, ADLeft);
  end;
end;
}

procedure PrintHeader(ACanvas: TCanvas; ARetNo: Integer; AFormName: String; AFormNo: Integer;
  APageNumber: Integer; APageHeight, APageWidth: Integer;  //20161130 Igor
  ADTop: Integer = 0; ADLeft: Integer = 0); //20161107 Igor
begin
  If not IsFormDynamic(ARetNo, AFormName) then //20161107 Igor
  Begin
    ACanvas.Font.size := 8;
    ACanvas.Font.Color:=clBlack;
    ACanvas.Brush.Style := bsClear;
    If (OptRec.Prn_NameH) and (IsShowHdrIndicator(AFormName)) then
      ACanvas.TextOut(ScalePrX(10 + ADLeft), ScalePrY(0 + ADTop), GetRetName(ARetNo));
    If (OptRec.Prn_DateH) and (IsShowHdrIndicator(AFormName)) then
      ACanvas.TextOut(ScalePrX(225 + ADLeft), ScalePrY(0 + ADTop), 'Tax Year: '+AppYear+'     Date Printed: '+DateToMonthDayYear(Date));
    If ShowFieldIdSw then
      ACanvas.TextOut(ScalePrX(400 + ADLeft), ScalePrY(0 + ADTop), AFormName + '  Fno='+IntToStr(AFormNo))
    else
    If (OptRec.Prn_SinH) and (IsShowHdrIndicator(AFormName)) then
    Begin
      if OptRec.Prn_HideSin=False then
        ACanvas.TextOut(ScalePrX(520 + ADLeft),ScalePrY(0 + ADTop), ' SIN: ' + ReformatSin(GetSinno(ARetNo)))
      Else
        ACanvas.TextOut(ScalePrX(520 + ADLeft),ScalePrY(0 + ADTop), ' SIN: ' + GetHiddenSin(GetSinno(ARetNo)));
    End;

    If ((OptRec.Prn_NameH) or (OptRec.Prn_DateH) or (OptRec.Prn_SinH)) and IsShowHdrIndicator(AFormName) then
    begin
      ACanvas.MoveTo(ScalePrX(10 + ADLeft), ScalePrY(12 + ADTop));
      ACanvas.LineTo(ScalePrX(600 + ADLeft), ScalePrY(12 + ADTop));
    end;
  End;
  //20161107 Igor >>>
  if APageNumber = 1 then
  begin
    //Headers
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
         (UpperCase(FetchElm(ARetNo, AFormName, 65))<='R1') then  //there is Efile confirmaqtion
      begin
        PrintAtAngle('AMENDED ON ' + FormatDateTime('yyyy-mm-dd', Date), ACanvas,
          100, Trunc(APageHeight - (APageHeight / 3)), 50, 240);
      end;

      If (FetchElm(ARetNo, AFormName, 39) > '') and
         (FetchElm(ARetNo, AFormName, 22) > '') and
         (UpperCase(FetchElm(ARetNo, AFormName, 65))>= 'R2') then  //there is Efile confirmaqtion
      begin
         PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(APageHeight-(APageHeight / 3)), 25, 240);
         PrintAtAngle('SENT ON ' + FormatDateTime('yyyy-mm-dd', Date) + '-DO NOT SEND BY MAIL',
           ACanvas, 100, Trunc(APageHeight-(APageHeight / 3) + (APageHeight / 9) - 200), 25, 240);
      end;
    end;
  end;
  //20161107 Igor <<<

  //20161130 Igor >>>
  if isDraft then
  begin
    // x y font and angle
    PrintAtAngle('D R A F T  Not reviewed by CRA', ACanvas, 100, (APageHeight div 2) - 50, 30, 100);
  end;

  If LicenseLevel = llDemo then {demo}
    PrintAtAngle('For Demo Purposes Only', ACanvas, 100, (APageHeight div 2) + 50, 30, 100)
  //20161130 Igor <<<
end;



//jz//20260325
procedure applyWaterMarks(var ACanvas:TCanvas;Printer:TPrinter;ppage,RetNo:Integer;FName:string);
var
  efConfermationElm,efAmendedElm,efRevisionElm:integer;
begin

  if isDraft then
    PrintAtAngle('DRAFT',ACanvas, 200,Printer.PageHeight div 2-100,50,50);

  //jz//20260220 - cleaned up the code a bit
  //if ppage = 0 then   //jz//20260330 - they want all pages to have watermarks //print of first page
  begin
    if      FName='T1135'   then begin efConfermationElm := 39; efAmendedElm := 22; efRevisionElm := 65; end
    else if FName='T1134'   then begin efConfermationElm := 26; efAmendedElm := 99; efRevisionElm := 27; end
    else if FName='T217'    then begin efConfermationElm := 59; efAmendedElm := 23; efRevisionElm := 65; end //reEfile Conf elm??

    //    else if FName='PAD'     then begin efConfermationElm := 00; efAmendedElm := 00; efRevisionElm := 00; end //no conf elms??
    //    else if FName='CONSENT' then begin efConfermationElm := 28; efAmendedElm := 00; efRevisionElm := 00; end
    //    else if ExtractNonInstFormName(FName)='T1013'   then begin efConfermationElm := 39; efAmendedElm := 00; efRevisionElm := 00; end
    else if ExtractNonInstFormName(FName)='T2057'   then begin efConfermationElm := 59; efAmendedElm :=  5; efRevisionElm := 65; end
    else if ExtractNonInstFormName(FName)='T2059'   then begin efConfermationElm := 59; efAmendedElm :=  5; efRevisionElm := 65; end
    else
      exit;


    //original Efiled
    If   (FetchElm(RetNo,FName,efConfermationElm)>'') and  //there is Efile confirmation #
         (FetchElm(RetNo,FName,efAmendedElm)     ='')      //not amended
    then
    begin
      PrintAtAngle('DUPLICATE',ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
      PrintAtAngle('DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),50,240);   //20160707
    end

    //amended
    else if (FetchElm(RetNo,FName,efConfermationElm)       >'') and   //there is Efile confirmation #
            (FetchElm(RetNo,FName,efAmendedElm)            >'') and   //is amended
            (UpperCase(FetchElm(RetNo,FName,efRevisionElm))<='R1')    //original //20190212
    then  //there is Efile confirmaqtion
    begin
     PrintAtAngle('AMENDED ON '+ FormatDateTime('yyyy-mm-dd',Date),ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),50,240);   //20141229
    end
    //Efiled after amended?
    else if (FetchElm(RetNo,FName,efConfermationElm)       >'') and    //there is Efile confirmation #
            (FetchElm(RetNo,FName,efAmendedElm)            >'') and    //amended
            (UpperCase(FetchElm(RetNo,Fname,efRevisionElm))>='R2')     //retransmission
    then  //there is Efile confirmaqtion
    begin
     PrintAtAngle('DUPLICATE OF AMENDED RETURN', ACanvas, 180,Trunc(Printer.PageHeight-(Printer.PageHeight/3)),25,240);   //20141229  //font smaller 20160707
     PrintAtAngle('SENT ON '+ FormatDateTime('yyyy-mm-dd',Date)+'-DO NOT SEND BY MAIL',ACanvas, 300,Trunc(Printer.PageHeight-(Printer.PageHeight/3)+(Printer.PageHeight/9)-200),25,240);   //20141229
    end;
  end; //end if page 0

end;

end.
