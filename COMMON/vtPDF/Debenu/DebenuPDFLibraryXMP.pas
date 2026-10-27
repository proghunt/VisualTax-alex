{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryXMP.pas                                }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryXMP;

{$I DebenuPDFLibraryDefines.inc}

interface

{$IFDEF VER120}
{$DEFINE D4ORD5}
{$ENDIF}

{$IFDEF VER130}
{$DEFINE D4ORD5}
{$ENDIF}

uses
  Classes, SysUtils,
{$IFDEF QPL_OS_WINDOWS}
  ComObj,
{$ENDIF}
{$IFNDEF D4ORD5}
  Variants,
{$ENDIF}
  DebenuPDFLibraryExtra;

{$IFNDEF QPL_OS_WINDOWS}
{$DEFINE QPLNOXMP}
{$ENDIF}

type
  TDebenuPDFLibraryXMP = class
  protected
    // Internal objects
    FXMLDoc: Variant;
    FError: Boolean;
    FXMPNode: Variant;
    FRDFNode: Variant;

    // Properties and property access functions
    FTitle: WideString;
    FAuthor: WideString;
    FSubject: WideString;
    FKeywords: WideString;
    FCreator: WideString;
    FProducer: WideString;
    FCreationDate: WideString;
    FModDate: WideString;
    FPDFAID: WideString;
    FDCSubject: WideString;
    procedure SetTitle(const NewTitle: WideString);
    procedure SetAuthor(const NewAuthor: WideString);
    procedure SetSubject(const NewSubject: WideString);
    procedure SetKeywords(const NewKeywords: WideString);
    procedure SetCreator(const NewCreator: WideString);
    procedure SetProducer(const NewProducer: WideString);
    procedure SetCreationDate(const NewCreationDate: WideString);
    procedure SetModDate(const NewModDate: WideString);
    procedure SetPDFAID(const NewPDFAID: WideString);
    procedure SetDCSubject(const NewDCSubject: WideString);

    // Internal functionality
    function ValidNode(const Node: Variant): Boolean;
    procedure GenerateXMP;
    function SelectNode(const XPath: WideString): Variant; overload;
    function SelectNode(const Parent: Variant; const XPath: WideString): Variant; overload;
    procedure SetXPathNamespace;
    procedure SetAllProperties;
    function FindNamespaceNode(const NamespaceURI: WideString): Variant;
    function CreatePropertyBag(const Key, Value, Namespace: WideString): Variant;
    function CreatePropertySeq(const Key, Value, Namespace: WideString): Variant;
    function CreateProperty(const Key, Value, Namespace: WideString): Variant;
    function CreatePropertyLang(const Key, Lang, Value, Namespace: WideString): Variant;
    procedure SetDublinCore(const Key, NewValue: WideString);
    procedure SetXMPBasic(const Key, NewValue: WideString);
    procedure SetAdobePDF(const Key, NewValue: WideString);
    procedure SetPDFA(const Key, NewValue: WideString);
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromString(const Source: AnsiString);
    function SaveToString: AnsiString;
    property Title: WideString read FTitle write SetTitle;
    property Author: WideString read FAuthor write SetAuthor;
    property Subject: WideString read FSubject write SetSubject;
    property Keywords: WideString read FKeywords write SetKeywords;
    property Creator: WideString read FCreator write SetCreator;
    property Producer: WideString read FProducer write SetProducer;
    property CreationDate: WideString read FCreationDate write SetCreationDate;
    property ModDate: WideString read FModDate write SetModDate;
    property PDFAID: WideString read FPDFAID write SetPDFAID;
    property DCSubject: WideString read FDCSubject write SetDCSubject;
  end;

implementation

const
  RDFURI: WideString = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
  DublinCoreURI: WideString = 'http://purl.org/dc/elements/1.1/';
  XMPBasicURI: WideString = 'http://ns.adobe.com/xap/1.0/';
  AdobePDFURI: WideString = 'http://ns.adobe.com/pdf/1.3/';
  PDFAURI: WideString = 'http://www.aiim.org/pdfa/ns/id/';

