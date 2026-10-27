{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryGIF.pas                                }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryGIF;

{$I DebenuPDFLibraryDefines.inc}

interface

{$IFNDEF QPL_OS_WINDOWS}
uses
  DebenuPDFLibraryGraphics, Classes;

type
  TPDFGIFDecoder = class
  public
    procedure LoadFromStream(Source: TStream);
    procedure SaveToBitmap(Target: TBitmap);
  end;

  TPDFGIFWriter = class
  public
    procedure Assign(ABitmap: TBitmap);
    procedure SaveToStream(Stream: TStream);
  end;

{$ELSE}

uses
  Windows, Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  SysUtils, DebenuPDFLibraryExtra;

type
  TPDFGIFLogicalScreen = record
    Width: Word;
    Height: Word;
    GlobalColorTable: Boolean;
    Colors: Word;
    GCTSorted: Boolean;
    GCTSize: Word;
    BackgroundColorIndex: Byte;
    PixelAspectRatio: Double;
  end;

  TPDFGIFRGB = packed record
    Red: Byte;
    Green: Byte;
    Blue: Byte;
  end;

  TPDFGIFGraphicControlExtension = record
    Valid: Boolean;
    DisposalMethod: Integer;
    UserInput: Boolean;
    Transparent: Boolean;
    DelayTime: Word;
    TransparentColorIndex: Integer;
  end;

  TPDFGIFImageBlock = record
    Left: Word;
    Top: Word;
    Width: Word;
    Height: Word;
    HasLocalColorTable: Boolean;
    Interlaced: Boolean;
    LCTSorted: Boolean;
    LCTSize: Word;
    LocalColorTable: array of TPDFGIFRGB;
    LZWMinimumCodeSize: Byte;
    ImageData: AnsiString;
    Control: TPDFGIFGraphicControlExtension;
  end;

  TPDFGIFDecoder = class
  private
    FStream: TStream;
    FVersion: AnsiString;
    FValidVersion: Boolean;
    FLogicalScreen: TPDFGIFLogicalScreen;
    FGlobalColorTable: array of TPDFGIFRGB;
    FImageBlocks: array of TPDFGIFImageBlock;
    FError: Boolean;
    FLastGraphicControl: TPDFGIFGraphicControlExtension;
    function ReadStr(const Len: Integer): AnsiString;
    function ReadWord: Word;
    function ReadByte: Byte;
    procedure ReadHeader;
    procedure ReadLogicalScreen;
    procedure ReadGlobalColorTable;
    function GetBackgroundColor: TColor;
    function GetNextBlock: Byte;
    procedure ReadExtensionBlock;
    procedure ReadImageBlock;
    procedure ReadPlainTextExtension;
    procedure ReadCommentExtension;
    procedure ReadGraphicControlExtension;
    procedure ReadApplicationExtension;
    procedure DecodeImage(BM: TBitmap; I: Integer);
  public
    procedure LoadFromString(const Source: AnsiString);
    procedure LoadFromStream(Source: TStream);
    procedure SaveToBitmap(Target: TBitmap);
    property Version: AnsiString read FVersion;
    property Width: Word read FLogicalScreen.Width;
    property Height: Word read FLogicalScreen.Height;
    property Colors: Word read FLogicalScreen.Colors;
    property ColorTableSize: Word read FLogicalScreen.GCTSize;
    property BackgroundColor: TColor read GetBackgroundColor;
    property PixelAspectRatio: Double read FLogicalScreen.PixelAspectRatio;
  end;

  TPDFGIFWriter = class
  private
    FWidth: Integer;
    FHeight: Integer;
    FBitmap: TBitmap;
    FPalette: array[0..255] of PALETTEENTRY;
  public
    destructor Destroy; override;
    procedure Assign(ABitmap: TBitmap);
    procedure SaveToFile(const FileName: WideString);
    procedure SaveToStream(Stream: TStream);
  end;
{$ENDIF}

implementation

{$IFNDEF QPL_OS_WINDOWS}
procedure TPDFGIFDecoder.LoadFromStream(Source: TStream);
begin

end;

procedure TPDFGIFDecoder.SaveToBitmap(Target: TBitmap);
begin

end;

procedure TPDFGIFWriter.Assign(ABitmap: TBitmap);
begin

end;

procedure TPDFGIFWriter.SaveToStream(Stream: TStream);
begin

end;

{$ELSE}

uses
  DebenuPDFLibraryLZW;

