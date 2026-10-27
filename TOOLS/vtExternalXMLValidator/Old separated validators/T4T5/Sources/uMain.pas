unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    Label1: TLabel;
    eFilePath: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    rgTaxType: TRadioGroup;
    btnStart: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

uses
  uT4T5XMLValidator;

procedure TfmMain.Button1Click(Sender: TObject);
var
  ExeDir: string;
begin
  ExeDir:= ExtractFilePath(ParamStr(0)) + '\Files';

  OpenDialog1.Title:= 'Open XML file';
  OpenDialog1.Filter:= 'XML files (*.xml)|*.xml|All files (*.*)|*.*';
  OpenDialog1.InitialDir:= ExeDir;
  OpenDialog1.DefaultExt:= 'xml';
  OpenDialog1.Options:= OpenDialog1.Options + [ofFileMustExist, ofPathMustExist];

  if OpenDialog1.Execute then
  begin
    eFilePath.Text:= OpenDialog1.FileName;
  end;
end;

procedure TfmMain.btnStartClick(Sender: TObject);
var
  DataTypeCode: String;
  //20260121 Igor >>>
  lXMLValidationErrorList: TStringList;
  ifor: Integer;
  lErrorsString: string;
  lXSDFilesList: TStringList;
  //20260121 Igor <<<
begin
  if (eFilePath.Text = '') then
  begin
    ShowMessage('Please select a file to analyze.');
    exit;
  end;

  lXMLValidationErrorList:= TStringList.Create;
  lXSDFilesList:= TStringList.Create;
  try
    case rgTaxType.ItemIndex of
      0: // T4
      begin
        lXSDFilesList.Add(',T619_T4.xsd');
        lXSDFilesList.Add(',T4.xsd');
      end;
      1: // T4A
      begin
        lXSDFilesList.Add(',T619_T4A.xsd');
        lXSDFilesList.Add(',T4A.xsd');
      end;
      2: // T5
      begin
        lXSDFilesList.Add(',T619_T5.xsd');
        lXSDFilesList.Add(',T5.xsd');
      end;
    end;

    TT4T5XMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)), lXSDFilesList, eFilePath.Text, lXMLValidationErrorList);

    if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
    begin
     TT4T5XMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
    end else
      TT4T5XMLValidator.ShowSuccessInHTML(lXMLValidationErrorList);
  finally
    lXMLValidationErrorList.Free;
    lXSDFilesList.Free;
  end;

end;

end.
