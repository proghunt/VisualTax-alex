unit vtLockManager;
{
//20170228 Igor
}
interface

uses
  system.Classes, System.UITypes, System.Generics.Collections; //20170315 Igor

type
  TLockMode = (lmRead, lmReadWrite, lmCreate, lmNoAccess, lmDisableLock);//20170315 Igor

  TLockManager = class(TObject)
  private
    FStream: TFileStream;
    FFileName: String;
    FShadow: String;
    FLockMode: TLockMode;
    FComputerName: String;
    FUserName: String;
    FDateTimeLock: TDateTime;
    FLockMessage: String;
    FFileDateTimeUpdate: TDateTime; //20170315 Igor
    function GetFileChanged: Boolean; //20170315 Igor
  protected
    procedure TryLock;
  public
    constructor Create(AFileName: String; ALockMode: TLockMode);
    destructor Destroy; override;
    property LockMode: TLockMode read FLockMode;
    property LockMessage: String read FLockMessage;
    property FileDateTimeUpdate: TDateTime read FFileDateTimeUpdate; //20170315 Igor
    property FileChanged: Boolean read GetFileChanged; //20170315 Igor
    procedure UpdateFileAge; //20170315 Igor
  end;

implementation

uses
  Windows, System.SysUtils, VCL.Dialogs, vtMulti; //20170315 Igor
{ TLockManager }
//20170315 Igor >>>
var
  FLockManagerList: TObjectList<TLockManager>;
//20170315 Igor <<<

function GetComputerName: string;
var
  buffer: array[0..MAX_COMPUTERNAME_LENGTH + 1] of Char;
  Size: Cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  Windows.GetComputerName(@buffer, Size);
  Result := StrPas(buffer);
end;

function getUserName: String;
var
  BufSize: DWord;
begin
 BufSize := 1024;
 SetLength(Result, BufSize);
 if Windows.GetUserName(PChar(Result), BufSize) then
   SetLength(Result, BufSize-1)
 else
   RaiseLastOSError;
end;

constructor TLockManager.Create(AFileName: String; ALockMode: TLockMode);
begin
  inherited Create;
  //20170315 Igor >>>
  FLockManagerList.Add(Self);
  if MainOptions.LockManagerLevel = lmlDisableLock then
  begin
    FLockMode := lmDisableLock;
    Exit;
  end;
  //20170315 Igor <<<
  FLockMode := ALockMode;
  FComputerName := GetComputerName;
  FUserName := GetUserName;
  FFileName := AFileName;
  FDateTimeLock := Now;
  FShadow := ExtractFilePath(AFileName) + '~$' + ExtractFileName(AFileName);
  TryLock;
end;

destructor TLockManager.Destroy;
begin
  //20170315 Igor >>>
  if FLockManagerList.IndexOf(Self) <> -1 then
    FLockManagerList.Delete(FLockManagerList.IndexOf(Self));
  if assigned(FStream) then
    FStream.Free;
  if FileExists(FShadow) then
    DeleteFile(FShadow);
  //20170315 Igor <<<
  inherited;
end;

function TLockManager.GetFileChanged: Boolean; //20170315 Iogor
var
  dt: TDateTime;
begin
  if FLockMode in [lmDisableLock] then
    Exit(False);
  if not FileAge(FFileName, dt) then
    Exit(False);
  Result := FFileDateTimeUpdate <> dt;
end;

procedure TLockManager.TryLock;
type
  TTryState = (tsReadWrite, tsRead, tsNoAccess);
var
  TryState: TTryState;
  len: cardinal;
  oString: UTF8String;
begin
  if not (FLockMode in [lmReadWrite, lmCreate]) then
    exit;
  FreeAndNil(FStream);

  TryState := tsReadWrite;
  try
    if Not FileExists(FShadow) then
      FStream := TFileStream.Create(FShadow, fmCreate or fmShareDenyWrite)
    else
      FStream := TFileStream.Create(FShadow, fmOpenReadWrite or fmShareDenyWrite);
  except on E: Exception do
    begin
      TryState := tsRead;
    end;
  end;

  if TryState = tsRead then
  begin
    try
      if FileExists(FShadow) then
        FStream := TFileStream.Create(FShadow, fmOpenRead or fmShareDenyNone)
    except on E: Exception do
      begin
        TryState := tsNoAccess;
      end;
    end;
  end;

  if TryState = tsNoAccess then
    FLockMode := lmNoAccess
  else
  if TryState = tsRead then
  Begin
    len := 0;
    try
      if Assigned(FStream) then
        FStream.ReadBuffer(len, 4);
    except ON E: Exception DO
      begin
        FLockMode := lmNoAccess;
      end;
    end;
    if len > 0 then
    begin
      setLength(oString, len);
      FStream.ReadBuffer(oString[1], len);
      FLockMessage := string(oString);
      //20170315 Igor >>>
      if FLockMode = lmCreate then
      begin
        MessageDlg(FLockMessage, mtConfirmation, [mbOK], 0);
        FLockMode := lmNoAccess
      end
      else
      begin
        if MainOptions.LockManagerLevel = lmlDeniedMultiWrite then
        begin
          if MessageDlg(FLockMessage + #13 + 'Open in read-only mode?',
                        mtConfirmation, mbYesNoCancel, 0) <> idYes then
            FLockMode := lmNoAccess
          else
            FLockMode := lmRead;
        end
        else
          if MessageDlg(FLockMessage + #13 + 'Open anyway?',
                        mtConfirmation, mbYesNoCancel, 0) <> idYes then
            FLockMode := lmNoAccess
          else
            FLockMode := lmRead;
      end;
      //20170315 Igor <<<
    end
    else
    begin
      //20170315 Igor >>>
      if MainOptions.LockManagerLevel = lmlDeniedMultiWrite then
      begin
        if MessageDlg('The Return is locked by unknown process. Open in read-only mode?',
                      mtConfirmation, mbYesNoCancel, 0) <> idYes then
          FLockMode := lmNoAccess
        else
          FLockMode := lmRead;
      end;
      //20170315 Igor <<<
    end;
  End
  else
  begin
    FLockMessage := 'This Return opened by user "' + FUserName + //20170315 Igor
                    '" from computer "' + FComputerName + '" (Open time: '+ //20170315 Igor
                    DateTimeToStr(FDateTimeLock) + ')';
    oString := UTF8String(FLockMessage);
    len := length(oString);
    FStream.WriteBuffer(len, 4);
    if len > 0 then
      FStream.WriteBuffer(oString[1], len);
    //no change mode (readwrite or create)
  End;
  //20170315 Igor >>>
  if (FLockMode in [lmReadWrite, lmCreate]) then
    FileSetAttr(FShadow, faHidden);
  UpdateFileAge;
  //20170315 Igor <<<
end;

procedure TLockManager.UpdateFileAge; //20170315 Igor
begin
  if not FileAge(FFileName, FFileDateTimeUpdate) then
    FFileDateTimeUpdate := Now;
end;

//20170315 Igor >>>
procedure InitLockManagerList;
begin
  FLockManagerList := TObjectList<TLockManager>.Create(False);
end;

procedure DisposeLockManagerList;
var
  I: Integer;
begin
  while FLockManagerList.Count > 0 do
    FLockManagerList[0].Free;
  FLockManagerList.Free;
end;


initialization
  InitLockManagerList;

finalization
  DisposeLockManagerList;
//20170315 Igor <<<

end.
