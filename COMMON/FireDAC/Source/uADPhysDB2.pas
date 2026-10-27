{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{              FireDAC ODBC IBM DB2 driver              }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysDB2"'}

unit uADPhysDB2;

interface

uses
  Classes, 
  uADStanError, 
  uADPhysManager, uADPhysODBCCli, uADPhysODBCWrapper, uADPhysODBCBase;

type
  EDB2NativeException = class;
  TADPhysDB2DriverLink = class;

  EDB2NativeException = class(EODBCNativeException)
  public
    function AppendError(AHandle: TODBCHandle; ARecNum: SQLSmallint;
      const ASQLState: String; ANativeError: SQLInteger; const ADiagMessage,
      AResultMessage, ACommandText, AObject: String; AKind: TADCommandExceptionKind;
      ACmdOffset, ARowIndex: Integer): TADDBError; override;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADPhysDB2DriverLink = class(TADPhysODBCBaseDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  StrUtils,
{$ENDIF}
  uADStanConst, uADStanIntf, uADStanUtil, uADStanStorage,
  uADPhysIntf, uADPhysCmdGenerator, uADPhysDB2Meta;

type
  TADPhysDB2Driver = class;
  TADPhysDB2Connection = class;

  TADPhysDB2Driver = class(TADPhysODBCDriverBase)
  protected
    class function GetBaseDriverID: String; override;
    procedure InternalLoad; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName, AType,
      ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  end;

  TADPhysDB2Connection = class(TADPhysODBCConnectionBase)
  private
    procedure UpdateCurrentSchema;
  protected
    function InternalCreateCommandGenerator(const ACommand:
      IADPhysCommand): TADPhysCommandGenerator; override;
    function InternalCreateCommand: TADPhysCommand; override;
    function InternalCreateMetadata: TObject; override;
    procedure GetStrsMaxSizes(AStrDataType: SQLSmallint; AFixedLen: Boolean;
      out ACharSize, AByteSize: Integer); override;
    procedure UpdateDecimalSep; override;
    procedure SetupConnection; override;
    function GetExceptionClass: EODBCNativeExceptionClass; override;
  end;

  TADPhysDB2Command = class(TADPhysODBCCommand)
  protected
    function InternalOpen: Boolean; override;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: TADCounter); override;
  end;

const
  S_AD_Choose = 'Choose';
  S_AD_Unicode = 'Unicode';

{-------------------------------------------------------------------------------}
{ EDB2NativeException                                                           }
{-------------------------------------------------------------------------------}
function EDB2NativeException.AppendError(AHandle: TODBCHandle;
  ARecNum: SQLSmallint; const ASQLState: String; ANativeError: SQLInteger;
  const ADiagMessage, AResultMessage, ACommandText, AObject: String;
  AKind: TADCommandExceptionKind; ACmdOffset, ARowIndex: Integer): TADDBError;
var
  sObj: String;

  procedure ExtractObjName;
  var
    i1, i2: Integer;
  begin
    i1 := Pos('"', ADiagMessage);
    if i1 <> 0 then begin
      i2 := ADPosEx('"', ADiagMessage, i1 + 1);
      if i2 <> 0 then
        sObj := Copy(ADiagMessage, i1 + 1, i2 - i1 - 1);
    end;
  end;

begin
  // following is not supported by DB2:
  // ekUserPwdExpired
  // ekUserPwdWillExpire
  // ekRecordLocked
  sObj := AObject;
  case ANativeError of
   100:
    AKind := ekNoDataFound;
  -803:
    begin
      AKind := ekUKViolated;
      // first "xxxx" - constraint
      // second "xxxx" - table name
      ExtractObjName;
    end;
  -530:
    begin
      AKind := ekFKViolated;
      // first "xxxx" - constraint
      ExtractObjName;
    end;
  -204:
    begin
      AKind := ekObjNotExists;
      // first "xxxx" - table name
      ExtractObjName;
    end;
  -30082:
    AKind := ekUserPwdInvalid;
  end;
  Result := inherited AppendError(AHandle, ARecNum, ASQLState, ANativeError,
    ADiagMessage, AResultMessage, ACommandText, sObj, AKind, ACmdOffset,
    ARowIndex);
end;

{-------------------------------------------------------------------------------}
{ TADPhysDB2DriverLink                                                          }
{-------------------------------------------------------------------------------}
function TADPhysDB2DriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_DB2Id;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDB2Driver                                                              }
{-------------------------------------------------------------------------------}
class function TADPhysDB2Driver.GetBaseDriverID: String;
begin
  Result := S_AD_DB2Id;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDB2Driver.InternalLoad;
