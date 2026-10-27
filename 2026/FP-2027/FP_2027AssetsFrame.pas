unit FP_2027AssetsFrame;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,vtLabel,vtShape,FP_2027Declare;
type
  TAssetsFrameFP_2012 = class(TFrame)
    Cash: TBitBtn;
    CSB: TBitBtn;
    GIC: TBitBtn;
    Bonds: TBitBtn;
    Loans: TBitBtn;
    TermDep: TBitBtn;
    MutFunds: TBitBtn;
    Stocks: TBitBtn;
    DefPlans: TBitBtn;
    RealEst: TBitBtn;
    Business: TBitBtn;
    OthAssets: TBitBtn;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtShape6: TvtShape;
    vtLabel3: TvtLabel;
    procedure CashClick(Sender: TObject);
    procedure BondsClick(Sender: TObject);
    procedure CSBClick(Sender: TObject);
    procedure TermDepClick(Sender: TObject);
    procedure DefPlansClick(Sender: TObject);
    procedure GICClick(Sender: TObject);
    procedure RealEstClick(Sender: TObject);
    procedure LoansClick(Sender: TObject);
    procedure MutFundsClick(Sender: TObject);
    procedure StocksClick(Sender: TObject);
    procedure BusinessClick(Sender: TObject);
    procedure OthAssetsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses vtCommon,FP_2027ChildWinNew,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TAssetsFrameFP_2012.CashClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('Cash#1'),0);
end;

procedure TAssetsFrameFP_2012.BondsClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('BONDS#1'),0);
end;

procedure TAssetsFrameFP_2012.CSBClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('CSB#1'),0);
end;

procedure TAssetsFrameFP_2012.TermDepClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('TERMDEP#1'),0);
end;

procedure TAssetsFrameFP_2012.DefPlansClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('DEFPLANS#1'),0);
end;

procedure TAssetsFrameFP_2012.GICClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('GIC#1'),0);
end;

procedure TAssetsFrameFP_2012.RealEstClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('REALEST#1'),0);
end;

procedure TAssetsFrameFP_2012.LoansClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('LOANS#1'),0);
end;

procedure TAssetsFrameFP_2012.MutFundsClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('MUTFUNDS#1'),0);
end;

procedure TAssetsFrameFP_2012.StocksClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('STOCKS#1'),0);
end;

procedure TAssetsFrameFP_2012.BusinessClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('BUSINESS#1'),0);
end;

procedure TAssetsFrameFP_2012.OthAssetsClick(Sender: TObject);
begin
 OpenForm(GetCurrentRetNo,GetFormNo('OTHASSETS#1'),0);
end;

end.
