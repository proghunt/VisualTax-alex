unit T1_2026t1efile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin, {Isp3,}
  ActnList, ImgList, shdocvw, Printers, Db, DBTables, ActiveX,
  T1_2026Declare, T1_2026TrimStr, {UPopList,} T1_2026Common,
  T1_2026Common2, {TeeProcs, TeEngine, Chart,}// 20160119 Igor
  T1_2026T1rtns, T1_2026Calc, T1_2026T1Rtns2,
  {URTU,} ShellApi, T1_2026ChildWinNew, {UBuild813,} FileCtrl, T1_2026EolSetup,
  T1_2026EfileRtns,

  ComObj, MsXml2_TLB, vtShape, System.Actions
  // 20110129  NEEDED for connection and the response handler
    , uADCompClient; // 20160119 Igor

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  TT1EfileT1_2026 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    ActionList1: TActionList;
    BackAction: TAction;
    ForwardAction: TAction;
    StopAction: TAction;
    RefreshAction: TAction;
    ExitProgram: TMenuItem;
    Query1: TQuery;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    LabelEfileType: TLabel;
    TransmitBtn: TBitBtn;
    ExitBtn: TBitBtn;
    WebServiceserrors1: TMenuItem;
    EfileErrorMessages1: TMenuItem;
    Panel1: TPanel;
    Label2: TLabel;
    Label9: TLabel;
    BitBtn5: TBitBtn;
    Label1: TLabel;
    WebBrowser1: TWebBrowser;
    testPanal: TPanel;
    Label4: TLabel;
    ProdOrTestBox: TRadioGroup;
    CreateFileHML: TBitBtn;
    testResponse: TBitBtn;
    Label3: TLabel;
    FileNameBox: TEdit;
    ShowContentsBtn: TBitBtn;

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

    Procedure SubmitSoapMsg(RetNo: Integer; SoapMsg: AnsiString;
      ProdOrTest: String; FlName: String; OnlineMethod: String);
    Procedure InitAckRec();
    procedure StartWebServiceTransmission(Sender: TObject);
    Procedure CreateSoapMessage(RetNo: Integer; ProdOrTest: String;
      OnlineMethod: String; Sender: TObject);
    Procedure CreateSoapHeader(Var TempSoapList: TStringList);
    Procedure CreateSoapFooter(Var TempSoapList: TStringList);
    Function MkSubmittedFileName(RetNo: Integer): String;
    Function MkResponseFileName(RetNo: Integer): String;
    Function parseXmlResponse(RetNo: Integer; rString: AnsiString): string;
    procedure CreateFileHMLClick(Sender: TObject);

    procedure ShowEfileXmlFile(Sender: TObject);
    procedure EfileErrorMessages1Click(Sender: TObject);
    procedure WebServiceserrors1Click(Sender: TObject);

    procedure UpdateTheDataBase;
    procedure BitBtn5Click(Sender: TObject);
    procedure testResponseClick(Sender: TObject);

  private
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    FExit: boolean; //20180228 Igor
  end;

var
  T1Efile: TT1EfileT1_2026; // 20160119 Igor
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
  vtCommon,
  vtShowMessageHTML, //20200306 Igor
  T1_2026, T1_2026main, vtMulti, // 20180722 Igor
  vtTrimStr, vtShared, vtDataBase; // 20160119 Igor;

{$R *.DFM}

procedure TT1EfileT1_2026.GetParms;
var s:String;
begin
  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir);
 (* //20180403
  //20180224 protect developer password
  If ((UpperCase(OnLineNo)='B0864') Or (UpperCase(OnLineNo)='B0865')) then
  Begin
   s:=UpperCase(InputBox('Efiler number maybe invalid', 'PSW', ''));
   If (s='IGOR') Or (s='FRED')
   then
   //ok
   Else
    OnlineNo:=''
  end;
 *)
end;

procedure TT1EfileT1_2026.FormCreate(Sender: TObject);
var
  Flags: OLEVariant;
  h: word;
  InitialDir: String;
begin
   setTestingElementsVisibility(testPanal);   //jz//20260402

  If IsHomeUse then
    LabelEfileType.caption := 'VisualTax Netfile'
  else
    LabelEfileType.caption := 'VisualTax Efile On-Line (EOL)';
  RetNo := GetCurrentRetNo;
  OnlineMethod := 'EOL';
  GetParms;

  FileNameBox.Text := MkXmlFileName(RetNo, NetFileDir);
  Screen.Cursor := CrDefault;
  //20180502 Igor >>>
  if not Assigned(XmlList) then
    XmlList := TStringList.Create;
  XmlList.Clear; // 20111212
  //20180502 Igor <<<
end;

