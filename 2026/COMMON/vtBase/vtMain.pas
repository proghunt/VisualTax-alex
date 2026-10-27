unit vtMain;
(* Replacement for direct MainForm references.
  Contains links to MainForm components and methods,
    initialized on program start.
  Also contains commands independent from or common to all AppIds.

Goal: replace all Main.pas uses by uMain.pas.
*)

interface

uses
  Classes, Windows, Forms, Controls, StdCtrls, ExtCtrls, Graphics, Menus, Dialogs,
  VCL.ActnList,//20170907 Igor
  EkRtf, System.IOUtils, //20190605 Igor
  vtMulti;

type
  //enums in vtMulti, to prevent circular unit references!
  TGuiCommand = procedure(cmd: eGuiCommand) of object;
  TMainProc = procedure of object;
  TMainProcInt = procedure(RetNo: integer) of object;

  TMainDummy = object
  private
    FMode: TArrangeMode;
    FViewSideBySidePanel: TWinControl;
    procedure SetMode(const Value: TArrangeMode);
  public //variables
    //AuditPanel,
    FormsPanel,
      LeftPanel,
      SuperVerificationBtn,
      WizardPanel: TWinControl; // TPanel;
    SuperAuditBox,
      UsedFormsBox: TCheckBox;
    AppImages: TImageList;
    function Handle: THandle; //use Application.Mainform.Handle instead?
  public //methods
    GuiCommand: TGuiCommand;
    EkRtf1: TEkRTF;
    PrintDialogItem: TPrintDialog;
    procedure Validate; //assert all references in place
    procedure AuditOpenBtnClick(Sender: TObject);
    procedure ReduceTutorialHeight(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
    procedure RefreshAuditPanel(RetNo: Integer);
    procedure RefreshFormsPanel(RetNo: Integer);
    property ArrangeMode: TArrangeMode read FMode write SetMode;
  public //common handlers
    procedure ClrClick(RetNo: integer; Sender: TObject; AClrElm: Integer);//20170219 Igor
  public //common commands, shortcuts
    procedure AboutItemClick(Sender: TObject);
    procedure CloseAllReturns;
    function CloseAllReturnsWithoutSaving(fConfirm: boolean = True): boolean;
    procedure FileExitItemClick(Sender: TObject);
    procedure FileSaveAsItemClick(RetNo: integer);
    function SaveAllReturns: boolean; //allow for methods
    procedure SetDisplayBtnClick(Sender: TObject);
    procedure ShowCellNumbers1Click(Sender: TObject);//20170907 Igor
    procedure TileVertical1Click;
    procedure TileHorizontally1Click;
    procedure TileMaximize;
    property ViewSideBySidePanel: TWinControl read FViewSideBySidePanel write FViewSideBySidePanel; //20170719 Igor
  end;
var
  MainForm: TMainDummy;
  //main form flags, could be moved into MainDummy
  SuperAuditSw,
    ScrollInSync: boolean;
  SkipReplaceFileQuestion: boolean; //20190701 Igor

procedure RetNoChanged(ARetNo: integer);
procedure ValueChanged(ARetNo: integer);
function ZoomBtnClicked(zoomDelta: integer): boolean; //valid range?

procedure ProgramInit;

implementation

uses
  SysUtils,
  vtDialogs, vtCommon, vtChild, vtEditBox, fCalcWatch,
  //keep last
  vtTrimStr, vtShared;

procedure ProgramInit;
begin
//20170927 igor>>>
  SetShortDateFormat;
  FastPrint := False;
//  Application.Icon.LoadFromFile(ExeDir + '\' + 'Visual.Ico');
  Application.HelpFile := ExeDir;
  ReviewMarkColor := clRed;
//20170927 igor<<<
end;

procedure RetNoChanged(ARetNo: integer);
begin
  (* called on OpenForm, close...
    also notify AppId for possible adjustments?
  *)
  //20170914 Igor<<<
  if GetCurrentRetNo = ARetNo then
    exit;
  //20170914 Igor>>>
  GetCurrentRetNo := ARetNo;
  if Assigned(Application.MainForm) then //20160531 Igor
    MainForm.GuiCommand(gcRetNoChanged);
  if ARetNo > 0 then
    AppList.RetNoChanged; //notify all apps
  //20160223 Igor >>>
  if assigned(RetList[ARetNo]) then
  Begin
    if CurrentApp <> AppList.AppFromId(RetList[ARetNo].MyApp.AppId) then
    Begin
      CurrentApp :=AppList.AppFromId(RetList[ARetNo].MyApp.AppId);
      if Assigned(Application.MainForm) then //20160531 Igor
        MainForm.GuiCommand(gcAppIdChanged);
    end;
  end;
   //20160223 Igor <<<<
end;

procedure ValueChanged(ARetNo: integer);
begin
  (* Does: refresh GUI: all open forms, MainForm + MDIChild panels
    DO CountDiagnostics?

    To be called WHEN?
    At end of ExitField if changed
    After USER (calc...) actions
  *)
  RetList[ARetNo].CountDiagnostics; //CountDiagnostics(RetNo);
  //AppCommand(acUpdateDiagnostics,RetNo);
  //MainForm.OnValueChanged;
  UpdateChildWin(ARetNo); //header/footer
  //todo
    //UpdateAllOpenForms; //related to current return only!?
end;

function ZoomBtnClicked(zoomDelta: integer): boolean; //valid range?
var
  zoom, i: integer;
  AChild: TMyChild;
begin
  (* called directly from ZoomButton...Click
    zoom = delta?
    check range
    Save new FormZoom
    update GUI? -> app.SelectFeatures (by caller?)
  *)
  Result := False; //assume invalid
 //20160209 Igor >>>>>
  case MainOptions.ZoomForm of
    zfAll:Begin
      //20161115 Igor >>>
      Zoom := MainOptions.FormZoom + zoomDelta;
      if (zoom >= GC_MINSCALE) AND (zoom <= GC_MAXSCALE)
         AND
         (zoom <> MainOptions.FormZoom) then
        MainOptions.FormZoom := zoom;

      Zoom := MainOptions.RightZoom + zoomDelta;
      if (zoom >= GC_MINSCALE) AND (zoom <= GC_MAXSCALE)
         AND
         (zoom <> MainOptions.RightZoom) then
        MainOptions.RightZoom := zoom;
      //20161115 Igor <<<
    End;
    zfCenter:Begin
      Zoom := MainOptions.FormZoom + zoomDelta;
      if (zoom < GC_MINSCALE) or (zoom > GC_MAXSCALE) then
        exit;
      if zoom = MainOptions.FormZoom then
        exit;
      MainOptions.FormZoom := zoom;

    End;
    zfRight:Begin
      Zoom := MainOptions.RightZoom + zoomDelta;
      if (zoom < GC_MINSCALE) or (zoom > GC_MAXSCALE) then
        exit;
      if zoom = MainOptions.RightZoom then
        exit;
      MainOptions.RightZoom := zoom;
    End;
  end;
  ReScaleAllOpenedForms;
  Result := True;
   //20160209 Igor <<<<<<
end;

{ TMainDummy }

procedure TMainDummy.AuditOpenBtnClick(Sender: TObject);
begin
  //not if no return open
  if Application.MainForm.MDIChildCount > 0 then
    GuiCommand(gcAuditOpenBtnClick);
end;

procedure TMainDummy.FileExitItemClick(Sender: TObject);
begin
  (*
   // SuperAuditBox.Checked := False;
    If CountUnsavedReturns = 0 then
      Application.Terminate {Close}
    else
     if MessageDlg(
       IntToStr(CountUnsavedReturns)
       + ' return(s) still in memory.'
       + Chr(13)+' Exit without closing the return(s)?',
       mtWarning, [mbNo, mbYes], 0) = mrYes then
          Application.Terminate; {Close;}
  *)
  Application.MainForm.Close; //check for unsaved returns!
end;

procedure TMainDummy.FileSaveAsItemClick(RetNo: integer);
begin
  RetList[RetNo].DoSaveAs;
end;

procedure TMainDummy.FormPaint(Sender: TObject);
begin
  GuiCommand(gcFormPaint);
  FloatingForms.UpdateForms(GetCurrentRetNo);
end;

function TMainDummy.Handle: THandle;
begin
  Result := Application.MainForm.Handle;
end;

procedure TMainDummy.RecalcBtnClick(Sender: TObject);
begin
  GuiCommand(gcRecalcBtnClick);
end;

procedure TMainDummy.ReduceTutorialHeight(Sender: TObject);
begin
  GuiCommand(gcReduceTutorialHeight);
end;

procedure TMainDummy.RefreshAuditPanel(RetNo: Integer);
begin
  GuiCommand(gcRefreshAuditPanel);
end;

procedure TMainDummy.RefreshFormsPanel(RetNo: Integer);
begin
  GuiCommand(gcRefreshFormsPanel);
end;

procedure TMainDummy.CloseAllReturns;
var
  I: Integer;
begin
  for I := RetList.Count-1 downto 0 do
  Begin
    if Assigned(RetList[I]) then
    Begin
      RetList[I].Changed := False; //prevent second question
      if Assigned(RetList[I]) then
        RetList[I].Close(True);
    End;
  end;
end;

function TMainDummy.CloseAllReturnsWithoutSaving(fConfirm: boolean): boolean;
begin
  Result := False;
  if fConfirm then
  begin
    if MessageDlg('Close ALL returns without saving them?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      exit;
  end;
  Result := True;
  CloseAllReturns;
end;

function TMainDummy.SaveAllReturns: boolean;
var
  i: integer;
  RetRec: RetPtr;
  HasAnswer: boolean; //20190605 Igor //20190701 Igor
begin
  (* loop over all open returns
    framework from T2-2013
  *)
  Result := True;
  //20190605 Igor >>>
  HasAnswer := false;
  //20190605 Igor <<<
  //20190701 Igor >>>
  SkipReplaceFileQuestion := false; 
  Screen.Cursor := CrHourGlass;
  try
    for i := RetList.Count - 1 downto 1 do
    begin
      RetRec := RetList[i];
      if (RetRec <> nil) AND not RetRec.IsLastYearReturn AND not RetRec.isAppendix then  //20160314 Igor
      begin
      if RetRec.MyChild <> nil then
        RetRec.MyChild.BringToFront; // SetFocus;
        if CurrentApp <> AppList.AppFromId(RetRec.MyApp.AppId) then //20160223 igor
        Begin
          CurrentApp :=AppList.AppFromId(RetRec.MyApp.AppId); //20160223 Igor
          MainForm.GuiCommand(gcAppIdChanged);               //20160223 Igor
        end;
        //20190605 Igor >>>
        if FileExists(TPath.Combine(RetRec.SourceDataDir, RetRec.SourceFlName)) then
        begin
          if not HasAnswer then
          begin
            HasAnswer := true;
            SkipReplaceFileQuestion := MessageDlg('File exists. Override?',
                        mtConfirmation, [mbYes, mbNo], 0) = mrYes;
          end;
          if not SkipReplaceFileQuestion then continue;
          //TFile.Delete(TPath.Combine(RetRec.SourceDataDir, RetRec.SourceFlName));
        end;
        //20190605 Igor <<<
        Result := RetRec.DoSave;
        if not Result then
          exit; //not saved
      end;
    end;
  finally
    SkipReplaceFileQuestion := false;
    Screen.Cursor := CrDefault;
  end;
  //20190701 Igor <<<
  if Result then
    ShowTimedMsg('All returns saved', 1200);
end;

procedure TMainDummy.TileHorizontally1Click;
begin
  ArrangeMode := amTileHorz;
  GuiCommand(gcMDIArrange);
end;

procedure TMainDummy.TileVertical1Click;
begin
  ArrangeMode := amTile;
  GuiCommand(gcMDIArrange);
end;

procedure TMainDummy.TileMaximize;
begin
  ArrangeMode := amMaximize;
  GuiCommand(gcMDIArrange);
end;

procedure TMainDummy.SetMode(const Value: TArrangeMode);
var
  i: integer;
  MainForm: TForm;
begin
  if FMode = Value then
    exit;
  FMode := Value;
  MainForm := Application.MainForm;
  if FMode <> amMaximize then
  begin
    for i := 0 to MainForm.MDIChildCount - 1 do
      MainForm.MDIChildren[i].WindowState := wsNormal;
  end;
  //set MDIForm.TileMode
  case Value of
    amTile: MainForm.TileMode := tbVertical;
    amTileHorz: MainForm.TileMode := tbHorizontal;
  end;
end;

procedure TMainDummy.Validate;
begin
  //assert(assigned(AboutPanel), 'assign AboutPanel');
  //assert(assigned(AuditPanel), 'assign AuditPanel');
  assert(assigned(FormsPanel), 'assign FormsPanel');
  assert(assigned(UsedFormsBox), 'assign UsedFormsBox');
  assert(assigned(WizardPanel), 'assign WizardPanel');
  assert(assigned(GuiCommand), 'assign GuiCommand');
  assert(assigned(EkRtf1), 'assign EkRtf1');
  assert(assigned(PrintDialogItem), 'assign PrintDialogItem');
end;

procedure TMainDummy.ClrClick(RetNo: integer; Sender: TObject; AClrElm: Integer); //20170219 Igor
var
  Clr: Tcolor;
begin
  (* handler for colorlist click
    Sender has the selected Color
  *)
  clr := (Sender as TPanel).Color;
  SetRetColor(RetNo, clr, AClrElm); //20170219 igor
  //update GUI
  if RetList[RetNo].MyChild = nil then
    exit;

  RetList[RetNo].MyChild.SetColor(clr); //.Invalidate;
  GuiCommand(gcColorChanged);
end;

procedure TMainDummy.AboutItemClick(Sender: TObject);
begin
  ShowAbout;
end;

procedure TMainDummy.ShowCellNumbers1Click(Sender: TObject);//20170907 Igor
begin
  (* Applies to all visible forms (floating...)
  *)
  ShowFieldIdSw := not ShowFieldIdSw;
  //20170907 Igor>>>
  if Sender is TMenuItem then
    TMenuItem(Sender).Checked := ShowFieldIdSw
  else
  if Sender is TAction then
    TAction(Sender).Checked := ShowFieldIdSw;
  //20170907 Igor<<<
  //If RetInMem >0 then MyChild.ShowFormData(MyChild,GetCurrentRetNo,FormName,FormNo);
  //GetActiveChild.PopulateActiveFormWithData; //(GetActiveForm);
  UpdateAllVisibleForms;
  //developer only
  if IsDeveloperLogin and ShowFieldIdSw then
    CalcWatch.ShowModal; //allow to configure the watches
end;

procedure TMainDummy.SetDisplayBtnClick(Sender: TObject);
begin
  UserMsg('Use Control Panel for adjusting the screen resolution');
end;

end.
