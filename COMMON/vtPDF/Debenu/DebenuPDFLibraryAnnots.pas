{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryAnnots.pas                             }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryAnnots;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure;

type
  TTagInteger = record
    Tag: Integer;
    Value: Integer;
  end;

  TTagDouble = record
    Tag: Integer;
    Value: Double;
  end;

  TTagString = record
    Tag: Integer;
    Value: WideString;
  end;

  TFindPageEvent = function(PageRef: TPDFIndRef): Integer of object;

  TPDFAnnots = class
  private
    FAnnots: TPDFArray;
    FIntegerProps: array of TTagInteger;
    FDoubleProps: array of TTagDouble;
    FStringProps: array of TTagString;
    FLastAnalysis: Integer;
    FOnFindPage: TFindPageEvent;
    procedure ClearProps;
    procedure AddIntegerProp(Tag, Value: Integer);
    procedure AddDoubleProp(Tag: Integer; Value: Double);
    procedure AddStringProp(Tag: Integer; const Value: WideString);
    function FindObject(IR: TPDFIndRef): TPDFObject;
    function FindDictObj(D: TPDFDictionary; const Key: AnsiString): TPDFObject;
    function GetAnnotDict(Index: Integer): TPDFDictionary;
  public
    constructor Create;
    procedure Attach(AAnnots: TPDFArray);
    function Count: Integer;
    procedure Clear;
    procedure AnalyseAnnot(Index: Integer);
    function GetAnnotRef(Index: Integer): TPDFIndRef;
    function GetAnnotRect(Index: Integer): TPDFArray;
    procedure SetRotation(Index, NewRotation: Integer);
    function GetRotation(Index: Integer): Integer;
    function GetAnnotAction(Index: Integer): TPDFDictionary;
    function GetAnnotDest(Index: Integer): TPDFObject;
    function GetAnnotQuadCount(Index: Integer): Integer;
    function GetAnnotQuadPoints(Index, QuadNumber, PointNumber: Integer): Double;
    procedure SetAnnotQuadPoints(Index, QuadNumber: Integer; X1, Y1, X2, Y2,
      X3, Y3, X4, Y4: Double);
    function GetDoubleProp(Tag: Integer): Double;
    function SetDoubleProp(Index, Tag: Integer; NewValue: Double): Boolean;
    function SetRect(Index: Integer; Left, Top, Width, Height: Double): Boolean;
    function GetIntegerProp(Tag: Integer): Integer;
    function SetIntegerProp(Index, Tag, NewValue: Integer): Boolean;
    function SetIndRefProp(Index, Tag: Integer; NewValue: TPDFIndRef): Boolean;
    function GetStringProp(Tag: Integer): WideString;
    function SetStringProp(Index, Tag: Integer; const NewValue: WideString): Boolean;
    function SetOCG(Index: Integer; OCGRef: TPDFIndRef): Boolean;
    function SetContents(Index: Integer; const C: AnsiString): Boolean;
    function SetBorderColor(Index: Integer; Red, Green, Blue: Double): Boolean;
    function SetMarkupAnnotStyle(Index: Integer; Red, Green, Blue, Transparency: Double): Boolean;
    function SetBorderColorCMYK(Index: Integer; C, M, Y, K: Double): Boolean;
    function AnnotSubtype(Index: Integer): AnsiString;
    function AnnotHasParent(Index: Integer): Boolean;
    function GetSound(Index, Options: Integer): AnsiString;
    function GetEmbeddedFileName(Index: Integer): WideString;
    function GetFile(Index: Integer): AnsiString;
    function SetBorderStyle(Index: Integer; Width: Double;
      const Style: AnsiString; DashOn, DashOff: Double): Boolean;
    property OnFindPage: TFindPageEvent read FOnFindPage write FOnFindPage;
  end;

implementation

uses
  DebenuPDFLibraryFontConst, DebenuPDFLibraryExtra, DebenuPDFLibraryEncoding;

{ TPDFAnnots }

procedure TPDFAnnots.AddDoubleProp(Tag: Integer; Value: Double);
var
  L: Integer;
begin
  L := Length(FDoubleProps);
  SetLength(FDoubleProps, L + 1);
  FDoubleProps[L].Tag := Tag;
  FDoubleProps[L].Value := Value;
end;

procedure TPDFAnnots.AddIntegerProp(Tag, Value: Integer);
var
  L: Integer;
begin
  L := Length(FIntegerProps);
  SetLength(FIntegerProps, L + 1);
  FIntegerProps[L].Tag := Tag;
  FIntegerProps[L].Value := Value;
end;

procedure TPDFAnnots.AddStringProp(Tag: Integer; const Value: WideString);
var
  L: Integer;
begin
  L := Length(FStringProps);
  SetLength(FStringProps, L + 1);
  FStringProps[L].Tag := Tag;
  FStringProps[L].Value := Value;
end;

procedure TPDFAnnots.AnalyseAnnot(Index: Integer);
var
  AnnotDict: TPDFDictionary;
  BSDict: TPDFDictionary;
  Obj: TPDFObject;
  Rect: TPDFArray;
  LLX, LLY, URX, URY: Double;
  Temp: Double;
  Subtype: AnsiString;
  ActionDict: TPDFDictionary;
  WinDict: TPDFDictionary;
  FDict: TPDFDictionary;
  DArray: TPDFArray;
  CArray: TPDFArray;
const
  NonMarkup: AnsiString = '*Link*Popup*Movie*Widget*Screen*PrinterMark*TrapNet';
