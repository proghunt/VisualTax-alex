unit fSelectCloudFile;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADCompDataSet, uADCompClient;

type
  TfrmSelectCloudFile = class(TForm)
    pnlButtons: TPanel;
    Label1: TLabel;
    rbAll: TRadioButton;
    rbFiltered: TRadioButton;
    edFilter: TEdit;
    btnOk: TButton;
    Button2: TButton;
    DBGrid1: TDBGrid;
    dsFiles: TDataSource;
    qFiles: TADMemTable;
    qFilesFILE_NAME: TStringField;
    qFilesFOLDER: TStringField;
    qFilesNAME: TStringField;
    qFilesEXT: TStringField;
    qFilesSHARED: TStringField;
    procedure rbAllClick(Sender: TObject);
    procedure edFilterChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    FilterEnabled: boolean;
    procedure LoadFiles(AFiles: TStringList);
    procedure ApplyFilter;
  public
    { Public declarations }
  end;

  function SelectCloudFile(AFiles: TStringList; AFilter: string = ''): string;

implementation

{$R *.dfm}

function SelectCloudFile(AFiles: TStringList; AFilter: string = ''): string;
var
  frmSelectCloudFile: TfrmSelectCloudFile;
begin
  Result := '';
  frmSelectCloudFile := TfrmSelectCloudFile.Create(nil);
  try
    frmSelectCloudFile.LoadFiles(AFiles);
    frmSelectCloudFile.edFilter.Text := AFilter;
    if frmSelectCloudFile.ShowModal = mrOk then
      Result := frmSelectCloudFile.qFiles.FieldByName('FILE_NAME').AsString;
  finally
    frmSelectCloudFile.Free;
  end;
end;

{ TfrmSelectCloudFile }

procedure TfrmSelectCloudFile.ApplyFilter;
begin
  if not FilterEnabled then Exit;
  qFiles.DisableControls;
  try
    qFiles.Filtered := false;
    if rbAll.Checked or String(edFilter.Text).IsEmpty then
      qFiles.Filter := ''
    else
      qFiles.Filter := 'UPPER(FILE_NAME) LIKE '+ QuotedStr('%' + String(UpperCase(edFilter.Text)) + '%');
    qFiles.Filtered := true;
    btnOK.Enabled := qFiles.RecordCount > 0;
  finally
    qFiles.EnableControls;
  end;
end;

procedure TfrmSelectCloudFile.DBGrid1DblClick(Sender: TObject);
begin
  if btnOK.Enabled then
    btnOK.Click;
end;

procedure TfrmSelectCloudFile.edFilterChange(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TfrmSelectCloudFile.FormCreate(Sender: TObject);
begin
  FilterEnabled := false;
end;

procedure TfrmSelectCloudFile.FormShow(Sender: TObject);
begin
  FilterEnabled := true;
  ApplyFilter;
end;

procedure TfrmSelectCloudFile.LoadFiles(AFiles: TStringList);
var I: integer;
    cFileName, cExt: string;
begin
  qFiles.Close;
  qFiles.Open;
  qFiles.DisableControls;
  try
    for I := 0 to AFiles.Count - 1 do
    begin
      cFileName := AFiles.Strings[I];
      if cFileName.IsEmpty then Exit;
      qFiles.Append;
      qFiles.FieldByName('FILE_NAME').AsString := cFileName;
      if SameText(Copy(cFileName, 1, 1), '*') then
      begin
        cFileName := Copy(cFileName, 2, Length(cFileName));
        qFiles.FieldByName('SHARED').Value := 'Yes';
      end
      else
        qFiles.FieldByName('SHARED').Value := '';
      qFiles.FieldByName('FOLDER').AsString := ExtractFilePath(cFileName);
      cFileName := ExtractFileName(cFileName);
      cExt := ExtractFileExt(cFileName);
      qFiles.FieldByName('EXT').AsString := Copy(cExt, 2, Length(cExt));
      cFileName := ChangeFileExt(ExtractFileName(cFileName), '');
      qFiles.FieldByName('NAME').AsString := cFileName;
      qFiles.Post;
    end;
    qFiles.First;
  finally
    qFiles.EnableControls;
  end;
  btnOk.Enabled := qFiles.RecordCount > 0;
end;

procedure TfrmSelectCloudFile.rbAllClick(Sender: TObject);
begin
  ApplyFilter;
  edFilter.Enabled := rbFiltered.Checked;
end;

end.
