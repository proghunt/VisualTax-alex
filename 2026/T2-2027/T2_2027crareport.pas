unit T2_2027crareport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl, System.StrUtils,
  T2_2027TrimStr, T2_2027Declare, T2_2027Common, T2_2027Common2, Db, DBTables, Grids, DBGrids,   //20150120 Igor
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  //MSSOAPLib30_TLB,     //does not seem to be needed for sending receiving  //20110129 it has dom
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Vcl.Mask, Vcl.DBCtrls, Vcl.DBCGrids, //20110129  NEEDED for connection and the response handler
  IdSSLOpenSSLHeaders; //20200804 Igor

  //20160215
 Const SOFTRELEASEYEAR   = '2023';  //20110120
 Const SOFTRELEASEMONTH  = '12'; //'10';  //20240321
 Const SOFTRELEASEDAY    = '31';
 Const CrLf         =  Chr(13)+Chr(10);
 //Const SoftwareId='VT33';    //20160613
//Const SoftVendor   =  '064K'; //20160606  N/A to T2


 type
 TT106resultType = (T106accepted,T106rejected,T106Delayed,T106webserviceError);  //20160523 Igor
 T106AckRec = Record  //20160523 Igor
   Name                 : String;
   BNnumber             : String;
   TxYear               : String;
   DateTimeReceived     : String;
   TransmitterID        : String;
   ConfirmationID       : String;
   Response             : String;
   ResponseCode         : String;
   ResponseText         : ansiString;
   additionalText       : ansiString;
   T106resultType       : TT106resultType;
 end;


type
  TTCRAReport = class(TForm)
    SubmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ShowBtn: TBitBtn;
    DataSource1: TDataSource;
    TestOrProductionGroup: TRadioGroup;
    Label2: TLabel;
    BitBtn4: TBitBtn;
    Bevel1: TBevel;
    BitBtn5: TBitBtn;
    Label9: TLabel;
    OpenDialog1: TOpenDialog;
    testResponse: TBitBtn;
    Table1: TADTable;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    SmallintField1: TSmallintField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    StringField13: TStringField;
    StringField14: TStringField;
    StringField15: TStringField;
    StringField16: TStringField;
    StringField17: TStringField;
    StringField18: TStringField;
    StringField19: TStringField;
    StringField20: TStringField;
    StringField21: TStringField;
    StringField22: TStringField;
    StringField23: TStringField;
    StringField24: TStringField;
    StringField25: TStringField;
    StringField26: TStringField;
    StringField27: TStringField;
    StringField28: TStringField;
    StringField29: TStringField;
    StringField30: TStringField;
    StringField31: TStringField;
    StringField32: TStringField;
    StringField33: TStringField;
    StringField34: TStringField;
    StringField35: TStringField;
    StringField36: TStringField;
    StringField37: TStringField;
    StringField38: TStringField;
    StringField39: TStringField;
    StringField40: TStringField;
    StringField41: TStringField;
    StringField42: TStringField;
    StringField43: TStringField;
    FloatField1: TFloatField;
    StringField44: TStringField;
    StringField45: TStringField;
    FloatField2: TFloatField;
    StringField46: TStringField;
    StringField47: TStringField;
    StringField48: TStringField;
    StringField49: TStringField;
    StringField50: TStringField;
    StringField51: TStringField;
    StringField52: TStringField;
    StringField53: TStringField;
    StringField54: TStringField;
    StringField55: TStringField;
    FDConnection: TADConnection;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdHTTP1: TIdHTTP;
    btnSelectDoc: TButton;
    dbcgMain: TDBCtrlGrid;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBEdit1: TDBEdit;
    mtMain: TADMemTable;
    mtMainDesc: TStringField;
    dsMain: TDataSource;
    DBNavigator1: TDBNavigator;
    pnlSelectFile: TPanel;
    mtMainfilepath: TStringField;
    mtMaindocid: TStringField;
    mtMaindocname: TStringField;
    mtMaindoccomment: TStringField;
    pnlSelectType: TPanel;
    lblFile: TLabel;
    lblFileType: TLabel;
    lblFileDesc: TLabel;


    Function ReplaceXMLChars(info: String): String;  //20161213
    Function ConvertCheckBoxTo1(S:String):String;  //20160124
    Function  GetDcnSeqNoForT106(RetNo:Integer;OnLineNo:String):String; //20150305
    procedure CreateT106SoapMessage(RetNo:Integer);
    procedure GetUrlBox;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    Procedure SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);

    Function parseT106Response(rString:AnsiString):T106AckRec;
    Function CreateT106EfileResponseHtm(RetNo: Integer; AckRec: T106AckRec; HtmFile: String):String;
    procedure FormActivate(Sender: TObject);
    Function  MkSelectedStr: String;
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
    procedure pnlSelectFileClick(Sender: TObject);
    procedure pnlSelectTypeClick(Sender: TObject);
  private
    { Private declarations }
    RetNo:Integer;   //20160120 Igor
    FSLDocTypeList: TStringList;
    FInsurancecorporations: boolean;
  public
    { Public declarations }
  end;

var
  T106Efile: TTCRAReport;
  SoapMsg:AnsiString;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
  NetFileDir:String;
  FormCnt:Integer;
  T106EfileDir: String;
  sUrl:String;
  Indent1, Indent2,Indent3,Indent4,Indent5,Indent6,Indent7, Indent8,Indent9,Indent10,Indent11:Integer;

   //AckRec:TAckRec;
  AckRecT106:T106AckRec;

implementation

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T2_2027, T2_2027main,
  vtShared, vtDynData, IdMultipartFormData, IdGlobalProtocols, IdCoderMIME,
  vtDialogs;

{$R *.DFM}

type
  TDocumentRow = array [0..2] of string;
  TArrDocumentRow = array of TDocumentRow;
var
  DocumentsDatasTable1: TArrDocumentRow;
  DocumentsDatasTable2: TArrDocumentRow;
  DocumentsDatasTable3: TArrDocumentRow;

procedure setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);
var
  wacNumber: String;
begin
  // 20130527
  wacNumber := GetWACNumber(GetCurrentRetNo);
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

procedure TTCRAReport.FormCreate(Sender: TObject);
procedure LoadArr(var aArr: TArrDocumentRow; aFileName: string);
var
  SL:TStringList;
  i: integer;
  val1, val2, val3: string;
begin
 SL := TStringList.Create;
 try
   SL.LoadFromFile(aFileName);
   for I := 0 to SL.Count - 1 do begin
     val1 := Trim(Copy(SL[i], 1, 106));
     val2 := Trim(Copy(SL[i], 107, 15));
     val3 := Trim(Copy(SL[i], 123, Length(SL[i])));
     if (val1 <> '') and (val2 <> '') then
     begin
       SetLength(aArr, Length(aArr) + 1);
       aArr[Length(aArr) -1][0] := val1;
       aArr[Length(aArr) -1][1] := val3;
       aArr[Length(aArr) -1][2] := val2;
     end;
   end;
 finally
   SL.Free;
 end;
end;
Var
  TempList:TStringList;
  i: integer;
  corp, val1, val2, val3: string;
