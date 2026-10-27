{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC TADUpdateSQL editor form            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADGUIxFormsfUSEdit;

interface

uses
{$IFDEF AnyDAC_FPC}
  LCLIntf, LCLType, LMessages, LResources,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Messages, Windows,
{$ENDIF}
  SysUtils, Classes, Graphics, Forms, ComCtrls, StdCtrls, ExtCtrls, Controls,
  uADStanIntf, uADStanOption,
  uADCompClient,
  uADGUIxFormsfOptsBase, uADGUIxFormsfUpdateOptions, uADGUIxFormsControls,
    uADGUIxFormsMemo;

type
  TfrmADGUIxFormsUSEdit = class(TfrmADGUIxFormsOptsBase)
    pcMain: TPageControl;
    tsGenerate: TTabSheet;
    Label1: TLabel;
    cbxTableName: TComboBox;
    btnDSDefaults: TButton;
    btnGenSQL: TButton;
    btnServerInfo: TButton;
    GroupBox2: TLabel;
    lbKeyFields: TListBox;
    GroupBox3: TLabel;
    lbUpdateFields: TListBox;
    GroupBox4: TLabel;
    lbRefetchFields: TListBox;
    tsSQL: TTabSheet;
    tsOptions: TTabSheet;
    ptreeOptions: TADGUIxFormsPanelTree;
    GroupBox5: TPanel;
    cbQuoteTabName: TCheckBox;
    cbQuoteColName: TCheckBox;
    frmUpdateOptions: TfrmADGUIxFormsUpdateOptions;
    Bevel4: TBevel;
    Bevel1: TBevel;
    Bevel5: TBevel;
    pcSQL: TPageControl;
    tsInsert: TTabSheet;
    tsModify: TTabSheet;
    tsDelete: TTabSheet;
    tsLock: TTabSheet;
    tsUnlock: TTabSheet;
    tsFetchRow: TTabSheet;
    procedure cbxTableNameDropDown(Sender: TObject);
    procedure btnServerInfoClick(Sender: TObject);
    procedure btnDSDefaultsClick(Sender: TObject);
    procedure btnGenSQLClick(Sender: TObject);
    procedure cbxTableNameExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mmSQLExit(Sender: TObject);
    procedure mmSQLKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbxTableNameChange(Sender: TObject);
    procedure cbxTableNameClick(Sender: TObject);
  private
    FConnection: TADCustomConnection;
    FDataSet: TADAdaptedDataSet;
    FUpdateSQL: TADUpdateSQL;
    FOpts: IADStanOptions;
    procedure UpdateExistSQLs;
    procedure GenCommands;
    function GetSQL(AIndex: Integer): TADGUIxFormsMemo;
    function ExecuteBase(AUpdSQL: TADUpdateSQL; const ACaption: String): Boolean;
    function UseField(const AFieldName: String): Boolean;
  public
    class function Execute(AUpdSQL: TADUpdateSQL; const ACaption: String): Boolean;
  end;

var
  frmADGUIxFormsUSEdit: TfrmADGUIxFormsUSEdit;

implementation

{$IFNDEF AnyDAC_FPC}
{$R *.dfm}
{$ENDIF}

uses
{$IFDEF AnyDAC_D17}
  System.UITypes,
{$ENDIF}
  Dialogs, DB,
  uADStanResStrs, uADStanUtil,
  uADDatSManager,
  uADPhysIntf;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.FormCreate(Sender: TObject);
var
  i: Integer;
  oSQL: TADGUIxFormsMemo;
begin
  for i := 0 to 5 do begin
    oSQL := TADGUIxFormsMemo.Create(Self);
    oSQL.Parent := pcSQL.Pages[i];
    oSQL.Left := 5;
    oSQL.Top := 5;
    oSQL.Width := oSQL.Parent.ClientWidth - 12;
    oSQL.Height := oSQL.Parent.ClientHeight - 12;
    oSQL.Anchors := [akLeft, akTop, akRight, akBottom];
    oSQL.Align := alNone;
    oSQL.Visible := True;
    oSQL.OnExit := mmSQLExit;
    oSQL.OnKeyDown := mmSQLKeyDown;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.FormShow(Sender: TObject);
{$IFDEF AnyDAC_FPC}
var
  i: Integer;
  oSQL: TADGUIxFormsMemo;
{$ENDIF}
begin
{$IFDEF AnyDAC_FPC}
  for i := 0 to 5 do begin
    oSQL := GetSQL(i);
    pcSQL.ActivePage := pcSQL.Pages[i];
    oSQL.Width := pcSQL.Width - 12;
    oSQL.Height := pcSQL.Height - 12;
  end;
{$ENDIF}
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsUSEdit.GetSQL(AIndex: Integer): TADGUIxFormsMemo;
begin
  Result := pcSQL.Pages[AIndex].Controls[0] as TADGUIxFormsMemo;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsUSEdit.UseField(const AFieldName: String): Boolean;
begin
  Result := (FDataSet = nil) or (FDataSet.FieldCount = 0) or
    (FDataSet.FindField(AFieldName) <> nil);
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.cbxTableNameDropDown(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  cbxTableName.Perform(CB_SETDROPPEDWIDTH, Width div 2, 0);
{$ENDIF}
  if cbxTableName.Items.Count = 0 then
    try
      FConnection.GetTableNames('', '', '', cbxTableName.Items, [osMy]);
    except
      cbxTableName.DroppedDown := False;
      raise;
    end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.cbxTableNameChange(Sender: TObject);
begin
  btnGenSQL.Enabled := (cbxTableName.Text <> '');
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.cbxTableNameClick(Sender: TObject);
begin
{$IFNDEF AnyDAC_FPC}
  if cbxTableName.Text <> '' then begin
    btnServerInfoClick(nil);
    btnDSDefaultsClick(nil);
  end;
{$ENDIF}
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.cbxTableNameExit(Sender: TObject);
begin
{$IFDEF AnyDAC_FPC}
  if cbxTableName.Text <> '' then begin
    btnServerInfoClick(nil);
    btnDSDefaultsClick(nil);
  end;
{$ENDIF}
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.btnServerInfoClick(Sender: TObject);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  sName: String;
  eAttrs: TADDataAttributes;
  i, j: Integer;
begin
  FConnection.ConnectionIntf.CreateMetadata(oConnMeta);
  oView := oConnMeta.GetTableFields('', '', cbxTableName.Text, '');
  try
    lbKeyFields.Items.Clear;
    lbUpdateFields.Items.Clear;
    lbRefetchFields.Items.Clear;
    for i := 0 to oView.Rows.Count - 1 do begin
      sName := oView.Rows[i].GetData('COLUMN_NAME');
      if sName = '' then
        sName := '_' + IntToStr(lbKeyFields.Items.Count);
      lbKeyFields.Items.Add(sName);
      lbUpdateFields.Items.Add(sName);
      lbRefetchFields.Items.Add(sName);
    end;
    for i := 0 to oView.Rows.Count - 1 do begin
      sName := oView.Rows[i].GetData('COLUMN_NAME');
      if UseField(sName) then begin
        j := oView.Rows[i].GetData('COLUMN_ATTRIBUTES');
        eAttrs := TADDataAttributes(Pointer(@J)^);
        if (sName <> '') and (eAttrs * [caCalculated, caInternal, caUnnamed] = []) then
          lbUpdateFields.Selected[i] := True;
        if eAttrs * [caAutoInc, caROWID, caDefault, caRowVersion, caCalculated, caVolatile] <> [] then
          lbRefetchFields.Selected[i] := True;
      end;
    end;
  finally
    ADFree(oView);
  end;
  oView := oConnMeta.GetTablePrimaryKeyFields('', '', cbxTableName.Text, '');
  try
    for i := 0 to oView.Rows.Count - 1 do begin
      sName := oConnMeta.UnQuoteObjName(oView.Rows[i].GetData('COLUMN_NAME'));
      if UseField(sName) then begin
        j := lbKeyFields.Items.IndexOf(sName);
        if j <> -1 then
          lbKeyFields.Selected[j] := True;
      end;
    end;
  finally
    ADFree(oView);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.btnDSDefaultsClick(Sender: TObject);
var
  oConnMeta: IADPhysConnectionMetadata;
  i, j: Integer;
  oFld: TField;
  sFldName: String;
begin
  if FDataSet = nil then
    Exit;
  if (FConnection <> nil) and (FConnection.ConnectionIntf <> nil) then
    FConnection.ConnectionIntf.CreateMetadata(oConnMeta)
  else
    oConnMeta := nil;
  if FDataSet.FieldCount <> 0 then begin
    for i := 0 to lbKeyFields.Items.Count - 1 do
      lbKeyFields.Selected[i] := False;
    for i := 0 to lbUpdateFields.Items.Count - 1 do
      lbUpdateFields.Selected[i] := False;
    for i := 0 to lbRefetchFields.Items.Count - 1 do
      lbRefetchFields.Selected[i] := False;
    for i := 0 to FDataSet.FieldCount - 1 do begin
      oFld := FDataSet.Fields[i];
      if oFld.Origin = '' then
        sFldName := oFld.FieldName
      else
        sFldName := oFld.Origin;
      if oConnMeta <> nil then
        sFldName := oConnMeta.UnQuoteObjName(sFldName);
      j := lbKeyFields.Items.IndexOf(sFldName);
      if j <> -1 then begin
        lbKeyFields.Selected[j] := pfInKey in oFld.ProviderFlags;
        lbUpdateFields.Selected[j] := pfInUpdate in oFld.ProviderFlags;
{$IFNDEF AnyDAC_FPC}
        lbRefetchFields.Selected[j] := (oFld.AutoGenerateValue <> DB.arNone);
{$ENDIF}
      end;
    end;
  end;
  if FDataSet.Adapter <> nil then begin
    FOpts.UpdateOptions.RestoreDefaults;
    frmUpdateOptions.LoadFrom(FOpts.UpdateOptions);
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.btnGenSQLClick(Sender: TObject);
begin
  frmUpdateOptions.SaveTo(FOpts.UpdateOptions);
  GenCommands;
  UpdateExistSQLs;
  pcMain.ActivePage := tsSQL;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.mmSQLExit(Sender: TObject);
begin
  UpdateExistSQLs;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.mmSQLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and ((Key = Ord('A')) or (Key = Ord('a'))) then begin
    TADGUIxFormsMemo(Sender).SelectAll;
    Key := 0;
  end
  else if Key = VK_ESCAPE then begin
    ModalResult := mrCancel;
    Key := 0;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.UpdateExistSQLs;
var
  i: Integer;
  s: String;
begin
  for i := 0 to 5 do begin
    s := pcSQL.Pages[i].Caption;
    if GetSQL(i).Lines.Count > 0 then begin
      if Pos('*', s) = 0 then
        s := s + ' *';
    end
    else begin
      if Pos('*', s) <> 0 then
        s := Copy(s, 1, Pos('*', s) - 1);
    end;
    pcSQL.Pages[i].Caption := s;
  end;
end;

{ --------------------------------------------------------------------------- }
procedure TfrmADGUIxFormsUSEdit.GenCommands;
var
  i, j: Integer;
  oCmdGen: IADPhysCommandGenerator;
  oTab: TADDatSTable;
  oCol: TADDatSColumn;
  oFld: TField;
  sFldName: String;
  oCmd: IADPhysCommand;
  oOpts: IADStanOptions;
begin
  oTab := TADDatSTable.Create;
  FConnection.ConnectionIntf.CreateCommand(oCmd);
  FConnection.ConnectionIntf.CreateCommandGenerator(oCmdGen, nil);
  try
    oOpts := oCmd.Options;
    oOpts.UpdateOptions.Assign(FOpts.UpdateOptions);
    oOpts.FetchOptions.RowsetSize := 0;
    oOpts.FetchOptions.Mode := fmManual;
    oOpts.FetchOptions.Items := oOpts.FetchOptions.Items + [fiMeta];

    // define table
    oCmd.Prepare('select * from ' + cbxTableName.Text);
    oCmd.Define(oTab);
    oTab.SourceName := cbxTableName.Text;

    // Include into Where only fields existing in dataset and
    // having pfInWhere in ProviderFlags
    if FDataSet <> nil then
      for i := 0 to oTab.Columns.Count - 1 do begin
        oCol := oTab.Columns[i];
        if coInWhere in oCol.Options then begin
          oCol.Options := oCol.Options - [coInWhere];
          for j := 0 to FDataSet.FieldCount - 1 do begin
            oFld := FDataSet.Fields[j];
            if oFld.Origin = '' then
              sFldName := oFld.FieldName
            else
              sFldName := oFld.Origin;
            if (AnsiCompareText(oCol.Name, sFldName) = 0) and
               (pfInWhere in oFld.ProviderFlags) then
              oCol.Options := oCol.Options + [coInWhere];
          end;
        end;
      end;

    // Include into where selected Key fields
    for i := 0 to lbKeyFields.Items.Count - 1 do begin
      oCol := oTab.Columns.ColumnByName(lbKeyFields.Items[i]);
      if lbKeyFields.Selected[i] then
        oCol.Options := oCol.Options + [coInKey, coInWhere]
      else
        oCol.Options := oCol.Options - [coInKey, coInWhere];
    end;

    // Include into update selected Updating fields
    for i := 0 to lbUpdateFields.Items.Count - 1 do begin
      oCol := oTab.Columns.ColumnByName(lbUpdateFields.Items[i]);
      if lbUpdateFields.Selected[i] then
        oCol.Options := oCol.Options + [coInUpdate, coInWhere]
      else
        oCol.Options := oCol.Options - [coInUpdate, coInWhere];
    end;

    // Include into refetch selected Refreshing fields
    for i := 0 to lbRefetchFields.Items.Count - 1 do begin
      oCol := oTab.Columns.ColumnByName(lbRefetchFields.Items[i]);
      if lbRefetchFields.Selected[i] then
        oCol.Options := oCol.Options + [coAfterInsChanged, coAfterUpdChanged]
      else
        oCol.Options := oCol.Options - [coAfterInsChanged, coAfterUpdChanged];
    end;

    // Setup SQL generator
    oCmdGen.FillRowOptions := [foData, foBlobs, foDetails, foClear] +
      ADGetFillRowOptions(oOpts.FetchOptions);
    oCmdGen.GenOptions := [goBeautify];
    if cbQuoteColName.Checked then
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceQuoteCol]
    else
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceNoQuoteCol];
    if cbQuoteTabName.Checked then
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceQuoteTab]
    else
      oCmdGen.GenOptions := oCmdGen.GenOptions + [goForceNoQuoteTab];
    oCmdGen.Options := oOpts;
    oCmdGen.Table := oTab;

    // Generate commands
    if FOpts.UpdateOptions.EnableInsert then
      GetSQL(0).Lines.Text := oCmdGen.GenerateInsert;
    if FOpts.UpdateOptions.EnableUpdate then
      GetSQL(1).Lines.Text := oCmdGen.GenerateUpdate;
    if FOpts.UpdateOptions.EnableDelete then
      GetSQL(2).Lines.Text := oCmdGen.GenerateDelete;
    if FOpts.UpdateOptions.LockMode <> lmNone then begin
      GetSQL(3).Lines.Text := oCmdGen.GenerateLock;
      GetSQL(4).Lines.Text := oCmdGen.GenerateUnLock;
    end;
    oCmdGen.FillRowOptions := oCmdGen.FillRowOptions + [foAfterIns, foAfterUpd];
    GetSQL(5).Lines.Text := oCmdGen.GenerateSelect(False);
  finally
    ADFree(oTab);
    oCmdGen := nil;
    oCmd := nil;
  end;
