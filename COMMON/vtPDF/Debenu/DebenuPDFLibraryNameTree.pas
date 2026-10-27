{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryNameTree.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryNameTree;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure;

type
  TPDFNumTreeItem = record
    Num: Integer;
    Obj: TPDFObject;
  end;

  TPDFNumTreeList = array of TPDFNumTreeItem;

function NameTreeLookup(Tree: TPDFDictionary; const Name: AnsiString): TPDFObject;
function NumTreeLookup(Tree: TPDFDictionary; Number: Integer): TPDFObject;
procedure NumTreeSet(Tree: TPDFDictionary; Number: Integer; Value: TPDFObject);
procedure EnumNumTree(Tree: TPDFDictionary; var List: TPDFNumTreeList);

implementation

type
  TPDFTreeSearch = record
    Container: TPDFArray;
    Pos: Integer;
    Match: Boolean;    
  end;

function NameTreeLookup(Tree: TPDFDictionary; const Name: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
  TestNode: TPDFDictionary;
  HasKids: Boolean;
  HasNames: Boolean;
  HasLimits: Boolean;
  Root: TPDFDictionary;
  Names: TPDFArray;
  Kids: TPDFArray;
  X: Integer;
  KidRef: TPDFIndRef;
  Found: Boolean;
  S: AnsiString;

  procedure CheckNode;
  begin
    HasKids := Assigned(TestNode.FindValueByKeyName('Kids', False));
    HasNames := Assigned(TestNode.FindValueByKeyName('Names', False));
    HasLimits := Assigned(TestNode.FindValueByKeyName('Limits', False));
  end;

  function InRange(R: TPDFIndRef): Boolean;
  var
    O: TPDFObject;
    D: TPDFDictionary;
    L1: TPDFObject;
    L2: TPDFObject;
  begin
    Result := False;
    if Assigned(R) then
    begin
      O := R.Obj;
      if O is TPDFDictionary then
      begin
        D := TPDFDictionary(O);
        O := D.FindValueByKeyName('Limits', True);
        if (O is TPDFArray) and (TPDFArray(O).Count = 2) then
        begin
          L1 := TPDFArray(O).Item[0];
          L2 := TPDFArray(O).Item[1];
          if (L1 is TPDFString) and (L2 is TPDFString) then
          begin
            Result := (Name >= TPDFString(L1).AsString) and
              (Name <= TPDFString(L2).AsString);
          end;
        end;
      end;
    end;
  end;

begin
  Result := nil;
  if Assigned(Tree) then
  begin
    TestNode := Tree;
    CheckNode;
    if (HasKids xor HasNames) then
    begin
      Root := TestNode;
      if HasNames then
      begin
        Obj := Root.FindValueByKeyName('Names', True);
        if Obj is TPDFArray then
        begin
          Names := TPDFArray(Obj);
          S := Names.Output;
          for X := 0 to (Names.Count div 2) - 1 do
          begin
            if (Names.Item[X * 2] is TPDFString) and (TPDFString(Names.Item[X * 2]).AsString = Name) then
              Result := Names.Item[X * 2 + 1];
          end;
        end;
      end else
      if HasKids then
      begin
        Obj := Root.FindValueByKeyName('Kids', True);
        if Obj is TPDFArray then
        begin
          Kids := TPDFArray(Obj);
          X := 0;
          Found := False;
          while (X < Kids.Count) and (not Found) do
          begin
            Obj := Kids.Item[X];
            if Obj is TPDFIndRef then
            begin
              KidRef := TPDFIndRef(Obj);
              if InRange(KidRef) then
              begin
                Found := True;
                Obj := KidRef.Obj;
                if Obj is TPDFDictionary then
                  Result := NameTreeLookup(TPDFDictionary(Obj), Name);
              end;
            end;
            Inc(X);
          end;
        end;
      end;
    end;
  end;
end;

function NumTreeLookup(Tree: TPDFDictionary; Number: Integer): TPDFObject;
var
  Obj: TPDFObject;
  TestNode: TPDFDictionary;
  HasKids: Boolean;
  HasNums: Boolean;
  HasLimits: Boolean;
  Root: TPDFDictionary;
  Nums: TPDFArray;
  Kids: TPDFArray;
  X: Integer;
  KidRef: TPDFIndRef;
  Found: Boolean;
  S: AnsiString;

  procedure CheckNode;
  begin
    HasKids := Assigned(TestNode.FindValueByKeyName('Kids', False));
    HasNums := Assigned(TestNode.FindValueByKeyName('Nums', False));
    HasLimits := Assigned(TestNode.FindValueByKeyName('Limits', False));
  end;

  function InRange(R: TPDFIndRef): Boolean;
  var
    O: TPDFObject;
    D: TPDFDictionary;
    L1: TPDFObject;
    L2: TPDFObject;
  begin
    Result := False;
    if Assigned(R) then
    begin
      O := R.Obj;
      if O is TPDFDictionary then
      begin
        D := TPDFDictionary(O);
        O := D.FindValueByKeyName('Limits', True);
        if (O is TPDFArray) and (TPDFArray(O).Count = 2) then
        begin
          L1 := TPDFArray(O).Item[0];
          L2 := TPDFArray(O).Item[1];
          if (L1 is TPDFNumeric) and (L2 is TPDFNumeric) then
          begin
            Result := (Number >= TPDFNumeric(L1).AsInteger) and
              (Number <= TPDFNumeric(L2).AsInteger);
          end;
        end;
      end;
    end;
  end;

begin
  Result := nil;
  if Assigned(Tree) then
  begin
    TestNode := Tree;
    CheckNode;
    if (HasKids xor HasNums) then
    begin
      Root := TestNode;
      if HasNums then
      begin
        Obj := Root.FindValueByKeyName('Nums', True);
        if Obj is TPDFArray then
        begin
          Nums := TPDFArray(Obj);
          S := Nums.Output;
          for X := 0 to (Nums.Count div 2) - 1 do
          begin
            if (Nums.Item[X * 2] is TPDFNumeric) and (TPDFNumeric(Nums.Item[X * 2]).AsInteger = Number) then
              Result := Nums.Item[X * 2 + 1];
          end;
        end;
      end else
      if HasKids then
      begin
        Obj := Root.FindValueByKeyName('Kids', True);
        if Obj is TPDFArray then
        begin
          Kids := TPDFArray(Obj);
          X := 0;
          Found := False;
          while (X < Kids.Count) and (not Found) do
          begin
            Obj := Kids.Item[X];
            if Obj is TPDFIndRef then
            begin
              KidRef := TPDFIndRef(Obj);
              if InRange(KidRef) then
              begin
                Found := True;
                Obj := KidRef.Obj;
                if Obj is TPDFDictionary then
                  Result := NumTreeLookup(TPDFDictionary(Obj), Number);
              end;
            end;
            Inc(X);
          end;
        end;
      end;
    end;
  end;
end;

procedure NumTreeSet(Tree: TPDFDictionary; Number: Integer; Value: TPDFObject);
var
  Obj: TPDFObject;
  Nums: TPDFArray;
  X: Integer;
  R: TPDFTreeSearch;
  S: AnsiString;
begin
  S := Tree.Output;
  R.Container := nil;
  Obj := Tree.FindValueByKeyName('Nums', True);
  if Obj is TPDFArray then
  begin
    Nums := TPDFArray(Obj);
    R.Container := Nums;
    R.Pos := -2;
    R.Match := False;
    for X := 0 to Nums.Count - 1 do
    begin
      Obj := Nums.Item[X];
      if (Obj is TPDFNumeric) and (TPDFNumeric(Obj).AsInteger < Number) then
      begin
        R.Container := Nums;
        R.Pos := X;
        R.Match := False;
      end;
      if (Obj is TPDFNumeric) and (TPDFNumeric(Obj).AsInteger = Number) then
      begin
        R.Container := Nums;
        R.Pos := X;
        R.Match := True;
      end;
    end;
  end;
  if Assigned(R.Container) then
  begin
    if R.Match then
      R.Container.Replace(R.Pos + 1, Value)
    else
    begin
      R.Container.Insert(R.Pos + 2, Value);
      R.Container.Insert(R.Pos + 2, R.Container.Owner.NewNumeric(Number));
    end;
  end else
  begin
    Nums := Tree.Owner.NewArray;
    Tree.Add('Nums', Nums);
    Nums.Add(Tree.Owner.NewNumeric(Number));
    Nums.Add(Value);    
  end;
end;

procedure EnumNumTree(Tree: TPDFDictionary; var List: TPDFNumTreeList);
var
  Obj: TPDFObject;
  Nums: TPDFArray;
  Kids: TPDFArray;
  X: Integer;
begin
  Obj := Tree.FindValueByKeyName('Kids', True);
  if Obj is TPDFArray then
  begin
    Kids := TPDFArray(Obj);
    for X := 0 to Kids.Count - 1 do
    begin
      Obj := Kids.Item[X];
      if Obj is TPDFIndRef then
      begin
        Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFDictionary then
        begin
          EnumNumTree(TPDFDictionary(Obj), List);
        end;
      end;
    end;
  end else
  begin
    Obj := Tree.FindValueByKeyName('Nums', True);
    if Obj is TPDFArray then
    begin
      Nums := TPDFArray(Obj);
      for X := 0 to Nums.Count - 2 do
      begin
        if Nums.Item[X] is TPDFNumeric then
        begin
          SetLength(List, Length(List) + 1);
          List[Length(List) - 1].Num := TPDFNumeric(Nums.Item[X]).AsInteger;
          List[Length(List) - 1].Obj := Nums.Item[X + 1];
        end;
      end;
    end;
  end;
end;

end.
