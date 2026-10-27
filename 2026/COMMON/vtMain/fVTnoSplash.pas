unit fVTnoSplash;
(* This is the release candidate for the main form.
*)

{.$DEFINE RPanel} //implement right hand panel?
{$DEFINE splash}  //show new splash screen?
{$DEFINE icons}  //show icons in ReturnsListBox?

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls, Dialogs,//20170811 Igor
  fMainBase, ImgList, StdActns, ActnList, Menus, ExtCtrls, StdCtrls,
  ComCtrls, ToolWin, Registry,
  vtMain, vtMulti, fCalcWatch,  //uDeclare,
//select one of these
  //ChoiceOld,
  //ChoiceCon1,
  //ChoiceTabbed,
//the right-hand panel interface
  //ChoicePanel,
  Buttons, vtLabel, vtShape, OleCtrls, SHDocVw, ekfunc, ekbasereport, ekrtf,
  System.Actions, Vcl.AppEvnts, //20160612 Igor //20160720 Igor
  DummyMDIChild, Vcl.ActnMan, Vcl.ActnColorMaps, //20161111 Igor //Con
  vtShared, fraClientFiles, //20170703 Igor //20170714 Igor
  vtControlIntf, VCL.Ribbon, Vcl.RibbonLunaStyleActnCtrls, fColouredPageTabControl, //20180122 Igor
  UIRibbon; //20190415 Igor

//20180122 Igor >>>
(*  
//20180104 Igor >>>
type
  TTabControl = class(ComCtrls.TTabControl)
  protected
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

type
  TPageControl = class(ComCtrls.TPageControl)
  protected
    procedure DrawTab(TabIndex: Integer; const Rect: TRect; Active: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;
//20180104 Igor <<<
*)
//20180122 Igor <<<

type
  Tvtnosplash = class(TVTMain, IvtAdoptableControl)//20170727 Igor
    LeftPanel: TPanel;
    WizardPanelSplitter: TSplitter;
    FormsPanelSplitter: TSplitter;
    FormsPanel: TPanel;
    Panel2: TPanel;
    ExpandPanel: TPanel;
    SpeedButton1: TSpeedButton;
    ExpandBtn: TBitBtn;
    Collapse: TBitBtn;
    UsedFormsBox: TCheckBox;
    FormsTreeView1: TTreeView;
    ReturnsPanel: TPanel;
    ReturnsHeaderPanel: TPanel;
    ReturnsListBox: TListBox;
    WizardPanel: TPanel;
    WizardHeaderPanel: TPanel;
    Label9: TLabel;
    SuperAuditBox: TCheckBox;
    buSignOffWarnings: TBitBtn;
    Panel3: TPanel;
    SuperFeaturesLbl: TLabel;
    PrintAuditBtn: TSpeedButton;
    SuperVerificationBtn: TPanel;
    AuditPanel: TScrollBox;
    ErrorView: TTreeView;
    TutorialsPanel: TPanel;
    Splitter1: TSplitter;
    TutLeftPanel: TPanel;
    Panel6: TPanel;
    TutorialListBox: TListBox;
    Panel4: TPanel;
    WebBrowser1: TWebBrowser;
    Panel5: TPanel;
    TutorialZoomInBtn: TSpeedButton;
    TutorialZoomOutBtn: TSpeedButton;
    CloseTutorialBtn: TBitBtn;
    NextTutorialBtn: TBitBtn;
    PrevTutorialBtn: TBitBtn;
    DemonstrateTutorialBtn: TBitBtn;
    URLs: TComboBox;
    HelpIndexBtn: TBitBtn;
    TrBtn: TBitBtn;
    ToolBoxSplitter: TSplitter;
    AppImages: TImageList;
    StatusBar1: TStatusBar;
    ReviewPanel: TPageControl;
    tabHide: TTabSheet;
    tabReview: TTabSheet;
    tabAssist: TTabSheet;
    AssistBrowser: TWebBrowser;
    ReviewForms: TTabControl;
    Panel1: TPanel;
    swFullHelp: TCheckBox;
    EkRTF1: TEkRTF;
    EkUDFList1: TEkUDFList;
    TabControl1: TTabControl;
    tbZoom: TTrackBar;
    lblZoom: TLabel;
    rbZoomAll: TRadioButton; //20160209 Igor
    rbZoomCenter: TRadioButton; //20160209 Igor
    rbZoomRight: TRadioButton;
    ReviewHeaderPanel: TPanel;
    ReviewBottomPanel: TPanel;
    PanelZoom: TPanel;
    buttonAvailableWidth: TSpeedButton;
    tabLastyear: TTabSheet;
    LastYearHeaderPanel: TPanel;
    LastYearBottomPanel: TPanel;
    buttonSynchronousDisplay: TSpeedButton;
    ButtonZoomPlus: TSpeedButton;
    ButtonZoomMinus: TSpeedButton;
    buttonZoom50_50: TSpeedButton;
    actViewReturnsList: TAction;
    actViewAudit: TAction;
    actViewForms: TAction;
    SpeedButton2: TSpeedButton;
    actHideForms: TAction;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    actHideReturnsList: TAction;
    actHideAudit: TAction;
    pgc: TPageControl;
    tsDiagnostics: TTabSheet;
    tsForms: TTabSheet;
    tsBoth: TTabSheet;
    tabRightPanelHide: TTabSheet;
    LastYearHeaderError: TLabel;
    LastYearHeaderCaption: TPanel;
    lblLinkLastYearReturn: TLabel;
    pnlToolBarParent: TPanel;
    XPColorMap1: TXPColorMap;
    tsClientDocuments: TTabSheet;
    tsViewSideBySide: TTabSheet;
    pnlViewSideBySide: TPanel;
    tsAutofill: TTabSheet; //20160209 Igor
    ilTreeView: TImageList; //20180206 Igor
    //20190504 Igor >>>
    btnSendGlobalMessage: TButton;
    GlobalMessageTimer: TTimer;
    CloudLogTimer: TTimer; //20190523 Igor
    //20190504 Igor <<<
    procedure FormCreate(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean); //update everything related to AppID
    procedure SideBySideBtnClick(Sender: TObject);
    procedure AuditListDblClick(Sender: TObject);
  //T1? handlers
    procedure SuperVerificationBtnClick(Sender: TObject);
    //procedure PlanNextYearClick(Sender: TObject);
    //procedure RefreshAllDependantsClick(Sender: TObject);
    procedure ReturnsListBoxClick(Sender: TObject);
    procedure ErrorViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ErrorViewClick(Sender: TObject);
    procedure FormsTreeView1Click(Sender: TObject);
    //procedure ToolBarBtnClick(Sender: TObject);
  //tutorials
    procedure CloseTutorialBtnClick(Sender: TObject);
    procedure NextTutorialBtnClick(Sender: TObject);
    procedure PrevTutorialBtnClick(Sender: TObject);
    procedure ReduceTutorialHeight(Sender: TObject);
    procedure TUTORIALS1Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure TutorialListBoxClick(Sender: TObject);
    procedure DemonstrateTutorialBtnClick(Sender: TObject);
    procedure TutorialZoomInBtnClick(Sender: TObject);
    procedure TutorialZoomOutBtnClick(Sender: TObject);
    procedure WebBrowser1BeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure TutorialsPanelResize(Sender: TObject);
    procedure CollapseClick(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure FormsTreeView1KeyPress(Sender: TObject; var Key: Char);
    procedure PrintAuditBtnClick(Sender: TObject);
    procedure UsedFormsBoxClick(Sender: TObject);
    procedure AuditPanelSplitterMoved(Sender: TObject);
    procedure SuperAuditBoxClick(Sender: TObject);
    procedure ReturnsListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure buSignOffWarningsClick(Sender: TObject);
    procedure ReviewPanelChange(Sender: TObject);
    procedure ReviewPanelSplitterMoved(Sender: TObject);
    procedure ReviewFormsChange(Sender: TObject);
    procedure RebuildReviewForm; //20160220 Igor
    procedure LoadRightPanelSettings; //20160221 Igor
    procedure TabControl1Change(Sender: TObject);  //20151001
    procedure PageControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);//20160113 Igor
    procedure PageControlDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);//20160113 Igor
    procedure PageControlDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tbZoomChange(Sender: TObject);//20160114 Igor
    procedure FormResize(Sender: TObject);//20160114 Igor
    procedure FormShow(Sender: TObject); //20160209 Igor
    procedure rbZoomAllClick(Sender: TObject); //20160209 Igor
    procedure TabControl1GetImageIndex(Sender: TObject; TabIndex: Integer;
      var ImageIndex: Integer); //20160209 Igor
    procedure buttonAvailableWidthClick(Sender: TObject); //20160301 Igor
    procedure AuditPanelSplitterCanResize(Sender: TObject; var NewSize: Integer; //20160305 Igor
      var Accept: Boolean);
    procedure ButtonZoomPlusClick(Sender: TObject);
    procedure ReviewPanelSplitterCanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);    //20160312 Igor
    procedure buttonZoom50_50Click(Sender: TObject);
    procedure buttonSynchronousDisplayClick(Sender: TObject);
    procedure ActLeftPanelSettingExecute(Sender: TObject); //20160426 Igor
    procedure actHideFormsExecute(Sender: TObject); //20160426 Igor
    procedure actHideReturnsListExecute(Sender: TObject); //20160426 Igor
    procedure actHideAuditExecute(Sender: TObject);
    procedure pgcChange(Sender: TObject); //20160316 Igor
    procedure TabControl1MouseUp(Sender: TObject; Button: TMouseButton;//20160519 Igor
      Shift: TShiftState; X, Y: Integer);
    procedure TabControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ErrorViewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer); //20160519 Igor
    procedure lblLinkLastYearReturnMouseEnter(Sender: TObject); //20160701 Igor
    procedure lblLinkLastYearReturnMouseLeave(Sender: TObject); //20160701 Igor
    procedure lblLinkLastYearReturnClick(Sender: TObject);  //20160701 Igor
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);//20160720 Igor
    procedure TreeViewGetImageIndex(Sender: TObject; Node: TTreeNode);  //20180206 Igor
    //20190504 Igor >>>
    procedure btnSendGlobalMessageClick(Sender: TObject);
    procedure GlobalMessageTimerTimer(Sender: TObject);
    //20190504 Igor <<<
    procedure CloudLogTimerTimer(Sender: TObject); //20190523 Igor
   //more
  published //toolbar handlers
    procedure AuditOpenBtnClick(Sender: TObject);
  private
    //20161129 Igor >>>
    FPreviewForm: TForm;
    FLastYearForm: TForm;
    //20161129 Igor <<<
    FClientFilesFrame: TClientFilesFrame; //20170714 Igor
    FAutoFillFrame: TClientFilesFrame;//20170720 Igor
    //20170825 Igor>>>
    Logoned: Boolean;
    //20170825 Igor<<<

    procedure UpdateReturns;
    property AuditList: TTreeView read ErrorView;
    procedure FindUrlAddress;
    procedure RefreshAuditPanel(RetNo: Integer);
    procedure RefreshFormsPanel(RetNo: Integer);
    procedure ShowTutorialsPanel(fShow: boolean);
    procedure ShowLeftPanel(fShow: boolean);
    procedure UpdateRightPanel;
    procedure GuiCmd(cmd: eGuiCommand);
    procedure ChangeApp(MyApp: TApp);
    procedure DockGUI;
    procedure ChangeRetNo(RNo: integer);
    procedure FormPaint_; override;
    procedure ShowDiagnostics(RetNo: integer);
    procedure SaveOptions; override;
    procedure SelectFeatures; override;
    procedure OnIdle(Sender: TObject; var Done: Boolean);

    procedure UpdateColor(RetNo: integer);
    procedure CheckLicenses;
    procedure MarkReturn;

    procedure SynchronousDisplay; //20160312 Igor
    procedure SetLeftPanelPartVisible; //20160426 Igor

    procedure AppShowHint(var HintStr: string; var CanShow: Boolean; //20160519 Igor
      var HintInfo: THintInfo);
    procedure ClearReview(AClearTabs: Boolean = True); //20170619 igor
    procedure UpdatePanelClientDocuments(ARetNo: Integer); //20170714 Igor
    procedure UpdatePanelAutoFill(ARetNo: Integer);//20170720 Igor
    procedure UpdateAdoptedPages(AApp: TApp; ARetNo: Integer);//20170727 Igor
    procedure InitGlobalMessage; //20190504 Igor
    procedure InitCloudLog; //20190523 Igor
  private //tutorials
    TutDir: string;
    TutorialFile, TutorialScript: string;
    TutUpdateCombo: boolean;
    TutHistoryIndex: integer;
    TutHistoryList: TStringList;
    FLastActiveRetNo: Integer; //20160220 Igor
    FCloseReturnState: Boolean;
    FStartCompilation: Boolean; //20160321 Igor
    FLastFormComparison: String; //20160321 Igor
    FLastReturnComparison : Integer; //20160321 Igor
    PrevTabControl1TabIndex: Integer; //20160519 Igor
    FHintRow: Integer; //20190519 Igor
    FDummyForm: TfrmDummyMDIChild; //20161111 Igor
    FpgcActivePageIndex: Integer; //20161111 igor
    FReviewPanelActivePageIndex: Integer; //20161111 Igor
    FCloudLogId: Integer; //20190523 Igor
    function GetTutorialFileName: String;
    procedure SetupSubForm(var AForm: TForm; ATabSheet: TTabSheet); //20161129 Igor
  private //? handlers
    AppToolBar: TControl; // TCustomControl;//20170824 Igor
    FAdoptedForm: Integer; //20170429 igor
    function GetAppToolBarHeight: Integer; //20160225 Igor
    function Comparison: Boolean;
    procedure SetPgcActivePage; //20160302 Igor
    function MainOptionsToPgcActivePage: TTabSheet; //20170619 Igor
  {$IFDEF old}
    procedure OnAttribChanged(var Msg: TVTMReturnChanged); message VTM_AttribChanged;
    procedure OnFormChanged(var Msg: TVTMFormChanged); message VTM_FormChanged;
    procedure OnRetNoChanged(var Msg: TVTMReturnChanged); message VTM_RetNoChanged;
    procedure OnValueChanged(var Msg: TVTMValueChanged); message VTM_ValueChanged;
    procedure OnAppChanged(var Msg: TVTMReturnChanged);
  {$ELSE}
  {$ENDIF}
    property AppToolBarHeight: Integer Read GetAppToolBarHeight; //20160225 Igor
  //20170914 Igor >>>
  private
    FResizeFormTimer: TTimer;
    procedure InitResizeForm;
    procedure ResizeFormTimer(Sender: TObject);
    procedure UpdateReviewData;
  //20170914 Igor <<<
    function SetActiveTab(ATab: TTabSheet): Boolean; overload;//20171228 Igor
    function SetActiveTab(ATabIndex: Integer): Boolean; overload;//20171228 Igor
  //20170703 Igor >>>
  protected
    procedure CallExecuteForm(var Msg: TMessage); message UM_EXECUTEFORM;
    procedure WndProc(var Message: TMessage); override; //20190401 Igor
  //20170703 Igor <<<
  public
    procedure SetReturnsHeaderPanelNormalState; //20160805 Igor
    destructor Destroy; override;
    //20170727 Igor>>>
    procedure AdoptMe(AChild: TCustomForm; AAppIds: Array of string;
      ARetNos: Array of Integer);
    procedure UnAdoptMe(AChild: TCustomForm);
    //20170727 Igor<<<
  end;

var
  vtnosplash: Tvtnosplash;

implementation

{$R *.DFM}

uses
  ShellApi, Printers,
  vtEditBox,vtForm, //vtScrollBox,
  fSplash,
  vtDialogs, //vtTaxResearch, //fProgres,
  //uPrint, //CommonPrint,
  vtCommon,
  vtChild,
  fCloudLogon, //20190523 Igor
  //fWaitForm, //20190401 Igor //20190925 Igor
  fSendGlobalMessage, fShowGlobalMessage, //20190430 Igor
//keep last
  vtTrimStr{, vtShared} //20170703 Igor
  ,vtRunArc; // 20151030 Igor


const
  UM_REMOVETABSHEET = WM_USER + 1;
type
  TSideBySide = (ssNone, ssSpouses, ssFamily, ssLastYear);

  TUpdateRequest = (
    urReturns,  //ReturnsListBox - on every RetNo change
    urRetNo,  //force retno change (after close return)?
    urForms,  //FormsList
    urErrors, //AuditList
    urRetColor, //panels color
    urShowAllControls, //20170518 Igor
    urViewSideBySide, //20170719 Igor
    urUpdateSkin,//20170824 Igor
    urAll     //check RetInMem,RetNo,AppId...
  );
  //20170429 Igor >>>
  TTabSheetEx = class(TTabSheet)
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure UMREMOVE(var Message: TMessage); message UM_REMOVETABSHEET;
  public
    ChildWidth: Integer;
    ChildHeight: Integer;
    ChildLeft: Integer;
    ChildTop: Integer;
    Stepson: TCustomForm;
    AppIDs: TArray<String>;
    RetNos: TArray<Integer>;
    destructor Destroy; override;
  end;
  //20170429 Igor <<<
var
  UpdateRequests: set of TUpdateRequest;

{$IFDEF old}
procedure Tvtnosplash.OnAppChanged(var Msg: TVTMReturnChanged);
begin

end;

procedure Tvtnosplash.OnAttribChanged(var Msg: TVTMReturnChanged);
begin

end;

procedure Tvtnosplash.OnFormChanged(var Msg: TVTMFormChanged);
begin

end;

procedure Tvtnosplash.OnRetNoChanged(var Msg: TVTMReturnChanged);
begin

end;

procedure Tvtnosplash.OnValueChanged(var Msg: TVTMValueChanged);
begin

end;
{$ELSE}
{$ENDIF}
//20170914 Igor>>>
procedure Tvtnosplash.InitCloudLog; //20190523 Igor
var cName, cEmail, cPhone: string;
    I: integer;
begin
  if not StartParams.IsCloud then Exit;
  cName := '';
  cEmail := '';
  cPhone := '';
  // not sure how to choose app for retrieving preparer_name,
  // each app has its own settings, so user can enter different values in apps
  // currently program searches first app where Preparer Name is not empty
  for I := 0 to AppList.Count - 1 do
  begin
    AppList.GetApp(I).LoadOptionsFileToMem;
    if not AppList.GetApp(I).Prp_Name.IsEmpty then
    begin
      cName := AppList.GetApp(I).Prp_Name;
      cEmail := AppList.GetApp(I).Prp_Email;
      cPhone := AppList.GetApp(I).Prp_Area + ' ' + AppList.GetApp(I).Prp_Tel;
      break;
    end;
  end;
  FCloudLogId := StartLogSession(cName, cEmail, cPhone);
  CloudLogTimer.Interval := 1000 * 60;
  CloudLogTimer.Enabled := true;
end;

procedure Tvtnosplash.InitGlobalMessage; //20190504 Igor
var
  Reg: TRegistry;
begin
  if not StartParams.IsCloud then Exit;
  btnSendGlobalMessage.Visible := StartParams.IsAdmin;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\VisualTax\',True);

    CurrGlobalMessageId := 0;
    if Reg.ValueExists('CurrGlobalMessageId') then
      CurrGlobalMessageId := Reg.ReadInteger('CurrGlobalMessageId');
  finally
    Reg.CloseKey();
  end;
  GlobalMessageTimer.Enabled := true;
