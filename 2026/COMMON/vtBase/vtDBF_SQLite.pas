unit vtDBF_SQLite; //20151018 Igor

interface
uses
  uADCompClient;  //20161202 Igor


function GenSqliteSchema(FullDbfName, FullSqliteName, lPsw:String): Boolean;
function PortDataToSqlite(FullDbfName, FullSqliteName, lPsw:String): Boolean;
function GenSqliteSchemaFromSqlite(FullSqliteName_from, FullSqliteName_to, TableName_from, lPsw:String): Boolean;
procedure SetODBCConnect(AConn: TADConnection; ADataBase: String); //20161202 Igor

implementation

uses Classes, SysUtils, {ADODB,} Data.SQLExpr, Data.DbxSqlite, Db, TypInfo
   , Data.DBXCommon, StrUtils, Variants, Dialogs
   {, uADCompClient}, vtDataBase, VKDBFDataSet, //20160121 Igor //20161202 Igor
   uADPhysIntf{, uADPhysODBCBase},  uADPhysODBC;
//20161202 Igor >>>

var
  FODBCDriver: String = '';

procedure GetDataSourceNames(AList: TStrings);
var
  ODBCDriver: TADPhysODBCDriverLink;
begin
  ODBCDriver := TADPhysODBCDriverLink.Create(nil);
  try
    ODBCDriver.GetDrivers(AList);
  finally
    ODBCDriver.Free;
  end;
end;

function GetODBCDriver: String;
var
  sl: TStringList;
begin
  if FODBCDriver = '' then
  begin
    SL := TStringList.Create;
    try
      GetDataSourceNames(SL);
      if SL.IndexOf('Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)') <> -1 then
        FODBCDriver := 'Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)'
      else
      if SL.IndexOf('Driver do Microsoft dBase (*.dbf)') <> -1 then
        FODBCDriver := 'Driver do Microsoft dBase (*.dbf)'
      else
        raise Exception.Create('ODBC Driver for *.dbf not found.');
    finally
      SL.Free;
    end;
  end;
  result := FODBCDriver;
end;

procedure SetODBCConnect(AConn: TADConnection; ADataBase: String);  //20161202 Igor
begin
  AConn.LoginPrompt := False;
  AConn.Params.Values['DriverID'] := 'ODBC';
  AConn.Params.Values['ODBCDriver'] := GetODBCDriver;
  if ExtractFileExt(ADataBase) <> '' then
    AConn.Params.Values['Database'] := ExtractFileDir(ADataBase)
  else
    AConn.Params.Values['Database'] := ExcludeTrailingPathDelimiter(ADataBase);
end;
//20161202 Igor <<<

function GenSqliteSchema(FullDbfName, FullSqliteName, lPsw:String): Boolean;
var FSQLiteConnection: TSQLConnection;
    TableName: string;
//    FAdoTable: TADOTable;
    i: integer;
    FField: TField;
    CreateTableExpression: string;
    Comma, Unique: string;
//    FIndexDef: TIndexDef;
    TT: TVKSmartDBF;  //20160121 Igor

    DBFConn: TADConnection;
    DBFMeta, DBFMeta2: TADMetaInfoQuery;
    Fields: String;
    ODBCDriverLink: TADPhysODBCDriverLink;
begin
  Result:=False;
  //
  if pos(UpperCase('\FOXUSER.dbf'), UpperCase(FullDbfName)) > 1 then exit;
  //
  ODBCDriverLink := TADPhysODBCDriverLink.Create(nil);
  FSQLiteConnection := TSQLConnection.Create(nil);
  DBFConn := TADConnection.Create(nil);
  DBFMeta := TADMetaInfoQuery.Create(nil);
  DBFMeta.connection := DBFConn;
  DBFMeta2 := TADMetaInfoQuery.Create(nil);
  DBFMeta2.connection := DBFConn;
