{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC resource strings                }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanResStrs;

interface

uses
  uADStanConst;

resourcestring
  {-------------------------------------------------------------------------------}
  // Dialog captions

  S_AD_ErrorDialogDefCaption = C_AD_Product + ' Error';
  S_AD_LoginDialogDefCaption = C_AD_Product + ' Login';
  S_AD_AsyncDialogDefCaption = C_AD_Product + ' Working';
  S_AD_ScriptDialogDefCaption = C_AD_Product + ' Processing';
  S_AD_LoginDialogTestOk = 'Connection established successfully.';
  S_AD_WizardNotAccessible = 'The wizard is not implemented for this driver.';
  S_AD_LoginCredentials = 'Enter your credentials';
  S_AD_LoginNewPassword = 'Enter your new password';
  S_AD_AsyncDialogDefPrompt = 'Please wait, application is busy ...';

  {-------------------------------------------------------------------------------}
  // Error messages

  S_AD_DuplicatedName = 'Name [%s] is duplicated in the list';
  S_AD_NameNotFound = 'Object [%s] is not found';
  S_AD_ColTypeUndefined = 'Column [%s] type is unknown or undefined';
  S_AD_NoColsDefined = 'No columns defined for table';
  S_AD_CheckViolated = 'Check condition violated.' + C_AD_EOL + 'Constraint [%s]';
  S_AD_CantBeginEdit = 'Cannot begin edit row';
  S_AD_CantCreateChildView = 'Cannot create child view. Relation [%s]';
  S_AD_RowCantBeDeleted = 'Cannot delete row';
  S_AD_ColMBBLob = 'Column [%s] must have blob value';
  S_AD_FixedLenDataMismatch = 'Fixed length column [%s] data length mismatch.' + C_AD_EOL +
    'Value length - [%d], column fixed length - [%d]';
  S_AD_RowNotInEditableState = 'Row is not in editable state';
  S_AD_ColIsReadOnly = 'Column [%s] is read only';
  S_AD_RowCantBeInserted = 'Cannot insert row into table';
  S_AD_RowColMBNotNull = 'Column [%s] value must be not null';
  S_AD_DuplicateRows = 'Duplicate row found on unique index. Constraint [%s]';
  S_AD_NoMasterRow = 'Cannot process - no parent row. Constraint [%s]';
  S_AD_HasChildRows = 'Cannot process - child rows found. Constraint [%s]';
  S_AD_CantCompareRows = 'Cannot compare rows';
  S_AD_ConvIsNotSupported = 'Data type conversion is not supported';
  S_AD_ColIsNotSearchable = 'Column [%s] is not searchable';
  S_AD_RowMayHaveSingleParent = 'Row may have only single column of [dtParentRowRef] data type';
  S_AD_CantOperateInvObj = 'Cannot read data from or write data to the invariant column [%s].' + C_AD_EOL +
    'Hint: use properties and methods, like a NestedTable';
  S_AD_CantSetParentRow = 'Cannot set parent row';
  S_AD_RowIsNotNested = 'Row is not nested';
  S_AD_ColumnIsNotRef = 'Column [%s] is not reference to other row';
  S_AD_ColumnIsNotSetRef = 'Column [%s] is not reference to row set';
  S_AD_OperCNBPerfInState = 'Cannot perform operation for row state';
  S_AD_CantSetUpdReg = 'Cannot change updates registry for DatS manager [%s]';
  S_AD_TooManyAggs = 'Too many aggregate values per view';
  S_AD_GrpLvlExceeds = 'Grouping level exceeds maximum allowed for aggregate [%s]';
  S_AD_VarLenDataMismatch = 'Variable length column [%s] overflow.' + C_AD_EOL +
    'Value length - [%d], column maximum length - [%d]';
  S_AD_BadForeignKey = 'Invalid foreign key [%s]';
  S_AD_BadUniqueKey = 'Invalid unique key [%s]';
  S_AD_CantChngColType = 'Cannot change column [%s] data type';
  S_AD_BadRelation = 'Invalid relation [%s]';
  S_AD_CantCreateParentView = 'Cannot create parent view. Relation [%s]';
  S_AD_CantChangeTableStruct = 'Cannot change table [%s] structure, when table has rows';
  S_AD_FoundCascadeLoop = 'Found a cascading actions loop at checking foreign key [%s]';
  S_AD_RecLocked = 'Record already locked';
  S_AD_RecNotLocked = 'Record is not locked';
  S_AD_TypeIncompat = 'Assigning value [%s] is not compatible with column [%s] data type.' + C_AD_EOL + '%s';
  S_AD_ValueOutOfRange = 'Value [%s] is out of range of [%s] data type';

  S_AD_ColumnDoesnotFound = 'Column or function [%s] is not found.' + C_AD_EOL +
    'Hint: if the name is a function name, then add uADStanExprFuncs to uses clause';
  S_AD_ExprTermination = 'Expression unexpectedly terminated';
  S_AD_ExprMBAgg = 'Expression must be aggregated';
  S_AD_ExprCantAgg = 'Expression cannot be aggregated';
  S_AD_ExprTypeMis = 'Type mismatch in expression';
  S_AD_ExprIncorrect = 'Expression is incorrect';
  S_AD_InvalidKeywordUse = 'Invalid use of keyword';
  S_AD_ExprInvalidChar = 'Invalid character found [%s]';
  S_AD_ExprNameError = 'Name is not terminated properly';
  S_AD_ExprStringError = 'String constant is not terminated properly';
  S_AD_ExprNoLParen = '''('' expected but [%s] found';
  S_AD_ExprNoRParenOrComma = ''')'' or '','' expected but [%s] found';
  S_AD_ExprNoRParen = ''')'' expected but [%s] found';
  S_AD_ExprEmptyInList = 'IN predicate list may not be empty';
  S_AD_ExprExpected = 'Expected [%s]';
  S_AD_ExprNoArith = 'Arithmetic in filter expressions not supported';
  S_AD_ExprBadScope = 'Operation cannot mix aggregate value with record-varying value';
  S_AD_ExprEmpty = 'Empty expression';
  S_AD_ExprEvalError = 'Error evaluating expression.' + C_AD_EOL + '%s';

  S_AD_DSNoBookmark = 'Bookmark is not found for dataset [%s]';
  S_AD_DSViewNotSorted = 'View [%s] is not a sorted view';
  S_AD_DSNoAdapter = 'Adapter interface must be supplied';
  S_AD_DSNoNestedMasterSource = 'Cannot set MasterSource for dataset [%s].' + C_AD_EOL +
    'Nested datasets cannot have a MasterSource';
  S_AD_DSCircularDataLink = 'Cannot set MasterSource for dataset [%s].' + C_AD_EOL +
    'Circular datalinks are not allowed';
  S_AD_DSRefreshError = 'Cannot refresh dataset [%s].' + C_AD_EOL +
    'Cached updates must be commited or canceled and batch mode terminated before refreshing';
  S_AD_DSNoDataTable = 'Cannot open dataset [%s].' + C_AD_EOL +
    'A DataTable or a DataView must be supplied.' + C_AD_EOL +
    'Hint: if that is TADMemTable, use CreateDataSet or CloneCursor to open dataset';
  S_AD_DSIndNotFound = 'Index [%s] is not found for dataset [%s]';
  S_AD_DSAggNotFound = 'Aggregate [%s] is not found for dataset [%s]';
  S_AD_DSIndNotComplete = 'Index [%s] definition is not complete for dataset [%s]';
  S_AD_DSAggNotComplete = 'Aggregate [%s] definition is not complete for dataset [%s]';
  S_AD_DSCantUnidir = 'Cannot perform operation on unidirectional dataset [%s]';
  S_AD_DSIncompatBmkFields = 'Bookmark key fields [%s] are incompatible' + C_AD_EOL +
    'with dataset [%s] key fields [%s]';
  S_AD_DSCantEdit = 'Record editing for dataset [%s] is disabled';
  S_AD_DSCantInsert = 'Record inserting for dataset [%s] is disabled';
  S_AD_DSCantDelete = 'Record deleting for dataset [%s] is disabled';
  S_AD_DSFieldNotFound = 'Field [%s] specified within %s of DataSet [%s] does not exist';
  S_AD_DSCantOffline = 'Cannot set dataset [%s] to offline mode.' + C_AD_EOL +
    'Hint: check that FetchOptions.AutoFetchAll is not afDisable';
  S_AD_DSCantOffCachedUpdates = 'Cannot turn off cached updates mode for DataSet [%s].' + C_AD_EOL +
    'Hint: dataset has updated rows, cancel or apply updates before action';

  S_AD_DefCircular = 'Cannot make definition [%s] circular reference';
  S_AD_DefRO = 'Cannot %s definition [%s]. It has associated connection';
  S_AD_DefCantMakePers = 'Cannot make definition persistent';
  S_AD_DefAlreadyLoaded = 'Cannot load definition list, because it is already loaded';
  S_AD_DefNotExists = 'Definition [%s] is not found in [%s]';
  S_AD_DefDupName = 'Definition name [%s] is duplicated';

  S_AD_AccSrvNotFound = 'Driver [%s] is not registered.' + C_AD_EOL + '%s';
  S_AD_AccCannotReleaseDrv = 'Driver [%s] cannot be released.' + C_AD_EOL +
    'Hint: Close all TADConnection objects and release pools';
  S_AD_AccSrcNotFoundExists =
    'To register it, you can drop component [TADPhys%sDriverLink] into your project';
  S_AD_AccSrcNotFoundNotExists =
    'Correct driver ID or define [%s] virtual driver in %s';
  S_AD_AccSrvNotDefined = 'Driver ID is not defined.' + C_AD_EOL +
    'Set TADConnection.DriverName or add DriverID to your connection definition';
  S_AD_AccSrvMBConnected = 'Connection must be active';
  S_AD_AccCapabilityNotSup = 'Capability is not supported';
  S_AD_AccTxMBActive = 'Transaction [%s] must be active';
  S_AD_AccTxMBInActive = 'Transaction [%s] must be inactive. Nested transactions are disabled';
  S_AD_AccCantChngCommandState = 'Cannot change command state';
  S_AD_AccCommandMBFilled = 'Command text must not be empty';
  S_AD_AccEscapeEmptyName = 'Escape function name must not be empty';
  S_AD_AccCmdMHRowSet = 'Cannot open / define command, which does not return result sets.' + C_AD_EOL +
    'Hint: use Execute / ExecSQL method for non-SELECT commands';
  S_AD_AccCmdMBPrepared = 'Command must be is prepared state';
  S_AD_AccCantExecCmdWithRowSet = 'Cannot execute command returning result sets.' + C_AD_EOL +
    'Hint: use Open method for SELECT-like commands';
  S_AD_AccCmdMBOpen4Fetch = 'Command must be open for fetching';
  S_AD_AccExactMismatch = 'Exact %s [%d] rows, while [%d] was requested';
  S_AD_AccMetaInfoMismatch = 'Meta information mismatch';
  S_AD_AccCantLoadLibrary = 'Cannot load vendor library [%s].' + C_AD_EOL + '%s' +
    'Hint: check it is in the PATH or application EXE directories, and has ' + {$IFDEF AnyDAC_32} 'x86' {$ELSE} 'x64' {$ENDIF} + ' bitness.';
  S_AD_AccCantGetLibraryEntry = 'Cannot get vendor library entry point[s].' + C_AD_EOL +
    '[%s]';
  S_AD_AccSrvMBDisConnected = 'Connection must be inactive';
  S_AD_AccToManyLogins = 'Too many login retries. Allowed [%d] times';
  S_AD_AccDrvMngrMB = 'To perform operation driver manager, must be [%s]';
  S_AD_AccPrepMissed = 'Character [%s] is missed';
  S_AD_AccPrepTooLongIdent = 'Too long identifier (> 255)';
  S_AD_AccParamArrayMismatch = 'Parameter [%s] ArraySize [%d] is less than ATimes [%d]';
  S_AD_AccAsyncOperInProgress = 'Cannot perform action, because previous action is in progress';
  S_AD_AccEscapeIsnotSupported = 'Escape function [%s] is not supported';
  S_AD_AccMetaInfoReset = 'Define(mmReset) is only supported for metainfo retrieval';
  S_AD_AccWhereIsEmpty = 'Cannot generate update query. WHERE condition is empty';
  S_AD_AccUpdateTabUndefined = 'Cannot generate update query. Update table undefined';
  S_AD_AccNameHasErrors = 'Cannot parse object name - [%s]';
  S_AD_AccEscapeBadSyntax = 'Syntax error in escape function [%s].' + C_AD_EOL + '%s';
  S_AD_AccShutdownTO = 'ADPhysManager shutdown timeout.' + C_AD_EOL +
    'Possible reason: application has not released all connection interfaces';
  S_AD_AccParTypeUnknown = 'Parameter [%s] data type is unknown.' + C_AD_EOL +
    'Hint: specify TADParam.DataType or assign TADParam value before Prepare/Execute call';
  S_AD_AccParDataMapNotSup = 'Parameter [%s] data type is not supported';
  S_AD_AccColDataMapNotSup = 'Column [%s] data type is not supported';
  S_AD_AccParDefChanged = 'Param [%s] type changed from [ft%s] to [ft%s]. Query must be reprepared.' + C_AD_EOL +
    'Possible reason: an assignment to a TADParam.AsXXX property implicitly changed the parameter data type.' + C_AD_EOL +
    'Hint: use the TADParam.Value or appropriate TADParam.AsXXX property';
  S_AD_AccMetaInfoNotDefined = 'A meta data argument [%s] value must be specified';
  S_AD_AccCantAssignTxIntf = 'Cannot set default transaction';
  S_AD_AccParSetChanged = 'The set of parameters is changed. Query must be reprepared.' + C_AD_EOL +
    'Expected number of parameters is [%d], but actual number is [%d].' + C_AD_EOL +
    'Possible reason: a parameter was added or deleted';
  S_AD_AccDataToLarge = 'Data too large for variable [%s]. Max len = [%d], actual len = [%d]' + C_AD_EOL +
    'Hint: set the TADParam.Size to a greater value';
  S_AD_AccDbNotExists = 'Database [%s] does not exist';
  S_AD_AccClassNotRegistered = 'Required OLEDB provider is missing on client machine.' + C_AD_EOL +
    'Hint: set exact DBVersion value or install respective MS Access Database Engine:' + C_AD_EOL +
    'Access 2003 or earlier: http://support.microsoft.com/kb/239114' + C_AD_EOL +
    'Access 2007: http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=23734' + C_AD_EOL +
    'Access 2010: http://www.microsoft.com/download/en/details.aspx?id=13255';
  S_AD_AccSysClassNotRegistered = 'JRO.JetEngine class is missing on client machine.' + C_AD_EOL +
    'Hint: install latest engine from: http://support.microsoft.com/kb/239114';
  S_AD_AccUnrecognizedDbFormat = 'Database format is not recognized.' + C_AD_EOL +
    'Possible reason: DBVersion value mismatches database version.';
  S_AD_AccNotValidPassword = 'Specified database password is invalid';
  S_AD_AccUnknownOleError = 'Unknown OLE error';

  S_AD_SvcLinkMBSet = 'To perform operation DriverLink must be specified';
  S_AD_SvcMBActive = 'To perform operation service must be active';
  S_AD_SvcCannotUninstall = 'Cannot deinstall a SQLite collation, while there are active connections';

  S_AD_DAptRecordIsDeleted = '%s command %s [%d] instead of [1] record.' + C_AD_EOL +
    'Possible reasons: %s';
  S_AD_DAptRecordIsDeletedReasons = 'update table does not have PK or row identifier,' + C_AD_EOL +
    'record has been changed/deleted by another user';
  S_AD_DAptNoSelectCmd = 'Operation cannot be performed without assigned SelectCommand';
  S_AD_DAptApplyUpdateFailed = 'Update post failed';
  S_AD_DAptCantEdit = 'Row editing disabled';
  S_AD_DAptCantInsert = 'Row inserting disabled';
  S_AD_DAptCantDelete = 'Row deleting disabled';

  S_AD_ClntSessMBSingle = 'Application must have only single ADManager';
  S_AD_ClntSessMBInactive = 'ADManager must be inactive';
  S_AD_ClntSessMBActive = 'ADManager must be active';
  S_AD_ClntDbDupName = 'Connection name [%s] must be unique';
  S_AD_ClntDbMBInactive = 'Connection [%s] must be inactive';
  S_AD_ClntDbMBActive = 'Connection [%s] must be active';
  S_AD_ClntDbLoginAborted = 'Connection [%s] establishment is canceled';
  S_AD_ClntDbCantConnPooled = 'Connection [%s] cannot be pooled.' + C_AD_EOL +
    'Possible reason: connection definition is not in the ADManager.ConnectionDefs list or' + C_AD_EOL +
    'TADConnection.Params has additional parameters';
  S_AD_ClntDBNotFound = 'Connection [%s] is not found' + C_AD_EOL +
    'Possible reason: [%s] ConnectionName property is misspelled or references to nonexistent connection';
  S_AD_ClntAdaptMBActive = 'Command [%s] must be in active state';
  S_AD_ClntAdaptMBInactive = 'Command [%s] must be in inactive state';
  S_AD_ClntNotCachedUpdates = 'Dataset [%s] must be in cached update mode';
  S_AD_ClntDbNotDefined = 'Connection is not defined for [%s].' + C_AD_EOL +
    'Possible reason: Connection and ConnectionName property values are both empty';
  S_AD_ClntDbMBOnline = 'Connection [%s] must be online';
  S_AD_ClntCantShareAdapt = 'Table adapter [%s] cannot be assigned to [%s], because it is' + C_AD_EOL +
    'already assigned to [%s] and cannot be shared across few datasets';
  S_AD_ClntConnNotMatch = 'Dataset connection does not match to called connection';
  S_AD_ClntPKNotFound = 'Table [%s] must have primary key';
  S_AD_ClntLocalSQLMisuse = 'Local SQL engine misusage by [%s].' + C_AD_EOL +
    'Hint: activate connection before activating dataset';
  S_AD_ClntWrongIndex = 'Table [%s] index [%s] must be existing non-expressional index';
  S_AD_ClntDSNameEmpty = 'Dataset name must be not empty';
  S_AD_ClntDSNameNotUnique = 'Dataset name [%s] must be unique across Local SQL [%s] datasets';

  S_AD_DPNoTxtFld = 'Text field [%s] is not found';
  S_AD_DPNoSrcDS = 'Source dataset not set';
  S_AD_DPNoDestDS = 'Destination dataset not set';
  S_AD_DPNoTxtDest = 'Destination text data file name or stream must be specified';
  S_AD_DPNoTxtSrc = 'Source text data file name or stream must be specified';
  S_AD_DPBadFixedSize = 'Text field [%s] size is undefined in Fixed Size Record format';
  S_AD_DPTxtFldDup = 'Text field [%s] name is Duplicated';
  S_AD_DPBadTextFmt = 'Bad text value [%s] format for mapping item [%s].' + C_AD_EOL + '%s';
  S_AD_DPSrcUndefined = 'Undefined source field or expression for destination field [%s]';

  S_AD_StanTimeout = 'Timeout expired';
  S_AD_StanCantGetBlob = 'Cannot get access to BLOB raw data';
  S_AD_StanParamOverflow = 'Variable length data parameter [%s] overflow.' + C_AD_EOL +
    'Value length - [%d], parameter data maximum length - [%d]';
  S_AD_StanCantNonblocking = 'Cannot perform nonblocking action, while other nonblocking action is in progress';
  S_AD_StanMacroNotFound = 'Macro [%s] is not found';
  S_AD_StanBadParRowIndex = 'Parameter [%s] value index [%d] is out of range [0..%d]';
  S_AD_StanPoolTooManyItems = 'Cannot acquire item (connection) from pool.' + C_AD_EOL +
    'Maximal number [%d] of simultaneous items (connections) reached.';
  S_AD_StanHowToReg = '.' + C_AD_EOL +
    'To register it, you can drop component [%s] into your project';
  S_AD_StanHowToInc = '.' + C_AD_EOL +
    'To register it, you can include unit [%s] into your project';
  S_AD_StanStrgInvBinFmt = 'Invalid binary storage format';
  S_AD_StanStrgCantReadProp = 'Cannot read [%s] property';
  S_AD_StanStrgCantReadObj = 'Cannot read [%s] object';
  S_AD_StanStrgCantReadCDATA = 'Cannot read RAW data of [%s] object';
  S_AD_StanStrgDictOverflow = 'Dictionary overflow';
  S_AD_StanStrgClassUnknown = 'Class [%s] is not registered';
  S_AD_StanStrgUnknownFmt = 'Unknown storage format [%s]';
  S_AD_StanStrgFileError = 'Cannot move file [%s] to [%s].' + C_AD_EOL + '%s';
  S_AD_StanStrgInvDIntFmt = 'Invalid date interval format [%s]';

  S_AD_ScrCantExecHostCmd = 'Cannot execute host command [%s].' + C_AD_EOL + '%s';
  S_AD_ScrStrSize1 = 'String size must be of 1 character length';
  S_AD_ScrStrNotAlphaNum = 'Character cannot be alphanumeric or whitespace';
  S_AD_ScrSetArgInvalid = 'Invalid SET command argument';
  S_AD_ScrInvalidSyntax = 'Invalid command [%s] syntax';
  S_AD_ScrAccMustSpecVar = 'ACCEPT statement must specify a variable name';
  S_AD_ScrDefReqValue = 'DEFINE requires a value following equal sign';
  S_AD_ScrVarMissedCloseBrace = 'VARIABLE has missed right brace';
  S_AD_ScrVarUnsupType = 'VARIABLE has unsupported data type';
  S_AD_ScrNotLogged = 'Cannot execute command. Not logged on';
  S_AD_ScrNoCmds = 'No script commands registered.' + C_AD_EOL +
    'Possible reason: uADCompScriptCommands unit is not linked to the application';
  S_AD_ScrNoScript = 'No script to execute for [%s].' + C_AD_EOL +
    'Possible reason: SQLScriptFileName and SQLScripts both are empty';

  S_AD_DBXParMBNotEmpty = 'Connection parameter [%s] must be not empty';
  S_AD_DBXNoDriverCfg = 'DbExpress driver configuration file [%s] is not found.'+ C_AD_EOL +
    'Possible reason: dbExpress is not properly installed on this machine';

  S_AD_MySQLBadVersion = 'Unsupported MySQL version [%d].' + C_AD_EOL +
    'Supported are client and server from v 3.20 to v 6.2';
  S_AD_MySQLCantSetPort = 'Port number cannot be changed';
  S_AD_MySQLBadParams = 'Error in parameter [%s] definition. %s';
  S_AD_MySQLCantInitEmbeddedServer = 'Failed to initialize embedded server.' + C_AD_EOL +
    'See MySQL log files for details';

  S_AD_OdbcVarDataTypeUnsup = 'Variable [%s] C data type [%d] is not supported';

  S_AD_OraNoCursor = 'No cursors available';
  S_AD_OraCantSetCharset = 'Cannot initialize OCI with character set [%s].' + C_AD_EOL +
    'Possible reason: %s';
  S_AD_OraCantAssFILE = 'Cannot assign value to BFILE/CFILE parameter [%s]';
  S_AD_OraNoCursorParams = 'No cursor parameters are defined. Include fiMeta into FetchOptions.Items';
  S_AD_OraNotInstalled = 'OCI is not properly installed on this machine (NOE1/INIT)';
  S_AD_OraBadVersion = 'Unsupported OCI library [%s] version [%s].' + C_AD_EOL +
    'At least version 8.0.3 is required (NOE2/INIT)';
  S_AD_OraBadVarType = 'Bad or undefined variable param type (NOE12/VAR)';
  S_AD_OraTooLongGTRID = 'Maximum length (%d) of GTRID exceeded - %d (NOE18/TX)';
  S_AD_OraTooLongBQUAL = 'Maximum length (%d) of BQUAL exceeded - %d (NOE19/TX)';
  S_AD_OraTooLongTXName = 'Maximum length (%d) of transaction name exceeded - %d (NOE20/TX)';
  S_AD_OraDBTNManyClBraces = 'Too many close braces in names file after alias [%s] (NOE105/DB)';
  S_AD_OraNotPLSQLObj = '[%s] is not a callable PL/SQL object (NOE130/SP)';
  S_AD_OraNotPackageProc = '[%s, #%d] is not found in [%s] package (NOE134/SP)';
  S_AD_OraBadTableType = 'Parameter with type TABLE OF BOOLEAN/RECORD not supported (use TADQuery) (NOE135/SP)';
  S_AD_OraUnNamedRecParam = 'Parameter with type RECORD must be of named type (use TADQuery) (NOE142/SP)';
  S_AD_OraCantUTF16 = 'To initialize OCI in UTF16 mode, OCI must be of version 8.1 or higher';
  S_AD_OraCantSetCharsetInUT16 = 'To set character set in UTF16 mode, OCI must be of version 9.2 or higher';
  S_AD_OraCantSetDiffCharset = 'Character set must be the same for all sessions';
  S_AD_OraCantConvNum = 'Cannot convert Oracle Number [%s] to TBcd';
  S_AD_OraPipeAlertToMany = 'DBMS_PIPE event alerter supports only single event name';

  S_AD_IBTraceIsActive = 'Cannot start a trace session, when there is an active one';

  S_AD_PgProcNotFound = 'Stored procedure [%s] is not found';
  S_AD_PgMultiDimArrNotSup = 'Array-typed variable [%s] dimensions [%d] are not supported.' + C_AD_EOL +
    'Only sigle dimensional simple type arrays are supported';
  S_AD_PgUnsupArrValueTypeNotSup = 'Array-typed variable [%s] unsupported element type [%d].' + C_AD_EOL +
    'Only sigle dimensional simple type arrays are supported';
  S_AD_PgArrIndexOutOfBound = 'Array-typed variable [%s] item index [%d] is out of bounds [%d, %d]';
  S_AD_PgCannotDescribeType = 'Cannot describe type [%d].' + C_AD_EOL + '%s';

  S_AD_SQLiteInitFailed = 'SQLite library initialization failed. Main code [%d], extended code [%d]';
  S_AD_SQLiteDBNotFound = 'Database specified by [%p] handle was not found';
  S_AD_SQLiteVTabInvalidArgs = 'VTab: Invalid number of arguments at VTabCreate. Expected [%d], got [%d]';
  S_AD_SQLiteVTabDSNotFoundOrEmpty = 'VTab: Dataset [%s] is not found or empty';
  S_AD_SQLiteVTabDSNotSupported = 'VTab: Operation is not supported';
  S_AD_SQLiteVTabDSSPNotFound = 'VTab: Savepoint [%d] is not found';
  S_AD_SQLiteVTabDSDataModFailed = 'VTab: Dataset modification failed';
  S_AD_SQLiteVTabDSRowidInvalid = 'VTab: Explicit ROWID at INSERT is not supported';
  S_AD_SQLiteVTabDSChangedOrFreed = 'VTab: Dataset state was changed. Cannot perform operation';
  S_AD_SQLiteVTabDSNoRowExists = 'VTab: Specified row does not exist';
  S_AD_SQLiteVTabDSCursorInvalid = 'VTab: Invalid cursor';
  S_AD_SQLiteVTabCannotAttach = 'TADLocalSQL must be attached to an active SQLite connection';
  S_AD_SQLiteVTabDataSetBusy = 'VTab: DataSet [%s] is busy by another result set';

  S_AD_ASADBToolNotFound = 'Cannot perform action. DBTOOLn.DLL is not found';

  S_AD_NexusQueryPrepareFailed = 'Query preparation failed: %s%s';
  S_AD_NexusQuerySetParamsFailed = 'Query set parameters failed: %s%s';
  S_AD_NexusQueryGetParamsFailed = 'Query get parameters failed: %s%s';
  S_AD_NexusQueryExecFailed = 'Query execution failed: %s%s';

  {-------------------------------------------------------------------------------}
  // uADCompBDEAliasImport

  S_AD_CantMakeConnDefBDEComp = 'Cannot make connection definition compatible with BDE.' + C_AD_EOL +
    'Reason - driver and RDBMS kind pair is unsupported';

  {-------------------------------------------------------------------------------}
  // uADCompDataMove

  S_AD_StartLog = 'Start Log';
  S_AD_NoErrorsLogged = 'No Errors Logged';
  S_AD_EndLog = 'End Log';

  {-------------------------------------------------------------------------------}
  // uADCompReg

  S_AD_RegIniFilter = 'Ini Files (*.ini)|*.ini|All files (*.*)|*.*';
  S_AD_RegTxtFilter = 'Text Files (*.txt)|*.txt|CSV Files (*.csv)|*.csv|All files (*.*)|*.*';
  S_AD_RegLogFilter = 'Log Files (*.log)|*.log|Text Files (*.txt)|*.txt|All files (*.*)|*.*';
  S_AD_RegSQLFilter = 'SQL Files (*.sql)|*.sql|All files (*.*)|*.*';
  S_AD_RegADSFilter = 'XML Files (*.xml)|*.xml|Binary Files (*.adb)|*.adb|All files (*.*)|*.*';
  S_AD_RegDLLFilter = 'DLL Files (*.dll)|*.dll|All files (*.*)|*.*';
  S_AD_RegExecute = '&Execute';
  S_AD_RegValidate = '&Validate';
  S_AD_RegGuessTxt = '&Guess Text Format';
  S_AD_RegAddMappins = '&Add All Mappings';
  S_AD_RegConnectionEditor = '&Connection Editor ...';
  S_AD_RegRdbmsNextRS = '&Next record set';
  S_AD_RegUpdSQLEditor = '&Update SQL Editor ...';
  S_AD_RegQEditor = '&Query Editor ...';
  S_AD_Executor = 'E&xecutor';
  S_AD_Explorer = '&Explorer';
  S_AD_Monitor = '&Monitor';
  S_AD_Preferences = '&Preferences ...';
  S_AD_Help = '&Help';
  S_AD_FAQ = 'FA&Q';
  S_AD_Forums = '&Forums';
  S_AD_About = '&About ...';
  S_AD_ADHome = 'Home Page';

  {-------------------------------------------------------------------------------}
  // uADDatSManager

  S_AD_NotFound = '<not found>';
  S_AD_Unnamed = 'Unnamed';

  {-------------------------------------------------------------------------------}
  // uADGUIxFormsfAbout

  S_AD_ProductAbout = '%s About';

  {-------------------------------------------------------------------------------}
  // uADGUIxFormsfConnEdit

  S_AD_ParParameter = 'Parameter';
  S_AD_ParValue = 'Value';
  S_AD_ParDefault = 'Default';
  S_AD_ConnEditCaption = C_AD_Product + ' Connection Editor - [%s]';

  {-------------------------------------------------------------------------------}
  // uADGUIxFormsfQEdit

  S_AD_QEditCaption = C_AD_Product + ' Query Editor - [%s]';

  {-------------------------------------------------------------------------------}
  // uADGUIxFormsfUSEdit

  S_AD_USEditCaption = C_AD_Product + ' Update SQL Editor - [%s]';
  S_AD_USEditCantEdit = 'Cannot edit TADUpdateSQL - connection is undefined';
  S_AD_USEditOpenDS = 'To get columns information would you like to execute the query ?';

  {-------------------------------------------------------------------------------}
  // uADMoniRemoteBase

  S_AD_MonNoConnection = 'No connection';
  S_AD_MonEncounterType = 'Encounter unexpected parameter type';
  S_AD_MonEncounterParamName = 'Encounter unexpected parameter name';
  S_AD_MonEncounterBlock = 'Encounter unexpected block of parameters';
  S_AD_MonEncounterEOF = 'Encounter EOF';

implementation

end.