type
  TRGBQuadArray = array[Byte] of TRGBQuad;
  TOctreeNode = class;
  TReducibleNodes = array[0..7] of TOctreeNode;

  TOctreeNode = class
  public
    IsLeaf: Boolean;
    PixelCount: Integer;
    RedSum: Integer;
    GreenSum: Integer;
    BlueSum: Integer;
    Next: TOctreeNode;
    Child: TReducibleNodes;
    Index: Integer;
    constructor Create(Level, ColorBits: Integer; var LeafCount: Integer;
      var ReducibleNodes: TReducibleNodes);
  end;

  TColorQuantizer = class
  private
    FTree: TOctreeNode;
    FLeafCount: Integer;
    FReducibleNodes: TReducibleNodes;
    FMaxColors: Integer;
    FColorBits: Integer;
  protected
    procedure AddColor(var Node: TOctreeNode; R, G, B: Byte; ColorBits,
      Level: Integer; var LeafCount: Integer;
      var ReducibleNodes: TReducibleNodes);
    procedure DeleteTree(var Node: TOctreeNode);
    procedure GetPaletteColors(Node: TOctreeNode;
      var RGBQuadArray: TRGBQuadArray; var Index: Integer);
    procedure ReduceTree(ColorBits: Integer; var LeafCount: Integer;
      var ReducibleNodes: TReducibleNodes);
  public
    constructor Create(MaxColors, ColorBits: Integer);
    destructor Destroy; override;
    procedure GetColorTable(var RGBQuadArray: TRGBQuadArray);
    procedure GetPalette(var Palette: array of PALETTEENTRY);
    function MakePalette: HPALETTE;
    function ProcessImage(BM: TBitmap): TBitmap;
    property ColorCount: Integer read FLeafCount;
  end;

type
  TInverseLookup = array[0..32767] of SmallInt;
  PInverseLookup = ^TInverseLookup;
  PalArray =  array[byte] of TPaletteEntry;
  PPalArray = ^PalArray;

  TFastColorLookup = class
  private
    FPaletteEntries: PPalArray;
    FInverseLookup: PInverseLookup;
    FColors: Integer;
  public
    constructor Create(Palette: hPalette);
    destructor Destroy; override;
    function Lookup(Red, Green, Blue: Byte): Byte; 
  end;

{ TPDFGIFDecoder }

procedure TPDFGIFDecoder.DecodeImage(BM: TBitmap; I: Integer);
var
  D: TPDFLZWDecompressor;
  PixelData: AnsiString;
  ImgPass: Integer;
  ImgRow: Integer;
  OutputPos: Integer;
  ScanLine: array of Byte;
  Row, Col: Integer;
begin
  D := TPDFLZWDecompressor.Create;
  try
    D.FillOrder := foBottom;
    D.InitialCodeSize := FImageBlocks[I].LZWMinimumCodeSize + 1;
    D.EarlyChange := False;
    PixelData := D.Decompress(FImageBlocks[I].ImageData);
  finally
    D.Free;
  end;
  SetLength(PixelData, BM.Height * BM.Width);
  SetLength(ScanLine, BM.Width * 3);
  OutputPos := 1;
  ImgPass := 1;
  ImgRow := -8;
  for Row := 0 to BM.Height - 1 do
  begin
    if FImageBlocks[I].Interlaced then
    begin
      case ImgPass of
        1: Inc(ImgRow, 8);
        2: Inc(ImgRow, 8);
        3: Inc(ImgRow, 4);
        4: Inc(ImgRow, 2);
      end;
      if ImgRow >= BM.Height then
      begin
        Inc(ImgPass);
        if ImgPass = 2 then ImgRow := 4;
        if ImgPass = 3 then ImgRow := 2;
        if ImgPass = 4 then ImgRow := 1;
      end;
    end else
      ImgRow := Row;

    if (FImageBlocks[I].HasLocalColorTable) then
    begin
      for Col := 0 to BM.Width - 1 do
      begin
        ScanLine[Col * 3] := FImageBlocks[i].LocalColorTable[Ord(PixelData[OutputPos])].Blue;
        ScanLine[Col * 3 + 1] := FImageBlocks[i].LocalColorTable[Ord(PixelData[OutputPos])].Green;
        ScanLine[Col * 3 + 2] := FImageBlocks[i].LocalColorTable[Ord(PixelData[OutputPos])].Red;
        Inc(OutputPos);
      end;
      Move(ScanLine[0], BM.ScanLine[ImgRow]^, BM.Width * 3);
    end else
    begin
      for Col := 0 to BM.Width - 1 do
      begin
        ScanLine[Col * 3] := FGlobalColorTable[Ord(PixelData[OutputPos])].Blue;
        ScanLine[Col * 3 + 1] := FGlobalColorTable[Ord(PixelData[OutputPos])].Green;
        ScanLine[Col * 3 + 2] := FGlobalColorTable[Ord(PixelData[OutputPos])].Red;
        Inc(OutputPos);
      end;
      Move(ScanLine[0], BM.ScanLine[ImgRow]^, BM.Width * 3);
    end;
  end;
end;

function TPDFGIFDecoder.GetBackgroundColor: TColor;
var
  C: TPDFGIFRGB;
begin
  if FLogicalScreen.GlobalColorTable then
  begin
    C := FGlobalColorTable[FLogicalScreen.BackgroundColorIndex];
    Result := C.Red + C.Green shl 8 + C.Green shl 16;
  end else
    Result := 0;
end;

function TPDFGIFDecoder.GetNextBlock: Byte;
var
  S: AnsiString;
begin
  S := ReadStr(1);
  if Length(S) = 1 then Result := Ord(S[1]) else Result := $3B;
end;

procedure TPDFGIFDecoder.LoadFromStream(Source: TStream);
var
  NextBlock: Byte;
