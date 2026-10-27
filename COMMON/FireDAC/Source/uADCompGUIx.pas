{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                FireDAC GUIx components                }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompGUIx;

interface

uses
  Classes,
  uADStanIntf, uADStanError, uADStanConst,
  uADGUIxIntf;

type
  TADGUIxComponent = class;
  TADGUIxAsyncExecuteDialog = class;
  TADGUIxErrorDialog = class;
  TADGUIxLoginDialog = class;
  TADGUIxScriptDialog = class;
  TADGUIxWaitCursor = class;

  TADGUIxComponent = class(TADComponent)
  private
    FProvider: String;
    FProviderSpecified: Boolean;
  protected
    function GetProvider: String;
    procedure SetProvider(const AValue: String); virtual;
  public
    class function GetGUID: TGUID; virtual;
  published
    property Provider: String read GetProvider write SetProvider
      stored FProviderSpecified;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADGUIxAsyncExecuteDialog = class(TADGUIxComponent, IADGUIxAsyncExecuteDialog)
  private
    FAsyncDialog: IADGUIxAsyncExecuteDialog;
    FCaption: String;
    FPrompt: String;
    FShowDelay: Integer;
    FHideDelay: Integer;
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
    function GetAsyncDialog: IADGUIxAsyncExecuteDialog;
    procedure DoOnShow(ASender: TObject);
    procedure DoOnHide(ASender: TObject);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function IsCS: Boolean;
    function GetShowDelay: Integer;
    procedure SetShowDelay(const AValue: Integer);
    function GetHideDelay: Integer;
    procedure SetHideDelay(const AValue: Integer);
    function GetPrompt: String;
    procedure SetPrompt(const AValue: String);
    function IsPS: Boolean;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetGUID: TGUID; override;
    property AsyncDialog: IADGUIxAsyncExecuteDialog read FAsyncDialog
      implements IADGUIxAsyncExecuteDialog;
  published
    property Caption: String read GetCaption write SetCaption stored IsCS;
    property Prompt: String read GetPrompt write SetPrompt stored IsPS;
    property ShowDelay: Integer read GetShowDelay write SetShowDelay
      default C_AD_DelayBeforeFWait;
    property HideDelay: Integer read GetHideDelay write SetHideDelay
      default C_AD_DelayBeforeFWait;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADGUIxErrorDialog = class(TADGUIxComponent, IADGUIxErrorDialog)
  private
    FErrorDialog: IADGUIxErrorDialog;
    FCaption: String;
    FEnabled: Boolean;
    FStayOnTop: Boolean;
    FOnHide: TADGUIxErrorDialogEvent;
    FOnShow: TADGUIxErrorDialogEvent;
    function GetErrorDialog: IADGUIxErrorDialog;
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function IsCS: Boolean;
    procedure DoOnHide(ASender: TObject; AException: EADDBEngineException);
    procedure DoOnShow(ASender: TObject; AException: EADDBEngineException);
    function GetEnabled: Boolean;
    procedure SetEnabled(const AValue: Boolean);
    function GetStayOnTop: Boolean;
    procedure SetStayOnTop(const AValue: Boolean);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetGUID: TGUID; override;
    procedure Execute(E: EADDBEngineException);
    property ErrorDialog: IADGUIxErrorDialog read FErrorDialog implements IADGUIxErrorDialog;
  published
    property Caption: String read GetCaption write SetCaption stored IsCS;
    property Enabled: Boolean read GetEnabled write SetEnabled default True;
    property StayOnTop: Boolean read GetStayOnTop write SetStayOnTop default True;
    property OnShow: TADGUIxErrorDialogEvent read FOnShow write FOnShow;
    property OnHide: TADGUIxErrorDialogEvent read FOnHide write FOnHide;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADGUIxLoginDialog = class(TADGUIxComponent, IADGUIxLoginDialog)
  private
    FLoginDialog: IADGUIxLoginDialog;
    FCaption: String;
    FHistoryEnabled: Boolean;
    FHistoryKey: String;
    FHistoryStorage: TADGUIxLoginHistoryStorage;
    FHistoryWithPassword: Boolean;
    FLoginRetries: Integer;
    FVisibleItems: TStrings;
    FChangeExpiredPassword: Boolean;
    FConnectionDef: IADStanConnectionDef;
    FOnChangePassword: TADGUIxLoginDialogEvent;
    FOnLogin: TADGUIxLoginDialogEvent;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    function GetLoginDialog: IADGUIxLoginDialog;
    function GetCaption: String;
    function GetChangeExpiredPassword: Boolean;
    function GetConnectionDef: IADStanConnectionDef;
    function GetHistoryEnabled: Boolean;
    function GetHistoryKey: String;
    function GetHistoryStorage: TADGUIxLoginHistoryStorage;
    function GetHistoryWithPassword: Boolean;
    function GetLoginRetries: Integer;
    function GetVisibleItems: TStrings;
    procedure SetCaption(const AValue: String);
    procedure SetConnectionDef(const AConnectionDef: IADStanConnectionDef);
    procedure SetChangeExpiredPassword(const AValue: Boolean);
    procedure SetHistoryEnabled(const AValue: Boolean);
    procedure SetHistoryKey(const AValue: String);
    procedure SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
    procedure SetHistoryWithPassword(const AValue: Boolean);
    procedure SetLoginRetries(const AValue: Integer);
    procedure SetVisibleItems(const AValue: TStrings);
    procedure DoOnHide(ASender: TObject);
    procedure DoOnShow(ASender: TObject);
    procedure DoChangePassword(ASender: TObject; var AResult: Boolean);
    procedure DoLogin(ASender: TObject; var AResult: Boolean);
    procedure SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
    procedure SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
    function IsCS: Boolean;
    function IsHKS: Boolean;
    function IsVIS: Boolean;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetGUID: TGUID; override;
    function Execute(ALoginAction: TADGUIxLoginAction): Boolean;
    procedure GetAllLoginParams;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef write SetConnectionDef;
    property LoginDialog: IADGUIxLoginDialog read FLoginDialog implements IADGUIxLoginDialog;
  published
    property Caption: String read GetCaption write SetCaption stored IsCS;
    property HistoryEnabled: Boolean read GetHistoryEnabled write SetHistoryEnabled default False;
    property HistoryWithPassword: Boolean read GetHistoryWithPassword write SetHistoryWithPassword default True;
    property HistoryStorage: TADGUIxLoginHistoryStorage read GetHistoryStorage write SetHistoryStorage default hsRegistry;
    property HistoryKey: String read GetHistoryKey write SetHistoryKey stored IsHKS;
    property VisibleItems: TStrings read GetVisibleItems write SetVisibleItems stored IsVIS;
    property LoginRetries: Integer read GetLoginRetries write SetLoginRetries default 3;
    property ChangeExpiredPassword: Boolean read GetChangeExpiredPassword write SetChangeExpiredPassword default True;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnLogin: TADGUIxLoginDialogEvent read FOnLogin write SetOnLogin;
    property OnChangePassword: TADGUIxLoginDialogEvent read FOnChangePassword write SetOnChangePassword;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADGUIxScriptDialog = class(TADGUIxComponent, IADGUIxScriptDialog)
  private
    FScriptDialog: IADGUIxScriptDialog;
    FCaption: String;
    FOptions: TADGUIxScriptOptions;
    FOnOutput: TADGUIxScriptOutputEvent;
    FOnInput: TADGUIxScriptInputEvent;
    FOnPause: TADGUIxScriptPauseEvent;
    FOnProgress: TADGUIxScriptProgressEvent;
    FOnShow: TNotifyEvent;
    FOnHide: TNotifyEvent;
    function GetScriptDialog: IADGUIxScriptDialog;
    function GetCaption: String;
    function IsCS: Boolean;
    procedure SetCaption(const AValue: String);
    procedure DoOnHide(ASender: TObject);
    procedure DoOnShow(ASender: TObject);
    procedure DoOnProgress(ASender: TObject;
      const AInfoProvider: IADGUIxScriptDialogInfoProvider);
    procedure DoOnOutput(ASender: TObject; const AStr: String);
    procedure DoOnInput(ASender: TObject; const APrompt: String; var AResult: String);
    procedure DoOnPause(ASender: TObject; const APrompt: String);
    function GetOptions: TADGUIxScriptOptions;
    procedure SetOptions(const AValue: TADGUIxScriptOptions);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetGUID: TGUID; override;
    property ScriptDialog: IADGUIxScriptDialog read FScriptDialog
      implements IADGUIxScriptDialog;
  published
    property Caption: String read GetCaption write SetCaption stored IsCS;
    property Options: TADGUIxScriptOptions read GetOptions write SetOptions
      default [ssCallstack, ssConsole, ssAutoHide];
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnProgress: TADGUIxScriptProgressEvent read FOnProgress write FOnProgress;
    property OnOutput: TADGUIxScriptOutputEvent read FOnOutput write FOnOutput;
    property OnInput: TADGUIxScriptInputEvent read FOnInput write FOnInput;
    property OnPause: TADGUIxScriptPauseEvent read FOnPause write FOnPause;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADGUIxWaitCursor = class(TADGUIxComponent, IADGUIxWaitCursor)
  private
    FWaitCursor: IADGUIxWaitCursor;
    FScreenCursor: TADGUIxScreenCursor;
    FOnHide: TNotifyEvent;
    FOnShow: TNotifyEvent;
    function GetGUIxWaitCursor: IADGUIxWaitCursor;
    function GetScreenCursor: TADGUIxScreenCursor;
    procedure SetScreenCursor(const AValue: TADGUIxScreenCursor);
    procedure DoOnHide(ASender: TObject);
    procedure DoOnShow(ASender: TObject);
  protected
    procedure Loaded; override;
    procedure SetProvider(const AValue: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetGUID: TGUID; override;
    property WaitCursor: IADGUIxWaitCursor read FWaitCursor
      implements IADGUIxWaitCursor;
  published
    property ScreenCursor: TADGUIxScreenCursor read GetScreenCursor write SetScreenCursor
      default gcrSQLWait;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
  end;

implementation

uses
{$IFNDEF AnyDAC_D6}
  {$IFDEF MSWINDOWS}
  uADGUIxFormsWait, uADGUIxFormsfAsync, uADGUIxFormsfError,
    uADGUIxFormsfLogin, uADGUIxFormsfScript,
  {$ENDIF}
{$ENDIF}
  uADStanUtil, uADStanFactory, uADStanResStrs,
  uADPhysIntf;

{-------------------------------------------------------------------------------}
{ TADGUIxComponent                                                              }
{-------------------------------------------------------------------------------}
function TADGUIxComponent.GetProvider: String;
begin
  if FProviderSpecified then
    Result := FProvider
  else
    Result := FADGUIxProvider;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxComponent.SetProvider(const AValue: String);
begin
  FProvider := AValue;
  FProviderSpecified := FProvider <> '';
end;

{-------------------------------------------------------------------------------}
class function TADGUIxComponent.GetGUID: TGUID;
begin
  ADFillChar(Result, SizeOf(TGUID), 0);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxAsyncExecuteDialog                                                     }
{-------------------------------------------------------------------------------}
constructor TADGUIxAsyncExecuteDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := S_AD_AsyncDialogDefCaption;
  FPrompt := S_AD_AsyncDialogDefPrompt;
  FShowDelay := C_AD_DelayBeforeFWait;
  FHideDelay := C_AD_DelayBeforeFWait;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxAsyncExecuteDialog.Destroy;
