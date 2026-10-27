unit T2_2027WACRequestEfile;

// 20260130CZ

{

  menu link

  begin

  Application.CreateForm(TWACRequestEfileT2_2027,TWACRequestEfile);
  TWACRequestEfile.ShowModal;
  TWACRequestEfile.Free;

  end;
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,
  T2_2027TrimStr, T2_2027Declare, T2_2027Common, T2_2027Common2, Db, DBTables,
  Grids, DBGrids,
  ShellApi, ComCtrls, ComObj, TLHelp32, Activex, ShlObj,
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  StrUtils, // 20260129 Igor
  uADCompClient, vtLabel, Vcl.Mask, vteditbox;
// 20110129  NEEDED for connection and the response handler

// 20230727 Con
Const
  SOFTRELEASEYEAR = '2025'; // '2023'; //'2018';

Const
  SOFTRELEASEMONTH = '12'; // '07'; //'12';  //20240321

Const
  SOFTRELEASEDAY = '31'; // '27'; //'19';  //20240321

Const
  CrLf = Chr(13) + Chr(10);
  // Const SoftwareId   = 'VT33'; //20160613
  // Const SoftVendor   = '064K'; //20160606  N/A to T2

type
  TWACResponseResultType = (WACResponseSuccess, WACResponseRejected,
    WACResponseWebServiceError, WACResponseUnknownError);

  TWACResponseAckRec = Record
    Name: String;
    BNnumber: String;
    TxYear: String;
    DateTimeReceived: String;
    TxYearEndDate: String;
    TxYearEndTime: String;
    ResponseCode: String;
    ResponseText: ansiString;
    WACCode: String;
    WACResponseResultType: TWACResponseResultType;
  end;

type
  TWACRequestEfileT2_2027 = class(TForm)
    EfileType: TPanel;
    SubmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ShowXMLBtn: TBitBtn;
    TestOrProductionGroup: TRadioGroup;
    UrlBox: TEdit;
    Label7: TLabel;
    testResponseOpenDialog: TOpenDialog;
    testResponse: TBitBtn;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel4: TvtLabel;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel9: TvtLabel;
    vtLabel10: TvtLabel;
    wacR_BNnumber: TEdit;
    wacR_TaxYearEnd: TEdit;
    wacR_TaxEndTime: TEdit;
    wacR_IncorporationDate: TEdit;
    wacR_Postal: TEdit;
    wacR_RequesterLastName: TEdit;
    wacR_RequesterFirstName: TEdit;
    wacR_RequesterJobTitle: TEdit;
    vtLabel11: TvtLabel;
    vtLabel12: TvtLabel;
    eDateIssued: TEdit;
    ePartITax: TEdit;
    vtLabel13: TvtLabel;
    eTotalFederalTax: TEdit;
    vtLabel14: TvtLabel;
    vtLabel15: TvtLabel;

    procedure setwebServiceUserNamePassword(var webServiceUserName: string;
      var webServicePassword: string);

    Function ReplaceXMLChars(info: String): String; // 20161213
    Function ConvertCheckBoxTo1(S: String): String; // 20160124
    Function CreateSoapMessage(RetNo: Integer): String;
    procedure GetUrlBox;
    Function MkSubmittedFileName(RetNo: Integer): String;
    Function MkResponseFileName(RetNo: Integer): String;
    procedure SubmitBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    Procedure SubmitSoapMsg(SoapMsg: ansiString; FlName: String);

    Function parseResponse(rString: ansiString): TWACResponseAckRec;
    Function CreateEfileResponseHtm(RetNo: Integer): String;
    procedure PostResponseToFrm();
    procedure FormActivate(Sender: TObject);
    procedure ShowXMLBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    // procedure BuildBatchBtnClick(Sender: TObject);
    // Procedure CreateBatch;
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure viewErrorCluesBtnClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure instalMSXMLbtnClick(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
    procedure wacR_IncorporationDateExit(Sender: TObject);
  private
    { Private declarations }
    RetNo: Integer; // 20160120 Igor
  public
    { Public declarations }
  end;

var

  TWACRequestEfile: TWACRequestEfileT2_2027;
  SoapMsg: ansiString;
  OnLineNo, TransmitterNo, PassWord, FileName, Url, OnlineMethod: String;
  webServiceUserName, webServicePassword: String;
  NetFileDir: String;
  FormCnt: Integer;
  WACResponseEfileDir: String;
  sUrl: String;
  Indent1, Indent2, Indent3, Indent4, Indent5, Indent6, Indent7, Indent8,
    Indent9, Indent10, Indent11: Integer;

  // AckRec:TAckRec;
  WACResponseRec: TWACResponseAckRec;

implementation

uses vtDataBase, vtMulti, vtCommon, vtMain, vtTrimStr, T2_2027, T2_2027main,
  vtShared, vtDynData {,childwinnew}; // 20150120 Igor

{$R *.DFM}

procedure TWACRequestEfileT2_2027.FormCreate(Sender: TObject);
Var
  TempList: TStringList;
  T2FNo: Integer;
begin
  WACResponseEfileDir := AppDir + '\' + 'WACResponseEfile';
  If DirectoryExists(WACResponseEfileDir) = false then
    ForceDirectories(WACResponseEfileDir);

  // if TestOrProductionGroup.visible = true then TestOrProductionGroup.itemindex := 1;  //20130212

  RetNo := GetCurrentRetNo;

  If RetNo > 0 then
  begin
    T2FNo := GetFormNo('T2');

    wacR_BNnumber.Text := FetchElmFNo(RetNo, T2FNo, 1); // bnnumber
    wacR_TaxYearEnd.Text := FetchElmFNo(RetNo, T2FNo, 11); // tax year end date
    wacR_TaxEndTime.Text := FetchElmFNo(RetNo, T2FNo, 207); // tax year end time

    wacR_IncorporationDate.Text := FetchElmFNo(RetNo, T2FNo, 299);
    // incorporation date //jz 20240703

    wacR_Postal.Text := FetchElmFNo(RetNo, T2FNo, 35);
    // mailing address postal code
    if wacR_Postal.Text = '' then
      wacR_Postal.Text := FetchElmFNo(RetNo, T2FNo, 20);
    // if no mailing address postal code use head office
    wacR_RequesterLastName.Text := FetchElmFNo(RetNo, T2FNo, 742);
    // requester last name
    wacR_RequesterFirstName.Text := FetchElmFNo(RetNo, T2FNo, 743);
    // requester first name
    wacR_RequesterJobTitle.Text := FetchElmFNo(RetNo, T2FNo, 744);
    // requester job title
  end;
end;

procedure TWACRequestEfileT2_2027.SubmitBtnClick(Sender: TObject);
Var
  RetNo: Integer;
  FlName: String;
begin
  // 20150312
  If ValidPostal(RetNo, OptRec.Prp_Postal) = false then
  begin
    ShowMessage
      ('Please fix the Postal code in Configure -> General Options -> Preparer');
    Exit;
  end;

  RetNo := GetCurrentRetNo;

  FlName := CreateSoapMessage(RetNo);
  // --------------
  If SoapMsg = '' then
  Begin
    ShowMessage('No data available for submission');
    Exit;
  end;
  SubmitSoapMsg(SoapMsg, FlName);
end;

Procedure TWACRequestEfileT2_2027.SubmitSoapMsg(SoapMsg: ansiString;
  FlName: String);
Var
  i: Integer;
  WString: ansiString; // wide string
  objHttp: ixmlHttpRequest;
  Status: String;
  T1135Msg: ansiString;
  TempSoapList: TStringList;
  TempDataList: TStringList;
  h: THandle;
  S: String;
  AList: TStringList;
  DOMDocument: IXMLDOMDocument;
  TrackNodes: IXMLDOMNodeList; // 20110129
  ResponseXmlFile: String;
  ConfirmationNumber: String;
  // T1135ResponseRec:T1135AckRec;
  WACResponseHTM: string;
Begin

  // define
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  // open it
  objHttp.open('POST', sUrl, false, OnLineNo, PassWord); // 20110120

  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?
  objHttp.setRequestHeader('Content-Type', 'text/xml; charset=UTF-8');
  // added encoding //20150206
  // ShowHTTPStatus(ObjHTTP.ReadyState);
  // transmit it now
  Screen.Cursor := crHourGlass;

  objHttp.send(SoapMsg);
  Screen.Cursor := crDefault;
  delay(2000);
  Screen.Cursor := crDefault;
  WString := objHttp.ResponseText;

  ResponseXmlFile := MkResponseFileName(RetNo);
  // Now save the WString
  AList := TStringList.Create;
  AList.Add(WString);
  AList.SaveToFile(ResponseXmlFile);
  AList.Free;

  // h := ShellExecute(MainForm.Handle,'open',Pchar(''+ResponseXmlFile),Nil,Nil,Sw_Show);

  parseResponse(WString);
  PostResponseToFrm();
  WACResponseHTM := CreateEfileResponseHtm(RetNo);

  h := ShellExecute(Self.Handle, nil, PChar('' + WACResponseHTM), nil, nil,
    SW_NORMAL);
  If h <= 32 then
    ShowMessage(ResponseXmlFile + 'not found');

  // succesful transmission
  S := MkSubmittedFileName(RetNo);
  If FileExists(S) then
    RenameFile(S, ReplaceStr(S, 'ToBeSubmitted', 'Submitted')); // rename it

  objHttp := Nil; // .Free is not accepted

end;

procedure TWACRequestEfileT2_2027.FormActivate(Sender: TObject);
begin
  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir); // 20110120
  GetUrlBox;
  If (Length(OnLineNo) <> 5) or (PassWord = '') then
  begin
    SoapMsg := '';
    ShowMessage
      ('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
    MainFormT2.SetupEOLInternetFiling1Click(Sender);
    Exit;
  end;

  SoapMsg := '';

  RetNo := GetCurrentRetNo;
end;

procedure TWACRequestEfileT2_2027.ShowXMLBtnClick(Sender: TObject);
Var
  h: THandle;
  FlName: String;
begin
  FlName := CreateSoapMessage(RetNo);
  h := ShellExecute(Self.Handle, 'open', PChar('' + FlName), Nil, Nil, Sw_Show);
  If h <= 32 then
    ShowMessage('File not found');
end;

procedure TWACRequestEfileT2_2027.DBGrid1DblClick(Sender: TObject);
Var
  i: Integer;
  FlName: String;
  SomeList: TStringList;
begin
end;

procedure TWACRequestEfileT2_2027.BitBtn1Click(Sender: TObject);
begin
  DBGrid1DblClick(Sender);
end;

Function TWACRequestEfileT2_2027.MkSubmittedFileName(RetNo: Integer): String;
// embedded function
  Function GetMinutesAndSeconds: String; // function within function
  Var
    SHours, SMinutes, SSeconds: string[2];
    Hour, Min, Sec, Msec: word;
  begin
    DecodeTime(Now, Hour, Min, Sec, Msec);
    SMinutes := AllTrim(IntToStr(Min));
    SSeconds := AllTrim(IntToStr(Sec));
    If Length(SMinutes) = 1 then
      SMinutes := '0' + SMinutes;
    If Length(SSeconds) = 1 then
      SSeconds := '0' + SSeconds;
    Result := SMinutes + SSeconds;
  end; // end of embedded function

Var
  S: String;
begin
  Result := WACResponseEfileDir + '\' + 'WACResponse-ToBeSubmitted-' +
    LeftStr(RemoveChar(GetCorpName(RetNo), '.'), 30) + '-' +
    GetAccountNumber(RetNo) + '.xml' // 20160526
end;

Function TWACRequestEfileT2_2027.MkResponseFileName(RetNo: Integer): String;
begin
  Result := WACResponseEfileDir + '\' + 'WACResponse-Response-' +
    LeftStr(RemoveChar(GetCorpName(RetNo), '.'), 30) + '-' +
    GetAccountNumber(RetNo) + '.xml'; // 20160526
end;

procedure TWACRequestEfileT2_2027.GetUrlBox;
begin
  // 20150102
  If TestOrProductionGroup.ItemIndex = 0 then // production
    sUrl := 'https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl'
    // sUrl :='https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'
  else // test
    sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
  // sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';

  UrlBox.Text := sUrl;

end;

procedure TWACRequestEfileT2_2027.TestOrProductionGroupClick(Sender: TObject);
begin
  GetUrlBox;
end;

procedure TWACRequestEfileT2_2027.viewErrorCluesBtnClick(Sender: TObject);
begin
  // MainForm.T1135EfileErrors1Click(Sender);
end;

procedure TWACRequestEfileT2_2027.wacR_IncorporationDateExit(Sender: TObject);
var
  val: string;
begin
  val := wacR_IncorporationDate.Text;
  AutoFormatDate(val);
  wacR_IncorporationDate.Text := val;

  // if not(wacR_IncorporationDate.Text = '10') then
  if Length(wacR_IncorporationDate.Text) <> 10 then // 20200109 CON
    ShowMessage('Incorporation Date field must be proper date format');

end;

procedure TWACRequestEfileT2_2027.BitBtn4Click(Sender: TObject);
Var
  h: THandle;
  Pgm: String;
begin
  Pgm := AppDir + '\' + 'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle, 'open', PChar('' + Pgm), Nil, Nil, Sw_Show);
  If h <= 32 then
    ShowMessage('Installation interrupted or program not found');
end;

procedure TWACRequestEfileT2_2027.instalMSXMLbtnClick(Sender: TObject);
Var
  Url: String;
  h: THandle;
begin
  Url := 'http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Self.Handle, 'open', PChar('' + Url), Nil, Nil, Sw_Show);
  If h <= 32 then
    ShowMessage('Connection failed');
  Screen.Cursor := crDefault;
end;

Function TWACRequestEfileT2_2027.parseResponse(rString: ansiString)
  : TWACResponseAckRec;

  function LTrimAnsi(Const S: ansiString): ansiString;
  var // len: integer;
    i: Integer;
  begin
    i := 1;
    while S[i] = ' ' do
      inc(i);
    Result := copy(S, i, Length(S) - i + 1);
  end;

  function RTrimAnsi(S: ansiString): ansiString;
  var
    len: Integer;
  begin
    while S[Length(S)] = ' ' do
      dec(S[1 { 0 } ]);
    Result := S;
  end;

  function AllTrimAnsi(Str: ansiString): ansiString;
  begin
    Result := Str;
    Exit; // not working??????????
    Result := LTrimAnsi(RTrimAnsi(Str));
  end { Trim };

  function xmlTagExists(sTag: string; Text: ansiString): boolean;
  var
    eTag: string;
    sPos, ePos: Integer;
  begin
    Result := false;
    if pos(sTag, Text) > 0 then
      Result := true;
  end;

  function xmlTagValue(sTag: string; Text: ansiString): string; overload;
  var
    eTag: string;
    sPos, ePos: Integer;
  begin
    sPos := pos(sTag, Text) + Length(sTag);

    eTag := sTag;
    insert('/', eTag, 2);
    ePos := pos(eTag, Text);
    Result := AllTrimAnsi(MidAnsiStr(Text, sPos, ePos - sPos));
  end;

  function xmlTagValue(sTag, eTag: string; Text: ansiString): string; overload;
  var
    sPos, ePos: Integer;
  begin
    sPos := pos(sTag, Text) + Length(sTag);
    ePos := pos(eTag, Text);
    Result := AllTrimAnsi(MidAnsiStr(Text, sPos, ePos - sPos));
  end;

var
  i, k, sPos, ePos, FNo: Integer;
  S, e, fCode, fString, messageString, idstring, TimeReceived,
    tempString: String;
  ReturnedTransmissionID, ReturnedEfilerNumber, ReturnedControlNumber: String;

  ReturnedCorpName, ReturnedBnNumber, ReturnedTaxYr: string;

  today: TDateTime;
begin

  With WACResponseRec do
  begin

    Name := GetCorpName(RetNo);
    BNnumber := xmlTagValue('<tgif:BusinessNumber>', rString);

    if BNnumber = '' then
      BNnumber := GetCorpBusNo(RetNo);

    TxYear := IntToStr(GetTaxationYearEndYYYY(RetNo));
    TxYearEndDate := xmlTagValue('<tgif:TaxationYearEndDate>', rString);
    TxYearEndTime := xmlTagValue('<tgif:TaxationYearEndTime>', rString);

    DateTimeReceived := xmlTagValue('<tgif:TimestampDateTime>', rString);
    // leftstr(xmlTagValue('<tgif:TimestampDateTime>',rString),10);
    if DateTimeReceived = '' then
    begin
      today := Now;
      DateTimeReceived := '(local) ' + DateToStr(today) + ' ' +
        TimeToStr(today);
    end;
    ResponseCode := '';
    ResponseText := '';

    // Proper Response -------------------------------------------------------------
    if xmlTagExists
      ('<tgif:WebAccessCodeResponse xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif/response/1-0-0">',
      rString) then
    begin
      // Successful Response -------------------------------------------------------------
      if xmlTagExists('<tgif:WebAccessCodeResponseMessage>', rString) then
      begin
        WACResponseResultType := WACResponseSuccess;
        WACCode := xmlTagValue('<tgif:WACode>', rString);
      end
      // Error Response ------------------------------------------------------------------
      else if xmlTagExists('<tgif:WebAccessCodeErrorMessage>', rString) then
      begin
        WACResponseResultType := WACResponseRejected;
        ResponseCode := xmlTagValue('<tgif:ErrorCode>', rString);
        ResponseText := xmlTagValue('<tgif:EnglishMessageText xml:lang="en">',
          '</tgif:EnglishMessageText>', rString);
      end;
    end

    // SOAP Fault Error ----------------------------------------------------------------
    else if xmlTagExists('<faultcode>', rString) then
    begin
      WACResponseResultType := WACResponseWebServiceError;
      ResponseCode := xmlTagValue('<faultcode>', rString);
      ResponseText := xmlTagValue('<faultstring>', rString);
    end

    // something not accounted for
    else
    begin
      WACResponseResultType := WACResponseUnknownError;
      ResponseCode := 'vtError';
      ResponseText := 'Unknown response file format';
    end;

  end;

end;

procedure TWACRequestEfileT2_2027.testResponseClick(Sender: TObject);
var
  tempResponseList: TStringList;
  AckResponseFlName, WACResponseHTM, ResponseXmlFile: string;
  // T1135ResponseRec:T1135AckRec;
begin
  testResponseOpenDialog.FileName := '*Response*';
  // OpenDialog1.FileName := '';

  testResponseOpenDialog.InitialDir := WACResponseEfileDir;
  testResponseOpenDialog.Filter := 'XML files (*.xml)|*.xml|' + 'Any (*.*)|*.*';
  If testResponseOpenDialog.Execute then
  begin
    tempResponseList := TStringList.Create;
    tempResponseList.loadFromFile(testResponseOpenDialog.FileName);

    parseResponse(tempResponseList.Text);
    // T1135ResponseRec := parseResponse(tempResponseList.text);

    PostResponseToFrm();

    WACResponseHTM := CreateEfileResponseHtm(RetNo);
    If FileExists(WACResponseHTM) then
      ShellExecute(Self.Handle, nil, PChar('' + WACResponseHTM), nil, nil,
        SW_NORMAL);

  end;
end;

procedure TWACRequestEfileT2_2027.PostResponseToFrm();
var
  FNo: Integer;
begin
  With WACResponseRec do
  begin
    if WACResponseResultType = WACResponseSuccess then
    begin

      // FNo := GetFormNo('WACreq');
      // Ret[RetNo].Frm[FNo].Strings[10] := WACCode;

      FNo := GetFormNo('T2');
      Ret[RetNo].Frm[FNo].Strings[75] := WACCode;
    end
    else
    begin
      // Ret[RetNo].Frm[FNo].Strings[9]  := DateTimeReceived;
      // Ret[RetNo].Frm[FNo].Strings[--] := ResponseCode;
      // Ret[RetNo].Frm[FNo].Strings[--] := ResponseText;
    end;
  end;
end;

// 20160124
Function TWACRequestEfileT2_2027.ConvertCheckBoxTo1(S: String): String;
// 20160124
Begin
  Result := '0'; // 20160624
  If UpperCase(S) = 'X' then
    Result := '1';
end;

Function TWACRequestEfileT2_2027.CreateSoapMessage(RetNo: Integer): String;
Const
  Format1 = '########0'; // 20150221
Var
  i, Elm, WacFNo: Integer;
  cd: String; // code
  S, FlName: String;
  DcnSeqNo: String;
begin

  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir);
  setwebServiceUserNamePassword(webServiceUserName, webServicePassword);

  XmlList := TStringList.Create;
  XmlList.Clear;

  With XmlList do
  Begin

    Add('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif">');
    {
      add('  <soapenv:Header>');
      add('        <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
      add('            <wsse:UsernameToken>');
      add('                <wsse:Username>'+ '' +'</wsse:Username>'); //supposed to leave blank?? //Mandatory   add('                <wsse:Username>'+ webServiceUserName +'</wsse:Username>'); //Mandatory
      add('                <wsse:Password>'+ '' +'</wsse:Password>'); //supposed to leave blank?? //Mandatory   add('                <wsse:Password>'+ webServicePassword +'</wsse:Password>'); //Mandatory
      add('            </wsse:UsernameToken>');
      add('        </wsse:Security>');
      add('   </soapenv:Header>');
    }
    Add('   <soapenv:Body>');
    // add('      <tgif:getOnlineWac xmlns:tgift="http://www.cra-arc.gc.ca/xmlns/tgif/request/1-0-0">'); //was used before changes of 2026-01-29
    Add('      <tgif:getOnlineWac>'); // 20260129 Igor
    Add('	      <tgif:WacRequest>');
    Add('	        <tgif:BusinessNumber>' + wacR_BNnumber.Text +
      '</tgif:BusinessNumber>'); // Mandatory

    // Mandatory
    S := wacR_TaxYearEnd.Text;
    Add('	        <tgif:TaxationYearEndDate>' + ReplaceChar(S, '/', '-') +
      '</tgif:TaxationYearEndDate>');

    S := wacR_TaxEndTime.Text;
    if S > '' then
      Add('	        <tgif:TaxationYearEndTime>' + ReplaceChar(S, '/', '-') +
        '</tgif:TaxationYearEndTime>');

    S := wacR_IncorporationDate.Text;
    Add('          <tgif:IncorporationDate>' + ReplaceChar(S, '/', '-') +
      '</tgif:IncorporationDate>');

    Add('	        <tgif:PostalZipCode>' + wacR_Postal.Text +
      '</tgif:PostalZipCode>');
    Add('	        <tgif:RequesterName>');
    Add('		        <tgif:LastName>' + ReplaceXMLChars
      (wacR_RequesterLastName.Text) + '</tgif:LastName>');
    Add('		        <tgif:FirstName>' + ReplaceXMLChars
      (wacR_RequesterFirstName.Text) + '</tgif:FirstName>');
    Add('		        <tgif:Title>' + ReplaceXMLChars(wacR_RequesterJobTitle.Text)
      + '</tgif:Title>');
    Add('	        </tgif:RequesterName>');

    // 20260129 Igor >>>
    // Mandatory
    S := eDateIssued.Text;
    Add('	        <tgif:DateIssued>' + ReplaceChar(S, '/', '-') +
      '</tgif:DateIssued>');

    // 20260202
    // if (ePartITax.Text <> '') or (eTotalFederalTax.Text <> '') then
    Add('	        <tgif:NoticeofAssessment>');
    if (ePartITax.Text <> '') then
      Add('		        <tgif:PartITax>' + FormatFloat('######0.00',
        vl(ePartITax.Text)) + '</tgif:PartITax>')
    Else
      Add('		        <tgif:PartITax>' + '0.00' + '</tgif:PartITax>');

    if (eTotalFederalTax.Text > '') then
      Add('		        <tgif:TotalFederalTax>' + FormatFloat('######0.00',
        vl(eTotalFederalTax.Text)) + '</tgif:TotalFederalTax>');

   // Else Add('		        <tgif:TotalFederalTax>' + '0.00' + '</tgif:TotalFederalTax>');

    Add('	        </tgif:NoticeofAssessment>');

    (*
      //20260202
      if (ePartITax.Text <> '') or (eTotalFederalTax.Text <> '') then
      begin
      add('	        <tgif:NoticeofAssessment>');
      if (ePartITax.Text <> '') then
      add('		        <tgif:PartITax>' + ePartITax.Text + '</tgif:PartITax>');
      if (eTotalFederalTax.Text <> '') then
      add('		        <tgif:TotalFederalTax>' + eTotalFederalTax.Text + '</tgif:TotalFederalTax>');
      //     add('		        <tgif:NetBalance>' + 0.00 + '</tgif:NetBalance>');
      add('	        </tgif:NoticeofAssessment>');
      end;
      //20260129 Igor <<<
    *)
    Add('        </tgif:WacRequest>');
    Add('      </tgif:getOnlineWac>');
    Add('   </soapenv:Body>');

    Add('</soapenv:Envelope>');

  End;

  // when testing, load from file xmlList.Clear; xmllist.LoadFromFile('C:\Users\Costas\Documents\SCHEMA\schema\T2\examplT1135_ORIGINALtoCHANGE.xml');

  // Now save the list to a file
  SoapMsg := '';
  For i := 0 to XmlList.count - 1 do
    SoapMsg := SoapMsg + XmlList[i]; // +Chr(13);

  FlName := MkSubmittedFileName(RetNo);
  If FileExists(FlName) then
    DeleteFile(FlName);
  XmlList.SaveToFile(FlName);
  XmlList.Free;

  Result := FlName;
end;

Function TWACRequestEfileT2_2027.CreateEfileResponseHtm
  (RetNo: Integer { ; AckRec: T1135AckRec; HtmFile: String } ): String;
// 20160523 Igor
var
  htmlSource: TStringList;
  source, FlName: string;
  OnLineNo, PassWord, Url, NetFileDir: String;
  S, keyWord, replacementString, fontColor: string;
  i, j, k, startPos, itemNumTemp: Integer;
begin
  Result := '';
  // GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  htmlSource := TStringList.Create;

  htmlSource.Add('<html><head><title>WAC Response - ' + WACResponseRec.Name +
    ', ' + WACResponseRec.BNnumber + '</title></head>');

  if WACResponseRec.WACResponseResultType = WACResponseSuccess then
  // if WACResponseRec.PreValresultType = PreValSuccess then
  begin
    fontColor := 'green';
    S := 'Successful';
  end
  else
  begin
    fontColor := 'red';
    S := 'Failed';
  end;

  htmlSource.Add('<h3>' + WACResponseRec.TxYear + '</h3>');

  htmlSource.Add('<h4>');
  htmlSource.Add(WACResponseRec.Name);
  htmlSource.Add('<br>');
  htmlSource.Add(WACResponseRec.BNnumber);
  htmlSource.Add('<br>');
  htmlSource.Add('Taxation Year End: ' + WACResponseRec.TxYearEndDate);
  if WACResponseRec.TxYearEndTime > '' then
    htmlSource.Add(' - ' + WACResponseRec.TxYearEndTime);
  htmlSource.Add('</h4>');

  htmlSource.Add('<h2><font color="' + fontColor + '"><strong>WAC request ' + S
    + '</strong></font></h1>');

  if WACResponseRec.WACResponseResultType = WACResponseSuccess then
  // if WACResponseRec.PreValresultType <> PreValSuccess then
  begin
    htmlSource.Add('<h4><strong>WAC Code: ' + WACResponseRec.WACCode +
      '</strong></h4>');
  end
  else
  begin
    // htmlSource.add('<br>');
    htmlSource.Add('<h4>Error Code: ' + WACResponseRec.ResponseCode + '<br>');
    htmlSource.Add('   Error Message: ' + WACResponseRec.ResponseText +
      '</h4>');
  end;

  htmlSource.Add('<h4>Acknowledgement received: ' +
    WACResponseRec.DateTimeReceived + '</h4><br><hr>');

  htmlSource.Add('</body></html>');


  // ----------------------------------------------------------------

  FlName := WACResponseEfileDir + '\' + trim(GetCorpName(RetNo)) +
    '-WACResponseEFileAck.htm';
  htmlSource.SaveToFile(FlName);
  htmlSource.Free;

  Result := FlName; // jz

end;

Function TWACRequestEfileT2_2027.ReplaceXMLChars(info: String): String;
Begin
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;'); // 20160515 it is char(39)
  info := ReplaceChar(info, Chr(39), '&apos;'); // 20161213
  Result := info;
End;

// 20180423
procedure TWACRequestEfileT2_2027.setwebServiceUserNamePassword
  (var webServiceUserName: string; var webServicePassword: string);
var
  wacNumber: String;
begin
  // 20130527
  wacNumber := GetWACNumber(RetNo);
  if wacNumber > '' then
  begin
    webServiceUserName := wacNumber;
    webServicePassword := '';
  end
  else
  begin
    GetEOLParms(OnLineNo, PassWord, Url, NetFileDir);
    webServiceUserName := OnLineNo;
    webServicePassword := PassWord;
  end;

end;

end.
