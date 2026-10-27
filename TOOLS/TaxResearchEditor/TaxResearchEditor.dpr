program TaxResearchEditor;

uses
  Vcl.Forms,
  uTaxResearchEditor in 'uTaxResearchEditor.pas' {fTaxResearchEditor},
  uData in 'uData.pas' {dmData: TDataModule},
  uTitleEdit in 'uTitleEdit.pas' {TitleEdit},
  uURLEdit in 'uURLEdit.pas' {URLEdit};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfTaxResearchEditor, fTaxResearchEditor);
  Application.CreateForm(TdmData, dmData);
  Application.Run;
end.
