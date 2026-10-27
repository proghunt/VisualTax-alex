{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{       FireDAC Adaptive Server Anywhere metadata       }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysASAMeta;

interface

uses
  Classes,
  uADStanIntf,
  uADPhysIntf, uADPhysConnMeta, uADPhysCmdGenerator, uADPhysManager;

type
  TADPhysASAMetadata = class (TADPhysConnectionMetadata)
  protected
    function GetKind: TADRDBMSKind; override;
    function GetTxSavepoints: Boolean; override;
    function GetEventKinds: String; override;
    function GetEventSupported: Boolean; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetIdentityInsertSupported: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetAsyncAbortSupported: Boolean; override;
    function GetLimitOptions: TADPhysLimitOptions; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalGetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind; override;
  public
    constructor Create(const AConnectionObj: TADPhysConnection;
      AServerVersion, AClientVerison: TADVersion; const ACSVKeywords: String);
  end;

  TADPhysASACommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetIdentity(ASessionScope: Boolean): String; override;
    function GetPessimisticLock: String; override;
    function GetSavepoint(const AName: String): String; override;
    function GetRollbackToSavepoint(const AName: String): String; override;
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
constructor TADPhysASAMetadata.Create(const AConnectionObj: TADPhysConnection;
  AServerVersion, AClientVerison: TADVersion; const ACSVKeywords: String);
var
  i: Integer;
begin
  inherited Create(AConnectionObj, AServerVersion, AClientVerison, False);
  if ACSVKeywords <> '' then begin
    FKeywords.CommaText := ACSVKeywords;
    // Early ASA ODBC drivers erroneously return 'DBA' as a keyword.
    // But really it is not a keyword and may be used as identifier.
    i := FKeywords.IndexOf('dba');
    if i >= 0 then
      FKeywords.Delete(i);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkASA;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 128;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npSchema, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetTxSavepoints: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetEventSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetEventKinds: String;
begin
  Result := S_AD_EventKind_ASA_Events;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetIdentityInsertSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDef;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.GetLimitOptions: TADPhysLimitOptions;
begin
  if GetServerVersion >= cvSybaseASA9 then
    Result := [loSkip, loRows]
  else
    Result := [loRows];
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.InternalEscapeBoolean(
  const AStr: String): String;
begin
  if CompareText(AStr, S_AD_True) = 0 then
    Result := '1'
  else
    Result := '0';
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ' + AnsiQuotedStr(AStr, '''') + ', 20)';
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ' + AnsiQuotedStr(AStr, '''') + ', 20)';
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := 'CONVERT(DATETIME, ' + AnsiQuotedStr(AStr, '''') + ', 114)';
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
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
  efBIT_LENGTH:  Result := '(LENGTH(' + A1 + ') * 8)';
  efCHAR_LENGTH: Result := 'LENGTH' + AddArgs;
  efCONCAT:      Result := '(' + A1 + ' + ' + A2 + ')';
  efINSERT:      Result := 'STUFF' + AddArgs;
  efLCASE:       Result := 'LOWER' + AddArgs;
  efLENGTH:      Result := 'LENGTH(RTRIM(' + A1 + '))';
  efLOCATE:
    begin
      Result := 'LOCATE(' + A2 + ', ' + A1;
      if A3 <> '' then
        Result := Result + ', ' + A3;
      Result := Result + ')';
    end;
  efOCTET_LENGTH:Result := 'LENGTH' + AddArgs;
  efPOSITION:    Result := 'CHARINDEX' + AddArgs;
  efREPEAT:      Result := 'REPLICATE' + AddArgs;
  efUCASE:       Result := 'UPPER' + AddArgs;
  // numeric
  efRANDOM:      Result := 'RAND' + AddArgs;
  efTRUNCATE:    Result := 'CAST(' + A1 + ' AS BIGINT)';
  efATAN2:       Result := 'ATN2' + AddArgs;
  efMOD:         Result := 'MOD' + AddArgs;
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
  efDAYOFWEEK:   Result := 'DATEPART(WEEKDAY, ' + A1 + ')';
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
  efSCHEMA:      Result := 'CURRENT_USER()';
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
function TADPhysASAMetadata.InternalGetSQLCommandKind(
  const ATokens: TStrings): TADPhysCommandKind;
var
  sToken: String;
begin
  sToken := ATokens[0];
  if sToken = 'CALL' then
    Result := skExecute
  else if sToken = 'BEGIN' then
    if ATokens.Count = 1 then
      Result := skNotResolved
    else if ATokens[1] = 'TRANSACTION' then
      Result := skStartTransaction
    else
      Result := inherited InternalGetSQLCommandKind(ATokens)
  else
    Result := inherited InternalGetSQLCommandKind(ATokens);
end;

{-------------------------------------------------------------------------------}
{ TADPhysASACommandGenerator                                                    }
{-------------------------------------------------------------------------------}
function TADPhysASACommandGenerator.GetIdentity(ASessionScope: Boolean): String;
begin
  Result := '@@IDENTITY';
end;

{-------------------------------------------------------------------------------}
function TADPhysASACommandGenerator.GetPessimisticLock: String;
var
  lNeedFrom: Boolean;
begin
  Result := 'BEGIN ';
  if FOptions.UpdateOptions.LockWait then
    Result := Result + 'SET TEMPORARY OPTION BLOCKING_TIMEOUT = 0; '
  else
    Result := Result + 'SET TEMPORARY OPTION BLOCKING_TIMEOUT = 1000; ';
  Result := Result + 'SELECT ' + GetSelectList(True, False, lNeedFrom) +
    ' FROM ' + GetFrom + ' WHERE ' + GetWhere(False, True, False) + ' FOR UPDATE; ';
  Result := Result + 'SET TEMPORARY OPTION BLOCKING_TIMEOUT =; ' +
    'EXCEPTION WHEN OTHERS THEN SET TEMPORARY OPTION BLOCKING_TIMEOUT =; END';
  FCommandKind := skSelectForLock;
  ASSERT(lNeedFrom);
end;

{-------------------------------------------------------------------------------}
function TADPhysASACommandGenerator.GetSavepoint(const AName: String): String;
begin
  Result := 'SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysASACommandGenerator.GetRollbackToSavepoint(const AName: String): String;
begin
  Result := 'ROLLBACK TO SAVEPOINT ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysASACommandGenerator.GetCall(const AName: String): String;
begin
  Result := 'CALL ' + AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysASACommandGenerator.GetPing: String;
begin
  Result := 'SELECT 1';
end;

{-------------------------------------------------------------------------------}
function TADPhysASACommandGenerator.GetLimitSelect(const ASQL: String;
  ASkip, ARows: Integer): String;
begin
  if (FConnMeta.ServerVersion >= cvSybaseASA9) and (ASkip > 0) then
    Result := 'SELECT TOP ' + IntToStr(ARows) + ' START AT ' + IntToStr(ASkip + 1) +
      ' * FROM (' + BRK + ASQL + BRK + ') A'
  else
    Result := inherited GetLimitSelect(ASQL, ASkip, ARows);
end;

end.
