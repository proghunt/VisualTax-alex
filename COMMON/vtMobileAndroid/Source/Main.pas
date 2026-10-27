{
Email: VisualTaxCanada@gmail.com
Password: vtSecret2015
App Key: clmqhseptut86vm
App Secret: l66h2jrszkkail6
}

unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.UITypes, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.ImgList, Vcl.ToolWin, ShellAPI,
  Vcl.Imaging.jpeg, Data.DB,  IPPeerClient,  Data.Bind.Components,
  Data.Bind.ObjectScope, Vcl.Menus, Vcl.XPMan, vtHelperManager, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADGUIxFormsWait, uADStanExprFuncs,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient, uADPhysSQLite, uADCompGUIx;

type
  TFieldRec = record
    FieldName,
    FieldType,
    IsNull,
    Default: String;
  end;
  TfrmFillDBMain = class(TForm)
    conMain: TADConnection;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
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
    pgcDicts: TPageControl;
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
    qryDocumentsID: TADAutoIncField;
    qryDocumentsClientID: TIntegerField;
    qryDocumentsDocumentTypeID: TIntegerField;
    qryDocumentsDocumentFormatID: TIntegerField;
    qryDocumentsDocumentName: TWideMemoField;
    qryDocumentsDocumentData: TBlobField;
    qryDocumentsisDocumentLoaded: TBooleanField;
    qryDocumentsDocumentTypeName: TStringField;
    qryDocumentsDocumentFormatName: TStringField;
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
    procedure FormCreate(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure grUsersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
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
  private
    { Private declarations }
    BasePath: String;
    vtTaxModulePath: string;
    ClientDir: string;
    SourceClientDataBase: String;
    SourceClientTable: String;
    SourceClientDataBasePassword: String;
    ScanStop: Boolean;
    function initStartParams: Boolean;
    function CheckConnection: Boolean;
    function CheckStructure: Boolean; overload;
    function CheckStructure(AConnection: TADConnection; ATableName: String): Boolean; overload;
    function CheckIndexes(ASrcConnection, ADstConnection: TADConnection;
      ASrcTableName, ADstTableName: String): Boolean; overload;
    function CheckData: Boolean;
    function TableExists(AConnection: TADConnection; ATableName: String): Boolean;
    function FieldExists(AConnection:TADConnection; ATableName, AFieldName,
      AFieldType, AIsNull, ADefault: String; ACreateIfNotExists: Boolean): Boolean;
    function IndexExists(AConnection: TADConnection; ATableName, AIndexName, ASQL: String;
      ACreateIfNotExists: Boolean):boolean;
    function GenerateDDL(AConnection:TADConnection; ATableName: String; out ADDL: String): Boolean;
    function GetDDL(ATableName: String; out ADDL: String): Boolean;
    function CreateTable(ASrcConnection, ADstConnection: TADConnection;
      ASrcTableName, ADstTableName: String): Boolean; overload;
    function CreateTable(AConnection: TADConnection; ATableName: String): Boolean; overload;
    function CompareStructure(ASrcConnection, ADstConnection: TADConnection;
      ASrcTableName, ADstTableName: String): Boolean;
    function CreateQuery(AConnection: TADConnection): TADQuery;
    function OpenData: Boolean;
    procedure UpdateUser;
    procedure OAuth2_DropBox_AccessTokenRedirect(const AURL: string;
      var DoCloseWebView: boolean);
    procedure WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch;
      const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure ResetToDefault;
    procedure UploadtoCloud(file_path: String);
    function GetClientDir: string;
    procedure Wait(AStart: Boolean = True);
  public
    { Public declarations }
  end;

var
  frmFillDBMain: TfrmFillDBMain;

implementation

{$R *.dfm}

uses RegularExpressions, uEditUser, uEditDocument, pngimage, Common, System.StrUtils;

const
  c_MobileDBName = 'vtMobile.sdb';
  c_tbl_Clients = 'Clients';
  c_tbl_Users = 'Users';
  c_tbl_UsersDDL = 'CREATE TABLE Users ('+
                     'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '+
                     'IsAdmin INTEGER NOT NULL, '+
                     'Login TEXT UNIQUE NOT NULL, '+
                     'Password TEXT NOT NULL, '+
                     'Email TEXT NOT NULL);';
  c_tbl_UsersFields: Array[0..4] of TFieldRec =
    ((FieldName: 'ID';       FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: ''),
     (FieldName: 'IsAdmin';  FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: '0'),
     (FieldName: 'Login';    FieldType: 'TEXT';    IsNull: 'NOT NULL'; Default: ''''''),
     (FieldName: 'Password'; FieldType: 'TEXT';    IsNull: 'NOT NULL'; Default: ''''''),
     (FieldName: 'Email';    FieldType: 'TEXT';    IsNull: 'NOT NULL'; Default: ''''''));
  c_tbl_ClientUsers = 'ClientUsers';
  c_tbl_ClientUsersDDL = 'CREATE TABLE ClientUsers ('+
                           'UserID INTEGER NOT NULL, '+
                           'ClientID INTEGER NOT NULL, '+
                           'FOREIGN KEY (UserID) REFERENCES Users (ID), '+
                           'FOREIGN KEY (ClientID) REFERENCES Clients (ID));';
  c_tbl_ClientUsersFields: Array[0..1] of TFieldRec =
    ((FieldName: 'UserId';   FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: ''),
     (FieldName: 'ClientId'; FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: '0'));
  c_tbl_DocumentTypes = 'DocumentTypes';
  c_tbl_DocumentTypesDDL = 'CREATE TABLE DocumentTypes ('+
                             'ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '+
                             'DocumentType TEXT NOT NULL);';
  c_tbl_DocumentTypesFields: Array[0..1] of TFieldRec =
    ((FieldName: 'ID';           FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: ''),
     (FieldName: 'DocumentType'; FieldType: 'TEXT';    IsNull: 'NOT NULL'; Default: ''''''));
  c_tbl_DocumentFormat = 'DocumentFormat';
  c_tbl_DocumentFormatDDL = 'CREATE TABLE DocumentFormat ('+
                              'ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '+
                              'DocumentFormat TEXT NOT NULL, '+
                              'Picture BLOB, '+
                              'FileExtension TEXT NOT NULL);';
  c_tbl_DocumentFormatFields: Array[0..3] of TFieldRec =
    ((FieldName: 'ID';             FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: ''),
     (FieldName: 'DocumentFormat'; FieldType: 'TEXT';    IsNull: 'NOT NULL'; Default: ''''''),
     (FieldName: 'Picture';        FieldType: 'BLOB';    IsNull: 'NULL';     Default: ''),
     (FieldName: 'FileExtension';  FieldType: 'TEXT';    IsNull: 'NOT NULL'; Default: ''''''));
  c_tbl_Documents = 'Documents';
  c_tbl_DocumentsDDL = 'CREATE TABLE Documents ('+
                         'ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '+
                         'ClientID INTEGER NOT NULL, '+
                         'DocumentTypeID INTEGER NOT NULL, '+
                         'DocumentFormatID INTEGER NOT NULL, '+
                         'DocumentName TEXT NOT NULL, '+
                         'DocumentData BLOB, '+
                         'isDocumentLoaded BOOLEAN, '+
                         'FOREIGN KEY (ClientID) REFERENCES Clients (ID), '+
                         'FOREIGN KEY (DocumentTypeID) REFERENCES DocumentTypes (ID), '+
                         'FOREIGN KEY (DocumentFormatID) REFERENCES DocumentFormat (ID));';
  c_tbl_DocumentsFields: Array[0..6] of TFieldRec =
    ((FieldName: 'ID';               FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: ''),
     (FieldName: 'ClientID';         FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: '0'),
     (FieldName: 'DocumentTypeID';   FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: '0'),
     (FieldName: 'DocumentFormatID'; FieldType: 'INTEGER'; IsNull: 'NOT NULL'; Default: '0'),
     (FieldName: 'DocumentName';     FieldType: 'TEXT';    IsNull: 'NOT NULL'; Default: ''''''),
     (FieldName: 'DocumentData';     FieldType: 'BLOB';    IsNull: 'NULL'; Default: ''),
     (FieldName: 'isDocumentLoaded'; FieldType: 'BOOLEAN'; IsNull: 'NULL'; Default: ''));
  c_tbl_Settings = 'SETTINGS';
  c_tbl_SettingsDDL = 'CREATE TABLE SETTINGS ('+
                        'Name VarChar (25) NOT NULL, '+
                        'Value VarChar (255), '+
                        'PRIMARY KEY (Name));';
  c_tbl_SettingsFields: Array[0..1] of TFieldRec =
    ((FieldName: 'Name';  FieldType: 'VarChar(25)';  IsNull: 'NOT NULL'; Default: ''),
     (FieldName: 'Value'; FieldType: 'VarChar(255)'; IsNull: 'NULL'; Default: ''));
  c_lib_SQLite = 'sqlite3.dll';
  c_UploadProgrammName = 'vtUploadToDropBox.exe';

  c_ScanCategoriesFile = 'vtScanCategories.d';
  c_MoreCategoriesFile = 'VtScanMoreCategories.txt';

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
  except ON E: Exception DO
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
                    'Select U.Id, '+qryClients.FieldByName('Id').AsString + #13 +
                    'from `Users` U' + #13 +
                    '  Left Outer Join `ClientUsers` CU ON CU.ClientID = '+qryClients.FieldByName('Id').AsString+' AND' + #13 +
                    '    CU.UserID = U.ID' + #13 +
                    'WHERE' + #13 +
                    '  CU.ClientID is null');
    conMain.Commit;
  except ON E: Exception DO
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

