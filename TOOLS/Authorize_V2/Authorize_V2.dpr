program Authorize_V2;

uses
  Vcl.Forms,
  Authorize in 'Authorize.pas' {frmAuthorize},   
  vtKeyList in '..\..\COMMON\vtBase\vtKeyList.pas';//20171031 Igor

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAuthorize, frmAuthorize);
  Application.Run;
end.
