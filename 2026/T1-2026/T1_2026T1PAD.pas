unit T1_2026T1PAD;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  T1_2026Declare,
  T1_2026TrimStr,
  T1_2026EfileRtns, //for SoftReleaseDate
  ComObj,           //for CreateOleObject
  MsXml2_TLB,       //for ixmlHttpRequest
  ShellApi, Vcl.ExtCtrls, Vcl.Buttons          //for shellexecute
  ;

  Const SoftwareReleaseDate='2026-03-26';  //064P  //20260326
  DeveloperId='064';
  PadSoftCode='P';  //20160214 //20250317  //20250425
  //Const SoftwareReleaseDate='2023-01-21';DeveloperId='064';PadSoftCode='P';  //20170208 //20170320 //20200224
  //Const SoftwareReleaseDate='2019-01-16';DeveloperId='064';PadSoftCode='P';  //20170208 //20170320

type
    APAD = Record
      Developer                         : String[3];
      SoftCode                          : String[1];
      SoftRelease                       : String[10];
      SIN                               : String[9];
      givenName                         : String[50];
      familyName                        : String[50];
      PaymentDate                       : String[10];
      PaymentAmount                     : String[10];
      FinancialInstitutionNumber        : String[3];
      FinancialInstitutionBranchNumber  : String[5];
      FinancialInstitutionAccountNumber : String[12];
end;

type
    APADResponse = Record
      status                  : String;
      statusColor             : String;
      dateTimeReceived        : String;
      resultCode              : String;
      messageText             : String;
      errorCode               : Array[1..3] of String[30];
      errorCodeText           : Array[1..3] of String[255];
      hyperLinkLink           : String;
      hyperLinkText           : String;
      ConfirmationNumber      : String;
end;




type
  TT1PadT1_2026 = class(TForm)
    PADbtn: TButton;
    PaymentDateEdit: TEdit;
    PaymentAmountEdit: TEdit;
    FinancialInstitutionNumberEdit: TEdit;
    FinancialInstitutionBranchNumberEdit: TEdit;
    FinancialInstitutionAccountNumberEdit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    testPADResponsebtn: TButton;
    OpenDialog1: TOpenDialog;
    EfileType: TPanel;
    TestOrProductionGroup: TRadioGroup;
    CancelBtn: TBitBtn;
    Label7: TLabel;
    UrlBox: TEdit;
    PadInfoBtn: TButton;
    T183Btn: TButton;
    showPADXML: TButton;


    Function GetProdOrTest:String;
    Function MkSubmittedFileName(RetNo: Integer): String;
    Function MkResponseFileName(RetNo: Integer): String;


    Function SubmitPADSoapMsg(RetNo: Integer; SoapMsg: AnsiString;ProdOrTest: String;FlName: String):ansistring;
    Function CreatePADSoapMessage(RetNo: Integer;ProdOrTest: String):ANSISTRING;
    procedure PADbtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure testPADResponsebtnClick(Sender: TObject);
    Function parsePADResponse(RetNo: Integer; rString: AnsiString): string;
    Function CreatePadResponseHtm(RetNo:Integer;PADRec:APAD;HtmFile:String):string;
    procedure TestOrProductionGroupClick(Sender: TObject);
    Procedure GetUrl;
    procedure FormPaint(Sender: TObject);
    procedure PadInfoBtnClick(Sender: TObject);
    procedure T183BtnClick(Sender: TObject);
    procedure showPADXMLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  T1PadT1_2026: TT1PadT1_2026;

  RetNo: Integer;
  PadInfoFNo:Integer;  //20170210
  OnLineNo, PassWord, NetFileDir, { EolFileName, } Url, Refund: String;
  PadDir:String;  //20170207
  sUrl:String;
  ProdOrTest:String;
  PADRec: APAD;
  PADResponseRec: APADResponse;

implementation

uses
  vtTrimStr,    //for alltrim
  vtCommon,
  vtShowMessageHTML
;

{$R *.dfm}


