unit T3_2026Efile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs,
  ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin, {Isp3,}
  ActnList, ImgList, shdocvw, Printers, Db, DBTables, ActiveX,
  T3_2026Declare, T3_2026TrimStr, {UPopList,} T3_2026Common,
  T3_2026Common2, {TeeProcs, TeEngine, Chart,}// 20160119 Igor
  T3_2026Calc,
  {URTU,} ShellApi, T3_2026ChildWinNew, {UBuild813,} FileCtrl, T3_2026EolSetup,

  StrUtils,

  ComObj, MsXml2_TLB, vtShape, System.Actions
  // 20110129  NEEDED for connection and the response handler
    , uADCompClient, XSuperObject, Variants, // 20211129 Igor

    IOUtils,

    Data.DBXJSON, vtPanel

    ;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;



type
  TEfileT3_2026 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    ExitProgram: TMenuItem;
    Query1: TQuery;
    ProdOrTestBox: TRadioGroup;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    LabelEfileType: TLabel;
    TransmitBtn: TBitBtn;
    ExitBtn: TBitBtn;
    CreateFileHML: TBitBtn;
    WebServiceserrors1: TMenuItem;
    EfileErrorMessages1: TMenuItem;
    Panel1: TPanel;
    Label2: TLabel;
    Label9: TLabel;
    BitBtn5: TBitBtn;
    Label1: TLabel;
    WebBrowser1: TWebBrowser;
    Label4: TLabel;
    testingPanel: TvtPanel;
    Label3: TLabel;
    Label6: TLabel;
    FileNameBox: TEdit;
    ShowContentsBtn: TBitBtn;
    testResponse: TBitBtn;
    rgReturnType: TRadioGroup;
    BitBtn1: TBitBtn;
    transmitWithTestFileCHK: TCheckBox;
    BitBtn2: TBitBtn;
    removeRefundCodeCheckBox: TCheckBox;

    procedure FormCreate(Sender: TObject);
    Function MakeSelectedStr: String;
    // Function GetProductionOrTest:String;
    procedure TransmitBtnClick(Sender: TObject);
    // procedure DisplayFile1Click(Sender: TObject);
    // procedure BuildFile1Click(Sender: TObject);
    procedure SetUp1Click(Sender: TObject);
    procedure GetParms;
    procedure ExitBtnClick(Sender: TObject);
    procedure UpdateDataBase1Click(Sender: TObject);
    Function LoadReturn(RNo: Integer; DataDir: String; FlName: string): Boolean;
    Function UpdateAckStatus(SinNo, Status, AckRcvdBy, AckRcvdDT, AckRcvdTm,
      ConfirmationNo: String): Boolean;
    Function BackUpTaxFile(NetFileDir, FileName: String): Boolean;
    procedure ShowContentsBtnClick(Sender: TObject);
    procedure SaveDialog1Close(Sender: TObject);

    Procedure SubmitJsonMsg(RetNo: Integer; AJsonMsg: AnsiString; //20240129 Igor
      ProdOrTest: String; FlName: String; OnlineMethod: String);
    Procedure InitAckRec();
    procedure StartWebServiceTransmission(Sender: TObject);
    Procedure CreateJsonMessage(RetNo: Integer; ProdOrTest: String;
      OnlineMethod: String);
    Function MkSubmittedFileName(RetNo: Integer): String;
    Function MkResponseFileName(RetNo: Integer): String;
    Function MkJsonOnlyFileName(RetNo: Integer): String; //20240118 Igor
    Function parseJsonResponse(RetNo: Integer; rString: AnsiString): string; //20211130 Igor


    procedure storeConfirmationData(retNo:integer); //jz 20240405 add specialreturns efile button


    procedure CreateFileHMLClick(Sender: TObject);


    procedure manuallyFixBenoSubmissionBecauseCouldntDoItRight(var jList:Tstringlist);
    Procedure manuallyfixNoDecimalOnDollarCentsIssueBecauseCouldntDoItRight(var jList:Tstringlist);

    procedure ShowEfileJsonFile;
    procedure EfileErrorMessages1Click(Sender: TObject);
    procedure WebServiceserrors1Click(Sender: TObject);

    procedure UpdateTheDataBase;
    procedure BitBtn5Click(Sender: TObject);
    procedure testResponseClick(Sender: TObject);


    function chooseJSONFile():string;
    function populateJSONfromFile():ansistring;
    procedure CompareVTjsonValtoCerfTestFile();

    //function checkCRAKeyVal(CRADepth,CRAkey,CRAval:string):string;
    function checkCRAKeyValandAddTo(var VTJSONFileList:Tstringlist;CRADepth,CRAkey,CRAval:string):string;

    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);

  private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    FExit: boolean; //20180228 Igor
    JsonMsg: string;
    //20240129 Igor >>>
    CurrentTransmission: integer;
    CurrentUUID: string;
    AckResponseFlName: string;
    //20240129 Igor <<<


    FReturnType: string; //jz 20240405 add specialreturns efile button


    //20211130 Igor >>>
    function GetUrl: string;
    function GetPrefix: string;
    //20211130 Igor <<<
    function GetProdOrTest: string; //20211220 Igor
    function GetSelectedFormName: string; //20240118 Igor
    function GetCurrentTransmissionName: string; //20240129 Igor

  public
    { Public declarations }
    constructor Create(AOwner: TComponent;const fn: string); //jz 20240405 add specialreturns efile button


  end;

var
  Efile: TEfileT3_2026; // 20160119 Igor
  AckRec: TAckRec;
  TedFile: File of TAckRec;
  CurDispatch: IDispatch; { save the interface globally }
  RetNo: Integer;
  OnLineNo, PassWord, { EolFileName, } Url, Refund: String;
  DcnSeqNo: String;
  F1: TextFile;
  SfdNo: Integer;
  EFlines: TStringList;
  // ProdOrTest:String[1];   //global as of 20111204 in Udeclare
  CrLf: String;
  SegmentCnt: Integer;
  NetFileDir: String;
  IsBrowsePage: Boolean;

  CurrentRtn: String;

implementation

uses
  vtCommon, vtShowMessageHTML, T3_2026, T3_2026main, vtMulti, T3_2026dataGenJSON,
  vtTrimStr, vtShared, vtDataBase;

{$R *.DFM}



//jz 20240405 add specialreturns efile button
constructor TEfileT3_2026.Create(AOwner: TComponent; const fn: string);
begin
  inherited Create(AOwner);
  fReturnType := fn;

  LabelEfileType.caption := fReturnType + ' VisualTax Efile On-Line (EOL)'; //jz 20240405 add specialreturns efile button
end;


function TEfileT3_2026.GetCurrentTransmissionName: string; //20240129 Igor
begin
  Result := '';
  if CurrentTransmission > 0 then
    Result := '-' + AddLeadingZeros(CurrentTransmission.ToString, 3);
end;

procedure TEfileT3_2026.GetParms;
var s: String;
begin
  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir);
end;

function TEfileT3_2026.GetPrefix: string; //20211130 Igor //20240118 Igor
begin
  Result := GetSelectedFormName + '-'; 
end;

function TEfileT3_2026.GetProdOrTest: string; //20211220 Igor
begin
  if ProdOrTestBox.ItemIndex = 0 then
    Result:='P'
  else
    Result:='T';
end;

function TEfileT3_2026.GetSelectedFormName: string; //20240118 Igor
begin

  //jz 20240405 add specialreturns efile button
  if FReturnType > '' then
    Result := FReturnType
  else
    Result := 'T3';

  {
  Result := '';
  case rgReturnType.ItemIndex of
    0 : Result := 'T3';
    1 : Result := 'T3M';
    2 : Result := 'T3RCA';
    3 : Result := 'T3ATH';
    4 : Result := 'T3D';
    5 : Result := 'T3P';
    6 : Result := 'T3PRP';
    7 : Result := 'T3GR';
    8 : Result := 'T3RI';
    9 : Result := 'T3S';
    10: Result := 'T1061'; //jz 20240326
  end;
  }
end;

function TEfileT3_2026.GetUrl: string; //20211130 Igor //20240118 Igor
const //20251201 Igor
  cOperationURLYear = '2026'; //20251201 Igor
begin
  Result := '';
  //20240129 Igor >>>
  if CurrentTransmission > 0 then
  begin
    if (ProdOrTestBox.itemIndex = 0) then
      Result:= 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/beno/'+ CurrentUUID +'/additionalReportableEntities'
    else
      Result:= 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/beno/'+ CurrentUUID +'/additionalReportableEntities';
    Exit;
  end;
  //20240129 Igor <<<
  // production
  if (ProdOrTestBox.itemIndex = 0) then
  begin
    //20251201 Igor change from 2025 to ' + cOperationURLYear + ' in all URLs
    if      GetSelectedFormName = 'T3'     then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3'
    else if GetSelectedFormName = 'T3M'    then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3m'
    else if GetSelectedFormName = 'T3RCA'  then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3rca'
    else if GetSelectedFormName = 'T3ATH'  then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3athind'
    else if GetSelectedFormName = 'T3D'    then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3d'
    else if GetSelectedFormName = 'T3P'    then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3p'
    else if GetSelectedFormName = 'T3PRP'  then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3prp'
    else if GetSelectedFormName = 'T3GR'   then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3gr'
    else if GetSelectedFormName = 'T3RI'   then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3ri'
    else if GetSelectedFormName = 'T3S'    then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3s'
    else if GetSelectedFormName = 'T1061'  then Result := 'https://apps.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t1061';
  end else // testing
  begin
    //20251201 Igor change from 2025 to ' + cOperationURLYear + ' in all URLs
    if      GetSelectedFormName = 'T3'     then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3'
    else if GetSelectedFormName = 'T3M'    then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3m'
    else if GetSelectedFormName = 'T3RCA'  then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3rca'
    else if GetSelectedFormName = 'T3ATH'  then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3athind'
    else if GetSelectedFormName = 'T3D'    then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3d'
    else if GetSelectedFormName = 'T3P'    then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3p'
    else if GetSelectedFormName = 'T3PRP'  then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3prp'
    else if GetSelectedFormName = 'T3GR'   then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3gr'
    else if GetSelectedFormName = 'T3RI'   then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3ri'
    else if GetSelectedFormName = 'T3S'    then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t3s'
    else if GetSelectedFormName = 'T1061'  then Result := 'https://apps-ct.cra-arc.gc.ca/ebci/eftr/api/' + cOperationURLYear + '/efile/t1061';
  end;