procedure TfrmFillDBMain.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  if (Screen.ActiveForm <> frmFillDBMain) or
     pnlWait.Visible then
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

  actDocumentAdd.Enabled := not qryClients.IsEmpty;
  actDocumentEdit.Enabled := not qryDocuments.IsEmpty;
  actDocumentDelete.Enabled := not qryDocuments.IsEmpty;

  actScan.Enabled := not qryClients.IsEmpty;
  actScanAll.Enabled := not qryClients.IsEmpty;
end;

function ExecAndWait(const FileName,
                     Params: String;
                     const WinState: Word): boolean; export;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: String;
begin
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;
  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                          PChar(ExtractFilePath(Filename)), StartInfo, ProcInfo);
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
    pnlWait.SetBounds((Width div 2) - (pnlWait.Width div 2),
      (Height div 2) - (pnlWait.Height div 2),
      pnlWait.Width, pnlWait.Height);
  end;
  pnlWait.Visible := AStart;
  edtFilter.Enabled := not AStart;
  for I := 0 to ActionList1.ActionCount - 1 do
    (ActionList1.Actions[I] as TAction).Enabled := not AStart;
  Application.ProcessMessages;
end;

function  FormatInClock(TickCount: Integer): string;
var
//  Days:   Integer;
  Hours:  Integer;
  Minutes:Integer;
  Seconds:Integer;
  MSecs:  Integer;
