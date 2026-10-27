{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryXFA.pas                                }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryXFA;

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

type
  TPDFXFA = class
  private
    FFullXML: AnsiString;
    FDatasetsXML: AnsiString;
    FTemplateXML: AnsiString;
    FFullXMLChanged: Boolean;
    FDatasetsXMLChanged: Boolean;
    FTemplateXMLChanged: Boolean;
    FTemplateVersion: AnsiString;
    LastAddedName: AnsiString;
    function CreateXMLObject: Variant;
    function ValidNode(const Node: Variant): Boolean;
    function IncreasePredicate(const PredicateStr: AnsiString): AnsiString;
    function GetDatasetsXPath(const SOM: AnsiString): AnsiString;
    function GetTemplateXPath(const SOM: AnsiString): AnsiString;
    procedure SetFullXML(const NewFullXML: AnsiString);
    procedure SetDatasetsXML(const NewDatasetsXML: AnsiString);
    procedure SetTemplateXML(const NewTemplateXML: AnsiString);
    function GetValidXML: Boolean;
    function SelectNode(const XML: Variant; const XPath: AnsiString): Variant;
    function GetChildXPath(const FieldXPath, Child: AnsiString): AnsiString;
    procedure WalkNode(const Node: Variant; var NameList: AnsiString;
      const Prefix, Delimiter: AnsiString);
  public
    TXML: Variant;
    DXML: Variant;
    DNS: AnsiString;
    TNS: AnsiString;
    constructor Create;
    destructor Destroy; override;
    procedure ChangeTemplateXMLObject(const XML: Variant);
    procedure ChangeDatasetsXMLObject(const XML: Variant);
    function GetFieldValue(const XFAFieldName: AnsiString): WideString;
    procedure SetFieldValue(const XFAFieldName: AnsiString; const NewValue: WideString);
    function GetFieldAttribute(const XFAFieldName, Attribute: AnsiString): AnsiString;
    procedure SetFieldAttribute(const XFAFieldName, Attribute, NewValue: AnsiString);
    function FieldHasChild(const XFAFieldName, Child: AnsiString): Boolean;
    procedure CreateFieldChild(const XFAFieldName, Child: AnsiString);
    procedure DeleteFieldChild(const XFAFieldName, Child: AnsiString);
    function GetFieldChildAttribute(const XFAFieldName, Child, Attribute: AnsiString): AnsiString;
    procedure SetFieldChildAttribute(const XFAFieldName, Child, Attribute, NewValue: AnsiString);
    function GetFieldNames(const Delimiter: AnsiString): AnsiString;
    property FullXML: AnsiString read FFullXML write SetFullXML;
    property DatasetsXML: AnsiString read FDatasetsXML write SetDatasetsXML;
    property TemplateXML: AnsiString read FTemplateXML write SetTemplateXML;
    property FullXMLChanged: Boolean read FFullXMLChanged;
    property DatasetsXMLChanged: Boolean read FDatasetsXMLChanged;
    property TemplateXMLChanged: Boolean read FTemplateXMLChanged;
    property ValidXML: Boolean read GetValidXML;
  end;

implementation

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

{ TPDFXFA }

constructor TPDFXFA.Create;
begin
  TXML := Unassigned;
  DXML := Unassigned;
end;

destructor TPDFXFA.Destroy;
begin
  TXML := Unassigned;
  DXML := Unassigned;
  inherited;
end;

procedure TPDFXFA.ChangeDatasetsXMLObject(const XML: Variant);
begin
  if FFullXML <> '' then
  begin
    FFullXML := QPLUTF8Encode(XML.xml);
    FFullXMLChanged := True;
  end else
  begin
    FDatasetsXML := QPLUTF8Encode(XML.xml);
    FDatasetsXMLChanged := True;
  end;
end;

procedure TPDFXFA.ChangeTemplateXMLObject(const XML: Variant);
begin
  if FFullXML <> '' then
  begin
    FFullXML := QPLUTF8Encode(XML.xml);
    FFullXMLChanged := True;
  end else
  begin
    FTemplateXML := QPLUTF8Encode(XML.xml);
    FTemplateXMLChanged := True;
  end;
