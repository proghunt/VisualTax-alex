{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{      FireDAC monitor TCP/IP based implementation      }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADMoniRemoteBase;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes, SysUtils, SyncObjs,
{$IFDEF AnyDAC_FPC}
  ssockets,
{$ELSE}
  ScktComp,
{$ENDIF}
  uADStanUtil, uADStanIntf;

type
  // common
  TADMoniRemoteQueueItem = class;
  TADMoniRemoteQueue = class;
  TADMoniRemoteQueueWorker = class;
  TADMoniRemoteStream = class;
  TADMoniRemoteAdapterList = class;
  EADMoniException = class(Exception);

  {----------------------------------------------------------------------------}
  { TADMoniRemoteQueueItem                                                     }
  {----------------------------------------------------------------------------}
  TADMoniRemoteQueueEventKind = (ptNone, ptConnectClient, ptDisConnectClient,
    ptRegisterAdapter, ptUnRegisterAdapter, ptUpdateAdapter, ptNotify);
  TADMoniRemoteQueueEventKinds = set of TADMoniRemoteQueueEventKind;
  TADMoniRemoteQueueItem = class(TObject)
  private
    procedure SetArg(AArg: PVarRec);
  public
    FProcessID: LongWord;
    FMonitorID: LongWord;
    FEvent: TADMoniRemoteQueueEventKind;
    FKind: TADMoniEventKind;
    FStep: TADMoniEventStep;
    FHandle: LongWord;
    FMessage: String;
    FPath: String;
    FArgs: TMemoryStream;
    FProc: Pointer;
    FTime: LongWord;
    constructor Create;
    destructor Destroy; override;
    procedure SetArgs(const AArgs: array of const); overload;
    procedure SetArgs(const AArgs: Variant); overload;
    function GetArgs: Variant;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteQueue                                                         }
  {----------------------------------------------------------------------------}
  TADMoniRemoteQueue = class(TObject)
  private
    FList: TADObjList;
    FThread: TADMoniRemoteQueueWorker;
    FOnPostItem: TNotifyEvent;
    FQueueCriticalSection: TCriticalSection;
    function GetCount: Integer;
  public
    constructor Create(AThread: TADMoniRemoteQueueWorker);
    destructor Destroy; override;
    function GetItem: TADMoniRemoteQueueItem;
    function GetNextEvent: TADMoniRemoteQueueEventKind;
    procedure PostItem(AItem: TADMoniRemoteQueueItem);
    procedure Clear;
    property Count: Integer read GetCount;
    property OnPostItem: TNotifyEvent read FOnPostItem write FOnPostItem;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteQueueWorker                                                   }
  {----------------------------------------------------------------------------}
  TADMoniRemoteQueueWorker = class(TThread)
  private
    FItemAvailableEvent: TEvent;
  protected
    procedure DoAction; virtual; abstract;
    function GetQueue: TADMoniRemoteQueue; virtual; abstract;
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AbortProcessing;
    procedure Signal;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteStream                                                        }
  {----------------------------------------------------------------------------}
  TADMoniRemoteStreamOpenMode = (omRead, omWrite);
  TADMoniRemoteStreamBlockID = LongWord;
  TADMoniRemoteStream = class(TObject)
  private
    FConnection: {$IFNDEF AnyDAC_FPC} TCustomWinSocket {$ELSE} TSocketStream {$ENDIF};
    FBuffer: TMemoryStream;
    FBlockLevel: Integer;
    FMode: TADMoniRemoteStreamOpenMode;
    FEncoder: TADEncoder;
    procedure WriteBytes(const ABuff; ALen: Integer);
    procedure WriteValueHeader(const AParamName: String; AType: TADAnsiChar);
    procedure ReadBytes(var ABuff; ALen: Integer);
    procedure ReadValueHeader(const AParamName: String; AType: TADAnsiChar);
    procedure ReceiveBuffer;
    procedure SendBuffer;
  public
    procedure Open(AConnection: {$IFNDEF AnyDAC_FPC} TCustomWinSocket {$ELSE} TSocketStream {$ENDIF};
      AMode: TADMoniRemoteStreamOpenMode);
    procedure Close;
    function IsOpen: Boolean;
    procedure WriteBeginBlock(AID: TADMoniRemoteStreamBlockID);
    procedure WriteEndBlock;
    procedure WriteString(const AParamName: String; const AValue: String);
    procedure WriteBlob(const AParamName: String; AValue: TMemoryStream);
    procedure WriteBoolean(const AParamName: String; AValue: Boolean);
    procedure WriteInteger(const AParamName: String; AValue: Integer);
    procedure WriteLongWord(const AParamName: String; AValue: LongWord);
    procedure WriteFloat(const AParamName: String; AValue: Double);
    procedure WriteDate(const AParamName: String; AValue: TDateTime);

    procedure ReadBeginBlock(AID: TADMoniRemoteStreamBlockID);
    procedure ReadEndBlock;
    function IsEndBlock: Boolean;
    function ReadString(const AParamName: String): String;
    procedure ReadBlob(const AParamName: String; AValue: TMemoryStream);
    function ReadBoolean(const AParamName: String): Boolean;
    function ReadInteger(const AParamName: String): Integer;
    function ReadLongWord(const AParamName: String): LongWord;
    function ReadFloat(const AParamName: String): Double;
    function ReadDate(const AParamName: String): TDateTime;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteAdapterList                                                   }
  {----------------------------------------------------------------------------}
  TADMoniRemoteAdapterList = class(TObject)
  private
    FList: TADStringList;
    function GetCount: Integer;
    function GetPath(AIndex: Integer): string;
    function GetHandle(AIndex: Integer): LongWord;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function IndexOf(AHandle: LongWord): Integer;
    function FindByHandle(AHandle: LongWord): string;
    function FindByPath(const APath: string): LongWord;
    procedure AddAdapter(const APath: string; AHandle: LongWord);
    procedure RemoveAdapter(AHandle: LongWord);
    property Count: Integer read GetCount;
    property Paths[AIndex: Integer]: string read GetPath;
    property Handles[AIndex: Integer]: LongWord read GetHandle;
  end;

