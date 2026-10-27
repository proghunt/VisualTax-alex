{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC TADConnection editor form           }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsfConnEdit;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, Controls, Forms, ExtCtrls, Grids, StdCtrls, ComCtrls,
    IniFiles, Graphics, Buttons, ToolWin, ImgList, ActnList, Dialogs,
  uADStanIntf, uADStanOption,
  uADPhysIntf,
  uADCompClient, uADCompScript, uADCompGUIx,
  uADGUIxFormsfOptsBase, uADGUIxFormsControls, uADGUIxFormsfLogin,
    uADGUIxFormsfUpdateOptions, uADGUIxFormsfFormatOptions,
    uADGUIxFormsfFetchOptions, uADGUIxFormsfResourceOptions,
    uADGUIxIntf, uADGUIxFormsMemo, uADGUIxFormsfScript;

type
  TfrmADGUIxFormsConnEdit = class(TfrmADGUIxFormsOptsBase)
    pcMain: TPageControl;
    tsConnection: TTabSheet;
    sgParams: TStringGrid;
    cbParams: TComboBox;
    edtParams: TEdit;
    pnlTitle: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    cbServerID: TComboBox;
    cbConnectionDefName: TComboBox;
    Panel2: TPanel;
    tsOptions: TTabSheet;
    ptreeOptions: TADGUIxFormsPanelTree;
    frmFormatOptions: TfrmADGUIxFormsFormatOptions;
    frmFetchOptions: TfrmADGUIxFormsFetchOptions;
    frmUpdateOptions: TfrmADGUIxFormsUpdateOptions;
    frmResourceOptions: TfrmADGUIxFormsResourceOptions;
    pnlConnection: TPanel;
    pnlOptions: TPanel;
    tsSQL: TTabSheet;
    tsInfo: TTabSheet;
    pnlInfo: TPanel;
    mmInfo: TMemo;
    pnlSQL: TPanel;
    Splitter1: TSplitter;
    mmLog: TMemo;
    scrEngine: TADScript;
    sdMain: TADGUIxScriptDialog;
    ActionList1: TActionList;
    acNewScript: TAction;
    acOpenScript: TAction;
    acSaveScript: TAction;
    acSaveScriptAs: TAction;
    acSaveLog: TAction;
    acExit: TAction;
    acRun: TAction;
    acRunByStep: TAction;
    acSkipStep: TAction;
    acContinueOnError: TAction;
    acDropNonexistObj: TAction;
    acShowMessages: TAction;
    acHelp: TAction;
    acAbout: TAction;
    ilMain: TImageList;
    ToolBar1: TToolBar;
    tbtRun: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    btnDefaults: TButton;
    btnTest: TButton;
    btnWizard: TButton;
    btnWiki: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnWizardClick(Sender: TObject);
    procedure sgParamsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbServerIDClick(Sender: TObject);
    procedure EditorExit(Sender: TObject);
    procedure sgParamsTopLeftChanged(Sender: TObject);
    procedure EditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgParamsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgParamsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbConnectionDefNameClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sgParamsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnDefaultsClick(Sender: TObject);
    procedure frmOptionsModified(Sender: TObject);
    procedure cbParamsDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure mmScriptKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mmScriptMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scrEngineBeforeExecute(Sender: TObject);
    procedure scrEngineAfterExecute(Sender: TObject);
    procedure scrEngineConsoleGet(AEngine: TADScript; const APrompt: string;
      var AResult: string);
    procedure scrEngineConsoleLockUpdate(AEngine: TADScript; ALock: Boolean);
    procedure scrEngineConsolePut(AEngine: TADScript; const AMessage: string;
      AKind: TADScriptOuputKind);
    procedure scrEnginePause(AEngine: TADScript; const AText: string);
    procedure mmLogDblClick(Sender: TObject);
    procedure acRunUpdate(Sender: TObject);
    procedure acRunExecute(Sender: TObject);
    procedure acRunByStepUpdate(Sender: TObject);
    procedure acRunByStepExecute(Sender: TObject);
    procedure acSkipStepUpdate(Sender: TObject);
    procedure acSkipStepExecute(Sender: TObject);
    procedure btnWikiClick(Sender: TObject);
    procedure bedtParamsRightButtonClick(Sender: TObject);
  private
    FConnection: TADCustomConnection;
    FTempConnection: TADCustomConnection;
    FModified: Boolean;
    FDriverID: String;
    FConnectionDefName: String;
    FConnectionDef: IADStanConnectionDef;
    FDefaults, FResults, FEdited: TStrings;
    FOptions: IADStanOptions;
    FOnModified: TNotifyEvent;
    FLockResize: Boolean;
    FLastGridWidth: Integer;
    FEditor: Integer;
    function GetPageControl: TPageControl;
    procedure GetDriverParams(const ADrvID: String; AStrs: TStrings);
    procedure GetConnectionDefParams(const AConnectionDefName: String; AStrs: TStrings);
    procedure OverrideBy(AThis, AByThat: TStrings);
    procedure FillParamValues(AAsIs: Boolean);
    procedure FillParamGrids(AResetPosition: Boolean);
    procedure AdjustEditor(ACtrl: TWinControl; ACol, ARow: Integer);
    procedure FillConnParams(AParams: TStrings);
    procedure Modified;
    function IsDriverKnown(const ADrvID: String;
      out ADrvMeta: IADPhysDriverMetadata): Boolean;
    procedure ResetConnectionDef;
    procedure ResetOpts;
    function GetGridWidth: Integer;
    function GetEditor: TWinControl;
    function GetTempConnection: TADCustomConnection;
    function GetTestConnection: TADCustomConnection;
    procedure ReleaseTempConnection;
    procedure SetConnectionParams(AConnection: TADCustomConnection);
  protected
    procedure LoadFormState(AIni: TCustomIniFile); override;
    procedure SaveFormState(AIni: TCustomIniFile); override;
  public
    mmScript: TADGUIxFormsMemo;
    bedtParams: {$IFDEF AnyDAC_D12} TButtonedEdit {$ELSE} TEdit {$ENDIF};
    class function Execute(AConn: TADCustomConnection; const ACaption: String;
      const ACustomFrmADGUIxFormsConnEdit: TfrmADGUIxFormsConnEdit = nil): Boolean; overload;
    class function Execute(var AConnStr: String; const ACaption: String;
      const ACustomFrmADGUIxFormsConnEdit: TfrmADGUIxFormsConnEdit = nil): Boolean; overload;
    constructor CreateForConnectionDefEditor;
    procedure LoadData(AConnectionDef: IADStanConnectionDef);
    procedure PostChanges;
    procedure SaveData;
    procedure ResetState(AClear: Boolean);
    procedure ResetData;
    procedure ResetPage;
    procedure TestConnection;
    procedure FillConnectionInfo(AConnection: TADCustomConnection; ATryToConnect: Boolean);
    procedure SetReadOnly(AValue: Boolean);
    property LockResize: Boolean read FLockResize write FLockResize;
    property PageControl: TPageControl read GetPageControl;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;

