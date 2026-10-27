{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{              FireDAC DBX 4 Bridge driver              }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysTDBX"'}

unit uADPhysTDBX;

interface

uses
  Classes,
  uADPhysTDBXBase;

type
  TADPhysTDBXDriverLink = class;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADPhysTDBXDriverLink = class(TADPhysTDBXBaseDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils, IniFiles, DBXCommon,
{$IFDEF AnyDAC_D12}
    DbxInterbase,
  {$IFNDEF AnyDAC_ProSKU}
    DbxDatasnap,
  {$ENDIF}
  {$IFNDEF AnyDAC_D15}
    DbxBlackfishSQL,
  {$ENDIF}
  {$IFNDEF NEXTGEN}
    {$IFNDEF AnyDAC_Mobile}
    DbxMySql,
    {$ENDIF}
    {$IFNDEF AnyDAC_ProSKU}
    DbxInformix, DbxOracle, DbxSybaseASA,
      {$IFNDEF AnyDAC_POSIX}
    DbxDb2, DbxMSSQL, DbxSybaseASE,
      {$ENDIF}
      {$IFDEF AnyDAC_D14}
    DbxFirebird,
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  uADStanIntf, uADStanConst, uADStanUtil,
  uADPhysIntf, uADPhysManager, uADPhysCmdGenerator, uADPhysConnMeta,
{$IFNDEF AnyDAC_MOBILE}
    uADPhysMSAccMeta, uADPhysMSSQLMeta, uADPhysMySQLMeta, uADPhysOracleMeta,
    uADPhysDB2Meta, uADPhysASAMeta, uADPhysADSMeta,
    uADPhysPGMeta, uADPhysNexusMeta,
{$ENDIF}
    uADPhysTDBXMeta, uADPhysIBMeta, uADPhysSQLiteMeta;

type
  TADPhysTDBXDriver = class;
  TADPhysTDBXConnection = class;

{$IFDEF AnyDAC_D12}
  TDBXConnectionEx = TDBXConnection;
  TDBXMetaDataCommandsEx = TDBXMetaDataCommands;
{$ENDIF}

  TADPhysTDBXDriver = class(TADPhysTDBXDriverBase)
  private
    function GetDriverParams(AKeys: TStrings): TStrings;
  protected
    class function GetBaseDriverID: String; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer;
      var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  end;

  TADPhysTDBXConnection = class(TADPhysTDBXConnectionBase)
  protected
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand):
      TADPhysCommandGenerator; override;
  end;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXDriverLink                                                         }
{-------------------------------------------------------------------------------}
function TADPhysTDBXDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_TDBXId;
end;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXDriver                                                             }
{-------------------------------------------------------------------------------}
class function TADPhysTDBXDriver.GetBaseDriverID: String;
begin
  Result := S_AD_TDBXId;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysTDBXConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXDriver.GetDriverParams(AKeys: TStrings): TStrings;
var
  sDrv, sName, sType, sDefVal, sCaption: String;
  oIniFile: TCustomIniFile;
  i, j, iLogin: Integer;
begin
  Result := TADStringList.Create;
  try
    sDrv := ADUnquote(AKeys.Values[TDBXPropertyNames.DriverName]);
    if sDrv <> '' then begin
      oIniFile := TADIniFile.Create(CfgFile);
      try
        oIniFile.ReadSectionValues(sDrv, Result);
        i := inherited GetConnParamCount(AKeys) - 1;
        while i >= 0 do begin
          inherited GetConnParams(AKeys, i, sName, sType, sDefVal, sCaption, iLogin);
          j := Result.IndexOfName(sName);
          if j <> -1 then
            Result.Delete(j);
          Dec(i);
        end;
      finally
        ADFree(oIniFile);
      end;
    end;
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXDriver.GetConnParamCount(AKeys: TStrings): Integer;
var
  oList: TStrings;
