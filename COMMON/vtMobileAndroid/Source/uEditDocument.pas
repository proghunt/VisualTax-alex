unit uEditDocument;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DB, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, ShellAPI, System.UITypes;

type
  TfrmEditDocument = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    chbDocumentLoaded: TCheckBox;
    edID: TEdit;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label5: TLabel;
    edName: TEdit;
    btnLoadFile: TBitBtn;
    cbType: TComboBox;
    cbFormat: TComboBox;
    dlgOpen: TOpenDialog;
    lblFileSource: TLabel;
    procedure btnLoadFileClick(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lblFileSourceMouseEnter(Sender: TObject);
    procedure lblFileSourceMouseLeave(Sender: TObject);
    procedure lblFileSourceClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FDocumentDataSet,
    FTypesDataSet,
    FFormatsDataSet: TDataSet;
    Filters: TStringList;
    FDataChanged: Boolean;
    FFileData: String;
    MemStrm: TMemoryStream;
    procedure LoadAllDocuments(StartFolder: String; Mask: TStrings;
      ScanSubFolders: Boolean = True);
    procedure AddFile(AFileName: String; AForceSave: Boolean);
    procedure LoadData;
    function GetIndex(ACombobox: TCombobox; AID: Integer): Integer;
    function GetCurrentID(ACombobox: TCombobox): Integer;
    procedure LoadCB(ACombobox: TCombobox; ADataSet: TDataSet;
      AFieldName, FilterField: String);
    function CheckAndSave(ADoAsc: Boolean): Boolean;
    procedure MessageE(AMessage: String);
    function GetCorrectFileName(AFileName: String): String;
  public
    { Public declarations }
  end;

procedure EditDocument(ADocumentDataSet, ATypesDataSet, AFormatsDataSet: TDataSet;
  AClientDir: String; ALoadAllFromClientDir: Boolean = False);

implementation

{$R *.dfm}

uses Masks;


procedure EditDocument(ADocumentDataSet, ATypesDataSet, AFormatsDataSet: TDataSet;
  AClientDir: String; ALoadAllFromClientDir: Boolean = False);
Begin
  with TfrmEditDocument.Create(Application) do
  Begin
    try
      Filters := TStringList.Create;
      MemStrm := TMemoryStream.Create;
      FDocumentDataSet := ADocumentDataSet;
      FTypesDataSet := ATypesDataSet;
      FFormatsDataSet := AFormatsDataSet;
      LoadData;
      dlgOpen.InitialDir := AClientDir;
      if not ALoadAllFromClientDir then
        ShowModal
      else
        LoadAllDocuments(AClientDir, Filters);
    finally
      freeAndNil(Filters);
      freeAndNil(MemStrm);
      free;
    end;
  End;
End;

{ TfrmEditDocument }

procedure TfrmEditDocument.AddFile(AFileName: String; AForceSave: Boolean);
var
  ext: string;
  I: Integer;
  FormatIndex: Integer;

begin
  if AForceSave AND
     FDocumentDataSet.Locate('DocumentName', ExtractFileName(AFileName), [loCaseInsensitive]) then
    Exit;
  FormatIndex := -1;
  ext := ExtractFileExt(AFileName);
  for I := 0 to Filters.Count - 1 do
  begin
    if SameText(ext, ExtractFileExt(Filters[I])) then
    begin
      FormatIndex := I;
      Break;
    end;
  end;
  if FormatIndex = -1 then
  begin
    if not AForceSave then
      MessageDlg('Unsupported file format!', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
    Exit;
  end;

  FFileData := AFileName;
  if (edName.Text = '') or AForceSave then
    edName.Text := ExtractFileName(FFileData);
  chbDocumentLoaded.Checked := True;
  cbFormat.ItemIndex := FormatIndex;
  for I := 0 to cbType.Items.Count - 1 do
  begin
    if Pos(AnsiLowerCase(cbType.Items[I]), AnsiLowerCase(ChangeFileExt(edName.Text,''))) > 0 then
    begin
      cbType.ItemIndex := I;
      Break;
    end;
  end;

  MemStrm.Clear;
  MemStrm.LoadFromFile(FFileData);
  lblFileSource.Caption := FFileData + ' (' + IntToStr(MemStrm.Size div 1024) + ' Kb)';
  FDataChanged := True;

  if AForceSave then
  begin
    if cbType.ItemIndex = -1 then
      cbType.ItemIndex := 0;
    FDocumentDataSet.Append;
    CheckAndSave(False)
  end;
end;

procedure TfrmEditDocument.btnLoadFileClick(Sender: TObject);
begin
  if not DlgOpen.Execute then
    exit;
  AddFile(DlgOpen.FileName, False);
end;

procedure TfrmEditDocument.cbTypeChange(Sender: TObject);
begin
  FDataChanged := True;
end;

procedure TfrmEditDocument.FormActivate(Sender: TObject);
begin
  if FDocumentDataSet.State = dsInsert then
    btnLoadFileClick(btnLoadFile);
end;

procedure TfrmEditDocument.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := CheckAndSave(ModalResult <> mrOk);
end;

procedure TfrmEditDocument.MessageE(AMessage: String);
begin
  MessageDlg(AMessage, mtError, [mbOk], 0);
end;

function TfrmEditDocument.CheckAndSave(ADoAsc: Boolean): Boolean;
var
  mr: TModalResult;
begin
  Result := True;
  if not FDataChanged then
  Begin
    if FDocumentDataSet.State in dsEditModes then
      FDocumentDataSet.Cancel;
    exit;
  End;
  if ADoAsc then
    mr := MessageDlg('Data have been modified. Save changes?', mtConfirmation, mbYesNoCancel, 0)
  else
    mr := mrYes;

  case mr of
    mrYes:
      Begin
        if cbType.ItemIndex = -1 then
        Begin
          MessageE('Document type is empty');
          cbType.SetFocus;
          Result := False;
        End
        else
        if cbFormat.ItemIndex = -1 then
        Begin
          MessageE('Document format is empty');
          cbFormat.SetFocus;
          Result := False;
        End
        else
        if trim(edName.Text) = '' then
        Begin
          MessageE('Document name is empty');
          edName.SetFocus;
          Result := False;
        End
        else
        Begin
          if not (FDocumentDataSet.State in dsEditModes) then
            FDocumentDataSet.Edit;
          FDocumentDataSet.FieldByName('DocumentTypeID').AsInteger := GetCurrentID(cbType);
          FDocumentDataSet.FieldByName('DocumentFormatID').AsInteger := GetCurrentID(cbFormat);
          FDocumentDataSet.FieldByName('DocumentName').AsString := edName.Text;
          FDocumentDataSet.FieldByName('isDocumentLoaded').AsBoolean := chbDocumentLoaded.Checked;
          if MemStrm.Size = 0 then
            FDocumentDataSet.FieldByName('DocumentData').Clear
          else
          Begin
            MemStrm.Position := 0;
            TBlobField(FDocumentDataSet.FieldByName('DocumentData')).LoadFromStream(memStrm);
          End;
          try
            FDocumentDataSet.Post;
          Except ON E: Exception DO
            Begin
              MessageE(E.Message);
              Result := False;
            End;
          end;
        End;
      End;
    mrNo:
      Begin
        if FDocumentDataSet.State in dsEditModes then
          FDocumentDataSet.Cancel;
        Result := True;
      End;
    mrCancel: Result := False;
  end;
end;

function TfrmEditDocument.GetCurrentID(ACombobox: TCombobox): Integer;
begin
  if ACombobox.ItemIndex = -1 then
    Result := 0
  else
    Result := Integer(ACombobox.Items.Objects[ACombobox.ItemIndex]);
end;

function TfrmEditDocument.GetIndex(ACombobox: TCombobox; AID: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to ACombobox.Items.Count - 1 do
  Begin
    if Integer(ACombobox.Items.Objects[I]) = AID then
    Begin
      Result := I;
      exit;
    End;
  End;
  Result := -1;
end;

function TfrmEditDocument.GetCorrectFileName(AFileName: String): String;
var
  C: Char;
const
  BadChar: Array[0..8] of Char = ('<','>',':','"','/','\','|','?','*');
Begin
  Result := AFileName;
  for C in BadChar do
    Result := StringReplace(Result, C, '', [rfReplaceAll]);
End;

procedure TfrmEditDocument.lblFileSourceClick(Sender: TObject);
var
  tmpFileName: String;
  function GetTempDirectory: String;
  var
    tempFolder: array[0..MAX_PATH] of Char;
  begin
    GetTempPath(MAX_PATH, @tempFolder);
    result := StrPas(tempFolder);
  end;
begin
  if FFileData <> '' then
    ShellExecute(Handle, PWideChar('open'), PWideChar(FFileData), '', PWideChar(ExtractFileDir(FFileData)), SW_SHOWNORMAL)
  else
  if (MemStrm.Size <> 0) then
  Begin
    tmpFileName := IncludeTrailingPathDelimiter(GetTempDirectory);
    if edName.Text <> '' then
      tmpFileName := tmpFileName + GetCorrectFileName(edName.Text);
    if (ExtractFileExt(tmpFileName) = '') and
       (cbFormat.ItemIndex <> -1) then
      tmpFileName := ChangeFileExt(tmpFileName, GetCorrectFileName(Filters[cbFormat.ItemIndex]));
    MemStrm.Position := 0;
    try
      memStrm.SaveToFile(tmpFileName);
    except On E: Exception DO
      begin
        MessageE(E.Message);
        exit;
      end;
    end;
    ShellExecute(Handle, PWideChar('open'), PWideChar(tmpFileName), '', PWideChar(ExtractFileDir(FFileData)), SW_SHOWNORMAL)
  End;

end;

procedure TfrmEditDocument.lblFileSourceMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [fsUnderline];
end;

procedure TfrmEditDocument.lblFileSourceMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [];
end;

procedure TfrmEditDocument.LoadAllDocuments(StartFolder: String; Mask: TStrings;
  ScanSubFolders: Boolean = True);
var
  SearchRec: TSearchRec;
  FindResult: Integer;
  function isMatchesMask(Name: String; Mask: TStrings): Boolean;
  var
    i: Integer;
  Begin
    if Mask.Text = '' then
    Begin
      result := True;
    End
    else
    Begin
      Result := False;
      for i := 0 to Mask.Count - 1 do
      Begin
        result := MatchesMask(Name, Mask[i]);
        if Result then break;
      End;
    End;
  End;
begin
  StartFolder := IncludeTrailingPathDelimiter(StartFolder);
  FindResult := FindFirst(StartFolder + '*.*', faAnyFile, SearchRec);
  try
    while FindResult = 0 do
      with SearchRec do
      begin
        if (Attr and faDirectory) <> 0 then
        begin
          if ScanSubFolders and (Name <> '.') and (Name <> '..') then
            LoadAllDocuments(StartFolder + Name, Mask, ScanSubFolders);
        end
        else
        begin
          if isMatchesMask(Name, Mask) then
            AddFile(StartFolder + Name, True)
        end;
        FindResult := FindNext(SearchRec);
      end;
  finally
    FindClose(SearchRec);
  end;
end;

procedure TfrmEditDocument.LoadCB(ACombobox: TCombobox; ADataSet: TDataSet;
  AFieldName, FilterField: String);
begin
  with ADataSet, ACombobox do
  Begin
    Clear;
    DisableControls;
    try
      First;
      while Not eof do
      Begin
        Items.AddObject(FieldByName(AFieldName).AsString, TObject(FieldByName('Id').AsInteger));
        if (FilterField <> '') then
          Filters.Add(FieldByName(FilterField).AsString);
        Next;
      End;
    finally
      EnableControls;
    end;
  End;
end;

procedure TfrmEditDocument.LoadData;
var
  I: Integer;
  allFilterName, AllFilterExt: string;
begin
  LoadCB(cbType, FTypesDataSet, 'DocumentType', '');
  LoadCB(cbFormat, FFormatsDataSet, 'DocumentFormat', 'FileExtension');
  allFilterName := '';
  allFilterExt := '';
  dlgOpen.Filter := '';
  for I := 0 to Filters.Count - 1 do
  begin
    if pos('.',Filters[I]) = 0 then
      Filters[I] := '*.'+Filters[I];
    if allFilterName <> '' then
      allFilterName := allFilterName + ', ';
    if allFilterExt <> '' then
      allFilterExt := allFilterExt + ';';
    AllFilterName := AllFilterName + cbFormat.Items[I];
    AllFilterExt := AllFilterExt + Filters[I];
    if dlgOpen.Filter <> '' then
      dlgOpen.Filter := dlgOpen.Filter + '|';
    dlgOpen.Filter := dlgOpen.Filter + cbFormat.Items[I] + '|' + Filters[I];
  end;
  dlgOpen.Filter := dlgOpen.Filter + '|' + AllFilterName + '|' + AllFilterExt;
  dlgOpen.FilterIndex := Filters.Count + 1;

  edID.Text := FDocumentDataSet.FieldByname('Id').AsString;
  edName.Text := FDocumentDataSet.FieldByname('DocumentName').AsString;
  cbType.ItemIndex := GetIndex(cbType, FDocumentDataSet.FieldByname('DocumentTypeID').AsInteger);
  cbFormat.ItemIndex := GetIndex(cbFormat, FDocumentDataSet.FieldByname('DocumentFormatID').AsInteger);
  chbDocumentLoaded.Checked := FDocumentDataSet.FieldByname('isDocumentLoaded').AsBoolean;
  MemStrm.Clear;
  if not FDocumentDataSet.FieldByname('DocumentData').IsNull then
  Begin
    TBlobField(FDocumentDataSet.FieldByname('DocumentData')).SaveToStream(MemStrm);
    lblFileSource.Caption := FDocumentDataSet.FieldByname('DocumentName').AsString + ' (' +IntToStr(MemStrm.Size div 1024)+' Kb)'
  End
  else
    lblFileSource.Caption := '';
  FDataChanged := False;


end;

end.
