unit T2_2027EfileConsent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IOUtils; // 20180731 Igor

type TEfileType = (etCONSENT, etCONSENTX);

type
  TEfileConsentT2_2027 = class(TForm)
    Panel1: TPanel;
    ProductionOrTestGroup: TRadioGroup;
    URLForWebServices: TEdit;
    createT2CONSENTXMLBtn: TBitBtn;
    MemoLog: TMemo;
    MemoFile: TMemo;
    submitRC269EfileBTN: TBitBtn;
    // 20180731 Igor >>>
    Panel4: TPanel;
    Label1: TLabel;
    edSubmittedFile: TEdit;
    Panel5: TPanel;
    Label2: TLabel;
    edReceivedFile: TEdit;
    Panel6: TPanel;
    Label3: TLabel;
    btnViewHTML: TSpeedButton;
    edReceivedHTMLFile: TEdit;
    testResponseOnly: TBitBtn;
    OpenDialog1: TOpenDialog; //20180518 Igor
    // 20180731 Igor <<<
    procedure ProductionOrTestGroupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure createT2CONSENTXMLBtnClick(Sender: TObject);
    procedure submitRC269EfileBTNClick(Sender: TObject); //20180518 Igor
    procedure btnViewHTMLClick(Sender: TObject);
    procedure testResponseOnlyClick(Sender: TObject); // 20180731 Igor
  private
    { Private declarations }
    EfilerNo: string;
    //OnlineNo: string;
    Password: string;
    Url: string;
    NetFileDir: string;
    RetNo: integer;
    FCONSENTDir: string; // 20180731 Igor

    procedure CreateSoapMessage(AType: TEfileType; var SoapMessage: string);
    function CreateSoapHeader: string;
    function CreateBody(AType: TEfileType): string;
    procedure SubmitSoapMessage(SoapMessage: string);
    function ReplacePredefinedXMLEntities(info: string): string;
    function PrepareValue(Value: string; MaxLength: integer = 0): string;
    procedure WebServiceEfile(AType: TEfileType);
    Procedure ParseXmlResponse(Response, ATitle: string); // 20180731 Igor
    // 20180731 Igor >>>
    function GetSubmittedFileName: string;
    function GetReceivedFileName: string;
    function GetReceivedHTMLFileName: string;
    procedure SaveToFile(AText, AFileName: string);
    // 20180731 Igor <<<
  public
    { Public declarations }
  // SoftwareId:String; //20180624

  end;

var
  TEfileConsent: TEfileConsentT2_2027;
  SoftwareID:String;  //20200512

const
  SoftwareRevisionDate = '2025/06/01'; //'2023/12/08'; //2022/06/15'; //20240321 CON
  SoftwareIDTypeCode   = 'T2'; //'T1 did not work eiter //20210708
 // SoftwareID           = '064V';  //20200212

implementation

uses T2_2027TrimStr, vtCommon, MSXML2_TLB, ComObj, System.RegularExpressions,
  Xml.XMLDoc, Xml.XMLIntf, StrUtils, vtTrimStr, vtMulti, vtShowMessageHTML, // 20180731 Igor
  T2_2027Declare;  //20180624

{$R *.dfm}

function ClearXML(AXML: String): string; // 20180731 Igor
begin
  Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;

function TEfileConsentT2_2027.ReplacePredefinedXMLEntities(info: string): string;
begin
  info := Trim(info);
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;');
  Result := info;
end;

procedure TEfileConsentT2_2027.SaveToFile(AText, AFileName: string); // 20180731 Igor
var L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := AText;
    L.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    L.Free;
  end;
end;

procedure TEfileConsentT2_2027.SubmitSoapMessage(SoapMessage: string);
Var
  objHttp: IXMLHTTPRequest;
  Response: String;
  ResponseXmlFile: String;
  AList: TStringList;
  FTitle: string; // 20180731 Igor
