unit T2_2027ChildWinNew;
(* see vtChild for documentation

version:  2014-07-29
*)

interface

uses SysUtils,WinTypes,WinProcs,Classes,Graphics,Forms,Controls,TabNotBk,
  StdCtrls,ExtCtrls,Tabs,Menus,Grids,Dialogs,ColorGrd,ClipBrd,Gauges,Mask,
  DBCtrls,Printers,Messages,shellApi,ComCtrls,Buttons,vtEditBox,vtLabel,vtForm,
  vtShape,vtMemoBox,T2_2027HeaderFrame,T2_2027MonitorFrame,vtMulti,vtChild,
  vtControlIntf, //20170409 Igor
  rxRichEd; //20160819 Igor (Must be last)

type
  TFormT2_2027 = class(TvtScrollBox, IvtForm) //20170409 Igor
  private
    function CleanUpPickedListValue(FieldId: Integer; SelectedString: String): string;
    //20170409 Igor >>>
    procedure ConditionCalc(AIdentificator: String; var AValue: Boolean); overload;
    procedure ConditionCalc(AIdentificator: String; var AValue: Integer); overload;
    procedure ConditionCalc(AIdentificator: String; var AValue: String); overload;
    procedure ConditionCalc(AIdentificator: String; var AValue: Real); overload;
    procedure EditButtonClick(AEdit: TObject; AAction: TEditButtonAction;
      AEdit2: TObject = nil); //20170411 Igor
    //20170409 Igor <<<
    //20170411 Igor >>>
    function SameTable(AField1, AField2: Integer): Boolean; override;
    function SameColumn(AField1, AField2: Integer): Boolean; override;
    function isLastRow(AFieldID: Integer): Boolean; override;
    //20170411 Igor <<<

  protected //override!
    procedure DataChangeRtn; override;
    procedure FormatDollar(MyEditBox: TvtEdit; str: string); override;
    function GetLinkedForm(FieldId: Integer; var TargetLinkedField: Integer): String; override;
    function IsProtectedField(MyEditBox: TvtEdit): boolean; override;
    function ValidateField(FieldId: integer; OldValue: string; var Value: string): boolean; override; //20260704 Alex

    //Procedure PopulateFormWithData(MyScrollBox:TvtScrollBox); override;
    Procedure ShowRichData(ARichEdit:TRichEdit;Fld:Integer); override;
    //Procedure ShowFormData(FName:String;FNo:Integer); override;
    procedure ShowOther(cmp: TComponent); override;
    //Procedure ShowInterpretedRichData(ARichEdit:TwwDbRichEdit;FName:String;FNo:Integer);

    Function PrivacyAgreementAccepted(ForEfileFormName:string):boolean; //jz 20250108

    function PopulatePickList(FieldId: Integer): String;  //20150806
    Function PopulateIrregularPickList(ebox:TvtEdit;FieldId:Integer;SomeList:TStringList):Boolean;
    Function GetValueFromList(MyEditBox:TvtEdit; FieldId:Integer):String; override;
    function GetisDraft: Boolean; override; //20161212 Igor
  protected //Form handlers
    procedure FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState); //virtual;
    procedure FormKeyPress(ActiveControl: TControl; var Key: Char); override;
    procedure FormButtonClick(Sender: TObject); override;
  public //vtEdit
    procedure EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    //procedure OnExitField(MyEditBox: TvtEdit); override;
    //procedure OnEnterField(MyEditBox: TvtEdit); override;
    procedure OnVtEditDblClick(MyEditBox:TvtEdit); override;
    procedure AfterOpenForm(ADestination: TvtDestination = vtdDisplay); override;//20160518 Igor
  end;

  TMyChildT2_2027 = class(TMyChild)
  private

  public
    procedure CloseActiveForm(Sender: TObject); override;
    procedure FormKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure SpeedButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FMyFormHeaderFrame: THeaderFrameT2_2027;
    FMyMonitorFrame: TMonitorFrameT2_2027;
   Procedure ChildMsgHandler(var Msg: TMsg; Var Handled:Boolean);
    procedure SectionBtnClick(Sender: TObject);
  protected
    procedure AddPropertiesAndEvents(); override;
    function GetHeaderFrame: TFrame; override; //20160227 Igor
    function GetMonitorFrame: TFrame; override; //20160227 Igor
  private //unused
    MyChild: boolean; //force errors on reference!
  protected
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    //procedure FormKeyPress(Sender: TObject; var Key: Char); override;
    Procedure Keys(Var Key: Word; Shift: TShiftState); override;
  public
    constructor CreateNew(AOwner: TComponent; RNo: Integer); override;
    procedure SetColor(clr: TColor); override;
    procedure UpdateChildTaxPanel; override;
    Procedure UpdateFormHeaderFrame; override;
    property MyFormHeaderFrame:THeaderFrameT2_2027 read FMyFormHeaderFrame;
    property MyMonitorFrame: TMonitorFrameT2_2027 read FMyMonitorFrame;
  end;

//known to all

Function InDateOnly(Value:string;MnYear,MxYear:integer):Boolean;
Function InDateYYYYMMDDonly(Value:string;MxYear:integer):Boolean;
Function InYYYYMMOnly(Value:string;MnYear,MxYear:integer):Boolean;


//really used
Function GetDFMFileName(FName:String):String;
Function GetLastYearDFMFileName(FName:String):String; //20160321 Igor
Function GetReturnCaption(RetNo:Integer):String;
Function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;

Function SubstituteLastYearForm(FName: String): String; //20160424 Igor

var
  RetNo: boolean; //force compilation errors

   //jz 20240707
  functionalCurrency_N : array[0..4] of string =
    ('01(USD = US Dollar)','02(GBP = GB Pound Sterling)','03(AUD = AU Dollar)','04(EUR = Euro)','05(JPY = Yen)');
  //jz 20240424
  //functionalCurrency : array[0..4] of string =
  //  ('USD = US Dollar', 'GBP = GB Pound Sterling', 'AUD = AU Dollar', 'EUR = Euro', 'JPY = Japanese Yen');

implementation

uses vtMain,vtDialogs,vtCommon,vtDynData,T2_2027,T2_2027main,T2_2027Print,
  {T2_2027GifiBSEdit,T2_2027GifiISEdit,}T2_2027Declare,T2_2027Common,
  T2_2027Common2,T2_2027TrimStr,T2_2027Calc,fPopList,T2_2027SaveAs,
  T2_2027CntErr,T2_2027SearchList,T2_2027Sic,vtTrimStr,vtShared,
  T2_2027T1135Efile, //20160523 Igor
  T2_2027T106Efile,  //20170728

  T2_2027PrivacyAgreement, //jz 20250108

  T2_2027EFILECONSENT,  //20200215
  T2_2027EFILERC59,  //20180504 CON
  T2_2027EFILERC59X,  //20180801 CON
  T2_2027EFILECBC,  //20180608 CON
  T2_2027SERS, //20240722 Igor
  T2_2027EfileT1134; //20180703 Igor
var
 KeyStrokes:String;

{.$R *.DFM}

Procedure TMyChildT2_2027.ChildMsgHandler(var Msg: TMsg; Var Handled:Boolean);
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

procedure TMyChildT2_2027.addPropertiesAndEvents();
begin
  inherited;
 VertScrollBar.Tracking := True;
 HorzScrollBar.Tracking := True;
 VertScrollBar.Position:=0;
 //OnCloseQuery := FormCloseQuery;
 //OnClose := FormClose;
 //OnClick := FormClick;
 //OnActivate := FormActivate;
 KeyPreview:=True;
 OnKeyDown := FormKeyDown;
 OnKeyUp := FormKeyUp;
 OnKeyPress := FormKeyPress;
//install for use by vtScrollBox
  PopupMenu := MainFormT2.FormPopup;
  OnContextPopup := FormContextPopup;
end;


(*
Function OpenForm(RetNo: Integer;FNo: integer;Elm:Integer): boolean;
 has been split into BeforeOpenForm and AfterOpenForm.
*)
Function BeforeOpenForm(RetNo: Integer;var FName: string; var FNo: integer): string;
//Function BeforeOpenForm(RetNo: Integer;const FName: string): boolean;
//Function OpenForm(RetNo: Integer;FNo: integer;Elm:Integer): boolean;
Var i,j,startPos,ActiveNdx:Integer;hwnd : Thandle; //FName : String;
  TheEnterKey:Char;
  DfmFileName:String absolute Result;
  FullFlname:String;
  FormsDir:String;
  ElmName:String;
begin
  if IsEnterpriseForm(FName) then  //and (ret[RetNo].FrmHasData[Fname])
  Begin//ok
   If (LicenseLevel=LLEnterprise)
   then
   //ok users need to have enreprise license level or know our efile psw
   Else
   Begin
    Showmessage('This Form ' + Fname +' is available only on the Enterprise version of the program'); //20251114
    If (UpperCase(InputBox('Input Box', 'PSW', ''))<>'B0865') then Exit;
   end;
  End;

(*
 //20241130
 //==============================
 if (GetFormType(Fname)='EL') or (IsEnterpriseForm(FName))
 then     //serrs Election fors
 Begin
  if (LicenseLevel=LLEnterprise) then  //and (ret[RetNo].FrmHasData[Fname])
  //ok
  Else
  Begin
   Showmessage('This Form ' + Fname +' is available only on the Enterprise version of the program'); //20251114
   If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit; //20211210
  end;
 End;

 //addon schedules uht, s150, s151,  ??.
 //20251101
 if (UpperCase(LeftStr(Fname,6))='S150')
 or (UpperCase(LeftStr(Fname,6))='S151')
 then
 BEGIN
  If (LicenseLevel=LLEnterprise) then
  //ok
  else
  Begin
    Showmessage('This form is available only on the Enterprise version of the program');   //20251114
    If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit; //20211210
  End;
 End;

 //20250109


 if (UpperCase(LeftStr(Fname,6))='SALDIV') then
 BEGIN
  If (LicenseLevel=LLEnterprise) then
  //ok
  else
  Begin
    Showmessage('Salary/Dividend analysis is available only on the Enterprise version of the program');
    If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit; //20211210
  End;
 End;

 if (UpperCase(LeftStr(Fname,6))='SBDALLOC')then
 Begin
  If (LicenseLevel=LLEnterprise) then
  //ok
  else
  Begin
    Showmessage('SBD allocation is available only on the Enterprise version of the program');
    If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'B0865' then exit; //20211210
  End;  //(ValidADDONFeaturesKey=False) then  Exit; //20200901
 End;
*)
 //=========================================================

 (* Perform checks before opening a form.
  The form can be opened in something different from a ChildWin!
*)
  Result := '';
  //If (RetNo < 1) or (RetNo > ReturnsLimit) then begin result:=false; exit;end;

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
//  FNo := GetFormNo(FName);
//20160704 Igor <<<
  If FNo = 0 then begin
   ShowMessage('Form No '+IntToStr(FNo)+' not found');
   exit;
  end;

  (* 20130608
  If LeftStr(GetFormName(FNo),3) = 'MCT' then
  begin
    if LicenseLevel in [llDemo..llStd] then
    begin
      ShowMessage('The MCT is available only in the Power version of the T2 program');
      Exit;
    end;
  end;
  *)

  {20151010
  If LeftStr(GetFormName(FNo),6) = 'GIFIBS' then
  begin
   ExecuteForm(TGifiBSEditT2_2027);
   exit;
  end;

  If LeftStr(GetFormName(FNo),6) = 'GIFIIS' then
  begin
   ExecuteForm(TGifiISEditT2_2027);
   Exit;
  end;
 }
//Try
  //FName:=GetFormName(FNo);
  //20160704 Igor >>>
  If ShowUnconvertedLastYear(RetNo) = False then
    DfmFileName:=GetDfmFileName(FName)
  else
    DfmFileName:=GetLastYearDfmFileName(FName);
//  DfmFileName:=GetDfmFileName(FName);
//20160704 Igor <<<
  If FileExists(DfmFileName) = False then
  begin
   //ShowMessage('Form '+FName+' not found'); //0250527
   Result := '';
   Exit;
  End;
  If LeftStr(FName,1)='O' then
  begin
    If Ret[RetNo].OntCalcStatus = false then CALCONT(RetNo);
  end;

  If LeftStr(FName,1)='A' then
  begin
    If Ret[RetNo].AlbCalcStatus = false then CALCALB(RetNo);
  end;

  If Ret[RetNo].Frm[FNo].count =0 then InitFormData(RetNo,FNo);
end;

procedure TFormT2_2027.ShowOther(cmp: TComponent);
var
  MyLabel: TvtLabel absolute cmp;
  AnImage:TImage;s:String;
begin
  if cmp is TvtLabel then
  begin
    if MyLabel.vtCraCertifCode then
      MyLabel.Caption := 'Version '+RsiVersion+ '  '+RSIApprovalCode; //20161217 //RSIApprovalCode;
  end;

 if cmp is TImage then //20120325
  begin
      AnImage:=cmp as TImage;
      If (UpperCase(AnImage.Name)='E_SIGNATUREHOLDER') then  //20200326
      Begin
        if UpperCase(FetchElm(RetNo,'T2',270))<>'Y' then
        AnImage.Picture:=Nil
       Else
       Begin
       s:=GetSignatureFilePath(RetNo);
       If s>'' then AnImage.Picture.LoadFromFile(s);
       End;
      //AnImage.Stretch:=True;
      End;
  end;

end;

procedure TFormT2_2027.FormButtonClick(Sender: TObject);
Var i:Integer;Nm:String;
  k:Integer;FNo:Integer;
  lUserResponse: Integer; // 20250709 Igor
const
  c_Element_TESTFRM_T1Folder = 6;
  c_Element_TESTFRM_T1File = 7;
  c_Element_TESTFRM_T1RetNo = 5;
  c_Element_TESTFRM_T1FirstName = 8;
  c_Element_TESTFRM_T1LastName = 9;
  c_Element_TESTFRM_T1RefundBalance = 11;
  c_Element_TESTFRM_Salary = 10;

  c_Element_T1INFO_FirstName = 5;
  c_Element_T1INFO_LastName = 2;
  c_Element_T1T1_Refund = 429;
  c_Element_T1T41_2 = 303; //for example...

  procedure PrepareForeignreturn(var AFormData: TFormData);
  var
    T1Folder: String;
    T1File: String;
  begin
    T1Folder := FetchElm(GetCurrentRetNo, 'TESTFRM', c_Element_TESTFRM_T1Folder);
    T1File := FetchElm(GetCurrentRetNo, 'TESTFRM', c_Element_TESTFRM_T1File);
    if T1Folder.IsEmpty then
    begin
      T1Folder := AppList.AppFromName('T1').Dir_Deflt;
      if not T1Folder.IsEmpty then
        StoreElm(GetCurrentRetNo, 'TESTFRM', c_Element_TESTFRM_T1Folder, T1Folder);
    end;

    if T1Folder.IsEmpty or not SysUtils.DirectoryExists(T1Folder) or
       T1File.IsEmpty or not FileExists(IncludeTrailingPathDelimiter(T1Folder) + T1File) then
      Exit;

    AFormData := vtCommon.GetForeignForm('T1', T1Folder, T1File, 'TAXSUM', omHidden);
  end;

  procedure Test_OpenT1Click;
  var
    T2RetNo: Integer;
    T1RetNo: Integer;
    FD: TFormData;

    T1FirstName, T1LastName: String;
    T1Refund: Currency;

  begin
    T2RetNo := GetCurrentRetNo;
    PrepareForeignreturn(FD);
    if Assigned(FD) then
    begin
      T1RetNo := FD.RetNo;
      StoreElm(T2RetNo, 'TESTFRM', c_Element_TESTFRM_T1RetNo, IntToStr(T1RetNo));

      T1FirstName := FetchElm(T1RetNo, 'INFO', c_Element_T1INFO_LastName);
      T1LastName := FetchElm(T1RetNo, 'INFO', c_Element_T1INFO_FirstName);

      T1Refund := VL(FetchElm(T1RetNo, 'T1', c_Element_T1T1_Refund));

      StoreElm(T2RetNo, 'TESTFRM', c_Element_TESTFRM_T1FirstName, T1FirstName);
      StoreElm(T2RetNo, 'TESTFRM', c_Element_TESTFRM_T1LastName, T1LastName);
      StoreElm(T2RetNo, 'TESTFRM', c_Element_TESTFRM_T1RefundBalance, FormatFloat('0.00',T1Refund));


      PopulateFormWithData;
    end;
  end;

  procedure Test_CalcBtnClick;
  var
    T2RetNo: Integer;
    T1RetNo: Integer;
    FD: TFormData;

    T1FirstName, T1LastName: String;
    T1Refund, T1Balance: Currency;

    T2Salary: String;
  begin
    T2RetNo := GetCurrentRetNo;
    T2Salary := FetchElm(T2RetNo, 'TESTFRM', 14);
    StoreElm(RetNo,'S125#1', GifiLineToElm(RetNo, GetFormNo('S125#1'), '8960'), T2Salary);
    CalcFed(T2RetNo);
    CalcAlb(T2RetNo);
    PopulateFormWithData;
  end;

  // 20250826 Igor >>>
  procedure CertificationButtonClick(aValueFieldId: Integer; aFieldValue: string);
  begin
    StoreElm(RetNo, GetFormNo(FormName), aValueFieldId, aFieldValue);
    OpenForm(RetNo, FormName, aValueFieldId);
  end;
  // 20250826 Igor <<<

// 20250711 Igor >>>
var
  lTaxVal: string;
  lTaxPaymentVal: string;
  lDlg: TForm;
  lBtnYes, lBtnNo: TButton;
