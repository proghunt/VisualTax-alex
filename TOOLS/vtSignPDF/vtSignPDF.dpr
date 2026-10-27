program vtSignPDF;

uses
  Vcl.Forms,
  uSignPDF in 'uSignPDF.pas' {SignPDF},
  //20220227 Igor >>>
  uEncrypt in '..\..\COMMON\CRYPT\uEncrypt.pas',
  vtCommonPDF in '..\..\COMMON\vtPDF\vtCommonPDF.pas',
  vtControllerPDF in '..\..\COMMON\vtPDF\vtControllerPDF.pas',
  vtImplPDF in '..\..\COMMON\vtPDF\vtImplPDF.pas',
  vtMulti in 'vtMulti.pas',
  vtCommon in 'vtCommon.pas',
  vtDialogs in 'vtDialogs.pas',
  vtShared in 'vtShared.pas',
  vtVirtualTaxOffice in '..\..\2021\COMMON\vtBase\vtVirtualTaxOffice.pas',
  vtVirtualTaxOfficeLogin in '..\..\2021\COMMON\vtBase\vtVirtualTaxOfficeLogin.pas' {vtVirtualTaxOfficeLogin},
  //20210308 Igor >>>
  ElAES in '..\..\COMMON\CRYPT\ElAES.pas',
  vtEditHTML in '..\..\2021\COMMON\vtBase\Dialogs\vtEditHTML.pas', {vtEditHTML}
  vtCourier in '..\..\2021\COMMON\vtBase\Dialogs\vtCourier.pas' {vtCourier};
  //20210308 Igor <<<
  //20220227 Igor <<<

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSignPDF, FSignPDF);
  Application.Title := 'vtSignPDF';
  FIsvtClient := false; //20210304 Igor
  if LoginToVirtualTaxOffice then
      Application.Run;
end.