begin
 IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));//20200804 Igor
 FSLDocTypeList := TStringList.Create;
 // load *tbl.d
 LoadArr(DocumentsDatasTable1, AppDir+'\'+'attachadoctbl1.d');
 LoadArr(DocumentsDatasTable2, AppDir+'\'+'attachadoctbl2.d');
 LoadArr(DocumentsDatasTable3, AppDir+'\'+'attachadoctbl3.d');

 T106EfileDir:=AppDir+'\'+'T106Efile';
 If DirectoryExists(T106EfileDir) = false then ForceDirectories(T106EfileDir);
 //if TestOrProductionGroup.visible = true then TestOrProductionGroup.itemindex := 1;  //20130212
 RetNo:=GetCurrentRetNo;
 If RetNo>0 then
 begin
   If ValidForT106Efile(RetNo,GetFormNo('T106')) = false then  //20170629
   Begin  SoapMsg:='';  Exit; End;
 end;
 CreateT106SoapMessage(RetNo);
 TempList := TStringList.Create;
 try
   TempList.Add('Insurance corporations');
   TempList.Add('Non-Insurance corporations');
   corp := PopSomeList(TempList, 'Select type your corporations');
   FInsurancecorporations := corp <> 'Non-Insurance corporations';
   if FInsurancecorporations then
     for I := 0 to Length(DocumentsDatasTable1) - 1 do
       FSLDocTypeList.Add(DocumentsDatasTable1[i][0])
   else
     for I := 0 to Length(DocumentsDatasTable2) - 1 do
       FSLDocTypeList.Add(DocumentsDatasTable2[i][0]);

   for I := 0 to Length(DocumentsDatasTable3) - 1 do
     FSLDocTypeList.Add(DocumentsDatasTable3[i][0]);
 finally
   TempList.Free;
 end;
end;

procedure TTCRAReport.SubmitBtnClick(Sender: TObject);
Var RetNo:Integer;FlName:String;
 SendStream:TStringStream;
 sMimeType      : String;
 XMLTEXT, sAttach:string;
 objHttp: ixmlHttpRequest;
 i: integer;
 xml: IXMLDOMDocument;
 node: IXMLDomNode;
 errormsg: string;
 sURL: String;
begin
  setwebServiceUserNamePassword(OnlineNo,Password);


 XMLTEXT := '--example-boundary'+#13#10+
            'Content-Type: application/xop+xml; charset=UTF-8'#13#10+
            'Content-Transfer-Encoding: 8bit'#13#10+
            'Content-ID: <xml>'+#13#10 +#13#10+
      '<?xml version="1.0" encoding="ISO-8859-1"?>'+#13#10 +
      '<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">'+#13#10 +
      '    <soap-env:Header>'+#13#10 +
      '        <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+#13#10 +
      '            <wsse:UsernameToken>'+#13#10 +
      '                <wsse:Username>'+OnlineNo+'</wsse:Username>'+#13#10 +
      '                <wsse:Password>'+Password+'</wsse:Password>'+#13#10 +
      '            </wsse:UsernameToken>'+#13#10 +
      '        </wsse:Security>'+#13#10 +
      '    </soap-env:Header>'+#13#10 +
      '    <soap-env:Body>'+#13#10 +
      '        <tgif:attachFiles xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif">'+#13#10 +
      '            <tgif:AttachFilesRequest>'+#13#10 +
      '                <tgif:BusinessNumber>'+FetchElm(GetCurrentRetNo, 'T2', 1)+'</tgif:BusinessNumber>'+#13#10 +
      '                <tgif:TaxationYearEndDate>'+FetchElm(GetCurrentRetNo, 'T2', 11)+'</tgif:TaxationYearEndDate>'+#13#10 +
      '                <tgif:TaxationYearEndTime>'+FetchElm(GetCurrentRetNo, 'T2', 207)+'</tgif:TaxationYearEndTime>'+#13#10 +
      '                <tgif:SoftwareID>'+RSIApprovalCode+'</tgif:SoftwareID>'+#13#10 +
      '                <tgif:ConfirmationNumber>'+GetEFileConfirmationNo(GetCurrentRetNo)+'</tgif:ConfirmationNumber>'+#13#10;
   mtMain.Post;
   mtMain.Edit;
   mtMain.First;
   while not mtMain.Eof do begin
     if (mtMain.FieldByName('filepath').AsString <> '') and FileExists(mtMain.FieldByName('filepath').AsString) then
     begin
       XMLTEXT := XMLTEXT +
        '                <tgif:DocumentDefinition>'+#13#10+
        '                    <tgif:DocumentName>' + ExtractFileName(mtMain.FieldByName('filepath').AsString) + '</tgif:DocumentName >'+#13#10+
        '                    <tgif:DocumentDescription>' + mtMain.FieldByName('Desc').AsString + '</tgif:DocumentDescription >'+#13#10+
        '                    <tgif:DocumentID>' + mtMain.FieldByName('docid').AsString + '</tgif:DocumentID >'+#13#10+
        '                </tgif:DocumentDefinition>'+#13#10;
     end;
     mtMain.Next;
   end;
 XMLTEXT := XMLTEXT +
      '            </tgif:AttachFilesRequest>'+#13#10+
      '        </tgif:attachFiles>'+#13#10+
      '    </soap-env:Body>'+#13#10+
      '</soap-env:Envelope>'+#13#10;
 SendStream :=TStringStream.Create(XMLTEXT);
 try
   mtMain.First;
   while not mtMain.Eof do begin
     if (mtMain.FieldByName('filepath').AsString <> '') and FileExists(mtMain.FieldByName('filepath').AsString) then
     begin
      SendStream.Clear;
      SendStream.LoadFromFile(mtMain.FieldByName('filepath').AsString);
      sAttach := TIdEncoderMime.EncodeStream(SendStream);
      XMLTEXT := XMLTEXT +
        '--example-boundary'   +#13#10+#13#10 +
        'Content-Type: application/octet-stream'+#13#10+
        'Content-Transfer-Encoding: 8bit'#13#10+
        'Content-Disposition: filename="' + ExtractFileName(mtMain.FieldByName('filepath').AsString) + '"'+#13#10+
        sAttach+#13#10+#13#10;
     end;
     mtMain.Next;
   end;
 XMLTEXT := XMLTEXT + '--example-boundary--';
 SendStream.Clear;
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  if TestOrProductionGroup.ItemIndex = 1 then
    sURL := 'https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl'
    // t2 testing
  else
    sURL := 'https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';


  objHttp.open('POST', sURL, False, '', ''); // 20110120

  objHttp.setRequestHeader('SOAPAction', 'https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService/AttachFilesRequest'); // set action?
  objHttp.setRequestHeader('Content-Type', 'Multipart/Related; boundary=example-boundary; start="<xml>"');
  objHttp.setRequestHeader('Content-Length', IntToStr(Length(XMLTEXT)*SizeOf(Char)));
  objHttp.send(XMLTEXT); // SEND SOAP MESSAGE
  finally
     SendStream.Free;
  end;
  xml := CreateOleObject('Microsoft.XMLDOM') as IXMLDOMDocument;
  xml.async := False;
  xml.loadXML(objHttp.ResponseText);
  if xml.parseError.errorCode <> 0 then
    raise Exception.Create('XML Load error:' + xml.parseError.reason);
  node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError');
  if assigned(node) then begin
    errormsg := '';
    node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError/tgif:ErrorMessage/tgif:ErrorCode');
    if Assigned(node) then
      errormsg := errormsg + 'Error code: ' + node.text + #13#10;
    node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError/tgif:ErrorMessage/tgif:EnglishMessageText');
    if Assigned(node) then
      errormsg := errormsg + 'English error text: ' + node.text + #13#10;
    node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError/tgif:ErrorMessage/tgif:FrenchMessageText');
    if Assigned(node) then
      errormsg := errormsg + 'French error text: ' + node.text + #13#10;
    ShowMessage(errormsg);
  end else
    showmessage('All ok');
  exit;
If ValidPostal(RetNo,OptRec.Prp_Postal) = false then
 begin
  ShowMessage('Please fix the Postal code in Configure -> General Options -> Preparer');
  Exit;
 end;
  //20150207
 RetNo:=GetCurrentRetNo;
 // ????????????????
 (*
 If FetchElm(RetNo,'T1135',39)>'' then  //has confirmation
 Begin
  If FetchElm(RetNo,'T1135',22)='' then //amended = false
  Begin
   ShowMessage('This T1135 has been already Efiled and it has a Confirmation number.'
   +Chr(13)+'Unless you check the Amended box');
  Exit;
  end;
 end;
 *)
// FlName:=MkSubmittedFileName(RetNo);
 CreateT106SoapMessage(RetNo);
 //  --------------
 If SoapMsg='' then
 Begin
  ShowMessage('No data available for submission');
  Exit;
 end;
// SubmitSoapMsg(SoapMsg,MkSubmittedFileName(RetNo));
end;


Procedure TTCRAReport.SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
Var
 i:Integer;
 WString:AnsiString;  //wide string
 objHttp:ixmlHttpRequest;
 Status: String;
 T106Msg:AnsiString;
 TempSoapList:TStringList;
 TempDataList:TStringList;
 h:THandle;
 s:String;
 AList:TstringList;
 DOMDocument:IXMLDOMDocument; TrackNodes: IXMLDOMNodeList;  //20110129
 ResponseXmlFile:String;
 ConfirmationNumber:String;
 T106ResponseRec:T106AckRec;
 T106ResponseHTM:string;
Begin


 //jz
 With AckRecT106 do //initialize to blank
 Begin

   Name                 := '';
   DateTimeReceived     := '';
   TransmitterID        := '';
   ConfirmationID       := '';
   Response             := '';
   ResponseCode         := '';
   ResponseText         := '';
   additionalText       := '';
   T106resultType      := T106accepted;
 End;

 //define
  ObjHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
 //open it
 ObjHTTP.open('POST', sURL, False, OnlineNo, Password);   //20110120

 ObjHTTP.setRequestHeader('SOAPAction', 'NA'); //set action?
 objHTTP.setRequestHeader('Content-Type','text/xml; charset=UTF-8'); //added encoding //20150206
 //ShowHTTPStatus(ObjHTTP.ReadyState);
 //transmit it now
 Screen.Cursor := crHourGlass;

// memo1.lines.add('https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl');
// memo1.lines.add(sURL);

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

 //h := ShellExecute(MainForm.Handle,'open',Pchar(''+ResponseXmlFile),Nil,Nil,Sw_Show);

 objHttp:=Nil;  //20110129  .Free It is not accepted

end;


procedure TTCRAReport.FormActivate(Sender: TObject);
begin
  setwebServiceUserNamePassword(OnlineNo,Password);
  If (OnlineNo='') then
  begin
   SoapMsg:='';
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT2.SetupEOLInternetFiling1Click(Sender);
   Exit;
  end;

  RetNo:=GetCurrentRetNo;
end;

Function TTCRAReport.MkSelectedStr: String;
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

procedure TTCRAReport.pnlSelectFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute(Application.Handle) then
  begin
    mtMain.Edit;
    mtMain.FieldByName('filepath').AsString := OpenDialog1.FileName;
  end;
end;

procedure TTCRAReport.pnlSelectTypeClick(Sender: TObject);
var
  docname: string;
  i: integer;
begin
  docname := PopSomeList(FSLDocTypeList, 'Select doc type');
  if FInsurancecorporations then
  begin
  for I := 0 to Length(DocumentsDatasTable1) - 1 do
    if DocumentsDatasTable1[i][0] = docname then begin
      mtMain.Edit;
      mtMain.FieldByName('docid').AsString := DocumentsDatasTable1[i][2];
      mtMain.FieldByName('doccomment').AsString := 'Doc Type: ' + DocumentsDatasTable1[i][0] + #13#10 + IfThen(DocumentsDatasTable1[i][1] <> '', 'Doc Comment: ' + DocumentsDatasTable1[i][1], '');
      Exit;
    end;
  end else
  begin
    for I := 0 to Length(DocumentsDatasTable2) - 1 do
      if DocumentsDatasTable2[i][0] = docname then begin
        mtMain.Edit;
        mtMain.FieldByName('docid').AsString := DocumentsDatasTable2[i][2];
        mtMain.FieldByName('doccomment').AsString := 'Doc Type: ' + DocumentsDatasTable2[i][0] + #13#10 + IfThen(DocumentsDatasTable2[i][1] <> '', 'Doc Comment: ' + DocumentsDatasTable2[i][1], '');
        Exit;
      end;
  end;
  for I := 0 to Length(DocumentsDatasTable3) - 1 do
    if DocumentsDatasTable3[i][0] = docname then begin
      mtMain.Edit;
      mtMain.FieldByName('docid').AsString := DocumentsDatasTable3[i][2];
      mtMain.FieldByName('doccomment').AsString := 'Doc Type: ' + DocumentsDatasTable3[i][0] + #13#10 + IfThen(DocumentsDatasTable3[i][1] <> '', 'Doc Comment: ' + DocumentsDatasTable3[i][1], '');
      Exit;
    end;
end;

Function TTCRAReport.MkResponseFileName(RetNo:Integer):String;
begin
 result:=T106EfileDir+'\'+'T106-Response-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml';  //20160526
end;

procedure TTCRAReport.GetUrlBox;
begin
 //20150102
 If TestOrProductionGroup.ItemIndex=0 then  //production
   //????sUrl :='https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'
 else  //test
   sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';
   //     'https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'

end;

procedure TTCRAReport.TestOrProductionGroupClick(Sender: TObject);
begin
  GetUrlBox;
end;

procedure TTCRAReport.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;

procedure TTCRAReport.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

Function TTCRAReport.parseT106Response(rString:AnsiString):T106AckRec;

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



var
    i,k,sPos,ePos,FNo : integer;
    s,e,fCode,fString,messageString,idstring,TimeReceived,tempString : String;
    ReturnedTransmissionID,ReturnedEfilerNumber,ReturnedControlNumber:String;

    ReturnedCorpName,ReturnedBnNumber,ReturnedTaxYr:string;

begin

   // idstring := RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.') + chr(10) + chr(13) + GetSinNo(RetNo);  //20160526  ??? not used...

    AckRecT106.T106resultType   := T106rejected;

    //server error -------------------------------------------------------------
    s     := '<faultcode>';
    sPos := pos(s,rString);
    IF sPos > 0 then
    BEGIN
        e     := '</faultcode>';
        sPos  := pos(s,rString) + length(s);
        ePos  := pos(e,rString);
        fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        s       := '<faultstring>';
        e       := '</faultstring>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        AckRecResultDescription := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                                   //+ chr(10) + chr(13) +  chr(10) + chr(13) + 'Please contact VisualTax';

        //messageString := 'Submission Failed' + chr(10) + chr(13) +  chr(10) + chr(13) + 'Error Code: ' + fCode + chr(10) + chr(13) + fString;
        //MessageDlg(messageString,mtError,[mbOK],0);
        //result := idstring + messageString + chr(10) + chr(13);

        AckRecT106.T106resultType := T106webserviceError; //jz
        //exit;
    END
{
    ELSE IF pos('SystemError',rString) > 0 then
    BEGIN
        //AckRec.EFresultType := EFwebServiceError;
        AckRecT106.T106resultType := T106webserviceError; //jz
        s       := '<t1rsp:MessageText xml:lang="en">';
        e       := '</t1rsp:MessageText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        fString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
    END
}
    ELSE
    BEGIN

        //Get result code ------------------------------------------------------------------
        s := '<t2ersp:T2ResultCode>';
        sPos := pos(s,rString);
        if sPos > 0 then
        begin
                e     := '</t2ersp:T2ResultCode>';
                sPos  := pos(s,rString) + length(s);
                ePos  := pos(e,rString);
                fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                //AckRecT106.ResponseCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));


                //Get Transmission Number (filename/confirmation number) if exists
                // ------------------------------------------------------------------
                s := '<t2ersp:T2TransmissionNumber>';
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:T2TransmissionNumber>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedTransmissionID := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT106.TransmitterID := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                s := '<t2ersp:CorporationName>';
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:CorporationName>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedCorpName := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT106.Name := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                s := '<t2ersp:BusinessNumber>';
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:BusinessNumber>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedBnNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT106.BnNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                s := '<t2ersp:TaxYear>';
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:TaxYear>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedTaxYr := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT106.TxYear:= AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                //get message is still t1rsp: even though for t2 jz???
                tempString:='';
                AckRecResultDescription := '';
                s     := '<t1rsp:MessageText xml:lang="en">';
                e     := '</t1rsp:MessageText>';
                sPos  := pos(s,rString) + length(s);
                ePos  := pos(e,rString);
                AckRecResultDescription := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                //AckRecT106.ResponseText := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

                //tempString := tempString + chr(13) + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));//showmessage(tempString);


                //same success codes jz???
                //success ------------------------------------------------------------------
                if (fCode = '480') or (fCode = '481') or (fCode = '180') or (fCode = '182') then  //20150416 added code 481
                begin
                        messageString :=    'Result Code: ' + fCode + chr(10) + chr(13) +
                                                'Efile Submitted Successfully';
                        messageString :=    messageString + chr(10) + chr(13) +
                                                'Transmission Number: ' + ReturnedTransmissionID +  chr(10) + chr(13) +
                                                'Efiler Number: ' + ReturnedEfilerNumber +  chr(10) + chr(13) +
                                                'Control Number: ' + ReturnedControlNumber;
                        //showmessage(messageString);
                        //result := idstring + chr(10) + chr(13) + messageString + chr(10) + chr(13);

                        //AckRec.EFresultType := EFaccepted; //20140124           ???????
                        AckRecT106.T106resultType := T106accepted; //jz
                end
                else         //else error ------------------------------------------------------------------
                begin

                        //AckRec.EFresultType := EFrejected;  //20140124
                        AckRecT106.T106resultType := T106rejected; //jz
                        //find error clues if any
                        fString := '';

                        messageString := 'Submission Failed' + chr(10) + chr(13) + chr(10) + chr(13) + 'Result Code: ' + fCode;
                end;
        end
        ELSE // no <t2ersp:T2ResultCode> found
        begin

                // jz??? not needed? Probably doesnt work???
                s := '<resultCode xsi:type="xsd:string">';
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</resultCode>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

                        if (fCode = '180') or (fCode = '182') then
                              AckRecT106.T106resultType := T106accepted;//AckRec.EFresultType := EFAccepted;

                        if fCode = '132' then
                        begin
                              //AckRec.EFresultType := EFrejected;
                              AckRecT106.T106resultType := T106rejected; //jz
                        end;
                end;


        end

    END; //else not servererror

    //   MessageDlg(tempString,mtError,[mbOK],0);    //20141211


    With AckRecT106 do
    Begin
     Name             := ReturnedCorpName;
     BnNumber         := ReturnedBnNumber;
     TransmitterID    := ReturnedTransmissionID;
     TxYear           := ReturnedTaxYr;
     ResponseCode     := fCode;
     ResponseText     := AckRecResultDescription;
     DateTimeReceived := FormatDateTime('yyyy-mm-dd',Date)+ '  '+GetTimeToMilliSec(Date);//FormatDateTime('yyyy-mm-dd',Date);

     if T106resultType <> T106accepted then // these are not sent currently on rejected submissions for some reason
     begin
      Name             := GetCorpName(RetNo);
      BnNumber         := GetCorpBusNo(RetNo);
      TxYear           := inttostr(GetTaxationYearEndYYYY(RetNo));
     end;


    end;

end;

procedure TTCRAReport.testResponseClick(Sender: TObject);
var
    tempResponseList:tstringlist;
    AckResponseFlName, T106ResponseHTM, ResponseXmlFile:string;
    T106ResponseRec:T106AckRec;
begin
 OpenDialog1.FileName := '*Response*';
 //OpenDialog1.FileName := '';

 OpenDialog1.InitialDir:= T106EfileDir; //NetFileDir;
 OpenDialog1.Filter := 'XML files (*.xml)|*.xml|'+
                       'Any (*.*)|*.*';
 If OpenDialog1.Execute then
 begin
   tempResponseList := TStringList.Create;
   tempResponseList.loadFromFile(OpenDialog1.FileName);

   T106ResponseRec := parseT106Response(tempResponseList.text);

   T106ResponseHTM := CreateT106EfileResponseHtm(RetNo,AckRecT106,AppDir +'\'+ 'EFT106ResponseTemplate.htm');

   If FileExists(T106ResponseHTM) then
    ShellExecute(Self.Handle, nil, PChar('' + T106ResponseHTM), nil, nil, SW_NORMAL);

 end;
end;



Function TTCRAReport.GetDcnSeqNoForT106(RetNo:Integer;OnLineNo:String):String;
Var YYYY,MM,DD,Hour,Min,Sec,Msec :word;
 SMM, SDD, SMin,SSec,SMSec : string[2];
 Syyyy:String[4];
 sBirthday:String[2];
 SAppYear:String[2];
begin
   Delay(1);  //to inceasethe second
   DecodeDate(Now,YYYY,MM,DD);
   DecodeTime(Now,Hour,Min,Sec,Msec);
   Syyyy:=AllTrim(IntToStr(YYYY));
   SMM   := LTrim(RTrim(IntToStr(MM)));

   sAppYear:=RightStr(AppYear,2);  //20150128
   SDD   := Ltrim(Rtrim(IntToStr(dd)));
   SMIN  := Ltrim(Rtrim(IntToStr(Min)));
   SSec   := AllTrim(IntToStr(Sec));
   SMSec:=LTrim(RTrim(IntToStr(MSec)));
   If Length(SMM)   =1 then SMM   := '0'+SMM;
   If Length(SDD)   =1 then SDD   := '0'+Sdd;
   If Length(SMIN)  =1 then SMin  := '0'+SMin;
   If Length(SSec)  =1 then SSec  := '0'+SSec;
   If Length(SMSec) =1 then SMSec:= '0'+SMSec;
  // Result:=OnlineNo+smm+Sdd+SSec+SMSec;    //20050128
   Result:=sAppYear+Sdd+SSec+RightStr(GetBirthdate(RetNo),1)+RightStr(SMSec,1);    //2005
   //If length(result)<> 13 then result:='';
end;

//20160124
Function TTCRAReport.ConvertCheckBoxTo1(S:String):String;  //20160124
Begin
 Result:='0';//20160624
 If UpperCase(s)='X' then result:='1';
end;


//20160617  from John
procedure TTCRAReport.CreateT106SoapMessage(RetNo:Integer);
Const Format1='########0';  //20150221
Var
i,Elm,T106FNo,ArrayNo,BoxesPerRow,MaxRowsPerArray:Integer; cd:String; //code
TempSoapList:TStringList;
TempDataList:TStringList;
s,s1,FlName:String;
DcnSeqNo:String;
begin
 T106FNo:=GetFormNo('T106');
 MaxRowsPerArray:=80;

 Indent1:=3;
 Indent2:=Indent1+3;
 Indent3:=Indent2+3;
 Indent4:=Indent3+3;
 Indent5:=Indent4+3;
 Indent6:=Indent5+3;
 Indent7:=Indent6+3;
 Indent8:=Indent7+3;
 Indent9:=Indent8+3;
 Indent10:=Indent9+3;
 Indent11:=Indent10+3;

 GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120
 XmlList:=TstringList.Create;
 XmlList.Clear;


 With XmlList do
 Begin
  add('<?xml version="1.0" encoding="UTF-8"?>');
  //added
  add('<soapenv:Envelope' + ' ' +
      'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' + ' ' +
      'xmlns:t2rq="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0">');
  add('<soapenv:Header/>');
  add('<soapenv:Body>');

   add('<t2rq:T2EfileReturnRequest' + ' ' +
     'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'        + ' ' +
     'xmlns:comm="http://www.cra-arc.gc.ca/xmlns/comm/2017/1-0-0"'   + ' ' +
     'xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2017/1-0-0"'       + ' ' +
     'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'          + ' ' +
     'xmlns:t106="http://www.cra-arc.gc.ca/xmlns/t106/2017/1-0-0"' + ' ' +
     'xmlns:t2rq="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0"' + ' ' +
     'xmlns:xml="http://www.w3.org/XML/1998/namespace"'              + ' ' +
     'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'         + ' ' +
     'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0 t2efilefrrmsrequest.xsd ">'); //jz 20160617

  add('<ef:TransmitterEfilerNumber>'+OnlineNo+'</ef:TransmitterEfilerNumber>');
  add('<ef:PasswordID>'+Password+'</ef:PasswordID>');
  add('<t2rq:TaxYear>'+LeftStr(GetTaxationYearEnd(RetNo),4)+'</t2rq:TaxYear>');
  add('<t2rq:SoftwareID>'+RsiApprovalCode+'</t2rq:SoftwareID>');   //20161207
 // add('<t2rq:SoftwareID>'+SoftwareId+'</t2rq:SoftwareID>');   //20160613

  add('<t2rq:TaxForm>');

//  add('<?xml version="1.0" encoding="UTF-8"?>');
  add('<t106:NonArmsLengthTransactionWithNonResidentInformationReturn'  + ' ' +
      'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'          + ' ' +
      'xmlns:comm="http://www.cra-arc.gc.ca/xmlns/comm/2017/1-0-0"'     + ' ' +
      'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'            + ' ' +
      'xmlns:t106="http://www.cra-arc.gc.ca/xmlns/t106/2017/1-0-1"'     + ' ' +
      'xmlns:xml="http://www.w3.org/XML/1998/namespace"'                + ' ' +
      'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'           + ' ' +
      'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t106/2017/1-0-1 NonArmsLengthTransactionWithNonResidentInformationReturn.xsd">');

  add('    <t106:NonArmsLengthWithNonResidentTransactionSummary>');
  {????????????????????}     add('        <t106:SummaryActionCode>'+ '1' +'</t106:SummaryActionCode>');             //???????????????????????????????????
  add('        <t106:FunctionalCurrencyCode>'+ leftstr( FetchElm(RetNo,'T106',60),3) +'</t106:FunctionalCurrencyCode>'); //???????????????????????????????????
  {????????????????????}     add('        <t106:AmendedReturnIndicator>'+ '0' +'</t106:AmendedReturnIndicator>');   //???????????????????????????????????
  add('        <t106:ReportingTaxpayerIdentification>');
  add('            <t106:Corporation>');
  add('                <t106:CorporationName>'+ ReplaceXMLChars( FetchElm(RetNo,'T106',5) ) +'</t106:CorporationName>');
  add('                <t106:BusinessNumber>'+ FetchElm(RetNo,'T106',6) +'</t106:BusinessNumber>');
  add('            </t106:Corporation>');
  add('        </t106:ReportingTaxpayerIdentification>');
  add('        <t106:ReportingTaxpayerAddress>');
  add('            <comm:AddressStreetText>'+ ReplaceXMLChars( FetchElm(RetNo,'T106',23) ) +'</comm:AddressStreetText>');
  add('            <comm:AddressMunicipalityName>'+ ReplaceXMLChars( FetchElm(RetNo,'T106',24) )+'</comm:AddressMunicipalityName>');
  add('            <t106:GlobalProvinceTerritoryStateCode>'+ FetchElm(RetNo,'T106',25) +'</t106:GlobalProvinceTerritoryStateCode>');
  add('            <t106:GlobalPostalZipCode>'+ RemoveChar(FetchElm(RetNo,'T106',26) , ' ') +'</t106:GlobalPostalZipCode>');
  {????????????????????}       add('            <t106:CountryCode>'+ leftstr( FetchElm(RetNo,'T106',60),3) +'</t106:CountryCode>');               //???????????????????????????????????
  add('        </t106:ReportingTaxpayerAddress>');
  add('        <t106:TaxationYearData>');
  s := FetchElm(RetNo,'T106',27);
  add('            <t106:TaxationYearStartDate>'+ ReplaceChar(s,'/','-') +'</t106:TaxationYearStartDate>');
  s := FetchElm(RetNo,'T106',28);
  add('            <t106:TaxationYearEndDate>'+ ReplaceChar(s,'/','-') +'</t106:TaxationYearEndDate>');
  add('        </t106:TaxationYearData>');



  s := ConvertCheckBoxTo1(FetchElm(RetNo,'T106',30));
  add('        <t106:FirstTimeFilerIndicator>'+ s +'</t106:FirstTimeFilerIndicator>');
  if s = '1' then
  begin
    s := FetchElm(RetNo,'T106',31);
    add('        <t106:LastReturnFilingPeriodEndDate>'+ ReplaceChar(s,'/','-') +'</t106:LastReturnFilingPeriodEndDate>');
  end;


  add('        <t106:DeclaredSlipCount>'+ FetchElm(RetNo,'T106',32) +'</t106:DeclaredSlipCount>');
  add('        <t106:SlipBoxTotalAmount>'+ FormatFloat(Format1,Round(Vl( FetchElm(RetNo,'T106',33) )))+'</t106:SlipBoxTotalAmount>');
  add('        <t106:ReportingTaxpayerGrossRevenueAmount>'+ FormatFloat(Format1,Round(Vl( FetchElm(RetNo,'T106',34) ))) +'</t106:ReportingTaxpayerGrossRevenueAmount>');


  add('        <t106:NorthAmericanIndustryClassificationSystem>');

  s:= FetchElm(RetNo,'T106',35);
  if s > '' then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');
  s:= FetchElm(RetNo,'T106',36);
  if s > ''  then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');
  s:= FetchElm(RetNo,'T106',37);
  if s > ''  then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');
  s:= FetchElm(RetNo,'T106',38);
  if s > ''  then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');

  add('        </t106:NorthAmericanIndustryClassificationSystem>');


  add('        <t106:AffectedReportedAmountCompetentAuthorityIndicator>'                  + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',39)) +'</t106:AffectedReportedAmountCompetentAuthorityIndicator>');
  add('        <t106:AdjustedReportedAmountForeignTaxAdministrationAssessmentIndicator>'  + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',41)) +'</t106:AdjustedReportedAmountForeignTaxAdministrationAssessmentIndicator>');
  add('        <t106:InternationalAdvancedPricingArrangementUseIndicator>'                + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',43)) +'</t106:InternationalAdvancedPricingArrangementUseIndicator>');

  s := ConvertCheckBoxTo1(FetchElm(RetNo,'T106',45));
  add('        <t106:ReportingTaxpayerFileOtherReturnIndicator>'+ s +'</t106:ReportingTaxpayerFileOtherReturnIndicator>');
  if s = '1' then
  begin
    add('        <t106:PrimaryAccount>');

    s := RemoveChar(FetchElm(RetNo,'T106',47), ' ');
    if s > '' then
      add('            <t106:PrimaryAccountNumber>'+ s +'</t106:PrimaryAccountNumber>');

    s := RemoveChar(FetchElm(RetNo,'T106',48), ' ');
    if s > '' then
      add('            <t106:PrimaryAccountNumber>'+ s +'</t106:PrimaryAccountNumber>');

    add('        </t106:PrimaryAccount>');
  end;

  add('        <t106:ReportingTaxpayerNonResidentNonMonetaryConsiderationIndicator>'  + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',49)) +'</t106:ReportingTaxpayerNonResidentNonMonetaryConsiderationIndicator>');
  add('        <t106:ReportingTaxpayerNonResidentNilConsiderationIndicator>'          + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',51)) +'</t106:ReportingTaxpayerNonResidentNilConsiderationIndicator>');

  add('        <t106:CertificationDetail>');
  add('            <t106:ContactPersonFirstName>'   + ReplaceXMLChars( FetchElm(RetNo,'T106',53) ) +'</t106:ContactPersonFirstName>');
  add('            <t106:ContactPersonLastName>'    + ReplaceXMLChars( FetchElm(RetNo,'T106',54) ) +'</t106:ContactPersonLastName>');
  add('            <t106:ContactPersonPhoneNumber>' + FetchElm(RetNo,'T106',55)+FetchElm(RetNo,'T106',56)+'</t106:ContactPersonPhoneNumber>');
  add('            <t106:CertifierName>'            + ReplaceXMLChars( FetchElm(RetNo,'T106',57) ) +'</t106:CertifierName>');
  add('            <t106:CertificationDate>'        + FetchElm(RetNo,'T106',58) +'</t106:CertificationDate>');
  add('            <t106:CertifierPositionTitle>'   + ReplaceXMLChars( FetchElm(RetNo,'T106',59) ) +'</t106:CertifierPositionTitle>');
  add('        </t106:CertificationDetail>');
  add('    </t106:NonArmsLengthWithNonResidentTransactionSummary>');



  //SLIP------------------------------------------------------------------------
  for i := 1 to CountMultipleInstances(RetNo,'T106SL') do
  begin

  add('    <t106:NonArmsLengthWithNonResidentTransactionSlip>');
  add('        <t106:SlipSequenceIdentifier>'+ FetchElm(RetNo,'T106SL#'+inttostr(i),124) +'</t106:SlipSequenceIdentifier>');

  s1 := '1'; {????????????????????}
  add('        <t106:SlipActionCode>' + s1 +'</t106:SlipActionCode>');
  s := '';     {????????????????????}
  if s1 = '4' then   //if (s > '') or (s1 = '4') then
    add('        <t106:SlipDeleteReasonCode>'   + s +'</t106:SlipDeleteReasonCode>');

  add('        <t106:NonResidentName>'        + ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),10) ) +'</t106:NonResidentName>');
  add('        <t106:NonResidentAddress>'     + ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),11) ) + ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),12) ) +'</t106:NonResidentAddress>');
  add('        <t106:NonResidentCountryCode>' + FetchElm(RetNo,'T106SL#'+inttostr(i),13) +'</t106:NonResidentCountryCode>');

  if FetchElm(RetNo,'T106SL#'+inttostr(i),14) > '' then s:='1'
  else if FetchElm(RetNo,'T106SL#'+inttostr(i),15) > '' then s:='2'
  else if FetchElm(RetNo,'T106SL#'+inttostr(i),16) > '' then s:='3';
  add('        <t106:RelationshipTypeCode>' + s + '</t106:RelationshipTypeCode>');

  add('        <t106:TaxTreatyIndicator>' + ConvertCheckBoxTo1(FetchElm(RetNo,'T106SL#'+inttostr(i),17)) +'</t106:TaxTreatyIndicator>');
  add('        <t106:NorthAmericanIndustryClassificationSystem>');

  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),19);
  if s > '' then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');
  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),20);
  if s > ''  then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');
  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),21);
  if s > ''  then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');
  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),22);
  if s > ''  then
    add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ s +'</t106:NorthAmericanIndustryClassificationSystemCode>');
  add('        </t106:NorthAmericanIndustryClassificationSystem>');

  add('        <t106:Country>');

  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),24);
  if s > '' then
    add('            <t106:CountryCode>'+ s +'</t106:CountryCode>');
  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),25);
  if s > '' then
    add('            <t106:CountryCode>'+ s +'</t106:CountryCode>');
  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),26);
  if s > '' then
    add('            <t106:CountryCode>'+ s +'</t106:CountryCode>');
  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),27);
  if s > '' then
    add('            <t106:CountryCode>'+ s +'</t106:CountryCode>');

  add('        </t106:Country>');

  add('        <t106:ContemporaneousDocumentationIndicator>'      + ConvertCheckBoxTo1(FetchElm(RetNo,'T106SL#'+inttostr(i),28)) +'</t106:ContemporaneousDocumentationIndicator>');
  add('        <t106:TransferPricingMethodologyChangeIndicator>'  + ConvertCheckBoxTo1(FetchElm(RetNo,'T106SL#'+inttostr(i),30)) +'</t106:TransferPricingMethodologyChangeIndicator>');


  add('        <t106:TangiblePropertyStockInTradeRawMaterial>');

  s:=FetchElm(RetNo,'T106SL#'+inttostr(i),32);
  if s > '' then
  begin
    add('            <t106:SoldToNonResidentAmount>' +                              FormatFloat(Format1,Round(Vl( s ))) +'</t106:SoldToNonResidentAmount>');
    add('            <t106:SoldToNonResidentTransferPricingMethodologyCode>' +      '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),33) +'</t106:SoldToNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),34);
  if s > '' then
  begin
    add('            <t106:PurchaseFromNonResidentAmount>' +                        FormatFloat(Format1,Round(Vl( s )))                               +'</t106:PurchaseFromNonResidentAmount>');
    add('            <t106:PurchaseFromNonResidentTransferPricingMethodologyCode>'+ '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),35)     +'</t106:PurchaseFromNonResidentTransferPricingMethodologyCode>');
  end;

  add('        </t106:TangiblePropertyStockInTradeRawMaterial>');


  add('        <t106:TangiblePropertyOther>');
  s:= ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),93) );
  if s > '' then
  begin
    add('            <t106:OtherTangiblePropertyDescription>'                       + s +'</t106:OtherTangiblePropertyDescription>');

    s:= FetchElm(RetNo,'T106SL#'+inttostr(i),120);
    if s > '' then
    begin
      add('            <t106:SoldToNonResidentAmount>'                                + FormatFloat(Format1,Round(Vl( s ))) +'</t106:SoldToNonResidentAmount>');
      add('            <t106:SoldToNonResidentTransferPricingMethodologyCode>'        + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),121) +'</t106:SoldToNonResidentTransferPricingMethodologyCode>');
    end;

    s:= FetchElm(RetNo,'T106SL#'+inttostr(i),122);
    if s > '' then
    begin
      add('            <t106:PurchaseFromNonResidentAmount>'                          + FormatFloat(Format1,Round(Vl( s ))) +'</t106:PurchaseFromNonResidentAmount>');
      add('            <t106:PurchaseFromNonResidentTransferPricingMethodologyCode>'  + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),123) +'</t106:PurchaseFromNonResidentTransferPricingMethodologyCode>');
    end;
  end;
  add('        </t106:TangiblePropertyOther>');


  add('        <t106:Rent>');

  s := FetchElm(RetNo,'T106SL#'+inttostr(i),36);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),37) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),38);
  if s > '' then
  begin
      add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
      add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),39) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;

  add('        </t106:Rent>');


  add('        <t106:Royalty>');
  s := FetchElm(RetNo,'T106SL#'+inttostr(i),40);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),41) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;

  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),42);
  if s > '' then
  begin
    add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),43) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('        </t106:Royalty>');

  add('        <t106:LicenseOrFranchiseFee>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),44);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),45) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),46);
  if s > '' then
  begin
    add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),47) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('        </t106:LicenseOrFranchiseFee>');


  add('        <t106:IntangiblePropertyOrRights>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),48);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),49) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),50);
  if s > '' then
  begin
    add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),51) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('        </t106:IntangiblePropertyOrRights>');


  add('        <t106:Management>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),52);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),53) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),54);
  if s > '' then
  begin
    add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),55) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('        </t106:Management>');


  add('        <t106:Engineering>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),56);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),57) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),58);
  if s > '' then
  begin
    add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),59) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('        </t106:Engineering>');


  add('        <t106:ResearchAndDevelopment>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),60);
  if s > '' then
  begin
    add('           <t106:RevenueFromNonResidentAmount>'                            + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('           <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'    + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),61) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),62);
  if s > '' then
  begin
    add('           <t106:ExpenditureToNonResidentAmount>'                          + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('           <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'  + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),63) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('       </t106:ResearchAndDevelopment>');


  add('        <t106:Commission>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),64);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),65) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),66);
  if s > '' then
  begin
    add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),67) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('        </t106:Commission>');


  add('        <t106:Interest>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),68);
  if s > '' then
    add('            <t106:RevenueFromNonResidentAmount>'     + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),70);
  if s > '' then
    add('            <t106:ExpenditureToNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:Interest>');


  add('        <t106:Dividend>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),72);
  if s > '' then
    add('            <t106:RevenueFromNonResidentAmount>'     + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),74);
  if s > '' then
    add('            <t106:ExpenditureToNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:Dividend>');


  add('        <t106:SaleOfFinancialProperty>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),126);
  if s > '' then
    add('            <t106:RevenueFromNonResidentAmount>'     + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),128);
  if s > '' then
    add('            <t106:ExpenditureToNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:SaleOfFinancialProperty>');


  add('        <t106:LeasePayment>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),130);
  if s > '' then
    add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),132);
  if s > '' then
    add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:LeasePayment>');


  add('        <t106:SecuritiesLending>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),134);
  if s > '' then
    add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),136);
  if s > '' then
    add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:SecuritiesLending>');


  add('        <t106:Insurance>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),76);
  if s > '' then
  begin
    add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
    add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),77) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
  end;
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),78);
  if s > '' then
  begin
    add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
    add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),79) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
  end;
  add('        </t106:Insurance>');


  add('        <t106:FinancialOther>');
  s:= ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),95) );
  if s > '' then
  begin
    add('            <t106:FinancialOtherDescription>'                              + s +'</t106:FinancialOtherDescription>');

    s:= FetchElm(RetNo,'T106SL#'+inttostr(i),80);
    if s > '' then
    begin
      add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
      add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),81) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
    end;
    s:= FetchElm(RetNo,'T106SL#'+inttostr(i),82);
    if s > '' then
    begin
      add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
      add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),83) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
    end;
  end;
  add('        </t106:FinancialOther>');


  add('        <t106:ReimbursementOfExpense>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),84);
  if s > '' then
  add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),86);
  if s > '' then
  add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:ReimbursementOfExpense>');


  add('        <t106:OtherTransaction>');
  s:= ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),119) );
  if s > '' then
  begin
    add('            <t106:OtherTransactionDescription>'                            + s +'</t106:OtherTransactionDescription>');

    s:= FetchElm(RetNo,'T106SL#'+inttostr(i),88);
    if s > '' then
    begin
      add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
      add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),89) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
    end;
    s:= FetchElm(RetNo,'T106SL#'+inttostr(i),90);
    if s > '' then
    begin
      add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
      add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),91) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
    end;
  end;
  add('        </t106:OtherTransaction>');


  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),92);
  if s > '' then
    add('        <t106:NonArmsLengthNonResidentSaleRevenueTotalAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentSaleRevenueTotalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),94);
  if s > '' then
    add('        <t106:NonArmsLengthNonResidentPurchaseExpenditureTotalAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentPurchaseExpenditureTotalAmount>');


  add('        <t106:OwedByReportingTaxpayerAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),96);
  if s > '' then
    add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),97);
  if s > '' then
    add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:IncreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),98);
  if s > '' then
    add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:DecreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),99);
  if s > '' then
    add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s ))) +'</t106:EndingBalanceAmount>');
  add('        </t106:OwedByReportingTaxpayerAmount>');


  add('        <t106:OwedToReportingTaxpayerAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),100);
  if s > '' then
    add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),101);
  if s > '' then
    add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:IncreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),102);
  if s > '' then
      add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:DecreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),103);
  if s > '' then
      add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s ))) +'</t106:EndingBalanceAmount>');
  add('        </t106:OwedToReportingTaxpayerAmount>');


  add('        <t106:InvestmentInNonResident>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),104);
  if s > '' then
      add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),105);
  if s > '' then
      add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:IncreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),106);
  if s > '' then
      add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:DecreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),107);
  if s > '' then
      add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s ))) +'</t106:EndingBalanceAmount>');
  add('        </t106:InvestmentInNonResident>');


  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),108);
  if s > '' then
      add('        <t106:NonArmsLengthNonResidentLoanAdvanceInvestmentIncreaseTotalAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentLoanAdvanceInvestmentIncreaseTotalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),109);
  if s > '' then
      add('        <t106:NonArmsLengthNonResidentLoanAdvanceInvestmentDecreaseTotalAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentLoanAdvanceInvestmentDecreaseTotalAmount>');


  add('        <t106:InterestRateContract>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),138);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),139);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),140);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),141);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:InterestRateContract>');


  add('        <t106:ForeignExchangeContract>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),142);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),143);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),144);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),145);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:ForeignExchangeContract>');


  add('        <t106:CreditContract>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),146);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),147);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),148);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),149);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:CreditContract>');


  add('        <t106:EquityContract>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),150);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),151);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),152);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),153);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:EquityContract>');


  add('        <t106:CommodityContract>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),154);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),155);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),156);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),157);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:CommodityContract>');


  add('        <t106:IndexContract>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),158);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),159);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),160);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),161);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:IndexContract>');


  add('        <t106:DerivativeFee>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),162);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),163);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),164);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),165);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:DerivativeFee>');


  add('        <t106:DerivativeOtherPayment>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),166);
  if s > '' then
      add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),167);
  if s > '' then
      add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NotionalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),168);
  if s > '' then
      add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),169);
  if s > '' then
      add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:ExpenditureToNonResidentAmount>');
  add('        </t106:DerivativeOtherPayment>');


  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),170);
  if s > '' then
    add('        <t106:NonArmsLengthNonResidentDerivativeContractTotalCount>'     + s +'</t106:NonArmsLengthNonResidentDerivativeContractTotalCount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),171);
  if s > '' then
    add('        <t106:NonArmsLengthNonResidentDerivativeNotionalTotalAmount>'    + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentDerivativeNotionalTotalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),172);
  if s > '' then
      add('        <t106:NonArmsLengthNonResidentDerivativeRevenueTotalAmount>'     + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentDerivativeRevenueTotalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),173);
  if s > '' then
      add('        <t106:NonArmsLengthNonResidentDerivativeExpenditureTotalAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentDerivativeExpenditureTotalAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),174);
  if s > '' then
      add('        <t106:BoxTotalAmount>'                                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BoxTotalAmount>');


  add('        <t106:AccountPayableAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),111);
  if s > '' then
      add('            <t106:BeginningBalanceAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),112);
  if s > '' then
      add('            <t106:IncreaseAmount>'           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:IncreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),113);
  if s > '' then
      add('            <t106:DecreaseAmount>'           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:DecreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),114);
  if s > '' then
      add('            <t106:EndingBalanceAmount>'      + FormatFloat(Format1,Round(Vl( s ))) +'</t106:EndingBalanceAmount>');
  add('        </t106:AccountPayableAmount>');


  add('        <t106:AccountReceivableAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),115);
  if s > '' then
      add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),116);
  if s > '' then
      add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:IncreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),117);
  if s > '' then
      add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:DecreaseAmount>');
  s:= FetchElm(RetNo,'T106SL#'+inttostr(i),118);
  if s > '' then
      add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s ))) +'</t106:EndingBalanceAmount>');
  add('        </t106:AccountReceivableAmount>');


  add('    </t106:NonArmsLengthWithNonResidentTransactionSlip>');

  end; //SLIP------------------------------------------------------------------------

  add('</t106:NonArmsLengthTransactionWithNonResidentInformationReturn>');