// 20250711 Igor <<<
begin
 Nm:=UpperCase((Sender as TbitBtn).Name);  //button name

 If Nm='E_SIGNATUREHELPBTN' then  //20200322
 begin
   ConnectToWeb('https://www.visualtax.com/e-signature.php'); //20200325  //20211030 lower case
 end;

  If LeftStr(FormName, 4) = 'UHT#' then // 20240406
  begin
    If (Nm = 'UHTIBTN') then
    begin
       ShowPdf(AppDir, 'UHTI.pdf'); // 20150115
      exit;
    end;
  end;

 (* //20260813CZ  removed not effective
 Begin
 If (LeftStr(FormName,5)='AS13#') then //20260813CZ
 Begin
  if Nm='RECALCALBBTN' then
  Begin
    CalcALB(RetNo);
    Exit;
  end;
 end;
 *)


 If (FormName='AS29') then //or (FormName='AS29L') then  //20240621
 Begin
  if Nm='AS29BTN' then   //help  //20251123
  Begin
    ConnectToWeb('https://www.alberta.ca/system/files/custom_downloaded_images/tra-guide-claiming-the-innovation-employment-grant.pdf');
    Exit;
  end;

  If Nm='ABSTEP1BTN' then    //20200726
  begin
    StoreElm(RetNo,GetFormNo(FormName),146,'X');
    StoreElm(RetNo,GetFormNo(FormName),147,'');
    StoreElm(RetNo,GetFormNo(FormName),248,'');
    Calc(RetNo, 'AS29');
    OpenForm(RetNo,'AS29',4);
    Exit;
  end;

  If Nm='ABSTEP2BTN' then    //2020620
  begin
    StoreElm(RetNo,GetFormNo(FormName),146,'');
    StoreElm(RetNo,GetFormNo(FormName),147,'X'); //shows the active step
    StoreElm(RetNo,GetFormNo(FormName),248,'');
    Calc(RetNo, 'AS29');
    OpenForm(RetNo,'AS29',4);
    Exit;
  end;


  {//20260703
  If Nm='ABSTEP3BTN' then    //20260620
  begin
    StoreElm(RetNo,GetFormNo(FormName),146,'');
    StoreElm(RetNo,GetFormNo(FormName),147,'');
    StoreElm(RetNo,GetFormNo(FormName),248,'X');
    Calc(RetNo, 'AS29');
    OpenForm(RetNo,'AS29',4);
    Exit;
  end;
  }
 End;  //as29

 If FormName='SBDALLOC' then
 begin
  If Nm='RECALCALLRELATEDBTN' then    //20200726
  begin
    CalcAllSbdAllocCompanies(RetNo);
    OpenForm(RetNo,'SBDALLOC',321);
    Exit;
  end;
 End;

 If LeftStr(FormName,4)='UHT#' then      //20231020
 begin
    If (Nm = 'UHT2900BTN') Or (Nm='UHT2900BTN') then
    begin
       ShowPdf(AppDir, 'UHT2900I.pdf'); // 20150115
      exit;
    end;
  end;


 If FormName='SALDIVSET' then
 Begin
  If Nm='T1CLIENTBOOKBTN' then Begin OpenT1ClientBook;Exit; end; //20200919
  If Nm='SINGLESALDIVOPTIONBTN' then    //20200908
  Begin
    if ValidADDONFeaturesKey=false then Exit;
    if Vl(FetchElm(RetNo,'SALDIVSET',7))=0 then  //20201212
    Begin
     ShowMessage('Please enter Compensation Amount on Column (C) first');
     Exit;
    end;

    If FetchElmFno(RetNo,GetFormNo('SALDIVSET'),49)>'' then
        StoreElm(RetNo,GetFormNo('SALDIVSET'),46,'1')
     Else
        StoreElm(RetNo,GetFormNo('SALDIVSET'),48,'1');
     OpenT1ReturnsForSalDiv(RetNo);
  End;
  If Nm='MULTIPLESALDIVOPTIONBTN' then    //20200908
  Begin
     if ValidADDONFeaturesKey=false then Exit;
     if Vl(FetchElm(RetNo,'SALDIVSET',7))=0 then  //20201212
     Begin
      ShowMessage('Please enter Compensation Amount on Column (C) first');
      Exit;
     end;
     If FetchElmFno(RetNo,GetFormNo('SALDIVSET'),49)>'' then
       StoreElm(RetNo,GetFormNo('SALDIVSET'),46,GetSalDivMultipleCombinationsString(RetNo)) //store Number of combinations option A
     Else
       StoreElmFNo(RetNo,GetFormNo('SALDIVSET'),48,GetSalDivMultipleCombinationsString(RetNo)); //store Number of combinations option B
     OpenT1ReturnsForSalDiv(RetNo);
  End;
  If Nm='EXITSALDIVBTN' then    //20200818
   begin
    SalDivMode:=False;
    CloseAllSalDivT1Returns;
    RetList[RetNo].Close(True);
   end;
 end;

 if (FormName='SALDIV')  //20201212
 or (LeftStr(FormName,7)='SALDIV#')
 Or (LeftStr(FormName,8)='SALDIVM#')  then  //20200930
 Begin
   If Nm='REVISESALDIVSETBTN' then
   begin
     OpenForm(RetNo,'SALDIVSET',31); //Open the first one //20200807
     Exit;
   end;
   If Nm='EXITSALDIVBTN' then    //20200818
   begin
    SalDivMode:=False;
    CloseAllSalDivT1Returns;
    RetList[RetNo].Close(True);
   end;
 end;

 //20201204
 If LeftStr(FormName,8)='CONSENT#' then
 Begin
  If Nm='ACONSENTBTN' then OpenForm(RetNo,GetFormNo('ACONSENT'),1);
 end;


 //20201204
 If FormName='AT1013' then
 Begin
  If Nm='ACONSENTBTN' then OpenForm(RetNo,GetFormNo('ACONSENT'),1);
 end;


 //20171118
 If FormName='AS14' then
 Begin
  If Nm='AS14WSBTN' then OpenForm(RetNo,GetFormNo('AS14WS'),1);
 end;

 //20190311
 If LeftStr(FormName,3)='S8#' then
 Begin
  If      Nm='AIIPBTN'              then  GetAiipHelp
  else if Nm='S8NOTESBTN'    then ShowPdf(AppDir,'s8i.pdf') //20260713
  else if Nm='CCAGUIDEBTN'    then  //20260713
  Begin
   ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/sole-proprietorships-partnerships/report-business-income-expenses/claiming-capital-cost-allowance/classes.html');
  end;
 end;

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

   Application.CreateForm(TT106EfileT2_2027,T106Efile);
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

 //20160522
 If FormName='T1135' then   //20140227
 begin
  If (Nm='T1135EFILEBTN')
  or (Nm='T1135EFILEBTN2')  //20160711
  then  //20140101 //20160523 Igor
  begin
   //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20211210
   Application.CreateForm(TT1135EfileT2_2027,T1135Efile);
   T1135Efile.ShowModal;
   T1135Efile.Free;
   OpenForm(RetNo,GetFormNo('T1135'),0);
  end;
  If Nm='T1135FILLBTN' then ConnectToWeb('http://www.cra-arc.gc.ca/E/pbg/tf/t1135/t1135-fill-15e.pdf');  //20160123
  If Nm='T1135I' then ShowPdf(AppDir,'t1135i.pdf');
 end;

 //20250826 Igor >>>
 if FormName = 'T217' then
 begin
   if (Nm='CERTBTN1') or (Nm='CERTBTN2') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(22, '1');
       if (Nm='CERTBTN2') then CertificationButtonClick(21, '1');
     end else
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(22, '2');
       if (Nm='CERTBTN2') then CertificationButtonClick(21, '2');
     end;
   end;
 end;

 if FormName = 'T2054' then
 begin
   if (Nm='CERTBTN') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
       CertificationButtonClick(17, '1')
     else
       CertificationButtonClick(17, '2');
   end;
 end;

 if LeftStr(FormName, 5) = 'T2057' then
 begin
  if (Nm='CERTBTN1') or (Nm='CERTBTN2') then
  begin
    lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
    if lUserResponse = mrYes then
    begin
      if (Nm='CERTBTN1') then CertificationButtonClick(8, '1');
      if (Nm='CERTBTN2') then CertificationButtonClick(60, '1');
    end else
    begin
      if (Nm='CERTBTN1') then CertificationButtonClick(8, '2');
      if (Nm='CERTBTN2') then CertificationButtonClick(60, '2');
    end;
  end;
 end;

 if FormName = 'T2058' then
 begin
   if (Nm='CERTBTN1') or (Nm='CERTBTN2') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(60, '1');
       if (Nm='CERTBTN2') then CertificationButtonClick(61, '1');
     end else
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(60, '2');
       if (Nm='CERTBTN2') then CertificationButtonClick(61, '2');
     end;
   end;
 end;

 if FormName = 'T2059' then
 begin
   if (Nm='CERTBTN1') or (Nm='CERTBTN2') or (Nm='CERTBTN3') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(38, '1');
       if (Nm='CERTBTN2') then CertificationButtonClick(43, '1');
       if (Nm='CERTBTN3') then CertificationButtonClick(51, '1');
     end else
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(38, '2');
       if (Nm='CERTBTN2') then CertificationButtonClick(43, '2');
       if (Nm='CERTBTN3') then CertificationButtonClick(51, '2');
     end;
   end;
 end;

 if LeftStr(FormName, 4) = 'UHT#' then
 begin
   if (Nm='CERTBTN') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
       CertificationButtonClick(45, '1')
     else
       CertificationButtonClick(45, '2');
   end;
 end;

 if FormName = 'T2311' then
 begin
   if (Nm='CERTBTN1') or (Nm='CERTBTN2') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(57, '1');
       if (Nm='CERTBTN2') then CertificationButtonClick(58, '1');
     end else
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(57, '2');
       if (Nm='CERTBTN2') then CertificationButtonClick(58, '2');
     end;
   end;

   If (Nm='EFILEBTN') then
   begin
     lTaxVal:= FetchElmFno(RetNo, GetFormNo(FormName), 54);
     lTaxPaymentVal:= FetchElmFno(RetNo, GetFormNo(FormName), 55);

     if (lTaxPaymentVal < lTaxVal) then
     begin
       lDlg:= CreateMessageDialog(
                'Please confirm that you will be making a payment within 5 days of submission.',
                mtConfirmation,
                [mbYes, mbNo]
              );
       try
         lDlg.Caption:= 'Payment required';
         lBtnYes:= lDlg.FindComponent('Yes') as TButton;
         lBtnNo:= lDlg.FindComponent('No') as TButton;

         if Assigned(lBtnNo) then lBtnNo.Caption:= 'No (Not sure)';

         if lDlg.ShowModal = mrYes then
         begin
           RunSERS(FormName);
         end else
           ShowMessage('Certain elections cannot be "approved" without full or partial payment.');
       finally
         lDlg.Free;
       end;
     end else
     if Nm = UpperCase('EfileBtn') then
       RunSERS(FormName);
   end;
 end;

 if FormName = 'T1521' then
 begin
   if (Nm='CERTBTN1') or (Nm='CERTBTN2') or (Nm='CERTBTN3') or (Nm='CERTBTN4') or (Nm='CERTBTN5') or
      (Nm='CERTBTN6') or (Nm='CERTBTN7') or (Nm='CERTBTN8') or (Nm='CERTBTN9') or (Nm='CERTBTN10') or
      (Nm='CERTBTN11') or (Nm='CERTBTN12') or (Nm='CERTBTN13') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(57, '1');
       if (Nm='CERTBTN2') then CertificationButtonClick(58, '1');
       if (Nm='CERTBTN3') then CertificationButtonClick(140, '1');
       if (Nm='CERTBTN4') then CertificationButtonClick(118, '1');
       if (Nm='CERTBTN5') then CertificationButtonClick(119, '1');
       if (Nm='CERTBTN6') then CertificationButtonClick(120, '1');
       if (Nm='CERTBTN7') then CertificationButtonClick(121, '1');
       if (Nm='CERTBTN8') then CertificationButtonClick(122, '1');
       if (Nm='CERTBTN9') then CertificationButtonClick(123, '1');
       if (Nm='CERTBTN10') then CertificationButtonClick(124, '1');
       if (Nm='CERTBTN11') then CertificationButtonClick(125, '1');
       if (Nm='CERTBTN12') then CertificationButtonClick(126, '1');
       if (Nm='CERTBTN13') then CertificationButtonClick(127, '1');
     end else
     begin
       if (Nm='CERTBTN1') then CertificationButtonClick(57, '2');
       if (Nm='CERTBTN2') then CertificationButtonClick(58, '2');
       if (Nm='CERTBTN3') then CertificationButtonClick(140, '2');
       if (Nm='CERTBTN4') then CertificationButtonClick(118, '2');
       if (Nm='CERTBTN5') then CertificationButtonClick(119, '2');
       if (Nm='CERTBTN6') then CertificationButtonClick(120, '2');
       if (Nm='CERTBTN7') then CertificationButtonClick(121, '2');
       if (Nm='CERTBTN8') then CertificationButtonClick(122, '2');
       if (Nm='CERTBTN9') then CertificationButtonClick(123, '2');
       if (Nm='CERTBTN10') then CertificationButtonClick(124, '2');
       if (Nm='CERTBTN11') then CertificationButtonClick(125, '2');
       if (Nm='CERTBTN12') then CertificationButtonClick(126, '2');
       if (Nm='CERTBTN13') then CertificationButtonClick(127, '2');
     end;
   end;

   If (Nm='EFILEBTN') then
   begin
     lTaxVal:= FetchElmFno(RetNo, GetFormNo(FormName), 54);
     lTaxPaymentVal:= FetchElmFno(RetNo, GetFormNo(FormName), 55);

     if (lTaxPaymentVal < lTaxVal) then
     begin
       lDlg:= CreateMessageDialog(
                'Please confirm that you will be making a payment within 5 days of submission.',
                mtConfirmation,
                [mbYes, mbNo]
              );
       try
         lDlg.Caption:= 'Payment required';
         lBtnYes:= lDlg.FindComponent('Yes') as TButton;
         lBtnNo:= lDlg.FindComponent('No') as TButton;

         if Assigned(lBtnNo) then lBtnNo.Caption:= 'No (Not sure)';

         if lDlg.ShowModal = mrYes then
         begin
           RunSERS(FormName);
         end else
           ShowMessage('Certain elections cannot be "approved" without full or partial payment.');
       finally
         lDlg.Free;
       end;
     end else
     if Nm = UpperCase('EfileBtn') then
       RunSERS(FormName);
   end;
 end;
 // 20250826 Igor <<<
 // 20251028 Igor >>>
 if (LeftStr(FormName, 3) = 'S74') then // 20251117 Igor
 begin
    if Nm.Equals('EFILEBTN') then RunSERS(FormName);
 end;

 if (LeftStr(FormName, 5) = 'T2107') then
 begin
   if Nm.Equals('EFILEBTN') then RunSERS(FormName);

   if Nm.Equals('CERTBTN1') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if (lUserResponse = mrYes) then
       if Nm.Equals('CERTBTN1') then CertificationButtonClick(62, '1')
     else
       if Nm.Equals('CERTBTN1') then CertificationButtonClick(62, '2');
   end;
 end;
 // 20251028 Igor <<<
 // 20250901 Igor >>>
 if FormName='S151' then
 begin
    if (Nm = 'EFILEBTN') then
      RunSERS(FormName);
 end;

 if FormName = 'T2055' then
 begin
   if (Nm='CERTBTN1') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
       if (Nm='CERTBTN1') then CertificationButtonClick(57, '1')
     else
       if (Nm='CERTBTN1') then CertificationButtonClick(57, '2');
   end;

   If (Nm='EFILEBTN') then
   begin
     lTaxVal:= FetchElmFno(RetNo, GetFormNo(FormName), 25);
     lTaxPaymentVal:= FetchElmFno(RetNo, GetFormNo(FormName), 26);

     if (lTaxPaymentVal < lTaxVal) then
     begin
       lDlg:= CreateMessageDialog(
                'Please confirm that you will be making a payment within 5 days of submission.',
                mtConfirmation,
                [mbYes, mbNo]
              );
       try
         lDlg.Caption:= 'Payment required';
         lBtnYes:= lDlg.FindComponent('Yes') as TButton;
         lBtnNo:= lDlg.FindComponent('No') as TButton;

         if Assigned(lBtnNo) then lBtnNo.Caption:= 'No (Not sure)';

         if lDlg.ShowModal = mrYes then
         begin
           RunSERS(FormName);
         end else
           ShowMessage('Certain elections cannot be "approved" without full or partial payment.');
       finally
         lDlg.Free;
       end;
     end else
     if Nm = UpperCase('EfileBtn') then
       RunSERS(FormName);
   end;
 end;

 //20251027 Igor >>>
 if FormName.Equals('T2184') then
 begin
   if Nm.Equals('CERTBTN1') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
       if (Nm = 'CERTBTN1') then CertificationButtonClick(74, '1')
     else
       if (Nm = 'CERTBTN1') then CertificationButtonClick(74, '2');
   end;

   if (Nm = 'EFILEBTN') then
   begin
     if Nm = UpperCase('EfileBtn') then
       RunSERS(FormName);
   end;
 end;
 //20251027 Igor <<<

 if FormName = 'T2123' then
 begin
   if (Nm = 'CERTBTN1') or (Nm = 'CERTBTN2') or (Nm = 'CERTBTN3') or (Nm = 'CERTBTN4') or (Nm = 'CERTBTN5') or (Nm = 'CERTBTN6') or (Nm = 'CERTBTN7') or
      (Nm = 'CERTBTN8') or (Nm = 'CERTBTN9') or (Nm = 'CERTBTN10') or (Nm = 'CERTBTN11') or (Nm = 'CERTBTN12') or (Nm = 'CERTBTN13') then
   begin
     lUserResponse:= MessageDlg('I certify that the information given on this form is correct and complete, and that the appropriate third party electronic filing authorization form (T2183, or UHT-183), has been completed authorizing it’s submission.', mtConfirmation, [mbYes, mbNo], 0);
     if lUserResponse = mrYes then
     begin
       if (Nm = 'CERTBTN1') then CertificationButtonClick(57, '1');
       if (Nm = 'CERTBTN2') then CertificationButtonClick(63, '1');
       if (Nm = 'CERTBTN3') then CertificationButtonClick(67, '1');
       if (Nm = 'CERTBTN4') then CertificationButtonClick(71, '1');
       if (Nm = 'CERTBTN5') then CertificationButtonClick(85, '1');
       if (Nm = 'CERTBTN6') then CertificationButtonClick(100, '1');
       if (Nm = 'CERTBTN7') then CertificationButtonClick(115, '1');
       if (Nm = 'CERTBTN8') then CertificationButtonClick(128, '1');
       if (Nm = 'CERTBTN9') then CertificationButtonClick(140, '1');
       if (Nm = 'CERTBTN10') then CertificationButtonClick(152, '1');
       if (Nm = 'CERTBTN11') then CertificationButtonClick(165, '1');
       if (Nm = 'CERTBTN12') then CertificationButtonClick(177, '1');
       if (Nm = 'CERTBTN13') then CertificationButtonClick(189, '1');
     end else
     begin
       if (Nm = 'CERTBTN1') then CertificationButtonClick(57, '2');
       if (Nm = 'CERTBTN2') then CertificationButtonClick(63, '2');
       if (Nm = 'CERTBTN3') then CertificationButtonClick(67, '2');
       if (Nm = 'CERTBTN4') then CertificationButtonClick(71, '2');
       if (Nm = 'CERTBTN5') then CertificationButtonClick(85, '2');
       if (Nm = 'CERTBTN6') then CertificationButtonClick(100, '2');
       if (Nm = 'CERTBTN7') then CertificationButtonClick(115, '2');
       if (Nm = 'CERTBTN8') then CertificationButtonClick(128, '2');
       if (Nm = 'CERTBTN9') then CertificationButtonClick(140, '2');
       if (Nm = 'CERTBTN10') then CertificationButtonClick(152, '2');
       if (Nm = 'CERTBTN11') then CertificationButtonClick(165, '2');
       if (Nm = 'CERTBTN12') then CertificationButtonClick(177, '2');
       if (Nm = 'CERTBTN13') then CertificationButtonClick(189, '2');
     end;
   end;

   If (Nm='EFILEBTN') then
   begin
     lTaxVal:= FetchElmFno(RetNo, GetFormNo(FormName), 54);
     lTaxPaymentVal:= FetchElmFno(RetNo, GetFormNo(FormName), 55);

     if (lTaxPaymentVal < lTaxVal) then
     begin
       lDlg:= CreateMessageDialog(
                'Please confirm that you will be making a payment within 5 days of submission.',
                mtConfirmation,
                [mbYes, mbNo]
              );
       try
         lDlg.Caption:= 'Payment required';
         lBtnYes:= lDlg.FindComponent('Yes') as TButton;
         lBtnNo:= lDlg.FindComponent('No') as TButton;

         if Assigned(lBtnNo) then lBtnNo.Caption:= 'No (Not sure)';

         if lDlg.ShowModal = mrYes then
         begin
           RunSERS(FormName);
         end else
           ShowMessage('Certain elections cannot be "approved" without full or partial payment.');
       finally
         lDlg.Free;
       end;
     end else
     if Nm = UpperCase('EfileBtn') then
       RunSERS(FormName);
   end;
 end;
 //20250901 Igor <<<

 //20240728 Igor >>>
 If FormName='T2054' then
 begin
  If (Nm='EFILEBTN') then
  begin
    // 20250711 Igor >>>
    lTaxVal:= FetchElmFno(RetNo, GetFormNo(FormName), 224);
    lTaxPaymentVal:= FetchElmFno(RetNo, GetFormNo(FormName), 109);

    if (lTaxPaymentVal < lTaxVal) then
    begin
      lDlg:= CreateMessageDialog(
               'Please confirm that you will be making a payment within 5 days of submission.',
               mtConfirmation,
               [mbYes, mbNo]
             );
      try
        lDlg.Caption:= 'Payment required';
        lBtnYes:= lDlg.FindComponent('Yes') as TButton;
        lBtnNo:= lDlg.FindComponent('No') as TButton;

        if Assigned(lBtnNo) then lBtnNo.Caption:= 'No (Not sure)';

        if lDlg.ShowModal = mrYes then
        begin
          RunSERS(FormName);
        end else
          ShowMessage('Certain elections cannot be "approved" without full or partial payment.');
      finally
        lDlg.Free;
      end;
    end else
    // 20250711 Igor <<<
    if Nm = UpperCase('EfileBtn') then
      RunSERS(FormName);
  end;
 end;
 //20240728 Igor <<<

  //20240723 Igor >>>
 If FormName='S89' then
 begin
    if Nm = UpperCase('EfileBtn') then
      RunSERS(FormName);
 end;

  If FormName = 'T217' then
  begin
    if Nm = UpperCase('EfileBtn') then
      RunSERS(FormName);
  end;
  //20240723 Igor <<<

  //20240722 Igor >>>
  If LeftStr(FormName, 4) = 'UHT#' then
  begin
    if Nm = UpperCase('UHT2900EfileBtn') then
    // 20250711 Igor >>>
    begin
      lTaxVal:= FetchElmFno(RetNo, GetFormNo(FormName), 134);
      lTaxPaymentVal:= FetchElmFno(RetNo, GetFormNo(FormName), 135);

      if (lTaxPaymentVal < lTaxVal) then
      begin
        lDlg:= CreateMessageDialog(
                 'Please confirm that you will be making a payment within 5 days of submission.',
                 mtConfirmation,
                 [mbYes, mbNo]
               );
        try
          lDlg.Caption:= 'Payment required';
          lBtnYes:= lDlg.FindComponent('Yes') as TButton;
          lBtnNo:= lDlg.FindComponent('No') as TButton;

          if Assigned(lBtnNo) then lBtnNo.Caption:= 'No (Not sure)';

          if lDlg.ShowModal = mrYes then
          begin
            RunSERS(FormName);
          end else
            ShowMessage('Certain elections cannot be "approved" without full or partial payment.');
        finally
          lDlg.Free;
        end;
      end else
        RunSERS(FormName);
    end;
    // 20250711 Igor <<<
  end;

  If LeftStr(FormName, 5) = 'T2057' then
  begin
    if Nm = UpperCase('T2057EfileBtn') then
      RunSERS(FormName);
  end;

  If LeftStr(FormName, 5) = 'T2059' then
  begin
    if Nm = UpperCase('T2059EfileBtn') then
      RunSERS(FormName);
  end;
  //20240722 Igor >>>
  If LeftStr(FormName, 5) = 'T2058' then
  begin
    if Nm = UpperCase('EfileBtn') then
      RunSERS(FormName);
  end;

 If FormName='SALDIVSET' then   //20201214
 begin
  If (Nm='SALDIVHELPBTN') then
   ConnectToWeb('http://www.visualtax.com/SalDiv.php');
 end;

 If FormName='TESTFRM' then
 Begin
  If Nm='OPENT1BTN' then
  begin
   Test_OpenT1Click;//Need a routine to OpenForeignT1
  end
  else
  If Nm='CALCBTN' then
  begin
   Test_CalcBtnClick; //as described in Procedure TestFrm(..)
  end;
 end;

 //20170716
 If FormName='S9' then
 Begin
  If Nm='SHOWGROUPTEMPLATEBTN' then
  begin
    If FetchElm(RetNo,'S9',185)>'' then ShowGroupTemplate(FetchElm(RetNo,'S9',185))  //template name
    Else ShowMessage('There is no template name');
  end;
  //20170726
  If Nm='APPLYGROUPTEMPLATEBTN' then
  begin
   If UpperCase(FetchElm(RetNo,'S9',184))='Y' then
   Begin
    ShowMessage('Apply is used only for other members of the group'
      +Chr(13)
      +Chr(13)+'For this corporation just prepare fully S9, S23, S49 and S39'
      +Chr(13)+'and the program creates the re-usable GroupInfo template/form');
    Exit;
   end;

   If FetchElm(RetNo,'S9',185)>'' then
   Begin
    ApplyGroupInfoToMember(RetNo,FetchElm(RetNo,'S9',185));
    OpenForm(RetNo,GetFormNo('S9'),1);
   end;
  end;
 end;  //s9

 (* //20171022
  //20170810
  If FormName='S10' then
  Begin
   If Nm='S10NEWBTN' then OpenForm(RetNo,GetFormNo('S10NEW'),1);
  end;
 *)
 If FormName='T2' then
 begin
  If Nm='RECALCALLRELATEDBTN' then    //20200901
  begin
    if ValidADDONFeaturesKey=False then Exit; //20200901
    CalcAllSbdAllocCompanies(RetNo);
    OpenForm(RetNo,'SBDALLOC',321);
  end;


  //pg2
  If Nm='GIFIBTN' then
  begin
     MainFormT2.GifiIsBtnClick(Sender);
     Exit;
  end;


  If Nm='SIGNATUREDATEBTN' then    //20200707
  begin
     StoreElm(RetNo,GetFormNo('T2'),264,FormatDateTime('yyyy/mm/dd', Now));
     OpenForm(RetNo,'T2',264);
     Exit;
  end;

  //pg3
  If Nm='NAICSBTN' then
  begin
     ShowPdf(AppDir,'NAICS.xlsx');  //20170630
     Exit;
  end;

 end;


 If Nm='FNOTE2BTN' then
 begin
     OpenForm(RetNo,GetFormNo('FNOTE2'),0);
     Exit;
 end;


 If FormName='AEFDONE' then
 begin
  If Nm='AEFDONEPRINTBTN' then
   begin
     MainFormT2.PrintForm1Click(Application);
     Exit;
   end;
 end;

 If FormName='MULTIAPP' then
 begin
  //If Nm='CALCMULTIAPPBTN' then CalcMultiAppForm(RetNo);
 end;


 If FormName='INVFORMS' then
 begin
  If Nm='INVOICEBTN' then begin OpenForm(RetNo,GetFormNo('INVOICE'),0); Exit;end;
  If Nm='FEESCHEDULEBTN' then
  begin
     MainFormT2.FeeSchedule1Click(Application);
     Exit;
   end;
  end;

  If FormName='S4' then  //20140609
  begin
     If (Nm='S4WSBTN') or (Nm='S4WSBTN2') then
      begin  OpenForm(RetNo,GetFormNo('S4WS'),0); Exit; end;
  end;

 If FormName='S5' then
 begin
  If Nm='S5IBTN' then  begin  OpenForm(RetNo,GetFormNo('S5'),0); Exit; end;
  If Nm='S5BCBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),601); Exit; end;
  If Nm='S5MBBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),412); Exit; end;
  If Nm='S5NBBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),401); Exit; end;
  If Nm='S5NLBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),101); Exit; end;
  If Nm='S5NSBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),123); Exit; end;
  If Nm='S5NTBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),728); Exit; end;
  If Nm='S5NUBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),705); Exit; end;
  If Nm='S5SKBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),424); Exit; end;
  If Nm='S5PEBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),114); Exit; end;
  If Nm='S5ONBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),501); Exit; end;
  If Nm='S5YTBTN' then  begin OpenForm(RetNo,GetFormNo('S5'),719); Exit; end;
 end;

 If FormName='S23' then
 begin
  If Nm='COPYFROMS9BTN' then
   begin
     CopyS23FromS9(RetNo);
     OpenForm(GetCurrentRetNo,GetFormNo('S23'),1);
     Exit;
   end;
 end;

 If FormName='EFCONFIRM' then  //20130531
 begin
  If Nm='EFCONFIRMBTN' then
   begin
     MainFormT2.PrintForm1Click(Application);
     Exit;
   end;
 end;

 If ExtractNonInstFormName(FormName)='S60' then //20160907 Igor
 begin
  If LeftStr(Nm,13)='T661IMPORTBTN' then
   begin
     FNo:=GetFormNo(FormName);
     If      RightStr(Nm,3) ='240' then begin k:=34;For i:=k to 60 do StoreElm(RetNo,FNo,i,'');end
     else If RightStr(Nm,3) ='242' then begin k:=104;For i:=k to 130 do StoreElm(RetNo,FNo,i,'');end
     else If RightStr(Nm,3) ='244' then begin k:=131;For i:=k to 157 do StoreElm(RetNo,FNo,i,'');end
     else If RightStr(Nm,3) ='250' then begin k:=158;For i:=k to 184 do StoreElm(RetNo,FNo,i,'');end
     else If RightStr(Nm,3) ='252' then begin k:=185;For i:=k to 211 do StoreElm(RetNo,FNo,i,'');end
     else exit; //do what?
     PasteFromClipBoard(RetNo,GetFormNo(FormName),k,27,78);
   //  ImportT661Descriptions(GetFormNo(FormName),k);
     Exit;
   end;
 end;

 //20150828
 if (FormName='S100')
 Or (FormName='S101')
 or (ExtractNonInstFormName(FormName)='S125') //20160907 Igor
 Or (FormName='S140')
 Or (FormName='S141')
 Or (FormName='FNOTE2')  //20160501
 then
 Begin
   If Nm='S100BTN' then OpenForm(GetCurrentRetNo,GetFormNo('S100'),0);
   If Nm='S101BTN' then OpenForm(GetCurrentRetNo,GetFormNo('S101'),0);
   If Nm='S125BTN' then OpenForm(GetCurrentRetNo,GetFormNo('S125#1'),0);
   If Nm='S140BTN' then OpenForm(GetCurrentRetNo,GetFormNo('S140'),0);
   If Nm='S141BTN' then OpenForm(GetCurrentRetNo,GetFormNo('S141'),0);
   If Nm='S141NOTESBTN' then OpenForm(GetCurrentRetNo,GetFormNo('FNOTE2'),0);
   If Nm='CRAGIFIGUIDEBTN' then ShowPdf(AppDir,'RC4088.pdf');
   if Nm='IMPORTGIFIBTN' then ImportGIFI(GetCurrentRetNo, GetFormNo(FormName), FormName);  //20160722 Igor
 End;

 If FormName='T661' then
 begin
  If Nm='T661GUIDEBTN' then
   begin
     ShowPdf(AppDir,'T4088-20e.pdf');  //20210703
     Exit;
   end;
  If (Nm='S60BTN') or (Nm='S60BTN2') then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('S60#1'),0);
     Exit;
   end;
 end;  //t661


 //20171201
 If ExtractNonInstFormName(FormName)='T1134' then //20160907 Igor
 begin
  //20180703 Igor >>>
  if Nm='T1134EFILEBTN' then
  begin

    //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20211210

    if FetchElm(RetNo,'T1134',26)>''  then  //20180824 CON
    Begin
     ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
     Exit;
    End;
    ExecuteForm(TEfileT1134T2_2027);
    Exit;
  end;
  //20180703 Igor <<<
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

  //20210627
  If Nm='FILLABLET1134BTN' then
  begin
   ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/forms-publications/forms/t1134.html');
   Exit;
  end;
  //20230601 Igor >>>
  If Nm='T1134SLBTN' then
  begin
   OpenForm(RetNo,GetFormNo('T1134S#1'),1);
   Exit;
  end;
  //20230601 Igor <<<

 end;

 If FormName='T1141' then
 begin
  If Nm='T1141IBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('T1141I'),0);
     Exit;
   end;
 end;

  If ExtractNonInstFormName(FormName)='CONSENT' then //20200215
  begin
   If Nm='EFILECONSENTBTN' then
   Begin
     ExecuteForm(TEfileConsentT2_2027); //20200211
   End;
  end;



 If FormName='RC59' then
 begin

   If Nm='CONSENTBTN' then //20200315
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('CONSENT'),0);
     Exit;
   end;
  { //20200315
  If Nm='RC59XBTN' then //20180824 CON
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('RC59X'),0);
     Exit;
   end;


  If Nm='RC59IBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('RC59I'),0);
     Exit;
   end;

  If Nm='EFILERC59BTN' then
   begin
    if FetchElm(RetNo,'RC59',28)>''  then  //20180824 CON
    Begin
     ShowMessage('This form has been already Efiled. To do it again, you must erase the Efiled Date from the form');
     Exit;
    End;
    ExecuteForm(TEfileRC59T2_2027);
   end;
   }
 end;


 If FormName='RC59X' then
 begin
  If Nm='RC59IBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('RC59I'),0);
     Exit;
   end;

  If Nm='EFILERC59XBTN' then
  begin
    if FetchElm(RetNo,'RC59X',8)>''  then  //20180824 CON
    Begin
     ShowMessage('This form has been already Efiled. To do it again, you must erase the Efiled Date from the form');
     Exit;
    End;
    ExecuteForm(TEfileRC59XT2_2027);
  end;
 end;


 If FormName='CBCR' then  //20180605
 begin
  If Nm='RC4649IBTN' then
   begin
     ShowPdf(AppDir,'RC4649I.pdf');
     Exit;
   end;

  //20180608
  If Nm='CBCEFILEBTN' then
   begin
    if FetchElm(RetNo,'CBCR',569)>''  then  //20180824 CON
    Begin
     ShowMessage('This form has been already Efiled. To do it again, you must erase the Efile Confirmation Number from this form');
     Exit;
    End;

    //20230109 Igor >>>
     if FetchElm(RetNo,'CBCR',604) + FetchElm(RetNo,'CBCR',605) = ''  then
     Begin
       ShowMessage('If this is an amended CbCR then check "yes", otherwise check "no"');
       Exit;
     End;
     //20230109 Igor <<<

     ExecuteForm(TEfileCBCT2_2027);
     Exit;
   end;
 end;

 If FormName='S49' then
 begin
  If Nm='COPYS49FROMS23BTN' then
   begin
     CopyS49FromS23(RetNo);
     OpenForm(GetCurrentRetNo,GetFormNo('S49'),1);
     Exit;
   end;
 end;

 If (FormName='S53') or (FormName='S54') then
 begin
  If Nm='DIVIDENDTAXATIONBTN' then
   begin
     MainFormT2.DividendTaxation1Click(Application);
     Exit;
   end;
 end;

 If FormName='S54' then  //20211106
 begin
  If Nm='S54WS1BTN' then  begin OpenForm(RetNo,'S54WS1#1',0); Exit; end;
  If Nm='S54WS2BTN' then  begin OpenForm(RetNo,'S54WS2#1',0); Exit; end;
 End;


 If FormName='OITC_1' then
 begin
  If Nm='COPYOT2013TOOITCPART1BTN' then
   begin
     CopyOT2013ToOITCPart1(RetNo);
     OpenForm(GetCurrentRetNo,GetFormNo('OITC_1'),1);
     Exit;
   end;
  If Nm='OITCHLPBTN' then
   begin
     OpenForm(GetCurrentRetNo,GetFormNo('OITCHLP'),0);
     Exit;
   end;

 end;


 If IsFormAClientLetter(FormName) then
 begin
  If Nm='LETTERDESIGNBTN' then
  begin
   MainFormT2.ClientLetter1Click(Sender);
   OpenForm(GetCurrentRetNo,GetFormNo(FormName),1);
  end;
  If Nm='PRINTLETTERBTN' then MainFormT2.CurrentPage1Click(Sender);
  If Nm='MSWORDBTN' then OpenMSWord;
 end;

 If FormName='FNOTE2' then
 begin
  If Nm='IMPORTFNBTN' then
   begin
     For i:=10 to 510 do StoreElm(RetNo,GetFormNo(FormName),i,''); //20110128
     PasteFromClipboard(RetNo,GetFormNo(FormName),104,116,78);
     //ImportGifiNotes;
     Exit;
   end;
 end;

 If ExtractNonInstFormName(FormName)='T1273' then //20160907 Igor
 begin
  If Nm='T1273A1BTN' then
   begin
     OpenForm(RetNo,GetFormNo('T1273A1#1'),0);
     Exit;
   end;
 end;

 If ExtractNonInstFormName(FormName)='T1273' then //20160907 Igor
 begin
  If Nm='T1273A2BTN' then
   begin
     OpenForm(RetNo,GetFormNo('T1273A2#1'),0);
     Exit;
   end;
 end;

 (*   //20130608
 If FormName='MCT' then
 begin
  If Nm='COPYMCTFROMS23BTN' then
   begin
     CopyMCTFROMS23(RetNo);
     OpenForm(GetCurrentRetNo,GetFormNo('MCT'),501);
     Exit;
   end;
 end;
 *)

 //20231024
 (*
 If FormName='AS9' then
 begin
  If Nm='ABSREDGUIDEBTN' then
   begin
     ShowPdf(AppDir,'sred_at190_guide.pdf');
     Exit;
   end;
 end;
 *)

 If FormName='AS20' then   //20140529
 begin
  If Nm='AS20WSBTN' then
   begin
     OpenForm(RetNo,GetFormNo('AS20WS'),0);
     Exit;
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