var
  frmADGUIxFormsConnEdit: TfrmADGUIxFormsConnEdit;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
{$IFDEF AnyDAC_D6}
  Types,
{$ENDIF}
{$IFDEF AnyDAC_D17}
  System.UITypes, Actions,
{$ENDIF}
  DB,
  uADStanConst, uADStanResStrs, uADStanUtil,
  uADCompScriptCommands;

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

type
  __TWinControl = class(TWinControl)
  end;

{------------------------------------------------------------------------------}
// General

procedure TfrmADGUIxFormsConnEdit.FormCreate(Sender: TObject);
var
  iBorderY, iBorderX: Integer;
begin
  iBorderY := GetSystemMetrics(SM_CYBORDER);
  iBorderX := GetSystemMetrics(SM_CXBORDER);
  sgParams.DefaultRowHeight := GetEditor.Height - iBorderY;
  FLastGridWidth := GetGridWidth;
  sgParams.ColWidths[0] := MulDiv(FLastGridWidth, 1, 3) - 2 * iBorderX;
  sgParams.ColWidths[1] := MulDiv(FLastGridWidth, 1, 3) - 2 * iBorderX;
  sgParams.ColWidths[2] := MulDiv(FLastGridWidth, 1, 3) - 2 * iBorderX;
  FDefaults := TADStringList.Create;
  FResults := TADStringList.Create;
  FEdited := TADStringList.Create;
  mmScript := TADGUIxFormsMemo.Create(Self);
  mmScript.Parent := pnlSQL;
  mmScript.Align := alClient;
  mmScript.OnKeyUp := mmScriptKeyUp;
  mmScript.OnMouseUp := mmScriptMouseUp;

{$IFDEF AnyDAC_D12}
  bedtParams := TButtonedEdit.Create(Self);
  bedtParams.Parent := pnlConnection;
  bedtParams.Images := ilMain;
  bedtParams.RightButton.ImageIndex := 6;
  bedtParams.RightButton.Visible := True;
  bedtParams.OnRightButtonClick := bedtParamsRightButtonClick;
{$ELSE}
  bedtParams := TEdit.Create(Self);
  bedtParams.Parent := pnlConnection;
{$ENDIF}
  bedtParams.OnExit := EditorExit;
  bedtParams.OnKeyDown := EditorKeyDown;
  bedtParams.Visible := False;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.FormDestroy(Sender: TObject);
begin
  scrEngine.Connection := nil;
  ReleaseTempConnection;
  FOptions := nil;
  ADFreeAndNil(FDefaults);
  ADFreeAndNil(FResults);
  ADFreeAndNil(FEdited);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.pcMainChange(Sender: TObject);
begin
  if pcMain.ActivePage = tsInfo then
    FillConnectionInfo(nil, True)
  else if pcMain.ActivePage = tsSQL then
    scrEngine.Connection := GetTestConnection;
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsConnEdit.GetPageControl: TPageControl;
begin
  Result := pcMain;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.SetConnectionParams(AConnection: TADCustomConnection);
