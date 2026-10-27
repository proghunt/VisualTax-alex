unit FP_2027Response;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,FP_2027TrimStr,FP_2027Declare,Db, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf,
  uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool,
  uADPhysManager, uADCompClient, uADCompDataSet;

type
  TResponse = class(TForm)
    ListBox1: TListBox;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Table1: TADTable;
    FDConnection: TADConnection;
    TransactionsTbl: TADTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Response: TResponse;
  TransactionId : string; //[15];
  ReturnCode : string; //[2];
  ErrorCode   : Array[1..5] of string; //[3];
  AssignedOrderId:string; //[7];
  AssignedTradeDate : string; //[8];
  AcknowledgementDate : string; //[8];
  SettlementDate : string; //[8];
  {AcknowledgementTime : string; //[8];}

implementation

{$R *.DFM}


end.
