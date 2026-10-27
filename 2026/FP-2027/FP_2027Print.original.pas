unit FP_2027Print;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,StdCtrls,Dialogs,Printers,{ QuickRpt,} //20150818 igor
  ComCtrls,
  vtEditBox,vtShape,vtLabel,extctrls,
  RichEdit,FP_2027ChildWinNew,FP_2027Declare,
  vtGroupBox, vtForm, //20160407 Igor

  rxRichEd; //20160819 Igor (Must be last)

Const MxFrmHeight = 1050; //980; //960;
Const MxFrmWidth  = 655;


{Procedure PrintALetter(RetNo:Integer;LetterName:String);}
procedure PrintForm(RetNo: integer; FName: string;WhichPage:integer);
Function PrintQuickReport(RetNo: integer; FName: string;WhichPage:integer): boolean;
procedure PrintFormPage(AForm: TFormFP_2027);
//procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm);
//Function PrintFormPage(RetNo: integer; FName: string): boolean;
//procedure DrawShape(TopLeft, BottomRight: TPoint; PenWidth: Integer);
Procedure AfterReadComponentForPrint(AForm:TFormFP_2027);

Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0);
{-----------------------------------------}
Var
//ScaleX, ScaleY : Word;

PFile    : TextFile;
HeaderType : string; //[1];
PRINTCNT, PGNO : Integer;

implementation

{-----------------------------------------}

uses
  vtMulti,vtCommon,vtDialogs,
  FP_2027,FP_2027TrimStr,FP_2027Common,
  FP_2027Common2,FP_2027Calc,FP_2027RepAssets,FP_2027RepLiabilities,
{$IFDEF ADO}
  FP_2012RepLifeInsurance,FP_2012RepGoalsObjectives,FP_2012RepProblemsSolutions,
  FP_2012RepGeneralActionPlan,FP_2012RepActionPlan,
{$ELSE}
{$ENDIF}
  FP_2027Main,vtPrints,
  vtTrimStr,vtShared
 ,RegularExpressions; // 20151214 Igor


procedure PrintForm(RetNo: integer; FName: string;WhichPage:integer);
Var i,j,n:integer; Root, FInst :string;
  FrmNm: String;
  DfmFileName,PFormFileName:String;
  F: TForm; //20160405 Igor
  FullForm,PForm:TFormFP_2027;
  PagebrakePos: array of Integer;
  startpage,endpage:integer;
  FormNo, formNumPages:Integer;
  MyLabel:TvtLabel;
  MyEditBox:tvtEdit;
  MyVtShape:TvtShape;

  Match: TMatch;          // 20151214 Igor
  strem:TStringStream;    // 20151214 Igor
  newRichText:AnsiString; // 20151214 Igor

  procedure PrintPage(DfmFileName: string);
  var
    FullForm: TFormFP_2027;
  begin
    FullForm:=TFormFP_2027.Create(nil, RetNo, FormNo); //(Application);
    if ReadComponentResFile(DfmFileName, FullForm) <> nil then
    begin
      FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
      CalcDynamic(RetNo,FName,FullForm);
      AfterReadComponentForPrint(FullForm);
      FullForm.vertscrollbar.position := 0;
      FullForm.horzscrollbar.position := 0;
      PrintFormPage(FullForm);
    end;
    FullForm.Free;
  end;

