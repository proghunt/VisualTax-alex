{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                FireDAC SQLite metadata                }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysSQLiteMeta;

interface

uses
  Classes,
  uADStanIntf, uADStanOption,
  uADPhysIntf, uADPhysManager, uADPhysConnMeta, uADPhysCmdGenerator;

type
  TADPhysSQLiteBrand = (sbSQLite, sbBDB);

  IADPhysSQLiteConnectionMetadata = interface (IUnknown)
    ['{91D454A4-327D-4ED2-8EF5-3F77BFB5B619}']
    // private
    function GetBrand: TADPhysSQLiteBrand;
    // public
    property Brand: TADPhysSQLiteBrand read GetBrand;
  end;

  TADPhysSQLiteMetadata = class (TADPhysConnectionMetadata, IADPhysSQLiteConnectionMetadata)
  private
    FBrand: TADPhysSQLiteBrand;
    FColumnOriginProvided: Boolean;
  protected
    // IADPhysConnectionMetadata
    function GetKind: TADRDBMSKind; override;
    function GetTxSavepoints: Boolean; override;
    function GetEventSupported: Boolean; override;
    function GetEventKinds: String; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameQuotedCaseSens(const AName: String; APart: TADPhysNamePart): Boolean; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetIdentityInsertSupported: Boolean; override;
    function GetNamedParamMark: TADPhysParamMark; override;
    function GetPositionedParamMark: TADPhysParamMark; override;
    function GetSelectWithoutFrom: Boolean; override;
    function GetAsyncAbortSupported: Boolean; override;
    function GetArrayExecMode: TADPhysArrayExecMode; override;
    function GetLimitOptions: TADPhysLimitOptions; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetColumnOriginProvided: Boolean; override;
    function GetInlineRefresh: Boolean; override;
    function GetTruncateSupported: Boolean; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalGetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind; override;
    // IADPhysSQLiteConnectionMetadata
    function GetBrand: TADPhysSQLiteBrand;
  public
    constructor Create(const AConnection: TADPhysConnection;
      ABrand: TADPhysSQLiteBrand; AServerVersion, AClientVersion: TADVersion;
      AIsUnicode, AColumnOriginProvided: Boolean);
  end;

  TADPhysSQLiteCommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetIdentity(ASessionScope: Boolean): String; override;
    function GetReadGenerator(const AName, AAlias: String;
      ANextValue, AFullSelect: Boolean): String; override;
    function GetInlineRefresh(const AStmt: String;
      ARequest: TADUpdateRequest): String; override;
    function GetPing: String; override;
    function GetCommitSavepoint(const AName: String): String; override;
    function GetRollbackToSavepoint(const AName: String): String; override;
    function GetSavepoint(const AName: String): String; override;
    function GetCall(const AName: String): String; override;
    function GetSelectMetaInfo(AKind: TADPhysMetaInfoKind;
      const ACatalog, ASchema, ABaseObject, AObject, AWildcard: String;
      AObjectScopes: TADPhysObjectScopes; ATableKinds: TADPhysTableKinds;
      AOverload: Word): String; override;
    function GetLimitSelect(const ASQL: String; ASkip, ARows: Integer): String; override;
  end;

implementation

uses
  SysUtils,
  uADStanConst, uADStanUtil, uADDatSManager, uADStanError;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteMetadata                                                         }
{-------------------------------------------------------------------------------}
constructor TADPhysSQLiteMetadata.Create(const AConnection: TADPhysConnection;
  ABrand: TADPhysSQLiteBrand; AServerVersion, AClientVersion: TADVersion;
  AIsUnicode, AColumnOriginProvided: Boolean);
