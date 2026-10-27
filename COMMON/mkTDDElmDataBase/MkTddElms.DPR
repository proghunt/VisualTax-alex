program MkTddElms;

uses
  Forms,
  Efer in 'EFER.PAS' {MainForm};

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