begin
  if (Index <> FLastAnalysis) and (Assigned(FAnnots)) then
  begin
    ClearProps;
    if (Index >= 0) and (Index < FAnnots.Count) then
    begin
      Obj := FAnnots.Item[Index];
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
      begin
        AnnotDict := TPDFDictionary(Obj);
        Obj := FindDictObj(AnnotDict, 'Type');
        if (not Assigned(Obj)) or ((Obj is TPDFName) and (TPDFName(Obj).Name = 'Annot')) then
        begin
          Subtype := '';
          Obj := FindDictObj(AnnotDict, 'Subtype');
          if Obj is TPDFName then
          begin
            Subtype := TPDFName(Obj).Name;
            AddStringProp(101, QPLLatin1ToWideString(Subtype));
          end;
          Obj := FindDictObj(AnnotDict, 'Contents');
          if Obj is TPDFString then
            AddStringProp(102, TPDFString(Obj).AsTextString);
          Obj := FindDictObj(AnnotDict, 'NM');
          if Obj is TPDFString then
            AddStringProp(103, TPDFString(Obj).AsTextString);
          Obj := FindDictObj(AnnotDict, 'Subj');
          if Obj is TPDFString then
            AddStringProp(127, TPDFString(Obj).AsTextString);
          Obj := AnnotDict.FindValueByKeyName('IRT');
          if Obj is TPDFIndRef then
            AddIntegerProp(128, FAnnots.ItemIndexMatch(TPDFIndRef(Obj)) + 1);
          Obj := FindDictObj(AnnotDict, 'M');
          if Obj is TPDFString then
            AddStringProp(104, TPDFString(Obj).AsTextString);

          Obj := FindDictObj(AnnotDict, 'OverlayText');
          if Obj is TPDFString then
            AddStringProp(140, TPDFString(Obj).AsTextString);

          Obj := FindDictObj(AnnotDict, 'Rect');
          if Obj is TPDFArray then
          begin
            Rect := TPDFArray(Obj);
            LLX := 0;
            LLY := 0;
            URX := 0;
            URY := 0;
            if (Rect.Count > 0) and (Rect.Item[0] is TPDFNumeric) then
              LLX := TPDFNumeric(Rect.Item[0]).AsDouble;
            if (Rect.Count > 1) and (Rect.Item[1] is TPDFNumeric) then
              LLY := TPDFNumeric(Rect.Item[1]).AsDouble;
            if (Rect.Count > 2) and (Rect.Item[2] is TPDFNumeric) then
              URX := TPDFNumeric(Rect.Item[2]).AsDouble;
            if (Rect.Count > 3) and (Rect.Item[3] is TPDFNumeric) then
              URY := TPDFNumeric(Rect.Item[3]).AsDouble;
            if LLX > URX then
            begin
              Temp := LLX;
              LLX := URX;
              URX := Temp;
            end;
            if LLY > URY then
            begin
              Temp := LLY;
              LLY := URY;
              URY := Temp;
            end;
            AddDoubleProp(105, LLX);
            AddDoubleProp(106, URY);
            AddDoubleProp(107, URX - LLX);
            AddDoubleProp(108, URY - LLY);
          end;
          Obj := FindDictObj(AnnotDict, 'BS');
          if (Obj is TPDFDictionary) then
          begin
            BSDict := TPDFDictionary(Obj);
            Obj := FindDictObj(BSDict, 'W');
            if (Obj is TPDFNumeric) then
            begin
              AddDoubleProp(132, TPDFNumeric(Obj).AsDouble);
            end else
            begin
              AddDoubleProp(132, 1);
            end;
          end;
          Obj := FindDictObj(AnnotDict, 'F');
          if Obj is TPDFNumeric then
            AddIntegerProp(109, TPDFNumeric(Obj).AsInteger);
          if QPLPos('*' + Subtype, NonMarkup) = 0 then
          begin
            Obj := FindDictObj(AnnotDict, 'T');
            if Obj is TPDFString then
              AddStringProp(110, TPDFString(Obj).AsTextString);
          end;
          Obj := FindDictObj(AnnotDict, 'A');
          if Obj is TPDFDictionary then
          begin
            ActionDict := TPDFDictionary(Obj);
            Obj := FindDictObj(ActionDict, 'S');
            if (Obj is TPDFName) then
            begin
              AddStringProp(112, QPLLatin1ToWideString(TPDFName(Obj).Name));
              if (TPDFName(Obj).Name = 'URI') then
              begin
                Obj := FindDictObj(ActionDict, 'URI');
                if Obj is TPDFString then
                begin
                  AddStringProp(111, QPLUTF8DecodeIgnore(TPDFString(Obj).AsString));
                end;
              end else
              if (TPDFName(Obj).Name = 'JavaScript') then
              begin
                Obj := FindDictObj(ActionDict, 'JS');
                if Obj is TPDFString then
                begin
                  AddStringProp(134, TPDFString(Obj).AsTextString);
                end;
              end else
              if (TPDFName(Obj).Name = 'Launch') then
              begin
                Obj := FindDictObj(ActionDict, 'Win');
                if Obj is TPDFDictionary then
                begin
                  WinDict := TPDFDictionary(Obj);
                  Obj := FindDictObj(WinDict, 'F');
                  if Obj is TPDFString then
                  begin
                    AddStringProp(113, TPDFString(Obj).AsTextString);
                  end;
                end;

                Obj := FindDictObj(ActionDict, 'F');
                if Obj is TPDFDictionary then
                begin
                  FDict := TPDFDictionary(Obj);
                  Obj := FindDictObj(FDict, 'F');
                  if Obj is TPDFString then
                  begin
                    AddStringProp(114, TPDFString(Obj).AsTextString);
                  end;
                  Obj := FindDictObj(FDict, 'UF');
                  if Obj is TPDFString then
                  begin
                    AddStringProp(129, TPDFString(Obj).AsTextString);
                  end;
                end else
                if (Obj is TPDFString) then
                begin
                  AddStringProp(114, TPDFString(Obj).AsTextString);
                end;

                Obj := FindDictObj(ActionDict, 'NewWindow');
                if (Obj is TPDFBoolean) then
                begin
                  if (TPDFBoolean(Obj).AsBoolean) then
                    AddIntegerProp(133, 1)
                  else
                    AddIntegerProp(133, 2);
                end;
              end else
              if (TPDFName(Obj).Name = 'GoTo') then
              begin
                Obj := FindDictObj(ActionDict, 'D');
                if Obj is TPDFArray then
                begin
                  DArray := TPDFArray(Obj);
                  if (DArray.Count > 0) then
                  begin
                    Obj := DArray.Item[0];
                    if (Obj is TPDFIndRef) and Assigned(FOnFindPage) then
                    begin
                      AddIntegerProp(131, FOnFindPage(TPDFIndRef(Obj)));
                    end;
                  end;
                end;
              end else
              if (TPDFName(Obj).Name = 'GoToR') then
              begin
                Obj := FindDictObj(ActionDict, 'F');
                if Obj is TPDFDictionary then
                begin
                  FDict := TPDFDictionary(Obj);
                  Obj := FindDictObj(FDict, 'F');
                  if Obj is TPDFString then
                  begin
                    AddStringProp(115, TPDFString(Obj).AsTextString);
                  end;
                  Obj := FindDictObj(FDict, 'UF');
                  if Obj is TPDFString then
                  begin
                    AddStringProp(130, TPDFString(Obj).AsTextString);
                  end;
                end else
                if Obj is TPDFString then
                begin
                  AddStringProp(115, TPDFString(Obj).AsTextString);
                end;

                Obj := FindDictObj(ActionDict, 'D');
                if Obj is TPDFArray then
                begin
                  DArray := TPDFArray(Obj);
                  if (DArray.Count > 0) then
                  begin
                    Obj := DArray.Item[0];
                    if Obj is TPDFNumeric then
                    begin
                      AddIntegerProp(116, TPDFNumeric(Obj).AsInteger + 1);
                    end;
                  end;
                end;

                Obj := FindDictObj(ActionDict, 'NewWindow');
                if (Obj is TPDFBoolean) then
                begin
                  if (TPDFBoolean(Obj).AsBoolean) then
                    AddIntegerProp(133, 1)
                  else
                    AddIntegerProp(133, 2);
                end;
              end;
            end;
          end;
          Obj := FindDictObj(AnnotDict, 'C');
          if Obj is TPDFArray then
          begin
            CArray := TPDFArray(Obj);
            case CArray.Count of
              1:
              begin
                AddStringProp(118, 'Gray');
                if CArray.Item[0] is TPDFNumeric then
                  AddDoubleProp(119, TPDFNumeric(CArray.Item[0]).AsDouble);
              end;
              3:
              begin
                AddStringProp(118, 'RGB');
                if CArray.Item[0] is TPDFNumeric then
                  AddDoubleProp(120, TPDFNumeric(CArray.Item[0]).AsDouble);
                if CArray.Item[1] is TPDFNumeric then
                  AddDoubleProp(121, TPDFNumeric(CArray.Item[1]).AsDouble);
                if CArray.Item[2] is TPDFNumeric then
                  AddDoubleProp(122, TPDFNumeric(CArray.Item[2]).AsDouble);
              end;
              4:
              begin
                AddStringProp(118, 'CMYK');
                if CArray.Item[0] is TPDFNumeric then
                  AddDoubleProp(123, TPDFNumeric(CArray.Item[0]).AsDouble);
                if CArray.Item[1] is TPDFNumeric then
                  AddDoubleProp(124, TPDFNumeric(CArray.Item[1]).AsDouble);
                if CArray.Item[2] is TPDFNumeric then
                  AddDoubleProp(125, TPDFNumeric(CArray.Item[2]).AsDouble);
                if CArray.Item[3] is TPDFNumeric then
                  AddDoubleProp(126, TPDFNumeric(CArray.Item[3]).AsDouble);
              end;
            end;
          end;
        end;
      end;
    end;
    FLastAnalysis := Index;
  end;
