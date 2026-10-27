{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryImageTransform.pas                     }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryImageTransform;

interface

uses
  Classes, DebenuPDFLibraryTypes;

type
  TDPLImageByteArray = array of Byte;

  TDPLImageIntegerArray = array of Integer;

  TDPLImageTransformMethod = (tmNearestNeighbour);

  TDPLImageBitmapFormat = (bf24BitRGB, bf24BitBGR, bf8BitGray, bf1BitGray, bf32BitRGBA);

  TDPLImage = class
  private
    FImageData: TDPLImageByteArray;
    FWidth: Integer;
    FHeight: Integer;
    FStride: Integer;
    FComponents: Integer;
    FBitsPerComponent: Integer;
  public
    constructor Create(InitWidth, InitHeight, InitComponents, InitBitsPerComponent: Integer);
    procedure SetBitsPerComponent(NewBitsPerComponent: Integer; Rescale: Boolean);
    procedure SetSizeTruncatePad(NewWidth, NewHeight: Integer);
    procedure SetSizeScale(NewWidth, NewHeight: Integer; Method: TDPLImageTransformMethod);
    procedure SetValue(X, Y, Component, NewValue: Integer);
    procedure GetRowValues(Row: Integer; var RowValues: TDPLImageIntegerArray);
    procedure SetRowValues(Row: Integer; RowValues: TDPLImageIntegerArray);
    procedure GenerateBitmap(OutStream: TStream; BitmapFormat: TDPLImageBitmapFormat);
    procedure AddComponentFromImage(NewComponentImage: TDPLImage);
    procedure SetFromPointer(Source: Pointer);
    function GetRowPointer(Row: Integer): Pointer;
    function GetDataPointer: Pointer;
    function DataSizeBytes: Integer;
    procedure FlipVertical;
    procedure Invert;
    procedure ApplyPalette(Palette: TDPLImageByteArray);
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Stride: Integer read FStride;
    property Components: Integer read FComponents;
    property BitsPerComponent: Integer read FBitsPerComponent;
  end;

implementation

{ TDPLImage }

// Adds a new component to the current image (ie adds a new color plane).
// The NewComponentImage should only contain a single component and should
// have the same BitsPerComponent.
procedure TDPLImage.AddComponentFromImage(
  NewComponentImage: TDPLImage);
var
  NewImage: TDPLImage;
  OldRowValues: TDPLImageIntegerArray;
  NewComponentRowValues: TDPLImageIntegerArray;
  CombinedRowValues: TDPLImageIntegerArray;
  P1, P2, P3: TQPLPByte;
  Row: Integer;
  Column: Integer;
  I1, I2, I3: Integer;
  ComponentIndex: Integer;
begin
  if ((NewComponentImage.FBitsPerComponent = FBitsPerComponent) and
    (NewComponentImage.FWidth = FWidth) and (NewComponentImage.FHeight = FHeight) and
    (NewComponentImage.FComponents = 1)) then
  begin
    NewImage := TDPLImage.Create(FWidth, FHeight, FComponents + 1, FBitsPerComponent);
    try
      if (FBitsPerComponent = 8) then
      begin
        for Row := 0 to FHeight - 1 do
        begin
          P1 := GetRowPointer(Row);
          P2 := NewComponentImage.GetRowPointer(Row);
          P3 := NewImage.GetRowPointer(Row);
          for Column := 0 to FWidth - 1 do
          begin
            Move(P1^, P3^, FComponents);
            Inc(P3, FComponents);
            Move(P2^, P3^, 1);
            Inc(P1, FComponents);
            Inc(P2, 1);
            Inc(P3, 1);
          end;
        end;
      end else
      begin
        SetLength(OldRowValues, FWidth * FComponents);
        SetLength(NewComponentRowValues, FWidth);
        SetLength(CombinedRowValues, FWidth * (FComponents + 1));

        for Row := 0 to FHeight - 1 do
        begin
          I1 := 0;
          I2 := 0;
          I3 := 0;
          GetRowValues(Row, OldRowValues);
          NewComponentImage.GetRowValues(Row, NewComponentRowValues);
          for Column := 0 to FWidth - 1 do
          begin
            for ComponentIndex := 0 to FComponents - 1 do
            begin
              CombinedRowValues[I3 + ComponentIndex] := OldRowValues[I1 + ComponentIndex];
            end;
            CombinedRowValues[I3 + FComponents] := NewComponentRowValues[I2];
            Inc(I1, FComponents);
            Inc(I2, 1);
            Inc(I3, FComponents + 1);
          end;
          NewImage.SetRowValues(Row, CombinedRowValues);
        end;
      end;

      Inc(FComponents);
      FStride := NewImage.FStride;
      SetLength(FImageData, Length(NewImage.FImageData));
      Move(NewImage.FImageData[0], FImageData[0], Length(FImageData));
    finally
      NewImage.Free;
    end;
  end;
