//cleaned unused function //20171204 Igor
unit T2_2027AttachADoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, {FileCtrl, }System.StrUtils, //20171121 Igor
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
  
 //20250725
 Const SOFTRELEASEYEAR   = '2025'; //'2023';  //20240221
 Const SOFTRELEASEMONTH  = '07'; //'10';  //20161219
 Const SOFTRELEASEDAY    = '26'; //'31';
 Const CrLf         =  Chr(13)+Chr(10);


 type
 TAttachADocresultType = (AttachADocaccepted,AttachADocrejected,AttachADocDelayed,AttachADocwebserviceError);  //20160523 Igor
 AttachADocAckRec = Record
   Name                 : String;
   BNnumber             : String;
   TxYear               : String;
   DateTimeReceived     : String;
   TransmitterID        : String;
   ConfirmationID       : String;
   Response             : String;
   ResponseCode         : String;
   ResponseText         : String;
   additionalText       : String;
   AttachADocresultType : TAttachADocresultType;
 end;


type
  TT2_2027AttachADoc = class(TForm)
    SubmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    TestOrProductionGroup: TRadioGroup;
    OpenDialog1: TOpenDialog;
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
    pnlSelectFile: TPanel;
    mtMainfilepath: TStringField;
    mtMaindocid: TStringField;
    mtMaindocname: TStringField;
    mtMaindoccomment: TStringField;
    Panel2: TPanel;
    Panel3: TPanel;
    HeaderControl1: THeaderControl;
    Panel1: TPanel;
    Label1: TLabel;
    btnAddFile: TBitBtn;
    btnDeleteFile: TBitBtn;
    DBText1: TDBText;
    Panel4: TPanel;


    Function ReplaceXMLChars(info: String): String;  //20161213
    Function ConvertCheckBoxTo1(S:String):String;  //20160124
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    Function CreateAttachADocEfileResponseHtm(ARetNo: Integer; AckRec: AttachADocAckRec; HtmFile: String):String;
    procedure FormActivate(Sender: TObject);
    Function  MkSelectedStr: String;
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure pnlSelectFileClick(Sender: TObject);
    procedure pnlSelectTypeClick(Sender: TObject);
    procedure mtMainAfterInsert(DataSet: TDataSet);
    procedure btnAddFileClick(Sender: TObject);
    procedure btnDeleteFileClick(Sender: TObject);
  private
    { Private declarations }
    FRetNo:Integer;
    FSLDocTypeList: TStringList;
    FInsurancecorporations: boolean;
    procedure setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);
    function GenerateFileName(aPrefix: string): string;//20171121 Igor
  public
    { Public declarations }
  end;

var
  AttachADocEfile: TT2_2027AttachADoc;
  SoapMsg:String;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
  NetFileDir:String;
  FormCnt:Integer;
  AttachADocEfileDir: String;
  Indent1, Indent2,Indent3,Indent4,Indent5,Indent6,Indent7, Indent8,Indent9,Indent10,Indent11:Integer;
  AckRecAttachADoc:AttachADocAckRec;

implementation

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T2_2027, T2_2027main,
  vtShared, vtDynData, IdMultipartFormData, IdGlobalProtocols, IdCoderMIME,
  vtDialogs, System.IOUtils;

{$R *.DFM}

type
  TDocumentRow = array [0..2] of string;
  TArrDocumentRow = array of TDocumentRow;
var
  DocumentsDatasTable1: TArrDocumentRow;
  DocumentsDatasTable2: TArrDocumentRow;
  DocumentsDatasTable3: TArrDocumentRow;

procedure TT2_2027AttachADoc.setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);
var
  wacNumber: String;
begin
  wacNumber := GetWACNumber(FRetNo);
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

