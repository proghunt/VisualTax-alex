unit T3_2026LargeBenoList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs,
  ExtCtrls, Menus, ComCtrls, OleCtrls, Buttons, ToolWin, 
  ActnList, ImgList, shdocvw, Printers, Db, DBTables, ActiveX,
  T3_2026Declare, T3_2026TrimStr, T3_2026Common,
  T3_2026Common2, ShellApi, T3_2026ChildWinNew, FileCtrl,
  StrUtils, uADCompClient, Variants, IOUtils, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, Vcl.Grids, Vcl.DBGrids, ComObj;

type
  TOnError = procedure(AError: string) of object;
  TOnStart = procedure of object;
  TOnFinish = procedure of object;
  TOnInitProgress = procedure(AMax: integer) of object;
  TOnIncProgress = procedure of object;
  TOnStatus = procedure(AStatus: string) of object;

type
  TImportThread = class(TThread)
  private
    FOnError: TOnError;
    FOnStart: TOnStart;
    FOnFinish: TOnFinish;
    FOnInitProgress: TOnInitProgress;
    FOnIncProgress: TOnIncProgress;
    FOnStatus: TOnStatus;
    FProgressBar: TProgressBar;
    FConnection: TADConnection;
    FFileName: string;
    FTrustAccountNumber: string;
    FTrustName: string;
    procedure ShowError(AError: string);
    procedure DoStart;
    procedure DoFinish;
    procedure InitProgress(AMax: integer);
    procedure IncProgress;
    procedure ShowStatus(AStatus: string);
    function PrepareConnection: boolean;
    procedure ImportFromExcel;
  public
    procedure Execute; override;
    property OnError: TOnError read FOnError write FOnError;
    property OnStart: TOnStart read FOnStart write FOnStart;
    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property OnInitProgress: TOnInitProgress read FOnInitProgress write FOnInitProgress;
    property OnIncProgress: TOnIncProgress read FOnIncProgress write FOnIncProgress;
    property OnStatus: TOnStatus read FOnStatus write FOnStatus;
    property ProgressBar: TProgressBar read FProgressBar write FProgressBar;
    property FileName: string read FFileName write FFileName;
    property TrustAccountNumber: string read FTrustAccountNumber write FTrustAccountNumber;
    property TrustName: string read FTrustName write FTrustName;
  end;


type
  TLargeBenoListT3_2026 = class(TForm)
    StatusBar1: TStatusBar;
    Query1: TQuery;
    pnlTop: TPanel;
    lblTrustAccountNumber: TLabel;
    edTrustAccountNumber: TEdit;
    Label1: TLabel;
    edTrustName: TEdit;
    DBGrid1: TDBGrid;
    FDConnection: TADConnection;
    dsQ: TDataSource;
    pnlButtons: TPanel;
    btnAdd: TSpeedButton;
    btnEdit: TSpeedButton;
    btnDelete: TSpeedButton;
    btnImportFromExcel: TSpeedButton;
    Q: TADQuery;
    ImportProgressBar: TProgressBar;
    btnCancel: TSpeedButton;
    ExcelFileOpenDialog: TFileOpenDialog;
    btnDeleteAll: TSpeedButton;
    TimerStart: TTimer;
    btnPopulateFromS15: TSpeedButton;
    btnImportHelp: TSpeedButton;
    procedure btnAddClick(Sender: TObject);
    procedure QAfterScroll(DataSet: TDataSet);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnImportFromExcelClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteAllClick(Sender: TObject);
    procedure TimerStartTimer(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnPopulateFromS15Click(Sender: TObject);
    procedure btnImportHelpClick(Sender: TObject);
  private
    RetNo: integer;
    FThread: TImportThread;
    procedure ShowError(AError: string);
    procedure ThreadFinish;
    procedure ShowStatus(AStatus: string);
    function Init: boolean;
    function InitDatabase: boolean;
    function GetTrustAccountNumber: string;
    procedure SetTrustAccountNumber(const Value: string);
    function GetTrustName: string;
    procedure SetTrustName(const Value: string);
    procedure UpdateControls(AEnabled: boolean);
  public
    class procedure Execute;
    procedure RefreshList(AID: integer = 0);
    property TrustAccountNumber: string read GetTrustAccountNumber write SetTrustAccountNumber;
    property TrustName: string read GetTrustName write SetTrustName;
  end;


implementation

uses
  T3_2026, T3_2026main, vtMulti, vtTrimStr, vtShared, vtDataBase, vtCommon,
  T3_2026LargeBenoEdit;

{$R *.DFM}


{ TLargeBenoListT3_2026 }

procedure TLargeBenoListT3_2026.btnAddClick(Sender: TObject);
var LID: integer;
begin
  LID := 0;
  if TLargeBenoEditT3_2026.Execute(LID, FDConnection, TrustAccountNumber, TrustName) then
    RefreshList(LID);
end;

procedure TLargeBenoListT3_2026.btnCancelClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel import ?',
                mtWarning, mbYesNo, 0) <> mrYes then Exit;
  btnCancel.Enabled := false;
  FThread.Terminate;