end;

procedure Tvtnosplash.InitResizeForm;
begin
  if not Assigned(FResizeFormTimer) then
  begin
    FResizeFormTimer := TTimer.Create(Self);
    FResizeFormTimer.Enabled := False;
    FResizeFormTimer.Interval := 500;
    FResizeFormTimer.OnTimer := ResizeFormTimer;
  end;
  FResizeFormTimer.Enabled := False;
  FResizeFormTimer.Enabled := True;
end;

procedure Tvtnosplash.ResizeFormTimer(Sender: TObject);
var
  I: Integer;
  procedure DoResize(AForm: TvtScrollBox);
  begin
    if not Assigned(AForm) then
      Exit;
    AForm.Visible := False;
    try
      AForm.Activated(False, false);
    finally
      AForm.Visible := True;
      AForm.RestoreControlTop; //20210319 Igor
    end;
  end;
begin
  (Sender as TTimer).Enabled := False;
  if (ActiveMDIChild = nil) or
     not (ActiveMDIChild is TMyChild) or
     (TMyChild(ActiveMDIChild).ActiveForm = nil) then
    Exit;
  DoResize(TMyChild(ActiveMDIChild).ActiveForm);
  if (ReviewPanel.ActivePage = tabReview) and
     assigned(FPreviewForm) then
  begin
    for I := 0 to FPreviewForm.ControlCount-1 do
      if FPreviewForm.Controls[I] is TvtScrollBox then
      Begin
        DoResize((FPreviewForm.Controls[I] as TvtScrollBox));
        break;
      End
  end
  else
  if (ReviewPanel.ActivePage = tabLastyear) and
     assigned(FLastYearForm) then
  begin
    for I := 0 to FLastYearForm.ControlCount-1 do
      if FLastYearForm.Controls[I] is TvtScrollBox then
      Begin
        DoResize((FLastYearForm.Controls[I] as TvtScrollBox));
        break;
      End;
  end;
end;

procedure TvtNoSplash.UpdateReviewData;
begin
  if ReviewPanel.ActivePage = tabHide then
    Exit;
  if ReviewPanel.ActivePage = tabReview then
    ReviewFormsChange(ReviewForms)
  else
  if ReviewPanel.ActivePage = tabLastyear then
  Begin
    if buttonZoom50_50.Down then
    Begin
      if LeftPanel.Visible then
        ReviewPanel.Width := (ClientWidth - (LeftPanel.Left + LeftPanel.Width)) div 2
      else
        ReviewPanel.Width := (ClientWidth - LeftPanel.Left) div 2;
      ReviewPanelSplitter.Left := ReviewPanel.Left - ReviewPanelSplitter.Width;
      buttonZoom50_50Click(buttonZoom50_50);
    End;
    Comparison;
  End
  else
  if ReviewPanel.ActivePage = tsClientDocuments then
    UpdatePanelClientDocuments(GetCurrentRetNo)
  else
  if ReviewPanel.ActivePage = tsAutoFill then
    UpdatePanelAutoFill(GetCurrentRetNo);
end;


//20170914 Igor<<<

procedure Tvtnosplash.ReturnsListBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
	Bitmap: TBitmap;      { temporary variable for the item’s bitmap }
	Offset: Integer;      { text offset width }
  MyRet: TRetData;
  MyApp: TApp;
  idx: integer;
  lb: TListBox absolute Control;
  obj: TObject;
  MustRefresh: boolean;
  I: Integer;
  FClr: TColor;
begin
(* Index may be wrong, when the ListBox was not updated after Child close?
*)
try
  if not (Control is TListBox) then exit;
  if Index < 0 then exit;
  obj := nil; //keep compiler happy
  MyApp := nil;
  //MustRefresh := True; //on errors
  MustRefresh := ReturnsListBox.Items.Count <> TMyChild.ChildCount; //20170606 Igor
  if not MustRefresh then
  begin
    obj := lb.Items.Objects[Index];
  //!!! crash here with invalid obj (destroyed!?)
    MustRefresh := (obj = nil) or not (obj is TRetData) or TRetData(obj).Destroying;
  end;
  if not MustRefresh then
  begin
    MyRet := obj as TRetData; //failure???
    MyApp := MyRet.MyApp;
    MustRefresh := (MyApp = nil) or (RetList[MyRet.RetNo] <> MyRet);
  end
  else //if MustRefresh then//20170811 Igor
  begin
    include(UpdateRequests,urAll); //refresh returns listbox
    ReturnsListBox.Clear; //within Paint???
    exit;
  end;
	with lb.Canvas do  { draw on control canvas, not on the form }
	begin
    FillRect(Rect);       { clear the rectangle }
    Offset := 2;          { provide default offset }
    //Bitmap := TBitmap((Control as TListBox).Items.Objects[Index]);  { get the bitmap }
    idx := ord(MyApp.AppIdx);
    StatusBar1.SimpleText := 'AddIdx='+IntToStr(idx); //20160302 Igor
    AppImages.Draw(ReturnsListBox.Canvas, Rect.Left+Offset, Rect.Top, idx);
    (*
      BrushCopy(Bounds(Rect.Left + 2, Rect.Top, Bitmap.Width, Bitmap.Height),
        Bitmap, Bounds(0, 0, Bitmap.Width, Bitmap.Height), clRed);  {render bitmap}
      Offset := Bitmap.width + 6;    { add four pixels between bitmap and text}
    *)
    Offset := AppImages.Width + 6;
    //if State = [] then Brush.Color := MyRet.RetColor; //try color entries - BAD when selected!!!
      //Con: no colors!
    if MyRet.isAppendix then
    Begin
      FClr := Font.Color;
      Font.Color := clGray;
      TextOut(Rect.Left + Offset, Rect.Top, '  >> '+(Control as TListBox).Items[Index]);  { display the text }
      Font.Color := FClr;
    End
    else
      TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index])  { display the text }
	end;
  for I := 0 to PanelZoom.ControlCount - 1 do
    PanelZoom.Controls[I].Repaint; //20160305 Igor
except
//problems with AppIdx?
  ReturnsListBox.Clear;
end;
end;

procedure Tvtnosplash.ReturnsListBoxClick(Sender: TObject);
var
  i: integer;
  MyRet: RetPtr;
begin
//simplified, not handling last year?
  i := ReturnsListBox.ItemIndex;
  if i < 0 then
    exit;
  TObject(MyRet) := ReturnsListBox.Items.Objects[i];
  if Assigned(MyRet) AND MyRet.isAppendix then
  Begin
    for I := 0 to ReturnsListBox.Items.Count - 1 do
      if Assigned(ReturnsListBox.Items.Objects[i]) AND
         (RetPtr(ReturnsListBox.Items.Objects[i]).LastYearRetNo = MyRet.RetNo) then
      Begin
        MyRet := RetPtr(ReturnsListBox.Items.Objects[i]);
        ReturnsListBox.ItemIndex := I;
        break;
      End;
  End;
  if (MyRet <> nil)
  and (MyRet is RetPtr)
  and not MyRet.Destroying
  then begin
    if (RetNo = MyRet.RetNo) then exit;//20160805 Igot
    SetReturnsHeaderPanelNormalState; //20160805 Igor
    if MyRet.MyChild = nil then
      OpenForm(MyRet.RetNo, MyRet.MyApp.FirstForm, 0)
    else
    //20170719 Igor>>>
    begin
      if not MyRet.MyChild.Visible then
        MyRet.MyChild.Visible := True;
      if MyRet.MyChild.FormStyle <> fsMDIChild then
        MyRet.MyChild.FormStyle := fsMDIChild;
      MyRet.MyChild.BringToFront; // SetFocus;
    end;
    //20170719 Igor<<<
    Application.ProcessMessages; //20160305 Igor
    RetNo := MyRet.RetNo; //20160220 Igor
    GetCurrentRetNo := MyRet.RetNo; //20170619 Igor
    UpdateAdoptedPages(MyRet.MyApp, RetNo);//20170727 Igor
    UpdatePanelClientDocuments(RetNo);//20170714 Igor
    UpdatePanelAutoFill(RetNo);//20170729 Igor
    RebuildReviewForm;
    ReviewFormsChange(ReviewForms);  //20160220 Igor
    if CurrentApp <> AppList.AppFromId(MyRet.MyApp.AppId) then //20160223 igor
    Begin
      CurrentApp :=AppList.AppFromId(MyRet.MyApp.AppId); //20160223 Igor
      MainForm.GuiCommand(gcAppIdChanged);               //20160223 Igor
    End;

  //try force new return
    //MarkReturn; -> must be requested when child becomes active!
  end else
    ErrorMsg('no RetPtr?');
//force new returns listbox selection
  //RetNoChanged(0);
  //ChangeRetNo(0);
end;

procedure Tvtnosplash.MarkReturn;
var
  i: integer;
  RetRec: RetPtr;
begin
(* mark current return selected in ReturnsListBox
  Is RetNo always valid?
*)
  for i := 0 to ReturnsListBox.Items.Count - 1 do
  begin
    TObject(RetRec) := ReturnsListBox.Items.Objects[i];
    if RetRec <> nil then
    begin
      if RetRec.RetNo = RetNo then begin
        ReturnsListBox.ItemIndex := i; //hilite current return
        exit;
      end;
    end;
  end;
end;

procedure Tvtnosplash.UpdateReturns;
var
  i,j: integer;
  RetRec: RetPtr;
begin
  ReturnsListBox.Items.BeginUpdate;
  ReturnsListBox.Clear;
  for i := 1 to RetList.Count - 1 do begin
    RetRec := RetList[i];
    if (RetRec <> nil) and not RetRec.Destroying and RetRec.isCreateMDIChild then //20161028 Igor
    begin
      //ReturnsListBox.Items.AddObject(GetReturnCaption(RetRec.RetNo), RetRec);
      j := ReturnsListBox.Items.AddObject(RetRec.GetReturnCaption, RetRec);
      //if RetRec.RetNo = RetNo then ReturnsListBox.ItemIndex := j; //hilite current return
    end;
  end;
  MarkReturn; //before or after EndUpdate? - old RetNo!
  ReturnsListBox.Items.EndUpdate;
  if TMyChild.ChildCount > 0 then //20170606 Igor
    //ReturnsPanel.Height:=ReturnsHeaderPanel.Height+RetInMem * ReturnsListBox.ItemHeight+10;
    if ReturnsPanel.Align <> alClient then //20160426 Igor
    //20181217 Igor >>>
    begin
      ReturnsPanel.Height:=ReturnsHeaderPanel.Height+ReturnsListBox.Items.Count * ReturnsListBox.ItemHeight+10;
      if ReturnsPanel.Height > LeftPanel.Height div 2 then
        ReturnsPanel.Height := LeftPanel.Height div 2;
    end
    //20181217 Igor <<<
    else
      ReturnsPanel.Tag:=ReturnsHeaderPanel.Height+ReturnsListBox.Items.Count * ReturnsListBox.ItemHeight+10
  else
    ShowLeftPanel(False);
  if AppToolBar <> nil then //20161117 Igor
    AppToolBar.Refresh;
  exclude(UpdateRequests, urReturns);
end;

procedure Tvtnosplash.GuiCmd(cmd: eGuiCommand);
var
  dummy: boolean;
begin
  case cmd of
  //gcHideFlash: if ReturnsListBox.Items.Count > 0 then BringToFront;
  gcHideFlash: if RetInMem > 0 then
  Begin
    if assigned(Screen.ActiveForm) AND not (fsModal in Screen.ActiveForm.FormState) then  //20160229 Igor //20160630 Igor
      BringToFront;
  End;
  gcFormPaint:  include(UpdateRequests,urAll);  // FormPaint_;
  gcRefreshAuditPanel: include(UpdateRequests,urErrors);  // RefreshAuditPanel(RetNo); //RetNo?
  gcRefreshFormsPanel: include(UpdateRequests,urForms); // RefreshFormsPanel(RetNo);
  gcRetNoChanged: begin
      include(UpdateRequests,urRetNo);  // ChangeRetNo(GetCurrentRetNo);
      LoadRightPanelSettings;//20160222 Igor
      //RebuildReviewForm;//20160222 Igor //20170518 Igor
      //20170911 Igor>>>
      TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
          begin
            if RetInMem = 0 then
              ShowSplash;
          end);
      end).Start;
      //20170911 Igor<<<
    end;
  gcColorChanged: include(UpdateRequests,urRetColor); // UpdateColor(GetCurrentRetNo);
  gcReturns:      include(UpdateRequests,urReturns); //updateReturnsList
  gcChildClose: OnIdle(nil, dummy); //test what's going on

  gcAppIdChanged: ChangeApp(CurrentApp);
  gcAuditOpenBtnClick: AuditOpenBtnClick(nil);
  gcReduceTutorialHeight: ReduceTutorialHeight(nil);
  gcLicenseCheck: CheckLicenses;
  gcTutorials: TUTORIALS1Click(nil);
  gcExit: FileExit1Execute(nil);
  //gcQueryOpen:    FileOpen1Execute(nil); //fallback only!
  //gcCloseReturn:  FileCloseItemClick(nil);
  //gcSaveAs:       FileSaveAsItemClick(nil);
  gcSaveAll:      SaveAllOpenedReturnsClick(nil);
  //gcShowMostRecentReturns: ShowMostRecentReturns;
  gcSuperVerification: SuperVerificationBtnClick(nil);
  gcMDIArrange:   MDIArrange;
  gcShowLeftPanel:  ShowLeftPanel(True);
  gcHideLeftPanel:  ShowLeftPanel(False); //20160220 Igor
  gcToggleLeftPanel: AuditOpenBtnClick(nil); //toogles left panel!
  gcActiveFormChange: Comparison; //20160305 Igor;
  gcStartCloseReturn: FCloseReturnState := True;//20160311 Igor
  gcDoneCloseReturn: FCloseReturnState := False;  //20160311 Igor
  gcShowLastYear:
    Begin
      if SetActiveTab(tabLastyear) then//20171228 Igor
        ReviewPanelChange(ReviewPanel);
    End;
  gcHideLastYear:
    Begin
      if ReviewPanel.ActivePage = tabLastyear then
      Begin
        SetActiveTab(TabHide);//20171228 Igor
        ReviewPanelChange(ReviewPanel);
      end;
    End;
  gcUpdateLastYearIfOpenned:
    Begin
      if (ReviewPanel.ActivePage = tabLastyear) or
         (ReviewPanel.ActivePage = tabReview) then
        ReviewPanelChange(ReviewPanel)
    End;
  gcScroll: SynchronousDisplay;
  //20190115 Igor >>>
  gcNoScroll: begin
      ShowMessage('For scrolling speed, please use PgUp, PgDn or hit the page indicators above');
    end;
  //20190115 Igor <<<
  gcAvailableWidth:
    begin
      ReviewPanelSplitter.Tag := 0; //20161107 Igor
      ReviewPanelSplitterMoved(ReviewPanelSplitter); //20160406 Igor
    end;
  gcShowPriorYearList:  //20160519 Igor
    Begin
      with TvtRunArcForm.Create(nil) do
      begin
        Execute;
        Free;
        exit;
      end;
    end;
  gcSetReturnsHeaderPanelNormalState: SetReturnsHeaderPanelNormalState;
  //20170518 Igor >>>
  gcShowAllControls:
    include(UpdateRequests, urShowAllControls);
  //20170518 Igor <<<
  //20170719 Igor>>>
  gcShowSideBySidePanel:
      include(UpdateRequests, urViewSideBySide);
  //20170719 Igor<<<

  gcChangeSkin:
    include(UpdateRequests, urUpdateSkin);
//20171215 Igor>>>
  gcShowDiagnostics:
    ShowDiagnostics(GetCurrentRetNo);
//20171215 Igor<<<
  //20230307 Igor >>>
  gcShowFormsPanel:
    if (pgc.ActivePage <> tsForms) and (pgc.ActivePage <> tsBoth) then
    begin
      pgc.ActivePage := tsForms;
      pgcChange(pgc);
    end;
  //20230307 Igor <<<
  end;
end;

procedure Tvtnosplash.CallExecuteForm(var Msg: TMessage); //20170703 Igor
var
  AppID: eAppIdx;
  App: TApp;
begin
  try
    AppID := eAppIdx(Msg.WParam);
  except
    exit;
  end;
  App := AppList.GetApp(AppID);
  if Assigned(App) then
    App.CallExecuteForm(Msg.LParam);
end;

procedure Tvtnosplash.ChangeApp(MyApp: TApp);
var
//  tb: TPanel;//20170824 Igor
  I: Integer;
  J: Integer; // TCustomControl;
  ReturnFind, NeedRestoreSplash: Boolean; //20161111 Igor
  PrevRetNo: Integer; //20161117 Igor
  CurrenActiveTab: TTabSheet;//20171228 Igor
begin
  UpdateRequests := UpdateRequests + [urErrors];//20170728 Igor
  if MyApp = nil then begin //should be checked only after Create
  //show splash screen
    ShowLeftPanel(False);
    UpdateAdoptedPages(nil, 0);//20170727 Igor
    UpdatePanelClientDocuments(0);//20170714 Igor
    UpdatePanelAutoFill(0);//20170729 Igor
    ShowSplash;
    exit;
  end;

  if (CurApp = MyApp)
  and (CurLicense = MyApp.LicenseLevel) then
    exit;
  PrevRetNo := GetCurrentRetNo; //20161117 Igor

//20171228 Igor>>>
  CurrenActiveTab := ReviewPanel.ActivePage;
  tabReview.TabVisible := rtsReview in MyApp.RightTabSheets;
  tabLastyear.TabVisible := rtsPrevYear in MyApp.RightTabSheets;
  tsClientDocuments.TabVisible := rtsClientDocument in MyApp.RightTabSheets;
  tsAutofill.TabVisible := rtsAutoFill in MyApp.RightTabSheets;
  SetActiveTab(CurrenActiveTab);//20171228 Igor
//20171228 Igor<<<

//20170825 Igor<<<
  if assigned(RetList[PrevRetNo]) AND
     assigned(RetList[PrevRetNo].MyChild) then
  begin
    FpgcActivePageIndex := pgc.ActivePageIndex;
    FReviewPanelActivePageIndex := ReviewPanel.ActivePageIndex;
  end
  else
  begin
    FpgcActivePageIndex := MainOptionsToPgcActivePage.TabIndex;
    FReviewPanelActivePageIndex := MainOptions.RightPanelActivePageIndex;
  end;
//20170825 Igor<<<

//really changed
  CurApp := MyApp;
  CurLicense := MyApp.LicenseLevel;
  CurrentApp := MyApp;
  Caption := MyApp.AppTitle;

  //20161111 Igor >>>
  if not(assigned(RetList[GetCurrentRetNo]) and
          not RetList[GetCurrentRetNo].Destroying and
         (RetList[GetCurrentRetNo].MyApp = MyApp)) then
  begin
    ReturnFind := False;
    for I := 0 to RetList.Count - 1 do
    begin
      if not ReturnFind and
         assigned(RetList[I]) and
         not RetList[I].Destroying and
         (RetList[I].MyApp = MyApp) then
      begin
        NeedRestoreSplash := Screen.ActiveForm = Splash;
        ReturnFind := true;
        GetCurrentRetNo := I;
        ChangeRetNo(I);
        if assigned(RetList[I].MyChild) then
        begin
          RetList[I].MyChild.BringToFront;
          if pgc.ActivePageIndex <> FpgcActivePageIndex then
          begin
            pgc.ActivePageIndex := FpgcActivePageIndex;
            pgcChange(nil);//20170825 Igor
          end;
          if ReviewPanel.ActivePageIndex <> FReviewPanelActivePageIndex then
          begin
            SetActiveTab(FReviewPanelActivePageIndex);//20171228 Igor
            ReviewPanelChange(ReviewPanel);
          end;
        end;
        if NeedRestoreSplash then
          ShowSplash;
      end;
    end;
  end
  else
    ReturnFind := True;
  //20161111 Igor <<<