end;

procedure TEfileT3_2026.FormCreate(Sender: TObject);
var
  Flags: OLEVariant;
  h: word;
  InitialDir: String;
begin
  if inJZtestmode then testingPanel.Visible := true else testingPanel.Visible := false;

  LabelEfileType.caption := 'VisualTax Efile On-Line (EOL)';
  RetNo := GetCurrentRetNo;
  OnlineMethod := 'EOL';
  GetParms;
  ForceDirectories(NetFileDir); //20220211 Igor

  FileNameBox.Text := MkJsonFileName(RetNo, NetFileDir);
  Screen.Cursor := CrDefault;
end;

Function TEfileT3_2026.MakeSelectedStr: String;
Const
  PartNameLen = 14;
Var
  S: string[80];
begin
end;

procedure TEfileT3_2026.TransmitBtnClick(Sender: TObject); //20211130 Igor
Var
  s: String; //20240129 Igor
  Flags: OLEVariant;
  h: THandle;
begin

 //20180308 protect developer password
  (*
  If ((UpperCase(OnLineNo)='B0864') Or (UpperCase(OnLineNo)='B0865')) then
  Begin
   s:=UpperCase(InputBox('Efiler number maybe invalid', 'PSW', ''));
   If (UpperCase(s)='IGOR') Or (UpperCase(s)='FRED')
   then
    ShowMessage('psw accepted')  //ok
   Else
    OnlineNo:=''
  end;
  *)


  {
  if RgReturnType.ItemIndex=0 then  //20240326 CZ
  Begin
   if FetchElm(RetNo,'T3',2)='' then
   begin
    showmessage('The T3 Return does not have account');
    Exit;
   end;
  End;

  if RgReturnType.ItemIndex>0 then   //20240324 jz/con
  Begin
    //showmessage(booltostr(Ret[RetNo].FrmHasData[GetFormNo(GetSelectedFormName)]));
    if not Ret[RetNo].FrmHasData[GetFormNo(GetSelectedFormName)] then
    begin
      showmessage(GetSelectedFormName + ' does not have data');
      exit;
    end;
  End;
  }

  //jz 20240405 add specialreturns efile button  <<<
  if GetSelectedFormName = 'T3' then
  Begin
   if FetchElm(RetNo,'T3',2)='' then
   begin
    showmessage('The T3 Return does not have account');
    Exit;
   end;
  End
  Else
  Begin
    //showmessage(booltostr(Ret[RetNo].FrmHasData[GetFormNo(GetSelectedFormName)]));
    if not Ret[RetNo].FrmHasData[GetFormNo(GetSelectedFormName)] then
    begin
      showmessage(GetSelectedFormName + ' does not have data');
      exit;
    end;
  End;
  //jz 20240405 add specialreturns efile button  >>>




  OnlineMethod := 'EOL';
  //EolpFileName := '';

  //20180228 Igor >>>
  FExit := false;
  StartWebServiceTransmission(sender);
  AddLogAppMon(amtOnEfile, RetNo); // 20180722 Igor //20220519 Igor
  if FExit then
  begin
    Close;
    Exit;
  end;
  //20180228 Igor <<<

  (* delete this //20240129 Igor
  // 20140124
  If (AckRec.EFresultType = EFaccepted) { AckRec.Accepted } then
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFAccepted.htm')
  Else If AckRec.EFresultType = EFwebServiceError then
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFWebServError.htm')
  Else
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFNotAccepted.htm');
  *)

  // above saves the created file in the eolfiles folder for future use?
  // second rround to resolve variables in the created client htm that come from dynamically loaded material after getting the source

  // filename assigned and returned from CreateEfileResponseHtm function //20170126
  // AckResponseFlName:=NetFileDir+'\'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo)+'-EfileAck','.')+'.htm'; //20140126

  If FileExists(AckResponseFlName) then
  begin
    if CheckIsCloud(true) or True then //20240118 Igor
     ShowMessageHTMLFromFile(AckResponseFlName)  //20200308 CON gives eror //20200914 Igor
    else
      ShellExecute(Self.Handle, nil, PChar('' + AckResponseFlName), nil, nil,
        SW_NORMAL);
  end;
  //20200306 Igor <<<
  //20200306 IGOR ShellExecute(Self.Handle, nil, PChar('' + AckResponseFlName), nil, nil,SW_NORMAL);
   Calc(RetNo, 'STATUS');
  // 20140127
  If not SaveReturn(RetNo, Ret[RetNo].SourceDataDir, Ret[RetNo].SourceFlName,
    True, False) = 0 then
    ShowMessage('Return cannot be saved');


  Screen.Cursor := crDefault; //jz 20240406 add specialreturns r1 - after adding open form to refresh cursor was stuck in hourglss
  //Close; // 20140126
end;

procedure TEfileT3_2026.StartWebServiceTransmission(Sender: TObject);
var
  i: Integer;
  ArrJsonMsg: TArray<string>; //20240129 Igor
Begin
  RetNo := GetCurrentRetNo;

  ProdOrTest := GetProdOrTest; //20211220 Igor

  if transmitWithTestFileCHK.Checked then
    JsonMsg := populateJSONfromFile
  else
    CreateJsonMessage(RetNo, ProdOrTest, OnlineMethod);

  If JsonMsg = '' then
  Begin
    ShowMessage('No data available for submission');
    Exit;
  end;

  //20240129 Igor >>>
  ArrJsonMsg := JsonMsg.Split([TRANSMISSIONS_DELIMITER], ExcludeEmpty);

  for I := 0 to Length(ArrJsonMsg) - 1 do
  begin
    CurrentTransmission := I;
    with TStringList.Create do
    try
      Text := ArrJsonMsg[I];
      SaveToFile(MkSubmittedFileName(RetNo));
    finally
      Free;
    end;
    SubmitJsonMsg(RetNo, ArrJsonMsg[I], ProdOrTest, MkSubmittedFileName(RetNo), OnlineMethod);

    if FileExists(MkSubmittedFileName(RetNo)) then DeleteFile(MkSubmittedFileName(RetNo)); //jz//20260311 - CRA probably want the files deleted

    if AckRec.EFresultType <> EFaccepted then
      break;


  end;
  //20240129 Igor <<<

end;


// Start of WebServices ---------------------------------------------------------------------------------------------------------------------------------------------------------------

procedure TEfileT3_2026.SubmitJsonMsg(RetNo: Integer; AJsonMsg: AnsiString; //20211130 Igor //20240129 Igor
  ProdOrTest: String; FlName: String; OnlineMethod: String);
Var
  i, j: Integer;
  WString: AnsiString; // wide string
  objHttp: ixmlHttpRequest;
  Status: String;
  T1013Msg: AnsiString;
  TempSoapList: TStringList;
  TempDataList: TStringList;
  h: THandle;
  S: String;
  AList: TStringList;
  DOMDocument: IXMLDOMDocument;
  TrackNodes: IXMLDOMNodeList; // 20110129
  ResponseJsonFile: String;
  ConfirmationNumber: String;

  parsedJsonResponseWString: string;
  batchResponseFile: TextFile;
  BatchresponseFlName: String;
Begin
  InitAckRec; //20181802
  GetParms; // 20140120
  // define
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  // open it
  //ShowMessage('Efile was stopped. N/A in this version of the program');  //20250121 //20260209 Igor
  ///EXIT; //20260209 Igor


  objHttp.open('POST', GetUrl, False, OnLineNo, PassWord);
  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?
  objHttp.setRequestHeader('Content-Type', 'application/json; charset=utf-8');  //jz 20220308 utf encoding added

  // transmit it now
  Screen.Cursor := crHourGlass;

  //20220120 Igor >>>
  // initialize the AckRec at transmission, finish it up upon receiving response
  With AckRec do
  Begin
    FamilyName := GetLastName(RetNo);
    GivenName := GetFirstName(RetNo);
    //TransmitBatchName := EolpFileName;
    DateTransmitted := FormatDateTime('yyyy-mm-dd', Date);
    TimeTransmitted := GetTimeToMilliSec(Date);
  end;
  //20220120 Igor <<<

  //20180228 Igor >>>
  try
    //objHttp.send(AnsiToUtf8(JsonMsg)); // SEND SOAP MESSAGE  //20220308 encode to UTF-8 done in header, not necessary here
    objHttp.send(AJsonMsg); // SEND SOAP MESSAGE //20240129 Igor
  except on E: Exception do
    begin
      Screen.Cursor := crDefault;
      objHttp := Nil;
      FExit := true;
      Application.MessageBox(PChar('It seems that there is no internet connection to the web site' + #13#13 +
                                    E.Message), 'Error', MB_OK or MB_ICONERROR);
      Exit;
    end;
  end;
  //20180228 Igor <<<

  Screen.Cursor := CrDefault;
  WString := objHttp.ResponseText;

  parsedJsonResponseWString := parseJsonResponse(RetNo, WString);
  // 20140118