end;

procedure TLargeBenoListT3_2026.btnDeleteAllClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete all entities ?',
                mtWarning, mbYesNo, 0) <> mrYes then Exit;
  FDConnection.ExecSql('DELETE FROM BenoTable WHERE TrustAccountNumber = '+ QuotedStr(TrustAccountNumber));
  RefreshList;
end;

procedure TLargeBenoListT3_2026.btnDeleteClick(Sender: TObject);
begin
  if Q.RecordCount = 0 then
  begin
    ShowMessage('There is nothing to delete');
    Exit;
  end;
  if MessageDlg('Are you sure you want to delete "'+ Q.FieldByName('EntityName').AsString + '" ?',
                mtWarning, mbYesNo, 0) <> mrYes then Exit;
  FDConnection.ExecSql('DELETE FROM BenoTable WHERE Id = '+ IntToStr(Q.FieldByName('Id').AsInteger));
  Q.Prior;
  RefreshList;
end;

procedure TLargeBenoListT3_2026.btnEditClick(Sender: TObject);
var LID: integer;
begin
  if Q.RecordCount = 0 then
  begin
    if not (Sender is TDBGrid) then
      ShowMessage('There is nothing to edit');
    Exit;
  end;
  LID := Q.FieldByName('Id').Asinteger;
  if TLargeBenoEditT3_2026.Execute(LID, FDConnection, TrustAccountNumber, TrustName) then
    RefreshList(LID);
end;

procedure TLargeBenoListT3_2026.btnImportFromExcelClick(Sender: TObject);
begin
  if not ExcelFileOpenDialog.Execute then Exit;
  UpdateControls(false);
  FThread := TImportThread.Create(true);
  FThread.FileName := ExcelFileOpenDialog.FileName;
  FThread.TrustAccountNumber := TrustAccountNumber;
  FThread.TrustName := TrustName;

  FThread.OnError := ShowError;
  FThread.OnFinish := ThreadFinish;
  FThread.OnStatus := ShowStatus;
  FThread.ProgressBar := ImportProgressBar;

  FThread.FreeOnTerminate := true;
  FThread.Start;
end;

