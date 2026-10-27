unit vtMobileAndroid;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  System.Rtti, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.DB, Data.Bind.Components, Data.Bind.Grid, FMX.StdCtrls, FMX.Layouts,
  FMX.Grid, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.DBScope,
  FireDAC.Comp.UI, FMX.Controls.Presentation, FMX.Edit, FMX.Colors,
  FMX.ListView.Types, FMX.ListView, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Data.Bind.ObjectScope, REST.Client,
  REST.Authenticator.OAuth,
  {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
  REST.Authenticator.OAuth.WebForm.Win,
  {$ELSE}
  REST.Authenticator.OAuth.WebForm.FMX,
  {$ENDIF}
  REST.Utils, System.StrUtils,
  IPPeerClient, REST.Response.Adapter, REST.Types, FMX.TabControl,
  FMX.WebBrowser, Datasnap.DBClient, System.JSON, REST.Json,
  Posix.Stdio, Posix.Unistd, System.Threading;
type
  TUser = class
  private
    FUserId: integer;
    FisAdmin: boolean;
  public
    property UserId: integer read FUserId;
    property isAdmin: boolean read FisAdmin;
    constructor Create(AUserId: Integer; AisAdmin: boolean);
  end;


  TMainForm = class(TForm)
    LoginPanel: TPanel;
    LoginScaledLayout: TScaledLayout;
    WrongLabel: TLabel;
    LoginEdit: TEdit;
    PasswordLabel: TLabel;
    PasswordEdit: TEdit;
    LogInButton: TButton;
    vtMobileConnection: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    LoginQuery: TFDQuery;
    HeaderPanel: TPanel;
    BackButton: TButton;
    ClientsListView: TListView;
    ClientsDS: TDataSource;
    DocumentsListView: TListView;
    HeaderLabel: TLabel;
    ClientsBindSource: TBindSourceDB;
    ClientsQuery: TFDQuery;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    DocumentsBindSource: TBindSourceDB;
    DocumentsQuery: TFDQuery;
    LinkFillControlToField2: TLinkFillControlToField;
    Label1: TLabel;
    OAuth2_DropBox: TOAuth2Authenticator;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    StyleBook1: TStyleBook;
    Layout1: TLayout;
    Layout2: TLayout;
    Label2: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    chbCheckDropBox: TCheckBox;
    Layout6: TLayout;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    tcMain: TTabControl;
    tiStart: TTabItem;
    tiWork: TTabItem;
    tiREST: TTabItem;
    tcWork: TTabControl;
    tiClient: TTabItem;
    tiDocument: TTabItem;
    wbREST: TWebBrowser;
    mdDropBox: TFDMemTable;
    qWork: TFDQuery;
    aiCheck: TAniIndicator;
    procedure FormCreate(Sender: TObject);
    procedure LogInButtonClick(Sender: TObject);
    procedure vtMobileConnectionBeforeConnect(Sender: TObject);
    procedure ClientsGridClick(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure ClientsListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure DocumentsListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure OAuth2_DropBox_AccessTokenRedirect(const AURL: string;
      var DoCloseWebView: boolean);
    procedure OAuth2_DropBox_TitleChanged(const ATitle: string; var DoCloseWebView : boolean);
    procedure RESTRequestHTTPProtocolError(Sender: TCustomRESTRequest);
    procedure tcWorkChange(Sender: TObject);
    procedure RESTResponseDataSetAdapterBeforeOpenDataSet(Sender: TObject);
    procedure vtMobileConnectionAfterConnect(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    CurrentUser: TUser;
    Version: String;
    NeedUpdateVersion: Boolean;
    wv: Tfrm_OAuthWebForm;
    NeedAfterAutorize: Boolean;
    function CheckLogin(Login, Password: string): boolean;
    procedure ShowFile;
    procedure CheckDropBox;
    procedure ResetRESTComponentsToDefaults;
    procedure ShowClients(ACheckLogin: Boolean);
    procedure ConnectToDataBase;
    {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
    procedure WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch;
      const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    {$ENDIF}
    procedure AfterAutorize;
    procedure Wait(AWait: Boolean);
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  TaskErrorMsg: string;
implementation
Uses
   ShowDocumentInterface,
   {$IF DEFINED(ANDROID)}
     OpenPDF,
   {$ELSEIF DEFINED(WIN32) OR DEFINED(WIN64)}
     ShowDocumentWindows,
   {$ENDIF}
   MainDM,  System.IOUtils, Common;
{$R *.fmx}

procedure TMainForm.ClientsGridClick(Sender: TObject);
begin
  ClientsListView.Visible := False;
  DocumentsListView.Visible := True;
  DocumentsQuery.Open;
end;

procedure TMainForm.ClientsListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  tcWork.ActiveTab := tiDocument;
  DocumentsQuery.Open;
end;

procedure TMainForm.DocumentsListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ShowFile;
end;

procedure TMainForm.ConnectToDataBase;
begin
  {$IFDEF WIN32}
  vtMobileConnection.Params.Database := ExtractFilePath(ParamStr(0))+'vtMobile.sdb';
  FDPhysSQLiteDriverLink1.VendorLib := ExtractFilePath(ParamStr(0))+'sqlite3.dll';
  vtMobileConnection.Connected := True;
  {$ENDIF}
end;
procedure TMainForm.FormActivate(Sender: TObject);
begin
  if DropBox_AccessToken = '' then
    Wait(False);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  NeedAfterAutorize := False;
  NeedUpdateVersion := False;
  tcMain.ActiveTab := tiStart;
  ConnectToDataBase;
  LoginQuery.Open;
  Application.OnIdle := ApplicationIdle;
end;

procedure TMainForm.ShowClients(ACheckLogin: Boolean);
begin
  if ACheckLogin AND not CheckLogin(LoginEdit.Text, PasswordEdit.Text) then
  begin
    tcMain.ActiveTab := tiStart;
    WrongLabel.Visible := true;
    WrongLabel.Text := 'Wrong login or password';
    Exit;
  end;

  ClientsQuery.Close;
  ClientsQuery.ParamByName('USERID').AsInteger := CurrentUser.UserId;
  ClientsQuery.Open;
  tcMain.ActiveTab := tiWork;
  tcWork.ActiveTab := tiClient;
  tcWorkChange(tcWork);
  Wait(False);
end;

procedure TMainForm.ShowFile;
var SQLQuery: TFDQuery;
    FileName, Extension: String;
begin
  if DocumentsQuery.Active and (DocumentsQuery.RecordCount > 0) AND (DocumentsQuery.FieldByName('ID').AsString <> '') then begin
     SQLQuery := TFDQuery.Create(nil);
     try
       SQLQuery.Connection := VtmobileConnection;
       SQLQuery.SQL.Text := 'select Documents.DocumentName, Documents.DocumentData, DocumentFormat.FileExtension '+
                            'from Documents join DocumentFormat on DocumentFormat.ID = Documents.DocumentFormatID '+
                            'where Documents.ID = ' + DocumentsQuery.FieldByName('ID').AsString;
       SQLQuery.Open;
       Extension := SQLQuery.FieldByName('FileExtension').AsString;
       FileName := TPath.GetTempPath + SQLQuery.FieldByName('DocumentName').AsString + '.' + Extension;
       (SQLQuery.FieldByName('DocumentData') as TBLOBField).SaveToFile(FileName);
       SQLQuery.Close;
     finally
       FreeAndNil(SQLQuery)
     end;
     //(TShowDocument.Create as IShowDocument).ShowDocument(FileName);
    {$IF DEFINED(ANDROID)}
     OpenFile(FileName, Extension);
    {$ELSEIF DEFINED(WIN32) OR DEFINED(WIN64)}
    (TShowDocument.Create as IShowDocument).ShowDocument(FileName);
    {$ENDIF}
   end;
end;

procedure TMainForm.tcWorkChange(Sender: TObject);
begin
  headerLabel.Text := tcWork.ActiveTab.Text;
  BackButton.Visible := (tcWork.ActiveTab = tiDocument);
end;

procedure TMainForm.Wait(AWait: Boolean);
begin
  aiCheck.Visible := AWait;
  aiCheck.Enabled := AWait;
  LogInButton.Enabled := not AWait;
  LoginEdit.Enabled := not AWait;
  PasswordEdit.Enabled := not AWait;
  chbCheckDropBox.Enabled := not AWait;
  Application.ProcessMessages;
//  if Not AWait AND (TaskErrorMsg <> '') then
//    MessageDlg(TaskErrorMsg, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  TaskErrorMsg := '';
end;

procedure TMainForm.LogInButtonClick(Sender: TObject);
begin
  Wait(True);

  if not CheckLogin(LoginEdit.Text, PasswordEdit.Text) then
  begin
    Wait(False);
    WrongLabel.Visible := true;
    WrongLabel.Text := 'Wrong login or password';
    Exit;
  end;
  WrongLabel.Visible := False;
  if chbCheckDropBox.IsChecked then
    CheckDropBox
  else
    ShowClients(False);
 end;

procedure TMainForm.vtMobileConnectionAfterConnect(Sender: TObject);
begin
  vtMobileConnection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS SETTINGS('+
      'Name VarChar(25) NOT NULL,'+
      'Value VarChar(255) NULL,'+
      'PRIMARY KEY (Name)'+
    ')');
  if NeedUpdateVersion then
  begin
    vtMobileConnection.ExecSQL(
      'DELETE FROM SETTINGS WHERE Name = ''version''');
    vtMobileConnection.ExecSQL(
      'INSERT INTO SETTINGS (Name, Value) Values (''version'', '+QuotedStr(Version)+')');
  end
  else
  begin
    qWork.SQL.Text := 'Select * from SETTINGS WHERE Name = ''version''';
    qWork.Open;
    if not qWork.IsEmpty then
      Version := qWork.FieldByName('Value').AsString
    else
      Version := '';
  end;
end;

procedure TMainForm.vtMobileConnectionBeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
  vtMobileConnection.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DataBaseFileName);
  {$ENDIF}
end;

constructor TUser.Create(AUserId: Integer; AisAdmin: boolean);
begin
  FUserId := AUserId;
  FisAdmin := AisAdmin;
end;

procedure TMainForm.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  if NeedAfterAutorize then
  begin
    NeedAfterAutorize := False;
    AfterAutorize;
  end;
end;

procedure TMainForm.BackButtonClick(Sender: TObject);
begin
  tcWork.ActiveTab := tiClient;
  DocumentsQuery.Close;
end;

procedure TMainForm.OAuth2_DropBox_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
begin
  GetToken(AURL, DoCloseWebView);
  if DoCloseWebView then
  Begin
    SaveToken(DropBox_AccessToken);
    NeedAfterAutorize := True;
  End;
end;

procedure TMainForm.OAuth2_DropBox_TitleChanged(const ATitle: string;
  var DoCloseWebView: boolean);
begin
  if (StartsText('Success code', ATitle)) then
    DropBox_AuthCode := Copy(ATitle, 14, Length(ATitle));
end;

procedure TMainForm.ResetRESTComponentsToDefaults;
begin
  RESTRequest.ResetToDefaults;
  RESTClient.ResetToDefaults;
  RESTResponse.ResetToDefaults;
  RESTResponseDataSetAdapter.ResetToDefaults;
end;


procedure TMainForm.RESTRequestHTTPProtocolError(Sender: TCustomRESTRequest);
begin
  // show error
  TThread.Synchronize(nil, procedure()
  begin
    ShowMessage(Sender.Response.StatusText+#13+
                Sender.Response.Content);
  end);
end;

procedure TMainForm.RESTResponseDataSetAdapterBeforeOpenDataSet(
  Sender: TObject);
begin
  if mdDropBox.FieldCount = 0 then
    mdDropBox.CreateDataSet;
end;


function RFC1123ToDateTime(Date: string): TDateTime;
var
  day, month, year: Integer;
  strMonth: string;
  Hour, Minute, Second: Integer;
begin
  try
    day      := StrToInt(Copy(Date, 6, 2));
    strMonth := Copy(Date, 9, 3);
    if strMonth = 'Jan' then month := 1
    else if strMonth = 'Feb' then month := 2
    else if strMonth = 'Mar' then month := 3
    else if strMonth = 'Apr' then month := 4
    else if strMonth = 'May' then month := 5
    else if strMonth = 'Jun' then month := 6
    else if strMonth = 'Jul' then month := 7
    else if strMonth = 'Aug' then month := 8
    else if strMonth = 'Sep' then month := 9
    else if strMonth = 'Oct' then month := 10
    else if strMonth = 'Nov' then month := 11
    else if strMonth = 'Dec' then month := 12
    else month := 1;
    year   := StrToInt(Copy(Date, 13, 4));
    hour   := StrToInt(Copy(Date, 18, 2));
    minute := StrToInt(Copy(Date, 21, 2));
    second := StrToInt(Copy(Date, 24, 2));
    Result := EncodeTime(hour, minute, second, 0);
    Result := Result + EncodeDate(year, month, day);
  except
    Result := now;
  end;
end;

procedure TMainForm.CheckDropBox;
var
  LURL: string;
begin
  DropBox_AccessToken := GetSavedToken;
  if DropBox_AccessToken = '' then
  Begin
    LURL := GenerateAuthorizeURL;
    wv := Tfrm_OAuthWebForm.Create(self);
    wv.OnAfterRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    wv.OnBeforeRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    wv.OnTitleChanged := Self.OAuth2_DropBox_TitleChanged;
    {$IF DEFINED(WIN32) OR DEFINED(WIN64)}
    wv.Browser.OnNavigateError := WebBrowser1NavigateError;
    wv.ShowModalWithURL(LURL);
    {$ELSEIF DEFINED(iOS) or DEFINED(ANDROID)}
    wv.ShowWithURL(LURL);
    {$ENDIF}
  End
  else
    AfterAutorize;
end;

procedure TMainForm.AfterAutorize;
var
  SomeStream : TMemoryStream;
  D: String;

begin
  if DropBox_AccessToken <> '' then
  Begin
    vtMobileConnection.Close;
    try
      TaskErrorMsg := '';
      ResetRESTComponentsToDefaults;

      RESTClient.BaseURL := DropBox_BaseURL;
      RESTClient.Authenticator := OAuth2_Dropbox;

      OAuth2_Dropbox.AccessToken := DropBox_AccessToken;

      RESTRequest.Resource := DropBox_ResourceURI;
      RESTResponseDataSetAdapter.Response := RESTResponse;
      RESTRequest.Params.AddItem('ROOT', 'sandbox', TRESTRequestParameterKind.pkURLSEGMENT);
      RESTRequest.Params.AddItem('PATH', '', TRESTRequestParameterKind.pkURLSEGMENT);
      try
        RESTRequest.Execute;
      except ON E: Exception do
        begin
          TaskErrorMsg := E.Message;
          Exit;
        end;
      end;

      if mdDropBox.RecordCount > 0 then
      begin
        if mdDropBox.Locate('path','/'+DataBaseFileName,[]) then
        Begin
          D := mdDropBox.FieldByName('modified').AsString;
          if (Version = '') or (RFC1123ToDateTime(D) > RFC1123ToDateTime(Version)) then
          begin
            RESTRequest.ResetToDefaults;
            RESTResponseDataSetAdapter.Response := nil;
            RESTClient.BaseURL := 'https://content.dropboxapi.com/1/files/auto/'+DataBaseFileName;
            RenameFile(vtMobileConnection.Params.Values['Database'],
                       vtMobileConnection.Params.Values['Database']+'.bak');
            try
              RESTRequest.Method := TRESTRequestMethod.rmGET;
              try
                RESTRequest.Execute;
              except ON E: Exception do
                begin
                  TaskErrorMsg := E.Message;
                  Exit;
                end;
              end;

              SomeStream := tmemorystream.Create;
              try
                Somestream.WriteData(RESTResponse.RawBytes,Length(RESTResponse.RawBytes));
                SomeStream.SaveToFile(vtMobileConnection.Params.Values['Database']);
                Version := D;
                NeedUpdateVersion := True;
              finally
                SomeStream.free;
              end;
            finally
              if not FileExists(vtMobileConnection.Params.Values['Database']) then
                RenameFile(vtMobileConnection.Params.Values['Database']+'.bak',
                       vtMobileConnection.Params.Values['Database'])
              else
                DeleteFile(vtMobileConnection.Params.Values['Database']+'.bak');
            end;
          end;
        End;
      end;
    finally
      ShowClients(true);
    end;
  End
  else
    ShowClients(true);
  if assigned(wv) then
    wv.Release;
end;

{$IF DEFINED(WIN32) OR DEFINED(WIN64)}
procedure TMainForm.WebBrowser1NavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
 Cancel:=True;
end;
{$ENDIF}

function TMainForm.CheckLogin(Login, Password: string): boolean;
begin
  Result := False;
  vtMobileConnection.Connected := True;
  LoginQuery.Connection := vtMobileConnection;
  LoginQuery.SQL.Text := 'select * from Users where lower(Login) = lower(:Login) and Password = :Password';
  LoginQuery.ParamByName('Login').AsString := Login;
  LoginQuery.ParamByName('Password').AsString := Password;
  LoginQuery.Open;
  if LoginQuery.EOF then
    exit;
  if Assigned(CurrentUser) then
    FreeAndNil(CurrentUser);
  CurrentUser := TUser.Create(LoginQuery.FieldByName('Id').AsInteger, LoginQuery.FieldByName('isAdmin').AsInteger = 1);
  result := true;
end;

end.
