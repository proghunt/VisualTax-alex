{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC Moni base classes               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADMoniBase;

interface

{$IFDEF AnyDAC_MONITOR}
uses
  Classes, uADStanIntf, uADStanFactory;

type
  TADMoniClientBase = class;
  TADMoniClientLinkBase = class;

  TADMoniClientBase = class(TADObject, IADMoniClient)
  private
    FName: TComponentName;
    FFailure: Boolean;
    FTracing: Boolean;
    FEventKinds: TADMoniEventKinds;
    FOutputHandler: IADMoniClientOutputHandler;
  protected
    // IADMoniClient
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function GetName: TComponentName;
    procedure SetName(const AValue: TComponentName);
    function GetEventKinds: TADMoniEventKinds;
    procedure SetEventKinds(const AValue: TADMoniEventKinds);
    function GetOutputHandler: IADMoniClientOutputHandler;
    procedure SetOutputHandler(const AValue: IADMoniClientOutputHandler);
    procedure ResetFailure;
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); virtual;
    function RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord; virtual;
    procedure UnregisterAdapter(const AAdapter: IADMoniAdapter); virtual;
    procedure AdapterChanged(const AAdapter: IADMoniAdapter); virtual;
    // other
    function DoTracingChanged: Boolean; virtual;
    function OperationAllowed: Boolean; virtual;
    procedure GetObjectNames(ASender: TObject; out AClassName, AName: String);
    // TADObject
    procedure Finalize; override;
  public
    procedure Initialize; override;
  end;

  TADMoniOutputEvent = procedure (ASender: TADMoniClientLinkBase;
    const AClassName, AObjName, AMessage: String) of object;
  TADMoniClientLinkBase = class(TComponent, IADMoniClientOutputHandler
{$IFNDEF AnyDAC_D6}
    , IUnknown
{$ENDIF}
    )
  private
    FClient: IADMoniClient;
    FOnOutput: TADMoniOutputEvent;
    FDesignTracing: Boolean;
    function GetEventKinds: TADMoniEventKinds;
    procedure SetEventKinds(const AValue: TADMoniEventKinds);
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    procedure SetOnOutput(const AValue: TADMoniOutputEvent);
  protected
    // IADMoniClientOutputHandler
    procedure HandleOutput(const AClassName, AObjName, AMessage: String); virtual;
    // other
    function GetMoniClient: IADMoniClient; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); virtual;
    property MoniClient: IADMoniClient read FClient;
    property Tracing: Boolean read GetTracing write SetTracing default False;
  published
    property EventKinds: TADMoniEventKinds read GetEventKinds write SetEventKinds
      default [ekLiveCycle .. ekComponent];
    property OnOutput: TADMoniOutputEvent read FOnOutput write SetOnOutput;
  end;
{$ENDIF}

implementation

{$IFDEF AnyDAC_MONITOR}
uses
  SysUtils,
  uADStanConst, uADStanUtil;

{-------------------------------------------------------------------------------}
{ TADMoniClientBase                                                             }
{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.Initialize;
begin
  inherited Initialize;
  FEventKinds := [ekLiveCycle .. ekComponent];
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetName: TComponentName;
begin
  Result := FName;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetName(const AValue: TComponentName);
begin
  FName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetEventKinds: TADMoniEventKinds;
begin
  Result := FEventKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetEventKinds(const AValue: TADMoniEventKinds);
begin
  FEventKinds := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetOutputHandler: IADMoniClientOutputHandler;
begin
  Result := FOutputHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetOutputHandler(const AValue: IADMoniClientOutputHandler);
begin
  FOutputHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.GetTracing: Boolean;
begin
  Result := FTracing;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.SetTracing(const AValue: Boolean);
begin
  if (FTracing <> AValue) and not FFailure and OperationAllowed then begin
    FTracing := AValue;
    try
      if not DoTracingChanged then
        if AValue then begin
          FTracing := False;
          FFailure := True;
        end;
    except
      SetTracing(False);
      FFailure := True;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.ResetFailure;
begin
  FFailure := False;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.Notify(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; ASender: TObject; const AMsg: String;
  const AArgs: array of const);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord;
begin
  // nothing
  Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.UnregisterAdapter(const AAdapter: IADMoniAdapter);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.AdapterChanged(const AAdapter: IADMoniAdapter);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.OperationAllowed: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientBase.DoTracingChanged: Boolean;
begin
  // nothing
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientBase.Finalize;
begin
  SetTracing(False);
end;

{-------------------------------------------------------------------------------}
type
  __TInterfacedObject = class(TInterfacedObject)
  end;

procedure TADMoniClientBase.GetObjectNames(ASender: TObject; out AClassName, AName: String);
var
  iRefCount: Integer;
  oObjIntf: IADStanObject;
begin
  AName := '';
  if ASender <> nil then begin
    AClassName := ASender.ClassName;
    if (ASender <> nil) and (ASender is TInterfacedObject) then begin
      iRefCount := __TInterfacedObject(ASender).FRefCount;
      __TInterfacedObject(ASender).FRefCount := 2;
      try
        if Supports(ASender, IADStanObject, oObjIntf) then begin
          AName := oObjIntf.GetName;
          oObjIntf := nil;
        end;
      finally
        __TInterfacedObject(ASender).FRefCount := iRefCount;
      end;
    end;
    if AName = '' then begin
      if ASender is TComponent then
        AName := TComponent(ASender).Name;
      if AName = '' then
        AName := '$' + IntToHex(Integer(ASender), 8);
    end;
  end
  else
    AClassName := '<nil>';
end;

{-------------------------------------------------------------------------------}
{ TADMoniClientLinkBase                                                         }
{-------------------------------------------------------------------------------}
constructor TADMoniClientLinkBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClient := GetMoniClient;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniClientLinkBase.Destroy;
begin
  SetOnOutput(nil);
  FClient.Tracing := False;
  FClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientLinkBase.GetEventKinds: TADMoniEventKinds;
begin
  Result := MoniClient.EventKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.SetEventKinds(const AValue: TADMoniEventKinds);
begin
  MoniClient.EventKinds := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniClientLinkBase.GetTracing: Boolean;
begin
  if csDesigning in ComponentState then
    Result := FDesignTracing
  else
    Result := MoniClient.Tracing;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.SetTracing(const AValue: Boolean);
begin
  if csDesigning in ComponentState then
    FDesignTracing := AValue
  else
    MoniClient.Tracing := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.SetOnOutput(const AValue: TADMoniOutputEvent);
begin
  if Assigned(AValue) then
    MoniClient.OutputHandler := Self as IADMoniClientOutputHandler
  else
    MoniClient.OutputHandler := nil;
  FOnOutput := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.HandleOutput(
  const AClassName, AObjName, AMessage: String);
begin
  if Assigned(FOnOutput) then
    FOnOutput(Self, AClassName, AObjName, AMessage);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniClientLinkBase.Notify(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; ASender: TObject; const AMsg: String;
  const AArgs: array of const);
begin
  MoniClient.Notify(AKind, AStep, ASender, AMsg, AArgs);
end;
{$ENDIF}

end.
