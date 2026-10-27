{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryDigitalSignatures.pas                  }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryDigitalSignatures;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibrarySmartAccess, DebenuPDFLibraryStructure, DebenuPDFLibraryExtra;

type
  TQuickPDFDataType = (dtFile, dtStream, dtString);

  TQuickPDFSignProcess = class
  public
    SourceDataType: TQuickPDFDataType;
    SourceFileName: WideString;
    SourceStream: TStream;
    SourceString: AnsiString;
    SourcePassword: WideString;
    TargetDataType: TQuickPDFDataType;
    TargetFileName: WideString;
    TargetStream: TStream;
    TargetString: AnsiString;
    PFXDataType: TQuickPDFDataType;
    PFXFileName: WideString;
    PFXPassword: WideString;
    Reason, Location, ContactInfo: WideString;
    SignatureFieldName: WideString;
    FieldImageFileName: WideString;
    FieldImageOptions: Integer;
    SetFieldBounds: Boolean;
    FieldBoundsLeft: Double;
    FieldBoundsTop: Double;
    FieldBoundsWidth: Double;
    FieldBoundsHeight: Double;
    FieldPage: Integer;
    SubFilter: AnsiString;
    SignResult: Integer;
    Passthrough: Boolean;
    PassthroughSignatureLength: Integer;
    ByteRange: array[0..3] of Int64;
    UseMachineKeyset: Boolean;
    function Sign: Integer;
    constructor Create;
  end;

  TQuickPDFSignResult = (srFailedUnknown, srSuccess, srFailedReadWritePDF,
    srFailedPDFPassword, srFailedOpeningPFX, srFailedPFXPassword,
    srFailedNoReason);

  TQuickPDFSignDoc = class
  private
    FSmartReader: TSmartPDFReader;
    FSmartDoc: TSmartPDFDocument;
    FSmartInfo: TSmartPDFInfo;
    FStream: TStream;
    FIsOpen: Boolean;
    FSignatureFieldObjNum: Integer;
    FSignatureFieldPosition: Int64;
    FSignatureFieldLength: Integer;
    FExternalStream: Boolean;
  public
    destructor Destroy; override;
    function Open(const FileName: WideString; const Password: WideString; ReadWrite: Boolean): Boolean;
    function OpenStream(SourceStream: TStream; const Password: WideString): Boolean;
    function OpenString(const SourceData: AnsiString; const Password: WideString): Boolean;
    procedure Append;
    function AppendToFile(const FileName: WideString): Boolean;
    function AppendToStream(TargetStream: TStream): Boolean;
    procedure Close;
    function AddSignatureField(const FieldName: WideString; PageNumber: Integer): Integer;
    function HasSignatureField(const FieldName: WideString): Boolean;
    procedure SetSignatureValue(const FieldName: WideString; const NewValue: AnsiString);
    procedure SetSignatureImage(const FieldName: WideString; const ImageData: AnsiString; ImageOptions: Integer);
    procedure SetSignatureBounds(const FieldName: WideString; Left,Top, Width, Height: Double);
    function GetSignatureValue(FieldRef: TPDFIndRef; ValueKey: Integer): AnsiString;
    procedure SetSignatureFlags(NewFlags: Integer);
    property IsOpen: Boolean read FIsOpen;
    property SignatureFieldPosition: Int64 read FSignatureFieldPosition;
    property SignatureFieldLength: Integer read FSignatureFieldLength;
  end;

  TQuickPDFSignerResult = (srOkay, srFileNotFound, srCannotRead, srWrongPassword,
    srBadFormat, srNoPrivateKey);

  TQuickPDFPFXFile = class
  private
    FContext: Cardinal;
    FCertStore: Cardinal;
    procedure Clear;
  public
    destructor Destroy; override;
    function Open(const FileName: WideString; const Password: AnsiString; UseMachineKeyset: Boolean): TQuickPDFSignerResult;
    function SignData(const Data, SubFilter: AnsiString): AnsiString;
  end;

  TQuickPDFSignatureProperty = (spReason, spLocation, spContactInfo, spFieldImage, spSubFilter, spFieldImageOptions);

  TQuickPDFSigner = class
  private
    FPDFDoc: TQuickPDFSignDoc;
    FPFXFile: TQuickPDFPFXFile;
    FSignatureField: WideString;
    FStructure: TPDFStructure;
    FSigValue: TPDFDictionary;
    FImageData: AnsiString;
    FImageOptions: Integer;
    FTargetFileName: WideString;
    FTargetStream: TStream;
    FSetBounds: Boolean;
    FBoundsLeft: Double;
    FBoundsTop: Double;
    FBoundsWidth: Double;
    FBoundsHeight: Double;
    FSubFilter: AnsiString;
    FPassthrough: Boolean;
    FPassthroughSignatureLength: Integer;
    FByteRange: array[0..3] of Int64;
    FInPlace: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function OpenPDF(const FileName: WideString; const Password: WideString): TQuickPDFSignerResult;
    function OpenPDFStream(SourceStream: TStream; const Password: WideString): TQuickPDFSignerResult;
    function OpenPDFString(const SourceString: AnsiString; const Password: WideString): TQuickPDFSignerResult;
    function OpenPFX(const FileName: WideString; const Password: AnsiString; UseMachineKeyset: Boolean): TQuickPDFSignerResult;
    procedure SelectField(const FieldName: WideString; FieldPage: Integer);
    procedure SetSignatureProperty(SignatureProperty: TQuickPDFSignatureProperty;
      const NewValue: AnsiString);
    procedure SetSignatureBounds(Left, Top, Width, Height: Double);
    procedure SetPassthrough(SignatureLength: Integer);
    function AppendToFile(const FileName: WideString): Boolean;
    function AppendToStream(TargetStream: TStream): Boolean;
    function ApplySignature: Boolean;
    function GetByteRange(Index: Integer): Int64;
    procedure SetInPlace;
  end;

  TQuickPDFSignatureVerifierResult = (vsUnknown, vsValid, vsInvalid);

  TQuickPDFSignatureVerifier = class
  private
    FPDFDoc: TQuickPDFSignDoc;
  public
    constructor Create;
    destructor Destroy; override;
    function OpenPDF(const FileName: WideString; const Password: WideString): TQuickPDFSignerResult;
    function VerifySignature: TQuickPDFSignatureVerifierResult;
  end;