const
  C_AD_Mon_PacketVersion: Integer = 1;
  C_AD_Mon_PacketBodyBlockID: Integer = 0;

  S_AD_MsgVersion: String = 'VER';
  S_AD_MsgEvent: String = 'EVT';
  S_AD_MsgProcessId: String = 'PID';
  S_AD_MsgMonitorId: String = 'MID';
  S_AD_MsgText: String = 'MSG';
  S_AD_MsgArgs: String = 'ARG';
  S_AD_MsgAdapterHandle: String = 'HND';
  S_AD_MsgNotifyKind: String = 'KND';
  S_AD_MsgNotifyStep: String = 'STP';
  S_AD_MsgTime: String = 'TIM';

  function ADMoniRemoteIsLocalHost(const AIP: String): Boolean;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX,
{$ENDIF}
{$IFDEF AnyDAC_D18}
  {$IFNDEF NEXTGEN}
  System.AnsiStrings,
  {$ENDIF}
{$ENDIF}
  uADStanResStrs;

const
  C_AD_Mon_StringHeader:    TADAnsiChar = TADAnsiChar('S');
  C_AD_Mon_BooleanHeader:   TADAnsiChar = TADAnsiChar('B');
  C_AD_Mon_IntegerHeader:   TADAnsiChar = TADAnsiChar('I');
  C_AD_Mon_FloatHeader:     TADAnsiChar = TADAnsiChar('F');
  C_AD_Mon_DateHeader:      TADAnsiChar = TADAnsiChar('D');
  C_AD_Mon_BlobHeader:      TADAnsiChar = TADAnsiChar('L');
  C_AD_Mon_BeginBlockDelim: TADAnsiChar = TADAnsiChar('{');
  C_AD_Mon_EndBlockDelim:   TADAnsiChar = TADAnsiChar('}');

var
  GEmptyObj, GNullObj: TADValWrapper;

