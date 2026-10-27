unit VirtualUI_AutoRun;

interface

uses VirtualUI_SDK;

implementation

initialization
  VirtualUI.Start();
  //20190109 Igor >>>
  VirtualUI.ClientSettings.MouseMoveGestureStyle := MM_STYLE_ABSOLUTE;
  VirtualUI.ClientSettings.MouseMoveGestureAction := MM_ACTION_WHEEL;
  VirtualUI.ClientSettings.CursorVisible := FALSE;
  //20190109 Igor <<<
end.