implementation

uses
  SysUtils, DebenuPDFLibraryCryptoAPI, DebenuPDFLibraryDigest;

function CheckReadAccess(const FileName: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
  S: AnsiString;
begin
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    if (FS.Size > 0) then
    begin
      SetLength(S, 1);
      FS.Read(S[1], 1);
    end;
    FS.Free;
    Result := True;
  except
    Result := False;
  end;
end;

function CheckReadWriteAccess(const FileName: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
  S: AnsiString;
begin
  try
    FS := QPLCreateFileStream(FileName, fmOpenReadWrite or fmShareDenyWrite);
    if (FS.Size > 0) then
    begin
      SetLength(S, 1);
      FS.Read(S[1], 1);
      FS.Seek(0, soFromBeginning);
      FS.Write(S[1], 1);
    end;
    FS.Free;
    Result := True;
  except
    Result := False;
  end;
end;

function TQuickPDFSignDoc.AddSignatureField(const FieldName: WideString;
  PageNumber: Integer): Integer;
begin
  if FIsOpen then
  begin
    Result := FSmartDoc.AddSignatureField(FieldName, FSmartDoc.FindPage(PageNumber));
  end else
    Result := 0;
end;

procedure TQuickPDFSignDoc.Append;
var
  OutStream: TMemoryStream;
  Writer: TSmartPDFWriter;
begin
  if FIsOpen then
  begin
    OutStream := TMemoryStream.Create;
    try
      Writer := TSmartPDFWriter.Create(OutStream);
      try
        FSmartReader.FixTrailer;
        if (FSmartReader.HasXRefStream) then
        begin
          Writer.AddXRefStream(FSmartDoc.WriteNewObjects(Writer), FStream.Size);        
        end else
        begin
          Writer.AddTrailer(FSmartDoc.WriteNewObjects(Writer), FStream.Size);
        end;
        FSignatureFieldPosition := FStream.Size +
          Writer.GetObjectPosition(FSignatureFieldObjNum);
        FSignatureFieldLength := Writer.GetObjectLength(FSignatureFieldObjNum);
      finally
        Writer.Free;
      end;
      FStream.Seek(FStream.Size, soBeginning);
      OutStream.Seek(0, soFromBeginning);
      FStream.CopyFrom(OutStream, OutStream.Size);
    finally
      OutStream.Free;
    end;
    Close;
  end;
end;

function TQuickPDFSignDoc.AppendToFile(const FileName: WideString): Boolean;
var
  FNewStream: TQuickPDFWideFileStream;
begin
  if (FileName <> '') then
  begin  
    try
      FNewStream := QPLCreateFileStream(FileName, fmCreate);
    except
      FNewStream := nil;
    end;
    if Assigned(FNewStream) then
    begin
      FStream.Seek(0, soFromBeginning);
      FNewStream.CopyFrom(FStream, FStream.Size);
      if (not FExternalStream) then
      begin
        FStream.Free;
      end;
      FExternalStream := False;
      FStream := FNewStream;
      Append;
      Result := True;
    end else
      Result := False;
  end else
  begin
    // In place signing
    FStream.Seek(0, soFromEnd);
    Append;
    Result := True;
  end;
end;

function TQuickPDFSignDoc.AppendToStream(TargetStream: TStream): Boolean;
var
  FNewStream: TStream;
begin
  FNewStream := TargetStream;

  if Assigned(FNewStream) then
  begin
    FStream.Seek(0, soFromBeginning);
    FNewStream.CopyFrom(FStream, FStream.Size);
    if (not FExternalStream) then
    begin
      FStream.Free;
    end;
    FExternalStream := True;
    FStream := FNewStream;
    Append;
    Result := True;
  end else
    Result := False;
end;

procedure TQuickPDFSignDoc.Close;
begin
  FIsOpen := False;
  FSmartInfo.Free;
  FSmartDoc.Free;
  FSmartReader.Free;
  if (not FExternalStream) then
  begin
    FStream.Free;
  end;
end;

destructor TQuickPDFSignDoc.Destroy;
begin
  if FIsOpen then
  begin
    FSmartInfo.Free;
    FSmartDoc.Free;
    FSmartReader.Free;
    if (not FExternalStream) then
    begin
      FStream.Free;
    end;
  end;
  inherited;
end;

function TQuickPDFSignDoc.GetSignatureValue(FieldRef: TPDFIndRef;
  ValueKey: Integer): AnsiString;
begin
  if FIsOpen then
    Result := FSmartDoc.GetSignatureValue(FieldRef, ValueKey)
  else
    Result := '';
end;

function TQuickPDFSignDoc.HasSignatureField(
  const FieldName: WideString): Boolean;
begin
  if FIsOpen then
    Result := FSmartDoc.HasSignatureField(FieldName)
  else
    Result := False;
end;

function TQuickPDFSignDoc.Open(const FileName: WideString; const Password: WideString; ReadWrite: Boolean): Boolean;
begin
  Result := False;
  if FIsOpen then
  begin
    FIsOpen := False;
    FSmartDoc.Free;
    FSmartInfo.Free;
    FSmartReader.Free;
    if (not FExternalStream) then
    begin
      FStream.Free;
    end;
  end;
  try
    FExternalStream := False;
    if (ReadWrite) then
    begin
      FStream := QPLCreateFileStream(FileName, fmOpenReadWrite or fmShareExclusive);
    end else
    begin
      FStream := QPLCreateFileStream(FileName, fmOpenRead or fmShareExclusive);
    end;
    FSmartReader := TSmartPDFReader.Create(FStream);
    if FSmartReader.ErrorCode = ecNone then
    begin
      FSmartDoc := TSmartPDFDocument.Create(FSmartReader);
      FSmartInfo := TSmartPDFInfo.Create(FSmartReader, Password);
      FSmartDoc.SmartInfo := FSmartInfo;
      Result := True;
      FIsOpen := True;
    end else
    begin
      FSmartReader.Free;
      FStream.Free;
    end;
  except
    FStream := nil;
  end;
end;

function TQuickPDFSignDoc.OpenStream(SourceStream: TStream;
  const Password: WideString): Boolean;
begin
  Result := False;
  if FIsOpen then
  begin
    FIsOpen := False;
    FSmartDoc.Free;
    FSmartInfo.Free;
    FSmartReader.Free;
    if (not FExternalStream) then
    begin
      FStream.Free;
    end;
  end;
  try
    FExternalStream := True;
    FStream := SourceStream;
    FSmartReader := TSmartPDFReader.Create(FStream);
    if FSmartReader.ErrorCode = ecNone then
    begin
      FSmartDoc := TSmartPDFDocument.Create(FSmartReader);
      FSmartInfo := TSmartPDFInfo.Create(FSmartReader, Password);
      FSmartDoc.SmartInfo := FSmartInfo;
      Result := True;
      FIsOpen := True;
    end else
    begin
      FSmartReader.Free;
    end;
  except
    FStream := nil;
  end;
end;

function TQuickPDFSignDoc.OpenString(const SourceData: AnsiString;
  const Password: WideString): Boolean;
begin
  Result := False;
  if FIsOpen then
  begin
    FIsOpen := False;
    FSmartDoc.Free;
    FSmartInfo.Free;
    FSmartReader.Free;
    if (not FExternalStream) then
    begin
      FStream.Free;
    end;
  end;
  try
    FExternalStream := False;
    FStream := TMemoryStream.Create;
    if (Length(SourceData) > 0) then
    begin
      FStream.Write(SourceData[1], Length(SourceData));
    end;
    FSmartReader := TSmartPDFReader.Create(FStream);
    if FSmartReader.ErrorCode = ecNone then
    begin
      FSmartDoc := TSmartPDFDocument.Create(FSmartReader);
      FSmartInfo := TSmartPDFInfo.Create(FSmartReader, Password);
      FSmartDoc.SmartInfo := FSmartInfo;
      Result := True;
      FIsOpen := True;
    end else
    begin
      FSmartReader.Free;
    end;
  except
    FStream := nil;
  end;
end;

procedure TQuickPDFSignDoc.SetSignatureBounds(const FieldName: WideString; Left,
  Top, Width, Height: Double);
begin
  if FIsOpen then
  begin
    FSmartDoc.SetSignatureBounds(FieldName, Left, Top, Width, Height);
  end;
end;

procedure TQuickPDFSignDoc.SetSignatureFlags(NewFlags: Integer);
begin
  if FIsOpen then
  begin
    FSmartDoc.SetSignatureFlags(NewFlags);
  end;
end;

procedure TQuickPDFSignDoc.SetSignatureImage(const FieldName: WideString;
  const ImageData: AnsiString; ImageOptions: Integer);
begin
  if FIsOpen then
  begin
    FSmartDoc.SetSignatureImage(FieldName, ImageData, ImageOptions);
  end;
end;

procedure TQuickPDFSignDoc.SetSignatureValue(const FieldName: WideString;
  const NewValue: AnsiString);
begin
  if FIsOpen then
  begin
    FSmartDoc.SetSignatureValue(FieldName, NewValue);
    FSignatureFieldObjNum := FSmartDoc.GetSignatureValueObjectNumber(FieldName);
  end;
end;

{ TQuickPDFSigner }

function TQuickPDFSigner.AppendToFile(const FileName: WideString): Boolean;
begin
  Result := False;
  if FPDFDoc.IsOpen then
  begin
    FPDFDoc.SetSignatureValue(FSignatureField, FSigValue.Output);
    if (FSetBounds) then
    begin
      FPDFDoc.SetSignatureBounds(FSignatureField, FBoundsLeft, FBoundsTop,
        FBoundsWidth, FBoundsHeight);
    end;
    FPDFDoc.SetSignatureImage(FSignatureField, FImageData, FImageOptions);
    Result := FPDFDoc.AppendToFile(FileName);
    if (Result) then
    begin
      if (not FInPlace) then
      begin
        FTargetFileName := FileName;
      end;
    end;
  end;
end;

function TQuickPDFSigner.AppendToStream(TargetStream: TStream): Boolean;
begin
  Result := False;
  if FPDFDoc.IsOpen then
  begin
    FPDFDoc.SetSignatureValue(FSignatureField, FSigValue.Output);
    if (FSetBounds) then
    begin
      FPDFDoc.SetSignatureBounds(FSignatureField, FBoundsLeft, FBoundsTop,
        FBoundsWidth, FBoundsHeight);
    end;
    FPDFDoc.SetSignatureImage(FSignatureField, FImageData, FImageOptions);
    Result := FPDFDoc.AppendToStream(TargetStream);
    if Result then FTargetStream := TargetStream;
  end;
end;

function TQuickPDFSigner.ApplySignature: Boolean;
var
  SignaturePosition: Int64;
  SignatureLength: Integer;
  FS: TStream;
  S: AnsiString;
  Found: Boolean;
  CE: Integer;
  CS: Integer;
  R1, R2, R3, R4: Int64;
  P: Integer;
  Digest: AnsiString;
  SigData: AnsiString;
  Contents: AnsiString;
  ContentsSize: Integer;
  ByteRange: AnsiString;
  ByteRangeSize: Integer;
  BRE: Integer;
  BRS: Integer;
  DataToSign: AnsiString;
begin
  Result := False;
  SignaturePosition := FPDFDoc.SignatureFieldPosition;
  SignatureLength := FPDFDoc.SignatureFieldLength;

  if ((FTargetFileName = '') and (Assigned(FTargetStream))) then
  begin
    FS := FTargetStream;
  end else
  if QPLFileExists(FTargetFileName) then
  begin
    try
      FS := QPLCreateFileStream(FTargetFileName, fmOpenReadWrite or fmShareExclusive);
    except
      FS := nil;
    end;
  end else
  begin
    FS := nil;
  end;

  if Assigned(FS) then
  try
    FS.Seek(SignaturePosition, soBeginning);
    SetLength(S, SignatureLength);
    FS.Read(S[1], SignatureLength);

    Found := QPLPos('/Contents', S) > 0;

    if Found then
    begin
      CS := QPLPos('/Contents', S);
      repeat
        Inc(CS);
      until S[CS] = '<';
      Inc(CS);
      CE := CS;
      repeat
        Inc(CE);
      until S[CE] = '>';
      Dec(CE);

      BRS := QPLPos('/ByteRange', S);
      repeat
        Inc(BRS);
      until S[BRS] = '<';
      BRE := BRS;
      repeat
        Inc(BRE);
      until S[BRE] = '>';

      R1 := 0;
      R2 := SignaturePosition + CS - 2;
      R3 := SignaturePosition + CE + 1;
      R4 := FS.Size - SignaturePosition - CE - 1;

      FByteRange[0] := R1;
      FByteRange[1] := R2;
      FByteRange[2] := R3;
      FByteRange[3] := R4;

      ByteRange := QPLIntToStr(R1) + ' ' + QPLIntToStr(R2) + ' ' +
        QPLIntToStr(R3) + ' ' + QPLIntToStr(R4);
      ByteRangeSize := BRE - BRS + 1;

      while Length(ByteRange) < ByteRangeSize do
      begin
        ByteRange := ByteRange + '     ';
      end;
      SetLength(ByteRange, ByteRangeSize);

      Delete(S, BRS, Length(ByteRange));
      Insert(ByteRange, S, BRS);

      // Write the byte range to the file so that
      // it can be part of the hash
      FS.Seek(SignaturePosition, soBeginning);
      FS.Write(S[1], Length(S));

      if (FPassthrough) then
      begin
        SigData := '';
      end else
      begin
        if (FSubFilter = 'adbe.pkcs7.detached') then
        begin
          FS.Seek(0, soBeginning);
          SetLength(DataToSign, R2 + R4);
          FS.Read(DataToSign[1], R2);
          FS.Seek(R3, soBeginning);
          FS.Read(DataToSign[R2 + 1], R4);
          SigData := FPFXFile.SignData(DataToSign, FSubFilter);
        end else
        begin
          Digest := SHA1StreamRange(FS, R2, R3, R4);
          SigData := FPFXFile.SignData(Digest, FSubFilter);
        end;
      end;

      Contents := '';
      for P := 1 to Length(SigData) do
        Contents := Contents + QPLIntToHex(Ord(SigData[P]), 2);

      ContentsSize := CE - CS + 1;
      while Length(Contents) < ContentsSize do
        Contents := Contents + '00000000';
      SetLength(Contents, ContentsSize);

      Delete(S, CS, Length(Contents));
      Insert(Contents, S, CS);

      FS.Seek(SignaturePosition, soBeginning);
      FS.Write(S[1], Length(S));

      Result := True;
    end;
  finally
    if (FTargetFileName <> '') then
    begin
      FS.Free;
    end;
  end;
end;

constructor TQuickPDFSigner.Create;
begin
  FPDFDoc := TQuickPDFSignDoc.Create;
  FPFXFile := TQuickPDFPFXFile.Create;
  FStructure := TPDFStructure.Create;
  FSigValue := FStructure.NewDictionary;
  FImageData := '';
  FSetBounds := False;
  FSubFilter := 'adbe.pkcs7.sha1';
  FPassthrough := False;
  FInPlace := False;
end;

destructor TQuickPDFSigner.Destroy;
begin
  FPDFDoc.Free;
  FPFXFile.Free;
  FStructure.Free;
  inherited;
end;

function TQuickPDFSigner.GetByteRange(Index: Integer): Int64;
begin
  if (Index >= 0) and (Index < 4) then
  begin
    Result := FByteRange[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDFSigner.OpenPDF(const FileName: WideString;
  const Password: WideString): TQuickPDFSignerResult;
var
  CanAccess: Boolean;
begin
  if QPLFileExists(FileName) then
  begin
    if (FInPlace) then
    begin
      CanAccess := CheckReadWriteAccess(FileName);
      FTargetFileName := FileName;
    end else
    begin
      CanAccess := CheckReadAccess(FileName);
    end;
    if (CanAccess) then
    begin
      if FPDFDoc.Open(FileName, Password, FInPlace) then
      begin
        Result := srOkay;
      end else
        Result := srWrongPassword;
    end else
      Result := srCannotRead;
  end else
    Result := srFileNotFound;
end;

function TQuickPDFSigner.OpenPFX(const FileName: WideString;
  const Password: AnsiString; UseMachineKeyset: Boolean): TQuickPDFSignerResult;
begin
  if QPLFileExists(FileName) then
  begin
    if CheckReadAccess(FileName) then
    begin
      Result := FPFXFile.Open(FileName, Password, UseMachineKeyset);
    end else
      Result := srCannotRead;
  end else
    Result := srFileNotFound;
end;

function TQuickPDFSigner.OpenPDFStream(SourceStream: TStream;
  const Password: WideString): TQuickPDFSignerResult;
begin
  if FPDFDoc.OpenStream(SourceStream, Password) then
  begin
    Result := srOkay;
  end else
    Result := srWrongPassword;
end;

function TQuickPDFSigner.OpenPDFString(const SourceString: AnsiString;
  const Password: WideString): TQuickPDFSignerResult;
begin
  if FPDFDoc.OpenString(SourceString, Password) then
  begin
    Result := srOkay;
  end else
    Result := srWrongPassword;
end;

procedure TQuickPDFSigner.SelectField(const FieldName: WideString; FieldPage: Integer);
var
  S: AnsiString;
begin
  if not FPDFDoc.HasSignatureField(FieldName) then
  begin
    FPDFDoc.AddSignatureField(FieldName, FieldPage);
  end;
  FPDFDoc.SetSignatureFlags(3);

  FSignatureField := FieldName;
  FSigValue.Clear;
  FSigValue.Add('Type', FStructure.NewName('Sig'));
  FSigValue.Add('Filter', FStructure.NewName('Adobe.PPKLite'));
  FSigValue.Add('SubFilter', FStructure.NewName(FSubFilter));

  if (FPassthrough) then
  begin
    SetLength(S, FPassthroughSignatureLength * 2);
  end else
  begin
    SetLength(S, Length(FPFXFile.SignData('12345678901234567890', FSubFilter)) * 2 + 512);
  end;
  FillChar(S[1], Length(S), '0');
  FSigValue.Add('Contents', FStructure.Decode('<' + S + '>'));

  SetLength(S, 200);
  FillChar(S[1], Length(S), '0');

  FSigValue.Add('ByteRange', FStructure.Decode(
    '[ <' + S + '> ]'));

  FSigValue.Add('M', FStructure.NewString(GetPDFDateTime));
//  FSigValue.Add('Name', FStructure.NewString(''));
end;

procedure TQuickPDFSigner.SetInPlace;
begin
  FInPlace := True;
end;

procedure TQuickPDFSigner.SetPassthrough(SignatureLength: Integer);
begin
  FPassthrough := True;
  FPassthroughSignatureLength := SignatureLength;
end;

procedure TQuickPDFSigner.SetSignatureBounds(Left, Top, Width, Height: Double);
begin
  FSetBounds := True;
  FBoundsLeft := Left;
  FBoundsTop := Top;
  FBoundsWidth := Width;
  FBoundsHeight := Height;
end;

procedure TQuickPDFSigner.SetSignatureProperty(
  SignatureProperty: TQuickPDFSignatureProperty;
  const NewValue: AnsiString);
begin
  case SignatureProperty of
    spReason: FSigValue.Add('Reason', FStructure.NewString(NewValue));
    spLocation: FSigValue.Add('Location', FStructure.NewString(NewValue));
    spContactInfo: FSigValue.Add('ContactInfo', FStructure.NewString(NewValue));
    spFieldImage: FImageData := NewValue;
    spSubFilter: FSubFilter := NewValue;
    spFieldImageOptions: FImageOptions := QPLStrToIntDef(NewValue, 0);
  end;
end;

{ TQuickPDFPFXFile }

procedure TQuickPDFPFXFile.Clear;
begin
  if FCertStore > 0 then
  begin
    CertCloseStore(FCertStore);
    FCertStore := 0;
  end;
  if FContext > 0 then
  begin
    CertFreeCertificateContext(FContext);
    FContext := 0;
  end;
end;

destructor TQuickPDFPFXFile.Destroy;
begin
  Clear;
  inherited;
end;

type
  TPFXBlob = record
    cbData: Cardinal;
    pbData: Pointer;
  end;

function TQuickPDFPFXFile.Open(const FileName: WideString;
  const Password: AnsiString; UseMachineKeyset: Boolean): TQuickPDFSignerResult;
var
  FS: TQuickPDFWideFileStream;
  PFXFile: AnsiString;
  PFXBlob: TPFXBlob;
  hCertStore: Cardinal;
  hCertContext: Cardinal;
  PFXPassword: WideString;
  PropSize: Cardinal;
  Flags: Cardinal;
begin
  FContext := 0;
  Result := srOkay;

  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    SetLength(PFXFile, FS.Size);
    FS.Read(PFXFile[1], Length(PFXFile));
    FS.Free;
  except
    PFXFile := 'X';
  end;

  PFXBlob.cbData := Length(PFXFile);
  PFXBlob.pbData := @PFXFile[1];
  if PFXIsPFXBlob(@PFXBlob) then
  begin
    PFXPassword := WideString(Password);
    Flags := CRYPT_USER_KEYSET;
    if (UseMachineKeyset) then
    begin
      Flags := CRYPT_MACHINE_KEYSET;
    end;
    hCertStore := PFXImportCertStore(@PFXBlob, @PFXPassword[1], Flags);
    if hCertStore > 0 then
    begin
      hCertContext := 0;
      repeat
        hCertContext := CertEnumCertificatesInStore(hCertStore, hCertContext);
        if hCertContext > 0 then
        begin
          PropSize := 0;
          if CertGetCertificateContextProperty(hCertContext,
            CERT_KEY_PROV_INFO_PROP_ID, nil, PropSize) then
          begin
            FContext := hCertContext;
          end;
        end;
      until (hCertContext = 0) or (FContext > 0);
      if FContext = 0 then Result := srNoPrivateKey;
    end else
      Result := srWrongPassword;
  end else
    Result := srBadFormat;
end;

function TQuickPDFPFXFile.SignData(const Data, SubFilter: AnsiString): AnsiString;
var
  DataArray: array[0..0] of Pointer;
  SizeArray: array[0..0] of Cardinal;
  SignPara: CRYPT_SIGN_MESSAGE_PARA;
  ResultLength: Cardinal;
  IsDetached: Boolean;
begin
  Result := '';
  if Length(Data) > 0 then
  begin
    DataArray[0] := @Data[1];
    SizeArray[0] := Length(Data);

    FillChar(SignPara, SizeOf(SignPara), 0);
    SignPara.cbSize := SizeOf(SignPara);
    SignPara.dwMsgEncodingType := X509_ASN_ENCODING or PKCS_7_ASN_ENCODING;
    SignPara.pSigningCert := FContext;

    if (SubFilter = 'adbe.pkcs7.detached') then
    begin
      SignPara.HashAlgorithmObjId := '1.3.14.3.2.26';  // SHA1
    end else
    if (SubFilter = 'adbe.pkcs7.sha1') then
    begin
      SignPara.HashAlgorithmObjId := '1.2.840.113549.1.1.5'; // RSA SHA1
    end;

    SignPara.cMsgCert := 1;
    SignPara.rgpMsgCert := @FContext;

    IsDetached := SubFilter = 'adbe.pkcs7.detached';

    ResultLength := 0;
    if CryptSignMessage(@SignPara, IsDetached, 1, @DataArray[0], @SizeArray[0],
      nil, ResultLength) then
    begin
      SetLength(Result, ResultLength);
      CryptSignMessage(@SignPara, IsDetached, 1, @DataArray[0], @SizeArray[0],
        @Result[1], ResultLength);
    end;
  end;
end;

{ TQuickPDFSignatureVerifier }

constructor TQuickPDFSignatureVerifier.Create;
begin
  FPDFDoc := TQuickPDFSignDoc.Create;
end;

destructor TQuickPDFSignatureVerifier.Destroy;
begin
  FPDFDoc.Free;
  inherited;
end;

function TQuickPDFSignatureVerifier.OpenPDF(const FileName: WideString;
  const Password: WideString): TQuickPDFSignerResult;
begin
  if QPLFileExists(FileName) then
  begin
    if (CheckReadAccess(FileName)) then
    begin
      if FPDFDoc.Open(FileName, Password, False) then
      begin
        Result := srOkay;
      end else
        Result := srWrongPassword;
    end else
      Result := srCannotRead;
  end else
    Result := srFileNotFound;
end;

function TQuickPDFSignatureVerifier.VerifySignature: TQuickPDFSignatureVerifierResult;
begin
  Result := vsUnknown;
end;

{ TQuickPDFSignProcess }

constructor TQuickPDFSignProcess.Create;
begin
  SourceDataType := dtFile;
  SourceFileName := '';
  SourceStream := nil;
  SourceString := '';
  SourcePassword := '';
  TargetDataType := dtFile;
  TargetFileName := '';
  TargetStream := nil;
  TargetString := '';
  PFXDataType := dtFile;
  PFXFileName := '';
  PFXPassword := '';
  Reason := '';
  Location := '';
  ContactInfo := '';
  SignatureFieldName := '';
  FieldImageFileName := '';
  FieldBoundsLeft := 0;
  FieldBoundsTop := 0;
  FieldBoundsWidth := 0;
  FieldBoundsHeight := 0;
  FieldPage := 1;
  SetFieldBounds := False;
  SubFilter := 'adbe.pkcs7.sha1';
  SignResult := 0;
  Passthrough := False;
  ByteRange[0] := 0;
  ByteRange[1] := 0;
  ByteRange[2] := 0;
  ByteRange[3] := 0;
  UseMachineKeyset := False;
end;

function TQuickPDFSignProcess.Sign: Integer;
var
  Signer: TQuickPDFSigner;
  PFXPasswordA: AnsiString;
  ReasonA: AnsiString;
  LocationA: AnsiString;
  ContactInfoA: AnsiString;
  OpenResult: TQuickPDFSignerResult;
  FieldImageFile: TQuickPDFWideFileStream;
  FieldImageData: AnsiString;
  TempStream: TMemoryStream;
  PFXResult: TQuickPDFSignerResult;
begin
  PFXPasswordA := AnsiString(PFXPassword);
  ReasonA := AnsiString(Reason);
  LocationA := AnsiString(Location);
  ContactInfoA := AnsiString(ContactInfo);

  if SignatureFieldName = '' then
  begin
    Result := 12;
  end else
  begin
    Result := 0;
    Signer := TQuickPDFSigner.Create;
    try
      case SourceDataType of
        dtFile: OpenResult := Signer.OpenPDF(SourceFileName, SourcePassword);
        dtStream: OpenResult := Signer.OpenPDFStream(SourceStream, SourcePassword);
        dtString: OpenResult := Signer.OpenPDFString(SourceString, SourcePassword);
      else
        OpenResult := srOkay;
      end;

      case OpenResult of
        srOkay:
        begin
          if (Passthrough) then
          begin
            Signer.SetPassthrough(PassthroughSignatureLength);
            PFXResult := srOkay;
          end else
          begin
            PFXResult := Signer.OpenPFX(PFXFileName, PFXPasswordA, UseMachineKeyset);
          end;
          case PFXResult of
            srOkay:
            begin
              Signer.SetSignatureProperty(spSubFilter, SubFilter);
              Signer.SelectField(SignatureFieldName, FieldPage);
              Signer.SetSignatureProperty(spReason, ReasonA);
              Signer.SetSignatureProperty(spLocation, LocationA);
              Signer.SetSignatureProperty(spContactInfo, ContactInfoA);

              if (FieldImageFileName <> '') then
              begin
                try
                  FieldImageFile := TQuickPDFWideFileStream.Create(FieldImageFileName, fmOpenRead);
                  SetLength(FieldImageData, FieldImageFile.Size);
                  if (Length(FieldImageData) > 0) then
                  begin
                    FieldImageFile.Read(FieldImageData[1], FieldImageFile.Size);
                  end;
                  FieldImageFile.Free;
                  Signer.SetSignatureProperty(spFieldImage, FieldImageData);
                  Signer.SetSignatureProperty(spFieldImageOptions, QPLIntToStr(FieldImageOptions));
                except
                end;
              end;

              if (SetFieldBounds) then
              begin
                Signer.SetSignatureBounds(FieldBoundsLeft, FieldBoundsTop,
                  FieldBoundsWidth, FieldBoundsHeight);
              end;

              if (TargetDataType = dtFile) then
              begin
                if Signer.AppendToFile(TargetFileName) then
                begin
                  if Signer.ApplySignature then
                    Result := 1   // Success
                  else
                    Result := 11; // Could not apply signature
                end else
                  Result := 10;   // Could not write output file
              end else
              if (TargetDataType = dtStream) then
              begin
                if Signer.AppendToStream(TargetStream) then
                begin
                  if Signer.ApplySignature then
                    Result := 1   // Success
                  else
                    Result := 11; // Could not apply signature
                end else
                  Result := 10;   // Could not write output file
              end else
              if (TargetDataType = dtString) then
              begin
                TempStream := TMemoryStream.Create;
                try
                  if Signer.AppendToStream(TempStream) then
                  begin
                    if Signer.ApplySignature then
                    begin
                      Result := 1;   // Success
                      TempStream.Seek(0, soBeginning);
                      SetLength(TargetString, TempStream.Size);
                      if (TempStream.Size > 0) then
                      begin
                        TempStream.Read(TargetString[1], TempStream.Size);
                      end;
                    end else
                      Result := 11; // Could not apply signature
                  end else
                    Result := 10;   // Could not write output file
                finally
                  TempStream.Free;
                end;
              end;
              if (Passthrough) then
              begin
                ByteRange[0] := Signer.GetByteRange(0);
                ByteRange[1] := Signer.GetByteRange(1);
                ByteRange[2] := Signer.GetByteRange(2);
                ByteRange[3] := Signer.GetByteRange(3);
              end;
            end;
            srFileNotFound: Result := 5;  // Certificate file not found
            srCannotRead: Result := 6;    // Certificate file is invalid
            srWrongPassword: Result := 7; // Incorrect certificate password
            srBadFormat: Result := 8;     // Unknown certificate format
            srNoPrivateKey: Result := 9;  // No private key found in certificate file
          end;
        end;
        srFileNotFound: Result := 2;  // Input PDF not found
        srCannotRead: Result := 3;    // Input PDF cannot be read
        srWrongPassword: Result := 4; // Input PDF password incorrect
      end;
    finally
      Signer.Free;
    end;
  end;
  SignResult := Result;
end;

end.
