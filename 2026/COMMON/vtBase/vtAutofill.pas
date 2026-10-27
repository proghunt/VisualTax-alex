unit vtAutofill;

// {$DEFINE WITH_MUTEX} //20160221 Igor
interface

uses Winapi.Windows, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls,
  Vcl.Menus, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.ImgList, Vcl.StdActns, Vcl.ActnList, Vcl.ToolWin, System.Actions

    , System.SysUtils // inttostr
    , Web.HTTPApp // HttpEncode
    , ShellApi // shellexecute
    , Crypt2 // HMACSHA256Encode, HCkCrypt2
    , MsXml2_TLB // ixmlHttpRequest
    , System.Win.ComObj // CreateOleObject
    , System.DateUtils // IncMinute
    , EncdDecd // encodeString
    , System.StrUtils // PosEx(
    , TXPCrypto, IdCoder, IdCoder3to4, IdCoderMIME // for freelancer
    , Variants //20240206 Igor
    , messages // for WM_CLOSE

    , IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, IdSNTP, Xml.xmldom,
  Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc;

const
  UnixStartDate: TDateTime = 25569.0;
  // Sets UnixStartDate to TDateTime of 01/01/1970

  spID = '064J';

type
  TrequestData = Record
    token: string[100];
    userName: string[50];
    password: string[100];
    passwordDigest: string;
    nonce: string[100];
    nonceB64: string[100];
    created: string[50];
    taxYear: string[4];
  end;

type
  TserverResponse = Record
    result: boolean;
    responseCode: string;
    responseDescr: string;
  end;

