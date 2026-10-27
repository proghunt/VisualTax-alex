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
  //20190910 Igor >>>
  SHDocVw, uCEFChromiumWindow, uCEFWinControl, uCEFChromium, uCEFTypes, uCEFInterfaces,
  uCEFStringMultimap, uCEFApplication;
  //20190910 Igor <<<

type
  TOAuth2WebFormRedirectEvent = procedure(const AURL: string; var DoCloseWebView : boolean) of object;
  TOAuth2WebFormTitleChangedEvent = procedure(const ATitle: string; var DoCloseWebView : boolean) of object;
  TOAuth2Error = procedure(const AURL: string) of object;

  Tfrm_OAuthWebForm = class(TForm)
    Bevel1: TBevel;
    btn_Close: TButton;
    Label1: TLabel;
    pnlBottom: TPanel;
    //20190910 Igor >>>
    ChromiumWindow: TChromiumWindow;
    TimerChromium: TTimer;
    Label2: TLabel;
    edCode: TEdit;
    Label3: TLabel;
    btnSaveCode: TButton;
    //20190910 Igor <<<
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    //20190910 Igor >>>
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ChromiumWindowAfterCreated(Sender: TObject);
    procedure TimerChromiumTimer(Sender: TObject);
    procedure ChromiumLoadStart(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; transitionType: Cardinal);
    procedure ChromiumLoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    procedure ChromiumTitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring);
    procedure ChromiumBeforeBrowse(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const request: ICefRequest; user_gesture,
      isRedirect: Boolean; out Result: Boolean);
    procedure ChromiumLoadError(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: Integer; const errorText,
      failedUrl: ustring);
    procedure ChromiumBeforeResourceLoad(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const callback: ICefRequestCallback;
      out Result: TCefReturnValue);
    //20230314 Igor >>>
    procedure ParsePageSource(const str: ustring);
    procedure btnSaveCodeClick(Sender: TObject);
    //20230314 Igor <<<
  private
    { Private declarations }
    FOnBeforeRedirect: TOAuth2WebFormRedirectEvent;
    FOnAfterRedirect: TOAuth2WebFormRedirectEvent;
    FOnBrowserTitleChanged : TOAuth2WebFormTitleChangedEvent;
    FOnError : TOAuth2Error;
    FLastTitle: string;
    FLastURL: string;
    FUrl: string; //20190910 Igor
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

procedure Tfrm_OAuthWebForm.btnSaveCodeClick(Sender: TObject); //20230314 Igor
var LTitle: string;
    LCloseForm: boolean;
begin
  if String(edCode.Text).IsEmpty then
  begin
    ShowMessage('Code is empty');
    Exit;
  end;
  LTitle := 'code='+ edCode.Text;

  if Assigned(FOnAfterRedirect) then
  begin
    LCloseForm:= FALSE;
    FOnAfterRedirect( LTitle, LCloseForm );

    if LCloseForm then
      self.Close;
  end;
end;

procedure Tfrm_OAuthWebForm.ChromiumBeforeBrowse(Sender: TObject; //20190910 Igor
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; user_gesture, isRedirect: Boolean;
  out Result: Boolean);
var
  LDoCloseForm : boolean;
begin
  if Assigned(FOnBeforeRedirect) then
  begin
    LDoCloseForm:= FALSE;

    FOnBeforeRedirect(frame.Url, LDoCloseForm);

    if LDoCloseForm then
    begin
      //Result := false;
      self.Close;
    end;
  end;
end;

procedure Tfrm_OAuthWebForm.ChromiumBeforeResourceLoad(Sender: TObject; //20190910 Igor
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; const callback: ICefRequestCallback;
  out Result: TCefReturnValue);
var
  map: ICefStringMultimap;
begin
  map := TCefStringMultimapOwn.Create;
  request.GetHeaderMap(map);
  map.Append('Accept-Language', 'en-CA,en-XA,en-GB;q=0.8,en;q=0.6');
  request.SetHeaderMap(map);
end;

procedure Tfrm_OAuthWebForm.ChromiumLoadEnd(Sender: TObject; //20190910 Igor
  const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer);
var
  LDoCloseForm : boolean;
begin
  //20230314 Igor >>>
  Browser.MainFrame.GetSourceProc(ParsePageSource);

  Exit;
  //20230314 Igor <<<
  FLastURL := VarToStrDef(frame.Url, '');

  if Assigned(FOnAfterRedirect) then
  begin
    LDoCloseForm:= FALSE;

    FOnAfterRedirect(FLastURL, LDoCloseForm);

    if LDoCloseForm then
      self.Close;
  end;
end;

procedure Tfrm_OAuthWebForm.ChromiumLoadError(Sender: TObject; //20190910 Igor
  const browser: ICefBrowser; const frame: ICefFrame; errorCode: Integer;
  const errorText, failedUrl: ustring);
begin
  if Assigned(FOnError) then
    FOnError(failedUrl);
end;