begin
  inherited Create(AConnection, AServerVersion, AClientVersion, AIsUnicode);
  FBrand := ABrand;
  FColumnOriginProvided := AColumnOriginProvided;
  FKeywords.CommaText :=
    'ABORT,ADD,AFTER,ALL,ALTER,ANALYZE,AND,AS,ASC,ATTACH,AUTOINCREMENT,BEFORE,' +
    'BEGIN,BETWEEN,BY,CASCADE,CASE,CAST,CHECK,COLLATE,COLUMN,COMMIT,CONFLICT,' +
    'CONSTRAINT,CREATE,CROSS,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,DATABASE,' +
    'DEFAULT,DEFERRABLE,DEFERRED,DELETE,DESC,DETACH,DISTINCT,DROP,EACH,ELSE,END,' +
    'ESCAPE,EXCEPT,EXCLUSIVE,EXISTS,EXPLAIN,FAIL,FOR,FOREIGN,FROM,FULL,GLOB,GROUP,' +
    'HAVING,IF,IGNORE,IMMEDIATE,IN,INDEX,INITIALLY,INNER,INSERT,INSTEAD,INTERSECT,' +
    'INTO,IS,ISNULL,JOIN,KEY,LEFT,LIKE,LIMIT,MATCH,NATURAL,NOT,NOTNULL,NULL,OF,' +
    'OFFSET,ON,OR,ORDER,OUTER,PLAN,PRAGMA,PRIMARY,QUERY,RAISE,REFERENCES,REGEXP,' +
    'REINDEX,RENAME,REPLACE,RESTRICT,RIGHT,ROLLBACK,ROW,SELECT,SET,TABLE,TEMP,' +
    'TEMPORARY,THEN,TO,TRANSACTION,TRIGGER,UNION,UNIQUE,UPDATE,USING,VACUUM,' +
    'VALUES,VIEW,VIRTUAL,WHEN,WHERE';
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkSQLite;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetParamNameMaxLength: Integer;
begin
  Result := MAXINT;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npCatalog, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
  ASide: TADPhysNameQuoteSide): Char;
begin
  Result := #0;
  case AQuote of
  ncDefault:
    Result := '"';
  ncSecond:
    if ASide = nsLeft then
      Result := '['
    else
      Result := ']';
  ncThird:
    Result := '`';
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetNameQuotedCaseSens(const AName: String;
  APart: TADPhysNamePart): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to Length(AName) do
    if not ADInSet(AName[i], ['a' .. 'z', 'A' .. 'Z', '0' .. '9',
                              '_', '$', '#', '"', '[', ']', '`']) then begin
      Result := True;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetNamedParamMark: TADPhysParamMark;
begin
  Result := prName;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetPositionedParamMark: TADPhysParamMark;
begin
  Result := prQNumber;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetTxSavepoints: Boolean;
begin
  Result := GetServerVersion >= svSQLite030608;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetEventSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetEventKinds: String;
begin
  Result := S_AD_EventKind_SQLite_Events;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetTruncateSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetInlineRefresh: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetSelectWithoutFrom: Boolean;
begin
  Result := True;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysSQLiteMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDefVals;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetColumnOriginProvided: Boolean;
begin
  Result := FColumnOriginProvided;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetIdentityInsertSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetArrayExecMode: TADPhysArrayExecMode;
begin
  if GetServerVersion >= svSQLite030711 then
    Result := aeOnErrorUndoAll
  else
    Result := aeUpToFirstError;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetLimitOptions: TADPhysLimitOptions;
begin
  Result := [loSkip, loRows];
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.GetBrand: TADPhysSQLiteBrand;
begin
  Result := FBrand;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.InternalEscapeBoolean(const AStr: String): String;
