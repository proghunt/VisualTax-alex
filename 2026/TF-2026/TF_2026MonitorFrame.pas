unit TF_2026MonitorFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls;
  //UDeclare,TrimStr;

type
  TMonitorFrameTF_2026 = class(TFrame)
    TotIncPanel: TPanel;
    NetIncLabel: TLabel;
    BalancePanel: TPanel;
    BalanceLbl: TLabel;
    TotIncBfrPanel: TPanel;
    TxblIncPanelLbl: TLabel;
    NetIncAftPanel: TPanel;
    AlbPaylbl: TLabel;
    TxblIncPanel: TPanel;
    OntPaylbl: TLabel;
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
