unit T2_2027DACRequestEfile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl, System.IOUtils, T2_2027TrimStr,
  T2_2027Declare, T2_2027Common, T2_2027Common2, Db, DBTables, Grids, DBGrids,
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  IdSNTP, IdGlobal, IdHashSHA, IdCoderMIME, IdSSLOpenSSL, DateUtils, Crypt2,
  TXPCrypto, StrUtils, Xml.XMLDoc, Xml.XMLIntf, System.RegularExpressions,
  uADCompClient, vtLabel, Vcl.Mask, vteditbox;

const
  c_ProdDomain = 'https://apps.cra-arc.gc.ca';
  c_TestDomain = 'https://apps-ct.cra-arc.gc.ca';

  c_RequestDACUrl = '/ebci/sres/ws/api/sersnet/requestDac';
  c_RequestUHTDACUrl = '/ebci/sres/ws/api/sersnet/requestUhtDac';
  c_FileReturnUrl = '/ebci/sres/ws/api/sersnet/fileReturn';
  c_FileUHTReturnUrl = '/ebci/sres/ws/api/sersnet/fileUhtReturn';
  c_AttachDocsUrl = '/ebci/sres/ws/api/sersnet/attachDocs';

  EOL = #13#10;

  MaxFiles = 10;
  MaxTotalSize = 150 * 1024 * 1024;

type
  TResponse = record
    Success: boolean;
    ReturnCode: integer;
    Description: string;
    Text: string;
    ErrorReason: string;
    ErrorReasonDescription: string;
    ErrorReasonText: string;
  end;

  TDACRequestEfileT2_2027 = class(TForm)
    EfileType: TPanel;
    pnlDevelopment: TPanel;
    ProductionOrTestGroup: TRadioGroup;
    URLForWebServices: TEdit;
    edNumber: TEdit;
    Label1: TLabel;
    edIDate: TEdit;
    Label24: TLabel;
    edPCode: TEdit;
    Label25: TLabel;
    Label4: TLabel;
    edDAC: TEdit;
    CancelBtn: TBitBtn;
    GetDACButton: TBitBtn;
    ShowXMLBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure GetDACButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ProductionOrTestGroupClick(Sender: TObject);
    procedure ShowXMLBtnClick(Sender: TObject);
  private
    FXMLList: TStringList;
    FFieldList: TStringList;
    OnlineNo: string;
    Password: string;
    Url: string;
    FRetNo: integer;
    FCorporationName: string;
    NetFileDir: string;
    FIsUHT: boolean;
    FEDocsDir: string;
    Response: TResponse;

    procedure Init;
    function GetSoftwareCode: string;
    function GetTaxYear: string;
    function GetRequestDACUrl: string;
    function GetRequestDACSubmittedFileName: string;
    procedure AddBeginTag(AIndent: integer; AName: string);
    procedure AddBeginTagwithValue(AIndent: integer; AName, AValue: string);
    procedure AddEndTag(AIndent: integer; AName: string);
    procedure AddTag(AIndent: integer; AName, AValue: string);
    function CreateDACXML: boolean;
    function GetBasicAuthorization(AUserName, APassword: string): string;
    function GetRequestDACReceivedFileName: string;
    function ParseResponse(AResponse: string): TResponse;
    procedure ShowHTML(AResponse: TResponse; AFileName: string);
    function GetRequestDACReceivedHTMLFileName: string;
  protected
    property SoftwareCode: string read GetSoftwareCode;
    property TaxYear: string read GetTaxYear;
  public
    property IsUHT: boolean read FIsUHT;
    property RequestDACUrl: string read GetRequestDACUrl;
    property RequestDACSubmittedFileName: string read GetRequestDACSubmittedFileName;
    property RequestDACReceivedFileName: string read GetRequestDACReceivedFileName;
    property RequestDACReceivedHTMLFileName: string read GetRequestDACReceivedHTMLFileName;
  end;

var
  DACRequestEfileT2_2027: TDACRequestEfileT2_2027;

implementation

uses
  vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T2_2027, T2_2027main, vtShared,
  vtShowMessageHTML, vtDynData;

{$R *.dfm}

const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;

