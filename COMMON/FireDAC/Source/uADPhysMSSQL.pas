{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                 FireDAC MSSQL driver                  }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysMSSQL"'}

unit uADPhysMSSQL;

interface

uses
  Classes,
  uADStanError, uADStanStorage, 
  uADPhysManager, uADPhysODBCCli, uADPhysODBCWrapper, uADPhysODBCBase;

type
  TADMSSQLError = class;
  EMSSQLNativeException = class;
  TADPhysMSSQLDriverLink = class;

  TADMSSQLError = class(TADODBCNativeError)
  private
    FLine: Integer;
    FMessageState: Integer;
    FSeverity: Integer;
    FProcName: String;
    FServerName: String;
  protected
    procedure Assign(ASrc: TADDBError); override;
    procedure LoadFromStorage(AStorage: TADStorage); override;
    procedure SaveToStorage(AStorage: TADStorage); override;
  public
    property Line: Integer read FLine;
    property MessageState: Integer read FMessageState;
    property Severity: Integer read FSeverity;
    property ProcName: String read FProcName;
    property ServerName: String read FServerName;
  end;

  EMSSQLNativeException = class(EODBCNativeException)
  private
    function GetErrors(AIndex: Integer): TADMSSQLError;
  protected
    function GetErrorClass: TADDBErrorClass; override;
  public
    function AppendError(AHandle: TODBCHandle; ARecNum: SQLSmallint;
      const ASQLState: String; ANativeError: SQLInteger; const ADiagMessage,
      AResultMessage, ACommandText, AObject: String;
      AKind: TADCommandExceptionKind; ACmdOffset, ARowIndex: Integer): TADDBError; override;
    property Errors[Index: Integer]: TADMSSQLError read GetErrors; default;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TADPhysMSSQLDriverLink = class(TADPhysODBCBaseDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils,
{$IFDEF MSWINDOWS}
  {$IFNDEF AnyDAC_FPC}
  ComObj, ActiveX,
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  StrUtils, Variants,
{$ENDIF}
  uADStanIntf, uADStanConst, uADStanUtil, uADStanFactory, uADDatSManager,
  uADPhysIntf, uADPhysCmdGenerator, uADPhysMSSQLMeta;

const
{$IFDEF AnyDAC_POSIX}
  C_FreeTDS = 'FreeTDS';
  C_FreeTDSLib = 'libtdsodbc.so';
{$ENDIF}
{$IFDEF MSWINDOWS}
  C_2012 = 'SQL SERVER NATIVE CLIENT 11.0';
  C_2008 = 'SQL SERVER NATIVE CLIENT 10.0';
  C_2005 = 'SQL NATIVE CLIENT';
  C_2000 = 'SQL SERVER';
{$ENDIF}
  C_String = 'String';
  C_Binary = 'Binary';

var
  GSQLServerList: String = '*';

type
  TADPhysMSSQLDriver = class;
  TADPhysMSSQLConnection = class;
{$IFDEF MSWINDOWS}
  TADPhysMSSQLEventAlerter = class;
{$ENDIF}

  TADPhysMSSQLDriver = class(TADPhysODBCDriverBase)
  protected
    class function GetBaseDriverID: String; override;
    procedure InternalLoad; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName, AType,
      ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  public
    function BuildODBCConnectString(const AConnectionDef: IADStanConnectionDef): string; override;
  end;

  TADPhysMSSQLConnection = class(TADPhysODBCConnectionBase)
  private
    FCatalogCaseSensitive: Boolean;
    FExtendedMetadata: Boolean;
    procedure CheckPasswordChange;
  protected
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; override;
    function InternalCreateCommandGenerator(const ACommand:
      IADPhysCommand): TADPhysCommandGenerator; override;
    function InternalCreateMetadata: TObject; override;
    procedure GetStrsMaxSizes(AStrDataType: SQLSmallint; AFixedLen: Boolean;
      out ACharSize, AByteSize: Integer); override;
    function GetExceptionClass: EODBCNativeExceptionClass; override;
    procedure InternalSetMeta; override;
    procedure SetupConnection; override;
    procedure InternalChangePassword(const AUserName, AOldPassword,
      ANewPassword: String); override;
    procedure InternalAnalyzeSession(AMessages: TStrings); override;
  end;

{$IFDEF MSWINDOWS}
  TADPhysMSSQLEventAlerter = class (TADPhysEventAlerter)
  private
    FWaitConnection: IADPhysConnection;
    FWaitCommand: IADPhysCommand;
    FMessageTab: TADDatSTable;
    FWaitThread: TThread;
    FServiceName, FQueueName, FEventTabName: String;
    FDropService, FDropQueue, FEventTab: Boolean;
    procedure DoFired;
    procedure InternalRegisterBase;
  protected
    procedure InternalAllocHandle; override;
    procedure InternalRegister; override;
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); override;
    procedure InternalAbortJob; override;
    procedure InternalUnregister; override;
    procedure InternalReleaseHandle; override;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); override;
  end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADMSSQLError                                                                 }
{-------------------------------------------------------------------------------}
procedure TADMSSQLError.Assign(ASrc: TADDBError);
begin
  inherited Assign(ASrc);
  if ASrc is TADMSSQLError then begin
    FLine := TADMSSQLError(ASrc).FLine;
    FMessageState := TADMSSQLError(ASrc).FMessageState;
    FSeverity := TADMSSQLError(ASrc).FSeverity;
    FProcName := TADMSSQLError(ASrc).FProcName;
    FServerName := TADMSSQLError(ASrc).FServerName;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMSSQLError.LoadFromStorage(AStorage: TADStorage);
