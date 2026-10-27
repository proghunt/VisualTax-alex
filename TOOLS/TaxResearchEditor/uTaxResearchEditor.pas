unit uTaxResearchEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, Data.DB, uADCompClient,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, uADStanExprFuncs, uADPhysSQLite,
  uADGUIxFormsWait, uADCompGUIx, System.IOUtils, System.Generics.Collections,
  System.UITypes;

type
  TfTaxResearchEditor = class(TForm)
    pnlDatabase: TPanel;
    lbDatabase: TLabel;
    edDatabase: TEdit;
    btnOpenDatabase: TSpeedButton;
    btnConnect: TButton;
    tvMain: TTreeView;
    grURLs: TDBGrid;
    pnlLeft: TPanel;
    pnlRight: TPanel;
    lbTitles: TLabel;
    lbURLs: TLabel;
    grpLeft: TGridPanel;
    btnTitleAdd: TButton;
    btnTitleEdit: TButton;
    btnTitleDelete: TButton;
    btnTitleUp: TButton;
    btnTitleDown: TButton;
    grpRight: TGridPanel;
    btnUrlAdd: TButton;
    btnUrlEdit: TButton;
    btnUrlDelete: TButton;
    btnUrlUp: TButton;
    btnUrlDown: TButton;
    pnlLeftCaption: TPanel;
    btnImportFromTRTOC: TButton;
    OpenTRTOC: TOpenDialog;
    btnExportToTRTOC: TButton;
    btnAddChild: TButton;
    SaveTRTOC: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure MainConnAfterConnect(Sender: TObject);
    procedure MainConnAfterDisconnect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConnectClick(Sender: TObject);
    procedure btnImportFromTRTOCClick(Sender: TObject);
    procedure btnTitleAddClick(Sender: TObject);
    procedure btnTitleEditClick(Sender: TObject);
    procedure btnAddChildClick(Sender: TObject);
    procedure btnTitleDeleteClick(Sender: TObject);
    procedure tvMainChange(Sender: TObject; Node: TTreeNode);
    procedure pnlRightResize(Sender: TObject);
    procedure btnTitleUpClick(Sender: TObject);
    procedure btnUrlAddClick(Sender: TObject);
    procedure btnUrlEditClick(Sender: TObject);
    procedure btnUrlDeleteClick(Sender: TObject);
    procedure btnUrlUpClick(Sender: TObject);
    procedure btnExportToTRTOCClick(Sender: TObject);
  private
    { Private declarations }
    RebuildingTree: boolean;
    procedure UpdateControlState;
    procedure BuildTree;
    procedure RefreshURLs;
  public
    { Public declarations }
  end;

var
  fTaxResearchEditor: TfTaxResearchEditor;

implementation

{$R *.dfm}

uses uData, uTitleEdit, uURLEdit;

procedure TfTaxResearchEditor.btnAddChildClick(Sender: TObject);
begin
  if not Assigned(tvMain.Selected) then
  begin
    ShowMessage('Please, select parent Title');
    Exit;
  end;
  if EditTitle(0, tvMain.Selected.StateIndex) then
    BuildTree;
end;

procedure TfTaxResearchEditor.btnConnectClick(Sender: TObject);
begin
  if dmData.MainConn.Connected then
    dmData.MainConn.Connected := false
  else
  begin
    dmData.ConnectTo(edDatabase.Text);
    BuildTree;
  end;
  UpdateControlState;
end;

procedure TfTaxResearchEditor.btnExportToTRTOCClick(Sender: TObject);
begin
  if not SaveTRTOC.Execute then Exit;
  if dmData.ExportToFile(SaveTRTOC.FileName) then
    ShowMessage('Data was successfully exported');
end;

procedure TfTaxResearchEditor.btnImportFromTRTOCClick(Sender: TObject);
var L: TStringList;
    I, nLevel, nParentTitleID: integer;
    A: TArray<string>;
    ParentTitleIDs: TArray<integer>;

    function GetLevel(AValue: string): integer;
    begin
      Result := 1;
      while AValue[Result] = ' ' do
      begin
        inc(Result);
        if Result >= Length(AValue) then break;
      end;
    end;

