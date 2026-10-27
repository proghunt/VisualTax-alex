unit T2_2027EfileCBC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IOUtils; // 20180731 Igor

type
  TEfileCBCT2_2027 = class(TForm)
    Panel1: TPanel;
    ProductionOrTestGroup: TRadioGroup;
    URLForWebServices: TEdit;
    CBCEfileBtn: TBitBtn;
    MemoLog: TMemo;
    MemoFile: TMemo;
    BitBtn1: TBitBtn;
    // 20180618 Igor >>>
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    edSubmittedFile: TEdit;
    Label1: TLabel;
    Panel5: TPanel;
    Label2: TLabel;
    edReceivedFile: TEdit;
    // 20180625 Igor >>>
    Panel6: TPanel;
    Label3: TLabel;
    edReceivedHTMLFile: TEdit;
    btnViewHTML: TSpeedButton;
    // 20180625 Igor <<<
    // 20180618 Igor <<<
    procedure ProductionOrTestGroupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBCEfileBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnViewHTMLClick(Sender: TObject); // 20180625 Igor
  private
    { Private declarations }
    OnlineNo: string;
    Password: string;
    Url: string;
    NetFileDir: string;
    RetNo: integer;
    FCBCRDir: string; // 20180618 Igor

    function CreateBody(ABaseIndent: integer): string;
    procedure SubmitSoapMessage(SoapMessage: string);
    function ReplacePredefinedXMLEntities(info: string): string;
    function PrepareValue(Value: string; MaxLength: integer = 0): string;
    procedure WebServiceEfile;
    // 20180618 Igor >>>
    function GetSubmittedFileName: string;
    function GetReceivedFileName: string;
    function GetReceivedHTMLFileName: string; // 20180625 Igor
    procedure SaveToFile(AText, AFileName: string);
    // 20180618 Igor <<<
  public
    { Public declarations }
  end;

  function GetT2EfileReturnRequest(ATaxYear: string): string; // 20180703 Igor
  function ParseXmlResponse(Response, ATitle, AFileName: string; var AConfirmNumber: string): boolean; // 20180625 Igor // 20180824 Igor

implementation

uses T2_2027TrimStr, vtCommon, MSXML2_TLB, ComObj, System.RegularExpressions,
  Xml.XMLDoc, Xml.XMLIntf, StrUtils, vtTrimStr, vtShowMessageHTML, T2_2027, vtMulti, // 20180618 Igor
  T2_2027Declare; // 20180625 Igor // 20180709 Igor

(*
uses T2_2027TrimStr, vtCommon, MSXML2_TLB, ComObj, System.RegularExpressions,
  Xml.XMLDoc, Xml.XMLIntf, StrUtils, vtTrimStr, vtShowMessageHTML, T2_2027, vtMulti, // 20180618 Igor
  T2_2027Declare, HTTPUtil; // 20180625 Igor
*)
{$R *.dfm}

function ClearXML(AXML: String): string; // 20180618 Igor
begin
  Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;

function GetT2NetfileReturnRequest(ATaxYear: string): string; // 20180703 Igor
var
  RetNo:Integer;
begin
  RetNo := GetCurrentRetNo;
  Result :=
    '<?xml version="1.0" encoding="UTF-8"?>'+ #13#10 +
    '<soapenv:Envelope '+ #13#10 +
    '  xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"> '+ #13#10 +
    '    <soapenv:Body> '+ #13#10 +
{
    '        <t2nrq:T2NetfileReturnRequest '+ #13#10 +
    '            xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0" '+ #13#10 +
    '            xmlns:comm="http://www.cra-arc.gc.ca/xmlns/comm/2019/1-0-0" '+ #13#10 +
    '            xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2019/1-0-0" '+ #13#10 +
    '            xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0" '+ #13#10 +
    '	           xmlns:iso="urn:oecd:ties:isocbctypes:v1" '+ #13#10 +
    //'            xmlns:cbc="http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-1-0" '+ #13#10 + //jz 20240705 thought it was this 1-1-0,  but thats wrong? left the same
    '            xmlns:cbc="http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0" '+ #13#10 +
    '            xmlns:t2nrq="http://www.cra-arc.gc.ca/xmlns/t2nrq/t2frrmsrequest/1-0-0" '+ #13#10 +
    '            xmlns:xml="http://www.w3.org/XML/1998/namespace" '+ #13#10 +
    '            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '+ #13#10 +
    '            xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t2nrq/t2frrmsrequest/1-0-0 t2frrmsrequest.xsd "> '+ #13#10 +
}
    //jz 20240711 from Web_sevices_guides_Finals_EAS --> t2nfrws_May24e.pdf
    '        <t2nrq:T2NetfileReturnRequest                                                        '+ #13#10 +
    '            xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"                           '+ #13#10 +
    '            xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"                             '+ #13#10 +
    '            xmlns:iso="urn:oecd:ties:isocbctypes:v1"                                         '+ #13#10 +
    '            xmlns:cbc="http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0"                        '+ #13#10 +
    '            xmlns:t2nrq="http://www.cra-arc.gc.ca/xmlns/t2nrq/t2frrmsrequest/1-0-0"          '+ #13#10 +
    '            xmlns:xml="http://www.w3.org/XML/1998/namespace"                                 '+ #13#10 +
    '            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"                            '+ #13#10 +
    '            xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t2nrq/t2frrmsrequest/1-0-0 t2frrmsrequest.xsd ">'+ #13#10 +

    '            <t2nrq:BusinessNumber>'+ ReplaceStr(FetchElm(RetNo, 'CBCR', 6), ' ', '') +'</t2nrq:BusinessNumber> '+ #13#10 +
    '    		     <t2nrq:WACNumber>'+ GetWacNumber(RetNo) +'</t2nrq:WACNumber> '+ #13#10 +
    '    	 	     <t2nrq:AgreementIndicator>0</t2nrq:AgreementIndicator>  '+ #13#10 + // still needs to be implemented
    '            <t2nrq:TaxYear>'+ ATaxYear +'</t2nrq:TaxYear> '+ #13#10 +
    '            <t2nrq:SoftwareID>'+ RSIApprovalCode +'</t2nrq:SoftwareID> '+ #13#10 +
    '            <t2nrq:TaxForm> '+ #13#10 +
    '                %BODY% '+ #13#10 +
    '            </t2nrq:TaxForm> '+ #13#10 +
    '        </t2nrq:T2NetfileReturnRequest> '+ #13#10 +
    '    </soapenv:Body> '+ #13#10 +
    '</soapenv:Envelope>';
