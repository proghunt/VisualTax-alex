{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                FireDAC MSSQL metadata                 }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysMSSQLMeta;

interface

uses
  Classes,
  uADStanIntf, uADStanOption,
  uADPhysIntf, uADPhysManager, uADPhysConnMeta, uADPhysCmdGenerator;

type
  TADPhysMSSQLMetadata = class (TADPhysConnectionMetadata)
  private
    FSchemaCaseSensitive,
    FCatalogCaseSensitive: Boolean;
    FCaseSensParts: TADPhysNameParts;
    FNameDoubleQuote: Boolean;
    FMSDriver: Boolean;
    FColumnOriginProvided: Boolean;
  protected
    function GetKind: TADRDBMSKind; override;
    function GetTxSavepoints: Boolean; override;
    function GetEventSupported: Boolean; override;
    function GetEventKinds: String; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; override;
    function GetInlineRefresh: Boolean; override;
    function GetIdentityInsertSupported: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetLockNoWait: Boolean; override;
    function GetAsyncAbortSupported: Boolean; override;
    function GetCommandSeparator: String; override;
    function GetLineSeparator: TADTextEndOfLine; override;
    function GetArrayExecMode: TADPhysArrayExecMode; override;
    function GetColumnOriginProvided: Boolean; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalGetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind; override;
  public
    constructor Create(const AConnectionObj: TADPhysConnection;
      ACatalogCaseSensitive, ASchemaCaseSensitive, ASchemaCaseInsSearch,
      ANameDoubleQuote, AMSDriver: Boolean; AServerVersion, AClientVersion: TADVersion;
      const ACSVKeywords: String; AColumnOriginProvided: Boolean);
  end;

  TADPhysMSSQLCommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetInlineRefresh(const AStmt: String;
      ARequest: TADUpdateRequest): String; override;
    function GetIdentityInsert(const ATable, AStmt: String;
      ARequest: TADUpdateRequest): String; override;
    function GetIdentity(ASessionScope: Boolean): String; override;
    function GetPessimisticLock: String; override;
    function GetSavepoint(const AName: String): String; override;
    function GetRollbackToSavepoint(const AName: String): String; override;
    function GetCommitSavepoint(const AName: String): String; override;
    function GetCall(const AName: String): String; override;
    function GetPing: String; override;
    function GetLimitSelect(const ASQL: String; ASkip, ARows: Integer): String; override;
  end;

implementation

uses
  SysUtils,
  uADStanConst, uADStanUtil;

