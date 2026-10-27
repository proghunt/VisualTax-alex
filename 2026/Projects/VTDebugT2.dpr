program VTDebugT2;

//{$I VirtualUI.inc}       //coment to create desktop  Un-comment to create vtCloud version

uses
  ShareMem,
  {$IFDEF UseVirtualUI}
  VirtualUI_AutoRun,
  {$ENDIF }
  Forms,
  fMainBase in '..\COMMON\vtMain\fMainBase.pas' {VTMain},
  fVTnoSplash in '..\COMMON\vtMain\fVTnoSplash.pas' {vtnosplash},
  fSplash in '..\COMMON\vtBase\Dialogs\fSplash.pas' {Splash},
  vtMulti,
  T2_2027 in '..\T2Test-2027\T2_2027.pas';

{$R *.RES}

begin
  Application.Initialize;
  vtMulti.InternalExeYear := iey2026; //20191015 Igor
  vtMulti.InitMulti;

  AppT2 := TAppT2_2027.Create(AppList);

  Application.CreateForm(Tvtnosplash, vtnosplash);
  Application.CreateForm(TSplash, Splash);
  Application.Run;
  vtMulti.DoneMulti;
end.
