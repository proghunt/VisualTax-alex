program TR2026;

uses
  Forms,
  TR_2026 in 'TR_2026.pas',
  TR_2026Engine in 'TR_2026Engine.pas' {EngineTR_2026},
  TR_2026About in 'TR_2026About.pas' {AboutTR_2026},
  TR_2026Declare in 'TR_2026Declare.pas',
  TR_2026AskForKey in 'TR_2026AskForKey.pas' {AskForKeyTR_2026},
  TR_2026PopTreeView in 'TR_2026PopTreeView.pas' {PopTreeViewTR_2026},
  TR_2026Authorization in 'TR_2026Authorization.pas',
  TR_2026Utils in 'TR_2026Utils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TR-2024';
  Application.CreateForm(TEngineTR_2026, EngineTR_2026);
  Application.Run;
end.