begin
  inherited LoadFromStorage(AStorage);
  FLine := AStorage.ReadInteger('Line', 0);
  FMessageState := AStorage.ReadInteger('MessageState', 0);
  FSeverity := AStorage.ReadInteger('Severity', 0);
  FProcName := AStorage.ReadString('ProcName', '');
  FServerName := AStorage.ReadString('ServerName', '');
end;

{-------------------------------------------------------------------------------}
procedure TADMSSQLError.SaveToStorage(AStorage: TADStorage);
begin
  inherited SaveToStorage(AStorage);
  AStorage.WriteInteger('Line', Line, 0);
  AStorage.WriteInteger('MessageState', MessageState, 0);
  AStorage.WriteInteger('Severity', Severity, 0);
  AStorage.WriteString('ProcName', ProcName, '');
  AStorage.WriteString('ServerName', ServerName, '');
end;

{-------------------------------------------------------------------------------}
{ EMSSQLNativeException                                                         }
{-------------------------------------------------------------------------------}
function EMSSQLNativeException.AppendError(AHandle: TODBCHandle;
  ARecNum: SQLSmallint; const ASQLState: String; ANativeError: SQLInteger;
  const ADiagMessage, AResultMessage, ACommandText, AObject: String;
  AKind: TADCommandExceptionKind; ACmdOffset, ARowIndex: Integer): TADDBError;
