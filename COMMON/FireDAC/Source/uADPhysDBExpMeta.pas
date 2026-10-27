{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{             FireDAC DBX 3 Bridge metadata             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysDBExpMeta;

interface

uses
  Classes,
  uADStanIntf,
  uADPhysIntf, uADPhysManager, uADPhysConnMeta, uADPhysDBExp;

type
  __TADPhysConnectionMetadata = class(TADPhysConnectionMetadata)
  end;

  TADPhysDBExpMetadata = class (TADPhysConnectionMetadata)
  private
    FTxSupported: Boolean;
    FTxNested: Boolean;
    FNameMaxLength: Integer;
    FNameQuoteChar: Char;
    FNameQuoteChar1: Char;
    FNameQuoteChar2: Char;
  protected
    // uses ParentMeta
    function GetTxSupported: Boolean; override;
    function GetTxNested: Boolean; override;
    function GetParamNameMaxLength: Integer; override;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char; override;
    function GetColumnOriginProvided: Boolean; override;
    function InternalDecodeObjName(const AName: String; out AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; ARaise: Boolean): Boolean; override;
  public
    constructor Create(const AConnection: TADPhysConnection);
  end;

implementation

uses
  SysUtils, DBXpress,
  uADStanUtil;

{-------------------------------------------------------------------------------}
{ TADPhysDBExpMetadata                                                          }
{-------------------------------------------------------------------------------}
constructor TADPhysDBExpMetadata.Create(const AConnection: TADPhysConnection);
var
  oDbxConn: {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE} ISQLConnection {$ENDIF};
  oDbxMeta: {$IFDEF AnyDAC_D10} ISQLMetaData30 {$ELSE} ISQLMetaData {$ENDIF};
  siPropSize: SmallInt;
  C: SQLString;
  L: LongBool;
  I: Integer;
begin
  inherited Create(AConnection, 0, 0, False);
  oDbxConn := {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE} ISQLConnection {$ENDIF}
    (AConnection.CliObj);
  oDbxConn.getSQLMetaData(oDbxMeta);
  C := '""';
  siPropSize := 1;
  oDbxMeta.getOption(eMetaObjectQuoteChar, @C[1], 2, siPropSize);
  FNameQuoteChar := #0;
  FNameQuoteChar1 := #0;
  FNameQuoteChar2 := #0;
  if siPropSize = 2 then begin
    FNameQuoteChar1 := AnsiChar(C[1]);
    FNameQuoteChar2 := AnsiChar(C[2]);
  end
  else if siPropSize = 1 then
    FNameQuoteChar := AnsiChar(C[1]);
  I := 30;
  oDbxMeta.getOption(eMetaMaxObjectNameLength, @I, SizeOf(Integer), siPropSize);
  FNameMaxLength := I;
  L := False;
  oDbxMeta.getOption(eMetaSupportsTransaction, @L, SizeOf(LongBool), siPropSize);
  FTxSupported := L;
  L := False;
  oDbxMeta.getOption(eMetaSupportsTransactions, @L, SizeOf(LongBool), siPropSize);
  // get eConnMaxActiveComm
  FTxNested := L;
  ConfigNameParts;
  ConfigQuoteChars;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.InternalDecodeObjName(const AName: String;
  out AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand;
  ARaise: Boolean): Boolean;
{$IFDEF AnyDAC_D7}
var
  oDbxConn: {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE} ISQLConnection {$ENDIF};
  buf0, buf1, buf2: array [0..255] of char;
  wLen: SmallInt;
  iRes: SQLResult;
{$ENDIF}
begin
{$IFDEF AnyDAC_D7}
  Result := True;
  if AName <> '' then begin
    oDbxConn := {$IFDEF AnyDAC_D10} ISQLConnection30 {$ELSE} ISQLConnection {$ENDIF}
      (FConnectionObj.CliObj);
    iRes := oDbxConn.setOption(eConnQualifiedName, LongInt(PChar(AName)));
    if iRes = 0 then begin
      ADFillChar(buf0[0], 256, 0);
      oDbxConn.getOption(eConnCatalogName, @buf0, SizeOf(buf0), wLen);
      if buf0[0] <> #0 then
        AParsedName.FCatalog := PChar(@buf0);
      ADFillChar(buf1[0], 256, 0);
      oDbxConn.getOption(eConnSchemaName, @buf1, SizeOf(buf1), wLen);
      if buf1[0] <> #0 then
        AParsedName.FSchema := PChar(@buf1);
      ADFillChar(buf2[0], 256, 0);
      oDbxConn.getOption(eConnObjectName, @buf2, SizeOf(buf2), wLen);
      if buf2[0] <> #0 then
        AParsedName.FObject := PChar(@buf2);
    end
    else
      Result := inherited InternalDecodeObjName(AName, AParsedName, ACommand, ARaise);
  end;
{$ELSE}
  Result := inherited InternalDecodeObjName(AName, AParsedName, ACommand, ARaise);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetTxNested: Boolean;
begin
  Result := FTxNested;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetTxSupported: Boolean;
begin
  Result := FTxSupported;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetParamNameMaxLength: Integer;
begin
  Result := FNameMaxLength;
end;

{-------------------------------------------------------------------------------}
function TADPhysDBExpMetadata.GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel;
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
function TADPhysDBExpMetadata.GetColumnOriginProvided: Boolean;
begin
  Result := False;
end;

end.