begin
  if FAsyncDialog <> nil then begin
    (FAsyncDialog as IADStanComponentReference).SetComponentReference(nil);
    FAsyncDialog.OnShow := nil;
    FAsyncDialog.OnHide := nil;
    FAsyncDialog := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADGUIxAsyncExecuteDialog.GetGUID: TGUID;
begin
  Result := IADGUIxAsyncExecuteDialog;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxAsyncExecuteDialog.Loaded;
var
  oDlg: IADGUIxAsyncExecuteDialog;
begin
  inherited Loaded;
  oDlg := GetAsyncDialog;
  oDlg.Caption := FCaption;
  oDlg.Prompt := FPrompt;
  oDlg.ShowDelay := FShowDelay;
  oDlg.HideDelay := FHideDelay;
  oDlg.OnShow := DoOnShow;
  oDlg.OnHide := DoOnHide;
end;

{-------------------------------------------------------------------------------}
function TADGUIxAsyncExecuteDialog.GetAsyncDialog: IADGUIxAsyncExecuteDialog;
begin
  if FAsyncDialog = nil then begin
    ADCreateInterface(IADGUIxAsyncExecuteDialog, FAsyncDialog, True, Provider);
    (FAsyncDialog as IADStanComponentReference).SetComponentReference(
      Self as IInterfaceComponentReference);
  end;
  Result := FAsyncDialog;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxAsyncExecuteDialog.DoOnHide(ASender: TObject);
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxAsyncExecuteDialog.DoOnShow(ASender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
function TADGUIxAsyncExecuteDialog.GetCaption: String;
begin
  if not (csLoading in ComponentState) then
    Result := GetAsyncDialog.Caption
  else
    Result := FCaption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxAsyncExecuteDialog.SetCaption(const AValue: String);
begin
  FCaption := AValue;
  if not (csLoading in ComponentState) then
    GetAsyncDialog.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxAsyncExecuteDialog.IsCS: Boolean;
begin
  Result := Caption <> S_AD_AsyncDialogDefCaption;
end;

{-------------------------------------------------------------------------------}
function TADGUIxAsyncExecuteDialog.GetPrompt: String;
begin
  if not (csLoading in ComponentState) then
    Result := GetAsyncDialog.Prompt
  else
    Result := FPrompt;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxAsyncExecuteDialog.SetPrompt(const AValue: String);
begin
  FPrompt := AValue;
  if not (csLoading in ComponentState) then
    GetAsyncDialog.Prompt := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxAsyncExecuteDialog.IsPS: Boolean;
begin
  Result := Prompt <> S_AD_AsyncDialogDefPrompt;
end;

{-------------------------------------------------------------------------------}
function TADGUIxAsyncExecuteDialog.GetShowDelay: Integer;
begin
  if not (csLoading in ComponentState) then
    Result := GetAsyncDialog.ShowDelay
  else
    Result := FShowDelay;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxAsyncExecuteDialog.SetShowDelay(const AValue: Integer);
begin
  FShowDelay := AValue;
  if not (csLoading in ComponentState) then
    GetAsyncDialog.ShowDelay := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxAsyncExecuteDialog.GetHideDelay: Integer;
begin
  if not (csLoading in ComponentState) then
    Result := GetAsyncDialog.HideDelay
  else
    Result := FHideDelay;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxAsyncExecuteDialog.SetHideDelay(const AValue: Integer);
begin
  FHideDelay := AValue;
  if not (csLoading in ComponentState) then
    GetAsyncDialog.HideDelay := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxErrorDialog                                                            }
{-------------------------------------------------------------------------------}
constructor TADGUIxErrorDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := S_AD_ErrorDialogDefCaption;
  FEnabled := True;
  FStayOnTop := True;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxErrorDialog.Destroy;