begin
  PostChanges;
  AConnection.Close;
  frmFetchOptions.SaveTo(AConnection.FetchOptions);
  frmFormatOptions.SaveTo(AConnection.FormatOptions);
  frmUpdateOptions.SaveTo(AConnection.UpdateOptions);
  frmResourceOptions.SaveTo(AConnection.ResourceOptions);
  FillConnParams(AConnection.Params);
  if FConnection <> nil then
    if FConnectionDefName <> '' then
      AConnection.ConnectionDefName := FConnectionDefName
    else
      AConnection.DriverName := FDriverID
  else
    if (CompareText(FResults.Values[S_AD_DefinitionParam_Common_Name], FConnectionDefName) = 0) or
       (FConnectionDefName = '') then
      AConnection.DriverName := FDriverID
    else
      AConnection.ConnectionDefName := FConnectionDefName;
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsConnEdit.GetTempConnection: TADCustomConnection;
begin
  if FTempConnection = nil then begin
    FTempConnection := TADConnection.Create(nil);
    SetConnectionParams(FTempConnection);
  end;
  Result := FTempConnection;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.ReleaseTempConnection;
begin
  if FTempConnection <> nil then begin
    scrEngine.Connection := nil;
    ADFreeAndNil(FTempConnection);
  end;
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsConnEdit.GetTestConnection: TADCustomConnection;
begin
  if (FConnection <> nil) and FConnection.Connected and not FModified then
    Result := FConnection
  else
    Result := GetTempConnection;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.Modified;
begin
  FModified := True;
  ReleaseTempConnection;
  if Assigned(FOnModified) then
    FOnModified(Self);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.LoadFormState(AIni: TCustomIniFile);
begin
  inherited LoadFormState(AIni);
  ptreeOptions.LoadState(Name, AIni);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.SaveFormState(AIni: TCustomIniFile);
begin
  inherited SaveFormState(AIni);
  ptreeOptions.SaveState(Name, AIni);
end;

{------------------------------------------------------------------------------}
// ConnDef page

procedure TfrmADGUIxFormsConnEdit.ResetConnectionDef;
begin
  GetEditor.Visible := False;
  FEdited.Clear;
  FillParamValues(True);
  FillParamGrids(True);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.ResetOpts;
var
  oOpts: IADStanOptions;
begin
  oOpts := TADOptionsContainer.Create(nil, TADFetchOptions, TADUpdateOptions,
    TADResourceOptions, nil);
  frmFetchOptions.LoadFrom(oOpts.FetchOptions);
  frmFormatOptions.LoadFrom(oOpts.FormatOptions);
  frmUpdateOptions.LoadFrom(oOpts.UpdateOptions);
  frmResourceOptions.LoadFrom(oOpts.ResourceOptions);
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsConnEdit.IsDriverKnown(const ADrvID: String;
  out ADrvMeta: IADPhysDriverMetadata): Boolean;
var
  i: Integer;
  oManMeta: IADPhysManagerMetadata;
begin
  Result := False;
  ADPhysManager.CreateMetadata(oManMeta);
  for i := 0 to oManMeta.DriverCount - 1 do
    if CompareText(oManMeta.DriverID[i], ADrvID) = 0 then begin
      oManMeta.CreateDriverMetadata(ADrvID, ADrvMeta);
      Result := True;
      Break;
    end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.GetDriverParams(const ADrvID: String;
  AStrs: TStrings);
var
  i, iLogin: Integer;
  sName, sType, sDefVal, sCaption: String;
  oDrvMeta: IADPhysDriverMetadata;
begin
  if IsDriverKnown(ADrvID, oDrvMeta) then
    for i := 0 to oDrvMeta.GetConnParamCount(AStrs) - 1 do begin
      oDrvMeta.GetConnParams(AStrs, i, sName, sType, sDefVal, sCaption, iLogin);
      AStrs.Add(sName + '=' + sDefVal);
    end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.GetConnectionDefParams(const AConnectionDefName: String;
  AStrs: TStrings);
var
  oConnectionDef: IADStanConnectionDef;
begin
  if FConnectionDef <> nil then
    oConnectionDef := FConnectionDef
  else
    oConnectionDef := ADManager.ConnectionDefs.ConnectionDefByName(AConnectionDefName);
  AStrs.AddStrings(oConnectionDef.Params);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.OverrideBy(AThis, AByThat: TStrings);
var
  i: Integer;
  sKey, sValue: String;
begin
  for i := 0 to AByThat.Count - 1 do begin
    sKey := AByThat.Names[i];
    sValue := AByThat.Values[sKey];
    AThis.Values[sKey] := sValue;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.FillParamValues(AAsIs: Boolean);
var
  oStrs: TADStringList;
begin
  oStrs := TADStringList.Create;
  try
    FDefaults.Clear;
    if FDriverID <> '' then
      GetDriverParams(FDriverID, FDefaults);
    if FConnectionDefName <> '' then begin
      GetConnectionDefParams(FConnectionDefName, oStrs);
      OverrideBy(FDefaults, oStrs);
    end;
    FResults.Assign(FDefaults);
    if (CompareText(FResults.Values[S_AD_DefinitionParam_Common_Name], FConnectionDefName) = 0) or
       (FConnectionDefName = '') then
      FResults.Values[S_AD_ConnParam_Common_DriverID] := FDriverID
    else
      FResults.Values[S_AD_DefinitionParam_Common_ConnectionDef] := FConnectionDefName;
    if not AAsIs then
      OverrideBy(FResults, FEdited);
  finally
    ADFree(oStrs);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.FillConnParams(AParams: TStrings);
