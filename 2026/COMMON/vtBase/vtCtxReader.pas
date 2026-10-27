unit vtCtxReader;
(* CTX file handler
  revision 2014-07-29

Usage
-----

0) Allocate these variables, as many as required:
  MyFile: TCtxItem;
  MySelector: RSelector;
  MyClients: TStrings; //maybe ComboBox.Items
  MyClient: integer;   //index of selected client in MyClients, maybe ComboBox.ItemIndex

1a) Open an file
  MyFile := LoadCtx(FileName);
  The disk file is closed after loading.

1b) Get list of clients
  MyFile.PutClients(MyClients);

1c) Get number of form clones
  clones := MyFile.CloneCount(MyClient, formNo);
  Zero means no clones exist, FCnnn\ is equivalent to FCnnn#1\.

2) Prepare an selector record
  if not ParseKey(MyKey, MyClient, MySelector) then ReportError;
  See CTX documentation for acceptable key strings.
  The prepared selector should be applicable to any file.

3a) Get an single value
  For an string value use:
    MyString := MyFile.GetString(MySelector);
  Or use GetReal, GetByte, GetLong for other field types,
  each method returns an appropriate type!

3b) Get multiple values
  MyPtr := MyFile.GetRecord(MySelector);
  MyString := MyPtr^.strings[MyIndex];
  ...

4) Repeat 2+3 as often as you like.

5) Release the database
  MyFile.Free;

Debugging
---------

Debug output can be sent to the console - requires APPTYPE CONSOLE.
Some sanity checks can be performed by $defining debug (below).
Both features are helpful only when you understand the file format.
*)

