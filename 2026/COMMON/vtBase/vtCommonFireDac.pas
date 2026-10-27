unit vtCommonFireDac;

interface

function DeleteReturn(Dir, FlName: string): Boolean;

implementation

uses FireDac.Comp.Client, vtDataBase; // 20150821 igor

function DeleteReturn(Dir, FlName: string): Boolean;
var
  //20150821 igor
  FDConnection: TFDConnection;
  Table: TFDTable;
begin
  Result := False;
  if FileExists(Dir + '\' + FlName) then
    SysUtils.DeleteFile(Dir + '\' + FlName);
  //20160226 Igor >>>>>
  if not SetTableName(FDConnection, Table, Dir + '\' + ClientsLite,
     ClientsTableLite, 'File_Name') then
  Begin
    if assigned(FDConnection) then
      freeAndNil(FDConnection);
    if assigned(Table1) then
      freeAndNil(Table1);
    result := False;
    exit;
  End;

//  FDConnection := TFDConnection.Create(nil);
//  FDConnection.DriverName := 'SQLite';
//  Table := TFDTable.Create(nil);
//  Table.Connection := FDConnection;
  try
//    FDConnection.Params.Values['DataBase'] := Dir + '\' + ClientsLite;
//    Table.TableName := ClientsTableLite;
//    Table.IndexName := 'File_Name';
//    Table.Open;
//20160226 Igor <<<<<<
    if Table.FindKey([FlName]) = True then
    begin
      Table.Delete;
      Result := True;
    end;
  finally
    FreeAndNil(FDConnection);
    FreeAndNil(Table);
  end;
end;

end.