end;

procedure TPDFXFA.CreateFieldChild(const XFAFieldName, Child: AnsiString);
var
  Node: Variant;
  XPath: AnsiString;
  SL: TQuickPDFStringList;
  S: AnsiString;
  X: Integer;
  NewNode: Variant;
begin
  if not VarIsClear(TXML) then
  begin
    try
      SL := TQuickPDFStringList.Create;
      try
        S := Child;
        if QPLCopy(S, 1, 1) = '/' then Delete(S, 1, 1);
        if QPLCopy(S, Length(S), 1) <> '/' then S := S + '/';
        while QPLPos('/', S) > 0 do
        begin
          SL.Add(QPLCopy(S, 1, QPLPos('/', S) - 1));
          Delete(S, 1, QPLPos('/', S));
        end;
        XPath := GetTemplateXPath(XFAFieldName);
        for X := 0 to SL.Count - 1 do
        begin
          Node := SelectNode(TXML, XPath + '/xfa:' + SL[X]);
          if not validNode(Node) then
          begin
            Node := SelectNode(TXML, XPath);
            if validNode(Node) then
            begin
              NewNode := TXML.createNode(1, SL[X], Node.namespaceURI);
              Node.appendChild(NewNode);
            end;
          end;
          XPath := XPath + '/xfa:' + SL[X]
        end;
      finally
        SL.Free;
      end;
      FTemplateXMLChanged := True;
    finally
      Node := Unassigned;
      NewNode := Unassigned;
    end;
  end;
end;

procedure TPDFXFA.DeleteFieldChild(const XFAFieldName, Child: AnsiString);
var
  Node: Variant;
  XPath: AnsiString;
  KillNode: Variant;
  SL: TQuickPDFStringList;
  X: Integer;
  S: AnsiString;
begin
  if not VarIsClear(TXML) then
  begin
    try
      XPath := GetTemplateXPath(XFAFieldName);
      XPath := GetChildXPath(XPath, Child);
      SL := TQuickPDFStringList.Create;
      try
        S := Child;
        if QPLCopy(S, 1, 1) = '/' then Delete(S, 1, 1);
        if QPLCopy(S, Length(S), 1) <> '/' then S := S + '/';
        while QPLPos('/', S) > 0 do
        begin
          SL.Add(QPLCopy(S, 1, QPLPos('/', S) - 1));
          Delete(S, 1, QPLPos('/', S));
        end;
        XPath := GetTemplateXPath(XFAFieldName);
        for X := 0 to SL.Count - 2 do
          XPath := XPath + '/xfa:' + SL[X];
        Node := SelectNode(TXML, XPath);
        if validNode(Node) then
        begin
          KillNode := SelectNode(TXML, XPath + '/xfa:' + SL[SL.Count - 1]);
          if validNode(KillNode) then
            Node.removeChild(KillNode);
        end;
      finally
        SL.Free;
      end;
      FTemplateXMLChanged := True;
    finally
      KillNode := Unassigned;
      Node := Unassigned;
    end;
  end;
end;

function TPDFXFA.FieldHasChild(const XFAFieldName, Child: AnsiString): Boolean;
var
  Node: Variant;
  XPath: AnsiString;
begin
  Result := False;
  if not VarIsClear(TXML) then
  begin
    try
      XPath := GetTemplateXPath(XFAFieldName);
      XPath := GetChildXPath(XPath, Child);
      Node := SelectNode(TXML, XPath);
      if validNode(Node) then Result := True;
    finally
      Node := Unassigned;
    end;
  end;
end;

function TPDFXFA.GetChildXPath(const FieldXPath,
  Child: AnsiString): AnsiString;
var
  SL: TQuickPDFStringList;
  X: Integer;
  S: AnsiString;