end;

// Sets the BitsPerComponent to a new value. Requires enough memory to
// hold the original and the new image at the same time in memory.
// The values can be kept as they are (and truncated if the bits per component
// is reduced) or the values can be scaled from their original range to
// the new range.
procedure TDPLImage.SetBitsPerComponent(
  NewBitsPerComponent: Integer; Rescale: Boolean);
var
  Row, ColComp: Integer;
  NewImage: TDPLImage;
  ScaleValue: Double;
  RowValues: TDPLImageIntegerArray;
  MaxValue: Integer;
begin
  if (NewBitsPerComponent <> FBitsPerComponent) then
  begin
    if ((NewBitsPerComponent = 1) or (NewBitsPerComponent = 2) or
      (NewBitsPerComponent = 4) or (NewBitsPerComponent = 8) or (NewBitsPerComponent = 16)) then
    begin
      MaxValue := (1 shl NewBitsPerComponent) - 1;
      NewImage := TDPLImage.Create(FWidth, FHeight, FComponents, NewBitsPerComponent);
      try
        SetLength(RowValues, FComponents * FWidth);
        for Row := 0 to FHeight - 1 do
        begin
          GetRowValues(Row, RowValues);

          if (Rescale) then
          begin
            for ColComp := 0 to (FWidth * FComponents) - 1 do
            begin
              ScaleValue := RowValues[ColComp] / ((1 shl FBitsPerComponent) - 1);
              ScaleValue := ScaleValue * ((1 shl NewBitsPerComponent) - 1);
              RowValues[ColComp] := Round(ScaleValue);
            end;
          end else
          begin
            for ColComp := 0 to (FWidth * FComponents) - 1 do
            begin
              if (RowValues[ColComp] > MaxValue) then
              begin
                RowValues[ColComp] := MaxValue;
              end;
            end;
          end;

          NewImage.SetRowValues(Row, RowValues);
        end;

        FBitsPerComponent := NewBitsPerComponent;
        FStride := NewImage.FStride;
        SetLength(FImageData, Length(NewImage.FImageData));
        Move(NewImage.FImageData[0], FImageData[0], Length(FImageData));
      finally
        NewImage.Free;
      end;
    end;
  end;
end;

procedure TDPLImage.SetFromPointer(Source: Pointer);
begin
  Move(Source^, FImageData[0], Length(FImageData));
end;

// Applies a (3 * x) palette R1G1B1R2G2B2...RxGxBx to convert
// a single component image, any bits per pixel, to a three component image
// at 8 bits per component
procedure TDPLImage.ApplyPalette(Palette: TDPLImageByteArray);
var
  NewImage: TDPLImage;
  Row: Integer;
  PaletteSize: Integer;
  RowValues: TDPLImageIntegerArray;
  NewRowValues: TDPLImageIntegerArray;
  Col: Integer;
  IndexValue: Integer;
