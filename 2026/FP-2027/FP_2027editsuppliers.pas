unit FP_2027editsuppliers;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,Grids,
  DBGrids,Db,FP_2027Declare,FP_2027TrimStr,StdCtrls,Buttons,ExtCtrls,
  DBCtrls;

type
  TEditSuppliers = class(TForm)
    SupplierDs: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SelectedItem: TEdit;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
(*
    procedure FormCreate(Sender: TObject);
    procedure OpenSupplierQuery;
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure OKBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EditSuppliers: TEditSuppliers;

implementation

{$R *.DFM}
(*
procedure TEditSuppliers.FormCreate(Sender: TObject);
begin
 OpenSupplierQuery;
end;

procedure TEditSuppliers.OpenSupplierQuery;
 {}
Var WhereClause:String;
begin
 //SupplierQuery.DataBaseName:= FundsDb;
 SupplierQuery.ConnectionString:=FundBaseConnectionString;
 SupplierQuery.Close;
 SupplierQuery.SQL.Clear;
 {Build where clause}
 WhereClause := '';
 {------------}
 With SupplierQuery do
 begin
 SQL.Add('Select ');
 SQL.Add('Name');
 SQL.Add(',Supplier');
 SQL.Add(' From Suppliers');
 SQL.Add(' Order by Name');
 //Prepare;
 open; {good only for local db and SELECT statement on Client server}
 {Query1.ExecSql;}  {good for INSERT, UPDATE, DELETE, and CREATE TABLE and client server db as well}
 end;


end;

procedure TEditSuppliers.CancelBtnClick(Sender: TObject);
begin
SelectedItem.Text :='';
Close;
end;

procedure TEditSuppliers.DBGrid1CellClick(Column: TColumn);
begin
 SelectedItem.Text := SupplierQuery.FieldByName('Supplier').AsString;
end;

procedure TEditSuppliers.OKBtnClick(Sender: TObject);
begin
  SupplierQuery.Edit;
  SupplierQuery.Post;
  Close;
end;

procedure TEditSuppliers.DBGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;
*)
end.
