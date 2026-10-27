unit uProjectionCharts;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls,DBCtrls, Mask, vtEditBox, vtLabel,
  vtShape, TeeProcs, TeEngine, Chart, Buttons;
type
TProjectionCharts = class(TForm)
    vtPNONSHLabel1:TvtLabel;
    vtPNONSHLabel2:TvtLabel;
    vtPNONSHLabel3:TvtLabel;
    vtEdit1:TvtEdit;
    vtEdit2:TvtEdit;
    vtShape4: TvtShape;
    FixedAssetsChart: TImage;
    LiabilitiesChart: TImage;
    NetWorthChart: TImage;
    CashFlChart: TImage;
    vtLabel5: TvtLabel;
    vtLabel6: TvtLabel;
    vtLabel7: TvtLabel;
    vtLabel8: TvtLabel;
    vtLabel10: TvtLabel;
    vtEdit3: TvtEdit;
    vtLabel11: TvtLabel;
    vtEdit4: TvtEdit;
    vtLabel12: TvtLabel;
    PageBreak: TvtShape;
    FixedAssetsChartBtn: TBitBtn;
    LiabilitiesChartBtn: TBitBtn;
    NetWorthChartBtn: TBitBtn;
    CashFlChartBtn: TBitBtn;
    NonShChart: TImage;
    SheltChart: TImage;
    SemShChart: TImage;
    TotalInvestmentsChart: TImage;
    vtLabel1: TvtLabel;
    vtLabel2: TvtLabel;
    vtLabel3: TvtLabel;
    vtLabel9: TvtLabel;
    IncomeChart: TImage;
    vtLabel13: TvtLabel;
    IncomeChartBtn: TBitBtn;
    NonShChartBtn: TBitBtn;
    SheltChartBtn: TBitBtn;
    SemShChartBtn: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
ProjectionCharts: TProjectionCharts;
implementation
{$R *.DFM}
end.