//  If OnlineMethod = 'EOLP' then
//  begin
//    If FileExists(EolpFileName) then
//      Write(TedFile, AckRec);
//    // add records to the ted batch file-list of records submitted/received
//  end;

  // Now save the WString
  ResponseJsonFile := MkResponseFileName(RetNo);
  AList := TStringList.Create;
  AList.Add(WString);
  AList.SaveToFile(ResponseJsonFile);
  AList.Free;

  //20240129 Igor >>>
  AckRec.TransmissionName := GetCurrentTransmissionName;
  If (AckRec.EFresultType = EFaccepted) { AckRec.Accepted } then
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFAccepted.htm')
  Else If AckRec.EFresultType = EFwebServiceError then
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFWebServError.htm')
  Else
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFNotAccepted.htm');
  //20240129 Igor <<<

  // succesful transmission
  S := MkSubmittedFileName(RetNo);

  objHttp := Nil; // 20110129  .Free It is not accepted
end;

Procedure TEfileT3_2026.InitAckRec();
var i,j:integer;
begin
  With AckRec do // initialize to blank
  Begin
    returnTypeName := '';
    FamilyName := '';
    GivenName := '';
    TransmitBatchName := '';
    ResultCode := '';
    DateTransmitted := '';
    TimeTransmitted := '';
    DateReceived := '';
    TimeReceived := '';
    EfilerNumber := '';
    DocumentNo := '';
    TransmissionNo := '';

    EFresultType := EFaccepted; // Accepted        :=False;

    For i := 1 to 6 do
    begin
      ErrorCode[i] := '';

      For j := 1 to 12 do
      begin
        ErrorDescription[i][j] := '';
      end;
    end;
  end;
end;

Procedure TEfileT3_2026.CreateJsonMessage(RetNo: Integer; ProdOrTest: String;
  OnlineMethod: String);
Var
  i, j: Integer;
  TempJsonList: TStringList;
  TempDataList: TStringList;
  FlName, FirstLast: String; //20240118 Igor
  S: String;
begin
  GetParms;
  TempJsonList := TStringList.Create;
  try
    if RetNo > 0 then
    begin
      //20211123 Igor >>>

      if GetSelectedFormName = 'T3' then  //jz 20240405 add specialreturns efile button  //if rgReturnType.ItemIndex = 0 then
      begin
        //20220120 Igor >>>
        if (1 = 0) and FileExists(MkSubmittedFileName(RetNo)) and
           (MessageDlg('Do you want to use existing request file?',
            mtInformation, [mbYes, mbNo], 0) = mrYes) then
          TempJsonList.LoadFromFile(MkSubmittedFileName(RetNo))
        else
          createEfileJson(RetNo, GetSelectedFormName, TempJsonList, ProdOrTest); //20211220 Igor //20240118 Igor
        //20220120 Igor <<<
      end
      //20240118 Igor >>>
      else //jz 20240405 add specialreturns efile button   //if rgReturnType.ItemIndex > 0 then //20231201 Igor
        createEfileJson(RetNo, GetSelectedFormName, TempJsonList, ProdOrTest);
      //20240118 Igor <<<
//20211123 Igor <<<
    end
    else
    Begin
      ShowMessage('The tax return must be opened first');
      Close;
      Exit;
    end;

    manuallyfixBenoSubmissionBecauseCouldntDoItRight(TempJsonList);
    manuallyfixNoDecimalOnDollarCentsIssueBecauseCouldntDoItRight(TempJsonList);

    //TempJsonList.SaveToFile(MkSubmittedFileName(RetNo)); //20240129 Igor
  finally
    JsonMsg := TempJsonList.Text;
    TempJsonList.Free;
  end;
End;

//jz//20260312
Procedure TEfileT3_2026.manuallyfixNoDecimalOnDollarCentsIssueBecauseCouldntDoItRight(var jList:Tstringlist);
var
  i,j,decimalPos:integer;
  s:string;
  eflines:Tstringlist;
  A: TArray<string>;
  Line, Value, FormName, FieldType: string;
begin
  eflines := TStringList.Create;
  eflines.LoadFromFile(AppDir+'\'+'EFLINE.D');

  for i := 0 to efLines.Count - 1 do
  begin
    A := Eflines.Strings[i].Split(['|']);
    if Length(A) < 5 then continue;
    //if not SameText(Trim(A[4]), Section) then continue;
    Line := Trim(A[0]);
    FieldType := Trim(A[1]);

    if SameText(FieldType, '$/c') then
    begin
      for j := 0 to jList.count -1 do
      begin
        if pos('"fieldCode":"'+Line+'"',jList[j]) > 0 then  //find
        begin
          decimalPos:=pos('.',jList[j+1]);
          if decimalPos = 0 then
          begin
            jList[j+1] := TrimRight(jList[j+1])+'.00';
            continue;
          end;
        end;
      end;
    end;
  end;

end;


Procedure TEfileT3_2026.manuallyfixBenoSubmissionBecauseCouldntDoItRight(var jList:Tstringlist);
var i:integer; s:string;
begin
  //Exit; //20240129 Igor the following code corrupts results

  for i := 0 to jList.count -1 do
  begin
  {
    if pos('"benoReportableEntities"',jList[i]) > 0 then
      jList[i]    := jList[i] + ' [';

    if pos('"entityAssociationEndAction"',jList[i]) > 0 then
      jList[i+1]  := jList[i+1] + ' ]';
  }
    if removeRefundCodeCheckBox.Checked then
    begin
      if pos('"refundCode"',jList[i]) > 0 then
      begin
        if (pos('],',jList[i-1])>0) and (pos('}',jList[i+1])>0) then
          jList[i-1]    := ']';
        jList[i]    := '';
      end;
    end;
  end;
end;


function TEfileT3_2026.MkJsonOnlyFileName(RetNo: Integer): String; //20240118 Igor
begin
  Result := NetFileDir + '\' + GetPrefix + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' {+ GetSinNo(RetNo) + '-'} + Ret[RetNo].Province +
    '-JSONONLY', '.') + '.json';
end;

Function TEfileT3_2026.MkResponseFileName(RetNo: Integer): String;
Var
  OnLineNo, PassWord, Url, NetFileDir: String;
begin
  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir);
  result := NetFileDir + '\' + GetPrefix + RemoveChar(GetLastName(RetNo) + ' ' + //20211130 Igor
    GetFirstName(RetNo) + {'-' + GetSinNo(RetNo) +} '-Received', '.') + GetCurrentTransmissionName + '.json'; //20240129 Igor
end;

Function TEfileT3_2026.MkSubmittedFileName(RetNo: Integer): String;
// embedded function
  Function GetMinutesAndSeconds: String; // function within function
  Var
    SHours, SMinutes, SSeconds: string[2];
    Hour, Min, Sec, Msec: word;
  begin
    DecodeTime(Now, Hour, Min, Sec, Msec);
    SMinutes := AllTrim(IntToStr(Min));
    SSeconds := AllTrim(IntToStr(Sec));
    If Length(SMinutes) = 1 then
      SMinutes := '0' + SMinutes;
    If Length(SSeconds) = 1 then
      SSeconds := '0' + SSeconds;
    result := SMinutes + SSeconds;
  end; // end of embedded function

Var
  S: String;
begin
  result := NetFileDir + '\' + GetPrefix + RemoveChar(GetLastName(RetNo) + ' ' + //20211130 Igor
    GetFirstName(RetNo) + {'-' + GetSinNo(RetNo) +} '-Submitted', '.') + GetCurrentTransmissionName + '.json'; //20240129 Igor
end;

Function TEfileT3_2026.parseJsonResponse(RetNo: Integer; //20211130 Igor
  rString: AnsiString): String;
var
  i, j, tPos, k, sPos, ePos, FNo: Integer;


  t, s, e, fCode, fString, messageString, idstring, TimeReceived, tempString: String;
  ReturnedTransmissionNumber, ReturnedEfilerNumber,ReturnedControlNumber: String;
  ReturnedHyperLinkLink, ReturnedHyperLinkText :string;
  errorClue: array [1 .. 16] of string;
  tempAnsiString : ansistring;


  JSON: ISuperObject;
  arrJSON, arrText: ISUperArray;
  cError, cMessage: string;