{$IFDEF D4ORD5}

const
  CFirstUserType = $010F;

function FindVarData(const V: Variant): PVarData;
begin
  Result := @TVarData(V);
  while Result.VType = varByRef or varVariant do
    Result := PVarData(Result.VPointer);
end;

function VarIsClear(const V: Variant): Boolean;
var
  LVarData: TVarData;
begin
  LVarData := FindVarData(V)^;
  with LVarData do
    if VType < CFirstUserType then
      Result := (VType = varEmpty) or
                (((VType = varDispatch) or (VType = varUnknown)) and
                  (VDispatch = nil))
    else
      Result := False;
end;
{$ENDIF}

{ TDebenuPDFLibraryXMP }

function TDebenuPDFLibraryXMP.ValidNode(const Node: Variant): Boolean;
begin
  Result := (not VarIsClear(Node)) and (not VarIsNull(Node));
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TDebenuPDFLibraryXMP.GenerateXMP;
begin
end;
{$ELSE}
procedure TDebenuPDFLibraryXMP.GenerateXMP;
var
  PI: Variant;
  PIStr: WideString;
  TempWS: WideString;
begin
  if (not FError) then
  begin
    PIStr := 'begin="';
    TempWS := WideChar($FEFF);
    PIStr := PIStr + TempWS;
    PIStr := PIStr + '" id="W5M0MpCehiHzreSzNTczkc9d"';
    PI := FXMLDoc.createProcessingInstruction('xpacket', PIStr);
    FXMLDoc.appendChild(PI);

    FXMPNode := FXMLDoc.createNode(1, 'x:xmpmeta', 'adobe:ns:meta/');
    FXMLDoc.appendChild(FXMPNode);

    FRDFNode := FXMLDoc.createNode(1, 'rdf:RDF', RDFURI);
    FXMPNode.appendChild(FRDFNode);

    PI := FXMLDoc.createProcessingInstruction('xpacket', 'end="w"');
    FXMLDoc.appendChild(PI);

    SetXPathNamespace;
    SetAllProperties;
  end;
end;
{$ENDIF}

{$IFDEF QPLNOXMP}
function TDebenuPDFLibraryXMP.SelectNode(const XPath: WideString): Variant;
begin

end;

procedure TDebenuPDFLibraryXMP.LoadFromString(const Source: AnsiString);
begin

end;

constructor TDebenuPDFLibraryXMP.Create;
begin
  FError := True;
end;

function TDebenuPDFLibraryXMP.SaveToString: AnsiString;
begin
  Result := '';
end;

function TDebenuPDFLibraryXMP.CreateProperty(const Key, Value,
  Namespace: WideString): Variant;
begin
  Result := Unassigned;
end;

function TDebenuPDFLibraryXMP.SelectNode(const Parent: Variant;
  const XPath: WideString): Variant;
begin
  Result := Unassigned;
end;

procedure TDebenuPDFLibraryXMP.SetXPathNamespace;
begin
end;

procedure TDebenuPDFLibraryXMP.SetPDFA(const Key, NewValue: WideString);
begin
end;

procedure TDebenuPDFLibraryXMP.SetAdobePDF(const Key, NewValue: WideString);
begin
end;

procedure TDebenuPDFLibraryXMP.SetXMPBasic(const Key, NewValue: WideString);
begin
end;

procedure TDebenuPDFLibraryXMP.SetDCSubject(const NewDCSubject: WideString);
begin

end;

procedure TDebenuPDFLibraryXMP.SetDublinCore(const Key, NewValue: WideString);
begin

end;

function TDebenuPDFLibraryXMP.FindNamespaceNode(
  const NamespaceURI: WideString): Variant;
begin

end;

function TDebenuPDFLibraryXMP.CreatePropertyLang(const Key, Lang, Value,
  Namespace: WideString): Variant;
begin

end;

function TDebenuPDFLibraryXMP.CreatePropertySeq(const Key, Value,
  Namespace: WideString): Variant;
