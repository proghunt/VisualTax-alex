unit T2_2027DACRequest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,
  T2_2027TrimStr, T2_2027Declare, T2_2027Common, T2_2027Common2, Db, DBTables, Grids, DBGrids,
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, vtLabel, Vcl.Mask, vteditbox; //20110129  NEEDED for connection and the response handler

  Const SOFTRELEASEYEAR   = '2023';
  Const SOFTRELEASEMONTH  = '12';
  Const SOFTRELEASEDAY    = '31';
  Const CrLf              =  Chr(13)+Chr(10);
  //Const SoftwareId   = 'VT33';
  //Const SoftVendor   = '064K';

 type
 TWACResponseResultType = (WACResponseSuccess,WACResponseRejected,WACResponseWebServiceError,WACResponseUnknownError);
 TWACResponseAckRec = Record
   Name                  : String;
   BNnumber              : String;
   TxYear                : String;
   DateTimeReceived      : String;
   TxYearEndDate         : String;
   TxYearEndTime         : String;
   ResponseCode          : String;
   ResponseText          : ansiString;
   WACCode               : String;
   WACResponseResultType : TWACResponseResultType;
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
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    wacR_BNnumber: TEdit;
    wacR_IncorporationDate: TEdit;
    wacR_Postal: TEdit;
    vtLabel11: TvtLabel;


    procedure setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);

    Function ReplaceXMLChars(info: String): String;
    Function ConvertCheckBoxTo1(S:String):String;
    Function CreateSoapMessage(RetNo:Integer):String;
    procedure GetUrlBox;
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    Procedure SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);

    Function parseResponse(rString:AnsiString):TWACResponseAckRec;
    Function CreateEfileResponseHtm(RetNo: Integer):String;
    procedure PostResponseToFrm();
    procedure FormActivate(Sender: TObject);
    procedure ShowXMLBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure viewErrorCluesBtnClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure instalMSXMLbtnClick(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
    procedure wacR_IncorporationDateExit(Sender: TObject);
  private
    { Private declarations }
    RetNo:Integer;
  public
    { Public declarations }
  end;

var

  TWACRequestEfile: TWACRequestEfileT2_2027;
  SoapMsg:AnsiString;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
  webServiceUserName, webServicePassword: String;
  NetFileDir:String;
  FormCnt:Integer;
  WACResponseEfileDir: String;
  sUrl:String;
  Indent1, Indent2,Indent3,Indent4,Indent5,Indent6,Indent7, Indent8,Indent9,Indent10,Indent11:Integer;

  WACResponseRec:TWACResponseAckRec;

implementation

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T2_2027, T2_2027main,
  vtShared, vtDynData{,childwinnew};



{$R *.DFM}



procedure TWACRequestEfileT2_2027.FormCreate(Sender: TObject);
Var
  TempList:TStringList;
  T2FNo:integer;
begin
 WACResponseEfileDir:=AppDir+'\'+'WACResponseEfile';
 If DirectoryExists(WACResponseEfileDir) = false then ForceDirectories(WACResponseEfileDir);

 RetNo:=GetCurrentRetNo;

 If RetNo>0 then
 begin
   T2FNo:=GetFormNo('T2');

   wacR_BNnumber.Text           := FetchElmFNo(RetNo,T2FNo,1);   //bnnumber
   wacR_TaxYearEnd.Text         := FetchElmFNo(RetNo,T2FNo,11);  //tax year end date
   wacR_TaxEndTime.Text         := FetchElmFNo(RetNo,T2FNo,207); //tax year end time

   wacR_IncorporationDate.Text  := FetchElmFNo(RetNo,T2FNo,299); //incorporation date //jz 20240703

   wacR_Postal.Text             := FetchElmFNo(RetNo,T2FNo,35);  //mailing address postal code
   if wacR_Postal.Text = '' then
     wacR_Postal.Text           := FetchElmFNo(RetNo,T2FNo,20);  //if no mailing address postal code use head office
   wacR_RequesterLastName.Text  := FetchElmFNo(RetNo,T2FNo,742); //requester last name
   wacR_RequesterFirstName.Text := FetchElmFNo(RetNo,T2FNo,743); //requester first name
   wacR_RequesterJobTitle.Text  := FetchElmFNo(RetNo,T2FNo,744); //requester job title
 end;
end;


procedure TWACRequestEfileT2_2027.SubmitBtnClick(Sender: TObject);
Var RetNo:Integer;FlName:String;
begin
 If ValidPostal(RetNo,OptRec.Prp_Postal) = false then
 begin
  ShowMessage('Please fix the Postal code in Configure -> General Options -> Preparer');
  Exit;
 end;

 RetNo:=GetCurrentRetNo;

 flName := CreateSoapMessage(RetNo);
 If SoapMsg='' then
 Begin
  ShowMessage('No data available for submission');
  Exit;
 end;
 SubmitSoapMsg(SoapMsg,flName);
end;

Procedure TWACRequestEfileT2_2027.SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
Var
 i:Integer;
 WString:AnsiString;  //wide string
 objHttp:ixmlHttpRequest;
 Status: String;
 T1135Msg:AnsiString;
 TempSoapList:TStringList;
 TempDataList:TStringList;
 h:THandle;
 s:String;
 AList:TstringList;
 DOMDocument:IXMLDOMDocument; TrackNodes: IXMLDOMNodeList;
 ResponseXmlFile:String;
 ConfirmationNumber:String;
 WACResponseHTM:string;
Begin

  ObjHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
 ObjHTTP.open('POST', sURL, False, OnlineNo, Password);   //20110120

 ObjHTTP.setRequestHeader('SOAPAction', 'NA'); //set action?
 objHTTP.setRequestHeader('Content-Type','text/xml; charset=UTF-8'); //added encoding //20150206
 Screen.Cursor := crHourGlass;

 ObjHTTP.send(SoapMsg);
 Screen.Cursor := crDefault;
 delay(2000);
 Screen.Cursor := crDefault;
 WString:=objHttp.ResponseText;

 ResponseXmlFile:= MkResponseFileName(RetNo);
 AList:=TStringList.Create;
 AList.Add(WString);
 AList.SaveToFile(ResponseXmlFile);
 AList.Free;

 parseResponse(WString);
 PostResponseToFrm();
 WacResponseHTM := CreateEfileResponseHtm(RetNo);

 h := ShellExecute(Self.Handle, nil, PChar('' + WacResponseHTM), nil, nil, SW_NORMAL);
 If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');

 s:=MkSubmittedFileName(RetNo);
 If FileExists(s) then RenameFile(s,ReplaceStr(S, 'ToBeSubmitted', 'Submitted'));

 objHttp:=Nil;

end;


procedure TWACRequestEfileT2_2027.FormActivate(Sender: TObject);
begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  GetUrlBox;
  If (Length(OnlineNo)<>5) or (Password='') then
  begin
   SoapMsg:='';
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT2.SetupEOLInternetFiling1Click(Sender);
   Exit;
  end;

  SoapMsg:='';

  RetNo:=GetCurrentRetNo;
end;

procedure TWACRequestEfileT2_2027.ShowXMLBtnClick(Sender: TObject);
Var h:THandle; FlName:String;
begin
  flName:= CreateSoapMessage(RetNo);
  h := ShellExecute(Self.Handle,'open',Pchar(''+flName),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('File not found');
end;

procedure TWACRequestEfileT2_2027.DBGrid1DblClick(Sender: TObject);
Var i:Integer; FlName:String;
SomeList:TStringList;
begin
end;


procedure TWACRequestEfileT2_2027.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;


Function TWACRequestEfileT2_2027.MkSubmittedFileName(RetNo:Integer):String;
    //embedded function
    Function GetMinutesAndSeconds:String;  //function within function
    Var SHours, SMinutes,SSeconds : string[2];
        Hour,Min,Sec,Msec :word;
    begin
      DecodeTime(Now,Hour,Min,Sec,Msec);
      sMinutes := AllTrim(IntToStr(Min));
      sSeconds := AllTrim(IntToStr(Sec));
      If Length(sMinutes) =1 then SMinutes := '0'+SMinutes;
      If Length(SSeconds) =1 then SSeconds := '0'+SSeconds;
      Result := SMinutes+SSeconds;
    end; //end of embedded function
Var s:String;
begin
  result:=WACResponseEfileDir+'\'+'WACResponse-ToBeSubmitted-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml'  //20160526
end;



Function TWACRequestEfileT2_2027.MkResponseFileName(RetNo:Integer):String;
begin
 result:=WACResponseEfileDir+'\'+'WACResponse-Response-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml';  //20160526
end;

procedure TWACRequestEfileT2_2027.GetUrlBox;
begin
 //20150102
 If TestOrProductionGroup.ItemIndex=0 then  //production
   sUrl :='https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl' //sUrl :='https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'
 else  //test
   sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl'; //sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';

  UrlBox.Text := SUrl;

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
var val:string;
begin
  val := wacR_IncorporationDate.Text;
  AutoFormatDate(val);
  wacR_IncorporationDate.Text := val;

  //if not(wacR_IncorporationDate.Text = '10') then
  if Length(wacR_IncorporationDate.Text)<>10 then //20200109 CON
    showmessage('Incorporation Date field must be proper date format');

end;

procedure TWACRequestEfileT2_2027.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;

procedure TWACRequestEfileT2_2027.instalMSXMLbtnClick(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;



Function TWACRequestEfileT2_2027.parseResponse(rString:AnsiString):TWACResponseAckRec;

    function LTrimAnsi(Const S: AnsiString): AnsiString;
    var //len: integer;
        i: Integer;
    begin
        i := 1;
        while s[i] = ' ' do inc(i);
        result := copy(s, i, length(s) - i + 1);
    end;

    function RTrimAnsi(S: AnsiString): AnsiString;
    var len: Integer;
    begin
        while s[length(s)] = ' ' do
                dec(s[1{0}]);
        result := s;
    end;

    function AllTrimAnsi(Str: AnsiString): AnsiString;
    begin
        Result := Str; exit; //not working??????????
        Result := LTrimAnsi(RTrimAnsi(Str));
    end {Trim};

    function xmlTagExists(sTag: string;text:ansistring): boolean;
    var eTag:string; sPos,ePos :integer;
    begin
        result := false;
        if pos(sTag,text) > 0 then
          result := true;
    end;

    function xmlTagValue(sTag: string;text:ansistring): string; overload;
    var eTag:string; sPos,ePos :integer;
    begin
        sPos    := pos(sTag,text) + length(sTag);

        eTag := sTag;
        insert('/', eTag, 2);
        ePos    := pos(eTag,text);
        result  := AllTrimAnsi(MidAnsiStr(text,sPos,ePos-sPos));
    end;

    function xmlTagValue(sTag,eTag: string;text:ansistring): string; overload;
    var sPos,ePos :integer;
    begin
        sPos    := pos(sTag,text) + length(sTag);
        ePos    := pos(eTag,text);
        result  := AllTrimAnsi(MidAnsiStr(text,sPos,ePos-sPos));
    end;

var
    i,k,sPos,ePos,FNo : integer;
    s,e,fCode,fString,messageString,idstring,TimeReceived,tempString : String;
    ReturnedTransmissionID,ReturnedEfilerNumber,ReturnedControlNumber:String;

    ReturnedCorpName,ReturnedBnNumber,ReturnedTaxYr:string;

    today : TDateTime;
begin

    With WACResponseRec do
    begin

      Name             := GetCorpName(RetNo);
      BnNumber         := xmlTagValue('<tgif:BusinessNumber>',rString);

      if BnNumber = '' then BnNumber         := GetCorpBusNo(RetNo);

      TxYear           := inttostr(GetTaxationYearEndYYYY(RetNo));
      TxYearEndDate    := xmlTagValue('<tgif:TaxationYearEndDate>',rString);
      TxYearEndTime    := xmlTagValue('<tgif:TaxationYearEndTime>',rString);

      DateTimeReceived := xmlTagValue('<tgif:TimestampDateTime>',rString); //leftstr(xmlTagValue('<tgif:TimestampDateTime>',rString),10);
      if DateTimeReceived = '' then
      begin
        today := Now;
        DateTimeReceived := '(local) ' + DateToStr(today) + ' ' + TimeToStr(today);
      end;
      ResponseCode     := '';
      ResponseText     := '';

      //Proper Response -------------------------------------------------------------
      if xmlTagExists('<tgif:WebAccessCodeResponse xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif/response/1-0-0">',rString) then
      begin
        //Successful Response -------------------------------------------------------------
        if xmlTagExists('<tgif:WebAccessCodeResponseMessage>',rString) then
        begin
          WACResponseResultType := WACResponseSuccess;
          WACCode               := xmlTagValue('<tgif:WACode>',rString);
        end
        //Error Response ------------------------------------------------------------------
        else if xmlTagExists('<tgif:WebAccessCodeErrorMessage>',rString) then
        begin
          WACResponseResultType := WACResponseRejected;
          ResponseCode     := xmlTagValue('<tgif:ErrorCode>',rString);
          ResponseText     := xmlTagValue('<tgif:EnglishMessageText xml:lang="en">', '</tgif:EnglishMessageText>',rString);
        end;
      end

      //SOAP Fault Error ----------------------------------------------------------------
      else if xmlTagExists('<faultcode>',rString) then
      begin
        WACResponseResultType := WACResponseWebServiceError;
        ResponseCode     := xmlTagValue('<faultcode>',rString);
        ResponseText     := xmlTagValue('<faultstring>',rString);
      end

      //something not accounted for
      else
      begin
        WACResponseResultType := WACResponseUnknownError;
        ResponseCode     := 'vtError';
        ResponseText     := 'Unknown response file format';
      end;



    end;

end;


procedure TWACRequestEfileT2_2027.testResponseClick(Sender: TObject);
var
    tempResponseList:tstringlist;
    AckResponseFlName,  WacResponseHTM, ResponseXmlFile:string;
    //T1135ResponseRec:T1135AckRec;
begin
 testResponseOpenDialog.FileName := '*Response*';
 //OpenDialog1.FileName := '';

 testResponseOpenDialog.InitialDir:= WACResponseEfileDir;
 testResponseOpenDialog.Filter := 'XML files (*.xml)|*.xml|'+
                                  'Any (*.*)|*.*';
 If testResponseOpenDialog.Execute then
 begin
   tempResponseList := TStringList.Create;
   tempResponseList.loadFromFile(testResponseOpenDialog.FileName);

   parseResponse(tempResponseList.text); //T1135ResponseRec := parseResponse(tempResponseList.text);

   PostResponseToFrm();

   WacResponseHTM := CreateEfileResponseHtm(RetNo);
   If FileExists(WacResponseHTM) then
    ShellExecute(Self.Handle, nil, PChar('' + WacResponseHTM), nil, nil, SW_NORMAL);

 end;
end;

procedure TWACRequestEfileT2_2027.PostResponseToFrm();
var FNo:integer;
begin
   With WACResponseRec do
   begin
     if WACResponseResultType = WACResponseSuccess then
     begin

//       FNo := GetFormNo('WACreq');
//       Ret[RetNo].Frm[FNo].Strings[10] := WACCode;

       FNo := GetFormNo('T2');
       Ret[RetNo].Frm[FNo].Strings[75] := WACCode;
     end
     else
     begin
       //Ret[RetNo].Frm[FNo].Strings[9]  := DateTimeReceived;
       //Ret[RetNo].Frm[FNo].Strings[--] := ResponseCode;
       //Ret[RetNo].Frm[FNo].Strings[--] := ResponseText;
     end;
   end;
end;



//20160124
Function TWACRequestEfileT2_2027.ConvertCheckBoxTo1(S:String):String;  //20160124
Begin
 Result:='0';//20160624
 If UpperCase(s)='X' then result:='1';
end;



Function TWACRequestEfileT2_2027.CreateSoapMessage(RetNo:Integer):String;
Const Format1='########0';  //20150221
Var
i,Elm,WacFNo:Integer; cd:String; //code
s,FlName:String;
DcnSeqNo:String;
begin

 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 setwebServiceUserNamePassword(webServiceUserName,webServicePassword);

 XmlList:=TstringList.Create;
 XmlList.Clear;

 With XmlList do
 Begin


   add('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif">');

   add('  <soapenv:Header>');
   add('        <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
   add('            <wsse:UsernameToken>');
   add('                <wsse:Username>'+ '' +'</wsse:Username>'); //supposed to leave blank?? //Mandatory   add('                <wsse:Username>'+ webServiceUserName +'</wsse:Username>'); //Mandatory
   add('                <wsse:Password>'+ '' +'</wsse:Password>'); //supposed to leave blank?? //Mandatory   add('                <wsse:Password>'+ webServicePassword +'</wsse:Password>'); //Mandatory
   add('            </wsse:UsernameToken>');
   add('        </wsse:Security>');
   add('   </soapenv:Header>');

   add('   <soapenv:Body>');
   add('      <tgif:getOnlineWac xmlns:tgift="http://www.cra-arc.gc.ca/xmlns/tgif/request/1-0-0">');
   add('	      <tgif:WacRequest>');
   add('	        <tgif:BusinessNumber>'+ wacR_BNnumber.Text +'</tgif:BusinessNumber>'); //Mandatory

   //Mandatory
   s:=wacR_TaxYearEnd.Text;
   add('	        <tgif:TaxationYearEndDate>'+ ReplaceChar(s,'/','-') +'</tgif:TaxationYearEndDate>');

   s:=wacR_TaxEndTime.Text;
   if s>'' then
     add('	        <tgif:TaxationYearEndTime>'+ s +'</tgif:TaxationYearEndTime>');

   s:=wacR_IncorporationDate.Text;
   add('          <tgif:IncorporationDate>'+ ReplaceChar(s,'/','-') +'</tgif:IncorporationDate>');

   add('	        <tgif:PostalZipCode>'+ wacR_Postal.Text +'</tgif:PostalZipCode>');
   add('	        <tgif:RequesterName>');
   add('		        <tgif:LastName>'+ ReplaceXMLChars(wacR_RequesterLastName.Text) +'</tgif:LastName>');
   add('		        <tgif:FirstName>'+ ReplaceXMLChars(wacR_RequesterFirstName.Text) +'</tgif:FirstName>');
   add('		        <tgif:Title>'+ ReplaceXMLChars(wacR_RequesterJobTitle.Text) +'</tgif:Title>');
   add('	        </tgif:RequesterName>');
   add('        </tgif:WacRequest>');
   add('      </tgif:getOnlineWac>');
   add('   </soapenv:Body>');

   add('</soapenv:Envelope>');

 End;

 //when testing, load from file xmlList.Clear; xmllist.LoadFromFile('C:\Users\Costas\Documents\SCHEMA\schema\T2\examplT1135_ORIGINALtoCHANGE.xml');

 //Now save the list to a file
 SoapMsg:='';
 For I:=0 to XmlList.count-1 do
  SoapMsg:=SoapMsg+XmlList[i]; //+Chr(13);

 flName := MkSubmittedFileName(RetNo);
 If FileExists(flName) then  DeleteFile(flName);
 XmlList.SaveToFile(flName);
 XmlList.Free;

 result := flName;
end;


Function TWACRequestEfileT2_2027.CreateEfileResponseHtm(RetNo: Integer{; AckRec: T1135AckRec; HtmFile: String}):String; //20160523 Igor
var
  htmlSource: TStringList;
  source, flName: string;
  OnLineNo, PassWord, Url, NetFileDir: String;
  s,keyWord,replacementString,fontColor:string;
  i, j, k, startPos, itemNumTemp: integer;
begin
  Result := '';
  //GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  htmlSource := TStringList.Create;

  htmlSource.add('<html><head><title>WAC Response - '+  WACResponseRec.Name +', '+ WACResponseRec.BNnumber +'</title></head>');

  if WACResponseRec.WACResponseResultType = WACResponseSuccess then //if WACResponseRec.PreValresultType = PreValSuccess then
  begin
    fontColor := 'green';
    s := 'Successful';
  end
  else
  begin
    fontColor := 'red';
    s := 'Failed';
  end;

  htmlSource.add('<h3>'+WACResponseRec.TxYear+'</h3>');

  htmlSource.add('<h4>');
  htmlSource.add(  WACResponseRec.Name); htmlSource.add(  '<br>');
  htmlSource.add(  WACResponseRec.BNnumber); htmlSource.add(  '<br>');
  htmlSource.add(  'Taxation Year End: ' + WACResponseRec.TxYearEndDate);
  if WACResponseRec.TxYearEndTime > '' then
    htmlSource.add(' - ' + WACResponseRec.TxYearEndTime);
  htmlSource.add('</h4>');

  htmlSource.add('<h2><font color="'+ fontColor +'"><strong>WAC request '+s+'</strong></font></h1>');


  if WACResponseRec.WACResponseResultType = WACResponseSuccess then //if WACResponseRec.PreValresultType <> PreValSuccess then
  begin
    htmlSource.add('<h4><strong>WAC Code: ' + WACResponseRec.WACcode + '</strong></h4>');
  end
  else
  begin
    //htmlSource.add('<br>');
    htmlSource.add('<h4>Error Code: ' + WACResponseRec.ResponseCode + '<br>');
    htmlSource.add('   Error Message: ' + WACResponseRec.ResponseText + '</h4>');
  end;


  htmlSource.add('<h4>Acknowledgement received: '+ WACResponseRec.DateTimeReceived +'</h4><br><hr>');

  htmlSource.add('</body></html>');


  //----------------------------------------------------------------

  flName := WACResponseEfileDir +'\'+ trim( GetCorpName(RetNo) )+ '-WACResponseEFileAck.htm';
  htmlSource.SaveToFile(flName);
  htmlSource.Free;

  result := flName;   //jz

end;

Function TWACRequestEfileT2_2027.ReplaceXMLChars(info: String): String;
Begin
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;');  //20160515 it is char(39)
  info := ReplaceChar(info, Chr(39), '&apos;');  //20161213
  result := info;
End;

//20180423
procedure TWACRequestEfileT2_2027.setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);
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
    GetEOLParms(OnlineNo, Password, Url, NetFileDir);
    webServiceUserName := OnlineNo;
    webServicePassword := Password;
  end;

end;





end.