procedure TLargeBenoListT3_2026.btnImportHelpClick(Sender: TObject);
begin
  ShowMessage('Required Excel file format:'+ #13#10 +
        'First row is ignored (it should contain column names) '+ #13#10 +
        'Column Count: 16'+ #13#10 +
        '1 (A): Add reportable entity (Y/N)'+ #13#10 +
        '2 (B): Reportable entity type (TRUSTEE, SETTLOR, BENEFICIARY, CONTROLLING_PERSON)'+ #13#10 +
        '3 (C): Entity classification (NATURAL_PERSON, CORPORATION, TRUST, OTHER)'+ #13#10 +
        '4 (D): Entity name'+ #13#10 +
        '5 (E): First name'+ #13#10 +
        '6 (F): Last name'+ #13#10 +
        '7 (G): Date of birth (YYYY-MM-DD)'+ #13#10 +
        '8 (H): Tax Identification Type (SIN, TTN, ITN, BN, TN, INTERNATIONAL)'+ #13#10 +
        '9 (I): Tax Identification Number'+ #13#10 +
        '10 (J): Address'+ #13#10 +
        '11 (K): City'+ #13#10 +
        '12 (L): Province (example - ON)'+ #13#10 +
        '13 (M): Country (example - CAN)'+ #13#10 +
        '14 (N): Postal Code'+ #13#10 +
        '15 (O): Country of Residence (example - CAN)'+ #13#10 +
        '16 (P): Did the entity''s association with the trust end during the year (Y/N)');
end;

procedure TLargeBenoListT3_2026.btnPopulateFromS15Click(Sender: TObject);
var LQuery: TADQuery;
    Inst: integer;
    cFormName, cError: string;
