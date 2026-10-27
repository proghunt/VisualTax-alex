unit vtReportBuilderExport;

interface

uses
  System.SysUtils, Vcl.Grids, System.Generics.Collections,
  System.Classes, vtPDFPrinter;

type
  TExportWorkerAbstr = class abstract
  public
    class function ExporterCaption: String; virtual; abstract;
    class function FileExt: String; virtual; abstract;
  public
    class procedure ExportTo(AStringGrid: TStringGrid; ADefaultFolder, AFilters: String); virtual; abstract;
  end;

  TExportWorkerClass = class of TExportWorkerAbstr;

  TExportWorkers = TList<TExportWorkerClass>;

  TExportManager = class(TObject)
  private
    FExportWorkers: TExportWorkers;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ExportTo(AWorkerIndex: Integer; AStringGrid: TStringGrid; ADefaultFolder, AFilters: String);
    property ExportWorkers: TExportWorkers read FExportWorkers;
    procedure RegisterExportWorker(AWorkerExportClass: TExportWorkerClass);
    procedure RegisterExportWorkers(AWorkerExportClasses: array of TExportWorkerClass);
  end;

  TExportWorkerExcel = class(TExportWorkerAbstr)
  protected
  public
    class function ExporterCaption: String; override;
    class function FileExt: String; override;
  public
    class procedure ExportTo(AStringGrid: TStringGrid; ADefaultFolder, AFilters: String); override;
  end;

  TExportWorkerHTML = class(TExportWorkerAbstr)
  protected
  public
    class function ExporterCaption: String; override;
    class function FileExt: String; override;
  public
    class procedure ExportTo(AStringGrid: TStringGrid;  ADefaultFolder, AFilters: String); override;
  end;

  TExportWorkerXML = class(TExportWorkerAbstr)
  protected
  public
    class function ExporterCaption: String; override;
    class function FileExt: String; override;
  public
    class procedure ExportTo(AStringGrid: TStringGrid;  ADefaultFolder, AFilters: String); override;
  end;

  TExportWorkerPDF = class(TExportWorkerAbstr)
  protected
  public
    class function ExporterCaption: String; override;
    class function FileExt: String; override;
  public
    class procedure ExportTo(AStringGrid: TStringGrid;  ADefaultFolder, AFilters: String); override;
  end;

function ExportWorkerManager: TExportManager;

function MyDocument: string;

implementation

uses
  System.Win.ComObj, Winapi.ActiveX, Vcl.Dialogs,
  System.Variants, System.TypInfo, System.Rtti,
  Winapi.ShellAPI, Windows, XML.XMLDom, XML.XMLDoc, XML.XMLIntf,
  System.StrUtils, Winapi.ShlObj;

var
  FExportWorkerManager: TExportManager;
{ TExportManager }

function MyDocument: string;
var
  Allocator: IMalloc;
  SpecialDir: PItemIdList;
  FBuf: array[0..MAX_PATH] of Char;
  PerDir: string;
begin
  if SHGetMalloc(Allocator) = NOERROR then
  begin
    SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, SpecialDir);
    SHGetPathFromIDList(SpecialDir, @FBuf[0]);
    Allocator.Free(SpecialDir);
    Result := string(FBuf);
  end
  else
    Result := '';
end;

function GetExportFileName(const AFilterCaption, AExt, ADefaultFolder: string; var AFileName: String): Boolean;
begin
  with TSaveDialog.Create(nil) do
  begin
    try
      if ADefaultFolder <> '' then
        InitialDir := ADefaultFolder
      else
        InitialDir := MyDocument;
      FileName := 'VisualTaxReport_' + FormatDateTime('YYYYMMDD_hhnnss', now) + AExt;
      Filter := AFilterCaption + '|*' + AExt;
      if not execute then
        exit(False);
      AFileName := FileName;
      if not sametext(ExtractFileExt(AFileName), AExt) then
        AFileName := AFileName + AExt;
      Result := True;
    finally
      free;
    end;
  end;
end;

function ExportWorkerManager: TExportManager;
begin
  if not assigned(FExportWorkerManager) then
    FExportWorkerManager := TExportManager.Create;
  Result := FExportWorkerManager;
