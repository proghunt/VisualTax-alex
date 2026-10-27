unit T2_2027MonitorFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls;
  //UDeclare,TrimStr;

type
  TMonitorFrameT2_2027 = class(TFrame)
    NetIncPanel: TPanel;
    NetIncLabel: TLabel;
    TxblIncPanel: TPanel;
    TxblIncPanelLbl: TLabel;
    AlbPay: TPanel;
    AlbPaylbl: TLabel;
    FedPay: TPanel;
    FedPaylbl: TLabel;
    TotalTaxPanel: TPanel;
    Totaltaxlbl: TLabel;
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
