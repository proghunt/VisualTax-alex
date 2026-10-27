unit FP_2027childwinnew;
(* see vtChild for documentation
*)

interface


uses SysUtils,WinTypes,WinProcs,Classes,Graphics,Forms,Controls,TabNotBk,
  StdCtrls,ExtCtrls,Tabs,Menus,Grids,Dialogs,ColorGrd,ClipBrd,FileCtrl,Gauges,
  Mask,DBCtrls,Printers,Messages,shellApi,MAPI,Buttons,ComCtrls,vtEditBox,
  vtLabel,vtShape,vtChild,vtForm,FP_2027HeaderFrame,
  FP_2027MonitorFrame,

  rxRichEd; //20160819 Igor (Must be last)

{20150730
uses Windows,Graphics,Forms,Controls,Buttons,ComCtrls,ExtCtrls,StdCtrls,Mask,
  Classes,Dialogs,Messages,FP_2027HeaderFrame,FP_2027MonitorFrame,vtEditBox,
  vtLabel,vtChild,vtShape;
}
type
  TFormFP_2027 = class(TvtScrollBox)
  private
    Function  CleanUpPickedListValue(FieldId:Integer;SelectedString:String):string;
    function  PopulatePickList(FieldId: Integer; SomeList: TStrings): String;
  protected
    procedure FormButtonClick(Sender: TObject); override;
    Procedure PopulateFormWithData; override;
    Procedure ShowRichData(ARichEdit:TRichEdit;Fld:Integer); override;
      //Procedure ShowInterpretedRichData(ARichEdit:TwwDbRichEdit;FName:String;FNo:Integer);
    //Procedure ShowFormData(FName:String;FNo:Integer); override;
    procedure ShowOther(cmp: TComponent); override;
    Function GetValueFromList(MyEditBox:TvtEdit;FieldId:Integer):String; override;
    procedure DataChangeRtn; override;
    procedure FormatDollar(MyEditBox: TvtEdit; str: string); override; //20150731
    function GetLinkedForm(FieldId: Integer; var TargetLinkedField: Integer): String; override;
    function IsProtectedField(MyEditBox: TvtEdit): boolean; override;
    function ValidateField(FieldId: integer; OldValue: string; var Value: string): boolean; override; //20260704 Alex
  public //overrides
    procedure OnVtEditDblClick(MyEditBox:TvtEdit); override;
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    Procedure PaintChart(TempImage:TImage);
  end;

  TMyChildFP_2027 = class(TMyChild)
  public
    procedure CloseActiveForm(Sender: TObject); override;
    procedure FormPaint(Sender: TObject);
    procedure Pg1Click(Sender: TObject); override;
  private
    FMyFormHeaderFrame: THeaderFrameFP_2027;
    FMyMonitorFrame: TMonitorFrameFP_2027;
    MyChild: boolean; //force errors
  {
    //set by getActiveTabsheet
     MyTabSheet:TTabSheet;
     MyScrollBox:TvtScrollBox;
  }
    procedure DeleteTabSheet(FName: String);
    procedure SectionBtnClick(Sender: TObject);
  protected //overrides
    procedure AddPropertiesAndEvents; override;
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    Procedure Keys(Var Key: Word; Shift: TShiftState); override;
    Procedure UpdateFormHeaderFrame(); override;
    procedure UpdateChildTaxPanel; override;
    function GetHeaderFrame: TFrame; override; //20160227 Igor
    function GetMonitorFrame: TFrame; override; //20160227 Igor
  public
    constructor CreateNew(AOwner: TComponent; RNo: Integer); override;
    property MyMonitorFrame:TMonitorFrameFP_2027 read FMyMonitorFrame;
    property MyFormHeaderFrame:THeaderFrameFP_2027 read FMyFormHeaderFrame;
  end;

//known to all
Function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;
Function GetDFMFileName(FName:String):String;
Function GetLastYearDFMFileName(FName:String):String; //20160321 Igor
Function GetReturnCaption(RetNo:Integer):String;
procedure OpenOtherImportantForms(RetNo: Integer);
//Function OpenOtherImportantForms(RetNo: Integer):Boolean;

Function InDateOnly(Value:string;MnYear,MxYear: integer):Boolean;
Function InDateYYYYMMDDonly(Value:string;MxYear: integer):Boolean;
Function SubstituteLastYearForm(FName: String): String; //20160704 Igor

var
 RetNo: boolean;  //Integer; - force compiler errors

implementation

{.$R *.DFM}

uses TypInfo,
  vtMulti,vtMain,vtCommon,vtDialogs,vtRichText,
  FP_2027,FP_2027Declare,
  FP_2027Common,FP_2027Common2,FP_2027TrimStr,FP_2027Calc,FP_2027PopComboList,
  FP_2027SaveAs,
  FP_2027CntErr,FP_2027SearchList,
  FP_2027main,FP_2027Print,
  FP_2027EditRich, //20150731
  vtTrimStr,vtShared;

var //force compiler errors
  MyChild: boolean;

procedure TFormFP_2027.PopulateFormWithData;
begin
  //20170409 Igor >>>
  if isCollectionForm(FormName) then
    FP_2027.Calc(RetNo, FormName);
  //20170409 Igor <<<
  If IsFormAClientLetter(FormName) then Color:=clWhite;
  inherited;
end;

procedure TFormFP_2027.ShowOther(cmp: TComponent);
begin
(* extracted from PopulateForm
*)
  if cmp is TImage then
  begin
   //AnImage:=MyScrollBox.Components[j] as TImage;
   PaintChart(TImage(cmp));
  end; //TImage
end;