begin
  if ((Length(Palette) mod 3) = 0) then
  begin
    PaletteSize := Length(Palette) div 3;
    NewImage := TDPLImage.Create(FWidth, FHeight, 3, 8);
    try
      SetLength(NewRowValues, FWidth * 3);
      for Row := 0 to FHeight - 1 do
      begin
        GetRowValues(Row, RowValues);
        for Col := 0 to FWidth - 1 do
        begin
          IndexValue := RowValues[Col];
          if (IndexValue < PaletteSize) then
          begin
            NewRowValues[Col * 3] := Palette[IndexValue * 3];
            NewRowValues[Col * 3 + 1] := Palette[IndexValue * 3 + 1];
            NewRowValues[Col * 3 + 2] := Palette[IndexValue * 3 + 2];
          end else
          begin
            NewRowValues[Col * 3] := 0;
            NewRowValues[Col * 3 + 1] := 0;
            NewRowValues[Col * 3 + 2] := 0;
          end;
        end;
        NewImage.SetRowValues(Row, NewRowValues);
      end;
      FBitsPerComponent := 8;
      FStride := NewImage.FStride;
      SetLength(FImageData, Length(NewImage.FImageData));
      Move(NewImage.FImageData[0], FImageData[0], Length(FImageData));
      FComponents := 3;
    finally
      NewImage.Free;
    end;
  end;
end;

// Defaults to a 1x1 single component image with 8-bits per pixel if
// any parameter is out of range. Components must 1 or greater,
// BitsPerComponent must be 1, 2, 4, 8 or 16. Width and height must be
// 1 or greater.
constructor TDPLImage.Create(InitWidth, InitHeight, InitComponents, InitBitsPerComponent: Integer);
begin
  if ((InitWidth > 0) and (InitHeight > 0) and (InitComponents > 0) and
    ((InitBitsPerComponent = 1) or (InitBitsPerComponent = 2) or
     (InitBitsPerComponent = 4) or (InitBitsPerComponent = 8) or
     (InitBitsPerComponent = 16))) then
  begin
    FWidth := InitWidth;
    FHeight := InitHeight;
    FComponents := InitComponents;
    FBitsPerComponent := InitBitsPerComponent;
    FStride := (FBitsPerComponent * FComponents * FWidth) div 8;
    if ((FStride * 8) < (FBitsPerComponent * FComponents * FWidth)) then
    begin
      Inc(FStride);
    end;
    SetLength(FImageData, FStride * FHeight);
    FillChar(FImageData[0], Length(FImageData), 0);
  end else
  begin
    SetLength(FImageData, 1);
    FImageData[0] := 0;
    FWidth := 1;
    FHeight := 1;
    FStride := 1;
    FComponents := 1;
    FBitsPerComponent := 8;
  end;
end;

// Returns the size in bytes of the entire image data block
function TDPLImage.DataSizeBytes: Integer;
begin
  Result := FStride * FHeight;
end;

procedure TDPLImage.FlipVertical;
var
  Temp: TDPLImageByteArray;
  Row: Integer;
begin
  SetLength(Temp, FStride);
  for Row := 0 to FHeight div 2 - 1 do
  begin
    Move(FImageData[FStride * Row], Temp[0], FStride);
    Move(FImageData[FStride * (Row + 1)], Temp[0], FStride);
  end;
end;

// Directly generates a Windows BMP into the supplied TStream with these
// possible formats:
//   bf24BitRGB (PDF)
//   bf24BitBGR (BMP)
//   bf8BitGray (Linear 000000 to FFFFFF RGB palette)
//   bf32BitRGBA
procedure TDPLImage.GenerateBitmap(OutStream: TStream; BitmapFormat: TDPLImageBitmapFormat);
var
  Buffer: array of Byte;
  BMPSize: Integer;
  DIBSize: Integer;
  PixelArraySize: Integer;
  PixelArrayOffset: Integer;
  PixelRowSize: Integer;
  PixelFormat: Integer;
  Resolution: Integer;
  PaletteColors: Integer;
  ImportantColors: Integer;
  Valid: Boolean;
  PaddingCount: Integer;
  PaddingData: Integer;
  Row: Integer;
  Index: Integer;
  BitsPerPixel: Integer;
  PaletteSize: Integer;
  PaletteItems: array of Cardinal;
  PaletteIndex: Byte;
  BitFields: Cardinal;
  Temp: Integer;
  SwapIndex: Integer;