begin
  SL := TQuickPDFStringList.Create;
  try
    S := Child;
    if QPLCopy(S, 1, 1) = '/' then Delete(S, 1, 1);
    if QPLCopy(S, Length(S), 1) <> '/' then S := S + '/';
    while QPLPos('/', S) > 0 do
    begin
      SL.Add(QPLCopy(S, 1, QPLPos('/', S) - 1));
      Delete(S, 1, QPLPos('/', S));
    end;
    Result := FieldXPath;
    for X := 0 to SL.Count - 1 do
      Result := Result + '/xfa:' + SL[X]
  finally
    SL.Free;
  end;
end;

function TPDFXFA.GetDatasetsXPath(const SOM: AnsiString): AnsiString;
var
  SL: TQuickPDFStringList;
  S: AnsiString;
  PredicateStr: AnsiString;
  X: Integer;
begin
  if FFullXML <> '' then
    DXML.setProperty('SelectionNamespaces', DNS);

  Result := '';
  S := SOM;
  SL := TQuickPDFStringList.Create;
  try
    while QPLPos('.', S) > 0 do
    begin
      SL.Add(QPLCopy(S, 1, QPLPos('.', S) - 1));
      Delete(S, 1, QPLPos('.', S));
    end;
    if S <> '' then
      SL.Add(S);
    if FFullXML <> '' then
      Result := '/xdp:xdp/xfa:datasets/xfa:data'
    else
      Result := '/xfa:datasets/xfa:data';
    for X := 0 to SL.Count - 1 do
    begin
      S := SL[X];
      if QPLPos('[', S) > 0 then
      begin
        PredicateStr := QPLCopy(S, QPLPos('[', S), MaxInt);
        S := QPLCopy(S, 1, QPLPos('[', S) - 1);
        S := S + IncreasePredicate(PredicateStr);
      end;
      if QPLCopy(S, 1, 1) <> '#' then
        Result := Result + '/' + S;
    end;
  finally
    SL.Free;
  end;
end;

function TPDFXFA.GetFieldAttribute(const XFAFieldName,
  Attribute: AnsiString): AnsiString;
var
  Node: Variant;
  XPath: AnsiString;
  AttributeValue: Variant;
begin
  Result := '';
  if not VarIsClear(TXML) then
  begin
    try
      XPath := GetTemplateXPath(XFAFieldName);
      Node := SelectNode(TXML, XPath);
      if validNode(Node) then
      begin
        AttributeValue := Node.getAttribute(Attribute);
        if not VarIsNull(AttributeValue) then
          Result := AnsiString(AttributeValue);
      end;
    finally
      Node := Unassigned;
    end;
  end;
end;

function TPDFXFA.GetFieldChildAttribute(const XFAFieldName, Child,
  Attribute: AnsiString): AnsiString;
var
  Node: Variant;
  XPath: AnsiString;
  AttributeValue: Variant;
begin
  if not VarIsClear(TXML) then
  begin
    try
      XPath := GetTemplateXPath(XFAFieldName);
      XPath := GetChildXPath(XPath, Child);
      Node := SelectNode(TXML, XPath);
      if validNode(Node) then
      begin
        AttributeValue := Node.getAttribute(Attribute);
        if not VarIsNull(AttributeValue) then
          Result := AnsiString(AttributeValue);
      end;
    finally
      Node := Unassigned;
      AttributeValue := Unassigned;
    end;
  end;
end;

procedure TPDFXFA.WalkNode(const Node: Variant; var NameList: AnsiString; const Prefix, Delimiter: AnsiString);
var
  FullNodeName: AnsiString;
  S: AnsiString;
  CanAdd: Boolean;
  CurNode: Variant;
