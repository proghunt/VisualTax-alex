program vtCourierDecrypt;

uses
  //20220227 Igor >>>
  Vcl.Forms,
  ElAES in '..\..\COMMON\CRYPT\ElAES.pas',
  uEncrypt in '..\..\COMMON\CRYPT\uEncrypt.pas',
  vtVirtualTaxOffice in '..\..\2021\COMMON\vtBase\vtVirtualTaxOffice.pas',
  vtVirtualTaxOfficeLogin in '..\..\2021\COMMON\vtBase\vtVirtualTaxOfficeLogin.pas' {vtVirtualTaxOfficeLogin},
  vtMulti in 'vtMulti.pas',
  vtCommon in 'vtCommon.pas',
  vtDialogs in 'vtDialogs.pas',
  vtShared in 'vtShared.pas',
  vtEditHTML in '..\..\2021\COMMON\vtBase\Dialogs\vtEditHTML.pas', {vtEditHTML}
  vtCourier in '..\..\2021\COMMON\vtBase\Dialogs\vtCourier.pas' {vtCourier};
  //20220227 Igor <<<

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'vtCourier';
  Application.Run;
  if LoginToVirtualTaxOffice then
    RunCourier(VirtualTaxOfficeInfo.CyberId);
end.
