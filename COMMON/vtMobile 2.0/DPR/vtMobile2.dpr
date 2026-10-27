program vtMobile2;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in '..\SOURCE\uMain.pas' {frmMain},
  DataModule in '..\SOURCE\DataModule.pas' {dmMain: TDataModule},
  CloudHelperAbstr in '..\SOURCE\Cloud\CloudHelperAbstr.pas',
  CloudHelperDropBox in '..\SOURCE\Cloud\CloudHelperDropBox.pas',
  CloudHelperFactory in '..\SOURCE\Cloud\CloudHelperFactory.pas',
  uToast in '..\SOURCE\uToast.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