begin
  Result := inherited GetConnParamCount(AKeys);
  oList := GetDriverParams(AKeys);
  try
    Result := Result + oList.Count + 6;
  finally
    ADFree(oList);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTDBXDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  oList, oList2: TStrings;
  oIniFile: TCustomIniFile;
  j: TADRDBMSKind;
begin
  ALoginIndex := -1;
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := 2;
  end
  else begin
    AIndex := AIndex - inherited GetConnParamCount(AKeys);
    if AIndex = 0 then begin
      AName := TDBXPropertyNames.DriverName;
      oIniFile := TIniFile.Create(CfgFile);
      oList := TStringList.Create;
      oList.Delimiter := ';';
      oList.QuoteChar := '"';
      try
        oIniFile.ReadSection(TDBXPropertyNames.InstalledDrivers, oList);
        AType := oList.DelimitedText;
      finally
        oList.Free;
        oIniFile.Free;
      end;
      ADefVal := '';
      ACaption := AName;
    end
    else begin
      Dec(AIndex);
      oList := GetDriverParams(AKeys);
      try
        if AIndex < oList.Count then begin
          AName := ADNameFromIndex(oList, AIndex);
          ADefVal := ADValueFromIndex(oList, AIndex);
          oIniFile := TADIniFile.Create(CfgFile);
          oList2 := TADStringList.Create;
          oList2.Delimiter := ';';
          oList2.QuoteChar := '"';
          try
            oIniFile.ReadSection(AName, oList2);
            AType := oList2.DelimitedText;
          finally
            ADFree(oList2);
            ADFree(oIniFile);
          end;
        end
        else
          case AIndex - oList.Count of
          0:
            begin
              AName := S_AD_ConnParam_Common_MetaDefCatalog;
              AType := '@S';
              ADefVal := '';
            end;
          1:
            begin
              AName := S_AD_ConnParam_Common_MetaDefSchema;
              AType := '@S';
              ADefVal := '';
            end;
          2:
            begin
              AName := S_AD_ConnParam_Common_MetaCurCatalog;
              AType := '@S';
              ADefVal := '';
            end;
          3:
            begin
              AName := S_AD_ConnParam_Common_MetaCurSchema;
              AType := '@S';
              ADefVal := '';
            end;
          4:
            begin
              AName := S_AD_ConnParam_Common_RDBMSKind;
              AType := '';
              for j := Low(TADRDBMSKind) to High(TADRDBMSKind) do begin
                if AType <> '' then
                  AType := AType + ';';
                AType := AType + C_AD_PhysRDBMSKinds[j];
              end;
              ADefVal := '';
            end;
          end;
      finally
        ADFree(oList);
      end;
      ACaption := AName;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXConnection                                                         }
{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    case GetRDBMSKindFromAlias of
{$IFNDEF AnyDAC_MOBILE}
    mkOracle:    Result := TADPhysOraCommandGenerator.Create(ACommand, False);
    mkMSSQL:     Result := TADPhysMSSQLCommandGenerator.Create(ACommand);
    mkMSAccess:  Result := TADPhysMSAccCommandGenerator.Create(ACommand);
    mkMySQL:     Result := TADPhysMySQLCommandGenerator.Create(ACommand);
    mkDb2:       Result := TADPhysDb2CommandGenerator.Create(ACommand);
    mkASA:       Result := TADPhysASACommandGenerator.Create(ACommand);
    mkADS:       Result := TADPhysADSCommandGenerator.Create(ACommand);
    mkPostgreSQL:Result := TADPhysPgCommandGenerator.Create(ACommand);
    mkNexus:     Result := TADPhysNexusCommandGenerator.Create(ACommand);
{$ENDIF}
    mkInterbase: Result := TADPhysIBCommandGenerator.Create(ACommand, 0, ecANSI);
    mkSQLite:    Result := TADPhysSQLiteCommandGenerator.Create(ACommand);
    else         Result := TADPhysCommandGenerator.Create(ACommand);
    end
  else
    case GetRDBMSKindFromAlias of
{$IFNDEF AnyDAC_MOBILE}
    mkOracle:    Result := TADPhysOraCommandGenerator.Create(Self, False);
    mkMSSQL:     Result := TADPhysMSSQLCommandGenerator.Create(Self);
    mkMSAccess:  Result := TADPhysMSAccCommandGenerator.Create(Self);
    mkMySQL:     Result := TADPhysMySQLCommandGenerator.Create(Self);
    mkDb2:       Result := TADPhysDb2CommandGenerator.Create(Self);
    mkASA:       Result := TADPhysASACommandGenerator.Create(Self);
    mkADS:       Result := TADPhysADSCommandGenerator.Create(Self);
    mkPostgreSQL:Result := TADPhysPgCommandGenerator.Create(Self);
    mkNexus:     Result := TADPhysNexusCommandGenerator.Create(Self);
{$ENDIF}
    mkInterbase: Result := TADPhysIBCommandGenerator.Create(Self, 0, ecANSI);
    mkSQLite:    Result := TADPhysSQLiteCommandGenerator.Create(Self);
    else         Result := TADPhysCommandGenerator.Create(Self);
    end
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXConnection.InternalCreateMetadata: TObject;
var
  iSQLDialect: Integer;
  iClntVer: TADVersion;
  eBrand: TADPhysIBBrand;
begin
  if (DbxConnection <> nil) and (DbxConnection is TDBXConnectionEx) then
    iClntVer := ADVerStr2Int(TDBXConnectionEx(DbxConnection).ProductVersion)
  else
    iClntVer := 0;
  case GetRDBMSKindFromAlias of
{$IFNDEF AnyDAC_MOBILE}
  mkOracle:    Result := TADPhysOraMetadata.Create(Self, iClntVer, iClntVer, False);
  mkMSSQL:     Result := TADPhysMSSQLMetadata.Create(Self, False, True, True, True,
    False, 0, iClntVer, GetKeywords, False);
  mkMSAccess:  Result := TADPhysMSAccMetadata.Create(Self, 0, iClntVer, GetKeywords);
  mkMySQL:     Result := TADPhysMySQLMetadata.Create(Self, False, 0, iClntVer,
    [nmCaseSens, nmDBApply], False);
  mkDb2:       Result := TADPhysDb2Metadata.Create(Self, 0, iClntVer, GetKeywords);
  mkASA:       Result := TADPhysASAMetadata.Create(Self, 0, iClntVer, GetKeywords);
  mkADS:       Result := TADPhysADSMetadata.Create(Self, 0, iClntVer);
  mkPostgreSQL:Result := TADPhysPgMetadata.Create(Self, 0, iClntVer, False, False, False);
  mkNexus:     Result := TADPhysNexusMetadata.Create(Self, 0, iClntVer);
{$ENDIF}
  mkInterbase:
    begin
      iSQLDialect := GetConnectionDef.AsInteger[S_AD_ConnParam_IB_SQLDialect];
      if iSQLDialect = 0 then
        iSQLDialect := 3;
      if CompareText(DriverName, 'firebird') = 0 then
        eBrand := ibFirebird
      else
        eBrand := ibInterbase;
      Result := TADPhysIBMetadata.Create(Self, eBrand, 0, iClntVer, iSQLDialect, False);
    end;
  mkSQLite:    Result := TADPhysSQLiteMetadata.Create(Self, sbSQLite, 0,
    iClntVer, False, False);
  else
    if (DbxConnection <> nil) and DbxConnection.IsOpen then
      Result := TADPhysTDBXMetadata.Create(Self, GetKeywords)
    else
      Result := TADPhysConnectionMetadata.Create(Self, 0, 0, False);
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  try
    TDBXConnectionFactory.GetConnectionFactory;
    // if previous line passed OK, then TDBX is installed correctly
    ADPhysManagerObj.RegisterDriverClass(TADPhysTDBXDriver);
  except
    // none
  end;

end.
