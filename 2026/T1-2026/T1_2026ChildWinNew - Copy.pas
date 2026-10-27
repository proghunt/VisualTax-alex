unit T1_2026ChildWinNew;
(* updated 07-24
  todo: add pagebreak every 1000 pixels, for printing and screen (after scaling)
  see vtChild for documentation
*)


interface


uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, TabNotBk,
  StdCtrls, ExtCtrls, Tabs, Menus, Grids, Dialogs, ColorGrd, ClipBrd,
  {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}, Gauges,
  Mask, DBCtrls, Printers, Messages, shellApi, MAPI, Buttons, ComCtrls,
  vtEditBox,
  vtLabel, vtShape, vtChild, vtForm, T1_2026HeaderFrame,
  T1_2026MonitorFrame, vtControlIntf, // 20170409 Igor
  vtVirtualTaxOffice, // 20210407 Igor
  RxRichEd; // 20160819 Igor (It must be the last)

type
  TFormT1_2026 = class(TvtScrollBox, IvtForm) // 20170409 Igor
  private
    Function PopulatePickList(FieldId: Integer): String; overload; // 20150806
    Function PopulatePickList(eBox: TvtEdit): String; overload; // 20150806
    Function PopulateIrregularPickList(eBox: TvtEdit; FieldId: Integer;SomeList: TStringList): Boolean;
    Function PopulateCAISPickList(eBox:TvtEdit;FieldId:Integer;SomeList:TStringList): Boolean; //jz//20260225
    Function PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj:integer;SomeCaption,flName,FormName,defaultCodeLine:string;var SomeList:Tstringlist):boolean;
    Function CleanUpPickedListValue(FieldId: Integer;SelectedString: String): string;
    procedure GetSICCode(FieldId: Integer);
    // 20170409 Igor >>>
    procedure ConditionCalc(AIdentificator: String;
      var AValue: Boolean); overload;
    procedure ConditionCalc(AIdentificator: String;
      var AValue: Integer); overload;
    procedure ConditionCalc(AIdentificator: String;
      var AValue: String); overload;
    procedure ConditionCalc(AIdentificator: String; var AValue: Real); overload;
    // 20170409 Igor <<<
    procedure EditButtonClick(AEdit: TObject; AAction: TEditButtonAction;
      AEdit2: TObject = nil); // 20170411 Igor
    // 20170411 Igor >>>
    function SameTable(AField1, AField2: Integer): Boolean; override;
    function SameColumn(AField1, AField2: Integer): Boolean; override;
    function isLastRow(AFieldID: Integer): Boolean; override;
    // 20170411 Igor <<<
  protected // overrides
    procedure ChangeProperties(MyEditBox: TvtEdit; Elm: Integer); override;
    procedure DataChangeRtn; override;
    procedure FormatDollar(MyEditBox: TvtEdit; str: string); override;
    function GetLinkedForm(FieldId: Integer; var TargetLinkedField: Integer)
      : String; override;
    function IsProtectedField(MyEditBox: TvtEdit): Boolean; override;
    function SetEditBoxBackColor(MyEditBox: TvtEdit): TColor; override;
    function ValidateField(FieldId: Integer; var Value: string)
      : Boolean; override;
    function GetisDraft: Boolean; override; // 20161130 Igor
  public // non-handlers
    Procedure PopulateFormWithData; override;
    Procedure ShowFormData; override;
    Procedure ShowLastYearFormData;
    Procedure ShowRichData(ARichEdit: TRichEdit; Fld: Integer); override;
    procedure ShowOther(cmp: TComponent); override;
    // procedure InsertSignature(cmp: TComponent);
    Function GetValueFromList(MyEditBox: TvtEdit; FieldId: Integer)
      : String; override;
    function ReplaceString(FieldId: Integer; NewString: string)
      : Boolean; override;
  public // handlers overrides
    procedure FormButtonClick(Sender: TObject); override;
    procedure OnVtEditDblClick(MyEditBox: TvtEdit); override;
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
  end;

  TMyChildT1_2026 = class(TMyChild)
  public
    procedure FormPaint(Sender: TObject);
    procedure Pg1Click(Sender: TObject); override;
    procedure SpeedButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AutoCompleteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public // non-handlers
    procedure CloseActiveForm(Sender: TObject); override;
    // Procedure ShowFormData(FName:String;FNo:Integer); override;

    function getvtEditbyName(eBoxName: string): TvtEdit;
    function getFieldByTabOrder(tOrder: Integer): TWinControl;
  private
    FMyFormHeaderFrame: THeaderFrameT1_2026;
    FMyMonitorFrame: TMonitorFrameT1_2026;
    // set by getActiveTabsheet
    MyTabSheet: TTabSheet;
    procedure SectionBtnClick(Sender: TObject);
  protected // overrides
    procedure AddPropertiesAndEvents; override;
    procedure AfterOpenForm(MyScrollBox: TvtScrollBox); override;
    function GetHeaderFrame: TFrame; override; // 20160227 Igor
    function GetMonitorFrame: TFrame; override; // 20160227 Igor
  public // overrides
    procedure FormKeyPress(Sender: TObject; var Key: Char); override;
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    Procedure Keys(Var Key: Word; Shift: TShiftState); override;
    Procedure UpdateFormHeaderFrame(); override;
    procedure UpdateChildTaxPanel; override;
  public
    constructor CreateNew(AOwner: TComponent; RNo: Integer); override;
    property MyFormHeaderFrame: THeaderFrameT1_2026 read FMyFormHeaderFrame;
    property MyMonitorFrame: TMonitorFrameT1_2026 read FMyMonitorFrame;
  end;


  // ROUTINES KNOWN TO OTHER UNITS
Function PrivacyAgreementAccepted(ForEfileFormName:string):boolean; //20251220 CZ

Function SubstituteLastYearForm(FName: String): String;
Function GetReturnCaption(RetNo: Integer): String;

Function InDateYYYYMMDDonly(Value: string; MxYear: Integer): Boolean;
Function AskingForSICCode(FormName: String; FieldId: Integer): Boolean;
Function InDateOnly(Value:string;MxYear:integer):Boolean; //20230811 Igor

Function BeforeOpenForm(RetNo: Integer; var FName: string;
  var FNo: Integer): string;

Function GetDFMFileName(FName: String): String;
Function GetLastYearDFMFileName(FName: String): String;

var
  RetNo: Boolean; // Integer; - force compiler errors

implementation

uses
  TypInfo,
  vtMulti, vtMain, vtCommon, vtDialogs, vtDynData, vtRichText,
  T1_2026, T1_2026Declare,
  T1_2026Common, T1_2026Common2, T1_2026TrimStr, T1_2026Calc,
  T1_2026PopComboList,
  T1_2026SaveAs, T1_2026T1Rtns, // T1_2026RichForm,
  T1_2026CntErr, T1_2026SearchList,
  T1_2026AcbFrame, {T1_2026SlipsFrame,} T1_2026OptimizeR, T1_2026main,
  T1_2026Print,
  T1_2026T1013Efile,
  T1_2026Calc4, // to pick up a calc routinr //20200524
  T1_2026EFILEConsent, // 20200211
  T1_2026T1135Efile, // 20150101
  T1_2026T106Efile,  //20170728
  T1_2026EfileT1134, // 20230811 Igor

  vtTrimStr, vtShared,
  T1_2026SERS; //20240715 Igor

var
  lastKey: Word; // for autocomplete
  // MyPickList:TListBox;
  // KeyStrokes:String;

Function InDateOnly(Value:string;MxYear:integer):Boolean; //20230811 Igor
begin
  result := EditDateYYYYMMDD(Value,MxYear);
  if not Result then
     ShowMessage('Invalid Date (YYYY/MM/DD) or out of range');
end;

procedure TMyChildT1_2026.AddPropertiesAndEvents;
begin
  inherited;
  // install for use by vtScrollBox
  PopupMenu := MainFormT1.FormPopup;
  OnContextPopup := FormContextPopup;
  OnPaint := FormPaint;
end;

procedure TMyChildT1_2026.AfterOpenForm(MyScrollBox: TvtScrollBox);
begin
  // MyScrollBox.OnDblClick := FormDblClick; - moved into vtScrollBox
end;

Function BeforeOpenForm(RetNo: Integer; var FName: string; var FNo: Integer): string;
// Function OpenForm(RetNo: Integer;FNo: integer;Elm:Integer): boolean;
Var
  j:integer;
  DfmFileName: String absolute Result;
begin
  Result := '';
  // argument checks
  If (RetNo < 1) then
    exit;
  if FName = '' then exit;

  if (FName = 'S6') and (ret[RetNo].Province = 'QC') then FName := 'S6QC'; // 20171205

  //20250109
  if GetFormType(Fname) ='EL' then //special Ekections) then
  Begin
   if LicenseLevel=llEnterprise then
   //ok
   Else
   Begin
    ShowMessage('Special Election returns are available only on the Enterprise version of the program');
    If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit;
   End;
  End;

  //20260304
  if (LeftStr(Fname,4)='T106') or (LeftStr(FName,5)='T1134') then
  Begin
   if LicenseLevel=llEnterprise then
   //ok
   Else
   Begin
    ShowMessage('Form '+Fname +' is available only on the Enterprise version of the program');
    If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit;
   End;
  End;

  { does not work
  if (Fname='INFO') then    //make vtGroupBox1 visible=false and vtProntabble =false
  begin
     for j := 0 to ComponentCount - 1 do
     begin
      if Components[j] is TvtGroupbox then
      begin
       If FetchElm(RetNo,'INFO',243)>'' then TvtGroupbox1.Visible:=False;
     end;
     end;//j
  end; //fname
  }

  If FName = 'OPTIMIZE' then
  begin
    if LicenseLevel in [llNetFile .. llStd] then
    begin
      ShowMessage
        ('The Family Optimization feature is only available in the T1 Power version');
      exit;
    end;
  end;

  // map formname
  If FName = 'FPCHECK' then
  begin
    If LicenseLevel in anyMulti then
    begin
      FName := 'FPINFO';
      // FNo:=GetFormNo(FName);
    end;
  end;

  If ret[RetNo].IsLastYearReturn = false then
    FNo := GetFormNo(FName)
  Else
    FNo := GetLastYearFormNo(FName);
  If FNo = 0 then
  begin
    // ShowMessage('Form No '+IntToStr(FNo)+' not found');
    ShowMessage('FormNo ' + FName + ' not found');
    exit;
  end;

  // get DFM name - in OpenTaxForm?
  If ShowUnconvertedLastYear(RetNo) = false then
    DfmFileName := GetDFMFileName(FName)
  else
  begin
    DfmFileName := GetLastYearDFMFileName(FName);
    // 20110224
    // If FName='INVOICE' then DfmFileName:=OptRec.Dir_PgmLastYr+'\'+'UINV_2.dfm';  //20101209
  end;
  If FileExists(DfmFileName) = false then
  begin
    ShowMessage('Form ' + FName + ' not found');
    Result := '';
    exit;
  End;

  If ret[RetNo].Frm[FNo].count = 0 then
    InitFormData(RetNo, FNo); // here???
end;

Procedure TFormT1_2026.ShowLastYearFormData; // (FName:String;FNo:Integer);
Var
  FrmDataList: TStringList;
  i, j, jj, jjj, Fld: Integer;
  MyEditBox: TvtEdit;
  MyRichEdit: TwwDbRichEdit;
  R: TRect;
  // MyScrollBox:TvtForm;  // TvtScrollBox;
  MyButton: TBitBtn;
begin
  FrmDataList := TStringList.Create;
  GetFormDataFromDisk(ret[RetNo].SourceDataDir + '\' + ret[RetNo].SourceFlName,
    FormName, FrmDataList); // 20110224
  // For i:=0 to FrmDataList.count-1 do ShowMessage(FrmDataList[i]);
  color := clWhite;
  // MyScrollBox:=MyChild.Components[i] as TvtScrollBox;
  If IsFormAClientLetter(FormName) then
    color := clWhite;
  for j := 0 to ComponentCount - 1 do
  begin
    if Components[j] is TvtEdit then
    begin
      MyEditBox := TvtEdit(Components[j]);
      MyEditBox.vtDataSource := vtCalc;
      // 20110220 stop changes in last year data
      If MyEditBox.vtDataSource = vtCalc then
        MyEditBox.TabStop := false;

      Fld := GetFieldId(MyEditBox.Name);
      For jjj := 0 to FrmDataList.count - 1 do
      begin
        If Fld = MyStrToInt(AllTrim(LeftStr(FrmDataList[jjj], 3))) then
          MyEditBox.Text := MidStr(FrmDataList[jjj], 4, 60);

        If FormName = 'INFO' then
        begin
          { TODO -oCon : wrong assignment direction }
          If Fld = 3 then
            ret[RetNo].LastYearSin := MyEditBox.Text;
          If Fld = 2 then
            ret[RetNo].LastYearFirstName := MyEditBox.Text;
          If Fld = 5 then
            ret[RetNo].LastYearLastName := MyEditBox.Text;
        end;
      end;

      If ShowFieldIdSw then
      begin
        Fld := GetFieldId(MyEditBox.Name);
        MyEditBox.Text := '[' + IntToStr(Fld) + ']';
        MyEditBox.Refresh;
      end;
    end // tvedit
    else if Components[j] is TwwDbRichEdit then
    begin
      MyRichEdit := Components[j] as TwwDbRichEdit;
      Fld := GetFieldId(MyRichEdit.Name);
      ShowRichData(MyRichEdit, Fld);
    end
    // 20200318
    else if Components[j] is TImage then
    begin
      ShowOther(Components[j]);
    end

    else if Components[j] is TBitBtn then
    begin
      MyButton := Components[j] as TBitBtn;
      MyButton.visible := false; // 20070227
      // MyButton.OnClick := MyChild.FormButtonClick;
    end;

    { if Components[j] is TSlipsFrameT1_2026 then //20160216 Igor
      begin
      (Components[j] as TSlipsFrameT1_2026).Visible:=False; //20110227  //20160216 Igor
      //(MyScrollBox.Components[j] as TSlipsFrame).Color:=GetRetColor(RetNo);
      //(MyScrollBox.Components[j] as TSlipsFrame).Visible:=OptRec.OtherSlipsButtons;
      end; }
  end; // j
  FrmDataList.Free;
end;

Procedure TFormT1_2026.ShowFormData; // (FName:String;FNo:Integer);
begin
  Caption := GetReturnCaption(RetNo);
  If ret[RetNo].IsLastYearReturn then
    ShowLastYearFormData // (FName,FNo)
  else
    inherited ShowFormData // (FName, FNo);
    // Caption:=GetReturnCaption(RetNo);
end;

// Procedure TMyChildT1_2026.PopulateFormWithData(MyScrollBox:TvtForm);
// Procedure TMyChildT1_2026.PopulateFormWithData(MyScrollBox:TvtScrollBox);
Procedure TFormT1_2026.PopulateFormWithData;
begin
  { TODO : set color in constructor }
  If IsFormAClientLetter(FormName) then
    color := clWhite;
  inherited;
end;

procedure TFormT1_2026.ShowOther(cmp: TComponent);
var
  s: string;
  AnImage: TImage;
  RNo: Integer;
  // MyEditBox:TvtEdit;
begin
  // 20200322
  if cmp is TImage then // 20120127
  begin
    AnImage := cmp as TImage;
    If (UpperCase(AnImage.Name) = 'E_SIGNATUREHOLDER') then
    Begin
      // 20210410 Igor >>>
      AnImage.Stretch := true;
      AnImage.Proportional := true;
      // 20210410 Igor <<<
      if UpperCase(FetchElmFNo(RetNo, InfoFNo, 144)) <> 'Y' then
      // 144 electronicall signed y/n
        AnImage.Picture := Nil // do not show it
      Else // show it
      Begin
        if (FormName <> 'T1032') then
        Begin
          s := GetSignatureFilePath(GetLastName(RetNo), GetFirstName(RetNo));
          If s > '' then
            AnImage.Picture.LoadFromFile(s);
        End
        Else if FormName = 'T1032' then
        // and (UpperCase(FetchElm(RetNo,'T1032',34))='Y')) then
        Begin
          s := GetSignatureFilePath(FetchELm(RetNo, 'T1032', 2),
            FetchELm(RetNo, 'T1032', 3));
          If s > '' then
            AnImage.Picture.LoadFromFile(s);
          If UpperCase(FetchELm(RetNo, 'T1032', 34)) <> 'Y' then
            AnImage.Picture := Nil;
        end;
      End; // show it
    End // e_signature

    Else If (UpperCase(AnImage.Name) = 'E_SIGNATUREHOLDER1') then
    Begin
      // 20210410 Igor >>>
      AnImage.Stretch := true;
      AnImage.Proportional := true;
      // 20210410 Igor <<<
      if UpperCase(FetchElmFNo(RetNo, InfoFNo, 144)) <> 'Y' then
        AnImage.Picture := Nil // do not show it
      Else // show it
      Begin
        if (FormName <> 'T1032') then
        Begin
          s := GetSignatureFilePath(GetLastName(RetNo), GetFirstName(RetNo));
          If s > '' then
            AnImage.Picture.LoadFromFile(s);
          if ((FormName = 'T185') and (Vl(FetchELm(RetNo, 'T185', 14)) = 0))
          then // PAD has no amount //20200212
            AnImage.Picture := Nil
        End
        Else if FormName = 'T1032' then // spouse's signature
        Begin
          s := GetSignatureFilePath(FetchELm(RetNo, 'T1032', 6),
            FetchELm(RetNo, 'T1032', 7));
          If s > '' then
            AnImage.Picture.LoadFromFile(s); // 20200502
          If UpperCase(FetchELm(RetNo, 'T1032', 34)) <> 'Y' then
            AnImage.Picture := Nil;
        end;
      End; // show/not
    End // e_signature1

    else if UpperCase(AnImage.Name) = 'E_PREPARERSIGNATUREHOLDER' // 2020214
    then
    Begin
      // 20210410 Igor >>>
      AnImage.Stretch := true;
      AnImage.Proportional := true;
      // 20210410 Igor <<<
      if UpperCase(FetchElmFNo(RetNo, InfoFNo, 144)) <> 'Y' then
        AnImage.Picture := Nil // do not show it
      Else // show it
      Begin
        s := GetPreparerSignatureFilePath;
        If s > '' then
          AnImage.Picture.LoadFromFile(s);
      End; // show it
    End; // e_signature
  end; // timage

  if cmp is TImage then // 20120127
  begin
    AnImage := cmp as TImage;
    s := GetPhotoIdFlName(RetNo);

    If (AnImage.Name = 'PhotoIdImage'){ and (HasvtScanLicense)} and (FileExists(s)) // // 20250616 Igor
    then
    Begin
      AnImage.Picture.LoadFromFile(s);
      AnImage.Stretch := true;
    End;
  end;
end;

procedure TFormT1_2026.FormButtonClick(Sender: TObject);
Var
  Nm: String;
  i, RetToOptimize: Integer;
  FInst, s: String;
  RNo, FNo, SpRetNo, PercentElm: Integer;
  OptimumPensionPercent: Integer;
  X: Real;
  FirstFieldId: Integer;
  h: THandle;
  AmendDir, FlName: String; // 20170320
  LargeString: AnsiString;
  //20260227 Igor >>>
  lUserResponse: Integer;

        procedure CertificationButtonClick(aValueFieldId: Integer; aFieldValue: string);
        begin
          StoreElm(RetNo, GetFormNo(FormName), aValueFieldId, aFieldValue);
          OpenForm(RetNo, FormName, aValueFieldId);
        end;
  //20260227 Igor <<<