end;

// Checks if the annotation with the specified zero-based
// index has a /Parent entry
function TPDFAnnots.AnnotHasParent(Index: Integer): Boolean;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
begin
  Result := False;

  // Check that Index is within range
  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];

    // Get the annotation dictionary
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      AnnotDict := TPDFDictionary(Obj);

      // Look for a /Parent entry
      Obj := AnnotDict.FindValueByKeyName('Parent');
      Result := Obj is TPDFIndRef;
    end;
  end;
end;

// Returns the /Subtype name of the annotation with the specified
// zero-based index
function TPDFAnnots.AnnotSubtype(Index: Integer): AnsiString;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
begin
  Result := '';

  // Check that Index is within range
  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];

    // Get the annotation dictionary
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      AnnotDict := TPDFDictionary(Obj);

      // Check that /Type is /Annot
      Obj := FindDictObj(AnnotDict, 'Type');
      if (not Assigned(Obj)) or ((Obj is TPDFName) and (TPDFName(Obj).Name = 'Annot')) then
      begin

        // Get the /Subtype entry
        Obj := FindDictObj(AnnotDict, 'Subtype');
        if Obj is TPDFName then
        begin
          // Return the value if the object is a Name object
          Result := TPDFName(Obj).Name;
        end;
      end;
    end;
  end;
end;

procedure TPDFAnnots.Attach(AAnnots: TPDFArray);
begin
  Clear;
  FAnnots := AAnnots;
end;

procedure TPDFAnnots.Clear;
begin
  FAnnots := nil;
  FLastAnalysis := -1;
  ClearProps;
end;

procedure TPDFAnnots.ClearProps;
begin
  SetLength(FIntegerProps, 0);
  SetLength(FDoubleProps, 0);
  SetLength(FStringProps, 0);
end;

function TPDFAnnots.Count: Integer;
begin
  if Assigned(FAnnots) then
    Result := FAnnots.Count
  else
    Result := 0;
end;

constructor TPDFAnnots.Create;
begin
  Clear;
end;

function TPDFAnnots.FindDictObj(D: TPDFDictionary;
  const Key: AnsiString): TPDFObject;
begin
  Result := D.FindValueByKeyName(Key, False);
  if Result is TPDFIndRef then Result := FindObject(TPDFIndRef(Result));
end;

function TPDFAnnots.FindObject(IR: TPDFIndRef): TPDFObject;
begin
  Result := IR.Obj;
end;

function TPDFAnnots.GetAnnotAction(Index: Integer): TPDFDictionary;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
begin
  Result := nil;
  Obj := FAnnots.Item[Index];
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFDictionary then
  begin
    AnnotDict := TPDFDictionary(Obj);
    Obj := AnnotDict.FindValueByKeyName('A', True);
    if Obj is TPDFDictionary then
      Result := TPDFDictionary(Obj);
  end;
end;

function TPDFAnnots.GetAnnotDest(Index: Integer): TPDFObject;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
begin
  Result := nil;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('Dest', True);
    if Assigned(Obj) then
    begin
      Result := Obj;
    end;
  end;
end;

function TPDFAnnots.GetAnnotDict(Index: Integer): TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      Result := TPDFDictionary(Obj);
    end;
  end;
end;

