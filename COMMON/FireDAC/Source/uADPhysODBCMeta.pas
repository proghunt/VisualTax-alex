{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                 FireDAC ODBC metadata                 }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysODBCMeta;

interface

uses
  Classes,
  uADStanIntf,
  uADPhysIntf, uADPhysManager, uADPhysConnMeta, uADPhysODBCBase,
    uADPhysODBCCli;

type
  __TADPhysConnectionMetadata = class(TADPhysConnectionMetadata)
  end;

  TADPhysODBCMetadata = class(TADPhysConnectionMetadata)
  private
    FNameMaxLength: Integer;
    FNameQuoteChar: Char;
    FNameQuoteChar1: Char;
    FNameQuoteChar2: Char;
    FTxNested: Boolean;
    FTxSupported: Boolean;
    FQuotedIdentifierCase: SQLUSmallint;
    FIdentifierCase: SQLUSmallint;
    FCatalogUsage: SQLUInteger;
    FSchemaUsage: SQLUInteger;
    FCancelSupported: Boolean;
    FCatalogSeparator: Char;
    FNullLocations: TADPhysNullLocations;
    FParentMeta: __TADPhysConnectionMetadata;
  protected
    function GetAsyncAbortSupported: Boolean; override;
    function GetCommandSeparator: String; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    function GetIdentityInsertSupported: Boolean; override;
    function GetInlineRefresh: Boolean; override;
    function GetKind: TADRDBMSKind; override;
    function GetLockNoWait: Boolean; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; override;
    function GetCatalogSeparator: Char; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetParamNameMaxLength: Integer; override;
    function GetSelectWithoutFrom: Boolean; override;
    function GetTruncateSupported: Boolean; override;
    function GetTxAutoCommit: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetTxSavepoints: Boolean; override;
    function GetTxSupported: Boolean; override;
    function GetLimitOptions: TADPhysLimitOptions; override;
    function GetNullLocation: TADPhysNullLocations; override;
    function GetColumnOriginProvided: Boolean; override;
    function InternalDecodeObjName(const AName: String;
      out AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand;
      ARaise: Boolean): Boolean; override;
    function InternalEncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand): String; override;
    function InternalGetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind; override;
    function TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String; override;
  public
    constructor Create(const AConnection: TADPhysConnection;
      AServerVersion, AClientVersion: TADVersion; AParentMeta: TADPhysConnectionMetadata);
    destructor Destroy; override;
  end;

implementation

uses
  SysUtils,
  uADStanConst, uADStanUtil,
  uADPhysODBCWrapper;

{------------------------------------------------------------------------------}
{ TADPhysODBCMetadata                                                          }
{------------------------------------------------------------------------------}
constructor TADPhysODBCMetadata.Create(const AConnection: TADPhysConnection;
  AServerVersion, AClientVersion: TADVersion; AParentMeta: TADPhysConnectionMetadata);
var
  C: String;
  oConn: TODBCConnection;
begin
  inherited Create(AConnection, AServerVersion, AClientVersion, False);
  FParentMeta := __TADPhysConnectionMetadata(AParentMeta);
  oConn := TODBCConnection(AConnection.CliObj);
  FTxSupported := oConn.TXN_CAPABLE <> SQL_TC_NONE;
  FTxNested := oConn.MULTIPLE_ACTIVE_TXN = 'Y';
  FNameMaxLength := oConn.MAX_COL_NAME_LEN;
  C := oConn.IDENTIFIER_QUOTE_CHAR;
  FNameQuoteChar := #0;
  FNameQuoteChar1 := #0;
  FNameQuoteChar2 := #0;
  if Length(C) = 2 then begin
    FNameQuoteChar1 := C[1];
    FNameQuoteChar2 := C[2];
  end
  else if Length(C) = 1 then
    FNameQuoteChar := C[1];
  C := oConn.CATALOG_NAME_SEPARATOR;
  if Length(C) = 1 then
    FCatalogSeparator := C[1]
  else
    FCatalogSeparator := #0;
  if oConn.DriverKind = dkElevateDB then begin
    FQuotedIdentifierCase := SQL_IC_SENSITIVE;
    FIdentifierCase := SQL_IC_SENSITIVE;
    FCatalogUsage := oConn.CATALOG_USAGE;
    FSchemaUsage := 0;
  end
  else begin
    FQuotedIdentifierCase := oConn.QUOTED_IDENTIFIER_CASE;
    FIdentifierCase := oConn.IDENTIFIER_CASE;
    FCatalogUsage := oConn.CATALOG_USAGE;
    FSchemaUsage := oConn.SCHEMA_USAGE;
  end;
  FCancelSupported := oConn.GetFunctions(SQL_API_SQLCANCEL) = SQL_TRUE;
  FKeywords.CommaText := oConn.KEYWORDS;
  case oConn.NULL_COLLATION of
  SQL_NC_START: FNullLocations := [nlAscFirst, nlDescFirst];
  SQL_NC_END:   FNullLocations := [nlAscLast, nlDescLast];
  SQL_NC_HIGH:  FNullLocations := [nlAscLast, nlDescFirst];
  SQL_NC_LOW:   FNullLocations := [nlAscFirst, nlDescLast];
  else          FNullLocations := inherited GetNullLocation;
  end;
  ConfigNameParts;
  ConfigQuoteChars;
