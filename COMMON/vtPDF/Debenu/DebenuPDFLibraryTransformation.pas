{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTransformation.pas                     }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTransformation;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryExtra, DebenuPDFLibrarySmartAccess;

type
  TQuickPDFTransformResult = (ptOkay, ptFileNotFound, ptCannotRead, ptWrongPassword);

  TQuickPDFTransformer = class
  private
    FInputStream: TQuickPDFWideFileStream;
    FReader: TSmartPDFReader;
    FWriter: TSmartPDFWriter;
    FDoc: TSmartPDFDocument;
    FInfo: TSmartPDFInfo;
    FOriginalVersion: AnsiString;
    FObjNumMapping: TQPLIntegerPairList;
    FTransformType: Integer;
    FTransformOptions: Integer;
    procedure FreeLocalObjects;
  private
    procedure Prepare;
    procedure WriteObjects(Writer: TSmartPDFWriter);
  public
    constructor Create;
    destructor Destroy; override;
    function OpenPDF(const FileName, Password: WideString): TQuickPDFTransformResult;
    procedure SetTransformType(TransformType, Options: Integer);
    function SaveToFile(const FileName: WideString): Boolean;
  end;

implementation

uses
  Classes, SysUtils,
  DebenuPDFLibraryStructure;

{ TQuickPDFTransformer }

constructor TQuickPDFTransformer.Create;
begin
  FReader := nil;
  FWriter := nil;
  FInputStream := nil;
  FObjNumMapping := TQPLIntegerPairList.Create;
  FTransformType := 1;
end;

destructor TQuickPDFTransformer.Destroy;
begin
  FreeLocalObjects;
  FObjNumMapping.Free;
  inherited;
end;

procedure TQuickPDFTransformer.FreeLocalObjects;
begin
  if (Assigned(FReader)) then
  begin
    FReader.Free;
  end;
  if (Assigned(FWriter)) then
  begin
    FWriter.Free;
  end;
  if (Assigned(FDoc)) then
  begin
    FDoc.Free;
  end;
  if (Assigned(FInfo)) then
  begin
    FInfo.Free;
  end;
  if (Assigned(FInputStream)) then
  begin
    FInputStream.Free;
  end;
end;

function TQuickPDFTransformer.OpenPDF(const FileName,
  Password: WideString): TQuickPDFTransformResult;
begin
  Result := ptOkay;
  FreeLocalObjects;

  if (QPLFileExists(FileName)) then
  begin
    try
      FInputStream := TQuickPDFWideFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    except
      FInputStream := nil;
      Result := ptCannotRead;
    end;
    if (Assigned(FInputStream)) then
    begin
      FReader := TSmartPDFReader.Create(FInputStream);
      if (FReader.ErrorCode = ecNone) then
      begin
        FInfo := TSmartPDFInfo.Create(FReader, '');
        if ((FInfo.Encrypted = spEncrypted) or (FInfo.Encrypted = spDecrypted)) then
        begin
          if (FInfo.Encrypted = spEncrypted) then
          begin
            if (not FInfo.CheckPassword(Password)) then
            begin
              Result := ptWrongPassword;
            end else
            begin
              FInfo.Password := Password;
            end;
          end;
          if (Result = ptOkay) then
          begin
            FInfo.GetBasic;
            FDoc := TSmartPDFDocument.Create(FReader);
            FOriginalVersion := FInfo.Version;
          end;
        end else
        begin
          Result := ptCannotRead;
        end;
      end else
      begin
        Result := ptCannotRead;
      end;
    end else
    begin
      Result := ptCannotRead;
    end;
  end else
  begin
    Result := ptFileNotFound;
  end;
end;

procedure TQuickPDFTransformer.Prepare;
var
  X: Integer;
  IntList: TQPLSortedNumberList;
  ObjNum: Integer;
  TempStruct: TPDFStructure;
  Obj: TPDFObject;
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

    for X := 0 to IntList.Count - 1 do
    begin
      FObjNumMapping.Add(IntList.GetNumAt(X), X + 1);
    end;
    FObjNumMapping.Sort;
  finally
    IntList.Free;
  end;
end;

function TQuickPDFTransformer.SaveToFile(const FileName: WideString): Boolean;
var
  OutStream: TQuickPDFWideFileStream;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  NewTrailer: TPDFObject;
  X: Integer;
  TestObj: TPDFObject;
begin
  Result := False;
  try
    OutStream := TQuickPDFWideFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
  except
    OutStream := nil;
  end;
  if (Assigned(OutStream)) then
  begin
    Writer := TSmartPDFWriter.Create(OutStream);
    try
      Writer.New(FOriginalVersion);
      Prepare;
      WriteObjects(Writer);
      FReader.FixTrailer;
      TempStruct := TPDFStructure.Create;
      try
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
        if (NewTrailer is TPDFDictionary) then
        begin
          if (FTransformType = 1) then
          begin
            Writer.AddTrailer(TPDFDictionary(NewTrailer), 0, True);
          end else
          if (FTransformType = 2) then
          begin
            Writer.AddXRefStream(TPDFDictionary(NewTrailer));
          end;
          Result := True;
        end;
      finally
        TempStruct.Free;
      end;
    finally
      Writer.Free;
      OutStream.Free;
    end;
  end;
end;

procedure TQuickPDFTransformer.SetTransformType(TransformType,
  Options: Integer);
begin
  FTransformType := TransformType;
  FTransformOptions := Options;
end;

procedure TQuickPDFTransformer.WriteObjects(Writer: TSmartPDFWriter);
var
  ObjNum: Integer;
  TempStruct: TPDFStructure;
  X: Integer;
  Obj: TPDFObject;
  TestObj: TPDFObject;
begin
  for ObjNum := 1 to FReader.ObjectCount do
  begin
    TempStruct := TPDFStructure.Create;
    try
      Obj := FReader.GetObject(ObjNum, TempStruct);
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
        Writer.AddObject(FObjNumMapping.GetValue(ObjNum), 0, Obj.Output);
      end;
    finally
      TempStruct.Free;
    end;
  end;
end;

end.