end;

function GetT2EfileReturnRequest(ATaxYear: string): string; // 20180703 Igor
var
  OnlineNo, Password, Url, NetFileDir,s: string;
  RetNo:Integer;  //20180627 con
begin
  RetNo := GetCurrentRetNo;  ////20180627 con
  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  Result :=
    '<?xml version="1.0" encoding="UTF-8"?>'+ #13#10 +
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:t2rq="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0"> '+ #13#10 + //20180704
    '    <soapenv:Body> '+ #13#10 +

    //jz 20240624 from t2efrws_May24e.pdf
    '        <t2rq:T2EfileReturnRequest'                                              + ' ' + #13#10 +
    '         xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'                 + ' ' + #13#10 +
    '         xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2024/1-0-0"'                + ' ' + #13#10 +
    '         xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'                   + ' ' + #13#10 +
    '         xmlns:cbc="http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0"'              + ' ' + #13#10 + //jz 20240705  thought it was 1-1-0 but 1-0-0 works
    '         xmlns:t2rq="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0"'  + ' ' + #13#10 +
    '         xmlns:xml="http://www.w3.org/XML/1998/namespace"'                       + ' ' + #13#10 +
    '         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                  + ' ' + #13#10 +
    '         xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0 t2efilefrrmsrequest.xsd ">'+ ' ' + #13#10 +

    '            <ef:TransmitterEfilerNumber>'+ OnlineNo +'</ef:TransmitterEfilerNumber> '  + #13#10 +
    '            <ef:PasswordID>'+ Password +'</ef:PasswordID> '                            + #13#10 ;

    //jz 20240723
    s := OptRec.Prp_RepId;
    If s>'' then
    begin
      Result := Result +
        '            <ef:RepresentativeID>'+ s +'</ef:RepresentativeID> '                   + #13#10 ;
    end;

  Result := Result +
    '            <t2rq:TaxYear>'+ ATaxYear +'</t2rq:TaxYear> '                              + #13#10 +
    '            <t2rq:SoftwareID>'+ RSIApprovalCode +'</t2rq:SoftwareID> '                 + #13#10 + // 20180625 Igor
    '            <t2rq:TaxForm> '                                                           + #13#10 +
    '                %BODY% '+
    '            </t2rq:TaxForm> '                                                          + #13#10 +
    '        </t2rq:T2EfileReturnRequest> '                                                 + #13#10 +
    '    </soapenv:Body> '                                                                  + #13#10 +
    '</soapenv:Envelope>';
end;

