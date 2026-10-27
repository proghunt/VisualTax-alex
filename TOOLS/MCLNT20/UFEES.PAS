unit Ufees;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, StdCtrls, Buttons, DB, Grids, DBGrids,
  ExtCtrls, DBCtrls,
  UDeclare,TrimStr;

type
  TFees = class(TForm)
    DataSource1: TDataSource;
    Table1: TTable;
    DBGrid1: TDBGrid;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    SortBy: TRadioGroup;
    Table1FORMNAME: TStringField;
    Table1FEE: TStringField;
    Table1FEEADDITEM: TStringField;
    Table1FORMABREV: TStringField;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SortByClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fees: TFees;

implementation

{$R *.DFM}

procedure TFees.CancelBtnClick(Sender: TObject);
begin
Table1.Close;
Close;

end;

procedure TFees.FormCreate(Sender: TObject);
begin
If not Table1.Active then
 begin
  Table1.DataBaseName := AppDir;
  Table1.TableName := ScrDBF; {'TAxFScr';} {'Fees';}
  SortBy.ItemIndex :=1;
  SortByClick(Sender);
  Table1.Open;
  Table1.Edit;
  Table1.First;
  end;
end;

procedure TFees.OKBtnClick(Sender: TObject);
begin
Table1.Edit;
Table1.Post;
Close;
Flist.Clear; {reinit the form specs}
end;

procedure TFees.SortByClick(Sender: TObject);
begin
 Case SortBy.ItemIndex of
 0: Table1.IndexName := 'FormName';
 1: Table1.IndexName := 'Fee';
 else
 Table1.IndexName := 'FormName';
 end;
If Table1.Active then Table1.First;
end;

end.
