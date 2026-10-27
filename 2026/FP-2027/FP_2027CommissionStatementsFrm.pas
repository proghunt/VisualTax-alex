unit FP_2027CommissionStatementsFrm;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,Grids,DBGrids,Db,ComCtrls,FP_2027TrimStr,FP_2027Declare,
  ExtCtrls,{QuickRpt,qrextra,} //20150817 igor
  FP_2027CommissionsReport, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TCommissionStatementsFrm = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel2: TPanel;
    TreeView1: TTreeView;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    FromDateBox: TEdit;
    ToDateBox: TEdit;
    CancelBtn: TBitBtn;
    ScopeBox: TRadioGroup;
    AgentNameLbl: TLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    PrintOneBtn: TBitBtn;
    MarkAsPaidBox: TCheckBox;
    PrintAllBtn: TBitBtn;
    GroupBox2: TGroupBox;
    OkBtn: TBitBtn;
    DataSource2: TDataSource;
    CalcAgentCommissionBtn: TBitBtn;
    FDConnection: TADConnection;
    TransactionsQ: TADQuery;
    Query1: TADQuery;
  (*
    procedure Query1CalcFields(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    Procedure OpenTables;
    Procedure OpenBranchOfficesQ;
    procedure TreeView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure OkBtnClick(Sender: TObject);

    procedure TreeView1DblClick(Sender: TObject);
    procedure PrintOneBtnClick(Sender: TObject);
    procedure PrintAllBtnClick(Sender: TObject);
    Function CalcAgentCommission(ThisAgent,FromDt,ToDt:String):Real;
    procedure CalcAgentCommissionBtnClick(Sender: TObject);
    Procedure OpenTransactionsQ;
    procedure FromDateBoxDblClick(Sender: TObject);
    procedure FromDateBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ToDateBoxDblClick(Sender: TObject);
    procedure ToDateBoxKeyPress(Sender: TObject; var Key: Char);
    *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommissionStatementsFrm: TCommissionStatementsFrm;
  // Report : TQuickRep;  //20150817 igor
  FromDt,ToDt:string; //[10];
  MarkAsPaid : Boolean;

implementation

{$R *.DFM}

end.
