unit Rclients;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrep, DB, DBTables;

type
  TR1 = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    ClientList: TQuickReport;
    QRDBText1: TQRDBText;
    QRDBCalc1: TQRDBCalc;
    QRBand1: TQRBand;
    QRGroup1: TQRGroup;
    QRShape1: TQRShape;
  end;

var
  R1: TR1;

implementation

{$R *.DFM}

end.