//20170824 Igor>>>
  DockGUI;
//20170824 Igor<<<

  //20161111 Igor >>>
  if (not ReturnFind or not assigned(RetList[GetCurrentRetNo].MyChild))
     and (MDIChildCount >= 1) then
  begin
    NeedRestoreSplash := Screen.ActiveForm = Splash;
//    if assigned(RetList[PrevRetNo]) AND           //20161117 Igor
//       assigned(RetList[PrevRetNo].MyChild) then  //20161117 Igor
//    begin
//      FpgcActivePageIndex := pgc.ActivePageIndex;
//      FReviewPanelActivePageIndex := ReviewPanel.ActivePageIndex;
//    end;
    if not ReturnFind then
    begin
      GetCurrentRetNo := 0;
      ChangeRetNo(0);     //20161117 Igor
    end;
    ApplicationState := ApplicationState + [asDummyFormShow];
    try
      if not assigned(FDummyForm) then
        FDummyForm := TfrmDummyMDIChild.Create(Self);
      FDummyForm.WindowState := wsMaximized; //20161117 Igor
      FDummyForm.BringToFront;
      FormsTreeView1.Items.Clear; //20161117 Igor
      RebuildReviewForm; //20170619 Igor
      if NeedRestoreSplash then
        ShowSplash;
      screen.Cursor := crDefault;
    finally
      ApplicationState := ApplicationState - [asDummyFormShow];
    end;
//  end
//  else
//  begin
//    if assigned(FDummyForm) then
//      freeAndNil(FDummyForm);
  end;
  //20161111 Igor <<<
//20170825 Igor>>>
//  //20170619 igor >>>
//  if assigned(RetList[PrevRetNo]) AND
//     assigned(RetList[PrevRetNo].MyChild) then
//  begin
//    FpgcActivePageIndex := pgc.ActivePageIndex;
//    FReviewPanelActivePageIndex := ReviewPanel.ActivePageIndex;
//  end
//  else
//  begin
//    FpgcActivePageIndex := MainOptionsToPgcActivePage.TabIndex;
//    FReviewPanelActivePageIndex := MainOptions.RightPanelActivePageIndex;
//  end;
//
//  //20170619 igor <<<
//20170825 Igor<<<
  if (MDIChildCount < 1) or
      not ReturnFind then //20161111 Igor
  begin
    ShowLeftPanel(False);
    SetActiveTab(tabHide);//20171228 Igor
    ReviewPanelChange(ReviewPanel); //20170619 igor
    //ShowSplash; - doesn't work here, only after this form is fully created!
  end
  else
  begin
  //offer all predefined forms for open
    RetList[GetCurrentRetNo].GetFrmTree(FormsTreeView1, UsedFormsBox.Checked); //mode? - on RetNoChanged!  //20160225 Igor
    //20170914 Igor>>>
    if (MainOptions.RightPanelActivePageIndex <> ReviewPanel.ActivePageIndex) and
       (MainOptions.RightPanelActivePageIndex >= 0) and
       (MainOptions.RightPanelActivePageIndex < ReviewPanel.PageCount) then
    begin
      SetActiveTab(MainOptions.RightPanelActivePageIndex);//20171228 Igor
      ReviewPanelChange(ReviewPanel); //20170619 igor
    end;
    //20170914 Igor<<<
    //FormsTreeview1.LoadFromFile(InitFrmTree(MyApp, FrmTreeForms));
  end;

//update buttons (after panel visibility updated)
  SelectFeatures;
//20160519 Igor >>>
  if TabControl1.TabIndex <> (TabControl1.Tabs.IndexOf(MyApp.AppId)) then //20161111 Igor
    TabControl1.TabIndex := (TabControl1.Tabs.IndexOf(MyApp.AppId));
  if assigned(Splash) then                //20161111 Igor
    Splash.SetActiveAppPage(MyApp.AppId); //20161111 Igor

  for I := 0 to screen.FormCount - 1 do
  Begin
    for J := 0 to Screen.Forms[I].ComponentCount - 1 do
    Begin
      if Screen.Forms[I].Components[j] is TPanel then
        (Screen.Forms[I].Components[j] as TPanel).ParentBackground := False;
    End;
  End;
//20160519 Igor <<<
end;

procedure Tvtnosplash.DockGUI;
var
  tb: TControl;
  I: Integer;

  function GetRibbon(AControl: TControl): TRibbon; //20180206 Igor
  var I: integer;
  begin
    Result := nil;
    if AControl is TRibbon then
    begin
      Result := TRibbon(AControl);
      Exit;
    end;
    if AControl is TWinControl then
      for I := 0 to TWinControl(AControl).ControlCount - 1 do
        if TWinControl(AControl).Controls[I] is TRibbon then
        begin
          Result := TRibbon(TWinControl(AControl).Controls[I]);
          break;
        end;
  end;
begin
//menu
//20170825 Igor>>>
  //20190415 Igor >>>
  if (MainOptions.Skin = skRibbon) then //20180206 Igor
  begin
    Menu := nil;
    //GetRibbon(CurApp.GetToolBar).ApplicationMenu.Menu.AutoFocus := False; //20180206 Igor
  end
  else
    Menu := CurApp.GetMenu;
//20170825 Igor<<<
//toolbar
  tb := CurApp.GetToolBar;
  if AppToolBar <> tb then
  begin
    //hide old toolbar
    if AppToolBar <> nil then
    begin
      pnlToolBarParent.AutoSize := False;//20170825 Igor
      //AppToolBar.Visible := False;
      if AppToolBar is TUIRibbon then
        TUIRibbon(AppToolBar).Visible := false
      else
        AppToolBar.parent := AppToolBar.Owner as TWinControl;
    end;
    AppToolBar := tb;
    tb.Parent := pnlToolBarParent; //Self;  //show it! //20161111 Igor {window less twitches}
    if AppToolBar is TUIRibbon then
      TUIRibbon(AppToolBar).Visible := true;
  //20190415 Igor <<<
//20170825 Igor>>>
    pnlToolBarParent.AutoSize := True;
//    pnlToolBarParent.Height := tb.Height; //20161111 Igor
//20170825 Igor<<<
    tb.Top := 0;  // ToolBar2.Top + 10; //sort it below the default toolbar
//    tb.Visible := True;
    TutorialsPanel.Top := tb.Top + 10;
  end;
end;

procedure Tvtnosplash.ChangeRetNo(RNo: integer);
begin
(* update all panels
- no returns -> splash screen only
- RNo=0 but returns open???
- left panel visible?
- what if ChildWin is closing -> wait for activate other one, or show splash
*)
  if csDestroying in componentstate then
    exit;
try
  UpdateRequests := UpdateRequests + [urErrors];//20170728 Igor
  UpdateReturns; //even if return stays the same (nil!)
  if Assigned(RetList[RNo]) then
    RetList[RNo].MyChild.ShowAllControls(True); //20170522 Igor
  UpdateAdoptedPages(CurrentApp, RetNo);//20170727 Igor
  UpdatePanelClientDocuments(RetNo); //20170714 Igor
  UpdatePanelAutoFill(RetNo); //20170729 Igor
  if RetList[RNo] = RetList[RetNo] then
    exit; //not really changed
  SetReturnsHeaderPanelNormalState; //20160805 Igor
  //if (RNo < 1) and (MDIChildCount > 0) then exit; //wait for valid RetNo
  //GetCurrentRetNo - 0 if child closing!
  RetNo := RNo;
  if RNo > 0 then begin
  //force all remaining updates
    UpdateRequests := UpdateRequests + [urErrors,urForms,urRetColor];
    //restore l/r panels
      ShowLeftPanel(True); //.Visible := True;  // LeftPanelVisible;
      //MDIArrange;
    ChangeApp(RetList[RetNo].MyApp); //valid for RetNo=0?
    //UpdateReturns; //hilite current
    MarkReturn; //now new RetNo should be valid
  //remaining by update flags
    //ShowDiagnostics(RetNo);
  //offer all predefined forms for open
    //RefreshFormsPanel(RetNo);
    //20170914 Igor>>>
    if MainOptions.RightPanelActivePageIndex <> ReviewPanel.ActivePageIndex then
    begin
      SetActiveTab(MainOptions.RightPanelActivePageIndex);//20171228 Igor
      ReviewPanelChange(ReviewPanel);
    end
    else
      UpdateReviewData;
    //20170914 Igor<<<
  end
  else //no returns shown
  begin
  //hide l/r panels
    //LeftPanelVisible := LeftPanel.Visible;
    ShowLeftPanel(False);
    //right panel: choose what?
    ShowSplash;
    exit;
  end;

{$IFDEF RPanel}
  ReviewPanel.RetNoChanged(RetNo); //.UpdatePanel;
//Adjust splitter
  ReviewPanelSplitter.Left := ReviewPanel.Left - 2;
{$ELSE}
{$ENDIF}

//adjust MDI?
  MDIArrange; //taking review panel into account
  //UpdateColor(RetNo); - requested above
  RebuildReviewForm; //20170518 Igor
finally
  exclude(UpdateRequests,urRetNo);
end;
end;

procedure Tvtnosplash.UpdateAdoptedPages(AApp: TApp; ARetNo: Integer);//20170727 Igor
var
  I: Integer;
  ts: TTabSheet;
  tsx: TTabSheetEx;
  J: Integer;
  lExists: Boolean;
  function ArrayContains(A: Array of string; Element: String): Boolean; overload;
  var
    I: Integer;
  begin
    for I := 0 to length(A) - 1 do
      if SameStr(A[I], Element) then
        exit(True);
    Result := false;
  end;
  function ArrayContains(A: Array of Integer; Element: Integer): Boolean; overload;
  var
    I: Integer;
  begin
    for I := 0 to length(A) - 1 do
      if A[I] = Element then
        exit(True);
    Result := false;
  end;
  procedure StoreActivePage;
  begin
    ts := ReviewPanel.ActivePage;
  end;
  procedure RestoreActivePage;
  begin
    if assigned(ts) and ts.TabVisible then
      SetActiveTab(ts)//20171228 Igor
    else
    begin
      SetActiveTab(tabHide);//20171228 Igor
      ReviewPanelChange(ReviewPanel);
    end;
  end;
begin
//clear
  for I := ReviewPanel.PageCount - 1 downto 0 do
  begin
    if ReviewPanel.Pages[I] is TTabSheetEx then
    begin
      tsx := TTabSheetEx(ReviewPanel.Pages[I]);
      if length(tsx.AppIDs) > 0 then
      begin
        lExists := False;
        for J := 0 to length(tsx.AppIDs) - 1 do
          if AppList.AppFromID(tsx.AppIDs[J]) <> nil then
          begin
            lExists := True;
            break;
          end;
        if not lExists then
        begin
          StoreActivePage;
          tsx.Free;
          RestoreActivePage;
          Continue;
        end;
      end;
      if length(tsx.RetNos) > 0 then
      begin
        lExists := False;
        for J := 0 to length(tsx.RetNos) - 1 do
          if (tsx.RetNos[J] >= 0) AND
             (tsx.RetNos[J] < RetList.Count) AND
             Assigned(RetList[tsx.RetNos[J]]) AND
             not RetList[tsx.RetNos[J]].Destroying then
          begin
            lExists := True;
            break;
          end;
        if not lExists then
        begin
          StoreActivePage;
          tsx.Free;
          RestoreActivePage;
          Continue;
        end;
      end;
    end;
  end;

//show/hide
  for I := 0 to ReviewPanel.PageCount - 1 do
  begin
    if ReviewPanel.Pages[I] is TTabSheetEx then
    begin
      tsx := TTabSheetEx(ReviewPanel.Pages[I]);
      if (
           (Length(tsx.AppIDs) = 0)
           or
           (
             Assigned(AApp)
             AND
             ArrayContains(tsx.AppIDs, AApp.AppId)
           )
         )
         AND
         (
           (Length(tsx.RetNos) = 0)
           or
           (
             (ARetNo > 0)
             AND
             ArrayContains(tsx.RetNos, ARetNo)
           )
         )
          then
      begin
        if not ReviewPanel.Pages[I].TabVisible then
        begin
          StoreActivePage;
          ReviewPanel.Pages[I].TabVisible := True;
          RestoreActivePage;
        end;
      end
      else
        if ReviewPanel.Pages[I].TabVisible then
        begin
          StoreActivePage;
          ReviewPanel.Pages[I].TabVisible := False;
          RestoreActivePage;
        end;
    end;
  end;


end;

procedure Tvtnosplash.UpdateColor(RetNo: integer);
var
  clr: TColor;
begin
(* update all panels using tax color
*)
  if RetNo < 1 then
    Clr := Rgb(255,255,240)//AuditPanel.Color;
  else
    clr := GetRetColor(RetNo);
  if clr < $300000 then
    Clr := Rgb(255,255,240);//AuditPanel.Color;
  ErrorView.Color := clr;
  FormsTreeView1.Color := clr;
  Exclude(UpdateRequests,urRetColor);
end;

procedure Tvtnosplash.UpdatePanelClientDocuments(ARetNo: Integer); //20170714 Igor
begin
  if ReviewPanel.ActivePage <> tsClientDocuments then
    exit;
  if not Assigned(FClientFilesFrame) then
  //20170721 Igor>>>
  begin
    FClientFilesFrame := TClientFilesFrame.Create(Self);
    FClientFilesFrame.Name := 'fraClientFilesFrame';
  end;
  //20170721 Igor<<<
  if not Assigned(RetList[ARetNo]) or
     RetList[ARetNo].Destroying then
    FClientFilesFrame.Init(tsClientDocuments, '')
  else
    FClientFilesFrame.Init(tsClientDocuments, RetList[ARetNo].GetDirClientDocs);
end;

procedure Tvtnosplash.UpdatePanelAutoFill(ARetNo: Integer);//20170720 Igor
begin
  if ReviewPanel.ActivePage <> tsAutofill then
    exit;
  if not Assigned(FAutoFillFrame) then
  begin
    FAutoFillFrame := TClientFilesFrame.Create(Self);
    FAutoFillFrame.Name := 'fraAutoFillFrame';
  end;
  if not Assigned(RetList[ARetNo]) or
     RetList[ARetNo].Destroying then
    FAutoFillFrame.Init(tsAutofill, '')
  else
    FAutoFillFrame.Init(tsAutofill, RetList[ARetNo].MyApp.Dir_AutoFill, RetList[ARetNo].GetTDDFileName, RetList[ARetNo].MyApp); // 20180530 Igor
end;

procedure Tvtnosplash.FormCreate(Sender: TObject);
 //20160209 Igor
//var
//  w: integer;
begin
  //20201117 Igor >>>
  if IsvtClient then //20210112 Igor
    TabControl1.Visible := false;
  //20201117 Igor <<<
//20170825 Igor>>>
  Logoned := False;
  //20170825 Igor<<<
  //20160114 Igor
  if assigned(MainOptions) then
  Begin
    MainOptions.tbZoom := tbZoom;
    MainOptions.lblZoom := lblZoom;
    MainOptions.ZoomForm := zfAll; //20160209 Igor
  End;
//production conforming
  inherited FormCreate(Sender); //loads MainOptions

  //if ComboBox1.Items.Count = 0 then
  if RetList.Count = 0 then
  begin
    ShowMessage('No AppId installed - exiting program');
    Application.Terminate;
  end;

//tutorials
  TutHistoryIndex := -1;
  TutHistoryList := TStringList.Create;
  TutUpdateCombo:=True;
  //HelpKeyW:=TStringList.Create;

{$IFDEF RPanel}
//right panel
  ReviewPanel := TReviewChoice.Create(self);
  ReviewPanel.Parent := self;
  ReviewPanel.Align := alRight;
 //20160209 Igor
//  w := MainOptions.RightPanelWidth;
//  if w <= 0 then
//    w := 100;
//  ReviewPanel.UndockWidth := w;
  ReviewPanelSplitter.Left := ReviewPanel.Left - 1; //<---- delta must be less than splitter width!
  ReviewPanel.Init(vmNone); //GetReviewChoice);
  ReviewPanelSplitter.Visible := ReviewPanel.Width > 2;
{$ELSE}
 //20160209 Igor
//  w := MainOptions.RightPanelWidth;
//  if w <= 0 then
//    w := 100;
//  ReviewPanel.UndockWidth := w;
  SetActiveTab(tabHide);//20171228 Igor
  ReviewPanel.OnChange(self); //hide it
{$ENDIF}

//left panel
{$IFDEF icons}
  ReturnsListBox.Style := lbOwnerDrawFixed;
{$ELSE}
  ReturnsListBox.Style := lbStandard;
{$ENDIF}
  ShowLeftPanel(False); //show only when returns are loaded
 //20160209 Igor
//  w := MainOptions.LeftPanelWidth;
//  if w > 0 then
//    LeftPanel.Width := w;

  SuperFeaturesLbl.Caption:='';

//clone
  MainForm.LeftPanel := LeftPanel;
  MainForm.FormsPanel := FormsPanel;
  MainForm.WizardPanel := WizardPanel;
  MainForm.UsedFormsBox := UsedFormsBox;
  MainForm.GuiCommand := GuiCmd; //move before inherited, to perform license checks?
  //MainForm.AuditPanel := AuditPanel;
  MainForm.AppImages := AppImages;
  MainForm.SuperAuditBox := SuperAuditBox;
  MainForm.SuperVerificationBtn := SuperVerificationBtn;
  MainForm.EkRtf1 :=EkRTF1;
  MainForm.PrintDialogItem := PrintDialogItem;
  MainForm.ViewSideBySidePanel := pnlViewSideBySide;
  MainForm.Validate;

//splash screen must have been initialized already?
//before loading apps!?
//include?  - configure splash screen
(* --- this would make Splash the MainForm!!!
  if Splash = nil then
    Application.CreateForm(TSplash,Splash);
*)
  //AppList.InitGUI(Self); //now MainForm is available, map all handlers
  //CurrentApp.Activate;
//--------
//select the last used/any licensed AppId
  AppList.InitApps;
(*
  //CheckLicenses; - here: crash with no CurrentApp in SelectFeatures?
  if MainOptions.LastAppId <> '' then
    CurrentApp := AppList.AppFromID(MainOptions.LastAppId); //!!! AppName only!

  if CurrentApp = nil then
      //showSplash; //do what? - not while in FormCreate!?
    ...
*)
  ChangeApp(CurrentApp);
  Application.OnIdle := OnIdle; //install OnIdle handler
  //20190501 Igor >>>
  InitGlobalMessage;
  //20190501 Igor <<<
  InitCloudLog; //20190523 Igor
  TabControl1.TabIndex:=-1; // 20151120 Igor

  Application.OnShowHint := AppShowHint; //20160519 Igor
end;

procedure Tvtnosplash.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);  //20160720 Igor
var
  C: TControl;
  P: TPoint;
  M: TMessage;