begin

  idstring := RemoveChar(GetLastName(RetNo) + ' ' + GetFirstName(RetNo), '.') +
    Chr(10) + Chr(13);

  AckRec.EFresultType := EFrejected;

  //20211220 Igor >>>
  try
    JSON := SO(rString);
  except on E: Exception do
    begin
      ShowMessageHTML(rString);
      FExit := true;
      Exit;
    end;
  end;
  //20211220 Igor <<<
  // error
  if SameText(JSON.S['status'], 'REJECTED') or SameText(JSON.S['status'], 'SYSTEM_ERROR') then
  begin
    if SameText(JSON.S['status'], 'REJECTED') then
      AckRec.EFresultType := EFrejected
    else
      AckRec.EFresultType := EFwebServiceError;
    fCode := TSuperObject(JSON.O['responseMessage']).S['code'];
    cError := '';
    arrText := TSuperArray(TSuperObject(TSuperObject(JSON.O['responseMessage']).O['englishMessage']).A['text']);
    for i := 0 to arrText.Length - 1 do
    begin
      if not cError.IsEmpty then
        cError := cError + '<br>';
      cError := cError + arrText.S[i];
    end;
    AckRecResultDescription := cError;
    cError := '';
    if JSON.GetType('errorCodeMessage') = varArray then
    begin
      arrJSON := JSON.A['errorCodeMessage'];
      for i := 0 to arrJSON.Length - 1 do
      begin
        arrText := TSuperArray(TSuperObject(TSuperObject(arrJSON.O[i]).O['englishMessage']).A['text']);
        for j := 0 to arrText.Length - 1 do
        begin
          if not cError.IsEmpty then
            cError := cError + '<br>';
          cError := cError + arrText.S[j];
        end;
        cError := TSuperObject(arrJSON.O[i]).S['code'] + ': ' + cError;
      end;
    end;
    ErrorDescription[1][1] := cError;
    ErrorDescription[1][2] := ('Please contact VisualTax');

    messageString := 'Submission Failed' + Chr(10) + Chr(13) + Chr(10) + Chr(13)
      + 'Error Code: ' + fCode + Chr(10) + Chr(13) + fString;
    // MessageDlg(messageString,mtError,[mbOK],0);
    result := idstring + messageString + Chr(10) + Chr(13);
  end
  //20211204 Igor >>>
  else if SameText(JSON.S['status'], 'ACCEPTED') or SameText(JSON.S['status'], 'ACCEPTED_IN_PROGRESS') then //20240129 Igor
  begin
    AckRec.EFresultType := EFaccepted;
    fCode := TSuperObject(JSON.O['responseMessage']).S['code'];
    ReturnedTransmissionNumber := JSON.S['confirmationNumber'];
    ReturnedEfilerNumber := JSON.S['taxPreparerEfilerNumber'];
    ReturnedControlNumber := JSON.S['taxPreparerReturnControlNumber'];
    CurrentUUID := JSON.S['uid']; //20240129 Igor

    arrText := TSuperArray(TSuperObject(TSuperObject(JSON.O['responseMessage']).O['englishMessage']).A['text']);
    cMessage := '';
    for i := 0 to arrText.Length - 1 do
    begin
      if not cMessage.IsEmpty then
        cMessage := cMessage + '<br>';
      cMessage := cMessage + arrText.S[i];
    end;
    AckRecResultDescription := cMessage;
    //20211204 Igor <<<
    (*
    // Get result code ------------------------------------------------------------------
    s := '<t1ersp:ResultCode>';
    e := '</t1ersp:ResultCode>';
    sPos := pos(S, rString);
    if sPos > 0 then
    begin
      sPos := pos(S, rString) + Length(S);
      ePos := pos(e, rString);
      fCode := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

      // Get Transmission Number (filename/confirmation number) if exists
      // ------------------------------------------------------------------
      S := '<t1ersp:TransmissionNumber>';
      // s := '<TransmissionNumber xsi:type="xsd:string">';
      sPos := pos(S, rString);
      if sPos > 0 then
      begin
        e := '</t1ersp:TransmissionNumber>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        ReturnedTransmissionNumber := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
      end;

      // Get Document Control Number (TaxPreparer Efiler Number and the TaxPreparer Return Control Number) if exists
      S := '<ef:TaxPreparerEfilerNumber>';
      sPos := pos(S, rString);
      if sPos > 0 then
      begin
        e := '</ef:TaxPreparerEfilerNumber>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        ReturnedEfilerNumber := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
      end;
      S := '<ef:TaxPreparerReturnControlNumber>';
      sPos := pos(S, rString);
      if sPos > 0 then
      begin
        e := '</ef:TaxPreparerReturnControlNumber>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        ReturnedControlNumber := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
      end;

      // get message //20150128
      tempString := '';
      AckRecResultDescription := '';
      S := '<t1rsp:MessageText xml:lang="en">';
      e := '</t1rsp:MessageText>';
      sPos := pos(S, rString) + Length(S);
      ePos := pos(e, rString);
      AckRecResultDescription := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
      // tempString := tempString + chr(13) + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
      // showmessage(tempString);

      // success ------------------------------------------------------------------
      if (fCode = '180') or (fCode = '182') or (fCode = '183')
      or (fCode = '580') or (fCode = '582') or (fCode = '583')  //20170324 //added 580 refile acceptance //20170420
      then
      begin
        messageString := 'Result Code: ' + fCode + Chr(10) + Chr(13) +
          'Efile Submitted Successfully';
        messageString := messageString + Chr(10) + Chr(13) +
          'Transmission Number: ' + ReturnedTransmissionNumber + Chr(10) +
          Chr(13) + 'Efiler Number: ' + ReturnedEfilerNumber + Chr(10) + Chr(13)
          + 'Control Number: ' + ReturnedControlNumber;
        // showmessage(messageString);
        result := idstring + Chr(10) + Chr(13) + messageString + Chr(10)
          + Chr(13);

        AckRec.EFresultType := EFaccepted; // 20140124           ???????

        // get CVIndicator  //20150127
        tempString := '';
        S := '<t1ersp:CvIndicator>';
        e := '</t1ersp:CvIndicator>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        tempString := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
        AckRec.CVIndicator := '';
        if tempString = '000002139' then
          AckRec.CVIndicator :=
            '(E) 2139 - The CRA is performing pre-assessment verification on this return. Supporting documentation may or may not be requested. Please do not submit any documentation unless you are asked to do so.';
        if tempString = '000000024' then
          AckRec.CVIndicator :=
            '(E) 24 - The CRA may perform a verification of this taxpayer''s return. If so, the processing may be delayed and supporting documentation may be requested. Please do not submit any documentation unless you are asked to do so.';

      end
      else // else error ------------------------------------------------------------------
      begin

        AckRec.EFresultType := EFrejected; // 20140124
        // find error clues if any
        fString := '';

        ReturnedHyperLinkText := '';
        // get hyperlink text and target
        s := '<t1rsp:HyperlinkText>';
        e := '</t1rsp:HyperlinkText>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        ReturnedHyperLinkText := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

        ReturnedHyperLinkLink := '';
        s := '<t1rsp:HyperlinkTarget>';
        e := '</t1rsp:HyperlinkTarget>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        ReturnedHyperLinkLink := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

        for i := 1 to 16 do
        begin
          // s     := '<errorClue'+inttostr(i)+' xsi:type="xsd:string">';
          S := '<t1rsp:ErrorCode>';
          sPos := pos(S, rString);
          if sPos > 0 then
          begin
            // get error code
            e := '</t1rsp:ErrorCode>';
            sPos := pos(S, rString) + Length(S);
            ePos := pos(e, rString);
            errorClue[i] := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

            // tempString := tempString + chr(13) + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

            rString := MidAnsiStr(rString, ePos + Length(e), Length(rString));




{            // get error message //20152801
            S := '<t1rsp:MessageText xml:lang="en">';
            e := '</t1rsp:MessageText>';
            sPos := pos(S, rString) + Length(S);
            ePos := pos(e, rString);
            ErrorDescription[i] := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
}


            //20181802
            for j := 1 to 12 do
            begin


              s := '<t1rsp:MessageText xml:lang="en">';
              e := '</t1rsp:MessageText>';
              t := '</t1rsp:ErrorCodeDescription>';

              tPos := pos(t, rString);
              sPos := pos(s, rString);
              ePos := pos(e, rString);

              //check for error close tag
              if (tPos < sPos) or (sPos = 0) then break;

              // else get/store error message
              sPos := sPos + Length(s);
              ErrorDescription[i][j] := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos)); //ErrorDescription[i] := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
              // tempString := tempString + chr(13) + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
              rString := MidAnsiStr(rString, ePos + Length(e), Length(rString));

            end;







          end;
          if errorClue[i] > '' then
            fString := fString + Chr(10) + Chr(13) + errorClue[i];
        end;
        messageString := 'Submission Failed' + Chr(10) + Chr(13) + Chr(10) +
          Chr(13) + 'Result Code: ' + fCode;

        if (ReturnedTransmissionNumber + ReturnedEfilerNumber + ReturnedControlNumber) > '' then
        begin
          messageString := messageString + Chr(10) + Chr(13) + Chr(10) + Chr(13)
            + 'Transmission Number: ' + ReturnedTransmissionNumber + Chr(10) +
            Chr(13) + 'Efiler Number: ' + ReturnedEfilerNumber + Chr(10) +
            Chr(13) + 'Control Number: ' + ReturnedControlNumber;
        end;

        if fString > '' then
        begin
          messageString := messageString + Chr(10) + Chr(13) + Chr(10) + Chr(13)
            + 'Error Clues: ' + fString;
        end;

        // MessageDlg(messageString,mtError,[mbOK],0);
        // MessageDlg(tempString,mtError,[mbOK],0);

        result := idstring + Chr(10) + Chr(13) + messageString + Chr(10)
          + Chr(13);
      end;
    end
    ELSE
    begin
      S := '<resultCode xsi:type="xsd:string">';
      sPos := pos(S, rString);
      if sPos > 0 then
      begin
        e := '</resultCode>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        fCode := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

        if (fCode = '180') or (fCode = '182') or (fCode = '183') or (fCode = '580')     //20170418 added 580
         // 20160307
        then
          AckRec.EFresultType := EFaccepted;

        if fCode = '132' then // 20150203
        begin
          AckRec.EFresultType := EFrejected;
          ErrorDescription[1][1] := 'The Efile service is not available';
        end;
      end;
    end
    *)

  end; // else not servererror

  // MessageDlg(tempString,mtError,[mbOK],0);    //20141211

  With AckRec do
  Begin
    DateReceived    := FormatDateTime('yyyy-mm-dd', Date);
    TimeReceived    := GetTimeToMilliSec(Now); //20220120 Igor
    DocumentNo      := ReturnedEfilerNumber + ReturnedControlNumber; // 20150128
    TransmissionNo  := ReturnedTransmissionNumber;
    EfilerNumber    := ReturnedEfilerNumber; // 20140130


    FamilyName      := GetLastName(RetNo);
    GivenName       := GetFirstName(RetNo);

    ResultCode      := fCode;
    Description     := AckRecResultDescription; // 20170130
    tempAckRecDescription := AckRecResultDescription;

    HyperLinkLink   := ReturnedHyperLinkLink;
    HyperLinkText   := ReturnedHyperLinkText;

