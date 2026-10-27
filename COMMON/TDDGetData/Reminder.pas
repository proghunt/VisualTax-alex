unit Reminder;
{
//20170303 Igor
StayOnTop window eith countdown timer
}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmReminder = class(TForm)
    Timer1: TTimer;
    lblCaption: TLabel;
    lblTimer: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure lblCaptionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblCaptionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblCaptionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    isMove: Boolean;
    StartX: Integer;
    StartY: Integer;
    FTimeExpire: TDateTime;
    FSessionLengthSec: Integer;
    FStart: Boolean;
  public
    { Public declarations }
  end;

procedure StartRemind(ATimeExpire: TDateTime);
procedure EndRemind;
function CRAPageExists: Boolean;

implementation

{$R *.dfm}

uses
  DateUtils;

var
  frmReminder: TfrmReminder;

function CRAPageExists: Boolean;
Begin
  Result := Assigned(frmReminder);
End;

procedure StartRemind(ATimeExpire: TDateTime);
var
  M: TMonitor;
begin
  if frmReminder = nil then
  begin
    frmReminder := TfrmReminder.Create(Application);
    M := Screen.MonitorFromWindow(Application.MainForm.Handle);
    frmReminder.Left := M.Left;
    frmReminder.Top := M.WorkareaRect.Top + ((M.WorkareaRect.Bottom - M.WorkareaRect.Top) div 2) -
      (frmReminder.Height div 2) - 4;
  end;
  frmReminder.FStart := True;
  frmReminder.FTimeExpire := ATimeExpire;
  frmReminder.FSessionLengthSec := SecondsBetween(ATimeExpire, Now);
  frmReminder.FormStyle := fsStayOnTop;
  frmReminder.Show;
  with frmReminder do
    SetWindowPos(Handle,
      HWND_TOPMOST,
      Left,
      Top,
      Width,
      Height,
      SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  Application.MainForm.Visible := False;

  frmReminder.Timer1.Enabled := True;
end;

procedure EndRemind;
begin
  if frmReminder <> nil then
  begin
    frmReminder.Timer1.Enabled := False;
    frmReminder.Close;
    FreeAndNil(frmReminder);
  end;
  //20170329 >>>
  Application.MainForm.Visible := True;
  Application.BringToFront;
  //20170329 <<<
end;

procedure TfrmReminder.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TfrmReminder.lblCaptionMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isMove := True;
  StartX := X;
  StartY := Y;
end;

procedure TfrmReminder.lblCaptionMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if isMove then
  begin
    Self.Left := Self.Left + (X - StartX);
    Self.Top := Self.Top + (Y - StartY);
  end;
end;

procedure TfrmReminder.lblCaptionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isMove := False;
end;

procedure TfrmReminder.SpeedButton1Click(Sender: TObject);
begin
  Timer1.Enabled := False;
  lblTimer.Caption := '--:--:--';
  FTimeExpire := IncSecond(Now, FSessionLengthSec);
  Timer1.Enabled := True;
end;

procedure TfrmReminder.SpeedButton2Click(Sender: TObject);
begin
  Application.MainForm.Visible := True;
  Application.MainForm.BringToFront;
end;

procedure TfrmReminder.Timer1Timer(Sender: TObject);
var
  DT: TDateTime;
  hWndTemp: HWND;
  iLenText: Integer;
  cTitletemp: array [0 .. 254] of Char;
  sTitleTemp: string;
  partialTitle, partialTitle2, partialTitle3: string;
  CRAWindowExists: Boolean;
begin
  if not assigned(frmReminder) then
    exit;
  frmReminder.BringToFront;

  partialTitle := UpperCase('Canada Revenue Agency - CRA Login');
  partialTitle2 := UpperCase('Auto-fill my return');
  partialTitle3 := UpperCase('https://apps-ct.cra-arc.gc.ca/ebci/awsc/tdd/certtest/auth/pub/wtTokenTransfer');

  CRAWindowExists := False;

  DT := FTimeExpire - Now;
  lblTimer.Caption := FormatDateTime('hh:nn:ss', DT);

  if MinutesBetween(FTimeExpire, Now) <= 1 then
    lblTimer.Font.Color := clRed
  else
    lblTimer.Font.Color := clGreen;

//  with TStringList.Create do
//  begin
//    try
//      hWndTemp := FindWindow(nil, nil);
//      while hWndTemp <> 0 do
//      begin
//        iLenText := GetWindowText(hWndTemp, cTitletemp, 255);
//        sTitleTemp := cTitletemp;
//        sTitleTemp := copy(sTitleTemp, 1, iLenText);
//        Add(sTitleTemp);
//        hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
//      end;
//      SaveToFile('D:\WindowTitles.txt');
//    finally
//      Free;
//    end;
//  end;

  hWndTemp := FindWindow(nil, nil);
  while hWndTemp <> 0 do
  begin
    iLenText := GetWindowText(hWndTemp, cTitletemp, 255);
    sTitleTemp := cTitletemp;
    sTitleTemp := UpperCase(copy(sTitleTemp, 1, iLenText));
    if (pos(partialTitle, sTitleTemp) <> 0) or
       (pos(partialTitle2, sTitleTemp) <> 0) or
       (pos(partialTitle3, sTitleTemp) <> 0) then
    begin
      CRAWindowExists := True;
      FStart := False;
      break;
    end;
    hWndTemp := GetWindow(hWndTemp, GW_HWNDNEXT);
  end;
  (* //20170329 Igor
  if not CRAWindowExists and not FStart then
    EndRemind;
  *)
end;

end.
