program ConvertDBF_SQLite;

uses
  Vcl.Forms,
  MainUIUnit in 'MainUIUnit.pas' {MainForm},
  MainUnit in 'MainUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
