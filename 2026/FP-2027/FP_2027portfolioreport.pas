unit FP_2027portfolioreport;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  QuickRpt,Db,Qrctrls,FP_2027trimStr,FP_2027Declare;

type
  TPortfolioReport = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRBand2: TQRBand;
    QRBand3: TQRBand;
    QRBand4: TQRBand;
    QRLabel2: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRLabel3: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel4: TQRLabel;
    QRDBText3: TQRDBText;
    DateLbl: TQRLabel;
    ClNameLbl: TQRLabel;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRLabel6: TQRLabel;
    QRLabel8: TQRLabel;
    QRShape1: TQRShape;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRLabel21: TQRLabel;
    QRLabel22: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRLabel26: TQRLabel;
    QRLabel27: TQRLabel;
    QRShape2: TQRShape;
    QRLabel9: TQRLabel;
    BusName: TQRLabel;
    TotalBand: TQRBand;
    QRGroup1: TQRGroup;
    QRDBText14: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText12: TQRDBText;
    QRExpr1: TQRExpr;
    QRExpr3: TQRExpr;
    QRExpr4: TQRExpr;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    YearsLbl: TQRLabel;
    QRExpr2: TQRExpr;
 (*
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   { procedure OpenQueries;}
    procedure CloseQueries;
    procedure QRBand2BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure OpenPortfoliosQ;
    procedure OpenPortfolioDetailsQ;
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PortfolioReport: TPortfolioReport;

implementation

{$R *.DFM}

(*
procedure TPortfolioReport.FormCreate(Sender: TObject);
begin
 ClNameLbl.Caption := ClientIdName;
 BusName.Caption :=HoRec.BusinessName;
 DateLbl.Caption:= FormatDateTime('yyyy-mm-dd',Now);
 OpenPortfolioDetailsQ;
 {OpenQueries;}
end;

procedure TPortfolioReport.OpenPortfoliosQ;
Var WhereClause:String;
begin
 Try
 PortfoliosQ.ConnectionString:=FpClientsConnectionString;
 //PortfoliosQ.DataBaseName:=ClientsDb;
 WhereClause:='';
 PortfoliosQ.Close;
 PortfoliosQ.SQL.Clear;
 WhereClause := ' where ' + 'ClientId = ' + '"' + Client + '"'
 +  'and ' + 'PortfolioName = ' + '"' + PortfolioDetailsQ['PortfolioName'] + '"';
 With PortfoliosQ do
 begin
  SQL.Add('Select * from Portfolios');
  SQL.Add( WhereClause);
  SQL.Add(' ORDER BY PortfolioName');
  //Prepare;
  open;
 end;
 Except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;

procedure TPortfolioReport.OpenPortfolioDetailsQ;
Var WhereClause:String;
begin
 WhereClause:='';
 Try
 PortfolioDetailsQ.ConnectionString:=FpClientsConnectionString;
 //PortfolioDetailsQ.DataBaseName:=ClientsDb;
 PortfolioDetailsQ.Close;
 PortfolioDetailsQ.SQL.Clear;
 WhereClause := ' where ' + 'ClientId = ' + '"' + Client + '"'
 +  'and ' + 'PortfolioName = ' + '"' + PortfolioNameToChart + '"';
 With PortfolioDetailsQ do
 begin
  SQL.Add('Select * from PortfolioDetails');
  SQL.Add( WhereClause);
  SQL.Add(' ORDER BY PortfolioName');
  //Prepare;
  open;
 end;
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;

procedure TPortfolioReport.CloseQueries;
begin
 If PortfoliosQ.Active then PortfoliosQ.Close;
 If PortfolioDetailsQ.Active then PortfolioDetailsQ.Close;
end;


procedure TPortfolioReport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CloseQueries;
end;

procedure TPortfolioReport.QRBand2BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
 OpenPortfoliosQ;
 YearsLbl.Caption := IntToStr(PortfoliosQ['Years']);
 {
 If PortfoliosQ.FindKey([PortfolioDetailsQ['PortfolioName']]) then
  YearsLbl.Caption := IntToStr(PortfolioQ['Years'])
 else
  YearsLbl.Caption := '??';
 } 
end;
*)
end.
