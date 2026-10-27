unit T3_2026T1135efile;
{
 To test
http://www.service-repository.com/client/input?operation=EfileReturnRequest&wsdlURL=https%3A%2F%2Fapps-ct.cra-arc.gc.ca%2Febci%2Fefes%2Ffrrms%2Fws%2Fservices%2FFileFormService%3Fwsdl&portType=FileFormSoapBindingImpl
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,

  T3_2026datagenT183,

  T3_2026TrimStr, T3_2026Declare, T3_2026Common, T3_2026Common2, Db, DBTables, Grids, DBGrids,   //20150120 Igor
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  //MSSOAPLib30_TLB,     //does not seem to be needed for sending receiving  //20110129 it has dom
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  Xml.XMLDoc, Xml.XMLIntf, System.RegularExpressions, Variants, //20220128 Igor
  uADCompClient; //20110129  NEEDED for connection and the response handler

                           //jz//20260320 - update release dates
 Const SOFTRELEASEYEAR   = '2026';  //'2025';
 Const SOFTRELEASEMONTH  = '03';    //'03';
 Const SOFTRELEASEDAY    = '20';    //'15';    //'14';
 Const CrLf              =  Chr(13)+Chr(10);
 Const SoftVendor        = '064AA'; // '064K'; //20220317

type
  TT1135EfileT3_2026 = class(TForm)
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
    BitBtn3: TBitBtn;
    SearchBox: TEdit;
    Label17: TLabel;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
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


    Function ConvertCheckBoxTo1(S:String):String;  //20160124
//    Function  GetDcnSeqNoForT1135(RetNo:Integer;OnLineNo:String):String; //20150305
    function GetAmendSuffix: string; //20220128 Igor
    procedure CreateT1135SoapMessage(RetNo:Integer);
    procedure GetUrlBox;
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    Procedure SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);

    Function CreateT1135ResponseHtm(RetNo:integer;T1135ResponseRec:TT1135AckRec;HtmTemplateFileName:String):String;
    Function GetT1135ErrorDescr(ErrorCode:String):AnsiString;  //20140119
    Function parseT1135Response(ResponseString: String):TT1135AckRec; //20220128 Igor
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
  //  procedure BuildBatchBtnClick(Sender: TObject);
    procedure ShowFiles;
  //  Procedure CreateBatch;
    procedure TestOrProductionGroupClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure testResponseClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
    RetNo:Integer;   //20160120 Igor
  public
    { Public declarations }
  end;

var
  T1135Efile: TT1135EfileT3_2026;
 // Fx1135:AT1135FX;
  userName1135,passWord1135 :string;
  SoapMsg:AnsiString;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
  NetFileDir:String;
  FormCnt:Integer;
  T1135EfileDir: String;
  sUrl:String;
  Indent1, Indent2,Indent3,Indent4,Indent5,Indent6,Indent7, Indent8,Indent9,Indent10,Indent11:Integer;

implementation

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T3_2026, T3_2026main,
  vtShared, vtDynData, {,childwinnew} //20150120 Igor
  vtShowMessageHTML
; //end uses
{$R *.DFM}

procedure TT1135EfileT3_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 T1135EfileDir:=AppDir+'\'+'T1135Efile';
 If DirectoryExists(T1135EfileDir) = false then ForceDirectories(T1135EfileDir);

 if TestOrProductionGroup.visible = true then TestOrProductionGroup.itemindex := 0;  //20220328 //1 to 0

 RetNo:=GetCurrentRetNo;
 {If RetNo>0 then
 begin
   If ValidForT1135Efile(RetNo,GetFormNo('T1135#1')) = false then
   Begin  SoapMsg:='';  Exit; End;
 end;}

 //CreateT1135SoapMessage(RetNo); //20220128 Igor
end;


procedure TT1135EfileT3_2026.SubmitBtnClick(Sender: TObject);
Var RetNo:Integer;FlName:String;
begin
  //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20181217  //20180226 //20220328
 //20150312
 If ValidPostal(RetNo,OptRec.Prp_Postal) = false then
 begin
  ShowMessage('Please fix the Postal code in Configure -> General Options -> Preparer');
  Exit;
 end;

 //20150207
 RetNo:=GetCurrentRetNo;
 If FetchElm(RetNo,'T1135',39)>'' then
 Begin
  If FetchElm(RetNo,'T1135',22)='' then
  Begin
   ShowMessage('This T1135 has been already Efiled and it has a Confirmation number.'
   +Chr(13)+'Unless you check the Amended box');
  Exit;
  end;
 end;

 FlName:=MkSubmittedFileName(RetNo);
 CreateT1135SoapMessage(RetNo);
 //  --------------
 If SoapMsg='' then
 Begin
  ShowMessage('No data available for submission');
  Exit;
 end;
 SubmitSoapMsg(SoapMsg,MkSubmittedFileName(RetNo));

 if FileExists(FlName) then DeleteFile(FlName); //jz//20260311 - CRA probably want the files deleted
end;

Procedure TT1135EfileT3_2026.SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
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
 T1135ResponseRec:TT1135AckRec;
 T1135ResponseHTM:string;
