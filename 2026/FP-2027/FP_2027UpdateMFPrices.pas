unit FP_2027UpdateMFPrices;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons;

type
  TUpdateMFPrices = class(TForm)
    PricingInfoSrc: TDataSource;
    FundInfoSrc: TDataSource;
    UpdateBtn: TBitBtn;
    CancelBtn: TBitBtn;
    TradingCodeScr: TDataSource;
    MutualFundsSrc: TDataSource;
    DBGrid4: TDBGrid;
    RebuildBtn: TBitBtn;
    DuplicatesBtn: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UpdateMFPrices: TUpdateMFPrices;

implementation

{$R *.DFM}


end.
