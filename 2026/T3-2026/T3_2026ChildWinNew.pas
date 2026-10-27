unit T3_2026ChildWinNew;
(* see vtChild for documentation
*)

interface

uses SysUtils, WinTypes, WinProcs, Classes, Graphics, Forms, Controls, TabNotBk,
  StdCtrls, ExtCtrls, Tabs, Menus, Grids, Dialogs, ColorGrd, ClipBrd, Gauges,
  Mask,
  DBCtrls, Printers, Messages, shellApi, Buttons, ComCtrls, vtEditBox, vtLabel,
  vtShape,
  vtChild, vtForm, T3_2026HeaderFrame,
  T3_2026MonitorFrame, // wwriched,
  TypInfo,

  rxRichEd; // 20160819 Igor (Must be last)

const
  functionalCurrency_N: array[0..4] of string = ('01(USD = US Dollar)', '02(GBP = GB Pound Sterling)', '03(AUD = AU Dollar)', '04(EUR = Euro)', '05(JPY = Yen)'); //20260817 Alex

type
  TFormT3_2026 = class(TvtScrollBox)
  private
    function PopulatePickList(FieldId: Integer { ;
        SomeList: TStrings } ): String;
    function CleanUpPickedListValue(FieldId: Integer;
      SelectedString: String): string;
    procedure GetSICCode(FieldId: Integer);
  protected // required overrides
    procedure DataChangeRtn; override;
    procedure FormatDollar(MyEditBox: TvtEdit; str: string); override;
    procedure FormatEditBoxText(MyEditBox: TvtEdit; str: string); override;
    function GetLinkedForm(FieldId: Integer; var TargetLinkedField: Integer)
      : String; override;
    Procedure PopulateFormWithData; override;
    Procedure ShowRichData(ARichEdit: TRichEdit; Fld: Integer); override;
    procedure ShowOther(cmp: TComponent); override;
    Procedure ShowFieldData(MyEditBox: TvtEdit); override;
    Function GetValueFromList(MyEditBox: TvtEdit; FieldId: Integer)
      : String; override;
    // Procedure ShowInterpretedRichData(ARichEdit:TwwDbRichEdit;FName:String;FNo:Integer);
    // Procedure ShowFormData(FName:String;FNo:Integer); override;
    // Function GetSignatureFilePath(RetNo:Integer):String;//20200320
    function ValidateField(FieldId: Integer; OldValue: string; var Value: string) //20260704 Alex
      : boolean; override;
    function PrivacyAgreementAccepted(ForEfileFormName: string): Boolean; //20260817 Alex
  protected // handlers
    procedure FormButtonClick(Sender: TObject); override;
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); override;
    procedure OnVtEditDblClick(MyEditBox: TvtEdit); override;
    procedure AfterOpenForm(ADestination: TvtDestination = vtdDisplay);
      override; // 20160518 Igor
  end;

  TMyChildT3_2026 = class(TMyChild)
  public
    procedure FormPaint(Sender: TObject);

    procedure CloseActiveForm(Sender: TObject); override;
  private
    FMyFormHeaderFrame: THeaderFrameT3_2026;
    FMyMonitorFrame: TMonitorFrameT3_2026;
    Procedure ChildMsgHandler(var Msg: TMsg; Var Handled: boolean);
  protected
    function GetHeaderFrame: TFrame; override; // 20160227 Igor
    function GetMonitorFrame: TFrame; override; // 20160227 Igor
  public // protected  //required overrides
    procedure AddPropertiesAndEvents; override;
  public // overrides
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: boolean);
    Procedure Keys(Var Key: Word; Shift: TShiftState); override;

    procedure UpdateChildTaxPanel; override;
    Procedure UpdateFormHeaderFrame; override;
  public
    constructor CreateNew(AOwner: TComponent; RNo: Integer); override;
    property MyMonitorFrame: TMonitorFrameT3_2026 read FMyMonitorFrame;
    property MyFormHeaderFrame: THeaderFrameT3_2026 read FMyFormHeaderFrame;
  end;

  // known to all
Function InDateYYYYMMDDonly(Value: string; MxYear: Integer): boolean;
// Function InT5013DateYYYYMMDDonly(Value:string;MxYear:integer):Boolean;

Function BeforeOpenForm(RetNo: Integer; var FName: string;
  var FNo: Integer): string;
Function GetDFMFileName(FName: String): String;
Function GetLastYearDFMFileName(FName: String): String; // 20160321 Igor
Function GetReturnCaption(RetNo: Integer): String;
Function SubstituteLastYearForm(FName: String): String; // 20160629 Igor

var // force compiler errors
  MyChildT3_2026: boolean; // TMyChild;
  RetNo: boolean;

implementation

{ --- $R *.DFM }

uses
  vtCommon, vtDialogs, vtMain,
  T3_2026, T3_2026Common, T3_2026Common2,
  T3_2026TrimStr, T3_2026Calc,
  // T3_2026PopList,T3_2026PopComboList,
  T3_2026SaveAs,
  T3_2026Declare, T3_2026SearchList,
  T3_2026RichForm, T3_2026CntErr, T3_2026main, T3_2026Print, T3_2026SIC,
  T3_2026T1135Efile, // 20181126 Igor
  T3_2026LargeBenoList, // 20240129 Igor
  vtTrimStr, vtShared, vtMulti,
  vtDynData, T3_2026EfileT1134, T3_2026T106Efile, T3_2026PrivacyAgreement, //20260817 Alex
  T3_2026Efile  //jz 20240405 add specialreturns efile button
  ;

// keep (here, local)
procedure ShowMessage(Msg: string);
begin
  UserMsg(Msg);
end;

procedure TFormT3_2026.AfterOpenForm(ADestination: TvtDestination);
// 20160518 Igor
var
  i: Integer;
begin
  inherited AfterOpenForm(ADestination);
  if ADestination = vtdPrint then
    for i := 0 to self.componentCount - 1 do
      ShowOther(self.components[i]);
end;

Procedure TMyChildT3_2026.ChildMsgHandler(var Msg: TMsg; Var Handled: boolean);
begin
  if (Msg.Message = WM_SysKeyDown) and (Msg.WParam = VK_F4) then
  begin
    Handled := True;
    exit;
  end;

  if (Msg.Message = WM_SysKeyDown) and (Msg.WParam = VK_F6) then
  begin
    Handled := True;
    exit;
  end;
end;

Function InDateYYYYMMDDonly(Value: string; MxYear: Integer): boolean;
begin
  // Result := InDateYMDonly(Value,1880,MxYear,'/'); //20160310 Igor
  Result := InDateYMDonly(Value, 1880, MxYear, '-'); // 20160310 Igor
end;
{$IFDEF old}

Function InT5013DateYYYYMMDDonly(Value: string; MxYear: Integer): boolean;
begin
  Result := InDateYMDonly(Value, 1880, MxYear, '/');
end;
{$ELSE}

// Function InT5013DateYYYYMMDDonly(Value:string;MxYear:String;RetNo: integer; FormName: string;FieldId: integer):Boolean;
Function InT5013DateYYYYMMDDonly(Value: string; MxYear: Integer; RetNo: Integer;
  FormName: string; FieldId: Integer): boolean;
var
  i: Integer;
  s: String;
begin
  Result := True;
  s := Value;
  If s = '' then
    exit;

  If (s[5] <> '/') or (s[8] <> '/') or (not InNumRange(RightStr(s, 2), 01, 31))
    or (not InNumRange(MidStr(s, 6, 2), 01, 12))
  // or (not InNumRange(LeftStr(s,4),1880,StrToInt(MxYear)))
    or (not InNumRange(LeftStr(s, 4), 1880, MxYear))
  // or (Vl(LeftStr(s,4)) > Vl(MxYear)) then
    or (Vl(LeftStr(s, 4)) > MxYear) then
  begin
    ShowMessage('Invalid Date or out of range');
    Result := False;
  end;
end;
{$ENDIF}

procedure TMyChildT3_2026.AddPropertiesAndEvents;
begin
  inherited;
  VertScrollBar.Tracking := True;
  HorzScrollBar.Tracking := True;
  VertScrollBar.Position := 0;
  KeyPreview := True;
  OnKeyDown := FormKeyDown;
  OnKeyPress := FormKeyPress;
  // install for use by vtScrollBox
  PopupMenu := MainFormT3.FormPopup;
  OnContextPopup := FormContextPopup;
end;

procedure TFormT3_2026.ShowOther(cmp: TComponent); // 20230312
var
  MyLabel: TvtLabel absolute cmp;
  AnImage: TImage;
  s: String;
begin
  {
    if cmp is TvtLabel then
    begin
    if MyLabel.vtCraCertifCode then
    MyLabel.Caption := 'Version '+RsiVersion+ '  '+RSIApprovalCode; //20161217 //RSIApprovalCode;
    end;
  }
  if cmp is TImage then // 20120325
  begin
    AnImage := cmp as TImage;
    If (UpperCase(AnImage.Name) = 'E_SIGNATUREHOLDER') then // 20200326
    Begin
      if UpperCase(FetchElm(RetNo, 'T183TRUST', 38)) <> 'Y' then
        AnImage.Picture := Nil
      Else
      Begin
        s := GetSignatureFilePath(RetNo);
        If s > '' then
          AnImage.Picture.LoadFromFile(s);
      End;
    End;
  end;

end;

// 20231223
Function BeforeOpenForm(RetNo: Integer; var FName: string;
  var FNo: Integer): string;
// Function OpenForm(RetNo: Integer;FNo: integer;Elm:Integer): boolean;
Var
  DfmFileName: String absolute Result;
begin

 if IsEnterPriseForm(Fname) =True then //special Ekections) then
 Begin
    ShowMessage('This form is available only on the Enterprise version of the program');
    If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit;
 End;

 (*
   //20250104
 if GetFormType(Fname)='SP' then //special types of t3 returns
 Begin
  if (LicenseLevel=LLEnterprise) then
  //ok
  Else if not inJZtestmode then
  Begin
   Showmessage('Form ' + Fname +' belongs to the T3 Special Returns and it is available only on the Enterprise version of the program');
   If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit;  //20250120
  // Exit;
  end;
 End;

*)
  Result := '';
  If (RetNo < 1)
{$IFDEF ReturnsLimit}
    or (RetNo > ReturnsLimit)
{$ELSE}
{$ENDIF}
  then
    exit;
  If FNo = 0 then
  begin
    ShowMessage('Form No ' + IntToStr(FNo) + ' not found');
    exit;
  end;

  if FName = '' then
    FName := AppT3_2026.FirstForm;
  // 20160629 Igor >>>
  if FNo = 0 then
  begin
    If Ret[RetNo].IsLastYearReturn = False then
      FNo := GetFormNo(FName)
    Else
      FNo := GetLastYearFormNo(FName);
  end;
  If ShowUnconvertedLastYear(RetNo) = False then
    DfmFileName := GetDFMFileName(FName)
  else
    DfmFileName := GetLastYearDFMFileName(FName);

  // 20160629 Igor <<<
  If FileExists(DfmFileName) = False then
  begin
    ShowMessage('Form ' + FName + ' not found');
    Result := '';
    exit;
  End;
  // Result := True;
  If Ret[RetNo].Frm[FNo].count = 0 then
    InitFormData(RetNo, FNo); // here?
  // =================
  (*
    //20240326 BELOW DOES NOT WORK  else it does not show latest data on form
    if Uppercase(GetFormType(Fname))='MJ' then //20240326
    Begin
    CalcFullT3(RetNo);
    MainformT3.RecalcBtnClick(Application); //20240326
    //If FNo>0 then ShowFormData(FName,FNo);//MyChild.ShowFormData(FName,FNo);
    end;
  *)
end;

procedure TFormT3_2026.PopulateFormWithData;
// Procedure TMyChildT3_2026.ShowFormData(FName:String;FNo:Integer);
begin
  If IsFormAClientLetter(FormName) then
    Color := clWhite;
  inherited;
end;

procedure TFormT3_2026.FormButtonClick(Sender: TObject);
Var
  Nm: String;
  ARichEdit: TRichEdit;
  FirstFieldId: Integer;
  FName: String;
  i: Integer;

  j,confirmationElm:integer;  //jz 20240405 add specialreturns efile button
