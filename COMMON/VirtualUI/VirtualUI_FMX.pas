unit VirtualUI_FMX;
{$IF CompilerVersion >= 25}
  {$DEFINE DELPHIXE4-5}
{$IFEND}
interface

uses
  VirtualUI_SDK;

implementation
uses
  FMX.Types;

procedure ShowVirtualKeyboardProc(const Displayed: boolean; const Caret: TCustomCaret;
       var VirtualKeyboardState: {$IFDEF DELPHIXE4-5}TVirtualKeyboardState{$ELSE}TVirtualKeyboardStates{$ENDIF});
begin
  if Displayed then
    VirtualUI.ShowVirtualKeyboard
end;

initialization
  RegisterShowVKProc(ShowVirtualKeyboardProc);
end.