var
  i, j: Integer;
  lChanged: Boolean;
  sKey, sVal: String;
begin
  AParams.Clear;
  if FConnectionDef <> nil then
    AParams.Assign(FEdited)
  else
    for i := 0 to FEdited.Count - 1 do begin
      sKey := FEdited.Names[i];
      sVal := FEdited.Values[sKey];
      lChanged := False;
      for j := 1 to sgParams.RowCount - 1 do
        if AnsiCompareText(sgParams.Cells[0, j], sKey) = 0 then begin
          lChanged := True;
          Break;
        end;
      if lChanged then
        lChanged := FDefaults.Values[sKey] <> sVal;
      if lChanged then
        AParams.Add(sKey + '=' + sVal);
    end;
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsConnEdit.GetGridWidth: Integer;
begin
  Result := sgParams.ClientWidth - GetSystemMetrics(SM_CXVSCROLL) - 5;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.FillParamGrids(AResetPosition: Boolean);
var
  oDrvMeta: IADPhysDriverMetadata;
  i, iLogin: Integer;
  sName, sType, sDefVal, sCaption: String;
begin
  if not IsDriverKnown(FDriverID, oDrvMeta) then
    sgParams.RowCount := 2
  else begin
    sgParams.RowCount := oDrvMeta.GetConnParamCount(FResults) + 1;
    for i := 0 to sgParams.RowCount - 2 do begin
      oDrvMeta.GetConnParams(FResults, i, sName, sType, sDefVal, sCaption, iLogin);
      sgParams.Cells[0, i + 1] := sName;
      sgParams.Cells[1, i + 1] := FResults.Values[sName];
      sgParams.Cells[2, i + 1] := sDefVal;
    end;
  end;
  sgParams.Cells[0, 0] := S_AD_ParParameter;
  sgParams.Cells[1, 0] := S_AD_ParValue;
  sgParams.Cells[2, 0] := S_AD_ParDefault;
  sgParams.FixedRows := 1;
  if AResetPosition then begin
    if sgParams.RowCount > 2 then
      sgParams.Row := 2
    else
      sgParams.Row := 1;
    sgParams.Col := 1;
  end;
end;

{------------------------------------------------------------------------------}
function TfrmADGUIxFormsConnEdit.GetEditor: TWinControl;
begin
  case FEditor of
  0:   Result := edtParams;
  1:   Result := cbParams;
  2:   Result := bedtParams;
  else Result := nil
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.AdjustEditor(ACtrl: TWinControl;
  ACol, ARow: Integer);
var
  R: TRect;
  oCtrl: __TWinControl;
begin
  oCtrl := __TWinControl(ACtrl);
  R := sgParams.CellRect(ACol, ARow);
  R.TopLeft := sgParams.Parent.ScreenToClient(sgParams.ClientToScreen(R.TopLeft));
  R.BottomRight := sgParams.Parent.ScreenToClient(sgParams.ClientToScreen(R.BottomRight));
  oCtrl.Left := R.Left;
  oCtrl.Top := R.Top;
  oCtrl.Width := R.Right - R.Left {$IFDEF AnyDAC_FPC} - 1 {$ENDIF};
  oCtrl.Text := sgParams.Cells[ACol, ARow];
  oCtrl.Visible := True;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.cbServerIDClick(Sender: TObject);
var
  s: String;
begin
  s := cbServerID.Text;
  if (s <> '') and ((FConnectionDef = nil) and (FConnectionDefName <> '') or (FDriverID <> s)) then begin
    if FConnectionDef = nil then
      FConnectionDefName := '';
    cbConnectionDefName.Text := '';
    FDriverID := s;
    FEdited.Clear;
    FillParamValues(True);
    FillParamGrids(True);
    GetEditor.Visible := False;
    Modified;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.cbConnectionDefNameClick(Sender: TObject);
var
  s: String;
begin
  s := cbConnectionDefName.Text;
  if (s <> '') and (FConnectionDefName <> s) then begin
    FConnectionDefName := s;
    FDriverID := ADManager.ConnectionDefs.ConnectionDefByName(s).DriverID;
    cbServerID.Text := '';
    FEdited.Clear;
    FillParamValues(True);
    FillParamGrids(True);
    GetEditor.Visible := False;
    Modified;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.sgParamsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  oDrvMeta: IADPhysDriverMetadata;
  iLogin: Integer;
  sName, sType, sDefVal, sCaption: String;
  iNewEditor: Integer;
