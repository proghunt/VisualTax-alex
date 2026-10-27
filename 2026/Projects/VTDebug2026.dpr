program VTDebug2026;

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
  T1_2026 in '..\T1-2026\T1_2026.pas',
  FP_2027 in '..\FP-2027\FP_2027.pas',
  T2_2027 in '..\T2-2027\T2_2027.pas',
  T3_2026 in '..\T3-2026\T3_2026.pas',
  T4T5_2026 in '..\T4T5-2026\T4T5_2026.pas',
  TF_2026 in '..\TF-2026\TF_2026.pas';

{$R *.RES}

begin
  Application.Initialize;
  vtMulti.InternalExeYear:= iey2026; //20260826 Alex
  vtMulti.InitMulti;

  AppT1_2026:= TAppT1_2026.Create(AppList);
  AppT2:= TAppT2_2027.Create(AppList);
  AppT3_2026:= TAppT3_2026.Create(AppList);
  AppT4T5_2026:= TAppT4T5_2026.Create(AppList);
  AppTF_2026:= TAppTF_2026.Create(AppList);
  AppFP:= TAppFP_2027.Create(AppList);

  Application.CreateForm(Tvtnosplash, vtnosplash);
  Application.CreateForm(TSplash, Splash);
  Application.Run;
  vtMulti.DoneMulti;
end.