begin
  if dmData.QTitles.RecordCount > 0 then
  begin
    if MessageDlg('Do you want to clear all existing data ?',
                  mtWarning, mbYesNo, 0) = mrYes then
    begin
      dmData.ExecSQL('DELETE FROM Urls');
      dmData.ExecSQL('DELETE FROM Titles');
    end;
  end;
  if not OpenTRTOC.Execute then Exit;
  L := TStringList.Create;
  try
    L.LoadFromFile(OpenTRTOC.FileName);
    for I := 0  to L.Count - 1 do
    begin
      A := L.Strings[I].Split(['|']);
      if Length(A) < 2 then continue;
      nLevel := GetLevel(A[1]);
      if Length(ParentTitleIDs) < nLevel then
        SetLength(ParentTitleIDs, nLevel);
      if nLevel = 1 then
        nParentTitleID := 0
      else
        nParentTitleID := ParentTitleIDs[nLevel - 2];

      if Trim(A[2]).IsEmpty then
        ParentTitleIDs[nLevel - 1] := dmData.GetOrAddTitle(nParentTitleID, Trim(A[1]))
      else
        dmData.GetOrAddURL(nParentTitleID, Trim(A[1]), Trim(A[2]));
    end;
  finally
    L.Free;
  end;
  ShowMessage('Import was successfully finished');
  BuildTree;
end;

procedure TfTaxResearchEditor.btnTitleAddClick(Sender: TObject);
begin
  if EditTitle(0, 0) then
    BuildTree;
end;

procedure TfTaxResearchEditor.btnTitleDeleteClick(Sender: TObject);
begin
  if not Assigned(tvMain.Selected) then
  begin
    ShowMessage('There is nothing to delete');
    Exit;
  end;
  if MessageDlg('Are you sure you want to delete title "'+ tvMain.Selected.Text +'" with all URLs ?',
                  mtWarning, mbYesNo, 0) <> mrYes then Exit;
  if tvMain.Selected.HasChildren then
    if MessageDlg('Title has child nodes. Are you sure you want to delete them ?',
                  mtWarning, mbYesNo, 0) <> mrYes then Exit;
  dmData.ExecSQL('DELETE FROM Titles WHERE Id = '+ IntToStr(tvMain.Selected.StateIndex));
  dmData.UpdateTitleSeqNo;
  BuildTree;
end;

procedure TfTaxResearchEditor.btnTitleEditClick(Sender: TObject);
begin
  if not Assigned(tvMain.Selected) then
  begin
    ShowMessage('There is nothing to edit');
    Exit;
  end;
  if EditTitle(tvMain.Selected.StateIndex, 0) then
    BuildTree;
end;

procedure TfTaxResearchEditor.btnTitleUpClick(Sender: TObject);
var nParentTitleId, nID, nSeqNo, nNewSeqNo: integer;
begin
  if not Assigned(tvMain.Selected) then
  begin
    ShowMessage('There is nothing to move');
    Exit;
  end;
  nID := tvMain.Selected.StateIndex;
  nParentTitleId := 0;
  if Assigned(tvMain.Selected.Parent) then
    nParentTitleId := tvMain.Selected.Parent.StateIndex;
  nSeqNo := tvMain.Selected.OverlayIndex;
  if Sender = btnTitleUp then
    nNewSeqNo := nSeqNo - 1
  else
    nNewSeqNo := nSeqNo + 1;
  if not dmData.Exists(
    ' SELECT * FROM Titles '+
    ' WHERE SeqNo = '+ IntToStr(nNewSeqNo) +
    '   AND IFNULL(ParentTitleId, 0) = '+ IntToStr(nParentTitleId)) then Exit;
  dmData.ExecSQL(
    ' UPDATE Titles '+
    ' SET SeqNo = '+ IntToStr(nSeqNo) +
    ' WHERE SeqNo = '+ IntToStr(nNewSeqNo) +
    '   AND IFNULL(ParentTitleId, 0) = '+ IntToStr(nParentTitleId));
  dmData.ExecSQL(
    ' UPDATE Titles '+
    ' SET SeqNo = '+ IntToStr(nNewSeqNo) +
    ' WHERE Id = '+ IntToStr(nId));
  BuildTree;
end;

procedure TfTaxResearchEditor.btnUrlAddClick(Sender: TObject);
begin
  if not Assigned(tvMain.Selected) then
  begin
    ShowMessage('Please, select Title');
    Exit;
  end;
  if EditURL(0, tvMain.Selected.StateIndex) then
    RefreshURLs;
