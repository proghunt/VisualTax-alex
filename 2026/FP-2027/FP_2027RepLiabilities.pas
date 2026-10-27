unit FP_2027RepLiabilities;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,QuickRpt,
  Qrctrls,ExtCtrls,Db,FP_2027Declare,FP_2027TrimStr, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef,
  uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;

type
  TRepLiabilities = class(TForm)
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
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRBand4: TQRBand;
    QRSysData2: TQRSysData;
    QRLabel7: TQRLabel;
    QRLabel9: TQRLabel;
    QRDBText1: TQRDBText;
    QRGroup1: TQRGroup;
    QRDBText4: TQRDBText;
    QRLabel13: TQRLabel;
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
  RepLiabilities: TRepLiabilities;
implementation

{$R *.DFM}

procedure TRepLiabilities.FormCreate(Sender: TObject);
begin
 OpenQuery;
 QrLabel13.Caption:= FormatDateTime('yyyy-mm-dd',Now);
 {Dt := FormatDateTime('yyyy-mm-dd',Now);}
end;

{
Function TRepAssets.Dt:String;
begin
 Result := FormatDateTime('yyyy-mm-dd',Now);
end;
}
Procedure TRepLiabilities.OpenQuery;
Var WhereClause :String;
begin
(*
 With Query1 do
 begin
  ConnectionString:=FpClientsConnectionString;
  If Active then Close;
  //Query1.DataBaseName := ClientsDb;
  SQL.Clear;
  {Build where clause}
  WhereClause := ' where '
   + 'ClientId = ' + '"' + Ret[RetNo]^.ClientId + '"';
  SQL.Add('Select * ');
  SQL.Add('from Liabilities');
  SQL.Add( WhereClause);
  SQL.Add(' ORDER BY LiabilityType');
  //Prepare;
  open;
 end;
 *)
end;
 
procedure TRepLiabilities.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Query1.Close;
end;

end.