end;

constructor TExportManager.Create;
begin
  inherited Create;
  FExportWorkers := TExportWorkers.Create;
end;

destructor TExportManager.Destroy;
begin
  FreeAndNil(FExportWorkers);
  inherited;
end;

procedure TExportManager.ExportTo(AWorkerIndex: Integer;
  AStringGrid: TStringGrid; ADefaultFolder, AFilters: String);
begin
  if (AWorkerIndex < 0) or (AWorkerIndex >= FExportWorkers.Count) then
    raise Exception.Create('Index out of bounds');
  FExportWorkers[AWorkerIndex].ExportTo(AStringGrid, ADefaultFolder, AFilters);
end;

procedure TExportManager.RegisterExportWorker(
  AWorkerExportClass: TExportWorkerClass);
begin
  FExportWorkers.Add(AWorkerExportClass)
end;

procedure TExportManager.RegisterExportWorkers(
  AWorkerExportClasses: array of TExportWorkerClass);
var
  I: Integer;
begin
  for I := Low(AWorkerExportClasses) to High(AWorkerExportClasses) do
    RegisterExportWorker(AWorkerExportClasses[I]);
end;

{ TExportWorkerExcel }

class procedure TExportWorkerExcel.ExportTo(AStringGrid: TStringGrid;
   ADefaultFolder, AFilters: String);
function IsOLEObjectInstalled(Name: String): boolean;
  var
    ClassID: TCLSID;
  begin
    Result := CLSIDFromProgID(PWideChar(WideString(Name)), ClassID) = S_OK;
  end;

  function CheckExcelRun(AValue: String; var ADest: Variant): boolean;
  begin
    try
      ADest := GetActiveOleObject(AValue);
      Result := true;
    except
      Result := false;
    end;
  end;
var
  Excel, Workbook, WorkSheet, ArrayData, Cell1, Cell2, Range: Variant;
  I, J: Integer;
  lFileName, V, ext: string;
begin
  if not IsOLEObjectInstalled('Excel.Application') then
  begin
    MessageDlg('Excel not instaled!', mtError, [mbOk], 0);
    exit;
  end;
  if not CheckExcelRun('Excel.Application', Excel) then
    try
      Excel := CreateOleObject('Excel.Application');
    except ON E: Exception DO
      begin
        MessageDlg(E.Message, mtError, [mbOk], 0);
        exit;
      end
    end;
  try
    V :=  Excel.Application.Version;
    if Pos('.', V) > 0 then
      V := Copy(V, 1, Pos('.', V) - 1);
    if not TryStrToInt(V, I) or (I < 12) then {excel 2007 = 12}
      Ext := '.xls'
    else
      Ext := '.xlsx';

    if not GetExportFileName('Excel Files', ext, ADefaultFolder, lFileName) then
      exit;
    Excel.Visible := False;
    Excel.Application.EnableEvents := false;
    Workbook := Excel.Workbooks.Add;
    WorkSheet := Workbook.WorkSheets[1];

    ArrayData := VarArrayCreate([1, AStringGrid.RowCount, 1, AStringGrid.ColCount], varVariant);

    for I := 0 to AStringGrid.RowCount - 1 do
      for J := 0 to AStringGrid.ColCount - 1 do
        ArrayData[I + 1, J + 1] := AStringGrid.Cells[J, I];
    Cell1 := WorkSheet.Cells[3, 1];
    Cell2 := WorkSheet.Cells[AStringGrid.RowCount + 2, AStringGrid.ColCount]; //20180424 Igor
    Range := WorkSheet.Range[Cell1, Cell2];
    Range.Value := ArrayData;
    Range.Borders.LineStyle := 1;

    Cell1 := WorkSheet.Cells[3, 1];
    Cell2 := WorkSheet.Cells[3, AStringGrid.ColCount];
    Range := WorkSheet.Range[Cell1, Cell2];
    Range.Font.Bold := True;
    Range.VerticalAlignment := 2;
    Range.HorizontalAlignment := 3;
    Range.EntireColumn.AutoFit;
    WorkSheet.Cells[1, 1].Value := 'Created: ' + FormatDateTime('YYYY-MM-DD hh:nn:ss', now);
    WorkSheet.Cells[2, 1].Value := 'Filters: ' + AFilters;
    Workbook.SaveAs(lFileName);
  finally
    if not VarIsEmpty(Excel) then
    begin
      Excel.Application.EnableEvents := true;
      Excel.DisplayAlerts := true;
      Excel.Visible := true;
      Workbook := Unassigned;
      WorkSheet := Unassigned;
      Excel := Unassigned;
    end;
  end;
