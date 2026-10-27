unit fShowGlobalMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmShowGlobalMessage = class(TForm)
    sbMessage: TScrollBox;
    Panel1: TPanel;
    btnOk: TButton;
    lbMessage: TLabel;
    lbClose: TLabel;
    TimerClose: TTimer;
    procedure FormShow(Sender: TObject);
    procedure sbMessageMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sbMessageMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure TimerCloseTimer(Sender: TObject);
  private
    { Private declarations }
    Options: integer;
    FSeconds: integer;
    procedure InitTimer;
    procedure UpdateLabelClose;
  public
    { Public declarations }
  end;

  procedure ShowGlobalMessage(AMessage: string; AOptions: integer);

implementation

{$R *.dfm}

procedure ShowGlobalMessage(AMessage: string; AOptions: integer);
var
  frmShowGlobalMessage: TfrmShowGlobalMessage;
begin
  frmShowGlobalMessage := TfrmShowGlobalMessage.Create(Screen.ActiveForm);
  try
    frmShowGlobalMessage.lbMessage.Caption := AMessage;
    frmShowGlobalMessage.Options := AOptions;
    frmShowGlobalMessage.ShowModal;
  finally
    frmShowGlobalMessage.Free;
  end;
  if AOptions and 1 = 1 then
    Application.MainForm.Close;
end;

procedure TfrmShowGlobalMessage.FormShow(Sender: TObject);
begin
  InitTimer;
end;

procedure TfrmShowGlobalMessage.InitTimer;
begin
  FSeconds := Options shr 5;
  if Options and 2 = 2 then
  begin
    UpdateLabelClose;
    TimerClose.Enabled := true;
  end;
end;

procedure TfrmShowGlobalMessage.sbMessageMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sbMessage.VertScrollBar.Position := sbMessage.VertScrollBar.Position + sbMessage.VertScrollBar.Increment;
end;

procedure TfrmShowGlobalMessage.sbMessageMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  sbMessage.VertScrollBar.Position := sbMessage.VertScrollBar.Position - sbMessage.VertScrollBar.Increment;
end;

procedure TfrmShowGlobalMessage.TimerCloseTimer(Sender: TObject);
begin
  inc(FSeconds, -1);
  UpdateLabelClose;
  if FSeconds = 0 then Close;
end;

procedure TfrmShowGlobalMessage.UpdateLabelClose;
begin
  lbClose.Caption := 'Close after '+ IntToStr(FSeconds) + ' sec';
end;

end.