function ReplaceSpecialChar(info: String): String;
begin
  info:= ReplaceChar(info, '&', '&amp;');
  info:= ReplaceChar(info, '<', '&lt;');
  info:= ReplaceChar(info, '"', '&quot;');
  info:= ReplaceChar(info, '>', '&gt;');
  info:= ReplaceChar(info, '''', '&apos;');
  result:= info;
end;

function ClearXML(AXML: String): string;
begin
  Result:= TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result:= TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;

procedure TDACRequestEfileT2_2027.FormCreate(Sender: TObject);
begin
  FXMLList:= TStringList.Create;
  FFieldList:= TStringList.Create;
end;

procedure TDACRequestEfileT2_2027.FormDestroy(Sender: TObject);
begin
  FXMLList.Free;
  FFieldList.Free;
end;

procedure TDACRequestEfileT2_2027.FormShow(Sender: TObject);
begin
  Init;
end;

procedure TDACRequestEfileT2_2027.Init;
var
  LCNumber: integer;
begin
  FRetNo:= GetCurrentRetNo;
  edNumber.Text:= FetchElm(FRetNo, 'T2', 1);
  FCorporationName:= FetchElm(FRetNo, 'T2', 3); // 20250625 Igor
  edIDate.Text:= ReplaceStr(FetchElm(FRetNo, 'T2', 299), '/', '-');
  edPCode.Text:= FetchElm(FRetNo, 'T2', 20);
  edDAC.Text:= FetchElm(FRetNo, 'T2', 128);

  GetEOLParms(OnlineNo, Password, Url, NetFileDir);

  ProductionOrTestGroup.ItemIndex:= 0;

  FEDocsDir:= TPath.Combine(NetFileDir, 'SERS\CorpDAC');
end;

procedure TDACRequestEfileT2_2027.AddBeginTag(AIndent: integer; AName: string);
begin
  FXMLList.Add(Space(AIndent) + '<'+ AName +'>');
end;

procedure TDACRequestEfileT2_2027.AddBeginTagwithValue(AIndent: integer; AName, AValue: string);
begin
  FXMLList.Add(Space(AIndent) + '<'+ AName + ' ' + AValue + '>');
end;

procedure TDACRequestEfileT2_2027.AddEndTag(AIndent: integer; AName: string);
begin
  FXMLList.Add(Space(AIndent) + '</'+ AName +'>');
end;

procedure TDACRequestEfileT2_2027.AddTag(AIndent: integer; AName, AValue: string);
begin
  if SameText(Trim(AName), '') then
    Exit;
  if SameText(Trim(AValue), '') then
    FXMLList.Add(Space(AIndent) + '<'+ AName +'/>')
  else
    FXMLList.Add(Space(AIndent) + '<'+ AName +'>' + ReplaceSpecialChar(AValue) + '</'+ AName +'>');
end;

function TDACRequestEfileT2_2027.GetSoftwareCode: string;
begin
  Result:= FRRMSSoftwareId;
end;

function TDACRequestEfileT2_2027.GetTaxYear: string;
begin
  Result:= CurrentApp.AppYear;
end;

function TDACRequestEfileT2_2027.GetRequestDACUrl: string;
begin
  if IsUHT then
    Result:= URLForWebServices.Text + c_RequestUHTDACUrl
  else
    Result:= URLForWebServices.Text + c_RequestDACUrl;
end;

function TDACRequestEfileT2_2027.GetRequestDACSubmittedFileName: string;

  function GetSubmittedFileName(AType: string): string;
  begin
    ForceDirectories(FEDocsDir);
    Result:= TPath.Combine(FEDocsDir, RetList[FRetNo].SourceFlName + '_' + AType + '_SERS-SUBMITTED.XML');
  end;

begin
  if IsUHT then
    Result:= GetSubmittedFileName('RequestUHTDAC')
  else
    Result:= GetSubmittedFileName('RequestDAC');
end;

function TDACRequestEfileT2_2027.GetRequestDACReceivedFileName: string;

  function GetReceivedFileName(AType: string): string;
  begin
    ForceDirectories(FEDocsDir);
    Result:= TPath.Combine(FEDocsDir, RetList[FRetNo].SourceFlName + '_' + AType + '_SERS-RECEIVED.XML');
  end;

begin
  if IsUHT then
    Result:= GetReceivedFileName('RequestUHTDAC')
  else
    Result:= GetReceivedFileName('RequestDAC');
end;

function TDACRequestEfileT2_2027.GetBasicAuthorization(AUserName, APassword: string): string;
var
  Encoder: TIdEncoderMIME;
begin
  Encoder:= TIdEncoderMIME.Create(nil);
  try
    Result:= Encoder.EncodeString(AUserName + ':' + APassword);
  finally
    Encoder.Free;
  end;
end;

function TDACRequestEfileT2_2027.CreateDACXML: boolean;
begin
  FXMLList.Clear;
  AddBeginTagwithValue(0, 'DacRequest', 'xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" xmlns:common="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0"');
  AddTag(indent, 'common:SoftwareCode', SoftwareCode);
  AddTag(indent, 'common:ClientId', edNumber.Text);
  AddBeginTag(indent, 'SharedSecrets');

  AddBeginTag(indentM, 'CorporateEntity');
  AddTag(indentMM, 'IncorporationDate', edIDate.Text);
  AddTag(indentMM, 'PostalCode', edPCode.Text);
  AddEndTag(indentM, 'CorporateEntity');

  AddEndTag(indent, 'SharedSecrets');
  AddTag(indent, 'Year', TaxYear);
  AddEndTag(0, 'DacRequest');
  Result:= FXMLList.Count > 0;
end;

procedure SaveToFile(AText: string; AFileName: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := AText;
    L.SaveToFile(AFileName);
  finally
    L.Free;
  end;
end;

function TDACRequestEfileT2_2027.ParseResponse(AResponse: string): TResponse;
var
  X: XML.XMLDoc.TXMLDocument;
  Node: IXMLNode;
begin
  Result.Success := false;
  Result.ReturnCode := -1;
  Result.Description := '';
  Result.Text := '';
  Result.ErrorReason := '';
  Result.ErrorReasonDescription := '';
  Result.ErrorReasonText := '';

  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;

      if AResponse.StartsWith('<?xml') then
      begin
        X.XML.Add(ClearXML(AResponse));

        if not(X.Active) then
          X.Active:= true;

        Node:= X.DocumentElement;
      end;

      if not Assigned(Node) then
        Result.Text:= 'Response has incorrect structure: <br><br>' + HTMLEscape(AResponse)
      else
      if SameText(Node.NodeName, 'DacResponse') then
      begin
        if Assigned(Node.ChildNodes.FindNode('DigitalAccessCode')) then
        begin
          edDAC.Text:= Node.ChildNodes.FindNode('DigitalAccessCode').NodeValue;
          StoreElm(FRetNo, 'T2', 128, edDAC.Text);

          Result.Success:= true;
          Result.Text:= 'Digital Access Code: ' + edDAC.Text;
        end else
        begin
          Node:= Node.ChildNodes.FindNode('Error');
          Result.ErrorReason:= Node.ChildNodes.FindNode('ErrorId').NodeValue;
          Result.Text:= Node.ChildNodes.FindNode('ErrorEnglishDesc').NodeValue;
        end;
      end else
        Result.Text:= HTMLEscape(AResponse);
    except on E: Exception do
      begin
        Result.Text:= HTMLEscape(AResponse);
        ShowMessage('Error occured while processing CRA response: ' + #13 + E.Message + #13#13 + 'Response: ' + AResponse);
      end;
    end;
  finally
    X.Free;
  end;
end;

procedure TDACRequestEfileT2_2027.ProductionOrTestGroupClick(Sender: TObject);
begin
  if ProductionOrTestGroup.ItemIndex = 1 then
    URLForWebServices.Text:= c_TestDomain
  else
    URLForWebServices.Text:= c_ProdDomain;
end;

procedure TDACRequestEfileT2_2027.ShowHTML(AResponse: TResponse; AFileName: string);
var
  L: TStringList;
  A: TArray<string>;
  I: integer;
  cColor, cBody: string;
  cCaption: string;
begin
  if AResponse.Success then
  begin
    cColor:= 'green';
    cCaption:= 'Confirmation';
  end else
  begin
    cColor:= 'red';
    cCaption:= 'Error';
  end;

  L:= TStringList.Create;
  try
    L.Add('<HTML><HEAD>');
    L.Add('<META CHARSET="UTF-8">');
    L.Add('<TITLE>T2 EFile Service</TITLE>');
    L.Add('</HEAD>');
    L.Add('<BODY>');
    L.Add('<DIV id="contentheader">');
    L.Add('<H1><FONT size=5><STRONG>SERS Results</STRONG></FONT></H1>');
    L.Add('<P>Business Number: <STRONG>' + HTMLEscape(edNumber.Text) + '</STRONG></P>');
    L.Add('<H2><FONT color=' + cColor + ' size=5><STRONG>'+ cCaption + '</STRONG></FONT></H2>');

    if AResponse.Success then
      L.Add('<P><FONT size=3>' + AResponse.Text + '</FONT></P>')
    else
    begin
      if AResponse.ReturnCode <> -1 then
        L.Add('<P><FONT size=3><strong>Result Code:</strong> ' + IntToStr(AResponse.ReturnCode) + ' - ' + AResponse.Description + '</FONT></P>');

      L.Add('<P><FONT size=3>' + AResponse.Text + '</FONT></P>');

      if not AResponse.ErrorReason.IsEmpty then
        if AResponse.ErrorReasonDescription.IsEmpty then
          L.Add('<P><FONT size=3><strong>Error Reason:</strong> ' + AResponse.ErrorReason + '</FONT></P>')
        else
          L.Add('<P><FONT size=3><strong>Error Reason:</strong> ' + AResponse.ErrorReason + ' - ' + AResponse.ErrorReasonDescription + '</FONT></P>');

      if not AResponse.ErrorReasonText.IsEmpty then
        L.Add('<P><FONT size=3>' + HTMLEscape(AResponse.ErrorReasonText) + '</FONT></P>');
    end;

    L.Add('<HR>');
    L.Add('<P>Received: ' + DateTimeToStr(Now) + '</P>');
    L.Add('</DIV></BODY></HTML>');
    L.SaveToFile(AFileName, TEncoding.UTF8);

    ShowMessageHTML(L.Text, 600);
  finally
    L.Free;
  end;
end;

function TDACRequestEfileT2_2027.GetRequestDACReceivedHTMLFileName: string;

  function GetReceivedHTMLFileName(AType: string): string;
  begin
    ForceDirectories(FEDocsDir);
    Result:= TPath.Combine(FEDocsDir, RetList[FRetNo].SourceFlName + '_' + AType + '_SERS-RECEIVED.HTML');
  end;

begin
  if IsUHT then
    Result:= GetReceivedHTMLFileName('RequestUHTDAC')
  else
    Result:= GetReceivedHTMLFileName('RequestDAC');
end;
// 20250730 Igor >>>
procedure TDACRequestEfileT2_2027.GetDACButtonClick(Sender: TObject);
var
  LResponse: string;
  objHttp: IXMLHTTPRequest;
begin
  if Length(edNumber.Text) <> 15 then
  begin
    ShowMessage('M-Business No is required (9 digits+RC+0001)');
    Exit;
  end;

  if not CreateDACXML then
  begin
    ShowMessage('DAC Request XML is empty');
    Exit;
  end;

  objHttp:= CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
  try
    objHttp.open('POST', RequestDACUrl, False, '', '');
    FXMLList.SaveToFile(RequestDACSubmittedFileName);
    objHttp.setRequestHeader('Content-Type', 'application/xml');
    objHttp.setRequestHeader('Authorization', 'Basic ' + GetBasicAuthorization(OnlineNo, Password));
    objHttp.send(FXMLList.Text);
    LResponse:= objHttp.ResponseText;
    SaveToFile(LResponse, RequestDACReceivedFileName);
    Response:= ParseResponse(LResponse);
    ShowHTML(Response, RequestDACReceivedHTMLFileName);

    if (Response.Success) then
    begin
      ShowMessage('We successfully got the Corporation DAC Number and put it to the T2 form.');
      Close;
    end;
  finally
     objHttp:= nil;
  end;
end;

procedure TDACRequestEfileT2_2027.ShowXMLBtnClick(Sender: TObject);
var
  h: THandle;
  FlName: String;
begin
  if CreateDACXML then
  begin
    FXMLList.SaveToFile(RequestDACSubmittedFileName);

    flName:= RequestDACSubmittedFileName;
    h:= ShellExecute(Self.Handle, 'open', Pchar('' + flName), Nil, Nil, Sw_Show);

    if h <= 32 then
      ShowMessage('File not found');
  end else
    ShowMessage('File not created');
end;
// 20250730 Igor <<<
end.