end;

{------------------------------------------------------------------------------}
destructor TADPhysODBCMetadata.Destroy;
begin
  if FParentMeta <> nil then
    ADFreeAndNil(FParentMeta);
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := FCancelSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetCommandSeparator: String;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetCommandSeparator
  else
    Result := inherited GetCommandSeparator;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetDefValuesSupported
  else
    Result := inherited GetDefValuesSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetIdentityInsertSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetIdentityInsertSupported
  else
    Result := inherited GetIdentityInsertSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetInlineRefresh: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetInlineRefresh
  else
    Result := inherited GetInlineRefresh;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetKind: TADRDBMSKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetKind
  else
    Result := inherited GetKind;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetLockNoWait: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetLockNoWait
  else
    Result := inherited GetLockNoWait;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameCaseSensParts
  else if FIdentifierCase = SQL_IC_SENSITIVE then
    Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject]
  else
    Result := [];
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameDefLowCaseParts
  else if FIdentifierCase = SQL_IC_LOWER then
    Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject]
  else
    Result := [];
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameParts
  else begin
    Result := inherited GetNameParts;
    if FCatalogUsage and SQL_CU_DML_STATEMENTS = SQL_CU_DML_STATEMENTS then
      Include(Result, npCatalog);
    if FSchemaUsage and SQL_SU_DML_STATEMENTS = SQL_SU_DML_STATEMENTS then
      Include(Result, npSchema);
  end;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
  ASide: TADPhysNameQuoteSide): Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuoteChar(AQuote, ASide)
  else begin
    Result := #0;
    if AQuote = ncDefault then
      if FNameQuoteChar <> #0 then
        Result := FNameQuoteChar
      else if ASide = nsLeft then
        Result := FNameQuoteChar1
      else
        Result := FNameQuoteChar2;
  end;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetCatalogSeparator: Char;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetCatalogSeparator
  else
    Result := FCatalogSeparator;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNameQuotedCaseSensParts
  else if FQuotedIdentifierCase = SQL_IC_SENSITIVE then
    Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject]
  else
    Result := [];
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetParamNameMaxLength: Integer;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetParamNameMaxLength
  else
    Result := FNameMaxLength;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetSelectWithoutFrom: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSelectWithoutFrom
  else
    Result := inherited GetSelectWithoutFrom;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTruncateSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTruncateSupported
  else
    Result := inherited GetTruncateSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxAutoCommit: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxAutoCommit
  else
    Result := inherited GetTxAutoCommit;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxNested: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxNested
  else
    Result := FTxNested;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxSavepoints: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSavepoints
  else
    Result := inherited GetTxSavepoints;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetTxSupported: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetTxSupported
  else
    Result := FTxSupported;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetLimitOptions: TADPhysLimitOptions;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetLimitOptions
  else
    Result := inherited GetLimitOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetNullLocation: TADPhysNullLocations;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetNullLocation
  else
    Result := FNullLocations;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.GetColumnOriginProvided: Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetColumnOriginProvided
  else
    // This is pessimistic, but Informix does not provide origin table name.
    // If here will be True, then all Informix result sets will be ReadOnly.
    Result := False;
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.InternalDecodeObjName(const AName: String;
  out AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand;
  ARaise: Boolean): Boolean;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.InternalDecodeObjName(AName, AParsedName, ACommand, ARaise)
  else
    Result := inherited InternalDecodeObjName(AName, AParsedName, ACommand, ARaise);
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.InternalEncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand): String;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.InternalEncodeObjName(AParsedName, ACommand)
  else
    Result := inherited InternalEncodeObjName(AParsedName, ACommand);
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.InternalGetSQLCommandKind(const ATokens: TStrings):
  TADPhysCommandKind;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.GetSQLCommandKind(ATokens)
  else
    Result := inherited InternalGetSQLCommandKind(ATokens);
end;

{------------------------------------------------------------------------------}
function TADPhysODBCMetadata.TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String;
begin
  if FParentMeta <> nil then
    Result := FParentMeta.TranslateEscapeSequence(ASeq)
  else
    { TODO -cODBC : Translate from FireDAC to ODBC style }
    Result := inherited TranslateEscapeSequence(ASeq);
end;

end.

