unit FP_2027PostTransactions;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,Db,Grids,DBGrids,FP_2027Declare,FP_2027TrimStr;

Const AssetType1 = 'MF-RRSP';
      AssetType2 = 'MF-Other';
type
  TPostTransactions = class(TForm)
    Panel3: TPanel;
    PostTransactionsBtn: TBitBtn;
    CancelBtn: TBitBtn;
    TransactionsSrc: TDataSource;
    DBGrid1: TDBGrid;
    AssetsSrc: TDataSource;
    ListBox1: TListBox;
    Label3: TLabel;
    DataSource1: TDataSource;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    FromDtBox: TEdit;
    ToDtBox: TEdit;
//    procedure FormCreate(Sender: TObject);
(*
    procedure FormCreate(Sender: TObject);
    procedure OpenAssets;
    procedure OpenTransactionsQ;
    procedure OpenClients;
    procedure OpenTables;
    procedure CancelBtnClick(Sender: TObject);
    procedure PostTransactionsBtnClick(Sender: TObject);
    Function FoundProductInAssets(Product,ClId:String):Boolean;
    Procedure InsertAsset;
    Procedure AdjustAsset;
    procedure SetToPosted;
    Function InClientsDB(ClId:String):Boolean;
    procedure TransactionsQCalcFields(DataSet: TDataSet);
    procedure FromDtBoxChange(Sender: TObject);
    procedure ToDtBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PostTransactions: TPostTransactions;

implementation

{$R *.DFM}

end.
