unit MainDM;

interface

uses Data.SqlExpr, Datasnap.Provider, Datasnap.DBClient;

type

  TClientDataSetAddOn = class
  public
    class procedure RefreshClientDataSet(DataSet: TClientDataSet; Connection: TSQLConnection; QueryText: string);
  end;

implementation

{ TClientDataSetAddOn }

uses SysUtils;

class procedure TClientDataSetAddOn.RefreshClientDataSet(
  DataSet: TClientDataSet; Connection: TSQLConnection; QueryText: string);
var
  Query: TSQLQuery;
  Provider: TDataSetProvider;
begin
  Query := TSQLQuery.Create(nil);
  Provider := TDataSetProvider.Create(nil);
  try
    DataSet.Close;
    Query.SQLConnection := Connection;
    Query.SQL.Text := QueryText;
    Provider.DataSet := Query;
    DataSet.Data := Provider.Data;
    DataSet.Open;
  finally
    FreeAndNil(Query);
    FreeAndNil(Provider);
  end;
end;

end.