Begin

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

 //20180228 Igor >>>
 try
  ObjHTTP.send(SoapMsg);
 except on E: Exception do
  begin
    Screen.Cursor := crDefault;
    objHttp := Nil;
    Application.MessageBox(PChar('It seems that there is no internet connection to the web site' + #13#13 +
                                  E.Message), 'Error', MB_OK or MB_ICONERROR);
    Exit;
  end;
 end;
 //20180228 Igor <<<
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
   T1135ResponseRec := parseT1135Response(WString);
   T1135ResponseHTM := CreateT1135ResponseHtm(RetNo,T1135ResponseRec,AppDir +'\'+'ResponseDisplayTemplateT1135.htm'); //20170122

   //??? The routine below does not capture the Confirmation number on the T1135 as AckRec.Transmission number is blank
   //If (AckRec.EFresultType=EFaccepted) then
   If (T1135ResponseRec.T1135resultType=T1135accepted) then
   Begin
    //StoreElm(RetNo,GetFormNo('T1135'),39,AckRec.ConfirmationNo);   //20170219
    //StoreElm(RetNo,GetFormNo('T1135'),39,AckRec.TransmissionNo);   //20150207
    StoreElm(RetNo,GetFormNo('T1135'),39,T1135ResponseRec.TransmissionNumber);   //20150207 //20170219
    If not SaveReturn(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName,True,False) =0 then
                ShowMessage('Return cannot be saved'); //20150208
   end;

   h := ShellExecute(Self.Handle, nil, PChar('' + T1135ResponseHTM), nil, nil, SW_NORMAL);

   If H<=32 then
      ShowMessage(ResponseXMLfile+ 'not found');

 End
 Else  //batch ???
 Begin
  h := ShellExecute(MainForm.Handle,'open',Pchar(''+ResponseXmlFile),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');
 end;
 //succesful transmission
 If EfileOptionGroup.ItemIndex=0 then  //single return
 Begin
  s:=MkSubmittedFileName(RetNo);
  //If FileExists(s) then RenameFile(s,ReplaceStr(S, 'ToBeSubmitted', 'Submitted')); //rename it  //jz//20260311 - remove as CRA does not want files saved
 end;
 objHttp:=Nil;  //20110129  .Free It is not accepted

end;


procedure TT1135EfileT3_2026.FormActivate(Sender: TObject);
begin

  //20220128 Igor >>>
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  GetUrlBox;
  If (Length(OnlineNo)<>5) or (Password='') then
  begin
   SoapMsg:='';
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT3.actSetupEOLExecute(Sender);
   Exit;
  end;

  userName1135 := OnLineNo;
  passWord1135 := Password;
  //20220128 Igor <<<

  userName1135 := '';
  passWord1135 := '';

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
  //??   CreateT1135SoapMessage(RetNo,EolTaxFlName,ProdOrTest,OnLineMethod:String);
  }
end;

procedure TT1135EfileT3_2026.ShowBtnClick(Sender: TObject);
Var h:THandle; FlName:String;
begin
  FlName:=MkSubmittedFileName(RetNo);
  CreateT1135SoapMessage(RetNo);

  //h := ShellExecute(Self.Handle,'open',Pchar(''+FlName),Nil,Nil,Sw_Show);
  //If H<=32 then ShowMessage('File not found');

  ShowMessageHTMLFromFile(FlName);

  if FileExists(FlName) then DeleteFile(FlName); //jz//20260311 - CRA probably want the files deleted
end;

procedure TT1135EfileT3_2026.FormPaint(Sender: TObject);
begin
 If EfileOptionGroup.ItemIndex=0 then
  BatchPanel.Visible:=False
 Else
  BatchPanel.Visible:=True;

 If EfileOptionGroup.ItemIndex=1 then ShowFiles;
end;

procedure TT1135EfileT3_2026.EfileOptionGroupClick(Sender: TObject);
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

procedure TT1135EfileT3_2026.DBGrid1DblClick(Sender: TObject);
Var i:Integer; FlName:String;
SomeList:TStringList;
begin
end;

procedure TT1135EfileT3_2026.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TT1135EfileT3_2026.RemoveBtnClick(Sender: TObject);
begin
ListBox1DblClick(Sender);
end;


procedure TT1135EfileT3_2026.BitBtn2Click(Sender: TObject);
begin
ListBox1.Clear;
end;

Function TT1135EfileT3_2026.MkSelectedStr: String;
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



procedure TT1135EfileT3_2026.ListBox1DblClick(Sender: TObject);
begin
 ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TT1135EfileT3_2026.ShowFiles;
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
//begin
// DataDirBox.Text := OptRec.Dir_Cur;
// Table1.DataBaseName:=OptRec.Dir_Cur;
//  If Not FileExists(DataDirBox.Text+'\'+'Clients.DBF') then
// begin
//  ShowMessage('There is no Clients data base in this directory'+
//    Chr(13)+'Use Configure | Data Directories');
//    exit;
// end;
//Try
// If Table1.Active then Table1.Close;
// Table1.DataBaseName := DataDirBox.Text; //OptRec.Dir_Cur;
// Table1.TableName := ClientsTable;
// Table1.IndexName := 'LAST_Name';
//
// Table1.Open;
// except
// on EdataBaseError do
//   begin
//    ShowMessage('Data Base cannot be opened '); //+E.Message, mtError, [mbok], 0);
//    exit;
//   end;
// end; {except}
// Screen.Cursor := crDefault;
// If Table1.RecordCount = 0 then
// begin
//  ShowMessage('DataBase is empty. Press Close');
//  exit;
// end;
// DBGrid1.Update;
end;


Function TT1135EfileT3_2026.MkSubmittedFileName(RetNo:Integer):String;
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
  result:=T1135EfileDir+'\'+'T1135-ToBeSubmitted-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+GetAmendSuffix+'.xml' //20220128 Igor
 Else
 Begin
  s:=FormatDateTime('yyyy-mm-dd',Date)+'-'+GetMinutesAndSeconds;
  result:=T1135EfileDir+'\'+'T1135-Submitted-Batch'+'-'+S+'.xml';
  //PaddZero(FetchElm(RetNo,FormName1135,9),9) + appYear + PaddZero(inttostr(jmonthDay),3) + PaddZero(IntToStr(Hour),2) + PaddZero(IntToStr(Min),2) + PaddZero(IntToStr(Sec),2) + PaddZero(IntToStr(MSec),3);
 end;
end;

Function TT1135EfileT3_2026.MkResponseFileName(RetNo:Integer):String;
begin
 result:=T1135EfileDir+'\'+'T1135-Response-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+GetAmendSuffix+'.xml' //20220128 Igor
end;

procedure TT1135EfileT3_2026.GetUrlBox;
begin
 //20150102
 If TestOrProductionGroup.ItemIndex=0 then  //production
   sUrl :='https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'
 else  //test
   sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';

  UrlBox.Text := SUrl;

end;

procedure TT1135EfileT3_2026.TestOrProductionGroupClick(Sender: TObject);
begin
GetUrlBox;
end;

procedure TT1135EfileT3_2026.BitBtn3Click(Sender: TObject);
begin
// MainForm.T1135EfileErrors1Click(Sender);
end;


procedure TT1135EfileT3_2026.SearchBoxChange(Sender: TObject);
begin
//20170522 Igor >>>
  Table1.Locate('LAST_NAME', SearchBox.Text, [loCaseInsensitive, loPartialKey]);
//  with Table1 do
//  begin
//   SetKey;
//   FieldByName('Last_Name').AsString := UpperCase(SearchBox.Text);
//   GotoNearest;
//  end;
//20170522 Igor <<<
end;

(*
procedure TT1135EfileT3_2026.SearchBoxChange(Sender: TObject);
begin
  with Table1 do
  begin
   SetKey;
   FieldByName('Last_Name').AsString := UpperCase(SearchBox.Text);
   GotoNearest;
  end;
end;
*)

procedure TT1135EfileT3_2026.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;

procedure TT1135EfileT3_2026.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

Function TT1135EfileT3_2026.parseT1135Response(ResponseString: String):TT1135AckRec; //20220128 Igor
var tempAckRec:TT1135AckRec;
    X: XML.XMLDoc.TXMLDocument;
    N, Body, Fault, ReturnResponse, FileReturnResponse, GenericResponse,
    BatchResponseCode, ResponseCodes, FormLevelResponse,
    FormResponseCode, Node: IXMLNode;
    fontRedColor, fontGreenColor, fontEnd: string;
    I, J, CurrCount, CurrFormCount: integer;


    aResponseTypes: TArray<string>;
    cTemp: string;
    returnedResultCode,returnedTransmissionNumber,returnedEfilerNumber,
    returnedControlNumber,returnedFamilyName,returnedGivenName,returnedMessageText: string;

    function ClearXML(AXML: String): string;
    begin
      Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
      Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
    end;

    function GetMessageText(ANode: IXMLNode): string;
    var EnglishMessage, TempNode: IXMLNode;
        I: integer;
    begin
      Result := '';
      EnglishMessage := ANode.ChildNodes.FindNode('EnglishMessage');
      for I := 0 to EnglishMessage.ChildNodes.Count - 1 do
      begin
        TempNode := EnglishMessage.ChildNodes[I];
        if SameText(TempNode.NodeName, 'MessageText') then
        begin
          if not Result.IsEmpty then
            Result := Result + '<br>';
          Result := Result + VarToStr(TempNode.NodeValue);
        end;
      end;
    end;

begin
  with tempAckRec do
  begin
    Name                           := '';
    DateTimeReceived               := '';
    Status                         := 'Rejected';
    StatusColor                    := 'RED';
    ResultCode                     := '';
    TransmissionNumber             := '';
    TaxPreparerEfilerNumber        := '';
    TaxPreparerReturnControlNumber := '';
    DocumentControlNumber          := '';
    FamilyName                     := '';
    GivenName                      := '';
    MessageText                    := '';
    additionalText                 := '';
    T1135resultType                := T1135rejected;
  end;

  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    X.XML.Clear;
    X.XML.Add(ClearXML(ResponseString));
    if not(X.Active) then
      X.Active := true;
    N := X.DocumentElement;
    if (N = nil) or (N.NodeName <> 'Envelope') then
      raise Exception.Create('Bad Response XML structure: ' + ResponseString);

    Body := N.ChildNodes.FindNode('Body');
    if (Body = nil) then
      raise Exception.Create('Bad Response XML structure: ' + ResponseString);
    Fault := Body.ChildNodes.FindNode('Fault');
    if Fault <> nil then
    begin
      Fault.ChildValues['faultcode'];
      returnedResultCode := VarToStr(Fault.ChildValues['faultcode']);
      returnedMessageText := VarToStr(Fault.ChildValues['faultstring']);
      tempAckRec.T1135resultType := T1135webserviceError;
    end;
    ReturnResponse := Body.ChildNodes.FindNode('T3FrrmsReturnResponse');
    if ReturnResponse <> nil then
    begin
      returnedResultCode := VarToStr(ReturnResponse.ChildValues['t3ResultCode']);
      returnedTransmissionNumber := VarToStr(ReturnResponse.ChildValues['t3TransmissionNumber']);
      returnedEfilerNumber := VarToStr(ReturnResponse.ChildValues['TaxPreparerEfilerNumber']);
      returnedControlNumber := VarToStr(ReturnResponse.ChildValues['TaxPreparerReturnControlNumber']);
      returnedMessageText := '';
      FileReturnResponse := ReturnResponse.ChildNodes.FindNode('FileReturnResponse');
      if FileReturnResponse <> nil then
      begin
        aResponseTypes := 'TermsAndConditions|Confirmation|Rejection|SystemError'.Split(['|']);
        for I := 0 to Length(aResponseTypes) - 1 do
        begin
          GenericResponse := FileReturnResponse.ChildNodes.FindNode(aResponseTypes[I]);
          if GenericResponse <> nil then
          begin
            cTemp := GetMessageText(GenericResponse);
            if not cTemp.IsEmpty then
            begin
              if not returnedMessageText.IsEmpty then
                returnedMessageText := returnedMessageText + '<br>';
              returnedMessageText := returnedMessageText + cTemp;
            end;
          end;
        end;
      end;
      returnedFamilyName := VarToStr(ReturnResponse.ChildValues['FamilyName']);
      returnedGivenName := VarToStr(ReturnResponse.ChildValues['GivenName']);
      if returnedResultCode.StartsWith('480') or returnedResultCode.StartsWith('481') or
        returnedResultCode.StartsWith('180') or returnedResultCode.StartsWith('182') then
      begin
        with tempAckRec do
        begin
          T1135resultType := T1135accepted;
          Status          := 'Accepted';
          StatusColor     := 'GREEN'
        end;
      end
    end;
  finally
    X.Free;
  end;

  With tempAckRec do
  Begin
    //TimeReceived:=FormatDateTime('yyyy-mm-dd',Date)+ ' '+GetTimeToMilliSec(Date);

    DateTimeReceived               := FormatDateTime('yyyy-mm-dd',Date) + ' ' + GetTimeToMilliSec(Date);
    ResultCode                     := returnedResultCode;
    TransmissionNumber             := returnedTransmissionNumber;
    TaxPreparerEfilerNumber        := returnedEfilerNumber;
    TaxPreparerReturnControlNumber := returnedControlNumber;
    DocumentControlNumber          := returnedEfilerNumber+ReturnedControlNumber;
    FamilyName                     := returnedFamilyName;
    GivenName                      := returnedGivenName;
    MessageText                    := returnedMessageText;

  end;

  Result := tempAckRec;
end;

(* // 20220128 Igor
Function TT1135EfileT3_2026.parseT1135Response(rString:AnsiString):TT1135AckRec;

     function LTrimAnsi(Const S: AnsiString): AnsiString;
     var {len: integer;} i: Integer;
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
  s,e,TimeReceived,tempString : String;
  returnedResultCode,returnedTransmissionNumber,returnedEfilerNumber,
  returnedControlNumber,returnedFamilyName,returnedGivenName,returnedMessageText: string;
  tempAckRec:TT1135AckRec;
begin
    with tempAckRec do
    begin
      Name                           := '';
      DateTimeReceived               := '';
      Status                         := 'Rejected';
      StatusColor                    := 'RED';
      ResultCode                     := '';
      TransmissionNumber             := '';
      TaxPreparerEfilerNumber        := '';
      TaxPreparerReturnControlNumber := '';
      DocumentControlNumber          := '';
      FamilyName                     := '';
      GivenName                      := '';
      MessageText                    := '';
      additionalText                 := '';
      T1135resultType                := T1135rejected;
    end;

     //server error-------------------------------------------------------------
     s     := '<faultcode>';
     sPos := pos(s,rString);
     IF sPos > 0 then
     BEGIN
         e     := '</faultcode>';
         sPos  := pos(s,rString) + length(s);
         ePos  := pos(e,rString);
         returnedResultCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

         s       := '<faultstring>';
         e       := '</faultstring>';
         sPos    := pos(s,rString) + length(s);
         ePos    := pos(e,rString);
         returnedMessageText := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

         with tempAckRec do
         begin
           T1135resultType       := T1135webserviceError; //20140124
           TransmissionNumber             := '--';
           TaxPreparerEfilerNumber        := '--';
           TaxPreparerReturnControlNumber := '--';


           {
           AdditionalMessageText := '<p>Web Services Error</p>'
                                    '<p>The tax return has not been accepted.</p>' +
                                    '<p>Error:soapenv:Server.userException</p>' +
                                    '<p>Please contact VisualTax.</p>';
           }
         end;
     END
     ELSE
     BEGIN
         //Get result code------------------------------------------------------------------
         s:= '<t1ersp:ResultCode>'; e:= '</t1ersp:ResultCode>';
         sPos := pos(s,rString);
         if sPos > 0 then
         begin
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           returnedResultCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;
         //Get Transmission Number (filename/confirmation number) if exists
         //------------------------------------------------------------------
         s:= '<t1ersp:TransmissionNumber>'; e:='</t1ersp:TransmissionNumber>';
         sPos := pos(s,rString);
         if sPos > 0 then
         begin
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           returnedTransmissionNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;
         //Get Document Control Number (TaxPreparer Efiler Number and the TaxPreparer Return Control Number) if exists
         //------------------------------------------------------------------
         s:= '<ef:TaxPreparerEfilerNumber>'; e:='</ef:TaxPreparerEfilerNumber>';
         sPos := pos(s,rString);
         if sPos > 0 then
         begin
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           ReturnedEfilerNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;

         s:= '<ef:TaxPreparerReturnControlNumber>'; e:='</ef:TaxPreparerReturnControlNumber>';
         sPos := pos(s,rString);
         if sPos > 0 then
         begin
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           ReturnedControlNumber :=AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;
         //Get Message
         //------------------------------------------------------------------
         s:= '<t1rsp:MessageText xml:lang="en">'; e:='</t1rsp:MessageText>';
         sPos := pos(s,rString);
         if sPos > 0 then
         begin
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           returnedMessageText := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;
         //Get Name
         //------------------------------------------------------------------
         s:= '<comm:FamilyName>'; e:= '</comm:FamilyName>';
         sPos := pos(s,rString);
         if sPos > 0 then
         begin
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           returnedFamilyName := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;

         s:= '<comm:GivenName>'; e:= '</comm:GivenName>';
         sPos := pos(s,rString);
         if sPos > 0 then
         begin
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           returnedGivenName := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;

         //success------------------------------------------------------------------
         if (returnedResultCode = '480') or (returnedResultCode = '481') or
            (returnedResultCode = '180') or(returnedResultCode = '182') then
         begin
           with tempAckRec do
           begin
             T1135resultType := T1135accepted; //20140124 ???????
             Status          := 'Accepted';
             StatusColor     := 'GREEN'
           end;
         end
         else         //else error------------------------------------------------------------------
         begin
           //find error clues if any
           //get hyperlink text and target
           s     := '<t1rsp:HyperlinkText>';
           e     := '</t1rsp:HyperlinkText>';
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           //tempString := tempString + chr(13) + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

           s     := '<t1rsp:HyperlinkTarget>';
           e     := '</t1rsp:HyperlinkTarget>';
           sPos  := pos(s,rString) + length(s);
           ePos  := pos(e,rString);
           //tempString := tempString + chr(13) + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
         end;
     END; //else not servererror

   //   MessageDlg(tempString,mtError,[mbOK],0);    //20141211

     With tempAckRec do
     Begin
       //TimeReceived:=FormatDateTime('yyyy-mm-dd',Date)+ ' '+GetTimeToMilliSec(Date);

       DateTimeReceived               := FormatDateTime('yyyy-mm-dd',Date) + ' ' + GetTimeToMilliSec(Date);
       ResultCode                     := returnedResultCode;
       TransmissionNumber             := returnedTransmissionNumber;
       TaxPreparerEfilerNumber        := returnedEfilerNumber;
       TaxPreparerReturnControlNumber := returnedControlNumber;
       DocumentControlNumber          := returnedEfilerNumber+ReturnedControlNumber;
       FamilyName                     := returnedFamilyName;
       GivenName                      := returnedGivenName;
       MessageText                    := returnedMessageText;

     end;

     result := tempAckRec;

end;
*)

Function TT1135EfileT3_2026.GetT1135ErrorDescr(ErrorCode:String):AnsiString;  //20140119
Var Tbl:TTable;
begin
 Result:='';
 tbl:=TTable.Create(Application);
 Tbl.DataBaseName := AppDir;
 Tbl.TableName := 'T1135Errors.DBF';
 Tbl.IndexName := 'Code';
 Tbl.Open;
 if Tbl.FindKey([ErrorCode]) = True then
  begin Result := Tbl.FieldByName('Descr').AsString;end
 Else
  begin end; // ShowMessage('See the Web Services Error Messages document Under EfileOnline');
 Tbl.Free;
end;


Function TT1135EfileT3_2026.CreateT1135ResponseHtm(RetNo:integer;T1135ResponseRec:TT1135AckRec;HtmTemplateFileName:String):String;
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

   sString := '!Status!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.status,[rfReplaceAll, rfIgnoreCase]);

   sString := '!StatusColor!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.statuscolor,[rfReplaceAll, rfIgnoreCase]);

   sString := '!Client!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.GivenName + ' ' + T1135ResponseRec.FamilyName,[rfReplaceAll, rfIgnoreCase]);

   sString := '!DateTime!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.DateTimeReceived,[rfReplaceAll, rfIgnoreCase]);

   sString := '!TransmitterID!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.TransmissionNumber,[rfReplaceAll, rfIgnoreCase]);

   sString := '!EfilerNumber!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.TaxPreparerEfilerNumber,[rfReplaceAll, rfIgnoreCase]);


   sString := '!ConfirmationNumber!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
   Begin
     htmlSource[i] := StringReplace(htmlSource[i], sString,T1135ResponseRec.TaxPreparerReturnControlNumber,[rfReplaceAll,rfIgnoreCase]);
   End;

   sString := '!ResponseCode!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString,
   T1135ResponseRec.ResultCode,[rfReplaceAll, rfIgnoreCase]);

   sString := '!ResponseText!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString,T1135ResponseRec.MessageText,[rfReplaceAll, rfIgnoreCase]);

   sString := '!additionalText!';
   startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
     htmlSource[i] := StringReplace(htmlSource[i], sString,T1135ResponseRec.additionalText,[rfReplaceAll, rfIgnoreCase]);

  end;

  //flName := ChangeFileExt(ResponseXmlFileName, '.htm');
  flName := T1135EfileDir+'\'+'T1135-Ack-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+GetAmendSuffix+'.htm'; //20220128 Igor
  htmlSource.SaveToFile(flName);

  htmlSource.Free;

  result := flName;