Function TFormT2_2027.ValidateField(FieldId: integer; OldValue: string; Var Value : string):boolean; //20260704 Alex
  //20250826 Igor >>>
  procedure ValidateDoubleCheckbox(aYesFieldIndex: Integer; aNoFieldIndex: Integer);
  begin
    if (FieldId = aYesFieldIndex) and (Value.Equals('X')) then
      if FetchElm(RetNo, GetFormNo(FormName), aNoFieldIndex).Equals('X') then
        StoreElm(RetNo, GetFormNo(FormName), aNoFieldIndex, '');

    if (FieldId = aNoFieldIndex) and (Value.Equals('X')) then
      if FetchElm(RetNo, GetFormNo(FormName), aYesFieldIndex).Equals('X') then
        StoreElm(RetNo, GetFormNo(FormName), aYesFieldIndex, '');
  end;

var
  i: Integer;
  SelectedString, s: string;
  //20250826 Igor <<<
begin
 Result := True;
 //20260608
 if LeftStr(FormName,2)='S8' then
  begin
    //20260704 Alex >>>
    if (FieldId = 6)    and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 313, 'X');
    if (FieldId = 28)   and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 314, 'X');
    if (FieldId = 50)   and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 315, 'X');
    if (FieldId = 72)   and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 316, 'X');
    if (FieldId = 94)   and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 317, 'X');
    if (FieldId = 116)  and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 318, 'X');
    if (FieldId = 138)  and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 319, 'X');
    if (FieldId = 160)  and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 320, 'X');
    if (FieldId = 182)  and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 321, 'X');
    if (FieldId = 204)  and OldValue.IsEmpty and not Value.IsEmpty then StoreElm(RetNo, GetFormNo(FormName), 322, 'X');
    //20260704 Alex <<<
    case FieldId of
      233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt+1);
        end;
    end;
  end
  // 299: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+1);end;

 Else If FormName = 'T2' then
 begin
    case FieldId of
     10,11: {start/end dates}   //20221115
      begin
       AutoFormatDate(Value); Result:= InDateOnly(Value,1999,AppYearInt+10);

       If FieldId =10 then  {beg date}
        begin
         If Value < MinStartPeriod then
         begin
          ShowMessage('This program version can only process periods '+MinStartPeriod+ '-'+MaxEndPeriod);
          result := False;
         end;
        end;
       If FieldId =11 then  {end date}
        begin
         If Value > MaxEndPeriod then
         begin
          ShowMessage('This program version can only process periods '+MinStartPeriod+ '-'+MaxEndPeriod);
          //result := False;
         end;
       exit;
      end;
     end;

     53,54,55,58: begin Result :=XOnly(Value);exit;end;
     82: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2019,AppYearInt+3);end; //t183 completyed //20221115
     299: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+1);end; //incorp date //20220617

     61: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1997,AppYearInt+1);end;
     18: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+1);end;
     66: begin Result :=InValuesOnly('Y,N',Value);exit;end;
    end; {Case}

    //Pg 3 ------------------------
    case FieldId of
      227,238,239,240,241,242,243,245,246,247:
      begin
        Result :=XOnly(Value);exit;
      end;
      260:
      begin
        AutoFormatDate(Value); Result:= InDateOnly(Value,1999,AppYearInt+5);
      end;
    end; {case}

    //Pg 8 ------------------------
    case FieldId of
      745:
      begin
        AutoFormatDate(Value);
        Result:=InDateOnly(Value,2000,AppYearInt+10);
        StoreElm(RetNo,GetFormNo(FormName),745,'');
        //OpenForm(RetNo,GetFormNo(FormName),45);
        exit;
      end;
    end; {case}
 end //T2

 else if FormName = 'S75' then  //20250919
  begin
    case FieldId of
      173,23,29,35,41,47,53, 60, 61, 62, 63, 64, 65: //20260508 Alex
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt+1);
        end;
    end;
  end
  //20260508 Alex >>>
  else if FormName = 'S77' then
  begin
    case FieldId of
      7, 14, 27, 40, 53, 66, 81, 93, 95, 96, 98, 99, 101, 102, 104, 105, 107, 108, 112, 124, 136, 148, 160, 172, 185:
        begin
          AutoFormatDate(Value);
          Result:= InDateYYYYMMDDonly(Value, AppYearInt+1);
        end;
    end;
  end
  //20260508 Alex <<<

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

  //JZ//20250707 - removed elm 19
  else if FormName = 'T2054' then
    begin
     case FieldId of
     12,13,14: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end;
  end  //case

  //20240722 Igor >>>
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
//20240722 Igor <<<

  else if ExtractNonInstFormName(FormName) = 'T2058' then
  begin
    case FieldId of
      7, 8, 35, 34, 39, 44, 59:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
    end;
  end
  //20250826 Igor <<<
  else if ExtractNonInstFormName(FormName) = 'T1521' then
  begin
    case FieldId of
      11, 12, 40,
      75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
      112, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 141:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
    end;
    case FieldId of
      35, 36: ValidateDoubleCheckbox(35, 36);
      37, 38:
        begin
          if not FetchElm(RetNo, GetFormNo(FormName), 35).Equals('X') then
            Value:= ''
          else
            ValidateDoubleCheckbox(37, 38);
        end;
      43, 44: ValidateDoubleCheckbox(43, 44);
      45, 46: ValidateDoubleCheckbox(45, 46);
      95, 96: ValidateDoubleCheckbox(95, 96);
      97, 98: ValidateDoubleCheckbox(97, 98);
      99, 100: ValidateDoubleCheckbox(99, 100);
      101, 102: ValidateDoubleCheckbox(101, 102);
      103, 104: ValidateDoubleCheckbox(103, 104);
      105, 106: ValidateDoubleCheckbox(105, 106);
      107, 108: ValidateDoubleCheckbox(107, 108);
      113, 109: ValidateDoubleCheckbox(113, 109);
      114, 115: ValidateDoubleCheckbox(114, 115);
      116, 117: ValidateDoubleCheckbox(116, 117);
    end;

    case FieldId of
      47, 48, 49, 50, 51, 52, 61, 62, 63, 64:
        begin
          if (Length(Value) > 0) then
          begin
            Result:= False;

            if Length(Value) < 15 then
            begin
              ShowMessage('Invalid Business number length. Format NNNNNNNNNRCNNNN.');
              Exit;
            end;

            Result:= (Value[10] = 'R') and ((Value[11] = 'C'));

            if not Result then
              ShowMessage('Invalid Business number in the column 330. Format NNNNNNNNNRCNNNN.');
          end;
        end;
    end;

  end
  //20250826 Igor <<<
  //20250901 Igor <<<
  else if ExtractNonInstFormName(FormName) = 'T2055' then
  begin
    case FieldId of
      11, 12, 112:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
    end;
    case FieldId of
      43, 44: ValidateDoubleCheckbox(43, 44);
    end;

    case FieldId of
      8:
        begin
          if (Length(Value) > 0) then
          begin
            Result:= False;

            if Length(Value) < 15 then
            begin
              ShowMessage('Invalid Business number length. Format NNNNNNNNNRCNNNN.');
              Exit;
            end;

            Result:= (Value[10] = 'R') and ((Value[11] = 'C'));

            if not Result then
              ShowMessage('Invalid Business number in the column 001. Format NNNNNNNNNRCNNNN.');
          end;
        end;
    end;
  end

  else if ExtractNonInstFormName(FormName) = 'T2123' then
  begin
    case FieldId of
      11, 12, 26, 27, 47, 48, 60, 64, 68, 72, 80, 81, 86, 95, 96, 101, 110, 111, 116, 129, 141, 153, 166, 178, 190:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
    end;

    case FieldId of
      8, 18, 74, 89, 104:
        begin
          if (Length(Value) > 0) then
          begin
            Result:= False;

            if Length(Value) < 15 then
            begin
              ShowMessage('Invalid "Business number" field length. Format NNNNNNNNNRCNNNN.');
              Exit;
            end;

            Result:= (Value[10] = 'R') and ((Value[11] = 'C'));

            if not Result then
              ShowMessage('Invalid "Business number" field format. Format NNNNNNNNNRCNNNN.');
          end;
        end;
    end;

    case FieldId of
      14, 28, 76, 91, 106:
        begin
          if (Length(Value) > 0) then
          begin
            Result:= False;

            if Length(Value) < 11 then
            begin
              ShowMessage('Invalid "Non-resident account number" field length. Format NRNNNNNNNNN.');
              Exit;
            end;

            Result:= (Value[1] = 'N') and ((Value[2] = 'R'));

            if not Result then
              ShowMessage('Invalid "Non-resident account number" field format. Format NRNNNNNNNNN.');
          end;
        end;
    end;
  end
  //20250901 Igor <<<

  // 20250714 Igor >>>
  else if (LeftStr(FormName, 5) = 'T2311') then
  begin
    case FieldId of
      11, 12:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
    end;
  end
  // 20250714 Igor >>>
  //20251028 Igor <<<
  else if (LeftStr(FormName, 3) = 'S74') then // 20251117 Igor
  begin
    case FieldId of
      3, 6, 13, 20, 32, 34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 64, //20260903 Alex
      10006, 10026, 10046, 10066, 10086, 10106, 10126, 10146, 10166, 10186, 10206, 10226, //20260903 Alex
      20005, 20018, 20031, 20044, 20057, 20070, 20083, 20096, 20109, 20122, 20135, 20148: //20260903 Alex
        begin
          AutoFormatDate(Value);
          Result:= InDateYYYYMMDDonly(Value, AppYearInt + 4);
        end;
      7, 8: ValidateDoubleCheckbox(7, 8);
      9, 10: ValidateDoubleCheckbox(9, 10);
      11, 12: ValidateDoubleCheckbox(11, 12);
      22, 23: ValidateDoubleCheckbox(22, 23);
      66, 67: ValidateDoubleCheckbox(66, 67);
    end;

    {case FieldId of
      50, 56:
        begin
          if (Length(Value) > 0) then
          begin
            Result:= False;

            if Length(Value) < 15 then
            begin
              ShowMessage('Invalid Business number length. Format NNNNNNNNNRCNNNN.');
              Exit;
            end;

            Result:= (Value[10] = 'R') and ((Value[11] = 'C'));

            if not Result then
              ShowMessage('Invalid Business number. Format NNNNNNNNNRCNNNN.');
          end;
        end;
    end;}
  end else

  if (LeftStr(FormName, 5) = 'T2107') then
  begin
    case FieldId of
      2, 12, 41, 63:
        begin
          AutoFormatDate(Value);
          Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
        end;
      39, 40: ValidateDoubleCheckbox(39, 40);
      56, 57: ValidateDoubleCheckbox(56, 57);
      58, 59: ValidateDoubleCheckbox(58, 59);
      8:
        begin
          if (Length(Value) > 0) then
          begin
            Result:= False;

            if Length(Value) < 15 then
            begin
              ShowMessage('Invalid Business number length. Format NNNNNNNNNRCNNNN.');
              Exit;
            end;

            Result:= (Value[10] = 'R') and ((Value[11] = 'C'));

            if not Result then
              ShowMessage('Invalid "001" Business number. Format NNNNNNNNNRCNNNN.');
          end;
        end;
    end;
  end
  //20251028 Igor <<<

 //20180614
   else if FormName = 'CBCR' then
   Begin
    case FieldId of
     571: begin AutoFormatDate(Value); Result:= InDateOnly(Value,2016,AppYearInt+10);Exit;end; //20191112
     602: begin AutoFormatDate(Value); Result:= InDateOnly(Value,2016,AppYearInt+10);Exit;end;
     32:  begin AutoFormatDate(Value); Result:= InDateOnly(Value,2016,AppYearInt+10);Exit;end;
    end;
   end

   else if LeftStr(FormName,4) = 'UHT#' then  //20231020
   begin
    case FieldId of
      115,116,117,118,129:
        begin
          AutoFormatDate(Value);
          Result := InDateYYYYMMDDonly(Value, AppYearInt+1);
          exit;
        end;
    end; { case }
   end

   else if FormName = 'T106' then  //20220618
   Begin
    case FieldId of
     31: begin AutoFormatDate(Value); Result:= InDateOnly(Value,2016,AppYearInt+2);Exit;end; //20191112
    end;
   end



   //20170614
    else if FormName = 'S7' then
    begin
     case FieldId of
      94..96: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2014,AppYearInt+1);exit;end;
      171..175: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2014,AppYearInt+1);exit;end;
      196..200: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2014,AppYearInt+1);exit;end;
      283..287: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2014,AppYearInt+1);exit;end;
     end; {case}
    end

    else if FormName = 'S20' then
    begin
     case FieldId of
      401,412,423,434,445,456,467,478,489,500,511,522:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end

    else if FormName = 'S54' then
    begin
     case FieldId of
      12,21,30,39,48:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end


   else if LeftStr(FormName,4) = 'S58#' then
    begin
     case FieldId of
      10,11:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,AppyearInt-3,AppYearInt+1);exit;end;   //20200609
     end; {case}
    end

    else if FormName = 'S59' then         //20220914
    begin
     case FieldId of
      5,12,19,26,33,40,47,54,61,68,75,82,89:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end

    //20260520 Alex >>>
   else
   if (LeftStr(FormName, 3) = 'S72') then
   begin
     case FieldId of
      6, 7:
       begin
         AutoFormatDate(Value);
         Result:= InDateOnly(Value, 2000, AppYearInt + 10);
         exit;
       end;
     end;
   end

   else
   if (LeftStr(FormName, 4) = 'S130') then
   begin
     case FieldId of
      7, 11, 15, 19, 23: //20260727 Alex
     // 7, 10, 14, 19, 23:
       begin
         AutoFormatDate(Value);
         Result:= InDateOnly(Value, 2000, AppYearInt + 10);
         exit;
       end;
       56, 4: ValidateDoubleCheckbox(56, 4); //20260616 Alex
       51, 52: ValidateDoubleCheckbox(51, 52); //20260616 Alex
     end;
   end
   //20260520 Alex <<<

    else if FormName = 'S73' then
    begin
     case FieldId of
      7,13,19,25,31,37,43,49,55,61,67,73,79,85,91,97,103,109,115,121,
      8,14,20,26,32,38,44,50,56,62,68,74,80,86,92,98,104,110,116,122:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end

    //20260626 Alex >>>
    else
    if (LeftStr(FormName, 3) = 'S76') then
    begin
      case FieldId of
       8, 19, 30, 41, 52, 63, 76, 85, 94, 103, 112, 121:
        begin
          AutoFormatDate(Value);
          Result:= InDateOnly(Value, 2000, AppYearInt + 10);
          exit;
        end;
      end;
    end
    //20260626 Alex <<<

    else if leftstr(FormName,3) = 'S78' then  //20250610
    begin
     case FieldId of
      6,8,158:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}

     //jz//20260611/VT52 v2
     if (FieldId >= 304) and (FieldId <= 313) then
       begin AutoFormatDate(Value); Result:=true;exit;end;
    end


    else if ExtractNonInstFormName(FormName) = 'S71' then //20160907 Igor
    begin
     case FieldId of
      8,9,10,11,32,33:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end


    else if ExtractNonInstFormName(FormName) = 'S54ADJ' then //20160907 Igor
    begin
     case FieldId of
      7,8,9:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end

    else if FormName = 'T183CP' then
    begin
     case FieldId of
      19: begin Result :=InValuesOnly('Y,N',Value);exit;end;
      16: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end; //20101121
     end; {case}
    end

   else if ExtractNonInstFormName(FormName) = 'IS_1' then
    begin
     case FieldId of
     25:begin Result :=NegativeOnly(Value);exit;end;
     end; {case}
    end

 else if ExtractNonInstFormName(FormName) = 'BLIMIT' then
    begin
     case FieldId of
     2,3:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+10);exit;end;
      end; {case}
    end


 else if ExtractNonInstFormName(FormName) = 'S1AUTO' then
    begin
     case FieldId of
     57,58,59,60,61,62:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
      end; {case}
    end

 else if ExtractNonInstFormName(FormName) = 'S3' then
    begin
     case FieldId of
     7,16,25,34,43,52,61,70,79,88:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
      end; {case}
     // 20130602
     case FieldId of
       212,216,220,224,228,232,236,240,244,248:
         //begin AutoFormatDate(Value); Result:=InDateOnly(Value,'1900',IntToStr(StrToInt(AppYear)+MxYears),RetNo,FormName,FieldId);exit;end;
         begin AutoFormatDate(Value);
           Result:=InDateOnly(Value,1900,AppYearInt+MxYears);  //,RetNo,FormName,FieldId);
           exit;
         end;
       263, 312: ValidateDoubleCheckbox(263, 312); //20260903 Alex
       264, 313: ValidateDoubleCheckbox(264, 313); //20260903 Alex
       265, 314: ValidateDoubleCheckbox(265, 314); //20260903 Alex
       266, 315: ValidateDoubleCheckbox(266, 315); //20260903 Alex
       267, 316: ValidateDoubleCheckbox(267, 316); //20260903 Alex
       268, 317: ValidateDoubleCheckbox(268, 317); //20260903 Alex
       269, 318: ValidateDoubleCheckbox(269, 318); //20260903 Alex
       270, 319: ValidateDoubleCheckbox(270, 319); //20260903 Alex
       271, 320: ValidateDoubleCheckbox(271, 320); //20260903 Alex
       272, 321: ValidateDoubleCheckbox(272, 321); //20260903 Alex

       284, 274: ValidateDoubleCheckbox(284, 274); //20260903 Alex
       285, 275: ValidateDoubleCheckbox(285, 275); //20260903 Alex
       286, 276: ValidateDoubleCheckbox(286, 276); //20260903 Alex
       287, 277: ValidateDoubleCheckbox(287, 277); //20260903 Alex
       288, 278: ValidateDoubleCheckbox(288, 278); //20260903 Alex
       289, 279: ValidateDoubleCheckbox(289, 279); //20260903 Alex
       290, 280: ValidateDoubleCheckbox(290, 280); //20260903 Alex
       291, 281: ValidateDoubleCheckbox(291, 281); //20260903 Alex
       292, 282: ValidateDoubleCheckbox(292, 282); //20260903 Alex
       293, 283: ValidateDoubleCheckbox(293, 283); //20260903 Alex

     end; {case}
    end
