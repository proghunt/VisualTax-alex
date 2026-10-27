{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{             FireDAC ODBC MS Access driver             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysMSAcc"'}

unit uADPhysMSAcc;

interface

uses
  Classes,
  uADStanError, 
  uADPhysManager, uADPhysODBCCli, uADPhysODBCWrapper, uADPhysODBCBase;

type
  EMSAccessNativeException = class;
  TADPhysMSAccessDriverLink = class;
  TADMSAccessService = class;

  EMSAccessNativeException = class(EODBCNativeException)
  public
    function AppendError(AHandle: TODBCHandle; ARecNum: SQLSmallint;
      const ASQLState: String; ANativeError: SQLInteger; const ADiagMessage,
      AResultMessage, ACommandText, AObject: String; AKind: TADCommandExceptionKind;
      ACmdOffset, ARowIndex: Integer): TADDBError; override;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADPhysMSAccessDriverLink = class(TADPhysODBCBaseDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

  TADMSAccessDBVersion = (avDefault, avAccess2, avAccess95, avAccess97,
    avAccess2000, avAccess2003, avAccess2007);
  TADMSAccessAction = (aaCompactDB, aaRepairDB, aaCreateDB, aaDropDB);
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADMSAccessService = class (TADPhysODBCBaseService)
  private
    FAction: TADMSAccessAction;
    FDatabase: String;
    FDestDatabase: String;
    FDBVersion: TADMSAccessDBVersion;
    FSortOrder: String;
    FEncrypted: Boolean;
    FPassword: String;
    FResetPassword: Boolean;
    function GetDriverLink: TADPhysMSAccessDriverLink;
    procedure SetDriverLink(const AValue: TADPhysMSAccessDriverLink);
  protected
    procedure InternalExecute; override;
  public
    procedure CreateDB;
    procedure Drop;
    procedure Repair;
    procedure Compact;
  published
    property DriverLink: TADPhysMSAccessDriverLink read GetDriverLink write SetDriverLink;
    property Database: String read FDatabase write FDatabase;
    property DestDatabase: String read FDestDatabase write FDestDatabase;
    property SortOrder: String read FSortOrder write FSortOrder;
    property DBVersion: TADMSAccessDBVersion read FDBVersion write FDBVersion default avDefault;
    property Encrypted: Boolean read FEncrypted write FEncrypted default False;
    property Password: String read FPassword write FPassword;
    property ResetPassword: Boolean read FResetPassword write FResetPassword default False;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF MSWINDOWS}
  // Preventing from "Inline has not expanded"
  Windows, ComObj,
{$ENDIF}
{$IFDEF POSIX}
  Posix.UniStd,
{$ENDIF}
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}  
  uADStanConst, uADStanResStrs, uADStanIntf, uADStanUtil, uADStanStorage,
  uADPhysIntf, uADPhysCmdGenerator, uADPhysMSAccMeta;

type
  TADPhysMSAccessDriver = class;
  TADPhysMSAccessConnection = class;

  TADPhysMSAccessDriver = class(TADPhysODBCDriverBase)
  protected
    class function GetBaseDriverID: String; override;
    procedure InternalLoad; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName,
      AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  end;

  TADPhysMSAccessConnection = class(TADPhysODBCConnectionBase)
  private
    FStringFormat: TADDataType;
  protected
    function InternalCreateCommandGenerator(const ACommand:
      IADPhysCommand): TADPhysCommandGenerator; override;
    function InternalCreateMetadata: TObject; override;
    procedure InternalConnect; override;
    procedure GetStrsMaxSizes(AStrDataType: SQLSmallint; AFixedLen: Boolean;
      out ACharSize, AByteSize: Integer); override;
    function GetStrsType: TADDataType; override;
    function GetExceptionClass: EODBCNativeExceptionClass; override;
  end;

const
  S_AD_Choose = 'Choose';
  S_AD_Unicode = 'Unicode';
  S_AD_ANSI = 'ANSI';

{-------------------------------------------------------------------------------}
{ EMSAccessNativeException                                                      }
{-------------------------------------------------------------------------------}
function EMSAccessNativeException.AppendError(AHandle: TODBCHandle;
  ARecNum: SQLSmallint; const ASQLState: String; ANativeError: SQLInteger;
  const ADiagMessage, AResultMessage, ACommandText, AObject: String;
  AKind: TADCommandExceptionKind; ACmdOffset, ARowIndex: Integer): TADDBError;
var
  sObj: String;

  procedure ExtractObjName;
  var
    i1, i2: Integer;
  begin
    i1 := Pos('''', ADiagMessage);
    if i1 <> 0 then begin
      i2 := ADPosEx('''', ADiagMessage, i1 + 1);
      if i2 <> 0 then
        sObj := Copy(ADiagMessage, i1 + 1, i2 - i1 - 1);
    end;
  end;

begin
  // following is not supported by MSAccess:
  // ekNoDataFound
  // ekUserPwdExpired
  // ekUserPwdWillExpire
  sObj := AObject;
  case ANativeError of
  -1102:
    AKind := ekRecordLocked;
  -1605:
    AKind := ekUKViolated;
  -1613:
    AKind := ekFKViolated;
  -1305:
    begin
      AKind := ekObjNotExists;
      // first 'xxxx' - object name
      ExtractObjName;
    end;
  -1905:
    AKind := ekUserPwdInvalid;
  end;
  Result := inherited AppendError(AHandle, ARecNum, ASQLState, ANativeError,
    ADiagMessage, AResultMessage, ACommandText, sObj, AKind, ACmdOffset, ARowIndex);
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSAccessDriverLink                                                     }
{-------------------------------------------------------------------------------}
function TADPhysMSAccessDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_MSAccId;
end;

{-------------------------------------------------------------------------------}
{ TADMSAccessService                                                            }
{-------------------------------------------------------------------------------}
function TADMSAccessService.GetDriverLink: TADPhysMSAccessDriverLink;
begin
  Result := inherited DriverLink as TADPhysMSAccessDriverLink;
end;

{-------------------------------------------------------------------------------}
procedure TADMSAccessService.SetDriverLink(const AValue: TADPhysMSAccessDriverLink);
begin
  inherited DriverLink := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMSAccessService.CreateDB;
begin
  FAction := aaCreateDB;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADMSAccessService.Drop;
begin
  FAction := aaDropDB;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADMSAccessService.Compact;
begin
  FAction := aaCompactDB;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADMSAccessService.Repair;
begin
  FAction := aaRepairDB;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADMSAccessService.InternalExecute;
var
  sStr, sDrv, sDb: String;
  lSort, lLastDrv: Boolean;

  function NormFileName(AName: String): String;
  begin
    Result := ADExpandStr(AName);
    if (Pos(' ', Result) > 0) and (Result <> '') and (Result[1] <> '"') then
      Result := '"' + Result + '"';
  end;

  procedure DeleteDatabase(const AName: String);
  var
    sFile: String;
  begin
    sFile := ADExpandStr(AName);
    SysUtils.DeleteFile(sFile);
    SysUtils.DeleteFile(ChangeFileExt(sFile, '.ldb'));
    SysUtils.DeleteFile(ChangeFileExt(sFile, '.laccdb'));
  end;

{$IFDEF MSWINDOWS}
  function RenameDatabase(const AOldName, ANewName: String): Boolean;
  var
    sOldFile, sNewFile, sLdbFile: String;
  begin
    sOldFile := ADExpandStr(AOldName);
    sNewFile := ADExpandStr(ANewName);
    Result := RenameFile(sOldFile, sNewFile);
    if Result then begin
      sLdbFile := ChangeFileExt(sOldFile, '.ldb');
      if FileExists(sLdbFile) then
        RenameFile(sLdbFile, ChangeFileExt(sNewFile, '.ldb'));
      sLdbFile := ChangeFileExt(sOldFile, '.laccdb');
      if FileExists(sLdbFile) then
        RenameFile(sLdbFile, ChangeFileExt(sNewFile, '.laccdb'));
    end;
  end;

  function GenTempFileName(const AName: String): String;
  var
    sPath: String;
  begin
    sPath := ExtractFilePath(ADExpandStr(AName));
    SetLength(Result, MAX_PATH);
    GetTempFileName(PChar(sPath), 'AD', 0, PChar(Result));
    Result := PChar(Result);
  end;

  procedure ProcessOLEException(AExc: EOleSysError);
  var
    sMsg: String;
    iCode: Integer;
    oExc: EADDBEngineException;
    oErr: TADDBError;
  begin
    sMsg := AExc.Message;
    iCode := er_AD_AccUnknownOleError;
    if AExc is EOLEException then begin
      if Pos('Class not registered', sMsg) > 0 then
        iCode := er_AD_AccClassNotRegistered
      else if Pos('Unrecognized database format', sMsg) > 0 then
        iCode := er_AD_AccUnrecognizedDbFormat
      else if Pos('Not a valid password', sMsg) > 0 then
        iCode := er_AD_AccNotValidPassword;
    end
    else
      if Pos('Class not registered', sMsg) > 0 then
        iCode := er_AD_AccSysClassNotRegistered;

    oExc := ADDBEngineExceptionCreate(EMSAccessNativeException, iCode, []);
    oErr := TADDBError.Create;
    oErr.Message := sMsg;
    oExc.Append(oErr);
    ADException(Self, oExc{$IFDEF AnyDAC_Monitor}, False{$ENDIF});
  end;

  procedure CompactRepair;
  var
    vJro: Variant;
    sSource, sDest, sProvider, sDestDatabase: String;
    iEngine: Integer;
    lRename: Boolean;
  begin
    if not FileExists(Database) then
      ADException(Self, ADDBEngineExceptionCreate(EMSAccessNativeException,
        er_AD_AccDbNotExists, [Database]){$IFDEF AnyDAC_Monitor}, False{$ENDIF});
    try
      vJro := CreateOLEObject('JRO.JetEngine');
      try
        lRename := (DestDatabase = '') or (DestDatabase = Database);
        if lRename then
          sDestDatabase := GenTempFileName(Database)
        else
          sDestDatabase := DestDatabase;
        DeleteDatabase(sDestDatabase);
        sSource := 'Provider=%s;Data Source=%s;Jet OLEDB:Engine Type=%d';
        sDest := sSource;
        if Password <> '' then begin
          sSource := sSource + ';Jet OLEDB:Database Password=' + Password;
          if not ResetPassword then
            sDest := sSource;
        end;
        if lSort then
          sDest := sDest + ';LocaleIdentifier=' + SortOrder;
        if Encrypted then
          sDest := sDest + ';Jet OLEDB:Encrypt Database=True';
        iEngine := 5;
        case DBVersion of
        avDefault:
          begin
            if sDrv = 'Microsoft Access Driver (*.mdb, *.accdb)' then
              sProvider := 'Microsoft.ACE.OLEDB.12.0'
            else
              sProvider := 'Microsoft.Jet.OLEDB.4.0';
          end;
        avAccess2:
          begin
            sProvider := 'Microsoft.Jet.OLEDB.4.0';
            iEngine := 3;
          end;
        avAccess95,
        avAccess97:
          begin
            sProvider := 'Microsoft.Jet.OLEDB.4.0';
            iEngine := 4;
          end;
        avAccess2000,
        avAccess2003:
          begin
            sProvider := 'Microsoft.Jet.OLEDB.4.0';
            iEngine := 5;
          end;
        avAccess2007:
          begin
            sProvider := 'Microsoft.ACE.OLEDB.12.0';
            iEngine := 5;
          end;
        end;
        vJro.CompactDatabase(Format(sSource, [sProvider, ADExpandStr(Database),
          iEngine]), Format(sDest, [sProvider, ADExpandStr(sDestDatabase), iEngine]));
        if lRename then begin
          DeleteDatabase(Database);
          if RenameDatabase(sDestDatabase, Database) then
            DeleteDatabase(sDestDatabase);
        end;
      finally
        vJro := Unassigned;
      end;
    except
      on E: EOleSysError do
        ProcessOLEException(EOleSysError(E))
    end;
  end;
{$ENDIF}

begin
  sDrv := (DriverLink.DriverIntf as IADPhysODBCDriver).ODBCDriver;
  case FAction of
  aaCompactDB:
{$IFDEF MSWINDOWS}
    CompactRepair;
{$ELSE}
    begin
      sDb := NormFileName(Database);
      sStr := 'COMPACT_DB=' + sDb + ' ';
      if DestDatabase = '' then
        sStr := sStr + sDb
      else
        sStr := sStr + NormFileName(DestDatabase);
      if SortOrder <> '' then
        sStr := sStr + ' ' + SortOrder;
      ExecuteBase(ODBC_ADD_DSN, sDrv, sStr);
    end;
{$ENDIF}
  aaRepairDB:
{$IFDEF MSWINDOWS}
    CompactRepair;
{$ELSE}
    begin
      sStr := 'REPAIR_DB=' + NormFileName(Database);
      ExecuteBase(ODBC_ADD_DSN, sDrv, sStr);
    end;
{$ENDIF}
  aaCreateDB:
    begin
      sStr := 'CREATE_DB';
      lLastDrv := sDrv = 'Microsoft Access Driver (*.mdb, *.accdb)';
      case DBVersion of
      avDefault:    ;
      avAccess2:    sStr := sStr + 'V2';
      avAccess95,
      avAccess97:   sStr := sStr + 'V3';
      avAccess2000: sStr := sStr + 'V4';
      avAccess2003,
      avAccess2007:
        begin
          sDrv := 'Microsoft Access Driver (*.mdb, *.accdb)';
          lLastDrv := True;
        end;
      end;
      sStr := sStr + '=' + NormFileName(Database);
      lSort := SortOrder <> '';
      if lSort and (Pos('0x', SortOrder) = 0) then begin
        sStr := sStr + ' ' + SortOrder;
{$IFDEF MSWINDOWS}
        lSort := False;
{$ENDIF}
      end;
      if Encrypted and not lLastDrv then
        sStr := sStr + ' ENCRYPT';
      ExecuteBase(ODBC_ADD_DSN, sDrv, sStr);
{$IFDEF MSWINDOWS}
      if (Password <> '') or lSort or (Encrypted and lLastDrv) then begin
        sDb := DestDatabase;
        DestDatabase := '';
        try
          CompactRepair;
        finally
          DestDatabase := sDb;
        end;
      end;
{$ENDIF}
    end;
  aaDropDB:
    DeleteDatabase(Database);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSAccessDriver                                                         }
{-------------------------------------------------------------------------------}
class function TADPhysMSAccessDriver.GetBaseDriverID: String;
begin
  Result := S_AD_MSAccId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSAccessDriver.InternalLoad;
