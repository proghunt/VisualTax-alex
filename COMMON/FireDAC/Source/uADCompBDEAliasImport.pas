{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{             FireDAC BDE Aliases Importer              }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompBDEAliasImport;

interface

uses
  Classes,
  uADStanIntf, uADStanConst, uADStanOption;

type
  TADAliasImportOverwriteEvent = procedure (const AName: String;
    var AOverwrite: Integer) of object;
  TADBDEAliasImporter = class(TObject)
  private
    FSrcParams: TADStringList;
    FDestParams: TStrings;
    FOpts: IADStanOptions;
    FFetch: TADFetchOptions;
    FFmt: TADFormatOptions;
    FUpd: TADUpdateOptions;
    FRes: TADResourceOptions;
    FConnectionDefFileName: String;
    FOverwriteDefs: Boolean;
    FAliasesToImport: TADStringList;
    FOnOverwrite: TADAliasImportOverwriteEvent;
    function GetSrcBool(const AName: String; var AResult: Boolean): Boolean;
    function GetSrcInt(const AName: String; var AResult: Integer): Boolean;
    function GetSrcStr(const AName: String; var AResult: String): Boolean;
    procedure ImportSQLCommon;
    procedure ImportOracle(AImportMode: Boolean);
    procedure ImportIB(AImportMode: Boolean);
    procedure ImportMSSQL(AImportMode: Boolean);
    procedure ImportMSAccess(AImportMode: Boolean);
    procedure ImportODBC(AImportMode: Boolean);
    procedure ImportDB2(AImportMode: Boolean);
    procedure ImportMySQL(AImportMode: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    procedure MakeBDECompatible(
      const AConnectionDef: IADStanConnectionDef; AEnableBCD, AEnableInteger: Boolean);
    property ConnectionDefFileName: String read FConnectionDefFileName
      write FConnectionDefFileName;
    property AliasesToImport: TADStringList read FAliasesToImport;
    property OverwriteDefs: Boolean read FOverwriteDefs write FOverwriteDefs;
    property OnOverwrite: TADAliasImportOverwriteEvent read FOnOverwrite
      write FOnOverwrite;
  end;

implementation

uses
  Dialogs, SysUtils, DBTables, BDE,
  uADStanFactory, uADStanResStrs, uADStanError, uADStanUtil,
  uADPhysIntf, TypInfo;

const
  S_OpenODBC = 'OpenODBC';
  DRIVERNAME_KEY = 'DriverName';

{-------------------------------------------------------------------------------}
constructor TADBDEAliasImporter.Create;
begin
  inherited Create;
  FAliasesToImport := TADStringList.Create;
{$IFDEF AnyDAC_D6}
  FAliasesToImport.CaseSensitive := False;
{$ENDIF}
  FAliasesToImport.Sorted := True;
  FAliasesToImport.Duplicates := dupAccept;
end;

{-------------------------------------------------------------------------------}
destructor TADBDEAliasImporter.Destroy;
begin
  ADFreeAndNil(FAliasesToImport);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADBDEAliasImporter.GetSrcBool(const AName: String; var AResult: Boolean): Boolean;
var
  i: Integer;
begin
  i := FSrcParams.IndexOfName(AName);
  Result := i <> -1;
  AResult := False;
  if Result then
    AResult := CompareText(FSrcParams.Values[AName], S_AD_True) = 0;
end;

{-------------------------------------------------------------------------------}
function TADBDEAliasImporter.GetSrcInt(const AName: String; var AResult: Integer): Boolean;
var
  i: Integer;
begin
  i := FSrcParams.IndexOfName(AName);
  Result := i <> -1;
  AResult := 0;
  if Result then
    AResult := StrToInt(FSrcParams.Values[AName]);
end;

{-------------------------------------------------------------------------------}
function TADBDEAliasImporter.GetSrcStr(const AName: String; var AResult: String): Boolean;
var
  i: Integer;
begin
  i := FSrcParams.IndexOfName(AName);
  Result := i <> -1;
  AResult := '';
  if Result then
    AResult := FSrcParams.Values[AName];
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportSQLCommon;
var
  sVal: String;
  iVal: Integer;
  lVal: Boolean;
begin
  if GetSrcInt(szROWSETSIZE, iVal) and (iVal <> 20) then
    FFetch.RowsetSize := iVal;
  if GetSrcInt(szBLOBCOUNT, iVal) and (iVal = 0) then
    if iVal > 0 then
      FFetch.Cache := FFetch.Cache + [fiBlobs]
    else
      FFetch.Cache := FFetch.Cache - [fiBlobs];
  if GetSrcBool(szENABLESCHEMACACHE, lVal) then
    if lVal then
      FFetch.Cache := FFetch.Cache + [fiMeta]
    else
      FFetch.Cache := FFetch.Cache - [fiMeta];
  if GetSrcInt(szMAXROWS, iVal) and (iVal <> -1) then
    FFetch.RecsMax := iVal;
  if GetSrcStr(szPASSWORD, sVal) and (sVal <> '') then
    FDestParams.Values[S_AD_ConnParam_Common_Password] := sVal;
  if (GetSrcStr(szUSERNAME, sVal) or GetSrcStr(UpperCase(S_AD_ConnParam_Common_BDEStyleUserName), sVal)) and
     (sVal <> '') then
    FDestParams.Values[S_AD_ConnParam_Common_UserName] := sVal;
  if GetSrcInt(szCFGDRVTRACEMODE, iVal) and (iVal > 0) then begin
    if iVal <> 0 then
      sVal := S_AD_MoniRemote
    else
      sVal := '';
    FDestParams.Values[S_AD_ConnParam_Common_MonitorBy] := sVal;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportOracle(AImportMode: Boolean);
var
  sVal: String;
  lVal: Boolean;
  oRule: TADMapRule;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_OraId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if GetSrcBool(szORAINTEGER, lVal) and lVal then begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.ScaleMin := 0;
    oRule.ScaleMax := 0;
    oRule.PrecMin := 0;
    oRule.PrecMax := 5;
    oRule.TargetDataType := dtInt16;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.ScaleMin := 0;
    oRule.ScaleMax := 0;
    oRule.PrecMin := 6;
    oRule.PrecMax := 10;
    oRule.TargetDataType := dtInt32;
  end;
  if GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal then begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtDouble;
    oRule.TargetDataType := dtBCD;
  end
  else begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.TargetDataType := dtDouble;
  end;
  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtAnsiString;
  oRule.SizeMin := 256;
  oRule.TargetDataType := dtMemo;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtWideString;
  oRule.SizeMax := 255;
  oRule.TargetDataType := dtAnsiString;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtWideString;
  oRule.SizeMin := 256;
  oRule.TargetDataType := dtMemo;

  if AImportMode then begin
    if GetSrcStr(szCFGDRVVENDINIT, sVal) and (CompareText(sVal, 'OCI.DLL') <> 0) then
      FDestParams.Values[S_AD_DrvVendorLib] := sVal;
    if GetSrcStr(szSERVERNAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportIB(AImportMode: Boolean);
var
  sVal: String;
  lVal: Boolean;
  oRule: TADMapRule;
begin
  // all TX related settings are not imported
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_IBId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal then begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtCurrency;
    oRule.TargetDataType := dtBCD;
  end
  else begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.TargetDataType := dtDouble;
  end;
  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtAnsiString;
  oRule.SizeMin := 256;
  oRule.TargetDataType := dtMemo;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtByteString;
  oRule.SizeMin := 256;
  oRule.TargetDataType := dtMemo;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtWideString;
  oRule.SizeMax := 255;
  oRule.TargetDataType := dtAnsiString;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtWideString;
  oRule.SizeMin := 256;
  oRule.TargetDataType := dtMemo;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtDateTimeStamp;
  oRule.TargetDataType := dtDateTime;

  if AImportMode then begin
    if GetSrcStr(szCFGDRVVENDINIT, sVal) and (CompareText(sVal, 'GDS32.DLL') <> 0) then
      FDestParams.Values[S_AD_DrvVendorLib] := sVal;
    if GetSrcStr(szSERVERNAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportMSSQL(AImportMode: Boolean);
var
  sVal: String;
  lVal: Boolean;
  iVal: Integer;
  oRule: TADMapRule;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_MSSQLId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal then begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtDouble;
    oRule.ScaleMin := 1;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtDouble;
    oRule.ScaleMin := 1;
    oRule.PrecMax := 17;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtDouble;
    oRule.ScaleMin := 1;
    oRule.PrecMin := 19;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtInt64;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtCurrency;
    oRule.TargetDataType := dtBCD;
  end
  else begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.TargetDataType := dtDouble;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtInt64;
    oRule.TargetDataType := dtDouble;
  end;
  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtDateTimeStamp;
  oRule.TargetDataType := dtDateTime;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtByte;
  oRule.TargetDataType := dtInt16;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtGUID;
  oRule.TargetDataType := dtByteString;

  if AImportMode then begin
    if GetSrcInt(szMAXQUERYTIME, iVal) and (iVal <> $7FFFFFFF) then
      FRes.CmdExecTimeout := iVal * 1000;
    if GetSrcStr(szSYBLAPP, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_ApplicationName] := sVal;
    if GetSrcStr(szDATABASENAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    if GetSrcStr(szSYBLHOST, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSSQL_Address] := sVal;
    if GetSrcStr(szSYBLNATLANG, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSSQL_Language] := sVal;
    if GetSrcStr(szSERVERNAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Server] := sVal;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportMSAccess(AImportMode: Boolean);
var
  sVal: String;
  oRule: TADMapRule;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_MSAccId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtBCD;
  oRule.TargetDataType := dtDouble;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtDateTimeStamp;
  oRule.TargetDataType := dtDateTime;

  if AImportMode then begin
    if GetSrcStr(szDATABASENAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sVal;
    if GetSrcStr(szCFGSYSTEMDB, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_MSAcc_SysDB] := sVal;
    if GetSrcStr(szUSERNAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_UserName] := sVal;
    if GetSrcStr(szPASSWORD, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Password] := sVal;
    if GetSrcStr(szOPENMODE, sVal) and (CompareText(sVal, szREADONLY) = 0) then
      FDestParams.Values[S_AD_ConnParam_MSAcc_RO] := S_AD_True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportDB2(AImportMode: Boolean);
var
  sVal: String;
  lVal: Boolean;
  iVal: Integer;
  oRule: TADMapRule;
begin
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_DB2Id;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;

  if not (GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal) then begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.TargetDataType := dtDouble;
  end;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtDateTimeStamp;
  oRule.TargetDataType := dtDateTime;

  if AImportMode then begin
    if GetSrcInt(szMAXQUERYTIME, iVal) and (iVal <> $7FFFFFFF) then
      FRes.CmdExecTimeout := iVal * 1000;
    if GetSrcStr('DB2 DSN', sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_DB2_Alias] := sVal;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportMySQL(AImportMode: Boolean);
begin
  { TODO : In BDE MySQL was supported through ODBC. Test BDE & MySQL. }
  ImportODBC(AImportMode);
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.ImportODBC(AImportMode: Boolean);
var
  sDrv, sVal: String;
  lVal: Boolean;
  oRule: TADMapRule;
begin
  if GetSrcStr(szCFGODBCDSN, sVal) then begin
    { TODO : Get RDBMS kind. If MySQL then Import to MySQL.
             Else set S_AD_ConnParam_Common_RDBMSKind value. }
  end;
  if AImportMode then
    FDestParams.Values[S_AD_ConnParam_Common_DriverID] := S_AD_ODBCId;
  FFmt.OwnMapRules := True;
  FFmt.MaxBcdPrecision := $7FFFFFFF;
  FFmt.MaxBcdScale := $7FFFFFFF;
  if GetSrcBool(szCFGDBENABLEBCD, lVal) and lVal then begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtDouble;
    oRule.ScaleMin := 1;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtDouble;
    oRule.ScaleMin := 1;
    oRule.PrecMax := 17;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtDouble;
    oRule.ScaleMin := 1;
    oRule.PrecMin := 19;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.ScaleMin := 0;
    oRule.ScaleMax := 0;
    oRule.PrecMin := 18;
    oRule.PrecMax := 18;
    oRule.TargetDataType := dtDouble;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtInt64;
    oRule.TargetDataType := dtBCD;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtCurrency;
    oRule.TargetDataType := dtBCD;
  end
  else begin
    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtBCD;
    oRule.TargetDataType := dtDouble;

    oRule := FFmt.MapRules.Add;
    oRule.SourceDataType := dtInt64;
    oRule.TargetDataType := dtDouble;
  end;
  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtDateTimeStamp;
  oRule.TargetDataType := dtDateTime;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtByte;
  oRule.TargetDataType := dtInt16;

  oRule := FFmt.MapRules.Add;
  oRule.SourceDataType := dtGUID;
  oRule.TargetDataType := dtByteString;

  if AImportMode then begin
    if GetSrcStr(szTYPe, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_ODBC_Driver] := sVal;
    if GetSrcStr(szCFGODBCDSN, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_ODBC_DataSource] := sVal;
    if GetSrcStr(szDATABASENAME, sVal) and (sVal <> '') then
      FDestParams.Values[S_AD_ConnParam_Common_Database] := sDrv;
    ImportSQLCommon;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.MakeBDECompatible(
  const AConnectionDef: IADStanConnectionDef; AEnableBCD, AEnableInteger: Boolean);
var
  sType, sDrv: String;
begin
  FSrcParams := TADStringList.Create;
{$IFDEF AnyDAC_D6}
  FSrcParams.CaseSensitive := False;
{$ENDIF}
  FSrcParams.Sorted := True;
  FSrcParams.Duplicates := dupAccept;
  if AEnableBCD then
    FSrcParams.Add(szCFGDBENABLEBCD + '=' + UpperCase(S_AD_True));
  if AEnableInteger then
    FSrcParams.Add(szORAINTEGER + '=' + UpperCase(S_AD_True));

  FDestParams := AConnectionDef.Params;
  FFetch := TADFetchOptions.Create(nil);
  FFmt := TADFormatOptions.Create(nil);
  FUpd := TADUpdateOptions.Create(nil);
  FRes := TADResourceOptions.Create(nil);
  AConnectionDef.ReadOptions(FFmt, FUpd, FFetch, FRes);

  try
    sType := AConnectionDef.DriverID;
    if CompareText(sType, S_AD_OraId) = 0 then
      ImportOracle(False)
    else if CompareText(sType, S_AD_IBId) = 0 then
      ImportIB(False)
    else if CompareText(sType, S_AD_MySQLId) = 0 then
      ImportMySQL(False)
    else if CompareText(sType, S_AD_MSSQLId) = 0 then
      ImportMSSQL(False)
    else if CompareText(sType, S_AD_MSAccId) = 0 then
      ImportMSAccess(False)
    else if CompareText(sType, S_AD_DB2Id) = 0 then
      ImportDB2(False)
    else if (CompareText(sType, S_AD_DBXId) = 0) or
            (CompareText(sType, S_AD_TDBXId) = 0) then begin
      sType := UpperCase(AConnectionDef.AsString[S_AD_ConnParam_Common_RDBMSKind]);
      sDrv := UpperCase(AConnectionDef.AsString[DRIVERNAME_KEY]);
      if (sType = C_AD_PhysRDBMSKinds[mkMSSQL]) and (sDrv = S_OpenODBC) then
        ImportMSSQL(False)
      else if (sType = C_AD_PhysRDBMSKinds[mkMSAccess]) and (sDrv = S_OpenODBC) then
        ImportMSAccess(False)
      else if (sType = C_AD_PhysRDBMSKinds[mkDB2]) and (sDrv = S_OpenODBC) then
        ImportDB2(False)
      else if CompareText(sDrv, S_OpenODBC) = 0 then
        ImportODBC(False)
      else
        raise Exception.Create(S_AD_CantMakeConnDefBDEComp);
    end;
    AConnectionDef.WriteOptions(FFmt, FUpd, FFetch, FRes);

  finally
    ADFreeAndNil(FSrcParams);
    FDestParams := nil;
    ADFreeAndNil(FFetch);
    ADFreeAndNil(FFmt);
    ADFreeAndNil(FUpd);
    ADFreeAndNil(FRes);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBDEAliasImporter.Execute;
var
  i, j: Integer;
  oAliases, oDrvParams: TADStringList;
  sType, sName: String;
  oDefs: IADStanConnectionDefs;
  oDef: IADStanConnectionDef;
  iOverwrite: Integer;
begin
  oAliases := TADStringList.Create;
  oDrvParams := TADStringList.Create;
  FSrcParams := TADStringList.Create;
{$IFDEF AnyDAC_D6}
  FSrcParams.CaseSensitive := False;
{$ENDIF}
  FSrcParams.Sorted := True;
  FSrcParams.Duplicates := dupAccept;
  FDestParams := TADStringList.Create;
  FOpts := TADOptionsContainer.Create(nil, TADFetchOptions, TADUpdateOptions,
    TADResourceOptions, nil);
  FFetch := FOpts.FetchOptions;
  FFmt := FOpts.FormatOptions;
  FUpd := FOpts.UpdateOptions;
  FRes := FOpts.ResourceOptions;
  ADCreateInterface(IADStanConnectionDefs, oDefs);
  if FConnectionDefFileName <> '' then
    oDefs.Storage.FileName := FConnectionDefFileName;
  oDefs.Load;
  try
    Session.GetAliasNames(oAliases);
    for i := 0 to oAliases.Count - 1 do
      if (FAliasesToImport.Count = 0) or (FAliasesToImport.IndexOf(oAliases[i]) <> -1) then begin
        FDestParams.Clear;
        sType := Session.GetAliasDriverName(oAliases[i]);
        Session.GetDriverParams(sType, oDrvParams);
        Session.GetAliasParams(oAliases[i], FSrcParams);
        for j := 0 to oDrvParams.Count - 1 do
          if FSrcParams.IndexOfName(ADNameFromIndex(oDrvParams, j)) = -1 then
            FSrcParams.Add(oDrvParams[j]);
        if sType = C_AD_PhysRDBMSKinds[mkOracle] then
          ImportOracle(True)
        else if sType = C_AD_PhysRDBMSKinds[mkInterbase] then
          ImportIB(True)
        else if sType = C_AD_PhysRDBMSKinds[mkMSSQL] then
          ImportMSSQL(True)
        else if sType = C_AD_PhysRDBMSKinds[mkMSAccess] then
          ImportMSAccess(True)
        else if sType = C_AD_PhysRDBMSKinds[mkDB2] then
          ImportDB2(True)
        else if FSrcParams.IndexOfName(szCFGODBCDSN) <> -1 then
          ImportODBC(True)
        else begin
          ShowMessage(Format('BDE driver [%s] is not supported.'#13#10 +
                             'Alias [%s] cannot be converted.', [sType, oAliases[i]]));
          Continue;
        end;
        if OverwriteDefs then begin
          oDef := oDefs.FindConnectionDef(oAliases[i]);
          if (oDef <> nil) and Assigned(FOnOverwrite) then begin
            iOverwrite := 1;
            FOnOverwrite(oAliases[i], iOverwrite);
            if iOverwrite = 0 then
              oDef := nil
            else if iOverwrite = -1 then
              Exit;
          end
        end
        else
          oDef := nil;
        if oDef = nil then
          oDef := oDefs.Add as IADStanConnectionDef;
        oDef.Params.Assign(FDestParams);
        sName := oAliases[i];
        if not OverwriteDefs then begin
          j := 0;
          while oDefs.FindConnectionDef(sName) <> nil do begin
            Inc(j);
            sName := Format('%s_%d', [oAliases[i], j]);
          end;
        end;
        oDef.Name := sName;
        oDef.WriteOptions(FFmt, FUpd, FFetch, FRes);
        oDef.MarkPersistent;
      end;
    oDefs.Save;
  finally
    ADFreeAndNil(oAliases);
    ADFreeAndNil(oDrvParams);
    ADFreeAndNil(FSrcParams);
    ADFreeAndNil(FDestParams);
    FFetch := nil;
    FFmt := nil;
    FUpd := nil;
    FRes := nil;
    FOpts := nil;
  end;
end;

(*
--------------------------
ALL

'TYPE'                f('DriverID') # not dbExpress
                      'DriverId = S_AD_DBXId' & 'DriverName = Oracle' # dbExpress
'DLL32'               x

--------------------------
SQL Common

'BLOB SIZE'           'BlobSize' # dbExpress
'BLOBS TO CACHE'      f('FetchOptions.Cache' & fiBlobs)
'ENABLE SCHEMA CACHE' f('FetchOptions.Cache' & fiMeta)
'LANGDRIVER'          x
'MAX ROWS'            'FetchOptions.RecsMax'
'PASSWORD'            'Password'
'SCHEMA CACHE DIR'    x
'SCHEMA CACHE SIZE'   x
'SCHEMA CACHE TIME'   x
'SQLPASSTHRU MODE'    x
'SQLQRYMODE'          x
'USER NAME'           'User_Name'
'TRACE MODE'          'Tracing'

--------------------------
Oracle

'ENABLE BCD'          f('FormatOptions.MapRules')
'ENABLE INTEGERS'     f('FormatOptions.MapRules')
'LIST SYNONYMS'       x
'NET PROTOCOL'        x
'OBJECT MODE'         x
'ROWSET SIZE'         'FetchOptions.RowsetSize' # not dbExpress
                      'RowsetSize'              # dbExpress
'SERVER NAME'         'Database'
'VENDOR INIT'         'VendorLib'

--------------------------
MSSQL

'APPLICATION NAME'    'App'=v
'BLOB EDIT LOGGING'   x
'CONNECT TIMEOUT'     x
'DATABASE NAME'       'Database'=v
'DATE MODE'           x
'ENABLE BCD'          f('FormatOptions.MapRules')
'HOST NAME'           'Address'=v
'NATIONAL LANG NAME'  'Language'=v
'MAX QUERY TIME'      'ResourceOptions.CmdExecTimeout'=v*1000
'SERVER NAME'         'Server'=v
'TDS PACKET SIZE'     x
'TIMEOUT'             x

--------------------------
IB
'BATCH COUNT'         x
'COMMIT RETAIN'       ?
'ENABLE BCD'          f('FormatOptions.MapRules')
'OPEN MODE'           ?
'ROLE NAME'           'RoleName'=v
'SERVER NAME'         'Database'=v
'WAIT ON LOCKS'       ?

--------------------------
MSAccess

'DATABASE NAME'       'DBQ'=v
'LANGDRIVER'          x
'OPEN MODE'           'ReadOnly'=READ/WRITE -> 0, READ ONLY -> 1
'SYSTEM DATABASE'     'SystemDB'=v
'USER NAME'           'UID'=v
'PASSWORD'            'PWD'=v


--------------------------
ODBC

'BATCH COUNT'         x
'DATABASE NAME'       'Database'=v
'ENABLE BCD'          f('FormatOptions.MapRules')
'ODBC DSN'            'DSN'=v
'OPEN MODE'           'ReadOnly'=READ/WRITE -> 0, READ ONLY -> 1
'ROWSET SIZE'         'FetchOptions.RowsetSize' # not dbExpress
                      'RowsetSize'              # dbExpress
*)
end.

