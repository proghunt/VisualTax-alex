{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{         FireDAC FireMonkey async notify form          }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFMXfAsync"'}

unit uADGUIxFMXfAsync;

interface

uses
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes,
{$IFDEF AnyDAC_FPC}
  FMX_Forms, FMX_Controls, FMX_Objects, FMX_Types, FMX_Effects,
{$ELSE}
  FMX.Forms, FMX.Controls, FMX.Objects, FMX.Types, FMX.Effects,
  {$IFDEF AnyDAC_D18}
    FMX.StdCtrls,
  {$ENDIF}
{$ENDIF}
  uADStanIntf,
  uADGUIxIntf, uADGUIxFMXfOptsBase;

type
  TfrmADGUIxFMXAsyncExecute = class(TfrmADGUIxFMXOptsBase)
    pnlBlur: TPanel;
    aniProgress: TAniIndicator;
    lblText: TLabel;
    btnCancel2: TButton;
    tmrDelay: TTimer;
    rectBorder: TRectangle;
    lblTitle: TLabel;
    pnlBottom: TPanel;
    StyleBook1: TStyleBook;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
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
    function IsFormMouseMessage(const AMsg: TMsg): Boolean;
{$ENDIF}
  end;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.fmx}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  Types, 
{$IFDEF AnyDAC_FPC}
  FMX_Platform,
{$ELSE}
  FMX.Platform,
{$ENDIF}
  uADStanConst, uADStanFactory, uADStanResStrs, uADStanUtil,
  uADGUIxManager;

var
  frmADGUIxFMXAsyncExecute: TfrmADGUIxFMXAsyncExecute;

{-------------------------------------------------------------------------------}
{ TfrmADGUIxFMXAsyncExecute                                                     }
{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXAsyncExecute.FormCreate(Sender: TObject);
begin
  lblText.Text := S_AD_AsyncDialogDefPrompt;
  FShowDelay := C_AD_DelayBeforeFWait;
  FHideDelay := C_AD_DelayBeforeFWait;
  lblTitle.Text := S_AD_AsyncDialogDefCaption;
  pnlButtons.Visible := False;
  pnlTop.Visible := False;
  FCentered := True;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXAsyncExecute.FormDestroy(Sender: TObject);
begin
  if frmADGUIxFMXAsyncExecute = Self then
    frmADGUIxFMXAsyncExecute := nil;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXAsyncExecute.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
{$IFDEF MSWINDOWS}
  if Key = VK_ESCAPE then begin
    btnCancelClick(nil);
    Key := 0;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXAsyncExecute.btnCancelClick(Sender: TObject);
begin
  if (FExecutor <> nil) and FExecutor.Operation.AbortSupported then
    FExecutor.AbortJob;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXAsyncExecute.tmrDelayTimer(Sender: TObject);
begin
  if (FRequestShow <> Visible) and not (csDestroying in ComponentState) then begin
    ADGUIxFMXCancel;
    if FRequestShow then begin
      FModalData := ADGUIxFMXBeginModal(Self, False);
      inherited Show;
    end
    else begin
      if FModalData <> nil then
        ADGUIxFMXEndModal(FModalData);
      inherited Hide;
    end;
    tmrDelay.Enabled := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TfrmADGUIxFMXAsyncExecute.Show(const AExecutor: IADStanAsyncExecutor);
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
procedure TfrmADGUIxFMXAsyncExecute.Hide;
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
function TfrmADGUIxFMXAsyncExecute.IsFormMouseMessage(const AMsg: TMsg): Boolean;
var
  rMousePos: TPointF;
  oCtrl: IControl;
  {$IFDEF AnyDAC_D17}
  oMouseSrv: IFMXMouseService;
  {$ENDIF}
begin
  {$IFDEF AnyDAC_D17}
  if TPlatformServices.Current.SupportsPlatformService(IFMXMouseService, IInterface(oMouseSrv)) then
    rMousePos := oMouseSrv.GetMousePos
  else begin
    Result := False;
    Exit;
  end;
  {$ELSE}
  rMousePos := Platform.GetMousePos;
  {$ENDIF}
  oCtrl := ObjectAtPoint(rMousePos);
  Result := (oCtrl <> nil);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADGUIxFMXAsyncExecuteImpl                                                    }
{-------------------------------------------------------------------------------}
type
  TADGUIxFMXAsyncExecuteImpl = class(TADGUIxObject, IADGUIxAsyncExecuteDialog)
  private
    function GetForm: TfrmADGUIxFMXAsyncExecute;
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
procedure TADGUIxFMXAsyncExecuteImpl.Initialize;
begin
  inherited Initialize;
  frmADGUIxFMXAsyncExecute := nil;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxFMXAsyncExecuteImpl.Destroy;
begin
  ADFreeAndNil(frmADGUIxFMXAsyncExecute);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.GetForm: TfrmADGUIxFMXAsyncExecute;
begin
  if frmADGUIxFMXAsyncExecute = nil then
    frmADGUIxFMXAsyncExecute := TfrmADGUIxFMXAsyncExecute.Create(Application);
  Result := frmADGUIxFMXAsyncExecute;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.Show(const AExecutor: IADStanAsyncExecutor);
var
  oWait: IADGUIxWaitCursor;
begin
  if not ADGUIxSilent() then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.PopWait;
    GetForm.Show(AExecutor);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.Hide;
var
  oWait: IADGUIxWaitCursor;
begin
  if not ADGUIxSilent() then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.PushWait;
    GetForm.Hide;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF MSWINDOWS}
function TADGUIxFMXAsyncExecuteImpl.IsFormActive: Boolean;
begin
  Result := not ADGUIxSilent() and GetForm.Active;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.IsFormMouseMessage(const AMsg: TMsg): Boolean;
begin
  Result := not ADGUIxSilent() and GetForm.IsFormMouseMessage(AMsg);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.GetOnHide: TNotifyEvent;
begin
  Result := GetForm.OnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.GetOnShow: TNotifyEvent;
begin
  Result := GetForm.OnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.SetOnHide(const AValue: TNotifyEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFMXAsyncExecute) then
    GetForm.OnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.SetOnShow(const AValue: TNotifyEvent);
begin
  if Assigned(AValue) or Assigned(frmADGUIxFMXAsyncExecute) then
    GetForm.OnShow := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.GetCaption: String;
begin
  Result := GetForm.lblTitle.Text;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.SetCaption(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFMXAsyncExecute) then
    GetForm.lblTitle.Text := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.GetPrompt: String;
begin
  Result := GetForm.lblText.Text;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.SetPrompt(const AValue: String);
begin
  if (AValue <> '') or Assigned(frmADGUIxFMXAsyncExecute) then
    GetForm.lblText.Text := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.GetShowDelay: Integer;
begin
  Result := GetForm.FShowDelay;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.SetShowDelay(AValue: Integer);
begin
  if (AValue <> 0) or Assigned(frmADGUIxFMXAsyncExecute) then
    GetForm.FShowDelay := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXAsyncExecuteImpl.GetHideDelay: Integer;
begin
  Result := GetForm.FHideDelay;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXAsyncExecuteImpl.SetHideDelay(AValue: Integer);
begin
  if (AValue <> 0) or Assigned(frmADGUIxFMXAsyncExecute) then
    GetForm.FHideDelay := AValue;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADSingletonFactory.Create(TADGUIxFMXAsyncExecuteImpl,
    IADGUIxAsyncExecuteDialog, C_AD_GUIxFMXProvider, 'uADGUIxFMXfAsync');

finalization
  ADReleaseFactory(oFact);

end.
