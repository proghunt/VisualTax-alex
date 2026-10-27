{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryStructure.pas                          }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryStructure;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryExtra, Classes, DebenuPDFLibraryTypes;

type
  TQuickPDFProgressEvent = procedure(Progress: Integer) of object;

  TPDFObject = class;
  TPDFDictionary = class;
  TPDFName = class;
  TPDFBoolean = class;
  TPDFNumeric = class;
  TPDFString = class;
  TPDFArray = class;
  TPDFStream = class;
  TPDFIndRef = class;
  TPDFNull = class;

  TPDFFindObjectEvent = function(Ref: TPDFIndRef): TPDFObject of object;
  TPDFCryptStreamEvent = procedure(Source: TPDFStream; Ref: TPDFIndRef) of object;

  TPDFStringMode = (smLiteral, smHex);

  TIndObjLookupEvent = procedure (Sender: TObject; ObjNum, GenNum: Integer;
    var Obj: TPDFObject) of object;
  TNewIndObjEvent = procedure (Sender: TObject; var ObjNum, GenNum: Integer;
    Obj: TPDFObject) of object;

  TPDFStructure = class
  private
    Reserved: Integer;
    Objects: array of TPDFObject;
    FOnIndObjLookup: TIndObjLookupEvent;
    FOnNewIndObj: TNewIndObjEvent;
  public
    OldFormat: Boolean;
    PDFPrecision: AnsiString;
    PDFPrecNum: Integer;
    function KillWhitespace(const OrigS: AnsiString): AnsiString;
    procedure AddObject(Obj: TPDFObject);
    procedure RemoveObject(Obj: TPDFObject);
    function NewName(const Value: AnsiString): TPDFName;
    function NewCommonName(const Value: AnsiString): TPDFName;
    function NewNull: TPDFNull;
    function NewBoolean(const Value: Boolean): TPDFBoolean;
    function NewNumeric(const Value: Double): TPDFNumeric;
    function NewString(const Value: AnsiString; Mode: TPDFStringMode = smLiteral): TPDFString;
    function NewTextString(const Value: WideString): TPDFString;
    function NewArray(const Value: array of TPDFObject): TPDFArray; overload;
    function NewIntArray(const Value: array of Integer): TPDFArray;
    function NewDoubleArray(const Value: array of Double): TPDFArray;
    function NewArray: TPDFArray; overload;
    function NewStream(const Value: AnsiString; Compress: Boolean = False): TPDFStream; overload;
    function NewStream(const Value: TQPLByteArray; Compress: Boolean = False): TPDFStream; overload;
    function NewStreamWithDict(const Value: AnsiString; StreamDict: TPDFDictionary): TPDFStream;
    function NewTextStream(const Value: WideString; Compress: Boolean = False): TPDFStream;
    function NewIndirectRef(ObjNum, GenNum: Integer): TPDFIndRef;
    function NewDictionary: TPDFDictionary;
    function DecodeWithLength(const Source: AnsiString; var ObjectLength: Integer; StartPos: Integer = 1): TPDFObject;
    function Decode(const Source: AnsiString): TPDFObject;
    function DecodeString(const Source: AnsiString): AnsiString;
    function DecodeHex(const Source: AnsiString): AnsiString;
    function FindName(const Name: AnsiString): TPDFName;
    procedure ShiftIndRef(Offset: Integer; ZeroGen: Boolean);
    procedure ReplaceIndRef(AddedObjects: TQuickPDFStringList; Offset: Integer);
    procedure Clear;
    constructor Create; virtual;
    destructor Destroy; override;
    function GetObjectCount: Integer;
    function GetObject(Index: Integer): TPDFObject;
    procedure ReserveObjects(Count: Integer);
    property AnObject[Index: Integer]: TPDFObject read GetObject;
    property OnIndObjLookup: TIndObjLookupEvent read FOnIndObjLookup write
      FOnIndObjLookup;
    property OnNewIndObj: TNewIndObjEvent read FOnNewIndObj write FOnNewIndObj;
    property ObjectCount: Integer read GetObjectCount;
  end;

  TPDFObject = class
  protected
    FOwner: TPDFStructure;
    FIsIndirect: Boolean;
    FIndObjNum: Integer;
    FIndGenNum: Integer;
    FChanged: Boolean;
    function GetHasChanged: Boolean; virtual;
  public
    SpyType: AnsiChar;
    function Output: AnsiString; virtual; abstract;
    constructor Create(AOwner: TPDFStructure); virtual;
    procedure Purge; virtual;
    procedure Own(ObjNum, GenNum: Integer);
    procedure ShiftIndRef(Offset: Integer); virtual;     
    function HasChild(AObject: TPDFObject): Boolean; virtual;
    procedure SetChanged(HasChanged: Boolean);
    property HasChanged: Boolean read GetHasChanged;
    property Owner: TPDFStructure read FOwner;
    property IsIndirect: Boolean read FIsIndirect;
    property IndObjNum: Integer read FIndObjNum;
    property IndGenNum: Integer read FIndGenNum;
  end;

  TPDFNameTree = class
  private
    FRoot: TPDFDictionary;
    FStructure: TPDFStructure;
    FSingleNode: Boolean;
    Arrays: array of TPDFArray;
    Dicts: array of TPDFDictionary;
    function FindIndex(const Name: AnsiString): Integer;
    procedure ProcessNode(NodeDict: TPDFDictionary);
    procedure RemoveEmptyKidsNodes(NodeDict: TPDFDictionary);
  public
    constructor Create(Parent: TPDFStructure; Root: TPDFDictionary);
    procedure AddKey(const Name: AnsiString; Value: TPDFIndRef);
    function HasKey(const Name: AnsiString): Boolean;
    function FindKey(const Name: AnsiString): TPDFIndRef;
    function DeleteKey(const Name: AnsiString): Boolean;
    function KeyCount: Integer;
    function KeyName(Index: Integer): AnsiString;
  end;

  TPDFName = class(TPDFObject)
  private
    FValue: AnsiString;
    FCommon: Boolean;
  public
    constructor Create(AOwner: TPDFStructure); override;
    function Output: AnsiString; override;
    procedure SetTo(const Value: AnsiString);
    property Name: AnsiString read FValue;
  end;

  TPDFEntry = record
    Key: TPDFName;
    Value: TPDFObject;
  end;

  TPDFDictionary = class(TPDFObject)
  private
    Entries: array of TPDFEntry;
  protected
    procedure AddEntry(Entry: TPDFEntry);
    function GetCount: Integer;
    function GetEntry(Index: Integer): TPDFEntry;
    function GetHasChanged: Boolean; override;
  public
    constructor Create(AOwner: TPDFStructure); override;
    procedure Assign(Dict: TPDFDictionary);
    property Count: Integer read GetCount;
    property Entry[Index: Integer]: TPDFEntry read GetEntry;
    function DictType: AnsiString;
    function Output: AnsiString; override;
    function FindValueByKeyName(const Key: AnsiString; FollowRef: Boolean = False): TPDFObject;
    function FindIndexByKeyName(const Key: AnsiString): Integer;
    function IntValue(const Key: AnsiString; Default: Integer = 0): Integer;
    function StringValue(const Key: AnsiString): AnsiString;
    procedure Add(const KeyName: AnsiString; Value: TPDFObject);
    procedure DeleteEntryByKeyName(const Key: AnsiString);
    procedure PurgeKey(const Key: AnsiString);
    procedure AddDict(Dict: TPDFDictionary);
    procedure Clear;
    procedure RemoveKeys;
    procedure Purge; override;
    function HasChild(AObject: TPDFObject): Boolean; override;
    procedure ShiftIndRef(Offset: Integer); override;
    procedure RenameKey(const OldName, NewName: AnsiString);
  end;

  TPDFNull = class(TPDFObject)
  public
    constructor Create(AOwner: TPDFStructure); override;
    function Output: AnsiString; override;
  end;

  TPDFBoolean = class(TPDFObject)
  private
    FValue: Boolean;
  public
    constructor Create(AOwner: TPDFStructure); override;
    function Output: AnsiString; override;
    function AsBoolean: Boolean;
    procedure SetTo(const Value: Boolean);
  end;

  TPDFNumeric = class(TPDFObject)
  private
    FValue: Double;
  public
    constructor Create(AOwner: TPDFStructure); override;
    function Output: AnsiString; override;
    function AsDouble: Double;
    function AsInteger: Integer;
    procedure SetTo(const Value: Double);
  end;

  TPDFString = class(TPDFObject)
  private
    FValue: AnsiString;
  public
    StringMode: TPDFStringMode;
    constructor Create(AOwner: TPDFStructure); override;
    function Output: AnsiString; override;
    function AsString: AnsiString;
    function AsTextString: WideString;
    procedure SetTo(const Value: AnsiString);
    procedure SetToTextString(const Value: WideString);
  end;

  TPDFArray = class(TPDFObject)
  private
    Reserved: Integer;
    Items: array of TPDFObject;
    function GetCount: Integer;
    function GetItem(Index: Integer): TPDFObject;
  protected
    function GetHasChanged: Boolean; override;
  public
    function Output: AnsiString; override;
    procedure Add(Value: TPDFObject);
    procedure Insert(Index: Integer; Value: TPDFObject);
    property Item[Index: Integer]: TPDFObject read GetItem;
    procedure Replace(Index: Integer; Obj: TPDFObject);
    procedure ReplaceNoKill(Index: Integer; Obj: TPDFObject);
    procedure Delete(Index: Integer);
    procedure DeleteObj(Obj: TPDFObject; ByOutput: Boolean = False);
    procedure Move(Index, NewPos: Integer);
    procedure Clear;
    procedure ReserveItems(Count: Integer);
    procedure Purge; override;
    constructor Create(AOwner: TPDFStructure); override;
    function HasChild(AObject: TPDFObject): Boolean; override;
    function HasMatchingChild(const Test: AnsiString): Boolean;
    function ItemIndexMatch(AObject: TPDFObject): Integer;
    function AllItemsNumeric: Boolean;
    procedure ShiftIndRef(Offset: Integer); override;
    property Count: Integer read GetCount;
  end;

  TPDFDimension = (pdLeft, pdTop, pdWidth, pdHeight, pdRight, pdBottom);

  TPDFRectangle = class
  protected
    FArray: TPDFArray;
    FLLX: TPDFNumeric;
    FLLY: TPDFNumeric;
    FURX: TPDFNumeric;
    FURY: TPDFNumeric;
    function GetWidth: Double;
    function GetHeight: Double;
    function GetLeft: Double;
    function GetTop: Double;
    function GetBottom: Double;
    function GetRight: Double;
    procedure SetBottom(NewBottom: Double);
    procedure SetRight(NewRight: Double);
    procedure SetLeft(NewLeft: Double);
    procedure SetTop(NewTop: Double);
  public
    constructor Create(AArray: TPDFArray);
    function IsRectangle: Boolean;
    function GetDimension(Dimension: TPDFDimension): Double;
    property Width: Double read GetWidth;
    property Height: Double read GetHeight;
    property Left: Double read GetLeft write SetLeft;
    property Top: Double read GetTop write SetTop;
    property Bottom: Double read GetBottom write SetBottom;
    property Right: Double read GetRight write SetRight;
  end;

  TPDFStream = class(TPDFObject)
  private
    FDictionary: TPDFDictionary;
    FStream: AnsiString;
    FLinkedObject: TObject;
    procedure SetStream(const NewStream: AnsiString);
  public
    function Output: AnsiString; override;
    constructor Create(AOwner: TPDFStructure); override;
    constructor CreateFull(AOwner: TPDFStructure; const Content: AnsiString;
      StreamDict: TPDFDictionary);
    procedure SetDict(NewDictionary: TPDFDictionary);
    procedure SetTo(NewStream: AnsiString; Compress: Boolean = False);
    procedure SetToTextString(NewStream: WideString; Compress: Boolean = False);
    procedure Purge; override;
    function HasChild(AObject: TPDFObject): Boolean; override;
    function GetDecodedStream: AnsiString;
    function GetDecodedStreamWithLookup(Lookup: TPDFFindObjectEvent): AnsiString;
    function GetDecodedTextStream: WideString;
    procedure ShiftIndRef(Offset: Integer); override;
    procedure ReadFromStream(Stream: TStream; Deflate: Boolean = False);
    property Dictionary: TPDFDictionary read FDictionary;
    property Stream: AnsiString read FStream write SetStream;
    property LinkedObject: TObject read FLinkedObject write FLinkedObject;
  end;

  TPDFIndRef = class(TPDFObject)
  public
    GenNum: Integer;
    ObjNum: Integer;
    function Output: AnsiString; override;
    function Obj: TPDFObject;
    constructor Create(AOwner: TPDFStructure); override;
    procedure ShiftIndRef(Offset: Integer); override;
    procedure CopyRef(Source: TPDFIndRef);
  end;

  TDPLTreeBalancer = class
  private
    FOnNewIndObj: TNewIndObjEvent;
    FOnIndObjLookup: TIndObjLookupEvent;
    FStructure: TPDFStructure;
  public
    constructor Create;
    function Balance(Pages: array of TPDFIndRef; NodeSize: Integer): TPDFIndRef;
    property Structure: TPDFStructure read FStructure write FStructure;
    property OnNewIndObj: TNewIndObjEvent read FOnNewIndObj write FOnNewIndObj;
    property OnIndObjLookup: TIndObjLookupEvent read FOnIndObjLookup write FOnIndObjLookup;
  end;

