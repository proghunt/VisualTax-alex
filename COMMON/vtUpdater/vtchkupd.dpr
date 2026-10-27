program vtchkupd;

uses
  Forms,
  updateUpdaterForm in 'updateUpdaterForm.pas' {updateUpdater};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TupdateUpdater, updateUpdater);
  Application.Run;
end.