begin
  if FErrorDialog <> nil then begin
    (FErrorDialog as IADStanComponentReference).SetComponentReference(nil);
    FErrorDialog.OnShow := nil;
    FErrorDialog.OnHide := nil;
    FErrorDialog := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADGUIxErrorDialog.GetGUID: TGUID;
begin
  Result := IADGUIxErrorDialog;
end;

{-------------------------------------------------------------------------------}
function TADGUIxErrorDialog.GetErrorDialog: IADGUIxErrorDialog;
begin
  if FErrorDialog = nil then begin
    ADCreateInterface(IADGUIxErrorDialog, FErrorDialog, True, Provider);
    (FErrorDialog as IADStanComponentReference).SetComponentReference(
      Self as IInterfaceComponentReference);
  end;
  Result := FErrorDialog;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxErrorDialog.Loaded;
var
  oDlg: IADGUIxErrorDialog;
begin
  inherited Loaded;
  oDlg := GetErrorDialog;
  oDlg.Caption := FCaption;
  oDlg.Enabled := FEnabled;
  oDlg.StayOnTop := FStayOnTop;
  oDlg.OnShow := DoOnShow;
  oDlg.OnHide := DoOnHide;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxErrorDialog.DoOnHide(ASender: TObject;
  AException: EADDBEngineException);