begin

end;

destructor TDebenuPDFLibraryXMP.Destroy;
begin

  inherited;
end;

function TDebenuPDFLibraryXMP.CreatePropertyBag(const Key, Value, Namespace: WideString): Variant;
begin

end;

{$ELSE}

function TDebenuPDFLibraryXMP.SelectNode(const XPath: WideString): Variant;
begin
  try
    Result := FXMLDoc.selectSingleNode(XPath);
  except
    Result := Null;
  end;
end;

procedure TDebenuPDFLibraryXMP.LoadFromString(const Source: AnsiString);
var
  Node: Variant;
begin
  if (not FError) then
  begin
    if (Source <> '') then
    begin
      if (FXMLDoc.loadXML(QPLUTF8Decode(Source))) then
      begin
        try
          SetXPathNamespace;

          FXMPNode := SelectNode('/x:xmpmeta');
          if not ValidNode(FXMPNode) then
            Exit;

          FRDFNode := SelectNode('/x:xmpmeta/rdf:RDF');
          if (not ValidNode(FRDFNode)) then
          begin
            FRDFNode := FXMLDoc.createNode(1, 'rdf:RDF', RDFURI);
            FXMPNode.appendChild(FRDFNode);
          end;

          Node := SelectNode('/x:xmpmeta/rdf:RDF/rdf:Description' +
            '/dc:creator/rdf:Bag/rdf:li');
          if (ValidNode(Node)) then
          begin
            if (ValidNode(Node.firstChild)) then
            begin
              FAuthor := WideString(Node.firstChild.nodeValue);
            end;
          end;

          Node := SelectNode('/x:xmpmeta/rdf:RDF/rdf:Description' +
            '/dc:creator/rdf:Seq/rdf:li');
          if (ValidNode(Node)) then
          begin
            if (ValidNode(Node.firstChild)) then
            begin
              FAuthor := WideString(Node.firstChild.nodeValue);
            end;
          end;

          Node := SelectNode('/x:xmpmeta/rdf:RDF/rdf:Description' +
            '/dc:subject/rdf:Bag/rdf:li');
          if (ValidNode(Node)) then
          begin
            if (ValidNode(Node.firstChild)) then
            begin
              FDCSubject := WideString(Node.firstChild.nodeValue);
            end;
          end;
        except

        end;
      end;
    end;
  end;
end;

function TDebenuPDFLibraryXMP.SaveToString: AnsiString;
var
  ThisPos: Integer;
  EndToken: AnsiString;
  Padding: AnsiString;
  Reader: Variant;
  Writer: Variant;
  SavedXML: WideString;
  PrettyXML: WideString;
