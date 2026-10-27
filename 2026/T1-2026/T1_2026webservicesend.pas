unit T1_2026webservicesend;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,FileCtrl,T1_2026TrimStr,T1_2026Declare,T1_2026Common,
  T1_2026Common2,Db,Grids,DBGrids,ShellApi,ComCtrls,ComObj,
  //T1_2026TLHelp32,
  Activex,ShlObj,T1_2026MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

 Const CrLf         =  Chr(13)+Chr(10);
 Const SoftVendor   =  '064F';

 Type TSendResultType = (SendAccepted,SendRejected,SendWebserviceError);
 Type TSendAckRec = Record
   Name                 : String;
   DateTimeReceived     : String;
   Response             : String;
   ResponseCode         : Array[1..8] of string;
   ResponseText         : Array[1..8] of string;
   additionalText       : String;
 end;




type
  TWebServiceSendT1_2026 = class(TForm)
    EfileType: TPanel;
    SubmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    TestOrProductionGroup: TRadioGroup;
    UrlBox: TEdit;
    Label7: TLabel;
    BitBtn3: TBitBtn;
    Label2: TLabel;
    Bevel1: TBevel;
    BitBtn5: TBitBtn;
    Label9: TLabel;
    FDConnection: TADConnection;
    Table1: TADTable;

    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);

    procedure GetUrlBox;
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);
    Function CreateSoapMessage:string;

    Procedure SubmitSoapMsg(SoapMsg:String;FlName:String);

    Function CreateSendResponseHtm(SendResponseRec:TSendAckRec;HtmTemplateFileName,ResponseXmlFileName:String):String;

    Function parseSendResponse(ResponseString:String):TSendAckRec;


    Function  MkSelectedStr: String;
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    RetNo: integer;
    OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
    NetFileDir:String;
    FormCnt:Integer;
    SendDir: String;
    sUrl:String;
  public
    { Public declarations }
  end;

var
  WebServiceSend: TWebServiceSendT1_2026;

implementation

uses
  vtCommon,
  T1_2026main,T1_2026childwinnew,
  vtTrimStr,vtShared;

{$R *.DFM}

procedure TWebServiceSendT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin

 SendDir:=AppDir+'\'+'send';
 If DirectoryExists(SendDir) = false then ForceDirectories(SendDir);
 FormCnt:=0;
 if TestOrProductionGroup.visible = true then
    TestOrProductionGroup.itemindex := 1;  //20130212

end;

procedure TWebServiceSendT1_2026.FormActivate(Sender: TObject);
begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120
  GetUrlBox;
  If (Length(OnlineNo)<>5) or (Password='') then
  begin
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT1.SetupEOL1Click(Sender);
   Exit;
  end;

  RetNo:=GetCurrentRetNo;
end;