end;

{ --------------------------------------------------------------------------- }
function TfrmADGUIxFormsUSEdit.ExecuteBase(AUpdSQL: TADUpdateSQL; const ACaption: String): Boolean;
var
  oTestCmd: TADCustomCommand;
  i: Integer;

  function GetConnection: TADCustomConnection;
  begin
    if FUpdateSQL.ConnectionName <> '' then
      Result := ADManager.AcquireConnection(FUpdateSQL.ConnectionName, FUpdateSQL.Name)
    else begin
      if FUpdateSQL.Connection <> nil then
        Result := FUpdateSQL.Connection
      else if (FDataSet <> nil) and (FDataSet.PointedConnection <> nil) then
        Result := FDataSet.PointedConnection
      else
        Result := oTestCmd.GetConnection(False);
      if Result = nil then
        raise Exception.Create(S_AD_USEditCantEdit);
      Result := ADManager.AcquireConnection(Result, FUpdateSQL.Name);
    end;
  end;

  function GetParentObject: TPersistent;
  begin
    if FDataSet <> nil then
      Result := FDataSet
    else
      Result := oTestCmd;
  end;

  function GetUpdateOptions: TADBottomUpdateOptions;
  begin
    if FDataSet <> nil then
      Result := FDataSet.OptionsIntf.UpdateOptions as TADBottomUpdateOptions
    else
      Result := oTestCmd.UpdateOptions;
  end;