begin
  FStream := Source;
  ReadHeader;
  if FValidVersion then
  begin
    ReadLogicalScreen;
    if FLogicalScreen.GlobalColorTable then
      ReadGlobalColorTable;
    FLastGraphicControl.Valid := False;
    repeat
      NextBlock := GetNextBlock;
      case NextBlock of
        $21: ReadExtensionBlock;
        $2c: ReadImageBlock;
      end;
    until FError or (NextBlock = $3B);
  end;
end;

procedure TPDFGIFDecoder.LoadFromString(const Source: AnsiString);
var
  SS: TStringStream;
begin
  SS := TStringStream.Create(Source);
  try
    LoadFromStream(SS);
  finally
    SS.Free;
  end;
end;

procedure TPDFGIFDecoder.ReadApplicationExtension;
var
  BlockSize: Byte;
begin
  repeat
    BlockSize := ReadByte;
    if BlockSize > 0 then
      ReadStr(BlockSize);
  until BlockSize = 0;
end;

function TPDFGIFDecoder.ReadByte: Byte;
var
  S: AnsiString;
begin
  S := ReadStr(1);
  if Length(S) = 1 then Result := Ord(S[1]) else Result := 0;
end;

procedure TPDFGIFDecoder.ReadCommentExtension;
var
  BlockSize: Byte;
begin
  repeat
    BlockSize := ReadByte;
    if BlockSize > 0 then
      ReadStr(BlockSize);
  until BlockSize = 0;
end;

procedure TPDFGIFDecoder.ReadExtensionBlock;
var
  BlockLabel: Byte;
  BlockSize: Byte;
begin
  BlockLabel := ReadByte;
  case BlockLabel of
    $01: ReadPlainTextExtension;
    $fe: ReadCommentExtension;
    $f9: ReadGraphicControlExtension;
    $ff: ReadApplicationExtension;
  else
    repeat
      BlockSize := ReadByte;
      if BlockSize > 0 then
        ReadStr(BlockSize);
    until BlockSize = 0;
  end;
end;

procedure TPDFGIFDecoder.ReadGlobalColorTable;
begin
  SetLength(FGlobalColorTable, FLogicalScreen.GCTSize);
  if FLogicalScreen.GCTSize > 0 then
    FStream.Read(FGlobalColorTable[0], FLogicalScreen.GCTSize * 3);
end;

procedure TPDFGIFDecoder.ReadGraphicControlExtension;
var
  Flags: Byte;
begin
  FError := ReadByte <> 4;
  if not FError then
  begin
    Flags := ReadByte;
    FLastGraphicControl.Valid := True;
    FLastGraphicControl.DisposalMethod := Flags and 28 shr 2;
    FLastGraphicControl.UserInput := Flags and 2 = 2;
    FLastGraphicControl.Transparent := Flags and 1 = 1;
    FLastGraphicControl.DelayTime := ReadWord;
    FLastGraphicControl.TransparentColorIndex := ReadByte;
    FError := ReadByte <> 0;
  end;
end;

procedure TPDFGIFDecoder.ReadHeader;
var
  Header: AnsiString;
begin
  Header := ReadStr(6);
  if QPLCopy(Header, 1, 3) = 'GIF' then
    FVersion := QPLCopy(Header, 4, 3)
  else
    FVersion := '';
  FValidVersion := (FVersion = '87a') or (FVersion = '89a');
end;

procedure TPDFGIFDecoder.ReadImageBlock;
var
  Flags: Byte;
  ImageBlockIndex: Integer;
  HasLCT: Boolean;
  BlockSize: Byte;
const
  Pwr2: array[0..7] of Word = (2, 4, 8, 16, 32, 64, 128, 256);
begin
  ImageBlockIndex := Length(FImageBlocks);
  SetLength(FImageBlocks, ImageBlockIndex + 1);
  FImageBlocks[ImageBlockIndex].Left := ReadWord;
  FImageBlocks[ImageBlockIndex].Top := ReadWord;
  FImageBlocks[ImageBlockIndex].Width := ReadWord;
  FImageBlocks[ImageBlockIndex].Height := ReadWord;
  Flags := ReadByte;
  HasLCT := Flags and 128 = 128;
  FImageBlocks[ImageBlockIndex].HasLocalColorTable := HasLCT;
  FImageBlocks[ImageBlockIndex].Interlaced := Flags and 64 = 64;
  FImageBlocks[ImageBlockIndex].LCTSorted := Flags and 32 = 32;
  FImageBlocks[ImageBlockIndex].LCTSize := Pwr2[Flags and 7];
  if HasLCT then
  begin
    SetLength(FImageBlocks[ImageBlockIndex].LocalColorTable,
      FImageBlocks[ImageBlockIndex].LCTSize);
    FStream.Read(FImageBlocks[ImageBlockIndex].LocalColorTable[0],
      FImageBlocks[ImageBlockIndex].LCTSize * 3);
  end;
  FImageBlocks[ImageBlockIndex].LZWMinimumCodeSize := ReadByte;
  FImageBlocks[ImageBlockIndex].ImageData := '';
  repeat
    BlockSize := ReadByte;
    if BlockSize > 0 then
    begin
      FImageBlocks[ImageBlockIndex].ImageData :=
        FImageBlocks[ImageBlockIndex].ImageData + ReadStr(BlockSize);
    end;
  until BlockSize = 0;
  if FLastGraphicControl.Valid then
    FImageBlocks[ImageBlockIndex].Control := FLastGraphicControl
  else
    FImageBlocks[ImageBlockIndex].Control.Valid := False;
  FLastGraphicControl.Valid := False;