begin
  ODBCAdvanced := 'IGNOREWARNINGS=1';
  inherited InternalLoad;
  if ODBCDriver = '' then
    ODBCDriver := FindBestDriver(['IBM DATA SERVER DRIVER for ODBC%',
      'IBM DB2 ODBC DRIVER%', 'IBM DB2 DRIVER FOR ODBC%']);
end;

{-------------------------------------------------------------------------------}
function TADPhysDB2Driver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysDB2Connection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDB2Driver.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  AKeywords.Add(S_AD_ConnParam_DB2_Alias + '=DBALIAS');
  AKeywords.Add(S_AD_ConnParam_Common_Database);
  AKeywords.Add(S_AD_ConnParam_Common_Server + '=HOSTNAME');
  AKeywords.Add(S_AD_ConnParam_Common_Port);
  AKeywords.Add(S_AD_ConnParam_DB2_Protocol);
  AKeywords.Add('=IGNOREWARNINGS');
end;

{-------------------------------------------------------------------------------}
function TADPhysDB2Driver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 9;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDB2Driver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex)
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_DB2_Alias;
        AType := '@S';
        ALoginIndex := 2;
      end;
    1:
      begin
        AName := S_AD_ConnParam_Common_Server;
        AType := '@S';
      end;
    2:
      begin
        AName := S_AD_ConnParam_Common_Port; // 50000
        AType := '@I';
      end;
    3:
      begin
        AName := S_AD_ConnParam_DB2_Protocol;
        AType := '@S';
      end;
    4:
      begin
        AName := S_AD_ConnParam_DB2_Trusted;
        AType := '@Y';
      end;
    5:
      begin
        AName := S_AD_ConnParam_DB2_StringFormat;
        AType := S_AD_Choose + ';' + S_AD_Unicode;
        ADefVal := S_AD_Choose;
      end;
    6:
      begin
        AName := S_AD_ConnParam_Common_ExtendedMetadata;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
    7:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
      end;
    8:
      begin
        AName := S_AD_ConnParam_Common_MetaCurSchema;
        AType := '@S';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDB2Connection                                                          }
{-------------------------------------------------------------------------------}
function TADPhysDB2Connection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysDB2Command.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysDB2Connection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysDb2CommandGenerator.Create(ACommand)
  else
    Result := TADPhysDb2CommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysDB2Connection.InternalCreateMetadata: TObject;
var
  iSrvVer, iClntVer: TADVersion;
begin
  GetVersions(iSrvVer, iClntVer);
  Result := TADPhysDb2Metadata.Create(Self, iSrvVer, iClntVer, GetKeywords);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDB2Connection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen: Boolean; out ACharSize: Integer; out AByteSize: Integer);
