unit FP_2027PayCodes;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  DBCtrls,Grids,DBGrids,Db,StdCtrls,Buttons,FP_2027TrimStr,
  FP_2027Declare;

type
  TPayCodes = class(TForm)
    HeaderBox: TPanel;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
(*
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Table1BeforePost(DataSet: TDataSet);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PayCodes: TPayCodes;

implementation

{$R *.DFM}

(*
procedure TPayCodes.SaveBtnClick(Sender: TObject);
begin
 Table1.Edit;
 Try
 Table1.Post;
 except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
ShowMessage('Saved');
end;

procedure TPayCodes.CancelBtnClick(Sender: TObject);
begin
If Table1.Active then table1.Close;
Close;
end;

procedure TPayCodes.FormCreate(Sender: TObject);
begin
//Table1.DataBaseName := ClientsDb;
If Table1.Active then Table1.Close;
Table1.Open;
end;

procedure TPayCodes.Table1BeforePost(DataSet: TDataSet);
begin
 If Vl(Table1['Code']) <31 then
 begin
   Table1.Edit;
   Table1['Type'] := 'Charge';
 end
 else
 begin
   Table1.Edit;
   Table1['Type'] := 'Credit';
 end;
 If AllTrim(Table1['Description']) ='' then
 begin
   ShowMessage('Description required');
   Abort;
 end
end;
*)
end.