begin
   FrmNm := FName;
   FormNo := GetFormNo(FrmNm);
   //FrmNm := SubstituteForm(RetNo,FrmNm);
   FInst := ExtractFormInst(FrmNm);
   DfmFileName:=GetDFMFileName(RetNo, FrmNm);

   If fileExists(DfmFileName) = False then exit;
   F:=TForm.Create(Application); //20160405 Igor
   F := TForm.Create(Application); //20160405 Igor
   F.visible := False; //20160405 Igor

   FullForm:=TFormFP_2027.Create(F, RetNo, FormNo); //(Application); //20160405 Igor
  if ReadComponentResFile(DfmFileName, FullForm) = nil then
  begin
     //ShowMessage('Form '+DfmFileName +' is damaged. Contact VisualTax');
    FullForm.free;
    exit;
  end;
   FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
   CalcDynamic(RetNo,FName,FullForm);
   AfterReadComponentForPrint(FullForm);
   FullForm.vertscrollbar.position := 0;
   FullForm.horzscrollbar.position := 0;

   SetLength(PagebrakePos, 20);

   formNumPages := 1;
   PagebrakePos[0] := 0;

 for i := 0 to FullForm.ComponentCount - 1 do
 begin
    // 20151214 Igor
    If FullForm.Components[i] is TRichEdit then
      if TRichEdit (FullForm.Components[i]).Text <> '' then
      begin
         strem:=TStringStream.Create;
         TRichEdit (FullForm.Components[i]).Lines.SaveToStream(strem);
         newRichText:=strem.DataString;
         //201601 Igor
         for Match in TRegEx.Matches(newRichText,'[\\][f][s]\d{1,}') do
           newRichText:= ReplaceStr(newRichText, Match.Value, '\fs' + IntToStr(StrToInt(ReplaceStr(Match.Value,'\fs','')) + 2 * MainOptions.Prn_FontIncr));
         strem.Seek(0, soFromBeginning);
         strem.WriteString(newRichText);
         strem.Seek(0, soFromBeginning);
         TRichEdit (FullForm.Components[i]).Lines.LoadFromStream(strem);
      end;

   If FullForm.Components[i] is TVtShape then
       if (FullForm.Components[i] as TVtShape).vtPageBreak then
       begin
        formNumPages := formNumPages + 1;
        PagebrakePos[formNumPages] := (FullForm.Components[i] as TVtShape).Top;
       end
       else
        (FullForm.Components[i] as TVtShape).SendToBack;
 end;  //i components

 if formNumPages > 1 then
 begin
   PagebrakePos[formNumPages + 1] := PagebrakePos[formNumPages] + 1100;

   for j := 1 to formNumPages do
   begin
    for  i := FullForm.ComponentCount - 1 downto 0 do
    begin
     if ((FullForm.Components[i] as TControl).Top > PagebrakePos[j]) and
        ((FullForm.Components[i] as TControl).Top < PagebrakePos[j+1])
     then
     begin
      (FullForm.Components[i] as TControl).Top := (FullForm.Components[i] as TControl).Top - PagebrakePos[j];
     end
     else
     begin
      (FullForm.Components[i] as TControl).Free;
     end;
    end;

    PFormFileName := AppDir + '\TempPrintForm.dfm';
    WriteComponentResFile(PFormFileName, FullForm);
    FullForm.free;
    PForm:=TFormFP_2027.Create(F, RetNo, FormNo); //(Application); //20160405 Igor
    ReadComponentResFile(PFormFileName, PForm);
    AfterReadComponentForPrint(PForm);

    FrmNm := FName;
    FInst := ExtractFormInst(FrmNm);
    PrintFormPage(PForm); //(RetNo,FrmNm,PForm);

    PForm.Free;

    FullForm:=TFormFP_2027.Create(F, RetNo, FormNo);  //(Application); //20160405 Igor

    ReadComponentResFile(DfmFileName, FullForm);
    FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
    CalcDynamic(RetNo,FName,FullForm);
    AfterReadComponentForPrint(FullForm);
    FullForm.vertscrollbar.position := 0;
    FullForm.horzscrollbar.position := 0;

   end; //end for

   FullForm.Free;
   if FileExists(PFormFileName) then SysUtils.DeleteFile(PFormFileName);

   exit;
 end; //////End of one page multi form printing
 FullForm.Free;

 If WhichPage =1 then  //current page only
  begin
   FrmNm := FName;
   //FrmNm := SubstituteForm(RetNo,FrmNm);
   FInst := ExtractFormInst(FrmNm);
   DfmFileName:=GetDFMFileName(RetNo, FrmNm);
   //If Ret[RetNo]^.LastYearData = True then DfmFileName:=GetLastYearDfmFileName(FName);
   FullForm:=TFormFP_2027.Create(F, RetNo, FormNo); //(Application); //20160405 Igor
   ReadComponentResFile(DfmFileName, FullForm);
   FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
   CalcDynamic(RetNo,FName,FullForm);
   AfterReadComponentForPrint(FullForm);
   FullForm.vertscrollbar.position := 0;
   FullForm.horzscrollbar.position := 0;

   PrintFormPage(FullForm);
  end
 else
 begin                   //whole form
  FrmNm := FName;
  If IsFormMultiPage(FrmNm) then
  begin
    n:=GetFormMxPg(FrmNm);
    Root := ExtractFormRootName(FrmNm);
    For i:=1 to n do
    begin
     FrmNm:=Root+'_'+IntToStr(i)+FInst;
     DfmFileName:=GetDFMFileName(RetNo, FrmNm);
     //If Ret[RetNo]^.LastYearData = True then DfmFileName:=GetLastYearDfmFileName(FName);
     FullForm:=TFormFP_2027.Create(F, RetNo, FormNo); //(Application); //20160819 Igor
     ReadComponentResFile(DfmFileName, FullForm);
   FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
     AfterReadComponentForPrint(FullForm);
     FullForm.vertscrollbar.position := 0;
     FullForm.horzscrollbar.position := 0;
     PrintFormPage(FullForm);
    end;
  end
  else
  begin
   FrmNm := FName;
   //FrmNm := SubstituteForm(RetNo,FrmNm);

   FInst := ExtractFormInst(FrmNm);
   DfmFileName:=GetDFMFileName(RetNo, FName);
   //If Ret[RetNo]^.LastYearData = True then DfmFileName:=GetLastYearDfmFileName(FName);
   FullForm:=TFormFP_2027.Create(F, RetNo, FormNo); //(Application); //20160819 Igor
   ReadComponentResFile(DfmFileName, FullForm);
   FullForm.AfterOpenForm(vtdPrint); //20160407 Igor
   CalcDynamic(RetNo,FName,FullForm);
   AfterReadComponentForPrint(FullForm);
   FullForm.vertscrollbar.position := 0;
   FullForm.horzscrollbar.position := 0;
   PrintFormPage(FullForm);
  end;
 end;
 FullForm.Free;
 F.Free; //20160405 Igor