(*    20130602
 else if ExtractNonInstFormName(FormName) = 'S3' then //pg2
    begin
     case FieldId of
     212,216,220,224,228,232,236,240,244,248:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
      end; {case}
    end
*)

 else if FormName = 'S4' then //pg4
    begin
     case FieldId of
     302,309,316,323,330,338,345,352,359,366:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

  else if ExtractNonInstFormName(FormName) = 'S6' then
    begin
     case FieldId of
     9,17,25,33,41,49,57,65,73,81,89,97,105,113,121,129,137,145,153:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     161,169,177,185,193,201,209:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     220,221,222,223,224,225,226,227,228,229,230,231:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;
     238,239,240,241,242,243,244,245:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     302,311,320,329,338,347,356,365:  //124,130,136,147,153,159:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;

     305,314,323,332,341,350,359,368:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     446,447,448,449,450,451,452,453:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     379,386,393,400,407,414:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     455,456,457,458,459,460:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     424,430,436:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     462,463,464:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

     505,512,519:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;
     506,513,520:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;

      606,613,620,627,634,641,648,655,662:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;
     687,688,689,690,691,692,693,694,695:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+0);exit;end;
     end; {case}

    end

   else if ExtractNonInstFormName(FormName) = 'S6RE' then
    begin
     case FieldId of
     6,17,28,39,50,61,72,83,94,105,116:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+3);exit;end;
     7,18,29,40,51,62,73,84,95,106,117:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+3);exit;end;
     end; {case}
    end


 (* //20260718
 else if ExtractNonInstFormName(FormName) = 'S8LH' then
    begin
     case FieldId of
     1,2,12,13,23,24,34,35,45,46,56,57,67,68:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+20);exit;end;
     78,79,89,90,100,101,111,112,122,123:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+20);exit;end;
     end; {case}
    end
*)
 else if ExtractNonInstFormName(FormName) = 'S8LFREE' then
    begin
     case FieldId of
     1,2,12,13,23,24,34,35,45,46,56,57,67,68:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+20);exit;end;
     78,79,89,90,100,101,111,112,122,123:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+20);exit;end;
     end; {case}
    end

    else if FormName = 'S24' then
    begin
     case FieldId of
     36,37,40,41,44,45,48,49,52,53,56,57,60,61,64,65:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

   else if FormName = 'S28' then
    begin
     case FieldId of
     1,51,6,9,12,15,18,21,24:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end


  else if FormName = 'S31' then //S31 pg3
    begin
     case FieldId of
     203,208,213,218,259,261,263,
     1206,1210,1214,1218,1222,1226,1230,1234,1238,1242:        //20181120
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

  else if FormName = 'S31' then //pg13
    begin
     case FieldId of
     1206,1210,1214,1218,1222,1226,1230,1234,1238,1242:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end


  else if FormName = 'S43' then
    begin
     case FieldId of
     7://7,14,18,22:     //20220211
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

   else if FormName = 'S44' then
    begin
     case FieldId of
     6,9,12:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

   else if FormName = 'S45' then
    begin
     case FieldId of
     1,5,8,12,16,20,24,28,32,36,40,44:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

   else if ExtractNonInstFormName(FormName) = 'S48' then
    begin
     case FieldId of
     24:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end


   else if FormName = 'S49' then
    begin
     case FieldId of
     1,10,16,22,28,34,40,46,52,58,64,70,76,82,88,94,100,106,112,118,124:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end


   else if ExtractNonInstFormName(FormName) = 'S60' then //20160907 Igor
    begin
     case FieldId of
      5,6: begin AutoFormatYYYYMMDate(Value);Result:=InYYYYMMOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; //case
    end

   else if FormName = 'S91' then
    begin
     case FieldId of
     23,90,91,93,94,96,97,99,100,102,103,8,9,15,16:
     begin
        AutoFormatDate(Value);
        Result:=InDateOnly(Value,1900,AppYearInt+MxYears);
        exit;
     end;
     end; {case}
    end

   //20231006
   else if FormName = 'S310' then
    begin
     case FieldId of
     92,96,100,104,108,112,116:
     begin
        AutoFormatDate(Value);
        Result:=InDateOnly(Value,2022,AppYearInt+3);
        exit;
     end;
     end; {case}
    end
   //20231006
   else if FormName = 'S311' then
    begin
     case FieldId of
     40,44,48,52,56,60,64,68,72,76:
     begin
        AutoFormatDate(Value);
        Result:=InDateOnly(Value,2022,AppYearInt+3);
        exit;
     end;
     end; {case}
    end



   //20200215
   else if ExtractNonInstFormName(FormName) = 'CONSENT' then
   begin
    case FieldId of
    15,23,30,37,44,55:
     begin
      AutoFormatDate(Value);
      Result:=InDateYYYYMMDDOnly(Value,AppYearInt+30);exit;
     end;
    end;  //case
    case FieldId of
    55:
     begin
      AutoFormatDate(Value);
      Result:=InDateYYYYMMDDOnly(Value,AppYearInt+1);exit;
     end;
    end; {case}
   end

   else if ExtractNonInstFormName(FormName) = 'ACONSENT' then //20201205
   begin
    case FieldId of
    64,33:
     begin
      AutoFormatDate(Value);
      Result:=InDateYYYYMMDDOnly(Value,AppYearInt+10);exit;
     end;
    end; {case}
   end

    //20180529
    else if FormName = 'RC59' then
    begin
     case FieldId of
     15,23,30,37,44,55: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+20);exit;end;
     end; {case}
    end

    else if FormName = 'POLIT' then
    begin
     case FieldId of
     33,36,39:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end


   else if FormName = 'S570' then
   begin
     case FieldId of
      69,74,79,84,89,94,99,14,109,114,119,124,129,134,139,144,149:
       begin AutoFormatDate(Value);Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end;
     case FieldId of
      10,11,174,179,184,189,194,199,204,2-9,214,219,224,229,234,239,244,249,254,259:
       begin AutoFormatDate(Value);Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
   end


   else if FormName = 'T661' then
    begin
     case FieldId of
      //5,6: begin AutoFormatYYYYMMDate(Value);Result:=InYYYYMMOnly(Value,'1900',IntToStr(AppYearInt+100),RetNo,FormName,FieldId);exit;end;
      307,314: begin AutoFormatDate(Value);Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

    else if ExtractNonInstFormName(FormName) = 'T1131' then //20160907 igor
    begin
     case FieldId of
     8,31,32,33,34: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

    //200160612
    else if ExtractNonInstFormName(FormName) = 'T1134S' then //20160907 igor
    begin
     case FieldId of
     //33,34: begin AutoFormatDate(Value); Result:=InDateOnly(Value,AppYearInt-5,AppYearInt+2);exit;end;  //20180629 //20230411 Igor
     62,63: begin AutoFormatDate(Value); Result:=InDateOnly(Value,AppYearInt-5,AppYearInt+2);exit;end;
     end; {case}
    end


    else if ExtractNonInstFormName(FormName) = 'T1145' then //20160907 Igor
    begin
     case FieldId of
     9,16,21,28: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

    else if ExtractNonInstFormName(FormName) = 'T1146' then //20160907 Igor
    begin
     case FieldId of
     9,16,28: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end


    else if FormName = 'T2054' then
    begin
     {//20250707 cz
     case FieldId of
     12,13,14,19: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end;  //case
     }
     case FieldId of      //20231218
     116,123,130,137,144,151,158,165,172,179:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
     case FieldId of      //20231218
     186,190,194,198,202,206,210,214,218,222:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

    else if ExtractNonInstFormName(FormName) = 'T1273' then //20160907 igor
    begin
     case FieldId of
     63,64,21: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end

    //290180507
    else If ExtractNonInstFormName(FormName) = 'T1134' then
    begin
     case FieldId of
     19,20:Begin AutoFormatDate(Value); Result:=InDateOnly(Value,2015,AppYearInt+1);end;
     147,33,34,62,63:Begin AutoFormatDate(Value); Result:=InDateOnly(Value,2015,AppYearInt+1);end;
     end; {Case}
    end

    else If ExtractNonInstFormName(FormName) = 'T1141' then //20160907 Igor
    begin
     case FieldId of
     21,22: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1950,AppYearInt+1);end;
     end; {Case}
    end

    else If ExtractNonInstFormName(FormName) = 'T1142' then //20160907 Igor
    begin
     case FieldId of
     17,18: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1950,AppYearInt+1);end;
     end; {Case}
    end


    else If FormName = 'T1197_1' then
    begin
     case FieldId of

     30: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1950,AppYearInt+1);end;
     end; {Case}
    end


   else if ExtractNonInstFormName(FormName) = 'S422' then //20160907 Igor
   begin
    case FieldId of
     7: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1950,AppYearInt+2);end;
    end //case
   end

  else if ExtractNonInstFormName(FormName) = 'S381' then
   begin
    case FieldId of
     71,75,79,83,87,91,95,99,103:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end //case
   end



  else if ExtractNonInstFormName(FormName) = 'S388' then
   begin
    case FieldId of
     8,10,27,28,29,30,31:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end //case
   end

  else if ExtractNonInstFormName(FormName) = 'S389' then
   begin
    case FieldId of
     16,24,32,40,48:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end //case
   end

  else if ExtractNonInstFormName(FormName) = 'S390' then
   begin
    case FieldId of
     5,20,21,22,27,29,31,33,35:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end //case
   end



  //20221123
  //20210515
  //20130831
  else if ExtractNonInstFormName(FormName) = 'S392' then         //20221123
  begin
    case FieldId of
     6,11,16,21,26,31,36,41,46,51,56,61,66,71,76,81,86,91,96,101:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end;//case
    case FieldId of
     106,111,116,121,126,131,136,141,146,151,156,161,166,171,176,181,186,191,196,201:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end;//case

    case FieldId of
     236,241,246,251,256,261,266,271,276,281,286,291,296,201,306,311,316,321,326,331:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end;


    //20160508
    case FieldId of
     349,358,367,376,385,394,403:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end;


    case FieldId of
     512,522,532,542,552,562,572:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end;

  end

 (* //20210516
  //20130505
  else if ExtractNonInstFormName(FormName) = 'S393' then
   begin
    case FieldId of
     6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,66,70,74,78,82:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1940,AppYearInt+2);end;
    end //case
   end
 *)



  else if FormName = 'S321' then
    begin
     case FieldId of
      6,10,14,18: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+10);exit;end;
     end; {case}
    end

  (*  0150316
  else if FormName = 'S342' then
    begin
     case FieldId of
      96,97,98,99,100,101,102: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+10);exit;end;
      55,58,61,64,67,70,73,76: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+10);exit;end;
     end; {case}
    end
  *)
  else if FormName = 'S402' then
    begin
     case FieldId of
      6,10,14,18: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+10);exit;end;
     end; {case}
    end

  else if ExtractNonInstFormName(FormName) = 'S423' then
   begin
    case FieldId of
     30,
     275,282,289,296,303,310,317324,331,338,345,352,359,366,373,380,387,394,401,408,415,422,
     429,436,443,450,457,464,471,478,485:
     begin AutoFormatDate(Value); Result:=InDateOnly(Value,1950,AppYearInt+2);end;
    end //case
   end


   { //20170525
   else if ExtractNonInstFormName(FormName) = 'S426' then
   begin
    case FieldId of
     106,110,114,118: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end
   }
