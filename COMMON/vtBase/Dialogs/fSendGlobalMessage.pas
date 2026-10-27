unit fSendGlobalMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin, TlHelp32, Registry;

type
  TfrmSendGlobalMessage = class(TForm)
    meMessage: TMemo;
    lbMessage: TLabel;
    cbExitAfterDisplay: TCheckBox;
    cbShowForSeconds: TCheckBox;
    seSeconds: TSpinEdit;
    btnSend: TButton;
    lbRunningProcesses: TLabel;
    lbProcessesCount: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure seSecondsChange(Sender: TObject);
  private
    { Private declarations }
    Options: LongInt;
    MessageFile: string;
    procedure CalcOptions;
    procedure PrepareMessage;
    procedure Send(AHandle: THandle);
    procedure StoreMessage;
  public
    { Public declarations }
  end;

var
  frmSendGlobalMessage: TfrmSendGlobalMessage;

procedure SendGlobalMessage;

implementation

uses vtMulti;

{$R *.dfm}

function RunningProcessesCount(AFileName: string): integer;
var
  Snapshot, P: THandle;
  pe: TProcessEntry32;
begin
  Result := 0;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  try
    pe.dwSize := SizeOf(pe);
    if Process32First(Snapshot, pe) then
      while Process32Next(Snapshot, pe) do
        if SameText(ExtractFileName(pe.szExeFile), AFileName) then
          if (GetCurrentProcessID  <> pe.th32ProcessID) then
            inc(Result);
  finally
    CloseHandle(Snapshot);
  end;
end;

procedure SendGlobalMessage;
begin
  frmSendGlobalMessage := TfrmSendGlobalMessage.Create(Screen.ActiveForm);
  try
    frmSendGlobalMessage.ShowModal;
  finally
    frmSendGlobalMessage.Free;
  end;
end;

function EnumWindowsProc(wHandle: HWND; lParam: LongInt): Bool; stdcall; export;
var
  ClassName: array[0..255] of char;
begin
  Result := True;
  GetClassName(wHandle, ClassName, 255);
  if (wHandle <> Application.MainForm.Handle) and
     SameText(ClassName, Application.MainForm.ClassName) then
    frmSendGlobalMessage.Send(wHandle);
end;

procedure TfrmSendGlobalMessage.btnSendClick(Sender: TObject);
begin
  CalcOptions;
  //PrepareMessage;
  //EnumWindows(@EnumWindowsProc, 0);
  //PostMessage(HWND_BROADCAST, CloudMessageId, 0, Options);
  StoreMessage;
end;

procedure TfrmSendGlobalMessage.CalcOptions;
begin
  Options := 0;
  if cbExitAfterDisplay.Checked then
    Options := Options or 1;
  if cbShowForSeconds.Checked then
  begin
    Options := Options or 2;
    Options := Options or (seSeconds.Value shl 5);
  end;
end;

procedure TfrmSendGlobalMessage.FormShow(Sender: TObject);
begin
  lbProcessesCount.Caption := IntToStr(RunningProcessesCount(ExtractFileName(Application.ExeName)));
end;

procedure TfrmSendGlobalMessage.PrepareMessage;
  function GenerateTempFileName: String;
  var
    TempFile: array[0..MAX_PATH - 1] of Char;
    TempPath: array[0..MAX_PATH - 1] of Char;
  begin
    GetTempPath(MAX_PATH, TempPath);
    if GetTempFileName(TempPath, PChar('abc'), 0, TempFile) <> 0 then
      Result := TempFile
    else
      Result := '';
  end;
begin
  MessageFile := GenerateTempFileName;
  meMessage.Lines.SaveToFile(MessageFile);
end;

procedure TfrmSendGlobalMessage.Send(AHandle: THandle);
var wParam: LongInt;
begin
  //wParam := GlobalAddAtom(PChar(MessageFile));
  //PostMessage(AHandle, CloudMessageId, wParam, Options);
end;

procedure TfrmSendGlobalMessage.seSecondsChange(Sender: TObject);
begin
  if seSeconds.Value < 0 then
    seSeconds.Value := 0;
end;

procedure TfrmSendGlobalMessage.StoreMessage;
var
  Reg: TRegistry;
  FId: integer;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('Software\VisualTax\',True);

    FId := 0;
    if Reg.ValueExists('CurrGlobalMessageId') then
      FId := Reg.ReadInteger('CurrGlobalMessageId');
    Inc(FId);
    Reg.WriteInteger('CurrGlobalMessageId', FId);
    Reg.OpenKey('Messages\', True);
    Reg.WriteString('Message_'+ IntToStr(FId), meMessage.Text);
    Reg.WriteInteger('Options_'+ IntToStr(FId), Options);
    CurrGlobalMessageId := FId;
  finally
    Reg.CloseKey;
  end;
end;

end.
