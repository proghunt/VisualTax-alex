unit vtDataBase; // 20150820 igor

interface

uses uADCompClient;

function SetTableName(var FDConnection: TADConnection; var Table: TADTable;
                       DataBaseName, TableName, IndexName: string;
                       AUpdatePassword: Boolean = True): boolean; //20170112 Igor
function SqlLoadDBFromFile(var FDConnection: TADConnection; var Query1: TADQuery; //201740512 igor
                           DBName: string;PathQryName: string): boolean; //20150909 Igor
function SetConnection(var FDConnection: TADConnection; DataBaseName,TableName: string;
  AReturn: Boolean = False; AUpdatePassword: Boolean = True; ASilent: boolean = false): Boolean; //20200317 Igor
function GetTableName(ADataBaseName: String): String;

function Pswd(V: Integer; AReturn: Boolean; AisMD5: Boolean = true): String; //20170117 Igor

implementation

uses Db, Dialogs, vtCommon, vtShared, vtTrimStr, SysUtils
   , vtMulti, StrUtils, //20150925 Igor
   IdHashMessageDigest, uADStanOption; //20161208 Igor //20170512 Igor
//20160303 Igor
//20150925 Igor

//20170117 Igor >>>
//function fGetSQLitePsw(var lPsw: TSQLitePassword):Boolean;
//begin
//  Result:=False;
//  if Assigned(CurrentApp) then
//    lPsw:= CurrentApp.SQLLitePassword; //20151017 Igor
//  Result:=True;
//end;
//20170512 Igor >>>
type
  TDBHelper = class(TObject)
  public
    procedure TableAfterOpen(ADataSet: TDataSet);
    procedure QueryAfterOpen(ADataSet: TDataSet);
  end;

var
  DBHelper: TDBHelper;
//20170512 Igor <<<

function NeedMD5(AVersion: Integer): Boolean;
begin
  Result := (AVersion = 3) or (AVersion = 4);
end;

function Pswd(V: Integer; AReturn: Boolean;
  AisMD5: Boolean = true): String;
begin
  if AReturn then
    Result := CurrentApp.SQLLitePassword.RFPassword[V]
  else
    Result := CurrentApp.SQLLitePassword.Password[V];

  if NeedMD5(V) and AisMD5 then  //20161215 Igor
    with TIdHashMessageDigest5.Create do
      try
        result := HashStringAsHex(result);
      finally
        Free;
      end;
end;

function SetConnection(var FDConnection: TADConnection; DataBaseName,TableName: string;
  AReturn: Boolean = False; AUpdatePassword: Boolean = True; ASilent: boolean = false): Boolean; //20200317 Igor
