unit vtShowMessageHTML;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw,
  Vcl.StdCtrls, MSHTML, Xml.XmlDoc, uCEFChromiumWindow, uCEFWinControl, uCEFChromium,
  uCEFTypes, uCEFInterfaces, uCEFStringMultimap, uCEFApplication; // 20180625 Igor

type
  TfShowMessageHTML = class(TForm)
    WebBrowser: TWebBrowser;
    Panel: TPanel;
    ButtonOK: TButton;
    CW: TChromiumWindow;
    procedure FormShow(Sender: TObject);
    procedure PanelResize(Sender: TObject);
    procedure CWAfterCreated(Sender: TObject);
  private
    { Private declarations }
    IsXML: boolean;
    HTML: string;
    FlName: string;
    UseChromium: boolean;
    procedure OpenHTML;
    procedure OpenFile;
  public
    { Public declarations }
  end;

procedure ShowMessageHTML(AHTML: string; AHeight: integer = -1; AIsXML: boolean = false; AUseChromium: boolean = false); // 20180625 Igor
procedure ShowMessageHTMLFromFile(AFileName: string; AHeight: integer = -1; AUseChromium: boolean = false); // 20190306 Igor

implementation

{$R *.dfm}


function HTMLEscape(const Str: string): string; // 20200611 Igor
var
  i: Integer;
begin
  Result := '';
  for i := Low(Str) to High(Str) do
  begin
    case Str[i]  of
    '<' : Result := Result + '&lt;';    { Do not localize }
    '>' : Result := Result + '&gt;';    { Do not localize }
    '&' : Result := Result + '&amp;';   { Do not localize }
    '"' : Result := Result + '&quot;';  { Do not localize }
{$IFNDEF UNICODE}
    #92, Char(160) .. #255 : Result := Result + '&#' + IntToStr(Ord(Str[ i ])) +';';  { Do not localize }
{$ELSE}
    // NOTE: Not very efficient
    #$0080..#$FFFF : Result := Result + '&#' + IntToStr(Ord(Str[ i ])) +';'; { Do not localize }
{$ENDIF}
    else
      Result := Result + Str[i];
    end;
  end;
end;

procedure ShowMessageHTMLFromFile(AFileName: string; AHeight: integer = -1; AUseChromium: boolean = false); // 20190306 Igor
var L: TStringList;
    cText: string;
    fShowMessageHTML: TfShowMessageHTML;
begin
  if not FileExists(AFileName) then
  begin
    ShowMessage('File "'+ AFileName + '" does not exist');
    Exit;
  end;
  if SameText(ExtractFileExt(AFileName), '.xml') then
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(AFileName);
      cText := L.Text;
    finally
      L.Free;
    end;
    ShowMessageHTML(cText, AHeight, true);
    Exit;
  end;
  fShowMessageHTML := TfShowMessageHTML.Create(Application);
  try
    fShowMessageHTML.FlName := AFileName;
    fShowMessageHTML.HTML := '';
    fShowMessageHTML.IsXML := false;
    fShowMessageHTML.UseChromium := AUseChromium;
    if AHeight <> -1 then
      fShowMessageHTML.Height := AHeight;
    fShowMessageHTML.ShowModal;
  finally
    fShowMessageHTML.Free;
  end;
end;

procedure ShowMessageHTML(AHTML: string; AHeight: integer = -1; AIsXML: boolean = false; AUseChromium: boolean = false); // 20180625 Igor
var
  fShowMessageHTML: TfShowMessageHTML;
begin
  fShowMessageHTML := TfShowMessageHTML.Create(Application);
  try
    fShowMessageHTML.FlName := '';
    fShowMessageHTML.HTML := AHTML;
    fShowMessageHTML.IsXML := AIsXML;
    fShowMessageHTML.UseChromium := AUseChromium;
    // 20180625 Igor >>>
    if AHeight <> -1 then
      fShowMessageHTML.Height := AHeight;
    // 20180625 Igor <<<
    fShowMessageHTML.ShowModal;
  finally
    fShowMessageHTML.Free;
  end;
end;

procedure TfShowMessageHTML.CWAfterCreated(Sender: TObject);
begin
  if UseChromium then
  begin
    if not FlName.IsEmpty then
      CW.LoadURL(FlName)
    else
      CW.ChromiumBrowser.LoadString(HTML);
  end;
end;

procedure TfShowMessageHTML.FormShow(Sender: TObject);
begin
  if IsXML then
  begin
    HTML := HTML.Replace('xmlns:xml="http://www.w3.org/XML/1998/namespace"', '');
    HTML := FormatXMLData(HTML);
    HTML :=
      '<html>'+
      '<head></head>'+
      '<body>'+
      '<pre>'+
      HTMLEscape(HTML) +
      '</pre>'+
      '</body>'+
      '</html>';
  end;
  if UseChromium then
  begin
    WebBrowser.Visible := false;
    CW.Align := alClient;
    CW.Visible := true;
    if not Assigned(GlobalCEFApp) then
    begin
      GlobalCEFApp := TCefApplication.Create;
      GlobalCEFApp.FrameworkDirPath     := 'Chromium';
      GlobalCEFApp.ResourcesDirPath     := 'Chromium';
      GlobalCEFApp.LocalesDirPath       := 'Chromium\locales';
      GlobalCEFApp.SingleProcess        := true;

      if not GlobalCEFApp.StartMainProcess then
        raise Exception.Create('Chromium Embedded engine has not been loaded');

    end;
    CW.CreateBrowser;
  end
  else
  begin
    if not FlName.IsEmpty then
      OpenFile
    else
      OpenHTML;
  end;
end;

procedure TfShowMessageHTML.OpenFile;
begin
  if not Assigned(WebBrowser.Document) then
    WebBrowser.Navigate(FlName);
end;

procedure TfShowMessageHTML.OpenHTML;
var
  Doc: Variant;
begin
  if not Assigned(WebBrowser.Document) then
    WebBrowser.Navigate('about:blank');

  Doc := WebBrowser.Document;
  Doc.Clear;
  Doc.Write(HTML);
  Doc.Close;
end;

procedure TfShowMessageHTML.PanelResize(Sender: TObject);
begin
  ButtonOK.Left := (Panel.Width - ButtonOK.Width) div 2;
end;

end.
