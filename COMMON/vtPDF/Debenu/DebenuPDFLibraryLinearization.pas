{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryLinearization.pas                      }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryLinearization;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryExtra, DebenuPDFLibrarySmartAccess,
  DebenuPDFLibraryStructure, DebenuPDFLibraryTypes;

type
  TDPLLinearizeResult = (plOkay, plCannotRead, plWrongPassword);

  TDPLPageInfo = record
    PageNum: Integer;
    PageObjects: TQPLIntegerArray;
    PageLength: Int64;
    ContentStreamOffset: Int64;
    ContentStreamLength: Int64;
    SharedObjects: array of Integer;
  end;

  TDPLLinearizer = class
  private
    FOptions: Integer;
    FReader: TSmartPDFReader;
    FDoc: TSmartPDFDocument;
    FInfo: TSmartPDFInfo;
    FOriginalVersion: AnsiString;
    FObjNumMapping: TQPLIntegerPairList;
    FOutStream: TStream;
    FLinDict: TPDFDictionary;
    FStreamXRefs: Boolean;
    FFirstPageNum: Integer;
    FLinDictObjNum: Integer;
    FLinDictPosition: Int64;
    FHintStreamObjNum: Integer;
    FDocumentObjects: array of Integer;
    FPageInfo: array of TDPLPageInfo;
    FSharedObjects: array of Integer;
    FOtherObjects: array of Integer;
    FLastXRefPosition: Int64;
    FTotalFileByteCount: Int64;
    FHintStreamPosition: Int64;
    FHintStreamSize: Int64;
    FFirstPageStartPosition: Int64;
    FFirstPageEndPosition: Int64;
    FMainXRefPosition: Int64;
    FMainXRefFirstEntryPosition: Int64;
    FFirstXRefStart: Int64;
    FPageStart: Int64;
    FSharedObjectsPosition: Int64;
    procedure FreeLocalObjects;
    procedure Prepare;
    procedure WriteObject(Writer: TSmartPDFWriter; OldObjNum, NewObjNum: Integer);
    procedure WriteLinearizationParameterDictionary(Writer: TSmartPDFWriter; FirstTime: Boolean);
    procedure WriteFirstXRef(Writer: TSmartPDFWriter; TrailerDict: TPDFDictionary; FirstPass: Boolean);
    procedure WriteDocumentObjects(Writer: TSmartPDFWriter);
    procedure WriteHintStream(Writer: TSmartPDFWriter; Stream: TPDFStream);
    procedure WritePages(Writer: TSmartPDFWriter; First: Boolean);
    procedure WriteSharedObjects(Writer: TSmartPDFWriter);
    procedure WriteMainXRefTable(Writer: TSmartPDFWriter);
    procedure GetPageObjects(PageNumber: Integer; ObjectIndex: TQPLIntegerPairList; ObjectSortArray: TQPLIntegerArray);
    procedure FollowObjectPath(StartObjNum, SortKey: Integer; ObjectIndex: TQPLIntegerPairList; ObjectSortArray: TQPLIntegerArray);
    function GenerateHintStreamStr(var SPosition: Int64; Guess: Boolean): AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    function OpenPDF(InputStream: TStream; const Password: WideString): TDPLLinearizeResult;
    procedure SetOptions(Options: Integer);
    function SaveToStream(OutStream: TStream): Boolean;
  end;

implementation

uses
  Math, DebenuPDFLibraryFlate;

{ TDPLLinearizer }

constructor TDPLLinearizer.Create;
begin
  FReader := nil;
  FObjNumMapping := TQPLIntegerPairList.Create;
  FStreamXRefs := False;
  FLinDict := nil;
  FFirstPageNum := 0;
  FOutStream := nil;
  FLastXRefPosition := 0;
  FHintStreamPosition := 0;
  FTotalFileByteCount := 0;
  FHintStreamSize := 0;
  FLinDictPosition := 0;
  FFirstPageStartPosition := 0;
  FFirstPageEndPosition := 0;
  FMainXRefFirstEntryPosition := 0;
  FFirstXRefStart := 0;
  FMainXRefPosition := 0;
  FPageStart := 0;
  FSharedObjectsPosition := 0;
end;

destructor TDPLLinearizer.Destroy;
begin
  FreeLocalObjects;
  FObjNumMapping.Free;
  inherited;
end;

procedure TDPLLinearizer.FollowObjectPath(StartObjNum, SortKey: Integer;
  ObjectIndex: TQPLIntegerPairList; ObjectSortArray: TQPLIntegerArray);
var
  Obj: TPDFObject;
  TempStruct: TPDFStructure;
  X: Integer;