begin

  Nm := UpperCase((Sender as TBitBtn).Name); // button name
  SpRetNo := GetSpRetNo(RetNo);

  //20251223 Igor >>>. Taken from T2-2026
  if FormName.Equals('T106') or LeftStr(Formname, 7).Equals('T106SL#') then
  begin
    if Nm.Equals('T106INSTRUCTIONSBTN') then ShowPdf(AppDir, 'T106SLIPI.pdf');

    if Nm.Equals('T106EFILEBTN') then
    begin
      if not FetchElm(RetNo, 'T106', 64).Equals('') then
      begin
        ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
        Exit;
      end;

      if not PrivacyAgreementAccepted(FormName) then Exit;

      Application.CreateForm(TT106EfileT1_2026, T106Efile);
      T106Efile.ShowModal;
      T106Efile.Free;
      OpenForm(RetNo, GetFormNo('T106'), 0);
    end;

    if Nm.Equals('T106SLBTN') then
    begin
      OpenForm(RetNo, GetFormNo('T106SL#1'), 1);
      Exit;
    end;

    if Nm.Equals('T106ISTRUCTIONSBTN') then ShowPdf(AppDir,'T106I.pdf');
  end;
  //20251223 Igor <<<

 //20251220CZ  Taken from T2-2026
 If (FormName='T106') //20240314
 Or (leftStr(Formname,7)='T106SL#')
 then  //20170728
 Begin
  //ShowMessage('Do not Efile the T106. It has not been released yet');//Exit;   //20171126
  If Nm='T106INSTRUCTIONSBTN' then
  begin
   ShowPdf(AppDir, 'T106SLIPI.pdf'); // 20240314
  end;

  If Nm='T106EFILEBTN' then
  begin
   //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20211210
   if FetchElm(RetNo,'T106',64)>''  then  //20180824 CON
   Begin
     ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
     Exit;
   End;

   if not PrivacyAgreementAccepted(FormName) then Exit; //T106 //jz 20250108

   Application.CreateForm(TT106EfileT1_2026,T106Efile);   //20251220
   T106Efile.ShowModal;
   T106Efile.Free;
   OpenForm(RetNo,GetFormNo('T106'),0);
  end;
  //20171201
  If Nm='T106SLBTN' then  //20171127
  begin
   OpenForm(RetNo,GetFormNo('T106SL#1'),1);
   Exit;
  end;


  If Nm='T106ISTRUCTIONSBTN' then  //20171127
  begin
   ShowPdf(AppDir,'T106I.pdf');
  end;
 end;
 //---------------------------------------------------------


  //20240723 Igor >>>
  If LeftStr(FormName, 5) = 'T217' then
  begin
    if Nm = UpperCase('EfileBtn') then
    begin
      with TfrmSERS2023.Create(Self, FormName) do
        try
          ShowModal;
        finally
          Free;
        end;
    end;
    //20260227 Igor >>>
    if (Nm = 'CERTBTN1') or (Nm = 'CERTBTN2') then
    begin
      lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
      if lUserResponse = mrYes then
      begin
        if (Nm = 'CERTBTN1') then CertificationButtonClick(22, '1');
        if (Nm = 'CERTBTN2') then CertificationButtonClick(21, '1');
      end else
      begin
        if (Nm = 'CERTBTN1') then CertificationButtonClick(22, '2');
        if (Nm = 'CERTBTN2') then CertificationButtonClick(21, '2');
      end;
    end;
    //20260227 Igor >>>
  end;
  //20240723 Igor <<<

  //20240715 Igor >>>
  If LeftStr(FormName, 5) = 'T2057' then
  begin
    if Nm = UpperCase('T2057EfileBtn') then
    begin
      with TfrmSERS2023.Create(Self, FormName) do
        try
          ShowModal;
        finally
          Free;
        end;
    end;
  end;

  If LeftStr(FormName, 5) = 'T2059' then
  begin
    if Nm = UpperCase('T2059EfileBtn') then
    begin
      with TfrmSERS2023.Create(Self, FormName) do
        try
          ShowModal;
        finally
          Free;
        end;
    end;
  end;

  If LeftStr(FormName, 4) = 'UHT#' then
  begin
    if Nm = UpperCase('UHT2900EfileBtn') then
    begin
      with TfrmSERS2023.Create(Self, FormName) do
        try
          ShowModal;
        finally
          Free;
        end;
    end;
  end;
  //20240715 Igor <<<

  // 20200526
  If LeftStr(FormName, 6) = 'T5008#' then
  begin
    // 20220510 Igor >>>
    If SameText(Nm, 'T5008OPENEXCELBTN') then
    begin
      OpenT5008Excel(RetNo);
      exit;
    end;

    If Nm = 'T5008SHOWSUMMARYAUTOFILLDATABTN' then
    begin
      GetAutofillData(RetNo, 'T5008slip');
      exit;
    end;
    If Nm = 'SHOWDETALAUTOFILLDATABTN' then // 20200605 after posting
    begin
      ShowMessage
        ('Click the Autofill my Return Slips, on the righthand vertical tabs of your VT desktop and enter T5008 on the search and Click filter');
      exit;
    end;

    If Nm = 'T5008FOREIGNRATESBTN' then // 20200531 //after fixing it recalc
    begin
      // SomeCaption := 'Average Exchange Rates for '+AppYear; //does not save
      // PopSomeFile(AppDir+'\'+'FCurrencies.txt',SomeCaption,True);
      ShellExecute(Application.Handle, 'open',
        PChar('' + AppDir + '\' + 'FCurrencies.txt'), nil, nil, SW_SHOWNORMAL);
      GetAutofillData(RetNo, 'T5008slip');
      Calc(RetNo, 'T5008#1');
      CalcFullReturn(RetNo);
      OpenForm(RetNo, 'T5008#1', 0);
      exit;
    end;

    If Nm = 'T5008ACCEPTAUTOFILLBTN' then
    Begin
      if (Vl(FetchELm(RetNo, 'T5008#1', 207)) <> 0) // threis amount
        and (FetchELm(RetNo, 'T5008#1', 214) = '')
      // thre is amount and no missing rates //2021
      then
      Begin
        StoreElm(RetNo, 'T5008#1', 1, 'Miscellaneous');
        StoreElm(RetNo, 'T5008#1', 2, 'C');
        StoreElm(RetNo, 'T5008#1', 3, FormatFloat('########.##',
          Vl(FetchELm(RetNo, 'T5008#1', 203))));
        StoreElm(RetNo, 'T5008#1', 4, FormatFloat('########.##',
          Vl(FetchELm(RetNo, 'T5008#1', 204))));
        StoreElm(RetNo, 'T5008#1', 5, FormatFloat('########.##',
          Vl(FetchELm(RetNo, 'T5008#1', 205))));
        StoreElm(RetNo, 'T5008#1', 7, FormatFloat('########.##',
          Vl(FetchELm(RetNo, 'T5008#1', 207))));
        Calc(RetNo, 'T5008#1');
        CalcFullReturn(RetNo);
        OpenForm(RetNo, 'T5008#1', 0);
      End
      Else
        ShowMessage
          ('There is no amount to use or foreign exchange rates are missing.' +
          Chr(13) + 'Click Show Summary Autofill My Return first or Add the missing exchange rates');
      exit;
    End;
  end;

  // 20250912 Igor >>>
  if FormName = 'S3' then
  begin
    if Nm = 'REMOVEDESIGNATIONBTN' then
    begin
      FNo := GetFormNo('S3');
      StoreElm(RetNo, FNo, 139, '');
      StoreElm(RetNo, FNo, 140, '');
      StoreElm(RetNo, FNo, 148, '');
      OpenForm(RetNo, 'S3', 139);
    end;

    if Nm = 'QLINKBTN' then OpenForm(RetNo, 'S3QSUPL#1', 1);
    if Nm = 'NONQLINKBTN' then OpenForm(RetNo, 'S3SUPL#1', 1);
  end;
  // 20250912 Igor <<<

  If FormName = 'T2043' then // 20220419
  begin
    If (Nm = 'T2043CHARTSBTN')
    or (Nm = 'T2043CHARTSBTN2') then // 20240111
    begin
      OpenForm(RetNo, 'T2043A#1', 0); // 20220419
      exit;
    end;
  end;

  // 20180312
  If LeftStr(FormName, 3) = 'T4#' then
  begin
    If Nm = 'IMPORTFROMT4T5APPBTN' then
    begin
      // ShowMessage('To be released after the T4T5 application is released');   //20181227
      BringSlipDataFromT4T5APP(MyStrToInt(GetSinNo(RetNo)), 'T4'); // 20200229
      exit;
    end;
  end;
  // 20180312


  // 20170304
  If FormName = 'RRSP' then
  begin
    If Nm = 'PRPPBTN' then
    begin
      OpenForm(RetNo, 'PRPP#1', 0);
      exit;
    end;
  end;

  (* //20260212 CZ
  // 20200402
  If FormName = 'S14EST' then
  begin
    if Nm = 'INFOBTN' then
      OpenForm(RetNo, 'INFO', 198);

    If Nm = 'CAIINFOBTN' then
    begin
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/services/child-family-benefits/cai-payment.html#toc3');
      // 20210110
      exit;
    end;
  end;
  *)

  If FormName = 'RC151' then // 2025041340131
  begin
    If (Nm = 'RC151HELPBTN') then
    begin
      ShowPdf(AppDir, 'rc151-24e.pdf');
      exit;
    end;
  end;


  If FormName = 'T400A' then // 20240131
  begin
    If (Nm = 'T400AIBTN') then
    begin
       ShowPdf(AppDir, 'T400AI.pdf'); // 20150115
      exit;
    end;
  end;


  If FormName = 'T2205' then // 20240131
  begin
    If (Nm = 'T2205IBTN') then
    begin
       ShowPdf(AppDir, 'T2205I.pdf'); // 20150115
      exit;
    end;
  end;

  If FormName = 'T1032' then // 20240131
  begin
    If (Nm = 'T1032IBTN') then
    begin
       ShowPdf(AppDir, 'T1032I.pdf'); // 20150115
      exit;
    end;
  end;

  If FormName = 'RC381' then // 20240131
  begin
    If (Nm = 'RC381IBTN') then
    begin  //20241217
     connectToWeb('https://www.canada.ca/en/revenue-agency/news/2023/05/the-canada-pension-plan-enhancement--businesses-individuals-and-self-employed-what-it-means-for-you.html');
     // connectToWeb('http://www.cra-arc.gc.ca/gncy/bdgt/2014/qa10-eng.html');
     //ShowPdf(AppDir, 'RC381I.pdf'); // 20150115
     exit;
    end;
  end;

  If FormName = 'RC59' then // 20240131
  begin
    If (Nm = 'RC59IBTN') then
    begin
       ShowPdf(AppDir, 'RC59I.pdf'); // 20150115
      exit;
    end;
  end;

  If LeftStr(FormName, 4) = 'UHT#' then // 20240131
  begin
    If (Nm = 'UHTIBTN') then
    begin
       ShowPdf(AppDir, 'UHTI.pdf'); // 20150115
      exit;
    end;
  end;

  If LeftStr(FormName, 6) = 'T1139#' then // 20220624
  begin
    If Nm = 'T1139IBTN' then
    begin
      ShowPdf(AppDir, 'T1139i.pdf'); // 20240131
      exit;
    end;
  end;


  If FormName = 'RC151' then // 20230330
  begin
    If Nm = 'RC151HELPBTN' then
    begin
      ShowPdf(AppDir, 'RC151I.pdf');
      exit;
    end;
  end;

  If FormName = 'T1206' then
  begin
    If Nm = 'T1206IBTN' then
    begin
      ShowPdf(AppDir, 'T1206I.pdf'); // 20150115
      exit;
    end;
    // 20190115
    If Nm = 'T1206FAQBTN' then
    begin
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/programs/about-canada-revenue-agency-cra/federal-government-budgets/income-sprinkling/frequently-asked-questions-income-sprinkling.html');
      exit;
    end;

    If Nm = 'T1206EXAMPLESBTN' then
    begin
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/programs/about-canada-revenue-agency-cra/federal-government-budgets/income-sprinkling/guidance-split-income-rules-adults.html');
      exit;
    end;

  end;

  // 20170623
  If FormName = 'T1OVP' then
  begin
    If Nm = 'RRSPGUIDEBTN' then
    begin
      ConnectToWeb
        ('https://www.canada.ca/content/dam/cra-arc/formspubs/pub/t4040/t4040-19e.pdf');
      // 20210110
      exit;
    end;
  end;

  If FormName = 'TRANSF' then
  begin
    If Nm = 'PTRANSFBTN' then
    begin
      OpenForm(RetNo, 'PTRANSF', 0);
      exit;
    end;

   If Nm = 'DEPENDBTN' then  //20230503
    begin
      OpenForm(RetNo, 'DEPEND', 0);
      exit;
    end;
  end;

  If FormName = 'PTRANSF' then // 20120204
  begin
    If Nm = 'TRANSFBTN' then
    begin
      OpenForm(RetNo, 'TRANSF', 0);
      exit;
    end;
  end;

  If FormName = 'TESTFRM' then
  begin
    If Nm = 'ADDROWBTN' then
    begin
      FirstFieldId := 10001;
      AddDynamicRow(self, FirstFieldId); // ???
    end;
    If Nm = 'REMOVEROWBTN' then
    begin
      // MyScrollbox:=GetScrollbox(FormName);
      FirstFieldId := 10001;
      DeleteDynamicRow(self, FirstFieldId);
    end;
  end;

  // FAILS 20150709
  If FormName = 'T1135' then // 20140227
  begin
    If (Nm = 'T1135EFILEBTN') Or (Nm = 'T1135EFILEBTN2') // 20200507
    then // 20140101
    begin
      //ShowMessage('T1135 Efile is not currently available');
      //Exit;
      // 20200207
      if ReadyForT1135Efile(RetNo) = false then
      Begin
        ShowMessage('Please select Simple or Detail option');
        exit;
      End;

      If IsCraOpenForEfile = false then
      begin
        ShowCraIsClosed;
        exit;
      end; // 20160205 //20160216 Igor
      Application.CreateForm(TT1135EfileT1_2026, T1135Efile); // 20150709
      T1135Efile.ShowModal;
      T1135Efile.Free;
      OpenForm(RetNo, GetFormNo('T1135'), 0);
    end;
    If Nm = 'T1135FILLBTN' then
    begin
      ConnectToWeb
        ('http://www.cra-arc.gc.ca/E/pbg/tf/t1135/t1135-fill-14e.pdf');
      // 20150105
    end;

    If Nm = 'T1135I' then // 20150201
    begin
      ShowPdf(AppDir, 't1135i.pdf'); // 20150105
    end;
  end;

  If FormName = 'OPTIMIZE' then
  begin
    If SpRetNo = 0 then
    begin
      ShowMessage
        ('Optimize can be used only if Spousal return is loaded (Coupling mode)');
      exit;
    end;

    If Nm = 'OPTIMIZEBTN' then
    begin
      FNo := GetFormNo('OPTIMIZE');
      If ret[RetNo].CouplingSw = false then
        exit;

      // 20200612

      If (FetchElmFNo(RetNo, FNo, 14) > '') then
      begin
        ShowMessage
          ('Click Optimize on the spouse with the higher taxable income. Switching now'
          + Chr(13) + ' ' + Chr(13) +
          '(Or change Pension split % directly on the T1032 form)');
        // ShowTimedMsg('Click Optimize on the spouse with the higher taxable income. Switching now'+Chr(13)+'Or change % directly on the T1032 form',1600);
        // RetNo := SpRetNo;
        LockWindowUpdate(MainForm.Handle);
        OpenForm(SpRetNo, FNo, 0);
        MainForm.RefreshAuditPanel(SpRetNo);
        LockWindowUpdate(0);
        exit;
      end;

      {
        If (FetchElmFNo(RetNo,FNo,14) > '')
        then
        begin
        ShowTimedMsg('Click Optimize on the spouse with the higher taxable income. Switching now',1600);
        //RetNo := SpRetNo;
        LockWindowUpdate(MainForm.Handle);
        OpenForm(SpRetNo, FNo,0);
        MainForm.RefreshAuditPanel(SpRetNo);
        LockWindowUpdate(0);
        Exit;
        end;
      }

      If (FetchElmFNo(RetNo, FNo, 13) > '') then
      begin
        If Vl(FetchElmFNo(RetNo, FNo, 35)) > 0 then
        begin
          ShowMessage('Auto-Optimize available only if you are' + Chr(13) +
            'transferring pension from the higher taxable income spouse');
          // RetNo := SpRetNo;
          LockWindowUpdate(MainForm.Handle);
          OpenForm(SpRetNo, FNo, 0);
          MainForm.RefreshAuditPanel(SpRetNo);
          LockWindowUpdate(0);
          exit;
        end;
      end;

      If (FetchElmFNo(RetNo, FNo, 14) > '') then
      begin
        If Vl(FetchElmFNo(RetNo, FNo, 24)) > 0 then
        begin
          ShowMessage('Auto-Optimize available only if you are' + Chr(13) +
            'transferring pension from the higher taxable income spouse');
          // RetNo := SpRetNo;
          LockWindowUpdate(MainForm.Handle);
          OpenForm(SpRetNo, FNo, 0);
          MainForm.RefreshAuditPanel(SpRetNo);
          LockWindowUpdate(0);
          exit;
        end;
      end;

      PercentElm := 0; // 24 vs 35 i.e to which spouse on the screen
      StoreElm(RetNo, FNo, 24, '');
      StoreElm(RetNo, FNo, 35, ''); // the split %
      // this put all % into the optimize form and returns the %
      OptimumPensionPercent := GetOptimumPensionSplit(RetNo, PercentElm);
      If (OptimumPensionPercent = 0) and
        (UpperCase(FetchElmFNo(RetNo, FNo, 5)) = 'Y') then
      begin
        If Vl(FetchELm(RetNo, 'PNSDED', 3)) + Vl(FetchELm(SpRetNo, 'PNSDED', 3))
          > 0 then // elig pension
          ShowTimedMsg
            ('Automatic optimization not available in this case. Please try manual optimization',
            1700);
      end;
      OpenForm(RetNo, FNo, 0);
      // it shows optimize form again with % after optimize
      ret[RetNo].AutoOptimize := false;
      ret[SpRetNo].AutoOptimize := false;
      Application.CreateForm(TOptimizeRT1_2026, OptimizeR);
      OptimizeR.ShowModal;
      OptimizeR.Free;
    end;

    If Nm = 'T1032BTN' then
    begin
      OpenForm(RetNo, 'T1032', 0);
    end;

    // 20170131
    If Nm = 'T1032IBTN' then
    begin
      ShowPdf(AppDir, 'T1032I.pdf');
      exit;
    end;

    If Nm = 'FAMSUMBTN' then
    begin
      OpenForm(RetNo, 'FAMSUM', 0);
    end;
  end; // optimize

  If FormName = 'RC381' then // 20131202
  begin
    If Nm = 'RC381IBTN' then
    begin
      ShowPdf(AppDir, 'Rc381I.pdf'); // 20150115
      exit;
    end;
    If Nm = 'CPT20BTN' then
    begin
      OpenForm(RetNo, GetFormNo('CPT20'), 0);
      exit;
    end;
  end;

  If FormName = 'T1DD' then // 20140127
  begin
    If Nm = 'T1DDWEBBTN' then
      ConnectToWeb
        ('https://www.tpsgc-pwgsc.gc.ca/recgen/form/inscription-enrolment-eng.html');
    If Nm = 'MYACCOUNTBTN' then
      ConnectToWeb
        ('http://www.cra-arc.gc.ca/esrvc-srvce/tx/ndvdls/myccnt/menu-eng.html');
    exit;
  end;


  If FormName = 'S8' then // 20130304
  begin
    If Nm = 'RC381BTN' then
    begin
      OpenForm(RetNo, GetFormNo('RC381'), 0);
      exit;
    end; // 20140112

    //jz//20250301
    If Nm = 'CPT20BTN' then
    begin
      OpenForm(RetNo, GetFormNo('CPT20'), 0);
      exit;
    end;

    If Nm = 'CPPRULESBTN' then
      ConnectToWeb('www.visualtax.com/t1faq.htm');
  end;


  If FormName = 'S8Q' then // 20130304
  begin
    If Nm = 'RC381BTN' then
    begin
      OpenForm(RetNo, GetFormNo('RC381'), 0); // 20140112
      exit;
    end;
  end;

  If FormName = 'ONBEN' then
  begin
    If Nm = 'ONBENHELPBTN' then
    begin
      ShowHelp('T1Help', 'ON479');
      exit;
    end; // 20101214
    // If Nm='ON479BTN' then  begin  OpenForm(RetNo,GetFormNo('ON479'),0);  Exit; end;
    If Nm = 'MCREDITBTN' then
    begin
      OpenForm(RetNo, 'MCREDIT', 0);
      exit;
    end;
    If Nm = 'OTBBTN' then
      ConnectToWeb('https://www.ontario.ca/page/ontario-trillium-benefit');
    // ('http://www.rev.gov.on.ca/en/credit/otb/index.html'); //otb
    // https://www.ontario.ca/page/ontario-trillium-benefit
  end;

  If FormName = 'MCREDIT' then
  begin
    If Nm = 'ONBENBTN' then
      OpenForm(RetNo, 'ONBEN', 0);
    If Nm = 'OTBBTN' then
      ConnectToWeb('https://www.ontario.ca/page/ontario-trillium-benefit');
    // otb //ConnectToWeb('http://www.rev.gov.on.ca/en/credit/otb/index.html'); //otb
    If Nm = 'OSTCBTN' then
      ConnectToWeb('http://www.rev.gov.on.ca/en/credit/stc/index.html');
    If Nm = 'SHPTGBTN' then
      ConnectToWeb(' http://www.rev.gov.on.ca/en/credit/shptg/index.html');
    If Nm = 'NOECBTN' then
      ConnectToWeb
        ('http://www.canada.ca/en/revenue-agency/services/child-family-benefits/provincial-territorial-programs/2021-northern-ontario-energy-credit-noec-calculation-sheet-married-common-law-individuals-who-have-have-children.html');
    // ('http://www.rev.gov.on.ca/en/credit/noec/index.html');
    If Nm = 'OEPTCBTN' then
    Begin
      OpenForm(RetNo, 'OEPTC', 0);
      exit;
    end;
  end;

  If FormName = 'MXCREDIT' then
  begin
    If Nm = 'BCHSTCBTN' then
      ConnectToWeb
        ('http://www.sbr.gov.bc.ca/individuals/income_taxes/personal_income_tax/tax_credits/hstc.htm');
    If Nm = 'BCLICATCBTN' then
      ConnectToWeb
        ('http://www.sbr.gov.bc.ca/individuals/Income_Taxes/Personal_Income_Tax/tax_credits/low_income_climate_action.htm');
    If Nm = 'SLITCBTN' then
      ConnectToWeb('http://www.cra-arc.gc.ca/bnfts/rltd_prgrms/sk-eng.html');
  end;

  If FormName = 'GSTC' then
  begin
    If Nm = 'MCREDITBTN' then
      OpenForm(RetNo, 'MCREDIT', 0);
    If Nm = 'MXCREDITBTN' then
      OpenForm(RetNo, 'MXCREDIT', 0);
  end;

  If FormName = 'INVFORMS' then
  begin
    If Nm = 'INVOICEBTN' then
    begin
      OpenForm(RetNo, 'INVOICE', 0);
      exit;
    end;
    If Nm = 'FEESCHEDULEBTN' then
    begin
      MainFormT1.FeeSchedule1Click(Application);
      exit;
    end;
  end;

  If FormName = 'INVOICE' then
  begin
    If Nm = 'INVHISTBTN' then
    begin
      FNo := GetFormNo('YRSUM');
      X := Vl(FetchLastYearValueFromDisk(RetNo, 'INVOICE', 277));
      // last year before taxes invoice //20150225
      // x:=Vl(FetchLastYearValueFromDisk(RetNo,'INV_2',277)); //last year before taxes invoice //20130209  //20130224  //every year

      If X > 0 then
        s := FormatFloat('###,###.##', X)
      else
        s := 'Not available';
      ShowMessage('After tax Invoice amounts in previous years' + Chr(13) +
        '=================================' + Chr(13) + FetchElmFNo(RetNo, FNo,
        3) + ':     $' + FormatFloat('###,###.00',
        Vl(FetchElmFNo(RetNo, FNo, 749))) + '  (Before Taxes $' + ' ' + s + ')'
        + Chr(13) + FetchElmFNo(RetNo, FNo, 4) + ':     $' +
        FormatFloat('###,###.00', Vl(FetchElmFNo(RetNo, FNo, 750))) + Chr(13) +
        FetchElmFNo(RetNo, FNo, 5) + ':     $' + FormatFloat('###,###.00',
        Vl(FetchElmFNo(RetNo, FNo, 751))) + Chr(13) + FetchElmFNo(RetNo, FNo, 6)
        + ':     $' + FormatFloat('###,###.00',
        Vl(FetchElmFNo(RetNo, FNo, 752))));
      exit;
    end;

    If Nm = 'LASTYRINVBTN' then // 20201127
    begin
      MainFormT1.ShowLastYearForm1Click(Application);
      exit;
    end;

    If Nm = 'ADDSPOUSESCHARGESBTN' then
    begin
      If ShowUnconvertedLastYear(RetNo) = true then
        exit;
      If (IsJointInvoice(RetNo) = false) or
        (IsJointInvoiceForThisReturn(RetNo) = false) then
      begin
        ShowMessage('N/A. See INFO form, Joint Invoice');
        OpenForm(RetNo, 'INFO', 121);
        exit;
      end
      else
      begin
        AddSpouseCharges(RetNo);
        Calc(RetNo, 'INVOICE'); // 20170411
        OpenForm(RetNo, 'INVOICE', 219);
        // 20170411 //OpenForm(RetNo,'INVOICE',321);
        exit;
      end;
    end;

    If Nm = 'INVFORMSBTN' then // 20100622
    begin
      OpenForm(RetNo, 'INVFORMS', 0);
      exit;
    end;
  end;

  If FormName = 'INFO' then
  begin

    if Nm = 'T776BTN' then     //20250428
    Begin
      OpenForm(RetNo, 'T776#1', 1);
      exit;
    End;

    if Nm = 'MJBTN' then     //20240414
    Begin
      OpenForm(RetNo, 'T2203', 110);
      exit;
    End;

    if Nm = 'T183BTN' then     //20240214
    Begin
      OpenForm(RetNo, 'T183', 13);
      exit;
    End;

    if Nm = 'T5013BTN' then
    Begin
      ConnectToWeb
      ('https://www.canada.ca/content/dam/cra-arc/formspubs/pub/5013-g/5013-g-25e.pdf');
       // ('https://www.canada.ca/content/dam/cra-arc/formspubs/pub/5013-g/5013-g-23e.pdf');
    End;


    if Nm = 'DETERMINERESIDENCYBTN' then
    Begin
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/services/tax/international-non-residents/information-been-moved/determining-your-residency-status.html');
    End;


    if Nm = 'FACTUALBTN' then
    Begin
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/services/tax/international-non-residents/individuals-leaving-entering-canada-non-residents/factual-residents-temporarily-outside-canada.html');
    End;

    if Nm = 'NONRESBTN' then  //20240111
    Begin
      ConnectToWeb
       ('https://www.canada.ca/en/revenue-agency/services/tax/international-non-residents/individuals-leaving-entering-canada-non-residents/non-residents-canada.html');
    End;

   If Nm = 'T1248BTN' then // 20140212
    begin
      OpenForm(RetNo, 'T1248', 0);
      exit;
    end;

    If Nm = 'BANKRUPTCYBTN' then // 20100622
    begin
      OpenForm(RetNo, 'BANKRPT', 0);
      exit;
    end;


    If Nm = 'HELPNEWCOMERBTN' then
    Begin
      ShowTimedMsg('Press CTRL F and search for NewComer OR Line 5292', 5000); //20260219
      // 202302
      MainFormT1.EFILERSMANUAL1Click(Sender); // 20200425
    End;
    If Nm = 'SIGNATUREDATEBTN' then // 20200430
    begin
      if MessageDlg('Set the date of receipt to be today?', mtInformation,
        [mbYes, mbNo], 0) = mrYes then
      Begin
        StoreElm(RetNo, InfoFNo, 153, FormatDateTime('yyyy-mm-dd', Now));
        s := TimeToHHMMDD(Now); // 20201227
        StoreElm(RetNo, InfoFNo, 155, s);
        // InfoFNo,155,FormatDateTime('tt',Now)); //20201127
        // ShowFormData;
        // Mainform.RecalcBtnClick(Sender); not needed
        // Calc(RetNo,'INFO');  //20210226
        OpenForm(RetNo, 'INFO', 153);
      End;
    end;
    If Nm = 'DEPENDBTN' then
      OpenForm(RetNo, 'DEPEND', 0);
    If Nm = 'PADINFOBTN' then
      OpenForm(RetNo, 'PADINFO', 0); // 20170212
    If Nm = 'SCHABTN' then
      OpenForm(RetNo, 'SNRESA', 0); // 20180210 SCH C
    If Nm = 'T1159BTN' then
      OpenForm(RetNo, 'T1159', 0); // 20180210
    If Nm = 'INTERVIEWBTN' then
      MainFormT1.PreSelForms1Click(Sender);
    If Nm = 'LASTYEARFORMSBTN' then
      MainFormT1.SuperEntryLastyearsformsselection1Click(Sender);
    If Nm = 'OPENAFORMBTN' then
      MainFormT1.SelectFormClick(Sender);
    If Nm = 'TUTORIALSBTN' then
      MainFormT1.TUTORIALS1Click(Sender);
    If Nm = 'WRITEEMAILBTN' then
      EmailToClient(RetNo);
    If Nm = 'T1135MSGBTN' then
      OpenForm(RetNo, 'DIAGNO', 0); // 20200210
    If Nm = 'ESIGNATUREBTN' then
      ConnectToWeb('www.VisualTax.com/e-signature.php'); // 20200517
    If Nm = 'T1135MOREINFOBTN' then
      ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/tax/international-non-residents/information-been-moved/foreign-reporting/information-returns-relating-foreign-affiliates.html#h11');




    // 20120126
    If Nm = 'PHOTOIDBTN' then
    Begin
      s := OptRec.Dir_ClientDocs + '\' + GetLastName(RetNo) + ',' +
        GetFirstName(RetNo) + '\Photo Id.bmp';
      If (HasvtScanLicense) and (FileExists(s)) then
        ShowClientPhotoId(s)
      Else
        ShowMessage('PHOTO ID not found or there is no vtScan program license');
    end;
  end;
  // 20180210
  If FormName = 'SNRESA' then
  begin
    If Nm = 'SCHBBTN' then
      OpenForm(RetNo, 'SNRESB', 0);
    If Nm = 'SCHCBTN' then
      OpenForm(RetNo, 'SNRC', 0);
  end;

  // 201220410
  If FormName = 'SNRESB' then
  begin
    If Nm = 'SCHABTN' then
      OpenForm(RetNo, 'SNRESA', 0);
    If Nm = 'SCHCBTN' then
      OpenForm(RetNo, 'SNRC', 0);
  end;

  // 201220410
  If FormName = 'SNRC' then
  begin
    If Nm = 'SCHABTN' then
      OpenForm(RetNo, 'SNRESA', 0);
    If Nm = 'SCHBBTN' then
      OpenForm(RetNo, 'SNRESB', 0);
  end;

  If FormName = 'PNSDED' then
  begin
    If Nm = 'T1032BTN' then
      OpenForm(RetNo, 'T1032', 0);
  end;

  // 20110218
  If ExtractNonInstFormName(FormName) = 'FLDTAPE' then // 20160907 Igor
  begin
    If Nm = 'AFFECTEDFORMBTN' then
    begin
      OpenForm(RetNo, GetFormNo(FetchELm(RetNo, FormName, 121)),
        MyStrToInt(FetchELm(RetNo, FormName, 122)));
    end;
  end;

  // 20110218
  If ExtractNonInstFormName(FormName) = 'FLDMEM' then // 20160907 Igor
  begin
    If Nm = 'AFFECTEDFORMBTN' then
    begin
      OpenForm(RetNo, GetFormNo(FetchELm(RetNo, FormName, 17)),
        MyStrToInt(FetchELm(RetNo, FormName, 18)));
    end;
  end;

  // 20110306
  If FormName = 'GST370' then
  begin
    // If Nm='SPLITBTN' then SplitGst370(RetNo);
    RecalcEverything(RetNo); // 20110402
    OpenForm(RetNo, FormName, 101);
  end;

  If ExtractNonInstFormName(FormName) = 'T4A' then // 20160907 Igor
  begin
    If Nm = 'T4AIBTN' then
      OpenForm(RetNo, 'T4AI', 0);
    If Nm = 'PTIMEWSBTN' then
      OpenForm(RetNo, 'PTIMEWS', 9);
  end;

  // 20110306
  If FormName = 'FITNESS' then
  begin
    // If Nm='ONFITNESSBTN' then OpenForm(RetNo,'CATC',0);
    If Nm = 'NSFITNESSBTN' then
      OpenForm(RetNo, 'SPORTS', 0);
    If Nm = 'MBFITNESBTN' then
      OpenForm(RetNo, 'MBFITNES', 0);
    If Nm = 'T778BTN' then
      OpenForm(RetNo, 'T778', 0);
    If Nm = 'ARTSBTN' then
      OpenForm(RetNo, 'ARTS', 0);
  end;

  If FormName = 'OTHEMPL' then
  begin
    If Nm = 'FORINCBTN' then
      OpenForm(RetNo, 'FORINC', 0);
  end;

  If FormName = 'DIRECT' then
  begin
    If Nm = 'RRSPBTN' then
      OpenForm(RetNo, 'RRSP', 17);
  end;

  If FormName = 'YRSUM2' then
  begin
    If Nm = 'YRSUMBTN' then
      OpenForm(RetNo, 'YRSUM', 0);
  end;

  If FormName = 'T1032' then
  begin
    If Nm = 'PNSDEDBTN' then
    begin
      If GetPensionerRetNo(RetNo) > 0 then
        OpenForm(GetPensionerRetNo(RetNo), 'PNSDED', 0);
    end;

    If Nm = 'T1032WSBTN' then
    begin
      If ((ret[RetNo].CouplingSw) and (GetSpRetNo(RetNo) > 0)) then
      begin
        If ((RetNo = GetPensionerRetNo(RetNo)) and
          (ret[RetNo].FormHasData['T1032']) and (ret[RetNo].Age >= 65) and
          (ret[SpRetNo].Age < 65) and (Vl(FetchELm(RetNo, 'T1032', 21)) < 2000))
        then
          OpenForm(RetNo, 'T1032WS', 9)
        Else
          ShowMessage
            ('Not applicable in this case or not in pensioners return');
      end
      Else // not coupled
      begin
        ShowMessage('Worksheet available only if returns are coupled');
      end;
    end;
  end;

  If FormName = 'T1032WS' then
  begin
    If Nm = 'POSTT1032WSBTN' then
    begin
      If Vl(FetchELm(RetNo, 'T1032', 22)) <> Vl(FetchELm(RetNo, FormName, 8))
      then
      begin
        StoreElm(RetNo, GetFormNo('T1032'), 50, 'Y');
        StoreElm(RetNo, GetFormNo('T1032'), 22, FormatFloat('######.##',
          Vl(FetchELm(RetNo, FormName, 8))));
        If GetSpRetNo(RetNo) > 0 then
        begin
          StoreElm(GetSpRetNo(RetNo), GetFormNo('T1032'), 50, 'Y');
          StoreElm(GetSpRetNo(RetNo), GetFormNo('T1032'), 22,
            FormatFloat('######.##', Vl(FetchELm(RetNo, FormName, 8))));
        end;
      end;
      OpenForm(RetNo, 'T1032', 0);
    end;
  end;

  If FormName = 'DEPEND' then
  begin
    If Nm = 'S5BTN' then
      OpenForm(RetNo, 'S5', 0);
    If Nm = 'DISABBTN' then
      OpenForm(RetNo, 'TRANSF', 0);
    If Nm = 'T778BTN' then
      OpenForm(RetNo, 'T778', 0);
    If Nm = 'LINEBYLINEBTN' then
      MainFormT1.LineByLinehelp1Click(Sender); // 20120209
    // 20180225
    If Nm = 'CAREGIVERHELPBTN' then
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/services/tax/individuals/topics/about-your-tax-return/tax-return/completing-a-tax-return/deductions-credits-expenses/family-caregiver-amount.html');
  end;

  If FormName = 'S7' then
  begin
    If Nm = 'RRSPBTN' then
      OpenForm(RetNo, 'RRSP', 0);
  end;

  If LeftStr(FormName, 5) = 'RC59#' then
  begin
    If Nm = 'RC59IBTN' then
      ShowPdf(AppDir, 'RC59I.pdf'); // 20150201
  end;

  { 202201
    If ExtractNonInstFormName(FormName)='T2201' then //20160907 Igor
    begin
    If Nm='T2201IBTN' then ShowPdf(AppDir,'T2201I.pdf');  //20150204
    end;
  }

  If ExtractNonInstFormName(FormName) = 'T1M' then // 20160907 Igor
  begin
    If Nm = 'T1MIBTN' then
      ShowPdf(AppDir, 'T1mi.pdf'); // 20150201
  end;

  If ExtractNonInstFormName(FormName) = 'T2209' then // 20160907 Igor
  begin
    If Nm = 'T2209IBTN' then
      ShowPdf(AppDir, 'T2209I.pdf'); // 20150201
  end;

  If FormName = 'RC201' then // 20150201
  begin
    If Nm = 'RC201IBTN' then
    begin
      ShowPdf(AppDir, 'RC201I.pdf');
      exit;
    end;
  end;

  If FormName = 'OEPTC' then
  begin
    If Nm = 'ONBENBTN' then
      OpenForm(RetNo, 'ONBEN', 0);
  end;

  If FormName = 'ON479' then
  begin
    If Nm = 'ONBENBTN' then
      OpenForm(RetNo, 'ONBEN', 0);
  end;

  If FormName = 'TAXSUM' then
  begin
    If Nm = 'PSUMBTN' then
      OpenForm(RetNo, 'PRVSUM', 0);
    If Nm = 'FSUMBTN' then
      OpenForm(RetNo, 'FAMSUM', 0);
    If Nm = 'BSUMBTN' then
      OpenForm(RetNo, 'BUSSUM', 0);
    If Nm = 'YSUMBTN' then
      OpenForm(RetNo, 'YRSUM', 0);
    If Nm = 'SSUMBTN' then
      OpenForm(RetNo, 'T4SUM#1', 0);
    If Nm = 'RENTSUMBTN' then
      OpenForm(RetNo, 'RENTSUM', 0);
  end;

  // 20200212
  If FormName = 'PADINFO' then
  begin
    If Nm = 'T185BTN' then
      OpenForm(RetNo, 'T185', 0);
  end;

  If FormName = 'FAMSUM' then
  begin
    If Nm = 'PSUMBTN' then
      OpenForm(RetNo, 'PRVSUM', 0);
  end;

  If FormName = 'PRVSUM' then
  begin
    If Nm = 'XX479BTN' then
      OpenForm(RetNo, GetFormNo(WhichCreditForm(RetNo,
        ret[RetNo].Province)), 0);
    If Nm = 'XX428BTN' then
      OpenForm(RetNo, GetFormNo(WhichTaxForm(RetNo, ret[RetNo].Province)), 0);
  end;

  If ExtractNonInstFormName(FormName) = 'T4' then // 20160907 Igor
  begin
    If Nm = 'EFMEMOBTN' then
      OpenForm(RetNo, 'EFMEMO', 0);
  end;

  If FormName = 'BUSSUM' then
  begin
    If Nm = 'RENTSUMBTN' then
      OpenForm(RetNo, 'RENTSUM', 0);
  end;

  // 20200212
  If FormName = 'T185' then
  Begin
    If Nm = 'SUBMITPADBTN' then
      MainFormT1.PADPreauthorizedDebit1Click(Sender); // 20180204
    If Nm = 'TODAYSDATEBTN1' then // 2020
    Begin
      StoreElm(RetNo, GetFormNo('T185'), 15, FormatDateTime('yyyy-mm-dd', Date)
        ); // 20210213
      Calc(RetNo, 'T185'); // 20200213
      OpenForm(RetNo, GetFormNo('T185'), 0);
    End;

    If Nm = 'TODAYSDATEBTN2' then // 2020
    Begin
      StoreElm(RetNo, GetFormNo('T185'), 27, FormatDateTime('yyyy-mm-dd', Date)
        ); // 20170307
      Calc(RetNo, 'T185'); // 20200213
      OpenForm(RetNo, GetFormNo('T185'), 0);
    end;
  End;

  If FormName = 'S11' then
  begin
    If (Nm = 'S11PRVBTN') Or (Nm = 'S11PRVBTN2') then // 20120204
    begin
      if (ret[RetNo].Province = 'QC') or (ret[RetNo].Province = 'ZZ') then
      // 20200217
        OpenForm(RetNo, 'S11', 0)
      Else
        OpenForm(RetNo, 'S11PRV', 0);
    end;

    If Nm = 'TRANSFERBTN' then
    begin
      If UpperCase(FetchELm(RetNo, 'S11', 25)) = 'Y' // spousal
      then
      begin
        RNo := GetSpRetNo(RetNo);
        If RNo > 0 then
        begin
          ShowMessage('See Schedule 2 of spouse');
          OpenForm(RNo, 'S2', 6);
        end
        else
          ShowMessage('Spousal return not found');
        exit;
      end;

      // transfer from dependants
      If ((UpperCase(FetchELm(RetNo, 'S11', 25)) = 'N') // not spousal
        and (Length(FetchELm(RetNo, 'S11', 26)) = 9) and
        (Vl(FetchELm(RetNo, 'S11', 10)) > 0)) then
      begin
        RNo := GetRetNoFromSin(FetchELm(RetNo, 'S11', 26));
        If RNo > 0 then
        begin
          StoreElm(RNo, GetFormNo('TRANSF'), 1, 'Y');
          StoreElm(RNo, GetFormNo('TRANSF'), 70, '100');
          StoreElm(RNo, GetFormNo('TRANSF'), 79, 'Y');
          OpenForm(RNo, GetFormNo('TRANSF'), 0);
        end
        else
          ShowMessage('Return of that SIN not loaded');
      end
      else
        ShowMessage('SIN incorrect or not entered' + Chr(13) +
          'or No amount for transfer' + Chr(13) +
          'or Transfer was not set to Yes' + Chr(13) + ' ' + Chr(13) +
          'SIN is Optional, used only by program for automatic coupling.' +
          Chr(13) + 'You can use Direct transfer on the Dep-Transfer form.');
    end;
  end;

  // 20120205
  If FormName = 'S11PRV' then
  begin
    If (Nm = 'S11BTN') or (Nm = 'S11BTN2') then // 20120204
    begin
      OpenForm(RetNo, 'S11', 0);
    end;

    If Nm = 'TRANSFERBTN' then
    begin
      If UpperCase(FetchELm(RetNo, 'S11PRV', 25)) = 'Y' // spousal
      then
      begin
        RNo := GetSpRetNo(RetNo);
        If RNo > 0 then
        begin
          ShowMessage('See Provincial Schedule 2 of spouse');
          OpenForm(RNo, 'S2PRV', 6);
        end
        else
          ShowMessage('Spousal return not found');
        exit;
      end;
      // transfer from dependants
      If ((UpperCase(FetchELm(RetNo, 'S11PRV', 25)) = 'N') // not spousal
        and (Length(FetchELm(RetNo, 'S11PRV', 26)) = 9) and
        (Vl(FetchELm(RetNo, 'S11PRV', 10)) > 0)) then
      begin
        RNo := GetRetNoFromSin(FetchELm(RetNo, 'S11PRV', 26));
        If RNo > 0 then
        begin
          StoreElm(RNo, GetFormNo('PTRANSF'), 1, 'Y');
          StoreElm(RNo, GetFormNo('PTRANSF'), 70, '100');
          StoreElm(RNo, GetFormNo('PTRANSF'), 79, 'Y');
          OpenForm(RNo, GetFormNo('PTRANSF'), 0);
        end
        else
          ShowMessage('Return of that SIN not loaded');
      end
      else
        ShowMessage('SIN incorrect or not entered' + Chr(13) +
          'or No amount for transfer' + Chr(13) +
          'or Transfer was not set to Yes' + Chr(13) + ' ' + Chr(13) +
          'SIN is Optional, used only by program for automatic coupling.' +
          Chr(13) + 'You can use Direct transfer on the Dep-Transfer form.');
    end;

  end;

  If FormName = 'T778' then
  begin
    If Nm = 'T778IBTN' then
      ShowPdf(AppDir, 'T778I.pdf'); // 20150201
  end;

  If FormName = 'T929' then
  begin
    If Nm = 'T929IBTN' then
      ShowPdf(AppDir, 'T929I.pdf'); // 20150201
  end;

  If FormName = 'T183' then
  begin

    If Nm = 'E_SIGNATUREHELPBTN' then // 20200322
    begin
      ConnectToWeb('https://www.visualtax.com/e-signature.php');
      // 20200325    //20230315
      // ConnectToWeb('https://account.docusign.com/username#/username');
    end;

    // 20210407 Igor >>>
    If Nm = 'E_SIGNATUREREQUESTBTN' then
      RequestSignature(RetNo); // 20210408 Igor
    // 20210407 Igor <<<

    // 20190124
    If Nm = 'CHANGENOABTN' then
    begin
      OpenForm(RetNo, InfoFNo, 180);
    end;

    // 20200212
    If Nm = 'SETUPPDAACCOUNT' then
    Begin
      if (AllTrim(FetchELm(RetNo, 'T185', 27)) = '') Or
        (AllTrim(FetchELm(RetNo, 'T185', 15)) = '') Or
        (AllTrim(FetchELm(RetNo, 'T185', 14)) = '') then
      Begin
        ShowMessage('You must complete the PAD dates and amount first');
        exit;
      End;
      OpenForm(RetNo, GetFormNo('PADINFO'), 0);
    End;

    // 20180206
    If Nm = 'TODAYSDATEBTN1' then
    begin
      StoreElm(RetNo, GetFormNo('T183'), 27,
        FormatDateTime('yyyy-mm-dd', Date));
      OpenForm(RetNo, GetFormNo('T183'), 0);
    end;

    If Nm = 'TODAYSDATEBTN2' then
    Begin
      StoreElm(RetNo, GetFormNo('T183'), 11, FormatDateTime('yyyy-mm-dd', Date)); // 20170307
      StoreElm(RetNo, GetFormNo('T183'), 12, TimeToHHMMDD(Now));  //20250319
      OpenForm(RetNo, GetFormNo('T183'), 0);
    end;
    // -----------------

    If Nm = 'MKDCNBTN' then // 20170103
    Begin
      if MessageDlg
        ('Normally you should change the DCN only if the original DCN was not accepted by Efile.'
        + Chr(13) + ' ' + Chr(13) +
        'If the return was already accepted, first you must click File -> Unlock'
        + Chr(13) +
        'and then Save the return with Efile Status of EF Ready for Efile on the Save As window.'
        + Chr(13) + ' ' + Chr(13) + 'Proceed?', mtConfirmation, [mbYes, mbNo],
        0) = mrYes then
      begin
        StoreElm(RetNo, GetFormNo('T183'), 21, '');
        Calc(RetNo, 'T183');
        OpenForm(RetNo, GetFormNo('T183'), 0);
      end;
    End;
    If Nm = 'T1DDBTN' then
      OpenForm(RetNo, GetFormNo('T1DD'), 0);
    If Nm = 'T183IBTN' then
      ShowPdf(AppDir, 'T183i.pdf'); // 20170213
    // OpenForm(RetNo,GetFormNo('T183I'),0);  //20160224 //20160304 Igor
  end; // t183

  If ExtractNonInstFormName(FormName) = 'RC62' then // 20160907 Igor
  begin
    If Nm = 'DEPENDBTN' then
      OpenForm(RetNo, 'DEPEND', 0);
    If Nm = 'TOTUCCBBTN' then
    begin
      ShowMessage('UCCB received for all dependants : ' +
        FormatFloat('###,##0.00', TotMultiple(RetNo, 'RC62', 22)));
    end;
  End;

  If ExtractNonInstFormName(FormName) = 'T5013' then // 20160907 Igor
  begin
    If Nm = 'T5013INSTBTN' then
      ShowPdf(AppDir, 'T5013-Inst-13e.pdf'); // 20131017
    If Nm = 'T2125BTN' then
      OpenForm(RetNo, 'T2125#1', 0);
    If Nm = 'T2125BTN2' then
      OpenForm(RetNo, 'T2125#1', 0);
    If Nm = 'T2121BTN' then
      OpenForm(RetNo, 'T2121#1', 0);
    If Nm = 'T2042BTN' then
      OpenForm(RetNo, 'T2042#1', 0);

    If Nm = 'T2125BTN2' then
      OpenForm(RetNo, 'T2125#1', 0);
    If Nm = 'T2121BTN2' then
      OpenForm(RetNo, 'T2121#1', 0);
    If Nm = 'T2042BTN2' then
      OpenForm(RetNo, 'T2042#1', 0);
    If Nm = 'ABILBTN' then
      OpenForm(RetNo, 'ABIL', 0);
    If Nm = 'T2038BTN' then
      OpenForm(RetNo, 'T2038', 0);
    If Nm = 'T776BTN' then
      OpenForm(RetNo, 'T776#1', 0);
    If Nm = 'T2017BTN' then
      OpenForm(RetNo, 'T2017', 0);
    If Nm = 'CAISBTN' then
    begin
      SomeList.clear; // :=TStringList.Create;
      SomeList.Add('T1163');
      SomeList.Add('T1273');
      SomeString := PopSomeList(SomeList, 'Select statement');
      // SomeList.Free; //20160301 Igor
      If SomeString > '' then
      begin
        If SomeString = 'T1163' then
        begin
          OpenForm(RetNo, 'T1163#1', 0);
          exit;
        end;
        If SomeString = 'T1273' then
        begin
          OpenForm(RetNo, 'T1273#1', 0);
          exit;
        end;
      end;
    end;
  end;

  If FormName = 'T2038' then
  begin
    If Nm = 'T2038BTN' then
      ShowPdf(AppDir, 'T2038I.pdf'); // 20150117
    exit;
  end;

  If FormName = 'T1198' then
  begin
    If Nm = 'T1198IBTN' then
      ShowPdf(AppDir, 'T1198I.pdf'); // 20200208
    exit;
  end;

  If FormName = 'TDD' then // 20200212
  begin
    if Nm = 'TDDBTN' then
      ConnectToWeb('https://www.tpsgc-pwgsc.gc.ca/recgen/pdf/canada-eng.pdf');
    // 20200212
    exit;
  end;



  If ExtractNonInstFormName(FormName) = 'CONSENT' then // 20200211
  begin
    If Nm = 'EFILECONSENTBTN' then
    Begin
      ExecuteForm(TEfileConsentT1_2026); // 20200211
    End;
  end;

  If ExtractNonInstFormName(FormName) = 'TL2' then // 20160907 Igor
  begin
    If Nm = 'GST370BTN' then
    begin
      OpenForm(RetNo, 'GST370', 0);
    end;
  end;

  If ExtractNonInstFormName(FormName) = 'T777' then // 20160907 Igor
  begin

   If Nm = 'AIIPBTN' then
      GetAiipHelp;
    If Nm = 'GST370BTN' then
    begin
      OpenForm(RetNo, 'GST370', 0);
    end;
    If Nm = 'TL2BTN' then
    begin
      OpenForm(RetNo, 'TL2#1', 130);
    end;
    If Nm = 'T2200BTN' then
    begin
      OpenForm(RetNo, 'T2200#1', 0);
    end;
    If Nm = 'TOOLEXPBTN' then
    begin
      OpenForm(RetNo, 'TOOLEXP', 0);
    end;
    If Nm = 'T4044BTN' then
    begin
      MainFormT1.T4044GuideEmploymentExpenses1Click(Application);
    end;
    If (Nm = 'AUTO777BTN1') or (Nm = 'AUTO777BTN2') or (Nm = 'AUTO777BTN3') or
      (Nm = 'AUTO777BTN4') then
    begin
      OpenForm(RetNo, 'AUTO777#1', 0);
    end;
    If Nm = 'T4044BTN2' then
    begin
      MainFormT1.T4044GuideEmploymentExpenses1Click(Application);
    end;
    If Nm = 'REFRESHT777BTNT' then
    begin
      OpenForm(RetNo, 'T777', 225);
    end; // 20200513
    If Nm = 'T777MOBBTN' then
    begin
      OpenForm(RetNo, 'T777MOB#1', 1);
    end; // 20221211
  end;

  {
  If ExtractNonInstFormName(FormName) = 'T777S' then // 20210117
  begin
    If (Nm = 'T4044BTN') or (Nm = 'T4044BTN2') then
    begin
      MainFormT1.T4044GuideEmploymentExpenses1Click(Application);
    end;
    If (Nm = 'HOMEOFFICEBTN') then
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/services/tax/individuals/topics/about-your-tax-return/tax-return/completing-a-tax-return/deductions-credits-expenses/line-229-other-employment-expenses/work-space-home-expenses/what-changes.html');
  end;
  }

  If ExtractNonInstFormName(FormName) = 'T777' then // 20160907 Igor
  begin
    If (Nm = 'AUTOSBTN') then
    begin
      OpenForm(RetNo, 'AUTO777#1', 0);
    end;
    If Nm = 'AIIPBTN' then
      GetAiipHelp;
  end;

  If ExtractNonInstFormName(FormName) = 'AUTOS' then // 20160907 Igor
  begin
    If Nm = 'T4044BTN2' then
    begin
      MainFormT1.T4044GuideEmploymentExpenses1Click(Application);
    end;
    If Nm = 'AIIPBTN' then
      GetAiipHelp;
    if Nm = 'PASSENGERVEHICLESBTN' then // 20200930
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/sole-proprietorships-partnerships/business-expenses/motor-vehicle-expenses/type-vehicle.html');
    //20230517
    If Nm='DIEPBTN' then ConnectToWeb('https://www.canada.ca/en/department-finance/news/2022/02/expansion-of-the-eligibility-for-tax-support-for-business-investments.html');
  end;

  If ExtractNonInstFormName(FormName) = 'AUTO777' then // 20160907 Igor
  begin
    If Nm = 'T4044BTN' then
    begin
      MainFormT1.T4044GuideEmploymentExpenses1Click(Application);
    end;
    If Nm = 'AIIPBTN' then
      GetAiipHelp;
  end;

  If ExtractNonInstFormName(FormName) = 'ASSETSB' then // 20230517
  begin
    If Nm = 'ASSETSBBTN' then  begin  OpenForm(RetNo, 'ASSETSB#1', 0);  end;
    If Nm = 'AIIPBTN' then GetAiipHelp;
    //20230517
    If Nm='DIEPBTN' then ConnectToWeb('https://www.canada.ca/en/department-finance/news/2022/02/expansion-of-the-eligibility-for-tax-support-for-business-investments.html');
  end;

  If ExtractNonInstFormName(FormName) = 'ASSETSB' then // 20160907 Igor
  begin
    If Nm = 'AIIPBTN' then
      GetAiipHelp;
    If (Nm = 'ASSETSHELPBTN') then
      ConnectToWeb('https://www.visualtax.com/assetsb.html'); // 20230219
    If (Nm = 'ASSETSBTN') then
    begin
      OpenForm(RetNo, 'ASSETS#1', 0);
    end;
    If Nm = 'POPULATEASSETSBTN' then
    begin
      if MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
      then
      begin
        PopulateAssets(RetNo);
        OpenForm(RetNo, 'ASSETSB#1', 0);
        ShowMessage('Done' + Chr(13) +
          'Descriptions and Date aquired assigned by program. Please revise.' +
          Chr(13) + 'And enter Y at the top of Asset #1 to post the CCA');
      end;
    end;
  end;

  If FormName = 'CCALIST' then
  begin
    If Nm = 'ASSETSBTN' then
    begin
      OpenForm(RetNo, 'ASSETSB#1', 0);
    end;
  end;

  If FormName = 'GST370' then
  begin
    If Nm = 'MULTT777FORGST370BTN' then
    Begin
      CopyFromT777Multiple(RetNo, GetFormNo('GST370'));
      OpenForm(RetNo, 'GST370', 101);
    end;
    If Nm = 'T777BTN' then
    begin
      OpenForm(RetNo, 'T777#1', 0);
    end;
    If Nm = 'TL2BTN' then
    begin
      OpenForm(RetNo, 'TL2#1', 0);
    end;
  end;

  If FormName = 'TOOLEXP' then
  begin
    If Nm = 'T4044BTN' then
    begin
      MainFormT1.T4044GuideEmploymentExpenses1Click(Application);
    end;
  end;

  If IsFormAClientLetter(FormName) then
  begin
    If Nm = 'LETTERDESIGNBTN' then
    begin
      MainFormT1.ClientLetter1Click(Sender);
      OpenForm(GetCurrentRetNo, FormName, 1);
    end;
    If Nm = 'PRINTLETTERBTN' then
      MainFormT1.PrintForm1Click(nil); // MainForm.CurrentPage1Click(Sender);
    If Nm = 'MSWORDBTN' then
      OpenMSWord;

    If Nm = 'SAVEBTN' then
    begin
      // wwDbRichEdit1.SaveToFile(GetClientLettersDir+'\'+MkClientLetterName(RetNo);
      // ShowMessage('Done');
      // SaveDialog.DefaultExt := '*RTF';
    end;
  end;

  If ExtractNonInstFormName(FormName) = 'ACBFRM' then // 20160907 Igor
  begin
    If Nm = 'SORT' then
    begin
      SortACBFrm(RetNo, FormName);
      CountDiagnostics(RetNo);
      OpenForm(RetNo, FormNo, 0);
      ShowTimedMsg('Sorted', 1000);
    end;
    If Nm = 'S3ACBBTN' then
      OpenForm(RetNo, 'S3ACB#1', 0);
    If Nm = 'ACBSUMBTN' then
      OpenForm(RetNo, 'ACBSUM#1', 0);
  end;

  If ExtractNonInstFormName(FormName) = 'S3ACB' then // 20160907 Igor
  begin
    If Nm = 'ACBFRMBTN' then
      OpenForm(RetNo, 'ACBFRM#1', 0);
  end;

  If FormName = 'DON' then
  begin
    If Nm = 'TRANSFERTOSPOUSEBTN' then
    begin
      If ret[RetNo].CouplingSw = false then
      begin
        ShowMessage('You must be in coupling mode. No transfer done');
        exit;
      end;

      If GetSpRetNo(RetNo) > 0 then
      begin
        If TransferDonations(RetNo, GetSpRetNo(RetNo)) = true then
        begin
          RecalcEverything(RetNo);
          // OpenForm(RetNo,GetFormNo('DON'),0);
          If GetSpRetNo(RetNo) > 0 then
            RecalcEverything(GetSpRetNo(RetNo));
          OpenForm(GetSpRetNo(RetNo), 'DON', 0);
        end;
      end;
    end;
  end;

  If FormName = 'MEDICAL' then
  begin
    If Nm = 'SORT' then
    begin
      SortMedical(RetNo, FormName);
      ShowTimedMsg('Medical Sorted and matched', 1000);
    end;
    If Nm = 'MEDPRVBTN' then
      OpenForm(RetNo, 'MEDPRV', 0);

    If Nm = 'TRANSFERTOSPOUSEBTN' then
    begin
      If TransferMedical(RetNo, GetSpRetNo(RetNo)) = true then
      begin
        OpenForm(RetNo, 'MEDICAL', 0);
        CalcAll(RetNo);
        OpenForm(GetSpRetNo(RetNo), 'MEDICAL', 0);
      end;
    end;
  end;

  // 20170322
  If FormName = 'REFILEQ' then // 20170320
  begin

    If Nm = 'CREATEREFILERETURNBTN' then
    Begin
     s := InitializeRefileReturn(RetNo); //,FetchElm(RetNo,'REFILEQ')); //20240606
     //s := InitializeRefileReturn(RetNo,FetchElm(RetNo,'REFILEQ',102)); //20240606
    End;

    If Nm = 'BEFOREREFILEBTN' then
      ConnectToWeb('www.visualtax.com/REFILE.php'); // 20200111 php not ASP

    If Nm = 'REFILEBTN' then // ReFILE Button
    Begin
      // 20170402
      if Length(FetchELm(RetNo, 'REFILEQ', 101)) <> 13 then
      begin
        ShowMessage('Please complete the DCN first');
        exit;
      end;

      // 20180415
      if UpperCase(LeftStr(FetchELm(RetNo, 'REFILEQ', 101), 5)) <>
        UpperCase(GetEfilerNo) then
      begin
        if MessageDlg
          ('The DCN does not seem correct. The first 5 characters are not your Efiler Number.'
          + Chr(13) + 'Accept as entered?', mtInformation, [mbYes, mbNo], 0) = mrNo
        then
          exit;
        exit;
      end;

      { //20180415
        if UpperCase(LeftStr(FetchElm(RetNo,'REFILEQ',101),5))<>UpperCase(GetEfilerNo) then
        begin
        ShowMessage('The DCN does not seem correct. The first 5 characters must be your Efiler Number');
        Exit;
        end;
      }

      if FetchELm(RetNo, 'REFILEQ', 16) = '' then
      begin
        ShowMessage('Check the box Ready for Efile first');
        exit;
      end;

      if (FetchELm(RetNo, 'REFILEQ', 7) = '') Or
        (FetchELm(RetNo, 'REFILEQ', 10) = '')
      // Or (FetchElm(RetNo,'REFILEQ',9)='')
      then
      begin
        ShowMessage('Please complete the Confirmation section first');
        exit;
      end;

      if Length(FetchELm(RetNo, 'REFILEQ', 101)) = 13 then
        StoreElm(RetNo, GetFormNo('T183'), 21, FetchELm(RetNo, 'REFILEQ', 101));
      // 20170327

      s := ValidateRefileReturn(RetNo, FetchELm(RetNo, 'REFILEQ', 101));
      if s > '' then
        ShowMessage(s)
      Else
      Begin
        If FetchELm(RetNo, 'REFILEQ', 16) > '' then
          StoreElm(RetNo, GetFormNo('INFO'), 79, 'X');

        MainFormT1.EOLClick(Sender); // 20170327
      End;
    end;

    // If Nm='SNAPSHOTBTN' then CreateSnapshot(RetNo,'B');
    If Nm = 'VARIANCEBTN' then
    Begin
      // MainFormT1.CreatetheT1ADJform1Click(Application);
      CreatetheREFILEVForm(RetNo); // CreatetheT1ADJform(RetNo);
      FNo := GetFormNo('REFILEV#1');
      // OpenForm(RetNo,FNo,0);  //20170404
      ret[RetNo].FormHasData['REFILEV#1'] := true;
      Calc(RetNo, 'REFILEV#1'); // 20170404
      OpenForm(RetNo, FNo, 0);
    End;
  end;

  If ExtractNonInstFormName(FormName) = 'T1ADJ' then // 20160907 Igor
  begin
    If Nm = 'T1ADJBTN' then
      ShowPdf(AppDir, 'T1ADJI.pdf'); // 20150201

    If Nm = 'CREATESNAPSHOTBTN' then
      MainFormT1.TakeShapshotforT1Adj1Click(Application);
    If Nm = 'SHOWFULLVARIANCEBTN' then
    Begin
      MainFormT1.CreatetheT1ADJform1Click(Application);
      Calc(RetNo, 'T1ADJ#1'); // 20170430
      OpenForm(RetNo, GetFormNo('T1ADJ#1'), 0); // 20170430
    End;

    If Nm = 'CLEARFORMBTN' then
    begin
      if MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
      then
        MainFormT1.ClearCurrentFormClick(Application);
    end
  end;

  If ExtractNonInstFormName(FormName) = 'MEDSUPL' then // 20160907 Igor
  begin
    If Nm = 'SORT' then
    begin
      SortMedical(RetNo, FormName);
      ShowTimedMsg('Medical Sorted and matched', 1000);
    end;
  end;

  If FormName = 'CFR' then
  begin
    If Nm = 'CFRMINHELPBTN' then  //20260228
    Begin
     ShowMessage('The error comes from the T1-2024 most likely from a rollover done very early in 2024'
      +Chr(13)+'  '
      +Chr(13)+ 'If you are getting a lot of erroneous values, do the following:'
      +Chr(13)+ 'Open the VT-2024 program and on its T1-2024 module, click Utilities'
      +Chr(13)+ 'and then Recalculate and save all returns.'
      +Chr(13)+'  '
      +Chr(13)+ 'This could eliminate the Minimum Tax Carryover diagnostic'
      +Chr(13)+ 'as it will calculate the proper CarryOver amount if any for the 2025 rollover.');
    end;
    If Nm = 'DECEASEDBTN' then OpenForm(RetNo, 'DEATH', 0);
  end;

  If FormName = 'T2222' then
  begin
    If Nm = 'T2222_3BTN' then
      ShowPdf(AppDir, 'T2222i.pdf'); // 20150201
  end;

  If (ExtractNonInstFormName(FormName) = 'T2125') // 20160907 Igor
    or (ExtractNonInstFormName(FormName) = 'T2121') // 20160907 Igor
    or (ExtractNonInstFormName(FormName) = 'T2042') // 20160907 Igor
  then
  begin
    If Nm = 'AUTOSBTN' then
      OpenForm(RetNo, 'AUTOS#1', 0);
  end;

  If (ExtractNonInstFormName(FormName) = 'T2125') // 20160907 Igor
    or (ExtractNonInstFormName(FormName) = 'T2121') // 20160907 Igor
    or (ExtractNonInstFormName(FormName) = 'T2042') // 20160907 Igor
    or (ExtractNonInstFormName(FormName) = 'T1175') // 20160907 Igor
    or (ExtractNonInstFormName(FormName) = 'T1175H') // 20160907 Igor
    or (ExtractNonInstFormName(FormName) = 'T776') // 20160907 Igor
  then
  begin
    If (Nm = 'AUTOSBTN') or (Nm = 'AUTOSBTN2') then
      OpenForm(RetNo, 'AUTOS#1', 0);
    If (Nm = 'ASSETSBTN') OR (Nm = 'ASSETSBTN1') or (Nm = 'ASSETSBTN2') then  //20230422
      OpenForm(RetNo, 'ASSETSB#1', 0);
  end;

  If (ExtractNonInstFormName(FormName) = 'T2125') then // 20160907 Igor
  begin
    If Nm = 'YEARLYSUMBTN' then
      OpenForm(RetNo, 'T2125SUM#1', 0);
  end;

  If (ExtractNonInstFormName(FormName) = 'T2121') then // 20160907 Igor
  begin
    If Nm = 'YEARLYSUMBTN' then
      OpenForm(RetNo, 'T2121SUM#1', 0);
  end;

  If (ExtractNonInstFormName(FormName) = 'T2042') then // 20160907 Igor
  begin
    If Nm = 'YEARLYSUMBTN' then
      OpenForm(RetNo, 'T2042SUM#1', 0);
  end;

  If (ExtractNonInstFormName(FormName) = 'T776') then // 20160907 igor
  begin
    If Nm = 'YEARLYSUMBTN' then
      OpenForm(RetNo, 'T776SUM#1', 0);
  end;

  If (ExtractNonInstFormName(FormName) = 'T1163') then // 20160907 Igor
  begin
    If Nm = 'YEARLYSUMBTN' then
      OpenForm(RetNo, 'T1163SUM#1', 0);
  end;

  If ExtractNonInstFormName(FormName) = 'T1273' then // 20160907 Igor
  begin
    If Nm = 'T1273A1BTN' then
      OpenForm(RetNo, 'T1273A1#1', 0);
    If Nm = 'YEARLYSUMBTN' then
      OpenForm(RetNo, 'T1273SUM#1', 0);
  end;

  If ExtractNonInstFormName(FormName) = 'T1273' then // 20160907 Igor
  begin
    If Nm = 'T1273A2BTN' then
      OpenForm(RetNo, 'T1273A2#1', 0);
  end;

  If ExtractNonInstFormName(FormName)='T1134' then //20230811 Igor >>>
  begin
    if Nm='T1134EFILEBTN' then
    begin
      //20251223 Igor >>>
      //ShowMessage('T1134 Efile is not currently available');
      //Exit;
      //20251223 Igor <<<

      if FetchElm(RetNo,'T1134',26)>''  then
      Begin
        ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
        Exit;
      End;

      ExecuteForm(TEfileT1134T1_2026);
      Exit;
    end;
    If Nm='T1134FILLBTN' then
    begin
      ConnectToWeb('https://www.canada.ca/content/dam/cra-arc/migration/cra-arc/E/pbg/tf/t1134/t1134-fill-17e.pdf');
      Exit;
    end;
    If Nm='T1134IBTN' then
    begin
      ShowPdf(AppDir,'T1134I.pdf');
      Exit;
    end;
    If Nm='FILLABLET1134BTN' then
    begin
      ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/forms-publications/forms/t1134.html');
      Exit;
    end;
    If Nm='T1134SLBTN' then
    begin
      OpenForm(RetNo,GetFormNo('T1134S#1'),1);
      Exit;
    end;
  end; //20230811 Igor <<<
end;

Function GetDFMFileName(FName: String): String;
Var
  FormsDir: String;
begin
  FormsDir := GetDfmFormsDir;
  Result := FormsDir + '\' + 'u' + ExtractNonInstFormName(FName) + '.DFM';
end;

Function GetLastYearDFMFileName(FName: String): String;
Var
  FormsDir: String;
begin
  Result := '';
  FormsDir := OptRec.Dir_PgmLastYr;
  If SysUtils.DirectoryExists(FormsDir) = false then
  begin
    ShowMessage('Program was not installed in ' + FormsDir + ' last year' +
      Chr(13) + 'Check Configure | General Options | Data Directories | Last year');
    exit;
  end;

  FName := ExtractNonInstFormName(FName);
  // if (FName = 'RC62')    or
  // (FName = 'T3MULT')  or
  // (FName = 'T4')      or
  // (FName = 'T4A')     or
  // (FName = 'T4AOAS')  or
  // (FName = 'T4ARCA')  or
  // (FName = 'T4AP')    or
  // (FName = 'T4E')     or
  // (FName = 'T4PS')    or
  // (FName = 'T4RIF')   or
  // (FName = 'T4RSP')   or
  // (FName = 'T5004')   or
  // (FName = 'T5MULT')  or
  // (FName = 'T5007')   or
  // (FName = 'T5008')   or
  // (FName = 'T5013')   or
  // (FName = 'T5006') or       //20131127
  // (FName = 'T101')    or
  // (FName = 'T2202') then
  // begin
  // FormsDir:=GetDfmFormsDir;
  // //20111227
  // // if (FName = 'RC62') or (FName = 'T4') or (FName = 'T4A') then
  // //     Result:= FormsDir+'\'+'u2010'+FName+'.DFM' //use modified 2009 forms
  // // else
  // Result:= FormsDir+'\'+'u'+FName+'.DFM'; //just use this years forms as they are the same
  // end
  // else
  Result := FormsDir + '\' + 'u' + FName + '.DFM';
end;

//20250918 Igor >>>
function TFormT1_2026.ValidateField(FieldId: Integer; var Value: string): Boolean;

  procedure ValidateDoubleCheckbox(aYesFieldIndex: Integer; aNoFieldIndex: Integer);
  begin
    if (FieldId = aYesFieldIndex) and (Value.Equals('Y')) then
      if FetchElm(RetNo, GetFormNo(FormName), aNoFieldIndex).Equals('Y') then
        StoreElm(RetNo, GetFormNo(FormName), aNoFieldIndex, 'N');

    if (FieldId = aNoFieldIndex) and (Value.Equals('Y')) then
      if FetchElm(RetNo, GetFormNo(FormName), aYesFieldIndex).Equals('Y') then
        StoreElm(RetNo, GetFormNo(FormName), aYesFieldIndex, 'N');
  end;

var
//20250918 Igor <<<
  i: Integer;
  SelectedString: string;
begin
  Result := true;

  If FormName = 'INFO' then
  begin
    case FieldId of
      3, 4:
        begin
          Result := ValidSin(Value);
          If Result = false then
          Begin
            If ret[RetNo].Province <> 'ZZ' then
              ShowMessage
                ('Enter a 9 digit valid SIN, or 9 zeros or 9 characters if Non-resident');
          end;
          exit;
        end;
      9, 59: { birthdates }
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
      65: { birthdates }
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit; // 20120423
        end;

      153: // SignatureDate
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit; // 20121201
        end;

      171: { Date of move }
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit; // 20121201
        end;

      24: { birthdates }
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      124: { due date }
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 3);
          exit;
        end;
      25, 27: { Day res }
        begin
          Result := InNumRangeOnly(Value, 0, 31);
          exit;
        end; // 0???
      26, 28: { MM res }
        begin
          Result := InNumRangeOnly(Value, 0, 12);
          exit;
        end;

      36:
        begin
          Result := XOnly(Value);
          exit;
        end;
      37:
        begin
          Result := XOnly(Value);
          exit;
        end;
      46:
        begin
          Result := XOnly(Value);
          exit;
        end;
      58:
        begin
          Result := XOnly(Value);
          exit;
        end;
      73:
        begin
          Result := XOnly(Value);
          exit;
        end;
      85:
        begin
          Result := XOnly(Value);
          exit;
        end;
      86:
        begin
          Result := XOnly(Value);
          exit;
        end;
      88:
        begin
          Result := XOnly(Value);
          exit;
        end;

      112: { signing date }
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 7);
          exit;
        end;

      192: // expiry date  //20190126
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 7);
          exit;
        end;
    end; { Case }
  end

  //20251223 Igor >>>
  else if FormName.Equals('T106') then
  begin
    case FieldId of
     31:
       begin
         AutoFormatDate(Value);
         Result:= InDateYYYYMMDDonly(Value, AppYearInt + 2);
         Exit;
       end;
    end;
  end
  //20251223 Igor <<<

  //20240715 Igor >>>
  else if ExtractNonInstFormName(FormName) = 'T2057' then // 20240603
  begin
    case FieldId of
      6, 7, 35, 34, 38, 44, 39:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
          exit;
        end;
    end;
  end

  else if ExtractNonInstFormName(FormName) = 'T2059' then
  begin
    case FieldId of
      6, 7, 35, 34, 39, 44, 52, 60:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
    end;
  end

  else if LeftStr(FormName,4) = 'UHT#' then
  begin
    case FieldId of
      115,116,117,118,129:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt+1);
        end;
    end;
  end
  //20240715 Igor <<<

  //20240723 Igor >>>
  else if LeftStr(FormName,4) = 'T217' then
  begin
    case FieldId of
      11, 16, 20:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt+1);
        end;
    end;
  end
  //20240723 Igor <<<

  else if FormName = 'T2200S' then
  begin
    case FieldId of
      17,18,21:            //20240226
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  // 20141208
  else if FormName = 'SK479' then
  begin
    case FieldId of
      28, 32, 36, 40, 44, 48, 52, 56:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit; // 20150709 ?
        end;
    end; { case }
  end

  //20250918 Igor >>>
  else if FormName = 'YT479' then
  begin
    case FieldId of
      38, 39: ValidateDoubleCheckbox(38, 39);
    end;
  end
  //20250918 Igor <<<

   // 20141208
  else if FormName = 'GST370' then
  begin
    case FieldId of
      25, 50:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit; // 20150709 ?
        end;
    end; { case }
  end

  // 20141208
  else if FormName = 'RC381' then
  begin
    case FieldId of
      129, 130:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit; // 20150709 ?
          // Result:=InDateYYYYMMDDOnly(Value,IntToStr(StrToInt(AppYear)+1),RetNo,FormName,FieldId);exit;
        end;
    end; { case }
  end

  else if FormName = 'S12BC' then
  begin
    case FieldId of
      1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91,
        96, 101, 106, 111, 116, 121, 126, 131, 136, 141, 146, 151, 156:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

 (*
  else if FormName = 'S12SK' then
  begin
    case FieldId of
      1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 76, 81, 86, 91,
        96, 101, 106, 111, 116, 121, 126, 131, 136, 141, 146, 151, 156:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end
 *)
  else if FormName = 'T1153' then // 20140208
  begin
    case FieldId of
      16:
        AutoFormatDate(Value);
    end; { case }
  end

  // 20160430 Igor
  // 20160411
  else if ExtractNonInstFormName(FormName) = 'T2201' then // 20160907 Igor
  begin
    case FieldId of
      11:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if FormName = 'T2204' then // 20130302
  begin
    case FieldId of
      35, 36:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if FormName = 'S8' then // 20130302
  begin
    case FieldId of
      22:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'S2' then
  begin
    case FieldId of
      43:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'ADOPT' then
  begin
    case FieldId of
      2:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'S7' then
  begin
    case FieldId of
      24, 16:
        begin
          Result := XOnly(Value);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'S8' then
  begin
    case FieldId of
      12:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
      17:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'ACBFRM' then // 20160907 igor
  begin
    case FieldId of
      15, 24, 33, 42, 51, 60, 69, 78, 87, 96, 105, 114, 123, 132, 141, 150, 159,
        168, 177, 186, 195, 204, 213, 222, 231, 240, 249, 258, 267, 276:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      285, 294, 303, 312, 321, 330, 339, 348, 357, 366, 375, 384, 393,
        402, 411, 420:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'BC479' then
  begin
    case FieldId of
       38,39:  //20231212
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T4' then
  begin
    case FieldId of
      7, 18:
        begin
          Result := XOnly(Value);
          exit;
        end;
      { 20:  begin Result :=InValuesOnly('NL,PE,NS,NB,QC,ON,MB,SK,AB,BC,NT,YT,NU,ZZ',
        RetNo,FormName,FieldId,Value);exit;end; }
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'T4RSP' then
  begin
    case FieldId of
      3:
        begin
          Result := XOnly(Value);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'T5' then
  begin
    case FieldId of
      3:
        begin
          Result := InValuesOnly('Y', Value);
          exit;
        end;
      5:
        begin
          Result := InValuesOnly('1,2,3', Value);
          exit;
        end;
      2:
        begin
          Result := InNumRangeOnly(Value, 0, 100);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'T5004' then
  begin
    case FieldId of
      69:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1161' then
  begin
    case FieldId of
      5:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      7, 11, 15, 19, 23, 27, 31, 35, 39, 43:
        begin
          Result := InValuesOnly('C,F', Value);
          exit;
        end;
    end; { Case }
  end

  (*
    else if ExtractNonInstFormName(FormName) = 'T626' then
    begin
    case FieldId of
    8,9:begin AutoFormatDate(Value);Result := InDateYYYYMMDDonly(Value,AppYearInt+1);exit;end;
    end; {Case}
    end
  *)

  else if ExtractNonInstFormName(FormName) = 'T1243' then
  begin
    case FieldId of
      5:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      8, 15, 22, 29, 36, 43, 50, 57, 64, 71:
        begin
          Result := InValuesOnly('C,F', Value);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'DEPEND' then
  begin
    case FieldId of
      10, 25, 40, 55, 70, 85, 100, 115, 130:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
      // 19,34,49,64,79,94,109,124,139: begin Result :=InValuesOnly('Y,N',RetNo,FormName,FieldId,Value);exit;end;
    end; { Case }
  end

  else if FormName = 'NS428' then
  begin
    case FieldId of
      88, 92, 96, 100:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'RC71' then
  begin
    case FieldId of
      27, 5:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'NU428' then
  begin
    case FieldId of
      158, 162, 166, 170, 174, 178, 182, 186:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'CTB' then
  begin
    case FieldId of
      3, 8, 13, 18, 23, 28, 33, 38:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
      1:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
      71:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'MEDICAL' then
  begin
    case FieldId of
      1, 3, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85,
        90, 95, 100, 105:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'MEDSUPL' then // 20160907 Igor
  begin
    case FieldId of
      5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90,
        95, 100, 105:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'T664' then
  begin
    case FieldId of
      1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73,
        77, 81, 85, 89, 93, 97:
        begin
          Result := InValuesOnly('F,O', Value);
          exit;
        end;
      3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75,
        79, 83, 87, 91, 95, 99:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'MB479' then
  begin
    case FieldId of
      50, 51, 52, 53, 32:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'ON479' then
  begin
    case FieldId of
      42, 43, 44, 31:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1DD' then
  begin
    case FieldId of
      1:
        begin
          Result := InValuesOnly('X,0,1,2,3', Value);
          exit;
        end;
      29:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T183' then
  begin
    case FieldId of
      11: // ,22: //,23:   //20230215//20200212
        begin // 20161201
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
    end; { case }
  end

  // 20200212
  else if FormName = 'T185' then
  begin
    case FieldId of
      27, 15:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T776' then
  begin
    case FieldId of
      3, 6:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end
  else if ExtractNonInstFormName(FormName) = 'T776' then
  begin
    case FieldId of
      357:
        begin
          Result := XOnly(Value);
          exit;
        end;
    end; { case }
  end
  else if ExtractNonInstFormName(FormName) = 'T777' then
  begin
    case FieldId of
      1:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end

  else if FormName = 'T778' then
  begin
    case FieldId of
      7, 11, 15, 19, 23, 27, 31:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
      6, 10, 14, 18, 22, 26, 30:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1013' then
  begin
    case FieldId of
      106, 112, 118, 124:
        begin
          Result := InValuesOnly('1,2', Value);
          exit;
        end;
      108, 114, 120, 126:
        begin
          Result := InValuesOnly('1,2', Value);
          exit;
        end;
      110, 116:
        begin
          Result := InValuesOnly('1,2', Value);
          exit;
        end;
      129:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
      131:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'AUTHREP' then
  begin
    case FieldId of
      106, 112, 118, 124:
        begin
          Result := InValuesOnly('1,2', Value);
          exit;
        end;
      108, 114, 120, 126:
        begin
          Result := InValuesOnly('1,2', Value);
          exit;
        end;
      110, 116:
        begin
          Result := InValuesOnly('1,2', Value);
          exit;
        end;
      129:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
      131:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
          exit;
        end;
    end; { case }
  end

  // 20200214
  else if ExtractNonInstFormName(FormName) = 'CONSENT' then
  begin
    case FieldId of
      15, 23, 30, 37, 44, 55:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
    end; // case
    case FieldId of
      55:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if LeftStr(FormName, 5) = 'RC59#' then // not in use See Consent above
  begin
    case FieldId of
      15, 22, 23, 29, 30, 36, 37, 43, 44, 55: // 20171212
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1M' then
  begin
    case FieldId of
      13, 16:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1033' then
  begin
    case FieldId of
      32:
        begin
          Result := XOnly(Value);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T2042' then
  begin
    case FieldId of
      4, 5:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      24:
        begin
          Result := InNumRangeOnly(Value, 0, 100);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T2121' then
  begin
    case FieldId of
      4, 5:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      18:
        begin
          Result := InNumRangeOnly(Value, 0, 100);
          exit;
        end;
    end; { case }
  end

  else if (ExtractNonInstFormName(FormName) = 'ASSETSB') or
    (ExtractNonInstFormName(FormName) = 'ASETSB') // 20230405
  then
  begin
    case FieldId of
      137:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'AUTOS' then
  begin
    case FieldId of
      57, 60, 137:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'AUTO777' then
  begin
    case FieldId of
      57, 60, 137:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 30);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T2125' then
  begin
    case FieldId of
      4, 5:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      18:
        begin
          Result := InNumRangeOnly(Value, 0, 100);
          exit;
        end;
      514:
        begin
          Result := XOnly(Value);
          exit;
        end; // 20180204
    end; { case }
  end

  (* //20180204
    else if ExtractNonInstFormName(FormName) = 'T2125' then
    begin
    case FieldId of
    514: begin Result :=XOnly(Value);exit;end;
    end; {case}
    end
  *)

  else if ((ExtractNonInstFormName(FormName) = 'T1163') or
    (ExtractNonInstFormName(FormName) = 'T1273')) then
  begin
    case FieldId of
      215, 216, 217:
        begin
          Result := XOnly(Value);
          exit;
        end;
      213, 214:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if FormName = 'T2222' then
  begin
    case FieldId of
      30, 40, 45, 50, 55:
        begin
          Result := InValuesOnly('A,B', Value);
          exit;
        end; // 20120130
      22, 23, 43, 44, 48, 49, 53, 54, 58, 59:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt);
          exit;
        end;
      111, 119, 127, 135, 143, 151, 159, 167, 175, 183, 191, 199, 207, 215, 223,
        231, 239, 247, 255, 263:
        begin
          Result := InValuesOnly('A,B', Value);
          exit;
        end;
      112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216, 224,
        232, 240, 248, 256, 264:
        begin
          Result := InValuesOnly('F,M,V', Value);
          exit;
        end;
    end; { Case }

  end

  else if ExtractNonInstFormName(FormName) = 'TL2' then
  begin
    case FieldId of
      5, 6:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'BANKRPT' then
  begin
    case FieldId of
      1:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { case }
  end
  else if ExtractNonInstFormName(FormName) = 'CCA1' then
  begin
    case FieldId of
      2:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end
  else if ExtractNonInstFormName(FormName) = 'TRANSF' then
  begin
    case FieldId of
      1, 79:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
      23, 24, 25, 26, 27, 28:
        begin
          Result := InNumRangeOnly(Value, 0, 12);
          exit;
        end;
      11, 12, 13, 14, 15, 16:
        begin
          Result := XOnly(Value);
          exit;
        end;
      101, 102, 103, 104, 105, 106:
        begin
          Result := XOnly(Value);
          exit;
        end;
    end; { case }
  end
  else if ExtractNonInstFormName(FormName) = 'GSTC' then
  begin
    case FieldId of
      1, 3:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
    end; { case }
  end
  else if ExtractNonInstFormName(FormName) = 'SUPPL' then
  begin
    case FieldId of
      2, 5, 7:
        begin
          Result := InValuesOnly('Y,N', Value);
          exit;
        end;
      6:
        begin
          Result := InValuesOnly('1,2,3', Value);
          exit;
        end;
    end; { case }
  end
  else if ExtractNonInstFormName(FormName) = 'FPENS' then
  begin
    case FieldId of
      2:
        begin
          Result := InValuesOnly('1,2,3', Value);
          exit;
        end;
    end; { case }
  end
  //20230811 Igor >>>
  else If ExtractNonInstFormName(FormName) = 'T1134' then
  begin
    case FieldId of
      19,20:Begin AutoFormatDate(Value); Result:=InDateOnly(Value,AppYearInt+1);end;
      147,33,34,62,63:Begin AutoFormatDate(Value); Result:=InDateOnly(Value,AppYearInt+1);end;
    end; {Case}
  end
  else if ExtractNonInstFormName(FormName) = 'T1134S' then //20220811 Igor
  begin
    case FieldId of
      //33,34: begin AutoFormatDate(Value); Result:=InDateOnly(Value,AppYearInt-5,AppYearInt+2);exit;end;  //20180629 //20230411 Igor
      62,63: begin AutoFormatDate(Value); Result:=InDateOnly(Value,AppYearInt+2);exit;end;
    end; {case}
  end;
  //20230811 Igor <<<