begin
  if (not FError) then
  begin
    if (DPLClassExists('MSXML2.SAXXMLReader.6.0')) then
    begin
      Reader := CreateOleObject('MSXML2.SAXXMLReader.6.0');
    end else
    if (DPLClassExists('MSXML2.SAXXMLReader.3.0')) then
    begin
      Reader := CreateOleObject('MSXML2.SAXXMLReader.3.0');
    end else
    if (DPLClassExists('MSXML2.SAXXMLReader')) then
    begin
      Reader := CreateOleObject('MSXML2.SAXXMLReader');
    end else
    begin
      Result := '';
      Exit;
    end;

    if (DPLClassExists('MSXML2.MXXMLWriter.6.0')) then
    begin
      Writer := CreateOleObject('MSXML2.MXXMLWriter.6.0');
    end else
    if (DPLClassExists('MSXML2.MXXMLWriter.3.0')) then
    begin
      Writer := CreateOleObject('MSXML2.MXXMLWriter.3.0');
    end else
    if (DPLClassExists('MSXML2.MXXMLWriter')) then
    begin
      Writer := CreateOleObject('MSXML2.MXXMLWriter');
    end else
    begin
      Result := '';
      Exit;
    end;

    Writer.indent := True;
    Writer.standalone := False;
    Writer.omitXMLDeclaration := False;
    //Writer.encoding: default WideString encoding

    Reader.contentHandler := Writer;
    Reader.dtdHandler := Writer;
    Reader.errorHandler := Writer;

    Reader.putProperty('http://xml.org/sax/properties/declaration-handler', Writer);
    Reader.putProperty('http://xml.org/sax/properties/lexical-handler', Writer);

    try
      SavedXML := FXMLDoc.xml
    except
      SavedXML := '';
    end;

    if (Length(SavedXML) > 0) then
    begin
      Reader.parse(SavedXML);

      PrettyXML := Writer.Output;
      if (Copy(PrettyXML, 1, 5) = '<?xml') then
      begin
        repeat
          Delete(PrettyXML, 1, 1);
        until (Length(PrettyXML) = 0) or (Copy(PrettyXML, 1, 9) = '<?xpacket');
      end;

      Result := QPLUTF8Encode(PrettyXML);

      Writer := Unassigned;
      Reader := Unassigned;

      if (Length(Result) > 0) then
      begin
        ThisPos := Length(Result);
        repeat
          Dec(ThisPos);
          EndToken := QPLCopy(Result, ThisPos, 14);
        until (EndToken = '<?xpacket end=') or (ThisPos = 1);
        if (ThisPos > 1) then
        begin
          SetLength(Padding, 1024);
          FillChar(Padding[1], 1024, #32);
          Padding[1024] := #10;
          Result := Copy(Result, 1, ThisPos - 1) + Padding +
            Copy(Result, ThisPos, MaxInt);
        end;
      end;
    end else
    begin
      Result := '';
    end;
  end;
end;

constructor TDebenuPDFLibraryXMP.Create;
begin
  FTitle := '';
  FAuthor := '';
  FSubject := '';
  FKeywords := '';
  FCreator := '';
  FProducer := '';
  FCreationDate := '';
  FModDate := '';

  FError := False;
  try
{$IFDEF QPL_OS_WINDOWS}
    if (DPLClassExists('MSXML2.DOMDocument.6.0')) then
    begin
      FXMLDoc := CreateOleObject('MSXML2.DOMDocument.6.0');
    end else
    if (DPLClassExists('MSXML2.DOMDocument.3.0')) then
    begin
      FXMLDoc := CreateOleObject('MSXML2.DOMDocument.3.0');
    end else
    if (DPLClassExists('MSXML2.DOMDocument')) then
    begin
      FXMLDoc := CreateOleObject('MSXML2.DOMDocument');
    end else
    begin
      FError := True;
    end;
{$ENDIF}
  except
    FXMLDoc := Unassigned;
    FError := True;
  end;

  if (not FError) then
    GenerateXMP;
end;

destructor TDebenuPDFLibraryXMP.Destroy;
begin
  try
    if ValidNode(FXMLDoc) then
      FXMLDoc := Unassigned;
  except
    //Debug('FXMLDoc Failed');
  end;

  try
    if ValidNode(FXMPNode) then
      FXMPNode := Unassigned;
  except
    //Debug('FXMPNode Failed');
  end;

  try
    if ValidNode(FRDFNode) then
      FRDFNode := Unassigned;
  except
    //Debug('FRDFNode Failed');
  end;

  inherited;
end;

function TDebenuPDFLibraryXMP.CreateProperty(const Key, Value,
  Namespace: WideString): Variant;
begin
  Result := FXMLDoc.createNode(1, Key, Namespace);
  Result.text := Value;
end;

function TDebenuPDFLibraryXMP.CreatePropertyBag(const Key, Value, Namespace: WideString): Variant;
var
  Bag: Variant;
  BagItem: Variant;
begin
  Result := FXMLDoc.createNode(1, Key, Namespace);
  Bag := FXMLDoc.createNode(1, 'rdf:Bag', RDFURI);
  Result.appendChild(Bag);
  BagItem := FXMLDoc.createNode(1, 'rdf:li', RDFURI);
  Bag.appendChild(BagItem);
  BagItem.text := Value;
end;

function TDebenuPDFLibraryXMP.CreatePropertySeq(const Key, Value, Namespace: WideString): Variant;
var
  Bag: Variant;
  BagItem: Variant;
begin
  Result := FXMLDoc.createNode(1, Key, Namespace);
  Bag := FXMLDoc.createNode(1, 'rdf:Seq', RDFURI);
  Result.appendChild(Bag);
  BagItem := FXMLDoc.createNode(1, 'rdf:li', RDFURI);
  Bag.appendChild(BagItem);
  BagItem.text := Value;
end;

function TDebenuPDFLibraryXMP.CreatePropertyLang(const Key, Lang, Value,
  Namespace: WideString): Variant;
var
  Bag: Variant;
  BagItem: Variant;
begin
  Result := FXMLDoc.createNode(1, Key, Namespace);
  Bag := FXMLDoc.createNode(1, 'rdf:Alt', RDFURI);
  Result.appendChild(Bag);
  BagItem := FXMLDoc.createNode(1, 'rdf:li', RDFURI);
  Bag.appendChild(BagItem);
  BagItem.text := Value;
  BagItem.setAttribute('xml:lang', Lang);
end;

function TDebenuPDFLibraryXMP.FindNamespaceNode(
  const NamespaceURI: WideString): Variant;
var
  Node: Variant;
  NodeList: Variant;
  NodeIndex: Integer;
  AttributeIndex: Integer;
begin
  Result := Null;
  if (not FError) then
  begin
    NodeList := FXMLDoc.selectNodes('/x:xmpmeta/rdf:RDF/rdf:Description');
    if (ValidNode(NodeList)) then
    begin
      for NodeIndex := 0 to NodeList.length - 1 do
      begin
        Node := NodeList.item[NodeIndex];
        if (ValidNode(Node)) then
        begin
          for AttributeIndex := 0 to Node.attributes.length - 1 do
          begin
            if (Copy(Node.attributes.item[AttributeIndex].name, 1, 6) = 'xmlns:') then
            begin
              if (Node.attributes.item[AttributeIndex].text = NamespaceURI) then
              begin
                Result := Node;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TDebenuPDFLibraryXMP.SetDCSubject(const NewDCSubject: WideString);
begin
  if ((not FError) and (NewDCSubject <> FDCSubject)) then
  begin
    FDCSubject := NewDCSubject;
    SetDublinCore('subject', NewDCSubject);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetDublinCore(const Key, NewValue: WideString);
var
  DublinCoreNode: Variant;
  Node: Variant;
begin
  DublinCoreNode := FindNamespaceNode(DublinCoreURI);
  if (not ValidNode(DublinCoreNode)) then
  begin
    DublinCoreNode := FXMLDoc.createNode(1, 'rdf:Description', RDFURI);
    DublinCoreNode.setAttribute('xmlns:dc', DublinCoreURI);
    FRDFNode.appendChild(DublinCoreNode);
  end;
  if (ValidNode(DublinCoreNode)) then
  begin
    Node := SelectNode(DublinCoreNode, 'dc:' + Key);
    if (ValidNode(Node)) then
    begin
      DublinCoreNode.removeChild(Node);
    end;
    if (Key = 'creator') then
    begin
      Node := CreatePropertySeq('dc:' + Key, NewValue, DublinCoreURI);
    end else
    if ((Key = 'description') or (Key = 'title')) then
    begin
      Node := CreatePropertyLang('dc:' + Key, 'x-default', NewValue, DublinCoreURI);
    end else
    if (Key = 'subject') then
    begin
      if (NewValue <> '') then
      begin
        Node := CreatePropertyBag('dc:' + Key, NewValue, DublinCoreURI);
      end else
      begin
        Node := Unassigned;
      end;
    end else
    begin
      Node := CreateProperty('dc:' + Key, NewValue, DublinCoreURI);
    end;
    if ValidNode(Node) then
    begin
      DublinCoreNode.appendChild(Node);
    end;
  end;
end;

procedure TDebenuPDFLibraryXMP.SetXMPBasic(const Key, NewValue: WideString);
var
  XMPBasicNode: Variant;
  Node: Variant;
begin
  XMPBasicNode := FindNamespaceNode(XMPBasicURI);
  if (not ValidNode(XMPBasicNode)) then
  begin
    XMPBasicNode := FXMLDoc.createNode(1, 'rdf:Description', RDFURI);
    XMPBasicNode.setAttribute('xmlns:xmp', XMPBasicURI);
    FRDFNode.appendChild(XMPBasicNode);
  end;
  if (ValidNode(XMPBasicNode)) then
  begin
    Node := SelectNode(XMPBasicNode, 'xmp:' + Key);
    if (ValidNode(Node)) then
    begin
      XMPBasicNode.removeChild(Node);
    end;
    Node := CreateProperty('xmp:' + Key, NewValue, XMPBasicURI);
    XMPBasicNode.appendChild(Node);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetAdobePDF(const Key, NewValue: WideString);
var
  AdobePDFNode: Variant;
  Node: Variant;
begin
  AdobePDFNode := FindNamespaceNode(AdobePDFURI);
  if (not ValidNode(AdobePDFNode)) then
  begin
    AdobePDFNode := FXMLDoc.createNode(1, 'rdf:Description', RDFURI);
    AdobePDFNode.setAttribute('xmlns:pdf', AdobePDFURI);
    FRDFNode.appendChild(AdobePDFNode);
  end;
  if (ValidNode(AdobePDFNode)) then
  begin
    Node := SelectNode(AdobePDFNode, 'pdf:' + Key);
    if (ValidNode(Node)) then
    begin
      AdobePDFNode.removeChild(Node);
    end;
    Node := CreateProperty('pdf:' + Key, NewValue, AdobePDFURI);
    AdobePDFNode.appendChild(Node);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetPDFA(const Key, NewValue: WideString);
var
  PDFANode: Variant;
  Node: Variant;
begin
  PDFANode := FindNamespaceNode(PDFAURI);
  if (not ValidNode(PDFANode)) then
  begin
    PDFANode := FXMLDoc.createNode(1, 'rdf:Description', RDFURI);
    PDFANode.setAttribute('xmlns:pdfaid', PDFAURI);
    FRDFNode.appendChild(PDFANode);
  end;
  if (ValidNode(PDFANode)) then
  begin
    Node := SelectNode(PDFANode, 'pdfaid:' + Key);
    if (ValidNode(Node)) then
    begin
      PDFANode.removeChild(Node);
    end;
    Node := CreateProperty('pdfaid:' + Key, NewValue, PDFAURI);
    PDFANode.appendChild(Node);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetXPathNamespace;
begin
  if (not FError) then
  begin
    FXMLDoc.setProperty('SelectionLanguage', 'XPath');
    FXMLDoc.setProperty('SelectionNamespaces', 'xmlns:x="adobe:ns:meta/" ' +
      'xmlns:rdf="' + RDFURI + '" ' +
      'xmlns:xmp="' + XMPBasicURI + '" ' +
      'xmlns:dc="' + DublinCoreURI + '" ' +
      'xmlns:pdf="' + AdobePDFURI + '" ' +
      'xmlns:pdfaid="' + PDFAURI + '"');
  end;
end;

function TDebenuPDFLibraryXMP.SelectNode(const Parent: Variant;
  const XPath: WideString): Variant;
begin
  try
    Result := Parent.selectSingleNode(XPath);
  except
    Result := Null;
  end;
end;
{$ENDIF}

procedure TDebenuPDFLibraryXMP.SetAllProperties;
begin
  SetDublinCore('format', 'application/pdf');
  SetDublinCore('creator', FAuthor);
  SetDublinCore('description', FSubject);
  SetDublinCore('title', FTitle);

  SetXMPBasic('CreatorTool', FCreator);
  SetXMPBasic('CreateDate', FCreationDate);
  SetXMPBasic('ModifyDate', FModDate);

  SetAdobePDF('Keywords', FKeywords);
  SetAdobePDF('Producer', FProducer);
end;

procedure TDebenuPDFLibraryXMP.SetTitle(const NewTitle: WideString);
begin
  if ((not FError) and (NewTitle <> FTitle)) then
  begin
    FTitle := NewTitle;
    SetDublinCore('title', NewTitle);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetAuthor(const NewAuthor: WideString);
begin
  if ((not FError) and (NewAuthor <> FAuthor)) then
  begin
    FAuthor := NewAuthor;
    SetDublinCore('creator', NewAuthor);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetSubject(const NewSubject: WideString);
begin
  if ((not FError) and (NewSubject <> FSubject)) then
  begin
    FSubject := NewSubject;
    SetDublinCore('description', NewSubject);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetKeywords(const NewKeywords: WideString);
begin
  if ((not FError) and (NewKeywords <> FKeywords)) then
  begin
    FKeywords := NewKeywords;
    SetAdobePDF('Keywords', NewKeywords);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetCreator(const NewCreator: WideString);
begin
  if ((not FError) and (NewCreator <> FCreator)) then
  begin
    FCreator := NewCreator;
    SetXMPBasic('CreatorTool', NewCreator);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetProducer(const NewProducer: WideString);
begin
  if ((not FError) and (NewProducer <> FProducer)) then
  begin
    FProducer := NewProducer;
    SetAdobePDF('Producer', NewProducer);
  end;
end;

procedure TDebenuPDFLibraryXMP.SetCreationDate(const NewCreationDate: WideString);
var
  XMPDate: WideString;
begin
  if (not FError) then
  begin
    if (Copy(NewCreationDate, 1, 2) = 'D:') then
    begin
      XMPDate := Copy(NewCreationDate, 3, 4) + '-' +
        Copy(NewCreationDate, 7, 2) + '-' +
        Copy(NewCreationDate, 9, 2) + 'T' +
        Copy(NewCreationDate, 11, 2) + ':' +
        Copy(NewCreationDate, 13, 2) + ':' +
        Copy(NewCreationDate, 15, 5) + ':' +
        Copy(NewCreationDate, 21, 2);
      if (QPLEndsWith(AnsiString(XMPDate), 'Z:')) then
      begin
        Delete(XMPDate, Length(XMPDate), 1);
      end;
    end else
    begin
      XMPDate := NewCreationDate;
    end;
    if ((not FError) and (XMPDate <> FCreationDate)) then
    begin
      FCreationDate := XMPDate;
      SetXMPBasic('CreateDate', XMPDate);
    end;
  end;
end;

procedure TDebenuPDFLibraryXMP.SetModDate(const NewModDate: WideString);
var
  XMPDate: WideString;
begin
  if (not FError) then
  begin
    if (Copy(NewModDate, 1, 2) = 'D:') then
    begin
      XMPDate := Copy(NewModDate, 3, 4) + '-' +
        Copy(NewModDate, 7, 2) + '-' +
        Copy(NewModDate, 9, 2) + 'T' +
        Copy(NewModDate, 11, 2) + ':' +
        Copy(NewModDate, 13, 2) + ':' +
        Copy(NewModDate, 15, 5) + ':' +
        Copy(NewModDate, 21, 2);
      if (QPLEndsWith(AnsiString(XMPDate), 'Z:')) then
      begin
        Delete(XMPDate, Length(XMPDate), 1);
      end;
    end else
    begin
      XMPDate := NewModDate;
    end;
    if ((not FError) and (XMPDate <> FModDate)) then
    begin
      FModDate := XMPDate;
      SetXMPBasic('ModifyDate', XMPDate);
    end;
  end;
end;

procedure TDebenuPDFLibraryXMP.SetPDFAID(const NewPDFAID: WideString);
begin
  if ((not FError) and (NewPDFAID <> FPDFAID)) then
  begin
    FPDFAID := NewPDFAID;
    SetPDFA('part', Copy(NewPDFAID, 1, 1));
    SetPDFA('conformance', Copy(NewPDFAID, 2, 1));
  end;
end;

end.
