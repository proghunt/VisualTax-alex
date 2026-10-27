unit T4T5_2026MonitorFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls;
  //UDeclare,TrimStr;

type
  TMonitorFrameT4T5_2026 = class(TFrame)
    TotIncPanel: TPanel;
    BalancePanel: TPanel;
    TotIncBfrPanel: TPanel;
    NetIncAftPanel: TPanel;
    TxblIncPanel: TPanel;
    //procedure OntPayClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}
//Uses ChildWinNew,UCalc;

(*
procedure TMonitorFrame.OntPayClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 CalcOnt(RetNo);
 Ret[Retno]^.OntCalcStatus := True;
end;
*)
end.