begin
  if not cbServerID.Enabled then
    Exit;
  if (ACol = 1) and (ARow > 1) then begin
    if IsDriverKnown(FDriverID, oDrvMeta) then begin
      oDrvMeta.GetConnParams(FResults, ARow - 1, sName, sType, sDefVal, sCaption, iLogin);
      iNewEditor := ADGUIxSetupEditor(cbParams, edtParams, bedtParams, OpenDialog1, sType);
      if iNewEditor <> FEditor then begin
        case iNewEditor of
        0:
          begin
            edtParams.Visible := True;
            cbParams.Visible := False;
            bedtParams.Visible := False;
          end;
        1:
          begin
            edtParams.Visible := False;
            cbParams.Visible := True;
            bedtParams.Visible := False;
          end;
        2:
          begin
            edtParams.Visible := False;
            cbParams.Visible := False;
            bedtParams.Visible := True;
          end;
        end;
        FEditor := iNewEditor;
      end;
      AdjustEditor(GetEditor, ACol, ARow);
    end
    else
      GetEditor.Visible := False;
  end
  else
    GetEditor.Visible := False;
  CanSelect := True;
  if GetEditor.CanFocus and (not tsSQL.TabVisible or Visible) then
    GetEditor.SetFocus
  else
    GetEditor.Visible := False;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.sgParamsTopLeftChanged(Sender: TObject);
begin
  if GetEditor.Visible then
    AdjustEditor(GetEditor, sgParams.Col, sgParams.Row);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.sgParamsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F2) and GetEditor.Visible then begin
    GetEditor.BringToFront;
    GetEditor.SetFocus;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.sgParamsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  sgParamsTopLeftChanged(sgParams);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.FormResize(Sender: TObject);
var
  d: Double;
  iW0, iW1, iW2: Integer;
begin
  if not FLockResize and (GetGridWidth > 80) then begin
    if FLastGridWidth > 0 then begin
      d := GetGridWidth / FLastGridWidth;
      iW0 := Round(d * sgParams.ColWidths[0]);
      if iW0 < 20 then
        iW0 := 20;
      iW1 := Round(d * sgParams.ColWidths[1]);
      if iW1 < 20 then
        iW1 := 20;
      iW2 := Round(d * sgParams.ColWidths[2]);
      if iW2 < 20 then
        iW2 := 20;
      sgParams.ColWidths[0] := iW0;
      sgParams.ColWidths[1] := iW1;
      sgParams.ColWidths[2] := iW2;
      sgParamsMouseUp(nil, mbLeft, [], 0, 0);
    end;
    FLastGridWidth := GetGridWidth;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.sgParamsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  sKey, sValue: String;
  oGrid: TStringGrid;
  oCanvas: TCanvas;
  oFont: TFont;
begin
  if gdFocused in State then
    Exit;
  oGrid := TStringGrid(Sender);
  oCanvas := oGrid.Canvas;
  oFont := oCanvas.Font;
  if ((ACol = 0) or (ACol = 1)) and (ARow = 1) or
     (ACol = 2) and (ARow > 0) then begin
    oFont.Color := clBtnShadow;
    oFont.Style := oFont.Style + [fsItalic];
  end
  else if (ACol = 1) and (ARow > 0) then begin
    sKey := oGrid.Cells[0, ARow];
    sValue := oGrid.Cells[1, ARow];
    if FDefaults.Values[sKey] <> sValue then
      oCanvas.Brush.Color := clInfoBk;
    oFont.Color := clHotLight;
  end;
{$IFNDEF AnyDAC_FPC}
    if oCanvas.Brush.Color = clInfoBk then
{$ENDIF}
      oCanvas.FillRect(Rect);
    oCanvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 3, oGrid.Cells[ACol, ARow]);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.EditorExit(Sender: TObject);
var
  sKey, sVal: String;
  i: Integer;
begin
  sKey := sgParams.Cells[0, sgParams.Row];
  sVal := __TWinControl(GetEditor).Text;
  if sgParams.Cells[1, sgParams.Row] <> sVal then begin
    sgParams.Cells[1, sgParams.Row] := sVal;
    i := FEdited.IndexOfName(sKey);
    if i = -1 then
      i := FEdited.Add('');
    FEdited[i] := (sKey + '=' + sVal);
    FillParamValues(False);
    FillParamGrids(False);
    Modified;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.EditorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (GetEditor = cbParams) and cbParams.DroppedDown and (cbParams.Style <> csSimple) then
    Exit;
  if Key = VK_ESCAPE then begin
    AdjustEditor(GetEditor, sgParams.Col, sgParams.Row);
    case FEditor of
    0: edtParams.SelectAll;
    1: cbParams.SelectAll;
    2: bedtParams.SelectAll;
    end;
    Key := 0;
  end
  else if (Key = VK_RETURN) or (Key = VK_DOWN) and (Shift = []) then begin
    if sgParams.Row < sgParams.RowCount - 1 then begin
      EditorExit(nil);
      sgParams.Row := sgParams.Row + 1;
    end;
    Key := 0;
  end
  else if (Key = VK_UP) and (Shift = []) then begin
    if sgParams.Row > sgParams.FixedRows + 1 then begin
      EditorExit(nil);
      sgParams.Row := sgParams.Row - 1;
    end;
    Key := 0;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.cbParamsDblClick(Sender: TObject);
begin
  if cbParams.ItemIndex + 1 >= cbParams.Items.Count then
    cbParams.ItemIndex := 0
  else
    cbParams.ItemIndex := cbParams.ItemIndex + 1;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.bedtParamsRightButtonClick(
  Sender: TObject);
