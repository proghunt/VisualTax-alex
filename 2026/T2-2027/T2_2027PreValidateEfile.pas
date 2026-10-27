unit T2_2027PreValidateEfile;

//20190521
//T1135 used as template

{

menu link

procedure TMainFormT2_2027.PreVal1Click(Sender: TObject);
begin

   Application.CreateForm(TPreValidateEfileT2_2027,TPreValidateEfile);
   TPreValidateEfile.ShowModal;
   TPreValidateEfile.Free;


end;
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,
  T2_2027TrimStr, T2_2027Declare, T2_2027Common, T2_2027Common2, Db, DBTables, Grids, DBGrids,
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient; //20110129  NEEDED for connection and the response handler

  //20160215
  Const SOFTRELEASEYEAR   = '2023';  //20110120
  Const SOFTRELEASEMONTH  = '10';  //20161219
  Const SOFTRELEASEDAY    = '31';
  Const CrLf              =  Chr(13)+Chr(10);
 type
 TPreValresultType = (PreValSuccess,PreValRejected,PreValWebServiceError,PreValUnknownError);
 TPreValAckRec = Record
   Name                 : String;
   BNnumber             : String;
   TxYear               : String;
   DateTimeReceived     : String;
   ResponseCode         : String;
   ResponseText         : ansiString;
   PreValresultType     : TPreValresultType;
 end;


type
  TPreValidateEfileT2_2027 = class(TForm)
    EfileType: TPanel;
    SubmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ShowXMLBtn: TBitBtn;
    EfileOptionGroup: TRadioGroup;
    BatchPanel: TPanel;
    ListBox1: TListBox;
    OtherBatchButtonsPanel: TPanel;
    BuildBatchBtn: TBitBtn;
    BatchButtonsPanel: TPanel;
    RemoveBtn: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    DataDirBox: TEdit;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    TestOrProductionGroup: TRadioGroup;
    UrlBox: TEdit;
    Label7: TLabel;
    viewErrorCluesBtn: TBitBtn;
    SearchBox: TEdit;
    Label17: TLabel;
    Bevel1: TBevel;
    Memo1: TMemo;
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


    procedure setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);

    Function ReplaceXMLChars(info: String): String;  //20161213
    Function ConvertCheckBoxTo1(S:String):String;    //20160124
    Function CreatePreValSoapMessage(RetNo:Integer):String;
    procedure GetUrlBox;
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    Procedure SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);

    Function parsePreValResponse(rString:AnsiString):TPreValAckRec; //T1135AckRec;
    Function CreatePreValEfileResponseHtm(RetNo: Integer{; AckRec: T1135AckRec; HtmFile: String}):String;
    procedure FormActivate(Sender: TObject);
    procedure ShowXMLBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure EfileOptionGroupClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    Function  MkSelectedStr: String;
    procedure ListBox1DblClick(Sender: TObject);
  //  procedure BuildBatchBtnClick(Sender: TObject);
    procedure ShowFiles;
  //  Procedure CreateBatch;
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure viewErrorCluesBtnClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure instalMSXMLbtnClick(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
  private
    { Private declarations }
    RetNo:Integer;   //20160120 Igor
  public
    { Public declarations }
  end;

var

  TPreValidateEfile: TPreValidateEfileT2_2027;
  SoapMsg:AnsiString;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
  webServiceUserName, webServicePassword: String;
  NetFileDir:String;
  FormCnt:Integer;
  PreValEfileDir: String;
  sUrl:String;
  Indent1, Indent2,Indent3,Indent4,Indent5,Indent6,Indent7, Indent8,Indent9,Indent10,Indent11:Integer;

  //AckRec:TAckRec;
  PreValRec:TPreValAckRec;

implementation

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T2_2027, T2_2027main,
  vtShared, vtDynData{,childwinnew}; //20150120 Igor

{$R *.DFM}

procedure TPreValidateEfileT2_2027.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 PreValEfileDir:=AppDir+'\'+'PreValEfile';
 If DirectoryExists(PreValEfileDir) = false then ForceDirectories(PreValEfileDir);

 //if TestOrProductionGroup.visible = true then TestOrProductionGroup.itemindex := 1;  //20130212

 RetNo:=GetCurrentRetNo;

 If RetNo>0 then
 begin

   //If ValidForT1135Efile(RetNo,GetFormNo('T1135#1')) = false then
   Begin  SoapMsg:='';  Exit; End;

 end;

 //CreatePreValSoapMessage(RetNo);
end;


procedure TPreValidateEfileT2_2027.SubmitBtnClick(Sender: TObject);
Var RetNo:Integer;FlName:String;
begin
 //20150312
 If ValidPostal(RetNo,OptRec.Prp_Postal) = false then
 begin
  ShowMessage('Please fix the Postal code in Configure -> General Options -> Preparer');
  Exit;
 end;

 RetNo:=GetCurrentRetNo;

{
 //20150207

 If FetchElm(RetNo,'T1135',39)>'' then  //has confirmation
 Begin
  If FetchElm(RetNo,'T1135',22)='' then //amended = false
  Begin
   ShowMessage('This T1135 has been already Efiled and it has a Confirmation number.'
   +Chr(13)+'Unless you check the Amended box');
  Exit;
  end;
 end;
}

 flName := CreatePreValSoapMessage(RetNo);
 //  --------------
 If SoapMsg='' then
 Begin
  ShowMessage('No data available for submission');
  Exit;
 end;
 SubmitSoapMsg(SoapMsg,flName);
end;

Procedure TPreValidateEfileT2_2027.SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
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
 DOMDocument:IXMLDOMDocument; TrackNodes: IXMLDOMNodeList;  //20110129
 ResponseXmlFile:String;
 ConfirmationNumber:String;
 //T1135ResponseRec:T1135AckRec;
 PreValResponseHTM:string;
Begin


{
 //jz
 With AckRecT1135 do //initialize to blank
 Begin

   Name                 := '';
   DateTimeReceived     := '';
   TransmitterID        := '';
   ConfirmationID       := '';
   Response             := '';
   ResponseCode         := '';
   ResponseText         := '';
   additionalText       := '';
   T1135resultType      := T1135accepted;
 End;
}

 //define
  ObjHTTP := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
 //open it
 ObjHTTP.open('POST', sURL, False, OnlineNo, Password);   //20110120

 ObjHTTP.setRequestHeader('SOAPAction', 'NA'); //set action?
 objHTTP.setRequestHeader('Content-Type','text/xml; charset=UTF-8'); //added encoding //20150206
 //ShowHTTPStatus(ObjHTTP.ReadyState);
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

 //h := ShellExecute(MainForm.Handle,'open',Pchar(''+ResponseXmlFile),Nil,Nil,Sw_Show);

 If EfileOptionGroup.ItemIndex=0 then  //single return
 Begin

   parsePreValResponse(WString); //T1135ResponseRec := parsePreValResponse(WString);

   PreValResponseHTM := CreatePreValEfileResponseHtm(RetNo{,AppDir +'\'+ 'EFPreValResponseTemplate.htm'});

   h := ShellExecute(Self.Handle, nil, PChar('' + PreValResponseHTM), nil, nil, SW_NORMAL);

   If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');

 End;

 {
 else  //batch ???
 begin
  h := ShellExecute(MainForm.Handle,'open',Pchar(''+ResponseXmlFile),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');
 end;
 }

 //succesful transmission
 If EfileOptionGroup.ItemIndex=0 then  //single return
 Begin
  s:=MkSubmittedFileName(RetNo);
  If FileExists(s) then RenameFile(s,ReplaceStr(S, 'ToBeSubmitted', 'Submitted')); //rename it
 end;


 objHttp:=Nil;  //20110129  .Free It is not accepted

end;


procedure TPreValidateEfileT2_2027.FormActivate(Sender: TObject);
begin
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120
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
  If RetNo=0 then  //no return opened defaults to batch
  Begin
    EfileOptionGroup.ItemIndex:=1;
    Exit;
  end;
  {
  //Return exists
  If (RetNo>0) and (EfileOptionGroup.ItemIndex=0) then   //current return
  //??   CreatePreValSoapMessage(RetNo,EolTaxFlName,ProdOrTest,OnLineMethod:String);
  }
end;

procedure TPreValidateEfileT2_2027.ShowXMLBtnClick(Sender: TObject);
Var h:THandle; FlName:String;
begin
  //flName:=MkSubmittedFileName(RetNo);
  flName:= CreatePreValSoapMessage(RetNo);
  h := ShellExecute(Self.Handle,'open',Pchar(''+flName),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('File not found');
end;

procedure TPreValidateEfileT2_2027.FormPaint(Sender: TObject);
begin
 If EfileOptionGroup.ItemIndex=0 then
  BatchPanel.Visible:=False
 Else
  BatchPanel.Visible:=True;

 If EfileOptionGroup.ItemIndex=1 then ShowFiles;
end;

procedure TPreValidateEfileT2_2027.EfileOptionGroupClick(Sender: TObject);
begin

 If (RetInMem>0) and (EfileOptionGroup.ItemIndex=1) then
 begin
  Exit;
 end;

 If (LicenseLevel <> llPower) and (EfileOptionGroup.ItemIndex=1) then
 Begin
  ShowMessage('Batch T1135 submission is only available in the T1-Power version');
  Exit;
 End;
 FormPaint(Sender);
end;

procedure TPreValidateEfileT2_2027.DBGrid1DblClick(Sender: TObject);
Var i:Integer; FlName:String;
SomeList:TStringList;
begin
end;

procedure TPreValidateEfileT2_2027.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TPreValidateEfileT2_2027.RemoveBtnClick(Sender: TObject);
begin
ListBox1DblClick(Sender);
end;


procedure TPreValidateEfileT2_2027.BitBtn2Click(Sender: TObject);
begin
ListBox1.Clear;
end;

Function TPreValidateEfileT2_2027.MkSelectedStr: String;
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



procedure TPreValidateEfileT2_2027.ListBox1DblClick(Sender: TObject);
begin
 ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TPreValidateEfileT2_2027.ShowFiles;
//20160120 Igor
var DataBaseName: string;
begin
 DataDirBox.Text := OptRec.Dir_Cur;
 DataBaseName := OptRec.Dir_Cur + '\' + ClientsDBLite;
 If Not FileExists(DataBaseName) then
 begin
  ShowMessage('There is no Clients data base in this directory'+
    Chr(13)+'Use Configure | Data Directories');
    exit;
 end;

 SetTableName(FDConnection, Table1, DataBaseName, ClientsTableLite, 'LAST_Name');

 Screen.Cursor := crDefault;
 If Table1.RecordCount = 0 then
 begin
  ShowMessage('DataBase is empty. Press Close');
  exit;
 end;
 DBGrid1.Update;
end;


Function TPreValidateEfileT2_2027.MkSubmittedFileName(RetNo:Integer):String;
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
 If EfileOptionGroup.ItemIndex=0 then
  result:=PreValEfileDir+'\'+'PreVal-ToBeSubmitted-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml'  //20160526
 Else
 Begin
  s:=FormatDateTime('yyyy-mm-dd',Date)+'-'+GetMinutesAndSeconds;
  result:=PreValEfileDir+'\'+'PreVal-Submitted-Batch'+'-'+S+'.xml';
 end;
end;

Function TPreValidateEfileT2_2027.MkResponseFileName(RetNo:Integer):String;
begin
 result:=PreValEfileDir+'\'+'PreVal-Response-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml';  //20160526
end;

procedure TPreValidateEfileT2_2027.GetUrlBox;
begin
 //20150102
 If TestOrProductionGroup.ItemIndex=0 then  //production
   sUrl :='https://apps.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl' //sUrl :='https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'
 else  //test
   sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/tgif/t2ws/services/T2FileReturnService?wsdl'; //sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';

  UrlBox.Text := SUrl;

end;

procedure TPreValidateEfileT2_2027.TestOrProductionGroupClick(Sender: TObject);
begin
GetUrlBox;
end;

procedure TPreValidateEfileT2_2027.viewErrorCluesBtnClick(Sender: TObject);
begin
// MainForm.T1135EfileErrors1Click(Sender);
end;


procedure TPreValidateEfileT2_2027.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;



procedure TPreValidateEfileT2_2027.instalMSXMLbtnClick(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;



Function TPreValidateEfileT2_2027.parsePreValResponse(rString:AnsiString):TPreValAckRec; //T1135AckRec;

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



    With PreValRec do
    begin

      Name             := GetCorpName(RetNo);
      BnNumber         := GetCorpBusNo(RetNo);
      TxYear           := inttostr(GetTaxationYearEndYYYY(RetNo));

      DateTimeReceived := xmlTagValue('<tgif:TimestampDateTime>',rString); //leftstr(xmlTagValue('<tgif:TimestampDateTime>',rString),10);
      if DateTimeReceived = '' then
      begin
        today := Now;
        DateTimeReceived := '(local) ' + DateToStr(today) + ' ' + TimeToStr(today);
      end;
      ResponseCode     := '';
      ResponseText     := '';

      //Proper Response -------------------------------------------------------------
      if xmlTagExists('<tgif:PreValidationSuccessful>',rString) then
      begin
        //Successful Response -------------------------------------------------------------
        if xmlTagValue('<tgif:PreValidationSuccessful>',rString) = 'true' then
        begin
          PreValresultType := PreValSuccess;
        end
        //Error Response ------------------------------------------------------------------
        else if xmlTagValue('<tgif:PreValidationSuccessful>',rString) = 'false' then
        begin
          PreValresultType := PreValRejected;
          ResponseCode     := xmlTagValue('<tgif:ErrorCode>',rString);
          ResponseText     := xmlTagValue('<tgif:EnglishMessageText xml:lang="en">', '</tgif:EnglishMessageText>',rString);
        end;
      end

      //SOAP Fault Error ----------------------------------------------------------------
      else if xmlTagExists('<faultcode>',rString) then
      begin
        PreValresultType := PreValWebServiceError;
        ResponseCode     := xmlTagValue('<faultcode>',rString);
        ResponseText     := xmlTagValue('<faultstring>',rString);
      end

      //something not accounted for
      else
      begin
        PreValresultType := PreValUnknownError;
        ResponseCode     := 'vtError';
        ResponseText     := 'Unknown response file format';
      end;



    end;

end;


procedure TPreValidateEfileT2_2027.testResponseClick(Sender: TObject);
var
    tempResponseList:tstringlist;
    AckResponseFlName,  PreValResponseHTM, ResponseXmlFile:string;
    //T1135ResponseRec:T1135AckRec;
begin
 OpenDialog1.FileName := '*Response*';
 //OpenDialog1.FileName := '';

 OpenDialog1.InitialDir:= PreValEfileDir; //NetFileDir;
 OpenDialog1.Filter := 'XML files (*.xml)|*.xml|'+
                       'Any (*.*)|*.*';
 If OpenDialog1.Execute then
 begin
   tempResponseList := TStringList.Create;
   tempResponseList.loadFromFile(OpenDialog1.FileName);

   parsePreValResponse(tempResponseList.text); //T1135ResponseRec := parsePreValResponse(tempResponseList.text);

   PreValResponseHTM := CreatePreValEfileResponseHtm(RetNo{,AppDir +'\'+ 'EFT1135ResponseTemplate.htm'});

   If FileExists(PreValResponseHTM) then
    ShellExecute(Self.Handle, nil, PChar('' + PreValResponseHTM), nil, nil, SW_NORMAL);

 end;
end;

//20160124
Function TPreValidateEfileT2_2027.ConvertCheckBoxTo1(S:String):String;  //20160124
Begin
 Result:='0';//20160624
 If UpperCase(s)='X' then result:='1';
end;



Function TPreValidateEfileT2_2027.CreatePreValSoapMessage(RetNo:Integer):String; //procedure TPreValidateEfileT2_2027.CreatePreValSoapMessage(RetNo:Integer);
Const Format1='########0';  //20150221
Var
i,Elm,PreValFNo:Integer; cd:String; //code
s,FlName:String;
DcnSeqNo:String;
begin

 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 setwebServiceUserNamePassword(webServiceUserName,webServicePassword);

 XmlList:=TstringList.Create;
 XmlList.Clear;

 PreValFNo:=GetFormNo('T2');

 With XmlList do
 Begin
   add('<?xml version="1.0" encoding="UTF-8"?>');
   add('	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tgif="http://www.cra-arc.gc.ca/xmlns/tgif">');
   add('  <soapenv:Header>');
   add('    <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">');
   add('      <wsse:UsernameToken>');
   add('        <wsse:Username>'+ webServiceUserName +'</wsse:Username>'); //Mandatory
   add('        <wsse:Password>'+ webServicePassword +'</wsse:Password>'); //Mandatory
   add('      </wsse:UsernameToken>');
   add('    </wsse:Security>');
   add('  </soapenv:Header>');
   add('  <soapenv:Body>');
   add('    <tgif:preValidate>');
   add('      <tgif:BusinessNumber>'+ GetCorpBusNo(RetNo) +'</tgif:BusinessNumber>'); //Mandatory

   //Mandatory
              s:=FetchElmFNo(RetNo,PreValFNo,10);
   add('      <tgif:TaxationYearStartDate>'+ ReplaceChar(s,'/','-') +'</tgif:TaxationYearStartDate>');

   s:=FetchElmFNo(RetNo,PreValFNo,177);
   if s>'' then
   add('      <tgif:TaxationYearStartTime>'+ s +'</tgif:TaxationYearStartTime>');

   //Mandatory
              s:=FetchElmFNo(RetNo,PreValFNo,11);
   add('      <tgif:TaxationYearEndDate>'+ ReplaceChar(s,'/','-') +'</tgif:TaxationYearEndDate>');

   s:=FetchElmFNo(RetNo,PreValFNo,207);
   if s>'' then
   add('      <tgif:TaxationYearEndTime>'+ s +'</tgif:TaxationYearEndTime>');


   s:=RsiApprovalCode;
   add('      <tgif:SoftwareID>'+ s +'</tgif:SoftwareID>'); //Mandatory
   //add('      <tgif:SoftwareID>'+ RsiApprovalCode +'</tgif:SoftwareID>'); //Mandatory

   add('      <tgif:BusinessName>'+ ReplaceXmlChars(GetCorpName(RetNo)) +'</tgif:BusinessName>');


   //Head Office address---------------------------
   add('      <tgif:ClientAddress>');
   add('        <tgif:ClientAddressTypeCode>'+ 'HO' +'</tgif:ClientAddressTypeCode>');

   s := FetchElmFNo(RetNo,PreValFNo,8);
   if uppercase(s) = 'X' then s:='true' else s:='false';
   add('        <tgif:ClientAddressChangedIndicator>'+ s +'</tgif:ClientAddressChangedIndicator>');
   if s = 'true' then
   begin
     add('        <tgif:ClientAddressLine1>'+            ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,12)) +'</tgif:ClientAddressLine1>');
     add('        <tgif:ClientAddressLine2>'+            ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,13)) +'<tgif:ClientAddressLine2>');
     add('        <tgif:ClientAddressMunicipalityName>'+ ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,16)) +'</tgif:ClientAddressMunicipalityName>');
     add('        <tgif:ClientAddressProvinceCode>'+     FetchElmFNo(RetNo,PreValFNo,17) +'</tgif:ClientAddressProvinceCode>');
     add('        <tgif:ClientAddressCountryCode>'+      FetchElmFNo(RetNo,PreValFNo,19) +'</tgif:ClientAddressCountryCode>');
     add('        <tgif:ClientAddressPostalCode>'+       FetchElmFNo(RetNo,PreValFNo,20) +'</tgif:ClientAddressPostalCode>');
   end;
   add('      </tgif:ClientAddress>'); //end Head Office address---------------------------

   //Mailing address---------------------------
   add('      <tgif:ClientAddress>');
   add('        <tgif:ClientAddressTypeCode>'+ 'MA' +'</tgif:ClientAddressTypeCode>');

   s := FetchElmFNo(RetNo,PreValFNo,21);
   if uppercase(s) = 'X' then s:='true' else s:='false';
   add('        <tgif:ClientAddressChangedIndicator>'+ s +'</tgif:ClientAddressChangedIndicator>');
   if s = 'true' then
   begin
     add('        <tgif:ClientAddressLine1>'+            ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,26)) +'</tgif:ClientAddressLine1>');
     add('        <tgif:ClientAddressLine2>'+            ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,27)) +'<tgif:ClientAddressLine2>');
     add('        <tgif:ClientAddressMunicipalityName>'+ ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,32)) +'</tgif:ClientAddressMunicipalityName>');
     add('        <tgif:ClientAddressProvinceCode>'+     FetchElmFNo(RetNo,PreValFNo,33) +'</tgif:ClientAddressProvinceCode>');
     add('        <tgif:ClientAddressCountryCode>'+      FetchElmFNo(RetNo,PreValFNo,34) +'</tgif:ClientAddressCountryCode>');
     add('        <tgif:ClientAddressPostalCode>'+       FetchElmFNo(RetNo,PreValFNo,35) +'</tgif:ClientAddressPostalCode>');
   end;
   add('      </tgif:ClientAddress>');  //end Mailing address---------------------------

   //Books & Records address---------------------------
   add('      <tgif:ClientAddress>');
   add('        <tgif:ClientAddressTypeCode>'+ 'BR' +'</tgif:ClientAddressTypeCode>');
   s := FetchElmFNo(RetNo,PreValFNo,67);
   if uppercase(s) = 'X' then s:='true' else s:='false';
   add('        <tgif:ClientAddressChangedIndicator>'+ s +'</tgif:ClientAddressChangedIndicator>');
   if s = 'true' then
   begin
     add('        <tgif:ClientAddressLine1>'+            ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,38)) +'</tgif:ClientAddressLine1>');
     add('        <tgif:ClientAddressLine2>'+            ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,41)) +'<tgif:ClientAddressLine2>');
     add('        <tgif:ClientAddressMunicipalityName>'+ ReplaceXmlChars(FetchElmFNo(RetNo,PreValFNo,44)) +'</tgif:ClientAddressMunicipalityName>');
     add('        <tgif:ClientAddressProvinceCode>'+     FetchElmFNo(RetNo,PreValFNo,45) +'</tgif:ClientAddressProvinceCode>');
     add('        <tgif:ClientAddressCountryCode>'+      FetchElmFNo(RetNo,PreValFNo,46) +'</tgif:ClientAddressCountryCode>');
     add('        <tgif:ClientAddressPostalCode>'+       FetchElmFNo(RetNo,PreValFNo,47) +'</tgif:ClientAddressPostalCode>');
   end;
   add('      </tgif:ClientAddress>'); //end Books & Records address---------------------------

   if      FetchElmFNo(RetNo,PreValFNo,51) = 'X' then s := '1'
   else if FetchElmFNo(RetNo,PreValFNo,56) = 'X' then s := '2'
   else if FetchElmFNo(RetNo,PreValFNo,59) = 'X' then s := '3'
   else if FetchElmFNo(RetNo,PreValFNo,52) = 'X' then s := '4'
   else if FetchElmFNo(RetNo,PreValFNo,57) = 'X' then s := '5'
   else s := '';
   add('      <tgif:CorporationTypeCode>'+ s +'</tgif:CorporationTypeCode>');

   if FetchElmFNo(RetNo,PreValFNo,14) = 'X' then s := 'true' else s := 'false';
   add('      <tgif:BusinessAcquistionControlIndicator>'+ s +'</tgif:BusinessAcquistionControlIndicator>');

   if FetchElmFNo(RetNo,PreValFNo,69) = 'X' then s := 'true' else s := 'false';
   add('      <tgif:BusinessDeemedTaxYearIndicator>'+ s +'</tgif:BusinessDeemedTaxYearIndicator>');

   if FetchElmFNo(RetNo,PreValFNo,30) = 'X' then s := 'true' else s := 'false';
   add('      <tgif:BusinessAmalgamationFirstYearIndicator>'+ s +'</tgif:BusinessAmalgamationFirstYearIndicator>');

   if FetchElmFNo(RetNo,PreValFNo,39) = 'X' then s := 'true' else s := 'false';
   add('      <tgif:BusinessAmalgamationFinalYearIndicator>'+ s +'</tgif:BusinessAmalgamationFinalYearIndicator>');

   {
   //could not find
   ???if FetchElmFNo(RetNo,PreValFNo,) = 'X' then s := 'true' else s := 'false';
   ???add('      <tgif:AccountAlertsRegistrationIndicator>'+ ??? +'</tgif:AccountAlertsRegistrationIndicator>'); //Schedule 200, line 88
   ???add('      <tgif:AccountAlertEmailAddress>'+ ??? +'</tgif:AccountAlertEmailAddress>');                     //Schedule 200, line 89
   }

   s := FetchElmFNo(RetNo,PreValFNo,737);
   if s > '' then
     add('      <tgif:DirectDepositBranchNumber>'+ s +'</tgif:DirectDepositBranchNumber>');

   s := FetchElmFNo(RetNo,PreValFNo,738);
   if s > '' then
     add('      <tgif:DirectDepositInstitutionNumber>'+ s +'</tgif:DirectDepositInstitutionNumber>');

   s := FetchElmFNo(RetNo,PreValFNo,739);
   if s > '' then
     add('      <tgif:DirectDepositAccountNumber>'+ s +'</tgif:DirectDepositAccountNumber>');

   //???add('      <tgif:BusinessReturnAmendmentIndicator>'+ ??? +'</tgif:BusinessReturnAmendmentIndicator>');  //Schedule 200, line 997

   add('    </tgif:preValidate>');
   add('  </soapenv:Body>');
   add('</soapenv:Envelope>');
 end; //With XmlList

 //jz 20160617
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