begin
  LQuery := TADQuery.Create(nil);
  try
    LQuery.Connection := FDConnection;
    // check S15 forms
    cError := '';
    for Inst := 1 to 100 do
    begin
      cFormName := 'S15#' + Inst.ToString;
      FormNo := FList.ByFormName(cFormName).FormNo;
      if RetList[RetNo].FrmHasData[FormNo] then
      begin
        if FetchElm(RetNo, cFormName, 5) + FetchElm(RetNo, cFormName, 6) = '' then
          cError := cError + #13#10 + cFormName +' Reportable Entity Action is not selected';

        if FetchElm(RetNo, cFormName, 7) +
           FetchElm(RetNo, cFormName, 8) +
           FetchElm(RetNo, cFormName, 9) +
           FetchElm(RetNo, cFormName, 10) = '' then
          cError := cError + #13#10 + cFormName + ' Reportable Entity Type is not selected';

        if FetchElm(RetNo, cFormName, 11) +
           FetchElm(RetNo, cFormName, 12) +
           FetchElm(RetNo, cFormName, 13) +
           FetchElm(RetNo, cFormName, 14) = '' then
          cError := cError + #13#10 + cFormName + ' Entity Classification is not selected';
      end;
    end;
    if not cError.IsEmpty then
    begin
      ShowMessage('Please fix the following errors: '+ cError);
      Exit;
    end;
    // populate entities from S15 forms
    for Inst := 1 to 100 do
    begin
      cFormName := 'S15#' + Inst.ToString;
      FormNo := FList.ByFormName(cFormName).FormNo;
      if RetList[RetNo].FrmHasData[FormNo] then
      begin
        LQuery.Close;
        LQuery.SQL.Text := 'SELECT * FROM BenoTable WHERE 1 = 0';
        LQuery.Open;
        LQuery.Append;
        LQuery.FieldByName('TrustAccountNumber').Value := TrustAccountNumber;
        LQuery.FieldByName('TrustName').Value := TrustName;

        if FetchElm(RetNo, cFormName, 5) > '' then
          LQuery.FieldByName('EntityAction').Value := 'A'
        else if FetchElm(RetNo, cFormName, 6) > '' then
          LQuery.FieldByName('EntityAction').Value := 'M'
        else
          raise Exception.Create(cFormName +' Reportable Entity Action is not selected');

        if FetchElm(RetNo, cFormName, 7) > '' then
          LQuery.FieldByName('EntityType').Value := 'T'
        else if FetchElm(RetNo, cFormName, 8) > '' then
          LQuery.FieldByName('EntityType').Value := 'S'
        else if FetchElm(RetNo, cFormName, 9) > '' then
          LQuery.FieldByName('EntityType').Value := 'BY'
        else if FetchElm(RetNo, cFormName, 10) > '' then
          LQuery.FieldByName('EntityType').Value := 'C'
        else
          raise Exception.Create(cFormName + ' Reportable Entity Type is not selected');

        if FetchElm(RetNo, cFormName, 11) > '' then
          LQuery.FieldByName('EntityClassification').Value := 'N'
        else if FetchElm(RetNo, cFormName, 12) > '' then
          LQuery.FieldByName('EntityClassification').Value := 'C'
        else if FetchElm(RetNo, cFormName, 13) > '' then
          LQuery.FieldByName('EntityClassification').Value := 'T'
        else if FetchElm(RetNo, cFormName, 14) > '' then
          LQuery.FieldByName('EntityClassification').Value := 'O'
        else
          raise Exception.Create(cFormName + ' Entity Classification is not selected');

        if FetchElm(RetNo, cFormName, 11) > '' then
        begin
          LQuery.FieldByName('NaturalPersonGivenName').Value := FetchElm(RetNo, cFormName, 16);
          LQuery.FieldByName('NaturalPersonFamilyName').Value := FetchElm(RetNo, cFormName, 17);
          if FetchElm(RetNo, cFormName, 18) > '' then
            LQuery.FieldByName('NaturalPersonBirthDate').Value := FetchElm(RetNo, cFormName, 18);
        end
        else
          LQuery.FieldByName('NotNaturalPersonEntityName').Value := FetchElm(RetNo, cFormName, 15);

        if FetchElm(RetNo, cFormName, 19) > '' then
          LQuery.FieldByName('TaxIdentificationNumberType').Value := 'SIN'
        else if FetchElm(RetNo, cFormName, 20) > '' then
          LQuery.FieldByName('TaxIdentificationNumberType').Value := 'TTN'
        else if FetchElm(RetNo, cFormName, 21) > '' then
          LQuery.FieldByName('TaxIdentificationNumberType').Value := 'ITN'
        else if FetchElm(RetNo, cFormName, 22) > '' then
          LQuery.FieldByName('TaxIdentificationNumberType').Value := 'BN'
        else if FetchElm(RetNo, cFormName, 23) > '' then
          LQuery.FieldByName('TaxIdentificationNumberType').Value := 'TN'
        else if FetchElm(RetNo, cFormName, 24) > '' then
          LQuery.FieldByName('TaxIdentificationNumberType').Value := 'INTERNATIONAL';

        LQuery.FieldByName('TaxIdentificationNumber').Value := FetchElm(RetNo, cFormName, 28);

        if FetchElm(RetNo, cFormName, 25) > '' then
          LQuery.FieldByName('OtherCountryOfResidence').Value := 'CAN'
        else if FetchElm(RetNo, cFormName, 26) > '' then
          LQuery.FieldByName('OtherCountryOfResidence').Value := 'USA'
        else if FetchElm(RetNo, cFormName, 27) > '' then
          LQuery.FieldByName('OtherCountryOfResidence').Value := FetchElm(RetNo, cFormName, 60);

        LQuery.FieldByName('AddressLineOne').Value := FetchElm(RetNo, cFormName, 29);
        LQuery.FieldByName('City').Value := FetchElm(RetNo, cFormName, 31);
        LQuery.FieldByName('ProvinceTerritoryState').Value := FetchElm(RetNo, cFormName, 32);
        LQuery.FieldByName('GlobalPostalZipCode').Value := FetchElm(RetNo, cFormName, 61);
        LQuery.FieldByName('Country').Value := GetCountry3FromCountry2(FetchElm(RetNo, cFormName, 30));
        if LQuery.FieldByName('Country').AsString.IsEmpty then
          LQuery.FieldByName('Country').Value := 'CAN';

        LQuery.FieldByName('EntityAssociationEndAction').Value := FetchElm(RetNo, cFormName, 34) > '';
        LQuery.Append;
      end;
    end;
    // clear forms (except S15#1, it contains unknownBeneficiariesInfo)
    for Inst := 100 downto 2 do
    begin
      cFormName := 'S15#' + Inst.ToString;
      FormNo := FList.ByFormName(cFormName).FormNo;
      if RetList[RetNo].FrmHasData[FormNo] then
        ClearForm(RetNo, cFormName);
    end;
    RefreshList;
  finally
    LQuery.Free;
  end;
