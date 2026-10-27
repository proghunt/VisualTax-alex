unit T3_2026t106efile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl, Db, DBTables, Grids, DBGrids,
  T3_2026TrimStr, T3_2026Declare, T3_2026Common, T3_2026Common2,
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, System.IOUtils;

const
  SOFTRELEASEYEAR = '2025';
  SOFTRELEASEMONTH = '06';
  SOFTRELEASEDAY = '01';
  CrLf =  Chr(13) + Chr(10);
  useEfilerNumber = 0;
  useWAC = 1;

type
  TT106resultType = (T106accepted, T106rejected, T106Delayed, T106webserviceError);
  T106AckRec = Record
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
  TT106EfileT3_2026 = class(TForm)
    EfileType: TPanel;
    SubmitBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ShowBtn: TBitBtn;
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
    SearchBox: TEdit;
    Label17: TLabel;
    BitBtn4: TBitBtn;
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
    sendCredentials: TRadioGroup;

    Function ReplaceXMLChars(info: String): String;  //20161213
    Function ConvertCheckBoxTo1(S:String):String;  //20160124
    Function ConvertCheckBoxTo0(S:String):String;  //20180706
    procedure CreateT106SoapMessage(RetNo:Integer);
    procedure GetUrlBox;
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Procedure SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
    Function parseT106Response(rString:AnsiString):T106AckRec;
    Function CreateT106EfileResponseHtm(RetNo: Integer; AckRec: T106AckRec; HtmFile: String):String;
    procedure FormActivate(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure EfileOptionGroupClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    Function  MkSelectedStr: String;
    procedure ListBox1DblClick(Sender: TObject);
    procedure ShowFiles;
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
  private
    { Private declarations }
    RetNo:Integer;   //20160120 Igor
  public
    { Public declarations }
  end;

var
  T106Efile: TT106EfileT3_2026;
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

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T3_2026, T3_2026main,
  vtShared, vtDynData{,childwinnew} //20150120 Igor
  , vtShowMessageHTML;//, uXMLValidator; //20250806 Igor

{$R *.DFM}

procedure TT106EfileT3_2026.FormCreate(Sender: TObject);
var
  TempList: TStringList;
begin
  RetNo:= GetCurrentRetNo;

  sendCredentials.ItemIndex := useEfilerNumber;
  if not GetWacNumber(RetNo).IsEmpty then
    sendCredentials.ItemIndex:= useWAC;

  GetEOLParms(OnlineNo, Password, Url, NetFileDir);    //20240223 Igor
  T106EfileDir:=TPath.Combine(NetFileDir, 'T106Efile'); //20240222 Igor
  If DirectoryExists(T106EfileDir) = false then ForceDirectories(T106EfileDir);
  TestOrProductionGroup.itemindex:= 0;  //20180824 CON default To production
  //if TestOrProductionGroup.visible = true then TestOrProductionGroup.itemindex := 1;  //20130212

  If RetNo>0 then
  begin
    If ValidForT106Efile(RetNo,GetFormNo('T106')) = false then  //20170629
    Begin  SoapMsg:='';  Exit; End;
  end;
  CreateT106SoapMessage(RetNo);
end;

procedure TT106EfileT3_2026.SubmitBtnClick(Sender: TObject);
// 20250806 Igor >>>
var
  RetNo: Integer;
  FlName: String;
  lXMLValidationErrorList: TStringList;
  ifor: Integer;
  lErrorsString: string;
  lXSDFilesList: TStringList;
  // 20250806 Igor <<<
begin
 If ValidPostal(RetNo,OptRec.Prp_Postal) = false then
 begin
  ShowMessage('Please fix the Postal code in Configure -> General Options -> Preparer');
  Exit;
 end;
  //20150207
 RetNo:=GetCurrentRetNo;
 FlName:=MkSubmittedFileName(RetNo);
 CreateT106SoapMessage(RetNo);

 // 20260817 Alex >>>
 {lXMLValidationErrorList:= TStringList.Create;
 lXSDFilesList:= TStringList.Create;
 try
   lXSDFilesList.Add('http://www.w3.org/XML/1998/namespace,xml.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0,standarddatatypes.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0,cracommonstructures.xsd');
   lXSDFilesList.Add('urn:oecd:ties:isocbctypes:v1,isocbctypes_v1.1.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/cbc/2019/1-0-0,CountryByCountryReport2019.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/comm/2025/1-0-0,electronicfilingcommon.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/ef/2025/1-0-0,efilecommon.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0,ForeignIncomeVerificationStatement.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t1134/2021/1-0-0,ControlledAndNotControlledForeignAffiliateReturn2021.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t106/2025/1-0-0,NonArmsLengthTransactionWithNonResidentInformationReturn.xsd');
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t3rq/t3efilerequest/1-0-0,t3efilefrrmsrequest.xsd');

   //TXMLValidator.XMLValidate(AppDir, lXSDFilesList, MkSubmittedFileName(RetNo), lXMLValidationErrorList);
   TXMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)) + T3_2026Declare.AppName + '-' + T3_2026Declare.AppYear, lXSDFilesList, MkSubmittedFileName(RetNo), lXMLValidationErrorList);

   if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
   begin
     TXMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
     Exit;
   end;
 finally
   lXMLValidationErrorList.Free;
   lXSDFilesList.Free;
 end;  }
 // 20260817 Alex <<<

 //  --------------
 If SoapMsg='' then
 Begin
  ShowMessage('No data available for submission');
  Exit;
 end;
 SubmitSoapMsg(SoapMsg,MkSubmittedFileName(RetNo));
end;

procedure TT106EfileT3_2026.SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
var
  i: Integer;
  WString: AnsiString;  //wide string
  objHttp: IxmlHttpRequest;
  Status: string;
  T106Msg: AnsiString;
  TempSoapList: TStringList;
  TempDataList: TStringList;
  h: THandle;
  s: string;
  AList: TStringList;
  DOMDocument: IXMLDOMDocument;
  TrackNodes: IXMLDOMNodeList;
  ResponseXmlFile: string;
  ConfirmationNumber: string;
  T106ResponseRec: T106AckRec;
  T106ResponseHTM: string;
