library vtGoogleDriveHelper;

{$WARN DUPLICATE_CTOR_DTOR OFF}

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  vtCommonIntf,
  vtLicense,
  SysUtils,
  OAuthWebForm in 'OAuthForm\OAuthWebForm.pas' {frm_OAuthWebForm},
  Worker in 'Worker.pas',
  GoogleDriveLicense in 'GoogleDriveLicense.pas',
  REST.Clouds in 'REST.Clouds.pas';

//20190919 Igor <<<

procedure Radar(out AClass: TCloudHelperClass; out AHelperName, AClientID: string);
begin
  AClass      := TGoogleDriveHelper;
  AHelperName := HELPER_NAME; //20180113 Igor
  AClientID   := c_VisualTaxGoogleDriveClientID;
end;

procedure init(const ACallBackDialog: TCallBackHelperDialog;
  const ACallBackLocalFileExists, ACallBackLocalFileNotExists, ACallBackCloudFileExists,
  ACallBackCloudFileNotExists, ACallBackDownLoadError, ACallBackUpLoadError,
  ACallBackCheckBytesError, ACallBackSaveLocalFileError, ACallBackReadLocalFileError: TCallBackHelperIOError;
  const ACallBackHelperLog: TCallBackHelperLog);
begin
  CallBackDialog := ACallBackDialog;
  CallBackLocalFileExists := ACallBackLocalFileExists;
  CallBackLocalFileNotExists := ACallBackLocalFileNotExists;
  CallBackCloudFileExists := ACallBackCloudFileExists;
  CallBackCloudFileNotExists := ACallBackCloudFileNotExists;
  CallBackDownLoadError := ACallBackDownLoadError;
  CallBackUpLoadError := ACallBackUpLoadError;
  CallBackCheckBytesError := ACallBackCheckBytesError;
  CallBackSaveLocalFileError := ACallBackSaveLocalFileError;
  CallBackReadLocalFileError := ACallBackReadLocalFileError;
  CallBackHelperLog := ACallBackHelperLog;
end;

procedure DonePChar(APchar: PChar);
begin
  Dispose(APchar);
end;

exports
  Radar,
  init,
  DonePChar;
begin

end.
