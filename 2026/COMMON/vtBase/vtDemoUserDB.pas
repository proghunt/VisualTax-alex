unit vtDemoUserDB;

interface

uses Windows, vtIntDemoUserDB, vtSendMail;

type
  TDemoUserDB = class
  private
    FSM: TSendMail;
    FDB: IInterfaceDemoUserDB;
    FConnectStr: string;
    FPwdArr: Variant;
    FLastError: String;
    FMutex: THandle;
    procedure GetMutex;
    procedure ReleaseMutex;
  public
    constructor Create(const aDB: IInterfaceDemoUserDB; const aConnectStr: string;
      const aPwdArr: Variant; const aCanCreate: boolean);//aConnectStr - for sqllite - filepath, for mysql - host:port or filepath
    destructor Destroy; override;

    function AddUser(const aEmail, aPhone, aName: string): boolean;
    function SetPassword(const aEmail, aPassword: string): boolean;
    function SetEndDate(const aEmail: string; const aEndDate: TDateTime): boolean;
    function SendRegMail(const aEmail: string): boolean;
    function BlockUser(const aEmail: string): boolean;
    function UnBlockUser(const aEmail: string): boolean;
    function LogOn(const aPassword: string): boolean;
    function GetExeDir(const aPassword: string; out aExeDir: string): boolean;

    property LastError: String read FLastError;
  end;
implementation

function RandomPassword(PLen: Integer): string;
var
  aStr: string;
begin
  Randomize;
  //string with all possible chars
  aStr := 'abcdefghijklmnopqrstuvwxyz0123456789';
  Result := '';
  repeat
    Result := Result + aStr[Random(Length(aStr)) + 1];
  until (Length(Result) = PLen)
end;

{ TDemoUserDB }

function TDemoUserDB.AddUser(const aEmail, aPhone, aName: string): boolean;
var
  aPassword: string;
  inum: integer;
begin
  GetMutex;
  try
    Result := FDB.AddUser(aEmail, aPhone, aName, FLastError);
  finally
    ReleaseMutex;
  end;
  if Result then begin
    inum := 10;
    //generate and write key in db
    while inum > 0 do begin
      aPassword := RandomPassword(10);
      GetMutex;
      try
        Result := FDB.SetPassword(aEmail, aPassword, FLastError);
      finally
        ReleaseMutex;
      end;
      if Result then
        Break;
      dec(inum);
    end;
    if not Result then
    begin
      //FLastError := 'The key will be generated'; // 20180904 Igor
      Exit;
    end;
    //write status about send mail in db
    GetMutex;
    try
      Result := FDB.SendRegMail(aPassword, FLastError);
    finally
      ReleaseMutex;
    end;
    //send email to client
    Result := FSM.SendMail('virtualui@visualtax.com', aEmail, 'visual tax key', aPassword, FLastError); // 20180816 Igor
    if not Result then
      FLastError := 'The key will be generated';
    //send email to support
    FSM.SendMail('virtualui@visualtax.com', 'Support@visualtax.com', 'visual tax key', aPassword, FLastError); // 20180816 Igor
  end;
end;

function TDemoUserDB.BlockUser(const aEmail: string): boolean;
begin
  Result := FDB.BlockUser(aEmail, FLastError);
end;

constructor TDemoUserDB.Create(const aDB: IInterfaceDemoUserDB; const aConnectStr: string;
  const APwdArr: Variant; const aCanCreate: boolean);
var
  ErrorString: string;
begin
  FDB := aDB;
  FConnectStr := aConnectStr;
  FPwdArr := APwdArr;
  GetMutex;
  try
    if not FDB.Connect(FConnectStr, FPwdArr, aCanCreate, ErrorString) then
    begin
      FLastError := 'Error open: ' + FConnectStr + #13 + ErrorString;
      Exit;
    end;
  finally
    ReleaseMutex;
  end;
  if aCanCreate then
  begin
    GetMutex;
    try
      if not FDB.PrepareDataBase(ErrorString) then
      begin
        FLastError := 'Error prepare: ' + FConnectStr + #13 + ErrorString;
        Exit;
      end;
    finally
      ReleaseMutex;
    end;
  end;
  FSM := TSendMail.Create;
end;

destructor TDemoUserDB.Destroy;
begin
  FSM.Free;
  inherited;
end;

function TDemoUserDB.GetExeDir(const aPassword: string;
  out aExeDir: string): boolean;
begin
  GetMutex;
  try
    Result := FDB.GetExeDir(aPassword, aExeDir, FLastError);
  finally
    ReleaseMutex;
  end;
end;

procedure TDemoUserDB.GetMutex;
begin
  FMutex := CreateMutex(nil, false, 'TDemoUserDB');
  WaitForSingleObject(FMutex, INFINITE);
end;

function TDemoUserDB.LogOn(const aPassword: string): boolean;
begin
  GetMutex;
  try
    Result := FDB.LogOn(aPassword, FLastError);
  finally
    ReleaseMutex;
  end;
end;

procedure TDemoUserDB.ReleaseMutex;
begin
  Windows.ReleaseMutex(FMutex);
end;

function TDemoUserDB.SendRegMail(const aEmail: string): boolean;
begin
  GetMutex;
  try
    Result := FDB.SendRegMail(aEmail, FLastError);
  finally
    ReleaseMutex;
  end;
end;

function TDemoUserDB.SetEndDate(const aEmail: string;
  const aEndDate: TDateTime): boolean;
begin
  GetMutex;
  try
    Result := FDB.SetEndDate(aEmail, aEndDate, FLastError);
  finally
    ReleaseMutex;
  end;
end;

function TDemoUserDB.SetPassword(const aEmail, aPassword: string): boolean;
begin
  GetMutex;
  try
    Result := FDB.SetPassword(aEmail, aPassword, FLastError);
  finally
    ReleaseMutex;
  end;
end;

function TDemoUserDB.UnBlockUser(const aEmail: string): boolean;
begin
  GetMutex;
  try
    Result := FDB.UnBlockUser(aEmail, FLastError);
  finally
    ReleaseMutex;
  end;
end;

end.
