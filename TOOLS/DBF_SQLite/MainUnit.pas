unit MainUnit;

interface

function GenSqliteSchemaAllTables(DbfDirectory, SqliteDirectory: String): Boolean;
function PortDataToSqliteAllTables(DbfDirectory, SqliteDirectory:String): Boolean;

function GenSqliteSchema(FullDbfName, FullSqliteName:String; AddRowId: Boolean): Boolean; //20220622 Igor
function PortDataToSqlite(FullDbfName, FullSqliteName:String): Boolean;

implementation

uses Classes, SysUtils, ADODB, Data.SQLExpr, Data.DbxSqlite, Db, TypInfo
   , Data.DBXCommon, StrUtils, Variants,
   VKDBFDataSet, Dialogs;

(*function GenSqliteSchema(FullDbfName, FullSqliteName:String): Boolean;
var FSQLiteConnection: TSQLConnection;
    TableName: string;
    FAdoTable: TADOTable;
    i: integer;
    FField: TField;
    CreateTableExpression: string;
    Comma, Unique: string;
    FIndexDef: TIndexDef;
begin
  FSQLiteConnection := TSQLConnection.Create(nil);
  FAdoTable := TADOTable.Create(nil);
  try
    FAdoTable.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                     'Data Source=' + ExtractFilePath(FullDbfName) + ';' +
                     'Extended Properties="DBASE IV";';

    TableName :=  ReplaceStr(ExtractFileName(FullDbfName), ExtractFileExt(FullDbfName), '');
    FAdoTable.TableName := TableName;
    FAdoTable.Open;
    FSQLiteConnection.DriverName := 'Sqlite';
    FSQLiteConnection.LoginPrompt := false;
    FSQLiteConnection.Params.Values['FailIfMissing'] := 'False';

    FSQLiteConnection.Params.Values['Database'] := FullSqliteName;
    FSQLiteConnection.Open;
    CreateTableExpression := 'CREATE TABLE ' + TableName + '(';
    Comma := '';

    for FField in FAdoTable.Fields do
    begin
      CreateTableExpression := CreateTableExpression + Comma + FField.FieldName + ' ';
      case FField.DataType of
        ftInteger, ftSmallint, ftBoolean: CreateTableExpression := CreateTableExpression + 'INTEGER';
        ftWideString, ftDateTime: CreateTableExpression := CreateTableExpression + 'TEXT';
        ftFloat: CreateTableExpression := CreateTableExpression + 'REAL';
        ftWideMemo: CreateTableExpression := CreateTableExpression + 'BLOB';
        else raise Exception.Create('Type ' + GetEnumName(TypeInfo(TDataType), integer(FField.DataType)) + ' is not defined');
      end;
      Comma := ',';
    end;
    CreateTableExpression := CreateTableExpression + ')';
    FSQLiteConnection.Execute(CreateTableExpression, nil);

    for  i := 0 to FAdoTable.IndexDefs.Count - 1 do
    begin
      FIndexDef := FAdoTable.IndexDefs[i];
      Unique := '';
      if ixUnique in FIndexDef.Options then
         Unique := ' UNIQUE ';
      CreateTableExpression := 'CREATE ' + Unique + 'INDEX ' +
         TableName +'_' + FIndexDef.Name + ' ON ' + TableName + '(' + FIndexDef.Fields + ')';
      FSQLiteConnection.Execute(CreateTableExpression, nil);
    end;
  finally
    FreeAndNil(FAdoTable);
    FreeAndNil(FSQLiteConnection);
  end;
end;*)
function GenSqliteSchema(FullDbfName, FullSqliteName: String; AddRowId: Boolean): Boolean; //20220622 Igor
var FSQLiteConnection: TSQLConnection;
    TableName: string;
    FAdoTable: TADOTable;
    i: integer;
    FField: TField;
    CreateTableExpression: string;
    Comma, Unique: string;
    FIndexDef: TIndexDef;
    TT: TVKSmartDBF;  //20160121 Igor