begin
  Valid := False;
  PaddingCount := 0;
  PixelArraySize := 0;
  PixelArrayOffset := 0;
  BMPSize := 0;
  PixelFormat := 0;
  PaletteColors := 0;
  ImportantColors := 0;
  BitsPerPixel := 0;
  PaletteSize := 0;
  SetLength(PaletteItems, 0);

  if ((BitmapFormat = bf24BitRGB) or (BitmapFormat = bf24BitBGR)) then
  begin
    if ((FComponents = 3) and (FBitsPerComponent = 8)) then
    begin
      Valid := True;
      PixelRowSize := FWidth * 3;
      PaddingCount := 0;
      while ((PixelRowSize mod 4) > 0) do
      begin
        Inc(PixelRowSize);
        Inc(PaddingCount);
      end;
      DIBSize := 40;
      PixelArraySize := PixelRowSize * FHeight;
      PixelArrayOffset := 14 + DIBSize;
      BMPSize := PixelArrayOffset + PixelArraySize;
      PixelFormat := 0;  // BI_RGB
      BitsPerPixel := 24;
      PaletteSize := 0;
    end;
  end else
  if (BitmapFormat = bf8BitGray) then
  begin
    if ((FComponents = 1) and (FBitsPerComponent = 8)) then
    begin
      Valid := True;
      PixelRowSize := FWidth;
      PaddingCount := 0;
      while ((PixelRowSize mod 4) > 0) do
      begin
        Inc(PixelRowSize);
        Inc(PaddingCount);
      end;
      DIBSize := 40;
      PixelArraySize := PixelRowSize * FHeight;
      PixelFormat := 0;  // BI_RGB
      BitsPerPixel := 8;
      PaletteColors := 256;
      PaletteSize := PaletteColors * 4;
      SetLength(PaletteItems, PaletteColors);
      for PaletteIndex := 0 to PaletteColors - 1 do
      begin
        PaletteItems[PaletteIndex] := (PaletteIndex shl 16) +
          (PaletteIndex shl 8) + PaletteIndex;
      end;
      BMPSize := PixelArrayOffset + PixelArraySize + PaletteSize;
      PixelArrayOffset := 14 + DIBSize + PaletteSize;
    end;
  end else
  if (BitmapFormat = bf32BitRGBA) then
  begin
    if ((FComponents = 4) and (FBitsPerComponent = 8)) then
    begin
      Valid := True;
      PixelRowSize := FWidth * 4;
      PaddingCount := 0;
      DIBSize := 108;
      PixelArraySize := PixelRowSize * FHeight;
      PixelArrayOffset := 14 + DIBSize;
      BMPSize := PixelArrayOffset + PixelArraySize;
      PixelFormat := 3;  // BI_BITFIELDS
      BitsPerPixel := 32;
      PaletteSize := 0;
    end;
  end;

  if (Valid) then
  begin
    // Write the BMP header
    SetLength(Buffer, 2);
    Buffer[0] := 66; // "BM"
    Buffer[1] := 77;
    OutStream.Write(Buffer[0], 2);
    OutStream.Write(BMPSize, 4);
    Buffer[0] := 0;
    Buffer[1] := 0;
    OutStream.Write(Buffer[0], 2);
    OutStream.Write(Buffer[0], 2);
    OutStream.Write(PixelArrayOffset, 4);

    OutStream.Write(DIBSize, 4);
    OutStream.Write(FWidth, 4);
    OutStream.Write(FHeight, 4);
    Buffer[0] := 1;  // 1 Plane
    Buffer[1] := 0;
    OutStream.Write(Buffer[0], 2);
    Buffer[0] := BitsPerPixel;
    Buffer[1] := 0;
    OutStream.Write(Buffer[0], 2);
    OutStream.Write(PixelFormat, 4);
    OutStream.Write(PixelArraySize, 4);
    Resolution := 2835;
    OutStream.Write(Resolution, 4);
    OutStream.Write(Resolution, 4);
    OutStream.Write(PaletteColors, 4);
    OutStream.Write(ImportantColors, 4);

    if (DIBSize = 108) then
    begin
      // Red, green, blue
      BitFields := $00FF0000;
      OutStream.Write(BitFields, 4);
      BitFields := $0000FF00;
      OutStream.Write(BitFields, 4);
      BitFields := $000000FF;
      OutStream.Write(BitFields, 4);

      // Alpha
      BitFields := $FF000000;
      OutStream.Write(BitFields, 4);

      // Colorspace
      BitFields := $57696E20;
      OutStream.Write(BitFields, 4);
      SetLength(Buffer, 48);
      FillChar(Buffer[0], 48, 0);
      OutStream.Write(Buffer[0], 48);
    end;

    if (PaletteSize > 0) then
    begin
      OutStream.Write(PaletteItems[0], PaletteSize);
    end;

    SetLength(Buffer, FStride);
    PaddingData := 0;
    Index := (FHeight - 1) * FStride;
    for Row := FHeight - 1 downto 0 do
    begin
      if (BitmapFormat = bf24BitRGB) then
      begin
        // Swap Red and Blue
        Move(FImageData[Index], Buffer[0], FStride);
        for SwapIndex := 0 to FWidth - 1 do
        begin
          Temp := Buffer[SwapIndex * 3];
          Buffer[SwapIndex * 3] := Buffer[SwapIndex * 3 + 2];
          Buffer[SwapIndex * 3 + 2] := Temp;
        end;
        OutStream.Write(Buffer[0], FStride);
      end else
      if (BitmapFormat = bf24BitBGR) then
      begin
        // Write directly to output buffer
        OutStream.Write(FImageData[Index], FStride);
      end else
      if (BitmapFormat = bf32BitRGBA) then
      begin
        // Swap Red and Blue
        Move(FImageData[Index], Buffer[0], FStride);
        for SwapIndex := 0 to FWidth - 1 do
        begin
          Temp := Buffer[SwapIndex * 4];
          Buffer[SwapIndex * 4] := Buffer[SwapIndex * 4 + 2];
          Buffer[SwapIndex * 4 + 2] := Temp;
        end;
        OutStream.Write(Buffer[0], FStride);
      end else
      begin
        OutStream.Write(FImageData[Index], FStride);
      end;
      if (PaddingCount > 0) then
      begin
        OutStream.Write(PaddingData, PaddingCount);
      end;
      Dec(Index, FStride);
    end;
  end;