Procedure TFormFP_2027.PaintChart(TempImage:TImage);
var
  YearOrAge:Boolean;
  TempBitMap:TBitMap;
  R: TRect;
begin
       R.Left:=0;
       R.Top:=0;
       R.Bottom:=TempImage.Height;
       R.Right:=TempImage.Width;

       TempBitMap := TBitMap.Create;
       TempBitMap.Width := TempImage.Width;
       TempBitMap.Height :=TempImage.Height;
       TempBitMap.Canvas.Pen.Width := 1;
       TempBitMap.Canvas.Brush.Color := clBtnShadow;

       YearOrAge:=False;
  try
       If FormName='PROJECTIONCHARTS' then
       begin
        If FetchElm(RetNo,'PROJECTIONCHARTS',4)>'' then YearOrAge:=True;
       end;

       If UpperCase(TempImage.Name)='INCOMECHART' then
       begin
         ChartIncome(RetNo,TempBitMap,R,YearOrAge,CashFlowProjectionList);
         TempImage.Picture.assign(TempBitMap);
       end
       Else If UpperCase(TempImage.Name)='NONSHCHART' then
       begin
         ChartStream(RetNo,'PNONSH',TempBitMap,R,YearOrAge);
         TempImage.Picture.assign(TempBitMap);
       end
       Else If UpperCase(TempImage.Name)='SHELTCHART' then
       begin
         ChartStream(RetNo,'PSHELT',TempBitMap,R,YearOrAge);
         TempImage.Picture.assign(TempBitMap);
       end
       Else If UpperCase(TempImage.Name)='SEMSHCHART' then
       begin
         ChartStream(RetNo,'PSEMSH',TempBitMap,R,YearOrAge);
         TempImage.Picture.assign(TempBitMap);
       end
      Else If UpperCase(TempImage.Name)='OTHERCHART' then
      begin
         ChartStream(RetNo,'POTHER',TempBitMap,R,YearOrAge);
         TempImage.Picture.assign(TempBitMap);
      end
      Else If UpperCase(TempImage.Name)='TOTALINVESTMENTSCHART' then
      begin
         ChartTotBalance(RetNo,TempBitMap,R,YearOrAge);
         TempImage.Picture.assign(TempBitMap);
      end
      Else If UpperCase(TempImage.Name)='ASSETSCHART' then
      begin
         ChartStream(RetNo,'PASSETS',TempBitMap,R,YearOrAge);
         TempImage.Picture.assign(TempBitMap);
      end
      Else If UpperCase(TempImage.Name)='LIABILITIESCHART' then
      begin
         BuildLiabilitiesProjection(RetNo);
         ChartLiabilities(RetNo,TempBitMap,R,YearOrAge,LiabilitiesProjectionList);
         TempImage.Picture.assign(TempBitMap);
      end
      Else If UpperCase(TempImage.Name)='NETWORTHCHART' then
      begin
         BuildNetWorthProjection(RetNo);
         ChartNetWorth(RetNo,TempBitMap,R,YearOrAge,NetWorthProjectionList);
         TempImage.Picture.assign(TempBitMap);
      end
      Else If UpperCase(TempImage.Name)='CASHFLCHART' then
      begin
         BuildCashFlowProjection(RetNo);
         ChartCashFl(RetNo,TempBitMap,R,YearOrAge,CashFlowProjectionList);
         TempImage.Picture.assign(TempBitMap);
      end
      Else If UpperCase(TempImage.Name)='BUSINESSCHART' then
      begin
         ChartBusiness(RetNo,TempBitMap,R,YearOrAge,BusinessProjectionList);
         TempImage.Picture.assign(TempBitMap);
      end
      Else If UpperCase(TempImage.Name)='FIXEDASSETSCHART' then
      begin
        BuildFixedAssetsProjection(RetNo);
        ChartFixedAssets(RetNo,TempBitMap,R,YearOrAge,FixedAssetsProjectionList);
        TempImage.Picture.assign(TempBitMap);
      end;
  finally
      TempBitMap.Free;
  end;
end;

procedure TMyChildFP_2027.addPropertiesAndEvents;
begin
  inherited;
 VertScrollBar.Tracking := True;
 HorzScrollBar.Tracking := True;
 VertScrollBar.Position:=0;
 KeyPreview:=True;
 OnKeyDown := FormKeyDown;
 OnKeyPress := FormKeyPress;
//install for use by vtScrollBox
  PopupMenu := MainFormFP.FormPopup;
  OnContextPopup := FormContextPopup;
end;

procedure OpenOtherImportantForms(RetNo: Integer);
//Function OpenOtherImportantForms(RetNo: Integer):Boolean;
begin
 LockWindowUpdate(Application.MainForm.Handle);

 OpenForm(RetNo,GetFormNo('NETWORTH'),0);
// OpenForm(RetNo,GetFormNo('ASSETSUM'),0);
// OpenForm(RetNo,GetFormNo('LIABSUM'),0);
 OpenForm(RetNo,GetFormNo('LIVINGEXP_1'),0);
 OpenForm(RetNo,GetFormNo('CASHFLOW'),0);
 OpenForm(RetNo,GetFormNo('INVESTSTRATEGY'),0);  //20190303
 OpenForm(RetNo,GetFormNo('INCPROJECTION'),0);
 OpenForm(RetNo,GetFormNo('LIFEEVENTS'),0);
 OpenForm(RetNo,GetFormNo('RETPLAN'),0);
 OpenForm(RetNo,GetFormNo('PROJECTIONCHARTS'),0);