Function TWebServiceSendT1_2026.CreateSoapMessage:string;
const
indent      = '';
indentI     = ' ';
indentII    = '  ';
indentIII   = '   ';
Var
i,j:Integer;
TempSoapList:TStringList;
FlName:String;
RetNo:Integer;
Sin,BirthDate,GivenName,Surname,SurnameChanged:string;
SoapMsg:string;
Begin
  RetNo:=GetCurrentRetNo;

  Sin               :=GetSinNo(RetNo);
  BirthDate         :=RemoveChar(FetchELm(RetNo,'T1',9),'-');
  GivenName         :=GetFirstName(RetNo);
  Surname           :=GetLastName(RetNo);
  SurnameChanged    := 'N';
  if FetchELm(RetNo,'T1',56) > '' then
    SurnameChanged    := 'Y';

  TempSoapList:=TStringList.Create;

  With TempSoaplist do
  begin
   add(indent+'<?xml version="1.0"?>');
   add(indent+'<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">');
   add(indent+'<soap-env:Header>');
   add(indentI+'<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
   add(indentII+'<wsse:UsernameToken>');
   add(indentIII+'<wsse:Username>'+OnLineNo+'</wsse:Username>');
   add(indentIII+'<wsse:Password>'+PassWord+'</wsse:Password>');
   add(indentII+'</wsse:UsernameToken>');
   add(indentI+'</wsse:Security>');
   add(indent+'</soap-env:Header>');
   add(indent+'<soap-env:Body>');
   add(indentI+'<efes:Request xmlns:efes="http://ccra.gc.ca/efes"');
   add(indentI+'xmlns:xsi="http://www.w3.org/2001/XMLSchema" xsi:type="efes:Request">');
   add(indentII+'<type>SEND</type>');
   add(indentII+'<sin>'+Sin+'</sin>');
   add(indentII+'<dob>'+BirthDate+'</dob>');
   add(indentII+'<fname>'+GivenName+'</fname>');
   add(indentII+'<lname>'+Surname+'</lname>');
   add(indentII+'<nameChangeInd>'+SurnameChanged+'</nameChangeInd>');
   add(indentI+'</efes:Request>');
   add(indent+'</soap-env:Body>');
   add(indent+'</soap-env:Envelope>');
  end;

  SoapMsg:='';
  For I:=0 to TempSoapList.count-1 do SoapMsg:=SoapMsg+TempSoapList[i]+Chr(13);

  If FileExists(MkSubmittedFileName(RetNo)) then  DeleteFile(MkSubmittedFileName(RetNo));

  TempSoapList.SaveToFile(MkSubmittedFileName(RetNo));
  TempSoapList.Free;

  result := SoapMsg;
End;

procedure TWebServiceSendT1_2026.SubmitBtnClick(Sender: TObject);
Var
    RetNo:Integer;
    SoapMsg:string;
begin

 SoapMsg := CreateSoapMessage;

 If SoapMsg='' then
 Begin
  ShowMessage('No data available for submission');
  Exit;
 end;

 SubmitSoapMsg(SoapMsg,MkSubmittedFileName(RetNo));
end;

Procedure TWebServiceSendT1_2026.SubmitSoapMsg(SoapMsg:String;FlName:String);
Var
 i:Integer;
 WString:String;  //wide string
 objHttp:ixmlHttpRequest;
 Status: String;
 TempSoapList:TStringList;
 TempDataList:TStringList;
 h:THandle;
 s:String;
 AList:TstringList;
 DOMDocument:IXMLDOMDocument; TrackNodes: IXMLDOMNodeList;  //20110129
 ResponseXmlFile:String;
 ConfirmationNumber:String;
 SendResponseRec:TSendAckRec;
 SendResponseHTM:string;
Begin

 //define
 ObjHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
 //open it
 ObjHTTP.open('POST', sURL, False, OnlineNo,Password);   //20110120

 ObjHTTP.setRequestHeader('SOAPAction', 'NA'); //set action?
 objHTTP.setRequestHeader('Content-Type','text/xml');

 //transmit it now
 Screen.Cursor := crHourGlass;
 ObjHTTP.send(SoapMsg);
 Screen.Cursor := crDefault;
 delay(2000);
 Screen.Cursor := crDefault;
 WString:=objHttp.ResponseText;

 ResponseXmlFile:= MkResponseFileName(RetNo);

 //Now save the WString
 AList:=TStringList.Create;
 AList.Add(WString);
 AList.SaveToFile(ResponseXmlFile);
 AList.Free;

 SendResponseRec := parseSendResponse(WString);

 SendResponseRec.Name := GetLastName(RetNo) + ', ' + GetFirstName(RetNo);

 SendResponseHTM := CreateSendResponseHtm(SendResponseRec,AppDir+'\'+'SendWSResponse.htm',ResponseXmlFile);

 h := ShellExecute({MainForm.}Handle,'open',Pchar(''+SendResponseHTM),Nil,Nil,Sw_Show);
 If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');

 //succesful transmission
 s:=MkSubmittedFileName(RetNo);
 If FileExists(s) then RenameFile(s,ReplaceStr(S, 'ToBeSubmitted', 'Submitted')); //rename it
 objHttp:=Nil;  //20110129  .Free It is not accepted

end;

Function TWebServiceSendT1_2026.MkSelectedStr: String;
Const
 PartNameLen = 14;
Var
 S : string[80];
begin
    Result :=
     LeftStr(Table1.FieldByName('Last_Name').AsString,PartNameLen)
     + ' ' +LeftStr(Table1.FieldByName('First_Name').AsString,1)
     + '.'
     + FilledStr(
       PartNameLen+3-Length(LeftStr(Table1.FieldByName('Last_Name').AsString,PartNameLen))
       + 1 + Length(LeftStr(Table1.FieldByName('First_Name').AsString,1))+1
       ,' ')
     + '\'+Table1.FieldByName('File_Name').AsString
end;

Function TWebServiceSendT1_2026.MkSubmittedFileName(RetNo:Integer):String;
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
  result:=SendDir+'\'+'Send-ToBeSubmitted-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'
end;

Function TWebServiceSendT1_2026.MkResponseFileName(RetNo:Integer):String;
begin
  result:=SendDir+'\'+'Send-Response-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'
end;

procedure TWebServiceSendT1_2026.GetUrlBox;
begin

 If TestOrProductionGroup.ItemIndex=0 then  //production
   sUrl := 'https://apps.cra-arc.gc.ca/ebci/efes/efws/services/EOLPlusWebService?wsdl'
  else //test
   sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/efes/efws/services/EOLPlusWebService?wsdl';

  UrlBox.Text := SUrl;

end;

procedure TWebServiceSendT1_2026.TestOrProductionGroupClick(Sender: TObject);
begin
GetUrlBox;
end;

procedure TWebServiceSendT1_2026.BitBtn3Click(Sender: TObject);
begin
 //MainForm.T1013EfileErrors1Click(Sender);
end;

procedure TWebServiceSendT1_2026.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;


Function TWebServiceSendT1_2026.parseSendResponse(ResponseString:String):TSendAckRec;
Var
    j,k,sPos,sLength,ePos:Integer;
    TempList:TStringList;
    s,e, fontRedColor, fontGreenColor, fontEnd:string;
    SendResponseRec:TSendAckRec;
Begin
  fontRedColor      := '<font color="#990000">';
  fontGreenColor    := '<font color="#009900">';
  fontEnd           := '</font>';

  SendResponseRec.DateTimeReceived := FormatDateTime('yyyy-mm-dd',Date)+ '  '+GetTimeToMilliSec(Date);

  //check if web server error ------------------------------------------------------------------------------------
  s         := '<faultcode>';
  sPos      := Pos(s,ResponseString);
  If sPos>0 then
  begin
        s := '<faultcode>';     sLength := Length(s);   sPos := Pos(s,ResponseString) + sLength;
        e := '</faultcode>';                            ePos := Pos(e,ResponseString);
        SendResponseRec.ResponseCode[1]   := MidStr(ResponseString,sPos,ePos-sPos);

        s := '<faultstring>';   sLength := Length(s);   sPos    := Pos(s,ResponseString) + sLength;
        e := '</faultstring>';                          ePos    := Pos(e,ResponseString);
        SendResponseRec.ResponseText[1]   := MidStr(ResponseString,sPos,ePos-sPos);

        SendResponseRec.Response       := fontRedColor+'Server Error'+ fontEnd;
        SendResponseRec.additionalText := 'Check with CRA to see if Efile is down.'; //20170126 //20160307 //20160505 Igor
        //SendResponseRec.additionalText := 'Check with CRA to see if Efile is down. If not, contact VisualTax.';  //20160307 //20160505 Igor
        //SendResponseRec.SendresultType:= T1013webServiceError;

        result := SendResponseRec;

        exit;

  end;

  //other kind of error????
  s         := '<response xsi:type="xsd:string">';
  sPos      := Pos(s,ResponseString);
  If sPos>0 then
  begin
        s := '<response xsi:type="xsd:string">';        sLength := Length(s);   sPos := Pos(s,ResponseString) + sLength;
        e := '</response>';                             ePos := Pos(e,ResponseString);
        SendResponseRec.ResponseCode[1]   := MidStr(ResponseString,sPos,ePos-sPos);

        SendResponseRec.Response       := fontRedColor+'Server Error'+ fontEnd;
        SendResponseRec.additionalText := 'Check with CRA to see if Efile is down.'; //20170126 //20160307 //20160505 Igor
        //SendResponseRec.additionalText := 'Check with CRA to see if Efile is down. If not, contact VisualTax.'; //20160307 //20160505 Igor
        //SendResponseRec.SendresultType:= T1013webServiceError;

        result := SendResponseRec;

        exit;

  end;

  //no server error, assume response
  //get response code
  SendResponseRec.Response       := '';
  for j := 1 to 8 do
  begin
    s := '<sendErrorClue'+inttostr(j)+' xsi:type="xsd:string">';  sLength := Length(s);           sPos := Pos(s,ResponseString) + sLength;
    e := '</sendErrorClue'+inttostr(j)+'>';                       ePos := Pos(e,ResponseString);
    if sPos - sLength > 0 then
    begin
        SendResponseRec.ResponseCode[j]   := MidStr(ResponseString,sPos,ePos-sPos);
    end;
  end;

  //get response text
  for j := 1 to 8 do
  begin
    s := '<sendMessage'+inttostr(j)+' xsi:type="xsd:string">';  sLength := Length(s);           sPos := Pos(s,ResponseString) + sLength;
    e := '</sendMessage'+inttostr(j)+'>';                       ePos := Pos(e,ResponseString);
    if sPos - sLength > 0 then
    begin
        SendResponseRec.ResponseText[j]   := MidStr(ResponseString,sPos,ePos-sPos);
    end;
  end;

  result := SendResponseRec;

end;

{
Function TWebServiceSend.GetT1013ErrorDescr(ErrorCode:String):String;  //20140119
Var Tbl:TADTable;
begin
 Result:='';
 tbl:=TTable.Create(Application);
 Tbl.DataBaseName := AppDir;
 Tbl.TableName := T1013Errors.DB;
 Tbl.IndexName := 'Code';
 Tbl.Open;
 if Tbl.FindKey([ErrorCode]) = True then
  begin Result := Tbl.FieldByName('Descr').AsString;end
 Else
  begin end; // ShowMessage('See the Web Services Error Messages document Under EfileOnline');
 Tbl.Free;
end;
}

Function TWebServiceSendT1_2026.CreateSendResponseHtm(SendResponseRec:TSendAckRec;HtmTemplateFileName,ResponseXmlFileName:String):String;
var
 htmlSource:TStringList;
 sString,source,flName:string;
 OnLineNo,PassWord,Url,NetFileDir:String;
 i,j,k,s,startPos,itemNumTemp:integer;
begin
 htmlSource:=TStringList.Create;
 htmlSource.LoadFromFile(HtmTemplateFileName);

 For i := 0 to htmlSource.Count-1 do
 begin
  sString := '!Client!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, SendResponseRec.Name,[rfReplaceAll, rfIgnoreCase]);


  sString := '!Response!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, SendResponseRec.Response,[rfReplaceAll, rfIgnoreCase]);

  sString := '!DateTime!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, SendResponseRec.DateTimeReceived,[rfReplaceAll, rfIgnoreCase]);

  for j := 1 to 8 do
  begin
    sString := '!ResponseCode'+inttostr(j)+'!';
    startPos := pos(sString, htmlSource[i]);
    if  startPos > 0 then
        htmlSource[i] := StringReplace(htmlSource[i], sString, SendResponseRec.ResponseCode[j],[rfReplaceAll, rfIgnoreCase]);

    sString := '!ResponseText'+inttostr(j)+'!';
    startPos := pos(sString, htmlSource[i]);
    if  startPos > 0 then
        htmlSource[i] := StringReplace(htmlSource[i], sString, SendResponseRec.ResponseText[j],[rfReplaceAll, rfIgnoreCase]);
  end;

  sString := '!additionalText!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, SendResponseRec.additionalText,[rfReplaceAll, rfIgnoreCase]);

 end;

 flName := ChangeFileExt(ResponseXmlFileName, '.htm');
 htmlSource.SaveToFile(flName);

 htmlSource.Free;

 result := flName;
end;


procedure TWebServiceSendT1_2026.CancelBtnClick(Sender: TObject);
begin
    close;
end;

end.
