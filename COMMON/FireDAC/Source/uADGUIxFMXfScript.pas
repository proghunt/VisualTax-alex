{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{       FireDAC FireMonkey script processing form       }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFMXfScript"'}

unit uADGUIxFMXfScript;

interface

uses
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, 
{$IFDEF AnyDAC_FPC}
  FMX_Controls, FMX_Forms, FMX_Types, FMX_ListBox, FMX_Layouts, FMX_TreeView, 
    FMX_Objects,
{$ELSE}
  FMX.Controls, FMX.Forms, FMX.Types, FMX.ListBox, FMX.Layouts, FMX.TreeView, 
    FMX.Objects,
  {$IFDEF AnyDAC_D18}
    FMX.StdCtrls,
  {$ENDIF}
{$ENDIF}
  uADStanIntf,
  uADGUIxIntf, uADGUIxFMXfOptsBase;

type
  TfrmADGUIxFMXfScript = class(TfrmADGUIxFMXOptsBase)
    pnlPrcLocation: TPanel;
    tvPrcLocation: TTreeView;
    pbPrcMain: TProgressBar;
    Label1: TLabel;
    lblTotalSize: TLabel;
    Label3: TLabel;
    lblTotalDone: TLabel;
    Label5: TLabel;
    lblTotalPctDone: TLabel;
    Label2: TLabel;
    lblTotalErrors: TLabel;
    Timer1: TTimer;
    pnlPrcOutput: TPanel;
    lbPrcOutput: TListBox;
    procedure btnCancelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FModalData: Pointer;
    FIsRunning: Boolean;
    FRequestStop: Boolean;
    procedure InternalHide(AImmediately: Boolean);
  protected
    FOnProgress: TADGUIxScriptProgressEvent;
    FOnOutput: TADGUIxScriptOutputEvent;
    FOnInput: TADGUIxScriptInputEvent;
    FOnPause: TADGUIxScriptPauseEvent;
    FOptions: TADGUIxScriptOptions;
    // IADGUIxScriptDialog
    procedure Show;
    procedure Progress(const AInfoProvider: IADGUIxScriptDialogInfoProvider);
    procedure Output(const AStr: String);
    procedure Input(const APrompt: String; var AResult: String);
    procedure Pause(const APrompt: String);
    procedure Hide;
  end;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.fmx}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  UITypes, 
{$IFDEF AnyDAC_FPC}
  FMX_Dialogs,
{$ELSE}
  FMX.Dialogs,
{$ENDIF}
  uADStanConst, uADStanFactory, uADStanResStrs, uADStanUtil,
  uADGUIxManager;

