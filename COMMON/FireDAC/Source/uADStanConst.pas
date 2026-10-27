{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                   FireDAC constants                   }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanConst;

interface

uses
{$IFDEF MSWINDOWS}
  Messages,
{$ENDIF}
{$IFDEF AnyDAC_FPC}
  DB,
{$ENDIF}
  uADStanIntf;

const
  C_AD_Version = '8.0.5 (Build 3365)';
  C_AD_Copyright = Chr($A9) + ' Embarcadero Technologies 2004-2013';
  C_AD_Product = 'FireDAC';
  C_AD_ProductFull = 'Embarcadero' + Chr($AE) + ' ' + C_AD_Product;
  C_AD_Link = 'http://www.embarcadero.com/products/rad-studio/firedac';
  C_AD_Docu_Link = 'http://docs.embarcadero.com/products/rad_studio/firedac/';
  C_AD_FAQ_Link = C_AD_Docu_Link + 'FAQ.html';
  C_AD_Forums_Link = C_AD_Link + 'forums.html';

  // EOL's
  C_AD_WinEOL = #13#10;
  C_AD_UnixEOL = #10;
  C_AD_MacEOL = #13;
{$IFDEF MSWINDOWS}
  C_AD_EOL = C_AD_WinEOL;
  C_AD_PathDelim = '\';
  C_AD_DLLExt = '.dll';
  C_AD_DLLFolder = 'bin';
{$ENDIF}
{$IFDEF UNIX}
  {$IFNDEF MACOS}
  C_AD_EOL = C_AD_UnixEOL;
  C_AD_PathDelim = '/';
  C_AD_DLLExt = '.so';
  C_AD_DLLFolder = 'lib';
  {$ENDIF}
{$ENDIF}
{$IFDEF MACOS}
  C_AD_EOL = C_AD_MacEOL;
  C_AD_PathDelim = '/';
  C_AD_DLLExt = '.dylib';
  C_AD_DLLFolder = 'lib';
{$ENDIF}

  // Common
{$IFDEF MSWINDOWS}
  C_AD_WM_Base    = WM_USER + 1000;
{$ENDIF}
  C_AD_GUIDStrLen = 38;
  C_AD_MaxNameLen = 128;
  C_AD_StorageVer = 9;

  // Layer ID's
  S_AD_LStan = 'Stan';
  S_AD_LStan_PEval = 'Eval';
  S_AD_LStan_PDef = 'Def';
  S_AD_LGUIx = 'GUIx';
  S_AD_LGUIx_PForms = 'Forms';
  S_AD_LGUIx_PSrvc = 'Services';
  S_AD_LMoni = 'Moni';
  S_AD_LMoni_PRemote = 'Remote';
  S_AD_LMoni_PFF = 'FlatFile';
  S_AD_LDatS = 'DatS';
  S_AD_LPhys = 'Phys';
  S_AD_LDApt = 'DApt';
  S_AD_LComp = 'Comp';
  S_AD_LComp_PClnt = 'Clnt';
  S_AD_LComp_PDS = 'DS';
  S_AD_LComp_PDM = 'DM';
  S_AD_LComp_PScr = 'Script';
  S_AD_LComp_Design = 'Design';

  // Driver ID's
  S_AD_DBXId = 'DBX';
  S_AD_TDBXId = 'TDBX';
  S_AD_ODBCId = 'ODBC';
  S_AD_MSSQLId = 'MSSQL';
  S_AD_MSAccId = 'MSAcc';
  S_AD_DB2Id = 'DB2';
  S_AD_MySQLId = 'MySQL';
  S_AD_OraId = 'Ora';
  S_AD_ASAId = 'ASA';
  S_AD_ADSId = 'ADS';
  S_AD_IBId = 'IB';
  S_AD_PGId = 'PG';
  S_AD_SQLiteId = 'SQLite';
  S_AD_NexusId = 'Nexus';
  S_AD_DataSnapId = 'DataSnap';

  // Definition standard parameters
  S_AD_DefinitionParam_Common_Name = 'Name';
  S_AD_DefinitionParam_Common_Parent = 'Parent';
  S_AD_DefinitionParam_Common_ConnectionDef = 'ConnectionDef';

  // Driver definition parameters
  C_AD_DrvBaseId = 'BaseDriverID';
  S_AD_DrvVendorLib = 'VendorLib';
  S_AD_DrvVendorHome = 'VendorHome';
  S_AD_Win32 = 'Win32';
  S_AD_Win64 = 'Win64';
  S_AD_OSX32 = 'OSX32';
  S_AD_OSX64 = 'OSX64';
  S_AD_UIX32 = 'UIX32';
  S_AD_UIX64 = 'UIX64';

  // Monitor ID names
  S_AD_MoniFlatFile = 'FlatFile';
  S_AD_MoniRemote = 'Remote';
  S_AD_MoniCustom = 'Custom';

  // Connection definition standard parameters
  S_AD_ConnParam_Common_DriverID = 'DriverID';
  S_AD_ConnParam_Common_Database = 'Database';
  S_AD_ConnParam_Common_Server = 'Server';
  S_AD_ConnParam_Common_Port = 'Port';
  S_AD_ConnParam_Common_UserName = 'User_Name';
  S_AD_ConnParam_Common_BDEStyleUserName = 'User name';
  S_AD_ConnParam_Common_Password = 'Password';
  S_AD_ConnParam_Common_NewPassword = 'NewPassword';
  S_AD_ConnParam_Common_OSAuthent = 'OSAuthent';
  S_AD_ConnParam_Common_Pooled = 'Pooled';
  S_AD_ConnParam_Common_MetaDefSchema = 'MetaDefSchema';
  S_AD_ConnParam_Common_MetaDefCatalog = 'MetaDefCatalog';
  S_AD_ConnParam_Common_MetaCurSchema = 'MetaCurSchema';
  S_AD_ConnParam_Common_MetaCurCatalog = 'MetaCurCatalog';
  S_AD_ConnParam_Common_MetaCaseIns = 'MetaCaseIns';
  S_AD_ConnParam_Common_RDBMSKind = 'RDBMS';
  S_AD_ConnParam_Common_MonitorBy = 'MonitorBy';
  S_AD_ConnParam_Common_LoginTimeout = 'LoginTimeout';
  S_AD_ConnParam_Common_CharacterSet = 'CharacterSet';
  S_AD_ConnParam_Common_ExtendedMetadata = 'ExtendedMetadata';
  S_AD_ConnParam_Common_ApplicationName = 'ApplicationName';

  // MySQL parameters
  S_AD_ConnParam_MySQL_Compress = 'Compress';
  S_AD_ConnParam_MySQL_UseSSL = 'UseSSL';
  S_AD_ConnParam_MySQL_SSL_key = 'SSL_key';
  S_AD_ConnParam_MySQL_SSL_cert = 'SSL_cert';
  S_AD_ConnParam_MySQL_SSL_ca = 'SSL_ca';
  S_AD_ConnParam_MySQL_SSL_capath = 'SSL_capath';
  S_AD_ConnParam_MySQL_SSL_cipher = 'SSL_cipher';
  S_AD_ConnParam_MySQL_ResultMode = 'ResultMode';
  S_AD_ConnParam_MySQL_TinyIntFormat = 'TinyIntFormat';
  S_AD_ConnParam_MySQL_EmbeddedArgs = 'EmbeddedArgs';
  S_AD_ConnParam_MySQL_EmbeddedGroups = 'EmbeddedGroups';
  S_AD_ConnParam_MySQL_ReadTimeout = 'ReadTimeout';
  S_AD_ConnParam_MySQL_WriteTimeout = 'WriteTimeout';

  // Base ODBC parameters
  S_AD_ConnParam_ODBC_Advanced = 'ODBCAdvanced';
  S_AD_ConnParam_ODBC_Driver = 'ODBCDriver';
  S_AD_ConnParam_ODBC_DataSource = 'DataSource';
  S_AD_ConnParam_ODBC_DSN = 'DSN';
  S_AD_ConnParam_ODBC_NumericFormat = 'NumericFormat';

  // MSSQL paramaters
  S_AD_ConnParam_MSSQL_Network = 'Network';
  S_AD_ConnParam_MSSQL_Address = 'Address';
  S_AD_ConnParam_MSSQL_MARS = 'MARS';
  S_AD_ConnParam_MSSQL_Workstation = 'Workstation';
  S_AD_ConnParam_MSSQL_Language = 'Language';
  S_AD_ConnParam_MSSQL_Encrypt = 'Encrypt';
  S_AD_ConnParam_MSSQL_VariantFormat = 'VariantFormat';

  S_AD_EventKind_MSSQL_Events = 'QueryNotifies';

  // MSAccess parameters
  S_AD_ConnParam_MSAcc_SysDB = 'SystemDB';
  S_AD_ConnParam_MSAcc_RO = 'ReadOnly';
  S_AD_ConnParam_MSAcc_StringFormat = 'StringFormat';

  // ASA parameters
  S_AD_ConnParam_ASA_ToolLib = 'ToolLib';

  S_AD_ConnParam_ASA_DatabaseFile = 'DatabaseFile';
  S_AD_ConnParam_ASA_Compress = S_AD_ConnParam_MySQL_Compress;
  S_AD_ConnParam_ASA_Encrypt = S_AD_ConnParam_MSSQL_Encrypt;

  S_AD_EventKind_ASA_Events = 'Message';

  // ADS parameters
  S_AD_ConnParam_ADS_DateFormat = 'DateFormat';
  S_AD_ConnParam_ADS_Decimals = 'Decimals';
  S_AD_ConnParam_ADS_DefaultPath = 'DefaultPath';
  S_AD_ConnParam_ADS_SearchPath = 'SearchPath';
  S_AD_ConnParam_ADS_ShowDeleted = 'ShowDeleted';
  S_AD_ConnParam_ADS_Epoch = 'Epoch';
  S_AD_ConnParam_ADS_Exact = 'Exact';

  S_AD_ConnParam_ADS_Alias = 'Alias';
  S_AD_ConnParam_ADS_Protocol = 'Protocol';
  S_AD_ConnParam_ADS_Compress = S_AD_ConnParam_MySQL_Compress;
  S_AD_ConnParam_ADS_ServerTypes = 'ServerTypes';
  S_AD_ConnParam_ADS_Locking = 'Locking';
  S_AD_ConnParam_ADS_TableType = 'TableType';
  S_AD_ConnParam_ADS_TablePassword = 'TablePassword';
  S_AD_ConnParam_ADS_Advanced = 'ADSAdvanced';

  S_AD_EventKind_ADS_Events = 'Events';

  // Oracle parameters
  S_AD_ConnParam_Oracle_AuthMode = 'AuthMode';
