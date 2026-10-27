unit vtDataModuleUnit;

interface

uses
  System.SysUtils, System.Classes, uADStanExprFuncs, uADGUIxIntf, System.UITypes, //20160226 Igor
  {uADGUIxFormsWait,} uADStanIntf, uADStanOption, uADStanError, uADPhysIntf, //20170417 Igor
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADCompClient, Data.DB,
  uADPhysSQLite, uADCompGUIx,
  vtMulti, IdHTTP, IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, Vcl.Dialogs, uADPhysODBCBase,
  uADPhysODBC, uADGUIxConsoleWait; //20170410 Igor

type
  TvtDataModule = class(TDataModule)
    FDPhysSQLiteDriverLink: TADPhysSQLiteDriverLink;
    FDGUIxWaitCursor: TADGUIxWaitCursor;
    FDSQLiteSecurity: TADSQLiteSecurity;
    FDConnection: TADConnection;
    FDTransaction: TADTransaction;
    dlgOpen: TOpenDialog;
    ADPhysODBCDriverLink1: TADPhysODBCDriverLink;
  private
    { Private declarations }
  public
    { Public declarations }
    // move EmptyDataBase, encrypt and fill it with values 20150903
//    procedure DataBaseCreate(lDbPsw,lClientsDBLite:String;DbDirectory1,DbDirectory2:String); //20151017 Igor
  end;

var
  vtDataModule: TvtDataModule;

procedure DataBaseCreate(lDbPsw: TSQLitePassword;lClientsDBLite:String;DbDirectory1,DbDirectory2:String);//20150119 Igor
function ConvertOneTable(ASrcTable, ADstTable, APassword: String): Boolean;
Function CheckTableStructure(App: TApp): Boolean; //20160226 Igor
function RemovePasswordClientDB(ADataBase: String): Boolean; //20160305 Igor
function RemovePasswordReturn(AReturnFile: String): Boolean; //20161028 Igor
function SetPasswordVersion(AFileName, ATableName: string; AisReturn: Boolean; AVersion: Integer): Boolean; //20170117 Igor
function RepairReturn(AReturnFile: String; out Res: String): Boolean; //20170420 Igor
procedure TryRecovery(AReturnFile: String);

implementation


