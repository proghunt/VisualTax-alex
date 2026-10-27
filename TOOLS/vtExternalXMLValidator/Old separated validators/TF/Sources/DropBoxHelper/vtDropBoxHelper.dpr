library vtDropBoxHelper;

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
  ShareMem, //20200224 Igor
  vtCommonIntf in '..\vtIntf\vtCommonIntf.pas',
  //20180113 Igor >>>
  vtLicense in '..\vtIntf\vtLicense.pas',
  Worker in 'Worker.pas',
  DropBoxLicense in 'DropBoxLicense.pas',
  //20180113 Igor <<<
  OAuthWebForm in 'OAuthForm\OAuthWebForm.pas', {frm_OAuthWebForm} //20190228 Igor
  //20190919 Igor >>>
  //ceflib; //20190312 Igor
  SysUtils, uCEFApplication;
  //20190919 Igor <<<

procedure Radar(out AClass: TCloudHelperClass; out AHelperName, AClientID: string);
begin
  AClass := TDropBoxHelper;
  AHelperName := HELPER_NAME; //20180113 Igor
  AClientID := c_VisualTaxDropBoxClientID;
end;

procedure init(const ACallBackDialog: TCallBackHelperDialog;
  const ACallBackLocalFileExists, ACallBackLocalFileNotExists, ACallBackCloudFileExists,
  ACallBackCloudFileNotExists, ACallBackDownLoadError, ACallBackUpLoadError,
  ACallBackCheckBytesError, ACallBackSaveLocalFileError, ACallBackReadLocalFileError: TCallBackHelperIOError;
  const ACallBackHelperLog: TCallBackHelperLog);
begin
  AddChromiumDirToPath; //20190228 Igor
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

procedure CloseCef; //20190312 Igor
begin
  //20190910 Igor >>>
  //CefShutdown;
  DestroyGlobalCEFApp;
  //20190910 Igor <<<
end;

exports
  Radar,
  init,
  DonePChar,
  CloseCef; //20190312 Igor

begin

end.