(*
   else if ExtractNonInstFormName(FormName) = 'S501' then
   begin
    case FieldId of
     6,10,14,18,22,26,30,34,38,42,46,50,54,58,62,66,70,74,78,82:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end
*)
   else if ExtractNonInstFormName(FormName) = 'S506' then
   begin
    case FieldId of
     169,170,171,172,78:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'S508' then
   begin
    case FieldId of
     38,40,42:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'S512' then
   begin
    case FieldId of
     44:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   (*
   else if ExtractNonInstFormName(FormName) = 'S546' then
   begin
    case FieldId of
     5: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
     43..67:begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
     72..94:begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'S547' then
   begin
    case FieldId of
     43..67:begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
     72..94:begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'S548' then
   begin
    case FieldId of
     5,30,31,41,42: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end
   *)
   else if ExtractNonInstFormName(FormName) = 'S550' then
   begin
    case FieldId of
     21,32,43,54,65,22,33,44,55,66:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'S552' then
   begin
    case FieldId of
     37,42,47,52,57,38,43,48,53,58,39,44,49,54,59:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

  else if ExtractNonInstFormName(FormName) = 'S556' then
    begin
     case FieldId of
     18,19:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+MxYears);exit;end;
     end; {case}
    end


   else if ExtractNonInstFormName(FormName) = 'S558' then
   begin
    case FieldId of
     9:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'S562' then
   begin
    case FieldId of
     16,17:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'S564' then
   begin
    case FieldId of
     16: begin AutoFormatYYYYMMDate(Value); Result:=InYYYYMMOnly(Value,1900,AppYearInt+2);end;
     17: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case

   end

   else if ExtractNonInstFormName(FormName) = 'S569' then
   begin
    case FieldId of
     9:
      begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+2);end;
    end //case
   end

   else if ExtractNonInstFormName(FormName) = 'T5004' then
   begin
    case FieldId of
     10,14,18,22,26,30,34,38,42,46,50,54,58,62,66:
        begin AutoFormatYYYYMMDate(Value);Result:=InYYYYMMOnly(Value,1900,AppYearInt+MxYears);exit;end;
    end //case
   end


   else if ExtractNonInstFormName(FormName) = 'AT1' then
    begin
     case FieldId of
      46,54: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+1);end;
     end; {Case}
    end


    else if ExtractNonInstFormName(FormName) = 'AT1' then //20120508
    begin
     If FieldId=133 then
     begin
      AutoFormatDate(Value); Result:= InDateOnly(Value,1999,AppYearInt+10);
     end;
    end

    else if ExtractNonInstFormName(FormName) = 'AS5' then
    begin
     case FieldId of
      16:begin Result :=InValuesOnly('1,2,3',Value);exit;end;
      22,26,30,34:
       begin
       AutoFormatDate(Value);
       Result:= InDateOnly(Value,1999,AppYearInt+10);
       end;
     end; {Case}
    end

    else if ExtractNonInstFormName(FormName) = 'AS5' then //pg2
    begin
     case FieldId of
      104,111,118,125,134,141,148,155:
       begin
       AutoFormatDate(Value);
       Result:= InDateOnly(Value,1999,AppYearInt+10);
       end;
     end; {Case}
    end


   //20231024
   (*
    else if FormName = 'AS9' then
    begin
     case FieldId of
      32,33: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end
    *)

    else if ExtractNonInstFormName(FormName) = 'AS9SUP' then   //201301
    begin
     case FieldId of
      23: begin AutoFormatDate(Value); Result:=InDateOnly(Value,1900,AppYearInt+1);end;
     end; {Case}
    end


    else if FormName = 'AS10' then
    begin
     case FieldId of
      10,15,20: begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end; {case}
    end

  //20261006 Alex >>>
  else if (LeftStr(FormName, 3) = 'S52') then
  begin
    case FieldId of
      1, 30, 32, 34:
        begin
          AutoFormatDate(Value);
          Result:= InDateYYYYMMDDonly(Value, AppYearInt + 1);
        end;
      3, 4: ValidateDoubleCheckbox(3, 4);
    end;
  end
  //20261006 Alex <<<


 else if ExtractNonInstFormName(FormName) = 'SUPPL' then
    begin
     (*
     case FieldId of
     2,5,7:begin Result :=InValuesOnly('Y,N',RetNo,FormName,FieldId,Value);exit;end;
     6:begin Result :=InValuesOnly('1,2,3',RetNo,FormName,FieldId,Value);exit;end;
     end; {case}
    *)
    end;
end;



Function InDateYYYYMMDDonly(Value:string;MxYear:integer):Boolean;
begin
  Result := InDateYMDonly(Value,1880,MxYear,'/');
end;


procedure TMyChildT2_2027.FormKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
Var
  MyScrollBox:TvtScrollBox;
  MyEditBox:TvtEdit;
  FieldId:Integer;
begin
  MyScrollBox:=GetScrollBox(FormName);

 //Check for VtEdit
  If ActiveControl is TvtEdit then
  begin
    MyEditBox:=ActiveControl As TvtEdit;
    FieldId:=GetFieldId(MyEditBox.Name);

    //if (FormNo = getFormNo('T2')) and (FieldId = 745) then
    if (MyScrollBox.FormName = 'T2') and (FieldId = 745) then
    begin
       //DataChanged:=True;
       MyScrollBox.SaveEditBoxText(FieldId,MyEditBox.Text);
       MyEditBox.Refresh;
    end;
  end;
end;


procedure TFormT2_2027.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TFormT2_2027.FormKeyPress(ActiveControl: TControl;
  var Key: Char);
//procedure TMyChildT2_2013.FormKeyPress(Sender: TObject; var Key: Char);
var
  FieldId:Integer;
  MyEditBox:TvtEdit absolute ActiveControl;
  FOriginalOnChange: TNotifyEvent;
begin
  inherited;
  if Key = #0 then exit;

  if not (ActiveControl is TvtEdit) then
    exit; //only Editbox here

 //other keys

  FieldId:=GetFieldId(MyEditBox.Name);
  If (MyEditBox.vtDataSource=vtCalc)
  or ((FormName='INVOICE') and (IsInvoiceLocked(RetNo)) and (fieldid <> 285))  //20160417
  then
  begin
    //20170502 Igor >>>
    //which field types can be overridden? --> vtCalc only

  //20170612 Igor >>>
    if MyEditBox.vtAllowOverride and
       (MessageDlg('Protected field - override?', mtConfirmation, mbOKCancel, 0)  = mrOk) then    //start override
      ToggleOverride(MyEditBox)
    else
    begin
      FOriginalOnChange := MyEditBox.OnChange;
      try
        MyEditBox.OnChange := Nil;
        MyEditBox.Undo;
        MyEditBox.ClearUndo;
        MyEditBox.Modified := False;
      finally
        MyEditBox.OnChange := FOriginalOnChange;
      end;
    end;
    //20170612 Igor <<<
    //    Key:=Chr(0);
     //    ShowTimedMsg('Protected or Calculated field',1000);
    //    Exit;
    //20170502 Igor <<<
  end;
end;

(*
    case MessageDlg('Protected field - override?', mtConfirmation, mbOKCancel, 0) of
      mrOk: //start override
        ToggleOverride(MyEditBox)
    else
      begin
        FOriginalOnChange := MyEditBox.OnChange;
        try
          MyEditBox.OnChange := Nil;
          MyEditBox.Undo;
          MyEditBox.ClearUndo;
          MyEditBox.Modified := False;
        finally
          MyEditBox.OnChange := FOriginalOnChange;
        end;

      end;
    end
//    Key:=Chr(0);
//    ShowTimedMsg('Protected or Calculated field',1000);
//    Exit;
    //20170502 Igor <<<
  end;
end;
*)

procedure TMyChildT2_2027.FormPaint(Sender: TObject);
Var
 i:integer;
begin
  Caption:=GetReturnCaption(RetNo);
end;

function TMyChildT2_2027.GetHeaderFrame: TFrame; //20160227 Igor
begin
  Result := MyFormHeaderFrame;
end;

function TMyChildT2_2027.GetMonitorFrame: TFrame;  //20160227 Igor
begin
  Result := MyMonitorFrame;
end;

procedure TMyChildT2_2027.UpdateChildTaxPanel;
begin
  if assigned(RetList[Self.RetNo]) AND RetList[Self.RetNo].isAppendix then //20160704 Igor
    exit;

  If RetInMem = 0 then
  begin
    MyMonitorFrame.NetIncPanel.Caption := '';
    MyMonitorFrame.TxblIncPanel.Caption := '';
   // MyMonitorFrame.OntPay.Caption := '';
  //  MyMonitorFrame.OntPaylbl.Caption:='';  //20090711
    MyMonitorFrame.AlbPay.Caption := '';
    MyMonitorFrame.FedPay.Caption := '';
    MyMonitorFrame.FedPay.Color := clBtnFace;
    exit;
  end;

  //If IsRetNoListed(RetNo) then
  begin
    MyMonitorFrame.FedPay.Color   := GetRetColor(RetNo);
    {?}
    FormatSettings.DecimalSeparator :='.';
    MyMonitorFrame.NetIncPanel.Caption  := FormatFloat('##,###,###',GetNetInc(RetNo));
    MyMonitorFrame.TxblIncPanel.Caption :=FormatFloat('##,###,###',Round(Ret[RetNo].Ln[360]));  //20201016
    //FormatFloat('##,###,###',Round(Vl(FetchElm(RetNo,'T2',234)))); //20130501

    MyMonitorFrame.TotalTaxPanel.Caption := FormatFloat('##,###,###',
       Round(Vl(FetchElm(RetNo,'T2',714)))+Vl(FetchElm(RetNo,'AT1',118))); //20200824
    If Vl(FetchElm(RetNo,'T2',732)) >0 then
    begin
      MyMonitorFrame.FedPaylbl.Caption := 'Federal Refund:';
      MyMonitorFrame.FedPay.Caption:=FormatFloat('##,###,###', Vl(FetchElm(RetNo,'T2',732)));
    end
    else
    begin
     MyMonitorFrame.FedPaylbl.Caption := 'Federal Owing';
     MyMonitorFrame.FedPay.Caption:=FormatFloat('##,###,###', Vl(FetchElm(RetNo,'T2',733)));
    end;

    {ontario}
    If Ret[RetNo].OntCalcStatus = False then CalcOnt(RetNo); //20090711

    {Alberta}
    If Ret[RetNo].AlbCalcStatus = False then
       MyMonitorFrame.AlbPay.Font.Style := [fsBold,fsStrikeOut]
    else
       MyMonitorFrame.AlbPay.Font.Style := [fsBold];

    If Vl(FetchElm(RetNo,'AT1',125)) <0 then
    begin
      MyMonitorFrame.AlbPaylbl.Caption := 'Alberta Refund';
      MyMonitorFrame.AlbPay.Caption := FormatFloat('##,###,###',ABS(Vl(FetchElm(RetNo,'AT1',125))));
    end
    else
    begin
      MyMonitorFrame.AlbPaylbl.Caption := 'Alberta Owing';
      MyMonitorFrame.AlbPay.Caption := FormatFloat('##,###,###',Vl(FetchElm(RetNo,'AT1',125)));
    end;
  end; {retno>0}
end;

Procedure TMyChildT2_2027.Keys(Var Key: Word; Shift: TShiftState);
var
  Handled: boolean;
begin
  if Shift = [] then //Ctrl etc. in ShortCuts!
  begin
   {PLAIN F KEYS}
    Handled := True;
    {F1, F2 are in short cut}
   // If    (Key = VK_F1) then begin MainForm.HelpBtnClick(Application);exit;end;
   // If    (Key = VK_F2) then begin MainForm.SelectFormClick(Application);exit;end;
    If    (Key = VK_F3) then MainFormT2.FileSaveAsItemClick(Application)
    else If    (Key = VK_F4) then OpenForm(RetNo,GetFormNo('TAXSUM'),0)
    else If    (Key = VK_F5) then MainForm.GuiCommand(gcToggleLeftPanel) //MainForm.LeftPanel.Visible:= Not MainForm.LeftPanel.Visible //20160222 Igor
    else If    (Key = VK_F7) then MainFormT2.Switchforms1Click(Application)
    else If    (Key = VK_F8) then MainFormT2.SwapBtnClick(Application)
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end;

  {CTRL 1 to 8}
  if (Shift = [ssCtrl]) then
  begin
    Handled := True;
    if      (Key = 49) then OpenForm(RetNo,GetFormNo('S1'),0)
    else if (Key = 50) then OpenForm(RetNo,GetFormNo('S2'),0)
    else if (Key = 51) then OpenForm(RetNo,GetFormNo('S3'),0)
    else if (Key = 52) then OpenForm(RetNo,GetFormNo('S4'),0)
    else if (Key = 53) then OpenForm(RetNo,GetFormNo('S5'),0)
    else if (Key = 54) then OpenForm(RetNo,GetFormNo('S6'),0)
    else if (Key = 55) then OpenForm(RetNo,GetFormNo('S7'),0)
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
    If Key = 83 then MainFormT2.SwapReturns1Click(Application) {Alt S}
    else If Key = 71 then  MainFormT2.CurrentPage1Click(Application) {Alt G}
    else If Key = 77 then  MainFormT2.PrintForm1Click(Application) {Alt M}
    else if Key = 88 then MainFormT2.FileCloseItemClick(Application) {Alt x}
    else  Handled := False;
    if Handled then begin Key := 0; exit; end;
  end; {Alt keys}

  inherited;
end;


Procedure TMyChildT2_2027.UpdateFormHeaderFrame;
var
  NmInfo,FormInfo:String;

  vis: boolean;

begin
  if not UpdateSectionButtons(MyFormHeaderFrame) then
    exit; //invalid RetNo...
  if assigned(RetList[Self.RetNo]) AND RetList[Self.RetNo].isAppendix then //20160704 Igor
    exit;

 //NmInfo:=AllTrim(UpperCase(GetCorpName(RetNo)));
 NmInfo:=AllTrim(UpperCase(GetReturnCaption(RetNo)));
 FormInfo:=AllTrim(GetFormAbrevName(FormNo));
 //MyFormHeaderFrame.ReturnNameLbl.Caption:=NmInfo;
 MyFormHeaderFrame.FormNameLbl.Caption:=' '+FormInfo;

  vis := IsFormMultiInst(FormName)
                  and (LeftStr(FormName,6) <> 'FLDMEM')
                  and (LeftStr(FormName,7) <> 'FLDTAPE');
  MyFormHeaderFrame.ListMultipleBtn.Enabled := vis;
  MyFormHeaderFrame.MultipleDnBtn.Enabled := vis;
  MyFormHeaderFrame.MultipleUpBtn.Enabled := vis;
 //MyFormHeaderFrame.SectionBtn.visible:=(IsFormMultipage(FormName)); // or (FormName='INFO');

  MyFormHeaderFrame.CloseTabBtn.Visible :=  FormName <> 'T2';
end;

procedure TMyChildT2_2027.CloseActiveForm(Sender: TObject);
Var j:Integer;
begin
  j:=MyPageControl.ActivePageIndex;
  MyTabSheet:=MyPageControl.Pages[j];

  If MyTabSheet.Caption = 'T2' then
  //If leftstr(MyTabSheet.Caption, 5) = 'T2' then
  begin
   ShowMessage('You cannot close the T2 jacket'
    +Chr(13)+'You can close the Return instead');
   Exit;
  end;
  inherited;
end;

Function TFormT2_2027.GetValueFromList(MyEditBox:TvtEdit;FieldId:Integer):String;
begin
  Result :='';
//populate the picklist

  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Valid entries';
  Result :=PopulatePickList(FieldId);   //20150806


  If (FormName='T2') and (FieldId=203) then exit;  //20111122

  //nisa done another way via usearchlist
  If (ExtractNonInstFormName(FormName)='T1273')
  or (ExtractNonInstFormName(FormName)='T1273A1')  //20121017
  or (ExtractNonInstFormName(FormName)='T1273A2')
  or (ExtractNonInstFormName(FormName)='T1163')
   or (ExtractNonInstFormName(FormName)='T1273CIV')
  or (ExtractNonInstFormName(FormName)='T1273LIV')
  or (ExtractNonInstFormName(FormName)='T1273ALI')
  or (ExtractNonInstFormName(FormName)='T1273OTH')
  then begin SelectedString:=Result;exit;end;

  if Result = '' then
  begin
    SelectedString := PopSomeList(SomeList,SomeCaption,MyEditBox);
    //SomeList.Free; //abends
    result:=CleanUpPickedListValue(FieldId,SelectedString);
  end;
  SelectedString:=Result;  //??
end;

function TFormT2_2027.GetisDraft: Boolean; //20161212 Igor
begin
  Result := T2_2027Declare.isDraft;
end;

Function TFormT2_2027.GetLinkedForm(FieldId:Integer;Var TargetLinkedField:Integer):String;
Var
  I, j, Fld: integer;
  Frm, InFrm: string;
  LinkList: TstringList;
  Wlist: TStringList;
  s: String;
