unit FP_2027portfoliomenu;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,VCLTee.TeeProcs,VCLTee.TeEngine,VCLTee.Chart,Menus,FP_2027Declare,Buttons;//20150819  Igor

type
  TPortFolioMenuFP_2012 = class(TForm)
    DealerButtons: TChart;
    Image3: TImage;
    Image1: TImage;
    ClientPortfBtn: TChart;
    ModelPortfBtn: TChart;
    Chart2: TChart;
    Label2: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    ModelPortfolio: TMenuItem;
    ClientPortfolio1: TMenuItem;
    Exit1: TMenuItem;
    Splitter1: TSplitter;
    PortfolioBuilder1: TMenuItem;
    CancelBtn: TBitBtn;
    procedure ClientPortfolio1Click(Sender: TObject);
    procedure ModelPortfolioClick(Sender: TObject);

    procedure ClientPortfBtnClick(Sender: TObject);
    procedure ModelPortfBtnClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject); private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PortFolioMenu: TPortFolioMenuFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027PortfolioCreator,FP_2027Trimstr,FP_2027FundsMenu,vtTrimStr,
  vtShared;

procedure TPortFolioMenuFP_2012.ClientPortfolio1Click(Sender: TObject);
begin
 (*
 If NoClient then exit;
 Client := Ret[RetNo]^.ClientId;
 ExecuteForm(TPortfolioCreator);
*)
end;

procedure TPortFolioMenuFP_2012.ModelPortfolioClick(Sender: TObject);
begin
 Client := 'TYPICAL';
 ExecuteForm(TPortfolioCreatorFP_2012);
end;


procedure TPortFolioMenuFP_2012.ClientPortfBtnClick(Sender: TObject);
begin
ClientPortfolio1Click(Sender);
end;

procedure TPortFolioMenuFP_2012.ModelPortfBtnClick(Sender: TObject);
begin
ModelPortfolioClick(Sender);
end;

procedure TPortFolioMenuFP_2012.Exit1Click(Sender: TObject);
begin
(*
If RetNo >0 then Client:= Ret[RetNo].ClientId;
Close;
*)
end;

procedure TPortFolioMenuFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