end;

procedure TPDFGIFDecoder.ReadLogicalScreen;
var
  Flags: Byte;
  Aspect: Byte;
const
  Pwr2: array[0..7] of Word = (2, 4, 8, 16, 32, 64, 128, 256);
begin
  FLogicalScreen.Width := ReadWord;
  FLogicalScreen.Height := ReadWord;
  Flags := ReadByte;
  FLogicalScreen.GlobalColorTable := Flags and 128 = 128;
  FLogicalScreen.Colors := Pwr2[(Flags and 112) shr 4];
  FLogicalScreen.GCTSorted := Flags and 8 = 8;
  FLogicalScreen.GCTSize := Pwr2[Flags and 7];
  FLogicalScreen.BackgroundColorIndex := ReadByte;
  Aspect := ReadByte;
  if Aspect = 0 then
    FLogicalScreen.PixelAspectRatio := 1
  else
    FLogicalScreen.PixelAspectRatio := (Aspect + 15) / 64;
end;

procedure TPDFGIFDecoder.ReadPlainTextExtension;
var
  BlockSize: Byte;
begin
  repeat
    BlockSize := ReadByte;
    if BlockSize > 0 then
      ReadStr(BlockSize);
  until BlockSize = 0;
end;

function TPDFGIFDecoder.ReadStr(const Len: Integer): AnsiString;
begin
  SetLength(Result, Len);
  if Len > 0 then
    SetLength(Result, FStream.Read(Result[1], Len));
end;

function TPDFGIFDecoder.ReadWord: Word;
var
  S: AnsiString;
begin
  S := ReadStr(2);
  if Length(S) = 2 then
    Result := Ord(S[1]) + Ord(S[2]) * 256
  else
    Result := 0;
end;

procedure TPDFGIFDecoder.SaveToBitmap(Target: TBitmap);
var
  I: Integer;
  BM: TBitmap;
begin
  Target.PixelFormat := pf24bit;
  Target.Width := FLogicalScreen.Width;
  Target.Height := FLogicalScreen.Height;
  BM := TBitmap.Create;
  try
    BM.Canvas.Lock;
    BM.PixelFormat := pf24bit;
    for I := 0 to Length(FImageBlocks) - 1 do
    begin
      BM.Width := FImageBlocks[I].Width;
      BM.Height := FImageBlocks[I].Height;
      BM.Canvas.Brush.Color := GetBackgroundColor;
      BM.Canvas.FillRect(Rect(0, 0, BM.Width, BM.Height));
      DecodeImage(BM, I);
      Target.Canvas.Draw(FImageBlocks[I].Left, FImageBlocks[I].Top, BM);
    end;
  finally
    BM.Free;
  end;
end;

{ TColorQuantizer }

procedure TColorQuantizer.AddColor(var Node: TOctreeNode; R, G, B: Byte;
  ColorBits, Level: Integer; var LeafCount: Integer;
  var ReducibleNodes: TReducibleNodes);
const
  Mask: array[0..7] of Byte = ($80, $40, $20, $10, $08, $04, $02, $01);
var
  Index: Integer;
  Shift: Integer;
begin
  if not Assigned(Node) then
  begin
    Node := TOctreeNode.Create(Level, ColorBits, LeafCount, ReducibleNodes);
    Node.Index := -1;
  end;

  if Node.IsLeaf then
  begin
    Inc(Node.PixelCount);
    Inc(Node.RedSum, R);
    Inc(Node.GreenSum, G);
    Inc(Node.BlueSum, B)
  end else
  begin
    Shift := 7 - Level;
    Index := (((R and Mask[Level]) shr Shift) shl 2) or (((G and Mask[Level])
      shr Shift) shl 1) or ((B and Mask[Level]) shr Shift);
    AddColor(Node.Child[Index], R, G, B, ColorBits, Level + 1, LeafCount,
      ReducibleNodes);
  end;
end;

constructor TColorQuantizer.Create(MaxColors, ColorBits: Integer);
var
  I: Integer;
begin
  FTree := nil;
  FLeafCount := 0;
  for I := Low(FReducibleNodes) to High(FReducibleNodes) do
    FReducibleNodes[i] := nil;
  FMaxColors := MaxColors;
  FColorBits := ColorBits
end;

procedure TColorQuantizer.DeleteTree(var Node: TOctreeNode);
var
  I: Integer;
begin
  for I := Low(TReducibleNodes) to High(TReducibleNodes) do
  begin
    if Assigned(Node.Child[I]) then
      DeleteTree(Node.Child[I]);
  end;
  Node.Free;
  Node := nil;
end;

destructor TColorQuantizer.Destroy;
begin
  if Assigned(FTree) then DeleteTree(FTree);
  inherited;