// OpenForm(RetNo,GetFormNo('EXECSUM'),0);   //20130203
 OpenForm(RetNo,GetFormNo('PROFILE'),0);
 LockWindowUpdate(0);
end;


Function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;
//Function OpenForm(RetNo: Integer;FNo: integer;Elm:Integer): boolean;
Var
  DfmFileName:String absolute Result;
begin
  Result := '';
  If (RetNo < 1)
{$IFDEF ReturnsLimit}
  or (RetNo > ReturnsLimit)
{$ELSE}
{$ENDIF}
  then exit;

  //20160704 Igor >>>
  if FNo = 0 then
  begin
    If RetList[Retno].IsLastYearReturn = false then
      FNo:=GetFormNo(FName)
    Else
      FNo:=GetLastYearFormNo(FName);
  end
  else
  begin
    If RetList[Retno].IsLastYearReturn = false then
      FName:=GetFormName(FNo)
    else
      FName:=GetLastYearFormName(FNo);
  end;
//  If FNo = 0 then begin
//   //Result := False;
//   ShowMessage('Form No '+IntToStr(FNo)+' not found');
//   exit;
//  end;
  //20160704 Igor <<<

  If FormAllowed(FName) then
  //ok
  else
  begin
    ShowMessage('This form is available in the more advanced versions of the program');
    Exit;
  End;

  //If IsDelphiForm(FNo)='Y' then
  If IsDelphiForm(FNo) then
  begin
   MainFormFP.OpenDelphiForm(RetNo,FName);
   Exit;
  end;

 Try
  //20160704 Igor >>>
  //DfmFileName:=GetDfmFileName(FName);
  If ShowUnconvertedLastYear(RetNo) = False then
    DfmFileName:=GetDfmFileName(FName)
  else
    DfmFileName:=GetLastYearDfmFileName(FName);
  //20160704 Igor <<<
  If FileExists(DfmFileName) = False then
  begin
   ShowMessage('Form '+FName+' not found');
   Exit;
  End;
 Except
 ShowTimedMsg('Form could not be opened. Close it and try another form',1200);
 end;
end;

procedure TFormFP_2027.FormButtonClick(Sender: TObject);
Var Nm:String;ToRetNo,FromRetNo:Integer;
  //ARichEdit:TwwDbRichEdit;
  ToFInst:String;
begin
 Nm:=UpperCase((Sender as TbitBtn).Name);  //button name

 If GetFormType(FormName)='DA' then  //detail Assets
 begin
  OpenForm(RetNo,GetFormNo(Nm+'#1'),0);
 end;

 If FormName='PROFILE' then
 begin
  If Nm='IMPORTT1BTN' then
   begin
     MainFormFP.ImportTaxData1Click(Application);
     Exit;
   end;
 end;

 If FormName='PROJECTIONCHARTS' then
 begin
  If Nm='INCOMECHARTBTN' then begin OpenForm(RetNo,GetFormNo('INCPROJECTION'),0); Exit;end;
  If Nm='NONSHCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PNONSH#1'),0); Exit;end;
  If Nm='SHELTCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PSHELT#1'),0); Exit;end;
  If Nm='SEMSHCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PSEMSH#1'),0); Exit;end;
  If Nm='OTHERCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PNETW#1'),0); Exit;end;
  If Nm='FIXEDASSETSCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PNETW#1'),0); Exit;end;
  If Nm='BUSINESSCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PNETW#1'),0); Exit;end;
  If Nm='LIABILITIESCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PLIAB#1'),0); Exit;end;
  If Nm='NETWORTHCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PNETW#1'),0); Exit;end;
  If Nm='CASHFLCHARTBTN' then begin OpenForm(RetNo,GetFormNo('PCASHFLOW#1'),0); Exit;end;
 end;

 If FormName='CASHFLOW' then
 begin
  If Nm='INVESTSTRATEGYBTN' then
   begin
    OpenForm(RetNo,GetFormNo('INVESTSTRATEGY'),0);
    Exit;
   end;
  If Nm='PCASHFLOWBTN' then
   begin
    OpenForm(RetNo,GetFormNo('PCASHFLOW#1'),0);
    Exit;
   end;
 end;

 If FormName='LIFEEVENTS' then
 begin
  If Nm='PNONSHBTN' then
   begin
    OpenForm(RetNo,GetFormNo('PNONSH#1'),0);
    Exit;
   end;
  If Nm='PSHELTBTN' then
   begin
    OpenForm(RetNo,GetFormNo('PSHELT#1'),0);
    Exit;
   end;

   If Nm='PSEMSHBTN' then
   begin
    OpenForm(RetNo,GetFormNo('PSEMSH#1'),0);
    Exit;
   end;
 end;


 If FormName='NETWORTH' then
 begin
  If Nm='PNETWBTN' then
   begin
    OpenForm(RetNo,GetFormNo('PNETW#1'),0);
    Exit;
   end;
 end;


 If FormName='INSNEED' then
 begin
  If Nm='PROBATEBTN' then
   begin
     MainFormFP.ProbateFeesCalculator1Click(Application);
     Exit;
   end;
 end;


 If FormName='INCPROJECTION' then
 begin
  If Nm='INITFROMCASHFLOWBTN' then
   begin
     InitIncProjectionFromCashFlow(RetNo);
     OpenForm(RetNo,GetFormNo(FormName),1);
     Exit;
   end;

  If Nm='PCASHFLOWBTN' then
   begin
     OpenForm(RetNo,GetFormNo('PCASHFLOW#1'),0);
     Exit;
   end;

 end;

 If LeftStr(FormName,10)='PORTFOLIO#' then
 begin
  If Nm='SAVEMODELPORTFOLIOBTN' then
   begin
     SaveModelPortfolio(RetNo);
     ShowTimedMsg('Done',1200);
     Exit;
   end;

  If Nm='IMPORTMODELPORTFOLIOBTN' then
  begin
     ToRetNo:=RetNo;
     ToFInst:=ExtractFormInst(FormName);
     ImportModelPortfolio(ToRetNo,FormName);
     Exit;
  end;
 end;

 If IsFormAClientLetter(FormName) then
 begin
  If Nm='LETTERDESIGNBTN' then
  begin
   MainFormFP.ClientLetter1Click(Sender);
   OpenForm(RetNo,GetFormNo(FormName),1);
  end;
  If Nm='PRINTLETTERBTN' then MainFormFP.CurrentPage1Click(Sender);
  If Nm='EDITFINISHEDLETTERBTN' then
  begin
    MyChild.CloseActiveForm(Sender); //FormCloseQuery(Sender,True);
    LetterName:=GetLetterFileName(RetNo,FormName);
    EditRich(RetNo, LetterName); //does abvoe
  end;
