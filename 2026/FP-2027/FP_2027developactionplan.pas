unit FP_2027developactionplan;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ComCtrls,Db,Menus,ExtCtrls,ToolWin,Grids,DBGrids,DBCtrls,
  FP_2027Declare;//20150819 IgorQuickRpt,qrextra;

type
  TDevelopActionPlan = class(TForm)
    DataSource1: TDataSource;
    PageControl1: TPageControl;
    BuySellSheet: TTabSheet;
    Label8: TLabel;
    DataSource2: TDataSource;
    GroupBox3: TGroupBox;
    DBGrid1: TDBGrid;
    ReviewSheet: TTabSheet;
    GroupBox2: TGroupBox;
    DBGrid2: TDBGrid;
    PrintDialog1: TPrintDialog;
    DataSource3: TDataSource;
    Panel3: TPanel;
    EnterDirectlyBtn: TBitBtn;
    RemoveBtn: TBitBtn;
    GroupBox6: TGroupBox;
    AssetsGrid: TDBGrid;
    SellBtn: TBitBtn;
    AddMFSheltBtn: TBitBtn;
    BuyMFNonShBtn: TBitBtn;
    SwitchFundBtn: TBitBtn;
    CloseBtn: TBitBtn;
    PrintBtn: TBitBtn;
    AssetTypeBox: TComboBox;
    Label1: TLabel;

    (*
    procedure BuyMF(AssetType:string);
    procedure FormCreate(Sender: TObject);
    procedure OpenAssetsQ;
    procedure OpenActionPlanQ;
    procedure OpenActionPlanQ2;
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure AddMFSheltBtnClick(Sender: TObject);
    procedure BuyMFNonShBtnClick(Sender: TObject);
    procedure SellBtnClick(Sender: TObject);
    procedure EnterDirectlyBtnClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure AssetTypeBoxChange(Sender: TObject);
    procedure LoadAssetTypes;
    procedure SwitchFundBtnClick(Sender: TObject);
    procedure GetSwitchToFund(AssetType:string);
    Function  AddAction(Action:string):Boolean;
    procedure ActionPlanQ2NewRecord(DataSet: TDataSet);
    procedure ActionPlanQNewRecord(DataSet: TDataSet);
    procedure PrintBtnClick(Sender: TObject);
   *)
    //procedure ReviewNetWorthBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  DevelopActionPlan: TDevelopActionPlan;
  SaleProceeds:Real;
  AssetType:string; //[15];
  SpecificAssetType : string; //[20];
//20150819 Igor  Report : TQuickRep;
  MFundsMastRec: TMFundsMastRec;
  RunningAmount,RunningPercent,RunningForeignCn,RunningForeignPercent:Real;
  TotAvailableAmount:Real;
  TotInitial,TotInterest,TotGainPercent,TotFutVal:real;
  CreateStage : Boolean;


implementation

{$R *.DFM}

end.