//  FAdoTable := TADOTable.Create(nil);
  TT := TVKSmartDBF.Create(nil); //20160121 Igor
  try
    TableName :=  ReplaceStr(ExtractFileName(FullDbfName), ExtractFileExt(FullDbfName), '');
    //20160121 Igor
    TT.DBFFileName := FullDbfName;
    try
      TT.Open;
    except
      ShowMessage ('Error open: ' + FullDbfName);
      exit;
    end;

    FSQLiteConnection.DriverName := 'Sqlite';
    FSQLiteConnection.LoginPrompt := false;
    FSQLiteConnection.Params.Values['FailIfMissing'] := 'False';

    FSQLiteConnection.Params.Values['Database'] := FullSqliteName;
    FSQLiteConnection.Params.Values['Password'] := ''; //20160226 Igor


    try FSQLiteConnection.Open; except ShowMessage ('Error open SqliteSchema: ' + FullSqliteName);exit;end;
    CreateTableExpression := 'CREATE TABLE ' + TableName + '(';
    Comma := '';

    for FField in TT.Fields do  //20160121 Igor
    begin
      CreateTableExpression := CreateTableExpression + Comma + FField.FieldName + ' ';
      case FField.DataType of
        ftInteger, ftSmallint, ftBoolean, ftLargeInt: CreateTableExpression := CreateTableExpression + 'INTEGER'; //20160208 Igor
        ftWideString, ftString: CreateTableExpression := CreateTableExpression + 'VARCHAR(' + IntToStr(FField.Size) + ')';
        ftDate: CreateTableExpression := CreateTableExpression + 'DATE';
        ftDateTime: CreateTableExpression := CreateTableExpression + 'DATETIME';
        ftFloat: CreateTableExpression := CreateTableExpression + 'REAL';
        ftWideMemo, ftMemo, ftBlob: CreateTableExpression := CreateTableExpression + 'BLOB';  //20160820 Igor
        else raise Exception.Create('Type ' + GetEnumName(TypeInfo(TFieldType), integer(FField.DataType)) + ' is not defined');
      end;
      Comma := ',';
    end;
    CreateTableExpression := CreateTableExpression + ')';

    try FSQLiteConnection.Execute(CreateTableExpression, nil); except ShowMessage ('Error create table: ' + FullSqliteName);exit;end;
    TT.Close;
    //20161202 Igor
    SetODBCConnect(DBFConn, FullDbfName);