end;

function TFormT1_2026.IsProtectedField(MyEditBox: TvtEdit): Boolean;
begin
  Result := (MyEditBox.vtDataSource = vtCalc) or
    ((FormName = 'INVOICE') and (IsInvoiceLocked(RetNo)) and
    (MyEditBox.FieldId <> 285));
end;

procedure TMyChildT1_2026.FormKeyPress(Sender: TObject; var Key: Char);
var
  FieldId: Integer;
  MyEditBox: TvtEdit;
  MyScrollBox: TvtScrollBox;
begin
  (* when called from non-MDI???
    Sender is *not* the active control!!!
  *)
  If ret[RetNo].IsLastYearReturn then
  begin
    Key := #0;
    exit; // 20110220
  end;

  if (ActiveControl is TvtEdit) then
  begin
    MyEditBox := TvtEdit(ActiveControl);
    FieldId := MyEditBox.FieldId; // GetFieldId(MyEditBox.Name);
    MyScrollBox := ActiveForm;

    If IsInTapesList(RetNo, MyScrollBox.FormName, FieldId) then
    Begin
      Key := Chr(0);
      ShowMessage('Adding tape in effect. See Audit Wizard');
      exit; // ?
    end;
  end;

  inherited;
end;

procedure TMyChildT1_2026.AutoCompleteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lastKey := Key;
end;

