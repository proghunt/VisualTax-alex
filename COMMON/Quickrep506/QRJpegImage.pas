unit QRJpegImage;

interface
uses quickrpt, DB, vcl.graphics, Windows, classes, jpeg, controls;


type
  TQRDBJPGImage = class(TQRPrintable)
  private
    FField : TField;
    FDataSet : TDataSet;
    FDataField : string;
    FPicture: TPicture;
    FStretch: boolean;
    FCenter: boolean;
    FImageOffset : integer;
    FPictureLoaded: boolean;
    procedure PictureChanged(Sender: TObject);
    procedure SetCenter(Value: Boolean);
    procedure SetDataField(const Value: string);
    procedure SetDataSet(Value: TDataSet);
    procedure SetPicture(Value: TPicture);
    procedure SetStretch(Value: Boolean);
  protected
    function GetPalette: HPALETTE; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Prepare; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure UnPrepare; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetExpandedHeight(var newheight : extended ); override;
    procedure GetFieldString( var DataStr : string); override;
    procedure LoadPicture;
    property Field: TField read FField;
    property Picture: TPicture read FPicture write SetPicture;
  published
    property Center: boolean read FCenter write SetCenter default True;
    property DataField: string read FDataField write SetDataField;
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property Stretch: boolean read FStretch write SetStretch default False;
    property ImageOffset: integer read FImageOffset write FImageOffset default 0;

  end;

  //procedure register;

implementation
uses qrprntr, forms, qrctrls;

 {
  procedure register;
  begin
    registercomponents('QReport',[TQRDBJPGImage]);
  end;
}
{ TQRDBJPGImage }

constructor TQRDBJPGImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csFramed, csOpaque];
  Width := 105;
  Height := 105;
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FCenter := True;
end;

destructor TQRDBJPGImage.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

procedure TQRDBJPGImage.Prepare;
begin
  inherited Prepare;
  if assigned(FDataSet) then
  begin
    FField := DataSet.FindField(FDataField);
    if Field is TBlobField then
    begin
      Caption := '';
    end;
  end else
    FField := nil;
end;

// return value in screen pixels
procedure TQRDBJPGImage.GetExpandedHeight(var newheight : extended );
var
  DrawPict: TJpegImage;
begin
    newheight := self.Height; // default in case of failure.
    DrawPict := TJpegImage.Create;
    try
      if assigned(FField) and (FField is TBlobField) then
      begin
        DrawPict.Assign(FField);
        newheight := DrawPict.Height;
      end
    finally
       drawpict.free;
    end;
end;

procedure TQRDBJPGImage.GetFieldString( var DataStr : string);
begin
end;

procedure TQRDBJPGImage.Print(OfsX, OfsY : integer);
var
  Dest: TRect;
  DrawPict: TJpegImage;
  expimg : TQRImage;
  expbmp : vcl.graphics.TBitmap;
  tmpstr : TMemoryStream;
begin
  with QRPrinter.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    DrawPict := TJpegImage.Create;
    tmpstr := TMemoryStream.Create;
    try
      if assigned(FField) and (FField is TBlobField) then
      begin
        TBlobfield(FField).SaveToStream(tmpstr);
        tmpstr.Position := FImageOffset;
        drawpict.LoadFromStream(tmpstr);
        //DrawPict.Assign(FField);
        Dest.Left := QRPrinter.XPos(OfsX + Size.Left);
        Dest.Top := QRPrinter.YPos(OfsY + Size.Top);
        Dest.Right := QRPrinter.XPos(OfsX + Size.Width + Size.Left);
        Dest.Bottom := QRPrinter.YPos(OfsY + Size.Height + Size.Top);
        if Stretch then
        begin
          if (DrawPict = nil) or DrawPict.Empty then
            FillRect(Dest)
          else
            with QRPrinter.Canvas do
              StretchDraw(Dest, DrawPict);
        end else
        begin
          IntersectClipRect(Handle, Dest.Left, Dest.Top, Dest.Right, Dest.Bottom);
          Dest.Right := Dest.Left +
            round(DrawPict.Width / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.XFactor);
          Dest.Bottom := Dest.Top +
            round(DrawPict.Height / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.YFactor);
          if Center then OffsetRect(Dest,
            (QRPrinter.XSize(Size.Width) -
              round(DrawPict.Width / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.XFactor)) div 2,
            (QRPrinter.YSize(Size.Height) -
              round(DrawPict.Height / Screen.PixelsPerInch * 254 * ParentReport.QRPrinter.YFactor)) div 2);
          QRPrinter.Canvas.StretchDraw(Dest, DrawPict);
          SelectClipRgn(Handle, 0);
        end;
      end;
    finally
    end;
  end;
  if parentreport.Exporting then
  begin
         expimg := TQRImage.Create(parentreport);
         expimg.Size.Height :=   self.Size.Height;
         expimg.Size.Width :=   self.Size.Width;
         expimg.Size.Left :=   self.Size.left;
         expimg.Size.Top :=   self.Size.top;
         expbmp := vcl.graphics.TBitmap.Create;
         expbmp.Width := drawpict.Width;
         expbmp.height := drawpict.height;
         expbmp.Canvas.Draw(0,0,drawpict);
         expimg.Picture.Bitmap.Assign(expbmp);

         TQRExportFilter(ParentReport.ExportFilter).acceptgraphic(
                              qrprinter.XPos(OfsX + expimg.Size.Left),
                              qrprinter.YPos(OfsY+ expimg.size.top ), expimg );
         expimg.Free;
         expbmp.Free;
  end;
  DrawPict.Free;
  tmpstr.Free;
  inherited Print(OfsX,OfsY);
end;

procedure TQRDBJPGImage.UnPrepare;
begin
  FField := nil;
  inherited UnPrepare;
end;

procedure TQRDBJPGImage.SetDataSet(Value: TDataSet);
begin
  FDataSet := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

procedure TQRDBJPGImage.SetDataField(const Value: string);
begin
  FDataField := Value;
end;

function TQRDBJPGImage.GetPalette: HPALETTE;
begin
  Result := 0;
end;

procedure TQRDBJPGImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

procedure TQRDBJPGImage.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TQRDBJPGImage.SetStretch(Value: Boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

procedure TQRDBJPGImage.Paint;
var
  W, H: Integer;
  R: TRect;
  S: string;
begin
  with Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    Font := Self.Font;
    if Field <> nil then
      S := Field.DisplayLabel
    else S := Name;
    S := '(' + S + ')';
    W := TextWidth(S);
    H := TextHeight(S);
    R := ClientRect;
    TextRect(R, (R.Right - W) div 2, (R.Bottom - H) div 2, S);
  end;
  Inherited Paint;
end;

procedure TQRDBJPGImage.PictureChanged(Sender: TObject);
begin
  FPictureLoaded := True;
  Invalidate;
end;

procedure TQRDBJPGImage.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = DataSet) then
    DataSet := nil;
end;

procedure TQRDBJPGImage.LoadPicture;
begin
  if not FPictureLoaded and (Field is TBlobField) then
    Picture.Assign(FField);
end;


end.
