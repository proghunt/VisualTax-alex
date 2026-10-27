program vtXMLValidator;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fmMain},
  uT4T5XMLValidator in 'uT4T5XMLValidator.pas',
  vtShowMessageHTML in 'vtShowMessageHTML.pas' {fShowMessageHTML};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