//  S_DAY:  string;
  S_HUR:  string;
  S_MIN:  string;
  S_SEC:  string;
  S_MSC:  string;
begin
  S_MSC := '000';
  S_SEC := '00';
  S_MIN := '00';
  S_HUR := '00';
//  S_DAY := '00';
  try
    if (TickCount>0) then
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
            + }S_HUR
            + ':'
            + S_MIN
            + ':'
            + S_SEC
            + ':'
            + S_MSC;
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
      t3 := ((t2 -t1) div qryClients.RecNo) * qryClients.RecordCount - (t2 - t1);
      lblProgress.Caption := FormatCurr('000', qryClients.RecNo) + ' of ' + FormatFloat('000', qryClients.RecordCount)+
        #9'Passed ' + FormatInClock(t2-t1) +
        #9'Left ' + FormatInClock(t3);

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

procedure TfrmFillDBMain.actUploadToCloudExecute(Sender: TObject);
var
  LURL: string;
//  wv: Tfrm_OAuthWebForm;
begin
  //Disconnect
  conMain.Connected := False;
  Wait;
  try

    DropBox_AccessToken := GetSavedToken;
//    if DropBox_AccessToken = '' then
//    Begin
      LURL := GenerateAuthorizeURL;
//      wv := Tfrm_OAuthWebForm.Create(self);
//      try
//        wv.OnAfterRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
//        wv.OnBeforeRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
//        wv.Browser.OnNavigateError := WebBrowser1NavigateError;
//        wv.ShowModalWithURL(LURL);
//        if (StartsText('Success code', wv.LastTitle)) then
//          DropBox_AuthCode := Copy(wv.LastTitle, 14, Length(wv.LastTitle));
//      finally
//        wv.Release;
//      end;
//    End;

    if DropBox_AccessToken <> '' then
    Begin
      SaveToken(DropBox_AccessToken);
//      ResetToDefault;
//      UploadtoCloud(conMain.Params.Values['DataBase']);
      HelperManager.Send(0, conMain.Params.Values['DataBase'],'', ExtractFileName(conMain.Params.Values['DataBase']),  DropBox_ClientID, DropBox_AccessToken);
//    HelperManager.Send(ListBox1.ItemIndex, ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken);

    End;
  finally
    CheckConnection;
    OpenData;
    Wait(False);
  end;
end;