//    DBFConn.LoginPrompt := False;
//    DBFConn.Params.Values['DriverID'] := 'ODBC';
//    DBFConn.Params.Values['ODBCDriver'] := '{Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)}';
//    DBFConn.Params.Values['Database'] := ExtractFileDir(FullDbfName);
    DBFConn.Connected := True;
    DBFMeta.MetaInfoKind := mkIndexes;
    DBFMeta.CatalogName := ExtractFileDir(FullDbfName);
    DBFMeta.ObjectName := TableName;
    DBFMeta.Active := True;


    while Not DBFMeta.EOF do
    Begin

      DBFMeta2.MetaInfoKind := mkIndexFields;
      DBFMeta2.CatalogName := ExtractFileDir(FullDbfName);
      DBFMeta2.BaseObjectName := TableName;
      DBFMeta2.ObjectName := DBFMeta.FieldByName('INDEX_NAME').asString;
      DBFMeta2.Open;
      Fields := '';
      while Not DBFMeta2.eof do
      begin
        if Fields <> '' then
          Fields := Fields + ',';
        Fields := Fields + DBFMeta2.FieldByName('COLUMN_NAME').asString;
        DBFMeta2.Next;
      end;
      if uADPhysIntf.TADPhysIndexKind(DBFMeta.FieldByName('INDEX_TYPE').asInteger) = ikUnique then
        Unique := ' UNIQUE '
      else
        Unique := '';
      if SameText(DBFMeta.FieldByName('INDEX_NAME').asString,TableName) then
        CreateTableExpression := 'CREATE ' + Unique + 'INDEX ' +
           'IDX_'+DBFMeta.FieldByName('INDEX_NAME').asString + ' ON ' + TableName + '(' + Fields + ')'
      else
        CreateTableExpression := 'CREATE ' + Unique + 'INDEX ' +
           DBFMeta.FieldByName('INDEX_NAME').asString + ' ON ' + TableName + '(' + Fields + ')';
      try
        FSQLiteConnection.Execute(CreateTableExpression, nil);
      except
        ShowMessage ('Error create index: ' + CreateTableExpression +#10 + #13 + 'table: ' + FullSqliteName);
        exit;
      end;
      DBFMeta.Next;
    End;
     //20160121 Igor
(*    FAdoTable.ConnectionString :=
//      'Provider=MSDASQL.1;Persist Security Info=False;'+
//      'Data Source=dBASE Files;Initial Catalog=' + ExtractFilePath(FullDbfName) + ';';
    'Provider=Microsoft.Jet.OLEDB.4.0;' +
    'Data Source=' + ExtractFilePath(FullDbfName) + ';' +
    'Extended Properties="DBASE IV";';

    FAdoTable.TableName := TableName;
    try
      FAdoTable.Open;
    except
      ShowMessage ('Error open: ' + FullDbfName);
      exit;
    end;

    for  i := 0 to FAdoTable.IndexDefs.Count - 1 do
    begin
      FIndexDef := FAdoTable.IndexDefs[i];
      Unique := '';
      if ixUnique in FIndexDef.Options then
         Unique := ' UNIQUE ';
      if FIndexDef.Fields <> '' then
      Begin
        if SameText(FIndexDef.Name,TableName) then
          CreateTableExpression := 'CREATE ' + Unique + 'INDEX ' +
             'IDX_'+FIndexDef.Name + ' ON ' + TableName + '(' + FIndexDef.Fields + ')'
        else
          CreateTableExpression := 'CREATE ' + Unique + 'INDEX ' +
             FIndexDef.Name + ' ON ' + TableName + '(' + FIndexDef.Fields + ')';
        try
          FSQLiteConnection.Execute(CreateTableExpression, nil);
        except
          ShowMessage ('Error create index: ' + CreateTableExpression +#10 + #13 + 'table: ' + FullSqliteName);
          exit;
        end;
      End;
    end;
*)
  finally
//    FreeAndNil(FAdoTable);
    FreeAndNil(TT);
    FreeAndNil(FSQLiteConnection);
    FreeAndNil(DBFConn);
    FreeAndNil(DBFMeta);
    freeAndNil(ODBCDriverLink);
  end;
  Result:=True;
end;

function GenSqliteSchemaFromSqlite(FullSqliteName_from, FullSqliteName_to, TableName_from, lPsw:String): Boolean;
var FSQLiteConnection_to: TSQLConnection;
    TableName: string;
    FDConnection: TADConnection;
    ADTable: TADTable;
    i: integer;
    FField: TField;
    CreateTableExpression: string;
    Comma, Unique: string;
    FIndexDef: TIndexDef;
begin
  Result:=FileExists (FullSqliteName_to);
  if Result = TRUE then exit;

  //
  try
    FDConnection := TADConnection.Create(nil);
    ADTable := TADTable.Create(nil);
    SetTableName(FDConnection, ADTable, FullSqliteName_from, TableName_from, '');

    FSQLiteConnection_to := TSQLConnection.Create(nil);
    FSQLiteConnection_to.DriverName := 'Sqlite';
    FSQLiteConnection_to.LoginPrompt := false;
    FSQLiteConnection_to.Params.Values['FailIfMissing'] := 'False';

    FSQLiteConnection_to.Params.Values['Database'] := FullSqliteName_to;
    FSQLiteConnection_to.Params.Values['Password'] := lPsw;

    try FSQLiteConnection_to.Open; except ShowMessage ('Error open SqliteSchema: ' + FullSqliteName_to);exit;end;
    CreateTableExpression := 'CREATE TABLE ' + TableName + '(';
    Comma := '';

    for FField in ADTable.Fields do
    begin
      CreateTableExpression := CreateTableExpression + Comma + FField.FieldName + ' ';
      case FField.DataType of
        ftInteger, ftSmallint, ftBoolean: CreateTableExpression := CreateTableExpression + 'INTEGER';
        ftWideString: CreateTableExpression := CreateTableExpression + 'VARCHAR(' + IntToStr(FField.Size) + ')';
        ftDate: CreateTableExpression := CreateTableExpression + 'DATE';
        ftDateTime: CreateTableExpression := CreateTableExpression + 'DATETIME';
        ftFloat: CreateTableExpression := CreateTableExpression + 'REAL';
        ftWideMemo: CreateTableExpression := CreateTableExpression + 'BLOB';
        else raise Exception.Create('Type ' + GetEnumName(TypeInfo(TFieldType), integer(FField.DataType)) + ' is not defined');
      end;
      Comma := ',';
    end;
    CreateTableExpression := CreateTableExpression + ')';

    try FSQLiteConnection_to.Execute(CreateTableExpression, nil); except ShowMessage ('Error create table: ' + FullSqliteName_to);exit;end;

    for  i := 0 to ADTable.IndexDefs.Count - 1 do
    begin
      FIndexDef := ADTable.IndexDefs[i];
      Unique := '';
      if ixUnique in FIndexDef.Options then
         Unique := ' UNIQUE ';
      CreateTableExpression := 'CREATE ' + Unique + 'INDEX ' +
         FIndexDef.Name + ' ON ' + TableName + '(' + FIndexDef.Fields + ')';
      try FSQLiteConnection_to.Execute(CreateTableExpression, nil); except ShowMessage ('Error create index: ' + CreateTableExpression +#10 + #13 + 'table: ' + FullSqliteName_to);exit;end;
    end;
  finally
    FreeAndNil(FDConnection);
    FreeAndNil(ADTable);
    FreeAndNil(FSQLiteConnection_to);
  end;
  Result:=True;
end;


function PortDataToSqlite(FullDbfName, FullSqliteName, lPsw:String): Boolean;
var //FDBFADOConnection: TADOConnection;
    FSQLiteConnection: TSQLConnection;
    FTableNames: TStrings;
    TableName: string;
    //FAdoTable: TADOTable;
    TT: TVKSmartDBF; //20160121 Igor
    FField: TField;
    AddRecordExpression, ValuesExpression: string;
    Comma: string;
    Transaction: TDBXSqliteTransaction;
    FLocalParams: TParams;
begin
  Result:=False;
  //
  FSQLiteConnection := TSQLConnection.Create(nil);
  //FAdoTable := TADOTable.Create(nil);
  TT:= TVKSmartDBF.Create(nil);//20160121 Igor
  FLocalParams := TParams.Create(nil);
  try
//    FAdoTable.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
//                     'Data Source=' + ExtractFilePath(FullDbfName) + ';' +
//                     'Extended Properties="DBASE IV";';

    TableName :=  ReplaceStr(ExtractFileName(FullDbfName), ExtractFileExt(FullDbfName), '');
    //FAdoTable.TableName := TableName;
    TT.DBFFileName := FullDbfName; //20160121 Igor
    //try {FAdoTable.Open;}
    TT.Open; //20160121 Igor
    //except ShowMessage ('Error open: ' + FullDbfName);exit;end;

    FSQLiteConnection.DriverName := 'Sqlite';
    FSQLiteConnection.LoginPrompt := false;
    FSQLiteConnection.Params.Values['FailIfMissing'] := 'False';

    FSQLiteConnection.Params.Values['Database'] := FullSqliteName;
    FSQLiteConnection.Params.Values['Password'] := ''; //20160226 Igor
    try FSQLiteConnection.Connected := True; except ShowMessage ('Error open Sqlite: ' + FullSqliteName);exit;end;
    Comma := '';

    Transaction := FSQLiteConnection.BeginTransaction as TDBXSqliteTransaction;
    while not {FAdoTable.EOF} TT.EOF do begin //20160121 Igor
      if not TT.Deleted then //20160121 Igor
      Begin
        FLocalParams.Clear;
        AddRecordExpression := 'INSERT INTO ' + TableName + '(';
        ValuesExpression := ' VALUES(';
        Comma := '';
        for FField in {FAdoTable.Fields} TT.Fields do begin //20160121 Igor
          AddRecordExpression := AddRecordExpression + Comma + FField.FieldName;
          ValuesExpression := ValuesExpression + Comma;
          Comma := ',';
          if VarIsNull(FField.Value) then
             ValuesExpression := ValuesExpression + 'NULL'
          else
            case FField.DataType of
              // convert to ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS").
              ftDateTime: ValuesExpression := ValuesExpression + chr(39) + FormatDateTime('YYYY-MM-DD HH:MM:SS.SSS', FField.AsDateTime) + chr(39);
              ftDate: ValuesExpression := ValuesExpression + chr(39) + FormatDateTime('YYYY-MM-DD', FField.AsDateTime) + chr(39); //20160820 Igor
              ftBoolean: ValuesExpression := ValuesExpression + IntToStr(integer(FField.asBoolean));
              ftInteger, ftSmallint, ftLargeInt: ValuesExpression := ValuesExpression + IntToStr(FField.asInteger); //20160208 Igor
              ftWideString, ftString: ValuesExpression :=
                 ValuesExpression + chr(39) + ReplaceStr(FField.AsString, '''', '''''') + chr(39);
              ftFloat: ValuesExpression := ValuesExpression + ReplaceStr(FloatToStr(FField.asFloat), FormatSettings.DecimalSeparator, '.');
              ftWideMemo, ftMemo, ftBlob: begin  //20160820 Igor
                            ValuesExpression := ValuesExpression + ' :' + FField.FieldName;
                            FLocalParams.CreateParam(ftBlob, FField.FieldName, ptInput).Value := FField.Value;
                          end
              else raise Exception.Create('Type ' + GetEnumName(TypeInfo(TFieldType), integer(FField.DataType)) + ' is not defined');
            end;
        end;
        AddRecordExpression := AddRecordExpression + ') ' + ValuesExpression + ')';
        try FSQLiteConnection.Execute(AddRecordExpression, FLocalParams); except ShowMessage ('Error add record: ' + AddRecordExpression +#10 + #13 + 'table: ' + FullSqliteName);exit;end;
        //FAdoTable.Next;
      end;
      TT.Next;  //20160121 Igor
    end;
    FSQLiteConnection.CommitFreeAndNil(TDBXTransaction(Transaction));
    TT.Close; //20160121 Igor
  finally
    FreeAndNil(FLocalParams);
    //FreeAndNil(FAdoTable);
    FreeAndNil(TT); //20160121 Igor
    FreeAndNil(FSQLiteConnection);
    //FreeAndNil(FDBFADOConnection);
  end;
  Result:=True;
end;

end.