begin
  if (ObjectSortArray[ObjectIndex.GetValue(StartObjNum)] = 0) then
  begin
    ObjectSortArray[ObjectIndex.GetValue(StartObjNum)] := SortKey;
    TempStruct := TPDFStructure.Create;
    try
      FDoc.GetObject(StartObjNum, TempStruct);
      for X := 0 to TempStruct.ObjectCount - 1 do
      begin
        Obj := TempStruct.GetObject(X);
        if (Obj is TPDFIndRef) then
        begin
          FollowObjectPath(TPDFIndRef(Obj).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
        end;
      end;
    finally
      TempStruct.Free;
    end;
  end;
end;

procedure TDPLLinearizer.FreeLocalObjects;
begin
  if (Assigned(FReader)) then
  begin
    FReader.Free;
  end;
  if (Assigned(FDoc)) then
  begin
    FDoc.Free;
  end;
  if (Assigned(FInfo)) then
  begin
    FInfo.Free;
  end;
end;

// This function uses 1-based page numbers
procedure TDPLLinearizer.GetPageObjects(PageNumber: Integer; ObjectIndex: TQPLIntegerPairList; ObjectSortArray: TQPLIntegerArray);
var
  PageRef: TPDFIndRef;
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  SortKey: Integer;
  ContentsArray: TPDFArray;
  AX: Integer;
  SX: Integer;
  ResourcesDict: TPDFDictionary;
  ResourcesSubDict: TPDFDictionary;
  //AnnotsArray: TPDFArray;
begin
  PageRef := FDoc.FindPage(PageNumber);
  if (Assigned(PageRef)) then
  begin
    Obj := FDoc.FindObject(PageRef);
    if (Obj is TPDFDictionary) then
    begin
      PageDict := TPDFDictionary(Obj);
      SortKey := PageNumber shl 8;
      SortKey := SortKey + $04;
      Obj := PageDict.FindValueByKeyName('Contents');
      if (Obj is TPDFIndRef) then
      begin
        FollowObjectPath(TPDFIndRef(Obj).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
      end else
      if (Obj is TPDFArray) then
      begin
        ContentsArray := TPDFArray(Obj);
        for AX := 0 to ContentsArray.Count - 1 do
        begin
          if (ContentsArray.Item[AX] is TPDFIndRef) then
          begin
            FollowObjectPath(TPDFIndRef(ContentsArray.Item[AX]).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
          end;
        end;
      end;

      Obj := PageDict.FindValueByKeyName('Resources');
      if (Obj is TPDFIndRef) then
      begin
        FollowObjectPath(TPDFIndRef(Obj).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
      end else
      if (Obj is TPDFDictionary) then
      begin
        ResourcesDict := TPDFDictionary(Obj);
        for AX := 0 to ResourcesDict.Count - 1 do
        begin
          Obj := ResourcesDict.Entry[AX].Value;
          if (Obj is TPDFIndRef) then
          begin
            FollowObjectPath(TPDFIndRef(Obj).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
          end else
          if (Obj is TPDFDictionary) then
          begin
            ResourcesSubDict := TPDFDictionary(Obj);
            for SX := 0 to ResourcesSubDict.Count - 1 do
            begin
              Obj := ResourcesSubDict.Entry[SX].Value;
              if (Obj is TPDFIndRef) then
              begin
                FollowObjectPath(TPDFIndRef(Obj).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
              end;
            end;
          end;
        end;
      end;

      {Obj := PageDict.FindValueByKeyName('Annots');
      if (Obj is TPDFIndRef) then
      begin
        FollowObjectPath(TPDFIndRef(Obj).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
      end else
      if (Obj is TPDFArray) then
      begin
        AnnotsArray := TPDFArray(Obj);
        for AX := 0 to AnnotsArray.Count - 1 do
        begin
          Obj := AnnotsArray.Item[AX];
          if (Obj is TPDFIndRef) then
          begin
            FollowObjectPath(TPDFIndRef(Obj).ObjNum, SortKey, ObjectIndex, ObjectSortArray);
          end;
        end;
      end;}
    end;
  end;
end;

function TDPLLinearizer.OpenPDF(InputStream: TStream;
  const Password: WideString): TDPLLinearizeResult;
begin
  Result := plOkay;
  FreeLocalObjects;

  if (Assigned(InputStream)) then
  begin
    FReader := TSmartPDFReader.Create(InputStream);
    if (FReader.ErrorCode = ecNone) then
    begin
      FInfo := TSmartPDFInfo.Create(FReader, '');
      if ((FInfo.Encrypted = spEncrypted) or (FInfo.Encrypted = spDecrypted)) then
      begin
        if (FInfo.Encrypted = spEncrypted) then
        begin
          if (not FInfo.CheckPassword(Password)) then
          begin
            Result := plWrongPassword;
          end else
          begin
            FInfo.Password := Password;
          end;
        end;
        if (Result = plOkay) then
        begin
          FInfo.GetBasic;
          FDoc := TSmartPDFDocument.Create(FReader);
          FOriginalVersion := FInfo.Version;
        end;
      end else
      begin
        Result := plCannotRead;
      end;
    end else
    begin
      Result := plCannotRead;
    end;
  end else
  begin
    Result := plCannotRead;
  end;
end;

procedure TDPLLinearizer.Prepare;
var
  X: Integer;
  IntList: TQPLSortedNumberList;
  ObjNum: Integer;
  TempStruct: TPDFStructure;
  Obj: TPDFObject;
  PageNum: Integer;
  NextObject: Integer;
  ObjectIndex: TQPLIntegerPairList;
  SortedLinkBack: TQPLIntegerArray;
  ObjectSortArray: TQPLIntegerArray;
  SortKey: Integer;
  Swapped: Boolean;
  TempInt: Integer;
begin
  IntList := TQPLSortedNumberList.Create;
  try
    for ObjNum := 1 to FReader.ObjectCount do
    begin
      TempStruct := TPDFStructure.Create;
      try
        Obj := FReader.GetObject(ObjNum, TempStruct);
        if (not Assigned(Obj)) then
        begin

        end else
        begin
          IntList.Add(ObjNum);
        end;
      finally
        TempStruct.Free;
      end;
    end;
    IntList.Sort;

    // Setup the page info list
    SetLength(FPageInfo, FDoc.PageCount);
    for X := 0 to Length(FPageInfo) - 1 do
    begin
      FPageInfo[X].PageNum := X + 1;
      FPageInfo[X].PageLength := 0;
      FPageInfo[X].ContentStreamOffset := 0;
      FPageInfo[X].ContentStreamLength := 0;
      SetLength(FPageInfo[X].PageObjects, 0);
      SetLength(FPageInfo[X].SharedObjects, 0);
    end;

    ObjectIndex := TQPLIntegerPairList.Create;
    SetLength(ObjectSortArray, IntList.Count);
    SetLength(SortedLinkBack, IntList.Count);
    for X := 0 to Length(ObjectSortArray) - 1 do
    begin
      ObjectSortArray[X] := 0;
      ObjectIndex.Add(IntList.GetNumAt(X), X);
      SortedLinkBack[X] := X;
    end;
    ObjectIndex.Sort;

    // Get document objects
    ObjectSortArray[ObjectIndex.GetValue(FDoc.RootRef.ObjNum)] := $01;

    Obj := FDoc.RootDict.FindValueByKeyName('Preferences');
    if (Obj is TPDFIndRef) then
    begin
      FollowObjectPath(TPDFIndRef(Obj).ObjNum, $02, ObjectIndex, ObjectSortArray);
    end;

    Obj := FDoc.RootDict.FindValueByKeyName('PageMode');
    if (Obj is TPDFIndRef) then
    begin
      FollowObjectPath(TPDFIndRef(Obj).ObjNum, $02, ObjectIndex, ObjectSortArray);
    end;

    Obj := FDoc.RootDict.FindValueByKeyName('OpenAction');
    if (Obj is TPDFIndRef) then
    begin
      FollowObjectPath(TPDFIndRef(Obj).ObjNum, $02, ObjectIndex, ObjectSortArray);
    end;

    Obj := FDoc.RootDict.FindValueByKeyName('AcroForm');
    if (Obj is TPDFIndRef) then
    begin
      if (ObjectSortArray[ObjectIndex.GetValue(TPDFIndRef(Obj).ObjNum)] = 0) then
      begin
        ObjectSortArray[ObjectIndex.GetValue(TPDFIndRef(Obj).ObjNum)] := $02;
      end;
    end;

    Obj := FReader.TrailerDict.FindValueByKeyName('Encrypt');
    if (Obj is TPDFIndRef) then
    begin
      if (ObjectSortArray[ObjectIndex.GetValue(TPDFIndRef(Obj).ObjNum)] = 0) then
      begin
        FollowObjectPath(TPDFIndRef(Obj).ObjNum, $02, ObjectIndex, ObjectSortArray);
      end;
    end;

    for PageNum := 0 to Length(FPageInfo) - 1 do
    begin
      SortKey := (PageNum + 1) shl 8 + $03;
      ObjectSortArray[ObjectIndex.GetValue(FDoc.FindPage(PageNum + 1).ObjNum)] := SortKey;
    end;

    // Get first page objects
    GetPageObjects(1, ObjectIndex, ObjectSortArray);

    // Get next page objects
    for PageNum := 2 to FDoc.PageCount do
    begin
      GetPageObjects(PageNum, ObjectIndex, ObjectSortArray);
    end;

    for X := 0 to Length(ObjectSortArray) - 1 do
    begin
      if ObjectSortArray[X] = 0 then
      begin
        ObjectSortArray[X] := $7FFFFFFF;
      end;
    end;

    SetLength(FSharedObjects, 0);
    SetLength(FOtherObjects, 0);

    Swapped := True;
    while Swapped do
    begin
      Swapped := False;
      for X := 0 to Length(ObjectSortArray) - 2 do
      begin
        if (ObjectSortArray[X] > ObjectSortArray[X + 1]) then
        begin
          Swapped := True;
          TempInt := ObjectSortArray[X];
          ObjectSortArray[X] := ObjectSortArray[X + 1];
          ObjectSortArray[X + 1] := TempInt;
          TempInt := SortedLinkBack[X];
          SortedLinkBack[X] := SortedLinkBack[X + 1];
          SortedLinkBack[X + 1] := TempInt;
        end;
      end;
    end;

    for X := 0 to Length(ObjectSortArray) - 1 do
    begin
      if (ObjectSortArray[X] = $01) then
      begin
        SetLength(FDocumentObjects, 1);
        FDocumentObjects[0] := IntList.GetNumAt(SortedLinkBack[X]);
      end else
      if (ObjectSortArray[X] = $02) then
      begin
        SetLength(FDocumentObjects, Length(FDocumentObjects) + 1);
        FDocumentObjects[Length(FDocumentObjects) - 1] := IntList.GetNumAt(SortedLinkBack[X]);
      end else
      if (ObjectSortArray[X] and $FF) = $03 then
      begin
        PageNum := (ObjectSortArray[X] shr 8);
        if (Length(FPageInfo[PageNum - 1].PageObjects) = 0) then
        begin
          SetLength(FPageInfo[PageNum - 1].PageObjects, 1);
        end;
        FPageInfo[PageNum - 1].PageObjects[0] := IntList.GetNumAt(SortedLinkBack[X]);
      end else
      if (ObjectSortArray[X] and $FF) = $04 then
      begin
        PageNum := (ObjectSortArray[X] shr 8);
        if (Length(FPageInfo[PageNum - 1].PageObjects) = 0) then
        begin
          SetLength(FPageInfo[PageNum - 1].PageObjects, 2);
        end else
        begin
          SetLength(FPageInfo[PageNum - 1].PageObjects,
            Length(FPageInfo[PageNum - 1].PageObjects) + 1);
        end;
        FPageInfo[PageNum - 1].PageObjects[Length(FPageInfo[PageNum - 1].PageObjects) - 1] := IntList.GetNumAt(SortedLinkBack[X]);
      end else
      begin
        SetLength(FOtherObjects, Length(FOtherObjects) + 1);
        FOtherObjects[Length(FOtherObjects) - 1] := IntList.GetNumAt(SortedLinkBack[X]);
      end;
    end;

    ObjectIndex.Free;

    // Reset the object number
    NextObject := 0;

    for X := 0 to Length(FSharedObjects) - 1 do
    begin
      Inc(NextObject);
      FObjNumMapping.Add(FSharedObjects[X], NextObject);
    end;

    for X := 0 to Length(FOtherObjects) - 1 do
    begin
      Inc(NextObject);
      FObjNumMapping.Add(FOtherObjects[X], NextObject);
    end;

    Inc(NextObject);
    FLinDictObjNum := NextObject;

    for X := 0 to Length(FDocumentObjects) - 1 do
    begin
      Inc(NextObject);
      FObjNumMapping.Add(FDocumentObjects[X], NextObject);
    end;

    for PageNum := 1 to FDoc.PageCount do
    begin
      for X := 0 to Length(FPageInfo[PageNum - 1].PageObjects) - 1 do
      begin
        Inc(NextObject);
        FObjNumMapping.Add(FPageInfo[PageNum - 1].PageObjects[X], NextObject);
      end;
    end;

    Inc(NextObject);
    FHintStreamObjNum := NextObject;

    FObjNumMapping.Sort;
  finally
    IntList.Free;
  end;
end;

function TDPLLinearizer.SaveToStream(OutStream: TStream): Boolean;
var
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  NewTrailer: TPDFObject;
  X: Integer;
  TestObj: TPDFObject;
  HintStreamBuffer: array of Byte;
  Placeholder1: Int64;
  HintBufferSize: Integer;
  HintStreamFits: Boolean;
begin
  Result := False;
  FOutStream := OutStream;
  if (Assigned(FOutStream)) then
  begin
    Writer := TSmartPDFWriter.Create(FOutStream);
    try
      Writer.New(FOriginalVersion);
      Prepare;

      if (not Assigned(FReader.TrailerDict.FindValueByKeyName('ID'))) then
      begin
        FReader.FixTrailer;
        FReader.TrailerDict.PurgeKey('ID');
      end else
      begin
        FReader.FixTrailer;
      end;

      TempStruct := TPDFStructure.Create;
      try
        FLinDictPosition := FOutStream.Position;
        HintBufferSize := 0;

        repeat
          FLinDict := TPDFDictionary(TempStruct.Decode('<</Linearized 1/L 9999999999/H[9999999999 9999999999]/O 9999999999/E 9999999999/N ' +
            QPLIntToStr(FDoc.PageCount) + '/T 999999>>'));

          WriteLinearizationParameterDictionary(Writer, True);

          NewTrailer := TempStruct.Decode(FReader.TrailerDict.Output);

          for X := 1 to TempStruct.ObjectCount do
          begin
            TestObj := TempStruct.GetObject(X);
            if (TestObj is TPDFIndRef) then
            begin
              TPDFIndRef(TestObj).ObjNum := FObjNumMapping.GetValue(TPDFIndRef(TestObj).ObjNum);
              TPDFIndRef(TestObj).GenNum := 0;
            end;
          end;

          FFirstXRefStart := FOutStream.Position;
          WriteFirstXRef(Writer, TPDFDictionary(NewTrailer), True);

          WriteDocumentObjects(Writer);


          FHintStreamPosition := FOutStream.Position;
          Placeholder1 := 0;
          if (HintBufferSize = 0) then
          begin
            HintBufferSize := (Length(DeflateStr(GenerateHintStreamStr(Placeholder1, True))) + 64);
            if (HintBufferSize < 2048) then
            begin
              HintBufferSize := 2048;
            end;
          end;

          SetLength(HintStreamBuffer, HintBufferSize);
          FillChar(HintStreamBuffer[0], Length(HintStreamBuffer), 32);
          HintStreamBuffer[Length(HintStreamBuffer) - 1] := 10;
          FOutStream.Write(HintStreamBuffer[0], Length(HintStreamBuffer));

          // First page
          FFirstPageStartPosition := FOutStream.Position;
          WritePages(Writer, True);
          FFirstPageEndPosition := FOutStream.Position;

          // Remaining pages
          WritePages(Writer, False);

          // Shared objects
          FSharedObjectsPosition := FOutStream.Position;
          WriteSharedObjects(Writer);

          FMainXRefPosition := FOutStream.Position;

          FOutStream.Seek(FHintStreamPosition, soBeginning);
          WriteHintStream(Writer, TempStruct.NewStream('', False));
          FHintStreamSize := FOutStream.Position - FHintStreamPosition;

          if (FHintStreamSize > HintBufferSize) then
          begin
            HintBufferSize := FHintStreamSize + 1024;
            HintStreamFits := False;
            OutStream.Seek(FLinDictPosition, soBeginning);
            Writer.Reset;
          end else
          begin
            HintStreamFits := True;
          end;

        until HintStreamFits;

        if (NewTrailer is TPDFDictionary) then
        begin
          FOutStream.Seek(FMainXRefPosition, soBeginning);
          WriteMainXRefTable(Writer);
          Result := True;
        end;

        FTotalFileByteCount := FOutStream.Position;

        // /L entry of the linearization dictionary contains the total file size
        TPDFNumeric(FLinDict.FindValueByKeyName('L')).SetTo(FTotalFileByteCount);

        if (Length(FPageInfo[0].PageObjects) > 0) then
        begin
          // Map the old object number of the first page's page dictionary
          // to the new number, set to the linearization dictionary's /O entry
          TPDFNumeric(FLinDict.FindValueByKeyName('O')).SetTo(FObjNumMapping.GetValue(FPageInfo[0].PageObjects[0]));
        end;

        // Set the other items of the linearization dictionary
        TPDFNumeric(FLinDict.FindValueByKeyName('E')).SetTo(FFirstPageEndPosition);
        TPDFNumeric(FLinDict.FindValueByKeyName('N')).SetTo(FDoc.PageCount);
        TPDFNumeric(FLinDict.FindValueByKeyName('T')).SetTo(FMainXRefFirstEntryPosition);

        // Set the hint stream size/position in the linearization dictionary's /H array
        TPDFNumeric(TPDFArray(FLinDict.FindValueByKeyName('H')).Item[0]).SetTo(FHintStreamPosition);
        TPDFNumeric(TPDFArray(FLinDict.FindValueByKeyName('H')).Item[1]).SetTo(FHintStreamSize);

        // Write the full linearization dictionary to the file into the space reserved
        FOutStream.Seek(FLinDictPosition, soBeginning);
        WriteLinearizationParameterDictionary(Writer, False);

        // Go back and write the first page's xref stream again
        FOutStream.Seek(FFirstXRefStart, soBeginning);
        WriteFirstXRef(Writer, TPDFDictionary(NewTrailer), False);
      finally
        TempStruct.Free;
      end;
    finally
      Writer.Free;
    end;
  end;
end;

procedure TDPLLinearizer.SetOptions(Options: Integer);
begin
  FOptions := Options;
end;

procedure TDPLLinearizer.WriteDocumentObjects(Writer: TSmartPDFWriter);
var
  X: Integer;
  OldObjNum: Integer;
  NewObjNum: Integer;
begin
  for X := 0 to Length(FDocumentObjects) - 1 do
  begin
    OldObjNum := FDocumentObjects[X];
    NewObjNum := FObjNumMapping.GetValue(OldObjNum);
    WriteObject(Writer, OldObjNum, NewObjNum);
  end;
end;

procedure TDPLLinearizer.WriteFirstXRef(Writer: TSmartPDFWriter; TrailerDict: TPDFDictionary; FirstPass: Boolean);
var
  XRef: AnsiString;
  L1: Integer;
  ObjNum: Integer;
  Temp: AnsiString;
begin
  if (FirstPass) then
  begin
    XRef := 'xref'#10 + QPLIntToStr(FLinDictObjNum) + ' ' + QPLIntToStr(FHintStreamObjNum - FLinDictObjNum + 1) + #10;
    SetLength(XRef, Length(XRef) + 20 * (FHintStreamObjNum - FLinDictObjNum + 1));
    XRef := XRef + 'trailer'#13 + TrailerDict.Output + 'startxref'#10'0'#10'%%EOF'#10'************************************************'#10;
    FillChar(XRef[1], Length(XRef) - 1, #32);
    FOutStream.Write(XRef[1], Length(XRef));
  end else
  begin
    XRef := 'xref'#10 + QPLIntToStr(FLinDictObjNum) + ' ' + QPLIntToStr(FHintStreamObjNum - FLinDictObjNum + 1) + #10;
    L1 := Length(XRef);
    SetLength(XRef, Length(XRef) + 20 * (FHintStreamObjNum - FLinDictObjNum + 1));
    for ObjNum := FLinDictObjNum to FHintStreamObjNum do
    begin
      Temp := QPLPaddedInt(Writer.GetObjectPosition(ObjNum), 10) + ' 00000 n '#10;
      Move(Temp[1], XRef[(ObjNum - FLinDictObjNum) * 20 + L1 + 1], 20);
    end;
    TrailerDict.Add('Prev', TrailerDict.Owner.NewNumeric(FMainXRefPosition));
    TrailerDict.Add('Size', TrailerDict.Owner.NewNumeric(FHintStreamObjNum + 1));
    XRef := XRef + 'trailer'#13 + TrailerDict.Output + 'startxref'#10'0'#10'%%EOF'#10;
    FOutStream.Write(XRef[1], Length(XRef));
  end;
end;

procedure Write32BitValue(var P: TQPLWordArray; var I: Integer; V: Cardinal; Guess: Boolean);
begin
  if (Guess) then V := Random($7FFFFFFF);
  if (Length(P) <= (I + 1)) then
  begin
    SetLength(P, (I + 2) * 2);
  end;
  P[I] := (V shr 16) and $FFFF;
  Inc(I);
  P[I] := V and $FFFF;
  Inc(I);
end;

procedure Write16BitValue(var P: TQPLWordArray; var I: Integer; V: Cardinal; Guess: Boolean);
begin
  if (Guess) then V := Random($7FFFFFFF);
  if (Length(P) = I) then
  begin
    SetLength(P, Length(P) * 2);
  end;
  P[I] := V and $FFFF;
  Inc(I);
end;

function BitsFromValue(V: Integer; Guess: Boolean): Integer;
begin
  if (Guess) then
  begin
    Result := 32;
  end else
  if (V = 0) then
  begin
    Result := 16;
  end else
  begin
    Result := Floor(Log2(V)) + 1;
    Result := Result + 16 - (Result mod 16);
    if (Result = 0) then
    begin
      Result := 16;
    end;
  end;
end;

function TDPLLinearizer.GenerateHintStreamStr(var SPosition: Int64; Guess: Boolean): AnsiString;
var
  HintStreamStr: AnsiString;
  Hints: TQPLWordArray;
  HintCount: Integer;
  LeastNumberOfObjectsInAPage: Integer;
  GreatestNumberOfObjectsInAPage: Integer;
  DiffAmount: Integer;
  AAmount: Integer;
  BitAmount: Integer;
  FirstObjNum: Integer;
  LastObjNum: Integer;
  ObjectsInThisPage: Integer;
  PageNum: Integer;
  LeastLengthOfAPage: Integer;
  GreatestLengthOfAPage: Integer;
  GreatestNumberOfSharedObjectReferences: Integer;
  GreatestContentStreamOffset: Integer;
  LeastContentStreamOffset: Integer;
  GreatestContentStreamLength: Integer;
  LeastContentStreamLength: Integer;
  ObjectsInPage: array of Integer;
  BitSizes: array[0..6] of Integer;
  SharedObjectIdentifier: Integer;
  SharedObjectIndex: Integer;
  SharedObjectPosition: Integer;
  LeastLengthOfASharedGroup: Integer;
  GreatestLengthOfASharedGroup: Integer;
  GroupLength: Integer;
  GroupObjectCount: Integer;
  GreatestNumberOfObjectsInASharedObjectGroup: Integer;
begin
  GreatestNumberOfObjectsInAPage := 0;
  GreatestLengthOfAPage := 0;
  GreatestNumberOfSharedObjectReferences := 0;
  GreatestContentStreamOffset := 0;
  GreatestContentStreamLength := 0;
  SetLength(ObjectsInPage, Length(FPageInfo));
  LeastLengthOfAPage := MaxInt;
  LeastNumberOfObjectsInAPage := MaxInt;
  LeastContentStreamOffset := MaxInt;
  LeastContentStreamLength := MaxInt;

  for PageNum := 0 to Length(FPageInfo) - 1 do
  begin
    if (Length(FPageInfo[PageNum].PageObjects) > 0) then
    begin
      FirstObjNum := FPageInfo[PageNum].PageObjects[0];
      LastObjNum := FPageInfo[PageNum].PageObjects[Length(FPageInfo[PageNum].PageObjects) - 1];
      if (FirstObjNum < LastObjNum) then
      begin
        ObjectsInThisPage := LastObjNum - FirstObjNum + 1;
      end else
      begin
        ObjectsInThisPage := FirstObjNum - LastObjNum + 1;
      end;
      ObjectsInPage[PageNum] := ObjectsInThisPage;
      if (ObjectsInThisPage > GreatestNumberOfObjectsInAPage) then
      begin
        GreatestNumberOfObjectsInAPage := ObjectsInThisPage;
      end;
      if (ObjectsInThisPage < LeastNumberOfObjectsInAPage) then
      begin
        LeastNumberOfObjectsInAPage := ObjectsInThisPage;
      end;
    end;
    if (FPageInfo[PageNum].PageLength < LeastLengthOfAPage) then
    begin
      LeastLengthOfAPage := FPageInfo[PageNum].PageLength;
    end;
    if (FPageInfo[PageNum].PageLength > GreatestLengthOfAPage) then
    begin
      GreatestLengthOfAPage := FPageInfo[PageNum].PageLength;
    end;
    if (Length(FPageInfo[PageNum].SharedObjects) > GreatestNumberOfSharedObjectReferences) then
    begin
      GreatestNumberOfSharedObjectReferences := Length(FPageInfo[PageNum].SharedObjects);
    end;
    if (FPageInfo[PageNum].ContentStreamOffset < LeastContentStreamOffset) then
    begin
      LeastContentStreamOffset := FPageInfo[PageNum].ContentStreamOffset;
    end;
    if (FPageInfo[PageNum].ContentStreamOffset > GreatestContentStreamOffset) then
    begin
      GreatestContentStreamOffset := FPageInfo[PageNum].ContentStreamOffset;
    end;
    if (FPageInfo[PageNum].ContentStreamLength < LeastContentStreamLength) then
    begin
      LeastContentStreamLength := FPageInfo[PageNum].ContentStreamLength;
    end;
    if (FPageInfo[PageNum].ContentStreamLength > GreatestContentStreamLength) then
    begin
      GreatestContentStreamLength := FPageInfo[PageNum].ContentStreamLength;
    end;
  end;
  if (LeastNumberOfObjectsInAPage = MaxInt) then
  begin
    LeastNumberOfObjectsInAPage := 1;
  end;
  if (LeastLengthOfAPage = MaxInt) then
  begin
    LeastLengthOfAPage := GreatestLengthOfAPage;
  end;
  if (LeastContentStreamOffset = MaxInt) then
  begin
    LeastContentStreamOffset := GreatestContentStreamOffset;
  end;
  if (LeastContentStreamLength = MaxInt) then
  begin
    LeastContentStreamLength := GreatestContentStreamLength;
  end;

  SetLength(Hints, 200);
  HintCount := 0;

  // Item 1
  Write32BitValue(Hints, HintCount, LeastNumberOfObjectsInAPage, Guess);

  // Item 2
  Write32BitValue(Hints, HintCount, FFirstPageStartPosition, Guess);

  // Item 3
  DiffAmount := GreatestNumberOfObjectsInAPage - LeastNumberOfObjectsInAPage;
  BitAmount := BitsFromValue(DiffAmount, True);
  BitSizes[0] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, True);

  // Item 4
  Write32BitValue(Hints, HintCount, LeastLengthOfAPage, Guess);

  // Item 5
  DiffAmount := GreatestLengthOfAPage - LeastLengthOfAPage;
  BitAmount := BitsFromValue(DiffAmount, Guess);
  BitSizes[1] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, Guess);

  // Item 6
  Write32BitValue(Hints, HintCount, LeastContentStreamOffset, Guess);

  // Item 7
  DiffAmount := GreatestContentStreamOffset - LeastContentStreamOffset;
  BitAmount := BitsFromValue(DiffAmount, Guess);
  BitSizes[2] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, Guess);

  // Item 8
  Write32BitValue(Hints, HintCount, LeastContentStreamLength, Guess);

  // Item 9
  DiffAmount := GreatestContentStreamLength - LeastContentStreamLength;
  BitAmount := BitsFromValue(DiffAmount, Guess);
  BitSizes[3] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, Guess);

  // Item 10
  AAmount := GreatestNumberOfSharedObjectReferences;
  BitAmount := BitsFromValue(AAmount, Guess);
  BitSizes[4] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, Guess);

  // Item 11
  AAmount := (*NumericallyGreatestSharedObjectIdentifier*)1024;
  BitAmount := BitsFromValue(AAmount, Guess);
  BitSizes[5] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, Guess);

  // Item 12
  AAmount := (*NumeratorFractionalPosition*)100;
  BitAmount := BitsFromValue(AAmount, Guess);
  BitSizes[6] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, Guess);

  // Item 13
  AAmount := 100;
  Write16BitValue(Hints, HintCount, AAmount, Guess);

  // Item 1 for all pages
  for PageNum := 0 to Length(FPageInfo) - 1 do
  begin
    if (BitSizes[0] = 16) then
    begin
      Write16BitValue(Hints, HintCount, ObjectsInPage[PageNum] - LeastNumberOfObjectsInAPage, Guess);
    end else
    begin
      Write32BitValue(Hints, HintCount, ObjectsInPage[PageNum] - LeastNumberOfObjectsInAPage, Guess);
    end;
  end;

  // Item 2 for all pages
  for PageNum := 0 to Length(FPageInfo) - 1 do
  begin
    if (BitSizes[1] = 16) then
    begin
      Write16BitValue(Hints, HintCount, FPageInfo[PageNum].PageLength - LeastLengthOfAPage, Guess);
    end else
    begin
      Write32BitValue(Hints, HintCount, FPageInfo[PageNum].PageLength - LeastLengthOfAPage, Guess);
    end;
  end;

  // Item 3 for all pages
  for PageNum := 0 to Length(FPageInfo) - 1 do
  begin
    if (BitSizes[4] = 16) then
    begin
      Write16BitValue(Hints, HintCount, Length(FPageInfo[PageNum].SharedObjects), Guess);
    end else
    begin
      Write32BitValue(Hints, HintCount, Length(FPageInfo[PageNum].SharedObjects), Guess);
    end;
  end;

  // Item 4 for all shared objects for each page from the second page
  for PageNum := 1 to Length(FPageInfo) - 1 do
  begin
    for SharedObjectIndex := 0 to Length(FPageInfo[PageNum].SharedObjects) - 1 do
    begin
      SharedObjectIdentifier := FPageInfo[PageNum].SharedObjects[SharedObjectIndex];
      if (BitSizes[5] = 16) then
      begin
        Write16BitValue(Hints, HintCount, SharedObjectIdentifier, Guess);
      end else
      begin
        Write32BitValue(Hints, HintCount, SharedObjectIdentifier, Guess);
      end;
    end;
  end;

  // Item 5 for all shared objects for each page from the second page
  for PageNum := 1 to Length(FPageInfo) - 1 do
  begin
    for SharedObjectIndex := 0 to Length(FPageInfo[PageNum].SharedObjects) - 1 do
    begin
      SharedObjectPosition := 0;  // TODO  percentage / ratio
      if (BitSizes[6] = 16) then
      begin
        Write16BitValue(Hints, HintCount, SharedObjectPosition, Guess);
      end else
      begin
        Write32BitValue(Hints, HintCount, SharedObjectPosition, Guess);
      end;
    end;
  end;

  // Item 6 for all pages
  for PageNum := 0 to Length(FPageInfo) - 1 do
  begin
    if (BitSizes[2] = 16) then
    begin
      Write16BitValue(Hints, HintCount, FPageInfo[PageNum].ContentStreamOffset - LeastContentStreamOffset, Guess);
    end else
    begin
      Write32BitValue(Hints, HintCount, FPageInfo[PageNum].ContentStreamOffset - LeastContentStreamOffset, Guess);
    end;
  end;

  // Item 7 for all pages
  for PageNum := 0 to Length(FPageInfo) - 1 do
  begin
    if (BitSizes[3] = 16) then
    begin
      Write16BitValue(Hints, HintCount, FPageInfo[PageNum].ContentStreamLength - LeastContentStreamLength, Guess);
    end else
    begin
      Write32BitValue(Hints, HintCount, FPageInfo[PageNum].ContentStreamLength - LeastContentStreamLength, Guess);
    end;
  end;


  // Shared Object Hint Table

  SPosition := HintCount * 2;

  // Header, item 1
  if (Length(FSharedObjects) > 0) then
  begin
    // Get the new object number of the first shared object
    Write32BitValue(Hints, HintCount, FObjNumMapping.GetValue(FSharedObjects[0]), Guess);
  end else
  begin
    // No shared objects, just write a zero
    Write32BitValue(Hints, HintCount, 0, Guess);
  end;

  // Item 2
  Write32BitValue(Hints, HintCount, FSharedObjectsPosition, Guess);

  // Item 3
  Write32BitValue(Hints, HintCount, Length(FPageInfo[0].PageObjects), Guess);

  // Item 4
  Write32BitValue(Hints, HintCount, Length(FPageInfo[0].PageObjects) + Length(FSharedObjects), Guess);

  // Item 5
  // TODO
  GreatestNumberOfObjectsInASharedObjectGroup := Length(FPageInfo[0].PageObjects);
  AAmount := GreatestNumberOfObjectsInASharedObjectGroup;
  BitAmount := BitsFromValue(AAmount, Guess);
  BitSizes[0] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount, Guess);

  // Item 6
  // TODO
  LeastLengthOfASharedGroup := FFirstPageEndPosition - FFirstPageStartPosition;
  AAmount := LeastLengthOfASharedGroup;
  Write32BitValue(Hints, HintCount, AAmount, Guess);

  // Item 7
  // TODO
  GreatestLengthOfASharedGroup := FFirstPageEndPosition - FFirstPageStartPosition;
  AAmount := GreatestLengthOfASharedGroup - LeastLengthOfASharedGroup;
  BitAmount := BitsFromValue(AAmount, Guess);
  BitSizes[1] := BitAmount;
  Write16BitValue(Hints, HintCount, BitAmount - 1, Guess);  // Steal a bit off here for the flag

  // Shared object groups
  GroupLength := FFirstPageEndPosition - FFirstPageStartPosition - LeastLengthOfASharedGroup;
  if (BitSizes[1] = 16) then
  begin
    Write16BitValue(Hints, HintCount, GroupLength shl 1, Guess);
  end else
  begin
    Write32BitValue(Hints, HintCount, GroupLength shl 1, Guess);
  end;

  GroupObjectCount := Length(FPageInfo[0].PageObjects);
  if (BitSizes[0] = 16) then
  begin
    Write16BitValue(Hints, HintCount, GroupObjectCount - GreatestNumberOfObjectsInASharedObjectGroup, Guess);
  end else
  begin
    Write32BitValue(Hints, HintCount, GroupObjectCount - GreatestNumberOfObjectsInASharedObjectGroup, Guess);
  end;

  SetLength(HintStreamStr, HintCount * 2);
  Move(Hints[0], HintStreamStr[1], Length(HintStreamStr));

  Result := HintStreamStr;