end;

procedure TfTaxResearchEditor.btnUrlDeleteClick(Sender: TObject);
begin
  if dmData.QURLs.RecordCount = 0 then
  begin
    ShowMessage('There is nothing to delete');
    Exit;
  end;
  if MessageDlg('Are you sure you want to delete title "'+ dmData.QURLs.FieldByName('Caption').AsString +'" ?',
                  mtWarning, mbYesNo, 0) <> mrYes then Exit;
  dmData.ExecSQL('DELETE FROM URLs WHERE Id = '+ IntToStr(dmData.QURLs.FieldByName('Id').AsInteger));
  dmData.UpdateURLSeqNo;
  RefreshURLs;
end;

procedure TfTaxResearchEditor.btnUrlEditClick(Sender: TObject);
begin
  if dmData.QURLs.RecordCount = 0 then
  begin
    ShowMessage('There is nothing to edit');
    Exit;
  end;
  if EditURL(dmData.QURLs.FieldByName('Id').AsInteger, dmData.QURLs.FieldByName('ParentTitleId').AsInteger) then
    RefreshURLs;
end;

procedure TfTaxResearchEditor.btnUrlUpClick(Sender: TObject);
var nParentTitleId, nID, nSeqNo, nNewSeqNo: integer;
begin
  if dmData.QURLs.RecordCount = 0 then
  begin
    ShowMessage('There is nothing to move');
    Exit;
  end;
  nID := dmData.QURLs.FieldByName('Id').AsInteger;
  nParentTitleId := dmData.QURLs.FieldByName('ParentTitleId').AsInteger;
  nSeqNo := dmData.QURLs.FieldByName('SeqNo').AsInteger;
  if Sender = btnURLUp then
    nNewSeqNo := nSeqNo - 1
  else
    nNewSeqNo := nSeqNo + 1;
  if not dmData.Exists(
    ' SELECT * FROM URLs '+
    ' WHERE SeqNo = '+ IntToStr(nNewSeqNo) +
    '   AND IFNULL(ParentTitleId, 0) = '+ IntToStr(nParentTitleId)) then Exit;
  dmData.ExecSQL(
    ' UPDATE URLs '+
    ' SET SeqNo = '+ IntToStr(nSeqNo) +
    ' WHERE SeqNo = '+ IntToStr(nNewSeqNo) +
    '   AND IFNULL(ParentTitleId, 0) = '+ IntToStr(nParentTitleId));
  dmData.ExecSQL(
    ' UPDATE URLs '+
    ' SET SeqNo = '+ IntToStr(nNewSeqNo) +
    ' WHERE Id = '+ IntToStr(nId));
  RefreshURLs;
end;

procedure TfTaxResearchEditor.BuildTree;
var NodeIDs: TDictionary<integer, TTreeNode>;
    ParentNode, CurrNode: TTreeNode;
    SelectedId: integer;

  function GetNodeByID(AID: integer): TTreeNode;
  begin
    Result := nil;
    NodeIDs.TryGetValue(AID, Result);
  end;

begin
  RebuildingTree := true;
  NodeIDs := TDictionary<integer, TTreeNode>.Create;
  try
    SelectedId := 0;
    if Assigned(tvMain.Selected) then
      SelectedId := tvMain.Selected.StateIndex;
    with dmData do
    begin
      QTitles.Close;
      QTitles.Open;
      tvMain.Items.BeginUpdate;
      try
        tvMain.Items.Clear;
        while not QTitles.Eof do
        begin
          ParentNode := GetNodeByID(QTitles.FieldByName('ParentTitleId').AsInteger);
          if Assigned(ParentNode) then
            CurrNode := tvMain.Items.AddChild(ParentNode, QTitles.FieldByName('Title').AsString)
          else
            CurrNode := tvMain.Items.Add(nil, QTitles.FieldByName('Title').AsString);
          CurrNode.StateIndex := QTitles.FieldByName('ID').AsInteger;
          CurrNode.OverlayIndex := QTitles.FieldByName('SeqNo').AsInteger;
          NodeIDs.AddOrSetValue(QTitles.FieldByName('Id').AsInteger, CurrNode);
          if SelectedId = QTitles.FieldByName('Id').AsInteger then
            CurrNode.Selected := true;
          QTitles.Next;
        end;
      finally
        tvMain.Items.EndUpdate;
      end;
    end;
  finally
    FreeAndNil(NodeIDs);
    RebuildingTree := false;
    tvMainChange(tvMain, tvMain.Selected);
  end;