begin
  Nm := UpperCase((Sender as TbitBtn).Name); // button name

  If FormName = 'T3' then
  begin
    If Nm = 'T5013INCBTN' then
      OpenForm(GetCurrentRetNo, GetFormNo('T5013INC#1'), 1);
    If Nm = 'T3INCOMEBTN' then
      OpenForm(GetCurrentRetNo, GetFormNo('T3INCOME#1'), 1);
    If Nm = 'T3LOSS_1BTN' then
      OpenForm(GetCurrentRetNo, GetFormNo('T3LOSS'), 0);
    If Nm = 'T3LOSS_2BTN' then
      OpenForm(GetCurrentRetNo, GetFormNo('T3LOSS'), 201); // j=201? //20131225
    If Nm = 'S5BTN' then
      OpenForm(GetCurrentRetNo, GetFormNo('S5'), 0);
    If Nm = 'T3OTHDEDBTN' then
      OpenForm(GetCurrentRetNo, GetFormNo('T3OTHDED'), 0);
    If Nm = 'EFMEMOBTN' then
      OpenForm(GetCurrentRetNo, GetFormNo('EFMEMO'), 0); // 20220322
    If Nm = 'ACCOUNTAPPLICATIONBTN' then
      ConnectToWeb
        ('https://www.canada.ca/en/revenue-agency/services/tax/trust-administrators/t3-return/application-trust-account-number-how-apply.html');
    // 20150105  //populateTestCasesJSON(1,'FName', 1);

    // 20240203
    If Nm = 'RETURNTYPEFORMBTN' then
    Begin
      If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then
        exit;
      FName := LeftStr(FetchElm(RetNo, 'T3', 155), 8);
      FName := UpperCase(Rtrim(FName));
      OpenForm(GetCurrentRetNo, GetFormNo(FName), 1);
    end;

    exit;
  end;

  // 20180210
  If FormName = 'T3DON' then
  begin
    If Nm = 'S11ABTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('S11A'), 0);
      exit;
    end;
  end;

  // 20220117 Igor >>>
  If FormName = 'T183TRUST' then
  begin
    If Nm = 'MKDCNBTN' then
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
        StoreElm(RetNo, GetFormNo('T183TRUST'), 21, '');
        Calc(RetNo, 'T183TRUST');
        OpenForm(RetNo, GetFormNo('T183TRUST'), 0);
      end;
    End;

    // jz //20230217
    If Nm = 'T183TRUSTIBTN' then
      ShowPdf(AppDir, 'T183trusti.pdf');

  end; // T183TRUST
  // 20220117 Igor <<<

  If FormName = 'TESTFRM' then
  begin
{$IFDEF dynamic}
    If Nm = 'ADDROWBTN' then
    begin
      MyScrollbox := GetScrollbox(FormName);
      FirstFieldId := 10001;
      PushComponentsUpOrDown(MyScrollbox, GetYPosOfFirstDynamicRow(MyScrollbox,
        FormName, FirstFieldId), 14);
    end;
    If Nm = 'REMOVEROWBTN' then
    begin
      MyScrollbox := GetScrollbox(FormName);
      PushComponentsUpOrDown(MyScrollbox, GetYPosOfFirstDynamicRow(MyScrollbox,
        FormName, 10001), -14);
    end;
{$ELSE}
{$ENDIF}
  end;





 //jz 20240405 add specialreturns efile button
 If (FormName='T1061') or (FormName='T2000') or (FormName='T3ATH') or
    (FormName='T3D')   or (FormName='T3GR')  or (FormName='T3M')   or
    (FormName='T3P')   or (FormName='T3PRP') or (FormName='T3RCA') or
    (FormName='T3RI')  or (FormName='T3S')
 then
 begin
  If (Nm='EFILEBTN') then
  begin

    if      FormName = 'T3'     then confirmationElm := 0
    else if FormName = 'T3M'    then confirmationElm := 0
    else if FormName = 'T3RCA'  then confirmationElm := 0
    else if FormName = 'T3ATH'  then confirmationElm := 0
    else if FormName = 'T3D'    then confirmationElm := 0
    else if FormName = 'T3P'    then confirmationElm := 0
    else if FormName = 'T3PRP'  then confirmationElm := 0
    else if FormName = 'T3GR'   then confirmationElm := 0
    else if FormName = 'T3RI'   then confirmationElm := 0
    else if FormName = 'T3S'    then confirmationElm := 0
    else if FormName = 'T1061'  then confirmationElm := 0;

    //below was taken / adjusted from ExecuteForm(TEfileT3_2026); in vtcommon then added a custom create function to add variable
    with TEfileT3_2026.create(Application,FormName) do //confirmationElm
    begin
      Screen.cursor := crDefault;
      for J := 0 to ComponentCount - 1 do
      Begin
        if Components[j] is TPanel then
          (Components[j] as TPanel).ParentBackground := False;
      End;
      ShowModal;
      Free;
    end;

    end;


 end;



















  If FormName = 'T1135' then // 20140227
  begin
    // If UpperCase(InputBox('Expected release: Feb 20', 'PSW', '')) <> 'N/A' then exit;  //20220328
    If (Nm = 'T1135EFILEBTN') Or (Nm = 'T1135EFILEBTN2') // 20200507
    then // 20140101
    begin
      // 20200207
      if ReadyForT1135Efile(RetNo) = False then
      Begin
        ShowMessage('Please select Simple or Detail option');
        exit;
      End;

      // If IsCraOpenForEfile=False then begin ShowCraIsClosed;exit;end;  //20160205 //20160216 Igor
      Application.CreateForm(TT1135EfileT3_2026, T1135Efile); // 20150709
      T1135Efile.ShowModal;
      T1135Efile.Free;
      OpenForm(RetNo, GetFormNo('T1135'), 0);
    end;

    {
      If Nm='T1135FILLBTN' then
      begin
      ConnectToWeb('http://www.cra-arc.gc.ca/E/pbg/tf/t1135/t1135-fill-14e.pdf');  //20150105
      end;
    }
    If Nm = 'T1135I' then // 20150201
    begin
      ShowPdf(AppDir, 't1135i.pdf'); // 20150105
    end;
  end;

  (*
    //20150105
    If LeftStr(FormName,6)='T1135' then
    begin
    If Nm='T1135I' then  //20150201
    begin
    ShowPdf(AppDir,'t1135i.pdf');  //20150105
    end;
    //20180422
    If Nm='T1135EFILEBTN' then
    begin
    // 20181126 Igor >>>
    //If IsCraOpenForEfile=False then begin ShowCraIsClosed;exit;end;
    Application.CreateForm(TT1135EfileT3_2026,T1135Efile);
    T1135Efile.ShowModal;
    T1135Efile.Free;
    OpenForm(RetNo,GetFormNo('T1135'),0);
    // 20181126 Igor <<<
    end;
    end;
  *)

  If (LeftStr(FormName, 6) = 'T2125#') or (LeftStr(FormName, 6) = 'T2121#') or
    (LeftStr(FormName, 6) = 'T2042#') then
  begin
    If Nm = 'AUTOSBTN' then
      OpenForm(RetNo, GetFormNo('AUTOS#1'), 0);
  end;

  If (LeftStr(FormName, 6) = 'T2125#') or (LeftStr(FormName, 6) = 'T2121#') or
    (LeftStr(FormName, 6) = 'T2042#') or (LeftStr(FormName, 6) = 'T1175#') or
    (LeftStr(FormName, 7) = 'T1175H#') or (LeftStr(FormName, 5) = 'T776#') then
  begin
    If Nm = 'AUTOSBTN' then
      OpenForm(RetNo, GetFormNo('AUTOS#1'), 0);
    If Nm = 'ASSETSBTN' then
      OpenForm(RetNo, GetFormNo('ASSETSB#1'), 0);
  end;

  {
    If FormName='S11' then
    begin
    If Nm='T3DONBTN' then
    begin
    OpenForm(GetCurrentRetNo,GetFormNo('T3DON'),0);
    Exit;
    end;
    end;
  }
  If LeftStr(FormName, 7) = 'INVSTM#' then
  begin
    If Nm = 'FINVSTMBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('FINVSTM'), 1);
      exit;
    end;
    If Nm = 'T3INCOMEBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T3INCOME#1'), 1);
      exit;
    end;
    If Nm = 'T5INCOMEBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T5INCOME#1'), 1);
      exit;
    end;
    If Nm = 'T5013INCBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T5013INC#1'), 1);
      exit;
    end;
  end;

  If LeftStr(FormName, 7) = 'FINVSTM' then
  begin
    If Nm = 'T3INCOMEBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T3INCOME#1'), 1);
      exit;
    end;

    If Nm = 'T5INCOMEBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T5INCOME#1'), 1);
      exit;
    end;

    If Nm = 'T5013INCBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T5013INC#1'), 1);
      exit;
    end;
  end;

  If LeftStr(FormName, 7) = 'T3SUPL#' then
  begin
    If Nm = 'AVLBLEBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('AVLBLE'), 1);
      exit;
    end;
  end;

  // 20180217
  If FormName = 'T3SUM' then
  begin
    If Nm = 'T3SUM2BTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T3SUM2'), 1);
      exit;
    end;
  end;

  If FormName = 'S9' then
  begin
    If Nm = 'BENEFICIARIESBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T3SUPL#1'), 1);
      exit;
    end;
  end;

  If FormName = 'T661' then
  begin
    If Nm = 'T661FBTN' then
    begin
      OpenForm(GetCurrentRetNo, GetFormNo('T661F#1'), 0);
      exit;
    end;
  end;

  If IsFormAClientLetter(FormName) then
  begin
    If Nm = 'LETTERDESIGNBTN' then
    begin
      MainFormT3.ClientLetter1Click(Sender);
      OpenForm(GetCurrentRetNo, GetFormNo(FormName), 1);
    end;
    If Nm = 'PRINTLETTERBTN' then
      MainFormT3.CurrentPage1Click(Sender);
  end;
  If FormName = 'COMPSUM' then
  begin
    If Nm = 'BUILDCOMPSUMBTN' then
    begin
      // MainForm.Builda5yearsummaryFromVisualTax1Click(Application);
      exit;
    end;
  end;

  If FormName = 'T661' then
  begin
    If Nm = 'S30BTN' then
    begin
      OpenForm(RetNo, GetFormNo('S30#1'), 0);
      exit;
    end;
  end;

  If FormName = 'T661' then
  begin
    If Nm = 'T661FBTN' then
    begin
      OpenForm(RetNo, GetFormNo('T661F#1'), 0);
      exit;
    end;
  end;

  // 20240319
  If (LeftStr(FormName, 4) = 'S15#') then
  begin
    If Nm = 'LARGEBENOBTN' then
    Begin
      // If UpperCase(InputBox('Input Box', 'PSW', '')) = 'LB' then  //20240320
      TLargeBenoListT3_2026.Execute;
    end;

    If Nm = 'T4013GUIDEBTN' then
      ConnectToWeb
        ('https://www.canada.ca/content/dam/cra-arc/formspubs/pub/t4013/t4013-23e.pdf');

    If (Nm = 'COPYS15FROMPREVIOUSBTN') then
    // and (LeftStr(FormName,5)>'S15#1') then
    begin
      for i := 1 to 4 do
      begin
        StoreElm(RetNo, GetFormNo(FormName), i, FetchElm(RetNo, 'S15#1', i));
      end;
      OpenForm(RetNo, GetFormNo(FormName), 0);
    end;
  end;
  // 20240129 Igor <<<

  //20260115 Igor >>>
  if ExtractNonInstFormName(FormName).Equals('T1134') then
  begin
    if Nm.Equals('T1134EFILEBTN') then
    begin
      if not FetchElm(RetNo, 'T1134', 26).IsEmpty  then
      Begin
        ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
        Exit;
      End;

      //ExecuteForm(TEfileT1134T3_2026); //20260115 Igor. TODO Nead add after efiling will be done
      Exit;
    end;
    if Nm.Equals('T1134FILLBTN') then
    begin
      ConnectToWeb('https://www.canada.ca/content/dam/cra-arc/migration/cra-arc/E/pbg/tf/t1134/t1134-fill-17e.pdf');
      Exit;
    end;
    if Nm.Equals('T1134IBTN') then
    begin
      ShowPdf(AppDir, 'T1134I.pdf');
      Exit;
    end;
    if Nm.Equals('FILLABLET1134BTN') then
    begin
      ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/forms-publications/forms/t1134.html');
      Exit;
    end;
    if Nm.Equals('T1134SLBTN') then
    begin
      OpenForm(RetNo, GetFormNo('T1134S#1'), 1);
      Exit;
    end;
  end;
  //20260115 Igor <<<
  //20260817 Alex >>>
  If (FormName = 'T106') or (leftStr(Formname, 7) = 'T106SL#') then
  begin
    if Nm = 'T106INSTRUCTIONSBTN' then ShowPdf(AppDir, 'T106SLIPI.pdf');
    if Nm = 'T106EFILEBTN' then
    begin
      if FetchElm(RetNo, 'T106', 64) > ''  then
      begin
        ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
        Exit;
      end;

      if not PrivacyAgreementAccepted(FormName) then Exit; //jz 20250108

      Application.CreateForm(TT106EfileT3_2026, T106Efile);
      T106Efile.ShowModal;
      T106Efile.Free;
      OpenForm(RetNo, GetFormNo('T106'), 0);
    end;

    if Nm = 'T106SLBTN' then
    begin
      OpenForm(RetNo, GetFormNo('T106SL#1'), 1);
      Exit;
    end;

    if Nm = 'T106ISTRUCTIONSBTN' then ShowPdf(AppDir, 'T106I.pdf');
  end;
  //20260817 Alex <<<
end;

Function GetDFMFileName(FName: String): String;
Var
  FormsDir: String;
begin
  FormsDir := GetDfmFormsDir;
  Result := FormsDir + '\' + 'u' + ExtractNonInstFormName(FName) + '.DFM';
end;

Function GetLastYearDFMFileName(FName: String): String; // 20160321 Igor
Var
  FormsDir: String;
begin
  Result := '';
  FormsDir := OptRec.Dir_PgmLastYr;
  if FormsDir = '' then
    exit;
  FName := ExtractNonInstFormName(FName);
  Result := FormsDir + '\' + 'u' + FName + '.DFM';
end;