end;

procedure TLargeBenoListT3_2026.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with Sender as TDBGrid do
    if DataCol = 0 then
    begin
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, Q.RecNo.ToString);
    end;
end;

class procedure TLargeBenoListT3_2026.Execute;
var LForm: TLargeBenoListT3_2026;
begin
  LForm := TLargeBenoListT3_2026.Create(Screen.ActiveForm);
  try
    if not LForm.Init then Exit;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

function TLargeBenoListT3_2026.GetTrustAccountNumber: string;
begin
  Result := edTrustAccountNumber.Text;
end;

function TLargeBenoListT3_2026.GetTrustName: string;
begin
  Result := edTrustName.Text;
end;

function TLargeBenoListT3_2026.Init: boolean;
begin
  Result := false;
  RetNo := GetCurrentRetNo;
  if RetNo < 1 then
  begin
    ShowMessage('You must open a return first');
    Exit;
  end;
  TrustAccountNumber := FetchElm(RetNo, 'T3', 2);
  TrustName := FetchElm(RetNo, 'T3', 1);
  if TrustAccountNumber.IsEmpty then
  begin
    ShowMessage('Trust Account Number is empty');
    Exit;
  end;
  if not InitDatabase then Exit;
  Result := true;
end;

function TLargeBenoListT3_2026.InitDatabase: boolean;
var LDBFile: string;
begin
  Result := false;
  LDBFile := TPath.Combine(OptRec.Dir_Cur, AppT3_2026.ClientsDBLite);
  if not TFile.Exists(LDBFile) then
  begin
    ShowMessage('File '+ LDBFile + ' was not found');
    Exit;
  end;
  FDConnection.LoginPrompt := false;
  FDConnection.DriverName := 'SQLite';
  FDConnection.Params.Values['Database'] := LDBFile;
  FDConnection.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, false);
  try
    try
      FDConnection.Connected := True;
    except
      FDConnection.Params.Values['Password'] := '';
      FDConnection.Connected := True;
    end;
    Q.Connection := FDConnection;
  except
    ON E: Exception DO
    begin
      ShowMessage(E.Message);
      Exit;
    end;
  end;
  Result := true;
end;

procedure TLargeBenoListT3_2026.QAfterScroll(DataSet: TDataSet);
begin
  if DataSet.RecordCount = 0 then
    StatusBar1.Panels.Items[0].Text := '0:0'
  else
    StatusBar1.Panels.Items[0].Text := DataSet.RecNo.ToString + ':' + DataSet.RecordCount.ToString;
end;

procedure TLargeBenoListT3_2026.RefreshList(AID: integer);
begin
  ShowStatus('Retrieving data (it can take some time if you have a lot of entities) ...');
  Screen.Cursor := crHourGlass;
  if (AID = 0) and Q.Active and not Q.IsEmpty then
    AID := Q.FieldByName('Id').AsInteger;
  Q.DisableControls;
  Q.AfterScroll := nil;
  dsQ.DataSet := nil;
  try
    Q.Close;
//    Q.SQL.Text :=
//        ' SELECT * FROM BenoTable '+
//        ' WHERE TrustAccountNumber = :TrustAccountNumber '+
//        ' ORDER BY Id';
    Q.ParamByName('TrustAccountNumber').Value := TrustAccountNumber;
    Q.Open;
    Q.FetchAll;
  finally
    if AID <> 0 then
      Q.Locate('Id', AID, []);
    Q.AfterScroll := QAfterScroll;
    QAfterScroll(Q);
    Q.EnableControls;
    dsQ.DataSet := Q;
    ShowStatus('');
    Screen.Cursor := crDefault;
  end;