var
//  lPsw: TSQLitePassword; //20170117 Igor
  I: Integer;
  //20170227 Igor >>>
  BackupVersion: Integer;
  procedure MakeBackUp;
  begin
    BackupVersion := 0;
    While FileExists(FDConnection.Params.Values['DataBase'] + '.bak' + IntToStr(BackupVersion)) do
      inc(BackupVersion);
    FDConnection.Connected := False;
    try
      FDConnection.Params.Values['LockingMode'] := 'Exclusive';
      CopyFile(FDConnection.Params.Values['DataBase'],
               FDConnection.Params.Values['DataBase'] + '.bak' + IntToStr(BackupVersion));
    finally
      FDConnection.Connected := True;
    end;
  end;

  procedure DelBackUp;
  begin
    FDConnection.Connected := False;
    try
      FDConnection.Params.Values['LockingMode'] := 'Normal';
      DeleteFile(FDConnection.Params.Values['DataBase'] + '.bak' + IntToStr(BackupVersion))
    finally
      FDConnection.Connected := True;
    end;

  end;

  procedure Restore;
  begin
    FDConnection.Connected := False;
    try
      FDConnection.Params.Values['LockingMode'] := 'Normal';
      CopyFile(FDConnection.Params.Values['DataBase'] + '.bak' + IntToStr(BackupVersion),
               FDConnection.Params.Values['DataBase']);
    finally
      FDConnection.Connected := True;
    end;
  end;

  procedure UpdateClientDBStructure;
  var
    Q: TADQuery;
    DataBaseVersion, X: Integer; //20171215 Igor
  begin
    Q := TADQuery.Create(nil);
    try
      Q.Connection := FDConnection;
      Q.ExecSQL('VACUUM;'); //20170605 Igor

      Q.SQL.Text := 'Select * from sqlite_master where type = ''table''';
      Q.Open;
      if not q.Locate('tbl_name', 'DataBaseVersion') then
          DataBaseVersion := 0
      else
      begin
        q.Close;
        q.SQL.Text := 'Select * from DataBaseVersion Order By VersionNo';
        q.Open;
        q.Last;
        DataBaseVersion := q.FieldByName('VersionNo').AsInteger;
      end;

      {Check Version}
      if DataBaseVersion = 0 then
      begin
        {Make restructure}
        try
          {Backup database}
          MakeBackUp;

          {Create service table}
          q.SQL.Text := 'CREATE TABLE DataBaseVersion (VersionNo INT NOT NULL PRIMARY KEY, RestructureDate DATETIME NOT NULL)';
          q.ExecSQL;

          {drop bad index}
          q.SQL.Text := 'DROP INDEX FILE_NAME;';
          q.ExecSQL;

          {collapse data}
          q.SQL.Text := 'DELETE FROM Clients' + #13 +
                        'WHERE Clients.ROWID in (' + #13 +
                        'Select' + #13 +
                        '  C1.ROWID' + #13 +
                        'from' + #13 +
                        '  Clients C1' + #13 +
                        '  LEFT OUTER JOIN (' + #13 +
                        '    SELECT FILE_NAME, MAX(C2.ROWID) as Row_ID' + #13 +
                        '    from Clients C2' + #13 +
                        '    Group By FILE_NAME) as C3 ON C1.FILE_NAME = C3.FILE_NAME AND C1.ROWID = C3.ROW_ID' + #13 +
                        'WHERE' + #13 +
                        '  C3.ROW_ID is null)';
          q.ExecSQL;

          {create good index}
          q.SQL.Text := 'CREATE UNIQUE INDEX FILE_NAME ON Clients(FILE_NAME);';
          q.ExecSQL;

          {Up Version}
          DataBaseVersion := 1;
          {Write Version}
          q.Close;
          q.SQL.Text := 'Select * from DataBaseVersion Order By VersionNo';
          q.Open;
          q.Append;
          q.FieldByName('VersionNo').AsInteger := DataBaseVersion;
          q.FieldByName('RestructureDate').AsDateTime := Now;
          q.Post;


          {Delete backup}
          DelBackUp;
        except ON E: Exception DO
          begin
            {restore backup}
            Restore;
          end;
        end;
      end;
      //20171215 Igor>>>
      if DataBaseVersion = 1 then
      begin
        {Make restructure}
        Q.SQL.Text := 'Select File_Name from Clients';
        Q.Open;
        X := Q.FieldByName('File_name').Size;

        Q.SQL.Text := 'CREATE TABLE IF NOT EXISTS CountSlips(' + #13#10 +
                        'File_Name VarChar('+IntToStr(X)+') Not Null,' + #13#10 +
                        'Slip_Name VarChar(50) Not Null,' + #13#10 +
                        'Slip_Count Int Not Null Default(0),' + #13#10 +
                        'CONSTRAINT [PK_CountSlips] PRIMARY KEY (File_Name, Slip_Name),' + #13#10 +
                        'CONSTRAINT [FK_CountSlips_File_Name] FOREIGN KEY (File_Name) ' + #13#10 +
                          'REFERENCES Clients(File_Name) ON DELETE CASCADE ON UPDATE CASCADE)';
        Q.ExecSQL;
        {Up Version}
        DataBaseVersion := 2;
        {Write Version}
        q.Close;
        q.SQL.Text := 'Select * from DataBaseVersion Order By VersionNo';
        q.Open;
        q.Append;
        q.FieldByName('VersionNo').AsInteger := DataBaseVersion;
        q.FieldByName('RestructureDate').AsDateTime := Now;
        q.Post;
      end;
      //20171215 Igor<<<
      //20171221 Igor>>>
      if DataBaseVersion = 2 then
      begin
        {Make restructure}
        Q.SQL.Text := 'Select File_Name from Clients';
        Q.Open;
        X := Q.FieldByName('File_name').Size;

        Q.SQL.Text := 'CREATE TABLE IF NOT EXISTS FormsInfo(' + #13#10 +
                        'File_Name VarChar('+IntToStr(X)+') Not Null,' + #13#10 +
                        'Form_Name VarChar(50) Not Null,' + #13#10 +
                        'Kind VarChar(10) Not Null,' + #13#10 +
                        'Value TEXT Not Null,' + #13#10 +
                        'CONSTRAINT [PK_FormsInfo] PRIMARY KEY (File_Name, Form_Name, Kind),' + #13#10 +
                        'CONSTRAINT [FK_FormsInfo_File_Name] FOREIGN KEY (File_Name) ' + #13#10 +
                        'REFERENCES Clients(File_Name) ON DELETE CASCADE ON UPDATE CASCADE);' + #13#10 +

                      'INSERT INTO FormsInfo(File_Name, Form_Name, Kind, Value)' + #13#10 +
                      'SELECT File_Name, Slip_Name, ''COUNT'', CAST(Slip_Count as TEXT)' + #13#10 +
                      'FROM CountSlips;' + #13#10 +

                      'DROP TABLE CountSlips;';

        Q.ExecSQL;
        {Up Version}
        DataBaseVersion := 3;
        {Write Version}
        q.Close;
        q.SQL.Text := 'Select * from DataBaseVersion Order By VersionNo';
        q.Open;
        q.Append;
        q.FieldByName('VersionNo').AsInteger := DataBaseVersion;
        q.FieldByName('RestructureDate').AsDateTime := Now;
        q.Post;
      end;
      //20171221 Igor<<<

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
    finally
      Q.Free;
    end;
  end;
  //20170227 Igor <<<
