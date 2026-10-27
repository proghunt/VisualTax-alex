program vtXMLValidator;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fmMain},
  uT1XMLValidator in 'uT1XMLValidator.pas',
  vtShowMessageHTML in 'vtShowMessageHTML.pas' {fShowMessageHTML};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