end;

procedure TLargeBenoListT3_2026.SetTrustAccountNumber(const Value: string);
begin
  edTrustAccountNumber.Text := Value;
end;

procedure TLargeBenoListT3_2026.SetTrustName(const Value: string);
begin
  edTrustName.Text := Value;
end;

procedure TLargeBenoListT3_2026.ShowError(AError: string);
begin
  ShowMessage(AError);
end;

procedure TLargeBenoListT3_2026.ShowStatus(AStatus: string);
begin
  StatusBar1.Panels.Items[1].Text := AStatus;
  Statusbar1.Repaint;
end;

procedure TLargeBenoListT3_2026.ThreadFinish;
begin
  FThread := nil;
  UpdateControls(true);
  RefreshList;
end;

procedure TLargeBenoListT3_2026.TimerStartTimer(Sender: TObject);
begin
  TimerStart.Enabled := false;
  RefreshList;
end;

procedure TLargeBenoListT3_2026.UpdateControls(AEnabled: boolean);
var I: integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TSpeedButton then
    begin
      if Components[I] = btnCancel then
      begin
        TSpeedButton(Components[I]).Enabled := not AEnabled;
        TSpeedButton(Components[I]).Visible := not AEnabled;
      end
      else
        TSpeedButton(Components[I]).Enabled := AEnabled
    end
    else if Components[I] is TDBGrid then
      TDBGrid(Components[I]).Enabled := AEnabled
    else if Components[I] is TEdit then
      TEdit(Components[I]).Enabled := AEnabled
    else if Components[I] is TProgressBar then
    begin
      TProgressBar(Components[I]).Visible := not AEnabled;
      TProgressBar(Components[I]).Position := 0;
    end;
end;

{ TImportThread }

procedure TImportThread.DoFinish;
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnFinish) then
        OnFinish;
    end);
end;

procedure TImportThread.DoStart;
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnStart) then
        OnStart;
      Application.ProcessMessages;
    end);
end;

procedure TImportThread.Execute;
begin
  inherited;
  FConnection := TADConnection.Create(nil);
  try
    try
      if PrepareConnection then
        ImportFromExcel;
    except on E: Exception do
      ShowError(E.Message);
    end;
  finally
    FConnection.Free;
    DoFinish;
  end;
end;

procedure TImportThread.ImportFromExcel;
const
  xlCellTypeLastCell = $0000000B;
var
  XLApp, Sheet: OLEVariant;
  RangeMatrix: Variant;
  x, y, J: integer;
  Value: string;
  LQuery: TADQuery;
