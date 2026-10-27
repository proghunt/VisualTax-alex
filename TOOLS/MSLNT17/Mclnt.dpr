program Mclnt;

uses
  Forms,
  controls,
  MAIN in 'MAIN.PAS' {MainForm},
  Uabout in 'UABOUT.PAS' {About},
  udeclare in 'udeclare.pas',
  Uwarning in 'UWARNING.PAS' {Warning},
  Ufixdb in 'UFIXDB.PAS' {FixDBForm},
  Uusers in 'UUSERS.PAS' {UserSetup},
  Utips in 'UTIPS.PAS' {Tip},
  Umpswd in 'UMPSWD.PAS' {Mpswd},
  Uprogres in 'UPROGRES.PAS' {Progress},
  uclients in 'uclients.pas' {Clients},
  Upoplist in 'upoplist.pas' {PopList},
  vtKeyList in '..\..\COMMON\vtBase\vtKeyList.pas',
  frmKeyItems in 'frmKeyItems.pas' {frmKey};

{$R TForce.RES}


begin
  Application.HintPause := 50;
  Application.Title := 'MCLNT';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TProgress, Progress);
  Application.CreateForm(TPopList, PopList);
  MainForm.WindowState := wsMaximized;
  MDIHandle := MainForm.Handle;
  Application.Run;

 end.