begin
  ODBCAdvanced := 'ExtendedAnsiSQL=1';
  inherited InternalLoad;
  if ODBCDriver = '' then
    ODBCDriver := FindBestDriver([
      'Microsoft Access Driver (*.mdb, *.accdb)',
      'Microsoft Access Driver (*.mdb)',
      'Driver do Microsoft Access (*.mdb)',
      'Microsoft Access-Treiber (*.mdb)']);
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccessDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysMSAccessConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSAccessDriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
var
  i: Integer;
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  i := AKeywords.IndexOfName(S_AD_ConnParam_Common_Password);
  if i <> -1 then
    AKeywords[i] := S_AD_ConnParam_Common_Password + '=PWD*';
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DBQ*');
  AKeywords.Add(S_AD_ConnParam_MSAcc_SysDB);
  AKeywords.Add(S_AD_ConnParam_MSAcc_RO);
  AKeywords.Add('=ExtendedAnsiSQL');
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccessDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 3;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSAccessDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then begin
      ALoginIndex := 2;
      AType := '@F:Microsoft Access Database|*.mdb;*.accdb';
    end;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_MSAcc_SysDB;
        AType := '@S';
      end;
    1:
      begin
        AName := S_AD_ConnParam_MSAcc_RO;
        AType := '@L';
      end;
    2:
      begin
        AName := S_AD_ConnParam_MSAcc_StringFormat;
        AType := S_AD_Choose + ';' + S_AD_Unicode + ';' + S_AD_ANSI;
        ADefVal := S_AD_Choose;
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSAccessConnection                                                     }
{-------------------------------------------------------------------------------}
function TADPhysMSAccessConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysMSAccCommandGenerator.Create(ACommand)
  else
    Result := TADPhysMSAccCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccessConnection.InternalCreateMetadata: TObject;