begin
  ShowStatus('Initializing Excel application..');
  CoInitialize(nil);
  XLApp := CreateOleObject('Excel.Application');
  try
    XLApp.Visible := False;
    XLApp.DisplayAlerts := false;
    if Terminated then
    begin
      ShowStatus('Canceling import..');
      Exit;
    end;
    ShowStatus('Loading '+ ExtractFileName(FileName) +'..');
    XLApp.Workbooks.Open(FileName);
    Sheet := XLApp.Workbooks[ExtractFileName(FileName)].WorkSheets[1];
    Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
    x := XLApp.ActiveCell.Row;
    y := XLApp.ActiveCell.Column;

    if (x < 2) or (y < 16) then
    begin
      raise Exception.Create('File "'+ FileName +'" contains incorrect data and cannot be loaded.'+ #13#10 +
        'Required file format:'+ #13#10 +
        'First row is ignored (it should contain column names) '+ #13#10 +
        'Column Count: 16'+ #13#10 +
        '1 (A): Add reportable entity (Y/N)'+ #13#10 +
        '2 (B): Reportable entity type (TRUSTEE, SETTLOR, BENEFICIARY, CONTROLLING_PERSON)'+ #13#10 +
        '3 (C): Entity classification (NATURAL_PERSON, CORPORATION, TRUST, OTHER)'+ #13#10 +
        '4 (D): Entity name'+ #13#10 +
        '5 (E): First name'+ #13#10 +
        '6 (F): Last name'+ #13#10 +
        '7 (G): Date of birth (YYYY-MM-DD)'+ #13#10 +
        '8 (H): Tax Identification Type (SIN, TTN, ITN, BN, TN, INTERNATIONAL)'+ #13#10 +
        '9 (I): Tax Identification Number'+ #13#10 +
        '10 (J): Address'+ #13#10 +
        '11 (K): City'+ #13#10 +
        '12 (L): Province (example - ON)'+ #13#10 +
        '13 (M): Country (example - CAN)'+ #13#10 +
        '14 (N): Postal Code'+ #13#10 +
        '15 (O): Country of Residence (example - CAN)'+ #13#10 +
        '16 (P): Did the entity''s association with the trust end during the year (Y/N)');
    end
    else
    begin
      LQuery := TADQuery.Create(nil);
      try
        LQuery.Connection := FConnection;
        RangeMatrix := XLApp.Range['A1', XLApp.Cells.Item[X, Y]].Value;
        InitProgress(X-1);
        ShowStatus('Importing data..');
        for J := 2 to X do
        begin
          if Terminated then
          begin
            ShowStatus('Canceling import..');
            break;
          end;
          LQuery.Close;
          LQuery.SQL.Text := 'SELECT * FROM BenoTable WHERE 1 = 0';
          LQuery.Open;
          LQuery.Append;
          LQuery.FieldByName('TrustAccountNumber').Value := TrustAccountNumber;
          LQuery.FieldByName('TrustName').Value := TrustName;

          Value := Trim(VarToStr(RangeMatrix[J, 1]));
          if SameText(Value, 'Y') then
            Value := 'A'
          else
            Value := 'M';
          LQuery.FieldByName('EntityAction').Value := Value;

          Value := UpperCase(VarToStr(RangeMatrix[J, 2]));
          if SameText(Value, 'TRUSTEE') then
            Value := 'T'
          else if SameText(Value, 'SETTLOR') then
            Value := 'S'
          else if SameText(Value, 'BENEFICIARY') then
            Value := 'B'
          else if SameText(Value, 'CONTROLLING_PERSON') then
            Value := 'C'
          else
            raise Exception.Create('Incorrect value for Reportable entity type on line '+ J.ToString);
          LQuery.FieldByName('EntityType').Value := Value;

          Value := UpperCase(VarToStr(RangeMatrix[J, 3]));
          if SameText(Value, 'NATURAL_PERSON') then
            Value := 'N'
          else if SameText(Value, 'CORPORATION') then
            Value := 'C'
          else if SameText(Value, 'TRUST') then
            Value := 'T'
          else if SameText(Value, 'OTHER') then
            Value := 'O'
          else
            raise Exception.Create('Incorrect value for Entity classification on line '+ J.ToString);
          LQuery.FieldByName('EntityClassification').Value := Value;

          LQuery.FieldByName('NotNaturalPersonEntityName').Value := VarToStr(RangeMatrix[J, 4]);
          LQuery.FieldByName('NaturalPersonGivenName').Value := VarToStr(RangeMatrix[J, 5]);
          LQuery.FieldByName('NaturalPersonFamilyName').Value := VarToStr(RangeMatrix[J, 6]);
          LQuery.FieldByName('NaturalPersonBirthDate').Value := VarToStr(RangeMatrix[J, 7]);

          Value := UpperCase(VarToStr(RangeMatrix[J, 8]));
          if SameText(Value, 'SIN')
             or
             SameText(Value, 'TTN')
             or
             SameText(Value, 'ITN')
             or
             SameText(Value, 'BN')
             or
             SameText(Value, 'TN')
             or
             SameText(Value, 'INTERNATIONAL')
             or
             Value.IsEmpty then
            LQuery.FieldByName('TaxIdentificationNumberType').Value := Value
          else
            raise Exception.Create('Incorrect value for Tax Identification Type on line '+ J.ToString);

          LQuery.FieldByName('TaxIdentificationNumber').Value := VarToStr(RangeMatrix[J, 9]);
          LQuery.FieldByName('AddressLineOne').Value := VarToStr(RangeMatrix[J, 10]);
          LQuery.FieldByName('City').Value := VarToStr(RangeMatrix[J, 11]);
          LQuery.FieldByName('ProvinceTerritoryState').Value := VarToStr(RangeMatrix[J, 12]);
          LQuery.FieldByName('Country').Value := VarToStr(RangeMatrix[J, 13]);
          LQuery.FieldByName('GlobalPostalZipCode').Value := VarToStr(RangeMatrix[J, 14]);
          LQuery.FieldByName('OtherCountryOfResidence').Value := VarToStr(RangeMatrix[J, 15]);
          LQuery.FieldByName('EntityAssociationEndAction').Value := SameText(Trim(VarToStr(RangeMatrix[J, 16])), 'Y');

          LQuery.Post;
          IncProgress;
        End;
      finally
        LQuery.Free;
      end;
    End;
  finally
    RangeMatrix := Unassigned;
    if not VarIsEmpty(XLApp) then
    begin
      XLApp.Quit;
      XLApp.DisplayAlerts := true;
      XLAPP := Unassigned;
      Sheet := Unassigned;
    end;
    CoUnInitialize();
  end;