begin
  if ValidNode(Node) then
  begin
    S := AnsiString(Node.nodeName);
    if (Length(S) > 0) and (S[1] <> '#') then
    begin
      FullNodeName := Prefix;
      if Prefix <> '' then
        FullNodeName := FullNodeName + '/';

      FullNodeName := FullNodeName + AnsiString(Node.nodeName);
    end;

    CanAdd := True;
    CurNode := Node.firstChild;
    while ValidNode(CurNode) do
    begin
      WalkNode(CurNode, NameList, FullNodeName, Delimiter);
      CurNode := CurNode.nextSibling;

      if ValidNode(CurNode) then  // Has valid children, don't add this one....
        CanAdd := False;
    end;

    if CanAdd and (QPLEndsWith(FullNodeName, '/value')) then
        FullNodeName := QPLCopy(FullNodeName, 1, Length(FullNodeName) - 6);

    if CanAdd and (FullNodeName <> '') and (FullNodeName <> LastAddedName) then
    begin
      NameList := NameList + FullNodeName + Delimiter;
      LastAddedName := FullNodeName;
    end;
  end;
end;

function TPDFXFA.GetFieldNames(const Delimiter: AnsiString): AnsiString;
var
  Node: Variant;
  XPath: AnsiString;
begin
  Result := '';
  if not VarIsClear(DXML) then
  begin
    try
      XPath := GetDatasetsXPath('');
      Node := SelectNode(DXML, XPath);
      if ValidNode(Node) then
      begin
        LastAddedName := '';
        if ValidNode(Node.firstChild) then
          WalkNode(Node.firstChild, Result, '', Delimiter);
      end;
    finally
      Node := Unassigned;
    end;
  end;
end;

function TPDFXFA.GetFieldValue(const XFAFieldName: AnsiString): WideString;
var
  Node: Variant;
  XPath: AnsiString;
begin
  Result := '';
  if not VarIsClear(DXML) then
  begin
    try
      XPath := GetDatasetsXPath(XFAFieldName);
      Node := SelectNode(DXML, XPath);

      if ValidNode(Node) then
      begin
        if ValidNode(Node.firstChild) then
        begin
          Node := Node.FirstChild;

          if (ValidNode(Node)) then
          begin
            if (Node.nodeType = 3) then
              Result := Result + Node.nodeValue
            else
            begin
              if (ValidNode(Node.FirstChild) and (Node.firstChild.nodeType = 3)) then
                Result := Result + Node.FirstChild.nodeValue;
            end;

            Node := Node.NextSibling;
            while (ValidNode(Node)) and (ValidNode(Node.FirstChild)) do
            begin
              Result := Result + '|' + Node.FirstChild.nodeValue;
              Node := Node.NextSibling;
            end;
          end;
        end;
      end;

      {
      if ValidNode(Node) then
      begin
        if ValidNode(Node.firstChild) and (Node.firstChild.nodeType = 3) then
        begin
          while ValidNode(Node) and ValidNode(Node.firstChild) do
          begin
            if Length(Result) <> 0 then
              Result := Result + '|';

            Result := Result + Node.firstChild.nodeValue;
            Node := Node.nextSibling;
          end;
        end;
      end;
      }
    finally
      Node := Unassigned;
    end;
  end;
end;

function TPDFXFA.GetTemplateXPath(const SOM: AnsiString): AnsiString;
var
  SL: TQuickPDFStringList;
  S: AnsiString;
  X: Integer;
  Predicate: AnsiString;
  NodeName: AnsiString;