//  S_AD_ConnParam_Oracle_Distributed = 'Distributed';
//  S_AD_ConnParam_Oracle_SrvIntName = 'Dist_SrvIntName';
  S_AD_ConnParam_Oracle_BooleanFormat = 'BooleanFormat';
  S_AD_ConnParam_Oracle_Advanced = 'OracleAdvanced';
  S_AD_ConnParam_Oracle_NLS_LANG = 'NLSLang';
  S_AD_ConnParam_Oracle_TNS_ADMIN = 'TNSAdmin';
  S_AD_ConnParam_Oracle_Threaded = 'Threaded';

  S_AD_EventKind_Oracle_DBMS_ALERT = 'DBMS_ALERT';
  S_AD_EventKind_Oracle_DBMS_PIPE = 'DBMS_PIPE';

  // IB parameters
  S_AD_ConnParam_IB_Protocol = S_AD_ConnParam_ADS_Protocol;
  S_AD_ConnParam_IB_InstanceName = 'InstanceName';
  S_AD_ConnParam_IB_RoleName = 'RoleName';
  S_AD_ConnParam_IB_SQLDialect = 'SQLDialect';
  S_AD_ConnParam_IB_CreateDatabase = 'CreateDatabase';
  S_AD_ConnParam_IB_DropDatabase = 'DropDatabase';
  S_AD_ConnParam_IB_PageSize = 'PageSize';
  S_AD_ConnParam_IB_Advanced = 'IBAdvanced';

  S_AD_EventKind_IB_Events = 'Events';

  // DB2 parameters
  S_AD_ConnParam_DB2_Alias = 'Alias';
  S_AD_ConnParam_DB2_Protocol = S_AD_ConnParam_ADS_Protocol;
  S_AD_ConnParam_DB2_Trusted = 'Trusted';
  S_AD_ConnParam_DB2_StringFormat = S_AD_ConnParam_MSAcc_StringFormat;

  // PG parameters
  S_AD_ConnParam_PG_OidAsBlob = 'OidAsBlob';
  S_AD_ConnParam_PG_UnknownFormat = 'UnknownFormat';
  S_AD_ConnParam_PG_Advanced = 'PGAdvanced';

  S_AD_EventKind_PG_Events = 'Notifies';

  // SQLite parameters
  S_AD_ConnParam_SQLite_SharedCache = 'SharedCache';
  S_AD_ConnParam_SQLite_OpenMode = 'OpenMode';
  S_AD_ConnParam_SQLite_Encrypt = S_AD_ConnParam_MSSQL_Encrypt;
  S_AD_ConnParam_SQLite_BusyTimeout = 'BusyTimeout';
  S_AD_ConnParam_SQLite_CacheSize = 'CacheSize';
  S_AD_ConnParam_SQLite_LockingMode = 'LockingMode';
  S_AD_ConnParam_SQLite_Synchronous = 'Synchronous';
  S_AD_ConnParam_SQLite_JournalMode = 'JournalMode';
  S_AD_ConnParam_SQLite_ForeignKeys = 'ForeignKeys';
  S_AD_ConnParam_SQLite_StringFormat = S_AD_ConnParam_MSAcc_StringFormat;
  S_AD_ConnParam_SQLite_GUIDFormat = 'GUIDFormat';
  S_AD_ConnParam_SQLite_DateTimeFormat = 'DateTimeFormat';
  S_AD_ConnParam_SQLite_Extensions = 'Extensions';
  S_AD_ConnParam_SQLite_Advanced = 'SQLiteAdvanced';

  S_AD_EventKind_SQLite_Events = 'Events';

  // Nexus parameters
  S_AD_ConnParam_Nexus_Protocol = S_AD_ConnParam_ADS_Protocol;
  S_AD_ConnParam_Nexus_OpenMode = 'OpenMode';
  S_AD_ConnParam_Nexus_ShareMode = 'ShareMode';

  // dbExpress / DataSnap
  S_AD_ConnParam_TDBX_Advanced = 'DBXAdvanced';
  S_AD_ConnParam_DataSnap_Protocol = S_AD_ConnParam_ADS_Protocol;

  S_AD_EventKind_DataSnap_Events = 'Callbacks';

