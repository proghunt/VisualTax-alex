program vtMobileAndr;

uses
  System.StartUpCopy,
  FMX.Forms,
  vtMobileAndroid in '..\Source\vtMobileAndroid.pas' {MainForm},
  ShowDocumentInterface in '..\Source\ShowDocument\ShowDocumentInterface.pas',
  {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
  ShowDocumentWindows in '..\Source\ShowDocument\ShowDocumentWindows.pas',
  {$ENDIF }
  {$IF DEFINED(ANDROID)}
  OpenPDF in '..\Source\ShowDocument\OpenPDF.pas',
  {$ENDIF }
  MainDM in '..\Source\MainDM.pas',
  Common in '..\Source\Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