{-------------------------------------------------------------------------------}
{ TfrmADGUIxFormsfScript                                                        }
{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.Show;
var
  iDeltaH, iPrcLocH, iPrcOutH: Integer;
begin
  btnCancel.Text := 'Cancel';
  Timer1.Enabled := False;
  tvPrcLocation.Clear;
  lbPrcOutput.Clear;
  pbPrcMain.Value := 0;
  FIsRunning := False;
  FRequestStop := False;
  iDeltaH := 0;
  iPrcLocH := Trunc(pnlPrcLocation.Height);
  iPrcOutH := Trunc(pnlPrcOutput.Height);
  if ssCallstack in FOptions then begin
    if not pnlPrcLocation.Visible then begin
      pnlPrcLocation.Visible := True;
      iDeltaH := iPrcLocH;
    end;
  end
  else begin
    if pnlPrcLocation.Visible then begin
      iDeltaH := - iPrcLocH;
      pnlPrcLocation.Visible := False;
    end;
  end;
  if ssConsole in FOptions then begin
    if not pnlPrcOutput.Visible then begin
      pnlPrcOutput.Visible := True;
      iDeltaH := iDeltaH + iPrcOutH;
    end;
  end
  else begin
    if pnlPrcOutput.Visible then begin
      iDeltaH := iDeltaH - iPrcOutH;
      pnlPrcOutput.Visible := False;
    end;
  end;
  Height := Height + iDeltaH;
  if not Visible then begin
    ADGUIxFMXCancel;
    FModalData := ADGUIxFMXBeginModal(Self);
    inherited Show;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.Output(const AStr: String);
var
  i: Integer;
  lOnLastItem: Boolean;
  s: String;
begin
  if not Visible or not pnlPrcOutput.Visible then
    Exit;
  lOnLastItem := lbPrcOutput.ItemIndex = lbPrcOutput.Items.Count - 1;
  s := AStr;
  for i := 1 to Length(s) do
    if ADInSet(s[i], [#13, #10, #9]) then
      s[i] := ' ';
  lbPrcOutput.Items.Add(s);
  if lOnLastItem then begin
    lbPrcOutput.ItemIndex := lbPrcOutput.Items.Count - 1;
    i := lbPrcOutput.Items.Count -
      Trunc(lbPrcOutput.Height / lbPrcOutput.ItemHeight) - 1;
    if i < 0 then
      i := 0;
    lbPrcOutput.ItemIndex := i;
  end;
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.Input(const APrompt: String; var AResult: String);
begin
{$IFNDEF AnyDAC_FPC}
  if APrompt <> '' then
    Output(APrompt);
  AResult := InputBox('SQL Script', APrompt, AResult);
  Output(AResult);
  Output('');
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.Pause(const APrompt: String);
var
  s: String;
begin
  s := APrompt;
  if s <> '' then
    Output(s)
  else
    s := 'Press OK to continue';
  ShowMessage('SQL Script paused.' + C_AD_EOL + s);
  Output('');
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.Progress(const AInfoProvider: IADGUIxScriptDialogInfoProvider);
var
  oItem, oParent: TTreeViewItem;
  i: Integer;
begin
  if not Visible then
    Exit;
  FIsRunning := AInfoProvider.IsRunning;
  pbPrcMain.Value := AInfoProvider.TotalPct10Done;
  if pnlPrcLocation.Visible then begin
    tvPrcLocation.Clear;
    oItem := nil;
    oParent := nil;
    for i := 0 to AInfoProvider.CallStack.Count - 1 do begin
      oItem := TTreeViewItem.Create(Self);
      if oParent = nil then
        oItem.Parent := tvPrcLocation
      else
        oItem.Parent := oParent;
      oItem.Text := AInfoProvider.CallStack[i];
      oParent := oItem;
    end;
    if oItem <> nil then
      oItem.IsSelected := True;
  end;
  if AInfoProvider.TotalJobSize <= 0 then
    lblTotalSize.Text := '<unknown>'
  else if AInfoProvider.TotalJobSize < 1000 then
    lblTotalSize.Text := Format('%d bytes', [AInfoProvider.TotalJobSize])
  else if AInfoProvider.TotalJobSize < 1000000 then
    lblTotalSize.Text := FormatFloat('0.000 Kb', AInfoProvider.TotalJobSize / 1000)
  else
    lblTotalSize.Text := FormatFloat('0.000 Mb', AInfoProvider.TotalJobSize / 1000000);
  if AInfoProvider.TotalJobDone < 1000 then
    lblTotalDone.Text := Format('%d bytes', [AInfoProvider.TotalJobDone])
  else if AInfoProvider.TotalJobDone < 1000000 then
    lblTotalDone.Text := FormatFloat('0.000 Kb', AInfoProvider.TotalJobDone / 1000)
  else
    lblTotalDone.Text := FormatFloat('0.000 Mb', AInfoProvider.TotalJobDone / 1000000);
  if AInfoProvider.TotalJobSize <= 0 then
    lblTotalPctDone.Text := '<unknown>'
  else
    lblTotalPctDone.Text := FormatFloat('0.0 %', AInfoProvider.TotalPct10Done / 10);
  lblTotalErrors.Text := Format('%d', [AInfoProvider.TotalErrors]);
  if FRequestStop then
    AInfoProvider.RequestStop;
  if Assigned(FOnProgress) then
    FOnProgress(Self, AInfoProvider);
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.InternalHide(AImmediately: Boolean);
begin
  if not Visible then
    Exit;
  if not AImmediately then
    Timer1.Enabled := True
  else begin
    tvPrcLocation.Clear;
    lbPrcOutput.Items.Clear;
    pbPrcMain.Value := 0;
    inherited Hide;
    ADGUIxFMXEndModal(FModalData);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.Hide;
begin
  if ssAutoHide in FOptions then
    InternalHide(False)
  else
    btnCancel.Text := '&Hide';
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.btnCancelClick(Sender: TObject);
begin
  if FIsRunning and not FRequestStop then begin
    if MessageDlg('Do you really want to cancel script execution ?',
                  TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes,
                  TMsgDlgBtn.mbNo], -1) = mrYes then
      FRequestStop := True;
  end
  else if not FIsRunning then
    InternalHide(True);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXfScript.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  InternalHide(True);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFMXScriptImpl                                                          }
{-------------------------------------------------------------------------------}
type
  TADGUIxFMXScriptImpl = class(TADGUIxVisualScriptImplBase)
  private
    FForm: TfrmADGUIxFMXfScript;
  protected
    // IADGUIxScriptDialog
    procedure Show; override;
    procedure Progress(const AInfoProvider: IADGUIxScriptDialogInfoProvider); override;
    procedure Output(const AStr: String; AKind: TADScriptOuputKind); override;
    procedure Input(const APrompt: String; var AResult: String); override;
    procedure Pause(const APrompt: String); override;
    procedure Hide; override;
  public
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFMXScriptImpl.Destroy;
begin
  ADFreeAndNil(FForm);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXScriptImpl.Show;
begin
  if ADGUIxSilent() then
    Exit;
  if FForm = nil then
    FForm := TfrmADGUIxFMXfScript.Create(nil);
  FForm.OnShow := FOnShow;
  FForm.OnHide := FOnHide;
  FForm.FOnProgress := FOnProgress;
  FForm.FOnOutput := FOnOutput;
  FForm.FOnInput := FOnInput;
  FForm.FOnPause := FOnPause;
  FForm.FOptions := FOptions;
  FForm.Caption := FCaption;
  FForm.Show;
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXScriptImpl.Progress(
  const AInfoProvider: IADGUIxScriptDialogInfoProvider);
begin
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Progress(AInfoProvider);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXScriptImpl.Output(const AStr: String; AKind: TADScriptOuputKind);
begin
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Output(AStr);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXScriptImpl.Input(const APrompt: String;
  var AResult: String);
begin
  AResult := '';
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Input(APrompt, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXScriptImpl.Pause(const APrompt: String);
begin
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Pause(APrompt);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXScriptImpl.Hide;
begin
  if (FForm <> nil) and FForm.Visible then
    FForm.Hide;
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADMultyInstanceFactory.Create(TADGUIxFMXScriptImpl,
    IADGUIxScriptDialog, C_AD_GUIxFMXProvider, 'uADGUIxFMXfScript');

finalization
  ADReleaseFactory(oFact);

end.
