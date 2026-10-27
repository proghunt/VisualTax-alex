unit T2_2027T1135efile;
{
 To test
http://www.service-repository.com/client/input?operation=EfileReturnRequest&wsdlURL=https%3A%2F%2Fapps-ct.cra-arc.gc.ca%2Febci%2Fefes%2Ffrrms%2Fws%2Fservices%2FFileFormService%3Fwsdl&portType=FileFormSoapBindingImpl
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, FileCtrl,
  T2_2027TrimStr, T2_2027Declare, T2_2027Common, T2_2027Common2, Db, DBTables, Grids, DBGrids,   //20150120 Igor
  ShellApi,ComCtrls,ComObj,TLHelp32, Activex,ShlObj,
  //MSSOAPLib30_TLB,     //does not seem to be needed for sending receiving  //20110129 it has dom
  MsXml2_TLB, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, System.IOUtils; //20110129  NEEDED for connection and the response handler //20240222 Igor

  //20250725
  Const SOFTRELEASEYEAR   = '2025';  //20131031
  Const SOFTRELEASEMONTH  = '07';  //20161219
  Const SOFTRELEASEDAY    = '26';


 Const CrLf         =  Chr(13)+Chr(10);
 //20160606  N/A to T2

 Const useEfilerNumber = 0;
 Const useWAC          = 1;

type
  TT1135EfileT2_2027 = class(TForm)
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
    Bevel1: TBevel;
    BitBtn5: TBitBtn;
    Label9: TLabel;
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


    procedure setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);

    Function ReplaceXMLChars(info: String): String;  //20161213
    Function ConvertCheckBoxTo1(S:String):String;  //20160124
    Function  GetDcnSeqNoForT1135(RetNo:Integer;OnLineNo:String):String; //20150305
    procedure CreateT1135SoapMessage(RetNo:Integer);
    procedure GetUrlBox;
    Function  MkSubmittedFileName(RetNo:Integer):String;
    Function  MkResponseFileName(RetNo:Integer):String;
    procedure SubmitBtnClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);

    Procedure SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);

    Function CreateT1135ResponseHtm(T1135ResponseRec: T1135AckRec;
      HtmTemplateFileName, ResponseXmlFileName: String): String;
    Function GetT1135ErrorDescr(ErrorCode:String):AnsiString;  //20140119
    Function parseT1135Response(rString:AnsiString):T1135AckRec;
    Function CreateT1135EfileResponseHtm(RetNo: Integer; AckRec: T1135AckRec; HtmFile: String):String; //20160523 Igor
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
  private
    { Private declarations }
    RetNo:Integer;   //20160120 Igor
  public
    { Public declarations }
  end;

var
  SoftwareId:String;    //20160613
  T1135Efile: TT1135EfileT2_2027;
 // Fx1135:AT1135FX;
  userName1135,passWord1135 :string;
  SoapMsg:AnsiString;
  OnLineNo,TransmitterNo,PassWord,FileName,Url,OnlineMethod:String;
  webServiceUserName, webServicePassword: String;
  NetFileDir:String;
  FormCnt:Integer;
  T1135EfileDir: String;
  sUrl:String;

  AckRecT1135:T1135AckRec;

implementation

uses vtDataBase, vtMulti,vtCommon,vtMain, vtTrimStr, T2_2027, T2_2027main,
  vtShared, vtDynData{,childwinnew} //20150120 Igor
  , uXMLValidator; //20250806 Igor

{$R *.DFM}

procedure TT1135EfileT2_2027.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
 RetNo:=GetCurrentRetNo;

 sendCredentials.ItemIndex := useEfilerNumber;
 if not GetWacNumber(RetNo).IsEmpty then
  sendCredentials.ItemIndex := useWAC;


 GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20240223 Igor
 T1135EfileDir:=TPath.Combine(NetFileDir, 'T1135Efile'); //20240222 Igor
 If DirectoryExists(T1135EfileDir) = false then ForceDirectories(T1135EfileDir);

 //if TestOrProductionGroup.visible = true then TestOrProductionGroup.itemindex := 1;  //20130212

 If RetNo>0 then
 begin
   If ValidForT1135Efile(RetNo,GetFormNo('T1135#1')) = false then
   Begin  SoapMsg:='';  Exit; End;
 end;

 CreateT1135SoapMessage(RetNo);
end;

procedure TT1135EfileT2_2027.SubmitBtnClick(Sender: TObject);
// 20250806 Igor >>>
var
  RetNo:Integer;FlName:String;
  lXMLValidationErrorList: TStringList;
  ifor: Integer;
  lErrorsString: string;
  lXSDFilesList: TStringList;
  // 20250806 Igor <<<
begin
 //20150312
 If ValidPostal(RetNo,OptRec.Prp_Postal) = false then
 begin
  ShowMessage('Please fix the Postal code in Configure -> General Options -> Preparer');
  Exit;
 end;

 //20150207
 RetNo:=GetCurrentRetNo;
 If FetchElm(RetNo,'T1135',39)>'' then  //has confirmation
 Begin
  If FetchElm(RetNo,'T1135',22)='' then //amended = false
  Begin
   ShowMessage('This T1135 has been already Efiled and it has a Confirmation number.'
   +Chr(13)+'Unless you check the Amended box');
  Exit;
  end;
 end;

 FlName:=MkSubmittedFileName(RetNo);
 CreateT1135SoapMessage(RetNo);

 // 20250806 Igor >>>
 lXMLValidationErrorList:= TStringList.Create;
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
   lXSDFilesList.Add('http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0,t2efilefrrmsrequest.xsd');

   //TXMLValidator.XMLValidate(AppDir, lXSDFilesList, MkSubmittedFileName(RetNo), lXMLValidationErrorList);
   TXMLValidator.XMLValidate(ExtractFilePath(ParamStr(0)) + T2_2027Declare.AppName + '-' + T2_2027Declare.AppYear, lXSDFilesList, MkSubmittedFileName(RetNo), lXMLValidationErrorList);

   if (lXMLValidationErrorList.Count > 0) and not lXMLValidationErrorList[0].StartsWith('XSD file not found:') then
   begin
     TXMLValidator.ShowErrorsInHTML(lXMLValidationErrorList);
     Exit;
   end;
 finally
   lXMLValidationErrorList.Free;
   lXSDFilesList.Free;
 end;
 // 20250806 Igor <<<

 //  --------------
 If SoapMsg='' then
 Begin
  ShowMessage('No data available for submission');
  Exit;
 end;
 SubmitSoapMsg(SoapMsg,MkSubmittedFileName(RetNo));
end;

Procedure TT1135EfileT2_2027.SubmitSoapMsg(SoapMsg:AnsiString;FlName:String);
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
 T1135ResponseRec:T1135AckRec;
 T1135ResponseHTM:string;