begin
  OpenDialog1.FileName := bedtParams.Text;
  if OpenDialog1.Execute then begin
    bedtParams.Text := OpenDialog1.FileName;
    EditorExit(nil);
    bedtParams.SetFocus;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.frmOptionsModified(Sender: TObject);
begin
  Modified;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.btnTestClick(Sender: TObject);
var
  oConn: TADCustomConnection;
  oDlg: TADGUIxLoginDialog;
begin
  oConn := GetTempConnection;
  oDlg := TADGUIxLoginDialog.Create(nil);
  try
    oDlg.HistoryEnabled := True;
    oDlg.VisibleItems.Text := '*';
    oConn.LoginDialog := oDlg;
    oConn.Close;
    oConn.Open;
    ShowMessage(S_AD_LoginDialogTestOk);
  finally
    ADFree(oDlg);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.btnWizardClick(Sender: TObject);
var
  oConn: TADCustomConnection;
  oDrv: IADPhysDriver;
  oWizard: IADPhysDriverConnectionWizard;
begin
  oConn := GetTempConnection;
  oConn.CheckConnectionDef;
  ADPhysManager.CreateDriver(oConn.ResultConnectionDef.DriverID, oDrv);
  oDrv.CreateConnectionWizard(oWizard);
  if oWizard = nil then
    MessageDlg(S_AD_WizardNotAccessible, mtWarning, [mbOK], -1)
  else if oWizard.Run(oConn.ResultConnectionDef) then begin
    FEdited.Assign(oConn.Params);
    FillParamValues(False);
    FillParamGrids(True);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.btnDefaultsClick(Sender: TObject);
begin
  ResetData;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.btnWikiClick(Sender: TObject);
const
  C_Prefix = C_AD_Docu_Link + 'Connect_to_';
  C_ADS = 'Advantage_Database_Server';
  C_DB2 = 'IBM_DB2_Server';
  C_IB = 'Interbase_or_Firebird';
  C_MSSQL = 'Microsoft_SQL_Server';
  C_MSAcc = 'Microsoft_Access_database';
  C_MySQL = 'MySQL_Server';
  C_Ora = 'Oracle_Server';
  C_PG = 'PostgreSQL';
  C_SQLite = 'SQLite_database';
  C_ASA = 'Sybase_SQL_Anywhere';
  C_DBX = 'dbExpress_data_source';
  C_ODBC = 'ODBC_data_source';
  C_DataSnap = 'DataSnap_server';
  C_Suff = '.html';
var
  sLink, sId: String;
begin
  sId := ADManager.GetBaseDriverID(FDriverID);
  if CompareText(sId, S_AD_ADSId) = 0 then
    sLink := C_ADS
  else if CompareText(sId, S_AD_DB2Id) = 0 then
    sLink := C_DB2
  else if CompareText(sId, S_AD_IBId) = 0 then
    sLink := C_IB
  else if CompareText(sId, S_AD_MSSQLId) = 0 then
    sLink := C_MSSQL
  else if CompareText(sId, S_AD_MSAccId) = 0 then
    sLink := C_MSAcc
  else if CompareText(sId, S_AD_MySQLId) = 0 then
    sLink := C_MySQL
  else if CompareText(sId, S_AD_OraId) = 0 then
    sLink := C_Ora
  else if CompareText(sId, S_AD_ASAId) = 0 then
    sLink := C_ASA
  else if (CompareText(sId, S_AD_DBXId) = 0) or
          (CompareText(sId, S_AD_TDBXId) = 0) then
    sLink := C_DBX
  else if CompareText(sId, S_AD_ODBCId) = 0 then
    sLink := C_ODBC
  else if CompareText(sId, S_AD_PGId) = 0 then
    sLink := C_PG
  else if CompareText(sId, S_AD_SQLiteId) = 0 then
    sLink := C_SQLite
  else if CompareText(sId, S_AD_DataSnapId) = 0 then
    sLink := C_DataSnap
  else begin
    ShowMessage('Information for the [' + sId + '] driver is not accessible');
    Exit;
  end;
  ADShell(C_Prefix + sLink + C_Suff, S_AD_LComp_Design);
end;

{------------------------------------------------------------------------------}
// Info page

procedure TfrmADGUIxFormsConnEdit.FillConnectionInfo(AConnection: TADCustomConnection;
  ATryToConnect: Boolean);
var
  eItems: TADInfoReportItems;
var
  oConn: TADCustomConnection;
begin
  if AConnection = nil then
    oConn := GetTestConnection
  else begin
    oConn := AConnection;
    ATryToConnect := False;
  end;
  eItems := [riConnDef .. riKeepConnected];
  if not ATryToConnect then
    eItems := eItems - [riTryConnect, riKeepConnected];
  oConn.GetInfoReport(mmInfo.Lines, eItems);
end;

{------------------------------------------------------------------------------}
// SQL page

procedure TfrmADGUIxFormsConnEdit.mmScriptKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  scrEngineBeforeExecute(nil);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.mmScriptMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  scrEngineBeforeExecute(nil);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.scrEngineBeforeExecute(Sender: TObject);
begin
{$IFDEF AnyDAC_Unicode}
  scrEngine.SQLScripts[0].SQL.Text := mmScript.Lines.Text;
{$ELSE}
  scrEngine.SQLScripts[0].SQL := mmScript.Lines;
{$ENDIF}
  scrEngine.Position := mmScript.CaretPos;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.scrEngineAfterExecute(Sender: TObject);