{
    For i := 1 to 6 do
    Begin
      ErrorCode[i]            := RmvLeadingZeros(errorClue[i]);
      ErrorCodeMsg[i]       := ErrorDescription[i];
      tempAckRecErrorCodeMsg[i]  := ErrorDescription[i];
    end;
}
    //20181802
    For i := 1 to 6 do
    Begin
      ErrorCode[i]                := RmvLeadingZeros(errorClue[i]);

      for j := 1 to 12 do
      begin
        ErrorCodeMsg[i][j]            := ErrorDescription[i][j];
        tempAckRecErrorCodeMsg[i][j]  := ErrorDescription[i][j];
      end;

    end;

  end;

  TimeReceived := FormatDateTime('yyyy-mm-dd', Date) + '  ' +
    GetTimeToMilliSec(Date);

  //20220120 Igor >>>
  // store response to the form  //20140126
  FNo := GetFormNo('STATUS');
  If AckRec.EFresultType = EFaccepted then
  begin
    if GetSelectedFormName = 'T3' then     //jz 20240405 add specialreturns efile button
    begin
      Ret[RetNo].EfStatus := '02';
      StoreElm(RetNo, FNo, 22, '02'); // It goes automatically via calc Status
      //20171220  Change confirmatio  to [37] and leave the dcn as is
      //StoreElm(RetNo, FNo, 36, GetEfStatusDescr('02'));
      StoreElm(RetNo, GetFormNo('T183TRUST'), 36, FetchElm(RetNo,'T183TRUST',21)); //original dcn   //20171220
      StoreElm(RetNo, GetFormNo('T183TRUST'), 37, AckRec.TransmissionNo);  //save confirm num also in [37]  20170331
      StoreElm(RetNo, FNo, 31, FetchElm(RetNo, 'T183TRUST', 21));
    end
    else
    begin
          storeConfirmationData(retNo);
    end;
  end
  Else
  begin
    if GetSelectedFormName = 'T3' then     //jz 20240405 add specialreturns efile button
    begin
      Ret[RetNo].EfStatus := '03'; // 20140130
      StoreElm(RetNo, FNo, 22, '03'); // It goes automatically via calc Status
    end;
  end;

  //jz 20240405 add specialreturns efile button
  if GetSelectedFormName = 'T3' then  //if it is T3 (ie. not special) store regardless if accpeted or rejected
  begin
    StoreElm(RetNo, FNo, 37, AckRec.TransmissionNo); // 20140130
    StoreElm(RetNo, FNo, 31, AckRec.TransmitBatchName);
    StoreElm(RetNo, FNo, 38, AckRec.DateTransmitted);
    StoreElm(RetNo, FNo, 36, AckRec.TimeTransmitted);
    StoreElm(RetNo, FNo, 35, UserName);
    StoreElm(RetNo, FNo, 32, AckRec.DateReceived);
    StoreElm(RetNo, FNo, 33, AckRec.TimeTransmitted);
    StoreElm(RetNo, FNo, 34, UserName);
    k := 40;
    //20220120 Igor <<<
    For i := 1 to 6 do
    Begin
      StoreElm(RetNo, FNo, k, AckRec.ErrorCode[i]);
      inc(k);
    end;
  end;

end;


//jz 20240406 add specialreturns r1
procedure TEfileT3_2026.storeConfirmationData(retNo:integer);
var
  spElms:TSpecialEfileStatusElms;
begin

  spElms := getSpecialEfileStatusElms(RetNo,GetSelectedFormName);
  StoreElm(RetNo, GetFormNo(GetSelectedFormName), spElms.spConfirmationNumElm, AckRec.TransmissionNo);
  OpenForm(RetNo, GetSelectedFormName, 0); //makes so efile conf number is shown //Calc(RetNo, GetSelectedFormName);

end;


procedure TEfileT3_2026.SetUp1Click(Sender: TObject);
begin
  Application.CreateForm(TEolSetUpT3_2026, EolSetUp);
  EolSetUp.ShowModal;
  EolSetUp.Free;
  GetParms;
end;

procedure TEfileT3_2026.ExitBtnClick(Sender: TObject);
begin
  If FileExists(FileNameBox.Text) then
    SysUtils.DeleteFile(FileNameBox.Text);
  Close;
end;

procedure TEfileT3_2026.UpdateDataBase1Click(Sender: TObject);
begin
  UpdateTheDataBase;
end;

procedure TEfileT3_2026.UpdateTheDataBase;
Var
  RNo: Integer;
  SinNo, Status, ConfirmationNo, DataDir, FlName, AckRcvdBy, AckRcvdDT,
    AckRcvdTm: String;
begin
  // ???ConfirmationNo:=GetConfirmationNoFromHtml;
  If ConfirmationNo = '' then
  begin
    ShowMessage('Confirmation no cannot be retrieved' + Chr(13) +
      'Please mark it down and enter it on the T183 form');
  end;

  (*

  SinNo := LeftStr(ExtractFileName(FileName), 9);
  RNo := IsRetInMemory(SinNo); // 0=not found
  If RNo = 0 then // not in memory
  begin
    FlName := LeftStr(SinNo, 8) + '.' + RightStr(SinNo, 1);
    // CreatingNew := True;
    RetNo := CreateNewReturn;
    // InitNewReturn;  //starting from current return//20160119 Igor
    RNo := RetNo;
    If LoadReturn(RNo, DataDir, FlName) = False then // failed
    begin
      ShowMessage('Tax return ' + FlName +
        ' could not be found or cannot load from ' + DataDir);
      RetNo := RetNo - 1;
      Exit;
    end;
  end;

  *)

  Status := '02';
  DataDir := OptRec.Dir_Cur;
  FlName := LeftStr(SinNo, 8) + '.' + RightStr(SinNo, 1);
  AckRcvdBy := UserName;
  AckRcvdDT := FormatDateTime('yyyy-mm-dd', Now);
  AckRcvdTm := TimeToStr(Now);
  If UpdateAckStatus(SinNo, Status, AckRcvdBy, AckRcvdDT, AckRcvdTm,
    ConfirmationNo) then
  begin
    If SaveReturn(RNo, DataDir, FlName, True, True) < 0 then
      // override=true, no prompt
      ShowMessage('Return failed to save with acknowledgment data')
    else
    begin
      ShowMessage('Return updated with acknowledgment data');
      BackUpTaxFile(NetFileDir, FileName); // this is the tax file transmitted
      If FileExists(FileName) then
        DeleteFile(FileName); // 20130130
    end;
  end
  else // memory update failed
    ShowMessage('Return faild to save with acknowledgment data');
end;

Function TEfileT3_2026.UpdateAckStatus(SinNo, Status, AckRcvdBy, AckRcvdDT,
  AckRcvdTm, ConfirmationNo: String): Boolean;
Var
  RNo, FNo: Integer;
begin
  result := False;

  (*

  RNo := IsRetInMemory(SinNo); // 0=not found
  If RNo > 0 then
  begin
    FNo := GetFormNo('STATUS');
    If Ret[RNo].Frm[FNo].count = 0 then
      InitFormData(RNo, FNo);
    Ret[RNo].EfStatus := Status;
    StoreElm(RNo, FNo, 15, Status);
    StoreElm(RNo, FNo, 21, AckRcvdDT);
    StoreElm(RNo, FNo, 22, AckRcvdDT);
    StoreElm(RNo, FNo, 23, AckRcvdTm);
    StoreElm(RNo, FNo, 31, ConfirmationNo); // conf and DCN

    FNo := GetFormNo('T183');
    If Ret[RNo].Frm[FNo].count = 0 then
      InitFormData(RNo, FNo);
    if FNo > 0 then
      StoreElm(RNo, FNo, 21, ConfirmationNo)
    else
      ShowMessage('Form T183 not found. Confirmation no Not stored');
    Ret[RNo].Changed := True;
    result := True;
    Exit;
  end;

  *)
end;

Function TEfileT3_2026.LoadReturn(RNo: Integer; DataDir: String;
  FlName: string): Boolean;
var
  // 20160119 Igor
  FDConnection: TADConnection;
  Table: TADTable;
begin
  result := False;

  (*

  FDConnection := TADConnection.Create(nil);
  Table := TADTable.Create(nil);
  try
    // 20150925 igor
    if SetTableName(FDConnection, Table, DataDir + '\' + ClientsDBLite,
      ClientsTableLite, 'File_Name') then
      //20170223 Igor >>>
      //if Table.FindKey([FlName]) = True then
      if Table.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
      //20170223 Igor <<<
      begin
        RetNo := ReadReturn(DataDir, FlName);
        result := RetNo > 0;
      end;
  finally
    FreeAndNil(FDConnection);
    FreeAndNil(Table);
  end;

  *)

  // Var Table1 : TTable;Reslt:Integer;
  // begin
  // Result := False;
  // Table1 := TTable.Create(Application);
  // Table1.DataBaseName := DataDir;
  // Table1.TableName := ClientsTable;
  // Table1.IndexFieldNames := 'FILE_NAME';
  // Table1.Open;
  //
  // If Table1.FindKey([FlName]) then
  // begin
  // Reslt:=ReadReturn(RNo,Datadir,FlName);
  // If Reslt=0 then  begin Result := True; Table1.Close; Table1.Free; Exit; end
  // end;
  //
  // Table1.Close;
  // Table1.Free;
end;

Function TEfileT3_2026.BackUpTaxFile(NetFileDir, FileName: String): Boolean;
Var
  DestDir: String;
  FlNm: String;
