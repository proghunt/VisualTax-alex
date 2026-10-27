unit vtImplPDF;

interface

uses vtCommonPDF, System.Classes, DebenuPDFLibrary1114, uPDFUtils, SysUtils, Vcl.Dialogs;

type
  TvtImplPDF = class(TvtPDF)
  private
    FPDF: TDebenuPDFLibrary1114;
    FDPI: integer;
    FCurrDocument : Integer;
    FCurrPage: integer;
    //20210326 Igor >>>
    FOCGText: Integer;      // Optional content group to draw removable text
    FOCGImg: Integer;       // Optional content group to draw image
    FCStreamImg: Integer;   // Content stream to draw image
    //20210326 Igor <<<
    function CheckDocument: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function OpenFile(AFileName: string) : boolean; override;
    function SaveFile(AFileName: string) : boolean; override;
    function SelectedDocument : integer; override;
    function SelectDocument(ADocumentId: integer) : boolean; override;
    function CloseDocument(ADocumentId: integer) : boolean; override;
    procedure SetDPI(ADPI: integer); override;
    function PageCount: integer; override;
    function SelectedPage: integer; override;
    function SelectPage(APageNumber: integer): boolean; override;
    function AddImageFromFile(AImageFileName: string) : integer; override;
    function SelectImage(AImageId: integer): boolean; override;
    function DrawImage(ALeft, ATop, AWidth, AHeight: integer): boolean; override;
    function ClearImage(AImageId: integer): boolean; override;
    function RenderPageToStream(AMS: TMemoryStream) : boolean; override;
    //20210326 Igor >>>
    function DrawTextBox(ALeft, ATop, AWidth, AHeight: Double; const AText: WideString): Integer;  override;
    function ClearText(ATextStream: Integer): Boolean; override;
    //20210326 Igor <<<
  end;

implementation

{ TvtImplPDF }

function TvtImplPDF.AddImageFromFile(AImageFileName: string): integer;
begin
  Result := -1;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  Result := FPDF.AddImageFromFile(AImageFileName, 0);
end;

function TvtImplPDF.CheckDocument: boolean;
begin
  Result := Assigned(FPDF) and (FCurrDocument <> -1);
end;

function TvtImplPDF.ClearImage(AImageId: integer): boolean;
begin
  Result := false;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  if AImageId < 0 then
  begin
    ShowMessage('Image Id should be > 0!');
    exit;
  end;
  Result := FPDF.ClearImage(AImageId) = 1;
end;


function TvtImplPDF.ClearText(ATextStream: Integer): Boolean; //20210326 Igor
begin
  Result := False;
  if CheckDocument then
  begin
    if (FOCGText >= 0) and (FPDF.DeleteOptionalContentGroup(FOCGText) > 0) then
      FOCGText := -1;

    if ATextStream >= 0 then
    begin
      FPDF.SelectContentStream(ATextStream);
      Result := FPDF.DeleteContentStream > 0;
    end
    else
      ShowMessage('Content stream Id should be > 0!');
  end
  else
    ShowMessage('PDF document is not opened!');
end;

function TvtImplPDF.CloseDocument(ADocumentId: integer): boolean;
begin
  Result := false;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  if ADocumentId < 0 then
  begin
    ShowMessage('Document Id should be > 0!');
    exit;
  end;
  Result := FPDF.RemoveDocument(ADocumentId) = 1;
  //20210326 Igor >>>
  FOCGText := -1;
  FOCGImg := -1;
  FCStreamImg := -1;
  //20210326 Igor <<<
end;

constructor TvtImplPDF.Create;
begin
  FDPI := 72;
  FCurrDocument := -1;
  //20210326 Igor >>>
  FOCGText := -1;
  FOCGImg := -1;
  FCStreamImg := -1;
  //20210326 Igor <<<
  FPDF := TDebenuPDFLibrary1114.Create;
  if not TestDebenuLicense(FPDF) then
    FreeAndNil(FPDF);
end;

destructor TvtImplPDF.Destroy;
begin
  if Assigned(FPDF) then
    FreeAndNil(FPDF);
  inherited;
end;

