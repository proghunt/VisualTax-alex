{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                FireDAC PostgreSQL API                 }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysPGCli;

interface

uses
  uADStanIntf;

const
  // Base PostgreSQL datatypes
  SQL_BOOL = 16;
  SQL_BYTEA = 17;
  SQL_CHAR = 18;         // Internal
  SQL_NAME = 19;         // Internal
  SQL_INT8 = 20;
  SQL_INT2 = 21;
  SQL_INT2VECTOR = 22;   // Internal
  SQL_INT4 = 23;
  SQL_REGPROC = 24;
  SQL_TEXT = 25;
  SQL_OID = 26;          // Internal
  SQL_TID = 27;
  SQL_XID = 28;
  SQL_CID = 29;          // Internal
  SQL_OIDVECTOR = 30;    // Internal
  SQL_XML = 142;
  SQL_SMGR = 210;
  SQL_POINT = 600;
  SQL_LSEG = 601;
  SQL_PATH = 602;
  SQL_BOX = 603;
  SQL_POLYGON = 604;
  SQL_LINE = 628;
  SQL_CIDR = 650;        // Internal
  SQL_FLOAT4 = 700;
  SQL_FLOAT8 = 701;
  SQL_ABSTIME = 702;
  SQL_RELTIME = 703;
  SQL_TINTERVAL = 704;
  SQL_UNKNOWN = 705;     // Internal
  SQL_CIRCLE = 718;
  SQL_CASH = 790;
  SQL_MACADDR = 829;     // Internal
  SQL_INET = 869;        // Internal
  SQL_ACLITEM = 1033;
  SQL_BPCHAR = 1042;
  SQL_VARCHAR = 1043;
  SQL_DATE = 1082;
  SQL_TIME = 1083;
  SQL_TIMESTAMP = 1114;
  SQL_TIMESTAMPTZ = 1184;
  SQL_INTERVAL = 1186;
  SQL_TIMETZ = 1266;
  SQL_BIT = 1560;
  SQL_VARBIT = 1562;
  SQL_NUMERIC = 1700;
  SQL_REFCURSOR = 1790;
  SQL_REGPROCEDURE = 2202;
  SQL_REGOPER = 2203;
  SQL_REGOPERATOR = 2204;
  SQL_REGCLASS = 2205;
  SQL_REGTYPE = 2206;
  SQL_CSTRING = 2275;
  SQL_ANY = 2276;
  SQL_VOID = 2278;       // Internal
  SQL_UUID = 2950;

  // connection status constants
  CONNECTION_OK = 0;
  CONNECTION_BAD  = 1;
  CONNECTION_STARTED = 2;
  CONNECTION_MADE = 3;
  CONNECTION_AWAITING_RESPONSE = 4;
  CONNECTION_AUTH_OK = 5;
  CONNECTION_SETENV = 6;
  CONNECTION_SSL_STARTUP = 7;
  CONNECTION_NEEDED = 8;

  // exec status constants
  PGRES_EMPTY_QUERY = 0;
  PGRES_COMMAND_OK = 1;
  PGRES_TUPLES_OK = 2;
  PGRES_COPY_OUT = 3;
  PGRES_COPY_IN = 4;
  PGRES_BAD_RESPONSE = 5;
  PGRES_NONFATAL_ERROR = 6;
  PGRES_FATAL_ERROR = 7;

  // error fields, copied from postgres_ext.h
  PG_DIAG_SEVERITY = Ord('S');
  PG_DIAG_SQLSTATE = Ord('C');
  PG_DIAG_MESSAGE_PRIMARY = Ord('M');
  PG_DIAG_MESSAGE_DETAIL = Ord('D');
  PG_DIAG_MESSAGE_HINT = Ord('H');
  PG_DIAG_STATEMENT_POSITION = Ord('P');
  PG_DIAG_INTERNAL_POSITION = Ord('p');
  PG_DIAG_INTERNAL_QUERY = Ord('q');
  PG_DIAG_CONTEXT = Ord('W');
  PG_DIAG_SOURCE_FILE = Ord('F');
  PG_DIAG_SOURCE_LINE = Ord('L');
  PG_DIAG_SOURCE_FUNCTION = Ord('R');

  // PGTransactionStatusType
	PQTRANS_IDLE = 0;		 // connection idle
	PQTRANS_ACTIVE = 1;	 // command in progress
	PQTRANS_INTRANS = 2; // idle, within transaction block
	PQTRANS_INERROR = 3; // idle, within failed transaction
	PQTRANS_UNKNOWN = 4; // cannot determine status

  // Attribute numbers for the system-defined attributes
  // Source: src\include\access\htup.h
  SelfItemPointerAttributeNumber  = -1;
  ObjectIdAttributeNumber         = -2;
  MinTransactionIdAttributeNumber = -3;
  MinCommandIdAttributeNumber     = -4;
  MaxTransactionIdAttributeNumber = -5;
  MaxCommandIdAttributeNumber     = -6;
  TableOidAttributeNumber         = -7;

  // other
  POSTGRES_EPOCH_JDATE = 2451545;
  NAMEMAXLEN = 64;
  InvalidOid = 0;
  VARHDRSZ = 4;

  NULL_LEN = -1;