end;








procedure TT1135EfileT3_2026.CreateT1135SoapMessage(RetNo:Integer);
Const Format1='########0';  //20150221
Var
i,Elm,T1135FNo,ArrayNo,BoxesPerRow,MaxRowsPerArray:Integer; cd:String; //code
TempSoapList:TStringList;
TempDataList:TStringList;
s,FlName:String;
DcnSeqNo:String;
XmlList: TStringList;

{
  function GetTrustNumber(RetNo:Integer; IsProd:boolean): String; //20220128 Igor
  begin
    if IsProd then
      Result := 'T' + FetchElm(RetNo, 'T3', 2)
    else
      Result := 'A' + FetchElm(RetNo, 'T3', 2);
  end;
}


t183data:TT3T183data;

begin
 T1135FNo:=GetFormNo('T1135');
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

 //GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 XmlList:=TstringList.Create;
 XmlList.Clear;

 With XmlList do
 Begin
  add('<?xml version="1.0" encoding="ISO-8859-1"?>');

  //Modified Denis verson
  add(' <soapenv:Envelope xmlns:soapenv = "http://schemas.xmlsoap.org/soap/envelope/">');
  add(' <soapenv:Body>');

  //20220128 Igor >>>
  add(' <t3rq:T3FrrmsReturnRequest');
  add('  xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"');
  add('  xmlns:comm="http://www.cra-arc.gc.ca/xmlns/comm/2026/1-0-0"'); //jz//20260340 //add('  xmlns:comm="http://www.cra-arc.gc.ca/xmlns/comm/2023/1-0-0"');
  add('  xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2026/1-0-0"');     //jz//20260340 //add('  xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2023/1-0-0"');
  add('  xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"');
  add('  xmlns:t1135="http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0"');
  add('  xmlns:t3rq="http://www.cra-arc.gc.ca/xmlns/t3rq/t3request/1-0-0"');
  add('  xmlns:xml="http://www.w3.org/XML/1998/namespace"');
  add('  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
  add('  xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t3rq/t3request/1-0-0 t3request.xsd">');

  //20230208
  //start T183 ========================================================================================================================


  t183data := getT83data(RetNo,TestOrProductionGroup.ItemIndex = 0,'T1135');

  add('   <t3rq:TrustNumber>'+t183data.trustNumber+'</t3rq:TrustNumber>');

  add('   <t3rq:TaxProfessionalData>');
  add('     <ef:TransmitterEfilerNumber>'+t183data.TransmitterEFilerNumber+'</ef:TransmitterEfilerNumber>');
  add('     <ef:PasswordID>'+ t183data.PasswordId+'</ef:PasswordID>');
  add('     <ef:DocumentControlNumber>');
  add('       <ef:TaxPreparerEfilerNumber>'+t183data.TaxPrepEfilerNumber+'</ef:TaxPreparerEfilerNumber>');
  add('       <ef:TaxPreparerReturnControlNumber>'+t183data.TaxPrepReturnControlNumber+'</ef:TaxPreparerReturnControlNumber>'); //DcnSeqNo
  add('     </ef:DocumentControlNumber>');

  //20230208
  if FetchElm(RetNo,'EFMEMO',49)>'' then add('     <ef:TaxPreparerAuthorizationIndicator>1</ef:TaxPreparerAuthorizationIndicator>');
  if FetchElm(RetNo,'EFMEMO',50)>'' then
  begin
   s:=AllTrim(FetchElm(RetNo,'EFMEMO',50));  //20230208
   If s>'' then add('     <ef:TaxPreparerAuthorizationExpiryDate>'+s+'+</ef:TaxPreparerAuthorizationExpiryDate> ');
  end;
  //add('     <ef:TaxPreparerAuthorizationIndicator>1</ef:TaxPreparerAuthorizationIndicator>');
  //add('     <ef:TaxPreparerAuthorizationExpiryDate>2023-12-31</ef:TaxPreparerAuthorizationExpiryDate> ');     //??? WHERE FROM?

  add('     <ef:TaxPreparerPreAssessmentReviewContactCode>'+ t183data.TaxPrepPreAssessRevContactCode +'</ef:TaxPreparerPreAssessmentReviewContactCode>'); //Cd
  add('     <ef:TaxPreparerPostAssessmentReviewContactCode>'+ t183data.TaxPrepPostAssessRevContactCode +'</ef:TaxPreparerPostAssessmentReviewContactCode>'); //Cd

  add('     <ef:T183ElectronicSignatureData>');
  if SameText(FetchElm(RetNo, 'T183TRUST', 38), 'Y') then
  begin
     add('       <ef:T183ElectronicSignatureIndicator>'+t183data.t183ESigIndicator+'</ef:T183ElectronicSignatureIndicator>');
     add('       <ef:T183ElectronicSignatureDate>'+t183data.t183ESigDate+'</ef:T183ElectronicSignatureDate>'); //2022-12-31
     add('       <ef:T183ElectronicSignatureTime>'+t183data.t183ESigTime+'</ef:T183ElectronicSignatureTime>'); //23:59:59
  end
  else
  Begin
    add('       <ef:T183ElectronicSignatureIndicator>'+t183data.t183ESigIndicator+'</ef:T183ElectronicSignatureIndicator>');
    add('       <ef:T183ElectronicSignatureDate>'+t183data.t183ESigDate+'</ef:T183ElectronicSignatureDate>'); //2022-12-31
    add('       <ef:T183ElectronicSignatureTime>'+t183data.t183ESigTime+'</ef:T183ElectronicSignatureTime>'); //23:59:59
  end;
  add('     </ef:T183ElectronicSignatureData>');


  add('    <ef:RepresentativeID>'+t183data.taxProDataRepId+'</ef:RepresentativeID>');

  add('   </t3rq:TaxProfessionalData>');



  //20220315
  add('   <t3rq:TaxYear>'+AppYear+'</t3rq:TaxYear>');
  add('   <t3rq:SoftwareID>'+t183data.softwareId+'</t3rq:SoftwareID>');   //20220317
  add('   <t3rq:SoftwareRevisionDate>'+t183data.softwareRevisionDate+'</t3rq:SoftwareRevisionDate>');

  add('   <comm:FirstTimeFilerIndicator>'+t183data.firstTimeFilerIndicator+'</comm:FirstTimeFilerIndicator>');

  if t183data.testCaseIdentifier > '' then
      add('   <comm:TestCaseIdentifier>'+ t183data.testCaseIdentifier +'</comm:TestCaseIdentifier>');

  add('   <comm:OriginatingIP>'+ t183data.originatingIp +'</comm:OriginatingIP>');


  //end T183 ========================================================================================================================


  add('   <t3rq:TaxForm>');
  add('   <t1135:ForeignIncomeVerificationStatement>');

  { This addition fails
  //20220328
  add('   <t1135:TaxYear>'+AppYear+'</t1135:TaxYear>');
  add('   <t1135:SoftwareID>'+SoftVendor+'</t1135:SoftwareID>');
  add('   <t1135:SoftwareRevisionDate>'+SOFTRELEASEYEAR+'-'+SOFTRELEASEMonth+'-'+SOFTRELEASEDay+'</t1135:SoftwareRevisionDate>');
  }

  cd:='0'; //20150414
  If FetchElm(RetNo,'T1135',22)>'' then CD:='1' else cd:='0';  //20220315
  add('       <t1135:AmendedReturnIndicator>'+Cd+'</t1135:AmendedReturnIndicator>');  //20150414
  add('       <t1135:TaxpayerIdentification>');
  add('         <t1135:TrustTaxpayer>');
  add('           <t1135:TrustName>'+FetchElmFNo(RetNo,t1135FNo,10)+'</t1135:TrustName>');
  add('           <ccms:TrustNumber>'+GetTrustNumber(RetNo, 'T1135', TestOrProductionGroup.ItemIndex = 0)+'</ccms:TrustNumber>'); //jz 20240326
  add('         </t1135:TrustTaxpayer>');
  add('       </t1135:TaxpayerIdentification>');

  add('       <t1135:TaxpayerAddress>');
  s:=FetchElmFNo(RetNo,t1135FNo,34)+' '+FetchElmFNo(RetNo,t1135FNo,15);  //20150207
  If s>'' then Add('         <t1135:AddressStreetText>'+AllTrim(s)+'</t1135:AddressStreetText>');
  s:=FetchElmFNo(RetNo,t1135FNo,17);If s>'' then Add('         <t1135:AddressMunicipalityName>'+s+'</t1135:AddressMunicipalityName>');
  s:=FetchElmFNo(RetNo,t1135FNo,63);If s>'' then Add('         <t1135:GlobalProvinceTerritoryStateCode>'+s+'</t1135:GlobalProvinceTerritoryStateCode>');
  s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,16),' ');If s>'' then Add('         <t1135:GlobalPostalZipCode>'+s+'</t1135:GlobalPostalZipCode>');
  s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,28),' ');If s>'' then Add('         <t1135:CountryCode>'+s+'</t1135:CountryCode>'); //20150127
  add('       </t1135:TaxpayerAddress>');

  add('      <t1135:TaxationYearData>'); //20150127
  s:=FetchElmFNo(RetNo,t1135FNo,19);If s>'' then Add('        <t1135:TaxationYearStartDate>'+s+'</t1135:TaxationYearStartDate>');
  s:=FetchElmFNo(RetNo,t1135FNo,20);If s>'' then Add('        <t1135:TaxationYearEndDate>'+s+'</t1135:TaxationYearEndDate>');
  add('      </t1135:TaxationYearData>');
  //20220128 Igor <<<

