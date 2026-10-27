{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{        FireDAC async execution implementation         }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADStanAsync"'}

unit uADStanAsync;

interface

implementation

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFDEF POSIX}
  Posix.Pthread,
{$ENDIF}
  SysUtils, Classes, SyncObjs,
  uADStanIntf, uADStanConst, uADStanError, uADStanFactory, uADStanUtil,
  uADGUIxIntf;

type
  TADAsyncThread = class;
  TADStanAsyncExecutor = class;

  TADAsyncThread = class(TThread)
  private
    FRunThreadId: TADThreadID;
    FEvent: TEvent;
    FExecutor: TADStanAsyncExecutor;
{$IFDEF AnyDAC_FPC}
    function GetFinished: Boolean;
{$ENDIF}
  protected
    procedure Execute; override;
  public
    constructor Create(AExecutor: TADStanAsyncExecutor);
    destructor Destroy; override;
    procedure WaitForLaunch;
{$IFDEF AnyDAC_FPC}
    property Finished: Boolean read GetFinished;
{$ENDIF}
  end;

  TADStanAsyncExecutor = class(TADObject, IADStanAsyncExecutor)
  private
    FOperationIntf: IADStanAsyncOperation;
    FHandlerIntf: IADStanAsyncHandler;
    FAsyncDlg: IADGUIxAsyncExecuteDialog;
    FWait: IADGUIxWaitCursor;
    FTimeout: LongWord;
    FState: TADStanAsyncState;
    FMode: TADStanAsyncMode;
    FThread: TADAsyncThread;
    FException: Exception;
    FSilentMode: Boolean;
    procedure ExecuteOperation(AStoreException: Boolean);
    procedure Cleanup;
  protected
    // IADStanAsyncExecutor
    function GetState: TADStanAsyncState;
    function GetMode: TADStanAsyncMode;
    function GetTimeout: LongWord;
    function GetOperation: IADStanAsyncOperation;
    function GetHandler: IADStanAsyncHandler;
    procedure Setup(const AOperation: IADStanAsyncOperation;
      const AMode: TADStanAsyncMode; const ATimeout: LongWord;
      const AHandler: IADStanAsyncHandler; ASilentMode: Boolean);
    procedure Run;
    procedure AbortJob;
    procedure Launched;
  public
    destructor Destroy; override;
  end;

var
  ADStanActiveAsyncsWithUI: Integer;

{-------------------------------------------------------------------------------}
{ TADAsyncThread                                                                }
{-------------------------------------------------------------------------------}
constructor TADAsyncThread.Create(AExecutor: TADStanAsyncExecutor);
begin
  inherited Create(True);
  FRunThreadId := GetCurrentThreadId;
  FExecutor := AExecutor;
  FExecutor._AddRef;
  FreeOnTerminate := True;
  FEvent := TEvent.Create(nil, False, False, '');
end;

{-------------------------------------------------------------------------------}
destructor TADAsyncThread.Destroy;
begin
  ADFreeAndNil(FEvent);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_FPC}
type
  __TThread = class
  private
    FHandle: TThreadID;
    FTerminated: Boolean;
    FFreeOnTerminate: Boolean;
    FFinished: Boolean;
  end;

function TADAsyncThread.GetFinished: Boolean;
begin
  Result := __TThread(Self).FFinished;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADAsyncThread.WaitForLaunch;
begin
  Resume;
  if FEvent <> nil then
    FEvent.WaitFor(1000);
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADAsyncThread.Execute;
begin
  try
    FExecutor.ExecuteOperation(True);
  finally
    FExecutor.Launched;
    FExecutor.FThread := nil;
    FExecutor._Release;
    Sleep(1);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADStanAsyncExecutor                                                          }
{-------------------------------------------------------------------------------}
destructor TADStanAsyncExecutor.Destroy;
begin
  Cleanup;
  FAsyncDlg := nil;
  FWait := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetMode: TADStanAsyncMode;
begin
  Result := FMode;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetState: TADStanAsyncState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetTimeout: LongWord;
