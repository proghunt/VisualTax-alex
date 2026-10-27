{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                    FireDAC tracer                     }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanTracer;

interface

Uses
  SysUtils, Classes,
  uADStanError, uADStanUtil, uADStanIntf;

type
  TADTracer = class;

  { --------------------------------------------------------------------------- }
  { TADTracer                                                                   }
  { --------------------------------------------------------------------------- }
  TADTracer = class(TADThread)
  private
    FTraceFileName: String;
    FTraceFileHandler: TADTextFile;
    FTraceFileAppend: Boolean;
    FCounter: Int64;
    FTraceFileColumns: TADTraceFileColumns;
    FTraceFileEncoding: TADEncoding;
    procedure CheckInactive;
    procedure SetTraceFileName(const AValue: String);
    procedure SetTraceFileAppend(AValue: Boolean);
    procedure OpenTraceFiles;
    procedure CloseTraceFiles;
    procedure SetTraceFileEncoding(const Value: TADEncoding);
  protected
    class function GetStartMsgClass: TADThreadMsgClass; override;
    class function GetStopMsgClass: TADThreadMsgClass; override;
    class function GetTerminateMsgClass: TADThreadMsgClass; override;
    function DoAllowTerminate: Boolean; override;
    procedure DoActiveChanged; override;
    procedure DoIdle; override;
  public
    constructor Create;
    procedure TraceMsg(const AObjClassName, AObjName, AMsg: String);
    property TraceFileName: String read FTraceFileName write SetTraceFileName;
    property TraceFileAppend: Boolean read FTraceFileAppend write SetTraceFileAppend;
    property TraceFileColumns: TADTraceFileColumns read FTraceFileColumns write FTraceFileColumns;
    property TraceFileEncoding: TADEncoding read FTraceFileEncoding write SetTraceFileEncoding;
  end;

var
  FADShowTraces: Boolean = True;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF POSIX}
  Posix.Pthread,
{$ENDIF}
  SyncObjs,
  uADStanConst;

resourceString
  sMb_TracerPropertyChangeOnlyActiveFalse = 'Tracer has to be Active=false to change the properties';
  sMb_TracerTraceFileHasToBeOpen = 'Trace file has to be open for this action';
  sMb_TracerTraceFileHasToBeClosed = 'Trace file has to be closed for this action';
  sMb_TracerTraceFileNameNotAssigned = 'Trace file name has to be assigned';

var
  GTracesLock: TCriticalSection;
  GTraces: TADStringList = nil;

type
  TADTracerMsgBase = class;
  TADTracerStartMsg = class;
  TADTracerStopMsg = class;
  TADTracerTerminateMsg = class;
  TADTracerOutputMsg = class;

  { --------------------------------------------------------------------------- }
  { TADTracerMsgBase                                                            }
  { --------------------------------------------------------------------------- }
  TADTracerMsgBase = class(TADThreadMsgBase)
  private
    FCounter: Int64;
    FTime: TDateTime;
    FThreadID: LongWord;
  public
    constructor Create; override;
    function Perform(AThread: TADThread): Boolean; override;
    function AsString(AItems: TADTraceFileColumns): String; virtual;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerStartMsg                                                           }
  { --------------------------------------------------------------------------- }
  TADTracerStartMsg = class(TADTracerMsgBase)
  public
    constructor Create; override;
    function Perform(AThread: TADThread): Boolean; override;
    function AsString(AItems: TADTraceFileColumns): String; override;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerStopMsg                                                            }
  { --------------------------------------------------------------------------- }
  TADTracerStopMsg = class(TADTracerMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
    function AsString(AItems: TADTraceFileColumns): String; override;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerTerminateMsg                                                       }
  { --------------------------------------------------------------------------- }
  TADTracerTerminateMsg = class(TADTracerMsgBase)
  public
    function Perform(AThread: TADThread): Boolean; override;
    function AsString(AItems: TADTraceFileColumns): String; override;
  end;

  { --------------------------------------------------------------------------- }
  { TADTracerOutputMsg                                                          }
  { --------------------------------------------------------------------------- }
  TADTracerOutputMsg = class(TADTracerMsgBase)
  private
    FObjClassName: String;
    FObjID: String;
    FMsgText: String;
  public
    constructor Create(const AObjectClassName, AObjID, AMsgText: String); overload;
    function AsString(AItems: TADTraceFileColumns): String; override;
  end;