Procedure TT1PadT1_2026.GetUrl;
Begin
  ProdOrTest:=GetProdOrTest;   //20170209
  If ProdOrTest = 'T' then  //20230121 for both
    sUrl := 'https://apps-ct.cra-arc.gc.ca/ebci/rjpt/epads_ws/services/PadService?wsdl'
     //'https://apps-ct.cra-arc.gc.ca/ebci/rjpt/epads_ws/services/PadCreateService?wsdl'
  Else
    sUrl :='https://apps.cra-arc.gc.ca/ebci/rjpt/epads_ws/services/PadService?wsdl';
     //'https://apps.cra-arc.gc.ca/ebci/rjpt/epads_ws/services/PadCreateService?wsdl' ;
  UrlBox.text:=Surl;
End;



Function TT1PadT1_2026.MkSubmittedFileName(RetNo: Integer): String;
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
  result:=PadDir+'\'+'PAD-ToBeSubmitted-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'; //20170207
 ////20170207  result := NetFileDir + '\' + RemoveChar(GetLastName(RetNo) + ' ' + GetFirstName(RetNo) + '-' + GetSinNo(RetNo) + '-Submitted', '.') + '.xml';
end;

procedure TT1PadT1_2026.FormCreate(Sender: TObject);
Var FNo:Integer;
begin
 //20200408
 TestOrProductionGroup.ItemIndex:=0;
 GetUrl;
 //----------------
 PadInfoFNo:=GetFormNo('PADINFO');
 PadDir:=AppDir+'\'+'PadEfile';  //PadDir:=AppDir+'\'+'Pad';  //20170208 9PM CON;
 If DirectoryExists(PadDir) = false then ForceDirectories(PadDir);

 //20161201
 RetNo:=GetCurrentRetNo;
 FNo:=GetFormNo('T185');   //20200212

 PaymentDateEdit.text:=FetchElmFNo(RetNo,FNo,15);
 PaymentAmountEdit.Text:=FetchElmFNo(RetNo,FNo,14);

 //20170210
 FinancialInstitutionNumberEdit.Text:=FetchElmFNo(RetNo,PADINFOFNo,1);
 FinancialInstitutionBranchNumberEdit.Text:=FetchElmFNo(RetNo,PADINFOFNo,2);
 FinancialInstitutionAccountNumberEdit.Text:=FetchElmFNo(RetNo,PADINFOFNo,3);

end;

procedure TT1PadT1_2026.FormPaint(Sender: TObject);
begin
 ProdOrTest:=GetProdOrTest; //20170209
end;

Function TT1PadT1_2026.MkResponseFileName(RetNo: Integer): String; // 20131218
begin
 //20170207
 result:=PadDir+'\'+'PAD-Response-'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo),'.')+'.xml'
end;

//PAD START -------------------------------------------------------------------------------------------------------------------------------------

procedure TT1PadT1_2026.PADbtnClick(Sender: TObject);
var
  SoapMsg,returnedPADResponse:ansistring;
  PADResponseFlName:string;