begin
  inherited;
  P := MousePos;
  C := ControlAtPos(P, True, true, false);
  if assigned(C) then
  begin
    repeat
      if C is TvtForm then
      begin
        if WheelDelta < 0 then
        begin
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEDOWN, 0);
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEDOWN, 0);
        end
        else
        begin
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEUP, 0);
          TvtForm(C).Perform(WM_VSCROLL, SB_LINEUP, 0);
        end;
        break;
      end;
      if C is TWinControl then
      begin
        P := C.ParentToClient(P);
        C := TWinControl(C).ControlAtPos(P, True, true, false);
      end
      else
        break;
    until c = nil;
  end
  else
    if Assigned(ActiveMDIChild) then
      if assigned(ActiveMDIChild.OnMouseWheel) then
        ActiveMDIChild.OnMouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);

end;

procedure Tvtnosplash.FormPaint_;
Var
  h : integer;
  RetsInMem: boolean;
begin
(* Show/hide splash screen (AboutPanel), splitters...
  Make splash screen visible if no return is shown(?)
*)
  RetsInMem := RetInMem > 0;
  if not RetsInMem AND LeftPanel.Visible then //20160302 Igor
    ShowLeftPanel(False);  //20160302 Igor

// OnRetNoChanged?

  If TutorialsPanel.Visible then
  begin
    TutorialZoomInBtn.Visible:=RetsInMem;
    TutorialZoomOutBtn.Visible:=RetsInMem;
    //ToolBoxSplitter.Visible := RetsInMem;
    h := Height - TutorialsPanel.Top;
    If RetsInMem then
      TutorialsPanel.Height:=h div 3
    else
     TutorialsPanel.Height:=h;  // * 3 div 4
  end;

  //SelectFeatures; //only if/in AppChanged

  if LeftPanel.Visible then begin
//    WizardPanel.Visible:=RetsInMem; //20160426 Igor
    UpdateReturns;
  end;
  Screen.Cursor := crDefault;
  if RetsInMem then
    UpdateRightPanel
  else
    ShowSplash;
  exclude(UpdateRequests,urAll);
end;

procedure Tvtnosplash.FormResize(Sender: TObject);
begin
  inherited;
  PanelZoom.Left := StatusBar1.Width - PanelZoom.Width - 16; //20160301 Igor

//  //20160114 Igor
//  tbZoom.Left := StatusBar1.Width - tbZoom.Width - 2;
//  lblZoom.Left := tbZoom.Left - lblZoom.Width - 4;
// //20160209 Igor >>>
//  rbZoomRight.Left := lblZoom.Left - rbZoomRight.Width - 4;
//  rbZoomCenter.Left := rbZoomRight.Left - rbZoomCenter.Width - 4;
//  rbZoomAll.Left := rbZoomCenter.Left - rbZoomAll.Width - 4;
// //20160209 Igor <<<
end;

//paint

Procedure Tvtnosplash.RefreshAuditPanel(RetNo:Integer);
var
  AuditMode: eAuditMode;
  i: integer; //20171212 Igor
begin
(* By default called from CountDiagnostics, to trigger display.
  Prevent loops when calling CountDiagnostics here!
*)
  If RetNo=0 then
  begin
    ErrorView.Items.Clear;
    exit;
  end;

ErrorView.Items.BeginUpdate;
  ErrorView.Items.Clear;

  if SuperAuditSw then
  //if (SuperAuditBox.Checked) and (SuperAuditBox.Enabled) then
    AuditMode := amSuperAudit
  else
    AuditMode := amStd;
  ErrorView.Color := RetList[RetNo].RetColor; //why not initialized properly?
    //is reset by AppIds depending on RetInMem! (remove!)
  RetList[RetNo].CountDiagnostics; //always - ignore callback
  SuperFeaturesLbl.Caption := RetList[RetNo].RefreshAuditPanel(ReturnsHeaderPanel, ErrorView, AuditMode);
  if ErrorView.Items.Count > 0 then
  begin
    //20171212 Igor>>
    for I := 0 to ErrorView.Items.Count - 1 do
      if ErrorView.Items[I].Level = 0 then
        ErrorView.Items[I].Expand(False);
    //20171212 Igor<<
    ErrorView.TopItem:=ErrorView.Items[0];
  end;
ErrorView.Items.EndUpdate;
  //UpdateColor(RetNo);
  Exclude(UpdateRequests,urErrors); //can be set again during CountDiagnostics!
end; {procedure}

procedure Tvtnosplash.SideBySideBtnClick(Sender: TObject);
begin
{$IFDEF old}
//new function - missing button?
  if ScrollInSync then begin
  //end sync scroll
    ScrollInSync := False;
    exit;
  end;
//start sync scrolling
  ShowMessage('Show identical forms for husband/wife or show This year/Last year forms and SCROLL TOGETHER'
    +Chr(13)+'Other existing forms should be Closed or minimized')
    //+Chr(13)+'Scaling may be required')
  ;
  if ReviewPanel.Width > 100 then
    ReviewPanel.Width :=Self.width div 6;
//instruct all open MDI children to scroll synchronously
  ScrollInSync := True;
  //TileMode:=tbVertical;
  //ArrangeMode := amTile;
  MDIArrange; // Tile;
{$ELSE}
{ TODO : SideBySide }
{$ENDIF}
end;

procedure Tvtnosplash.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  ctl,shft: boolean;
begin
(* Global Hotkeys, also work in MDI forms (unless captured there).

  When another active form (MDI...) implements an ShortCut handler,
  that one is called first
  and it can set Handled=True, to prevent any further handling.
*)
  ctl := GetKeyState(VK_CONTROL) < 0;
  shft := GetKeyState(VK_SHIFT) < 0;
//control combinations
  if ctl and not shft then
  begin
    if (msg.CharCode = ord('S'))
    and not ButtonInactive then
    begin //CTRL-S
      RetList[RetNo].DoSaveAs;
      Handled := True;
    end;
    exit; //all CTRL combinations handled
  end;

  if ctl or shft then
    exit;

//bare keys
  case Msg.CharCode of
  VK_F3: MainForm.FileSaveAsItemClick(RetNo);
  VK_F5: AuditOpenBtnClick(nil);  // Panel.Visible:= Not AuditPanel.Visible;
  //VK_F7: {MainForm.}Switchforms1Click(Application);
  else
    exit; //unhandled
  end; //case
  Handled := True;
end;

procedure Tvtnosplash.FormShow(Sender: TObject); //20160209 Igor
var
  w, J: Integer;
  SlfWidth, SlfHeight: Integer;
  M: TMonitor;  //20160225 Igor
begin
  inherited;
  SendToBack; //20200310 Igor
  //20160225 Igor >>>>
  if Self.WindowState = wsMaximized then
  Begin
    M := nil;
    for J := 0 to Screen.MonitorCount-1 do
    if (Self.Left >= Screen.Monitors[J].Left) AND (Self.Left <= Screen.Monitors[J].Left+Screen.Monitors[J].Width)
       AND
       (Self.Top >= Screen.Monitors[J].Top) AND (Self.Top <= Screen.Monitors[J].Top+Screen.Monitors[J].Height) then
    Begin
      M := Screen.Monitors[J];
      break;
    End;
    if not Assigned(M) then
      M := Screen.Monitors[0];
    SlfWidth := M.Width;
    SlfHeight := M.Height;
  End
  else
  Begin
    SlfWidth := Self.Width;
    SlfHeight := Self.Height;
  End;
  //20160225 Igor <<<<
  w := MainOptions.RightPanelWidth;
  if w <= 0 then
    w := ROUND(SlfWidth * 0.35); //20160225 Igor
  if w > round(SlfWidth * 0.85) then //20160225 Igor
    w := round(SlfWidth * 0.85); //20160225 Igor
  ReviewPanel.UndockWidth := w;

  w := MainOptions.LeftPanelWidth;
  if w <= 0 then
    w := ROUND(SlfWidth * 0.15);  //20160225 Igor
  if w > round(SlfWidth - ReviewPanel.UndockWidth) then //20160225 Igor
    w := round(SlfWidth - ReviewPanel.UndockWidth - Self.Width*0.05); //20160225 Igor
  LeftPanel.Width := w;

   //20160225 Igor >>>>>
  w := MainOptions.FormPanelHeight;
  if w <= 0 then
    w := ROUND((SlfHeight - AppToolBarHeight - ReturnsPanel.Height) * 0.4);
  if w > round((SlfHeight - AppToolBarHeight - ReturnsPanel.Height) * 0.9) then
    w := round((SlfHeight - AppToolBarHeight - ReturnsPanel.Height) * 0.8);
  formsPanel.Height := w;
   //20160225 Igor <<<<
  //20160426 Igor >>>
  actViewReturnsList.Checked := true; //MainOptions.ReturnsPanelVisible; //20160529 Igor
  actViewAudit.Checked := MainOptions.AuditPanelVisible;
  actViewForms.Checked := MainOptions.FormsPanelVisible;
//  SetPgcActivePage; //20160522 Igor
  SetLeftPanelPartVisible; //20160516 Igor
  //20160426 Igor <<<
end;

//20170619 Igor >>>
function Tvtnosplash.MainOptionsToPgcActivePage: TTabSheet;
begin
  if MainOptions.AuditPanelVisible AND
     MainOptions.FormsPanelVisible then
    Result := tsBoth //20160516 Igor
  else
  if MainOptions.FormsPanelVisible then
    Result := tsForms
  else
  if MainOptions.AuditPanelVisible then
    Result := tsDiagnostics
  else
    Result := tabRightPanelHide;
end;

procedure Tvtnosplash.SetPgcActivePage; //20160522 Igor
begin
  //20160428 Igor >>>
  pgc.ActivePage := MainOptionsToPgcActivePage;
//  if MainOptions.AuditPanelVisible AND
//     MainOptions.FormsPanelVisible then
//    pgc.ActivePage := tsBoth //20160516 Igor
//  else
//  if MainOptions.FormsPanelVisible then
//    pgc.ActivePage := tsForms
//  else
//    pgc.ActivePage := tsDiagnostics; //20160516 Igor
  //20160428 Igor <<<
end;
//20170619 Igor <<<

procedure Tvtnosplash.SetReturnsHeaderPanelNormalState; //20160805 Igor
begin
  ReturnsHeaderPanel.Caption:='Returns';
  ReturnsHeaderPanel.Color:=$00AC7400;
  ReturnsHeaderPanel.Font.Color:=$00A6CAF0;
end;

procedure Tvtnosplash.SetupSubForm(var AForm: TForm; ATabSheet: TTabSheet); //20161129 Igor
begin
  if assigned(AForm) then
    exit;
  AForm := TForm.CreateNew(Application);
  AForm.Parent := ATabSheet;
  AForm.Align := alClient;
  AForm.BorderIcons := [];
  AForm.BorderStyle := bsNone;
  AForm.Visible := True;
end;

procedure Tvtnosplash.ShowDiagnostics(RetNo: integer);
Var
  TempList: TStringList;
begin
(* RefreshAuditPanel
  Force visible?
  RetNo required, it may not yet be the current one!
*)
  ShowLeftPanel(RetNo>0);
  if RetNo < 1 then
    exit; //don't show

  RefreshAuditPanel(RetNo);
end;

procedure Tvtnosplash.AuditListDblClick(Sender: TObject);
var
  SourceNode: TTreeNode;
begin
  //if ButtonInactive then exit; //Get RetNo - really the right one???
{ TODO : audit list click }
  SourceNode := AuditList.Selected;
  if SourceNode = nil then
    exit; //invalid click
  RetList[RetNo].OpenAuditOrigin(SourceNode);
end;

procedure Tvtnosplash.SuperVerificationBtnClick(Sender: TObject);
var
  FileName, FormName: string;
begin
//should be T1 production conforming (virtual!)
  if ButtonInactive then exit;
  RetList[RetNo].RefreshAuditPanel(ReturnsHeaderPanel, ErrorView, amSuperVericifcation);
end;

procedure Tvtnosplash.SynchronousDisplay; //20160312 Igor
var
  MyScrollBox,
  LastYearScrollBox: TvtScrollBox;
  I, MaxV,MaxVLY,MaxH,MaxHLY: Integer;

begin
  if not buttonSynchronousDisplay.Down or  (ReviewPanel.ActivePage <> tabLastYear) then exit; //20160314 Igor
  if not assigned(Application.MainForm) then exit;
  if not assigned(Application.MainForm.ActiveMDIChild) then exit;
  if not (Application.MainForm.ActiveMDIChild is TMyChild) then exit; //20161111 Igor
  MyScrollBox := (Application.MainForm.ActiveMDIChild AS TMyChild).ActiveForm;
  if not assigned(MyScrollBox) then exit;
  LastYearScrollBox := nil;
  //20161129 Igor >>>
  if assigned(FLastYearForm) then
    for I := 0 to FLastYearForm.controlCount - 1 do
      if FLastYearForm.controls[I] is TvtScrollBox then
      Begin
        LastYearScrollBox := (FLastYearForm.controls[I] as TvtScrollBox);
        break;
      End;
  //20161129 Igor <<<
  if not Assigned(LastYearScrollBox) then exit;

  MaxV := MyScrollBox.VertScrollBar.Range - MyScrollBox.Height + 20;
  MaxH := MyScrollBox.HorzScrollBar.Range - MyScrollBox.Width + 20;

  MaxVLY := LastYearScrollBox.VertScrollBar.Range - LastYearScrollBox.Height + 20;
  MaxHLY := LastYearScrollBox.HorzScrollBar.Range - LastYearScrollBox.Width + 20;

  if LastYearScrollBox.Handle = ScrollSender then
  Begin
    if (MaxVLY > 0) AND (MaxV > 0) then //20160314 Igor
      MyScrollBox.VertScrollBar.Position := ROUND(LastYearScrollBox.VertScrollBar.Position / MaxVLY * MaxV);
    if (MaxHLY > 0) AND (MaxH > 0) then //20160314 Igor
      MyScrollBox.HorzScrollBar.Position := ROUND(LastYearScrollBox.HorzScrollBar.Position / MaxHLY * MaxH);
  End
  else
  if MyScrollBox.Handle = ScrollSender then
  Begin
    if (MaxVLY > 0) AND (MaxV > 0) then //20160314 Igor
      LastYearScrollBox.VertScrollBar.Position := ROUND(MyScrollBox.VertScrollBar.Position / MaxV * MaxVLY);
    if (MaxHLY > 0) AND (MaxH > 0) then //20160314 Igor
      LastYearScrollBox.HorzScrollBar.Position := ROUND(MyScrollBox.HorzScrollBar.Position / MaxH * MaxHLY);
  End;
end;

procedure Tvtnosplash.ErrorViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  SourceNode : TTreeNode;
  r: TObject;
  ro: TOverRec absolute r;
  MyScrollBox: TvtScrollBox;
  MyEditBox: TvtEdit;
begin
  if ButtonInactive then exit;
//production conforming
  If Button = mbLeft then  //20110224
  begin
   // ErrorViewClick(Sender);   //20160422 Igor
    Exit;
  end;

  If Button = mbRight then  //20110224
  begin
  //signoff the warning
    SourceNode:= ErrorView.GetNodeAt(X, Y);
    if not Assigned(SourceNode) then
      exit;
(* We could use the source node immediately.
*)
    r := TObject(SourceNode.Data);
  //overrides!?
    if r = nil then exit;
    if r is TAuditRec then
      SignOffAWarning(RetNo, TAuditRec(r)) // SourceNode.Text)
    else if r is TOverRec then
    begin
      MyScrollBox := TvtScrollBox(OpenFormNo(ro.RetNo, ro.FormNo, ro.FieldId));
      //MyScrollBox := GetScrollbox(RetList[RetNo],RetList[retNo].GetFormName(ro.FormNo));
      if MyScrollBox <> nil then
      begin
        MyEditBox := TvtEdit(MyScrollBox.FindComponent('vtEdit'+IntToStr(ro.FieldId)));
        if MyEditBox <> nil then
          MyScrollBox.ToggleOverride(MyEditBox)
        else
          ErrorMsg('vtEdit' + IntToStr(ro.FieldId)+ ' not found');
        //OverList.Remove(r); //removes the override from all lists
        RefreshAuditPanel(RetNo);
      end
    end
    else
      ErrorMsg('unknown audit type: ' + r.ClassName);
  end;
end;

procedure Tvtnosplash.ErrorViewMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer); //20160519 Igot
var
    MousePos : TPoint;
    ItemPos  : TRect;
    RowWidth,
    ItemNum  : Integer;
    FHint    : String;
    Node: TTreeNode;
begin
  MousePos.X := X;
  MousePos.Y := Y;
  Node := ErrorView.GetNodeAt(X, Y); //get current node
  if not Assigned(Node) then
    ItemNum := -1
  else
    ItemNum := Node.AbsoluteIndex;
  if (ItemNum <> FHintRow) then //if node changed
  begin
    FHintRow := ItemNum;
    if ItemNum > -1 then
    begin
      ItemPos := Node.DisplayRect (TRUE);
      Application.CancelHint;
      ErrorView.Tag := ItemPos.Left * 10000 + ItemPos.Top; //Save position
      FHint := Node.Text;
      RowWidth := ErrorView.Canvas.TextWidth( FHint );
      if (ItemPos.Left + RowWidth > (ErrorView.ClientWidth - ErrorView.Indent)) then //if text very long //20171204 Igor
      Begin
        ErrorView.Hint := FHint;
        Application.ActivateHint(MousePos); //show hint (position corrected in AppShowHint)
      End
      else //20171204 Igor
        ErrorView.Hint := ''; //20171204 Igor
    end
    else
    begin
      ErrorView.Hint := '';
      Application.CancelHint;
      ErrorView.Tag := -1;
    end;
  end
end;

procedure Tvtnosplash.AppShowHint(var HintStr: string; var CanShow: Boolean; //20160519 Igor
  var HintInfo: THintInfo);
Var Pos : TPoint;
begin
  with HintInfo do
    if HintControl is TTreeView then
     begin
       Pos.X := HintControl.Tag div 10000;
       Pos.Y := HintControl.Tag mod 10000;
       HintPos := HintControl.ClientToScreen(Pos);
       HintStr := HintControl.Hint;
     end;
end;

procedure Tvtnosplash.ErrorViewClick(Sender: TObject);
Var
  SourceNode : TTreeNode; //Ndx :Integer;
  AuditMode: eAuditMode;
  r: TObject;
  OverRec: TOverRec absolute r;
begin
//production conforming
  if ButtonInactive then exit;
  If RetList[RetNo].IsLastYearReturn then Exit;
  SourceNode:= ErrorView.Selected;
  if SourceNode = nil then
    exit; //how this?
//new: by Data
  r := TObject(SourceNode.Data);
  if r = nil then
    exit; //header node?
  if r is TAuditRec then
    RetList[RetNo].OpenAuditOrigin(SourceNode) //(r)?
  else if r is TOverRec then
  begin
    OpenForm(OverRec.RetNo,OverRec.FormNo,OverRec.FieldId);
  end else
    ErrorMsg('unknown audit: '+r.ClassName);
end;