end;

Function PrintQuickReport(RetNo: integer; FName: string;WhichPage:integer): boolean;
//20150818 igor Var  Report : TQuickRep;
begin
  If Fname = 'ASSETS' then
  begin
    Application.CreateForm(TRepAssetsFP_2027,RepAssets);
    //20150818 igor Report := RepAssets.QuickRep1;
    //20150818 igor Report.Print;
    RepAssets.Free;
    exit;
  end;
  If Fname = 'LIABIL' then
  begin
    Application.CreateForm(TRepLiabilities,RepLiabilities);
//20150818 igor     Report := RepLiabilities.QuickRep1;
//20150818 igor     Report.Print;
    RepLiabilities.Free;
    exit;
  end;

//ADODB???
  If Fname = 'GENOBJ' then  {Goals?}
  begin
  {$IFDEF ADO}
    Application.CreateForm(TRepGoalsObjectives,RepGoalsObjectives);
    Report := RepGoalsObjectives.QuickRep1;
    Report.Print;
    RepGoalsObjectives.Free;
  {$ELSE}
    ADOMsg('RepGoalsObjectives');
  {$ENDIF}
    exit;
  end;

  If Fname = 'LIFEINS' then
  begin
  {$IFDEF ADO}
    Application.CreateForm(TRepLifeInsurance,RepLifeInsurance);
    Report := RepLifeInsurance.QuickRep1;
    Report.Print;
    RepLifeInsurance.Free;
  {$ELSE}
    ADOMsg('RepLifeInsurance');
  {$ENDIF}
    exit;
  end;

  If Fname = 'PROBLEM' then
  begin
  {$IFDEF ADO}
    Application.CreateForm(TRepProblemsSolutions,RepProblemsSolutions);
    Report := RepProblemsSolutions.QuickRep1;
    Report.Print;
    RepProblemsSolutions.Free;
  {$ELSE}
    ADOMsg('RepProblemsSolutions');
  {$ENDIF}
    exit;
  end;

  If Fname = 'GENACT' then
  begin
  {$IFDEF ADO}
    Application.CreateForm(TRepGeneralActionPlan,RepGeneralActionPlan);
    Report := RepGeneralActionPlan.QuickRep1;
    Report.Print;
    RepGeneralActionPlan.Free;
  {$ELSE}
    ADOMsg('RepGeneralActionPlan');
  {$ENDIF}
    exit;
  end;

  If Fname = 'ACTPLN' then
  begin
  {$IFDEF ADO}
    Application.CreateForm(TRepActionPlan,RepActionPlan);
    Report := RepActionPlan.QuickRep1;
    Report.Print;
    RepActionPlan.Free;
  {$ELSE}
    ADOMsg('RepActionPlan');
  {$ENDIF}
    exit;
  end;

  {repeat for PORTFOL when Qreports ready}