begin
  if Assigned(FOnHide) then
    FOnHide(Self, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxErrorDialog.DoOnShow(ASender: TObject;
  AException: EADDBEngineException);
begin
  if Assigned(FOnShow) then
    FOnShow(Self, AException);
end;

{-------------------------------------------------------------------------------}
function TADGUIxErrorDialog.GetCaption: String;
begin
  if not (csLoading in ComponentState) then
    Result := GetErrorDialog.Caption
  else
    Result := FCaption;
end;

{-------------------------------------------------------------------------------}
function TADGUIxErrorDialog.IsCS: Boolean;
begin
  Result := Caption <> S_AD_ErrorDialogDefCaption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxErrorDialog.SetCaption(const AValue: String);
begin
  FCaption := AValue;
  if not (csLoading in ComponentState) then
    GetErrorDialog.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxErrorDialog.GetEnabled: Boolean;
begin
  if not (csLoading in ComponentState) then
    Result := GetErrorDialog.Enabled
  else
    Result := FEnabled;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxErrorDialog.SetEnabled(const AValue: Boolean);
begin
  FEnabled := AValue;
  if not (csLoading in ComponentState) then
    GetErrorDialog.Enabled := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxErrorDialog.GetStayOnTop: Boolean;
begin
  if not (csLoading in ComponentState) then
    Result := GetErrorDialog.StayOnTop
  else
    Result := FStayOnTop;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxErrorDialog.SetStayOnTop(const AValue: Boolean);
begin
  FStayOnTop := AValue;
  if not (csLoading in ComponentState) then
    GetErrorDialog.StayOnTop := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxErrorDialog.Execute(E: EADDBEngineException);
begin
  FErrorDialog.Execute(E);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxLoginDialog                                                            }
{-------------------------------------------------------------------------------}
constructor TADGUIxLoginDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisibleItems := TADStringList.Create;
  FCaption := S_AD_LoginDialogDefCaption;
  FHistoryWithPassword := True;
  FHistoryStorage := hsRegistry;
  FHistoryKey := {$IFDEF MSWINDOWS} S_AD_CfgKeyName + '\' + S_AD_Profiles {$ENDIF}
                 {$IFDEF AnyDAC_POSIX} S_AD_Profiles {$ENDIF};
  FLoginRetries := 3;
  FChangeExpiredPassword := True;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxLoginDialog.Destroy;
