unit fMainBase;
(* The purpose of this unit is to provide a base for various GUI designs.
  General functionality should reside here, so that a concrete main form
  must only handle its special GUI elements.
*)

(* Problems in this revision:
+ MDI forms always tile horizontally on Tile? (TileMode not set!)
*)

{.$DEFINE Packages}   //loading packages?
{$DEFINE DblBuf} //use DoubleBuffer to reduce flicker?

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, shdocvw, OleCtrls, FileCtrl,
  vtMulti, //uMultiApp, //UDeclare,
  VtShape,vtEditBox,vtLabel,vtForm, System.Actions; //, vtScrollBox;

type
//20160122 Igor
  TwwRichEditOption=(reoShowLoad, reoShowSaveAs, reoShowSaveExit, reoShowPrint, reoShowPageSetup,
                     reoShowFormatBar, reoShowToolBar, reoShowStatusBar,
                     reoShowHints, reoShowRuler, reoShowInsertObject, reoCloseOnEscape,
                     reoFlatButtons, reoShowSpellCheck, reoShowMainMenuIcons,
                     reoShowJustifyButton, reoUseBackColor, reoNoConfirmation);
  TwwRichEditOptions=Set of TwwRichEditOption;
  TwwFormPosition = class(TPersistent)
  private
     FLeft, FTop: integer;
     FWidth, FHeight: integer;
  published
     property Left: integer read FLeft write FLeft;
     property Top: integer read FTop write FTop;
     property Width: integer read FWidth write FWidth;
     property Height: integer read FHeight write FHeight;
  end;
  TwwMeasurementUnits=(muInches, muCentimeters);
  TwwPrintMargins = class(TPersistent)
  private
     FTop, FBottom, FLeft, FRight: Double;
  published
     property Top: Double read FTop write FTop;
     property Bottom: Double read FBottom write FBottom;
     property Left : Double read FLeft write FLeft;
     property Right : Double read FRight write FRight;
  end;
  TwwRichEditWidth=(rewWindowSize, rewPrinterSize);

  TwwDBRichEdit = class(TRichEdit)
  private
    FAutoURLDetect: Boolean;
    FPrintJobName: String;
    FEditorOptions: TwwRichEditOptions;
    FEditorCaption: string;
    FEditorPosition: TwwFormPosition;
    FUnits: TwwMeasurementUnits;
    FPrintMargins: TwwPrintMargins;
    FEditWidth: TwwRichEditWidth;
    FRichEditVersion: integer;
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoURLDetect: Boolean read FAutoURLDetect write FAutoURLDetect;
    property PrintJobName: String read FPrintJobName write FPrintJobName;
    property EditorOptions: TwwRichEditOptions read FEditorOptions write FEditorOptions default
           [reoShowSaveExit, reoShowPrint, reoShowPageSetup,
            reoShowFormatBar, reoShowToolbar, reoShowStatusBar,
            reoShowHints, reoShowRuler, reoShowInsertObject ,reoCloseOnEscape,
            reoFlatButtons, reoShowMainMenuIcons, reoShowSpellCheck];
    property EditorPosition: TwwFormPosition read FEditorPosition write FEditorPosition;
    property MeasurementUnits: TwwMeasurementUnits read FUnits write FUnits;
    property PrintMargins: TwwPrintMargins read FPrintMargins write FPrintMargins;
    property EditWidth: TwwRichEditWidth read FEditWidth write FEditWidth default rewWindowSize;
    property RichEditVersion: integer read FRichEditVersion write FRichEditVersion;
    property EditorCaption : string read FEditorCaption write FEditorCaption;
    property ScrollBars;
    property Align;
  end;