begin
  result := False;
  DestDir := NetFileDir + '\' + 'Transmitted';
  FlNm := ExtractFileName(FileName);
  ForceDirectories(DestDir);
  If DirectoryExists(DestDir) then
  begin
    If CopyFile(FileName, DestDir + '\' + FlNm) then
    begin
      result := True;
      // ShowTimedMsg(FileName + ' copied to folder: '+DestDir,1600);  //20130130
      Exit;
    end
    else
    begin
      ShowMessage('Failed to back up the transmitted file');
    end;
  end
  Else // no backup directory
    ShowMessage('Directory ' + NetFileDir + '\' + 'Transmitted' +
      ' cannot be created');
end;

procedure TEfileT3_2026.ShowContentsBtnClick(Sender: TObject);
Var
  h: word;
begin
  CreateJsonMessage(RetNo, GetProdOrTest, OnlineMethod); //20211220 Igor
  if not FileExists(MkSubmittedFileName(RetNo)) then
    ShowMessage('File '+ MkSubmittedFileName(RetNo) +'not found')
  else
    ShowMessageHTMLFromFile(MkSubmittedFileName(RetNo));
end;

procedure TEfileT3_2026.SaveDialog1Close(Sender: TObject);
begin
  If FileExists(FileNameBox.Text) then
    SysUtils.DeleteFile(FileNameBox.Text);
  Close;
end;

procedure TEfileT3_2026.CreateFileHMLClick(Sender: TObject);
begin
  ProdOrTest:=GetProdOrTest; //20211220 Igor
  ShowEfileJsonFile;



end;

procedure TEfileT3_2026.ShowEfileJsonFile;
var
  FlName: String;
  RetNo: Integer;
  JsonList: TStringList;
  I, Y: Integer; //20260204 Igor
  lLastNotSpaceSymbolPos: Integer; //20260204 Igor
begin
  RetNo := GetCurrentRetNo;
  If RetNo > 0 then
  begin
    JsonList := TStringList.Create;
    try
      //20240118 Igor >>>
      createEfileJson(RetNo, GetSelectedFormName, JsonList, GetProdOrTest);
      FlName := MkJsonOnlyFileName(RetNo);
      //20240118 Igor <<
      manuallyfixBenoSubmissionBecauseCouldntDoItRight(JsonList);

      manuallyfixNoDecimalOnDollarCentsIssueBecauseCouldntDoItRight(JsonList); //jz//20260312

      //20260204 Igor trim JSON lines >>>
      for i:= 0 to pred(JsonList.Count) do
      begin
        JsonList[i]:= StringReplace(JsonList[i], ':          ', ':', [rfReplaceAll]);
        JsonList[i]:= StringReplace(JsonList[i], ':      ', ':', [rfReplaceAll]);
        JsonList[i]:= StringReplace(JsonList[i], ':    ', ':', [rfReplaceAll]);
      end;
      for i:= 0 to pred(JsonList.Count) do
      begin
        if (Length(JsonList[i]) > 0) and (JsonList[i][Length(JsonList[i])] = ' ') then
        begin
          lLastNotSpaceSymbolPos:= -1;
          for y:= Length(JsonList[i]) downto 1 do
            if (JsonList[i][y] <> ' ') then
            begin
              lLastNotSpaceSymbolPos:= y;
              Break;
            end;

          if (lLastNotSpaceSymbolPos >= 0) then
            JsonList[i]:= Copy(JsonList[i], 1, lLastNotSpaceSymbolPos);
        end;
      end;
      //20260204 Igor <<<

      //JsonList.SaveToFile(FlName);
      saveXMLWithNoCRAPasswordID(FlName, JsonList,true);

    finally
      JsonList.Free;
    end;
    if not FileExists(FlName) then
      ShowMessage('File '+ FlName +'not found')
    else
      ShowMessageHTMLFromFile(FlName);

    if FileExists(FlName) then DeleteFile(FlName); //jz//20260311 - CRA probably want the files deleted
  end
  else
  Begin
    ShowMessage('The tax return must be opened first');
    //Close;
    //Exit;
  end;
end;

procedure TEfileT3_2026.EfileErrorMessages1Click(Sender: TObject);
begin
  ShowPdf(AppDir, 'Ch2-21e.pdf'); //Every year
end;



procedure TEfileT3_2026.WebServiceserrors1Click(Sender: TObject);
begin
  ShowPdf(AppDir, 'WebServiceErrors.pdf');
end;






//function TEfileT3_2026.checkCRAKeyVal(CRADepth,CRAkey,CRAval:string):string;
function TEfileT3_2026.checkCRAKeyValandAddTo(var VTJSONFileList:Tstringlist;CRADepth,CRAkey,CRAval:string):string;


          function fixSelectValues(val, key: string): string;
          begin
            if key = '"localNumber"' then
              begin result := stringreplace(val, '-', '',[]); end

            else if key = '"languageOfCorrespondence"' then
            begin if val = 'X' then
                      result := 'ENGLISH'
                    else
                      result := 'FRENCH';
            end

            else if key = '"trustType"' then
            begin
              if val = '|43|X' then result := 'TYPE_903';
              if val = '|45|X' then result := 'TYPE_904';
              if pos('|81|',val) > 0 then result := 'TYPE_' + stringreplace(val,'|81|', '',[]);
            end

            else if key = '"refundCode"' then
              begin if val = '0' then
                result := 'ISSUE_OVERPAYMENT_00'; end


            else if (key = '"trustAccountNumber"') or (key = '"trustNumber"') then
                begin result := 'A' + val; end


            else if key = '"trustDocumentFilingMethod"' then
            begin
              if val = '|39|X' then result := 'SENT';
              if val = '|72|X' then result := 'WITH_T3_APP';
              if val = '|30|X' then result := 'WITH_T1';
            end


            else
              result := val; //no change

          end;
var
    prefix, postfix, vtValue: string;
    vtKeyWordString: string;

    e, f : string;

    rn, j, k : integer;

    vtKeyWordMapArray : TArray<String>;

    JSONtoProgramMapList : Tstringlist;

begin
    RN := GetCurrentRetNo;

    JSONtoProgramMapList  := Tstringlist.Create;
    JSONtoProgramMapList.LoadFromFile('C:\vtPrograms\2023\DistrFl\T3-2023\JSONProgramMapDepth.json');

    vtKeyWordString:='';
    for j := 0 to JSONtoProgramMapList.count-1 do
    begin
      if pos(CRAkey, JSONtoProgramMapList[j]) > 0 then
      begin
        vtKeyWordString := JSONtoProgramMapList[j];
      end;
    end;


    prefix := '';
    postfix := '';
    vtValue := '';
    if vtKeyWordString > '' then
    begin
      if pos('?',vtKeyWordString) > 0 then
        postfix := ' = ??? found, map incomplete'
      else
      begin

          vtKeyWordMapArray :=  vtKeyWordString.Split(['|']);
          if Length(vtKeyWordMapArray) > 2 then
          begin
            if trim(vtKeyWordMapArray[2]) = 'M' then
            begin
              f := alltrim(vtKeyWordMapArray[1]);
              for k := 3 to length(vtKeyWordMapArray)-1 do
              begin
                e := alltrim(vtKeyWordMapArray[k]);
                vtValue := FetchElm(RN,f,strtoint(e));
                if vtValue > '' then
                begin
                  vtValue := fixSelectValues('|'+e+'|' + vtValue, CRAkey); //vtValue := '"'+ vtValue +'"';
                  postfix := ' = ' + vtValue;
                  break;
                end;
              end;
            end
            else if trim(vtKeyWordMapArray[2]) = 'B' then
            begin
              f := alltrim(vtKeyWordMapArray[1]);
              e := alltrim(vtKeyWordMapArray[3]);
              vtValue := FetchElm(RN,f,strtoint(e));
              if vtValue > '' then
                vtValue := 'true' else vtValue := 'false';
              vtValue := fixSelectValues(vtValue, CRAkey);
              postfix := ' = ' + vtValue;
            end
            else
            begin
              f := alltrim(vtKeyWordMapArray[1]);
              e := alltrim(vtKeyWordMapArray[2]);
              vtValue := FetchElm(RN,f,strtoint(e)); //vtValue := '"'+ vtValue +'"';
              vtValue := fixSelectValues(vtValue, CRAkey);
              if vtValue = '' then postfix := ' = returned blank' else postfix := ' = ' + vtValue;
            end;

            if not (vtValue = stringreplace(CRAVal,'"', '', [rfReplaceAll]) ) then
              postfix := postfix + ' !*** DIFFERENT VT value ***!';
            prefix := f + ',' + e + ' ';


          end;
      end;
    end;

    //result :=   prefix + ' ' + CRAkey + ' ' + CRAVal + postfix;
    //result :=   paddR(prefix, 10) + ' ' + paddR(CRAkey, 60) + ' ' + paddR(CRAVal,10) + postfix;
    VTJSONFileList.add(paddR(prefix, 10) + ' ' + paddR(CRAkey, 60) + ' ' + stringreplace(CRAVal,'"','',[rfReplaceAll]));
    if postfix > '' then
    begin
      VTJSONFileList.add(paddR('', 69) + postfix);
      VTJSONFileList.add('');
    end;
end;











procedure TEfileT3_2026.BitBtn2Click(Sender: TObject);
          function ExtractBetween(const Value, A, B: string): string;
          var
            aPos, bPos: Integer;
          begin
            result := '';
            aPos := Pos(A, Value);
            if aPos > 0 then begin
              aPos := aPos + Length(A);
              bPos := PosEx(B, Value, aPos);
              if bPos > 0 then begin
                result := Copy(Value, aPos, bPos - aPos);
              end;
            end;
          end;


          procedure parseReturnLines(returnLinesString:string);
          var
            craReturnLinesArray, fieldCodeValueArray:TArray<String>;
            keyWord, cLine , CRAValue: string;
            i:integer;
          begin
            returnLinesString := stringReplace(returnLinesString, '},{', '|', [rfReplaceAll]);
            craReturnLinesArray :=  returnLinesString.Split(['|']);
            //for i := 0 to craReturnLinesArray.count -1 do
            begin
              stringReplace(craReturnLinesArray[i], '","', '|', [rfReplaceAll]);
              fieldCodeValueArray := returnLinesString.Split(['|']);

              //key := fieldCodeValueArray[0];
              //val := fieldCodeValueArray[1];

              //VTJSONFileList.add(checkCRAKeyVal(depthchart,key,val));
            end;

            {
            if keyWord = '"fieldCode"' then
            begin
              cLine := StringReplace(cLine,keyWord,'',[]);
              keyWord := '"' + ExtractBetween(cLine, '"', '"') + '"';

              //cLine:= CRAJSONFileList[i+1];
              if pos(',',cLine) = 0 then cLine := cLine + ','; //needs end delim
              CRAValue := trim(ExtractBetween(cLine, ':', ','));
              CRAValue := StringReplace(CRAValue,'"','',[rfReplaceAll]);
              if pos('.00', CRAValue) = 0 then
                CRAValue := FormatFloat('.00', strtofloat(CRAValue));
            end;
            }
          end;


var
  CRAJSONData    : ansiString;
  JSONObject     : TJSONObject;
  JSONPair       : TJSONPair;

  i              : Integer;


  JSONObject1, JSONObject2, JSONObject3, JSONObject4     : TJSONObject;
  JSONPair1,   JSONPair2,   JSONPair3,   JSONPair4       : TJSONPair;

  depthchart:string;


  VTJSONFileList, JSONtoProgramMapList : Tstringlist;
  key, val : string;
  savefilename1:string;


  //for if returnlines
  returnLinesString:string;
  craReturnLinesArray, fieldCodeValueArray:TArray<String>;
  keyWord, cLine , CRAValue, fieldandValueString: string;

  JSONPairJsonString:string;
  p:integer;
begin

  CRAJSONData := populateJSONfromFile();

  if CRAJSONData > '' then
  begin
    VTJSONFileList        := Tstringlist.Create;
    JSONtoProgramMapList  := Tstringlist.Create;
    //gets loaded in checkCRAKeyValandAddTo
    //JSONtoProgramMapList.LoadFromFile('C:\vtPrograms\2023\DistrFl\T3-2023\JSONProgramMap.json');
  end
  else
    exit;


   JSONObject := TJSonObject.ParseJSONValue(CRAJSONData) as TJSONObject;
   try
     for JSONPair in JSONObject do
     begin

          if pos('{',JSONPair.JsonValue.ToString) = 0 then
          begin
            //ShowMessage(Format('1) Key=%s Value=%s',[JSONPair.JsonString.ToString,JSONPair.JsonValue.ToString]));
            depthchart := JSONPair.JsonString.ToString; //showmessage(depthchart);
          end;

          if (JSONPair.JsonString.ToString = '"returnLines"') or (JSONPair.JsonString.ToString = '"t2042Submissions"') then
          begin
              //ShowMessage(Format('1) Key=%s Value=%s',[JSONPair.JsonString.ToString,JSONPair.JsonValue.ToString]));
              //parseReturnLines(JSONPair.JsonValue.ToString);

              returnLinesString := JSONPair.JsonValue.ToString;

              JSONPairJsonString := JSONPair.JsonString.ToString;
              if  (JSONPairJsonString = '"t2042Submissions"') or
                  (JSONPairJsonString = '"t2125Submissions"')
              then
              begin
                p := pos('"returnLines":', returnLinesString) + length('"returnLines":');
                returnLinesString := returnLinesString.SubString(p);
              end;

              returnLinesString := stringReplace(returnLinesString, '}]', '', [rfReplaceAll]); //remove from end
              returnLinesString := stringReplace(returnLinesString, '},{', '|', [rfReplaceAll]);
              craReturnLinesArray :=  returnLinesString.Split(['|']);
              for i := 0 to length(craReturnLinesArray)-1 do
              begin
                fieldandValueString := craReturnLinesArray[i]; //fieldandValueString := stringReplace(craReturnLinesArray[i], '","', '|', [rfReplaceAll]);
                fieldandValueString := stringReplace(fieldandValueString, '"fieldCode"',  '', [rfReplaceAll]);
                fieldandValueString := stringReplace(fieldandValueString, '"fieldValue"', '', [rfReplaceAll]);
                fieldCodeValueArray := fieldandValueString.Split([',']);

                key := ExtractBetween(fieldCodeValueArray[0]+'|', ':', '|');
                val := ExtractBetween(fieldCodeValueArray[1]+'|', ':', '|');

                if (pos('.00', val) = 0) and (pos('"', val) = 0) then
                  val := FormatFloat('.00', strtofloat(val));

                checkCRAKeyValandAddTo(VTJSONFileList,depthchart,key,val);
              end;
          end;

          if (JSONPair.JsonString.ToString = '"header"') or
             (JSONPair.JsonString.ToString = '"trustIdentification"') or
             (JSONPair.JsonString.ToString = '"trustTypeInformation"') or
             (JSONPair.JsonString.ToString = '"filingInformation"') or
             (JSONPair.JsonString.ToString = '"otherInformation"') or
             (JSONPair.JsonString.ToString = '"memoIndicators"')
          then
          begin
            JSONObject1 := TJSonObject.ParseJSONValue(JSONPair.JsonValue.ToString) as TJSONObject;
            for JSONPair1 in JSONObject1 do
            begin
                if pos('{',JSONPair1.JsonValue.ToString) = 0 then
                begin
                  key:=JSONPair1.JsonString.ToString;
                  val:=JSONPair1.JsonValue.ToString;
                  checkCRAKeyValandAddTo(VTJSONFileList,depthchart,key,val);
                  {
                  ShowMessage(Format('2) Key=%s Value=%s',
                               [JSONPair1.JsonString.ToString,
                                JSONPair1.JsonValue.ToString]));}

                  depthchart := JSONPair.JsonString.ToString + ' ' +
                                JSONPair1.JsonString.ToString ;
                  //showmessage(depthchart);

                end;


                if (JSONPair1.JsonString.ToString = '"taxProfessionalData"') or
                   (JSONPair1.JsonString.ToString = '"trustIdentifier"')  or
                   (JSONPair1.JsonString.ToString = '"primaryTrusteeContactInformation"')  or
                   (JSONPair1.JsonString.ToString = '"trustResidencyInformation"')
                then
                begin
                  JSONObject2 := TJSonObject.ParseJSONValue(JSONPair1.JsonValue.ToString) as TJSONObject;
                  for JSONPair2 in JSONObject2 do
                  begin
                    if pos('{',JSONPair2.JsonValue.ToString) = 0 then
                    begin
                      key:=JSONPair2.JsonString.ToString;
                      val:=JSONPair2.JsonValue.ToString;
                      checkCRAKeyValandAddTo(VTJSONFileList, depthchart,key,val);



                       {ShowMessage(Format('3) Key=%s Value=%s',
                                   [JSONPair2.JsonString.ToString,
                                    JSONPair2.JsonValue.ToString])); }

                       depthchart := JSONPair.JsonString.ToString   + ' ' +
                                      JSONPair1.JsonString.ToString  + ' ' +
                                      JSONPair2.JsonString.ToString ;
                       //showmessage(depthchart);

                    end;
                  end;

                  if (JSONPair2.JsonString.ToString = '"t183ElectronicSignature"') or
                     (JSONPair2.JsonString.ToString = '"nonIndividualTrusteeContactInformation"')  or
                     (JSONPair2.JsonString.ToString = '"IndividualTrusteeContactInformation"')
                  then
                  begin
                    JSONObject3 := TJSonObject.ParseJSONValue(JSONPair2.JsonValue.ToString) as TJSONObject;
                    for JSONPair3 in JSONObject3 do
                    begin
                      if pos('{',JSONPair3.JsonValue.ToString) = 0 then
                      begin
                        key:=JSONPair3.JsonString.ToString;
                        val:=JSONPair3.JsonValue.ToString;
                        checkCRAKeyValandAddTo(VTJSONFileList,depthchart,key,val);

                         {ShowMessage(Format('4) Key=%s Value=%s',
                                     [JSONPair3.JsonString.ToString,
                                      JSONPair3.JsonValue.ToString])); }

                          depthchart := JSONPair.JsonString.ToString   + ' ' +
                                        JSONPair1.JsonString.ToString  + ' ' +
                                        JSONPair2.JsonString.ToString  + ' ' +
                                        JSONPair3.JsonString.ToString ;
                          //showmessage(depthchart);

                      end;
                    end;
                    if (JSONPair3.JsonString.ToString = '"contactPerson"') or
                       (JSONPair3.JsonString.ToString = '"address"')
                    then
                    begin
                      JSONObject4 := TJSonObject.ParseJSONValue(JSONPair3.JsonValue.ToString) as TJSONObject;
                      for JSONPair4 in JSONObject4 do
                      begin
                        if pos('{',JSONPair4.JsonValue.ToString) = 0 then
                        begin
                          key:=JSONPair4.JsonString.ToString;
                          val:=JSONPair4.JsonValue.ToString;
                          checkCRAKeyValandAddTo(VTJSONFileList, depthchart,key,val);


                           {ShowMessage(Format('5) Key=%s Value=%s',
                                       [JSONPair4.JsonString.ToString,
                                        JSONPair4.JsonValue.ToString])); }

                            depthchart := JSONPair.JsonString.ToString   + ' ' +
                                          JSONPair1.JsonString.ToString  + ' ' +
                                          JSONPair2.JsonString.ToString  + ' ' +
                                          JSONPair3.JsonString.ToString ;
                            //showmessage(depthchart);

                        end;
                      end;
                    end;
                end;
            end;
          end;
     end;
   end;
   finally
     JSONObject.Free;
   end;

  //savefilename := ChangeFileExt(Certfile, '') + '_COMPARE.json';
  //VTJSONFileList.SaveToFile(savefilename);

  savefilename1:= 'C:\vtPrograms\2023\DistrFl\T3-2023\JSON_VT_CRA_COMPARE.json';
  VTJSONFileList.SaveToFile(savefilename1);

  //showmessage('saved to: ' + savefilename + ' and ' + savefilename1);
  showmessage('saved to: ' + savefilename1);


   VTJSONFileList.free;
   JSONtoProgramMapList.free;

end;

procedure TEfileT3_2026.BitBtn5Click(Sender: TObject);
Var
  Url: String;
  h: THandle;
begin
  Url := 'http://www.microsoft.com/downloads/en/details.aspx?FamilyID=993c0bcf-3bcf-4009-be21-27e85e1857b1';
  Screen.Cursor := crHourGlass;
  h := ShellExecute(Self.Handle, 'open', PChar('' + Url), Nil, Nil, Sw_Show);
  If h <= 32 then
    ShowMessage('Connection failed');
  Screen.Cursor := CrDefault;
end;




procedure TEfileT3_2026.testResponseClick(Sender: TObject); //20211130 Igor
var
  tempResponseList: TStringList;
  AckResponseFlName: string;
begin
  OpenDialog1.FileName := '*Received.json';
  OpenDialog1.InitialDir := NetFileDir;
  OpenDialog1.Filter := 'JSON files (*.json)|*.json|' + 'Any (*.*)|*.*';
  If OpenDialog1.Execute then
  begin
    tempResponseList := TStringList.Create;
    tempResponseList.loadFromFile(OpenDialog1.FileName);

    InitAckRec;

    parseJsonResponse(RetNo, tempResponseList.Text);

    If (AckRec.EFresultType = EFaccepted) { AckRec.Accepted } then
      CreateEfileResponseHtm(RetNo, AckRec, AppDir + '\' + 'EFAccepted.htm')
    Else If AckRec.EFresultType = EFwebServiceError then
      CreateEfileResponseHtm(RetNo, AckRec, AppDir + '\' + 'EFWebServError.htm')
    Else
      CreateEfileResponseHtm(RetNo, AckRec, AppDir + '\' + 'EFNotAccepted.htm');

    AckResponseFlName := NetFileDir + '\' +
      RemoveChar(GetLastName(RetNo) + ' ' + GetFirstName(RetNo) + {'-' + GetSinNo(RetNo) +} '-EfileAck', '.') + '.htm';
    // AckResponseFlName:=ChangeFileExt(OpenDialog1.FileName, '.htm');
    If FileExists(AckResponseFlName) then
      ShellExecute(Self.Handle, nil, PChar('' + AckResponseFlName), nil, nil,
        SW_NORMAL);

  end;

end;


procedure TEfileT3_2026.BitBtn1Click(Sender: TObject);
begin
  CompareVTjsonValtoCerfTestFile();
end;



procedure TEfileT3_2026.CompareVTjsonValtoCerfTestFile();
          function ExtractBetween(const Value, A, B: string): string;
          var
            aPos, bPos: Integer;
          begin
            result := '';
            aPos := Pos(A, Value);
            if aPos > 0 then begin
              aPos := aPos + Length(A);
              bPos := PosEx(B, Value, aPos);
              if bPos > 0 then begin
                result := Copy(Value, aPos, bPos - aPos);
              end;
            end;
          end;

          function fixSelectValues(val, key: string): string;
          begin
            if key = '"localNumber"' then
              begin result := stringreplace(val, '-', '',[]); end

            else if key = '"languageOfCorrespondence"' then
              begin if val = 'X' then
                result := 'ENGLISH'; end

            else if key = '"trustType"' then
            begin
              if val = '|43|X' then result := 'TYPE_903';
              if val = '|45|X' then result := 'TYPE_904';
              if pos('|81|',val) > 0 then result := 'TYPE_' + stringreplace(val,'|81|', '',[]);
            end

            else if key = '"refundCode"' then
              begin if val = '0' then
                result := 'ISSUE_OVERPAYMENT_00'; end


            else if key = '"trustAccountNumber"' then
                begin result := 'A' + val; end


            else if key = '"trustDocumentFilingMethod"' then
            begin
              if val = '|39|X' then result := 'SENT';
              if val = '|72|X' then result := 'WITH_T3_APP';
              if val = '|30|X' then result := 'WITH_T1';
            end


            else
              result := val; //no change
          end;





var
  i,j,k, RN:integer;
  f, e:string;
  savefilename, savefilename1:string;
  prefix, postFix,  cLine, keyWord, Certfile, keyWordString, vtValue, CRAValue:string;
  CRAJSONFileList, VTJSONFileList, JSONtoProgramMapList:Tstringlist;
  keyWordMapArray: TArray<String>;
begin
  RN := GetCurrentRetNo;
  //showmessage(GetCurrentDir());
  //showmessage(FetchElm(RetNo,'T3',11));

  Certfile := chooseJSONFile;
  if Certfile > '' then
  begin
    CRAJSONFileList       := Tstringlist.Create;
    VTJSONFileList        := Tstringlist.Create;
    JSONtoProgramMapList  := Tstringlist.Create;

    CRAJSONFileList.LoadFromFile(Certfile);
    JSONtoProgramMapList.LoadFromFile('C:\vtPrograms\2023\DistrFl\T3-2023\CERTIFTESTING\JSONProgramMap.json');
  end
  else
    exit;

  for i := 0 to CRAJSONFileList.Count-1 do
  begin
    cLine:= CRAJSONFileList[i];

    if (pos(':{',cLine) > 0) or (pos(':[',cLine) > 0) then
      begin VTJSONFileList.add(CRAJSONFileList[i]); Continue; end;

    keyWord := '"' + ExtractBetween(cLine, '"', '"') + '"';

    if pos(',',cLine) = 0 then cLine := cLine + ','; //needs end delim
    CRAValue := trim(ExtractBetween(cLine, ':', ','));
    CRAValue := StringReplace(CRAValue,'"','',[rfReplaceAll]);

    if keyWord = '"fieldCode"' then
    begin
      cLine := StringReplace(cLine,keyWord,'',[]);
      keyWord := '"' + ExtractBetween(cLine, '"', '"') + '"';

      cLine:= CRAJSONFileList[i+1];
      if pos(',',cLine) = 0 then cLine := cLine + ','; //needs end delim
      CRAValue := trim(ExtractBetween(cLine, ':', ','));
      CRAValue := StringReplace(CRAValue,'"','',[rfReplaceAll]);
      if pos('.00', CRAValue) = 0 then
        CRAValue := FormatFloat('.00', strtofloat(CRAValue));
    end;


    keyWordString:='';
    for j := 0 to JSONtoProgramMapList.count-1 do
    begin
      if pos(keyWord, JSONtoProgramMapList[j]) > 0 then
      begin
        keyWordString := JSONtoProgramMapList[j];
      end;
    end;

    prefix := '';
    postfix := '';
    vtValue := '';
    if keyWordString > '' then
    begin
      if pos('?',keyWordString) > 0 then
        postfix := ' = found:??? , map incomplete'
      else
      begin

          keyWordMapArray :=  keyWordString.Split(['|']);
          if Length(keyWordMapArray) > 2 then
          begin
            if trim(keyWordMapArray[2]) = 'M' then
            begin
              f := alltrim(keyWordMapArray[1]);
              for k := 3 to length(keyWordMapArray)-1 do
              begin
                e := alltrim(keyWordMapArray[k]);
                vtValue := FetchElm(RN,f,strtoint(e));
                if vtValue > '' then
                begin
                  vtValue := fixSelectValues('|'+e+'|' + vtValue, keyWord);
                  postfix := ' = ' + vtValue;
                  break;
                end;
              end;
            end
            else if trim(keyWordMapArray[2]) = 'B' then
            begin
              f := alltrim(keyWordMapArray[1]);
              e := alltrim(keyWordMapArray[3]);
              vtValue := FetchElm(RN,f,strtoint(e));
              if vtValue > '' then
                vtValue := 'true' else vtValue := 'false';
              vtValue := fixSelectValues(vtValue, keyWord);
              postfix := ' = ' + vtValue;
            end
            else
            begin
              f := alltrim(keyWordMapArray[1]);
              e := alltrim(keyWordMapArray[2]);
              vtValue := FetchElm(RN,f,strtoint(e));
              vtValue := fixSelectValues(vtValue, keyWord);
              if vtValue = '' then postfix := ' = returned blank' else postfix := ' = ' + vtValue;
            end;

            if not (vtValue = CRAValue) then
              postfix := postfix + '  DIFFERENT  ' + prefix;
            prefix := f + ',' + e + ' ';


          end;
      end;
    end;

    VTJSONFileList.add(prefix + CRAJSONFileList[i] + postfix);

  end;

  //savefilename := ChangeFileExt(Certfile, '') + '_COMPARE.json';
  //VTJSONFileList.SaveToFile(savefilename);

  savefilename1:= 'C:\vtPrograms\2023\DistrFl\T3-2023\CERTIFTESTING\JSON_VT_CRA_COMPARE.json';
  VTJSONFileList.SaveToFile(savefilename1);

  CRAJSONFileList.Free;
  VTJSONFileList.Free;
  JSONtoProgramMapList.Free;

  //showmessage('saved to: ' + savefilename + ' and ' + savefilename1);
  showmessage('saved to: ' + savefilename1);

end;

function TEfileT3_2026.populateJSONfromFile():ansistring;
begin
  result := TFile.ReadAllText(chooseJSONFile());
end;


function TEfileT3_2026.chooseJSONFile():string;
var
  aOpenDialog : TOpenDialog;
begin
    aOpenDialog := TOpenDialog.Create(self);
    // Set up the starting directory to be the current one
  aOpenDialog.InitialDir := 'C:\Users\XPSWINDOWSPRO\Documents\VT\CRASpecs\T3-2023\TestCases-T3RET'; //GetCurrentDir;
  // Only allow existing files to be selected
  aOpenDialog.Options := [ofFileMustExist];
  // Allow only .dpr and .pas files to be selected
  //openDialog.Filter := 'Delphi project files|*.dpr|Delphi pascal files|*.pas';
  aOpenDialog.Filter := 'JSON|*.json|All|*.*';
  // Select pascal files as the starting filter type
  //openDialog.FilterIndex := 2;
  // Display the open file dialog
  if aOpenDialog.Execute
  then result := aOpenDialog.FileName;
  //ShowMessage('File : '+openDialog.FileName);
  //else ShowMessage('Open file was cancelled');
  // Free up the dialog
  aOpenDialog.Free;
end;
















procedure TEfileT3_2026.BitBtn3Click(Sender: TObject);

begin

     //findValExample();

end;

end.

