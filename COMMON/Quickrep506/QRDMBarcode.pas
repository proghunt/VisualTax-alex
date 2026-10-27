unit QRDMBarcode;
////////////////////////////////////////////////////////////////////////////
//  Unit : QRDMBarcode.pas
//
//  (c) 2012 QBS Software
////////////////////////////////////////////////////////////////////////////

interface
uses messages, windows, classes, controls, stdctrls, sysutils, graphics, 
     forms, extctrls, ComCtrls, RichEdit, QRPrntr, Quickrpt, QR5Const, qrexpr,
     qrctrls, qrlabled, DB, ECC200Consts;
type

  TQRDMBarcode = class(TQRPrintable)
  private
    FPicture: TPicture;
    //FAutoSize: Boolean;
    FMatrixRows : TMatrixsize;
    FText : string;
    FGS1 : Boolean;
    FFNCChar : char;
    FQuietZone : boolean;
    function GetCanvas: TCanvas;
    procedure PictureChanged(Sender: TObject);
    procedure SetMatrixrows( value : TMatrixsize);
  protected
    //procedure SetAutoSize(Value: Boolean);override;
    procedure SetQuietZone(Value: Boolean);
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas;
  published
    //property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Text: string read FText write FText;
    // GS1 support in text encoding
    property MatrixRows: TMatrixsize read FMatrixRows write setMatrixRows ;
    property FNCChar : char read FFNCChar write FFNCChar;
    property GS1 : Boolean read FGS1 write FGS1;
    property QuietZone : Boolean read FQuietZone write SetQuietZone;
    //property OnPrint;
 end;

  TQRDbDMBarcode = class(TQRCustomLabel)
  private
    //ComboBox : TEdit;
    //FAutoSize: Boolean;
    Field : TField;
    FieldNo : integer;
    FieldOK : boolean;
    DataSourceName : string[30];
    FDataSet : TDataSet;
    FDataField : string;
    FMask : string;
    IsMemo : boolean;
    FMatrixRows : TMatrixsize;
    FText : string;
    FGS1 : Boolean;
    FFNCChar : char;
    FQuietZone : boolean;
    procedure SetMatrixrows( value : TMatrixsize);
    procedure SetDataSet(Value : TDataSet);
    procedure SetDataField(Value : string);
    procedure SetMask(Value : string);
    procedure SetQuietZone(Value: Boolean);
  protected
    procedure SetAutoSize(Value: Boolean); override;
    procedure Paint; override;
    function GetCaptionBased : boolean;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Prepare; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure UnPrepare; override;
  public
    constructor Create(AOwner : TComponent); override;
    function UseRightToLeftAlignment: boolean; override;
    procedure GetExpandedHeight(var newheight : extended ); override;
    procedure GetFieldString( var DataStr : string); override;
  published
    property MatrixRows: TMatrixsize read FMatrixRows write setMatrixRows;
    property FNCChar : char read FFNCChar write FFNCChar;
    property GS1 : Boolean read FGS1 write FGS1;
    property QuietZone : Boolean read FQuietZone write SetQuietZone;
    property AutoSize;
    property DataSet : TDataSet read FDataSet write SetDataSet;
    property DataField : string read FDataField write SetDataField;
    property Mask : string read FMask write SetMask;
    property OnPrint;
end;


implementation
uses ECC200Procs, dialogs;

procedure GetCorrectedSize( var aw : integer;  nrows : integer; qz : boolean );
var
   mw : integer;
begin
    if qz then
    begin
        mw := aw div (nrows + 4);
        aw := mw*(nrows + 4);
    end
    else
    begin
        mw := aw div (nrows + 2);
        aw := mw*(nrows + 2);
    end
end;

constructor TQRDMBarcode.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  Height := 105;
  Width := 105;
  FMatrixrows := m10x10;
  FGS1 := false;
  FFNCChar := '[';
  FQuietzone := true;
end;

destructor TQRDMBarcode.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

procedure TQRDMBarcode.SetMatrixrows( value : TMatrixsize);
begin
   FMatrixrows := value;
   if csDesigning in ComponentState then
      invalidate;
end;

procedure TQRDMBarcode.Paint;
var
  Dest: TRect;
  nrows : integer;
begin
  if csDesigning in ComponentState then
  begin
    nrows := patterninfo[FMatrixrows].matrixdim;
    Dest := Rect(0, 0, Width, Height);
    PaintRandomBC( 0,0, nrows, dest, FQuietZone, inherited canvas );
    exit;
  end;
end;

procedure TQRDMBarcode.Print(OfsX,OfsY : Integer);
var
  dest : TRect;
  nrows, twidth : integer;
  tmpimg : TQRImage;
