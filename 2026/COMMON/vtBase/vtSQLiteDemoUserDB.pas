unit vtSQLiteDemoUserDB;

interface

uses System.Variants, System.SysUtils, Data.DB, System.DateUtils, vtIntDemoUserDB,
  uADCompClient;

type
  TSQLiteDemoUserDB = class(TInterfacedObject, IInterfaceDemoUserDB)
  private
    FADConnection: TADConnection;
    function isEmailExists(const aEmail: string; out aErrorString: string): boolean;
    function isBlockByDate(const aEmail: string; out aErrorString: string): boolean;
    function isBlockByState(const aEmail: string; out aErrorString: string): boolean;
    function isPasswordEqual(const aEmail, aPassword: string; out aErrorString: string): boolean;
    function GetEmail(const aPassword: string; out aEmail, aErrorString: string): Boolean;
  public
    function Connect(const aConnectStr: string; const aPwdArr: variant;
      const aCanCreate: boolean; out aErrorString: string): boolean;
    function PrepareDataBase(out aErrorString: string): boolean;
    function AddUser(const aEmail, aPhone, aName: string; out aErrorString: string): boolean;
    function SetPassword(const aEmail, aPassword: string; out aErrorString: string): boolean;
    function SetEndDate(const aPassword: string; const aEndDate: TDateTime; out aErrorString: string): boolean;
    function SendRegMail(const aPassword: string; out aErrorString: string): boolean;
    function SetExeDir(const aPassword, aExeDir: string; out aErrorString: string): boolean;
    function GetExeDir(const aPassword: string;out aExeDir: string; out aErrorString: string): boolean;
    function BlockUser(const aPassword: string; out aErrorString: string): boolean;
    function UnBlockUser(const aPassword: string; out aErrorString: string): boolean;
    function LogOn(const aPassword: string; out aErrorString: string): boolean;
  end;

implementation

const
  c_UserData_DDL =
      'create table if not exists `UserData`('+
        '`Email` VARCHAR(125) PRIMARY KEY NOT NULL,'+
        '`Phone` VARCHAR(25) NOT NULL,'+
        '`Name` VARCHAR(125) NOT NULL,'+
        '`RegDate` INTEGER NOT NULL,'+
        '`isRegEmailSent` INTEGER NOT NULL,'+
        '`Password` TEXT UNIQUE,'+
        '`EndDate` INTEGER NULL,'+
        '`ExeDir` TEXT,'+
        '`isBlocked` INTEGER NOT NULL,'+
        '`LastLogonDate` INTEGER'+
      ' )';

{ TSQLiteDemoUserDB }

function TSQLiteDemoUserDB.AddUser(const aEmail, aPhone, aName: string;
  out aErrorString: string): boolean;