function TPDFAnnots.GetAnnotQuadCount(Index: Integer): Integer;
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := 0;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('QuadPoints', True);
    if Obj is TPDFArray then
    begin
      // Each quad has eight values so divide the number of array
      // items by eight to determine the number of quads
      Result := TPDFArray(Obj).Count div 8;
    end;
  end;
end;

function TPDFAnnots.GetAnnotQuadPoints(Index, QuadNumber,
  PointNumber: Integer): Double;
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
  ItemIndex: Integer;
begin
  Result := 0;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('QuadPoints', True);
    if Obj is TPDFArray then
    begin
      // Each quad has eight values
      ItemIndex := (QuadNumber - 1) * 8 - 1;
      case PointNumber of
        1: Inc(ItemIndex, 5);
        2: Inc(ItemIndex, 6);
        3: Inc(ItemIndex, 7);
        4: Inc(ItemIndex, 8);
        5: Inc(ItemIndex, 3);
        6: Inc(ItemIndex, 4);
        7: Inc(ItemIndex, 1);
        8: Inc(ItemIndex, 2);
      end;
      if ((ItemIndex >= 0) and (ItemIndex < TPDFArray(Obj).Count)) then
      begin
        Obj := TPDFArray(Obj).Item[ItemIndex];
        if (Obj is TPDFNumeric) then
        begin
          Result := TPDFNumeric(Obj).AsDouble;
        end;
      end;
    end;
  end;
end;

function TPDFAnnots.GetAnnotRect(Index: Integer): TPDFArray;
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := nil;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('Rect', True);
    if Obj is TPDFArray then
    begin
      Result := TPDFArray(Obj);
    end;
  end;
end;

function TPDFAnnots.GetAnnotRef(Index: Integer): TPDFIndRef;
var
  Obj: TPDFObject;
begin
  Obj := FAnnots.Item[Index];
  if Obj is TPDFIndRef then
  begin
    Result := TPDFIndRef(Obj);
  end else
  begin
    Result := nil;
  end;
end;

function TPDFAnnots.GetDoubleProp(Tag: Integer): Double;
var
  X: Integer;
  Found: Boolean;
begin
  Result := 0;
  if Length(FDoubleProps) > 0 then
  begin
    X := 0;
    Found := False;
    repeat
      if FDoubleProps[X].Tag = Tag then
      begin
        Result := FDoubleProps[X].Value;
        Found := True;
      end;
      Inc(X);
    until (X = Length(FDoubleProps)) or Found;
  end;
end;

function TPDFAnnots.GetIntegerProp(Tag: Integer): Integer;
var
  X: Integer;
  Found: Boolean;
begin
  Result := 0;
  if Length(FIntegerProps) > 0 then
  begin
    X := 0;
    Found := False;
    repeat
      if FIntegerProps[X].Tag = Tag then
      begin
        Result := FIntegerProps[X].Value;
        Found := True;
      end;
      Inc(X);
    until (X = Length(FIntegerProps)) or Found;
  end;
end;

function TPDFAnnots.GetRotation(Index: Integer): Integer;
var
  AnnotDict: TPDFDictionary;
  MKDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := 0;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('MK', True);
    if Obj is TPDFDictionary then
    begin
      MKDict := TPDFDictionary(Obj);
      Obj := MKDict.FindValueByKeyName('R', True);
      if (Obj is TPDFNumeric) then
      begin
        Result := TPDFNumeric(Obj).AsInteger;
      end;
    end
    else
    begin
      Obj := AnnotDict.FindValueByKeyName('Rotate', True);
      if (Obj is TPDFNumeric) then
      begin
        Result := TPDFNumeric(Obj).AsInteger;
      end;
    end;
  end;
end;

function TPDFAnnots.GetSound(Index, Options: Integer): AnsiString;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  SoundStream: TPDFStream;
  DataChunk: AnsiString;
  DataLength: Integer;
  FormatChunk: AnsiString;
  FormatCode: Word;
  FormatChannels: Word;
  FormatSampleRate: Integer;
  FormatDataRate: Integer;
  FormatBlockSize: Integer;
  FormatBitsPerSample: Integer;
  FactChunk: AnsiString;
  SwapX: Integer;
  SwapTemp: AnsiChar;
  PDFSoundEncoding: AnsiString;

  function WriteI32(I: Integer): AnsiString;
  begin
    Result := AnsiChar(I and $FF) +
      AnsiChar((I and $FF00) shr 8) +
      AnsiChar((I and $FF0000) shr 16) +
      AnsiChar((I and $FF000000) shr 24);
  end;

  function WriteWord(W: Word): AnsiString;
  begin
    Result := AnsiChar(W and $FF) +
      AnsiChar((W and $FF00) shr 8);
  end;

begin
  Result := '';
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('Sound', True);
    if (Obj is TPDFStream) then
    begin
      SoundStream := TPDFStream(Obj);
      if (Options = 0) then
      begin
        Result := SoundStream.GetDecodedStream;
      end else
      if (Options = 1) then
      begin
        Obj := SoundStream.Dictionary.FindValueByKeyName('R', True);
        if (Obj is TPDFNumeric) then
        begin
          FormatSampleRate := TPDFNumeric(Obj).AsInteger;
        end else
        begin
          FormatSampleRate := 0;
        end;

        Obj := SoundStream.Dictionary.FindValueByKeyName('B', True);
        if (Obj is TPDFNumeric) then
        begin
          FormatBitsPerSample := TPDFNumeric(Obj).AsInteger;
        end else
        begin
          FormatBitsPerSample := 8;
        end;

        Obj := SoundStream.Dictionary.FindValueByKeyName('C', True);
        if (Obj is TPDFNumeric) then
        begin
          FormatChannels := TPDFNumeric(Obj).AsInteger;
        end else
        begin
          FormatChannels := 1;
        end;

        Obj := SoundStream.Dictionary.FindValueByKeyName('E', True);
        if (Obj is TPDFName) then
        begin
          PDFSoundEncoding := TPDFName(Obj).Name;
        end else
        begin
          PDFSoundEncoding := 'Raw';
        end;

        if ((FormatSampleRate > 0) and
          ((FormatChannels = 1) or (FormatChannels = 2)) and
          (PDFSoundEncoding = 'Signed') and
          ((FormatBitsPerSample = 8) or (FormatBitsPerSample = 16))) then
        begin
          DataChunk := SoundStream.GetDecodedStream;
          for SwapX := 1 to Length(DataChunk) div 2 do
          begin
            SwapTemp := DataChunk[SwapX * 2 - 1];
            DataChunk[SwapX * 2 - 1] := DataChunk[SwapX * 2];
            DataChunk[SwapX * 2] := SwapTemp;
          end;

          DataLength := Length(DataChunk);
          if ((DataLength mod 2) = 1) then
          begin
            Result := Result + #0;
          end;
          DataChunk := 'data' + WriteI32(DataLength) + DataChunk;

          FormatCode := 1;
          FormatBlockSize := (FormatBitsPerSample * FormatChannels) div 8;
          FormatDataRate := (FormatSampleRate * FormatChannels * FormatBlockSize);

          FactChunk := '';

          FormatChunk := 'fmt ' + WriteI32(16) + WriteWord(FormatCode) +
            WriteWord(FormatChannels) + WriteI32(FormatSampleRate) +
            WriteI32(FormatDataRate) + WriteWord(FormatBlockSize) +
            WriteWord(FormatBitsPerSample);

          Result := 'RIFF' + WriteI32(Length(FormatChunk) + Length(DataChunk) + Length(FactChunk) + 8) + 'WAVE' +
            FormatChunk + FactChunk + DataChunk;
        end;
      end;
    end;
  end;