Function TPreValidateEfileT2_2027.CreatePreValEfileResponseHtm(RetNo: Integer{; AckRec: T1135AckRec; HtmFile: String}):String; //20160523 Igor
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

  htmlSource.add('<html><head><title>PreValidate - '+  PreValRec.Name +', '+ PreValRec.BNnumber +'</title></head>');

  if PreValRec.PreValresultType = PreValSuccess then
  begin
    fontColor := 'green';
    s := 'Successful';
  end
  else
  begin
    fontColor := 'red';
    s := 'Failed';
  end;

  htmlSource.add('<h3>'+PreValRec.TxYear+'</h3>');
  htmlSource.add('<h4>'+PreValRec.Name+'<br>');
  htmlSource.add(       PreValRec.BNnumber+'</h4>');
  htmlSource.add('<h2><font color="'+ fontColor +'"><strong>Prevalidation '+s+'</strong></font></h1>');


  if PreValRec.PreValresultType <> PreValSuccess then
  begin
   //htmlSource.add('<br>');
   htmlSource.add('<h4>Error Code: ' + PreValRec.ResponseCode + '<br>');
   htmlSource.add('   Error Message: ' + PreValRec.ResponseText + '</h4>');
  end;


  htmlSource.add('<h4>Acknowledgement received: '+ PreValRec.DateTimeReceived +'</h4><br><hr>');

  htmlSource.add('</body></html>');


  //----------------------------------------------------------------

  flName := PreValEfileDir+'\'+ GetLastName(RetNo)+' '+GetFirstName(RetNo) + '-PreValEFileAck.htm';
  htmlSource.SaveToFile(flName);
  htmlSource.Free;

  result := flName;   //jz

end;

Function TPreValidateEfileT2_2027.ReplaceXMLChars(info: String): String;
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
procedure TPreValidateEfileT2_2027.setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);
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

