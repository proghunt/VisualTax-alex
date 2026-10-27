unit fDfmProgress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TDfmProgress = class(TForm)
    Label1: TLabel;
    lbAction: TLabel;
    Label3: TLabel;
    lbFile: TLabel;
    Label5: TLabel;
    lbExcept: TLabel;
    buCancel: TBitBtn;
    buIgnore: TBitBtn;
    buOK: TBitBtn;
    lbMsg: TListBox;
    buIgnore1: TBitBtn;
    procedure buCancelClick(Sender: TObject);
    procedure buIgnoreClick(Sender: TObject);
    procedure buOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure buCloseClick(Sender: TObject);
    procedure buIgnore1Click(Sender: TObject);
  private

  public
    LogName: string;
    function ShowMsg(const msg: string): boolean;
  end;

var
  DfmProgress: TDfmProgress;
  DfmWait, //waiting for user confirmation (button click)
  DfmCancel, //Cancel clicked
  DfmIgnore1, //ignore this one (don't kill...)
  DfmIgnore: boolean; //Ignore clicked, don't stop

implementation

{$R *.DFM}

uses
  vtCommon;

procedure TDfmProgress.buCancelClick(Sender: TObject);
begin
  DfmCancel := True;
  DfmWait := False;
end;

procedure TDfmProgress.buIgnoreClick(Sender: TObject);
begin
  DfmIgnore := True;
  DfmWait := False;
end;

procedure TDfmProgress.buIgnore1Click(Sender: TObject);
begin
  DfmIgnore1 := True;
  DfmWait := False;
end;

procedure TDfmProgress.buOKClick(Sender: TObject);
begin
  DfmWait := False;
end;

function TDfmProgress.ShowMsg(const msg: string): boolean;
var
  i, n: integer;
begin
  Screen.Cursor := crHandPoint;
  if lbExcept.Caption = '' then
    lbExcept.Caption := msg; //else preserve exception message
  DfmWait := True;
  DfmCancel := False; //may be set - why?
  i := lbMsg.Items.Add(lbFile.Caption + ': ' + msg);
  lbMsg.ItemIndex := i;
  n := lbMsg.Height div lbMsg.ItemHeight;
  i := lbMsg.Items.Count;
  if i > n then
    lbMsg.TopIndex := i - n;
  Beep;
  //Sleep(1000);
  repeat
    Sleep(200);
    Application.ProcessMessages;
  until DfmIgnore or not DfmWait;
  lbExcept.Caption := '';
  Screen.Cursor := crHourGlass;
  Result := DfmCancel; //True if Cancel button pressed
end;

procedure TDfmProgress.FormCreate(Sender: TObject);
begin
  DfmIgnore := False;
  LogName := '';
end;

procedure TDfmProgress.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (lbMsg.Items.Count > 0) and (LogName <> '') then
  begin
    lbMsg.Items.SaveToFile(LogName);
    UserMsg('List saved in ' + LogName);
  end;
  Action := caFree;
end;

procedure TDfmProgress.buCloseClick(Sender: TObject);
begin
  {
    if lbMsg.Items.Count > 0 then
      lbMsg.Items.SaveToFile(exedir+'\vtErrors.txt');
  }
  Close;
end;

end.