end;

procedure TColorQuantizer.GetColorTable(var RGBQuadArray: TRGBQuadArray);
var
  Index: Integer;
begin
  Index := 0;
  GetPaletteColors(FTree, RGBQuadArray, Index);
end;

procedure TColorQuantizer.GetPalette(var Palette: array of PALETTEENTRY);
var
  CT: TRGBQuadArray;
  X: Byte;
begin
  GetColorTable(CT);
  for X := 0 to 255 do
  begin
    Palette[X].peRed := CT[X].rgbRed;
    Palette[X].peGreen := CT[X].rgbGreen;
    Palette[X].peBlue := CT[X].rgbBlue;
    Palette[X].peFlags := 0;
  end;
end;

procedure TColorQuantizer.GetPaletteColors(Node: TOctreeNode;
  var RGBQuadArray: TRGBQuadArray; var Index: Integer);
var
  I: Integer;
begin
  if Node.IsLeaf then
  begin
    Node.Index := Index;
    with RGBQuadArray[Index] do
    begin
      try
        rgbRed := Byte(Node.RedSum div Node.PixelCount);
        rgbGreen := Byte(Node.GreenSum div Node.PixelCount);
        rgbBlue :=  Byte(Node.BlueSum div Node.PixelCount);
      except
        rgbRed := 0;
        rgbGreen := 0;
        rgbBlue := 0;
      end;
      rgbReserved := 0
    end;
    Inc(Index);
  end else
  begin
    for I := Low(Node.Child) to High(Node.Child) do
    begin
      if Assigned(Node.Child[I]) then
        GetPaletteColors(Node.Child[I], RGBQuadArray, Index);
    end;
  end;
end;

function TColorQuantizer.MakePalette: HPALETTE;
var
  Palette: TMaxLogPalette;
  CT: TRGBQuadArray;
  X: Byte;
  P: PLogPalette;
begin
  Palette.palVersion := $300;
  Palette.palNumEntries := 256;
  GetColorTable(CT);
  for X := 0 to 255 do
  begin
    Palette.palPalEntry[X].peRed := CT[X].rgbRed;
    Palette.palPalEntry[X].peGreen := CT[X].rgbGreen;
    Palette.palPalEntry[X].peBlue := CT[X].rgbBlue;
    Palette.palPalEntry[X].peFlags := 0;
  end;
  P := @Palette;
  Result := CreatePalette(P^);
end;

function TColorQuantizer.ProcessImage(BM: TBitmap): TBitmap;
var
  I: Integer;
  J: Integer;
  ScanLine: array of TRGBTriple;
  ScanLine8: array of Byte;
  Lookup: TFastColorLookup;
  Palette: HPALETTE;
begin
  SetLength(ScanLine, BM.Width);
  for J := 0 to BM.Height - 1 do
  begin
    Move(BM.ScanLine[J]^, ScanLine[0], BM.Width * 3);
    for I := 0 to BM.Width - 1 do
      AddColor(FTree, ScanLine[I].rgbtRed, ScanLine[I].rgbtGreen,
        ScanLine[I].rgbtBlue, FColorBits, 0, FLeafCount, FReducibleNodes);
    while FLeafCount > FMaxColors do
      ReduceTree(FColorbits, FLeafCount, FReducibleNodes);
  end;
  Result := TBitmap.Create;
  Result.PixelFormat := pf8bit;
  Result.Width := BM.Width;
  Result.Height := BM.Height;
  Palette := MakePalette;
  Result.Palette := Palette;

  Lookup := TFastColorLookup.Create(Palette);
  try
    SetLength(ScanLine8, Result.Width);
    for J := 0 to BM.Height - 1 do
    begin
      Move(BM.ScanLine[J]^, ScanLine[0], BM.Width * 3);
      for I := 0 to BM.Width - 1 do
      begin
        ScanLine8[I] := Lookup.Lookup(ScanLine[I].rgbtRed, ScanLine[I].rgbtGreen, ScanLine[I].rgbtBlue);
      end;
      Move(ScanLine8[0], Result.ScanLine[J]^, BM.Width);
    end;
  finally
    Lookup.Free;
  end;
end;

procedure TColorQuantizer.ReduceTree(ColorBits: Integer;
  var LeafCount: Integer; var ReducibleNodes: TReducibleNodes);
var
  RedSum: Integer;
  GreenSum: Integer;
  BlueSum: Integer;
  Children: Integer;
  I: Integer;
  Node: TOctreeNode;
begin
  I := Colorbits - 1;
  while (I > 0) and (ReducibleNodes[I] = nil) do
    Dec(I);

  Node := ReducibleNodes[I];
  ReducibleNodes[I] := Node.Next;

  RedSum  := 0;
  GreenSum := 0;
  BlueSum := 0;
  Children := 0;

  for I := Low(ReducibleNodes) to High(ReducibleNodes) do
  begin
    if Assigned(Node.Child[I]) then
    begin
      Inc(RedSum, Node.Child[I].RedSum);
      Inc(GreenSum, Node.Child[I].GreenSum);
      Inc(BlueSum, Node.Child[I].BlueSum);
      Inc(Node.PixelCount, Node.Child[I].PixelCount);
      Node.Child[I].Free;
      Node.Child[I] := nil;
      Inc(Children);
    end;
  end;

  Node.IsLeaf := True;
  Node.RedSum := RedSum;
  Node.GreenSum := GreenSum;
  Node.BlueSum := BlueSum;
  Dec(LeafCount, Children - 1);