begin
  //20170209
  ProdOrTest:=GetProdOrTest;
  GetUrl;

  RetNo := GetCurrentRetNo;
  SoapMsg := CreatePADSoapMessage(RetNo, ProdOrTest);

  If SoapMsg = '' then
  Begin
    ShowMessage('No data available for submission');
    Exit;
  end;

  returnedPadResponse := SubmitPADSoapMsg(RetNo, SoapMsg, ProdOrTest, MkSubmittedFileName(RetNo));

  parsePADResponse(RetNo, returnedPadResponse);

  PADResponseFlName := CreatePADResponseHtm(RetNo, PADRec, AppDir + '\' + 'PADResponseTemplate.htm');

  If FileExists(PADResponseFlName) then
    ShellExecute(Self.Handle, nil, PChar('' + PADResponseFlName), nil, nil,SW_NORMAL);

end;

procedure TT1PadT1_2026.PadInfoBtnClick(Sender: TObject);
begin
 OpenForm(RetNo,GetFormNo('PADINFO'),0);
end;

Function TT1PadT1_2026.SubmitPADSoapMsg(RetNo: Integer; SoapMsg: AnsiString;ProdOrTest: String;FlName: String):ansistring;
Var
  objHttp: ixmlHttpRequest;
  WString: AnsiString; // wide string
  ResponseXmlFile: String;
  parsedXmlResponseWString: string;
  S: String;
  AList: TStringList;

Begin
  GetEOLParms(OnLineNo, PassWord, Url, NetFileDir);

  // define
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
  // open it
  objHttp.open('POST', sUrl, False, OnLineNo, PassWord); // 20110120

  objHttp.setRequestHeader('SOAPAction', 'NA'); // set action?
  objHttp.setRequestHeader('Content-Type', 'text/xml');

  // transmit it now
  Screen.Cursor := crHourGlass;


  //20180228 Igor >>>
  try
    objHttp.send(SoapMsg); // SEND SOAP MESSAGE
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
  Screen.Cursor := CrDefault;
  If TransmitDelay < 200 then
    TransmitDelay := 200;
  delay(TransmitDelay);
  Screen.Cursor := CrDefault;
  WString := objHttp.ResponseText;
  // Now save the WString
  ResponseXmlFile := MkResponseFileName(RetNo);
  AList := TStringList.Create;
  AList.Add(WString);
  AList.SaveToFile(ResponseXmlFile);
  AList.Free;

  // succesful transmission
  S := MkSubmittedFileName(RetNo);
  objHttp := Nil; // 20110129  .Free It is not accepted

  result := WString;

end;

procedure TT1PadT1_2026.T183BtnClick(Sender: TObject);
begin
 OpenForm(RetNo,GetFormNo('T183'),0);  //20170210
end;

procedure TT1PadT1_2026.TestOrProductionGroupClick(Sender: TObject);
begin
 ProdOrTest:=GetProdOrTest;    //20170209
 GetUrl;
end;

Function TT1PadT1_2026.GetProdOrTest:String;
begin
  If TestOrProductionGroup.ItemIndex=0 then //production
   Result:='P'
 else  //test
   Result:='T';
end;

procedure TT1PadT1_2026.testPADResponsebtnClick(Sender: TObject);
var
  tempResponseList: TStringList;
  PADResponseFlName: string;
begin
  OpenDialog1.FileName := '*Response*';
  OpenDialog1.InitialDir := 'C:\XE-WIP\2017\DISTRFL\T1-2017\PadEfile'; //NetFileDir;
  OpenDialog1.Filter := 'XML files (*.xml)|*.xml|' + 'Any (*.*)|*.*';
  If OpenDialog1.Execute then
  begin
    tempResponseList := TStringList.Create;
    tempResponseList.loadFromFile(OpenDialog1.FileName);

    parsePADResponse(RetNo, tempResponseList.Text);

    PADResponseFlName := CreatePADResponseHtm(RetNo, PADRec, AppDir + '\' + 'PADResponseTemplate.htm');

    If FileExists(PADResponseFlName) then
      ShellExecute(Self.Handle, nil, PChar('' + PADResponseFlName), nil, nil,SW_NORMAL);
  end;

end;

Function TT1PadT1_2026.parsePADResponse(RetNo: Integer; rString: AnsiString): string;

    function LTrimAnsi(Const S: AnsiString): AnsiString;
    var i: Integer; //      len: integer;
    begin
        i := 1;
        while s[i] = ' ' do inc(i);
        result := copy(s, i, length(s) - i + 1);
    end;

    function RTrimAnsi(S: AnsiString): AnsiString;
    var len: Integer;
    begin
        while s[length(s)] = ' ' do
                dec(s[1]); //dec(s[0]);
        result := s;
    end;

    function AllTrimAnsi(Str: AnsiString): AnsiString;
    begin
        Result := Str; exit; //not working??????????
        Result := LTrimAnsi(RTrimAnsi(Str));
    end; //Trim


    var
      i,sPos,ePos:integer;
      s,e,returnedColor,returnedStatus,returnedCode,returnedMessageString,returnedResultCode,returnedHyperLinkLink,returnedHyperLinkText,returnedPADConfirmationNumber:string;
      returnedErrorCode     : Array[0..3] of String[30];
      returnedErrorCodeText : Array[0..3] of String[255];
      rStringTrunc :ansistring;

begin
    //Fault error -------------------------------------------------------------
    s     := '<soapenv:Fault>';
    sPos := pos(s,rString);
    IF sPos > 0 then
    BEGIN
        returnedStatus  := 'Rejected - FaultError';
        returnedColor   := 'RED';

        s       := '<ns1:hostname xmlns:ns1="http://xml.apache.org/axis/">';
        e       := '</ns1:hostname>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedMessageString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        s       := '<faultcode>';
        e       := '</faultcode>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedErrorCode[1] := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        s       := '<faultstring>';
        e       := '</faultstring>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedErrorCodeText[1] := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
    END

    //SYSTEM error -------------------------------------------------------------
    ELSE IF pos('SystemError',rString) > 0 then
    BEGIN
        returnedStatus  := 'Rejected - SystemError';
        returnedColor   := 'RED';

        s       := '<padrsp:MessageText xml:lang="en">';
        e       := '</padrsp:MessageText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedMessageString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
    END
    //REJECTION error -------------------------------------------------------------
    ELSE IF pos('<padrsp:Rejection>',rString) > 0 then
    BEGIN
        returnedStatus := 'Rejected';
        returnedColor  := 'RED';

        s       := '<padrsp:MessageText xml:lang="en">';
        e       := '</padrsp:MessageText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedMessageString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        s       := '<padrsp:HyperlinkText>';
        e       := '</padrsp:HyperlinkText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedHyperLinkText := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));

        s       := '<padrsp:HyperlinkTargetText>';
        e       := '</padrsp:HyperlinkTargetText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedHyperLinkLink := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
    END
    //CONFIRMATION  -------------------------------------------------------------
    ELSE IF pos('<padrsp:Confirmation>',rString) > 0 then
    BEGIN
        returnedStatus := 'Accepted';
        returnedColor  := 'GREEN';

        s       := '<padrsp:ConfirmationNumber>';
        e       := '</padrsp:ConfirmationNumber>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedPADConfirmationNumber := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
        //20170721
        StoreElm(RetNo,'PADINFO',4, FormatDateTime('yyyy-mm-dd',Date)); //20170321
        StoreElm(RetNo,'PADINFO',5,returnedPADConfirmationNumber); //20170321
        ShowMessage('Save the return to capture the Confirmation number on the PDAInfo form');
        returnedPADConfirmationNumber := '<strong>Confirmation Number: </strong>' + returnedPADConfirmationNumber;

        s       := '<padrsp:MessageText xml:lang="en">';
        e       := '</padrsp:MessageText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedMessageString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));
    END
    //PROCESSING error -------------------------------------------------------------
    ELSE IF pos('<padrsp:ProcessingError>',rString) > 0 then
    BEGIN
        returnedStatus := 'Rejected - ProcessingError';
        returnedColor  := 'RED';

        s       := '<padrsp:MessageText xml:lang="en">';
        e       := '</padrsp:MessageText>';
        sPos    := pos(s,rString) + length(s);
        ePos    := pos(e,rString);
        returnedMessageString := AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));


        rStringTrunc := rString;
        s       := '<padrsp:ResponseCode>';
        e       := '</padrsp:ResponseCode>';
        for i := 0 to 3 do //do not use the first error
        begin
          //find if first tag exists //20170316
          sPos    := pos(s,rStringTrunc);
          if sPos > 0 then
          begin
            rStringTrunc := MidAnsiStr(rStringTrunc,sPos,length(rStringTrunc));

            sPos    := pos(s,rStringTrunc) + length(s);
            ePos    := pos(e,rStringTrunc);
            returnedErrorCode[i] := 'Error Code: ' + AllTrimAnsi(MidAnsiStr(rStringTrunc,sPos,ePos-sPos));

            rStringTrunc := MidAnsiStr(rStringTrunc,(ePos + length(e)),length(rStringTrunc));
          end
          else
            break;
        end; //for i

        rStringTrunc := rString;
        s       := '<padrsp:MessageText xml:lang="en">';
        e       := '</padrsp:MessageText>';
        for i := 0 to 3 do //do not use the first error
        begin
          //find if first tag exists //20170316
          sPos    := pos(s,rStringTrunc);
          if sPos > 0 then
          begin
            rStringTrunc := MidAnsiStr(rStringTrunc,sPos,length(rStringTrunc));

            sPos    := pos(s,rStringTrunc) + length(s);
            ePos    := pos(e,rStringTrunc);
            returnedErrorCodeText[i] := AllTrimAnsi(MidAnsiStr(rStringTrunc,sPos,ePos-sPos));

            rStringTrunc := MidAnsiStr(rStringTrunc,(ePos + length(e)),length(rStringTrunc));
          end
          else
            break;

        end; //for i
    END
    ELSE
    BEGIN
      showmessage('response not captured');
    END;

    //always look for resultCode //20170316
    s       := '<padrsp:ResponseCode>';
    e       := '</padrsp:ResponseCode>';
    sPos    := pos(s,rString) + length(s);
    ePos    := pos(e,rString);
    returnedResultCode := 'Result Code: ' + AllTrimAnsi(MidAnsiStr(rString,sPos,ePos-sPos));


    with PADResponseRec do
    begin
      DateTimeReceived        := FormatDateTime('yyyy-mm-dd',Date) + ' ' + GetTimeToMilliSec(Date);

      status                  := returnedStatus;
      statusColor             := returnedColor;

      resultCode              := returnedResultCode;
      messageText             := returnedMessageString;
      hyperLinkLink           := returnedHyperLinkLink;
      hyperLinkText           := returnedHyperLinkText;
      ConfirmationNumber      := returnedPADConfirmationNumber;

      For i := 1 to 3 do
      begin
        errorCode[i]               := returnedErrorCode[i];
        errorCodeText[i]           := returnedErrorCodeText[i];
      end;


    end;
