{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC async notify form               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFormsfAsync"'}

unit uADGUIxFormsfAsync;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, Buttons, StdCtrls,
  uADStanIntf,
  uADGUIxIntf, uADGUIxFormsfOptsBase;

type
  TfrmADGUIxFormsAsyncExecute = class(TfrmADGUIxFormsOptsBase)
    tmrDelay: TTimer;
    btnCancel2: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure tmrDelayTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FExecutor: IADStanAsyncExecutor;
    FRequestShow: Boolean;
    FModalData: Pointer;
    FShowDelay, FHideDelay: Integer;
  protected
    // IADGUIxAsyncExecuteDialog
    procedure Show(const AExecutor: IADStanAsyncExecutor);
    procedure Hide;
{$IFDEF MSWINDOWS}
    function IsFormActive: Boolean;
    function IsFormMouseMessage(const AMsg: TMsg): Boolean;
{$ENDIF}
  end;

var
  frmADGUIxFormsAsyncExecute: TfrmADGUIxFormsAsyncExecute;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

uses
{$IFDEF AnyDAC_FPC}
  RTLConsts,
{$ELSE}
  Consts,
{$ENDIF}
  uADStanConst, uADStanFactory, uADStanResStrs, uADStanUtil,
  uADGUIxManager, uADGUIxFormsControls;

{-------------------------------------------------------------------------------}
{ TfrmADGUIxFormsAsyncExecute                                                   }
{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.FormCreate(Sender: TObject);
begin
  Caption := S_AD_AsyncDialogDefCaption;
  lblPrompt.Caption := S_AD_AsyncDialogDefPrompt;
  FShowDelay := C_AD_DelayBeforeFWait;
  FHideDelay := C_AD_DelayBeforeFWait;
  btnCancel2.Caption := '&' + SCancelButton;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.FormDestroy(Sender: TObject);
begin
  if frmADGUIxFormsAsyncExecute = Self then
    frmADGUIxFormsAsyncExecute := nil;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    btnCancelClick(nil);
    Key := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.btnCancelClick(Sender: TObject);
begin
  if (FExecutor <> nil) and FExecutor.Operation.AbortSupported then
    FExecutor.AbortJob;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.tmrDelayTimer(Sender: TObject);
begin
  if (FRequestShow <> Visible) and not (csDestroying in ComponentState) then begin
    ADGUIxCancel;
    if FRequestShow then begin
      FModalData := ADGUIxBeginModal(Self, False);
      inherited Show;
    end
    else begin
      if FModalData <> nil then
        ADGUIxEndModal(FModalData);
      inherited Hide;
    end;
    tmrDelay.Enabled := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.Show(const AExecutor: IADStanAsyncExecutor);
begin
  FExecutor := AExecutor;
  if not FRequestShow then begin
    FRequestShow := True;
    btnCancel2.Visible := AExecutor.Operation.AbortSupported;
    tmrDelay.Interval := FShowDelay;
    tmrDelay.Enabled := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFormsAsyncExecute.Hide;
begin
  if FRequestShow then begin
    FRequestShow := False;
    FExecutor := nil;
    tmrDelay.Interval := FHideDelay;
    tmrDelay.Enabled := True;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF MSWINDOWS}
function TfrmADGUIxFormsAsyncExecute.IsFormActive: Boolean;
begin
  Result := Screen.ActiveForm = Self;
end;

{-------------------------------------------------------------------------------}
function TfrmADGUIxFormsAsyncExecute.IsFormMouseMessage(const AMsg: TMsg): Boolean;
var
  oCtrl: TControl;
begin
  oCtrl := FindControl(AMsg.hwnd);
  if oCtrl <> nil then
    Result := (GetParentForm(oCtrl) = Self)
  else
    Result := False;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADGUIxFormsAsyncExecuteImpl                                                  }
{-------------------------------------------------------------------------------}
type
  TADGUIxFormsAsyncExecuteImpl = class(TADGUIxObject, IADGUIxAsyncExecuteDialog)
  private
    function GetForm: TfrmADGUIxFormsAsyncExecute;
  protected
    // IADGUIxAsyncExecuteDialog
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function GetPrompt: String;
    procedure SetPrompt(const AValue: String);
    function GetShowDelay: Integer;
    procedure SetShowDelay(AValue: Integer);
    function GetHideDelay: Integer;
    procedure SetHideDelay(AValue: Integer);
    procedure Show(const AExecutor: IADStanAsyncExecutor);
    procedure Hide;
{$IFDEF MSWINDOWS}
    function IsFormActive: Boolean;
    function IsFormMouseMessage(const AMsg: TMsg): Boolean;
{$ENDIF}
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.Initialize;
begin
  inherited Initialize;
  frmADGUIxFormsAsyncExecute := nil;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFormsAsyncExecuteImpl.Destroy;
begin
  ADFreeAndNil(frmADGUIxFormsAsyncExecute);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetForm: TfrmADGUIxFormsAsyncExecute;
begin
  if frmADGUIxFormsAsyncExecute = nil then
    frmADGUIxFormsAsyncExecute := TfrmADGUIxFormsAsyncExecute.Create(Application);
  Result := frmADGUIxFormsAsyncExecute;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.Show(const AExecutor: IADStanAsyncExecutor);
begin
  if not ADGUIxSilent() then
    GetForm.Show(AExecutor);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.Hide;
begin
  if not ADGUIxSilent() then
    GetForm.Hide;
end;

{-------------------------------------------------------------------------------}
{$IFDEF MSWINDOWS}
function TADGUIxFormsAsyncExecuteImpl.IsFormActive: Boolean;
begin
  Result := not ADGUIxSilent() and GetForm.IsFormActive;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.IsFormMouseMessage(
  const AMsg: TMsg): Boolean;
begin
  Result := not ADGUIxSilent() and GetForm.IsFormMouseMessage(AMsg);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetOnHide: TNotifyEvent;
begin
  Result := GetForm.OnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetOnShow: TNotifyEvent;
begin
  Result := GetForm.OnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetOnHide(const AValue: TNotifyEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.OnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetOnShow(const AValue: TNotifyEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.OnShow := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetCaption: String;
begin
  Result := GetForm.Caption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetCaption(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetPrompt: String;
begin
  Result := GetForm.lblPrompt.Caption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetPrompt(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.lblPrompt.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetShowDelay: Integer;
begin
  Result := GetForm.FShowDelay;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetShowDelay(AValue: Integer);
begin
  if (AValue <> 0) or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.FShowDelay := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFormsAsyncExecuteImpl.GetHideDelay: Integer;
begin
  Result := GetForm.FHideDelay;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFormsAsyncExecuteImpl.SetHideDelay(AValue: Integer);
begin
  if (AValue <> 0) or Assigned(frmADGUIxFormsAsyncExecute) then
    GetForm.FHideDelay := AValue;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
{$IFDEF AnyDAC_FPC}
  {$I uADGUIxFormsfAsync.lrs}
{$ENDIF}
  oFact := TADSingletonFactory.Create(TADGUIxFormsAsyncExecuteImpl,
    IADGUIxAsyncExecuteDialog, C_AD_GUIxFormsProvider, 'uADGUIxFormsfAsync');
{$IFDEF AnyDAC_FMX}
  oFact.AddFriend(C_AD_GUIxFMXProvider + '=uADGUIxFMXfAsync');
{$ENDIF}

finalization
  ADReleaseFactory(oFact);

end.