type
  //20221222 Igor >>>
  TCallBack = procedure(AToken: String; ARequestData: TrequestData) of Object;
  TOnLog = procedure(AMessage: String) of Object;

  TWaitThread = class(TThread)
  private
    FCallBack: TCallBack;
    FRequestData: TrequestData;
    FOnLog: TOnLog;
    FToken: String;
    FLastMessage: String;
    FNeedCloseWebPage: Boolean; //20170307 Igor
    procedure DoLog;
    procedure DoCallBack;
    function ReturnTokenFromTitle: string;
  public
    constructor Create(ACallBack: TCallBack; AOnLog: TOnLog;
      ARequestData: TrequestData; ANeedCloseWebPage: Boolean); //20170307 Igor
    procedure Execute; override;
  end;
  //20221222 Igor <<<

  TfrmAutofill = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton9: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    Memo1: TMemo;
    XMLDocument1: TXMLDocument;
    Panel1: TPanel;
    GetInternetDateBtn: TButton;
    retrieveDataBtn: TButton;
    test: TButton;
    hashSINtxt: TEdit;
    Button1: TButton;
    txYear: TLabeledEdit;
    tempMemo: TMemo;
    Memo2: TMemo;
    Panel2: TPanel;
    sendSINbtn: TButton;
    ExitBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    chkAutoClose: TCheckBox;
    lblTestOrProduction: TLabel;
    BrowserMode: TRadioGroup; //20180201 Igor
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure retrieveDataBtnClick(Sender: TObject);

    procedure createTokenRequestURL;
    function getInternetTime(): TDateTime;
    function hoursToAdd(tempDate: TDateTime): integer;
    procedure CallBackStop; //20221222 Igor
    Procedure StopTheApplication;

    function SHA256Encode(s: PWideChar): string;
    function HMACSHA256Encode(s: PWideChar; key: PWideChar): string;

    function checkTDDPayloadResultCode(var taxData: ansistring;
      requestData: TrequestData): boolean;

    function createTDDPayloadSoapMessageXml(requestData: TrequestData)
      : ansistring;

    function getResultInfoServerError(taxData: ansistring): TserverResponse;

    function getTDDPayloadResultInfo(return: string;
      xmlData: ansistring): string;

    procedure setRequestDataInput(var rd: TrequestData);
    function generateNonce(): string;
    function generatePasswordDigest(requestData: TrequestData): string;
    function Password_Digest(ANonce, ACreated, APassword: ansistring)
      : ansistring;

    function retrieveTDDPayload(requestData: TrequestData): ansistring;

    function submitTDDPayloadSoapMsg(SoapMsg: ansistring;
      userName, password: string): ansistring;
    function getResultInfo(infoType: string; xmlData: ansistring): string;
    procedure readAllXMLResults(xmlAnsiString: ansistring);
    function traverseAllXML(StartNode: IXMLNode): IXMLNode;
    function TraverseParseConcatXML(StartNode: IXMLNode): IXMLNode;

    procedure FormCreate(Sender: TObject);

    procedure sendSINbtnClick(Sender: TObject);

    function cleanXMLResult(xmlData: ansistring): ansistring;
    function getTokenC(xmlData: ansistring): string;
    function checkSINSsendResult(var taxData: ansistring;
      requestData: TrequestData): TserverResponse;
    procedure linkToCRALogin(tokenC: string; ARequestData: TRequestData);
    function createSendSINSoapMessageXml(requestData: TrequestData): ansistring;
    procedure Button1Click(Sender: TObject);
    procedure testClick(Sender: TObject);

    procedure requestTDDPayload(retrievedToken: string;
      requestData: TrequestData);

    function encodeSINSHA256(sinToEncode: string): string;

    Function ReplaceChar(s, FromChar, ToChar: String): String;
    procedure ExitBtnClick(Sender: TObject);
    procedure GetInternetDateBtnClick(Sender: TObject);
    //20221222 Igor >>>
    procedure CallBack(AToken: String; ARequestData: TrequestData);
    procedure OnLog(ALogMessage: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    //20221222 Igor <<<
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    TokenFromTitle: string;
    ReturnsList: TStringList;
    DataReceived: boolean;
    FWaitThread: TWaitThread; //20221222 Igor
    // 20170303 Igor <<<
    { Private declarations }
    function ExternalBrowser: boolean; //20221222 Igor
  public
    { Public declarations }
  end;

var
  SIN, FirstName, LastName: String; // non needed?
  // it holds the SIN's,firstname,lastname of of the TDD returns submitted by the end user

  // URI, secretAccessKey, WebServiceUrl:String;
  WebApplicationUrl, secretAccessKey, WebServiceUrl: String; // 20151125
  secretAccessKeyTest, secretAccessKeyProduction: string; //20180201 Igor

  TestOrProduction: String;
  AppDir, T1AppDir: String;
  SaveDir: String;
  taxYear: String;
  FileDone: String; //20221222 Igor

function RunAutofill(ATestOrProduction, AAppDir, AAutofillDir, AAppYear, ASelectedSins: string): boolean;

implementation

uses System.RegularExpressions, vtShowMessageHTML, IdException, vtGetToken, vtCommon,  //20210208 Igor
  vtAutofillReminder;  //20221222 Igor

{$R *.dfm}

function RunAutofill(ATestOrProduction, AAppDir, AAutofillDir, AAppYear, ASelectedSins: string): boolean;
var FAutofill: TfrmAutofill;
begin
  TestOrProduction := ATestOrProduction;
  T1AppDir := AAppDir;
  SaveDir := AAutofillDir;
  taxYear := AAppYear;
  FAutofill := TfrmAutofill.Create(Application.MainForm);
  try
    FAutofill.ReturnsList.Text := ASelectedSins;
    FAutofill.txYear.Text := AAppYear;
    FAutofill.ShowModal;
    Result := FAutofill.DataReceived;
  finally
    FAutofill.Free;
  end;
end;

procedure ShowHTMLError(ACode: integer; AMessage, ADescription: string); //20180219 Igor
var L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">');
    L.Add('<!DOCTYPE html PUBLIC "-//IETF//DTD HTML//EN" "">');
    L.Add('<HTML><HEAD><META content="IE=5.0000" http-equiv="X-UA-Compatible">');
    L.Add('<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">');
    L.Add('<META name="GENERATOR" content="MSHTML 11.00.9600.16476">');
    L.Add('<TITLE>Autofill request</TITLE>');
    L.Add('</HEAD>');
    L.Add('<BODY>');
    L.Add('<DIV id="frame"><DIV id="contentheader">');
		L.Add('<H1><FONT size=5><STRONG>Autofill request</STRONG></FONT></H1>');
    L.Add('<H2><FONT color=red size=5><STRONG>'+ AMessage +'</STRONG></FONT></H2>');
    L.Add('<P>Received: '+ DateTimeToStr(Now) +'</P>');
    L.Add('<HR>');

    L.Add('<P></P>');
    if ACode > 0 then  //20180228 Igor >>>
      L.Add('<P><FONT size=3 face="arial, helvetica, sans-serif">Result Code: '+ IntToStr(ACode) +'</FONT></P>');
    L.Add('<P><FONT face="arial, helvetica, sans-serif"><FONT size=3>Error: '+ ADescription + '</FONT></FONT></P>');
    L.Add('</DIV></DIV></BODY></HTML>');
    //20180220 Igor >>>
    ShowMessageHTML(L.Text);
    //20180220 Igor <<<
  finally
    L.Free;
  end;
end;

//20180126 Igor >>>
function ClearXML(AXML: String): string;
begin
  Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;
//20180126 Igor <<<

// 20170303 Igor >>>
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
// 20170303 Igor <<<

procedure log(AText: String);
var
  TF: TextFile;
const
  c_logFile: String = 'log.txt';
begin
  AssignFile(TF, c_logFile);
  if FileExists(c_logFile) then
    Append(TF)
  else
    Rewrite(TF);
  try
    Writeln(TF, DatetimeToStr(Now) + #9 + AText);
  finally
    CloseFile(TF);
  end;
end;

procedure TfrmAutofill.FileNew1Execute(Sender: TObject);
begin
  { Do nothing }
end;

procedure TfrmAutofill.FileOpen1Execute(Sender: TObject);
begin
  OpenDialog.Execute;
end;

procedure TfrmAutofill.FileSave1Execute(Sender: TObject);
begin
  SaveDialog.Execute;
end;

procedure TfrmAutofill.FormClose(Sender: TObject; var Action: TCloseAction); //20200306 Igor
begin
  if Assigned(ReturnsList) then
    ReturnsList.Free;
  //20221222 Igor >>>
  if FileExists(FileDone) then
    DeleteFile(FileDone);
  //20221222 Igor <<<
end;

procedure TfrmAutofill.FormCloseQuery(Sender: TObject; var CanClose: Boolean); //20221222 Igor
begin
  if assigned(FWaitThread) then
  begin
    FWaitThread.Terminate;
    while assigned(FWaitThread) do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;
  end;
  CallBackStop; //20170309 Igor
end;

procedure TfrmAutofill.FormCreate(Sender: TObject);
Var
  // i: integer; //20170212 Igor
  //20180201 Igor >>>
  WebApplicationUrlTest, WebApplicationUrlProduction, {secretAccessKeyTest,
    secretAccessKeyProduction,} WebServiceUrlTest,
  //20180201 Igor <<<
    WebServiceUrlProduction: string;
  // myDate:TDateTime;  //20160107  test
begin
  ReturnsList := TStringList.Create;
  DataReceived := false;
  {
    // Test to see if Firewall blocks the connection
    //20160107
    memo1.Lines.Clear;
    myDate:=GetInternetTime();
    ShowMessage('date');
    EXIT;
  }

  screen.Cursor := crHourGlass; // 20160107

  WebApplicationUrlTest :=
    'apps-ct.cra-arc.gc.ca/ebci/awsc/tdd/certtest/auth/start';
  WebApplicationUrlProduction :=
    'ams-sga.cra-arc.gc.ca/gol-ged/awsc/tdd/auth/start';

  //20210128
  if taxYear = '2020' then    //20210204
  begin
    secretAccessKeyTest := 'O1v2RHSGMxbgD8Ftfew3PL2FDFQgEhi2'; //20190103
    secretAccessKeyProduction := 'jvP1G7BqzM8gUTsJ3dUimLKFO1N155oP'; //20210220
  end
  else if taxYear = '2021' then    //??
  begin
    secretAccessKeyTest := 'ZrSMrYry49j7mgVFYqHWD8nMRw9yTJkG'; //20211224 CON
    secretAccessKeyProduction := 'dhwPMwJ74Csvt1vUZ36p8CK12thnpipu'; //20220218
  end
  else if taxYear = '2022' then  //??
  begin
    secretAccessKeyTest := 'z6KFFuvsk3gsqZgDrlWyXBeTc2c1MqDo'; //20230104
    secretAccessKeyProduction := '5G2h1JrRDCBvg2odfh3PR7C7zIZIrIrP'; //20230218
  end
  else if taxYear = '2023' then
  begin
    secretAccessKeyTest :='MfmsdsPKjOiFcZvUVFCN87WQEhgDyMxW'; //'MfmsdsPKjOiFcZvUVFCN87WQEhgDyMxW';  //20240220
    secretAccessKeyProduction := 'tvW5e9SiFuSPOuo9kVb7dEQLCsjgc1Rv'; //20240220
  end

  else if taxYear = '2024' then   //202501060
  begin
    secretAccessKeyTest       :='9LUzuTDtwjk1UKgo177MXGJhSemP7m4o'; //'MfmsdsPKjOiFcZvUVFCN87WQEhgDyMxW';  //20250218 Igor
    secretAccessKeyProduction := 'XrPsIr4gJLMu6W4U5Ekfcz4hFBzzTKv7'; //jz//20250317 'tvW5e9SiFuSPOuo9kVb7dEQLCsjgc1Rv'; //20240220 /?????

  end

  //20260122CZ
  else if taxYear = '2025' then   //202501060
  begin
    secretAccessKeyTest       := 'tEzJw1gwETyZzgNTw8nxOCi2eBTMexhr';   //20260122CZ
    secretAccessKeyProduction := 'FwrnnhRJ3Vunk2tVHj6z6ZNqUNCxwCWs';   //jz//20260223
  end

  else
  begin
    MessageDlg('Tax Year "'+taxYear+'" not defined. Contact Your vendor.', mtWarning, [mbOk], 0);
    StopTheApplication;
    Exit;
  end;

  WebServiceUrlTest := 'https://apps-ct.cra-arc.gc.ca/ebci/awsc/tdd/ws/' +
    taxYear + '/CertTestDeliveryService'; // 20170212 Igor
  WebServiceUrlProduction := 'https://apps.cra-arc.gc.ca/ebci/awsc/tdd/ws/' +
    taxYear + '/TaxDataDeliveryService'; // 20160208 //20170212 Igor
  // 20170212 Igor <<<
  appDir := GetCurrentDir;

  if UpperCase(TestOrProduction) = 'T' then
  begin
    lblTestOrProduction.Caption := 'Test mode'; //20180201 Igor
    // T1AppDir:='C:\delphi\T1';   //20151223
    Memo1.Visible := True; //20170309 Igor
    WebApplicationUrl := WebApplicationUrlTest; // 20151125
    secretAccessKey := secretAccessKeyTest;
    WebServiceUrl := WebServiceUrlTest;

    // 20151108
    Memo1.Lines.Add('spId                       =' + spID);
    Memo1.Lines.Add('TestOrProduction           =' + TestOrProduction);
    Memo1.Lines.Add('SIN                        =' + SIN);
    // Memo1.Lines.Add('PrgrmAppDir                =' + appDir);   //20151223
    Memo1.Lines.Add('T1AppDir                   =' + T1AppDir);
    Memo1.Lines.Add('SaveDir                    =' + SaveDir); // 20151223
    Memo1.Lines.Add('secretAccessKeyTest        =' + secretAccessKeyTest);
    Memo1.Lines.Add('secretAccessKeyProduction  =' + secretAccessKeyProduction);
    Memo1.Lines.Add('secretAccessKey (chosen)   =' + secretAccessKey);

    Memo1.Lines.Add(' ');

    Memo1.Lines.Add('WebServiceUrlTest                =' + WebServiceUrlTest);
    Memo1.Lines.Add('WebServiceUrlProduction          =' +
      WebServiceUrlProduction);
    Memo1.Lines.Add('WebServiceUrl (chosen)           =' + WebServiceUrl);
  end
  else // production
  begin
    lblTestOrProduction.Caption := 'Production mode'; //20180201 Igor
    Memo1.Visible := False; //20170309 Igor
    WebApplicationUrl := WebApplicationUrlProduction; // 20151125
    secretAccessKey := secretAccessKeyProduction;
    WebServiceUrl := WebServiceUrlProduction;
  end;

  screen.Cursor := crDefault;
  Memo2.Lines.Add('Please Click the ' + Chr(39) + 'Send SIN' + Chr(39) +
    ' button to start and DO NOT interrupt it...'); // 20160120
  // 20170306 CON
  Memo2.Lines.Add('    ');
  Memo2.Lines.Add('NOTE');
  Memo2.Lines.Add ('Several users found it beneficial to first logon to CRA via Represent A Client,');
  Memo2.Lines.Add ('before they click SEND on this window');
  Memo2.Lines.Add ('It helps the connection process, receipt of Auto-fill data and staying on-line longer with CRA');
  FileDone := SaveDir + '\TDD_'+ FormatDateTime('YYYYMMDDHHNNSS', Now) +'.done'; // 20220324 Igor
end;

procedure TfrmAutofill.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TfrmAutofill.HelpAbout1Execute(Sender: TObject);
begin
  //AboutBox.ShowModal;
end;

procedure TfrmAutofill.sendSINbtnClick(Sender: TObject);
var
  // i, J: integer; //20160221 Igor //20170303 igor
  // TokenFromTitle: string; //20170303 Igor

  rString: ansistring;
  sUrl: string;
  objHttp: ixmlHttpRequest;
  userName, password: string;
  SoapSINMsg: ansistring;
  requestData: TrequestData;
  tokenC: string;
begin
  //20180102 Igor >>>
  if UpperCase(TestOrProduction) = 'T' then
  begin
    if secretAccessKeyTest = '' then
    begin
      ShowMessage('Access key for test version '+ taxYear +' is not specified!');
      Exit;
    end;
  end
  else
  begin
    if secretAccessKeyProduction = '' then
    begin
      ShowMessage('Access key for production version '+ taxYear +' is not specified!');
      Exit;
    end;
  end;
  //20180102 Igor <<<

  sendSINbtn.enabled := False;
  log(WebServiceUrl);
  // StateTddEfile
  sUrl := WebServiceUrl; // 'http://www.cra-arc.gc.ca/xmlns/tdd/stageTDDEFile';
  userName := spID; // requestData.userName;
  password := secretAccessKey;

  Memo1.Lines.Add('WebServiceUrl : ' + WebServiceUrl);

  requestData.token := '';
  setRequestDataInput(requestData);
  requestData.passwordDigest := generatePasswordDigest(requestData);

  SoapSINMsg := createSendSINSoapMessageXml(requestData);
  log(SoapSINMsg);

  // define
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  // open it
  objHttp.open('POST', sUrl, False, userName, password);

  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?

  objHttp.setRequestHeader('Content-Type', 'text/xml');

  // transmit it now
  // Screen.Cursor := crHourGlass;//20170303 Igor
  objHttp.send(SoapSINMsg); // SEND SOAP MESSAGE
  Memo1.Lines.Add('objHttp.send(' + SoapSINMsg + ');'); // 20170215 Igor
  sleep(1000);

  rString := objHttp.ResponseText;
  log(rString);
  tempMemo.clear;
  tempMemo.Lines.Add(rString);
  tempMemo.Lines.SaveToFile(appDir + '/sendSINresponse.xml');

  // Memo1.Lines.Add(rString);

  rString := cleanXMLResult(rString); // Memo1.Lines.Add(rString);

  if checkSINSsendResult(rString, requestData).result then
  begin
    //20221222 Igor >>>
    if ExternalBrowser then
      StartRemind(IncMinute(Now, 14));
    //20221222 Igor <<<
    tokenC := getTokenC(rString); // returned by Send SIN
    log('Token: ' + tokenC);
    // ShowMessage('Send SIN accepted');  //20151129
    linkToCRALogin(tokenC, requestData);
    // 20170303 Igor <<<
    //20221222 Igor >>>
    if ExternalBrowser then
    begin
      TokenFromTitle := '';
      FWaitThread := TWaitThread.Create(Self.CallBack, Self.OnLog, requestData, chkAutoClose.Checked);
    end;
    //20221222 Igor <<<
  end
  else
  begin
    // show some error message
    Memo1.Lines.Add('checkSINSsendResult returned false');
    // ShowMessage('Send SIN failed');  //20151129
    StopTheApplication; // 20170303 Igor
  end;
end;

function TfrmAutofill.SHA256Encode(s: PWideChar): string;
var
  crypt: HCkCrypt2;
  success: boolean;
begin
  crypt := CkCrypt2_Create();

  success := CkCrypt2_UnlockComponent(crypt, 'djhzcoCrypt_Y7xcLWVr6XPk');
  // 20151125 This is the DLL we purchased

  if (success <> true) then
  begin
    Memo1.Lines.Add(CkCrypt2__lastErrorText(crypt));
    Exit;
  end;

  CkCrypt2_putEncodingMode(crypt, 'hex');
  CkCrypt2_putHashAlgorithm(crypt, 'sha256');
  result := CkCrypt2__hashStringENC(crypt, s);
end;

procedure TfrmAutofill.StopTheApplication;
begin
  Close;
end;

procedure TfrmAutofill.Button1Click(Sender: TObject); // test button
var
  recoveredSIN: string;
begin
  recoveredSIN := encodeSINSHA256(hashSINtxt.Text);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('recoveredSIN:');
  Memo1.Lines.Add(recoveredSIN);
  Memo1.Lines.Add
    ('15E2B0D3C33891EBB0F1EF609EC419420C20E320CE94C65FBC8C3312448EB225');
  Memo1.Lines.Add('');

end;

function TfrmAutofill.encodeSINSHA256(sinToEncode: string): string;
var
  recoveredSIN: string;
  hashChar: PWideChar;
begin
  hashChar := pchar(sinToEncode);
  recoveredSIN := SHA256Encode(hashChar);
  result := recoveredSIN;
end;

function TfrmAutofill.getResultInfoServerError(taxData: ansistring)
  : TserverResponse;
var
  NodeCode, NodeDescr: IXMLNode;

begin
  if pos('<faultcode', taxData) > 0 then
  begin
    result.result := true;

    XMLDocument1.Xml.clear;
    XMLDocument1.Xml.Add(taxData);

    if not(XMLDocument1.Active) then
      XMLDocument1.Active := true;

    //20200108 Igor >>>
    NodeCode := XMLDocument1.DocumentElement.ChildNodes.FindNode('Body').ChildNodes.FindNode('Fault').
      ChildNodes.FindNode('faultcode');
    NodeDescr := XMLDocument1.DocumentElement.ChildNodes.FindNode('Body').ChildNodes.FindNode('Fault').
      ChildNodes.FindNode('faultstring');
    //20200108 Igor <<<

    if (NodeCode = nil) or (NodeDescr = nil) then
    begin
      result.responseCode := '-1';
      result.responseDescr := 'Nodes not found';
    end
    else
    begin
      result.responseCode := NodeCode.ChildNodes[0].Text;
      result.responseDescr := NodeDescr.ChildNodes[0].Text;
    end
  end
  else
    result.result := False;

end;

function TfrmAutofill.checkTDDPayloadResultCode(var taxData: ansistring;
  requestData: TrequestData): boolean;
var
  i, resultCode: integer;
  resultCaption, resultDescription: string; //20180219 Igor
begin
  result := False;
  resultCode := 0;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('taxdata:');
  Memo1.Lines.Add(taxData);

  i := 0;
  repeat
  begin
    Application.ProcessMessages;
    sleep(4000); // polling, 3 chances, 4 seconds between them as per guide
    Application.ProcessMessages;

    if getResultInfoServerError(taxData).result then
      break;

    resultCode := strtoint(getTDDPayloadResultInfo('returnResultCode',
      taxData));
    //20180219 Igor >>>
    if (resultCode = -1) then // is visualtax error
    begin
      resultCaption := 'Node not found';
      resultDescription := 'Error reading xml result';
      Memo1.Lines.Add('');
      Memo1.Lines.Add('Error reading xml result');
      Memo2.Lines.Add('Error reading xml result');
      Memo1.Lines.Add('');
    end
    else if (resultCode = 0) or (resultCode = 10) then
    begin
      if resultCode = 0 then
      begin
        resultCaption := 'REQUEST_ACCEPTED';
        resultDescription := 'The request for tax data has been accepted. The tax data is being assembled.';
        Memo1.Lines.Add
          ('0: REQUEST_ACCEPTED The request for tax data has been accepted. The tax data is being assembled.');
        Memo2.Lines.Add('CRA is assembing the SIN data');
      end
      else if resultCode = 10 then
      begin
        resultCaption := 'NOT_READY';
        resultDescription := 'The tax data is not ready, waiting and making another call.';
        Memo1.Lines.Add
          ('10: NOT_READY The tax data is not ready, waiting and making another call.');
        Memo2.Lines.Add
          ('10: NOT_READY The tax data is not ready, waiting and making another call.');
      end;

      requestData.token := getTDDPayloadResultInfo('returnToken', taxData);
      // setRequestDataInput(requestData);
      // requestData.passwordDigest := generatePasswordDigest(requestData);
      taxData := ClearXML(retrieveTDDPayload(requestData)); //20180126 Igor
    end
    else if resultCode = 20 then
    begin
      resultCaption := 'FOUND';
      resultDescription := 'The tax data has been found and returned.';
      Memo1.Lines.Add('20: FOUND The tax data has been found and returned.');
      Memo2.Lines.Add('CRA server found the data...');
      result := true;
      DataReceived := true;
      break;
    end
    else if resultCode = 201 then
    begin
      // ShowMessage('201: INVALID_REQUEST The request for tax data is not structured properly.');
      resultCaption := 'INVALID_REQUEST';
      resultDescription := 'The request for tax data is not structured properly.';
      Memo2.Lines.Add
        ('201: INVALID_REQUEST The request for tax data is not structured properly.');
      // StopTheApplication;   //20160122
      break;
    end
    else if resultCode = 202 then
    begin
      // ShowMessage('202: INVALID_SP_ID The SPID provided is invalid. Currently not used.');
      resultCaption := 'INVALID_SP_ID';
      resultDescription := 'The SPID provided is invalid. Currently not used.';
      Memo2.Lines.Add
        ('202: INVALID_SP_ID The SPID provided is invalid. Currently not used.');
      break;
    end
    else if resultCode = 203 then
    begin
      // ShowMessage('203: INVALID_TAX_YEAR The tax year provided is invalid.');
      resultCaption := 'INVALID_TAX_YEAR';
      resultDescription := 'The tax year provided is invalid.';
      Memo2.Lines.Add
        ('203: INVALID_TAX_YEAR The tax year provided is invalid.');
      break;
    end
    else if resultCode = 204 then
    begin
      // ShowMessage('204: INVALID_TOKEN The token provided is invalid. The token is mandatory input.');
      resultCaption := 'INVALID_TOKEN';
      resultDescription := 'The token provided is invalid. The token is mandatory input.';
      Memo2.Lines.Add
        ('204: INVALID_TOKEN The token provided is invalid. The token is mandatory input.');
      break;
    end
    else if resultCode = 501 then
    begin
      // ShowMessage('501: SERVICE_UNAVAILABLE The system is currently unavailable. Please refer to times of operation.');
      resultCaption := 'SERVICE_UNAVAILABLE';
      resultDescription := 'The system is currently unavailable. Please refer to times of operation.';
      Memo2.Lines.Add
        ('501: SERVICE_UNAVAILABLE The system is currently unavailable. Please refer to times of operation.');
      // StopTheApplication;   //20160122
      break;
    end
    else if resultCode = 502 then
    begin
      // ShowMessage('502: SYSTEM_BUSY The system is too busy. Please retry later.');
      resultCaption := 'SYSTEM_BUSY';
      resultDescription := 'The system is too busy. Please retry later.';
      Memo2.Lines.Add
        ('502: SYSTEM_BUSY The system is too busy. Please retry later.');
      // StopTheApplication;   //20160122
      break;
    end
    else if resultCode = 503 then
    begin
      // ShowMessage('503: SYSTEM_ERROR A system error occurred. This could be a temporary condition. A retry may be successful.');
      resultCaption := 'SYSTEM_ERROR';
      resultDescription := 'A system error occurred. This could be a temporary condition. A retry may be successful.';
      Memo2.Lines.Add
        ('503: SYSTEM_ERROR A system error occurred. This could be a temporary condition. A retry may be successful.');
      // StopTheApplication;   //20160122
      break;
    end
  end;
  i := i + 1;
  Memo2.Lines.Add('Trying again...');
  until i = 3;
  // 20160123 if this is polling, 3 chances, 4 seconds between them as per guide
  // 20;     //is this polling? 2.5.3.3 SOAP Request with Username Token Password Digest //Where does 20 come from??  //20151108
  if not Result then
    ShowHTMLError(resultCode, resultCaption, resultDescription);
  //20180219 Igor <<<
end;

function TfrmAutofill.getTDDPayloadResultInfo(return: string;
  xmlData: ansistring): string;
var
  Node: IXMLNode;
begin
  XMLDocument1.Xml.clear;
  XMLDocument1.Xml.Add(ClearXML(xmlData)); //20180126 Igor

  if not(XMLDocument1.Active) then
    XMLDocument1.Active := true;

  // ReturnCode>0</ns1:ReturnCode><ns1:TokenIdentifier
  //20190201 Igor >>>
  try
    if return = 'returnResultCode' then
    begin
      if Assigned(XMLDocument1.DocumentElement.ChildNodes.First) then
        if Assigned(XMLDocument1.DocumentElement.ChildNodes.First.ChildNodes.First) then
          Node := XMLDocument1.DocumentElement.ChildNodes.First.ChildNodes.First.ChildNodes.FindNode('ReturnCode');
      if Node = nil then
      begin
        Node := XMLDocument1.DocumentElement.ChildNodes.FindNode('Body');
        if Node <> nil then
          Node := Node.ChildNodes.First;
        if Node <> nil then
          Node := Node.ChildNodes.FindNode('ReturnCode');
      end;
    end
    else if return = 'returnToken' then
    begin
      if Assigned(XMLDocument1.DocumentElement.ChildNodes.First) then
        if Assigned(XMLDocument1.DocumentElement.ChildNodes.First.ChildNodes.First) then
          Node := XMLDocument1.DocumentElement.ChildNodes.First.ChildNodes.First.ChildNodes.FindNode('TokenIdentifier');
      if Node = nil then
      begin
        Node := XMLDocument1.DocumentElement.ChildNodes.FindNode('Body');
        if Node <> nil then
          Node := Node.ChildNodes.First;
        if Node <> nil then
          Node := Node.ChildNodes.FindNode('TokenIdentifier');
      end;
    end;
  except on E: Exception do
    Memo1.Lines.Add('Exception: ' + E.Message);
  end;
  //20190201 Igor <<<
  //20180126 Igor >>>
  if Assigned(Node) then
    Memo1.Lines.Add(Node.ChildNodes[0].Text);
  //20180126 Igor <<<

  if Node = nil then
  begin
    Memo1.Lines.Add('Node not found.');
    result := '-1';
  end
  else
  begin
    result := Node.ChildNodes[0].Text;
  end;
end;

procedure TfrmAutofill.retrieveDataBtnClick(Sender: TObject);
begin
  createTokenRequestURL;
end;

procedure TfrmAutofill.requestTDDPayload(retrievedToken: string;
  requestData: TrequestData);
var
  // requestData   : TrequestData;
  taxData: ansistring;
  ReceivedFlName: String;
begin

  // requestData.token := retrievedToken;
  // setRequestDataInput(requestData);
  // requestData.passwordDigest := generatePasswordDigest(requestData);

  Memo1.Lines.Add('');
  Memo1.Lines.Add('---');
  Memo1.Lines.Add('Test Case Token: ' + requestData.token);
  Memo1.Lines.Add('---');

  taxData := retrieveTDDPayload(requestData);

  if checkTDDPayloadResultCode(taxData, requestData) then
  begin
    // save raw TDD Payload Result
    tempMemo.clear;
    tempMemo.Lines.Add(taxData);

    // 20151223
    ReceivedFlName := SaveDir + '\' + 'TDDReceived.xml';
    Memo1.Lines.Add('Data saved to: ' + ReceivedFlName);
    // Memo1.Lines.Add('Data saved to: ' + SaveDir+'\'+LeftStr(ReturnsList[0],9)+'-'+ReceivedDate+'.xml');
    tempMemo.Lines.SaveToFile(ReceivedFlName);
    Memo1.Lines.Add('---');
    Memo1.Lines.Add('raw data saved to: ' + ReceivedFlName);

    // tempMemo.Lines.SaveToFile(AppDir + '\RawTddResponse.xml'); // 20150427
    // Memo1.Lines.Add('---'); Memo1.Lines.Add('raw data saved to: ' + AppDir + '\RawTDDPayload.xml'); //WRONG...
    readAllXMLResults(taxData);
  end
  else // 20160123 both if and else are exacty the same.. main program can handle error messages, checkTDDPayloadResultCode probably not even needed
  begin
    // show some error message
    ReceivedFlName := SaveDir + '\' + 'TDDReceived.xml';

    tempMemo.Lines.clear;
    tempMemo.Lines.Add(taxData);
    tempMemo.Lines.SaveToFile(ReceivedFlName);

    Memo1.Lines.Add('Data saved to: ' + ReceivedFlName);
    Memo1.Lines.Add('---');
    Memo1.Lines.Add('raw data saved to: ' + ReceivedFlName);
    readAllXMLResults(taxData);
  end;
end;

// 20151223
procedure TfrmAutofill.readAllXMLResults(xmlAnsiString: ansistring);
var
  StartNode: IXMLNode;

  i: integer;
  OrigSentSIN, encodedSINtoReplace: string;
begin
  if xmlAnsiString > '' then
  begin

    xmlAnsiString := StringReplace(xmlAnsiString, 'ns1:', '',
      [rfReplaceAll, rfIgnoreCase]);
    xmlAnsiString := StringReplace(xmlAnsiString, 'ns2:', '',
      [rfReplaceAll, rfIgnoreCase]);
    xmlAnsiString := StringReplace(xmlAnsiString, 'soapenv:', '',
      [rfReplaceAll, rfIgnoreCase]);

    // decode/replace endoded sin
    for i := 0 to ReturnsList.count - 1 do
    begin
      OrigSentSIN := leftstr(ReturnsList[i], 9);
      encodedSINtoReplace := encodeSINSHA256(OrigSentSIN);
      xmlAnsiString := StringReplace(xmlAnsiString, encodedSINtoReplace,
        OrigSentSIN, [rfReplaceAll, rfIgnoreCase]);
    end;

    XMLDocument1.Xml.clear;
    XMLDocument1.Xml.Add(xmlAnsiString);

    if not(XMLDocument1.Active) then
      XMLDocument1.Active := true;

    tempMemo.clear;
    StartNode := XMLDocument1.DocumentElement.ChildNodes.FindNode('Body'); //20190201 Igor

    TraverseParseConcatXML(StartNode);
    // 20151223
    tempMemo.Lines.SaveToFile(SaveDir + '\' + 'TddReceived.txt');
    Memo1.Lines.Add('SAVED ' + SaveDir + '\' + 'TddReceived.txt'); // 20160123
    // tempMemo.Lines.SaveToFile(appDir + '\testCaseTddXMLParsedResultResponse.txt');
    Memo1.Lines.Add('');
    // Application.Terminate;   //20151223
  end;

end;

function TfrmAutofill.TraverseParseConcatXML(StartNode: IXMLNode): IXMLNode;
var
  i: integer;
  s: string;
begin

  result := nil;

  for i := 0 to StartNode.ChildNodes.count - 1 do
  begin
    //20240206 Igor >>>
    if SameText(StartNode.ChildNodes[i].NodeName, 'Slips') then
      if StartNode.ChildNodes[i].HasAttribute('remark') then
        if SameText(VarToStr(StartNode.ChildNodes[i].Attributes['remark']), 'suppressed') then
          ShowMessage('There are more than 500 T5008 slips and none of the slips will be delivered and manual entry will be required');
    //20240206 Igor <<<

    if StartNode.ChildNodes[i].HasChildNodes then
    begin
      if StartNode.ChildNodes[i].IsTextElement then
      begin
        //20200203 Igor >>>
        //20210208 Igor >>>
        if SameText(StartNode.ChildNodes[i].ParentNode.NodeName, 'TuitionSessionPeriod') then
        begin
          s := StartNode.ChildNodes[i].ParentNode.ParentNode.ParentNode.ParentNode.NodeName + AFRStringDelimiter;
          s := s + StartNode.ChildNodes[i].ParentNode.ParentNode.ParentNode.NodeName + AFRStringDelimiter;
          s := s + StartNode.ChildNodes[i].NodeName + AFRStringDelimiter;
          s := s + '01' + AFRStringDelimiter;
          // s := s + StringOfChar ('_', 75 - Length(s));
          s := s + StartNode.ChildNodes[i].Text;
        end
        else
        begin
          // s := Format('%100s', [s]);

          s := StartNode.ChildNodes[i].ParentNode.ParentNode.NodeName + AFRStringDelimiter;
          s := s + StartNode.ChildNodes[i].ParentNode.NodeName + AFRStringDelimiter;
          s := s + StartNode.ChildNodes[i].NodeName + AFRStringDelimiter;
          s := s + '01' + AFRStringDelimiter;
          // s := s + StringOfChar ('_', 75 - Length(s));
          s := s + StartNode.ChildNodes[i].Text;
        end;
        //20210208 Igor <<<
        //20200203 Igor <<<
        Memo1.Lines.Add(s);
        tempMemo.Lines.Add(s);
      end
      else
      begin
        // Memo1.Lines.Add(StartNode.ChildNodes[i].NodeName);
        // tempMemo.Lines.Add(StartNode.ChildNodes[i].NodeName);
      end;
      result := TraverseParseConcatXML(StartNode.ChildNodes[i]);
      if result <> nil then
        break;
    end;
  end;
end;

procedure TfrmAutofill.testClick(Sender: TObject);
var
  rToken: string;
  rData: TrequestData;

begin
  rToken := '';
  requestTDDPayload(rToken, rData);
end;

function TfrmAutofill.traverseAllXML(StartNode: IXMLNode): IXMLNode;
var
  i: integer;
  s: string;
begin

  result := nil;

  for i := 0 to StartNode.ChildNodes.count - 1 do
  begin
    if StartNode.ChildNodes[i].HasChildNodes then
    begin
      if StartNode.ChildNodes[i].IsTextElement then
      begin
        // s := Format('%100s', [s]);

        s := StartNode.ChildNodes[i].NodeName;
        s := s + StringOfChar('_', 70 - Length(s));
        s := s + '01';
        s := s + StringOfChar('_', 75 - Length(s));
        s := s + StartNode.ChildNodes[i].Text;
        Memo1.Lines.Add(s);
        tempMemo.Lines.Add(s);
      end
      else
      begin
        Memo1.Lines.Add(StartNode.ChildNodes[i].NodeName);
        tempMemo.Lines.Add(StartNode.ChildNodes[i].NodeName);
      end;
      result := traverseAllXML(StartNode.ChildNodes[i]);
      if result <> nil then
        break;
    end;
  end;
end;

function TfrmAutofill.getResultInfo(infoType: string; xmlData: ansistring): string;
var
  Node: IXMLNode;
begin
  XMLDocument1.Xml.clear;
  XMLDocument1.Xml.Add(ClearXml(xmlData)); //20190201 Igor

  if not(XMLDocument1.Active) then
    XMLDocument1.Active := true;

  Node := XMLDocument1.DocumentElement.ChildNodes.First.ChildNodes.FindNode
    ('StageTDDEFileResponse');
  //20190201 Igor >>>
  if Node = nil then
  begin
    Node := XMLDocument1.DocumentElement.ChildNodes.FindNode('Body');
    if Node <> nil then
      Node := Node.ChildNodes.FindNode('StageTDDEFileResponse');
  end;
  //20190201 Igor <<<

  // Memo1.Lines.Add(Node.ChildNodes[0].Text);
  // Memo1.Lines.Add(Node.ChildNodes[1].Text);

  // ShowMessage('XMLDATA shows below. The Infotype is '+InfoType);  //20151108
  // Memo1.Lines.add(xmldata); //20151108 Temporary

  if Node = nil then
  begin
    Memo1.Lines.Add('Node not found.');
    result := '-1';
  end
  else
  begin
    if infoType = 'resultCode' then
    Begin
      // ShowMessage('ready to do statement: result := Node.ChildModes[0]].text');  //20151108 Temporary
      result := Node.ChildNodes[0].Text;
    End
    else if infoType = 'token' then
      result := Node.ChildNodes[1].Text;
  end;

end;

Function TfrmAutofill.retrieveTDDPayload(requestData: TrequestData): ansistring;
var
  SoapMsg: ansistring;
begin
  SoapMsg := '';
  SoapMsg := createTDDPayloadSoapMessageXml(requestData);
  result := submitTDDPayloadSoapMsg(SoapMsg, requestData.userName,
    secretAccessKey);
end;

Function TfrmAutofill.submitTDDPayloadSoapMsg(SoapMsg: ansistring;
  userName, password: string): ansistring;
var
  rString: ansistring;
  sUrl: string;
  objHttp: ixmlHttpRequest;
begin

  // 20151108
  sUrl := WebServiceUrl;

  // define
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  // open it
  objHttp.open('POST', sUrl, False, userName, password);

  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?
  objHttp.setRequestHeader('Content-Type', 'text/xml');

  // transmit it now
  screen.Cursor := crHourGlass;
  // Memo1.Lines.Add('');Memo1.Lines.Add(SoapMsg);  Memo1.Lines.Add('');
  log(SoapMsg);
  objHttp.send(SoapMsg); // SEND SOAP MESSAGE

  sleep(1000); // Why sleep so much??

  screen.Cursor := crDefault;
  rString := objHttp.ResponseText;
  log(rString);
  Memo1.Lines.Add(rString);

  result := rString;

end;

function TfrmAutofill.generateNonce(): string;
var
  randomInt: integer;
  randomstring: ansistring;

  function GetBytes(const AText: ansistring): TBytes;
  begin
    SetLength(result, Length(AText));
    if Length(AText) > 0 then
      Move(AText[1], result[0], Length(AText));
  end;

begin
  randomInt := Random(1000000);
  randomstring := Format('%.*d', [7, randomInt]) +
    FormatDateTime('dddddhh:nn:ss.zzz', Now());
  // TimeToStr(now()); //DateTimeToStr(now());

  result := randomstring;
end;

(* //20170303 Igor
  //20160204 IGOR routine
  function TfrmAutofill.returnTokenFromTitle(): string;
  var
  hWndTemp: hWnd;
  iLenText: integer;
  cTitletemp: array [0 .. 254] of Char;
  sTitleTemp: string;
  partialTitle: string;
  title, token: string;
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


  //closes the window, need to close the tab ONLY
  //      if PostMessage(hWndTemp, WM_CLOSE, 0, 0) then //20160204 Igor
  //        Memo1.Lines.Add('Close windoe request succeeded...') //20160204 Igor
  //      else //20160204 Igor
  //        Memo1.Lines.Add('Close Window Failed!'); //20160204 Igor
  SetForegroundWindow(hWndTemp); //20160204 Igor
  sleep(10); //20160204 Igor
  keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0); //1 //20160204 Igor
  sleep(10); //20160204 Igor
  keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), 0, 0); //2 //20160204 Igor
  sleep(10); //20160204 Igor
  keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), KEYEVENTF_KEYUP, 0); //2 //20160204 Igor
  sleep(10); //20160204 Igor
  keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0); //1 //20160204 Igor
  SetForegroundWindow(Handle); //20160204 Igor

  break;
  end;

  hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
  end;
  // result := hWndTemp;

  // Memo1.Lines.Add(Title);
  token := ExtractBetween(title, '{', '}');
  // Memo1.Lines.Add(token);
  result := token;
  end; *)