function TMyChildT1_2026.getvtEditbyName(eBoxName: string): TvtEdit;
var
  i, j: Integer;
  eBox: TvtEdit;
  sBox: TvtScrollBox;
  // pControl : TPageControl;
  tSheet: TTabSheet;
  FName: string;
begin
  Result := nil;

  tSheet := Pages.ActivePage;
  // showmessage(tSheet.caption);
  sBox := GetScrollbox(tSheet.Caption);
  // showmessage(sBox.vtScrollBoxId);
  for j := 0 to sBox.ComponentCount - 1 do
  begin
    if (sBox.Components[j] is TvtEdit) and
      (UpperCase(sBox.Components[j].Name) = UpperCase(eBoxName)) then
    begin
      eBox := sBox.Components[j] as TvtEdit;
      // showmessage(ebox.name);
      Result := eBox;
      exit;
    end; // end sBox.Components[j] is TvtEdit
  end; // end sBox.ComponentCount

end;

function TMyChildT1_2026.getFieldByTabOrder(tOrder: Integer): TWinControl;
var
  i, j: Integer;
  resultBox: TWinControl;
  sBox: TvtScrollBox;
  pControl: TPageControl;
  tSheet: TTabSheet;
  FName: string;
begin
  Result := nil;

  tSheet := Pages.ActivePage;
  // showmessage(tSheet.caption);
  sBox := GetScrollbox(tSheet.Caption);
  // showmessage(sBox.vtScrollBoxId);
  for j := 0 to sBox.ControlCount - 1 do
  begin
    if (sBox.Controls[j] is TWinControl) and
      ((sBox.Controls[j] as TWinControl).TabOrder = tOrder) then
    begin
      resultBox := sBox.Controls[j] as TWinControl;
      // showmessage(ebox.name);
      Result := resultBox;
      exit;
    end; // end sBox.Components[j] is TvtEdit
  end; // end sBox.ComponentCount

end;

function TMyChildT1_2026.GetHeaderFrame: TFrame; // 20160227 Igor
begin
  Result := MyFormHeaderFrame;
end;

function TMyChildT1_2026.GetMonitorFrame: TFrame; // 20160227 Igor
begin
  Result := MyMonitorFrame;
end;

function TFormT1_2026.ReplaceString(FieldId: Integer;
  NewString: string): Boolean;
begin
  Result := inherited ReplaceString(FieldId, NewString);
  if Result then
    CalcAll(RetNo); // T1 special
end;

constructor TMyChildT1_2026.CreateNew(AOwner: TComponent; RNo: Integer);
var
  j: Integer; // 20160519 Igor
begin
  inherited;
  FormClass := TFormT1_2026;
  Caption := GetReturnCaption(RetNo);
  color := GetRetColor(RetNo); // $00AC7400; //GetRetColor(RetNo);
  Name := 'R' + IntToStr(RetNo);

  FMyFormHeaderFrame := THeaderFrameT1_2026.Create(self);
  with MyFormHeaderFrame do
  begin
    Name := 'P' + IntToStr(RetNo); // Name:='P2';  //20110224
    Parent := self; // MyPageControl;
    Height := 25; // 30;
    Align := alTop;
    color := $00AC7400; // GetRetColor(RetNo);  //$00AC7400;
    // 20160519 Igor >>>
    ParentBackGround := false;
    for j := 0 to ComponentCount - 1 do
    Begin
      if Components[j] is TPanel then
        (Components[j] as TPanel).ParentBackGround := false;
    End;
    // 20160519 Igor <<<

    If ret[RetNo].IsLastYearReturn then
      color := RGB(255, 255, 255);
    // AppYearlbl.caption := AppYear;
    ReturnNameLbl.Caption := '[Un-Named return]';
    CloseTabBtn.OnClick := CloseActiveForm;
    SectionBtn.OnClick := SectionBtnClick;
    MyChild := self;
  end;

  FMyMonitorFrame := TMonitorFrameT1_2026.Create(self);
  With MyMonitorFrame do
  begin
    Parent := self;
    Height := 23;
    Align := alBottom;
    // 20160519 Igor >>>
    ParentBackGround := false;
    for j := 0 to ComponentCount - 1 do
    Begin
      if Components[j] is TPanel then
        (Components[j] as TPanel).ParentBackGround := false;
    End;
    // 20160519 Igor <<<
  end;
  // UpdateChildTaxPanel; - not now
end;

procedure TMyChildT1_2026.FormPaint(Sender: TObject);
begin
  if RetNo > 0 then
    Caption := GetReturnCaption(RetNo);
end;

Function TFormT1_2026.SetEditBoxBackColor(MyEditBox: TvtEdit): TColor;
begin
  (* only additional checks here
  *)
  Result := clBlack;
  // if NoFormInfo(MyEditBox) then exit;
  ChangeProperties(MyEditBox, GetFieldId(MyEditBox.Name));

  // 20220121 Igor >>>
  (* If IsInTapesList(RetNo,FormName,GetFieldId(MyEditBox.Name)) then
    Result := TapeColor //20220121 Igor
    else *)
  // 20220121 Igor <<<
  Result := inherited SetEditBoxBackColor(MyEditBox);
end;

procedure TMyChildT1_2026.UpdateChildTaxPanel;
Var
  SpRetNo: Integer;
  FamilyTotal: Real;
begin
  If RetInMem = 0 then
  begin
    with MyMonitorFrame do
    begin
      TotIncPanel.Caption := '';
      NetIncPanel.Caption := '';
      TxblIncPanel.Caption := '';
      TaxPayablePanel.Caption := '';
      BalancePanel.Caption := '';
      FamilyPanel.Caption := '';
    end;
    exit;
  end
  else If IsRetNoListed(RetNo) then
  begin
    FormatSettings.DecimalSeparator := '.';
    MyMonitorFrame.TotIncPanel.Caption := FormatFloat('##,###,###.00',
      ret[RetNo].Lnn[15000]);
    MyMonitorFrame.NetIncPanel.Caption := FormatFloat('##,###,###.00',
      ret[RetNo].Lnn[23600]);
    MyMonitorFrame.TxblIncPanel.Caption := FormatFloat('##,###,###.00',
      ret[RetNo].Lnn[26000]);
    MyMonitorFrame.TaxPayablePanel.Caption := FormatFloat('##,###,###.00',
      ret[RetNo].Lnn[43500]);


    // Ret[RetNo].Balance := Vl(FetchElm(RetNo,'T1',429)); //20101114  does not help

    If ret[RetNo].Balance < 0 then
    begin
      MyMonitorFrame.BalanceLabel.Caption := 'Refund';
      MyMonitorFrame.BalancePanel.Caption := FormatFloat('##,###,###.00',
        ABS(ret[RetNo].Balance));
    end
    else
    begin
      MyMonitorFrame.BalanceLabel.Caption := 'Owing';
      MyMonitorFrame.BalancePanel.Caption := FormatFloat('##,###,###.00',
        ret[RetNo].Balance);
    end;
  end;

  MyMonitorFrame.FamilyPanel.visible := false;
  MyMonitorFrame.FamilyPanel.Caption := '';
  MyMonitorFrame.FamilyLabel.Caption;

  If (ret[RetNo].MarStatus < 3) and (GetSpRetNo(RetNo) > 0) then
  begin
    MyMonitorFrame.FamilyPanel.visible := true;
    SpRetNo := GetSpRetNo(RetNo);

    FamilyTotal := ExtractFamilyTotal(RetNo, SpRetNo);
    // Ret[RetNo].Balance+ Ret[SpRetNo].Balance;
    If FamilyTotal < 0 then
    begin
      MyMonitorFrame.FamilyLabel.Caption := 'Fam Refund';
      MyMonitorFrame.FamilyPanel.Caption := FormatFloat('##,###,###.00',
        ABS(FamilyTotal));
    end
    else
    begin
      MyMonitorFrame.FamilyLabel.Caption := 'Fam Owing';
      MyMonitorFrame.FamilyPanel.Caption := FormatFloat('##,###,###.00',
        FamilyTotal);
    end;
  end;

  If ShowUnconvertedLastYear(RetNo) then
  begin
    If ret[RetNo].Lnn[43500] - ret[RetNo].Lnn[482] > 0 then
    begin
      MyMonitorFrame.BalanceLabel.Caption := 'Owing';
      MyMonitorFrame.BalancePanel.Caption := FormatFloat('##,###,###.00',
        ABS(ret[RetNo].Lnn[43500] - ret[RetNo].Lnn[482]));
    end
    else
    begin
      MyMonitorFrame.BalanceLabel.Caption := 'Refund';
      MyMonitorFrame.BalancePanel.Caption := FormatFloat('##,###,###.00',
        ABS(ret[RetNo].Lnn[43500] - ret[RetNo].Lnn[482]));
    end;
  end;
end;

Procedure TMyChildT1_2026.Keys(Var Key: Word; Shift: TShiftState);
var
  MyEditBox: TvtEdit;
  Handled: Boolean;
