{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{              FireDAC MS Access metadata               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysMSAccMeta;

interface

uses
  Classes,
  uADStanIntf,
  uADPhysIntf, uADPhysConnMeta, uADPhysCmdGenerator, uADPhysManager;

type
  TADPhysMSAccMetadata = class (TADPhysConnectionMetadata)
  protected
    function GetKind: TADRDBMSKind; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; override;
    function GetTruncateSupported: Boolean; override;
    function GetIdentityInsertSupported: Boolean; override;
    function GetIdentityInWhere: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetAsyncAbortSupported: Boolean; override;
    function InternalEscapeBoolean(const AStr: String): String; override;
    function InternalEscapeDate(const AStr: String): String; override;
    function InternalEscapeDateTime(const AStr: String): String; override;
    function InternalEscapeFloat(const AStr: String): String; override;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; override;
    function InternalEscapeTime(const AStr: String): String; override;
    function InternalEscapeEscape(AEscape: Char; const AStr: String): String; override;
    function InternalGetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind; override;
  public
    constructor Create(const AConnectionObj: TADPhysConnection;
      AServerVersion, AClientVersion: TADVersion; const ACSVKeywords: String);
  end;

  TADPhysMSAccCommandGenerator = class(TADPhysCommandGenerator)
  protected
    function GetIdentity(ASessionScope: Boolean): String; override;
    function GetPing: String; override;
  end;

implementation

uses
  SysUtils,
  uADStanConst, uADStanUtil, uADStanOption,
  uADDatSManager;

{-------------------------------------------------------------------------------}
{ TADPhysMSAccMetadata                                                          }
{-------------------------------------------------------------------------------}
constructor TADPhysMSAccMetadata.Create(const AConnectionObj: TADPhysConnection;
  AServerVersion, AClientVersion: TADVersion; const ACSVKeywords: String);
begin
  inherited Create(AConnectionObj, AServerVersion, AClientVersion, True);
  if ACSVKeywords <> '' then
    FKeywords.CommaText := ACSVKeywords + ',PASSWORD';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkMSAccess;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 30;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
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
    Result := '"';
  ncThird:
    Result := '`';
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetTruncateSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetIdentityInsertSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetIdentityInWhere: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDefVals;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeBoolean(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := 'DATEVALUE(' + AnsiQuotedStr(AStr, '''') + ')';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := 'CDATE(' + AnsiQuotedStr(AStr, '''') + ')';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := 'TIMEVALUE(' + AnsiQuotedStr(AStr, '''') + ')';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
var
  i: Integer;
  sEnd: String;
  A1, A2, A3, A4: String;

  function Intv2Acc(AIntv: String): String;
  begin
    AIntv := UpperCase(ADUnquote(Trim(AIntv), ''''));
    if AIntv = 'YEAR' then
      Result := '''yyyy'''
    else if AIntv = 'QUARTER' then
      Result := '''Q'''
    else if AIntv = 'MONTH' then
      Result := '''m'''
    else if AIntv = 'WEEK' then
      Result := '''ww'''
    else if AIntv = 'DAY' then
      Result := '''d'''
    else if AIntv = 'HOUR' then
      Result := '''H'''
    else if AIntv = 'MINUTE' then
      Result := '''N'''
    else if AIntv = 'SECOND' then
      Result := '''S'''
    else
      UnsupportedEscape(ASeq);
  end;

begin
  if Length(ASeq.FArgs) >= 1 then begin
    A1 := ASeq.FArgs[0];
    if Length(ASeq.FArgs) >= 2 then begin
      A2 := ASeq.FArgs[1];
      if Length(ASeq.FArgs) >= 3 then begin
        A3 := ASeq.FArgs[2];
        if Length(ASeq.FArgs) >= 4 then
          A4 := ASeq.FArgs[3];
      end;
    end;
  end;
  case ASeq.FFunc of
  // the same
  // char
  efASCII,
  efCHAR,
  efLEFT,
  efLTRIM,
  efREPEAT,
  efRIGHT,
  efRTRIM,
  efSPACE,
  efSUBSTRING,
  efCONCAT,
  efLCASE,
  efLOCATE,
  efUCASE,
  // numeric
  efACOS,
  efASIN,
  efATAN,
  efABS,
  efCEILING,
  efCOS,
  efCOT,
  efEXP,
  efFLOOR,
  efLOG,
  efMOD,
  efPOWER,
  efROUND,
  efSIGN,
  efSIN,
  efSQRT,
  efTAN,
  efRANDOM,
  efATAN2,
  // date and time
  efCURDATE,
  efCURTIME,
  efNOW,
  efDAYNAME,
  efDAYOFMONTH,
  efDAYOFWEEK,
  efDAYOFYEAR,
  efHOUR,
  efMINUTE,
  efMONTH,
  efMONTHNAME,
  efQUARTER,
  efSECOND,
  efWEEK,
  efYEAR:         Result := '{fn ' + ASeq.FName + '(' + AddEscapeSequenceArgs(ASeq) + ')}';
  // system
  efIFNULL:       Result := 'IIF(' + A1 + ' IS NULL, ' + A2 + ', ' + A1 + ')';
  efIF:           Result := 'IIF(' + AddEscapeSequenceArgs(ASeq) + ')';
  efDECODE:
    begin
      i := 1;
      sEnd := '';
      Result := '';
      while i <= Length(ASeq.FArgs) - 2 do begin
        if i > 1 then
          Result := Result + ', ';
        Result := Result + 'IIF(' + A1 + ' = ' + ASeq.FArgs[i] +
          ', ' + ASeq.FArgs[i + 1];
        sEnd := sEnd + ')';
        Inc(i, 2);
      end;
      if i = Length(ASeq.FArgs) - 1 then begin
        if i > 1 then
          Result := Result + ', ';
        Result := Result + ASeq.FArgs[i];
      end;
      Result := Result + sEnd;
    end;
  // char
  efPOSITION:     Result := 'INSTR(1, ' + A2 + ', ' + A1 + ')';
  efBIT_LENGTH:   Result := '(LEN(' + A1 + ') * 8)';
  efCHAR_LENGTH,
  efLENGTH,
  efOCTET_LENGTH: Result := 'LEN(' + A1 + ')';
  efINSERT:       Result := 'MID(' + A1 + ', 1, ' + A2 + '- 1) & ' + A4 +
                    '& MID(' + A1 + ', (' + A2 + ') + (' + A3 + '), LEN(' + A1 + '))';
  efREPLACE:      Result := 'REPLACE(' + AddEscapeSequenceArgs(ASeq) + ')';
  // date and time
  efEXTRACT:      Result := 'DATEPART(' + Intv2Acc(A1) + ', ' + A2 + ')';
  efTIMESTAMPADD: Result := 'DATEADD(' + Intv2Acc(A1) + ', ' + A2 + ', ' + A3 + ')';
  efTIMESTAMPDIFF:Result := 'DATEDIFF(' + Intv2Acc(A1) + ', ' + A2 + ', ' + A3 + ')';
  // system
  efCATALOG:      Result := '{fn DATABASE()}';
  efSCHEMA:       Result := '{fn USER()';
  // numeric
  efPI:           Result := S_AD_Pi;
  efDEGREES:      Result := '(180 * (' + A1 + ') / ' + S_AD_Pi + ')';
  efRADIANS:      Result := '(' + S_AD_Pi + ' * (' + A1 + ') / 180)';
  efTRUNCATE:     Result := 'INT(' + A1 + ')';
  efLOG10:        Result := '(LOG(' + A1 + ') / LOG(10))';
  // convert
  efCONVERT:
    begin
      A2 := Trim(UpperCase(A2));
      if A2[1] = '''' then
        A2 := Copy(A2, 2, Length(A2) - 2);
      if A2 = 'CHAR' then
        A2 := 'VARCHAR';
      Result := '{fn CONVERT(' + A1 + ', SQL_' + A2 + ')}';
    end;
  else
    UnsupportedEscape(ASeq);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalEscapeEscape(AEscape: Char;
  const AStr: String): String;
var
  i: Integer;
begin
  Result := AStr;
  i := 1;
  while i <= Length(Result) do
    if Result[i] = AEscape then begin
      Result := Copy(Result, 1, i - 1) + '[' + Result[i + 1] + ']' +
        Copy(Result, i + 2, Length(Result));
      Inc(i, 3);
    end
    else
      Inc(i);
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccMetadata.InternalGetSQLCommandKind(
  const ATokens: TStrings): TADPhysCommandKind;
var
  sToken: String;
begin
  sToken := ATokens[0];
  if sToken = 'BEGIN' then
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
{ TADPhysMSAccCommandGenerator                                                  }
{-------------------------------------------------------------------------------}
function TADPhysMSAccCommandGenerator.GetIdentity(ASessionScope: Boolean): String;
begin
  Result := '@@IDENTITY';
end;

{-------------------------------------------------------------------------------}
function TADPhysMSAccCommandGenerator.GetPing: String;
begin
  Result := 'SELECT 1';
end;

end.