var
  sObj, sUDiagMessage, sRes: String;
  i, j: Integer;
  oErr: TADMSSQLError;
  oStmt: TODBCStatementBase;

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
  // following is not supported by MSSQL:
  // ekNoDataFound
  // ekUserPwdWillExpire
  sObj := AObject;
  sRes := AResultMessage;
  case ANativeError of
  1204,
  1222:
    AKind := ekRecordLocked;
  2601,
  2627:
    begin
      AKind := ekUKViolated;
      // first 'xxxx' - constraint name
      // second 'xxxx' - table name
      ExtractObjName;
    end;
  547:
    begin
      sUDiagMessage := UpperCase(ADiagMessage);
      if (Pos('COLUMN FOREIGN KEY', sUDiagMessage) <> 0) or
         (Pos('CONFLICTED', sUDiagMessage) <> 0) and
          (Pos('REFERENCE', sUDiagMessage) <> 0) and
          (Pos('CONSTRAINT', sUDiagMessage) <> 0) then begin
        AKind := ekFKViolated;
        // first 'xxxx' - constraint name
        // next 3 'xxxx' - full column name (database, table, column)
        ExtractObjName;
      end;
    end;
  208,
  3701:
    begin
      AKind := ekObjNotExists;
      // first 'xxxx' - object name
      ExtractObjName;
    end;
  18456,
  18463,
  18464,
  18465,
  18466,
  18467,
  18468:
    AKind := ekUserPwdInvalid;
  18487,
  18488:
    AKind := ekUserPwdExpired;
  170:
    // strange "incorrect syntax near '{'" at Array INSERT execute,
    // for example on PKSP_Merge DOCS_OUT table
    if (Pos('''{''', UpperCase(ADiagMessage)) <> 0) and (Pos('{', ACommandText) = 0) and
       (AHandle is TODBCCommandStatement) and (TODBCCommandStatement(AHandle).PARAMSET_SIZE > 1) then
      AKind := ekArrExecMalfunc;
  0:
    if ASQLState = '01000' then begin
      AKind := ekServerOutput;
      i := 0;
      for j := 1 to 3 do
        i := ADPosEx(']', sRes, i + 1);
      if i <> 0 then
        sRes := Copy(sRes, i + 1, Length(sRes));
    end
    // strange errors at Array DML:
    // - "Invalid character value for cast specification", 22018.
    //   GS has provided the bug report for 22018.
    // - "Invalid cursor state", 24000.
    //   ADQA fails on Batch execute -> Error handling on MSSQL 2005 with 24000 state.
    // - "String data, length mismatch", 22026
    //   Insert into VARBINARY(MAX) on MSSQL 2008 may give 22026.
    else if ((ASQLState = '22018') or (ASQLState = '24000') or (ASQLState = '22026')) and
            (AHandle is TODBCCommandStatement) and (TODBCCommandStatement(AHandle).PARAMSET_SIZE > 1) then
      AKind := ekArrExecMalfunc;
  201,
  8144:
    AKind := ekInvalidParams;
  end;
  Result := inherited AppendError(AHandle, ARecNum, ASQLState, ANativeError,
    ADiagMessage, sRes, ACommandText, sObj, AKind, ACmdOffset, ARowIndex);
  if AHandle is TODBCStatementBase then begin
    oErr := TADMSSQLError(Result);
    oStmt := TODBCStatementBase(AHandle);
    try
      oStmt.IgnoreErrors := True;
      oErr.FLine         := oStmt.DIAG_SS_LINE[ARecNum];
      oErr.FMessageState := oStmt.DIAG_SS_MSGSTATE[ARecNum];
      oErr.FSeverity     := oStmt.DIAG_SS_SEVERITY[ARecNum];
      oErr.FProcName     := oStmt.DIAG_SS_PROCNAME[ARecNum];
      if oErr.ObjName = '' then
        oErr.ObjName     := oErr.FProcName;
      oErr.FServerName   := oStmt.DIAG_SS_SRVNAME[ARecNum];
    finally
      oStmt.IgnoreErrors := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function EMSSQLNativeException.GetErrorClass: TADDBErrorClass;
begin
  Result := TADMSSQLError;
end;

{-------------------------------------------------------------------------------}
function EMSSQLNativeException.GetErrors(AIndex: Integer): TADMSSQLError;
begin
  Result := inherited Errors[AIndex] as TADMSSQLError;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSSQLDriverLink                                                        }
{-------------------------------------------------------------------------------}
function TADPhysMSSQLDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_MSSQLId;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSSQLDriver                                                            }
{-------------------------------------------------------------------------------}
class function TADPhysMSSQLDriver.GetBaseDriverID: String;
begin
  Result := S_AD_MSSQLId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLDriver.InternalLoad;
