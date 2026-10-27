program vtUploadToDropBox;

uses
  Vcl.Forms,
  Upload in '..\Source\Upload.pas' {frmMain},
  Common in '..\Source\Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