begin
  Result := FTimeout;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetOperation: IADStanAsyncOperation;
begin
  Result := FOperationIntf;
end;

{-------------------------------------------------------------------------------}
function TADStanAsyncExecutor.GetHandler: IADStanAsyncHandler;
begin
  Result := FHandlerIntf;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.ExecuteOperation(AStoreException: Boolean);
begin
  try
    try
      try
        FState := asExecuting;
        FOperationIntf.Execute;
      except
        on E: Exception do begin
          if FState in [asInactive, asExecuting] then
            if (E is EADDBEngineException) and (EADDBEngineException(E).Kind = ekCmdAborted) then
              FState := asAborted
            else
              FState := asFailed;
          if AStoreException then
            FException := ADAcquireExceptionObject
          else
            raise;
        end;
      end;
      if FState in [asInactive, asExecuting] then
        FState := asFinished;
    finally
      if FMode = amAsync then
        if (FHandlerIntf <> nil) and AStoreException then
          FHandlerIntf.HandleFinished(nil, FState, FException);
    end;
  finally
    if FMode = amAsync then begin
      Cleanup;
      _Release;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.Setup(const AOperation: IADStanAsyncOperation;
  const AMode: TADStanAsyncMode; const ATimeout: LongWord;
  const AHandler: IADStanAsyncHandler; ASilentMode: Boolean);
begin
  try
    ASSERT(AOperation <> nil);
    FOperationIntf := AOperation;
    FHandlerIntf := AHandler;
    FTimeout := ATimeout;
    FMode := AMode;
    FState := asInactive;
    FSilentMode := ASilentMode;
    if FMode in [amNonBlocking, amCancelDialog] then
      if ADGUIxSilent() then
        FMode := amBlocking
      else if ADStanActiveAsyncsWithUI > 0 then
        ADException(Self, [S_AD_LStan], er_AD_StanCantNonblocking, [])
      else begin
        if FAsyncDlg = nil then
          ADCreateInterface(IADGUIxAsyncExecuteDialog, FAsyncDlg);
        Inc(ADStanActiveAsyncsWithUI);
      end;
    if not FSilentMode and (FMode <> amAsync) then
      if FWait = nil then
        ADCreateInterface(IADGUIxWaitCursor, FWait);
  except
    Cleanup;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.Cleanup;