procedure Tvtnosplash.TreeViewGetImageIndex(Sender: TObject; Node: TTreeNode); //20180206 Igor
begin
  //documents
  if Sender = FormsTreeView1 then
  begin
    if SameText(Trim(Node.Text), '') then
      Node.ImageIndex := -1
    else if Node.HasChildren then
    begin
      if Node.Expanded then
        Node.ImageIndex := 5
      else
        Node.ImageIndex := 4
    end
    else
      Node.ImageIndex := 6
  end
  //errors
  else
  begin
    if SameText(Trim(Node.Text), '') then
      Node.ImageIndex := -1
    else if (Node.Parent = nil) and not Node.HasChildren then
      Node.ImageIndex := 3
    else if Node.HasChildren then
    begin
      if Node.Expanded then
        Node.ImageIndex := 1
      else
        Node.ImageIndex := 0
    end
    else
      Node.ImageIndex := 2;
  end;
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure Tvtnosplash.FormsTreeView1Click(Sender: TObject);
Var
  SourceNode : TTreeNode; //Ndx,
  FNo:Integer; //Fname:String;
begin
//production conforming
  If ButtonInactive then exit;
  If RetList[RetNo].IsLastYearReturn then
  begin
    ShowMessage('Function not available for last year'+Chr(39)+'s forms. Press F2 instead');
    exit; //?
  end;
  Try
    SourceNode:= FormsTreeView1.Selected;
    //Ndx :=SourceNode.AbsoluteIndex;

    If SourceNode.Expanded then
      SourceNode.Collapse(True)
    else If SourceNode.HasChildren then
      SourceNode.Expand(True);

    FNo := RetList[RetNo].GetFrmTreeFNo(SourceNode, UsedFormsBox.Checked);
    if FNo > 0 then
      OpenFormNo(RetNo,FNo,0)
    else
      RetList[RetNo].MyApp.FrmTreeCustomNodeClick(SourceNode);
  except on e: Exception do ExceptMsg(e);
  end;
end;

procedure Tvtnosplash.FormsTreeView1KeyPress(Sender: TObject;
  var Key: Char);
begin
//production conforming
  FormsTreeView1Click(Sender);
end;

procedure Tvtnosplash.TutorialsPanelResize(Sender: TObject);
begin
  inherited; //?
  MDIArrange;
end;

procedure Tvtnosplash.ShowTutorialsPanel(fShow: boolean);
begin
(* properly show/hide TutorialsPanel, including splitter!
  toolbar above tutorials!
*)
  if TutorialsPanel.Visible = fShow then
    exit;
  if fShow then begin
    TutorialsPanel.Visible := True;
    TutorialsPanel.Top := AppToolBar.Top + AppToolBar.Height + 10;
    ToolBoxSplitter.Top := TutorialsPanel.Top + 100;
    ToolBoxSplitter.Visible := True;
  end else begin
    ToolBoxSplitter.Visible := False;
    TutorialsPanel.Visible := False;
  end;
  MDIArrange;
end;

procedure Tvtnosplash.ShowLeftPanel(fShow: boolean);
begin
(* properly show/hide LeftPanel, including splitter!
*)
  if LeftPanel.Visible = fShow then
    exit;
  if fShow then begin
    if LeftPanel.Width = 0 then
      LeftPanel.Width := AuditPanelSplitter.Tag;
    LeftPanel.Visible := True;
    AuditPanelSplitter.Left := LeftPanel.Left+LeftPanel.Width; // right of LeftPanel! //20160220 Igor
    AuditPanelSplitter.Visible := True;
    AuditPanelSplitter.Refresh; //20160522 Igor;
    SetPgcActivePage; //20160522 Igor
    ReviewPanelSplitter.Tag := 0; //20170224 Igor
  end else begin
    AuditPanelSplitter.Visible := False;
    LeftPanel.Visible := False;
    pgc.ActivePage := tabRightPanelHide;
    ReviewPanelSplitter.Tag := 0; //20170224 Igor
  end;
  MDIArrange;
  //20170914 Igor>>>
  if (ReviewPanel.ActivePage = tabLastYear) and buttonZoom50_50.Down then
    buttonZoom50_50Click(buttonZoom50_50);
  //20170914 Igor<<<
  Application.ProcessMessages; //20160220 Igor
end;

procedure Tvtnosplash.AuditOpenBtnClick(Sender:TObject);
begin
(* TOGGLE the audit/left panel
*)
  If ButtonInactive then exit; //? hide panel?

  if not LeftPanel.Visible then
    ShowDiagnostics(RetNo)  //RefreshAuditPanel(GetCurrentRetNo);
  else begin
    //LeftPanel.Visible := False;
    //MDIArrange;
    ShowLeftPanel(False);
  end;
end;

//------------- Tutorials -------------------

procedure Tvtnosplash.TUTORIALS1Click(Sender: TObject);
Var i:Integer;//Url:String;
  TempList,TempList1:TStringList; //it loads the helpkeyw in a list
    PrevNo:String;
begin
//production conforming
  Urls.Items.Clear;
{$IFDEF old}
  RetNo := GetCurrentRetNo;
  if RetNo > 0 then
    TutDir := RetList[RetNo].MyApp.AppDir
{$ELSE}
  if CurrentApp <> nil then
    TutDir := CurrentApp.AppDir
{$ENDIF}
  else
    TutDir := ExeDir;

  //LoadHelpCntInTreeView(AppDir+'\'+'T1Help.Cnt',TutHelpTreeView,HelpKeyW);
  //TutHelpTreeView.FullExpand;
  ShowTutorialsPanel(True);
  //TutorialsPanel.Width:=LeftPanel.Width;
  TempList:=TStringList.Create;
  TempList1:=TStringList.Create;
  GetFileList(TutDir+'\','T-*.htm',TempList);
  TempList.Sorted:=True;
  //TutorialListBox.Mask:='T-*.htm';
  If RetInMem =0 then
   TutorialsPanel.Height:=Screen.height * 2 div 3
  else
   ReduceTutorialHeight(Application);

  // insert dividers in between
  TempList1.Add(ExtractFileName(TempList[0]));
  PrevNo:=LeftStr(ExtractFileName(TempList[0]),4);  //i.e 'T-00';
  For i:=1 to TempList.Count-1 do
  begin
   If (LeftStr(ExtractFileName(TempList[i]),4) > PrevNo)
   and (RightStr(LeftStr(ExtractFileName(TempList[i]),4),1)='0') then
   begin
    PrevNo:=LeftStr(ExtractFileName(TempList[i]),4);
    TempList1.Add(' ');
   end;
   TempList1.Add(ExtractFileName(TempList[i]));
  end;
  TempList.Clear;
  TempList.Sorted:=False;
  For i:=0 to TempList1.Count-1 do TempList.Add(ChangeFileExt(TempList1[i],''));
  TempList1.Free;

  TutorialListBox.Items.Clear;
  For i:=0 to TempList.Count-1 do   //not from 0
    TutorialListBox.Items.Add(TempList[i]);

  TempList.Free;
  If TutorialListBox.Items.Count>0 then
  begin
    TutorialListBox.ItemIndex:=0;
    TutorialListBoxClick(Sender);
    TutHistoryIndex:=0;
  end;
end;

function Tvtnosplash.GetAppToolBarHeight: Integer; //20160225 Igor
begin
  if Assigned(AppToolBar) then
    Result := AppToolBar.Height
  else
    Result := 80;
end;

Function Tvtnosplash.GetTutorialFileName:String;
begin
 Result:='';
 If TutorialListBox.ItemIndex <0 then exit;
 If TutorialListBox.Items.Count = 0 then exit;
 If AllTrim(TutorialListBox.Items[TutorialListBox.ItemIndex])>'' then
    Result:=TutDir+'\'+TutorialListBox.Items[TutorialListBox.ItemIndex]+'.htm';
end;

procedure Tvtnosplash.GlobalMessageTimerTimer(Sender: TObject); //20190504 Igor
var
  Reg: TRegistry;
  FId, I, Options: integer;
  Msg: string;
begin
  GlobalMessageTimer.Enabled := false;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\VisualTax\',True);

    FId := 0;
    if Reg.ValueExists('CurrGlobalMessageId') then
      FId := Reg.ReadInteger('CurrGlobalMessageId');

    Reg.OpenKey('Messages\', True);
    for I := CurrGlobalMessageId + 1 to FId do
      if Reg.ValueExists('Message_'+ IntToStr(I))
         and
         Reg.ValueExists('Options_'+ IntToStr(I)) then
      begin
        Msg := Reg.ReadString('Message_'+ IntToStr(I));
        Options := Reg.ReadInteger('Options_'+ IntToStr(I));
        ShowGlobalMessage(Msg, Options);
      end;
    CurrGlobalMessageId := FId;
  finally
    Reg.CloseKey;
    GlobalMessageTimer.Enabled := true;
  end;
end;

procedure Tvtnosplash.ClearReview(AClearTabs: Boolean = True); //20170619 Igor
var
  C: Integer;
begin
  if Assigned(FPreviewForm) then
    for C := FPreviewForm.ControlCount - 1 downto 0 do
      if (FPreviewForm.Controls[C] is TvtScrollBox) then
      begin
        FloatingForms.Remove((FPreviewForm.Controls[C] as TvtScrollBox));
        FPreviewForm.Controls[C].Free;
      end;
  if AClearTabs then
    ReviewForms.Tabs.Clear;
end;

procedure Tvtnosplash.CloseTutorialBtnClick(Sender: TObject);
begin
 ShowTutorialsPanel(False);
end;


procedure Tvtnosplash.CloudLogTimerTimer(Sender: TObject); //20190523 Igor
begin
  inherited;
  if FCloudLogId = 0 then Exit;
  KeepAliveSession(FCloudLogId);
end;

procedure Tvtnosplash.NextTutorialBtnClick(Sender: TObject);
begin
//production conforming
 If TutorialListBox.ItemIndex < TutorialListBox.Items.Count then
 begin
   TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex+1;
   If AllTrim(TutorialListBox.Items[TutorialListBox.ItemIndex]) = '' then
     TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex+1;
   TutorialListBoxClick(Sender);
 end;
end;

procedure Tvtnosplash.PrevTutorialBtnClick(Sender: TObject);
begin
//production conforming
 If TutorialListBox.ItemIndex >0 then
 begin
   TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex-1;
   If AllTrim(TutorialListBox.Items[TutorialListBox.ItemIndex]) = '' then
     TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex-1;

   TutorialListBoxClick(Sender);
 end;

end;

procedure Tvtnosplash.ReduceTutorialHeight(Sender: TObject);
begin
 TutorialsPanel.Height:=Screen.Height div 3;
end;

procedure Tvtnosplash.lblLinkLastYearReturnClick(Sender: TObject); //20160701 Igor
var
  WorkRetNo: integer;
  RApp: String;
  RYear: Integer;
begin
  inherited;
  if not assigned(Application.MainForm) then exit;
  if not assigned(Application.MainForm.ActiveMDIChild) then exit;
  if not (Application.MainForm.ActiveMDIChild is TMyChild) then exit; //20161111 Igor

  WorkRetNo := GetCurrentRetNo;
  if WorkRetNo < 1 then exit;
  if not assigned(RetList[WorkRetNo]) then exit;
  if not assigned(RetList[WorkRetNo].MyApp) then exit;
  if not OpenDialog1.Execute then
    exit;
  if not GetReturnAppAndYear(ExtractFileDir(OpenDialog1.FileName),
           ExtractFileName(OpenDialog1.FileName), RApp, RYear,
           RetList[WorkRetNo].MyApp.SQLLitePassword.PassRFArray) then //20160714 Igor
  Begin
    ShowMessage('File "'+OpenDialog1.FileName+'" has bad format');//20160714 Igor
    exit;
  End;
  if not RetList[WorkRetNo].MyApp.isMyReturn(RApp) then //20160623 Igor
  Begin
    ShowMessage('Skip record. File "'+OpenDialog1.FileName+'" does not belong to the current program');
    exit;
  End;
  RetList[WorkRetNo].SetLastYearFile(OpenDialog1.FileName);
  FLastReturnComparison := 0;
  Comparison;
end;

procedure Tvtnosplash.lblLinkLastYearReturnMouseEnter(Sender: TObject); //20160701 Igor
begin
  (Sender as TLabel).Font.Style := [fsUnderline];
end;

procedure Tvtnosplash.lblLinkLastYearReturnMouseLeave(Sender: TObject); //20160701 Igor
begin
  inherited;
  (Sender as TLabel).Font.Style := [];
end;

procedure Tvtnosplash.Label4Click(Sender: TObject);
begin
//hidden AppId???
  TUTORIALS1Click(Sender);
end;

procedure Tvtnosplash.TutorialListBoxClick(Sender: TObject);
begin
//production conforming
 TutorialFile:=GetTutorialFileName;  //full path
 If TutorialFile='' then exit;
 TutorialScript:=ChangeFileExt(TutorialFile,'.EXE');
 If FileExists(TutorialScript) then
  DemonstrateTutorialBtn.Enabled := True
 else
  DemonstrateTutorialBtn.Enabled := False;

 Urls.Text:=TutorialFile;
 FindUrlAddress; //(TutorialFile);
end;

procedure Tvtnosplash.FindUrlAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  TutUpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure Tvtnosplash.WebBrowser1BeforeNavigate2(Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool);
var
  NewIndex: Integer;
begin
  NewIndex := TutHistoryList.IndexOf(URL);
  if NewIndex = -1 then
  begin
    { Remove entries in HistoryList between last address and current address }
    if (TutHistoryIndex >= 0) and (TutHistoryIndex < TutHistoryList.Count - 1) then
      while TutHistoryList.Count > TutHistoryIndex do
        TutHistoryList.Delete(TutHistoryIndex);
    TutHistoryIndex := TutHistoryList.Add(URL);
  end
  else
    TutHistoryIndex := NewIndex;
  if TutUpdateCombo then
  begin
    TutUpdateCombo := False;
    NewIndex := URLs.Items.IndexOf(URL);
    if NewIndex = -1 then
      URLs.Items.Insert(0, URL)
    else
      URLs.Items.Move(NewIndex, 0);
  end;
  URLs.Text := URL;
end;

procedure Tvtnosplash.WndProc(var Message: TMessage); //20190401 Igor
begin
//20190925 Igor >>>
//  if Message.Msg = WM_WININICHANGE then
//    ShowWaitForm := true;
//20190925 Igor <<<
  inherited WndProc(Message);
end;

procedure Tvtnosplash.DemonstrateTutorialBtnClick(Sender: TObject);
Var h : THandle;
begin
//production conforming
 If FileExists(TutorialScript) then
 Begin
  h := ShellExecute(Handle, Nil, PChar(''+TutorialScript), Nil, Nil, SW_RESTORE);
   If h<32 then
     ShowMessage('File not found');
  ReduceTutorialHeight(Sender);
 end;
end;

procedure Tvtnosplash.TutorialZoomInBtnClick(Sender: TObject);
begin
//production conforming
 TutorialsPanel.Height:=TutorialsPanel.Height+150;
end;

procedure Tvtnosplash.TutorialZoomOutBtnClick(Sender: TObject);
begin
//production conforming
 If TutorialsPanel.Height <= 70 then exit;
 If TutorialsPanel.Height < 200 then
   TutorialsPanel.Height:=70
 else
  TutorialsPanel.Height:=TutorialsPanel.Height-150;
end;

procedure Tvtnosplash.SaveOptions;
begin
//20170914 Igor>>>
  if LeftPanel.Visible then
    MainOptions.LeftPanelWidth := LeftPanel.Width;
  if ReviewPanel.ActivePage <> tabHide then
    MainOptions.RightPanelWidth := ReviewPanel.Width; //.Width;
  MainOptions.FormPanelHeight := FormsPanel.Height; //20160225 Igor
  inherited;
//20170914 Igor<<<
end;

Procedure Tvtnosplash.CheckLicenses;
begin
(* called after license update
*)
  SelectFeatures;
end;

Procedure Tvtnosplash.SelectFeatures;
var
  MyApp: TApp;
Begin
(* To be called when AppId or License changed
  a) [update splashs after license change (about dialog) - global]
  b) update Super options after AppChanged
*)
  MyApp := CurrentApp;
  assert(MyApp<>nil, 'handle closed return');
  MyApp.SelectFeatures;
//super features /optimize
  SuperAuditBox.Enabled := lcSuperAudit in CurApp.LicenseCaps;
  SuperVerificationBtn.Enabled := lcSuperAudit in CurApp.LicenseCaps;
end;

procedure Tvtnosplash.RefreshFormsPanel(RetNo: Integer);
begin
(*  get either all or used forms, depending on RetNo(?)
*)
  //if (FormsPanel.Visible = True) then
  RetList[RetNo].GetFrmTree(FormsTreeView1, UsedFormsBox.Checked);
  Exclude(UpdateRequests,urForms);
end;

procedure Tvtnosplash.CollapseClick(Sender: TObject);
begin
(* Forms TreeView collapse
*)
//production conforming
  FormsTreeView1.FullCollapse;
end;

procedure Tvtnosplash.ExpandBtnClick(Sender: TObject);
begin
//production conforming
 FormsTreeView1.FullExpand;
 FormsTreeView1.TopItem:=FormsTreeView1.Items[0];
end;

procedure Tvtnosplash.PrintAuditBtnClick(Sender: TObject);
begin
//production conforming
//T1 specific!?
  if ButtonInactive then exit;
 If PrintDialogItem.Execute then
 begin
  CalcName(RetNo,'DIAGNO');
  RetList[RetNo].StartPrintForm('DIAGNO',1);
 end;
end;

procedure Tvtnosplash.rbZoomAllClick(Sender: TObject); //20160209 Igor
var
  I: Integer;
begin
  inherited;
  if rbZoomAll.Checked then
  Begin
    MainOptions.ZoomForm := zfAll;
  End
  else
  if rbZoomCenter.Checked then
  Begin
    MainOptions.ZoomForm := zfCenter;
  End
  else
  if rbZoomRight.Checked then
  Begin
    MainOptions.ZoomForm := zfRight;
  End;
end;

procedure Tvtnosplash.UsedFormsBoxClick(Sender: TObject);
begin
//production conforming
  If ButtonInactive then exit;
  RefreshFormsPanel(RetNo);
end;

destructor Tvtnosplash.Destroy;
begin
  TutHistoryList.Free;
  //20170914 Igor>>>
  if Assigned(FResizeFormTimer) then
    FreeAndNil(FResizeFormTimer);
  //20170914 Igor<<<
  inherited;
end;

procedure Tvtnosplash.AuditPanelSplitterCanResize(Sender: TObject; //20160305 Igor
  var NewSize: Integer; var Accept: Boolean);
begin
  inherited;
  AuditPanelSplitter.Tag := AuditPanelSplitter.Left;
end;

procedure Tvtnosplash.AuditPanelSplitterMoved(Sender: TObject);
var
  Delta, OldSpliterPosition, NewSpliterPosition: Integer;
  NewReviewPanelWidth: Integer;
