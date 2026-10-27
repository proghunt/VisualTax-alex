unit FP_2027exportToFS;
(* Actually does nothing
*)

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,TabNotBk,StdCtrls,Buttons,ComCtrls,FileCtrl,FP_2027Declare,
  FP_2027TrimStr,FP_2027FsRtns,Grids,Db,DBGrids,Mask,DBCtrls,
  FP_2027Common,ExtCtrls,FP_2027FsOutFiles,ShellApi, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompClient, uADCompDataSet;

Const BufferSize=1200;
Const OrderVersion = '261200';
type
  TExportToFS = class(TForm)
    TransactionsQSrc: TDataSource;
    GroupBox1: TGroupBox;
    PrepBtn: TBitBtn;
    TestOrProduction: TRadioGroup;
    Label1: TLabel;
    DBNavigator1: TDBNavigator;
    DBGrid2: TDBGrid;
    Panel3: TPanel;
    FileSeqBox: TEdit;
    Label3: TLabel;
    Label2: TLabel;
    SetForSelectedBtn: TBitBtn;
    SetForAllBtn: TBitBtn;
    CancelBtn: TBitBtn;
    AccountQuerySource: TDataSource;
    ListFsOutFilesBtn: TBitBtn;
    TransmitBtn: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Image1: TImage;
    Label6: TLabel;
    Image2: TImage;
    FDConnection: TADConnection;
    ClientsTbl: TADTable;
    TransactionsQ: TADQuery;
    AccountQuery: TADQuery;

(*
    {Function PrepOne:Boolean;}
    Function DateToMDDY(Dt:TDateTime;TestOrProduction:Integer):String;
    Function DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
    Function MkFileName(
       FileCode,FileSeq,Recipient,Sender:string;
       Dt:TDateTime;TestOrProduction:Integer):string;

    procedure WriteOrderBtnClick(Sender: TObject);
    {procedure PrepareFundServeOrder;}
    procedure FormCreate(Sender: TObject);
    procedure PrepBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    Procedure GetOrderLayouts;
    Function  GetFpOrdStatus(RetNo:Integer;FName:String):String;
    procedure OpenTransactionsQ;
    Procedure InsertDataToBuffer(FromPos,Len:Integer;Valu:String);
    Function IsNewAccount(AccountNo:String):Boolean;
    Procedure PrepareHdrRec;
    Procedure PrepareDtlRec;
    Procedure PrepareTrlRec;
    procedure ConnectToFundServBtnClick(Sender: TObject);
    procedure ShowAndTransmit;
    procedure TabbedNoteBook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure SetForAllBtnClick(Sender: TObject);
    procedure SetForSelectedBtnClick(Sender: TObject);
    procedure ChangeStatus(NewStatus,TransId:String);
    procedure TransactionsQCalcFields(DataSet: TDataSet);
    Function GetTheFileSeq:String;
    Function OpenAccountQuery(Client,Supplier,AccountType:String):String;
    Function GetClientAccount(Client,Supplier,AccountType:String):String;
    procedure ListFsOutFilesBtnClick(Sender: TObject);
    Function GetFileName:String;
    Function PreValidate:Boolean;
    procedure TransmitBtnClick(Sender: TObject);
    procedure ArchiveFile(FileName:String);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportToFS: TExportToFS;
  FSOutDir, FsOutArchive   :String;

  RecCount:Integer;
  BufferRec : AnsiString;
  FileName:String;
  F:TextFile;
implementation

{$R *.DFM}

end.
