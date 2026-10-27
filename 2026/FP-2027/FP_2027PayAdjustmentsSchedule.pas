unit FP_2027PayAdjustmentsSchedule;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,ExtCtrls,Mask,DBCtrls,ComCtrls,
  FP_2027TrimStr,FP_2027Declare,DBCGrids,FP_2027SelectPayCode,fYearCalendar;


type
  TPayAdjustmentsSchedule = class(TForm)
    HeaderBox: TPanel;
    AdjustmentsSource: TDataSource;
    DBCtrlGrid1: TDBCtrlGrid;
    CodeBox: TDBEdit;
    DBEdit3: TDBEdit;
    StartFromBox: TDBEdit;
    EndInBox: TDBEdit;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    AgentNameLbl: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    CancelBtn: TBitBtn;
    AddBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    SaveBtn: TBitBtn;
    Memo1: TMemo;
(*
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
   { procedure OpenAgentsQ;}
    procedure OpenPayAdjustmentsScheduleQ;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure StartFromBoxKeyPress(Sender: TObject; var Key: Char);
    Function FetchADate:String;
    procedure EndInBoxKeyPress(Sender: TObject; var Key: Char);
    procedure CodeBoxKeyPress(Sender: TObject; var Key: Char);
    procedure PayAdjustmentsScheduleQBeforePost(DataSet: TDataSet);
    procedure CodeBoxDblClick(Sender: TObject);
    procedure StartFromBoxDblClick(Sender: TObject);
    procedure EndInBoxDblClick(Sender: TObject);
    Function AddOneToYear(Yr:String):String;
    procedure DBCtrlGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBEdit3KeyPress(Sender: TObject; var Key: Char);
    procedure PayAdjustmentsScheduleQNewRecord(DataSet: TDataSet);
*)    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PayAdjustmentsSchedule: TPayAdjustmentsSchedule;

implementation

{$R *.DFM}

end.
