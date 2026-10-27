{*******************************************************}
{                                                       }
{             Delphi REST Client Framework              }
{                                                       }
{ Copyright(c) 2013-2017 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}
unit OAuthWebForm;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  SHDocVw, ShellApi, Windows, IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  IdHTTPServer, IdContext;

type
  TOAuth2WebFormRedirectEvent = procedure(const AURL: string; var DoCloseWebView : boolean) of object;
  TOAuth2WebFormTitleChangedEvent = procedure(const ATitle: string; var DoCloseWebView : boolean) of object;
  TOAuth2Error = procedure(const AURL: string) of object;

  Tfrm_OAuthWebForm = class(TForm)
    Bevel1: TBevel;
    btn_Close: TButton;
    Label1: TLabel;
    pnlBottom: TPanel;
    TimerChromium: TTimer;
    HTTPServer: TIdHTTPServer;
    lbCaption: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FOnBeforeRedirect: TOAuth2WebFormRedirectEvent;
    FOnAfterRedirect: TOAuth2WebFormRedirectEvent;
    FOnBrowserTitleChanged : TOAuth2WebFormTitleChangedEvent;
    FOnError : TOAuth2Error;
    FLastTitle: string;
    FLastURL: string;
    FUrl: string;
  public
    { Public declarations }
    procedure ShowWithURL(const AURL: string);
    procedure ShowModalWithURL(const AURL: string); //deprecated 'Please use ShowWithURL() instead. Sorry for inconvenience.';

    property LastTitle: string read FLastTitle;
    property LastURL: string read FLastURL;

    property OnAfterRedirect: TOAuth2WebFormRedirectEvent read FOnAfterRedirect write FOnAfterRedirect;
    property OnBeforeRedirect: TOAuth2WebFormRedirectEvent read FOnBeforeRedirect write FOnBeforeRedirect;
    property OnTitleChanged : TOAuth2WebFormTitleChangedEvent read FOnBrowserTitleChanged write FOnBrowserTitleChanged;
    property OnError : TOAuth2Error read FOnError write FOnError;
  end;

var
  frm_OAuthWebForm: Tfrm_OAuthWebForm;

implementation

{$R *.dfm}

procedure Tfrm_OAuthWebForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  HTTPServer.Active := false;
end;

procedure Tfrm_OAuthWebForm.FormCreate(Sender: TObject);
begin
  FOnAfterRedirect := NIL;
  FOnBeforeRedirect:= NIL;
  FOnBrowserTitleChanged:= NIL;

  FLastTitle := '';
  FLastURL := '';
end;

procedure Tfrm_OAuthWebForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #27) then
  begin
    Close;
  end;
end;

procedure Tfrm_OAuthWebForm.FormShow(Sender: TObject);
begin
  HTTPServer.Active := true;
  ShellExecute(0, 'OPEN', pchar('' + FUrl), '', '', SW_SHOWNORMAL);
end;

procedure Tfrm_OAuthWebForm.HTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var code: string;
  LDoCloseForm : boolean;
begin
  if ARequestInfo.Document = '/' then
  begin
    code := ARequestInfo.Params.Values['code'];
    if code.IsEmpty then Exit;

    LDoCloseForm:= FALSE;

    FOnBeforeRedirect('Success code='+code, LDoCloseForm);

    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentText :=
      '<html>'+ #13#10 +
      '<head>'+ #13#10 +
      '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">'+ #13#10 +
      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>'+ #13#10 +
      '<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>'+ #13#10 +
      '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>'+ #13#10 +
      '</head>'+ #13#10 +
      '<body style="background-color:#e9ecef">'+ #13#10 +
      #13#10 +
      '<div class="container-fluid" style="background-color:#0d3250">'+ #13#10 +
      '    <div class="container">'+ #13#10 +
      '        <br>'+ #13#10 +
      '        <div class="navbar-header"> <a class="navbar-brand with-top-margin" href="https://www.visualtax.com/"><img src="https://www.visualtax.com/assets/images/logo.png" alt="VisualTax"></a> </div>'+ #13#10 +
      '        <br>'+ #13#10 +
      '    </div>'+ #13#10 +
      '</div>'+ #13#10 +
      #13#10 +
      '<div class="jumbotron text-center">'+ #13#10 +
      '  <h1>You have successfully logged in to Google Drive</h1>'+ #13#10 +
      '  <p>You can close this page now and go back to VisualTax application</p>'+ #13#10 +
      '</div>'+ #13#10 +
      #13#10 +
      '</body>'+ #13#10 +
      '</html>';
    AResponseInfo.ContentType := 'text/html';

    if LDoCloseForm then
    begin
      Self.Visible := True;
      Application.BringToFront;
      Application.ProcessMessages;
      Self.Close;
    end;
  end
  else
  begin
    AResponseInfo.ResponseNo := 404;
    AResponseInfo.ContentText := '<html><body><b>404 NOT FOUND</b></body></html>';
    AResponseInfo.ContentType := 'text/html';
  end;
end;

procedure Tfrm_OAuthWebForm.ShowModalWithURL(const AURL: string);
begin
  /// for backwards-compatibility only
  ShowWithURL( AURL );
end;

procedure Tfrm_OAuthWebForm.ShowWithURL(const AURL: string);
begin
  FUrl := AUrl;
  self.ShowModal;
end;

end.