begin
  inherited InternalLoad;
  if ODBCDriver = '' then
    ODBCDriver := FindBestDriver({$IFDEF MSWINDOWS} [C_2012, C_2008, C_2005, C_2000] {$ENDIF}
                                 {$IFDEF AnyDAC_POSIX} [C_FreeTDS], C_FreeTDSLib {$ENDIF});
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysMSSQLConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLDriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  AKeywords.Add(S_AD_ConnParam_Common_Server);
  AKeywords.Add(S_AD_ConnParam_Common_Database);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Language);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Address);
  AKeywords.Add(S_AD_ConnParam_MSSQL_Workstation + '=WSID');
{$IFDEF AnyDAC_POSIX}
  AKeywords.Add(S_AD_ConnParam_Common_Port);
{$ENDIF}
{$IFDEF MSWINDOWS}
  AKeywords.Add(S_AD_ConnParam_MSSQL_Network);
  AKeywords.Add(S_AD_ConnParam_Common_OSAuthent + '=Trusted_Connection');
  AKeywords.Add(S_AD_ConnParam_MSSQL_MARS + '=MARS_Connection');
  AKeywords.Add(S_AD_ConnParam_MSSQL_Encrypt);
{$ENDIF}
  AKeywords.Add(S_AD_ConnParam_Common_ApplicationName + '=APP');
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLDriver.BuildODBCConnectString(const AConnectionDef: IADStanConnectionDef): string;
begin
  Result := inherited BuildODBCConnectString(AConnectionDef);
{$IFDEF MSWINDOWS}
  if ((CompareText(ODBCDriver, C_2012) = 0) or
      (CompareText(ODBCDriver, C_2005) = 0) or
      (CompareText(ODBCDriver, C_2008) = 0)) and
     not (AConnectionDef.HasValue('DSN') or AConnectionDef.HasValue('FIL')) and
     (Pos('MARS_CONNECTION=', UpperCase(Result)) = 0) then
    Result := Result + ';MARS_Connection=yes';
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  if not (AConnectionDef.HasValue('DSN') or AConnectionDef.HasValue('FIL')) and
     (Pos('TDS_VERSION=', UpperCase(Result)) = 0) then
    Result := Result + ';TDS_VERSION=8.0';
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 16;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  oList: TADStringList;
  i: Integer;
  oODBCConn: TODBCConnection;
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := 4;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_Common_Server;
        if GSQLServerList = '*' then begin
          GSQLServerList := '';
          Employ;
          oODBCConn := TODBCConnection.Create(ODBCEnvironment, Self);
          oList := TADStringList.Create;
          try
            oODBCConn.SS_BROWSE_CONNECT := SQL_MORE_INFO_YES;
            oODBCConn.ListServers('DRIVER=' + TODBCLib.DecorateKeyValue(ODBCDriver), oList);
            for i := 0 to oList.Count - 1 do begin
              if GSQLServerList <> '' then
                GSQLServerList := GSQLServerList + ';';
              GSQLServerList := GSQLServerList + oList[i];
            end;
          finally
            ADFree(oList);
            ADFree(oODBCConn);
            Vacate;
          end;
          if GSQLServerList = '' then
            GSQLServerList := '@S';
        end;
        AType := GSQLServerList;
        ALoginIndex := 3;
      end;
    1:
      begin
        AName := S_AD_ConnParam_MSSQL_Network;
        AType := '@S';
      end;
    2:
      begin
        AName := S_AD_ConnParam_MSSQL_Address;
        AType := '@S';
      end;
    3:
      begin
        AName := S_AD_ConnParam_Common_OSAuthent;
        AType := '@Y';
        ALoginIndex := 2;
      end;
    4:
      begin
        AName := S_AD_ConnParam_MSSQL_MARS;
        AType := '@Y';
        ADefVal := S_AD_Yes;
      end;
    5:
      begin
        AName := S_AD_ConnParam_MSSQL_Workstation;
        AType := '@S';
      end;
    6:
      begin
        AName := S_AD_ConnParam_MSSQL_Language;
        AType := '@S';
      end;
    7:
      begin
        AName := S_AD_ConnParam_MSSQL_Encrypt;
        AType := '@Y';
      end;
    8:
      begin
        AName := S_AD_ConnParam_MSSQL_VariantFormat;
        AType := C_String + ';' + C_Binary;
        ADefVal := C_String;
      end;
    9:
      begin
        AName := S_AD_ConnParam_Common_ExtendedMetadata;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
   10:
      begin
        AName := S_AD_ConnParam_Common_ApplicationName;
        AType := '@S';
      end;
   11:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
      end;
   12:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
      end;
   13:
      begin
        AName := S_AD_ConnParam_Common_MetaCurCatalog;
        AType := '@S';
      end;
   14:
      begin
        AName := S_AD_ConnParam_Common_MetaCurSchema;
        AType := '@S';
      end;
   15:
      begin
        AName := S_AD_ConnParam_Common_MetaCaseIns;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSSQLConnection                                                        }
{-------------------------------------------------------------------------------}
function TADPhysMSSQLConnection.InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter;
{$IFDEF MSWINDOWS}
var
  oConnMeta: IADPhysConnectionMetadata;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  CreateMetadata(oConnMeta);
  if (oConnMeta.ServerVersion >= svMSSQL2005) and (ODBCConnection.DriverKind = dkSQLNC) and
     (CompareText(AEventKind, S_AD_EventKind_MSSQL_Events) = 0) then
    Result := TADPhysMSSQLEventAlerter.Create(Self, AEventKind)
  else
{$ENDIF}
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysMSSQLCommandGenerator.Create(ACommand)
  else
    Result := TADPhysMSSQLCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLConnection.InternalCreateMetadata: TObject;