end;

{ TOctreeNode }

constructor TOctreeNode.Create(Level, ColorBits: Integer;
  var LeafCount: Integer; var ReducibleNodes: TReducibleNodes);
var
  I: Integer;
begin
  PixelCount := 0;
  RedSum := 0;
  GreenSum := 0;
  BlueSum := 0;
  for I := Low(Child) to High(Child) do
    Child[I] := nil;
  IsLeaf := (Level = ColorBits);
  if IsLeaf then
  begin
    Next := nil;
    Inc(LeafCount);
  end else
  begin
    Next := ReducibleNodes[Level];
    ReducibleNodes[Level] := Self;
  end;
end;

{ TFastColorLookup }

constructor TFastColorLookup.Create(Palette: hPalette);
var
  I: Integer;
  InverseIndex: Integer;
begin
  GetMem(FPaletteEntries, SizeOf(TPaletteEntry) * 256);
  FColors := GetPaletteEntries(Palette, 0, 256, FPaletteEntries^);
  New(FInverseLookup);
  for I := Low(TInverseLookup) to High(TInverseLookup) do
    FInverseLookup^[I] := -1;
  if (FColors > 0) then
    for I := 0 to FColors - 1 do
      with FPaletteEntries^[I] do
      begin
        InverseIndex := (peRed shr 3) or ((peGreen and $F8) shl 2) or
          ((peBlue and $F8) shl 7);
        if (FInverseLookup^[InverseIndex] = -1) then
          FInverseLookup^[InverseIndex] := I;
      end;
end;

destructor TFastColorLookup.Destroy;
begin
  if (FPaletteEntries <> nil) then
    FreeMem(FPaletteEntries);
  if (FInverseLookup <> nil) then
    Dispose(FInverseLookup);
  inherited Destroy;
end;

function TFastColorLookup.Lookup(Red, Green, Blue: Byte): Byte;
var
  I: Integer;
  InverseIndex: Integer;
  Delta: Integer;
  MinDelta: Integer;
  MinColor: Integer;
begin
  InverseIndex := (Red shr 3) or ((Green and $F8) shl 2) or ((Blue and $F8) shl 7);
  if (FInverseLookup^[InverseIndex] = -1) then
  begin
    MinDelta := 3 * (256 * 256);
    MinColor := 0;
    for I := 0 to FColors - 1 do
      with FPaletteEntries[I] do
      begin
        Delta := Abs(peRed - Red) + Abs(peGreen - Green) + Abs(peBlue - Blue);
        if (Delta < MinDelta) then
        begin
          MinDelta := Delta;
          MinColor := I;
        end;
      end;
    Result := MinColor;
    FInverseLookup^[InverseIndex] := MinColor;
  end else
    Result := FInverseLookup^[InverseIndex];  
end;

const
  GIFCodeBits = 12;
  GIFCodeMax = 4095;
  HashKeyBits = 13;
  HashSize = 8009;
  HashKeyMax = 8191;
  HashKeyMask = HashKeyMax;
  GIFCodeMask = GIFCodeMax;
  HashEmpty = $000FFFFF;

type
  THashArray = array[0..8008] of Integer;
  PHashArray = ^THashArray;

  THashTable = class
    HashTable: PHashArray;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Insert(Key: Integer; Code: SmallInt);
    function Lookup(Key: Integer): SmallInt;
  end;

function HashKey(Key: Integer): SmallInt;
begin
  Result := ((Key shr (GIFCodeBits-8)) xor Key) mod HashSize;
end;

function NextHashKey(HKey: SmallInt): SmallInt;
var
  Disp: SmallInt;
begin
  Disp := HashSize - HKey;
  if (HKey = 0) then Disp := 1;
  Dec(HKey, Disp);
  if (HKey < 0) then Inc(HKey, HashSize);
  Result := HKey;
end;


constructor THashTable.Create;
begin
  inherited Create;
  GetMem(HashTable, sizeof(THashArray));
  Clear;
end;

destructor THashTable.Destroy;
begin
  FreeMem(HashTable);
  inherited Destroy;
end;

procedure THashTable.Clear;
begin
  FillChar(HashTable^, sizeof(THashArray), $FF);
end;

procedure THashTable.Insert(Key: Integer; Code: SmallInt);
var
  HKey: SmallInt;
begin
  HKey := HashKey(Key);
  while (HashTable[HKey] and (HashEmpty shl GIFCodeBits) <> (HashEmpty shl GIFCodeBits)) do { Optimized }
    HKey := NextHashKey(HKey);
  HashTable[HKey] := (Key shl GIFCodeBits) or (Code and GIFCodeMask);
end;

function THashTable.Lookup(Key: Integer): SmallInt;
var
  HKey: SmallInt;
  HTKey: Integer;
