unit T1_2026MassEmailToTaxPreparers;

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

  TMassEmailToTaxPreparersT1_2026 = class(TForm)
    pnlCaption: TPanel;
    pnlBottom: TPanel;
    QOffices: TADMemTable;
    grOffices: TDBGrid;
    QOfficesEMAIL: TStringField;
    QOfficesRESULT: TStringField;
    dsOffices: TDataSource;
    QOfficesERROR: TBooleanField;
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
    pnlFilter: TPanel;
    lbWhere: TLabel;
    edWhere: TEdit;
    btnGetTaxPreparers: TButton;
    QOfficesBUSINESS_NAME: TStringField;
    QOfficesCYBERID: TStringField;
    btnShowColumns: TSpeedButton;
    meColumns: TMemo;
    pnlGrid: TPanel;
    sbGrid: TStatusBar;
    cbMassEmailWording: TComboBox;
    Label1: TLabel;
    edSubject: TEdit;
    btnEdit: TSpeedButton;
    SaveWordingDialog: TSaveDialog;
    QOfficesPASSWORD: TStringField;
    procedure FormShow(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure grOfficesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ThreadTimerTimer(Sender: TObject);
    procedure QOfficesAfterScroll(DataSet: TDataSet);
    procedure wbPreviewCommandStateChange(ASender: TObject; Command: Integer;
      Enable: WordBool);
    procedure FormCreate(Sender: TObject);
    procedure wbPreviewBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure btnShowColumnsClick(Sender: TObject);
    procedure btnGetTaxPreparersClick(Sender: TObject);
    procedure cbMassEmailWordingChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject); //20210205 Igor
  private
    { Private declarations }
    FThread: TMassRegisterThread;
    FProcessedCount: integer;
    FStartTime: TDateTime;
    FSkipLinkIntercept: boolean;
    GridRefreshing: boolean;
    FCurrentWording: string;
    procedure ThreadStarted;
    procedure ThreadFinished;
    function GetRecord(var AWording, AEmail: string): boolean;
    procedure SaveRecordAndNext(AResult: string; AError: boolean);
    procedure RefreshPreview;
    procedure InitTableColumns;
    procedure LoadTaxOffices;
    procedure InitWordings;
    function SaveWording(ATemplate: string): boolean; //20210205 Igor
  public
    { Public declarations }
  end;

  TMassRegisterThread = class(TThread)
  private
    FForm: TMassEmailToTaxPreparersT1_2026;
  protected
    procedure Execute; override;
    constructor Create(AForm: TMassEmailToTaxPreparersT1_2026);
  end;

  procedure MassEmailToTaxPreparers;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Common,T1_2026Common2,T1_2026TrimStr,
  T1_2026Declare,T1_2026ChildWinNEW,vtTrimStr,vtShared,vtDatabase,
  vtDialogs,DateUtils;

procedure MassEmailToTaxPreparers;
var FMassEmailToTaxPreparersT1_2026: TMassEmailToTaxPreparersT1_2026;
begin
  FMassEmailToTaxPreparersT1_2026 := TMassEmailToTaxPreparersT1_2026.Create(Screen.ActiveForm);
  try
    FMassEmailToTaxPreparersT1_2026.ShowModal;
  finally
    FMassEmailToTaxPreparersT1_2026.Free;
  end;
end;

{ TMassEmailToTaxPreparersT1_2026 }

procedure TMassEmailToTaxPreparersT1_2026.btnRegisterClick(Sender: TObject);
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
    if QOffices.RecordCount = 0 then
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
    QOffices.First;
    FThread := TMassRegisterThread.Create(Self);
    ThreadStarted;
  end;
end;

procedure TMassEmailToTaxPreparersT1_2026.btnShowColumnsClick(Sender: TObject);
begin
  meColumns.Visible := not meColumns.Visible;
  if meColumns.Visible then
  begin
    btnShowColumns.Caption := 'Hide columns';
    meColumns.Height := CalcTextHeight(meColumns.Font, meColumns.Text, meColumns.ClientWidth - GetSystemMetrics(SM_CYHSCROLL) - 10) + 10;
  end
  else
    btnShowColumns.Caption := 'Show columns';
end;

procedure TMassEmailToTaxPreparersT1_2026.btnEditClick(Sender: TObject); //20210205 Igor
var FHTML, cFile: string;
begin
  FHTML := '';
  if not String(cbMassEmailWording.Text).IsEmpty then
  begin
    cFile := TPath.Combine(AppDir, cbMassEmailWording.Text);
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

procedure TMassEmailToTaxPreparersT1_2026.btnGetTaxPreparersClick(Sender: TObject);
begin
  LoadTaxOffices;
end;

procedure TMassEmailToTaxPreparersT1_2026.cbMassEmailWordingChange(
  Sender: TObject);