begin
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
  //20180518 Igor >>>
  //objHttp.open('POST', URLForWebServices.Text, False, EfilerNo, Password);
  objHttp.open('POST', URLForWebServices.Text, False, '', '');
  //20180518 Igor <<<
  objHttp.setRequestHeader('SOAPAction', 'NA');
  objHttp.setRequestHeader('Content-Type', 'text/xml');
  // 20180731 Igor >>>
  SaveToFile(SoapMessage, GetSubmittedFileName);
  edSubmittedFile.Text := GetSubmittedFileName;
  if Pos('EfileRC59TypeRequest', SoapMessage) > 0 then
    FTitle := 'Business Consent XML Submission'
  else
    FTitle := 'Cancel Business Consent XML Submission';
  // 20180731 Igor <<<
  Screen.Cursor := crHourGlass;
  try
    objHttp.send(SoapMessage);
    Screen.Cursor := crDefault;
    delay(2000);
    Screen.Cursor := crDefault;
    Response := objHttp.ResponseText;
    // 20180731 Igor >>>
    SaveToFile(Response, GetReceivedFileName);
    edReceivedFile.Text := GetReceivedFileName;

    ParseXmlResponse(Response, FTitle);

    if FileExists(GetReceivedHTMLFileName) then
      edReceivedHTMLFile.Text := GetReceivedHTMLFileName;
    // 20180731 Igor <<<
    MemoLog.Clear;
    MemoLog.Text := ReplaceStr(Response, '><', '>' + #13#10 + '<');

  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TEfileConsentT2_2027.testResponseOnlyClick(Sender: TObject);
var atitle,response:string; L:TStringlist;
begin
  //openDialog1.

  if not openDialog1.Execute
  then ShowMessage('Open file was cancelled')
  else
  begin
    if FileExists(openDialog1.filename) then
    begin
      L := TStringList.Create;
      try
        L.LoadFromFile(openDialog1.filename);
        atitle    := 'Test Response From File: ' + ExtractFileName(openDialog1.FileName);
        response  := l.text;

    ParseXmlResponse(Response, ATitle);

      finally
        L.Free;
      end;
    end;
  end;
end;

procedure TEfileConsentT2_2027.ParseXmlResponse(Response, ATitle: string); // 20180731 Igor
var X: XML.XMLDoc.TXMLDocument;
        Node: IXMLNode;
        ALines, cStr: string; // 20180731 Igor
        ConfirmNumber: string; // 20180824 Igor
        Caption:string; //20230711 JZ

      {
      function ClearXML(AXML: String): string;
      begin
        Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
        Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
      end;
      }

      function GetNodeValue(ANode: IXMLNode; ANodeName: string; ACaption: string = ''): string; // 20180731 Igor
      var TNode: IXMLNode;
      begin
        Result := '';
        TNode := ANode.ChildNodes.FindNode(ANodeName);
        if Assigned(TNode) and (TNode.NodeValue <> NULL) then
        begin
          if not SameText(ACaption, '') then
            Result := ACaption + ': ';
          Result := Result + TNode.NodeValue;
        end;
      end;

      function GetErrorMessage(ANode: IXMLNode): string; // 20180731 Igor
      var I: integer;
          FNode: IXMLNode;
          cValue: string;
      begin
        Result := '';
        FNode := ANode.ChildNodes.FindNode('errorMessageEnglishText');
        if Assigned(FNode) then
        begin
          Result := FNode.NodeValue;
          Exit;
        end;
        // 20180828 Igor >>>
        FNode := ANode.ChildNodes.FindNode('englishMessageText');
        if Assigned(FNode) then
        begin
          Result := FNode.NodeValue;
          Exit;
        end;
        // 20180828 Igor <<<
        for I := 0 to ANode.ChildNodes.Count - 1 do
        begin
          cValue := GetErrorMessage(ANode.ChildNodes[I]);
          if not SameText(cValue, '') then
          begin
            if Pos(cValue, Result) > 0 then continue;
            if not SameText(Result, '') then
              Result := Result + '<br>';
            Result := Result + cValue;
          end;
        end;
      end;

      procedure ShowHTML(ACaption, ALines: string; AError: boolean); // 20180731 Igor
      var L: TStringList;
          A: TArray<string>;
          I: integer;
          cColor: string;
      begin
        ACaption := HTMLEscape(ACaption);
        ALines := ReplaceText(HTMLEscape(ALines), '&lt;br&gt;', '<br>');
        if AError then
          cColor := 'red'
        else
          cColor := 'green';
        L := TStringList.Create;
        try
          L.Add('<HTML><HEAD>');
          L.Add('<META CHARSET="UTF-8">');
          L.Add('<TITLE>T1 EFile Service</TITLE>');  //20200212
          L.Add('</HEAD>');
          L.Add('<BODY>');
          L.Add('<DIV id="contentheader">');
          L.Add('<H1><FONT size=5><STRONG>'+ ATitle +'</STRONG></FONT></H1>');
          L.Add('<H2><FONT color='+ cColor +' size=5><STRONG>'+ ACaption +'</STRONG></FONT></H2>');
          L.Add('<P>Received: '+ DateTimeToStr(Now) +'</P>');
          L.Add('<HR>');

          L.Add('<P></P>');
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
          L.SaveToFile(GetReceivedHTMLFileName, TEncoding.UTF8);
          ShowMessageHTML(L.Text, 600);
        finally
          L.Free;
        end;
      end;

begin
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

      // 20180731 Igor >>>
      if SameText(Node.NodeName, 'Fault') then
      begin

        ALines := '';
        cStr := GetNodeValue(Node, 'faultcode', 'Fault Code');
        if not SameText(cStr, '') then
          ALines := ALines + cStr + #13;
        cStr := GetNodeValue(Node, 'faultstring', 'Fault String');
        if not SameText(cStr, '') then
          ALines := ALines + cStr + #13;
        cStr := GetErrorMessage(Node);
        if not SameText(cStr, '') then
          ALines := ALines + 'Error: ' + cStr + #13;
        ShowHTML('Failed Response', ALines, true);
        Exit;
      end;

      if SameText(Node.NodeName, 'EfileRC59ResponseType') or
         SameText(Node.NodeName, 'EfileRC59XResponseType') then
      begin
        if SameText(Node.NodeName, 'EfileRC59ResponseType') then
          Caption := 'Consent EFile received successfully - SEE INSTRUCTION MESSAGE'
        else if SameText(Node.NodeName, 'EfileRC59XResponseType') then
          Caption := 'Cancel Consent EFile received successfully - SEE INSTRUCTION MESSAGE';

        ALines := '';
        cStr := GetNodeValue(Node, 'efileID', 'EFile ID');
        if not SameText(cStr, '') then
          ALines := ALines + cStr + #13;
        cStr := GetNodeValue(Node, 'businessNumber', 'Business Number');
        if not SameText(cStr, '') then
          ALines := ALines + cStr + #13;
        // 20180824 Igor >>>
        ConfirmNumber := '';
        cStr := GetNodeValue(Node, 'timestampDateTime', '');
        if not SameText(cStr, '') then
        begin
          ConfirmNumber := Copy(cStr, 1, 4) + '/' + Copy(cStr, 6, 2) + '/' + Copy(cStr, 9, 2);
          cStr := Copy(cStr, 1, 10) + ' ' + Copy(cStr, 12, 8);
          ALines := ALines + 'Date: ' + cStr + #13;
        end;
        if SameText(ConfirmNumber, '') then ConfirmNumber := FormatDateTime('yyyy/mm/dd', Date);
        StoreElm(RetNo, GetFormNo('CONSENT'), 28, ConfirmNumber);
        // 20180824 Igor <<<


        //20230711 JZ >>>
        //20231207 Igor >>>
        Node := Node.ChildNodes.FindNode('instructionMessage');
        if Assigned(Node) then
          if SameText(Node.NodeName, 'instructionMessage') then
          begin
              cStr := GetNodeValue(Node, 'englishMessageText', 'Instruction Message');
            if not SameText(cStr, '') then
                ALines := ALines + cStr + #13;

          end;
        //20231207 Igor <<<
        
        ShowHTML(Caption, ALines, false);

        //20230711 JZ <<<


        Exit;
      end;
      // 20180731 Igor <<<
    except on E: Exception do
      begin
        ShowMessage('Error occured while processing CRA SOAP response: '+ #13 + E.Message + #13#13 + 'Response: '+ Response);
      end;
    end;
  finally
    X.Free;
  end;
end;

function TEfileConsentT2_2027.PrepareValue(Value: string; MaxLength: integer = 0): string;
begin
  Value := ReplacePredefinedXMLEntities(Trim(Value));
  if MaxLength > 0 then
    Value := Copy(Value, 1, MaxLength);
  Result := Value;
end;

procedure TEfileConsentT2_2027.submitRC269EfileBTNClick(Sender: TObject); //20180518 Igor
var SoapMessage: string;
begin
  SoapMessage := MemoFile.Text;
  SubmitSoapMessage(SoapMessage);
end;

procedure TEfileConsentT2_2027.btnViewHTMLClick(Sender: TObject); // 20180731 Igor
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

function TEfileConsentT2_2027.CreateBody(AType: TEfileType): string;
const indent      = '  ';
      indentT     = '    ';
      indentTT    = '      ';
      indentTTT   = '        ';
      indentTTTT  = '          ';
      indentTTTTT = '            ';

var L: TStringList;
    CancellationCode:String;
    clientBusinessNumber: string;
    ClientBusinessName: string;
    racIDType, repID, groupID, repBusinessNumber: string;

    programmAccountsType: integer;
    expiryDate: string;
    authLevel: string;
    programmIdentifiers: array of string;
    programmRefNumbers: array of string;
    //20180728 Con
    programmAuthLevels: array of string;
    programmExpiryDates: array of string;

    signingFirstName, signingLastName: string;


    I: integer;
begin

    GetEOLParms(EfilerNo,Password,Url,NetFileDir);
   //11 means efile
    ClientbusinessName   := PrepareValue(FetchElm(RetNo, 'CONSENT', 1), 175);
    clientBusinessNumber := PrepareValue(FetchElm(RetNo, 'CONSENT', 2), 9);

    if AType = etCONSENT then
    begin
      repID             := PrepareValue(FetchElm(RetNo, 'CONSENT', 10), 62);
      groupID           := PrepareValue(FetchElm(RetNo, 'CONSENT', 57), 67);
      repBusinessNumber := PrepareValue(FetchElm(RetNo, 'CONSENT', 20), 63);
    end
    else
    begin
      CancellationCode:='';
      if FetchElm(RetNo, 'CONSENT', 47)>''      then CancellationCode:='01'
      Else if FetchElm(RetNo, 'CONSENT', 46)>'' then CancellationCode:='02';

      if CancellationCode='02'then //send repID, groupID, repBusinessNumber only if is CancellationCode
      begin
        repID             := PrepareValue(FetchElm(RetNo, 'CONSENT', 48), 62);
        groupID           := PrepareValue(FetchElm(RetNo, 'CONSENT', 50), 67);
        repBusinessNumber := PrepareValue(FetchElm(RetNo, 'CONSENT', 49), 63);
      end;
    end;

    if not SameText(repID, '') then
      racIDType := '01'
    else if not SameText(groupID, '') then
      racIDType := '03'
    else if not SameText(repBusinessNumber, '') then
      racIDType := '02'
    else
      racIDType := ''; // raise error?

    if not SameText(Trim(FetchElm(RetNo, 'CONSENT', 12)), '') then
        programmAccountsType := 1
    else if not SameText(Trim(FetchElm(RetNo, 'CONSENT', 17)), '') then  //certain program accounts
        programmAccountsType := 2;

    if programmAccountsType = 1 then
    begin
      authLevel  := Trim(FetchElm(RetNo, 'CONSENT', 16)); //jz 20190131
      expiryDate := stringreplace(FetchElm(RetNo,'CONSENT', 15), '/', '-', [rfReplaceAll, rfIgnoreCase]); //jz 20190131
      //RemoveChar(RemoveChar(RemoveChar(FetchElm(RetNo,'CONSENT', 15),'/'),'-'),' '); //20180731;
      //if not SameText(expiryDate, '') then expiryDate := FormatDateTime('YYYY-MM-DD', expiryDate); //expiryDate := FormatDateTime('YYYYMMDD', StrToDateDef(expiryDate, EncodeDate(1900, 01, 01)));
    end
    else if programmAccountsType = 2 then
    begin
      SetLength(programmIdentifiers, 4);
      SetLength(programmRefNumbers, 4);
      //20180728 Con
      SetLength(programmAuthLevels, 4);
      SetLength(programmExpiryDates, 4);

      programmIdentifiers[0] := PrepareValue(FetchElm(RetNo, 'CONSENT', 17), 2);
      programmIdentifiers[1] := PrepareValue(FetchElm(RetNo, 'CONSENT', 24), 2);
      programmIdentifiers[2] := PrepareValue(FetchElm(RetNo, 'CONSENT', 31), 2);
      programmIdentifiers[3] := PrepareValue(FetchElm(RetNo, 'CONSENT', 38), 2);

      programmRefNumbers[0] := PrepareValue(FetchElm(RetNo, 'CONSENT', 19), 4);
      programmRefNumbers[1] := PrepareValue(FetchElm(RetNo, 'CONSENT', 26), 4);
      programmRefNumbers[2] := PrepareValue(FetchElm(RetNo, 'CONSENT', 33), 4);
      programmRefNumbers[3] := PrepareValue(FetchElm(RetNo, 'CONSENT', 40), 4);

      programmAuthLevels[0] := trim(FetchElm(RetNo, 'CONSENT', 22)); //jz 20190131
      programmAuthLevels[1] := trim(FetchElm(RetNo, 'CONSENT', 29));
      programmAuthLevels[2] := trim(FetchElm(RetNo, 'CONSENT', 36));
      programmAuthLevels[3] := trim(FetchElm(RetNo, 'CONSENT', 43));

      ProgrammExpiryDates[0]:=stringreplace(FetchElm(RetNo, 'CONSENT',23), '/', '-', [rfReplaceAll, rfIgnoreCase]); //jz 20190131
      ProgrammExpiryDates[1]:=stringreplace(FetchElm(RetNo, 'CONSENT',30), '/', '-', [rfReplaceAll, rfIgnoreCase]);
      ProgrammExpiryDates[2]:=stringreplace(FetchElm(RetNo, 'CONSENT',37), '/', '-', [rfReplaceAll, rfIgnoreCase]);
      ProgrammExpiryDates[3]:=stringreplace(FetchElm(RetNo, 'CONSENT',44), '/', '-', [rfReplaceAll, rfIgnoreCase]);
    end;

    signingFirstName := PrepareValue(FetchElm(RetNo, 'CONSENT', 53), 30);
    signingLastName  := PrepareValue(FetchElm(RetNo, 'CONSENT', 54), 30);

    L := TStringList.Create;
    try
        L.Add('<soap-env:Body>');
        if AType = etCONSENT then
        begin
          L.Add(indent  + '<xscop:EfileRC59Type xmlns:xscop="http://www.cra-arc.gc.ca/xmlns/xscop" soap-env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'); //jz 20190125
          L.Add(indentT +  '<xscop:EfileRC59TypeRequest xmlns:xscop="http://www.cra-arc.gc.ca/xmlns/xscop/request/1-0-0">');                                              //jz 20190125
        end
        else
        begin
          L.Add(indent  + '<xscop:EfileRC59XType xmlns:xscop="http://www.cra-arc.gc.ca/xmlns/xscop" soap-env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'); //jz 20190125
          L.Add(indentT + '<xscop:EfileRC59XTypeRequest xmlns:xscop="http://www.cra-arc.gc.ca/xmlns/xscop/request/1-0-0" >');                                              //jz 20190125
        end;
        L.Add(indentTT  + '<xscop:clientData>');
        L.Add(indentTTT + '<xscop:clientBusinessNumber>'+ clientBusinessNumber +'</xscop:clientBusinessNumber>');
        L.Add(indentTTT + '<xscop:businessName>'+ ClientBusinessName +'</xscop:businessName>');  //20200212
        L.Add(indentTT  + '</xscop:clientData>');


        if racIDType > '' then
        begin
          L.Add(indentTT  + '<xscop:representativeData>');
          L.Add(indentTTT + '<xscop:racIDType>'+ racIDType +'</xscop:racIDType>');
          If RepId>''             then L.Add(indentTTT + '<xscop:repID>'+ repID +'</xscop:repID>');
          If GroupId>''           then L.Add(indentTTT + '<xscop:groupID>'+ groupID +'</xscop:groupID>');
          If repBusinessNumber>'' then L.Add(indentTTT + '<xscop:repBusinessNumber>'+ repBusinessNumber +'</xscop:repBusinessNumber>'); //20180728

          if AType = etCONSENT then
          begin
            If (FetchElm(RetNo,'CONSENT',27)>'') then //thre is phone
            Begin
             L.Add(indentTTT + '<xscop:repTelephone>');
             L.Add(indentTTTT + '<xscop:countryCode>'+'01'+'</xscop:countryCode>');  //20180627 CON
             If FetchElm(RetNo,'CONSENT',21)>'' then L.Add(indentTTTT + '<xscop:cityAreaCode>'   +FetchElm(RetNo,'CONSENT',21)+'</xscop:cityAreaCode>');
             If FetchElm(RetNo,'CONSENT',27)>'' then L.Add(indentTTTT + '<xscop:telephoneNumber>'+RemoveChar(FetchElm(RetNo,'CONSENT',27),'-')+'</xscop:telephoneNumber>');
             L.Add(indentTTT + '</xscop:repTelephone>');
            End;

          end; //if AType = etCONSENT

          L.Add(indentTT  + '</xscop:representativeData>');
        end;


        if programmAccountsType = 1 then
        begin
          L.Add(indentTT  + '<xscop:permissions>');
          If ExpiryDate>'' then L.Add(indentTTT + '<xscop:expiryDate>'+ expiryDate +'</xscop:expiryDate>');
          L.Add(indentTTT + '<xscop:authorizationLevel>'+ authLevel +'</xscop:authorizationLevel>');
          L.Add(indentTT  + '</xscop:permissions>');
        end
        else if programmAccountsType = 2 then
        begin
          //20231207 Igor >>>
          for I := 0 to 3 do
          begin
            if SameText(programmIdentifiers[I], '') then continue;
            L.Add(indentTT  + '<xscop:programAccountData>');
            L.Add(indentTTT  + '<xscop:businessProgramIdentifier>'+ programmIdentifiers[I] +'</xscop:businessProgramIdentifier>');
            if not SameText(programmRefNumbers[I], '') then
              L.Add(indentTTT  + '<xscop:businessProgramAccountReferenceNumber>'+ programmRefNumbers[I] +'</xscop:businessProgramAccountReferenceNumber>');
            L.Add(indentTT  + '</xscop:programAccountData>');
          end;
          for I := 0 to 3 do
          begin
            if SameText(ProgrammExpiryDates[I], '') and SameText(ProgrammAuthLevels[I], '') then continue;
            L.Add(indentTT  + '<xscop:permissions>');
            If ProgrammExpiryDates[I]>'' then L.Add(indentTTT + '<xscop:expiryDate>'+ ProgrammExpiryDates[I] +'</xscop:expiryDate>');
            L.Add(indentTTT + '<xscop:authorizationLevel>'+ ProgrammAuthLevels[I] +'</xscop:authorizationLevel>');
            L.Add(indentTT  + '</xscop:permissions>');
//            L.Add(indentTT  + '<xscop:programAccountData>');
//            L.Add(indentTTT  + '<xscop:businessProgramIdentifier>'+ programmIdentifiers[I] +'</xscop:businessProgramIdentifier>');
//            if not SameText(programmRefNumbers[I], '') then
//              L.Add(indentTTT  + '<xscop:businessProgramAccountReferenceNumber>'+ programmRefNumbers[I] +'</xscop:businessProgramAccountReferenceNumber>');
//            if not SameText(programmAuthLevels[I], '') then
//              L.Add(indentTTT  + '<xscop:authorizationLevel>'+ ProgrammAuthLevels[I] +'</xscop:authorizationLevel>'); // 20180731 Igor
//            if not SameText(programmAuthLevels[I], '') then
//              L.Add(indentTTT  + '<xscop:ExpiryDate>'+ ProgrammExpiryDates[I] +'</xscop:ExpiryDate>');
//            L.Add(indentTT  + '</xscop:programAccountData>');
          end;
          //20231207 Igor <<<
        end;
        L.Add(indentTT + '<xscop:signingAuthority>');
        L.Add(indentTTT + '<xscop:firstName>'+ signingFirstName +'</xscop:firstName>');
        L.Add(indentTTT + '<xscop:lastName>'+ signingLastName +'</xscop:lastName>');
        L.Add(indentTT + '</xscop:signingAuthority>');

        if AType = etCONSENT then  //authorization
        begin
          L.Add(indentT + '</xscop:EfileRC59TypeRequest>');
          L.Add(indent + '</xscop:EfileRC59Type>'); //jz 20190125 case sensitive
        end
        else
        begin   //cancellation
          L.Add(indentTT + '<xscop:cancellationCode>'+ cancellationCode +'</xscop:cancellationCode>');
          L.Add(indentT + '</xscop:EfileRC59XTypeRequest>');
          L.Add(indent + '</xscop:EfileRC59XType>'); //jz 20190125 case sensitive
        end;
        L.Add('</soap-env:Body>');
        Result := L.Text;
    finally
        L.Free;
    end;
end;

function TEfileConsentT2_2027.CreateSoapHeader: string;
var L: TStringList;
begin
  SoftwareID:= 'VT50'; //20250605'VT49'; //'VT47'; //20231208 CON   //VT44'; //20220529
  L := TStringList.Create;
  try
    //20190125 jz
    L.Add('  <soap-env:Header>');
    L.Add('    <wsse:Security xmlns:wsse="http://schemas.xmlsoap.org/ws/2002/04/secext">');
    L.Add('      <wsse:UsernameToken>');
    L.Add('        <wsse:Username>'+ EfilerNo+'</wsse:Username>');  //20200319
    L.Add('        <wsse:Password>'+ Password +'</wsse:Password>');         //20200212
    //    L.Add('        <wsse:Username>'+ PrepareValue(OnlineNo) +'</wsse:Username>');
    //    L.Add('        <wsse:Password>'+ PrepareValue(Password) +'</wsse:Password>');
    L.Add('      </wsse:UsernameToken>');
    L.Add('    </wsse:Security>');
    L.Add('    <wsse:VendorCredential soap-env:actor="ca.gc.ccra.klco" soap-env:mustUnderstand="1" xmlns:wsse="http://schemas.xmlsoap.org/ws/2002/04/secext">');
    L.Add('      <xskl:VendorCredentialsTypeRequest xmlns:xskl="http://www.cra-arc.gc.ca/xmlns/xskl/request/1-0-0">');
    L.Add('      <xskl:softwareID>'          + SoftwareID                        +'</xskl:softwareID>');
  //  L.Add('      <xskl:softwareID>'          + PrepareValue(SoftwareID)           +'</xskl:softwareID>');
    L.Add('      <xskl:softwareRevisionDate>'+ PrepareValue(SoftwareRevisionDate) +'</xskl:softwareRevisionDate>');
    L.Add('      <xskl:softwareIDTypeCode>'  + PrepareValue(SoftwareIDTypeCode)   +'</xskl:softwareIDTypeCode>');
    L.Add('      </xskl:VendorCredentialsTypeRequest>');
    L.Add('    </wsse:VendorCredential>');
    L.Add('  </soap-env:Header>');

    Result := L.Text;
  finally
    L.Free;
  end;
end;

procedure TEfileConsentT2_2027.CreateSoapMessage(AType: TEfileType; var SoapMessage: string);
var SoapHeader, SoapBody, SoapFooter: string;
    L: TStringList;
begin
  SoapHeader := CreateSoapHeader;
  SoapBody   := CreateBody(AType);

  L := TStringList.Create;
  try
    L.Add('<?xml version="1.0" encoding="UTF-8"?>');
    L.Add('<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">');

    L.Add(SoapHeader);
    L.Add(SoapBody);

    L.Add('</soap-env:Envelope>');

    SoapMessage := L.Text;
  finally
    L.Free;
  end;
end;

procedure TEfileConsentT2_2027.FormShow(Sender: TObject);
begin
  //SoftwareId:=RSIApprovalCode;   //20200512   //20200627
  ProductionOrTestGroup.ItemIndex := 0;   //20180824 Con Production default
  ProductionOrTestGroupClick(nil); // 20180828 Igor
  RetNo := GetCurrentRetNo;
  // 20180731 Igor >>>
  GetEOLParms(EfilerNo,Password,Url,NetFileDir);
  FCONSENTDir := TPath.Combine(NetFileDir, 'CONSENT');
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
  if FileExists(GetReceivedHTMLFileName) then
    edReceivedHTMLFile.Text := GetReceivedHTMLFileName;
  // 20180731 Igor <<<
end;

function TEfileConsentT2_2027.GetReceivedFileName: string; // 20180731 Igor
begin
  ForceDirectories(FCONSENTDir);
  Result := TPath.Combine(FCONSENTDir, RetList[RetNo].SourceFlName + '-RECEIVED.XML');
end;

function TEfileConsentT2_2027.GetReceivedHTMLFileName: string; // 20180731 Igor
begin
  ForceDirectories(FCONSENTDir);
  Result := TPath.Combine(FCONSENTDir, RetList[RetNo].SourceFlName + '-RECEIVED.HTML');
end;

function TEfileConsentT2_2027.GetSubmittedFileName: string; // 20180731 Igor
begin
  ForceDirectories(FCONSENTDir);
  Result := TPath.Combine(FCONSENTDir, RetList[RetNo].SourceFlName + '-SUBMITTED.XML');
end;

procedure TEfileConsentT2_2027.ProductionOrTestGroupClick(Sender: TObject);
begin
  testResponseOnly.Visible := false;

  // testing mode
  if ProductionOrTestGroup.ItemIndex = 1 then
  begin
    UrlForWebServices.Text :='https://apps-ct.cra-arc.gc.ca/ebci/klco/webservices/services/ERC59Service?wsdl';

    testResponseOnly.Visible := true;

  end
  // production mode
  else
  begin
    ProductionOrTestGroup.ItemIndex := 0;
    UrlForWebServices.Text := 'https://apps.cra-arc.gc.ca/ebci/klco/webservices/services/ERC59Service?wsdl';
  end;
  //20180518 Igor <<<
end;

procedure TEfileConsentT2_2027.WebServiceEfile(AType: TEfileType);
var SoapMessage: string;
begin
  GetEOLParms(EfilerNo, Password, Url, NetFileDir);
  CreateSoapMessage(AType, SoapMessage);
  MemoFile.Clear;
  MemoFile.Lines.Add(SoapMessage);
  //20180518 Igor >>>
  //SoapMessage := MemoFile.Text;
  //SubmitSoapMessage(SoapMessage);
  //20180518 Igor <<<
end;

procedure TEfileConsentT2_2027.createT2CONSENTXMLBtnClick(Sender: TObject);
var
  authConsent:TEfileType;
  OnlineNo, Password, Url, NetFileDir,s:String;
begin
  //20200520
  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  if (OnlineNo='') and (FetchElm(RetNo,'T2',75)='') then //Efiler / wac both empty
  Begin
   ShowMessage('Efiler Number or WAC is required');
   exit;
  End;
 //-----------------------------

  if FetchElm(RetNo, 'CONSENT', 13) > '' then
    authConsent := etCONSENT
  else
    authConsent := etCONSENTX;

  WebServiceEfile(authConsent);
end;

end.
