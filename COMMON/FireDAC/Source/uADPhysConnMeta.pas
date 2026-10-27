{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{        FireDAC connection metadata base class         }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysConnMeta;

interface

uses
  Classes,
  uADStanIntf, uADDatSManager,
  uADPhysIntf, uADPhysManager;

type
  TADPhysConnectionMetadata = class (TInterfacedObject, IUnknown,
    IADPhysConnectionMetadata)
  private
    FMetadataCache: TADDatSManager;
    FMaximumNameParts: Integer;
    FNameParts: array of String;
    FServerVersion: TADVersion;
    FClientVersion: TADVersion;
    FIsUnicode: Boolean;
    FQuoteChars: TADByteSet;
    function UnQuoteBase(const AName: String; ACh1, ACh2: Char): String;
    function IsQuotedBase(const AName: String; ACh1, ACh2: Char): Boolean;
    function IsNameValid(const AName: String): Boolean;
    function IsNameQuoted(const AName: String): Boolean;
    function NormObjName(const AName: String; APart: TADPhysNamePart): String;
    function QuoteNameIfReq(const AName: String; APart: TADPhysNamePart): String;
    function IsRDBMSKind(const AStr: String; out ACurrent: Boolean): Boolean;
    function FetchNoCache(AMetaKind: TADPhysMetaInfoKind; AScope: TADPhysObjectScopes;
      AKinds: TADPhysTableKinds; const ACatalog, ASchema, ABaseObject, AWildCard: String;
      AOverload: Word): TADDatSTable;
    function CheckFetchToCache(AMetaKind: TADPhysMetaInfoKind; const AFilter: String;
      var ATable: TADDatSTable; var AView: TADDatSView): Boolean;
    procedure AddWildcard(AView: TADDatSView; const AColumn, AWildcard: String;
      APart: TADPhysNamePart);
    procedure FetchToCache(AMetaKind: TADPhysMetaInfoKind; const ACatalog, ASchema,
      ABaseObject, AObject: String; AOverload: Word; ADataTable: TADDatSTable);
    function DefineMetadataTableName(AKind: TADPhysMetaInfoKind): String;
    function GetCacheFilter(const ACatalog, ASchema, AObjField, AObj,
      ASubObjField, ASubObj: String): String;
    function ConvertNameCaseExpr(const AColumn, AValue: String; APart: TADPhysNamePart): String;
    function ConvertNameCaseConst(const AValue: String; APart: TADPhysNamePart): String;
    procedure ParseMetaInfoParams(const ACatalog, ASchema, ABaseObjName,
      AObjName: String; out AParsedName: TADPhysParsedName);
  protected
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FConnectionObj: TADPhysConnection;
    FKeywords: TADStringList;
    FCISearch: Boolean;
    // IUnknown
    function _AddRef: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    function _Release: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    // IADPhysConnectionMetadata
    function GetKind: TADRDBMSKind; virtual;
    function GetClientVersion: TADVersion; virtual;
    function GetServerVersion: TADVersion; virtual;
    function GetIsUnicode: Boolean; virtual;
    function GetIsFileBased: Boolean; virtual;
    function GetTxSupported: Boolean; virtual;
    function GetTxNested: Boolean; virtual;
    function GetTxMultiple: Boolean; virtual;
    function GetTxSavepoints: Boolean; virtual;
    function GetTxAutoCommit: Boolean; virtual;
    function GetTxAtomic: Boolean; virtual;
    function GetEventSupported: Boolean; virtual;
    function GetEventKinds: String; virtual;
    function GetGeneratorSupported: Boolean; virtual;
    function GetParamNameMaxLength: Integer; virtual;
    function GetNameParts: TADPhysNameParts; virtual;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; virtual;
    function GetNameQuotedCaseSens(const AName: String; APart: TADPhysNamePart): Boolean; virtual;
    function GetNameCaseSensParts: TADPhysNameParts; virtual;
    function GetNameDefLowCaseParts: TADPhysNameParts; virtual;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; virtual;
    function GetCatalogSeparator: Char; virtual;
    function GetSchemaSeparator: Char; virtual;
    function GetInsertHBlobMode: TADPhysInsertHBlobMode; virtual;
    function GetIdentitySupported: Boolean; virtual;
    function GetIdentityInsertSupported: Boolean; virtual;
    function GetIdentityInWhere: Boolean; virtual;
    function GetNamedParamMark: TADPhysParamMark; virtual;
    function GetPositionedParamMark: TADPhysParamMark; virtual;
    function GetSelectWithoutFrom: Boolean; virtual;
    function GetLockNoWait: Boolean; virtual;
    function GetAsyncAbortSupported: Boolean; virtual;
    function GetCommandSeparator: String; virtual;
    function GetLineSeparator: TADTextEndOfLine; virtual;
    function GetArrayExecMode: TADPhysArrayExecMode; virtual;
    function GetLimitOptions: TADPhysLimitOptions; virtual;
    function GetNullLocation: TADPhysNullLocations; virtual;
    function GetServerCursorSupported: Boolean; virtual;
    function GetColumnOriginProvided: Boolean; virtual;
    function DecodeObjName(const AName: String; out AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysDecodeOptions): Boolean;
    function EncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysEncodeOptions): String;
    function QuoteObjName(const AName: String): String;
    function UnQuoteObjName(const AName: String): String;
    function IsKeyword(const AName: String): Boolean;
    function TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String; virtual;
    function GetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind;
    function GetTruncateSupported: Boolean; virtual;
    function GetDefValuesSupported: TADPhysDefaultValues; virtual;
    function GetInlineRefresh: Boolean; virtual;
    function GetCatalogs(const AWildCard: String): TADDatSView; virtual;
    function GetSchemas(const ACatalog, AWildCard: String): TADDatSView; virtual;
    function GetTables(AScope: TADPhysObjectScopes; AKinds: TADPhysTableKinds;
      const ACatalog, ASchema, AWildCard: String): TADDatSView; virtual;
    function GetTableFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView; virtual;
    function GetTableIndexes(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView; virtual;
    function GetTableIndexFields(const ACatalog, ASchema, ATable, AIndex, AWildCard: String): TADDatSView; virtual;
    function GetTablePrimaryKey(const ACatalog, ASchema, ATable: String): TADDatSView; virtual;
    function GetTablePrimaryKeyFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView; virtual;
    function GetTableForeignKeys(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetTableForeignKeyFields(const ACatalog, ASchema, ATable, AForeignKey, AWildCard: String): TADDatSView;
    function GetPackages(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView; virtual;
    function GetPackageProcs(const ACatalog, ASchema, APackage, AWildCard: String): TADDatSView; virtual;
    function GetProcs(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView; virtual;
    function GetProcArgs(const ACatalog, ASchema, APackage, AProc, AWildCard: String; AOverload: Word): TADDatSView; virtual;
    function GetGenerators(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView; virtual;
    function GetResultSetFields(const ASQLKey: String): TADDatSView; virtual;
    procedure DefineMetadataStructure(ATable: TADDatSTable; AKind: TADPhysMetaInfoKind); virtual;
    procedure RefreshMetadataCache(const AObjName: String = '');
    // other
    function InternalEncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand): String; virtual;
    function InternalDecodeObjName(const AName: String;
      out AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand;
      ARaise: Boolean): Boolean; virtual;
    procedure InternalOverrideNameByCommand(var AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand); virtual;
    function InternalEscapeBoolean(const AStr: String): String; virtual;
    function InternalEscapeDate(const AStr: String): String; virtual;
    function InternalEscapeDateTime(const AStr: String): String; virtual;
    function InternalEscapeFloat(const AStr: String): String; virtual;
    function InternalEscapeFunction(const ASeq: TADPhysEscapeData): String; virtual;
    function InternalEscapeTime(const AStr: String): String; virtual;
    function InternalEscapeEscape(AEscape: Char; const AStr: String): String; virtual;
    function InternalEscapeInto(const AStr: String): String; virtual;
    function InternalEscapeString(const AStr: String): String; virtual;
    function InternalGetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind; virtual;
    // utility
    procedure UnsupportedEscape(const ASeq: TADPhysEscapeData);
    procedure EscapeFuncToID(var ASeq: TADPhysEscapeData);
    function AddEscapeSequenceArgs(const ASeq: TADPhysEscapeData): String;
    procedure ConfigNameParts;
    procedure ConfigQuoteChars;
    procedure AddMetadataCol(ATable: TADDatSTable; const AName: String;
      AType: TADDataType);
  public
    constructor Create(const AConnectionObj: TADPhysConnection;
      AServerVersion, AClientVersion: TADVersion; AIsUnicode: Boolean);
    destructor Destroy; override;
  end;

implementation

uses
{$IFDEF MSWINDOWS}
  // Preventing from "Inline has not expanded"
  Windows,
{$ENDIF}
  SysUtils,
  uADStanError, uADStanConst, uADStanUtil, uADStanOption;

{-------------------------------------------------------------------------------}
{ TADPhysConnectionMetadata                                                     }
{-------------------------------------------------------------------------------}
constructor TADPhysConnectionMetadata.Create(const AConnectionObj: TADPhysConnection;
  AServerVersion, AClientVersion: TADVersion; AIsUnicode: Boolean);
begin
  inherited Create;
  FConnectionObj := AConnectionObj;
  FKeywords := TADStringList.Create;
  FKeywords.Sorted := True;
  FKeywords.Duplicates := dupAccept;
{$IFDEF AnyDAC_D7}
  FKeywords.CaseSensitive := False;
{$ENDIF}
  FKeywords.CommaText :=
    'ABSOLUTE,ACTION,ADA,ADD,ALL,ALLOCATE,ALTER,AND,ANY,ARE,AS,' +
    'ASC,ASSERTION,AT,AUTHORIZATION,AVG,' +
    'BEGIN,BETWEEN,BIT,BIT_LENGTH,BOTH,BY,CASCADE,CASCADED,CASE,CAST,CATALOG,' +
    'CHAR,CHAR_LENGTH,CHARACTER,CHARACTER_LENGTH,CHECK,CLOSE,COALESCE,' +
    'COLLATE,COLLATION,COLUMN,COMMIT,CONNECT,CONNECTION,CONSTRAINT,' +
    'CONSTRAINTS,CONTINUE,CONVERT,CORRESPONDING,COUNT,CREATE,CROSS,CURRENT,' +
    'CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,' +
    'DATE,DAY,DEALLOCATE,DEC,DECIMAL,DECLARE,DEFAULT,DEFERRABLE,' +
    'DEFERRED,DELETE,DESC,DESCRIBE,DESCRIPTOR,DIAGNOSTICS,DISCONNECT,' +
    'DISTINCT,DOMAIN,DOUBLE,DROP,' +
    'ELSE,END,END-EXEC,ESCAPE,EXCEPT,EXCEPTION,EXEC,EXECUTE,' +
    'EXISTS,EXTERNAL,EXTRACT,' +
    'FALSE,FETCH,FIRST,FLOAT,FOR,FOREIGN,FORTRAN,FOUND,FROM,FULL,' +
    'GET,GLOBAL,GO,GOTO,GRANT,GROUP,HAVING,HOUR,' +
    'IDENTITY,IMMEDIATE,IN,INCLUDE,INDEX,INDICATOR,INITIALLY,INNER,' +
    'INPUT,INSENSITIVE,INSERT,INT,INTEGER,INTERSECT,INTERVAL,INTO,IS,ISOLATION,' +
    'JOIN,KEY,LANGUAGE,LAST,LEADING,LEFT,LEVEL,LIKE,LOCAL,LOWER,' +
    'MATCH,MAX,MIN,MINUTE,MODULE,MONTH,' +
    'NAMES,NATIONAL,NATURAL,NCHAR,NEXT,NO,NONE,NOT,NULL,NULLIF,NUMERIC,' +
    'OCTET_LENGTH,OF,ON,ONLY,OPEN,OPTION,OR,ORDER,OUTER,OUTPUT,OVERLAPS,' +
    'PAD,PARTIAL,PASCAL,PLI,POSITION,PRECISION,PREPARE,PRESERVE,' +
    'PRIMARY,PRIOR,PRIVILEGES,PROCEDURE,PUBLIC,' +
    'READ,REAL,REFERENCES,RELATIVE,RESTRICT,REVOKE,RIGHT,ROLLBACK,ROWS' +
    'SCHEMA,SCROLL,SECOND,SECTION,SELECT,SESSION,SESSION_USER,SET,SIZE,' +
    'SMALLINT,SOME,SPACE,SQL,SQLCA,SQLCODE,SQLERROR,SQLSTATE,SQLWARNING,' +
    'SUBSTRING,SUM,SYSTEM_USER,' +
    'TABLE,TEMPORARY,THEN,TIME,TIMESTAMP,TIMEZONE_HOUR,TIMEZONE_MINUTE,' +
    'TO,TRAILING,TRANSACTION,TRANSLATE,TRANSLATION,TRIM,TRUE,' +
    'UNION,UNIQUE,UNKNOWN,UPDATE,UPPER,USAGE,USER,USING,' +
    'VALUE,VALUES,VARCHAR,VARYING,VIEW,WHEN,WHENEVER,WHERE,WITH,WORK,WRITE,' +
    'YEAR,ZONE';
  ConfigNameParts;
  ConfigQuoteChars;
  FServerVersion := AServerVersion;
  FClientVersion := AClientVersion;
  FIsUnicode := AIsUnicode;
  FCISearch := (FConnectionObj <> nil) and
    FConnectionObj.ConnectionDef.AsBoolean[S_AD_ConnParam_Common_MetaCaseIns];
end;

{-------------------------------------------------------------------------------}
destructor TADPhysConnectionMetadata.Destroy;
begin
  FConnectionObj := nil;
  ADFreeAndNil(FMetadataCache);
  ADFreeAndNil(FKeywords);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata._AddRef: Integer;
begin
  if FConnectionObj = nil then
    Result := inherited _AddRef
  else
    Result := FConnectionObj._AddRef;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata._Release: Integer;
begin
  if FConnectionObj = nil then
    Result := inherited _Release
  else
    Result := FConnectionObj._Release;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.ConfigNameParts;
var
  i: TADPhysNamePart;
begin
  FMaximumNameParts := 0;
  for i := Low(TADPhysNamePart) to High(TADPhysNamePart) do
    if (i <> npDBLink) and (i in GetNameParts) then
      Inc(FMaximumNameParts);
  SetLength(FNameParts, FMaximumNameParts);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.ConfigQuoteChars;
var
  eQuote: TADPhysNameQuoteLevel;
begin
  FQuoteChars := [];
  for eQuote := Low(TADPhysNameQuoteLevel) to High(TADPhysNameQuoteLevel) do begin
    Include(FQuoteChars, Byte(GetNameQuoteChar(eQuote, nsLeft)));
    Include(FQuoteChars, Byte(GetNameQuoteChar(eQuote, nsRight)));
  end;
  Exclude(FQuoteChars, 0);
  Exclude(FQuoteChars, Byte(' '));
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.UnQuoteBase(const AName: String; ACh1, ACh2: Char): String;
begin
  if IsQuotedBase(AName, ACh1, ACh2) then
    Result := Copy(AName, 2, Length(AName) - 2)
  else
    Result := AName;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.UnQuoteObjName(const AName: String): String;
var
  eQuote: TADPhysNameQuoteLevel;
begin
  for eQuote := Low(TADPhysNameQuoteLevel) to High(TADPhysNameQuoteLevel) do begin
    Result := UnQuoteBase(AName, GetNameQuoteChar(eQuote, nsLeft), GetNameQuoteChar(eQuote, nsRight));
    if Result <> AName then
      Break;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsQuotedBase(const AName: String; ACh1, ACh2: Char): Boolean;
begin
  Result :=
    (Length(AName) > 2) and
    not ADInSet(ACh1, [#0, ' ']) and not ADInSet(ACh2, [#0, ' ']) and
    (AName[1] = ACh1) and (AName[Length(AName)] = ACh2);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsNameQuoted(const AName: String): Boolean;
var
  eQuote: TADPhysNameQuoteLevel;
begin
  if not ((Length(AName) > 2) and (Byte(AName[1]) in FQuoteChars)) then
    Result := False
  else
    for eQuote := Low(TADPhysNameQuoteLevel) to High(TADPhysNameQuoteLevel) do begin
      Result := IsQuotedBase(AName, GetNameQuoteChar(eQuote, nsLeft), GetNameQuoteChar(eQuote, nsRight));
      if Result then
        Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsNameValid(const AName: String): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AName) do
    if not ((i = 1) and ADInSet(AName[i], ['a' .. 'z', 'A' .. 'Z', '_']) or
            (i > 1) and ADInSet(AName[i], ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '$', '#'])) then begin
      Result := False;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameQuotedCaseSens(const AName: String;
  APart: TADPhysNamePart): Boolean;
begin
  Result := APart in GetNameQuotedCaseSensParts;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.NormObjName(const AName: String; APart: TADPhysNamePart): String;
begin
  Result := AName;
  if Result <> '' then
    if not IsNameQuoted(Result) then
      if APart in GetNameCaseSensParts then begin
        // QwQw -> QwQw
        // Q w Q w -> "Q w Q w"
        // "Q w Q w" -> "Q w Q w"
        // SELECT -> "SELECT"
        if not IsNameValid(Result) or IsKeyword(Result) then
          Result := QuoteObjName(Result);
      end
      else begin
        // QwQw -> QWQW | qwqw
        // Q w Q w -> "Q W Q W" | "q w q w"
        // "Q w Q w" -> "Q w Q w"
        // SELECT -> "SELECT"
        if APart in GetNameDefLowCaseParts then
          Result := AnsiLowerCase(Result)
        else
          Result := AnsiUpperCase(Result);
        if not IsNameValid(Result) or IsKeyword(Result) then
          Result := QuoteObjName(Result);
      end
    else if not GetNameQuotedCaseSens(AName, APart) then
      if APart in GetNameDefLowCaseParts then
        Result := AnsiLowerCase(Result)
      else
        Result := AnsiUpperCase(Result);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.QuoteObjName(const AName: String): String;
var
  eQuote: TADPhysNameQuoteLevel;
  ch1, ch2: Char;
begin
  Result := AName;
  if (Result <> '') and not IsNameQuoted(Result) then
    for eQuote := Low(TADPhysNameQuoteLevel) to High(TADPhysNameQuoteLevel) do begin
      ch1 := GetNameQuoteChar(eQuote, nsLeft);
      ch2 := GetNameQuoteChar(eQuote, nsRight);
      if not ADInSet(ch1, [#0, ' ']) and not ADInSet(ch2, [#0, ' ']) and
         (StrScan(PChar(AName), ch1) = nil) and (StrScan(PChar(AName), ch2) = nil) then begin
        Result := ch1 + Result + ch2;
        Break;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.QuoteNameIfReq(const AName: String; APart: TADPhysNamePart): String;
begin
  Result := AName;
  if (AName <> '') and not IsNameQuoted(AName) then
    if not IsNameValid(AName) or IsKeyword(AName) then
      Result := QuoteObjName(AName)
    else if not (APart in GetNameCaseSensParts) and GetNameQuotedCaseSens(AName, APart) then begin
      if APart in GetNameDefLowCaseParts then
        Result := AnsiLowerCase(AName)
      else
        Result := AnsiUpperCase(AName);
      if Result <> AName then
        Result := QuoteObjName(AName);
    end;
end;

{-------------------------------------------------------------------------------}
type
  __TADPhysConnection = class(TADPhysConnection)
  end;

procedure TADPhysConnectionMetadata.InternalOverrideNameByCommand(
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand);
var
  rBaseName: TADPhysParsedName;
begin
  if AParsedName.FCatalog = '' then
    AParsedName.FCatalog := ACommand.CatalogName;
  if AParsedName.FSchema = '' then
    AParsedName.FSchema := ACommand.SchemaName;
  if AParsedName.FBaseObject = '' then begin
    AParsedName.FBaseObject := ACommand.BaseObjectName;
    if (Pos(GetCatalogSeparator, AParsedName.FBaseObject) <> 0) or
       (Pos(GetSchemaSeparator, AParsedName.FBaseObject) <> 0) then begin
      InternalDecodeObjName(AParsedName.FBaseObject, rBaseName, ACommand, True);
      if rBaseName.FCatalog <> '' then
        AParsedName.FCatalog := rBaseName.FCatalog;
      if rBaseName.FSchema <> '' then
        AParsedName.FSchema := rBaseName.FSchema;
      if rBaseName.FObject <> '' then
        AParsedName.FBaseObject := rBaseName.FObject;
    end;
  end;
  if FConnectionObj <> nil then
    __TADPhysConnection(FConnectionObj).
      InternalOverrideNameByCommand(AParsedName, ACommand);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalDecodeObjName(const AName: String;
  out AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand;
  ARaise: Boolean): Boolean;
var
  lWasLink, lWasCat: Boolean;
  iStName, i, iPart, nParts: Integer;
  c, cQuote1, cQuote2, cCatDelim, cSchDelim: Char;
  eParts: TADPhysNameParts;
  eQuote: TADPhysNameQuoteLevel;
  eInQuotes: TADPhysNameQuoteLevels;

  procedure ClearName;
  begin
    AParsedName.FCatalog := '';
    AParsedName.FSchema := '';
    AParsedName.FBaseObject := '';
    AParsedName.FObject := '';
    AParsedName.FLink := '';
  end;

  procedure Error;
  begin
    Result := False;
    ClearName;
    if ARaise then
      ADException(Self, [S_AD_LPhys], er_AD_AccNameHasErrors, [AName]);
  end;

  procedure ExtractNamePart;
  begin
    if (iPart + 1 > FMaximumNameParts) or (i - iStName < 0) then
      Error
    else begin
      FNameParts[iPart] := Trim(Copy(AName, iStName, i - iStName));
      Inc(iPart);
    end;
  end;

  function NextPart: String;
  begin
    if iPart > 0 then begin
      Dec(iPart);
      Result := FNameParts[iPart];
    end;
  end;

begin
  Result := True;
  ClearName;
  if AName = '' then
    Exit;

  eParts := GetNameParts;
  cCatDelim := GetCatalogSeparator;
  cSchDelim := GetSchemaSeparator;
  eInQuotes := [];
  lWasLink := False;
  lWasCat := False;
  iStName := 1;
  iPart := 0;
  i := 1;
  while i <= Length(AName) do begin
    c := AName[i];
    if (Byte(c) in FQuoteChars) then
      for eQuote := Low(TADPhysNameQuoteLevel) to High(TADPhysNameQuoteLevel) do begin
        cQuote1 := GetNameQuoteChar(eQuote, nsLeft);
        cQuote2 := GetNameQuoteChar(eQuote, nsRight);
        if c = cQuote1 then begin
          if (eInQuotes = [eQuote]) or (eInQuotes = []) then
            if cQuote1 = cQuote2 then
              if eQuote in eInQuotes then
                Exclude(eInQuotes, eQuote)
              else
                Include(eInQuotes, eQuote)
            else if not (eQuote in eInQuotes) then
              Include(eInQuotes, eQuote);
          Break;
        end
        else if c = cQuote2 then begin
          if eInQuotes = [eQuote] then
            Exclude(eInQuotes, eQuote);
          Break;
        end;
      end
    else if (c = cCatDelim) and (npCatalog in eParts) or
            (c = cSchDelim) and (npSchema in eParts) then begin
      if eInQuotes = [] then begin
        ExtractNamePart;
        if not Result then
          Exit;
        iStName := i + 1;
        if (c = cCatDelim) and (cCatDelim <> cSchDelim) then
          lWasCat := True;
      end;
    end
    else if c = '@' then begin
      if eInQuotes = [] then begin
        ExtractNamePart;
        if not Result then
          Exit;
        AParsedName.FLink := Copy(AName, i + 1, Length(AName));
        lWasLink := True;
        Break;
      end;
    end;
    Inc(i);
  end;

  if not lWasLink then begin
    ExtractNamePart;
    if not Result then
      Exit;
  end;
  if eInQuotes <> [] then begin
    Error;
    Exit;
  end;

  nParts := iPart;
  AParsedName.FObject := NextPart;
  if nParts = FMaximumNameParts then
    AParsedName.FBaseObject := NextPart;
  if (npSchema in eParts) and ((iPart >= 2) or not lWasCat) then
    AParsedName.FSchema := NextPart;
  if npCatalog in eParts then
    AParsedName.FCatalog := NextPart;
  if iPart <> 0 then
    Error;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.DecodeObjName(const AName: String;
  out AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand;
  AOpts: TADPhysDecodeOptions): Boolean;
begin
  if not (doSubObj in AOpts) then begin
    Result := InternalDecodeObjName(AName, AParsedName, ACommand, not (doNotRaise in AOpts));
    if not Result then
      Exit;
    if ACommand <> nil then
      InternalOverrideNameByCommand(AParsedName, ACommand);
    if doNormalize in AOpts then begin
      AParsedName.FCatalog := NormObjName(AParsedName.FCatalog, npCatalog);
      AParsedName.FSchema := NormObjName(AParsedName.FSchema, npSchema);
      AParsedName.FBaseObject := NormObjName(AParsedName.FBaseObject, npBaseObject);
      AParsedName.FObject := NormObjName(AParsedName.FObject, npObject);
    end;
    if doUnquote in AOpts then begin
      AParsedName.FCatalog := UnQuoteObjName(AParsedName.FCatalog);
      AParsedName.FSchema := UnQuoteObjName(AParsedName.FSchema);
      AParsedName.FBaseObject := UnQuoteObjName(AParsedName.FBaseObject);
      AParsedName.FObject := UnQuoteObjName(AParsedName.FObject);
    end;
    if not (doMetaParams in AOpts) and (AParsedName.FBaseObject = '') and
           (AParsedName.FObject = '') then begin
      AParsedName.FCatalog := '';
      AParsedName.FSchema := '';
      AParsedName.FLink := '';
    end;
  end
  else begin
    Result := True;
    AParsedName.FCatalog := '';
    AParsedName.FSchema := '';
    AParsedName.FLink := '';
    AParsedName.FBaseObject := '';
    AParsedName.FObject := AName;
    if doNormalize in AOpts then
      AParsedName.FObject := NormObjName(AParsedName.FObject, npObject);
    if doUnquote in AOpts then
      AParsedName.FObject := UnQuoteObjName(AParsedName.FObject);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand): String;
var
  eParts: TADPhysNameParts;
  lWasCat: Boolean;
  iLen: Integer;
begin
  Result := '';
  eParts := GetNameParts;

  lWasCat := False;
  if (npCatalog in eParts) and (AParsedName.FCatalog <> '') then begin
    Result := Result + AParsedName.FCatalog + GetCatalogSeparator;
    lWasCat := True;
  end;
  if (npSchema in eParts) and (lWasCat and (GetCatalogSeparator = GetSchemaSeparator) or
                              (AParsedName.FSchema <> '')) then
    Result := Result + AParsedName.FSchema + GetSchemaSeparator;
  if (npBaseObject in eParts) and (AParsedName.FBaseObject <> '') then
    Result := Result + AParsedName.FBaseObject + GetSchemaSeparator;
  if (npObject in eParts) and (AParsedName.FObject <> '') then
    Result := Result + AParsedName.FObject + GetSchemaSeparator;

  if Result <> '' then begin
    iLen := Length(Result);
    while (iLen > 0) and ((Result[iLen] = GetSchemaSeparator) or
                          (Result[iLen] = GetCatalogSeparator)) do
      Dec(iLen);
    SetLength(Result, iLen);
  end;

  if (npDBLink in eParts) and (AParsedName.FLink <> '') then
    Result := Result + '@' + AParsedName.FLink;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.EncodeObjName(const AParsedName: TADPhysParsedName;
  const ACommand: IADPhysCommand; AOpts: TADPhysEncodeOptions): String;
var
  rName: TADPhysParsedName;
  eParts: TADPhysNameParts;
begin
  eParts := GetNameParts;
  rName := AParsedName;
  if eoBeautify in AOpts then begin
    if not (npCatalog in eParts) or
       (npCatalog in FConnectionObj.RemoveDefaultMeta) or (rName.FCatalog = '*') or
       (AnsiCompareText(FConnectionObj.DefaultCatalog, rName.FCatalog) = 0) then
      rName.FCatalog := '';
    if not (npSchema in eParts) or
       (npSchema in FConnectionObj.RemoveDefaultMeta) or (rName.FSchema = '*') or
       (AnsiCompareText(FConnectionObj.DefaultSchema, rName.FSchema) = 0) then
      rName.FSchema := '';
    if rName.FBaseObject = '*' then
      rName.FBaseObject := '';
    if rName.FObject = '*' then
      rName.FObject := '';
    if not (eoQuote in AOpts) then begin
      rName.FCatalog := QuoteNameIfReq(rName.FCatalog, npCatalog);
      rName.FSchema := QuoteNameIfReq(rName.FSchema, npSchema);
      rName.FBaseObject := QuoteNameIfReq(rName.FBaseObject, npBaseObject);
      rName.FObject := QuoteNameIfReq(rName.FObject, npObject);
    end;
  end
  else
    if eoNormalize in AOpts then begin
      rName.FCatalog := NormObjName(rName.FCatalog, npCatalog);
      rName.FSchema := NormObjName(rName.FSchema, npSchema);
      rName.FBaseObject := NormObjName(rName.FBaseObject, npBaseObject);
      rName.FObject := NormObjName(rName.FObject, npObject);
    end;
  if eoQuote in AOpts then begin
    rName.FCatalog := QuoteObjName(rName.FCatalog);
    rName.FSchema := QuoteObjName(rName.FSchema);
    rName.FBaseObject := QuoteObjName(rName.FBaseObject);
    rName.FObject := QuoteObjName(rName.FObject);
  end;
  Result := InternalEncodeObjName(rName, ACommand);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsKeyword(const AName: String): Boolean;
begin
  Result := FKeywords.IndexOf(AName) >= 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.IsRDBMSKind(const AStr: String; out ACurrent: Boolean): Boolean;
var
  i: TADRDBMSKind;
begin
  Result := False;
  ACurrent := False;
  for i := Low(TADRDBMSKind) to High(TADRDBMSKind) do
    if (CompareText(AStr, C_AD_PhysRDBMSKinds[i]) = 0) or
       (CompareText(AStr, C_AD_PhysRDBMSIds[i]) = 0) then begin
      Result := True;
      if i = GetKind then
        ACurrent := True;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.UnsupportedEscape(const ASeq: TADPhysEscapeData);
begin
  ADException(Self, [S_AD_LPhys], er_AD_AccEscapeIsnotSupported, [ASeq.FName]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.EscapeFuncToID(var ASeq: TADPhysEscapeData);
var
  sName: String;
  eFunc: TADPhysEscapeFunction;
begin
  sName := ASeq.FName;
  // character
  if sName = 'ASCII' then
    eFunc := efASCII
  else if sName = 'LTRIM' then
    eFunc := efLTRIM
  else if sName = 'REPLACE' then
    eFunc := efREPLACE
  else if sName = 'RTRIM' then
    eFunc := efRTRIM
  else if sName = 'DECODE' then
    eFunc := efDECODE
  else if sName = 'BIT_LENGTH' then
    eFunc := efBIT_LENGTH
  else if sName = 'CHAR' then
    eFunc := efCHAR
  else if (sName = 'CHAR_LENGTH') or (sName = 'CHARACTER_LENGTH') then
    eFunc := efCHAR_LENGTH
  else if sName = 'CONCAT' then
    eFunc := efCONCAT
  else if sName = 'INSERT' then
    eFunc := efINSERT
  else if sName = 'LCASE' then
    eFunc := efLCASE
  else if sName = 'LEFT' then
    eFunc := efLEFT
  else if sName = 'LENGTH' then
    eFunc := efLENGTH
  else if sName = 'LOCATE' then
    eFunc := efLOCATE
  else if sName = 'OCTET_LENGTH' then
    eFunc := efOCTET_LENGTH
  else if sName = 'POSITION' then
    eFunc := efPOSITION
  else if sName = 'REPEAT' then
    eFunc := efREPEAT
  else if sName = 'RIGHT' then
    eFunc := efRIGHT
  else if sName = 'SPACE' then
    eFunc := efSPACE
  else if sName = 'SUBSTRING' then
    eFunc := efSUBSTRING
  else if sName = 'UCASE' then
    eFunc := efUCASE
  // numeric
  else if sName = 'ACOS' then
    eFunc := efACOS
  else if sName = 'ASIN' then
    eFunc := efASIN
  else if sName = 'ATAN' then
    eFunc := efATAN
  else if sName = 'CEILING' then
    eFunc := efCEILING
  else if sName = 'DEGREES' then
    eFunc := efDEGREES
  else if sName = 'LOG' then
    eFunc := efLOG
  else if sName = 'LOG10' then
    eFunc := efLOG10
  else if sName = 'PI' then
    eFunc := efPI
  else if sName = 'RADIANS' then
    eFunc := efRADIANS
  else if sName = 'RANDOM' then
    eFunc := efRANDOM
  else if sName = 'TRUNCATE' then
    eFunc := efTRUNCATE
  else if sName = 'ABS' then
    eFunc := efABS
  else if sName = 'COS' then
    eFunc := efCOS
  else if sName = 'EXP' then
    eFunc := efEXP
  else if sName = 'FLOOR' then
    eFunc := efFLOOR
  else if sName = 'MOD' then
    eFunc := efMOD
  else if sName = 'POWER' then
    eFunc := efPOWER
  else if sName = 'ROUND' then
    eFunc := efROUND
  else if sName = 'SIGN' then
    eFunc := efSIGN
  else if sName = 'SIN' then
    eFunc := efSIN
  else if sName = 'SQRT' then
    eFunc := efSQRT
  else if sName = 'TAN' then
    eFunc := efTAN
  // date and time
  else if (sName = 'CURRENT_DATE') or (sName = 'CURDATE') then
    eFunc := efCURDATE
  else if (sName = 'CURRENT_TIME') or (sName = 'CURTIME') then
    eFunc := efCURTIME
  else if (sName = 'CURRENT_TIMESTAMP') or (sName = 'NOW') then
    eFunc := efNOW
  else if sName = 'DAYNAME' then
    eFunc := efDAYNAME
  else if sName = 'DAYOFMONTH' then
    eFunc := efDAYOFMONTH
  else if sName = 'DAYOFWEEK' then
    eFunc := efDAYOFWEEK
  else if sName = 'DAYOFYEAR' then
    eFunc := efDAYOFYEAR
  else if sName = 'EXTRACT' then
    eFunc := efEXTRACT
  else if sName = 'HOUR' then
    eFunc := efHOUR
  else if sName = 'MINUTE' then
    eFunc := efMINUTE
  else if sName = 'MONTH' then
    eFunc := efMONTH
  else if sName = 'MONTHNAME' then
    eFunc := efMONTHNAME
  else if sName = 'QUARTER' then
    eFunc := efQUARTER
  else if sName = 'SECOND' then
    eFunc := efSECOND
  else if sName = 'TIMESTAMPADD' then
    eFunc := efTIMESTAMPADD
  else if sName = 'TIMESTAMPDIFF' then
    eFunc := efTIMESTAMPDIFF
  else if sName = 'WEEK' then
    eFunc := efWEEK
  else if sName = 'YEAR' then
    eFunc := efYEAR
  // system
  else if sName = 'CATALOG' then
    eFunc := efCATALOG
  else if sName = 'SCHEMA' then
    eFunc := efSCHEMA
  else if sName = 'IFNULL' then
    eFunc := efIFNULL
  else if (sName = 'IF') or (sName = 'IIF') then
    eFunc := efIF
  else if sName = 'LIMIT' then
    eFunc := efLIMIT
  // convert
  else if sName = 'CONVERT' then
    eFunc := efCONVERT
  else begin
    eFunc := efNONE;
    // unsupported ATAN2, COT
    UnsupportedEscape(ASeq);
  end;
  ASeq.FFunc := eFunc;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.AddEscapeSequenceArgs(const ASeq: TADPhysEscapeData): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Length(ASeq.FArgs) - 1 do begin
    if i > 0 then
      Result := Result + ', ';
    Result := Result + ASeq.FArgs[i];
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.TranslateEscapeSequence(
  var ASeq: TADPhysEscapeData): String;
var
  rName: TADPhysParsedName;
  i: Integer;
  s: String;
  lCurrent: Boolean;
begin
  case ASeq.FKind of
  eskFloat:
    Result := InternalEscapeFloat(UnQuoteBase(ASeq.FArgs[0], '''', ''''));
  eskDate:
    Result := InternalEscapeDate(UnQuoteBase(ASeq.FArgs[0], '''', ''''));
  eskTime:
    Result := InternalEscapeTime(UnQuoteBase(ASeq.FArgs[0], '''', ''''));
  eskDateTime:
    Result := InternalEscapeDateTime(UnQuoteBase(ASeq.FArgs[0], '''', ''''));
  eskIdentifier:
    begin
      rName.FObject := UnQuoteBase(ASeq.FArgs[0], '''', '''');
      Result := EncodeObjName(rName, nil, [eoQuote]);
    end;
  eskBoolean:
    Result := InternalEscapeBoolean(UnQuoteBase(ASeq.FArgs[0], '''', ''''));
  eskString:
    Result := InternalEscapeString(UnQuoteBase(ASeq.FArgs[0], '''', ''''));
  eskFunction:
    begin
      EscapeFuncToID(ASeq);
      // LIMIT has a syntax of a function, but it special escape sequence,
      // processed internally by command preprocessor and TADPhysCommand
      if ASeq.FFunc = efLIMIT then
        Result := ''
      else
        try
          Result := InternalEscapeFunction(ASeq);
        except
          on E: Exception do begin
            if not (E is EADException) then
              ADException(Self, [S_AD_LPhys], er_AD_AccEscapeBadSyntax,
                [ASeq.FName, E.Message])
            else
              raise;
          end;
        end;
    end;
  eskIIF:
    begin
      i := 0;
      Result := '';
      while i < (Length(ASeq.FArgs) and not 1) do begin
        s := Trim(ASeq.FArgs[i]);
        lCurrent := False;
        if IsRDBMSKind(s, lCurrent) then begin
          if lCurrent then begin
            Result := ASeq.FArgs[i + 1];
            Break;
          end;
        end
        else if s <> '' then begin
          Result := ASeq.FArgs[i + 1];
          Break;
        end;
        Inc(i, 2);
      end;
      if i = Length(ASeq.FArgs) - 1 then
        Result := ASeq.FArgs[i];
    end;
  eskIF:
    begin
      Result := '';
      s := Trim(ASeq.FArgs[0]);
      lCurrent := False;
      if IsRDBMSKind(s, lCurrent) then begin
        if lCurrent then
          Result := 'True';
      end
      else if s <> '' then
        Result := 'True';
    end;
  eskFI:
    Result := '';
  eskEscape:
    Result := InternalEscapeEscape(ASeq.FArgs[0][1], ASeq.FArgs[1]);
  eskInto:
    Result := InternalEscapeInto(ASeq.FArgs[0]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetSQLCommandKind(
  const ATokens: TStrings): TADPhysCommandKind;
begin
  Result := InternalGetSQLCommandKind(ATokens);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalGetSQLCommandKind(
  const ATokens: TStrings): TADPhysCommandKind;
var
  sToken: String;
begin
  sToken := ATokens[0];
  if (sToken = 'SELECT') or (sToken = 'WITH') then
    if (ATokens.Count > 1) and (ATokens[1] = 'INTO') then
      Result := skInsert
    else
      Result := skSelect
  else if sToken = 'UPDATE' then
    Result := skUpdate
  else if sToken = 'INSERT' then
    Result := skInsert
  else if sToken = 'MERGE' then
    Result := skMerge
  else if sToken = 'DELETE' then
    Result := skDelete
  else if sToken = 'DROP' then
    Result := skDrop
  else if sToken = 'CREATE' then
    Result := skCreate
  else if sToken = 'ALTER' then
    Result := skAlter
  else if sToken = 'COMMIT' then
    Result := skCommit
  else if sToken = 'ROLLBACK' then
    if ATokens.Count < 2 then
      Result := skNotResolved
    else if (ATokens.Count >= 3) and ((ATokens[1] = 'WORK') or (ATokens[1] = 'TRANSACTION')) and
              (ATokens[2] = 'TO') or
            (ATokens.Count >= 2) and (ATokens[1] = 'TO') then
      Result := skOther
    else
      Result := skRollback
  else if sToken = 'SET' then
    Result := skSet
  else
    Result := skOther;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetInsertHBlobMode: TADPhysInsertHBlobMode;
begin
  Result := hmInInsert;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetIdentitySupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetIdentityInsertSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetIdentityInWhere: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkOther;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetClientVersion: TADVersion;
begin
  Result := FClientVersion;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetServerVersion: TADVersion;
begin
  Result := FServerVersion;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetIsUnicode: Boolean;
begin
  Result := FIsUnicode;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetIsFileBased: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [npCatalog, npSchema, npDBLink, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameDefLowCaseParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 32;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
  ASide: TADPhysNameQuoteSide): Char;
begin
  if AQuote = ncDefault then
    Result := '"'
  else
    Result := #0;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetCatalogSeparator: Char;
begin
  Result := '.';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetSchemaSeparator: Char;
begin
  Result := '.';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNamedParamMark: TADPhysParamMark;
begin
  Result := prQMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetPositionedParamMark: TADPhysParamMark;
begin
  Result := GetNamedParamMark;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxNested: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxMultiple: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxSavepoints: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxAutoCommit: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTxAtomic: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetEventSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetEventKinds: String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetGeneratorSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTruncateSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvDef;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetInlineRefresh: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetSelectWithoutFrom: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetLockNoWait: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetCommandSeparator: String;
begin
  Result := ';';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetLineSeparator: TADTextEndOfLine;
begin
  Result := elDefault;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetArrayExecMode: TADPhysArrayExecMode;
begin
  Result := aeUpToFirstError;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetLimitOptions: TADPhysLimitOptions;
begin
  Result := [loRows];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetNullLocation: TADPhysNullLocations;
begin
  Result := [nlAscFirst, nlDescLast];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetServerCursorSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetColumnOriginProvided: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeBoolean(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeDate(const AStr: String): String;
begin
  Result := AnsiQuotedStr(AStr, '''');
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeDateTime(const AStr: String): String;
begin
  Result := AnsiQuotedStr(AStr, '''');
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeFloat(const AStr: String): String;
begin
  Result := AStr;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeTime(const AStr: String): String;
begin
  Result := AnsiQuotedStr(AStr, '''');
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeString(const AStr: String): String;
begin
  Result := AnsiQuotedStr(AStr, '''');
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeFunction(const ASeq: TADPhysEscapeData): String;
begin
  Result := ASeq.FName;
  if Length(ASeq.FArgs) > 0 then
    Result := Result + '(' + AddEscapeSequenceArgs(ASeq) + ')';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeEscape(AEscape: Char; const AStr: String): String;
begin
  Result := AStr + ' ESCAPE ''' + AEscape + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.InternalEscapeInto(const AStr: String): String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.DefineMetadataTableName(AKind: TADPhysMetaInfoKind): String;
var
  sDB: String;
begin
  ASSERT((FConnectionObj <> nil) and (FConnectionObj.ConnectionDef <> nil));
  sDB := FConnectionObj.ConnectionDef.ExpandedDatabase;
  case AKind of
  mkCatalogs:         Result := C_AD_SysNamePrefix + '#' + sDB + '#CATALOGS';
  mkSchemas:          Result := C_AD_SysNamePrefix + '#' + sDB + '#SCHEMAS';
  mkTables:           Result := C_AD_SysNamePrefix + '#' + sDB + '#TABLES';
  mkTableFields:      Result := C_AD_SysNamePrefix + '#' + sDB + '#TABLEFIELDS';
  mkIndexes:          Result := C_AD_SysNamePrefix + '#' + sDB + '#INDEXES';
  mkIndexFields:      Result := C_AD_SysNamePrefix + '#' + sDB + '#INDEXFIELDS';
  mkPrimaryKey:       Result := C_AD_SysNamePrefix + '#' + sDB + '#PRIMARYKEYS';
  mkPrimaryKeyFields: Result := C_AD_SysNamePrefix + '#' + sDB + '#PRIMARYKEYFIELDS';
  mkForeignKeys:      Result := C_AD_SysNamePrefix + '#' + sDB + '#FOREIGNKEYS';
  mkForeignKeyFields: Result := C_AD_SysNamePrefix + '#' + sDB + '#FOREIGNKEYFIELDS';
  mkPackages:         Result := C_AD_SysNamePrefix + '#' + sDB + '#PACKAGES';
  mkProcs:            Result := C_AD_SysNamePrefix + '#' + sDB + '#PROCS';
  mkProcArgs:         Result := C_AD_SysNamePrefix + '#' + sDB + '#PROCARGS';
  mkGenerators:       Result := C_AD_SysNamePrefix + '#' + sDB + '#GENERATORS';
  mkResultSetFields:  Result := C_AD_SysNamePrefix + '#' + sDB + '#RESULTSETFIELDS';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.AddMetadataCol(ATable: TADDatSTable;
  const AName: String; AType: TADDataType);
var
  oCol: TADDatSColumn;
begin
  oCol := TADDatSColumn.Create;
  oCol.Name := AName;
  oCol.SourceName := '';
  oCol.SourceID := ATable.Columns.Count + 1;
  oCol.SourceDataType := AType;
  oCol.SourceSize := LongWord(-1);
  oCol.Attributes := [caBase, caAllowNull, caReadOnly, caSearchable];
  oCol.DataType := AType;
  if AType = dtWideString then
    oCol.Size := C_AD_MaxNameLen;
  ATable.Columns.Add(oCol);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.DefineMetadataStructure(ATable: TADDatSTable;
  AKind: TADPhysMetaInfoKind);

  procedure Add(const AName: String; AType: TADDataType);
  begin
    AddMetadataCol(ATable, AName, AType);
  end;

begin
  case AKind of
  mkCatalogs:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
    end;
  mkSchemas:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
    end;
  mkTables:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('TABLE_NAME',       dtWideString);
      Add('TABLE_TYPE',       dtInt32);       // TADPhysTableKind
      Add('TABLE_SCOPE',      dtInt32);       // TADPhysObjectScopes
    end;
  mkTableFields:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('TABLE_NAME',       dtWideString);
      Add('COLUMN_NAME',      dtWideString);
      Add('COLUMN_POSITION',  dtInt32);
      Add('COLUMN_DATATYPE',  dtInt32);       // TADDataType
      Add('COLUMN_TYPENAME',  dtWideString);
      Add('COLUMN_ATTRIBUTES',dtUInt32);      // TADDataAttributes
      Add('COLUMN_PRECISION', dtInt32);
      Add('COLUMN_SCALE',     dtInt32);
      Add('COLUMN_LENGTH',    dtInt32);
    end;
  mkIndexes,
  mkPrimaryKey:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('TABLE_NAME',       dtWideString);
      Add('INDEX_NAME',       dtWideString);
      Add('PKEY_NAME',        dtWideString);
      Add('INDEX_TYPE',       dtInt32);       // TADPhysIndexKind
    end;
  mkIndexFields,
  mkPrimaryKeyFields:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('TABLE_NAME',       dtWideString);
      Add('INDEX_NAME',       dtWideString);
      Add('COLUMN_NAME',      dtWideString);
      Add('COLUMN_POSITION',  dtInt32);
      Add('SORT_ORDER',       dtWideString);
      Add('FILTER',           dtWideString);
    end;
  mkForeignKeys:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('TABLE_NAME',       dtWideString);
      Add('FKEY_NAME',        dtWideString);
      Add('PKEY_CATALOG_NAME',dtWideString);
      Add('PKEY_SCHEMA_NAME', dtWideString);
      Add('PKEY_TABLE_NAME',  dtWideString);
      Add('DELETE_RULE',      dtInt32);
      Add('UPDATE_RULE',      dtInt32);
    end;
  mkForeignKeyFields:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('TABLE_NAME',       dtWideString);
      Add('FKEY_NAME',        dtWideString);
      Add('COLUMN_NAME',      dtWideString);
      Add('PKEY_COLUMN_NAME', dtWideString);
      Add('COLUMN_POSITION',  dtInt32);
    end;
  mkPackages:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('PACKAGE_NAME',     dtWideString);
      Add('PACKAGE_SCOPE',    dtInt32);       // TADPhysObjectScopes
    end;
  mkProcs:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('PACK_NAME',        dtWideString);
      Add('PROC_NAME',        dtWideString);
      Add('OVERLOAD',         dtInt32);
      Add('PROC_TYPE',        dtInt32);       // TADPhysProcedureKind
      Add('PROC_SCOPE',       dtInt32);       // TADPhysObjectScopes
      Add('IN_PARAMS',        dtInt32);
      Add('OUT_PARAMS',       dtInt32);
    end;
  mkProcArgs:
    begin
      Add('RECNO',            dtInt32);       // 0
      Add('CATALOG_NAME',     dtWideString);  // 1
      Add('SCHEMA_NAME',      dtWideString);  // 2
      Add('PACK_NAME',        dtWideString);  // 3
      Add('PROC_NAME',        dtWideString);  // 4
      Add('OVERLOAD',         dtInt32);       // 5
      Add('PARAM_NAME',       dtWideString);  // 6
      Add('PARAM_POSITION',   dtInt32);       // 7
      Add('PARAM_TYPE',       dtInt32);       // 8 - TParamType
      Add('PARAM_DATATYPE',   dtInt32);       // 9 - TADDataType
      Add('PARAM_TYPENAME',   dtWideString);  // 10
      Add('PARAM_ATTRIBUTES', dtUInt32);      // 11 - TADDataAttributes
      Add('PARAM_PRECISION',  dtInt32);       // 12
      Add('PARAM_SCALE',      dtInt32);       // 13
      Add('PARAM_LENGTH',     dtInt32);       // 14
    end;
  mkGenerators:
    begin
      Add('RECNO',            dtInt32);
      Add('CATALOG_NAME',     dtWideString);
      Add('SCHEMA_NAME',      dtWideString);
      Add('GENERATOR_NAME',   dtWideString);
      Add('GENERATOR_SCOPE',  dtInt32);       // TADPhysObjectScopes
    end;
  mkResultSetFields:
    begin
      Add('RECNO',            dtInt32);
      Add('RESULTSET_KEY',    dtWideString);
      ATable.Columns[0].Size := 1024;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.FetchNoCache(AMetaKind: TADPhysMetaInfoKind;
  AScope: TADPhysObjectScopes; AKinds: TADPhysTableKinds; const ACatalog, ASchema,
  ABaseObject, AWildCard: String; AOverload: Word): TADDatSTable;
var
  oCommand: IADPhysMetaInfoCommand;
  oResOpts: TADResourceOptions;
begin
  Result := TADDatSTable.Create(DefineMetadataTableName(AMetaKind));
  Result.CountRef(0);
  try
    (FConnectionObj as IADPhysConnection).CreateMetaInfoCommand(oCommand);
    oResOpts := oCommand.Options.ResourceOptions;
    if oResOpts.CmdExecMode = amAsync then
      oResOpts.CmdExecMode := amBlocking;
    oCommand.ObjectScopes := AScope;
    oCommand.TableKinds := AKinds;
    oCommand.CatalogName := ACatalog;
    oCommand.SchemaName := ASchema;
    oCommand.BaseObjectName := ABaseObject;
    oCommand.Wildcard := AWildCard;
    oCommand.Overload := AOverload;
    oCommand.MetaInfoKind := AMetaKind;
    oCommand.Prepare;
    oCommand.Define(Result);
    oCommand.Open;
    if oCommand.State = csOpen then
      oCommand.Fetch(Result, True);
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.FetchToCache(AMetaKind: TADPhysMetaInfoKind;
  const ACatalog, ASchema, ABaseObject, AObject: String; AOverload: Word; ADataTable: TADDatSTable);
var
  oCommand: IADPhysMetaInfoCommand;
  oResOpts: TADResourceOptions;
begin
  (FConnectionObj as IADPhysConnection).CreateMetaInfoCommand(oCommand);
  oResOpts := oCommand.Options.ResourceOptions;
  if oResOpts.CmdExecMode = amAsync then
    oResOpts.CmdExecMode := amBlocking;
  oCommand.CatalogName := ACatalog;
  oCommand.SchemaName := ASchema;
  oCommand.BaseObjectName := ABaseObject;
  oCommand.CommandText := AObject;
  oCommand.Overload := AOverload;
  oCommand.MetaInfoKind := AMetaKind;
  oCommand.Prepare;
  if ADataTable.Columns.Count = 0 then
    oCommand.Define(ADataTable);
  oCommand.Open;
  if oCommand.State = csOpen then
    oCommand.Fetch(ADataTable, True);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.CheckFetchToCache(AMetaKind: TADPhysMetaInfoKind;
  const AFilter: String; var ATable: TADDatSTable; var AView: TADDatSView): Boolean;
var
  i: Integer;
  sTabName: String;
begin
  sTabName := DefineMetadataTableName(AMetaKind);
  if FMetadataCache = nil then
    FMetadataCache := TADDatSManager.Create;
  i := FMetadataCache.Tables.IndexOfName(sTabName);
  if i = -1 then begin
    ATable := FMetadataCache.Tables.Add(sTabName);
    DefineMetadataStructure(ATable, AMetaKind);
  end
  else
    ATable := FMetadataCache.Tables.ItemsI[i];
  AView := ATable.Select(AFilter);
  Result := AView.Rows.Count = 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.ConvertNameCaseExpr(const AColumn, AValue: String;
  APart: TADPhysNamePart): String;
begin
  if FCISearch then
    Result := 'UPPER(' + AColumn + ')'
  else if not GetNameQuotedCaseSens(AValue, APart) then
    if APart in GetNameDefLowCaseParts then
      Result := 'LOWER(' + AColumn + ')'
    else
      Result := 'UPPER(' + AColumn + ')'
  else
    Result := AColumn;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.ConvertNameCaseConst(const AValue: String;
  APart: TADPhysNamePart): String;
begin
  if FCISearch then
    Result := AnsiUpperCase(AValue)
  else if not GetNameQuotedCaseSens(AValue, APart) then
    if APart in GetNameDefLowCaseParts then
      Result := AnsiLowerCase(AValue)
    else
      Result := AnsiUpperCase(AValue)
  else
    Result := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.AddWildcard(AView: TADDatSView;
  const AColumn, AWildcard: String; APart: TADPhysNamePart);
begin
  if AWildcard <> '' then
    AView.RowFilter := AView.RowFilter + ' AND ' +
      ConvertNameCaseExpr(AColumn, AWildcard, APart) + ' LIKE ''' +
      ConvertNameCaseConst(AWildcard, APart) + '''';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetCacheFilter(const ACatalog, ASchema,
  AObjField, AObj, ASubObjField, ASubObj: String): String;

  procedure AddCond(const AColumn, AValue: String; APart: TADPhysNamePart);
  begin
    if Result <> '' then
      Result := Result + ' AND ';
    if GetIsFileBased and (APart = npBaseObject) then
      Result := Result + 'CmpFileName(' + AColumn + ',''' + AValue + ''')'
    else if GetIsFileBased and (APart = npCatalog) then
      Result := Result + 'CmpFilePath(' + AColumn + ',''' + AValue + ''')'
    else
      Result := Result + ConvertNameCaseExpr(AColumn, AValue, APart) + ' = ''' +
        ConvertNameCaseConst(AValue, APart) + '''';
  end;

begin
  Result := '';
  if ACatalog <> '' then
    AddCond('CATALOG_NAME', ACatalog, npCatalog);
  if ASchema <> '' then
    AddCond('SCHEMA_NAME', ASchema, npSchema);
  if AObj <> '' then
    AddCond(AObjField, AObj, npBaseObject);
  if ASubObj <> '' then
    AddCond(ASubObjField, ASubObj, npObject);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.ParseMetaInfoParams(const ACatalog, ASchema,
  ABaseObjName, AObjName: String; out AParsedName: TADPhysParsedName);
var
  sObjName: String;
  rName2: TADPhysParsedName;
begin
  if ABaseObjName <> '' then
    sObjName := ABaseObjName
  else
    sObjName := AObjName;
  DecodeObjName(sObjName, AParsedName, nil, [doUnquote, doNormalize]);
  if ABaseObjName <> '' then begin
    AParsedName.FBaseObject := AParsedName.FObject;
    DecodeObjName(AObjName, rName2, nil, [doUnquote, doNormalize, doSubObj]);
    AParsedName.FObject := rName2.FObject;
  end;
  if (AParsedName.FCatalog = '') and (ACatalog <> '') then
    AParsedName.FCatalog := UnQuoteObjName(NormObjName(ACatalog, npCatalog));
  if (AParsedName.FSchema = '') and (ASchema <> '') then
    AParsedName.FSchema := UnQuoteObjName(NormObjName(ASchema, npSchema));
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetCatalogs(const AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkCatalogs, [], [], '', '', '', AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetSchemas(const ACatalog, AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkSchemas, [], [], ACatalog, '', '', AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTables(AScope: TADPhysObjectScopes;
  AKinds: TADPhysTableKinds; const ACatalog, ASchema, AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkTables, AScope, AKinds, ACatalog, ASchema, '',
    AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableFields(const ACatalog, ASchema,
  ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  if CheckFetchToCache(mkTableFields, GetCacheFilter(rName.FCatalog, rName.FSchema,
      'TABLE_NAME', rName.FObject, '', ''), oTab, Result) then
    FetchToCache(mkTableFields, ACatalog, ASchema, '', ATable, 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableIndexes(const ACatalog, ASchema,
  ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  if CheckFetchToCache(mkIndexes, GetCacheFilter(rName.FCatalog, rName.FSchema,
      'TABLE_NAME', rName.FObject, '', ''), oTab, Result) then
    FetchToCache(mkIndexes, ACatalog, ASchema, '', ATable, 0, oTab);
  AddWildcard(Result, 'INDEX_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableIndexFields(const ACatalog,
  ASchema, ATable, AIndex, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, ATable, AIndex, rName);
  if CheckFetchToCache(mkIndexFields, GetCacheFilter(rName.FCatalog, rName.FSchema,
      'TABLE_NAME', rName.FBaseObject, 'INDEX_NAME', rName.FObject), oTab, Result) then
    FetchToCache(mkIndexFields, ACatalog, ASchema, ATable, AIndex, 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTablePrimaryKey(const ACatalog,
  ASchema, ATable: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  if CheckFetchToCache(mkPrimaryKey, GetCacheFilter(rName.FCatalog, rName.FSchema,
      'TABLE_NAME', rName.FObject, '', ''), oTab, Result) then
    FetchToCache(mkPrimaryKey, ACatalog, ASchema, '', ATable, 0, oTab);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTablePrimaryKeyFields(const ACatalog,
  ASchema, ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  if CheckFetchToCache(mkPrimaryKeyFields, GetCacheFilter(rName.FCatalog,
      rName.FSchema, 'TABLE_NAME', rName.FObject, '', ''), oTab, Result) then
    FetchToCache(mkPrimaryKeyFields, ACatalog, ASchema, ATable, '', 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableForeignKeys(const ACatalog, ASchema,
  ATable, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, '', ATable, rName);
  if CheckFetchToCache(mkForeignKeys, GetCacheFilter(rName.FCatalog, rName.FSchema,
      'TABLE_NAME', rName.FObject, '', ''), oTab, Result) then
    FetchToCache(mkForeignKeys, ACatalog, ASchema, '', ATable, 0, oTab);
  AddWildcard(Result, 'FK_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetTableForeignKeyFields(const ACatalog,
  ASchema, ATable, AForeignKey, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, ATable, AForeignKey, rName);
  if CheckFetchToCache(mkForeignKeyFields, GetCacheFilter(rName.FCatalog,
      rName.FSchema, 'TABLE_NAME', rName.FBaseObject, 'FK_NAME', rName.FObject),
      oTab, Result) then
    FetchToCache(mkForeignKeyFields, ACatalog, ASchema, ATable, AForeignKey, 0, oTab);
  AddWildcard(Result, 'COLUMN_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetPackages(AScope: TADPhysObjectScopes;
  const ACatalog, ASchema, AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkPackages, AScope, [], ACatalog, ASchema, '',
    AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetPackageProcs(const ACatalog, ASchema,
  APackage, AWildCard: String): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, APackage, '', rName);
  if CheckFetchToCache(mkProcs, GetCacheFilter(rName.FCatalog, rName.FSchema,
      'PACK_NAME', rName.FBaseObject, '', ''), oTab, Result) then
    FetchToCache(mkProcs, ACatalog, ASchema, APackage, '', 0, oTab);
  AddWildcard(Result, 'PROC_NAME', AWildCard, npBaseObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetProcs(AScope: TADPhysObjectScopes;
  const ACatalog, ASchema, AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkProcs, AScope, [], ACatalog, ASchema, '',
    AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetProcArgs(const ACatalog, ASchema,
  APackage, AProc, AWildCard: String; AOverload: Word): TADDatSView;
var
  rName: TADPhysParsedName;
  oTab: TADDatSTable;
  sProc, sFlt: String;
begin
  Result := nil;
  oTab := nil;
  ParseMetaInfoParams(ACatalog, ASchema, APackage, AProc, rName);
  if (GetKind = mkMSSQL) and (Pos(';', AProc) = 0) then
    sProc := rName.FObject + ';1'
  else
    sProc := rName.FObject;
  sFlt := GetCacheFilter(rName.FCatalog, rName.FSchema, 'PACK_NAME',
    rName.FBaseObject, 'PROC_NAME', sProc);
  if AOverload <> 0 then begin
    if sFlt <> '' then
      sFlt := sFlt + ' AND ';
    sFlt := sFlt + 'OVERLOAD = ' + IntToStr(AOverload);
  end;
  if CheckFetchToCache(mkProcArgs, sFlt, oTab, Result) then
    FetchToCache(mkProcArgs, ACatalog, ASchema, APackage, AProc, AOverload, oTab);
  AddWildcard(Result, 'PARAM_NAME', AWildCard, npObject);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetGenerators(
  AScope: TADPhysObjectScopes; const ACatalog, ASchema,
  AWildCard: String): TADDatSView;
begin
  Result := FetchNoCache(mkGenerators, AScope, [], ACatalog, ASchema, '',
    AWildCard, 0).DefaultView;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnectionMetadata.GetResultSetFields(const ASQLKey: String): TADDatSView;
var
  oTab: TADDatSTable;
begin
  Result := nil;
  oTab := nil;
  if CheckFetchToCache(mkResultSetFields, 'RESULTSET_KEY = ' + QuotedStr(ASQLKey), oTab, Result) then
    FetchToCache(mkResultSetFields, '', '', '', ASQLKey, 0, oTab);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnectionMetadata.RefreshMetadataCache(const AObjName: String = '');
var
  rName: TADPhysParsedName;
  sFlt: String;

  procedure TabClear(AMetaKind: TADPhysMetaInfoKind);
  var
    oTab: TADDatSTable;
    oView: TADDatSView;
  begin
    CheckFetchToCache(AMetaKind, sFlt, oTab, oView);
    oView.DeleteAll(True);
    ADFree(oView);
  end;

begin
  if FMetadataCache <> nil then
    if AObjName = '' then
      FMetadataCache.Clear
    else begin
      ParseMetaInfoParams('', '', '', AObjName, rName);

      if rName.FObject <> '' then begin
        sFlt := GetCacheFilter(rName.FCatalog, rName.FSchema, 'TABLE_NAME', rName.FObject, '', '');
        TabClear(mkTableFields);
        TabClear(mkIndexes);
        TabClear(mkIndexFields);
        TabClear(mkPrimaryKey);
        TabClear(mkPrimaryKeyFields);
        TabClear(mkForeignKeys);
        TabClear(mkForeignKeyFields);

        sFlt := GetCacheFilter(rName.FCatalog, rName.FSchema, 'PACK_NAME', rName.FObject, '', '');
        TabClear(mkProcs);
        TabClear(mkProcArgs);

        sFlt := GetCacheFilter(rName.FCatalog, rName.FSchema, 'PROC_NAME', rName.FObject, '', '');
        TabClear(mkProcArgs);
      end;

      if (rName.FBaseObject <> '') and (rName.FObject <> '') then begin
        sFlt := GetCacheFilter(rName.FCatalog, rName.FSchema, 'PACK_NAME', rName.FBaseObject, 'PROC_NAME', rName.FObject);
        TabClear(mkProcs);
      end;
    end;
end;

end.