end;

function TPDFAnnots.GetEmbeddedFileName(Index: Integer): WideString;
var
  Obj: TPDFObject;
  AnnotDict, FSDict: TPDFDictionary;
begin
  Result := '';
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('FS', True);
    if (Obj is TPDFDictionary) then
    begin
      FSDict := TPDFDictionary(Obj);

      Obj := FSDict.FindValueByKeyName('F', True);
      if (Obj is TPDFString) then
      begin
        Result := TPDFString(Obj).AsTextString;
      end
      else begin
        Obj := FSDict.FindValueByKeyName('UF', True);
        if (Obj is TPDFString) then
        begin
          Result := TPDFString(Obj).AsTextString;
        end;
      end;
    end;
  end;
end;

function TPDFAnnots.GetFile(Index: Integer): AnsiString;
var
  Obj: TPDFObject;
  AnnotDict, FSDict, EFDict: TPDFDictionary;
  FileStream: TPDFStream;

begin
  Result := '';
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('FS', True);
    if (Obj is TPDFDictionary) then
    begin
      FSDict := TPDFDictionary(Obj);
      Obj := FSDict.FindValueByKeyName('EF', True);
      begin
        EFDict := TPDFDictionary(Obj);

        Obj := EFDict.FindValueByKeyName('F', True);
        if (Obj is TPDFStream) then
        begin
          FileStream := TPDFStream(Obj);
          Result := FileStream.GetDecodedStream;
        end
        else begin
          Obj := EFDict.FindValueByKeyName('UF', True);
          if (Obj is TPDFStream) then
          begin
            FileStream := TPDFStream(Obj);
            Result := FileStream.GetDecodedStream;
          end
        end;
      end;
    end;
  end;
end;

function TPDFAnnots.GetStringProp(Tag: Integer): WideString;
var
  X: Integer;
  Found: Boolean;
begin
  Result := '';
  if Length(FStringProps) > 0 then
  begin
    X := 0;
    Found := False;
    repeat
      if FStringProps[X].Tag = Tag then
      begin
        Result := FStringProps[X].Value;
        Found := True;
      end;
      Inc(X);
    until (X = Length(FStringProps)) or Found;
  end;
end;

procedure TPDFAnnots.SetAnnotQuadPoints(Index, QuadNumber: Integer; X1, Y1,
  X2, Y2, X3, Y3, X4, Y4: Double);
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
  ItemIndex: Integer;
  QuadPointsArray: TPDFArray;
  NewTotal: Integer;
  ThisValue: Double;
  PointCount: Integer;
begin
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('QuadPoints', True);
    if (not Assigned(Obj)) then
    begin
      Obj := AnnotDict.Owner.NewArray;
      AnnotDict.Add('QuadPoints', Obj);
    end;
    if (Obj is TPDFArray) then
    begin
      QuadPointsArray := TPDFArray(Obj);

      // Each quad has eight values
      NewTotal := QuadNumber * 8;

      // If there aren't enough numbers then add more      
      while (QuadPointsArray.Count < NewTotal) do
      begin
        QuadPointsArray.Add(AnnotDict.Owner.NewNumeric(0));
      end;

      ThisValue := 0;
      ItemIndex := (QuadNumber - 1) * 8;
      for PointCount := 1 to 8 do
      begin
        if PointCount = 1 then ThisValue := X4;
        if PointCount = 2 then ThisValue := Y4;
        if PointCount = 3 then ThisValue := X3;
        if PointCount = 4 then ThisValue := Y3;
        if PointCount = 5 then ThisValue := X1;
        if PointCount = 6 then ThisValue := Y1;
        if PointCount = 7 then ThisValue := X2;
        if PointCount = 8 then ThisValue := Y2;
        Obj := QuadPointsArray.Item[ItemIndex + PointCount - 1];
        if (Obj is TPDFNumeric) then
        begin
          TPDFNumeric(Obj).SetTo(ThisValue);
        end;
      end;
    end;
  end;
end;

function TPDFAnnots.SetRect(Index: Integer; Left, Top, Width,
  Height: Double): Boolean;
