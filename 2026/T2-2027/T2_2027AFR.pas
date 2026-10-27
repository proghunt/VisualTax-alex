unit T2_2027AFR;
{
//20170320 Igor
}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, Vcl.Grids,
  Vcl.DBGrids, Data.DB, uADCompDataSet, uADCompClient,
  vtMulti, vtDataBase, vtShared, Vcl.ValEdit, Vcl.OleCtrls, SHDocVw,
  IOUtils,
  T2_2027AutoFillFrm, T2_2027Declare, //20171122 Igor
  vtTransformNOA, //20220608 Igor
  vtCommon; //20170328 Igor

type
  TServerResponse = Record
    ReturnCode: string;
    ReturnCodeDescr: string;
    ResultCode: string;
    ResultCodeDescr: string;
    PayerName: string;
    //20170405 Igor >>>
    HaveHTMLBody: Boolean;
    NoticeType: string;
    SummaryText: string;
    //20170405 Igor <<<
    //DCN: string;//20170328 Igor
    UserCancelled: boolean; //20171120 Igor
  end;

  TCallBack = procedure(Sender: TObject; AResponse: TServerResponse; ADone, AHasAutofill, AHasNOA: Boolean) of Object; //20220610 Igor
  TLog = procedure(AMessage: String) of object;
  TAvailableReturns = record
    TaxYearEndYearMonthDay: string;
    TaxYearEndHourMinute: string;
		ReturnStatusTypeCode: string;
		ReturnStatusDate: string;
  end;
  //20220608 Igor >>>
  TAvailableNOAs = record
    TaxYearEndYearMonthDay: string;
    ArchiveID: string;
  end;
  //20220608 Igor <<<
  TRequestData = Record
  private
    function GetWebServiceUrl: string;
    function GetTrunkApplicationUrl: string;
    function GetSelectedReturn: TAvailableReturns;
    function GetSelectedNOA: TAvailableNOAs; //20220608 Igor
  public
    Domain: String;
    Servise: String;
    Auth_Param: String;
    SecretAccessKey: string;
    WebApplicationUrl: string;
    transform_xsl: string; //20220608 Igor

    UserName: string;
    PasswordDigest: string;
    Nonce: string;
    NonceB64: string;
    Created: string;
    TaxYear: string;
    TokenC: string;
    TokenDataAccess: String;
    RefreshToken: String;
    ExpireDatetime: String;
    ExpireDatetimeD: TDateTime; //20171120 Igor
    TokenTitle: string;
    T2ReturnBalanceIndicator, CorporationAccountBalanceIndicator, CorporationBNDataIndicator: boolean;
    SelectedTaxYearEndYearMonthDay: string;
    AvailableReturns: array of TAvailableReturns;
    //20220608 Igor >>>
    SelectedNOATaxYearEndYearMonthDay: string;
    AvailableNOAs: array of TAvailableNOAs;
    //20220608 Igor <<<
    property WebServiceUrl: string read GetWebServiceUrl;
    property TrunkApplicationUrl: string read GetTrunkApplicationUrl;
    property SelectedReturn: TAvailableReturns read GetSelectedReturn;
    property SelectedNOA: TAvailableNOAs read GetSelectedNOA; //20220608 Igor
  end;

  TSender = class(TThread)
  private
    FisSelect: boolean;
    FBN: string;
    FTaxYear, FTaxEndDate: string;
    FRelease: string;
    FCallBack: TCallBack;
    FLog: TLog;
    FServerResponse: TServerResponse;
    FDone: Boolean;
    FRequestData: TRequestData;
    FSOAPMessage: string;
    FSOAPResponse: string;
    FNeedCloseWebPage: Boolean;
    //FSaveDir: string;
    FTest: Boolean;
    FLastMessage: string;
    FReceivedFlName: String;
//    FxsltPath: string;
    WBDone: Boolean;
    FAutoSaveToMobileDB: Boolean;
    FNOADir: string; //20220608 Igor
    //20220610 Igor >>>
    FHasAutofill: boolean;
    FHasNOA: boolean;
    //20220610 Igor <<<
    procedure DoCallBack;
    procedure DoLog;
    procedure Log(AMessage: String);
    function GetInternetDateTime: TDateTime;
    function SetRequestDataInput: Boolean;
    function GenerateNonce: string;
    function GeneratePasswordDigest: String;
    function Password_Digest(ANonce, ACreated,
      APassword: ansistring): ansistring;
    procedure GenerateSOAPMessage;
    procedure SendSOAPMessage;
    procedure GetResultInfoServerError;
    procedure LinkToCRALogin;
    function HMACSHA256Encode(S, Key: PWideChar): string;
    procedure WaitTitleToken;
    procedure SaveRequestAFR;
