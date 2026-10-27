unit T1_2026SERS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, System.IOUtils,
  Vcl.Grids, System.Generics.Collections, T1_2026SERSAddFile, IdSNTP, IdGlobal, IdHashSHA,
  IdCoderMIME, IdSSLOpenSSL, DateUtils, Crypt2, TXPCrypto, StrUtils, Math, //20260427 Alex
  EncdDecd, Xml.XMLDoc, Xml.XMLIntf, MSXML2_TLB, ComObj, System.RegularExpressions,
  Vcl.ComCtrls, IdGlobalProtocols, vtDynData;

const
  c_ProdDomain = 'https://apps.cra-arc.gc.ca';
  c_TestDomain = 'https://apps-ct.cra-arc.gc.ca';

  c_RequestDACUrl    = '/ebci/sres/ws/api/sersnet/requestDac';
  c_RequestUHTDACUrl = '/ebci/sres/ws/api/sersnet/requestUhtDac';
  c_FileReturnUrl    = '/ebci/sres/ws/api/sersnet/fileReturn';
  c_FileUHTReturnUrl = '/ebci/sres/ws/api/sersnet/fileUhtReturn';
  c_AttachDocsUrl    = '/ebci/sres/ws/api/sersnet/attachDocs';

  EOL = #13#10;

  MaxFiles = 10;
  MaxTotalSize = 150 * 1024 * 1024;

type TResponse = record
  Success: boolean;
  ReturnCode: integer;
  Description: string;
  Text: string;
  ErrorReason: string;
  ErrorReasonDescription: string;
  ErrorReasonText: string;
end;

type TFileRecord = record
  FileName: string;
  DocType: integer;
  FileSize: int64;
end;

type
  TfrmSERS2025 = class(TForm)
    Panel6: TPanel;
    pContentContainer: TPanel;
    pgSubmittedFiles: TPageControl;
    DACSheet: TTabSheet;
    DACSubmittedPanel: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    DACReceivedButton: TSpeedButton;
    DACSubmittedEdit: TEdit;
    DACReceivedEdit: TEdit;
    DACReceivedHTMLEdit: TEdit;
    UHTDACSheet: TTabSheet;
    Panel2: TPanel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    UHTDACReceivedButton: TSpeedButton;
    UHTDACSubmittedEdit: TEdit;
    UHTDACReceivedEdit: TEdit;
    UHTDACReceivedHTMLEdit: TEdit;
    FileReturnSheet: TTabSheet;
    Panel3: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    FileReturnReceivedButton: TSpeedButton;
    FileReturnSubmittedEdit: TEdit;
    FileReturnReceivedEdit: TEdit;
    FileReturnReceivedHTMLEdit: TEdit;
    UHTFileReturn: TTabSheet;
    Panel4: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    FileUHTReturnReceivedButton: TSpeedButton;
    FileUHTReturnSubmittedEdit: TEdit;
    FileUHTReturnReceivedEdit: TEdit;
    FileUHTReturnReceivedHTMLEdit: TEdit;
    AttachDocsSheet: TTabSheet;
    Panel5: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    AttachDocsReceivedButton: TSpeedButton;
    AttachDocsSubmittedEdit: TEdit;
    AttachDocsReceivedEdit: TEdit;
    AttachDocsReceivedHTMLEdit: TEdit;
    mHelp: TMemo;
    pcMain: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label26: TLabel;
    Panel7: TPanel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    lBNOnAttachFilesPage: TLabel;
    Label30: TLabel;
    lForrmTypeOnAttachFilesPage: TLabel;
    Label31: TLabel;
    lConfNumberOnAttachFilesPage: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    grFiles: TStringGrid;
    pnlBottom: TPanel;
    Label6: TLabel;
    lbTotal: TLabel;
    Label8: TLabel;
    lbRemaining: TLabel;
    Label10: TLabel;
    lbRemainingNumber: TLabel;
    btnAttach: TBitBtn;
    btnDetach: TBitBtn;
    btnSubmit: TBitBtn;
    pnlDevelopment: TPanel;
    ProductionOrTestGroup: TRadioGroup;
    URLForWebServices: TEdit;
    pnlTop: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label25: TLabel;
    edNumber: TEdit;
    edFormType: TEdit;
    edConfirmationNumber: TEdit;
    SubmitFileReturnButton: TBitBtn;
    edFormSequenceNumber: TEdit;
    edPCode: TEdit;
    Panel1: TPanel;
    Panel8: TPanel;
    rbUseDACAuth: TRadioButton;
    rbUseEfilerNumPassAuth: TRadioButton;
    GetDACButton: TBitBtn;
    Label4: TLabel;
    edDAC: TEdit;
    Label34: TLabel;
    eAuthEfilerNum: TEdit;
    eAuthPassword: TEdit;
    Label35: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAttachClick(Sender: TObject);
    procedure btnDetachClick(Sender: TObject);
    procedure btnSubmitClick(Sender: TObject);
    procedure btnViewHTMLClick(Sender: TObject);
    procedure ProductionOrTestGroupClick(Sender: TObject);
    procedure GetDACButtonClick(Sender: TObject);
    procedure SubmitFileReturnButtonClick(Sender: TObject);
    // 20250703 Igor >>>
    procedure ForHelpOnMouseLeave(Sender: TObject);
    procedure ForHelpOnMouseEnter(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    // 20250703 Igor <<<
    procedure rbUseDACAuthClick(Sender: TObject); // 20250729 Igor
    procedure rbUseEfilerNumPassAuthClick(Sender: TObject);
    procedure eAuthEfilerNumChange(Sender: TObject);
    procedure eAuthPasswordChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); // 20250729 Igor
  private
    FXMLList: TStringList;
    FFieldList: TStringList;
    OnlineNo: string;
    Password: string;
    Url: string;
    NetFileDir: string;
    FRetNo: integer;
    FFormType: string;
    TotalSize: int64;
    RemainingSize: int64;
    Files: TList<TFileRecord>;
    SoapMessage: string;
    Response: TResponse;
    FEDocsDir: string;
    FIsUHT: boolean;
    FCorporationName: string; // 20250625 Igor
    FIsBNConfirmed: Boolean; // 20250709 Igor
    isUserSelectedFilesAttaching: Boolean; //20260427 Alex

    procedure RebuildGrid;
    procedure InitFileNames;
    function AddFile(ADocumentType: integer; AFileName: string): boolean;
    function ParseResponse(AResponse: string): TResponse;
    procedure ShowHTML(AResponse: TResponse; AFileName: string);
    function GetSubmittedFileName(AType: string): string;
    function GetReceivedFileName(AType: string): string;
    function GetReceivedHTMLFileName(AType: string): string;
    function GetRequestDACUrl: string;
    function GetFileReturnUrl: string;
    function GetAttachDocsUrl: string;
    function GetRequestDACSubmittedFileName: string;
    function GetRequestDACReceivedFileName: string;
    function GetRequestDACReceivedHTMLFileName: string;
    function GetFileReturnReceivedFileName: string;
    function GetFileReturnReceivedHTMLFileName: string;
    function GetFileReturnSubmittedFileName: string;
    function GetAttachDocsReceivedFileName: string;
    function GetAttachDocsReceivedHTMLFileName: string;
    function GetAttachDocsSubmittedFileName: string;
    procedure SetFormType(const Value: string);
    function GetBasicAuthorization(AUserName, APassword: string): string;
    function GetFormNumber: string;
    function GetAttachDocsRequest: string;
    function CreateXML: boolean;
    procedure Init;
    procedure InitFormParams;
    function GetSoftwareCode: string;
    function GetShortFormName: string;
    function CreateDACXML: boolean;
    procedure AddBeginTagwithValue(AIndent: integer; AName, AValue: string);
    procedure AddBeginTag(AIndent: integer; AName: string);
    procedure AddEndTag(AIndent: integer; AName: string);
    procedure AddTag(AIndent: integer; AName, AValue: string);
    function GetTaxYear: string;
    function GetLastName: string;
    function GetConfirmNumber: integer;
    procedure HelpObjectDescription(Sender: TObject); // 20250703 Igor
    procedure ShowEDocHTML(AResponse: TResponse; AFileName: string); // 20250709 Igor
  protected
    property ShortFormName: string read GetShortFormName;
    property SoftwareCode: string read GetSoftwareCode;
    property FormNumber: string read GetFormNumber;
    property TaxYear: string read GetTaxYear;
    property LastName: string read GetLastName;
    property ConfirmNumber: integer read GetConfirmNumber;
  public
    { Public declarations }
    property FormType: string read FFormType write SetFormType;
    property IsUHT: boolean read FIsUHT;

    property RequestDACUrl: string read GetRequestDACUrl;
    property FileReturnUrl: string read GetFileReturnUrl;
    property AttachDocsUrl: string read GetAttachDocsUrl;

    property RequestDACSubmittedFileName: string read GetRequestDACSubmittedFileName;
    property RequestDACReceivedFileName: string read GetRequestDACReceivedFileName;
    property RequestDACReceivedHTMLFileName: string read GetRequestDACReceivedHTMLFileName;

    property FileReturnSubmittedFileName: string read GetFileReturnSubmittedFileName;
    property FileReturnReceivedFileName: string read GetFileReturnReceivedFileName;
    property FileReturnReceivedHTMLFileName: string read GetFileReturnReceivedHTMLFileName;

    property AttachDocsSubmittedFileName: string read GetAttachDocsSubmittedFileName;
    property AttachDocsReceivedFileName: string read GetAttachDocsReceivedFileName;
    property AttachDocsReceivedHTMLFileName: string read GetAttachDocsReceivedHTMLFileName;

    property RetNo: integer read FRetNo;
    property CorporationName: string read FCorporationName; // 20250625 Igor
    property IsBNConfirmed: Boolean read FIsBNConfirmed; // 20250709 Igor
  end;

  procedure RunSERS(AFormType: string);

implementation

uses
  T1_2026TrimStr, vtCommon, vtShowMessageHTML, vtTrimStr, vtMulti, T1_2026, T1_2026Declare;