{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

uses IOUtils, {ADODb,} Variants, StrUtils, System.TypInfo, Forms
   ,  vtShared, vtDBF_SQLite, vtDataBase, //20151017 Igor
   vtFileStorage; //20170420 Igor

{ TvtDataModule }

//20151018 Igor
procedure {TvtDataModule.}DataBaseCreate(lDbPsw: TSQLitePassword; lClientsDBLite:String;
  DbDirectory1,DbDirectory2:String);
var //FDBFADOConnection: TADOConnection;
  DBFConn: TADConnection;
    lPsw: string;
    DBNames1,DBNames2: TStrings;
    DBNameFrom: string;
    DBNameFrom_all,DBNameTo_all: string;
    msgStr: string;
    FDSQLSecurity : TADSQLiteSecurity;
    DriverLink : TADPhysSQLiteDriverLink; //20160226 Igor
  //20161202 Igor >>>
    sr: TSearchRec;
    r1, r2: Integer;
begin
  r1 := FindFirst(IncludeTrailingPathDelimiter(DbDirectory1) + '*.dbf', faAnyFile, sr);
  FindClose(sr);
  r2 := FindFirst(IncludeTrailingPathDelimiter(DbDirectory2) + '*.dbf', faAnyFile, sr);
  FindClose(sr);
  if (r1 <> 0) and (r2 <> 0) then //no DBF
    exit;
  //20161202 Igor <<<
  
  DBFConn := TADConnection.Create(nil);
  DBFConn.LoginPrompt := False;

//  FDBFADOConnection := TADOConnection.Create(nil);
  DriverLink := TADPhysSQLiteDriverLink.Create(nil); //20160226 Igor
  DriverLink.DriverID := 'SQLite';                   //20160226 Igor
  FDSQLSecurity := TADSQLiteSecurity.Create(nil);
  FDSQLSecurity.DriverLink := DriverLink;            //20160226 Igor

  DBNames1 := TStringList.Create;
  DBNames2 := TStringList.Create;
  msgStr:='';
  try
    if not DirectoryExists(DbDirectory1) then
      DbDirectory1 := '';// exit; //20160811 Igor
    if DbDirectory1 <> '' then
    begin
     //20161202 Igor >>>
      SetODBCConnect(DBFConn, DbDirectory2);
//      DBFConn.Params.Values['DriverID'] := 'ODBC';
//      DBFConn.Params.Values['ODBCDriver'] := '{Driver do Microsoft dBase (*.dbf)}';//'{Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)}';
//      DBFConn.Params.Values['Database'] := ExtractFileDir(DbDirectory1);
      //20161202 Igor <<<
      DBFConn.Connected := True;
      DBFConn.GetTableNames(ExtractFileDir(DbDirectory1), '', '', DBNames1);
(*
        FDBFADOConnection.ConnectionString :=
//          'Provider=MSDASQL.1;Persist Security Info=False;'+
//          'Data Source=dBASE Files;Initial Catalog=' + ExtractFilePath(DbDirectory1) + ';';
                         'Provider=Microsoft.Jet.OLEDB.4.0;' +
                         'Data Source=' + DbDirectory1 + ';' +
                         'Extended Properties="DBASE IV";';
        FDBFADOConnection.LoginPrompt := false;
        FDBFADOConnection.Open;
        FDBFADOConnection.GetTableNames(DBNames1);
*)
    end;

    if DbDirectory2 <> '' then
    begin
      DBFConn.Close;
      //20161202 Igor >>>
      SetODBCConnect(DBFConn, DbDirectory2);
//      DBFConn.Params.Values['DriverID'] := 'ODBC'; //20161108 Igor
//      DBFConn.Params.Values['ODBCDriver'] := '{Driver do Microsoft dBase (*.dbf)}';//'{Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)}'; //20161108 Igor
//      DBFConn.Params.Values['Database'] := ExtractFileDir(DbDirectory2);
      //20161202 Igor <<<
      DBFConn.Connected := True;
      DBFConn.GetTableNames(ExtractFileDir(DbDirectory2), '', '', DBNames2);

(*
        FDBFADOConnection.ConnectionString :=
//          'Provider=MSDASQL.1;Persist Security Info=False;'+
//          'Data Source=dBASE Files;Initial Catalog=' + ExtractFilePath(DbDirectory2) + ';';
                         'Provider=Microsoft.Jet.OLEDB.4.0;' +
                         'Data Source=' + DbDirectory2 + ';' +
                         'Extended Properties="DBASE IV";';
        FDBFADOConnection.LoginPrompt := false;
        FDBFADOConnection.Open;
        FDBFADOConnection.GetTableNames(DBNames2);
*)
    end;

    //on path1
    for DbNameFrom in DBNames1 do
    begin
        DBNameFrom_all:= DbDirectory1 + DbNameFrom + '.dbf';
        if UpperCase(DbNameFrom+'.DBF') = UpperCase(ClientsTable_dbf)
        then begin DBNameTo_all:=DbDirectory1 + lClientsDBLite;
                   lPsw:=lDbPsw.CurrentPassword;
             end
        else begin DBNameTo_all:=DbDirectory1 + DBNameFrom+ '.db';
                   lPsw:='';
             end;

        if not TFile.Exists(DBNameTo_all) then
        begin
             if GenSqliteSchema(DBNameFrom_all, DBNameTo_all, lPsw)
             then begin
                  //
                  if PortDataToSqlite(DBNameFrom_all, DBNameTo_all, lPsw)
                  then msgStr:=msgStr + #10+ #13 + DBNameFrom_all + ' => ' + ExtractFileName(DBNameTo_all);
                  // Encrypt data file
                  if lPsw<>'' then
                  begin
                        FDSQLSecurity.Database := DBNameTo_all;
                        FDSQLSecurity.Password := lPsw;
                        FDSQLSecurity.SetPassword;
                  end;
             end;
        end;
    end;

    if msgStr <> '' then msgStr:= msgStr + #10+ #13 + '-----------------';

    //on path2
    for DbNameFrom in DBNames2 do
    begin
        DBNameFrom_all:= DbDirectory2 + DbNameFrom + '.dbf';
        if UpperCase(DbNameFrom+'.DBF') = UpperCase(ClientsTable_dbf)
        then begin DBNameTo_all:=DbDirectory2 + lClientsDBLite;
                   lPsw:=lDbPsw.CurrentPassword;
             end
        else begin DBNameTo_all:=DbDirectory2 + DBNameFrom+ '.db';
                   lPsw:='';
             end;

        if not TFile.Exists(DBNameTo_all) then
        begin
             if GenSqliteSchema(DBNameFrom_all, DBNameTo_all, lPsw)
             then begin
                  //
                  if PortDataToSqlite(DBNameFrom_all, DBNameTo_all, lPsw)
                  then msgStr:=msgStr + #10+ #13 + DBNameFrom_all + ' => ' + ExtractFileName(DBNameTo_all);
                  // Encrypt data file
                  if lPsw<>'' then
                  begin
                        FDSQLSecurity.Database := DBNameTo_all;
                        FDSQLSecurity.Password := lPsw;
                        FDSQLSecurity.SetPassword;
                  end;
             end;
        end;
    end;

  finally
    FreeAndNil(DBNames1);
    FreeAndNil(DBNames2);
    FreeAndNil(FDSQLSecurity);
//    FreeAndNil(FDBFADOConnection);
    freeAndNil(DBFConn);
    FreeAndNil(DriverLink);//20160226 Igor
  end;

  if msgStr <> '' then ShowMessage('DataBase file was converted:' + #10+ #13 + '-----------------'+msgStr);

end;

function ConvertOneTable(ASrcTable, ADstTable, APassword: String): Boolean;
Begin
  Result := False;
  if not FileExists(ASrcTable) then
  Begin
    MessageDlg('Source file "'+ASrcTable+'" not found!',mtError,[mbOk],0);
    exit;
  End;
  if FileExists(ADstTable) then
  Begin
    if MessageDlg('Distination file "'+ASrcTable+'" exists. Overwrite?',mtWarning,[mbYes,mbCancel],0,mbCancel) <> mrYes then
    exit;
  End;
  if GenSqliteSchema(ASrcTable, ADstTable, APassword) then
    if PortDataToSqlite(ASrcTable, ADstTable, APassword) then
      Result := true;
End;

Function CheckTableStructure(App: TApp): Boolean; //20160226 Igor
var
  Conn: TADConnection;
  QRY: TADQuery;
  function UpdateUsers(DBUsers: String): Boolean;
  var
    DataBaseVersion: Integer;
  Begin
    Result := False;
    Conn := TADConnection.Create(nil);
    QRY := TADQuery.Create(nil);
    QRY.Connection := Conn;
    try
      Conn.LoginPrompt := False;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] := DBUsers;
      Conn.Params.Values['Password'] := ''; //20160226 Igor
      try
        Conn.Connected := True;
//20170112 Igor >>>
//        qry.SQL.Text := 'SELECT * FROM Users Where 1=0';
//        qry.Open;
//        if qry.FindField('DBFData_Dir') = nil then
//        Begin
//          qry.Close;
//          qry.SQL.Text := 'ALTER TABLE Users ADD DBFData_Dir VARCHAR(100) NULL';
//          qry.ExecSQL;
//        End;
        QRY.SQL.Text := 'Select * from sqlite_master where type = ''table''';
        QRY.Open;
        if not qry.Locate('tbl_name', 'DataBaseVersion') then
          DataBaseVersion := 0
        else
        begin
          qry.Close;
          qry.SQL.Text := 'Select * from DataBaseVersion Order By VersionNo';
          qry.Open;
          qry.Last;
          DataBaseVersion := qry.FieldByName('VersionNo').AsInteger;
        end;

        {Check Version}
        if DataBaseVersion = 0 then
        begin
          {Make restructure}
          qry.SQL.Text := 'CREATE TABLE DataBaseVersion (VersionNo INT NOT NULL PRIMARY KEY, RestructureDate DATETIME NOT NULL)';
          qry.ExecSQL;
          qry.SQL.Text := 'CREATE TABLE User_TaxModule ('+
                             'LOGIN_ID VARCHAR(10) NOT NULL, '+
                             'TaxModule VARCHAR(10) NOT NULL, '+
                             'CONSTRAINT `PK_User_TaxModule` PRIMARY KEY (LOGIN_ID, TaxModule))';
          qry.ExecSQL;
          qry.SQL.Text := 'CREATE TABLE Overload_Options ('+
                             'LOGIN_ID VARCHAR(10) NOT NULL, '+
                             'TaxModule VARCHAR(10) NOT NULL, '+
                             'OptionsName VARCHAR(50) NOT NULL, '+
                             'OptionsValue TEXT NULL, '+
                             'CONSTRAINT `PK_Overload_Options` PRIMARY KEY (LOGIN_ID, TaxModule, OptionsName))';
          qry.ExecSQL;

          if App = nil then
          Begin
            qry.SQL.Text := 'INSERT INTO User_TaxModule(LOGIN_ID, TaxModule) Select LOGIN_ID, ''T1-2016'' from `Users`';
            qry.ExecSQL;

            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''Dir_Cur'', `Users`.TAX_DIR from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''Dir_Deflt'', `Users`.TAX_DIR from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''Dir_DBFData'', `Users`.DBFData_Dir from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''Ef_DataDir'', `Users`.EFile_Dir from `Users`');

            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''CR_PROFILE'', `Users`.CR_PROFILE from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''CR_RETURN'', `Users`.CR_RETURN from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''PR_INVOICE'', `Users`.PR_INVOICE from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''PR_REPORT'', `Users`.PR_REPORT from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''MK_APPOINT'', `Users`.MK_APPOINT from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''CR_RTU'', `Users`.CR_RTU from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''EFILE'', `Users`.EFILE from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''UPLOAD'', `Users`.UPLOAD from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''MK_PAY'', `Users`.MK_PAY from `Users`');
            qry.ExecSQL('INSERT INTO Overload_Options(LOGIN_ID, TaxModule, OptionsName, OptionsValue) '+
                        'Select `Users`.LOGIN_ID, ''T1-2016'', ''BR_DIR'', `Users`.BR_DIR from `Users`');

            qry.ExecSQL('ALTER TABLE Users RENAME TO Users_Old');
            qry.ExecSQL('CREATE TABLE Users (' +
                           'LOGIN_ID VARCHAR(10) NOT NULL, ' +
                           'CODE VARCHAR(4) NOT NULL, ' +
                           'PSWD VARCHAR(10) NOT NULL, ' +
                           'PREP_NAME VARCHAR (20) NULL, ' +
                           'PREP_INTLS VARCHAR (2) NULL, ' +
                           'M_OFFICE VARCHAR(4) NULL, ' +
                           'BRANCH VARCHAR(2) NULL, ' +
                           'AUTH_LEVEL VARCHAR(2) NULL,'+
                           'INV_NO REAL NULL,'+
                           'CONSTRAINT `PK_USERS` PRIMARY KEY (LOGIN_ID))');
            qry.ExecSQL('INSERT INTO Users(LOGIN_ID,CODE,PSWD,PREP_NAME,PREP_INTLS,M_OFFICE,BRANCH,AUTH_LEVEL,INV_NO) '+
                        'Select COALESCE(LOGIN_ID,''''), COALESCE(CODE,''''), COALESCE(PSWD,''''), '+
                        'PREP_NAME,PREP_INTLS,M_OFFICE,BRANCH,AUTH_LEVEL,INV_NO from Users_Old');
            qry.ExecSQL('Drop Table Users_Old');
            qry.ExecSQL('CREATE INDEX NAME ON Users (LOGIN_ID);');
          end;
          {Up Version}
          DataBaseVersion := 1;
          {Write Version}
          qry.Close;
          qry.SQL.Text := 'Select * from DataBaseVersion Order By VersionNo';
          qry.Open;
          qry.Append;
          qry.FieldByName('VersionNo').AsInteger := DataBaseVersion;
          qry.FieldByName('RestructureDate').AsDateTime := Now;
          qry.Post;
        end;
(* template
        {Check Version}
        if DataBaseVersion = N then
        begin
          {Make restructure}

          {Up Version}
          DataBaseVersion := N+1;
          {Write Version}
          qry.Close;
          qry.SQL.Text := 'Select * from DataBaseVersion Order By VersionNo';
          qry.Open;
          qry.Append;
          qry.FieldByName('VersionNo').AsInteger := DataBaseVersion;
          qry.FieldByName('RestructureDate').AsDateTime := Now;
          qry.Post;
        end;
*)
//20170112 Igor <<<
      Except ON E: Exception DO
        Begin
          MessageDlg('Failed to update the table "Users" structure:'+#13+
                     E.Message,mtError,[mbOk],0);
          exit;
        End;
      end;
      Result := True;
    finally
      QRY.Close; //20160720 Igor
      QRY.Free; //20160720 Igor
      Conn.Close;
      Conn.Free;
    end;
  End;
  function UpdateClientPassword: Boolean;
  var
    C: TADConnection;
  Begin
    result := False;
    try
      C := TADConnection.Create(nil);
      Result := SetConnection(C,App.AppDir+'\'+ClientsDbLite, ClientsTableLite);
    finally
      if Assigned(C) then
        FreeAndNil(C);
    end;
  End;
Begin
  Result := False;
  //------------------------
  // Users
  //------------------------
  if App <> nil then
  Begin
  //20170927 igor>>>
    //if FileExists(App.AppDir+'\'+'Users.db') then
    //  if not UpdateUsers(App.AppDir+'\'+'Users.db') then exit;
  //20170927 igor<<<
    if not UpdateClientPassword then
      exit;
  End
  else
  Begin
  //20170927 igor>>>
    if FileExists(TPath.Combine(ExeDir, 'Users.db')) then
      if not UpdateUsers(TPath.Combine(ExeDir, 'Users.db')) then exit;
  //20170927 igor<<<
  End;
  Result := True;
End;

function RemovePasswordClientDB(ADataBase: String): Boolean; //20160305 Igor
var
  Conn: TADConnection;
  FDSQLSecurity : TADSQLiteSecurity;
  DriverLink : TADPhysSQLiteDriverLink;
Begin
  Result := False;
  Conn := TADConnection.Create(nil);
  DriverLink := TADPhysSQLiteDriverLink.Create(nil);
  DriverLink.DriverID := 'SQLite';
  FDSQLSecurity := TADSQLiteSecurity.Create(nil);
  FDSQLSecurity.DriverLink := DriverLink;
  try
    if not SetConnection(Conn,ADataBase,ClientsTableLite, False) then exit; //20170117 Igor
    Conn.connected := False;
    FDSQLSecurity.Database := ADataBase;
    FDSQLSecurity.Password := Conn.Params.Values['Password'];
    FDSQLSecurity.RemovePassword;
    result := true;
  finally
    DriverLink.Free;
    FDSQLSecurity.Free;
    conn.Free;
  end;
End;

function RemovePasswordReturn(AReturnFile: String): Boolean; //20161028 Igor
var
  Conn: TADConnection;
  FDSQLSecurity : TADSQLiteSecurity;
  DriverLink : TADPhysSQLiteDriverLink;
Begin
  Result := False;
  Conn := TADConnection.Create(nil);
  DriverLink := TADPhysSQLiteDriverLink.Create(nil);
  DriverLink.DriverID := 'SQLite';
  FDSQLSecurity := TADSQLiteSecurity.Create(nil);
  FDSQLSecurity.DriverLink := DriverLink;
  try
    if not SetConnection(Conn,AReturnFile, '', True, False) then exit; //20170117 Igor
    Conn.connected := False;
    FDSQLSecurity.Database := AReturnFile;
    FDSQLSecurity.Password := Conn.Params.Values['Password'];
    FDSQLSecurity.RemovePassword;
    result := true;
  finally
    DriverLink.Free;
    if assigned(FDSQLSecurity) then
      FDSQLSecurity.Free;
    conn.Free;
  end;
End;

procedure TryRecovery(AReturnFile: String);
type
  TRow = array of string;
  TRows = Array of TRow;
  TFields = Array of String;
  TTable = record
    TableName: String;
    Fields: TFields;
    Data: TRows;
  end;
  TTableList = array of TTable;
var
  Conn: TADConnection;
  DriverLink : TADPhysSQLiteDriverLink;
  Q, Q2: TADQuery;
  I: Integer;
  FS: TSQLiteStorage;
  TL: TTableList;
  T: ^TTable;
  R: ^TRow;
  Row: Integer;
  J: Integer;
begin
  Conn := TADConnection.Create(nil);
  DriverLink := TADPhysSQLiteDriverLink.Create(nil);
  DriverLink.DriverID := 'SQLite';
  try
    if not SetConnection(Conn,AReturnFile, '', True, False) then exit; //20170117 Igor

    Q := TADQuery.Create(nil);
    try
      Q.Connection := Conn;
      Q.SQL.Text := 'Select * from sqlite_master';
      Q.Open;

      Q2 := TADQuery.Create(nil);
      try
        Q2.Connection := Conn;
        Q.First;
        while not Q.Eof do
        begin
          if Q.FieldByName('type').AsString = 'table' then
          begin
            SetLength(TL, length(TL) + 1);
            T := @TL[length(TL) - 1];
            T.TableName := Q.FieldByName('name').AsString;
            Q2.SQL.Text := 'Select * from "' + Q.FieldByName('name').AsString + '"';
            Q2.Open;
            SetLength(T.Fields, Q2.FieldCount);
            for I := 0 to Q2.FieldCount - 1 do
              T.Fields[I] := Q2.Fields[I].FieldName;
            while not Q2.Eof do
            begin
              SetLength(T.Data, length(T.Data) + 1);
              R := @T.Data[length(T.Data) - 1];
              SetLength(R^, Q2.FieldCount);
              for I := 0 to Q2.FieldCount - 1 do
                R^[I] := Q2.Fields[I].AsString;
              Q2.Next;
            end;
          end;
          Q.Next;
        end;
      finally
        Q2.Free;
      end;
    finally
      Q.Free;
    end;
  finally
    DriverLink.Free;
    conn.Free;
  end;
  Renamefile(AReturnFile, AReturnFile + '.corupted');
  FS := TSQLiteStorage.Create(ExtractFileDir(AReturnFile),
    ExtractFileName(AReturnFile), fsWrite, CurrentApp.SQLLitePassword.PassRFArray);
  FS.Free;

  Conn := TADConnection.Create(nil);
  try
    if not SetConnection(Conn, AReturnFile, '', True, True) then exit;
    Q := TADQuery.Create(nil);
    try
      Q.Connection := conn;
      for I := 0 to length(TL) - 1 do
      begin
        Q.SQL.Text := 'Select * from "'+TL[I].TableName+'"';
        Q.Open;
        for Row := 0 to length(TL[I].Data) - 1 do
        begin
          Q.Append;
          for J := 0 to length(tl[I].Fields) - 1 do
            Q.FieldByName(tl[I].Fields[J]).Value := TL[I].Data[Row][J];
          Q.Post;
        end;
      end;
    finally
      Q.Free;
    end;
  finally
    Conn.Free;
  end;
  MessageDlg('Done.', mtInformation, [mbOk], 0);
end;

function RepairReturn(AReturnFile: String; out Res: String): Boolean; //20170420 Igor
var
  FS: TSQLiteStorage;
Begin
  if not FileExists(AReturnFile) then
  begin
    //message fixed by  CON 20170420
    MessageDlg('File does not exist', mtError, [mbOk], 0);
    exit(False);
  end;
  FS := TSQLiteStorage.Create(ExtractFileDir(AReturnFile),
    ExtractFileName(AReturnFile), fsRead, CurrentApp.SQLLitePassword.PassRFArray);
  try
    if FS.LastError <> '' then
    begin
      MessageDlg(FS.LastError, mtError, [mbOk], 0);
      Exit(False);
    end;
    Result := FS.Repair;
    Res := FS.LastError;
  finally
    FS.Free;
  end;
end;

function SetPasswordVersion(AFileName, ATableName: string; AisReturn: Boolean; AVersion: Integer): Boolean; //20170117 Igor
var
  Conn: TADConnection;
  FDSQLSecurity : TADSQLiteSecurity;
  DriverLink : TADPhysSQLiteDriverLink;
Begin
  Result := False;
  Conn := TADConnection.Create(nil);
  DriverLink := TADPhysSQLiteDriverLink.Create(nil);
  DriverLink.DriverID := 'SQLite';
  FDSQLSecurity := TADSQLiteSecurity.Create(nil);
  FDSQLSecurity.DriverLink := DriverLink;
  try
    if not SetConnection(Conn, AFileName, ATableName, AIsReturn, False) then exit; //20170117 Igor
    Conn.connected := False;
    FDSQLSecurity.Database := AFileName;
    FDSQLSecurity.Password := Conn.Params.Values['Password'];
    FDSQLSecurity.ToPassword := vtDataBase.Pswd(AVersion, AIsReturn, not AIsReturn);
    FDSQLSecurity.ChangePassword;
    result := true;
  finally
    DriverLink.Free;
    FDSQLSecurity.Free;
    conn.Free;
  end;
end;


initialization

  // 20150926 igor Initialization vtDataModule
  vtDataModule := TvtDataModule.Create(Application);
end.