end;

end;


Function GetDFMFileName(FName:String):String;
Var FormsDir:String;
begin
 FormsDir:= GetDfmFormsDir;
 Result:= FormsDir+'\'+'u'+ExtractNonInstFormName(FName)+'.DFM';
end;

Function GetLastYearDFMFileName(FName:String):String; //20160321 Igor
Var
  FormsDir:String;
begin
  Result:='';
  FormsDir:=OptRec.Dir_PgmLastYr;
  if FormsDir = '' then exit;
  FName := ExtractNonInstFormName(FName);
  Result:= FormsDir+'\'+'u'+FName+'.DFM';
end;

Function TFormFP_2027.ValidateField(FieldId: integer; OldValue: string; Var Value : string):boolean; //20260704 Alex
Var I : integer;SelectedString :string;
begin
 Result := True;
 If FormName = 'PROFILE' then
 begin
   case FieldId of
    27,29: {birth dates}
    begin
     If value>'' then
      begin
        AutoFormatDate(Value);
        Result:= InDateOnly(Value,1900,AppYearInt+1);
        exit;
      end;
    end;
   end; {Case}

   i:=45;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1900,AppYearInt+1);
     exit;
    end;
    Inc(i,4);
   until i>77;
 end


 Else If LeftStr(FormName,4) = 'CSB#' then
 begin
   i:=10;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,15);
   until i>445;
 end

 Else If LeftStr(FormName,4) = 'GIC#' then
 begin
   i:=10;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,15);
   until i>445;
 end

 Else If LeftStr(FormName,6) = 'BONDS#' then
 begin
   i:=10;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,15);
   until i>445;
 end

 Else If LeftStr(FormName,6) = 'LOANS#' then
 begin
   i:=4;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,10);
   until i>294;
 end

 Else If LeftStr(FormName,8) = 'TERMDEP#' then
 begin
   i:=11;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,15);
   until i>416;
 end

 Else If LeftStr(FormName,12) = 'UNPAIDBILLS#' then
 begin
   i:=4;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,7);
   until i>207;
 end

 Else If LeftStr(FormName,8) = 'BANKADV#' then
 begin
   i:=4;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,8);
   until i>156;
 end

 Else If LeftStr(FormName,11) = 'TAXPAYABLE#' then
 begin
   i:=7;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,9);
   until i>178;
 end

 Else If LeftStr(FormName,9) = 'CARLOANS#' then
 begin
   i:=8;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,12);
   until i>356;
 end

 Else If LeftStr(FormName,10) = 'MORTGAGES#' then
 begin
   i:=7;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,12);
   until i>259;

   i:=8;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,12);
   until i>260;
 end

 Else If LeftStr(FormName,9) = 'OTHERLTL#' then
 begin
   i:=8;
   Repeat
    If (i=FieldId) and (value>'') then
    begin
     AutoFormatDate(Value);
     Result:= InDateOnly(Value,1999,AppYearInt+100);
     exit;
    end;
    Inc(i,11);
   until i>327;
 end;
End;

Function InDateYYYYMMDDonly(Value:string;MxYear: integer):Boolean;
begin
  Result := InDateYMDonly(Value,1880,MxYear,'-');
end;

function TFormFP_2027.IsProtectedField(MyEditBox: TvtEdit): boolean;
begin
  Result := (MyEditBox.vtDataSource=vtCalc)
  or ((FormName='INV_2') and (IsInvoiceLocked(RetNo)) and (MyEditBox.FieldId <> 85))
end;

constructor TMyChildFP_2027.CreateNew(AOwner: TComponent; RNo: Integer);
var
  j: Integer; //20160519 Igor