begin
(* Scale forms down if necessary
*)
  if (asLoadReturn in ApplicationState) or //20160615 Igor
     (asOpenForm in ApplicationState) then
    exit;

  //20160305 Igor >>>>>
  if LeftPanel.width > 0 then //20160522 Igor
  Begin
    if ReviewPanel.ActivePage <> tabHide then
    Begin
      OldSpliterPosition := AuditPanelSplitter.Tag;
      NewSpliterPosition := AuditPanelSplitter.Left;
      if NewSpliterPosition <= AuditPanelSplitter.MinSize then
        NewSpliterPosition := 0;

      Delta := NewSpliterPosition - OldSpliterPosition;
      if Delta = 0 then exit;

      NewReviewPanelWidth := ReviewPanel.Width - Delta;
      if NewReviewPanelWidth > ReviewPanelSplitter.MinSize then
      Begin
        ReviewPanel.SetBounds(ReviewPanel.Left + Delta,
                              ReviewPanel.Top,
                              NewReviewPanelWidth,
                              ReviewPanel.Height);
        //ReviewPanelSplitter.Left := ReviewPanel.Left - ReviewPanelSplitter.Width - 1;
      End
      else
      Begin
        SetActiveTab(tabHide);//20171228 Igor
        ReviewPanelChange(ReviewPanel);
      End;
    //20170811 Igor>>>
      AuditPanelSplitter.Tag := NewSpliterPosition;
    End;
    //20170811 Igor<<<
  End;
  //20160305 Igor <<<<<
  MDIArrange; //- doesn't help when tax form wider than remaining client size
  //20170914 Igor>>>
  if (ReviewPanel.ActivePage = tabLastYear) and buttonZoom50_50.Down then
    buttonZoom50_50Click(buttonZoom50_50);
  //20170914 Igor<<<
end;

procedure Tvtnosplash.SuperAuditBoxClick(Sender: TObject);
begin
  vtMain.SuperAuditSw := (SuperAuditBox.Checked) and (SuperAuditBox.Enabled);
  RefreshAuditPanel(GetCurrentRetNo); //20170208 Igor
end;

procedure Tvtnosplash.actHideAuditExecute(Sender: TObject); //20160426 Igor
begin
  inherited;
  ActLeftPanelSettingExecute(actViewAudit);
end;

procedure Tvtnosplash.actHideFormsExecute(Sender: TObject); //20160426 Igor
begin
  inherited;
  ActLeftPanelSettingExecute(actViewForms);
end;

procedure Tvtnosplash.actHideReturnsListExecute(Sender: TObject); //20160426 Igor
begin
  inherited;
  ActLeftPanelSettingExecute(actViewReturnsList);
end;

procedure Tvtnosplash.ActLeftPanelSettingExecute(Sender: TObject); //20160426 Igor
begin
  inherited;
  (Sender as TAction).Checked := not (Sender as TAction).Checked;
  if not (actViewReturnsList.Checked or actViewAudit.Checked or actViewForms.Checked) then
    (Sender as TAction).Checked := true
  else
    SetLeftPanelPartVisible;
end;

function Tvtnosplash.SetActiveTab(ATab: TTabSheet): Boolean;//20171228 Igor
var
  I: Integer;
begin
  if ATab.TabVisible then
    ReviewPanel.ActivePage := ATab
  else
  begin
    for I := 0 to ReviewPanel.PageCount - 1 do
      if ReviewPanel.Pages[I].TabVisible then
      begin
        ReviewPanel.ActivePage := ReviewPanel.Pages[I];
      end;
  end;
  Result := ReviewPanel.ActivePage = ATab;
end;

function Tvtnosplash.SetActiveTab(ATabIndex: Integer): Boolean;//20171228 Igor
begin
  if (ATabIndex >= 0) and (ATabIndex < ReviewPanel.PageCount) then
    SetActiveTab(ReviewPanel.Pages[ATabIndex])
  else
    SetActiveTab(tabHide);
end;

procedure Tvtnosplash.SetLeftPanelPartVisible; //20160426 Igor
Begin
  MainOptions.ReturnsPanelVisible := true; //actViewReturnsList.Checked;
  MainOptions.AuditPanelVisible := actViewAudit.Checked;
  MainOptions.FormsPanelVisible := actViewForms.Checked;

  ReturnsPanel.Visible := true; //actViewReturnsList.Checked; 20160529 Igor
  WizardPanel.Visible := actViewAudit.Checked;
  FormsPanel.Visible := actViewForms.Checked;

  WizardPanelSplitter.Visible := (actViewReturnsList.Checked and (actViewAudit.Checked or actViewForms.Checked));
  FormsPanelSplitter.Visible := (actViewForms.Checked and actViewAudit.Checked);

  if ReturnsPanel.Visible AND
     not (WizardPanel.Visible or FormsPanel.Visible) then
  Begin
    if ReturnsPanel.Align <> alClient then
    Begin
      ReturnsPanel.Tag := ReturnsPanel.Height;
      ReturnsPanel.Align := alClient;
    End;
  End
  else
  begin
    if ReturnsPanel.Align = alClient then
    Begin
      ReturnsPanel.Align := alTop;
      ReturnsPanel.Height := ReturnsPanel.Tag;
    End;
  end;

  if FormsPanel.Visible AND not WizardPanel.Visible then
  Begin
    if FormsPanel.Align <> alClient then
    Begin
      FormsPanel.Tag := FormsPanel.Height;
      FormsPanel.Align := alClient;
    End;
  End
  else
  Begin
    if FormsPanel.Align = alClient then
    begin
      FormsPanel.Align := alBottom;
      FormsPanel.Height := FormsPanel.Tag;
      if WizardPanel.Height < WizardHeaderPanel.Height then
      FormsPanel.Height := FormsPanel.Height - WizardHeaderPanel.Height*2;
    end;
  End;
  if WizardPanelSplitter.Visible then
    WizardPanelSplitter.Top := ReturnsPanel.Top + ReturnsPanel.Height+1;
  if FormsPanelSplitter.Visible then
    FormsPanelSplitter.Top := FormsPanel.Top - 1;
End;

procedure Tvtnosplash.btnSendGlobalMessageClick(Sender: TObject); //20190504 Igor
begin
  inherited;
  SendGlobalMessage;
end;

procedure Tvtnosplash.buSignOffWarningsClick(Sender: TObject);
begin
  if ButtonInactive then exit;
  SignOffAWarning(RetNo); //sign off all
end;

procedure Tvtnosplash.buttonZoom50_50Click(Sender: TObject); //20160316 Igor
begin
  if (asLoadReturn in ApplicationState) or //20160615 Igor
     (asOpenForm in ApplicationState) then
    exit;

  if buttonZoom50_50.Down then
  Begin
    buttonZoom50_50.Hint := 'Zoom 50 / 50: ON';
    if LeftPanel.Visible then
      ReviewPanel.Width := (ClientWidth - LeftPanel.Width) div 2
    else
      ReviewPanel.Width := ClientWidth div 2;
    ReviewPanelSplitter.Left := ReviewPanel.Left - 1;
    ReviewPanelSplitterMoved(ReviewPanelSplitter);
  End
  else
    buttonZoom50_50.Hint := 'Zoom 50 / 50: OFF';
end;

procedure Tvtnosplash.buttonAvailableWidthClick(Sender: TObject); //20160301 Igor
begin
  inherited;
  ReviewPanelSplitter.Tag := 0; //20160627 Igor
  ReviewPanelSplitterMoved(ReviewPanelSplitter);
end;

procedure Tvtnosplash.buttonSynchronousDisplayClick(Sender: TObject);
begin
  inherited;
  if buttonSynchronousDisplay.Down then
    buttonSynchronousDisplay.Hint := 'Synchronous display: ON'
  else
    buttonSynchronousDisplay.Hint := 'Synchronous display: OFF';
end;

procedure Tvtnosplash.ButtonZoomPlusClick(Sender: TObject);
begin
  inherited;
  if ((tbZoom.position + (Sender as TSpeedButton).tag) >= tbZoom.Min) AND
     ((tbZoom.position + (Sender as TSpeedButton).tag) <= tbZoom.Max) then
    tbZoom.position := tbZoom.position + (Sender as TSpeedButton).tag;
end;

procedure Tvtnosplash.OnIdle(Sender: TObject; var Done: Boolean);
var
  RNo: integer;
  MyRet: RetPtr;
const
  dbg = False; //turn debug messages on/off
begin
//  ShowWaitForm := false;; //20190401 Igor //20190925 Igor
  if assigned(CurrentApp) then
    CurrentApp.AppOnIddle;//20161213 Igor
  (* Must perform some initializations AFTER FormCreate
  *)
  if dbg then StatusBar1.SimpleText := 'Exit Idle 1';
  Done := True;
  //Done := False;
  if Application.MainForm = nil then
  begin
    if dbg then StatusBar1.SimpleText := 'MainForm=NIL???';
    exit; //in FormCreate
  end;

  if dbg then StatusBar1.SimpleText := 'Exit Idle 2';

  if (screen.ActiveForm <> nil)
     and
     (fsModal in Screen.ActiveForm.FormState) then
    exit; //modal form shown?
  //problem: exit when Splash is shown???

  if dbg then StatusBar1.SimpleText := 'Exit Idle 3';
  //20170825 Igor>>>
  if Not Logoned then
  //if FormStyle <> fsMDIForm then
  //20170825 Igor<<<
  begin
    //program startup only
    if not Logon then
      Close;
    //20170825 Igor>>>
    Logoned := True;
    //FormStyle := fsMDIForm;
    //20170825 Igor<<<

    if not assigned(FDummyForm) then                //20161111 Igor
      FDummyForm := TfrmDummyMDIChild.Create(Self); //20161111 Igor


    //LoadHelperPlugins; //20161118 Igor //20161209 Igor

    if AppList.LicensedApps > 0 then begin
      //AppList.InitGUI(Self); //now MainForm is available, map all handlers
      //CurApp.Activate;
      AppList.InitApps;
    end else begin
      ShowMessage('No AppId installed - exiting program');
      Application.Terminate;
    end;
    CalcWatch := TCalcWatch.Create(Application);
    InStartup := False; //now show all messages
    if not MessageShowing then
      ShowSplash;
    if Assigned(CurrentApp) then//20170811 Igor
      CurrentApp.SelectFeatures; //20170112 Igor
    exit;
  end;

  if dbg then StatusBar1.SimpleText := 'Exit Idle 4';

  if MessageShowing then
    exit;

  //20170824 Igor>>>
  if urUpdateSkin in UpdateRequests then
    DockGUI;
  //20170824 Igor<<<

  //remaining only after FormCreate finished
  //Done := False; //unless painting ------- ???

  //problem with closing returns
  RNo := GetCurrentRetNo;
  if dbg then StatusBar1.SimpleText := Format('RetNo=%d, ChildCount=%d', [RNo, TMyChild.ChildCount]); //20170606 Igor
  (* RetNo=0 even if ChildCount > 0???
  *)
  if (RNo > 0)
  //and (MDIChildCount>0) //have returns without a ChildWin?
  //and (RetList.Count > 1) //dummy at [0]!
  //and (RetInMem > 0)
  and (TMyChild.ChildCount > 0) //20170606 igor
  then begin
  (*
  gcFormPaint:  include(UpdateRequests,urAll);  // FormPaint_;
  gcRefreshAuditPanel: include(UpdateRequests,urErrors);  // RefreshAuditPanel(RetNo); //RetNo?
  gcRefreshFormsPanel: include(UpdateRequests,urForms); // RefreshFormsPanel(RetNo);
  gcRetNoChanged: include(UpdateRequests,urAll);  // ChangeRetNo(GetCurrentRetNo);
  gcColorChanged: include(UpdateRequests,urRetColor); // UpdateColor(GetCurrentRetNo);
  *)
    //if (RNo <> RetNo)
    if (RetList[RNo] <> RetList[RetNo]) //RetList changed? (close&open return!)
    or (urRetNo in UpdateRequests) //problem after closing return!?
    then
      ChangeRetNo(RNo); //does it all!?
    if urAll In UpdateRequests then
      FormPaint_; //RetNo := 0; //force ChangeRetNo
    if (DrawingRetInMem <> ReturnsListBox.Items.Count)
    or (urReturns In UpdateRequests) then begin
      UpdateReturns;
      BringToFront;
    end;
    if urErrors In UpdateRequests then
      RefreshAuditPanel(RetNo);
    if urForms In UpdateRequests then
      RefreshFormsPanel(RetNo);
    if urRetColor In UpdateRequests then
      UpdateColor(RetNo);
    //Done := MDIChildCount > 0;  // True; //really here?
  end else begin
  //no returns shown
    ShowLeftPanel(False);
    UpdateAdoptedPages(nil, 0);//20170727 Igor
    UpdatePanelClientDocuments(0);//20170714 Igor
    UpdatePanelAutoFill(0); //20170729 Igor
    //20170927 Igor>>>
    SetActiveTab(tabHide);//20171228 Igor
    ReviewPanelChange(ReviewPanel);
    //20170927 Igor<<<
    RebuildReviewForm; //20170518 Igor
  //clear all return related lists
    ReturnsListBox.Clear;
    AuditList.Items.Clear;
    FormsTreeView1.Items.Clear;

    if TutorialsPanel.Visible then
      BringToFront
    else
    begin
      //20170429 Igor >>>
      if not(
               assigned(Screen.ActiveForm)
               and
               (
                 (Screen.ActiveForm.FormStyle = fsStayOnTop)
                 or
                 (
                   assigned(Screen.ActiveForm.ActiveControl)
                   and
                   (Screen.ActiveForm.ActiveControl is TCombobox)
                   and
                   TCombobox(Screen.ActiveForm.ActiveControl).DroppedDown
                 )
               )
             )
         and
         (ActiveControl <> mmoLog)
         and
         (FAdoptedForm = 0)//20170112 Igor
         //20170907 Igor>>>
         and
         (MainOptions.Skin <> skRibbon)
         //20170927 Igor>>>
         and
         not StartParams.isCloud then
         //20170927 Igor<<<
         //20170907 Igor<<<
      //20170429 Igor <<<
        ShowSplash;
    end;
    UpdateRequests := []; //all done
    //Done := True;
  end;

  //causes flicker!
  if CurrentApp <> CurApp then begin
    CurApp := CurrentApp;
    Caption := 'Visual Tax ' + CurApp.AppId; //?AppTitle = ''?
  end;

  //LockWindowUpdate(0); //forces ChildWin repaint!
  if WindowLocks > 0 then begin
    WindowLocks := 0;
    Windows.LockWindowUpdate(0);
  end;

  if DrawingRetInMem <> ReturnsListBox.Items.Count then
    Include(UpdateRequests, urReturns);  //not reached?
  //20170518 Igor >>>
  if urShowAllControls in UpdateRequests then
  begin
    vtChild.CreateNewMDIChild(GetCurrentRetNo, '').ShowAllControls(False);
    //20170914 Igor>>>
    UpdateReviewData;
    //20170914 Igor<<<
    Exclude(UpdateRequests, urShowAllControls);  //not reached?
  end;
  //20170518 Igor <<<
  //20170719 Igor>>>
  if urViewSideBySide in UpdateRequests then
  begin
    Exclude(UpdateRequests, urViewSideBySide);
    tsViewSideBySide.TabVisible := True;
    ReviewPanel.ActivePage := tsViewSideBySide;
    //20170914 Igor>>>
    UpdateReviewData;
    //20170914 Igor<<<
  end;
  //20170719 Igor<<<
  Done := UpdateRequests = [];
  if Done then
    Busy(False);

end;

// ------ Right hand panel ------

procedure Tvtnosplash.ReviewPanelChange(Sender: TObject);
begin
//20170914 Igor>>>
  if (asLoadReturn in ApplicationState) or
     (asOpenForm in ApplicationState) then
    exit;

  if (ReviewPanel.ActivePageIndex < 0) or
     (Assigned(ReviewPanel.ActivePage) and
      not ReviewPanel.ActivePage.TabVisible and
      (ReviewPanel.ActivePage <> tabHide)) then
      SetActiveTab(tabHide);//20171228 Igor

  if (ReviewPanel.ActivePage = tabHide) then
  begin
    if (MainOptions.RightPanelActivePageIndex <> tabHide.PageIndex) and
       (GetCurrentRetNo <> 0) and
        Self.Visible then
      MainOptions.RightPanelWidth := ReviewPanel.Width;
    if ReviewPanel.Width <> (ReviewPanel.Width - ReviewPanel.ActivePage.Width) then
      ReviewPanel.Width := ReviewPanel.Width - ReviewPanel.ActivePage.Width;

    if (GetCurrentRetNo <> 0) and Self.Visible then //20251229 Igor
      MainForm.GuiCommand(gcAvailableWidth); //20251229 Igor
  end
  else
  if (ReviewPanel.ActivePage <> tabHide) then
  begin
    if ReviewPanel.ActivePage.Width = 0 then
    begin
      ReviewPanel.Width := MainOptions.RightPanelWidth;
      ReviewPanelSplitter.Left := ReviewPanel.Left - ReviewPanelSplitter.Width;
    end;
    UpdateReviewData;
  end;
  if (GetCurrentRetNo <> 0) and
     Self.Visible then
    MainOptions.RightPanelActivePageIndex := ReviewPanel.ActivePageIndex;
  //20170914 Igor<<<
end;

function TvtNoSplash.Comparison: Boolean; //20160302 Igor
var
  AChild: TMyChild;
  P,P1 : TPoint;
  WorkRetNo, LastYearFormNo, LastYearRetNo: Integer;
  WorkFormName, WorkFileName, LastYearFormName, LYDFM, CheckMessage,
  WorkFileDir: String; //20160701 Igor
  I, instNo: Integer; //20160321 Igor
  F: TvtForm;
  PrevCouplingSw: Boolean;