end;


procedure TT1PadT1_2026.showPADXMLClick(Sender: TObject);
var
  FlName : string;
begin

  ProdOrTest:=GetProdOrTest;
  GetUrl;

  RetNo := GetCurrentRetNo;
  SoapMsg := CreatePADSoapMessage(RetNo, ProdOrTest);

  FlName := MkSubmittedFileName(RetNo);

  if not FileExists(FlName) then
    ShowMessage('File '+ FlName +'not found')
  else
    ShowMessageHTMLFromFile(FlName);
end;

function TT1PadT1_2026.CreatePadResponseHtm(RetNo:Integer;PADRec:APAD;HtmFile:String):string;
var
 htmlSource:TStringList;
 sString,source,flName:string;
 OnLineNo,PassWord,Url,NetFileDir:String;
 i,j,k,s,startPos,itemNumTemp:integer;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 htmlSource:=TStringList.Create;
 htmlSource.LoadFromFile(HtmFile);


 For i := 0 to htmlSource.Count-1 do
 begin

  sString := '!Status!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.Status,[rfReplaceAll, rfIgnoreCase]);

  sString := '!StatusColor!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.statusColor,[rfReplaceAll, rfIgnoreCase]);

  sString := '!Client!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADRec.GivenName+' '+PADRec.FamilyName,[rfReplaceAll, rfIgnoreCase]);

  sString := '!Received!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
        htmlSource[i] := StringReplace(htmlSource[i], sString, 'Received: ' + PADResponseRec.DateTimeReceived,[rfReplaceAll, rfIgnoreCase]);

  sString := '!ResultCode!';          //20140219
  startPos := pos(sString, htmlSource[i]);
  if (startPos > 0) then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.ResultCode,[rfReplaceAll, rfIgnoreCase]);

  sString := '!Description!'; //'!Description!';    //20150128
  startPos := pos(sString, htmlSource[i]);
  if (startPos > 0) then
      htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.messageText,[rfReplaceAll, rfIgnoreCase]); //htmlSource[i] := StringReplace(htmlSource[i], sString, GetWebServiceErrorDescr(AckRec.ResultCode),[rfReplaceAll, rfIgnoreCase]);

  sString := '!ConfirmationNumber!'; //'!Description!';    //20150128
  startPos := pos(sString, htmlSource[i]);
  if (startPos > 0) then
      htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.ConfirmationNumber,[rfReplaceAll, rfIgnoreCase]); //htmlSource[i] := StringReplace(htmlSource[i], sString, GetWebServiceErrorDescr(AckRec.ResultCode),[rfReplaceAll, rfIgnoreCase]);

  sString := '!HyperLinkText!'; //'!Description!';    //20150128
  startPos := pos(sString, htmlSource[i]);
  if (startPos > 0) then
      htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.hyperLinkText,[rfReplaceAll, rfIgnoreCase]); //htmlSource[i] := StringReplace(htmlSource[i], sString, GetWebServiceErrorDescr(AckRec.ResultCode),[rfReplaceAll, rfIgnoreCase]);

  sString := '!HyperLinkLink!'; //'!Description!';    //20150128
  startPos := pos(sString, htmlSource[i]);
  if (startPos > 0) then
      htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.hyperLinkLink,[rfReplaceAll, rfIgnoreCase]); //htmlSource[i] := StringReplace(htmlSource[i], sString, GetWebServiceErrorDescr(AckRec.ResultCode),[rfReplaceAll, rfIgnoreCase]);

  //----------------------------------------------------------------

  //tax return error codes
  sString := '!ErrorCode1!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.ErrorCode[1],[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorCode2!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.ErrorCode[2],[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorCode3!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0
    then htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.ErrorCode[3],[rfReplaceAll, rfIgnoreCase]);

  ////20152801 Error descriptions code not coming from the EfErrors.dbf anymore
  sString := '!ErrorMessage1!';
  startPos := pos(sString, htmlSource[i]);
  if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.errorCodeText[1],[rfReplaceAll, rfIgnoreCase]); //htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[1]),[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorMessage2!';
  startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.errorCodeText[2],[rfReplaceAll, rfIgnoreCase]); //    htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[2]),[rfReplaceAll, rfIgnoreCase]);

  sString := '!ErrorMessage3!';
  startPos := pos(sString, htmlSource[i]);
   if  startPos > 0 then
    htmlSource[i] := StringReplace(htmlSource[i], sString, PADResponseRec.errorCodeText[3],[rfReplaceAll, rfIgnoreCase]); //    htmlSource[i] := StringReplace(htmlSource[i], sString, GetEfErrorDescr(AckRec.ErrorCode[3]),[rfReplaceAll, rfIgnoreCase]);

 end;


