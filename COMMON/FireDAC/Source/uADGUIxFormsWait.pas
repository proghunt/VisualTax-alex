{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC wait time user interface            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxFormsWait"'}

unit uADGUIxFormsWait;

interface

implementation

uses
  Classes, SysUtils, Controls, Forms,
  uADStanConst, uADStanUtil, uADStanFactory,
  uADGUIxIntf, uADGUIxManager;

{-------------------------------------------------------------------------------}
{- TADGUIxWaitCursorImpl                                                       -}
{-------------------------------------------------------------------------------}
type
  TADGUIxWaitCursorImpl = class(TADGUIxVisualWaitCursorImplBase)
  private
    function CheckGetCursor(out ACrs: TCursor): Boolean;
  protected
    function CheckCurCursor: Boolean; override;
    function InternalHideCursor: Boolean;  override;
    procedure InternalShowCursor; override;
  end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImpl.CheckGetCursor(out ACrs: TCursor): Boolean;
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
function TADGUIxWaitCursorImpl.CheckCurCursor: Boolean;
var
  iCrs: TCursor;
begin
  Result := (Screen <> nil) and CheckGetCursor(iCrs) and (Screen.Cursor = iCrs);
end;

{-------------------------------------------------------------------------------}
function TADGUIxWaitCursorImpl.InternalHideCursor: Boolean;
begin
  Result := Screen <> nil;
  if Result then
    Screen.Cursor := crDefault;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorImpl.InternalShowCursor;
var
  iCrs: TCursor;
begin
  if CheckGetCursor(iCrs) then
    Screen.Cursor := iCrs;
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
  oFact := TADSingletonFactory.Create(TADGUIxWaitCursorImpl, IADGUIxWaitCursor,
    C_AD_GUIxFormsProvider, 'uADGUIxFormsWait');
{$IFDEF AnyDAC_FMX}
  oFact.AddFriend(C_AD_GUIxFMXProvider + '=uADGUIxFMXWait');
{$ENDIF}
  oFact.AddFriend(C_AD_GUIxConsoleProvider + '=uADGUIxConsoleWait');

  GCheckGuiRunning := CheckGuiRunning;

finalization
  ADReleaseFactory(oFact);

end.