end;

procedure TfTaxResearchEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dmData.MainConn.AfterConnect := nil;
  dmData.MainConn.AfterDisconnect := nil;
end;

procedure TfTaxResearchEditor.FormShow(Sender: TObject);
begin
  UpdateControlState;
  dmData.MainConn.AfterConnect := MainConnAfterConnect;
  dmData.MainConn.AfterDisconnect := MainConnAfterDisconnect;
  edDatabase.Text := TPath.Combine(ExtractFilePath(Application.ExeName), 'TRTOC.db');
  dmData.ConnectTo(edDatabase.Text);
  dmData.UpdateTitleSeqNo;
  dmData.UpdateURLSeqNo;
  BuildTree;
end;

procedure TfTaxResearchEditor.MainConnAfterConnect(Sender: TObject);
begin
  UpdateControlState;
end;

procedure TfTaxResearchEditor.MainConnAfterDisconnect(Sender: TObject);
begin
  UpdateControlState;
end;

procedure TfTaxResearchEditor.pnlRightResize(Sender: TObject);
var arrColWidths: TArray<integer>;
    i, nTotal: integer;
begin
  SetLength(arrColWidths, grURLs.Columns.Count);
  nTotal := 0;
  for i := 0 to grURLs.Columns.Count - 1 do
  begin
    if grURLs.Columns.Items[i].Width < 0 then
      arrColWidths[i] := 0
    else
      arrColWidths[i] := grURLs.Columns.Items[i].Width;
    nTotal := nTotal + arrColWidths[i];
  end;
  for i := 0 to grURLs.Columns.Count - 1 do
    grURLs.Columns.Items[i].Width := Trunc((grURLs.Width - IndicatorWidth - GetSystemMetrics(SM_CXVSCROLL) - 10) * arrColWidths[i] / nTotal);
end;

procedure TfTaxResearchEditor.RefreshURLs;
var nTitleId, nID: integer;
begin
  if RebuildingTree then Exit;
  if Assigned(tvMain.Selected) then
    nTitleId := tvMain.Selected.StateIndex
  else
    nTitleId := 0;
  with dmData do
  begin
    QURLs.DisableControls;
    try
      nID := 0;
      if QURLs.Active and (QURLs.RecordCount > 0) then
        nID := QURLs.FieldByName('Id').AsInteger;
      QURLs.Close;
      QURLs.ParamByName('TitleId').Value := nTitleId;
      QURLs.Open;
      if nID <> 0 then
        QURLs.Locate('Id', nID, []);
    finally
      QURLs.EnableControls;
    end;
  end;
end;

procedure TfTaxResearchEditor.tvMainChange(Sender: TObject; Node: TTreeNode);
begin
  RefreshURLs;
end;

procedure TfTaxResearchEditor.UpdateControlState;
var IsConnected: boolean;
begin
  IsConnected := dmData.MainConn.Connected;
  lbDatabase.Enabled := not IsConnected;
  edDatabase.Enabled := not IsConnected;
  btnOpenDatabase.Enabled := not IsConnected;
  if IsConnected then
    btnConnect.Caption := 'Disconnect'
  else
    btnConnect.Caption := 'Connect';
  btnImportFromTRTOC.Enabled := IsConnected;
  lbTitles.Enabled := IsConnected;
  lbURLs.Enabled := IsConnected;
  tvMain.Enabled := IsConnected;
  grURLs.Enabled := IsConnected;
  btnTitleAdd.Enabled := IsConnected;
  btnTitleEdit.Enabled := IsConnected;
  btnTitleDelete.Enabled := IsConnected;
  btnTitleUp.Enabled := IsConnected;
  btnTitleDown.Enabled := IsConnected;
  btnURLAdd.Enabled := IsConnected;
  btnURLEdit.Enabled := IsConnected;
  btnURLDelete.Enabled := IsConnected;
  btnURLUp.Enabled := IsConnected;
  btnURLDown.Enabled := IsConnected;
end;

end.
