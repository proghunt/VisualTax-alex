unit FP_2027MonitorFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls;
  //UDeclare,TrimStr;

type
  TMonitorFrameFP_2027 = class(TFrame)
    AssetsPanel: TPanel;

    FedPay: TPanel;
    LiabilitiesPanel: TPanel;
    NetWorthPanel: TPanel;
    DisposableIncomePanel: TPanel;
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
