program vtFillDB;

uses
  Vcl.Forms,
  Main in '..\Source\Main.pas' {frmFillDBMain},
  uEditUser in '..\Source\uEditUser.pas' {frmEditUser},
  uEditDocument in '..\Source\uEditDocument.pas' {frmEditDocument},
  Common in '..\Source\Common.pas',
  vtHelperManager in '..\..\vtIntf\vtHelperManager.pas',
  vtCommonIntf in '..\..\vtIntf\vtCommonIntf.pas',
  uEncrypt in '..\..\vtIntf\uEncrypt.pas',
  ManagerHelperSettingsFrame in '..\..\vtFrames\ManagerHelperSettingsFrame.pas' {frameManagerHelperSettings: TFrame},
  HelperSettionsFrame in '..\..\vtFrames\HelperSettionsFrame.pas' {frameHelperSettings: TFrame},
  HelperAppSettingsFrame in '..\..\vtFrames\HelperAppSettingsFrame.pas' {frameHelperAppSettings: TFrame},
  HelperAppUserSettingsFrame in '..\..\vtFrames\HelperAppUserSettingsFrame.pas' {frameHelperAppUserSettings: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmFillDBMain, frmFillDBMain);
  Application.Run;
end.