begin
  Handled := false;
  if Shift = [] then // Ctrl etc. in ShortCuts!
  begin
    { PLAIN F KEYS }
    { F1, F2 , F3, F5 in short cut }
    Handled := true; // assume
    case Key of
      VK_F3:
        MainFormT1.FileSaveAsItemClick(Application);
      VK_F4:
        OpenForm(RetNo, 'TAXSUM', 8);
      VK_F5:
        MainForm.GuiCommand(gcToggleLeftPanel);
      VK_F7:
        MainFormT1.Switchforms1Click(Application);
    else
      Handled := false;
    end;
    if Handled then
    begin
      Key := 0;
      exit;
    end;
  end;

  { CTRL 1 to 8 }
  if (Shift = [ssCtrl]) then
  begin
    Handled := true; // assume
    if (Key = 49) then
      OpenForm(RetNo, 'T1', 0) // 20191220 instead of S1
    else if (Key = 50) then
      OpenForm(RetNo, 'S2', 0)
    else if (Key = 51) then
      OpenForm(RetNo, 'S3', 0)
    else if (Key = 52) then
      OpenForm(RetNo, 'S4', 0)
    else if (Key = 53) then
      OpenForm(RetNo, 'S5', 0)
    else if (Key = 54) then
    Begin // 20171205
      If ret[RetNo].Province = 'QC' then
        OpenForm(RetNo, 'S6QC', 0)
      Else
        OpenForm(RetNo, 'S6', 0)
    End
    else if (Key = 55) then
      OpenForm(RetNo, 'S7', 0)
    else if (Key = 56) then
      OpenForm(RetNo, 'S8', 0)
    else if (Key = 57) then
      OpenForm(RetNo, 'S9', 0)

    else if (Key = 65) then { Ctrl A }
      OpenForm(RetNo, 'OTHEMPL', 0)
    else if (Key = 66) then { Ctrl B }
      OpenForm(RetNo, 'T2125#1', 0)

    else if (Key = 68) then { Ctrl D }
      OpenForm(RetNo, 'OTHDED', 0)
    else if (Key = 69) then { Ctrl E }
      OpenForm(RetNo, 'NPAD#1', 0)
    else if (Key = 70) then { Ctrl F }
      OpenForm(RetNo, 'INVOICE', 0)
    else if (Key = 71) then { Ctrl G }
      OpenForm(RetNo, 'GSTC', 0)
    else if (Key = 72) then { Ctrl H }
      OpenForm(RetNo, 'T778', 0)
    else if (Key = 73) then { Ctrl I }
      OpenForm(RetNo, 'INFO', 0)
    else if (Key = 74) then { Ctrl J }
      OpenForm(RetNo, 'UNIOND', 0)
    else if (Key = 75) then { Ctrl O }
      OpenForm(RetNo, 'OTHINC', 0)
    else if (Key = 76) then { Ctrl L }
      OpenForm(RetNo, 'T691', 0)

    else if (Key = 80) then { Ctrl P }
      OpenForm(RetNo, 'RRSP', 0)
    else if (Key = 81) then { Ctrl Q }
    begin
      if WhichCreditForm(RetNo, ret[RetNo].Province) > '' then
        OpenForm(RetNo, WhichCreditForm(RetNo, ret[RetNo].Province), 0)
    end
    else if (Key = 82) then { Ctrl R }
      OpenForm(RetNo, 'DEPEND', 0)
      (*
        else if (Key = 83) then {Ctrl S}
        MainForm.SlipsItemClick(Application)
      *)
    else if (Key = 84) then { Ctrl T }
      OpenForm(RetNo, 'T1', 0)
    else if (Key = 85) then { Ctrl U }
      OpenForm(RetNo, 'T777#1', 0)

    else if (Key = 88) then { Ctrl X }
    begin
      // MainForm.FileCloseItemClick(Application)
      If ActiveControl is TvtEdit then
      begin
        MyEditBox := ActiveControl As TvtEdit;
        // FieldId:=GetFieldId(MyEditBox.Name);
        MyEditBox.SelectAll;
        MyEditBox.CopyToClipboard;
        MyEditBox.Text := '';
        // DataChanged:=True;
        MyEditBox.Refresh;
      end;
    end
    else if (Key = 89) then { Ctrl Y }
      OpenForm(RetNo, 'YRSUM2', 0)
    else
      Handled := false;
    if Handled then
    begin
      Key := 0;
      exit;
    end;
  end; { Ctrl }

  { ALT KEYS }
  If Shift = [ssAlt] then
  begin
    Handled := true;
    (* Conflict with windows
      If Key = 67 then  {Alt C}
      MainForm.StartCoupling1Click(Application)
    *)
    if (Key = 49) then
      OpenForm(RetNo, 'T4AOAS#1', 0) { 1 }
    else if (Key = 50) then
      OpenForm(RetNo, 'T4A#1', 0) { 2 }
    else if (Key = 51) then
      OpenForm(RetNo, 'T3MULT#1', 0) { 3 }
    else if (Key = 52) then
      OpenForm(RetNo, 'T4#1', 0) { 4 }
    else if (Key = 53) then
      OpenForm(RetNo, 'T5MULT#1', 0) { 5 }
    else if (Key = 54) then
      OpenForm(RetNo, 'T4RSP#1', 0) { 6 }
    else if (Key = 55) then
      OpenForm(RetNo, 'T4RIF#1', 0) { 7 }
    else if (Key = 56) then
      OpenForm(RetNo, 'T4AP#1', 0) { 8 }

    else If Key = 71 then
      MainFormT1.CurrentPage1Click(Application) { Alt G }
    else If Key = 77 then
      MainFormT1.PrintForm1Click(Application) { Alt M }
    else If Key = 83 then
      MainFormT1.SwapReturns1Click(Application) { Alt S }
    else if Key = 88 then
      MainFormT1.FileCloseItemClick(Application) { Alt x }
    else
      Handled := false;
    if Handled then
    begin
      Key := 0;
      exit;
    end;
  end; { Alt keys }

  { Shift KEYS }
  If Shift = [ssShift] then
  begin
    Handled := true;
    if (Key = 65) then
      // AddTheCCALines(RetNo,FormName) {Shift A}  ?
    else
      Handled := false;
    if Handled then
    begin
      Key := 0;
      exit;
    end;
  end; // shift

  // common key?
  if not Handled then
    inherited;
end;

procedure TMyChildT1_2026.Pg1Click(Sender: TObject);
// this is the TMychild.Pg1Click that is used
Var
  FNo: Integer;
  FormName: string;
begin
  If ret[RetNo].IsLastYearReturn then // 20111125
  begin
    FormName := TPanel(Sender).Caption;
    FNo := GetLastYearFormNo((ExtractFormRootName(FormName) + '_' +
      IntToStr(TPanel(Sender).Tag) + ExtractFormInst(FormName)));
    OpenForm(GetCurrentRetNo, FNo, 0);
  end
  else
    ActiveForm.ScrollToPage(TPanel(Sender).Tag);
end;

// 20110225
Procedure TMyChildT1_2026.UpdateFormHeaderFrame();
var
  NmInfo, FormName, FormInfo: String;
  sBox: TvtScrollBox;
  vis: Boolean;
begin
  if not UpdateSectionButtons(MyFormHeaderFrame) then
    exit;
  sBox := ActiveForm; // GetScrollbox(FormName);
  FormName := sBox.FormName;
  NmInfo := AllTrim(UpperCase(GetFirstName(RetNo) + ' ' +
    LeftStr(GetLastName(RetNo), 1))) + '.';
  If NmInfo = '.' then
    NmInfo := '[Un-named]';
  FormInfo := AllTrim(GetFormAbrevName(sBox.FormNo));
  MyFormHeaderFrame.ReturnNameLbl.Caption := NmInfo;
  MyFormHeaderFrame.FormNameLbl.Caption := ' ' + FormInfo;
  vis := ret[RetNo].IsLastYearReturn;
  MyFormHeaderFrame.LastYearIndicator.visible := vis;
  if vis then
  begin // last year
    MyFormHeaderFrame.CplBtn.visible := false;
    MyFormHeaderFrame.MinTaxBtn.visible := false;
  end
  else
  begin // this year
    MyFormHeaderFrame.CplBtn.visible := ret[RetNo].CouplingSw;
    MyFormHeaderFrame.MinTaxBtn.visible := SubjectToMinTax(RetNo);
  end;

  vis := IsFormMultiInst(FormName) and (LeftStr(FormName, 6) <> 'FLDMEM') and
    (LeftStr(FormName, 7) <> 'FLDTAPE');
  MyFormHeaderFrame.ListMultipleBtn.Enabled := vis;
  MyFormHeaderFrame.MultipleDnBtn.Enabled := vis;
  MyFormHeaderFrame.MultipleUpBtn.Enabled := vis;
  // MyFormHeaderFrame.SectionBtn.visible:=(MxPg>1) or (FormName='INFO');  //20110122
  MyFormHeaderFrame.CloseTabBtn.visible := FormName <> 'INFO';
end;

procedure TMyChildT1_2026.CloseActiveForm(Sender: TObject);
Var
  i, j: Integer;
begin
  j := MyPageControl.ActivePageIndex; // page to be deleted

  If FormName = 'INFO' then
  begin
    UserMsg('You cannot close the INFO page' + Chr(13) +
      'You can close the Return instead');
    exit;
  end;
  // Ret[RetNo].FrmScaled[GetFormNo(MyTabSheet.Caption)] := False;

  If (ShowUnconvertedLastYear(RetNo)) then
  begin
    If j = 0 then
      MainFormT1.FileCloseItemClick(Sender);
    exit;
  end;
  inherited;
end;

Function TFormT1_2026.GetValueFromList(MyEditBox: TvtEdit;
  FieldId: Integer): String;
Var
  i: Integer;
  TempList: TStringList;
  FromFname: string; // [12];
  FromElm: Integer;
  s, TempString: String;
  WList: TStringList;
begin
  Result := '';
  // populate the picklist
  SomeList.clear; // := TStringList.Create;
  SomeCaption := 'Valid entries';
  Result := PopulatePickList(MyEditBox); // 20150806

  ShowFormData; // (FormName,FormNo);

  If ExtractNonInstFormName(FormName) = 'T1ADJ' then
    exit;
  // nisa done another way via usearchlist
  If (ExtractNonInstFormName(FormName) = 'T1273') or
    (ExtractNonInstFormName(FormName) = 'T1163') or
    (ExtractNonInstFormName(FormName) = 'T1273A1') or
    (ExtractNonInstFormName(FormName) = 'T1273A2') or
    (ExtractNonInstFormName(FormName) = 'T1273OTH') then
  begin
    SelectedString := Result;
    exit;
  end;

  SelectedString := PopSomeList(SomeList, SomeCaption, MyEditBox);
  Result := CleanUpPickedListValue(FieldId, SelectedString);
  SelectedString := Result; // ??
end;

function TFormT1_2026.GetisDraft: Boolean; // 20161130 Igor
begin
  Result := T1_2026Declare.isDraft;
end;

Function TFormT1_2026.GetLinkedForm(FieldId: Integer;
  Var TargetLinkedField: Integer): String;
Var
  i, j, Fld: Integer;
  LinkedFromFrm, FInst: String; // 20101223
  CurrentFrm: string; // [12]; //CurrentFrm:string; //[10];  //20120125
  LinkList: TStringList;
  WList: TStringList;
  s: String;