//20170208 9PM CON
 flName := PADDir+'\'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo)+'-PADAck','.')+'.htm';
 //flName := AppDir+'\'+'PAD' +'\'+RemoveChar(GetLastName(RetNo)+' '+GetFirstName(RetNo)+'-'+GetSinNo(RetNo)+'-T1135Ack','.')+'.htm';

 if not directoryexists(ExtractFilePath(flName)) then
 begin
    if not CreateDir(ExtractFilePath(flName)) then
      ShowMessage('New directory ' +ExtractFilePath(flName)+ ' creation failed with error : '+IntToStr(GetLastError));
 end;

 htmlSource.SaveToFile(flName);

 result := flName;
 htmlSource.Free;
end;

Function TT1PadT1_2026.CreatePADSoapMessage(RetNo: Integer;ProdOrTest: String):ANSISTRING;

  Var
  i:Integer;
  XmlPADList : Tstringlist;

  procedure PreparePADRec(RetNo: Integer);
  begin
    with PADRec do
    begin
      Developer                         := DeveloperId;   //20170208
      SoftCode                          := PadSoftCode; //CodeSuffix;  //20170208
      SoftRelease                       := EfileSoftReleaseDate; //20231221 SoftwareReleaseDate; // SOFTRELEASEDate;  //20170208
      SIN                               := RemoveHyphens(FetchElm(RetNo,'INFO',3));
      givenName                         := GetFirstName(RetNo);
      familyName                        := GetLastName(RetNo);
      PaymentDate                       := PaymentDateEdit.text;
      PaymentAmount                     := PaymentAmountEdit.text;
      FinancialInstitutionNumber        := FinancialInstitutionNumberEdit.text;
      FinancialInstitutionBranchNumber  := FinancialInstitutionBranchNumberEdit.text;
      FinancialInstitutionAccountNumber := FinancialInstitutionAccountNumberEdit.text;
    end;
  end;