begin
  RefreshPreview;
end;

procedure TMassEmailToTaxPreparersT1_2026.FormCreate(Sender: TObject);
begin
  GridRefreshing := false;
  FSkipLinkIntercept := false;
end;

procedure TMassEmailToTaxPreparersT1_2026.FormShow(Sender: TObject);
begin
  InitTableColumns;
  btnShowColumns.Click;
  InitWordings;
end;

function TMassEmailToTaxPreparersT1_2026.GetRecord(var AWording, AEmail: string): boolean;
begin
  Result := false;
  if QOffices.Eof then Exit;
  AWording := FCurrentWording;
  AEmail := QOffices.FieldByName('EMAIL').AsString;
  Result := true;
end;

procedure TMassEmailToTaxPreparersT1_2026.grOfficesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (gdFocused in State) then
  begin
    grOffices.Canvas.Brush.Color := clHighlight;
    grOffices.Canvas.Font.Color := clHighlightText;
  end
  else if QOffices.FieldByName('ERROR').AsBoolean then
    grOffices.Canvas.Brush.Color := Rgb(255, 128, 128)
  else if QOffices.FieldByName('RESULT').AsString.IsEmpty then
    grOffices.Canvas.Brush.Color := clWhite
  else
    grOffices.Canvas.Brush.Color := Rgb(198, 255, 198);
  grOffices.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TMassEmailToTaxPreparersT1_2026.InitTableColumns;
var FParams: TParamList;
    Res: TJSONObject;
begin
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','LIST_OFFICES_COLUMNS');
    FParams.Add(ADMIN_PARAM);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        meColumns.Text := GetJSONValue(Res, 'columns')
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TMassEmailToTaxPreparersT1_2026.InitWordings;  //20210205 Igor
var cSaveCurrWording: string;
    bRestore: boolean;
begin
  cSaveCurrWording := cbMassEmailWording.Text;
  cbMassEmailWording.Text := '';
  cbMassEmailWording.Items.Clear;
  TDirectory.GetFiles(AppDir, 'MassEmailWording*.txt', TSearchOption.soTopDirectoryOnly,
    function(const Path: string; const SearchRec: TSearchRec): Boolean
    begin
      Result := True;
      cbMassEmailWording.Items.Add(SearchRec.Name);
      if SameText(cSaveCurrWording, SearchRec.Name) then
        bRestore := true;
    end);
  cbMassEmailWording.ItemIndex := cbMassEmailWording.Items.IndexOf(cSaveCurrWording);
end;

procedure TMassEmailToTaxPreparersT1_2026.LoadTaxOffices;
var FParams: TParamList;
    Res, Row: TJSONObject;
    Values: TJSONArray;
    ArrayElement: TJSONValue;
begin
  QOffices.Close;
  QOffices.Open;
  QOffices.DisableControls;
  FParams := TParamList.Create;
  GridRefreshing := true;
  try
    FParams.Add('action=LIST_OFFICES_FOR_DESKTOP');
    FParams.Add(ADMIN_PARAM);
    FParams.Add('searchWhere='+ edWhere.Text);
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
              QOffices.Append;
              QOffices.FieldByName('CYBERID').Value := Row.Get('CyberId').JSONValue.Value;
              QOffices.FieldByName('BUSINESS_NAME').Value := Row.Get('BusinessName').JSONValue.Value;
              QOffices.FieldByName('EMAIL').Value := Row.Get('Email').JSONValue.Value;
              QOffices.FieldByName('PASSWORD').Value := Row.Get('Password').JSONValue.Value;
              QOffices.FieldByName('RESULT').Value := '';
              QOffices.FieldByName('ERROR').Value := false;
              QOffices.Post;
            end;
        end;
      end
      else
        ShowMessage(Res.Get('error_message').JSONValue.Value);
    end;
  finally
    FParams.Free;
    QOffices.First;
    QOffices.EnableControls;
    GridRefreshing := false;
    QOfficesAfterScroll(nil);
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TMassEmailToTaxPreparersT1_2026.QOfficesAfterScroll(DataSet: TDataSet);
begin
  if GridRefreshing then Exit;
  if QOffices.RecordCount = 0 then
    sbGrid.Panels[0].Text := '0 : 0'
  else
    sbGrid.Panels[0].Text := IntToStr(QOffices.RecNo) + ' : ' + IntToStr(QOffices.RecordCount);
  pnlPreview.Enabled := false;
  RefreshPreview;
  pnlPreview.Enabled := true;
end;

procedure TMassEmailToTaxPreparersT1_2026.RefreshPreview;
var FHTML, FBusinessName, FCyberId, FPassword: string; //20210208 Igor
    Doc: Variant;
    cFile: string;