var
  X: Integer;
  A: TPDFArray;
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  Structure: TPDFStructure;
begin
  Result := False;
  AnnotDict := GetAnnotDict(Index);
  if (Assigned(AnnotDict)) then
  begin
    Structure := AnnotDict.Owner;
    if Assigned(AnnotDict) then
    begin
      Obj := AnnotDict.FindValueByKeyName('Rect');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if (not (Obj is TPDFArray)) or ((Obj is TPDFArray) and
        (TPDFArray(Obj).Count <> 4)) then
      begin
        AnnotDict.PurgeKey('Rect');
        AnnotDict.Add('Rect', Structure.NewIntArray([0, 0, 0, 0]));
        Obj := AnnotDict.FindValueByKeyName('Rect');
      end;
      if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
      begin
        A := TPDFArray(Obj);
        for X := 0 to 3 do
        begin
          Obj := A.Item[X];
          if not (Obj is TPDFNumeric) then
          begin
            Obj := Structure.NewNumeric(0);
            A.Replace(X, Obj);
          end;
          if (Obj is TPDFNumeric) then
          case X of
            0: TPDFNumeric(Obj).SetTo(Left);
            1: TPDFNumeric(Obj).SetTo(Top - Height);
            2: TPDFNumeric(Obj).SetTo(Left + Width);
            3: TPDFNumeric(Obj).SetTo(Top);
          end;
        end;
      end;
    end;
  end;

  // Clear the cached annotation properties
  FLastAnalysis := -1;
  ClearProps;
end;

function TPDFAnnots.SetBorderColor(Index: Integer; Red, Green,
  Blue: Double): Boolean;
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
  CArray: TPDFArray;
begin
  Result := False;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('C');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

    if Obj is TPDFArray then
    begin
      CArray := TPDFArray(Obj);
      if (CArray.Count = 3) and CArray.AllItemsNumeric then
      begin
        TPDFNumeric(CArray.Item[0]).SetTo(Red);
        TPDFNumeric(CArray.Item[1]).SetTo(Green);
        TPDFNumeric(CArray.Item[2]).SetTo(Blue);
        Result := True;
      end;
    end;

    if not Result then
    begin
      AnnotDict.Add('C', AnnotDict.Owner.NewDoubleArray([Red, Green, Blue]));
      Result := True;
    end;
  end;
end;

function TPDFAnnots.SetBorderColorCMYK(Index: Integer; C, M, Y,
  K: Double): Boolean;
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
  CArray: TPDFArray;
begin
  Result := False;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('C');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

    if Obj is TPDFArray then
    begin
      CArray := TPDFArray(Obj);
      if (CArray.Count = 4) and CArray.AllItemsNumeric then
      begin
        TPDFNumeric(CArray.Item[0]).SetTo(C);
        TPDFNumeric(CArray.Item[1]).SetTo(M);
        TPDFNumeric(CArray.Item[2]).SetTo(Y);
        TPDFNumeric(CArray.Item[3]).SetTo(K);
        Result := True;
      end;
    end;

    if not Result then
    begin
      AnnotDict.Add('C', AnnotDict.Owner.NewDoubleArray([C, M, Y, K]));
    end;
  end;
end;

function TPDFAnnots.SetBorderStyle(Index: Integer; Width: Double;
  const Style: AnsiString; DashOn, DashOff: Double): Boolean;
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
  BSDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
begin
  Result := False;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('BS');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if not Assigned(Obj) then
    begin
      Obj := AnnotDict.Owner.NewDictionary;
      AnnotDict.Owner.OnNewIndObj(Self, ObjNum, GenNum, Obj);
      AnnotDict.Add('BS', AnnotDict.Owner.NewIndirectRef(ObjNum, GenNum));
    end;
    if Obj is TPDFDictionary then
    begin
      BSDict := TPDFDictionary(Obj);
      BSDict.PurgeKey('Type');
      BSDict.PurgeKey('W');
      BSDict.PurgeKey('S');
      BSDict.PurgeKey('D');
      BSDict.Add('Type', AnnotDict.Owner.NewName('Border'));
      BSDict.Add('W', AnnotDict.Owner.NewNumeric(Width));
      BSDict.Add('S', AnnotDict.Owner.NewName(Style));
      if Style = 'D' then
      begin
        BSDict.Add('D', AnnotDict.Owner.NewArray([
          AnnotDict.Owner.NewNumeric(DashOn),
          AnnotDict.Owner.NewNumeric(DashOff)
        ]));
      end;
    end;
  end;
end;

function TPDFAnnots.SetContents(Index: Integer; const C: AnsiString): Boolean;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  Structure: TPDFStructure;
begin
  Result := False;
  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      AnnotDict := TPDFDictionary(Obj);
      Structure := AnnotDict.Owner;
      Obj := AnnotDict.FindValueByKeyName('Contents', True);
      if Obj is TPDFString then
        TPDFString(Obj).SetTo(C)
      else
        AnnotDict.Add('Contents', Structure.NewString(C));
      AnnotDict.PurgeKey('RC');
    end;
  end;
end;

function TPDFAnnots.SetDoubleProp(Index, Tag: Integer;
  NewValue: Double): Boolean;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  Structure: TPDFStructure;
  PDFRect: TPDFRectangle;
  Change: Double;
begin
  Result := False;
  if not Assigned(FAnnots) then Exit;

  AnnotDict := nil;

  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
      AnnotDict := TPDFDictionary(Obj);
  end;

  if Assigned(AnnotDict) then
  begin
    Structure := AnnotDict.Owner;

    if ((Tag >= 105) and (Tag <= 108)) then
    begin
      Obj := FindDictObj(AnnotDict, 'Rect');
      if (not (Obj is TPDFArray)) then
      begin
        Obj := nil;
      end;
      PDFRect := TPDFRectangle.Create(TPDFArray(Obj));
      try
        if (not PDFRect.IsRectangle) then
        begin
          PDFRect.Free;
          Obj := Structure.NewDoubleArray([0, 0, 0, 0]);
          AnnotDict.Add('Rect', Obj);
          PDFRect := TPDFRectangle.Create(TPDFArray(Obj));
        end;
        if (PDFRect.IsRectangle) then
        begin
          case Tag of
            105:
            begin
              Change := NewValue - PDFRect.Left;
              PDFRect.Left := NewValue;
              PDFRect.Right := PDFRect.Right + Change;
            end;
            106:
            begin
              Change := NewValue - PDFRect.Top;
              PDFRect.Top := NewValue;
              PDFRect.Bottom := PDFRect.Bottom + Change;
            end;
            107:
            begin
              PDFRect.Right := PDFRect.Right + (NewValue - PDFRect.Width);
            end;
            108:
            begin
              PDFRect.Bottom := PDFRect.Bottom - (NewValue - PDFRect.Height);
            end;
          end;
        end;
      finally
        PDFRect.Free;
      end;
      Result := True;
    end;
  end;

  // If something was changed, clear the cached annotation properties
  if (Result) then
  begin
    FLastAnalysis := -1;
    ClearProps;
  end;
