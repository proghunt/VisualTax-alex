unit T1_2026invoicerep;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
     Db, ekfunc, ekbasereport, ekrtf, Vcl.StdCtrls, Vcl.ComCtrls,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient,
  vtRichmemobox, //20170209 igor

  RxRichEd; //20160819 Igor (It must be the last)

type
  TInvoiceRepT1_2026 = class(TForm)
    DataSource1: TDataSource;
    RichEdit1: TvtRichMemo; //20170209 igor
    EkRTF1: TEkRTF;
    FDConnection: TADConnection;
    Query1: TADQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure OpenQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ReportOpen;
  end;

var
  InvoiceRep: TInvoiceRepT1_2026;

implementation

{$R *.DFM}

uses T1_2026,T1_2026trimStr,T1_2026Declare,vtTrimStr,vtShared, vtDataBase;

procedure TInvoiceRepT1_2026.FormCreate(Sender: TObject);
begin
 {PrintDate.Caption:=FormatDateTime('yyyy-mm-dd',Date);}
 //20150727 QrLabel6.Caption:= ReportInvoiceDate;

 OpenQuery;
end;

Procedure TInvoiceRepT1_2026.OpenQuery;
Var
  WhereClause: String;
  CurrDt: string;
begin
  //20170224 Igor >>>
  SqlLoadDBFromFile(FDConnection, Query1, OptRec.Dir_Cur +'\'+ ClientsDBLite, '');
  Query1.Open('Select * from ' + ClientsTableLite + #13#10 +
              'where' + #13#10 +
                'Updated_Dt >= ' + '"' + ReportInvoiceDateStart + '" AND ' + #13#10 +    //20180501 start
                'Updated_Dt <= ' + '"' + ReportInvoiceDateEnd + '" AND ' + #13#10 +       //20180501 start
                'Inv_Amount > 0' + #13#10 +
              'Order By Last_Name');
  Query1.FetchAll;
  //20170224 Igor <<<
end;

procedure TInvoiceRepT1_2026.ReportOpen; //20150806 Igor
var AStream: TMemoryStream;
begin
  EkRTF1.InFile:=AppDir+'\InvoiceReport.rtf';
  EkRTF1.ClearVars;
        AStream:=TMemoryStream.Create;
      Try
       EkRTF1.ExecuteStream([Query1],AStream);
       RichEdit1.Lines.LoadFromStream(AStream);
      finally //on e: Exception do ExceptMsg(e);
        AStream.Free;
      end;


  //EkRtf1.ExecuteStream([Query1],SW_SHOW);
end;



procedure TInvoiceRepT1_2026.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 If Query1.Active then Query1.Close;
end;

end.