{-------------------------------------------------------------------------------}
{ TADPhysOraMetadata                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysMSSQLMetadata.Create(const AConnectionObj: TADPhysConnection;
  ACatalogCaseSensitive, ASchemaCaseSensitive, ASchemaCaseInsSearch,
  ANameDoubleQuote, AMSDriver: Boolean; AServerVersion, AClientVersion: TADVersion;
  const ACSVKeywords: String; AColumnOriginProvided: Boolean);
begin
  inherited Create(AConnectionObj, AServerVersion, AClientVersion, False);
  FCatalogCaseSensitive := ACatalogCaseSensitive;
  FSchemaCaseSensitive := ASchemaCaseSensitive;
  FNameDoubleQuote := ANameDoubleQuote;
  FMSDriver := AMSDriver;
  FCaseSensParts := [];
  if FCatalogCaseSensitive then
    FCaseSensParts := FCaseSensParts + [npCatalog];
  if FSchemaCaseSensitive then
    FCaseSensParts := FCaseSensParts + [npSchema, npBaseObject, npObject];
  if ASchemaCaseInsSearch then
    FCISearch := True;
  if ACSVKeywords <> '' then
    FKeywords.CommaText := ACSVKeywords;
  ConfigQuoteChars;
  FColumnOriginProvided := AColumnOriginProvided;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkMSSQL;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := FCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := FCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [npSchema, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 128;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npCatalog, npSchema, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
  ASide: TADPhysNameQuoteSide): Char;
begin
  Result := #0;
  case AQuote of
  ncDefault:
    if ASide = nsLeft then
      Result := '['
    else
      Result := ']';
  ncSecond:
    if FNameDoubleQuote then
      Result := '"';
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetTxSavepoints: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetEventSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetEventKinds: String;
begin
  Result := S_AD_EventKind_MSSQL_Events;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetInlineRefresh: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetIdentityInsertSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDefVals;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetLockNoWait: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetCommandSeparator: String;
begin
  Result := 'GO';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetLineSeparator: TADTextEndOfLine;
begin
  Result := elWindows;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetArrayExecMode: TADPhysArrayExecMode;
begin
  if FMSDriver then
    Result := aeCollectAllErrors
  else
    // FreeTDS has broken Array DML implementation
    Result := aeUpToFirstError;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.GetColumnOriginProvided: Boolean;
begin
  Result := FMSDriver and FColumnOriginProvided;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeBoolean(
  const AStr: String): String;
begin
  if CompareText(AStr, S_AD_True) = 0 then
    Result := '1'
  else
    Result := '0';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ' + AnsiQuotedStr(AStr, '''') + ', 20)';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ' + AnsiQuotedStr(AStr, '''') + ', 20)';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ' + AnsiQuotedStr(AStr, '''') + ', 114)';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  sName: String;
  A1, A2, A3: String;
  rSeq: TADPhysEscapeData;
  i: Integer;

  function AddArgs: string;
  begin
    Result := '(' + AddEscapeSequenceArgs(ASeq) + ')';
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
  // the same
  // char
  efASCII,
  efCHAR,
  efLEFT,
  efLTRIM,
  efREPLACE,
  efRIGHT,
  efRTRIM,
  efSPACE,
  efSUBSTRING,
  // numeric
  efACOS,
  efASIN,
  efATAN,
  efABS,
  efCEILING,
  efCOS,
  efCOT,
  efDEGREES,
  efEXP,
  efFLOOR,
  efLOG,
  efLOG10,
  efPOWER,
  efPI,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN:         Result := sName + AddArgs;
  // character
  efBIT_LENGTH:  Result := '(LEN(' + A1 + ') * 8)';
  efCHAR_LENGTH: Result := 'LEN' + AddArgs;
  efCONCAT:      Result := '(' + A1 + ' + ' + A2 + ')';
  efINSERT:      Result := 'STUFF' + AddArgs;
  efLCASE:       Result := 'LOWER' + AddArgs;
  efLENGTH:      Result := 'LEN(RTRIM(' + A1 + '))';
  efLOCATE:
    begin
      Result := 'CHARINDEX(' + A1 + ', ' + A2;
      if Length(ASeq.FArgs) = 3 then
        Result := Result + ', ' + A3;
      Result := Result + ')'
    end;
  efOCTET_LENGTH:Result := 'LEN' + AddArgs;
  efPOSITION:    Result := 'CHARINDEX' + AddArgs;
  efREPEAT:      Result := 'REPLICATE' + AddArgs;
  efUCASE:       Result := 'UPPER' + AddArgs;
  // numeric
  efRANDOM:      Result := 'RAND' + AddArgs;
  efTRUNCATE:    Result := 'CAST(' + A1 + ' AS BIGINT)';
  efATAN2:       Result := 'ATN2' + AddArgs;
  efMOD:         Result := '((' + A1 + ') % (' + A2 + '))';
  efROUND:
    if A2 = '' then
      Result := sName + '(' + A1 + ', 0)'
    else
      Result := sName + AddArgs;
  efRADIANS:
    Result := sName + '(' + A1 + ' + 0.0)';
  // date and time
  efCURDATE,
  efCURTIME,
  efNOW:         Result := 'GETDATE()';
  efDAYNAME:     Result := 'DATENAME(WEEKDAY, ' + A1 + ')';
  efDAYOFMONTH:  Result := 'DATEPART(DAY, ' + A1 + ')';
  efDAYOFWEEK:   Result := '((DATEPART(WEEKDAY, ' + A1 + ') + @@DATEFIRST - 1) % 7 + 1)';
  efDAYOFYEAR:   Result := 'DATEPART(DAYOFYEAR, ' + A1 + ')';
  efEXTRACT:
    begin
      rSeq.FKind := eskFunction;
      A1 := UpperCase(ADUnquote(Trim(A1), ''''));
      if A1 = 'DAY' then
        A1 := 'DAYOFMONTH';
      rSeq.FName := A1;
      SetLength(rSeq.FArgs, 1);
      rSeq.FArgs[0] := ASeq.FArgs[1];
      EscapeFuncToID(rSeq);
      Result := InternalEscapeFunction(rSeq);
    end;
  efHOUR:        Result := 'DATEPART(HOUR, ' + A1 + ')';
  efMINUTE:      Result := 'DATEPART(MINUTE, ' + A1 + ')';
  efMONTH:       Result := 'DATEPART(MONTH, ' + A1 + ')';
  efMONTHNAME:   Result := 'DATENAME(MONTH, ' + A1 + ')';
  efQUARTER:     Result := 'DATEPART(QUARTER, ' + A1 + ')';
  efSECOND:      Result := 'DATEPART(SECOND, ' + A1 + ')';
  efTIMESTAMPADD:
    begin
      A1 := UpperCase(ADUnquote(Trim(A1), ''''));
      if A1 = 'FRAC_SECOND' then begin
        A1 := 'MILLISECOND';
        A2 := '(' + A2 + ' / 1000)';
      end;
      ASeq.FArgs[0] := A1;
      ASeq.FArgs[1] := A2;
      Result := 'DATEADD' + AddArgs;
    end;
  efTIMESTAMPDIFF:
    begin
      A1 := UpperCase(ADUnquote(Trim(A1), ''''));
      if A1 = 'FRAC_SECOND' then
        A1 := 'MILLISECOND';
      ASeq.FArgs[0] := A1;
      Result := 'DATEDIFF' + AddArgs;
      if A1 = 'MILLISECOND' then
        Result := '(' + Result + ' * 1000.0)';
    end;
  efWEEK:        Result := 'DATEPART(WEEK, ' + A1 + ')';
  efYEAR:        Result := 'DATEPART(YEAR, ' + A1 + ')';
  // system
  efCATALOG:     Result := 'DB_NAME()';
  efSCHEMA:
    if GetServerVersion >= svMSSQL2005 then
      Result := 'SCHEMA_NAME()'
    else
      Result := 'CURRENT_USER()';
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
    Result := 'CONVERT(' + A2 + ', ' + A1 + ')';
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLMetadata.InternalGetSQLCommandKind(
  const ATokens: TStrings): TADPhysCommandKind;
var
  sToken: String;
begin
  sToken := ATokens[0];
  if (sToken = 'EXEC') or (sToken = 'EXECUTE') then
    Result := skExecute
  else if sToken = 'BEGIN' then
    if ATokens.Count = 1 then
      Result := skNotResolved
    else if (ATokens[1] = 'TRAN') or (ATokens[1] = 'TRANSACTION') then
      Result := skStartTransaction
    else
      Result := inherited InternalGetSQLCommandKind(ATokens)
  else if sToken = 'IF' then
    // IF @@TRANCOUNT > 0 COMMIT | ROLLBACK
    if ATokens.Count = 1 then
      Result := skNotResolved
    else if ATokens[1] = 'COMMIT' then
      Result := skCommit
    else if ATokens[1] = 'ROLLBACK' then
      Result := skRollback
    else
      Result := inherited InternalGetSQLCommandKind(ATokens)
  else if sToken = 'RECEIVE' then
    Result := skSelect
  else
    Result := inherited InternalGetSQLCommandKind(ATokens);
end;

{-------------------------------------------------------------------------------}
{ TADPhysMSSQLCommandGenerator                                                  }
{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetInlineRefresh(const AStmt: String;
  ARequest: TADUpdateRequest): String;
begin
  Result := GenerateSelect(False);
  if Result <> '' then
    Result := AStmt + ';' + BRK + Result
  else
    Result := AStmt;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetIdentityInsert(
  const ATable, AStmt: String; ARequest: TADUpdateRequest): String;
begin
  Result := 'SET IDENTITY_INSERT ' + ATable + ' ON;' + BRK + AStmt +
    ';' + BRK + 'SET IDENTITY_INSERT ' + ATable + ' OFF';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetIdentity(ASessionScope: Boolean): String;
begin
  if not ASessionScope and
     ((FConnMeta.ServerVersion = 0) or (FConnMeta.ServerVersion >= svMSSQL2000)) then
    Result := 'SCOPE_IDENTITY()'
  else
    Result := '@@IDENTITY';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetPessimisticLock: String;
var
  lNeedFrom: Boolean;
begin
  if not FOptions.UpdateOptions.LockWait then
    Result := 'SET LOCK_TIMEOUT 0;' + BRK;
  lNeedFrom := False;
  Result := Result + 'SELECT ' + GetSelectList(True, False, lNeedFrom) + BRK +
    'FROM ' + GetFrom + ' WITH(ROWLOCK,UPDLOCK)' + BRK +
    'WHERE ' + GetWhere(False, True, False);
  FCommandKind := skSelectForLock;
  ASSERT(lNeedFrom);
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'IF @@TRANCOUNT = 0 BEGIN SET IMPLICIT_TRANSACTIONS OFF BEGIN TRANSACTION END SAVE TRANSACTION ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'ROLLBACK TRANSACTION ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetCommitSavepoint(const AName: String): String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetCall(const AName: String): String;
begin
  Result := 'EXECUTE ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetPing: String;
begin
  Result := 'SELECT 1';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSSQLCommandGenerator.GetLimitSelect(const ASQL: String;
  ASkip, ARows: Integer): String;
var
  s: string;
begin
  if (GetSQLOrderByPos > 0) and (FConnMeta.ServerVersion >= svMSSQL2012) then begin
    s := UpperCase(ASQL);
    if not (HasKW(s, 'UNION') or HasKW(s, 'INTERSECT') or HasKW(s, 'EXCEPT')) then
      if (ASkip > 0) and (ARows + ASkip <> MAXINT) then
        Result := ASQL + BRK + 'OFFSET ' + IntToStr(ASkip) + ' ROWS FETCH FIRST ' + IntToStr(ARows) + ' ROWS ONLY'
      else if ASkip > 0 then
        Result := ASQL + BRK + 'OFFSET ' + IntToStr(ASkip) + ' ROWS'
      else if ARows >= 0 then
        Result := ASQL + BRK + 'OFFSET 0 ROWS FETCH FIRST ' + IntToStr(ARows) + ' ROWS ONLY'
      else
        Result := ASQL
    else
      Result := inherited GetLimitSelect(ASQL, ASkip, ARows);
  end
  else
    Result := inherited GetLimitSelect(ASQL, ASkip, ARows);
end;

end.