begin
  if GridRefreshing then Exit;
  FHTML := '';
  if not String(cbMassEmailWording.Text).IsEmpty then
  begin
    cFile := TPath.Combine(AppDir, cbMassEmailWording.Text);
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

  FBusinessName := '';
  FCyberId := '';
  FPassword := ''; //20210208 Igor
  if QOffices.RecordCount > 0 then
  begin
    FBusinessName := QOffices.FieldByName('BUSINESS_NAME').AsString;
    FCyberId := QOffices.FieldByName('CYBERID').AsString;
    FPassword := QOffices.FieldByName('PASSWORD').AsString; //20210208 Igor
  end;
  FHTML := FHTML.Replace('[DATE]', formatdatetime('yyyy-mm-dd', Date));
  FHTML := FHTML.Replace('[COMPANY_NAME]', FBusinessName);
  FHTML := FHTML.Replace('[VIRTUAL_ID]', FCyberId);
  FHTML := FHTML.Replace('[PASSWORD]', FPassword); //20210208 Igor

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

procedure TMassEmailToTaxPreparersT1_2026.ThreadFinished;
begin
  pnlProgress.Visible := false;
  btnCancel.Visible := true;
  //btnRegister.Width := btnCancel.Width;
  btnRegister.Caption := 'Send Email to clients';
  btnRegister.Enabled := true;
  FThread := nil;
  ThreadTimer.Enabled := false;
  grOffices.Enabled := true;
  grOffices.Repaint;
  pnlTemplateHeader.Enabled := true;
  pnlPreview.Enabled := true;
end;

procedure TMassEmailToTaxPreparersT1_2026.ThreadStarted;
begin
  FStartTime := Now;
  ThreadTimer.Enabled := true;
  ThreadTimerTimer(ThreadTimer);
  pbProgress.Position := 0;
  pbProgress.Max := QOffices.RecordCount;
  FProcessedCount := 0;
  pnlProgress.Visible := true;
  btnCancel.Visible := false;
  //btnRegister.Width := btnCancel.Left + btnCancel.Width - btnRegister.Left;
  btnRegister.Caption := 'Cancel Email to clients';
  grOffices.Enabled := false;
  grOffices.Repaint;
  pnlTemplateHeader.Enabled := false;
  pnlPreview.Enabled := false;
  lbProgress.Caption := 'Processed 0 of ' + IntToStr(QOffices.RecordCount) + ' records.';
end;

procedure TMassEmailToTaxPreparersT1_2026.ThreadTimerTimer(Sender: TObject);
var nElapsedSeconds, nRemainingSeconds: integer;
    ElapsedTime, RemainingTime: TDateTime;
    cCaption: string;
begin
  nElapsedSeconds := SecondsBetween(FStartTime, Now);
  if FProcessedCount = 0 then
    nRemainingSeconds := 0
  else
    nRemainingSeconds := Trunc(nElapsedSeconds / FProcessedCount * (QOffices.RecordCount - FProcessedCount));
  ElapsedTime := 0;
  ElapsedTime := IncSecond(ElapsedTime, nElapsedSeconds);
  RemainingTime := 0;
  RemainingTime := IncSecond(RemainingTime, nRemainingSeconds);
  cCaption := 'Elapsed Time: '+ TimeToStr(ElapsedTime) + '. Remaining Time: ' + TimeToStr(RemainingTime);
  if not SameText(lbTime.Caption, cCaption) then
    lbTime.Caption := cCaption;
end;

procedure TMassEmailToTaxPreparersT1_2026.wbPreviewBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if FSkipLinkIntercept then Exit;
  Cancel := true;
  ConnectToWeb(URL);
end;

procedure TMassEmailToTaxPreparersT1_2026.wbPreviewCommandStateChange(ASender: TObject;
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

procedure TMassEmailToTaxPreparersT1_2026.SaveRecordAndNext(AResult: string;
  AError: boolean);
begin
  QOffices.Edit;
  QOffices.FieldByName('RESULT').Value := AResult;
  QOffices.FieldByName('ERROR').Value := AError;
  QOffices.Post;
  QOffices.Next;
  inc(FProcessedCount);
  pbProgress.Position := FProcessedCount;
  lbProgress.Caption := 'Processed '+ IntToStr(FProcessedCount) + ' of ' + IntToStr(QOffices.RecordCount) + ' records.';
  ThreadTimerTimer(ThreadTimer);
end;

function TMassEmailToTaxPreparersT1_2026.SaveWording( //20210205 Igor
  ATemplate: string): boolean;
var cFile: string;
begin
  Result := false;
  cFile := cbMassEmailWording.Text;
  SaveWordingDialog.InitialDir := AppDir;
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

constructor TMassRegisterThread.Create(AForm: TMassEmailToTaxPreparersT1_2026);
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
          FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
          FParams.Add(ADMIN_PARAM);
          FParams.AddParam('MassEmailToTaxPreparers', 'true');
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