begin
  Result:=False;
  //
  if pos(UpperCase('\FOXUSER.dbf'), UpperCase(FullDbfName)) > 1 then exit;
  //
  FSQLiteConnection := TSQLConnection.Create(nil);
  FAdoTable := TADOTable.Create(nil);
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

    //20220622 Igor >>>
    if AddRowId then
    begin
      CreateTableExpression := CreateTableExpression + ' RowId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL';
      Comma := ',';
    end;
    //20220622 Igor <<<

    for FField in TT.Fields do  //20160121 Igor
    begin
      CreateTableExpression := CreateTableExpression + Comma + FField.FieldName + ' ';
      case FField.DataType of
        ftInteger, ftSmallint, ftBoolean, ftLargeInt: CreateTableExpression := CreateTableExpression + 'INTEGER'; //20160208 Igor
        ftWideString, ftString: CreateTableExpression := CreateTableExpression + 'VARCHAR(' + IntToStr(FField.Size) + ')';
        ftDate: CreateTableExpression := CreateTableExpression + 'DATE';
        ftDateTime: CreateTableExpression := CreateTableExpression + 'DATETIME';
        ftFloat: CreateTableExpression := CreateTableExpression + 'REAL';
        ftWideMemo, ftMemo, ftBlob: CreateTableExpression := CreateTableExpression + 'BLOB';
        else raise Exception.Create('Type ' + GetEnumName(TypeInfo(TDataType), integer(FField.DataType)) + ' is not defined');
      end;
      Comma := ',';
    end;
    CreateTableExpression := CreateTableExpression + ')';

    try FSQLiteConnection.Execute(CreateTableExpression, nil); except ShowMessage ('Error create table: ' + FullSqliteName);exit;end;
    TT.Close;
     //20160121 Igor
    FAdoTable.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
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
  finally
    FreeAndNil(FAdoTable);
    FreeAndNil(TT);
    FreeAndNil(FSQLiteConnection);
  end;
  Result:=True;
