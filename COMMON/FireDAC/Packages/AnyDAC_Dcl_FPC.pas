{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit AnyDAC_Dcl_FPC;

interface

uses
  uADStanUtil, uADCompClient, uADCompDataMove, uADCompDataSet, uADCompGUIx, 
  uADCompScript, uADCompScriptCommands, uADDAptColumn, uADDAptIntf, 
  uADDAptManager, uADDatSManager, uADGUIxConsoleScript, uADGUIxConsoleWait, 
  uADGUIxIntf, uADMoniBase, uADMoniCustom, uADMoniFlatFile, uADPhysADS, 
  uADPhysADSMeta, uADPhysASA, uADPhysASAMeta, uADPhysCmdGenerator, 
  uADPhysCmdPreprocessor, uADPhysConnMeta, uADPhysDB2, uADPhysDB2Meta, 
  uADPhysIB, uADPhysIBCli, uADPhysIBMeta, uADPhysIBWrapper, uADPhysIntf,
  uADPhysManager, uADPhysMSAcc, uADPhysMSAccMeta, uADPhysMSSQL, uADPhysMSSQLMeta,
  uADPhysMySQL, uADPhysMySQLCli, uADPhysMySQLWrapper, uADPhysODBC, uADPhysODBCBase,
  uADPhysODBCCli, uADPhysODBCMeta, uADPhysODBCWrapper, uADPhysOracle, 
  uADPhysOracleCli, uADPhysOracleMeta, uADPhysOracleWrapper, uADStanAsync, 
  uADStanConst, uADStanDef, uADStanError, uADStanExpr, uADStanFactory, 
  uADStanIntf, uADStanOption, uADStanParam, uADStanPool, uADStanResStrs, 
  uADStanStorage, uADStanTracer, uADMoniRemoteClient, uADMoniRemoteBase, 
  uADStanExprFuncs, uADPhysPG, uADPhysPGCli, uADPhysPGMeta, uADPhysPGWrapper, 
  uADPhysSQLite, uADPhysSQLiteCli, uADPhysSQLiteMeta, uADPhysSQLiteWrapper, 
  uADStanSQLTimeInt, uADPhysASACli, uADPhysASAWrapper, uADGUIxFormsControls, 
  uADGUIxFormsMemo, uADGUIxFormsfAbout, uADGUIxFormsfOptsBase, 
  uADGUIxFormsfAsync, uADGUIxFormsfConnEdit, uADGUIxFormsfDesignTimeOptions, 
  uADGUIxFormsfError, uADGUIxFormsfFetchOptions, uADGUIxFormsfFields, 
  uADGUIxFormsfFormatOptions, uADGUIxFormsfLogin, uADGUIxFormsfQEdit, 
  uADGUIxFormsfResourceOptions, uADGUIxFormsfScript, 
  uADGUIxFormsfUpdateOptions, uADGUIxFormsfUSEdit, uADCompReg, uADPhysADSCli, 
  uADPhysADSWrapper, uADPhysNexusMeta, uADPhysSQLiteVDataSet, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('uADCompReg', @uADCompReg.Register);
end;

initialization
  RegisterPackage('AnyDAC_Dcl_FPC', @Register);
end.
