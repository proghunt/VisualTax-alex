unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADStanAsync, uADDAptManager, DB, uADCompDataSet, uADCompClient,
  StdCtrls, Grids, DBGrids, uADCompGUIx, uADGUIxFormsWait, uADPhysIB,
  uADCompVSE, uADCompVSEXML;

type
  TForm1 = class(TForm)
    ADConnection1: TADConnection;
    ADQuery1: TADQuery;
    ADPhysIBDriverLink1: TADPhysIBDriverLink;
    ADGUIxWaitCursor1: TADGUIxWaitCursor;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FVS: TADVSEXMLManager;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

(*
<Transaction>
  <Request>
     <OrderNumber>123456</OrderNumber>
     <ShippingMethod>123456</ShippingMethod>
  </Request>
  <Response>
     <StatusCode>200</StatusCode>
     <StatusMesg>Order accepted</StatusMesg>
     <RefNumber>S0123456</RefNumber>
  </Response>
</Transaction>
*)

procedure TForm1.FormCreate(Sender: TObject);
var
  oSch: TADVSESchema;
begin
  FVS := TADVSEXMLManager.Create(nil);
  FVS.AutoManage := True;

  oSch := FVS.Schemas.Add;
  oSch.Name := 'Request';
  with TADVSEXMLFieldDef(oSch.FieldDefs.Add) do begin
    Name := 'OrderNumber';
    DataType := dtInt32;
    XPathExpression := '//Transaction/Request/OrderNumber';
  end;
  with TADVSEXMLFieldDef(oSch.FieldDefs.Add) do begin
    Name := 'ShippingMethod';
    DataType := dtInt32;
    XPathExpression := '//Transaction/Request/ShippingMethod';
  end;

  oSch := FVS.Schemas.Add;
  oSch.Name := 'Response';
  with TADVSEXMLFieldDef(oSch.FieldDefs.Add) do begin
    Name := 'StatusCode';
    DataType := dtInt32;
    XPathExpression := '//Transaction/Response/StatusCode';
  end;
  with TADVSEXMLFieldDef(oSch.FieldDefs.Add) do begin
    Name := 'StatusMesg';
    DataType := dtAnsiString;
    Size := 50;
    XPathExpression := '//Transaction/Response/StatusMesg';
  end;
  with TADVSEXMLFieldDef(oSch.FieldDefs.Add) do begin
    Name := 'RefNumber';
    DataType := dtAnsiString;
    Size := 20;
    XPathExpression := '//Transaction/Response/RefNumber';
  end;

  FVS.Sessions.AddSession(ADQuery1, 'VS');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FVS.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ADQuery1.Active := not ADQuery1.Active;
end;

end.
