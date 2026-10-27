{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC DataSnap metadata               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysDataSnapMeta;

interface

uses
  Classes,
  uADStanIntf, uADDatSManager,
  uADPhysIntf, uADPhysManager, uADPhysConnMeta;

type
  TADPhysDataSnapMetadata = class (TADPhysConnectionMetadata)
  protected
    // IADPhysConnectionMetadata
    function GetKind: TADRDBMSKind; override;
    function GetTxSupported: Boolean; override;
    function GetEventSupported: Boolean; override;
    function GetEventKinds: String; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameParts: TADPhysNameParts; override;
    function GetNameQuotedCaseSensParts: TADPhysNameParts; override;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; override;
    function GetIdentitySupported: Boolean; override;
    function GetNamedParamMark: TADPhysParamMark; override;
    function GetAsyncAbortSupported: Boolean; override;
    function GetLimitOptions: TADPhysLimitOptions; override;
    function GetServerCursorSupported: Boolean; override;
    function GetColumnOriginProvided: Boolean; override;
    function GetTruncateSupported: Boolean; override;
    function GetDefValuesSupported: TADPhysDefaultValues; override;
    // other
    function InternalGetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind; override;
  public
    constructor Create(const AConnectionObj: TADPhysConnection;
      AServerVersion, AClientVersion: TADVersion; AIsUnicode: Boolean);
  end;

implementation

uses
{$IFDEF MSWINDOWS}
  // Preventing from "Inline has not expanded"
  Windows,
{$ENDIF}
  SysUtils,
  uADStanError, uADStanConst, uADStanUtil;

{-------------------------------------------------------------------------------}
{ TADPhysDataSnapMetadata                                                       }
{-------------------------------------------------------------------------------}
constructor TADPhysDataSnapMetadata.Create(const AConnectionObj: TADPhysConnection;
  AServerVersion, AClientVersion: TADVersion; AIsUnicode: Boolean);
begin
  inherited Create(AConnectionObj, AServerVersion, AClientVersion, AIsUnicode);
  FKeywords.CommaText := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.InternalGetSQLCommandKind(
  const ATokens: TStrings): TADPhysCommandKind;
var
  sToken: String;
begin
  sToken := ATokens[0];
  if sToken = 'CALL' then
    Result := skExecute
  else
    Result := inherited InternalGetSQLCommandKind(ATokens);
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetIdentitySupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetKind: TADRDBMSKind;
begin
  Result := mkDataSnap;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetNameQuotedCaseSensParts: TADPhysNameParts;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetParamNameMaxLength: Integer;
begin
  Result := 255;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetNameParts: TADPhysNameParts;
begin
  Result := [npSchema, npBaseObject, npObject];
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
  ASide: TADPhysNameQuoteSide): Char;
begin
  Result := #0;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetNamedParamMark: TADPhysParamMark;
begin
  Result := prName;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetTxSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetEventSupported: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetEventKinds: String;
begin
  Result := S_AD_EventKind_DataSnap_Events;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetTruncateSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetDefValuesSupported: TADPhysDefaultValues;
begin
  Result := dvNone;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetAsyncAbortSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetLimitOptions: TADPhysLimitOptions;
begin
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetServerCursorSupported: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapMetadata.GetColumnOriginProvided: Boolean;
begin
  Result := False;
end;

end.