procedure Tfrm_OAuthWebForm.ChromiumLoadStart(Sender: TObject; //20190910 Igor
  const browser: ICefBrowser; const frame: ICefFrame; transitionType: Cardinal);
var
  LDoCloseForm : boolean;
begin
  if Assigned(FOnBeforeRedirect) then
  begin
    LDoCloseForm:= FALSE;

    FOnBeforeRedirect(frame.Url, LDoCloseForm);

    if LDoCloseForm then
    begin
      //Cancel := true;
      self.Close;
    end;
  end;
end;

procedure Tfrm_OAuthWebForm.ChromiumTitleChange(Sender: TObject; //20190910 Igor
  const browser: ICefBrowser; const title: ustring);
var LCloseForm : boolean;
begin
  if (title <> FLastTitle) then
  begin
    FLastTitle := title;

    if Assigned(FOnBrowserTitleChanged) then
    begin
      LCloseForm:= FALSE;
      FOnBrowserTitleChanged( FLastTitle, LCloseForm );

      if LCloseForm then
        self.Close;
    end;
  end;
end;

procedure Tfrm_OAuthWebForm.ChromiumWindowAfterCreated(Sender: TObject); //20190910 Igor
begin
  ChromiumWindow.LoadURL(FURL);
end;

procedure Tfrm_OAuthWebForm.FormClose(Sender: TObject; //20190910 Igor
  var Action: TCloseAction);
begin
  ChromiumWindow.CloseBrowser(true);
end;

procedure Tfrm_OAuthWebForm.FormCreate(Sender: TObject); //20190910 Igor
begin
  if not Assigned(GlobalCEFApp) then
  begin
    GlobalCEFApp := TCefApplication.Create;
    GlobalCEFApp.FrameworkDirPath     := 'Chromium';
    GlobalCEFApp.ResourcesDirPath     := 'Chromium';
    GlobalCEFApp.LocalesDirPath       := 'Chromium\locales';
    GlobalCEFApp.SingleProcess        := true;
    //20230314 Igor >>>
    GlobalCEFApp.cache                    := 'Chromium\cache';
    GlobalCEFApp.DeleteCache              := false;
    GlobalCEFApp.DeleteCookies            := false;
    GlobalCEFApp.PersistSessionCookies    := true;
    GlobalCEFApp.IgnoreCertificateErrors  := true;
    //20230314 Igor <<<
    GlobalCEFApp.MustCreateBrowserProcessHandler := false;

    if not GlobalCEFApp.StartMainProcess then
      raise Exception.Create('Chromium Embedded engine has not been loaded');
  end;

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

procedure Tfrm_OAuthWebForm.FormShow(Sender: TObject); //20190910 Igor
begin
  //ChromiumWindow.ChromiumBrowser.OnLoadStart := ChromiumLoadStart; //20230314 Igor
  ChromiumWindow.ChromiumBrowser.OnLoadEnd := ChromiumLoadEnd;
  //ChromiumWindow.ChromiumBrowser.OnTitleChange := ChromiumTitleChange; //20230314 Igor
  //ChromiumWindow.ChromiumBrowser.OnBeforeBrowse := ChromiumBeforeBrowse; //20230314 Igor
  ChromiumWindow.ChromiumBrowser.OnLoadError := ChromiumLoadError;
  ChromiumWindow.ChromiumBrowser.OnBeforeResourceLoad := ChromiumBeforeResourceLoad;
  TimerChromium.Enabled := True;
end;

procedure Tfrm_OAuthWebForm.Label1Click(Sender: TObject); //20190910 Igor
begin
  //ChromiumWindow.ChromiumBrowser.ShowDevTools(Point(0,0), Panel1);
end;

procedure Tfrm_OAuthWebForm.ParsePageSource(const str: ustring); //20230314 Igor
var LString, LCode: string;
begin
  LString := str;
  if Pos('<input id="auth-code-input"', LString) > 0 then
  begin
    LString := Copy(LString, Pos('<input id="auth-code-input"', LString), Length(LString));
    LString := Copy(LString, Pos('value="', LString) + Length('value="'), Length(LString));
    LCode := Copy(LString, 1, Pos('"', LString) - 1);

    edCode.Text := LCode;
    btnSaveCode.Click;
  end;
end;

procedure Tfrm_OAuthWebForm.ShowModalWithURL(const AURL: string);
begin
  /// for backwards-compatibility only
  ShowWithURL( AURL );
end;

procedure Tfrm_OAuthWebForm.ShowWithURL(const AURL: string);
begin
  FUrl := AUrl; //20190910 Igor
  self.ShowModal;
end;

procedure Tfrm_OAuthWebForm.TimerChromiumTimer(Sender: TObject); //20190910 Igor
begin
  TimerChromium.Enabled := False;
  if not (ChromiumWindow.CreateBrowser) and not (ChromiumWindow.Initialized) then
    TimerChromium.Enabled := True
  else
    ChromiumWindow.LoadUrl(FURL);
end;

end.
