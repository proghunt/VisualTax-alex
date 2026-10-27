{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC script processing form             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFormsfScript"'}

unit uADGUIxFormsfScript;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
    ComCtrls, ImgList,
  uADStanIntf,
  uADGUIxIntf, uADGUIxFormsfOptsBase, uADGUIxFormsControls;

type
  TfrmADGUIxFormsfScript = class(TfrmADGUIxFormsOptsBase)
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

var
  frmADGUIxFormsfScript: TfrmADGUIxFormsfScript;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

uses
{$IFDEF AnyDAC_D17}
  System.UITypes,
{$ENDIF}
  uADStanConst, uADStanFactory, uADStanResStrs, uADStanUtil,
  uADGUIxManager;

{-------------------------------------------------------------------------------}
{ TfrmADGUIxFormsfScript                                                        }
{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.Show;
var
  iDeltaH, iPrcLocH, iPrcOutH: Integer;
begin
  btnCancel.Caption := '&Cancel';
  Timer1.Enabled := False;
  tvPrcLocation.Items.Clear;
  lbPrcOutput.Items.Clear;
  pbPrcMain.Position := 0;
  FIsRunning := False;
  FRequestStop := False;
  iDeltaH := 0;
  iPrcLocH := pnlPrcLocation.Height;
  iPrcOutH := pnlPrcOutput.Height;
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
    ADGUIxCancel;
    FModalData := ADGUIxBeginModal(Self);
    inherited Show;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.Output(const AStr: String);
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
    i := lbPrcOutput.Items.Count - lbPrcOutput.Height div lbPrcOutput.ItemHeight - 1;
    if i < 0 then
      i := 0;
    lbPrcOutput.TopIndex := i;
  end;
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.Input(const APrompt: String; var AResult: String);
begin
  if APrompt <> '' then
    Output(APrompt);
  AResult := InputBox('SQL Script', APrompt, AResult);
  Output(AResult);
  Output('');
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.Pause(const APrompt: String);
var
  s: String;
begin
  s := APrompt;
  if s <> '' then
    Output(s)
  else
    s := 'Press OK to continue';
  MessageBox(0, PChar(s), PChar('SQL Script'), MB_OK);
  Output('');
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.Progress(const AInfoProvider: IADGUIxScriptDialogInfoProvider);
var
  oItem: TTreeNode;
  i: Integer;
begin
  if not Visible then
    Exit;
  FIsRunning := AInfoProvider.IsRunning;
  pbPrcMain.Position := AInfoProvider.TotalPct10Done;
  if pnlPrcLocation.Visible then begin
    tvPrcLocation.Items.BeginUpdate;
    try
      tvPrcLocation.Items.Clear;
      oItem := nil;
      for i := 0 to AInfoProvider.CallStack.Count - 1 do
        oItem := tvPrcLocation.Items.AddChild(oItem, AInfoProvider.CallStack[i]);
      if oItem <> nil then begin
        oItem.Selected := True;
        oItem.Focused := True;
        oItem.MakeVisible;
      end;
    finally
      tvPrcLocation.Items.EndUpdate;
    end;
  end;
  if AInfoProvider.TotalJobSize <= 0 then
    lblTotalSize.Caption := '<unknown>'
  else if AInfoProvider.TotalJobSize < 1000 then
    lblTotalSize.Caption := Format('%d bytes', [AInfoProvider.TotalJobSize])
  else if AInfoProvider.TotalJobSize < 1000000 then
    lblTotalSize.Caption := FormatFloat('0.000 Kb', AInfoProvider.TotalJobSize / 1000)
  else
    lblTotalSize.Caption := FormatFloat('0.000 Mb', AInfoProvider.TotalJobSize / 1000000);
  if AInfoProvider.TotalJobDone < 1000 then
    lblTotalDone.Caption := Format('%d bytes', [AInfoProvider.TotalJobDone])
  else if AInfoProvider.TotalJobDone < 1000000 then
    lblTotalDone.Caption := FormatFloat('0.000 Kb', AInfoProvider.TotalJobDone / 1000)
  else
    lblTotalDone.Caption := FormatFloat('0.000 Mb', AInfoProvider.TotalJobDone / 1000000);
  if AInfoProvider.TotalJobSize <= 0 then
    lblTotalPctDone.Caption := '<unknown>'
  else
    lblTotalPctDone.Caption := FormatFloat('0.0 %', AInfoProvider.TotalPct10Done / 10);
  lblTotalErrors.Caption := Format('%d', [AInfoProvider.TotalErrors]);
  if FRequestStop then
    AInfoProvider.RequestStop;
  if Assigned(FOnProgress) then
    FOnProgress(Self, AInfoProvider);
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.InternalHide(AImmediately: Boolean);
begin
  if not Visible then
    Exit;
  if not AImmediately then
    Timer1.Enabled := True
  else begin
    tvPrcLocation.Items.Clear;
    lbPrcOutput.Items.Clear;
    pbPrcMain.Position := 0;
    inherited Hide;
    ADGUIxEndModal(FModalData);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.Hide;
begin
  if ssAutoHide in FOptions then
    InternalHide(False)
  else
    btnCancel.Caption := '&Hide';
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.btnCancelClick(Sender: TObject);
begin
  if FIsRunning and not FRequestStop then begin
    if MessageDlg('Do you really want to cancel script execution ?',
                  mtConfirmation, [mbYes, mbNo], -1) = mrYes then
      FRequestStop := True;
  end
  else if not FIsRunning then
    InternalHide(True);
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsfScript.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  InternalHide(True);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxFormsScriptImpl                                                        }
{-------------------------------------------------------------------------------}
type
  TADGUIxFormsScriptImpl = class(TADGUIxVisualScriptImplBase)
  private
    FForm: TfrmADGUIxFormsfScript;
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
destructor TADGUIxFormsScriptImpl.Destroy;
begin
  ADFreeAndNil(FForm);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsScriptImpl.Show;
begin
  if ADGUIxSilent() then
    Exit;
  if FForm = nil then
    FForm := TfrmADGUIxFormsfScript.Create(nil);
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
procedure TADGUIxFormsScriptImpl.Progress(
  const AInfoProvider: IADGUIxScriptDialogInfoProvider);
begin
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Progress(AInfoProvider);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsScriptImpl.Output(const AStr: String; AKind: TADScriptOuputKind);
begin
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Output(AStr);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsScriptImpl.Input(const APrompt: String;
  var AResult: String);
begin
  AResult := '';
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Input(APrompt, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsScriptImpl.Pause(const APrompt: String);
begin
  if ADGUIxSilent() or (FForm = nil) then
    Exit;
  FForm.Pause(APrompt);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsScriptImpl.Hide;
begin
  if (FForm <> nil) and FForm.Visible then
    FForm.Hide;
  Application.ProcessMessages;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
{$IFDEF AnyDAC_FPC}
  {$I uADGUIxFormsfScript.lrs}
{$ENDIF}
  oFact := TADMultyInstanceFactory.Create(TADGUIxFormsScriptImpl,
    IADGUIxScriptDialog, C_AD_GUIxFormsProvider, 'uADGUIxFormsfScript');
{$IFDEF AnyDAC_FMX}
  oFact.AddFriend(C_AD_GUIxFMXProvider + '=uADGUIxFMXfScript');
{$ENDIF}
  oFact.AddFriend(C_AD_GUIxConsoleProvider + '=uADGUIxConsoleScript');

finalization
  ADReleaseFactory(oFact);

end.