type
  TVTMain = class(TForm)

    OpenDialog1: TOpenDialog;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    ImageList1: TImageList;
    AuditPanelSplitter: TSplitter;
    ReviewPanelSplitter: TSplitter;
    SaveDialog1: TSaveDialog;
    PrintDialogItem: TPrintDialog;
    ColorDialog1: TColorDialog; //experimental!
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure SaveAllOpenedReturnsClick(Sender: TObject);
    procedure SaveAndCloseAllOpenedReturnsClick(Sender: TObject);
    procedure CloseAllReturnsWithoutSavingClick(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AuditPanelSplitterMoved(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure WindowCascade1Execute(Sender: TObject);
    procedure WindowTileVertical1Execute(Sender: TObject);
    procedure TileReturns1Click(Sender: TObject);
    procedure TileReturns2Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NoScaleClick(Sender: TObject);
    procedure clr0Click(Sender: TObject);
    procedure ClrCustomClick(Sender: TObject);
    procedure MinimizeReturnClick(Sender: TObject);
    procedure MinimizeAllClick(Sender: TObject);
    procedure RestoreReturnClick(Sender: TObject);
    procedure RestoreAllClick(Sender: TObject);
  published
  protected
  //detect changed return/app
    CurApp: TApp;
      CurLicense: eLicenseLevel;
    CurRet: RetPtr;
    //FormsBarSw, //???
    //StatusBarSw, //???
    //ToolBarSw: boolean;
    RetNo: integer; //set by ButtonInactive
    function  ButtonInactive: Boolean;
    function  CountFiles(const Dir, FileExt: String): Integer;
    //function  DetectApp(Sender: TObject): boolean;
    procedure FormPaint_; virtual;
    procedure MDIArrange;
    procedure SetArrangeMode(const Value: TArrangeMode);
    function  GetArrangeMode: TArrangeMode;
    procedure LoadOptions; virtual;
    procedure SaveOptions; virtual;
    procedure SelectFeatures; virtual;
    procedure ShowAbout; virtual;
  published //some menu functions
    procedure PrintManager1Click(Sender: TObject);
    procedure PrinterSetupClick(Sender: TObject);
  end;

  procedure initfMainBase; //20160220 Igor
  procedure Register;

implementation

{$R *.DFM}

uses
  Printers, ShellApi, DBCtrls, EkRtf,
  vtMain,
  vtChild,
  vtDialogs, //fFileViewer,
  fPopList, vtAuthorization,
  //fFixDb,  //20120420
  vtButton,vtMemoBox, vtRichMemobox, vtPanel, //wwRichEd,
  uCanFlagFrame, uFlagFrameCan, uFlagFrameCanada,
  uFlagFrameAB,uFlagFrameBC,uFlagFrameMB,
  UFlagFrameMBMCT,  uFlagFrameNS,
  uFlagFrameNB,uFlagFrameNF,uFlagFrameNW,uFlagFrameNU,uFlagFrameON,
  uFlagFramePE,uFlagFrameSK,uFlagFrameYK,  //, uSlipsFrame;
  vtCommon;//UPrototypeRtns,
//  T1_2014SlipsFrame, T1_2014FrameElections; //20160118 Igor //20160216 Igor
procedure TVTMain.FileNew1Execute(Sender: TObject);
begin
{Action FileNew1}
{$IFDEF AppCommand}
  MainForm.FileNewItemClick(Sender);
{$ELSE}
{$ENDIF}
end;

procedure TVTMain.FileOpen1Execute(Sender: TObject);
begin
{$IFDEF AppCommand}
  MainForm.FileNewItemClick(Sender);
{$ELSE}
{$ENDIF}
end;

procedure TVTMain.HelpAbout1Execute(Sender: TObject);
begin
  ShowAbout;
end;

procedure TVTMain.FileExit1Execute(Sender: TObject);
begin
//shut down
  Close;
end;

procedure TVTMain.CloseAllReturnsWithoutSavingClick(Sender: TObject);
begin
  if MessageDlg('Close ALL returns without saving them?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes
  then
    exit;
  RetList.Clear;
{$IFDEF old}
  RetNoChanged(nil); //not automatically triggered!?
{$ELSE}
  FormPaint_;
{$ENDIF}
end;

procedure TVTMain.FormCreate(Sender: TObject);

  Procedure InitSwitches;
  begin
  {
    ToolBarSw := True;
    StatusBarSw := True;
    FormsBarSw := False;
  }
  end;

begin
{$IFDEF DblBuf}
  DoubleBuffered := True;
{$ELSE}
{$ENDIF}
  Application.Icon.LoadFromFile(ExeDir+'\'+'Visual.Ico');
  Application.HelpFile := ExeDir;  // AppDir;

  InitSwitches;
  TileMode := tbVertical;

(* Do NOT set this property at design time,
 this would make the controls on the Main form not align properly.
*)
  //Application.MainForm := self; //replaced???
  //FormStyle := fsMDIForm; - delay until OnIdle

  LoadOptions;
(*
//check license file
  if not FileExists(ExeDir + '\' + LicenseFile) then begin
    //ErrorMsg('No license file found');
    ShowAbout;
  end;
*)
//load packages
  LoadApps;
//should be done after Create?
  if AppList.LicensedApps < 1 then begin
  //allow to enter keys
    ShowAbout;
  end;
(* after Create!?
  if AppList.LicensedApps > 0 then begin
    //AppList.InitGUI(Self); //now MainForm is available, map all handlers
    //CurApp.Activate;
    AppList.InitApps;
  end else begin
    ShowMessage('No AppId installed - exiting program');
    Application.Terminate;
  end;
*)
(* after Create!?
//  ShowMessage('Loggin in');
  if not Logon then
    close;
*)
{ TODO -oCon : make logon multi-app how? }
(*
  If (LeftStr(LicenseLevel,8) ='T1 Multi') and
   (ValidUser=False) then
    Application.Terminate;
   OptRec.Dir_Cur :=OptRec.Dir_Deflt;
   If (LeftStr(LicenseLevel,8) ='T1 Multi')
   then
   begin
     OptRec.Dir_Cur :=User.Tax_Dir;
     OptRec.Dir_Deflt :=User.Tax_Dir;
     OptRec.Ef_DataDir :=  User.EFile_Dir;
   end;
*)
end;

procedure TVTMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if RetList.MustSave then begin
    case MessageDlg('Save changed returns', mtConfirmation, mbYesNoCancel, 0) of
    //mrYes:
    mrNo: CanClose := True;
    mrCancel: CanClose := False;
    else
      CanClose := MainForm.SaveAllReturns; //remove saved right now?
    end;
  end else
    CanClose := True;
  MainOptions.MaximizeMainForm := (WindowState = wsMaximized);
  if MainOptions.MaximizeMainForm = False then begin
    MainOptions.MainLeft := Left;
    MainOptions.MainTop := Top;
    MainOptions.MainWidth := Width;
    MainOptions.MainHeight := Height;
  end;
  SaveOptions;
end;

procedure TVTMain.AuditPanelSplitterMoved(Sender: TObject);
begin
//handler for resized MDI area, by moving the splitters around it
  MDIArrange; //rearrange MDI forms
end;

procedure TVTMain.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
(* Global Hotkeys, also work in MDI forms (unless captured there).

  When another active form (MDI...) implements an ShortCut handler,
  that one is called first
  and it can set Handled=True, to prevent any further handling.
*)
  case Msg.CharCode of
  {PLAIN F KEYS}
  {F1, F2 , F3, F5 in short cut}
  //VK_F2: ShowFormExplorer(GetCurrentRetNo);
  VK_F3:  //F3: save current return
    if not ButtonInactive then
      RetList[RetNo].DoSaveAs;
  //VK_F4: OpenForm(RetNo,GetFormNo('TAXSUM'),8);
  //VK_F7: MainForm.SwitchForms;
  VK_ESCAPE:
    begin
      If Printer.Printing then begin
        Printer.Abort;
        MessageDlg('Printing interrupted by user', mtInformation, [mbOK],0);
        Handled := True;  // Key:=0;
      end else begin
      {$IFDEF HandleESC}
      //all this in ChildWin
        if not IsIconic(TMyChild(ActiveMDIChild).activescrollbox.Handle) then begin
          If OptRec.EscOption ='GoToSummary' then begin
            CalcAll(RetNo);
            OpenForm(RetNo,GetFormno('TAXSUM'), fsNormal, ???);
          end else begin
            CloseActiveForm(Application);
            OpenForm(RetNo,GetFormNo(PrevFormName),fsMDIChild, ???);
          end;
          FormActivate(Sender);
        end;
      {$ELSE}
        //ShowMessage('Move ESC related into ChildWin');
        exit; //unhandled here, handled in TMyChild.Keys
      {$ENDIF}
      end;
    end;
  ord('S'): //CTRL-S: save current return
    if (GetKeyState(VK_CONTROL) < 0)
    and not ButtonInactive then
      RetList[RetNo].DoSaveAs
    else
      exit; //unhandled
  else
    exit; //unhandled;
  end;
//key handled if reached here
  Handled := True;
end;

procedure TVTMain.WindowCascade1Execute(Sender: TObject);
begin
  MainForm.ArrangeMode := amCascade;
  WindowCascade1.ExecuteTarget(self);
end;

procedure TVTMain.WindowTileVertical1Execute(Sender: TObject);
begin
  MainForm.ArrangeMode := amTile;
  WindowTileVertical1.ExecuteTarget(self);
end;

procedure TVTMain.TileReturns1Click(Sender: TObject);
begin
  WindowTileVertical1Execute(self);
end;

procedure TVTMain.TileReturns2Click(Sender: TObject);
begin
  TileReturns1Click(Sender);
end;

procedure TVTMain.MDIArrange;
begin
(* Rearrange according to last settings.
  what if maximized?
*)
  if ActiveMDIChild = nil then
    exit;

  //if ScrollInSync or (MainForm.ArrangeMode = amTile) then
  if ScrollInSync then
  begin
    TileMode := tbVertical;
    Tile; //force TileMode=tbHorizontal?
  end
  else
    case MainForm.ArrangeMode of
    amMaximize: ActiveMDIChild.WindowState := wsMaximized;
    amTile:
      begin
        TileMode := tbVertical;
        Tile;
      end;
    amTileHorz:
      begin
        TileMode := tbHorizontal;
        Tile;
      end;
    //amCascade
    else
      Cascade;
    end; //case
end;

//var bds: TRect; //debug

procedure TVTMain.FormResize(Sender: TObject);
begin
  //bds := BoundsRect;
  MDIArrange;
end;

var
  AlreadyShown: boolean;

procedure TVTMain.FormShow(Sender: TObject);
var
  r: TRect;
begin
  if AlreadyShown then
    exit;
  AlreadyShown := True; //do it only once
(* strange behaviour, when started maximized:
  the non-maximized values are crap (zero)
*)
  if not MainOptions.Valid then begin
    MainOptions.MainLeft := Left;
    MainOptions.MainTop := Top;
    MainOptions.MainWidth := Width;
    MainOptions.MainHeight := Height;
  end else begin
  //try: non-maximized position first, for Restore from Maximized
    r.Left := MainOptions.MainLeft;
    r.Right := r.Left + MainOptions.MainWidth;
    r.Top := MainOptions.MainTop;
    r.Bottom := r.Top + MainOptions.MainHeight;
    BoundsRect := r;

    if MainOptions.MaximizeMainForm then
      self.WindowState := wsMaximized;
  end;
end;

procedure TVTMain.NoScaleClick(Sender: TObject);
begin
{$IFDEF new}
  vtScrollBox.NoScale := True;
  NoScale.Down := True;
{$ELSE}
{$ENDIF}
end;

procedure TVTMain.SetArrangeMode(const Value: TArrangeMode);
begin
  MainForm.ArrangeMode := Value;
end;

function TVTMain.GetArrangeMode: TArrangeMode;
begin
  Result := MainForm.ArrangeMode;
end;

procedure TVTMain.PrintManager1Click(Sender: TObject);
Var h : THandle;
begin
{ TODO : moved into uPrint }
 h := ShellExecute(Handle, Nil, 'PrintMan.Exe', Nil,
  Nil, SW_RESTORE);
end;

Function TVTMain.ButtonInactive:Boolean;
begin
  RetNo := GetCurrentRetNo;
  Result := RetNo < 1; // RetInMem <1;
  if Result then
    ShowMessage('You must open a return first');
end;

procedure TVTMain.ClrCustomClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  if not ColorDialog1.Execute then
    exit;
  //IF CLR <> clBlack then Clr := ColorDialog1.Color;
  TPanel(Sender).Color := ColorDialog1.Color;
  Clr0Click(Sender);
end;

procedure TVTMain.clr0Click(Sender: TObject);
var
  Clr : Tcolor;
begin
  If ButtonInactive then exit;

  clr := (Sender as TPanel).Color;
//change return color
  SetRetColor(RetNo, clr);
end;

procedure TVTMain.SaveAllOpenedReturnsClick(Sender: TObject);
begin
  MainForm.SaveAllReturns;  //(True, False);
end;

procedure TVTMain.SaveAndCloseAllOpenedReturnsClick(Sender: TObject);
begin
  if MainForm.SaveAllReturns then
    MainForm.CloseAllReturnsWithoutSaving(False);
  //SaveAllReturns(True, True);
end;

Function TVTMain.CountFiles(const Dir, FileExt:String):Integer;
Var //i:Integer;
  FileListBox1:TFileListBox;
begin
  FileListBox1:=TFileListBox.Create(Application);
  FileListBox1.Parent:=Self;
  FileListBox1.Visible:=False;
  FileListBox1.Mask:='*.'+FileExt;
  FileListBox1.Directory:=Dir;
  Result:=FileListBox1.Items.Count;
  FileListBox1.Free;
end;

procedure TVTMain.PrinterSetupClick(Sender: TObject);
begin
  PrintDialogItem.Execute;
end;

procedure TVTMain.MinimizeReturnClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
    ActiveMDIChild.WindowState := wsMinimized;
end;

procedure TVTMain.MinimizeAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].WindowState := wsMinimized;
end;

procedure TVTMain.RestoreReturnClick(Sender: TObject);
var
  RetNo: integer;
begin
  if ButtonInactive then exit;
  RetNo := GetCurrentRetNo;
  if RetList[RetNo].MyChild <> nil then
    RetList[RetNo].MyChild.WindowState := wsNormal; //maximize?
end;

procedure TVTMain.RestoreAllClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].WindowState := wsNormal;
end;

procedure TVTMain.LoadOptions;
begin
  MainOptions.Load;
  //establish options later
end;

procedure TVTMain.SaveOptions;
begin
//save window state
  MainOptions.MaximizeMainForm := WindowState = wsMaximized;
  if WindowState = wsNormal then begin
    MainOptions.MainLeft := Left;
    MainOptions.MainTop := Top;
    MainOptions.MainWidth := Width;
    MainOptions.MainHeight := Height;
  end;
  MainOptions.Save;
end;

Procedure TVTMain.SelectFeatures;
Begin
//nothing here, must override or move into App.Gui...
  //in fVTGUI -> App.Gui...
end;

procedure TVTMain.FormPaint_;
begin
(* update entire GUI
*)
//must override
end;

procedure TVTMain.ShowAbout;
begin
  vtDialogs.ShowAbout;
end;

procedure Register;
begin
  RegisterComponents('VisualTax', [TVTMain]);
end;

{ TwwDBRichEdit } //20160122 Igor

constructor TwwDBRichEdit.Create(AOwner: TComponent);
begin
  inherited;
  FEditorPosition := TwwFormPosition.Create;
  FPrintMargins := TwwPrintMargins.Create;
end;

procedure TwwDBRichEdit.DefineProperties(Filer: TFiler);
begin
  inherited;
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadData, WriteData, true);
end;

procedure TwwDBRichEdit.ReadData(Stream: TStream);
begin
end;

procedure TwwDBRichEdit.WriteData(Stream: TStream);
begin
end;

procedure initfMainBase; //20160220 Igor
Begin
  RegisterClasses([TdbEdit,TImage,TShape,TSpeedButton,TEdit,TBitBtn,
    TPanel,TRichEdit,TLabel,TShape,TListBox,TFileListBox,TButton,
    TPageControl,TFrame,TMemo,TComboBox,TCheckBox,TLabel,TvtLabel,
    //TvtScrollBox,
    TvtEdit,TvtShape,TvtMemo,TvtRichMemo,
    TFrame,{TAcbFrame,}TEKRTF,
    TCanFlagFrame,TFlagFrameCan,TFlagFrameCanada,
    TFlagFrameAB,TFlagFrameBC,TFlagFrameMB,TFlagFrameMBMCT,
    TFlagFrameNS,TFlagFrameNB,TFlagFrameNF,TFlagFrameNW,TFlagFrameNU,
    TFlagFrameON,TFlagFramePE,TFlagFrameSK,TFlagFrameYK//,TwwDbRichEdit
    ,TwwDBRichEdit]); //20160118 Igor //20160122 Igor //20160216 Igor
End;


initialization
  initfMainBase; //20160220 Igor
end.