begin
  if FLoginDialog <> nil then begin
    (FLoginDialog as IADStanComponentReference).SetComponentReference(nil);
    FLoginDialog.OnLogin := nil;
    FLoginDialog.OnChangePassword := nil;
    FLoginDialog.OnShow := nil;
    FLoginDialog.OnHide := nil;
    FLoginDialog := nil;
    ADFreeAndNil(FVisibleItems);
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADGUIxLoginDialog.GetGUID: TGUID;
begin
  Result := IADGUIxLoginDialog;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetLoginDialog: IADGUIxLoginDialog;
begin
  if FLoginDialog = nil then begin
    ADCreateInterface(IADGUIxLoginDialog, FLoginDialog, True, Provider);
    (FLoginDialog as IADStanComponentReference).SetComponentReference(
      Self as IInterfaceComponentReference);
  end;
  Result := FLoginDialog;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.Loaded;
var
  oDlg: IADGUIxLoginDialog;
begin
  inherited Loaded;
  oDlg := GetLoginDialog;
  oDlg.ConnectionDef := FConnectionDef;
  oDlg.Caption := FCaption;
  oDlg.HistoryEnabled := FHistoryEnabled;
  oDlg.HistoryWithPassword := FHistoryWithPassword;
  oDlg.HistoryStorage := FHistoryStorage;
  oDlg.HistoryKey := FHistoryKey;
  oDlg.VisibleItems := FVisibleItems;
  oDlg.LoginRetries := FLoginRetries;
  oDlg.ChangeExpiredPassword := FChangeExpiredPassword;
  if Assigned(FOnLogin) then
    oDlg.OnLogin := DoLogin;
  if Assigned(FOnChangePassword) then
    oDlg.OnChangePassword := DoChangePassword;
  oDlg.OnShow := DoOnShow;
  oDlg.OnHide := DoOnHide;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.DoLogin(ASender: TObject; var AResult: Boolean);
