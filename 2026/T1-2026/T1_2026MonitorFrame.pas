unit T1_2026MonitorFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls;

type
  TMonitorFrameT1_2026 = class(TFrame)
    TotIncPanel: TPanel;
    NetIncPanel: TPanel;
    TxblIncPanel: TPanel;
    TaxPayablePanel: TPanel;
    BalancePanel: TPanel;
    TotIncLabel: TLabel;
    NetIncLabel: TLabel;
    TxblIncLabel: TLabel;
    TaxPayableLabel: TLabel;
    BalanceLabel: TLabel;
    FamilyPanel: TPanel;
    FamilyLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
