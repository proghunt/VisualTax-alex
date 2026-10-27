unit FP_2027repassets;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,QuickRpt,
  Qrctrls,ExtCtrls,Db, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TRepAssetsFP_2027 = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRBand3: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRBand2: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRBand5: TQRBand;
    QRExpr2: TQRExpr;
    QRLabel8: TQRLabel;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    QRLabel6: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel7: TQRLabel;
    QRDBText7: TQRDBText;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRBand4: TQRBand;
    QRSysData2: TQRSysData;
    QRLabel13: TQRLabel;
    QRGroup1: TQRGroup;
    QRDBText4: TQRDBText;
    QRLabel14: TQRLabel;
    Query1: TADQuery;
    FDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    Procedure OpenQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepAssets: TRepAssetsFP_2027;

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TRepAssetsFP_2027.FormCreate(Sender: TObject);
begin
 OpenQuery;
 QrLabel14.Caption:= FormatDateTime('yyyy-mm-dd',Now);
 {Dt := FormatDateTime('yyyy-mm-dd',Now);}
end;

{
Function TRepAssets.Dt:String;
begin
 Result := FormatDateTime('yyyy-mm-dd',Now);
end;
}
Procedure TRepAssetsFP_2027.OpenQuery;
//Const TblName='Assets.db f'; //rem 20150922 Igor
Var WhereClause :String;
begin
Try
 With Query1 do
 begin
  If Active then Close;
  FDConnection.Params.Values['DataBase']:=OptRec.Dir_cur; // 20150922 Igor //ClientsDb;
  SQL.Clear;
  //WhereClause := ' where ' + 'ClientId = ' + '"' + Ret[RetNo]^.ClientId + '"';
  SQL.Add('Select * ');
  SQL.Add('From '+ AssetsDBLite); //Assets.db f);
  //SQL.Add( WhereClause);
  SQL.Add(' ORDER BY AssetType');
  Prepare;
  open;
 end;
 Except
 on EdataBaseError do ShowMessage('Assets Query failed');end;
end;

procedure TRepAssetsFP_2027.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Query1.Close;
end;

end.