{$R *.DFM}

const
 indent = 3;
 indentM = 6;
 indentMM = 9;
 indentMMM = 12;
 indentMMMM = 15;
 indentMMMMM = 18;

var
 SERSTestMode:boolean;

function ReplaceSpecialChar(info: String): String;
begin
  info := ReplaceChar(info, '&', '&amp;');
  info := ReplaceChar(info, '<', '&lt;');
  info := ReplaceChar(info, '"', '&quot;');
  info := ReplaceChar(info, '>', '&gt;');
  info := ReplaceChar(info, '''', '&apos;');
  result := info;
end;

function ClearXML(AXML: String): string;
begin
  Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;

procedure SaveToFile(AText: string; AFileName: string);
var L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Text := AText;
    L.SaveToFile(AFileName);
  finally
    L.Free;
  end;
end;

procedure RunSERS(AFormType: string);
var
  FSERST1_2026: TfrmSERS2025;
  OnlineNo, Password, Url, NetFileDir: string;
begin
  AFormType := UpperCase(AFormType);
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  if (OnlineNo = '') or (Password = '') or (NetFileDir = '') then
  begin
    showmessage('Please enter and save the Internet Filing Parameters before attempting to submit SERS');
    Exit;
  end;

  FSERST1_2026 := TfrmSERS2025.Create(Screen.ActiveForm);
  try
    FSERST1_2026.FormType := AFormType;
    FSERST1_2026.ShowModal;
  finally
    FSERST1_2026.Free;
  end;
end;

function GetFileBase64(AFileName: string): string;
var
  Encoder: TIdEncoderMIME;
  Base64String: String;
  FStream: TFileStream;
begin
  Encoder := TIdEncoderMIME.Create;
  FStream := TFileStream.Create(AFilename, fmOpenRead);
  try
    Result := Encoder.Encode(FStream);
  finally
    FreeAndNil(Encoder);
    FreeAndNil(FStream);
  end;
end;

function GetFileSize(FileName: string): TLargeInteger;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(FileName, faAnyFile, SearchRec) = 0 then
  begin
    Result := SearchRec.Size;
    FindClose(SearchRec);
  end
  else
    Result := -1;
end;

procedure TfrmSERS2025.AddBeginTag(AIndent: integer; AName: string);
begin
  FXMLList.Add(Space(AIndent) + '<'+ AName +'>');
end;

procedure TfrmSERS2025.AddBeginTagwithValue(AIndent: integer; AName, AValue: string);
begin
  FXMLList.Add(Space(AIndent) + '<'+ AName + ' ' + AValue + '>');
end;

procedure TfrmSERS2025.AddEndTag(AIndent: integer; AName: string);
begin
  FXMLList.Add(Space(AIndent) + '</'+ AName +'>');
end;

function TfrmSERS2025.AddFile(ADocumentType: integer; AFileName: string): boolean;
var
  nSize: int64;
  F: TFileRecord;
  I: integer;
  LMessage: string;
begin
  Result := False;
  LMessage := '';

  if not FileExists(AFileName) then
  begin
    ShowMessage('File '+ QuotedStr(AFileName) + ' does not exists');
    Exit;
  end;

  if FormNumber = '0217' then
  begin
    if ADocumentType = 0 then
      LMessage := 'Invalid Document Type for T217 (01: Director’s Resolution)'
    else if ADocumentType = 1 then
      LMessage := 'Invalid Document Type for T217 (02: Financial Notes)';
  end
  else if FormNumber = '0089' then
  begin
    if ADocumentType = 0 then
      LMessage := 'Invalid Document Type for Sch 89 (01: Director’s Resolution)'
    else if ADocumentType = 1 then
      LMessage := 'Invalid Document Type for Sch 89 (02: Financial Notes)';
  end;

  if not LMessage.IsEmpty then
  begin
    ShowMessage(LMessage);
    Exit;
  end;

  nSize := GetFileSize(AFileName);
  if nSize > RemainingSize then
  begin
    ShowMessage('Total file size with new file will be '+
                Format('%.2f', [(nSize + TotalSize) / 1024 / 1024])+' Mb. '+
                'File cannot be attached');
    Exit;
  end;
  for I := 0 to Files.Count - 1 do
    if SameText(ExtractFileName(Files[I].FileName), ExtractFileName(AFileName)) then
    begin
      ShowMessage('You have already added file with the same name');
      Exit;
    end;
  F.FileName := AFileName;
  F.DocType := ADocumentType;
  F.FileSize := nSize;
  Files.Add(F);
  RebuildGrid;
  Result := true;
end;

procedure TfrmSERS2025.AddTag(AIndent: integer; AName, AValue: string);
begin
  if SameText(Trim(AName), '') then
    Exit;
  if SameText(Trim(AValue), '') then
    FXMLList.Add(Space(AIndent) + '<'+ AName +'/>')
  else
    FXMLList.Add(Space(AIndent) + '<'+ AName +'>' + ReplaceSpecialChar(AValue) + '</'+ AName +'>');
end;

procedure TfrmSERS2025.SubmitFileReturnButtonClick(Sender: TObject);
var
  objHttp: IXMLHTTPRequest;
  LResponse: String;
  ResponseXmlFile: String;
  ConfirmNumber: string;
  Response: TResponse;
  lUserResponse: Integer; // 20250703 Igor
begin
  // 20250627 Igor >>>
  if rbUseDACAuth.Checked and (edDAC.Text = '') then // 20250729 Igor
  begin
    ShowMessage('First you need to get a Digital Access Code (DAC number).');
    Exit;
  end;
  // 20250627 Igor <<<

  CreateXML;
  objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
  Screen.Cursor := crHourGlass;
  try
    ObjHTTP.open('POST', FileReturnUrl, False, '', '');
    ObjHTTP.setRequestHeader('Content-Type','application/xml');
    objHttp.setRequestHeader('Authorization', 'Basic ' + IfThen(edDAC.Text = '', GetBasicAuthorization(OnLineNo, Password), GetBasicAuthorization(edDAC.Text, '')));
    FXMLList.SaveToFile(FileReturnSubmittedFileName);
    ObjHTTP.send(FXMLList.Text);
    delay(2000);
    LResponse := objHttp.ResponseText;
    SaveToFile(LResponse, FileReturnReceivedFileName);
    Response := ParseResponse(LResponse);
    ShowHTML(Response, FileReturnReceivedHTMLFileName);
    InitFileNames;
    RebuildGrid;

    // 20260427 Alex >>>
    if (Response.Success){ and (edFormType.Text = 'T2054')} then //20260427 Alex
    begin
      //lUserResponse:= MessageDlg('Do you want to submit the supporting documentation electronically?', mtConfirmation, [mbYes, mbNo], 0); //20260427 Alex
      lUserResponse:= MessageDlg('Do you require supporting documentation to be attached?', mtConfirmation, [mbYes, mbNo], 0); //20260427 Alex
      if lUserResponse = mrYes then
      begin
        lUserResponse:= MessageDlg('You have selected "Yes" to the question:'                            + EOL + EOL +
                                   '"Do you require supporting documentation to be attached?"'           + EOL + EOL +
                                   'Do you want to submit the supporting documentation electronically?'  + EOL + EOL +
                                   'If yes, you must attach the required documents now.', mtConfirmation, [mbYes, mbNo], 0); //20260427 Alex
        if lUserResponse = mrYes then
        begin
          pcMain.TabIndex:= 2;

          lBNOnAttachFilesPage.Caption:= edNumber.Text;
          lForrmTypeOnAttachFilesPage.Caption:= edFormType.Text;
          lConfNumberOnAttachFilesPage.Caption:= edConfirmationNumber.Text;
          isUserSelectedFilesAttaching:= True;
        end;
      end;
    end;
    // 20260427 Alex <<<
    if btnSubmit.Enabled then
      btnSubmitClick(nil);
    OpenForm(RetNo, FFormType, 0);
    // 20260427 Alex >>>
    if not SERSTestMode then
    begin
      if FileExists(FileReturnSubmittedFileName) then DeleteFile(FileReturnSubmittedFileName);
      if FileExists(FileReturnReceivedFileName)  then DeleteFile(FileReturnReceivedFileName);
    end;
    // 20260427 Alex <<<
  finally
    objHttp := nil;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmSERS2025.btnAttachClick(Sender: TObject);
begin
  RunSERSAddFile(FormType, FRetNo, RemainingSize, AddFile);
end;

procedure TfrmSERS2025.btnDetachClick(Sender: TObject);
var I: integer;
begin
  I := grFiles.Selection.Top - 1;
  if (I < 0) or (I + 1 > Files.Count) then
    raise Exception.Create('Error occured while calculating files index');
  if MessageDlg('Are you sure you want to detach '+ QuotedStr(ExtractFileName(Files[I].FileName)) +'?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;
  Files.Delete(I);
  RebuildGrid;
end;

procedure TfrmSERS2025.btnSubmitClick(Sender: TObject);
var
  Boundary, ContentID, ResponseXML, CurrFileName: string;
  MStrm: TMemoryStream;
  FStrm: TFileStream;
  objHttp: IXMLHTTPRequest;
  Buf: TArray<Byte>;
  I: integer;

  procedure WriteStringToStream(AStream: TMemoryStream; AText: String);
  var cText: AnsiString;
  begin
    cText := AText;
    AStream.Write(cText[1], Length(cText));
  end;

begin
  // 20250703 Igor >>>
  if rbUseDACAuth.Checked and (edDAC.Text = '') then // 20250729 Igor
  begin
    ShowMessage('First you need to get Digital Access Code.');
    Exit;
  end;

  if edConfirmationNumber.Text = '' then
  begin
    ShowMessage('First you need to get Confirmation Number.');
    Exit;
  end;

  if Files.Count = 0 then
  begin
    ShowMessage('First you need to attach a file.');
    Exit;
  end;
  // 20250703 Igor <<<

  if edDAC.Text = '' then
  begin
    if Length(OnLineNo) < 5 then
    begin
      //ShowMessage('Invalid Efiler ID. Efiler ID must be 5 characters');
      ShowMessage('According to CRA''s records, the EFILE number provided is not valid. Contact CRA''s T1 EFILE Helpdesk Support for further information.');
      Exit;
    end;

    if Length(Password) < 7 then
    begin
      //ShowMessage('Invalid Efiler Password. Efiler Password must be 7 characters');
      ShowMessage('According to CRA''s records, the EFILE password provided is not valid. Contact CRA''s T1 EFILE Helpdesk Support for further information.');
      Exit;
    end;
  end;

//  ShowMessage('Number of SERs Attachments does not match number of file names provided!');
//  Exit;

  Boundary := '----PART637009425006238352';
//  Boundary := '----=_Part_38_113729151.1667315483004'; // 20250626 Igor

  MStrm := TMemoryStream.Create;
  try
    WriteStringToStream(MStrm, '--' + Boundary + EOL);
    WriteStringToStream(MStrm, 'Content-Type: multipart/form-data' + EOL);
    WriteStringToStream(MStrm, 'Content-Transfer-Encoding: 8bit'   + EOL);

    WriteStringToStream(MStrm, EOL + EOL);

    WriteStringToStream(MStrm, GetAttachDocsRequest + EOL);

    for I := 0 to Files.Count - 1 do
    begin
      CurrFileName := ExtractFileName(Files[I].FileName);

      WriteStringToStream(MStrm, EOL + '--' + Boundary + EOL);
      WriteStringToStream(MStrm, 'Content-Type: ' + GetMIMETypeFromFile(CurrFileName) + '; charset=Cp1252; name=' + CurrFileName +EOL); // 20250626 Igor
      WriteStringToStream(MStrm, 'Content-Transfer-Encoding: binary' + EOL);
      WriteStringToStream(MStrm, 'Content-Disposition: form-data; name="'+ CurrFileName +'"; filename="'+ CurrFileName +'"' + EOL);
      WriteStringToStream(MStrm, EOL);

      begin
        FStrm := TFileStream.Create(Files[I].FileName, fmOpenRead);
        try
          SetLength(Buf, FStrm.Size);
          FStrm.Position := 0;
          FStrm.ReadBuffer(Buf, FStrm.Size);
          MStrm.WriteBuffer(Buf, Length(Buf));
        finally
          FStrm.Free;
        end;
      end;
    end;

    WriteStringToStream(MStrm, EOL + '--' + Boundary + '--' + EOL);
    WriteStringToStream(MStrm, EOL);

    MStrm.SaveToFile(AttachDocsSubmittedFileName);

    objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;

    objHttp.open('POST', AttachDocsUrl, False, '', '');
    objHttp.setRequestHeader('Authorization', 'Basic ' + IfThen(edDAC.Text = '', GetBasicAuthorization(OnLineNo, Password), GetBasicAuthorization(edDAC.Text, '')));
    objHttp.setRequestHeader('Content-Type', 'multipart/form-data; boundary="'+ Boundary +'"');

    SetLength(Buf, Mstrm.Size);
    MStrm.Position := 0;
    Mstrm.ReadBuffer(Buf, Mstrm.Size);

    objHttp.send(Buf);
    ResponseXML := objHttp.ResponseText;

    SaveToFile(ResponseXML, AttachDocsReceivedFileName);

    //Test appendix D/B
    //ResponseXML:= '<?xml version="1.0" encoding="UTF-8"?>';
    //ResponseXML:= ResponseXML + '<AttachDocsResponse xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" xmlns:ns0="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0">';
    //ResponseXML:= ResponseXML + '<Error>';
    //Test 1. Get the CRA error code 1435
    //ResponseXML:= ResponseXML + '<ns0:ErrorId>1435</ns0:ErrorId>';
    //ResponseXML:= ResponseXML + '<ns0:ErrorEnglishDesc>The number of SER E-Attachments does not match the number of file names provided. To better identify the source of this problem, contact your software vendor.</ns0:ErrorEnglishDesc>';
    //ResponseXML:= ResponseXML + '</Error>';
    //ResponseXML:= ResponseXML + '</AttachDocsResponse>';

    Response := ParseResponse(ResponseXML);
    ShowEDocHTML(Response, AttachDocsReceivedHTMLFileName);
    InitFileNames;

    // 20260427 Alex >>>
    if not SERSTestMode then
    begin
      if FileExists(AttachDocsSubmittedFileName) then DeleteFile(AttachDocsSubmittedFileName);
      if FileExists(AttachDocsReceivedFileName)  then DeleteFile(AttachDocsReceivedFileName);
    end;
    // 20260427 Alex <<<
  finally
    isUserSelectedFilesAttaching:= False;
    MStrm.Free;
  end;
end;

procedure TfrmSERS2025.btnViewHTMLClick(Sender: TObject);
var L: TStringList;
    LFileName: string;
begin
  if Sender = DACReceivedButton then
    LFileName := DACReceivedHTMLEdit.Text
  else if Sender = UHTDACReceivedButton then
    LFileName := UHTDACReceivedHTMLEdit.Text
  else if Sender = FileReturnReceivedButton then
    LFileName := FileReturnReceivedHTMLEdit.Text
  else if Sender = FileUHTReturnReceivedButton then
    LFileName := FileUHTReturnReceivedHTMLEdit.Text
  else if Sender = AttachDocsReceivedButton then
    LFileName := AttachDocsReceivedHTMLEdit.Text
  else
    Exit;
  if FileExists(LFileName) then
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(LFileName);
      ShowMessageHTML(L.Text, 600);
    finally
      L.Free;
    end;
  end;
end;

function TfrmSERS2025.CreateDACXML: boolean;
begin
  FXMLList.Clear;
  AddBeginTagwithValue(0, 'DacRequest', 'xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" xmlns:common="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0"');
  AddTag(indent, 'common:SoftwareCode', SoftwareCode);
  if FormNumber = '2900' then
    AddTag(indent, 'common:TaxYear', FetchElm(RetNo, FormType, 2))
  else
    AddTag(indent, 'common:TaxYear', CurrentApp.AppYear);
  AddTag(indent, 'common:ClientId', edNumber.Text);
  AddBeginTag(indent, 'SharedSecrets');
  //20260413 Igor >>>
  AddBeginTag(indentM, 'SinEntity');
  AddTag(indentMM, 'FirstName', FetchElm(FRetNo, 'INFO', 2));
  AddTag(indentMM, 'LastName', FetchElm(FRetNo, 'INFO', 5));
  AddTag(indentMM, 'DateOfBirth', FetchElm(FRetNo, 'INFO', 9));
  AddTag(indentMM, 'PostalCode', FetchElm(FRetNo, 'INFO', 15));
  AddEndTag(indentM, 'SinEntity');
  //20260413 Igor <<<
  // 20250625 Igor >>>
  {if not IsUHT then
  begin
    if (FormNumber = '2058') then
    begin
      AddBeginTag(indentM, 'PartnershipEntity');
      AddTag(indentMM, 'RegistrationDate', edIDate.Text);
      AddEndTag(indentM, 'PartnershipEntity');
    end else
    begin
      AddBeginTag(indentM, 'CorporateEntity');
      AddTag(indentMM, 'IncorporationDate', edIDate.Text);
      AddTag(indentMM, 'PostalCode', edPCode.Text);
      AddEndTag(indentM, 'CorporateEntity');
    end;
  end else
  begin
    AddBeginTag(indentM, 'UhtEntity');
    AddTag(indentMM, 'RegistrationDate', edIDate.Text);
    AddTag(indentMM, 'PostalCode', edPCode.Text);
    AddTag(indentMM, 'Name', CorporationName);
    AddEndTag(indentM, 'UhtEntity');
  end;}
  // 20250625 Igor <<<
  AddEndTag(indent, 'SharedSecrets');
  AddTag(indent, 'Year', TaxYear);
  AddEndTag(0, 'DacRequest');
  Result := FXMLList.Count > 0;
end;

function TfrmSERS2025.CreateXML: boolean;
var
  s: string;
  x: double;
  FS: TFormatSettings;

  procedure NormalizeArray(var AValue: TArray<string>);
  var
    i: integer;
  begin
    for i := Low(AValue) to High(AValue) do
      AValue[i] := trim(AValue[i]);
  end;

  function GetBoolValue3(ATrue, AFalse, ANAcc: string): string;
  begin
    if FetchElm(RetNo, FFormType, StrToInt(ATrue)) = 'X' then
      Result := '1'
    else if FetchElm(RetNo, FFormType, StrToInt(AFalse)) = 'X' then
      Result := '2'
    else if FetchElm(RetNo, FFormType, StrToInt(ANAcc)) = 'X' then
      Result := '3'
    else
      Result := '';
  end;

  function GetBoolValue2(ATrue, AFalse: string): string;
  begin
    Result := IfThen(FetchElm(RetNo, FFormType, StrToInt(ATrue)) = 'X', '1', IfThen(FetchElm(RetNo, FFormType, StrToInt(AFalse)) = 'X', '2',''));
  end;

  function GetBoolValue1(AValue: string): string;
  begin
    if (ShortFormName = 'T2057') then //20260227 Igor
      Result:= IfThen(FetchElm(RetNo, FormType, StrToInt(AValue)) = 'X', '1', '2') //20260227 Igor
    else //20260227 Igor
      Result:= IfThen(FetchElm(RetNo, FormType, StrToInt(AValue)) = 'X', '1', ''); //20260227 Igor
  end;

  procedure SaveField(AIndent: integer; AValue, ACode, ARow: string);
  begin
    if not AValue.IsEmpty then
    begin
      AddBeginTag(AIndent, 'FieldCode');
      AddTag(AIndent + 3, 'Line', ACode);
      AddTag(AIndent + 3, 'Row', ARow);
      //20250623 Igor >>>
      if (FormNumber.Equals('2059') and ACode.Equals('0385')) then
        AddTag(AIndent + 3, 'Value', IfThen(LowerCase(AValue) = 'yes', '1', '2'))
      else
        AddTag(AIndent + 3, 'Value', AValue);
      //20250623 Igor <<<
      AddEndTag(AIndent, 'FieldCode');
    end;
  end;

  function NormalizeStr(AValue: string): string;
  begin
    Result:= StrUtils.ReplaceStr(AValue,  '’', ''''); //20251114 Igor
    Result:= StrUtils.ReplaceStr(Result,  '‘', ''''); //20251114 Igor
  end;
  //20260226 Igor >>>
  function CheckSymbolsAfterPoint(aFloatVal: string = '0'): string;
  begin
    if (Length(aFloatVal) > 0) and (Pos('.', aFloatVal) = 0) then
      Result:= aFloatVal + '.00'
    else
    if (Pos('.', aFloatVal) > 0) then
    begin
      if ((Length(aFloatVal) - Pos('.', aFloatVal)) = 1) then
        Result:= aFloatVal + '0'
      else
        Result:= aFloatVal;
    end else
      Result:= aFloatVal;
  end;
  //20260226 Igor <<<

  function GetValue(AType: string; AParams: TArray<string>): string;
  var
    sp: string;
  begin
    if AType = 'B1' then
      Result := GetBoolValue1(AParams[0])
    else if AType = 'B2' then
      Result := GetBoolValue2(AParams[0], AParams[1])
    else if AType = 'B3' then
      Result := GetBoolValue3(AParams[0], AParams[1], AParams[2])
    else if AType = 'S' then
      Result := NormalizeStr(FetchElm(RetNo, FFormType, StrToInt(AParams[0])))
    else if AType = 'SC' then
    begin
      Result := '';
      for sp in AParams do
        Result := Result + NormalizeStr(FetchElm(RetNo, FFormType, StrToInt(sp)));
    end
    else if AType = 'N' then
    begin
      {Result := NormalizeStr(FetchElm(RetNo, FFormType, StrToInt(AParams[0])));
      if not Result.IsEmpty then
      begin
        x := VL(Result);
        Result := FormatFloat('#######0.00', x, FS);
      end;}
      Result:= CheckSymbolsAfterPoint(NormalizeStr(FetchElm(RetNo, FormType, StrToInt(AParams[0])))) //20260226 Igor
    end
    else if AType.Split([','])[0] = 'A' then
      Result := 'A'
    // 20250826 Igor >>>
    else if AType.Split([','])[0] = 'T' then
      Result := 'T'
    // 20250826 Igor <<<
    else
      Result := '';
  end;

  procedure AddDynArray(AIndent: integer; AValue: string);
  var
    LCodes: TArray<string>;
    LTypes: TArray<string>;
    LValues: TArray<string>;
    LRow: string;
    LParams: TArray<string>;
    LArrayNo: integer;
    BoxesPerRow: integer;
    RowCount: integer;
    FNo: integer;
    i, j, x: integer;
    Elm: integer;
    LValue: string;
    LStart: integer;
  begin
    FNo := Ret[RetNo].Form[FFormType].FormNo;
    LParams := AValue.Split([chr(9)]);
    NormalizeArray(LParams);
    LCodes := LParams[0].Split([',']);
    NormalizeArray(LCodes);
    LTypes := LParams[1].Split([',']);
    NormalizeArray(LTypes);
    LValues := LParams[2].Split([',']);
    NormalizeArray(LValues);
    LStart := -1;
    for i := Low(LValues) to High(LValues) do
    begin
      if StrToInt(LValues[i]) < 10000 then
        Continue
      else
      begin
        LStart := i;
        break;
      end;
    end;
    if LStart = -1 then
      Exit;
    LArrayNo := StrToInt(LValues[LStart]) div 10000;
    RowCount := DynamicRowCount(RetNo, FNo, LArrayNo);
    if RowCount = 0 then
      Exit;
    BoxesPerRow := Ret[RetNo].Form[FFormType].FormDataRec.BoxesPerRow[LArrayNo];
    for i := 0 to RowCount - 1 do
    begin
      Elm := StrToInt(LValues[LStart]) + BoxesPerRow * i;
      LRow := IntToStr(i + 1);//FetchElmFNo(RetNo, FNo, Elm);
      for j := 1 to High(LTypes) do
      begin
        LParams := LValues[j].Split([':']);
        NormalizeArray(LParams);
        for x := Low(LParams) to High(LParams) do
        begin
          Elm := StrToInt(LParams[x]) + BoxesPerRow * i;
          LParams[x] := IntToStr(Elm);
        end;
        LValue := GetValue(LTypes[j], LParams);
        SaveField(AIndent, LValue, LCodes[j], LRow);
      end;
    end;
  end;

  // 20250826 Igor >>>
  procedure AddTableArray(aIndent: Integer; aValue: string);
  var
    FNo: integer;
    lParams: TArray<string>;
    lCodes: TArray<string>;
    lTypes: TArray<string>;
    lValues: TArray<string>;
    lRow: string;
    i: Integer;
    lValue: string;
  begin
    FNo:= Ret[RetNo].Form[FFormType].FormNo;
    lParams:= aValue.Split([chr(9)]);
    lCodes:= lParams[0].Split([',']);
    NormalizeArray(lCodes);
    lTypes:= lParams[1].Split([',']);
    NormalizeArray(lTypes);
    lValues:= lParams[2].Split([',']);
    NormalizeArray(lValues);
    lRow:= '';

    if (Length(lTypes) > 0) then
      for i:= 0 to High(lTypes) do
        if (lTypes[i] = 'T') then
        begin
          lRow:= lValues[i];
          Break;
        end;

    if lRow.IsEmpty() then Exit;

    for i:= 0 to High(lTypes) do
    if (lTypes[i] <> 'T') then
    begin
      lParams:= lValues[i].Split([':']);
      NormalizeArray(lParams);

      lValue:= GetValue(lTypes[i], lParams);
      SaveField(aIndent, lValue, lCodes[i], lRow);
    end;
  end;
  // 20250826 Igor <<<

  procedure AddField(AIndent: integer; AValue: string);
  var
    LCode: string;
    LType: string;
    LValue: string;
    LRow: string;
    LParams: TArray<string>;
  begin
    LRow := '0';
    LParams := AValue.Split([chr(9), ' ']);
    NormalizeArray(LParams);
    LCode := LParams[0];
    LType := LParams[1];
    LValue := LParams[2];
    LParams := LValue.Split([',']);
    NormalizeArray(LParams);

    LValue := GetValue(LType, LParams);

    if LValue = 'A' then
    begin
      AddDynArray(AIndent, AValue);
      Exit;
    end;
    // 20250826 Igor >>>
    if LValue = 'T' then
    begin
      AddTableArray(AIndent, AValue);
      Exit;
    end;
    // 20250826 Igor <<<

    SaveField(AIndent, LValue, LCode, LRow);
  end;
begin
  FS := TFormatSettings.Create;
  FS.DecimalSeparator := '.';
  FXMLList.Clear;
  InitFormParams;
  AddBeginTagwithValue(0, 'FileReturnRequest', 'xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" xmlns:common="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0"');

  AddTag(indent, 'common:SoftwareCode', SoftwareCode);
  if FormNumber = '2900' then
    AddTag(indent, 'common:TaxYear', FetchElm(RetNo, FormType, 2))
  else
    AddTag(indent, 'common:TaxYear', CurrentApp.AppYear);
  AddTag(indent, 'common:ClientId', edNumber.Text);

  AddBeginTag(indent, 'Form');

  AddTag(indentM, 'common:FormSequenceNumber', '1');
  AddTag(indentM, 'common:FormNumber', FormNumber);

  for s in FFieldList do
    AddField(indentM, s);

  AddEndTag(indent, 'Form');

  AddEndTag(0, 'FileReturnRequest');
  Result := FXMLList.Count > 9;
end;

procedure TfrmSERS2025.FormCreate(Sender: TObject);
begin
  Files := TList<TFileRecord>.Create;
  FXMLList := TStringList.Create;
  FFieldList := TStringList.Create;
  pcMain.TabIndex:= 0; // 20250703 Igor
end;

procedure TfrmSERS2025.FormDestroy(Sender: TObject);
begin
  FXMLList.Free;
  FFieldList.Free;
  if Assigned(Files) then
    Files.Free;
end;

procedure TfrmSERS2025.FormShow(Sender: TObject);
begin
  Init;
end;

function TfrmSERS2025.GetAttachDocsReceivedFileName: string;
begin
  Result := GetReceivedFileName('AttachDocs');
end;

function TfrmSERS2025.GetAttachDocsReceivedHTMLFileName: string;
begin
  Result := GetReceivedHTMLFileName('AttachDocs');
end;

function TfrmSERS2025.GetAttachDocsRequest: string;
var I: integer;
begin
  Result :=
    '<AttachDocsRequest xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" '+ #13#10 +
    '                   xmlns:common="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0"> '+ #13#10 +
    '  <common:SoftwareCode>' + DeveloperCode + 'AF'{SoftwareCode} + '</common:SoftwareCode> '+ #13#10 + //20260414 Igor. Changes after CRA email answer.
    '  <common:TaxYear>' + CurrentApp.AppYear + '</common:TaxYear>' + #13#10 + //20260413 Igor
    '  <common:ClientId>'+ edNumber.Text +'</common:ClientId> '+ #13#10 +
    '  <common:ConfirmationNumber>'+ edConfirmationNumber.Text +'</common:ConfirmationNumber> '+ #13#10 +
    '  <AttachmentList>'+ #13#10;
  for I := 0 to Files.Count - 1 do
    Result := Result +
      '    <File> '+ #13#10 +
      '      <common:FileName>'+ ExtractFileName(Files[I].FileName) +'</common:FileName> '+ #13#10 +
      '      <MimeType>'+ GetMIMETypeFromFile(Files[I].FileName) + '</MimeType>'+ #13#10 +
      '      <common:FormNumber>'+ GetFormNumber +'</common:FormNumber> '+ #13#10 +
      '      <DocumentType>'+ DocumentTypesShort[Files[I].DocType] +'</DocumentType> '+ #13#10 +
      '    </File>' + #13#10;

  Result := Result +
    '  </AttachmentList>' + #13#10 +
    '</AttachDocsRequest>';
end;

function TfrmSERS2025.GetAttachDocsSubmittedFileName: string;
begin
  Result := GetSubmittedFileName('AttachDocs');
end;

function TfrmSERS2025.GetAttachDocsUrl: string;
begin
  Result := URLForWebServices.Text + c_AttachDocsUrl;
end;

function TfrmSERS2025.GetBasicAuthorization(AUserName, APassword: string): string;
var
  Encoder: TIdEncoderMIME;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Result := Encoder.EncodeString(AUserName + ':' + APassword);
  finally
    Encoder.Free;
  end;
end;

function TfrmSERS2025.GetConfirmNumber: integer;
begin
  if (FormNumber = '2054') or (FormNumber = '0089') or (FormNumber = '2058') then
    Result := 89
  else
  // 20250901 Igor >>>
  if (FormNumber = '2311') or (FormNumber = '1521') or (FormNumber = '2055') or (FormNumber = '2123') or (FormNumber = '2184') or (FormNumber = '2107') or (FormNumber = '0074') then  //20251028 Igor
    Result:= 311
  else
  if (FormNumber = '0151') then
    Result:= 413
  else
  // 20250901 Igor <<<
    Result := 59;
end;

// 20250729 Igor >>>
procedure TfrmSERS2025.GetDACButtonClick(Sender: TObject);
var
  LResponse: string;
  objHttp: IXMLHTTPRequest;
  LSub: string;
  lDlg1, lDlg: TForm;
  lBtnYes, lBtnNo: TButton;

  procedure MakeDACRequest();
  begin
    if Length(edNumber.Text) <> 9 then
    begin
      ShowMessage('M-Client No is required (9 digits)');
      Exit;
    end;

    if not CreateDACXML then
    begin
      ShowMessage('DAC Request XML is empty');
      Exit;
    end;

    objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as IXMLHTTPRequest;
    try
      objHttp.open('POST', RequestDACUrl, False, '', '');
      FXMLList.SaveToFile(RequestDACSubmittedFileName);
      objHttp.setRequestHeader('Content-Type', 'application/xml');
      objHttp.setRequestHeader('Authorization', 'Basic ' + GetBasicAuthorization(OnlineNo, Password));
      objHttp.send(FXMLList.Text);
      LResponse := objHttp.ResponseText;
      SaveToFile(LResponse, RequestDACReceivedFileName);
      Response := ParseResponse(LResponse);
      ShowHTML(Response, RequestDACReceivedHTMLFileName);
      InitFileNames;

      if (Response.Success) then
      begin
        ShowMessage('Please Submit your File Return now');
        pcMain.TabIndex:= 1;
      end;
    finally
       objHttp := nil;
    end;
  end;

  procedure MakeDACRequestProc();
  begin
    if not IsBNConfirmed then
    begin
      lDlg:= CreateMessageDialog(
               'Please confirm that the client number and extension entered are correct '+
               'for the form or attachment being filed.',
               mtConfirmation,
               [mbNo, mbCancel, mbYes]
             );
      try
        lDlg.Caption:= 'Confirm Client Number';
        lBtnYes:= lDlg.FindComponent('Yes') as TButton;
        lBtnNo:= lDlg.FindComponent('No') as TButton;

        if Assigned(lBtnYes) then lBtnYes.Caption:= 'Continue';
        if Assigned(lBtnNo) then lBtnNo.Caption:= 'Back';

        if lDlg.ShowModal = mrYes then
        begin
          FIsBNConfirmed:= True;
          MakeDACRequest();
        end;
      finally
        lDlg.Free;
      end;
    end else
      MakeDACRequest();
  end;

//var
//  ResponseXML: string;
begin
  //Test appendix D/B (10
//  ResponseXML:= '<?xml version="1.0" encoding="UTF-8"?>';
//  ResponseXML:= ResponseXML + '<AttachDocsResponse xmlns="http://www.cra-arc.gc.ca/xmlns/sres/1-0-0" xmlns:ns0="http://www.cra-arc.gc.ca/xmlns/srescommon/1-0-0">';
//  ResponseXML:= ResponseXML + '<Error>';
//  ResponseXML:= ResponseXML + '<ns0:ErrorId>1320</ns0:ErrorId>';
//  ResponseXML:= ResponseXML + '<ns0:ErrorEnglishDesc>The information submitted is either incorrect or incomplete.</ns0:ErrorEnglishDesc>';
//  ResponseXML:= ResponseXML + '</Error>';
//  ResponseXML:= ResponseXML + '</AttachDocsResponse>';
//
//  Response:= ParseResponse(ResponseXML);
//  ShowEDocHTML(Response, AttachDocsReceivedHTMLFileName);
//  Exit;

  if (edDAC.Text <> '') then
  begin
    lDlg1:= CreateMessageDialog(
             'DAC Number is not empty. Are you sure that you want to request new DAC number?',
             mtConfirmation,
             [mbNo, mbYes]
           );
    try
      lDlg1.Caption:= 'Confirm DAC Request';
      lBtnYes:= lDlg1.FindComponent('Yes') as TButton;
      lBtnNo:= lDlg1.FindComponent('No') as TButton;

      if Assigned(lBtnYes) then lBtnYes.Caption:= 'Continue';
      if Assigned(lBtnNo) then lBtnNo.Caption:= 'Cancel';

      if lDlg1.ShowModal = mrYes then
        MakeDACRequestProc();
    finally
      lDlg1.Free;
    end;
  end else
    MakeDACRequestProc();
end;
// 20250729 Igor <<<

function TfrmSERS2025.GetFileReturnReceivedFileName: string;
begin
  if IsUHT then
    Result := GetReceivedFileName('FileUHTReturn')
  else
    Result := GetReceivedFileName('FileReturn');
end;

function TfrmSERS2025.GetFileReturnReceivedHTMLFileName: string;
begin
  if IsUHT then
    Result := GetReceivedHTMLFileName('FileUHTReturn')
  else
    Result := GetReceivedHTMLFileName('FileReturn');
end;

function TfrmSERS2025.GetFileReturnSubmittedFileName: string;
begin
  if IsUHT then
    Result := GetSubmittedFileName('FileUHTReturn')
  else
    Result := GetSubmittedFileName('FileReturn');
end;

function TfrmSERS2025.GetFileReturnUrl: string;
begin
  if IsUHT then
    Result := URLForWebServices.Text + c_FileUHTReturnUrl
  else
    Result := URLForWebServices.Text + c_FileReturnUrl;
end;

function TfrmSERS2025.GetFormNumber: string;
begin
  Result := '';
  if SameText(FormType, 'T2054') then
    Result := '2054'
  else if SameText(FormType, 'S89') then
    Result := '0089'
  else if SameText(ShortFormName, 'T2057') then
    Result := '2057'
  else if SameText(ShortFormName, 'T2059') then
    Result := '2059'
  else if SameText(ShortFormName, 'T2058') then
    Result := '2058'
  else if SameText(ShortFormName, 'UHT2900') then
    Result := '2900'
  else if SameText(ShortFormName, 'T217') then
    Result := '0217'
  // 20250901 Igor >>>
  else if SameText(FormType, 'S151') then
    Result := '0151'
  else if SameText(FormType, 'T2055') then
    Result:= '2055'
  else if SameText(FormType, 'T2123') then
    Result:= '2123'
  // 20250901 Igor <<<
  else if SameText(FormType, 'T2184') then Result:= '2184' //20251027 Igor
  else if SameText(FormType, 'T2107') then Result:= '2107' //20251028 Igor
  else if SameText(FormType, 'S74') then Result:= '0074' //20251028 Igor
  // 20250826 Igor >>>
  else if SameText(FormType, 'T2311') then
    Result:= '2311'
  else if SameText(FormType, 'T1521') then
    Result:= '1521';
  // 20250826 Igor <<<
end;

function TfrmSERS2025.GetLastName: string;
begin
  Result := FetchElm(RetNo, FFormType, 2)
end;

function TfrmSERS2025.GetReceivedFileName(AType: string): string;
begin
  ForceDirectories(FEDocsDir);
  Result := TPath.Combine(FEDocsDir, RetList[FRetNo].SourceFlName + '_' + AType + '_SERS-RECEIVED.XML');
end;

function TfrmSERS2025.GetReceivedHTMLFileName(AType: string): string;
begin
  ForceDirectories(FEDocsDir);
  Result := TPath.Combine(FEDocsDir, RetList[FRetNo].SourceFlName + '_' + AType + '_SERS-RECEIVED.HTML');
end;

function TfrmSERS2025.GetRequestDACReceivedFileName: string;
begin
  if IsUHT then
    Result := GetReceivedFileName('RequestUHTDAC')
  else
    Result := GetReceivedFileName('RequestDAC');
end;

function TfrmSERS2025.GetRequestDACReceivedHTMLFileName: string;
begin
  if IsUHT then
    Result := GetReceivedHTMLFileName('RequestUHTDAC')
  else
    Result := GetReceivedHTMLFileName('RequestDAC');
end;

function TfrmSERS2025.GetRequestDACSubmittedFileName: string;
begin
  if IsUHT then
    Result := GetSubmittedFileName('RequestUHTDAC')
  else
    Result := GetSubmittedFileName('RequestDAC');
end;

function TfrmSERS2025.GetRequestDACUrl: string;
begin
  if IsUHT then
    Result := URLForWebServices.Text + c_RequestUHTDACUrl
  else
    Result := URLForWebServices.Text + c_RequestDACUrl;
end;

function TfrmSERS2025.GetShortFormName: string;
begin
  if LeftStr(FFormType, 5) = 'T2057' then
    Result := 'T2057'
  else if LeftStr(FFormType, 4) = 'UHT#' then
    Result := 'UHT2900'
  else if LeftStr(FFormType, 3) = 'S89' then
    Result := 'S89'
  else
    Result := FFormType;
end;

function TfrmSERS2025.GetSoftwareCode: string;
begin
  //20250109
  if ShortFormName = 'T2057' then Result := '064AC'
  else if ShortFormName = 'T2059' then Result := '064AD'
  else if ShortFormName = 'UHT'   then Result := '064AE'
  //else if ShortFormName = 'UHT2900' then Result := '064AE'
  else if ShortFormName = 'T217'  then Result := '064AB'
  else
    Result:= '';
  //Result:= FRRMSSoftwareId;
end;

function TfrmSERS2025.GetSubmittedFileName(AType: string): string;
begin
  ForceDirectories(FEDocsDir);
  Result := TPath.Combine(FEDocsDir, RetList[FRetNo].SourceFlName + '_' + AType + '_SERS-SUBMITTED.XML');
end;

function TfrmSERS2025.GetTaxYear: string;
begin
  // 20250723 Igor >>>
  (*if {(FormNumber = '2900') or} (FormNumber = '0089'){ or (FormNumber = '2058')} then // 20250623 Igor
    Result := ''
  else  *)
  // 20250723 Igor <<<
    Result := CurrentApp.AppYear;
end;

procedure TfrmSERS2025.Init;
var
  LCNumber: integer;
begin
  if forCRATestMode or inJZtestmode then SERSTestMode := true; //jz//no difference with this unit between the test modes

  isUserSelectedFilesAttaching    := False;
  pcMain.Pages[0].TabVisible      := SERSTestMode; //20260427 Alex
  pcMain.TabIndex                 := 0; //20260427 Alex
  TabSheet1.Caption               := 'Connection Info for TESTING' + IfThen(SERSTestMode, ' (step 1)', ' (step 1)');   //20260427 Alex
  TabSheet2.Caption               := 'Submit File Return'          + IfThen(SERSTestMode, ' (step 2)', ' (step 1)');  //20260427 Alex
  TabSheet3.Caption               := 'Attach e-Documents'          + IfThen(SERSTestMode, ' (step 3)', ' (step 2)');  //20260427 Alex
  Label15.Visible                 := SERSTestMode; //20260427 Alex
  Label16.Visible                 := SERSTestMode; //20260427 Alex
  FileReturnSubmittedEdit.Visible := SERSTestMode; //20260427 Alex
  FileReturnReceivedEdit.Visible  := SERSTestMode; //20260427 Alex
  Label21.Visible                 := SERSTestMode; //20260427 Alex
  Label22.Visible                 := SERSTestMode; //20260427 Alex
  AttachDocsSubmittedEdit.Visible := SERSTestMode; //20260427 Alex
  AttachDocsReceivedEdit.Visible  := SERSTestMode; //20260427 Alex

  FRetNo:= GetCurrentRetNo;
  edNumber.Text:= FetchElm(FRetNo, 'INFO', 3); //FetchElm(FRetNo, 'T2', 1); //20260413 Igor
  FCorporationName:= FetchElm(FRetNo, 'INFO', 2) + ' ' + FetchElm(FRetNo, 'INFO', 5); //FetchElm(FRetNo, 'T2', 3); // 20250625 Igor
  //edIDate.Text:= ReplaceStr(FetchElm(FRetNo, 'T2', 299), '/', '-');
  edPCode.Text:= FetchElm(FRetNo, 'INFO', 15); //FetchElm(FRetNo, 'T2', 20);
  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  // 20250729 Igor >>>
  //if not IsUHT and (FormNumber <> '2058') then //20260413 Igor
  //  edDAC.Text:= FetchElm(FRetNo, 'T2', 128); //20260413 Igor

  eAuthEfilerNum.Text:= OnlineNo;
  eAuthPassword.Text:= Password;
  eAuthEfilerNum.Enabled:= True;
  eAuthPassword.Enabled:= True;
  GetDACButton.Enabled:= False;
  edDAC.Enabled:= False;
  // 20250729 Igor <<<

  if (FormNumber = '2054') or (FormNumber = '0089') or (FormNumber = '2058') then
    LCNumber := 89
  else
  // 20250901 Igor >>>
  if (FormNumber = '2311') or (FormNumber = '1521') or (FormNumber = '2055') or (FormNumber = '2123') or (FormNumber = '2184') or (FormNumber = '2107') or (FormNumber = '0074') then //20251028 Igor
    LCNumber:= 311
  else
  if (FormNumber = '0151') then
    LCNumber:= 413
  else
  // 20250901 Igor <<<
    LCNumber := 59;
  edConfirmationNumber.Text := FetchElm(RetNo, FFormType, LCNumber);

  ProductionOrTestGroup.ItemIndex := 0;
  if SERSTestMode then ProductionOrTestGroup.ItemIndex := 1; //testing url


  edFormType.Text := FormType;
  edFormSequenceNumber.Text := '1';

  DACSheet.TabVisible := False;// not IsUHT; //20260414 Igor
  UHTDACSheet.TabVisible := False; //IsUHT; //20260414 Igor
  FileReturnSheet.TabVisible := not IsUHT;
  UHTFileReturn.TabVisible := IsUHT;

  if IsUHT then
    pgSubmittedFiles.ActivePage := UHTFileReturn //UHTDACSheet //20260414 Igor
  else
    pgSubmittedFiles.ActivePage := FileReturnSheet;//DACSheet; //20260414 Igor

  grFiles.ColWidths[0] := 170;
  grFiles.ColWidths[1] := 295;
  grFiles.ColWidths[2] := 105;
  RebuildGrid;

  FEDocsDir := TPath.Combine(NetFileDir, 'SERS\'+ ShortFormName);
  InitFileNames;
end;

procedure TfrmSERS2025.InitFileNames;
  procedure SetFileNameEditValue(AEdit: TEdit; AFileName: string);
  begin
    if FileExists(AFileName) then
      AEdit.Text := AFileName;
  end;
begin
  SetFileNameEditValue(DACSubmittedEdit, GetRequestDACSubmittedFileName);
  SetFileNameEditValue(DACReceivedEdit, GetRequestDACReceivedFileName);
  SetFileNameEditValue(DACReceivedHTMLEdit, GetRequestDACReceivedHTMLFileName);

  SetFileNameEditValue(UHTDACSubmittedEdit, GetRequestDACSubmittedFileName);
  SetFileNameEditValue(UHTDACReceivedEdit, GetRequestDACReceivedFileName);
  SetFileNameEditValue(UHTDACReceivedHTMLEdit, GetRequestDACReceivedHTMLFileName);

  SetFileNameEditValue(FileReturnSubmittedEdit, GetFileReturnSubmittedFileName);
  SetFileNameEditValue(FileReturnReceivedEdit, GetFileReturnReceivedFileName);
  SetFileNameEditValue(FileReturnReceivedHTMLEdit, GetFileReturnReceivedHTMLFileName);

  SetFileNameEditValue(AttachDocsSubmittedEdit, GetAttachDocsSubmittedFileName);
  SetFileNameEditValue(AttachDocsReceivedEdit, GetAttachDocsReceivedFileName);
  SetFileNameEditValue(AttachDocsReceivedHTMLEdit, GetAttachDocsReceivedHTMLFileName);
end;

procedure TfrmSERS2025.InitFormParams;
var
  i: integer;
begin
  FFieldList.Clear;
  FFieldList.LoadFromFile(AppDir + '\' + 'SERS.D');
  for i := FFieldList.Count - 1 downto 0 do
    if Pos(ShortFormName, FFieldList[i]) = 1 then
      FFieldList[i] := trim(Copy(FFieldList[i], Length(ShortFormName) + 1, MaxInt))
    else
      FFieldList.Delete(i);
end;

function TfrmSERS2025.ParseResponse(AResponse: string): TResponse;
var
  X: XML.XMLDoc.TXMLDocument;
  Node: IXMLNode;
begin
  Result.Success := false;
  Result.ReturnCode := -1;
  Result.Description := '';
  Result.Text := '';
  Result.ErrorReason := '';
  Result.ErrorReasonDescription := '';
  Result.ErrorReasonText := '';

  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      // 20250703 Igor >>>
      if AResponse.StartsWith('<?xml') then
      begin
        X.XML.Add(ClearXML(AResponse));
        if not(X.Active) then
          X.Active := true;
        Node := X.DocumentElement;
      end;
      // 20250703 Igor <<<

      if not Assigned(Node) then
        Result.Text := 'Response has incorrect structure: <br><br>' + HTMLEscape(AResponse)
      else if SameText(Node.NodeName, 'DacResponse') then
      begin
        if Assigned(Node.ChildNodes.FindNode('DigitalAccessCode')) then
        begin
          edDAC.Text := Node.ChildNodes.FindNode('DigitalAccessCode').NodeValue;
          Result.Success := true;
          Result.Text := 'Digital Access Code: ' + edDAC.Text;
        end
        else
        begin
          Node := Node.ChildNodes.FindNode('Error');
          Result.ErrorReason := Node.ChildNodes.FindNode('ErrorId').NodeValue;
          Result.Text := Node.ChildNodes.FindNode('ErrorEnglishDesc').NodeValue;
        end;
      end
      else if SameText(Node.NodeName, 'FileReturnResponse') then
      begin
        if Assigned(Node.ChildNodes.FindNode('Form')) then
        begin
          Node := Node.ChildNodes.FindNode('Form');
          if Assigned(Node.ChildNodes.FindNode('ConfirmationNumber')) then
          begin
            edConfirmationNumber.Text := Node.ChildNodes.FindNode('ConfirmationNumber').NodeValue;
            Result.Success := true;
            Result.Text := 'Confirmation Number: ' + edConfirmationNumber.Text;
            StoreElm(RetNo, FormType, ConfirmNumber, edConfirmationNumber.Text);
            Ret[RetNo].Changed := True;
            Exit;
          end
          else if Assigned(Node.ChildNodes.FindNode('Error')) then
            Node := Node.ChildNodes.FindNode('Error');
        end
        else if Assigned(Node.ChildNodes.FindNode('Error')) then
          Node := Node.ChildNodes.FindNode('Error')
        else
          Node := nil;
        if Assigned(Node) then
        begin
          Result.ErrorReason := Node.ChildNodes.FindNode('ErrorId').NodeValue;
          Result.Text := Node.ChildNodes.FindNode('ErrorEnglishDesc').NodeValue;
        end;
      end
      else if SameText(Node.NodeName, 'AttachDocsResponse') then
      begin
        if Assigned(Node.ChildNodes.FindNode('ConfirmationNumber')) then
        begin
          Result.Success := true;
          Result.Text := 'Confirmation: ' + Node.ChildNodes.FindNode('ConfirmationNumber').NodeValue;
          Exit;
        end;
        if Assigned(Node.ChildNodes.FindNode('File')) then
          Node := Node.ChildNodes.FindNode('File').ChildNodes.FindNode('Error')
        else
          Node := Node.ChildNodes.FindNode('Error');
        if Assigned(Node) then
        begin
          Result.ErrorReason := Node.ChildNodes.FindNode('ErrorId').NodeValue;
          Result.Text := Node.ChildNodes.FindNode('ErrorEnglishDesc').NodeValue;
        end;
      end
      else
        Result.Text := HTMLEscape(AResponse);
    except on E: Exception do
      begin
        Result.Text := HTMLEscape(AResponse);
        ShowMessage('Error occured while processing CRA response: '+ #13 + E.Message + #13#13 + 'Response: '+ AResponse);
      end;
    end;
  finally
    X.Free;
  end;
end;

procedure TfrmSERS2025.ProductionOrTestGroupClick(Sender: TObject);
begin
  if ProductionOrTestGroup.ItemIndex = 1 then
    URLForWebServices.Text := c_TestDomain
  else
    URLForWebServices.Text := c_ProdDomain;
  edDAC.ReadOnly := ProductionOrTestGroup.ItemIndex = 0;
  edConfirmationNumber.ReadOnly := ProductionOrTestGroup.ItemIndex = 0;
end;

procedure TfrmSERS2025.RebuildGrid;
var F: TFileRecord;
    I, J, Row: integer;
begin
  for I := 0 to grFiles.ColCount - 1 do
    for J := 1 to grFiles.RowCount - 1 do
      grFiles.Cells[I, J] := '';

  grFiles.RowCount := Files.Count + 1;
  if grFiles.RowCount = 1 then
  begin
    grFiles.RowCount := 2;
    grFiles.FixedRows := 1;
  end;
  grFiles.Cells[0, 0] := 'Document Type';
  grFiles.Cells[1, 0] := 'File Name';
  grFiles.Cells[2, 0] := 'File Size';
  Row := 1;
  TotalSize := 0;
  for F in Files do
  begin
    grFiles.Cells[0, Row] := DocumentTypesFull[F.DocType];
    grFiles.Cells[1, Row] := ExtractFileName(F.FileName);
    grFiles.Cells[2, Row] := Format('%.2f', [F.FileSize / 1024 / 1024])+' Mb';
    TotalSize := TotalSize + F.FileSize;
    inc(Row);
  end;
  RemainingSize := MaxTotalSize - TotalSize;
  lbTotal.Caption := Format('%.2f', [TotalSize / 1024 / 1024])+' Mb';
  lbRemaining.Caption := Format('%.2f', [RemainingSize / 1024 / 1024])+' Mb';
  lbRemainingNumber.Caption := IntToStr(MaxFiles - Files.Count);
  btnAttach.Enabled := (Files.Count < MaxFiles);
  btnDetach.Enabled := Files.Count > 0;
  btnSubmit.Enabled := (Files.Count > 0) and (edConfirmationNumber.Text <> '');
end;

procedure TfrmSERS2025.SetFormType(const Value: string);
begin
  FFormType := Value;
  FIsUHT := FormNumber = '2900';
end;

procedure TfrmSERS2025.ShowHTML(AResponse: TResponse; AFileName: string);
var L: TStringList;
    A: TArray<string>;
    I: integer;
    cColor, cBody: string;
    cCaption: string;
begin
  if AResponse.Success then
  begin
    cColor := 'green';
    cCaption := 'Confirmation';
  end
  else
  begin
    cColor := 'red';
    cCaption := 'Error';
  end;
  L := TStringList.Create;
  try
    L.Add('<HTML><HEAD>');
    L.Add('<META CHARSET="UTF-8">');
    L.Add('<TITLE>T2 EFile Service</TITLE>');
    L.Add('</HEAD>');
    L.Add('<BODY>');
    L.Add('<DIV id="contentheader">');
    L.Add('<H1><FONT size=5><STRONG>SERS Results</STRONG></FONT></H1>');
    L.Add('<P>Client Number: <STRONG>'+ HTMLEscape(edNumber.Text) +'</STRONG></P>');
    L.Add('<P>Form Type: <STRONG>'+ HTMLEscape(edFormType.Text) +'</STRONG></P>');
    L.Add('<H2><FONT color='+ cColor +' size=5><STRONG>'+ cCaption +'</STRONG></FONT></H2>');
    if AResponse.Success then
    begin
      L.Add('<P><FONT size=3>'+ AResponse.Text +'</FONT></P>');
    end
    else
    begin
      if AResponse.ReturnCode <> -1 then
        L.Add('<P><FONT size=3><strong>Result Code:</strong> '+ IntToStr(AResponse.ReturnCode) +' - '+ AResponse.Description +'</FONT></P>');

      L.Add('<P><FONT size=3>'+ AResponse.Text +'</FONT></P>');

      if not AResponse.ErrorReason.IsEmpty then
        if AResponse.ErrorReasonDescription.IsEmpty then
          L.Add('<P><FONT size=3><strong>Error Reason:</strong> '+ AResponse.ErrorReason +'</FONT></P>')
        else
          L.Add('<P><FONT size=3><strong>Error Reason:</strong> '+ AResponse.ErrorReason +' - '+ AResponse.ErrorReasonDescription +'</FONT></P>');
      if not AResponse.ErrorReasonText.IsEmpty then
        L.Add('<P><FONT size=3>'+ HTMLEscape(AResponse.ErrorReasonText) +'</FONT></P>');
    end;
    L.Add('<HR>');
    L.Add('<P>Received: '+ DateTimeToStr(Now) +'</P>');
    L.Add('</DIV></BODY></HTML>');
    L.SaveToFile(AFileName, TEncoding.UTF8);
    ShowMessageHTML(L.Text, 600);
  finally
    L.Free;
  end;
end;

// 20250703 Igor >>>

procedure TfrmSERS2025.ForHelpOnMouseEnter(Sender: TObject);
begin
  HelpObjectDescription(Sender);
end;

procedure TfrmSERS2025.ForHelpOnMouseLeave(Sender: TObject);
begin
  HelpObjectDescription(Sender);
end;

procedure TfrmSERS2025.HelpObjectDescription(Sender: TObject);
begin
  mHelp.Lines.Clear;
  if Assigned(Sender) then
  begin
    if Sender is TRadioGroup and (TRadioGroup(Sender).Name = 'ProductionOrTestGroup') then
    begin
      mHelp.Lines.Add('Production (End User) - for the end user. This is the URL link to CRA server.');
      mHelp.Lines.Add('Test (Software developer) - To be used by the software developers only!');
    end;

    // TEdits
    if Sender is TEdit then //20250704
    begin
      if (TEdit(Sender).Name = 'URLForWebServices') then
      begin
        mHelp.Lines.Add('If selected "Production (End User)" - it means that you will use the production URL to connect to the CRA web server.');
        mHelp.Lines.Add('If selected "Test (Software developer)" - This option must be used only by software developers to test the SERS functionality.');
      end;
      if (TEdit(Sender).Name = 'edDAC') then
        mHelp.Lines.Add('This is a "Digital Access Code (DAC)" you will get from the CRA server when you clicked the "Get Digital Access Code" button.');
      if (TEdit(Sender).Name = 'edNumber') then
        mHelp.Lines.Add('This is a "Client Number" what was copied from the "001" field on the form. We will use this information in the DAC request.');
      if (TEdit(Sender).Name = 'edIDate') then
        mHelp.Lines.Add('This is a "Inc. Date" you entered on the top of the T2 Form.');
      if (TEdit(Sender).Name = 'edPCode') then
        mHelp.Lines.Add('This is a "Postal or Zip code" that you entered on the T2 Form. box "018".');
      if (TEdit(Sender).Name = 'edFormType') then
        mHelp.Lines.Add('Just a system name of the current used form to be used in the DAC request.');
      if (TEdit(Sender).Name = 'edFormSequenceNumber') then
        mHelp.Lines.Add('Just a system information to be used DAC request.');
      if (TEdit(Sender).Name = 'edConfirmationNumber') then
        mHelp.Lines.Add('This is a "Confermation number" is a number you will recove to comfirm successfully submition of the Return. To be used if you will attach and submit an e-Documents.');
    end;

    // TBitBtns
    if Sender is TBitBtn then
    begin
      if (TBitBtn(Sender).Name = 'GetDACButton') then
        mHelp.Lines.Add('Use this button "Request a Digital Access Code" to get the "Digital Access Code" from the CRA API server.');
      if (TBitBtn(Sender).Name = 'SubmitFileReturnButton') then
        mHelp.Lines.Add('This button can be used only when you successfully got the "Digital Access Code" from the CRA API server. You can use this button when you need to Submit your "File Return".');

      if (TBitBtn(Sender).Name = 'btnAttach') then
        mHelp.Lines.Add('Use this button when you want to attach e-Document file to the Form’s EFILE confirmation number.');
      if (TBitBtn(Sender).Name = 'btnDetach') then
        mHelp.Lines.Add('Use this button when you want to remove e-Document file from the Form’s EFILE confirmation number.');
      if (TBitBtn(Sender).Name = 'btnSubmit') then
        mHelp.Lines.Add('Use this button when you want to send all you attached documents to CRA with a EFILE confirmation number you got early.');
    end;

    // TStringGrids
    if Sender is TStringGrid then
    begin
      if (TBitBtn(Sender).Name = 'grFiles') then
        mHelp.Lines.Add('This is a Summary information of the attached files that you want to send to CRA with a "Confirmation number of your File Return" that you will get from the CRA server after after you click "Submit File Return".');
    end;
  end;
end;

procedure TfrmSERS2025.pcMainChange(Sender: TObject);
begin
  lBNOnAttachFilesPage.Caption:= edNumber.Text;
  lForrmTypeOnAttachFilesPage.Caption:= edFormType.Text;
  lConfNumberOnAttachFilesPage.Caption:= edConfirmationNumber.Text;

  case pcMain.TabIndex of
    1:
      begin
        if rbUseDACAuth.Checked and (edDAC.Text = '') then // 20250729 Igor
        begin
          ShowMessage('First you need to get Digital Access Code.');
          pcMain.TabIndex:= 0;
          Exit;
        end;
      end;
    2:
      begin
        if rbUseDACAuth.Checked and (edDAC.Text = '') then // 20250729 Igor
        begin
          ShowMessage('First you need to get Digital Access Code.');
          pcMain.TabIndex:= 0;
          Exit;
        end;
        if edConfirmationNumber.Text = '' then
        begin
          ShowMessage('First you need to get Confirmation Number.');
          pcMain.TabIndex:= 1;
          Exit;
        end;
      end;
  end;
end;

// 20250703 Igor <<<
// 20250709 Igor >>>
procedure TfrmSERS2025.ShowEDocHTML(AResponse: TResponse; AFileName: string);
var
  L: TStringList;
  A: TArray<string>;
  I: integer;
  cColor, cBody: string;
  cCaption: string;
  lFile: TFileRecord;
  lRow: integer;
begin
  if AResponse.Success then
  begin
    cColor:= 'green';
    cCaption:= 'Confirmation';
  end else
  begin
    cColor:= 'red';
    cCaption:= 'Error';
  end;

  L:= TStringList.Create;
  try
    L.Add('<HTML><HEAD>');
    L.Add('<META CHARSET="UTF-8">');
    L.Add('<TITLE>T2 EFile Service</TITLE>');
    L.Add('</HEAD>');
    L.Add('<BODY>');
    L.Add('<DIV id="contentheader" style="margin-left: 20px;">');
    L.Add('<br>');
    L.Add('<FONT size=5><STRONG>Submit e-Documents - <FONT color='+ cColor +' size=5>' + cCaption + '</FONT></STRONG></FONT>');
    L.Add('<br>Program: <b>SERS</b>');
    L.Add('<br>Client Number: <b>'+ HTMLEscape(edNumber.Text) +'</b>');
    L.Add('<br>Form Type: <b>'+ HTMLEscape(edFormType.Text) +'</b>');
    L.Add('<br><div style="margin-left:20px;">•	EFILE Confirmation number: <b>' + edConfirmationNumber.Text + '</b></div>');
//    L.Add('<H2><FONT color='+ cColor +' size=5><STRONG>'+ cCaption +'</STRONG></FONT></H2>');

    if AResponse.Success then
    begin
      L.Add('<br><FONT size=3>Submit e-Documents ' + ReplaceStr(ReplaceStr(AResponse.Text, 'Confirmation:', 'Confirmation number:'), ':', ':<b>') + '</b></FONT>');
      L.Add('<br><i>Retain this confirmation number for future reference.</i>');
      L.Add('<br>Your document has been successfully submitted.');
    end else
    begin
      if AResponse.ReturnCode <> -1 then
        L.Add('<br><FONT size=3><strong>Error '+ IntToStr(AResponse.ReturnCode) + '</strong></FONT>') // +' - '+ AResponse.Description +'</FONT></P>');
      else
      if not AResponse.ErrorReason.IsEmpty then
        L.Add('<br><FONT size=3><strong>Error '+ AResponse.ErrorReason + '</strong></FONT>');

      if not AResponse.Text.IsEmpty() then
        L.Add('<br><FONT size=3>' + AResponse.Text + '</FONT>')
      else
      if not AResponse.ErrorReason.IsEmpty then
      begin
        if AResponse.ErrorReasonDescription.IsEmpty then
          L.Add('<br><FONT size=3><strong>Error Reason:</strong> '+ AResponse.ErrorReason +'</FONT>')
        else
          L.Add('<br><FONT size=3><strong>Error Reason:</strong> '+ AResponse.ErrorReason +' - '+ AResponse.ErrorReasonDescription +'</FONT>');
      end else
      if not AResponse.ErrorReasonText.IsEmpty then
        L.Add('<br><FONT size=3>'+ HTMLEscape(AResponse.ErrorReasonText) +'</FONT>');

      L.Add('<br><FONT size=3>Note: Your access will be locked after five unsuccessful attempts.</FONT>');
      L.Add('<br><FONT size=3>For assistance, contact CRA''s T1 <a href="https://www.canada.ca/en/revenue-agency/services/e-services/digital-services-businesses/efile-electronic-filers/efile-helpdesk-support-t1-returns.html">EFILE Helpdesk</a> Support.</FONT>');
    end;

    L.Add('<P><FONT size=3><b>Current file(s):</b></FONT>');
    L.Add('<br>');

    L.Add('<table style="width:700; border-style: solid; border-width: 1px; border-color: #000000;" cellspacing="0">');
    L.Add('<tr>');
      L.Add('<td style="width:70px; background-color: #e0e0e0; text-align: center; font-size: 12px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-left-style: solid; border-left-width: 1px; border-left-color: #FFFFFF;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 8px;"><b>No.</b></td>');
      L.Add('<td style="width:200px; background-color: #e0e0e0; text-align: center; font-size: 12px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 8px;"><b>Document Type</b></td>');
      L.Add('<td style="width:300px; background-color: #e0e0e0; text-align: center; font-size: 12px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 8px;"><b>File Name</b></td>');
      L.Add('<td style="width:130px; background-color: #e0e0e0; text-align: center; font-size: 12px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 8px;"><b>File Size</b></td>');
    L.Add('</tr>');

    lRow:= 1;

    for lFile in Files do
    begin
      L.Add('<tr>');
        L.Add('<td style="width:70px; text-align: center; font-size: 11px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-left-style: solid; border-left-width: 1px; border-left-color: #FFFFFF;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 6px;">' + IntToStr(lRow) + '.</td>');
        L.Add('<td style="width:200px; text-align: center; font-size: 11px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 6px;">' + DocumentTypesFull[lFile.DocType] + '</td>');
        L.Add('<td style="width:300px; text-align: center; font-size: 11px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 6px;">' + ExtractFileName(lFile.FileName) + '</td>');
        L.Add('<td style="width:130px; text-align: center; font-size: 11px; font-family: Arial; border-style: solid; border-width: 1px; border-color: #000000;' + ' border-right-style: solid; border-right-width: 1px; border-right-color: #FFFFFF; padding: 6px;">' + Format('%.2f', [lFile.FileSize / 1024 / 1024])+' Mb' + '</td>');
      L.Add('</tr>');

      inc(lRow);
    end;
    L.Add('</table>');
    L.Add('<br><div style="text-align: right; margin-right: 150px; font-size: 11px; font-family: Arial;"><b>Total file size: ' + Format('%.2f', [TotalSize / 1024 / 1024]) + ' Mb' +'</b></div>');
    if AResponse.Success then
    begin
      L.Add('<br><FONT size=3><i>Keep all your supporting documents in case we ask to see them.</i></FONT>');
    end else
    begin
      L.Add('<br><FONT size=3><i>Correct the error(s) and resubmit</i></FONT>');
    end;

    L.Add('<HR>');
    L.Add('<br>Received: '+ DateTimeToStr(Now) +'');
    L.Add('</DIV></BODY></HTML>');
    L.SaveToFile(AFileName, TEncoding.UTF8);
    ShowMessageHTML(L.Text, 600);
  finally
    L.Free;
  end;
end;
// 20250709 Igor <<<
// 20250729 Igor >>>
procedure TfrmSERS2025.rbUseDACAuthClick(Sender: TObject);
begin
  rbUseEfilerNumPassAuth.Checked:= False;

  eAuthEfilerNum.Enabled:= False;
  eAuthPassword.Enabled:= False;
  GetDACButton.Enabled:= True;
  edDAC.Enabled:= True;
end;

procedure TfrmSERS2025.rbUseEfilerNumPassAuthClick(Sender: TObject);
begin
  rbUseDACAuth.Checked:= False;

  eAuthEfilerNum.Enabled:= True;
  eAuthPassword.Enabled:= True;
  GetDACButton.Enabled:= False;
  edDAC.Enabled:= False;
end;

procedure TfrmSERS2025.eAuthEfilerNumChange(Sender: TObject);
begin
  OnlineNo:= eAuthEfilerNum.Text;
end;

procedure TfrmSERS2025.eAuthPasswordChange(Sender: TObject);
begin
  Password:= eAuthPassword.Text;
end;
// 20250729 Igor <<<
// 20260427 Alex >>>
procedure TfrmSERS2025.FormClose(Sender: TObject; var Action: TCloseAction);
var
  lUserResponse: Integer;
begin
  if isUserSelectedFilesAttaching then
  begin
    lUserResponse:= MessageDlg('You selected "Yes" to the question: '                                  + EOL + EOL +
                               '"Do you want to submit the supporting documentation electronically?"'  + EOL + EOL +
                               'However, no document has been attached.'                               + EOL + EOL +
                               'Do you want to change your answer to "NO" and exit without attaching a document?', mtConfirmation, [mbYes, mbNo], 0);

    if lUserResponse = mrYes then
    begin
      isUserSelectedFilesAttaching:= False;
      Exit;
    end
    else
       Action := caNone;



  end;
end;
// 20260427 Alex <<<
end.
