unit FP_2027Liabilities;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,Buttons,Grids,DBGrids,Db,DBCtrls,FP_2027Declare,
  FP_2027TrimStr,FP_2027Calc,//20150819 Igor QuickRpt,qrextra,
  FP_2027RepLiabilities;
  //UMortgageCalculator,UDebtRepaymentCalculator;

type
  TLiabilities = class(TForm)
    DataSource1: TDataSource;
    LiabilityTypeLbl: TLabel;
    CancelBtn: TBitBtn;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    Delete: TBitBtn;
    DataSource2: TDataSource;
    LiabilityTypeBox: TRadioGroup;
    PrintBtn: TBitBtn;
    CalculatorPanel: TPanel;
    Label3: TLabel;
    Label2: TLabel;
    AutoMonthlyBtn: TBitBtn;
(*
    procedure CalcRec;
    procedure FormCreate(Sender: TObject);
    procedure OpenLiabilitiesQ;
    procedure CancelBtnClick(Sender: TObject);
    procedure LiabilityTypeBoxClick(Sender: TObject);
    procedure InitNewRec;
    Function CalcPayOffDate(AsOfDate:String;YearsRemaining:Integer):String;
    //procedure AddBtnClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure SetUpGridFields;
    procedure RunSql;
    procedure LoadLiabilityDescriptions;
    Function GetLiabilityType(Description:String):String;
    procedure LiabilitiesummaryBtnClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure PrintBtnClick(Sender: TObject);
    procedure DBGrid1ColExit(Sender: TObject);
    procedure LiabilitiesQBeforeScroll(DataSet: TDataSet);
    procedure LiabilitiesQBeforePost(DataSet: TDataSet);

    Function GetLiabilityAmount(Description:String):String;
    procedure UpdateTotalAmounts;
    Function GetLiabilityHeader:String;
    Procedure CalcMonthlyPayment;
    //procedure BitBtn1Click(Sender: TObject);
    //procedure DebtRepaymentBtnClick(Sender: TObject);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Liabilities: TLiabilities;
  LiabilityType : String[10];
  WhereClause:String;
  //20150819 Igor Report : TQuickRep;
implementation

{$R *.DFM}

end.
