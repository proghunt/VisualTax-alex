{
Email: VisualTaxCanada@gmail.com
Password: vtSecret2015
App Key: clmqhseptut86vm
App Secret: l66h2jrszkkail6
}

unit vtFillDBMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool,
  uADStanAsync, uADPhysManager, uADStanExprFuncs, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, Vcl.XPMan, Vcl.Menus, Vcl.ImgList,
  System.Actions, Vcl.ActnList, Data.DB, uADCompDataSet, uADCompClient, uADPhysSQLite,
  uADCompGUIx, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Grids,
  Vcl.DBGrids, vtCommonIntf, vtHelperManager,
  vtMulti, vtDataBase, vtShared, IdMessage, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase,
  IdMessageClient, IdSMTPBase, IdSMTP, Vcl.Samples.Spin, IdText;

type
  TFieldRec = record
    FieldName, FieldType, IsNull, Default: string;
  end;

  TfrmFillDBMain = class(TForm)
    conMain: TADConnection;
    DriverLink: TADPhysSQLiteDriverLink;
    conSourceClient: TADConnection;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    grClients: TDBGrid;
    qryClients: TADQuery;
    dsClients: TDataSource;
    qryDocumentFormat: TADQuery;
    qryDocumentTypes: TADQuery;
    qryUsers: TADQuery;
    grUsers: TDBGrid;
    Splitter2: TSplitter;
    grDocuments: TDBGrid;
    dsDocumentFormat: TDataSource;
    dsDocumentTypes: TDataSource;
    dsUsers: TDataSource;
    qryDocuments: TADQuery;
    dsDocuments: TDataSource;
    qryClientUsers: TADQuery;
    pgcMain: TPageControl;
    tsMain: TTabSheet;
    tsDicts: TTabSheet;
    pgcSettings: TPageControl;
    tsDocumentTypes: TTabSheet;
    tsDocumentFormats: TTabSheet;
    grDocumentTypes: TDBGrid;
    DBGrid1: TDBGrid;
    Panel5: TPanel;
    imgDocumentPicture: TImage;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ActionList1: TActionList;
    actDocumentAdd: TAction;
    ToolBar1: TToolBar;
    btnUserAdd: TToolButton;
    btnUserEdit: TToolButton;
    btnUserDelete: TToolButton;
    il16X16: TImageList;
    actUserAdd: TAction;
    actUserEdit: TAction;
    actUserDelete: TAction;
    qryUserSingle: TADQuery;
    btnUserAccessGranted: TToolButton;
    btnUserAccessDenied: TToolButton;
    actUserAccessGranted: TAction;
    actUserAccessDenied: TAction;
    actUserAccessGrantedAll: TAction;
    actUserAccessDeniedAll: TAction;
    btnUserAccessGrantedAll: TToolButton;
    btnUserAccessDeniedAll: TToolButton;
    tbClient: TToolBar;
    btnClientGrantedForAll: TToolButton;
    btnClientDeniedForAll: TToolButton;
    actClientGrantedForAll: TAction;
    actClientDeniedForAll: TAction;
    tbDocument: TToolBar;
    btnDocumentAdd: TToolButton;
    btnDocumentEdit: TToolButton;
    btnDocumentDelete: TToolButton;
    actDocumentEdit: TAction;
    actDocumentDelete: TAction;
    actUploadToCloud: TAction;
    imgPDF: TImage;
    imgDOC: TImage;
    Label1: TLabel;
    ToolButton2: TToolButton;
    edtFilter: TEdit;
    btnClearFilter: TToolButton;
    actClearFilter: TAction;
    actFilter: TAction;
    pnlWait: TPanel;
    il32X32: TImageList;
    pmClients: TPopupMenu;
    Grantedforallusers1: TMenuItem;
    Deniedforallusers1: TMenuItem;
    pmUsers: TPopupMenu;
    NewUser1: TMenuItem;
    Edituser1: TMenuItem;
    Deleteuser1: TMenuItem;
    N1: TMenuItem;
    Accessgranted1: TMenuItem;
    Accessdenied1: TMenuItem;
    N2: TMenuItem;
    Accessgrantedall1: TMenuItem;
    Accessdeniedall1: TMenuItem;
    pmDocuments: TPopupMenu;
    Loadnewdocument1: TMenuItem;
    Editdocument1: TMenuItem;
    Deletedocument1: TMenuItem;
    N3: TMenuItem;
    Loadnewdocument2: TMenuItem;
    Editdocument2: TMenuItem;
    Deletedocument2: TMenuItem;
    XPManifest1: TXPManifest;
    btnUploadToCloud: TButton;
    Button1: TButton;
    actExit: TAction;
    actScan: TAction;
    ToolButton3: TToolButton;
    btnScanAll: TToolButton;
    actScanAll: TAction;
    pb: TProgressBar;
    btnStop: TButton;
    ToolBar2: TToolBar;
    pnlFilter: TPanel;
    lblProgress: TLabel;
    pnlProgress: TPanel;
    qryDocumentsID: TADAutoIncField;
    qryDocumentsClientID: TIntegerField;
    qryDocumentsDocumentTypeID: TIntegerField;
    qryDocumentsDocumentFormatID: TIntegerField;
    qryDocumentsDocumentName: TStringField;
    qryDocumentsDocumentData: TBlobField;
    qryDocumentsisDocumentLoaded: TBooleanField;
    qryDocumentsDocumentTypeName: TStringField;
    qryDocumentsDocumentFormatName: TStringField;
    btnUploadDBForUser: TToolButton;
    actUploadDBForUser: TAction;
    imgHTML: TImage;
    tsEmailSettings: TTabSheet;
    chbSendNotificationEmail: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edSMTPServer: TEdit;
    edSMTPLogin: TEdit;
    edSMTPPassword: TEdit;
    edSMTPPort: TSpinEdit;
    qrySettings: TADQuery;
    Label6: TLabel;
    cbUseTLS: TComboBox;
    Label7: TLabel;
    cbSSLVersion: TComboBox;
    ToolButton1: TToolButton;
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure grUsersDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actUserAddExecute(Sender: TObject);
    procedure actUserEditExecute(Sender: TObject);
    procedure actUserDeleteExecute(Sender: TObject);
    procedure grUsersDblClick(Sender: TObject);
    procedure qryClientsAfterScroll(DataSet: TDataSet);
    procedure actUserAccessGrantedExecute(Sender: TObject);
    procedure actUserAccessGrantedAllExecute(Sender: TObject);
    procedure actUserAccessDeniedAllExecute(Sender: TObject);
    procedure actClientGrantedForAllExecute(Sender: TObject);
    procedure actClientDeniedForAllExecute(Sender: TObject);
    procedure actDocumentAddExecute(Sender: TObject);
    procedure actDocumentEditExecute(Sender: TObject);
    procedure actDocumentDeleteExecute(Sender: TObject);
    procedure qryDocumentsNewRecord(DataSet: TDataSet);
    procedure actUploadToCloudExecute(Sender: TObject);
    procedure qryDocumentFormatAfterScroll(DataSet: TDataSet);
    procedure actClearFilterExecute(Sender: TObject);
    procedure actFilterExecute(Sender: TObject);
    procedure qryClientsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure grClientsTitleClick(Column: TColumn);
    procedure tbClientResize(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actScanExecute(Sender: TObject);
    procedure actScanAllExecute(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure qryUsersAfterOpen(DataSet: TDataSet);
    procedure actUploadDBForUserExecute(Sender: TObject);
    procedure qrySettingsAfterOpen(DataSet: TDataSet);
    procedure edSMTPServerExit(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    ScanStop: Boolean;
    FApp: TApp;
    FSilent: Boolean;
    function initStartParams: Boolean;
    function CheckConnection: Boolean;
    function CheckStructure(AConnection: TADConnection): Boolean; overload;//20170327 Igor
    function CheckStructure(AConnection: TADConnection; ATableName: string): Boolean; overload;
    function CheckIndexes(ASrcConnection, ADstConnection: TADConnection; ASrcTableName, ADstTableName: string): Boolean; overload;
    function CheckData: Boolean;
    function TableExists(AConnection: TADConnection; ATableName: string): Boolean;
    function FieldExists(AConnection: TADConnection; ATableName, AFieldName, AFieldType, AIsNull, ADefault: string; ACreateIfNotExists: Boolean): Boolean;
    function IndexExists(AConnection: TADConnection; ATableName, AIndexName, ASQL: string; ACreateIfNotExists: Boolean): boolean;
    function GenerateDDL(AConnection: TADConnection; ATableName: string; out ADDL: string): Boolean;
    function GetDDL(ATableName: string; out ADDL: string): Boolean;
    function CreateTable(ASrcConnection, ADstConnection: TADConnection; ASrcTableName, ADstTableName: string): Boolean; overload;
    function CreateTable(AConnection: TADConnection; ATableName: string): Boolean; overload;
    function CompareStructure(ASrcConnection, ADstConnection: TADConnection; ASrcTableName, ADstTableName: string): Boolean;
    function CreateQuery(AConnection: TADConnection): TADQuery;
    function OpenData: Boolean;
    procedure UpdateUser;
    function GetClientDir: string;
    function GetClientName: string;
    procedure Wait(AStart: Boolean = True);
    function SelectManager(var AHelperID: Integer): Boolean;
    procedure ScanClientWithEmail;
    function MakeSharedDB(out ASharedFilePath: String): Boolean;//20170327 Igor
    procedure SaveSettings(const AName, AValue: String); overload;
    procedure SaveSettings(const AName: String; const AValue: Integer); overload;
    procedure SaveSettings(const AName: String; const AValue: Boolean); overload;
    function SendEmail(ATaxPayerName, ATaxPayerEmail: String): Boolean; //20170415 Igor
  public
    { Public declarations }
    function Start: Boolean;
  end;

procedure StartFillDB(AApp: TApp);
procedure SilentAddFile(AApp: TApp; AClientIdentificator: string; AFile: String; ADocumentType: string = ''); //20170403 Igor

implementation

{$R *.dfm}

uses
  RegularExpressions, uEditUser, uEditDocument, Common, System.StrUtils;

const
  c_MobileDBName = 'vtMobile.sdb';
  c_tbl_Clients = 'Clients';
  c_tbl_Users = 'Users';
  c_tbl_UsersDDL = 'CREATE TABLE Users (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ' +
    'IsAdmin INTEGER NOT NULL, ' +
    'Login VARCHAR(255) UNIQUE NOT NULL, ' +
    'Password VARCHAR(255) NOT NULL, ' +
    'Email VARCHAR(255) NOT NULL);';
  c_tbl_UsersFields: array[0..4] of TFieldRec = ((
    FieldName: 'ID';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: ''
  ), (
    FieldName: 'IsAdmin';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: '0'
  ), (
    FieldName: 'Login';
    FieldType: 'VARCHAR(255)';
    IsNull: 'NOT NULL';
    Default: ''''''
  ), (
    FieldName: 'Password';
    FieldType: 'VARCHAR(255)';
    IsNull: 'NOT NULL';
    Default: ''''''
  ), (
    FieldName: 'Email';
    FieldType: 'VARCHAR(255)';
    IsNull: 'NOT NULL';
    Default: ''''''
  ));
  c_tbl_ClientUsers = 'ClientUsers';
  c_tbl_ClientUsersDDL = 'CREATE TABLE ClientUsers (' +
    'UserID INTEGER NOT NULL, ' +
    'ClientID INTEGER NOT NULL, ' +
    'FOREIGN KEY (UserID) REFERENCES Users (ID), ' +
    'FOREIGN KEY (ClientID) REFERENCES Clients (ID),'+
    'PRIMARY KEY (UserID, ClientID) ON CONFLICT REPLACE)';
  c_tbl_ClientUsersFields: array[0..1] of TFieldRec = ((
    FieldName: 'UserId';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: ''
  ), (
    FieldName: 'ClientId';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: '0'
  ));
  c_tbl_DocumentTypes = 'DocumentTypes';
  c_tbl_DocumentTypesDDL = 'CREATE TABLE DocumentTypes (' +
    'ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
    'DocumentType VARCHAR(255) NOT NULL);';
  c_tbl_DocumentTypesFields: array[0..1] of TFieldRec = ((
    FieldName: 'ID';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: ''
  ), (
    FieldName: 'DocumentType';
    FieldType: 'VARCHAR(255)';
    IsNull: 'NOT NULL';
    Default: ''''''
  ));
  c_tbl_DocumentFormat = 'DocumentFormat';
  c_tbl_DocumentFormatDDL = 'CREATE TABLE DocumentFormat (' +
    'ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, ' +
    'DocumentFormat VARCHAR(255) NOT NULL, ' +
    'Picture BLOB, ' +
    'FileExtension VARCHAR(255) NOT NULL);';
  c_tbl_DocumentFormatFields: array[0..3] of TFieldRec = ((
    FieldName: 'ID';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: ''
  ), (
    FieldName: 'DocumentFormat';
    FieldType: 'VARCHAR(255)';
    IsNull: 'NOT NULL';
    Default: ''''''
  ), (
    FieldName: 'Picture';
    FieldType: 'BLOB';
    IsNull: 'NULL';
    Default: ''
  ), (
    FieldName: 'FileExtension';
    FieldType: 'VARCHAR(255)';
    IsNull: 'NOT NULL';
    Default: ''''''
  ));
  c_tbl_Documents = 'Documents';
  c_tbl_DocumentsDDL = 'CREATE TABLE Documents (' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ' +
    'ClientID INTEGER NOT NULL, ' +
    'DocumentTypeID INTEGER NOT NULL, ' +
    'DocumentFormatID INTEGER NOT NULL, ' +
    'DocumentName VARCHAR(400) NOT NULL, ' +
    'DocumentData BLOB, ' +
    'isDocumentLoaded BOOLEAN, ' +
    'FOREIGN KEY (ClientID) REFERENCES Clients (ID), ' +
    'FOREIGN KEY (DocumentTypeID) REFERENCES DocumentTypes (ID), ' +
    'FOREIGN KEY (DocumentFormatID) REFERENCES DocumentFormat (ID));';
  c_tbl_DocumentsFields: array[0..6] of TFieldRec = ((
    FieldName: 'ID';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: ''
  ), (
    FieldName: 'ClientID';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: '0'
  ), (
    FieldName: 'DocumentTypeID';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: '0'
  ), (
    FieldName: 'DocumentFormatID';
    FieldType: 'INTEGER';
    IsNull: 'NOT NULL';
    Default: '0'
  ), (
    FieldName: 'DocumentName';
    FieldType: 'VARCHAR(400)';
    IsNull: 'NOT NULL';
    Default: ''''''
  ), (
    FieldName: 'DocumentData';
    FieldType: 'BLOB';
    IsNull: 'NULL';
    Default: ''
  ), (
    FieldName: 'isDocumentLoaded';
    FieldType: 'BOOLEAN';
    IsNull: 'NULL';
    Default: ''
  ));
  c_tbl_Settings = 'SETTINGS';
  c_tbl_SettingsDDL = 'CREATE TABLE SETTINGS (' +
    'Name VarChar (25) NOT NULL, ' +
    'Value VarChar (255), ' +
    'PRIMARY KEY (Name));';
  c_tbl_SettingsFields: array[0..1] of TFieldRec = ((
    FieldName: 'Name';
    FieldType: 'VarChar(25)';
    IsNull: 'NOT NULL';
    Default: ''
  ), (
    FieldName: 'Value';
    FieldType: 'VarChar(255)';
    IsNull: 'NULL';
    Default: ''
  ));
  c_lib_SQLite = 'sqlite3.dll';
  c_ScanCategoriesFile = 'vtScanCategories.d';
  c_MoreCategoriesFile = 'VtScanMoreCategories.txt';

// letter

  c_LetterHTML ='<HTML>' + #13#10 +
                    '<HEAD>' + #13#10 +
                        '<title>VisualTax - vtMobile2</title>' + #13#10 +
                    '</HEAD>' + #13#10 +
                    '<BODY>' + #13#10 +
                        '<table style="width: 100%">' + #13#10 +
                            '<colgroup>' + #13#10 +
                                '<col width="100%" valign="top" align="left"></col>' + #13#10 +
                            '</colgroup>' + #13#10 +
                            '<tr>' + #13#10 +
                                '<td align="center">' + #13#10 +
                                    '<b>Dear [!!TaxPayer!!].</b>' + #13#10 +
                                '</td>' + #13#10 +
                            '</tr>' + #13#10 +
                            '<tr>' + #13#10 +
                                '<td>' + #13#10 +
                                    '<p>&nbsp;&nbsp;An updated package of documents has been created and uploaded for you.</p>' + #13#10 +
                                    '<p>&nbsp;&nbsp;In order to get the updated package of documents, update the database in the program vtMobile2.</p>' + #13#10 +
                                    '<p>&nbsp;&nbsp;If you do not have an installed program vtMobile2, you can download it at:</p>' + #13#10 +
                                    '<br>' + #13#10 +
                                '</td>' + #13#10 +
                            '</tr>' + #13#10 +
                            '<tr>' + #13#10 +
                                '<td>' + #13#10 +
                                    '<table style="width: 100%">' + #13#10 +
                                        '<colgroup>' + #13#10 +
                                            '<col width="250px" valign="center" align="left"></col>' + #13#10 +
                                            '<col width="152px" valign="top" align="left"></col>' + #13#10 +
                                        '</colgroup>' + #13#10 +
                                        '<tr>' + #13#10 +
                                            '<td>' + #13#10 +
                                                'Android version direct link:' + #13#10 +
                                            '</td>' + #13#10 +
                                            '<td>' + #13#10 +
                                                '<a href="http://visualtax.com/vtmobile/download/vtMobile2.apk">vtMobile2.apk</a>' + #13#10 +
                                                '<br>' + #13#10 +
                                            '</td>' + #13#10 +
                                        '</tr>' + #13#10 +
                                        '<tr>' + #13#10 +
                                            '<td>' + #13#10 +
                                                '&nbsp;' + #13#10 +
                                            '</td>' + #13#10 +
                                        '</tr>' + #13#10 +
                                        '<tr>' + #13#10 +
                                            '<td>' + #13#10 +
                                                'Windows version direct link:' + #13#10 +
                                            '</td>' + #13#10 +
                                            '<td>' + #13#10 +
                                                '<a href="http://visualtax.com/vtmobile/download/vtMobile2Setup.exe">vtMobile2Setup.exe</a>' + #13#10 +
                                                '<br>' + #13#10 +
                                            '</td>' + #13#10 +
                                        '</tr>' + #13#10 +
                                        '<tr>' + #13#10 +
                                            '<td>' + #13#10 +
                                                '&nbsp;' + #13#10 +
                                            '</td>' + #13#10 +
                                        '</tr>' + #13#10 +
                                        '<tr>' + #13#10 +
                                            '<td colspan="2">' + #13#10 +
                                                '<div>Or visit&nbsp;<a href="http://visualtax.com/download.asp">Download page</a></div>' + #13#10 +
                                            '</td>' + #13#10 +
                                            '<td>' + #13#10 +
                                            '</td>' + #13#10 +
                                        '</tr>' + #13#10 +
                                    '</table>' + #13#10 +
                                '</td>' + #13#10 +
                            '</tr>' + #13#10 +
                            '<tr>' + #13#10 +
                                '<td>' + #13#10 +
                                    '<br>' + #13#10 +
                                    '<br>' + #13#10 +
                                    '<div><i>&nbsp;Best Regards, [!!Preparer!!].</i></div>' + #13#10 +
                                '<td>' + #13#10 +
                            '</tr>' + #13#10 +
                            '<tr>' + #13#10 +
                                '<td align="right">' + #13#10 +
                                    '<br>' + #13#10 +
                                    '<br>' + #13#10 +
                                    '<div><font size="2"><i>(The letter is generated automatically and does not require an answer.)</i></font></div>' + #13#10 +
                                '</td>' + #13#10 +
                            '</tr>' + #13#10 +
                            '<tr>' + #13#10 +
                                '<td align="right">' + #13#10 +
                                    '<br>' + #13#10 +
                                    '<div><font size="1"><i>Created by <a href="http://visualtax.com">VisualTax</a></i></font></div>' + #13#10 +
                                '</td>' + #13#10 +
                            '</tr>' + #13#10 +
                        '</table>' + #13#10 +
                    '</BODY>' + #13#10 +
                '</HTML>';
  c_LetterText ='  Dear [!!TaxPayer!!].' + #13#10 +
                '  An updated package of documents has been created and uploaded for you.' + #13#10 +
                '  In order to get the updated package of documents, update the database in the program vtMobile2.' + #13#10 +
                '  If you do not have an installed program vtMobile2, you can download it at:' + #13#10 +
                '' + #13#10 +
                'Android version direct link: http://visualtax.com/vtmobile/download/vtMobile2.apk' + #13#10 +
                'Windows version direct link: http://visualtax.com/vtmobile/download/vtMobile2Setup.exe' + #13#10 +
                '' + #13#10 +
                'Or visit Download page: http://visualtax.com/download.asp' + #13#10 +
                '' + #13#10 +
                'Best Regards, [!!Preparer!!].' + #13#10 +
                '' + #13#10 +
                '(The letter is generated automatically and does not require an answer.)' + #13#10 +
                'Created by VisualTax (http://visualtax.com)';

  c_TaxPayerTag = '[!!TaxPayer!!]';
  c_PreparerTag = '[!!Preparer!!]';

function CorrectPath(Apath: String): string;//20170327 Igor
var
  I: Integer;
begin
  Result := Apath;
  for I := 1 to Length(Result) do
    if CharInSet(Result[I], ['\','/',':','*','?','"','<','>','|',' ']) then
      Result[I] := '_';
end;


procedure StartFillDB(AApp: TApp);
begin
  With TfrmFillDBMain.Create(nil) do
  begin
    try
      FSilent := False;
      FApp := AApp;
      Start;
    finally
      Free;
    end;
  end;
end;

procedure SilentAddFile(AApp: TApp; AClientIdentificator: string; AFile: String; ADocumentType: string = ''); //20170403 Igor
begin
  With TfrmFillDBMain.Create(nil) do
  begin
    try
      FSilent := True;
      FApp := AApp;
      //20170403 Igor >>>
      if Start then
      begin
        if not qryDocumentTypes.locate('DocumentType', ADocumentType, [loCaseInsensitive]) then
        begin
          qryDocumentTypes.Append;
          qryDocumentTypes.FieldByname('DocumentType').AsString := ADocumentType;
          qryDocumentTypes.Post;
        end;
        if qryClients.Locate('File_Name', AClientIdentificator, [loCaseInsensitive]) then
          EditDocument(qryDocuments, qryDocumentTypes, qryDocumentFormat, ExtractFileDir(AFile),
            ExtractFileName(AFile), ADocumentType)
        //20170403 Igor <<<
        //20190118 Igor >>>
        {else
        begin
          MessageDlg('Client not exists in the mobile database.'+
                     ' Perhaps the return is not saved.', mtInformation, [mbOk], 0);
        end;}
        //20190118 Igor <<<
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmFillDBMain.actDocumentAddExecute(Sender: TObject);
begin
  qryDocuments.Append;
  EditDocument(qryDocuments, qryDocumentTypes, qryDocumentFormat, GetClientDir);
end;

procedure TfrmFillDBMain.actDocumentDeleteExecute(Sender: TObject);
begin
  if qryDocuments.IsEmpty then
    Exit;
  if MessageDlg('Delete the current document?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    exit;
  qryDocuments.Delete;
end;

procedure TfrmFillDBMain.actDocumentEditExecute(Sender: TObject);
begin
  EditDocument(qryDocuments, qryDocumentTypes, qryDocumentFormat, GetClientDir);
end;

procedure TfrmFillDBMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmFillDBMain.actFilterExecute(Sender: TObject);
begin
  qryClients.DisableControls;
  try
    qryClients.Filtered := False;
    qryClients.Filtered := True;
    qryClients.First;
  finally
    qryClients.EnableControls;
  end;
end;

procedure TfrmFillDBMain.actClearFilterExecute(Sender: TObject);
begin
  edtFilter.Text := '';
end;

procedure TfrmFillDBMain.actClientDeniedForAllExecute(Sender: TObject);
begin
  if qryClients.IsEmpty then
    exit;
  if MessageDlg('Deny access for all users?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    exit;
  conMain.StartTransaction;
  try
    conMain.ExecSQL('Delete from `ClientUsers` Where ClientID = ' + qryClients.FieldByName('Id').AsString);
    conMain.Commit;
  except
    on E: Exception do
    begin
      conMain.Rollback;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      Exit;
    end;
  end;
  qryClientUsers.Close;
  qryClientUsers.Open;
  qryClientsAfterScroll(qryClients);
end;

procedure TfrmFillDBMain.actClientGrantedForAllExecute(Sender: TObject);
begin
  if qryClients.IsEmpty then
    exit;
  if MessageDlg('Allow access for all users?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    exit;
  conMain.StartTransaction;
  try
    conMain.ExecSQL('Insert into `ClientUsers`(UserId, ClientId)' + #13 +
                    'Select U.Id, ' + qryClients.FieldByName('Id').AsString + #13 +
                    'from `Users` U' + #13 +
                    '  Left Outer Join `ClientUsers` CU ON CU.ClientID = ' + qryClients.FieldByName('Id').AsString + ' AND' + #13 +
                    '    CU.UserID = U.ID' + #13 +
                    'WHERE' + #13 +
                    '  CU.ClientID is null');
    conMain.Commit;
  except
    on E: Exception do
    begin
      conMain.Rollback;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      exit;
    end;
  end;
  qryClientUsers.Close;
  qryClientUsers.Open;
  qryClientsAfterScroll(qryClients);

end;

procedure TfrmFillDBMain.ActionList1Update(Action: TBasicAction; var Handled: Boolean);
begin
  if (Screen.ActiveForm.ClassType <> TfrmFillDBMain) or pnlWait.Visible then
  begin
    (Action as TAction).Enabled := False;
    exit;
  end;

  actUserAdd.Enabled := true;
  actUserEdit.Enabled := not qryUsers.IsEmpty;
  actUserDelete.Enabled := not qryUsers.IsEmpty;
  actUserAccessGranted.Enabled := not qryUsers.IsEmpty and not qryClients.IsEmpty and (qryUsers.FieldByName('isAllow').AsInteger = 0);
  actUserAccessDenied.Enabled := not qryUsers.IsEmpty and not qryClients.IsEmpty and (qryUsers.FieldByName('isAllow').AsInteger = 1);
  actUserAccessGrantedAll.Enabled := not qryUsers.IsEmpty and not qryClients.IsEmpty;
  actUserAccessDeniedAll.Enabled := not qryUsers.IsEmpty and not qryClients.IsEmpty;

  actClientGrantedForAll.Enabled := not qryClients.IsEmpty;
  actClientDeniedForAll.Enabled := not qryClients.IsEmpty;

  actDocumentAdd.Enabled := not qryClients.IsEmpty and (pgcMain.ActivePage = tsMain);
  actDocumentEdit.Enabled := not qryDocuments.IsEmpty and (pgcMain.ActivePage = tsMain) and (ActiveControl = grDocuments);
  actDocumentDelete.Enabled := not qryDocuments.IsEmpty and (pgcMain.ActivePage = tsMain) and (ActiveControl = grDocuments);

  actScan.Enabled := not qryClients.IsEmpty;
  actScanAll.Enabled := not qryClients.IsEmpty;
end;

function ExecAndWait(const FileName, Params: string; const WinState: Word): boolean; export;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;
  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath(Filename)), StartInfo, ProcInfo);
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

procedure TfrmFillDBMain.Wait(AStart: Boolean = True);
var
  I: Integer;
begin
  if AStart then
  begin
    pnlWait.SetBounds((Width div 2) - (pnlWait.Width div 2), (Height div 2) - (pnlWait.Height div 2), pnlWait.Width, pnlWait.Height);
  end;
  pnlWait.Visible := AStart;
  edtFilter.Enabled := not AStart;
  for I := 0 to ActionList1.ActionCount - 1 do
    (ActionList1.Actions[I] as TAction).Enabled := not AStart;
  Application.ProcessMessages;
end;

function FormatInClock(TickCount: Integer): string;
var
//  Days:   Integer;
  Hours: Integer;
  Minutes: Integer;
  Seconds: Integer;
  MSecs: Integer;
//  S_DAY:  string;
  S_HUR: string;
  S_MIN: string;
  S_SEC: string;
  S_MSC: string;
begin
  S_MSC := '000';
  S_SEC := '00';
  S_MIN := '00';
  S_HUR := '00';
//  S_DAY := '00';
  try
    if (TickCount > 0) then
    begin
      MSecs := TickCount mod 1000;
      TickCount := TickCount div 1000;
      S_MSC := Format('%.3d', [MSecs]);

      Seconds := TickCount mod 60;
      TickCount := TickCount div 60;
      S_SEC := Format('%.2d', [Seconds]);

      Minutes := TickCount mod 60;
      TickCount := TickCount div 60;
      S_MIN := Format('%.2d', [Minutes]);

      Hours := TickCount mod 24;
      S_HUR := Format('%.2d', [Hours]);

//      Days := TickCount div 24;
//      S_DAY := Format('%.2d', [Days]);
    end;
  finally
    Result := {S_DAY
            + ':'
            + }S_HUR + ':' + S_MIN + ':' + S_SEC + ':' + S_MSC;
  end;
end;

procedure TfrmFillDBMain.actScanAllExecute(Sender: TObject);
var
  t1, t2, t3: Integer;
begin
  qryClients.Last;
  qryClients.First;
  pb.Max := qryClients.RecordCount;
  lblProgress.Caption := '1 of ' + IntToStr(qryClients.RecordCount);
  ScanStop := False;
  pnlProgress.Visible := True;
  grClients.Enabled := False;
  Wait;

  try
    Application.ProcessMessages;
    t1 := GetTickCount;
    while not qryClients.Eof do
    begin
      actScanExecute(actScan);
      pb.Position := qryClients.RecNo;
      t2 := GetTickCount;
      t3 := ((t2 - t1) div qryClients.RecNo) * qryClients.RecordCount - (t2 - t1);
      lblProgress.Caption := FormatCurr('000', qryClients.RecNo) + ' of ' + FormatFloat('000', qryClients.RecordCount) + #9'Passed ' + FormatInClock(t2 - t1) + #9'Left ' + FormatInClock(t3);

      Application.ProcessMessages;
      if ScanStop then
        Exit;
      qryClients.Next;
    end;
  finally
    Wait(False);
    pnlProgress.Visible := False;
    grClients.Enabled := true;
    grClients.Repaint;
  end;
end;

procedure TfrmFillDBMain.actScanExecute(Sender: TObject);
begin
  EditDocument(qryDocuments, qryDocumentTypes, qryDocumentFormat, GetClientDir, True);
end;

procedure TfrmFillDBMain.actUploadDBForUserExecute(Sender: TObject);//20170327 Igor
var
  HelperID: Integer;
  CloudPath, ClientID, HelperClassName, Token, SharedFile,
  S: string;
begin
  Wait;
  try
    if not MakeSharedDB(SharedFile) then
      Exit;
    if not SelectManager(HelperID) then
      Exit;
    HelperClassName := HelperManager.HelperClassList.Keys.ToArray[HelperID].ClassName;
    CloudPath := ReplaceStr(HelperManager.Config(HelperClassName, FApp.AppId, User.UserName).Path, '\', '/') + '/Shared/' +
      CorrectPath(qryUsers.FieldByName('Email').asString);
    ClientID := HelperManager.Config(HelperClassName).ClientID;
    Token := HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token;

    if HelperManager.Send(HelperID, SharedFile,
       CloudPath, ExtractFileName(SharedFile), ClientID, Token) then
    begin
      if HelperManager.Config(HelperID, FApp.AppId, User.UserName).SaveToken and
        (Token <> '') and
        (Token <> HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token) then
        HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token := Token;
      if HelperManager.SetShare(HelperID, qryUsers.FieldByName('Email').asString,
        CloudPath, c_MobileDBName, ClientID, Token) then
      begin
        if HelperManager.Config(HelperID, FApp.AppId, User.UserName).SaveToken and
          (Token <> '') and
          (Token <> HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token) then
          HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token := Token;
        S := 'Upload DB for client ' + qryUsers.FieldByName('Login').asString +
          ' (' + qryUsers.FieldByName('Email').asString + ') completed.';
        if SendEmail(qryUsers.FieldByName('Login').asString, qryUsers.FieldByName('Email').asString) then
          S := S + #13 + 'Notifications e-mail sended';
        MessageDlg(S, mtInformation, [mbOk], 0);
      end
      else
        MessageDlg('Upload DB for client ' + qryUsers.FieldByName('Login').asString +
          ' (' + qryUsers.FieldByName('Email').asString + ') failed!', mtError, [mbOk], 0);
    end
    else
      MessageDlg('Upload DB for client ' + qryUsers.FieldByName('Login').asString +
        ' (' + qryUsers.FieldByName('Email').asString + ') failed!', mtError, [mbOk], 0);
    if FileExists(SharedFile) then
      DeleteFile(SharedFile);
  finally
    Wait(False);
  end;
end;

procedure TfrmFillDBMain.actUploadToCloudExecute(Sender: TObject);
var
  CloudPath, ClientId, Token: string;
  HelperClassName, s: string;
  HelperID: Integer;
begin
  //Disconnect
  conMain.Connected := False;
  Wait;
  try

    if not SelectManager(HelperID) then
      Exit;

    S := '';
    // := 0;
    HelperClassName := HelperManager.HelperClassList.Keys.ToArray[HelperID].ClassName;
    CloudPath := HelperManager.Config(HelperClassName, FApp.AppId, User.UserName).Path; //20170112 Igor
    ClientID := HelperManager.Config(HelperClassName).ClientID;
    Token := HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token; //20170112 Igor
    if HelperManager.Send(HelperID, conMain.Params.Values['DataBase'],
         CloudPath, ExtractFileName(conMain.Params.Values['DataBase']), ClientID, Token) then
      S := S + HelperManager.HelperClassList.Values.ToArray[HelperId] + ' upload complete.' + #13
    else
      S := S + HelperManager.HelperClassList.Values.ToArray[HelperId] + ' upload failed!' + #13;
    if HelperManager.Config(HelperID, FApp.AppId, User.UserName).SaveToken and //20170112 Igor
      (Token <> '') and
      (Token <> HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token) then //20170112 Igor
      HelperManager.Config(HelperID, FApp.AppId, User.UserName).Token := Token; //20170112 Igor

    if S <> '' then
      MessageDlg(S, mtInformation, [mbOk], 0);

  finally
    CheckConnection;
    OpenData;
    Wait(False);
  end;
end;

procedure TfrmFillDBMain.actUserAccessDeniedAllExecute(Sender: TObject);
begin
  if qryUsers.IsEmpty then
    exit;
  if MessageDlg('Deny access to all the clients?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    exit;
  conMain.StartTransaction;
  try
    conMain.ExecSQL('Delete from `ClientUsers` Where UserID = ' + qryUsers.FieldByName('ID').AsString);
    conMain.Commit;
  except
    on E: Exception do
    begin
      conMain.Rollback;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      exit;
    end;
  end;
  qryClientUsers.Close;
  qryClientUsers.Open;
  qryClientsAfterScroll(qryClients);
end;

procedure TfrmFillDBMain.actUserAccessGrantedAllExecute(Sender: TObject);
begin
  if qryUsers.IsEmpty then
    exit;
  if MessageDlg('Allow access to all the clients?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    exit;
  conMain.StartTransaction;
  try
    conMain.ExecSQL('Insert into `ClientUsers`(UserId, ClientId)' + #13 +
                    'Select ' + qryUsers.FieldByName('ID').AsString + ', Cl.Id' + #13 +
                    'from `Clients` Cl' + #13 +
                    '  Left Outer Join `ClientUsers` CU ON CU.UserID = ' + qryUsers.FieldByName('ID').AsString + ' AND' + #13 +
                    '    CU.ClientID = Cl.ID' + #13 +
                    'WHERE' + #13 +
                    '  CU.ClientID is null');
    conMain.Commit;
  except
    on E: Exception do
    begin
      conMain.Rollback;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      exit;
    end;
  end;
  qryClientUsers.Close;
  qryClientUsers.Open;
  qryClientsAfterScroll(qryClients);
end;

procedure TfrmFillDBMain.actUserAccessGrantedExecute(Sender: TObject);
begin
  grUsersDblClick(nil);
end;

procedure TfrmFillDBMain.actUserAddExecute(Sender: TObject);
begin
  qryUserSingle.Close;
  qryUserSingle.ParamByName('Id').AsInteger := 0;
  qryUserSingle.Open;
  qryUserSingle.Append;
  if EditUser(qryUserSingle) then
    UpdateUser;
end;

procedure TfrmFillDBMain.actUserDeleteExecute(Sender: TObject);
begin
  if qryUsers.IsEmpty then
    Exit;
  if MessageDlg('Delete the current user?', mtConfirmation, mbYesNoCancel, 0) <> mrYes then
    exit;
  conMain.StartTransaction;
  try
    conMain.ExecSQL('Delete from `' + c_tbl_ClientUsers + '` Where UserId = ' + qryUsers.FieldByName('ID').AsString);
    conMain.ExecSQL('Delete from `' + c_tbl_Users + '` Where ID = ' + qryUsers.FieldByName('ID').AsString);
    conMain.Commit;
  except
    on E: Exception do
    begin
      conMain.Rollback;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      exit;
    end;
  end;
  qryUsers.Delete;
  qryClientUsers.Close;
  qryClientUsers.Open;
end;

procedure TfrmFillDBMain.actUserEditExecute(Sender: TObject);
begin
  if qryUsers.IsEmpty then
  begin
    actUserAdd.Execute;
    exit;
  end;
  qryUserSingle.Close;
  qryUserSingle.ParamByName('Id').AsInteger := qryUsers.FieldByName('ID').AsInteger;
  qryUserSingle.Open;
  if EditUser(qryUserSingle) then
    UpdateUser;
end;

procedure TfrmFillDBMain.btnStopClick(Sender: TObject);
begin
  ScanStop := True;
end;

function TfrmFillDBMain.CheckConnection: Boolean;
begin
  result := False;
  DriverLink.VendorLib := ExtractFilePath(Application.exeName) + c_lib_SQLite;
  //Mobile DB
  conMain.Params.Values['DataBase'] := IncludeTrailingPathDelimiter(FApp.Dir_Cur) + c_MobileDBName;
  try
    conMain.Connected := True;
  except
    on E: exception do
    begin
      if FileExists(conMain.Params.Values['DataBase']) then
      begin
        try
          DeleteFile(conMain.Params.Values['DataBase']);
          conMain.Connected := True;
          MessageDlg('Can not connect to mobile database (' + conMain.Params.Values['DataBase'] + '). Error message:' + #13 +
                     E.Message + #13 +
                     'Database recreated', mtWarning, [mbOk], 0);
        except
          on EE: Exception do
          begin
            MessageDlg('Can not connect to mobile database (' + conMain.Params.Values['DataBase'] + '). Error message:' + #13 +
                       E.Message, mtWarning, [mbOk], 0);
            exit;
          end;
        end;
      end;
    end;
  end;

  //Source client DB
  if not SetConnection(conSourceClient, IncludeTrailingPathDelimiter(FApp.Dir_Cur) + FApp.ClientsDBLite,
    ClientsTableLite, False, False) then
   Exit(False);

  //all ok
  Result := True;
end;

function TfrmFillDBMain.CheckData: Boolean;
var
  SrcTbl, DstTbl: TADQuery;
  I: Integer;
  strm: TMemoryStream;
  sl: TStringList;
begin
  Result := False;
  SrcTbl := CreateQuery(conSourceClient);
  try
    DstTbl := CreateQuery(conMain);
    try
      SrcTbl.SQL.Text := 'Select * from `' + ClientsTableLite + '`';
      SrcTbl.Open;
      DstTbl.SQL.Text := 'Select * from `' + c_tbl_Clients + '`';
      DstTbl.Open;
      while not SrcTbl.Eof do
      begin
        if DstTbl.Locate('File_Name', SrcTbl.FieldByName('File_Name').AsString, [loCaseInsensitive]) then
        begin
          for I := 0 to DstTbl.FieldCount - 1 do
          begin
            if SrcTbl.FindField(DstTbl.Fields[I].FieldName) <> nil then
            begin
              if DstTbl.Fields[I].Value <> SrcTbl.FieldByName(DstTbl.Fields[I].FieldName).Value then
              begin
                if DstTbl.State <> dsEdit then
                  DstTbl.Edit;
                DstTbl.Fields[I].Value := SrcTbl.FieldByName(DstTbl.Fields[I].FieldName).Value;
              end;
            end;
          end;
          if DstTbl.State = dsEdit then
          try
            DstTbl.Post;
          except
            on E: Exception do
            begin
              MessageDlg('Can not update data in table "' + c_tbl_Clients + '". Error message:' + E.Message, mtError, [mbOk], 0);
              Exit;
            end;
          end;
        end
        else
        begin
          DstTbl.Append;
          for I := 0 to DstTbl.FieldCount - 1 do
          begin
            if SrcTbl.FindField(DstTbl.Fields[I].FieldName) <> nil then
              DstTbl.Fields[I].Value := SrcTbl.FieldByName(DstTbl.Fields[I].FieldName).Value;
          end;
          try
            DstTbl.Post;
          except
            on E: Exception do
            begin
              MessageDlg('Can not update data in table "' + c_tbl_Clients + '". Error message:' + E.Message, mtError, [mbOk], 0);
              Exit;
            end;
          end;
        end;

        SrcTbl.Next;
      end;
    finally
      FreeAndNil(DstTbl);
    end;
  finally
    FreeAndNil(SrcTbl);
  end;
  with CreateQuery(conMain) do
  begin
    try
      SQL.Text := 'Select * from `' + c_tbl_Users + '`';
      Open;
      if IsEmpty then
      begin
        Append;
        FieldByname('IsAdmin').AsInteger := 1;
        FieldByname('Login').AsString := 'Admin';
        FieldByname('Password').AsString := 'Admin';
        FieldByname('Email').AsString := 'No email';
        Post;
      end;
      Close;

      SQL.Text := 'Select * from `' + c_tbl_DocumentTypes + '`';
      Open;
      if FileExists(IncludeTrailingPathDelimiter(FApp.AppDir) + c_ScanCategoriesFile) then
      begin
        sl := TStringList.Create;
        try
          sl.LoadFromFile(IncludeTrailingPathDelimiter(FApp.AppDir) + c_ScanCategoriesFile);
          for I := 0 to sl.Count - 1 do
          begin
            if (Trim(sl[I]) <> '') and not locate('DocumentType', sl[I], [loCaseInsensitive]) then
            begin
              Append;
              FieldByname('DocumentType').AsString := sl[I];
              Post;
            end;
          end;
        finally
          sl.Free;
        end;
      end;
      if FileExists(IncludeTrailingPathDelimiter(FApp.AppDir) + c_MoreCategoriesFile) then
      begin
        sl := TStringList.Create;
        try
          sl.LoadFromFile(IncludeTrailingPathDelimiter(FApp.AppDir) + c_MoreCategoriesFile);
          for I := 0 to sl.Count - 1 do
          begin
            if (Trim(sl[I]) <> '') and not locate('DocumentType', sl[I], [loCaseInsensitive]) then
            begin
              Append;
              FieldByname('DocumentType').AsString := sl[I];
              Post;
            end;
          end;
        finally
          sl.Free;
        end;
      end;

      if not Locate('DocumentType', 'TAX SUMMARY', [loCaseInsensitive]) then
      begin
        Append;
        FieldByname('DocumentType').AsString := 'TAX SUMMARY';
        Post;
      end;
      Close;

      SQL.Text := 'Select * from `' + c_tbl_DocumentFormat + '`';
      Open;
      if not Locate('DocumentFormat', 'PDF', [loCaseInsensitive]) then
      begin
        Append;
        strm := TMemoryStream.Create;
        try
          imgPDF.Picture.Bitmap.SaveToStream(strm);
          strm.Position := 0;
          FieldByname('DocumentFormat').AsString := 'PDF';
          TBlobField(FieldByname('Picture')).LoadFromStream(strm);
          FieldByName('FileExtension').AsString := 'pdf';
        finally
          freeAndNil(strm);
        end;
        Post;
      end;
      if not Locate('DocumentFormat', 'DOC', [loCaseInsensitive]) then
      begin
        Append;
        strm := TMemoryStream.Create;
        try
          imgDOC.Picture.Bitmap.SaveToStream(strm);
          strm.Position := 0;
          FieldByname('DocumentFormat').AsString := 'DOC';
          TBlobField(FieldByname('Picture')).LoadFromStream(strm);
          FieldByName('FileExtension').AsString := 'doc';
        finally
          freeAndNil(strm);
        end;
        Post;
      end;
      //20170403 igor >>>
      if not Locate('DocumentFormat', 'HTML', [loCaseInsensitive]) then
      begin
        Append;
        strm := TMemoryStream.Create;
        try
          imgHTML.Picture.Bitmap.SaveToStream(strm);
          strm.Position := 0;
          FieldByname('DocumentFormat').AsString := 'HTML';
          TBlobField(FieldByname('Picture')).LoadFromStream(strm);
          FieldByName('FileExtension').AsString := 'html';
        finally
          freeAndNil(strm);
        end;
        Post;
      end;
      //20170403 igor <<<
    finally
      Close;
      free;
    end;
  end;
  // All Ok
  Result := True;
end;

function TfrmFillDBMain.CheckIndexes(ASrcConnection, ADstConnection: TADConnection; ASrcTableName, ADstTableName: string): Boolean;
begin
  result := False;
  if assigned(ASrcConnection) then
  begin
    with CreateQuery(ASrcConnection) do
    begin
      try
        SQL.Text := 'Select * from sqlite_master where type = ''index'' and Upper(tbl_name) like Upper(' + QuotedStr(ASrcTableName) + ')';
        Open;
        while not eof do
        begin
          if not IndexExists(ADstConnection, ADstTableName, FieldByName('name').AsString, FieldByName('sql').AsString, true) then
            Exit;
          next;
        end;
      finally
        Close;
        Free;
      end;
    end;
  end;
  //All Ok
  Result := True;
end;

function TfrmFillDBMain.FieldExists(AConnection: TADConnection; ATableName, AFieldName, AFieldType, AIsNull, ADefault: string; ACreateIfNotExists: Boolean): Boolean;

  function GenerateDefault: string;
  begin
    if ADefault = '' then
      Result := ''
    else
      Result := ' Default (' + ADefault + ')';
  end;

begin
  with CreateQuery(AConnection) do
  try
    SQL.Text := 'PRAGMA table_info(' + QuotedStr(ATableName) + ')';
    Open;
    Result := Locate('Name', AFieldName, [loCaseInsensitive]);
    if not Result and ACreateIfNotExists then
    begin
      SQL.Text := 'ALTER TABLE `' + ATableName + '` ADD `' + AFieldName + '` ' + AFieldType + ' ' + AIsNull + GenerateDefault;
      try
        ExecSQL;
        Result := True;
      except
        on E: Exception do
        begin
          Result := False;
          MessageDlg(E.Message, mtError, [mbOk], 0);
        end;
      end;
    end;
  finally
    free;
  end;
end;

function TfrmFillDBMain.CheckStructure(AConnection: TADConnection; ATableName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  if SameText(ATableName, c_tbl_Users) then
  begin
    for I := 0 to Length(c_tbl_UsersFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_UsersFields[I].FieldName, c_tbl_UsersFields[I].FieldType, c_tbl_UsersFields[I].IsNull, c_tbl_UsersFields[I].Default, True) then
        exit;
  end
  else if SameText(ATableName, c_tbl_ClientUsers) then
  begin
    for I := 0 to Length(c_tbl_ClientUsersFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_ClientUsersFields[I].FieldName, c_tbl_ClientUsersFields[I].FieldType, c_tbl_ClientUsersFields[I].IsNull, c_tbl_ClientUsersFields[I].Default, True) then
        exit;
  end
  else if SameText(ATableName, c_tbl_DocumentTypes) then
  begin
    for I := 0 to Length(c_tbl_DocumentTypesFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_DocumentTypesFields[I].FieldName, c_tbl_DocumentTypesFields[I].FieldType, c_tbl_DocumentTypesFields[I].IsNull, c_tbl_DocumentTypesFields[I].Default, True) then
        exit;
  end
  else if SameText(ATableName, c_tbl_DocumentFormat) then
  begin
    for I := 0 to Length(c_tbl_DocumentFormatFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_DocumentFormatFields[I].FieldName, c_tbl_DocumentFormatFields[I].FieldType, c_tbl_DocumentFormatFields[I].IsNull, c_tbl_DocumentFormatFields[I].Default, True) then
        exit;
  end
  else if SameText(ATableName, c_tbl_Documents) then
  begin
    for I := 0 to Length(c_tbl_DocumentsFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_DocumentsFields[I].FieldName, c_tbl_DocumentsFields[I].FieldType, c_tbl_DocumentsFields[I].IsNull, c_tbl_DocumentsFields[I].Default, True) then
        exit;
  end
  else if SameText(ATableName, c_tbl_Settings) then
  begin
    for I := 0 to Length(c_tbl_SettingsFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_SettingsFields[I].FieldName, c_tbl_SettingsFields[I].FieldType, c_tbl_SettingsFields[I].IsNull, c_tbl_SettingsFields[I].Default, True) then
        exit;
  end
  else
    Exit;
  //All Ok
  Result := True;
end;

function TfrmFillDBMain.CheckStructure(AConnection: TADConnection): Boolean;//20170327 Igor

  function Check(ATableName: string): Boolean;
  begin
    Result := False;
    if not TableExists(AConnection, ATableName) then
      if not CreateTable(AConnection, ATableName) then
        Exit
      else

    else if not CheckStructure(AConnection, ATableName) then
      exit;
    Result := true;
  end;

begin
  Result := False;
  if not TableExists(AConnection, c_tbl_Clients) then
    if not CreateTable(conSourceClient, AConnection, ClientsTableLite, c_tbl_Clients) then
      Exit
    else

  else if not CompareStructure(conSourceClient, AConnection, ClientsTableLite, c_tbl_Clients) then
    exit;

  if not Check(c_tbl_Users) then
    Exit;
  if not Check(c_tbl_ClientUsers) then
    Exit;
  if not Check(c_tbl_DocumentTypes) then
    Exit;
  if not Check(c_tbl_DocumentFormat) then
    Exit;
  if not Check(c_tbl_Documents) then
    Exit;
  if not Check(c_tbl_Settings) then
    Exit;

  //all ok
  Result := True;
end;

function TfrmFillDBMain.CompareStructure(ASrcConnection, ADstConnection: TADConnection; ASrcTableName, ADstTableName: string): Boolean;

  function GetisNull(AIsNull: string): string;
  begin
    if AIsNull = '1' then
      Result := 'NOT NULL'
    else
      Result := 'NULL';
  end;

begin
  Result := False;
  with CreateQuery(ADstConnection) do
  begin
    try
      SQL.Text := 'PRAGMA table_info(' + QuotedStr(ASrcTableName) + ')';
      Open;
      while not eof do
      begin
        if not FieldExists(ADstConnection, ADstTableName, FieldByName('name').AsString, FieldByName('type').AsString, GetisNull(FieldByName('notnull').AsString), FieldByName('dflt_value').AsString, True) then
          exit;
        Next;
      end;
      //Index
      if not CheckIndexes(ASrcConnection, ADstConnection, ASrcTableName, ADstTableName) then
        exit;
    finally
      close;
      Free;
    end;
  end;
  Result := True;
end;

function TfrmFillDBMain.CreateQuery(AConnection: TADConnection): TADQuery;
begin
  Result := TADQuery.Create(nil);
  Result.Connection := AConnection;
end;

function TfrmFillDBMain.CreateTable(AConnection: TADConnection; ATableName: string): Boolean;
begin
  Result := CreateTable(nil, AConnection, '', ATableName);
end;

function TfrmFillDBMain.CreateTable(ASrcConnection, ADstConnection: TADConnection; ASrcTableName, ADstTableName: string): Boolean;
var
  CreateSQL: string;
begin
  Result := False;
  if Assigned(ASrcConnection) and (ASrcTableName <> '') then
  begin
    if not GenerateDDL(ASrcConnection, ASrcTableName, CreateSQL) then
      exit;
  end
  else if not GetDDL(ADstTableName, CreateSQL) then
    Exit;

  with CreateQuery(ADstConnection) do
  begin
    try
      SQL.Text := CreateSQL;
      try
        ExecSQL;
      except
        on E: Exception do
        begin
          MessageDlg('Can not Create Table "' + ADstTableName + '". Error message:' + #13 + E.Message, mtError, [mbOk], 0);
          Exit;
        end;
      end;
    finally
      Close;
      Free;
    end;
  end;
  if not CheckIndexes(ASrcConnection, ADstConnection, ASrcTableName, ADstTableName) then
    exit;

  //All Ok
  Result := True;
end;

procedure TfrmFillDBMain.edSMTPServerExit(Sender: TObject);
begin
  if Sender is TCustomEdit then
  begin
    if (Sender as TCustomEdit).Modified then
    begin
      if Sender = edSMTPServer then
        SaveSettings('PREPARER:SMTP_SERVER', edSMTPServer.Text)
      else
      if Sender = edSMTPPort then
        SaveSettings('PREPARER:SMTP_PORT', edSMTPPort.Text)
      else
      if Sender = edSMTPLogin then
        SaveSettings('PREPARER:SMTP_LOGIN', edSMTPLogin.Text)
      else
      if Sender = edSMTPPassword then
        SaveSettings('PREPARER:SMTP_PASSWORD', edSMTPPassword.Text);


      (Sender as TCustomEdit).Modified := False;
    end;
  end
  else
  if Sender is TCustomComboBox then
  begin
    if Sender = cbUseTLS then
      SaveSettings('PREPARER:SMTP_USETLS', cbUseTLS.ItemIndex)
    else
    if Sender = cbSSLVersion then
      SaveSettings('PREPARER:SMTP_SSLVERSION', cbSSLVersion.ItemIndex);
  end
  else
  if Sender is TCustomCheckBox then
  begin
    if Sender = chbSendNotificationEmail then
      SaveSettings('PREPARER:SEND_MAIL', chbSendNotificationEmail.Checked)
  end;
end;

function TfrmFillDBMain.GenerateDDL(AConnection: TADConnection; ATableName: string; out ADDL: string): Boolean;
var
  X: Integer;
begin
  Result := False;
  with CreateQuery(AConnection) do
  begin
    try
      SQL.Text := 'SELECT sql FROM sqlite_master WHERE type=''table'' AND upper(name) like upper(' + QuotedStr(ATableName) + ')';
      Open;
      if not isEmpty then
      begin
        Result := True;
        ADDL := FieldByName('sql').AsString;
        if pos('ID INTEGER PRIMARY KEY AUTOINCREMENT,', upperCase(ADDL)) = 0 then
        begin
          X := pos('(', ADDL);
          ADDL := Copy(ADDL, 1, X) + 'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' + Copy(ADDL, X + 1, MaxInt);
        end;
      end;
    finally
      free;
    end;
  end;
end;

function TfrmFillDBMain.GetClientDir: string;
begin
  Result := '';
  if qryClients.IsEmpty then
    Exit;
  // for T1
  if (qryClients.FindField('First_Name') <> nil) and (qryClients.FindField('Last_Name') <> nil) then
    Result := IncludeTrailingPathDelimiter(FApp.Dir_ClientDocs) + qryClients.FieldByName('Last_Name').AsString + ',' + qryClients.FieldByName('First_Name').AsString
  else
    Result := ExcludeTrailingPathDelimiter(FApp.Dir_ClientDocs);
end;

function TfrmFillDBMain.GetClientName: string;
var
  I: Integer;
begin
  Result := '';
  if qryClients.IsEmpty then
    Exit;

  for I := 0 to qryClients.FieldCount - 1 do
    if (
         (
           (Pos('name', LowerCase(qryClients.Fields[I].FieldName)) > 0)
           and
           not sametext(qryClients.Fields[I].FieldName, 'file_name')
         )
         or
         sametext(qryClients.Fields[I].FieldName, 'sin')
       )
       and
       (qryClients.Fields[I].AsString <> '') then
    begin
      if Result <> '' then
        Result := Result + ', ';
      Result := Result + qryClients.Fields[I].AsString;
    end;
end;

function TfrmFillDBMain.GetDDL(ATableName: string; out ADDL: string): Boolean;
begin
  if SameText(ATableName, c_tbl_Users) then
    ADDL := c_tbl_UsersDDL
  else if SameText(ATableName, c_tbl_ClientUsers) then
    ADDL := c_tbl_ClientUsersDDL
  else if SameText(ATableName, c_tbl_DocumentTypes) then
    ADDL := c_tbl_DocumentTypesDDL
  else if SameText(ATableName, c_tbl_DocumentFormat) then
    ADDL := c_tbl_DocumentFormatDDL
  else if SameText(ATableName, c_tbl_Documents) then
    ADDL := c_tbl_DocumentsDDL
  else if SameText(ATableName, c_tbl_Settings) then
    ADDL := c_tbl_SettingsDDL
  else
    ADDL := '';

  Result := ADDL <> '';
end;

procedure TfrmFillDBMain.grClientsTitleClick(Column: TColumn);
var
  fld: string;
begin
  if Column.Field.IsBlob then
    exit;
  if Column.Field.Lookup then
    fld := Column.Field.KeyFields
  else
    fld := Column.FieldName;
  with TADQuery(Column.Grid.DataSource.DataSet) do
  begin
    if (fld = IndexFieldNames) then
      IndexFieldNames := ''
    else
      IndexFieldNames := fld;
  end;
end;

procedure TfrmFillDBMain.grUsersDblClick(Sender: TObject);
begin
  if qryUsers.IsEmpty then
    exit;
  if qryClients.IsEmpty then
    exit;
  if qryClientUsers.locate('UserId;ClientId', VarArrayOf([qryUsers.FieldByName('ID').AsInteger, qryClients.FieldByName('ID').AsInteger]), []) then
  begin
    qryClientUsers.Delete;
  end
  else
  begin
    qryClientUsers.Append;
    qryClientUsers.FieldByName('UserId').AsInteger := qryUsers.FieldByName('ID').AsInteger;
    qryClientUsers.FieldByName('ClientId').AsInteger := qryClients.FieldByName('ID').AsInteger;
    qryClientUsers.Post;
  end;
  qryClientsAfterScroll(qryClients);
end;

procedure TfrmFillDBMain.grUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
(*var
  S, S2: Widestring;
  X, L: Integer;*)
begin
  if (Sender = grUsers) and not qryUsers.IsEmpty then
  begin
    if SameText(Column.Field.FieldName, 'isAllow') then
    begin
      TDBGrid(Sender).Canvas.FillRect(Rect);
      if (qryUsers.FieldByName('isAllow').AsInteger = 1) or
         (qryUsers.FieldByName('isAdmin').AsInteger = 1) then
        il16X16.Draw(TDBGrid(Sender).Canvas, Rect.Left + (Rect.Width div 2) - (il16X16.Width div 2), Rect.Top + 1, 14);
    end;

    if SameText(Column.Field.FieldName, 'IsAdmin') then
    begin
      TDBGrid(Sender).Canvas.FillRect(Rect);
      if (qryUsers.FieldByName('isAdmin').AsInteger = 1) then
        il16X16.Draw(TDBGrid(Sender).Canvas, Rect.Left + (Rect.Width div 2) - (il16X16.Width div 2), Rect.Top + 1, 10);
    end;
  end;
(*  if (Column.Field is TBlobField) or (Column.Field is TMemoField) then
  begin
    S := Column.Field.AsString;
    TDBGrid(Sender).Canvas.FillRect(Rect);
    TDBGrid(Sender).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
  if (Sender = grClients) and (edtFilter.Text <> '') then
  begin
    S := Column.Field.AsString;
    X := pos(AnsiUpperCase(edtFilter.Text), AnsiUpperCase(S));
    if X > 0 then
    begin
      S2 := Copy(S, 1, X - 1);
      L := TDBGrid(Sender).Canvas.TextWidth(S2);
      S2 := Copy(S, X, length(edtFilter.Text));
      TDBGrid(Sender).Canvas.Font.Color := clRed;
      TDBGrid(Sender).Canvas.Brush.Style := bsClear;
      TDBGrid(Sender).Canvas.TextOut(Rect.Left + L + 3, Rect.Top + 2, S2);
    end;
  end;  *)
end;

function TfrmFillDBMain.IndexExists(AConnection: TADConnection; ATableName, AIndexName, ASQL: string; ACreateIfNotExists: Boolean): boolean;

  function RebuildSQL(ASrcSQL: string): string;
  begin
    Result := TRegEx.Replace(ASrcSQL, 'ON .{,}\(', 'ON ' + ATableName + '(');
  end;

begin
  with CreateQuery(AConnection) do
  begin
    try
      SQL.Text := 'Select * from sqlite_master where type = ''index'' and ' + 'Upper(name) like Upper(' + QuotedStr(AIndexName) + ') AND ' + 'Upper(tbl_name) like Upper(' + QuotedStr(ATableName) + ')';
      Open;
      Result := not isEmpty;
      if not Result and ACreateIfNotExists and (ASQL <> '') then
      begin
        SQL.Text := RebuildSQL(ASQL);
        try
          ExecSQL;
        except
          on E: Exception do
          begin
            MessageDlg('Can not create index "' + AIndexName + '". Exception message:' + #13 + E.Message, mtError, [mbOk], 0);
            exit;
          end;
        end;
      end;
    finally
      Free;
    end;
  end;
  //all ok
  Result := True;
end;

function TfrmFillDBMain.initStartParams: Boolean;
begin
// BasePath                                    Source Cl DB    Cl Tbl    Password        DropBox_ClientID  VisualTaxUserId vtTaxModulePath              ClientDir
// "c:\XE4\xe4-Vt-2015\DistrFl\T1-2015\Data\"  "CLIENTS_T1.db" "Clients" "T1IGORDODINOC" "g5fgaczz3lbww9n" "ADMIN" "c:\XE4\xe4-Vt-2015\DistrFl\T1-2015" "c:\XE4\xe4-Vt-2015\DistrFl\T1-2015\ClientDocs"
  Result := False;

  if not Assigned(FApp) then
  begin
    MessageDlg('Tax module not defined.', mtError, [mbOk], 0);
    exit;
  end;

  if not DirectoryExists(FApp.Dir_Cur) then
  begin
    MessageDlg('Directory "' + FApp.Dir_Cur + '" does not exists', mtError, [mbOk], 0);
    exit;
  end;

  if not FileExists(IncludeTrailingPathDelimiter(FApp.Dir_Cur) + FApp.ClientsDBLite) then
  begin
    MessageDlg('Client database not found', mtError, [mbOk], 0);
    exit;
  end;

  if not DirectoryExists(FApp.AppDir) then
  begin
    MessageDlg('Directory "' + FApp.AppDir + '" does not exists', mtError, [mbOk], 0);
    exit;
  end;

  if (Trim(FApp.Dir_ClientDocs) <> '') and not DirectoryExists(FApp.Dir_ClientDocs) then
  begin
    MessageDlg('Directory "' + FApp.Dir_ClientDocs + '" does not exists', mtError, [mbOk], 0);
    exit;
  end;

  LoadPluginSettings(FApp.AppId, User.UserName, Self, pgcSettings);

  // all ok
  Result := true;
end;

function TfrmFillDBMain.MakeSharedDB(out ASharedFilePath: String): Boolean; //20170327 Igor
var
  con: TADConnection;
  SrcTbl, DstTbl: TADQuery;

  function CopyData(ASrcSQL, ADstSQL, ATableName: String): Boolean;
  var
    I: Integer;
    SQLUpdate: string;

  begin
    SrcTbl.SQL.Text := ASrcSQL;
    SrcTbl.Open;
    DstTbl.SQL.Text := ADstSQL;
    DstTbl.Open;
    SQLUpdate := 'INSERT INTO `' + ATableName + '`(';
    for I := 0 to DstTbl.FieldCount - 1 do
      SQLUpdate := SQLUpdate + '`' + DstTbl.Fields[I].FieldName + '`,';
    SQLUpdate[Length(SQLUpdate)] := ')';
    SQLUpdate := SQLUpdate + ' Values (';
    for I := 0 to DstTbl.FieldCount - 1 do
      SQLUpdate := SQLUpdate + ':' + DstTbl.Fields[I].FieldName + ',';
    SQLUpdate[Length(SQLUpdate)] := ')';
    with CreateQuery(Con) do
    try
      SQL.Text := SQLUpdate;
      while not SrcTbl.Eof do
      begin
        for I := 0 to DstTbl.FieldCount - 1 do
        begin
          if SrcTbl.FindField(DstTbl.Fields[I].FieldName) <> nil then
          begin
            ParamByName(DstTbl.Fields[I].FieldName).DataType := DstTbl.Fields[I].DataType;
            ParamByName(DstTbl.Fields[I].FieldName).Value := SrcTbl.FieldByName(DstTbl.Fields[I].FieldName).Value;
          end;
        end;
        try
          ExecSQL;
        except
          on E: Exception do
          begin
            MessageDlg('Can not copy data. Error message:' + E.Message, mtError, [mbOk], 0);
            Exit(False);
          end;
        end;
        SrcTbl.Next;
      end;
    finally
      free;
    end;
    SrcTbl.Close;
    DstTbl.Close;
    Result := True;
  end;
begin
  ASharedFilePath := ExtractFilePath(conMain.Params.Values['DataBase']) + 'Shared\'+
    CorrectPath(qryUsers.FieldByName('Email').asString) + '\' +
    c_MobileDBName;
  if not ForceDirectories(ExtractFileDir(ASharedFilePath)) then
  begin
    MessageDlg('Can''t create temp directory "' + ExtractFileDir(ASharedFilePath) + '".', mtError, [mbOk], 0);
    Exit(False);
  end;
  if FileExists(ASharedFilePath) then
    if not DeleteFile(ASharedFilePath) then
    begin
      MessageDlg('Can''t rewrite temp database "' + ASharedFilePath + '".', mtError, [mbOk], 0);
      Exit(False);
    end;
  con := TADConnection.Create(nil);
  try
    con.LoginPrompt := False;
    con.DriverName := 'SQLite';
    con.Params.Values['DataBase'] := ASharedFilePath;
    try
      con.Connected := True;
    except ON E: Exception do
      begin
        MessageDlg('Can''t connect to temp database "' + ASharedFilePath + '".', mtError, [mbOk], 0);
        Exit(false);
      end;
    end;
    if not CheckStructure(con) then
      Exit(False);

    (* * * * * * * * * * * *)
    SrcTbl := CreateQuery(conMain);
    try
      DstTbl := CreateQuery(con);
      try
        {Clients}
        if not CopyData('Select C.* from `' + c_tbl_Clients + '` AS C '+
                           '  INNER JOIN `' + c_tbl_ClientUsers + '` CU ON C.ID = CU.ClientID ' +
                           'WHERE CU.UserID = ' + qryUsers.FieldByName('ID').AsString,
                           'Select * from `' + c_tbl_Clients + '`',
                           c_tbl_Clients) then
          Exit(False);
        {Users}
        if Not CopyData('Select * from `' + c_tbl_Users + '` Where ID = ' + qryUsers.FieldByName('ID').AsString,
                        'Select * from `' + c_tbl_Users + '`',
                        c_tbl_Users) then
          Exit(False);

        {ClientUsers}
        if Not CopyData('Select * from `' + c_tbl_ClientUsers + '` Where UserID = ' + qryUsers.FieldByName('ID').AsString,
                        'Select * from `' + c_tbl_ClientUsers + '`',
                        c_tbl_ClientUsers) then
          Exit(False);


        {DocumentTypes}
        if Not CopyData('Select * from `' + c_tbl_DocumentTypes + '`',
                        'Select * from `' + c_tbl_DocumentTypes + '`',
                        c_tbl_DocumentTypes) then
          Exit(False);

        {DocumentFormat}
        if Not CopyData('Select * from `' + c_tbl_DocumentFormat + '`',
                        'Select * from `' + c_tbl_DocumentFormat + '`',
                        c_tbl_DocumentFormat) then
          Exit(False);

        {Settings}
        if Not CopyData('Select * from `' + c_tbl_Settings + '` WHERE `Name` not like ''PREPARER:%''',
                        'Select * from `' + c_tbl_Settings + '`',
                        c_tbl_Settings) then
          Exit(False);

        {Documents}
        if Not CopyData('Select D.* from `' + c_tbl_Documents + '` AS D ' +
                        '  INNER JOIN `' + c_tbl_ClientUsers + '` as CU ON D.ClientID = CU.ClientID ' +
                        'WHERE CU.UserID = ' + qryUsers.FieldByName('ID').AsString,
                        'Select * from `' + c_tbl_Documents + '`',
                        c_tbl_Documents) then
          Exit(False);

      finally
        FreeAndNil(DstTbl);
      end;
    finally
      FreeAndNil(SrcTbl);
    end;
  finally
    con.Free;
  end;
  Result := True;
end;

function TfrmFillDBMain.OpenData: Boolean;
var
  C: TObject;
begin
  Result := False;
  try
    for C in Self do
      if C is TADQuery then
        TADQuery(C).DisableControls;
    qryClients.AfterScroll := Nil;
    try
      for C in Self do
        if C is TADQuery then
        begin
          TADQuery(C).Close;
          TADQuery(C).Open;
        end;
    finally
      for C in Self do
        if C is TADQuery then
          TADQuery(C).EnableControls;
      qryClients.AfterScroll := qryClientsAfterScroll;
      qryClientsAfterScroll(qryClients);
    end;
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
      exit;
    end;
  end;
  Result := True;
end;

procedure TfrmFillDBMain.qryClientsAfterScroll(DataSet: TDataSet);
var
  CurrUser: Integer;
begin
  CurrUser := 0;
  if qryUsers.IsEmpty then
    exit;
  qryUsers.DisableControls;
  try
    CurrUser := qryUsers.FieldByName('Id').AsInteger;
    qryUsers.First;
    while not qryUsers.Eof do
    begin
      if qryClientUsers.Locate('UserId;ClientId', VarArrayOf([qryUsers.FieldByName('ID').AsInteger, qryClients.FieldByName('ID').AsInteger]), []) and (qryUsers.FieldByName('isAllow').AsInteger = 0) then
      begin
        qryUsers.Edit;
        qryUsers.FieldByName('isAllow').AsInteger := 1;
        qryUsers.Post;
      end
      else if not qryClientUsers.Locate('UserId;ClientId', VarArrayOf([qryUsers.FieldByName('ID').AsInteger, qryClients.FieldByName('ID').AsInteger]), []) and (qryUsers.FieldByName('isAllow').AsInteger = 1) then
      begin
        qryUsers.Edit;
        qryUsers.FieldByName('isAllow').AsInteger := 0;
        qryUsers.Post;
      end;
      qryUsers.Next;
    end;
  finally
    qryUsers.Locate('Id', CurrUser, []);
    qryUsers.EnableControls;
    grUsers.Repaint;
  end;
end;

procedure TfrmFillDBMain.qryClientsFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  I: Integer;
begin
  Accept := True;
  if edtFilter.Text = '' then
    exit;
  for I := 0 to DataSet.FieldCount - 1 do
  begin
    if not DataSet.Fields[I].IsBlob and (pos(AnsiUpperCase(edtFilter.Text), AnsiUpperCase(DataSet.Fields[I].AsString)) > 0) then
      exit;
  end;
  Accept := False;
end;

procedure TfrmFillDBMain.qryDocumentFormatAfterScroll(DataSet: TDataSet);
var
  g: TBitmap;
begin
  imgDocumentPicture.Picture := nil;
  if qryDocumentFormat.FieldByName('Picture').IsNull then
    exit;
  g := TBitmap.Create;
  try
    try
      g.Assign(TBlobField(qryDocumentFormat.FieldByName('Picture')));
      imgDocumentPicture.Picture.Assign(g);
    except
    end;
  finally
    g.Free;
  end;
end;

procedure TfrmFillDBMain.qryDocumentsNewRecord(DataSet: TDataSet);
begin
  qryDocuments.FieldByName('ClientId').AsInteger := qryClients.FieldByName('Id').AsInteger;
  qryDocuments.FieldByName('DocumentTypeId').AsInteger := qryDocumentTypes.FieldByName('Id').AsInteger;
  qryDocuments.FieldByName('DocumentName').AsString := '';
  qryDocuments.FieldByName('isDocumentLoaded').AsBoolean := False;
end;

procedure TfrmFillDBMain.qrySettingsAfterOpen(DataSet: TDataSet);
var
  ssl: TidSSLVersion;
  UseTLS : TIdUseTLS;
const
  SSVersionName: array[TidSSLVersion] of String =
    ('SSLv2', 'SSLv23', 'SSLv3', 'TLSv1', 'TLSv1_1', 'TLSv1_2');
  UseTLSName: array[TIdUseTLS] of String =
    ('NoTLSSupport', 'UseImplicitTLS', 'UseRequireTLS', 'UseExplicitTLS');

begin
  cbSSLVersion.Items.Clear;
  for SSL := Low(TidSSLVersion) to High(TidSSLVersion) do
    cbSSLVersion.Items.Add(SSVersionName[SSL]);
  cbUseTLS.Items.Clear;
  for UseTLS := Low(UseTLS) to High(UseTLS) do
    cbUseTLS.Items.Add(UseTLSName[UseTLS]);

  edSMTPServer.Text := '';
  edSMTPPort.Text := '';
  edSMTPLogin.Text := '';
  edSMTPPassword.Text := '';
  cbUseTLS.ItemIndex := Integer(utUseImplicitTLS);
  cbSSLVersion.ItemIndex := Integer(sslvSSLv23);
  chbSendNotificationEmail.Checked := False;
  qrySettings.DisableControls;
  try
    qrySettings.First;
    while not qrySettings.Eof do
    begin
      if SameText(qrySettings.FieldByName('Name').AsString, 'PREPARER:SEND_MAIL') then
        chbSendNotificationEmail.Checked := StrToBoolDef(qrySettings.FieldByName('Value').AsString, False);
      if SameText(qrySettings.FieldByName('Name').AsString, 'PREPARER:SMTP_SERVER') then
        edSMTPServer.Text := qrySettings.FieldByName('Value').AsString;
      if SameText(qrySettings.FieldByName('Name').AsString, 'PREPARER:SMTP_PORT') then
        edSMTPPort.Text := qrySettings.FieldByName('Value').AsString;
      if SameText(qrySettings.FieldByName('Name').AsString, 'PREPARER:SMTP_LOGIN') then
        edSMTPLogin.Text := qrySettings.FieldByName('Value').AsString;
      if SameText(qrySettings.FieldByName('Name').AsString, 'PREPARER:SMTP_PASSWORD') then
        edSMTPPassword.Text := qrySettings.FieldByName('Value').AsString;
      if SameText(qrySettings.FieldByName('Name').AsString, 'PREPARER:SMTP_USETLS') then
        cbUseTLS.ItemIndex := StrToIntDef(qrySettings.FieldByName('Value').AsString, Integer(utUseImplicitTLS));
      if SameText(qrySettings.FieldByName('Name').AsString, 'PREPARER:SMTP_SSLVERSION') then
        cbSSLVersion.ItemIndex := StrToIntDef(qrySettings.FieldByName('Value').AsString, Integer(sslvSSLv23));
      qrySettings.Next;
    end;
  finally
    qrySettings.EnableControls;
  end;
end;

procedure TfrmFillDBMain.qryUsersAfterOpen(DataSet: TDataSet);
var
  Field: TField;
begin
  for Field in DataSet.Fields do
  begin
    Field.ReadOnly := False;
    Field.Required := False;
  end;
end;

function TfrmFillDBMain.TableExists(AConnection: TADConnection; ATableName: string): Boolean;
begin
  with CreateQuery(AConnection) do
  try
    SQL.Text := 'select * from sqlite_master where type = ''table'' and ' + 'Upper(name) like Upper(' + QuotedStr(ATableName) + ')';
    Open;
    Result := not IsEmpty;
  finally
    Close;
    Free;
  end;
end;

procedure TfrmFillDBMain.tbClientResize(Sender: TObject);
begin
  pnlFilter.Width := (Sender as TToolBar).Width - pnlFilter.Left - btnClearFilter.Width - 4;
end;

procedure TfrmFillDBMain.ToolButton1Click(Sender: TObject);
begin
  SendEmail(qryUsers.FieldByName('Login').asString, qryUsers.FieldByName('Email').asString);
end;

procedure TfrmFillDBMain.UpdateUser;
begin
  if qryUsers.Locate('Id', qryUserSingle.FieldByName('Id').AsInteger, []) then
    qryUsers.Edit
  else
  begin
    qryUsers.Append;
    qryUsers.FieldByName('ID').AsInteger := qryUserSingle.FieldByName('ID').AsInteger;
    qryUsers.FieldByName('isAllow').AsInteger := 0;
  end;
  qryUsers.FieldByName('Login').AsString := qryUserSingle.FieldByName('Login').AsString;
  qryUsers.FieldByName('Password').AsString := qryUserSingle.FieldByName('Password').AsString;
  qryUsers.FieldByName('Email').AsString := qryUserSingle.FieldByName('Email').AsString;
  qryUsers.FieldByName('IsAdmin').AsInteger := qryUserSingle.FieldByName('IsAdmin').AsInteger;
  qryUsers.Post;
end;

procedure TfrmFillDBMain.SaveSettings(const AName, AValue: String);
begin
  if qrySettings.Locate('name', AName, [loCaseInsensitive]) then
    qrySettings.Edit
  else
  begin
    qrySettings.Append;
    qrySettings.FieldByName('Name').AsString := AName;
  end;
  qrySettings.FieldByName('Value').AsString := AValue;
  qrySettings.Post;
end;

procedure TfrmFillDBMain.SaveSettings(const AName: String;
  const AValue: Integer);
begin
  if qrySettings.Locate('name', AName, [loCaseInsensitive]) then
    qrySettings.Edit
  else
  begin
    qrySettings.Append;
    qrySettings.FieldByName('Name').AsString := AName;
  end;
  qrySettings.FieldByName('Value').AsString := IntToStr(AValue);
  qrySettings.Post;
end;

procedure TfrmFillDBMain.SaveSettings(const AName: String;
  const AValue: Boolean);
begin
  if qrySettings.Locate('name', AName, [loCaseInsensitive]) then
    qrySettings.Edit
  else
  begin
    qrySettings.Append;
    qrySettings.FieldByName('Name').AsString := AName;
  end;
  qrySettings.FieldByName('Value').AsString := BoolToStr(AValue);
  qrySettings.Post;
end;

procedure TfrmFillDBMain.ScanClientWithEmail;//20170327 Igor
var
  NewID: Integer;
begin
  if qryClients.FindField('email') = nil then
    Exit;

  NewID := 0;
  qryUsers.First;
  qryClients.First;
  while not qryClients.Eof do
  begin
    if qryClients.FieldByName('Email').AsString <> '' then
    begin
      if not qryUsers.Locate('Email', Trim(qryClients.FieldByName('Email').AsString), [loCaseInsensitive]) then
      begin
        qryUserSingle.Append;
        qryUserSingle.FieldByName('IsAdmin').AsInteger := 0;
        qryUserSingle.FieldByName('Login').AsString := GetClientName;
        qryUserSingle.FieldByName('Password').AsString := qryClients.FieldByName('Email').AsString;
        qryUserSingle.FieldByName('Email').AsString := qryClients.FieldByName('Email').AsString;
        qryUserSingle.Post;
        NewID := qryUserSingle.FieldByName('ID').AsInteger;
        UpdateUser;
      end;
      if not qryClientUsers.locate('UserId;ClientId', VarArrayOf([NewID, qryClients.FieldByName('ID').AsInteger]), []) then
      begin
        qryClientUsers.Append;
        qryClientUsers.FieldByName('UserId').AsInteger := qryUsers.FieldByName('ID').AsInteger;
        qryClientUsers.FieldByName('ClientId').AsInteger := qryClients.FieldByName('ID').AsInteger;
        qryClientUsers.Post;
      end;
    end;
    qryClients.Next;
  end;
end;

function TfrmFillDBMain.SelectManager(var AHelperID: Integer): Boolean;
var
  i: Integer;
  formManager: TForm;
  listManager: TListBox;
  btnManager: TButton;
begin
  //get list
  Result := False;
  if HelperManager.HelperClassList.Count = 1 then
  begin
    AHelperID := 0;
    Exit(True);
  end;
  formManager := TForm.CreateNew(nil);
  try
    formManager.Font.Size := 14;
    formManager.Width := 250;
    formManager.Height := 200;
    formManager.Position := poMainFormCenter;
    formManager.Caption := 'Select store';

    listManager := TListBox.Create(formManager);
    listManager.Parent := formManager;
    btnManager := TButton.Create(formManager);
    btnManager.Parent := formManager;
    btnManager.Align := alBottom;
    listManager.Align := alClient;
    btnManager.ModalResult := mrOk;
    btnManager.Caption := 'Ok';

    for I := 0 to HelperManager.HelperClassList.Count - 1 do
      listManager.Items.Add(HelperManager.HelperClassList.Values.ToArray[i]);

    if AHelperID < HelperManager.HelperClassList.Count then
      listManager.ItemIndex := AHelperID;

    btnManager.TabOrder := 0;
    formManager.ShowModal;
    if formManager.ModalResult <> mrOk then
      Exit;
    if listManager.ItemIndex >= 0 then
      AHelperID := listManager.ItemIndex
    else
      AHelperID := 0;
    Result := true;
  finally
    formManager.Free;
  end;
end;

function TfrmFillDBMain.SendEmail(ATaxPayerName, ATaxPayerEmail: String): Boolean;
var
  idText: TIdText;
  ToList: TStringList;
  I: Integer;

  IdSMTP1: TIdSMTP;
  IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
  IdMessage1: TIdMessage;

  procedure InitComponents;
  begin
    IdSMTP1 := TIdSMTP.Create(Self);
    IdSMTP1.ConnectTimeout := 5000;
    IdSMTP1.ReadTimeout := 5000;
    IdSMTP1.ManagedIOHandler := True;
    IdSMTP1.AuthType := satDefault; //satNone, satDefault, satSASL
    IdMessage1 := TIdMessage.Create(Self);
  end;

  procedure Done;
  Begin
    IdSMTP1.IOHandler.Free;
    IdSMTP1.IOHandler := nil;
    IdSMTP1.Free;
    IdMessage1.Free;
  End;

  procedure StringToAddressList(AString: String; AList: TStrings; ADelim: String);
  var
    x: Integer;
    S, lMail, lName: String;
    procedure Add;
    begin
      if pos('@', S) = 0 then
        exit;
      if pos('<', S) = 0 then
      begin
        lMail := lowerCase(S);
        lName := '*';
      end
      else
      begin
        lName := copy(S, 1, pos('<', S)-1);
        Delete(S, 1, pos('<', S));
        lMail := copy(S, 1, pos('>', S) - 1);
      end;
      if AList.IndexOfName(lMail) = -1 then
        AList.Values[lMail] := lName;
    end;
  begin
    x := pos(ADelim, AString);
    while x > 0 do
    begin

      S := Copy(AString, 1, x - 1);
      delete(AString, 1, x);
      x := pos(ADelim, AString);
      Add;
    end;
    if AString <> '' then
    begin
      S := AString;
      Add;
    end;
  end;

  function ConnectToSMTP: Boolean;
  begin
    if IdSMTP1.Connected then
      IdSMTP1.Disconnect;
    TIdSSLContext.Create.Free;

    if cbUseTLS.ItemIndex <> Integer(utNoTLSSupport) then
    begin
      IdSMTP1.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdSMTP1);
      IdSMTP1.UseTLS := TidUseTLS(cbUseTLS.ItemIndex);
      with TIdSSLIOHandlerSocketOpenSSL(IdSMTP1.IOHandler) do
      begin
        SSLOptions.Method := TidSSLVersion(cbSSLVersion.ItemIndex);
        SSLOptions.Mode := sslmUnassigned;
      end;
    end
    else
    begin
      IdSMTP1.IOHandler := TIdIOHandler.MakeDefaultIOHandler(idSmtp1);
      IdSMTP1.UseTLS := TidUseTLS(cbUseTLS.ItemIndex);
    end;

    IdSMTP1.Host := edSMTPServer.Text;
    IdSMTP1.Port := edSMTPPort.Value;
    IdSMTP1.Username := edSMTPLogin.Text;
    IdSMTP1.Password := edSMTPPassword.Text;

    try
      IdSMTP1.Connect;
      if not IdSMTP1.Authenticate then
        raise Exception.Create('Authentification has not completed.');
      Result := True;
    except
      Result := False;
    end;
  end;

  function PreparedHTML: String;
  begin
    Result := ReplaceText(c_LetterHTML, c_TaxPayerTag, ATaxPayerName);
    Result := ReplaceText(Result, c_PreparerTag, FApp.Prp_Name);
  end;

  function PreparedText: String;
  begin
    Result := ReplaceText(c_LetterText, c_TaxPayerTag, ATaxPayerName);
    Result := ReplaceText(Result, c_PreparerTag, FApp.Prp_Name);
  end;

begin
  Result := false;
  if not chbSendNotificationEmail.Checked then
    exit;
  InitComponents;
  try
    if not ConnectToSMTP then
      exit;
    try
      IdMessage1.Clear;
      IdMessage1.Subject := 'vtMobile: Update database.';
      IdMessage1.UID := FormatDateTime('yyyymmddhhnnss', Now);
      IdMessage1.Priority := mpNormal;
      IdMessage1.ContentType := 'multipart/alternative';
      IdMessage1.Body.Text := 'This is a multipart message in MIME format.';
      IdMessage1.CharSet := 'utf-8';
      IdMessage1.From.Address := edSMTPLogin.Text;
      IdMessage1.From.Name := FApp.Prp_Name;
      idText := TIdText.Create(IdMessage1.MessageParts);
      idText.ContentType := 'text/html';
      idText.Body.Text := PreparedHTML;
      idText.CharSet := 'utf-8';

      idText := TIdText.Create(IdMessage1.MessageParts);
      idText.ContentType := 'text/text';
      idText.Body.Text := PreparedText;
      idText.CharSet := 'utf-8';

      ToList := TStringList.Create;
      try
        StringToAddressList(StringReplace(ATaxPayerEmail, ';', ',', [rfReplaceAll]), ToList, ',');
        for I := 0 to ToList.Count - 1 do
        begin
          with idMessage1.Recipients.Add do
          begin
            if ToList.ValueFromIndex[I] <> '*' then
            Begin
              Address := ToList.Names[I];
              Name := ToList.ValueFromIndex[I];
            end
            else
              Text := ToList.Names[I];
          end;
        end;
      finally
        ToList.Free;
      end;

      try
        IdSMTP1.Send(idMessage1);
        Result := True;
      except

      end;
    finally
      if IdSMTP1.Connected then
        IdSMTP1.Disconnect;
    end;
  finally
    Done;
  end;
end;

function TfrmFillDBMain.Start: Boolean;
begin
  try
    if not initStartParams or
       not CheckConnection or
       not CheckStructure(conMain) or //20170327 Igor
       not CheckData or
       not OpenData then
    begin
      exit(False);
    end;
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
      exit(False);
    end;
  end;
  tbClientResize(tbClient);
  pgcMain.ActivePageIndex := 0;
  pgcSettings.ActivePageIndex := 0;
  ScanClientWithEmail;
  Result := True;
  if not FSilent then
    Self.ShowModal;
end;

end.



