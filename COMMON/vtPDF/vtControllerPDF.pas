unit vtControllerPDF;

interface

uses System.Classes, vtCommonPDF, System.IOUtils, SysUtils, Windows;

var
  PDF_Plugin: HModule;
  PDF_Create: TCreateVtPDFFunction;

procedure LoadVtPDF;

implementation

procedure LoadVtPDF;
var cFileName: string;
begin
  PDF_Plugin := 0;
  cFileName := TPath.Combine(ExtractFilePath(ParamStr(0)), 'vtPDF.dll');
  if not FileExists(cFileName) then Exit;
  PDF_Plugin := SafeLoadLibrary(PWideChar(cFileName), SEM_FAILCRITICALERRORS);
  if PDF_Plugin <> 0 then
  begin
    try
      @PDF_Create := GetProcAddress(PDF_Plugin, 'CreateNewVtPdf');
    except ON E: Exception DO
      begin
        FreeLibrary(PDF_Plugin);
        PDF_Plugin := 0;
      end;
    end;
  end;
end;

procedure UnloadVtPDF;
begin
  if (PDF_Plugin <> 0) then
    FreeLibrary(PDF_Plugin);
end;

initialization

finalization
  UnloadVtPDF;

end.