Function TFormT3_2026.ValidateField(FieldId: Integer; OldValue: string; Var Value: string): boolean; //20260704 Alex

		  //20260302 Igor >>>
		  procedure ValidateDoubleCheckbox(aYesFieldIndex: Integer; aNoFieldIndex: Integer);
		  begin
		    if (FieldId = aYesFieldIndex) and (Value.Equals('X')) then
		      if FetchElm(RetNo, GetFormNo(FormName), aNoFieldIndex).Equals('X') then
		        StoreElm(RetNo, GetFormNo(FormName), aNoFieldIndex, '');
		
		    if (FieldId = aNoFieldIndex) and (Value.Equals('X')) then
		      if FetchElm(RetNo, GetFormNo(FormName), aYesFieldIndex).Equals('X') then
		        StoreElm(RetNo, GetFormNo(FormName), aYesFieldIndex, '');
		  end;
 		  //20260302 Igor <<<
Var
  i: Integer;
  SelectedString: string;
begin
  Result := True;
  If FormName = 'T3' then
  begin
    case FieldId of
      2:
        begin
          Result := ValidAccount(Value);
          If Result = False then
            ShowMessage('Invalid Account. Enter 8 digits');
          exit;
        end;

      14, 17, 20, 54, 42, 69: // 20161227  //42,69  //20190331
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;

      22, 52, 51:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;

      // 41: begin Result :=XOnly(Value);exit;end;
      56:
        begin
          Result := XOnly(Value);
          exit;
        end;
      169, 170: ValidateDoubleCheckbox(169, 170); //20260930 Alex
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
      129, 131:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1055' then // 20220318
  begin
    case FieldId of
      12, 19, 22:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 2);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'S15' then // 20240205
  begin
    case FieldId of
      18:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 2);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1255' then // 20220327
  begin
    case FieldId of
      5:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 2);
          exit;
        end;
    end; { case }
  end

  else if ExtractNonInstFormName(FormName) = 'T3INCOME' then
  begin
    case FieldId of
      5:
        begin
          Result := InValuesOnly('1,2,3', Value);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'ASSETSB' then
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

  // 20230208
  else if ExtractNonInstFormName(FormName) = 'EFMEMO' then // 20230208
  begin
    case FieldId of // 20230209
      50, 54, 55:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 10);
          exit;
        end;
    end; { case }
  end

  else if FormName = 'S5' then
  begin
    case FieldId of
      6:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 3);
          exit;
        end;
    end; { case }
  end

  else if FormName = 'T2047' then
  begin
    case FieldId of
      11, 12:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 10);
          exit;
        end;
    end; { Case }
  end

  else if LeftStr(FormName, 6) = 'T2121#' then
  begin
    case FieldId of
      657, 658, 659, 660, 661, 662:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 10);
          exit;
        end;
    end; { Case }
  end

  else if LeftStr(FormName, 6) = 'T2042#' then
  begin
    case FieldId of
      757, 758, 759, 760, 761, 762:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 10);
          exit;
        end;
    end; // case
  end

  { //did not work
    else if LeftStr(FormName,6) = 'T2042#' then //20220305
    begin
    case
    FieldId of 71: begin for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]);end;
    end; //case
    end
  }

  else if FormName = 'RC145' then
  begin
    case FieldId of
      17, 25, 33, 36:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 2);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'T2054' then
  begin
    case FieldId of
      15, 16:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 2);
          exit;
        end;
    end; { Case }
  end

  else if FormName = 'T2054' then
  begin
    case FieldId of
      122, 114:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 2);
          exit;
        end;
    end; { Case }
  end

  else if LeftStr(FormName, 6) = 'T1235#' then
  begin
    case FieldId of
      86 .. 99:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 20);
          exit;
        end;
      4, 16, 28, 40, 52, 64, 76:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { Case }
  end

  else if LeftStr(FormName, 6) = 'T1235#' then
  begin
    case FieldId of
      86 .. 99:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 20);
          exit;
        end;
      4, 16, 28, 40, 52, 64, 76:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { Case }
  end

  else if ExtractNonInstFormName(FormName) = 'T1044' then
  begin
    case FieldId of
      1, 2:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
    end; { Case }
  end
  //20260817 Alex >>>
  else if FormName = 'T106' then
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
  //20260817 Alex <<<
  //20260115 Igor >>>
  else if ExtractNonInstFormName(FormName) = 'T1134' then
  begin
    case FieldId of
      19, 20:
      begin
        AutoFormatDate(Value);
        Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
      end;
      147, 33, 34, 62, 63:
      begin
        AutoFormatDate(Value);
        Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
      end;
    end;
  end
  else if ExtractNonInstFormName(FormName) = 'T1134S' then
  begin
    case FieldId of
      62, 63:
      begin
        AutoFormatDate(Value);
        Result:= InDateYYYYMMDDonly(Value, AppYearInt + 2);
        exit;
      end;
    end;
  //20260302 Igor >>>
  end
  //20260115 Igor <<<
  else if ExtractNonInstFormName(FormName) = 'S130' then
  begin
    case FieldId of
      1, 2: ValidateDoubleCheckbox(1, 2);
      3, 4: ValidateDoubleCheckbox(3, 4);
      5, 6: ValidateDoubleCheckbox(5, 6);
      9, 13, 17, 21:
        begin
          AutoFormatDate(Value);
          Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      93, 99, 105, 111, 117, 123:
        begin
          if (Length(Value) > 0) then
          begin
            Result:= False;

            if Length(Value) < 15 then
            begin
              ShowMessage('Invalid Partnership account number. Format NNNNNNNNNRZNNNN.');
              Exit;
            end;

            Result:= (Value[10] = 'R') and ((Value[11] = 'Z'));

            if not Result then
              ShowMessage('Invalid Partnership account number in the table 6. Format NNNNNNNNNRZNNNN.');
          end;
        end;

    end;

  end
  //20260302 Igor <<<
  //20261006 Alex <<<
  else if LeftStr(FormName, 5) = 'T1099' then
  begin
    case FieldId of
      4:
        begin
          AutoFormatDate(Value);
          Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
          exit;
        end;
      8, 9: ValidateDoubleCheckbox(8, 9);
    end;
  end
  //20261006 Alex <<<
  ;
end;

constructor TMyChildT3_2026.CreateNew(AOwner: TComponent; RNo: Integer);
Var { MyPanel1,MyPanel2:TPanel; }
  MyBevel1: TBevel;
  j: Integer; // 20160519 Igor
begin
  inherited;
  FormClass := TFormT3_2026;
  Caption := GetReturnCaption(RetNo);
  Color := GetRetColor(RetNo); // $00AC7400; //GetRetColor(RetNo);
  Name := 'R' + IntToStr(RetNo);

  FMyFormHeaderFrame := THeaderFrameT3_2026.Create(self);
  with MyFormHeaderFrame do
  begin
    Name := 'P2';
    Parent := self; // MyPageControl;
    MyChild := self;
    Height := 25; // 30;
    Align := alTop;
    Color := $00AC7400; // GetRetColor(RetNo);  //$00AC7400;
    // 20160519 Igor >>>
    ParentBackGround := False;
    for j := 0 to componentCount - 1 do
    Begin
      if components[j] is TPanel then
        (components[j] as TPanel).ParentBackGround := False;
    End;
    // 20160519 Igor <<<

    // ReturnNameLbl.Caption := '[Un-Named return]';
  end;

  FMyMonitorFrame := TMonitorFrameT3_2026.Create(self);
  With MyMonitorFrame do
  begin
    Parent := self;
    Height := 23;
    Align := alBottom;
    // 20160519 Igor >>>
    ParentBackGround := False;
    for j := 0 to componentCount - 1 do
    Begin
      if components[j] is TPanel then
        (components[j] as TPanel).ParentBackGround := False;
    End;
    // 20160519 Igor <<<
  end;
  // UpdateChildTaxPanel; - not now
end;

procedure TMyChildT3_2026.FormPaint(Sender: TObject);
Var
  i: Integer;
begin
  Caption := GetReturnCaption(RetNo);
end;

function TMyChildT3_2026.GetHeaderFrame: TFrame; // 20160227 Igor
begin
  Result := MyFormHeaderFrame;
end;

function TMyChildT3_2026.GetMonitorFrame: TFrame; // 20160227 Igor
begin
  Result := MyMonitorFrame;
end;

Procedure TMyChildT3_2026.UpdateChildTaxPanel;
begin
  if RetNo < 1 then
    exit; // wait for valid RetNo

  FormatSettings.DecimalSeparator := '.'; // 20150805 Igor
  With MyMonitorFrame do
  begin
    BalancePanel.Color := GetRetColor(RetNo);
    TotIncPanel.Caption := FormatFloat('##,###,###.00',
      Vl(FetchElm(RetNo, 'T3', 126)));
    TotIncBfrPanel.Caption := FormatFloat('##,###,###.00',
      Vl(FetchElm(RetNo, 'T3', 252)));
    NetIncAftPanel.Caption := FormatFloat('##,###,###.00',
      Vl(FetchElm(RetNo, 'T3', 254)));
    TxblIncPanel.Caption := FormatFloat('##,###,###.00',
      Vl(FetchElm(RetNo, 'T3', 272)));

    If Vl(FetchElm(RetNo, 'T3', 324)) < 0 then
    begin
      BalanceLbl.Caption := 'Refund';
      BalancePanel.Caption := FormatFloat('##,###,##0.00',
        ABS(Vl(FetchElm(RetNo, 'T3', 324))));
    end
    else
    begin
      BalanceLbl.Caption := 'Owing';
      BalancePanel.Caption := FormatFloat('##,###,##0.00',
        Vl(FetchElm(RetNo, 'T3', 324)));
    end;
  end;
end;

Procedure TMyChildT3_2026.Keys(Var Key: Word; Shift: TShiftState);
var
  Handled: boolean;
begin
  { PLAIN F KEYS }
  Handled := True;
  { F1, F2 are in short cut }
  // If    (Key = VK_F1) then begin MainForm.HelpBtnClick(Application);exit;end;
  // If    (Key = VK_F2) then begin MainForm.SelectFormClick(Application);exit;end;
  If (Key = VK_F3) then
    MainForm.FileSaveAsItemClick(RetNo)
  else If (Key = VK_F4) then
    OpenForm(RetNo, GetFormNo('TAXSUM'), 0)
  else If (Key = VK_F5) then
    MainForm.GuiCommand(gcToggleLeftPanel)
    // MainForm.LeftPanel.Visible:= Not MainForm.LeftPanel.Visible //20160222 Igor
  else If (Key = VK_F7) then
    MainFormT3.Switchforms1Click(Application)
  else If (Key = VK_F8) then
    MainFormT3.SwapBtnClick(Application)
  else
    Handled := False;
  if Handled then
  begin
    Key := 0;
    exit;
  end;

  { CTRL 1 to 8 }
  if (Shift = [ssCtrl]) then
  begin
    Handled := True;
    if (Key = 49) then
      OpenForm(RetNo, GetFormNo('S1'), 0)
    else if (Key = 50) then
      OpenForm(RetNo, GetFormNo('S2'), 0)
    else if (Key = 51) then
      OpenForm(RetNo, GetFormNo('S3'), 0)
    else if (Key = 52) then
      OpenForm(RetNo, GetFormNo('S4'), 0)
    else if (Key = 53) then
      OpenForm(RetNo, GetFormNo('S5'), 0)
    else if (Key = 54) then
      OpenForm(RetNo, GetFormNo('S6'), 0)
    else if (Key = 55) then
      OpenForm(RetNo, GetFormNo('S7'), 0)
    else if (Key = 56) then
      OpenForm(RetNo, GetFormNo('S8#1'), 0)
    else if (Key = 57) then
      OpenForm(RetNo, GetFormNo('S9'), 0)
    else if (Key = 89) then
      OpenForm(RetNo, GetFormNo('COMPSUM'), 0) // Ctrl Y
    else
      Handled := False;
    if Handled then
    begin
      Key := 0;
      exit;
    end;
  end; { Ctrl }

  // ALT KEYS
  If Shift = [ssAlt] then
  begin
    Handled := True;
    If Key = 83 then
      MainFormT3.SwapReturns1Click(Application) { Alt S }
    else if Key = 88 then
      MainFormT3.FileCloseItemClick(Application) { Alt x }
    else
      Handled := False;
    if Handled then
    begin
      Key := 0;
      exit;
    end;
  end; { Alt keys }

  inherited;
end;

Procedure TMyChildT3_2026.UpdateFormHeaderFrame;
var
  FormInfo: String;
begin

  if not UpdateSectionButtons(MyFormHeaderFrame) then
    exit;
  FormInfo := AllTrim(GetFormAbrevName(FormNo));
  // MyFormHeaderFrame.ReturnNameLbl.Caption:=NmInfo;
  MyFormHeaderFrame.FormNameLbl.Caption := ' ' + FormInfo;
  MyFormHeaderFrame.CloseTabBtn.Visible := FormName <> 'T3'; // 20180109 Igor
end;

procedure TMyChildT3_2026.CloseActiveForm(Sender: TObject);
Var
  j: Integer;
begin
  If MyPageControl.PageCount < 2 then
  begin
    ShowMessage('You cannot close the last form' + Chr(13) +
      'You can close the file instead. Click the Close button');
    exit;
  end;
  inherited;
end;