function SODecodeHex(const Source: AnsiString): AnsiString;
function RLEDecode(const Input: AnsiString): AnsiString;

implementation

uses
  SysUtils, DebenuPDFLibraryFlate, DebenuPDFLibraryAscii85, DebenuPDFLibraryDigest, DebenuPDFLibraryLZW,
  DebenuPDFLibraryEncoding;

const
  PreDef: AnsiString = '[MediaBox][Length][CropBox][Type][Subtype][Name][Pages][Page][Parent]' +
   '[Font][Contents][BaseFont][PDF][Text][ImageB][ImageC][ImageI][Resources][ProcSet]' +
   '[ExtGState][Type1][TrueType][WinAnsiEncoding][Filter][FlateDecode][Annot][URI]' +
   '[Goto][XYZ][iSQP][QuickPDF]';

function SODecodeHex(const Source: AnsiString): AnsiString;
var
  X: Integer;
  HS: AnsiString;
begin
  Result := '';
  if (QPLCopy(Source, 1, 1) = '<') and (QPLCopy(Source, Length(Source), 1) = '>') then
  begin
    HS := '';
    for X := 2 to Length(Source) - 1 do
    begin
      if ((Source[X] >= 'A') and (Source[X] <= 'Z')) or
        ((Source[X] >= 'a') and (Source[X] <= 'z')) or
        ((Source[X] >= '0') and (Source[X] <= '9')) then
          HS := HS + UpCase(Source[X]);
    end;
    if Length(HS) mod 2 = 1 then HS := HS + '0';
    for X := 1 to Length(HS) div 2 do
      Result := Result + AnsiChar(QPLStrToIntDef('$' + QPLCopy(HS, X * 2 - 1, 2), 0));
  end;
end;   

{ TPDFBoolean }

function TPDFBoolean.AsBoolean: Boolean;
begin
  Result := FValue;
end;

constructor TPDFBoolean.Create(AOwner: TPDFStructure);
begin
  inherited Create(AOwner);
  SpyType := 'B';
end;

function TPDFBoolean.Output: AnsiString;
begin
  if FValue then Result := 'true' else Result := 'false';
end;

procedure TPDFBoolean.SetTo(const Value: Boolean);
begin
  FValue := Value;
end;

{ TPDFDictionary }

procedure TPDFDictionary.AddEntry(Entry: TPDFEntry);
var
  Len: Integer;
  Index: Integer;
begin
  Index := FindIndexByKeyName(Entry.Key.Name);
  if Index < 0 then
  begin
    Len := Length(Entries);
    SetLength(Entries, Len + 1);
    Entries[Len] := Entry;
  end else
    Entries[Index] := Entry;
  FChanged := True;
end;

procedure TPDFDictionary.Add(const KeyName: AnsiString;
  Value: TPDFObject);
var
  Entry: TPDFEntry;
begin
  if Value <> Self then
  begin
    Entry.Key := FOwner.NewCommonName(KeyName);
    Entry.Value := Value;
    AddEntry(Entry);
  end;
  FChanged := True;
end;

function TPDFDictionary.Output: AnsiString;
var
  X: Integer;
  Len: Integer;
  KeyOutput: AnsiString;
  ValueOutput: AnsiString;