begin
  if Assigned(FOnLogin) then
    FOnLogin(Self, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.DoChangePassword(ASender: TObject; var AResult: Boolean);
begin
  if Assigned(FOnChangePassword) then
    FOnChangePassword(Self, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.DoOnShow(ASender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.DoOnHide(ASender: TObject);
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnChangePassword := AValue;
  if not (csLoading in ComponentState) then
    if Assigned(FOnChangePassword) then
      GetLoginDialog.OnChangePassword := DoChangePassword
    else
      GetLoginDialog.OnChangePassword := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
begin
  FOnLogin := AValue;
  if not (csLoading in ComponentState) then
    if Assigned(FOnLogin) then
      GetLoginDialog.OnLogin := DoLogin
    else
      GetLoginDialog.OnLogin := nil;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetConnectionDef: IADStanConnectionDef;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.ConnectionDef
  else
    Result := FConnectionDef;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetCaption: String;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.Caption
  else
    Result := FCaption;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetChangeExpiredPassword: Boolean;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.ChangeExpiredPassword
  else
    Result := FChangeExpiredPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetHistoryEnabled: Boolean;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.HistoryEnabled
  else
    Result := FHistoryEnabled;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetHistoryKey: String;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.HistoryKey
  else
    Result := FHistoryKey;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetHistoryStorage: TADGUIxLoginHistoryStorage;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.HistoryStorage
  else
    Result := FHistoryStorage;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetHistoryWithPassword: Boolean;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.HistoryWithPassword
  else
    Result := FHistoryWithPassword;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetLoginRetries: Integer;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.LoginRetries
  else
    Result := FLoginRetries;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.GetVisibleItems: TStrings;
begin
  if not (csLoading in ComponentState) then
    Result := GetLoginDialog.VisibleItems
  else
    Result := FVisibleItems;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetCaption(const AValue: String);
begin
  FCaption := AValue;
  if not (csLoading in ComponentState) then
    GetLoginDialog.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.IsCS: Boolean;
begin
  Result := Caption <> S_AD_LoginDialogDefCaption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetChangeExpiredPassword(const AValue: Boolean);
begin
  FChangeExpiredPassword := AValue;
  if not (csLoading in ComponentState) then
    GetLoginDialog.ChangeExpiredPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetHistoryEnabled(const AValue: Boolean);
begin
  FHistoryEnabled := AValue;
  if not (csLoading in ComponentState) then
    GetLoginDialog.HistoryEnabled := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetHistoryKey(const AValue: String);
begin
  FHistoryKey := AValue;
  if not (csLoading in ComponentState) then
    GetLoginDialog.HistoryKey := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.IsHKS: Boolean;
begin
  Result := HistoryKey <> ({$IFDEF MSWINDOWS} S_AD_CfgKeyName + '\' + S_AD_Profiles {$ENDIF}
                           {$IFDEF AnyDAC_POSIX} S_AD_Profiles {$ENDIF});
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
begin
  FHistoryStorage := AValue;
  if not (csLoading in ComponentState) then
    GetLoginDialog.HistoryStorage := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetHistoryWithPassword(const AValue: Boolean);
begin
  FHistoryWithPassword := AValue;
  if not (csLoading in ComponentState) then
    GetLoginDialog.HistoryWithPassword := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetLoginRetries(const AValue: Integer);
begin
  FLoginRetries := AValue;
  if not (csLoading in ComponentState) then
    GetLoginDialog.LoginRetries := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetConnectionDef(const AConnectionDef: IADStanConnectionDef);
begin
  FConnectionDef := AConnectionDef;
  if not (csLoading in ComponentState) then
    GetLoginDialog.ConnectionDef := AConnectionDef;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.SetVisibleItems(const AValue: TStrings);
begin
  FVisibleItems.Assign(AValue);
  if not (csLoading in ComponentState) then
    GetLoginDialog.VisibleItems := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.IsVIS: Boolean;
begin
  Result := not ((VisibleItems.Count = 2) and
    (VisibleItems.IndexOf(S_AD_ConnParam_Common_UserName) >= 0) and
    (VisibleItems.IndexOf(S_AD_ConnParam_Common_Password) >= 0));
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxLoginDialog.GetAllLoginParams;
begin
  GetLoginDialog.GetAllLoginParams;
end;

{-------------------------------------------------------------------------------}
function TADGUIxLoginDialog.Execute(ALoginAction: TADGUIxLoginAction): Boolean;
begin
  Result := GetLoginDialog.Execute(ALoginAction);
end;

{-------------------------------------------------------------------------------}
{ TADGUIxScriptDialog                                                           }
{-------------------------------------------------------------------------------}
constructor TADGUIxScriptDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaption := S_AD_ScriptDialogDefCaption;
  FOptions := [ssCallstack, ssConsole, ssAutoHide];
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxScriptDialog.Destroy;
begin
  if FScriptDialog <> nil then begin
    (FScriptDialog as IADStanComponentReference).SetComponentReference(nil);
    FScriptDialog.OnShow := nil;
    FScriptDialog.OnHide := nil;
    FScriptDialog.OnProgress := nil;
    FScriptDialog.OnOutput := nil;
    FScriptDialog.OnInput := nil;
    FScriptDialog.OnPause := nil;
    FScriptDialog := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADGUIxScriptDialog.GetGUID: TGUID;
begin
  Result := IADGUIxScriptDialog;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptDialog.GetScriptDialog: IADGUIxScriptDialog;
begin
  if FScriptDialog = nil then begin
    ADCreateInterface(IADGUIxScriptDialog, FScriptDialog, True, Provider);
    (FScriptDialog as IADStanComponentReference).SetComponentReference(
      Self as IInterfaceComponentReference);
  end;
  Result := FScriptDialog;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.Loaded;
var
  oDlg: IADGUIxScriptDialog;
begin
  inherited Loaded;
  oDlg := GetScriptDialog;
  oDlg.Caption := FCaption;
  oDlg.Options := FOptions;
  oDlg.OnShow := DoOnShow;
  oDlg.OnHide := DoOnHide;
  oDlg.OnProgress := DoOnProgress;
  oDlg.OnOutput := DoOnOutput;
  oDlg.OnInput := DoOnInput;
  oDlg.OnPause := DoOnPause;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.DoOnHide(ASender: TObject);
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.DoOnShow(ASender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.DoOnProgress(ASender: TObject;
  const AInfoProvider: IADGUIxScriptDialogInfoProvider);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, AInfoProvider);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.DoOnOutput(ASender: TObject;
  const AStr: String);
begin
  if Assigned(FOnOutput) then
    FOnOutput(Self, AStr);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.DoOnInput(ASender: TObject;
  const APrompt: String; var AResult: String);
begin
  if Assigned(FOnInput) then
    FOnInput(Self, APrompt, AResult);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.DoOnPause(ASender: TObject;
  const APrompt: String);
begin
  if Assigned(FOnPause) then
    FOnPause(Self, APrompt);
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptDialog.GetCaption: String;
begin
  if not (csLoading in ComponentState) then
    Result := GetScriptDialog.Caption
  else
    Result := FCaption;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.SetCaption(const AValue: String);
begin
  FCaption := AValue;
  if not (csLoading in ComponentState) then
    GetScriptDialog.Caption := AValue;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptDialog.IsCS: Boolean;
begin
  Result := Caption <> S_AD_ScriptDialogDefCaption;
end;

{-------------------------------------------------------------------------------}
function TADGUIxScriptDialog.GetOptions: TADGUIxScriptOptions;
begin
  if not (csLoading in ComponentState) then
    Result := GetScriptDialog.Options
  else
    Result := FOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxScriptDialog.SetOptions(const AValue: TADGUIxScriptOptions);
begin
  FOptions := AValue;
  if not (csLoading in ComponentState) then
    GetScriptDialog.Options := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADGUIxWaitCursor                                                             }
{-------------------------------------------------------------------------------}
constructor TADGUIxWaitCursor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScreenCursor := gcrSQLWait;
end;

{-------------------------------------------------------------------------------}
destructor TADGUIxWaitCursor.Destroy;
begin
  if FWaitCursor <> nil then begin
    (FWaitCursor as IADStanComponentReference).SetComponentReference(nil);
    FWaitCursor.OnShow := nil;
    FWaitCursor.OnHide := nil;
    FWaitCursor := nil;
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
class function TADGUIxWaitCursor.GetGUID: TGUID;
begin
  Result := IADGUIxWaitCursor;
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursor.GetGUIxWaitCursor: IADGUIxWaitCursor;
begin
  if FWaitCursor = nil then begin
    ADCreateInterface(IADGUIxWaitCursor, FWaitCursor, True, Provider);
    (FWaitCursor as IADStanComponentReference).SetComponentReference(
      Self as IInterfaceComponentReference);
  end;
  Result := FWaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.Loaded;
var
  oCursor: IADGUIxWaitCursor;
begin
  inherited Loaded;
  oCursor := GetGUIxWaitCursor;
  oCursor.WaitCursor := FScreenCursor;
  oCursor.OnShow := DoOnShow;
  oCursor.OnHide := DoOnHide;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.SetProvider(const AValue: String);
begin
  inherited SetProvider(AValue);
  FADGUIxProvider := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.DoOnHide(ASender: TObject);
begin
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.DoOnShow(ASender: TObject);
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursor.GetScreenCursor: TADGUIxScreenCursor;
begin
  if not (csLoading in ComponentState) then
    Result := GetGUIxWaitCursor.WaitCursor
  else
    Result := FScreenCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursor.SetScreenCursor(const AValue: TADGUIxScreenCursor);
begin
  FScreenCursor := AValue;
  if not (csLoading in ComponentState) then
    GetGUIxWaitCursor.WaitCursor := AValue;
end;

end.