begin
  LoadState;
  FUpdateSQL := AUpdSQL;
  FDataSet := FUpdateSQL.DataSet;
  oTestCmd := FUpdateSQL.Commands[arInsert];
  FConnection := GetConnection;
  try
    FConnection.CheckActive;
    if (FDataSet <> nil) and not FDataSet.Active and
       (FDataSet.Command <> nil) and (Trim(FDataSet.Command.CommandText.Text) <> '') and
       (MessageDlg(S_AD_USEditOpenDS, mtConfirmation, [mbYes, mbNo], -1) = mrYes) then
      FDataSet.Open;

    FOpts := TADOptionsContainer.Create(GetParentObject, TADFetchOptions,
      TADUpdateOptions, TADTopResourceOptions, nil);
    FOpts.ParentOptions := GetUpdateOptions.Container as IADStanOptions;
    FOpts.UpdateOptions.Assign(GetUpdateOptions);

    Caption := Format(S_AD_USEditCaption, [ACaption]);
    btnDSDefaults.Enabled := (FDataSet <> nil);
    btnGenSQL.Enabled := False;
    pcMain.ActivePage := tsGenerate;
    ActiveControl := cbxTableName;

    frmUpdateOptions.LoadFrom(FOpts.UpdateOptions);
    frmUpdateOptions.SQLGenerator := True;

    cbxTableName.Text := GetUpdateOptions.UpdateTableName;
    if (cbxTableName.Text = '') and (FDataSet <> nil) and (FDataSet.Table <> nil) then
      cbxTableName.Text := FDataSet.Table.ActualOriginName;
    if cbxTableName.Text <> '' then begin
      cbxTableNameChange(cbxTableName);
      cbxTableNameClick(cbxTableName);
    end;

    if btnDSDefaults.Enabled then
      btnDSDefaultsClick(nil);

    for i := 0 to 5 do
      GetSQL(0).RDBMSKind := FConnection.RDBMSKind;
    GetSQL(0).Lines.Assign(AUpdSQL.InsertSQL);
    GetSQL(1).Lines.Assign(AUpdSQL.ModifySQL);
    GetSQL(2).Lines.Assign(AUpdSQL.DeleteSQL);
    GetSQL(3).Lines.Assign(AUpdSQL.LockSQL);
    GetSQL(4).Lines.Assign(AUpdSQL.UnlockSQL);
    GetSQL(5).Lines.Assign(AUpdSQL.FetchRowSQL);
    UpdateExistSQLs;

    Result := (ShowModal = mrOK);

  finally
    ADManager.ReleaseConnection(FConnection);
  end;

  if Result then begin
    AUpdSQL.InsertSQL.Assign(GetSQL(0).Lines);
    AUpdSQL.ModifySQL.Assign(GetSQL(1).Lines);
    AUpdSQL.DeleteSQL.Assign(GetSQL(2).Lines);
    AUpdSQL.LockSQL.Assign(GetSQL(3).Lines);
    AUpdSQL.UnlockSQL.Assign(GetSQL(4).Lines);
    AUpdSQL.FetchRowSQL.Assign(GetSQL(5).Lines);
  end;
  SaveState;
end;

{ --------------------------------------------------------------------------- }
class function TfrmADGUIxFormsUSEdit.Execute(AUpdSQL: TADUpdateSQL; const ACaption: String): Boolean;
var
  oFrm: TfrmADGUIxFormsUSEdit;
begin
  oFrm := TfrmADGUIxFormsUSEdit.Create(nil);
  try
    Result := oFrm.ExecuteBase(AUpdSQL, ACaption);
  finally
    ADFree(oFrm);
  end;
end;

{$IFDEF AnyDAC_FPC}
initialization
  {$I uADGUIxFormsfUSEdit.lrs}
{$ENDIF}

end.

