{ ideas from PJCBView}

unit FP_2027CBListener;

interface

uses Windows,WinProcs,WinTypes,Messages,Classes;

type
  {
    monitors Windows clipboad and triggers an event whenever
    clipboard contents change.
  }
  TCBListener = class(TComponent)
  private {properties}
    fOnClipboardChanged: TNotifyEvent;
    fTriggerOnCreation: Boolean;
    fEnabled: Boolean;
  private
    fHWnd: HWND;
      {Handle of hidden window used as a clipboard viewer}
    fHWndNextViewer: HWND;
      {Handle of next clipboard viewer window in chain}
  protected
    procedure ClipboardChanged; dynamic;
      {Triggers OnClipboardChanged event if any handler is assigned and
      component is enabled}
    procedure Loaded; override;
      {Overrride of Loaded method to fire OnClipboardChanged event if required
      on component creation}
    procedure WndMethod(var Msg: TMessage); virtual;
      {Window procedure for hidden window}
  public
    constructor Create(AOwner: TComponent); override;
      {Class constructor: creates a hidden window, registers it as a clipboard
      viewer and sets default property values}
    destructor Destroy; override;
      {Class destructor: de-registers hidden window as clipboard viewer and
      disposes of it}
  published
    property OnClipboardChanged: TNotifyEvent
      read fOnClipboardChanged write fOnClipboardChanged;
      {Event triggered whenever clipboard contents change}
    property TriggerOnCreation: Boolean
      read fTriggerOnCreation write fTriggerOnCreation default True;
      {When true causes OnClipboardChanged event to be triggered as soon as
      component is created, otherwise OnClipboardChanged event only triggers
      when clipboard actually changes}
    property Enabled: Boolean read fEnabled write fEnabled default True;
      {When true component triggers events when clipboard changes, when false
      these events are not triggered}
  end;


procedure Register;
  {Component registration procedure}


implementation


uses Forms;


procedure TCBListener.ClipboardChanged;
  {Triggers OnClipboardChanged event if any handler is assigned and component is
  enabled}
begin
  try
    {Fire event if assigned and enabled}
    if Assigned(fOnClipboardChanged) and fEnabled then
      fOnClipboardChanged(Self);
  except
    {Ensure any un-caught exception is handled by application and then continue}
    Application.HandleException(Self);
  end;
end;

constructor TCBListener.Create(AOwner: TComponent);
  {Class constructor: creates a hidden window, registers it as a clipboard
  viewer and sets default property values}
begin
  inherited Create(AOwner);
  {Create hidden window to be used as clipboard viewer}
//  {$IFDEF DELPHI6ANDUP} //20150817 igor
    fHWnd := Classes.AllocateHWnd(WndMethod);
//  {$ELSE}
//    fHWnd := Forms.AllocateHWnd(WndMethod);
//  {$ENDIF}
  {Register hidden window as a clipboard viewer and store handle of next window
  in chain}
  fHWndNextViewer := SetClipboardViewer(fHWnd);
  {Set default property values}
  fTriggerOnCreation := True;
  fEnabled := True;
end;

destructor TCBListener.Destroy;
  {Class destructor: de-registers hidden window as clipboard viewer and disposes
  of it}
begin
  {Remove our hidden window from the chain of clipboard viewers}
  ChangeClipboardChain(fHWnd, fHWndNextViewer);
  {Get rid of the window}
//20150817 igor
//  {$IFDEF DELPHI6ANDUP}
    Classes.DeallocateHWnd(fHWnd);
//  {$ELSE}
//    Forms.DeallocateHWnd(fHWnd);
//  {$ENDIF}
  inherited Destroy;
end;

procedure TCBListener.Loaded;
  {Overrride of Loaded method to fire OnClipboardChanged event if required on
  component creation}
begin
  inherited Loaded;
  {If we're notifying a clipboard change event on creation then do it}
  if fTriggerOnCreation then
    ClipboardChanged;
end;

procedure TCBListener.WndMethod(var Msg: TMessage);
  {Window procedure for hidden window}
var
  Handled: Boolean; {flag true if we handle a message}
begin
	{Assume we've handled message}
  Handled := True;
  {Now process messages, handling the ones we want}
  with Msg do
  begin
  	case Msg of
      WM_DRAWCLIPBOARD:
      begin
        {Clipboard has changed: trigger event}
        ClipboardChanged;
        {Pass on message to next window in viewer chain (if any)}
        if fHWndNextViewer <> 0 then
          SendMessage(fHWndNextViewer, Msg, WParam, LParam);
      end;
      WM_CHANGECBCHAIN:
      begin
        {Windows is detaching a clipboard viewer}
        if HWND(WParam) = fHWndNextViewer then
          {Window being detached is next one: record new "next" window in chain}
          fHWndNextViewer := HWND(LParam)
        else
          {Window being detached is not next one: pass message along}
          if fHWndNextViewer <> 0 then
            SendMessage(fHWndNextViewer, Msg, WParam, LParam);
      end;
      else
      begin
        {We're not handling this message}
        Handled := False;
      end;
    end;
    {Check if we handled message}
    if Handled then
      {we did - return 0}
      Result := 0
    else
      {we didn't - pass message on to Windows}
      Result := DefWindowProc(fHWnd, Msg, WParam, LParam);
  end;
end;

procedure Register;
  {Component registration procedure}
begin
  RegisterComponents('CBListener', [TCBListener]);
end;

end.