end;

procedure PrintFormPage(AForm: TFormFP_2027);
//procedure PrintFormPage(RetNo: integer; FName: string; AForm: TForm);
var
  RetNo: integer; FName: string;
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

  Margins: TMargins;
  //MyChild: TMyChildFP_2027;
  MyScrollBox: TFormFP_2027 absolute AForm;
  procedure PrintControls(AControl: TWinControl; ADTop, ADLeft: Integer);  //20160407 Igor
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
        begin
          PrintVtShape(MyVtShape, ACanvas, ADTop, ADLeft);
        end;
      end

      else
      if AControl.Controls[i] is TvtLabel then
      begin //print the label
        MyLabel:=AControl.Controls[i] as TvtLabel;
        if MyLabel.vtIsPrintable then
          PrintLabel(MyLabel,ACanvas, DefFontName, ADTop, ADLeft);
      end

      else
      if AControl.Controls[i] is TvtEdit then
      begin //print the editbox
        MyEditBox:=AControl.Controls[i] as TvtEdit;
        if MyEditBox.vtIsPrintable then
        begin
          PrintEditBox(RetNo,MyEditBox,FName,FNo,Hdc,ACanvas, ADTop, ADLeft);
        end;
      end //tvedit

      else
      if AControl.Controls[i] is TImage then
      begin
        AImage := AControl.Controls[i] as TImage;
        //MyChild.PaintChart(AImage);
        AForm.PaintChart(AImage);
        R.Left   := ScalePrX(AImage.Left + ADLeft);
        R.Top    := ScalePrY(AImage.Top + ADTop);
        R.Right  := R.Left +  ScalePrX(AImage.Picture.Width);
        R.Bottom := R.Top  +  ScalePrY(AImage.Picture.Height);
        PrintBitmap(ACanvas,R,AImage.Picture.Bitmap);
      end

      else
      if AControl.Controls[i] is TRichEdit then //RichEdit
      begin
        ARichEdit:=AControl.Controls[i] as TRichEdit;
        if Assigned(ARichEdit.Parent) then
        begin   // 20151016 igor
          if IsFormAClientLetter(FName) then
          begin
            GetInterpretedRichEdit(RetNo,GetLetterFileName(RetNo,FName),ARichEdit);
            Delay(50);
          end;
          PrintRichEdit(RetNo, ARichEdit, ACanvas, ADTop, ADLeft);
        end;
      end //richedit

      else
      if AControl.Controls[i] is TMemo then //TMemo
      begin
        //AMemo:=AControl.Controls[i] as TMemo;
        PrintMemo(RetNo, AControl.Controls[i] as TMemo, ACanvas, ADTop, ADLeft);
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
      end;
    end;  //i Controls
  End;