begin
  if Trim(aEmail) = '' then
  begin
    aErrorString := 'Email should not be empty.';
    Result := False;
    Exit;
  end;
  if Trim(aPhone) = '' then
  begin
    aErrorString := 'Phone should not be empty.';
    Result := False;
    Exit;
  end;
  if Trim(aName) = '' then
  begin
    aErrorString := 'Name should not be empty.';
    Result := False;
    Exit;
  end;
  Result := not isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('Insert into `UserData` (`Email`, `Phone`, ' +
      '`Name`, `RegDate`, `isRegEmailSent`, `isBlocked`, `ExeDir`, `EndDate`) Values '+
      '(:Email, :Phone, :Name, :RegDate, :isRegEmailSent, :isBlocked, :ExeDir, :EndDate)',
      [aEmail, aPhone, aName, DateTimeToUnix(Now), False, False, TGUID.NEWGUID.ToString, DateTimeToUnix(Now + 14)],
      [ftString, ftString, ftString, ftInteger, ftBoolean, ftBoolean, ftString, ftInteger]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write data error: ' + e.Message;
      Result := False;
      Exit;
    End;
  end;
  Result := True;
end;

function TSQLiteDemoUserDB.BlockUser(const aPassword: string; out aErrorString: string): boolean;
var
  aEmail: string;
begin
  Result := GetEmail(aPassword, aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('update `UserData` SET `isBlocked` = 1 WHERE `Email` = :Email', [aEmail], [ftString]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write data error';
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteDemoUserDB.Connect(const aConnectStr: string;
  const aPwdArr: variant; const aCanCreate: boolean; out aErrorString: string): boolean;
begin
  FADConnection := TADConnection.Create(nil);
  FADConnection.DriverName := 'Sqlite';
  FADConnection.LoginPrompt := false;
  FADConnection.Params.Values['Database'] := aConnectStr;
  FADConnection.Params.Values['Password'] := '';//VarArrayGet(aPwdArr, [VarArrayHighBound(aPwdArr, 1)]);
  FADConnection.Params.Values['LockingMode'] := 'Normal';
  try
    FADConnection.Open;
  except on E: Exception do
    begin
      aErrorString := E.Message;
      Result := False;
      Exit;
    end;
  end;
  Result := FADConnection.Connected;
end;

function TSQLiteDemoUserDB.GetEmail(const aPassword: string; out aEmail,
  aErrorString: string): Boolean;
begin
  try
    with TADQuery.Create(nil) do
    begin
      try
        Connection := FADConnection;
        SQL.Text := 'select Email from `UserData` where Password = ' + QuotedStr(aPassword);
        Open;
        Result := not IsEmpty;
        if not Result then
          aErrorString := 'EMail not found.'
        else
        begin
          aEmail := FieldByName('Email').AsString;
          Result := True;
        end;
      finally
        Free;
      end;
    end;
  except
    on E:Exception do begin
      Result := False;
      aErrorString := 'Get Email. Error = ' + E.Message;
    end;
  end;
end;

function TSQLiteDemoUserDB.GetExeDir(const aPassword: string; out aExeDir,
  aErrorString: string): boolean;
var
  aEmail: string;
begin
  Result := GetEmail(aPassword, aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    with TADQuery.Create(nil) do
    begin
      try
        Connection := FADConnection;
        SQL.Text := 'select ExeDir from `UserData` where Email = ' + QuotedStr(aEmail); // 20180904 Igor
        Open;
        Result := not IsEmpty;
        if not Result then
          aErrorString := 'EMail not found.'
        else
        begin
          aExeDir := FieldByName('ExeDir').AsString;
          Result := True;
        end;
      finally
        Free;
      end;
    end;
  except
    on E:Exception do begin
      Result := False;
      aErrorString := 'Check ExeDir. Error = ' + E.Message;
    end;
  end;
end;

function TSQLiteDemoUserDB.isBlockByDate(const aEmail: string;
  out aErrorString: string): boolean;
begin
  try
    with TADQuery.Create(nil) do
    begin
      try
        Connection := FADConnection;
        SQL.Text := 'select EndDate from `UserData` where Email = ' + QuotedStr(aEmail); // 20180904 Igor
        Open;
        Result := not IsEmpty;
        if not Result then
          aErrorString := 'EMail not found.'
        else
        begin
          Result := UnixToDateTime(FieldByName('EndDate').AsInteger) > Now;
          if not Result then
            aErrorString := 'Block by EndDate.'
        end;
      finally
        Free;
      end;
    end;
  except
    on E:Exception do begin
      Result := False;
      aErrorString := 'Check EndDate. Error = ' + E.Message;
    end;
  end;
end;

function TSQLiteDemoUserDB.isBlockByState(const aEmail: string;
  out aErrorString: string): boolean;
begin
  try
    with TADQuery.Create(nil) do
    begin
      try
        Connection := FADConnection;
        SQL.Text := 'select isBlocked from `UserData` where Email = ' + QuotedStr(aEmail); // 20180904 Igor
        Open;
        Result := not IsEmpty;
        if not Result then
          aErrorString := 'EMail not found.'
        else
        begin
          Result := FieldByName('isBlocked').AsInteger = 0;
          if not Result then
            aErrorString := 'Block by isBlocked.'
        end;
      finally
        Free;
      end;
    end;
  except
    on E:Exception do begin
      Result := False;
      aErrorString := 'Check isBlocked. Error = ' + E.Message;
    end;
  end;
end;

function TSQLiteDemoUserDB.isEmailExists(const aEmail: string;
  out aErrorString: string): boolean;
begin
  try
    with TADQuery.Create(nil) do
    begin
      try
        Connection := FADConnection;
        SQL.Text := 'select 1 from UserData where Email = ' + QuotedStr(aEmail); // 20180904 Igor
        Open;
        Result := not IsEmpty;
        if not Result then
          aErrorString := 'EMail not found.'
        else
          aErrorString := 'Key send to email. Check inbox and spam folder. Or call (905) 238-6159.';
      finally
        Free;
      end;
    end;
  except
    on E:Exception do begin
      Result := False;
      aErrorString := 'Check EMail. Error = ' + E.Message;
    end;
  end;
end;

function TSQLiteDemoUserDB.isPasswordEqual(const aEmail, aPassword: string;
  out aErrorString: string): boolean;
begin
  try
    with TADQuery.Create(nil) do
    begin
      try
        Connection := FADConnection;
        SQL.Text := 'select 1 from `UserData` where Email = ' + QuotedStr(aEmail) // 20180904 Igor
          + ' and Password = ' + QuotedStr(aPassword);
        Open;
        Result := not IsEmpty;
        if not Result then
          aErrorString := 'Password wrong.';
      finally
        Free;
      end;
    end;
  except
    on E:Exception do begin
      Result := False;
      aErrorString := 'Check Password. Error = ' + E.Message;
    end;
  end;
end;

function TSQLiteDemoUserDB.LogOn(const aPassword: string; out aErrorString: string): boolean;
var
  aEmail: string;
begin
  Result := GetEmail(aPassword, aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isBlockByDate(aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isBlockByState(aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isPasswordEqual(aEmail, aPassword, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('update `UserData` SET `LastLogonDate` = :aDate WHERE `Email` = :Email', [Now, aEmail], [ftDateTime, ftString]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write data error: '+ E.Message;
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteDemoUserDB.PrepareDataBase(out aErrorString: string): boolean;
begin
  try
    FADConnection.ExecSQL(c_UserData_DDL);
  except on E: Exception do
    begin
      aErrorString := 'An error occurred during file preparation for recording: '+ E.Message;
      Result := False;
      exit;
    end;
  end;
  Result := True;
end;

function TSQLiteDemoUserDB.SendRegMail(const aPassword: string; out aErrorString: string): boolean;
var
  aEmail: string;
begin
  Result := GetEmail(aPassword, aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('update `UserData` SET `isRegEmailSent` = 1 WHERE `Email` = :Email', [aEmail], [ftString]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write data error: '+ E.Message;
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteDemoUserDB.SetExeDir(const aPassword, aExeDir: string;
  out aErrorString: string): boolean;
var
  aEmail: string;
begin
  Result := GetEmail(aPassword, aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('update `UserData` SET `ExeDir` = :aExeDir WHERE `Email` = :Email', [aExeDir, aEmail], [ftString, ftString]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write ExeDir error: '+ E.Message; // 20180904 Igor
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteDemoUserDB.SetEndDate(const aPassword: string;
  const aEndDate: TDateTime; out aErrorString: string): boolean;
var
  aEmail: string;
begin
  Result := GetEmail(aPassword, aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('update `UserData` SET `EndDate` = :EndDate WHERE `Email` = :Email', [aEndDate, aEmail], [ftDateTime, ftString]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write data error: '+ E.Message; // 20180904 Igor
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteDemoUserDB.SetPassword(const aEmail, aPassword: string;
  out aErrorString: string): boolean;
begin
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('update `UserData` SET `Password` = :Password WHERE `Email` = :Email', [aPassword, aEmail], [ftString, ftString]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write Password error: '+ E.Message; // 20180904 Igor
      Result := False;
      Exit;
    End;
  end;
end;

function TSQLiteDemoUserDB.UnBlockUser(const aPassword: string; out aErrorString: string): boolean;
var
  aEmail: string;
begin
  Result := GetEmail(aPassword, aEmail, aErrorString);
  if not Result then
    Exit;
  Result := isEmailExists(aEmail, aErrorString);
  if not Result then
    Exit;
  try
    FADConnection.ExecSQL('update `UserData` SET `isBlocked` = 0 WHERE `Email` = :Email', [aEmail], [ftString]);
  except ON E: Exception DO
    Begin
      aErrorString := 'Write data error: '+ E.Message; // 20180904 Igor
      Result := False;
      Exit;
    End;
  end;
end;

end.
