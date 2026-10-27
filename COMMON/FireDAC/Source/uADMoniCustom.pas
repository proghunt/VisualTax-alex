{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{         FireDAC monitor custom implementation         }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADMoniCustom"'}

unit uADMoniCustom;

interface

uses
  Classes,
  uADStanIntf, uADMoniBase;

{$IFDEF AnyDAC_MONITOR}
type
  {-----------------------------------------------------------------------------}
  { TADMoniCustomClientLink                                                     }
  {-----------------------------------------------------------------------------}
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADMoniCustomClientLink = class(TADMoniClientLinkBase)
  private
    FCClient: IADMoniCustomClient;
    function GetSynchronize: Boolean;
    procedure SetSynchronize(AValue: Boolean);
  protected
    function GetMoniClient: IADMoniClient; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CClient: IADMoniCustomClient read FCClient;
  published
    property Tracing;
    property Synchronize: Boolean read GetSynchronize write SetSynchronize
      default False;
  end;

  {-----------------------------------------------------------------------------}
  { TADMoniCustomClient                                                         }
  {-----------------------------------------------------------------------------}
  TADMoniCustomClient = class(TADMoniClientBase, IADMoniCustomClient)
  private
    FLevel: Integer;
    FSynchronize: Boolean;
  protected
    // IADMoniClient
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); override;
    // IADMoniCustomClient
    function GetSynchronize: Boolean;
    procedure SetSynchronize(AValue: Boolean);
    // other
    function DoTracingChanged: Boolean; override;
    procedure DoTraceMsg(const AClassName, AObjName, AMessage: String); virtual;
  public
    destructor Destroy; override;
  end;
{$ENDIF}

{-------------------------------------------------------------------------------}
implementation

{$IFDEF AnyDAC_MONITOR}
uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF POSIX}
  Posix.Pthread,
{$ENDIF}
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX,
{$ENDIF}
  uADStanConst, uADStanUtil, uADStanFactory, uADStanError;

{$IFDEF AnyDAC_D9}
{-------------------------------------------------------------------------------}
{ TADMoniCustomClientMsg                                                        }
{-------------------------------------------------------------------------------}
type
  TADMoniCustomClientMsg = class (TObject)
  private
    FClassName,
    FObjName,
    FMessage: String;
    FClient: IADMoniCustomClient;
  protected
    procedure DoOutput;
  public
    constructor Create(const AClassName, AObjName, AMessage: String;
      const AClient: IADMoniCustomClient);
  end;

{-------------------------------------------------------------------------------}
constructor TADMoniCustomClientMsg.Create(const AClassName, AObjName, AMessage: String;
  const AClient: IADMoniCustomClient);
begin
  inherited Create;
  FClassName := AClassName;
  FObjName := AObjName;
  FMessage := AMessage;
  FClient := AClient;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniCustomClientMsg.DoOutput;
begin
  if FClient.OutputHandler <> nil then
    FClient.OutputHandler.HandleOutput(FClassName, FObjName, FMessage);
  Destroy;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADMoniCustomClient                                                           }
{-------------------------------------------------------------------------------}
destructor TADMoniCustomClient.Destroy;
begin
  SetTracing(False);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniCustomClient.GetSynchronize: Boolean;
begin
  Result := FSynchronize;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniCustomClient.SetSynchronize(AValue: Boolean);
begin
  FSynchronize := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniCustomClient.DoTracingChanged: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniCustomClient.DoTraceMsg(const AClassName, AObjName,
  AMessage: String);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function VarRec2Variant(AArg: PVarRec): Variant;
