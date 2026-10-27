{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC wait time user interface            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFMXWait"'}

unit uADGUIxFMXWait;

interface

implementation

uses
  SysUtils, Types, UITypes, Classes, 
{$IFDEF AnyDAC_FPC}
  FMX_Types, FMX_Platform, FMX_Forms,
{$ELSE}
  FMX.Types, FMX.Platform, FMX.Forms,
{$ENDIF}
  uADStanFactory, uADStanConst, uADStanUtil,
  uADGUIxIntf, uADCompGUIx, uADGUIxManager;

{-------------------------------------------------------------------------------}
{- TADGUIxFMXWaitCursorImpl                                                    -}
{-------------------------------------------------------------------------------}
type
  TADGUIxFMXWaitCursorImpl = class(TADGUIxVisualWaitCursorImplBase)
  private
    function CheckGetCursor(out ACrs: TCursor): Boolean;
  protected
    function CheckCurCursor: Boolean; override;
    function InternalHideCursor: Boolean;  override;
    procedure InternalShowCursor; override;
  end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXWaitCursorImpl.CheckGetCursor(out ACrs: TCursor): Boolean;
begin
  case FWaitCursor of
    gcrDefault:   ACrs := crDefault;
    gcrHourGlass: ACrs := crHourGlass;
    gcrSQLWait:   ACrs := crSQLWait;
    gcrAppWait:   ACrs := crAppStart;
  else            ACrs := crNone;
  end;
  Result := ACrs <> crNone;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXWaitCursorImpl.CheckCurCursor: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADGUIxFMXWaitCursorImpl.InternalHideCursor: Boolean;
{$IFDEF AnyDAC_D17}
var
  oCrsSrv: IFMXCursorService;
{$ENDIF}
begin
{$IFDEF AnyDAC_D17}
  Result := TPlatformServices.Current.SupportsPlatformService(IFMXCursorService, IInterface(oCrsSrv));
  if Result then
    oCrsSrv.SetCursor(crDefault);
{$ELSE}
  Result := Platform <> nil;
  if Result then
    Platform.SetCursor(nil, crDefault);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxFMXWaitCursorImpl.InternalShowCursor;
var
  iCrs: TCursor;
{$IFDEF AnyDAC_D17}
  oCrsSrv: IFMXCursorService;
{$ENDIF}
begin
  if CheckGetCursor(iCrs) then
{$IFDEF AnyDAC_D17}
  if TPlatformServices.Current.SupportsPlatformService(IFMXCursorService, IInterface(oCrsSrv)) then
    oCrsSrv.SetCursor(iCrs);
{$ELSE}
  if CheckGetCursor(iCrs) then
    Platform.SetCursor(nil, iCrs);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function CheckGuiRunning: Boolean;
begin
  Result := (Application <> nil) and not Application.Terminated;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADSingletonFactory.Create(TADGUIxFMXWaitCursorImpl, IADGUIxWaitCursor,
    C_AD_GUIxFMXProvider, 'uADGUIxFMXWait');

  GCheckGuiRunning := CheckGuiRunning;

finalization
  ADReleaseFactory(oFact);

end.