end;

// Returns a pointer to the first byte of the image data
function TDPLImage.GetDataPointer: Pointer;
begin
  Result := @FImageData[0];
end;

// Returns the component values of a row expanded to 32-bits each.
// Returns an empty array if Row is out of range.
function TDPLImage.GetRowPointer(Row: Integer): Pointer;
begin
  if ((Row >= 0) and (Row < FHeight)) then
  begin
    Result := @FImageData[Row * FStride];
  end else
  begin
    Result := nil;
  end;
end;

procedure TDPLImage.GetRowValues(Row: Integer;
  var RowValues: TDPLImageIntegerArray);
var
  BitMask: Integer;
  BitShift: Integer;
  StartBitMask: Integer;
  StartBitShift: Integer;
  Index: Integer;
  ColComp: Integer;
begin
  if ((Row >= 0) and (Row < FHeight)) then
  begin
    SetLength(RowValues, FComponents * FWidth);

    if (FBitsPerComponent = 1) then
    begin
      StartBitMask := 128; // 10000000
      StartBitShift := 7;
    end else
    if (FBitsPerComponent = 2) then
    begin
      StartBitMask := 192; // 11000000
      StartBitShift := 6;
    end else
    if (FBitsPerComponent = 4) then
    begin
      StartBitMask := 240; // 11110000
      StartBitShift := 4;
    end else
    begin
      StartBitMask := 0;
      StartBitShift := 0;
    end;

    Index := Row * FStride;
    BitMask := StartBitMask;
    BitShift := StartBitShift;

    for ColComp := 0 to (FWidth * FComponents) - 1 do
    begin
      if (FBitsPerComponent = 16) then
      begin
        RowValues[ColComp] := FImageData[Index] shl 8 + FImageData[Index + 1];
        Inc(Index, 2);
      end else
      if (FBitsPerComponent = 8) then
      begin
        RowValues[ColComp] := FImageData[Index];
        Inc(Index);
      end else
      begin
        RowValues[ColComp] := (FImageData[Index] and BitMask) shr BitShift;
        BitMask := BitMask shr FBitsPerComponent;
        BitShift := BitShift - FBitsPerComponent;
        if (BitMask = 0) then
        begin
          BitMask := StartBitMask;
          BitShift := StartBitShift;
          Inc(Index);
        end;
      end;
    end;
  end else
  begin
    SetLength(RowValues, 0);
  end;
