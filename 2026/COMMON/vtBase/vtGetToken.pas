unit vtGetToken;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw,
  Vcl.StdCtrls, StrUtils, uCEFChromiumWindow, uCEFWinControl, uCEFChromium, uCEFTypes, uCEFInterfaces,
  uCEFStringMultimap, uCEFApplication, System.IOUtils; // 20180625 Igor //20220215 Igor

type
  TfGetToken = class(TForm)
    CW: TChromiumWindow;
    TimerChromium: TTimer;
    procedure FormShow(Sender: TObject);
    procedure CWAfterCreated(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerChromiumTimer(Sender: TObject);
    procedure ChromiumTitleChange(Sender: TObject; const browser: ICefBrowser;
      const title: ustring);
    procedure FormClose(Sender: TObject; var Action: TCloseAction); //20220215 Igor
  private
    FUrl: string;
    FToken: string;
    { Private declarations }
    procedure SaveToLog(AText: string); //20220215 Igor
  public
    { Public declarations }
  end;

function GetToken(AUrl: string): string;

implementation

{$R *.dfm}

uses vtMulti; //20220704 Igor

function GetToken(AUrl: string): string; //20220215 Igor
var
  fGetToken: TfGetToken;
begin
  Result := '';
  fGetToken := TfGetToken.Create(Application);
  try
    fGetToken.FUrl := AUrl;
    if fGetToken.ShowModal = mrOk then
      Result := fGetToken.FToken;
  finally
    fGetToken.Free;
  end;
end;

procedure TfGetToken.ChromiumTitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
var LCloseForm : boolean;
    partialTitle: string;

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
  SaveToLog(title); //20220215 Igor
  partialTitle := 'token={';
  if pos(partialTitle, title) <> 0 then
  begin
    FToken := ExtractBetween(title, '{', '}');
    //20220215 Igor >>>
    CW.ChromiumBrowser.OnTitleChange := nil;
    ModalResult := mrOk;
    //20220215 Igor <<<
  end;
end;

procedure TfGetToken.CWAfterCreated(Sender: TObject);
begin
  CW.LoadURL(FURL);
end;

procedure TfGetToken.FormClose(Sender: TObject; var Action: TCloseAction); //20220215 Igor
begin
  SaveToLog('------ Finish');
  CW.CloseBrowser(True);
end;

procedure TfGetToken.FormCreate(Sender: TObject);
begin
  FToken := '';
  InitChromiumEngine; //20220704 Igor
end;

procedure TfGetToken.FormShow(Sender: TObject);
begin
  SaveToLog('------ Start'); //20220215 Igor
  TimerChromium.Enabled := True;
  CW.ChromiumBrowser.OnTitleChange := ChromiumTitleChange;
end;

procedure TfGetToken.SaveToLog(AText: string); //20220215 Igor
var F: TextFile;
    LogFileName: String;
begin
  LogFileName := TPath.Combine(ExtractFilePath(Application.ExeName), 'vtGetToken.log');
  AssignFile(F, LogFileName);
  if FileExists(LogFileName) then
    Append(F)
  else
    Rewrite(F);
  WriteLn(F, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' : ' + AText);
  CloseFile(F);
end;

procedure TfGetToken.TimerChromiumTimer(Sender: TObject);
begin
  TimerChromium.Enabled := False;
  if not (CW.CreateBrowser) and not (CW.Initialized) then
    TimerChromium.Enabled := True
end;

end.