{$IFDEF MSWINDOWS}
  // Async exec messages
  C_AD_WM_ASYNC_DONE = C_AD_WM_Base + 1;
  // Monitor
  C_AD_WM_MoniMainFrmRunning = C_AD_WM_Base + 10;
{$ENDIF}

  // Pool definition parameters
  S_AD_PoolParam_CleanupTimeout = 'POOL_CleanupTimeout';
  S_AD_PoolParam_ExpireTimeout = 'POOL_ExpireTimeout';
  S_AD_PoolParam_MaximumItems = 'POOL_MaximumItems';

  // Pool default values
  C_AD_PoolCleanupTimeout = 30000;
  C_AD_PoolExpireTimeout = 90000;
  C_AD_PoolCloseTimeout = 10000;
  C_AD_PoolMaximumItems = 50;

  // Wait default values
  C_AD_HideCursorDelay = 50;
  C_AD_DelayBeforeFWait = 200;

  // Thread default values
  C_AD_ThreadStartupTimeout = 1000;
  C_AD_ThreadIdleTimeout = 1000;

  // Phys manager default timeout values
  C_AD_PhysManagerShutdownTimeout = 10000;

  // Auto reconnect values
  C_AD_PhysConnRetryDelay = 3000;
  C_AD_PhysConnRetryCount = 3;

  // Definition related
{$IFDEF MSWINDOWS}
  S_AD_Main = '';
  S_AD_CfgKeyName = '\Software\Embarcadero\FireDAC';
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  S_AD_Main = 'main';
  // The following is a path in HOME directory
  S_AD_CfgFile = {$IFDEF IOS} 'ad.conf' {$ELSE} '.firedac/ad.conf' {$ENDIF};
{$ENDIF}
  S_AD_DefCfgFileName = 'ADConnectionDefs.ini';
  S_AD_DefDrvFileName = 'ADDrivers.ini';
  S_AD_CfgValName = 'ConnectionDefFile';
  S_AD_DrvValName = 'DriverFile';
  S_AD_MoniValName = 'MonitorPath';
  S_AD_ExplValName = 'ExplorerPath';
  S_AD_ExecValName = 'ExecutorPath';
  S_AD_HelpValName = 'HelpPath';
  S_AD_Profiles = 'Profiles';
  S_AD_Drivers = 'Drivers';
  S_AD_DesignTime = 'DesignTime';
  S_AD_DTCatalog = 'Catalog';
  S_AD_DTSchema = 'Schema';
  S_AD_DTScope = 'Scope';
  S_AD_DTTableKinds = 'TableKinds';
  S_AD_DTFullName = 'FullName';
  S_AD_DTTracing = 'Tracing';
  S_AD_DTDCFieldsEditor = 'DCFieldsEditor';
  S_AD_DTMask = 'Mask';
  S_AD_True = 'True';
  S_AD_False = 'False';
  S_AD_Yes = 'Yes';
  S_AD_No = 'No';
  S_AD_Bools: array[Boolean] of String = (S_AD_False, S_AD_True);
  S_AD_Local = '<LOCAL>';

  // Monitor default values
  C_AD_MonitorPort = 8050;
  C_AD_MonitorTimeout = 3000;
  C_AD_MonitorFileName = '$(TEMP)' + C_AD_PathDelim + 'trace$(NEXT).txt';
  C_AD_MonitorAppend = False;
  C_AD_MonitorColumns = [tiRefNo, tiTime, tiMsgText];
  C_AD_MonitorEncoding = 0;

  // GUIx
  C_AD_GUIxFormsProvider = 'Forms';
  C_AD_GUIxConsoleProvider = 'Console';
  C_AD_GUIxFMXProvider = 'FMX';

  // DatS
  C_AD_AllTypes = [dtBoolean .. dtObject];
  C_AD_InvariantDataTypes = [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef, dtParentRowRef];
  C_AD_BlobTypes = [dtBlob, dtMemo, dtWideMemo, dtXML, dtHBlob, dtHBFile, dtHMemo, dtWideHMemo];
  C_AD_StrTypes = [dtAnsiString, dtWideString, dtByteString];
  C_AD_VarLenTypes = C_AD_BlobTypes + C_AD_StrTypes;
  C_AD_WideTypes = [dtWideString, dtWideMemo, dtXML, dtWideHMemo];
  C_AD_AnsiTypes = [dtAnsiString, dtMemo, dtHMemo];
  C_AD_CharTypes = C_AD_WideTypes + C_AD_AnsiTypes;
  C_AD_NumTypes = [dtSByte, dtInt16, dtInt32, dtInt64,
                   dtByte, dtUInt16, dtUInt32, dtUInt64,
                   dtSingle, dtDouble, dtExtended,
                   dtCurrency, dtBCD, dtFmtBCD];
  C_AD_NumUnsignedTypes = [dtByte, dtUInt16, dtUInt32, dtUInt64];
  C_AD_NonSearchableDataTypes = C_AD_InvariantDataTypes + C_AD_BlobTypes;
  C_AD_DataTypeNames: array[TADDataType] of String = (
    'Unknown',
    'Boolean',
    'SByte', 'Int16', 'Int32', 'Int64',
    'Byte', 'UInt16', 'UInt32', 'UInt64',
    'Single', 'Double', 'Extended',
    'Currency', 'BCD', 'FmtBCD',
    'DateTime', 'Time', 'Date', 'DateTimeStamp',
    'TimeIntervalFull', 'TimeIntervalYM', 'TimeIntervalDS',
    'AnsiString', 'WideString', 'ByteString',
    'Blob', 'Memo', 'WideMemo', 'XML',
    'HBlob', 'HMemo', 'WideHMemo',
    'HBFile',
    'RowSetRef', 'CursorRef', 'RowRef',
      'ArrayRef', 'ParentRowRef',
    'GUID', 'Object');
  C_AD_SysNamePrefix = '_AD_';
  C_AD_SysSavepointPrefix = 'SP_';
  C_AD_SysColumnPrefix = 'AD__';
  C_AD_MaxAggsPerView = 64;

  C_AD_CrsPctClose = 80;

  S_AD_Pi = '3.141592653589';
  C_AD_Pi =  3.1415926535897932384626433832795;

  // Command generator
  C_AD_CmdGenRight = 60;
  C_AD_CmdGenAlias = 'A';
  C_AD_CmdGenWindow = C_AD_SysColumnPrefix + 'WN_';
  C_AD_CmdGenRangeStart = C_AD_SysColumnPrefix + 'RS_';
  C_AD_CmdGenRangeFinish = C_AD_SysColumnPrefix + 'RF_';
  C_AD_CmdGenLocate = C_AD_SysColumnPrefix + 'LC_';

  // Some Oracle versions
  cvOracle80000 = 800000000;
  cvOracle80300 = 800030000;
  cvOracle80400 = 800040000;
  cvOracle80500 = 800050000;
  cvOracle80501 = 800050001;
  cvOracle81000 = 801000000;
  cvOracle81500 = 801050000;
  cvOracle81600 = 801060000;
  cvOracle90000 = 900010101;
  cvOracle92000 = 902000000;
  cvOracle100000 = 1000000000;
  cvOracle102000 = 1002000000;

  // Some MySQL versions
  mvMySQL032000 = 0320000000;
  mvMySQL032300 = 0323000000;
  mvMySQL032306 = 0323060000;
  mvMySQL032314 = 0323140000;
  mvMySQL032321 = 0323210000;
  mvMySQL040000 = 0400000000;
  mvMySQL040002 = 0400020000;
  mvMySQL040018 = 0400180000;
  mvMySQL040100 = 0401000000;
  mvMySQL040101 = 0401010000;
  mvMySQL041000 = 0410000000;
  mvMySQL050000 = 0500000000;
  mvMySQL050006 = 0500060000;
  mvMySQL050007 = 0500070000;
  mvMySQL050010 = 0500100000;
  mvMySQL050023 = 0500230000;
  mvMySQL050060 = 0500600000;
  mvMySQL050100 = 0501000000;
  mvMySQL050200 = 0502000000;
  mvMySQL050500 = 0505000000;
  mvMySQL050600 = 0506000000;
  mvMySQL060200 = 0602000000;

  // Some MSSQL versions
  svMSSQL6    = 0600000000;
  svMSSQL7    = 0700000000;
  svMSSQL2000 = 0800000000;
  svMSSQL2005 = 0900000000;
  svMSSQL2008 = 1000000000;
  svMSSQL2012 = 1100000000;

  // Some Sybase ASA versions
  cvSybaseASA6 = 0600000000;
  cvSybaseASA8 = 0800000000;
  cvSybaseASA9 = 0900000000;
  cvSybaseASA10 = 1000000000;
  cvSybaseASA11 = 1100000000;
  cvSybaseASA12 = 1200000000;

  // Some SQLite versions
  svSQLite030000 = 0300000000;
  svSQLite030202 = 0302020000;
  svSQLite030304 = 0303040000;
  svSQLite030313 = 0303130000;
  svSQLite030400 = 0304000000;
  svSQLite030401 = 0304010000;
  svSQLite030500 = 0305000000;
  svSQLite030508 = 0305080000;
  svSQLite030600 = 0306000000;
  svSQLite030605 = 0306050000;
  svSQLite030608 = 0306080000;
  svSQLite030611 = 0306110000;
  svSQLite030619 = 0306190000;
  svSQLite030623 = 0306230000;
  svSQLite030700 = 0307000000;
  svSQLite030703 = 0307030000;
  svSQLite030707 = 0307070000;
  svSQLite030711 = 0307110000;
  svSQLite030715 = 0307150000;

  // Some PGSQL versions
  svPGSQL070300 = 0703000000;
  svPGSQL080100 = 0801000000;
  svPGSQL080200 = 0802000000;
  svPGSQL080300 = 0803000000;
  svPGSQL090000 = 0900000000;
  svPGSQL090100 = 0901000000;

  // Some IB/FB versions
  ivFB010002 = 100020000;
  ivFB010003 = 100030000;
  ivFB010500 = 105000000;
  ivFB020000 = 200000000;
  ivFB020100 = 201000000;
  ivFB020500 = 205000000;
  ivFB030000 = 300000000;
  ivIB060500 = 605000000;
  ivIB070000 = 700000000;
  ivIB070100 = 701000000;
  ivIB070500 = 705000000;
  ivIB080000 = 800000000;
  ivIB110000 = 1100000000;
  ivYF080607 = 806070000;

  // Some ODBC versions
  ovODBC3 = 300000000;
  ovODBC2 = 200000000;

  // Some Advantage versions
  caADS8 = 800000000;
  caADS9 = 900000000;
  caADS10 = 1000000000;

  // Default data length's
  C_AD_DefLongSize = 0;
  C_AD_MaxPLSQLDataSize = 32767;
  C_AD_DefStrSize = 255;
  C_AD_DefNumericSize = 30;
  C_AD_MaxFixedSize = 134; // BCD -> WIDE STR: 2 * (64 digits + 1 sign + 1 dec.sep. + 1 zero byte)
  C_AD_DefInlineDataSize = 1000;
  C_AD_DefPieceBuffLen = 262144;
  C_AD_DefRowSetSize = 50;
  C_AD_DefMaxStrSize = {$IFNDEF AnyDAC_FPC} C_AD_MaxPLSQLDataSize {$ELSE} dsMaxStringSize {$ENDIF};

  // Default data type mapping
  C_AD_DefMapPrec = -1;
  C_AD_DefMapScale = -1;
  C_AD_DefMapSize = $FFFFFFFF;

  // Error codes
  er_AD_DuplicatedName = 1;
  er_AD_NameNotFound = 2;
  er_AD_ColTypeUndefined = 3;
  er_AD_NoColsDefined = 4;
  er_AD_CheckViolated = 5; // * 1-> cons name, 0-> message
  er_AD_CantBeginEdit = 6;
  er_AD_CantCreateChildView = 7;
  er_AD_RowCantBeDeleted = 8;
  er_AD_ColMBBlob = 9;
  er_AD_FixedLenDataMismatch = 10;
  er_AD_RowNotInEditableState = 11;
  er_AD_ColIsReadOnly = 12;
  er_AD_RowCantBeInserted = 13;
  er_AD_RowColMBNotNull = 14;
  er_AD_DuplicateRows = 15; // * 1-> cons name, 0-> message
  er_AD_NoMasterRow = 16; // * 1-> cons name, 0-> message
  er_AD_HasChildRows = 17; // * 1-> cons name, 0-> message
  er_AD_CantCompareRows = 18;
  er_AD_ConvIsNotSupported = 19;
  er_AD_ColIsNotSearchable = 20;
  er_AD_RowMayHaveSingleParent = 21;
  er_AD_CantOperateInvObj = 22;
  er_AD_CantSetParentRow = 23;
  er_AD_RowIsNotNested = 24;
  er_AD_ColumnIsNotRef = 25;
  er_AD_ColumnIsNotSetRef = 26;
  er_AD_OperCNBPerfInState = 28;
  er_AD_CantSetUpdReg = 29;
  er_AD_TooManyAggs = 30;
  er_AD_GrpLvlExceeds = 31;
  er_AD_VarLenDataMismatch = 32;
  er_AD_BadForeignKey = 33;
  er_AD_BadUniqueKey = 34;
  er_AD_CantChngColType = 35;
  er_AD_BadRelation = 36;
  er_AD_CantCreateParentView = 37;
  er_AD_CantChangeTableStruct = 38;
  er_AD_FoundCascadeLoop = 39;
  er_AD_RecLocked = 40;
  er_AD_RecNotLocked = 41;
  er_AD_TypeIncompat = 42;
  er_AD_ValueOutOfRange = 43;

  er_AD_ColumnDoesnotFound = 100;
  er_AD_ExprTermination = 101;
  er_AD_ExprMBAgg = 102;
  er_AD_ExprCantAgg = 103;
  er_AD_ExprTypeMis = 104;
  er_AD_ExprIncorrect = 105;
  er_AD_InvalidKeywordUse = 106;
  er_AD_ExprInvalidChar = 107;
  er_AD_ExprNameError = 108;
  er_AD_ExprStringError = 109;
  er_AD_ExprNoLParen = 110;
  er_AD_ExprNoRParenOrComma = 111;
  er_AD_ExprNoRParen = 112;
  er_AD_ExprEmptyInList = 113;
  er_AD_ExprExpected = 114;
  er_AD_ExprNoArith = 115;
  er_AD_ExprBadScope = 116;
  er_AD_ExprEmpty = 117;
  er_AD_ExprEvalError = 118;

  er_AD_DSNoBookmark = 200;
  er_AD_DSViewNotSorted = 201;
  er_AD_DSNoAdapter = 202;
  er_AD_DSNoNestedMasterSource = 203;
  er_AD_DSCircularDataLink = 204;
  er_AD_DSRefreshError = 205;
  er_AD_DSNoDataTable = 206;
  er_AD_DSIndNotFound = 207;
  er_AD_DSAggNotFound = 208;
  er_AD_DSIndNotComplete = 209;
  er_AD_DSAggNotComplete = 210;
  er_AD_DSCantUnidir = 211;
  er_AD_DSIncompatBmkFields = 212;
  er_AD_DSCantEdit = 213;
  er_AD_DSCantInsert = 214;
  er_AD_DSCantDelete = 215;
  er_AD_DSFieldNotFound = 216;
  er_AD_DSCantOffline = 217;
  er_AD_DSCantOffCachedUpdates = 218;

  er_AD_DefCircular = 250;
  er_AD_DefRO = 251;
  er_AD_DefCantMakePers = 252;
  er_AD_DefAlreadyLoaded = 253;
  er_AD_DefNotExists = 254;
  er_AD_DefDupName = 255;

  er_AD_AccSrvNotFound = 300;
  er_AD_AccCannotReleaseDrv = 301;
  er_AD_AccSrvMBConnected = 302;
  er_AD_AccCapabilityNotSup = 303;
  er_AD_AccTxMBActive = 304;
  er_AD_AccCantChngCommandState = 305;
  er_AD_AccCommandMBFilled = 306;
  er_AD_AccEscapeEmptyName = 307;
  er_AD_AccCmdMHRowSet = 308;
  er_AD_AccCmdMBPrepared = 309;
  er_AD_AccCantExecCmdWithRowSet = 310;
  er_AD_AccCmdMBOpen4Fetch = 311;
  er_AD_AccExactMismatch = 312;
  er_AD_AccMetaInfoMismatch = 313;
  er_AD_AccCantLoadLibrary = 314;
  er_AD_AccCantGetLibraryEntry = 315;
  er_AD_AccSrvMBDisConnected = 316;
  er_AD_AccToManyLogins = 317;
  er_AD_AccTxMBInActive = 318;
  er_AD_AccDrvMngrMB = 320;
  er_AD_AccPrepMissed = 321;
  er_AD_AccPrepTooLongIdent = 323;
  er_AD_AccParamArrayMismatch = 325;
  er_AD_AccAsyncOperInProgress = 326;
  er_AD_AccEscapeIsnotSupported = 327;
  er_AD_AccMetaInfoReset = 328;
  er_AD_AccWhereIsEmpty = 329;
  er_AD_AccUpdateTabUndefined = 330;
  er_AD_AccNameHasErrors = 331;
  er_AD_AccEscapeBadSyntax = 332;
  er_AD_AccShutdownTO = 334;
  er_AD_AccParTypeUnknown = 335;
  er_AD_AccParDataMapNotSup = 336;
  er_AD_AccColDataMapNotSup = 337;
  er_AD_AccParDefChanged = 338;
  er_AD_AccMetaInfoNotDefined = 339;
  er_AD_AccSrvNotDefined = 340;
  er_AD_AccArrayExecError = 341;
  er_AD_AccCantAssignTxIntf = 343;
  er_AD_AccParSetChanged = 344;
  er_AD_AccDataToLarge = 345;
  er_AD_AccDbNotExists = 346;
  er_AD_AccClassNotRegistered = 347;
  er_AD_AccSysClassNotRegistered = 348;
  er_AD_AccUnrecognizedDbFormat = 349;
  er_AD_AccNotValidPassword = 350;
  er_AD_AccUnknownOleError = 351;

  er_AD_SvcLinkMBSet = 370;
  er_AD_SvcMBActive = 371;
  er_AD_SvcCannotUninstall = 372;

  er_AD_DAptRecordIsDeleted = 400;
  er_AD_DAptNoSelectCmd = 402;
  er_AD_DAptRecordIsChanged = 403;
  er_AD_DAptApplyUpdateFailed = 404;
  er_AD_DAptCantEdit = 405;
  er_AD_DAptCantInsert = 406;
  er_AD_DAptCantDelete = 407;

  er_AD_ClntSessMBSingle = 500;
  er_AD_ClntSessMBInactive = 501;
  er_AD_ClntSessMBActive = 502;
  er_AD_ClntDbDupName = 503;
  er_AD_ClntDbMBInactive = 504;
  er_AD_ClntDbMBActive = 505;
  er_AD_ClntDbLoginAborted = 506;
  er_AD_ClntDbCantConnPooled = 507;
  er_AD_ClntDBNotFound = 508;
  er_AD_ClntAdaptMBActive = 509;
  er_AD_ClntAdaptMBInactive = 510;
  er_AD_ClntNotCachedUpdates = 511;
  er_AD_ClntDbNotDefined = 512;
  er_AD_ClntDbMBOnline = 513;
  er_AD_ClntTxMBActive = 514;
  er_AD_ClntCantShareAdapt = 515;
  er_AD_ClntConnNotMatch = 516;
  er_AD_ClntPKNotFound = 517;
  er_AD_ClntLocalSQLMisuse = 518;
  er_AD_ClntWrongIndex = 519;
  er_AD_ClntDSNameEmpty = 520;
  er_AD_ClntDSNameNotUnique = 521;

  er_AD_DPNoTxtFld = 600;
  er_AD_DPNoSrcDS = 601;
  er_AD_DPNoDestDS = 602;
  er_AD_DPNoTxtDest = 603;
  er_AD_DPNoTxtSrc = 604;
  er_AD_DPBadFixedSize = 605;
  er_AD_DPTxtFldDup = 606;
  er_AD_DPBadTextFmt = 607;
  er_AD_DPSrcUndefined = 608;

  er_AD_StanTimeout = 700;
  er_AD_StanCantGetBlob = 701;
  er_AD_StanParamOverflow = 704;
  er_AD_StanCantNonblocking = 705;
  er_AD_StanMacroNotFound = 706;
  er_AD_StanBadParRowIndex = 707;
  er_AD_StanPoolTooManyItems = 708;
  er_AD_StanStrgInvBinFmt = 710;
  er_AD_StanStrgCantReadProp = 711;
  er_AD_StanStrgCantReadObj = 712;
  er_AD_StanStrgCantReadCDATA = 713;
  er_AD_StanStrgDictOverflow = 714;
  er_AD_StanStrgClassUnknown = 715;
  er_AD_StanStrgUnknownFmt = 716;
  er_AD_StanStrgFileError = 717;
  er_AD_StanStrgInvDIntFmt = 718;

  er_AD_ScrCantExecHostCmd = 800;
  er_AD_ScrStrSize1 = 801;
  er_AD_ScrStrNotAlphaNum = 802;
  er_AD_ScrSetArgInvalid = 803;
  er_AD_ScrInvalidSyntax = 804;
  er_AD_ScrAccMustSpecVar = 805;
  er_AD_ScrDefReqValue = 806;
  er_AD_ScrVarMissedCloseBrace = 807;
  er_AD_ScrVarUnsupType = 808;
  er_AD_ScrNotLogged = 809;
  er_AD_ScrNoCmds = 810;
  er_AD_ScrNoScript = 811;

  er_AD_DBXGeneral = 1000;
  er_AD_DBXParMBNotEmpty = 1001;
  er_AD_DBXNoDriverCfg = 1002;

  er_AD_MySQLGeneral = 1100;
  er_AD_MySQLBadVersion = 1101;
  er_AD_MySQLCantSetPort = 1102;
  er_AD_MySQLBadParams = 1103;
  er_AD_MySQLCantInitEmbeddedServer = 1104;

  er_AD_OdbcGeneral = 1200;
  er_AD_OdbcVarDataTypeUnsup = 1202;

  er_AD_OraGeneral = 1300;
  er_AD_OraCantSetCharset = 1301;
  er_AD_OraNoCursor = 1305;
  er_AD_OraCantAssFILE = 1307;
  er_AD_OraNoCursorParams = 1308;
  er_AD_OraNotInstalled = 1309;
  er_AD_OraBadVersion = 1310;
  er_AD_OraBadValueType = 1315;
  er_AD_OraBadVarType = 1319;
  er_AD_OraTooLongGTRID = 1323;
  er_AD_OraTooLongBQUAL = 1324;
  er_AD_OraTooLongTXName = 1325;
  er_AD_OraDBTNManyClBraces = 1326;
  er_AD_OraNotPLSQLObj = 1327;
  er_AD_OraNotPackageProc = 1329;
  er_AD_OraBadTableType = 1330;
  er_AD_OraUnNamedRecParam = 1331;
  er_AD_OraCantConvNum = 1332;
  er_AD_OraPipeAlertToMany = 1333;

  er_AD_IBGeneral = 1400;
  er_AD_IBTraceIsActive = 1401;

  er_AD_PgGeneral = 1500;
  er_AD_PgProcNotFound = 1501;
  er_AD_PgMultiDimArrNotSup = 1502;
  er_AD_PgUnsupArrValueTypeNotSup = 1503;
  er_AD_PgArrIndexOutOfBound = 1504;
  er_AD_PgCannotDescribeType = 1505;

  er_AD_SQLiteGeneral = 1600;
  er_AD_SQLiteInitFailed = 1601;
  er_AD_SQLiteAlgFailure = 1602;
  er_AD_SQLitePwdInvalid = 1603;
  er_AD_SQLiteDBUnencrypted = 1604;
  er_AD_SQLiteDBNotFound = 1605;
  er_AD_SQLiteVTabInvalidArgs = 1650;
  er_AD_SQLiteVTabDSNotFoundOrEmpty = 1651;
  er_AD_SQLiteVTabDSNotSupported = 1652;
  er_AD_SQLiteVTabDSSPNotFound = 1653;
  er_AD_SQLiteVTabDSDataModFailed = 1654;
  er_AD_SQLiteVTabDSRowidInvalid = 1655;
  er_AD_SQLiteVTabDSChangedOrFreed = 1656;
  er_AD_SQLiteVTabDSNoRowExists = 1657;
  er_AD_SQLiteVTabDSCursorInvalid = 1658;
  er_AD_SQLiteVTabCannotAttach = 1659;
  er_AD_SQLiteVTabDataSetBusy = 1660;

  er_AD_ASAGeneral = 1700;
  er_AD_ASADBToolNotFound = 1701;

  er_AD_ADSGeneral = 1800;

  er_AD_NexusGeneral = 1900;

implementation

end.