end;

// Inverts the image data with max value based on the bits per component
procedure TDPLImage.Invert;
var
  RowValues: TDPLImageIntegerArray;
  Row: Integer;
  ColComp: Integer;
  MaxValue: Integer;
  DataIndex: Integer;
begin
  if (FBitsPerComponent = 1) then
  begin
    // Optimization for 1-bit images, work directly on the bytes
    for DataIndex := 0 to Length(FImageData) - 1 do
    begin
      FImageData[DataIndex] := not FImageData[DataIndex];
    end;
  end else
  begin
    MaxValue := (1 shl FBitsPerComponent) - 1;
    for Row := 0 to FHeight - 1 do
    begin
      GetRowValues(Row, RowValues);
      for ColComp := 0 to (FWidth * FComponents) - 1 do
      begin
        RowValues[ColComp] := MaxValue - RowValues[ColComp];
      end;
      SetRowValues(Row, RowValues);
    end;
  end;
end;

// Encodes the supplied component values to the current
// bits per component and writes into the image data.
procedure TDPLImage.SetRowValues(Row: Integer;
  RowValues: TDPLImageIntegerArray);
var
  BitMask: Integer;
  BitShift: Integer;
  StartBitMask: Integer;
  StartBitShift: Integer;
  ColComp: Integer;
  Index: Integer;
begin
  if ((Row >= 0) and (Row < FHeight) and (Length(RowValues) = (FComponents * FWidth))) then
  begin
    if (FBitsPerComponent = 1) then
    begin
      StartBitMask := 1; // 00000001
      StartBitShift := 7;
    end else
    if (FBitsPerComponent = 2) then
    begin
      StartBitMask := 3; // 00000011
      StartBitShift := 6;
    end else
    if (FBitsPerComponent = 4) then
    begin
      StartBitMask := 15; // 00001111
      StartBitShift := 4;
    end else
    begin
      StartBitMask := 0;
      StartBitShift := 0;
    end;

    Index := Row * FStride;

    // Set initial values to zero for sub-byte OR combining
    if (FBitsPerComponent < 8) then
    begin
      for ColComp := 0 to FStride - 1 do
      begin
        FImageData[Index + ColComp] := 0;
      end;
    end;

    BitMask := StartBitMask;
    BitShift := StartBitShift;

    for ColComp := 0 to (FWidth * FComponents) - 1 do
    begin
      if (FBitsPerComponent = 16) then
      begin
        FImageData[Index] := (RowValues[ColComp] and $FF00) shr 8;
        FImageData[Index + 1] := (RowValues[ColComp] and $FF);
        Inc(Index, 2);
      end else
      if (FBitsPerComponent = 8) then
      begin
        FImageData[Index] := RowValues[ColComp];
        Inc(Index);
      end else
      begin
        FImageData[Index] := FImageData[Index] or (RowValues[ColComp] and BitMask) shl BitShift;
        BitShift := BitShift - FBitsPerComponent;
        if (BitShift < 0) then
        begin
          BitMask := StartBitMask;
          BitShift := StartBitShift;
          Inc(Index);
        end;
      end;
    end;
  end;