begin
  FHandlerIntf := nil;
  if (FOperationIntf <> nil) and (FMode in [amNonBlocking, amCancelDialog]) then
    Dec(ADStanActiveAsyncsWithUI);
  FOperationIntf := nil;
  ADFreeAndNil(FException);
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.Run;
var
  oEx: Exception;
{$IFDEF MSWINDOWS}
  H: THandle;
  dwRes, dwWakeMask: LongWord;
  rMsg: TMsg;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  iStartTime: LongWord;
{$ENDIF}
begin
  ASSERT(FState = asInactive);
  // If command execution fails with error, and DBMS disconnects command (eg
  // PostgreSQL), then Unprepare releases last reference to TADStanAsyncExecutor.
  // As result FHandlerIntf.HandleFinished raises AV. So, just around execution
  // into AddRef / _Release.
  _AddRef;
  if (FWait <> nil) and not FSilentMode and (FMode <> amAsync) then
    FWait.StartWait;
  try
    try
      if (FMode = amBlocking) and (FTimeout = $FFFFFFFF) then
        ExecuteOperation(False)
      else begin
        { TODO -cASYNC : The thread pool must be used here }
        FThread := TADAsyncThread.Create(Self);
{$IFDEF MSWINDOWS}
        H := FThread.Handle;
{$ENDIF}
        FThread.WaitForLaunch;
        if FMode = amAsync then
          Exit;
        if FThread <> nil then
          try
            if FMode <> amBlocking then begin
              TADTimer.LockTimers;
              if FMode = amCancelDialog then
                FAsyncDlg.Show(Self);
{$IFDEF MSWINDOWS}
              dwWakeMask := QS_ALLINPUT;
            end
            else
              // Here was QS_POSTMESSAGE, but that may lead to AV. Because WM_PAINT
              // is handling too and GUI is not ready when a dataset is inactive.
              dwWakeMask := 0;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
            end;
{$ENDIF}
            try
{$IFDEF MSWINDOWS}
              while FThread <> nil do begin
                dwRes := MsgWaitForMultipleObjects(1, H, False, FTimeout, dwWakeMask);
                case dwRes of
                WAIT_FAILED, // most probably - already terminated
                WAIT_OBJECT_0:
                  Break;
                WAIT_OBJECT_0 + 1:
                  while (FThread <> nil) and PeekMessage(rMsg, 0, 0, 0, PM_REMOVE) do
                    if rMsg.Message = WM_QUIT then begin
                      AbortJob;
                      Halt(Byte(rMsg.WParam));
                    end
                    else if (FMode = amNonBlocking) or not (
                        (rMsg.message >= WM_KEYDOWN) and (rMsg.message <= WM_DEADCHAR) and
                          ((FAsyncDlg = nil) or not FAsyncDlg.IsFormActive) or
                        (rMsg.message >= WM_MOUSEFIRST) and (rMsg.message <= WM_MOUSELAST) and
                          ((FAsyncDlg = nil) or not FAsyncDlg.IsFormMouseMessage(rMsg)) or
                        (rMsg.message >= WM_SYSKEYDOWN) and (rMsg.message <= WM_SYSDEADCHAR)
                       ) then begin
                      TranslateMessage(rMsg);
                      DispatchMessage(rMsg);
                    end;
                WAIT_TIMEOUT:
                  begin
                    AbortJob;
                    FState := asExpired;
                    Break;
                  end;
                end;
              end;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
              iStartTime := ADGetTickCount;
              while (FThread <> nil) and not FThread.Finished and
                    not ADTimeout(iStartTime, FTimeout) do begin
                { TODO -cNEXTGEN : CheckSynchronize has to be replaced
                  with something other }
  {$IFDEF AnyDAC_FPC}
                CheckSynchronize();
  {$ENDIF}
                Sleep(0);
              end;
              if (FThread <> nil) and not FThread.Finished then begin
                AbortJob;
                FState := asExpired;
              end;
{$ENDIF}
            finally
              if FMode <> amBlocking then begin
                if FMode = amCancelDialog then
                  FAsyncDlg.Hide;
                TADTimer.UnLockTimers;
              end;
            end;
            if (FException <> nil) and not (
                (FException is EADDBEngineException) and
                (EADDBEngineException(FException).Kind = ekCmdAborted) and
                (FState in [asAborted, asExpired])
               ) then begin
              FState := asFailed;
              oEx := FException;
              FException := nil;
              raise oEx;
            end
            else if FState = asExpired then
              ADException(Self, [S_AD_LStan], er_AD_StanTimeout, [])
            else if FState = asAborted then
              Abort;
          except
            if FState in [asInactive, asExecuting] then
              FState := asFailed;
            raise;
          end;
        if FState in [asInactive, asExecuting] then
          FState := asFinished;
      end;
    finally
      if FMode <> amAsync then begin
        if (FWait <> nil) and not FSilentMode then
          FWait.StopWait;
        if FHandlerIntf <> nil then
          FHandlerIntf.HandleFinished(nil, FState, FException);
      end;
    end;
  finally
    if FMode <> amAsync then begin
      Cleanup;
      _Release;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.AbortJob;
begin
  FState := asAborted;
  if FThread <> nil then
    FThread.Terminate;
  if FOperationIntf <> nil then
    FOperationIntf.AbortJob;
end;

{-------------------------------------------------------------------------------}
procedure TADStanAsyncExecutor.Launched;
begin
  if FThread <> nil then
    FThread.FEvent.SetEvent;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  ADStanActiveAsyncsWithUI := 0;
  oFact := TADMultyInstanceFactory.Create(TADStanAsyncExecutor, IADStanAsyncExecutor);

finalization
  ADReleaseFactory(oFact);

end.