procedure TfrmFillDBMain.UploadtoCloud(file_path:String);
//var
//  cloud_path,
//  local_filename,
//  local_file_path: String;
//  upload_stream: TFileStream;
begin
//  local_filename := ExtractFileName(file_path);
//  cloud_path := local_filename;
//  local_file_path := file_path;
//
//
//  RESTRequest.Method := TRESTRequestMethod.rmPUT;
//  RESTClient.BaseURL :=  DropBox_BaseURL_Put;
//  RESTClient.Authenticator := nil;
//
//  RESTRequest.Params.Clear;
//  RESTRequest.ClearBody;
//  RESTRequest.Resource := DropBox_ResourceURI_Put;
//  RESTRequest.Params.AddItem('ROOT', 'auto', TRESTRequestParameterKind.pkURLSEGMENT);
//  RESTRequest.Params.AddItem('PATH', URIEncode(cloud_path), TRESTRequestParameterKind.pkURLSEGMENT);
//  RESTRequest.Params.AddItem('ACCES_TOKEN', 'access_token', TRESTRequestParameterKind.pkURLSEGMENT);
//  RESTRequest.Params.AddItem('VALUE', DropBox_AccessToken, TRESTRequestParameterKind.pkURLSEGMENT);
//
//
//  RESTClient.ContentType := 'text/plain';
//  RESTRequest.ClearBody;
//
//  upload_stream := TFileStream.Create(file_path ,fmOpenRead);
//  upload_stream.Position := 0;
//  RESTRequest.Params.AddHeader('Content-Type', 'multipart/mixed');
//  RESTRequest.Params.AddHeader('Content-Length', IntTostr(upload_stream.Size));
//
//  try
//    RESTRequest.AddBody(upload_stream, TRESTContentType.ctMULTIPART_MIXED);
//    try
//      RESTRequest.Execute;
//    except ON E: Exception DO
//      begin
//        MessageDlg(E.Message, mtError, [mbOk], 0);
//        exit;
//      end;
//    end;
//  finally
//    upload_stream.Free;
//  end;
//
//  //Check upload
//  if mdDropBox.RecordCount > 0 then
//  begin
//    if (mdDropBox.FindField('revision') = nil) or
//       (mdDropBox.FindField('modified') = nil) then
//    begin
//      MessageDlg('Unknown error. Server said "'+RESTResponse.JSONText+'"', mtError, [mbOk], 0);
//    end
//    else
//    begin // Upload Ok, exit program
//      MessageDlg('Upload comlete.'+#13+
//                 '  File revision = "'+mdDropBox.FindField('revision').AsString+'"' + #13 +
//                 '  Date modification = "'+mdDropBox.FindField('modified').AsString+'"',
//        mtInformation, [mbOk], 0);
//    end;
//  end
//  else
//  Begin
//    MessageDlg('Unknown error. Server said "'+RESTResponse.JSONText+'"', mtError, [mbOk], 0);
//  End;

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
  except ON E: Exception DO
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
                    'Select '+qryUsers.FieldByName('ID').AsString+', Cl.Id' + #13 +
                    'from `Clients` Cl' + #13 +
                    '  Left Outer Join `ClientUsers` CU ON CU.UserID = '+qryUsers.FieldByName('ID').AsString+' AND' + #13 +
                    '    CU.ClientID = Cl.ID' + #13 +
                    'WHERE' + #13 +
                    '  CU.ClientID is null');
    conMain.Commit;
  except ON E: Exception DO
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
  except ON E: Exception DO
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
  conMain.Params.Values['DataBase'] := IncludeTrailingPathDelimiter(BasePath)+c_MobileDBName;
  try
    conMain.Connected := True;
  except ON E: exception DO
    begin
      if FileExists(conMain.Params.Values['DataBase']) then
      begin
        try
          DeleteFile(conMain.Params.Values['DataBase']);
          conMain.Connected := True;
          MessageDlg('Can not connect to mobile database (' + conMain.Params.Values['DataBase'] + '). Error message:'+#13+
                     E.Message+#13+'Database recreated', mtWarning, [mbOk], 0);
        except ON EE: Exception do
          Begin
            MessageDlg('Can not connect to mobile database (' + conMain.Params.Values['DataBase'] + '). Error message:'+#13+
                       E.Message, mtWarning, [mbOk], 0);

            exit;
          End;
        end;
      end;

    end;
  end;

  //Source client DB
  conSourceClient.Params.Values['DataBase'] := IncludeTrailingPathDelimiter(BasePath)+SourceClientDataBase;
  conSourceClient.Params.Values['Password'] := SourceClientDataBasePassword;
  try
    conSourceClient.Connected := True;
  except ON E: exception DO
    begin
      MessageDlg('Can not connect to source client database (' + conSourceClient.Params.Values['DataBase'] + '). Error message:'+#13+
        E.Message, mtError, [mbOk], 0);
      exit;
    end;
  end;

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
      SrcTbl.SQL.Text := 'Select * from `'+SourceClientTable+'`';
      SrcTbl.Open;
      DstTbl.SQL.Text := 'Select * from `'+c_tbl_Clients+'`';
      DstTbl.Open;
      while Not SrcTbl.Eof do
      Begin
        if DstTbl.Locate('File_Name', SrcTbl.FieldByName('File_Name').AsString, [loCaseInsensitive]) then
        Begin
          for I := 0 to DstTbl.FieldCount - 1 do
          Begin
            if SrcTbl.FindField(DstTbl.Fields[I].FieldName) <> nil then
            Begin
              if DstTbl.Fields[I].Value <> SrcTbl.FieldByName(DstTbl.Fields[I].FieldName).Value then
              Begin
                if DstTbl.State <> dsEdit then
                  DstTbl.Edit;
                DstTbl.Fields[I].Value := SrcTbl.FieldByName(DstTbl.Fields[I].FieldName).Value;
              End;
            End;
          End;
          if DstTbl.State = dsEdit then
            try
              DstTbl.Post;
            except ON E: Exception DO
              Begin
                MessageDlg('Can not update data in table "'+c_tbl_Clients+'". Error message:'+E.Message,
                  mtError, [mbOk], 0);
                Exit;
              end;
            end;
        End
        else
        Begin
          DstTbl.Append;
          for I := 0 to DstTbl.FieldCount - 1 do
          Begin
            if SrcTbl.FindField(DstTbl.Fields[I].FieldName) <> nil then
              DstTbl.Fields[I].Value := SrcTbl.FieldByName(DstTbl.Fields[I].FieldName).Value;
          End;
          try
            DstTbl.Post;
          except ON E: Exception DO
            Begin
              MessageDlg('Can not update data in table "'+c_tbl_Clients+'". Error message:'+E.Message,
                mtError, [mbOk], 0);
              Exit;
            end;
          end;
        End;

        SrcTbl.Next;
      End;
    finally
      FreeAndNil(DstTbl);
    end;
  finally
    FreeAndNil(SrcTbl);
  end;
  With CreateQuery(conMain) do
  Begin
    try
      SQL.Text := 'Select * from `'+c_tbl_Users+'`';
      Open;
      if IsEmpty then
      Begin
        Append;
        FieldByname('IsAdmin').AsInteger := 1;
        FieldByname('Login').AsString := 'Admin';
        FieldByname('Password').AsString := 'Admin';
        FieldByname('Email').AsString := 'No email';
        Post;
      End;
      Close;

      SQL.Text := 'Select * from `'+c_tbl_DocumentTypes+'`';
      Open;
      if FileExists(IncludeTrailingPathDelimiter(vtTaxModulePath)+c_ScanCategoriesFile) then
      begin
        sl := TStringList.Create;
        try
           sl.LoadFromFile(IncludeTrailingPathDelimiter(vtTaxModulePath)+c_ScanCategoriesFile);
           for I := 0 to sl.Count - 1 do
           begin
             if (Trim(sl[I]) <> '') AND not locate('DocumentType', sl[I], [loCaseInsensitive]) then
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
      if FileExists(IncludeTrailingPathDelimiter(vtTaxModulePath)+c_MoreCategoriesFile) then
      begin
        sl := TStringList.Create;
        try
           sl.LoadFromFile(IncludeTrailingPathDelimiter(vtTaxModulePath)+c_MoreCategoriesFile);
           for I := 0 to sl.Count - 1 do
           begin
             if (Trim(sl[I]) <> '') AND not locate('DocumentType', sl[I], [loCaseInsensitive]) then
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

      if Not Locate('DocumentType', 'TAX SUMMARY', [loCaseInsensitive]) then
      Begin
        Append;
        FieldByname('DocumentType').AsString := 'TAX SUMMARY';
        Post;
      End;
      Close;

      SQL.Text := 'Select * from `'+c_tbl_DocumentFormat+'`';
      Open;
      if Not Locate('DocumentFormat', 'PDF', [loCaseInsensitive]) then
      Begin
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
      End;
      if Not Locate('DocumentFormat', 'DOC', [loCaseInsensitive]) then
      Begin
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
      End;

    finally
      Close;
      free;
    end;
  End;
  // All Ok
  Result := True;
end;


function TfrmFillDBMain.CheckIndexes(ASrcConnection, ADstConnection: TADConnection;
  ASrcTableName, ADstTableName: String): Boolean;
begin
  result := False;
  if assigned(ASrcConnection) then
  begin
    With CreateQuery(ASrcConnection) do
    Begin
      try
        SQL.Text := 'Select * from sqlite_master where type = ''index'' and Upper(tbl_name) like Upper('+QuotedStr(ASrcTableName)+')';
        Open;
        while not eof do
        Begin
          if not IndexExists(ADstConnection, ADstTableName, FieldByName('name').AsString, FieldByName('sql').AsString, true) then
            Exit;
          next;
        end;
      finally
        Close;
        Free;
      end;
    End;
  end;
  //All Ok
  Result := True;
end;

function TfrmFillDBMain.FieldExists(AConnection:TADConnection; ATableName,
  AFieldName, AFieldType, AIsNull, ADefault: String; ACreateIfNotExists: Boolean): Boolean;
  function GenerateDefault: String;
  Begin
    if ADefault = '' then
      Result := ''
    else
      Result := ' Default ('+ADefault+')';
  End;
begin
  with CreateQuery(AConnection) do
  try
    SQL.Text := 'PRAGMA table_info('+QuotedStr(ATableName)+')';
    Open;
    Result := Locate('Name', AFieldName,[loCaseInsensitive]);
    if not Result and ACreateIfNotExists then
    Begin
      SQL.Text := 'ALTER TABLE `' + ATableName + '` ADD `' + AFieldName + '` ' +
        AFieldType + ' ' + AIsNull + GenerateDefault;
      try
        ExecSQL;
        Result := True;
      except ON E: Exception DO
        Begin
          Result := False;
          MessageDlg(E.Message, mtError, [mbOk], 0);
        end;
      end;
    End;
  finally
    free;
  end;
end;

function TfrmFillDBMain.CheckStructure(AConnection: TADConnection;
  ATableName: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  if SameText(ATableName, c_tbl_Users) then
  Begin
    for I := 0 to Length(c_tbl_UsersFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_UsersFields[I].FieldName,
        c_tbl_UsersFields[I].FieldType, c_tbl_UsersFields[I].IsNull,
        c_tbl_UsersFields[I].Default, True) then exit;
  End
  else
  if SameText(ATableName, c_tbl_ClientUsers) then
  Begin
    for I := 0 to Length(c_tbl_ClientUsersFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_ClientUsersFields[I].FieldName,
        c_tbl_ClientUsersFields[I].FieldType, c_tbl_ClientUsersFields[I].IsNull,
        c_tbl_ClientUsersFields[I].Default, True) then exit;
  End
  else
  if SameText(ATableName, c_tbl_DocumentTypes) then
  Begin
    for I := 0 to Length(c_tbl_DocumentTypesFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_DocumentTypesFields[I].FieldName,
        c_tbl_DocumentTypesFields[I].FieldType, c_tbl_DocumentTypesFields[I].IsNull,
        c_tbl_DocumentTypesFields[I].Default, True) then exit;
  End
  else
  if SameText(ATableName, c_tbl_DocumentFormat) then
  Begin
    for I := 0 to Length(c_tbl_DocumentFormatFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_DocumentFormatFields[I].FieldName,
        c_tbl_DocumentFormatFields[I].FieldType, c_tbl_DocumentFormatFields[I].IsNull,
        c_tbl_DocumentFormatFields[I].Default, True) then exit;
  End
  else
  if SameText(ATableName, c_tbl_Documents) then
  Begin
    for I := 0 to Length(c_tbl_DocumentsFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_DocumentsFields[I].FieldName,
        c_tbl_DocumentsFields[I].FieldType, c_tbl_DocumentsFields[I].IsNull,
        c_tbl_DocumentsFields[I].Default, True) then exit;
  End
  else
  if SameText(ATableName, c_tbl_Settings) then
  Begin
    for I := 0 to Length(c_tbl_SettingsFields) - 1 do
      if not FieldExists(AConnection, ATableName, c_tbl_SettingsFields[I].FieldName,
        c_tbl_SettingsFields[I].FieldType, c_tbl_SettingsFields[I].IsNull,
        c_tbl_SettingsFields[I].Default, True) then exit;
  End
  else
    Exit;
  //All Ok
  Result := True;
end;

function TfrmFillDBMain.CheckStructure: Boolean;
  function Check(ATableName: String): Boolean;
  Begin
    Result := False;
    if not TableExists(conMain, ATableName) then
      if not CreateTable(conMain, ATableName) then
        Exit
      else
    else
      if not CheckStructure(conMain, ATableName) then
        exit;
    Result := true;
  End;
begin
  Result := False;
  if not TableExists(conMain, c_tbl_Clients) then
    if not CreateTable(conSourceClient, conMain, SourceClientTable, c_tbl_Clients) then
      Exit
    else
  else
    if not CompareStructure(conSourceClient, conMain, SourceClientTable, c_tbl_Clients) then
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

function TfrmFillDBMain.CompareStructure(ASrcConnection, ADstConnection: TADConnection;
  ASrcTableName, ADstTableName: String): Boolean;
  function GetisNull(AIsNull: String): String;
  Begin
    if AIsNull = '1' then
      Result := 'NOT NULL'
    else
      Result := 'NULL';
  End;
begin
  Result := False;
  With CreateQuery(ADstConnection) do
  Begin
    try
      SQL.Text := 'PRAGMA table_info('+QuotedStr(ASrcTableName)+')';
      Open;
      while not eof do
      Begin
        if not FieldExists(ADstConnection, ADstTableName,
                           FieldByName('name').AsString,
                           FieldByName('type').AsString,
                           GetisNull(FieldByName('notnull').AsString),
                           FieldByName('dflt_value').AsString,
                           True) then
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
  End;
  Result := True;
end;

function TfrmFillDBMain.CreateQuery(AConnection: TADConnection): TADQuery;
begin
  Result := TADQuery.Create(nil);
  Result.Connection := AConnection;
end;

function TfrmFillDBMain.CreateTable(AConnection: TADConnection;
  ATableName: String): Boolean;
begin
  Result := CreateTable(nil, AConnection, '', ATableName);
end;

function TfrmFillDBMain.CreateTable(ASrcConnection, ADstConnection: TADConnection;
      ASrcTableName, ADstTableName: String): Boolean;
var
  CreateSQL: String;
begin
  Result := False;
  if Assigned(ASrcConnection) AND (ASrcTableName <> '') then
  Begin
    if not GenerateDDL(ASrcConnection, ASrcTableName, CreateSQL) then
      exit;
  End
  else
    if not GetDDL(ADstTableName, CreateSQL) then
      Exit;

  With CreateQuery(ADstConnection) do
  Begin
    try
      SQL.Text := CreateSQL;
      try
        ExecSQL;
      Except ON E: Exception DO
        Begin
          MessageDlg('Can not Create Table "'+ADstTableName+'". Error message:'+#13+E.Message, mtError, [mbOk], 0);
          Exit;
        End;
      end;
    finally
      Close;
      Free;
    end;
  End;
  if not CheckIndexes(ASrcConnection, ADstConnection, ASrcTableName, ADstTableName) then
    exit;

  //All Ok
  Result := True;
end;

procedure TfrmFillDBMain.FormCreate(Sender: TObject);
begin
  try
    if not initStartParams or
       not CheckConnection or
       not CheckStructure or
       not CheckData or
       not OpenData then
    begin
      Halt(0);
      exit;
    end;
  except ON E: Exception DO
    begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
      Halt(0);
      exit;
    end;
  end;
  tbClientResize(tbClient);
  pgcMain.ActivePageIndex := 0;
  pgcDicts.ActivePageIndex := 0;
end;

function TfrmFillDBMain.GenerateDDL(AConnection: TADConnection;
  ATableName: String; out ADDL: String): Boolean;
var
  X: Integer;
begin
  Result := False;
  With CreateQuery(AConnection) do
  Begin
    try
      SQL.Text := 'SELECT sql FROM sqlite_master WHERE type=''table'' AND upper(name) like upper('+QuotedStr(ATableName)+')';
      Open;
      if not isEmpty then
      Begin
        Result := True;
        ADDL := FieldByName('sql').AsString;
        if pos('ID INTEGER PRIMARY KEY AUTOINCREMENT,', upperCase(ADDL)) = 0 then
        Begin
          X := pos('(',ADDL);
          ADDL := Copy(ADDL, 1, X) + 'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' + Copy(ADDL, X+1, MaxInt);
        End;
      End;
    finally
      free;
    end;
  End;
end;

function TfrmFillDBMain.GetClientDir: string;
begin
  Result := '';
  if qryClients.IsEmpty then
  Exit;
  if (qryClients.FindField('First_Name') <> nil) and
     (qryClients.FindField('Last_Name') <> nil) then
    Result := IncludeTrailingPathDelimiter(ClientDir) +
              qryClients.FieldByName('Last_Name').AsString + ',' +
              qryClients.FieldByName('First_Name').AsString
  else
    Result := ExcludeTrailingPathDelimiter(ClientDir);
end;

function TfrmFillDBMain.GetDDL(ATableName: String; out ADDL: String): Boolean;
begin
  if SameText(ATableName, c_tbl_Users) then
    ADDL := c_tbl_UsersDDL
  else
  if SameText(ATableName, c_tbl_ClientUsers) then
    ADDL := c_tbl_ClientUsersDDL
  else
  if SameText(ATableName, c_tbl_DocumentTypes) then
    ADDL := c_tbl_DocumentTypesDDL
  else
  if SameText(ATableName, c_tbl_DocumentFormat) then
    ADDL := c_tbl_DocumentFormatDDL
  else
  if SameText(ATableName, c_tbl_Documents) then
    ADDL := c_tbl_DocumentsDDL
  else
  if SameText(ATableName, c_tbl_Settings) then
    ADDL := c_tbl_SettingsDDL
  else
    ADDL := '';

  Result := ADDL <> '';
end;

procedure TfrmFillDBMain.grClientsTitleClick(Column: TColumn);
var
  fld: String;
begin
  if Column.Field.IsBlob then exit;
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
  if qryUsers.IsEmpty then exit;
  if qryClients.IsEmpty then exit;
  if qryClientUsers.locate('UserId;ClientId',
                           VarArrayOf([qryUsers.FieldByName('ID').AsInteger,
                                       qryClients.FieldByName('ID').AsInteger]),[]) then
  Begin
    qryClientUsers.Delete;
  End
  else
  Begin
    qryClientUsers.Append;
    qryClientUsers.FieldByName('UserId').AsInteger := qryUsers.FieldByName('ID').AsInteger;
    qryClientUsers.FieldByName('ClientId').AsInteger := qryClients.FieldByName('ID').AsInteger;
    qryClientUsers.Post;
  End;
  qryClientsAfterScroll(qryClients);
end;

procedure TfrmFillDBMain.grUsersDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  S, S2: Widestring;
  X, L: Integer;
begin
  if (Sender = grUsers) AND
     not qryUsers.IsEmpty then
  begin
    if (qryUsers.FieldByName('isAllow').AsInteger = 1) then
      TDBGrid(Sender).Canvas.Font.Style := [fsBold];

    if SameText(Column.Field.FieldName, 'IsAdmin') then
    Begin
      TDBGrid(Sender).Canvas.FillRect(Rect);
      if (qryUsers.FieldByName('isAdmin').AsInteger = 1) then
        il16X16.Draw(TDBGrid(Sender).Canvas, Rect.Left + (Rect.Width div 2) - (il16X16.Width div 2), Rect.Top + 1, 10);
    end;
  end;
  if (Column.Field is TBlobField) or
     (Column.Field is TMemoField)  then
  begin
    S := Column.Field.AsString;
    TDBGrid(Sender).Canvas.FillRect(Rect);
    TDBGrid(Sender).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
  if (Sender = grClients) and
     (edtFilter.Text <> '') then
  Begin
    S := Column.Field.AsString;
    X := pos(AnsiUpperCase(edtFilter.Text), AnsiUpperCase(S));
    if X > 0 then
    Begin
      S2 := Copy(S, 1, X-1);
      L := TDBGrid(Sender).Canvas.TextWidth(S2);
      S2 := Copy(S, X, length(edtFilter.Text));
      TDBGrid(Sender).Canvas.Font.Color := clRed;
      TDBGrid(Sender).Canvas.Brush.Style := bsClear;
      TDBGrid(Sender).Canvas.TextOut(Rect.Left + L + 3, Rect.Top + 2, S2);
    End;
  End;
end;

function TfrmFillDBMain.IndexExists(AConnection: TADConnection; ATableName,
  AIndexName, ASQL: String; ACreateIfNotExists: Boolean): boolean;
  function RebuildSQL(ASrcSQL: String): String;
  Begin
    Result := TRegEx.Replace(ASrcSQL,'ON .{,}\(','ON ' + ATableName + '(');
  End;
begin
  With CreateQuery(AConnection) do
  Begin
    try
      SQL.Text := 'Select * from sqlite_master where type = ''index'' and ' +
        'Upper(name) like Upper(' + QuotedStr(AIndexName) + ') AND ' +
        'Upper(tbl_name) like Upper(' + QuotedStr(ATableName) + ')';
      Open;
      Result := Not isEmpty;
      if not Result AND ACreateIfNotExists AND (ASQL <> '') then
      Begin
        SQL.Text := RebuildSQL(ASQL);
        try
          ExecSQL;
        except ON E: Exception do
          begin
            MessageDlg('Can not create index "'+AIndexName+'". Exception message:'+#13+E.Message, mtError, [mbOk], 0);
            exit;
          end;
        end;
      End;
    finally
      Free;
    end;
  End;
  //all ok
  Result := True;
end;

function TfrmFillDBMain.initStartParams: Boolean;
begin
// BasePath                                    Source Cl DB    Cl Tbl    Password        DropBox_ClientID  VisualTaxUserId vtTaxModulePath              ClientDir
// "c:\XE4\xe4-Vt-2015\DistrFl\T1-2015\Data\"  "CLIENTS_T1.db" "Clients" "T1IGORDODINOC" "g5fgaczz3lbww9n" "ADMIN" "c:\XE4\xe4-Vt-2015\DistrFl\T1-2015" "c:\XE4\xe4-Vt-2015\DistrFl\T1-2015\ClientDocs"
  Result := False;
  if ParamCount < 8 then
  begin
    MessageDlg('Not enough options to run', mtError, [mbOk], 0);
    exit;
  end;
  BasePath := ParamStr(1);
  if not DirectoryExists(BasePath) then
  Begin
    MessageDlg('Directory "' + BasePath + '" does not exists', mtError, [mbOk], 0);
    exit;
  End;
  SourceClientDataBase := ParamStr(2);
  if not FileExists(IncludeTrailingPathDelimiter(BasePath) + SourceClientDataBase) then
  Begin
    MessageDlg('Client database not found', mtError, [mbOk], 0);
    exit;
  End;
  SourceClientTable := ParamStr(3);
  SourceClientDataBasePassword := ParamStr(4);
  DropBox_ClientID := ParamStr(5);
  VisualTaxUserId := ParamStr(6);
  vtTaxModulePath := ParamStr(7);
  if not DirectoryExists(vtTaxModulePath) then
  Begin
    MessageDlg('Directory "' + vtTaxModulePath + '" does not exists', mtError, [mbOk], 0);
    exit;
  End;
  ClientDir := ParamStr(8);
  if (Trim(ClientDir) <> '') and not DirectoryExists(ClientDir) then
  Begin
    MessageDlg('Directory "' + ClientDir + '" does not exists', mtError, [mbOk], 0);
    exit;
  End;

  LoadPluginSettings(DropBox_ClientID, VisualTaxUserId, frmFillDBMain, pgcMain);

  // all ok
  Result := true;
end;

procedure TfrmFillDBMain.OAuth2_DropBox_AccessTokenRedirect(const AURL: string;
  var DoCloseWebView: boolean);
begin
  GetToken(AURL, DoCloseWebView);
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
  except ON E: Exception DO
    Begin
      MessageDlg(E.Message, mtError, [mbOk],0);
      exit;
    End;
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
    Begin
      if qryClientUsers.Locate('UserId;ClientId',
                               VarArrayOf([qryUsers.FieldByName('ID').AsInteger,
                                           qryClients.FieldByName('ID').AsInteger]),[]) and
         (qryUsers.FieldByName('isAllow').AsInteger = 0) then
      begin
        qryUsers.Edit;
        qryUsers.FieldByName('isAllow').AsInteger := 1;
        qryUsers.Post;
      end
      else
      if not qryClientUsers.Locate('UserId;ClientId',
                                   VarArrayOf([qryUsers.FieldByName('ID').AsInteger,
                                               qryClients.FieldByName('ID').AsInteger]),[]) and
         (qryUsers.FieldByName('isAllow').AsInteger = 1) then
      begin
        qryUsers.Edit;
        qryUsers.FieldByName('isAllow').AsInteger := 0;
        qryUsers.Post;
      end;
      qryUsers.Next;
    End;
  finally
    qryUsers.Locate('Id',CurrUser,[]);
    qryUsers.EnableControls;
    grUsers.Repaint;
  end;
end;

procedure TfrmFillDBMain.qryClientsFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  I: Integer;
begin
  Accept := True;
  if edtFilter.Text = '' then
    exit;
  for I := 0 to DataSet.FieldCount - 1 do
  Begin
    if not DataSet.Fields[I].IsBlob and
       (pos(AnsiUpperCase(edtFilter.Text), AnsiUpperCase(DataSet.Fields[I].AsString)) > 0) then
      exit;
  End;
  Accept := False;
end;

procedure TfrmFillDBMain.qryDocumentFormatAfterScroll(DataSet: TDataSet);
var
  g:TBitmap;
begin
  imgDocumentPicture.Picture := nil;
  if qryDocumentFormat.FieldByName('Picture').IsNull then
    exit;
  g:=TBitmap.Create;
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

function TfrmFillDBMain.TableExists(AConnection: TADConnection; ATableName: String): Boolean;
begin
  with CreateQuery(AConnection) do
  try
    SQL.Text := 'select * from sqlite_master where type = ''table'' and '+
      'Upper(name) like Upper('+QuotedStr(ATableName)+')';
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

procedure TfrmFillDBMain.UpdateUser;
begin
  if qryUsers.Locate('Id', qryUserSingle.FieldByName('Id').AsInteger,[]) then
    qryUsers.Edit
  else
  Begin
    qryUsers.Append;
    qryUsers.FieldByName('ID').AsInteger := qryUserSingle.FieldByName('ID').AsInteger;
    qryUsers.FieldByName('isAllow').AsInteger := 0;
  End;
  qryUsers.FieldByName('Login').AsString := qryUserSingle.FieldByName('Login').AsString;
  qryUsers.FieldByName('Password').AsString := qryUserSingle.FieldByName('Password').AsString;
  qryUsers.FieldByName('Email').AsString := qryUserSingle.FieldByName('Email').AsString;
  qryUsers.FieldByName('IsAdmin').AsInteger := qryUserSingle.FieldByName('IsAdmin').AsInteger;
  qryUsers.Post;
end;

procedure TfrmFillDBMain.WebBrowser1NavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  Cancel:=True;
end;

procedure TfrmFillDBMain.ResetToDefault;
begin
//  RESTRequest.ResetToDefaults;
//  RESTClient.ResetToDefaults;
//  RESTResponse.ResetToDefaults;
//  RESTResponseDataSetAdapter.ResetToDefaults;
end;

end.
