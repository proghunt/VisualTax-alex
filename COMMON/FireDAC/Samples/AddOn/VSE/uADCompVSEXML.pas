{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{   FireDAC Virtual Storage Engine XML implementation   }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompVSEXML;

interface

uses
  Classes, MSXML,
  uADCompDataSet, uADCompVSE;

type
  TADVSEXMLFieldDef = class;
  TADVSEXMLSession = class;
  TADVSEXMLManager = class;

  {-----------------------------------------------------------------------------}
  // XPath virtual storage

  TADVSEXMLFieldDef = class(TADVSEFieldDef)
  private
    FXPathNamespace: String;
    FXPathExpression: String;
    FAttribute: String;
  published
    property XPathExpression: String read FXPathExpression write FXPathExpression;
    property XPathNamespace: String read FXPathNamespace write FXPathNamespace;
    property Attribute: String read FAttribute write FAttribute;
  end;

  TADVSEXMLSession = class(TADVSESession)
  private
    FDoc: {$IFDEF AnyDAC_D14} IXMLDomDocument2 {$ELSE} IXMLDomDocument {$ENDIF};
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  end;

  TADVSEXMLManager = class(TADVSEManager)
  protected
    class function GetFieldDefClass: TADVSEFieldDefClass; override;
    class function GetSessionClass: TADVSESessionClass; override;
    procedure DoDecode(ASession: TADVSESession; ADataSet: TADDataSet); override;
  end;

implementation

uses
  SysUtils, Variants, ComObj, DB,
  uADStanIntf;

{-------------------------------------------------------------------------------}
{ TADVSEXMLSession                                                              }
{-------------------------------------------------------------------------------}
constructor TADVSEXMLSession.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
{$IFDEF AnyDAC_D14} 
  FDoc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument2;
  FDoc.setProperty('SelectionLanguage', 'XPath');
{$ELSE}
  FDoc := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
destructor TADVSEXMLSession.Destroy;
begin
  FDoc := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{ TADVSEXMLManager                                                              }
{-------------------------------------------------------------------------------}
class function TADVSEXMLManager.GetFieldDefClass: TADVSEFieldDefClass;
begin
  Result := TADVSEXMLFieldDef;
end;

{-------------------------------------------------------------------------------}
class function TADVSEXMLManager.GetSessionClass: TADVSESessionClass;
begin
  Result := TADVSEXMLSession;
end;

{-------------------------------------------------------------------------------}
procedure TADVSEXMLManager.DoDecode(ASession: TADVSESession;
  ADataSet: TADDataSet);
var
  sa: AnsiString;
  sw: WideString;
  i: Integer;
  oNode: IXMLDomNode;
begin
  with TADVSEXMLSession(ASession).FDoc do begin
    case ASession.BaseColumn.DataType of
    dtByteString,
    dtBlob,
    dtHBlob,
    dtHBFile,
    dtAnsiString,
    dtMemo,
    dtHMemo:
      begin
        SetString(sa, PAnsiChar(ASession.Buff), ASession.Len);
        loadXML(WideString(sa));
      end;
    dtWideString,
    dtWideMemo,
    dtXML,
    dtWideHMemo:
      begin
        SetString(sw, PWideChar(ASession.Buff), ASession.Len);
        loadXML(sw);
      end;
    else
      raise Exception.CreateFmt('Base column [%s] data type is not supported !',
        [ASession.BaseColumn.Name]);
    end;
    try

      for i := 0 to ASession.Fields.Count - 1 do
        with ASession.Fields[i] do begin
{$IFDEF AnyDAC_D14} 
          setProperty('SelectionNamespaces', TADVSEXMLFieldDef(FieldDef).XPathNamespace);
{$ENDIF}
          oNode := selectSingleNode(TADVSEXMLFieldDef(FieldDef).XPathExpression);
          if oNode = nil then
            ASession.Row.SetData(Column, Null)
          else if TADVSEXMLFieldDef(FieldDef).Attribute <> '' then
            ASession.Row.SetData(Column, oNode.attributes.getNamedItem(
              TADVSEXMLFieldDef(FieldDef).Attribute).text)
          else
            ASession.Row.SetData(Column, oNode.text);
        end;

    finally
      loadXML('');
    end;
  end;

  inherited DoDecode(ASession, ADataSet);
end;

end.