end;

procedure IncProgressBar(AProgressBar: TProgressBar);
begin
  // it is a workaround for progressbar glithes, it does not refresh immediately after position increment
  if AProgressBar.Position + 1 >= AProgressBar.Max then
  begin
    AProgressBar.Max := AProgressBar.Max + 1;
    AProgressBar.Position := AProgressBar.Position + 2;
    AProgressBar.Max := AProgressBar.Max - 1;
  end
  else
  begin
    AProgressBar.Position := AProgressBar.Position + 2;
    AProgressBar.Position := AProgressBar.Position - 1;
  end;
end;

procedure TImportThread.IncProgress;
begin
  Synchronize(
    procedure
    begin
      if Assigned(ProgressBar) then
        IncProgressBar(ProgressBar)
      else if Assigned(OnIncProgress) then
        OnIncProgress;
    end);
end;

procedure TImportThread.InitProgress(AMax: integer);
begin
  Synchronize(
    procedure
    begin
      if Assigned(ProgressBar) then
      begin
        ProgressBar.Position := 0;
        ProgressBar.Max := AMax;
      end
      else if Assigned(OnInitProgress) then
        OnInitProgress(AMax);
    end);
end;

function TImportThread.PrepareConnection: boolean;
begin
  ShowStatus('Preparing database connection..');
  Result := false;
  FConnection.Connected := false;
  FConnection.LoginPrompt := false;
  FConnection.DriverName := 'SQLite';
  FConnection.Params.Values['Database'] := TPath.Combine(OptRec.Dir_Cur, AppT3_2026.ClientsDBLite);
  FConnection.Params.Values['Password'] := Pswd(GC_SQLLitePasswordVersion, false);
  try
    try
      FConnection.Connected := True;
    except
      FConnection.Params.Values['Password'] := '';
      FConnection.Connected := True;
    end;
  except
    ON E: Exception DO
      ShowError(E.Message);
  end;
  Result := FConnection.Connected;
end;

procedure TImportThread.ShowError(AError: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnError) then
        OnError(AError);
    end);
end;

procedure TImportThread.ShowStatus(AStatus: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnStatus) then
        OnStatus(AStatus);
    end);
end;

end.