Begin
  Result := False;
  if not fileExists(DataBaseName) and
     (not Assigned(RetList) or //20170811 Igor
      (RetList[GetCurrentRetNo] = nil) or
      not RetList[GetCurrentRetNo].InitDataDirectory) then
    exit;
  //20170310 Igor >>>
  if Assigned(CurrentApp) then
    AUpdatePassword := AUpdatePassword and
                       (
                         SameText(ExtractFileDir(DataBaseName), CurrentApp.Dir_Deflt)
                         or
                         SameText(ExtractFileDir(DataBaseName), CurrentApp.AppDir)
                       );
  //20170310 Igor <<<
  if not assigned(FDConnection) then
    FDConnection := TADConnection.Create(nil); //20160226 Igor
//  result:= fGetSQLitePsw(lPsw); //20160303 Igor //20170117 Igor
//  if not result then exit;      //20160303 Igor //20170117 Igor
  if FDConnection.Connected then //20150820 igor
    FDConnection.Close;
  //20180103 Igor>>>
  FDConnection.ResourceOptions.MacroCreate := False;
  FDConnection.ResourceOptions.MacroExpand := False;
  FDConnection.ResourceOptions.AssignedValues := FDConnection.ResourceOptions.AssignedValues +
    [rvMacroCreate, rvMacroExpand];
  //20180103 Igor<<<
  FDConnection.Params.Values['DataBase'] := DataBaseName;
  FDConnection.DriverName:='SQLite';                      //20150908 Igor
//  FDConnection.Params.Values['SharedCache'] := 'False'; //20170512 Igor
  FDConnection.Params.Values['LockingMode'] := 'normal'; // 20170203 Igor
  FDConnection.FetchOptions.Mode := fmAll; //20170512 Igor
  //20170605 Igor >>>
  FDConnection.FormatOptions.SortLocale := 0;
//  FDConnection.FormatOptions.StrsTrim := False; //20170606 Igor
  //20170605 Igor <<<

  //20150925 Igor

  if (pos(trim(UpperCase(ClientsTableLite)),trim(UpperCase(TableName))) = 1) or AReturn //20161028 Igor
    then FDConnection.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, AReturn) //20161208 Igor
                                                 //ifthen(not AReturn, lPsw.CurrentPassword, lPsw.RFCurrentPassword)     //20150925 Igor //20161028 Igor
    else FDConnection.Params.Values['Password'] := '';      //20150925 Igor
  try
    FDConnection.Connected := true;
  Except ON E: Exception DO
    Begin
      //20200303 Igor >>>
      try
        FDConnection.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, AReturn, false);
        FDConnection.Connected := true;
      except
        begin
          if (pos(trim(UpperCase(ClientsTableLite)),trim(UpperCase(TableName))) = 1) or AReturn then //20170117 Igor
          Begin
            //20160303 Igor >>>>
            for I := GC_SQLLitePasswordVersion downto 0 do
            Begin
              FDConnection.Close;
              FDConnection.Params.Values['Password'] := Pswd(I, AReturn); //20161208 Igor
                                                        //ifthen(not AReturn, lPsw.Password[I], lPsw.RFPassword[I]); //20161028 Igor
              if AUpdatePassword then  //20170112 Igor
                FDConnection.Params.Values['NewPassword'] := Pswd(GC_SQLLitePasswordVersion, AReturn); //20161208 Igor
                                                           //ifthen(not AReturn, lPsw.CurrentPassword, lPsw.RFCurrentPassword); //20161028 Igor
              try
                FDConnection.Connected := True;
                if FDConnection.Connected then
                  break;
              Except
                if NeedMD5(I) then
                begin
                  FDConnection.Close;
                  FDConnection.Params.Values['Password'] := Pswd(I, AReturn, False); //20161208 Igor
                  if AUpdatePassword then
                    FDConnection.Params.Values['NewPassword'] := Pswd(GC_SQLLitePasswordVersion, AReturn);
                  try
                    FDConnection.Connected := True;
                    if FDConnection.Connected then
                      break;
                  except
                  end;
                end;
              end;
            end;
            //20160303 Igor <<<<<
          End;
        End;
      //20200303 Igor <<<
      End;
    End;
  end;
  Result := FDConnection.Connected;
  //20200317 Igor >>>
  if not Result then
  begin
    if not ASilent then ErrorMsg('Cannot open ' + DataBaseName)
  end
  //20200317 Igor <<<
  //20170227 Igor >>>
  else
  if Result and AUpdatePassword and SameText(ClientsTableLite, TableName) then
  begin
    UpdateClientDBStructure;
  end;
  //20170227 Igor <<<
