{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{              FireDAC ODBC Bridge driver               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysODBC"'}

unit uADPhysODBC;

interface

uses
  Classes,
  uADPhysManager, uADPhysODBCBase;

type
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TADPhysODBCDriverLink = class(TADPhysODBCBaseDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils,
  uADStanIntf, uADStanConst, uADStanUtil,
  uADPhysIntf, uADPhysCmdGenerator, uADPhysConnMeta,
  uADPhysODBCCli, uADPhysODBCWrapper, uADPhysODBCMeta
{$IFDEF AnyDAC_ODBC_ALLMETA}
    , uADPhysMSSQLMeta, uADPhysMSAccMeta, uADPhysDB2Meta, uADPhysOracleMeta,
    uADPhysASAMeta, uADPhysMySQLMeta, uADPhysADSMeta, uADPhysIBMeta,
    uADPhysPGMeta, uADPhysSQLiteMeta, uADPhysNexusMeta
{$ENDIF}
    ;

type
  TADPhysODBCDriver = class;
  TADPhysODBCConnection = class;

  TADPhysODBCDriver = class(TADPhysODBCDriverBase)
  protected
    class function GetBaseDriverID: String; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName, AType,
      ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  end;

  TADPhysODBCConnection = class(TADPhysODBCConnectionBase)
  private
    FRdbmsKind: TADRDBMSKind;
    FNumericFormat: TADDataType;
    procedure UpdateRDBMSKind;
  protected
    function InternalCreateCommandGenerator(
      const ACommand: IADPhysCommand): TADPhysCommandGenerator; override;
    function InternalCreateMetadata: TObject; override;
    procedure InternalConnect; override;
    function GetNumType: TADDataType; override;
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); override;
  end;

const
  S_AD_Binary = 'Binary';
  S_AD_String = 'String';

{-------------------------------------------------------------------------------}
{ TADPhysODBCDriverLink                                                         }
{-------------------------------------------------------------------------------}
function TADPhysODBCDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_ODBCId;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCDriver                                                             }
{-------------------------------------------------------------------------------}
class function TADPhysODBCDriver.GetBaseDriverID: String;
begin
  Result := S_AD_ODBCId;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysODBCConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
var
  i: Integer;
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  i := AKeywords.IndexOf('=DRIVER');
  if i >= 0 then
    AKeywords.Delete(i);
  i := AKeywords.IndexOf('DSN');
  if i >= 0 then
    AKeywords.Delete(i);
  AKeywords.Add(S_AD_ConnParam_ODBC_Driver + '=DRIVER');
  AKeywords.Add(S_AD_ConnParam_ODBC_DataSource + '=DSN');
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DBQ');
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DATABASE');
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 8;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  j: TADRDBMSKind;
  i: Integer;
  oList: TADStringList;
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex)
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        Employ;
        oList := TADStringList.Create;
        try
          AName := S_AD_ConnParam_ODBC_Driver;
          AType := '';
          ODBCEnvironment.GetDrivers(oList, True);
          for i := 0 to oList.Count - 1 do begin
            if AType <> '' then
              AType := AType + ';';
            AType := AType + oList[i];
          end;
        finally
          ADFree(oList);
          Vacate;
        end;
      end;
    1:
      begin
        Employ;
        oList := TADStringList.Create;
        try
          AName := S_AD_ConnParam_ODBC_DataSource;
          AType := '';
          ODBCEnvironment.GetDSNs(oList, False, True);
          for i := 0 to oList.Count - 1 do begin
            if AType <> '' then
              AType := AType + ';';
            AType := AType + oList[i];
          end;
          ALoginIndex := 2;
        finally
          ADFree(oList);
          Vacate;
        end;
      end;
    2:
      begin
        AName := S_AD_ConnParam_ODBC_NumericFormat;
        AType := S_AD_Binary + ';' + S_AD_String;
        ADefVal := S_AD_Binary;
      end;
    3:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
      end;
    4:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
      end;
    5:
      begin
        AName := S_AD_ConnParam_Common_MetaCurCatalog;
        AType := '@S';
      end;
    6:
      begin
        AName := S_AD_ConnParam_Common_MetaCurSchema;
        AType := '@S';
      end;
    7:
      begin
        AName := S_AD_ConnParam_Common_RDBMSKind;
        AType := '';
        for j := Low(TADRDBMSKind) to High(TADRDBMSKind) do begin
          if AType <> '' then
            AType := AType + ';';
          AType := AType + C_AD_PhysRDBMSKinds[j];
        end;
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysODBCConnection                                                         }
{-------------------------------------------------------------------------------}
constructor TADPhysODBCConnection.Create(ADriverObj: TADPhysDriver;
  AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, AConnHost);
  UpdateRDBMSKind;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnection.UpdateRDBMSKind;
var
  i: TADRDBMSKind;
  s: string;

  function Match(const AName: String): Boolean;
  begin
    Result := Copy(s, 1, Length(AName)) = AName;
  end;

begin
  if FRdbmsKind = mkUnknown then begin
    s := UpperCase(GetConnectionDef.AsString[S_AD_ConnParam_Common_RDBMSKind]);
    if s <> '' then
      for i := Low(TADRDBMSKind) to High(TADRDBMSKind) do
        if C_AD_PhysRDBMSKinds[i] = s then begin
          FRdbmsKind := i;
          Exit;
        end;
  end;
  if (FRdbmsKind = mkUnknown) and (ODBCConnection <> nil) then
    FRdbmsKind := ODBCConnection.RdbmsKind;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysODBCConnection.InternalConnect;
