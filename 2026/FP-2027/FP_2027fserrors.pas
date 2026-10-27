unit FP_2027fserrors;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  Grids,DBGrids,Db,StdCtrls,Buttons;

type
  TFSErrors = class(TForm)
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    HeaderBox: TPanel;
(*
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
 *)   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSErrors: TFSErrors;

implementation

{$R *.DFM}

(*
procedure TFSErrors.FormCreate(Sender: TObject);
begin
Table1.Close;
Table1.Open;
end;

procedure TFSErrors.CancelBtnClick(Sender: TObject);
begin
 If Table1.Active then Table1.Close;
 Close;
end;

procedure TFSErrors.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;
*)
end.