Function TT1EfileT1_2026.MakeSelectedStr: String;
Const
  PartNameLen = 14;
Var
  S: string[80];
begin
end;

procedure TT1EfileT1_2026.TransmitBtnClick(Sender: TObject);
Var
  s,AckResponseFlName: String;
  Flags: OLEVariant;
  h: THandle;
begin
 //If UpperCase(InputBox('Enter Password', 'PSW', '')) <> 'N/A' then exit; //20240622
 (* //20180403
  //20180308 protect developer password
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

 if VL(FetchElm(RetNo,'S3',339))<>0  then //20250312 gains or losses)
 begin
   //20250407
  //ShowMessage('Return has capital dispositions. CRA may not accept it for now.');
  //If UpperCase(InputBox('Enter Password', 'PSW', '')) <> 'N/A' then exit; //20260401
 end;

 //20250507
 if IsNonResident(RetNo) then //20250312 gains or losses)
 begin
 // ShowMessage('This is a Non-Resident Return. CRA may bot accept it for now.');
 // If UpperCase(InputBox('Enter Password', 'PSW', '')) <> 'N/A' then exit; //20260401
 end;


 if IsForRefile(Retno) then
 begin
   if MessageDlg('This return is for ReFILE as per INFO - Filing Info'
        +Chr(13)+'ReFILE now?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then
       //ok
       Else
       Exit;
 end;

  // 20160307  Stopped as it seems non functional
  // WebBrowser1.Navigate(WideString('www.visualtax.com/Efiling/RedirectPage.asp'+GetPreparerInfo('')),Flags, Flags, Flags, Flags);

  //20171206
  //do the URL's in two places of this unit
  If ProdOrTestBox.itemIndex = 0 then
  begin
    ProdOrTest := 'P';
    sUrl := 'https://apps.cra-arc.gc.ca/ebci/pfeo/ws/services/FileReturnService?wsdl'; //20220521
   // sUrl := 'https://apps.cra-arc.gc.ca/ebci/pfeo/ws/services/EolService?wsdl'; obsolete
  end
  else
  Begin
    ProdOrTest := 'T';
    sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/pfeo/ws/services/FileReturnService?wsdl'; //20211227 Igor
   //sUrl :='https://apps-ct.cra-arc.gc.ca/ebci/pfeo/ws/services/FileReturnService?wsdl';
  End;

  OnlineMethod := 'EOL';
  EolpFileName := '';

  //20180228 Igor >>>
  FExit := false;

  StartWebServiceTransmission(Sender);
  AddLogAppMon(amtOnEfile, RetNo); // 20180722 Igor //20220519 Igor
  if FExit then
  begin
    Close;
    Exit;
  end;
  //20180228 Igor <<<

  // 20140124
  If (AckRec.EFresultType = EFaccepted) { AckRec.Accepted } then
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFAccepted.htm')
  Else If AckRec.EFresultType = EFwebServiceError then
    AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec,
      AppDir + '\' + 'EFWebServError.htm')
  Else
  begin
    if AckRec.EFresultType = EFNotSent then
    begin showmessage('Efile Submission Canceled'); exit; end
    else
      AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec, AppDir + '\' + 'EFNotAccepted.htm');
  end;



  // above saves the created file in the eolfiles folder for future use?
  // second rround to resolve variables in the created client htm that come from dynamically loaded material after getting the source

  // filename assigned and returned from CreateEfileResponseHtm function //20170126
  // AckResponseFlName:=NetFileDir+'\'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo)+'-EfileAck','.')+'.htm'; //20140126

  If FileExists(AckResponseFlName) then
  begin
    if CheckIsCloud(true) then
     ShowMessageHTMLFromFile(AckResponseFlName)  //20200308 CON gives eror //20200914 Igor
    else
      ShellExecute(Self.Handle, nil, PChar('' + AckResponseFlName), nil, nil,
        SW_NORMAL);
  end
  else
    showmessage('Response file: ' +AckResponseFlName + ' file not found');

  //20200306 Igor <<<
  //20200306 IGOR ShellExecute(Self.Handle, nil, PChar('' + AckResponseFlName), nil, nil,SW_NORMAL);
   Calc(RetNo, 'STATUS');
  // 20140127
  If not SaveReturn(RetNo, Ret[RetNo].SourceDataDir, Ret[RetNo].SourceFlName,
    True, False) = 0 then
    ShowMessage('Return cannot be saved');

  Close; // 20140126
end;

procedure TT1EfileT1_2026.StartWebServiceTransmission(Sender: TObject);
var
  i: Integer;
Begin
  RetNo := GetCurrentRetNo;

  CreateSoapMessage(RetNo, ProdOrTest, OnlineMethod,Sender);

  If SoapMsg = '' then
  Begin
    ShowMessage('No data available for submission');
    Exit;
  end;
  SubmitSoapMsg(RetNo, SoapMsg, ProdOrTest, MkSubmittedFileName(RetNo),OnlineMethod);
end;

// Start of WebServices ---------------------------------------------------------------------------------------------------------------------------------------------------------------

Procedure TT1EfileT1_2026.SubmitSoapMsg(RetNo: Integer; SoapMsg: AnsiString;
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
  ResponseXmlFile: String;
  ConfirmationNumber: String;

  parsedXmlResponseWString: string;
  batchResponseFile: TextFile;
  BatchresponseFlName: String;
Begin
  InitAckRec; //20181802
  GetParms; // 20140120
  //DO THIS in two places
  If ProdOrTest = 'T' then
    sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/pfeo/ws/services/FileReturnService?wsdl' //20211227 Igor
  Else
    sUrl := 'https://apps.cra-arc.gc.ca/ebci/pfeo/ws/services/FileReturnService?wsdl';

  // define
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  // open it
  //20240323
  if ProdOrTest = 'T' then
  Begin
   If UpperCase(InputBox('Create the XML', 'Create the XML to be submitted Y/N', 'Y'))='N' then //<> 'Y'
   begin
    AckRec.EFresultType := EFNotSent; //jz//20250321
    Exit;  //20240506
   end;
  end;

  objHttp.open('POST', sUrl, False, OnLineNo, PassWord); // 20110120

  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?
  objHttp.setRequestHeader('Content-Type', 'text/xml');

  // transmit it now
  Screen.Cursor := crHourGlass;

  // initialize the AckRec at transmission, finish it up upon receiving response
  With AckRec do
  Begin
    FamilyName := GetLastName(RetNo);
    GivenName := GetFirstName(RetNo);
    TransmitBatchName := EolpFileName;
    DateTransmitted := FormatDateTime('yyyy-mm-dd', Date);
    TimeTransmitted := GetTimeToMilliSec(Date);
  end;

  try
   //debugging
   if ProdOrTest = 'T' then
   Begin
    If UpperCase(InputBox('Efile to CRA now?', '', 'N')) = 'Y' then
    //ok
    else
    begin
     ShowMessage ('Not sent to CRA. Ignore the accepted message. See Sunmitted XML in EfileOnline -> History'); //20251122 CZ
     exit;
    end;
   End;

  objHttp.send(SoapMsg); // SEND SOAP MESSAGE
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
  If TransmitDelay < 200 then
    TransmitDelay := 200;
  delay(TransmitDelay);
  Screen.Cursor := CrDefault;
  WString := objHttp.ResponseText;

  parsedXmlResponseWString := parseXmlResponse(RetNo, WString);
  // 20140118
  If OnlineMethod = 'EOLP' then
  begin
    If FileExists(EolpFileName) then
      Write(TedFile, AckRec);
    // add records to the ted batch file-list of records submitted/received
  end;

  // Now save the WString
  ResponseXmlFile := MkResponseFileName(RetNo);
  AList := TStringList.Create;
  AList.Add(WString);
  AList.SaveToFile(ResponseXmlFile);
  AList.Free;

  // succesful transmission
  S := MkSubmittedFileName(RetNo);
  objHttp := Nil; // 20110129  .Free It is not accepted

end;



Procedure TT1EfileT1_2026.InitAckRec();
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

    //20181802
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

Procedure TT1EfileT1_2026.CreateSoapMessage(RetNo: Integer; ProdOrTest: String;
  OnlineMethod: String; Sender: TObject);
Var
  i, j: Integer;
  TempSoapList: TStringList;
  TempDataList: TStringList;
  FileNm, FlName, FirstLast: String;
  S: String;
begin

  GetParms; // 20131217

  TempSoapList := TStringList.Create;

  CreateSoapHeader(TempSoapList); // Not needed for right now

  TempDataList := TStringList.Create;
  If RetNo > 0 then
  begin
    FileNm := MkXmlFileName(RetNo, NetFileDir); // FileNameBox.Text;  //20131216

    CreateXmlDataFile(RetNo, FileNm, ProdOrTest, OnlineMethod,Sender);

    For j := 0 to XmlList.count - 1 do
      TempSoapList.Add(XmlList[j]);
    // XmlList global, known from UEfileRtns; unit
    XmlList.Clear;
  end
  else
  Begin
    ShowMessage('The tax return must be opened first');
    Close;
    Exit;
  end;

  CreateSoapFooter(TempSoapList); // 20141122


  // 20141208
  // OpenDialog1.InitialDir:= 'C:\Users\Costas\Documents\SCHEMA\data\2014 T1Efile Data\';
  // OpenDialog1.Filter := 'XML files (*.xml)|*.xml|'+ 'Any (*.*)|*.*';
  // If OpenDialog1.Execute then
  // begin
  // TempSoapList.loadFromFile(OpenDialog1.FileName);
  // end;

  SoapMsg := '';

  For i := 0 to TempSoapList.count - 1 do
    SoapMsg := SoapMsg + TempSoapList[i] + Chr(13);

  //jz//20260219 - use common save that redacts password and only saves when is Test and the VT efile number
  saveXMLWithNoCRAPasswordID(MkSubmittedFileName(RetNo),TempSoapList,(OnLineNo = 'B0865') and (ProdOrTest = 'T')); //(savelocation:string; aList:tstringlist; promtToSave:boolean);
  //saveXMLWithNoCRAPasswordID(MkSubmittedFileName(RetNo),TempSoapList,false); //(savelocation:string; aList:tstringlist; promtToSave:boolean);
  //If ProdOrTest = 'T' then TempSoapList.SaveToFile(MkSubmittedFileName(RetNo));  //savexml

  TempSoapList.Free;
  TempDataList.Free;
End;

Procedure TT1EfileT1_2026.CreateSoapHeader(Var TempSoapList: TStringList);
Var
  i: Integer;
  efilerIdT1, efilerIdT1PassWord: string;
begin
  With TempSoapList do
  begin
    Add('<?xml version="1.0" encoding="ISO-8859-1"?>');  //"utf-8"?>');   //20181119 encoding="ISO-8859-1"?
    Add('<soapenv:Envelope xmlns:soapenv = "http://schemas.xmlsoap.org/soap/envelope/">');
    //Add('<intentional SyntaxError');
    Add('  <soapenv:Body>');
  end;
end;

Procedure TT1EfileT1_2026.CreateSoapFooter(Var TempSoapList: TStringList);
Var
  i: Integer;
begin

  With TempSoapList do
  begin
    Add('</soapenv:Body>');
    Add('</soapenv:Envelope>');
  end;

end;

Function TT1EfileT1_2026.MkResponseFileName(RetNo: Integer): String; // 20131218
Var
  OnLineNo, PassWord, Url, NetFileDir: String; // 20131218
begin
  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir);; // 20131217
  result := NetFileDir + '\' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + GetSinNo(RetNo) + '-Received', '.') + '.xml';
  // 20140126
end;

Function TT1EfileT1_2026.MkSubmittedFileName(RetNo: Integer): String;
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
  result := NetFileDir + '\' + RemoveChar(GetLastName(RetNo) + ' ' +
    GetFirstName(RetNo) + '-' + GetSinNo(RetNo) + '-Submitted', '.') + '.xml';
  // 20140126
end;

Function TT1EfileT1_2026.parseXmlResponse(RetNo: Integer;
  rString: AnsiString): String;
          function LTrimAnsi(Const S: AnsiString): AnsiString;
          var { len: integer; }
            i: Integer;
          begin
            i := 1;
            while S[i] = ' ' do
              inc(i);
            result := copy(S, i, Length(S) - i + 1);
          end;

          function RTrimAnsi(S: AnsiString): AnsiString;
          var
            len: Integer;
          begin
            while S[Length(S)] = ' ' do
              dec(S[1 { 0 } ]);
            result := S;
          end;

          function AllTrimAnsi(Str: AnsiString): AnsiString;
          begin
            result := Str;
            Exit; // not working??????????
            result := LTrimAnsi(RTrimAnsi(Str));
          end { Trim };

var
          i, j, tPos, k, sPos, ePos, FNo: Integer;


          t, s, e, fCode, fString, messageString, idstring, TimeReceived, tempString: String;
          ReturnedTransmissionNumber, ReturnedEfilerNumber,ReturnedControlNumber: String;
          ReturnedHyperLinkLink, ReturnedHyperLinkText : array [1..5] of string;
          errorClue: array [1 .. 16] of string;
          tempAnsiString , temprString, englishBlock: ansistring;

begin

  idstring := RemoveChar(GetLastName(RetNo) + ' ' + GetFirstName(RetNo), '.') +
    Chr(10) + Chr(13) + GetSinNo(RetNo);

  AckRec.EFresultType := EFrejected;

  // server error -------------------------------------------------------------
  S := '<faultcode>';
  sPos := pos(S, rString);
  IF sPos > 0 then
  BEGIN
    e := '</faultcode>';
    sPos := pos(S, rString) + Length(S);
    ePos := pos(e, rString);
    fCode := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

    S := '<faultstring>';
    e := '</faultstring>';
    sPos := pos(S, rString) + Length(S);
    ePos := pos(e, rString);
    //fString := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
    AckRecResultDescription := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

    s := '<ns1:hostname xmlns:ns1="http://xml.apache.org/axis/">';
    e := '</ns1:hostname>';
    sPos := pos(s, rString);
    if sPos > 0 then
    begin
      sPos := pos(S, rString) + Length(S);
      ePos := pos(e, rString);
      ErrorDescription[1][1] := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
    end;

    ErrorDescription[1][2] := ('Please contact VisualTax');

    messageString := 'Submission Failed' + Chr(10) + Chr(13) + Chr(10) + Chr(13)
      + 'Error Code: ' + fCode + Chr(10) + Chr(13) + fString;
    // MessageDlg(messageString,mtError,[mbOK],0);
    result := idstring + messageString + Chr(10) + Chr(13);

    //AckRec.EFresultType := EFwebServiceError; // 20140124
    // exit;
  END

  ELSE IF pos('SystemError', rString) > 0 then
  BEGIN
    //AckRec.EFresultType := EFwebServiceError;
    //AckRec.EFresultType := EFwebServiceError;

    //no result code???
    s := '<t1ersp:ResultCode>';
    e := '</t1ersp:ResultCode>';
    sPos := pos(S, rString);
    if sPos > 0 then
    begin
      sPos := pos(S, rString) + Length(S);
      ePos := pos(e, rString);
      fCode := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
    end;


    AckRecResultDescription := '';

      //20230216 Igor >>>
    s := '<t1rsp:EnglishMessage';
    e := '</t1rsp:EnglishMessage>';
    sPos := pos(s, rString);
    if sPos > 0 then
    begin
      sPos := pos(S, rString);
      ePos := pos(e, rString);
      if ePos > 0 then
        ePos := ePos + Length(e);
      AckRecResultDescription := ProcessMessageText(MidAnsiStr(rString, sPos, ePos - sPos));
    end;
    {tempAnsiString := '';
    for i := 0 to 3 do
    begin
      s := '<t1rsp:MessageText xml:lang="en">';
      e := '</t1rsp:MessageText>';
      sPos := pos(s, rString);
      if sPos > 0 then
      begin
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        tempAnsiString := tempAnsiString + '<BR>' + AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
      end;

      rString := MidAnsiStr(rString, ePos + Length(e), Length(rString));
    end; //for i
    AckRecResultDescription := tempAnsiString;
    }
    //20230216 Igor <<<

  END

  ELSE
  BEGIN

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


{
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
}

       // get multiple message //20220216
        AckRecResultDescription := '';
        //20230216 Igor >>>
        s := '<t1rsp:EnglishMessage';
        e := '</t1rsp:EnglishMessage>';
        sPos := pos(s, rString);
        if sPos > 0 then
        begin
          sPos := pos(S, rString);
          ePos := pos(e, rString);
          if ePos > 0 then
            ePos := ePos + Length(e);
          AckRecResultDescription := ProcessMessageText(MidAnsiStr(rString, sPos, ePos - sPos));
        end;
        {tempAnsiString := '';
        temprString := rString;
        for i := 0 to 10 do
        begin
          s := '<t1rsp:MessageText xml:lang="en">';
          e := '</t1rsp:MessageText>';
          sPos := pos(s, temprString);
          if sPos > 0 then
          begin
            sPos := pos(S, temprString) + Length(S);
            ePos := pos(e, temprString);
            tempAnsiString := tempAnsiString + '<BR>' + AllTrimAnsi(MidAnsiStr(temprString, sPos, ePos - sPos));
          end;

          temprString := MidAnsiStr(temprString, ePos + Length(e), Length(temprString));
        end; //for i
        AckRecResultDescription := tempAnsiString;
        }
        //20230216 Igor <<<

        {tempAnsiString := '';


        //jz //20230217
        //get initial english block for main descrpition
        s := '<t1rsp:EnglishMessage>';
        e := '</t1rsp:EnglishMessage>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        //englishBlock := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
        temprString := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
        //temprString := rString;
        for i := 0 to 10 do
        begin
          s := '<t1rsp:MessageText xml:lang="en">';
          e := '</t1rsp:MessageText>';
          sPos := pos(s, temprString);
          if sPos > 0 then
          begin
            sPos := pos(S, temprString) + Length(S);
            ePos := pos(e, temprString);
            tempAnsiString := tempAnsiString + '<BR>' + AllTrimAnsi(MidAnsiStr(temprString, sPos, ePos - sPos));
          end;

          temprString := MidAnsiStr(temprString, ePos + Length(e), Length(temprString));
        end; //for i
        AckRecResultDescription := tempAnsiString;

        //jz //20230217
        //get initial english block for hyperlinks
        s := '<t1rsp:EnglishMessage><t1rsp:MessageText xml:lang="en">';
        e := '</t1rsp:Hyperlink></t1rsp:EnglishMessage>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        englishBlock := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

        //get all hyperlinks in the englishBlock if there are any, up to 5
        for i := 1 to 5 do
        begin
          ReturnedHyperLinkText[i] := '';
          // get hyperlink text
          s := '<t1rsp:HyperlinkText>';
          e := '</t1rsp:HyperlinkText>';
          sPos := pos(S, englishBlock) + Length(S);
          ePos := pos(e, englishBlock);
          ReturnedHyperLinkText[i] := AllTrimAnsi(MidAnsiStr(englishBlock, sPos, ePos - sPos));

          // get hyperlink text and target
          ReturnedHyperLinkLink[i] := '';
          s := '<t1rsp:HyperlinkTarget>';
          e := '</t1rsp:HyperlinkTarget>';
          sPos := pos(S, englishBlock) + Length(S);
          ePos := pos(e, englishBlock);
          ReturnedHyperLinkLink[i] := AllTrimAnsi(MidAnsiStr(englishBlock, sPos, ePos - sPos));

          // truncate englishBlock to get next one
          //first to the end of the last
          englishBlock := AllTrimAnsi(MidAnsiStr(englishBlock, ePos, length(englishBlock)));
          //next to the beginning of the next
          s := '<t1rsp:Hyperlink>';
          sPos := pos(s, englishBlock);
          englishBlock := AllTrimAnsi(MidAnsiStr(englishBlock, sPos, length(englishBlock)));
        end;
        }



      // success ------------------------------------------------------------------
      //20211215 Igor >>>           //added 181 //jz 20230217
      if fCode.StartsWith('180') or fCode.StartsWith('181') or fCode.StartsWith('182') or fCode.StartsWith('183')
      or fCode.StartsWith('580') or fCode.StartsWith('582') or fCode.StartsWith('583')  //20170324 //added 580 refile acceptance //20170420
      //20211215 Igor <<<
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

        //20230216 Igor >>>
        //ReturnedHyperLinkText := '';
        //ReturnedHyperLinkLink := '';
        // get hyperlink text and target
        // no need to extract hyperlinks because they are used in MessageText // 20230216 Igor
        {s := '<t1rsp:HyperlinkText>';
        e := '</t1rsp:HyperlinkText>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        ReturnedHyperLinkText := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));

        s := '<t1rsp:HyperlinkTarget>';
        e := '</t1rsp:HyperlinkTarget>';
        sPos := pos(S, rString) + Length(S);
        ePos := pos(e, rString);
        ReturnedHyperLinkLink := AllTrimAnsi(MidAnsiStr(rString, sPos, ePos - sPos));
        }
        //20230216 Igor <<<

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


            //20230216 Igor >>>
            s := '<t1rsp:EnglishMessage';
            e := '</t1rsp:EnglishMessage>';
            sPos := pos(s, rString);
            if sPos > 0 then
            begin
              sPos := pos(S, rString);
              ePos := pos(e, rString);
              if ePos > 0 then
                ePos := ePos + Length(e);
              ErrorDescription[i][1] := ProcessMessageText(MidAnsiStr(rString, sPos, ePos - sPos));
            end;
            //20181802
            {
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
            }
            //20230216 Igor <<<







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

  END; // else not servererror

  // MessageDlg(tempString,mtError,[mbOK],0);    //20141211

  With AckRec do
  Begin
    DateReceived    := FormatDateTime('yyyy-mm-dd', Date);
    TimeReceived    := GetTimeToMilliSec(Date);
    DocumentNo      := ReturnedEfilerNumber + ReturnedControlNumber; // 20150128
    TransmissionNo  := ReturnedTransmissionNumber;
    EfilerNumber    := ReturnedEfilerNumber; // 20140130


    FamilyName      := GetLastName(RetNo);
    GivenName       := GetFirstName(RetNo);

    ResultCode      := fCode;
    Description     := AckRecResultDescription; // 20170130
    tempAckRecDescription := AckRecResultDescription;

    //jz //20230217
    For i := 1 to 5 do
    Begin
      HyperLinkLink[i] := ReturnedHyperLinkLink[i];
      HyperLinkText[i] := ReturnedHyperLinkText[i];
    end;

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

  // store response to the form  //20140126
  FNo := GetFormNo('STATUS');
  If AckRec.EFresultType = EFaccepted then
  begin
    Ret[RetNo].EfStatus := '02';
    StoreElm(RetNo, FNo, 15, '02'); // It goes automatically via calc Status
    //20171220  Change confirmatio  to [37] and leave the dcn as is
    StoreElm(RetNo, FNo, 36, GetEfStatusDescr('02'));
    StoreElm(RetNo, GetFormNo('T183'), 36, FetchElm(RetNo,'T183',21)); //original dcn   //20171220
    //StoreElm(RetNo, GetFormNo('T183'), 21, AckRec.TransmissionNo);                                //20171220
    StoreElm(RetNo, GetFormNo('T183'), 37, AckRec.TransmissionNo);  //save confirm num also in [37]  20170331
    StoreElm(RetNo, FNo, 31, FetchElm(RetNo, 'T183', 21));

    (*
    //20171220
    StoreElm(RetNo, FNo, 36, GetEfStatusDescr('02'));
    StoreElm(RetNo, GetFormNo('T183'), 36, FetchElm(RetNo,'T183',21)); //started saving the DCN   //20170320
    StoreElm(RetNo, GetFormNo('T183'), 21, AckRec.TransmissionNo);
    StoreElm(RetNo, GetFormNo('T183'), 37, AckRec.TransmissionNo);  //save confirm num also in [37]  20170331
    StoreElm(RetNo, FNo, 31, FetchElm(RetNo, 'T183', 21));
    *)
  end
  Else
  begin
    Ret[RetNo].EfStatus := '03'; // 20140130
    StoreElm(RetNo, FNo, 15, '03'); // It goes automatically via calc Status
  end;
  StoreElm(RetNo, FNo, 37, AckRec.TransmissionNo); // 20140130
  StoreElm(RetNo, FNo, 31, AckRec.TransmitBatchName);
  StoreElm(RetNo, FNo, 19, AckRec.DateTransmitted);
  StoreElm(RetNo, FNo, 20, AckRec.TimeTransmitted);
  StoreElm(RetNo, FNo, 18, UserName);
  StoreElm(RetNo, FNo, 22, AckRec.DateReceived);
  StoreElm(RetNo, FNo, 23, AckRec.TimeTransmitted);
  StoreElm(RetNo, FNo, 21, UserName);
  k := 24;
  For i := 1 to 6 do
  Begin
    StoreElm(RetNo, FNo, k, AckRec.ErrorCode[i]);
    inc(k);
  end;

end;

procedure TT1EfileT1_2026.SetUp1Click(Sender: TObject);
begin
  Application.CreateForm(TEolSetUpT1_2026, EolSetUp);
  EolSetUp.ShowModal;
  EolSetUp.Free;
  GetParms;
end;

procedure TT1EfileT1_2026.ExitBtnClick(Sender: TObject);
begin
  If FileExists(FileNameBox.Text) then
    SysUtils.DeleteFile(FileNameBox.Text); // 20130317
  Close;
end;

procedure TT1EfileT1_2026.UpdateDataBase1Click(Sender: TObject);
begin
  UpdateTheDataBase;
end;

procedure TT1EfileT1_2026.UpdateTheDataBase;
Var
  RNo: Integer;
  SinNo, Status, ConfirmationNo, DataDir, FlName, AckRcvdBy, AckRcvdDT,
    AckRcvdTm: String;
begin
  If ConfirmationNo = '' then
  begin
    ShowMessage('Confirmation no cannot be retrieved' + Chr(13) +
      'Please mark it down and enter it on the T183 form');
  end;

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

Function TT1EfileT1_2026.UpdateAckStatus(SinNo, Status, AckRcvdBy, AckRcvdDT,
  AckRcvdTm, ConfirmationNo: String): Boolean;
Var
  RNo, FNo: Integer;
begin
  result := False;
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
end;

Function TT1EfileT1_2026.LoadReturn(RNo: Integer; DataDir: String;
  FlName: string): Boolean;
var
  // 20160119 Igor
  FDConnection: TADConnection;
  Table: TADTable;
begin
  result := False;

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

Function TT1EfileT1_2026.BackUpTaxFile(NetFileDir, FileName: String): Boolean;
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

procedure TT1EfileT1_2026.ShowContentsBtnClick(Sender: TObject);
Var
  h: word;
begin
  CreateSoapMessage(RetNo, ProdOrTest, OnlineMethod, Sender);
  //20200914 Igor >>>
  if not FileExists(MkSubmittedFileName(RetNo)) then
    ShowMessage('File '+ MkSubmittedFileName(RetNo) +'not found')
  else
    ShowMessageHTMLFromFile(MkSubmittedFileName(RetNo));
  {h := ShellExecute(Self.Handle, 'open', PChar('' + MkSubmittedFileName(RetNo)),
    Nil, Nil, Sw_Show);
  If h <= 32 then
    ShowMessage('File not found');}
  //20200914 Igor <<<
end;

procedure TT1EfileT1_2026.SaveDialog1Close(Sender: TObject);
begin
  If FileExists(FileNameBox.Text) then
    SysUtils.DeleteFile(FileNameBox.Text);
  Close;
end;

procedure TT1EfileT1_2026.CreateFileHMLClick(Sender: TObject);
begin
 //20171221
  ProdOrTest:='P';
  if ProdOrTestBox.itemindex=1 then ProdOrTest:='T';
  //---------------
  ShowEfileXmlFile(Sender);

end;

procedure TT1EfileT1_2026.ShowEfileXmlFile(Sender: TObject);
var
  FileNm, FlName, FirstLast: String;
  RetNo: Integer;
  h: THandle;
begin
  RetNo := GetCurrentRetNo;
  If RetNo > 0 then
  begin
    FirstLast := '';
    FileNm := FileNameBox.Text;
    // ProdOrTest:=GetProductionOrTest;
    CreateXmlDataFile(RetNo, FileNm, ProdOrTest, OnlineMethod, Sender);

    // remove CDATA from first line
    // XmlList[0] := midstr(XmlList[0],16,length(XmlList[0])); //not needed right now/ any more

    // FlName:=NetFileDir+'\'+'T1Efile-XMLONLY-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),',')+'-'+Ret[RetNo]^.Province+'.xml';
    FlName := NetFileDir + '\' + RemoveChar(GetLastName(RetNo) + ' ' +
      GetFirstName(RetNo) + '-' + GetSinNo(RetNo) + '-' + Ret[RetNo].Province +
      '-XMLONLY', '.') + '.xml'; // 20140126


    //jz//20250314
    saveXMLWithNoCRAPasswordID(FlName,XmlList,true); //(savelocation:string; aList:tstringlist; promtToSave:boolean);
    // NO GOOD format here XmlList.SaveToFile(MkSubmittedFileName(RetNo));  //save it to different folder
    XmlList.Clear;
    // ShowMessage('Done');
    //20200914 Igor >>>
    if not FileExists(FlName) then
      ShowMessage('File '+ FlName +'not found')
    else
      ShowMessageHTMLFromFile(FlName);

    if FileExists(FlName) then DeleteFile(FlName);

  end
  else
  Begin
    ShowMessage('The tax return must be opened first');
    Close;
    Exit;
  end;
