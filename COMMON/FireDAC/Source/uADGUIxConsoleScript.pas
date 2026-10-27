{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{             FireDAC script console output             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADGUIxConsoleScript"'}

unit uADGUIxConsoleScript;

interface

implementation

uses
  Classes, SysUtils,
  uADStanFactory, uADStanConst,
  uADGUIxIntf, uADGUIxManager;

{-------------------------------------------------------------------------------}
{- TADGUIxConsoleScriptImpl                                                    -}
{-------------------------------------------------------------------------------}
type
  TADGUIxConsoleScriptImpl = class(TADGUIxScriptImplBase)
  protected
    // IADGUIxScriptDialog
    procedure Show; override;
    procedure Progress(const AInfoProvider: IADGUIxScriptDialogInfoProvider); override;
    procedure Output(const AStr: String; AKind: TADScriptOuputKind); override;
    procedure Input(const APrompt: String; var AResult: String); override;
    procedure Pause(const APrompt: String); override;
    procedure Hide; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADGUIxConsoleScriptImpl.Show;
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxConsoleScriptImpl.Progress(
  const AInfoProvider: IADGUIxScriptDialogInfoProvider);
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnProgress) then
    FOnProgress(Self, AInfoProvider);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxConsoleScriptImpl.Output(const AStr: String; AKind: TADScriptOuputKind);
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnOutput) then
    FOnOutput(Self, AStr);
  Writeln(AStr);
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxConsoleScriptImpl.Input(const APrompt: String; var AResult: String);
begin
  if ADGUIxSilent() then
    Exit;
  if APrompt <> '' then
    Writeln(APrompt);
  if Assigned(FOnInput) then
    FOnInput(Self, APrompt, AResult);
  Readln(AResult);
  Writeln;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxConsoleScriptImpl.Pause(const APrompt: String);
begin
  if ADGUIxSilent() then
    Exit;
  if APrompt <> '' then
    Writeln(APrompt)
  else
    Writeln('Press Enter to continue ...');
  if Assigned(FOnPause) then
    FOnPause(Self, APrompt);
  Readln;
end;

{-------------------------------------------------------------------------------}
procedure TADGUIxConsoleScriptImpl.Hide;
begin
  if ADGUIxSilent() then
    Exit;
  if Assigned(FOnHide) then
    FOnHide(Self);
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
  oFact := TADSingletonFactory.Create(TADGUIxConsoleScriptImpl,
    IADGUIxScriptDialog, C_AD_GUIxConsoleProvider, 'uADGUIxConsoleScript');

finalization
  ADReleaseFactory(oFact);

end.