begin
  case AArg^.VType of
    vtInteger:    Result := AArg^.VInteger;
    vtBoolean:    Result := AArg^.VBoolean;
    vtChar:       Result := {$IFDEF NEXTGEN} String(AArg^.VChar) {$ELSE}
                                             AArg^.VChar {$ENDIF};
    vtExtended:   Result := AArg^.VExtended^;
    vtString:     Result := {$IFDEF NEXTGEN} String(AArg^.VString^) {$ELSE}
                                             AArg^.VString^ {$ENDIF};
    vtPointer:    Result := {$IFDEF AnyDAC_D6Base} TADNativeUInt {$ELSE} Integer {$ENDIF} (AArg^.VPointer);
    vtPChar:      Result := {$IFDEF NEXTGEN} String(AArg^.VPChar) {$ELSE}
                                             AnsiString(AArg^.VPChar) {$ENDIF};
    vtWideChar:   Result := AArg^.VWideChar;
    vtPWideChar:  Result := TADWideString(AArg^.VPWideChar);
    vtAnsiString: Result := {$IFDEF NEXTGEN} String(AArg^.VAnsiString) {$ELSE}
                                             AnsiString(AArg^.VAnsiString) {$ENDIF};
    vtCurrency:   Result := AArg^.VCurrency^;
    vtWideString: Result := TADWideString(AArg^.VWideString);
    vtInt64:
      begin
{$IFDEF AnyDAC_D6Base}
        Result := AArg^.VInt64^;
{$ELSE}
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := AArg^.VInt64^;
{$ENDIF}
      end;
    vtObject:
      // special case - for NULL and Unassigned
      if Byte(LongWord(AArg^.VObject)) = 0 then
        Result := Null
      else if Byte(LongWord(AArg^.VObject)) = 1 then
        Result := Unassigned
      else
        ASSERT(False);
{$IFDEF AnyDAC_D12}
    vtUnicodeString: Result := UnicodeString(AArg^.VUnicodeString);
{$ENDIF}
    else
      // vtClass, vtVariant, vtInterface
      ASSERT(False);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniCustomClient.Notify(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; ASender: TObject; const AMsg: String;
  const AArgs: array of const);
var
  s, sClassName, sName: String;
  i, iHigh, iLow: Integer;
  lQuotes: Boolean;
{$IFDEF AnyDAC_D9}
  oMsg: TADMoniCustomClientMsg;
{$ENDIF}
begin
  if AStep = esEnd then
    Dec(FLevel);
  if GetTracing and (AKind in GetEventKinds) then begin
    s := StringOfChar(' ', FLevel * 4);
    case AStep of
    esStart:    s := s + '>> ';
    esProgress: s := s + ' . ';
    esEnd:      s := s + '<< ';
    end;
    s := s + AMsg;
    iHigh := High(AArgs);
    iLow := Low(AArgs);
    if iHigh - iLow + 1 >= 2 then begin
      s := s + ' [';
      i := iLow;
      while i < iHigh do begin
        if i <> iLow then
          s := s + ', ';
        lQuotes := False;
        s := s + ADIdentToStr(VarRec2Variant(@AArgs[i]), lQuotes) + '=' +
          ADValToStr(VarRec2Variant(@AArgs[i + 1]), lQuotes);
        Inc(i, 2);
      end;
      s := s + ']';
    end;
    GetObjectNames(ASender, sClassName, sName);
    DoTraceMsg(sClassName, sName, s);
    if GetOutputHandler <> nil then
{$IFDEF AnyDAC_D9}
      if not GetSynchronize or (GetCurrentThreadID = MainThreadID) then
        GetOutputHandler.HandleOutput(sClassName, sName, s)
      else begin
        oMsg := TADMoniCustomClientMsg.Create(sClassName, sName, s, Self);
        TThread.Queue(nil, oMsg.DoOutput);
      end;
{$ELSE}
      GetOutputHandler.HandleOutput(sClassName, sName, s)
{$ENDIF}
  end;
  if AStep = esStart then
    Inc(FLevel);
end;

{-------------------------------------------------------------------------------}
{ TADMoniCustomClientLink                                                       }
{-------------------------------------------------------------------------------}
constructor TADMoniCustomClientLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCClient := MoniClient as IADMoniCustomClient;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniCustomClientLink.Destroy;
begin
  FCClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniCustomClientLink.GetMoniClient: IADMoniClient;
var
  oCClient: IADMoniCustomClient;
begin
  ADCreateInterface(IADMoniCustomClient, oCClient);
  Result := oCClient as IADMoniClient;
end;

{-------------------------------------------------------------------------------}
function TADMoniCustomClientLink.GetSynchronize: Boolean;
begin
  Result := FCClient.Synchronize;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniCustomClientLink.SetSynchronize(AValue: Boolean);
begin
{$IFNDEF AnyDAC_D9}
  if AValue then
    ADCapabilityNotSupported(Self, [S_AD_LMoni]);
{$ENDIF}
  FCClient.Synchronize := AValue;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADSingletonFactory.Create(TADMoniCustomClient, IADMoniCustomClient);

finalization
  ADReleaseFactory(oFact);
{$ENDIF}

end.