begin
  Result := '';
  TargetLinkedField := 0;

  If (FormName = 'T5006') and (FieldId = 1) then
  begin
    Result := FetchELm(RetNo, FormName, 1);
    exit;
  end;
  If ((ExtractNonInstFormName(FormName) = 'T4RIF') and (FieldId = 17))
  // 20160907 Igor
    or ((ExtractNonInstFormName(FormName) = 'T4RSP') and (FieldId = 22)) then
  // 20160907 Igor
  begin
    Result := 'T2205';
    exit;
  end;

  If ExtractNonInstFormName(FormName) = 'ACBSUM' then // 20160907 Igor
  begin
    Case FieldId of
      1, 9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105, 113, 121, 129, 137,
        145, 153, 161, 169, 177, 185, 193, 201, 209, 217, 225, 233, 241, 249,
        257, 165, 273, 281, 289, 297, 305, 313, 321, 329, 337, 345, 353:
        Result := FetchELm(RetNo, FormName, FieldId);
    End;
    exit;
  end;
  LinkList := TStringList.Create;
  // 20170515 Igor >>>
  try
    // 20170515 igor <<<
    LinkList.LoadFromFile(AppDir + '\' + 'LINKLIST.D');
    {
      If RightStr(CurrentFrm,1)='#' then  //20101223
      begin
      Frm:=RTrim(ExtractNonInstFormName(LeftStr(LinkList[i],10)))+ExtractFormInst(FormName)
      end
      else
    }
    FInst := ExtractFormInst(FormName); // 20101223
    CurrentFrm := Rtrim(ExtractNonInstFormName(FormName));

    // multiple linked forms
    WList := TStringList.Create;
    // 20170515 igor >>>
    try
      // 20170515 igor <<<
      For i := 0 to LinkList.count - 1 do
      begin
        LinkedFromFrm :=
          Rtrim(ExtractNonInstFormName(LeftStr(LinkList[i], 10)));
        If CurrentFrm = LinkedFromFrm then
        begin
          Fld := MyStrToInt(MidStr(LinkList[i], 11, 3));
          If Fld = FieldId then
          begin
            s := AllTrim(MidStr(LinkList[i], 15, 80));
            ParseWords(s, ',', WList);
            If WList.count = 1 then { just one linked form }
            begin
              // wordformat is fffffff#n/5
              If ExtractFormInst(Rtrim(CurrentFrm)) > '' then
                Result := ExtractLinkedFormAndSlashField(FInst, WList[0],
                  TargetLinkedField) + ExtractFormInst(Rtrim(FormName))
              else
                Result := ExtractLinkedFormAndSlashField(FInst, WList[0],
                  TargetLinkedField);

              If Result = '?PRV479' then
                Result := WhichCreditForm(RetNo, ret[RetNo].Province);
              If Result = '?PRV428' then
                Result := WhichTaxForm(RetNo, ret[RetNo].Province);
              // 20170515 Igor >>>
              // LinkList.Free;
              // WList.Free;
              // 20170515 Igor <<<
              exit;
            end // end single link
            Else If WList.count > 1 then
            begin
              SomeList.clear; // := TStringList.Create;
              SomeCaption := 'Select from Linked forms';
              For j := 0 to WList.count - 1 do
                SomeList.Add(PaddR(WList[j], 20) + GetFormAbrevNameWithNoInst
                  (GetFormNo(WList[j])));
              SelectedString := PopSomeList(SomeList, SomeCaption);
              // SomeList.Free; //20160301 Igor
              If SelectedString > '' then
              begin
                Result := AllTrim(LeftStr(SelectedString, 20));
                exit;
              end;
            end;
          end; // matching fieldid
        end; // found entry
      end;
      // 20170515 Igor >>>
    finally
      WList.Free;
    end;
  finally
    LinkList.Free;
  end;
  // 20170515 Igor <<<
end;

Function TFormT1_2026.PopulatePickList(eBox: TvtEdit): String; // 20150806
const
  functionalCurrency_N: array[0..4] of string = ('01(USD = US Dollar)', '02(GBP = GB Pound Sterling)', '03(AUD = AU Dollar)', '04(EUR = Euro)', '05(JPY = Yen)'); //20251223 Igor
Var
  i: Integer;
  s, popfile: String;
  FromElm, FieldId: Integer;
begin
  Result := '';
  SomeList.clear;
  FieldId := GetFieldId(eBox.Name);

  IF      PopulateCAISPickList(eBox, FieldId, SomeList) then exit
  ELSE IF PopulateIrregularPickList(eBox, FieldId, SomeList) then exit
  ELSE
  BEGIN
    // set caption
    if eBox.vtPopData.vtPopCaption <> '' then
      SomeCaption := eBox.vtPopData.vtPopCaption;

    popfile := eBox.vtPopData.vtPopFileName; // 20100710
    if popfile <> '' then
    begin // DoDi
      popfile := AppDir + '\' + popfile;
      if not FileExists(popfile) then
        ShowMessage(popfile + ' not found.')
      else
      begin
        SomeList.LoadFromFile(popfile); // 20100710
        if (FieldId = 21) and (UpperCase(ExtractFileName(popfile)) = 'PRVLONG.D')
        then // 20200412
          SomeList.Add('MULTIPLE JURISDICTION'); // self empl
      end;
    end

    //20251223 Igor >>>
    else if FormName.Equals('T106') then
    begin
      case FieldId of
        60: for i:= 0 to pred(length(functionalCurrency_N)) do SomeList.Add(functionalCurrency_N[i]);
        35, 36, 37, 38: Somelist.LoadFromFile(AppDir + '\NAICS.d');
        2, 67: Somelist.LoadFromFile(AppDir + '\FCountry.d');
        72:
        begin
          Somelist.LoadFromFile(AppDir + '\FCountry.d');
          Somelist.add('0XX Country that is not currently contained in the ISO country list');
          Somelist.add('0X5 Not to be resident in any tax jurisdiction for tax purposes');
        end;
       3:
        begin
          SomeList.Add('1   New');
          SomeList.Add('2   Unmodified');
          SomeList.Add('3   Amended');
        end;
      end;
    end else
    if ExtractNonInstFormName(FormName).Equals('T106SL') then
    begin
      case FieldId of
        13, 24, 25, 26, 27: Somelist.LoadFromFile(AppDir + '\' + 'FCountry.d');
        19, 20, 21, 22: Somelist.LoadFromFile(AppDir + '\NAICS.d');
        33, 121, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89,
        35, 123, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91:
          begin
            SomeList.Add('1 Comparable Uncontrolled Price');
            SomeList.Add('2 Cost-Plus');
            SomeList.Add('3 Resale');
            SomeList.Add('4 Profit Split');
            SomeList.Add('5 Transactional Net Margin');
            SomeList.Add('6 Qualifing Cost Contribution Arrangement');
            SomeList.Add('7 Advanced Pricing Arrangement');
            SomeList.Add('8 Other');
          end;
        110:
          begin
            if FetchElm(RetNo, 'T106', 3) = '3   Amended' then SomeList.Add('1   Additional') else SomeList.Add('1   New');

            SomeList.Add('2   Unmodified');
            SomeList.Add('3   Amended');
            SomeList.Add('4   Delete (Close)');
          end;
        175:
          begin
            SomeList.Add('1   Duplicate');
            SomeList.Add('2   Filed in Error');
            SomeList.Add('3   Other');
          end;
       end;
    end
    else
      PopulatePickList(eBox.FieldId);
    //20251223 Igor <<<
  END; // if not PopulateIrregularPickList
end; // Function PopulatePickList

Function TFormT1_2026.PopulatePickList(FieldId: Integer): String;
Var
  i: Integer;
  s, FromFname: string; // [12];
  FromElm: Integer;
begin
  Result := '';

  If (FormName = 'INFO') then
  begin
    case FieldId of
      1:
        for i := Low(PrvLong) to High(PrvLong) do
          SomeList.Add(PrvLong[i]);
      21:
        begin
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvLong[i]);
        end;
      14:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');

      66:
        for i := Low(PrvLong) to High(PrvLong) do
          SomeList.Add(PrvShort[i]);

      249:      //20260315
        Begin
          SomeList.Add('NL');
          SomeList.Add('PE');
          SomeList.Add('NS');
          SomeList.Add('QC');
          SomeList.Add('ON');
          SomeList.Add('MB');
          SomeList.Add('SK');
          SomeList.Add('AB');
          SomeList.Add('BC');
          SomeList.Add('YT');
          SomeList.Add('NT');
          SomeList.Add('NU');
        end;


      33:
        SomeList.LoadFromFile(AppDir + '\' + 'Titles.d');
      49:
        for i := Low(AltAddrCodes) to High(AltAddrCodes) do
          SomeList.Add(AltAddrCodes[i]);
      47:
        for i := Low(TypeOfRet) to High(TypeOfRet) do
          SomeList.Add(TypeOfRet[i]);
      70:
        Begin
          SomeList.Add('NA-Not applicable');
          SomeList.Add('BK-Bankruptcy');
          SomeList.Add('NR-Section 216 election');
          SomeList.Add('NR-Section 217 election');
        end;

      53:
        Begin
          SomeList.Add('1 By Fax');
          SomeList.Add('2 By Mail');
          SomeList.Add('3 Client');
        end;

      69,161:  //20240323 added 69
        SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRY.d'); // 20220209

      222:  //20240113
        SomeList.LoadFromFile(AppDir + '\' + 'ResidencyType.d');

    end;

    exit;
  end

  else if (LeftStr(FormName,4) = 'T217') then
  begin
  case FieldId of
    5: begin
        SomeList.LoadFromFile(AppDir+'\'+'State.d');
        end;
    end; //case
  end

  //20240715 Igor >>>
  else if (LeftStr(FormName,6) = 'T2057#') then
  begin
  case FieldId of
    17,41: begin
        SomeList.LoadFromFile(AppDir+'\'+'State.d');
        end;
    end; //case
  end

  // 20140322
  Else If FormName = 'T1132' then
  begin
    case FieldId of
      14:
        for i := Low(PrvShort) to High(PrvShort) do
          SomeList.Add(PrvShort[i]);
    end; // case
  end

  else If (LeftStr(FormName,4) = 'UHT#') then
  begin
    case FieldId of
     6,14,27:
      for i := Low(Prvshort) to High(PrvShort) do
          SomeList.Add(PrvShort[i]);
     7,15:   //20230628
          SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRY.d'); // 20220209
    end; //case
  end
  //20240715 Igor <<<


  else // 20200212
    If (LeftStr(FormName, 7) = 'CONSENT') then
      case FieldId of
        16, 22, 29, 36, 43:
          begin
            SomeList.Add('01  View Only');
            SomeList.Add('02  Allow Update Access');
            SomeList.Add('03  Delegate Authority');
          end;
        17, 24, 31, 38:
          begin
            SomeList.Add('RC Corporate income tax');
            SomeList.Add('RT Goods and Services tax');
            SomeList.Add('RP Payroll deductions');
            SomeList.Add('RM Import/Export');
            SomeList.Add('RE Excise Tax');
            SomeList.Add('RN Insurance Premium Tax');
            SomeList.Add('RD Excise Duty');
            SomeList.Add('RG Air Travelers Security Charge');
            SomeList.Add('SL Softwood Lumber Products Export Charge');
          end;
      end

      // 20151010
    else If FormName = 'T1135' then // 20150329
    begin
      If FieldId > 9999 then
      Begin
        // Somelist:=TStringList.Create; //20150705  WHY? Othrwise t abbends //dynaic element
        SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRYT1135.d'); // 20161227
        // Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRY.d');
      End;
    end

    // 20180204
    Else If LeftStr(FormName, 6) = 'T2125#' then
    begin
      case FieldId of
        53:
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
      end; // case
    end

    // 20170129
    Else If LeftStr(FormName, 6) = 'T2042#' then
    begin
      case FieldId of
        71:
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]); // 20180204
      end; // case
    end

    // 20150118
    Else If ExtractNonInstFormName(FormName) = 'T2121' then // 20160907 Igor
    begin
      case FieldId of
        89:
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
      end; // case
    end

    Else If ExtractNonInstFormName(FormName) = 'T1M' then // 20160907 Igor
    begin
      case FieldId of
        137:
          begin
            for i := Low(PrvShort) to High(PrvShort) do
              SomeList.Add(PrvShort[i]);
          end;
      end; // case
    end

    // 20180114
    Else If ExtractFormRootName(FormName) = 'T2091' then
    begin
      case FieldId of
        19:
          begin
            for i := Low(PrvShort) to High(PrvShort) do
              SomeList.Add(PrvShort[i]);
          end;
        22:
          SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRY.d'); // 20180407
      end; // case
    end

    // 20180304
    Else If ExtractFormRootName(FormName) = 'T1255' then
    begin
      case FieldId of
        19:
          begin
            for i := Low(PrvShort) to High(PrvShort) do
              SomeList.Add(PrvShort[i]);
          end;
      end; // case
    end


    Else If FormName = 'S3' then
    begin
      case FieldId of
        133, 134, 135, 136, 137:
          begin
            for i := Low(PrvShort) to High(PrvShort) do
              SomeList.Add(PrvShort[i]);
          end;
      end; // case
    end

    Else If FormName = 'S11' then
    begin
      case FieldId of
        26:
          begin
            GetParentsInfo(RetNo);
          end;
      end; // case
    end

    Else If ExtractNonInstFormName(FormName) = 'T4' then // 20160907 Igor
    begin
      case FieldId of
        20:
          begin
            for i := Low(PrvShort) to High(PrvShort) do
              SomeList.Add(PrvShort[i]);
          end;
        63: SomeList.LoadFromFile(AppDir + '\' + 'EmployerDental.d');  //20231125
      end; // case
    end

    Else If ExtractNonInstFormName(FormName) = 'T4A' then // 20231125
    begin
      case FieldId of
        102: SomeList.LoadFromFile(AppDir + '\' + 'EmployerDental.d');  //20231125
      end; // case
    end


    // 20210404   //renoe 20210501
    Else If ExtractNonInstFormName(FormName) = 'T777' then // 20160907 Igor
    begin
      case FieldId of
        61:
          begin
            GetListOfT4SlipsForT777(RetNo, SomeList);
          end;
      end; // case
    end

    Else If (ExtractNonInstFormName(FormName) = 'ASSETSB') or
      (ExtractNonInstFormName(FormName) = 'ASETSB') // 20230211
    then // 20160907 Igor
    begin
      case FieldId of
        215, 221, 227:
          begin
            GetListOfStatementsForAutos(RetNo, SomeList);
          end;
        134:
          begin
            SomeCaption := 'CCA Class, Rate and description';
            SomeList.LoadFromFile(AppDir + '\' + 'CCARATES.d');
          end;
      end; // case
    end

    Else If FormName = 'FORINC' then
    begin
      case FieldId of
        1, 2, 3:
          begin
            SomeCaption := 'Foreign Countries';
            SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRY.d');
            {
              SomeList.Sorted:=True; //20100418
              SomeList.Sorted:=False; //20100418
            }
          end;
      end; // case
    end

    else If (FormName = 'RC59') then
    begin
      case FieldId of
        16, 22, 29, 36, 43:
          begin
            SomeList.Add('1  View Only');
            SomeList.Add('2  Allow Update Access');
            SomeList.Add('3  Delegate Authority (Efile Only)');
          end;
        17, 24, 31, 38:
          begin
            SomeList.Add('RC Corporate income tax');
            SomeList.Add('RT Goods and Services tax');
            SomeList.Add('RP Payroll deductions');
            SomeList.Add('RM Import/Export (no online access');
            SomeList.Add('RE Excise Tax');
            SomeList.Add('RN Insurance Premium Tax');
            SomeList.Add('RD Excise Duty');
            SomeList.Add('RG Air Travelers Security Charge');
            SomeList.Add('SL Softwood Lumber Products Export Charge');
          end;
      end
    end

    // 20160722 CON  it seems it does not work from the uONBEN form?
    else If (FormName = 'ONBEN') then
    begin
      case FieldId of
        83, 89, 95, 101, 107, 113, 119, 125:
          begin
            SomeList.Add('Rent');
            SomeList.Add('Private Long Term Care Rent');
            SomeList.Add('Property Tax');
            SomeList.Add('Energy on a Reserve');
            SomeList.Add('Public Long Term Care');
          end;
      end // case
    end

    Else If ExtractNonInstFormName(FormName) = 'AUTOS' then // 20160907 Igor
    begin
      case FieldId of
        134: // ,135,136:
          begin
            SomeList.Add('10');
            SomeList.Add('10.1');
            // 20200520
            SomeList.Add('54');
            SomeList.Add('55');
          end;
        215, 221, 227:
          begin
            GetListOfStatementsForAutos(RetNo, SomeList);
          end;
      end; // case
    end

    Else If ExtractNonInstFormName(FormName) = 'AUTO777' then // 20160907 Igor
    begin
      case FieldId of
        134:
          begin
            SomeList.Add('8');
            SomeList.Add('10');
            SomeList.Add('10.1');
            SomeList.Add('54'); // 20200506
            SomeList.Add('55'); // 20200506
          end;
      end; // case
    end

    else if ExtractNonInstFormName(FormName) = 'T1ADJ' then // 20160907 Igor
      case FieldId of
        23, 28, 33, 38, 43, 48, 53, 58, 63, 68, 73, 78, 83, 88, 93, 98,
          103, 108:
          begin
            SomeList.clear;
            // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
            SomeCaption := 'Valid entries';
            SomeList.LoadFromFile(AppDir + '\' + 'EfFields.D');
            Application.CreateForm(TPopComboListT1_2026, PopComboList);
            PopComboList.ShowModal;
            PopComboList.Free;

            Result := LeftStr(SelectedString, 4);
            StoreElm(RetNo, FormName, FieldId + 1,
              AllTrim(MidStr(SelectedString, 9, 70)));
            FromFname := UpperCase(AllTrim(MidStr(SelectedString, 81, 9)));
            FromElm := MyStrToInt(AllTrim((MidStr(SelectedString, 91, 3))));
            s := AllTrim(FetchELm(RetNo, FromFname, FromElm));
            StoreElm(RetNo, FormName, FieldId + 4, s);
            exit;
          end
      end

    else if FormName = 'MEDICAL' then
      case FieldId of
        113 .. 133:
          begin
            GetPatientsInfo(RetNo);
          end
      end

    else if ExtractNonInstFormName(FormName) = 'MEDSUPL' then // 20160907 Igor
      case FieldId of
        133 .. 153:
          begin
            GetPatientsInfo(RetNo);
          end
      end

    else if ExtractNonInstFormName(FormName) = 'T5013' then // 20160907 Igor
      case FieldId of
        1:
          begin
            SomeList.Add('0');
            SomeList.Add('1');
          end
      end

    else if FormName = 'PTRANSIT' then
      case FieldId of
        3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57,
          60, 63, 66, 69, 72, 75:
          begin
            GetDependantsForTransit(RetNo);
          end
      end

    else if FormName = 'NS428' then
      case FieldId of
        86, 90, 94, 98:
          begin
            GetKidsUnder6(RetNo);
          end
      end


     else // //20260110cz //20171125
      if (FormName = 'MBARTS') or (FormName = 'BCARTS') or (FormName = 'YTARTS')
      then
        case FieldId of
          6, 17, 28, 39, 50:
            begin
              GetKidsForArts(RetNo);
            end
        end


    else if FormName = 'FITNESS' then
      case FieldId of
        6, 17, 28, 39, 50:
          begin
            GetKidsForFitness(RetNo);
          end
      end

      Else If (ExtractNonInstFormName(FormName) = 'ACBFRM') then
      // 20160907 Igor
        case FieldId of
          4:
            begin
              SomeCaption := 'Valid properties';
              SomeList.LoadFromFile(AppDir + '\' + 'ACBPROP.d');
            end;
          16, 25, 34, 43, 52, 61, 70, 79, 88, 97, 106, 115, 124, 133, 142, 151,
            160, 169, 178, 187, 196, 205, 214, 223, 232, 241, 250, 259,
            268, 277:
            begin
              SomeCaption := 'Valid transactions';
              SomeList.LoadFromFile(AppDir + '\' + 'ACBTrans.d');
            end;
          286, 295, 304, 313, 322, 331, 340, 349, 358, 367, 376, 385, 394,
            403, 412, 421:
            begin
              SomeCaption := 'Valid transactions';
              SomeList.LoadFromFile(AppDir + '\' + 'ACBTrans.d');
            end;
          475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488,
            489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501,
            502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514,
            515, 516, 517, 518, 519, 520:
            begin
              SomeCaption := 'Foreign Countries';
              SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
            end;
        end

        // 20161126  Con
      Else If FormName = 'EFMEMO' then
        case FieldId of
          42:
            begin
              SomeList.Add
                ('1 : Partnership is a tax shelter or income is from inactive business');
              SomeList.Add
                ('2 : Partnership is not a tax shelter or income is from active business');
            end;
        end

      Else If (ExtractNonInstFormName(FormName) = 'MIA') then // 20160907 Igor
        case FieldId of
          1:
            begin
              SomeList.clear;
              SomeCaption := 'Farming Statements';
              GetListOfFarmingStatements(RetNo, SomeList);
            end;
        end

      Else If (ExtractNonInstFormName(FormName) = 'T1163') // 20160907 Igor
      then
        case FieldId of
          14:
            begin
              for i := Low(PrvLong) to High(PrvLong) do
                SomeList.Add(PrvShort[i]);
            end;

          205:
            begin
              for i := Low(PrvLong) to High(PrvLong) do
                SomeList.Add(PrvShort[i]);
            end;

          //jz//20260225 - moved to PopulateCAISPickList
          {
          //1163
          219, 222, 225, 228, 231, 234, 237, 240, 243, 246, 249, 252, 255, 258,
            261, 264, 267, 270, 273, 276, 279, 282, 285, 288, 291, 294,
            297, 300, 303:
            begin
              SomeList.clear;
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 3);
              If Numeric(LeftStr(s, 1)) = true then // 20111227
              begin
                If (Result = '888') then
                  StoreElm(RetNo, FormName, FieldId - 1,
                    GetUserCaisCodeDescr(Result))
                else
                  StoreElm(RetNo, FormName, FieldId - 1,
                    AllTrim(MidStr(SelectedString, 5, 36)));
              end;
              exit;
            end;
          //jz//20260225 - moved to PopulateCAISPickList
          //1163
          402, 405, 408, 411, 414, 417, 420, 423, 426, 429, 432, 435, 438, 441,
            444, 447, 450, 453, 456:
            begin
              SomeList.clear;
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 3);
              If Numeric(LeftStr(s, 1)) = true then // 20111227
              begin
                If (Result = '999') then
                  StoreElm(RetNo, FormName, FieldId - 1,
                    GetUserCaisCodeDescr(Result))
                else
                  StoreElm(RetNo, FormName, FieldId - 1,
                    AllTrim(MidStr(SelectedString, 5, 36)));
              end;
            end;
            }

        end

      Else If (ExtractNonInstFormName(FormName) = 'T1273') then
        case FieldId of
          32:
            begin
              SomeList.clear;
              // Somelist := TSingleStringList.Create;; //20150814 igor //201690301 Igor
              for i := Low(PrvLong) to High(PrvLong) do
                SomeList.Add(PrvShort[i]);
              SelectedString := PopSomeList(SomeList, SomeCaption);
              // SomeList.Free; //20160301 Igor
              If SelectedString > '' then
                Result := SelectedString
              else
                Result := '';

              If (Result = 'AB') or (Result = 'ON') or (Result = 'PE') or
                (Result = 'NU') or (Result = 'NT') or (Result = 'QC') or
                (Result = 'SK') or (Result = 'ZZ') then
                Result := '';
            end;

          27:
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'District/County/Municipality Names';
              If FileExists(AppDir + '\' + 'DISTR' + FetchELm(RetNo, FormName,
                32) + '.D') then
                SomeList.LoadFromFile(AppDir + '\' + 'DISTR' + FetchELm(RetNo,
                  FormName, 32) + '.D')
              else
                SomeList.clear;
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := '';
              If Numeric(LeftStr(SelectedString, 1)) then
              begin
                Result := MidStr(SelectedString, 5, 50);
                { 20170108 Leave it as manualentry
                  //StoreElm(RetNo,FormName,28,AddLeadingZeros(LeftStr(S,3),3));  //201170108
                  s:=Alltrim(RemoveChar(RemoveChar(Result,'-'),'-'));  //20170108
                  s:=AllTrim(FillLeftZeros(s,3));  //20170108
                  StoreElm(RetNo,FormName,FieldId+1,LeftStr(S,3));
                  //StoreElm(RetNo,FormName,FieldId+1,LeftStr(SelectedString,3));
                }
              end;
              // SomeList.Clear;
              exit;
            end;

          205:
            begin
              for i := Low(PrvLong) to High(PrvLong) do
                SomeList.Add(PrvShort[i]);
            end;
          //jz//20260225 - moved to PopulateCAISPickList
          {
          //1273
          219, 222, 225, 228, 231, 234, 237, 240, 243, 246, 249, 252, 255, 258,
            261, 264, 267, 270, 273, 276, 279, 282, 285, 288, 291, 294,
            297, 300, 303:
            begin
              SomeList.clear;
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 3);
              If Numeric(LeftStr(Result, 1)) = true then // 20111227
              Begin
                If (Result = '888') then
                  StoreElm(RetNo, FormName, FieldId - 1,
                    GetUserCaisCodeDescr(Result))
                else
                  StoreElm(RetNo, FormName, FieldId - 1,
                    AllTrim(MidStr(SelectedString, 5, 36)));
              end;
              exit;
            end;
          //jz//20260225 - moved to PopulateCAISPickList
          //1273
          402, 405, 408, 411, 414, 417, 420, 423, 426, 429, 432, 435, 438, 441,
            444, 447, 450, 453, 456:
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 3);
              If Numeric(LeftStr(Result, 1)) = true then // 20111227
              begin
                If (Result = '999') then
                  StoreElm(RetNo, FormName, FieldId - 1,
                    GetUserCaisCodeDescr(Result))
                else
                  StoreElm(RetNo, FormName, FieldId - 1,
                    AllTrim(MidStr(SelectedString, 5, 36)));
              end;
              exit;
            end;
          }

          807, 811, 815, 819, 823, 827, 831, 835, 839, 843, 847, 851, 855:
          // live inv SECTION 7
            begin
              SomeList.clear;
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAISL1L2.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 4);
              If Result = '4001' then
                StoreElm(RetNo, FormName, FieldId + 1,
                  GetUserCaisCodeDescr(Result,''))
              else
                StoreElm(RetNo, FormName, FieldId + 1,
                  AllTrim(MidStr(SelectedString, 37, 73)));
              exit;
            end;

          859, 866, 873, 880, 887, 894, 901, 908, 915, 922, 929, 936, 943:
          // crop inv SECTION 8
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAISL1L2.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              If Numeric(LeftStr(SelectedString, 4)) then
              begin
                Result := LeftStr(SelectedString, 4);
                If Result = '4000' then
                  StoreElm(RetNo, FormName, FieldId + 1,
                    GetUserCaisCodeDescr(Result,''))
                else
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 37, 73)));
              end
              else
                Result := '';
              exit;
            end;

          861, 868, 875, 882, 889, 896, 903, 910, 917, 924, 931, 938, 945:
          // crop units
            begin
              SomeCaption := 'CAIS Units of Measure';
              SelectedString := PopSomeFile(AppDir + '\' + 'CaisUnit.D',
                SomeCaption);
              If SelectedString > '' then
                Result := SelectedString // MidStr(SelectedString,4,16)
              else
                Result := '';
              exit;
            end;

          1092, 1096, 1100, 1104, 1108: // section 9 - productive capacity
            begin
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAISL5.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 4);
              If (Result = '4005') then
                StoreElm(RetNo, FormName, FieldId + 1,
                  GetUserCaisCodeDescr(Result,''))
              else
              begin
                StoreElm(RetNo, FormName, FieldId + 1,
                  AllTrim(MidStr(SelectedString, 5, 39)));
                If FetchELm(RetNo, FormName, FieldId + 2) = '' then
                  StoreElm(RetNo, FormName, FieldId + 2,
                    AllTrim(MidStr(SelectedString, 47, 30))); // 20090125
              end;
              exit;
            end;

          //jz//20260225 - moved to PopulateCAISPickList
          {
          //1273
          1029, 1032, 1035, 1038, 1041, 1044, 1047, 1050:
          // Section 11 deferred income
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := AllTrim(LeftStr(SelectedString, 4));
              If Numeric(LeftStr(Result, 1)) = true then // 20111227
              begin
                If (Result = '4003') then
                  StoreElm(RetNo, FormName, FieldId + 1,
                    GetUserCaisCodeDescr(Result))
                else
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 5, 39)));
              end;
              exit;
            end;
          }

          //I dont think this is used? gets from irregularpicklist skips this
          //jz//20260225 - moved to PopulateCAISPickList
          {
          //1273
          1005, 1008, 1011, 1014, 1017, 1020, 1023, 1026, 1053, 1056, 1059,
            1062, 1065, 1068, 1071, 1074:
          // Section 10 -purch inputs and accounts payable
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'Select codes';
              SomeList.Add('1. Income/Expense codes');
              SomeList.Add('2. Commodity codes');
              SelectedString := PopSomeList(SomeList, SomeCaption);
              If LeftStr(SelectedString, 1) = '1' then
              begin
                SomeCaption := 'Valid entries';
                SelectedString := PopSomeFile(AppDir + '\' + 'CaisExp.D',
                  SomeCaption);
                Result := LeftStr(SelectedString, 4);
                If (Result = '4002') or (Result = '4004') then
                  StoreElm(RetNo, FormName, FieldId + 1,
                    GetUserCaisCodeDescr(Result,''))
                else
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 6, 43)));
                exit;
              end
              Else If LeftStr(SelectedString, 1) = '2' then
              begin
                SomeList.clear;  // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
                SomeCaption := 'CAIS codes';
                SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
                Application.CreateForm(TSearchListT1_2026, SearchList);
                SearchList.ShowModal;
                SearchList.Free;
                Result := LeftStr(SelectedString, 3);
                If Numeric(LeftStr(Result, 1)) = true then // 20111227
                begin
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 5, 39)));
                end;
                exit;
              end
              else
                exit;
            end;
            }
        end
      else if ExtractNonInstFormName(FormName) = 'T1273A1' then
      begin
        case FieldId of
          7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55:
          // live inv SECTION 7
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor  //20160907 Igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAISL1L2.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 4);
              If Result = '4001' then
                StoreElm(RetNo, FormName, FieldId + 1,
                  GetUserCaisCodeDescr(Result,''))
              else
                StoreElm(RetNo, FormName, FieldId + 1,
                  AllTrim(MidStr(SelectedString, 37, 73)));
              exit;
            end;

          59, 66, 73, 80, 87, 94, 101, 108, 115, 122, 129, 136, 143:
          // crop inv SECTION 8
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAISL1L2.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              If Numeric(LeftStr(SelectedString, 4)) then
              begin
                Result := LeftStr(SelectedString, 4);
                If Result = '4000' then
                  StoreElm(RetNo, FormName, FieldId + 1,
                    GetUserCaisCodeDescr(Result,''))
                else
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 37, 73)));
              end
              else
                Result := '';
              exit;
            end;

          61, 68, 75, 82, 89, 96, 103, 110, 117, 124, 131, 138, 145:
          // crop units
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'CAIS Units of Measure';
              SelectedString := PopSomeFile(AppDir + '\' + 'CaisUnit.D',
                SomeCaption);
              If SelectedString > '' then
                Result := SelectedString // MidStr(SelectedString,4,16)
              else
                Result := '';
            end;
        end;
        exit;
      end // end T1273A1 -------------------------------------------------------------------------------

      else if ExtractNonInstFormName(FormName) = 'T1273A2' then
      begin
        case FieldId of
          92, 96, 100, 104, 108: // section 9 - productive capacity
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAISL5.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 4);
              If (Result = '4005') then
                StoreElm(RetNo, FormName, FieldId + 1,
                  GetUserCaisCodeDescr(Result,''))
              else
              begin
                StoreElm(RetNo, FormName, FieldId + 1,
                  AllTrim(MidStr(SelectedString, 5, 39)));
                If FetchELm(RetNo, FormName, FieldId + 2) = '' then
                  StoreElm(RetNo, FormName, FieldId + 2,
                    AllTrim(MidStr(SelectedString, 47, 30))); // 20090125
                // StoreElm(RetNo,GetFormNo(FormName),FieldId+2,AllTrim(MidStr(SelectedString,47,18)));
              end;
              exit;
            end;

          //jz//20260225 - moved to PopulateCAISPickList
          {
          //T1273A2
          29, 32, 35, 38, 41, 44, 47, 50: // Section 11 deferred income
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := AllTrim(LeftStr(SelectedString, 4));
              If Numeric(LeftStr(Result, 1)) = true then // 20111227
              begin
                If (Result = '4003') then
                  StoreElm(RetNo, FormName, FieldId + 1,
                    GetUserCaisCodeDescr(Result))
                else
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 5, 39)));
              end;
              exit;
            end;
          }

          //jz//20260225 - moved to PopulateCAISPickList
          {
          //T1273A2
          5, 8, 11, 14, 17, 20, 23, 26, 53, 56, 59, 62, 65, 68, 71, 74:
          // Section 10 -purch inputs and accounts payable
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
              SomeCaption := 'Select codes';
              SomeList.Add('1. Income/Expense codes');
              SomeList.Add('2. Commodity codes');
              SelectedString := PopSomeList(SomeList, SomeCaption);
              If LeftStr(SelectedString, 1) = '1' then
              begin
                SomeCaption := 'Valid entries';
                SelectedString := PopSomeFile(AppDir + '\' + 'CaisExp.D',
                  SomeCaption);
                Result := LeftStr(SelectedString, 4);
                If (Result = '4002') or (Result = '4004') then
                  StoreElm(RetNo, FormName, FieldId + 1,
                    GetUserCaisCodeDescr(Result,''))
                else
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 6, 43)));
                exit;
              end
              Else If LeftStr(SelectedString, 1) = '2' then
              begin
                SomeList.clear;
                // := TSingleStringList.Create;; //20150814 igor //20160907 igor
                SomeCaption := 'CAIS codes';
                SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
                Application.CreateForm(TSearchListT1_2026, SearchList);
                SearchList.ShowModal;
                SearchList.Free;
                Result := LeftStr(SelectedString, 3);
                If Numeric(LeftStr(Result, 1)) = true then // 20111227
                begin
                  StoreElm(RetNo, FormName, FieldId + 1,
                    AllTrim(MidStr(SelectedString, 5, 39)));
                end;
                exit;
              end
              else
                exit;
            end;
            }
        end;
      end // end T1273A2 -------------------------------------------------------------------------------

      Else If (ExtractNonInstFormName(FormName) = 'ONEETC') then
      // 20160907 Igor
        case FieldId of
          1, 2:
            begin
              SomeCaption := 'Select a child';
              GetDependantsList(RetNo);
            end
        end

      Else If (ExtractNonInstFormName(FormName) = 'T1139') then // 20160907 Igor
        case FieldId of
          2:
            begin
              SomeCaption :=
                'Statement  YearEnd           NetIncome          BusinessName';
              GetOddBusStatements(RetNo);
            end
        end

      Else If (ExtractNonInstFormName(FormName) = 'T2043A') then
      // 20160907 Igor
        case FieldId of
          69:
            begin
              SomeCaption :=
                'Statement  YearEnd           NetIncome          BusinessName';
              GetFarmingStatements(RetNo);
            end
        end

        // 20160820 con
      Else If FormName = 'T2222' then
      begin
        case FieldId of
          27, 29:
            begin
              for i := Low(PrvShort) to High(PrvShort) do
                SomeList.Add(PrvShort[i]);
            end;
        end; // case
        // 20160815
        case FieldId of
          111, 119, 127, 135, 143, 151, 159, 167, 175, 183, 191, 199, 207, 215,
            223, 231, 239, 247, 255, 263:
            begin
              SomeList.Add('A');
              SomeList.Add('B');
            end;
          112, 120, 128, 136, 144, 152, 160, 168, 176, 184, 192, 200, 208, 216,
            224, 232, 240, 248, 256, 264:
            begin
              SomeList.Add('F'); // 20220519
              SomeList.Add('V');
            end;
        end; // case
      end

      Else If FormName = 'FECONV' then
        case FieldId of
          1:
            begin
              SomeCaption := 'Foreign Exchange Rates';
              SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
            end;
        end

      Else If FormName = 'AJCTC' then
        case FieldId of
          2, 7, 12, 17, 22, 27, 32, 37, 42, 47, 52, 57, 62, 67, 72, 77,
            82, 87, 92:
            begin
              SomeCaption := 'Apprentice Trades';
              SomeList.LoadFromFile(AppDir + '\' + 'Trades.d');
            end;
        end

      Else If (ExtractNonInstFormName(FormName) = 'T5') then // 20160907 Igor
        case FieldId of
          21:
            begin
              SomeCaption := 'Foreign Exchange Rates';
              SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
            end;
        end

      Else If (ExtractNonInstFormName(FormName) = 'T3MULT') then
      // 20160907 Igor
      begin
        case FieldId of
          59 .. 63:
            begin
              SomeCaption := 'Foreign Exchange Rates';
              SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
            end;
          53 .. 57:
            begin
              SomeList.Add('1');
              SomeList.Add('2');
              SomeList.Add('3');
            end;
        end; // case
      end

      Else If (ExtractNonInstFormName(FormName) = 'T2202') then // 20200319
        case FieldId of
          72:
            begin
              SomeCaption := 'Foreign Exchange Rates';
              SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
            end;
        end

      Else If (ExtractNonInstFormName(FormName) = 'FPENS') then // 20160907 Igor
        case FieldId of
          9:
            begin
              SomeCaption := 'Foreign Exchange Rates';
              SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
            end;
        end

      Else If (ExtractNonInstFormName(FormName) = 'T5MULT') then
      // 20160907 Igor
      begin
        case FieldId of
          21, 43, 65, 87, 109:
            begin
              SomeCaption := 'Foreign Exchange Rates';
              SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
            end;
          5, 27, 49, 71, 93:
            begin
              SomeList.Add('1');
              SomeList.Add('2');
              SomeList.Add('3');
            end;
        end; // case
      end

      Else If (ExtractNonInstFormName(FormName) = 'T776A') then // 20160907 Igor
        case FieldId of
          16, 29, 42, 55, 68, 81, 94, 107, 120, 133, 146, 159:
            begin
              SomeCaption := 'CCA Class, Rate and description';
              SomeList.LoadFromFile(AppDir + '\' + 'CCARATES.d');
            end;
        end

      Else If FormName = 'DEPEND' then
        Case FieldId of
          11, 26, 41, 56, 71, 86, 101, 116, 131, 146:
            SomeList.LoadFromFile(AppDir + '\' + 'DepRel.d');
        end

      Else If FormName = 'T1134' then //20230811 Igor
      Begin
        //20230411 Igor >>>
        FieldId := GetFirstElmId(RetNo,FormNo,FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
        case FieldId of
         40,41,42,43:SomeList.LoadFromFile(AppDir+'\'+'NAICS.d'); //20230510 Igor
         24:begin
               //20180703 Igor >>>
               SomeList.Add('USD = US Dollar');
               SomeList.Add('GBP = GB Pound Sterling');
               SomeList.Add('AUD = AU Dollar');
               SomeList.Add('EUR = Euro');
               //20180703 Igor <<<
              end;
         // 20180703 Igor >>>
         25:
            begin
              SomeList.Add('1   New');
              SomeList.Add('2   Unmodified');
              SomeList.Add('3   Amended');
            end;
         // 20180703 Igor <<<
         20009,20010,20011,20012,30009,30010,30011,30012,40010,40011,40012,40013: SomeList.LoadFromFile(AppDir+'\'+'NAICS.d');
         17,10007,20005,30005,40005: SomeList.LoadFromFile(AppDir+'\'+'State.d');
         141,10009,20007,30007,40007,60002,60005,70003,70006,80003,90003,110003: SomeList.LoadFromFile(AppDir+'\'+'FCountryT1135.d');
         40009:
            begin
              SomeList.Add('1   If end partners are individuals or trusts');
              SomeList.Add('2   If end partners are corporations');
              SomeList.Add('3   If end partners are a combination of 1 and 2 mentioned above');
            end;
          60003,70001,90004,110001: PopulateT1134ForeignAffiliates(RetNo,SomeList); //20230601 Igor
        end; //case;
        //20230411 Igor <<<
      End

      Else If LeftStr(FormName,7) = 'T1134S#' then //20230811 Igor
      begin
        FieldId := GetFirstElmId(RetNo,FormNo,FieldId); // if FieldId is dynamic, change it to the corresponding id of first row

        case FieldId of
         //20180703 Igor >>>
         //20230510 Igor >>>
        // 35: PopulateT1134ForeignAffiliates(RetNo,SomeList);
         20001,30001: PopulateT1134SGroupList(RetNo,FormNo,SomeList, 1);
         50001,60001,70002,80002,90002,100002,110001,140001: PopulateT1134SGroupList(RetNo,FormNo,SomeList);
         10001,40001,120001,130001,150001,160001: PopulateT1134GroupList(RetNo,SomeList);
         //20230510 Igor <<<
         3:
           begin
            SomeList.Add('1   New');
            SomeList.Add('2   Unmodified');
            SomeList.Add('3   Amended');
            SomeList.Add('4   Delete (Close)');
           end;
         175:
           begin
            SomeList.Add('1   Duplicate');
            SomeList.Add('2   Filed in Error');
            SomeList.Add('3   Other');
           end;
         //20180703 Igor <<<
         40,41,42,43:SomeList.LoadFromFile(AppDir+'\'+'NAICS.d');
         44,45,46,47,5,6,7,8,48:SomeList.LoadFromFile(AppDir+'\'+'FCountryT1135.d');
         10012,16,18,79,83,87,91,95,99,103,107,111:SomeList.LoadFromFile(AppDir+'\'+'Currency.d'); //20240622
        end; //case;
      end;
End;

Function TFormT1_2026.PopulateIrregularPickList(eBox: TvtEdit; FieldId: Integer; SomeList: TStringList): Boolean;
Var
  i: Integer;
  s, FromFname: string;
  FromElm: Integer;
begin
  if not assigned(SomeList) then // 20160907 igor
    SomeList := TSingleStringList.Create; // 20160907 igor
  Result := false;
  // 20160223 Igor (Full reload procedure)
  If FormName = 'S11' then
  begin
    case FieldId of
      26:
        begin
          GetParentsInfo(RetNo);
          Result := true;
        end;
    end; // case
  end // end If 'S11';

  else If FormName = 'T1135' then // 20130720
  begin
    If eBox.Tag > 9999 then
      SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRYT1135.d');
    // it includes OTH, but tbl: 1 and 5 cannot use OTH ! //20160123
    // 20151212
    Case FieldId of
      28:
        SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRY.d');
        // 20160123  //it does notinclude OTH
      57, 58, 59:
        SomeList.LoadFromFile(AppDir + '\' + 'FCOUNTRYT1135.d'); // 20160123
    end;
  end

  else If FormName = 'S11PRV' then
  begin
    case FieldId of
      26:
        begin
          GetParentsInfo(RetNo);
          Result := true;
        end;
    end; // case
  end // end If 'S11';

  else If ExtractNonInstFormName(FormName) = 'RC62' then // 20160907 Igor
    case FieldId of
      9, 10:
        begin
          GetKidsUnder6ForUccb(RetNo);
          Result := true;
        end
    end

  Else If (ExtractNonInstFormName(FormName) = 'ASSETSB') Or
    (ExtractNonInstFormName(FormName) = 'ASETSB') then // 20160907 Igor
  begin
    case FieldId of
      215, 221, 227:
        begin
          GetListOfStatementsForAutos(RetNo, SomeList);
          Result := true;
        end;
    end; // case
  end // end If ASSETSB#

  Else If ExtractNonInstFormName(FormName) = 'AUTO777' then // 20200511
  begin
    case FieldId of
      215:
        begin
          GetListOfStatementsForAuto777(RetNo, SomeList, ''); // 20200513
        end;
    end; // case
  end

  Else If ExtractNonInstFormName(FormName) = 'AUTOS' then // 20160907 Igor
  begin
    case FieldId of
      215, 221, 227:
        begin
          GetListOfStatementsForAutos(RetNo, SomeList);
          Result := true;
        end;
    end; // case
  end

  else if ExtractNonInstFormName(FormName) = 'T1ADJ' then // 20160907 Igor
    case FieldId of
      23, 28, 33, 38, 43, 48, 53, 58, 63, 68, 73, 78, 83, 88, 93, 98, 103, 108:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 igor
          SomeCaption := 'Valid entries';
          SomeList.LoadFromFile(AppDir + '\' + 'EfFields.D');
          Application.CreateForm(TPopComboListT1_2026, PopComboList);
          PopComboList.ShowModal;
          PopComboList.Free;

          // result := LeftStr(SelectedString,4);
          LeftStr(SelectedString, 4);
          StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
            AllTrim(MidStr(SelectedString, 9, 70)));
          FromFname := UpperCase(AllTrim(MidStr(SelectedString, 81, 9)));
          FromElm := MyStrToInt(AllTrim((MidStr(SelectedString, 91, 3))));
          s := AllTrim(FetchELm(RetNo, FromFname, FromElm));
          StoreElm(RetNo, GetFormNo(FormName), FieldId + 4, s);

          Result := true;
          exit;
        end
    end

    // 20160430 Igor
    // 20160409
  else if ExtractNonInstFormName(FormName) = 'T2201' then // 20160907 Igor
    case FieldId of
      35:
        begin
          GetPatientsInfo(RetNo);
          Result := true;
        end
    end

  else if FormName = 'MEDICAL' then
    case FieldId of
      113 .. 133:
        begin
          GetPatientsInfo(RetNo);
          Result := true;
        end
    end

  else if ExtractNonInstFormName(FormName) = 'MEDSUPL' then // 20160907 Igor
    case FieldId of
      133 .. 153:
        begin
          GetPatientsInfo(RetNo);
          Result := true;
        end
    end

  else if FormName = 'PTRANSIT' then
    case FieldId of
      3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57,
        60, 63, 66, 69, 72, 75:
        begin
          GetDependantsForTransit(RetNo);
          Result := true;
        end
    end

  else if FormName = 'NS428' then
    case FieldId of
      86, 90, 94, 98:
        begin
          GetKidsUnder6(RetNo);
          Result := true;
        end
    end

  else if FormName = 'NU428' then
    case FieldId of
      156, 160, 164, 168, 172, 176, 180, 184:
        begin
          GetKidsUnder6(RetNo);
          Result := true;
        end
    end

  else if FormName = 'PE428' then
    case FieldId of
      156, 161, 166, 171, 176:
        begin
          GetKidsUnder6(RetNo);
          Result := true;
        end
    end

  else if FormName = 'FITNESS' then
    case FieldId of
      6, 17, 28, 39, 50:
        begin
          GetKidsForFitness(RetNo);
          Result := true;
        end
    end

  else if FormName = 'ARTS' then
    case FieldId of
      6, 17, 28, 39, 50:
        begin
          GetKidsForArts(RetNo);
          Result := true;
        end
    end

  else if FormName = 'MBFITNES' then
    case FieldId of
      6, 17, 28, 39, 50:
        begin
          GetMBKidsForFitness(RetNo);
          Result := true;
        end
    end

  Else If (ExtractNonInstFormName(FormName) = 'MIA') then // 20160907 Igor
    case FieldId of
      1:
        begin
          SomeCaption := 'Farming Statements';
          GetListOfFarmingStatements(RetNo, SomeList);
          Result := true;
        end;
    end

  Else If (ExtractNonInstFormName(FormName) = 'T1163') // 20160907 Igor
  then
    case FieldId of

      14, 205:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
          SelectedString := PopSomeList(SomeList, SomeCaption);
          s := SelectedString;

          StoreElm(RetNo, GetFormNo(FormName), FieldId, SelectedString);
          Result := true;

        end;

      32:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
          SelectedString := PopSomeList(SomeList, SomeCaption);
          s := SelectedString;

          If (s = 'ON') or (s = 'AB') or (s = 'PE') or (s = 'SK') then
          // 20220223
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, SelectedString);
            Result := true;
          end;
        end;

      //jz//20260225 - moved to PopulateCAISPickList
      {
      //T1163
      219, 222, 225, 228, 231, 234, 237, 240, 243, 246, 249, 252, 255, 258, 261,
        264, 267, 270, 273, 276, 279, 282, 285, 288, 291, 294, 297, 300, 303:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          s := LeftStr(SelectedString, 3);
          If Numeric(LeftStr(s, 1)) = true then // 20111227
          Begin
            If s = '888' then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                GetUserCaisCodeDescr(s));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                AllTrim(MidStr(SelectedString, 5, 36)));
            end;
            Result := true;
          end;
          exit;
        end;
      }

      //jz//20260225 - moved to PopulateCAISPickList
      {
      //T1163
      402, 405, 408, 411, 414, 417, 420, 423, 426, 429, 432, 435, 438, 441, 444,
        447, 450, 453, 456:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          s := LeftStr(SelectedString, 3);
          If Numeric(LeftStr(s, 1)) = true then // 20111227
          Begin
            If s = '999' then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                GetUserCaisCodeDescr(s));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                AllTrim(MidStr(SelectedString, 5, 48))); // 20150110
              // StoreElm(RetNo,GetFormNo(FormName),FieldId-1,AllTrim(MidStr(SelectedString,5,36)));
            end;
            Result := true;
          end;
          exit;
        end;
        }
    end // end T1163 ------------------------------------------------------------

  Else If (ExtractNonInstFormName(FormName) = 'T1273') then
    case FieldId of

      14:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
          SelectedString := PopSomeList(SomeList, SomeCaption);
          s := SelectedString;

          StoreElm(RetNo, GetFormNo(FormName), FieldId, SelectedString);
          Result := true;

        end;

      32:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
          SelectedString := PopSomeList(SomeList, SomeCaption);
          s := SelectedString;

          If (s = 'BC') or (s = 'MB') or (s = 'NB') or (s = 'NL') or (s = 'NS')
            or (s = 'SK') or (s = 'YT') then
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, SelectedString);
          end;
          Result := true;
        end;

      27:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'District/County/Municipality Names';
          If FileExists(AppDir + '\' + 'DISTR' + FetchELm(RetNo, FormName, 32) +
            '.D') then
            SomeList.LoadFromFile(AppDir + '\' + 'DISTR' + FetchELm(RetNo,
              FormName, 32) + '.D')
          else
            SomeList.clear;
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          If Numeric(LeftStr(SelectedString, 1)) then
          begin
            s := MidStr(SelectedString, 5, 50);
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              LeftStr(SelectedString, 3));
          end;
          // SomeList.Clear;
          Result := true;
          exit;
        end;

      205:
        begin
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
          Result := true;
        end;

      //jz//20260225 - moved to PopulateCAISPickList
      {
      //T1273
      219, 222, 225, 228, 231, 234, 237, 240, 243, 246, 249, 252, 255, 258, 261,
        264, 267, 270, 273, 276, 279, 282, 285, 288, 291, 294, 297, 300, 303:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;

          s := LeftStr(SelectedString, 3);
          If Numeric(LeftStr(s, 1)) = true then // 20111227
          Begin
            If (s = '888') then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                GetUserCaisCodeDescr(s));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                AllTrim(MidStr(SelectedString, 5, 49))); // 20150110
              // StoreElm(RetNo,GetFormNo(FormName),FieldId-1,AllTrim(MidStr(SelectedString,5,36)));
            end;
            Result := true;
          end;
          exit;
        end;
      }
      //jz//20260225 - moved to PopulateCAISPickList
      {
      //T1273
      402, 405, 408, 411, 414, 417, 420, 423, 426, 429, 432, 435, 438, 441, 444,
        447, 450, 453, 456:
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          // result := LeftStr(SelectedString,3);
          // If (result='999')   then
          s := LeftStr(SelectedString, 3);
          If Numeric(LeftStr(s, 1)) = true then // 20111227
          Begin
            If (s = '999') then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                GetUserCaisCodeDescr(s));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId - 1,
                AllTrim(MidStr(SelectedString, 5, 48))); // 20150110
            end;
            Result := true;
          end;
          exit;
        end;
       }

      807, 811, 815, 819, 823, 827, 831, 835, 839, 843, 847, 851, 855:
      // live inv SECTION 7
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAISL1L2.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          // result := LeftStr(SelectedString,4);
          // If result='4001' then
          s := LeftStr(SelectedString, 4);
          If s = '4001' then
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              GetUserCaisCodeDescr(s,''));
          end
          else
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            // StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,9,73))); //20140404
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              AllTrim(MidStr(SelectedString, 37, 73)));
          end;
          Result := true;
          exit;
        end;

      859, 866, 873, 880, 887, 894, 901, 908, 915, 922, 929, 936, 943:
      // crop inv SECTION 8
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAISCROP.d');
          // 'CAISL1L2.D');  //20140406
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          If Numeric(LeftStr(SelectedString, 4)) then
          begin
            // result := LeftStr(SelectedString,4);
            // If result='4000' then
            s := LeftStr(SelectedString, 4);
            If s = '4000' then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                GetUserCaisCodeDescr(s,''));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 9, 73))); // 20140404
              // StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,37,73)));
            end;
          end;
          Result := true;
          exit;
        end;

      861, 868, 875, 882, 889, 896, 903, 910, 917, 924, 931, 938, 945:
      // crop units
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS Units of Measure';
          SelectedString := PopSomeFile(AppDir + '\' + 'CaisUnit.D',
            SomeCaption);
          s := SelectedString;
          If s > '' then
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
          // result := SelectedString //MidStr(SelectedString,4,16)
          Result := true;
          exit;
        end;

      1092, 1096, 1100, 1104, 1108: // section 9 - productive capacity
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAISL5.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          // result := LeftStr(SelectedString,4);
          // If (result='4005') then
          s := LeftStr(SelectedString, 4);
          If (s = '4005') then
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              GetUserCaisCodeDescr(s,''));
          end
          else
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              AllTrim(MidStr(SelectedString, 5, 39)));
            If FetchELm(RetNo, FormName, FieldId + 2) = '' then
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 2,
                AllTrim(MidStr(SelectedString, 47, 30))); // 20090125
          end;
          Result := true;
          exit;
        end;

      //jz//20260225 - moved to PopulateCAISPickList
      {
      //1273
      1029, 1032, 1035, 1038, 1041, 1044, 1047, 1050:
      // Section 11 deferred income
        begin
          SomeList.clear; // :=TStringList.Create;  //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          s := AllTrim(LeftStr(SelectedString, 4));
          If Numeric(LeftStr(s, 1)) = true then // 20111227
          Begin
            If (s = '4003') then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                GetUserCaisCodeDescr(s));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 5, 39)));
            end;
            Result := true;
          end;
          exit;
        end;
      }
        {
        //jz//20260225 - moved to PopulateCAISPickList
        //1273
        1005, 1008, 1011, 1014, 1017, 1020, 1023, 1026, 1053, 1056, 1059, 1062,
        1065, 1068, 1071, 1074: // Section 10 -purch inputs and accounts payable
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'Select codes';
          SomeList.Add('1. Income/Expense codes');
          SomeList.Add('2. Commodity codes');
          SelectedString := PopSomeList(SomeList, SomeCaption);
          If LeftStr(SelectedString, 1) = '1' then
          begin
            SomeList.clear; // :=TStringList.Create; //20160907 Igor
            SomeCaption := 'Valid entries';
            SelectedString := PopSomeFile(AppDir + '\' + 'CaisExp.D',
              SomeCaption);
            // result := LeftStr(SelectedString,4);
            // If (result='4002') or (result='4004') then
            s := LeftStr(SelectedString, 4);
            If (s = '4002') or (s = '4004') then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                GetUserCaisCodeDescr(s,''));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 6, 43)));
            end;
          end
          Else If LeftStr(SelectedString, 1) = '2' then
          begin
                SomeList.clear;
                //flName      := 'CAIS.D';
                // FieldId2Adj := -1;
                //defaultCodeLine := '888    Commodity Sales/Program Payments (supply your own description)';
                PopulateCAISPickListVal(RetNo,FieldId,1,SomeCaption,'CAIS.D',FormName,'',SomeList);
                result := true;
                exit;
          end;
          Result := true;
          exit;

        end;
        }
    end

  else if ExtractNonInstFormName(FormName) = 'T1273A1' then
  begin
    case FieldId of
      7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55: // live inv SECTION 7
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAISL1L2.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          // result := LeftStr(SelectedString,4);
          // If result='4001' then
          s := LeftStr(SelectedString, 4);
          If s = '4001' then
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              GetUserCaisCodeDescr(s,''));
          end
          else
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              AllTrim(MidStr(SelectedString, 37, 73)));
          end;
          Result := true;
          exit;
        end;

      59, 66, 73, 80, 87, 94, 101, 108, 115, 122, 129, 136, 143:
      // crop inv SECTION 8
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAISCrop.D'); // 20140406
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          If Numeric(LeftStr(SelectedString, 4)) then
          begin
            // result := LeftStr(SelectedString,4);
            // If result='4000' then
            s := LeftStr(SelectedString, 4);
            If s = '4000' then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                GetUserCaisCodeDescr(s,''))
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 9, 73))); // 20140406
            end;
          end;
          Result := true;
          exit;
        end;

      61, 68, 75, 82, 89, 96, 103, 110, 117, 124, 131, 138, 145: // crop units
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS Units of Measure';
          SelectedString := PopSomeFile(AppDir + '\' + 'CaisUnit.D',
            SomeCaption);
          If SelectedString > '' then
          begin
            // result := SelectedString //MidStr(SelectedString,4,16)
            s := SelectedString; // MidStr(SelectedString,4,16)
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
          end;
          Result := true;
        end;
    end;
  end // end T1273A1 -------------------------------------------------------------------------------

  else if ExtractNonInstFormName(FormName) = 'T1273A2' then
  begin
    case FieldId of
      92, 96, 100, 104, 108: // section 9 - productive capacity
        begin
          SomeList.clear; // :=TStringList.Create;  //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAISL5.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          // result := LeftStr(SelectedString,4);
          // If (result='4005') then
          s := LeftStr(SelectedString, 4);
          If (s = '4005') then
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              GetUserCaisCodeDescr(s,''));
          end
          else
          begin
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
            StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
              AllTrim(MidStr(SelectedString, 5, 39)));
            If FetchELm(RetNo, FormName, FieldId + 2) = '' then
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 2,
                AllTrim(MidStr(SelectedString, 47, 30))); // 20090125
            // StoreElm(RetNo,GetFormNo(FormName),FieldId+2,AllTrim(MidStr(SelectedString,47,18)));
          end;
          Result := true;
          exit;
        end;

      //jz//20260225 - moved to PopulateCAISPickList
      {
      //T1273A2
      29, 32, 35, 38, 41, 44, 47, 50: // Section 11 deferred income
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'CAIS codes';
          SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
          Application.CreateForm(TSearchListT1_2026, SearchList);
          SearchList.ShowModal;
          SearchList.Free;
          // result := AllTrim(LeftStr(SelectedString,4));
          // If (result='4003') then
          s := AllTrim(LeftStr(SelectedString, 4));
          If Numeric(LeftStr(s, 1)) = true then // 20111227
          begin
            If (s = '4003') then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                GetUserCaisCodeDescr(s));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 5, 39)));
            end;
            Result := true;
          end;
          exit;
        end;
      }

      //jz//20260225 - moved to PopulateCAISPickList
      {
      //T1273A2
      5, 8, 11, 14, 17, 20, 23, 26, 53, 56, 59, 62, 65, 68, 71, 74:
      // Section 10 -purch inputs and accounts payable
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'Select codes';
          SomeList.Add('1. Income/Expense codes');
          SomeList.Add('2. Commodity codes');
          SelectedString := PopSomeList(SomeList, SomeCaption);
          If LeftStr(SelectedString, 1) = '1' then
          begin
            SomeList.clear; // :=TStringList.Create; //20160907 Igor
            SomeCaption := 'Valid entries';
            SelectedString := PopSomeFile(AppDir + '\' + 'CaisExp.D',
              SomeCaption);
            // result := LeftStr(SelectedString,4);
            // If (result='4002') or (result='4004') then
            s := LeftStr(SelectedString, 4);
            If (s = '4002') or (s = '4004') then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                GetUserCaisCodeDescr(s,''));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 6, 43)));
            end;
          end
          Else If LeftStr(SelectedString, 1) = '2' then
          begin
            SomeList.clear; // :=TStringList.Create; //20160907 Igor
            SomeCaption := 'CAIS codes';
            SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
            Application.CreateForm(TSearchListT1_2026, SearchList);
            SearchList.ShowModal;
            SearchList.Free;
            s := LeftStr(SelectedString, 3);
            If Numeric(LeftStr(s, 1)) = true then // 20111227
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 5, 39)));
            end;
          end;
          Result := true;
          exit;
      end;
      }
    end;
  end // end T1273A2 -------------------------------------------------------------------------------

  Else If (ExtractNonInstFormName(FormName) = 'ONEETC') then // 20160907 Igor
    case FieldId of
      1, 2:
        begin
          SomeCaption := 'Select a child';
          GetDependantsList(RetNo);
          Result := true;
        end
    end

  Else If (ExtractNonInstFormName(FormName) = 'T1139') then // 20160907 Igor
    case FieldId of
      2:
        begin
          SomeCaption :=
            'Statement  YearEnd           NetIncome          BusinessName';
          GetOddBusStatements(RetNo);
          Result := true;
        end
    end

