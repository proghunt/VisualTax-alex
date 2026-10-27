unit FP_2027lifeinsur;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,StdCtrls,Buttons,FP_2027Declare,//20150819 IgorQuickRpt,qrextra,
  ExtCtrls;

type
  TLifeInsur = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DeleteBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PrintBtn: TBitBtn;
    Panel3: TPanel;
(*
    procedure FormCreate(Sender: TObject);
    procedure OpenQuery;
    procedure DeleteBtnClick(Sender: TObject);
    procedure LifeInsuranceQBeforeInsert(DataSet: TDataSet);
    procedure LifeInsuranceQNewRecord(DataSet: TDataSet);
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    //procedure AddBtnClick(Sender: TObject);
    Procedure InitNewRec;
    procedure PrintBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
 *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LifeInsur: TLifeInsur;
//20150819 Igor  Report : TQuickRep;

implementation

{$R *.DFM}

(*
uses FP_2027TrimStr,FP_2012RepLifeInsurance;
  
procedure TLifeInsur.FormCreate(Sender: TObject);
begin
DecimalSeparator:='.';
OpenQuery;
DbGrid1.SetFocus;   //new

end;

procedure TLifeInsur.OpenQuery;
Var WhereClause:String;
begin
end;


procedure TLifeInsur.DeleteBtnClick(Sender: TObject);
begin
if MessageDlg('Delete '+LifeInsuranceQ.FieldByName('PolicyNo').AsString + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
 LifeInsuranceQ.Edit;
 LifeInsuranceQ.Delete;
end;

procedure TLifeInsur.LifeInsuranceQBeforeInsert(DataSet: TDataSet);
begin
 {
 If (LifeInsuranceQ.FieldByName('CashSurrenderValue').AsFloat = 0)
 and (LifeInsuranceQ.RecordCount >0) then
 begin
   ShowMessage('Enter Cash Surrender value, or delete the record');
   Abort;
 end;
}
end;

procedure TLifeInsur.LifeInsuranceQNewRecord(DataSet: TDataSet);
begin
 {
 LifeInsuranceQ.FieldByName('ClientId').AsString := Ret[RetNo]^.ClientId;
 LifeInsuranceQ.FieldByName('PolicyNo').AsString := '?????';
 }
end;

procedure TLifeInsur.CancelBtnClick(Sender: TObject);
begin
 If LifeInsuranceQ.Modified then
 begin
  LifeInsuranceQ.Edit;
  Try
   LifeInsuranceQ.Post;
   except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;

 end;
  LifeInsuranceQ.Close;
Close;
end;

procedure TLifeInsur.DBGrid1KeyPress(Sender: TObject; var Key: Char);
Var BkMark:TBookMark;
begin
 If (AllTrim(LifeInsuranceQ.FieldByName('ClientId').AsString) = '')
 or (LifeInsuranceQ.Eof = True)
 or (LifeInsuranceQ.RecordCount =0)
 then
 begin
  InitNewRec;
  LifeInsuranceQ.Post;
  BkMark:=LifeInsuranceQ.GetBookMark;
  OpenQuery;
  LifeInsuranceQ.GotoBookMark(BkMark);
 end;


end;

procedure TLifeInsur.InitNewRec;
begin
end;

procedure TLifeInsur.PrintBtnClick(Sender: TObject);
begin
    Application.CreateForm(TRepLifeInsurance,RepLifeInsurance);
    Report := RepLifeInsurance.QuickRep1;
    Report.Preview;
    RepLifeInsurance.Free;

end;

procedure TLifeInsur.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;
*)
end.