Function TFormT3_2026.GetValueFromList(MyEditBox: TvtEdit;
  FieldId: Integer): String;
Var
  i: Integer;
  TempList: TStringList;
  FromFname: String;
  FromElm: Integer;
  s, TempString: String;
  // WList:TstringList;
begin
  Result := '';
  // populate the picklist
  SomeList.Clear; // := TStringList.Create;
  // SomeList := TStringList.Create;
  SomeCaption := 'Valid entries';
  Result := PopulatePickList(FieldId { ,Somelist } );

  If (FormName = 'T5013FIN') and (FieldId = 2) then
    exit; // 20140320

  // If ExtractNonInstFormName(FormName)='T1ADJ' then Exit;
  // nisa done another way via usearchlist
  If (ExtractNonInstFormName(FormName) = 'T1273_1') Or
    (ExtractNonInstFormName(FormName) = 'T1273_2') or
    (ExtractNonInstFormName(FormName) = 'NISAA_2') or
    (ExtractNonInstFormName(FormName) = 'T1273_3') or
    (ExtractNonInstFormName(FormName) = 'NISAA_3') or
    (ExtractNonInstFormName(FormName) = 'T1273_4')

    or (ExtractNonInstFormName(FormName) = 'T1273_5') or
    (ExtractNonInstFormName(FormName) = 'T1273_6') or
    (ExtractNonInstFormName(FormName) = 'T1273_7') or
    (ExtractNonInstFormName(FormName) = 'T1273CIV') or
    (ExtractNonInstFormName(FormName) = 'T1273LIV') or
    (ExtractNonInstFormName(FormName) = 'T1273ALI') or
    (ExtractNonInstFormName(FormName) = 'T1273OTH') then
  begin
    SelectedString := Result;
    exit;
  end;

  SelectedString := PopSomeList(SomeList, SomeCaption, MyEditBox);
  // SomeList.Free; //abends
  Result := CleanUpPickedListValue(FieldId, SelectedString);
  SelectedString := Result; // ??
end;

Function TFormT3_2026.GetLinkedForm(FieldId: Integer;
  Var TargetLinkedField: Integer): String;
Var
  i, j, Fld: Integer;
  Frm, InFrm: string; // [10];
  LinkList: TStringList;
  Wlist: TStringList;
  s: String;
