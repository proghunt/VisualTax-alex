unit T1_2026MassEmailToTaxPayers;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls, System.Generics.Collections,
  vtMulti, Vcl.Menus, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, Data.DB,
  uADCompDataSet, uADCompClient, Vcl.DBGrids, System.IOUtils, Data.DBXJSON,
  vtVirtualTaxOffice, Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw, MSHTML, ActiveX,
  vtEditHTML;

type
  TMassRegisterThread = class;

  TMassEmailToTaxPayersT1_2026 = class(TForm)
    pnlCaption: TPanel;
    pnlBottom: TPanel;
    QPayers: TADMemTable;
    grPayers: TDBGrid;
    QPayersEMAIL: TStringField;
    QPayersRESULT: TStringField;
    dsPayers: TDataSource;
    QPayersERROR: TBooleanField;
    btnRegister: TButton;
    btnCancel: TButton;
    pnlButtons: TPanel;
    pnlProgress: TPanel;
    pbProgress: TProgressBar;
    lbProgress: TLabel;
    ThreadTimer: TTimer;
    lbTime: TLabel;
    pnlTemplate: TPanel;
    lbTemplateCaption: TLabel;
    pnlTemplateHeader: TPanel;
    wbPreview: TWebBrowser;
    pnlPreview: TPanel;
    Splitter1: TSplitter;
    QPayersCYBERID: TStringField;
    pnlGrid: TPanel;
    sbGrid: TStatusBar;
    cbMassEmailWording: TComboBox;
    Label1: TLabel;
    edSubject: TEdit;
    btnEdit: TSpeedButton;
    SaveWordingDialog: TSaveDialog;
    QPayersPASSWORD: TStringField;
    QPayersFIRST_NAME: TStringField;
    QPayersLAST_NAME: TStringField;
    btnNew: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure grPayersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ThreadTimerTimer(Sender: TObject);
    procedure QPayersAfterScroll(DataSet: TDataSet);
    procedure wbPreviewCommandStateChange(ASender: TObject; Command: Integer;
      Enable: WordBool);
    procedure FormCreate(Sender: TObject);
    procedure wbPreviewBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure cbMassEmailWordingChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
  private
    { Private declarations }
    FThread: TMassRegisterThread;
    FProcessedCount: integer;
    FStartTime: TDateTime;
    FSkipLinkIntercept: boolean;
    GridRefreshing: boolean;
    FCurrentWording: string;
    FWordingDir: string;
    procedure ThreadStarted;
    procedure ThreadFinished;
    function GetRecord(var AWording, AEmail: string): boolean;
    procedure SaveRecordAndNext(AResult: string; AError: boolean);
    procedure RefreshPreview;
    procedure LoadTaxPayers;
    procedure InitWordings;
    procedure ClearResults;
    function SaveWording(ATemplate: string): boolean;
  public
    { Public declarations }
  end;

  TMassRegisterThread = class(TThread)
  private
    FForm: TMassEmailToTaxPayersT1_2026;
  protected
    procedure Execute; override;
    constructor Create(AForm: TMassEmailToTaxPayersT1_2026);
  end;

  procedure MassEmailToTaxPayers;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Common,T1_2026Common2,T1_2026TrimStr,
  T1_2026Declare,T1_2026ChildWinNEW,vtTrimStr,vtShared,vtDatabase,
  vtDialogs,DateUtils;

procedure MassEmailToTaxPayers;
var FMassEmailToTaxPayersT1_2026: TMassEmailToTaxPayersT1_2026;
begin
  FMassEmailToTaxPayersT1_2026 := TMassEmailToTaxPayersT1_2026.Create(Screen.ActiveForm);
  try
    FMassEmailToTaxPayersT1_2026.ShowModal;
  finally
    FMassEmailToTaxPayersT1_2026.Free;
  end;
end;

{ TMassEmailToTaxPayersT1_2026 }