begin
    Dest.Top := QRPrinter.YPos(OfsY + Size.Top);
    Dest.Left := QRPrinter.XPos(OfsX + Size.Left);
    Dest.Right := QRPrinter.XPos(OfsX + Size.Width + Size.Left);
    Dest.Bottom := QRPrinter.YPos(OfsY + Size.Height + Size.Top);
    RenderBarcode( FText, FGS1, FFNCChar, Dest.Left, Dest.Top, FMatrixrows, dest, FQuietzone, qrprinter.canvas );

    if parentreport.Exporting then
    begin
         nrows := patternInfo[FMatrixrows].matrixdim;
         tmpimg := TQRImage.Create(self);
         tmpimg.Left := left;
         tmpimg.Top := top;
         if self.Width < self.Height then
               twidth := self.Width
         else
               twidth := self.Height;
         GetCorrectedSize( twidth, nrows, fquietzone);
         tmpimg.Width := twidth;
         tmpimg.Height := twidth;
         tmpimg.Picture.Bitmap.Width := twidth;
         tmpimg.Picture.Bitmap.Height := twidth;
         Dest.Top := 0;
         Dest.Left := 0;
         Dest.Right := tWidth;
         Dest.Bottom := tWidth;
         RenderBarcode( FText, FGS1, FFNCChar, Dest.Left, Dest.Top, FMatrixrows, dest, FQuietzone, tmpimg.Picture.Bitmap.canvas );
         ParentReport.ExportFilter.acceptgraphic( qrprinter.XPos(OfsX + self.Size.Left), qrprinter.YPos(OfsY + self.Size.Top), tmpimg );
         tmpimg.Free;
    end;
end;

function TQRDMBarcode.GetCanvas: TCanvas;
var
  Bitmap: TBitmap;
begin
  if FPicture.Graphic = nil then
  begin
    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      FPicture.Graphic := Bitmap;
    finally
      Bitmap.Free;
    end;
  end;
  if FPicture.Graphic is TBitmap then
    Result := TBitmap(FPicture.Graphic).Canvas
  else
    Result := nil;
{    raise EInvalidOperation.CreateRes(SImageCanvasNeedsBitmap)};
end;

procedure TQRDMBarcode.SetQuietZone(Value: Boolean);
begin
   FQuietZone := Value;
   if csDesigning in ComponentState then
      invalidate;
end;

{
procedure TQRDMBarcode.SetAutoSize(Value: Boolean);
begin
end;
}

procedure TQRDMBarcode.PictureChanged(Sender: TObject);
begin
end;

{TQRDbDMBarcode}
constructor TQRDbDMBarcode.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  DataSourceName := '';
  //ComboBox := nil;
  IsMemo := false;
  FMatrixrows := m10x10;
  FGS1 := false;
  FFNCChar := '[';
  FQuietzone := true;
  Autosize := false;
end;

procedure TQRDbDMBarcode.SetMatrixrows( value : TMatrixSize);
begin
   FMatrixrows := value;
   if csDesigning in ComponentState then
      invalidate;
end;

procedure TQRDbDMBarcode.SetQuietZone(Value: Boolean);
begin
   FQuietZone := Value;
   if csDesigning in ComponentState then
      invalidate;
end;

procedure TQRDbDMBarcode.GetExpandedHeight(var newheight : extended );
begin
end;

procedure TQRDbDMBarcode.GetFieldString( var DataStr : string);
begin
  if IsEnabled then
  begin
    if FieldOK then
    begin
      if FDataSet.DefaultFields then
        Field := FDataSet.Fields[FieldNo];
    end
    else
      Field := nil;
    if assigned(Field) then
    begin
      try
        if (Field is TMemoField) or
           (Field is TBlobField) then
        begin
          // caution : Lines is a property of self
          DataStr := TMemoField(Field).AsString;
        end
        else
          if (Mask = '') or (Field is TStringField) then
            if not (Field is TBlobField) then
              DataStr := Field.DisplayText
            else
              DataStr := Field.AsString
          else
          begin
            if (Field is TIntegerField) or
               (Field is TSmallIntField) or
               (Field is TWordField) then
               DataStr := FormatFloat(Mask, TIntegerField(Field).Value * 1.0)
            else if (Field is TBCDField) or
                 (Field is TFmtBCDField) then
                 DataStr := FormatFloat(Mask,TNumericField(Field).Value)
            else if (Field is TFloatField) or
                 (Field is TCurrencyField)then
                 DataStr := FormatFloat(Mask,TFloatField(Field).Value)
            else if (Field is TDateTimeField) or
                   (Field is TDateField) or
                   (Field is TTimeField) then
                  DataStr := FormatDateTime(Mask,TDateTimeField(Field).Value);
          end;
      except
        DataStr := '';
      end;
    end else
      DataStr := '';
  end;
end;

procedure TQRDbDMBarcode.SetDataSet(Value : TDataSet);
begin
  FDataSet := Value;
  if Value <> nil then
    Value.FreeNotification(self);
end;

function TQRDbDMBarcode.GetCaptionBased : boolean;
begin
  Result := true;
end;

procedure TQRDbDMBarcode.SetAutoSize(Value: Boolean);
begin
end;

procedure TQRDbDMBarcode.SetDataField(Value : string);
begin
  FDataField := Value;
  Caption := Value;
end;