end;

procedure TDPLLinearizer.WriteHintStream(Writer: TSmartPDFWriter; Stream: TPDFStream);
var
  HintStreamStr: AnsiString;
  SHintPosition: Int64;
begin
  SHintPosition := 0;
  HintStreamStr := GenerateHintStreamStr(SHintPosition, False);
  Stream.Dictionary.Add('S', Stream.Owner.NewNumeric(SHintPosition));
  Stream.SetTo(HintStreamStr, True);
  if (FInfo.Encrypted = spEncrypted) then
  begin
    FInfo.CryptObject(Stream, FHintStreamObjNum, 0);
  end;
  Writer.AddObject(FHintStreamObjNum, 0, Stream.Output);
end;

procedure TDPLLinearizer.WriteLinearizationParameterDictionary(
  Writer: TSmartPDFWriter; FirstTime: Boolean);
var
  LinDictLength: Integer;
  Buffer: array of Byte;
  BufferStr: AnsiString;
begin
  if (Assigned(FLinDict)) then
  begin
    FLinDictPosition := FOutStream.Position;
    if (FirstTime) then
    begin
      // The first time the xref is written, a buffer of space characters is generated
      SetLength(Buffer, 201);
      FillChar(Buffer[0], Length(Buffer), 32);
      Buffer[Length(Buffer) - 1] := 10;
      FOutStream.Write(Buffer[0], Length(Buffer));
    end else
    begin
      BufferStr := FLinDict.Output;
      LinDictLength := Length(BufferStr);
      if (LinDictLength < 200) then
      begin
        Writer.AddObject(FLinDictObjNum, 0, BufferStr);
      end else
      begin
        // TODO Error if Linearization Dict too big
      end;
    end;
  end;