end;

// Resizes the image, scaling it using the specified scaling method
procedure TDPLImage.SetSizeScale(NewWidth, NewHeight: Integer; Method: TDPLImageTransformMethod);
var
  Row, Column: Integer;
  NewRow, NewColumn: Integer;
  RowValues: TDPLImageIntegerArray;
  NewRowValues: TDPLImageIntegerArray;
  LastRowValues: Integer;
  ComponentIndex: Integer;
  NewImage: TDPLImage;
begin
  if ((NewWidth > 0) and (NewHeight > 0)) then
  begin
    NewImage := TDPLImage.Create(NewWidth, NewHeight, FComponents, FBitsPerComponent);
    try
      // if (Method = xxx) then
      // begin

      // end else
      begin
        // Nearest neighbour
        LastRowValues := -1;
        SetLength(NewRowValues, NewWidth * FComponents);
        for NewRow := 0 to NewHeight - 1 do
        begin
          Row := (NewRow * FHeight) div NewHeight;
          if (Row <> LastRowValues) then
          begin
            GetRowValues(Row, RowValues);
            LastRowValues := Row;
          end;
          for NewColumn := 0 to NewWidth - 1 do
          begin
            Column := (NewColumn * FWidth) div NewWidth;
            for ComponentIndex := 0 to FComponents - 1 do
            begin
              NewRowValues[NewColumn * FComponents + ComponentIndex] :=
                RowValues[Column * FComponents + ComponentIndex];
            end;
          end;
          NewImage.SetRowValues(NewRow, NewRowValues);
        end;
      end;
      FWidth := NewWidth;
      FHeight := NewHeight;
      FStride := NewImage.FStride;
      SetLength(FImageData, Length(NewImage.FImageData));
      Move(NewImage.FImageData[0], FImageData[0], Length(FImageData));
    finally
      NewImage.Free;
    end;
  end;
end;

// Sets the width and height of the image without scaling the image data
procedure TDPLImage.SetSizeTruncatePad(NewWidth, NewHeight: Integer);
var
  NewStride: Integer;
  Row: Integer;
  OldIndex: Integer;
  NewIndex: Integer;
  RowPadding: Integer;
begin
  if ((NewWidth > 0) and (NewHeight > 0)) then
  begin
    NewStride := (FBitsPerComponent * NewWidth * FComponents) div 8;
    if ((NewStride * 8) < (FBitsPerComponent * NewWidth * FComponents)) then
    begin
      Inc(NewStride);
    end;
    if (NewStride <= FStride) then
    begin
      OldIndex := FStride;
      NewIndex := NewStride;
      for Row := 1 to FHeight - 1 do
      begin
        Move(FImageData[OldIndex], FImageData[NewIndex], NewStride);
        Inc(OldIndex, FStride);
        Inc(NewIndex, NewStride);
      end;
      SetLength(FImageData, NewStride * NewHeight);
      for Row := FHeight to NewHeight - 1 do
      begin
        FillChar(FImageData[NewIndex], (NewStride * NewHeight) - (FStride * FHeight), 0);
      end;
      FWidth := NewWidth;
      FHeight := NewHeight;
      FStride := NewStride;
    end else
    begin
      SetLength(FImageData, NewStride * FHeight);
      OldIndex := FStride * (FHeight - 1);
      NewIndex := NewStride * (FHeight - 1);
      for Row := FHeight - 1 downto 0 do
      begin
        Move(FImageData[OldIndex], FImageData[NewIndex], FStride);
        for RowPadding := 0 to (NewStride - FStride) - 1 do
        begin
          FImageData[NewIndex + FStride + RowPadding] := 0;
        end;
        Dec(OldIndex, FStride);
        Dec(NewIndex, NewStride);
      end;
      SetLength(FImageData, NewStride * NewHeight);
      if (NewHeight > FHeight) then
      begin
        NewIndex := NewStride * FHeight;
        FillChar(FImageData[NewIndex], NewStride * (NewHeight - FHeight), 0);
      end;

      FWidth := NewWidth;
      FHeight := NewHeight;
      FStride := NewStride;
    end;
  end;