end;


//jz//20260224
Function TFormT1_2026.PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj:integer;SomeCaption,flName,FormName,defaultCodeLine:string;var SomeList:Tstringlist):boolean;
var
  s:string;
  delimPos:integer;
begin
  SomeList.clear; // :=TStringList.Create; //20160907 Igor
  SomeCaption := 'CAIS codes';
  SomeList.LoadFromFile(AppDir + '\' + flName);

  if defaultCodeLine > '' then 
    SomeList[1] := defaultCodeLine;
  
  Application.CreateForm(TSearchListT1_2026, SearchList);
  SearchList.ShowModal;
  SearchList.Free;

  delimPos :=  pos('|',SelectedString);               //jz//20260223 added delimiter to cais.d,find it, use it for the string manipulations
  if delimPos = 0 then delimPos := 5;                 //jz//20260225 make usable if no delim 

  s := alltrim(LeftStr(SelectedString, delimPos-1));  //jz//20260223 use delim
  If Numeric(LeftStr(s, 1)) = true then // 20111227
  Begin
    case strtoint(s) of 000,888,999,4000..4005:
        begin
          StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
          if s = '000' then 
          begin
            s := GetUserCaisCodeDescr(s,'D');
            StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
          end;
          StoreElm(RetNo, GetFormNo(FormName), FieldId + FieldId2Adj, GetUserCaisCodeDescr(s,''));
        end //end of strtoint(s)
        else
        begin
          StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
          StoreElm(RetNo, GetFormNo(FormName), FieldId + FieldId2Adj, AllTrim(MidStr(SelectedString, delimPos+1, 49))); //jz//20260223 use delimiter
        end; //end else
    end; //end case

    Result := true;
  end; //end If s Numeric
end; //end PopulateCAISPickListVal


Function TFormT1_2026.PopulateCAISPickList(eBox: TvtEdit; FieldId: Integer;SomeList: TStringList): Boolean;
Var
  i: Integer;
  s, FromFname,defaultCodeLine: string;
  flName:string;
  FieldId2Adj : integer;
  FromElm: Integer;
begin
  Result := false;

  if not assigned(SomeList) then // 20160907 igor
    SomeList := TSingleStringList.Create; // 20160907 igor

  IF (ExtractNonInstFormName(FormName) = 'T1163') or (ExtractNonInstFormName(FormName) = 'T1273') then
  BEGIN
      case FieldId of

        //1163 and T1273 are the same for these elms
        //for this group code 888 is the GetUserCaisCodeDescr default, not others, they shouldnt be available but they are, revisit sometime
        219, 222, 225, 228, 231, 234, 237, 240, 243, 246, 249, 252, 255, 258,
        261, 264, 267, 270, 273, 276, 279, 282, 285, 288, 291, 294,
        297, 300, 303:
        begin
          SomeList.clear;
          flName      := 'CAIS.D';
          FieldId2Adj := -1;
          defaultCodeLine := '888    Commodity Sales/Program Payments (supply your own description)';
          PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,defaultCodeLine,SomeList);
          result := true;
          exit;
        end;

        //1163 and T1273 are the same for these elms
        //for this group code 999 is the GetUserCaisCodeDescr default, not others, they shouldnt be available but they are, revisit sometime
        402, 405, 408, 411, 414, 417, 420, 423, 426, 429, 432, 435, 438, 441,
        444, 447, 450, 453, 456:
        begin
          SomeList.clear;
          flName      := 'CAIS.D';
          FieldId2Adj := -1;
          defaultCodeLine := '999    Commodity Sales/Program Payments (supply your own description)';
          PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,defaultCodeLine,SomeList);
          result := true;
          exit;
        end;
      END; //case

      IF      ExtractNonInstFormName(FormName) = 'T1163' then
      BEGIN
        //
      END
      ELSE IF ExtractNonInstFormName(FormName) = 'T1273' then
      BEGIN
          case FieldId of
            //1273 // Section 11 deferred income
            //for this group code 4003 is the GetUserCaisCodeDescr default, not others, they shouldnt be available but they are, revisit sometime
            1029, 1032, 1035, 1038, 1041, 1044, 1047, 1050:
            begin
              SomeList.clear;
              flName      := 'CAIS.D';
              FieldId2Adj := 1;
              defaultCodeLine := '4003   Commodity Sales/Program Payments (supply your own description)';
              PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,defaultCodeLine,SomeList);
              result := true;
              exit;
            end;

            //1273 // Section 10 -purch inputs and accounts payable
            1005, 1008, 1011, 1014, 1017, 1020, 1023, 1026,
            1053, 1056, 1059, 1062, 1065, 1068, 1071, 1074:
            begin
              SomeList.clear; // :=TStringList.Create; //20160907 Igor
              SomeCaption := 'Select codes';
              SomeList.Add('1. Income/Expense codes');
              SomeList.Add('2. Commodity codes');
              SelectedString := PopSomeList(SomeList, SomeCaption);
              If LeftStr(SelectedString, 1) = '1' then
              begin
                SomeList.clear;
                SomeCaption := 'Valid entries';
                flName      := 'CaisExp.D';
                FieldId2Adj := 1;
                defaultCodeLine := '';
                PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,defaultCodeLine,SomeList);
              end
              Else If LeftStr(SelectedString, 1) = '2' then
              begin
                    SomeList.clear;
                    flName      := 'CAIS.D';
                    FieldId2Adj := 1;
                    //defaultCodeLine := '888    Commodity Sales/Program Payments (supply your own description)';
                    PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,'',SomeList);
              end;
              Result := true;
              exit;
            end;
          end;
      END;
  END
  ELSE IF ExtractNonInstFormName(FormName) = 'T1273A2' then
  BEGIN

      case FieldId of
        //T1273A2 // Section 11 deferred income
        //for this group code 4003 is the GetUserCaisCodeDescr default, not others, they shouldnt be available but they are, revisit sometime
        29, 32, 35, 38, 41, 44, 47, 50:
        begin
          SomeList.clear;
          flName      := 'CAIS.D';
          FieldId2Adj := 1;
          defaultCodeLine := '4003   Commodity Sales/Program Payments (supply your own description)';
          PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,defaultCodeLine,SomeList);
          result := true;
          exit;
        end;

      //T1273A2
      5, 8, 11, 14, 17, 20, 23, 26, 53, 56, 59, 62, 65, 68, 71, 74:
      // Section 10 -purch inputs and accounts payable
        begin
          SomeList.clear; // :=TStringList.Create; //20160907 Igor
          SomeCaption := 'Select codes';
          SomeList.Add('1. Income/Expense codes');
          SomeList.Add('2. Commodity codes');
          SelectedString := PopSomeList(SomeList, SomeCaption);
          If LeftStr(SelectedString, 1) = '1' then
          begin
            SomeList.clear;
            SomeCaption := 'Valid entries';
            flName      := 'CaisExp.D';
            FieldId2Adj := 1;
            defaultCodeLine := '';
            PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,defaultCodeLine,SomeList);

            {
            SomeList.clear; // :=TStringList.Create; //20160907 Igor
            SomeCaption := 'Valid entries';
            SelectedString := PopSomeFile(AppDir + '\' + 'CaisExp.D',
              SomeCaption);
            // result := LeftStr(SelectedString,4);
            // If (result='4002') or (result='4004') then
            s := LeftStr(SelectedString, 4);
            If (s = '4002') or (s = '4004') then
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                GetUserCaisCodeDescr(s,''));
            end
            else
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 6, 43)));
            end;
            }
          end
          Else If LeftStr(SelectedString, 1) = '2' then
          begin
            SomeList.clear;
            flName      := 'CAIS.D';
            FieldId2Adj := 1;
            defaultCodeLine := '';
            PopulateCAISPickListVal(RetNo,FieldId,FieldId2Adj,SomeCaption,flName,FormName,defaultCodeLine,SomeList);
            //result := true;
            //exit;



            {

            SomeList.clear; // :=TStringList.Create; //20160907 Igor
            SomeCaption := 'CAIS codes';
            SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
            Application.CreateForm(TSearchListT1_2026, SearchList);
            SearchList.ShowModal;
            SearchList.Free;
            s := LeftStr(SelectedString, 3);
            If Numeric(LeftStr(s, 1)) = true then // 20111227
            begin
              StoreElm(RetNo, GetFormNo(FormName), FieldId, s);
              StoreElm(RetNo, GetFormNo(FormName), FieldId + 1,
                AllTrim(MidStr(SelectedString, 5, 39)));
            end;
            }
          end; //end else if 2
          Result := true;
          exit;
      end;