begin
  // char - 254
  // varchar - 32672
  // long varchar - 32700
  // clob - 2147483647
  // graphic - 127 * 2
  // vargraphic - 16336 * 2
  // long vargraphic - 16350 * 2
  // dbclob - 1073741823 * 2
  // blob - 2147483647
  case AStrDataType of
  SQL_C_CHAR, SQL_C_BINARY:
    begin
      if AFixedLen then
        AByteSize := 254
      else
        AByteSize := 32672;
      ACharSize := AByteSize;
    end;
  SQL_C_WCHAR:
    begin
      if AFixedLen then
        AByteSize := 254
      else
        AByteSize := 32672;
      ACharSize := AByteSize div SizeOf(SQLWChar);
    end;
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_DB2Id]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDB2Connection.UpdateDecimalSep;
var
  oStmt: TODBCCommandStatement;
  oCol: TODBCVariable;
  pData: SQLPointer;
  iSize: SQLLen;
  sNum: String;
begin
  inherited UpdateDecimalSep;
  try
    oStmt := TODBCCommandStatement.Create(ODBCConnection);
    try
      oStmt.Open(1, 'SELECT 12.34 FROM SYSIBM.SYSDUMMY1');
      oCol := oStmt.AddCol(1, SQL_NUMERIC, SQL_C_CHAR);
      oStmt.Fetch(1);
      oCol.GetData(0, pData, iSize, True);
      sNum := ODBCConnection.Encoder.Decode(pData, iSize, ecANSI);
      ODBCConnection.DecimalSepCol := sNum[3];
    finally
      ADFree(oStmt);
    end;
  except
    // silent
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDB2Connection.GetExceptionClass: EODBCNativeExceptionClass;
begin
  Result := EDB2NativeException;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDB2Connection.SetupConnection;
begin
  inherited SetupConnection;
  if GetConnectionDef.HasValue(S_AD_ConnParam_DB2_Trusted) and
     GetConnectionDef.AsYesNo[S_AD_ConnParam_DB2_Trusted] then
    ODBCConnection.USE_TRUSTED_CONTEXT := SQL_TRUE;
  if CompareText(GetConnectionDef.AsString[S_AD_ConnParam_DB2_StringFormat], S_AD_Unicode) = 0 then
    ODBCConnection.MAPCHAR := SQL_MAPCHAR_WCHAR;
  if GetConnectionDef.AsBoolean[S_AD_ConnParam_Common_ExtendedMetadata] then
    ODBCConnection.DESCRIBE_OUTPUT_LEVEL := '3';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDB2Connection.UpdateCurrentSchema;
var
  oStmt: TODBCCommandStatement;
  oCol: TODBCVariable;
  pData: SQLPointer;
  iSize: SQLLen;
begin
  oStmt := TODBCCommandStatement.Create(ODBCConnection);
  try
    oStmt.Open(1, 'SELECT CURRENT_SCHEMA FROM SYSIBM.SYSDUMMY1');
    oCol := oStmt.AddCol(1, SQL_VARCHAR, SQL_C_CHAR, 30);
    oStmt.Fetch(1);
    oCol.GetData(0, pData, iSize, True);
    FCurrentSchema := ODBCConnection.Encoder.Decode(pData, iSize, ecANSI);
  finally
    ADFree(oStmt);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDB2Command                                                             }
{-------------------------------------------------------------------------------}
procedure TADPhysDB2Command.InternalExecute(ATimes, AOffset: Integer;
  var ACount: TADCounter);
begin
  inherited InternalExecute(ATimes, AOffset, ACount);
  if GetCommandKind = skSetSchema then
    TADPhysDB2Connection(FConnectionObj).UpdateCurrentSchema;
end;

{-------------------------------------------------------------------------------}
function TADPhysDB2Command.InternalOpen: Boolean;
begin
  Result := inherited InternalOpen;
  if GetCommandKind = skSetSchema then
    TADPhysDB2Connection(FConnectionObj).UpdateCurrentSchema;
end;

{-------------------------------------------------------------------------------}
function DB2NativeExceptionLoad(AStorage: TADStorage): TObject;
begin
  Result := EDB2NativeException.Create;
  EDB2NativeException(Result).LoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysDB2Driver);
  ADStorageManager().RegisterClass(EDB2NativeException, 'DB2NativeException',
    @DB2NativeExceptionLoad, @ADExceptionSave);

end.
