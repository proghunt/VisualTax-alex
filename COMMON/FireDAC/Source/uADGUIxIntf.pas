{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                FireDAC GUIx layer API                 }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxIntf;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes,
  uADStanIntf, uADStanError;

type
  IADGUIxLoginDialog = interface;
  IADGUIxWaitCursor = interface;
  IADGUIxAsyncExecuteDialog = interface;
  IADGUIxErrorDialog = interface;
  IADGUIxScriptDialogInfoProvider = interface;
  IADGUIxScriptDialog = interface;

  { --------------------------------------------------------------------------}
  { Login dialog                                                              }
  { --------------------------------------------------------------------------}
  TADGUIxLoginAction = procedure of object;
  TADGUIxLoginHistoryStorage = (hsRegistry, hsFile);
  TADGUIxLoginDialogEvent = procedure (ASender: TObject; var AResult: Boolean) of object;

  IADGUIxLoginDialog = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2200}']
    // private
    function GetConnectionDef: IADStanConnectionDef;
    function GetOnHide: TNotifyEvent;
    function GetOnShow: TNotifyEvent;
    function GetCaption: String;
    function GetChangeExpiredPassword: Boolean;
    function GetHistoryEnabled: Boolean;
    function GetHistoryKey: String;
    function GetHistoryStorage: TADGUIxLoginHistoryStorage;
    function GetHistoryWithPassword: Boolean;
    function GetLoginRetries: Integer;
    function GetOnChangePassword: TADGUIxLoginDialogEvent;
    function GetOnLogin: TADGUIxLoginDialogEvent;
    function GetVisibleItems: TStrings;
    procedure SetConnectionDef(const AValue: IADStanConnectionDef);
    procedure SetOnHide(const AValue: TNotifyEvent);
    procedure SetOnShow(const AValue: TNotifyEvent);
    procedure SetCaption(const AValue: String);
    procedure SetChangeExpiredPassword(const AValue: Boolean);
    procedure SetHistoryEnabled(const AValue: Boolean);
    procedure SetHistoryKey(const AValue: String);
    procedure SetHistoryStorage(const AValue: TADGUIxLoginHistoryStorage);
    procedure SetHistoryWithPassword(const AValue: Boolean);
    procedure SetLoginRetries(const AValue: Integer);
    procedure SetOnChangePassword(const AValue: TADGUIxLoginDialogEvent);
    procedure SetOnLogin(const AValue: TADGUIxLoginDialogEvent);
    procedure SetVisibleItems(const AValue: TStrings);
    // public
    procedure GetAllLoginParams;
    function Execute(AAction: TADGUIxLoginAction = nil): Boolean;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef write SetConnectionDef;
    property Caption: String read GetCaption write SetCaption;
    property HistoryEnabled: Boolean read GetHistoryEnabled write SetHistoryEnabled;
    property HistoryWithPassword: Boolean read GetHistoryWithPassword write SetHistoryWithPassword;
    property HistoryStorage: TADGUIxLoginHistoryStorage read GetHistoryStorage write SetHistoryStorage;
    property HistoryKey: String read GetHistoryKey write SetHistoryKey;
    property VisibleItems: TStrings read GetVisibleItems write SetVisibleItems;
    property LoginRetries: Integer read GetLoginRetries write SetLoginRetries;
    property ChangeExpiredPassword: Boolean read GetChangeExpiredPassword write SetChangeExpiredPassword;
    property OnHide: TNotifyEvent read GetOnHide write SetOnHide;
    property OnShow: TNotifyEvent read GetOnShow write SetOnShow;
    property OnLogin: TADGUIxLoginDialogEvent read GetOnLogin write SetOnLogin;
    property OnChangePassword: TADGUIxLoginDialogEvent read GetOnChangePassword write SetOnChangePassword;
  end;

  { --------------------------------------------------------------------------}
  { "Wait, working ..."                                                       }
  { --------------------------------------------------------------------------}
  TADGUIxScreenCursor = (gcrNone, gcrDefault, gcrHourGlass, gcrSQLWait, gcrAppWait);
  IADGUIxWaitCursor = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2201}']
    // private
    function GetWaitCursor: TADGUIxScreenCursor;
    procedure SetWaitCursor(const AValue: TADGUIxScreenCursor);
    function GetOnShow: TNotifyEvent;
    procedure SetOnShow(const AValue: TNotifyEvent);
    function GetOnHide: TNotifyEvent;
    procedure SetOnHide(const AValue: TNotifyEvent);
    // public
    procedure StartWait;
    procedure StopWait;
    procedure PushWait;
    procedure PopWait;
    procedure ForceStopWait;
    property WaitCursor: TADGUIxScreenCursor read GetWaitCursor write SetWaitCursor;
    property OnShow: TNotifyEvent read GetOnShow write SetOnShow;
    property OnHide: TNotifyEvent read GetOnHide write SetOnHide;
  end;

  { --------------------------------------------------------------------------}
  { Async execution dialog                                                    }
  { --------------------------------------------------------------------------}
  IADGUIxAsyncExecuteDialog = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2202}']
    // private
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
    // public
    procedure Show(const AExecutor: IADStanAsyncExecutor);
    procedure Hide;
{$IFDEF MSWINDOWS}
    function IsFormActive: Boolean;
    function IsFormMouseMessage(const AMsg: TMsg): Boolean;
{$ENDIF}
    property Caption: String read GetCaption write SetCaption;
    property Prompt: String read GetPrompt write SetPrompt;
    property ShowDelay: Integer read GetShowDelay write SetShowDelay;
    property HideDelay: Integer read GetHideDelay write SetHideDelay;
    property OnShow: TNotifyEvent read GetOnShow write SetOnShow;
    property OnHide: TNotifyEvent read GetOnHide write SetOnHide;
  end;

  { --------------------------------------------------------------------------}
  { Error dialog                                                              }
  { --------------------------------------------------------------------------}
  TADGUIxErrorDialogEvent = procedure (ASender: TObject; AException: EADDBEngineException) of object;
  IADGUIxErrorDialog = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2203}']
    // private
    function GetOnShow: TADGUIxErrorDialogEvent;
    procedure SetOnShow(const AValue: TADGUIxErrorDialogEvent);
    function GetOnHide: TADGUIxErrorDialogEvent;
    procedure SetOnHide(const AValue: TADGUIxErrorDialogEvent);
    function GetCaption: String;
    procedure SetCaption(const AValue: String);
    function GetEnabled: Boolean;
    procedure SetEnabled(const AValue: Boolean);
    function GetStayOnTop: Boolean;
    procedure SetStayOnTop(const AValue: Boolean);
    // public
    procedure Execute(E: EADDBEngineException);
    property Caption: String read GetCaption write SetCaption;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property StayOnTop: Boolean read GetStayOnTop write SetStayOnTop;
    property OnShow: TADGUIxErrorDialogEvent read GetOnShow write SetOnShow;
    property OnHide: TADGUIxErrorDialogEvent read GetOnHide write SetOnHide;
  end;

  { --------------------------------------------------------------------------}
  { Script dialog                                                             }
  { --------------------------------------------------------------------------}
  IADGUIxScriptDialogInfoProvider = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2206}']
    // private
    function GetCallStack: TStrings;
    function GetTotalJobSize: Integer;
    function GetTotalJobDone: Integer;
    function GetTotalPct10Done: Integer;
    function GetTotalErrors: Integer;
    function GetIsRunning: Boolean;
    // public
    procedure RequestStop;
    property CallStack: TStrings read GetCallStack;
    property TotalJobSize: Integer read GetTotalJobSize;
    property TotalJobDone: Integer read GetTotalJobDone;
    property TotalPct10Done: Integer read GetTotalPct10Done;
    property TotalErrors: Integer read GetTotalErrors;
    property IsRunning: Boolean read GetIsRunning;
  end;

  TADGUIxScriptProgressEvent = procedure (ASender: TObject;
    const AInfoProvider: IADGUIxScriptDialogInfoProvider) of object;
  TADGUIxScriptOutputEvent = procedure (ASender: TObject; const AStr: String) of object;
  TADGUIxScriptInputEvent = procedure (ASender: TObject; const APrompt: String;
    var AResult: String) of object;
  TADGUIxScriptPauseEvent = procedure (ASender: TObject; const APrompt: String) of object;
  TADGUIxScriptOptions = set of (ssCallstack, ssConsole, ssAutoHide);
  TADScriptOuputKind = (soSeparator, soEcho, soScript, soInfo, soError, soConnect,
    soServerOutput, soUserOutput, soCommand, soMacro, soData, soParam);

  IADGUIxScriptDialog = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2205}']
    // private
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
    // public
    procedure Show;
    procedure Progress(const AInfoProvider: IADGUIxScriptDialogInfoProvider);
    procedure Output(const AStr: String; AKind: TADScriptOuputKind);
    procedure Input(const APrompt: String; var AResult: String);
    procedure Pause(const APrompt: String);
    procedure Hide;
    property Caption: String read GetCaption write SetCaption;
    property Options: TADGUIxScriptOptions read GetOptions write SetOptions;
    property OnShow: TNotifyEvent read GetOnShow write SetOnShow;
    property OnHide: TNotifyEvent read GetOnHide write SetOnHide;
    property OnProgress: TADGUIxScriptProgressEvent read GetOnProgress write SetOnProgress;
    property OnOutput: TADGUIxScriptOutputEvent read GetOnOutput write SetOnOutput;
    property OnInput: TADGUIxScriptInputEvent read GetOnInput write SetOnInput;
    property OnPause: TADGUIxScriptPauseEvent read GetOnPause write SetOnPause;
  end;

