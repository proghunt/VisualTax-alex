unit FP_2027commissionsmenu;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Menus,FP_2027Declare,FP_2027TrimStr,
  FP_2027CommissionStatementsFrm,FP_2027PayCodes,FP_2027CommissionSummary,
  FP_2027AdjustmentsReview, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart;
  //20150817 igor

type
  TCommissionsMenu = class(TForm)
    DealerButtons: TChart;
    Image3: TImage;
    Image1: TImage;
    Image2: TImage;
    Image4: TImage;
    AdjCodesBtn: TChart;
    AgentAdjusmentsBtn: TChart;
    Chart1: TChart;
    Label6: TLabel;
    Label9: TLabel;
    ReviewBalancesBtn: TChart;
    StatementsBtn: TChart;
    MainMenu1: TMainMenu;
    Statements1: TMenuItem;
    Summary1: TMenuItem;
    Adjustments1: TMenuItem;
    Label2: TLabel;
    AutoAdjustments1: TMenuItem;
    Balances1: TMenuItem;
    Exit1: TMenuItem;
    Splitter1: TSplitter;
    Commissions1: TMenuItem;
    procedure Statements1Click(Sender: TObject);
    procedure Adjustments1Click(Sender: TObject);
    procedure Summary1Click(Sender: TObject);
    procedure StatementsBtnClick(Sender: TObject);
    procedure AdjCodesBtnClick(Sender: TObject);
    procedure AutoAdjustments1Click(Sender: TObject);
    procedure AgentAdjusmentsBtnClick(Sender: TObject);
    procedure Balances1Click(Sender: TObject);
    procedure ReviewBalancesBtnClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommissionsMenu: TCommissionsMenu;

implementation

{$R *.DFM}

uses
  vtCommon;

procedure TCommissionsMenu.Statements1Click(Sender: TObject);
begin
 {
 If (IsAgentVersion = false) and (IsDealerVersion = false) then exit;
 If YouKnowTheAdminPassword = False then exit;
 }
 ExecuteForm(TCommissionStatementsFrm);
end;

procedure TCommissionsMenu.Adjustments1Click(Sender: TObject);
begin
 {
 If (IsAgentVersion = false) and (IsDealerVersion = false) then exit;
 If YouKnowTheAdminPassword = False then exit;
 }
 ExecuteForm(TPayCodes);
end;

procedure TCommissionsMenu.Summary1Click(Sender: TObject);
begin
{
If (IsAgentVersion = false) and (IsDealerVersion = false) then exit;
If YouKnowTheAdminPassword = False then exit;
}
ExecuteForm(TCommissionSummary);
end;

procedure TCommissionsMenu.StatementsBtnClick(Sender: TObject);
begin
Statements1Click(Sender);
end;

procedure TCommissionsMenu.AdjCodesBtnClick(Sender: TObject);
begin
Adjustments1Click(Sender);
end;

procedure TCommissionsMenu.AutoAdjustments1Click(Sender: TObject);
begin
 {
 If (IsAgentVersion = false) and (IsDealerVersion = false) then exit;
 If YouKnowTheAdminPassword = False then exit;
 }
 ExecuteForm(TAdjustmentsReview);

end;

procedure TCommissionsMenu.AgentAdjusmentsBtnClick(Sender: TObject);
begin
AutoAdjustments1Click(Sender);
end;

procedure TCommissionsMenu.Balances1Click(Sender: TObject);
begin
ShowMessage('N/A');
end;

procedure TCommissionsMenu.ReviewBalancesBtnClick(Sender: TObject);
begin
Balances1Click(Sender);
end;

procedure TCommissionsMenu.Exit1Click(Sender: TObject);
begin
Close;
end;

end.