function ParseXmlResponse(Response, ATitle, AFileName: string; var AConfirmNumber: string): boolean; // 20180625 Igor // 20180824 Igor
var X: XML.XMLDoc.TXMLDocument;
    Node, CodeNode: IXMLNode;
    ACode, ACaption, AMessage, ALines: string;
    I: integer;
    RetNo : integer;
  // 20180618 Igor >>>
  {
  function ClearXML(AXML: String): string;
  begin
    Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
    Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
  end;
  }
  // 20180618 Igor <<<

  procedure ShowHTML(ACaption, ACode, ALines: string; AError: boolean); // 20180625 Igor
  var L: TStringList;
      A: TArray<string>;
      I: integer;
      cColor: string;
  begin
    // 20180626 Igor >>>
    ACaption := HTMLEscape(ACaption);
    ALines := HTMLEscape(ALines);
    // 20180626 Igor <<<
    if AError then
      cColor := 'red'
    else
      cColor := 'green';
    L := TStringList.Create;
    try
	  // 20180626 Igor >>>
      L.Add('<HTML><HEAD>');
      L.Add('<META CHARSET="UTF-8">'); 
      L.Add('<TITLE>T2 EFile Service</TITLE>');
      L.Add('</HEAD>');
      L.Add('<BODY>');
      L.Add('<DIV id="contentheader">');
      L.Add('<H1><FONT size=5><STRONG>'+ ATitle+'</STRONG></FONT></H1>');
      L.Add('<H2><FONT color='+ cColor +' size=5><STRONG>'+ ACaption +'</STRONG></FONT></H2>');
      L.Add('<P>Received: '+ DateTimeToStr(Now) +'</P>');
      L.Add('<HR>');

      L.Add('<P></P>');
      L.Add('<P><FONT size=3 face="arial, helvetica, sans-serif"><strong>Result Code:</strong> '+ ACode +'</FONT></P>');
      A := ALines.Split([#13], ExcludeEmpty);
      for i := 0 to Length(A) - 1 do
      begin
        L.Add('<P><FONT size=3 face="arial, helvetica, sans-serif">'+
          '<strong>' +
          Copy(A[i], 1, Pos(':', A[i])) +
          '</strong>'+
          Copy(A[i], Pos(':', A[i]) + 1, Length(A[i])) +
          '</FONT></P>');
      end;
      L.Add('</DIV></BODY></HTML>');
      // 20180626 Igor <<<
      L.SaveToFile(AFileName, TEncoding.UTF8);
      ShowMessageHTML(L.Text, 600);
    finally
      L.Free;
    end;
  end;

  function GetNodeValue(ANode: IXMLNode; ANodeName: string; ACaption: string = ''): string; // 20180625 Igor
  var TNode: IXMLNode;
  begin
    Result := '';
    TNode := ANode.ChildNodes.FindNode(ANodeName);
    if Assigned(TNode) then
    begin
      if not SameText(ACaption, '') then
        Result := ACaption + ': ';
      Result := Result + TNode.NodeValue;
    end;
  end;

  function GetNodeMessage(ANode: IXMLNode): string; // 20180625 Igor
  var TNode: IXMLNode;
      TNodeInner: IXMLNode;
      AMessage: string;
      i,j: integer;
  begin
    Result := '';
    TNode := Node.ChildNodes.FindNode('EnglishMessage');
    AMessage := '';
    for i := 0 to  TNode.ChildNodes.Count - 1 do
    begin
      if AMessage <> '' then
        AMessage := AMessage + '    '; //#13; //'<br>';

      //20210604 jz
      //showmessage(TNode.ChildNodes.Nodes[I].NodeName);
      if TNode.ChildNodes.Nodes[i].NodeName = 'Hyperlink' then
      begin
        TNodeInner := TNode.ChildNodes.Nodes[i];
        for j := 0 to  TNodeInner.ChildNodes.Count - 1 do
        begin
          if AMessage <> '' then
            AMessage := AMessage + ' '; //#13; //'<br>';

          //showmessage(TNode.ChildNodes.Nodes[I].NodeName);
          AMessage := AMessage + TNodeInner.ChildNodes.Nodes[j].NodeValue;
        end;
        break;
      end;

      AMessage := AMessage + TNode.ChildNodes.Nodes[I].NodeValue;

    end;
    if not SameText(AMessage, '') then
      Result := Result + 'English message: '+ AMessage + #13;

    {
    TNode := Node.ChildNodes.FindNode('FrenchMessage');
    AMessage := '';
    for I := 0 to  TNode.ChildNodes.Count - 1 do
    begin
      if AMessage <> '' then
        AMessage := AMessage + '<br>';
      AMessage := AMessage + TNode.ChildNodes.Nodes[I].NodeValue;
    end;
    if not SameText(AMessage, '') then
      Result := Result + 'French message: '+ AMessage + #13;
    }

  end; //GetNodeMessage --------------------------------------------------------

begin
  Result := false;
  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      X.XML.Add(ClearXML(Response));
      if not(X.Active) then
        X.Active := true;
      Node := X.DocumentElement;
      if (Node = nil) or (Node.NodeName <> 'Envelope') then
        raise Exception.Create('Bad Response XML structure: ' + Response);
      Node := Node.ChildNodes.FindNode('Body');
      if (Node = nil) then
        raise Exception.Create('Bad Response XML structure: ' + Response);
      Node := Node.ChildNodes.First;
      if (Node = nil) then
        raise Exception.Create('Bad Response XML structure: ' + Response);
      if SameText(Node.NodeName, 'Fault') then
      begin
        ACaption := 'Unsuccessful Response';
        ACode := Node.ChildNodes.FindNode('faultcode').NodeValue;
        AMessage := 'Message: ' + Node.ChildNodes.FindNode('faultstring').NodeValue;
        ShowHtml(ACaption, ACode, AMessage, true); // 20180625 Igor
        Exit;
      end;
      if SameText(Node.NodeName, 'T2EfileReturnResponse') or SameText(Node.NodeName, 'T2NetfileReturnResponse') then
      begin
        // 20180625 Igor >>>
        AConfirmNumber := GetNodeValue(Node, 'T2TransmissionNumber'); // 20180824 Igor
        ACode := GetNodeValue(Node, 'T2ResultCode');
        ALines := ALines + GetNodeValue(Node, 'T2TransmissionNumber', 'T2 Transmission Number') + #13;
        ALines := ALines + GetNodeValue(Node, 'CorporationName', 'Corporation Name') + #13;
        ALines := ALines + GetNodeValue(Node, 'BusinessNumber', 'Business Number') + #13;
        ALines := ALines + GetNodeValue(Node, 'TaxYear', 'Tax Year') + #13;
        Node := Node.ChildNodes.FindNode('FileReturnResponse');
        if Assigned(Node) then
          Node := Node.ChildNodes.First;
        if Assigned(Node) then
        begin
          if SameText(Node.NodeName, 'Confirmation') then
          begin
            ACaption := Node.NodeName;
            ALines := ALines + GetNodeMessage(Node);
            ShowHTML(ACaption, ACode, ALines, false);
            Result := true;
            Exit;
          end
          else if SameText(Node.NodeName, 'Rejection') or
                  SameText(Node.NodeName, 'SystemError') then
          begin
            ACaption := Node.NodeName;

            //20180720 add info not included in cra response
            RetNo := GetCurrentRetNo;
            //ALines := ALines + 'T2 Transmission Number: ' + '???' + #13;
            ALines := ALines + 'Corporation Name: ' +  GetCorpName(RetNo) + #13;
            ALines := ALines + 'Business Number: ' + GetCorpBusNo(RetNo) + #13;
            ALines := ALines + 'Tax Year: ' + GetTaxationYearEnd(RetNo) + #13;

            ALines := ALines + GetNodeMessage(Node);
            ShowHTML(ACaption, ACode, ALines, true);
          end;
          // 20180625 Igor <<<
        end
        else
          ShowMessage('Invalid Response Message');
      end;
    except on E: Exception do
      begin
        ShowMessage('Error occured while processing CRA SOAP response: '+ #13 + E.Message + #13#13 + 'Response: '+ Response);
      end;
    end;
  finally
    X.Free;
  end;
end;

//20180628
function TEfileCBCT2_2027.ReplacePredefinedXMLEntities(info: string): string; // 20180625 Igor
begin
  info := Trim(info);
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
 // info := HTMLEscape(info);
  info := ReplaceChar(info, '''', '&apos;');
  info := ReplaceChar(info, '’', '&apos;'); //20230109 Igor
  Result := info;
end;

(*
function TEfileCBCT2_2027.ReplacePredefinedXMLEntities(info: string): string; // 20180625 Igor
begin
  info := Trim(info);
  {nfo := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');}
  info := HTMLEscape(info);
  info := ReplaceChar(info, '''', '&apos;');
  Result := info;
end;
*)
procedure TEfileCBCT2_2027.SaveToFile(AText, AFileName: string); // 20180618 Igor
var L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := AText;
    L.SaveToFile(AFileName, TEncoding.UTF8); // 20180625 Igor
  finally
    L.Free;
  end;
end;

procedure TEfileCBCT2_2027.SubmitSoapMessage(SoapMessage: string);
var
  objHttp: IXMLHTTPRequest;
  Response: String;
  ResponseXmlFile: String;
  AList: TStringList;
  ConfirmNumber: string; // 20180824 Igor
begin
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
  //objHttp.open('POST', URLForWebServices.Text, False, OnlineNo, Password);
  objHttp.open('POST', URLForWebServices.Text, False, '', '');
  objHttp.setRequestHeader('SOAPAction', 'NA');
  objHttp.setRequestHeader('Content-Type', 'text/xml;charset=UTF-8');
  // 20180618 Igor >>>
  SaveToFile(SoapMessage, GetSubmittedFileName);
  edSubmittedFile.Text := GetSubmittedFileName;
  // 20180618 Igor <<<
  Screen.Cursor := crHourGlass;
  try
    objHttp.send(SoapMessage);
    Screen.Cursor := crDefault;
    delay(2000);
    Screen.Cursor := crDefault;
    Response := objHttp.ResponseText;    
    // 20180618 Igor >>>
    SaveToFile(Response, GetReceivedFileName);
    edReceivedFile.Text := GetReceivedFileName;
    // 20180618 Igor <<<
    // 20180824 Igor >>>
    if ParseXmlResponse(Response, 'Country-by-Country Report XML submission', GetReceivedHTMLFileName, ConfirmNumber) then // 20180625 Igor
    begin
      // implement some logic for successful result
      StoreElm(RetNo, GetFormNo('CBCR'), 569, ConfirmNumber);
      Ret[RetNo].Changed := True; //201800824 CON
      OpenForm(RetNo,'CBCR',0); //20180824 CON
      Close; //20180824 CON
    end;
    // 20180824 Igor <<<

    // 20180625 Igor >>>
    if FileExists(GetReceivedHTMLFileName) then
      edReceivedHTMLFile.Text := GetReceivedHTMLFileName;
    // 20180625 Igor <<<

    MemoLog.Clear;
    MemoLog.Text := ReplaceStr(Response, '><', '>' + #13#10 + '<');

  finally
    Screen.Cursor := crDefault;
  end;
end;

function TEfileCBCT2_2027.PrepareValue(Value: string;
  MaxLength: integer = 0): string;
begin
  Value := ReplacePredefinedXMLEntities(Trim(Value));
  if MaxLength > 0 then
    Value := Copy(Value, 1, MaxLength);
  Result := Value;
end;

procedure TEfileCBCT2_2027.BitBtn1Click(Sender: TObject); //20180518 Igor
var SoapMessage: string;
begin
  SoapMessage := MemoFile.Text;
  SubmitSoapMessage(SoapMessage);
end;

function TEfileCBCT2_2027.CreateBody(ABaseIndent: integer): string;
const OPTIONAL = true;
var FList: TStringList;
    FName, cValue, cTax, cTIN, cDefaultLang: string; //20230109 Igor
    I, J, A, nTable1Elm, nTable2Elm: integer;
    bAvailable, bEmpty: boolean;
    nElm1, nElm2, nElm3, nElm4: integer; // 20180618 Igor //20230109 Igor

    procedure AddBeginTag(AIndent: integer; AName: string);
    begin
      FList.Add(Space(AIndent) + '<'+ AName +'>');
    end;

    procedure AddEndTag(AIndent: integer; AName: string; AOptional: boolean = false);
    begin
      if AOptional and SameText(Trim(FList.Strings[FList.Count - 1]), '<'+ AName +'>') then
        FList.Delete(FList.Count - 1)
      else
        FList.Add(Space(AIndent) + '</'+ AName +'>');
    end;


    procedure AddTag(AIndent: integer; AName, AValue: string; AOptional: boolean = false);
    begin
      if SameText(Trim(AValue), '') and AOptional then Exit;
      AValue := ReplacePredefinedXMLEntities(AValue);

      if SameText(Trim(AValue), '') then
        FList.Add(Space(AIndent) + '<'+ AName +'/>')
      else
        FList.Add(Space(AIndent) + '<'+ AName +'>' + AValue + '</'+ AName +'>');
    end;

    procedure AddEMPTYTag(AIndent: integer; AName, AValue: string; AOptional: boolean = false);
    begin
      FList.Add(Space(AIndent) + '<'+ AName +'>' +'</'+ AName +'>');
      //FList.Add(Space(AIndent) + '<'+ AName +'/>');
      {
      if SameText(Trim(AValue), '') and AOptional then Exit;
      AValue := ReplacePredefinedXMLEntities(AValue);

      if SameText(Trim(AValue), '') then
        FList.Add(Space(AIndent) + '<'+ AName +'/>')
      else
        FList.Add(Space(AIndent) + '<'+ AName +'>' + AValue + '</'+ AName +'>');
     }
    end;


    function GetValue(AElm: integer; ADefaultValue: string = ''): string; //20230109 Igor
    begin
      Result := FetchElm(RetNo, FName, AElm);
      if Trim(Result).IsEmpty then
        Result := ADefaultValue;
    end;

    function GetYesNoValue(AElm1, AElm2: integer): string;
    begin
      if not SameText(FetchElm(RetNo, FName, AElm1), '') then
        Result := '1'
      else if not SameText(FetchElm(RetNo, FName, AElm2), '') then
        Result := '0'
      else
        Result := '';
    end;

    function BoxChecked(AElm: integer): boolean;
    begin
      Result := not SameText(FetchElm(RetNo, FName, AElm), '');
    end;

    function GetPhoneNumber(AElm1, AElm2: integer): string;
    begin
      Result := '('+GetValue(AElm1)+')' + GetValue(AElm2);  //20180628
    end;

    function ExtractNumbers(AValue: string): string;
    var I: integer;
    begin
      Result := '';
      for I := 1 to Length(AValue) do
        if CharInSet(AValue[I], ['0'..'9']) then
          Result := Result + AValue[I];
    end;

    function GetDateValue(AElm: integer): string;
    var cValue: string;
    begin
      cValue := ExtractNumbers(GetValue(AElm));
      Result := Copy(cValue, 1, 4) + '-' + Copy(cValue, 5, 2) + '-' + Copy(cValue, 7, 2);
    end;

    procedure AddBoxAmount(AIndent: integer; AName: string; AElm: integer);
    var cValue: string;
    begin
      FList.Add(Space(AIndent) + '<'+ AName +'>');
      cValue := Trim(GetValue(AElm));
      cValue := StringReplace(cValue, ',', '',[rfReplaceAll, rfIgnoreCase]); //jz 20240718

      if SameText(cValue, '') then
        cValue := '0'
      // 20180618 Igor >>>
      else
        cValue := IntToStr(Trunc(StrToFloatDef(cValue, 0)));

      // 20180618 Igor <<<
      AddTag(AIndent + 2, 'cbc:Amount', cValue);
      FList.Add(Space(AIndent) + '</'+ AName +'>');
    end;

begin
  FName := 'CBCR';

  FList := TStringList.Create;
  try
    FList.Text :=
      //from Ch6-CbC-24e_May24.pdf

      '<cbc:CountryByCountryReport '                                + #13#10 +
      ' xmlns:cbc="http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0" ' + #13#10 + //jz 20240705  thought it was 1-1-0 but 1-0-0 works
      ' xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0" '    + #13#10 +
      ' xmlns:iso="urn:oecd:ties:isocbctypes:v1" '                  + #13#10 +
      ' xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0" '      + #13#10 +
      ' xmlns:xml="http://www.w3.org/XML/1998/namespace" '          + #13#10 +
      ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '     + #13#10 +
      ' xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0 CountryByCountryReport2019.xsd ">';






    AddTag(4, 'cbc:FunctionalCurrencyCode', GetValue(1), OPTIONAL);
    AddTag(4, 'cbc:AmendedReportIndicator', GetYesNoValue(604, 605));
    AddBeginTag(4, 'cbc:ReportingPeriod');
    AddTag(8, 'cbc:ReportingFiscalYearStartDate', GetDateValue(571));
    AddTag(8, 'cbc:ReportingFiscalYearEndDate', GetDateValue(602));
    AddEndTag(4, 'cbc:ReportingPeriod');

    // TrustEntity and PartnershipEntity are Not applicable for initial CbC release.
    bAvailable := false;
    AddBeginTag(4, 'cbc:ReportingEntityIdentification');
    if BoxChecked(4) or not bAvailable then
    begin
      AddBeginTag(6, 'cbc:CorporationEntity');
      AddTag(8, 'cbc:CorporationName', GetValue(5));
      AddTag(8, 'cbc:BusinessNumber', ReplaceStr(GetValue(6), ' ', '')); // 20180618 Igor
      AddEndTag(6, 'cbc:CorporationEntity');
    end
    else if BoxChecked(7) and bAvailable then
    begin
      AddBeginTag(6, 'cbc:TrustEntity');
      AddTag(8, 'cbc:TrustName', GetValue(8));
      AddTag(8, 'cbc:TrustNumber', GetValue(12));
      AddEndTag(6, 'cbc:TrustEntity');
    end
    else if BoxChecked(9) and bAvailable then
    begin
      AddBeginTag(6, 'cbc:PartnershipEntity');
      AddTag(8, 'cbc:PartnershipName', GetValue(14));
      AddTag(8, 'cbc:PartnershipNumber', GetValue(15));
      AddEndTag(6, 'cbc:PartnershipEntity');
    end;
    AddEndTag(4, 'cbc:ReportingEntityIdentification');

    AddTag(4, 'cbc:MultinationalEnterpriseGroupName', GetValue(10));

    AddBeginTag(4, 'cbc:ReportingEntityAddress');
    AddTag(6, 'cbc:StreetNumber', GetValue(11), OPTIONAL);
    AddTag(6, 'cbc:StreetName', GetValue(13), OPTIONAL);
    AddTag(6, 'cbc:CityName', GetValue(16));
    AddTag(6, 'cbc:GlobalProvinceTerritoryStateCode', GetValue(17), OPTIONAL);
    AddTag(6, 'cbc:CountryCode', GetValue(18));
    AddTag(6, 'cbc:GlobalPostalZipCode', ReplaceStr(GetValue(19), ' ', ''), OPTIONAL); // 20180618 Igor
    AddEndTag(4, 'cbc:ReportingEntityAddress');

    // role of the reporting entity
    AddBeginTag(4, 'cbc:RoleOfTheReportingEntity');
    if BoxChecked(20) then
      cValue := 'CBC701'
    else if BoxChecked(21) then
      cValue := 'CBC702'
    else if BoxChecked(22) then
      cValue := 'CBC703';
    AddTag(6, 'cbc:EntityReportingRoleCode', cValue);
    if SameText(cValue, 'CBC703') then
      AddTag(6, 'cbc:ConstituentEntityFilesForAllIndicator', GetYesNoValue(23, 24));
    if SameText(cValue, 'CBC703') or SameText(cValue, 'CBC702') then
    begin
      AddTag(6, 'cbc:MultinationalEnterpriseUltimateParentEntityName', GetValue(25));
      AddTag(6, 'cbc:MultinationalEnterpriseUltimateParentEntityResidencyCountryCode', GetValue(26));
    end;
    AddEndTag(4, 'cbc:RoleOfTheReportingEntity');

    // certification
    AddBeginTag(4, 'cbc:Certification');
    AddTag(6, 'cbc:CertifierName', GetValue(27));
    AddTag(6, 'cbc:CertifierPositionTitle', GetValue(29));
    AddTag(6, 'cbc:CertifierTelephoneNumber', GetPhoneNumber(30, 31));
    AddTag(6, 'cbc:CertificationDate', GetDateValue(32), OPTIONAL);
    AddEndTag(4, 'cbc:Certification');


    if GetValue(28) >'' then  //contact name
    Begin
     AddBeginTag(4, 'cbc:Contact');
     AddTag(6, 'cbc:ContactName', GetValue(28), OPTIONAL);
     AddTag(6, 'cbc:ContactAddressText', Trim(GetValue(33) + ' ' + GetValue(34) + ' ' + GetValue(35)), OPTIONAL);
     If GetValue(36)+GetValue(37)>'' then //20180628
       AddTag(6, 'cbc:ContactTelephoneNumber', '('+GetValue(36)+')' + GetValue(37)+'X'+GetValue(568), OPTIONAL); // 20180618 Igor  //20180627 CON
     AddEndTag(4, 'cbc:Contact', OPTIONAL);
    end;

    // CbC report
    nTable1Elm := 38;
    for I := 1 to 48 do
    begin
      bEmpty := true;
      // check if this line is not empty
      for J := 0 to 10 do
        if not SameText(GetValue(nTable1Elm + J), '') then
        begin
          bEmpty := false;
          break;
        end;
      if not bEmpty then
      begin
        AddBeginTag(4, 'cbc:CbcReport');
        cTax := GetValue(nTable1Elm);
        // 20180618 Igor >>>
        if SameText(cTax, '') then
        begin
          AddEndTag(4, 'cbc:CbcReport', OPTIONAL);
          continue;
        end;
        // 20180618 Igor <<<
        // fill table 1 line
        AddTag(6, 'cbc:TaxJurisdictionCode', cTax);
        AddBeginTag(6, 'cbc:IncomeTaxBusinessAllocationByTaxJurisdiction');
        AddBoxAmount(8, 'cbc:UnrelatedPartyRevenue', nTable1Elm + 1);
        AddBoxAmount(8, 'cbc:RelatedPartyRevenue', nTable1Elm + 2);
        AddBoxAmount(8, 'cbc:TotalRevenue', nTable1Elm + 3);
        AddBoxAmount(8, 'cbc:ProfitOrLoss', nTable1Elm + 4);
        AddBoxAmount(8, 'cbc:TaxPaid', nTable1Elm + 5);
        AddBoxAmount(8, 'cbc:TaxAccrued', nTable1Elm + 6);
        AddBoxAmount(8, 'cbc:Capital', nTable1Elm + 7);
        AddBoxAmount(8, 'cbc:Earning', nTable1Elm + 8);
        AddBoxAmount(8, 'cbc:EmployeeCount', nTable1Elm + 9);
        AddBoxAmount(8, 'cbc:Asset', nTable1Elm + 10);
        AddEndTag(6, 'cbc:IncomeTaxBusinessAllocationByTaxJurisdiction');

        // scan table 2 for same tax and append all founded lines to current section
        nTable2Elm := 616;
        // 20180618 Igor >>>
        for J := 1 to 45 do
        begin
          cTIN := Trim(GetValue(nTable2Elm + 4));
          if SameText(GetValue(nTable2Elm), cTax) and not SameText(cTIN, '') then
          begin

            AddBeginTag(6, 'cbc:ConstituentEntityPerTaxJurisdiction');

            AddTag(8, 'cbc:ConstituentEntityName', GetValue(nTable2Elm + 1), OPTIONAL);
            AddTag(8, 'cbc:ConstituentEntityRole', GetValue(1635 + J));

            AddTag(8, 'cbc:TaxIdentificationNumber', cTIN, OPTIONAL);
            AddTag(8, 'cbc:TaxIdentificationNumberCountryCode', GetValue(nTable2Elm + 5), OPTIONAL); //20180717

           (*
            if not SameText(cTIN, 'NOTIN') then   //20180703 con
              AddTag(8, 'cbc:TaxIdentificationNumberCountryCode', GetValue(nTable2Elm + 5), OPTIONAL)
            Else
            Begin
              //20180713
              If GetValue(nTable2Elm + 5)>'' then
               AddTag(8, 'cbc:TaxIdentificationNumberCountryCode', GetValue(nTable2Elm + 5), OPTIONAL)
              Else
               AddEMPTYTag(8, 'cbc:TaxIdentificationNumberCountryCode', '', OPTIONAL);
            end;
           *)

            AddTag(8, 'cbc:IncorporationCountryCode', GetValue(nTable2Elm + 6), OPTIONAL);
            AddTag(8, 'cbc:AddressCityName', GetValue(nTable2Elm + 2), OPTIONAL);
            AddTag(8, 'cbc:AddressCountryCode', GetValue(nTable2Elm + 3), OPTIONAL);

            for A := 1 to 13 do
              if BoxChecked(nTable2Elm + 6 + A) then
                AddTag(8, 'cbc:BusinessActivityTypeCode', 'CBC5'+ PaddZero(IntToStr(A), 2), OPTIONAL);

            AddTag(8, 'cbc:OtherInformationText', GetValue(nTable2Elm + 20), OPTIONAL);
            AddEndTag(6, 'cbc:ConstituentEntityPerTaxJurisdiction', OPTIONAL);
          end;
          nTable2Elm := nTable2Elm + 21;
        end;
        AddEndTag(4, 'cbc:CbcReport', OPTIONAL);
        // 20180618 Igor <<<
      end;
      nTable1Elm := nTable1Elm + 11;
    end;

    // additional info
    if BoxChecked(566) or BoxChecked(567) then
    begin
      AddBeginTag(4, 'cbc:AdditionalInformation');
      //20230109 Igor >>>

      // 20180618 Igor >>>
      nElm1 := 1580;
      nElm2 := 1588;
      nElm3 := 1612;
      nElm4 := 1681;
      for I := 1 to 8 do
      begin
        AddBeginTag(6, 'cbc:AdditionalInformationList');
        cValue := Trim(GetValue(nElm1));
        if not cValue.IsEmpty then
        begin
          if BoxChecked(566) then
            cDefaultLang := 'EN'
          else
            cDefaultLang := 'FR'
        end
        else
          cDefaultLang := '';
        AddTag(6, 'cbc:AdditionalInformationLanguageCode', Trim(GetValue(nElm4, cDefaultLang)), OPTIONAL);
        AddTag(6, 'cbc:AdditionalInformationText', cValue, OPTIONAL);

        for j := 1 to 3 do
        begin
          if not SameText(GetValue(nElm2), '') and not SameText(GetValue(nElm3), '') then
          begin
            AddBeginTag(6, 'cbc:RelevantCountryCodeAndSummaryReference');
            AddTag(8, 'cbc:AdditionalInformationRelevantCountryCode', GetValue(nElm2), OPTIONAL);
            AddTag(8, 'cbc:AdditionalInformationSummaryReference', GetValue(nElm3), OPTIONAL);
            AddEndTag(6, 'cbc:RelevantCountryCodeAndSummaryReference', OPTIONAL);
          end;
          inc(nElm2);
          inc(nElm3);
        end;

        inc(nElm1);
        inc(nElm4);
        // 20180618 Igor <<<
        AddEndTag(6, 'cbc:AdditionalInformationList', OPTIONAL);
        //20230109 Igor <<<
      end;

      AddEndTag(4, 'cbc:AdditionalInformation');
    end;
    AddEndTag(0, 'cbc:CountryByCountryReport');

    for I := 1 to FList.Count - 1 do
      FList.Strings[I] := Space(ABaseIndent) + FList.Strings[I];
    Result := FList.Text;
  finally
    FList.Free;
  end;
end;

procedure TEfileCBCT2_2027.FormShow(Sender: TObject);
Var OnlineNo,Password,Url,NetFileDir,FileExt:String; // 20180625 Igor
begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir); // 20180625 Igor
  ProductionOrTestGroup.ItemIndex := 0; //1;  0 = Production, 1 = Test
  RetNo := GetCurrentRetNo;
  // 20180618 Igor >>>
  FCBCRDir := TPath.Combine(NetFileDir, 'CBCR'); // 20180625 Igor // 20180731 Igor
  if FileExists(GetSubmittedFileName) then
  begin
    edSubmittedFile.Text := GetSubmittedFileName;
    MemoFile.Lines.LoadFromFile(GetSubmittedFileName);
  end;
  if FileExists(GetReceivedFileName) then
  begin
    edReceivedFile.Text := GetReceivedFileName;
    MemoLog.Lines.LoadFromFile(GetReceivedFileName);
    MemoLog.Text := ReplaceStr(ClearXml(MemoLog.Text), '><', '>' + #13#10 + '<');
  end;
  // 20180618 Igor <<<
  // 20180625 Igor >>>
  if FileExists(GetReceivedHTMLFileName) then
    edReceivedHTMLFile.Text := GetReceivedHTMLFileName;
  // 20180625 Igor <<<
end;

function TEfileCBCT2_2027.GetReceivedFileName: string; // 20180618 Igor
begin
  ForceDirectories(FCBCRDir);
  Result := TPath.Combine(FCBCRDir, RetList[RetNo].SourceFlName + '-RECEIVED.XML'); // 20180625 Igor // 20180731 Igor
end;

function TEfileCBCT2_2027.GetReceivedHTMLFileName: string; // 20180625 Igor
begin
  ForceDirectories(FCBCRDir);
  Result := TPath.Combine(FCBCRDir, RetList[RetNo].SourceFlName + '-RECEIVED.HTML'); // 20180731 Igor
end;

function TEfileCBCT2_2027.GetSubmittedFileName: string; // 20180618 Igor
begin
  ForceDirectories(FCBCRDir);
  Result := TPath.Combine(FCBCRDir, RetList[RetNo].SourceFlName + '-SUBMITTED.XML'); // 20180625 Igor // 20180731 Igor
end;

procedure TEfileCBCT2_2027.ProductionOrTestGroupClick(Sender: TObject);
begin
  // testing mode
  if ProductionOrTestGroup.ItemIndex = 1 then
  begin
    UrlForWebServices.Text := 'https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';
  end
  // production mode
  else
  begin
    ProductionOrTestGroup.ItemIndex := 0;
    UrlForWebServices.Text :='https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';   //20190530
  end;
end;

procedure TEfileCBCT2_2027.WebServiceEfile;
var SoapMessage, SoapBody: string;
begin
  if GetWacNumber(RetNo).IsEmpty then
    SoapMessage := GetT2EfileReturnRequest(LeftStr(FetchElm(RetNo,'CBCR',602),4)) // 20180703 Igor
  else
    SoapMessage := GetT2NetfileReturnRequest(LeftStr(FetchElm(RetNo,'CBCR',602),4));
  SoapBody := CreateBody(17);
  SoapMessage := ReplaceStr(SoapMessage, '%BODY%', SoapBody);
  MemoFile.Clear;
  MemoFile.Lines.Add(SoapMessage);
end;

procedure TEfileCBCT2_2027.btnViewHTMLClick(Sender: TObject); // 20180625 Igor
var L: TStringList;
begin
  if FileExists(edReceivedHTMLFile.Text) then
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(edReceivedHTMLFile.Text);
      ShowMessageHTML(L.Text, 600);
    finally
      L.Free;
    end;
  end;
end;

procedure TEfileCBCT2_2027.CBCEfileBtnClick(Sender: TObject);
begin
  WebServiceEfile;
end;

end.