procedure TQRDbDMBarcode.Loaded;
var
  aComponent : TComponent;
begin
  inherited Loaded;
  if DataSourceName<>'' then
  begin
    aComponent := Owner.FindComponent(string(DataSourceName));
    if (aComponent <> nil) and (aComponent is TDataSource) then
      DataSet:=TDataSource(aComponent).DataSet;
  end;
end;

procedure TQRDbDMBarcode.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
    if AComponent = FDataSet then
      FDataSet := nil;
end;

procedure TQRDbDMBarcode.SetMask(Value : string);
begin
  FMask := Value;
end;

procedure TQRDbDMBarcode.Prepare;
begin
  inherited Prepare;
  if assigned(FDataSet) then
  begin
    Field := FDataSet.FindField(FDataField);
    if Field <> nil then
    begin
      FieldNo := Field.Index;
      FieldOK := true;
      if (Field is TMemoField) or (Field is TBlobField) then
      begin
        FText := TMemoField(Field).AsString;
        IsMemo := false;
      end
        else IsMemo := false;
    end;
  end else
  begin
    Field := nil;
    FieldOK := false;
  end;
end;

procedure TQRDbDMBarcode.Print(OfsX, OfsY : integer);
var
  dest : TRect;
  nrows, twidth : integer;
  tmpimg : TQRImage;
begin
  if IsEnabled then
  begin
    if FieldOK then
    begin
      if FDataSet.DefaultFields then
        Field := FDataSet.Fields[FieldNo];
    end
    else
      Field := nil;
    if assigned(Field) then
    begin
      try
        if (Field is TMemoField) or
           (Field is TBlobField) then
        begin
          FText := TMemoField(Field).AsString;
        end else
          if (Mask = '') or (Field is TStringField) then
            if not (Field is TBlobField) then
              FText := Field.DisplayText
            else
              FText := Field.AsString
          else
          begin
            if (Field is TIntegerField) or
               (Field is TSmallIntField) or
               (Field is TWordField) then
                   FText := FormatFloat(Mask, TIntegerField(Field).Value * 1.0)
            else if (Field is TBCDField) or
                    (Field is TFMTBCDField) then
                       FText := FormatFloat(Mask,TNumericField(Field).Value)
            else if (Field is TFloatField) or
                 (Field is TCurrencyField) then
                    FText := FormatFloat(Mask,TFloatField(Field).Value)
            else if (Field is TDateTimeField) or
                   (Field is TDateField) or
                   (Field is TTimeField) then
                       FText := FormatDateTime(Mask,TDateTimeField(Field).Value);
          end;
      except
        FText := '';
      end;
    end else
      FText := '';

    Dest.Top := QRPrinter.YPos(OfsY + Size.Top);
    Dest.Left := QRPrinter.XPos(OfsX + Size.Left);
    Dest.Right := QRPrinter.XPos(OfsX + Size.Width + Size.Left);
    Dest.Bottom := QRPrinter.YPos(OfsY + Size.Height + Size.Top);
    RenderBarcode( FText, FGS1, FFNCChar, Dest.Left, Dest.Top, FMatrixrows, dest, FQuietzone, qrprinter.canvas );

    if parentreport.Exporting then
    begin
         nrows := patternInfo[FMatrixrows].matrixdim;
         tmpimg := TQRImage.Create(self);
         tmpimg.Left := left;
         tmpimg.Top := top;
         if self.Width < self.Height then
               twidth := self.Width
         else
               twidth := self.Height;
         GetCorrectedSize( twidth, nrows, fquietzone);
         tmpimg.Width := twidth;
         tmpimg.Height := twidth;
         tmpimg.Picture.Bitmap.Width := twidth;
         tmpimg.Picture.Bitmap.Height := twidth;
         Dest.Top := 0;
         Dest.Left := 0;
         Dest.Right := tWidth;
         Dest.Bottom := tWidth;
         RenderBarcode( FText, FGS1, FFNCChar, Dest.Left, Dest.Top, FMatrixrows, dest, FQuietzone, tmpimg.Picture.Bitmap.canvas );
         ParentReport.ExportFilter.acceptgraphic( qrprinter.XPos(OfsX + self.Size.Left), qrprinter.YPos(OfsY + self.Size.Top), tmpimg );
         tmpimg.Free;
    end;
  end;
end;

procedure TQRDbDMBarcode.UnPrepare;
begin
  Field := nil;
  inherited UnPrepare;
  if DataField <> '' then
    SetDataField(DataField) { Reset component caption }
  else
    SetDataField(Name);
end;

function TQRDbDMBarcode.UseRightToLeftAlignment: Boolean;
begin
  Result := false;
end;

procedure TQRDbDMBarcode.Paint;
var
  Dest: TRect;
  nrows : integer;
begin
  if csDesigning in ComponentState then
  begin
    Dest := Rect(0, 0, Width, Height);
    nrows := patternInfo[FMatrixrows].matrixdim;
    PaintRandomBC( 0,0, nrows, dest, FQuietZone, inherited canvas );
    exit;
  end;
end;




end.
