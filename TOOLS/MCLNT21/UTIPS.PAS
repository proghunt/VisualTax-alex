unit Utips;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, DBCtrls, ExtCtrls, DB, DBTables,
  Grids, DBGrids,
  UDeclare,TrimStr,DBLookup, FileCtrl;

type
  TTip = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    Table1: TTable;
    DBMemo1: TDBMemo;
    SaveBtn: TBitBtn;
    Label3: TLabel;
    Image1: TImage;
    DBNavigator1: TDBNavigator;

    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Var Tip : TTip;



implementation

{$R *.DFM}

procedure TTip.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;
end;

procedure TTip.FormCreate(Sender: TObject);
var i : integer;
begin
Table1.Active := false;
Table1.DataBaseName := AppDir;
Table1.TableName := 'Tips.DBF';
{Table1.IndexName := 'Tip_Type';}
Table1.Open;
Table1.Edit;
end;

procedure TTip.SaveBtnClick(Sender: TObject);
begin
Table1.Edit;
Table1.Post;
ShowMessage('Tip Saved');
end;



end.