end;

function TPDFAnnots.SetMarkupAnnotStyle(Index: Integer; Red, Green, Blue,
  Transparency: Double): Boolean;
var
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;
  CArray: TPDFArray;
  CA: TPDFNumeric;
begin
  Result := False;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('C');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

    if Obj is TPDFArray then
    begin
      CArray := TPDFArray(Obj);
      if (CArray.Count = 3) and CArray.AllItemsNumeric then
      begin
        TPDFNumeric(CArray.Item[0]).SetTo(Red);
        TPDFNumeric(CArray.Item[1]).SetTo(Green);
        TPDFNumeric(CArray.Item[2]).SetTo(Blue);
        Result := True;
      end;
    end;

    if not Result then
    begin
      AnnotDict.Add('C', AnnotDict.Owner.NewDoubleArray([Red, Green, Blue]));
      Result := True;
    end;

    Obj := AnnotDict.FindValueByKeyName('CA');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

    if Obj is TPDFNumeric then
    begin
      CA := TPDFNumeric(Obj);
      CA.SetTo(Transparency);
    end else
    begin
      AnnotDict.Add('CA', AnnotDict.Owner.NewNumeric(Transparency / 100));
    end;
  end;
end;

function TPDFAnnots.SetOCG(Index: Integer; OCGRef: TPDFIndRef): Boolean;
var
  AnnotDict: TPDFDictionary;
begin
  Result := False;
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    AnnotDict.Add('OC', OCGRef);
    Result := True;
  end;
end;

procedure TPDFAnnots.SetRotation(Index, NewRotation: Integer);
var
  AnnotDict: TPDFDictionary;
  MKDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  AnnotDict := GetAnnotDict(Index);
  if Assigned(AnnotDict) then
  begin
    Obj := AnnotDict.FindValueByKeyName('MK', True);
    if Obj is TPDFDictionary then
    begin
      MKDict := TPDFDictionary(Obj);
      Obj := MKDict.FindValueByKeyName('R', True);
      if (Obj is TPDFNumeric) then
      begin
        TPDFNumeric(Obj).SetTo(NewRotation);
      end;
    end
    else
    begin
      Obj := AnnotDict.FindValueByKeyName('Rotate', True);
      if (Obj is TPDFNumeric) then
        TPDFNumeric(Obj).SetTo(NewRotation);
    end;
  end;
end;

function TPDFAnnots.SetIntegerProp(Index, Tag: Integer;
  NewValue: Integer): Boolean;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  Structure: TPDFStructure;
  ActionDict: TPDFDictionary;
  NeedActionDict: Boolean;
  DArray: TPDFArray;
begin
  Result := False;
  if not Assigned(FAnnots) then Exit;

  AnnotDict := nil;

  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
      AnnotDict := TPDFDictionary(Obj);
  end;

  if Assigned(AnnotDict) then
  begin
    Structure := AnnotDict.Owner;

    if (Tag = 109) then
    begin
      Obj := FindDictObj(AnnotDict, 'F');
      if (Obj is TPDFNumeric) then
      begin
        TPDFNumeric(Obj).SetTo(NewValue);
      end else
      begin
        AnnotDict.Add('F', Structure.NewNumeric(NewValue));
      end;
      Result := True;
    end;

    NeedActionDict := False;
    if (Tag = 116) then NeedActionDict := True;

    Obj := FindDictObj(AnnotDict, 'A');
    if NeedActionDict and (not (Obj is TPDFDictionary)) then
    begin
      Obj := Structure.NewDictionary;
      AnnotDict.Add('A', Obj);
    end;
    if Obj is TPDFDictionary then
    begin
      ActionDict := TPDFDictionary(Obj);

      Obj := FindDictObj(ActionDict, 'D');
      if (Obj is TPDFArray) then
      begin
        DArray := TPDFArray(Obj);
        if (DArray.Count > 0) then
        begin
          Obj := DArray.Item[0];
          if ((Tag = 116) and (Obj is TPDFNumeric)) then
          begin
            TPDFNumeric(Obj).SetTo(NewValue - 1);
            Result := True;
          end;
        end;
      end;
    end;
  end;

  // If something was changed, clear the cached annotation properties
  if (Result) then
  begin
    FLastAnalysis := -1;
    ClearProps;
  end;
end;

function TPDFAnnots.SetIndRefProp(Index, Tag: Integer; NewValue: TPDFIndRef): Boolean;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  Structure: TPDFStructure;
  ActionDict: TPDFDictionary;
  NeedActionDict: Boolean;
  DArray: TPDFArray;
begin
  Result := False;
  if not Assigned(FAnnots) then Exit;

  AnnotDict := nil;

  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
      AnnotDict := TPDFDictionary(Obj);
  end;

  if (Assigned(AnnotDict) and Assigned(NewValue)) then
  begin
    Structure := AnnotDict.Owner;

    NeedActionDict := False;
    if (Tag = 131) then NeedActionDict := True;

    Obj := FindDictObj(AnnotDict, 'A');
    if NeedActionDict and (not (Obj is TPDFDictionary)) then
    begin
      Obj := Structure.NewDictionary;
      AnnotDict.Add('A', Obj);
    end;
    if Obj is TPDFDictionary then
    begin
      ActionDict := TPDFDictionary(Obj);

      Obj := FindDictObj(ActionDict, 'D');
      if (Obj is TPDFArray) then
      begin
        DArray := TPDFArray(Obj);
        if (DArray.Count > 0) then
        begin
          Obj := DArray.Item[0];
          if ((Tag = 131) and (Obj is TPDFIndRef)) then
          begin
            TPDFIndRef(Obj).CopyRef(NewValue);
            Result := True;
          end;
        end;
      end;
    end;
  end;

  // If something was changed, clear the cached annotation properties
  if (Result) then
  begin
    FLastAnalysis := -1;
    ClearProps;
  end;
end;

function TPDFAnnots.SetStringProp(Index, Tag: Integer;
  const NewValue: WideString): Boolean;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  FDict: TPDFDictionary;
  WinDict: TPDFDictionary;
  Structure: TPDFStructure;
  NeedActionDict: Boolean;
  ForceSName: AnsiString;