end;

procedure TT1EfileT1_2026.EfileErrorMessages1Click(Sender: TObject);
begin
  ShowPdf(AppDir, 'Ch2-19e.pdf'); // 20130213    //Every year //20191205
  //ConnectToWeb('https://www.canada.ca/content/dam/cra-arc/formspubs/pub/rc4018/rc4018ch1-25e.pdf');
end;

procedure TT1EfileT1_2026.WebServiceserrors1Click(Sender: TObject);
begin
  ShowPdf(AppDir, 'WebServiceErrors.pdf');
end;

procedure TT1EfileT1_2026.BitBtn5Click(Sender: TObject);
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

procedure TT1EfileT1_2026.testResponseClick(Sender: TObject);
var
  tempResponseList: TStringList;
  AckResponseFlName: string;
begin
  OpenDialog1.FileName := '*Received.xml';
  OpenDialog1.InitialDir := NetFileDir;
  OpenDialog1.Filter := 'XML files (*.xml)|*.xml|' + 'Any (*.*)|*.*';
  If OpenDialog1.Execute then
  begin
    tempResponseList := TStringList.Create;
    tempResponseList.loadFromFile(OpenDialog1.FileName);

    InitAckRec;

    parseXmlResponse(RetNo, tempResponseList.Text);

    If (AckRec.EFresultType = EFaccepted) { AckRec.Accepted } then
      CreateEfileResponseHtm(RetNo, AckRec, AppDir + '\' + 'EFAccepted.htm')
    Else If AckRec.EFresultType = EFwebServiceError then
      CreateEfileResponseHtm(RetNo, AckRec, AppDir + '\' + 'EFWebServError.htm')
    Else
    begin
      if AckRec.EFresultType = EFNotSent then           //jz//20250321
      begin showmessage('Efile Submission Canceled'); exit; end
      else
        AckResponseFlName := CreateEfileResponseHtm(RetNo, AckRec, AppDir + '\' + 'EFNotAccepted.htm');
    end;

    AckResponseFlName := NetFileDir + '\' +
      RemoveChar(GetLastName(RetNo) + ' ' + GetFirstName(RetNo) + '-' +
      GetSinNo(RetNo) + '-EfileAck', '.') + '.htm';
    // AckResponseFlName:=ChangeFileExt(OpenDialog1.FileName, '.htm');
    If FileExists(AckResponseFlName) then
      ShellExecute(Self.Handle, nil, PChar('' + AckResponseFlName), nil, nil,
        SW_NORMAL);

  end;

end;



end.