begin
  SoapMsg := ''; //20170315 Igor
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);    //20110120
  PreparePADRec(RetNo);

  XmlPADList := TStringList.Create;

  With XmlPADList do
  Begin
    Add('<soap-env:Envelope');
    Add('xmlns="http://www.cra-arc.gc.ca/xmlns/padrq/request/1-0-0"');
    Add('xmlns:soap-env="http://schemas.xmlsoap.org/soap/envelope/"');
    Add('xmlns:padrq="http://www.cra-arc.gc.ca/xmlns/padrq/request/1-0-0"');
    Add('xmlns:pad="http://www.cra-arc.gc.ca/xmlns/pad/1-0-0">');
    Add('  <soap-env:Body>');
    Add('    <padrq:PadCreateRequest>');
    Add('            <padrq:TransmitterEfilerNumber>' + OnLineNo + '</padrq:TransmitterEfilerNumber>');
    Add('            <padrq:PasswordIdentifier>' + PassWord + '</padrq:PasswordIdentifier>');
    Add('            <padrq:SoftwareIdentifier>' + PADRec.Developer + PADRec.SoftCode + '</padrq:SoftwareIdentifier>');
    Add('            <padrq:SoftwareRevisionDate>' + PADRec.SoftRelease + '</padrq:SoftwareRevisionDate>');
    Add('            <padrq:TaxpayerSocialInsuranceNumber>' + PADRec.SIN + '</padrq:TaxpayerSocialInsuranceNumber>');
    Add('            <padrq:PadCreateDetail>');
    Add('                <pad:T1PaymentOnFiling>');
    Add('                    <pad:PaymentDate>' + PADRec.PaymentDate + '</pad:PaymentDate>');
    Add('                    <pad:PaymentAmount>' + PADRec.PaymentAmount + '</pad:PaymentAmount>');
    Add('                    <pad:BankingInformation>');
    Add('                        <pad:FinancialInstitutionNumber>' + PADRec.FinancialInstitutionNumber + '</pad:FinancialInstitutionNumber>');
    Add('                        <pad:FinancialInstitutionBranchNumber>' + PADRec.FinancialInstitutionBranchNumber + '</pad:FinancialInstitutionBranchNumber>');
    Add('                        <pad:FinancialInstitutionAccountNumber>' + PADRec.FinancialInstitutionAccountNumber + '</pad:FinancialInstitutionAccountNumber>');
    Add('                    </pad:BankingInformation>');
    Add('                </pad:T1PaymentOnFiling>');
    Add('            </padrq:PadCreateDetail>');
    Add('    </padrq:PadCreateRequest>');
    Add('</soap-env:Body>');
    Add('</soap-env:Envelope>');
  end;

  For i := 0 to XmlPADList.count - 1 do
    SoapMsg := SoapMsg + AllTrim(XmlPADList[i]) + Chr(13);   //alltrim //20170207

  XmlPADList.SaveToFile(MkSubmittedFileName(RetNo));
  XmlPADList.Free;

  result := SoapMsg;
end;
//PAD END -------------------------------------------------------------------------------------------------------------------------------------

end.