begin
  Result := False;
  if not Assigned(FAnnots) then Exit;

  AnnotDict := nil;

  if (Index >= 0) and (Index < FAnnots.Count) then
  begin
    Obj := FAnnots.Item[Index];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
      AnnotDict := TPDFDictionary(Obj);
  end;
  if Assigned(AnnotDict) then
  begin
    Structure := AnnotDict.Owner;

    ForceSName := '';

    if (Tag = 102) then
    begin
      ForceSName := 'Contents';

      Obj := FindDictObj(AnnotDict, 'Contents');
      if not (Obj is TPDFString) then
      begin
        Obj := Structure.NewString('');
        AnnotDict.Add('Contents', Obj);
      end;
      TPDFString(Obj).SetToTextString(NewValue);
      Result := True;
    end;

    if (Tag = 103) then
    begin
      ForceSName := 'NM';

      Obj := FindDictObj(AnnotDict, 'NM');
      if not (Obj is TPDFString) then
      begin
        Obj := Structure.NewString('');
        AnnotDict.Add('NM', Obj);
      end;
      TPDFString(Obj).SetToTextString(NewValue);
      Result := True;
    end;

    if (Tag = 110) then
    begin
      ForceSName := 'T';

      Obj := FindDictObj(AnnotDict, 'T');
      if not (Obj is TPDFString) then
      begin
        Obj := Structure.NewString('');
        AnnotDict.Add('T', Obj);
      end;
      TPDFString(Obj).SetToTextString(NewValue);
      Result := True;
    end;

    if (Tag = 127) then
    begin
      ForceSName := 'Subj';

      Obj := FindDictObj(AnnotDict, 'Subj');
      if not (Obj is TPDFString) then
      begin
        Obj := Structure.NewString('');
        AnnotDict.Add('Subj', Obj);
      end;
      TPDFString(Obj).SetToTextString(NewValue);
      Result := True;
    end;

    // NOTE : Acrobat doesn't automatically update the Appearance stream when the
    // OverlayText property is updated.  Currently you need to edit the Rectact object
    // properties where the new string will show and then press OK to have Acrobat update
    // the appearance stream.

    {
    if (Tag = 140) then
    begin
      ForceSName := 'OverlayText';

      Obj := FindDictObj(AnnotDict, 'OverlyText');
      if not (Obj is TPDFString) then
      begin
        Obj := Structure.NewString('');
        AnnotDict.Add('OverlayText', Obj);
      end;
      TPDFString(Obj).SetToTextString(NewValue);
      Result := True;
    end;
    }

    NeedActionDict := False;
    if (Tag >= 111) and (Tag <= 115) then NeedActionDict := True;
    if (Tag >= 129) and (Tag <= 130) then NeedActionDict := True;

    Obj := FindDictObj(AnnotDict, 'A');
    if NeedActionDict and (not (Obj is TPDFDictionary)) then
    begin
      Obj := Structure.NewDictionary;
      AnnotDict.Add('A', Obj);
    end;
    if Obj is TPDFDictionary then
    begin
      ActionDict := TPDFDictionary(Obj);

      if (Tag = 111) and Assigned(ActionDict) then
      begin
        ForceSName := 'URI';

        Obj := FindDictObj(ActionDict, 'URI');
        if not (Obj is TPDFString) then
        begin
          Obj := Structure.NewString('');
          ActionDict.Add('URI', Obj);
        end;
        TPDFString(Obj).SetToTextString(NewValue);
        Result := True;
      end;

      if (Tag = 113) and Assigned(ActionDict) then
      begin
        ForceSName := 'Launch';

        Obj := FindDictObj(ActionDict, 'Win');
        if not (Obj is TPDFDictionary) then
        begin
          Obj := Structure.NewDictionary;
          ActionDict.Add('Win', Obj);
        end;
        WinDict := TPDFDictionary(Obj);
        Obj := FindDictObj(WinDict, 'F');
        if not (Obj is TPDFString) then
        begin
          Obj := Structure.NewString('');
          WinDict.Add('F', Obj);
        end;
        TPDFString(Obj).SetToTextString(NewValue);
        Result := True;
      end;

      if ((Tag = 114) or (Tag = 115)) and Assigned(ActionDict) then
      begin
        if Tag = 114 then ForceSName := 'Launch';
        if Tag = 115 then ForceSName := 'GoToR';
        
        Obj := FindDictObj(ActionDict, 'F');
        if not (Obj is TPDFDictionary) then
        begin
          Obj := Structure.NewDictionary;
          ActionDict.Add('F', Obj);
        end;
        FDict := TPDFDictionary(Obj);
        Obj := FindDictObj(FDict, 'F');
        if not (Obj is TPDFString) then
        begin
          Obj := Structure.NewString('');
          FDict.Add('F', Obj);
        end;
        TPDFString(Obj).SetToTextString(NewValue);
        Result := True;
      end;

      if ((Tag = 129) or (Tag = 130)) and Assigned(ActionDict) then
      begin
        if Tag = 129 then ForceSName := 'Launch';
        if Tag = 130 then ForceSName := 'GoToR';

        Obj := FindDictObj(ActionDict, 'F');
        if not (Obj is TPDFDictionary) then
        begin
          Obj := Structure.NewDictionary;
          ActionDict.Add('F', Obj);
        end;
        FDict := TPDFDictionary(Obj);
        Obj := FindDictObj(FDict, 'UF');
        if not (Obj is TPDFString) then
        begin
          Obj := Structure.NewString('');
          FDict.Add('UF', Obj);
        end;
        TPDFString(Obj).SetToTextString(NewValue);
        Result := True;
      end;

      if ((ForceSName <> '') and Assigned(ActionDict)) then
      begin
        ActionDict.Add('S', Structure.NewName(ForceSName));
      end;

      if (Tag = 134) and Assigned(ActionDict) then
      begin
        ActionDict.Purge;
        ActionDict.Add('Type', Structure.NewName('Action'));
        ActionDict.Add('S', Structure.NewName('JavaScript'));
        ActionDict.Add('JS', Structure.NewTextString(NewValue));
        Result := True;
      end;
      
    end;
  end;

  // If something was changed, clear the cached annotation properties
  if (Result) then
  begin
    FLastAnalysis := -1;
    ClearProps;
  end;
end;

end.
