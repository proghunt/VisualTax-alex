unit Ufixdb;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Grids, DBGrids, DB, DBTables,
  UDeclare, TrimStr, ExtCtrls, DBCtrls;

type
  TFixDBForm = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    DBNavigator1: TDBNavigator;
    SortBy: TRadioGroup;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SortByClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const HelpTopic = 'Utilities_advanced';
var
  FixDBForm: TFixDBForm;

implementation

{$R *.DFM}

procedure TFixDBForm.FormCreate(Sender: TObject);
begin
Caption := 'Modify ' + FixDBName;
If FixDbName = ClientsTable then
 Table1.DataBaseName := CfgRec.Dir_Cur
else
 Table1.DataBaseName := AppDir;

Table1.TableName := FixDBName;
If UpperCase(FixDbName) = scrdbf then
 begin
  SortBy.Visible := True;
  SortBy.ItemIndex := 0;
  SortByClick(Sender);
 end
 else
  SortBy.Visible := False;
Table1.Open; Table1.Edit;
Table1.First;
end;


procedure TFixDBForm.CancelBtnClick(Sender: TObject);
begin
Table1.Close; Close;
end;

procedure TFixDBForm.SortByClick(Sender: TObject);
begin
 Case SortBy.ItemIndex of
 0: Table1.IndexName := 'FormName';
 1: Table1.IndexName := 'FormNo';
 2: Table1.IndexName := 'PrnSeq';
 else
 Table1.IndexName := 'FormName';
 end;
 If Table1.Active then Table1.First;
end;


procedure TFixDBForm.BitBtn1Click(Sender: TObject);
begin
ShowHelp(HelpTopic);
end;

end.