{ --------------------------------------------------------------------------- }
{ TADTracerMsgBase                                                            }
{ --------------------------------------------------------------------------- }
constructor TADTracerMsgBase.Create;
begin
  inherited Create;
  FCounter := ADGetPerformanceCounter();
  FTime := Time();
  FThreadID := GetCurrentThreadID;
end;

{ --------------------------------------------------------------------------- }
function TADTracerMsgBase.AsString(AItems: TADTraceFileColumns): String;
var
  s: String;
begin
  if tiRefNo in AItems then
    Result := Format('%8d ', [FCounter])
  else
    Result := '';
  if tiTime in AItems then begin
    DateTimeToString(s, 'hh:nn:ss.zzz ', FTime);
    Result := Result + s;
  end;
  if tiThreadID in AItems then
    Result := Result + Format('%8d ', [FThreadID]);
end;

{ --------------------------------------------------------------------------- }
function TADTracerMsgBase.Perform(AThread: TADThread): Boolean;
var
  oTracer: TADTracer;
begin
  oTracer := AThread as TADTracer;
  Inc(FCounter);
  Self.FCounter := FCounter;
  if oTracer.FTraceFileHandler <> nil then
    oTracer.FTraceFileHandler.WriteLine(AsString(oTracer.FTraceFileColumns));
  Result := True;
end;

{ --------------------------------------------------------------------------- }
{ TADTracerStartMsg                                                           }
{ --------------------------------------------------------------------------- }
constructor TADTracerStartMsg.Create;
begin
  inherited Create;
end;

{ --------------------------------------------------------------------------- }
function TADTracerStartMsg.Perform(AThread: TADThread): Boolean;
var
  oMsg: TADThreadStartMsg;
begin
  (AThread as TADTracer).OpenTraceFiles;
  inherited Perform(AThread);
  oMsg := TADThreadStartMsg.Create;
  try
    Result := oMsg.Perform(AThread);
  finally
    ADFree(oMsg);
  end;
end;

{ --------------------------------------------------------------------------- }
function TADTracerStartMsg.AsString(AItems: TADTraceFileColumns): String;
begin
  Result := inherited AsString(AItems) + '-=#!!! FireDAC Tracer started !!!#=-';
end;

{ --------------------------------------------------------------------------- }
{ TADTracerStopMsg                                                            }
{ --------------------------------------------------------------------------- }
function TADTracerStopMsg.Perform(AThread: TADThread): Boolean;
var
  oMsg: TADThreadStopMsg;
begin
  inherited Perform(AThread);
  (AThread as TADTracer).CloseTraceFiles;
  oMsg := TADThreadStopMsg.Create;
  try
    Result := oMsg.Perform(AThread);
  finally
    ADFree(oMsg);
  end;
end;

{ --------------------------------------------------------------------------- }
function TADTracerStopMsg.AsString(AItems: TADTraceFileColumns): String;
begin
  Result := inherited AsString(AItems) + '-=#!!! FireDAC Tracer stopped !!!#=-';
end;

{ --------------------------------------------------------------------------- }
{ TADTracerTerminateMsg                                                       }
{ --------------------------------------------------------------------------- }
function TADTracerTerminateMsg.Perform(AThread: TADThread): Boolean;
var
  oMsg: TADThreadTerminateMsg;
begin
  inherited Perform(AThread);
  oMsg := TADThreadTerminateMsg.Create;
  try
    Result := oMsg.Perform(AThread);
  finally
    ADFree(oMsg);
  end;
end;

{ --------------------------------------------------------------------------- }
function TADTracerTerminateMsg.AsString(AItems: TADTraceFileColumns): String;
begin
  Result := inherited AsString(AItems) + '-=#!!! FireDAC Tracer terminated !!!#=-';
end;

{ --------------------------------------------------------------------------- }
{ TADTracerOutputMsg                                                          }
{ --------------------------------------------------------------------------- }
constructor TADTracerOutputMsg.Create(const AObjectClassName, AObjID, AMsgText: String);
begin
  inherited Create;
  FObjClassName := AObjectClassName;
  FObjID := AObjID;
  FMsgText := AMsgText;
end;

{ --------------------------------------------------------------------------- }
function TADTracerOutputMsg.AsString(AItems: TADTraceFileColumns): String;
begin
  Result := inherited AsString(AItems);
  if tiClassName in AItems then
    Result := Result + ADPadR(FObjClassName, 32) + ' ';
  if tiObjID in AItems then
    Result := Result + ADPadR(FObjID, 20) + ' ';
  if tiMsgText in AItems then
    Result := Result + FMsgText;
