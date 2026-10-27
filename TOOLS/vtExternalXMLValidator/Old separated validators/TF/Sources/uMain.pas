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
  uTFXMLValidator;

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
      0: // T5013
      begin
        lXSDFilesList.Add(',T619_T5013main.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/ols/1-0-1,t5013fin.xsd');
        //lXSDFilesList.Add('http://www.cra-arc.gc.ca/enov/ol/interfaces/efile/partnership/olsbr/1-0-1,t5013main.xsd');
      end;
      1: //NR4
      begin
        lXSDFilesList.Add(',T619_NR4.xsd');
        lXSDFilesList.Add(',nr4.xsd');
      end;
      2: //T5018
      begin
        lXSDFilesList.Add(',T619_T5018.xsd');
        lXSDFilesList.Add(',t5018.xsd');
      end;
    end;

    TTFXMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)), lXSDFilesList, eFilePath.Text, lXMLValidationErrorList);

    if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
    begin
     TTFXMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
    end else
      TTFXMLValidator.ShowSuccessInHTML(lXMLValidationErrorList);
  finally
    lXMLValidationErrorList.Free;
    lXSDFilesList.Free;
  end;

end;

end.
