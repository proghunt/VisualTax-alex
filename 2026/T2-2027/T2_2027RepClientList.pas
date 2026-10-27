unit T2_2027RepClientList;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  QuickRpt,Db,Qrctrls, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager,
  uADCompClient, uADCompDataSet;

type
  TRepClientListT2_2027 = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRSysData3: TQRSysData;
    PrintDate: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRShape1: TQRShape;
    Table1: TADTable;
    FDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepClientList: TRepClientListT2_2027;

implementation

{$R *.DFM}

uses vtDialogs,T2_2027,T2_2027trimStr,T2_2027Declare,vtTrimStr,vtShared,vtDataBase;

procedure TRepClientListT2_2027.FormCreate(Sender: TObject);
begin
 PrintDate.Caption:=FormatDateTime('yyyy-mm-dd',Date);

  //20150922 Igor
  SetTableName(FDConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite, '');

end;

procedure TRepClientListT2_2027.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Table1.Close;
end;

end.