Begin
  if (asLoadReturn in ApplicationState) or
     (asOpenForm in ApplicationState) then
    Exit(false);
  if (FStartCompilation) then exit; //20160321 Igor
  FStartCompilation := True;  //20160321 Igor
  try
    result := False;
    if reviewPanel.ActivePage <> tabLastYear then exit;
    if FCloseReturnState then exit;


    if not assigned(Application.MainForm) then exit;
    if not assigned(Application.MainForm.ActiveMDIChild) then exit;
    if not (Application.MainForm.ActiveMDIChild is TMyChild) then exit; //20161111 Igor

    WorkRetNo := GetCurrentRetNo;
    if WorkRetNo < 1 then exit;

    if not assigned(RetList[WorkRetNo]) then exit;
    if not assigned(RetList[WorkRetNo].MyApp) then exit;

    AChild := (Application.MainForm.ActiveMDIChild as TMyChild);
    if not assigned(AChild) then exit;
    if ((AChild.FormName = '') or (AChild.FormName = FLastFormComparison)) AND
       (WorkRetNo = FLastReturnComparison) then exit;
    if assigned(AChild) then
    Begin
      //20161129 Igor >>>
      if assigned(FLastYearForm) then
        for I := FLastYearForm.ControlCount - 1 downto 0 do
          if FLastYearForm.Controls[I] is TvtScrollBox then
          Begin
            if WorkRetNo = TvtScrollBox(FLastYearForm.Controls[I]).RetNo then exit;

            if (TvtScrollBox(FLastYearForm.Controls[I]).FormName = RetList[WorkRetNo].MyChild.ActiveForm.FormName) AND
               (TvtScrollBox(FLastYearForm.Controls[I]).RetNo = RetList[WorkRetNo].LastYearRetNo) then
              exit
            else
              FloatingForms.Remove((FLastYearForm.Controls[I] as TvtScrollBox)); //20160312 Igor
              FLastYearForm.Controls[I].Free;
          End;
      //20161129 Igor <<<
    End;
    LastYearHeaderCaption.Caption := 'LAST YEAR';
    LastYearHeaderError.Visible := false; //20160516 Igor
    lblLinkLastYearReturn.visible := False; //20160701 igor

    If RetList[WorkRetNo].IsLastYearReturn then Exit;

    If not RetList[WorkRetNo].MyApp.CheckLastYearPgmFolder(CheckMessage) then
    Begin
      LastYearHeaderError.Visible := True; //20160516 Igor
      LastYearHeaderError.Caption := CheckMessage;//20160516 Igor
      Exit;
    End;
    if not RetList[WorkRetNo].MyApp.CheckLastYearDataFolder(CheckMessage) then
    begin
      LastYearHeaderError.Visible := True; //20160516 Igor
      LastYearHeaderError.Caption := CheckMessage;//20160516 Igor
      exit;
    end;
    if not RetList[WorkRetNo].MyApp.InitLastYear then
    begin
      LastYearHeaderError.Visible := True; //20160516 Igor
      LastYearHeaderError.Caption := 'Last Year not init';//20160516 Igor
      Exit;
    end;
    FLastReturnComparison := WorkRetNo;
    FLastFormComparison := AChild.FormName;
    WorkFormName := AChild.FormName;

    If RetList[WorkRetNo].LastYearRetNo > 0 then
    Begin

      RetNo := RetList[WorkRetNo].LastYearRetNo;
      RetList[WorkRetNo].MyChild.ActiveForm.LYRetNo := RetList[WorkRetNo].LastYearRetNo; //20160316 Igor

      With RetList[WorkRetNo].MyApp do
      Begin
        LastYearFormName := GetSubstituteLastYearForm(WorkFormName); //20160316 Igor
        LastYearFormNo := GetLastYearFormNo(LastYearFormName); //20160316 Igor //20160321 Igor
        //20160321 Igor >>>>
        if (LastYearFormNo = 0) AND
           IsFormMultiInst(LastYearFormName) then
        Begin
          instNo := ExtractFormInstNo(LastYearFormName);
          LastYearFormNo := RetList[RetList[WorkRetNo].LastYearRetNo].AddPageInstance(ExtractNonInstFormName(LastYearFormName),
            '#' + IntToStr(instNo));
        End;
      End;
      If LastYearFormNo=0 then
      begin
        LastYearHeaderError.Caption := 'Form "' + LastYearFormName + '" not found in last year';     //20160314 Igor //20160516 Igor //20160710 Igor
        LastYearHeaderError.Visible := True; //20160516 Igor
        Exit;
      end;

      RetList[WorkRetNo].MyChild.ActiveForm.LYFormNo := LastYearFormNo;
      RetList[WorkRetNo].MyChild.ActiveForm.LYFormName := LastYearFormName;

      LYDFM := RetList[RetList[WorkRetNo].LastYearRetNo].GetDfmFileName(LastYearFormName);
      if not FileExists(LYDFM) then
      Begin
        LastYearHeaderError.Caption := 'File "' + LYDFM + '" not found in Last year program''s directory';     //20160314 Igor //20160516 Igor //20160710 Igor
        LastYearHeaderError.Visible := True;
        exit;
      End;

      try
        //20161129 Igor >>>
        SetupSubForm(FLastYearForm, tabLastyear);
        F := OpenTaxForm(RetList[WorkRetNo].LastYearRetNo,LastYearFormName,fsNormal,FLastYearForm);
        //20161129 Igor <<<
      except
        exit;//20170811 Igor
      end;
      if not assigned(F) then exit;

      GetCurrentRetNo := WorkRetNo;
      RetNo := WorkRetNo;
      RetList[WorkRetNo].MyChild.BringToFront; // SetFocus;
      RetList[WorkRetNo].MyChild.ActiveForm.Activated(false);
      //20160314 Igor
      if assigned(AChild) then
        LastYearHeaderCaption.Color := AChild.HeaderFrame.Color
      else
        LastYearHeaderCaption.Color := $00AC7400;
      LastYearHeaderCaption.Caption := 'LAST YEAR – '+
                                 RetList[RetList[WorkRetNo].LastYearRetNo].GetLastName + ' ' +
                                 RetList[RetList[WorkRetNo].LastYearRetNo].GetFirstName + ' ' +
                                 F.FormName;

    End
    Else
    Begin
      WorkFileName := RetList[WorkRetNo].GetLastYearFile;
      if (WorkFileName <> '') and (FileExists(WorkFileName)) then
      begin
        WorkFileDir := ExtractFileDir(WorkFileName); //20160701 Igor
        WorkFileName := ExtractFileName(WorkFileName); //20160703 Igor
        LastYearRetNo := RetList[WorkRetNo].MyApp.OpenReturn(WorkFileDir,
                                                             WorkFileName,False,true);
        lblLinkLastYearReturn.visible := true; //20160701 igor
      end
      else
      begin
        WorkFileName := RetList[WorkRetNo].MyApp.ConvertToLastYearName(RetList[WorkRetNo].GetDefaultFileName);
        //20160608 Igor >>>
        If FileExists(RetList[WorkRetNo].MyApp.LastYearDataFolder+'\'+WorkFileName) then
        begin
          LastYearRetNo := RetList[WorkRetNo].MyApp.OpenReturn(RetList[WorkRetNo].MyApp.LastYearDataFolder,
                                                               WorkFileName,False,true);
          WorkFileDir := RetList[WorkRetNo].MyApp.LastYearDataFolder;//20160701 Igor
        end
        else
        if (WorkFileName <> RetList[WorkRetNo].SourceFlName) AND
           FileExists(RetList[WorkRetNo].MyApp.Dir_Cur+'\'+WorkFileName) then
        begin
          LastYearRetNo := RetList[WorkRetNo].MyApp.OpenReturn(RetList[WorkRetNo].MyApp.Dir_Cur,
                                                               WorkFileName,False,true);
          WorkFileDir := RetList[WorkRetNo].MyApp.Dir_Cur; //20160701 Igor
        end
        else
        begin
          LastYearHeaderError.Caption := 'File '+WorkFileName+ ' not found in last year'; //20160516 Igor
          LastYearHeaderError.Visible := True; //20160516 Igor
          lblLinkLastYearReturn.visible := true; //20160701 igor
          Exit;
        end;
      end;
      //20160608 Igor <<<
      RetList[LastYearRetNo].RestoreRetColor(clWhite); //20160314 Igor
      GetCurrentRetNo := WorkRetNo; //20160316 Igor
      RetNo := WorkRetNo;
      If LastYearRetNo > 0 then
      begin
        RetList[WorkRetNo].LastYearRetNo := LastYearRetNo;
        RetList[WorkRetNo].MyChild.ActiveForm.LYRetNo := LastYearRetNo; //20160316 Igor
        With RetList[WorkRetNo].MyApp do
        Begin
          LastYearFormName := GetSubstituteLastYearForm(WorkFormName); //20160316 Igor
          LastYearFormNo := GetLastYearFormNo(LastYearFormName); //20160316 Igor //20160321 Igor
          //20160321 Igor >>>>
          if (LastYearFormNo = 0) AND
             IsFormMultiInst(LastYearFormName) then
          Begin
            instNo := ExtractFormInstNo(LastYearFormName);
            LastYearFormNo := RetList[RetList[WorkRetNo].LastYearRetNo].AddPageInstance(ExtractNonInstFormName(LastYearFormName),
              '#' + IntToStr(instNo));
          End;
        End;
        If LastYearFormNo=0 then
        begin
          LastYearHeaderError.Caption := 'Form "' + LastYearFormName + '" not found in last year';     //20160314 Igor //20160516 Igor //20160710 Igor
          LastYearHeaderError.Visible := True; //20160516 Igor
          Exit;
        end;

        LYDFM := RetList[LastYearRetNo].GetDfmFileName(LastYearFormName);
        if not FileExists(LYDFM) then
        Begin
          LastYearHeaderError.Caption := 'File "' + LYDFM + '" not found in Last year program''s directory';     //20160314 Igor //20160516 Igor //20160710 Igor
          LastYearHeaderError.Visible := True; //20160516 Igor
          exit;
        End;
        try
          //20161129 Igor >>>
          SetupSubForm(FLastYearForm, tabLastyear);
          F := OpenTaxForm(LastYearRetNo,LastYearFormName,fsNormal,FLastYearForm);
          //20161129 Igor
        except
          exit;
        end;
        if not assigned(F) then exit;

        (F as TvtScrollBox).ShowFormData; //20160314 Igor
        GetCurrentRetNo := WorkRetNo;
        RetList[WorkRetNo].MyChild.ActiveForm.LYFormNo := LastYearFormNo;  //20160424 Igor
        RetList[WorkRetNo].MyChild.ActiveForm.LYFormName := LastYearFormName; //20160424 Igor

        RetList[WorkRetNo].MyChild.BringToFront; // SetFocus;
        RetList[WorkRetNo].MyChild.ActiveForm.Activated(false);
        LastYearHeaderCaption.Caption := 'LAST YEAR – '+
                                       RetList[LastYearRetNo].GetLastName + ' ' +
                                       RetList[LastYearRetNo].GetFirstName + ' ' +
                                       F.FormName;

        if assigned(AChild) AND (Self.Visible){ AND (AChild.WindowState = wsMaximized)} then
        Begin
          if assigned(AChild.HeaderFrame) then
          Begin
          //20160322 Igor
//            P := AChild.HeaderFrame.Parent.ClientToScreen(Point(0,AChild.HeaderFrame.Top+AChild.HeaderFrame.Height));
//            P1:= LastYearHeaderCaption.Parent.ClientToScreen(Point(0,LastYearHeaderCaption.Top));
//            LastYearHeaderCaption.Height := min(P.Y - P1.Y,AChild.HeaderFrame.Height);
            LastYearHeaderCaption.Color := AChild.HeaderFrame.Color;
          End;
          if assigned(AChild.MonitorFrame) then
          Begin
            LastYearBottomPanel.Height := AChild.MonitorFrame.Height;
          End;
        end;
      end
      else
        ShowOpenReturnFailure(LastYearRetNo,WorkFileDir,WorkFileName); //20160701 Igor
      if FormsTreeView1.Items.Count = 0 then
        MainForm.GuiCommand(gcRefreshFormsPanel);

    End;
    buttonAvailableWidthClick(buttonAvailableWidth); //20160720 Igor
  finally
    //buttonAvailableWidthClick(buttonAvailableWidth); //20160703 Igor //20160720 Igor
    FStartCompilation := False; //20160321 Igor
  end;
End;

procedure Tvtnosplash.ReviewPanelSplitterCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean); //20160312 Igor
begin
  inherited;
  buttonZoom50_50.Tag := -1;
  try
    if ReviewPanel.ActivePage = tabHide then
      Accept := False
    else
    //20160316 Igor
    if (ReviewPanel.ActivePage = tabLastYear) AND
       (buttonZoom50_50.Down) then
    begin
      //20160611 Igor >>>
      if MessageDlg('Current and Last year presentation of available space is 50-50.'+#13+
                    'You could click the Last Year Zoom icon to allow resizing.'+#13+
                    'Do you want to resize it now?',mtConfirmation,[mbYes, mbNo],0) = mrYes then
      Begin
        buttonZoom50_50.Down := False;
        Accept := True;
      End
      else
      //20160611 Igor <<<
        Accept := False;
    end;
  finally
    buttonZoom50_50.Tag := 0;
  end;
end;

procedure Tvtnosplash.ReviewPanelSplitterMoved(Sender: TObject);
//20170914 Igor>>>
var
  CenterW,RightW, CurrentZoom, CurrentRightZoom,
  NewZoom, NewRightZoom: Integer;
  I: Integer;
  AChild: TMyChild;
  scrlbox: TvtScrollBox;
  W: integer;
  F: TvtScrollBox;
begin
  if (RetNo = 0) or
     Application.Terminated or
     (asLoadReturn in ApplicationState) or
     (asOpenForm in ApplicationState) or
     (ReviewPanelSplitter.Tag = ReviewPanelSplitter.Left) or
     not assigned(ActiveMDIChild) or
     not (ActiveMDIChild is TMyChild) then
    exit;
  if (buttonZoom50_50.tag = -1) and (buttonZoom50_50.Down) then
    exit;
  ReviewPanelSplitter.Tag := ReviewPanelSplitter.Left;
  if LeftPanel.Visible then
    CenterW := ReviewPanelSplitter.Left - (AuditPanelSplitter.Left + AuditPanelSplitter.Width)
  else
    CenterW := ReviewPanelSplitter.Left - (pgc.Left + pgc.Width);
  if not Assigned(ReviewPanel.ActivePage) or (ReviewPanel.ActivePage = tabHide) then
    RightW := 0
  else
    RightW := ReviewPanel.ActivePage.Width;
  CurrentZoom := MainOptions.FormZoom;
  CurrentRightZoom := MainOptions.RightZoom;
  AChild := (ActiveMDIChild as TMyChild);
  W := 0;
  F := AChild.ActiveForm;
  if not Assigned(F) then
    Exit;
  W := F.StartUsedWidth;
  if W <> 0 then
    NewZoom := Trunc((100 * CenterW) / W);
  if NewZoom > 200 then
    NewZoom := 200;
  if NewZoom < 50 then
    NewZoom := 50;

  if (ReviewPanel.ActivePage = tabReview) or
     (ReviewPanel.ActivePage = tabLastYear) then
  Begin
    if (ReviewPanel.ActivePage = tabReview) and
       assigned(FPreviewForm) then
      for I := 0 to FPreviewForm.ControlCount-1 do
        if FPreviewForm.Controls[I] is TvtScrollBox then
        Begin
          F := (FPreviewForm.Controls[I] as TvtScrollBox); //20170518 Igor
          W := F.StartUsedWidth;
          break;
        End
        else
    else
    if (ReviewPanel.ActivePage = tabLastyear) and
       assigned(FLastYearForm) then
      for I := 0 to FLastYearForm.ControlCount-1 do
        if FLastYearForm.Controls[I] is TvtScrollBox then
        Begin
          F := (FLastYearForm.Controls[I] as TvtScrollBox); //20170518 Igor
          W := F.StartUsedWidth;
          break;
        End;
    NewRightZoom := TRUNC(100 * RightW / W); //20160720 Igor
    if NewRightZoom > 200 then
      NewRightZoom := 200;
    if NewRightZoom < 50 then
      NewRightZoom := 50;
  End
  else
    NewRightZoom := MainOptions.RightZoom;
  if (MainOptions.FormZoom <> NewZoom) or
     (MainOptions.RightZoom <> NewRightZoom) then
  Begin
    MainOptions.FormZoom := NewZoom;
    MainOptions.RightZoom := NewRightZoom;
    InitResizeForm;
  End;
//20170914 Igor<<<
end;

procedure Tvtnosplash.RebuildReviewForm;//20160222 Igor
var
  I,Cnt: Integer;
  R: Integer;
  //20170619 Igor >>>
//  procedure ClearReview;
//  var
//    C: Integer;
//  begin
//    if Assigned(FPreviewForm) then
//      for C := FPreviewForm.ControlCount - 1 downto 0 do
//        if (FPreviewForm.Controls[C] is TvtScrollBox) then
//        begin
//          FloatingForms.Remove((FPreviewForm.Controls[C] as TvtScrollBox));
//          FPreviewForm.Controls[C].Free;
//        end;
//    ReviewForms.Tabs.Clear;
//  end;
  //20170619 Igor <<<
Begin
  //20170518 Igor >>>
  if GetCurrentRetNo = 0 then
  begin
    ClearReview;
    //20170914 Igor>>>
    FLastActiveRetNo := R;
    //20170914 Igor<<<
    exit;
  end;
  //20170518 Igor <<<

  if (asLoadReturn in ApplicationState) or
     (asOpenForm in ApplicationState) then exit; //20160724 Igor
  R := GetCurrentRetNo;
  if FLastActiveRetNo = R then exit;
  FLastActiveRetNo := R;
  if Application.Terminated or not assigned(tabReview) then exit;

  //Clear current review form set
  //20170518 Igor >>>
  ClearReview;
  //20170518 Igor <<<
  //Create Static form
  if assigned(RetList[R]) AND Assigned(RetList[R].MyApp) then
  Begin
    for I := 0 to RetList[R].MyApp.CountReviewStaticForm -1 do
      ReviewForms.Tabs.Add(RetList[R].MyApp.ReviewStaticFormName[I]);
  end;
  //Create Dynamic form
  if assigned(RetList[R]) AND Assigned(RetList[R].MyApp) then
  Begin
    for I := 0 to RetList[R].MyApp.CountReviewDynamicForm -1 do
      ReviewForms.Tabs.Add(RetList[R].MyApp.ReviewDynamicFormName[I]);
  end;
  if ReviewForms.Tabs.Count > 0 then
  Begin
    if (RetList[R].MyApp.LastActiveReviewTab > 0) AND
       (RetList[R].MyApp.LastActiveReviewTab < ReviewForms.Tabs.Count) then
      ReviewForms.TabIndex := RetList[R].MyApp.LastActiveReviewTab
    else
      ReviewForms.TabIndex := 0;
    ReviewFormsChange(ReviewForms);
  end;

End;

procedure Tvtnosplash.LoadRightPanelSettings; //20160221 Igor
Begin
  if Application.Terminated or not assigned(ReviewPanel) or not Assigned(MainOptions) then exit;
  if (ReviewPanel.ActivePageIndex <> MainOptions.RightPanelActivePageIndex) AND
     (MainOptions.RightPanelActivePageIndex <> tabLastyear.PageIndex) then  //20160627 Igor
  Begin
    SetActiveTab(MainOptions.RightPanelActivePageIndex);
    ReviewPanelChange(ReviewPanel);
  End;
End;


procedure Tvtnosplash.ReviewFormsChange(Sender: TObject);
var
  i, FNo, R: integer;
  FName: string;
  AChild: TMyChild;
  P,P1: TPoint;
  //20170619 Igor >>>
  function ReviewFormIdent(ARetNo: Integer; AFormName: String): Boolean;
  var
    C: Integer;
  begin
    if Assigned(FPreviewForm) then
      for C := FPreviewForm.ControlCount - 1 downto 0 do
        if (FPreviewForm.Controls[C] is TvtScrollBox) then
          exit(SameText(TvtScrollBox(FPreviewForm.Controls[C]).FormName, AFormName) AND
               (TvtScrollBox(FPreviewForm.Controls[C]).RetNo = ARetNo));
    Result := False;
  end;
  //20170619 Igor <<<
begin
(* Show the form named as Caption
*)
  if ReviewPanel.ActivePage <> tabReview then exit; //20160220 Igor
  if (asLoadReturn in ApplicationState) or
     (asOpenForm in ApplicationState) or
     (asFamilyOpen in ApplicationState) then exit; //20160724 Igor
  if GetCurrentRetNo < 1 then //20160223 Igor
    exit; //no return open

//  Application.ProcessMessages;  //20160220 Igor //20160724 Igor
  R := GetCurrentRetNo;
  if not assigned(RetList[R]) then exit;

  RetList[R].MyApp.LastActiveReviewTab := ReviewForms.TabIndex;  //20160220 Igor
  i := ReviewForms.TabIndex;
  //20160724 Igor >>>
  if i < 0 then
  begin
    RebuildReviewForm;
    i := ReviewForms.TabIndex;
  end;
  //20160724 Igor <<<
  if i < 0 then exit; //20160220 Igor
  FName := ReviewForms.Tabs[i];
  if FName = '' then
    exit; //what?
  FNo := RetList[R].GetFormNo(FName);
  if FNo < 1 then
  begin //what?
    if i <= 0 then
      exit; //no TAXSUM form?
    ReviewForms.TabIndex := 0; //recursion?
    FName := 'TAXSUM';
    FNo := RetList[R].GetFormNo(FName);
    if FNo < 1 then
      exit; //no TAXSUM form?
  end;
  //20170619 Igor >>>
  SetupSubForm(FPreviewForm, tabReview);
  if not ReviewFormIdent(R, FName) then
  begin
    ClearReview(False);
    OpenTaxForm(R,FName,fsNormal,FPreviewForm);
  end;
  //20170619 igor <<<
//20160113 Igor
  ReviewForms.onMouseDown:=PageControlMouseDown;
  ReviewForms.onDragOver:=PageControlDragOver;
  ReviewForms.onDragDrop:=PageControlDragDrop;

  tabReview.onDragOver:=PageControlDragOver;
  tabReview.onDragDrop:=PageControlDragDrop;
//  RetList[R].MyApp. MyFormHeaderFrame
  //20160227 Igor

  if not assigned(Application.MainForm) then exit; //20161111 Igor
  if not assigned(Application.MainForm.ActiveMDIChild) then exit; //20161111 Igor
  if not (Application.MainForm.ActiveMDIChild is TMyChild) then exit; //20161111 Igor

  AChild := (Application.MainForm.ActiveMDIChild as TMyChild);
  if assigned(AChild) AND (Self.Visible) AND (AChild.WindowState = wsMaximized) then
  Begin
    if assigned(AChild.HeaderFrame) then
    Begin
      P := AChild.HeaderFrame.Parent.ClientToScreen(Point(0,AChild.HeaderFrame.Top+AChild.HeaderFrame.Height));
      P1:= ReviewHeaderPanel.Parent.ClientToScreen(Point(0,ReviewHeaderPanel.Top));
      ReviewHeaderPanel.Height := min(P.Y - P1.Y,AChild.HeaderFrame.Height);
      ReviewHeaderPanel.Color := AChild.HeaderFrame.Color;
      //20160229 Igor
//      if ReviewForms.TabIndex < 0 then
//        ReviewHeaderPanel.Caption := 'Drag and drop any tab from the central part.'
//      else
//        ReviewHeaderPanel.Caption := ReviewForms.tabs[ReviewForms.TabIndex];
      if AChild.Pages.PageCount > 0 then
        ReviewForms.TabHeight := AChild.Pages.TabRect(0).Bottom-AChild.Pages.TabRect(0).Top;
    End;
    if assigned(AChild.MonitorFrame) then
    Begin
      ReviewBottomPanel.Height := AChild.MonitorFrame.Height;
    End;
  End;

  //20160227 Igor
end;

procedure Tvtnosplash.UpdateRightPanel;
begin
(* do what, depending on what?
*)
  if false then
    NotImp('UpdateRightPanel');
end;


// Id does not work
//20151001
//20150727 added:
procedure Tvtnosplash.TabControl1Change(Sender: TObject);
var
  AppId: string;
  i :Integer;
  LStr: array[0 .. MAX_PATH] of Char;// 20151119 Igor
  searchResult : TSearchRec;// 20151119 Igor
  lPop:TPopupMenu;
  lMenuItem: TMenuItem;
begin
  AppId := TabControl1.Tabs[TabControl1.TabIndex];
  if CurrentApp <> AppList.AppFromId(AppId) then
  Begin
    // 20151120 Igor
    if not Assigned(AppList.AppFromId(AppId)) then
    begin
      MainForm.GuiCommand(gcShowPriorYearList); //20160519 Igor
      TabControl1.TabIndex := PrevTabControl1TabIndex; // 20151120 Igor //20160519 Igor
      exit;
    end;
    // 20151030 Igor
    CurrentApp :=AppList.AppFromId(AppId);
    MainForm.GuiCommand(gcAppIdChanged);
    Application.ProcessMessages; //20160518 Igor
    Splash.SetActiveAppPage(TabControl1.Tabs[TabControl1.TabIndex]); //20160323 Igor
    //
  end;
  ShowSplash; // 20151215 Igor
end;

procedure Tvtnosplash.TabControl1Changing(Sender: TObject; //20160519 Igor
  var AllowChange: Boolean);
begin
  inherited;
  //20170927 Igor>>>
  if (TabControl1.TabIndex = 0) and StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    AllowChange := False;
    Exit;
  end;
  //20170927 Igor<<<
  PrevTabControl1TabIndex := TabControl1.TabIndex;
end;

procedure Tvtnosplash.TabControl1GetImageIndex(Sender: TObject;  //20160209 Igor
  TabIndex: Integer; var ImageIndex: Integer);
var
  AppId: String;
begin
  if TabIndex >= TabControl1.Tabs.Count then
    ImageIndex := TabControl1.Tag
  else
  Begin
    case TabIndex of
      0: ImageIndex := 0;
    else
    Begin
      AppId := TabControl1.Tabs[TabIndex];
      if not Assigned(AppList.AppFromId(AppId)) then
        ImageIndex := AppImages.Count - 1 //20170117 Igor
      else
        ImageIndex := ord(AppList.AppFromId(AppId).AppIdx);
    End;
    end;
  End;
end;

procedure Tvtnosplash.TabControl1MouseUp(Sender: TObject; Button: TMouseButton; //20160519 Igor
  Shift: TShiftState; X, Y: Integer);
var
  AppId: string;
begin
  inherited;
  AppId := TabControl1.Tabs[TabControl1.TabIndex];
  if Assigned(AppList.AppFromId(AppId)) then
    if (Screen.ActiveForm <> splash) then
    begin
      Splash.SetActiveAppPage(TabControl1.Tabs[TabControl1.TabIndex]); //20160323 Igor
      ShowSplash;
    end;
end;

// 20160114 Igor
procedure Tvtnosplash.tbZoomChange(Sender: TObject);
var
  I: Integer;
begin
 //20160209 Igor >>>>
  if rbZoomAll.Checked then
  Begin
    MainOptions.FormZoom := tbZoom.Position * 5;
    MainOptions.RightZoom := MainOptions.FormZoom;
  End
  else
  if rbZoomCenter.Checked then
  Begin
    MainOptions.FormZoom := tbZoom.Position * 5;
  End
  else
  if rbZoomRight.Checked then
  Begin
    MainOptions.RightZoom := tbZoom.Position * 5;
  End;
//20170914 Igor>>>
  InitResizeForm;
//  ReScaleAllOpenedForms;
//20170914 Igor<<<
end;

//20160113 Igor
procedure Tvtnosplash.PageControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Sender is TPageControl then
    TPageControl(Sender).BeginDrag(true);

    if Sender is TTabSheet then
    TTabSheet(Sender).BeginDrag(true);

    if Sender is TTabControl then
    Begin
      if (TTabControl(Sender).TabIndex >= RetList[RetNo].MyApp.CountReviewStaticForm) then //20160220 Igor
        TTabControl(Sender).BeginDrag(true);
    end
end;

procedure Tvtnosplash.pgcChange(Sender: TObject); //20160428 Igor
begin
  inherited;
  //20160516 Igor >>>
  case pgc.ActivePageIndex of
    0:
      begin
        ShowLeftPanel(False);
      end;
    1:
      begin
        actViewAudit.Checked := true;
        actViewForms.Checked := False;
        SetLeftPanelPartVisible;
        ShowLeftPanel(true);
      end;
    2:
      begin
        actViewAudit.Checked := False;
        actViewForms.Checked := True;
        SetLeftPanelPartVisible;
        ShowLeftPanel(true);
      end;
    3:
      begin
        actViewAudit.Checked := True;
        actViewForms.Checked := True;
        SetLeftPanelPartVisible;
        ShowLeftPanel(true);
      end;
  end;
  //20160516 Igor <<<
  //20170825 Igor>>>
  if not Assigned(Sender) then
    FpgcActivePageIndex := pgc.ActivePageIndex;
  //20170825 Igor<<<
end;

//20160113 Igor
procedure Tvtnosplash.PageControlDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept:=True;
end;
//20160113 Igor
procedure Tvtnosplash.PageControlDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  i, FNo: integer;
  FName: string;
begin
  //20160223 Igor >>>>>
  //dfm: TabRevie.onDragDrop := PageControlDragDrop AND TabRevie.onDragOver := PageControlDragOver;
  if Source is TPageControl then
  Begin
    if Source = Sender then exit;
    for I := 0 to ReviewForms.Tabs.Count-1 do
      if ReviewForms.Tabs[i] = TPageControl(Source).ActivePage.Caption then
        exit;
    if TPageControl(Source).ActivePage.Caption = '' then exit;

    if TPageControl(Source).ActivePage.ControlCount=1 then
    Begin
      RetList[RetNo].MyApp.AddReviewDynamicForm(TPageControl(Source).ActivePage.Caption); //20160220 Igor
      TPageControl(Source).ActivePage.Controls[0].Parent := tabReview;
      ReviewForms.Tabs.Add(TPageControl(Source).ActivePage.Caption);
      ReviewForms.TabIndex := ReviewForms.Tabs.Count-1;
      ReviewForms.OnChange(Sender);
      TPageControl(Source).ActivePage.Free;
    End;
    if TPageControl(Source).PageCount=0 then
    with TTabSheet.Create(Self) do
    begin
      PageControl:=TPageControl(Source);
      OnDragOver:=PageControlDragOver;
      OnDragDrop:=PageControlDragDrop;
      Tag:=-123;
    end;
  end
 //20160223 Igor <<<

end;

//20170429 Igor >>>
procedure Tvtnosplash.AdoptMe(AChild: TCustomForm; AAppIds: Array of string;
  ARetNos: Array of Integer);//20170727 Igor
var
  I: Integer;
  ts: TTabSheetEx;
begin
  for I := 0 to ReviewPanel.PageCount - 1 do
  begin
    if (ReviewPanel.Pages[I] is TTabSheetEx) and
       (TTabSheetEx(ReviewPanel.Pages[I]).Stepson = AChild) then
    begin
      ReviewPanel.ActivePage := ReviewPanel.Pages[I];//20170811 Igor
      exit;
    end;
  end;
  ts := TTabSheetEx.Create(ReviewPanel);
  ts.PageControl := ReviewPanel;
  ts.Caption := AChild.Caption;
  ts.ChildWidth := AChild.Width;
  ts.ChildHeight := AChild.Height;
  ts.ChildLeft := AChild.Left;
  ts.ChildTop := AChild.Top;
  ts.Stepson := AChild;

  SetLength(ts.AppIDs, length(AAppIds));
  for I := 0 to length(AAppIds) - 1 do
    ts.AppIds[I] := AAppIds[I];

  SetLength(ts.RetNos, length(ARetNos));
  for I := 0 to length(ARetNos) - 1 do
    ts.RetNos[I] := ARetNos[I];

  AChild.Parent := ts;
  AChild.FreeNotification(ts);

  AChild.Align := alClient;
  AChild.BorderStyle := bsNone;
  AChild.visible := True;

  SetActiveTab(ts);//20171228 Igor
  ReviewPanelChange(ReviewPanel);
  inc(FAdoptedForm);
end;

procedure Tvtnosplash.UnAdoptMe(AChild: TCustomForm);
var
  I: Integer;
begin
//20170727 Igor>>>
  for I := 0 to ReviewPanel.PageCount - 1 do
    if (ReviewPanel.Pages[I] is TTabSheetEx) and
       (TTabSheetEx(ReviewPanel.Pages[I]).Stepson = AChild) then
    begin
//20170727 Igor<<<
      AChild.Align := alNone;
      AChild.Width := TTabSheetEx(ReviewPanel.Pages[I]).ChildWidth;
      AChild.Height := TTabSheetEx(ReviewPanel.Pages[I]).ChildHeight;
      AChild.Left := TTabSheetEx(ReviewPanel.Pages[I]).ChildLeft;
      AChild.Top := TTabSheetEx(ReviewPanel.Pages[I]).ChildTop;
      AChild.BorderStyle := bsSizeable;

      AChild.Parent := nil;
      ReviewPanel.Pages[I].Free;
      SetActiveTab(tabHide);//20171228 Igor
      ReviewPanelChange(ReviewPanel);
      Dec(FAdoptedForm);
      exit;
    end;
end;
//20170429 Igor <<<

//20170727 Igor>>>
{ TTabSheetEx }

destructor TTabSheetEx.Destroy;
begin
  if Assigned(StepSon) then
  begin
    StepSon.RemoveFreeNotification(Self);
    StepSon := nil;
  end;
  inherited;
end;

procedure TTabSheetEx.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = Stepson) and (Operation = opRemove) then
  begin
    Stepson := nil;
    PostMessage(Self.Handle, UM_REMOVETABSHEET, 0, 0);
  end;
