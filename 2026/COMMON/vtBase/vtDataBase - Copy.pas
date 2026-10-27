unit vtDataBase; // 20150820 igor

interface

uses uADCompClient;

function SetTableName(var FDConnection: TADConnection; var Table: TADTable;
                       DataBaseName, TableName, IndexName: string;
                       AUpdatePassword: Boolean = True): boolean; //20170112 Igor
function SqlLoadDBFromFile(FDConnection: TADConnection; Query1: TADQuery;
                           DBName: string;PathQryName: string): boolean; //20150909 Igor
function SetConnection(var FDConnection: TADConnection; DataBaseName,TableName: string;
  AReturn: Boolean = False; AUpdatePassword: Boolean = True): Boolean; //20160226 Igor //20161028 Igor //20170112 Igor
function GetTableName(ADataBaseName: String): String;

function Pswd(V: Integer; AReturn: Boolean; AisMD5: Boolean = true): String; //20170117 Igor


implementation

uses Db, Dialogs, vtCommon, vtShared, vtTrimStr, SysUtils
   , vtMulti, StrUtils, //20150925 Igor
   IdHashMessageDigest; //20161208 Igor

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
  AReturn: Boolean = False; AUpdatePassword: Boolean = True): Boolean; //20160226 Igor //20161028 Igor //20170112 Igor
var
//  lPsw: TSQLitePassword; //20170117 Igor
  I: Integer;
Begin
  Result := False;
  if not fileExists(DataBaseName) and
     ((RetList[GetCurrentRetNo] = nil) or
      not RetList[GetCurrentRetNo].InitDataDirectory) then
    exit;
  if not assigned(FDConnection) then
    FDConnection := TADConnection.Create(nil); //20160226 Igor
//  result:= fGetSQLitePsw(lPsw); //20160303 Igor //20170117 Igor
//  if not result then exit;      //20160303 Igor //20170117 Igor
  if FDConnection.Connected then //20150820 igor
    FDConnection.Close;
  FDConnection.Params.Values['DataBase'] := DataBaseName;
  FDConnection.DriverName:='SQLite';                      //20150908 Igor
  //20150925 Igor

  if (pos(trim(UpperCase(ClientsTableLite)),trim(UpperCase(TableName))) = 1) or AReturn //20161028 Igor
    then FDConnection.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, AReturn) //20161208 Igor
                                                 //ifthen(not AReturn, lPsw.CurrentPassword, lPsw.RFCurrentPassword)     //20150925 Igor //20161028 Igor
    else FDConnection.Params.Values['Password'] := '';      //20150925 Igor
  try
    FDConnection.Connected := true;
  Except ON E: Exception DO
    Begin
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
  end;
  Result := FDConnection.Connected;
  if not Result then
    ErrorMsg('Cannot open ' + DataBaseName);
End;
//20170117 Igor <<<

function SetTableName(var FDConnection: TADConnection; var Table: TADTable;
                       DataBaseName, TableName, IndexName: string;
                       AUpdatePassword: Boolean = True): boolean; //20170112 Igor
begin
  Result := False;
  if not SetConnection(FDConnection,DataBaseName,TableName, False, AUpdatePassword) then exit; //20160226 Igor //20170112 Igor
  if not Assigned(Table) then
    Table := TADTable.Create(Nil);  //20160226 Igor
 Try
   If Table.Active then
     Table.Close;

   Table.Connection:= FDConnection;                        //20150908 Igor
   Table.TableName := TableName;
   Table.IndexName := UpperCase(IndexName);
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

function SqlLoadDBFromFile(FDConnection: TADConnection; Query1: TADQuery;
                           DBName: string;PathQryName: string): boolean;
var i:integer;
    fReplace:Boolean;
    lPsw:String;
begin
  if not SetConnection(FDConnection,DBName,ChangeFileExt(ExtractFileName(DBName),'')) then exit; //20160226 Igor
  if Not assigned(Query1) then
    Query1 := TADQuery.Create(nil);
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

end.