end;
(*
function PortDataToSqlite(FullDbfName, FullSqliteName:String): Boolean;
var FDBFADOConnection: TADOConnection;
    FSQLiteConnection: TSQLConnection;
    FTableNames: TStrings;
    TableName: string;
    FAdoTable: TADOTable;
    FField: TField;
    AddRecordExpression, ValuesExpression: string;
    Comma: string;
    Transaction: TDBXSqliteTransaction;
    FLocalParams: TParams;
begin
  FSQLiteConnection := TSQLConnection.Create(nil);
  FAdoTable := TADOTable.Create(nil);
  FLocalParams := TParams.Create(nil);
  try
    FAdoTable.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                     'Data Source=' + ExtractFilePath(FullDbfName) + ';' +
                     'Extended Properties="DBASE IV";';

    TableName :=  ReplaceStr(ExtractFileName(FullDbfName), ExtractFileExt(FullDbfName), '');
    FAdoTable.TableName := TableName;
    FAdoTable.Open;
    FSQLiteConnection.DriverName := 'Sqlite';
    FSQLiteConnection.LoginPrompt := false;
    FSQLiteConnection.Params.Values['FailIfMissing'] := 'False';

    FSQLiteConnection.Params.Values['Database'] := FullSqliteName;
    FSQLiteConnection.Open;
    Comma := '';

    Transaction := FSQLiteConnection.BeginTransaction as TDBXSqliteTransaction;
    while not FAdoTable.EOF do begin
      FLocalParams.Clear;
      AddRecordExpression := 'INSERT INTO ' + TableName + '(';
      ValuesExpression := ' VALUES(';
      Comma := '';
      for FField in FAdoTable.Fields do begin
        AddRecordExpression := AddRecordExpression + Comma + FField.FieldName;
        ValuesExpression := ValuesExpression + Comma;
        Comma := ',';
        if VarIsNull(FField.Value) then
           ValuesExpression := ValuesExpression + 'NULL'
        else
          case FField.DataType of
            // convert to ISO8601 strings ("YYYY-MM-DD HH:MM:SS.SSS").
            ftDateTime: ValuesExpression := ValuesExpression + chr(39) + FormatDateTime('YYYY-MM-DD HH:MM:SS.SSS', FField.AsDateTime) + chr(39);
            ftBoolean: ValuesExpression := ValuesExpression + IntToStr(integer(FField.asBoolean));
            ftInteger, ftSmallint: ValuesExpression := ValuesExpression + IntToStr(FField.asInteger);
            ftWideString: ValuesExpression :=
               ValuesExpression + chr(39) + ReplaceStr(FField.AsString, '''', '''''') + chr(39);
            ftFloat: ValuesExpression := ValuesExpression + ReplaceStr(FloatToStr(FField.asFloat), FormatSettings.DecimalSeparator, '.');
            ftWideMemo: begin
                          ValuesExpression := ValuesExpression + ' :' + FField.FieldName;
                          FLocalParams.CreateParam(ftBlob, FField.FieldName, ptInput).Value := FField.Value;
                        end
            else raise Exception.Create('Type ' + GetEnumName(TypeInfo(TDataType), integer(FField.DataType)) + ' is not defined');
          end;
      end;
      AddRecordExpression := AddRecordExpression + ') ' + ValuesExpression + ')';
      FSQLiteConnection.Execute(AddRecordExpression, FLocalParams);
      FAdoTable.Next;
    end;
    FSQLiteConnection.CommitFreeAndNil(TDBXTransaction(Transaction));
  finally
    FreeAndNil(FLocalParams);
    FreeAndNil(FAdoTable);
    FreeAndNil(FSQLiteConnection);
    FreeAndNil(FDBFADOConnection);
  end;
end;*)

function PortDataToSqlite(FullDbfName, FullSqliteName: String): Boolean;
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
              ftDate: ValuesExpression := ValuesExpression + chr(39) + FormatDateTime('YYYY-MM-DD', FField.AsDateTime) + chr(39);
              ftBoolean: ValuesExpression := ValuesExpression + IntToStr(integer(FField.asBoolean));
              ftInteger, ftSmallint, ftLargeInt: ValuesExpression := ValuesExpression + IntToStr(FField.asInteger); //20160208 Igor
              ftWideString, ftString: ValuesExpression :=
                 ValuesExpression + chr(39) + ReplaceStr(FField.AsString, '''', '''''') + chr(39);
              ftFloat: ValuesExpression := ValuesExpression + ReplaceStr(FloatToStr(FField.asFloat), FormatSettings.DecimalSeparator, '.');
              ftWideMemo, ftMemo, ftBlob: begin
                            ValuesExpression := ValuesExpression + ' :' + FField.FieldName;
                            FLocalParams.CreateParam(ftBlob, FField.FieldName, ptInput).Value := FField.Value;
                          end
              else raise Exception.Create('Type ' + GetEnumName(TypeInfo(TDataType), integer(FField.DataType)) + ' is not defined');
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

function PortDataToSqliteAllTables(DbfDirectory, SqliteDirectory: String): Boolean;
var FDBFADOConnection: TADOConnection;
    FTableNames: TStrings;
    TableName: string;
begin
  FDBFADOConnection := TADOConnection.Create(nil);
  FTableNames := TStringList.Create;
  try
    FDBFADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                     'Data Source=' + DbfDirectory + ';' +
                     'Extended Properties="DBASE IV";';
    FDBFADOConnection.LoginPrompt := false;
    FDBFADOConnection.Open;

    FDBFADOConnection.GetTableNames(FTableNames);

    for TableName in FTableNames do
      PortDataToSqlite(DbfDirectory + '\' + TableName + '.dbf', SqliteDirectory + '\' + TableName + '.db');
  finally
    FreeAndNil(FTableNames);
    FreeAndNil(FDBFADOConnection);
  end;
end;

function GenSqliteSchemaAllTables(DbfDirectory, SqliteDirectory: String): Boolean;
var FDBFADOConnection: TADOConnection;
    FTableNames: TStrings;
    TableName: string;
begin
  FDBFADOConnection := TADOConnection.Create(nil);
  FTableNames := TStringList.Create;
  try
    FDBFADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                     'Data Source=' + DbfDirectory + ';' +
                     'Extended Properties="DBASE IV";';
    FDBFADOConnection.LoginPrompt := false;
    FDBFADOConnection.Open;

    FDBFADOConnection.GetTableNames(FTableNames);


    for TableName in FTableNames do
      GenSqliteSchema(DbfDirectory + '\' + TableName + '.dbf', SqliteDirectory + '\' + TableName + '.db', false); //20220622 Igor
  finally
    FreeAndNil(FTableNames);
    FreeAndNil(FDBFADOConnection);
  end;
end;

end.