var
  FADGUIxSilentMode: Boolean;
  FADGUIxProvider: String;

  function ADGUIxSilent: Boolean;

implementation

uses
  SysUtils,
  uADStanConst, uADStanUtil;

{-------------------------------------------------------------------------------}
function ADGUIxSilent: Boolean;
begin
  Result := FADGUIxSilentMode or ({$IFDEF AnyDAC_D16} TThread.CurrentThread.ThreadID {$ELSE}
    GetCurrentThreadID {$ENDIF} <> MainThreadID);
end;

{-------------------------------------------------------------------------------}
initialization

  FADGUIxSilentMode := {$IFDEF MSWINDOWS} IsConsole {$ELSE} False {$ENDIF};
{$IFDEF MSWINDOWS}
  if IsConsole then
    FADGUIxProvider := C_AD_GUIxConsoleProvider
  else
{$ENDIF}
  if ADIsDesignTime then
    FADGUIxProvider := C_AD_GUIxFormsProvider
  else if GetClass('TFmxObject') = nil then
{$IFDEF AnyDAC_POSIX}
    FADGUIxProvider := C_AD_GUIxConsoleProvider
{$ELSE}
    FADGUIxProvider := C_AD_GUIxFormsProvider
{$ENDIF}
  else
    FADGUIxProvider := C_AD_GUIxFMXProvider;

end.