(* 20160204  Replaced with Igor's routine
  function TfrmAutofill.returnTokenFromTitle(): string;
  var
  hWndTemp: hWnd;
  iLenText: integer;
  cTitletemp: array [0 .. 254] of Char;
  sTitleTemp: string;
  partialTitle: string;
  title, token: string;
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


  //closes the window, need to close the tab ONLY
  if PostMessage(hWndTemp, WM_CLOSE, 0, 0) then
  Memo1.Lines.Add('Close windoe request succeeded...')
  else
  Memo1.Lines.Add('Close Window Failed!');

  break;
  end;

  hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
  end;
  // result := hWndTemp;

  // Memo1.Lines.Add(Title);
  token := ExtractBetween(title, '{', '}');
  // Memo1.Lines.Add(token);
  result := token;
  end;
*)

procedure TfrmAutofill.ExitBtnClick(Sender: TObject);
begin
  StopTheApplication; // 20160107 //20160221 Igor
end;

function TfrmAutofill.ExternalBrowser: boolean; //20221222 Igor
begin
  Result := BrowserMode.ItemIndex = 1;
end;

(* //20170303 Igor
  function TfrmAutofill.ExtractBetween(const Value, A, B: string): string;
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
  begin
  result := copy(Value, aPos, bPos - aPos);
  end;
  end;
  end;
*)

