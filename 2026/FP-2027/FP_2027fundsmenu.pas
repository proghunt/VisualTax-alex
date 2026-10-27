unit FP_2027fundsmenu;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,VCLTee.TeeProcs,VCLTee.TeEngine,VCLTee.Chart,Menus,FP_2027TrimStr,FP_2027Declare,//20150819  Igor
  FP_2027FundAnalyser;

type
  TFundsMenu = class(TForm)
    DealerButtons: TChart;
    Chart2: TChart;
    Label2: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    Exit1: TMenuItem;
    Splitter1: TSplitter;
    FindBtn: TMenuItem;
    procedure FindaFund1Click(Sender: TObject);
    procedure Analyse1Click(Sender: TObject);
    procedure FindAFundBtnClick(Sender: TObject);
    procedure GenStudyBtnClick(Sender: TObject);
    //procedure PortfBuilderBtnClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    //procedure Analyse2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FundsMenu: TFundsMenu;

implementation

{$R *.DFM}
uses
  vtCommon;

procedure TFundsMenu.FindaFund1Click(Sender: TObject);
begin
 ExecuteForm(TFundAnalyserFP_2012);
end;

procedure TFundsMenu.Analyse1Click(Sender: TObject);
begin
{
 ThisPortfolioName :='';
 ExecuteForm(TwwSelectFund);
}
end;

procedure TFundsMenu.FindAFundBtnClick(Sender: TObject);
begin
FindaFund1Click(Sender);
end;

procedure TFundsMenu.GenStudyBtnClick(Sender: TObject);
begin
Analyse1Click(Sender);
end;

(*
procedure TFundsMenu.PortfBuilderBtnClick(Sender: TObject);
begin
 If NoClient then exit;
 ExecuteForm(TPortfolioMenu);
end;
*)
procedure TFundsMenu.Exit1Click(Sender: TObject);
begin
Close;
end;

procedure TFundsMenu.FindBtnClick(Sender: TObject);
begin
 ExecuteForm(TFundAnalyserFP_2012);
end;

(*
procedure TFundsMenu.Analyse2Click(Sender: TObject);
begin
 ThisPortfolioName :='';
 ExecuteForm(TwwSelectFund);
end;
*)
end.