var
  iSrvVer, iClntVer: TADVersion;
  iCase: SQLUSmallint;
begin
  if ODBCConnection <> nil then begin
    GetVersions(iSrvVer, iClntVer);
    iCase := ODBCConnection.IDENTIFIER_CASE;
    Result := TADPhysMSSQLMetadata.Create(Self, FCatalogCaseSensitive,
      iCase in [SQL_IC_SENSITIVE, SQL_IC_MIXED], iCase in [SQL_IC_MIXED],
      ODBCConnection.IDENTIFIER_QUOTE_CHAR = '"',
      ODBCConnection.DriverKind in [dkSQLSrv, dkSQLNC], iSrvVer, iClntVer,
      GetKeywords, FExtendedMetadata);
  end
  else
    Result := TADPhysMSSQLMetadata.Create(Self, False, True, True, True, False,
      0, 0, GetKeywords, FExtendedMetadata);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLConnection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen: Boolean; out ACharSize, AByteSize: Integer);
begin
  AByteSize := 8000;
  ACharSize := AByteSize;
  case AStrDataType of
  SQL_C_CHAR, SQL_C_BINARY:
    ;
  SQL_C_WCHAR:
    ACharSize := AByteSize div SizeOf(SQLWChar);
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_MSSQLId]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLConnection.GetExceptionClass: EODBCNativeExceptionClass;
begin
  Result := EMSSQLNativeException;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLConnection.CheckPasswordChange;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  CreateMetadata(oConnMeta);
  if not ((oConnMeta.ServerVersion >= svMSSQL2005) and (ODBCConnection.DriverKind = dkSQLNC)) then
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_MSSQLId]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLConnection.SetupConnection;
var
  oPrevChanging: TNotifyEvent;
begin
  if ConnectionDef.NewPassword <> '' then begin
    CheckPasswordChange;
    ODBCConnection.SS_OLDPWD := ConnectionDef.Password;
    oPrevChanging := ConnectionDef.OnChanging;
    ConnectionDef.OnChanging := nil;
    ConnectionDef.Password := ConnectionDef.NewPassword;
    ConnectionDef.NewPassword := '';
    ConnectionDef.OnChanging := oPrevChanging;
  end;
  inherited SetupConnection;
  ODBCConnection.MSSQLVariantBinary :=
    CompareText(GetConnectionDef.AsString[S_AD_ConnParam_MSSQL_VariantFormat], C_Binary) = 0;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLConnection.InternalChangePassword(const AUserName,
  AOldPassword, ANewPassword: String);
var
  oConnDef: IADStanConnectionDef;
  oConn: TODBCConnection;