End;
//20170117 Igor <<<

function SetTableName(var FDConnection: TADConnection; var Table: TADTable;
                       DataBaseName, TableName, IndexName: string;
                       AUpdatePassword: Boolean = True): boolean; //20170112 Igor
begin
  Result := False;
  //20200317 Igor >>>
  if CurrentApp.CanRebuildCorruptedDatabase then
  begin
    if not SetConnection(FDConnection,DataBaseName,TableName, False, AUpdatePassword, true) then
    begin
      CurrentApp.RebuildCorruptedDatabase;
      if not SetConnection(FDConnection,DataBaseName,TableName, False, AUpdatePassword) then exit;
    end;
  end
  else
    if not SetConnection(FDConnection,DataBaseName,TableName, False, AUpdatePassword) then exit; //20160226 Igor //20170112 Igor
  //20200317 Igor <<<
  if not Assigned(Table) then
    Table := TADTable.Create(Nil);  //20160226 Igor
 Try
   If Table.Active then
     Table.Close;

   Table.Connection:= FDConnection;                        //20150908 Igor
   Table.TableName := TableName;
   Table.IndexName := UpperCase(IndexName);
   Table.AfterOpen := DBHelper.TableAfterOpen; //20170512 Igor

   Table.Open;
   Result := True;
 except
   on EDataBaseError do begin
    ErrorMsg('Cannot open ' + DataBaseName + ' : ' + TableName);
    ShowMessage('Data Base cannot be opened '); //+E.Message, mtError, [mbok], 0);
   // ShowMessage('Data Base cannot be opened');
    result := False;
   end;
 end; {except}

end;

function SqlLoadDBFromFile(var FDConnection: TADConnection; var Query1: TADQuery; //20170512 Igor
                           DBName: string;PathQryName: string): boolean;
var i:integer;
    fReplace:Boolean;
    lPsw:String;
begin
  if not SetConnection(FDConnection,DBName,ChangeFileExt(ExtractFileName(DBName),'')) then exit; //20160226 Igor
  if Not assigned(Query1) then
    Query1 := TADQuery.Create(nil);
  Query1.AfterOpen := DBHelper.QueryAfterOpen; //20170512 Igor
  Query1.Close;
  Query1.SQL.Clear;
  Query1.Connection:= FDConnection;                   //20150922 Igor
  if trim (PathQryName) <> '' then Query1.Sql.LoadFromFile(PathQryName);
  //
  fReplace:=false;
  i:=0;
  while i <= Query1.Sql.Count - 1 do
  begin
    if Pos(UpperCase('"clients.dbf"'), UpperCase(Query1.Sql[i])) > 0 then
    begin
      fReplace:=true;
      Query1.Sql[i]:=ReplaceStr(UpperCase(Query1.Sql[i]), UpperCase('"clients.dbf"'), 'clients');
    end;
    if (LengTh(Query1.Sql[i])>0)and(Ord(Query1.Sql[i][1])=26) then
      Query1.Sql[i]:=''; //20150910
    i:=i+1;
  end;
  //Sql Text on file Replace or NOT Replace
  if fReplace then Query1.SQL.SaveToFile(PathQryName);
end;

function GetTableName(ADataBaseName: String): String;
Begin
  if pos(UpperCase('Clients'),UpperCase(ADataBaseName)) = 1 then
    Result := ClientsTableLite
  else
    result := ChangeFileExt(ADataBaseName, '');
End;

{ TDBHelper }

procedure TDBHelper.QueryAfterOpen(ADataSet: TDataSet);
begin
  with (ADataSet as TADQuery) do
  begin
    DisableControls;
    try
      Last;
      First;
    finally
      EnableControls;
    end;
  end;
end;

procedure TDBHelper.TableAfterOpen(ADataSet: TDataSet);
begin
  with (ADataSet as TADTable) do
  begin
    DisableControls;
    try
      Last;
      First;
    finally
      EnableControls;
    end;
  end;
end;

//20170512 Igor >>>
initialization
  DBHelper := TDBHelper.Create;

finalization
  FreeAndNil(DBHelper);
//20170512 Igor <<<

end.