begin
  inherited;
  FormClass := TFormFP_2027;
 Caption:= GetReturnCaption(RetNo);
 Color:=GetRetColor(RetNo); //$00AC7400; //GetRetColor(RetNo);
 Name:='R'+IntToStr(RetNo);

 FMyFormHeaderFrame := THeaderFrameFP_2027.Create(self);
 with MyFormHeaderFrame do
 begin
  MyChild := self;
  Name:='P2';
  Parent:=self; //MyChild; //MyPageControl;
  Height:=25; //30;
  Align:=alTop;
  Color:=$00AC7400; //GetRetColor(RetNo);  //$00AC7400;
  //20160519 Igor >>>
  ParentBackGround := False;
  for J := 0 to ComponentCount - 1 do
  Begin
    if Components[j] is TPanel then
      (Components[j] as TPanel).ParentBackground := False;
  End;
  //20160519 Igor <<<
  //ReturnNameLbl.Caption := '[Un-Named]';
 end;
 MyFormHeaderFrame.Pg1.onClick := Pg1Click;
 MyFormHeaderFrame.Pg2.onClick := Pg1Click;
 MyFormHeaderFrame.Pg3.onClick := Pg1Click;
 MyFormHeaderFrame.Pg4.onClick := Pg1Click;
 MyFormHeaderFrame.Pg5.onClick := Pg1Click;
 MyFormHeaderFrame.Pg6.onClick := Pg1Click;
 MyFormHeaderFrame.Pg7.onClick := Pg1Click;
 MyFormHeaderFrame.Pg8.onClick := Pg1Click;
 MyFormHeaderFrame.Pg9.onClick := Pg1Click;
 MyFormHeaderFrame.Pg10.onClick := Pg1Click;
 MyFormHeaderFrame.CloseTabBtn.OnClick := CloseActiveForm;
 MyFormHeaderFrame.SectionBtn.OnClick := SectionBtnClick;

 FMyMonitorFrame := TMonitorFrameFP_2027.Create(self);
 With MyMonitorFrame do
 begin
  Parent:=self;
  Height:=23;
  //Width:=MyChild.Width;
  Align:=alBottom;

  //20160519 Igor >>>
  ParentBackGround := False;
  for J := 0 to ComponentCount - 1 do
  Begin
    if Components[j] is TPanel then
      (Components[j] as TPanel).ParentBackground := False;
  End;
  //20160519 Igor <<<
 end;
 UpdateChildTaxPanel;
end;

procedure TMyChildFP_2027.FormPaint(Sender: TObject);
begin
  Caption:=GetReturnCaption(RetNo);
end;

function TMyChildFP_2027.GetHeaderFrame: TFrame; //20160227 Igor
begin
  Result := MyFormHeaderFrame;
end;

function TMyChildFP_2027.GetMonitorFrame: TFrame; //20160227 Igor
begin
  Result := MyMonitorFrame;
end;

procedure TMyChildFP_2027.UpdateChildTaxPanel;
begin
    FormatSettings.DecimalSeparator :='.'; //20150818 igor
    MyMonitorFrame.AssetsPanel.Caption  := 'Assets: $'+FormatFloat('##,###,##0',Vl(FetchElm(RetNo,'NETWORTH',52)));
    MyMonitorFrame.LiabilitiesPanel.Caption :='Liabilities: $'+ FormatFloat('##,###,##0',Vl(FetchElm(RetNo,'NETWORTH',72)));
    MyMonitorFrame.NetWorthPanel.Caption := 'Net Worth: $'+ FormatFloat('##,###,##0',Vl(FetchElm(RetNo,'NETWORTH',65)));
    MyMonitorFrame.DisposableIncomePanel.Caption := 'Cash Flow: $'+FormatFloat('##,###,##0',Vl(FetchElm(RetNo,'CASHFLOW',73)));
end;

Procedure TMyChildFP_2027.Keys(Var Key: Word; Shift: TShiftState);
var
  Handled: boolean;
begin
  Handled := False;
  if Shift = [] then //Ctrl etc. in ShortCuts!
  begin
   {PLAIN F KEYS}
    Handled := True;
    {F1, F2 are in short cut}
   // If    (Key = VK_F1) then begin MainForm.HelpBtnClick(Application);exit;end;
   // If    (Key = VK_F2) then begin MainForm.SelectFormClick(Application);exit;end;
    If    (Key = VK_F3) then MainFormFP.FileSaveAsItemClick(Application)
    else If    (Key = VK_F4) then OpenForm(RetNo,GetFormNo('TAXSUM'),0)
    else If    (Key = VK_F5) then MainForm.GuiCommand(gcToggleLeftPanel)
    else If    (Key = VK_F7) then MainFormFP.Switchforms1Click(Application)
    else If    (Key = VK_F8) then MainFormFP.SwapBtnClick(Application)
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end;

  {CTRL 1 to 8}
  if (Shift = [ssCtrl]) then
  begin
    Handled := True;
    if      (Key = 49) then OpenForm(RetNo,GetFormNo('S1_1'),0)
    else if (Key = 50) then OpenForm(RetNo,GetFormNo('S2_1'),0)
    else if (Key = 51) then OpenForm(RetNo,GetFormNo('S3_1'),0)
    else if (Key = 52) then OpenForm(RetNo,GetFormNo('S4_1'),0)
    else if (Key = 53) then OpenForm(RetNo,GetFormNo('S5_1'),0)
    else if (Key = 54) then OpenForm(RetNo,GetFormNo('S6_1'),0)
    else if (Key = 55) then OpenForm(RetNo,GetFormNo('S7_1'),0)
    else if (Key = 56) then OpenForm(RetNo,GetFormNo('S8#1'),0)
    else if (Key = 57) then OpenForm(RetNo,GetFormNo('S9'),0)
    else if (Key = 89) then OpenForm(RetNo,GetFormNo('COMPSUM'),0) //Ctrl Y
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end; {Ctrl}

  //ALT KEYS
  If Shift = [ssAlt] then
  begin
    Handled := True;
    If Key = 83 then MainFormFP.SwapReturns1Click(Application) {Alt S}
    else if Key = 88 then MainFormFP.FileCloseItemClick(Application) {Alt x}
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end; {Alt keys}

  inherited;
end;

procedure TMyChildFP_2027.Pg1Click(Sender: TObject);
Var
 i,FNo:Integer;
begin
 FNo :=GetFormNo(ExtractFormRootName(FormName)+'_'
                +IntToStr(TPanel(sender).Tag)
                +ExtractFormInst(FormName));
 OpenForm(GetCurrentRetNo,FNo,0);
