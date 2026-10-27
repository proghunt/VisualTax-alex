{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibrarySmartAccess.pas                        }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryImageList;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryMatrix, DebenuPDFLibraryStructure;

type
  TPDFImageListItemType = (nitUnknown, nitJPEG, nitBMP, nitTIFF, nitPNG);

  TPDFImageListItemCorner = (icTopLeft, icTopRight, icBottomLeft, icBottomRight);

  TPDFImageListItem = record
    ImageType: TPDFImageListItemType;
    PixelWidth: Integer;
    PixelHeight: Integer;
    BitsPerPixel: Integer;
    ColorSpaceType: Integer;
    ImageData: AnsiString;
    Corners: array[TPDFImageListItemCorner] of TPDFDoublePoint;
    ImageRef: TPDFIndRef;
    ImageID: Integer;
    FormatDesc0: AnsiString;
    FormatDesc1: AnsiString;
  end;

  TPDFImageList = class
  private
    FImages: array of TPDFImageListItem;
  public
    procedure AddImage(Item: TPDFImageListItem);
    function ImageCount: Integer;
    function ImagePixelWidth(ImageIndex: Integer): Integer;
    function ImagePixelHeight(ImageIndex: Integer): Integer;
    function ImageBitsPerPixel(ImageIndex: Integer): Integer;
    function ImageColorSpaceType(ImageIndex: Integer): Integer;
    function ImageType(ImageIndex: Integer): TPDFImageListItemType;
    function ImageData(ImageIndex: Integer): AnsiString;
    function ImageCorner(ImageIndex: Integer; Corner: TPDFImageListItemCorner; Horizontal: Boolean): Double;
    function ImageRef(ImageIndex: Integer): TPDFIndRef;
    function ImageID(ImageIndex: Integer): Integer;
    function FormatDesc(ImageIndex, Options: Integer): AnsiString;
    procedure SetImageID(ImageIndex, ImageID: Integer);
  end;

implementation

uses
  DebenuPDFLibraryExtra;

{ TPDFImageList }

procedure TPDFImageList.AddImage(Item: TPDFImageListItem);
begin
  SetLength(FImages, Length(FImages) + 1);
  Item.ImageID := -1;
  FImages[Length(FImages) - 1] := Item;
end;

function TPDFImageList.ImageCount: Integer;
begin
  Result := Length(FImages);
end;

function TPDFImageList.ImageData(ImageIndex: Integer): AnsiString;
var
  YPixPerM, XPixPerM: Integer;
  W, H: Double;
  X1, X2: Double;
  Y1, Y2: Double;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].ImageData;

    if ((FImages[ImageIndex - 1].ImageType = nitBMP) and (QPLCopy(Result, 1, 2) = 'BM')) then
    begin
      X1 := FImages[ImageIndex - 1].Corners[icTopRight].X;
      Y1 := FImages[ImageIndex - 1].Corners[icTopRight].Y;
      X2 := FImages[ImageIndex - 1].Corners[icTopLeft].X;
      Y2 := FImages[ImageIndex - 1].Corners[icTopLeft].Y;
      W := Sqrt((X1 - X2) * (X1 - X2) + (Y1 - Y2) * (Y1 - Y2));

      X1 := FImages[ImageIndex - 1].Corners[icTopLeft].X;
      Y1 := FImages[ImageIndex - 1].Corners[icTopLeft].Y;
      X2 := FImages[ImageIndex - 1].Corners[icBottomLeft].X;
      Y2 := FImages[ImageIndex - 1].Corners[icBottomLeft].Y;
      H := Sqrt((X1 - X2) * (X1 - X2) + (Y1 - Y2) * (Y1 - Y2));

      XPixPerM := Round(FImages[ImageIndex - 1].PixelWidth / (W / 72.0) * 1000 / 25.4);
      YPixPerM := Round(FImages[ImageIndex - 1].PixelHeight / (H / 72.0) * 1000 / 25.4);

      if (XPixPerM <> 0) and (YPixPerM <> 0) then
      begin
        Move(XPixPerM, Result[$26 + 1], Sizeof(Integer));
        Move(YPixPerM, Result[$2A + 1], Sizeof(Integer));
      end;
    end;

  end else
    Result := '';
end;

function TPDFImageList.FormatDesc(ImageIndex, Options: Integer): AnsiString;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    if (Options = 1) then
    begin
      Result := FImages[ImageIndex - 1].FormatDesc1;
    end else
    begin
      Result := FImages[ImageIndex - 1].FormatDesc0;
    end;
  end else
    Result := '';
end;

function TPDFImageList.ImageID(ImageIndex: Integer): Integer;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].ImageID;
  end else
    Result := 0;
end;

function TPDFImageList.ImageBitsPerPixel(ImageIndex: Integer): Integer;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].BitsPerPixel;
  end else
    Result := 0;
end;


function TPDFImageList.ImageColorSpaceType(ImageIndex: Integer): Integer;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].ColorSpaceType;
  end else
    Result := 0;
end;

function TPDFImageList.ImagePixelHeight(ImageIndex: Integer): Integer;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].PixelHeight;
  end else
    Result := 0;
end;

function TPDFImageList.ImageType(ImageIndex: Integer): TPDFImageListItemType;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].ImageType;
  end else
    Result := nitUnknown;
end;

procedure TPDFImageList.SetImageID(ImageIndex, ImageID: Integer);
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    FImages[ImageIndex - 1].ImageID := ImageID;
  end;
end;

function TPDFImageList.ImagePixelWidth(ImageIndex: Integer): Integer;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].PixelWidth;
  end else
    Result := 0;
end;

function TPDFImageList.ImageRef(ImageIndex: Integer): TPDFIndRef;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    Result := FImages[ImageIndex - 1].ImageRef;
  end else
    Result := nil;
end;

function TPDFImageList.ImageCorner(ImageIndex: Integer;
  Corner: TPDFImageListItemCorner; Horizontal: Boolean): Double;
begin
  if (ImageIndex >= 1) and (ImageIndex <= Length(FImages)) then
  begin
    if Horizontal then
      Result := FImages[ImageIndex - 1].Corners[Corner].X
    else
      Result := FImages[ImageIndex - 1].Corners[Corner].Y;    
  end else
    Result := 0;
end;

end.