Begin


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

 If EfileOptionGroup.ItemIndex=0 then  //single return
 Begin
   T1135ResponseRec := parseT1135Response(WString);

   T1135ResponseHTM := CreateT1135EfileResponseHtm(RetNo,AckRecT1135,AppDir +'\'+ 'EFT1135ResponseTemplate.htm');

   If (AckRecT1135.T1135resultType=T1135accepted){AckRec.Accepted} then
   Begin
    //T1135ResponseHTM := CreateEfileResponseHtm(RetNo,AckRecT1135,AppDir +'\'+ 'EFAccepted.htm');
    StoreElm(RetNo,GetFormNo('T1135'),39,AckRecT1135.TransmitterID);   //20150207
    If not SaveReturn(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName,True,False) =0 then
                ShowMessage('Return cannot be saved'); //20150208
   end;

   {
   Else If AckRecT1135.T1135resultType=T1135webserviceError then
    T1135ResponseHTM := CreateEfileResponseHtm(RetNo,AckRecT1135,AppDir +'\'+ 'EFWebServError.htm')
   Else
    T1135ResponseHTM := CreateEfileResponseHtm(RetNo,AckRecT1135,AppDir +'\'+ 'EFNotAccepted.htm');
   }
    h := ShellExecute(Self.Handle, nil, PChar('' + T1135ResponseHTM), nil, nil, SW_NORMAL);

    If H<=32 then ShowMessage(ResponseXMLfile+ 'not found');

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
  If FileExists(s) then RenameFile(s,ReplaceStr(S, 'ToBeSubmitted', 'Submitted')); //rename it
 end;
 objHttp:=Nil;  //20110129  .Free It is not accepted

end;


procedure TT1135EfileT2_2027.FormActivate(Sender: TObject);
begin
  //GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120 //20240223 Igor
  GetUrlBox;
  If (Length(OnlineNo)<>5) or (Password='') then
  begin
   SoapMsg:='';
   ShowMessage('Efiler number/password not entered correctly. Please complete the EfileOnline -> Setup EOL and Setup Eol Plus');
   MainFormT2.SetupEOLInternetFiling1Click(Sender);
   Exit;
  end;

  userName1135 := OnLineNo;
  passWord1135 := Password;

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

procedure TT1135EfileT2_2027.ShowBtnClick(Sender: TObject);
Var h:THandle; FlName:String;
begin
  FlName:=MkSubmittedFileName(RetNo);
  CreateT1135SoapMessage(RetNo);
  h := ShellExecute(Self.Handle,'open',Pchar(''+FlName),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('File not found');
end;

procedure TT1135EfileT2_2027.FormPaint(Sender: TObject);
begin
 If EfileOptionGroup.ItemIndex=0 then
  BatchPanel.Visible:=False
 Else
  BatchPanel.Visible:=True;

 If EfileOptionGroup.ItemIndex=1 then ShowFiles;
end;

procedure TT1135EfileT2_2027.EfileOptionGroupClick(Sender: TObject);
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

procedure TT1135EfileT2_2027.DBGrid1DblClick(Sender: TObject);
Var i:Integer; FlName:String;
SomeList:TStringList;
begin
end;

procedure TT1135EfileT2_2027.BitBtn1Click(Sender: TObject);
begin
DBGrid1DblClick(Sender);
end;

procedure TT1135EfileT2_2027.RemoveBtnClick(Sender: TObject);
begin
ListBox1DblClick(Sender);
end;


procedure TT1135EfileT2_2027.BitBtn2Click(Sender: TObject);
begin
ListBox1.Clear;
end;

Function TT1135EfileT2_2027.MkSelectedStr: String;
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



procedure TT1135EfileT2_2027.ListBox1DblClick(Sender: TObject);
begin
 ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TT1135EfileT2_2027.ShowFiles;
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


Function TT1135EfileT2_2027.MkSubmittedFileName(RetNo:Integer):String;
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
  result:=T1135EfileDir+'\'+'T1135-ToBeSubmitted-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml'  //20160526
  //result:=T1135EfileDir+'\'+'T1135-ToBeSubmitted-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'
 Else
 Begin
  s:=FormatDateTime('yyyy-mm-dd',Date)+'-'+GetMinutesAndSeconds;
  result:=T1135EfileDir+'\'+'T1135-Submitted-Batch'+'-'+S+'.xml';
  //PaddZero(FetchElm(RetNo,FormName1135,9),9) + appYear + PaddZero(inttostr(jmonthDay),3) + PaddZero(IntToStr(Hour),2) + PaddZero(IntToStr(Min),2) + PaddZero(IntToStr(Sec),2) + PaddZero(IntToStr(MSec),3);
 end;
end;

Function TT1135EfileT2_2027.MkResponseFileName(RetNo:Integer):String;
begin
 result:=T1135EfileDir+'\'+'T1135-Response-'+LeftStr(RemoveChar(GetCorpName(RetNo),'.'),30)+'-'+GetAccountNumber(RetNo)+'.xml';  //20160526
 //result:=T1135EfileDir+'\'+'T1135-Response-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'
end;

procedure TT1135EfileT2_2027.GetUrlBox;
begin
 //20150102
 If TestOrProductionGroup.ItemIndex=0 then  //production
   sUrl :='https://apps.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'
  else  //test
   sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl';
   //     'https://apps-ct.cra-arc.gc.ca/ebci/efes/frrms/ws/services/FileFormService?wsdl'

  UrlBox.Text := SUrl;

end;

procedure TT1135EfileT2_2027.TestOrProductionGroupClick(Sender: TObject);
begin
GetUrlBox;
end;

procedure TT1135EfileT2_2027.BitBtn3Click(Sender: TObject);
begin
// MainForm.T1135EfileErrors1Click(Sender);
end;


procedure TT1135EfileT2_2027.SearchBoxChange(Sender: TObject);
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

procedure TT1135EfileT2_2027.BitBtn4Click(Sender: TObject);
Var h:THandle; Pgm:String;
begin
  PGM:=AppDir+'\'+'SOAPSDK.EXE';
  h := ShellExecute(Self.Handle,'open',Pchar(''+Pgm),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Installation interrupted or program not found');
end;

procedure TT1135EfileT2_2027.BitBtn5Click(Sender: TObject);
Var Url:String; h:THandle;
begin
  Url:='http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(self.Handle,'open',Pchar(''+Url),Nil,Nil,Sw_Show);
  If H<=32 then ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

Function TT1135EfileT2_2027.parseT1135Response(rString:AnsiString):T1135AckRec;

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

    searchStringAdjustment:string;

begin

   // idstring := RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.') + chr(10) + chr(13) + GetSinNo(RetNo);  //20160526  ??? not used...

    AckRecT1135.T1135resultType   := T1135rejected;

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

        AckRecT1135.T1135resultType := T1135webserviceError; //jz
        //exit;
    END
{
    ELSE IF pos('SystemError',rString) > 0 then
    BEGIN
        //AckRec.EFresultType := EFwebServiceError;
        AckRecT1135.T1135resultType := T1135webserviceError; //jz
        s       := '<t1rsp:MessageText xml:lang="en">';
        e       := '</t1rsp:MessageText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        fString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
    END
}
    ELSE
    BEGIN

        searchStringAdjustment := '>';
        if sendCredentials.ItemIndex = useWAC then //jz 20240711
          searchStringAdjustment := ' xmlns:t2ersp="http://www.cra-arc.gc.ca/xmlns/t2ersp/t2efilefrrmsresponse/1-0-0">'; //s := '<t2ersp:T2ResultCode xmlns:t2ersp="http://www.cra-arc.gc.ca/xmlns/t2ersp/t2efilefrrmsresponse/1-0-0">';


        //Get result code ------------------------------------------------------------------
        s := '<t2ersp:T2ResultCode'+searchStringAdjustment;

        sPos := pos(s,rString);
        if sPos > 0 then
        begin
                e     := '</t2ersp:T2ResultCode>';
                sPos  := pos(s,rString) + length(s);
                ePos  := pos(e,rString);
                fCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                //AckRecT1135.ResponseCode := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));


                //Get Transmission Number (filename/confirmation number) if exists
                // ------------------------------------------------------------------
                s := '<t2ersp:T2TransmissionNumber'+searchStringAdjustment;
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:T2TransmissionNumber>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedTransmissionID := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT1135.TransmitterID := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                s := '<t2ersp:CorporationName'+searchStringAdjustment;
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:CorporationName>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedCorpName := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT1135.Name := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                s := '<t2ersp:BusinessNumber'+searchStringAdjustment;
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:BusinessNumber>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedBnNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT1135.BnNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                s := '<t2ersp:TaxYear'+searchStringAdjustment;
                sPos := pos(s,rString);
                if sPos > 0 then
                begin
                        e     := '</t2ersp:TaxYear>';
                        sPos  := pos(s,rString) + length(s);
                        ePos  := pos(e,rString);
                        ReturnedTaxYr := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                        //AckRecT1135.TxYear:= AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;

                //get message is still t1rsp: even though for t2 jz???
                tempString:='';
                AckRecResultDescription := '';
                s     := '<t1rsp:MessageText xml:lang="en">';
                e     := '</t1rsp:MessageText>';
                //20211208 Igor >>>
                sPos  := 0;
                ePos  := 0;
                while True do
                begin
                  if pos(s,rString, ePos + 1) = 0 then break;
                  sPos  := pos(s,rString, ePos + 1) + length(s);
                  ePos  := pos(e,rString, ePos + 1);
                  if not String(AckRecResultDescription).IsEmpty then
                    AckRecResultDescription := AckRecResultDescription + '<br>';
                  AckRecResultDescription := AckRecResultDescription + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
                end;
                //20211208 Igor <<<
                //AckRecT1135.ResponseText := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

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
                        AckRecT1135.T1135resultType := T1135accepted; //jz
                end
                else         //else error ------------------------------------------------------------------
                begin

                        //AckRec.EFresultType := EFrejected;  //20140124
                        AckRecT1135.T1135resultType := T1135rejected; //jz
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
                              AckRecT1135.T1135resultType := T1135accepted;//AckRec.EFresultType := EFAccepted;

                        if fCode = '132' then
                        begin
                              //AckRec.EFresultType := EFrejected;
                              AckRecT1135.T1135resultType := T1135rejected; //jz
                        end;
                end;


        end

    END; //else not servererror

    //   MessageDlg(tempString,mtError,[mbOK],0);    //20141211


    With AckRecT1135 do
    Begin
     Name             := ReturnedCorpName;
     BnNumber         := ReturnedBnNumber;
     TransmitterID    := ReturnedTransmissionID;
     TxYear           := ReturnedTaxYr;
     ResponseCode     := fCode;
     ResponseText     := AckRecResultDescription;
     DateTimeReceived := FormatDateTime('yyyy-mm-dd',Date)+ '  '+GetTimeToMilliSec(Date);//FormatDateTime('yyyy-mm-dd',Date);

     if T1135resultType <> T1135accepted then // these are not sent currently on rejected submissions for some reason
     begin
      Name             := GetCorpName(RetNo);
      BnNumber         := GetCorpBusNo(RetNo);
      TxYear           := inttostr(GetTaxationYearEndYYYY(RetNo));
     end;


    end;

end;


Function TT1135EfileT2_2027.GetT1135ErrorDescr(ErrorCode:String):AnsiString;  //20140119
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


Function TT1135EfileT2_2027.CreateT1135ResponseHtm(T1135ResponseRec:T1135AckRec;HtmTemplateFileName,ResponseXmlFileName:String):String;
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
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.Name,[rfReplaceAll, rfIgnoreCase]);

  sString := '!Response!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.Response,[rfReplaceAll, rfIgnoreCase]);

  sString := '!DateTime!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.DateTimeReceived,[rfReplaceAll, rfIgnoreCase]);

  sString := '!TransmitterID!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.TransmitterID,[rfReplaceAll, rfIgnoreCase]);

  sString := '!ConfirmationNumberNo!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.ConfirmationID,[rfReplaceAll, rfIgnoreCase]);

  sString := '!ResponseCode!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.ResponseCode,[rfReplaceAll, rfIgnoreCase]);

  sString := '!ResponseText!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.ResponseText,[rfReplaceAll, rfIgnoreCase]);

  sString := '!additionalText!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, T1135ResponseRec.additionalText,[rfReplaceAll, rfIgnoreCase]);

 end;

 flName := ChangeFileExt(ResponseXmlFileName, '.htm');
 htmlSource.SaveToFile(flName);

 htmlSource.Free;

 result := flName;
end;

procedure TT1135EfileT2_2027.testResponseClick(Sender: TObject);
var
    tempResponseList:tstringlist;
    AckResponseFlName, T1135ResponseHTM, ResponseXmlFile:string;
    T1135ResponseRec:T1135AckRec;
begin
 OpenDialog1.FileName := '*Response*';

 OpenDialog1.InitialDir:= T1135EfileDir; //NetFileDir;
 OpenDialog1.Filter := 'XML files (*.xml)|*.xml|'+
                       'Any (*.*)|*.*';
 If OpenDialog1.Execute then
 begin
   tempResponseList := TStringList.Create;
   tempResponseList.loadFromFile(OpenDialog1.FileName);

   T1135ResponseRec := parseT1135Response(tempResponseList.text);
   T1135ResponseHTM := CreateT1135EfileResponseHtm(RetNo,AckRecT1135,AppDir +'\'+ 'EFT1135ResponseTemplate.htm');

   If FileExists(T1135ResponseHTM) then
    ShellExecute(Self.Handle, nil, PChar('' + T1135ResponseHTM), nil, nil, SW_NORMAL);

 end;
end;



Function TT1135EfileT2_2027.GetDcnSeqNoForT1135(RetNo:Integer;OnLineNo:String):String;
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
Function TT1135EfileT2_2027.ConvertCheckBoxTo1(S:String):String;  //20160124
Begin
 Result:='0';//20160624
 If UpperCase(s)='X' then result:='1';
end;


procedure TT1135EfileT2_2027.CreateT1135SoapMessage(RetNo:Integer);
Const Format1='########0';  //20150221
Var
i,Elm,T1135FNo,ArrayNo,BoxesPerRow,MaxRowsPerArray:Integer; cd:String; //code
TempSoapList:TStringList;
TempDataList:TStringList;
s,FlName:String;
DcnSeqNo:String;

BN,WACnum,AgreementInd:string;

i0, i1_, i2__,i3___,i4____,i5_____,i6______,i7_______:string;

begin
  SoftwareId:= FRRMSsoftwareId; //20231031//'VT46'; //'VT45'; //'VT44'; //'VT43';  //20230728//JZ  //20221213 //20220529

  {
 Softwareid:='VT42';  //20210627
 if GetBegYearend(RetNo)<'2021/01/01' then
    SoftwareId:='VT41'
 else
    SoftwareId:='VT42';
 }
 T1135FNo:=GetFormNo('T1135');
 MaxRowsPerArray:=80;

 i0 := '      ';
 i1_ := i0 + '  ';
 i2__ := i1_ + '  ';
 i3___ := i2__ + '  ';
 i4____ := i3___ + '  ';
 i5_____ := i4____ + '  ';
 i6______ := i5_____ + '  ';
 i7_______ := i6______ + '  ';

 GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120
 setwebServiceUserNamePassword(webServiceUserName,webServicePassword);  //20180423

 XmlList:=TstringList.Create;
 XmlList.Clear;

 With XmlList do
 Begin

  // FROM T2 Corporation Foreign Reporting Web Service Specification Guide, T2 CFR-WS Guide

  add('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">');
  add('<soapenv:Body>');

  //jz 20240711 different headers for Efile vs WAC
  if sendCredentials.ItemIndex = useEfilerNumber then
  begin

    //jz 20240524 from t2efrws_May24e.pdf
      add('  <t2rq:T2EfileReturnRequest'                                                  + ' ' + #13#10 +
          '   ' + 'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'                + ' ' + #13#10 +
          '   ' + 'xmlns:ef="http://www.cra-arc.gc.ca/xmlns/ef/2025/1-0-0"'               + ' ' + #13#10 + // 20251104 Igor
          '   ' + 'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'                  + ' ' + #13#10 +
          '   ' + 'xmlns:t1135="http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0"'         + ' ' + #13#10 +
          '   ' + 'xmlns:t2rq="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0"' + ' ' + #13#10 +
          '   ' + 'xmlns:xml="http://www.w3.org/XML/1998/namespace"'                      + ' ' + #13#10 +
          '   ' + 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                 + ' ' + #13#10 +
          '   ' + 'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t2rq/t2efilerequest/1-0-0 t2efilefrrmsrequest.xsd ">');

    add('  ' + '<ef:TransmitterEfilerNumber>'+webServiceUserName+'</ef:TransmitterEfilerNumber>');
    If webServicePassword>'' then
      add('  ' +  '<ef:PasswordID>'+webServicePassword+'</ef:PasswordID>');

    //jz 20240723
    s := OptRec.Prp_RepId;
    If s>'' then
      add('  ' +  '<ef:RepresentativeID>'+ s +'</ef:RepresentativeID>');

    add('  ' +    '<t2rq:TaxYear>'+LeftStr(GetTaxationYearEnd(RetNo),4)+'</t2rq:TaxYear>');

    add('  ' +    '<t2rq:SoftwareID>'+SoftwareId+'</t2rq:SoftwareID>');  //20210627
    //add('  ' +    '<t2rq:SoftwareID>'+RsiApprovalCode+'</t2rq:SoftwareID>');
    add('    ' +    '<t2rq:TaxForm>');

  end
  else if sendCredentials.ItemIndex = useWAC then
  begin

      //jz 20240710 from t2nfrws_May24e.pdf
      add('  <t2nrq:T2NetfileReturnRequest'                                                 + ' ' + #13#10 +
          '   ' + 'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'                  + ' ' + #13#10 +
          '   ' + 'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'                    + ' ' + #13#10 +
          '   ' + 'xmlns:t1135="http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0"'           + ' ' + #13#10 +
          '   ' + 'xmlns:t2nrq="http://www.cra-arc.gc.ca/xmlns/t2nrq/t2frrmsrequest/1-0-0"' + ' ' + #13#10 +
          '   ' + 'xmlns:xml="http://www.w3.org/XML/1998/namespace"'                        + ' ' + #13#10 +
          '   ' + 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                   + ' ' + #13#10 +
          '   ' + 'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t2nrq/t2frrmsrequest/1-0-0 t2frrmsrequest.xsd ">');

      BN                  := FetchElm(RetNo,'T1135',8) + 'RC' + FetchElm(RetNo,'T1135',30);
      WACnum              := GetWacNumber(RetNo);
      AgreementInd        := '0'; //FetchElm(RetNo,'T1135',) //????

      add('  ' + '<t2nrq:BusinessNumber>'+BN+'</t2nrq:BusinessNumber>');
      add('  ' + '<t2nrq:WACNumber>'+WACnum+'</t2nrq:WACNumber>');
      add('  ' + '<t2nrq:AgreementIndicator>'+AgreementInd+'</t2nrq:AgreementIndicator>');
      add('  ' + '<t2nrq:TaxYear>'+LeftStr(GetTaxationYearEnd(RetNo),4)+'</t2nrq:TaxYear>');
      add('  ' + '<t2nrq:SoftwareID>'+SoftwareId+'</t2nrq:SoftwareID>');
      add('  ' + '<t2nrq:TaxForm>');

  end;



  //----------------------------------------------------------------------------

  //from CHAPTER 6 T1135 XML SPECIFICATIONS, Ch6-T1135


  //add(i0 +'<?xml version="1.0" encoding="UTF-8"?>');
  {
  add(i0 +'<t1135:ForeignIncomeVerificationStatement'                              + ' ' + #13#10 +
      i0 +'xmlns:ccms="http://www.cra-arc.gc.ca/xmlns/ccms/1-1-0"'                 + ' ' + #13#10 +
      i0 +'xmlns:sdt="http://www.cra-arc.gc.ca/xmlns/sdt/2-2-0"'                   + ' ' + #13#10 +
      i0 +'xmlns:t1135="http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0"'          + ' ' + #13#10 +
      i0 +'xmlns:xml="http://www.w3.org/XML/2001/namespace"'                       + ' ' + #13#10 +
      i0 +'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                  + ' ' + #13#10 +
      i0 +'xsi:schemaLocation="http://www.cra-arc.gc.ca/xmlns/t1135/2021/1-0-0 ForeignIncomeVerificationStatement.xsd ">');
  }

  add(i0 +'<t1135:ForeignIncomeVerificationStatement>');

  //2021 jz SoftwareID and SoftwareRevisionDate omitted in the T2
  //add(i1_ + '<t1135:SoftwareID>'+RsiApprovalCode+'</t1135:SoftwareID>');
  //add('<t1135:SoftwareRevisionDate>'+SoftwareRevisionDate+'</t1135:SoftwareRevisionDate>');

  //jz 20240711 - not manditory but CRA wants for certification after addition of 'JPY'
  s:= FetchElmFNo(RetNo,t1135FNo,21);
  If (s>'') and (AnsiUpperCase(s) <> 'CAD') then //jz 20240723 CAD is not a valid entry
    add(i1_ + '<t1135:FunctionalCurrencyCode>'+s+'</t1135:FunctionalCurrencyCode>');

  cd:='0';
  If FetchElm(RetNo,'T1135',22)>'' then CD:='1';
  add(i1_ + '<t1135:AmendedReturnIndicator>'+Cd+'</t1135:AmendedReturnIndicator>');  //20150414

  add(i1_ + '<t1135:TaxpayerIdentification>');
  add(i2__ + '<t1135:CorporationTaxpayer>');
  add(i3___ + '<t1135:CorporationName>'+ReplaceXmlChars(GetCorpName(RetNo))+'</t1135:CorporationName>');
  add(i3___ + '<t1135:BusinessNumber>'+GetCorpBusNo(RetNo)+'</t1135:BusinessNumber>');
  add(i2__ + '</t1135:CorporationTaxpayer>');
  add(i1_ + '</t1135:TaxpayerIdentification>');


  add(i1_ + '<t1135:TaxpayerAddress>');

  s:=FetchElmFNo(RetNo,t1135FNo,15);  //jz 20240624 remove FetchElmFNo(RetNo,t1135FNo,34)+' '+  //20150207
  If s>'' then Add(i2__ +'<t1135:AddressStreetText>'+s+'</t1135:AddressStreetText>');
  s:=FetchElmFNo(RetNo,t1135FNo,17);If s>'' then Add(i2__ + '<t1135:AddressMunicipalityName>'+s+'</t1135:AddressMunicipalityName>');
  s:=FetchElmFNo(RetNo,t1135FNo,63);If s>'' then Add(i2__ + '<t1135:GlobalProvinceTerritoryStateCode>'+s+'</t1135:GlobalProvinceTerritoryStateCode>');
  s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,16),' ');If s>'' then Add(i2__ + '<t1135:GlobalPostalZipCode>'+s+'</t1135:GlobalPostalZipCode>');
  s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,28),' ');If s>'' then Add(i2__ + '<t1135:CountryCode>'+s+'</t1135:CountryCode>'); //20150127
  add(i1_ + '</t1135:TaxpayerAddress>');

  //20160617
  add(i1_ + '<t1135:TaxationYearData>'); //20150127
  s:=FetchElmFNo(RetNo,t1135FNo,19);
  Add(i2__ + '<t1135:TaxationYearStartDate>'+ReplaceChar(s,'/','-')+'</t1135:TaxationYearStartDate>');
  s:=FetchElmFNo(RetNo,t1135FNo,20);
  Add(i2__ + '<t1135:TaxationYearEndDate>'+ReplaceChar(s,'/','-')+'</t1135:TaxationYearEndDate>');
  add(i1_ + '</t1135:TaxationYearData>');

//------------------------------------------------------------------------------

   add(i1_ + '<t1135:ForeignPropertyIdentification>');

   if (FetchElmFNo(RetNo,t1135FNo,36)>'') and (FetchElmFNo(RetNo,t1135FNo,86)='')  then  //is category 1
   begin
     add(i2__ + '<t1135:ForeignPropertyCostCategoryOne>');
     add(i3___ + '<t1135:ForeignPropertySimplifiedData>');
     add(i4____ + '<t1135:ForeignPropertyIndicator>');
     add(i5_____ + '<t1135:ForeignFundsIndicator>'                + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,46)) +'</t1135:ForeignFundsIndicator>');
     add(i5_____ + '<t1135:NonResidentCorporationShareIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,47)) +'</t1135:NonResidentCorporationShareIndicator>');
     add(i5_____ + '<t1135:NonResidentIndebtednessIndicator>'     + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,48)) +'</t1135:NonResidentIndebtednessIndicator>');
     add(i5_____ + '<t1135:NonResidentTrustInterestIndicator>'    + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,49)) +'</t1135:NonResidentTrustInterestIndicator>');
     add(i5_____ + '<t1135:ForeignRealPropertyIndicator>'         + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,50)) +'</t1135:ForeignRealPropertyIndicator>');
     add(i5_____ + '<t1135:OtherForeignPropertyIndicator>'        + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,53)) +'</t1135:OtherForeignPropertyIndicator>');
     add(i5_____ + '<t1135:CanadianHeldForeignPropertyIndicator>' + ConvertCheckBoxto1(FetchElmFNo(RetNo,t1135FNo,55)) +'</t1135:CanadianHeldForeignPropertyIndicator>'); //wrong 555 //20160124
     add(i4____ + '</t1135:ForeignPropertyIndicator>');

     add(i4____ + '<t1135:ForeignPropertyCountryCodes>');
     If FetchElmFNo(RetNo,t1135FNo,57)>'' then add(i5_____ + '<t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,57) +'</t1135:MaximumCostForeignCountryCode>');
     If FetchElmFNo(RetNo,t1135FNo,58)>'' then add(i5_____ + '<t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,58) +'</t1135:MaximumCostForeignCountryCode>');
     If FetchElmFNo(RetNo,t1135FNo,59)>'' then add(i5_____ + '<t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,59) +'</t1135:MaximumCostForeignCountryCode>');
     //add('        <t1135:MaximumCostForeignCountryCode>'        + FetchElmFNo(RetNo,t1135FNo,59) +'</t1135:MaximumCostForeignCountryCode>'); //wrong
     add(i4____ + '</t1135:ForeignPropertyCountryCodes>');
     add(i4____ + '<t1135:AllForeignPropertyIncomeAmount>'         + RemoveChar(FetchElmFNo(RetNo,t1135FNo,60),',') + '</t1135:AllForeignPropertyIncomeAmount>');    //20160125
     add(i4____ + '<t1135:AllForeignPropertyDispositionGainLossAmount>'+ RemoveChar(FetchElmFNo(RetNo,t1135FNo,64),',') +'</t1135:AllForeignPropertyDispositionGainLossAmount>'); //20160125
     add(i3___ + '</t1135:ForeignPropertySimplifiedData>');
     add(i2__ + '</t1135:ForeignPropertyCostCategoryOne>');
   end

   else
   begin
    add(i2__ + '<t1135:ForeignPropertyCostCategoryTwo>');
    add(i3___ + '<t1135:ForeignPropertyDetailedData>');

  //ForeignFunds
  If FetchElmFNo(RetNo,t1135FNo,10001)>'' then
  Begin
   add(i4____ + '<t1135:ForeignFunds>');
   ArrayNo:=1; BoxesPerRow:=5;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
      s:=FetchElmFNo(RetNo,t1135FNo,Elm);
      If S>'' then
      begin
       add(i5_____ + '<t1135:ForeignFundsRecord>');
       s:=FetchElmFNo(RetNo,t1135FNo,Elm);
       Add(i6______ + '<t1135:ForeignFundsBankEntityName>'+ReplaceXmlChars(s)+'</t1135:ForeignFundsBankEntityName>'); //20161213
       s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add(i6______ + '<t1135:ForeignFundsCountryCode>'+s+'</t1135:ForeignFundsCountryCode>');
       s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add(i6______ + '<t1135:ForeignFundsMaximumYearlyHeldAmount>'+s+'</t1135:ForeignFundsMaximumYearlyHeldAmount>');
       s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add(i6______ + '<t1135:ForeignFundsHeldYearEndAmount>'+s+'</t1135:ForeignFundsHeldYearEndAmount>');
       s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add(i6______ + '<t1135:ForeignFundsIncomeAmount>'+s+'</t1135:ForeignFundsIncomeAmount>'); //new 2016, removed 'loss'
       Add(i5_____ + '</t1135:ForeignFundsRecord>');
      end;
      Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,18))));Add(i5_____ + '<t1135:ForeignFundsTotalHeldYearEndAmount>'+s+'</t1135:ForeignFundsTotalHeldYearEndAmount>');  //totl line
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,31))));Add(i5_____ + '<t1135:ForeignFundsTotalIncomeAmount>'+s+'</t1135:ForeignFundsTotalIncomeAmount>');  //new 2016, removed 'loss'
   add(i4____ + '</t1135:ForeignFunds>');
  end;

  // NonResidentCorporationShare
  If FetchElmFNo(RetNo,t1135FNo,20001)>'' then
  Begin
   add(i5_____ + '<t1135:NonResidentCorporationShare>');
   ArrayNo:=2; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     add(i6______ + '<t1135:NonResidentCorporationShareRecord>');
     s:=ReplaceXMLChars(FetchElmFNo(RetNo,t1135FNo,Elm));Add(i7_______ + '<t1135:NonResidentCorporationName>'+s+'</t1135:NonResidentCorporationName>');//20161219
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);Add(i7_______ + '<t1135:NonResidentCorporationCountryCode>'+s+'</t1135:NonResidentCorporationCountryCode>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add(i7_______ +'<t1135:NonResidentCorporationShareMaximumYearlyCostAmount>'+s+'</t1135:NonResidentCorporationShareMaximumYearlyCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add(i7_______ +'<t1135:NonResidentCorporationShareYearEndCostAmount>'+s+'</t1135:NonResidentCorporationShareYearEndCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add(i7_______ +'<t1135:NonResidentCorporationShareIncomeAmount>'+s+'</t1135:NonResidentCorporationShareIncomeAmount>'); //new 2016, removed loss
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add(i7_______ +'<t1135:NonResidentCorporationShareDispositionGainLossAmount>'+s+'</t1135:NonResidentCorporationShareDispositionGainLossAmount>');
     add(i6______ + '</t1135:NonResidentCorporationShareRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
    //Totals
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,32))));Add(i6______ + '<t1135:NonResidentCorporationShareTotalYearEndCostAmount>'+s+'</t1135:NonResidentCorporationShareTotalYearEndCostAmount>');

    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,33))));Add(i6______ + '<t1135:NonResidentCorporationShareTotalIncomeAmount>'+s+'</t1135:NonResidentCorporationShareTotalIncomeAmount>'); //new 2016, removed 'loss'

    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,43))));Add(i6______ + '<t1135:NonResidentCorporationShareTotalDispositionGainLossAmount>'+s+'</t1135:NonResidentCorporationShareTotalDispositionGainLossAmount>');
    add(i5_____ + '</t1135:NonResidentCorporationShare>');
  End;

  // NonResidentIndebtedness  ----------
  If FetchElmFNo(RetNo,t1135FNo,30001)>'' then
  Begin
   add(i5_____ + '<t1135:NonResidentIndebtedness>');
   ArrayNo:=3; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
      add(i6______ + '<t1135:NonResidentIndebtednessRecord>');
      s:=ReplaceXmlChars(FetchElmFNo(RetNo,t1135FNo,Elm));Add(i7_______ + '<t1135:NonResidentIndebtednessDescription>'+s+'</t1135:NonResidentIndebtednessDescription>'); //20161219
      s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);               Add(i7_______ + '<t1135:NonResidentIndebtednessCountryCode>'+s+'</t1135:NonResidentIndebtednessCountryCode>');
      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add(i7_______ + '<t1135:NonResidentIndebtednessMaximumYearlyCostAmount>'+s+'</t1135:NonResidentIndebtednessMaximumYearlyCostAmount>');
      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add(i7_______ + '<t1135:NonResidentIndebtednessYearEndCostAmount>'+s+'</t1135:NonResidentIndebtednessYearEndCostAmount>');
      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add(i7_______ + '<t1135:NonResidentIndebtednessIncomeAmount>'+s+'</t1135:NonResidentIndebtednessIncomeAmount>'); //new 2016, removed loss
      s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add(i7_______ + '<t1135:NonResidentIndebtednessDispositionGainLossAmount>'+s+'</t1135:NonResidentIndebtednessDispositionGainLossAmount>');
      add(i6______ + '</t1135:NonResidentIndebtednessRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,40))));Add(i6______ + '<t1135:NonResidentIndebtednessTotalYearEndCostAmount>'+s+'</t1135:NonResidentIndebtednessTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,41))));Add(i6______ + '<t1135:NonResidentIndebtednessTotalIncomeAmount>'+s+'</t1135:NonResidentIndebtednessTotalIncomeAmount>'); //new 2016, removed loss
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,45))));Add(i6______ + '<t1135:NonResidentIndebtednessTotalDispositionGainLossAmount>'+s+'</t1135:NonResidentIndebtednessTotalDispositionGainLossAmount>');
   add(i5_____ + '</t1135:NonResidentIndebtedness>');
  end;

  // NonResidenttrust       ----------------------------------------
  If FetchElmFNo(RetNo,t1135FNo,40001)>'' then   //20150221
  Begin
  add(i5_____ + '<t1135:NonResidentTrustInterest>'); //20150127
   ArrayNo:=4; BoxesPerRow:=7;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
    add(i6______ + '<t1135:NonResidentTrustInterestRecord>');
    s:=ReplaceXmlChars(FetchElmFNo(RetNo,t1135FNo,Elm));                 Add(i7_______ + '<t1135:NonResidentTrustInterestName>'+s+'</t1135:NonResidentTrustInterestName>'); //20161219
    s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);                                Add(i7_______ + '<t1135:NonResidentTrustInterestCountryCode>'+s+'</t1135:NonResidentTrustInterestCountryCode>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add(i7_______ + '<t1135:NonResidentTrustInterestMaximumYearlyCostAmount>'+s+'</t1135:NonResidentTrustInterestMaximumYearlyCostAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add(i7_______ + '<t1135:NonResidentTrustInterestYearEndCostAmount>'+s+'</t1135:NonResidentTrustInterestYearEndCostAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add(i7_______ + '<t1135:NonResidentTrustInterestIncomeReceivedAmount>'+s+'</t1135:NonResidentTrustInterestIncomeReceivedAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add(i7_______ + '<t1135:NonResidentTrustInterestCapitalReceivedAmount>'+s+'</t1135:NonResidentTrustInterestCapitalReceivedAmount>');
    s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+6))));Add(i7_______ + '<t1135:NonResidentTrustInterestDispositionGainLossAmount>'+s+'</t1135:NonResidentTrustInterestDispositionGainLossAmount>');
    add(i6______ + '</t1135:NonResidentTrustInterestRecord>');
   end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,51))));Add(i6______ + '<t1135:NonResidentTrustInterestTotalYearEndCostAmount>'+s+'</t1135:NonResidentTrustInterestTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,52))));Add(i6______ + '<t1135:NonResidentTrustInterestTotalIncomeReceivedAmount>'+s+'</t1135:NonResidentTrustInterestTotalIncomeReceivedAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,54))));Add(i6______ + '<t1135:NonResidentTrustInterestTotalCapitalReceivedAmount>'+s+'</t1135:NonResidentTrustInterestTotalCapitalReceivedAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,56))));Add(i6______ + '<t1135:NonResidentTrustInterestTotalDispositionGainLossAmount>'+s+'</t1135:NonResidentTrustInterestTotalDispositionGainLossAmount>');
   add(i5_____ + '</t1135:NonResidentTrustInterest>');
  end;

  // ForeignRealProperty    -----------------------------------
  If FetchElmFNo(RetNo,t1135FNo,50001)>'' then
  Begin
   add(i5_____ + '<t1135:ForeignRealProperty>');
   ArrayNo:=5; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     add(i6______ + '<t1135:ForeignRealPropertyRecord>');
     s:=ReplaceXmlChars(FetchElmFNo(RetNo,t1135FNo,Elm));                 Add(i7_______ + '<t1135:ForeignRealPropertyDescription>'+s+'</t1135:ForeignRealPropertyDescription>');  //20161219
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);                                Add(i7_______ + '<t1135:ForeignRealPropertyCountryCode>'+s+'</t1135:ForeignRealPropertyCountryCode>'); //new 2016, 'oth' code no longer valid
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add(i7_______ + '<t1135:ForeignRealPropertyMaximumYearlyCostAmount>'+s+'</t1135:ForeignRealPropertyMaximumYearlyCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add(i7_______ + '<t1135:ForeignRealPropertyYearEndCostAmount>'+s+'</t1135:ForeignRealPropertyYearEndCostAmount>'); //new 2016, removed 'loss' wrong in the guide, ok in the examples
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add(i7_______ + '<t1135:ForeignRealPropertyIncomeAmount>'+s+'</t1135:ForeignRealPropertyIncomeAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add(i7_______ + '<t1135:ForeignRealPropertyDispositionGainLossAmount>'+s+'</t1135:ForeignRealPropertyDispositionGainLossAmount>');
     add(i6______ + '</t1135:ForeignRealPropertyRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,61))));Add(i6______ + '<t1135:ForeignRealPropertyTotalYearEndCostAmount>'+s+'</t1135:ForeignRealPropertyTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,62))));Add(i6______ + '<t1135:ForeignRealPropertyTotalIncomeAmount>'+s+'</t1135:ForeignRealPropertyTotalIncomeAmount>'); //new 2016, removed 'loss'
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,68))));Add(i6______ + '<t1135:ForeignRealPropertyTotalDispositionGainLossAmount>'+s+'</t1135:ForeignRealPropertyTotalDispositionGainLossAmount>');
   add(i5_____ + '</t1135:ForeignRealProperty>');
  end;

  //OtherForeignProperty  -------------------------------------
  If FetchElmFNo(RetNo,t1135FNo,60001)>'' then
  Begin
   add(i5_____ + '<t1135:OtherForeignProperty>');
   ArrayNo:=6; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     Add(i6______ + '<t1135:OtherForeignPropertyRecord>');
     s:=ReplaceXmlChars(FetchElmFNo(RetNo,t1135FNo,Elm));                 Add(i7_______ + '<t1135:OtherForeignPropertyDescription>'+s+'</t1135:OtherForeignPropertyDescription>'); //20161219
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);                                Add(i7_______ + '<t1135:OtherForeignPropertyCountryCode>'+s+'</t1135:OtherForeignPropertyCountryCode>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));Add(i7_______ + '<t1135:OtherForeignPropertyMaximumYearlyCostAmount>'+s+'</t1135:OtherForeignPropertyMaximumYearlyCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));Add(i7_______ + '<t1135:OtherForeignPropertyYearEndCostAmount>'+s+'</t1135:OtherForeignPropertyYearEndCostAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add(i7_______ + '<t1135:OtherForeignPropertyIncomeAmount>'+s+'</t1135:OtherForeignPropertyIncomeAmount>'); //new 2016, removed 'loss'
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add(i7_______ + '<t1135:OtherForeignPropertyDispositionGainLossAmount>'+s+'</t1135:OtherForeignPropertyDispositionGainLossAmount>');
     add(i6______ + '</t1135:OtherForeignPropertyRecord>');
   end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,81))));Add(i6______ + '<t1135:OtherForeignPropertyTotalYearEndCostAmount>'+s+'</t1135:OtherForeignPropertyTotalYearEndCostAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,82))));Add(i6______ + '<t1135:OtherForeignPropertyTotalIncomeAmount>'+s+'</t1135:OtherForeignPropertyTotalIncomeAmount>'); //new 2016, removed 'loss'
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,85))));Add(i6______ + '<t1135:OtherForeignPropertyTotalDispositionGainLossAmount>'+s+'</t1135:OtherForeignPropertyTotalDispositionGainLossAmount>');
   add(i5_____ + '</t1135:OtherForeignProperty>');
  end;

  // CanadianHeldForeignProperty  -------- -------------------------------
  If FetchElmFNo(RetNo,t1135FNo,70001)>'' then
  Begin
   add(i5_____ + '<t1135:CanadianHeldForeignProperty>');
   ArrayNo:=7; BoxesPerRow:=6;
   Elm:=ArrayNo*10000+StrToInt('1');
   For i:=0 to MaxRowsPerArray do
   begin
    s:=FetchElmFNo(RetNo,t1135FNo,Elm);
    If S>'' then
    begin
     Add(i6______ + '<t1135:CanadianHeldForeignPropertyRecord>');
     s:=ReplaceXmlChars(FetchElmFNo(RetNo,t1135FNo,Elm));Add(i7_______ + '<t1135:CanadianHeldForeignPropertySecurityDealerTrustCompanyName>'+s+'</t1135:CanadianHeldForeignPropertySecurityDealerTrustCompanyName>'); //20161219
     s:=FetchElmFNo(RetNo,t1135FNo,Elm+1);               Add(i7_______ + '<t1135:CanadianHeldForeignPropertyCountryCode>'+s+'</t1135:CanadianHeldForeignPropertyCountryCode>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+2))));
       If s>'' then                                      Add(i7_______ + '<t1135:CanadianHeldForeignPropertyMaximumYearlyFairMarketValueAmount>'+s+'</t1135:CanadianHeldForeignPropertyMaximumYearlyFairMarketValueAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+3))));
       If S>'' then                                      Add(i7_______ + '<t1135:CanadianHeldForeignPropertyYearEndFairMarketValueAmount>'+s+'</t1135:CanadianHeldForeignPropertyYearEndFairMarketValueAmount>');
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+4))));Add(i7_______ + '<t1135:CanadianHeldForeignPropertyIncomeAmount>'+s+'</t1135:CanadianHeldForeignPropertyIncomeAmount>'); //new 2016, removed 'loss'
     s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,Elm+5))));Add(i7_______ + '<t1135:CanadianHeldForeignPropertyDispositionGainLossAmount>'+s+'</t1135:CanadianHeldForeignPropertyDispositionGainLossAmount>');
     add(i6______ + '</t1135:CanadianHeldForeignPropertyRecord>');
    end;
     Elm:=Elm+BoxesPerRow;
   end;
   //totals
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,37))));Add(i6______ + '<t1135:CanadianHeldForeignPropertyTotalYearEndFairMarketValueAmount>'+s+'</t1135:CanadianHeldForeignPropertyTotalYearEndFairMarketValueAmount>');
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,38))));Add(i6______ + '<t1135:CanadianHeldForeignPropertyTotalIncomeAmount>'+s+'</t1135:CanadianHeldForeignPropertyTotalIncomeAmount>'); //new 2016, removed 'loss'
   s:=FormatFloat(Format1,Round(Vl(FetchElmFNo(RetNo,t1135FNo,44))));Add(i6______ + '<t1135:CanadianHeldForeignPropertyTotalDispositionGainLossAmount>'+s+'</t1135:CanadianHeldForeignPropertyTotalDispositionGainLossAmount>');
   add(i5_____ + '</t1135:CanadianHeldForeignProperty>');
  end;

    add(i3___ + '</t1135:ForeignPropertyDetailedData>');
    add(i2__ + '</t1135:ForeignPropertyCostCategoryTwo>');
  end;

  add(i1_ + '</t1135:ForeignPropertyIdentification>');

  // ---------------------------------------------------------------------------

  Add(i1_ + '<t1135:CertificationDetail>');
  Add(i2__ + '<t1135:CertifierName>');
  Add(i3___ + '<t1135:TaxpayerName>');

  //jz 20240711 get from t1135 not T2
  s:=FetchElm(RetNo,t1135FNo,70); Add(i4____ + '<t1135:GivenName>'+s+'</t1135:GivenName>');   //s:=FetchElm(RetNo,'T2',743); Add(i4____ + '<t1135:GivenName>'+s+'</t1135:GivenName>');
  s:=FetchElm(RetNo,t1135FNo,69); Add(i4____ + '<t1135:FamilyName>'+s+'</t1135:FamilyName>');   //s:=FetchElm(RetNo,'T2',742); Add(i4____ + '<t1135:FamilyName>'+s+'</t1135:FamilyName>');

  add(i3___ + '</t1135:TaxpayerName>');
  add(i2__ + '</t1135:CertifierName>');
  s:=FetchElmFNo(RetNo,t1135FNo,71);If s>'' then Add(i2__ + '<t1135:CertifierPositionTitle>'+s+'</t1135:CertifierPositionTitle>');
  s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,72),' ');
 // s:=RemoveChar(S,'(');s:=RemoveChar(s,'(');
 // s:=Char(s,'-');
 // s:=Char(s,'/');

  Add(i2__ + '<t1135:CertifierPhoneNumber>'+s+'</t1135:CertifierPhoneNumber>'); //20150127
  s:=ReplaceChar(FetchElmFNo(RetNo,t1135FNo,73),'/','-');Add(i2__ + '<t1135:CertificationDate>'+s+'</t1135:CertificationDate>');

 If UpperCase(FetchElmFNo(RetNo,T1135FNo,29)) = 'Y' then
 Begin
  s:=ReplaceReservedXMLCharacters(FetchElmFNo(RetNo,t1135FNo,74));  //20150305
  Add(i2__ + '<t1135:PreparerName>'+s+'</t1135:PreparerName>');
  Add(i2__ + '<t1135:PreparerAddress>');
  s:=FetchElmFNo(RetNo,t1135FNo,75)+' '+FetchElmFNo(RetNo,t1135FNo,78)+' '+FetchElmFNo(RetNo,t1135FNo,79);
  Add(i3___ + '<t1135:GlobalAddress>'+s+'</t1135:GlobalAddress>');
  s:=RemoveChar(FetchElmFNo(RetNo,t1135FNo,76),' ');  //20150226
  add(i3___ + '<t1135:GlobalPostalZipCode>'+s+'</t1135:GlobalPostalZipCode>');
  add(i2__ + '</t1135:PreparerAddress>');
  s:=FetchElmFNo(RetNo,t1135FNo,77);
  add(i2__ + '<t1135:PreparerPhoneNumber>'+s+'</t1135:PreparerPhoneNumber>');
 end;

 add(i1_ + '</t1135:CertificationDetail>');

 add(i0 + '</t1135:ForeignIncomeVerificationStatement>');

 //jz 20240711
 if sendCredentials.ItemIndex = useEfilerNumber then
 begin
  add(' </t2rq:TaxForm>');
  add(' </t2rq:T2EfileReturnRequest>');
 end
 else if sendCredentials.ItemIndex = useWAC then
 begin
  add(' </t2nrq:TaxForm>');
  add(' </t2nrq:T2NetfileReturnRequest>');
 end;

 add('</soapenv:Body>');
 add('</soapenv:Envelope>');

 end; //with xmllist

 //when testing, load from file xmlList.Clear; xmllist.LoadFromFile('C:\Users\Costas\Documents\SCHEMA\schema\T2\examplT1135_ORIGINALtoCHANGE.xml');

 //save the list to a file
 SoapMsg:='';
 For I:=0 to XmlList.count-1 do
  SoapMsg:=SoapMsg+XmlList[i]; //+Chr(13);
 If FileExists(MkSubmittedFileName(RetNo)) then  DeleteFile(MkSubmittedFileName(RetNo));
 XmlList.SaveToFile(MkSubmittedFileName(RetNo));
 XmlList.Free;
end;

Function TT1135EfileT2_2027.CreateT1135EfileResponseHtm(RetNo: Integer; AckRec: T1135AckRec; HtmFile: String):String; //20160523 Igor
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
    if AckRec.T1135resultType = T1135accepted then
        replacementString := 'Accepted'
    else if  AckRec.T1135resultType = T1135webserviceError then
        replacementString := 'Rejected - Web Service Error'
    else
        replacementString := 'Rejected';
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!COLOR!';
    if AckRec.T1135resultType = T1135accepted then
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

  flName := NetFileDir+'\'+ GetLastName(RetNo)+' '+GetFirstName(RetNo) + '-EFileAck.htm';
  htmlSource.SaveToFile(flName);
  htmlSource.Free;

  result := flName;   //jz

end;

Function TT1135EfileT2_2027.ReplaceXMLChars(info: String): String;
Begin
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;');  //20160515 it is char(39)
  info := ReplaceChar(info, Chr(39), '&apos;');  //20161213
  info := ReplaceChar(info, '’', ''''); //20220616 Igor
  result := info;
End;

//20180423
procedure TT1135EfileT2_2027.setwebServiceUserNamePassword(var webServiceUserName: string; var webServicePassword: string);
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