end;

procedure TDPLLinearizer.WriteMainXRefTable(Writer: TSmartPDFWriter);
var
  Buffer: AnsiString;
  Temp: AnsiString;
  X: Integer;
begin
  Buffer := 'xref'#13;
  Buffer := Buffer + '0 ' + QPLIntToStr(FLinDictObjNum) + #13;
  FOutStream.Write(Buffer[1], Length(Buffer));
  FMainXRefFirstEntryPosition := FOutStream.Position;
  SetLength(Buffer, FLinDictObjNum * 20);
  Temp := '0000000000 65535 f '#10;
  Move(Temp[1], Buffer[1], 20);
  for X := 1 to FLinDictObjNum - 1 do
  begin
    Temp := QPLPaddedInt(Writer.GetObjectPosition(X), 10) + ' 00000 n '#10;
    Move(Temp[1], Buffer[X * 20 + 1], 20);
  end;
  FOutStream.Write(Buffer[1], Length(Buffer));
  Buffer := 'trailer'#10'<<'#10'/Size ' + QPLIntToStr(FLinDictObjNum) +
    #10'>>'#10'startxref'#10 + QPLIntToStr(FFirstXRefStart) + #10'%%EOF';
  FOutStream.Write(Buffer[1], Length(Buffer));
end;

