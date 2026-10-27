unit FP_2027processfsfunds;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  Grids,DBGrids,StdCtrls,Buttons,Db,FP_2027TrimStr,FP_2027Declare,
  FP_2027FsRtns,FP_2027SelectFile, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

Const BufferSize=420;

type
  TProcessFsFunds = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    StringGrid2: TStringGrid;
    Panel3: TPanel;
    FileBox: TEdit;
    Label1: TLabel;
    SelectDirBtn: TBitBtn;
    Label2: TLabel;
    PreviewBtn: TBitBtn;
    UpdateFundsBtn: TBitBtn;
    Memo1: TMemo;
    FDConnection: TADConnection;
    MutualFundsTbl: TADTable;
(*
    procedure FormCreate(Sender: TObject);
    Procedure ProcessFundsFile(FileName:string);
    procedure CancelBtnClick(Sender: TObject);
    procedure PreviewBtnClick(Sender: TObject);
    {Procedure Preview(FileName:String);}
    procedure UpdateFundsBtnClick(Sender: TObject);
    Procedure BreakFundsRec(FundsRec:AnsiString);
    Function GetNumbRecords(FileName:String):Integer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SelectDirBtnClick(Sender: TObject);
    procedure UpdateOnly;
    Function  ValidateFile(FileName:String):Boolean;
*)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
  RecSize =420;
var
  ProcessFsFunds: TProcessFsFunds;
  FileName:String;
  {Fs Funds file structure}
   RecordID    :string; //[6];
   ActionCode  :string; //[3];
   EffectiveDate:string; //[8];
   FundNo      :string; //[5];
   FundName    :string; //[80];
   FundNameF   :string; //[80];
   LoadType    : string; //[3];
   Currency    :string; //[2];
   PriceModel  :string; //[1];
   CutOffTime  : string; //[4];
   FundTypeCode : string; //[1];
   PurchSettlePeriod : string; //[1];
   RedemptionSettlePeriod : string; //[1];
   ParentFundNo   : string; //[5];
   Supplier    :string; //[3];
   FundClassification: string; //[2];
   FundEligibility  : string; //[1];
   ProductType     : string; //[1];
   FundClass       :string; //[2];
   FromFundNo      : string; //[5];
   FromSupplier    : string; //[3];
   ContactName     : string; //[40];
   ContactPhone    : string; //[10];
   DeactivationDate : string; //[8];
   Filler           :string; //[139];
   Version          :string; //[6];

implementation

{$R *.DFM}

end.
