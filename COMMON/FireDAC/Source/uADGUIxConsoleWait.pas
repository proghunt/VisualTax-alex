{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC wait time user interface            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxConsoleWait"'}

unit uADGUIxConsoleWait;

interface

implementation

uses
  Classes, SysUtils,
  uADStanFactory, uADStanConst,
  uADGUIxIntf, uADGUIxManager;

{-------------------------------------------------------------------------------}
{- TADGUIxWaitCursorConsoleImpl                                                -}
{-------------------------------------------------------------------------------}
type
  TADGUIxWaitCursorConsoleImpl = class(TADGUIxWaitCursorImplBase)
  protected
    // IADGUIxWaitCursor
    procedure StartWait; override;
    procedure StopWait; override;
    procedure PushWait; override;
    procedure PopWait; override;
    procedure ForceStopWait; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.StartWait;
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.StopWait;
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.PopWait;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.PushWait;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxWaitCursorConsoleImpl.ForceStopWait;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADSingletonFactory.Create(TADGUIxWaitCursorConsoleImpl,
    IADGUIxWaitCursor, C_AD_GUIxConsoleProvider, 'uADGUIxConsoleWait');

finalization
  ADReleaseFactory(oFact);

end.