begin
  with AckRecT106 do //initialize to blank
  begin
    Name:= '';
    DateTimeReceived:= '';
    TransmitterID:= '';
    ConfirmationID:= '';
    Response:= '';
    ResponseCode:= '';
    ResponseText:= '';
    additionalText:= '';
    T106resultType:= T106accepted;
  end;

  //define
  ObjHTTP:= CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
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

  if EfileOptionGroup.ItemIndex=0 then  //single return
  begin
    T106ResponseRec := parseT106Response(WString);
    T106ResponseHTM := CreateT106EfileResponseHtm(RetNo,AckRecT106,AppDir +'\'+ 'EFT106ResponseTemplate.htm');

    if (AckRecT106.T106resultType=T106accepted){AckRec.Accepted} then
    begin
      //???????
      //StoreElm(RetNo,GetFormNo('T106'),39,AckRecT106.TransmitterID);   //20150207 //jz 20240624 wrong elm, is a checkbox
      StoreElm(RetNo,GetFormNo('T106'),64,AckRecT106.TransmitterID);   //20180824 Igor
      If not SaveReturn(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName,True,False) =0 then
                ShowMessage('Return cannot be saved'); //20150208
    end;
    //20250603 Igor >>>
    ShowMessageHTMLFromFile(T106ResponseHTM, 600, true);
    //   h := ShellExecute(Self.Handle, nil, PChar('' + T106ResponseHTM), nil, nil, SW_NORMAL);
    //   If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');
    //20250603 Igor <<<
  end else
  begin
    //20250603 Igor >>>
    ShowMessageHTMLFromFile(ResponseXmlFile, 600, true);
    //   h := ShellExecute(MainForm.Handle,'open',Pchar(''+ResponseXmlFile),Nil,Nil,Sw_Show);
    //   If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');
    //20250603 Igor <<<
  end;
  //succesful transmission
  if EfileOptionGroup.ItemIndex=0 then  //single return
  Begin
    s:=MkSubmittedFileName(RetNo);
    If FileExists(s) then RenameFile(s,ReplaceStr(S, 'ToBeSubmitted', 'Submitted')); //rename it
  end;

  objHttp:= Nil;  //20110129  .Free It is not accepted
  OpenForm(RetNo,'T106',0); //20180824 CON to refresh
end;

procedure TT106EfileT3_2026.FormActivate(Sender: TObject);
begin
  //GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120 //20240223 Igor
  GetUrlBox;
  If (Length(OnlineNo)<>5) or (Password='') then
  begin
   SoapMsg:='';
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT3.actSetupEOLExecute(Sender);
   Exit;
  end;

  SoapMsg:= '';

  RetNo:= GetCurrentRetNo;

  if RetNo = 0 then  //no return opened defaults to batch
  begin
    EfileOptionGroup.ItemIndex:= 1;
    Exit;
  end;
end;

procedure TT106EfileT3_2026.ShowBtnClick(Sender: TObject);
Var h:THandle; FlName:String;
begin
  FlName:=MkSubmittedFileName(RetNo);
  CreateT106SoapMessage(RetNo);
  h := ShellExecute(Self.Handle,'open',Pchar(''+FlName),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('File not found');
end;

procedure TT106EfileT3_2026.FormPaint(Sender: TObject);
begin
 If EfileOptionGroup.ItemIndex=0 then
  BatchPanel.Visible:=False
 Else
  BatchPanel.Visible:=True;

 If EfileOptionGroup.ItemIndex=1 then ShowFiles;
end;

procedure TT106EfileT3_2026.EfileOptionGroupClick(Sender: TObject);
begin

 If (RetInMem>0) and (EfileOptionGroup.ItemIndex=1) then
 begin
  Exit;
 end;

 If (LicenseLevel <> llPower) and (EfileOptionGroup.ItemIndex=1) then
 Begin
  ShowMessage('Batch T106 submission is only available in the T1-Power version');
  Exit;
 End;
 FormPaint(Sender);
end;

procedure TT106EfileT3_2026.DBGrid1DblClick(Sender: TObject);
Var i:Integer; FlName:String;
SomeList:TStringList;
begin
end;

procedure TT106EfileT3_2026.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TT106EfileT3_2026.RemoveBtnClick(Sender: TObject);
begin
ListBox1DblClick(Sender);
end;


procedure TT106EfileT3_2026.BitBtn2Click(Sender: TObject);
begin
ListBox1.Clear;
end;

Function TT106EfileT3_2026.MkSelectedStr: String;
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



procedure TT106EfileT3_2026.ListBox1DblClick(Sender: TObject);
begin
 ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TT106EfileT3_2026.ShowFiles;
var
  DataBaseName: string;
begin
  DataDirBox.Text := OptRec.Dir_Cur;
  DataBaseName := OptRec.Dir_Cur + '\' + ClientsDBLite;

  if Not FileExists(DataBaseName) then
  begin
    ShowMessage('There is no Clients data base in this directory' + Chr(13) + 'Use Configure | Data Directories');
    exit;
  end;

  SetTableName(FDConnection, Table1, DataBaseName, ClientsTableLite, 'LAST_Name');
  Screen.Cursor:= crDefault;

  if Table1.RecordCount = 0 then
  begin
    ShowMessage('DataBase is empty. Press Close');
    exit;
  end;

  DBGrid1.Update;
end;

function TT106EfileT3_2026.MkSubmittedFileName(RetNo:Integer):String;

  //embedded function
  function GetMinutesAndSeconds: string;  //function within function
  var
    SHours, SMinutes, SSeconds: string[2];
    Hour, Min, Sec, Msec: word;
  begin
    DecodeTime(Now, Hour, Min, Sec, Msec);
    sMinutes:= AllTrim(IntToStr(Min));
    sSeconds:= AllTrim(IntToStr(Sec));

    if Length(sMinutes) = 1 then SMinutes:= '0' + SMinutes;
    if Length(SSeconds) = 1 then SSeconds:= '0' + SSeconds;

    Result:= SMinutes + SSeconds;
  end;

var
  s: string;
begin
  if EfileOptionGroup.ItemIndex = 0 then
    Result:= T106EfileDir + '\' + 'T106-ToBeSubmitted-' + LeftStr(RemoveChar(GetRetName(RetNo), '.'), 30) + '-' + GetAccountNumber(RetNo) + '.xml'
  else
  begin
    s:= FormatDateTime('yyyy-mm-dd', Date) + '-' + GetMinutesAndSeconds;
    Result:= T106EfileDir + '\' + 'T106-Submitted-Batch' + '-' + S + '.xml';
  end;
end;

Function TT106EfileT3_2026.MkResponseFileName(RetNo:Integer):String;
begin
  result:= T106EfileDir + '\' + 'T106-Response-' + LeftStr(RemoveChar(GetRetName(RetNo), '.'), 30) + '-' + GetAccountNumber(RetNo) + '.xml';
end;

procedure TT106EfileT3_2026.GetUrlBox;
begin
  If TestOrProductionGroup.ItemIndex = 0 then  //production
    sUrl:= 'https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'
  else  //test
    sUrl:= 'https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';

  UrlBox.Text := SUrl;
end;

procedure TT106EfileT3_2026.TestOrProductionGroupClick(Sender: TObject);
begin
  GetUrlBox;
end;

procedure TT106EfileT3_2026.BitBtn3Click(Sender: TObject);
begin
//
end;

procedure TT106EfileT3_2026.SearchBoxChange(Sender: TObject);
begin
  Table1.Locate('LAST_NAME', SearchBox.Text, [loCaseInsensitive, loPartialKey]);
end;

procedure TT106EfileT3_2026.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;

procedure TT106EfileT3_2026.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

Function TT106EfileT3_2026.parseT106Response(rString:AnsiString):T106AckRec;

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
  i, k, sPos, ePos, FNo: Integer;
  s, e, fCode, fString, messageString, idstring, TimeReceived, tempString: string;
  ReturnedTransmissionID, ReturnedEfilerNumber, ReturnedControlNumber: String;
  ReturnedCorpName, ReturnedBnNumber, ReturnedTaxYr: string;
  searchStringAdjustment: string;
begin
  AckRecT106.T106resultType:= T106rejected;
  //server error -------------------------------------------------------------
  s:= '<faultcode>';
  sPos:= pos(s, rString);

  if sPos > 0 then
  begin
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
  end else
  begin
    searchStringAdjustment:= '>';
    if sendCredentials.ItemIndex = useWAC then //jz 20240711
      searchStringAdjustment:= ' xmlns:t3ersp="http://www.cra-arc.gc.ca/xmlns/t3ersp/t3efilefrrmsresponse/1-0-0">'; //s := '<t3ersp:T3ResultCode xmlns:t3ersp="http://www.cra-arc.gc.ca/xmlns/t3ersp/t3efilefrrmsresponse/1-0-0">';

    //Get result code ------------------------------------------------------------------
    s := '<t3ersp:T3ResultCode'+searchStringAdjustment;
    sPos := pos(s,rString);
    if sPos > 0 then
    begin
      e     := '</t3ersp:T3ResultCode>';
      sPos  := pos(s,rString) + length(s);
      ePos  := pos(e,rString);
      fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
      //AckRecT106.ResponseCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
      //Get Transmission Number (filename/confirmation number) if exists
      // ------------------------------------------------------------------
      s := '<t3ersp:T3TransmissionNumber'+searchStringAdjustment;
      sPos := pos(s,rString);
      if sPos > 0 then
      begin
        e     := '</t3ersp:T3TransmissionNumber>';
        sPos  := pos(s,rString) + length(s);
        ePos  := pos(e,rString);
        ReturnedTransmissionID := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
        //AckRecT106.TransmitterID := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
      end;

      s := '<t3ersp:TrustName'+searchStringAdjustment;
      sPos := pos(s,rString);
      if sPos > 0 then
      begin
        e     := '</t3ersp:TrustName>';
        sPos  := pos(s,rString) + length(s);
        ePos  := pos(e,rString);
        ReturnedCorpName := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
        //AckRecT106.Name := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
      end;

      s := '<t3ersp:TrustNumber'+searchStringAdjustment;
      sPos := pos(s,rString);
      if sPos > 0 then
      begin
        e     := '</t3ersp:TrustNumber>';
        sPos  := pos(s,rString) + length(s);
        ePos  := pos(e,rString);
        ReturnedBnNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
        //AckRecT106.BnNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
      end;

      s := '<t3ersp:TaxYear'+searchStringAdjustment;
      sPos := pos(s,rString);
      if sPos > 0 then
      begin
        e     := '</t3ersp:TaxYear>';
        sPos  := pos(s,rString) + length(s);
        ePos  := pos(e,rString);
        ReturnedTaxYr := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
        //AckRecT106.TxYear:= AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
      end;

      //get message is still t1rsp: even though for t3 jz???
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
      end else         //else error ------------------------------------------------------------------
      begin
        //AckRec.EFresultType := EFrejected;  //20140124
        AckRecT106.T106resultType := T106rejected; //jz
        //find error clues if any
        fString := '';

        messageString := 'Submission Failed' + chr(10) + chr(13) + chr(10) + chr(13) + 'Result Code: ' + fCode;
      end;
    end else // no <t3ersp:T3ResultCode> found
    begin
      // jz??? not needed? Probably doesnt work???
      s:= '<resultCode xsi:type="xsd:string">';
      sPos:= pos(s,rString);
      if sPos > 0 then
      begin
        e:= '</resultCode>';
        sPos:= pos(s,rString) + length(s);
        ePos:= pos(e,rString);
        fCode:= AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        if (fCode = '180') or (fCode = '182') then AckRecT106.T106resultType:= T106accepted;//AckRec.EFresultType := EFAccepted;

        if fCode = '132' then
        begin
          //AckRec.EFresultType := EFrejected;
          AckRecT106.T106resultType:= T106rejected; //jz
        end;
      end;
    end
  end; //else not servererror

  with AckRecT106 do
  begin
    Name             := ReturnedCorpName;
    BnNumber         := ReturnedBnNumber;
    TransmitterID    := ReturnedTransmissionID;
    TxYear           := ReturnedTaxYr;
    ResponseCode     := fCode;
    ResponseText     := AckRecResultDescription;
    DateTimeReceived := FormatDateTime('yyyy-mm-dd',Date)+ '  '+GetTimeToMilliSec(Date);//FormatDateTime('yyyy-mm-dd',Date);

    if T106resultType <> T106accepted then // these are not sent currently on rejected submissions for some reason
    begin
      Name:= GetRetName(RetNo);
      BnNumber:= GetAccountNumber(RetNo);
      TxYear:= GetYearEnd(RetNo);
    end;
  end;
end;

procedure TT106EfileT3_2026.testResponseClick(Sender: TObject);
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

//20160124
Function TT106EfileT3_2026.ConvertCheckBoxTo1(S:String):String;  //20160124
Begin
 Result:='0';//20160624
 If UpperCase(s)='X' then result:='1';
end;

Function TT106EfileT3_2026.ConvertCheckBoxTo0(S:String):String;
Begin
 Result:='1';
 If UpperCase(s)='X' then result:='0';
end;

procedure TT106EfileT3_2026.CreateT106SoapMessage(RetNo:Integer);
const
  Format1 = '########0';

var
  i, Elm, T106FNo, ArrayNo, BoxesPerRow, MaxRowsPerArray: Integer;
  cd: string;
  TempSoapList: TStringList;
  TempDataList: TStringList;
  s, s1, s2, s3, s4, FlName: string;
  DcnSeqNo: string;
  BN, WACnum, PrivacyAgreementInd: string;
  XmlList:TStringList; //used to create contents of Xml for a single return
begin
  //tax years startying 2021 or later use the new format
  T106FNo:= GetFormNo('T106');
  MaxRowsPerArray:= 80;

  Indent1:= 3;
  Indent2:= Indent1 + 3;
  Indent3:= Indent2 + 3;
  Indent4:= Indent3 + 3;
  Indent5:= Indent4 + 3;
  Indent6:= Indent5 + 3;
  Indent7:= Indent6 + 3;
  Indent8:= Indent7 + 3;
  Indent9:= Indent8 + 3;
  Indent10:= Indent9 + 3;
  Indent11:= Indent10 + 3;

  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  XmlList:= TStringList.Create;
  try
    XmlList.Clear;

    with XmlList do
    begin
      //add('<?xml version="1.0" encoding="UTF-8"?>');
      add('<?xml version="1.0" encoding="ISO-8859-1"?>');
      add('<soapenv:Envelope'                                                    + ' ' + #13#10 +
          'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'            + ' ' + #13#10 +
          'xmlns:t3rq="http://www.cra-arc.gc.ca/xmlns/t3rq/t3efilerequest/1-0-0">');

      //add('<soapenv:Header/>');

      add('<soapenv:Body>');

      //jz 20240711 different headers for Efile vs WAC
      if sendCredentials.ItemIndex = useEfilerNumber then
      begin
        //ef from 2024 to 0025 cz  //jz 20240624 from t2efrws_May24e.pdf
        add('<t3rq:T3EfileReturnRequest'                                            + ' ' + #13#10 +
            'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'                 + ' ' + #13#10 +
            'xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2025/1-0-0"'                + ' ' + #13#10 + // 20251104 Igor
            'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'                   + ' ' + #13#10 +
            //jz 20241126 updated for new 2025 T106
          //'xmlns:t106="http://www.cra-arc.gc.ca/xmlns/t106/2022/1-0-0"'            + ' ' + #13#10 +
            'xmlns:t106="http://www.cra-arc.gc.ca/xmlns/t106/2025/1-0-0"'            + ' ' + #13#10 +
            'xmlns:t3rq="http://www.cra-arc.gc.ca/xmlns/t3rq/t3efilerequest/1-0-0"'  + ' ' + #13#10 +
            'xmlns:xml="http://www.w3.org/XML/1998/namespace"'                       + ' ' + #13#10 +
            'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                  + ' ' + #13#10 +
            'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t3rq/t3efilerequest/1-0-0 t3efilefrrmsrequest.xsd">');


        add('<ef:TransmitterEfilerNumber>'+OnlineNo+'</ef:TransmitterEfilerNumber>');
        add('<ef:PasswordID>'+Password+'</ef:PasswordID>');

        //jz 20240723
        s := OptRec.Prp_RepId;
        If s>'' then
          add('<ef:RepresentativeID>'+ s +'</ef:RepresentativeID>');
         //add('<t3nrq:TaxYear>'+ '2024'+'</t3nrq:TaxYear>');   //TEMp 20250605

        add('<t3rq:TaxYear>' + GetYearEnd(RetNo) + '</t3rq:TaxYear>');
        add('<t3rq:SoftwareID>' + RsiApprovalCode + '</t3rq:SoftwareID>');
        add('<t3rq:TaxForm>');
      end
      else if sendCredentials.ItemIndex = useWAC then
      begin
        //jz 20240711 from t3nfrws_May24e.pdf
        add('<t3nrq:T3NetfileReturnRequest'                                           + ' ' + #13#10 +
            'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'                  + ' ' + #13#10 +
            'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'                    + ' ' + #13#10 +
            //jz 20241126 updated for new 2025 T106
            //'xmlns:t106="http://www.cra-arc.gc.ca/xmlns/t106/2022/1-0-0"'             + ' ' + #13#10 +
            'xmlns:t106="http://www.cra-arc.gc.ca/xmlns/t106/2025/1-0-0"'             + ' ' + #13#10 +
            'xmlns:t3nrq="http://www.cra-arc.gc.ca/xmlns/t3nrq/t3frrmsrequest/1-0-0"' + ' ' + #13#10 +
            'xmlns:xml="http://www.w3.org/XML/1998/namespace"'                        + ' ' + #13#10 +
            'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                   + ' ' + #13#10 +
            'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t3nrq/t3frrmsrequest/1-0-0 t3frrmsrequest.xsd">');

        BN:= FetchElm(RetNo, 'T106', 6);
        WACnum:= GetWacNumber(RetNo);
        privacyAgreementInd:= '1'; //jz 20250108 //should always be 1 as user should always agree with the privacy agreement  //According to the Schemas, values are 1 for "Yes", 2 for "No", and 0 for "Question not answered". //FetchElm(RetNo,'T1135',) //????

        add('<t3nrq:BusinessNumber>' + BN + '</t3nrq:BusinessNumber>');
        add('<t3nrq:WACNumber>' + WACnum + '</t3nrq:WACNumber>');
        add('<t3nrq:AgreementIndicator>' + privacyAgreementInd + '</t3nrq:AgreementIndicator>');
        add('<t3nrq:TaxYear>' + GetYearEnd(RetNo) + '</t3nrq:TaxYear>');
        add('<t3nrq:SoftwareID>' + RsiApprovalCode + '</t3nrq:SoftwareID>');
        add('<t3nrq:TaxForm>');
      end;

      {
      add('<t106:NonArmsLengthTransactionWithNonResidentInformationReturn'  + ' ' + #13#10 +
          'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'          + ' ' + #13#10 +
          'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'            + ' ' + #13#10 +
          'xmlns:t106="http://www.cra-arc.gc.ca/xmlns/t106/2017/1-0-1"'     + ' ' + #13#10 +
          'xmlns:xml="http://www.w3.org/XML/1998/namespace"'                + ' ' + #13#10 +
          'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'           + ' ' + #13#10 +
          'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t106/2017/1-0-1 NonArmsLengthTransactionWithNonResidentInformationReturn.xsd">');
      }

      add('<t106:NonArmsLengthTransactionWithNonResidentInformationReturn>');

      add('    <t106:NonArmsLengthWithNonResidentTransactionSummary>');
      add('        <t106:SummaryActionCode>'+ leftstr( FetchElm(RetNo,'T106',3),1 ) +'</t106:SummaryActionCode>');
      s:=FetchElm(RetNo,'T106',60);
      If s>'' then  add('        <t106:FunctionalCurrencyCode>'+ leftstr(s,3) +'</t106:FunctionalCurrencyCode>');
      add('        <t106:AmendedReturnIndicator>'+ ConvertCheckBoxTo1( FetchElm(RetNo,'T106',1) ) +'</t106:AmendedReturnIndicator>');
      add('        <t106:ReportingTaxpayerIdentification>');
      add('            <t106:Trust>');
      add('                <t106:TrustName>'+ ReplaceXMLChars( FetchElm(RetNo, 'T106', 14) ) +'</t106:TrustName>');
      add('                <ccms:TrustNumber>'+ FetchElm(RetNo, 'T106', 15) +'</ccms:TrustNumber>');
      add('            </t106:Trust>');
      add('        </t106:ReportingTaxpayerIdentification>');
      add('        <t106:ReportingTaxpayerAddress>');
      add('            <t106:AddressStreetText>'+ ReplaceXMLChars( FetchElm(RetNo,'T106',23) ) +'</t106:AddressStreetText>');
      add('            <t106:AddressMunicipalityName>'+ ReplaceXMLChars( FetchElm(RetNo,'T106',24) )+'</t106:AddressMunicipalityName>');
      add('            <t106:GlobalProvinceTerritoryStateCode>'+ FetchElm(RetNo,'T106',25) +'</t106:GlobalProvinceTerritoryStateCode>');
      add('            <t106:GlobalPostalZipCode>'+ RemoveChar(FetchElm(RetNo,'T106',26) , ' ') +'</t106:GlobalPostalZipCode>');
      add('            <t106:CountryCode>'+ leftstr( FetchElm(RetNo,'T106',2),3 )+'</t106:CountryCode>');
      add('        </t106:ReportingTaxpayerAddress>');
      add('        <t106:TaxationYearData>');
      s := FetchElm(RetNo,'T106',27);
      add('            <t106:TaxationYearStartDate>'+ ReplaceChar(s,'/','-') +'</t106:TaxationYearStartDate>');
      s := FetchElm(RetNo,'T106',28);
      add('            <t106:TaxationYearEndDate>'+ ReplaceChar(s,'/','-') +'</t106:TaxationYearEndDate>');
      add('        </t106:TaxationYearData>');

      s := ConvertCheckBoxTo0(FetchElm(RetNo,'T106',30));
      add('        <t106:FirstTimeFilerIndicator>'+ s +'</t106:FirstTimeFilerIndicator>');
      if s = '0' then
      begin
        s := FetchElm(RetNo,'T106',31);
        add('        <t106:LastReturnFilingPeriodEndDate>'+ ReplaceChar(s,'/','-') +'</t106:LastReturnFilingPeriodEndDate>');
      end;

      add('        <t106:DeclaredSlipCount>'+ FetchElm(RetNo,'T106',32) +'</t106:DeclaredSlipCount>');
      add('        <t106:SlipBoxTotalAmount>'+ FormatFloat(Format1,Round(Vl( FetchElm(RetNo,'T106',33) )))+'</t106:SlipBoxTotalAmount>');
{??? T3 haven't S125 form}      add('        <t106:ReportingTaxpayerGrossRevenueAmount>'+ FormatFloat(Format1,TotMultiple(RetNo,'S125',14)) +'</t106:ReportingTaxpayerGrossRevenueAmount>'); //20180705 gifi revenue
      add('        <t106:NorthAmericanIndustryClassificationSystem>');

      s:= FetchElm(RetNo,'T106',35);
      if s > '' then
        add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ leftstr(s,6) +'</t106:NorthAmericanIndustryClassificationSystemCode>');
      s:= FetchElm(RetNo,'T106',36);
      if s > ''  then
        add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ leftstr(s,6) +'</t106:NorthAmericanIndustryClassificationSystemCode>');
      s:= FetchElm(RetNo,'T106',37);
      if s > ''  then
        add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ leftstr(s,6) +'</t106:NorthAmericanIndustryClassificationSystemCode>');
      s:= FetchElm(RetNo,'T106',38);
      if s > ''  then
        add('            <t106:NorthAmericanIndustryClassificationSystemCode>'+ leftstr(s,6) +'</t106:NorthAmericanIndustryClassificationSystemCode>');

      add('        </t106:NorthAmericanIndustryClassificationSystem>');


      add('        <t106:AffectedReportedAmountCompetentAuthorityIndicator>'                  + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',39)) +'</t106:AffectedReportedAmountCompetentAuthorityIndicator>');
      add('        <t106:AdjustedReportedAmountForeignTaxAdministrationAssessmentIndicator>'  + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',41)) +'</t106:AdjustedReportedAmountForeignTaxAdministrationAssessmentIndicator>');

      //jz 20241126 removed from new 2025 T106
      //add('        <t106:InternationalAdvancedPricingArrangementUseIndicator>'                + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',43)) +'</t106:InternationalAdvancedPricingArrangementUseIndicator>');

      //jz 20241126 new for 2025 T106 -->

      //9.1
      add('        <t106:ReportingTaxpayerUltimateParentIndicator>' + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',65)) +'</t106:ReportingTaxpayerUltimateParentIndicator>');

      //9.2
      s:= FetchElm(RetNo,'T106',67);
      if s > ''  then
        add('        <t106:UltimateParentCountry>'                    + s +'</t106:UltimateParentCountry>');

      //10.1
      add('        <t106:ReportingTaxpayerMNEIndicator>'            + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',68)) +'</t106:ReportingTaxpayerMNEIndicator>');

      //10.2
      s:= FetchElm(RetNo,'T106',73);
      if s > ''  then
        add('        <t106:MNEName>'                                  + ReplaceXMLChars(s) +'</t106:MNEName>');

      //10.3
      add('        <t106:MNECbCRRequiredIndicator>'                 + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',70)) +'</t106:MNECbCRRequiredIndicator>');

      //10.4
      s:= FetchElm(RetNo,'T106',72);
      if s > ''  then
        add('        <t106:CbCRJurisdiction>'                         + s +'</t106:CbCRJurisdiction>');

      //jz 20241126 new for 2025 T106 <--

      s := ConvertCheckBoxTo1(FetchElm(RetNo,'T106',45));
      add('        <t106:ReportingTaxpayerFileOtherReturnIndicator>'+ s +'</t106:ReportingTaxpayerFileOtherReturnIndicator>');
      if s = '1' then
      begin
        add('        <t106:PrimaryAccount>');

        s := RemoveChar(FetchElm(RetNo,'T106',47), ' ');
        if s > '' then
          add('            <t106:PrimaryNRAccountNumber>'+ s +'</t106:PrimaryNRAccountNumber>'); //<t106:PrimaryAccountNumber>'+ s +'</t106:PrimaryAccountNumber>');
        s := RemoveChar(FetchElm(RetNo,'T106',74), ' ');
        if s > '' then
          add('            <t106:PrimaryNRAccountNumber>'+ s +'</t106:PrimaryNRAccountNumber>'); //<t106:PrimaryAccountNumber>'+ s +'</t106:PrimaryAccountNumber>');
        s := RemoveChar(FetchElm(RetNo,'T106',76), ' ');
        if s > '' then
          add('            <t106:PrimaryNRAccountNumber>'+ s +'</t106:PrimaryNRAccountNumber>'); //<t106:PrimaryAccountNumber>'+ s +'</t106:PrimaryAccountNumber>');

        s := RemoveChar(FetchElm(RetNo,'T106',48), ' ');
        if s > '' then
          add('            <t106:PrimaryRPAccountNumber>'+ s +'</t106:PrimaryRPAccountNumber>');
        s := RemoveChar(FetchElm(RetNo,'T106',75), ' ');
        if s > '' then
          add('            <t106:PrimaryRPAccountNumber>'+ s +'</t106:PrimaryRPAccountNumber>');
        s := RemoveChar(FetchElm(RetNo,'T106',77), ' ');
        if s > '' then
          add('            <t106:PrimaryRPAccountNumber>'+ s +'</t106:PrimaryRPAccountNumber>');

        add('        </t106:PrimaryAccount>');
      end;

      add('        <t106:ReportingTaxpayerNonResidentNonMonetaryConsiderationIndicator>'  + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',49)) +'</t106:ReportingTaxpayerNonResidentNonMonetaryConsiderationIndicator>');
      add('        <t106:ReportingTaxpayerNonResidentNilConsiderationIndicator>'          + ConvertCheckBoxTo1(FetchElm(RetNo,'T106',51)) +'</t106:ReportingTaxpayerNonResidentNilConsiderationIndicator>');

      add('        <t106:CertificationDetail>');
      add('            <t106:ContactPersonFirstName>'   + ReplaceXMLChars( FetchElm(RetNo,'T106',53) ) +'</t106:ContactPersonFirstName>');
      add('            <t106:ContactPersonLastName>'    + ReplaceXMLChars( FetchElm(RetNo,'T106',54) ) +'</t106:ContactPersonLastName>');
      //added parenthesis to area code //20171128 CON
      //20180705
      add('            <t106:ContactPersonPhoneNumber>' + '('+FetchElm(RetNo,'T106',55)+')'+FetchElm(RetNo,'T106',56)+'X'+FetchElm(RetNo,'T106',62)+'</t106:ContactPersonPhoneNumber>');
      add('            <t106:CertifierName>'            + ReplaceXMLChars( FetchElm(RetNo,'T106',57) ) +'</t106:CertifierName>');
      add('            <t106:CertificationDate>'        + ReplaceChar(FetchElm(RetNo,'T106',58),'/','-') +'</t106:CertificationDate>');
      add('            <t106:CertifierPositionTitle>'   + ReplaceXMLChars( FetchElm(RetNo,'T106',59) ) +'</t106:CertifierPositionTitle>');
      add('        </t106:CertificationDetail>');
      add('    </t106:NonArmsLengthWithNonResidentTransactionSummary>');



      //SLIP------------------------------------------------------------------------SLIP------------------------------------------------------------------------
      for i := 1 to CountMultipleInstances(RetNo,'T106SL') do
      begin
      add('    <t106:NonArmsLengthWithNonResidentTransactionSlip>');
      add('        <t106:SlipSequenceIdentifier>'+ FetchElm(RetNo,'T106SL#'+inttostr(i),124) +'</t106:SlipSequenceIdentifier>');

      s := leftstr( FetchElm(RetNo,'T106SL#'+inttostr(i),110),1 );
      add('        <t106:SlipActionCode>' + s +'</t106:SlipActionCode>');
      if s = '4' then
        add('        <t106:SlipDeleteReasonCode>'   + leftstr( FetchElm(RetNo,'T106SL#'+inttostr(i),175),1 ) +'</t106:SlipDeleteReasonCode>');

      add('        <t106:NonResidentName>'        + ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),10) ) +'</t106:NonResidentName>');

      s:= FetchElm(RetNo,'T106SL#'+inttostr(i),184);

      //20220623 jz
      if s > '' then
        add('        <t106:TaxpayerIdentificationNumber>'        + s +'</t106:TaxpayerIdentificationNumber>');

      add('        <t106:NonResidentAddress>'     + ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),11) ) + ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),12) ) +'</t106:NonResidentAddress>');

      //wrong drop down options on the form
      s:=FetchElm(RetNo,'T106SL#'+inttostr(i),13);  //20171128
      add('        <t106:NonResidentCountryCode>' + s +'</t106:NonResidentCountryCode>');


      //jz 20241126 new for 2025 T106 -->
      //4
      if FetchElm(RetNo,'T106SL#'+inttostr(i),     185) > '' then s:='1'
      else if FetchElm(RetNo,'T106SL#'+inttostr(i),186) > '' then s:='2'
      else if FetchElm(RetNo,'T106SL#'+inttostr(i),187) > '' then s:='3'
      else if FetchElm(RetNo,'T106SL#'+inttostr(i),188) > '' then s:='4'
      else if FetchElm(RetNo,'T106SL#'+inttostr(i),189) > '' then s:='5';
      add('        <t106:NonResidentTypeCode>' + s + '</t106:NonResidentTypeCode>');

      //5
      add('        <t106:DifferentClassificationIndicator>' + ConvertCheckBoxTo1(FetchElm(RetNo,'T106SL#'+inttostr(i),17)) + '</t106:DifferentClassificationIndicator>');

      //jz 20241126 new for 2025 T106 <--

      //6
      if      FetchElm(RetNo,'T106SL#'+inttostr(i),14)  > '' then s:='1'
      else if FetchElm(RetNo,'T106SL#'+inttostr(i),15)  > '' then s:='2'
      else if FetchElm(RetNo,'T106SL#'+inttostr(i),16)  > '' then s:='3'
      else if FetchElm(RetNo,'T106SL#'+inttostr(i),190) > '' then s:='4';
      add('        <t106:RelationshipTypeCode>' + s + '</t106:RelationshipTypeCode>');

      //jz 20241126 removed from new 2025 T106 add('        <t106:TaxTreatyIndicator>' + ConvertCheckBoxTo1(FetchElm(RetNo,'T106SL#'+inttostr(i),17)) +'</t106:TaxTreatyIndicator>');

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


      //TangiblePropertyStockInTradeRawMaterial
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),32);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),34);
      if (s > '') or (s1 > '') then //jz 20241126 must be positive, handled on the form with vtAllowNegative = false
      begin
        add('        <t106:TangiblePropertyStockInTradeRawMaterial>');
        if (s > '') and (maxr(0,Vl(s)) > 0) then //jz 20241206 change from minr to maxr
        begin
          add('            <t106:SoldToNonResidentAmount>' +                              FormatFloat(Format1,Round(Vl( s ))) +'</t106:SoldToNonResidentAmount>');
          add('            <t106:SoldToNonResidentTransferPricingMethodologyCode>' +      '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),33),1) +'</t106:SoldToNonResidentTransferPricingMethodologyCode>');
        end;
        if (s1 > '') and (maxr(0,Vl(s1)) > 0)  then //jz 20241206 change from minr to maxr
        begin
          add('            <t106:PurchaseFromNonResidentAmount>' +                        FormatFloat(Format1,Round(Vl( s1 )))                               +'</t106:PurchaseFromNonResidentAmount>');
          add('            <t106:PurchaseFromNonResidentTransferPricingMethodologyCode>'+ '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),35),1) +'</t106:PurchaseFromNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:TangiblePropertyStockInTradeRawMaterial>');
      end;


      //20220623 jz
      //TangiblePropertyOther
      s  := ReplaceXMLChars( FetchElm(RetNo,'T106SL#'+inttostr(i),93) );
      s1 := FetchElm(RetNo,'T106SL#'+inttostr(i),120);
      s2 := FetchElm(RetNo,'T106SL#'+inttostr(i),122);
      if (s1 > '') or (s2 > '') then
      begin
      add('        <t106:TangiblePropertyOther>');
        add('            <t106:OtherTangiblePropertyDescription>'                       + s +'</t106:OtherTangiblePropertyDescription>');
        if s1 > '' then
        begin
          add('            <t106:SoldToNonResidentAmount>'                                + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:SoldToNonResidentAmount>');
          add('            <t106:SoldToNonResidentTransferPricingMethodologyCode>'        + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),121),1) +'</t106:SoldToNonResidentTransferPricingMethodologyCode>');
        end;
        if s2 > '' then
        begin
          add('            <t106:PurchaseFromNonResidentAmount>'                          + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:PurchaseFromNonResidentAmount>');
          add('            <t106:PurchaseFromNonResidentTransferPricingMethodologyCode>'  + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),123),1) +'</t106:PurchaseFromNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:TangiblePropertyOther>');
      end;



      //Rent
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),36);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),38);
      if (s > '') or (s1 > '') then
      begin

        add('        <t106:Rent>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),37),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s > '' then
        begin
            add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
            add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),39),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:Rent>');
      end;

      //Royalty
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),40);
      s1  :=FetchElm(RetNo,'T106SL#'+inttostr(i),42);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:Royalty>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),41),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),43),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:Royalty>');
      end;

      //LicenseOrFranchiseFee
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),44);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),46);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:LicenseOrFranchiseFee>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),45),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),47),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:LicenseOrFranchiseFee>');
      end;


      //IntangiblePropertyOrRights
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),48);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),50);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:IntangiblePropertyOrRights>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'+                            FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'+    '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),49),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('            <t106:ExpenditureToNonResidentAmount>'+                          FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'+  '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),51),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:IntangiblePropertyOrRights>');
      end;


      //Management
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),52);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),54);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:Management>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),53),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),55),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:Management>');
      end;


      //Engineering
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),56);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),58);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:Engineering>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),57),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),59),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:Engineering>');
      end;


      //ResearchAndDevelopment
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),60);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),62);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:ResearchAndDevelopment>');
        if s > '' then
        begin
          add('           <t106:RevenueFromNonResidentAmount>'                            + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('           <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'    + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),61),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('           <t106:ExpenditureToNonResidentAmount>'                          + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('           <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>'  + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),63),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('       </t106:ResearchAndDevelopment>');
      end;


      //Commission
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),64);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),66);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:Commission>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),65),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),67),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:Commission>');
      end;


      //Interest
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),68);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),70);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:Interest>');
        if s > '' then
          add('            <t106:RevenueFromNonResidentAmount>'     + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
        if s1 > '' then
          add('            <t106:ExpenditureToNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
        add('        </t106:Interest>');
      end;

      //Dividend
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),72);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),74);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:Dividend>');
        if s > '' then
          add('            <t106:RevenueFromNonResidentAmount>'     + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
        if s1 > '' then
          add('            <t106:ExpenditureToNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
        add('        </t106:Dividend>');
      end;

      //SaleOfFinancialProperty
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),126);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),128);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:SaleOfFinancialProperty>');
        if s > '' then
          add('            <t106:RevenueFromNonResidentAmount>'     + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
        if s1 > '' then
          add('            <t106:ExpenditureToNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
        add('        </t106:SaleOfFinancialProperty>');
      end;


      //LeasePayment
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),130);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),132);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:LeasePayment>');
        if s > '' then
          add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
        if s1 > '' then
          add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
        add('        </t106:LeasePayment>');
      end;


      //SecuritiesLending
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),134);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),136);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:SecuritiesLending>');
        if s > '' then
          add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
        if s1 > '' then
          add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
        add('        </t106:SecuritiesLending>');
      end;


      //Insurance
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),76);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),78);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:Insurance>');
        if s > '' then
        begin
          add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
          add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+FetchElm(RetNo,'T106SL#'+inttostr(i),77) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
        end;
        if s1 > '' then
        begin
          add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
          add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),79),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
        end;
        add('        </t106:Insurance>');
      end;

      //20220623 jz
      //FinancialOther
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),95);
      s1:= FetchElm(RetNo,'T106SL#'+inttostr(i),80);
      s2:= FetchElm(RetNo,'T106SL#'+inttostr(i),82);
      if s1 + s2 > '' then
      begin
          add('        <t106:FinancialOther>');
            add('            <t106:FinancialOtherDescription>'                                + ReplaceXMLChars( s ) +'</t106:FinancialOtherDescription>');
          if s1 > '' then
          begin
            add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:RevenueFromNonResidentAmount>');
            add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),81),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
          end;
          if s2 > '' then
          begin
            add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:ExpenditureToNonResidentAmount>');
            add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),83),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
          end;
          add('        </t106:FinancialOther>');
      end;


      //ReimbursementOfExpense
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),84);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),86);
      if (s > '') or (s1 > '') then
      begin
        add('        <t106:ReimbursementOfExpense>');
        if s > '' then
          add('            <t106:RevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:RevenueFromNonResidentAmount>');
        if s1 > '' then
          add('            <t106:ExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:ExpenditureToNonResidentAmount>');
        add('        </t106:ReimbursementOfExpense>');
      end;



      //20220623 jz
      //OtherTransaction
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),119);
      s1:= FetchElm(RetNo,'T106SL#'+inttostr(i),88);
      s2:= FetchElm(RetNo,'T106SL#'+inttostr(i),90);

      if (s1 + s2) > '' then
      begin
          add('        <t106:OtherTransaction>');
          add('            <t106:OtherTransactionDescription>'                              + ReplaceXMLChars( s ) +'</t106:OtherTransactionDescription>');
          if s1 > '' then
          begin
            add('            <t106:RevenueFromNonResidentAmount>'                           + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:RevenueFromNonResidentAmount>');
            add('            <t106:RevenueFromNonResidentTransferPricingMethodologyCode>'   + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),89),1) +'</t106:RevenueFromNonResidentTransferPricingMethodologyCode>');
          end;
          if s2 > '' then
          begin
            add('            <t106:ExpenditureToNonResidentAmount>'                         + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:ExpenditureToNonResidentAmount>');
            add('            <t106:ExpenditureToNonResidentTransferPricingMethodologyCode>' + '0'+leftstr(FetchElm(RetNo,'T106SL#'+inttostr(i),91),1) +'</t106:ExpenditureToNonResidentTransferPricingMethodologyCode>');
          end;
          add('        </t106:OtherTransaction>');
      end;


      s:= FetchElm(RetNo,'T106SL#'+inttostr(i),92);
      if s > '' then
        add('        <t106:NonArmsLengthNonResidentSaleRevenueTotalAmount>'         + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentSaleRevenueTotalAmount>');
      s:= FetchElm(RetNo,'T106SL#'+inttostr(i),94);
      if s > '' then
        add('        <t106:NonArmsLengthNonResidentPurchaseExpenditureTotalAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentPurchaseExpenditureTotalAmount>');


      //OwedByReportingTaxpayerAmount
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),96);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),97);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),98);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),99);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:OwedByReportingTaxpayerAmount>');
        if s > '' then
          add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
        if s1 > '' then
          add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:IncreaseAmount>');
        if s2 > '' then
          add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DecreaseAmount>');
    //    if s3 > '' then //jz 20241206 as per cra email in certification - if there is a calculation it must be included, essentially manditory
          add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:EndingBalanceAmount>');
        add('        </t106:OwedByReportingTaxpayerAmount>');
      end;


      //OwedToReportingTaxpayerAmount
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),100);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),101);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),102);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),103);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:OwedToReportingTaxpayerAmount>');
        if s > '' then
          add('            <t106:BeginningBalanceAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
        if s1 > '' then
          add('            <t106:IncreaseAmount>'           + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:IncreaseAmount>');
        if s2 > '' then
            add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DecreaseAmount>');
    //    if s3 > '' then //jz 20241206 as per cra email in certification - if there is a calculation it must be included, essentially manditory
            add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:EndingBalanceAmount>');
        add('        </t106:OwedToReportingTaxpayerAmount>');
      end;


      //InvestmentInNonResident
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),104);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),105);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),106);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),107);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:InvestmentInNonResident>');
        if s > '' then
            add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
        if s1 > '' then
            add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:IncreaseAmount>');
        if s2 > '' then
            add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DecreaseAmount>');
    //    if s3 > '' then //jz 20241206 as per cra email in certification - if there is a calculation it must be included, essentially manditory
            add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:EndingBalanceAmount>');
        add('        </t106:InvestmentInNonResident>');
      end;


      //InvestmentInReportEntity
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),176);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),177);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),178);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),179);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:InvestmentInReportEntity>');
        if s > '' then
            add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
        if s1 > '' then
            add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:IncreaseAmount>');
        if s2 > '' then
            add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DecreaseAmount>');
    //    if s3 > '' then //jz 20241206 as per cra email in certification - if there is a calculation it must be included, essentially manditory
            add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:EndingBalanceAmount>');
        add('        </t106:InvestmentInReportEntity>');
      end;





      s:= FetchElm(RetNo,'T106SL#'+inttostr(i),108);
      if s > '' then
          add('        <t106:NonArmsLengthNonResidentLoanAdvanceInvestmentIncreaseTotalAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentLoanAdvanceInvestmentIncreaseTotalAmount>');
      s:= FetchElm(RetNo,'T106SL#'+inttostr(i),109);
      if s > '' then
          add('        <t106:NonArmsLengthNonResidentLoanAdvanceInvestmentDecreaseTotalAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:NonArmsLengthNonResidentLoanAdvanceInvestmentDecreaseTotalAmount>');


      //jz 20220623
      s:= ConvertCheckBoxTo1(FetchElm(RetNo,'T106SL#'+inttostr(i),180));
      add('        <t106:PLOIElectionMade>'   + s +'</t106:PLOIElectionMade>');
      if s = '1' then
      begin
        s:= FetchElm(RetNo,'T106SL#'+inttostr(i),182);
        add('        <t106:PLOIInterestAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:PLOIInterestAmount>');
      end;


      //PART V – Derivatives -------------------------------------------------------

      //InterestRateContract -------------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),138);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),139);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),140);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),141);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:InterestRateContract>');
        if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:InterestRateContract>');
      end;


      //ForeignExchangeContract ----------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),142);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),143);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),144);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),145);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:ForeignExchangeContract>');
        if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:ForeignExchangeContract>');
      end;

      //CreditContract -------------------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),146);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),147);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),148);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),149);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:CreditContract>');
        if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:CreditContract>');
      end;

      //EquityContract -------------------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),150);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),151);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),152);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),153);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:EquityContract>');
        if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:EquityContract>');
      end;

      //CommodityContract ----------------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),154);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),155);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),156);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),157);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:CommodityContract>');
        if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:CommodityContract>');
      end;


      //IndexContract --------------------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),158);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),159);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),160);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),161);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:IndexContract>');
        if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:IndexContract>');
      end;


      //DerivativeFee --------------------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),162);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),163);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),164);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),165);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:DerivativeFee>');
       if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:DerivativeFee>');
      end;


      //DerivativeOtherPayment -----------------------------------------------------
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),166);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),167);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),168);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),169);
      s4  := FetchElm(RetNo,'T106SL#'+inttostr(i),183);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:DerivativeOtherPayment>');

        add('            <t106:DerivativeOtherPaymentDescription>'  + s4 +'</t106:DerivativeOtherPaymentDescription>');

        if s > '' then
            add('            <t106:ContractCount>'                  + s +'</t106:ContractCount>');
        if s1 > '' then
            add('            <t106:NotionalAmount>'                 + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:NotionalAmount>');
        if s2 > '' then
            add('            <t106:DerivativeRevenueFromNonResidentAmount>'   + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DerivativeRevenueFromNonResidentAmount>');
        if s3 > '' then
            add('            <t106:DerivativeExpenditureToNonResidentAmount>' + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:DerivativeExpenditureToNonResidentAmount>');
        add('        </t106:DerivativeOtherPayment>');
      end;


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

      //AccountPayableAmount
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),111);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),112);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),113);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),114);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:AccountPayableAmount>');
        if s > '' then
            add('            <t106:BeginningBalanceAmount>'   + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
        if s1 > '' then
            add('            <t106:IncreaseAmount>'           + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:IncreaseAmount>');
        if s2 > '' then
            add('            <t106:DecreaseAmount>'           + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DecreaseAmount>');
    //    if s3 > '' then //jz 20241206 as per cra email in certification - if there is a calculation it must be included, essencially manditory
            add('            <t106:EndingBalanceAmount>'      + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:EndingBalanceAmount>');
        add('        </t106:AccountPayableAmount>');
      end;


      //AccountReceivableAmount
      s   := FetchElm(RetNo,'T106SL#'+inttostr(i),115);
      s1  := FetchElm(RetNo,'T106SL#'+inttostr(i),116);
      s2  := FetchElm(RetNo,'T106SL#'+inttostr(i),117);
      s3  := FetchElm(RetNo,'T106SL#'+inttostr(i),118);
      if (s > '') or (s1 > '') or (s2 > '') or (s3 > '') then
      begin
        add('        <t106:AccountReceivableAmount>');
        if s > '' then
            add('            <t106:BeginningBalanceAmount>' + FormatFloat(Format1,Round(Vl( s ))) +'</t106:BeginningBalanceAmount>');
        if s1 > '' then
            add('            <t106:IncreaseAmount>'         + FormatFloat(Format1,Round(Vl( s1 ))) +'</t106:IncreaseAmount>');
        if s2 > '' then
            add('            <t106:DecreaseAmount>'         + FormatFloat(Format1,Round(Vl( s2 ))) +'</t106:DecreaseAmount>');
    //    if s3 > '' then //jz 20241206 as per cra email in certification - if there is a calculation it must be included, essencially manditory
            add('            <t106:EndingBalanceAmount>'    + FormatFloat(Format1,Round(Vl( s3 ))) +'</t106:EndingBalanceAmount>');
        add('        </t106:AccountReceivableAmount>');
      end;

      add('    </t106:NonArmsLengthWithNonResidentTransactionSlip>');

      end; //SLIP------------------------------------------------------------------------

      add('</t106:NonArmsLengthTransactionWithNonResidentInformationReturn>');

      //jz 20240711
      if sendCredentials.ItemIndex = useEfilerNumber then
      begin
        add(' </t3rq:TaxForm>');
        add(' </t3rq:T3EfileReturnRequest>');
      end
      else if sendCredentials.ItemIndex = useWAC then
      begin
        add(' </t3nrq:TaxForm>');
        add(' </t3nrq:T3NetfileReturnRequest>');
      end;

      //mine
      add('</soapenv:Body>');
      add('</soapenv:Envelope>');
    end;

    //jz 20160617
    //when testing, load from file xmlList.Clear; xmllist.LoadFromFile('C:\Users\Costas\Documents\SCHEMA\schema\T3\examplT1135_ORIGINALtoCHANGE.xml');
    //Now save the list to a file
    SoapMsg:= '';

    for I:= 0 to pred(XmlList.count) do SoapMsg:= SoapMsg + XmlList[i]; //+Chr(13);

    if FileExists(MkSubmittedFileName(RetNo)) then DeleteFile(MkSubmittedFileName(RetNo));

    XmlList.SaveToFile(MkSubmittedFileName(RetNo));
  finally
    XmlList.Free;
  end;
end;

function TT106EfileT3_2026.CreateT106EfileResponseHtm(RetNo: Integer; AckRec: T106AckRec; HtmFile: String):String; //20160523 Igor
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
  end;

  flName:= T106EfileDir + '\' + GetAccountNumber(RetNo) + 'T106EFileAck.htm';

  htmlSource.SaveToFile(flName);
  htmlSource.Free;

  Result:= flName;
end;

Function TT106EfileT3_2026.ReplaceXMLChars(info: String): String;
Begin
  info:= ReplaceChar(info, '&', '&amp;');
  info:= ReplaceChar(info, '<', '&lt;');
  info:= ReplaceChar(info, '"', '&quot;');
  info:= ReplaceChar(info, '>', '&gt;');
  info:= ReplaceChar(info, '''', '&apos;');  //20160515 it is char(39)
  info:= ReplaceChar(info, Chr(39), '&apos;');  //20161213
  Result:= info;
End;

end.
