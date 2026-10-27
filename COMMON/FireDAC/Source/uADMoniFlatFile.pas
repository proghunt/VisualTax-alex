{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{       FireDAC monitor flat file implementation        }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADMoniFlatFile"'}

unit uADMoniFlatFile;

interface

uses
  Classes,
  uADStanIntf, uADStanConst, uADStanUtil,
  uADMoniBase, uADMoniCustom;

{$IFDEF AnyDAC_MONITOR}
type
  {-----------------------------------------------------------------------------}
  { TADMoniFlatFileClientLink                                                   }
  {-----------------------------------------------------------------------------}
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADMoniFlatFileClientLink = class(TADMoniClientLinkBase)
  private
    FFFClient: IADMoniFlatFileClient;
    FFileNameChanged: Boolean;
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetFileAppend: Boolean;
    procedure SetFileAppend(const AValue: Boolean);
    function GetFileColumns: TADTraceFileColumns;
    procedure SetFileColumns(const Value: TADTraceFileColumns);
    function IsFNS: Boolean;
    function GetFileEncoding: TADEncoding;
    procedure SetFileEncoding(AValue: TADEncoding);
    function GetShowTraces: Boolean;
    procedure SetShowTraces(AValue: Boolean);
  protected
    function GetMoniClient: IADMoniClient; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property FFClient: IADMoniFlatFileClient read FFFClient;
  published
    property FileName: String read GetFileName write SetFileName stored IsFNS;
    property FileAppend: Boolean read GetFileAppend write SetFileAppend default False;
    property FileColumns: TADTraceFileColumns read GetFileColumns write SetFileColumns
      default C_AD_MonitorColumns;
    property FileEncoding: TADEncoding read GetFileEncoding write SetFileEncoding
      default ecANSI;
    property ShowTraces: Boolean read GetShowTraces write SetShowTraces default True;
    property Tracing;
  end;
{$ENDIF}

implementation

{$IFDEF AnyDAC_MONITOR}
uses
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX,
{$ENDIF}
  uADStanFactory, uADStanTracer;

{-----------------------------------------------------------------------------}
{ TADMoniFlatFileClient                                                       }
{-----------------------------------------------------------------------------}
type
  TADMoniFlatFileClient = class(TADMoniCustomClient, IADMoniFlatFileClient)
  private
    FStarted: Boolean;
    FTracer: TADTracer;
  protected
    // IADMoniFlatFileClient
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetFileAppend: Boolean;
    procedure SetFileAppend(const AValue: Boolean);
    function GetFileColumns: TADTraceFileColumns;
    procedure SetFileColumns(const AValue: TADTraceFileColumns);
    function GetFileEncoding: TADEncoding;
    procedure SetFileEncoding(const AValue: TADEncoding);
    // other
    procedure DoTraceMsg(const AClassName, AObjName, AMessage: String); override;
    function DoTracingChanged: Boolean; override;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    property Tracer: TADTracer read FTracer;
  end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.Initialize;
begin
  inherited Initialize;
  FTracer := TADTracer.Create;
  FTracer.TraceFileName := C_AD_MonitorFileName;
  FTracer.TraceFileAppend := C_AD_MonitorAppend;
  FTracer.TraceFileColumns := C_AD_MonitorColumns;
  FTracer.TraceFileEncoding := TADEncoding(C_AD_MonitorEncoding);
  FStarted := False;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniFlatFileClient.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FTracer);
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
function TADMoniFlatFileClient.DoTracingChanged: Boolean;
begin
  if GetTracing and not FStarted then begin
    FTracer.Resume;
    FStarted := True;
  end;
  FTracer.Active := GetTracing;
  Result := True;
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.DoTraceMsg(const AClassName, AObjName,
  AMessage: String);
begin
  FTracer.TraceMsg(AClassName, AObjName, AMessage);
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClient.GetFileName: String;
begin
  Result := FTracer.TraceFileName;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.SetFileName(const AValue: String);
begin
  FTracer.TraceFileName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClient.GetFileAppend: Boolean;
begin
  Result := FTracer.TraceFileAppend;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.SetFileAppend(const AValue: Boolean);
begin
  FTracer.TraceFileAppend := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClient.GetFileColumns: TADTraceFileColumns;
begin
  Result := FTracer.TraceFileColumns;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.SetFileColumns(const AValue: TADTraceFileColumns);
begin
  FTracer.TraceFileColumns := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClient.GetFileEncoding: TADEncoding;
begin
  Result := FTracer.TraceFileEncoding;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClient.SetFileEncoding(const AValue: TADEncoding);
begin
  FTracer.TraceFileEncoding := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMoniFlatFileClientLink                                                     }
{-------------------------------------------------------------------------------}
constructor TADMoniFlatFileClientLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFFClient := MoniClient as IADMoniFlatFileClient;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniFlatFileClientLink.Destroy;
begin
  FFFClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetMoniClient: IADMoniClient;
var
  oFFClient: IADMoniFlatFileClient;
begin
  ADCreateInterface(IADMoniFlatFileClient, oFFClient);
  Result := oFFClient as IADMoniClient;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetFileName: String;
begin
  Result := FFClient.FileName;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClientLink.SetFileName(const AValue: String);
begin
  if (FFClient.FileName <> AValue) or (csReading in ComponentState) then begin
    FFClient.FileName := AValue;
    FFileNameChanged := (AValue <> '');
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.IsFNS: Boolean;
begin
  Result := FFileNameChanged;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetFileAppend: Boolean;
begin
  Result := FFClient.FileAppend;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClientLink.SetFileAppend(const AValue: Boolean);
begin
  FFClient.FileAppend := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetFileColumns: TADTraceFileColumns;
begin
  Result := FFClient.FileColumns;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClientLink.SetFileColumns(const Value: TADTraceFileColumns);
begin
  FFClient.FileColumns := Value;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetFileEncoding: TADEncoding;
begin
  Result := FFClient.FileEncoding;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClientLink.SetFileEncoding(AValue: TADEncoding);
begin
  FFClient.FileEncoding := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniFlatFileClientLink.GetShowTraces: Boolean;
begin
  Result := FADShowTraces;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniFlatFileClientLink.SetShowTraces(AValue: Boolean);
begin
  FADShowTraces := AValue;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADSingletonFactory.Create(TADMoniFlatFileClient, IADMoniFlatFileClient);

finalization
  ADReleaseFactory(oFact);
{$ENDIF}

end.
