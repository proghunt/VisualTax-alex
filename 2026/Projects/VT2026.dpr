program VT2026;
{$I VirtualUI.inc}  //20170101 CON   //20200303
uses
  ShareMem, //20200224 Igor
  Forms,
  {$IFDEF  UseVirtualUI}
  VirtualUI_AutoRun,
  {$ENDIF}
  Classes,
  SysUtils,
  Dialogs,
  winapi.Windows,
  fVTnoSplash{vtnosplash},
  fSplash{Splash},
  vtMulti;

{$R *.RES}

procedure WriteLog(AText: String);
var
  FFile: Text;
begin
  try
    AssignFile(FFile, ChangeFileExt(Application.ExeName,'.log'));
    try
      if FileExists(ChangeFileExt(Application.ExeName,'.log')) then
        Append(FFile)
      else
        Rewrite(FFile);
      Writeln(FFile, FormatDateTime('YYYY.MM.DD hh:nn:ss', Now) + ': '+ AText);
    finally
      CloseFile(FFile);
    end;
  except
  end;
end;

begin
//20171031 Igor>>>
  Application.Initialize;
  vtMulti.InternalExeYear := iey2026;
  if not vtMulti.InitMulti or
     not vtMulti.InitTaxModules then
    Exit;

  Application.CreateForm(Tvtnosplash, vtnosplash);
  Application.CreateForm(TSplash, Splash);
  Application.Run;
  vtMulti.DoneMulti;
//20171031 Igor<<<
end.