function TvtImplPDF.DrawImage(ALeft, ATop, AWidth, AHeight: integer): boolean;
begin
  Result := False;
  if CheckDocument then
  begin
    if FOCGImg < 0 then
      FOCGImg := FPDF.NewOptionalContentGroup('OCG_Signature_Img');
    if FCStreamImg < 0 then
      FCStreamImg := FPDF.NewContentStream;
    FPDF.SelectContentStream(FCStreamImg);
    FPDF.SetContentStreamOptional(FOCGImg);
    Result := FPDF.DrawImage(ALeft, ATop, AWidth, AHeight) = 1;
    FPDF.SetOptionalContentGroupVisible(FOCGImg, 1);
  end
  else
    ShowMessage('PDF document is not opened!');
end;


function TvtImplPDF.DrawTextBox(ALeft, ATop, AWidth, AHeight: Double; //20210326 Igor
  const AText: WideString): Integer;
var
  _height, _width: Double;
begin
  Result := -1;
  if CheckDocument then
  begin
    if FOCGText < 0 then
      FOCGText := FPDF.NewOptionalContentGroup('OCG_Signature_Date');

    Result := FPDF.NewContentStream;

    if Result >= 0 then
      with FPDF do
      begin
        SelectContentStream(Result);
        SetContentStreamOptional(FOCGText);
        //20210329 Igor >>>
        _height := AHeight * 0.8;       // Text height must be about 20% smaller than box height
        SetTextSize(_height);
        _width := GetTextWidth(AText);
        if _width > AWidth * 0.995 then // Sometimes works wrong with scale 1.0
          _height := _height * (AWidth * 0.995 / _width);
        SetTextSize(_height);
        //20210329 Igor <<<
        DrawTextBox(ALeft, ATop, AWidth, AHeight, AText, 0);
        SetOptionalContentGroupVisible(FOCGText, 1);
      end;
  end
  else
    ShowMessage('PDF document is not opened!');
end;

function TvtImplPDF.OpenFile(AFileName: string): boolean;
begin
  Result := false;
  if not Assigned(FPDF) then
  begin
    ShowMessage('PDF module is not loaded!');
    exit;
  end;
  Result := FPDF.LoadFromFile(AFileName, '') = 1;
  if Result then
  begin
    FCurrDocument := FPDF.SelectedDocument;
    FCurrPage := FPDF.SelectedPage;
  end;
end;

function TvtImplPDF.PageCount: integer;
begin
  Result := -1;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  Result := FPDF.PageCount;
end;

function TvtImplPDF.RenderPageToStream(AMS: TMemoryStream): boolean;
begin
  Result := false;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  Result := FPDF.RenderPageToStream(FDPI, FPDF.SelectedPage, 0, AMS) = 1;
end;

function TvtImplPDF.SaveFile(AFileName: string): boolean;
begin
  Result := false;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  DeleteFile(AFileName);
  Result := FPDF.SaveToFile(AFileName) = 1;
end;

function TvtImplPDF.SelectDocument(ADocumentId: integer): boolean;
begin
  Result := false;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  if ADocumentId < 0 then
  begin
    ShowMessage('Document Id should be >= 0!');
    exit;
  end;
  Result := FPDF.SelectDocument(ADocumentId) = 1;
end;

function TvtImplPDF.SelectedDocument: integer;
begin
  Result := -1;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  Result := FPDF.SelectedDocument;
end;

function TvtImplPDF.SelectedPage: integer;
begin
  Result := -1;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  Result := FPDF.SelectedPage;
end;

function TvtImplPDF.SelectImage(AImageId: integer): boolean;
begin
  Result := false;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  Result := FPDF.SelectImage(AImageId) = 1;
end;

function TvtImplPDF.SelectPage(APageNumber: integer): boolean;
begin
  Result := false;
  if not CheckDocument then
  begin
    ShowMessage('PDF document is not opened!');
    exit;
  end;
  Result := FPDF.SelectPage(APageNumber) = 1;
end;

procedure TvtImplPDF.SetDPI(ADPI: integer);
begin
  inherited;
  FDPI := ADPI;
end;

end.
