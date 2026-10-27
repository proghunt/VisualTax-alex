unit FP_2027BuyTransaction;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls,Mask,DBCtrls,ComCtrls,
  FP_2027Declare, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompClient,
  uADCompDataSet;


type
  TBuyTransactionFP_2012 = class(TForm)
    Label2: TLabel;
    DataSource2: TDataSource;
    GroupBox2: TGroupBox;
    CancelBtn: TBitBtn;
    SelectedItem: TEdit;
    SaveBtn: TBitBtn;
    Label10: TLabel;
    ListBox1: TListBox;
    StatusBox: TComboBox;
    Label12: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    OptionsPanel: TGroupBox;
    Label32: TLabel;
    Label26: TLabel;
    SettlementMethodBox: TComboBox;
    SettlementSourceBox: TComboBox;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    AccountBox: TEdit;
    AmountBox: TEdit;
    AmountTypeBox: TComboBox;
    ProductBox: TEdit;
    SelectAccountBtn: TBitBtn;
    AccountTypeBox: TComboBox;
    SysPlanPanel: TGroupBox;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    SysPlanFreqBox: TComboBox;
    SysPlanIndicatorBox: TComboBox;
    SysPlanStartDateBox: TEdit;
    SysPlanStopDateBox: TEdit;
    SysPlanRestartDateBox: TEdit;
    SysPlanAmountBox: TEdit;
    SysPlanCommRateBox: TEdit;
    NewAccountBtn: TBitBtn;
    IntermediaryCodeBox: TEdit;
    Label13: TLabel;
    IntermediaryAccountBox: TEdit;
    GroupBox10: TGroupBox;
    Label36: TLabel;
    Label37: TLabel;
    ContrPeriodBox: TComboBox;
    ContrCodeBox: TComboBox;
    GroupBox4: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Fe_RateBox: TEdit;
    Dsc_RateBox: TEdit;
    GrossNetBox: TRadioGroup;
    Label16: TLabel;
    BitBtn1: TBitBtn;
    PortfolioBtn: TBitBtn;
    DataSource1: TDataSource;
    SourceOfFundsBox: TComboBox;
    Label1: TLabel;
    ManagerCodeBox: TEdit;
    Label3: TLabel;
    SelectAnAgentBtn: TBitBtn;
    FDConnection: TADConnection;
    TransactionsTbl: TADTable;
    PortfolioDetailsQ: TADQuery;
(*
    procedure FormCreate(Sender: TObject);
    {procedure OpenMutualFundsQ;}
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
   { procedure PortFChartBtnClick(Sender: TObject);}
    procedure SearchBtnClick(Sender: TObject);
    {procedure SelectFundTypeBtnClick(Sender: TObject);}
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FundNameBoxKeyPress(Sender: TObject; var Key: Char);
    procedure InitTransaction;
    procedure SelectAccountBtnClick(Sender: TObject);
    Procedure ShowTransactiondata;
    procedure NewAccountBtnClick(Sender: TObject);
    procedure GrossNetBoxClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PortfolioBtnClick(Sender: TObject);
    procedure OpenPortfolioDetailsQ(PortfolioNm:String);
    Function CalcNetAmount(Gross,FeRate,DscRate:Real):Real;
    procedure SelectAnAgentBtnClick(Sender: TObject);
*)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BuyTransaction: TBuyTransactionFP_2012;
  FundType :string; //[2];
  TransactionNo : Integer;
  NewTransaction : Boolean;
  AccountId:string; //[20];

implementation

{$R *.DFM}


End.