begin
  if not scrEngine.Eof then
    mmScript.CaretPos := scrEngine.Position
  else
    mmScript.SelStart := mmScript.GetTextLen;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.scrEngineConsoleGet(AEngine: TADScript;
  const APrompt: string; var AResult: string);
begin
  InputQuery('Enter value', APrompt, AResult);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.scrEngineConsoleLockUpdate(AEngine: TADScript;
  ALock: Boolean);
begin
  if ALock then
    mmLog.Lines.BeginUpdate
  else
    mmLog.Lines.EndUpdate;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.scrEngineConsolePut(AEngine: TADScript;
  const AMessage: string; AKind: TADScriptOuputKind);
var
  i: Integer;
begin
  if AEngine.CurrentCommand <> nil then
    i := AEngine.CurrentCommand.Position.Y
  else
    i := -1;
  mmLog.Lines.AddObject(AMessage, {$IFDEF AUTOREFCOUNT} TADValWrapper.Create(i) {$ELSE}
                                                        TObject(i) {$ENDIF});
  Application.ProcessMessages;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.scrEnginePause(AEngine: TADScript;
  const AText: string);
begin
  ShowMessage(AText + #13#10'Press OK to continue script execution');
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.mmLogDblClick(Sender: TObject);
var
  i: Integer;
  o: TObject;
begin
  if (mmLog.CaretPos.Y >= 0) and (mmLog.CaretPos.Y < mmLog.Lines.Count) then begin
    o := mmLog.Lines.Objects[mmLog.CaretPos.Y];
    i := {$IFDEF AUTOREFCOUNT} TADValWrapper(o).AsInt {$ELSE} LongWord(o) {$ENDIF};
    if i >= 0 then
      mmScript.CaretPos := Point(0, i);
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.acRunUpdate(Sender: TObject);
begin
  acRun.Enabled := (scrEngine.Connection <> nil) and not scrEngine.IsEmpty;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.acRunExecute(Sender: TObject);
begin
  mmScript.CaretPos := Point(0, 0);
  scrEngine.ValidateAll;
  if scrEngine.Status = ssFinishSuccess then
    scrEngine.ExecuteAll;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.acRunByStepUpdate(Sender: TObject);
begin
  acRunByStep.Enabled := (scrEngine.Connection <> nil) and not scrEngine.Eof;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.acRunByStepExecute(Sender: TObject);
var
  rPos: TPoint;
begin
  rPos := mmScript.CaretPos;
  scrEngine.ExecuteStep;
  if scrEngine.TotalErrors <> 0 then
    mmScript.CaretPos := rPos;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.acSkipStepUpdate(Sender: TObject);
begin
  acSkipStep.Enabled := not scrEngine.Eof;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.acSkipStepExecute(Sender: TObject);
begin
  scrEngine.ValidateStep;
end;

{------------------------------------------------------------------------------}
// TADConnection editor

class function TfrmADGUIxFormsConnEdit.Execute(AConn: TADCustomConnection;
  const ACaption: String;
  const ACustomFrmADGUIxFormsConnEdit: TfrmADGUIxFormsConnEdit = nil): Boolean;
var
  oFrm: TfrmADGUIxFormsConnEdit;
  lFreeFrm: boolean;
begin
  lFreeFrm := False;
  if ACustomFrmADGUIxFormsConnEdit <> nil then
    oFrm := ACustomFrmADGUIxFormsConnEdit
  else begin
    oFrm := TfrmADGUIxFormsConnEdit.Create(nil);
    lFreeFrm := True;
  end;
  try
    oFrm.LoadState;
    oFrm.FConnection := AConn;
    oFrm.Caption := Format(S_AD_ConnEditCaption, [ACaption]);
    ADManager.GetDriverNames(oFrm.cbServerID.Items);
    ADManager.GetConnectionDefNames(oFrm.cbConnectionDefName.Items);
    if AConn.ConnectionDefName <> '' then begin
      oFrm.cbConnectionDefName.Text := AConn.ConnectionDefName;
      oFrm.FConnectionDefName := AConn.ConnectionDefName;
      try
        oFrm.FDriverID := ADManager.ConnectionDefs.ConnectionDefByName(
          AConn.ConnectionDefName).DriverID;
      except
        Application.HandleException(nil);
        oFrm.cbConnectionDefName.Text := '';
        oFrm.FConnectionDefName := '';
      end;
    end
    else if AConn.DriverName <> '' then begin
      oFrm.cbServerID.Text := AConn.DriverName;
      oFrm.FDriverID := AConn.DriverName;
    end;
    oFrm.FEdited.Assign(AConn.Params);
    oFrm.FillParamValues(False);
    oFrm.FillParamGrids(True);
    oFrm.frmFetchOptions.LoadFrom(AConn.FetchOptions);
    oFrm.frmFormatOptions.LoadFrom(AConn.FormatOptions);
    oFrm.frmUpdateOptions.LoadFrom(AConn.UpdateOptions);
    oFrm.frmResourceOptions.LoadFrom(AConn.ResourceOptions);
    Result := (oFrm.ShowModal = mrOK);
    if Result then
      oFrm.SetConnectionParams(AConn);
    oFrm.SaveState;
  finally
    if lFreeFrm then
      ADFree(oFrm);
  end;
end;

{------------------------------------------------------------------------------}
class function TfrmADGUIxFormsConnEdit.Execute(var AConnStr: String;
  const ACaption: String;
  const ACustomFrmADGUIxFormsConnEdit: TfrmADGUIxFormsConnEdit = nil): Boolean;
var
  oConn: TADCustomConnection;
begin
  oConn := TADCustomConnection.Create(nil);
  try
    oConn.ResultConnectionDef.ParseString(AConnStr);
    Result := Execute(oConn, ACaption, ACustomFrmADGUIxFormsConnEdit);
    if Result then
      AConnStr := oConn.ResultConnectionDef.BuildString();
  finally
    ADFree(oConn);
  end;
end;

{------------------------------------------------------------------------------}
// ConnectionDef editor

constructor TfrmADGUIxFormsConnEdit.CreateForConnectionDefEditor;
const
  C_TitleHeight = 27;
begin
  inherited Create(nil);
  BorderStyle := bsNone;
  sgParams.Top := sgParams.Top - (pnlTitle.Height - C_TitleHeight);
  sgParams.Height := sgParams.Height + (pnlTitle.Height - C_TitleHeight);
  sgParams.Color := clBtnFace;
  pnlTitle.Height := C_TitleHeight;
  Label2.Visible := False;
  cbConnectionDefName.Visible := False;
  cbServerID.Left := cbServerID.Left + 5;
  pnlButtons.Visible := False;
  btnDefaults.Visible := False;
  btnTest.Visible := False;
  btnWizard.Visible := False;
  btnWiki.Visible := False;
  FLockResize := True;
{$IFDEF AnyDAC_D6Base}
  ActionList1.State := asSuspended;
{$ENDIF}
  tsSQL.TabVisible := False;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.LoadData(AConnectionDef: IADStanConnectionDef);
begin
  FConnectionDef := AConnectionDef;
  ADManager.GetDriverNames(cbServerID.Items);
  FConnectionDefName := AConnectionDef.Name;
  cbServerID.Text := AConnectionDef.DriverID;
  FDriverID := AConnectionDef.DriverID;
  FEdited.Assign(AConnectionDef.Params);
  FillParamValues(False);
  FillParamGrids(True);
  FOptions := TADOptionsContainer.Create(nil, TADFetchOptions, TADUpdateOptions,
    TADTopResourceOptions, nil);
  AConnectionDef.ReadOptions(FOptions.FormatOptions, FOptions.UpdateOptions,
    FOptions.FetchOptions, FOptions.ResourceOptions);
  frmFetchOptions.LoadFrom(FOptions.FetchOptions);
  frmFormatOptions.LoadFrom(FOptions.FormatOptions);
  frmUpdateOptions.LoadFrom(FOptions.UpdateOptions);
  frmResourceOptions.LoadFrom(FOptions.ResourceOptions);
  FLockResize := False;
  FModified := False;
  ReleaseTempConnection;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.PostChanges;
begin
  if GetEditor.Visible then
    EditorExit(nil);
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.SaveData;
begin
  frmFetchOptions.SaveTo(FOptions.FetchOptions);
  frmFormatOptions.SaveTo(FOptions.FormatOptions);
  frmUpdateOptions.SaveTo(FOptions.UpdateOptions);
  frmResourceOptions.SaveTo(FOptions.ResourceOptions);

  FillConnParams(FConnectionDef.Params);
  FConnectionDef.Name := FConnectionDefName;
  FConnectionDef.DriverID := FDriverID;
  FConnectionDef.WriteOptions(FOptions.FormatOptions, FOptions.UpdateOptions,
    FOptions.FetchOptions, FOptions.ResourceOptions);
  FModified := False;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.ResetState(AClear: Boolean);
begin
  GetEditor.Visible := False;
  if AClear then
    FConnectionDef := nil;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.ResetData;
begin
  ResetOpts;
  ResetConnectionDef;
  Modified;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.ResetPage;
begin
  if pcMain.ActivePage = tsConnection then begin
    ResetConnectionDef;
    Modified;
  end
  else if pcMain.ActivePage = tsOptions then begin
    ResetOpts;
    Modified;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.SetReadOnly(AValue: Boolean);
begin
  if AValue then begin
    sgParams.Font.Color := clGray;
    Label1.Enabled := False;
    cbServerID.Enabled := False;
    tsOptions.Enabled := False;
    ptreeOptions.Enabled := False;
    GetEditor.Visible := False;
  end
  else begin
    sgParams.Font.Color := clWindowText;
    Label1.Enabled := True;
    cbServerID.Enabled := True;
    tsOptions.Enabled := True;
    ptreeOptions.Enabled := True;
  end;
end;

{------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsConnEdit.TestConnection;
begin
  btnTestClick(nil);
end;

{$IFDEF AnyDAC_FPC}
initialization
  {$I uADGUIxFormsfConnEdit.lrs}
{$ENDIF}

end.
