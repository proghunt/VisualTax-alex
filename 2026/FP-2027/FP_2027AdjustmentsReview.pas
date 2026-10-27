unit FP_2027AdjustmentsReview;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,FP_2027TrimStr,FP_2027Declare,
  FP_2027PayAdjustmentsSchedule,FP_2027SelectAnAgent;

type
  TAdjustmentsReview = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    EditBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label2: TLabel;
    AddBtn: TBitBtn;
    DeleteBtn: TBitBtn;
(*
    procedure FormCreate(Sender: TObject);
    procedure OpenPayAdjustmentsScheduleQ;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
*)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AdjustmentsReview: TAdjustmentsReview;

implementation

{$R *.DFM}

(*
procedure TAdjustmentsReview.FormCreate(Sender: TObject);
begin
 OpenPayAdjustmentsScheduleQ;
end;

procedure TAdjustmentsReview.OpenPayAdjustmentsScheduleQ;
Var WhereClause:String;
begin
 //PayAdjustmentsScheduleQ.DataBaseName := ClientsDb;
 WhereClause :='';
 With PayAdjustmentsScheduleQ do
 begin
  Close;
  SQL.Clear;
  SQL.Add('Select * from PayAdjustmentsSchedule ');
  SQL.Add( 'ORDER BY AgentCode,Code');

  //Prepare;
  Try
   open;
  Except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end; {Try}
 end; {with}
end;

procedure TAdjustmentsReview.CancelBtnClick(Sender: TObject);
begin
 PayAdjustmentsScheduleQ.Close;
 Close;
end;

procedure TAdjustmentsReview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

procedure TAdjustmentsReview.EditBtnClick(Sender: TObject);
begin
 If PayAdjustmentsScheduleq.RecordCount =0 then
 begin
  ShowMessage('Please add an agent first');
  exit;
 end;
 ThisAgent := PayAdjustmentsScheduleq.FieldByName('AgentCode').AsString;
 ExecuteForm(TPayAdjustmentsSchedule);
 OpenPayAdjustmentsScheduleQ;
end;

procedure TAdjustmentsReview.DBGrid1DblClick(Sender: TObject);
begin
EditBtnClick(Sender);
end;

procedure TAdjustmentsReview.AddBtnClick(Sender: TObject);
Var SelString:String;
begin
 Application.CreateForm(TSelectAnAgent,SelectAnAgent);
 SelectAnAgent.ShowModal;
 SelString:=SelectAnAgent.PickedItem.Text;
 SelectAnAgent.Free;
 If SelString>'' then
 begin
  PayAdjustmentsScheduleQ.Insert;
  PayAdjustmentsScheduleQ.FieldByName('AgentCode').AsString := SelString;
  {PayAdjustmentsScheduleQ.FieldByName('Code').AsString := '01';}
  PayAdjustmentsScheduleQ.Post;
 end;
end;

procedure TAdjustmentsReview.DeleteBtnClick(Sender: TObject);
begin
 if MessageDlg('Delete '+PayAdjustmentsScheduleQ.FieldByName('Code').AsString + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
 PayAdjustmentsScheduleQ.Edit;
 PayAdjustmentsScheduleQ.Delete;
end;
*)
end.
