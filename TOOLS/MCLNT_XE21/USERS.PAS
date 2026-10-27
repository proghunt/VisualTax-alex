unit Users;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, DBCtrls, DB, DBTables,
  TrimStr,UDeclare;

type
  TUserfrm = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    DBEdit1: TDBEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Userfrm: TUserfrm;

implementation

{$R *.DFM}

end.