begin
  Result := '';
  TargetLinkedField := 0;
  LinkList := TStringList.Create;
  // 20170515 Igor >>>
  try
    // 20170515 Igor <<<
    LinkList.LoadFromFile(AppDir + '\' + 'LINKLIST.D');
    InFrm := Rtrim(ExtractNonInstFormName(FormName));

    // multiple linked forms
    Wlist := TStringList.Create;
    // 20170515 Igor >>>
    try
      // 20170515 Igor <<<
      For i := 0 to LinkList.count - 1 do
      begin
        Frm := Rtrim(ExtractNonInstFormName(LeftStr(LinkList[i], 10)));
        If InFrm = Frm then
        begin
          Fld := MyStrToInt(MidStr(LinkList[i], 11, 3));
          If Fld = FieldId then
          begin
            s := AllTrim(MidStr(LinkList[i], 15, 80));
            ParseWords(s, ',', Wlist);
            If Wlist.count = 1 then { just one linked form }
            begin
              // wordformat is fffffff#n/5
              If ExtractFormInst(Rtrim(InFrm)) > '' then
                Result := ExtractFormSlashField(Wlist[0], TargetLinkedField) +
                  ExtractFormInst(Rtrim(FormName))
                // Rtrim(ExtractNonInstFormName(LeftStr(WList[0],10)))
              else
                Result := ExtractFormSlashField(Wlist[0], TargetLinkedField);
              If Result = '?PRVT3' then
                Result := WhichTaxForm(RetNo, Ret[RetNo].Province);
              // 20170515 Igor >>>
              // LinkList.Free;
              // WList.Free;
              // 20170515 Igor <<<
              exit;
            end // end single link
            Else If Wlist.count > 1 then
            begin
              SomeList.Clear; // := TStringList.Create;
              SomeCaption := 'Select from Linked forms';
              For j := 0 to Wlist.count - 1 do
                SomeList.Add(PaddR(Wlist[j], 20) + GetFormAbrevNameWithNoInst
                  (GetFormNo(Wlist[j])));
              SelectedString := PopSomeList(SomeList, SomeCaption);

              If SelectedString > '' then
              begin
                Result := AllTrim(LeftStr(SelectedString, 20));
                exit;
              end;
            end;
          end; // matching fieldid
        end; // found entry
      end;
      // 20170515 igor >>>
    finally
      Wlist.Free;
    end;
    // 20170515 Igor <<<
    // nothing found
    UserMsg('nothing linked to ' + InFrm + '.vtEdit' + IntToStr(FieldId));
    // 20170515 Igor >>>
  finally
    LinkList.Free;
  end;
  // 20170515 Igor <<<
end;

Function TFormT3_2026.PopulatePickList(FieldId: Integer { ;SomeList:TStrings } )
  : String; // 20160227 Igor
Var
  i: Integer;
  s, FromFname: String[10];
  FromElm: Integer;
  TempList: TStringList;
begin
  Result := '';
  // 20130420
  If FormName = 'T5013FIN' then
    case FieldId of
      2: // naics
        begin
          Application.CreateForm(TSICT3_2026, SIC);
          SIC.ShowModal;
          SIC.Free;
          If SelectedString > '' then
            Result := SelectedString
          Else
            Result := '';
          exit;
        end;
    end;

  // 20220119 Igor >>>
  If FormName.StartsWith('T2125#') then
  begin
    case FieldId of
      53:
        for i := Low(PrvShort) to High(PrvShort) do
          SomeList.Add(PrvShort[i]);
    end;
  end;
  // 20220119 Igor <<<

  // 20220119 Igor >>>
  If FormName.StartsWith('T2042#') then
  begin
    case FieldId of
      71:
        for i := Low(PrvShort) to High(PrvShort) do
          SomeList.Add(PrvShort[i]);
    end;
  end;
  // 20220119 Igor <<<

  // 20220119 Igor >>>
  If FormName.StartsWith('T2121#') then
  begin
    case FieldId of
      89:
        for i := Low(PrvShort) to High(PrvShort) do
          SomeList.Add(PrvShort[i]);
    end;
  end;
  // 20220119 Igor <<<

  If (FormName = 'T3') then
  begin
    // 20211201 Igor >>>
    case FieldId of
      11, 23, 73, 24:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
        // 'Country.d');  //20220312 ,151 O0t and use 3-char country
      9:
        for i := Low(PrvLong) to High(PrvLong) do
          SomeList.Add(PrvLong[i]);

      10:                                            //jz//202600314 - add dropdown for provinceOfBusiness
      begin
        for i := Low(PrvShort) to High(PrvShort) do
        begin
          SomeList.Add(PrvShort[i]);
        end;
        //jz//202600314 - 'ZZ' not a valid entry, replace 'ZZ' add 'MJ' and 'EX'
        SomeList[12] := 'NU';        //but also order is weird, put NU where ZZ was
        SomeList[13] := 'MJ';        //and then replace old NU with MJ
        SomeList.add('EX');
      end;
      // 67,66,68,149: for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]); //20180317
      67, 66, 68, 149:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d'); // 20240303

      81:
        SomeList.LoadFromFile(AppDir + '\' + 'TrustType.d');
        // 20160130  //If FetchElm(RetNo,'T3',79)>'' then
      155: // 20240203  //ReturnType
        begin
          SomeList.LoadFromFile(AppDir + '\' + 'ReturnType.d');
          // then open the new form
          s := LeftStr(FetchElm(RetNo, 'T3', 155), 8);
          s := UpperCase(Rtrim(s));
          OpenForm(GetCurrentRetNo, GetFormNo(s), 1);
        end;
    end; // case
    // 20211201 Igor <<<
  end;

  If (LeftStr(FormName, 4) = 'S15#') then // 20231129 Con
  begin
    case FieldId of
      30:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d'); // 202240310
      32:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d'); // 202240310
    end; // case
  end;

  If (FormName = 'T3RCA') then // 20231129 Con
  begin
    case FieldId of
      8, 17, 24:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
    end; // case
  end;

  If (FormName = 'T3ATH') then // 20231201
  begin
    case FieldId of
      11, 19, 29, 34, 67:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d'); // 20240118 Igor
      12, 20, 30, 35:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end;

  If (FormName = 'T3M') then // 20211111 Igor >>>
  begin
    case FieldId of
      2, 11, 14:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      12, 17:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end; // 20211111 Igor <<<

  If (FormName = 'T3S') then // 20231201
  begin
    case FieldId of
      10, 11, 26, 31:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      12, 27, 32:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end;

  If (FormName = 'T3P') then // 20231201
  begin
    case FieldId of
      8:
        for i := Low(PrvShort) to High(PrvShort) do
          SomeList.Add(PrvShort[i]); // 20240118 Igor
      18, 27, 32:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      19, 28, 33:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end;

  If (FormName = 'T3RI') then // 20231201
  begin
    case FieldId of
      7, 26, 17:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      18, 27:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end;

  If (FormName = 'T3D') then // 20231201
  begin
    case FieldId of
      16, 25, 30:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      17, 26, 31:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end;

  // 20240118 Igor >>>
  If (FormName = 'T3PRP') then
  begin
    case FieldId of
      9, 18, 27, 32:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      19, 28, 33:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end;

  If (FormName = 'T3GR') then
  begin
    case FieldId of
      13, 23, 33, 40, 45:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      24, 34, 41, 47:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end; // case
  end;
  // 20240118 Igor <<<

  // 20211223 Igor >>>
  If (FormName = 'EFMEMO') then
  begin
    case FieldId of
      2, 3:
        begin
          SomeList.Add('CONTACT_EFILER_BY_MAIL');
          SomeList.Add('CONTACT_WITH_CLIENT');
          SomeList.Add('NOT_APPLICABLE_2013'); // 20220307
        end;
    end;
  end;
  // 20211223 Igor <<<

  If FormName = 'T5013FIN' then
  begin
    case FieldId of
      16, 25, 33:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      17, 26, 34:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end; // case
  end;

  If LeftStr(FormName, 4) = 'PS9#' then
  begin
    case FieldId of
      7, 15, 23, 31, 39, 47, 55, 63, 71, 79, 87:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end; // case
  end;

  If (LeftStr(FormName, 7) = 'T3SUPL#') then
  begin
    case FieldId of
      29:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      66:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
      67:
        begin
          SomeList.Add('12');
          SomeList.Add('3A');
          SomeList.Add('3B');
          SomeList.Add('4B');
          SomeList.Add('11');
          SomeList.Add('07');
          SomeList.Add('13');
        end;

      3:
        begin
          SomeList.Add('O Original');
          SomeList.Add('A Amended');
          SomeList.Add('C Cancel');
        end;
      4:
        begin
          SomeList.Add('1 Individual');
          SomeList.Add('2 Joint account');
          SomeList.Add('3 Corporation');
          SomeList.Add('4 Association,trust,club,partnership');
          SomeList.Add('5 Government and others');
        end;

    end;
  end;

  If (LeftStr(FormName, 5) = 'PS50#') then
  begin
    case FieldId of
      15:
        begin
          SomeList.Add('0 Limited partner');
          SomeList.Add('1 Specified member who is not a limited partner');
          SomeList.Add('2 General partner');
          SomeList.Add('3 Limited partner exempt interest');
          SomeList.Add('4 Nominee, Agent, Broker or Advisor');
        end;
      14:
        begin
          SomeList.Add('1 Individual, other than a trust');
          SomeList.Add('2 Corporation');
          SomeList.Add('3 Partnership');
          SomeList.Add('4 Trust');
          SomeList.Add('5 Non-resident Individual, other than a trust');
          SomeList.Add('6 Non-resident Corporation');
          SomeList.Add('7 Non-resident Partnership');
          SomeList.Add('8 Non-resident Trust (other than Non-res Discr trust');
          SomeList.Add('9 Non-resident Discretionary trust');
        end;
      22:
        SomeList.LoadFromFile(AppDir + '\' + 'State.D');
      24:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end; // case
  end;

  // 20240118 Igor >>>
  If ((FormName = 'T3') and (FieldId = 326)) or
    ((FormName = 'T3M') and (FieldId = 48)) or
    ((FormName = 'T3P') and (FieldId = 44)) or
    ((FormName = 'T3PRP') and (FieldId = 46)) or
    ((FormName = 'T3GR') and (FieldId = 66)) or
    ((FormName = 'T3RI') and (FieldId = 43)) or
    ((FormName = 'T3S') and (FieldId = 46)) then
  begin
    SomeList.Add('0 Refund the credit');
    SomeList.Add('1 Keep the credit for next year');
    SomeList.Add('2 Hold the credit (Attach letter)');
    SomeList.Add('-');
  end;
  // 20240118 Igor <<<

  If (LeftStr(FormName, 7) = 'T5018L#') then
  begin
    case FieldId of
      13:
        begin
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
        end;
      15:
        begin
          SomeCaption := 'Country Codes';
          SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
        end;
    end; // case
  end;

  If (FormName = 'T5018S') then
  begin
    case FieldId of
      8:
        begin
          for i := Low(PrvLong) to High(PrvLong) do
            SomeList.Add(PrvShort[i]);
        end;
      21:
        begin
          SomeList.Add('1 WIP');
          SomeList.Add('2 Ready for Print');
          SomeList.Add('3 Ready for Efile');
          // SomeList.Add('4 Ready for Print');
          // SomeList.Add('5 Ready for Efile');
          SomeList.Add('6 Printed');
          SomeList.Add('7 Printed/Mailed');
          SomeList.Add('8 Efiled');
          SomeList.Add('9 N/A');
        end;
    end; // case
  end;

  If FormName = 'T106' then
    case FieldId of
      35, 36, 37, 38:
        SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d');
    end;

  If LeftStr(FormName, 7) = 'T106SL#' then
    case FieldId of
      13:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
      19, 20, 21, 22:
        SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d');
      33, 121, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89, 35, 123,
        39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91:
        begin
          SomeList.Add('1 Comparable Uncontrolled Price');
          SomeList.Add('2 Cost-Plus');
          SomeList.Add('3 Resale');
          SomeList.Add('4 Profit Split');
          SomeList.Add('5 Transactional Net Margin');
          SomeList.Add('6 Qualifing Cost Contribution Arrangement');
          SomeList.Add('7 Other');
        end;
      24, 25, 26, 27:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end; // case

  If LeftStr(FormName, 8) = 'ASSETSB#' then
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
  end;

  If LeftStr(FormName, 6) = 'AUTOS#' then
  begin
    case FieldId of
      134: // ,135,136:
        begin
          SomeList.Add('10');
          SomeList.Add('10.1')
        end;
      215, 221, 227:
        begin
          GetListOfStatementsForAutos(RetNo, SomeList);
        end;
    end; // case
  end;

  If (LeftStr(FormName, 9) = 'T3INCOME#') then
  begin
    case FieldId of
      31:
        begin
          SomeCaption := 'Foreign Exchange Rates';
          SomeList.LoadFromFile(AppDir + '\' + 'ExchRate.d');
        end;
      5:
        begin
          SomeList.Add('1');
          SomeList.Add('2');
          SomeList.Add('3');
        end;
    end;
  end;

  If (LeftStr(FormName, 9) = 'T5INCOME#') then
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
  end;

  If (LeftStr(FormName, 9) = 'T5013INC#') then
    case FieldId of
      1:
        begin
          SomeList.Add('1');
          SomeList.Add('2');
          SomeList.Add('3');
        end;
    end; // case

  If (LeftStr(FormName, 6) = 'T5013#') then
    case FieldId of
      8:
        begin
          SomeList.Add('0 Original slip');
          SomeList.Add('1 Amended slip');
          SomeList.Add('2 Additional slip');
          SomeList.Add('3 Cancelled slip');
          SomeList.Add('4 Duplicate slip');
        end;
    end; // case

  If FormName = 'T5013SUM' then // 20120324
    case FieldId of
      85, 88, 90, 92, 94, 98:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');
      79, 83:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');
      102, 106, 110, 114, 118, 122, 126:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');
      112, 143, 147, 262:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');
      269, 273, 277, 281, 285, 289, 293, 297, 301, 305, 309, 313, 317:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');
      321, 325, 329, 333, 337, 341, 345, 349, 353, 357, 361, 365, 369,
        373, 377, 381:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');
      128, 137:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');
      242 .. 260:
        SomeList.LoadFromFile(AppDir + '\' + 'FCPlusSt.d');

      // 20150705
    else
      If FormName = 'T1135' then // 20130720
      begin
        If FieldId > 9999 then
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

      (*
        97,101,105,109,113,117,121,125:
        begin
        SomeList.Add('162  Gross business income (loss)');
        SomeList.Add('164  Gross professional income (loss)');
        SomeList.Add('166  Gross commission income (loss)');
        SomeList.Add('168  Gross farming income (loss)');
        SomeList.Add('170  Gross fishing income (loss)');
        SomeList.Add('35-1 Tax exempt foreign business income');
        SomeList.Add('39   Commission income (loss)');
        SomeList.Add('60   Total business income (loss) from active business');
        SomeList.Add('61   Cdn manufacturing and Processing profits under S125.1(3)');
        end;
      *)
    end;

  (*
    If FormName = 'T5013SUM' then
    case FieldId of
    78:SomeList.Add('34  Partnership total gross income');
    15,18,22,25,32,35,39,42: SomeList.LoadFromFile(AppDir+'\'+'State.D');
    177: SomeList.LoadFromFile(AppDir+'\'+'State.D');
    17,24,34,41: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');

    85,88,90,92,94,98:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
    79,83:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
    102,106,110,114,118,122,126:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
    112,143,147,262:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
    269,273,277,281,285,289,293,297,301,305,309,313,317:
    Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
    321,325,329,333,337,341,345,349,353,357,361,365,369,373,377,381:
    Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
    128,137:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
    242..260:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');

    97,101,105,109,113,117,121,125:
    begin
    SomeList.Add('162  Gross business income (loss)');
    SomeList.Add('164  Gross professional income (loss)');
    SomeList.Add('166  Gross commission income (loss)');
    SomeList.Add('168  Gross farming income (loss)');
    SomeList.Add('170  Gross fishing income (loss)');
    SomeList.Add('35-1 Tax exempt foreign business income');
    SomeList.Add('39   Commission income (loss)');
    SomeList.Add('60   Total business income (loss) from active business');
    SomeList.Add('61   Cdn manufacturing and Processing profits under S125.1(3)');
    end;

    142, 146, 82:
    begin
    SomeList.Add('26-1 Foreign rental income, exempt from tax');
    SomeList.Add('55-1 Foreign investment income, exempt from tax');
    SomeList.Add('56-5 ABIL-Proceeds of dispositions');
    SomeList.Add('56-6 ABIL-Adjusted Cost base');
    SomeList.Add('56-7 ABIL-Outlays and expenses');
    SomeList.Add('57   Dividend rental arrangement compensation payments');
    SomeList.Add('58   Other investment income');
    end;
    end;
  *)
  {
    If FormName = 'POTHINFO' then
    case FieldId of
    3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79,83,87,91,95,99:
    SomeList.LoadFromFile(AppDir+'\'+'FCplusSt.D');
    103,107,111,115,119,123,127,131,135,139,143,147,151,155,159,163,167,171,175:
    SomeList.LoadFromFile(AppDir+'\'+'FCplusSt.D');
    end;
  }
  If FormName = 'T1135' then // 20160227 Igor
  begin
    If FieldId > 9999 then
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
  end;

  If LeftStr(FormName, 5) = 'PS100' then
    case FieldId of
      5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41,
        43, 45, 47, 49, 51, 53, 55:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFIAssets.d');
      78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110,
        112, 114, 116, 118, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138,
        140, 142, 144, 146, 148:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFILiabilities.D');

      151, 153, 155, 157, 159, 161, 163, 165, 167, 169, 171, 173, 175, 177, 179,
        181, 183, 185:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFIEquity.D');

      188, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFIRetEarnings.D');
    end;

  If LeftStr(FormName, 6) = 'PS125#' then
    case FieldId of
      7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 43,
        45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFINFIncome.d');
      68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102,
        104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFINFCostOfSales.D');

      128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156,
        158, 160, 162, 164, 168, 170, 172, 174, 176, 178, 180, 182:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFINfOperExpenses.D');

      189, 191, 193, 195, 197, 199, 201, 203:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFIFarmIncome.D');

      206, 208, 210, 212, 214, 216, 218, 220, 22, 224, 226, 228, 230, 232, 234,
        236, 238, 240, 242, 244, 246, 248, 250, 252, 254, 256, 258, 260, 262,
        264, 266, 268, 270, 272:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFIFarmExpenses.D');

      277, 279, 281, 283, 285, 287, 289, 291, 293, 295, 297, 299:
        SomeList.LoadFromFile(AppDir + '\' + 'GIFIExtraItems.D');

    end;

  If ExtractNonInstFormName(FormName) = 'T3SUPL' then
    case FieldId of
      61:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end;

  If FormName = 'T5011' then
    case FieldId of
      7, 17, 22, 25:
        SomeList.LoadFromFile(AppDir + '\' + 'State.D');
      9, 24:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end;

  If (LeftStr(FormName, 4) = 'PS8#') then
    case FieldId of
      6, 22, 38, 54, 70, 86, 102, 118, 134, 150, 166, 182, 198:
        for i := Low(CCARates) to High(CCARates) do
          SomeList.LoadFromFile(AppDir + '\' + 'CCARates.D');
    end;

  If (LeftStr(FormName, 6) = 'T5015#') then
  begin
    case FieldId of
      11, 27, 43, 59, 75, 91, 107, 123, 139, 155:
        begin
          SomeList.Add('1 Individual');
          SomeList.Add('3 Corporation');
          SomeList.Add('4 Trust or Partnership');
        end;
      12, 28, 44, 60, 76, 92, 108, 124, 140, 156:
        begin
          SomeList.Add('0 Limited Partner');
          SomeList.Add('1 Specified Partner');
          SomeList.Add('2 General Partner');
        end;
      17, 33, 49, 65, 81, 97, 113, 129, 145, 161:
        SomeList.LoadFromFile(AppDir + '\' + 'State.D');
      19, 35, 51, 67, 83, 99, 115, 131, 147, 163:
        SomeList.LoadFromFile(AppDir + '\' + 'FCountry.d');
    end; // case
  end;

  If FormName = 'T3010' then // 20130225
  begin
    case FieldId of
      189, 193, 197, 201, 205:
        SomeList.LoadFromFile(AppDir + '\' + 'CharCountry.d');
      153, 156, 159, 162, 165:
        SomeList.LoadFromFile(AppDir + '\' + 'CharCountry.d');
      384, 387, 390, 393, 396, 399, 402:
        SomeList.LoadFromFile(AppDir + '\' + 'CharCountry.d');
      167 .. 176:
        SomeList.LoadFromFile(AppDir + '\' + 'CharCountry.d');
    end; // case
  end;

  //20260817 Alex >>>
  if FormName = 'T106' then
  begin
    case FieldId of
      2, 67, 72:
        Somelist.LoadFromFile(AppDir + '\' + 'FCountry.d');
      3:
      begin
        SomeList.Add('1   New');
        SomeList.Add('2   Unmodified');
        SomeList.Add('3   Amended');
      end;
      35, 36, 37, 38:
        Somelist.LoadFromFile(AppDir + '\' + 'NAICS.d');
      60:
        for i:= 0 to pred(length(functionalCurrency_N)) do SomeList.Add(functionalCurrency_N[i]);
    end;
  end;

  if ExtractNonInstFormName(FormName) = 'T106SL' then
  begin
    case FieldId of
      13, 24, 25, 26, 27:
        Somelist.LoadFromFile(AppDir + '\' + 'FCountry.d');
      19, 20, 21, 22:
        Somelist.LoadFromFile(AppDir + '\' + 'NAICS.d');
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
        if FetchElm(RetNo, 'T106', 3) = '3   Amended' then  //jz 20241206 ss per cra email
          SomeList.Add('1   Additional')
        else
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
    end;
  end;
  //20260817 Alex <<<

  //20260115 Igor >>>
  if FormName = 'T1134' then
  begin
    FieldId:= GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
     40, 41, 42, 43: SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d'); //20230510 Igor
     24:
     begin
       SomeList.Add('USD = US Dollar');
       SomeList.Add('GBP = GB Pound Sterling');
       SomeList.Add('AUD = AU Dollar');
       SomeList.Add('EUR = Euro');
     end;
     25:
     begin
       SomeList.Add('1   New');
       SomeList.Add('2   Unmodified');
       SomeList.Add('3   Amended');
     end;
     20009, 20010, 20011, 20012, 30009, 30010, 30011, 30012, 40010, 40011, 40012, 40013: SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d');
     17, 10007, 20005, 30005, 40005: SomeList.LoadFromFile(AppDir + '\' + 'State.d');
     141, 10009, 20007, 30007, 40007, 60002, 60005, 70003, 70006, 80003, 90003, 110003: SomeList.LoadFromFile(AppDir + '\' + 'FCountryT1135.d');
     40009:
     begin
       SomeList.Add('1   If end partners are individuals or trusts');
       SomeList.Add('2   If end partners are corporations');
       SomeList.Add('3   If end partners are a combination of 1 and 2 mentioned above');
     end;
     60003,70001,90004,110001: PopulateT1134ForeignAffiliates(RetNo,SomeList); //20230601 Igor
    end;
  end

  else if LeftStr(FormName, 7) = 'T1134S#' then
  begin
    FieldId:= GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row

    case FieldId of
     20001, 30001: PopulateT1134SGroupList(RetNo, FormNo, SomeList, 1);
     50001, 60001, 70002, 80002, 90002, 100002, 110001, 140001: PopulateT1134SGroupList(RetNo, FormNo, SomeList);
     10001, 40001, 120001, 130001, 150001, 160001: PopulateT1134GroupList(RetNo, SomeList);
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
     40, 41, 42, 43: SomeList.LoadFromFile(AppDir + '\' + 'NAICS.d');
     44, 45, 46, 47, 5, 6, 7, 8, 48: SomeList.LoadFromFile(AppDir + '\' + 'FCountryT1135.d');
     10012, 16, 18, 79, 83, 87, 91, 95, 99, 103, 107, 111: SomeList.LoadFromFile(AppDir + '\' + 'Currency.d');
    end;
  end;
  //20260115 Igor <<<

  // Result:='';
  // //20130420
  // If FormName = 'T5013FIN' then
  // case FieldId of
  // 2: //naics
  // begin
  // Application.CreateForm(TSICT3_2026,SIC);
  // SIC.ShowModal;
  // SIC.Free;
  // If SelectedString>'' then
  // Result:=SelectedString
  // Else
  // Result:='';
  // Exit;
  // end;
  // end;
  //
  //
  //
  // If (FormName = 'T3') then
  // begin
  // case FieldId of
  // 11:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
  // 9: for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvLong[i]);
  // 81: If FetchElm(RetNo,'T3',79)>'' then SomeList.LoadFromFile(AppDir+'\'+'TrustType.d');   //20160130
  // end; //case
  // end;
  //
  // If FormName = 'T5013FIN' then
  // begin
  // case FieldId of
  // 16,25,33:SomeList.LoadFromFile(AppDir+'\'+'State.d');
  // 17,26,34: SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end; //case
  // end;
  //
  // If LeftStr(FormName,4) = 'PS9#' then
  // begin
  // case FieldId of
  // 7,15,23,31,39,47,55,63,71,79,87: SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end; //case
  // end;
  //
  //
  // If (LeftStr(FormName,7) = 'T3SUPL#') then
  // begin
  // case FieldId of
  // 29:SomeList.LoadFromFile(AppDir+'\'+'State.d');
  // 66: SomeList.LoadFromFile(AppDir+'\'+'FCountry.d');
  // 67: begin
  // SomeList.Add('12');
  // SomeList.Add('3A');
  // SomeList.Add('3B');
  // SomeList.Add('4B');
  // SomeList.Add('11');
  // SomeList.Add('07');
  // SomeList.Add('13');
  // end;
  //
  // 3: begin
  // SomeList.Add('O Original');
  // SomeList.Add('A Amended');
  // SomeList.Add('C Cancel');
  // end;
  // 4: begin
  // SomeList.Add('1 Individual');
  // SomeList.Add('2 Joint account');
  // SomeList.Add('3 Corporation');
  // SomeList.Add('4 Association,trust,club,partnership');
  // SomeList.Add('5 Government and others');
  // end;
  //
  // end;
  // end;
  //
  //
  // If (LeftStr(FormName,5) = 'PS50#') then
  // begin
  // case FieldId of
  // 15:
  // begin
  // SomeList.Add('0 Limited partner');
  // SomeList.Add('1 Specified member who is not a limited partner');
  // SomeList.Add('2 General partner');
  // SomeList.Add('3 Limited partner exempt interest');
  // SomeList.Add('4 Nominee, Agent, Broker or Advisor');
  // end;
  // 14:
  // begin
  // SomeList.Add('1 Individual, other than a trust');
  // SomeList.Add('2 Corporation');
  // SomeList.Add('3 Partnership');
  // SomeList.Add('4 Trust');
  // SomeList.Add('5 Non-resident Individual, other than a trust');
  // SomeList.Add('6 Non-resident Corporation');
  // SomeList.Add('7 Non-resident Partnership');
  // SomeList.Add('8 Non-resident Trust (other than Non-res Discr trust');
  // SomeList.Add('9 Non-resident Discretionary trust');
  // end;
  // 22:SomeList.LoadFromFile(AppDir+'\'+'State.D');
  // 24: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end; //case
  // end;
  //
  //
  // If (FormName = 'T3') then
  // begin
  // case FieldId of
  // 326: begin
  // SomeList.Add('0 Refund the credit');
  // SomeList.Add('1 Keep the credit for next year');
  // SomeList.Add('2 Hold the credit (Attach letter)');
  // end;
  // end; //case
  // end;
  //
  //
  // If (LeftStr(FormName,7) = 'T5018L#') then
  // begin
  // case FieldId of
  // 13: begin
  // for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]);
  // end;
  // 15: begin
  // SomeCaption:='Country Codes';
  // Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end;
  // end; //case
  // end;
  //
  // If (FormName = 'T5018S') then
  // begin
  // case FieldId of
  // 8:  begin
  // for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]);
  // end;
  // 22: begin
  // SomeCaption:='Country Codes';
  // Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end;
  // 21: begin
  // SomeList.Add('1 WIP');
  // SomeList.Add('2 Ready for Print');
  // SomeList.Add('3 Ready for Efile');
  // //SomeList.Add('4 Ready for Print');
  // //SomeList.Add('5 Ready for Efile');
  // SomeList.Add('6 Printed');
  // SomeList.Add('7 Printed/Mailed');
  // SomeList.Add('8 Efiled');
  // SomeList.Add('9 N/A');
  // end;
  // end; //case
  // end;
  //
  // If FormName = 'T106' then
  // case FieldId of
  // 35,36,37,38:Somelist.LoadFromFile(AppDir+'\'+'NAICS.d');
  // end;
  //
  // If LeftStr(FormName,7) = 'T106SL#' then
  // case FieldId of
  // 13:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
  // 19,20,21,22:Somelist.LoadFromFile(AppDir+'\'+'NAICS.d');
  // 33,121,37,41,45,49,53,57,61,65,69,73,77,81,85,89,
  // 35,123,39,43,47,51,55,59,63,67,71,75,79,83,87,91:
  // begin
  // SomeList.Add('1 Comparable Uncontrolled Price');
  // SomeList.Add('2 Cost-Plus');
  // SomeList.Add('3 Resale');
  // SomeList.Add('4 Profit Split');
  // SomeList.Add('5 Transactional Net Margin');
  // SomeList.Add('6 Qualifing Cost Contribution Arrangement');
  // SomeList.Add('7 Other');
  // end;
  // 24,25,26,27:
  // Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end;  //case
  //
  //
  // If LeftStr(FormName,8) = 'ASSETSB#'  then
  // begin
  // case FieldId of
  // 215,221,227:
  // begin
  // GetListOfStatementsForAutos(RetNo,Somelist);
  // end;
  // 134:
  // begin
  // SomeCaption:='CCA Class, Rate and description';
  // Somelist.LoadFromFile(AppDir+'\'+'CCARATES.d');
  // end;
  // end; //case
  // end;
  //
  // If LeftStr(FormName,6) = 'AUTOS#'  then
  // begin
  // case FieldId of
  // 134: //,135,136:
  // begin
  // SomeList.Add('10');
  // SomeList.Add('10.1')
  // end;
  // 215,221,227:
  // begin
  // GetListOfStatementsForAutos(RetNo,Somelist);
  // end;
  // end; //case
  // end;
  //
  // If (LeftStr(FormName,9) = 'T3INCOME#') then
  // begin
  // case FieldId of
  // 31:
  // begin
  // SomeCaption:='Foreign Exchange Rates';
  // Somelist.LoadFromFile(AppDir+'\'+'ExchRate.d');
  // end;
  // 5:
  // begin
  // SomeList.Add('1');
  // SomeList.Add('2');
  // SomeList.Add('3');
  // end;
  // end;
  // end;
  //
  // If (ExtractNonInstFormName(FormName) = 'NR4DET') then
  // begin
  // case FieldId of
  // 2:
  // begin
  // SomeList.Add('1 individual');
  // SomeList.Add('2 joint account');
  // SomeList.Add('3 corporation');
  // SomeList.Add('4 other (association, trust, etc');
  // SomeList.Add('5 government, government enterprise, or international organizations');
  // end;
  // 3:Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // 10,15:Somelist.LoadFromFile(AppDir+'\'+'ExemptCd.d');
  // 7,12:begin Somelist.LoadFromFile(AppDir+'\'+'CurrencyCd.d'); end;
  // 25,32:Somelist.LoadFromFile(AppDir+'\'+'STATE.d');
  // 27,34:Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  //
  // end; //case
  // end;
  //
  // If (LeftStr(FormName,9) = 'T5INCOME#') then
  // begin
  // case FieldId of
  // 21,43,65,87,109:
  // begin
  // SomeCaption:='Foreign Exchange Rates';
  // Somelist.LoadFromFile(AppDir+'\'+'ExchRate.d');
  // end;
  // 5,27,49,71,93:
  // begin
  // SomeList.Add('1');
  // SomeList.Add('2');
  // SomeList.Add('3');
  // end;
  // end; //case
  // end;
  //
  // If (LeftStr(FormName,9) = 'T5013INC#')
  // then
  // case FieldId of
  // 1:
  // begin
  // SomeList.Add('1');
  // SomeList.Add('2');
  // SomeList.Add('3');
  // end;
  // end;  //case
  //
  // If (LeftStr(FormName,6) = 'T5013#')
  // then
  // case FieldId of
  // 8:
  // begin
  // SomeList.Add('0 Original slip');
  // SomeList.Add('1 Amended slip');
  // SomeList.Add('2 Additional slip');
  // SomeList.Add('3 Cancelled slip');
  // SomeList.Add('4 Duplicate slip');
  // end;
  // end;  //case
  //
  // If FormName = 'T5013SUM' then  //20120324
  // case FieldId of
  // 85,88,90,92,94,98:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // 79,83:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // 102,106,110,114,118,122,126:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // 112,143,147,262:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // 269,273,277,281,285,289,293,297,301,305,309,313,317:
  // Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // 321,325,329,333,337,341,345,349,353,357,361,365,369,373,377,381:
  // Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // 128,137:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // 242..260:Somelist.LoadFromFile(AppDir+'\'+'FCPlusSt.d');
  // end;
  // {
  // If FormName = 'POTHINFO' then
  // case FieldId of
  // 3,7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79,83,87,91,95,99:
  // SomeList.LoadFromFile(AppDir+'\'+'FCplusSt.D');
  // 103,107,111,115,119,123,127,131,135,139,143,147,151,155,159,163,167,171,175:
  // SomeList.LoadFromFile(AppDir+'\'+'FCplusSt.D');
  // end;
  // }
  // If LeftStr(FormName,5) = 'PS100' then
  // case FieldId of
  // 5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFIAssets.d');
  // 78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,
  // 118,120,122,124,126,128,130,132,134,136,138,140,142,144,146,148:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFILiabilities.D');
  //
  // 151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFIEquity.D');
  //
  // 188,190,192,194,196,198,200,202,204,206,208:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFIRetEarnings.D');
  // end;
  //
  // If LeftStr(FormName,6) = 'PS125#' then
  // case FieldId of
  // 7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,
  // 57,59,61,63,65:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFINFIncome.d');
  // 68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,
  // 118,120,122,124:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFINFCostOfSales.D');
  //
  // 128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158,
  // 160,162,164,168,170,172,174,176,178,180,182:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFINfOperExpenses.D');
  //
  // 189,191,193,195,197,199,201,203:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFIFarmIncome.D');
  //
  // 206,208,210,212,214,216,218,220,22,224,226,228,230,232,234,236,238,240,242,244,
  // 246,248,250,252,254,256,258,260,262,264,266,268,270,272:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFIFarmExpenses.D');
  //
  // 277,279,281,283,285,287,289,291,293,295,297,299:
  // SomeList.LoadFromFile(AppDir+'\'+'GIFIExtraItems.D');
  //
  // end;
  //
  //
  // If ExtractNonInstFormName(FormName) = 'T3SUPL' then
  // case FieldId of
  // 61: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end;
  //
  //
  // If FormName = 'T5011' then
  // case FieldId of
  // 7,17,22,25: SomeList.LoadFromFile(AppDir+'\'+'State.D');
  // 9,24: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end;
  //
  //
  // If (LeftStr(FormName,4) = 'PS8#') then
  // case FieldId of
  // 6,22,38,54,70,86,102,118,134,150,166,182,198:
  // for i := Low(CCARates) to High(CCARates) do
  // SomeList.LoadFromFile(AppDir+'\'+'CCARates.D');
  // end;
  //
  //
  //
  // If (LeftStr(FormName,6) = 'T5015#') then
  // begin
  // case FieldId of
  // 11,27,43,59,75,91,107,123,139,155:
  // begin
  // SomeList.Add('1 Individual');
  // SomeList.Add('3 Corporation');
  // SomeList.Add('4 Trust or Partnership');
  // end;
  // 12,28,44,60,76,92,108,124,140,156:
  // begin
  // SomeList.Add('0 Limited Partner');
  // SomeList.Add('1 Specified Partner');
  // SomeList.Add('2 General Partner');
  // end;
  // 17,33,49,65,81,97,113,129,145,161: SomeList.LoadFromFile(AppDir+'\'+'State.D');
  // 19,35,51,67,83,99,115,131,147,163: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
  // end;  //case
  // end;
  //
  // If FormName = 'T3010'then  //20130225
  // begin
  // case FieldId of
  // 189,193,197,201,205: Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
  // 153,156,159,162,165:Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
  // 384,387,390,393,396,399,402:Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
  // 167..176:Somelist.LoadFromFile(AppDir+'\'+'CharCountry.d');
  // end;  //case
  // end;

end;

Function TFormT3_2026.CleanUpPickedListValue(FieldId: Integer;
  SelectedString: String): string; // 20160227 Igor
Var
  TempS: String;
Begin
  Result := SelectedString;
  // 20160130
  If FormName = 'T3' then
    If FieldId = 81 then // 201
    Begin
      Result := LeftStr(SelectedString, 3);
      StoreElm(RetNo, 'T3', 82, MidStr(SelectedString, 5, 50)); // 20211213
      If Not Numeric(Result) then
        Result := '';
    end;

  If FormName = 'T3' then
  Begin
    If (FieldId = 66) then //20240329
      Result := LeftStr(SelectedString, 2);
    If (FieldId = 67) then //20240328
      Result := LeftStr(SelectedString, 2);
    If (FieldId = 68) then //20240328
      Result := LeftStr(SelectedString, 2);
  end;

  // 20211015
  // 20240118 Igor >>>
  // refund code
  If ((FormName = 'T3') and (FieldId = 326)) or
    ((FormName = 'T3M') and (FieldId = 48)) or
    ((FormName = 'T3P') and (FieldId = 44)) or
    ((FormName = 'T3PRP') and (FieldId = 46)) or
    ((FormName = 'T3GR') and (FieldId = 66)) or
    ((FormName = 'T3RI') and (FieldId = 43)) or
    ((FormName = 'T3S') and (FieldId = 46)) then
  Begin
    Result := LeftStr(SelectedString, 1);
    If Not Numeric(Result) then
      Result := '';
  end;

  If ((FormName = 'T3') and (FieldId = 155)) then
  begin
    if LeftStr(SelectedString, 1) = '*' then // comment //202401
      // do nothing
    else
      Result := LeftStr(SelectedString, 9); // 20240203
  end;

  If (LeftStr(FormName, 4) = 'S15#') then // 20240310
  begin
    case FieldId of
      30:
        Result := LeftStr(SelectedString, 3);
      32:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3RCA') then
  begin
    case FieldId of
      8, 17, 24: Result := LeftStr(SelectedString, 2);
      9, 18, 25: Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3ATH') then
  begin
    case FieldId of
      11, 19, 29, 34, 67: Result := LeftStr(SelectedString, 2);
      12, 20, 30, 35: Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3M') then
  begin
    case FieldId of
      2, 11, 14:
        Result := LeftStr(SelectedString, 2);
      12, 17:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3S') then
  begin
    case FieldId of
      10, 11, 26, 31:
        Result := LeftStr(SelectedString, 2);
      12, 27, 32:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3P') then
  begin
    case FieldId of
      8:
        Result := LeftStr(SelectedString, 2);
      18, 27, 32:
        Result := LeftStr(SelectedString, 2);
      19, 28, 33:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3RI') then
  begin
    case FieldId of
      7, 26, 17:
        Result := LeftStr(SelectedString, 2);
      18, 27:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3D') then
  begin
    case FieldId of
      16, 25, 30:
        Result := LeftStr(SelectedString, 2);
      17, 26, 31:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3PRP') then
  begin
    case FieldId of
      9, 18, 27, 32:
        Result := LeftStr(SelectedString, 2);
      19, 28, 33:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;

  If (FormName = 'T3GR') then
  begin
    case FieldId of
      13, 23, 33, 40, 45:
        Result := LeftStr(SelectedString, 2);
      24, 34, 41, 47:
        Result := LeftStr(SelectedString, 2);
    end; // case
  end;
  // 20240118 Igor <<<

  // 20220119 Igor >>>
  If FormName = 'T3' then
  begin // counry
    If FieldId in [11, 23, 24, 73] then
      Result := LeftStr(SelectedString, 3); // 20220312
    // If FieldId in [23, 24, 73]  then result := LeftStr(SelectedString,2);
  end;
  // 20220119 Igor <<<

  If (LeftStr(FormName, 7) = 'T3SUPL#') then
  begin
    If FieldId = 29 then
      Result := LeftStr(SelectedString, 2);
    If FieldId = 3 then
      Result := LeftStr(SelectedString, 1);
    If FieldId = 4 then
      Result := LeftStr(SelectedString, 1);
    If FieldId = 61 then
      Result := LeftStr(SelectedString, 3); // 20120416
  end;

  If FormName = 'T5013FIN' then
  begin
    Case FieldId of
      16, 25, 33, 17, 26, 34:
        Result := LeftStr(SelectedString, 2);
    end; // case;
  end;

  If LeftStr(FormName, 4) = 'PS9#' then
  begin
    Result := LeftStr(SelectedString, 3); // country
  end;

  If (LeftStr(FormName, 8) = 'ASSETSB#') then
  begin
    If (FieldId = 215) or (FieldId = 221) or (FieldId = 227) then
      Result := LeftStr(SelectedString, 8);
    If (FieldId = 134) then
      Result := LeftStr(SelectedString, 4);
  end;

  If (LeftStr(FormName, 5) = 'PS50#') then
  begin
    If FieldId = 14 then
      Result := LeftStr(SelectedString, 1);
    If FieldId = 15 then
      Result := LeftStr(SelectedString, 1);
    If FieldId = 22 then
      Result := LeftStr(SelectedString, 2);
    If FieldId = 24 then
      Result := LeftStr(SelectedString, 3);
    If FieldId = 47 then
      Result := LeftStr(SelectedString, 2);
    If FieldId = 49 then
      Result := LeftStr(SelectedString, 3);
  end;

  If (LeftStr(FormName, 6) = 'AUTOS#') then
  begin
    If (FieldId = 215) or (FieldId = 221) or (FieldId = 227) then
      Result := LeftStr(SelectedString, 8);
  end;

  If (FormName = 'T5014') then
    Result := LeftStr(Result, 4);

  If LeftStr(FormName, 6) = 'T5015#' then
  begin
    Case FieldId of
      11, 27, 43, 59, 75, 91, 107, 123, 139, 155:
        Result := LeftStr(Result, 1);
      12, 28, 44, 60, 76, 92, 108, 124, 140, 156:
        Result := LeftStr(Result, 1);
    else
      Result := LeftStr(Result, 3);
    end; // case
  end;

  If (ExtractNonInstFormName(FormName) = 'T5018L') then
  begin
    case FieldId of
      15:
        Result := LeftStr(Result, 3);
    end; // case
  end;

  If (ExtractNonInstFormName(FormName) = 'T5018S') then
  begin
    case FieldId of
      22:
        Result := LeftStr(Result, 3);
    end; // case
  end;

  If (LeftStr(FormName, 9) = 'T3INCOME#') and (FieldId = 31) then
  begin
    Result := AllTrim(LeftStr(SelectedString, 30));
    StoreElm(RetNo, FormNo, FieldId - 27,
      AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If (LeftStr(FormName, 9) = 'T5INCOME#') and
    ((FieldId = 21) or (FieldId = 43) or (FieldId = 65) or (FieldId = 87) or
    (FieldId = 109)) then
  begin
    Result := AllTrim(LeftStr(SelectedString, 20));
    StoreElm(RetNo, FormNo, FieldId - 17,
      AllTrim(MidStr(SelectedString, 31, 12)));
  end;

  If FormName = 'T5013SUM' then
  begin
    TempS := Result;
    Result := LeftStr(Result, 4);
    Case FieldId of
      97, 101, 105, 109, 113, 117, 121, 125, 142, 146, 82:
        StoreElm(RetNo, FormNo, FieldId - 1, MidStr(TempS, 5, 40));
    end; // case
  end;

  If (LeftStr(FormName, 6) = 'T5013#')
  // or (LeftStr(FormName,7) = 'T5013A#')
  then
    Result := LeftStr(Result, 1);

  If (LeftStr(FormName, 5) = 'PS100') then
    Result := LeftStr(Result, 4);
  If (LeftStr(FormName, 6) = 'PS125#') then
    Result := LeftStr(Result, 4);
  // If (FormName = 'POTHINFO') then Result := LeftStr(Result,4);

  If FormName = 'T5011' then
    Result := LeftStr(Result, 3);

  If FormName = 'T106' then
    Result := LeftStr(Result, 3);
  If LeftStr(FormName, 7) = 'T106SL#' then
  begin
    Case FieldId of
      13:
        Result := LeftStr(Result, 2);
      19, 20, 21, 22:
        Result := LeftStr(Result, 3);
      24, 25, 26, 27:
        Result := LeftStr(Result, 3);
    else
      Result := LeftStr(Result, 1);
    end; // case
  end;

  If (LeftStr(FormName, 4) = 'PS8#') then
    Result := LeftStr(Result, 4);

  If FormName = 'T3010' then // 20130225
  begin
    case FieldId of
      189, 193, 197, 201, 205:
        Result := LeftStr(Result, 2);
      153, 156, 159, 162, 165:
        Result := LeftStr(Result, 2);
      167 .. 176:
        Result := LeftStr(Result, 2);
      384, 387, 390, 393, 396, 399, 402:
        Result := LeftStr(Result, 2); // 20131231
    end; // case
  end;

  If (FormName = 'T1135') then
    Result := LeftStr(SelectedString, 3); // 20160227 Igor

  //20260817 Alex >>>
  if FormName = 'T106' then
  begin
    case FieldId of
     2, 67, 72: Result:= LeftStr(SelectedString, 3);
     35, 36, 37, 38: Result:= LeftStr(SelectedString, 6);
     60: Result:= LeftStr(SelectedString, 2);
    end;
  end;

  if ExtractNonInstFormName(FormName) = 'T106SL' then
  begin
    case FieldId of
     13:
       Result:= LeftStr(Result, 3);
     19, 20, 21, 22:
       Result:= LeftStr(Result, 6);
     24, 25, 26, 27:
       Result:= LeftStr(Result, 3);
     33, 121, 37, 41, 45, 49, 53, 57, 61, 65, 69, 73, 77, 81, 85, 89,
     35, 123, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91:
       Result:= LeftStr(Result, 1);
    end;
  end;
  //20260817 Alex <<<

  //20260115 Igor >>>
  if FormName = 'T1134' then
  begin
    FieldId:= GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
      40, 41, 42, 43, 20009, 20010, 20011, 20012, 30009, 30010, 30011, 30012, 40010, 40011, 40012, 40013: Result:= LeftStr(Result, 6);
      60003, 70001, 90004, 110001: ; //20230601 Igor do nothing
    else
      Result:= LeftStr(Result, 3);
    end;
  end;

  if ExtractNonInstFormName(FormName) = 'T1134S' then
  begin
    FieldId := GetFirstElmId(RetNo, FormNo, FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
      10001, 40001, 120001, 130001, 150001: Result:= Copy(Result, Pos(' - ', Result) + 3, Length(Result));
      20001, 30001, 50001, 60001, 70002, 80002, 90002, 100002, 110001, 140001, 160001: Result:= Copy(Result, 1, Pos(' - ', Result) - 1);
      40..43: Result:= LeftStr(Result, 6)
    else
      Result:= LeftStr(Result, 3);
    end;
  end;
  //20260115 Igor <<<

  // {limit the size of returned string}
  // Result := SelectedString;
  //
  //
  // //20160130
  // If FormName = 'T3' then If FieldId=81 then  //201
  // //If (LeftStr(FormName,7) = 'T3') then If FieldId=81 then
  // Begin
  // result := LeftStr(SelectedString,3);
  // If Not Numeric(result) then result:='';
  // end;
  //
  // If (LeftStr(FormName,7) = 'T3SUPL#') then
  // begin
  // If FieldId=29 then result := LeftStr(SelectedString,2);
  // If FieldId=3 then result := LeftStr(SelectedString,1);
  // If FieldId=4 then result := LeftStr(SelectedString,1);
  // If FieldId=61 then result := LeftStr(SelectedString,3);   //20120416
  // end;
  //
  // If FormName='T5013FIN' then
  // begin
  // Case FieldId of
  // 16,25,33,17,26,34:result := LeftStr(SelectedString,2);
  // end; // case;
  // end;
  //
  // If LeftStr(FormName,4)='PS9#' then
  // begin
  // result := LeftStr(SelectedString,3);  //country
  // end;
  //
  //
  // If (LeftStr(FormName,8) = 'ASSETSB#') then
  // begin
  // If (FieldId =215) or (FieldId =221) or (FieldId =227) then result := LeftStr(SelectedString,8);
  // If (FieldId =134) then result := LeftStr(SelectedString,4);
  // end;
  //
  // If (LeftStr(FormName,5) = 'PS50#') then
  // begin
  // If FieldId=14 then  result := LeftStr(SelectedString,1);
  // If FieldId=15 then  result := LeftStr(SelectedString,1);
  // If FieldId=22 then  result := LeftStr(SelectedString,2);
  // If FieldId=24 then  result := LeftStr(SelectedString,3);
  // If FieldId=47 then  result := LeftStr(SelectedString,2);
  // If FieldId=49 then  result := LeftStr(SelectedString,3);
  // end;
  //
  //
  // If (LeftStr(FormName,6) = 'AUTOS#') then
  // begin
  // If (FieldId =215) or (FieldId =221) or (FieldId =227) then result := LeftStr(SelectedString,8);
  // end;
  //
  // If (FormName = 'T5014') then Result := LeftStr(Result,4);
  //
  // If LeftStr(FormName,6) = 'T5015#' then
  // begin
  // Case FieldId of
  // 11,27,43,59,75,91,107,123,139,155:Result:=LeftStr(Result,1);
  // 12,28,44,60,76,92,108,124,140,156:Result:=LeftStr(Result,1);
  // else Result := LeftStr(Result,3);
  // end; //case
  // end;
  //
  //
  // If (ExtractNonInstFormName(FormName) = 'NR4DET') then
  // begin
  // case FieldId of
  // 2:Result:=LeftStr(Result,1);
  // 3:Result:=LeftStr(Result,3);
  // 7,12:Result:=LeftStr(Result,3);
  // 10,15:Result:=LeftStr(Result,1);
  // 25,32:Result:=LeftStr(Result,2);
  // 27,34:Result:=LeftStr(Result,3);
  // end; //case
  // end;
  //
  // If (ExtractNonInstFormName(FormName) = 'T5018L') then
  // begin
  // case FieldId of
  // 15:Result:=LeftStr(Result,3);
  // end; //case
  // end;
  //
  // If (ExtractNonInstFormName(FormName) = 'T5018S') then
  // begin
  // case FieldId of
  // 22:Result:=LeftStr(Result,3);
  // end; //case
  // end;
  //
  //
  // If (LeftStr(FormName,9) = 'T3INCOME#') and
  // (FieldId = 31) then
  // begin
  // result := AllTrim(LeftStr(SelectedString,30));
  // StoreElm(RetNo,FormNo,FieldId-27,AllTrim(MidStr(SelectedString,31,12)));
  // end;
  //
  //
  // If (LeftStr(FormName,9) = 'T5INCOME#') and
  // ((FieldId = 21) or (FieldId = 43) or (FieldId = 65) or (FieldId = 87) or
  // (FieldId = 109)) then
  // begin
  // result := AllTrim(LeftStr(SelectedString,20));
  // StoreElm(RetNo,FormNo,FieldId-17,AllTrim(MidStr(SelectedString,31,12)));
  // end;
  //
  //
  // If FormName = 'T5013SUM' then
  // begin
  // TempS:=result;
  // Result := LeftStr(Result,4);
  // Case FieldId of
  // 97,101,105,109,113,117,121,125,142, 146,82:
  // StoreElm(RetNo,FormNo,FieldId-1,MidStr(TempS,5,40));
  // end; //case
  // end;
  //
  // If (LeftStr(FormName,6) = 'T5013#')
  // //or (LeftStr(FormName,7) = 'T5013A#')
  // then Result := LeftStr(Result,1);
  //
  // If (LeftStr(FormName,5) = 'PS100') then Result := LeftStr(Result,4);
  // If (LeftStr(FormName,6) = 'PS125#') then Result := LeftStr(Result,4);
  // //If (FormName = 'POTHINFO') then Result := LeftStr(Result,4);
  //
  // If FormName = 'T5011' then Result := LeftStr(Result,3);
  //
  // If FormName = 'T106' then result:=LeftStr(Result,3);
  // If LeftStr(FormName,7) = 'T106SL#' then
  // begin
  // Case FieldId of
  // 13:Result := LeftStr(Result,2);
  // 19,20,21,22: result:=LeftStr(Result,3);
  // 24,25,26,27: result:=LeftStr(Result,3);
  // else Result := LeftStr(Result,1);
  // end; //case
  // end;
  //
  // If (LeftStr(FormName,4) = 'PS8#') then Result := LeftStr(Result,4);
  //
  //
  // If FormName = 'T3010' then  //20130225
  // begin
  // case FieldId of
  // 189,193,197,201,205:Result:=LeftStr(Result,2);
  // 153,156,159,162,165:Result:=LeftStr(Result,2);
  // 167..176:Result:=LeftStr(Result,2);
  // 384,387,390,393,396,399,402:Result:=LeftStr(Result,2);  //20131231
  // end;  //case
  // end;
end;

procedure TMyChildT3_2026.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: boolean);
begin
  exit;
end;

procedure TFormT3_2026.FormatEditBoxText(MyEditBox: TvtEdit; str: string);
begin
  inherited;
  MyEditBox.Font.Name := 'Arial Narrow'; // 20131225

  If FormName = 'T3' then // 20130218
  begin
    If MyEditBox.FieldId = 2 then
      MyEditBox.text := FormatT3Account(RetNo, FetchElm(RetNo, 'T3', 2));
    // 20130218
  end;

end;

Procedure TFormT3_2026.FormatDollar(MyEditBox: TvtEdit; str: string);
var
  HowToFormat: Integer;
begin
  FormatSettings.DecimalSeparator := '.'; // 20150805 Igor
  If Vl(str) = 0 then
    MyEditBox.text := '' // 20160808 Igor
    // MyEditBox.Text:='0'   //20130421
  else
  begin
    HowToFormat := GetHowToFormat(FormName, MyEditBox.FieldId);
    MyEditBox.text := FormatAmount(FormName, str, HowToFormat);
  end;
  MyEditBox.Modified := True;
end;

Procedure TFormT3_2026.ShowFieldData(MyEditBox: TvtEdit);
Var
  Fld: Integer;
  // R:TRect;FormattedAmount:string; //[15];ErrMsg:String;
  // EditBoxColr:TColor;
Begin
  inherited;
  If GetFormType(FormName) = 'T3' then
  begin
    If Vl(FetchElm(RetNo, 'T3', 201)) > 999999 then
      MyEditBox.Font.size := 8; // 20090220
  end;

  If FormName = 'T3' then // 20130218
  begin
    Fld := GetFieldId(MyEditBox.Name);
    If Fld = 2 then
      MyEditBox.text := FormatT3Account(RetNo, FetchElm(RetNo, 'T3', 2));
    // 20130218
  end;
end;

procedure TFormT3_2026.EditBoxMouseDown(MyEditBox: TvtEdit;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  FieldId: Integer;
  vis: boolean;
begin
  If Button = mbLeft then
  begin
    inherited;
  End // MbLeft
  else If Button = mbRight then
  begin
    // set right click focus - john 20090521
    MyEditBox.setfocus;
    MyEditBox.Refresh;
    FieldId := MyEditBox.FieldId;

    with MainFormT3 do
    begin
      // configure menu
      vis := FieldId > 9999;
      AddRow1.Visible := vis;
      DeleteRow1.Visible := vis; // SomeList.Add('Delete Row');
      DeleteRow2.Visible := vis; // SomeList.Add('------------------------');
      // show menu
      FieldPopup.PopupComponent := MyEditBox;
      // pos must be in screen coordinates
      FieldPopup.Popup(mouse.CursorPos.X, mouse.CursorPos.Y);
    end; // with
  end; { mbright }
end;

// keep!
Function AskingForSICCode(FormName: String; FieldId: Integer): boolean;
begin
  Result := False;
  If ((ExtractNonInstFormName(FormName) = 'T2125') and (FieldId = 12)) or
    ((ExtractNonInstFormName(FormName) = 'T2032_1') and (FieldId = 15)) or
    ((ExtractNonInstFormName(FormName) = 'T2121') and (FieldId = 11)) or
    ((ExtractNonInstFormName(FormName) = 'T2042') and (FieldId = 17)) or
    ((ExtractNonInstFormName(FormName) = 'NISAA_1') and (FieldId = 34)) or
    ((ExtractNonInstFormName(FormName) = 'T1273_1') and (FieldId = 34)) or
    ((ExtractNonInstFormName(FormName) = 'T5011') and (FieldId = 2)) then
    Result := True;
end;

procedure TFormT3_2026.OnVtEditDblClick(MyEditBox: TvtEdit);
Var
  i: Integer;
  FName: string;
  NewString: String;
  FieldId, TargetLinkedField: Integer;
  P: TWinControl; // 20160805 Igor
begin
  FieldId := MyEditBox.FieldId;

  // 20160710 Igor
  if MyEditBox.ReadOnly then
    exit;
  if not assigned(RetList[RetNo]) then
    exit;
  if RetList[RetNo].IsLastYearReturn or RetList[RetNo].isAppendix then
    exit;

  if MyEditBox.vtDataSource = vtLinked then
  begin
    FName := GetLinkedForm(FieldId, TargetLinkedField);
    // 20170628 Igor >>>
    // if linkToSelf(FormName,FName)then
    // ShowTimedMsg('Hit the Spacebar to link',1200)
    // else
    // 20170628 Iogr <<<
    If FName > '' then
      OpenForm(RetNo, GetFormNo(FName), TargetLinkedField);
    exit;
  end;

  if MyEditBox.vtDataSource = vtPopupList then // pick boxes
  begin
    If AskingForSICCode(FormName, FieldId) then
      GetSICCode(FieldId)
    else
      GetValueFromList(MyEditBox, FieldId);
    // GetValueFromList(MyEditBox,FormName,FieldId);
    // GetValueFromPopUp(MyScrollBox,MyEditBox,FormName,FieldId);
    If SelectedString > '' then
    begin
      If IsReturnLocked(RetNo) = False then
      Begin
        ChangeEditBoxText(MyEditBox, SelectedString);
        // SaveEditBoxText(FormNo,FieldId,MyEditBox.Text);
        // 20160805 Igor >>>
        UpdateAfterSave;
        P := self.Parent;
        while assigned(P) AND not(P is TForm) do
          P := P.Parent;
        if assigned(P) then
          PostMessage(P.Handle, WM_NEXTDLGCTL, 0, 0)
        else
          PostMessage(self.Handle, WM_NEXTDLGCTL, 0, 0)
          // 20160805 Igor <<<
      end
      Else
        ShowTimedMsg('Changes not allowed. Return is locked', 1500);
      exit;
    end;
  End;
end;

Procedure TFormT3_2026.DataChangeRtn;
begin
  Ret[RetNo].Changed := True;
  { save instance data }
  Calc(RetNo, FormName); // 20150729  //Calc(Retno,FormName,FormNo);
  CalcFullT3(RetNo); // 20180319

  CalcAffectedBy(RetNo, FormName);
  If IsFormMultipage(FormName) then
    CalcMultiPageForm(RetNo, FormName);

  If ToolBarSw then
  begin
    CalcAll(RetNo); // it does not work?  //20180319
    Ret[RetNo].CalcStatus := True;
  end
  Else
    Ret[RetNo].CalcStatus := False;
end;

Function GetReturnCaption(RetNo: Integer): String;
Var
  YrPrefix: String;
  RetName: String;
begin
  YrPrefix := '';
  RetName := GetRetName(RetNo);
  If RetName = '' then
    RetName := 'Un-named';
  // Result:=PaddR(PaddZero(IntToStr(RetNo),2),2)+' '+YrPrefix+' '+CorpName;
  Result := PaddR(PaddZero(IntToStr(RetNo), 2), 2) + ' ' + RetName;
  // +' Y/E: '+IntToStr(GetTaxationYearEndYYYY(RetNo));
end;

procedure TFormT3_2026.ShowRichData(ARichEdit: TRichEdit; Fld: Integer);
// Procedure TMyChildT3_2026.ShowInterpretedRichData(ARichEdit:TRichEdit;FName:String;FNo:Integer);
Var
  i: Integer;
  LetterName: String;
  AImage: TImage;
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

procedure TFormT3_2026.GetSICCode(FieldId: Integer);
begin
  If AskingForSICCode(FormName, FieldId) then
  begin
    MainFormT3.NAICSCodes1Click(Application);
    If Numeric(SelectedString) then
      ReplaceString(FieldId, SelectedString);
    exit;
  end;
end;

Function SubstituteLastYearForm(FName: String): String; // 20160629 Igor
Begin
  Result := GetRenamedFName(FName);
  if Result = '' then
    Result := FName;
end;

//20260817 Alex >>>
function TFormT3_2026.PrivacyAgreementAccepted(ForEfileFormName: string): Boolean;
var
  i: Integer;
  PAdlgBox: TPrivacyAgreementT3_2026;
  doNotShowPrivacyAgreement: TStringList;
begin
  Result:= true;

  if FileExists(PrivacyAgreementDoNotShowPathandFileName) then
  begin
    doNotShowPrivacyAgreement:= TStringList.Create;
    doNotShowPrivacyAgreement.LoadFromFile(PrivacyAgreementDoNotShowPathandFileName);

    for i:= 0 to pred(doNotShowPrivacyAgreement.Count) do
      if doNotShowPrivacyAgreement[i] = ForEfileFormName then Exit;

    doNotShowPrivacyAgreement.Free;
  end;

  PAdlgBox:= TPrivacyAgreementT3_2026.Create(Self);
  try
    //from example: Populate dialog//dlg.eFont.Text := lblCaption.Font.Name;//dlg.eSize.Text := lblCaption.Font.Size.ToString;//dlg.cbBold.Checked := fsBold in lblCaption.Font.Style;    //dlg.cbItalic.Checked := fsItalic in lblCaption.Font.Style;
    //dlg.headerPanel.Caption := 'T106' + dlg.headerPanel.Caption
    PAdlgBox.formHeaderLbl.Caption:= ForEfileFormName;
    if PAdlgBox.ShowModal <> mrOk then
    begin
        //from example: Apply settings from dialog//lblCaption.Font.Name := dlg.eFont.Text;//lblCaption.Font.Size := StrToInt(dlg.eSize.Text);//if dlg.cbBold.Checked then//lblCaption.Font.Style := lblCaption.Font.Style + [fsBold]//else//lblCaption.Font.Style := lblCaption.Font.Style - [fsBold];//if dlg.cbItalic.Checked then//lblCaption.Font.Style := lblCaption.Font.Style + [fsItalic]//else//lblCaption.Font.Style := lblCaption.Font.Style - [fsItalic];
        Result:= False;
    end;
  finally
    PAdlgBox.Free;
  end;
end;
//20260817 Alex <<<

end.
