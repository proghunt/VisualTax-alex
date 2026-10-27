unit T2_2027RepBsAccounts;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  QuickRpt,Db,Qrctrls,T2_2027trimStr,T2_2027Declare, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef,
  uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;

type
  TRepBSAccountsT2_2027 = class(TForm)
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRLabel2: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel4: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel3: TQRLabel;
    QRShape2: TQRShape;
    QRLabel5: TQRLabel;
    PrintDate: TQRLabel;
    QRLabel1: TQRLabel;
    Table1: TADTable;
    FDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QRBand3BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QuickRep1BeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepBSAccounts: TRepBSAccountsT2_2027;

implementation

{$R *.DFM}

uses vtTrimStr,vtShared,vtDataBase;
  
procedure TRepBSAccountsT2_2027.FormCreate(Sender: TObject);
begin
 {PrintDate.Caption:=FormatDateTime('yyyy-mm-dd',Date);}

  //20150922 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + GiFibsDBLite, GiFibsTableLite, '');

end;

procedure TRepBSAccountsT2_2027.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Table1.Close;
 Close;
end;

procedure TRepBSAccountsT2_2027.QRBand3BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
Var Displ:Integer;
begin
 Displ:=30;
 With Table1 do
 begin
   If AllTrim(FieldByName('Parent').AsString) = '' then
    begin
     QrDBText1.Font.Style := [fsBold];
     QrDBText4.Font.Style := [fsBold];
     QrDBText1.Left := Displ;
    end
   else If UpperCase(AllTrim(FieldByName('Calculated').AsString)) = 'Y' then
    begin
     QrDBText1.Font.Style := [fsBold];
     QrDBText4.Font.Style := [fsBold];
     QrDBText1.Left := Displ+15;
    end
   else
     begin
       QrDBText1.Font.Style := [];
       QrDBText4.Font.Style := [];
       QrDBText1.Left := Displ+30;
     end;
  end;


end;

procedure TRepBSAccountsT2_2027.QuickRep1BeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  PrintDate.Caption:=FormatDateTime('yyyy/mm/dd',Date);
end;

end.