begin
  Len := Length(Entries);
  Result := '<<';
  if (Len > 1) or (FOwner.OldFormat) then Result := Result + #10 else Result := Result + ' ';
  for X := 0 to Len - 1 do
  begin
    try
      KeyOutput := '';
      ValueOutput := '';
      if Assigned(Entries[X].Key) then
        KeyOutput := Entries[X].Key.Output
      else
        KeyOutput := '';
      if Assigned(Entries[X].Value) then
        ValueOutput := Entries[X].Value.Output
      else
        ValueOutput := '';
      Result := Result + KeyOutput + ' ' + ValueOutput;
      if (QPLCopy(Result, Length(Result), 1) <> #10) and ((Len > 1) or FOwner.OldFormat) then
        Result := Result + #10;
    except
      Result := Result + '% bug '#10;
    end;
  end;
  if (Len = 1) and (not FOwner.OldFormat) then
    Result := Result + ' ';
  Result := Result + '>>' + #10;
end;

function TPDFDictionary.FindIndexByKeyName(const Key: AnsiString): Integer;
var
  X: Integer;
begin
  Result := -1;
  X := 0;
  while (Result < 0) and (X < Length(Entries)) do
    if Entries[X].Key.Name = Key then
      Result := X
    else
      Inc(X);
end;

function TPDFDictionary.FindValueByKeyName(const Key: AnsiString; FollowRef: Boolean): TPDFObject;
var
  Index: Integer;
begin
  Index := FindIndexByKeyName(Key);
  if Index >= 0 then
    Result := Entries[Index].Value
  else
    Result := nil;
  if FollowRef and (Result is TPDFIndRef) then Result := TPDFIndRef(Result).Obj;
end;

procedure TPDFDictionary.Assign(Dict: TPDFDictionary);
var
  X: Integer;
  Obj: TPDFObject;
begin
  if Dict.Owner = FOwner then
  begin
    SetLength(Entries, Dict.Count);
    for X := 0 to Dict.Count - 1 do
      Entries[X] := Dict.Entry[X];
  end else
  begin
    Obj := FOwner.Decode(Dict.Output);
    if Obj is TPDFDictionary then
      Assign(TPDFDictionary(Obj));
  end;
  FChanged := True;
end;

function TPDFDictionary.GetCount: Integer;
begin
  Result := Length(Entries);
end;

function TPDFDictionary.GetEntry(Index: Integer): TPDFEntry;
begin
  if (Index >= 0) and (Index < Length(Entries)) then
    Result := Entries[Index]
  else
  begin
    Result.Key := nil;
    Result.Value := nil;
  end;
end;

function TPDFDictionary.GetHasChanged: Boolean;
var
  X: Integer;
begin
  Result := FChanged;
  X := 0;
  while (not Result) and (X < Length(Entries)) do
  begin
    if (Entries[X].Value.HasChanged) then
    begin
      Result := True;
    end;
    Inc(X);
  end;
end;

procedure TPDFDictionary.DeleteEntryByKeyName(const Key: AnsiString);
var
  Index: Integer;
  X: Integer;
begin
  Index := FindIndexByKeyName(Key);
  if Index >= 0 then
  begin
    for X := Index to Length(Entries) - 2 do
      Entries[X] := Entries[X + 1];
    SetLength(Entries, Length(Entries) - 1);
    FChanged := True;
  end;
end;

procedure TPDFDictionary.AddDict(Dict: TPDFDictionary);
var
  X: Integer;
  Obj: TPDFObject;
  Len: Integer;
begin
  if Dict.Owner = FOwner then
  begin
    for X := 0 to Dict.Count - 1 do
    begin
      if FindIndexByKeyName(Dict.Entry[X].Key.Name) < 0 then
      begin
        Len := Length(Entries);
        SetLength(Entries, Len + 1);
        Entries[Len] := Dict.Entry[X];
        FChanged := True;
      end;
    end;
  end else
  begin
    Obj := FOwner.Decode(Dict.Output);
    if Obj is TPDFDictionary then
      AddDict(TPDFDictionary(Obj));
  end;
end;

function TPDFDictionary.DictType: AnsiString;
var
  Obj: TPDFObject;
begin
  Obj := FindValueByKeyName('Type');
  if Obj is TPDFName then
    Result := TPDFName(Obj).Name
  else
    Result := '';
end;

function TPDFDictionary.IntValue(const Key: AnsiString;
  Default: Integer): Integer;
var
  Obj: TPDFObject;
begin
  Obj := FindValueByKeyName(Key);

  if Obj is TPDFIndRef then
    Obj := TPDFIndRef(Obj).Obj;

  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger
  else
    Result := Default;
end;

procedure TPDFDictionary.PurgeKey(const Key: AnsiString);
var
  Index: Integer;
  X: Integer;
begin
  Index := FindIndexByKeyName(Key);
  if Index >= 0 then
  begin
    if (Entries[Index].Value is TPDFDictionary) or
      (Entries[Index].Value is TPDFArray) then
        Entries[Index].Value.Purge;

    if QPLPos('[' + Key + ']', PreDef) = 0 then
      Owner.RemoveObject(Entries[Index].Key);
    for X := Index to Length(Entries) - 2 do
      Entries[X] := Entries[X + 1];
    SetLength(Entries, Length(Entries) - 1);
    FChanged := True;
  end;
end;

procedure TPDFDictionary.RemoveKeys;
begin
  SetLength(Entries, 0);
end;

procedure TPDFDictionary.RenameKey(const OldName, NewName: AnsiString);
var
  X: Integer;
begin
  for X := 0 to Length(Entries) - 1 do
  begin
    if (Entries[X].Key.Name = OldName) then
    begin
      Entries[X].Key.SetTo(NewName);
      FChanged := True;
    end;
  end;
end;

procedure TPDFDictionary.Clear;
var
  X: Integer;
begin
  for X := 0 to Length(Entries) - 1 do
  begin
    FOwner.RemoveObject(Entries[X].Key);
    FOwner.RemoveObject(Entries[X].Value);
  end;
  SetLength(Entries, 0);
  FChanged := True;
end;

procedure TPDFDictionary.Purge;
var
  X: Integer;
begin
  for X := 0 to Length(Entries) - 1 do
  begin
    if Assigned(Entries[X].Key) then Entries[X].Key.Purge;
    if Assigned(Entries[X].Value) then Entries[X].Value.Purge;
  end;
  FChanged := True;
  inherited;
end;

function TPDFDictionary.StringValue(const Key: AnsiString): AnsiString;
var
  Obj: TPDFObject;
begin
  Result := '';
  Obj := FindValueByKeyName(Key);

  if Obj is TPDFIndRef then
    Obj := TPDFIndRef(Obj).Obj;

  if Obj is TPDFName then Result := TPDFName(Obj).Name;
  if Obj is TPDFString then Result := TPDFString(Obj).AsString;
  if Obj is TPDFArray then Result := TPDFArray(Obj).Output;  
end;

constructor TPDFDictionary.Create(AOwner: TPDFStructure);
begin
  inherited;
  SpyType := 'D';
end;

function TPDFDictionary.HasChild(AObject: TPDFObject): Boolean;
var
  X: Integer;
begin
  Result := False;
  for X := 0 to Length(Entries) - 1 do
  begin
    if Entries[X].Key = AObject then Result := True;
    if Entries[X].Value = AObject then Result := True;
  end;
end;

procedure TPDFDictionary.ShiftIndRef(Offset: Integer);
var
  X: Integer;
begin
  for X := 0 to Length(Entries) - 1 do
    Entries[X].Value.ShiftIndRef(Offset);
  FChanged := True;
end;

{ TPDFName }

constructor TPDFName.Create(AOwner: TPDFStructure);
begin
  inherited;
  FCommon := False;
  SpyType := 'N';
end;

function TPDFName.Output: AnsiString;
var
  X: Integer;
begin
  Result := '/';
  for X := 1 to Length(FValue) do
    if (FValue[X] > #32) and (FValue[X] < #127) and
      (FValue[X] <> #47) and (FValue[X] <> #40) and
      (FValue[X] <> #41) and (FValue[X] <> #35) and
      (FValue[X] <> #37) and (FValue[X] <> #91) and
      (FValue[X] <> #123) and (FValue[X] <> #125) and
      (FValue[X] <> #93) and (FValue[X] <> #60) and
      (FValue[X] <> #62) then
        Result := Result + FValue[X]
    else
      Result := Result + '#' + QPLUpperCase(QPLIntToHex(Ord(FValue[X]), 2));
end;

procedure TPDFName.SetTo(const Value: AnsiString);
begin
  FValue := Value;
  FChanged := True;
end;

{ TPDFStructure }

procedure TPDFStructure.AddObject(Obj: TPDFObject);
begin
  // Make sure there are at least 1000 reserved objects
  if Reserved < 100 then
  begin
    ReserveObjects(1000);
  end;

  // Add the new object at the end of the list of valid objects and then
  // decrement Reserved (effectively increments the number of valid objects)
  Objects[Length(Objects) - Reserved] := Obj;
  Dec(Reserved);
end;

constructor TPDFStructure.Create;
begin
  inherited Create;
  Clear;
end;

destructor TPDFStructure.Destroy;
var
  X: Integer;
begin
  for X := 0 to (Length(Objects) - Reserved) - 1 do
  begin
    if Assigned(Objects[X]) then
    begin
      if Objects[X] is TPDFObject then
      begin
        try
          Objects[X].Free;
          Objects[X] := nil;
        except
          //ShowMessage('Free exception: ' + QPLIntToStr(X));
        end;
      end;// else
        //ShowMessage('Not a TPDFObject');
    end; //else
      //ShowMessage('Not an object');
  end;
  inherited Destroy;
end;

function TPDFStructure.KillWhitespace(const OrigS: AnsiString): AnsiString;
var
  X: Integer;
  PhaseOne: AnsiString;
  IsWhite: Boolean;
  LastWhite: Boolean;
  BracketCount: Integer;
  TempS: AnsiString;
  InDict: Integer;
  S: AnsiString;
  OutHex: Boolean;
const
  Delimiter: AnsiString = '(<>[]{/%';
  Whitespace: AnsiString = #0#9#10#12#13#32;
begin
  S := OrigS + #10;
  InDict := 0;
  PhaseOne := '';
  LastWhite := False;
  X := 0;
  while (X < Length(S)) do
  begin
    Inc(X);
    if (InDict > 0) and (S[X] = '%') and (PhaseOne[Length(PhaseOne)] = #10) then
    begin
      repeat
        Inc(X);
      until (S[X] = #10) or (S[X] = #13) or (X >= Length(S));
    end;
    IsWhite := QPLPos(S[X], Whitespace) > 0;
    if IsWhite then
    begin
      if (not LastWhite) and (PhaseOne <> '') then
      begin
        PhaseOne := PhaseOne + #10;
        LastWhite := True;
      end;
    end else
    begin
      PhaseOne := PhaseOne + S[X];

      if (S[X] = '<') and (QPLCopy(S, X + 1, 1) = '<') then
      begin
        Inc(InDict);
        if (Length(PhaseOne) > 1) and (QPLCopy(PhaseOne, Length(PhaseOne) - 1, 1) <> #10) then
          Insert(#10, PhaseOne, Length(PhaseOne));
      end;

      OutHex := False;
      if (S[X] = '<') and (QPLCopy(S, X + 1, 1) <> '<') and (QPLCopy(S, X - 1, 1) <> '<') then
      begin
        Insert(#10, PhaseOne, Length(PhaseOne));
        TempS := QPLCopy(S, X + 1, MaxInt);
        Delete(TempS, QPLPos('>', TempS) + 1, MaxInt);
        TempS := QPLStringReplace(TempS, ' ', '', [rfReplaceAll]);
        TempS := QPLStringReplace(TempS, #10, '', [rfReplaceAll]);
        TempS := QPLStringReplace(TempS, #13, '', [rfReplaceAll]);
        PhaseOne := PhaseOne + TempS + #10;
        repeat
          X := X + 1;
        until (S[X] = '>') or (X = Length(S));
        OutHex := True;
      end;

      if QPLCopy(PhaseOne, Length(PhaseOne) - 1, 2) = '<<' then
      begin
        PhaseOne := PhaseOne + #10;
      end;

      if (InDict = 0) and (QPLCopy(S, X, 6) = 'stream') then
      begin
        PhaseOne := PhaseOne + QPLCopy(S, X + 1, Length(S));
        X := Length(S);
      end;

      if S[X] = '(' then
      begin
        Insert(#10, PhaseOne, Length(PhaseOne)); 
        BracketCount := 1;
        repeat
          Inc(X);
          PhaseOne := PhaseOne + S[X];
          if S[X] = ')' then
          begin
            if S[X - 1] = '\' then
            begin
              if S[X - 2] = '\' then
                Dec(BracketCount);
            end else
              Dec(BracketCount);
          end;
          if S[X] = '(' then
          begin
            if S[X - 1] <> '\' then
              Inc(BracketCount);
          end;
        until (BracketCount = 0) or (X > Length(S));
        PhaseOne := PhaseOne + #10;
      end;

      LastWhite := False;

      if S[X] = '[' then
      begin
        if Length(PhaseOne) > 1 then
          Insert(#10, PhaseOne, Length(PhaseOne));
        if QPLCopy(PhaseOne, Length(PhaseOne), 1) <> #10 then
        begin
          PhaseOne := PhaseOne + #10;
          LastWhite := True;
        end;
      end;

      if S[X] = ']' then
      begin
        if QPLCopy(PhaseOne, Length(PhaseOne) - 1, 1) <> #10 then
          Insert(#10, PhaseOne, Length(PhaseOne));
        PhaseOne := PhaseOne + #10;
      end;

      if S[X] = '/' then
      begin
        if QPLCopy(PhaseOne, Length(PhaseOne) - 1, 1) <> #10 then
          Insert(#10, PhaseOne, Length(PhaseOne));
        repeat
          Inc(X);
          PhaseOne := PhaseOne + S[X];
        until (QPLPos(S[X + 1], Delimiter) > 0) or
          (QPLPos(S[X + 1], WhiteSpace) > 0) or (X = (Length(S) - 1));
        PhaseOne := PhaseOne + #10;
      end;

      if S[X] = '>' then
      begin
        if (InDict > 0) and (not OutHex) then
        begin
          if QPLCopy(S, X, 2) = '>>' then
          begin
            Delete(PhaseOne, Length(PhaseOne), 1);
            PhaseOne := PhaseOne + #10'>>'#10;
            Inc(X);
            Dec(InDict);
            if InDict = 0 then
            begin
              X := X + 0;
            end;
          end;
        end;
      end;
    end;
  end;

  while QPLPos(QPLCopy(PhaseOne, 1, 1), Whitespace) > 0 do
    Delete(PhaseOne, 1, 1);

  Result := PhaseOne;
end;

function TPDFStructure.NewArray(
  const Value: array of TPDFObject): TPDFArray;
var
  X: Integer;
begin
  Result := TPDFArray.Create(Self);
  for X := Low(Value) to High(Value) do
    Result.Add(Value[X]);
  AddObject(Result);
end;

function TPDFStructure.NewBoolean(const Value: Boolean): TPDFBoolean;
begin
  Result := TPDFBoolean.Create(Self);
  Result.SetTo(Value);
  AddObject(Result);
end;

function TPDFStructure.NewIndirectRef(ObjNum,
  GenNum: Integer): TPDFIndRef;
begin
  Result := TPDFIndRef.Create(Self);
  Result.ObjNum := ObjNum;
  Result.GenNum := GenNum;
  AddObject(Result);
end;

function TPDFStructure.NewName(const Value: AnsiString): TPDFName;
begin
  Result := TPDFName.Create(Self);
  Result.SetTo(Value);
  AddObject(Result);
end;

function TPDFStructure.NewNumeric(const Value: Double): TPDFNumeric;
begin
  Result := TPDFNumeric.Create(Self);
  Result.SetTo(Value);
  AddObject(Result);
end;

function TPDFStructure.NewStream(const Value: AnsiString; Compress: Boolean): TPDFStream;
begin
  Result := TPDFStream.Create(Self);
  Result.SetTo(Value, Compress);
  AddObject(Result);
end;

function TPDFStructure.NewStream(const Value: TQPLByteArray; Compress: Boolean): TPDFStream;
var
  ValueS: AnsiString;
begin
  Result := TPDFStream.Create(Self);
  SetLength(ValueS, Length(Value));
  if (Length(Value) > 0) then
  begin
    Move(Value[0], ValueS[1], Length(Value));
  end;
  Result.SetTo(ValueS, Compress);
  AddObject(Result);
end;

function TPDFStructure.NewTextStream(const Value: WideString; Compress: Boolean = False): TPDFStream;
begin
  Result := TPDFStream.Create(Self);
  Result.SetToTextString(Value, Compress);
  AddObject(Result);
end;

function TPDFStructure.NewString(const Value: AnsiString; Mode: TPDFStringMode): TPDFString;
begin
  Result := TPDFString.Create(Self);
  Result.SetTo(Value);
  Result.StringMode := Mode;
  AddObject(Result);
end;

function TPDFStructure.NewTextString(const Value: WideString): TPDFString;
begin
  Result := TPDFString.Create(Self);
  Result.SetToTextString(Value);
  AddObject(Result);
end;

function TPDFStructure.NewDictionary: TPDFDictionary;
begin
  Result := TPDFDictionary.Create(Self);
  AddObject(Result);
end;

function TPDFStructure.NewNull: TPDFNull;
begin
  Result := TPDFNull.Create(Self);
  AddObject(Result);
end;

procedure TPDFStructure.Clear;
var
  X: Integer;
begin
  PDFPrecision := '0.0000';
  PDFPrecNum := 4;
  OldFormat := True;
  for X := 0 to (Length(Objects) - Reserved) - 1 do
    Objects[X].Free;
  SetLength(Objects, 0);
  Reserved := 0;
end;

function TPDFStructure.NewIntArray(const Value: array of Integer): TPDFArray;
var
  X: Integer;
begin
  Result := TPDFArray.Create(Self);
  for X := Low(Value) to High(Value) do
    Result.Add(NewNumeric(Value[X]));
  AddObject(Result);
end;

function TPDFStructure.NewArray: TPDFArray;
begin
  Result := TPDFArray.Create(Self);
  AddObject(Result);
end;

procedure TPDFStructure.RemoveObject(Obj: TPDFObject);
var
  X: Integer;
  Index: Integer;
begin
  // Search the Objects array to find the matching TPDFObject
  Index := -1;
  X := (Length(Objects) - Reserved) - 1;
  repeat
    if Objects[X] = Obj then Index := X;
    X := X - 1;
  until (X < 0) or (Index >= 0);

  // Do not delete the object if it's a common TPDFName
  if (Index >= 0) and (Objects[Index] is TPDFName) then
  begin
    if TPDFName(Objects[Index]).FCommon then
    begin
      Index := -1;
    end;
  end;

  // Do not delete the object if another object links to it
  for X := 0 to (Length(Objects) - Reserved) - 1 do
  begin
    if Objects[X].HasChild(Obj) then
    begin
      Index := -1;
    end;
  end;

  if (Index >= 0) then
  begin
    // Free the object
    Objects[Index].Free;

    // Shift the object array
    for X := Index to (Length(Objects) - Reserved) - 2 do
    begin
      Objects[X] := Objects[X + 1];
    end;

    // Set the last previously used item to nil to prevent attempts to free it
    Objects[Length(Objects) - Reserved - 1] := nil;

    // Increment Reserved. Effectively decrements the number of
    // valid objects in the array without resizing the array
    Inc(Reserved);
  end;
end;

function TPDFStructure.NewDoubleArray(
  const Value: array of Double): TPDFArray;
var
  X: Integer;
begin
  Result := TPDFArray.Create(Self);
  for X := Low(Value) to High(Value) do
    Result.Add(NewNumeric(Value[X]));
  AddObject(Result);
end;

function TPDFStructure.FindName(const Name: AnsiString): TPDFName;
var
  X: Integer;
  Found: Boolean;
begin
  X := 0;
  Found := False;
  Result := nil;
  while (X < (Length(Objects) - Reserved)) and (not Found) do
  begin
    if Objects[X] is TPDFName then
    begin
      if TPDFName(Objects[X]).Name = Name then
      begin
        Result := TPDFName(Objects[X]);
        Found := True;
      end;
    end;
    Inc(X);
  end;
end;

function TPDFStructure.NewCommonName(const Value: AnsiString): TPDFName;
begin
  if QPLPos('[' + Value + ']', PreDef) > 0 then
    Result := FindName(Value)
  else
    Result := nil;

  if not Assigned(Result) then
  begin
    Result := TPDFName.Create(Self);
    Result.SetTo(Value);
    AddObject(Result);
  end;

  Result.FCommon := True;
end;

function TPDFStructure.DecodeString(const Source: AnsiString): AnsiString;
var
  X: Integer;
  NS: AnsiString;
  O1, O2, O3: AnsiString;
  O: Integer;

  function IsOctal(const S: AnsiString): Boolean;
  var
    Oct: Integer;
    Max: Integer;
    X: Integer;
  begin
    Result := False;
    if (Length(S) >= 1) and (Length(S) <= 3) then
    begin
      Max := 777;
      if Length(S) = 1 then Max := 7;
      if Length(S) = 2 then Max := 77;
      Oct := QPLStrToIntDef(S, -1);
      Result := (Oct >= 0) and (Oct <= Max);

      for X := 1 to Length(S) do
      begin
        if (S[X] < '0') or (S[X] > '9') then
        begin
          Result := False;
        end;
      end;
    end;
  end;

begin
  NS := Source;
  Result := '';
  Delete(NS, 1, 1);
  Delete(NS, Length(NS), 1);
  begin
    X := 0;
    while (X < Length(NS)) do
    begin
      Inc(X);
      if NS[X] <> '\' then Result := Result + NS[X] else
      begin
        if QPLCopy(NS, X + 1, 1) = 'b' then
        begin
          Result := Result + #8;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = 't' then
        begin
          Result := Result + #9;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = 'n' then
        begin
          Result := Result + #10;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = 'f' then
        begin
          Result := Result + #12;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = 'r' then
        begin
          Result := Result + #13;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = '(' then
        begin
          Result := Result + #40;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = ')' then
        begin
          Result := Result + #41;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = '\' then
        begin
          Result := Result + #92;
          Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = #13 then
        begin
          Inc(X);
          if QPLCopy(NS, X + 1, 1) = #10 then
            Inc(X);
        end else
        if QPLCopy(NS, X + 1, 1) = #10 then
        begin
          Inc(X);        
        end else
        begin
          O1 := QPLCopy(NS, X + 1, 1);
          O2 := QPLCopy(NS, X + 1, 2);
          O3 := QPLCopy(NS, X + 1, 3);

          if IsOctal(O3) then
          begin
            O := (Ord(NS[X + 1]) - 48) * 64 + (Ord(NS[X + 2]) - 48) * 8 + (Ord(NS[X + 3]) - 48);
            Result := Result + AnsiChar(O);
            Inc(X, 3);
          end else
          if IsOctal(O2) then
          begin
            O := (Ord(NS[X + 1]) - 48) * 8 + (Ord(NS[X + 2]) - 48);
            Result := Result + AnsiChar(O);
            Inc(X, 2);
          end else
          if IsOctal(O1) then
          begin
            O := Ord(NS[X + 1]) - 48;
            Result := Result + AnsiChar(O);
            Inc(X, 1);
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFStructure.ShiftIndRef(Offset: Integer; ZeroGen: Boolean);
var
  X: Integer;
begin
  for X := 0 to (Length(Objects) - Reserved) - 1 do
  begin
    if Objects[X] is TPDFIndRef then
    begin
      TPDFIndRef(Objects[X]).ObjNum := TPDFIndRef(Objects[X]).ObjNum + Offset;
      if ZeroGen then
        TPDFIndRef(Objects[X]).GenNum := 0;
    end;
  end;
end;

function TPDFStructure.GetObjectCount: Integer;
begin
  // The number of valid objects is the length of the array minus the
  // number of reserved object entries
  Result := Length(Objects) - Reserved;
end;

function TPDFStructure.GetObject(Index: Integer): TPDFObject;
begin
  if (Index >= 0) and (Index < (Length(Objects) - Reserved)) then
  begin
    Result := Objects[Index];
  end else
  begin
    Result := nil;
  end;
end;

procedure TPDFStructure.ReserveObjects(Count: Integer);
begin
  // Only increase the size of the array if the requested reserved object
  // count is larger than the current value. Increase the size of the array
  // by the difference between the requested size and the existing size
  if Count > Reserved then
  begin
    SetLength(Objects, Length(Objects) + Count - Reserved);
    Reserved := Count;
  end;
end;

function TPDFStructure.Decode(const Source: AnsiString): TPDFObject;
var
  UnusedLength: Integer;
begin
  UnusedLength := 0;
  Result := DecodeWithLength(Source, UnusedLength);
end;

function TPDFStructure.DecodeWithLength(const Source: AnsiString; var ObjectLength: Integer; StartPos: Integer = 1): TPDFObject;
var
  L: Integer;
  X: Integer;
  S: AnsiString;
  OS: AnsiString;

  function IsWhitespace(C: AnsiChar): Boolean;
  begin
    Result := (C = #32) or (C = #10) or (C = #13) or (C = #9) or
      (C = #12) or (C = #0);
  end;

  function IsDelimiter(C: AnsiChar): Boolean;
  begin
    Result := (C = '(') or (C = ')') or (C = '<') or (C = '>') or
      (C = '[') or (C = ']') or (C = '/') or (C = '%') or (C = '{');
  end;

  function IsNumeric(C: AnsiChar): Boolean;
  begin
    Result := ((C >= '0') and (C <= '9'));
  end;

  function IsHex(C: AnsiChar): Boolean;
  begin
    Result := ((C >= '0') and (C <= '9')) or ((C >= 'a') and (C <= 'f')) or
      ((C >= 'A') and (C <= 'F'));
  end;

  procedure SkipWhitespace;
  begin
    repeat
      while (X < L) and IsWhitespace(Source[X]) do Inc(X);
      while (X < L) and (Source[X] = '%') do
      begin
        while (X < L) and (Source[X] <> #10) and (Source[X] <> #13) do Inc(X);
      end;
    until (X >= L) or ((not IsWhitespace(Source[X])) and (Source[X] <> '%'));
  end;

  function PeekIs(const Test: AnsiString): Boolean;
  var
    I1: Integer;
    I2: Integer;
    M: Integer;
  begin
    Result := True;
    I1 := X;
    I2 := 1;
    M := X + Length(Test) - 1;
    if M > Length(Source) then M := Length(Source);
    while Result and (I1 <= M) do
    begin
      Result := Source[I1] = Test[I2];
      Inc(I1);
      Inc(I2);
    end;
  end;

  function SmartRecDecode(CheckIndObj: Boolean = False): TPDFObject;
  var
    C: AnsiChar;
    D: Double;
    D2: Double;
    P: Integer;
    DC: Integer;
    BC: Integer;
    O: TPDFObject;
    N: TPDFObject;
    E: TPDFEntry;
    IRCheck: Integer;
    IsIR: Boolean;
    TX: Integer;
    CC: Integer;
    EFound: Boolean;
  begin
    Result := nil;
    if X <= L then
    begin
      if (L - X >= 3) and (Source[X] = '<') and (Source[X + 1] = '<') then
      begin
        Inc(X, 2);
        Result := NewDictionary;
        repeat
          SkipWhitespace;
          N := SmartRecDecode;
          SkipWhitespace;
          O := SmartRecDecode;
          if (N is TPDFName) and (Assigned(O)) then
          begin
            E.Key := TPDFName(N);
            E.Value := O;
            TPDFDictionary(Result).AddEntry(E);
          end;
        until (not Assigned(O)) or (not (N is TPDFName));
        Result.SetChanged(False);
        if (X < L) and (Source[X] = '>') and (Source[X + 1] = '>') then
          Inc(X, 2);
      end else

      if (L - X >= 1) and (Source[X] = '[') then
      begin
        Inc(X);
        Result := NewArray;
        repeat
          SkipWhitespace;
          O := SmartRecDecode;
          if Assigned(O) then
          begin
            TPDFArray(Result).Add(O);
            if (TPDFArray(Result).Count = 1) and (O is TPDFIndRef) and (X < L) then
            begin
              if (Source[X] <> ']') then
              begin
                TX := X;
                CC := 0;
                repeat
                  Inc(TX);
                  if Source[TX] = 'R' then Inc(CC);
                until (Source[TX] = ']') or (TX >= L);
                TPDFArray(Result).ReserveItems(CC);
              end;
            end;
          end;
        until not Assigned(O);
        Result.SetChanged(False);
        if (X <= L) and (Source[X] = ']') then
          Inc(X);
      end else

      if (((L - X) = 3) and PeekIs('true')) or
        (((L - X) > 3) and PeekIs('true') and
        (IsWhitespace(Source[X + 4]) or IsDelimiter(Source[X + 4]))) then
      begin
        Result := NewBoolean(True);
        Result.SetChanged(False);
        X := X + 4;
      end else

      if (((L - X) = 4) and PeekIs('false')) or
        (((L - X) > 4) and PeekIs('false') and
        (IsWhitespace(Source[X + 5]) or IsDelimiter(Source[X + 5]))) then
      begin
        Result := NewBoolean(False);
        Result.SetChanged(False);
        X := X + 5;
      end else

      if (((L - X) = 3) and PeekIs('null')) or
        (((L - X) > 3) and PeekIs('null') and
        (IsWhitespace(Source[X + 4]) or IsDelimiter(Source[X + 4]))) then
      begin
        Result := NewNull;
        Result.SetChanged(False);
        X := X + 4;
      end else

      if (Source[X] = '-') or (Source[X] = '.') or IsNumeric(Source[X]) then
      begin
        P := X + 1;
        if Source[X] = '.' then DC := 1 else DC := 0;

        EFound := False;
        while (P <= L) and (((DC = 0) and (Source[P] = '.')) or (IsNumeric(Source[P]) or (Source[P] = 'E'))) do
        begin
          if Source[P] = '.' then Inc(DC);
          if Source[P] = 'E' then
            EFound := True;;
          Inc(P);
        end;

        if (EFound) then
        begin
          P := X + 1;
          while (P <= L) and ((Source[P] = '.') or (IsNumeric(Source[P]) or (Source[P] = '-') or (Source[P] = 'E'))) do
            Inc(P);
        end;

        S := QPLCopy(Source, X, P - X);
        if Length(S) > 0 then
        begin
          if S[1] = '.' then S := '0' + S;
          if S[Length(S)] = '.' then S := S + '0';
        end;
        if (EFound) then
          D := ExpToFloatVar(S)
        else
        begin
          if (DC = 0) and (Length(S) < 9) then
            D := QPLStrToIntDef(S, 0)
          else
            D := TazzToFloat(S);
        end;

        X := P;
        IsIR := False;
        IRCheck := X;

        if DC = 0 then
        begin
          SkipWhitespace;
          if (X <= L) and (IsNumeric(Source[X])) then
          begin
            P := X + 1;
            if Source[X] = '.' then DC := 1 else DC := 0;
            while (P <= L) and (((DC = 0) and (Source[P] = '.')) or IsNumeric(Source[P])) do
            begin
              if Source[P] = '.' then Inc(DC);
              Inc(P);
            end;
            S := QPLCopy(Source, X, P - X);
            if Length(S) > 0 then
            begin
              if S[1] = '.' then S := '0' + S;
              if S[Length(S)] = '.' then S := S + '0';
            end;
            if DC = 0 then D2 := QPLStrToIntDef(S, 0) else
              D2 := TazzToFloat(S);

            X := P;
            SkipWhitespace;
            if ((X <= L) and (Source[X] = 'R')) then
            begin
              IsIR := True;
              Result := NewIndirectRef(Trunc(D), Trunc(D2));
              Result.SetChanged(False);
              Inc(X);
            end;
          end;
        end;
        if not IsIR then
        begin
          X := IRCheck;
          Result := NewNumeric(D);
          Result.SetChanged(False);
        end;
      end else

      if (L - X >= 1) and (Source[X] = '(') then
      begin
        P := X;
        BC := 1;
        while (P <= L) and (BC > 0) do
        begin
          Inc(P);
          if Source[P] = '(' then Inc(BC) else
          if Source[P] = ')' then Dec(BC) else
          if (Source[P] = '\') and (P < (L - 1)) then
          begin
            C := Source[P + 1];
            if (C = '(') or (C = ')') or (C = '\') then Inc(P);
          end;
        end;
        if BC = 0 then
        begin
          S := QPLCopy(Source, X + 1, P - X - 1);
          X := P + 1;
          P := 1;
          while P <= Length(S) do
          begin
            if (S[P] = '\') and (P < Length(S)) then
            begin
              C := S[P + 1];
              if IsNumeric(C) then
              begin
                OS := C;

                if (P < (Length(S) - 1)) and IsNumeric(S[P + 2]) then
                begin
                  OS := OS + S[P + 2];
                  if (P < (Length(S) - 2)) and IsNumeric(S[P + 3]) then
                    OS := OS + S[P + 3];
                end;

                Delete(S, P, Length(OS));
                while Length(OS) < 3 do
                  OS := '0' + OS;
                S[P] := AnsiChar((Ord(OS[1]) - 48) * 64 + (Ord(OS[2]) - 48) * 8 + (Ord(OS[3]) - 48));
              end else
              if (C = 'n') or (C = 'r') or (C = 't') or (C = 'b') or (C = 'f') or
                (C = '(') or (C = ')') or (C = '\') then
              begin
                Delete(S, P, 1);
                case C of
                  'n': S[P] := #10;
                  'r': S[P] := #13;
                  't': S[P] := #9;
                  'b': S[P] := #8;
                  'f': S[P] := #12;
                end;
              end else
              if (C = #10) then
              begin
                Delete(S, P, 2);
                Dec(P);
              end else
              if (C = #13) then
              begin
                Delete(S, P, 2);
                if (Length(S) >= P) and (S[P] = #10) then
                  Delete(S, P, 1);
                Dec(P);
              end;
            end else
            if (S[P] = #13) then
            begin
              S[P] := #10;
              if (Length(S) >= P) and (S[P + 1] = #10) then
                Delete(S, P + 1, 1);
            end;
            Inc(P);
          end;
          Result := NewString(S);
          Result.SetChanged(False);
        end;
      end else

      if ((L - X) >= 1) and (Source[X] = '<') then
      begin
        P := X;
        while (P < L) and (Source[P] <> '>') do Inc(P);
        S := QPLCopy(Source, X + 1, P - X - 1);
        X := P + 1;
        S := QPLUpperCase(QPLTrim(S));
        P := 1;
        while P <= Length(S) do
        begin
          if ((S[P] >= '0') and (S[P] <= '9')) or ((S[P] >= 'A') and (S[P] <= 'F')) then
            Inc(P)
          else
            Delete(S, P, 1);
        end;
        if Length(S) mod 2 = 1 then S := S + '0';
        OS := '';
        for P := 1 to Length(S) div 2 do
          OS := OS + AnsiChar(QPLStrToIntDef('$' + QPLCopy(S, P * 2 - 1, 2), 0));
        Result := NewString(OS, smHex);
        Result.SetChanged(False);
      end else

      if (L - X >= 1) and (Source[X] = '/') then
      begin
        P := X + 1;
        while (P <= L) and (not IsWhitespace(Source[P])) and
          (not IsDelimiter(Source[P])) do Inc(P);
        S := QPLCopy(Source, X + 1, P - X - 1);
        X := P;
        P := 0;
        while P < Length(S) do
        begin
          Inc(P);
          if (S[P] = '#') then
          begin
            OS := QPLCopy(S, P + 1, 2);
            if Length(OS) = 2 then
            begin
              if (IsHex(OS[1]) and IsHex(OS[2])) then
              begin
                Delete(S, P, 2);
                S[P] := AnsiChar(QPLStrToIntDef('$' + OS, 0));
              end;
            end;
          end;
        end;
        Result := NewName(S);
        Result.SetChanged(False);
      end;

    end;
  end;

begin
  Result := nil;
  ObjectLength := 0;
  try
    L := Length(Source);
    if L > 0 then
    begin
      X := StartPos;
      SkipWhitespace;
      Result := SmartRecDecode;
      ObjectLength := X - StartPos;
    end;
  except
  end;

  if not Assigned(Result) then
  begin
    Result := NewNull;
  end;
end;

function TPDFStructure.DecodeHex(const Source: AnsiString): AnsiString;
begin
  Result := SODecodeHex(Source);
end;

procedure TPDFStructure.ReplaceIndRef(AddedObjects: TQuickPDFStringList;
  Offset: Integer);
var
  X: Integer;
  I: Integer;
begin
  for X := 0 to (Length(Objects) - Reserved) - 1 do
  begin
    if Objects[X] is TPDFIndRef then
    begin
      I := AddedObjects.IndexOf(Objects[X].Output);
      if (I >= 0) then
      begin
        TPDFIndRef(Objects[X]).ObjNum := I + Offset;
        TPDFIndRef(Objects[X]).GenNum := 0;
      end else
      begin
        TPDFIndRef(Objects[X]).ObjNum := 0;
        TPDFIndRef(Objects[X]).GenNum := 0;
      end;
    end;
  end;
end;

function TPDFStructure.NewStreamWithDict(const Value: AnsiString;
  StreamDict: TPDFDictionary): TPDFStream;
begin
  Result := TPDFStream.CreateFull(Self, Value, StreamDict);
  AddObject(Result);
end;

{ TPDFObject }

constructor TPDFObject.Create(AOwner: TPDFStructure);
begin
  inherited Create;
  FChanged := False;
  SpyType := #0;
  FOwner := AOwner;
  FIsIndirect := False;
  FIndObjNum := 0;
  FIndGenNum := 0;
end;

function TPDFObject.GetHasChanged: Boolean;
begin
  Result := FChanged;
end;

function TPDFObject.HasChild(AObject: TPDFObject): Boolean;
begin
  Result := False;
end;

procedure TPDFObject.Own(ObjNum, GenNum: Integer);
begin
  FIndObjNum := ObjNum;
  FIndGenNum := GenNum;
  FIsIndirect := True;  
end;

procedure TPDFObject.Purge;
begin
  FOwner.RemoveObject(Self);
end;

procedure TPDFObject.SetChanged(HasChanged: Boolean);
begin
  FChanged := HasChanged;
end;

procedure TPDFObject.ShiftIndRef(Offset: Integer);
begin
  //
end;

{ TPDFNumeric }

function TPDFNumeric.AsDouble: Double;
begin
  Result := FValue;
end;

function TPDFNumeric.AsInteger: Integer;
begin
  try
    Result := Round(FValue);
  except
    Result := 0;
  end;
end;

constructor TPDFNumeric.Create(AOwner: TPDFStructure);
begin
  inherited Create(AOwner);
  SpyType := 'n';
end;

function TPDFNumeric.Output: AnsiString;
begin
  Result := QPLDoubleToStr(FValue, Owner.PDFPrecNum);
end;

procedure TPDFNumeric.SetTo(const Value: Double);
begin
  FValue := Value;
  FChanged := True;
end;

{ TPDFString }

function TPDFString.AsString: AnsiString;
begin
  Result := FValue;
end;

function TPDFString.AsTextString: WideString;
begin
  Result := QPLDecodeTextString(FValue);
end;

constructor TPDFString.Create(AOwner: TPDFStructure);
begin
  inherited Create(AOwner);
  SpyType := 's';
end;

function TPDFString.Output: AnsiString;
var
  X: Integer;
  OutputPos: Integer;
  FinalSize: Integer;
begin
  Result := '';
  case StringMode of
    smLiteral:
      begin
        FinalSize := 2;
        for X := 1 to Length(FValue) do
        begin
          if FValue[X] in [#8, #9, #10, #12, #13, #40, #41, #92] then
          begin
            Inc(FinalSize, 2);
          end else
          begin
            Inc(FinalSize);
          end;
        end;

        SetLength(Result, FinalSize);
        Result[1] := '(';
        OutputPos := 2;
        for X := 1 to Length(FValue) do
        begin
          if FValue[X] in [#8, #9, #10, #12, #13, #40, #41, #92] then
          begin
            Result[OutputPos] := '\';
            Inc(OutputPos);
            case FValue[X] of
              #8:  Result[OutputPos] := 'b';
              #9:  Result[OutputPos] := 't';
              #10: Result[OutputPos] := 'n';
              #12: Result[OutputPos] := 'f';
              #13: Result[OutputPos] := 'r';
              #40: Result[OutputPos] := '(';
              #41: Result[OutputPos] := ')';
              #92: Result[OutputPos] := '\';
            end;
            Inc(OutputPos);
          end else
          begin
            Result[OutputPos] := FValue[X];
            Inc(OutputPos);
          end;
        end;
        Result[Length(Result)] := ')';
      end;
    smHex:
      begin
        Result := '<';
        for X := 1 to Length(FValue) do
          Result := Result + QPLUpperCase(QPLIntToHex(Ord(FValue[X]), 2));
        Result := Result + '>';
      end;
  end;
end;

procedure TPDFString.SetTo(const Value: AnsiString);
begin
  FValue := Value;
  FChanged := True;
end;

procedure TPDFString.SetToTextString(const Value: WideString);
begin
  FValue := QPLEncodeTextString(Value);
  StringMode := smLiteral;
  FChanged := True;
end;

{ TPDFArray }

procedure TPDFArray.Add(Value: TPDFObject);
var
  Len: Integer;
begin
  Len := Length(Items);
  if Reserved = 0 then
  begin
    SetLength(Items, Len + 1);
    Items[Len] := Value;
  end else
  begin
    Items[Len - Reserved] := Value;
    Dec(Reserved);
  end;
  FChanged := True;
end;

function TPDFArray.AllItemsNumeric: Boolean;
var
  X: Integer;
begin
  X := 0;
  Result := True;
  while Result and (X < (Length(Items) - Reserved)) do
  begin
    if not (Items[X] is TPDFNumeric) then Result := False;
    Inc(X);
  end;
end;

procedure TPDFArray.Clear;
var
  X: Integer;
begin
  for X := 0 to (Length(Items) - Reserved) - 1 do
    FOwner.RemoveObject(Items[X]);
  SetLength(Items, 0);
  Reserved := 0;
  FChanged := True;
end;

constructor TPDFArray.Create(AOwner: TPDFStructure);
begin
  inherited;
  Reserved := 0;
  SpyType := 'A';  
end;

procedure TPDFArray.Delete(Index: Integer);
var
  X: Integer;
begin
  if (Index >= 0) and (Index < (Length(Items) - Reserved)) then
  begin
    FOwner.RemoveObject(Items[Index]);
    for X := Index to (Length(Items) - Reserved) - 2 do
      Items[X] := Items[X + 1];

    // Set the last previously used item to nil to prevent any attempts
    // to access it
    Items[(Length(Items) - Reserved) - 1] := nil;

    // Increment Reserved, effectively decrements the object count
    // without requiring resizing of the array
    Inc(Reserved);

    FChanged := True;
  end;
end;

procedure TPDFArray.DeleteObj(Obj: TPDFObject; ByOutput: Boolean);
var
  X: Integer;
  Found: Boolean;
  Test: AnsiString;
begin
  if Assigned(Obj) then
  begin
    if ByOutput then
    begin
      Test := Obj.Output;
      X := 0;
      Found := False;
      while (X < (Length(Items) - Reserved)) and (not Found) do
      begin
        if Items[X].Output = Test then
        begin
          FChanged := True;
          Found := True;
          Delete(X);
        end else
          Inc(X);
      end;
    end else
    begin
      X := 0;
      Found := False;
      while (X < (Length(Items) - Reserved)) and (not Found) do
      begin
        if Items[X] = Obj then
        begin
          FChanged := True;
          Found := True;
          Delete(X);
        end else
          Inc(X);
      end;
    end;
  end;
end;

function TPDFArray.GetCount: Integer;
begin
  Result := Length(Items) - Reserved;
end;

function TPDFArray.GetHasChanged: Boolean;
var
  X: Integer;
begin
  Result := FChanged;
  X := 0;
  while ((not Result) and (X < (Length(Items) - Reserved))) do
  begin
    if (Assigned(Items[X])) then
    begin
      if (Items[X].HasChanged) then
      begin
        Result := True;
      end;
    end;
    Inc(X);
  end;
end;

function TPDFArray.GetItem(Index: Integer): TPDFObject;
begin
  Result := nil;
  if (Index >= 0) and (Index < (Length(Items) - Reserved)) then
    Result := Items[Index];
end;

function TPDFArray.HasChild(AObject: TPDFObject): Boolean;
var
  X: Integer;
begin
  Result := False;
  for X := 0 to (Length(Items) - Reserved) - 1 do
    if Items[X] = AObject then Result := True;
end;

function TPDFArray.HasMatchingChild(const Test: AnsiString): Boolean;
var
  X: Integer;
begin
  Result := False;
  X := 0;
  while (X < (Length(Items) - Reserved)) and (not Result) do
  begin
    if Items[X].Output = Test then Result := True;
    X := X + 1;
  end;
end;

procedure TPDFArray.Insert(Index: Integer; Value: TPDFObject);
var
  X: Integer;
begin
  if (Index >= 0) and (Index <= (Length(Items) - Reserved)) then
  begin
    if Reserved = 0 then
      SetLength(Items, Length(Items) + 1)
    else
      Dec(Reserved);
    for X := (Length(Items) - 1 - Reserved) downto Index + 1 do
      Items[X] := Items[X - 1];
    Items[Index] := Value;
    FChanged := True;
  end;
end;

function TPDFArray.ItemIndexMatch(AObject: TPDFObject): Integer;
var
  X: Integer;
begin
  Result := -1;
  X := 0;
  while (Result < 0) and (X < (Length(Items) - Reserved)) do
  begin
    if Items[X].Output = AObject.Output then
      Result := X
    else
      Inc(X);
  end;
end;

procedure TPDFArray.Move(Index, NewPos: Integer);
var
  X: Integer;
  Temp: TPDFObject;
begin
  if (Index >= 0) and (Index < (Length(Items) - Reserved)) and
    (NewPos >= 0) and (NewPos < (Length(Items) - Reserved)) then
  begin
    Temp := Items[Index];
    if NewPos < Index then
    begin
      for X := Index downto NewPos + 1 do
        Items[X] := Items[X - 1];
      Items[NewPos] := Temp;
    end else
    begin
      for X := Index to NewPos - 1 do
        Items[X] := Items[X + 1];
      Items[NewPos] := Temp;
    end;
    FChanged := True;
  end;
end;

function TPDFArray.Output: AnsiString;
var
  X: Integer;
  LastCR: Integer;
begin
  Result := '[ ';
  LastCR := 0;
  for X := 0 to (Length(Items) - Reserved) - 1 do
  begin
    if Assigned(Items[X]) then
    begin
      Result := Result + Items[X].Output;
    end;
    if QPLCopy(Result, Length(Result), 1) <> #10 then Result := Result + ' ';
    if (Length(Result) - LastCR) > 80 then
    begin
      Result := Result + #10;
      LastCR := Length(Result);
    end;
  end;
  Result := Result + ']';
end;

procedure TPDFArray.Purge;
var
  X: Integer;
begin
  for X := 0 to (Length(Items) - Reserved) - 1 do
  begin
    FOwner.RemoveObject(Items[X]);
  end;
  FChanged := True;
  inherited;
end;

procedure TPDFArray.Replace(Index: Integer; Obj: TPDFObject);
begin
  if (Index >= 0) and (Index < (Length(Items) - Reserved)) then
  begin
    FOwner.RemoveObject(Items[Index]);
    Items[Index] := Obj;
    FChanged := True;
  end;
end;

procedure TPDFArray.ReplaceNoKill(Index: Integer; Obj: TPDFObject);
begin
  if (Index >= 0) and (Index < (Length(Items) - Reserved)) then
  begin
    Items[Index] := Obj;
    FChanged := True;
  end;
end;

procedure TPDFArray.ReserveItems(Count: Integer);
begin
  if Count > Reserved then
  begin
    SetLength(Items, Length(Items) + Count - Reserved);
    Reserved := Count;
  end;
end;

procedure TPDFArray.ShiftIndRef(Offset: Integer);
var
  X: Integer;
begin
  for X := 0 to Length(Items) - 1 - Reserved do
  begin
    Items[X].ShiftIndRef(Offset);
    FChanged := True;
  end;
end;

{ TPDFStream }

constructor TPDFStream.Create(AOwner: TPDFStructure);
begin
  inherited Create(AOwner);
  FDictionary := FOwner.NewDictionary;
  FStream := '';
  FLinkedObject := nil;
  SpyType := 'S';
end;

constructor TPDFStream.CreateFull(AOwner: TPDFStructure;
  const Content: AnsiString; StreamDict: TPDFDictionary);
begin
  inherited Create(AOwner);
  FDictionary := StreamDict;
  FStream := Content;
  FLinkedObject := nil;
  SpyType := 'S';
end;

function TPDFStream.GetDecodedStreamWithLookup(
  Lookup: TPDFFindObjectEvent): AnsiString;
var
  Obj: TPDFObject;
  FilterArray: TPDFArray;
  FilterDict: TPDFDictionary;
  Filters: TQuickPDFStringList;
  X: Integer;
  Max: Integer;
  Filter: AnsiString;
  FlateParms: TPDFFlateParms;
  LZWDecompressor: TPDFLZWDecompressor;
  LZWEarlyChange: Integer;
  LZWParms: TPDFLZWParms;
begin
  Result := FStream;
  Filters := TQuickPDFStringList.Create;
  try
    Obj := FDictionary.FindValueByKeyName('Filter');
    if (Obj is TPDFIndRef) then
    begin
      if (Assigned(Lookup)) then
      begin
        Obj := Lookup(TPDFIndRef(Obj));
      end else
      begin
        Obj := TPDFIndRef(Obj).Obj;
      end;
    end;
    if Obj is TPDFName then
    begin
      Filters.Add(TPDFName(Obj).Name);
    end else
    if Obj is TPDFArray then
    begin
      FilterArray := TPDFArray(Obj);
      for X := 0 to FilterArray.Count - 1 do
      begin
        Obj := FilterArray.Item[X];
        if (Obj is TPDFIndRef) then
        begin
          if (Assigned(Lookup)) then
          begin
            Obj := Lookup(TPDFIndRef(Obj));
          end else
          begin
            Obj := TPDFIndRef(Obj).Obj;
          end;
        end;
        if Obj is TPDFName then
          Filters.Add(TPDFName(Obj).Name);
      end;
    end;
    if Filters.Count > 0 then
    begin
      Obj := FDictionary.FindValueByKeyName('DecodeParms', True);
      if not Assigned(Obj) then FDictionary.FindValueByKeyName('DP', True);
      if Obj is TPDFDictionary then
        Filters.Objects[0] := Obj;
      if Obj is TPDFArray then
      begin
        FilterArray := TPDFArray(Obj);
        Max := Filters.Count;
        if FilterArray.Count < Max then Max := FilterArray.Count;
        for X := 0 to Max - 1 do
        begin
          Obj := FilterArray.Item[X];
          if Obj is TPDFDictionary then
            Filters.Objects[X] := Obj;
        end;
      end;
      for X := 0 to Filters.Count - 1 do
      begin
        Filter := Filters[X];
        if (Filter = 'FlateDecode') or (Filter = 'Fl') then
        begin
          if Filters.Objects[X] is TPDFDictionary then
          begin
            FilterDict := TPDFDictionary(Filters.Objects[X]);
            Obj := FilterDict.FindValueByKeyName('Colors', True);
            if Obj is TPDFNumeric then
              FlateParms.Colors := TPDFNumeric(Obj).AsInteger
            else
              FlateParms.Colors := 1;
            Obj := FilterDict.FindValueByKeyName('BitsPerComponent', True);
            if Obj is TPDFNumeric then
              FlateParms.BitsPerComponent := TPDFNumeric(Obj).AsInteger
            else
              FlateParms.BitsPerComponent := 8;
            Obj := FilterDict.FindValueByKeyName('Columns', True);
            if Obj is TPDFNumeric then
              FlateParms.Columns := TPDFNumeric(Obj).AsInteger
            else
              FlateParms.Columns := 1;
            Obj := FilterDict.FindValueByKeyName('Predictor', True);
            if Obj is TPDFNumeric then
              FlateParms.Predictor := TPDFNumeric(Obj).AsInteger
            else
              FlateParms.Predictor := 1;

            if FlateParms.Predictor > 1 then
            begin
              Result := InflateStrParms(Result, FlateParms);
            end else
            begin
              Result := InflateStr(Result);
            end;
          end else
          begin
            Result := InflateStr(Result);
          end;
        end else
        if ((Filter = 'RunLengthDecode') or (Filter = 'RL')) then
        begin
          Result := RLEDecode(Result);
        end else
        if ((Filter = 'ASCII85Decode') or (Filter = 'A85')) then
        begin
          Result := ASCII85Decode(Result);
        end else
        if (Filter = 'ASCIIHexDecode') then
        begin
          Result := SODecodeHex('<' + Result + '>');
        end else
        if Filter = 'LZWDecode' then
        begin
          LZWDecompressor := TPDFLZWDecompressor.Create;
          try
            LZWDecompressor.FillOrder := foTop;
            LZWDecompressor.InitialCodeSize := 9;
            LZWEarlyChange := 1;
            if Filters.Objects[X] is TPDFDictionary then
            begin
              FilterDict := TPDFDictionary(Filters.Objects[X]);
              Obj := FilterDict.FindValueByKeyName('Colors', True);
              if Obj is TPDFNumeric then
                LZWParms.Colors := TPDFNumeric(Obj).AsInteger
              else
                LZWParms.Colors := 1;
              Obj := FilterDict.FindValueByKeyName('BitsPerComponent', True);
              if Obj is TPDFNumeric then
                LZWParms.BitsPerComponent := TPDFNumeric(Obj).AsInteger
              else
                LZWParms.BitsPerComponent := 8;
              Obj := FilterDict.FindValueByKeyName('Columns', True);
              if Obj is TPDFNumeric then
                LZWParms.Columns := TPDFNumeric(Obj).AsInteger
              else
                LZWParms.Columns := 1;
              Obj := FilterDict.FindValueByKeyName('Predictor', True);
              if Obj is TPDFNumeric then
                LZWParms.Predictor := TPDFNumeric(Obj).AsInteger
              else
                LZWParms.Predictor := 1;
              Obj := FilterDict.FindValueByKeyName('EarlyChange', True);
              if Obj is TPDFNumeric then
                LZWEarlyChange := TPDFNumeric(Obj).AsInteger;
            end;
            LZWDecompressor.EarlyChange := LZWEarlyChange = 1;
            Result := LZWDecompressor.Decompress(Result, LZWParms);
          finally
            LZWDecompressor.Free;
          end;
        end;
      end;
    end;
  finally
    Filters.Free;
  end;
end;

function TPDFStream.GetDecodedStream: AnsiString;
begin
  Result := GetDecodedStreamWithLookup(nil);
end;

function TPDFStream.GetDecodedTextStream: WideString;
begin
  Result := QPLDecodeTextString(GetDecodedStream);
end;

function TPDFStream.HasChild(AObject: TPDFObject): Boolean;
begin
  Result := FDictionary.HasChild(AObject);
end;

function TPDFStream.Output: AnsiString;
begin
  Result := FDictionary.Output + 'stream' + #10 + FStream + #10 + 'endstream';
end;

procedure TPDFStream.Purge;
begin
  FDictionary.Purge;
  inherited;
end;

procedure TPDFStream.ReadFromStream(Stream: TStream; Deflate: Boolean);
var
  Obj: TPDFObject;
begin
  Stream.Seek(0, soFromBeginning);
  SetLength(FStream, Stream.Size);
  if Length(FStream) > 0 then
  begin
    SetLength(FStream, Stream.Read(FStream[1], Length(FStream)));
    if Deflate then
    begin
      FStream := DeflateStr(FStream);
      Dictionary.PurgeKey('Filter');
      Dictionary.Add('Filter', FOwner.NewName('FlateDecode'));
    end else
    begin
      Dictionary.PurgeKey('Filter');
    end;
  end;
  Obj := FDictionary.FindValueByKeyName('Length');
  if Obj is TPDFNumeric then
  begin
    TPDFNumeric(Obj).SetTo(Length(FStream));
  end else
  begin
    FDictionary.Add('Length', FOwner.NewNumeric(Length(FStream)));
  end;
  FChanged := True;
end;

procedure TPDFStream.SetDict(NewDictionary: TPDFDictionary);
begin
  Owner.RemoveObject(FDictionary);
  FDictionary := NewDictionary;
  FChanged := True;
end;

procedure TPDFStream.SetStream(const NewStream: AnsiString);
var
  Obj: TPDFObject;
begin
  FStream := NewStream;
  Obj := FDictionary.FindValueByKeyName('Length');
  if Obj is TPDFNumeric then
  begin
    TPDFNumeric(Obj).SetTo(Length(NewStream));
  end else
  begin
    FDictionary.Add('Length', FOwner.NewNumeric(Length(NewStream)));
  end;
  FChanged := True;
end;

procedure TPDFStream.SetTo(NewStream: AnsiString; Compress: Boolean);
begin
  if Compress then
  begin
    SetStream(DeflateStr(NewStream));
    Dictionary.PurgeKey('Filter');
    Dictionary.Add('Filter', FOwner.NewName('FlateDecode'));
  end else
  begin
    SetStream(NewStream);
    Dictionary.PurgeKey('Filter');
  end;
  FChanged := True;
end;

procedure TPDFStream.SetToTextString(NewStream: WideString;
  Compress: Boolean);
begin
  if Compress then
  begin
    SetStream(DeflateStr(QPLEncodeTextString(NewStream)));
    Dictionary.PurgeKey('Filter');
    Dictionary.Add('Filter', FOwner.NewName('FlateDecode'));
  end else
  begin
    SetStream(QPLEncodeTextString(NewStream));
    Dictionary.PurgeKey('Filter');
  end;
  FChanged := True;
end;

procedure TPDFStream.ShiftIndRef(Offset: Integer);
begin
  Dictionary.ShiftIndRef(Offset);
  FChanged := True;
end;

{ TPDFIndRef }

procedure TPDFIndRef.CopyRef(Source: TPDFIndRef);
begin
  if (Assigned(Source)) then
  begin
    ObjNum := Source.ObjNum;
    GenNum := Source.GenNum;
    FChanged := True;
  end;
end;

constructor TPDFIndRef.Create(AOwner: TPDFStructure);
begin
  inherited;
  SpyType := 'I';
end;

function TPDFIndRef.Obj: TPDFObject;
begin
  if Assigned(FOwner.OnIndObjLookup) then
    FOwner.OnIndObjLookup(Self, ObjNum, GenNum, Result)
  else
    Result := nil;
end;

function TPDFIndRef.Output: AnsiString;
begin
  Result := QPLIntToStr(ObjNum) + ' ' + QPLIntToStr(GenNum) + ' R';
end;

procedure TPDFIndRef.ShiftIndRef(Offset: Integer);
begin
  ObjNum := ObjNum + Offset;
end;

{ TPDFNull }

constructor TPDFNull.Create(AOwner: TPDFStructure);
begin
  inherited Create(AOwner);
  SpyType := '0';
end;

function TPDFNull.Output: AnsiString;
begin
  Result := 'null';
end;

{ TPDFNameTree }

procedure TPDFNameTree.AddKey(const Name: AnsiString; Value: TPDFIndRef);
var
  Obj: TPDFObject;
  AX: Integer;
  IX: Integer;
  LessIX: Integer;
  LimitsArray: TPDFArray;
  LowLimit: AnsiString;
  HighLimit: AnsiString;
  FoundArray: Boolean;
begin
  if (Length(Arrays) > 0) then
  begin
    AX := 0;
    FoundArray := False;

    while (not FoundArray) and (AX < Length(Dicts)) do
    begin
      LowLimit := '';
      HighLimit := '';

      if (not FSingleNode) then  // Single Nodes do not use Limits
      begin
        Obj := Dicts[AX].FindValueByKeyName('Limits', True);
        if not (Obj is TPDFArray) then
        begin
          Dicts[AX].Add('Limits', FStructure.NewArray);
          Obj := Dicts[AX].FindValueByKeyName('Limits', True);
        end;

        if (Obj is TPDFArray) then
        begin
          LimitsArray := TPDFArray(Obj);
          if (LimitsArray.Count = 2) then
          begin
            Obj := LimitsArray.GetItem(0);
            if (Obj is TPDFString) then
            begin
              LowLimit := TPDFString(Obj).AsString;
            end;
            Obj := LimitsArray.GetItem(1);
            if (Obj is TPDFString) then
            begin
              HighLimit := TPDFString(Obj).AsString;
            end;
          end
          else
          begin
            LimitsArray.Add(FStructure.NewString(Name));
            LimitsArray.Add(FStructure.NewString(Name));
          end;
        end;
      end
      else
      begin
        if (Arrays[AX].GetCount >= 2) then  // Use GetCount as some entries could be nil
        begin
          LowLimit := TPDFString(Arrays[AX].Item[0]).AsString;
          HighLimit := TPDFString(Arrays[AX].Item[Arrays[AX].GetCount - 2]).AsString;
        end;
      end;

      if ((LowLimit <> '') and (HighLimit <> '') and (Name < HighLimit)) then
      begin
        // Found a suitable array, end the loop after this
        FoundArray := True;

        // Calculate the insertion point
        LessIX := -2;
        for IX := 0 to (Arrays[AX].GetCount div 2) - 1 do
        begin
          Obj := Arrays[AX].Item[IX * 2];
          if (Obj is TPDFString) and (TPDFString(Obj).AsString < Name) then
          begin
            LessIX := IX * 2;
          end;
        end;

        // Insert the name and the object at the appropriate point
        Arrays[AX].Insert(LessIX + 2, FStructure.NewString(Name));
        Arrays[AX].Insert(LessIX + 3, Value);

        if (LessIX = -2) then
        begin
          // The new name appears at the start of this array
          // so the /Limits array must be updated if it exists
          Obj := Dicts[AX].FindValueByKeyName('Limits', True);
          if (Obj is TPDFArray) then
          begin
            LimitsArray := TPDFArray(Obj);
            if (LimitsArray.Count = 2) then
            begin
              Obj := LimitsArray.GetItem(0);
              if (Obj is TPDFString) then
              begin
                TPDFString(Obj).SetTo(Name);
              end else
              begin
                LimitsArray.Replace(0, FStructure.NewString(Name));
              end;
            end;
          end;
        end;
      end;
      Inc(AX);
    end;

    if (not FoundArray) then
    begin
      // Add the item to the end of the last array
      AX := Length(Dicts) - 1;

      // Add the name and the object at the end of the array
      Arrays[AX].Add(FStructure.NewString(Name));
      Arrays[AX].Add(Value);

      // Update the /Limits array
      Obj := Dicts[AX].FindValueByKeyName('Limits', True);
      if (Obj is TPDFArray) then
      begin
        LimitsArray := TPDFArray(Obj);
        if (LimitsArray.Count = 2) then
        begin
          Obj := LimitsArray.GetItem(1);
          if (Obj is TPDFString) then
          begin
            LimitsArray.Replace(1, FStructure.NewString(Name));
          end else
          begin
            LimitsArray.Replace(1, FStructure.NewString(Name));
          end;
        end;
      end;
    end;
  end;
end;

constructor TPDFNameTree.Create(Parent: TPDFStructure; Root: TPDFDictionary);
var
  Obj: TPDFObject;
begin
  inherited Create;
  FStructure := Parent;
  FRoot := Root;
  if Root.Count = 0 then
    Root.Add('Names', FStructure.NewArray);
  Obj := Root.FindValueByKeyName('Names');
  FSingleNode := Obj <> nil;
  SetLength(Arrays, 0);
  SetLength(Dicts, 0);
  ProcessNode(Root);
end;

function TPDFNameTree.DeleteKey(const Name: AnsiString): Boolean;
var
  I: Integer;
  AX: Integer;
  IX: Integer;
  Obj: TPDFObject;
  LimitsArray: TPDFArray;
  Lower, Upper: WideString;
begin
  Result := False;
  I := FindIndex(Name);
  if I >= 0 then
  begin
    AX := (I and $FFFF0000) shr 16;
    IX := (I and $FFFF);

    // Delete the name
    Arrays[AX].Delete(IX);

    // Delete the reference
    Arrays[AX].Delete(IX);

    if (Arrays[AX].GetCount > 0) then
    begin

      Obj := Arrays[AX].GetItem(0);
      if (Obj is TPDFString) then
        Lower := TPDFString(Obj).AsTextString;

      Obj := Arrays[AX].GetItem(Arrays[AX].GetCount - 2);
      if (Obj is TPDFString) then
        Upper := TPDFString(Obj).AsTextString;

      Obj := Dicts[AX].FindValueByKeyName('Limits', True);
      if (Obj is TPDFArray) then
      begin
        LimitsArray := TPDFArray(Obj);
        if (LimitsArray.Count = 2) then
        begin
          LimitsArray.Replace(0, FStructure.NewTextString(Lower));
          LimitsArray.Replace(1, FStructure.NewTextString(Upper));
        end;
      end;
    end
    else
    begin
      Dicts[AX].DeleteEntryByKeyName('Limits');
    end;

  RemoveEmptyKidsNodes(FRoot);

  Result := True;
  end;
end;

function TPDFNameTree.FindIndex(const Name: AnsiString): Integer;
var
  AX: Integer;
  IX: Integer;
  Obj: TPDFObject;
begin
  Result := -1;
  for AX := 0 to Length(Arrays) - 1 do
  begin
    for IX := 0 to (Arrays[AX].Count div 2) - 1 do
    begin
      Obj := Arrays[AX].Item[IX * 2];
      if (Obj is TPDFString) and (TPDFString(Obj).AsString = Name)
        and (Arrays[AX].Item[IX * 2 + 1] is TPDFIndRef) then
          Result := AX shl 16 + (IX * 2);
    end;
  end;
end;

function TPDFNameTree.FindKey(const Name: AnsiString): TPDFIndRef;
var
  I: Integer;
  AX: Integer;
  IX: Integer;
begin
  Result := nil;
  I := FindIndex(Name);
  if I >= 0 then
  begin
    AX := (I and $FFFF0000) shr 16;
    IX := (I and $FFFF);
    Result := TPDFIndRef(Arrays[AX].Item[IX + 1]);
  end;
end;

function TPDFNameTree.HasKey(const Name: AnsiString): Boolean;
var
  AX: Integer;
  IX: Integer;
  Obj: TPDFObject;
  ObjName: AnsiString;
  Test: AnsiString;
begin
  Result := False;
  for AX := 0 to Length(Arrays) - 1 do
  begin
    for IX := 0 to (Arrays[AX].Count div 2) - 1 do
    begin
      Obj := Arrays[AX].Item[IX * 2];
      Test := Obj.Output;
      if (Obj is TPDFString) then
        ObjName := TPDFString(Obj).AsString
      else
        ObjName := '';
      if (ObjName = Name) then
        Result := True;
    end;
  end;
end;

function TPDFNameTree.KeyCount: Integer;
var
  AX: Integer;
  IX: Integer;
  Obj: TPDFObject;
begin
  Result := 0;
  for AX := 0 to Length(Arrays) - 1 do
  begin
    for IX := 0 to (Arrays[AX].Count div 2) - 1 do
    begin
      Obj := Arrays[AX].Item[IX * 2];
      if (Obj is TPDFString) then
        Inc(Result);
    end;
  end;
end;

function TPDFNameTree.KeyName(Index: Integer): AnsiString;
var
  AX: Integer;
  IX: Integer;
  Obj: TPDFObject;
  ThisIndex: Integer;
begin
  Result := '';
  ThisIndex := 0;
  for AX := 0 to Length(Arrays) - 1 do
  begin
    for IX := 0 to (Arrays[AX].Count div 2) - 1 do
    begin
      Obj := Arrays[AX].Item[IX * 2];
      if (Obj is TPDFString) then
        Inc(ThisIndex);
      if ThisIndex = Index then
        Result := TPDFString(Obj).AsString;
    end;
  end;
end;

procedure TPDFNameTree.ProcessNode(NodeDict: TPDFDictionary);
var
  Obj: TPDFObject;
  Index: Integer;
  Kids: TPDFArray;
  NewSize: Integer;
begin
  Obj := NodeDict.FindValueByKeyName('Kids', True);
  if (Obj is TPDFArray) then
  begin
    Kids := TPDFArray(Obj);
    for Index := 0 to Kids.Count - 1 do
    begin
      Obj := Kids.GetItem(Index);
      if (Obj is TPDFIndRef) then
      begin
        Obj := TPDFIndRef(Obj).Obj;
        if (Obj is TPDFDictionary) then
        begin
          ProcessNode(TPDFDictionary(Obj));
        end;
      end;
    end;
  end else
  begin
    Obj := NodeDict.FindValueByKeyName('Names', True);
    if (Obj is TPDFArray) then
    begin
      NewSize := Length(Arrays) + 1;
      SetLength(Arrays, NewSize);
      Arrays[NewSize - 1] := TPDFArray(Obj);
      SetLength(Dicts, NewSize);
      Dicts[NewSize - 1] := NodeDict;
    end;
  end;
end;

procedure TPDFNameTree.RemoveEmptyKidsNodes(NodeDict: TPDFDictionary);
var
  Obj: TPDFObject;
  Index: Integer;
  Kids: TPDFArray;
begin
  Obj := NodeDict.FindValueByKeyName('Kids', True);
  if (Obj is TPDFArray) then
  begin
    Kids := TPDFArray(Obj);
    for Index := Kids.Count - 1 downto 0 do
    begin
      Obj := Kids.GetItem(Index);
      if (Obj is TPDFIndRef) then
      begin
        Obj := TPDFIndRef(Obj).Obj;
        if (Obj is TPDFDictionary) then
        begin
          Obj := TPDFDictionary(Obj).FindValueByKeyName('Names', True);

          if (Obj is TPDFArray) then
          begin
            if (TPDFArray(Obj).Count = 0) and (Kids.Count > 1) then
              Kids.Delete(Index);
          end;
        end;
      end;
    end;
  end;
end;

{ TPDFRectangle }

constructor TPDFRectangle.Create(AArray: TPDFArray);
var
  Temp: TPDFNumeric;
begin
  if Assigned(AArray) and (AArray.Count = 4) and
    (AArray.Items[0] is TPDFNumeric) and
    (AArray.Items[1] is TPDFNumeric) and
    (AArray.Items[2] is TPDFNumeric) and
    (AArray.Items[3] is TPDFNumeric) then
  begin
    FArray := AArray;
    FLLX := TPDFNumeric(AArray.Items[0]);
    FLLY := TPDFNumeric(AArray.Items[1]);
    FURX := TPDFNumeric(AArray.Items[2]);
    FURY := TPDFNumeric(AArray.Items[3]);
    if FLLX.AsDouble > FURX.AsDouble then
    begin
      Temp := FLLX;
      FLLX := FURX;
      FURX := Temp;
    end;
    if FLLY.AsDouble > FURY.AsDouble then
    begin
      Temp := FLLY;
      FLLY := FURY;
      FURY := Temp;
    end;
  end else
    FArray := nil;
end;

function TPDFRectangle.GetBottom: Double;
begin
  Result := FLLY.AsDouble;
end;

function TPDFRectangle.GetDimension(Dimension: TPDFDimension): Double;
begin
  case Dimension of
    pdLeft: Result := GetLeft;
    pdTop: Result := GetTop;
    pdWidth: Result := GetWidth;
    pdHeight: Result := GetHeight;
    pdRight: Result := GetRight;
    pdBottom: Result := GetBottom;
  else
    Result := 0;
  end;
end;

function TPDFRectangle.GetHeight: Double;
begin
  Result := FURY.AsDouble - FLLY.AsDouble;
end;

function TPDFRectangle.GetLeft: Double;
begin
  Result := FLLX.AsDouble;
end;

function TPDFRectangle.GetRight: Double;
begin
  Result := FURX.AsDouble;
end;

function TPDFRectangle.GetTop: Double;
begin
  Result := FURY.AsDouble;
end;

function TPDFRectangle.GetWidth: Double;
begin
  Result := FURX.AsDouble - FLLX.AsDouble;
end;

function TPDFRectangle.IsRectangle: Boolean;
begin
  Result := Assigned(FArray);
end;

procedure TPDFRectangle.SetBottom(NewBottom: Double);
begin
  FLLY.SetTo(NewBottom);
end;

procedure TPDFRectangle.SetLeft(NewLeft: Double);
begin
  FLLX.SetTo(NewLeft);
end;

procedure TPDFRectangle.SetTop(NewTop: Double);
begin
  FURY.SetTo(NewTop);
end;

procedure TPDFRectangle.SetRight(NewRight: Double);
begin
  FURX.SetTo(NewRight);
end;

{ TDPLTreeBalancer }

function TDPLTreeBalancer.Balance(Pages: array of TPDFIndRef; NodeSize: Integer): TPDFIndRef;
var
  ItemRefs: array of TPDFIndRef;
  ItemCounts: array of Integer;
  NewItemRefs: array of TPDFIndRef;
  NewItemDicts: array of TPDFDictionary;
  NewItemCounts: array of Integer;
  DictKids: TPDFArray;
  LevelSize: Integer;
  X: Integer;
  Y: Integer;
  NewObjNum: Integer;
  NewGenNum: Integer;
  Obj: TPDFObject;
  ChildNode: TPDFDictionary;

  function GetPageInheritedValue(Start: TPDFDictionary;
    const Key: AnsiString): TPDFObject;
  var
    O: TPDFObject;
  begin
    Result := nil;
    if Assigned(Start) then
    begin
      O := Start.FindValueByKeyName(Key, True);
      if Assigned(O) then
      begin
        Result := O;
      end else
      begin
        O := Start.FindValueByKeyName('Parent', True);
        if O is TPDFDictionary then
        begin
          Result := GetPageInheritedValue(TPDFDictionary(O), Key);
        end;
      end;
    end;
  end;

  procedure InheritProperties(ChildNode: TPDFDictionary);
  var
    NodeList: array of AnsiString;
    NodeIndex: Integer;
    Obj: TPDFObject;
  begin
    SetLength(NodeList, 4);
    NodeList[0] := 'Resources';
    NodeList[1] := 'MediaBox';
    NodeList[2] := 'CropBox';
    NodeList[3] := 'Rotate';
    for NodeIndex := 0 to Length(NodeList) - 1 do
    begin
      if (not Assigned(ChildNode.FindValueByKeyName('Resources'))) then
      begin
        Obj := GetPageInheritedValue(ChildNode, 'Resources');
        if (Assigned(Obj)) then
        begin
          ChildNode.Add('Resources', Obj);
        end;
      end;
    end;
  end;

begin
  SetLength(ItemRefs, Length(Pages));
  SetLength(ItemCounts, Length(Pages));
  for X := 0 to Length(Pages) - 1 do
  begin
    ItemRefs[X] := Pages[X];
    ItemCounts[X] := 1;
  end;

  repeat
    LevelSize := Length(ItemRefs) div NodeSize;
    if ((LevelSize * NodeSize) < Length(ItemRefs)) then
    begin
      Inc(LevelSize);
    end;
    SetLength(NewItemRefs, LevelSize);
    SetLength(NewItemDicts, LevelSize);
      SetLength(NewItemCounts, LevelSize);
    for X := 0 to LevelSize - 1 do
    begin
      NewItemDicts[X] := FStructure.NewDictionary;
      FOnNewIndObj(Self, NewObjNum, NewGenNum, NewItemDicts[X]);
      NewItemRefs[X] := FStructure.NewIndirectRef(NewObjNum, NewGenNum);

      DictKids := FStructure.NewArray;
      NewItemDicts[X].Add('Kids', DictKids);
      NewItemCounts[X] := 0;
      for Y := 0 to NodeSize - 1 do
      begin
        if ((X * NodeSize + Y) < Length(ItemRefs)) then
        begin
          Inc(NewItemCounts[X], ItemCounts[X * NodeSize + Y]);
          DictKids.Add(ItemRefs[X * NodeSize + Y]);
          FOnIndObjLookup(Self, ItemRefs[X * NodeSize + Y].ObjNum,
            ItemRefs[X * NodeSize + Y].GenNum, Obj);
          if (Obj is TPDFDictionary) then
          begin
            ChildNode := TPDFDictionary(Obj);
            InheritProperties(ChildNode);
            ChildNode.Add('Parent', NewItemRefs[X]);
          end;
        end;
      end;
      NewItemDicts[X].Add('Count', FStructure.NewNumeric(NewItemCounts[X]));
      NewItemDicts[X].Add('Type', FStructure.NewCommonName('Pages'));
    end;
    SetLength(ItemRefs, Length(NewItemRefs));
    SetLength(ItemCounts, Length(NewItemRefs));
    for X := 0 to Length(NewItemRefs) - 1 do
    begin
      ItemRefs[X] := NewItemRefs[X];
      ItemCounts[X] := NewItemCounts[X];
    end;
  until LevelSize = 1;

  if (Length(NewItemRefs) > 0) then
  begin
    Result := NewItemRefs[0];
  end else
  begin
    Result := nil;
  end;
end;

constructor TDPLTreeBalancer.Create;
begin

end;

function RLEDecode(const Input: AnsiString): AnsiString;
var
  L: Byte;
  AL: Integer;
  BL: Integer;
  CL: Byte;
  A: array of Byte;
  B: array of Byte;
  AX: Integer;
  BX: Integer;
  EOD: Boolean;
begin
  AL := Length(Input);
  if (AL > 0) then
  begin
    SetLength(A, AL);
    Move(Input[1], A[0], AL);
    BL := 4096;
    SetLength(B, BL);
    AX := 0;
    BX := 0;
    EOD := False;
    while (AX < AL) and (not EOD) do
    begin
      L := A[AX];
      Inc(AX);
      case L of
        0..127:
        begin
          CL := L + 1;
          if (AX + CL) > AL then CL := AL - AX;
          if CL > 0 then
          begin
            Move(A[AX], B[BX], CL);
            Inc(AX, CL);
            Inc(BX, CL);
          end;
        end;
        128: EOD := True;
        129..255:
        begin
          if (AX < AL) then
          begin
            CL := 257 - L;
            while CL > 0 do
            begin
              B[BX] := A[AX];
              Inc(BX);
              Dec(CL);
            end;
          end;
          Inc(AX);
        end;
      end;
      if BX > (BL - 1024) then
      begin
        Inc(BL, 4096);
        SetLength(B, BL);
      end;
    end;
    SetLength(Result, BX);
    Move(B[0], Result[1], BX);
  end else
  begin
    Result := '';
  end;
end;

end.