end;

{ --------------------------------------------------------------------------- }
{ TADTracer                                                                   }
{ --------------------------------------------------------------------------- }
constructor TADTracer.Create;
begin
  inherited Create;
  FreeOnTerminate := False;
  FTraceFileAppend := C_AD_MonitorAppend;
  FTraceFileColumns := C_AD_MonitorColumns;
end;

{ --------------------------------------------------------------------------- }
class function TADTracer.GetStartMsgClass: TADThreadMsgClass;
begin
  Result := TADTracerStartMsg;
end;

{ --------------------------------------------------------------------------- }
class function TADTracer.GetStopMsgClass: TADThreadMsgClass;
begin
  Result := TADTracerStopMsg;
end;

{ --------------------------------------------------------------------------- }
class function TADTracer.GetTerminateMsgClass: TADThreadMsgClass;
begin
  Result := TADTracerTerminateMsg;
end;

{ --------------------------------------------------------------------------- }
function TADTracer.DoAllowTerminate: Boolean;
begin
  if Messages = nil then
    Result := True
  else begin
    Result := Messages.LockList.Count = 0;
    Messages.UnlockList;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.DoActiveChanged;
begin
  if not Active then
    while not DoAllowTerminate do
      Sleep(1);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.DoIdle;
begin
  if (FTraceFileHandler <> nil) and (FTraceFileHandler.Stream <> nil) and
     (FTraceFileHandler.Stream is TADFileStream) then
    TADFileStream(FTraceFileHandler.Stream).SyncBuffer(False);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.CheckInactive;
begin
  if Active then
    raise EADException.Create(sMb_TracerPropertyChangeOnlyActiveFalse);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.SetTraceFileName(const AValue: String);
begin
  CheckInactive;
  FTraceFileName := ADExpandStr(AValue);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.SetTraceFileAppend(AValue: Boolean);
begin
  CheckInactive;
  FTraceFileAppend := AValue;
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.SetTraceFileEncoding(const Value: TADEncoding);
begin
  CheckInactive;
  FTraceFileEncoding := Value;
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.OpenTraceFiles;
begin
  FCounter := 0;
  if FTraceFileHandler <> nil then
    raise EADException.Create(sMb_TracerTraceFileHasToBeClosed);
  if FTraceFileName = '' then
    raise EADException.Create(sMb_TracerTraceFileNameNotAssigned);
  FTraceFileHandler := TADTextFile.Create(FTraceFileName,
    False, FTraceFileAppend, FTraceFileEncoding, elWindows);
  FTraceFileHandler.WriteLine('--- new start of FireDAC Trace ---');
  if GTraces <> nil then begin
    GTracesLock.Enter;
    try
      if GTraces.IndexOf(FTraceFileName) = -1 then
        GTraces.Add(FTraceFileName);
    finally
      GTracesLock.Leave;
    end;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.CloseTraceFiles;
begin
  if FTraceFileHandler = nil then
    raise EADException.Create(sMb_TracerTraceFileHasToBeOpen);
  ADFreeAndNil(FTraceFileHandler);
end;

{ --------------------------------------------------------------------------- }
procedure TADTracer.TraceMsg(const AObjClassName, AObjName, AMsg: String);
begin
  if (Self <> nil) and Active then
    EnqueueMsg(TADTracerOutputMsg.Create(AObjClassName, AObjName, AMsg));
end;

{ --------------------------------------------------------------------------- }
procedure ShowTraces;
var
  sMsg: String;
begin
  sMsg := C_AD_Product + ' produced following application trace files:' +
    C_AD_EOL + GTraces.Text;
{$IFDEF MSWINDOWS}
  sMsg := sMsg + C_AD_EOL + 'Press OK to close application.';
{$ENDIF}
  ADSystemMessage(C_AD_Product + ' MonitorBy=FlatFile', sMsg, False);
end;

{ --------------------------------------------------------------------------- }
initialization
  GTracesLock := TCriticalSection.Create;
  GTraces := TADStringList.Create;

finalization
  GTracesLock.Enter;
  try
    if FADShowTraces and (GTraces.Count > 0) and not ADIsDesignTime then
      ShowTraces;
    ADFreeAndNil(GTraces);
  finally
    GTracesLock.Leave;
    ADFreeAndNil(GTracesLock);
  end;

end.
