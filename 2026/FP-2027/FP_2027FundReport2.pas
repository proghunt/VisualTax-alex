unit FP_2027FundReport2;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  QuickRpt,Db,Qrctrls,FP_2027trimStr,FP_2027Declare, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TFundReport2 = class(TForm)
    QuickRep1: TQuickRep;
    QRBand1: TQRBand;
    DateLbl: TQRLabel;
    QRBand2: TQRBand;
    QRLabel4: TQRLabel;
    QRBand3: TQRBand;
    QRDBText3: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText10: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText15: TQRDBText;
    QRDBText16: TQRDBText;
    QRDBText18: TQRDBText;
    QRDBText19: TQRDBText;
    QRDBText20: TQRDBText;
    QRDBText21: TQRDBText;
    QRDBText22: TQRDBText;
    QRDBText27: TQRDBText;
    QRDBText29: TQRDBText;
    QRDBText28: TQRDBText;
    QRDBText23: TQRDBText;
    QRDBText24: TQRDBText;
    QRDBText25: TQRDBText;
    QRDBText33: TQRDBText;
    QRLabel3: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel11: TQRLabel;
    QRShape1: TQRShape;
    QRLabel7: TQRLabel;
    QRDBText6: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText32: TQRDBText;
    QRDBText34: TQRDBText;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRDBText35: TQRDBText;
    QRDBText36: TQRDBText;
    QRDBText37: TQRDBText;
    QRDBText38: TQRDBText;
    QRDBText39: TQRDBText;
    QRDBText40: TQRDBText;
    QRLabel17: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    QRShape2: TQRShape;
    QRLabel21: TQRLabel;
    QRLabel22: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRLabel25: TQRLabel;
    QRLabel26: TQRLabel;
    QRDBText41: TQRDBText;
    QRDBText42: TQRDBText;
    QRDBText43: TQRDBText;
    QRLabel28: TQRLabel;
    QRLabel29: TQRLabel;
    QRLabel30: TQRLabel;
    QRLabel31: TQRLabel;
    QRDBText31: TQRDBText;
    QRDBText44: TQRDBText;
    QRLabel32: TQRLabel;
    QRLabel33: TQRLabel;
    QRDBText30: TQRDBText;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRLabel34: TQRLabel;
    QRDBText46: TQRDBText;
    QRDBText47: TQRDBText;
    QRDBText48: TQRDBText;
    QRDBText49: TQRDBText;
    QRDBText50: TQRDBText;
    QRDBText51: TQRDBText;
    QRDBText52: TQRDBText;
    QRDBText53: TQRDBText;
    QRDBText56: TQRDBText;
    QRDBText57: TQRDBText;
    QRDBText58: TQRDBText;
    QRDBText59: TQRDBText;
    QRLabel35: TQRLabel;
    QRLabel36: TQRLabel;
    QRLabel38: TQRLabel;
    QRLabel39: TQRLabel;
    QRLabel41: TQRLabel;
    QRLabel42: TQRLabel;
    QRLabel43: TQRLabel;
    QRLabel45: TQRLabel;
    QRLabel47: TQRLabel;
    QRLabel48: TQRLabel;
    QRDBText60: TQRDBText;
    QRLabel52: TQRLabel;
    QRLabel53: TQRLabel;
    QRLabel54: TQRLabel;
    QRLabel55: TQRLabel;
    QRLabel56: TQRLabel;
    QRLabel57: TQRLabel;
    QRLabel58: TQRLabel;
    QRDBText61: TQRDBText;
    QRDBText62: TQRDBText;
    QRDBText63: TQRDBText;
    QRLabel59: TQRLabel;
    QRLabel60: TQRLabel;
    QRLabel61: TQRLabel;
    QRShape6: TQRShape;
    QRDBText64: TQRDBText;
    QRLabel62: TQRLabel;
    QRDBText65: TQRDBText;
    QRLabel40: TQRLabel;
    QRDBText12: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText4: TQRDBText;
    QRLabel44: TQRLabel;
    QRLabel51: TQRLabel;
    QRLabel63: TQRLabel;
    QRShape7: TQRShape;
    QRDBText66: TQRDBText;
    QRDBText67: TQRDBText;
    QRLabel65: TQRLabel;
    QRDBRichText2: TQRDBRichText;
    QRShape9: TQRShape;
    QRLabel1: TQRLabel;
    Holding1: TQRLabel;
    Holding2: TQRLabel;
    Holding3: TQRLabel;
    Holding4: TQRLabel;
    Holding5: TQRLabel;
    Holding6: TQRLabel;
    Holding7: TQRLabel;
    Holding8: TQRLabel;
    Holding9: TQRLabel;
    Holding0: TQRLabel;
    QRShape8: TQRShape;
    Percent1: TQRLabel;
    Percent2: TQRLabel;
    Percent3: TQRLabel;
    Percent4: TQRLabel;
    Percent5: TQRLabel;
    Percent6: TQRLabel;
    Percent7: TQRLabel;
    Percent8: TQRLabel;
    Percent9: TQRLabel;
    Percent0: TQRLabel;
    QRLabel27: TQRLabel;
    QRDBText11: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText26: TQRDBText;
    QRDBText45: TQRDBText;
    QRDBText54: TQRDBText;
    QRDBText55: TQRDBText;
    QRDBText68: TQRDBText;
    QRDBText69: TQRDBText;
    QRDBText70: TQRDBText;
    QRDBText71: TQRDBText;
    QRDBText72: TQRDBText;
    QRLabel37: TQRLabel;
    QRLabel46: TQRLabel;
    QRLabel49: TQRLabel;
    QRLabel50: TQRLabel;
    QRLabel64: TQRLabel;
    QRLabel66: TQRLabel;
    QRLabel67: TQRLabel;
    QRLabel68: TQRLabel;
    QRLabel69: TQRLabel;
    QRLabel70: TQRLabel;
    QRLabel71: TQRLabel;
    QRLabel72: TQRLabel;
    QRLabel73: TQRLabel;
    QRDBText73: TQRDBText;
    QRLabel74: TQRLabel;
    QRShape11: TQRShape;
    QRLabel75: TQRLabel;
    QRDBText74: TQRDBText;
    QRShape10: TQRShape;
    QRLabel76: TQRLabel;
    BusName: TQRLabel;
    FDConnection: TADConnection;
    FundInfoQ: TADQuery;
    PerformanceQ: TADQuery;
    FeesExpensesQ: TADQuery;
    MPTQ: TADQuery;
    PricingInfoQ: TADQuery;
    AllocationsQ: TADQuery;