{-------------------------------------------------------------------------------}
function ADMoniRemoteIsLocalHost(const AIP: String): Boolean;
begin
  Result := (AIP <> '127.0.0.1') and (LowerCase(AIP) <> 'localhost');
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteQueueItem                                                        }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteQueueItem.Create;
begin
  inherited Create;
  FArgs := TMemoryStream.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteQueueItem.Destroy;
begin
  ADFreeAndNil(FArgs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteQueueItem.SetArg(AArg: PVarRec);
var
  iLen: Integer;
  bByte: Byte;
begin
  FArgs.WriteBuffer(AArg^.VType, SizeOf(AArg^.VType));
  case AArg^.VType of
    vtInteger:
      FArgs.WriteBuffer(AArg^.VInteger, SizeOf(AArg^.Vinteger));
    vtBoolean:
      FArgs.WriteBuffer(AArg^.VBoolean, SizeOf(AArg^.VBoolean));
    vtChar:
      FArgs.WriteBuffer(AArg^.VChar, SizeOf(AArg^.VChar));
    vtExtended:
      FArgs.WriteBuffer(AArg^.VExtended^, SizeOf(AArg^.VExtended^));
    vtString:
      begin
        iLen := Length(AArg^.VString^);
        FArgs.WriteBuffer(iLen, SizeOf(iLen));
        if iLen > 0 then
        {$IFDEF NEXTGEN}
          FArgs.WriteBuffer(String(AArg^.VString^)[1], iLen);
        {$ELSE}
          FArgs.WriteBuffer(AArg^.VString^[1], iLen);
        {$ENDIF}
      end;
    vtPointer:
      FArgs.WriteBuffer(TADNativeInt(AArg^.VPointer), SizeOf(AArg^.VPointer));
    vtPChar:
      begin
        iLen := {$IFDEF AnyDAC_D18} {$IFNDEF NEXTGEN} System.AnsiStrings. {$ENDIF} {$ENDIF}
          StrLen(AArg^.VPChar);
        FArgs.WriteBuffer(iLen, SizeOf(iLen));
        if iLen > 0 then
        {$IFDEF NEXTGEN}
          FArgs.WriteBuffer(PChar(AArg^.VPChar)^, iLen);
        {$ELSE}
          FArgs.WriteBuffer(AArg^.VPChar^, iLen);
        {$ENDIF}
      end;
    vtAnsiString:
      begin
        iLen := Length( {$IFDEF NEXTGEN} String {$ELSE} AnsiString {$ENDIF} (AArg^.VAnsiString));
        FArgs.WriteBuffer(iLen, SizeOf(iLen));
        if iLen > 0 then
        {$IFDEF NEXTGEN}
          FArgs.WriteBuffer(PChar(String(AArg^.VAnsiString))^, iLen);
        {$ELSE}
          FArgs.WriteBuffer(PAnsiChar(AnsiString(AArg^.VAnsiString))^, iLen);
        {$ENDIF}
      end;
    vtCurrency:
      FArgs.WriteBuffer(AArg^.VCurrency^, SizeOf(AArg^.VCurrency^));
    vtWideChar:
      FArgs.WriteBuffer(AArg^.VWideChar, SizeOf(AArg^.VWideChar));
    vtWideString:
      begin
        iLen := Length(WideString(AArg^.VWideString)) * SizeOf(WideChar);
        FArgs.WriteBuffer(iLen, SizeOf(iLen));
        if iLen > 0 then
          FArgs.WriteBuffer(PWideChar(WideString(AArg^.VWideString))^, iLen);
      end;
    vtPWideChar:
      begin
        iLen := ADWideStrLen(AArg^.VPWideChar) * SizeOf(WideChar);
        FArgs.WriteBuffer(iLen, SizeOf(iLen));
        if iLen > 0 then
          FArgs.WriteBuffer(AArg^.VPWideChar^, iLen);
      end;
    vtInt64:
      FArgs.WriteBuffer(AArg^.VInt64^, SizeOf(AArg^.VInt64^));
    vtObject:
      begin
        // special case - for NULL and Unassigned
        ASSERT((TObject(AArg^.VObject) is TADValWrapper) and
               ((TADValWrapper(AArg^.VObject).AsInt = 0) or
                (TADValWrapper(AArg^.VObject).AsInt = 1)));
        bByte := Byte(TADValWrapper(AArg^.VObject).AsInt);
        FArgs.WriteBuffer(bByte, SizeOf(bByte));
      end;
{$IFDEF AnyDAC_D12}
    vtUnicodeString:
      begin
        iLen := Length(UnicodeString(AArg^.VUnicodeString)) * SizeOf(WideChar);
        FArgs.WriteBuffer(iLen, SizeOf(iLen));
        if iLen > 0 then
          FArgs.WriteBuffer(PWideChar(UnicodeString(AArg^.VUnicodeString))^,
            iLen);
      end;
{$ENDIF}
    else
      // vtObject, vtClass, vtVariant, vtInterface
      ASSERT(FALSE);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteQueueItem.SetArgs(const AArgs: array of const);
var
  i, iLen: Integer;
begin
  iLen := High(AArgs);
  if iLen = -1 then
    Exit;
  FArgs.WriteBuffer(iLen, SizeOf(iLen));
  for i := 0 to iLen do
    SetArg(@AArgs[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteQueueItem.SetArgs(const AArgs: Variant);
var
  i, iLen: Integer;
  V: Variant;
  rVD: TVarData;

  procedure SetVarRec(const AArgs: array of const);
  begin
    SetArg(@AArgs[0]);
  end;

  procedure SetCustom;
  begin
    SetVarRec(['CT: ' + String(V)])
  end;

  procedure SetArray;
  var
    i, iLen: Integer;
    s: String;
  begin
    s := '';
    iLen := VarArrayHighBound(V, 1);
    for i := 0 to iLen - 1 do begin
      s := s + String(V[i]);
      if i < iLen - 1 then
        s := s + ',';
    end;
    SetVarRec(['ARR: <' + s + '>']);
  end;

begin
  if VarIsNull(AArgs) or VarIsEmpty(AArgs) then
    Exit;
  iLen := VarArrayHighBound(AArgs, 1);
  FArgs.WriteBuffer(iLen, SizeOf(iLen));
  for i := 0 to iLen do begin
    V := AArgs[i];
    rVD := TVarData(V);
    case rVD.VType of
      varSmallInt: SetVarRec([rVD.VSmallInt]);
      varInteger:  SetVarRec([rVD.VInteger]);
      varSingle:   SetVarRec([rVD.VSingle]);
      varDouble:   SetVarRec([rVD.VDouble]);
      varCurrency: SetVarRec([rVD.VCurrency]);
      varDate:     SetVarRec([rVD.VDate]);
      varOleStr:   SetVarRec([rVD.VOleStr]);
      varBoolean:  SetVarRec([rVD.VBoolean]);
      varByte:     SetVarRec([rVD.VByte]);
{$IFDEF AnyDAC_D6Base}
      varShortInt: SetVarRec([rVD.VShortInt]);
      varWord:     SetVarRec([rVD.VWord]);
      varLongWord: SetVarRec([rVD.VLongWord]);
      varInt64:    SetVarRec([rVD.VInt64]);
{$ELSE}
      varInt64:    SetVarRec([Decimal(V).lo64]);
{$ENDIF}
      varString:   SetVarRec([String(rVD.VString)]);
{$IFDEF AnyDAC_D12}
      varUInt64:   SetVarRec([rVD.VUInt64]);
      varUString:  SetVarRec([UnicodeString(rVD.VUString)]);
{$ENDIF}
      // special case - for NULL and Unassigned
      varEmpty:    SetVarRec([GEmptyObj]);
      varNull:     SetVarRec([GNullObj]);
    else
{$IFDEF AnyDAC_D6Base}
      if VarIsCustom(V) then
        SetCustom
      else
{$ENDIF}
      if VarIsArray(V) then
        SetArray
      else
        // varAny, varByRef, varDispatch, varError, varUnknown, varVariant
        ASSERT(FALSE);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteQueueItem.GetArgs: Variant;
var
  i, iLen: Integer;
  iType: Byte;
  iInteger: Integer;
  lBoolean: Boolean;
  cChar: TADAnsiChar;
  fExtended: Extended;
  sString: {$IFDEF NEXTGEN} String {$ELSE} AnsiString {$ENDIF};
  lwLongword: LongWord;
  cCurrency: Currency;
  wsString: TADWideString;
  wcChar: WideChar;
  lliInt64: Int64;
  bByte: Byte;
{$IFNDEF AnyDAC_D6Base}
  V: Variant;
{$ENDIF}
begin
  if FArgs.Read(iLen, SizeOf(iLen)) = 0 then begin
    Result := Unassigned;
    Exit;
  end;
  Result := VarArrayCreate([0, iLen], varVariant);
  for i := 0 to iLen do begin
    FArgs.ReadBuffer(iType, SizeOf(iType));
    case iType of
      vtInteger:
        begin
          FArgs.ReadBuffer(iInteger, SizeOf(integer));
          Result[i] := iInteger;
        end;
      vtBoolean:
        begin
          FArgs.ReadBuffer(lBoolean, SizeOf(lBoolean));
          Result[i] := lBoolean;
        end;
      vtChar:
        begin
          FArgs.ReadBuffer(cChar, SizeOf(cChar));
          Result[i] := cChar;
        end;
      vtExtended:
        begin
          FArgs.ReadBuffer(fExtended, SizeOf(fExtended));
          Result[i] := fExtended;
        end;
      vtString, vtPChar, vtAnsiString:
        begin
          FArgs.ReadBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then begin
            SetLength(sString, iLen);
            FArgs.ReadBuffer(sString[1], iLen);
          end
          else
            sString := '';
          Result[i] := sString;
        end;
      vtPointer:
        begin
          FArgs.ReadBuffer(lwLongword, SizeOf(lwLongword));
{$IFDEF AnyDAC_D6Base}
          Result[i] := lwLongword;
{$ELSE}
          Result[i] := Integer(lwLongword);
{$ENDIF}
        end;
      vtCurrency:
        begin
          FArgs.ReadBuffer(cCurrency, SizeOf(cCurrency));
          Result[i] := cCurrency;
        end;
      vtWideString, vtPWideChar, {$IFDEF AnyDAC_D12} vtUnicodeString {$ELSE} 17 {$ENDIF}:
        begin
          FArgs.ReadBuffer(iLen, SizeOf(iLen));
          if iLen > 0 then begin
            SetLength(wsString, iLen div SizeOf(WideChar));
            FArgs.ReadBuffer(wsString[1], iLen);
          end
          else
            wsString := '';
          Result[i] := wsString;
        end;
      vtWideChar:
        begin
          FArgs.ReadBuffer(wcChar, SizeOf(wcChar));
          Result[i] := wcChar;
        end;
      vtInt64:
        begin
          FArgs.ReadBuffer(lliInt64, SizeOf(lliInt64));
{$IFDEF AnyDAC_D6Base}
          Result[i] := lliInt64;
{$ELSE}
          TVarData(V).VType := varInt64;
          Decimal(V).lo64 := lliInt64;
          Result[i] := V;
{$ENDIF}
        end;
      vtObject:
        begin
          // special case - for NULL and Unassigned
          FArgs.ReadBuffer(bByte, SizeOf(bByte));
          if bByte = 0 then
            Result[i] := Unassigned
          else if bByte = 1 then
            Result[i] := Null;
        end;
      else
        // vtObject, ctClass, vtVariant, vtInterface
        ASSERT(FALSE);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteQueue                                                            }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteQueue.Create(AThread: TADMoniRemoteQueueWorker);
begin
  inherited Create;
  FThread := AThread;
  FList := TADObjList.Create;
  FQueueCriticalSection := TCriticalSection.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteQueue.Destroy;
begin
  FThread := nil;
  ADFreeAndNil(FList);
  ADFreeAndNil(FQueueCriticalSection);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteQueue.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteQueue.GetNextEvent: TADMoniRemoteQueueEventKind;
begin
  FQueueCriticalSection.Enter;
  try
    if FList.Count > 0 then
      Result := TADMoniRemoteQueueItem(FList[0]).FEvent
    else
      Result := ptNone;
  finally
    FQueueCriticalSection.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteQueue.GetItem: TADMoniRemoteQueueItem;
begin
  FQueueCriticalSection.Enter;
  try
    if FList.Count > 0 then begin
      Result := TADMoniRemoteQueueItem(FList[0]);
      FList.Delete(0);
    end
    else
      Result := nil;
  finally
    FQueueCriticalSection.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteQueue.PostItem(AItem: TADMoniRemoteQueueItem);
var
  i: Integer;
  lSignal: Boolean;
begin
  i := 10;
  while (i > 0) and (FList.Count > 100) do begin
    Dec(i);
    Sleep(1);
  end;
  FQueueCriticalSection.Enter;
  try
    if FList.Count > 1000 then
      FList.Clear;
    lSignal := (FList.Count = 0);
    FList.Add(AItem);
  finally
    FQueueCriticalSection.Leave;
  end;
  if lSignal then
    FThread.Signal;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteQueue.Clear;
var
  i: Integer;
begin
  FQueueCriticalSection.Enter;
  try
    for i := 0 to FList.Count - 1 do
      ADFree(TADMoniRemoteQueueItem(FList[i]));
    FList.Clear;
  finally
    FQueueCriticalSection.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteQueueWorker                                                      }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteQueueWorker.Create;
begin
  inherited Create(True);
  FItemAvailableEvent := TEvent.Create(nil, False, False, '');
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteQueueWorker.Destroy;
begin
  AbortProcessing;
  ADFreeAndNil(FItemAvailableEvent);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteQueueWorker.Execute;
begin
  while not Terminated do begin
    if FItemAvailableEvent.WaitFor(INFINITE) = wrSignaled then
      while not Terminated and (GetQueue <> nil) and (GetQueue.Count > 0) do
        DoAction
    else
      Terminate;
  end;
  Sleep(10);
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADMoniRemoteQueueWorker.AbortProcessing;
begin
  if Suspended then
    Resume;
  if not Terminated then begin
    Terminate;
    Signal;
    WaitFor;
  end;
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteQueueWorker.Signal;
begin
  FItemAvailableEvent.SetEvent;
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteStream                                                           }
{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteBytes(const ABuff; ALen: Integer);
begin
  FBuffer.WriteBuffer(ABuff, ALen);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteValueHeader(const AParamName: String;
  AType: TADAnsiChar);
{$IFDEF AnyDAC_DEBUG}
var
  iLen: Integer;
  sb: TADByteString;
{$ENDIF}
begin
{$IFDEF AnyDAC_DEBUG}
  WriteBytes(AType, SizeOf(AType));
  sb := FEncoder.Encode(AParamName);
  iLen := ADByteStrLength(sb);
  WriteBytes(iLen, SizeOf(iLen));
  if iLen > 0 then
    WriteBytes(PADByteString(sb)^, iLen);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.ReadBytes(var ABuff; ALen: Integer);
begin
  FBuffer.ReadBuffer(ABuff, ALen);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.ReadValueHeader(const AParamName: String; AType: TADAnsiChar);
{$IFDEF AnyDAC_DEBUG}
var
  ch: TADAnsiChar;
  iLen: Integer;
  sPName: TADByteString;
  s: String;
{$ENDIF}
begin
{$IFDEF AnyDAC_DEBUG}
  ReadBytes(ch, SizeOf(ch));
  if ch <> AType then
    raise EADMoniException.Create(S_AD_MonEncounterType);
  ReadBytes(iLen, SizeOf(iLen));
  if iLen > 0 then begin
    SetLength(sPName, iLen);
    ReadBytes(PADByteString(sPName)^, iLen);
    s := FEncoder.Decode(sPName);
    if CompareText(AParamName, s) <> 0 then
      raise EADMoniException.Create(S_AD_MonEncounterParamName);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.ReceiveBuffer;
var
  iSize: Integer;
begin
  if FConnection.{$IFNDEF AnyDAC_FPC} ReceiveBuf {$ELSE} Read {$ENDIF} (iSize, SizeOf(iSize)) <> SizeOf(iSize) then
    raise EADMoniException.Create(S_AD_MonEncounterEOF);
  FBuffer.Size := iSize;
  if FConnection.{$IFNDEF AnyDAC_FPC} ReceiveBuf {$ELSE} Read {$ENDIF} (FBuffer.Memory^, iSize) <> iSize then
    raise EADMoniException.Create(S_AD_MonEncounterEOF);
  FBuffer.Position := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.SendBuffer;
var
  iSize: Integer;
begin
  iSize := FBuffer.Size;
  FConnection.{$IFNDEF AnyDAC_FPC} SendBuf {$ELSE} Write {$ENDIF} (iSize, SizeOf(iSize));
  FConnection.{$IFNDEF AnyDAC_FPC} SendBuf {$ELSE} Write {$ENDIF} (FBuffer.Memory^, iSize);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.Open(AConnection: {$IFNDEF AnyDAC_FPC} TCustomWinSocket {$ELSE} TSocketStream {$ENDIF};
  AMode: TADMoniRemoteStreamOpenMode);
begin
  FEncoder := TADEncoder.Create(nil);
  FBuffer := TMemoryStream.Create;
  FConnection := AConnection;
  FBlockLevel := 0;
  FMode := AMode;
  if FMode = omRead then
    try
      ReceiveBuffer;
    except
      Close;
      raise;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.Close;
begin
  try
    if FMode = omWrite then
      SendBuffer;
  finally
    ADFreeAndNil(FBuffer);
    ADFreeAndNil(FEncoder);
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.IsOpen: Boolean;
begin
  Result := FBuffer <> nil;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteBeginBlock(AID: TADMoniRemoteStreamBlockID);
begin
  WriteBytes(C_AD_Mon_BeginBlockDelim, SizeOf(TADAnsiChar));
  WriteBytes(AID, SizeOf(AID));
  Inc(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteEndBlock;
begin
  WriteBytes(C_AD_Mon_EndBlockDelim, SizeOf(TADAnsiChar));
  Dec(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteString(const AParamName: String; const AValue: String);
var
  iLen: Integer;
  sb: TADByteString;
begin
  WriteValueHeader(AParamName, C_AD_Mon_StringHeader);
  iLen := Length(AValue);
  WriteBytes(iLen, SizeOf(iLen));
  if iLen > 0 then begin
    sb := FEncoder.Encode(AValue);
    WriteBytes(PADByteString(sb)^, iLen);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteBlob(const AParamName: String; AValue: TMemoryStream);
var
  iLen: Integer;
begin
  WriteValueHeader(AParamName, C_AD_Mon_BlobHeader);
  iLen := AValue.Size;
  WriteBytes(iLen, SizeOf(iLen));
  if iLen > 0 then
    WriteBytes(PByte(AValue.Memory)^, iLen);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteBoolean(const AParamName: String; AValue: Boolean);
var
  b: Byte;
begin
  b := Byte(AValue);
  WriteValueHeader(AParamName, C_AD_Mon_BooleanHeader);
  WriteBytes(b, SizeOf(b));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteInteger(const AParamName: String; AValue: Integer);
begin
  WriteValueHeader(AParamName, C_AD_Mon_IntegerHeader);
  WriteBytes(AValue, SizeOf(AValue));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteLongWord(const AParamName: String; AValue: LongWord);
begin
  WriteInteger(AParamName, Integer(AValue));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteFloat(const AParamName: String; AValue: Double);
begin
  WriteValueHeader(AParamName, C_AD_Mon_FloatHeader);
  WriteBytes(AValue, SizeOf(AValue));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.WriteDate(const AParamName: String; AValue: TDateTime);
begin
  WriteValueHeader(AParamName, C_AD_Mon_DateHeader);
  WriteBytes(AValue, SizeOf(AValue));
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.ReadBeginBlock(AID: TADMoniRemoteStreamBlockID);
var
  iID: TADMoniRemoteStreamBlockID;
  c: TADAnsiChar;
begin
  ReadBytes(c, SizeOf(TADAnsiChar));
  if c <> C_AD_Mon_BeginBlockDelim then
    raise EADMoniException.Create(S_AD_MonEncounterBlock);
  ReadBytes(iID, SizeOf(iID));
  if AID <> iID then
    raise EADMoniException.Create(S_AD_MonEncounterBlock);
  Inc(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.ReadEndBlock;
var
  c: TADAnsiChar;
begin
  while not IsEndBlock do
    FBuffer.Position := FBuffer.Position + 1;
  ReadBytes(c, SizeOf(TADAnsiChar));
  Dec(FBlockLevel);
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.IsEndBlock: Boolean;
var
  iPos: Integer;
  c: TADAnsiChar;
begin
  iPos := FBuffer.Position;
  try
    ReadBytes(c, SizeOf(TADAnsiChar));
    Result := c = C_AD_Mon_EndBlockDelim;
  finally
    FBuffer.Position := iPos;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.ReadString(const AParamName: String): String;
var
  iLen: Integer;
  sb: TADByteString;
begin
  ReadValueHeader(AParamName, C_AD_Mon_StringHeader);
  ReadBytes(iLen, SizeOf(iLen));
  if iLen > 0 then begin
    SetLength(sb, iLen);
    ReadBytes(PADByteString(sb)^, iLen);
    Result := FEncoder.Decode(sb);
  end
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteStream.ReadBlob(const AParamName: String; AValue: TMemoryStream);
var
  iLen: Integer;
begin
  ReadValueHeader(AParamName, C_AD_Mon_BlobHeader);
  ReadBytes(iLen, SizeOf(iLen));
  AValue.Size := iLen;
  if iLen > 0 then
    ReadBytes(PByte(AValue.Memory)^, iLen);
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.ReadBoolean(const AParamName: String): Boolean;
var
  b: Byte;
begin
  ReadValueHeader(AParamName, C_AD_Mon_BooleanHeader);
  ReadBytes(b, SizeOf(b));
  Result := Boolean(b);
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.ReadInteger(const AParamName: String): Integer;
begin
  ReadValueHeader(AParamName, C_AD_Mon_IntegerHeader);
  ReadBytes(Result, SizeOf(Result));
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.ReadLongWord(const AParamName: String): LongWord;
begin
  Result := LongWord(ReadInteger(AParamName));
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.ReadFloat(const AParamName: String): Double;
begin
  ReadValueHeader(AParamName, C_AD_Mon_FloatHeader);
  ReadBytes(Result, SizeOf(Result));
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteStream.ReadDate(const AParamName: String): TDateTime;
begin
  ReadValueHeader(AParamName, C_AD_Mon_DateHeader);
  ReadBytes(Result, SizeOf(Result));
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteAdapterList                                                      }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteAdapterList.Create;
begin
  inherited Create;
  FList := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteAdapterList.Destroy;
begin
  Clear;
  ADFreeAndNil(FList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteAdapterList.Clear;
begin
  FList.Clear;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteAdapterList.GetCount: Integer;
begin
  Result := FList.Count;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteAdapterList.GetPath(AIndex: Integer): string;
begin
  Result := FList[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteAdapterList.GetHandle(AIndex: Integer): LongWord;
begin
  Result := FList.Ints[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteAdapterList.IndexOf(AHandle: LongWord): Integer;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    if FList.Ints[i] = AHandle then begin
      Result := i;
      Exit;
    end;
  Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteAdapterList.FindByHandle(AHandle: LongWord): string;
var
  i: Integer;
begin
  i := IndexOf(AHandle);
  if i <> -1 then
    Result := FList[i]
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteAdapterList.FindByPath(const APath: string): LongWord;
var
  i: Integer;
begin
  if FList.Find(APath, i) then
    Result := FList.Ints[i]
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteAdapterList.AddAdapter(const APath: string; AHandle: LongWord);
begin
  FList.AddInt(APath, AHandle);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteAdapterList.RemoveAdapter(AHandle: LongWord);
var
  i: Integer;
begin
  i := IndexOf(AHandle);
  if i <> -1 then
    FList.Delete(i);
end;

{-------------------------------------------------------------------------------}
initialization
  GEmptyObj := TADValWrapper.Create(0);
  GNullObj := TADValWrapper.Create(1);

finalization
  ADFreeAndNil(GEmptyObj);
  ADFreeAndNil(GNullObj);

end.