end;

procedure TTabSheetEx.UMREMOVE(var Message: TMessage);
var
  pc: Vcl.ComCtrls.TPageControl; //20180104 Igor
begin
  pc := Self.PageControl;
  Self.Free;
  if Assigned(pc) and Assigned(pc.OnChange) then
    pc.OnChange(pc);

end;
//20170727 Igor<<<

//20180122 Igor >>>
(* 
//20180104 Igor >>>

function ActiveTabColor: TColor;
begin
  Result :=  Rgb(128, 255, 128);
end;
{ TTabControl }

constructor TTabControl.Create(AOwner: TComponent);
begin
  inherited;
  OwnerDraw := true;
end;

procedure TTabControl.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
var FImageMargin, FImageW, FImageH: integer;

  procedure DrawImage;
  var X, Y: integer;
      FImageIndex: integer; //20180105 Igor
  begin
    //20180105 Igor >>>
    FImageIndex := TabIndex;
    if Assigned(OnGetImageIndex) then
      OnGetImageIndex(Self, TabIndex, FImageIndex);
    if FImageIndex < Images.Count then
    //20180105 Igor <<<
    begin
      if TabPosition = tpLeft then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Bottom - FImageH - FImageMargin;
      end
      else if TabPosition = tpRight then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Top + FImageMargin;
      end
      else if TabPosition = tpTop then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin + 2;
      end
      else if TabPosition = tpBottom then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin - 2;
      end;
      Images.Draw(Canvas, X, Y, FImageIndex, true); //20180105 Igor
    end;
  end;

  procedure DrawText;
  var
    FSavedDC, X, Y, Angle, H, W: Integer;
    FCaption: string;
  begin
    FCaption := Tabs[TabIndex];
    H := Canvas.TextHeight(Tabs[TabIndex]);
    W := Canvas.TextWidth(Tabs[TabIndex]);
    if TabPosition = tpLeft then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 - H div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 + W div 2 - FImageH + FImageMargin;
      Angle := 900;
    end
    else if TabPosition = tpRight then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 + H div 2;
      Y := FImageH - FImageMargin + Rect.Top + (Rect.Bottom - Rect.Top) div 2 - W div 2;
      Angle := -900;
    end
    else if TabPosition = tpTop then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left - FImageW) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2;
      Angle := 0;
    end
    else if TabPosition = tpBottom then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left - FImageW) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2 - 2;
      Angle := 0;
    end;
    FSavedDC := SaveDC(Canvas.Handle);
    try
      SetBkMode(Canvas.Handle, TRANSPARENT);
      Canvas.Font.Orientation := Angle;
      Canvas.TextOut(X, Y, Tabs[TabIndex]);
    finally
      RestoreDC(Canvas.Handle, FSavedDC);
    end;
  end;

begin
  inherited;
  if Active then
    Canvas.Brush.Color := ActiveTabColor
  else
    Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(Rect);
  FImageMargin := 0;
  FImageW := 0;
  FImageH := 0;
  if Images <> nil then
  begin
    FImageW := Images.Width;
    FImageH := Images.Height;
    if (TabPosition = tpLeft) or (TabPosition = tpRight) then
      FImageMargin := (Rect.Right - Rect.Left - Images.Width) div 2
    else
      FImageMargin := (Rect.Bottom - Rect.Top - Images.Height) div 2;
    DrawImage;
  end;
  DrawText;
  Canvas.Brush.Color := clBtnFace;
end;

{ TPageControl }

constructor TPageControl.Create(AOwner: TComponent);
begin
  inherited;
  OwnerDraw := true;
end;

procedure TPageControl.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
var FImageMargin, FImageW, FImageH, FPageIndex: integer;

  procedure DrawImage;
  var X, Y: integer;
  begin
    if Pages[FPageIndex].ImageIndex < Images.Count then
    begin
      if TabPosition = tpLeft then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Bottom - Images.Height - FImageMargin;
      end
      else if TabPosition = tpRight then
      begin
        X := Rect.Left + FImageMargin;
        Y := Rect.Top + FImageMargin;
      end
      else if TabPosition = tpTop then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin + 2;
      end
      else if TabPosition = tpBottom then
      begin
        X := Rect.Left + FImageMargin + 2;
        if Active then
          Y := Rect.Top + FImageMargin
        else
          Y := Rect.Bottom - FImageW - FImageMargin - 2;
      end;
      Images.Draw(Canvas, X, Y, Pages[FPageIndex].ImageIndex, true);
    end;
  end;

  procedure DrawText;
  var
    FSavedDC, X, Y, Angle, H, W: Integer;
    FCaption: string;
  begin
    FCaption := Pages[FPageIndex].Caption;
    H := Canvas.TextHeight(FCaption);
    W := Canvas.TextWidth(FCaption);
    if TabPosition = tpLeft then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 - H div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 + W div 2 - FImageH + FImageMargin;
      Angle := 900;
    end
    else if TabPosition = tpRight then
    begin
      X := Rect.Left + (Rect.Right - Rect.Left) div 2 + H div 2;
      Y := FImageH - FImageMargin + Rect.Top + (Rect.Bottom - Rect.Top) div 2 - W div 2;
      Angle := -900;
    end
    else if TabPosition = tpTop then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2;
      Angle := 0;
    end
    else if TabPosition = tpBottom then
    begin
      X := FImageW - FImageMargin + Rect.Left + (Rect.Right - Rect.Left) div 2 - W div 2;
      Y := Rect.Top + (Rect.Bottom - Rect.Top) div 2 - H div 2;
      Angle := 0;
    end;
    FSavedDC := SaveDC(Canvas.Handle);
    try
      SetBkMode(Canvas.Handle, TRANSPARENT);
      Canvas.Font.Orientation := Angle;
      Canvas.TextOut(X, Y, FCaption);
    finally
      RestoreDC(Canvas.Handle, FSavedDC);
    end;
  end;

  function PageIndexFromTabIndex(TabIndex: Integer): Integer;
  var
    I, FTabIndex: Integer;
  begin
    FTabIndex := -1;
    Result := TabIndex;
    for i := 0 to PageCount - 1 do
    begin
      if FTabIndex = TabIndex then Break;
      if not Pages[i].TabVisible then
        Inc(Result)
      else
        Inc(FTabIndex);
    end;
  end;

begin
  inherited;
  FPageIndex := PageIndexFromTabIndex(TabIndex);
  //if not Pages[FPageIndex].TabVisible then Exit;
  if Active then
    Canvas.Brush.Color := ActiveTabColor
  else
    Canvas.Brush.Color := clBtnFace;
  Canvas.FillRect(Rect);
  FImageMargin := 0;
  FImageW := 0;
  FImageH := 0;
  if Images <> nil then
  begin
    FImageW := Images.Width;
    FImageH := Images.Height;
    if (TabPosition = tpLeft) or (TabPosition = tpRight) then
      FImageMargin := (Rect.Right - Rect.Left - Images.Width) div 2
    else
      FImageMargin := (Rect.Bottom - Rect.Top - Images.Height) div 2;
    DrawImage;
  end;
  DrawText;
  Canvas.Brush.Color := clBtnFace;
end;
*)
//20180122 Igor <<<

end.

