unit uTimedMsg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,Gauges,
  UDeclare,TrimStr;

type
  TTimedMsg = class(TForm)
    MsgLbl: TLabel;
    CloseBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TimedMsg: TTimedMsg;

implementation

{$R *.DFM}


procedure TTimedMsg.FormCreate(Sender: TObject);
begin
  MsgLbl.Caption:=DelayMsg;
end;

procedure TTimedMsg.CloseBtnClick(Sender: TObject);
begin
 Close;
end;

end.
