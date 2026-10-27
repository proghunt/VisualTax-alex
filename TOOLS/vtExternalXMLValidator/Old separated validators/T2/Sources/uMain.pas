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
  uT2XMLValidator;

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
      0: // T1134
      begin
        lXSDFilesList.Add('http://www.w3.org/XML/1998/namespace,xml.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0,standarddatatypes.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0,cracommonstructures.xsd');
        lXSDFilesList.Add('urn:oecd:ties:isocbctypes:v1,isocbctypes_v1.1.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0,CountryByCountryReport2019.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/comm/2025/1-0-0,electronicfilingcommon.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ef/2025/1-0-0,efilecommon.xsd'); // 20251104 Igor
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0,ForeignIncomeVerificationStatement.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1134/2021/1-0-0,ControlledAndNotControlledForeignAffiliateReturn2021.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t106/2025/1-0-0,NonArmsLengthTransactionWithNonResidentInformationReturn.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0,t2efilefrrmsrequest.xsd');
      end;
      1: //T1135
      begin
        lXSDFilesList.Add('http://www.w3.org/XML/1998/namespace,xml.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0,standarddatatypes.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0,cracommonstructures.xsd');
        lXSDFilesList.Add('urn:oecd:ties:isocbctypes:v1,isocbctypes_v1.1.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0,CountryByCountryReport2019.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/comm/2025/1-0-0,electronicfilingcommon.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ef/2025/1-0-0,efilecommon.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0,ForeignIncomeVerificationStatement.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1134/2021/1-0-0,ControlledAndNotControlledForeignAffiliateReturn2021.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t106/2025/1-0-0,NonArmsLengthTransactionWithNonResidentInformationReturn.xsd');
        lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0,t2efilefrrmsrequest.xsd');
      end;
    end;

    TT2XMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)) + 'DistrFl\T2', lXSDFilesList, eFilePath.Text, lXMLValidationErrorList);

    if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
    begin
     TT2XMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
    end else
      TT2XMLValidator.ShowSuccessInHTML(lXMLValidationErrorList);
  finally
    lXMLValidationErrorList.Free;
    lXSDFilesList.Free;
  end;

end;

end.