//    procedure WBNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
//      const URL: OleVariant);
    function CreateTDDAccessSoapMessageXml: string;
    function CreateGetDCSoapMessageXml: string;
    function CreateGetCorporationDataSoapMessageXml: string;
    procedure ProcessRequestAFR;
    procedure ProcessNOA; //20220608 Igor
    function SOAPRequesrHeader: string;
    procedure RequestTaxDataElement;//20171120 Igor
    function GenerateFileName: string;//20171215 Igor
    function PrepareErrorHTM(const aResultFileName: string): string; // 20180530 Igor
  public
    constructor Create(ABN, ATaxYear, ATaxEndDate,
      ASaveDir: String; ACallBack: TCallBack; ALog: TLog;
      ANeedCloseWebPage, ATest: Boolean; ANOADir: string); //20220608 Igor
    procedure Execute; override;
  end;

  TfrmAFR = class(TForm)
    pgcMain: TPageControl;
    tsStart: TTabSheet;
    tsWork: TTabSheet;
    btnContinue: TButton;
    btnCancel: TButton;
    lblStart: TLabel;
    pgcWizard: TPageControl;
    tsSelectReturn: TTabSheet;
    tsProcess: TTabSheet;
    Label1: TLabel;
    Panel1: TPanel;
    btnPrev: TButton;
    btnNext: TButton;
    btnCancel2: TButton;
    tsFinish: TTabSheet;
    lblFinish: TLabel;
    conClients: TADConnection;
    tblClients: TADTable;
    dsClients: TDataSource;
    grClients: TDBGrid;
    Panel2: TPanel;
    Label3: TLabel;
    edFilter: TEdit;
    GroupBox1: TGroupBox;
    btnExecuteAFR: TButton;
    rgTestOrProd: TRadioGroup;
    vlReturnInfo: TValueListEditor;
    mmoLog: TMemo;
    chbAutoClose: TCheckBox;
    lblHTMLPath: TLabel;
    Panel3: TPanel;//20170328 Igor
    pnlViewOld: TPanel;//20170328 Igor
    btnViewOld: TButton;
    chbAutoSaveToMobileDB: TCheckBox;
    btnViewOldNOA: TButton;//20170328 Igor
    procedure btnCancelClick(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancel2Click(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure grClientsKeyPress(Sender: TObject; var Key: Char);
    procedure edFilterChange(Sender: TObject);
    procedure tblClientsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure grClientsTitleClick(Column: TColumn);
    procedure btnExecuteAFRClick(Sender: TObject);
    procedure btnViewOldClick(Sender: TObject);
    procedure btnViewOldNOAClick(Sender: TObject);//20170328 Igor
  private
    { Private declarations }
    FIsSilent: Boolean;//20171123 Igor
    FApp: TApp;
    FRet: TRetData; //20170328 igor
    FSender: TSender;
    FSelectedBN: string;
    FSpID: string;
    FPassword: string;
    FTaxYear, FTaxEndDate: string;
    FServerResponse: TServerResponse;
    FNOADir: string; //20220608 Igor
    FileNameNOA: string; //20220608 Igor
    procedure CallBack(Sender: TObject; AServerResponse: TServerResponse; ADone, AHasAutofill, AHasNOA: Boolean); //20220610 Igor
    procedure Log(AMessage: String);
    procedure StopThread;
    procedure PrevStep;
    procedure NextStep;
    function AllowNextStep: Boolean;
    procedure RefreshStep;
    procedure RecreateNOAFiles; //20220608 Igor
  public
    { Public declarations }
  end;

procedure AFR(AApp: TApp; ARet: TRetData = nil); //20170328 igor

implementation

{$R *.dfm}
{$R 'T2_NOA\T2_NOA.res'} //20220608 Igor

uses
  IdSNTP, System.DateUtils, Soap.EncdDecd, TXPCrypto, System.Win.ComObj,
  Xml.XMLDoc, Xml.XMLIntf, WEB.HTTPApp, Winapi.ShellAPI, Crypt2, System.StrUtils,
  ActiveX, System.RegularExpressions, MSXML2_TLB, MSHTML,
  T2_2027GetParamAFR, IdGlobalProtocols, //20171123 Igor
  vtFillDBMain, T2_2027TrimStr, vtShowMessageHTML; //20170403 Igor // 20180530 Igor

const
  c_FinishOkMessage =
    '  The %s tax return for %s has been assessed. ';

  c_FinishNoDataMessage =
    ' No data received';  // 20180530 Igor

  c_SPID_TDD = 'VT50'; //20250617 Igor //20250601//'VT49'; //20241126 //'VT47'; //20231028 'VT45'; //20221014 //'VT44'; //'VT43';//20211028  //'VT41'; //'VT42'; //20220608 Igor


  c_Domain_Prod = 'https://apps.cra-arc.gc.ca'; //20171206
  c_Domain_Test = 'https://apps-ct.cra-arc.gc.ca';

  c_Servise_Prod ='/ebci/awsc/tdd/ws/202205/T2TaxDataDeliveryService'; //20211204  //20220608 Igor
                  //'/ebci/awsc/tdd/ws/%s/T2TaxDataDeliveryService'; //2021112
  c_Servise_Test ='/ebci/awsc/tdd/ws/202205/CertTestT2Service';  //20211204     //20220608 Igor
                 // '/ebci/awsc/tdd/ws/%s/CertTestT2Service';
                  // /ebci/awsc/tdd/ws/201910/T2TaxDataDeliveryService

  //%s = ${release}   //20171204


  c_stageTDDT2 = 'stageTDDT2';//	Operation to auto-transfer BN, and retrieve Web Access Token.
  c_getTDDAccessToken = 'getTDDAccessToken';//	Operation to retrieve Data Access and Refresh Tokens.
  c_getDataChoices = 'getDataChoices';//	Operation to retrieve list of available TYE files.
  c_getCorporationData = 'getCorporationData';//	Operation to retrieve user-selected corporation data.
  c_refreshToken = 'refreshToken';//	Operation to retrieve new Data Access Token.

  c_transform_xsl = 't2-transform.xsl';  //20220608 Igor

  c_auth_Param = '/gol-ged/awsc/tdd/ws/t2';

  c_WebApplicationURL_Test = 'https://apps-ct.cra-arc.gc.ca/ebci/awsc/tdd/certtest/auth/start';
  c_WebApplicationURL_Prod = 'https://ams-sga.cra-arc.gc.ca/gol-ged/awsc/tdd/auth/start';

  c_secretAccessKey_2019_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N'; //Received Nov 23, 2020 //'XNTcLvOYSHmMsZoy7isivHCCkepKoFT4';  //20201123 //20201126 Igor
  c_secretAccessKey_2019_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy'; //'5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';  //20210630  //used the same as tes?  maybe it was production given to me

  c_secretAccessKey_2020_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';
  c_secretAccessKey_2020_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy';

  //20210629
  c_secretAccessKey_2021_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';
  c_secretAccessKey_2021_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy';  //20211115
                              //vt-43 secret key   4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy  //chad 20211101  Seems to be the same with T2-2021 in VT-2042
  //20210629
  c_secretAccessKey_2022_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';
  c_secretAccessKey_2022_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy'; //20220613 '4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy';  //20211115

//20210629
  c_secretAccessKey_2023_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N'; //20221013
  c_secretAccessKey_2023_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy'; //20240322 used same as 2022 ???

//20240516
  c_secretAccessKey_2024_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';
  c_secretAccessKey_2024_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy'; //20240516 used same as 2023 and 2022 ???

//20241018 same secrete keys used for several years  SAME?
  c_secretAccessKey_2025_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N'; //'5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';//20250604 //'5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';
  c_secretAccessKey_2025_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy';  //20250605     //'4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy';

   {
  //20251022
  c_secretAccessKey_2026_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N'; //'5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';//20250604 //'5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';
  c_secretAccessKey_2026_Prod ='4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy';  //20250605     //'4uBfxRLxnNnbzVfKuwIO5munPGLUNQIy';
  }
//20260612  for t2-2026 b
  c_secretAccessKey_2026_Test ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';  //20260612
  c_secretAccessKey_2026_Prod ='5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N';  //20260623
  //5NMwwzg6dOL582sQlFqB2T1Z4Ye8IS1N  test received Jun 12 2026

  // do not change it unless xnoa-transform files were changed for current year
procedure TfrmAFR.RecreateNOAFiles; //20220608 Igor
var cFile: string;
    I: Integer;

type TNOA_File = record
    ResName: string;
    FileName: string;
  end;

const NOA_Files: array[0..11] of TNOA_File =
    (
      (ResName : 'BANNER_HTML'; FileName : 'banner.html'),
      (ResName : 'BANNER_FR_HTML'; FileName : 'banner.fr.html'),
      (ResName : 'FOOTER_HTML'; FileName : 'footer.html'),
      (ResName : 'FOOTER_FR_HTML'; FileName : 'footer.fr.html'),
      (ResName : 'HEADER_HTML'; FileName : 'header.html'),
      (ResName : 'T2_TRANSFORM_XSL'; FileName : 't2-transform.xsl'),
      (ResName : 'CRA_BRANDING_CSS'; FileName : 'css\cra-branding.css'),
      (ResName : 'THEME_MIN_CSS'; FileName : 'css\theme.min.css'),
      (ResName : 'FAVICON_ICO'; FileName : 'images\favicon.ico'),
      (ResName : 'SIG_BLK_EN_SVG'; FileName : 'images\sig-blk-en.svg'),
      (ResName : 'SIG_BLK_FR_SVG'; FileName : 'images\sig-blk-fr.svg'),
      (ResName : 'WMMS_BLK_SVG'; FileName : 'images\wmms-blk.svg')
    );

  procedure SaveResourceToFile(AResName, AFileName, AResType: string);
  var
    FResStream: TResourceStream;
    FFileStream: TFileStream;
  begin
    FResStream := TResourceStream.Create(FindClassHInstance(TfrmAFR), AResName, PChar(AResType)) ;
    try
      FFileStream := TFileStream.Create(AFileName, fmCreate) ;
      try
        FFileStream.CopyFrom(FResStream, 0) ;
      finally
        FFileStream.Free;
      end;
    finally
      FResStream.Free;
    end;
  end;

  procedure CopyFiles(A: array of TNOA_File; AResource: string);
  var I: integer;
  begin
    for I := 0 to Length(A) - 1 do
    begin
      cFile := FNOADir + A[I].FileName;
      ForceDirectories(ExtractFilePath(cFile));
      SaveResourceToFile(A[I].ResName, cFile, AResource);
    end;
  end;

begin
  FNOADir := IncludeTrailingPathDelimiter(FApp.AppDir) + 'NOA\';
  if not ForceDirectories(FNOADir) then
  begin
    UserMsg('Cannot create '+ QuotedStr(FNOADir));
    Exit;
  end;
  try
    CopyFiles(NOA_Files, 'T2_NOA');
  except on E: Exception do
    ExceptMsg(Exception.Create('Error in RecreateNOAFiles: ' + E.Message));
  end;
end;

procedure AFR(AApp: TApp; ARet: TRetData = nil);  //20170328 Igor
begin
  with TfrmAFR.Create(Application) do
  begin
    try
      FApp := AApp;
      FRet := ARet; //20170328 Igor
      RecreateNOAFiles; //20220608 Igor
      ShowModal;
    finally
      Free;
    end;
  end;
end;


function ClearXML(AXML: String): string;
begin
  Result := TRegEx.Replace(AXML, '<[^/: >]*:', '<');
  Result := TRegEx.Replace(Result, '</[^/: >]*:', '</');
end;

function TfrmAFR.AllowNextStep: Boolean;
begin
  if pgcWizard.ActivePage = tsSelectReturn then
  begin
    Result := not tblClients.IsEmpty;
    if Not Result then
      MessageDlg('No return selected.', mtWarning, [mbOk], 0);
  end
  else
  if pgcWizard.ActivePage = tsProcess then
  begin
    {TODO : check}
    Result := True;
  end
  else
  //if pgcWizard.ActivePage = tsFinish then
  begin
    Result := True;
  end;
end;

//20171219 Igor>>>
function NowUTC: TDateTime;
var
  system_datetime: TSystemTime;
begin
  GetSystemTime(system_datetime);
  Result := SystemTimeToDateTime(system_datetime);
end;

function GetTimeZone(AStr: string): Real;
var
  S: String;
  I: Integer;
  Z: Integer;
begin
  S := '';
  Z := 1;
  for I := Length(AStr) downto 1 do
  begin
    if (AStr[I] <> 'Z') and (AStr[I] <> '-') and (AStr[I] <> '+') then
      S := AStr[I] + S
    else
    begin
      if AStr[I] = '-' then
        Z := -1;
      Break;
    end;
  end;

  Result := Z * StrToTimeDef(S, 0);
end;
//20171219 Igor<<<

procedure TfrmAFR.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAFR.btnContinueClick(Sender: TObject);
begin
  pgcMain.ActivePage := tsWork;
  RefreshStep;
end;

procedure TfrmAFR.btnPrevClick(Sender: TObject);
begin
  PrevStep;
end;

procedure TfrmAFR.btnViewOldClick(Sender: TObject);//20170328 Igor
var
  FileName: string;
begin
  FileName := MkTddFileName(GetCurrentRetNo);
  if FileExists(FileName) then
    ShellExecute(0, 'OPEN', PChar(FileName), '', '', SW_SHOWNORMAL);
end;

procedure TfrmAFR.btnViewOldNOAClick(Sender: TObject); //20220608 Igor
begin
  if FileExists(FileNameNOA) then
    ShellExecute(0, 'OPEN', PChar(FileNameNOA), '', '', SW_SHOWNORMAL);
end;

procedure TfrmAFR.CallBack(Sender: TObject; AServerResponse: TServerResponse; ADone, AHasAutofill, AHasNOA: Boolean); //20220610 Igor
begin
  FSender := nil;
  btnExecuteAFR.Tag := 0;
  if ADone then
    btnExecuteAFR.Caption := 'Retry request for AFR'      //20170330
  else
    btnExecuteAFR.Caption := 'Try request again for AFR'; //20170330
  btnNext.Enabled := True; //20170403 Igor
  FServerResponse := AServerResponse;
  if not ADone then
  begin
    if AServerResponse.ReturnCodeDescr <> '' then
      Log('Return info: ' + AServerResponse.ReturnCodeDescr);
    if AServerResponse.ResultCodeDescr <> '' then
      Log('Result info: ' + AServerResponse.ResultCodeDescr);
    NextStep;
  end
  else
  begin
    //users are authorized to see the BN tax data being requested – Your authorization was successful
    //20220610 Igor >>>
    if AHasAutofill and not AHasNOA then
      ShowMessage(Chr(13)+Chr(13)+
         'Token transfer was successful. Your request to see the BN '+GetCorpBusNo(GetCurrentRetNo)+' tax data was authorized by CRA'
         +Chr(13)+' '
         +Chr(13)+' ')
    else if AHasNOA and not AHasAutofill then
      ShowMessage(Chr(13)+Chr(13)+
         'Token transfer was successful. Your request to see the BN '+GetCorpBusNo(GetCurrentRetNo)+' NOA was authorized by CRA'
         +Chr(13)+' '
         +Chr(13)+' ')
    else
      ShowMessage(Chr(13)+Chr(13)+
         'Token transfer was successful. Your request to see the BN '+GetCorpBusNo(GetCurrentRetNo)+' tax data and NOA was authorized by CRA'
         +Chr(13)+' '
         +Chr(13)+' ');
    //20220610 Igor <<<
  //20170405 Igor >>>
//    ShellExecute(0, 'OPEN', PChar(IncludeTrailingPathDelimiter(FApp.AppDir) +
//        'AFR\' + 'AFR-' + FSelectedBN + '.txt'), '', '', SW_SHOWNORMAL);
    if chbAutoSaveToMobileDB.Checked and AHasAutofill then //20220610 Igor
    begin
      SilentAddFile(FApp, RetList[GetCurrentRetNo].SourceFlName, MkTddFileName(GetCurrentRetNo), 'AFR');
      SilentAddFile(FApp, RetList[GetCurrentRetNo].SourceFlName, ChangeFileExt(MkTddFileName(GetCurrentRetNo), '.xml'), 'AFR');
      //20171219 Igor>>>
      if FileExists(ChangeFileExt(MkTddFileName(GetCurrentRetNo), '-COR.txt')) then
        SilentAddFile(FApp, RetList[GetCurrentRetNo].SourceFlName, ChangeFileExt(MkTddFileName(GetCurrentRetNo), '-COR.txt'), 'AFR');
      //20171219 Igor<<<
    end;
    NextStep;
//20170405 Igor <<<
    //20171123 Igor>>
    //20220610 Igor >>>
    if AHasAutofill then
      if MessageDlg('Apply received data now?', mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
      begin
        TThread.CreateAnonymousThread(procedure
          begin
            TThread.Synchronize(nil, procedure
              begin
                with TAutoFillFrmT2_2027.Create(Application.MainForm) do
                  try
                    ShowModal;
                  finally
                    Free;
                  end;
              end)
          end).Start;
        FIsSilent := True;
        Close;
      end
    else
      Close;
    //20220610 Igor <<<
    //20171123 Igor<<
  end;
end;

procedure TfrmAFR.btnExecuteAFRClick(Sender: TObject);
begin
   if btnExecuteAFR.Tag = 0 then
  begin
    btnExecuteAFR.Tag := 1;
    btnExecuteAFR.Caption := 'Stop';
    btnNext.Enabled := False;
    mmoLog.Lines.Clear;
    FSender := TSender.Create(FSelectedBN, FApp.AppYear, FTaxEndDate,
      ExtractFileDir(MkTddFileName(GetCurrentRetNo)), CallBack,
      Log, chbAutoClose.Checked, rgTestOrProd.ItemIndex = 1, FNOADir); //20220608 Igor
  end
  else
    StopThread;
end;

procedure TfrmAFR.edFilterChange(Sender: TObject);
begin
  tblClients.Filtered := False;
  tblClients.Filtered := True;
  tblClients.First;
end;

procedure TfrmAFR.grClientsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    NextStep;
end;

procedure TfrmAFR.grClientsTitleClick(Column: TColumn);
begin
  if tblClients.IndexFieldNames = Column.FieldName then
    tblClients.IndexFieldNames := ''
  else
    tblClients.IndexFieldNames := Column.FieldName;
end;

procedure TfrmAFR.Log(AMessage: String);
begin
  mmoLog.Lines.Add(FormatDateTime('YYYY/MM/DD hh:nn:ss', Now) + ': ' + AMessage);
end;

procedure TfrmAFR.btnNextClick(Sender: TObject);
begin
  NextStep;
end;

procedure TfrmAFR.btnCancel2Click(Sender: TObject);
begin
  if pgcWizard.ActivePageIndex = (pgcWizard.PageCount - 1) then
  begin
    pgcWizard.ActivePageIndex := 0;
    RefreshStep;
  end
  else
    ModalResult := mrCancel;
end;

procedure TfrmAFR.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //20171123 Igor>>
  if FIsSilent then
  begin
    StopThread;
    CanClose := True;
  end
  else
  begin
  //20171123 Igor<<
    if ModalResult <> mrOk then
    begin
      if MessageDlg('Are you sure you want to quit?', mtConfirmation, [mbYes, mbCancel], 0) <> mrYes then
        CanClose := False;
      if CanClose then
        StopThread;
    end;
  end;//20171123 Igor
end;

procedure TfrmAFR.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to pgcMain.PageCount - 1 do
    pgcMain.Pages[I].TabVisible := False;
  for I := 0 to pgcWizard.PageCount - 1 do
    pgcWizard.Pages[I].TabVisible := False;
  pgcMain.ActivePage := tsStart;
  pgcWizard.ActivePageIndex := 0;
  FIsSilent := False; //20171123 Igor
end;

procedure TfrmAFR.NextStep;
begin
  if not AllowNextStep then
    Exit;
  if pgcWizard.ActivePageIndex = pgcWizard.PageCount - 1 then
  //20170328 igor >>>
  begin
    ModalResult := mrOk;
  end
  //20170328 igor<<<
  else
  begin
    pgcWizard.ActivePageIndex := pgcWizard.ActivePageIndex + 1;
    RefreshStep;
  end;
end;

procedure TfrmAFR.PrevStep;
begin
  if (pgcWizard.ActivePageIndex = 0) or
     ((pgcWizard.ActivePageIndex = 1) and (FRet <> nil)) then  //20170328 Igor
    pgcMain.ActivePage := tsStart
  else
    pgcWizard.ActivePageIndex := pgcWizard.ActivePageIndex - 1;
  btnNext.Enabled := True;
end;

procedure TfrmAFR.RefreshStep;  //20170328 igor All proc
var
  I: Integer;
  WorkRetNo: Integer;
  FileName: string; //20220608 Igor
  FileDate: TDateTime;
  bVisible: boolean; //20220608 Igor
begin
  if pgcWizard.ActivePageIndex = pgcWizard.PageCount - 1 then
  begin
    btnNext.Caption := 'Finish';
    btnCancel2.Enabled := False;
  end
  else
  begin
    btnNext.Caption := 'Next >>>';
    btnCancel2.Enabled := True;
  end;
  if (pgcWizard.ActivePage = tsSelectReturn) AND (FRet <> nil) then
    pgcWizard.ActivePage := tsProcess;

  if pgcWizard.ActivePage = tsSelectReturn then
  begin
    if tblClients.IsEmpty then
      SetTableName(conClients, tblClients, IncludeTrailingPathDelimiter(FApp.Dir_Cur) + FApp.ClientsDBLite, ClientsTableLite, '');
  end
  else
  if pgcWizard.ActivePage = tsProcess then
  begin
    btnNext.Enabled := False;
    btnExecuteAFR.Caption := 'Submit AFR request to CRA';  //20170330  //20171206 CON
    btnExecuteAFR.Tag := 0;
    if FRet <> nil then
    begin
      FSelectedBN := FetchElm(GetCurrentRetNo, 'T2',1);
      FTaxEndDate := Trim(FetchElm(GetCurrentRetNo, 'T2', 11));
      btnExecuteAFR.Enabled := FSelectedBN <> '';
    end
    else
    begin
      WorkRetNo := FApp.OpenReturn(FApp.Dir_Cur, tblClients.FieldByName('FILE_NAME').AsString,
        False, False);
      if WorkRetNo > 0 then
      begin
        try
          FSelectedBN := FetchElm(WorkRetNo, 'T2',1);
          FTaxEndDate := Trim(FetchElm(WorkRetNo, 'T2', 11));
          btnExecuteAFR.Enabled := FSelectedBN <> '';
        finally
          DeEnlistReturn(WorkRetNo);
        end;
      end
      else
      begin
        btnExecuteAFR.Enabled := False;
      end
    end;
    vlReturnInfo.Strings.BeginUpdate;
    try
      vlReturnInfo.Strings.Clear;
      vlReturnInfo.InsertRow('BN', FSelectedBN, True);
    finally
      vlReturnInfo.Strings.EndUpdate;
    end;
    //20220608 Igor >>>
    bVisible := false;
    //20170328 Igor >>>
    FileName := MkTddFileName(GetCurrentRetNo);
    if FileExists(FileName) then
    begin
      bVisible := True;
      if FileAge(FileName, FileDate) then
        btnViewOld.Caption := 'View ARF response from ' + DateTimeToStr(FileDate);
    end
    else
      pnlViewOld.Visible := False;
    //20170328 Igor<<<
    FileNameNOA := TPath.Combine(FNOADir, FSelectedBN+'.html');
    if FileExists(FileNameNOA) then
    begin
      bVisible := True;
      if FileAge(FileNameNOA, FileDate) then
        btnViewOldNOA.Caption := 'View NOA response from ' + DateTimeToStr(FileDate);
    end;
    //20220608 Igor<<<
    pnlViewOld.Visible := bVisible
  end
  else
  if pgcWizard.ActivePage = tsFinish then
  begin
    if StartsText('FOUND', FServerResponse.ResultCode) then
    begin
      lblFinish.Caption := Format(c_FinishOkMessage, [FApp.AppYear,
        FServerResponse.PayerName]);
      lblHTMLPath.Caption := MkTddFileName(GetCurrentRetNo);
    end
    else
    begin
      lblFinish.Caption := c_FinishNoDataMessage;
      lblHTMLPath.Caption := '';
    end;
  end;

end;

procedure TfrmAFR.StopThread;
begin
  if Assigned(FSender) then
  begin
    FSender.Terminate;
    while FSender <> nil do
    begin
      sleep(50);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrmAFR.tblClientsFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  I: Integer;
begin
  Accept := True;
  if edFilter.Text = '' then
    Exit;
  for I := 0 to tblClients.FieldCount - 1 do
  begin
    if Pos(LowerCase(edFilter.Text), LowerCase(tblClients.Fields[I].AsString)) > 0 then
      Exit;
  end;
  Accept := False;
end;

{ TSender }

constructor TSender.Create(ABN, ATaxYear, ATaxEndDate,
  ASaveDir: String; ACallBack: TCallBack; ALog: TLog;
  ANeedCloseWebPage, ATest: Boolean; ANOADir: string); //20220608 Igor
begin
  inherited Create(False);
  //20220610 Igor >>>
  FHasAutofill := false;
  FHasNOA := false;
  //20220610 Igor <<<
  FreeOnTerminate := True;
  FBN := ABN;

  //20201123
  FTaxYear:= '2025'; //2025061 ALEX  Igor //'2024'; //jz 20241123 //'2023'; //'2019';  //20211204 //20220801 //20231211 Igor
  //FTaxYear := '2018';
  FRelease := '202205'; //From integration guide schema? 20250617 Igor  //'201910'; //'201910'; //20201125 Igor  //20211204 //20211208 Igor //20220608 Igor
  (*
   $r{release} = The releease ID of the schema that will be used to exlchange data with thee Web Service.  For the initial realseae
   se of T2 AFR, the value will be 201710. (mandatory)
  *)
  FTaxEndDate := ReplaceStr(ATaxEndDate, '/', '-');
//  FSaveDir := ASaveDir;
//  FxsltPath := IncludeTrailingPathDelimiter(FSaveDir) + 'notice-html.xsl';
  FCallBack := ACallBack;
  FNeedCloseWebPage := ANeedCloseWebPage;
  FLog := ALog;
  FDone := False;
  FTest := ATest;
  FNOADir := ANOADir; //20220608 Igor
end;

function TSender.CreateGetCorporationDataSoapMessageXml: string;
const
  c_boolStr: array[Boolean] of string =
    ('false', 'true');
var cReturnDescription, cNOADescription: string; //20220608 Igor
begin
  //20220608 Igor >>>
  cReturnDescription := '';
  if not FRequestData.SelectedTaxYearEndYearMonthDay.IsEmpty then
    cReturnDescription :=
      '<AvailableReturns>'+
      '<T2ReturnDescription>'+
      '<TaxYearEndYearMonthDay>' + FRequestData.SelectedReturn.TaxYearEndYearMonthDay + '</TaxYearEndYearMonthDay>'+
      '<TaxYearEndHourMinute>' + FRequestData.SelectedReturn.TaxYearEndHourMinute + '</TaxYearEndHourMinute>'+
      '<ReturnStatusTypeCode>' + FRequestData.SelectedReturn.ReturnStatusTypeCode + '</ReturnStatusTypeCode>'+
      '<ReturnStatusDate>' + FRequestData.SelectedReturn.ReturnStatusDate + '</ReturnStatusDate>'+
      '</T2ReturnDescription>'+
  		'</AvailableReturns>';
  cNOADescription := '';
  if not FRequestData.SelectedNOATaxYearEndYearMonthDay.IsEmpty then
    cNOADescription :=
      '<AvailableNOAs>'+
      '<T2NOADescription>'+
      '<TaxYearEndYearMonthDay>' + FRequestData.SelectedNOA.TaxYearEndYearMonthDay + '</TaxYearEndYearMonthDay>'+
      '<ArchiveID>' + FRequestData.SelectedNOA.ArchiveID + '</ArchiveID>'+
      '</T2NOADescription>'+
      '</AvailableNOAs>';

  FSOAPMessage := SOAPRequesrHeader +
    '<S:Body>'+
    '<GetCorporationData xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/bn/1-0-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">'+
    '<TokenIdentifier>' + FRequestData.TokenDataAccess + '</TokenIdentifier>'+
		'<T2ReturnBalanceIndicator>' + c_boolStr[FRequestData.T2ReturnBalanceIndicator] + '</T2ReturnBalanceIndicator>'+
		'<CorporationAccountBalanceIndicator>' + c_boolStr[FRequestData.CorporationAccountBalanceIndicator] + '</CorporationAccountBalanceIndicator>'+
		'<CorporationBNDataIndicator>' + c_boolStr[FRequestData.CorporationBNDataIndicator] + '</CorporationBNDataIndicator>'+
		cReturnDescription +
		cNOADescription +
    '</GetCorporationData>'+
    '</S:Body>'+
    '</S:Envelope>';
  //20220608 Igor <<<

  Log('Request for get AFR prepared');
end;

function TSender.CreateGetDCSoapMessageXml: string;
begin
  FSOAPMessage := SOAPRequesrHeader +
    '<S:Body>'+
        '<GetDataChoices xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/bn/1-0-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">'+
            '<TokenIdentifier>'+FRequestData.TokenDataAccess+'</TokenIdentifier>'+
        '</GetDataChoices>'+
    '</S:Body>'+
  '</S:Envelope>';

  Log('Request for get AFR prepared');
end;

function TSender.CreateTDDAccessSoapMessageXml: string;
begin
  FSOAPMessage := SOAPRequesrHeader +
    '<S:Body>'+
    '<GetTDDAccessToken xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/2-1-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">'+
    '<TokenIdentifier>' + FRequestData.TokenTitle + '</TokenIdentifier>'+
    '</GetTDDAccessToken>'+
    '</S:Body>'+
    '</S:Envelope>';

  Log('Request for get AFR prepared');
end;

procedure TSender.DoCallBack;
begin
  if Assigned(FCallBack) then
    FCallBack(Self, FServerResponse, FDone, FHasAutofill, FHasNOA); //20220610 Igor
end;

procedure TSender.DoLog;
begin
  if Assigned(FLog) then
    FLog(FLastMessage);
end;

procedure TSender.Execute;
begin
  FServerResponse.UserCancelled := True; //20171120 Igor
  FisSelect := False; //20171120 Igor
  CoInitialize(Nil);
  try
    try
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      if not SetRequestDataInput then
        Exit;
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      GenerateSOAPMessage;
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      SendSOAPMessage;
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      GetResultInfoServerError;
      if Terminated then
      begin
        Log('Process stopped');
        Exit;
      end;
      if FServerResponse.ReturnCode = '0' then
      begin
        LinkToCRALogin;
        if Terminated then
        begin
          Log('Process stopped');
          Exit;
        end;
        if FRequestData.TokenTitle <> '' then
        begin
          CreateTDDAccessSoapMessageXml;
          if Terminated then
          begin
            Log('Process stopped');
            Exit;
          end;
          SendSOAPMessage;
          if Terminated then
          begin
            Log('Process stopped');
            Exit;
          end;
          GetResultInfoServerError;
          if Terminated then
          begin
            Log('Process stopped');
            Exit;
          end;
          if FServerResponse.ReturnCode = '1' then
          begin
            CreateGetDCSoapMessageXml;
            if Terminated then
            begin
              Log('Process stopped');
              Exit;
            end;
            SendSOAPMessage;
            if Terminated then
            begin
              Log('Process stopped');
              Exit;
            end;
            GetResultInfoServerError;
            if Terminated then
            begin
              Log('Process stopped');
              Exit;
            end;
            if FServerResponse.ReturnCode = '20' then
            begin
              //Request Tax Data Element
              Synchronize(RequestTaxDataElement);
              if not FisSelect then
              begin
                FServerResponse.UserCancelled := True;
                Log('User cancelled');
                Exit;
              end;
              //20171219 Igor>>>
              if (NowUTC > FRequestData.ExpireDatetimeD) then//20171219 Igor
              begin
                TThread.Synchronize(nil, procedure
                  begin
                    ShowMessage('The session time has been exhausted. Please restart the task.');
                  end);
                Log('The session time has been exhausted. Please restart the task.');
                Exit;
              end;

              CreateGetCorporationDataSoapMessageXml;
              if Terminated then
              begin
                Log('Process stopped');
                Exit;
              end;
              SendSOAPMessage;
              if Terminated then
              begin
                Log('Process stopped');
                Exit;
              end;
              GetResultInfoServerError;
              if Terminated then
              begin
                Log('Process stopped');
                Exit;
              end;
              if (FServerResponse.ResultCode = 'FOUND') or
                 (FServerResponse.ResultCode = 'FOUND_INCOMPLETE') then
              begin
                SaveRequestAFR;
                if Terminated then
                begin
                  Log('Process stopped');
                  Exit;
                end;
                ProcessRequestAFR;
              end
            end;
          end;
        end;
      end;
    finally
      Synchronize(DoCallBack);
    end;
  finally
    CoUninitialize;
  end;
end;
//20171215 Igor>>
function TSender.GenerateFileName: string;
begin
  Result := 'AFR' + Trim(FBN) + '_' + FormatDateTime('YYYYMMDD_hhnnss', Now);
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

function TSender.PrepareErrorHTM(const aResultFileName: string): string; // 20180530 Igor
var
  htmlSource: TStringList;
  source: string;
  keyWord,replacementString:string;
  i, startPos: integer;
begin
  htmlSource := TStringList.Create;
  htmlSource.LoadFromFile(AppDir +'\'+ 'AFRErrorTemplate.htm');
  For i := 0 to htmlSource.Count - 1 do
  begin
    keyWord           := '!ErrCode!';
    replacementString := FServerResponse.ReturnCode;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!ErrDesc!';
    replacementString := FServerResponse.ReturnCodeDescr;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!BNNUMBER!';
    replacementString := FBN;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!TaxYear!';
    replacementString := FTaxYear;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);

    keyWord           := '!TaxEndDate!';
    replacementString := FTaxEndDate;
    startPos := pos(keyWord, htmlSource[i]);
    if  startPos > 0 then
      htmlSource[i] := StringReplace(htmlSource[i], keyWord , replacementString,[rfReplaceAll]);
  end;
  if not DirectoryExists(ExtractFileDir(aResultFileName)) then
    ForceDirectories(ExtractFileDir(aResultFileName));
  htmlSource.SaveToFile(aResultFileName);
  Result := htmlSource.Text; // 20180530 Igor
  htmlSource.Free;
end;
//20171215 Igor<<
function TSender.GenerateNonce: string;
var
  randomInt: integer;
begin
  randomInt := Random(1000000);
  Result := Format('%.*d', [7, randomInt]) + FormatDateTime('dddddhh:nn:ss.zzz', Now());
end;

function TSender.GeneratePasswordDigest: String;
var
  pDigest: string;
begin
  Result := Trim(Password_Digest(FRequestData.Nonce, FRequestData.Created, FRequestData.SecretAccessKey));
end;
function TSender.SOAPRequesrHeader: string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8"?>'+
      '<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">'+
      '<S:Header>'+
      '<wsse:Security S:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+
      '<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
      '<wsse:Username>' + FRequestData.UserName + '</wsse:Username>'+
      '<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">'
        + FRequestData.PasswordDigest + '</wsse:Password>'+
      '<wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">'
        + FRequestData.NonceB64 + '</wsse:Nonce>'+
      '<wsu:Created>' + FRequestData.Created + '</wsu:Created>'+
      '</wsse:UsernameToken>'+
      '</wsse:Security>'+
      '</S:Header>';
end;

procedure TSender.GenerateSOAPMessage;
begin
  FSOAPMessage := SOAPRequesrHeader+
      '<S:Body>'+
      '<StageTDDT2 xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/bn/1-0-0" xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">'+
      '<BusinessNumber>' + FBN + '</BusinessNumber>'+
      '</StageTDDT2>'+
      '</S:Body>'+
      '</S:Envelope>';
  Log('Request for authorization prepared');  //20170328 CON
end;

function TSender.Password_Digest(ANonce, ACreated, APassword: AnsiString): AnsiString;
var
  crypt: TTXPCrypto;
  bytesToHash, nonceBytes, CreatedBytes, passwordBytes: TBytes;

  function GetBytes(const AText: ansistring): TBytes;
  begin
    SetLength(result, Length(AText));
    if Length(AText) > 0 then
      Move(AText[1], result[0], Length(AText));
  end;

  function Concat(const AParam1, AParam2, AParam3: TBytes): TBytes;
  var
    Idx: integer;
  begin
    SetLength(result, Length(AParam1) + Length(AParam2) + Length(AParam3));
    Idx := 0;
    Move(AParam1[0], result[Idx], Length(AParam1));
    Inc(Idx, Length(AParam1));
    Move(AParam2[0], result[Idx], Length(AParam2));
    Inc(Idx, Length(AParam2));
    Move(AParam3[0], result[Idx], Length(AParam3));
  end;

begin
  crypt := TTXPCrypto.Create;
  try
    nonceBytes := GetBytes(ANonce);
    CreatedBytes := GetBytes(ACreated);
    passwordBytes := GetBytes(APassword);
    bytesToHash := Concat(nonceBytes, CreatedBytes, passwordBytes);
    result := crypt.base64Encode(crypt.SHA1Hash(bytesToHash))
  finally
    crypt.free;
  end;
end;

procedure TSender.ProcessNOA; //20220608 Igor
var cFile: string;
    I: integer;
begin
  if FRequestData.SelectedNOATaxYearEndYearMonthDay.IsEmpty then Exit;
  cFile := TPath.Combine(FNOADir, FBN+'.xml');
  I := Pos('?>', FSOAPResponse) + 1;
  FSOAPResponse := '<?xml version=''1.0'' encoding=''ISO-8859-1''?>' + '<?xml-stylesheet type=''text/xsl'' href='''+ FRequestData.transform_xsl +'''?>' + Copy(FSOAPResponse, I + 1, MaxInt); //20220608 Igor
  with TStringStream.Create(FSOAPResponse) do
  begin
    try
      SaveToFile(cFile);
    finally
      free;
    end;
  end;
  Synchronize(procedure
    begin
      TransformNOA(cFile);
      //20220608 Igor >>>
      DeleteFile(cFile);
      cFile := ChangeFileExt(cFile, '.html');
      if FileExists(cFile) then
        ShellExecute(0, 'OPEN', PChar(cFile), '', '', SW_SHOWNORMAL);
      //20220608 Igor <<<
    end);
end;

procedure TSender.ProcessRequestAFR;
var
  SL: TStringList;
  X: XML.XMLDoc.TXMLDocument;
  N, Data, COR: IXMLNode;

  function TraverseParseConcatXML(StartNode: IXMLNode): IXMLNode;
  var
    i: integer;
    s: string;
  begin
    result := nil;
    if SameText(StartNode.NodeName, 'Correspondence') then Exit; //20220609 Igor
    for i := 0 to StartNode.ChildNodes.count - 1 do
    begin
      if StartNode.ChildNodes[i].HasChildNodes then
      begin
        if StartNode.ChildNodes[i].IsTextElement then
        begin
		  //20201126 Igor >>>
          s := StartNode.ChildNodes[i].ParentNode.ParentNode.NodeName + AFRStringDelimiter;
          s := s + StartNode.ChildNodes[i].ParentNode.NodeName + AFRStringDelimiter;
          s := s + StartNode.ChildNodes[i].NodeName + AFRStringDelimiter;
          s := s + '01' + AFRStringDelimiter;
          s := s + StartNode.ChildNodes[i].Text;
          //20201126 Igor <<<
          SL.Add(s);
        end;
        result := TraverseParseConcatXML(StartNode.ChildNodes[i]);
        if result <> nil then
          break;
      end;
    end;
  end;
begin
  try
    SL := TStringList.Create;
    try
      X :=  XML.XMLDoc.TXMLDocument.Create(Application);
      try
        X.XML.Text := ClearXML(TFile.ReadAllText(FReceivedFlName));
        X.Active := True;
        N := X.DocumentElement;
        if (N = nil) or (N.NodeName <> 'Envelope') then
          raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
        N := N.ChildNodes.FindNode('Body');
        if (N = nil) then
          raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
        N := N.ChildNodes.First;
        if (N = nil) then
          raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
        //20171219 Igor>>>
        COR := N.ChildNodes.FindNode('T2ReturnData');
        if Assigned(COR) then
        begin
          COR := COR.ChildNodes.FindNode('T2ReturnDataFile');
          if Assigned(COR) then
            if VarToStr(COR.NodeValue) <> '' then
              TFile.WriteAllText(ChangeFileExt(FReceivedFlName, '-COR.txt'),
                ReplaceStr(StringOf(DecodeBase64(VarToStr(COR.NodeValue))), #$A, #$D#$A));
        end;
        //20171219 Igor<<<
        //20220610 Igor >>>
        if FHasNOA and Assigned(N.ChildNodes.FindNode('CorrespondenceData')) then
          ProcessNOA;

        if FHasAutofill then
        begin
          Data := N.ChildNodes.First;
          while Assigned(Data) do
          begin
            TraverseParseConcatXML(Data);
            Data := Data.NextSibling;
          end;
        //20220610 Igor <<<
        end;
      finally
        X.Free;
      end;
      //20220610 Igor >>>
      if FHasAutofill then
        SL.SaveToFile(ChangeFileExt(FReceivedFlName, '.txt'));
      //20220610 Igor <<<
      FDone := True;
    finally
      SL.Free;
    end;
  except ON E: Exception do
    begin
      Log(E.Message);
      FDone := False;
    end;
  end;
end;
//20171120 Igor>>
procedure TSender.RequestTaxDataElement;
var
  TYEList: TStringList;
  NOAList: TStringList; //20220608 Igor
  i: integer;
begin
  TYEList := TStringList.Create;
  NOAList := TStringList.Create; //20220608 Igor
  try
    for I := 0 to Length(FRequestData.AvailableReturns) - 1 do
      TYEList.Add(FRequestData.AvailableReturns[i].TaxYearEndYearMonthDay);
    //20220608 Igor >>>
    for I := 0 to Length(FRequestData.AvailableNOAs) - 1 do
      NOAList.Add(FRequestData.AvailableNOAs[i].TaxYearEndYearMonthDay);
    //20220608 Igor <<<

    FisSelect := GetParamAFR(TYEList, FRequestData.SelectedTaxYearEndYearMonthDay,
      FRequestData.T2ReturnBalanceIndicator, FRequestData.CorporationAccountBalanceIndicator,
      FRequestData.CorporationBNDataIndicator,
      NOAList, FRequestData.SelectedNOATaxYearEndYearMonthDay); //20220608 Igor
    //20220610 Igor >>>
    FHasAutofill :=
      not FRequestData.SelectedTaxYearEndYearMonthDay.IsEmpty
      or
      FRequestData.T2ReturnBalanceIndicator
      or
      FRequestData.CorporationAccountBalanceIndicator
      or
      FRequestData.CorporationBNDataIndicator;
    FHasNOA := not FRequestData.SelectedNOATaxYearEndYearMonthDay.IsEmpty;
    //20220610 Igor <<<
  finally
    TYEList.Free;
    NOAList.Free; //20220608 Igor
  end;
end;
//20171120 Igor<<
procedure TSender.SaveRequestAFR;
begin
  FReceivedFlName := ChangeFileExt(MkTddFileName(GetCurrentRetNo), '.xml');
  if not DirectoryExists(ExtractFileDir(FReceivedFlName)) then
    ForceDirectories(ExtractFileDir(FReceivedFlName));
  with TStringStream.Create(FSOAPResponse) do
  begin
    try
      SaveToFile(FReceivedFlName);
    finally
      free;
    end;
  end;
  Log('Request from AFR Saved to file "'+FReceivedFlName+'"');
end;

function TSender.GetInternetDateTime: TDateTime;
var
  I: integer;
  myDate: TDateTime;
  S: string;
  mySNTP: TIdSNTP;
  //20170405 Igor >>>
const
  ntpServers: array [0..14] of string =
    ('ntp2.cs.wisc.edu',
     'ca.pool.ntp.org',
     'us.pool.ntp.org',
     'time.chu.nrc.ca',
     'ntp1.cmc.ec.gc.ca',
     'ntp.cpsc.ucalgary.ca',
     'timelord.uregina.ca',
     '1.north-america.pool.ntp.org',
     '2.north-america.pool.ntp.org',
     '2.north-america.pool.ntp.org',
     '3.north-america.pool.ntp.org',
     '0.ca.pool.ntp.org',
     '1.ca.pool.ntp.org',
     '2.ca.pool.ntp.org',
     '3.ca.pool.ntp.org');
   //20170405 Igor <<<
begin
  mySNTP := TIdSNTP.Create;
  try
    //mySNTP.Host := 'ntp2.cs.wisc.edu';//20170405 Igor
    mySNTP.ReceiveTimeout := 3000;
    for I := Low(ntpServers) to High(ntpServers) do
    begin
      mySNTP.Host := ntpServers[I];//20170405 Igor
      myDate := mySNTP.DateTime;
      myDate := TTimeZone.Local.ToUniversalTime(myDate);
      S := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', myDate);
      if pos('1899', S) = 0 then
        break;
    end;
    result := myDate;
  finally
    mySNTP.free;
  end;
end;

procedure TSender.GetResultInfoServerError;
var
  X: XML.XMLDoc.TXMLDocument;
  N, Manifest, AvailableReturn, AvailableNOA, Refresh, Fault: IXMLNode; //20201125 Igor //20220608 Igor
  i: integer;
  FErrorFileName: string;//20171215 Igor
begin
  X := XML.XMLDoc.TXMLDocument.Create(Application);
  try
    try
      X.XML.Clear;
      X.XML.Add(ClearXML(FSOAPResponse));
      //for test
      if not(X.Active) then
        X.Active := true;
      N := X.DocumentElement;
      if (N = nil) or (N.NodeName <> 'Envelope') then
        raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
      N := N.ChildNodes.FindNode('Body');
      if (N = nil) then
        raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
      //20201125 Igor >>>
      Fault := N.ChildNodes.FindNode('Fault');
      if Fault <> nil then
        raise Exception.Create(VarToStr(Fault.ChildValues['faultcode']) + ': ' + VarToStr(Fault.ChildValues['faultstring']));
      //20201125 Igor <<<
      N := N.ChildNodes.First;
      if (N = nil) then
        raise Exception.Create('Bad Response XML structure: ' + FSOAPResponse);
      FServerResponse.ReturnCode := VarToStr(N.ChildValues['ReturnCode']);
      if VarToStr(N.ChildValues['TokenIdentifier']) <> '' then
        FRequestData.TokenC := VarToStr(N.ChildValues['TokenIdentifier'])
      else
      if VarToStr(N.ChildValues['DataAccessTokenIdentifier']) <> '' then
        FRequestData.TokenDataAccess := VarToStr(N.ChildValues['DataAccessTokenIdentifier']);
      Refresh := N.ChildNodes.FindNode('RefreshToken');
      if Refresh <> nil then
      begin
        FRequestData.RefreshToken := VarToStr(Refresh.ChildValues['TokenIdentifier']);
        FRequestData.ExpireDatetime := VarToStr(Refresh.ChildValues['TokenExpireDatetime']);
        FRequestData.ExpireDatetimeD := StrInternetToDateTime(FRequestData.ExpireDatetime) - GetTimeZone(FRequestData.ExpireDatetime); //20171120 Igor
      end;

      Manifest := N.ChildNodes.FindNode('Manifest');
      if Manifest <> nil then
      begin
        Manifest := Manifest.ChildNodes.FindNode('ResultCode');
        if Manifest <> nil then
          FServerResponse.ResultCode := VarToStr(Manifest.NodeValue);
      end;
      AvailableReturn := N.ChildNodes.FindNode('AvailableReturns');
      AvailableNOA := N.ChildNodes.FindNode('AvailableNOAs'); //20220608 Igor
      if AvailableReturn <> nil then
      begin
        for I := 0 to AvailableReturn.ChildNodes.Count - 1 do
        begin
          N := AvailableReturn.ChildNodes[i];
          //20171120 Igor>>
          SetLength(FRequestData.AvailableReturns, Length(FRequestData.AvailableReturns) + 1);
          FRequestData.AvailableReturns[Length(FRequestData.AvailableReturns) - 1].TaxYearEndYearMonthDay :=
            N.ChildValues['TaxYearEndYearMonthDay'];
          FRequestData.AvailableReturns[Length(FRequestData.AvailableReturns) - 1].TaxYearEndHourMinute :=
            N.ChildValues['TaxYearEndHourMinute'];
          FRequestData.AvailableReturns[Length(FRequestData.AvailableReturns) - 1].ReturnStatusTypeCode :=
            N.ChildValues['ReturnStatusTypeCode'];
          FRequestData.AvailableReturns[Length(FRequestData.AvailableReturns) - 1].ReturnStatusDate :=
            N.ChildValues['ReturnStatusDate'];
          //20171120 Igor<<
        end;

      end;
      //20220608 Igor >>>
      if AvailableNOA <> nil then
      begin
        for I := 0 to AvailableNOA.ChildNodes.Count - 1 do
        begin
          N := AvailableNOA.ChildNodes[i];
          SetLength(FRequestData.AvailableNOAs, Length(FRequestData.AvailableNOAs) + 1);
          FRequestData.AvailableNOAs[Length(FRequestData.AvailableNOAs) - 1].TaxYearEndYearMonthDay :=
            N.ChildValues['TaxYearEndYearMonthDay'];
          FRequestData.AvailableNOAs[Length(FRequestData.AvailableNOAs) - 1].ArchiveID :=
            N.ChildValues['ArchiveID'];
        end;
      end;
      //20220608 Igor <<<
    except ON E: Exception DO
      begin
        FServerResponse.ReturnCode := '-1';
        FServerResponse.ReturnCodeDescr := E.Message;
      end;
    end;
    if FServerResponse.ReturnCode = '0' then
      FServerResponse.ReturnCodeDescr := '0: REQUEST_ACCEPTED  The request for tax data has been accepted.  The tax data is being assembled.'
    else
    if FServerResponse.ReturnCode = '1' then
      FServerResponse.ReturnCodeDescr := '1: SUCCESS The request for Data Access and Refresh Tokens was successful.'
    else
    if FServerResponse.ReturnCode = '10' then
      FServerResponse.ReturnCodeDescr := '10: NOT_READY  The tax data is not ready, please wait and make another call.'
    else
    if FServerResponse.ReturnCode = '20' then
      FServerResponse.ReturnCodeDescr := '20: FOUND  The  tax data has been found and returned.'
    else
    if FServerResponse.ReturnCode = '201' then
      FServerResponse.ReturnCodeDescr := '201: INVALID_REQUEST The request for tax data is not structured properly.'
    else
    if FServerResponse.ReturnCode = '202' then
      FServerResponse.ReturnCodeDescr := '202: INVALID_SP_ID The SPID provided is invalid. Currently not used.'
    else
    if FServerResponse.ReturnCode = '203' then
      FServerResponse.ReturnCodeDescr := '203: INVALID_TAX_YEAR The tax year provided is invalid.'
    else
    if FServerResponse.ReturnCode = '204' then
      FServerResponse.ReturnCodeDescr := '204: INVALID_TOKEN The token provided is invalid. The token is mandatory input.'
    else
    if FServerResponse.ReturnCode = '206' then
      FServerResponse.ReturnCodeDescr := '206: INVALID_BN The provided BN format is invalid.  The format must conform to 999999999RC9999 (Nine digits, RC, 4 digits).   BN is a mandatory input.'
    else
    if FServerResponse.ReturnCode = '501' then
      FServerResponse.ReturnCodeDescr := '501: SERVICE_UNAVAILABLE The system is currently unavailable. Please refer to times of operation.'
    else
    if FServerResponse.ReturnCode = '502' then
      FServerResponse.ReturnCodeDescr := '502: SYSTEM_BUSY The system is too busy. Please retry later.'
    else
    if FServerResponse.ReturnCode = '503' then
      FServerResponse.ReturnCodeDescr := '503: SYSTEM_ERROR A system error occurred. This could be a temporary condition. A retry may be successful.';

    if FServerResponse.ResultCode = 'FOUND' then
      FServerResponse.ResultCodeDescr := 'The corporation data has been found for a given BN and no issues were encountered'
    else
    if FServerResponse.ResultCode = 'FOUND_INCOMPLETE' then
    begin
      FServerResponse.ResultCodeDescr := 'The corporation data has been found for a given BN BUT issues were encountered';
      repeat
        N := N.NextSibling;
        if Assigned(N) AND (N.NodeName = 'SubResultCode') then
          FServerResponse.ResultCodeDescr := FServerResponse.ResultCodeDescr + #13 +
            VarToStr(N.NodeValue);
      until N = nil ;
    end
    else
    if FServerResponse.ResultCode = 'NO_DATA' then
      FServerResponse.ResultCodeDescr := 'The tax data has NOT been found for a given BN and no issues were encountered'
    else
    if FServerResponse.ResultCode = 'ERROR' then
      FServerResponse.ResultCodeDescr := 'Unable to return data due to errors';
  finally
    X.Free;
  end;
  //20171215 Igor>>
  if (FServerResponse.ReturnCode <> '0') and (FServerResponse.ReturnCode <> '1')
    and (FServerResponse.ReturnCode <> '20') then
  begin
    FErrorFileName := TPath.Combine(CurrentApp.AppDir, 'AFR' +
      TPath.DirectorySeparatorChar + GenerateFileName + '.htm');
    // 20180530 Igor >>>
    ShowMessageHTML(PrepareErrorHTM(FErrorFileName));
//    if MessageDlg('Got Error. Show detail information?', mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
//      ShellExecute(0, 'OPEN', PChar(FErrorFileName), '', '', SW_SHOWNORMAL);
    // 20180530 Igor <<<
  end;
  //20171215 Igor<<
  Log('Response from CRA parsed');
end;

function TSender.HMACSHA256Encode(S, Key: PWideChar): string;
var
  success: boolean;
  crypt: HCkCrypt2;
  mac: PWideChar;
  keyEncoding: PWideChar;
begin
  crypt := CkCrypt2_Create;
  // Any string argument automatically begins the 30-day trial.
  success := CkCrypt2_UnlockComponent(crypt, 'djhzcoCrypt_Y7xcLWVr6XPk');
  if (success <> true) then
  begin
    FServerResponse.ReturnCode := '-1';
    FServerResponse.ReturnCodeDescr := CkCrypt2__lastErrorText(crypt);
    Terminate;
    Exit;
  end;
  CkCrypt2_putEncodingMode(crypt, 'base64');
  CkCrypt2_putHashAlgorithm(crypt, 'sha256');
  keyEncoding := 'ansi';
  CkCrypt2_SetHmacKeyEncoded(crypt, key, keyEncoding);
  mac := CkCrypt2__hmacStringENC(crypt, s);
  result := mac;
end;

procedure TSender.LinkToCRALogin;
var
  TokenRequestUrl: string;
  BaseStr, Lang, Auth, SignedKey, SpIDstr,
  TimestampStr, AuthStr, TokenCStr, SWRelease, Release: string;
  BaseStrToSign: PWideChar;
  TimeStamp : int64;
  myDate: TDateTime;
begin


  myDate := GetInternetDateTime;
  TimeStamp := SecondsBetween(myDate, EncodeDateTime(1970, 01, 01, 0, 0, 0, 0)) + 1;
  auth := FRequestData.Auth_Param;
  authStr := HttpEncode(auth);
  Lang := 'en';
  SWRelease := FRelease;
  TokenCStr := HttpEncode(FRequestData.TokenC);
  //         ${spID} +               urlencode(${URI}) +                            ${timestamp} +
  BaseStr := FRequestData.userName + HttpEncode(FRequestData.TrunkApplicationUrl) + inttostr(timestamp) +
  //urlencode(${auth}) + ${l} + urlencode(${T} + ${release} + urlencode(${state}))
    authStr            + lang + tokenCStr      + SWRelease;
  BaseStrToSign := PWideChar(BaseStr);
  SignedKey := HMACSHA256Encode(baseStrToSign, pchar(FRequestData.SecretAccessKey));
  SignedKey := HttpEncode(SignedKey);

//  URI?spID=${spID}&timestamp=${timestamp}&auth=${auth}&key=${signedKey}&t=${T}&lang=${l}&release=${release}&state=${state}
//spID=${spID}
  SpIDstr := '?spID=' + FRequestData.UserName;
//timestamp=${timestamp}
  timestampStr := '&timestamp=' + inttostr(Timestamp);
//auth=${auth}
  AuthStr := '&auth=' + HttpEncode(Auth);
//key=${signedKey}
  SignedKey := '&key=' + SignedKey;
//t=${T}
  TokenCStr := '&t=' + TokenCStr;
//lang=${l}
  Lang := '&lang=' + Lang;
//release=${release}
  Release := '&release=' + SWRelease;
////state=${state}
//  State := '&state=' + SWRelease;

  tokenRequestUrl := FRequestData.WebApplicationUrl + SpIDstr + TimeStampStr + AuthStr +
    SignedKey + TokenCStr + Lang + Release;
  ShellExecute(0, 'OPEN', pchar('' + TokenRequestUrl), '', '', SW_SHOWNORMAL);
  Log('Start authorization');   //20170328
  WaitTitleToken;
  Synchronize(procedure
    begin
      Application.BringToFront;
    end);
end;

procedure TSender.Log(AMessage: String);
begin
  FLastMessage := AMessage;
  Synchronize(DoLog);
end;

procedure TSender.WaitTitleToken;
var
  i: integer;
  lStart: Boolean;
  function ReturnTokenFromTitle: string;
  var
    hWndTemp: hWnd;
    iLenText: integer;
    cTitletemp: array [0 .. 254] of Char;
    sTitleTemp: string;
    partialTitle: string;
    title, token: string;
    function ExtractBetween(const Value, A, B: string): string;
    var
      aPos, bPos: integer;
    begin
      result := '';
      aPos := pos(A, Value);
      if aPos > 0 then
      begin
        aPos := aPos + Length(A);
        bPos := PosEx(B, Value, aPos);
        if bPos > 0 then
          result := copy(Value, aPos, bPos - aPos);
      end;
    end;
  begin
    partialTitle := 'token={';

    hWndTemp := FindWindow(nil, nil);
    while hWndTemp <> 0 do
    begin
      iLenText := GetWindowText(hWndTemp, cTitletemp, 255);
      sTitleTemp := cTitletemp;

      title := sTitleTemp;

      sTitleTemp := UpperCase(copy(sTitleTemp, 1, iLenText));
      partialTitle := UpperCase(partialTitle);
      if pos(partialTitle, sTitleTemp) <> 0 then
      begin
        if FNeedCloseWebPage then
        begin

          SetForegroundWindow(hWndTemp);
          sleep(10);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
          sleep(10);
          keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), 0, 0);
          sleep(10);
          keybd_event(Ord('W'), MapVirtualKey(Ord('W'), 0), KEYEVENTF_KEYUP, 0);
          sleep(10);
          keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
          SetForegroundWindow(Handle);
        end;
        break;
      end;
      hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
    end;
    token := ExtractBetween(title, '{', '}');
    result := token;
  end;
begin
  FRequestData.TokenTitle := '';
  i := 0;
  lStart := True;
  while not Terminated {and CRAPageExists} do //20170330 Igor
  begin
    Inc(i);
    sleep(400);

    if i > 5 then
    Begin
      FRequestData.TokenTitle := ReturnTokenFromTitle;
      if FRequestData.TokenTitle > '' then
        break;
    end;
  end;
  if FRequestData.TokenTitle > '' then
    Log('Authorization done');  //20170328 CON
end;

//procedure TSender.WBNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
//  const URL: OleVariant);
//var
//  XMLDOMDocument: IHtmldocument2;
//  i: integer;
//  HTMLResult: string;
//  WB: TWebBrowser;
//begin
////20170405 Igor >>>
//  try
//    try
//      WB := ASender as TWebBrowser;
//      if not Assigned(WB.Document) then exit;
//      HTMLResult := '';
//      XMLDOMDocument := WB.Document as IHtmldocument2;
//      for i := 1 to 2 do
//      begin
//        HTMLResult := HTMLResult + (XMLDOMDocument.all.item(i,i) as IHTMLElement).outerHTML ;
//      end;
//      HTMLResult := ReplaceText(HTMLResult, '•', '&bull;');
//
//      with TStringStream.Create(HTMLResult) do
//      try
//        FReceivedFlName := FSaveDir + '\' + FBN+'.html';
//        SaveToFile(FReceivedFlName);
//      finally
//        free;
//      end;
//    except ON E: Exception DO
//      begin
//        FLastMessage := E.Message;
//        DoLog;
//      end;
//    end;
//  finally
//    WBDone := True;
//  end;
////20170405 Igor <<<
//end;

procedure TSender.SendSOAPMessage;
var
  objHttp: ixmlHttpRequest;
  Attempt: Integer; //20170405 Igor
begin
{  FSOAPMessage := '<?xml version=''1.0'' encoding=''UTF-8''?>'+#13#10+
'<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">'+#13#10+
	'<S:Header>'+#13#10+
		'<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" S:mustUnderstand="1">'+#13#10+
			'<wsse:UsernameToken	xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+#13#10+
				'<wsse:Username>testt2app</wsse:Username>'+#13#10+
				'<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">0YsoLRU2+q114LQa8+ZaQqV5Ruw=</wsse:Password>'+#13#10+
				'<wsse:Nonce	EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">sillynoncejustotchangeitupl6/XjLkhqJfaS4QWk=</wsse:Nonce>'+#13#10+
				'<wsu:Created>2017-10-11T14:16:18.1356821Z</wsu:Created>'+#13#10+
			'</wsse:UsernameToken>'+#13#10+
		'</wsse:Security>'+#13#10+
	'</S:Header>'+#13#10+
	'<S:Body>'+#13#10+
		'<StageTDDT2 xmlns="http://www.cra-arc.gc.ca/xmlns/tdd/bn/1-0-0"'+#13#10+
		 'xmlns:ns2="http://www.cra-arc.gc.ca/xmlns/ccms/1-0-0">'+#13#10+
			'<BusinessNumber>597139583RC0001</BusinessNumber>'+#13#10+
		'</StageTDDT2>'+#13#10+
	'</S:Body>'+#13#10+
'</S:Envelope>';}
  //20170405 Igor >>>
  Attempt := 0;
  repeat
    objHttp := CreateOleObject('MSXML2.XMLHTTP.3.0') as ixmlHttpRequest;
    objHttp.open('POST', FRequestData.WebServiceUrl, False, FRequestData.UserName, FRequestData.SecretAccessKey);
    objHttp.setRequestHeader('SOAPAction', 'NA');
    objHttp.setRequestHeader('Content-Type', 'text/xml');
    try
      objHttp.send(FSOAPMessage);
      Break;
    except
      inc(Attempt);
      if Attempt >= 4 then
        raise;
      Sleep(1000);
    end;
    objHttp := nil;
  until False;
  //20170405 Igor <<<
  FSOAPResponse := objHttp.ResponseText;
  Log('Request for CRA authorization sent');  //20170330
end;

function TSender.SetRequestDataInput: Boolean;
var
  myDate: TDateTime;
begin
  FRequestData.Created := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', GetInternetDateTime);
  if (pos('1899', FRequestData.created) > 0) or (FRequestData.created = '') then
  begin
    FServerResponse.ReturnCode := '-1';
    FServerResponse.ReturnCodeDescr := 'Unable to connect. Try again.' + Chr(13) +
      'Or Disable your Firewall. It may be blocking the connection.';
    Exit(False);
  end;

  if FTest then
  begin
    FRequestData.Domain := c_Domain_Test;
    FRequestData.Servise := Format(c_Servise_Test,[FRelease]);;
    FRequestData.Auth_Param := c_auth_Param;
    if FTaxYear = '2019' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2019_Test

    else if FTaxYear = '2020' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2020_Test

    Else if FTaxYear = '2021' then  //20210629
      FRequestData.SecretAccessKey := c_secretAccessKey_2021_Test

    Else if FTaxYear = '2022' then  //20211101
      FRequestData.SecretAccessKey := c_secretAccessKey_2022_Test

   Else if FTaxYear = '2023' then //20231211 Igor
      FRequestData.SecretAccessKey := c_secretAccessKey_2023_Test

   Else if FTaxYear = '2024' then //jz 20241123
      FRequestData.SecretAccessKey := c_secretAccessKey_2024_Test

   Else if FTaxYear = '2025' then //jz 20241123
      FRequestData.SecretAccessKey := c_secretAccessKey_2025_Test

    else
      Exit(False); {New Year - New Key}

    FRequestData.WebApplicationUrl := c_WebApplicationURL_Test;
  end
  else
  begin
    FRequestData.Domain := c_Domain_Prod;
    FRequestData.Servise := Format(c_Servise_Prod,[FRelease]);
    FRequestData.Auth_Param := c_auth_Param;
    {
    if FTaxYear = '2018' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2018_Prod
    }
    if FTaxYear = '2019' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2019_Prod

    else
    if FTaxYear = '2020' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2020_Prod

    else
    if FTaxYear = '2021' then
      FRequestData.SecretAccessKey := c_secretAccessKey_2021_Prod

    else if FTaxYear = '2022' then   //20211101
      FRequestData.SecretAccessKey := c_secretAccessKey_2022_Prod

    else if FTaxYear = '2023' then   //20231211 Igor
      FRequestData.SecretAccessKey := c_secretAccessKey_2023_Prod

    else if FTaxYear = '2024' then //jz 20241123
      FRequestData.SecretAccessKey := c_secretAccessKey_2024_Prod

    else if FTaxYear = '2025' then //jz 20241123
      FRequestData.SecretAccessKey := c_secretAccessKey_2025_Prod


    else
      Exit(False); {New Year - New Key}
    FRequestData.WebApplicationUrl := c_WebApplicationURL_Prod;
  end;
  FRequestData.transform_xsl := c_transform_xsl; //20220608 Igor
  FRequestData.UserName := c_SPID_TDD;
  FRequestData.TaxYear := FTaxYear;
  FRequestData.Nonce := GenerateNonce;
  FRequestData.NonceB64 := EncodeString(FRequestData.Nonce);
  FRequestData.PasswordDigest := GeneratePasswordDigest;
  Result := True;
  Log('Data for CRA authorization prepared');  //20170330
end;

{ TRequestData }

function TRequestData.GetSelectedNOA: TAvailableNOAs; //20220608 Igor
var
  i: integer;
begin
  for I := 0 to Length(AvailableNOAs) - 1 do
    if AvailableNOAs[i].TaxYearEndYearMonthDay = SelectedNOATaxYearEndYearMonthDay then
    begin
      Result := AvailableNOAs[i];
      Exit;
    end;
end;

function TRequestData.GetSelectedReturn: TAvailableReturns;
var
  i: integer;
begin
  for I := 0 to Length(AvailableReturns) - 1 do
    if AvailableReturns[i].TaxYearEndYearMonthDay = SelectedTaxYearEndYearMonthDay then
    begin
      Result := AvailableReturns[i];
      Exit;
    end;
end;

function TRequestData.GetTrunkApplicationUrl: string;
begin
  Result := Copy(WebApplicationUrl, Pos('://', WebApplicationUrl) + 3, MaxInt);
end;

function TRequestData.GetWebServiceUrl: string;
begin
  Result := Domain + Servise;
end;

end.