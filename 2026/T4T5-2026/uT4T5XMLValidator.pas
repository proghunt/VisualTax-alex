unit uT4T5XMLValidator;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils, System.StrUtils, Dialogs, vtCommon,
  Variants, ComObj, Winapi.msxml;

type
  TT4T5XMLValidator = class
  private
    FXMLFilePath: string;
    FXML: IXMLDOMDocument2;
    FValidationErrorList: TStringList;
    FXSDFilesList: TStringList;
    FAPPDir: string;

    procedure ValidateXML;
    function Init: Boolean;
  public
	  constructor Create;
    destructor Destroy; override;
    class procedure XMLValidate(aAPPDir: string; aXSDFilesList: TStringList; aXMLFilePath: string; var aValidationErrorList: TStringList);
    class procedure ShowErrorsInHTML(aErrorsList: TStringList);
  end;

implementation

uses
  vtShowMessageHTML;

class procedure TT4T5XMLValidator.XMLValidate(aAPPDir: string; aXSDFilesList: TStringList; aXMLFilePath: string; var aValidationErrorList: TStringList);
begin
  with TT4T5XMLValidator.Create do
  try
    FAPPDir:= aAPPDir;
    FXSDFilesList:= aXSDFilesList;
    FXMLFilePath:= aXMLFilePath;
    FValidationErrorList:= aValidationErrorList;

    if not Init then
      Exit;

    ValidateXML;
  finally
    Free;
  end;
end;

function TT4T5XMLValidator.Init(): Boolean;
var
  lDirPath: string;
begin
  Result:= False;

  lDirPath:= FAPPDir + '\XSD';
  if not DirectoryExists(lDirPath) then CreateDir(lDirPath);

  Result:= Assigned(FXSDFilesList) and Assigned(FValidationErrorList);
end;

constructor TT4T5XMLValidator.Create;
begin
  inherited;

  FXML:= CoDOMDocument60.Create;
  FXML.Async:= False;
//  FXML.setProperty('ProhibitDTD', False); // DTD disabled if True
  FXML.ValidateOnParse:= True;//False;  // Use manual validation
  FXML.resolveExternals:= True;//False;
end;

destructor TT4T5XMLValidator.Destroy;
begin
  FXML:= nil;
  inherited;
end;

class procedure TT4T5XMLValidator.ShowErrorsInHTML(aErrorsList: TStringList);
var
  L: TStringList;
  A: TArray<string>;
  I: integer;
  cColor, cBody: string;
  cCaption: string;
  lRow: integer;
begin
  cColor:= 'red';

  L:= TStringList.Create;
  try
    L.Add('<HTML><HEAD>');
    L.Add('<META CHARSET="UTF-8">');
    L.Add('<TITLE>T2 EFile Service</TITLE>');
    L.Add('</HEAD>');
    L.Add('<BODY>');
    L.Add('<DIV id="contentheader" style="margin-left: 20px;">');
    L.Add('<br>');
    L.Add('<FONT size=5><STRONG>Your XML file <FONT color='+ cColor +' size=5>has not been validated!</FONT></STRONG></FONT>');
    L.Add('<br><br><b>We found next error:</b>');

    for i:= 0 to pred(aErrorsList.Count) do
      L.Add('<br><br>'+ aErrorsList[i]);

    L.Add('</DIV></BODY></HTML>');
    ShowMessageHTML(L.Text, 600);
  finally
    L.Free;
  end;
end;

procedure TT4T5XMLValidator.ValidateXML;
var
  lSchemaCache: IXMLDOMSchemaCollection;
  lErrorList: IXMLDOMParseErrorCollection;
  lError: IXMLDOMParseError;
  ifor: Integer;
  lValidationResult: OleVariant;
  lSplitedXSD: TArray<string>;
  lXSDPath: string;
begin
  lSchemaCache:= CoXMLSchemaCache60.Create;

  for ifor:= 0 to pred(FXSDFilesList.Count) do
  begin
    lSplitedXSD:= FXSDFilesList[ifor].Split([',']);
    lXSDPath:= FAPPDir + '\XSD\' + lSplitedXSD[1];
    if not FileExists(lXSDPath) then
    begin
      FValidationErrorList.Add('XSD file not found: ' + lXSDPath);
      Exit;
    end;

    try
      lSchemaCache.add(lSplitedXSD[0], lXSDPath); // lSchemaCache.add(lSplitedXSD[0], FAPPDir + '\XSD\' + lSplitedXSD[1]);
    except on E: Exception do
      Exit;
//      FValidationErrorList.Add('Error of schema adding: ' + lSplitedXSD[1] + ' — ' + E.Message);
    end;
  end;

  FXML.schemas:= lSchemaCache;

  if not FileExists(FXMLFilePath) then
  begin
    FValidationErrorList.Add('XML file not found.');
    Exit;
  end;

  if not FXML.Load(FXMLFilePath) then
  begin
    FValidationErrorList.Add('XML file loading error: ' + FXML.parseError.reason);
    Exit;
  end;

  try
    lValidationResult:= FXML.validate;
  except on E: EOleException do
  begin
    FValidationErrorList.Add('Exception during validation: ' + E.Message);
    Exit;
  end;
  end;

  if VarIsClear(lValidationResult) or VarIsEmpty(lValidationResult) or VarIsNull(lValidationResult) then
    Exit;

  lError:= IDispatch(lValidationResult) as IXMLDOMParseError;
  if (lError <> nil) and (Trim(lError.reason) <> '') and (Pos('DTD', string(lError.reason)) = 0) then
    FValidationErrorList.Add(Format('Line %d, position %d: %s', [lError.line, lError.linepos, lError.reason]));
end;

end.