var
  sFmt: String;
begin
  inherited InternalConnect;
  FRdbmsKind := mkUnknown;
  sFmt := GetConnectionDef.AsString[S_AD_ConnParam_ODBC_NumericFormat];
  if CompareText(sFmt, S_AD_Binary) = 0 then
    FNumericFormat := dtBCD
  else
    FNumericFormat := dtAnsiString;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnection.GetNumType: TADDataType;
begin
  Result := FNumericFormat;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnection.InternalCreateCommandGenerator(const ACommand:
  IADPhysCommand): TADPhysCommandGenerator;
begin
  UpdateRDBMSKind;
{$IFDEF AnyDAC_ODBC_ALLMETA}
  if ACommand <> nil then
    case FRdbmsKind of
    mkOracle:    Result := TADPhysOraCommandGenerator.Create(ACommand, False);
    mkMSSQL:     Result := TADPhysMSSQLCommandGenerator.Create(ACommand);
    mkMSAccess:  Result := TADPhysMSAccCommandGenerator.Create(ACommand);
    mkMySQL:     Result := TADPhysMySQLCommandGenerator.Create(ACommand);
    mkDb2:       Result := TADPhysDb2CommandGenerator.Create(ACommand);
    mkASA:       Result := TADPhysASACommandGenerator.Create(ACommand);
    mkADS:       Result := TADPhysADSCommandGenerator.Create(ACommand);
    mkInterbase: Result := TADPhysIBCommandGenerator.Create(ACommand, 0, ecANSI);
    mkPostgreSQL:Result := TADPhysPgCommandGenerator.Create(ACommand);
    mkSQLite:    Result := TADPhysSQLiteCommandGenerator.Create(ACommand);
    mkNexus:     Result := TADPhysNexusCommandGenerator.Create(ACommand);
    else         Result := TADPhysCommandGenerator.Create(ACommand);
    end
  else
    case FRdbmsKind of
    mkOracle:    Result := TADPhysOraCommandGenerator.Create(Self, False);
    mkMSSQL:     Result := TADPhysMSSQLCommandGenerator.Create(Self);
    mkMSAccess:  Result := TADPhysMSAccCommandGenerator.Create(Self);
    mkMySQL:     Result := TADPhysMySQLCommandGenerator.Create(Self);
    mkDb2:       Result := TADPhysDb2CommandGenerator.Create(Self);
    mkASA:       Result := TADPhysASACommandGenerator.Create(Self);
    mkADS:       Result := TADPhysADSCommandGenerator.Create(Self);
    mkInterbase: Result := TADPhysIBCommandGenerator.Create(Self, 0, ecANSI);
    mkPostgreSQL:Result := TADPhysPgCommandGenerator.Create(Self);
    mkSQLite:    Result := TADPhysSQLiteCommandGenerator.Create(Self);
    mkNexus:     Result := TADPhysNexusCommandGenerator.Create(Self);
    else         Result := TADPhysCommandGenerator.Create(Self);
    end;
{$ELSE}
  if ACommand <> nil then
    Result := TADPhysCommandGenerator.Create(ACommand)
  else
    Result := TADPhysCommandGenerator.Create(Self);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCConnection.InternalCreateMetadata: TObject;
var
  iSrvVer, iClntVer: TADVersion;
begin
  GetVersions(iSrvVer, iClntVer);
  UpdateRDBMSKind;
{$IFDEF AnyDAC_ODBC_ALLMETA}
  case FRdbmsKind of
  mkOracle:    Result := TADPhysOraMetadata.Create(Self, iSrvVer, iClntVer, False);
  mkMSSQL:     Result := TADPhysMSSQLMetadata.Create(Self, False, True, True, True,
    (ODBCConnection <> nil) and (ODBCConnection.DriverKind in [dkSQLSrv, dkSQLNC]),
    iSrvVer, iClntVer, GetKeywords, False);
  mkMSAccess:  Result := TADPhysMSAccMetadata.Create(Self, iSrvVer, iClntVer, GetKeywords);
  mkMySQL:     Result := TADPhysMySQLMetadata.Create(Self, False, iSrvVer, iClntVer,
    [nmCaseSens, nmDBApply], False);
  mkDb2:       Result := TADPhysDb2Metadata.Create(Self, iSrvVer, iClntVer, GetKeywords);
  mkASA:       Result := TADPhysASAMetadata.Create(Self, iSrvVer, iClntVer, GetKeywords);
  mkADS:       Result := TADPhysADSMetadata.Create(Self, iSrvVer, iClntVer);
  mkInterbase: Result := TADPhysIBMetadata.Create(Self, ibInterbase, iSrvVer, iClntVer, 3, False);
  mkPostgreSQL:Result := TADPhysPgMetadata.Create(Self, iSrvVer, iClntVer, False, False, False);
  mkSQLite:    Result := TADPhysSQLiteMetadata.Create(Self, sbSQLite, iSrvVer,
    iClntVer, False, False);
  mkNexus:     Result := TADPhysNexusMetadata.Create(Self, iSrvVer, iClntVer);
  else         Result := nil;
  end;
{$ELSE}
  Result := nil;
{$ENDIF}
  if (ODBCConnection <> nil) and ODBCConnection.Connected then
    Result := TADPhysODBCMetadata.Create(Self, iSrvVer, iClntVer, TADPhysConnectionMetadata(Result))
  else if Result = nil then
    Result := TADPhysConnectionMetadata.Create(Self, iSrvVer, iClntVer, False);
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysODBCDriver);

end.
