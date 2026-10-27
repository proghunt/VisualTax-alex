{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC GUIx layer base classes            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxManager;

interface

uses
  Classes,
  uADStanFactory, uADStanIntf, uADStanUtil, uADStanConst,
  uADGUIxIntf;

type
  TADGUIxObject = class(TADObject)
  protected
    class function IsFactoryEnabled(const AMyProvider, AReqProvider: String): Boolean; override;
  end;

  PADLoginItem = ^TADLoginItem;
  TADLoginItem = record
    FParam: String;
    FType: String;
    FCaption: String;
    FOrder: Integer;
    FValue: String;
  end;

  TADGUIxLoginDialogImplBase = class(TADGUIxObject, IADGUIxLoginDialog)
  private
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FLoginRetries: Integer;
    FOnChangePassword: TADGUIxLoginDialogEvent;
    FOnLogin: TADGUIxLoginDialogEvent;
    FChangeExpiredPassword: Boolean;
  protected
    FCaption: String;
    FConnectionDef: IADStanConnectionDef;
    FHistoryEnabled: Boolean;
    FHistoryKey: String;
    FHistoryStorage: TADGUIxLoginHistoryStorage;
    FHistoryWithPassword: Boolean;
    FVisibleItems: TStrings;
    // IADGUIxLoginDialog
    function GetCaption: String;
    function GetChangeExpiredPassword: Boolean;
    function GetHistoryEnabled: Boolean;
    function GetHistoryKey: String;
    function GetHistoryStorage: TADGUIxLoginHistoryStorage;
    function GetHistoryWithPassword: Boolean;
    function GetLoginRetries: Integer;
    function GetVisibleItems: TStrings;
    function GetConnectionDef: IADStanConnectionDef;
    function GetOnHide: TNotifyEvent;
    function GetOnShow: TNotifyEvent;
    function GetOnChangePassword: TADGUIxLoginDialogEvent;
    function GetOnLogin: TADGUIxLoginDialogEvent;
    procedure SetCaption(const AValue: String);
    procedure SetChangeExpiredPassword(const AValue: Boolean);
    procedure SetHistoryEnabled(const AValue: Boolean);
    procedure SetHistoryKey(const AValue: String);
    procedure SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
    procedure SetHistoryWithPassword(const AValue: Boolean);
    procedure SetLoginRetries(const AValue: Integer);
    procedure SetVisibleItems(const AValue: TStrings);
    procedure SetConnectionDef(const AValue: IADStanConnectionDef);
    procedure SetOnHide(const AValue: TNotifyEvent);
    procedure SetOnShow(const AValue: TNotifyEvent);
    procedure SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
    procedure SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
    function Execute(ALoginAction: TADGUIxLoginAction): Boolean;
    procedure GetAllLoginParams;
    // Forms & FMX
    function ExecuteLogin: Boolean; virtual; abstract;
    function ExecuteChngPwd: Boolean; virtual; abstract;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

  TADGUIxScriptImplBase = class(TADGUIxObject, IADGUIxScriptDialog)
  protected
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
    FOnProgress: TADGUIxScriptProgressEvent;
    FOnOutput: TADGUIxScriptOutputEvent;
    FOnInput: TADGUIxScriptInputEvent;
    FOnPause: TADGUIxScriptPauseEvent;
    FCaption: String;
    FOptions: TADGUIxScriptOptions;
    // IADGUIxScriptDialog
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
    function GetOnProgress: TADGUIxScriptProgressEvent;
    procedure SetOnProgress(const AValue: TADGUIxScriptProgressEvent);
    function GetOnOutput: TADGUIxScriptOutputEvent;
    procedure SetOnOutput(const AValue: TADGUIxScriptOutputEvent);
    function GetOnInput: TADGUIxScriptInputEvent;
    procedure SetOnInput(const AValue: TADGUIxScriptInputEvent);
    function GetOnPause: TADGUIxScriptPauseEvent;
    procedure SetOnPause(const AValue: TADGUIxScriptPauseEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function GetOptions: TADGUIxScriptOptions;
    procedure SetOptions(AValue: TADGUIxScriptOptions);
    procedure Show; virtual; abstract;
    procedure Progress(const AInfoProvider: IADGUIxScriptDialogInfoProvider); virtual; abstract;
    procedure Output(const AStr: String; AKind: TADScriptOuputKind); virtual; abstract;
    procedure Input(const APrompt: String; var AResult: String); virtual; abstract;
    procedure Pause(const APrompt: String); virtual; abstract;
    procedure Hide; virtual; abstract;
  end;

  TADGUIxVisualScriptImplBase = class(TADGUIxScriptImplBase)
  public
    procedure Initialize; override;
  end;

  TADGUIxWaitCursorImplBase = class(TADGUIxObject, IADGUIxWaitCursor)
  protected
    FWaitCursor: TADGUIxScreenCursor;
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
    // IADGUIxWaitCursor
    procedure StartWait; virtual; abstract;
    procedure StopWait; virtual; abstract;
    procedure PushWait; virtual; abstract;
    procedure PopWait; virtual; abstract;
    procedure ForceStopWait; virtual; abstract;
    function GetWaitCursor: TADGUIxScreenCursor;
    procedure SetWaitCursor(const AValue: TADGUIxScreenCursor);
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
  end;

  TADGUIxVisualWaitCursorImplBase = class(TADGUIxWaitCursorImplBase)
  private
    FTimer: TADTimer;
    FStopRequestTime: LongWord;
    FWasActive: Integer;
    function IsVisible: Boolean;
    procedure HideCursor;
    procedure ShowCursor;
    procedure TimerProc;
    procedure StopTimer;
    procedure StartTimer;
  protected
    function CheckCurCursor: Boolean; virtual; abstract;
    function InternalHideCursor: Boolean; virtual; abstract;
    procedure InternalShowCursor; virtual; abstract;
    // IADGUIxWaitCursor
    procedure StartWait; override;
    procedure StopWait; override;
    procedure PushWait; override;
    procedure PopWait; override;
    procedure ForceStopWait; override;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  uADStanResStrs, uADStanError,
  uADPhysIntf;

var
  FWait: TADGUIxWaitCursorImplBase;

{-------------------------------------------------------------------------------}
{ TADGUIxObject                                                                 }
{-------------------------------------------------------------------------------}
class function TADGUIxObject.IsFactoryEnabled(const AMyProvider,
  AReqProvider: String): Boolean;
begin
  if ADIsDesignTime then
    Result := CompareText(AMyProvider, C_AD_GUIxFormsProvider) = 0
  else if AReqProvider = '' then
    Result := CompareText(AMyProvider, FADGUIxProvider) = 0
  else
    Result := CompareText(AMyProvider, AReqProvider) = 0;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxLoginDialogImplBase                                                    }
{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.Initialize;
begin
  inherited Initialize;
{$IFDEF MSWINDOWS}
  FHistoryStorage := hsRegistry;
  FHistoryKey := S_AD_CfgKeyName + '\' + S_AD_Profiles;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  FHistoryStorage := hsFile;
  FHistoryKey := S_AD_Profiles;
{$ENDIF}
  FHistoryWithPassword := True;
  FHistoryEnabled := False;
  FCaption := S_AD_LoginDialogDefCaption;
  FVisibleItems := TADStringList.Create;
  FVisibleItems.Add(S_AD_ConnParam_Common_UserName);
  FVisibleItems.Add(S_AD_ConnParam_Common_Password);
  FLoginRetries := 3;
  FChangeExpiredPassword := True;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxLoginDialogImplBase.Destroy;
begin
  ADFreeAndNil(FVisibleItems);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetCaption: String;
begin
  Result := FCaption;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetChangeExpiredPassword: Boolean;
begin
  Result := FChangeExpiredPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetConnectionDef: IADStanConnectionDef;
begin
  Result := FConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetHistoryEnabled: Boolean;
begin
  Result := FHistoryEnabled;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetHistoryKey: String;
begin
  Result := FHistoryKey;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetHistoryStorage: TADGUIxLoginHistoryStorage;
begin
  Result := FHistoryStorage;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetHistoryWithPassword: Boolean;
begin
  Result := FHistoryWithPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetLoginRetries: Integer;
begin
  Result := FLoginRetries;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetVisibleItems: TStrings;
begin
  Result := FVisibleItems;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetOnHide: TNotifyEvent;
begin
  Result := FOnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetOnShow: TNotifyEvent;
begin
  Result := FOnShow;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetOnChangePassword: TADGUIxLoginDialogEvent;
begin
  Result := FOnChangePassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.GetOnLogin: TADGUIxLoginDialogEvent;
begin
  Result := FOnLogin;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetOnHide(const AValue: TNotifyEvent);
begin
  FOnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetCaption(const AValue: String);
begin
  FCaption := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetChangeExpiredPassword(const AValue: Boolean);
begin
  FChangeExpiredPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetConnectionDef(const AValue: IADStanConnectionDef);
begin
  FConnectionDef := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetHistoryEnabled(const AValue: Boolean);
begin
  FHistoryEnabled := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetHistoryKey(const AValue: String);
begin
  FHistoryKey := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
begin
  FHistoryStorage := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetHistoryWithPassword(const AValue: Boolean);
begin
  FHistoryWithPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetLoginRetries(const AValue: Integer);
begin
  FLoginRetries := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetVisibleItems(const AValue: TStrings);
begin
  FVisibleItems.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetOnShow(const AValue: TNotifyEvent);
begin
  FOnShow := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnChangePassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnLogin := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialogImplBase.GetAllLoginParams;
var
  oMeta: IADPhysManagerMetadata;
  oDrv: IADPhysDriverMetadata;
  i, iLogin: Integer;
  sName, sCaption, sTmp: String;
begin
  ADPhysManager.CreateMetadata(oMeta);
  if ADPhysManager.State <> dmsActive then
    ADPhysManager.Open;
  oMeta.CreateDriverMetadata(FConnectionDef.DriverID, oDrv);
  FVisibleItems.Clear;
  for i := 0 to oDrv.GetConnParamCount(FConnectionDef.Params) - 1 do begin
    oDrv.GetConnParams(FConnectionDef.Params, i, sName, sTmp, sTmp, sCaption, iLogin);
    if iLogin <> -1 then
      FVisibleItems.Add(sName + '=' + sCaption);
  end;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialogImplBase.Execute(ALoginAction: TADGUIxLoginAction): Boolean;
var
  iRetries: Integer;
  lLoged, lLoginPrompt: Boolean;
begin
  if ADGUIxSilent() then begin
    if Assigned(ALoginAction) then
      ALoginAction;
    Result := True;
    Exit;
  end;
  if Assigned(FOnShow) then
    FOnShow(Self);
  iRetries := 0;
  lLoged := True;
  lLoginPrompt := True;
  repeat
    try
      if lLoginPrompt then begin
        if Assigned(FOnLogin) then begin
          Result := True;
          FOnLogin(Self, Result);
        end
        else
          Result := ExecuteLogin;
      end
      else begin
        lLoginPrompt := True;
        Result := True;
      end;
      if Result and Assigned(ALoginAction) then
        ALoginAction;
      lLoged := True;
    except on E: EADDBEngineException do
      // invalid password/user name
      if (E.Kind = ekUserPwdInvalid) and (FLoginRetries >= 0) then begin
        ADHandleException;
        Inc(iRetries);
        if iRetries >= FLoginRetries then
          ADException(Self, [S_AD_LGUIx, S_AD_LGUIx_PForms], er_AD_AccToManyLogins,
            [FLoginRetries]);
        lLoged := False;
      end
      // password expired
      else if (E.Kind = ekUserPwdExpired) and FChangeExpiredPassword then begin
        ADHandleException;
        if Assigned(FOnChangePassword) then begin
          Result := True;
          FOnChangePassword(Self, Result);
        end
        else
          Result := ExecuteChngPwd;
        lLoginPrompt := False;
        lLoged := False;
      end
      // will expired
      else if E.Kind = ekUserPwdWillExpire then
        ADHandleException
      else
        raise;
    end;
  until lLoged;
  if Result and Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxScriptImplBase                                                         }
{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetOnHide: TNotifyEvent;
begin
  Result := FOnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetOnShow: TNotifyEvent;
begin
  Result := FOnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetOnHide(const AValue: TNotifyEvent);
begin
  FOnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetOnShow(const AValue: TNotifyEvent);
begin
  FOnShow := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetOnOutput: TADGUIxScriptOutputEvent;
begin
  Result := FOnOutput;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetOnOutput(const AValue: TADGUIxScriptOutputEvent);
begin
  FOnOutput := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetOnInput: TADGUIxScriptInputEvent;
begin
  Result := FOnInput;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetOnInput(const AValue: TADGUIxScriptInputEvent);
begin
  FOnInput := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetOnPause: TADGUIxScriptPauseEvent;
begin
  Result := FOnPause;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetOnPause(const AValue: TADGUIxScriptPauseEvent);
begin
  FOnPause := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetOnProgress: TADGUIxScriptProgressEvent;
begin
  Result := FOnProgress;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetOnProgress(const AValue: TADGUIxScriptProgressEvent);
begin
  FOnProgress := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetCaption: String;
begin
  Result := FCaption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetCaption(const AValue: String);
begin
  FCaption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptImplBase.GetOptions: TADGUIxScriptOptions;
begin
  Result := FOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptImplBase.SetOptions(AValue: TADGUIxScriptOptions);
begin
  FOptions := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxVisualScriptImplBase                                                   }
{-------------------------------------------------------------------------------}
procedure TADGUIxVisualScriptImplBase.Initialize;
begin
  inherited Initialize;
  FCaption := S_AD_ScriptDialogDefCaption;
  FOptions := [ssCallstack, ssConsole, ssAutoHide];
  FOnShow := nil;
  FOnHide := nil;
  FOnProgress := nil;
  FOnOutput := nil;
  FOnInput := nil;
  FOnPause := nil;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxWaitCursorImplBase                                                     }
{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImplBase.GetWaitCursor: TADGUIxScreenCursor;
begin
  Result := FWaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImplBase.SetWaitCursor(const AValue: TADGUIxScreenCursor);
begin
  FWaitCursor := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImplBase.GetOnHide: TNotifyEvent;
begin
  Result := FOnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImplBase.GetOnShow: TNotifyEvent;
begin
  Result := FOnShow;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImplBase.SetOnHide(const AValue: TNotifyEvent);
begin
  FOnHide := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImplBase.SetOnShow(const AValue: TNotifyEvent);
begin
  FOnShow := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxVisualWaitCursorImplBase                                               }
{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.Initialize;
begin
  inherited Initialize;
  FWait := Self;
  FWaitCursor := gcrSQLWait;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxVisualWaitCursorImplBase.Destroy;
begin
  ForceStopWait;
  ADFreeAndNil(FTimer);
  inherited Destroy;
  FWait := nil;
end;

{-------------------------------------------------------------------------------}
function TADGUIxVisualWaitCursorImplBase.IsVisible: Boolean;
begin
  Result := not ADGUIxSilent() and (FWaitCursor <> gcrNone);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.StopTimer;
begin
  if FTimer <> nil then
    FTimer.Enabled := False;
  FStopRequestTime := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.TimerProc;
begin
  if ADTimeout(FStopRequestTime, C_AD_HideCursorDelay) then begin
    if IsVisible then
      HideCursor;
    StopTimer;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.StartTimer;
begin
  if FTimer = nil then begin
    FTimer := TADTimer.Create(nil);
    FTimer.Interval := C_AD_HideCursorDelay;
    FTimer.Options := [toSynchronized];
    FTimer.OnTimer := TimerProc;
  end;
  FTimer.Enabled := True;
  FStopRequestTime := ADGetTickCount();
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.ShowCursor;
begin
  if not CheckCurCursor then begin
    if Assigned(FOnShow) then
      FOnShow(Self);
    InternalShowCursor;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.HideCursor;
begin
  if InternalHideCursor then
    if Assigned(FOnHide) then
      FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.StartWait;
begin
  if not IsVisible then
    Exit;
  StopTimer;
  ShowCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.StopWait;
begin
  if not IsVisible then
    Exit;
  StartTimer;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.PopWait;
begin
  if not IsVisible then
    Exit;
  if CheckCurCursor then
    if FStopRequestTime > 0 then
      FWasActive := 2
    else
      FWasActive := 1
  else
    FWasActive := 0;
  HideCursor;
  StopTimer;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.PushWait;
begin
  if not IsVisible then
    Exit;
  case FWasActive of
  2: begin
      ShowCursor;
      StartTimer;
     end;
  1: ShowCursor;
  0: ;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxVisualWaitCursorImplBase.ForceStopWait;
begin
  StopTimer;
  HideCursor;
  FWasActive := 0;
end;

end.