procedure TMassEmailToTaxPayersT1_2026.btnNewClick(Sender: TObject);
var FHTML, cFile: string;
begin
  FHTML := '';
  if RunEditHTML(FHTML, SaveWording) then
  begin
    InitWordings;
    RefreshPreview;
  end;
end;

procedure TMassEmailToTaxPayersT1_2026.btnRegisterClick(Sender: TObject);
var FRecNo: integer;
    FParams: TParamList;
    Res: TJSONObject;
begin
  if Assigned(FThread) then
  begin
    if MessageDlg('Are you sure you want to cancel mass email ?',
            mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    FThread.Terminate;
    btnRegister.Enabled := false;
  end
  else
  begin
    if QPayers.RecordCount = 0 then
    begin
      ShowMessageWarning('There is no clients to register');
      Exit;
    end;
    if FCurrentWording.IsEmpty then
    begin
      ShowMessageWarning('Email wording is empty');
      Exit;
    end;
    if String(edSubject.Text).IsEmpty then
    begin
      ShowMessageWarning('Email Subject is empty');
      Exit;
    end;
    if MessageDlg('Program will sent emails to all offices from the list.'+ Chr(13)+'Are you sure ?',
            mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    ClearResults;
    QPayers.First;
    FThread := TMassRegisterThread.Create(Self);
    ThreadStarted;
  end;
end;

procedure TMassEmailToTaxPayersT1_2026.btnEditClick(Sender: TObject);
var FHTML, cFile: string;
begin
  FHTML := '';
  if not String(cbMassEmailWording.Text).IsEmpty then
  begin
    cFile := TPath.Combine(FWordingDir, cbMassEmailWording.Text);
    if FileExists(cFile) then
    begin
      with TStringList.Create do
      try
        LoadFromFile(cFile);
        FHTML := Text;
      finally
        Free;
      end;
      if RunEditHTML(FHTML, SaveWording) then
      begin
        InitWordings;
        RefreshPreview;
      end;
    end;
  end;
end;

procedure TMassEmailToTaxPayersT1_2026.cbMassEmailWordingChange(
  Sender: TObject);
begin
  RefreshPreview;
  btnEdit.Enabled := cbMassEmailWording.ItemIndex <> -1;
end;

procedure TMassEmailToTaxPayersT1_2026.ClearResults;
var FRecNo: integer;
begin
  FRecNo := QPayers.RecNo;
  QPayers.DisableControls;
  try
    QPayers.First;
    while not QPayers.Eof do
    begin
      QPayers.Edit;
      QPayers.FieldByName('RESULT').Clear;
      QPayers.FieldByName('ERROR').Value := false;
      QPayers.Post;
      QPayers.Next;
    end;
  finally
    QPayers.RecNo := FRecNo;
    QPayers.EnableControls;
  end;
end;

procedure TMassEmailToTaxPayersT1_2026.FormCreate(Sender: TObject);
begin
  GridRefreshing := false;
  FSkipLinkIntercept := false;
end;

procedure TMassEmailToTaxPayersT1_2026.FormShow(Sender: TObject);
begin
  FWordingDir := TPath.Combine(AppDir, 'MassEmailWordings');
  ForceDirectories(FWordingDir);
  InitWordings;
  LoadTaxPayers;
end;

function TMassEmailToTaxPayersT1_2026.GetRecord(var AWording, AEmail: string): boolean;
begin
  Result := false;
  if QPayers.Eof then Exit;
  AWording := FCurrentWording;
  AEmail := QPayers.FieldByName('EMAIL').AsString;
  Result := true;
end;

procedure TMassEmailToTaxPayersT1_2026.grPayersDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (gdFocused in State) then
  begin
    grPayers.Canvas.Brush.Color := clHighlight;
    grPayers.Canvas.Font.Color := clHighlightText;
  end
  else if QPayers.FieldByName('ERROR').AsBoolean then
    grPayers.Canvas.Brush.Color := Rgb(255, 128, 128)
  else if QPayers.FieldByName('RESULT').AsString.IsEmpty then
    grPayers.Canvas.Brush.Color := clWhite
  else
    grPayers.Canvas.Brush.Color := Rgb(198, 255, 198);
  grPayers.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TMassEmailToTaxPayersT1_2026.InitWordings;
var cSaveCurrWording: string;
    bRestore: boolean;
begin
  cSaveCurrWording := cbMassEmailWording.Text;
  cbMassEmailWording.Text := '';
  cbMassEmailWording.Items.Clear;
  TDirectory.GetFiles(FWordingDir, '*.txt', TSearchOption.soTopDirectoryOnly,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      Result := True;
      cbMassEmailWording.Items.Add(SearchRec.Name);
      if SameText(cSaveCurrWording, SearchRec.Name) then
        bRestore := true;
    end);
  cbMassEmailWording.ItemIndex := cbMassEmailWording.Items.IndexOf(cSaveCurrWording);
end;

procedure TMassEmailToTaxPayersT1_2026.LoadTaxPayers;
var FParams: TParamList;
    Res, Row: TJSONObject;
    Values: TJSONArray;
    ArrayElement: TJSONValue;
begin
  QPayers.Close;
  QPayers.Open;
  QPayers.DisableControls;
  FParams := TParamList.Create;
  GridRefreshing := true;
  try
    FParams.Add('action=LIST_PAYERS_FOR_DESKTOP');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(Res.Get('success').JSONValue.Value, 'true') then
      begin
        Values := TJSONArray(Res.Get('result').JSONValue);
        if Assigned(Values) then
        begin
          for ArrayElement in Values do
            if Assigned(ArrayElement) then
            begin
              Row := TJSONObject(ArrayElement);
              QPayers.Append;
              QPayers.FieldByName('CYBERID').Value := Row.Get('CyberId').JSONValue.Value;
              QPayers.FieldByName('FIRST_NAME').Value := Row.Get('FirstName').JSONValue.Value;
              QPayers.FieldByName('LAST_NAME').Value := Row.Get('LastName').JSONValue.Value;
              QPayers.FieldByName('EMAIL').Value := Row.Get('Email').JSONValue.Value;
              QPayers.FieldByName('RESULT').Value := '';
              QPayers.FieldByName('ERROR').Value := false;
              QPayers.Post;
            end;
        end;
      end
      else
        ShowMessage(Res.Get('error_message').JSONValue.Value);
    end;
  finally
    FParams.Free;
    QPayers.First;
    QPayers.EnableControls;
    GridRefreshing := false;
    QPayersAfterScroll(nil);
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TMassEmailToTaxPayersT1_2026.QPayersAfterScroll(DataSet: TDataSet);
begin
  if GridRefreshing then Exit;
  if QPayers.RecordCount = 0 then
    sbGrid.Panels[0].Text := '0 : 0'
  else
    sbGrid.Panels[0].Text := IntToStr(QPayers.RecNo) + ' : ' + IntToStr(QPayers.RecordCount);
  pnlPreview.Enabled := false;
  RefreshPreview;
  pnlPreview.Enabled := true;
end;

procedure TMassEmailToTaxPayersT1_2026.RefreshPreview;
var FHTML, FFirstName, FLastName: string;
    Doc: Variant;
    cFile: string;
begin
  if GridRefreshing then Exit;
  FHTML := '';
  if not String(cbMassEmailWording.Text).IsEmpty then
  begin
    cFile := TPath.Combine(FWordingDir, cbMassEmailWording.Text);
    if FileExists(cFile) then
    begin
      with TStringList.Create do
      try
        LoadFromFile(cFile);
        FHTML := Text;
      finally
        Free;
      end;
    end;
  end;

  FFirstName := '';
  FLastName := '';
  if QPayers.RecordCount > 0 then
  begin
    FFirstName := QPayers.FieldByName('FIRST_NAME').AsString;
    FLastName := QPayers.FieldByName('LAST_NAME').AsString;
  end;
  FHTML := FHTML.Replace('[DATE]', formatdatetime('yyyy-mm-dd', Date), [rfIgnoreCase]);
  FHTML := FHTML.Replace('[FIRST_NAME]', FFirstName, [rfIgnoreCase]);
  FHTML := FHTML.Replace('[LAST_NAME]', FLastName, [rfIgnoreCase]);

  FCurrentWording := FHTML;

  FSkipLinkIntercept := true;
  try
    if not Assigned(wbPreview.Document) then
      wbPreview.Navigate('about:blank');

    Doc := wbPreview.Document;
    Doc.Clear;
    Doc.Write(FHTML);
    Doc.Close;
    while wbPreview.ReadyState <> READYSTATE_COMPLETE do
      Application.ProcessMessages;
  finally
    FSkipLinkIntercept := false;
  end;
end;

procedure TMassEmailToTaxPayersT1_2026.ThreadFinished;
begin
  pnlProgress.Visible := false;
  btnCancel.Visible := true;
  //btnRegister.Width := btnCancel.Width;
  btnRegister.Caption := 'Send Email to clients';
  btnRegister.Enabled := true;
  FThread := nil;
  ThreadTimer.Enabled := false;
  grPayers.Enabled := true;
  grPayers.Repaint;
  pnlTemplateHeader.Enabled := true;
  pnlPreview.Enabled := true;
end;

procedure TMassEmailToTaxPayersT1_2026.ThreadStarted;
begin
  FStartTime := Now;
  ThreadTimer.Enabled := true;
  ThreadTimerTimer(ThreadTimer);
  pbProgress.Position := 0;
  pbProgress.Max := QPayers.RecordCount;
  FProcessedCount := 0;
  pnlProgress.Visible := true;
  btnCancel.Visible := false;
  //btnRegister.Width := btnCancel.Left + btnCancel.Width - btnRegister.Left;
  btnRegister.Caption := 'Cancel Email to clients';
  grPayers.Enabled := false;
  grPayers.Repaint;
  pnlTemplateHeader.Enabled := false;
  pnlPreview.Enabled := false;
  lbProgress.Caption := 'Processed 0 of ' + IntToStr(QPayers.RecordCount) + ' records.';
end;

procedure TMassEmailToTaxPayersT1_2026.ThreadTimerTimer(Sender: TObject);
var nElapsedSeconds, nRemainingSeconds: integer;
    ElapsedTime, RemainingTime: TDateTime;
    cCaption: string;
begin
  nElapsedSeconds := SecondsBetween(FStartTime, Now);
  if FProcessedCount = 0 then
    nRemainingSeconds := 0
  else
    nRemainingSeconds := Trunc(nElapsedSeconds / FProcessedCount * (QPayers.RecordCount - FProcessedCount));
  ElapsedTime := 0;
  ElapsedTime := IncSecond(ElapsedTime, nElapsedSeconds);
  RemainingTime := 0;
  RemainingTime := IncSecond(RemainingTime, nRemainingSeconds);
  cCaption := 'Elapsed Time: '+ TimeToStr(ElapsedTime) + '. Remaining Time: ' + TimeToStr(RemainingTime);
  if not SameText(lbTime.Caption, cCaption) then
    lbTime.Caption := cCaption;
end;

procedure TMassEmailToTaxPayersT1_2026.wbPreviewBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if FSkipLinkIntercept then Exit;
  Cancel := true;
  ConnectToWeb(URL);
end;

procedure TMassEmailToTaxPayersT1_2026.wbPreviewCommandStateChange(ASender: TObject;
  Command: Integer; Enable: WordBool);
var Doc: IHTMLDocument2;
    Sel: IHTMLSelectionObject;
    C: TControl;
begin
  if not Assigned(ASender) or not (ASender is TWebBrowser) then
    Exit;
  if TOleEnum(Command) <> CSC_UPDATECOMMANDS then
    Exit;
  Doc := wbPreview.Document as IHTMLDocument2;
  if not Assigned(Doc) then
    Exit;
  Sel := Doc.Selection as IHTMLSelectionObject;
  C := FindVCLWindow(Mouse.CursorPos);
  if Assigned(Sel) and ((Sel.type_ = 'Text') or (C = ASender) or (C = TControl(ASender).Parent)) then
    ActiveControl := wbPreview;
end;

procedure TMassEmailToTaxPayersT1_2026.SaveRecordAndNext(AResult: string;
  AError: boolean);
begin
  QPayers.Edit;
  QPayers.FieldByName('RESULT').Value := AResult;
  QPayers.FieldByName('ERROR').Value := AError;
  QPayers.Post;
  QPayers.Next;
  inc(FProcessedCount);
  pbProgress.Position := FProcessedCount;
  lbProgress.Caption := 'Processed '+ IntToStr(FProcessedCount) + ' of ' + IntToStr(QPayers.RecordCount) + ' records.';
  ThreadTimerTimer(ThreadTimer);
end;

function TMassEmailToTaxPayersT1_2026.SaveWording(
  ATemplate: string): boolean;
var cFile: string;
begin
  Result := false;
  cFile := cbMassEmailWording.Text;
  SaveWordingDialog.InitialDir := FWordingDir;
  SaveWordingDialog.FileName := cFile;
  if not SaveWordingDialog.Execute then Exit;
  cFile := SaveWordingDialog.FileName;
  if not SameText(ExtractFileExt(cFile), '.txt') then
    cFile := cFile + '.txt';
  with TStringList.Create do
  try
    Text := ATemplate;
    SaveToFile(cFile);
    Result := true;
  finally
    Free;
  end;
end;

{ TMassRegisterThread }

constructor TMassRegisterThread.Create(AForm: TMassEmailToTaxPayersT1_2026);
begin
  FForm := AForm;
  inherited Create(false);
end;

procedure TMassRegisterThread.Execute;
var cEmail, cSubject, cWording, cResult: string;
    bResult, bError: boolean;
    FParams: TParamList;
    Res: TJSONObject;
begin
  inherited;
  try
    Synchronize(nil,
          procedure
          begin
            cSubject := FForm.edSubject.Text;
          end);
    FParams := TParamList.Create;
    try
      while not Terminated do
      begin
        cEmail := '';
        cResult := '';
        bResult := false;
        bError := false;

        Synchronize(nil,
          procedure
          begin
            bResult := FForm.GetRecord(cWording, cEmail);
          end);
        if not bResult then
        begin
          Synchronize(nil,
            procedure
            begin
              FForm.ThreadTimer.Enabled := false;
              ShowMessageInfo('Mass Email was successfully finished');
            end);
          Terminate;
        end
        else
        begin
          FParams.Clear;
          FParams.AddParam('action', 'SEND_MASS_EMAIL');
          FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
          FParams.AddParam('Email', cEmail);
          FParams.AddParam('Subject', cSubject);
          FParams.AddParam('Wording', cWording);
          try
            Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, true);
            //20210218 Igor >>>
            try
              if Assigned(Res) then
              begin
                if SameText( GetJSONValue(Res, 'success'), 'true') then
                begin
                  cResult := 'Sent';
                  bError := false;
                end
                else
                begin
                  cResult := GetJSONValue(Res, 'error_message');
                  bError := true;
                end;
              end;
            finally              
              if Assigned(Res) then
                FreeAndNil(Res);              
            end;
            //20210218 Igor <<<
          except on E: Exception do
            begin
              cResult := E.Message;
              bError := true;
            end;
          end;
          Synchronize(nil,
            procedure
            begin
              FForm.SaveRecordAndNext(cResult, bError);
            end);
        end;
      end;
      Synchronize(nil,
        procedure
        begin
          FForm.ThreadFinished;
        end);
    finally
      FParams.Free;
    end;
  except on E: Exception do
    begin
      Synchronize(nil,
        procedure
        begin
          FForm.ThreadTimer.Enabled := false;
          ShowMessageError(E.Message);
          FForm.ThreadFinished;
        end);
    end;
  end;
end;

end.
