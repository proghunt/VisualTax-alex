unit fTimedMsg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Gauges,
  //UDeclare,TrimStr;
  ExtCtrls;

type
  TTimedMsg = class(TForm)
    MsgLbl: TLabel;
    CloseBtn: TBitBtn;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
  private

  public

  end;

var
  TimedMsg: TTimedMsg;
  DelayMsg: string;
  TheDelay: integer;

implementation

{$R *.DFM}

procedure TTimedMsg.FormCreate(Sender: TObject);
begin
  MsgLbl.Caption := DelayMsg;
  Timer1.Interval := TheDelay;
end;

procedure TTimedMsg.Timer1Timer(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TTimedMsg.CloseBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