end;

class function TExportWorkerExcel.FileExt: String;
begin
  Result := '*.xls;*.xlsx';
end;

class function TExportWorkerExcel.ExporterCaption: String;
begin
  Result := 'Export to Excel';
end;

{ TExportWorkerHTML }

function HTMLEscape(const Str: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(Str) to High(Str) do
  begin
    case Str[i]  of
    '<' : Result := Result + '&lt;';    { Do not localize }
    '>' : Result := Result + '&gt;';    { Do not localize }
    '&' : Result := Result + '&amp;';   { Do not localize }
    '"' : Result := Result + '&quot;';  { Do not localize }
{$IFNDEF UNICODE}
    #92, Char(160) .. #255 : Result := Result + '&#' + IntToStr(Ord(Str[ i ])) +';';  { Do not localize }
{$ELSE}
    // NOTE: Not very efficient
    #$0080..#$FFFF : Result := Result + '&#' + IntToStr(Ord(Str[ i ])) +';'; { Do not localize }
{$ENDIF}
    else
      Result := Result + Str[i];
    end;
  end;
end;

class procedure TExportWorkerHTML.ExportTo(AStringGrid: TStringGrid;
   ADefaultFolder, AFilters: String);
var
  SL: TStringList;
  lFileName: string;
  procedure AddHeader;
  begin
    SL.Add('<!DOCTYPE html>'+#13+
           '<html>'+#13+
             '<head>'+#13+
               '<meta charset="utf-8">'+#13+
               '<title>VisualTax report</title>'+#13+
             '</head>'+#13+
             '<body>'+#13+
               '<p><b>Created:&nbsp;</b>'+HTMLEscape(FormatDateTime('YYYY-MM-DD hh:nn:ss', Now))+'</p>'+#13+
               '<p><b>Filters:&nbsp;</b>'+HTMLEscape(AFilters)+'</p>');
  end;
  procedure AddFooter;
  begin
    SL.Add(  '</body>'+#13+
           '</html>');
  end;
  procedure StartTable;
  begin
    SL.Add(    '<table border="1" bordercolor="#000000" cellspacing="0" cellpadding="0">');
  end;
  procedure EndTable;
  begin
    SL.Add(    '</table>');
  end;
  procedure AddColGroup;
  var
    I: Integer;
  begin
    SL.Add('<colgroup>');
    for I := 0 to AStringGrid.ColCount - 1 do
      SL.Add('<col width="'+IntToStr(AStringGrid.ColWidths[I])+'px"></col>');
    SL.Add('</colgroup>');
  end;
  procedure AddTableHead;
  var
    I: Integer;
  begin
    SL.Add('<thead>'+#13+
             '<tr>');
    for I := 0 to AStringGrid.ColCount - 1 do
      SL.Add('<th>'+HTMLEscape(AStringGrid.Cells[I,0])+'</th>');
    SL.Add(  '</tr>'+#13+
           '</thead>');
  end;

  function Cell(ACol, ARow: Integer): String;
  begin
    Result := '<td>' + HTMLEscape(AStringGrid.Cells[ACol, ARow]) + '</td>';
  end;

  function Row(ARow: Integer): String;
  var
    I: Integer;
  begin
    Result := '<tr>';
    for I := 0 to AStringGrid.ColCount - 1 do
      Result := Result + Cell(I, ARow);
    Result := Result + '</tr>';
  end;

  procedure AddTableData;
  var
    I: Integer;
  begin
    SL.Add('<tbody>'+#13+
             '<tr>');
    for I := 1 to AStringGrid.RowCount - 1 do
      SL.Add(Row(I));
    SL.Add(  '</tr>'+#13+
           '</tbody>');
  end;

//  procedure AddTableFooter;
//  var
//    I: Integer;
//  begin
//    SL.Add('<tfoot>'+#13+
//             '<tr>');
//    for I := 0 to AStringGrid.ColCount - 1 do
//      SL.Add('<td>'+AStringGrid.Cells[I,AStringGrid.RowCount - 1]+'</td>');
//    SL.Add(  '</tr>'+#13+
//           '</tfoot>');
//  end;
begin
  if not GetExportFileName('HTML Files', '.html', ADefaultFolder, lFileName) then
    exit;

  SL := TStringList.Create;
  try
    AddHeader;
    StartTable;
      AddColGroup;
      AddTableHead;
      AddTableData;
      //AddTableFooter;
    EndTable;
    AddFooter;

    SL.SaveToFile(lFileName);
    ShellExecute(0, PWideChar('open'), PWideChar(lFileName), nil,
                 PWideChar(ExtractFileDir(lFileName)), SW_NORMAL)
  finally
    SL.Free;
  end;
end;

class function TExportWorkerHTML.ExporterCaption: String;
begin
  Result := 'Export to HTML';
end;

class function TExportWorkerHTML.FileExt: String;
begin
  Result := '*.html';
end;

{ TExportWorkerXML }

class function TExportWorkerXML.ExporterCaption: String;
begin
  Result := 'Export to XML';
end;

class function TExportWorkerXML.FileExt: String;
begin
  Result := '*.xml';
end;

class procedure TExportWorkerXML.ExportTo(AStringGrid: TStringGrid;
   ADefaultFolder, AFilters: String);
var
  X: IXMLDocument;
  Root, Table, N, Row: IXMLNode;
  ICol, IRow: Integer;
  SL: TStringList;
  lFileName: string;
begin
  if not GetExportFileName('XML Files', '.xml', ADefaultFolder, lFileName) then
    exit;
  X := NewXMLDocument;
  X.Encoding := 'utf-8';
  Root := X.AddChild('VTReport');
  Table := Root.AddChild('Table');
  Table.AddChild('Created').NodeValue := Now;
  Table.AddChild('Filters').NodeValue := AFilters;
  N := Table.AddChild('Header');
  for ICol := 0 to AStringGrid.ColCount - 1 do
    N.AddChild('Col' + IntToStr(ICol)).NodeValue := AStringGrid.Cells[ICol, 0];

  N := Table.AddChild('Data');
  for IRow := 1 to AStringGrid.RowCount - 1 do
  begin
    Row := N.AddChild('Row');
    for ICol := 0 to AStringGrid.ColCount - 1 do
      Row.AddChild('Col' + IntToStr(ICol)).NodeValue := AStringGrid.Cells[ICol, IRow];
  end;
  X.SaveToFile(lFileName);
  ShellExecute(0, PWideChar('open'), PWideChar(lFileName), nil,
               PWideChar(ExtractFileDir(lFileName)), SW_NORMAL);

end;


{ TExportWorkerPDF }

class function TExportWorkerPDF.ExporterCaption: String;
begin
  Result := 'Export to PDF';
end;

class function TExportWorkerPDF.FileExt: String;
begin
  Result := '*.pdf'
end;

class procedure TExportWorkerPDF.ExportTo(AStringGrid: TStringGrid;
   ADefaultFolder, AFilters: String);
var
  lFileName: string;
begin
  if not GetExportFileName('PDF Files', '.pdf', ADefaultFolder, lFileName) then
    exit;
  with TvtPDFPrinter.Create(nil) do
  begin
    try
      PrintStringGrid('VisualTax report', '', ['Created: ' + FormatDateTime('YYYY-MM-DD hh:nn:ss', Now),
                                               'Filters: ' + AFilters],
                      AStringGrid, True, lFileName);
    finally
      free;
    end;
  end;
end;

initialization
  ExportWorkerManager.RegisterExportWorkers([
    TExportWorkerExcel,
    TExportWorkerPDF,
    TExportWorkerHTML,
    TExportWorkerXML]);

finalization
  FreeAndNil(FExportWorkerManager);
end.