begin
   If AbortSw then exit;
   RetNo := AForm.RetNo;
   FName := AForm.FormName;
   //TObject(MyChild) := RetList[RetNo].MyChild;
   FName := UpperCase(Ltrim(RTrim(Fname)));


   if (Printer.Printing) and (FastPrint=False) then
   begin
    if MessageDlg('Printer temporarily busy. Try again?',
      mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;
   end;
   WhiteBoxes := GetWhiteBoxesIndicator(FName);

   If FastPrint = false then
   begin
    If IsLandscape(FName) Then
      Printer.Orientation := poLandscape
    else
      Printer.Orientation := poPortrait;
   end
   Else
    ;//Printer.Orientation := poPortrait;  //fst print


   //ShowMessage('Bfr begindoc= '+IntToStr(GetGDIResources));
   If FastPrint=false then
     Printer.BeginDoc;
   //ShowMessage('aftr begindoc= '+IntToStr(GetGDIResources));
   FNo := AForm.FormNo; // GetFormNo(FName);
   If FNo=0 then
    begin
     If FastPrint =false then Printer.EndDoc;
     exit;
    end;


   If Ret[RetNo].Frm[FNo].Count = 0 then InitFormData(RetNo,FNo);
   Printer.Title :=  GetRetName(RetNo);

   //PageX := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH); //Printer.PageWidth;
   //PageY := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT); //Printer.PageHeight;

   hdc :=  Printer.Canvas.Handle;
   ACanvas:=Printer.Canvas;

  dpiAdjustment := ( GetWindowsFontSize(Application.MainForm.Handle) * 100) div DesignPixelsPerInch;

  PageX := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);  //Printer.PageWidth;
  PageY := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT); //Printer.PageHeight;

  If Printer.Orientation = poLandscape then
  begin
  //20160115 Igor
  // PageX:=Round(PageX * 2/3);  //3/4 dot not go wide enough
   PageX:=Round(PageX * 3/4);  //3/4 dot not go wide enough
   //PageY:=Round(PageY * 4/3);
    PageY:=Round(PageY * 2);
  end;

  hdc :=  Printer.Canvas.Handle;
  ACanvas:=Printer.Canvas;

  ScaleX := (PageX * ScMult) div ( (MxFrmWidth  * dpiAdjustment) div 100); //to get the decimals
  //ScaleY := (PageY * ScMult) div ( (MxFrmHeight * dpiAdjustment) div 100); //to get the decimals
  ScaleY := (PageY * ScMult) div (((GetFormHeight(Fname) + 60) * dpiAdjustment) div 100); //to get the decimals

  (*  does not work
  If Printer.Orientation = poLandscape then
  begin
   ScaleX := Round(ScaleX * 3/4);
   ScaleY := Round(ScaleY * 3/2);
  end;
  *)


  //If UpperCase(LeftStr(LicenseLevel,7)) = 'T1 DEMO' then {demo}
  If LicenseLevel = llDemo then {demo}
  begin
    PrintAtAngle('For Demo Purposes Only',ACanvas, 200,Printer.PageHeight div 2-100,30,100)
  end
  else
  begin
  end;

  {Print Form Header}
  ACanvas.Font.size := 8;
  {remove switches later}

  {Print Header}
   If (OptRec.Prn_NameH) and (IsShowHdrIndicator(FName)) then
     ACanvas.TextOut(ScalePrX(10),ScalePrY(0),GetRetName(RetNo));
   If (OptRec.Prn_DateH) and (IsShowHdrIndicator(FName)) then
     ACanvas.TextOut(
       ScalePrX(270),ScalePrY(0), ' Date: '+DateToMonthDayYear(Date));
   If ShowFieldIdSw then
       ACanvas.TextOut(ScalePrX(400),ScalePrY(0), FName)
   else
       If (OptRec.Prn_SinH) and (IsShowHdrIndicator(FName)) then
         ACanvas.TextOut(ScalePrX(520),ScalePrY(0), ' BN: '
             + GetSinNo(RetNo));
   //If IsShowHdrIndicator(FName) then
   If ((OptRec.Prn_NameH)
   or (OptRec.Prn_DateH)
   or (OptRec.Prn_SinH))
   and IsShowHdrIndicator(FName) then
   begin
    ACanvas.MoveTo(10 * ScaleX div ScMult, 12 * ScaleY Div ScMult);
    ACanvas.LineTo((600)* ScaleX Div ScMult, 12* ScaleY Div ScMult)
   end;

   PrintControls(AForm, 0, 0); //20160407 Igor

   If FastPrint=True then
   begin
    Printer.NewPage;
   end;

   If FastPrint=False then
   begin
    Printer.EndDoc;
   end;
End;

Procedure AfterReadComponentForPrint(AForm:TFormFP_2027);
Var i:Integer;AImage:TImage;
CONST
  pxl = 96; //20160819 Igor