end;

procedure TDPLImage.SetValue(X, Y, Component, NewValue: Integer);
var
  ColComp: Integer;
  Index: Integer;
  Row: Integer;
  Column: Integer;
begin
  Row := Y;
  Column := X;
  if ((Row >= 0) and (Column >= 0) and
    (Component >= 0) and (Component < FComponents) and
    (Row < FHeight) and (Column < FWidth) and
    (NewValue < (1 shl FBitsPerComponent))) then
  begin
    ColComp := Column * FComponents + Component;
    Index := Row * FStride + (ColComp * FBitsPerComponent) div 8;

    case FBitsPerComponent of
      1:
      begin
        case (ColComp mod 8) of
          0:
          begin
            FImageData[Index] := FImageData[Index] and $7F;  // 01111111
            FImageData[Index] := FImageData[Index] or ((NewValue and $01) shl 7);
          end;
          1:
          begin
            FImageData[Index] := FImageData[Index] and $BF;  // 10111111
            FImageData[Index] := FImageData[Index] or ((NewValue and $01) shl 6);
          end;
          2:
          begin
            FImageData[Index] := FImageData[Index] and $DF;  // 11011111
            FImageData[Index] := FImageData[Index] or ((NewValue and $01) shl 5);
          end;
          3:
          begin
            FImageData[Index] := FImageData[Index] and $EF;  // 11101111
            FImageData[Index] := FImageData[Index] or ((NewValue and $01) shl 4);
          end;
          4:
          begin
            FImageData[Index] := FImageData[Index] and $F7;  // 11110111
            FImageData[Index] := FImageData[Index] or ((NewValue and $01) shl 3);
          end;
          5:
          begin
            FImageData[Index] := FImageData[Index] and $FB;  // 11111011
            FImageData[Index] := FImageData[Index] or ((NewValue and $01) shl 2);
          end;
          6:
          begin
            FImageData[Index] := FImageData[Index] and $FD;  // 11111101
            FImageData[Index] := FImageData[Index] or ((NewValue and $01) shl 1);
          end;
          7:
          begin
            FImageData[Index] := FImageData[Index] and $FE;  // 11111110
            FImageData[Index] := FImageData[Index] or (NewValue and $01);
          end;
        end;
      end;
      2:
      begin
        case (ColComp mod 4) of
          0:
          begin
            FImageData[Index] := FImageData[Index] and $3F;  // 00111111
            FImageData[Index] := FImageData[Index] or ((NewValue and $03) shl 6);
          end;
          1:
          begin
            FImageData[Index] := FImageData[Index] and $CF;  // 11001111
            FImageData[Index] := FImageData[Index] or ((NewValue and $03) shl 4);
          end;
          2:
          begin
            FImageData[Index] := FImageData[Index] and $F3;  // 11110011
            FImageData[Index] := FImageData[Index] or ((NewValue and $03) shl 2);
          end;
          3:
          begin
            FImageData[Index] := FImageData[Index] and $FC;  // 11111100
            FImageData[Index] := FImageData[Index] or (NewValue and $03);
          end;
        end;
      end;
      4:
      begin
        if ((ColComp mod 2) = 0) then
        begin
          FImageData[Index] := FImageData[Index] and $0F;
          FImageData[Index] := FImageData[Index] or ((NewValue and $0F) shl 4);
        end else
        begin
          FImageData[Index] := FImageData[Index] and $F0;
          FImageData[Index] := FImageData[Index] or (NewValue and $0F);
        end;
      end;
      8:
      begin
        FImageData[Index] := NewValue;
      end;
      16:
      begin
        FImageData[Index] := (NewValue and $FF00) shr 8;
        FImageData[Index + 1] := NewValue and $FF;
      end;
    end;
  end;
end;

end.
