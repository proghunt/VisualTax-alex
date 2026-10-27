unit vtNOA;
{
//20170320 Igor
}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, Vcl.Grids,
  Vcl.DBGrids, Data.DB, uADCompDataSet, uADCompClient,
  vtMulti, vtDataBase, vtShared, Vcl.ValEdit, Vcl.OleCtrls, SHDocVw,
  vtCommon; //20170328 Igor

type
  TServerResponse = Record
    ReturnCode: string;
    ReturnCodeCaption: string; //20180219 Igor
    ReturnCodeDescr: string;
    ResultCode: string;
    ResultCodeDescr: string;
    PayerName: string;
    //20170405 Igor >>>
    HaveHTMLBody: Boolean;
    NoticeType: string;
    SummaryText: string;
    //20170405 Igor <<<
    //DCN: string;//20170328 Igor
  end;

  TCallBack = procedure(Sender: TObject; AResponse: TServerResponse; ADone: Boolean) of Object;
  TLog = procedure(AMessage: String) of object;
  TRequestData = Record
  private
    function GetWebServiceUrl: string;
    function GetTrunkApplicationUrl: string;
  public
    Domain: String;
    Servise: String;
    Auth_Param: String;
    Method: String;
    SecretAccessKey: string;
    WebApplicationUrl: string;
    xmlns: string;
    transform_xsl: string; //20200131 Igor

    UserName: string;
    PasswordDigest: string;
    Nonce: string;
    NonceB64: string;
    Created: string;
    TaxYear: string;
    TokenC: string;
    TokenTitle: string;
    property WebServiceUrl: string read GetWebServiceUrl;
    property TrunkApplicationUrl: string read GetTrunkApplicationUrl;
  end;

  TSender = class(TThread)
  private
    FSIN: string;
    FTaxPayerGivenName: string;
    FTaxPayerSurname: string;
    FTaxYear: string;
    FCallBack: TCallBack;
    FLog: TLog;
    FServerResponse: TServerResponse;
    FDone: Boolean;
    FRequestData: TRequestData;
    FSOAPMessage: string;
    FSOAPResponse: string;
    FNeedCloseWebPage: Boolean;
    FSaveDir: string;
    FTest: Boolean;
    FLastMessage: string;
    FReceivedFlName: String;
    FxsltPath: string;
    WBDone: Boolean;
    FAutoSaveToMobileDB: Boolean;
    FForceKey: string;
    procedure DoCallBack;
    procedure DoLog;
    procedure Log(AMessage: String);
    function GetInternetDateTime: TDateTime;
    function SetRequestDataInput: Boolean;
    function GenerateNonce: string;
    function GeneratePasswordDigest: String;
    function Password_Digest(ANonce, ACreated,
      APassword: ansistring): ansistring;
    procedure GenerateSOAPMessage;
    procedure SendSOAPMessage;
    procedure GetResultInfoServerError;
    procedure LinkToCRALogin;
    function HMACSHA256Encode(S, Key: PWideChar): string;
    procedure WaitTitleToken;
    procedure SaveRequestNOA;
    procedure WBNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    function CreateNOASoapMessageXml: string;
    procedure ProcessRequestNOA;
    function SOAPRequesrHeader: string;
    procedure CreateAuthorizationWindow(AUrl: string);
  public
    constructor Create(ATaxPayerGivenName, ATaxPayerSurname, ASIN, ATaxYear,
      ASaveDir: String; ACallBack: TCallBack; ALog: TLog;
      ANeedCloseWebPage, ATest: Boolean; AForceKey: string);
    procedure Execute; override;
  end;

  TfrmNOA = class(TForm)
    pgcMain: TPageControl;
    tsStart: TTabSheet;
    tsWork: TTabSheet;
    btnContinue: TButton;
    btnCancel: TButton;
    lblStart: TLabel;
    pgcWizard: TPageControl;
    tsSelectReturn: TTabSheet;
    tsProcess: TTabSheet;
    Label1: TLabel;
    Panel1: TPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnCancel2: TButton;
    tsFinish: TTabSheet;
    lblFinish: TLabel;
    conClients: TADConnection;
    tblClients: TADTable;
    dsClients: TDataSource;
    grClients: TDBGrid;
    Panel2: TPanel;
    Label3: TLabel;
    edFilter: TEdit;
    GroupBox1: TGroupBox;
    btnExecuteNOA: TButton;
    rgTestOrProd: TRadioGroup;
    vlReturnInfo: TValueListEditor;
    mmoLog: TMemo;
    chbAutoClose: TCheckBox;
    lblHTMLPath: TLabel;
    Panel3: TPanel;//20170328 Igor
    pnlViewOld: TPanel;//20170328 Igor
    btnViewOld: TButton;
    chbAutoSaveToMobileDB: TCheckBox;
    Label2: TLabel;
    edNOAKey: TEdit;//20170328 Igor
    procedure btnCancelClick(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancel2Click(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure grClientsKeyPress(Sender: TObject; var Key: Char);
    procedure edFilterChange(Sender: TObject);
    procedure tblClientsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure grClientsTitleClick(Column: TColumn);
    procedure btnExecuteNOAClick(Sender: TObject);
    procedure btnViewOldClick(Sender: TObject);//20170328 Igor
    procedure RecreateNOAFiles; //20180130 Igor
  private
    { Private declarations }
    FApp: TApp;
    FRet: TRetData; //20170328 igor
    FSender: TSender;
    FSelectedSIN: string;
    FTaxPayerGivenName: string;
    FTaxPayerSurname: string;
    FDCN: string; //20170328 Igor
    FSpID: string;
    FPassword: string;
    FTaxYear: string;
    FServerResponse: TServerResponse;
    procedure CallBack(Sender: TObject; AServerResponse: TServerResponse; ADone: Boolean);
    procedure Log(AMessage: String);
    procedure StopThread;
    procedure PrevStep;
    procedure NextStep;
    function AllowNextStep: Boolean;
    procedure RefreshStep;
  public
    { Public declarations }
  end;

procedure NOA(AApp: TApp; ARet: TRetData = nil); //20170328 igor
function ReplaceHTML_SpecChars(AText: string): string; // 20171224 Igor

implementation

{$R *.dfm}
{$R 'T1_NOA\T1_NOA.res'} //20180130 Igor
{$R 'T1_NOA_2019\T1_NOA_2019.res'} //20200131 Igor

uses
  IdSNTP, System.DateUtils, Soap.EncdDecd, TXPCrypto, System.Win.ComObj,
  Xml.XMLDoc, Xml.XMLIntf, WEB.HTTPApp, Winapi.ShellAPI, Crypt2, System.StrUtils,
  ActiveX, System.RegularExpressions, MSXML2_TLB, MSHTML,
  vtFillDBMain, vtShowMessageHTML, //20170403 Igor  //20180220 Igor
  IdException, vtTransformNOA, vtGetToken; //20180227 Igor //20200131 Igor //20220216 Igor

const
  c_FinishOkMessage =
    '  The %s tax return for %s has been assessed. '+
    'To view your clients most recent assessment/reassessment details, '+
    'login to the Express NOA service within your software.'+ #13#10+
    '' + #13#10+
    'The same selection criteria for verifying income tax returns are used '+
    'for both paper and electronic versions. Your client needs to keep '+
    'all tax information slips and documents for six years after you filed '+
    'the tax return. Please keep this confirmation number and DCN '+
    'for your records: %s'; //#######- #############

  c_FinishNoDataMessage =
    'The Express NOA service is not available for one of the following reasons:'+#13#10+
    '•	There may be a delay during peak periods due to processing higher '+
    'than normal volumes.  Please check again tomorrow.'+#13#10+
    '•	More than one tax year has been filed. The current year Express NOA '+
    'will be available when the prior year returns have been processed.'+#13#10+
    '•	Your client’s tax return has been received but has not yet been assessed.'+#13#10+
    '•	It has been more than 5 business days since your client’s tax return has been filed.'+#13#10+
    'Please check Represent a Client for further details about your client’s account.';


   //20181205 Con  this is the correct for Efile
   c_LastMessage =
    'If you have questions about your client’s instant assessment message, '+
    'please check Represent A Client for further details about the assessment.' + #13 +
    'Your client’s notice of assessment will be available tomorrow directly in '+
    'the VT program via "[AutoFill / NOA] > [NOA]".  Don’t forget to come back tomorrow to view, '+
    'print and/or save your notice of assessment.'{ + #13+
    '<Software instructions can be added here>'};


  (*
  //20170406 Con  this is the correct for Efile
  c_LastMessage =
    'If you have questions about your client’s instant assessment message, '+
    'please check Represent A Client for further details about the assessment.' + #13 +
    'Your client’s notice of assessment will be available tomorrow directly in '+
    '"vt2017" via "[AutoFill / NOA] > [NOA]".  Don’t forget to come back tomorrow to view, '+
    'print and/or save your notice of assessment.'{ + #13+
    '<Software instructions can be added here>'};
  *)
  (*
  //20170328 Igor  This was for NetFile
  c_LastMessage =
    'If you have questions about your instant assessment message, '+
    'please check My Account for further details about your assessment.' + #13 +
    'Your notice of assessment will be available tomorrow directly in '+
    '"vt2016" via "[AutoFill / NOA] > [NOA]".  Don’t forget to come back tomorrow to view, '+
    'print and/or save your notice of assessment.'{ + #13+
    '<Software instructions can be added here>'};
  *)
  c_SPID_TDD = '064J';  //afr
  c_SPID_NOA = '064T';  //noa


  //c_Domain_Prod = 'https://ams-sga.cra-arc.gc.ca';
  c_Domain_Prod = 'https://apps.cra-arc.gc.ca';
  c_Domain_Test = 'https://apps-ct.cra-arc.gc.ca';

  c_Servise_Prod = '/ebci/awsc/tdd/ws/%s/NoticeOfAssessmentService'; //%s = ${year}
  c_Servise_Test = '/ebci/awsc/tdd/ws/%s/CertTestNOAService';        //%s = ${year}

  c_auth_Param = '/gol-ged/awsc/tdd/ws/noa';

  c_method_Prod = 'StageNOA';
  c_method_Test = 'GetNOA';

  c_WebApplicationURL_Prod = 'https://ams-sga.cra-arc.gc.ca/gol-ged/awsc/tdd/auth/start';
  c_WebApplicationURL_Test = 'https://apps-ct.cra-arc.gc.ca/ebci/awsc/tdd/certtest/auth/start';

  c_secretAccessKey_2015_Test = 'XVOvlM6C8mmoLKR9i7Qj39mc1dkNw2Hv';
  c_secretAccessKey_2015_Prod = 'xfPfarNhPkNmHi3v0AClwe8ioRcio8n5';
  c_secretAccessKey_2016_Test = 'JuBbmuoCHnPFA74kZPwd3JE7ey212Tzd';
  c_secretAccessKey_2016_Prod = 'rvsQqJNR3EJt9Gv67BjjwHIu1It3EcvW';
  //20171222 Igor>>>
  c_secretAccessKey_2017_Test = '37zqnls2N1viMs3oyjW8fuyZsx9y8KZk';
  c_secretAccessKey_2017_Prod = 'XVLwBEv13KwdxbPx2KIHBebccVYNSoOj';   //20180301
  //20171222 Igor<<<

  //20181205 CON>>>
  c_secretAccessKey_2018_Test = 'TFp9isqPvoqyzb57Mb8vkqI4GPJJxvbC'; //20181205 //'37zqnls2N1viMs3oyjW8fuyZsx9y8KZk';
  c_secretAccessKey_2018_Prod = 'R68f3K5JtfumfNVhtIbUCwSeksJqn1l7'; //20190218//XVLwBEv13KwdxbPx2KIHBebccVYNSoOj';   //20180301

  //20181205 CON>>>
  c_secretAccessKey_2019_Test = 'epDu2XS4bYCTp2hcpmsWlzZOMeHNGU73';  //202001??              //201200107 Igor //20200130 Igor
  c_secretAccessKey_2019_Prod = '4ikoEVLVKUl5lzgNGfLU4hUQ8ohj8Jbs'; //20200214 //20190218//XVLwBEv13KwdxbPx2KIHBebccVYNSoOj';   //20180301

  c_xmlns_noa_2016 = 'http://www.cra-arc.gc.ca/xmlns/tdd/noa/1-0-0';
  c_xmlns_noa_2019 = 'http://www.cra-arc.gc.ca/xmlns/tdd/noa/1-1-0'; //20200130 Igor

  //20200131 Igor >>>
  c_transform_xsl = 'notice-html.xsl';
  c_transform_xsl_2019 = 'xnoa-html-transform.xsl';
  //20200131 Igor <<<

(*
procedure Transform(AInXML, Axlst: String);
var
  X: IXMLDOMDocument2;
  XSLTemp: IXMLDOMDocument2;
  HTML: IXMLDOMDocument2;
begin
  Xml.Win.msxmldom.MSXMLDOMDocumentFactory.AddDOMProperty('ProhibitDTD', True);

  X := CoFreeThreadedDomDocument60.Create;
  XSLTemp := CoFreeThreadedDomDocument60.Create;
  HTML := CoFreeThreadedDomDocument60.Create;
  try
    X.Load(AInXML);
    XSLTemp.Load(Axlst);
    X.transformNodeToObject(XSLTemp, HTML);
    HTML.save(ChangeFileExt(AInXML, '.html'));
  finally
    X := nil;
    XSLTemp := nil;
    HTML := nil;
  end;
end;
*)

procedure ShowHTMLError(AServerResponce: TServerResponse); //20180219 Igor
var L: TStringList;
    //ErrorFile: string; //20180220 Igor
    FCode, FCaption, FDescription: string;
begin
  //ErrorFile := 'NOAErrorMessage.html'; //20180220 Igor
  if AServerResponce.ResultCode <> '' then
  begin
    FCode := AServerResponce.ResultCode;
    FCaption := '';
    FDescription := AServerResponce.ResultCodeDescr;
  end
  else
  begin
    FCode := AServerResponce.ReturnCode;
    FCaption := AServerResponce.ReturnCodeCaption;
    FDescription := AServerResponce.ReturnCodeDescr;
  end;
  L := TStringList.Create;
  try
    L.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">');
    L.Add('<!DOCTYPE html PUBLIC "-//IETF//DTD HTML//EN" "">');
    L.Add('<HTML><HEAD><META content="IE=5.0000" http-equiv="X-UA-Compatible">');
    L.Add('<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
    L.Add('<META name="GENERATOR" content="MSHTML 11.00.9600.16476">');
    L.Add('<TITLE>Notice of Assessment request</TITLE>');
    L.Add('</HEAD>');
    L.Add('<BODY>');
    L.Add('<DIV id="frame"><DIV id="contentheader">');
		L.Add('<H1><FONT size=5><STRONG>Notice of Assessment request</STRONG></FONT></H1>');
    if FCaption = '' then
      L.Add('<H2><FONT color=red size=5><STRONG>'+ FCode +'</STRONG></FONT></H2>')
    else
      L.Add('<H2><FONT color=red size=5><STRONG>'+ FCaption +'</STRONG></FONT></H2>');
    L.Add('<P>Received: '+ DateTimeToStr(Now) +'</P>');
    L.Add('<HR>');

    L.Add('<P></P>');
    if FCaption <> '' then
      L.Add('<P><FONT size=3 face="arial, helvetica, sans-serif">Result Code: '+ FCode +'</FONT></P>');
    L.Add('<P><FONT face="arial, helvetica, sans-serif"><FONT size=3>Error: '+ FDescription + '</FONT></FONT></P>');
    L.Add('</DIV></DIV></BODY></HTML>');
    //20180220 Igor >>>
    //L.SaveToFile(ErrorFile);
    //ShellExecute(0, 'OPEN', PChar(ErrorFile), '', '', SW_SHOWNORMAL);
    ShowMessageHTML(L.Text);
    //20180220 Igor <<<
  finally
    L.Free;
  end;
end;

function ReplaceHTML_SpecChars(AText: string): string; // 20171224 Igor
var i: integer;

type THTML_SpecChar = record
    CharValue: WideChar;
    CharCode: string;
  end;

const HTML_SpecCharsCount = 38;

const HTML_SpecChars: array[0..HTML_SpecCharsCount - 1] of THTML_SpecChar =
    (
      (CharValue : '•'; CharCode : '&bull;'),
      (CharValue : 'À'; CharCode : '&Agrave;'),
      (CharValue : 'Â'; CharCode : '&Acirc;'),
      (CharValue : 'Ä'; CharCode : '&Auml;'),
      (CharValue : 'È'; CharCode : '&Egrave;'),
      (CharValue : 'É'; CharCode : '&Eacute;'),
      (CharValue : 'Ê'; CharCode : '&Ecirc;'),
      (CharValue : 'Ë'; CharCode : '&Euml;'),
      (CharValue : 'Î'; CharCode : '&Icirc;'),
      (CharValue : 'Ï'; CharCode : '&Iuml;'),
      (CharValue : 'Ô'; CharCode : '&Ocirc;'),
      (CharValue : 'Œ'; CharCode : '&OElig;'),
      (CharValue : 'Ù'; CharCode : '&Ugrave;'),
      (CharValue : 'Û'; CharCode : '&Ucirc;'),
      (CharValue : 'Ü'; CharCode : '&Uuml;'),
      (CharValue : 'Ÿ'; CharCode : '&Yuml;'),
      (CharValue : 'à'; CharCode : '&agrave;'),
      (CharValue : 'â'; CharCode : '&acirc;'),
      (CharValue : 'ä'; CharCode : '&auml;'),
      (CharValue : 'è'; CharCode : '&egrave;'),
      (CharValue : 'é'; CharCode : '&eacute;'),
      (CharValue : 'ê'; CharCode : '&ecirc;'),
      (CharValue : 'ë'; CharCode : '&euml;'),
      (CharValue : 'î'; CharCode : '&icirc;'),
      (CharValue : 'ï'; CharCode : '&iuml;'),
      (CharValue : 'ô'; CharCode : '&ocirc;'),
      (CharValue : 'œ'; CharCode : '&oelig;'),
      (CharValue : 'ù'; CharCode : '&ugrave;'),
      (CharValue : 'û'; CharCode : '&ucirc;'),
      (CharValue : 'ü'; CharCode : '&uuml;'),
      (CharValue : 'ÿ'; CharCode : '&yuml;'),
      (CharValue : 'Ç'; CharCode : '&Ccedil;'),
      (CharValue : 'ç'; CharCode : '&ccedil;'),
      (CharValue : '«'; CharCode : '&laquo;'),
      (CharValue : '»'; CharCode : '&raquo;'),
      (CharValue : '‹'; CharCode : '&lsaquo;'),
      (CharValue : '›'; CharCode : '&rsaquo;'),
      (CharValue : '€'; CharCode : '&euro;')
    );
begin
  for I := 0 to HTML_SpecCharsCount - 1 do
    AText := ReplaceStr(AText, HTML_SpecChars[I].CharValue, HTML_SpecChars[I].CharCode);
  Result := AText;
end;

procedure NOA(AApp: TApp; ARet: TRetData = nil);  //20170328 Igor
begin
  with TfrmNOA.Create(Application) do
  begin
    try
      FApp := AApp;
      FRet := ARet; //20170328 Igor
      ShowModal;
    finally
      Free;
    end;
  end;
end;

function TfrmNOA.AllowNextStep: Boolean;
begin
  if pgcWizard.ActivePage = tsSelectReturn then
  begin
    Result := not tblClients.IsEmpty;
    if Not Result then
      MessageDlg('No return selected.', mtWarning, [mbOk], 0);
  end
  else
  if pgcWizard.ActivePage = tsProcess then
  begin
    {TODO : check}
    Result := True;
  end
  else
  //if pgcWizard.ActivePage = tsFinish then
  begin
    Result := True;
  end;
end;

procedure TfrmNOA.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmNOA.btnContinueClick(Sender: TObject);
begin
  pgcMain.ActivePage := tsWork;
  RefreshStep;
end;

procedure TfrmNOA.btnPrevClick(Sender: TObject);
begin
  PrevStep;
end;

procedure TfrmNOA.btnViewOldClick(Sender: TObject);//20170328 Igor
var
  FileName: string;
begin
  FileName := IncludeTrailingPathDelimiter(FApp.AppDir) +
      'NOA\' + FSelectedSIN + '.html';
  if FileExists(FileName) then
    //ShellExecute(0, 'OPEN', PChar(FileName), '', '', SW_SHOWNORMAL);
    ShowMessageHTMLFromFile(FileName, -1, true);
end;

procedure TfrmNOA.CallBack(Sender: TObject; AServerResponse: TServerResponse; ADone: Boolean);
var cMessage: string; //20190118 Igor
//20170405 Igor >>>
  function NotiseCaption(const ACode: String): string;
  begin
    if SameText(ACode, '1451') then
      Result := 'Notice of Assessment'
    else
    if SameText(ACode, '1491') then
      Result := 'Notice of Reassessment'
    else
    if ACode <> '' then
      Result := 'Notice Code ' + ACode
    else
      Result := '';
  end;
//20170405 Igor <<<
begin
  FSender := nil;
  btnExecuteNOA.Tag := 0;
  if ADone then
    btnExecuteNOA.Caption := 'Retry request for NOA'      //20170330
  else
    btnExecuteNOA.Caption := 'Try request again for NOA'; //20170330
  btnNext.Enabled := True; //20170403 Igor
  FServerResponse := AServerResponse;
  if not ADone then
  begin
    //20180219 Igor >>>
    if AServerResponse.ReturnCodeDescr <> '' then
      Log('Return info: ' + AServerResponse.ReturnCode + ': ' + AServerResponse.ReturnCodeCaption + ' ' + AServerResponse.ReturnCodeDescr);
    if AServerResponse.ResultCodeDescr <> '' then
      Log('Result info: ' + AServerResponse.ResultCodeDescr);
    //20180302 Igor >>>
    if AServerResponse.ReturnCode <> '0' then
      ShowHTMLError(AServerResponse);
    //20180302 Igor <<<
    //20180219 Igor <<<
    //20170403 Igor >>>
//    ShellExecute(0, 'OPEN', PChar(IncludeTrailingPathDelimiter(FApp.AppDir) +
//      'NOA' + FSelectedSIN + '.xml'), '', '', SW_SHOWNORMAL);
    NextStep;
    //20170403 Igor <<<
  end
  else
  begin
//20170405 Igor >>>
    //20190118 Igor >>>
    cMessage := Trim(FServerResponse.SummaryText);
    if SameText(cMessage, '') then
      cMessage := 'Your '+ FApp.AppYear +' return was assessed.';
    Application.MessageBox(PWideChar(cMessage), PWideChar(NotiseCaption(FServerResponse.NoticeType)),
      MB_OK + MB_ICONINFORMATION);
    //20190118 Igor <<<
    if FServerResponse.HaveHTMLBody then
    begin
//      ShellExecute(0, 'OPEN', PChar(IncludeTrailingPathDelimiter(FApp.AppDir) +
//        'NOA\' + FSelectedSIN + '.html'), '', '', SW_SHOWNORMAL);
      ShowMessageHTMLFromFile(IncludeTrailingPathDelimiter(FApp.AppDir) +
        'NOA\' + FSelectedSIN + '.html', -1, true);
      if chbAutoSaveToMobileDB.Checked then
        SilentAddFile(FApp, RetList[GetCurrentRetNo].SourceFlName, IncludeTrailingPathDelimiter(FApp.AppDir) +
          'NOA\' + FSelectedSIN + '.html', 'NOA');
    end;
    NextStep;
//20170405 Igor <<<
  end;
end;

procedure TfrmNOA.RecreateNOAFiles; //20180130 Igor
var cNOADir, cFile: string;
    I, nTaxYear: Integer; //20200131 Igor

type TNOA_File = record
    ResName: string;
    FileName: string;
  end;

const NOA_Files: array[0..6] of TNOA_File =
    (
      (ResName : 'BANNER_HTML'; FileName : 'banner.html'),
      (ResName : 'BANNER_FR_HTML'; FileName : 'banner.fr.html'),
      (ResName : 'FOOTER_HTML'; FileName : 'footer.html'),
      (ResName : 'FOOTER_FR_HTML'; FileName : 'footer.fr.html'),
      (ResName : 'HEADER_HTML'; FileName : 'header.html'),
      (ResName : 'NOTICE_HTML_XSL'; FileName : 'notice-html.xsl'),
      (ResName : 'NOTICE_REPLACE_XSL'; FileName : 'notice-replace.xsl')
    );

//20200131 Igor >>>    
const NOA_2019_Files: array[0..30] of TNOA_File =
    (
      (ResName : 'BANNER_HTML_2019'; FileName : 'banner.html'),
      (ResName : 'BANNER_FR_HTML_2019'; FileName : 'banner.fr.html'),
      (ResName : 'BUILD_RES_CMD_2019'; FileName : 'build_res.cmd'),
      (ResName : 'FOOTER_HTML_2019'; FileName : 'footer.html'),
      (ResName : 'FOOTER_FR_HTML_2019'; FileName : 'footer.fr.html'),
      (ResName : 'HEADER_HTML_2019'; FileName : 'header.html'),
      (ResName : 'NOA_EN_HTML_2019'; FileName : 'noa_en.html'),
      (ResName : 'NOA_EN_XML_2019'; FileName : 'noa_en.xml'),
      (ResName : 'NOA_FR_HTML_2019'; FileName : 'noa_fr.html'),
      (ResName : 'NOA_FR_XML_2019'; FileName : 'noa_fr.xml'),
      (ResName : 'NOA_RRSP_EN_HTML_2019'; FileName : 'noa_rrsp_en.html'),
      (ResName : 'NOA_RRSP_EN_XML_2019'; FileName : 'noa_rrsp_en.xml'),
      (ResName : 'NOA_RRSP_FR_HTML_2019'; FileName : 'noa_rrsp_fr.html'),
      (ResName : 'NOA_RRSP_FR_XML_2019'; FileName : 'noa_rrsp_fr.xml'),
      (ResName : 'NORA_EN_HTML_2019'; FileName : 'nora_en.html'),
      (ResName : 'NORA_EN_XML_2019'; FileName : 'nora_en.xml'),
      (ResName : 'NORA_FR_HTML_2019'; FileName : 'nora_fr.html'),
      (ResName : 'NORA_FR_XML_2019'; FileName : 'nora_fr.xml'),
      (ResName : 'NORA_RRSP_EN_HTML_2019'; FileName : 'nora_rrsp_en.html'),
      (ResName : 'NORA_RRSP_EN_XML_2019'; FileName : 'nora_rrsp_en.xml'),
      (ResName : 'NORA_RRSP_FR_HTML_2019'; FileName : 'nora_rrsp_fr.html'),
      (ResName : 'NORA_RRSP_FR_XML_2019'; FileName : 'nora_rrsp_fr.xml'),
      (ResName : 'NOTICE_REPLACE_XSL_2019'; FileName : 'notice-replace.xsl'),
      (ResName : 'XNOA_BODY_TRANSFORM_XSL_2019'; FileName : 'xnoa-body-transform.xsl'),
      (ResName : 'XNOA_HTML_TRANSFORM_XSL_2019'; FileName : 'xnoa-html-transform.xsl'),
      (ResName : 'CRA_BRANDING_CSS_2019'; FileName : 'css\cra-branding.css'),
      (ResName : 'THEME_MIN_CSS_2019'; FileName : 'css\theme.min.css'),
      (ResName : 'FAVICON_ICO_2019'; FileName : 'images\favicon.ico'),
      (ResName : 'SIG_BLK_EN_SVG_2019'; FileName : 'images\sig-blk-en.svg'),
      (ResName : 'SIG_BLK_FR_SVG_2019'; FileName : 'images\sig-blk-fr.svg'),
      (ResName : 'WMMS_BLK_SVG_2019'; FileName : 'images\wmms-blk.svg')
    );
//20200131 Igor <<<

  procedure SaveResourceToFile(AResName, AFileName, AResType: string);
  var
    FResStream: TResourceStream;
    FFileStream: TFileStream;
  begin
    FResStream := TResourceStream.Create(FindClassHInstance(TfrmNOA), AResName, PChar(AResType)) ;
    try
      FFileStream := TFileStream.Create(AFileName, fmCreate) ;
      try
        FFileStream.CopyFrom(FResStream, 0) ;
      finally
        FFileStream.Free;
      end;
    finally
      FResStream.Free;
    end;
  end;

  procedure CopyFiles(A: array of TNOA_File; AResource: string); //20200131 Igor
  var I: integer;
  begin
    for I := 0 to Length(A) - 1 do
    begin
      cFile := cNOADir + A[I].FileName;
      ForceDirectories(ExtractFilePath(cFile));
      //if not FileExists(cFile) then //20180131 Igor
        SaveResourceToFile(A[I].ResName, cFile, AResource);
    end;
  end;

begin
  cNOADir := IncludeTrailingPathDelimiter(FApp.AppDir) + 'NOA\';
  if not ForceDirectories(cNOADir) then
  begin
    UserMsg('Cannot create '+ QuotedStr(cNOADIr));
    Exit;
  end;
  try
  	//20200131 Igor >>>
    nTaxYear := StrToIntDef(FApp.AppYear, 0);
    if nTaxYear < 2019 then
      CopyFiles(NOA_Files, 'T1_NOA')
    else
      CopyFiles(NOA_2019_Files, 'T1_NOA_2019');
    //20200131 Igor <<<
  except on E: Exception do
    ExceptMsg(Exception.Create('Error in RecreateNOAFiles: ' + E.Message));
  end;
end;

procedure TfrmNOA.btnExecuteNOAClick(Sender: TObject);
begin
  if btnExecuteNOA.Tag = 0 then
  begin
    btnExecuteNOA.Tag := 1;
    btnExecuteNOA.Caption := 'Stop';
    btnNext.Enabled := False;
    mmoLog.Lines.Clear;
    RecreateNOAFiles; //20180130 Igor
    FSender := TSender.Create(FTaxPayerGivenName, FTaxPayerSurname, FSelectedSIN, FApp.AppYear,
      IncludeTrailingPathDelimiter(FApp.AppDir) + 'NOA', CallBack,
      Log, chbAutoClose.Checked, rgTestOrProd.ItemIndex = 1, Trim(edNOAKey.Text));
  end
  else
    StopThread;
end;

procedure TfrmNOA.edFilterChange(Sender: TObject);
begin
  tblClients.Filtered := False;
  tblClients.Filtered := True;
  tblClients.First;
end;

procedure TfrmNOA.grClientsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    NextStep;
end;

procedure TfrmNOA.grClientsTitleClick(Column: TColumn);
begin
  if tblClients.IndexFieldNames = Column.FieldName then
    tblClients.IndexFieldNames := ''
  else
    tblClients.IndexFieldNames := Column.FieldName;
end;

procedure TfrmNOA.Log(AMessage: String);
begin
  mmoLog.Lines.Add(FormatDateTime('YYYY/MM/DD hh:nn:ss', Now) + ': ' + AMessage);
end;

procedure TfrmNOA.btnNextClick(Sender: TObject);
begin
  NextStep;
end;

procedure TfrmNOA.btnCancel2Click(Sender: TObject);
begin
  if pgcWizard.ActivePageIndex = (pgcWizard.PageCount - 1) then
  begin
    pgcWizard.ActivePageIndex := 0;
    RefreshStep;
  end
  else
    ModalResult := mrCancel;
end;

procedure TfrmNOA.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult <> mrOk then
  begin
    if MessageDlg('Are you sure you want to quit?', mtConfirmation, [mbYes, mbCancel], 0) <> mrYes then
      CanClose := False;
    if CanClose then
      StopThread;
  end;
end;

procedure TfrmNOA.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to pgcMain.PageCount - 1 do
    pgcMain.Pages[I].TabVisible := False;
  for I := 0 to pgcWizard.PageCount - 1 do
    pgcWizard.Pages[I].TabVisible := False;
  pgcMain.ActivePage := tsStart;
  pgcWizard.ActivePageIndex := 0;
end;

procedure TfrmNOA.NextStep;
begin
  if not AllowNextStep then
    Exit;
  if pgcWizard.ActivePageIndex = pgcWizard.PageCount - 1 then
  //20170328 igor >>>
  begin
    if (FServerResponse.ResultCode = 'FOUND')
   // and (FServerResponse.NoticeType = '1451') //20170407 Igor  //20170410
    then
      MessageDlg(c_lastMessage, mtInformation, [mbOk], 0);
    ModalResult := mrOk;
  end
  //20170328 igor<<<
  else
  begin
    pgcWizard.ActivePageIndex := pgcWizard.ActivePageIndex + 1;
    RefreshStep;
  end;
end;

procedure TfrmNOA.PrevStep;
begin
  if (pgcWizard.ActivePageIndex = 0) or
     ((pgcWizard.ActivePageIndex = 1) and (FRet <> nil)) then  //20170328 Igor
    pgcMain.ActivePage := tsStart
  else
    pgcWizard.ActivePageIndex := pgcWizard.ActivePageIndex - 1;
  btnNext.Enabled := True;
end;

procedure TfrmNOA.RefreshStep;  //20170328 igor All proc
var
  I: Integer;
  WorkRetNo: Integer;
  FileName: string;
  FileDate: TDateTime;
begin
  if pgcWizard.ActivePageIndex = pgcWizard.PageCount - 1 then
  begin
    btnNext.Caption := 'Finish';
    btnCancel2.Caption := 'Try again';
  end
  else
  begin
    btnNext.Caption := 'Next >>>';
    btnCancel2.Caption := 'Cancel';
  end;
  if (pgcWizard.ActivePage = tsSelectReturn) AND (FRet <> nil) then
    pgcWizard.ActivePage := tsProcess;

  if pgcWizard.ActivePage = tsSelectReturn then
  begin
    if tblClients.IsEmpty then
      SetTableName(conClients, tblClients, IncludeTrailingPathDelimiter(FApp.Dir_Cur) + FApp.ClientsDBLite, ClientsTableLite, '');
  end
  else
  if pgcWizard.ActivePage = tsProcess then
  begin
    btnNext.Enabled := False;
    btnExecuteNOA.Caption := 'Request the electronic delivery of the NOA';  //20190128
    btnExecuteNOA.Tag := 0;
    if FRet <> nil then
    begin
      FSelectedSIN := FRet.GetSIN;
      FTaxPayerGivenName := FRet.GetFirstName;
      FTaxPayerSurname := FRet.GetLastName;
      FDCN := FRet.GetDCN;
      btnExecuteNOA.Enabled := FDCN <> '';
    end
    else
    begin
      WorkRetNo := FApp.OpenReturn(FApp.Dir_Cur, tblClients.FieldByName('FILE_NAME').AsString,
        False, False);
      if WorkRetNo > 0 then
      begin
        try
          FSelectedSIN := RetList[WorkRetNo].GetSIN;
          FTaxPayerGivenName := RetList[WorkRetNo].GetFirstName;
          FTaxPayerSurname := RetList[WorkRetNo].GetLastName;
          FDCN := RetList[WorkRetNo].GetDCN;
          btnExecuteNOA.Enabled := FDCN <> '';
        finally
          DeEnlistReturn(WorkRetNo);
        end;
      end
      else
      begin
        btnExecuteNOA.Enabled := False;
      end
    end;
    vlReturnInfo.Strings.BeginUpdate;
    try
      vlReturnInfo.Strings.Clear;
      vlReturnInfo.InsertRow('SIN', FSelectedSIN, True);
      vlReturnInfo.InsertRow('Given Name', FTaxPayerGivenName, True);
      vlReturnInfo.InsertRow('Surname', FTaxPayerSurname, True);
      vlReturnInfo.InsertRow('DCN', FDCN, True);
    finally
      vlReturnInfo.Strings.EndUpdate;
    end;
    //20170328 Igor >>>
    FileName := IncludeTrailingPathDelimiter(FApp.AppDir) +
      'NOA\' + FSelectedSIN + '.html';
    if FileExists(FileName) then
    begin
      pnlViewOld.Visible := True;
      if FileAge(FileName, FileDate) then
        btnViewOld.Caption := 'View NOA response from ' + DateTimeToStr(FileDate);
    end
    else
      pnlViewOld.Visible := False;
    //20170328 Igor<<<
  end
  else
  if pgcWizard.ActivePage = tsFinish then
  begin
    if FServerResponse.ResultCode = 'FOUND' then
    begin
      lblFinish.Caption := Format(c_FinishOkMessage, [FApp.AppYear,
        FServerResponse.PayerName, Copy(FDCN, 1, 7) + '-' + Copy(FDCN, 8, maxInt)]);
      lblHTMLPath.Caption := FApp.AppDir + '\NOA\' + FSelectedSIN + '.html';
    end
    else
    begin
      lblFinish.Caption := c_FinishNoDataMessage;
      lblHTMLPath.Caption := '';
    end;
  end;
  
end;

procedure TfrmNOA.StopThread;
begin
  if Assigned(FSender) then
  begin
    FSender.Terminate;
    while FSender <> nil do
    begin
      sleep(50);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrmNOA.tblClientsFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  I: Integer;
begin
  Accept := True;
  if edFilter.Text = '' then
    Exit;
  for I := 0 to tblClients.FieldCount - 1 do
  begin
    if Pos(LowerCase(edFilter.Text), LowerCase(tblClients.Fields[I].AsString)) > 0 then
      Exit;
  end;
  Accept := False;
end;

{ TSender }

constructor TSender.Create(ATaxPayerGivenName, ATaxPayerSurname, ASIN, ATaxYear,
  ASaveDir: String; ACallBack: TCallBack; ALog: TLog;
  ANeedCloseWebPage, ATest: Boolean; AForceKey: string);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FTaxPayerGivenName := ATaxPayerGivenName;
  FTaxPayerSurname := ATaxPayerSurname;
  FSIN := ASIN;
  FTaxYear := ATaxYear;
  FSaveDir := ASaveDir;
  FxsltPath := IncludeTrailingPathDelimiter(FSaveDir) + 'notice-html.xsl';
  FCallBack := ACallBack;
  FNeedCloseWebPage := ANeedCloseWebPage;
  FLog := ALog;
  FDone := False;
  FTest := ATest;
  FForcekey := AForceKey;
end;

procedure TSender.CreateAuthorizationWindow(AUrl: string);

begin

end;

function TSender.CreateNOASoapMessageXml: string;
begin
  FSOAPMessage := SOAPRequesrHeader +
    '<S:Body>'+
    '<GetNOA xmlns="'+ FRequestData.xmlns +'">'+ //20200130 Igor
    '<TokenIdentifier>' + FRequestData.TokenTitle + '</TokenIdentifier>'+
    '<TaxYear>' + FRequestData.TaxYear + '</TaxYear>'+
    '</GetNOA>'+
    '</S:Body>'+
    '</S:Envelope>';
  
  Log('Request for get NOA prepared');
end;

procedure TSender.DoCallBack;
begin
  if Assigned(FCallBack) then
    FCallBack(Self, FServerResponse, FDone);
end;

procedure TSender.DoLog;
begin
  if Assigned(FLog) then
    FLog(FLastMessage);
end;

procedure TSender.Execute;
begin
  CoInitialize(Nil);
  try
    try
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      if not SetRequestDataInput then
        Exit;
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      GenerateSOAPMessage;

      // saving our request xml in file
      with TStringStream.Create(FSOAPMessage) do
      begin
        try
          SaveToFile(FSaveDir + '\' + 'NOA-'+FSIN+'_TokenRequest.xml');
        finally
          free;
        end;
      end;

      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      SendSOAPMessage;
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      GetResultInfoServerError;
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      if FServerResponse.ReturnCode = '0' then
      begin
        LinkToCRALogin;
        if Terminated then
        begin
          Log('Process stopped');
          Exit;
        end;
        if FRequestData.TokenTitle <> '' then
        begin
          CreateNOASoapMessageXml;
          if Terminated then
          begin
            Log('Process stopped');
            Exit;
          end;
          SendSOAPMessage;
          if Terminated then
          begin
            Log('Process stopped');
            Exit;
          end;
          SaveRequestNOA;
          if Terminated then
          begin
            Log('Process stopped');
            Exit;
          end;
          ProcessRequestNOA;
        end;
      end;
    finally
      Synchronize(DoCallBack);
    end;
  finally
    CoUninitialize;
  end;
end;

function TSender.GenerateNonce: string;
var
  randomInt: integer;
begin
  randomInt := Random(1000000);
  Result := Format('%.*d', [7, randomInt]) + FormatDateTime('dddddhh:nn:ss.zzz', Now());
end;

function TSender.GeneratePasswordDigest: String;
var
  pDigest: string;
begin
 (* to see what the secret key is
  //20200127
  If UpperCase(InputBox('', 'PSW', '')) <> 'CRA' then exit;
  ShowMessage(FRequestData.SecretAccessKey); //20200127
  *)
 //-------------------------------
  //20200108 Igor >>>
  if FRequestData.SecretAccessKey.IsEmpty then
    raise Exception.Create('Secret key is missing');
  //20200108 Igor <<<
  Result := Trim(Password_Digest(FRequestData.Nonce, FRequestData.Created, FRequestData.SecretAccessKey));
end;
function TSender.SOAPRequesrHeader: string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>'+
      '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">'+
      '<S:Header>'+
      '<wsse:Security S:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+
      '<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
      '<wsse:Username>' + FRequestData.UserName + '</wsse:Username>'+
      '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">'
        + FRequestData.PasswordDigest + '</wsse:Password>'+
      '<wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">'
        + FRequestData.NonceB64 + '</wsse:Nonce>'+
      '<wsu:Created>' + FRequestData.Created + '</wsu:Created>'+
      '</wsse:UsernameToken>'+
      '</wsse:Security>'+
      '</S:Header>';
end;

procedure TSender.GenerateSOAPMessage;
begin
  FSOAPMessage := SOAPRequesrHeader+
      '<S:Body>'+
      '<StageNOA xmlns="'+ FRequestData.xmlns +'">'+ //20200130 Igor
      '<TaxYear>' + FRequestData.TaxYear + '</TaxYear>'+
      '<Sin>' + FSIN + '</Sin>'+
      '</StageNOA>'+
      '</S:Body>'+
      '</S:Envelope>';
  Log('Request for authorization prepared');  //20170328 CON
end;

function TSender.Password_Digest(ANonce, ACreated, APassword: AnsiString): AnsiString;
var
  crypt: TTXPCrypto;
  bytesToHash, nonceBytes, CreatedBytes, passwordBytes: TBytes;

  function GetBytes(const AText: ansistring): TBytes;
  begin
    SetLength(result, Length(AText));
    if Length(AText) > 0 then
      Move(AText[1], result[0], Length(AText));
  end;

  function Concat(const AParam1, AParam2, AParam3: TBytes): TBytes;
  var
    Idx: integer;
  begin
    SetLength(result, Length(AParam1) + Length(AParam2) + Length(AParam3));
    Idx := 0;
    Move(AParam1[0], result[Idx], Length(AParam1));
    Inc(Idx, Length(AParam1));
    Move(AParam2[0], result[Idx], Length(AParam2));
    Inc(Idx, Length(AParam2));
    Move(AParam3[0], result[Idx], Length(AParam3));
  end;

begin
  crypt := TTXPCrypto.Create;
  try
    nonceBytes := GetBytes(ANonce);
    CreatedBytes := GetBytes(ACreated);
    passwordBytes := GetBytes(APassword);
    bytesToHash := Concat(nonceBytes, CreatedBytes, passwordBytes);
    result := crypt.base64Encode(crypt.SHA1Hash(bytesToHash))
  finally
    crypt.free;
  end;
end;

procedure TSender.ProcessRequestNOA;
var
  HashSIN: string;
  crypt: HCkCrypt2;
  I: Integer;
  WB: TWebBrowser;

begin
  GetResultInfoServerError;
  if (
       (FServerResponse.ReturnCode = '0')
       or
       (FServerResponse.ReturnCode = '20')
     )
     and
     (SameText(FServerResponse.ResultCode, 'FOUND')) then
  begin
    //20170405 Igor >>>
    if (FServerResponse.HaveHTMLBody) then
    begin
    //20170405 Igor <<<
      crypt := CkCrypt2_Create();
      if CkCrypt2_UnlockComponent(crypt, 'djhzcoCrypt_Y7xcLWVr6XPk') then
      begin
        CkCrypt2_putEncodingMode(crypt, 'hex');
        CkCrypt2_putHashAlgorithm(crypt, 'sha256');
        HashSIN := CkCrypt2__hashStringENC(crypt, PWideChar(FSIN));
        // 20171223 Igor >>>
        if StrToIntDef(FTaxYear, 0) >= 2017 then //20190118 Igor
        begin
          FSOAPResponse := TRegEx.Replace(FSOAPResponse,
                                          '(<ns[0-9]:TaxPayerGivenName>)'+HashSIN+'(</ns[0-9]:TaxPayerGivenName>)',
                                          '\1'+ FTaxPayerGivenName +'\2');
          FSOAPResponse := TRegEx.Replace(FSOAPResponse,
                                          '(<ns[0-9]:TaxPayerSurname>)'+HashSIN+'(</ns[0-9]:TaxPayerSurname>)',
                                          '\1'+ FTaxPayerSurname +'\2');
          FSOAPResponse := TRegEx.Replace(FSOAPResponse,
                                          '(<ns[0-9]:MaskedAccountNumber>)'+HashSIN+'(</ns[0-9]:MaskedAccountNumber>)',
                                          '\1'+ 'XXX XXX ' + Copy(FSIN, 7, 3) + '\2');
        end
        else
        begin
          FSOAPResponse := ReplaceText(FSOAPResponse,'<ns2:TaxPayerGivenName>'+HashSIN+'</ns2:TaxPayerGivenName>',
            '<ns2:TaxPayerGivenName>'+FTaxPayerGivenName+'</ns2:TaxPayerGivenName>');
          FSOAPResponse := TRegEx.Replace(FSOAPResponse,'<ns2:TaxPayerSurname>'+HashSIN+'</ns2:TaxPayerSurname>',
            '<ns2:TaxPayerSurname>'+FTaxPayerSurname+'</ns2:TaxPayerSurname>');
          FSOAPResponse := TRegEx.Replace(FSOAPResponse,'<ns2:MaskedAccountNumber>'+HashSIN+'</ns2:MaskedAccountNumber>',
            '<ns2:MaskedAccountNumber>' + 'XXX XXX ' + Copy(FSIN, 7, 3) + '</ns2:MaskedAccountNumber>');
        end;
        // 20171223 Igor <<<
      end;

      FServerResponse.PayerName := FTaxPayerGivenName + FTaxPayerSurname;
      I := Pos('?>', FSOAPResponse) + 1;
      FSOAPResponse := Copy(FSOAPResponse, 1, I) + '<?xml-stylesheet type=''text/xsl'' href='''+ FRequestData.transform_xsl +'''?>' + Copy(FSOAPResponse, I + 1, MaxInt); //20200131 Igor
      with TStringStream.Create(FSOAPResponse) do
      begin
        try
          SaveToFile(FSaveDir + '\' + FSIN+'.xml');
        finally
          free;
        end;
      end;
      //20200131 Igor >>>
      {WB := TWebBrowser.Create(nil);
      try
        WBDone := False;
        WB.OnNavigateComplete2 := WBNavigateComplete2;
        WB.Navigate(FSaveDir + '\' + FSIN+'.xml');
        while not WBDone do
        begin
          Sleep(1000);
          Application.ProcessMessages;
        end;
      finally
        WB.Free;
      end;}
      Synchronize(procedure
        begin
          TransformNOA(FSaveDir + '\' + FSIN+'.xml');
        end);
      //20200131 Igor <<<
    end;
    FDone := True;
  end
  else
  begin
    FDone := False;
  end;
end;

procedure TSender.SaveRequestNOA;
begin
  FSOAPResponse := stringreplace(FSOAPResponse, 'UTF-8', 'ISO-8859-1',[rfIgnoreCase]);  //20190204 jz
  FReceivedFlName := FSaveDir + '\' + 'NOA-'+FSIN+'.xml';
  with TStringStream.Create(FSOAPResponse) do
  begin
    try
      SaveToFile(FReceivedFlName);
    finally
      free;
    end;
  end;
  Log('Request from NOA Saved to file "'+FReceivedFlName+'"');
end;

function TSender.GetInternetDateTime: TDateTime;
var
  I: integer;
  myDate: TDateTime;
  S: string;
  mySNTP: TIdSNTP;
  //20170405 Igor >>>
const
  ntpServers: array [0..14] of string =
    ('ntp2.cs.wisc.edu',
     'ca.pool.ntp.org',
     'us.pool.ntp.org',
     'time.chu.nrc.ca',
     'ntp1.cmc.ec.gc.ca',
     'ntp.cpsc.ucalgary.ca',
     'timelord.uregina.ca',
     '1.north-america.pool.ntp.org',
     '2.north-america.pool.ntp.org',
     '2.north-america.pool.ntp.org',
     '3.north-america.pool.ntp.org',
     '0.ca.pool.ntp.org',
     '1.ca.pool.ntp.org',
     '2.ca.pool.ntp.org',
     '3.ca.pool.ntp.org');
   //20170405 Igor <<<
begin
  mySNTP := TIdSNTP.Create;
  try
    //mySNTP.Host := 'ntp2.cs.wisc.edu';//20170405 Igor
    mySNTP.ReceiveTimeout := 3000;
    for I := Low(ntpServers) to High(ntpServers) do
    begin
      mySNTP.Host := ntpServers[I];//20170405 Igor
      myDate := mySNTP.DateTime;
      myDate := TTimeZone.Local.ToUniversalTime(myDate);
      S := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', myDate);
      if pos('1899', S) = 0 then
        break;
    end;
    result := myDate;
  finally
    mySNTP.free;
  end;
end;

procedure TSender.GetResultInfoServerError;
var
  X: XML.XMLDoc.TXMLDocument;
  N, Manifest, NOADATA, Fault: IXMLNode; //20190128 Igor
  function ClearXML(AXML: String): string;
  begin
    Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
    Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
  end;
begin
  FServerResponse.ReturnCodeCaption := ''; //20180219 Igor
  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      X.XML.Add(ClearXML(FSOAPResponse));
      if not(X.Active) then
        X.Active := true;
      N := X.DocumentElement;
      if (N = nil) or (N.NodeName <> 'Envelope') then
        raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
      N := N.ChildNodes.FindNode('Body');
      if (N = nil) then
        raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
      //20190128 Igor >>>
      Fault := N.ChildNodes.FindNode('Fault');
      if Fault <> nil then
        raise Exception.Create(VarToStr(Fault.ChildValues['faultstring']));
      //20190128 Igor <<<
      N := N.ChildNodes.First;
      if (N = nil) then
        raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
      FServerResponse.ReturnCode := VarToStr(N.ChildValues['ReturnCode']);
      FRequestData.TokenC := VarToStr(N.ChildValues['TokenIdentifier']);
      //20170405 Igor >>>
      N := N.ChildNodes.FindNode('NoticeOfAssessment');
      if N <> nil then
      begin
        Manifest := N.ChildNodes.FindNode('Manifest');
        if Manifest <> nil then
        begin
          Manifest := Manifest.ChildNodes.FindNode('ManifestLine');
          if Manifest <> Nil then
          begin
            Manifest := Manifest.ChildNodes.FindNode('ResultCode');
            if Manifest <> nil then
              FServerResponse.ResultCode := VarToStr(Manifest.NodeValue);
          end;
        end;
        NOADATA := N.ChildNodes.FindNode('NoticeOfAssessmentData');
        if NOADATA <> nil then
        begin
          NOADATA := NOADATA.ChildNodes.FindNode('NoticeOfAssessmentItem');
          if NOADATA <> Nil then
          begin
            N := NOADATA.ChildNodes.FindNode('AssessmentSummaryText');
            if N <> nil then
              FServerResponse.SummaryText := VarToStr(N.NodeValue);
            N := NOADATA.ChildNodes.FindNode('T1Notice');
            if N <> nil then
            begin
              FServerResponse.HaveHTMLBody := True;
              N := N.ChildNodes.FindNode('NoticeType');
              if N <> nil then
                FServerResponse.NoticeType := VarToStr(N.NodeValue);
            end
            else
              FServerResponse.HaveHTMLBody := False;
          end;
        end;
        //20170405 Igor <<<
      end;
    except ON E: Exception DO
      begin
        FServerResponse.ReturnCode := '-1';
        FServerResponse.ReturnCodeDescr := E.Message;
      end;
    end;
    //20180219 Igor >>>
    if FServerResponse.ReturnCode = '0' then
    begin
      FServerResponse.ReturnCodeCaption := 'REQUEST_ACCEPTED';
      FServerResponse.ReturnCodeDescr := 'The request for tax data has been accepted.  The tax data is being assembled.';
    end
    else
    if FServerResponse.ReturnCode = '10' then
    begin
      FServerResponse.ReturnCodeCaption := 'NOT_READY';
      FServerResponse.ReturnCodeDescr := 'The tax data is not ready, please wait and make another call.';
    end
    else
    if FServerResponse.ReturnCode = '20' then
    begin
      FServerResponse.ReturnCodeCaption := 'FOUND';
      FServerResponse.ReturnCodeDescr := 'The  tax data has been found and returned.';
    end
    else
    if FServerResponse.ReturnCode = '201' then
    begin
      FServerResponse.ReturnCodeCaption := 'INVALID_REQUEST';
      FServerResponse.ReturnCodeDescr := 'The request for tax data is not structured properly.';
    end
    else
    if FServerResponse.ReturnCode = '202' then
    begin
      FServerResponse.ReturnCodeCaption := 'INVALID_SP_ID';
      FServerResponse.ReturnCodeDescr := 'The SPID provided is invalid. Currently not used.';
    end
    else
    if FServerResponse.ReturnCode = '203' then
    begin
      FServerResponse.ReturnCodeCaption := 'INVALID_TAX_YEAR';
      FServerResponse.ReturnCodeDescr := 'The tax year provided is invalid.';
    end
    else
    if FServerResponse.ReturnCode = '204' then
    begin
      FServerResponse.ReturnCodeCaption := 'INVALID_TOKEN';
      FServerResponse.ReturnCodeDescr := 'The token provided is invalid. The token is mandatory input.';
    end
    else
    if FServerResponse.ReturnCode = '205' then
    begin
      FServerResponse.ReturnCodeCaption := 'INVALID_SIN';
      FServerResponse.ReturnCodeDescr := 'The SIN(s) provided is invalid. More than 10 SINs. Duplicate SINs. SIN is mandatory input.';
    end
    else
    if FServerResponse.ReturnCode = '501' then
    begin
      FServerResponse.ReturnCodeCaption := 'SERVICE_UNAVAILABLE';
      FServerResponse.ReturnCodeDescr := 'The system is currently unavailable. Please refer to times of operation.';
    end
    else
    if FServerResponse.ReturnCode = '502' then
    begin
      FServerResponse.ReturnCodeCaption := 'SYSTEM_BUSY';
      FServerResponse.ReturnCodeDescr := 'The system is too busy. Please retry later.';
    end
    else
    if FServerResponse.ReturnCode = '503' then
    begin
      FServerResponse.ReturnCodeCaption := 'SYSTEM_ERROR';
      FServerResponse.ReturnCodeDescr := 'A system error occurred. This could be a temporary condition. A retry may be successful.';
    end;
    //20180219 Igor <<<

    if FServerResponse.ResultCode = 'FOUND' then
      FServerResponse.ResultCodeDescr := 'The tax data has been found for a given SIN and no issues were encountered'
    else
    if FServerResponse.ResultCode = 'FOUND_INCOMPLETE' then
    begin
      FServerResponse.ResultCodeDescr := 'The tax data has been found for a given SIN BUT issues were encountered';
      repeat
        N := N.NextSibling;
        if N.NodeName = 'SubResultCode' then
          FServerResponse.ResultCodeDescr := FServerResponse.ResultCodeDescr + #13 +
            VarToStr(N.NodeValue);
      until N = nil ;
    end
    else
    if FServerResponse.ResultCode = 'NO_DATA' then
      FServerResponse.ResultCodeDescr := 'The tax data has NOT been found for a given SIN and no issues were encountered'
    else
    if FServerResponse.ResultCode = 'ERROR' then
      FServerResponse.ResultCodeDescr := 'Unable to return data due to errors';
  finally
    X.Free;
  end;
  Log('Response from CRA parsed');
end;

function TSender.HMACSHA256Encode(S, Key: PWideChar): string;
var
  success: boolean;
  crypt: HCkCrypt2;
  mac: PWideChar;
  keyEncoding: PWideChar;
begin
  crypt := CkCrypt2_Create;
  // Any string argument automatically begins the 30-day trial.
  success := CkCrypt2_UnlockComponent(crypt, 'djhzcoCrypt_Y7xcLWVr6XPk');
  if (success <> true) then
  begin
    FServerResponse.ReturnCode := '-1';
    FServerResponse.ReturnCodeDescr := CkCrypt2__lastErrorText(crypt);
    Terminate;
    Exit;
  end;
  CkCrypt2_putEncodingMode(crypt, 'base64');
  CkCrypt2_putHashAlgorithm(crypt, 'sha256');
  keyEncoding := 'ansi';
  CkCrypt2_SetHmacKeyEncoded(crypt, key, keyEncoding);
  mac := CkCrypt2__hmacStringENC(crypt, s);
  result := mac;
end;

procedure TSender.LinkToCRALogin;
var
  TokenRequestUrl: string;
  BaseStr, Lang, Auth, SignedKey, SpIDstr,
  TimestampStr, AuthStr, TokenCStr, SWTaxYear: string;
  BaseStrToSign: PWideChar;
  TimeStamp : int64;
  myDate: TDateTime;
begin
  myDate := GetInternetDateTime;
  TimeStamp := SecondsBetween(myDate, EncodeDateTime(1970, 01, 01, 0, 0, 0, 0)) + 1;
  auth := FRequestData.Auth_Param;
  authStr := HttpEncode(auth);
  Lang := 'en';
  SWTaxYear := FRequestData.taxYear;
  TokenCStr := HttpEncode(FRequestData.TokenC);
  BaseStr := FRequestData.userName + HttpEncode(FRequestData.TrunkApplicationUrl) + inttostr(timestamp) +
    authStr + lang + tokenCStr + swtaxyear;
  BaseStrToSign := PWideChar(BaseStr);
  SignedKey := HMACSHA256Encode(baseStrToSign, pchar(FRequestData.SecretAccessKey));
  SignedKey := HttpEncode(SignedKey);

  SpIDstr := '?spID=' + FRequestData.UserName;
  timestampStr := '&timestamp=' + inttostr(Timestamp);
  AuthStr := '&auth=' + HttpEncode(Auth);
  SignedKey := '&key=' + SignedKey;
  TokenCStr := '&t=' + TokenCStr;
  Lang := '&lang=' + Lang;
  SWTaxYear := '&swtaxyear=' + SWTaxYear;
  tokenRequestUrl := FRequestData.WebApplicationUrl + SpIDstr + TimeStampStr + AuthStr +
    SignedKey + TokenCStr + Lang + SWTaxYear;
  {
  ShellExecute(0, 'OPEN', pchar('' + TokenRequestUrl), '', '', SW_SHOWNORMAL);
  Log('Start authorization');   //20170328
  WaitTitleToken;
  }
  Synchronize(procedure
    begin
      FRequestData.TokenTitle := GetToken(tokenRequestUrl); //20220216 Igor
    end);
  if FRequestData.TokenTitle > '' then
    Log('Authorization done');
  Synchronize(procedure
    begin
      Application.BringToFront;
    end);
end;

procedure TSender.Log(AMessage: String);
begin
  FLastMessage := AMessage;
  Synchronize(DoLog);
end;

procedure TSender.WaitTitleToken;
var
  i: integer;
  lStart: Boolean;
  (* //20170330 Igor
  function CRAPageExists: Boolean;
  var
    DT: TDateTime;
    hWndTemp: HWND;
    iLenText: Integer;
    cTitletemp: array [0 .. 254] of Char;
    sTitleTemp: string;
    partialTitle, partialTitle2, partialTitle3, partialTitle4: string;
    CRAWindowExists: Boolean;
  begin
    partialTitle := UpperCase('Canada Revenue Agency - CRA Login');
    partialTitle2 := UpperCase('Auto-fill my return');
    partialTitle3 := UpperCase('https://apps-ct.cra-arc.gc.ca/ebci/awsc/tdd/certtest/auth/pub/wtTokenTransfer');
    partialTitle4 := UpperCase('Express NOA&mdash;request confirmation');

    CRAWindowExists := False;

    hWndTemp := FindWindow(nil, nil);
    while hWndTemp <> 0 do
    begin
      iLenText := GetWindowText(hWndTemp, cTitletemp, 255);
      sTitleTemp := cTitletemp;
      sTitleTemp := UpperCase(copy(sTitleTemp, 1, iLenText));
      if (pos(partialTitle, sTitleTemp) <> 0) or
         (pos(partialTitle2, sTitleTemp) <> 0) or
         (pos(partialTitle3, sTitleTemp) <> 0) or
         (pos(partialTitle4, sTitleTemp) <> 0) then
      begin
        CRAWindowExists := True;
        lStart := False;
        break;
      end;
      hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
    end;
    Result := CRAWindowExists or lStart;
    if not Result then
    begin
      FServerResponse.ReturnCode := '-1';
      FServerResponse.ReturnCode := 'CRA WEB page closed without authorization';  //20170328

      FServerResponse.ResultCode := '';
      FServerResponse.ResultCodeDescr := '';
    end;
  end;
  *)
  function ReturnTokenFromTitle: string;
  var
    hWndTemp: hWnd;
    iLenText: integer;
    cTitletemp: array [0 .. 254] of Char;
    sTitleTemp: string;
    partialTitle: string;
    title, token: string;
    function ExtractBetween(const Value, A, B: string): string;
    var
      aPos, bPos: integer;
    begin
      result := '';
      aPos := pos(A, Value);
      if aPos > 0 then
      begin
        aPos := aPos + Length(A);
        bPos := PosEx(B, Value, aPos);
        if bPos > 0 then
          result := copy(Value, aPos, bPos - aPos);
      end;
    end;
  begin
    partialTitle := 'token={';

    hWndTemp := FindWindow(nil, nil);
    while hWndTemp <> 0 do
    begin
      iLenText := GetWindowText(hWndTemp, cTitletemp, 255);
      sTitleTemp := cTitletemp;

      title := sTitleTemp;

      sTitleTemp := UpperCase(copy(sTitleTemp, 1, iLenText));
      partialTitle := UpperCase(partialTitle);
      if pos(partialTitle, sTitleTemp) <> 0 then
      begin
        if FNeedCloseWebPage then
        begin

          SetForegroundWindow(hWndTemp);
          sleep(10);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
          sleep(10);
          keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), 0, 0);
          sleep(10);
          keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), KEYEVENTF_KEYUP, 0);
          sleep(10);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
          SetForegroundWindow(Handle);
        end;
        break;
      end;
      hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
    end;
    token := ExtractBetween(title, '{', '}');
    result := token;
  end;
begin
  FRequestData.TokenTitle := '';
  i := 0;
  lStart := True;
  while not Terminated {and CRAPageExists} do //20170330 Igor
  begin
    Inc(i);
    sleep(400);

    if i > 5 then
    Begin
      FRequestData.TokenTitle := ReturnTokenFromTitle;
      if FRequestData.TokenTitle > '' then
        break;
    end;
  end;
  if FRequestData.TokenTitle > '' then
    Log('Authorization done');  //20170328 CON
end;

procedure TSender.WBNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
  const URL: OleVariant);
var
  XMLDOMDocument: IHtmldocument2;
  i: integer;
  HTMLResult: string;
  WB: TWebBrowser;
begin
//20170405 Igor >>>
  try
    try
      WB := ASender as TWebBrowser;
      if not Assigned(WB.Document) then exit;
      HTMLResult := '';
      XMLDOMDocument := WB.Document as IHtmldocument2;
      for i := 1 to 2 do
      begin
        HTMLResult := HTMLResult + (XMLDOMDocument.all.item(i,i) as IHTMLElement).outerHTML ;
      end;
      //20171224 Igor >>>
      HTMLResult := ReplaceHTML_SpecChars(HTMLResult);
      //20171224 Igor <<<

      with TStringStream.Create(HTMLResult) do
      try
        FReceivedFlName := FSaveDir + '\' + FSIN+'.html';
        SaveToFile(FReceivedFlName);
      finally
        free;
      end;
    except ON E: Exception DO
      begin
        FLastMessage := E.Message;
        DoLog;
      end;
    end;
  finally
    WBDone := True;
  end;
//20170405 Igor <<<
end;

procedure TSender.SendSOAPMessage;
var
  objHttp: ixmlHttpRequest;
  Attempt: Integer; //20170405 Igor
begin
  //20170405 Igor >>>
  Attempt := 0;
  repeat
    objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
    objHttp.open('POST', FRequestData.WebServiceUrl, False, FRequestData.UserName, FRequestData.SecretAccessKey);
    objHttp.setRequestHeader('SOAPAction', 'NA');
    objHttp.setRequestHeader('Content-Type', 'text/xml');
    try
      objHttp.send(FSOAPMessage);
      Break;
    except
      inc(Attempt);
      if Attempt >= 4 then
        raise;
      Sleep(1000);
    end;
    objHttp := nil;
  until False;
  //20170405 Igor <<<
  FSOAPResponse := objHttp.ResponseText;
  Log('Request for CRA authorization sent');  //20170330
end;

function TSender.SetRequestDataInput: Boolean;
var
  myDate: TDateTime;
begin
  //20180228 Igor >>>
  try
    FRequestData.Created := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', GetInternetDateTime);
  except on E: EIdException do
    begin
      FServerResponse.ReturnCode := IntToStr(GetLastError);
      FServerResponse.ReturnCodeCaption := 'It seems that there is no internet connection to the web site';
      FServerResponse.ReturnCodeDescr := SysErrorMessage(GetLastError);
      Exit(False);
    end;
    on E: Exception do
    begin
      FServerResponse.ReturnCode := 'Error';
      FServerResponse.ReturnCodeDescr := E.Message;
      Exit(False);
    end;
  end;
  //20180228 Igor <<<
  if (pos('1899', FRequestData.created) > 0) or (FRequestData.created = '') then
  begin
    FServerResponse.ReturnCode := '-1';
    FServerResponse.ReturnCodeDescr := 'Unable to connect. Try again.' + Chr(13) +
      'Or Disable your Firewall. It may be blocking the connection.';
    Exit(False);
  end;

  if FTest then
  begin
    FRequestData.Domain := c_Domain_Test;
    FRequestData.Servise := Format(c_Servise_Test,[FTaxYear]);
    FRequestData.Auth_Param := c_auth_Param;
    FRequestData.Method := c_method_Test;
    if FTaxYear = '2015' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2015_Test
    else
    if FTaxYear = '2016' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2016_Test
    //20171222 Igor>>>
    else
    if FTaxYear = '2017' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2017_Test
    else //20181205
    if FTaxYear = '2018' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2018_Test
    else //20200108 Igor
    if FTaxYear = '2019' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2019_Test;
    //20171222 Igor<<<
    FRequestData.WebApplicationUrl := c_WebApplicationURL_Test;
  end
  else
  begin
    FRequestData.Domain := c_Domain_Prod;
    FRequestData.Servise := Format(c_Servise_Prod,[FTaxYear]);
    FRequestData.Auth_Param := c_auth_Param;
    FRequestData.Method := c_method_Prod;
    if FTaxYear = '2015' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2015_Prod
    else
    if FTaxYear = '2016' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2016_Prod
    //20171222 Igor>>>
    else
    if FTaxYear = '2017' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2017_Prod
    else     //20181205 CON>>>
    if FTaxYear = '2018' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2018_Prod
    else     //20200108 Igor
    if FTaxYear = '2019' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2019_Prod;

    //20171222 Igor<<<
    FRequestData.WebApplicationUrl := c_WebApplicationURL_Prod;
  end;
  if not FForceKey.IsEmpty then
    FRequestData.SecretAccessKey := FForceKey;

  //20200130 Igor >>>
  if FTaxYear = '2019' then
    FRequestData.xmlns := c_xmlns_noa_2019
  else
    FRequestData.xmlns := c_xmlns_noa_2016;
  //20200130 Igor <<<

  //20200131 Igor >>>
  if FTaxYear = '2019' then
    FRequestData.transform_xsl := c_transform_xsl_2019
  else
    FRequestData.transform_xsl := c_transform_xsl;
  //20200131 Igor <<<

  FRequestData.UserName := c_SPID_NOA;
  FRequestData.TaxYear := FTaxYear;
  FRequestData.Nonce := GenerateNonce;
  FRequestData.NonceB64 := EncodeString(FRequestData.Nonce);
  FRequestData.PasswordDigest := GeneratePasswordDigest;
  Result := True;
  Log('Data for CRA authorization prepared');  //20170330
end;

{ TRequestData }

function TRequestData.GetTrunkApplicationUrl: string;
begin
  Result := Copy(WebApplicationUrl, Pos('://', WebApplicationUrl) + 3, MaxInt);
end;

function TRequestData.GetWebServiceUrl: string;
begin
  Result := Domain + Servise;
end;

end.