begin
  HKey := HashKey(Key);
  Key := Key shl GIFCodeBits;
  HTKey := HashTable[HKey] and (HashEmpty shl GIFCodeBits);
  while (HTKey <> HashEmpty shl GIFCodeBits) do
  begin
    if (Key = HTKey) then
    begin
      Result := HashTable[HKey] and GIFCodeMask;
      Exit;
    end;
    HKey := NextHashKey(HKey);
    HTKey := HashTable[HKey] and (HashEmpty shl GIFCodeBits);
  end;
  Result := -1;
end;

type
  TGIFStream = class
  private
    FData: AnsiString;
    FStream: TStream;
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;
    procedure WriteByte(B: Byte);
  end;

constructor TGIFStream.Create(AStream: TStream);
begin
  FStream := AStream;
end;

destructor TGIFStream.Destroy;
var
  L: Byte;
begin
  L := Length(FData);
  if L > 0 then
  begin
    FStream.Write(L, 1);
    FStream.Write(FData[1], Length(FData));
  end;
  inherited;
end;

procedure TGIFStream.WriteByte(B: Byte);
var
  L: Byte;
begin
  FData := FData + AnsiChar(B);
  if Length(FData) = 255 then
  begin
    L := Length(FData);
    FStream.Write(L, 1);
    FStream.Write(FData[1], Length(FData));
    FData := '';
  end;
end;

type
  TAbstractGIFEncoder = class(TObject)
  protected
    MaxColor: Integer;
    BitsPerPixel: Byte;
    Stream: TSTream;
    Width: Integer;
    Height: Integer;
    Interlace: Boolean;
    Data: PAnsiChar;
    GIFStream: TGIFStream;
    OutputBucket: Integer;
    OutputBits: Integer;
    ClearFlag: Boolean;
    BitsPerCode: Integer;
    InitialBitsPerCode: Integer;
    MaxCode: SmallInt;
    ClearCode: SmallInt;
    EOFCode: SmallInt;
    BaseCode: SmallInt;
    Pixel: PAnsiChar;
    cX: Integer;
    Y: Integer;
    function MaxCodesFromBits(Bits: Integer): SmallInt;
    procedure Output(Value: Integer); virtual;
    procedure Clear; virtual;
    function BumpPixel: boolean;
    procedure DoCompress; virtual; abstract;
  public
    procedure Compress(AStream: TStream; ABitsPerPixel: Integer; AWidth,
      AHeight: Integer; AInterlace: boolean; AData: PAnsiChar; AMaxColor: Integer);
  end;

function TAbstractGIFEncoder.MaxCodesFromBits(Bits: Integer): SmallInt;
begin
  Result := (SmallInt(1) shl Bits) - 1;
end;

procedure TAbstractGIFEncoder.Output(Value: Integer);
const
  BitBucketMask: array[0..16] of Integer = ($0000, $0001, $0003, $0007, $000F,
    $001F, $003F, $007F, $00FF, $01FF, $03FF, $07FF, $0FFF, $1FFF, $3FFF,
    $7FFF, $FFFF);
begin
  if (OutputBits > 0) then
  begin
    OutputBucket := (OutputBucket and BitBucketMask[OutputBits]) or
      (Integer(Value) shl OutputBits)
  end else
    OutputBucket := Value;
  Inc(OutputBits, BitsPerCode);
  while (OutputBits >= 8) do
  begin
    GIFStream.WriteByte(OutputBucket and $FF);
    OutputBucket := OutputBucket shr 8;
    dec(OutputBits, 8);
  end;
  if (Value = EOFCode) then
  begin
    while (OutputBits > 0) do
    begin
      GIFStream.WriteByte(OutputBucket and $FF);
      OutputBucket := OutputBucket shr 8;
      dec(OutputBits, 8);
    end;
  end;
end;

procedure TAbstractGIFEncoder.Clear;
begin
  ClearFlag := TRUE;
  Output(ClearCode);
end;

function TAbstractGIFEncoder.BumpPixel: Boolean;
begin
  Dec(cX);
  Result := cX > 0;
end;

procedure TAbstractGIFEncoder.Compress(AStream: TStream; ABitsPerPixel: Integer;
  AWidth, AHeight: Integer; AInterlace: boolean; AData: PAnsiChar; AMaxColor: Integer);
var
  B: Byte;
begin
  MaxColor := AMaxColor;
  Stream := AStream;
  BitsPerPixel := ABitsPerPixel;
  Width := AWidth;
  Height := AHeight;
  Interlace := AInterlace;
  Data := AData;
  if (BitsPerPixel <= 1) then BitsPerPixel := 2;
  InitialBitsPerCode := BitsPerPixel + 1;
  Stream.Write(BitsPerPixel, 1);
  BitsPerCode := InitialBitsPerCode;
  MaxCode := MaxCodesFromBits(BitsPerCode);
  ClearCode := (1 shl (InitialBitsPerCode - 1));
  EOFCode := ClearCode + 1;
  BaseCode := EOFCode + 1;
  OutputBucket := 0;
  OutputBits  := 0;
  if (Interlace) then cX := Width else cX := Width * Height;
  Y := 0;
  GIFStream := TGIFStream.Create(AStream);
  try
    if (Data <> nil) and (Height > 0) and (Width > 0) then
    begin
      DoCompress;
      Output(EOFCode);
    end else
      TAbstractGIFEncoder(self).Output(EOFCode);
  finally
    GIFStream.Free;
  end;
  B := 0;
  Stream.Write(B, 1);