end;

Procedure TMyChildFP_2027.UpdateFormHeaderFrame;
var
 FormInfo:String;
  vis: boolean;
begin
 if not UpdateSectionButtons(MyFormHeaderFrame) then exit;
 FormInfo:=AllTrim(GetFormAbrevName(FormNo));
 MyFormHeaderFrame.FormNameLbl.Caption:=' '+FormInfo;
 vis := IsFormMultiInst(FormName)
                  and (LeftStr(FormName,6) <> 'FLDMEM')
                  and (LeftStr(FormName,7) <> 'FLDTAPE');
 MyFormHeaderFrame.ListMultipleBtn.Enabled := vis;
 MyFormHeaderFrame.MultipleDnBtn.Enabled := vis;
 MyFormHeaderFrame.MultipleUpBtn.Enabled := vis;
 //MyFormHeaderFrame.SectionBtn.visible:=(IsFormMultipage(FormName));
 MyFormHeaderFrame.CloseTabBtn.Visible := True
end;

procedure TMyChildFP_2027.CloseActiveForm(Sender: TObject);
Var j:Integer;
begin
  j:=MyPageControl.ActivePageIndex;
  MyTabSheet:=MyPageControl.Pages[j];

  If MyTabSheet.Caption = 'PROFILE' then
  begin
   ShowMessage('You cannot close the Profile'
    +Chr(13)+'You can close the client file instead');
   Exit;
  end;
  inherited;
end;

procedure TMyChildFP_2027.SectionBtnClick(Sender: TObject);
begin
  GoToSection();
end;


Function TFormFP_2027.GetValueFromList(MyEditBox:TvtEdit;FieldId:Integer):String;
Var I : integer;TempList:TStringList;FromFname:String;FromElm:Integer;
   s,TempString:String;
begin
 //populate the picklist
  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Valid entries';
  Result:=PopulatePickList(FieldId,Somelist);
  if Result = '' then
  begin
    SelectedString := PopSomeList(SomeList,SomeCaption,MyEditBox);
    result:=CleanUpPickedListValue(FieldId,SelectedString);
  end;
  SelectedString:=Result;  //??
end;

Function TFormFP_2027.GetLinkedForm(FieldId:Integer;Var TargetLinkedField:Integer):String;
Var
  I, j, Fld: integer;
  Frm, InFrm: string; //[10];
  LinkList: TstringList;
  Wlist: TStringList;
  s: String;
