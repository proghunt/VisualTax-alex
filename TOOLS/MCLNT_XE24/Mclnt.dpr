program Mclnt;

uses
  Forms,
  controls,
  MAIN in 'MAIN.PAS' {MainForm},
  UABOUT in 'UABOUT.PAS' {About},
  udeclare in 'udeclare.pas',
  UWARNING in 'UWARNING.PAS' {Warning},
  UFIXDB in 'UFIXDB.PAS' {FixDBForm},
  UUSERS in 'UUSERS.PAS' {UserSetup},
  UTIPS in 'UTIPS.PAS' {Tip},
  UMPSWD in 'UMPSWD.PAS' {Mpswd},
  UPROGRES in 'UPROGRES.PAS' {Progress},
  uclients in 'uclients.pas' {Clients},
  upoplist in 'upoplist.pas' {PopList},
  uEncrypt in '..\..\COMMON\CRYPT\uEncrypt.pas',
  MassEmailToTaxPreparers in 'MassEmailToTaxPreparers.pas' {MassEmailToTaxPreparers},
  vtEditHTML in 'vtEditHTML.pas' {vtEditHTML},
  udmMain in 'udmMain.pas' {dmMain: TDataModule};

//20191015 Igor

{$R TForce.RES}


begin
  Application.HintPause := 50;
  Application.Title := 'MCLNT';
//  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TClients, Clients);
  Application.CreateForm(TProgress, Progress);
  Application.CreateForm(TPopList, PopList);
  //MainForm.WindowState := wsMaximized;
  Clients.WindowState := wsMaximized;
  //MDIHandle := MainForm.Handle;
  Application.Run;

 end.
