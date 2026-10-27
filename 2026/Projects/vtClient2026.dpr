program vtClient2026;

uses
  ShareMem, //20200224 Igor
  Forms,
  fMainBase in '..\COMMON\vtMain\fMainBase.pas' {VTMain},
  fVTnoSplash in '..\COMMON\vtMain\fVTnoSplash.pas' {vtnosplash},
  fSplash in '..\COMMON\vtBase\Dialogs\fSplash.pas' {Splash},
  vtMulti,

  T1_2026 in '..\T1-2026\T1_2026.pas';

  {$R *.RES}

begin
  Application.Initialize;
  vtMulti.InternalExeYear := iey2026;
  vtMulti.InitMulti;

  AppT1_2026 := TAppT1_2026.Create(AppList);

  vtMulti.InitVtClientKeys; //20210119 Igor

  Application.CreateForm(Tvtnosplash, vtnosplash);
  Application.CreateForm(TSplash, Splash);
  Application.Run;
  vtMulti.DoneMulti;
end.