begin
   AImage:=Nil;
   If IsFormAClientLetter(AForm.FormName) then
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
      //20160819 Igor >>>
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
      //20160819 Igor <<<
    end;
     (*
     If (OptRec.Prn_Logo) and (AImage <> Nil) then
     begin
       If (FileExists(OptRec.LogoFile))  then
       begin
         AImage.Picture.LoadFromFile(OptRec.LogoFile);
         AImage.Visible:=True;
       end;
     end
     Else
     begin
       If AImage <> Nil then AImage.Visible:=False;
     end;
     *)
   end;
end;


Procedure PrintEditBox(RetNo: Integer; MyEditBox: TvtEdit; FName: String;
  FNo: Integer; hdc: THandle; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0);
Var FieldId:Integer; R:TRect;aString,s:String;FormattedAmount : string;
x,y:LongInt; PenWidth:Integer;AlignTopBottomVar,tempPos:Integer; MyEditHandle:THandle;
Begin
  FieldId:=GetFieldId(MyEditBox.Name);
  ACanvas.Font.Size := MyEditBox.Font.Size +MainOptions.Prn_FontIncr; //9; //10;
  R.Left   := MyEditBox.Left + ADLeft;
  R.Top    := MyEditBox.Top + ADTop;
  R.Right  := MyEditBox.Left + ADLeft + MyEditBox.Width;
  R.Bottom := MyEditBox.Top + ADTop + MyEditBox.Height;


  If LeftStr(Fname,5)='T4SUM' then
    ACanvas.Font.Name := 'Courier New'
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
                        Text := FormatAmount(Ret[RetNo].Frm[FNo].Strings[FieldId],2);
                        if leftstr(Text,2) = '0 'then Text := ' ' + midstr(Text, 3, 20);
                        if Vl(Text) = 0 then Text := '';
                        if leftstr(text,1) = ' ' then text := '0' + text;  //2005 to retain space and 0.78

                end
                else if vtInputType = vtSin then Text := reFormatSin(Ret[RetNo].Frm[FNo].Strings[FieldId])
                else Text := Ret[RetNo].Frm[FNo].Strings[FieldId];

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

                //add vertSeporator and paint prefix if vtDollar
                if vtinputType = vtDollar then
                begin
                       ACanvas.Textout(ScalePrX(R.Left),ScalePrY(AlignTopBottomVar),vtPrefix);

                       if vtVertSeparator = True then
                       begin
                          ACanvas.Pen.Width := 1;
                          if vtBorderType = vtDoubleUnderLine then
                          begin
                                ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') -1 , ScalePrY(R.Top) , ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2 , ScalePrY(R.Bottom) - 3);
                          end
                          else
                          begin
                                ACanvas.Rectangle(ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 1, ScalePrY(R.Top) , ScalePrX(R.Right) - ACanvas.TextWidth(' 00') - 2 , ScalePrY(R.Bottom));
                          end;
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
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) - 1 , ScalePrX(R.Right) , ScalePrY(R.Bottom));
                end
                else if MyEditBox.vtBorderType = vtDoubleUnderLine then
                begin
                     ACanvas.Pen.Width := MyEditBox.vtPenThickness;
                     ACanvas.Brush.Style := bsClear;
                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom) - 1  , ScalePrX(R.Right) , ScalePrY(R.Bottom));

                     ACanvas.Rectangle(ScalePrX(R.Left) , ScalePrY(R.Bottom)  - 3 , ScalePrX(R.Right) , ScalePrY(R.Bottom) - 2);
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

begin
  //First, get the size of a printed page in printer device units
  wPage := GetDeviceCaps(ACanvas.Handle, PHYSICALWIDTH);
  hPage := GetDeviceCaps(ACanvas.Handle, PHYSICALHEIGHT);
  //Next, get the device units per inch for the printer
  xPPI := GetDeviceCaps(ACanvas.Handle, LOGPIXELSX);
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


Procedure PrintMemo(RetNo:Integer;AMemo:TMemo;ACanvas:TCanvas);
Var i:Integer;ARichEdit:TRichEdit;
begin
 ARichEdit:=TRichEdit.Create(Application);
 ARichEdit.Parent:=Application.MainForm;
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


PROCEDURE PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
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
END; //PrintBitmap

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




end.