//------------------------------------------------------------------------------

   add('<t1135:ForeignPropertyIdentification>');
   //20220128 Igor >>>
   if (FetchElmFNo(RetNo,t1135FNo,36)>'') then
    add('  <t1135:ForeignPropertyCostCategoryOne>')
   else
    add('  <t1135:ForeignPropertyCostCategoryTwo>');
   if (FetchElmFNo(RetNo,t1135FNo,36)>'') and (FetchElmFNo(RetNo,t1135FNo,86)='')  then  //category 1     //20160125
   begin
     add('    <t1135:ForeignPropertySimplifiedData>');

     add(' <t1135:ForeignPropertyIndicator>');
     //20240117 JZ
     If FetchElmFNo(RetNo,t1135FNo,46)>'' then add(' <t1135:ForeignFundsIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,46)) +'</t1135:ForeignFundsIndicator>');
     If FetchElmFNo(RetNo,t1135FNo,47)>'' then add(' <t1135:NonResidentCorporationShareIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,47)) +'</t1135:NonResidentCorporationShareIndicator>');
     If FetchElmFNo(RetNo,t1135FNo,48)>'' then add(' <t1135:NonResidentIndebtednessIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,48)) +'</t1135:NonResidentIndebtednessIndicator>');
     If FetchElmFNo(RetNo,t1135FNo,49)>'' then add(' <t1135:NonResidentTrustInterestIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,49)) +'</t1135:NonResidentTrustInterestIndicator>');
     If FetchElmFNo(RetNo,t1135FNo,50)>'' then add(' <t1135:ForeignRealPropertyIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,50)) +'</t1135:ForeignRealPropertyIndicator>');
     If FetchElmFNo(RetNo,t1135FNo,53)>'' then add(' <t1135:OtherForeignPropertyIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,53)) +'</t1135:OtherForeignPropertyIndicator>');
     If FetchElmFNo(RetNo,t1135FNo,55)>'' then add(' <t1135:CanadianHeldForeignPropertyIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,55)) +'</t1135:CanadianHeldForeignPropertyIndicator>'); //20170129
    add(' </t1135:ForeignPropertyIndicator>');

    (*
     //20160307
     add('      <t1135:ForeignPropertyIndicator>');
      add('        <t1135:ForeignFundsIndicator>'                + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,46)) +'</t1135:ForeignFundsIndicator>');
      add('        <t1135:NonResidentCorporationShareIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,47)) +'</t1135:NonResidentCorporationShareIndicator>');
      add('        <t1135:NonResidentIndebtednessIndicator>'     + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,48)) +'</t1135:NonResidentIndebtednessIndicator>');
      add('        <t1135:NonResidentTrustInterestIndicator>'    + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,49)) +'</t1135:NonResidentTrustInterestIndicator>');
      add('        <t1135:ForeignRealPropertyIndicator>'         + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,50)) +'</t1135:ForeignRealPropertyIndicator>');
      add('        <t1135:OtherForeignPropertyIndicator>'        + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,53)) +'</t1135:OtherForeignPropertyIndicator>');
      add('        <t1135:CanadianHeldForeignPropertyIndicator>'  + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,55)) +'</t1135:CanadianHeldForeignPropertyIndicator>'); //20170129
     add('      </t1135:ForeignPropertyIndicator>');
    *)


     add('      <t1135:ForeignPropertyCountryCodes>');
     If FetchElmFNo(RetNo,t1135FNo,57)>'' then add('        <t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,57) +'</t1135:MaximumCostForeignCountryCode>');
     If FetchElmFNo(RetNo,t1135FNo,58)>'' then add('        <t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,58) +'</t1135:MaximumCostForeignCountryCode>');
     If FetchElmFNo(RetNo,t1135FNo,59)>'' then add('        <t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,59) +'</t1135:MaximumCostForeignCountryCode>');
     //add('        <t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,59) +'</t1135:MaximumCostForeignCountryCode>'); //wrong
     add('      </t1135:ForeignPropertyCountryCodes>');
     add('      <t1135:AllForeignPropertyIncomeAmount>'         + RemoveChar(FetchElmFNo(RetNo,t1135FNo,60),',') + '</t1135:AllForeignPropertyIncomeAmount>');    //20160125
     add('      <t1135:AllForeignPropertyDispositionGainLossAmount>'+ RemoveChar(FetchElmFNo(RetNo,t1135FNo,64),',') +'</t1135:AllForeignPropertyDispositionGainLossAmount>'); //20160125
     add('    </t1135:ForeignPropertySimplifiedData>');
   end

   else
   begin
    add('      <t1135:ForeignPropertyDetailedData>');
  //20220128 Igor <<<

  //ForeignFunds                 DONE
  //If Vl(FetchElmFNo(RetNo,t1135FNo,18))<>0 then  //there is total holdings for this category
  If FetchElmFNo(RetNo,t1135FNo,10001)>'' then   //20150221
  Begin
   add('<t1135:ForeignFunds>');
   ArrayNo:=1; BoxesPerRow:=5;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
      s:=FetchElmFNo(RetNo,t1135FNo,Elm);
      If S>'' then
      begin
       add('<t1135:ForeignFundsRecord>');
       s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,Elm));Add('<t1135:ForeignFundsBankEntityName>'+s+'</t1135:ForeignFundsBankEntityName>');
       s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add('<t1135:ForeignFundsCountryCode>'+s+'</t1135:ForeignFundsCountryCode>');
       s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add('<t1135:ForeignFundsMaximumYearlyHeldAmount>'+s+'</t1135:ForeignFundsMaximumYearlyHeldAmount>');
       s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add('<t1135:ForeignFundsHeldYearEndAmount>'+s+'</t1135:ForeignFundsHeldYearEndAmount>');
       s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add('<t1135:ForeignFundsIncomeAmount>'+s+'</t1135:ForeignFundsIncomeAmount>'); //new 2016, removed 'loss'
       Add('</t1135:ForeignFundsRecord>');
      end;
      Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,18))));Add('<t1135:ForeignFundsTotalHeldYearEndAmount>'+s+'</t1135:ForeignFundsTotalHeldYearEndAmount>');  //totl line
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,31))));Add('<t1135:ForeignFundsTotalIncomeAmount>'+s+'</t1135:ForeignFundsTotalIncomeAmount>');  //new 2016, removed 'loss'
   add('</t1135:ForeignFunds>');
  end;

  // NonResidentCorporationShare   DONE
  //If Vl(FetchElmFNo(RetNo,t1135FNo,32))<>0 then  //there is total holdings for this category
  If FetchElmFNo(RetNo,t1135FNo,20001)>'' then   //20150221
  Begin
   add('<t1135:NonResidentCorporationShare>');
   ArrayNo:=2; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     add('<t1135:NonResidentCorporationShareRecord>');
     s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,Elm));Add('<t1135:NonResidentCorporationName>'+s+'</t1135:NonResidentCorporationName>');
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add('<t1135:NonResidentCorporationCountryCode>'+s+'</t1135:NonResidentCorporationCountryCode>');

     //s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+??))));Add('<t1135:NonResidentCorporationShareMaximumYearly>'+s+'</t1135:NonResidentCorporationShareMaximumYearly>'); //new 2016

     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add('<t1135:NonResidentCorporationShareMaximumYearlyCostAmount>'+s+'</t1135:NonResidentCorporationShareMaximumYearlyCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add('<t1135:NonResidentCorporationShareYearEndCostAmount>'+s+'</t1135:NonResidentCorporationShareYearEndCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add('<t1135:NonResidentCorporationShareIncomeAmount>'+s+'</t1135:NonResidentCorporationShareIncomeAmount>'); //new 2016, removed loss
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add('<t1135:NonResidentCorporationShareDispositionGainLossAmount>'+s+'</t1135:NonResidentCorporationShareDispositionGainLossAmount>');
     add('</t1135:NonResidentCorporationShareRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
    //TotalS
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,32))));Add('<t1135:NonResidentCorporationShareTotalYearEndCostAmount>'+s+'</t1135:NonResidentCorporationShareTotalYearEndCostAmount>');

    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,33))));Add('<t1135:NonResidentCorporationShareTotalIncomeAmount>'+s+'</t1135:NonResidentCorporationShareTotalIncomeAmount>'); //new 2016, removed 'loss'

    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,43))));Add('<t1135:NonResidentCorporationShareTotalDispositionGainLossAmount>'+s+'</t1135:NonResidentCorporationShareTotalDispositionGainLossAmount>');
    add('</t1135:NonResidentCorporationShare>');
  End;

  // NonResidentIndebtedness  ----------  DONE
  //If Vl(FetchElmFNo(RetNo,t1135FNo,40))<>0 then
  If FetchElmFNo(RetNo,t1135FNo,30001)>'' then   //20150221
  Begin
   add('<t1135:NonResidentIndebtedness>');
   ArrayNo:=3; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
      add('<t1135:NonResidentIndebtednessRecord>');
      s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,Elm));Add('<t1135:NonResidentIndebtednessDescription>'+s+'</t1135:NonResidentIndebtednessDescription>');
      s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add('<t1135:NonResidentIndebtednessCountryCode>'+s+'</t1135:NonResidentIndebtednessCountryCode>');

      //s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+?))));Add('<t1135:NonResidentIndebtednessMaximumYearly>'+s+'</t1135:NonResidentIndebtednessMaximumYearly>'); //new 2016 ??

      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add('<t1135:NonResidentIndebtednessMaximumYearlyCostAmount>'+s+'</t1135:NonResidentIndebtednessMaximumYearlyCostAmount>');
      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add('<t1135:NonResidentIndebtednessYearEndCostAmount>'+s+'</t1135:NonResidentIndebtednessYearEndCostAmount>');
      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add('<t1135:NonResidentIndebtednessIncomeAmount>'+s+'</t1135:NonResidentIndebtednessIncomeAmount>'); //new 2016, removed loss
      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add('<t1135:NonResidentIndebtednessDispositionGainLossAmount>'+s+'</t1135:NonResidentIndebtednessDispositionGainLossAmount>');
      add('</t1135:NonResidentIndebtednessRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,40))));Add('<t1135:NonResidentIndebtednessTotalYearEndCostAmount>'+s+'</t1135:NonResidentIndebtednessTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,41))));Add('<t1135:NonResidentIndebtednessTotalIncomeAmount>'+s+'</t1135:NonResidentIndebtednessTotalIncomeAmount>'); //new 2016, removed loss
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,45))));Add('<t1135:NonResidentIndebtednessTotalDispositionGainLossAmount>'+s+'</t1135:NonResidentIndebtednessTotalDispositionGainLossAmount>');
   add('</t1135:NonResidentIndebtedness>');
  end;

  // NonResidenttrust       DONE----------------------------------------
  //If Vl(FetchElmFNo(RetNo,t1135FNo,51))<>0 then
  If FetchElmFNo(RetNo,t1135FNo,40001)>'' then   //20150221
  Begin
  add('<t1135:NonResidentTrustInterest>'); //20150127
   ArrayNo:=4; BoxesPerRow:=7;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
    add('<t1135:NonResidentTrustInterestRecord>');
    s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,Elm));Add('<t1135:NonResidentTrustInterestName>'+s+'</t1135:NonResidentTrustInterestName>');
    s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add('<t1135:NonResidentTrustInterestCountryCode>'+s+'</t1135:NonResidentTrustInterestCountryCode>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add('<t1135:NonResidentTrustInterestMaximumYearlyCostAmount>'+s+'</t1135:NonResidentTrustInterestMaximumYearlyCostAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add('<t1135:NonResidentTrustInterestYearEndCostAmount>'+s+'</t1135:NonResidentTrustInterestYearEndCostAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add('<t1135:NonResidentTrustInterestIncomeReceivedAmount>'+s+'</t1135:NonResidentTrustInterestIncomeReceivedAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add('<t1135:NonResidentTrustInterestCapitalReceivedAmount>'+s+'</t1135:NonResidentTrustInterestCapitalReceivedAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+6))));Add('<t1135:NonResidentTrustInterestDispositionGainLossAmount>'+s+'</t1135:NonResidentTrustInterestDispositionGainLossAmount>');
    add('</t1135:NonResidentTrustInterestRecord>');
   end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,51))));Add('<t1135:NonResidentTrustInterestTotalYearEndCostAmount>'+s+'</t1135:NonResidentTrustInterestTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,52))));Add('<t1135:NonResidentTrustInterestTotalIncomeReceivedAmount>'+s+'</t1135:NonResidentTrustInterestTotalIncomeReceivedAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,54))));Add('<t1135:NonResidentTrustInterestTotalCapitalReceivedAmount>'+s+'</t1135:NonResidentTrustInterestTotalCapitalReceivedAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,56))));Add('<t1135:NonResidentTrustInterestTotalDispositionGainLossAmount>'+s+'</t1135:NonResidentTrustInterestTotalDispositionGainLossAmount>');
   add('</t1135:NonResidentTrustInterest>');   //see original   //20150127
  end;

  // ForeignRealProperty    DONE-----------------------------------
  //If Vl(FetchElmFNo(RetNo,t1135FNo,61))<>0 then
  If FetchElmFNo(RetNo,t1135FNo,50001)>'' then   //20150221
  Begin
   add('<t1135:ForeignRealProperty>');
   ArrayNo:=5; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     add('<t1135:ForeignRealPropertyRecord>');
     s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,Elm));Add('<t1135:ForeignRealPropertyDescription>'+s+'</t1135:ForeignRealPropertyDescription>');
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add('<t1135:ForeignRealPropertyCountryCode>'+s+'</t1135:ForeignRealPropertyCountryCode>'); //new 2016, 'oth' code no longer valid
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add('<t1135:ForeignRealPropertyMaximumYearlyCostAmount>'+s+'</t1135:ForeignRealPropertyMaximumYearlyCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add('<t1135:ForeignRealPropertyYearEndCostAmount>'+s+'</t1135:ForeignRealPropertyYearEndCostAmount>'); //new 2016, removed 'loss' wrong in the guide, ok in the examples
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add('<t1135:ForeignRealPropertyIncomeAmount>'+s+'</t1135:ForeignRealPropertyIncomeAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add('<t1135:ForeignRealPropertyDispositionGainLossAmount>'+s+'</t1135:ForeignRealPropertyDispositionGainLossAmount>');
     add('</t1135:ForeignRealPropertyRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,61)))); Add('<t1135:ForeignRealPropertyTotalYearEndCostAmount>'+s+'</t1135:ForeignRealPropertyTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,62))));Add('<t1135:ForeignRealPropertyTotalIncomeAmount>'+s+'</t1135:ForeignRealPropertyTotalIncomeAmount>'); //new 2016, removed 'loss'
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,68))));Add('<t1135:ForeignRealPropertyTotalDispositionGainLossAmount>'+s+'</t1135:ForeignRealPropertyTotalDispositionGainLossAmount>');
   add('</t1135:ForeignRealProperty>');
  end;

  //OtherForeignProperty  ----------DONE---------------------------
  //If Vl(FetchElmFNo(RetNo,t1135FNo,81))<>0 then
  If FetchElmFNo(RetNo,t1135FNo,60001)>'' then   //20150221
  Begin
   add('<t1135:OtherForeignProperty>');
   ArrayNo:=6; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     Add('<t1135:OtherForeignPropertyRecord>');
     s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,Elm));Add('<t1135:OtherForeignPropertyDescription>'+s+'</t1135:OtherForeignPropertyDescription>');
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add('<t1135:OtherForeignPropertyCountryCode>'+s+'</t1135:OtherForeignPropertyCountryCode>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add('<t1135:OtherForeignPropertyMaximumYearlyCostAmount>'+s+'</t1135:OtherForeignPropertyMaximumYearlyCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add('<t1135:OtherForeignPropertyYearEndCostAmount>'+s+'</t1135:OtherForeignPropertyYearEndCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add('<t1135:OtherForeignPropertyIncomeAmount>'+s+'</t1135:OtherForeignPropertyIncomeAmount>'); //new 2016, removed 'loss'
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add('<t1135:OtherForeignPropertyDispositionGainLossAmount>'+s+'</t1135:OtherForeignPropertyDispositionGainLossAmount>');
     add('</t1135:OtherForeignPropertyRecord>');
   end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,81))));Add('<t1135:OtherForeignPropertyTotalYearEndCostAmount>'+s+'</t1135:OtherForeignPropertyTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,82))));Add('<t1135:OtherForeignPropertyTotalIncomeAmount>'+s+'</t1135:OtherForeignPropertyTotalIncomeAmount>'); //new 2016, removed 'loss'
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,85))));Add('<t1135:OtherForeignPropertyTotalDispositionGainLossAmount>'+s+'</t1135:OtherForeignPropertyTotalDispositionGainLossAmount>');
   add('</t1135:OtherForeignProperty>');
  end;

  // CanadianHeldForeignProperty--------DONE -------------------------------
  //If Vl(FetchElmFNo(RetNo,t1135FNo,37))<>0 then
  If FetchElmFNo(RetNo,t1135FNo,70001)>'' then   //20150221
  Begin
   add('<t1135:CanadianHeldForeignProperty>');
   ArrayNo:=7; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     Add('<t1135:CanadianHeldForeignPropertyRecord>');
     s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,Elm));Add('<t1135:CanadianHeldForeignPropertySecurityDealerTrustCompanyName>'+s+'</t1135:CanadianHeldForeignPropertySecurityDealerTrustCompanyName>');
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add('<t1135:CanadianHeldForeignPropertyCountryCode>'+s+'</t1135:CanadianHeldForeignPropertyCountryCode>');
     //20150126
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));
       If s>'' then  Add('<t1135:CanadianHeldForeignPropertyMaximumYearlyFairMarketValueAmount>'+s+'</t1135:CanadianHeldForeignPropertyMaximumYearlyFairMarketValueAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));
       If S>'' then Add('<t1135:CanadianHeldForeignPropertyYearEndFairMarketValueAmount>'+s+'</t1135:CanadianHeldForeignPropertyYearEndFairMarketValueAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add('<t1135:CanadianHeldForeignPropertyIncomeAmount>'+s+'</t1135:CanadianHeldForeignPropertyIncomeAmount>'); //new 2016, removed 'loss'
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add('<t1135:CanadianHeldForeignPropertyDispositionGainLossAmount>'+s+'</t1135:CanadianHeldForeignPropertyDispositionGainLossAmount>');
     add('</t1135:CanadianHeldForeignPropertyRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,37))));Add('<t1135:CanadianHeldForeignPropertyTotalYearEndFairMarketValueAmount>'+s+'</t1135:CanadianHeldForeignPropertyTotalYearEndFairMarketValueAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,38))));Add('<t1135:CanadianHeldForeignPropertyTotalIncomeAmount>'+s+'</t1135:CanadianHeldForeignPropertyTotalIncomeAmount>'); //new 2016, removed 'loss'
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,44))));Add('<t1135:CanadianHeldForeignPropertyTotalDispositionGainLossAmount>'+s+'</t1135:CanadianHeldForeignPropertyTotalDispositionGainLossAmount>');
   add('</t1135:CanadianHeldForeignProperty>');
  end;

    add('      </t1135:ForeignPropertyDetailedData>');
  //20220128 Igor >>>
  end;
  if (FetchElmFNo(RetNo,t1135FNo,36)>'') then
   add('  </t1135:ForeignPropertyCostCategoryOne>')
  else
   add('  </t1135:ForeignPropertyCostCategoryTwo>');
  //20220128 Igor <<<

  add('  </t1135:ForeignPropertyIdentification>');

  // ---------------------------------------------------------------------------

  Add('<t1135:CertificationDetail>');
  //20220128 Igor >>>
  Add('<t1135:CertifierName>');
  Add('<t1135:TaxpayerName>');
  s:=AllTrim(FetchElmFNo(RetNo,t1135FNo,70));
  if Pos(' ',s) > 0 then
  begin
    Add('<t1135:GivenName>'+Copy(s, 1, Pos(' ', s) - 1)+'</t1135:GivenName>');
    Add('<t1135:FamilyName>'+Copy(s, Pos(' ', s) + 1, Length(s))+'</t1135:FamilyName>');
  end
  else
  begin
    Add('<t1135:GivenName>'+s+'</t1135:GivenName>');
    Add('<t1135:FamilyName></t1135:FamilyName>');
  end;
  add('</t1135:TaxpayerName>');
  add('</t1135:CertifierName>');

  s:=FetchElmFNo(RetNo,t1135FNo,71);If s>'' then Add('<t1135:CertifierPositionTitle>'+s+'</t1135:CertifierPositionTitle>');
  //s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,72),'-');  //jz//20260304 -- ACTUALLY NO THEY DONT -- they want the dashes in the test cases now, do not remove
  //s:='1-'+ FetchElmFNo(RetNo,t1135FNo,72);            //jz//20260304 -- ACTUALLY NO THEY DONT -- they want the "1" test cases now, add
  s:=FetchElmFNo(RetNo,t1135FNo,72);                    //jz//20260304 -- put whatever is entered as test cases have different formats
  Add('<t1135:CertifierPhoneNumber>'+s+'</t1135:CertifierPhoneNumber>'); //20150127
  s:=FetchElmFNo(RetNo,t1135FNo,73);Add('<t1135:CertificationDate>'+s+'</t1135:CertificationDate>');

 If UpperCase(FetchElmFNo(RetNo,T1135FNo,29)) = 'Y' then
 Begin
  s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,74));  //20150305
  Add('<t1135:PreparerName>'+s+'</t1135:PreparerName>');
  Add('<t1135:PreparerAddress>');
 //20230208
  s:=FetchElmFNo(RetNo,t1135FNo,75)+' '+FetchElmFNo(RetNo,t1135FNo,78)+' '+FetchElmFNo(RetNo,t1135FNo,79);    //20230208
     Add('<t1135:GlobalAddress>'+s+'</t1135:GlobalAddress>');

  s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,76),' ');  //20150226
  add('<t1135:GlobalPostalZipCode>'+s+'</t1135:GlobalPostalZipCode>');
  add('</t1135:PreparerAddress>');

  //s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,77),'-');    //jz//20260304 -- ACTUALLY NO THEY DONT -- they want the dashes in the test cases now, do not remove
  //s:='1-'+ FetchElmFNo(RetNo,t1135FNo,77);              //jz//20260304 -- ACTUALLY NO THEY DONT -- they want the "1" test cases now, add
  s:=FetchElmFNo(RetNo,t1135FNo,77);                      //jz//20260304 -- put whatever is entered as test cases have different formats
  add('<t1135:PreparerPhoneNumber>'+s+'</t1135:PreparerPhoneNumber>');
 end;

 add('</t1135:CertificationDetail>');

  //new stuff
  add('     </t1135:ForeignIncomeVerificationStatement>');
  add('   </t3rq:TaxForm>');
  add(' </t3rq:T3FrrmsReturnRequest>');

  //20220128 Igor <<<
 //mine
 add('</soapenv:Body>');
 add('</soapenv:Envelope>');

 end; //with xmllist

 //Now save the list to a file
 SoapMsg:='';
 For I:=0 to XmlList.count-1 do
  SoapMsg:=SoapMsg+XmlList[i]; //+Chr(13);
 If FileExists(MkSubmittedFileName(RetNo)) then  DeleteFile(MkSubmittedFileName(RetNo));

 //XmlList.SaveToFile(MkSubmittedFileName(RetNo));
 saveXMLWithNoCRAPasswordID(MkSubmittedFileName(RetNo),XmlList,(OnLineNo = 'B0865'));

 FreeAndNil(XmlList); //20180228 Igor
