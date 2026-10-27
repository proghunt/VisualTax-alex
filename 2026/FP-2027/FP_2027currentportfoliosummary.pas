unit FP_2027currentportfoliosummary;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,QuickRpt,
  Qrctrls,ExtCtrls,Db,FP_2027Declare,FP_2027TrimStr,StdCtrls;

type
  TCurrentPortfolioSummary = class(TForm)
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRShape1: TQRShape;
    QRLabel9: TQRLabel;
    QRLabel11: TQRLabel;
    PortfTypeHeader: TQRGroup;
    QRLabel2: TQRLabel;
    QRBand3: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    PortfTypeFooter: TQRBand;
    QRBand4: TQRBand;
    DataSource1: TDataSource;
    QRDBText1: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel3: TQRLabel;
    QRShape2: TQRShape;
    PortfolioTypeDescriptionLbl: TQRLabel;
    QRBand1: TQRBand;
    QRShape3: TQRShape;
    QRLabel1: TQRLabel;
    QRDBText7: TQRDBText;
    QRSysData3: TQRSysData;
    QRLabel6: TQRLabel;
    DateLbl: TQRLabel;
    PortfolioTotalLbl: TQRLabel;
    QRDBText5: TQRDBText;
    QRLabel7: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CurrentPortfolioSummary: TCurrentPortfolioSummary;
  PortfolioTotal,ClientTotal: Real;

implementation

{$R *.DFM}


end.
