program vtXMLValidator;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fmMain},
  uT1XMLValidator in 'uT1XMLValidator.pas',
  vtShowMessageHTML in 'vtShowMessageHTML.pas' {fShowMessageHTML},
  uT2XMLValidator in 'uT2XMLValidator.pas',
  uT4T5XMLValidator in 'uT4T5XMLValidator.pas',
  uTFXMLValidator in 'uTFXMLValidator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