begin
  if CompareText(AStr, S_AD_True) = 0 then
    Result := '1'
  else
    Result := '0';
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := AnsiQuotedStr(AStr, '''');
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := AnsiQuotedStr(AStr, '''');
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := AnsiQuotedStr(AStr, '''');
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := 'CAST(' + AnsiQuotedStr(AStr, '''') + ' AS REAL)';
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  sName, A1, A2, A3: String;
  i: Integer;

  function AddArgs: string;
  begin
    Result := '(';
    if Length(ASeq.FArgs) > 0 then
      Result := Result + AddEscapeSequenceArgs(ASeq);
    Result := Result + ')';
  end;

  function Unquote(const AValue: String): String;
  begin
    Result := Trim(AValue);
    if Result[1] = '''' then
      Result := Copy(Result, 2, Length(Result) - 2);
  end;

begin
  sName := ASeq.FName;
  if Length(ASeq.FArgs) >= 1 then begin
    A1 := ASeq.FArgs[0];
    if Length(ASeq.FArgs) >= 2 then begin
      A2 := ASeq.FArgs[1];
      if Length(ASeq.FArgs) >= 3 then
        A3 := ASeq.FArgs[2];
    end;
  end;
  case ASeq.FFunc of
  // numeric
  efRANDOM:
    begin
      Result := '(ABS(RANDOM()) / 9223372036854775807)';
      if Length(ASeq.FArgs) = 1 then
        Result := '(' + Result + ' * (' + A1 + '))';
    end;
  efDEGREES,
  efRADIANS,
  efTRUNCATE,
  efLOG,
  efROUND,
  efABS,
  efACOS,
  efASIN,
  efATAN,
  efATAN2,
  efCEILING,
  efCOS,
  efCOT,
  efEXP,
  efFLOOR,
  efLOG10,
  efMOD,
  efPI,
  efPOWER,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN:         Result := sName + AddArgs;

  // character
  efBIT_LENGTH:  Result := '(OCTET_LENGTH(' + A1 + ') * 8)';
  efASCII,
  efCHAR,
  efCONCAT,
  efLCASE,
  efLENGTH,
  efLOCATE,
  efPOSITION,
  efLTRIM,
  efREPEAT,
  efRTRIM,
  efSPACE,
  efUCASE,
  efCHAR_LENGTH,
  efOCTET_LENGTH,
  efREPLACE,
  efSUBSTRING:   Result := sName + AddArgs;

  // See comment in uADPhysSQLiteWrapper, TSQLiteExpressionFunction.Create
  efINSERT,
  efLEFT,
  efRIGHT:       Result := sName + '_' + AddArgs;

  // system
  efCATALOG:     Result := '''MAIN''';
  efSCHEMA:      Result := '''''';
  efIFNULL:      Result := 'CASE WHEN ' + A1 + ' IS NULL THEN ' + A2 + ' ELSE ' + A1 + ' END';
  efIF:          Result := 'CASE WHEN ' + A1 + ' THEN ' + A2 + ' ELSE ' + A3 + ' END';
  efDECODE:
    begin
      Result := 'CASE ' + ASeq.FArgs[0];
      i := 1;
      while i < Length(ASeq.FArgs) - 1 do begin
        Result := Result + ' WHEN ' + ASeq.FArgs[i] + ' THEN ' + ASeq.FArgs[i + 1];
        Inc(i, 2);
      end;
      if i = Length(ASeq.FArgs) - 1 then
        Result := Result + ' ELSE ' + ASeq.FArgs[i];
      Result := Result + ' END';
    end;

  // convert
  efCONVERT:
    begin
      A2 := UpperCase(Trim(A2));
      if A2 = 'DATE' then
        Result := 'DATE(' + A1 + ')'
      else if A2 = 'TIME' then
        Result := 'TIME(' + A1 + ')'
      else if (A2 = 'DATETIME') or (A2 = 'TIMESTAMP') then
        Result := 'DATETIME(' + A1 + ')'
      else
        Result := 'CAST(' + A1 + ' AS ' + A2 + ')';
    end;

  // date and time
  efCURDATE:     Result := 'DATE(''NOW'')';
  efCURTIME:     Result := 'TIME(''NOW'')';
  efNOW:         Result := 'DATETIME(''NOW'')';
  efDAYNAME:
    begin
      Result := 'CASE STRFTIME(''%w'', ' + A1 + ')';
      for i := 1 to 7 do
        Result := Result + ' WHEN ''' + IntToStr(i mod 7) + ''' THEN ''' +
          AnsiUpperCase({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} LongDayNames[i mod 7 + 1]) + '''';
      Result := Result + ' END';
    end;
  efDAYOFMONTH:  Result := 'CAST(STRFTIME(''%d'', ' + A1 + ') AS INT)';
  efDAYOFWEEK:   Result := '(STRFTIME(''%w'', ' + A1 + ') + 1)';
  efDAYOFYEAR:   Result := 'CAST(STRFTIME(''%j'', ' + A1 + ') AS INT)';
  efHOUR:        Result := 'CAST(STRFTIME(''%H'', ' + A1 + ') AS INT)';
  efMINUTE:      Result := 'CAST(STRFTIME(''%M'', ' + A1 + ') AS INT)';
  efMONTH:       Result := 'CAST(STRFTIME(''%m'', ' + A1 + ') AS INT)';
  efMONTHNAME:
    begin
      Result := 'CASE STRFTIME(''%m'', ' + A1 + ')';
      for i := 1 to 12 do
        Result := Result + ' WHEN ''' + Format('%.2d', [i]) + ''' THEN ''' +
          AnsiUpperCase({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} LongMonthNames[i]) + '''';
      Result := Result + ' END';
    end;
  efSECOND:      Result := 'CAST(STRFTIME(''%S'', ' + A1 + ') AS INT)';
  efWEEK:        Result := '(STRFTIME(''%W'', ' + A1 + ') + 1)';
  efYEAR:        Result := 'CAST(STRFTIME(''%Y'', ' + A1 + ') AS INT)';

  efEXTRACT,
  efQUARTER,
  efTIMESTAMPADD,
  efTIMESTAMPDIFF:
                 Result := sName + AddArgs;
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteMetadata.InternalGetSQLCommandKind(
  const ATokens: TStrings): TADPhysCommandKind;
var
  sToken: String;
begin
  sToken := ATokens[0];
  if sToken = 'BEGIN' then
    Result := skStartTransaction
  else if sToken = 'END' then
    Result := skCommit
  else if sToken = 'EXPLAIN' then
    Result := skSelect
  else if sToken = 'REPLACE' then
    Result := skMerge
  else if sToken = 'UPDATE' then
    if ATokens.Count < 3 then
      Result := skNotResolved
    else if (ATokens[1] = 'OR') and (ATokens[2] = 'INSERT') then
      Result := skMerge
    else
      Result := skUpdate
  else if sToken = 'INSERT' then
    if (ATokens.Count = 1) or
       (ATokens.Count = 2) and (ATokens[1] = 'OR') then
      Result := skNotResolved
    else if (ATokens.Count = 3) and (ATokens[1] = 'OR') and (ATokens[2] = 'UPDATE') then
      Result := skMerge
    else
      Result := skInsert
  else
    Result := inherited InternalGetSQLCommandKind(ATokens);
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteCommandGenerator                                                 }
{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetIdentity(ASessionScope: Boolean): String;
begin
  Result := 'LAST_INSERT_ROWID()';
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetReadGenerator(const AName,
  AAlias: String; ANextValue, AFullSelect: Boolean): String;
begin
  if ANextValue or (AName <> '') and not AFullSelect then
    ADCapabilityNotSupported(Self, [S_AD_LPhys]);
  if AName = '' then
    Result := inherited GetReadGenerator(AName, AAlias, ANextValue, AFullSelect)
  else begin
    Result := 'SELECT seq ';
    if AAlias <> '' then
      Result := Result + ' AS ' + AAlias;
    Result := Result + ' FROM sqlite_sequence WHERE name = ''' + AName + '''';
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetInlineRefresh(const AStmt: String;
  ARequest: TADUpdateRequest): String;
begin
  Result := GenerateSelect(False);
  if Result <> '' then
    Result := AStmt + ';' + BRK + Result
  else
    Result := AStmt;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetPing: String;
begin
  Result := 'SELECT 1';
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetCall(const AName: String): String;
begin
  Result := 'SELECT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetCommitSavepoint(const AName: String): String;
begin
  Result := 'RELEASE SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'ROLLBACK TO SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetSelectMetaInfo(AKind: TADPhysMetaInfoKind;
  const ACatalog, ASchema, ABaseObject, AObject, AWildcard: String;
  AObjectScopes: TADPhysObjectScopes; ATableKinds: TADPhysTableKinds;
  AOverload: Word): String;
var
  lWasWhere: Boolean;
  sCat, sDatabase, sWhere: String;

  procedure AddWhere(const ACond: String);
  begin
    if lWasWhere then
      Result := Result + ' AND ' + ACond
    else begin
      Result := Result + ' WHERE ' + ACond;
      lWasWhere := True;
    end;
  end;

begin
  if (ACatalog <> '') and (ACatalog <> 'MAIN') then begin
    sCat := ACatalog + '.';
    sDatabase := ACatalog;
  end
  else begin
    sCat := '';
    sDatabase := 'MAIN';
  end;
  lWasWhere := False;
  Result := '';
  case AKind of
  mkTables:
    begin
      Result := 'SELECT NULL AS RECNO, ''' + sDatabase + ''' AS CATALOG_NAME, ' +
        'NULL AS SCHEMA_NAME, tbl_name AS TABLE_NAME, ' +
        'CASE type ' +
          'WHEN ''table'' THEN ' +
            'CASE tmp '+
            'WHEN 0 THEN ' + IntToStr(Integer(tkTable)) +
            ' ELSE ' + IntToStr(Integer(tkTempTable)) +
            ' END ' +
          'WHEN ''view'' THEN ' + IntToStr(Integer(tkView)) +
        ' END AS TABLE_TYPE, ' + IntToStr(Integer(osMy)) + ' AS TABLE_SCOPE ' +
        'FROM (' +
          'SELECT t1.*, 0 AS tmp FROM ' + sCat + 'sqlite_master t1 ' +
          'UNION ALL ' +
          'SELECT t2.*, 1 AS tmp FROM ' + sCat + 'sqlite_temp_master t2)';
      sWhere := '';
      if tkTable in ATableKinds then
        sWhere := sWhere + ' OR type = ''table'' AND tmp = 0';
      if tkTempTable in ATableKinds then
        sWhere := sWhere + ' OR type = ''table'' AND tmp = 1';
      if tkView in ATableKinds then
        sWhere := sWhere + ' OR type = ''view''';
      if ([tkSynonym, tkLocalTable] * ATableKinds <> []) or
         (ATableKinds = []) then
        sWhere := sWhere + ' OR 0 = 1';
      AddWhere('(' + Copy(sWhere, 5, MAXINT) + ')');
      if AWildcard <> '' then
        AddWhere('tbl_name LIKE ''' + AWildcard + '''');
      Result := Result + ' ORDER BY 4';
    end;
  mkTableFields,
  mkPrimaryKey:
    Result := 'PRAGMA ' + sCat + 'table_info("' + AObject + '")';
  mkPrimaryKeyFields:
    Result := 'PRAGMA ' + sCat + 'table_info("' + ABaseObject + '")';
  mkIndexes:
    Result := 'PRAGMA ' + sCat + 'index_list("' + AObject + '")';
  mkIndexFields:
    Result := 'PRAGMA ' + sCat + 'index_info("' + AObject + '")';
  mkForeignKeys:
    Result := 'PRAGMA ' + sCat + 'foreign_key_list("' + AObject + '")';
  mkForeignKeyFields:
    Result := 'PRAGMA ' + sCat + 'foreign_key_list("' + ABaseObject + '")';
  else
    Result := '';
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommandGenerator.GetLimitSelect(const ASQL: String;
  ASkip, ARows: Integer): String;
begin
  if (ASkip > 0) and (ARows + ASkip <> MAXINT) then
    Result := ASQL + BRK + 'LIMIT ' + IntToStr(ARows) + ' OFFSET ' + IntToStr(ASkip)
  else if ASkip > 0 then
    Result := ASQL + BRK + 'LIMIT -1 OFFSET ' + IntToStr(ASkip)
  else if ARows >= 0 then
    Result := ASQL + BRK + 'LIMIT ' + IntToStr(ARows)
  else
    Result := ASQL;
end;

end.