(*
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure OpenQueries;
    Procedure CloseQueries;
    Procedure LoadHoldings;
  *)  
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FundReport2: TFundReport2;

implementation

{$R *.DFM}

(*
procedure TFundReport2.FormCreate(Sender: TObject);
begin
  DateLbl.Caption:=PricesAsOfDate;
  BusName.Caption :=HoRec.BusinessName;
  {DateLbl.Caption:= FormatDateTime('yyyy-mm-dd',Now);}
  OpenQueries;
  LoadHoldings;
end;

Procedure TFundReport2.LoadHoldings;
Var aList:TStringList;k:Integer;
begin
  Holding0.Caption := '';
  Holding1.Caption := '';
  Holding2.Caption := '';
  Holding3.Caption := '';
  Holding4.Caption := '';
  Holding5.Caption := '';
  Holding6.Caption := '';
  Holding7.Caption := '';
  Holding8.Caption := '';
  Holding9.Caption := '';

  Percent0.Caption := '';
  Percent1.Caption := '';
  Percent2.Caption := '';
  Percent3.Caption := '';
  Percent4.Caption := '';
  Percent5.Caption := '';
  Percent6.Caption := '';
  Percent7.Caption := '';
  Percent8.Caption := '';
  Percent9.Caption := '';

  AList := TstringList.Create;
  GetTopTenHoldings(FundToChart,AList);
  k:=AList.Count-1;
  if k>=0 then Holding0.Caption := LeftStr(Alist[0],50);
  if k>=1 then Holding1.Caption := LeftStr(Alist[1],50);
  if k>=2 then Holding2.Caption := LeftStr(Alist[2],50);
  if k>=3 then Holding3.Caption := LeftStr(Alist[3],50);
  if k>=4 then Holding4.Caption := LeftStr(Alist[4],50);
  if k>=5 then Holding5.Caption := LeftStr(Alist[5],50);
  if k>=6 then Holding6.Caption := LeftStr(Alist[6],50);
  if k>=7 then Holding7.Caption := LeftStr(Alist[7],50);
  if k>=8 then Holding8.Caption := LeftStr(Alist[8],50);
  if k>=9 then Holding9.Caption := LeftStr(Alist[9],50);

  if k>=0 then Percent0.Caption := MidStr(Alist[0],50,9);
  if k>=1 then Percent1.Caption := MidStr(Alist[1],50,9);
  if k>=2 then Percent2.Caption := MidStr(Alist[2],50,9);
  if k>=3 then Percent3.Caption := MidStr(Alist[3],50,9);
  if k>=4 then Percent4.Caption := MidStr(Alist[4],50,9);
  if k>=5 then Percent5.Caption := MidStr(Alist[5],50,9);
  if k>=6 then Percent6.Caption := MidStr(Alist[6],50,9);
  if k>=7 then Percent7.Caption := MidStr(Alist[7],50,9);
  if k>=8 then Percent8.Caption := MidStr(Alist[8],50,9);
  if k>=9 then Percent9.Caption := MidStr(Alist[9],50,9);

  AList.Free;

end;

Procedure TFundReport2.OpenQueries;
Var WhereClause:String;
begin

 FundInfoQ.Close;
 FundInfoQ.SQL.Clear;
 WhereClause := ' where ' + 'FundId = ' + '"' + FundToChart + '"';
 With FundInfoQ do
 begin
 SQL.Add('Select * from FundInfo');
 SQL.Add( WhereClause);
 Prepare;
 open;
 end;

 FeesExpensesQ.Close;
 FeesExpensesQ.SQL.Clear;
 WhereClause := ' where ' + 'FundId = ' + '"' + FundToChart + '"';
 With FeesExpensesQ do
 begin
 SQL.Add('Select * from FeesExpenses');
 SQL.Add( WhereClause);
 Prepare;
 open;
 end;

 MptQ.Close; MptQ.SQL.Clear;
 WhereClause := ' where ' + 'FundId = ' + '"' + FundToChart + '"';
 With MptQ do
 begin
 SQL.Add('Select * from MPT');
 SQL.Add( WhereClause);
 Prepare;
 open;
 end;

 PricingInfoQ.Close; PricingInfoQ.SQL.Clear;
 WhereClause := ' where ' + 'FundId = ' + '"' + FundToChart + '"';
 With PricingInfoQ do
 begin
 SQL.Add('Select * from PricingInfo');
 SQL.Add( WhereClause);
 Prepare;
 open;
 end;

 PerformanceQ.Close; PerformanceQ.SQL.Clear;
 WhereClause := ' where ' + 'FundId = ' + '"' + FundToChart + '"';
 With PerformanceQ do
 begin
  SQL.Add('Select * from Performance');
  SQL.Add( WhereClause);
  Prepare;
  open;
 end;

 AllocationsQ.Close; AllocationsQ.SQL.Clear;
 WhereClause := ' where ' + 'FundId = ' + '"' + FundToChart + '"';
 With AllocationsQ do
 begin
  SQL.Add('Select * from Allocations');
  SQL.Add( WhereClause);
  Prepare;
  open;
 end;

end;

Procedure TFundReport2.CloseQueries;
begin
 {TopTenHoldingsQ.Close;}
 FundInfoQ.Close;
 PerformanceQ.Close;
 FeesExpensesQ.Close;
 MPTQ.Close;
 PricingInfoQ.Close;
 AllocationsQ.Close;
end;

procedure TFundReport2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CloseQueries;
end;
*)
end.
