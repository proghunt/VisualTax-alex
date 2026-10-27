unit FP_2027portfoliocreator;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,Grids,DBGrids,Db,ExtCtrls, //20150819 Igor QuickRpt,
  DBCGrids,Mask,DBCtrls,ComCtrls,FP_2027Declare;

type
  TPortfolioCreatorFP_2012 = class(TForm)
    FormHeader: TPanel;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    DBGrid2: TDBGrid;
    TabSheet2: TTabSheet;
    Panel7: TPanel;
    Label7: TLabel;
    DBGrid1: TDBGrid;
    Panel9: TPanel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Label10: TLabel;
    Bevel13: TBevel;
    DBEdit4: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    Label13: TLabel;
    DBText3: TDBText;
    DBEdit9: TDBEdit;
    Bevel7: TBevel;
    Label6: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CalcBtn: TBitBtn;
    ProjectOptionBox: TRadioGroup;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    Label23: TLabel;
    Bevel1: TBevel;
    TransactionsSrc: TDataSource;
    CancelBtn: TBitBtn;
    PortfolioReportBtn: TBitBtn;
    PortFChartBtn: TBitBtn;
    Panel6: TPanel;
    DeleteFundBtn: TBitBtn;
    SelectBtn: TBitBtn;
    GroupBox3: TGroupBox;
    DBGrid3: TDBGrid;
    Panel5: TPanel;
    NewPortfolioBtn: TBitBtn;
    DeletePortfolioBtn: TBitBtn;
    ImportPortfolioBtn: TBitBtn;
    PortfolioProjectionBtn: TBitBtn;
    CurrentPortfoliosBtn: TBitBtn;
(*
    Procedure CopyPortfolioRec(PortFolioName,NewPortFolioName:String);
    Procedure CopyPortfolioDetailsRec(PortFolioNm,NewPortfolioNm:String);
    procedure OpenTransactionsQ;
    procedure InitTransaction;
    procedure NewPortfolioBtnClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DeletePortfolioBtnClick(Sender: TObject);
    procedure DeleteFundBtnClick(Sender: TObject);
    {procedure AddFundBtnClick(Sender: TObject);}
    procedure FormCreate(Sender: TObject);
    procedure OpenTables;
    procedure OpenPortfolioQ;
    procedure OpenPortfolioDetailsQ;
    //procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure PortfolioReportBtnClick(Sender: TObject);
    procedure PortfolioProjectionBtnClick(Sender: TObject);
    procedure PortfolioQAfterScroll(DataSet: TDataSet);
    procedure CalcBtnClick(Sender: TObject);
    Function  GetRateOfReturn(SouthamId:string;TypeOfReturn:String):Real;
    Function  GetStdDev5yr(SouthamId:string):Real;
    Function  GetStdDev3yr(SouthamId:string):Real;
    procedure ProjectOptionBoxClick(Sender: TObject);
    procedure SetProjectionYears;
    procedure SelectBtnClick(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    {procedure ConvertToOrdersBtnClick(Sender: TObject);}
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure ImportPortfolioBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    Function ValidatePortfolio:Boolean;
    procedure PortfolioQBeforePost(DataSet: TDataSet);
    procedure PortfolioDetailsQBeforePost(DataSet: TDataSet);
    procedure PortFChartBtnClick(Sender: TObject);
    procedure CurrentPortfoliosBtnClick(Sender: TObject);
    Procedure GetCurrentPortfolio(PortFlNm,PortFlType:String);
    Procedure GetCurrentPortfolioDetails(PortFlNm,AssetType:String);
    Procedure OpenAssetsQ(PortFlNm,AssetType:String);
    procedure DeleteCurrentPortfolios(PortflName:String);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PortfolioCreator: TPortfolioCreatorFP_2012;
  PortfolioName :String[25];
  TotalInitialInvestment,
  TotalAllocatedAmount, TotalAllocatedPercent,TotalFutureValue,
  TotalGainPercent:Real;
  TransactionNo:Integer;
 //20150819 Igor  Report : TQuickRep;

implementation

{$R *.DFM}

end.
