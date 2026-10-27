unit UReadEMail;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, Psock, NMpop3;

type
  TReadEMail = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Memo1: TRichEdit;
    NMPOP31: TNMPOP3;
    eServer: TEdit;
    Label1: TLabel;
    Label6: TLabel;
    eFrom: TEdit;
    Button2: TBitBtn;
    DeleteBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);

    procedure NMPOP31Connect(Sender: TObject);
    procedure NMPOP31List(Msg, Size: Integer);
    procedure NMPOP31AuthenticationFailed(var Handled: Boolean);
    procedure NMPOP31AuthenticationNeeded(var Handled: Boolean);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NMPOP31RetrieveStart(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure NMPOP31RetrieveEnd(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure NMPOP31Success(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReadEMail: TReadEMail;

implementation

{$R *.DFM}

procedure TReadEMail.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TReadEMail.OKBtnClick(Sender: TObject);
begin
  if NMPOP31.Connected then
    NMPOP31.Disconnect
  else
  begin
    // connect
    NMPOP31.Host := eServer.Text;
    NMPOP31.UserID := eFrom.Text;
    NMPOP31.Password := 'Evlambia1';
    NMPOP31.Connect;
    ShowMessage('Connected');
  end;
end;

procedure TReadEMail.NMPOP31Connect(Sender: TObject);
begin
  if NMPOP31.MailCount > 0 then
    NMPOP31.List
  else
    Memo1.lines.add('No Messages');
end;

procedure TReadEMail.NMPOP31List(Msg, Size: Integer);
begin
 Memo1.Lines.Add('Message '+IntToStr(Msg)+': '+IntToStr(Size)+' bytes');
end;

procedure TReadEMail.NMPOP31AuthenticationFailed(var Handled: Boolean);
var
  NewPass,
  NewID: String;
begin
  if MessageDlg('Authentication Failed. Retry?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
   {
    NewPass := NMPOP31.Password;
    NewID := NMPOP31.UserID;
    InputQuery('Authentication Failed','Input User ID', NewID);
    InputQuery('Authentication Failed','Input Password', NewPass);
    NMPOP31.Password := NewPass;
    NMPOP31.UserID := NewID;
    Handled := TRUE;
    }
  end
  else
    Handled := FALSE;
end;

procedure TReadEMail.NMPOP31AuthenticationNeeded(var Handled: Boolean);
var
  NewPass,
  NewID: String;
begin
  NewPass := NMPOP31.Password;
  NewID := NMPOP31.UserID;
  {
  InputQuery('Authorization Needed','Input User ID', NewID);
  InputQuery('Authorization Needed','Input Password', NewPass);
  }
  NMPOP31.UserID := NewID;
  NMPOP31.Password := NewPass;
  Handled := TRUE;

end;


procedure TReadEMail.FormCreate(Sender: TObject);
begin
eFrom.Text:='b1pmxh93';
eServer.Text:= 'POP3.sympatico.ca';
end;

procedure TReadEMail.NMPOP31RetrieveStart(Sender: TObject);
begin
 Memo1.Lines.Add('Retrieving Summary');

end;

procedure TReadEMail.Button2Click(Sender: TObject);
var
  S: String;
  M: Integer;
begin
 (*
  if NMPOP31.MailCount > 0 then
  begin
    s:= InputBox('Retrieve a Summary', 'Which message? (1-'+IntToStr(NMPOP31.MailCount)+')';
    If S>'' then
    begin
      M := StrToIntDef(S, -1);
      If (M < 0) or (M > NMPOP31.MailCount) then

        ShowMessage('Invalid message index')
      else
      begin
        NMPOP31.GetSummary(M);
        Edit6.Text := NMPOP31.UniqueID(M);
      end;
    end;
  end
  else
    ShowMessage('No Messages to Summarize');
  *)
end;

procedure TReadEMail.NMPOP31RetrieveEnd(Sender: TObject);
begin
  (*
  Memo1.Lines.Add('Summary retrieved');
  Edit4.Text := NMPOP31.Summary.From;

  Edit5.Text := NMPOP31.Summary.Subject;
  Memo2.Text := NMPOP31.Summary.Header.Text;
  *)
end;

procedure TReadEMail.DeleteBtnClick(Sender: TObject);
var
  S: String;
  M: Integer;
begin
 (*
  if NMPOP31.MailCount > 0 then
  begin
    if InputQuery('Delete a Message', 'Which message? (1-'+IntToStr(NMPOP31.MailCount)+')', S) then
    begin
      M := StrToIntDef(S, -1);
      If (M < 0) or (M > NMPOP31.MailCount) then
        ShowMessage('Invalid message index')
      else
      begin
        NMPOP31.DeleteMailMessage(M);
      end;
    end;
  end
  else
    ShowMessage('No Messages to Delete');
  *)  
end;

procedure TReadEMail.NMPOP31Success(Sender: TObject);
begin
  ShowMessage('Message deleted.');

end;

end.