add(' </t2rq:TaxForm>');

add(' </t2rq:T2EfileReturnRequest>');
 //mine
add('</soapenv:Body>');
add('</soapenv:Envelope>');

end; //with xmllist

 //jz 20160617
 //when testing, load from file xmlList.Clear; xmllist.LoadFromFile('C:\Users\Costas\Documents\SCHEMA\schema\T2\examplT1135_ORIGINALtoCHANGE.xml');
 //Now save the list to a file
 SoapMsg:='';
 For I:=0 to XmlList.count-1 do
  SoapMsg:=SoapMsg+XmlList[i]; //+Chr(13);
// If FileExists(MkSubmittedFileName(RetNo)) then  DeleteFile(MkSubmittedFileName(RetNo));
// XmlList.SaveToFile(MkSubmittedFileName(RetNo));
 XmlList.Free;
end;

Function TTCRAReport.CreateT106EfileResponseHtm(RetNo: Integer; AckRec: T106AckRec; HtmFile: String):String; //20160523 Igor
var
  htmlSource: TStringList;
  source, flName: string;
  OnLineNo, PassWord, Url, NetFileDir: String;
  keyWord,replacementString:string;
  i, j, k, s, startPos, itemNumTemp: integer;
begin
  Result := '';
  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  htmlSource := TStringList.Create;
  htmlSource.LoadFromFile(HtmFile);
  For i := 0 to htmlSource.Count - 1 do
  begin
    keyWord           := '!STATUS!';
    if AckRecT106.T106resultType = T106accepted then
        replacementString := 'Accepted'
    else if  AckRecT106.T106resultType = T106webserviceError then
        replacementString := 'Rejected - Web Service Error'
    else
        replacementString := 'Rejected';
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!COLOR!';
    if AckRecT106.T106resultType = T106accepted then
        replacementString := 'green'
    else
        replacementString := 'red';
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);


    keyWord           := '!DATETIME!';
    replacementString := AckRec.DateTimeReceived;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!CORPNAME!';
    replacementString := AckRec.Name;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!BNNUMBER!';
    replacementString := AckRec.BNnumber;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!TRANSMITTERID!';
    replacementString := AckRec.TransmitterID;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);


    keyWord           := '!YEAR!';
    replacementString := AckRec.TxYear;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);


    keyWord           := '!RESULT!';
    replacementString := AckRec.ResponseCode;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);


    keyWord           := '!DESCRIPTION!';
    replacementString := AckRec.ResponseText;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    //----------------------------------------------------------------

  end;

  //flName := NetFileDir+'\'+ GetLastName(RetNo)+' '+GetFirstName(RetNo) + 'T106EFileAck.htm';

  flName :=  T106EfileDir + '\' + GetNineDigitAccountNumber(RetNo) + 'T106EFileAck.htm';

  htmlSource.SaveToFile(flName);
  htmlSource.Free;

  result := flName;   //jz

end;

Function TTCRAReport.ReplaceXMLChars(info: String): String;
Begin
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;');  //20160515 it is char(39)
  info := ReplaceChar(info, Chr(39), '&apos;');  //20161213
  result := info;
End;

end.