type
  PGConn = Pointer;
  PPGConn = Pointer;

  // Internal pqlib structure
  pgresAttValue = record
    len: Integer;
    value: PADAnsiString;
  end;
  PPGresAttValue = ^pgresAttValue;
  PPPGresAttValue = ^PPGresAttValue;

  // Internal pqlib structure
  pg_result = record
	  ntups: Integer;
	  numAttributes: Integer;
	  attDescs: Pointer;
	  tuples: PPPGresAttValue;	// each PGresTuple is an array of PGresAttValue's
    // ..........
  end;
  PGresult = pg_result;
  PPGresult = ^PGresult;

  PGcancel = Pointer;
  PPGcancel = Pointer;

  Oid = LongWord;
  POid = ^Oid;
  Tid = array[0..5] of Byte;
  PTid = ^Tid;

  PQConninfoOptions = record
    keyword: PADAnsiString;   // The keyword of the option
    envvar: PADAnsiString;    // Fallback environment variable name
    compiled: PADAnsiString;  // Fallback compiled in default value
    val: PADAnsiString;       // Option's current value, or NULL
    lbl: PADAnsiString;       // Label for field in connect dialog
    dispchar: PADAnsiString;  // Character to display for this field in a
                          // connect dialog. Values are: "" Display
                          // entered value as is "*" Password field -
                          // hide value "D"  Debug option - don't show
                          // by default
    dispsize: integer;    // Field size in characters for dialog
  end;
  PPQconninfoOption = ^PQConninfoOptions;

  PGnotify = record
    relname: PADAnsiString;   // notification condition name
    be_pid: Integer;      // process ID of notifying server process
    extra: PADAnsiString;     // notification parameter
  end;
  PPGnotify = ^PGnotify;

  // Notice Processing
  TPQnoticeReceiver = procedure(arg: Pointer; res: PPGresult);
    {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQnoticeProcessor = procedure(arg: Pointer; msg: PADAnsiString);
    {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

{$IFDEF AnyDAC_PGSQL_STATIC}

  {$L crypt.obj}
//  {$L dirent.obj}
//  {$L dirmod.obj}
  {$L encnames.obj}
  {$L fe-auth.obj}
  {$L fe-connect.obj}
  {$L fe-exec.obj}
  {$L fe-lobj.obj}
  {$L fe-misc.obj}
  {$L fe-print.obj}
  {$L fe-protocol2.obj}
  {$L fe-protocol3.obj}
  {$L fe-secure.obj}
  {$L getaddrinfo.obj}
  {$L inet_aton.obj}
  {$L ip.obj}
  {$L md5.obj}
  {$L noblock.obj}
  {$L open.obj}
  {$L pgsleep.obj}
  {$L pgstrcasecmp.obj}
  {$L pqexpbuffer.obj}
  {$L pqsignal.obj}
  {$L pthread-win32.obj}
  {$L snprintf.obj}
  {$L strlcpy.obj}
  {$L thread.obj}
  {$L wchar.obj}
  {$L win32.obj}
  {$L win32error.obj}

  // Database Connection Control Functions
  function PQconnectdb(ConnInfo: PADAnsiString): PPGconn; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  //  function PQsetdbLogin(Host, Port, Options, Tty, Db, User, Passwd: PADAnsiString): PPGconn; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQconndefaults: PPQconninfoOption; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  procedure PQfinish(conn: PPGconn); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  procedure PQreset(conn: PPGconn); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  // Connection Status Functions
  function PQdb(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQuser(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQpass(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQhost(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQport(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQtty(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQoptions(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQstatus(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  function PQparameterStatus(conn: PGconn; ParamName: PADAnsiString): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQtransactionStatus(conn: PGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQserverVersion(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQprotocolVersion(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQsetClientEncoding(conn: PPGconn; encoding: PADAnsiString): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQclientEncoding(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function pg_encoding_to_char(encoding_id: Integer): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  function PQerrorMessage(conn: PPGconn): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQbackendPID(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  // SSL *_PQgetssl(const PGconn *conn);

  // Command Execution Functions
  function PQexec(conn: PPGconn; command: PADByteString): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  function PQexecParams(conn: PPGconn; command: PADByteString; nParams: integer;
    paramTypes: PInteger; ParamValues: Pointer; paramLengths: PInteger;
    paramFormats: Integer; resultFormat: Integer): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQprepare(conn: PPGconn; stmtName: PADAnsiString; query: PADByteString;
    nParams: Integer; ParamTypes: POid): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQexecPrepared(conn: PPGconn; stmtName: PADAnsiString; nParams: Integer;
    paramValues: Pointer; paramLengths: PInteger; paramFormats: PInteger;
    resultFormat: Integer): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQdescribePrepared(conn: PPGconn; stmtName: PADAnsiString): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQdescribePortal(conn: PPGconn; portalName: PADAnsiString): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQresultStatus(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQresultErrorMessage(res: PPGresult): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQresultErrorField(res: PPGResult; fieldcode: integer): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  procedure PQclear(res: PPGresult); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQmakeEmptyPGresult(conn: PPGconn; status: Integer): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQntuples(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQnfields(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQfname(res: PPGresult; field_num: Integer): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQfnumber(res: PPGresult; field_name: PADByteString): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQftable(res: PPGresult; column_number: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQftablecol(res: PPGresult; column_number: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQfformat(res: PPGresult; column_number: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQftype(res: PPGresult; field_num: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQfmod(res: PPGresult; field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQfsize(res: PPGresult; field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQbinaryTuples(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQgetvalue(res: PPGresult; row_number, column_number: Integer): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQgetisnull(res: PPGresult; tup_num, field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQgetlength(res: PPGresult; tup_num, field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQnparams(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQparamtype(res: PPGresult; param_number: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  function PQcmdStatus(res: PPGresult): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQoidValue(res: PPGresult): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQoidStatus(res: PPGresult): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQcmdTuples(res: PPGresult): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  // Notice Processing
  function PQsetNoticeReceiver(conn: PPGconn; proc: TPQnoticeReceiver;
    arg: Pointer): TPQnoticeReceiver; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQsetNoticeProcessor(conn: PPGconn; proc: TPQnoticeProcessor;
    arg: Pointer): TPQnoticeProcessor; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  // Cancelling Queries in Progress
  function PQgetCancel(conn: PPGconn): PPGcancel; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  procedure PQfreeCancel(cancel: PPGcancel); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQcancel(cancel: PPGcancel; errbuf: PADAnsiString; errbufsize: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  // Large Objects support
  function lo_creat(conn: PPGconn; mode: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function lo_open(conn: PPGconn; objoid: Oid; mode: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function lo_write(conn: PPGconn; fd: Integer; buf: Pointer; len: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function lo_read(conn: PPGconn; fd: Integer; buf: Pointer; len: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function lo_lseek(conn: PPGconn; fd: Integer; offset: Integer; whence: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function lo_tell(conn: PPGconn; fd: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function lo_close(conn: PPGconn; fd: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function lo_unlink(conn: PPGconn; objoid: Oid): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  function PQgetResult(conn: PPGconn): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  // Functions Associated with the COPY Command
  function PQputCopyData(conn: PPGconn; buffer: Pointer; nbytes: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQputCopyEnd(conn: PPGconn; errormsg: Pointer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;

  // Async notifications
  // Check after: prepare, execute, describe, isbusy, getresult, putcopydata
  function PQnotifies(conn: PPGconn): PPGnotify; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  procedure PQfreemem(ptr: Pointer); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQconsumeInput(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
  function PQsocket(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF} external;
{$ENDIF}

type
  // Database Connection Control Functions
  TPQconnectdb = function(ConnInfo: PADAnsiString): PPGconn; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  //  TPQsetdbLogin = function(Host, Port, Options, Tty, Db, User, Passwd: PADAnsiString): PPGconn; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQconndefaults = function: PPQconninfoOption; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfinish = procedure(conn: PPGconn); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQreset = procedure(conn: PPGconn); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  // Connection Status Functions
  TPQdb = function(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQuser = function(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQpass = function(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQhost = function(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQport = function(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQtty = function(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQoptions = function(conn: PPGconn): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQstatus = function(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  TPQparameterStatus = function(conn: PGconn; ParamName: PADAnsiString): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQtransactionStatus = function(conn: PGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQserverVersion = function(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQprotocolVersion = function(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQsetClientEncoding = function(conn: PPGconn; encoding: PADAnsiString): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQclientEncoding = function(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tpg_encoding_to_char = function(encoding_id: Integer): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  TPQerrorMessage = function(conn: PPGconn): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQbackendPID = function(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  // SSL *PQgetssl(const PGconn *conn);

  // Command Execution Functions
  TPQexec = function(conn: PPGconn; command: PADByteString): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  TPQexecParams = function(conn: PPGconn; command: PADByteString; nParams: integer;
    paramTypes: PInteger; ParamValues: Pointer; paramLengths: PInteger;
    paramFormats: PInteger; resultFormat: Integer): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQprepare = function(conn: PPGconn; stmtName: PADAnsiString; query: PADByteString;
    nParams: Integer; ParamTypes: POid): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQexecPrepared = function(conn: PPGconn; stmtName: PADAnsiString; nParams: Integer;
    paramValues: Pointer; paramLengths: PInteger; paramFormats: PInteger;
    resultFormat: Integer): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQdescribePrepared = function(conn: PPGconn; stmtName: PADAnsiString): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQdescribePortal = function(conn: PPGconn; portalName: PADAnsiString): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQresultStatus = function(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQresultErrorMessage = function(res: PPGresult): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQresultErrorField = function(res: PPGResult; fieldcode: integer): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  TPQclear = procedure(res: PPGresult); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQmakeEmptyPGresult = function(conn: PPGconn; status: Integer): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQntuples = function(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQnfields = function(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfname = function(res: PPGresult; field_num: Integer): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfnumber = function(res: PPGresult; field_name: PADByteString): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQftable = function(res: PPGresult; column_number: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQftablecol = function(res: PPGresult; column_number: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfformat = function(res: PPGresult; column_number: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQftype = function(res: PPGresult; field_num: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfmod  = function(res: PPGresult; field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfsize = function(res: PPGresult; field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQbinaryTuples = function(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQgetvalue = function(res: PPGresult; row_number, column_number: Integer): PADByteString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQgetisnull = function(res: PPGresult; tup_num, field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQgetlength = function(res: PPGresult; tup_num, field_num: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQnparams = function(res: PPGresult): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQparamtype = function(res: PPGresult; param_number: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  TPQcmdStatus = function(res: PPGresult): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQoidValue = function(res: PPGresult): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQoidStatus = function(res: PPGresult): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQcmdTuples = function(res: PPGresult): PADAnsiString; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  // Notice Processing
  TPQsetNoticeReceiver = function(conn: PPGconn; proc: TPQnoticeReceiver;
    arg: Pointer): TPQnoticeReceiver; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQsetNoticeProcessor = function(conn: PPGconn; proc: TPQnoticeProcessor;
    arg: Pointer): TPQnoticeProcessor; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  // Cancelling Queries in Progress
  TPQgetCancel = function(conn: PPGconn): PPGcancel; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfreeCancel = procedure(cancel: PPGcancel); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQcancel = function(cancel: PPGcancel; errbuf: PADAnsiString; errbufsize: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  // Large Objects support
  Tlo_creat = function(conn: PPGconn; mode: Integer): Oid; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tlo_open = function(conn: PPGconn; objoid: Oid; mode: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tlo_write = function(conn: PPGconn; fd: Integer; buf: Pointer; len: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tlo_read = function(conn: PPGconn; fd: Integer; buf: Pointer; len: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tlo_lseek = function(conn: PPGconn; fd: Integer; offset: Integer; whence: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tlo_tell = function(conn: PPGconn; fd: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tlo_close = function(conn: PPGconn; fd: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  Tlo_unlink = function(conn: PPGconn; objoid: Oid): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  TPQgetResult = function(conn: PPGconn): PPGresult; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  // Functions Associated with the COPY Command
  TPQputCopyData = function(conn: PPGconn; buffer: Pointer; nbytes: Integer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQputCopyEnd = function(conn: PPGconn; errormsg: Pointer): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  // Async notifications
  // Check after: prepare, execute, describe, isbusy, getresult, putcopydata
  TPQnotifies = function(conn: PPGconn): PPGnotify; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQfreemem = procedure(ptr: Pointer); {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQconsumeInput = function(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}
  TPQsocket = function(conn: PPGconn): Integer; {$IFDEF AnyDAC_STATIC_CDECL} cdecl; {$ENDIF}

  // Functions mentioned below are not used in FireDAC PostgreSQL driver
  // Asynchronous Command Processing
  // PQsendQuery
  // PQsendQueryParams
  // PQsendPrepare
  // PQsendQueryPrepared
  // PQsendDescribePrepared
  // PQsendDescribePortal
  // PQgetResult
  // PQconsumeInput
  // PQisBusy
  // PQsetnonblocking
  // PQisnonblocking
  // PQflush

  // The Fast-Path Interface
  // PQfn

implementation

{$IFDEF AnyDAC_PGSQL_STATIC}
uses
  Windows, WinSock, ShlObj,
  uADPhysStatic;
{$ENDIF}

end.