(* History
v2.04:  Debug Skip Tables
v2.03:  improved handling of encrypted headers
V02.2:  variation of 3AF...
V02.1:  retyped strings around SIN
V02.0:  Added T2 format (*.C07)
V01.06: Added exception handler, query methods.
V01.05: Allow zero or ID for clone table numbers. (don't check?)
V01.04: Added empty entries.
V01.03: Improved handling of local notes.
V01.02: Fixed clones. Added CloneCount method.
V01.01: Fixed bug in FCf#i index calculation. Added $H+.
V01.00: First Release
*)

{$IFDEF CONSOLE}
{$DEFINE CTXdebug}
{$ENDIF}
{$DEFINE NoExcept} //no exception in getting values

{$H+}

interface

uses
  Classes, Controls,
  ComCtrls; //TTreeView

type
  eFieldType = (ftCurr, ftByte, ftInt, ftStr);

  RIndex = record
    ind: array[0..3] of integer;
    client: integer;
    ft: eFieldType;
  end;

  TByteArray = array of byte;
  TIntArray = array of integer;
  TCurrArray = array of currency;
  TStringArray = array of AnsiString; //20170321 Igor
  RCtxRec = record
    currs: TCurrArray;
    bytes: TByteArray;
    ints: TIntArray;
    strings: TStringArray;
  end;
  PCtxRec = ^RCtxRec;

  TCtxItem = class
  protected
    procedure Populate(tv: TTreeNodes; tn: TTreeNode); virtual; abstract;
    function GetCaption(index: integer): String; virtual; abstract;
    function GetCount: integer; virtual; abstract;
    procedure LoadFromStream; virtual; abstract;
  public
    fpos: integer; //debug only
    function GetString(const Selector: RIndex): String;
    function GetReal(const Selector: RIndex): Currency;
    function GetByte(const Selector: RIndex): byte;
    function GetLong(const Selector: RIndex): LongInt;
    function GetRecord(const Selector: RIndex): PCtxRec;
    function ValueExists(const Selector: RIndex): boolean;

    function CloneCount(clientNo, formNo: integer): integer;
    function FormExists(clientNo, formNo: integer): boolean;
    procedure PutItems(Alst: TStrings; fieldType: eFieldType); virtual;
    procedure PutClients(Alst: TStrings); virtual;
  end;

const
  aFieldType: array[eFieldType] of char = 'RBLS';

function LoadCtx(const fn: string): TCtxItem;
function ParseKey(const key: String; client: integer; var Selector: RIndex): boolean;
procedure Populate(tv: TTreeView; Tables: TCtxItem);

implementation

uses
  Dialogs,
  SysUtils;

type
  TCtxItems = class(TCtxItem)
  protected
    lst: TList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    function GetCaption(index: integer): String; override;
    function GetCount: integer; override;
    procedure Populate(tv: TTreeNodes; tn: TTreeNode); override;
  end;

  TCtxRecord = class(TCtxItem)
  protected
    rec: RCtxRec;
  public
    formNo, seqNo, idxNo: integer;
    function GetCaption(index: integer): String; override;
    function GetCount: integer; override;
    procedure LoadFromStream; override;
    procedure Populate(tv: TTreeNodes; tn: TTreeNode); override;
    procedure PutItems(Alst: TStrings; fieldType: eFieldType); override;
  end;

  TCtxRecords = class(TCtxItems)
  public
    seqNo: integer;
    function GetCaption(index: integer): String; override;
    procedure LoadFromStream; override;
  end;

  TCtxTables = class(TCtxItems)
  public
    ID, Clones: integer;
    function GetCaption(index: integer): String; override;
    procedure LoadFromStream; override;
  end;

  TCtxStrings = class(TCtxItem)
  public
    strs: TStringArray;
    function GetCaption(index: integer): String; override;
    function GetCount: integer; override;
    procedure LoadFromStream; override;
    procedure Populate(tv: TTreeNodes; tn: TTreeNode); override;
    procedure PutItems(Alst: TStrings; fieldType: eFieldType); override;
  end;

  TCtxNotes = class(TCtxStrings)
  protected
    cnt: integer;
    function GetCaption(index: integer): string; override;
    procedure LoadFromStream; override;
  end;

  ePersonKind = (pkTaxpayer, pkSpouse, pkDep, pkDepLast);

  TCtxPerson = class(TCtxItems)
  public
    Name: String; //20150702
    SIN: String;  //20150702
    kind: ePersonKind;
    s1: TCtxNotes;
    s2: TCtxStrings;
    function GetCaption(index: integer): String; override;
    procedure LoadFromStream; override;
    function LoadHeader(index: integer): boolean;
  end;

  TCtxFile = class(TCtxItems)
  public
    AddEmptyRecords: boolean;
    procedure LoadFromStream; override;
    procedure PutClients(Alst: TStrings); override;
  end;

  TCtxStream = class(TStream)
  protected
    nd, nb: integer;
    b, mask: byte;
    fin: TFileStream;
    fpos: int64;
    EOF: boolean;
  public
    constructor Create(AName: string);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure ReadCurrs(var r: TCurrArray);
    procedure ReadBytes(var r: TByteArray);
    procedure ReadLongs(var r: TIntArray);
    procedure ReadStrings(var r: TStringArray);
    function ReadString: AnsiString;
    function ReadRaw(cnt: integer): string;
    property Position: int64 read fpos;
  end;

var
  fctx: TCtxStream;

const
  EmptyItem: AnsiString = '<empty>';

procedure Check(cond: boolean; const msg: string);
begin
  if cond then
    exit;
  raise EAssertionFailed.Create(IntToHex(fctx.Position, 6) + ': ' + msg);
end;

function ParseKey(const key: String; client: integer; var Selector: RIndex): boolean;
var
  i, ii: integer;
  p: PChar;
  s: AnsiString;

  procedure GetNum(fDec: boolean = False);
  begin
    s := '0';
    i := 0;
    while CharInSet(p^, ['0'..'9']) do
    begin
      i := i * 10 + ord(p^) - ord('0');
      inc(p);
    end;
    if fDec then
      dec(i);
    Selector.ind[ii] := i;
    inc(ii);
  end;

begin
  Selector.client := client;
  ii := 0;
  for i := 0 to 3 do
    Selector.ind[i] := 0;
  p := PChar(key);
  if p^ = 'F' then
    inc(p);
  if p^ = 'C' then
    inc(p);
  GetNum;
  Result := (client >= 0) and (Selector.ind[0] > 0);
  if not Result then
    exit;
  if p^ = '#' then
  begin
    inc(p);
    GetNum(True);
    inc(ii);
    Result := p^ = '\';
    if not Result then
      exit;
    inc(p);
  end
  else if p^ = '\' then
  begin
    inc(p);
    GetNum;
    if p^ = '.' then
    begin
      inc(p);
      GetNum(True);
      Result := p^ = '.';
      if not Result then
        exit;
      inc(p);
    end
    else
    begin
      Selector.ind[3] := i;
      Selector.ind[ii - 1] := 0;
      ii := 4;
    end;
  end
  else
  begin
    Result := False;
    exit;
  end;
  if ii < 4 then
    GetNum;
  Result := ii = 4;
  if Result then
  begin
    case p^ of
      'R': Selector.ft := ftCurr;
      'B': Selector.ft := ftByte;
      'L': Selector.ft := ftInt;
      'S': Selector.ft := ftStr;
    else
      Result := False;
    end;
  end;
end;

procedure Populate(tv: TTreeView; Tables: TCtxItem);
var
  n: TTreeNode;
begin
  tv.Items.Clear;
  if Tables is TCtxFile then
  begin
    n := tv.Items.AddFirst(nil, 'file');
    Tables.Populate(tv.Items, n);
  end;
end;

{ TCtxItem }

function TCtxItem.CloneCount(clientNo, formNo: integer): integer;
var
  item: TCtxItem;
  items: TCtxItems absolute item;
  tables: TCtxTables absolute item;
begin
  //start in TCtxFile
  item := self;
  try
    TObject(item) := items.lst[clientNo];
    TObject(item) := items.lst[formNo];
    if item is TCtxTables then
      Result := TCtxTables(item).Clones
    else
      Result := 0;
  except
    Result := 0;
  end;
end;

function TCtxItem.FormExists(clientNo, formNo: integer): boolean;
var
  item: TCtxItem;
  items: TCtxItems absolute item;
begin
  try
    TObject(item) := items.lst[clientNo];
    TObject(item) := items.lst[formNo];
    Result := item <> nil;
  except
    Result := False;
  end;
end;

var
  RecPtr: PCtxRec;

function TCtxItem.ValueExists(const Selector: RIndex): boolean;
var
  l: integer;
begin
  try
    RecPtr := GetRecord(Selector);
    Result := RecPtr <> nil;
    if not Result then
      exit; //no such table
    case Selector.ft of
      ftCurr: l := Length(RecPtr.currs);
      ftByte: l := Length(RecPtr.bytes);
      ftInt: l := Length(RecPtr.ints);
      ftStr: l := Length(RecPtr.strings);
    else
      l := 0;
    end;
    Result := l > Selector.ind[3];
  except
    Result := False;
  end;
end;

function TCtxItem.GetByte(const Selector: RIndex): byte;
begin
  RecPtr := GetRecord(Selector);
  if assigned(RecPtr) then
    Result := RecPtr.bytes[Selector.ind[3]]
  else
    Result := 0;
end;

function TCtxItem.GetLong(const Selector: RIndex): LongInt;
begin
  RecPtr := GetRecord(Selector);
  if assigned(RecPtr) then
    Result := RecPtr.ints[Selector.ind[3]]
  else
    Result := 0;
end;

function TCtxItem.GetReal(const Selector: RIndex): Currency;
begin
  RecPtr := GetRecord(Selector);
  if assigned(RecPtr) then
    Result := RecPtr.currs[Selector.ind[3]]
  else
    Result := 0;
end;

function TCtxItem.GetString(const Selector: RIndex): String;
begin
  RecPtr := GetRecord(Selector);
  if assigned(RecPtr) then
    Result := RecPtr.strings[Selector.ind[3]]
  else
    Result := '';
end;

function TCtxItem.GetRecord(const Selector: RIndex): PCtxRec;
var
  item: TCtxItem;
  items: TCtxItems absolute item;
  i: integer;
  idx: integer;
begin
  Result := nil;
  item := self;
  if item is TCtxFile then
  begin
    TObject(item) := items.lst.Items[Selector.client];
    for i := 0 to 2 do
    begin
      if item = nil then
        exit;
      idx := Selector.ind[i];
      if items.lst.Count < 2 then
      begin
        idx := 0;
        //Selector.ind[i] := -1; //not if const
      end;
      if idx >= items.lst.Count then
        exit; //index too high
      TObject(item) := items.lst.Items[idx];
    end;
    Result := @((item as TCtxRecord).rec);
  end; // else  Result := nil;
end;

procedure TCtxItem.PutClients(Alst: TStrings);
begin
  //nop
end;

procedure TCtxItem.PutItems(Alst: TStrings; fieldType: eFieldType);
begin
  //nop
end;

{ TCtxStream }

constructor TCtxStream.Create(AName: string);
begin
  fin := TFileStream.Create(AName, fmOpenRead or fmShareDenyWrite);
  mask := $3D;
  nb := -1;
  nd := -1;
end;

destructor TCtxStream.Destroy;
begin
  fin.Free;
  fin := nil;
  inherited;
end;

function TCtxStream.Read(var Buffer; Count: Integer): Longint;
type
  PByte = ^byte;
var
  p: PByte;
begin
  Result := 0;
  if EOF then
    exit;
  inc(fpos, Count);
  pointer(p) := @Buffer;
  while Result < Count do
  begin
    if nd < 0 then
    begin
      nd := 0;
      fin.ReadBuffer(nd, 2);
      if fin.Position + nd > fin.Size then
      begin
        EOF := True;
        exit;
      end;
    end;
    while nd > 0 do
    begin
      fin.ReadBuffer(b, 1);
      dec(nd);
      p^ := b xor mask;
      inc(p);
      inc(Result);
      if Result >= Count then
        exit;
    end;
    if nb < 0 then
    begin
      nb := 0;
      fin.ReadBuffer(nb, 2);
      fin.ReadBuffer(b, 1);
      if nb = 1 then
        EOF := True;
    end;
    while nb > 0 do
    begin
      p^ := b;
      inc(p);
      dec(nb);
      inc(Result);
      if Result >= Count then
        exit;
    end;
    if EOF then
      exit;
    fin.ReadBuffer(nd, 2);
    if fin.Position + nd > fin.Size then
    begin
      EOF := True;
      exit;
    end;
    nb := -1;
  end;
end;

type
  TTbl = packed record
    tid, trep: LongInt;
  end;

var
  rtbl: TTbl;
  rrep, rdim: LongInt;

procedure TCtxStream.ReadBytes(var r: TByteArray);
begin
  if rdim > 0 then
  begin
    SetLength(r, rdim);
    ReadBuffer(r[0], 1 * rdim);
  end;
end;

procedure TCtxStream.ReadCurrs(var r: TCurrArray);
begin
  if rdim > 0 then
  begin
{$IFDEF CTXdebug}
    WriteLn('@', IntToHex(fctx.Position, 6), ' currs: ', IntToHex(rdim, 3));
{$ENDIF}
    SetLength(r, rdim);
    ReadBuffer(r[0], 8 * rdim);
  end;
end;

procedure TCtxStream.ReadLongs(var r: TIntArray);
begin
  if rdim > 0 then
  begin
{$IFDEF CTXdebug}
    WriteLn('@', IntToHex(fctx.Position, 6), ' longs: ', IntToHex(rdim, 3));
{$ENDIF}
    SetLength(r, rdim);
    ReadBuffer(r[0], 4 * rdim);
  end;
end;

function TCtxStream.ReadRaw(cnt: integer): string;
begin
  if cnt > 0 then
  begin
    SetLength(Result, cnt);
    ReadBuffer(Result[1], cnt);
  end
  else
    Result := '';
end;

function TCtxStream.ReadString: AnsiString;
var
  n: integer;
begin
  ReadBuffer(n, 4);
  if n > 0 then
  begin
    SetLength(Result, n);
    ReadBuffer(Result[1], n);
  end
  else
    Result := '';
end;

procedure TCtxStream.ReadStrings(var r: TStringArray);
var
  i, n: integer;
begin
  if rdim > 0 then
  begin
{$IFDEF CTXdebug}
    WriteLn('@', IntToHex(fctx.Position, 6), ' strgs: ', IntToHex(rdim, 3));
{$ENDIF}
    SetLength(r, rdim);
    for i := 0 to rdim - 1 do
    begin
      ReadBuffer(n, 4);
      if n > 0 then
      begin
        SetLength(r[i], n);
        ReadBuffer(r[i][1], n);
      end;
    end;
{$IFDEF CTXdebug}
    WriteLn('...@', IntToHex(fctx.Position, 6));
{$ENDIF}
  end;
end;

function TCtxStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  //implement abstract
  Result := -1; //debug only, not implemented
end;

function TCtxStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := 0;
end;

{ TCtxStrings }

function TCtxStrings.GetCaption(index: integer): String;
begin
  Result := 'strings[' + IntToStr(GetCount) + ']';
end;

function TCtxStrings.GetCount: integer;
begin
  Result := Length(strs);
end;

procedure TCtxStrings.LoadFromStream;
begin
  fpos := fctx.Position;
  fctx.ReadBuffer(rdim, 4);
  if rdim > 0 then
    fctx.ReadStrings(strs);
end;

procedure TCtxStrings.Populate(tv: TTreeNodes; tn: TTreeNode);
begin
  tn.Data := self;
end;

procedure TCtxStrings.PutItems(Alst: TStrings; fieldType: eFieldType);
var
  i, n: integer;
begin
  n := GetCount;
  Alst.Capacity := n;
  for i := 0 to n - 1 do
  begin
    if strs[i] <> '' then
      Alst.Add(IntToStr(i) + '="' + strs[i] + '"');
  end;
end;

{ TCtxNotes }

function TCtxNotes.GetCaption(index: integer): string;
begin
  Result := 'Local Notes[' + IntToStr(GetCount) + ']';
end;

procedure TCtxNotes.LoadFromStream;
var
  dummy: packed record
    b: byte;
    l: LongInt;
  end; //4, 34 -> + 8 bytes
  w: word;
  i, j, n: integer;
  s1, s2: string;
begin
  n := cnt;
  SetLength(strs, n);
  for i := 0 to n - 1 do
  begin
    fctx.ReadBuffer(dummy, 1);
    case dummy.b of
      4, 6:
        begin
          fctx.ReadBuffer(dummy.l, 4);
          s1 := string(fctx.ReadString); //20150702
          s2 := string(fctx.ReadString); //20150702
          strs[i] := s1 + '=' + s2;
          if (dummy.b = 4) then
          begin
            for j := 1 to dummy.b do
              fctx.Read(w, 2);
          end;
        end;
      5:
        begin
          fctx.ReadBuffer(dummy.b, 1);
          Check(dummy.b = 4, 'info 5?');
          s1 := string(fctx.ReadString); //20150702
          s2 := string(fctx.ReadString); //20150702
          strs[i] := s1 + '=' + s2;
          fctx.ReadBuffer(dummy.l, 4);
          fctx.ReadBuffer(dummy.l, 4);
        end;
    else //case
      Check(False, 'info not 456?');
    end;
  end;
end;

{ TCtxRecord }

function TCtxRecord.GetCount: integer;
begin
  Result := 1; //every array can have an different count
end;

procedure TCtxRecord.PutItems(Alst: TStrings; fieldType: eFieldType);
var
  i, n: integer;
begin
  Alst.Clear;
  case fieldType of
    ftCurr:
      begin
        n := Length(rec.currs);
        Alst.Capacity := n;
        for i := 0 to n - 1 do
        begin
          if rec.currs[i] <> 0 then
            Alst.Add(IntToStr(i) + '=' + FloatToStrF(rec.currs[i], ffCurrency, 9, 4));
        end;
      end;
    ftByte:
      begin
        n := Length(rec.bytes);
        Alst.Capacity := n;
        for i := 0 to n - 1 do
        begin
          if rec.bytes[i] <> 0 then
            Alst.Add(IntToStr(i) + '=' + IntToStr(rec.bytes[i]));
        end;
      end;
    ftInt:
      begin
        n := Length(rec.ints);
        Alst.Capacity := n;
        for i := 0 to n - 1 do
        begin
          if rec.ints[i] <> 0 then
            Alst.Add(IntToStr(i) + '=' + IntToStr(rec.ints[i]));
        end;
      end;
    ftStr:
      begin
        n := Length(rec.strings);
        Alst.Capacity := n;
        for i := 0 to n - 1 do
        begin
          if rec.strings[i] <> '' then
            Alst.Add(IntToStr(i) + '="' + rec.strings[i] + '"');
        end;
      end;
  end;
  if Alst.Count = 0 then
    Alst.Add('<all empty>')
end;

procedure TCtxRecord.LoadFromStream;
begin
{$IFDEF CTXdebug}
  WriteLn('@', IntToHex(fctx.Position, 6), ' rec...');
{$ENDIF}
  fpos := fctx.Position;
  fctx.ReadBuffer(rdim, 4);
  fctx.ReadCurrs(rec.currs);
  fctx.ReadBuffer(rdim, 4);
  fctx.ReadBytes(rec.bytes);
  fctx.ReadBuffer(rdim, 4);
  fctx.ReadLongs(rec.ints);
  fctx.ReadBuffer(rdim, 4);
  fctx.ReadStrings(rec.strings);
{$IFDEF CTXdebug}
  WriteLn('...@', IntToHex(fctx.Position, 6));
{$ENDIF}
end;

function TCtxRecord.GetCaption(index: integer): String;
begin
  Result := Format('%d [%d R, %d B, %d L, %d S]',
    [index, Length(rec.currs), Length(rec.bytes), Length(rec.ints),
    Length(rec.strings)]);

end;

{ TCtxRecords }

function TCtxRecords.GetCaption(index: integer): String;
begin
  Result := IntToStr(index);
  if seqNo >= 0 then
    Result := Result + '#' + IntToStr(seqNo + 1);
  Result := Result + ' [' + IntToStr(GetCount) + ']';
end;

procedure TCtxRecords.LoadFromStream;
var
  i: integer;
  rec: TCtxRecord;
begin
  fpos := fctx.Position;
  fctx.ReadBuffer(rrep, 4);
{$IFDEF CTXdebug}
  WriteLn('rrep ', rrep);
  //Check(rrep > 0, 'rrep<=0?'); - this can happen
{$ENDIF}
  if rrep > 0 then
    Clear;
  lst.Capacity := rrep;
  for i := 0 to rrep - 1 do
  begin
    rec := TCtxRecord.Create;
    rec.formNo := rtbl.tid;
    rec.seqNo := -1; //below checked for 0???
    rec.idxNo := i;
    lst.Add(rec);
  end;

  if rrep = 0 then
  begin
    //keep dummy record?
  //read record sizes!?
    fctx.ReadBuffer(rdim, 4);
    fctx.ReadBuffer(rdim, 4);
    fctx.ReadBuffer(rdim, 4);
    fctx.ReadBuffer(rdim, 4);
  end
  else if rrep = 1 then
  begin
    pointer(rec) := lst.items[0];
    rec.idxNo := -1; //not indexed, allow for seq#
    rec.seqNo := seqNo;
    rec.LoadFromStream;
  end
  else
  begin
{$IFDEF CTXdebug}
    //Check(seqNo=0, '#+i'); - failed!???
{$ENDIF}
    seqNo := -1; //???
    fctx.ReadBuffer(rdim, 4);
    for i := 0 to rrep - 1 do
    begin
      TObject(rec) := lst.Items[i];
      fctx.ReadCurrs(rec.rec.currs);
    end;
    fctx.ReadBuffer(rdim, 4);
    for i := 0 to rrep - 1 do
    begin
      TObject(rec) := lst.Items[i];
      fctx.ReadBytes(rec.rec.bytes);
    end;
    fctx.ReadBuffer(rdim, 4);
    for i := 0 to rrep - 1 do
    begin
      TObject(rec) := lst.Items[i];
      fctx.ReadLongs(rec.rec.ints);
    end;
    fctx.ReadBuffer(rdim, 4);
    for i := 0 to rrep - 1 do
    begin
      TObject(rec) := lst.Items[i];
      fctx.ReadStrings(rec.rec.strings);
    end;
  end;
end;

procedure TCtxRecord.Populate(tv: TTreeNodes; tn: TTreeNode);
begin
  tn.Data := Self;
end;

{ TCtxItems }

constructor TCtxItems.Create;
begin
  lst := TList.Create;
end;

destructor TCtxItems.Destroy;
begin
  Clear;
  lst.Free;
  lst := nil;
  inherited;
end;

procedure TCtxItems.Clear;
var
  i: integer;
  o: TObject;
begin
  for i := 0 to lst.Count - 1 do
  begin
    o := lst.Items[i];
    o.Free;
    lst.Items[i] := nil;
  end;
  lst.Clear;
end;

function TCtxItems.GetCaption(index: integer): String;
begin
  Result := IntToStr(index) + ' [' + IntToStr(GetCount) + ']';
end;

function TCtxItems.GetCount: integer;
begin
  Result := lst.Count;
end;

procedure TCtxItems.Populate(tv: TTreeNodes; tn: TTreeNode);
var
  n: TTreeNode;
  item: TCtxItem;
  rec: TCtxRecord absolute item;
  i, nn: integer;
begin
  //problem: lst with incredible count!?
  nn := lst.Count;
  //if nn > 100 then nn := 100;
  for i := 0 to nn - 1 do
  begin
    TObject(item) := lst.Items[i];
    if assigned(item) then
    begin
      n := tv.AddChild(tn, item.GetCaption(i));
      item.Populate(tv, n);
    end;
  end;
end;

{ TCtxTables }

function TCtxTables.GetCaption(index: integer): String;
begin
  Result := Format('%d:$%x [%d]', [index, self.ID, GetCount]);
end;

procedure TCtxTables.LoadFromStream;
var
  i, rep, seq, seq2, crep, skip: integer;
  item: TCtxRecords;

  procedure AddRecord;
  begin
    rtbl.tid := ID;
    item := TCtxRecords.Create;
    lst.Add(item);
    item.seqNo := seq;
  end;

begin
{$IFDEF CTXdebug}
  WriteLn('tid $', IntToHex(rtbl.tid, 4));
  WriteLn('trep ', rtbl.trep);
{$ENDIF}
  fpos := fctx.Position;
  ID := rtbl.tid;
  rep := rtbl.trep; //-1: skip!?
  seq := 0;
  if rep > 0 then
  begin
    lst.Capacity := rep;
    for i := 0 to rep - 1 do
    begin
      AddRecord;
      item.LoadFromStream;
    end;
  end
  else
  begin
    //really add empty record?
    AddRecord;
  end;
  fctx.ReadBuffer(crep, 4);
  Clones := crep;
{$IFDEF CTXdebug}
  WriteLn('@', IntToHex(fctx.Position, 6));
  Write('clones ', crep);
  WriteLn(' tid $', IntToHex(rtbl.tid, 4));
{$ENDIF}

  if crep > 0 then
  begin
    for seq := 1 to crep do
    begin
      //AddRecord; - separate: skip/present
      fctx.ReadBuffer(skip, 4);
{$IFDEF CTXdebug}
      WriteLn('skip ', skip);
{$ENDIF}
      if (skip = 0) or (skip = ID) then
      begin
        fctx.ReadBuffer(rtbl.trep, 4);
{$IFDEF CTXdebug}
        WriteLn('trep ', rtbl.trep);
        //Check(rtbl.trep=1, 'seq#+trep');
{$ENDIF}
        for seq2 := 1 to rtbl.trep do
        begin
          AddRecord;
          item.LoadFromStream;
        end
      end
      else if skip = -1 then
      begin
        //may signal end of list?
        AddRecord;
      end
      else
      begin //#records to skip??
        //Check(skip=1, 'skip>1'); - can be -1!
{$IFDEF CTXdebug}
        if MessageDlg('Table ID=' + IntToStr(rtbl.tid) + #13
          + 'Index=' + IntToStr(seq) + ' of ' + IntToStr(crep) + #13
          + 'Skip=' + IntToStr(skip) + #13
          + 'Add empty table?',
          mtConfirmation, [mbYes, mbNo], 0 {, mbYes}) = mrYes then
{$ELSE}
{$ENDIF}
        AddRecord; //really add empty record?
      end
    end;
  end;
end;

// --------------

type
  THdr2 = packed record
    l044: array[1..34] of byte;
    DIni: array[1..6] of packed record
      dt: TDateTime;
      s3: string[3];
    end;
    l0AE: array[1..31] of LongInt;
  end;

  THdr = packed record
    w00, w02: word;
    l004: array[1..10] of LongInt;
    Name: AnsiString;
    l038s: array[1..3] of string;
    r044: THdr2;
    s044: string;
    SIN: AnsiString;
    l137s: array[1..4] of string;
    case ePersonKind of
      pkTaxpayer: (spouse: boolean);
      pkSpouse: (sb: byte; sl, numDepts: LongInt);
      pkDep: (db: byte; dl: LongInt; dplus: boolean);
      pkDepLast: (lb: byte; ll: LongInt);
  end;

  THdrT2fix = packed record
    l003D: array[$3D..$A6 - 1] of byte;
    SIN: string[9]; //@A6
    l00B0: array[$B0..$BA - 1] of byte;
    l0BA: LongInt;
  end;

  THdrT2 = packed record
    Name: AnsiString;
    fix: THdrT2fix;
  end;

var
  hdr: THdr;
  hT2: THdrT2;
  maxPerson: integer;

  { TCtxPerson }

function TCtxPerson.GetCaption(index: integer): String;
begin
  Result := Name;
end;

procedure TCtxPerson.LoadFromStream;
type
  TUpd = packed record
    case integer of
      0: (l: LongInt; b: byte);
      1: (w1, w2, w3: word);
  end;
var
  item: TCtxTables;
  upd: TUpd;
begin
{$IFDEF CTXdebug}
  WriteLn('@', IntToHex(fctx.Position, 6));
{$ENDIF}
  fpos := fctx.Position;
  lst.Capacity := $200;
  fctx.ReadBuffer(rtbl, sizeof(rtbl));
  {.$IFDEF CTXdebug}
  Check(rtbl.tid = 1, 'bad start');
  Check(rtbl.trep = 1, 'bad start');
  {.$ENDIF}
  while rtbl.tid > 0 do
  begin
    item := TCtxTables.Create;
    while rtbl.tid >= lst.Count do
      lst.Add(nil);
{$IFDEF CTXdebug}
    Check(lst.Items[rtbl.tid] = nil, 'dupe table');
{$ENDIF}
    lst.Items[rtbl.tid] := item;
    item.LoadFromStream;
    fctx.ReadBuffer(rtbl, sizeof(rtbl));
  end;
  upd.l := rtbl.trep;
  fctx.ReadBuffer(upd.w3, 2);
  {.$IFDEF CTXdebug}
  Check(upd.w1 = $AF03, 'bad upd');
  {.$ENDIF}
  if upd.w2 > 0 then
  begin
    //upd.w2 is number of local notes
    s1 := TCtxNotes.Create;
    s1.cnt := upd.w2; //l?
    lst.Add(s1);
    s1.LoadFromStream;
  end;
  if kind <> pkTaxpayer then
  begin
    s2 := TCtxStrings.Create;
    lst.Add(s2);
    s2.LoadFromStream;
  end;
end;

function TCtxPerson.LoadHeader(index: integer): boolean;
var
  cnt: integer;
begin
  Name := string(fctx.ReadString); //20150702
  if kind = pkTaxpayer then
  begin
    hdr.l038s[1] := string(fctx.ReadString); //20150702
    hdr.l038s[2] := string(fctx.ReadString); //20150702
    hdr.l038s[3] := string(fctx.ReadString); //20150702
  end;
  //if (hdr.w00 = $7F0) and (hdr.w02 = 3) then begin
  if hdr.w00 = $7E3 then
  begin
    //T2, all hdr.w02
    fctx.ReadBuffer(cnt, 4);
    if cnt = 0 then
      hdr.s044 := fctx.ReadRaw($75 - 4)
    else
      hdr.s044 := fctx.ReadRaw(cnt); //encrypted block
    //T2, no dependants
    Result := False;
    exit;
  end;

  if (hdr.w02 = 3) or (hdr.w02 = 2) then //20181221 Igor
  begin
    hdr.s044 := string(fctx.ReadString); //20150702
  end
  else
  begin
    fctx.ReadBuffer(hdr.r044, sizeof(hdr.r044));
    SIN := string(fctx.ReadString); //20150702
    hdr.l137s[1] := string(fctx.ReadString); //20150702
    hdr.l137s[2] := string(fctx.ReadString); //20150702
    hdr.l137s[3] := string(fctx.ReadString); //20150702
    hdr.l137s[4] := string(fctx.ReadString); //20150702
  end;
  {
    if hdr.w00 = $7E3 then begin
    //T2, no dependants
      Result := False;
      exit;
    end;
  }
  fctx.ReadBuffer(Result, 1);
  if Result then
  begin
    if kind = pkTaxpayer then
      maxPerson := index + 1;
    exit;
  end;
  fctx.ReadBuffer(hdr.ll, 4);

  if hdr.w00 < $7F0 then
  begin
    case kind of
      pkTaxpayer, pkDepLast: exit;
      pkSpouse:
        begin
          fctx.ReadBuffer(hdr.numDepts, 4);
          if hdr.numDepts = 0 then
            exit;
          fctx.ReadBuffer(Result, 1);
        end;
      pkDep:
        begin
          Result := index <= hdr.numDepts;
          if Result then
            fctx.ReadBuffer(Result, 1)
          else
            kind := pkDepLast;
        end;
    end;
  end
  else
  begin
    if (kind = pkSpouse) and (hdr.numDepts > 0) then
    begin
      kind := pkDep;
    end;

    case kind of
      pkTaxpayer:
        if hdr.ll = 0 then
          Result := False
        else
        begin
          hdr.numDepts := hdr.ll;
          maxPerson := index + hdr.numDepts;
          fctx.ReadBuffer(Result, 1);
        end;

      pkSpouse:
        begin
          fctx.ReadBuffer(hdr.numDepts, 4);
          if hdr.numDepts = 0 then
            Result := False
          else
          begin
            maxPerson := index + hdr.numDepts;
            fctx.ReadBuffer(Result, 1);
          end;
        end;

      pkDep:
        begin
          Result := index < maxPerson;
          if Result then
            fctx.ReadBuffer(Result, 1)
          else
            kind := pkDepLast;
        end;
      pkDepLast: exit;
    end;
  end;
end;

{ TCtxFile }

procedure TCtxFile.LoadFromStream;
var
  p: TCtxPerson;
  i: integer;
  pk: ePersonKind;
begin
  fpos := fctx.Position;
  p := nil; //keep compiler happy
  // ShowMessage('Detected format: $'+IntToHex(hdr.w00,4)+' $'+IntToHex(hdr.w02,2));
  if hdr.w00 <= $07E3 then
  begin
    //T2
    if hdr.w02 = 0 then
    begin
      p := TCtxPerson.Create;
      hT2.Name := fctx.ReadString;
      p.Name := string(hT2.Name); //20150702
      i := lst.Add(p);
      fctx.ReadBuffer(hT2.fix, sizeof(hT2.fix));
      p.SIN := string(hT2.fix.SIN); //20150702
      p.LoadFromStream;
    end
    else if (hdr.w02 = 3) or (hdr.w02 = 2) then // 20180913 Igor
    begin
      p := TCtxPerson.Create;
      p.LoadHeader(0);
      i := lst.Add(p);
      //fctx.ReadString;
      p.LoadFromStream; //L: 1,1,1,1E
    end
    else
      assert(False, 'unknown w02: $' + IntToHex(hdr.w02, 4));
  end
  else
  begin
    //T1
    pk := pkTaxpayer;
    maxPerson := 0;
    repeat
      p := TCtxPerson.Create;
      i := lst.Add(p);
      p.kind := pk;
      if not p.LoadHeader(i) then
        break;
      if pk < pkDep then
        inc(pk);
    until i >= maxPerson;
    for i := 0 to lst.Count - 1 do
    begin
      TObject(p) := lst.Items[i];
      p.LoadFromStream;
    end;
    TObject(p) := lst.Items[0];
  end;
  p.s2 := TCtxStrings.Create;
  p.lst.Add(p.s2);
  p.s2.LoadFromStream;
end;

procedure TCtxFile.PutClients(Alst: TStrings);
var
  i: integer;
  o: TObject;
  p: TCtxPerson absolute o;
begin
  Alst.Clear;
  for i := 0 to lst.Count - 1 do
  begin
    o := lst.Items[i];
    Alst.AddObject(p.Name, p);
  end;
end;

function LoadCtx(const fn: string): TCtxItem;
begin
  fctx := TCtxStream.Create(fn);
  try
    fctx.ReadBuffer(hdr.w00, 4);
    fctx.ReadBuffer(hdr.l004, sizeof(hdr.l004));
    fctx.mask := $20;
    Result := TCtxFile.Create;
    try
      Result.LoadFromStream;
    except
      //Result := nil;
      Beep;
    end;
  finally
    fctx.Free;
    fctx := nil;
  end;
end;

end.

