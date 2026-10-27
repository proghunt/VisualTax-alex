{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{             FireDAC DBX 4 Bridge metadata             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysTDBXMeta;

interface

uses
  Classes,
  uADStanIntf,
  uADPhysIntf, uADPhysManager, uADPhysConnMeta, uADPhysTDBX;

type
  TADPhysTDBXMetadata = class (TADPhysConnectionMetadata)
  private
    FTxSupported: Boolean;
    FTxNested: Boolean;
    FNameQuoteChar: Char;
    FNameQuoteChar1: Char;
    FNameQuoteChar2: Char;
    FDefLowerCase: Boolean;
    FDefUpperCase: Boolean;
    FNameParts: TADPhysNameParts;
  protected
    function GetTxSupported: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameCaseSensParts: TADPhysNameParts; override;
    function GetNameDefLowCaseParts: TADPhysNameParts; override;
    function GetColumnOriginProvided: Boolean; override;
  public
    constructor Create(const AConnection: TADPhysConnection;
      const ACSVKeywords: String);
  end;

implementation

uses
  SysUtils,
  DBXCommon,
    DBXMetaDataWriterFactory, DBXMetaDataWriter, DbxMetaDataProvider,
{$IFNDEF AnyDAC_D15}
    DbxDataStoreMetaData,
{$ENDIF}
    DbxInterbaseMetaData,
{$IFNDEF NEXTGEN}
  {$IFNDEF AnyDAC_Mobile}
    DbxMySqlMetaData,
  {$ENDIF}
  {$IFNDEF AnyDAC_ProSKU}
    DbxOracleMetaData, DbxSybaseASAMetaData, DbxInformixMetaData,
    {$IFNDEF AnyDAC_POSIX}
    DbxMsSqlMetaData, DbxSybaseASEMetaData, DbxDb2MetaData,
    {$ENDIF}
    {$IFDEF AnyDAC_D14}
    DBXFirebirdMetaData,
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  uADStanUtil;

{-------------------------------------------------------------------------------}
{ TADPhysTDBXMetadata                                                           }
{-------------------------------------------------------------------------------}
constructor TADPhysTDBXMetadata.Create(const AConnection: TADPhysConnection;
  const ACSVKeywords: String);
{$IFDEF AnyDAC_D12}
type
  TDBXDatabaseMetaDataEx = TDBXDatabaseMetaData;
  TDBXConnectionEx = TDBXConnection;
{$ENDIF}
var
  oDbxConn: TDBXConnection;
  oDbxMeta: TDBXDatabaseMetaData;
  oDbxMetaWrtr: TDBXMetaDataWriter;
  ws: TADWideString;
  iClntVer: TADVersion;
begin
  oDbxConn := TDBXConnection(AConnection.CliObj);
  oDbxMeta := oDbxConn.DatabaseMetaData;
  if oDbxConn is TDBXConnectionEx then
    iClntVer := ADVerStr2Int(TDBXConnectionEx(oDbxConn).ProductVersion)
  else
    iClntVer := 0;
  FNameQuoteChar := #0;
  FNameQuoteChar1 := #0;
  FNameQuoteChar2 := #0;
  if oDbxMeta is TDBXDatabaseMetaDataEx then begin
    ws := TDBXDatabaseMetaDataEx(oDbxMeta).QuotePrefix;
    if Length(ws) <> 0 then
      FNameQuoteChar1 := Char(ws[1]);
    ws := TDBXDatabaseMetaDataEx(oDbxMeta).QuoteSuffix;
    if Length(ws) <> 0 then
      FNameQuoteChar2 := Char(ws[1]);
    FDefLowerCase := TDBXDatabaseMetaDataEx(oDbxMeta).SupportsLowerCaseIdentifiers;
    FDefUpperCase := TDBXDatabaseMetaDataEx(oDbxMeta).SupportsUpperCaseIdentifiers;
  end
  else begin
    ws := oDbxMeta.QuoteChar;
    if Length(ws) <> 0 then
      FNameQuoteChar := Char(ws[1]);
    FDefLowerCase := not (npObject in inherited GetNameCaseSensParts) and
      (npObject in inherited GetNameDefLowCaseParts);
    FDefUpperCase := not (npObject in inherited GetNameCaseSensParts) and
      not (npObject in inherited GetNameDefLowCaseParts);
  end;
  FTxSupported := oDbxMeta.SupportsTransactions;
  FTxNested := oDbxMeta.SupportsNestedTransactions;
  // most likely DBMS support schemas
  FNameParts := [npSchema, npBaseObject, npObject];
  if oDbxConn is TDBXConnectionEx then begin
    try
      oDbxMetaWrtr := TDBXMetaDataWriterFactory.CreateWriter(TDBXConnectionEx(oDbxConn).ProductName);
    except
      // no visible exception, if metadata is not registered
      oDbxMetaWrtr := nil;
    end;
    if oDbxMetaWrtr <> nil then begin
      FNameParts := [npBaseObject, npObject];
      if oDbxMetaWrtr.CatalogsSupported then
        Include(FNameParts, npCatalog);
      if oDbxMetaWrtr.SchemasSupported then
        Include(FNameParts, npSchema);
      ADFreeAndNil(oDbxMetaWrtr);
    end;
  end;
  inherited Create(AConnection, 0, iClntVer, False);
  if ACSVKeywords <> '' then
    FKeywords.CommaText := ACSVKeywords;
  ConfigNameParts;
  ConfigQuoteChars;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetTxNested: Boolean;
begin
  Result := FTxNested;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetTxSupported: Boolean;
begin
  Result := FTxSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
  ASide: TADPhysNameQuoteSide): Char;
begin
  Result := #0;
  if AQuote = ncDefault then
    if FNameQuoteChar <> #0 then
      Result := FNameQuoteChar
    else if ASide = nsLeft then
      Result := FNameQuoteChar1
    else
      Result := FNameQuoteChar2;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := FNameParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  if not FDefLowerCase and not FDefUpperCase then
    Result := [npBaseObject, npObject]
  else
    Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  if FDefLowerCase then
    Result := [npBaseObject, npObject]
  else
    Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysTDBXMetadata.GetColumnOriginProvided: Boolean;
begin
  Result := False;
end;

end.