begin
  if FFullXML <> '' then
    TXML.setProperty('SelectionNamespaces', TNS);

  Result := '';
  S := SOM;
  SL := TQuickPDFStringList.Create;
  try
    while QPLPos('.', S) > 0 do
    begin
      SL.Add(QPLCopy(S, 1, QPLPos('.', S) - 1));
      Delete(S, 1, QPLPos('.', S));
    end;
    if S <> '' then
      SL.Add(S);
    if FFullXML <> '' then
      Result := '/xdp:xdp/xfa:template'
    else
      Result := '/xfa:template';
    for X := 0 to SL.Count - 1 do
    begin
      if QPLPos('[', SL[X]) > 0 then
      begin
        NodeName := QPLCopy(SL[X], 1, QPLPos('[', SL[X]) - 1);
        Predicate := QPLCopy(SL[X], QPLPos('[', SL[X]), MaxInt);
        Predicate := IncreasePredicate(Predicate);
      end else
      begin
        Predicate := '';
        NodeName := SL[X];
      end;
      if X < (SL.Count - 1) then
      begin
        if QPLCopy(NodeName, 1, 1) = '#' then
          Result := Result + '/xfa:' + QPLCopy(NodeName, 2, MaxInt) + Predicate
        else
          Result := Result + '/xfa:subform[@name=''' + NodeName + ''']' + Predicate;
      end else
        Result := Result + '/xfa:field[@name=''' + NodeName + ''']' + Predicate;
    end;
  finally
    SL.Free;
  end;
end;

function TPDFXFA.GetValidXML: Boolean;
var
  Node: Variant;
  TestMajor: Integer;
  TestMinor: Integer;
  TestVersion: AnsiString;
  NS: AnsiString;
begin
  if (VarIsEmpty(DXML)) then
  begin
    DXML := CreateXMLObject;
  end;

  NS :=  'xmlns:xdp="http://ns.adobe.com/xdp/"';
  DNS :=  NS + ' ' + 'xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/"';

  if FFullXML <> '' then
    Result := DXML.loadXML(QPLUTF8Decode(FFullXML))
  else
    Result := DXML.loadXML(QPLUTF8Decode(FDatasetsXML));

  // Datasets code
  if (Result) then
  begin
    {$IFDEF QPL_OS_WINDOWS}
    DXML.setProperty('SelectionLanguage', 'XPath');
    DXML.setProperty('SelectionNamespaces', DNS);
    {$ENDIF}
  end;

  Node := SelectNode(DXML, '/xdp:xdp/xfa:datasets');
  if not validNode(Node) then
    Node := SelectNode(DXML, 'xfa:datasets');

  if not validNode(Node)
    then Result := False;

  if FFullXML <> '' then
    TXML := DXML
  else
  begin
    TXML := CreateXMLObject;
    Result := TXML.loadXML(QPLUTF8Decode(FTemplateXML));
  end;

  // Template code
  if (Result) then
  begin

    TestMajor := 2;
    TestMinor := 0;
    while (FTemplateVersion = '') and (TestMajor < 4) do
    begin
      Inc(TestMinor);
      if (TestMinor > 9) then
      begin
        TestMinor := 0;
        Inc(TestMajor);
      end;
      TestVersion := QPLIntToStr(TestMajor) + '.' + QPLIntToStr(TestMinor);
      TNS := NS + ' ' + 'xmlns:xfa="http://www.xfa.org/schema/xfa-template/' + TestVersion + '/"';

      {$IFDEF QPL_OS_WINDOWS}
      TXML.setProperty('SelectionNamespaces', TNS);
      {$ENDIF}

      Node := SelectNode(TXML, '/xdp:xdp/xfa:template');
      if not validNode(Node) then
        Node := SelectNode(TXML, 'xfa:template');

      if (validNode(Node)) then
        FTemplateVersion := TestVersion;
    end;
  end;

  if (FTemplateVersion = '') then
    Result := False;

  Node := Unassigned;
end;

function TPDFXFA.IncreasePredicate(const PredicateStr: AnsiString): AnsiString;
var
  S: AnsiString;
begin
  Result := PredicateStr;
  S := PredicateStr;
  if QPLCopy(S, 1, 1) = '[' then
  begin
    Delete(S, 1, 1);
    if QPLPos(']', S) > 0 then
    begin
      Delete(S, QPLPos(']', S), MaxInt);
      Result := '[' + QPLIntToStr(QPLStrToIntDef(S, 0) + 1) + ']';
    end;
  end;
end;

function TPDFXFA.SelectNode(const XML: Variant; const XPath: AnsiString): Variant;
begin
  try
    Result := XML.selectSingleNode(XPath);
  except
    Result := Null;
  end;
end;

procedure TPDFXFA.SetDatasetsXML(const NewDatasetsXML: AnsiString);
begin
  FDatasetsXML := NewDatasetsXML;
  FDatasetsXMLChanged := False;
end;

procedure TPDFXFA.SetFieldAttribute(const XFAFieldName, Attribute,
  NewValue: AnsiString);
var
  Node: Variant;
  XPath: AnsiString;
begin
  if not VarIsClear(TXML) then
  begin
    try
      XPath := GetTemplateXPath(XFAFieldName);
      Node := SelectNode(TXML, XPath);
      if validNode(Node) then
        Node.setAttribute(Attribute, NewValue);
      FTemplateXMLChanged := True;
    finally
      Node := Unassigned;
    end;
  end;
end;

procedure TPDFXFA.SetFieldChildAttribute(const XFAFieldName, Child,
  Attribute, NewValue: AnsiString);
var
  Node: Variant;
  XPath: AnsiString;
begin
  if not VarIsClear(TXML) then
  begin
    try
      XPath := GetTemplateXPath(XFAFieldName);
      XPath := GetChildXPath(XPath, Child);
      Node := SelectNode(TXML, XPath);
      if validNode(Node) then
        Node.setAttribute(Attribute, NewValue);
      FTemplateXMLChanged := True;
    finally
      Node := Unassigned;
    end;
  end;
end;

procedure TPDFXFA.SetFieldValue(const XFAFieldName: AnsiString; const NewValue: WideString);
var
  Node, NewNode: Variant;
  XPath: AnsiString;
  NodeName: AnsiString;
  I: Integer;

begin
  if not VarIsClear(DXML) then
  begin
    try
      XPath := GetDatasetsXPath(XFAFieldName);
      Node := SelectNode(DXML, XPath);
      if ValidNode(Node) then
        if validnode(Node.firstChild) then
        begin
          if Node.firstChild.nodeType = 3 then
            Node.firstChild.nodeValue := NewValue
          else if Node.firstChild.nodeType = 1 then           // Array for Listbox entries
          begin
            NodeName := AnsiString(Node.firstChild.NodeName); // usually 'value' for a Listbox

            while ValidNode(Node.firstChild) do
              Node.removeChild(Node.firstChild);

            for I := 1 to GetWideTokCount(NewValue, '|') do
            begin
              NewNode := TXML.createNode(1, NodeName, Node.namespaceURI); //
              Node.appendChild(NewNode);
              NewNode.appendchild(DXML.createTextNode(GetWideTok(NewValue, '|', I)));
            end;
          end;

        end else
          Node.appendchild(DXML.createTextNode(NewValue));
      FDatasetsXMLChanged := True;
    finally
      Node := Unassigned;
    end;
  end;
end;

procedure TPDFXFA.SetFullXML(const NewFullXML: AnsiString);
begin
  FFullXML := NewFullXML;
  FFullXMLChanged := False;
end;

procedure TPDFXFA.SetTemplateXML(const NewTemplateXML: AnsiString);
begin
  FTemplateXML := NewTemplateXML;
  FTemplateXMLChanged := False;
end;

function TPDFXFA.ValidNode(const Node: Variant): Boolean;
begin
  Result := (not VarIsClear(Node)) and (not VarIsNull(Node));
end;

function TPDFXFA.CreateXMLObject: Variant;
begin
  try
{$IFDEF QPL_OS_WINDOWS}
    Result := CreateOleObject('MSXML2.DOMDocument');
    if (DPLClassExists('MSXML2.DOMDocument.6.0')) then
    begin
      Result := CreateOleObject('MSXML2.DOMDocument.6.0');
    end else
    if (DPLClassExists('MSXML2.DOMDocument.3.0')) then
    begin
      Result := CreateOleObject('MSXML2.DOMDocument.3.0');
    end else
    if (DPLClassExists('MSXML2.DOMDocument')) then
    begin
      Result := CreateOleObject('MSXML2.DOMDocument');
    end else
    begin
      Result := Unassigned;
    end;
{$ENDIF}
  except
    Result := Unassigned;
  end;
end;

end.