procedure TDPLLinearizer.WriteObject(Writer: TSmartPDFWriter; OldObjNum, NewObjNum: Integer);
var
  TempStruct: TPDFStructure;
  X: Integer;
  Obj: TPDFObject;
  TestObj: TPDFObject;
begin
  TempStruct := TPDFStructure.Create;
  try
    Obj := FReader.GetObject(OldObjNum, TempStruct);
    if (FInfo.Encrypted = spEncrypted) then
    begin
      // File is encrypted
      if (FDoc.GetEncryptionDictObjNum = OldObjNum) then
      begin
        // The encryption dictionary itself should not be encrypted, so
        // do nothing
      end else
      begin
        if (FReader.IsCompact(OldObjNum)) then
        begin
          // Object was originally stored inside an object stream. The object
          // stream was encrypted, but the object itself was unencrypted
          // inside that stream. Encrypt the object with the new object
          // number
          FInfo.CryptObject(Obj, NewObjNum, 0);
        end else
        begin
          // The original object needs to be decrypted using the old
          // object number and then re-encrypted using the new object number
          FInfo.DecryptObject(Obj, OldObjNum, 0);
          FInfo.CryptObject(Obj, NewObjNum, 0);
        end;
      end;
    end;
    if (not Assigned(Obj)) then
    begin

    end else
    begin
      for X := 1 to TempStruct.ObjectCount do
      begin
        TestObj := TempStruct.GetObject(X);
        if (TestObj is TPDFIndRef) then
        begin
          TPDFIndRef(TestObj).ObjNum := FObjNumMapping.GetValue(TPDFIndRef(TestObj).ObjNum);
          TPDFIndRef(TestObj).GenNum := 0;
        end;
      end;
      Writer.AddObject(NewObjNum, 0, Obj.Output);
    end;
  finally
    TempStruct.Free;
  end;