procedure TT2_2027AttachADoc.FormCreate(Sender: TObject);
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
 FSLDocTypeList := TStringList.Create;
 // load *tbl.d
 LoadArr(DocumentsDatasTable1, AppDir+'\'+'attachadoctbl1.d');
 LoadArr(DocumentsDatasTable2, AppDir+'\'+'attachadoctbl2.d');
 LoadArr(DocumentsDatasTable3, AppDir+'\'+'attachadoctbl3.d');

 AttachADocEfileDir:=AppDir+'\'+'AttachADocEfile';
 If not SysUtils.DirectoryExists(AttachADocEfileDir) then SysUtils.ForceDirectories(AttachADocEfileDir);
 FRetNo:=GetCurrentRetNo;

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
 //20171204 Igor>>>
 OpenDialog1.InitialDir := TPath.Combine(OptRec.Dir_ClientDocs, MkDirforClientDocs(FRetNo));
 ForceDirectories(OpenDialog1.InitialDir);
//20171204 Igor<<<
 (* IGOR to look into it
 //20171202 CON
  We want to initialize it to the clients Documents directory and force the directory to be build before selection
  Something like the lines below but they do not work ok.
  OpenDialog1.InitialDir:=optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(FRetNo);
  DbEdit1.text:=OpenDialog1.InitialDir;
  If DirectoryExists(DbEdit1.text) then ForceDirectories(DbEdit1.text);
  Clicking the select panel of the data directory should default to the ClientDocuments folder
  Also the User must not be able to connect unless all 3 pieces of data are entered
 *)
end;

procedure TT2_2027AttachADoc.SubmitBtnClick(Sender: TObject);
Var
 FlName:String;
 SendStream:TStringStream;
 HTMLFile :String; //20171121 Igor
 XMLTEXT, sAttach:string;
 objHttp: ixmlHttpRequest;
 i: integer;
 xml: IXMLDOMDocument;
 node: IXMLDomNode;
 errormsg: string;
 sURL: String;
begin
  if mtMain.State in [dsInsert, dsEdit] then
    mtMain.Post;
  mtMain.First;
  while not mtMain.Eof do
  begin
    if (mtMain.FieldByName('filepath').AsString = '') then
    begin
      MessageDlg('File path required!', mtError, [mbOk], 0);
      Exit;
    end;
    if not TFile.Exists(mtMain.FieldByName('filepath').AsString) then
    begin
      MessageDlg('File not found!', mtError, [mbOk], 0);
      Exit;
    end;
    if (mtMain.FieldByName('docid').AsString = '') then
    begin
      MessageDlg('Document ID required!', mtError, [mbOk], 0);
      Exit;
    end;
    //20171204 Igor>>>
    if (mtMain.FieldByName('Desc').AsString = '') then
    begin
      MessageDlg('Document Description required!', mtError, [mbOk], 0);
      Exit;
    end;
    //20171204 Igor<<<

    mtMain.Next;
  end;

  setwebServiceUserNamePassword(OnlineNo,Password);
  //20171121 Igor>>
  AckRecAttachADoc.BNnumber := Trim(FetchElm(FRetNo, 'T2', 1));
  AckRecAttachADoc.ConfirmationID := Trim(GetEFileConfirmationNo(FRetNo));
  AckRecAttachADoc.Name := Trim(FetchElm(FRetNo, 'T2', 3));
  //20171121 Igor<<
  XMLTEXT := '--mime-boundary'+#13#10+
            'Content-Type: application/xop+xml; charset=UTF-8'#13#10+
            'Content-Transfer-Encoding: 8bit'#13#10+
            'Content-ID: <xml>'+#13#10 +#13#10+
      '<?xml version="1.0" encoding="ISO-8859-1"?>'+#13#10 +
      '<soap-env:Envelope xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/">'+#13#10 +
      '    <soap-env:Header>'+#13#10 +
      '        <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+#13#10 +
      '            <wsse:UsernameToken>'+#13#10 +
      '                <wsse:Username>'+ Trim(OnlineNo)+'</wsse:Username>'+#13#10 +
      '                <wsse:Password>'+Trim(Password)+'</wsse:Password>'+#13#10 +
      '            </wsse:UsernameToken>'+#13#10 +
      '        </wsse:Security>'+#13#10 +
      '    </soap-env:Header>'+#13#10 +
      '    <soap-env:Body>'+#13#10 +
      '        <tgif:attachFiles xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif">'+#13#10 +
      '            <tgif:AttachFilesRequest>'+#13#10 +
      '                <tgif:BusinessNumber>' + AckRecAttachADoc.BNnumber + '</tgif:BusinessNumber>'+#13#10 +
      '                <tgif:TaxationYearEndDate>' + ReplaceStr(Trim(FetchElm(FRetNo, 'T2', 11)), '/', '-') + '</tgif:TaxationYearEndDate>'+#13#10 +
      '                <tgif:TaxationYearEndTime>' + Trim(FetchElm(FRetNo, 'T2', 207)) + '</tgif:TaxationYearEndTime>'+#13#10 +
      '                <tgif:SoftwareID>'+RSIApprovalCode+'</tgif:SoftwareID>'+#13#10 +
      '                <tgif:ConfirmationNumber>' + AckRecAttachADoc.ConfirmationID + '</tgif:ConfirmationNumber>'+#13#10;
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
          '--mime-boundary'   +#13#10+#13#10 +
          'Content-Type: application/octet-stream'+#13#10+
          'Content-Transfer-Encoding: 8bit'#13#10+
          'Content-Disposition: filename="' + ExtractFileName(mtMain.FieldByName('filepath').AsString) + '"'+#13#10+
          sAttach+#13#10+#13#10;
      end;
      mtMain.Next;
    end;
    XMLTEXT := XMLTEXT + '--mime-boundary--'; //20171120 Igor
    SendStream.Clear;

    SysUtils.ForceDirectories(TPath.Combine(CurrentApp.AppDir, 'AddADoc'));
    TFile.AppendAllText(TPath.Combine(CurrentApp.AppDir, 'AddADoc' +
      TPath.DirectorySeparatorChar + GenerateFileName('Request') + '.txt'),
      XMLTEXT);

    objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
    if TestOrProductionGroup.ItemIndex = 1 then       // t2 testing
      sURL := 'https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl'
    else    //production
         sURL := 'https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl';
    objHttp.open('POST', sURL, False, '', ''); // 20110120

    objHttp.setRequestHeader('SOAPAction', 'AttachFilesRequest'); //20171122 Igor
    objHttp.setRequestHeader('Content-Type', 'Multipart/Related; boundary=mime-boundary; start="<xml>"');
    objHttp.setRequestHeader('Content-Length', IntToStr(Length(XMLTEXT)*SizeOf(Char)));
    objHttp.send(XMLTEXT); // SEND SOAP MESSAGE
  finally
     SendStream.Free;
  end;

  TFile.AppendAllText(TPath.Combine(CurrentApp.AppDir, 'AddADoc' +
      TPath.DirectorySeparatorChar + GenerateFileName('Response') + '.txt'),
      objHttp.ResponseText);

  xml := CreateOleObject('Microsoft.XMLDOM') as IXMLDOMDocument;
  xml.async := False;
  xml.loadXML(objHttp.ResponseText);
  if xml.parseError.errorCode <> 0 then
    raise Exception.Create('XML Load error:' + xml.parseError.reason);
  node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnConfirmation/tgif:ConfirmationNumber');
  if assigned(node) then
    AckRecAttachADoc.TransmitterID := node.text
  else
    AckRecAttachADoc.TransmitterID := 'Not Found';
  node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError');
  if assigned(node) then begin
    AckRecAttachADoc.ResponseText := '';//20171121 Igor
    errormsg := '';
    node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError/tgif:ErrorMessage/tgif:ErrorCode');
    if Assigned(node) then
    begin//20171121 Igor
      errormsg := errormsg + 'Error code: ' + node.text + #13#10;
      AckRecAttachADoc.ResponseCode := node.text;//20171121 Igor
    end else//20171121 Igor
      AckRecAttachADoc.ResponseCode := 'Unknown';//20171121 Igor
    node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError/tgif:ErrorMessage/tgif:EnglishMessageText');
    if Assigned(node) then
    begin//20171121 Igor
      errormsg := errormsg + 'English error text: ' + node.text + #13#10;
      AckRecAttachADoc.ResponseText := 'English error text: ' + node.text + '<br>';//20171121 Igor
    end;//20171121 Igor
    node := xml.selectSingleNode('soapenv:Envelope/soapenv:Body/tgif:AttachFilesResponse/tgif:ReturnError/tgif:ErrorMessage/tgif:FrenchMessageText');
    if Assigned(node) then
    begin//20171121 Igor
      errormsg := errormsg + 'French error text: ' + node.text + #13#10;
      AckRecAttachADoc.ResponseText := AckRecAttachADoc.ResponseText + 'French error text: ' + node.text;//20171121 Igor
    end;//20171121 Igor
    ShowMessage(errormsg);
    HTMLFile := CreateAttachADocEfileResponseHtm(FRetNo, AckRecAttachADoc, AppDir +'\'+ 'AttachADocNONAcceptedTemplate.htm');//20171122 Igor
  end
  else
  Begin
   showmessage('All ok for submit');
   //SubmitSoapMsg(SoapMsg,FlName); //20171121 Igor
   HTMLFile := CreateAttachADocEfileResponseHtm(FRetNo, AckRecAttachADoc, AppDir +'\'+ 'AttachADocAcceptedTemplate.htm');//20171122 Igor
  end;
  ShellExecute(MainForm.Handle,'open',Pchar(HTMLFile),Nil,Nil,Sw_Show);
end;

procedure TT2_2027AttachADoc.FormActivate(Sender: TObject);
begin
  IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));//20200804 Igor
  setwebServiceUserNamePassword(OnlineNo,Password);
  If (OnlineNo='') then
  begin
   SoapMsg:='';
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT2.SetupEOLInternetFiling1Click(Sender);
   Exit;
  end;

  FRetNo:=GetCurrentRetNo;
end;

Function TT2_2027AttachADoc.MkSelectedStr: String;
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

procedure TT2_2027AttachADoc.mtMainAfterInsert(DataSet: TDataSet);
begin
  pnlSelectFileClick(pnlSelectFile);
end;

procedure TT2_2027AttachADoc.pnlSelectFileClick(Sender: TObject);
begin
  if OpenDialog1.Execute(Application.Handle) then
  begin
    if not (mtMain.State in [dsInsert, dsEdit]) then
    begin
      if mtMain.IsEmpty then
      begin
        mtMain.AfterInsert := nil;
        try
          mtMain.Append;
        finally
          mtMain.AfterInsert := mtMainAfterInsert;
        end;
      end
      else
        mtMain.Edit;

    end;
    mtMain.FieldByName('filepath').AsString := OpenDialog1.FileName;
    if (mtMain.FieldByName('docid').AsString = '') then
      pnlSelectTypeClick(nil);
  end;
end;

procedure TT2_2027AttachADoc.pnlSelectTypeClick(Sender: TObject);
var
  docname: string;
  i: integer;
begin
  docname := PopSomeList(FSLDocTypeList, 'Select doc type');
  if FInsurancecorporations then
  begin
  for I := 0 to Length(DocumentsDatasTable1) - 1 do
    if DocumentsDatasTable1[i][0] = docname then begin
      if not (mtMain.State in [dsInsert, dsEdit]) then
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

Function TT2_2027AttachADoc.MkResponseFileName(RetNo:Integer):String;
begin
  result:=AttachADocEfileDir+'\'+'AttachADoc-Response-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml';  //20160526
end;
//20171121 Igor>>
function TT2_2027AttachADoc.GenerateFileName(aPrefix: string): string;
begin
  Result := aPrefix + Trim(FetchElm(FRetNo, 'T2', 1)) + '_' + Trim(FetchElm(FRetNo, 'T2', 3)) + '_' + FormatDateTime('YYYYMMDD_hhnnss', Now);
  Result := ReplaceChar(Result, '\', '_');
  Result := ReplaceChar(Result, '/', '_');
  Result := ReplaceChar(Result, ':', '_');
  Result := ReplaceChar(Result, '*', '_');
  Result := ReplaceChar(Result, '?', '_');
  Result := ReplaceChar(Result, '"', '_');
  Result := ReplaceChar(Result, '<', '_');
  Result := ReplaceChar(Result, '>', '_');
  Result := ReplaceChar(Result, '|', '_');
  Result := ReplaceChar(Result, '+', '_');
  Result := ReplaceChar(Result, ' ', '_');
  Result := ReplaceChar(Result, '.', '_');
  Result := ReplaceChar(Result, '%', '_');
  Result := ReplaceChar(Result, '!', '_');
  Result := ReplaceChar(Result, '@', '_');
end;

procedure TT2_2027AttachADoc.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;

procedure TT2_2027AttachADoc.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

procedure TT2_2027AttachADoc.btnAddFileClick(Sender: TObject);
begin
  if mtMain.State in [dsInsert, dsEdit] then
    mtMain.Post;
  mtMain.Append;
end;

procedure TT2_2027AttachADoc.btnDeleteFileClick(Sender: TObject);
begin
  if MessageDlg('Delete record?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    Exit;
  if mtMain.State in [dsInsert] then
    mtMain.Cancel
  else
    mtMain.Delete;
end;

//20160124
Function TT2_2027AttachADoc.ConvertCheckBoxTo1(S:String):String;  //20160124
Begin
 Result:='0';//20160624
 If UpperCase(s)='X' then result:='1';
end;

//20171121 Igor>>
Function TT2_2027AttachADoc.CreateAttachADocEfileResponseHtm(ARetNo: Integer; AckRec: AttachADocAckRec; HtmFile: String):String; //20160523 Igor
var
  htmlSource: TStringList;
  source, flName: string;
  keyWord,replacementString:string;
  i, j, k, s, startPos, itemNumTemp: integer;
begin
  Result := '';
  htmlSource := TStringList.Create;
  htmlSource.LoadFromFile(HtmFile);
  For i := 0 to htmlSource.Count - 1 do
  begin
    keyWord           := '!ConNum!';
    replacementString := AckRec.ConfirmationID;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!DATE!';
    replacementString := DateToStr(Now);
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!ErrCode!';
    replacementString := AckRec.ResponseCode;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!ErrDesc!';
    replacementString := AckRec.ResponseText;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!TIME!';
    replacementString := TimeToStr(Now);
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

    keyWord           := '!TransID!';
    replacementString := AckRec.TransmitterID;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);



    //----------------------------------------------------------------

  end;

  flName :=  TPath.Combine(CurrentApp.AppDir, 'AddADoc' +
      TPath.DirectorySeparatorChar + GenerateFileName('AttachADoc') + '.htm');

  htmlSource.SaveToFile(flName);
  htmlSource.Free;

  result := flName;
end;
//20171121 Igor<<
Function TT2_2027AttachADoc.ReplaceXMLChars(info: String): String;
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