begin
  Result := '';
  TargetLinkedField:=0;
  LinkList := TStringList.Create;
  //20170515 Igor >>>
  try
  //20170515 Igor <<<
    Linklist.LoadFromFile(Appdir+'\'+'LINKLIST.D');
    InFrm := Rtrim(ExtractNonInstFormName(FormName));

    //multiple linked forms
    WList:=TStringList.Create;
    //20170515 Iogr >>>
    try
    //20170515 Igor <<<
      For i :=0 to LinkList.Count -1 do
      begin
        Frm := RTrim(ExtractNonInstFormName(LeftStr(LinkList[i],20)));
        If InFrm = Frm then
        begin
          Fld := MyStrToInt(MidStr(LinkList[i],22,3));
          If Fld = FieldId then
          begin
            s:=AllTrim(MidStr(LinkList[i],26,80));
            ParseWords(S,',',WList);
            If Wlist.Count=1 then  {just one linked form}
            begin
              //wordformat is fffffff#n/5
              If ExtractFormInst(Rtrim(InFrm)) > '' then
                Result :=ExtractFormSlashField(WList[0],TargetLinkedField)+ExtractFormInst(Rtrim(FormName))
                     //Rtrim(ExtractNonInstFormName(LeftStr(WList[0],10)))
              else
                Result :=ExtractFormSlashField(WList[0],TargetLinkedField);
              //20170515 Igor >>>
              //LinkList.Free;
              //WList.Free;
              //20170515 Igor <<<
              exit;
            end //end single link
            Else
            If Wlist.Count>1 then
            begin
              SomeList.Clear;  // := TStringList.Create;
              SomeCaption := 'Select from Linked forms';
              For j:=0 to WList.Count-1 do
                SomeList.Add(PaddR(WList[j],20)); //+GetFormAbrevNameWithNoInst(GetFormNo(WList[j])));
              SelectedString := PopSomeList(SomeList,SomeCaption);
              //SomeList.Free;
              If SelectedString > '' then
              begin
                Result:=AllTrim(LeftStr(SelectedString,20));
                //20170515 Igor >>>
                //LinkList.Free;
                //WList.Free;
                //20170515 Igor <<<
                exit;
              end;
            end;
          end; //matching fieldid
        end; //found entry
      end;
    //20170515 Igor >>>
    finally
      WList.Free;
    end;
    //20170515 igor <<<
    //nothing found
    UserMsg('nothing linked to '+InFrm+'.vtEdit'+IntToStr(FieldId));
  //20170515 igor >>>
  finally
    LinkList.Free;
  end;
  //20170515 Igor <<<
end;


Function TFormFP_2027.PopulatePickList(FieldId:Integer;SomeList:TStrings):String;
Var i:Integer;s,FromFname:String;FromElm:Integer;
begin
  Result:='';
  If (FormName = 'PROFILE') then
  case FieldId of
      99: for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
      // 17,33,45: Somelist.LoadFromFile(AppDir+'\'+'State.d');
      // 19,34,46:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
      // 50:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
  end;


  If (FormName = 'LIFEEVENTS') then
  begin
   i:=6;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('W');
      SomeList.Add('C');
    end;
    Inc(i,9);
   until i>159;
  end;


  If (LeftStr(FormName,10) = 'PORTFOLIO#') then
  case FieldId of
      1:
      begin
       SomeList.Add('RRSP');
       SomeList.Add('BALANCED');
       SomeList.Add('AGGRESSIVE');
      end;
      6,16,26,36,46,56,66,76,86,96,106,116,126,136,146,156,166,176,186,
       196,206,216,226,236,246,256,266,276,286,296:
      begin
       SomeList.Add('MutualFunds');
       SomeList.Add('Stocks');
       SomeList.Add('Bonds');
       SomeList.Add('GIC');
      end;
      8:
       begin
        SomeList.Add('TSX');
        SomeList.Add('Stocks');
        SomeList.Add('Bonds');
        SomeList.Add('GIC');
       end;
  end;

  If (LeftStr(FormName,4) = 'CSB#') then
  begin
   i:=12;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('NONSH');
      SomeList.Add('SHELT');
    end;
    Inc(i,15);
   until i>447;
  end;
  If (LeftStr(FormName,4) = 'GIC#') then
  begin
   i:=12;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('NONSH');
      SomeList.Add('SHELT');
    end;
    Inc(i,15);
   until i>447;
  end;

  If (LeftStr(FormName,6) = 'BONDS#') then
  begin
   i:=12;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('NONSH');
      SomeList.Add('SHELT');
    end;
    Inc(i,15);
   until i>447;
  end;

  If (LeftStr(FormName,8) = 'TERMDEP#') then
  begin
   i:=13;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('NONSH');
      SomeList.Add('SHELT');
    end;
    Inc(i,15);
   until i>418;
  end;

  If (LeftStr(FormName,9) = 'MUTFUNDS#') then
  begin
   i:=13;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('NONSH');
      SomeList.Add('SHELT');
      SomeList.Add('SEMSH');
    end;
    Inc(i,18);
   until i>499;
  end;

  If (LeftStr(FormName,7) = 'STOCKS#') then
  begin
   i:=12;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('NONSH');
      SomeList.Add('SHELT');
      SomeList.Add('SEMSH');
    end;
    Inc(i,16);
   until i>476;
  end;

  If (LeftStr(FormName,9) = 'DEFPLANS#') then
  begin
   i:=8;
   Repeat
    If FieldId=i then
    begin
      SomeList.Add('SHELT');
      SomeList.Add('NONSH');
    end;
    Inc(i,11);
   until i>327;
  end;

End;

Function TFormFP_2027.CleanUpPickedListValue(FieldId:Integer;SelectedString:String):string;
Begin
  Result := SelectedString;

    {limit the size of returned string}

  If (LeftStr(FormName,3) = 'S8#')
  or (LeftStr(FormName,7) = 'S8FREE#')
  or (LeftStr(FormName,4) = 'OS8#')
  or (LeftStr(FormName,5) = 'AS13#') then
    Result := LeftStr(Result,4);

  If FormName = 'S5_1' then Result := LeftStr(Result,3);

  If FormName = 'T106' then result:=LeftStr(Result,3);

  If LeftStr(FormName,7) = 'T106SL#' then
  begin
    Case FieldId of
     13:Result := LeftStr(Result,2);
     19,20,21,22: result:=LeftStr(Result,3);
     24,25,26,27: result:=LeftStr(Result,3);
     else Result := LeftStr(Result,1);
    end; //case
  end;

  If FormName = 'S9' then
  begin
   Case FieldId of
   5,14,23,32,41,50,59,68,77,86,95,104,113,122,131:Result := LeftStr(Result,2);
   7,16,25,34,43,52,61,70,79,88,97,106,115,124,133:Result := LeftStr(Result,1);
   end; {case}
  end;

  If FormName = 'PAGE_8' then  Result := LeftStr(Result,1);
  If FormName = 'S3_1' then  Result := LeftStr(Result,1);
  If FormName = 'S11' then  Result := LeftStr(Result,1);
  If FormName = 'S23' then  Result := LeftStr(Result,1);
  If FormName = 'S25' then  Result := LeftStr(Result,1);
  If FormName = 'S49' then  Result := LeftStr(Result,1);

  If (FormName = 'S6RE')
  or (FormName = 'S12_6')
  or (FormName = 'S12_7')
  or (FormName = 'S14')
  or (FormName = 'S15')
  or (FormName = 'S21_1')
  or (FormName = 'S22')
  or (FormName = 'S29')
  or (FormName = 'S80_2')
  or (FormName = 'S81_1')
  or (FormName = 'S81_2')
  or (FormName = 'S91_1')
  or (FormName = 'S97')
  or (FormName = 'OPG_2')
  then
   Result := LeftStr(Result,2);

  If (FormName = 'AT1_1') then
  begin
   If FieldId=58 then result:=LeftStr(Result,4) else result:=LeftStr(Result,2);
  end;

  If (FormName = 'OPG_18')
  or (FormName = 'OPG_19')
  or (LeftStr(FormName,6) = 'OMCCRA')then
  begin
   Case FieldId of
    10,56,11,57: Result := LeftStr(Result,2);
   end;
  end;

  If FormName = 'OS114_1' then
  begin
   Case FieldId of
     3,16,29:
     Begin
      StoreElm(RetNo,GetFormNo(FormName),FieldId+1,MidStr(result,6,50));
      Result := LeftStr(Result,4);
     end;
   end;
  end;

  If (LeftStr(FormName,7) = 'OS114S#') then
  begin
   Case FieldId of
     3,16,29:
     Begin
      StoreElm(RetNo,GetFormNo(FormName),FieldId+1,MidStr(result,6,50));
      Result := LeftStr(Result,4);
     end;
   end;
  end;

  If (FormName = 'OADDR') then
  begin
   Case FieldId of
    10,11: Result := LeftStr(Result,2);
   end;
  end;

end;

procedure TMyChildFP_2027.FormContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  //nop
end;

procedure TFormFP_2027.FormatDollar(MyEditBox: TvtEdit; str: string);
var
  HowToFormat:Integer;
begin
  FormatSettings.DecimalSeparator := ' ';  //20150818 igor
  HowToFormat :=GetHowToFormat(FormName,MyEditBox.FieldId);
  If Vl(str) = 0 then
    MyEditBox.Text:='0'
  else
    MyEditBox.Text:=FormatAmount(str,HowToFormat);
end;


procedure TFormFP_2027.EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
  If Button = mbLeft then
  begin
    inherited;
  End  //MbLeft
  else
  If Button = mbRight then
  begin
  with MainFormFP do
  begin
//configure menu
//show menu
    FieldPopup.PopupComponent := MyEditBox;
  //pos must be in screen coordinates
    FieldPopup.Popup(mouse.CursorPos.x, mouse.CursorPos.y);
  end; //with
 end;  {mbright}
end;

procedure TFormFP_2027.OnVtEditDblClick(MyEditBox: TvtEdit);
Var
  FName:string;
  NewString: String;
  FieldId,TargetLinkedField:Integer;
  P: TWinControl; //20160805 Igor
begin
  FieldId:=MyEditBox.FieldId;

  //20160710 Igor
  if MyEditBox.ReadOnly then exit;
  if not assigned(RetList[RetNo]) then exit;
  if RetList[RetNo].isLastYearReturn or
     RetList[RetNo].isAppendix then exit;

  if MyEditBox.vtDataSource = vtLinked then
  begin
   FName :=GetLinkedForm(FieldId,TargetLinkedField);
   //20170731 Igor >>>
   //if linkToSelf(FormName,FName)then
   //begin
   // ShowTimedMsg('Hit the Spacebar to link',1200);
   // exit;
   //end;
   //20170731 Igor <<<
   If FName > '' then
   begin
    OpenForm(RetNo,GetFormNo(Fname),TargetLinkedField);
    exit;
   end;
   //Exit;
  end;

  if MyEditBox.vtDataSource = vtPopupList then   //pick boxes
  begin
   GetValueFromList(MyEditBox,FieldId);
   //GetValueFromPopUp(MyScrollBox,MyEditBox,FormName,FieldId);
   If SelectedString >'' then
   begin
     If IsReturnLocked(RetNo) = False then
     Begin
      MyEditBox.Text := SelectedString;
      SaveEditBoxText(FieldId,MyEditBox.Text);
      //20160805 Igor >>>
      UpdateAfterSave;
      P := Self.Parent;
      while Assigned(P) AND not(P is TForm) do
        P := P.Parent;
      if assigned(P) then
        PostMessage(P.Handle, WM_NEXTDLGCTL, 0, 0)
      else
        PostMessage(Self.Handle, WM_NEXTDLGCTL, 0, 0)
      //20160805 Igor <<<
     end
     Else
      ShowTimedMsg('Changes not allowed. File is locked',1500);
     Exit;
   end;
  End;
end;

Procedure TMyChildFP_2027.DeleteTabSheet(FName:String);
Var
  i:Integer;MyTabSheet:TTabSheet;
begin
  //LockWindowUpdate(MyPageControl.Handle);     //does not help
  For i:=0 to MyPageControl.PageCount-1 do
  begin
   MyTabSheet:=MyPageControl.Pages[i];
   If MyTabSheet.Caption = FName then
   Begin
    MyTabSheet.Free;  //removes the tabsheet
    Exit;
   end;
  end;
end;

Procedure TFormFP_2027.DataChangeRtn; //(FormName:String);
begin
  Ret[RetNo].Changed := True;
  {save instance data}
  Calc(Retno,FormName);
  CalcAffectedBy(RetNo,FormName);
  If IsFormMultipage(FormName) then CalcMultiPageForm(RetNo,FormName);
  CalcAll(RetNo);
end;

Function GetReturnCaption(RetNo:Integer):String;
Var CorpName:String;
begin
  CorpName:=GetRetName(RetNo);
  If CorpName='' then CorpName:= 'Un-named';
  Result:=PaddR(PaddZero(IntToStr(RetNo),2),2)+' '+CorpName;
end;

procedure TFormFP_2027.ShowRichData(ARichEdit: TRichEdit; Fld: Integer);
//Procedure TMyChildFP_2012.ShowInterpretedRichData(ARichEdit:TwwDbRichEdit;FName:String;FNo:Integer);
begin
 If IsFormAClientLetter(FormName)  AND (ARichEdit.parent <> nil) then //20160223 Igor
 begin
  LetterName:=GetLetterFileName(RetNo,FormName);
  If FileExists(LetterName) then
  begin
    GetInterpretedRichEdit(RetNo,LetterName,ARichEdit);
    exit;
  end;
 end; //CLetter
 inherited;
end;

Function InDateOnly(Value:string;MnYear,MxYear: integer):Boolean;
begin
  Result := EditDate(Value,MnYear,MxYear);
  if not Result then
    UserMsg('Invalid Date (YYYY-MM-DD) or out of range');
end;

Function SubstituteLastYearForm(FName: String): String; //20160704 Igor
Begin
  Result:=GetRenamedFName(FName);
  if Result = '' then
    Result:=Fname;
end;

end.