end;

procedure TDPLLinearizer.WritePages(Writer: TSmartPDFWriter; First: Boolean);
var
  P: Integer;
  X: Integer;
  OldObjNum: Integer;
  NewObjNum: Integer;
  P1: Integer;
  P2: Integer;
begin
  if (First) then
  begin
    P1 := 0;
    P2 := 0;
    FPageStart := FOutStream.Position;
  end else
  begin
    P1 := 1;
    P2 := Length(FPageInfo) - 1;
  end;
  for P := P1 to P2 do
  begin
    for X := 0 to Length(FPageInfo[P].PageObjects) - 1 do
    begin
      OldObjNum := FPageInfo[P].PageObjects[X];
      NewObjNum := FObjNumMapping.GetValue(OldObjNum);
      WriteObject(Writer, OldObjNum, NewObjNum);
    end;
    if (not First) then
    begin
      FPageInfo[P].PageLength := FOutStream.Position - FPageStart;
      SetLength(FPageInfo[P].SharedObjects, 0);

      // TODO measure and store the content stream start/length
      FPageInfo[P].ContentStreamOffset := 1024;
      FPageInfo[P].ContentStreamLength := 2048;
    end;
  end;
end;

procedure TDPLLinearizer.WriteSharedObjects(Writer: TSmartPDFWriter);
var
  X: Integer;
  OldObjNum: Integer;
  NewObjNum: Integer;
begin
  for X := 0 to Length(FSharedObjects) - 1 do
  begin
    OldObjNum := FSharedObjects[X];
    NewObjNum := FObjNumMapping.GetValue(OldObjNum);
    WriteObject(Writer, OldObjNum, NewObjNum);
  end;
  for X := 0 to Length(FOtherObjects) - 1 do
  begin
    OldObjNum := FOtherObjects[X];
    NewObjNum := FObjNumMapping.GetValue(OldObjNum);
    WriteObject(Writer, OldObjNum, NewObjNum);
  end;
end;

end.
