unit Upardox;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, DBTables, Grids, DBGrids;

type
  Tparadox = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Table1: TTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  paradox: Tparadox;

implementation

{$R *.DFM}

end.