{
        //T1273A2
        5, 8, 11, 14, 17, 20, 23, 26, 53, 56, 59, 62, 65, 68, 71, 74:
        // Section 10 -purch inputs and accounts payable
        begin
            SomeList.clear;
            // := TSingleStringList.Create;; //20150814 igor //20160907 Igor
            SomeCaption := 'Select codes';
            SomeList.Add('1. Income/Expense codes');
            SomeList.Add('2. Commodity codes');
            SelectedString := PopSomeList(SomeList, SomeCaption);
            If LeftStr(SelectedString, 1) = '1' then
            begin
              SomeCaption := 'Valid entries';
              SelectedString := PopSomeFile(AppDir + '\' + 'CaisExp.D',
                SomeCaption);
              Result := LeftStr(SelectedString, 4);
              If (Result = '4002') or (Result = '4004') then
                StoreElm(RetNo, FormName, FieldId + 1,
                  GetUserCaisCodeDescr(Result,''))
              else
                StoreElm(RetNo, FormName, FieldId + 1,
                  AllTrim(MidStr(SelectedString, 6, 43)));
              exit;
            end
            Else If LeftStr(SelectedString, 1) = '2' then
            begin
              SomeList.clear;
              // := TSingleStringList.Create;; //20150814 igor //20160907 igor
              SomeCaption := 'CAIS codes';
              SomeList.LoadFromFile(AppDir + '\' + 'CAIS.D');
              Application.CreateForm(TSearchListT1_2026, SearchList);
              SearchList.ShowModal;
              SearchList.Free;
              Result := LeftStr(SelectedString, 3);
              If Numeric(LeftStr(Result, 1)) = true then // 20111227
              begin
                StoreElm(RetNo, FormName, FieldId + 1,
                  AllTrim(MidStr(SelectedString, 5, 39)));
              end;
              exit;
            end
            else
              exit;
        end;
      }
      end; //end case

  END; //end if T1273A2

end;



Function TFormT1_2026.CleanUpPickedListValue(FieldId: Integer;
  SelectedString: String): string;
Begin
  Result := SelectedString;

  If (FormName = 'INFO') and (FieldId = 49) then
    Result := LeftStr(SelectedString, 2);
  If (FormName = 'INFO') and (FieldId = 14) then // 20110714
    Result := LeftStr(SelectedString, 2);

  If (FormName = 'INFO') and (FieldId = 47) then  Result := LeftStr(SelectedString, 1);
  If (FormName = 'INFO') and (FieldId = 53) then  Result := LeftStr(SelectedString, 1);
  If (FormName = 'INFO') and (FieldId = 69) then  Result := LeftStr(SelectedString, 3); //fcountry //20240323


  If (FormName = 'INFO') and (FieldId = 222) then //residencytype
    Result := SelectedString;

    //20240715 Igor >>>
   if Leftstr(FormName,6)='T2057#' then result:=AllTrim(MidStr(SelectedString,3,30));
//   if Leftstr(FormName,41)='T2057#' then result:=AllTrim(MidStr(SelectedString,3,30));
    //20240715 Igor <<<

  //20251223 Igor >>>
  if FormName.Equals('T106') then
  begin
    case FieldId of
      2, 67, 72: Result:= LeftStr(SelectedString, 3);
      35, 36, 37, 38: Result:= LeftStr(SelectedString, 6);
      60: Result:= LeftStr(SelectedString, 2);
    end;
  end;

  if ExtractNonInstFormName(FormName).Equals('T106SL') then
  begin
    case FieldId of
     13: Result:= LeftStr(Result, 3);
     19, 20, 21, 22: Result:= LeftStr(Result, 6);
     24, 25, 26, 27: result:= LeftStr(Result, 3);
     33, 121, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89,
     35, 123, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91: Result:= LeftStr(Result, 1);
    end;
  end;
  //20251223 Igor <<<

  If (LeftStr(FormName,3) = 'T4#') then
   Result := LeftStr(SelectedString, 2); //20240110 // 20131219 //Result := LeftStr(SelectedString, 1); // 20131219

  If (FormName = 'T1135') then
    Result := LeftStr(SelectedString, 3); // 20130720
  If (LeftStr(FormName, 5) = 'T2091') and (FieldId = 22) then
    Result := LeftStr(SelectedString, 3); // 20180407

  // 20160430 Igor
  // 20160409
  If (ExtractNonInstFormName(FormName) = 'T2201') and (FieldId = 35) then
  // 20160907 Igor
  begin
    If SelectedString > '' then
      Result := LeftStr(SelectedString, 3);
    If SelectedString > '' then
    Begin
      StoreElm(RetNo, GetFormNo(FormName), 1, MidStr(SelectedString, 5, 15));
      // fn
      StoreElm(RetNo, GetFormNo(FormName), 2, MidStr(SelectedString, 16, 30));
      // lastnm
      StoreElm(RetNo, GetFormNo(FormName), 11, MidStr(SelectedString, 46, 10));
      // birthdate

    end;
  end;

  If (FormName = 'MEDICAL') and (FieldId >= 113) and (FieldId <= 133) then
  begin
    If SelectedString > '' then
      Result := LeftStr(SelectedString, 3);
    If SelectedString > '' then
      StoreElm(RetNo, 'MEDICAL', 6 + (FieldId - 113) * 5,
        MidStr(SelectedString, 5, 15));
  end;

  If (ExtractNonInstFormName(FormName) = 'MEDSUPL') and (FieldId >= 133) and
    (FieldId <= 153) then // 20160907 Igor
  begin
    If SelectedString > '' then
      Result := LeftStr(SelectedString, 3);
    If SelectedString > '' then
      StoreElm(RetNo, FormName, 6 + (FieldId - 133) * 5,
        MidStr(SelectedString, 5, 15));
  end;

  // 20101106
  If (ExtractNonInstFormName(FormName) = 'RC62') and
    ((FieldId = 9) or (FieldId = 10)) then // 20160907 Igor
  begin
    If SelectedString > '' then
      Result := LeftStr(SelectedString, 3);
    If SelectedString > '' then
    Begin
      If FieldId = 9 then
        StoreElm(RetNo, FormName, 4, MidStr(SelectedString, 5, 15))
      Else If FieldId = 10 then
        StoreElm(RetNo, FormName, 8, MidStr(SelectedString, 5, 15));
    end
  end;

  // 20160430 Igor
  If (ExtractNonInstFormName(FormName) = 'T1139') and (FieldId = 2) then
    Result := LeftStr(SelectedString, 7); // 20160907 Igor
  If (ExtractNonInstFormName(FormName) = 'T2201') and (FieldId = 36) then
    Result := LeftStr(SelectedString, 3); // 20160411 //20160907 Igor

  If (ExtractNonInstFormName(FormName) = 'UHT')  //20230628
  then // 20160907 Igor
  begin
    If (FieldId = 6) or (FieldId = 14) or (FieldId = 27) then
      Result := trim(LeftStr(SelectedString, 2));
    If (FieldId = 15) or (FieldId = 7) then
      Result := LeftStr(SelectedString, 3);
  end;


  If (ExtractNonInstFormName(FormName) = 'ASSETSB')
  then // 20160907 Igor
  begin
    If (FieldId = 215) or (FieldId = 221) or (FieldId = 227) then
      Result := trim(LeftStr(SelectedString, 8)); // 20160422 Igor
    If (FieldId = 134) then
      Result := LeftStr(SelectedString, 4);
  end;

  If (ExtractNonInstFormName(FormName) = 'AUTOS') then // 20160907 Igor
  begin
    If (FieldId = 215) or (FieldId = 221) or (FieldId = 227) then
      Result := trim(LeftStr(SelectedString, 8)); // 20160422 Igor
  end;

  If FormName = 'S11' then
  begin
    If FieldId = 26 then
      Result := LeftStr(SelectedString, 9);
  end;

  If FormName = 'S11PRV' then // 20120205
  begin
    If FieldId = 26 then
      Result := LeftStr(SelectedString, 9);
  end;

  If (ExtractNonInstFormName(FormName) = 'T5') and (FieldId = 21) then
  // 20160907 Igor
  begin
    Result := AllTrim(LeftStr(SelectedString, 30));
    StoreElm(RetNo, FormNo, 4, AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If (FormName = 'FECONV') and (FieldId = 1) then
  begin
    Result := AllTrim(LeftStr(SelectedString, 30));
    If UpperCase(FetchELm(RetNo, 'FECONV', 5)) = 'Y' then
      StoreElm(RetNo, FormNo, 2, AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If (ExtractNonInstFormName(FormName) = 'T3MULT') and // 20160907 Igor
    ((FieldId = 59) or (FieldId = 60) or (FieldId = 61) or (FieldId = 62) or
    (FieldId = 63)) then
  begin
    Result := AllTrim(LeftStr(SelectedString, 13));
    StoreElm(RetNo, FormNo, FieldId + 6,
      AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If (FormName = 'EFMEMO') and (FieldId = 42) then
    Result := AllTrim(LeftStr(SelectedString, 1));

  If (ExtractNonInstFormName(FormName) = 'T2202') and (FieldId = 72) then
  // 20200319
  begin
    Result := AllTrim(LeftStr(SelectedString, 30));
    StoreElm(RetNo, FormNo, 70, AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If (ExtractNonInstFormName(FormName) = 'FPENS') and (FieldId = 9) then
  // 20160907 Igor
  begin
    Result := AllTrim(LeftStr(SelectedString, 30));
    StoreElm(RetNo, FormNo, 3, AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If (ExtractNonInstFormName(FormName) = 'T5MULT') and // 20160907 Igor
    ((FieldId = 21) or (FieldId = 43) or (FieldId = 65) or (FieldId = 87) or
    (FieldId = 109)) then
  begin
    Result := AllTrim(LeftStr(SelectedString, 13));
    StoreElm(RetNo, FormNo, FieldId - 17,
      AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If (ExtractNonInstFormName(FormName) = 'T776A') and (FieldId <> 2) then
  // 20160907 Igor
    Result := LeftStr(SelectedString, 4);

  If (ExtractNonInstFormName(FormName) = 'T2042') and (FieldId = 101) then
  // 20160907 Igor
    Result := LeftStr(SelectedString, 10);

  If (ExtractNonInstFormName(FormName) = 'ACBFRM') and (FieldId >= 475) and
    (FieldId <= 520) then // 20160907 Igor
  begin
    Result := LeftStr(SelectedString, 3);
    // result := LeftStr(SelectedString,5); July 3 208
    StoreElm(RetNo, FormNo, 429 + FieldId - 475,
      MidStr(SelectedString, 31, 10));
  end;

  If FormName = 'NS428' then
  begin
    If (FieldId = 86) or (FieldId = 90) or (FieldId = 94) or (FieldId = 98) then
    begin
      Result := AllTrim(LeftStr(SelectedString, 40));
      StoreElm(RetNo, FormNo, FieldId + 1,
        AllTrim(MidStr(SelectedString, 41, 10)));
      StoreElm(RetNo, FormNo, FieldId + 2,
        AllTrim(MidStr(SelectedString, 51, 10)));
    end;
  end;

  // 20110116
  If FormName = 'NU428' then
  begin
    If (FieldId = 156) or (FieldId = 160) or (FieldId = 164) or (FieldId = 168)
      or (FieldId = 172) or (FieldId = 176) or (FieldId = 180) or (FieldId = 184)
    then
    begin
      Result := AllTrim(LeftStr(SelectedString, 40));
      StoreElm(RetNo, FormNo, FieldId + 1,
        AllTrim(MidStr(SelectedString, 41, 10)));
      StoreElm(RetNo, FormNo, FieldId + 2,
        AllTrim(MidStr(SelectedString, 51, 10)));
    end;
  end;

  // 20110116
  If FormName = 'PE428' then
  begin
    If (FieldId = 156) or (FieldId = 161) or (FieldId = 166) or (FieldId = 171)
      or (FieldId = 176) then
    begin
      Result := AllTrim(LeftStr(SelectedString, 40));
      StoreElm(RetNo, FormNo, FieldId + 1,
        AllTrim(MidStr(SelectedString, 41, 10)));
      StoreElm(RetNo, FormNo, FieldId + 2,
        AllTrim(MidStr(SelectedString, 51, 10)));
    end;
  end;

  If (FormName = 'FITNESS') or (FormName = 'ARTS')
  // or (FormName = 'CATC') //20171119
    or (FormName = 'MBFITNES') then // 20111120
  begin
    If (FieldId = 6) or (FieldId = 17) or (FieldId = 28) or (FieldId = 39) or
      (FieldId = 50) then
    begin
      Result := AllTrim(LeftStr(SelectedString, 40));
      If AllTrim(MidStr(SelectedString, 61, 5)) = 'Y' then // 20121115
        // If MidStr(SelectedString,61,5)>'' then
        StoreElm(RetNo, FormNo, 62 + Trunc(FieldId / 11), 'X')
      else
        StoreElm(RetNo, FormNo, 62 + Trunc(FieldId / 11), '');
    end;
  end;

  //20230811 Igor >>>
  if FormName = 'T1134' then
  Begin
    //20230411 Igor >>>
    FieldId := GetFirstElmId(RetNo,FormNo,FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
      40,41,42,43,20009,20010,20011,20012,30009,30010,30011,30012,40010,40011,40012,40013: Result:=LeftStr(Result,6); //20230510 Igor
      60003,70001,90004,110001: ; //20230601 Igor do nothing
      else Result:=LeftStr(Result,3);
    end;
    //20230411 Igor <<<
  End;

  if ExtractNonInstFormName(FormName) = 'T1134S' then  //20180507
  Begin
    //20230411 Igor >>>
    FieldId := GetFirstElmId(RetNo,FormNo,FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    Case FieldId of
     //20230510 Igor >>>
     //35: ; // do nothing
     10001,40001,120001,130001,150001: Result := Copy(Result, Pos(' - ', Result) + 3, Length(Result));
     20001,30001,50001,60001,70002,80002,90002,100002,110001,140001,160001: Result := Copy(Result, 1, Pos(' - ', Result) - 1);
     //20230510 Igor <<<
     40..43: Result:=LeftStr(Result,6)
     else Result:=LeftStr(Result,3);
    end;
    //20230411 Igor <<<
  End;
  //20230811 Igor <<<
end;

// 20170409 Igor >>>
procedure TFormT1_2026.ConditionCalc(AIdentificator: String;
  var AValue: Integer);
begin
  //
end;

procedure TFormT1_2026.ConditionCalc(AIdentificator: String;
  var AValue: Boolean);
begin
  if SameText(AIdentificator, 'TREFILEQ.vtGroupBox2.Printable') or
    SameText(AIdentificator, 'TREFILEQ.vtGroupBox2.Displayed') or
    SameText(AIdentificator, 'TREFILEQ.vtGroupBox2.Visible') then
  begin
    AValue := ret[GetCurrentRetNo].Lnn[10100] = 0;
  end;
end;

procedure TFormT1_2026.ConditionCalc(AIdentificator: String; var AValue: Real);
begin
  //
end;

procedure TFormT1_2026.ConditionCalc(AIdentificator: String;
  var AValue: String);
begin
  //
end;
// 20170409 Igor <<<

procedure TMyChildT1_2026.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  s, FormName: string;
  MyScrollBox: TvtScrollBox;
  vis: Boolean;
begin
  (* configure the popup - sender is always the ChildWin!
    This handler is *also* called by MyScrollBox, then it works!
  *)
  s := Sender.ClassName; // debug only
  MyScrollBox := ActiveForm;
  if MyScrollBox = nil then
  begin
    Handled := true;
    exit;
  end;
  FormName := MyScrollBox.FormName;
  // enable/disable entries
  with MainFormT1 do
  begin
    vis := FormName = 'DEPEND';
    RefreshALLdependants1.visible := vis;
    // SomeList.Add('Refresh ALL dependant'+Chr(39)+'s addresses from parent');
    RefreshALLdependants2.visible := vis;
    // SomeList.Add('________________________________________________');

    vis := (FormName = 'MEDICAL') or
      (ExtractNonInstFormName(FormName) = 'MEDSUPL'); // 20160907 Igor
    SortMedical1.visible := vis; // SomeList.Add('Sort Medical');
    SortMedical2.visible := vis;
    // SomeList.Add('_______________________________________________');

    vis := (ExtractNonInstFormName(FormName) = 'ACBFRM'); // 20160907 Igor
    SortACBBydate1.visible := vis; // SomeList.Add('Sort ACB By date');
    SortACBBydate2.visible := vis;
    // SomeList.Add('_______________________________________________');

    vis := IsFormMultiInst(FormName);
    NextStatement1.visible := vis; // SomeList.Add('Next Statement');
    PreviousStatement1.visible := vis; // SomeList.Add('Previous Statement');
    PreviousStatement2.visible := vis;
    // SomeList.Add('_______________________________________________');

    vis := RetInMem > 1; // tiling only multiple returns
    TileReturns1.visible := vis;
  end; // with
end;

Function AskingForSICCode(FormName: String; FieldId: Integer): Boolean;
begin
  Result := false;
  If ((ExtractNonInstFormName(FormName) = 'T2125') and (FieldId = 12)) or
    ((ExtractNonInstFormName(FormName) = 'T2121') and (FieldId = 11)) or
    ((ExtractNonInstFormName(FormName) = 'T2042') and (FieldId = 17)) or
    ((ExtractNonInstFormName(FormName) = 'T1163') and (FieldId = 34)) or
    ((ExtractNonInstFormName(FormName) = 'T1273') and (FieldId = 34)) then
    Result := true;
end;

procedure TFormT1_2026.GetSICCode(FieldId: Integer);
// procedure GetSICCode(RetNo: integer; FormName:String;FieldId:Integer);
begin
  If AskingForSICCode(FormName, FieldId) then
  begin
    MainFormT1.SICCodes1Click(Application);
    If Numeric(SelectedString) then
      ReplaceString(FieldId, SelectedString); { TODO 1 -oCon : check }
    exit;
  end;
end;

procedure TFormT1_2026.FormatDollar(MyEditBox: TvtEdit; str: string);
begin
  // FormatSettings.DecimalSeparator := ' '; //20161213 Igor
  If Vl(str) = 0 then
    MyEditBox.Text := ''
  else
    MyEditBox.Text := FormatAmount(str, MyEditBox.vtVertSeparator);
  If isT1273NoDecimalSection(FormName, GetFieldId(MyEditBox.Name)) then
    MyEditBox.Text := FormatNoDecimals(str, 0); // 20120123
end;

procedure TFormT1_2026.EditBoxMouseDown(MyEditBox: TvtEdit;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  HelpTopic: string; // [20];
  RefFormName, RefFieldId: String;
  FNo: Integer;
  Cinst: Integer;
  FName: string; // [12];
  DataList, FrmDataList: TStringList;
  LYrValue, FullFlName: String;
  FileFound: Boolean;
  MyFrame, NewFrame: TFrame;
  FieldId: Integer;
  Value: String;
  s: String;
  TempEditBox: TvtEdit;
  RadioElms: String;
  jj: Integer;
  vis: Boolean;
begin
  If ret[RetNo].IsLastYearReturn then
    exit; // 20110220

  FieldId := GetFieldId(MyEditBox.Name);

  If Button = mbLeft then
    inherited
  else If Button = mbRight then
  begin
    // set right click focus - john 20090525
    MyEditBox.setfocus;
    MyEditBox.Refresh;
    // try use fieldpopup - works!
    // configure menu
    with MainFormT1 do
    begin
      vis := (ExtractNonInstFormName(FormName) = 'ACBFRM'); // 20160907 Igor
      sortacbbyDate3.visible := vis;
      sortacbbyDate4.visible := vis;

      vis := FormName = 'DEPEND';
      RefreshALLdependantsaddressesfromparent1.visible := vis;
      RefreshALLdependantsaddressesfromparent2.visible := vis;

      vis := (FormName = 'INFO') and (ret[self.RetNo].CouplingSw = true);
      Refreshaddressfromotherspouse1.visible := vis;
      // SomeList.Add('Refresh address from other spouse');
      Refreshaddressfromotherspouse2.visible := vis;
      // SomeList.Add('------------------------------------------------');

      vis := LicenseLevel in [llDemo, llPower .. llMultiPower];
      Showwhatthevaluewaslastyear1.visible := vis;
      // SomeList.Add('Show what the value was last year');
      Showwhatthevaluewaslastyear2.visible := vis;
      // SomeList.Add('------------------------------------------------');

      vis := FieldId > 9999;
      AddRow1.visible := vis;
      DeleteRow1.visible := vis; // SomeList.Add('Delete Row');
      DeleteRow2.visible := vis; // SomeList.Add('------------------------');
      // show menu
      FieldPopup.PopupComponent := MyEditBox;
      // pos must be in screen coordinates
      FieldPopup.Popup(mouse.CursorPos.X, mouse.CursorPos.Y);
    end; // with
  end; { mbright }
end;

procedure TFormT1_2026.EditButtonClick(AEdit: TObject;
  AAction: TEditButtonAction; AEdit2: TObject = nil); // 20170411 Igor
begin
  case AAction of
    ebaInsertRow:
      begin
        if not assigned(AEdit) then
          exit;
        if not(AEdit is TvtEdit) then
          exit;
        InsertDynamicRowBefore(TvtEdit(AEdit));
      end;
    ebaRowUp:
      begin
        if not assigned(AEdit) then
          exit;
        if not(AEdit is TvtEdit) then
          exit;
        MoveDynamicRow(TvtEdit(AEdit), mdUp);
      end;
    ebaRowDown:
      begin
        if not assigned(AEdit) then
          exit;
        if not(AEdit is TvtEdit) then
          exit;
        MoveDynamicRow(TvtEdit(AEdit), mdDown);
      end;
    ebaDeleteRow:
      begin
        if not assigned(AEdit) then
          exit;
        if not(AEdit is TvtEdit) then
          exit;
        MoveDynamicRow(TvtEdit(AEdit), mdRemove);
      end;
    // 20170411 Igor >>>
    ebaMove:
      begin
        if not assigned(AEdit) then
          exit;
        if not(AEdit is TvtEdit) then
          exit;
        if (AEdit2 = nil) or not(AEdit2 is TvtEdit) or (AEdit2 = AEdit) then
          MoveDynamicRow(TvtEdit(AEdit), mdWithRequest)
        else
          MoveDynamicRow(TvtEdit(AEdit), TvtEdit(AEdit2));
      end;
    // 20170411 Igor <<<
  end;
end;

// 20170411 Igor >>>
function TFormT1_2026.SameTable(AField1, AField2: Integer): Boolean;
Begin
  Result := Inherited SameTable(AField1, AField2);
End;

function TFormT1_2026.SameColumn(AField1, AField2: Integer): Boolean;
Begin
  Result := Inherited SameColumn(AField1, AField2);
End;

function TFormT1_2026.isLastRow(AFieldID: Integer): Boolean;
Begin
  Result := Inherited isLastRow(AFieldID);
End;
// 20170411 Igor <<<

procedure TFormT1_2026.OnVtEditDblClick(MyEditBox: TvtEdit);
Var
  i: Integer;
  FName: string; // [12];
  NewString: String;
  // ElmsInError:TStringList;
  // MyEditBox:TVtEdit;
  FieldId, TargetLinkedField: Integer;
  P: TWinControl; // 20160121 Igor
begin
  // showmessage(sender.classname);
  // if not(MyChild.ActiveControl is TvtEdit) then //20160310 Igor
  // exit;

  // 20160314 Igor >>>
  if MyEditBox.ReadOnly then
    exit;

  P := MyEditBox.Parent;
  while assigned(P) do
  Begin
    if P is TvtScrollBox then
    Begin
      if (TvtScrollBox(P).Parent is TTabSheet) AND
        SameText(TTabSheet(TvtScrollBox(P).Parent).Name, 'tabLastYear') then
        exit
      else
        break;
    End;
    P := P.Parent;
  End;
  // 20160314 Igor <<<

  RetNo := GetCurrentRetNo;

  // MyEditBox:=MyChild.ActiveControl as TVtEdit; //20160310 Igor
  // MyEditBox:=Sender as TVtEdit;

  FieldId := GetFieldId(MyEditBox.Name);

  if (MyEditBox.vtDataSource = vtLinked)
  or (MyEditBox.vtDataSource = vtCalc)  //20231209

   then
  begin
    FName := GetLinkedForm(FieldId, TargetLinkedField);
    If FName > '' then
    begin
      OpenForm(RetNo, GetFormNo(FName), TargetLinkedField);
      exit;
    end;
    // Exit;
  end;

  if MyEditBox.vtDataSource = vtPopupList then // pick boxes
  begin
    {
      //testing.... vtPopData.vtPopValues.Strings
      for i:=0 to MyEditBox.vtPopData.vtPopValues.count - 1 do
      begin
      showmessage(MyEditBox.vtPopData.vtPopValues.Strings[i]);
      end;
      //end testing.... vtPopData.vtPopValues.Strings
    }

    If AskingForSICCode(FormName, FieldId) then
      GetSICCode(FieldId)
    else
      GetValueFromList(MyEditBox, FieldId);
    // GetValueFromPopUp(MyScrollBox,MyEditBox,FormName,FieldId);
    If SelectedString > '' then
    begin
      If IsReturnLocked(RetNo) = false then
      Begin
        MyEditBox.Text := SelectedString;
        SaveEditBoxText(FieldId, MyEditBox.Text);
        UpdateAfterSave; // 20160805 Igor
        P := self.Parent;
        while assigned(P) AND not(P is TForm) do
          P := P.Parent;
        if assigned(P) then
          PostMessage(P.Handle, WM_NEXTDLGCTL, 0, 0)
        else
          PostMessage(self.Handle, WM_NEXTDLGCTL, 0, 0)
      end
      Else
        ShowTimedMsg('Changes not allowed. Return is locked', 2000); // 20230219
      exit;
    end;

    // begin MyEditBox.Text := SelectedString;DataChanged:=True;end;
  End;

  /// ////////////////////////////////////////////
  // //showmessage(sender.classname);
  // //if not(Sender is TvtEdit) then    exit;
  // //MyEditBox:=Sender as TVtEdit;
  //
  // FieldId:=MyEditBox.FieldId; // GetFieldId(MyEditBox.Name);
  //
  // {Try linked form first}
  // If LeftStr(FormName,5) = 'FPENS' then
  // begin
  // OpenForm(RetNo,'EFMEMO',0);
  // exit;
  // end;
  //
  // if MyEditBox.vtDataSource = vtLinked then
  // begin
  // FName :=GetLinkedForm(FieldId,TargetLinkedField);
  //
  // If FName > '' then
  // OpenForm(RetNo,Fname,TargetLinkedField);
  // Exit;
  // end;
  //
  // if MyEditBox.vtDataSource = vtPopupList then   //pick boxes
  // begin
  // If AskingForSicCode(FormName,FieldId) then
  // GetSicCode(FieldId)
  // else
  // GetValueFromList(MyEditBox,FieldId);
  // //GetValueFromPopUp(MyScrollBox,MyEditBox,FormName,FieldId);
  // If SelectedString >'' then
  // begin
  // If IsReturnLocked(RetNo) = False then
  // Begin
  // MyEditBox.Text := SelectedString;
  // SaveEditBoxText(FieldId,MyEditBox.Text);
  // //20160121 Igor
  // P := Self.Parent;
  // while Assigned(P) AND not(P is TForm) do
  // P := P.Parent;
  // if assigned(P) then
  // PostMessage(P.Handle, WM_NEXTDLGCTL, 0, 0)
  // else
  // PostMessage(Self.Handle, WM_NEXTDLGCTL, 0, 0)
  // end
  // Else
  // ShowTimedMsg('Changes not allowed. Return is locked',1500);
  // Exit;
  // end;
  //
  // // begin MyEditBox.Text := SelectedString;DataChanged:=True;end;
  // End;
End;

Procedure TFormT1_2026.DataChangeRtn; // (FormName:String);
begin
  If ShowUnconvertedLastYear(RetNo) then
  begin
    exit; // ?
  end;
  ret[RetNo].Changed := true;
  // Ret[RetNo].Saved := False;
  { save instance data }
  T1_2026.Calc(RetNo, FormName);  //20240715 Igor
  If ExtractNonInstFormName(FormName) = 'ACBFRM' then
    T1_2026.Calc(RetNo, FormName); // twice!! //20160907 Igor //20240715 Igor
  T1_2026Calc.CalcAffectedBy(RetNo, FormName);
  If IsFormMultipage(FormName) then
    T1_2026Calc.CalcMultiPageForm(RetNo, FormName); //20240715 Igor
  If IsFormMultiInst(FormName) then
    SumSlips(RetNo, FormName);
  CalcAll(RetNo);
  Calc(RetNo, 'FORINC');
  If Vl(FetchELm(RetNo, 'FORINC', 109)) > 0 then
  begin
    UpdateAllDataIndicators(RetNo);
    CalcAll(RetNo);
  end;
  ret[RetNo].CalcStatus := true;
  // more afterwards, in common code
  // CountDiagnostics(RetNo); //for proper color
end;

Function FormatAmount(s: string): string;
var
  SignPart: string; // [1];
  IntegerPart: string; // [15];
  DecimalPart: string; // [2];
  { SignPart, IntegerPart, DecimalPart : string; //[20]; }
begin
  s := LTrim(s);
  IntegerPart := ExtractIntegerPart(s);
  DecimalPart := ExtractDecimalPart(s);
  If Length(DecimalPart) = 0 then
    DecimalPart := '00'
  else if Length(DecimalPart) = 1 then
    DecimalPart := DecimalPart + '0'
  else
    DecimalPart := Copy(DecimalPart, 1, 2);
  Result := InsertCommas(IntegerPart) + '  ' + DecimalPart;
end;

Function SubstituteLastYearForm(FName: String): String;
Var
  Inst: Integer;
  NewInst: Integer;
Begin
  Result := GetRenamedFName(FName);
  if Result = '' then
    Result := FName;
end;

Function GetReturnCaption(RetNo: Integer): String;
Var
  YrPrefix, Capt, Sin, FirstName, LastName: String;
begin
  // 20110221
  If ret[RetNo].IsLastYearReturn = false then
  begin
    Sin := GetSinNo(RetNo);
    FirstName := GetFirstName(RetNo);
    LastName := GetLastName(RetNo);
    YrPrefix := '';
  end
  Else // last yearreturn
  begin
    YrPrefix := GetLastYearTaxYear; // IntToStr(MyAppYearInt-1)
    Sin := ret[RetNo].LastYearSin;
    FirstName := ret[RetNo].LastYearFirstName;
    LastName := ret[RetNo].LastYearLastName;
    // GetLastYearSinFirstLastName(RetNo,Sin,FirstName,LastName);
  end;
  Capt := FirstName + ' ' + LastName + ' ' + ReformatSin(Sin);
  If FirstName + LastName = '' then
    Capt := PaddR(PaddZero(IntToStr(RetNo), 2), 2) + ' ' + YrPrefix +
      'Un-named';

  Result := { PaddR(PaddZero(IntToStr(RetNo),2),2)+' '+ } YrPrefix + ' ' + Capt;
end;

Procedure TFormT1_2026.ChangeProperties(MyEditBox: TvtEdit; Elm: Integer);
begin
  // NO GOOD  if (MyEditBox.vtInputType = vtSin) and (HideSin(RetNo)=True) then  MyEditBox.Text:=GetHiddenSin(RetNo);   //20200430
  If FormName = 'DEPEND' then
  begin
    If UpperCase(FetchElmFNo(RetNo, FormNo, 38)) <> 'Y' then
    begin
      If (Elm = 1) or (Elm = 2) or (Elm = 3) or (Elm = 4) or (Elm = 53) or
        (Elm = 8) or (Elm = 9) then
        MyEditBox.vtDataSource := vtCalc;
    end
    else
    begin
      If (Elm = 1) or (Elm = 2) or (Elm = 3) or (Elm = 4) or (Elm = 53) or
        (Elm = 8) or (Elm = 9) then
        MyEditBox.vtDataSource := vtUser;
    end;
  end

  else If FormName = 'OPTIMIZE' then
  begin
    If Elm = 55 then
    begin
      If FetchElmFNo(RetNo, FormNo, 14) > '' then
      Begin
        MyEditBox.color := GetRetColor(RetNo);
        MyEditBox.Font.color := clRed;
        MyEditBox.Font.Style := [fsBold, fsItalic];
        MyEditBox.visible := true;
      end
      Else
        MyEditBox.visible := false;
    end;
  end

  else If ExtractNonInstFormName(FormName) = 'ACBFRM' then // 20160907 Igor
  begin
    If IsInRange(Elm, 17, 422, 9) then { Unit }
    begin
      If ((UpperCase(FetchElmFNo(RetNo, FormNo, Elm - 1)) = 'ROC') or
        (UpperCase(FetchElmFNo(RetNo, FormNo, Elm - 1)) = 'COST ADJUSTMENT'))
      then
      begin
        MyEditBox.vtDataSource := vtCalc;
        MyEditBox.Font.color := clBlack;
        exit;
      end
      else
      begin
        MyEditBox.vtDataSource := vtUser;
        MyEditBox.Font.color := clBlue;
        exit;
      end;
    end;

    If IsInRange(Elm, 18, 423, 9) then { unit cost }
    begin
      If ((UpperCase(FetchElmFNo(RetNo, FormNo, Elm - 2)) = 'ROC') or
        (UpperCase(FetchElmFNo(RetNo, FormNo, Elm - 2)) = 'COST ADJUSTMENT'))
      then
      begin
        MyEditBox.vtDataSource := vtCalc;
        MyEditBox.Font.color := clBlack;
        exit;
      end
      else
        MyEditBox.vtDataSource := vtUser;
      MyEditBox.Font.color := clBlue;
      exit;
    end;

    If IsInRange(Elm, 21, 426, 9) then { Adjusted cost allowed only in ROC }
    begin
      If ((UpperCase(FetchElmFNo(RetNo, FormNo, Elm - 5)) = 'ROC') or
        (UpperCase(FetchElmFNo(RetNo, FormNo, Elm - 5)) = 'COST ADJUSTMENT'))
      // or (UpperCase(FetchElmFNo(RetNo,FNo,Elm-5))='BUY'))  //???
      then
      begin
        MyEditBox.vtDataSource := vtUser;
        MyEditBox.Font.color := clBlue;
        exit;
      end
      else
      begin
        MyEditBox.vtDataSource := vtCalc;
        MyEditBox.Font.color := clBlack;
        exit;
      end;
    end;

    If IsInRange(Elm, 22, 427, 9) then // selling expense
    begin
      If UpperCase(FetchElmFNo(RetNo, FormNo, Elm - 6)) = 'SELL' then
      begin
        MyEditBox.vtDataSource := vtUser;
        MyEditBox.Font.color := clBlue;
        exit;
      end
      else
      begin
        MyEditBox.vtDataSource := vtCalc;
        MyEditBox.Font.color := clBlack;
        exit;
      end;
    end;
  end;

  inherited;
end;

Procedure TFormT1_2026.ShowRichData(ARichEdit: TRichEdit; Fld: Integer);
begin
  If IsFormAClientLetter(FormName) AND (ARichEdit.Parent <> nil) then
  // 20160223 Igor
  begin
    LetterName := GetLetterFileName(RetNo, FormName);
    If FileExists(LetterName) then
    begin
      GetInterpetedRichEdit(RetNo, LetterName, ARichEdit);
      exit;
    end;
  end; // CLetter
  inherited;
end;

procedure TMyChildT1_2026.SpeedButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowMessage('button clicked');
end;

procedure TMyChildT1_2026.SectionBtnClick(Sender: TObject);
Var
  k: Integer;
  SectionBtn: TSpeedButton absolute Sender;
  SelectedString: string;
begin
  If ret[RetNo].IsLastYearReturn then
  begin
    SectionBtn.visible := false; // 20110227
    exit;
  end;

  SelectedString := GoToSection('INFO');
  if SelectedString = '' then
    exit; // all done

  // special handling of INFO form
  // if FName = 'INFO' then begin
  k := GetClosestEditBoxOFINFO(LeftStr(SelectedString, 60)); // based on caption
  OpenForm(RetNo, 'INFO', k);
end;

Function InDateYYYYMMDDonly(Value: string; MxYear: Integer): Boolean;
begin
  Result := InDateYMDonly(Value, 1888, MxYear, '-');
end;


//20251220copied from T2-2026 Remved prefix of TformT2_20276  ???
//jz 20250108
//Function TFormT2_2027.PrivacyAgreementAccepted(ForEfileFormName:string):boolean;
Function PrivacyAgreementAccepted(ForEfileFormName:string):boolean;
var
  i:integer;
  //PAdlgBox: TPrivacyAgreementT2_2027; //20251220
  doNotShowPrivacyAgreement: TStringList;
begin
 result := true;
 EXIT;
end;
(*
    result := true;

    if FileExists(PrivacyAgreementDoNotShowPathandFileName) then
    begin
      doNotShowPrivacyAgreement:= TStringList.Create;
      doNotShowPrivacyAgreement.LoadFromFile(PrivacyAgreementDoNotShowPathandFileName);
      for i:= 0 to doNotShowPrivacyAgreement.Count -1 do
      begin
        if doNotShowPrivacyAgreement[i] = ForEfileFormName then
          exit;
      end;
      doNotShowPrivacyAgreement.Free;
    end; //if not FileExists

    PAdlgBox := TPrivacyAgreementT2_2027.Create(Self);
    try
      //from example: Populate dialog//dlg.eFont.Text := lblCaption.Font.Name;//dlg.eSize.Text := lblCaption.Font.Size.ToString;//dlg.cbBold.Checked := fsBold in lblCaption.Font.Style;    //dlg.cbItalic.Checked := fsItalic in lblCaption.Font.Style;
      //dlg.headerPanel.Caption := 'T106' + dlg.headerPanel.Caption
      PAdlgBox.formHeaderLbl.Caption := ForEfileFormName;
      if PAdlgBox.ShowModal <> mrOk then
      begin
          ////from example: Apply settings from dialog//lblCaption.Font.Name := dlg.eFont.Text;//lblCaption.Font.Size := StrToInt(dlg.eSize.Text);//if dlg.cbBold.Checked then//lblCaption.Font.Style := lblCaption.Font.Style + [fsBold]//else//lblCaption.Font.Style := lblCaption.Font.Style - [fsBold];//if dlg.cbItalic.Checked then//lblCaption.Font.Style := lblCaption.Font.Style + [fsItalic]//else//lblCaption.Font.Style := lblCaption.Font.Style - [fsItalic];
          result := false;
      end;
    finally
      PAdlgBox.Free;
    end;

 end;
 *)


end.