procedure TfrmAutofill.createTokenRequestURL;
var
  tokenRequestUrl: string;
  baseStr, lang, sinRequestNum,  auth, signedKey: string;
  baseStrToSign { ,secretAccessKey } : PWideChar;
  timestamp: int64;
  myDate: TDateTime;

  URI: string;
begin
  myDate := getInternetTime(); // Now;
  timestamp := Round((myDate - 25569.0) * 86400) + (3600 * hoursToAdd(myDate))
  { (3600*5) add hours to match cra };
  Memo1.Lines.Add('getInternetTime timestamp: ' + inttostr(timestamp));

  auth := '/gol-ged/awsc/tdd/ws';
  sinRequestNum := inttostr(ReturnsList.count);
  lang := 'en';

  // baseStr:=spID+URI+inttostr(TimeStamp)+auth+lang;
  baseStr := spID + WebApplicationUrl + inttostr(timestamp) + auth + lang;
  // 20151125

  // baseStr:=spID+HttpEncode(URI)+inttostr(TimeStamp)+HttpEncode(auth)+lang;
  baseStr := spID + HttpEncode(WebApplicationUrl) + inttostr(timestamp) +
    HttpEncode(auth) + lang; // 20151125

  baseStrToSign := PWideChar(baseStr);

  signedKey := HMACSHA256Encode(baseStrToSign, pchar(secretAccessKey));

  signedKey := HttpEncode(signedKey);

  {
    spID: TESTAPP (see *Additional Information)
    software product secret key: TESTKEY (see *Additional Information)
    timestamp: 137131201
    URI: https://test.cra-arc.gc.ca/gol-ged/awsc/tdd/auth/start
    auth: /gol-ged/awsc/tdd/ws
    t: sf/1yHUQmiQWwp11mVohv55lEBywP4v3
    lang: en

    ${spID + urlencode(${URI) + ${timestamp + urlencode(${auth) + ${l + urlencode(${T)
  }

  URI := 'https://test.cra-arc.gc.ca/gol-ged/awsc/tdd/auth/start';

  tokenRequestUrl := URI + '?spID=' + spID + '&timestamp=' + inttostr(timestamp)
    + '&auth=' + HttpEncode(auth) + '&key=' + signedKey + '&lang=' + lang;
  // 20151125
  // tokenRequestUrl := 'https://' + URI + '?spID=' + spID + '&timestamp=' + inttostr(timestamp) + '&auth=' + HttpEncode(auth) + '&lang=' + lang + '&N=' + sinRequestNum + '&key=' + SignedKey;
  // tokenRequestUrl := 'https://' + WebApplicationUrl + '?spID=' + spID + '&timestamp=' + inttostr(timestamp) + '&auth=' + HttpEncode(auth) + '&lang=' + lang + '&N=' + sinRequestNum + '&key=' + SignedKey; //20151125

  // Memo1.Lines.Add(tokenRequestUrl); //showmessage(tokenRequestUrl);

  ShellExecute(0, 'OPEN', pchar('' + tokenRequestUrl), '', '', SW_SHOWNORMAL);
end;

function TfrmAutofill.hoursToAdd(tempDate: TDateTime): integer;
var
  dateString: string;
begin
  dateString := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', tempDate);
  // 20170215 Igor
  dateString := leftstr(dateString, 10);

  // dateString:= '2016-03-20';//leftstr(dateString, 10);
  // Memo1.Lines.Add('dateString:' + dateString);

  {
    daylight savings dates
    2015	Sunday, March 8, 2:00 AM	Sunday, November 1, 2:00 AM
    2015-03-08                2015-11-01

    2016	Sunday, March 13, 2:00 AM	Sunday, November 6, 2:00 AM
    2016-03-13                2016-11-06

    2017	Sunday, March 12, 2:00 AM	Sunday, November 5, 2:00 AM
    2017-03-12                2017-11-05

    2018	Sunday, March 11, 2:00 AM	Sunday, November 4, 2:00 AM
    2018-03-08                2018-11-01
  }

  result := 5;

  // adjustments for daylight savings time
  if ((dateString > '2015-03-08') and (dateString < '2015-11-01')) or
    ((dateString > '2016-03-13') and (dateString < '2016-11-06')) or
    ((dateString > '2017-03-12') and (dateString < '2017-11-05')) or
    ((dateString > '2018-03-08') and (dateString < '2018-11-01')) then
  begin
    result := 4;
  end;
end;

// 20160127  done by IGOR
function TfrmAutofill.getInternetTime(): TDateTime;
var
  i: integer;
  tempDate: TDateTime;
  s: string;
  bFound: boolean; //20221222 Igor
begin
  bFound := false; //20221222 Igor
  with TIdSNTP.Create(nil) do
  try
    Host := 'ca.pool.ntp.org'; //20220321 Igor
    //Host := 'ntp2.cs.wisc.edu'; // 'time.windows.com';  //20160111
    // IdSNTP.Host := 'time.windows.com';
    // IdSNTP.Host := 'time.nist.gov';
    // 'pool.ntp.org'; //'time.nist.gov'; '64.90.182.55';
    // IdSNTP.Port := 37; //13; 123;
    ReceiveTimeout := 5000;
    // 1250;    //20160109 increased timeout, more consistant
    Memo1.Lines.Add('IdSNTP.Port ' + inttostr(Port));
    Memo1.Lines.Add('IdSNTP.ReceiveTimeout ' + inttostr(ReceiveTimeout));
    Memo1.Lines.Add('IdSNTP.Host ' + Host);

    // seems to work the second/third time more consistantly
    // tempDate := IdSNTP.DateTime;tempDate := IdSNTP.DateTime;tempDate := IdSNTP.DateTime;

    for i := 0 to 10 do
    begin
      tempDate := DateTime;
      //20221222 Igor >>>
      if tempDate < EncodeDate(2020, 01, 01) then
      begin
        Memo1.Lines.Add('getInternetTime() Incorrect date:' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', tempDate));
        continue;
      end;
      //20221222 Igor <<<

      /// Try to set DataTime to UTC -5 20160127 igor
      tempDate := TTimeZone.Local.ToUniversalTime(tempDate);

      // tempDate := tempDate - 1/24 * hoursToAdd(tempDate); //20170215 Igor
      // tempDate := tempDate - 1/24*5;

      s := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', tempDate);
      // 20170215 Igor
      Memo1.Lines.Add('getInternetTime() Date:' + s);
      // sleep(1000); //no sleep needed because of time out
      if pos('1899', s) = 0 then
      begin
        Memo1.Lines.Add('Date found');
        bFound := true;
        break;
      end;
    end;
    if not bFound then
      raise Exception.Create('Current time was not retrieved from '+ Host);
    result := tempDate;
  finally
    Free
  end;
end;

(* 20160127
  function TfrmAutofill.getInternetTime(): TDateTime;
  var
  i: integer;
  tempDate: TDateTime;
  s: string;
  begin
  IdSNTP.Host := 'ntp2.cs.wisc.edu';//'time.windows.com';  //20160111
  //IdSNTP.Host := 'time.windows.com';
  //IdSNTP.Host := 'time.nist.gov';
  // 'pool.ntp.org'; //'time.nist.gov'; '64.90.182.55';
  //IdSNTP.Port := 37; //13; 123;
  IdSNTP.ReceiveTimeout := 5000; //1250;    //20160109 increased timeout, more consistant
  Memo1.Lines.Add('IdSNTP.Port ' + inttostr(IdSNTP.Port));
  Memo1.Lines.Add('IdSNTP.ReceiveTimeout ' + inttostr(IdSNTP.ReceiveTimeout));
  Memo1.Lines.Add('IdSNTP.Host ' + IdSNTP.Host);

  // seems to work the second/third time more consistantly
  // tempDate := IdSNTP.DateTime;tempDate := IdSNTP.DateTime;tempDate := IdSNTP.DateTime;

  for i := 0 to 10 do
  begin
  tempDate := IdSNTP.DateTime;
  s := FormatDateTime('yyyy-mm-dd"T"hh:nn:ssss"Z"', tempDate);
  Memo1.Lines.Add('getInternetTime() Date:' + s);
  //sleep(1000); //no sleep needed because of time out
  if pos('1899', s) = 0 then
  begin Memo1.Lines.Add('Date found'); break; end;
  end;
  result := tempDate;
  end;
*)
function TfrmAutofill.HMACSHA256Encode(s: PWideChar; key: PWideChar): string;
var
  success: boolean;
  crypt: HCkCrypt2;
  mac: PWideChar;
  keyEncoding: PWideChar;
  // key,encodingString: PWideChar;
begin

  crypt := CkCrypt2_Create();

  // Any string argument automatically begins the 30-day trial.
  success := CkCrypt2_UnlockComponent(crypt, 'djhzcoCrypt_Y7xcLWVr6XPk');
  if (success <> true) then
  begin
    Memo1.Lines.Add(CkCrypt2__lastErrorText(crypt));
    Exit;
  end;

  // Set the EncodingMode:
  CkCrypt2_putEncodingMode(crypt, 'base64');
  // CkCrypt2_putEncodingMode(crypt,'hex');

  // Set the hash algorithm: Choices are: md5, sha-1, sha256, sha384, sha512, md2, haval
  CkCrypt2_putHashAlgorithm(crypt, 'sha256');

  keyEncoding := 'ansi';
  CkCrypt2_SetHmacKeyEncoded(crypt, key, keyEncoding);

  mac := CkCrypt2__hmacStringENC(crypt, s);
  // CkCrypt2_Dispose(crypt); //screws up the mac var for some reason?

  result := mac;
end;

function TfrmAutofill.createTDDPayloadSoapMessageXml(requestData: TrequestData)
  : ansistring;
var
  xmlSoapList: TStringList;
  s: ansistring;
  i: integer;
begin

  xmlSoapList := TStringList.Create;

  With xmlSoapList do
  Begin
    Add('<?xml version="1.0" encoding="UTF-8"?>');
    Add('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">');
    Add('  <S:Header>');
    Add('    <wsse:Security S:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
    Add('      <wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">');
    Add('        <wsse:Username>' + requestData.userName + '</wsse:Username>');
    Add('        <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">'
      + requestData.passwordDigest + '</wsse:Password>');
    Add('        <wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">'
      + requestData.nonceB64 + '</wsse:Nonce>');
    Add('        <wsu:Created>' + requestData.created + '</wsu:Created>');
    Add('      </wsse:UsernameToken>');
    Add('    </wsse:Security>');
    Add('  </S:Header>');
    Add('  <S:Body>');

    //20180126 Igor >>>


    if taxYear = '2015' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-0-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2016' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-1-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2017' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-2-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2018' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-3-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20190201 Igor
    else if taxYear = '2019' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-4-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20200108 Igor
    else if taxYear = '2020' then //20210128
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-5-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    //20211227 Igor >>>
    else if taxYear = '2021' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-6-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2022' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-7-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2023' then
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-8-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2024' then  //20250106
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-9-2" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20250218 Igor
    else if taxYear = '2025' then  //20250602 ??? iws it correct?
      Add('    <GetTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-10-1" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20260122 Igor

    //20211227 Igor <<<

    else
      Raise Exception.Create('GetTDDEFile xmlns is not specified for ' + taxYear);
    //20180126 Igor <<<
    Add('      <TokenIdentifier>' + requestData.token + '</TokenIdentifier>');
    Add('      <TaxYear>' + requestData.taxYear + '</TaxYear>');
    Add('    </GetTDDEFile>');
    Add('  </S:Body>');
    Add('</S:Envelope>');
  end;

  s := '';
  For i := 0 to xmlSoapList.count - 1 do
  begin
    s := s + xmlSoapList[i] + Chr(13);
    // Memo1.Lines.Add(s);
  end;

  {
    // 20150427
    If DirectoryExists(T1AppDir + '\' + 'Tdd') = false then
    ForceDirectories(T1AppDir + '\' + 'Tdd');
    xmlSoapList.SaveToFile(T1AppDir + '\' + 'Tdd' + '\' + 'TDDSumbitted.xml');
    // -----
  }
  xmlSoapList.SaveToFile(appDir + '\SoapList.xml');
  xmlSoapList.free;

  result := s;

end;

// used in send sin portion ----------------------------------------------------
// -----------------------------------------------------------------------------
Procedure TfrmAutofill.setRequestDataInput(var rd: TrequestData);
var
  myDate: TDateTime;
begin
  // rd.token     := returnTokenFromTitle(); //'TCAtTY9Y4m7Gz8ZXa6Cw8Zq4nvZnvlDlhV7';
  rd.userName := spID;
  myDate := 0;

  //20180227 Igor >>>
  try
    myDate := getInternetTime(); // Now;
  except
    on E: EIdException do
    begin
//      Application.MessageBox(PChar('It seems that there is no internet connection to the web site' + #13#13 +
//                                    IntToStr(GetLastError) + ': ' + SysErrorMessage(GetLastError)),
//                             'Error', MB_OK or MB_ICONERROR);
      ShowHTMLError(GetLastError, 'It seems that there is no internet connection to the web site', SysErrorMessage(GetLastError));
      StopTheApplication;
    end;
    on E: Exception do
    begin
      Application.MessageBox(PChar(E.Message), 'Error', MB_OK or MB_ICONERROR);
      StopTheApplication;
    end;
  end;
  //20180227 Igor <<<
  // myDate := IncMinute(myDate, (hoursToAdd(myDate) * 60));//20170215 Igor
  rd.created := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', myDate);

  rd.password := secretAccessKey;
  rd.taxYear := txYear.Text;
  rd.nonce := generateNonce();
  rd.nonceB64 := encodeString(rd.nonce);

  // real data -----------------------------------------------------------------

  if (pos('1899', rd.created) > 0) or (rd.created = '') then
  begin
    // 20160107
    showmessage('Unable to connect. Try again.' + Chr(13) +
      'or Disable your Firewall. It may be blocking the connection.');
    // 20151223  //needs better explation for user and terminate or try again/how?
    StopTheApplication; // 20151223 //20170306 Igor
  end;
end;

function TfrmAutofill.generatePasswordDigest(requestData: TrequestData): string;
var
  pDigest: string;
begin
  {
    Memo1.Lines.Add('requestData.nonce:    ' + requestData.nonce);
    Memo1.Lines.Add('requestData.nonceB64: ' + requestData.nonceB64);
    Memo1.Lines.Add('requestData.created:  ' + requestData.created);
    Memo1.Lines.Add('requestData.password: ' + requestData.password);
  }
  pDigest := Password_Digest(requestData.nonce, requestData.created,
    requestData.password);
  pDigest := Trim(pDigest); // has invalid char if do not trim

  // Memo1.Lines.Add('requestData.passwordDigest: ' + pDigest);

  result := pDigest;
end;

procedure TfrmAutofill.GetInternetDateBtnClick(Sender: TObject);
Var
  myDate: TDateTime;
begin
  myDate := getInternetTime(); // 20160107
end;

function TfrmAutofill.Password_Digest(ANonce, ACreated, APassword: ansistring)
  : ansistring;
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

function TfrmAutofill.createSendSINSoapMessageXml(requestData: TrequestData)
  : ansistring;
var
  xmlSoapList: TStringList;
  s: ansistring;
  i: integer;
begin
  xmlSoapList := TStringList.Create;

  With xmlSoapList do
  Begin
    // creates server error
    // Add('creates server error');

    Add('<?xml version="1.0" encoding="UTF-8"?>');
    Add('<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">');
    Add('<S:Header>');
    Add('<wsse:Security S:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
    Add('<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">');
    Add('<wsse:Username>' + requestData.userName + '</wsse:Username>');
    Add('<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">'
      + requestData.passwordDigest + '</wsse:Password>');
    Add('<wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">'
      + requestData.nonceB64 + '</wsse:Nonce>');
    Add('<wsu:Created>' + requestData.created + '</wsu:Created>');
    Add('</wsse:UsernameToken>');
    Add('</wsse:Security>');
    Add('</S:Header>');
    Add('<S:Body>');
    //20180126 Igor >>>
    if taxYear = '2015' then
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-0-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2016' then
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-1-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2017' then
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-2-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">')
    else if taxYear = '2018' then  //20181205 CON
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-3-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20190201 Igor
    else if taxYear = '2019' then  //20200108 CON
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-4-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20120108 Igor
    else if taxYear = '2020' then  //20210129 CON
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-5-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20120108 Igor
    //20211227 Igor >>>
    else if taxYear = '2021' then  //20211224 CON
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-6-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20120108 Igor
    else if taxYear = '2022' then  //20211224 CON
      Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-7-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20120108 Igor
    else if taxYear = '2023' then  //20211224 CON
    Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-8-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20120108 Igor
    else if taxYear = '2024' then  //20250106 jz
     Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-9-2" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20250218 Igor

    else if taxYear = '2025' then  //20260122 Igor
     Add('<StageTDDEFile xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-10-1" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">') //20260122 Igor

	//20211227 Igor <<<
    else
      Raise Exception.Create('StageTDDEFile xmlns is not specified for ' + taxYear);
    //20180126 Igor <<<
    Add('<TaxYear>' + requestData.taxYear + '</TaxYear>');

    for i := 0 to ReturnsList.count - 1 do
    begin
      Add('<Sin>' + leftstr(ReturnsList[i], 9) + '</Sin>');
      // 20151125  SIN is 9 digits NOT 8
    end;

    Add('</StageTDDEFile>');
    Add('</S:Body>');
    Add('</S:Envelope>');
  end;

  s := '';
  For i := 0 to xmlSoapList.count - 1 do
  begin
    s := s + xmlSoapList[i] + Chr(13);
  end;

  // Memo1.Lines.Add(s);

  xmlSoapList.SaveToFile(appDir + '\' + 'sendSINSubmitted.xml');
  // 20151125 Con was mis-spelled sumbitted

  xmlSoapList.free;

  result := s;
end;

function TfrmAutofill.cleanXMLResult(xmlData: ansistring): ansistring;
begin
  xmlData := StringReplace(xmlData, 'ns1:', '', [rfReplaceAll, rfIgnoreCase]);
  xmlData := StringReplace(xmlData, 'ns2:', '', [rfReplaceAll, rfIgnoreCase]);
  xmlData := StringReplace(xmlData, 'soapenv:', '',
    [rfReplaceAll, rfIgnoreCase]);
  result := xmlData;
end;

procedure TfrmAutofill.CallBack(AToken: String; ARequestData: TrequestData); //20221222 Igor
begin
  EndRemind;
  TokenFromTitle := AToken;
  if TokenFromTitle <> '' then // 20160221 Igor
  Begin
    ARequestData.token := TokenFromTitle;
    requestTDDPayload(TokenFromTitle, ARequestData);
  End;
  FWaitThread := nil;
  StopTheApplication;
end;

procedure TfrmAutofill.CallBackStop; //20221222 Igor
{$IFNDEF WITH_MUTEX}
var
  F: TextFile;
{$ENDIF}
begin
{$IFNDEF WITH_MUTEX}
  try
    AssignFile(F, FileDone);
    try
      Rewrite(F);
    finally
      CloseFile(F);
    end;
  except
  end;
{$ENDIF}
end;

function TfrmAutofill.checkSINSsendResult(var taxData: ansistring;
  requestData: TrequestData): TserverResponse;
var
  i, resultCode: integer;
  resultDescription, resultCaption: string; //20180219 Igor
  serverError: TserverResponse; // serverError:boolean;
begin
  result.result := False;
  resultCode := 0;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('taxdata:');
  Memo1.Lines.Add(taxData);

  i := 0;
  //20180201 Igor >>>
  //20180219 Igor >>>
  repeat
  begin
    sleep(1000);
    // as per 2.5.3.3 SOAP Request with Username Token Password Digest //why 1000?  //20151108

    serverError := getResultInfoServerError(taxData);
    if serverError.result then
    begin
      resultCode := -100;
      resultCaption := serverError.responseCode;
      resultDescription := serverError.responseDescr;
      break;
    end;

    resultCode := strtoint(getResultInfo('resultCode', taxData));

    if (resultCode = -1) then // is visualtax error
    begin
      resultCaption := 'Node not found';
      resultDescription := 'Error while reading xml result';
      break;
    end
    else if resultCode = 0 then
    begin
      resultCaption := 'REQUEST_ACCEPTED';
      resultDescription := 'The request for the SIN(s) has been accepted.';
      result.result := true;
      break;
    end
    else if resultCode = 201 then
    begin
      resultCaption := 'INVALID_REQUEST';
      resultDescription := 'The request for tax data is not structured properly.';
      break;
    end
    else if resultCode = 202 then
    begin
      resultCaption := 'INVALID_SP_ID';
      resultDescription := 'The SPID provided is invalid. Currently not used.';
      break;
    end
    else if resultCode = 203 then
    begin
      resultCaption := 'INVALID_TAX_YEAR';
      resultDescription := 'The tax year provided is invalid.';
      break;
    end
    else if resultCode = 204 then
    begin
      resultCaption := 'INVALID_TOKEN';
      resultDescription := 'The token provided is invalid. The token is mandatory input.';
      break;
    end
    else if resultCode = 205 then
    begin
      resultCaption := 'INVALID_SIN';
      resultDescription := 'The SIN(s) provided is invalid. More than 10 SINs. Duplicate SINs. SIN is mandatory input.';
      break;
    end
    else if resultCode = 501 then
    begin
      resultCaption := 'SERVICE_UNAVAILABLE';
      resultDescription := 'The system is currently unavailable. Please refer to times of operation.';
      break;
    end
    else if resultCode = 502 then
    begin
      resultCaption := 'SYSTEM_BUSY';
      resultDescription := 'The system is too busy. Please retry later.';
      break;
    end
    else if resultCode = 503 then
    begin
      resultCaption := 'SYSTEM_ERROR';
      resultDescription := 'A system error occurred. This could be a temporary condition. A retry may be successful.';
      break;
    end
    else
    begin
      resultCaption := 'Unknown error code';
      resultDescription := '';
      break;
    end;
  end;
  i := i + 1
  until i = 3;
  if not Result.result then
  begin
    Memo1.Lines.Add(IntToStr(resultCode) + ': ' + resultCaption + ' ' + resultDescription);
    Memo2.Lines.Add(IntToStr(resultCode) + ': ' + resultCaption + ' ' + resultDescription);
    //ShowMessage(resultDescription);
    ShowHTMLError(resultCode, resultCaption, resultDescription);
  end;
  //20180201 Igor <<<
  //20180219 Igor <<<
end;

function TfrmAutofill.getTokenC(xmlData: ansistring): string;
var
  Node: IXMLNode;
begin
  XMLDocument1.Xml.clear;
  XMLDocument1.Xml.Add(ClearXml(xmlData)); //20190201 Igor

  if not(XMLDocument1.Active) then
    XMLDocument1.Active := true;

  Node := XMLDocument1.DocumentElement.ChildNodes.First.ChildNodes.FindNode
    ('StageTDDEFileResponse');
  //20190201 Igor >>>
  if Node = nil then
  begin
    Node := XMLDocument1.DocumentElement.ChildNodes.FindNode('Body');
    if Node <> nil then
      Node := Node.ChildNodes.FindNode('StageTDDEFileResponse');
  end;
  //20190201 Igor <<<

  // Memo1.Lines.Add(Node.ChildNodes[0].Text);
  // Memo1.Lines.Add(Node.ChildNodes[1].Text);

  if Node = nil then
  begin
    Memo1.Lines.Add('Node not found.');
    result := '-1';
  end
  else
  begin
    result := Node.ChildNodes[1].Text;
  end;
end;

procedure TfrmAutofill.linkToCRALogin(tokenC: string; ARequestData: TRequestData);
var
  tokenRequestUrl: string;
  { s, } baseStr, lang, { sinRequestNum, authEncoded, } auth, signedKey,
    spIDstr, // 20170212 Igor
  timestampStr, authStr, tokenCStr, swtaxyear: string; // 20170215 Igor
  baseStrToSign: PWideChar;
  timestamp { , serverTimeStamp } : int64; // 20170212 Igor
  // baseStrLength: integer; //20170212 Igor
  myDate: TDateTime;

  URI: string;
begin
  myDate := getInternetTime(); // Now;
  timestamp := SecondsBetween(myDate, EncodeDateTime(1970, 01, 01, 0, 0, 0, 0))
    + 1; // 20170215 Igor

  // Memo1.Lines.Add('getInternetTime timestamp: ' + inttostr(timestamp));
  auth := '/gol-ged/awsc/tdd/ws';
  authStr := HttpEncode(auth);
  lang := 'en';
  swtaxyear := taxYear; // 20170215 Igor
  tokenCStr := HttpEncode(tokenC);

  Memo1.Lines.Add('spID: ' + spID);
  Memo1.Lines.Add('HttpEncode(WebApplicationUrl): ' +
    HttpEncode(WebApplicationUrl));
  Memo1.Lines.Add('inttostr(TimeStamp): ' + inttostr(timestamp));
  Memo1.Lines.Add('authStr: ' + authStr);

  Memo1.Lines.Add('');

  Memo1.Lines.Add('');
  Memo1.Lines.Add('tokenC               : ' + tokenC);
  Memo1.Lines.Add('tokenC httpEncode    : ' + HttpEncode(tokenC));
  Memo1.Lines.Add('');
  Memo1.Lines.Add('tokenCStr            : ' + tokenCStr);
  Memo1.Lines.Add('');
  Memo1.Lines.Add('swtaxyear            : ' + taxYear); // 20170215 Igor

  // Here's how to construct the ${baseStr} string:

  // ${spID} + urlencode(${URI}) + ${timestamp} + urlencode(${auth}) + ${l} + urlencode(${T} + ${softwareTaxYear} + urlencode(${state}))

  baseStr := spID + HttpEncode(WebApplicationUrl) + inttostr(timestamp) +
    authStr + lang + tokenCStr + swtaxyear; // 20170215 Igor
  Memo1.Lines.Add('');
  baseStrToSign := PWideChar(baseStr);

  // 20151129
  Memo1.Lines.Add('BaseStr      : ' + baseStr);
  // Memo1.Lines.Add('BaseStrToSign: ' + BaseStrToSign);

  signedKey := HMACSHA256Encode(baseStrToSign, pchar(secretAccessKey));
  signedKey := HttpEncode(signedKey);

  URI := WebApplicationUrl; // 20170215 Igor

  spIDstr := '?spID=' + spID;
  timestampStr := '&timestamp=' + inttostr(timestamp);
  authStr := '&auth=' + HttpEncode(auth);
  signedKey := '&key=' + signedKey;
  tokenCStr := '&t=' + tokenCStr;
  lang := '&lang=' + lang;
  swtaxyear := '&swtaxyear=' + swtaxyear; // 20170215 Igor

  // Token Request URL Format:
  // URI?spID=${spID}&timestamp=${timestamp}&auth=${auth}&key=${signedKey}&t=${T}&lang=${l}&swtaxyear=${softwareTaxYear}&state=${state}

  tokenRequestUrl := 'https://' + URI + spIDstr + timestampStr + authStr +
    signedKey + tokenCStr + lang + swtaxyear; // 20151125//20170215 Igor
  // tokenRequestUrl := URI + spIDstr + timestampStr + authStr +  signedKey + lang + tokenCStr; // 20151125  //20160215

  Memo1.Lines.Add('tokenRequestUrl: ' + tokenRequestUrl);
  Memo1.Lines.Add('');
  log('tokenRequestUrl: ' + tokenRequestUrl);

  //20221222 Igor >>>
  if ExternalBrowser then
    ShellExecute(0, 'OPEN', pchar('' + tokenRequestUrl), '', '', SW_SHOWNORMAL)
  else
  begin
    TokenFromTitle := GetToken(tokenRequestUrl);
    if TokenFromTitle <> '' then // 20160221 Igor
    Begin
      ARequestData.token := TokenFromTitle;
      requestTDDPayload(TokenFromTitle, ARequestData);
      StopTheApplication;
    End
    //20220215 Igor >>>
    Else
      ShowMessage('Token was not retrieved from CRA. Try again later!');
    //20220215 Igor <<<
  end;
  //20221222 Igor <<<
end;

procedure TfrmAutofill.OnLog(ALogMessage: String); //20221222 igor
begin
  Memo1.Lines.Add(ALogMessage);
end;

// good for XE4   //20151223
Function TfrmAutofill.ReplaceChar(s, FromChar, ToChar: String): String;
Var
  i: integer;
begin
  result := '';
  For i := 1 to Length(s) do
    If s[i] = FromChar then
      result := result + ToChar
    else
      result := result + s[i];
end;

{ TWaitThread }

constructor TWaitThread.Create(ACallBack: TCallBack; AOnLog: TOnLog; //20221222 Igor
  ARequestData: TrequestData; ANeedCloseWebPage: Boolean); 
begin
  inherited Create(true);
  FCallBack := ACallBack;
  FOnLog := AOnLog;
  FRequestData := ARequestData;
  FreeOnTerminate := true;
  Suspended := False;
  FNeedCloseWebPage := ANeedCloseWebPage; 
end;

procedure TWaitThread.DoCallBack; //20221222 Igor
begin
  if assigned(FCallBack) then
    FCallBack(FToken, FRequestData);
end;

procedure TWaitThread.DoLog; //20221222 Igor
begin
  if assigned(FOnLog) then
    FOnLog(FLastMessage);
  log(FLastMessage);
end;

procedure TWaitThread.Execute; //20221222 Igor
var
  i: integer;
begin
  inherited;
  FToken := '';
  i := 0;
  while not Terminated and CRAPageExists do
  begin
    Inc(i);
    sleep(400);

{$IFDEF WITH_MUTEX}
    MutexHandle := OpenMutex(MUTEX_ALL_ACCESS, False, VTMutexName);
    if MutexHandle <> 0 then
      CloseHandle(MutexHandle)
    else
      break;
{$ELSE}
    if FileExists(FileDone) then
      break;
{$ENDIF}
    if i > 5 then
    Begin
      FToken := ReturnTokenFromTitle;
      FLastMessage := 'TokenFromTitle :' + FToken;
      Synchronize(DoLog);
      if FToken > '' then
        break;
    end;
  end;
  Synchronize(DoCallBack);
end;

function TWaitThread.ReturnTokenFromTitle: string; //20221222 Igor
var
  hWndTemp: hWnd;
  iLenText: integer;
  cTitletemp: array [0 .. 254] of Char;
  sTitleTemp: string;
  partialTitle: string;
  title, token: string;
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
      // closes the window, need to close the tab ONLY
      // if PostMessage(hWndTemp, WM_CLOSE, 0, 0) then //20160204 Igor
      // Memo1.Lines.Add('Close windoe request succeeded...') //20160204 Igor
      // else //20160204 Igor
      // Memo1.Lines.Add('Close Window Failed!'); //20160204 Igor


      (*  Previous releases of the Tax Data services logout the user after every transaction.
        Future releases of the Tax Data services will not logout the user but will require
        the tax software to interact with the Tax Data web application in order to prevent
        premature logout.  The following are the responsibilities for the software depending
        on client type and token transfer method.

        Client Type: Thick client;
        Token Transfer method:	Windows title;
        Logout:	N/A – logout link on CRA page (remove closing of window) ;
        Extend session:	N/A – Dialog session prompt on CRA page. (remove closing of window);
      *)
      //20170307 Igor >>>
      if FNeedCloseWebPage then
      begin

        SetForegroundWindow(hWndTemp); //20160204 Igor
        sleep(10); //20160204 Igor
        keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0); //1 //20160204 Igor
        sleep(10); //20160204 Igor
        keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), 0, 0); //2 //20160204 Igor
        sleep(10); //20160204 Igor
        keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), KEYEVENTF_KEYUP, 0); //2 //20160204 Igor
        sleep(10); //20160204 Igor
        keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0); //1 //20160204 Igor
        SetForegroundWindow(Handle); //20160204 Igor
      end;
      //20170307 Igor <<<

      break;
    end;

    hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
  end;
  token := ExtractBetween(title, '{', '}');
  result := token;
end;

end.