var
  iSrvVer, iClntVer: TADVersion;
begin
  GetVersions(iSrvVer, iClntVer);
  Result := TADPhysMSAccMetadata.Create(Self, iSrvVer, iClntVer, GetKeywords);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSAccessConnection.InternalConnect;
var
  s: String;
begin
  inherited InternalConnect;
  FStringFormat := dtUnknown;
  s := GetConnectionDef.AsString[S_AD_ConnParam_MSAcc_StringFormat];
  if CompareText(s, S_AD_Unicode) = 0 then
    FStringFormat := dtWideString
  else if CompareText(s, S_AD_ANSI) = 0 then
    FStringFormat := dtAnsiString;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSAccessConnection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen: Boolean; out ACharSize, AByteSize: Integer);
begin
  case AStrDataType of
  SQL_C_CHAR, SQL_C_WCHAR:
    ACharSize := 255;
  SQL_C_BINARY:
    ACharSize := 510;
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_MSAccId]);
  end;
  AByteSize := ACharSize;
  if AStrDataType = SQL_C_WCHAR then
    AByteSize := AByteSize * SizeOf(SQLWChar);
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccessConnection.GetStrsType: TADDataType;
begin
  Result := FStringFormat;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccessConnection.GetExceptionClass: EODBCNativeExceptionClass;
begin
  Result := EMSAccessNativeException;
end;

{-------------------------------------------------------------------------------}
function MSAccessNativeExceptionLoad(AStorage: TADStorage): TObject;
begin
  Result := EMSAccessNativeException.Create;
  EMSAccessNativeException(Result).LoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysMSAccessDriver);
  ADStorageManager().RegisterClass(EMSAccessNativeException, 'MSAccessNativeException',
    @MSAccessNativeExceptionLoad, @ADExceptionSave);

end.