begin
  Result := '';
  TargetLinkedField:=0;
  (* 20141026
  If (FormName='LABORSP') and (FieldId=1) then
  begin Result:=FetchElm(RetNo,'LABORSP',1); Exit; end;
  If ((LeftStr(FormName,5)='T4RIF') and (FieldId=17))
  or ((LeftStr(FormName,5)='T4RSP') and (FieldId=22)) then
  begin  Result:='T2205'; Exit; end;
  *)
  LinkList := TStringList.Create;
  //20170515 Igor >>>
  try
  //20170515 Igor <<<
    Linklist.LoadFromFile(Appdir+'\'+'LINKLIST.D');
    InFrm := Rtrim(ExtractNonInstFormName(FormName));

    //multiple linked forms
    WList:=TStringList.Create;
    //20170515 Igor >>>
    try
    //20170515 Igor <<<
      For i := 0 to LinkList.Count -1 do
      begin
        Frm := RTrim(ExtractNonInstFormName(LeftStr(LinkList[i],10)));
        If InFrm = Frm then
        begin
          Fld := MyStrToInt(MidStr(LinkList[i],11,3));
          If Fld = FieldId then
          begin
            s:=AllTrim(MidStr(LinkList[i],15,80));
            ParseWords(S,',',WList);
            If Wlist.Count = 1 then  {just one linked form}
            begin
              //wordformat is fffffff#n/5
              If ExtractFormInst(Rtrim(InFrm)) > '' then
                Result := ExtractFormSlashField(WList[0],TargetLinkedField)+ExtractFormInst(Rtrim(FormName))
                       //Rtrim(ExtractNonInstFormName(LeftStr(WList[0],10)))
              else
                Result :=ExtractFormSlashField(WList[0],TargetLinkedField);
              //20170515 Igor >>>
              //WList.free;
              //LinkList.Free;
              //20170515 Igor <<<
              exit;
            end //end single link
            Else
            If Wlist.Count > 1 then
            begin
              SomeList.Clear;  // := TStringList.Create;
              For j:=0 to WList.Count-1 do
                SomeList.Add(PaddR(WList[j],20)+GetFormAbrevNameWithNoInst(GetFormNo(WList[j])));
              SelectedString := PopSomeList(SomeList,'Select from Linked forms');
              //SomeList.Free; //20160704 Igor
              If SelectedString > '' then
              begin
                Result:=AllTrim(LeftStr(SelectedString,20));
                //20170515 Igor >>>
                //WList.free;
                //LinkList.Free;
                //20170515 Igor <<<
                exit;
              end;
            end;
          end; //matching fieldid
        end; //found entry
      end;
    //20170515 Igor >>>
    finally
      WList.free;
    end;
    //20170515 Igor <<<
    //nothing found
    UserMsg('nothing linked to '+InFrm+'.vtEdit'+IntToStr(FieldId));
  //20170515 Igor >>>
  finally
    LinkList.Free;
  end;
  //20170515 Igor <<<
end;

//20150707
Function TFormT2_2027.PopulateIrregularPickList(ebox:TvtEdit;FieldId:Integer;SomeList:TStringList):Boolean;
Var
  i:Integer;
  s,FromFname:string;
  FromElm:integer;
begin
  result := false;
end;

Function TFormT2_2027.PopulatePickList(FieldId:Integer):String;  //20150806
Var i:Integer;s,FromFname:String;FromElm:Integer;
   FromLine,ToLine:String;

begin
  //SysUtils.FreeAndNil(SomeList);  //20150806 //20160704
  if not assigned(SomeList) then //20160704 Igor
    SomeList:=TSingleStringList.Create; //20150806
  SomeList.Clear; //20160704 Igor

  Result:='';
  //20150816 GIFI-s100
  //If LeftStr(FormName,4)='S100' then
  If (FormName='S100') or (FormName='S101') then
  begin
   Result:='';
   Somelist.Clear;
  //20150809
   if SplitDynId(RetNo,FormNo, FieldId) and (ColNo < 2) then begin
    case ArrayNo of
      1: PopBSGifiLines('1000','1486');   //current assets
      2: PopBSGifiLines('1600','1922');  //tangible assets
      3: PopBSGifiLines('2010','2077');  //intangible
      4: PopBSGifiLines('2180','2590');  //long term   //2487 plus 2590 held in trust
      5: PopBSGifiLines('2600','3139');  //curr liab
      6: PopBSGifiLines('3140','3470');  //long term liab to 3460 plus in trust 3470
      7: PopBSGifiLines('3520','3580');  //Equity except Common
      8: PopBSGifiLines('3700','3745');  //div and adj
    end;
   end;
   Exit;
  end  //s100 and s101

  Else If ExtractNonInstFormName(FormName) = 'S29L'  then //20210722
  begin
     case FieldId of
     1,8,15,22,29,36,43,50,57,64,71,78,85,92,99,106,113,120,127,134,141:
      begin
        GetListOfS60Projects(RetNo,Somelist);
      end;
     end; //case
   end
  //20260508 Alex >>>
  else if (LeftStr(FormName, 3) = 'S75') then
  begin
    case FieldId of
      22, 28, 34, 40, 46, 52, 114, 120, 126, 132, 138, 144: SomeList.LoadFromFile(AppDir + '\' + 'State.d'); //20260811 Alex
      4, 6,8, 10, 12, 14, 100, 102, 104, 106, 108, 110: for i:= Low(CCARates) to High(CCARates) do SomeList.LoadFromFile(AppDir + '\' + 'CCARates.D'); //20260811 Alex
    end;
  end



  else if (LeftStr(FormName, 3) = 'S77') then
  begin
    case FieldId of
      13, 26, 39, 52, 65, 111, 123, 135, 147, 159, 171, 189, 195, 201, 207, 213, 219: SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      12, 25, 38, 51, 64, 110, 122, 134, 146, 158, 170, 188, 194, 200, 206, 212, 218:
      begin
        SomeList.Add('    ');  //20260416
        SomeList.Add('01 Wind energy conversion systems');
        SomeList.Add('02 Small-scale hydro-electric installations');
        SomeList.Add('03 Photovoltaic equipment');
        SomeList.Add('04 Water-current, tidal, or wave energy equipment');
        SomeList.Add('05 Geothermal energy equipment');
        SomeList.Add('09 Fixed location energy storage equipment');
        SomeList.Add('10 Pumped hydroelectric energy storage');
        SomeList.Add('13 Concentrated solar energy equipment');
        SomeList.Add('16 Nuclear energy property');
        SomeList.Add('17 Waste biomass electricity generation equipment');
        SomeList.Add('19 Qualified natural gas energy equipment');
        SomeList.Add('20 Qualified interprovincial transmission equipment');
        SomeList.Add('21 Large-scale hydro-electric installations');
      end;
    end;
  end

  //20260508 Alex <<<
  //20240730 Igor >>>
  else if (LeftStr(FormName, 4) = 'T217') then
  begin
    case FieldId of
      12:
        SomeList.LoadFromFile(AppDir+'\'+'State.d');
    end;
  end
  else if (LeftStr(FormName, 5) = 'T2054') then
  begin
    case FieldId of
      4:
        SomeList.LoadFromFile(AppDir+'\'+'State.d');
    end;
  end
  //20240730 Igor <<<

  //20240724 Igor >>>
  else if (LeftStr(FormName,4) = 'UHT#') then
  begin
    case FieldId of
      6, 14, 27:
        SomeList.LoadFromFile(AppDir+'\'+'State.d');
      15, 7:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end;
  end

  else if (LeftStr(FormName,4) = 'T217') then
  begin
    case FieldId of
      5:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
    end;
  end
  //20240724 Igor <<<

  else If (LeftStr(FormName, 5) = 'T2058') then
  begin
    case FieldId of
      17, 41:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      18:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end;
  end

  //20240725 Igor >>>
  else If (LeftStr(FormName, 5) = 'T2059') then
  begin
    case FieldId of
      17, 41:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      18:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end;
  end

   else If (LeftStr(FormName,5) = 'T2057') then
   begin
    case FieldId of
      17, 41:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      18:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end;
   end
  //20240725 Igor <<<

  //20250826 Igor >>>
  else
  if (LeftStr(FormName, 5) = 'T1521') then
  begin
    case FieldId of
      17, 24, 32:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      26, 34:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end;
  end
  //20250826 Igor <<<

  //20250901 Igor >>>
  else
  if (LeftStr(FormName, 5) = 'T2055') then
  begin
    case FieldId of
      17:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
    end;
  end else
  if (LeftStr(FormName, 5) = 'T2123') then
  begin
    case FieldId of
      17, 25, 36, 43, 78, 93, 108, 123, 135, 147, 160, 172, 184:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      34, 45, 125, 137, 149, 162, 174, 186:
        SomeList.LoadFromFile(AppDir + '\' + 'Country.d');
    end;
  end
  //20250901 Igor <<<

  //20150813  //GIFI-s125
  Else If ExtractNonInstFormName(FormName)='S125' then //20160907 igor
  begin
   Result:='';
   Somelist.Clear;
  //20150809
   if SplitDynId(RetNo,FormNo, FieldId) and (ColNo < 2) then begin //20150812 same handling of column 1 and 2?
    case ArrayNo of
      1: PopIsGifiLines('8000','8088');   //revenue
      2: PopIsGifiLines('8090','8250');  //other income
      3: PopIsGifiLines('8300','8503');  //cost of sales
      4: PopIsGifiLines('8520','9286');  //Operating expenses
      5: PopIsGifiLines('9370','9650');  //Farming Revenue
      6: PopIsGifiLines('9660','9870');  //Farming expenses
    end;
   end;
   Exit;
  end  //s125

 Else If FormName = 'T2' then  //PAGE_3 //20111122
   case FieldId of

      72:begin
         for i := 0 to length(functionalCurrency_N)-1 do SomeList.Add(functionalCurrency_N[i]); //jz 20240424
         exit;
        end;

   203: //naics
     begin
        ExecuteForm(TSICT2_2027);
        If SelectedString>'' then
          Result:=SelectedString
        Else
          Result:='';
        Exit;
     end;
   2: for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvLong[i]);
    {10,11: begin SomeList.Free;Result:=FetchADate;exit; end;}
   62: begin
         SomeList.Add('N/A');
         SomeList.Add('Bank');
         SomeList.Add('Credit Union');
         SomeList.Add('Financial Institution');
         SomeList.Add('Investment Corporation');
         SomeList.Add('Life Insurance Corporation');
         SomeList.Add('Insurance Corporation');
         SomeList.Add('Mutual Fund Corporation');
         SomeList.Add('Non-resident Owned Investment Corp.');
         SomeList.Add('Co-operative Corporation');
         SomeList.Add('Subject Corporation');
         SomeList.Add('Trust or Loan Corporation');
        end;
   17,33,45: Somelist.LoadFromFile(AppDir+'\'+'State.d');
   19,34,46: SomeList.LoadFromFile(AppDir+'\'+'Country.d');
   50:SomeList.LoadFromFile(AppDir+'\'+'Country.d');

   731: begin
         SomeList.Add('    ');  //20260416
         SomeList.Add('1 Refund Overpayment');
         SomeList.Add('2 Transfer to next year instalment account');
         SomeList.Add('3 Apply to another liability (attach instructions)');
        end;
   end;


  //20180614
  If (FormName = 'CBCR') then
  Begin

   case fieldId of

      1:begin              //20180620
         for i := 0 to length(functionalCurrency_N)-1 do SomeList.Add(functionalCurrency_N[i]); //jz 20240424
         //SomeList.Add('USD=US dollar');SomeList.Add('GBP=GB Pound Sterling)');SomeList.Add('AUD=AU Dollar)');SomeList.Add('EUR=Euro)');
        end;
      18,26:Begin Somelist.LoadFromFile(AppDir+'\'+'Country.d');end;
    end; //case field id case
   //20180613
   i:=38;
   repeat
    if FieldId=i then Begin Somelist.LoadFromFile(AppDir+'\'+'Country.d');end;
    Inc(i,11);
   until i>555;

   i:=616;
   repeat
    if FieldId=i then Begin Somelist.LoadFromFile(AppDir+'\'+'Country.d');end;
    Inc(i,21);
   until i>1540;

   i:=619;
   repeat
    if FieldId=i then Begin Somelist.LoadFromFile(AppDir+'\'+'Country.d');end;
    Inc(i,21);
   until i>1543;

   i:=621;
   repeat
    if FieldId=i then Begin Somelist.LoadFromFile(AppDir+'\'+'Country.d');end;
    Inc(i,21);
   until i>1545;

   i:=622;
   repeat
    if FieldId=i then Begin Somelist.LoadFromFile(AppDir+'\'+'Country.d');end;
    Inc(i,21);
   until i>1546;

   i:=1588;
   repeat
    if FieldId=i then Begin Somelist.LoadFromFile(AppDir+'\'+'Country.d');end;
    Inc(i,1);
   until i>1611;

   i:=1612;
   repeat
    if FieldId=i then Begin Somelist.LoadFromFile(AppDir+'\'+'CBCSumRef.d');end;
    Inc(i,1);
   until i>1635;

   if (FieldId >= 1636) and (FieldId <= 1680) then
   begin
     SomeList.Add('CBC801 - Ultimate Parent Entity');
     SomeList.Add('CBC802 - Reporting Entity');
     SomeList.Add('CBC803 - Both Ultimate Parent Entity and Reporting Entity');
   end;

   if (FieldId >= 1681) and (FieldId <= 1688) then
   begin
     SomeList.Add('EN English');
     SomeList.Add('FR French');
   end;

  end;  //formname

  //20180507
  If FormName = 'T1134' then
  Begin
  	//20230411 Igor >>>
    FieldId := GetFirstElmId(RetNo,FormNo,FieldId); // if FieldId is dynamic, change it to the corresponding id of first row
    case FieldId of
     40,41,42,43:SomeList.LoadFromFile(AppDir+'\'+'NAICS.d'); //20230510 Igor
     24:begin

           for i := 0 to length(functionalCurrency_N)-1 do SomeList.Add(functionalCurrency_N[i]); //jz 20240424
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
  End;

  //20180507
  //20230411 Igor >>>
  If LeftStr(FormName,7) = 'T1134S#' then
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
     10012,16,18,79,83,87,91,95,99,103,107,111:SomeList.LoadFromFile(AppDir+'\'+'Currency.d');
    end; //case;
  end;
  //20230411 Igor <<<

  If (FormName = 'T661') then
     case FieldId of
      20,26,32,38,44,50,56,62,68,74,80,86,92:
         begin
           SomeList.Add('1 Contingency fee arrangement (based on %)');
           SomeList.Add('2 Hourly rate');
           SomeList.Add('3 Daily rate');
           SomeList.Add('4 Flat fee arrangement (lump sum)');
           SomeList.Add('5 Other arrangements');
          end;
  end //case T2

  else
  If (FormName = 'T661') then
     case FieldId of
      20,26,32,38,44,50,56,62,68,74,80,86,92:
         begin
           SomeList.Add('1 Contingency fee arrangement (based on %)');
           SomeList.Add('2 Hourly rate');
           SomeList.Add('3 Daily rate');
           SomeList.Add('4 Flat fee arrangement (lump sum)');
           SomeList.Add('5 Other arrangements');
         end;
      end

  else
  If (FormName = 'S6RE') then
     case FieldId of
     3,14,25,36,47,58,69,80,91,102,113,124,135,146,157,168,179,190,201:Somelist.LoadFromFile(AppDir+'\'+'State.d');
     212,223,234,245,256,267,278,289,300:Somelist.LoadFromFile(AppDir+'\'+'State.d');
     4,15,26,37,48,59,70,81,92,103,114,125,136,147,158,169,180,191,202:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
     213,224,235,246,257,268,279,290,301:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
   end
   else
   If (FormName = 'S3') then
     case FieldId of
     5,14,23,32,41,50,59,68,77,86:
     begin
      Somelist.add('2 Not connected Corp');
      Somelist.add('1 Connected Corp.');
     end;
    end
   else

   If (FormName = 'S5') then
     case FieldId of
     104:
     begin
      Somelist.add('402 - General Rules: Col B:Salaries, D: Gross Revenue');
      Somelist.add('403 - Insurance Corporations: B:No entry D:Net premiums');
      Somelist.add('404 - Chartered Banks: B:Salaries  D: Loans and Deposits');
      Somelist.add('405 - Trust and Loan Corporations: B:No entry  D:Gross Revenue');
      Somelist.add('406 - Railway Corporations:  B:Miles/Kilometers  D: Gross ton miles/kilom.');
      Somelist.add('407 - Airline Corporations: B:Capital cost of assets  D:Revenue plane mile/Kilom');
      Somelist.add('408 - Grain Elevator Corporations: B:Salaries  D:Bushels of grain reveived');
      Somelist.add('409 - Truck and Bus Operators:  B:salaries  D: Miles/Kilometers travelled');
      Somelist.add('410 - Ship Operators:  B:Salaries  D: Port-call-tonnage');
      Somelist.add('411 - Pipeline Operators:  B:Salaries  D:Miles/kilometers of pipeline');
      Somelist.add('412 - Divided Business: Col B and D: Refer to regulation');
      Somelist.add('413 - Non-resident Corporations: Col B and D: Refer to regulation');
     end;
   end

   else  //20141025  //20231231
   If FormName = 'S8ALL' then //20140802
   begin
    If IsNumberInSet(FieldId,900,9441,4)=true then Somelist.LoadFromFile(AppDir+'\'+'Cls43Codes.d');
    If IsNumberInSet(FieldId,901,945,4)=true then for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);

   //  If IsNumberInSet(FieldId,403,631,4)=true then Somelist.LoadFromFile(AppDir+'\'+'Cls43Codes.d');
   //  If IsNumberInSet(FieldId,404,632,4)=true then for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
   end

   else  //20260713
   If (LeftStr(FormName,3) = 'S8#') then
   begin
    case FieldId of 293,294,295,296,297,298,299,300,301,202:
       Somelist.LoadFromFile(AppDir+'\'+'PropertyTypes.d');
    end;
   end

   else
   If (FormName = 'S9') then
     case FieldId of
     5,14,23,32,41,50,59,68,77,86,95,104,113,122,131,
        140,149,158,167,176:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
     7,16,25,34,43,52,61,70,79,88,97,106,115,124,133,
     142,151,160,169,178,186:                       //20170726 added 186
     begin
      Somelist.add('1 Parent');
      Somelist.add('2 Subsidiary');
      Somelist.add('3 Associated');
      Somelist.add('4 Related but Not associated');
     end;
     185:
     Begin
      Somelist.LoadFromFile(OptRec.Dir_Cur+'\'+'GroupInfo'+'\'+'GroupInfo.txt');
     End;
   end
   else
   If (FormName = 'S11') then
     case FieldId of
     4,11,18,25,32,39,46,53,60,67,74,81,88:
     begin
      Somelist.add('1 Shareholder');
      Somelist.add('2 Officer');
      Somelist.add('3 Employee');
     end;
   end
   else

   If (FormName = 'S12') then
    case FieldId of
      501,502,503,504,505:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
      551,552,553,554,555:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
    end
    else

   If (FormName = 'S12') then
    case FieldId of
      601,602,603,604,605:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
      651,652,653,654,655:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
    end
    else

   If (FormName = 'S14') then
     case FieldId of
     8,20,32,44,56,68,80,92,104,116:Somelist.LoadFromFile(AppDir+'\'+'State.d');
     9,21,33,45,57,69,81,93,105,117:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
   end

   else
   If (FormName = 'S444') then   //20201023
   begin
     case FieldId of
     21,28,35,42,49,56,63,70,77,84,91,98,105,112,119,126,133,140,
     147,154,161,168,175,182,189,196,203,210:
      Somelist.LoadFromFile(AppDir+'\'+'YTClassS444.d');
     //20231109  //miissing 233   //20240318
     219,226,233,240,247,254,261,268,275,282,289,296,303,310,317,324,331,338,345,352,
     359,366,373,380,387,394,401,408:
      Somelist.LoadFromFile(AppDir+'\'+'YTClassS444.d');
    end;
   end

   else
   If (FormName = 'RC59') then
     case FieldId of
     16, 22, 29, 36, 43:
     begin
      Somelist.add('01  View Only');
      Somelist.add('02  Allow Update Access');
      Somelist.add('03  Delegate Authority (Efile Only)');
     end;
     17,24,31,38:
     begin
      Somelist.add('RC Corporate income tax');
      Somelist.add('RT Goods and Services tax');
      Somelist.add('RP Payroll deductions');
      Somelist.add('RM Import/Export (no online access');
      Somelist.add('RE Excise Tax');
      Somelist.add('RN Insurance Premium Tax');
      Somelist.add('RD Excise Duty');
      Somelist.add('RG Air Travelers Security Charge');
      Somelist.add('SL Softwood Lumber Products Export Charge');
     end;
   end

else      //20180801
   If (FormName = 'RC59X') then
     case FieldId of
     28,41:
     begin
      Somelist.add('RC Corporate income tax');
      Somelist.add('RT Goods and Services tax');
      Somelist.add('RP Payroll deductions');
      Somelist.add('RM Import/Export (no online access');
      Somelist.add('RE Excise Tax');
      Somelist.add('RN Insurance Premium Tax');
     Somelist.add('RD Excise Duty');
      Somelist.add('RG Air Travelers Security Charge');
      Somelist.add('SL Softwood Lumber Products Export Charge');
     end;
   end



   else   If (ExtractNonInstFormName(FormName) = 'S60') then //20160907 Igor
   case FieldId of
      7:Somelist.LoadFromFile(AppDir+'\'+'T661Cd.d');
      43:Somelist.LoadFromFile(AppDir+'\'+'S60RDF.d');  //jz//20260526
   end


   else //20200215
   If (lEFTSTR(FormName,7) = 'CONSENT') then
     case FieldId of
     16, 22, 29, 36, 43:
     begin
      Somelist.add('01  View Only');
      Somelist.add('02  Allow Update Access');
      Somelist.add('03  Delegate Authority');
     end;
     17,24,31,38:
     begin
      {
      Somelist.add('RC Corporate income tax');
      Somelist.add('RT Goods and Services tax');
      Somelist.add('RP Payroll deductions');
      Somelist.add('RM Import/Export');
      Somelist.add('RE Excise Tax');
      Somelist.add('RN Insurance Premium Tax');
      Somelist.add('RD Excise Duty');
      Somelist.add('RG Air Travelers Security Charge');
      //Somelist.add('SL Softwood Lumber Products Export Charge'); //jz vt49 20241107 removed as per specs
      }

      //jz vt49 20241107
      //new Business program identifiers as per specs
      Somelist.add('CT = Carbon Levy');
      Somelist.add('LT = Luxury Tax');
      Somelist.add('RC = Corporation income tax');
      Somelist.add('RD = Excise duty');
      Somelist.add('RE = Excise tax');
      Somelist.add('RG = Air travellers security charge');
      Somelist.add('RN = Excise tax on insurance premiums');
      Somelist.add('RP = Payroll deductions');
      Somelist.add('RR = Registered charities');
      Somelist.add('RT = Goods and services tax/harmonized sales tax (GST/HST)');
      Somelist.add('RU = Underused Housing Tax');
      //had to shorten RZ as cannot be over 255 char
      Somelist.add('RZ = Info returns (T5, T5007, T5008, T5013, T5018, TFSA, SAFER, RRSP, RRSP and RRIF non-qualified investments, and PRPP, Part XVIII – International Exchange of Info on Financial Accounts), Part XIX – International Exchange of Info on Financial Accounts');
      Somelist.add('ZA = Canada Emergency Rent Subsidy, Tourism and Hospitality Recovery Program – Rent, Hardest-Hit Business Recovery Program – Rent');

     end;
   end



   //20150705
   else If FormName = 'T1135' then   //20130720
   begin
     If FieldId>9999 then
       Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRYT1135.d');  //it includes OTH, but tbl: 1 and 5 cannot use OTH ! //20160123
     //20151212
     Case fieldId of
       21:begin
           for i := 0 to length(functionalCurrency_N)-1 do SomeList.Add(functionalCurrency_N[i]); //jz 20240624
          end;
       28:Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRY.d');  //20160123  //it does notinclude OTH
       57,58,59: Somelist.LoadFromFile(AppDir+'\'+'FCOUNTRYT1135.d');  //20160123
     end;
   end

   else If FormName = 'T1141' then
     case FieldId of
      14:Somelist.LoadFromFile(AppDir+'\'+'State.d');
   end;

   If FormName = 'T1142' then
     case FieldId of
      14:Somelist.LoadFromFile(AppDir+'\'+'State.d');
   end
   else

    If (FormName = 'S15') then
     case FieldId of
     4,14,24,34,44,54,64,74,84,94,104,114,124,134,144:  //20140608
        begin
        Somelist.add('1 RPP');
        Somelist.add('2 RSUBP');
        Somelist.add('3 DPSP');
        Somelist.add('4 EPSP');
        Somelist.add('5 PRPP (pooled registered pension plan)');
        end;

      10,20,30,40,50,60,70,80,90,100,110,120,130,140,150:Somelist.LoadFromFile(AppDir+'\'+'State.d');
      11,21,31,41,51,61,71,81,91,101,111,121,131,141,151:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
      13,23,33,43,53,63,73,83,93,103,113,123,133,143,153:
        begin
        Somelist.add('1 Trustee');
        Somelist.add('2 Employer');
        end;
   end
   else


   If (FormName = 'S21') then
     case FieldId of
     4,13,22,31,40:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
     50,60,70,80,90:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
   end
   else

   If (FormName = 'S22') then
     case FieldId of
     7,14,21,28,35,42,49,56:Somelist.LoadFromFile(AppDir+'\'+'State.d');
     8,15,22,29,36,43,50,57:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
   end

   else
   If (FormName = 'S23') then
     case FieldId of
     7,13,19,25,31,37,43,49,55,61,67,73,79,85,91,97,103,109,115,121:
     begin
      Somelist.add('1 Associated for purposes of allocating the business limit');
      Somelist.add('2 CCPC/third corp. that has elected under subsection 256(2) not to be associated for purposes of SBD');
      Somelist.add('3 non-CCPC/third corporation as defined in subsection 256(2)');
      Somelist.add('4 associated non-CCPC');
      Somelist.add('5 associated CCPC/third corporation that has elected not to be associated with for purposes of the SBD');
     end;
   end
   else

    If (FormName = 'S25') then
     case FieldId of
     6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66:
        begin
        Somelist.add('1 Controlled');
        Somelist.add('2 Other');
        end;
   end
   else

   If (FormName = 'S29') then
     case FieldId of
     7,15,23,31,39,47,55,63,71,79:Somelist.LoadFromFile(AppDir+'\'+'State.d');
     8,16,24,32,40,48,56,64,72,80:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
     10,18,26,34,42,50,58,66,74,82:
     begin
        Somelist.add('1 Royalties');
        Somelist.add('2 Rents');
        Somelist.add('3 Management Fees');
        Somelist.add('4 Technical Assistastance Fees');
        Somelist.add('5 Research and Development Fees');
        Somelist.add('6 Interest');
        Somelist.add('7 Dividends');
        Somelist.add('8 Film Payments');
        Somelist.add('9 Any Payments for regular services');
      //  Somelist.add('10 Other services'); //20110322
     end;
   end

   else
   If (FormName = 'S31') then //S31 pg3
     case FieldId of
      204,209,214,219,224,229,234:
        for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
   end

   Else   //20250607
   If (FormName = 'S76') then  //20250607
   Begin

    case FieldId of 4,15,26,37,48,59:
     for i := Low(CCARates) to High(CCARates) do
         SomeList.LoadFromFile(AppDir+'\'+'CCARates.D');
     end;

    case FieldId of 73,82,91,100,109,118:
     for i := Low(CCARates) to High(CCARates) do
         SomeList.LoadFromFile(AppDir+'\'+'CCARates.D');
     end;

     case FieldId of   //20250607
      7,18,29,40,51,62: for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
     end;

     case FieldId of   //20250607
      75,84,93,102,111,120: for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
     end;

     case FieldId of
        6, 17, 28, 39, 50, 61, 131, 132, 133, 134, 135, 136: //20260811 Alex
        begin
          SomeList.Add('    ');  //20260416
          SomeList.Add('01 Wind energy conversion systems');
          SomeList.Add('03 Solar energy conversion equipment (excluding passive solar heating equipment');
          SomeList.Add('04 Water energy conversion equipment');
          SomeList.Add('05 Geothermal energy equipment');
          SomeList.Add('06 Electric vehicle charging equipment');
          SomeList.Add('08 Electrical energy storage equipment');
          SomeList.Add('11 Hydrogen refuelling equipment');
          SomeList.Add('32 Nuclear energy equipment');
          SomeList.Add('33 Nuclear fuel rods, nuclear fuels, and heavy water');
          SomeList.Add('34 Air and ground source heat pump equipment');
          SomeList.Add('35 Zero-emission vehicle batteries or fuel cells');
          SomeList.Add('36 Zero-emission automotive equipment');
          SomeList.Add('37 Hydrogen production electrolysis equipment');
          SomeList.Add('   ---------------------------------------');
          SomeList.Add('   CMT codes for properties used all');
          SomeList.Add('    OR substantially all in a qualifying mineral');
          SomeList.Add('    activity producing qualifying materials:');
          SomeList.Add('30 Mineral activity property at mine or well sites');
          SomeList.Add('31 Mineral activity property other than at mine or well sites');
        end;
     end;
   end  //s76

    {
    else if FormName = 'S76' then  //20250610
    begin
     case FieldId of
      8,19,30,41,52,63,76,85,94,103,112,121:
       begin AutoFormatDate(Value); Result:=InDateOnly(Value,2000,AppYearInt+10);exit;end;
     end;
    end
    }

   Else   //20250608
   If (LeftStr(FormName,3) = 'S78') then  //20250607
   Begin
    case FieldId of 9,23,37,51,65,79,93,107,121,135, 193, 201, 209, 217, 225, 233, 241: //20260518 Alex
     begin
      Somelist.add('57 Equioment used on CCUS project (Carbon Capture,Utilization,and Storage)');
      Somelist.add('58 Equipment that is used solely to use carbon dioxide (CO2) in industrial production');
     end;
    end;

    //20250610
    case FieldId of 10,24,38,52,66,80,94, 194, 202, 210, 218, 226, 234, 242: //20260518 Alex
     begin
      Somelist.add('01 Carbon capture (ambient air)');
      Somelist.add('02 Carbon capture (other)');
      Somelist.add('03 Carbon transportation');
      Somelist.add('04 Carbon storage)');
      Somelist.add('05 Carbon use');
     end;
    end;

    case FieldId of 12,26,40,54,68,82,96,110,124,138:
    for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
    end;
   end

   else If FormName = 'S8ALL' then //20140802
   begin
     If IsNumberInSet(FieldId,403,631,4)=true then Somelist.LoadFromFile(AppDir+'\'+'Cls43Codes.d');
     If IsNumberInSet(FieldId,404,632,4)=true then for i := Low(PrvShort) to High(PrvShort) do SomeList.Add(PrvShort[i]);
   end

   else If (FormName = 'S49') then
   begin
    case FieldId of
     7,13,19,25,31,37,43,49,55,61,67,73,79,85,91,97,103,109,115,121:
      begin
       Somelist.add('1 CCPC');
       Somelist.add('2 Non-CCPC');
      end;
    end;
   end


   else If (FormName = 'S97') then
    case FieldId of
      4:SomeList.LoadFromFile(AppDir+'\'+'Country.d');
   end

   else
   begin
   If FormName = 'T106' then
     case FieldId of
     60:begin
           for i := 0 to length(functionalCurrency_N)-1 do SomeList.Add(functionalCurrency_N[i]); //jz 20240424
          end;

     35,36,37,38:Somelist.LoadFromFile(AppDir+'\'+'NAICS.d'); //35,36,37,38:Somelist.LoadFromFile(AppDir+'\'+'NAICS3d.d');

     //20260612CZ
     2,67,72: Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');  //jz 20241126 fields added //added 72 //20260611 20171128
     {
     begin
            Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');  //jz 20241126 field added with extra
            Somelist.add('0X5 CAN');
            Somelist.add('0X5 CAN');
     end;
     }
     3:
      begin
        SomeList.Add('1   New');
        SomeList.Add('2   Unmodified');
        SomeList.Add('3   Amended');
      end;

    end;

   If ExtractNonInstFormName(FormName) = 'T106SL' then //20160907 igor
     case FieldId of
      13:Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');  //20171128 CON
      19,20,21,22:Somelist.LoadFromFile(AppDir+'\'+'NAICS.d');  //20170907 CON 3 to 6 char codes
      //20170909 Igor <<<
      33,121,37,41,45,49,53,57,61,65,69,73,77,81,85,89,
      35,123,39,43,47,51,55,59,63,67,71,75,79,83,87,91:
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

      24,25,26,27:
       Somelist.LoadFromFile(AppDir+'\'+'FCountry.d');
     end;

   If (FormName = 'S389') then   //20180503
     case FieldId of
     19,27,35,43,51:
     begin
        Somelist.add('1 Hardcover');
        Somelist.add('2 Paperback');
        Somelist.add('3 Electronic');
     end;

     20,28,36,44,52:    //20180503
     begin
        Somelist.add('1 Fiction');
        Somelist.add('2 Non-fiction');
        Somelist.add('3 Poetry');
        Somelist.add('4 Drama');
        Somelist.add('5 Biography');
        Somelist.add('6 Children');
     end;
   end;

   If (ExtractNonInstFormName(FormName) = 'T1163') then //20160907 Igor
   case FieldId of
    14: begin for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]); end
   end;

   If (ExtractNonInstFormName(FormName) = 'T1273')
   then
   case FieldId of
    9,14: begin
       SomeList.Clear; //:=TStringList.Create; //20150806 //20160704 Igor
       for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]);
       SelectedString := PopSomeList(SomeList);
       //SomeList.Free; //20160704 Igor
       If SelectedString > '' then
        Result:=SelectedString
       else
        result:='';
       end;
    32:
    begin
      SomeList.Clear; //:=TStringList.Create; //20160704 Igor
      for i := Low(PrvLong) to High(PrvLong) do SomeList.Add(PrvShort[i]);
       SelectedString := PopSomeList(SomeList);
      //SomeList.Free; //20160704 Igor
      If SelectedString > '' then
        Result:=SelectedString
      else
        result:='';

      If (result='AB')  or (result='ON') or (result='PE')
      or (result='NU')  or (result='NT') or (result='QC')
      or (result='ZZ')
       then
      result:='';
    end;

    41:
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 igor
      SomeCaption := 'District/County/Municipality Names';
      If FileExists(AppDir+'\'+'DISTR'+FetchElm(RetNo,FormName,32)+'.D') then
       SomeList.LoadFromFile(AppDir+'\'+'DISTR'+FetchElm(RetNo,FormName,32)+'.D')
      else
       SomeList.Clear;
      ExecuteForm(TSearchListT2_2027);
      Result:='';
      If Numeric(LeftStr(SelectedString,1)) then
      begin
       result := MidStr(SelectedString,5,50);
       StoreElm(RetNo,GetFormNo(FormName),FieldId+1,LeftStr(SelectedString,3));
      end;
      //SomeList.Clear;
      Exit;
     end;
   end;

   If (ExtractNonInstFormName(FormName) = 'T1163') //pg2 //20160907 igor
   or (ExtractNonInstFormName(FormName) = 'T1273') //pg2 //20160907 igor
    then
   case FieldId of
     119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,176,179,182,
     185,188,191,194,197,200,203:
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAIS.D');
      ExecuteForm(TSearchListT2_2027);
      result := LeftStr(SelectedString,3);
      StoreElm(RetNo,GetFormNo(FormName),FieldId-1,AllTrim(MidStr(SelectedString,5,36)));
      Exit;
     end;
   end;

   If (ExtractNonInstFormName(FormName) = 'T1163') //pg3 //20160907 igor
   or (ExtractNonInstFormName(FormName) = 'T1273') //pg3 //20160907 Igor
   then
   case FieldId of
    302,305,308,311,314,317,320,323,326,329,332,335,338,341,344,347,350,353,356:
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAIS.D');
      ExecuteForm(TSearchListT2_2027);
      result := LeftStr(SelectedString,3);
      StoreElm(RetNo,GetFormNo(FormName),FieldId-1,AllTrim(MidStr(SelectedString,5,36)));
      Exit;
     end;
   end;

   if ExtractNonInstFormName(FormName) = 'T1273' then
   case FieldId of
   607,611,615,619,623,627,631,635,639,643,647,651,655:   //live inv SECTION 7
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAISL1L2.D');
      ExecuteForm(TSearchListT2_2027);
      result := LeftStr(SelectedString,4);
      If result='4001' then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
      else
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,37,73)));
      Exit;
     end;

    659,666,673,680,687,694,701,708,715,722,729,736,743:  //crop inv SECTION 8
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAISL1L2.D');
      ExecuteForm(TSearchListT2_2027);
      If Numeric(LeftStr(SelectedString,4)) then
      begin
       result := LeftStr(SelectedString,4);
       If result='4000' then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
      else
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,37,73)));
      end
      else
       result:='';
      Exit;
     end;

     661,668,675,682,689,696,703,710,717,724,731,738,745:  //crop units
     begin
       SelectedString := PopSomeFile(AppDir+'\'+'CaisUnit.D','CAIS Units of Measure');
      If selectedString >'' then
        result := SelectedString
      else
        Result:='';
      Exit;
     end;
   end;

  If ExtractNonInstFormName(FormName) = 'T1273A1' then
   case FieldId of
   7,11,15,19,23,27,31,35,39,43,47,51,55:   //live inv SECTION 7
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAISL1L2.D');
      ExecuteForm(TSearchListT2_2027);
      result := LeftStr(SelectedString,4);
      If result='4001' then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
      else
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,37,73)));
      Exit;
     end;

    59,66,73,80,87,94,101,108,115,122,129,136,143:  //crop inv SECTION 8
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAISL1L2.D');
      ExecuteForm(TSearchListT2_2027);
      If Numeric(LeftStr(SelectedString,4)) then
      begin
       result := LeftStr(SelectedString,4);
       If result='4000' then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
      else
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,37,73)));
      end
      else
       result:='';
      Exit;
     end;

     61,68,75,82,89,96,103,110,117,124,131,138,145:  //crop units
     begin
      Result := PopSomeFile(AppDir+'\'+'CaisUnit.D');
      Exit;
     end;
   end;


   if ExtractNonInstFormName(FormName) = 'T1273' then
   case FieldId of
     829,832,835,838,841,844,847,850:  //Section 11 deferred income
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAIS.D');
      ExecuteForm(TSearchListT2_2027);
      result := AllTrim(LeftStr(SelectedString,4));
      If (result='4003') then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
      else
       StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,5,39)));
      Exit;
     end;

    805,808,811,814,817,820,823,826,      //Section 10 -purch inputs
    853,856,859,862,865,868,871,874:   //Section 12  -accounts payable
    begin
      SomeList.Clear; //:=TStringList.Create; //20160704 Igor
      SomeList.Add('1. Income/Expense codes');
      SomeList.Add('2. Commodity codes');
      SelectedString := PopSomeList(SomeList,'Select codes');
      //SomeList.Free; //20160704 Igor
      If LeftStr(SelectedString,1)='1' then
      begin
       SelectedString := PopSomeFile(AppDir+'\'+'CaisExp.D','Valid entries');
       result := LeftStr(SelectedString,4);
       If (result='4002') or (result='4004') then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
       else
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,6,43)));
       Exit;
      end
      Else If LeftStr(SelectedString,1)='2' then
      begin
        SomeList.Clear; // :=TStringList.Create; //20160704 Igor
        SomeList.LoadFromFile(AppDir+'\'+'CAIS.D');
        SomeCaption := 'CAIS codes';
        ExecuteForm(TSearchListT2_2027);
        //SomeList.Free; //20160704 Igor
        result := LeftStr(SelectedString,3);
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,5,39)));
        Exit;
      end
      else
      Exit;
     end;
   end;


   If ExtractNonInstFormName(FormName) = 'T1273A2'
   then
   case FieldId of
     92,96,100,104,108:   //section 9 - productive capacity
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAISL5.D');
      ExecuteForm(TSearchListT2_2027);
      result := LeftStr(SelectedString,4);
      If (result='4005') then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
       else
       begin
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,5,39)));
        StoreElm(RetNo,GetFormNo(FormName),FieldId+2,AllTrim(MidStr(SelectedString,47,18)));
       end;
      Exit;
     end;

     29,32,35,38,41,44,47,50:  //Section 11 deferred income
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAIS.D');
      ExecuteForm(TSearchListT2_2027);
      result := AllTrim(LeftStr(SelectedString,4));
      If (result='4003') then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
      else
       StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,5,39)));
      Exit;
     end;

    5,8,11,14,17,20,23,26,      //Section 10 -purch inputs
    53,56,59,62,65,68,71,74:   //Section 12  -accounts payable
    begin
      SomeList.Clear; //:=TStringList.Create;//20160704 Igor
      SomeList.Add('1. Income/Expense codes');
      SomeList.Add('2. Commodity codes');
      SelectedString := PopSomeList(SomeList,'Select codes');
      //SomeList.Free; //20160704 Igor
      If LeftStr(SelectedString,1)='1' then
      begin
        SelectedString := PopSomeFile(AppDir+'\'+'CaisExp.D','Valid entries');
       result := LeftStr(SelectedString,4);
       If (result='4002') or (result='4004') then
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,GetUserCaisCodeDescr(Result))
       else
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,6,43)));
       Exit;
      end
      Else If LeftStr(SelectedString,1)='2' then
      begin
        SomeList.Clear; //:=TStringList.Create; //20160704 Igor
        SomeList.LoadFromFile(AppDir+'\'+'CAIS.D');
        SomeCaption := 'CAIS codes';
        ExecuteForm(TSearchListT2_2027);
        //SomeList.Free; //20160704 Igor
        result := LeftStr(SelectedString,3);
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,5,39)));
        Exit;
      end
      else
      Exit;
     end;
   end;

   if (ExtractNonInstFormName(FormName) = 'T1273ALI')
   then
   case FieldId of
     5,9,13,17,21,25,29,33,37,41,45,49,53,57,61,65,69,73,77,81,85,89,93,
      97,101,105,109,113,117,121,125,129:
     begin
      SomeList.Clear; //:=TStringList.Create; //20160907 Igor
      SomeCaption := 'CAIS codes';
      SomeList.LoadFromFile(AppDir+'\'+'CAISL1L2.D');
      ExecuteForm(TSearchListT2_2027);
      result := LeftStr(SelectedString,4);
      StoreElm(RetNo,GetFormNo(FormName),FieldId+1,AllTrim(MidStr(SelectedString,37,70)));
      Exit;
     end;

     7,11,15,19,23,27,31,35,39,43,47,51,55,59,63,67,71,75,79,83,87,91,
       95,99,103,107,111,115,119,123,127,131:
     begin
      SelectedString := PopSomeFile(AppDir+'\'+'CaisUnit.D','CAIS Units of Measure');
      If selectedString >'' then
        result := SelectedString
      else
        Result:='';
      Exit;
     end;
   end;

  If (FormName = 'AT1') then
  case FieldId of
      6: Somelist.LoadFromFile(AppDir+'\'+'State.d');  //20221119 26 out
      7: Somelist.LoadFromFile(AppDir+'\'+'Country.d');  //20221119  28 out
      58: SomeList.LoadFromFile(AppDir+'\'+'ALBSIC.D');
  end;
  //20260515 Alex >>>
  if (ExtractNonInstFormName(FormName) = 'S8') then
  case FieldId of
      6, 28, 50, 72, 94, 116, 138, 160, 182, 204:
        for i:= Low(CCARates) to High(CCARates) do
         SomeList.LoadFromFile(AppDir + '\' + 'CCARates.D');
  end;
  if (ExtractNonInstFormName(FormName) = 'S8FREE')//20160907 Igor
  or (ExtractNonInstFormName(FormName) = 'AS13') then //20160907 Igor
  case FieldId of
      6,22,38,54,70,86,102,118,134,150,166,182,198:
        for i := Low(CCARates) to High(CCARates) do
         SomeList.LoadFromFile(AppDir+'\'+'CCARates.D');
  end;
  //20260515 Alex <<<
  //20260928 Alex >>>
  if (LeftStr(FormName, 3) = 'S77') then
    case FieldId of
      10, 23, 36, 49, 62:
        for i:= Low(CCARates) to High(CCARates) do
          SomeList.LoadFromFile(AppDir + '\' + 'CCARates.D');
    end;
  //20260928 Alex <<<

  If (FormName = 'AS29L') then
  case FieldId of
      1,8,15,22,29,36,43,50,67,64,71,78,85,92,99,106,113,120,127,134,141:
    begin
      SomeList.Clear;
      GetListOfS60Projects(RetNo,SomeList);
      SelectedString := PopSomeList(SomeList);
      If SelectedString > '' then
      Begin
        Result:=LeftStr(SelectedString,40);
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,MidStr(SelectedString,42,10));  //name
      End
      else
      Begin
        result:='';
        StoreElm(RetNo,GetFormNo(FormName),FieldId+1,'');  //code
      End;
    end;
  end;


  If (ExtractNonInstFormName(FormName) = 'S552') then //20160907 Igor
     case FieldId of
      17,21,25,29,33,37:Somelist.LoadFromFile(AppDir+'\'+'TradeCodes.d');
     end;

  If (FormName = 'S566') then
  case FieldId of
     183,189,195,201,207,213,219,225,231,237:SomeList.LoadFromFile(AppDir+'\'+'State.d');
     184,190,196,202,208,214,220,226,232,238:Somelist.LoadFromFile(AppDir+'\'+'Country.d');
  end;

  If (ExtractNonInstFormName(FormName) = 'S569') then //20160907 Igor
  case FieldId of
    8:Somelist.LoadFromFile(AppDir+'\'+'EriCodes.d');
  end;

  // 20250714 Igor >>>
  if (LeftStr(FormName, 5) = 'T2311') then
  begin
    case FieldId of
      10, 25, 33:
        SomeList.LoadFromFile(AppDir + '\' + 'State.d');
      27, 35:
        Somelist.LoadFromFile(AppDir + '\' + 'Country.d');
    end;
  end;
  // 20250714 Igor >>>

    // 20251117 Igor >>>
    if (LeftStr(FormName, 3) = 'S74') then
    begin
      case FieldId of
        5:
        begin
          Somelist.add('01  Electrolysis of water');
          Somelist.add('02  Eligible hydrocarbons with CCUS');
        end;

        10004, 10024, 10044, 10064, 10084, 10104, 10124, 10144, 10164, 10184, 10204, 10224, 10244, 10264, 10284, //20260903 Alex
        20003, 20016, 20029, 20042, 20055, 20068, 20081, 20094, 20107, 20120, 20133, 20146, 20159, 20172, 20185, //20260903 Alex
        30003, 30011, 30019, 30027, 30035, 30043, 30051, 30059, 30067, 30075, 30083, 30091, 30099, 30107, 30115:
        begin
          SomeList.Add('01');
          SomeList.Add('02');
          SomeList.Add('03');
          SomeList.Add('04');
          SomeList.Add('05');
          SomeList.Add('06');
          SomeList.Add('07');
          SomeList.Add('08');
          SomeList.Add('09');
        end;
        10005, 10025, 10045, 10065, 10085, 10105, 10125, 10145, 10165, 10185, 10205, 10225, 10245, 10265, 10285, //20260903 Alex
        20004, 20017, 20030, 20043, 20056, 20069, 20082, 20095, 20108, 20121, 20134, 20147, 20160, 20173, 20186, //20260903 Alex
        30004, 30012, 30020, 30028, 30036, 30044, 30052, 30060, 30068, 30076, 30084, 30092, 30100, 30108, 30116: Somelist.LoadFromFile(AppDir + '\' + 'State.d');
        10020, 10040, 10060, 10080, 10100, 10120, 10140, 10160, 10180, 10200, 10220, 10240, 10260, 10280, 10300: //20260903 Alex
        begin
          SomeList.Add('Y');
          SomeList.Add('N');
        end;
        //20260710 Alex >>>
        10002, 10022, 10042, 10062, 10082, 100102, 10122, 10142, 10162, 10182, //20260903 Alex
        20002, 20015, 20028, 20041, 20054, 20067, 20080, 20093, 20106, 20119, //20260903 Alex
        30002, 30010, 30018, 30026, 30034, 30042, 30050, 30058, 30066, 30074:
          for i:= Low(CCARates) to High(CCARates) do
            SomeList.LoadFromFile(AppDir + '\' + 'CCARates.D');
        //20260710 Alex <<<
      end;
    end;
    // 20251117 Igor <<<

    if (LeftStr(FormName, 5) = 'T2107') then
    begin
      case FieldId of
        10, 25, 33, 53: Somelist.LoadFromFile(AppDir + '\' + 'State.d');
        27, 35, 52: Somelist.LoadFromFile(AppDir + '\' + 'Country.d');
      end;
    end;

    //20261006 Alex >>>
    if (LeftStr(FormName, 3) = 'S52') then
    begin
      case FieldId of
        7, 11, 15, 19, 23, 27:
        begin
          SomeList.Add('    ');
          SomeList.Add('1 CCPCs');
          SomeList.Add('2 ECPCs');
        end;
      end;
    end;
    //20261006 Alex <<<
  end; //more forms
end;
// 20251028 Igor <<<

procedure TFormT2_2027.AfterOpenForm(ADestination: TvtDestination); //20160518 Igor
var
  i: Integer;
begin
  inherited AfterOpenForm(ADestination);
  if ADestination = vtdPrint then
    for i := 0 to self.componentCount - 1 do
      ShowOther(self.components[I]);
end;

Function TFormT2_2027.CleanUpPickedListValue(FieldId:Integer;SelectedString:String):string;
var
  cmp: TObject; //20160620 Igor
Begin
  Result := SelectedString;
  {limit the size of returned string}

  if (FormName = 'S100')  //20150816
  or (FormName = 'S101')  //20150816
  or (ExtractNonInstFormName(FormName) = 'S125') //20160907 Igor
  then
  begin //20150812
    //if SplitDynId(RetNo,FormNo,FieldId) and (ColNo < 2) then
    if SplitDynId(RetNo,FormNo,FieldId) and (ColNo = 0) then //first column only
    begin //column 1 and 2, all arrays
      if ColNo = 1 then
        dec(FieldId); //first element in row
    //first column
      Result:=MidStr(SelectedString,6,100);   //ChangeEditBoxText!?
      //StoreElm(RetNo,FormNo, FieldId, MidStr(SelectedString,6,100));
    //second column
      StoreElm(RetNo,FormNo, FieldId+1, AllTrim(LeftStr(SelectedString,4)));
      //20160620 Igor >>>
      cmp := FindComponent('vtEdit' + IntToStr(FieldId+1));
      if (cmp <> nil) and (cmp is TvtEdit) then
      begin
        OnEnterField(TvtEdit(cmp));
        OnExitField(TvtEdit(cmp));
      end;
      //20160620 Igor <<<
    //all done
      //Result := '';
    end;
  end;

  If FormName = 'S76' then  //20260524
  begin
    case FieldId of  //20160722 CON
      6, 17, 28, 39, 50, 61, 131, 132, 133, 134, 135, 136:  result:= LeftStr(Result, 2); //20260811 Alex
    end;
  end;

  If FormName = 'T2' then  //20111029
  begin
    If FieldId=72 then result:=LeftStr(Result,2);
    If FieldId=731 then result:=LeftStr(Result,1);  //20160722 CON it was below
    If FieldId=203 then result:=LeftStr(Result,6);  //naics   //20160722 CON
    case FieldId of  //20160722 CON
      17,33,45:  result:=LeftStr(Result,2);
    end;
  end;

  If FormName = 'T106' then  //20180725
  Begin
    Case FieldId of
     2,67,72: result:=LeftStr(SelectedString,3);  //jz20241126 //20180725
     35,36,37,38: result:=LeftStr(SelectedString,6);
     60: result:=LeftStr(SelectedString,2);  //20240707 FunctinalCurrency
    end; //case
  end;

  if FormName='S444' then   //20220511
  Begin
     case FieldId of
     21,28,35,42,49,56,63,70,77,84,91,98,105,112,119,126,133,140,
     147,154,161,168,175,182,189,196,203,210: result:=LeftStr(SelectedString,4);
     //20231109 //233 was missing
     219,226,233,240,247,254,261,268,275,282,289,296,303,310,317,324,331,338,345,352,
     359,366,373,380,387,394,401,408: result:=LeftStr(SelectedString,4);
     end;
  end;


  If (FormName = 'T1135') then result := LeftStr(SelectedString,3);  //20150329

  If (FormName = 'S389') then result := LeftStr(SelectedString,1);  //20180503


  If LeftStr(FormName,3) = 'S8#' then  //20260713
  begin
    Case
     FieldId of 293,294,295,296,297,298,299,300,301,302: result:=trim(LeftStr(Result,7)); //not 6 //20260718
     else Result := trim(LeftStr(Result,4)); //jz//20260714 - add from below s8 trunc all by 4
    end;
  end;

  //If (ExtractNonInstFormName(FormName) = 'S8')  //jz//20260714 - remove from here as causing unwanted trunc //20160907 Igor
  if (ExtractNonInstFormName(FormName) = 'S8FREE')  //20160907 Igor
  or (ExtractNonInstFormName(FormName) = 'OS8') //20160907 Igor
  or (ExtractNonInstFormName(FormName) = 'AS13') //20160907 Igor
  or (FormName = 'S76') //20250607
  or (LeftStr(FormName, 3) = 'S74') //20260710 Alex
  or (LeftStr(FormName, 3) = 'S75') //20260811 Alex
  or (LeftStr(FormName, 3) = 'S77') //20260928 Alex
  then
  begin
    Result := LeftStr(Result,4);
  end;

  //20140804
  If (FormName = 'S8ALL')
  then Result := LeftStr(Result,2);


  If (FormName = 'RC59') then Result := LeftStr(Result,2);

  If FormName = 'S5' then Result := LeftStr(Result,3);


  If ExtractNonInstFormName(FormName) = 'S60' then //20160907 igor
  begin
    If FieldId=7 then result:=LeftStr(Result,7);
     If FieldId=43 then result:=LeftStr(Result,5);  //jz//20260526
  end;

  //If FormName = 'T106' then result:=LeftStr(Result,6); //instead of 3  ?? //20171128

  { included above as part of T2 form //20160722
  If FormName = 'T2' then  //20111025
  begin
    If FieldId=203 then result:=LeftStr(Result,6);  //naics
  end;
  }

  If ExtractNonInstFormName(FormName) = 'T106SL' then //20160907 Igor
  begin
    Case FieldId of
     13: result:=LeftStr(Result,3);
     //20170909 Igor>>>
     19,20,21,22: result:=LeftStr(Result,6); //20170907 fCON from 3 to 6 chrs codes
     //20170909 Igor<<<
     24,25,26,27: result:=LeftStr(Result,3);
     //20180627 CON
     33,121,37,41,45,49,53,57,61,65,69,73,77,81,85,89,
     35,123,39,43,47,51,55,59,63,67,71,75,79,83,87,91:result:=LeftStr(Result,1);
    end; //case

  end;

  //20140804
  If (FormName = 'S8ALL')
  then Result := LeftStr(Result,2);

  If FormName = 'S9' then
  begin
   Case FieldId of
   5,14,23,32,41,50,59,68,77,86,95,104,113,122,131,
     140,149,158,167,176:Result := LeftStr(Result,2);
   7,16,25,34,43,52,61,70,79,88,97,106,115,124,133,
     142,151,160,169,178,186:Result := LeftStr(Result,1);  //20170726
   end; {case}
  end;

//If FormName = 'PAGE_8' then  Result := LeftStr(Result,1); //???
  If FormName = 'S3'  then  Result := LeftStr(Result,1);
  If FormName = 'S11' then  Result := LeftStr(Result,1);
  If FormName = 'S23' then  Result := LeftStr(Result,1);
  If FormName = 'S25' then  Result := LeftStr(Result,1);
  If FormName = 'S49' then  Result := LeftStr(Result,1);

  If (FormName = 'S6RE')
  or (FormName = 'S12')
  or (FormName = 'S14')
  or (FormName = 'S15')
  or (FormName = 'S21')
  or (FormName = 'S22')
  or (FormName = 'S29')
  or (FormName = 'S97')
  or (FormName = 'S566')
  //or (FormName = 'S546')
  //or (ExtractNonInstFormName(FormName) = 'S547') //20160907 Igor
  then  Result := LeftStr(Result,2);

  If FormName = 'T661' then  result:=LeftStr(Result,1);   //20130829

  //If (ExtractNonInstFormName(FormName) = 'S548') then  result:=LeftStr(Result,3); //20160907 Igor

  If (ExtractNonInstFormName(FormName) = 'S552') then //20160907 Igor
  begin
   //result:=LeftStr(Result,4);
   If Not Numeric(LeftStr(Result,1)) then Result:=''
   else
   begin
     StoreElm(RetNo,GetFormNo(FormName),FieldId+1,MidStr(Result,5,80)); //20121208 does not work result is a number
     result:=LeftStr(Result,4);
   end;
  end;
  If (ExtractNonInstFormName(FormName) = 'S569') then  result:=LeftStr(Result,3); //20160907 Igor


  If (FormName = 'AT1') then
  begin
   If FieldId=58 then result:=LeftStr(Result,4) else result:=LeftStr(Result,2);
  end;

  (*   //20231024
  If (FormName = 'AS9') then
  begin
    If FieldId=16 then result:=LeftStr(Result,1);
  end;
  *)

  //20180614
  if (FormName = 'CBCR') then  //20180507
  Begin
    If FieldId=1 then result:=LeftStr(Result,3);  //20180620
    If FieldId=26 then result:=LeftStr(Result,2);
    If FieldId=72 then result:=LeftStr(Result,2);
    If (FieldId>=38) and (FieldId<=555) then result:=LeftStr(Result,2); //20180611
    If (FieldId>=616) and (FieldId<=1540) then result:=LeftStr(Result,2); //20180611
    If (FieldId>=1588) and (FieldId<=1611) then result:=LeftStr(Result,2); //20180611
    If (FieldId>=1612) and (FieldId<=1635) then result:=LeftStr(Result,6); //20180611
    If (FieldId>=1636) and (FieldId<=1680) then result:=LeftStr(Result,6); //20180611
    If (FieldId>=1681) and (FieldId<=1688) then result:=LeftStr(Result,2); //20180611
  End;

  //20180611
  if FormName = 'T1134' then  //20180507
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

  //20180613
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

  //20240730 Igor >>>
  if (LeftStr(FormName, 4) = 'UHT#') then
  begin
    case FieldId of
      12:
        Result := LeftStr(Result, 2);
    end;
  end

  else if (LeftStr(FormName, 5) = 'T2054') then
  begin
    case FieldId of
      4:
        Result := LeftStr(Result, 2);
    end;
  end

  else if (LeftStr(FormName, 4) = 'UHT#') then
  begin
    case FieldId of
      6, 14, 27:
        Result := LeftStr(Result, 2);
      15, 7:
        Result := LeftStr(Result, 2);
    end;
  end

  else if (LeftStr(FormName, 4) = 'T217') then
  begin
    case FieldId of
      5:
        Result := LeftStr(Result, 2);
    end;
  end

  else If (LeftStr(FormName, 5) = 'T2058') then
  begin
    case FieldId of
      17, 41:
        Result := LeftStr(Result, 2);
      18:
        Result := LeftStr(Result, 2);
    end;
  end

  else If (LeftStr(FormName, 5) = 'T2059') then
  begin
    case FieldId of
      17, 41:
        Result := LeftStr(Result, 2);
      18:
        Result := LeftStr(Result, 2);
    end;
  end

  else If (LeftStr(FormName, 5) = 'T2057') then
  begin
    case FieldId of
      17, 41:
        Result := LeftStr(Result, 2);
      18:
        Result := LeftStr(Result, 2);
    end;
  end
  //20240730 Igor <<<
  //20261006 Alex >>>
  else if (LeftStr(FormName, 3) = 'S52') then
  begin
    case FieldId of
      7, 11, 15, 19, 23, 27: Result:= Trim(LeftStr(Result, 2));
    end;
  end;
  //20261006 Alex <<<
end;

procedure TMyChildT2_2027.FormContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  vis: boolean;
begin
  with MainFormT2 do
  begin
    vis := RetInMem > 1;
    TileReturnsVertically1.Visible := vis;
    TileReturnsHorizontally1.Visible := vis;
    TileReturnsHorizontally2.Visible := vis;
  end;
end;

Procedure TFormT2_2027.FormatDollar(MyEditBox: TvtEdit; str: string);
var
  fld,HowToFormat:Integer;
begin
   FormatSettings.DecimalSeparator := ' ';
   Fld := GetFieldId(MyEditBox.Name);
   HowToFormat :=GetHowToFormat(FormName,Fld);
   If Vl(str) = 0 then
    MyEditBox.Text:='0'
   else
    MyEditBox.Text:=FormatAmount(FormName,str,HowToFormat);
end;

procedure TFormT2_2027.EditBoxMouseDown(MyEditBox: TvtEdit; Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
begin
  If Button = mbLeft then
  begin
    inherited;
  End  //MbLeft
  else
  If Button = mbRight then
  begin
   MyEditBox.setfocus;
   MyEditBox.Refresh;

  with MainFormT2 do
  begin
//configure menu
//show menu
    FieldPopup.PopupComponent := MyEditBox;
  //pos must be in screen coordinates
    FieldPopup.Popup(mouse.CursorPos.x, mouse.CursorPos.y);
  end; //with
 end;  {mbright}
end;


procedure TFormT2_2027.OnVtEditDblClick(MyEditBox:TvtEdit);
Var i:Integer;FName:string;
    NewString: String;
    //ElmsInError:TStringList;
    FieldId, TargetLinkedField:Integer;
    P: TWinControl; //20160805 Igor
begin
  FieldId:=MyEditBox.FieldId; // GetFieldId(MyEditBox.Name);

  //20160710 Igor
  if MyEditBox.ReadOnly then exit;
  if not assigned(RetList[RetNo]) then exit;
  if RetList[RetNo].isLastYearReturn or
     RetList[RetNo].isAppendix then exit;


  if MyEditBox.vtDataSource = vtLinked then
  begin
   FName :=GetLinkedForm(FieldId,TargetLinkedField);
   //20170628 Igor >>>
//   if linkToSelf(FormName,FName)then
//   begin
//    ShowTimedMsg('Hit the Spacebar to link',1000);
//    exit;
//   end;
   //20170628 Iogr <<<
   If FName > '' then
   begin
    OpenForm(RetNo,GetFormNo(FName),TargetLinkedField); //20150809
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
      ShowTimedMsg('Changes not allowed. Return is locked',1500);
     Exit;
   end;
  End;
end;



(*
procedure TFormT2_2027.OnVtEditDblClick(MyEditBox:TvtEdit);
Var i:Integer;FName:string;
    NewString: String;
    //ElmsInError:TStringList;
    FieldId, TargetLinkedField:Integer;
    P: TWinControl; //20160805 Igor
begin
  FieldId:=MyEditBox.FieldId; // GetFieldId(MyEditBox.Name);

  //20160710 Igor
  if MyEditBox.ReadOnly then exit;
  if not assigned(RetList[RetNo]) then exit;
  if RetList[RetNo].isLastYearReturn or
     RetList[RetNo].isAppendix then exit;


  if MyEditBox.vtDataSource = vtLinked then
  begin
   FName :=GetLinkedForm(FieldId,TargetLinkedField);
   if linkToSelf(FormName,FName)then
   begin
    ShowTimedMsg('Hit the Spacebar to link',1000);
    exit;
   end;
   If FName > '' then
   begin
    OpenForm(RetNo,GetFormNo(FName),TargetLinkedField); //20150809
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
      ShowTimedMsg('Changes not allowed. Return is locked',1500);
     Exit;
   end;
  End;
end;
*)

Procedure TFormT2_2027.DataChangeRtn;
begin
  if not AppT2.CheckAllowedBN(RetNo, true) then Exit; //20191015 Igor
  {save instance data}
  Calc(Retno,FormName);
  CalcAffectedBy(RetNo,FormName);
  If IsFormMultipage(FormName) then CalcMultiPageForm(RetNo,FormName);

  Ret[RetNo].Changed := True;
  Ret[Retno].FedCalcStatus := False;
  Ret[Retno].OntCalcStatus := False;
  Ret[Retno].AlbCalcStatus := False;

  Recalc(RetNo,FormName);
end;

Function GetReturnCaption(RetNo:Integer):String;
Var YrPrefix:String;CorpName:String;
begin
  YrPrefix:='';
  CorpName:=GetCorpName(RetNo);
  If CorpName='' then CorpName:= PaddR(PaddZero(IntToStr(RetNo),2),2)+' Un-named';
  //Result:=PaddR(PaddZero(IntToStr(RetNo),2),2)+' '+YrPrefix+' '+CorpName;
  Result:=CorpName+' '+FetchElm(RetNo,'T2',1);
    //+' Y/E: '+IntToStr(GetTaxationYearEndYYYY(RetNo));
end;


procedure TFormT2_2027.ShowRichData(ARichEdit: TRichEdit; Fld: Integer);
//Procedure TMyChildT2_2013.ShowInterpretedRichData(ARichEdit:TwwDbRichEdit;FName:String;FNo:Integer);
begin
  If IsFormAClientLetter(FormName) AND (ARichEdit.parent <> nil) then  //20160223 Igor
  begin
    LetterName:=GetLetterFileName(RetNo,FormName);
    If FileExists(LetterName) then
    begin
      GetInterpetedRichEdit(RetNo,LetterName,ARichEdit);
      exit;
    end;
  end; //CLetter
  inherited; //if not exited before
end;

procedure TMyChildT2_2027.SpeedButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  showMessage('button clicked');
end;

procedure TMyChildT2_2027.SectionBtnClick(Sender: TObject);
{
Var
  I,J,MxPg,k,FNo:Integer; FName,FNonInst,FRootName,FInst:string;
  LblTop:Integer;
  SomeList, TempList:TStringList;
  FirstLine:String;
}
begin
  GoToSection();
end;



Function InDateOnly(Value:string;MnYear,MxYear:integer):Boolean;
begin
  result := EditDate(Value,MnYear,MxYear);
  if not Result then
     ShowMessage('Invalid Date (YYYY/MM/DD) or out of range');
end;

Function InYYYYMMOnly(Value:string;MnYear,MxYear:integer):Boolean;
begin
  result := EditYYYYMMDate(Value+'/01',MnYear,MxYear);
  if not Result then
     ShowMessage('Invalid Date (YYYY/MM) or out of range');   //20160417  Con
   //  UserMsg('Invalid Date (YYYY/MM/DD) or out of range');
end;


constructor TMyChildT2_2027.CreateNew(AOwner: TComponent; RNo: Integer);
var
  j: Integer; //20160519 Igor
begin
  inherited; //calls AddPropertiesAndEvents;
  FormClass := TFormT2_2027;

 FMyFormHeaderFrame := THeaderFrameT2_2027.Create(self);
 with MyFormHeaderFrame do
 begin
  Name:='P2';
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

  //ReturnNameLbl.Caption := '[Un-Named return]';
  Parent:=self; //MyChild; //MyPageControl;
  CloseTabBtn.OnClick := CloseActiveForm;
  SectionBtn.OnClick := SectionBtnClick;
  MyChild := self;
 end;


 FMyMonitorFrame := TMonitorFrameT2_2027.Create(self);
 With MyMonitorFrame do
 begin
  Height:=23;
  Align:=alBottom;
  Parent:=self;
  //20160519 Igor >>>
  ParentBackGround := False;
  for J := 0 to ComponentCount - 1 do
  Begin
    if Components[j] is TPanel then
      (Components[j] as TPanel).ParentBackground := False;
  End;
  //20160519 Igor <<<
 end;
 if not RetList[RNo].isAppendix then //20160704 Igor
   UpdateChildTaxPanel;
end;

procedure TMyChildT2_2027.SetColor(clr: TColor);
begin
  inherited;
  UpdateChildTaxPanel;
end;

function TFormT2_2027.IsProtectedField(MyEditBox: TvtEdit): boolean;
begin
  Result := (MyEditBox.vtDataSource=vtCalc)
  or ((FormName='INVOICE') and (IsInvoiceLocked(RetNo)) and (MyEditBox.FieldId <> 285))  //20160417
end;

//20170409 Igor >>>
procedure TFormT2_2027.ConditionCalc(AIdentificator: String; var AValue: Boolean);
begin
//
end;

procedure TFormT2_2027.ConditionCalc(AIdentificator: String; var AValue: Integer);
begin
//
end;

procedure TFormT2_2027.ConditionCalc(AIdentificator: String; var AValue: String);
begin
//
end;

procedure TFormT2_2027.ConditionCalc(AIdentificator: String; var AValue: Real);
begin
//
end;

procedure TFormT2_2027.EditButtonClick(AEdit: TObject;
  AAction: TEditButtonAction; AEdit2: TObject = nil); //20170411 Igor
begin
  case AAction of
    ebaInsertRow:
      begin
        if not Assigned(AEdit) then
          Exit;
        if not(AEdit is TvtEdit) then
          Exit;
        InsertDynamicRowBefore(TvtEdit(AEdit));
      end;
    ebaRowUp:
      begin
        if not Assigned(AEdit) then
          Exit;
        if not(AEdit is TvtEdit) then
          Exit;
        MoveDynamicRow(TvtEdit(AEdit), mdUp);
      end;
    ebaRowDown:
      begin
        if not Assigned(AEdit) then
          Exit;
        if not(AEdit is TvtEdit) then
          Exit;
        MoveDynamicRow(TvtEdit(AEdit), mdDown);
      end;
    ebaDeleteRow:
      begin
        if not Assigned(AEdit) then
          Exit;
        if not(AEdit is TvtEdit) then
          Exit;
        MoveDynamicRow(TvtEdit(AEdit), mdRemove);
      end;
//20170411 Igor >>>
    ebaMove:
      begin
        if not Assigned(AEdit) then
          Exit;
        if not(AEdit is TvtEdit) then
          Exit;
        if (AEdit2 = nil) or not(AEdit2 is TvtEdit) or (AEdit2 = AEdit) then
          MoveDynamicRow(TvtEdit(AEdit), mdWithRequest)
        else
          MoveDynamicRow(TvtEdit(AEdit), TvtEdit(AEdit2));
      end;
//20170411 Igor <<<
  end;
end;
//20170409 Igor <<<

//20170411 Igor >>>
function TFormT2_2027.SameTable(AField1, AField2: Integer): Boolean;
Begin
  Result := Inherited SameTable(AField1, AField2);
End;

function TFormT2_2027.SameColumn(AField1, AField2: Integer): Boolean;
Begin
  Result := Inherited SameColumn(AField1, AField2);
End;

function TFormT2_2027.isLastRow(AFieldID: Integer): Boolean;
Begin
  Result := Inherited isLastRow(AFieldID);
End;
//20170411 Igor <<<

Function SubstituteLastYearForm(FName: String): String; //20160424 Igor
Var
  Inst: Integer;
  NewInst: Integer;
Begin
  Result := GetRenamedFName(FName);
  if Result = '' then
    Result := FName;
end;


//jz 20250108
Function TFormT2_2027.PrivacyAgreementAccepted(ForEfileFormName:string):boolean;
var
  i:integer;
  PAdlgBox: TPrivacyAgreementT2_2027;
  doNotShowPrivacyAgreement: TStringList;
begin
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

end.