End;

procedure TT1135EfileT3_2026.testResponseClick(Sender: TObject);
var
    tempResponseList:tstringlist;
    AckResponseFlName, T1135ResponseHTM, ResponseXmlFile:string;
    T1135ResponseRec:TT1135AckRec;
begin
 OpenDialog1.FileName := '*Response*';
 //OpenDialog1.FileName := '';

 OpenDialog1.InitialDir:= T1135EfileDir; //NetFileDir;
 OpenDialog1.Filter := 'XML files (*.xml)|*.xml|'+
                       'Any (*.*)|*.*';
 If OpenDialog1.Execute then
 begin
   tempResponseList := TStringList.Create;
   tempResponseList.loadFromFile(OpenDialog1.FileName);

   T1135ResponseRec := parseT1135Response(tempResponseList.text);

   T1135ResponseHTM := CreateT1135ResponseHtm(RetNo,T1135ResponseRec,AppDir +'\'+ 'ResponseDisplayTemplateT1135.htm');

   //AckResponseFlName:=NetFileDir+'\'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo)+'-EfileAck','.')+'.htm'; //AckResponseFlName:=ChangeFileExt(OpenDialog1.FileName, '.htm');
   If FileExists(T1135ResponseHTM) then
    ShellExecute(Self.Handle, nil, PChar('' + T1135ResponseHTM), nil, nil, SW_NORMAL);

 end;
end;



function TT1135EfileT3_2026.GetAmendSuffix: string; //20220128 Igor
begin
  If FetchElm(RetNo,'T1135',22)>'' then
    Result := '_AMEND'
  else
    Result := '';
end;

{
Function TT1135EfileT3_2026.GetDcnSeqNoForT1135(RetNo:Integer;OnLineNo:String):String;
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

   // What Birthdate should be used here?
   Result:=sAppYear+Sdd+SSec+RightStr(SMSec,1);    //2005

   //If length(result)<> 13 then result:='';
end;
}

//20160124
procedure TT1135EfileT3_2026.CancelBtnClick(Sender: TObject);
begin
 Close;  //20170219
end;

Function TT1135EfileT3_2026.ConvertCheckBoxTo1(S:String):String;  //20160124 //20220128 Igor
Begin
  Result:=s;
  If UpperCase(s)='X' then
    Result:='1'
  else
    Result:='0';
end;

end.