end;

const
  TableMaxMaxCode = 4096;
  TableMaxFill = 4095;

type
  TGIFEncoder = class(TAbstractGIFEncoder)
  private
    Prefix  : SmallInt;
    FreeEntry  : SmallInt;
    HashTable  : THashTable;
  protected
    procedure Output(Value: Integer); override;
    procedure Clear; override;
    procedure DoCompress; override;
  end;

procedure TGIFEncoder.Output(Value: Integer);
begin
  inherited Output(Value);

  if (FreeEntry > MaxCode) or (ClearFlag) then
  begin
    if (ClearFlag) then
    begin
      BitsPerCode := InitialBitsPerCode;
      MaxCode := MaxCodesFromBits(BitsPerCode);
      ClearFlag := False;
    end else
    begin
      Inc(BitsPerCode);
      if (BitsPerCode = GIFCodeBits) then
        MaxCode := TableMaxMaxCode
      else
        MaxCode := MaxCodesFromBits(BitsPerCode);
    end;
  end;
end;

procedure TGIFEncoder.Clear;
begin
  inherited Clear;
  HashTable.Clear;
  FreeEntry := ClearCode + 2;
end;

procedure TGIFEncoder.DoCompress;
var
  Color: AnsiChar;
  NewKey: Integer;
  NewCode: SmallInt;
begin
  HashTable := THashTable.Create;
  try
    Clear;
    Pixel := Data;
    Prefix := SmallInt(Pixel^);
    Inc(Pixel);
    while BumpPixel do
    begin
      Color := Pixel^;
      Inc(Pixel);
      NewKey := (Integer(Prefix) shl 8) or Ord(Color);
      NewCode := HashTable.Lookup(NewKey);
      if (NewCode >= 0) then
      begin
        Prefix := NewCode;
        Continue;
      end;
      Output(Prefix);
      Prefix := SmallInt(Color);
      if (FreeEntry < TableMaxFill) then
      begin
        HashTable.Insert(NewKey, FreeEntry);
        Inc(FreeEntry);
      end else
        Clear;
    end;
    Output(Prefix);
  finally
    HashTable.Free;
  end;
end;

{ TPDFGIFWriter }

procedure TPDFGIFWriter.Assign(ABitmap: TBitmap);
var
  CQ: TColorQuantizer;
begin
  if Assigned(FBitmap) then FBitmap.Free;
  ABitmap.PixelFormat := pf24bit;
  CQ := TColorQuantizer.Create(256, 8);
  try
    FBitmap := CQ.ProcessImage(ABitmap);
  finally
    CQ.Free;
  end;
  FWidth := FBitmap.Width;
  FHeight := FBitmap.Height;
  GetPaletteEntries(FBitmap.Palette, 0, 256, FPalette);
end;

destructor TPDFGIFWriter.Destroy;
begin
  if Assigned(FBitmap) then FBitmap.Free;
  inherited;
end;

procedure TPDFGIFWriter.SaveToFile(const FileName: WideString);
var
  FS: TQuickPDFWideFileStream;
begin
  FS := QPLCreateFileStream(FileName, fmCreate);
  try
    SaveToStream(FS);
  finally
    FS.Free;
  end;
end;

procedure TPDFGIFWriter.SaveToStream(Stream: TStream);
var
  GE: TAbstractGIFEncoder;
  S: AnsiString;
  X: Integer;
begin
  S := 'GIF87a';
  S := S + AnsiChar(FWidth and $FF) + AnsiChar((FWidth and $FF00) shr 8);
  S := S + AnsiChar(FHeight and $FF) + AnsiChar((FHeight and $FF00) shr 8);
  S := S + AnsiChar(112) + AnsiChar(0) + AnsiChar(0);
  S := S + #$2C#0#0#0#0;
  S := S + AnsiChar(FWidth and $FF) + AnsiChar((FWidth and $FF00) shr 8);
  S := S + AnsiChar(FHeight and $FF) + AnsiChar((FHeight and $FF00) shr 8);
  S := S + AnsiChar(135);
  for X := 0 to 255 do
    S := S + AnsiChar(FPalette[X].peRed) + AnsiChar(FPalette[X].peGreen) +
      AnsiChar(FPalette[X].peBlue);
  Stream.Write(S[1], Length(S));
  SetLength(S, FWidth * FHeight);
  for X := 0 to FBitmap.Height - 1 do
    Move(FBitmap.ScanLine[X]^, S[X * FBitmap.Width + 1], FBitmap.Width);
  GE := TGIFEncoder.Create;
  try
    GE.Compress(Stream, 8, FWidth, FHeight, False, @S[1], 255);
  finally
    GE.Free;
  end;
  S := #$3B;
  Stream.Write(S[1], Length(S));
end;

{$ENDIF}

end.
