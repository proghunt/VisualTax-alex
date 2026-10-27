{$DEFINE VT_UPLOAD}
unit Upload;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.StrUtils,
  //rest
  REST.Client, REST.Authenticator.OAuth, REST.Authenticator.OAuth.WebForm.Win,
  REST.Utils, IPPeerClient, REST.Response.Adapter, REST.Types,System.JSON, REST.Json,
  Data.Bind.Components, Data.Bind.ObjectScope,

  IdURI, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.UITypes;


type
  TfrmMain = class(TForm)
    btnUpload: TButton;
    dlgOpen: TOpenDialog;
    edtFileName: TButtonedEdit;
    ImageList1: TImageList;
    OAuth2_DropBox: TOAuth2Authenticator;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    mdDropBox: TFDMemTable;
    tmrRun: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure edtFileNameRightButtonClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrRunTimer(Sender: TObject);
  private
    procedure OAuth2_DropBox_AccessTokenRedirect(const AURL: string;
      var DoCloseWebView: boolean);
    procedure WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch;
      const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure UploadtoCloud(file_path: String);
    procedure ResetToDefault;
    function GetInputParams: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;


implementation

{$R *.dfm}

uses
  Common;


procedure TfrmMain.btnUploadClick(Sender: TObject);
var
  LURL: string;
  wv: Tfrm_OAuthWebForm;
begin
  DropBox_AccessToken := GetSavedToken;
  if DropBox_AccessToken = '' then
  Begin
    if edtFileName.Text = '' then
    begin
      edtFileNameRightButtonClick(edtFileName);
      if edtFileName.Text = '' then
        Exit;
    end;
    LURL := GenerateAuthorizeURL;
    wv := Tfrm_OAuthWebForm.Create(self);
    try
      wv.OnAfterRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
      wv.OnBeforeRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
      wv.Browser.OnNavigateError := WebBrowser1NavigateError;
      wv.ShowModalWithURL(LURL);
      if (StartsText('Success code', wv.LastTitle)) then
        DropBox_AuthCode := Copy(wv.LastTitle, 14, Length(wv.LastTitle));
    finally
      wv.Release;
    end;
  End;

  if DropBox_AccessToken <> '' then
  Begin
    SaveToken(DropBox_AccessToken);
    ResetToDefault;
    UploadtoCloud(edtFileName.Text);
  End;
end;

procedure TfrmMain.UploadtoCloud(file_path:String);
var
  cloud_path,
  local_filename,
  local_file_path: String;
  upload_stream: TFileStream;
begin
  local_filename := ExtractFileName(file_path);
  cloud_path := local_filename;
  local_file_path := file_path;


  RESTRequest.Method := TRESTRequestMethod.rmPUT;
  RESTClient.BaseURL :=  DropBox_BaseURL_Put;
  RESTClient.Authenticator := nil;

  RESTRequest.Params.Clear;
  RESTRequest.ClearBody;
  RESTRequest.Resource := DropBox_ResourceURI_Put;
  RESTRequest.Params.AddItem('ROOT', 'auto', TRESTRequestParameterKind.pkURLSEGMENT);
  RESTRequest.Params.AddItem('PATH', URIEncode(cloud_path), TRESTRequestParameterKind.pkURLSEGMENT);
  RESTRequest.Params.AddItem('ACCES_TOKEN', 'access_token', TRESTRequestParameterKind.pkURLSEGMENT);
  RESTRequest.Params.AddItem('VALUE', DropBox_AccessToken, TRESTRequestParameterKind.pkURLSEGMENT);


  RESTClient.ContentType := 'text/plain';
  RESTRequest.ClearBody;

  upload_stream := TFileStream.Create(file_path ,fmOpenRead);
  upload_stream.Position := 0;
  RESTRequest.Params.AddHeader('Content-Type', 'multipart/mixed');
  RESTRequest.Params.AddHeader('Content-Length', IntTostr(upload_stream.Size));

  try
    RESTRequest.AddBody(upload_stream, TRESTContentType.ctMULTIPART_MIXED);
    try
      RESTRequest.Execute;
    except ON E: Exception DO
      begin
        MessageDlg(E.Message, mtError, [mbOk], 0);
        exit;
      end;
    end;
  finally
    upload_stream.Free;
  end;

  //Check upload
  if mdDropBox.RecordCount > 0 then
  begin
    if (mdDropBox.FindField('revision') = nil) or
       (mdDropBox.FindField('modified') = nil) then
    begin
      MessageDlg('Unknown error. Server said "'+RESTResponse.JSONText+'"', mtError, [mbOk], 0);
    end
    else
    begin // Upload Ok, exit program
      MessageDlg('Upload comlete.'+#13+
                 '  File revision = "'+mdDropBox.FindField('revision').AsString+'"' + #13 +
                 '  Date modification = "'+mdDropBox.FindField('modified').AsString+'"',
        mtInformation, [mbOk], 0);
      Close;
    end;
  end
  else
  Begin
    MessageDlg('Unknown error. Server said "'+RESTResponse.JSONText+'"', mtError, [mbOk], 0);
  End;
end;

procedure TfrmMain.OAuth2_DropBox_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
begin
  GetToken(AURL, DoCloseWebView);
end;

procedure TfrmMain.ResetToDefault;
begin
  RESTRequest.ResetToDefaults;
  RESTClient.ResetToDefaults;
  RESTResponse.ResetToDefaults;
  RESTResponseDataSetAdapter.ResetToDefaults;
end;

procedure TfrmMain.tmrRunTimer(Sender: TObject);
begin
  tmrRun.Enabled := False;
  if edtFileName.Text = '' then
    edtFileNameRightButtonClick(edtFileName);
  if edtFileName.Text <> '' then
    btnUploadClick(btnUpload);
end;

procedure TfrmMain.WebBrowser1NavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  Cancel:=True;
end;

procedure TfrmMain.edtFileNameRightButtonClick(Sender: TObject);
begin
  if not dlgOpen.Execute then
    Exit;
  edtFileName.Text := dlgOpen.FileName;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  dlgOpen.Filter := DataBaseFileName + '|' + DataBaseFileName;
  if not GetInputParams then
    Close;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Application.ProcessMessages;
  tmrRun.Enabled := True;
end;

function TfrmMain.GetInputParams: Boolean;
begin
  result:=true;
  if (ParamCount < 1) then
  begin
    showmessage('Parameters not sent. Please contact the vendor');
    result := false;
  end
  else
  begin
    DropBox_ClientId := ParamStr(1);
    if ParamCount >= 2 then
    begin
      edtFileName.Text := ParamStr(2);
      if edtFileName.Text <> '' then
        edtFileName.Enabled := False;
    end;
    if ParamCount >= 3 then
      VisualTaxUserId := ParamStr(3)
    else
      VisualTaxUserId := '0';
  end;
end;

end.