begin
  CheckPasswordChange;
  ADCreateInterface(IADStanConnectionDef, oConnDef);
  oConnDef.ParentDefinition := ConnectionDef;
  oConnDef.UserName := AUserName;
  oConnDef.Password := ANewPassword;
  oConn := TODBCConnection.Create(ODBCEnvironment, Self);
  try
    oConn.SS_OLDPWD := AOldPassword;
    oConn.Connect(TADPhysODBCDriverBase(DriverObj).BuildODBCConnectString(oConnDef), False);
  finally
    ADFree(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLConnection.InternalSetMeta;
var
  oStmt: TODBCCommandStatement;
  oCol1, oCol2: TODBCColumn;
  oConnMeta: IADPhysConnectionMetadata;
  iCount: SQLLen;
  sCollProp, sCurCatalog: String;
begin
  inherited InternalSetMeta;
  oStmt := TODBCCommandStatement.Create(ODBCConnection, Self);
  try
    CreateMetadata(oConnMeta);
    if FCurrentCatalog <> '' then
      sCurCatalog := FCurrentCatalog
    else
      sCurCatalog := InternalGetCurrentCatalog;
    if sCurCatalog <> '' then begin
      if oConnMeta.ServerVersion >= svMSSQL2005 then
        sCollProp := 'DATABASEPROPERTYEX('''
      else
        sCollProp := 'DATABASEPROPERTY(''';
      sCollProp := sCollProp + sCurCatalog + ''', ''COLLATION'')';
    end
    else
      sCollProp := 'SERVERPROPERTY(''COLLATION'')';
    if oConnMeta.ServerVersion >= svMSSQL2005 then
      oStmt.Open(1, 'SELECT SCHEMA_NAME(), ' + sCollProp)
    else
      oStmt.Open(1, 'SELECT USER_NAME(), ' + sCollProp);
    oCol1 := oStmt.AddCol(1, SQL_WVARCHAR,
      {$IFDEF AnyDAC_Unicode} SQL_C_WCHAR {$ELSE} SQL_C_CHAR {$ENDIF}, 128);
    oCol2 := oStmt.AddCol(2, SQL_WVARCHAR,
      {$IFDEF AnyDAC_Unicode} SQL_C_WCHAR {$ELSE} SQL_C_CHAR {$ENDIF}, 128);
    oStmt.Fetch(1);
    if FCurrentSchema = '' then begin
      FCurrentSchema := oCol1.AsString;
      // Under MSSQL 2005 the SCHEMA_NAME() may return NULL
      if FCurrentSchema = '' then
        FCurrentSchema := 'dbo';
    end;
    FCatalogCaseSensitive := Pos('_CI_', UpperCase(oCol2.AsString)) = 0;
    FExtendedMetadata := GetConnectionDef.AsBoolean[S_AD_ConnParam_Common_ExtendedMetadata];
    if FExtendedMetadata then begin
      oStmt.Unprepare;
      oStmt.Execute(1, 0, iCount, False, 'SET NO_BROWSETABLE ON');
    end;
  finally
    ADFree(oStmt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLConnection.InternalAnalyzeSession(AMessages: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  inherited InternalAnalyzeSession(AMessages);
  CreateMetadata(oConnMeta);

  // 2. SQLNC 2008 fails with SQL2000 at some tests
  if (oConnMeta.ServerVersion >= svMSSQL2000) and (oConnMeta.ServerVersion < svMSSQL2005) and
     (oConnMeta.ClientVersion >= svMSSQL2008) then
    AMessages.Add('Warning: SQL NC 2008 is not full compatible with SQL Server 2000.');
end;

{$IFDEF MSWINDOWS}
{-------------------------------------------------------------------------------}
{ TADPhysMSSQLEventThread                                                       }
{-------------------------------------------------------------------------------}
type
  TADPhysMSSQLEventThread = class(TThread)
  private
    FAlerter: TADPhysMSSQLEventAlerter;
  protected
    procedure Execute; override;
  public
    constructor Create(AAlerter: TADPhysMSSQLEventAlerter);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysMSSQLEventThread.Create(AAlerter: TADPhysMSSQLEventAlerter);
begin
  inherited Create(False);
  FAlerter := AAlerter;
  FreeOnTerminate := True;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysMSSQLEventThread.Destroy;
begin
  FAlerter.FWaitThread := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventThread.Execute;
begin
  FAlerter.InternalRegisterBase;
  while not Terminated and FAlerter.IsRunning do
    try
      if FAlerter.FMessageTab.Columns.Count = 0 then
        FAlerter.FWaitCommand.Define(FAlerter.FMessageTab);
      FAlerter.FWaitCommand.Open();
      if not Terminated then begin
        FAlerter.FWaitCommand.Fetch(FAlerter.FMessageTab, True);
        if FAlerter.FMessageTab.Rows.Count > 0 then begin
          FAlerter.DoFired;
          FAlerter.InternalRegisterBase;
        end;
      end;
    except
      on E: EADDBEngineException do
        if E.Kind <> ekCmdAborted then begin
          Terminate;
          FAlerter.AbortJob;
        end;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSSQLEventMessage                                                      }
{-------------------------------------------------------------------------------}
type
  TADPhysMSSQLEventMessage = class(TADPhysEventMessage)
  private
    FName,
    FMessage: String;
  public
    constructor Create(const AName, AMessage: String);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysMSSQLEventMessage.Create(const AName, AMessage: String);
begin
  inherited Create;
  FName := AName;
  FMessage := AMessage;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSSQLEventAlerter                                                      }
{-------------------------------------------------------------------------------}
// See:
// 1) http://msdn.microsoft.com/en-us/library/ms181122.aspx
// Creating a Query for Notification - supported SELECT's, connection settings, etc
// 2) http://msdn.microsoft.com/en-us/library/ms188323.aspx
// Understanding When Query Notifications Occur
// 3) http://www.code-magazine.com/article.aspx?quickid=0605061&page=1
// SQL Server 2005 Query Notifications Tell .NET 2.0 Apps When Critical Data Changes

// SERVICE=<service>
// QUEUE=<queue>
// CHANGE1=<message>;<SELECT>
// ...
// CHANGEn=<message>;<SELECT>
// <EV1>=<message>
// ...
// <EVn>=<message>

const
  C_Service = 'SERVICE';
  C_Queue = 'QUEUE';
  C_Change = 'CHANGE';
  C_Events = 'EVENTS';

procedure TADPhysMSSQLEventAlerter.InternalAllocHandle;
var
  i: Integer;
  sName, sVal: String;

{$IFDEF AnyDAC_FPC}
  function CreateClassID: String;
  var
    rGUID: TGUID;
  begin
    CreateGUID(rGUID);
    Result := GUIDToString(rGUID);
  end;
{$ENDIF}

begin
  FWaitConnection := GetConnection.Clone;
  if FWaitConnection.State = csDisconnected then
    FWaitConnection.Open;
  FWaitConnection.CreateCommand(FWaitCommand);
  SetupCommand(FWaitCommand);
  FMessageTab := TADDatSTable.Create;
  FServiceName := C_AD_SysNamePrefix + C_Service;
  FQueueName := C_AD_SysNamePrefix + C_Queue;
  FEventTabName := C_AD_SysNamePrefix + C_Events;
  FDropService := False;
  FDropQueue := False;
  FEventTab := False;
  for i := 0 to GetNames.Count - 1 do begin
    sName := ADNameFromIndex(GetNames(), i);
    sVal := ADValueFromIndex(GetNames(), i);
    if CompareText(sName, C_Service) = 0 then
      if sVal = '?' then begin
        FServiceName := C_AD_SysNamePrefix + C_Service + CreateClassID;
        FDropService := True;
      end
      else
        FServiceName := sVal
    else if CompareText(sName, C_Queue) = 0 then
      if sVal = '?' then begin
        FQueueName := C_AD_SysNamePrefix + C_Queue + CreateClassID;
        FDropQueue := True;
      end
      else
        FQueueName := sVal
    else if StrLIComp(PChar(sName), PChar(C_Change), Length(C_Change)) <> 0 then
      FEventTab := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.InternalRegister;
var
  sSQL: String;
begin
  sSQL :=
    'IF OBJECT_ID(''' + FQueueName + ''') IS NULL BEGIN ' +
    '  CREATE QUEUE [' + FQueueName + ']; ' +
    'END; ' +
    'IF (SELECT COUNT(*) FROM sys.services WHERE NAME = ''' + FServiceName + ''') = 0 BEGIN ' +
    '  CREATE SERVICE [' + FServiceName + '] ON QUEUE [' + FQueueName + '] ' +
    '    ([http://schemas.microsoft.com/SQL/Notifications/PostQueryNotification]); ' +
    '  IF (SELECT COUNT(*) FROM sys.database_principals WHERE name = ''sql_dependency_subscriber'' AND type = ''R'') <> 0 BEGIN ' +
    '    GRANT SEND ON SERVICE::[' + FServiceName + '] TO sql_dependency_subscriber; ' +
    '  END; ' +
    'END;';
  if FEventTab then
    sSQL := sSQL +
      'IF OBJECT_ID(''' + FEventTabName + ''') IS NULL BEGIN ' +
      '  CREATE TABLE [' + FEventTabName + '] (Name NVARCHAR(128) NOT NULL PRIMARY KEY CLUSTERED, Value BIGINT); ' +
      'END; ';
  FWaitCommand.Prepare(sSQL);
  FWaitCommand.Execute;
  FWaitThread := TADPhysMSSQLEventThread.Create(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.InternalRegisterBase;
var
  i, j: Integer;
  oStmt: TODBCStatementBase;
  sName, sVal: String;
  sMsg, sSQL: String;
begin
  for i := 0 to GetNames.Count - 1 do begin
    sName := ADNameFromIndex(GetNames(), i);
    sVal := ADValueFromIndex(GetNames(), i);
    if not ((CompareText(sName, C_Service) = 0) or (CompareText(sName, C_Queue) = 0)) then begin
      if StrLIComp(PChar(sName), PChar(C_Change), Length(C_Change)) = 0 then begin
        j := Pos(';', sVal);
        sMsg := Copy(sVal, 1, j - 1);
        sSQL := Copy(sVal, j + 1, MAXINT);
      end
      else begin
        sName := QuotedStr(sName);
        try
          FWaitCommand.Prepare('INSERT INTO [' + FEventTabName + '] VALUES(' + sName + ', 0)');
          FWaitCommand.Execute();
        except
          on E: EMSSQLNativeException do
            if E.Kind <> ekUKViolated then
              raise;
        end;
        sSQL := 'SELECT Value FROM [' + FEventTabName + '] WHERE Name = ' + sName;
      end;
      FWaitCommand.Prepare(sSQL);
      oStmt := TODBCStatementBase(FWaitCommand.CliObj);
      if GetOptions.Timeout > 0 then
        oStmt.SS_QUERYNOTIFICATION_TIMEOUT := GetOptions.Timeout div MSecsPerSec;
      oStmt.SS_QUERYNOTIFICATION_MSGTEXT := sMsg;
      oStmt.SS_QUERYNOTIFICATION_OPTIONS := 'SERVICE=' + FServiceName +
        ';LOCAL DATABASE=' + FWaitConnection.ConnectionDef.Database;
      FWaitCommand.Define(FMessageTab);
      FWaitCommand.Open;
      FWaitCommand.Disconnect;
      FMessageTab.Reset;
    end;
  end;

  sSQL := 'WAITFOR (RECEIVE message_body FROM [' + FQueueName + '])';
  if GetOptions.Timeout > 0 then
    sSQL := sSQL + ', TIMEOUT ' + IntToStr(GetOptions.Timeout);
  FWaitCommand.Prepare(sSQL);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.DoFired;
const
  C_Start: String = '<qn:Message>';
  C_End: String = '</qn:Message>';
var
  i, i1, i2: Integer;
  sMsg: String;
begin
  for i := 0 to FMessageTab.Rows.Count - 1 do begin
    sMsg := FMessageTab.Rows[i].AsString['message_body'];
    i1 := Pos(C_Start, sMsg);
    i2 := Pos(C_End, sMsg);
    if (i1 > 0) and (i2 > 0) then begin
      i1 := i1 + Length(C_Start);
      i2 := i2 - 1;
      sMsg := Copy(sMsg, i1, i2 - i1 + 1);
    end;
    FMsgThread.EnqueueMsg(TADPhysMSSQLEventMessage.Create(sMsg, ''));
  end;
  FMessageTab.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.InternalHandle(AEventMessage: TADPhysEventMessage);
var
  oMsg: TADPhysMSSQLEventMessage;
begin
  if GetHandler <> nil then begin
    oMsg := TADPhysMSSQLEventMessage(AEventMessage);
    GetHandler.HandleEvent(oMsg.FName, oMsg.FMessage);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.InternalAbortJob;
begin
  FWaitThread.Terminate;
  FWaitCommand.AbortJob(True);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.InternalUnregister;
var
  sSQL: String;
begin
  FWaitThread := nil;
  sSQL := '';
  if FDropService then
    sSQL := sSQL +
      'IF (SELECT COUNT(*) FROM sys.services WHERE NAME = ''' + FServiceName + ''') <> 0 BEGIN ' +
      '  DROP SERVICE [' + FServiceName + ']; ' +
      'END; ';
  if FDropQueue then
    sSQL := sSQL +
      'IF OBJECT_ID(''' + FQueueName + ''') IS NOT NULL BEGIN ' +
      '  DROP QUEUE [' + FQueueName + ']; ' +
      'END; ';
  if sSQL <> '' then begin
    FWaitCommand.Prepare(sSQL);
    FWaitCommand.Execute;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.InternalReleaseHandle;
begin
  FWaitCommand := nil;
  FWaitConnection := nil;
  ADFreeAndNil(FMessageTab);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMSSQLEventAlerter.InternalSignal(const AEvent: String;
  const AArgument: Variant);
var
  oCmd: IADPhysCommand;
begin
  if FEventTab then begin
    GetConnection.CreateCommand(oCmd);
    SetupCommand(oCmd);
    oCmd.Prepare('UPDATE [' + FEventTabName + '] SET Value = Value + 1 WHERE Name = ' + QuotedStr(AEvent));
    oCmd.Execute();
  end
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_MSSQLId]);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function MSSQLNativeExceptionLoad(AStorage: TADStorage): TObject;
begin
  Result := EMSSQLNativeException.Create;
  EMSSQLNativeException(Result).LoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysMSSQLDriver);
  ADStorageManager().RegisterClass(EMSSQLNativeException, 'MSSQLNativeException',
    @MSSQLNativeExceptionLoad, @ADExceptionSave);

end.
