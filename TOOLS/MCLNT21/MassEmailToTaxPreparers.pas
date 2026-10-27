unit MassEmailToTaxPreparers;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls, Menus, DB, ShellApi,
  DBGrids, ComCtrls, OleCtrls, SHDocVw, MSHTML, ActiveX,
  vtEditHTML, FileCtrl, Psock, NMHttp, NMURL, DBTables;

const
  //HOST = 'http://192.168.1.147/VirtualTaxOffice/api.php';
  HOST = 'http://www.virtualofficetower.com/api.php'; 

type
  TMassRegisterThread = class;

  TMassEmailToTaxPreparers = class(TForm)
    pnlCaption: TPanel;
    pnlBottom: TPanel;
    grOffices: TDBGrid;
    dsOffices: TDataSource;
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
    btnShowColumns: TSpeedButton;
    meColumns: TMemo;
    pnlGrid: TPanel;
    sbGrid: TStatusBar;
    cbMassEmailWording: TComboBox;
    Label1: TLabel;
    edSubject: TEdit;
    btnEdit: TSpeedButton;
    SaveWordingDialog: TSaveDialog;
    QClients: TQuery;
    btnNew: TSpeedButton;
    QOffices: TQuery;
    procedure FormShow(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure grOfficesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ThreadTimerTimer(Sender: TObject);
    procedure QOfficesAfterScroll(DataSet: TDataSet);
    procedure wbPreviewCommandStateChange(ASender: TObject; Command: Integer;
      Enable: WordBool);
    procedure FormCreate(Sender: TObject);
    procedure btnShowColumnsClick(Sender: TObject);
    procedure btnGetTaxPreparersClick(Sender: TObject);
    procedure cbMassEmailWordingChange(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure wbPreviewBeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
  private
    { Private declarations }
    FThread: TMassRegisterThread;
    FProcessedCount: integer;
    FStartTime: TDateTime;
    FSkipLinkIntercept: boolean;
    GridRefreshing: boolean;
    FCurrentWording: string;
    FWordingFolder: string;
    procedure ThreadStarted;
    procedure ThreadFinished;
    function GetRecord(var AWording, AEmail: string): boolean;
    procedure SaveRecordAndNext(AResult: string; AError: boolean);
    procedure RefreshPreview;
    procedure InitTableColumns;
    procedure LoadTaxOffices;
    procedure InitWordings;
    procedure InitTempTable;
    function SaveWording(ATemplate: string): boolean;
  public
    { Public declarations }
  end;

  TMassRegisterThread = class(TThread)
  private
    FForm: TMassEmailToTaxPreparers;
    cEmail, cSubject, cWording, cResult, cErrorMessage: string;
    bResult, bError: boolean;
    procedure GetSubject;
    procedure GetRecord;
    procedure Finish;
    procedure SaveRecordAndNext;
    procedure ThreadFinished;
    procedure ShowError;
  protected
    procedure Execute; override;
    constructor Create(AForm: TMassEmailToTaxPreparers);
  end;

  procedure ShowMassEmailToTaxPreparers;

implementation

{$R *.DFM}

const
  HoursPerDay   = 24;
  MinsPerHour   = 60;
  SecsPerMin    = 60;
  MSecsPerSec   = 1000;
  MinsPerDay    = HoursPerDay * MinsPerHour;
  SecsPerDay    = MinsPerDay * SecsPerMin;
  SecsPerHour   = SecsPerMin * MinsPerHour;
  MSecsPerDay   = SecsPerDay * MSecsPerSec;

function DateTimeToMilliseconds(const ADateTime: TDateTime): Int64;
var
  LTimeStamp: TTimeStamp;
begin
  LTimeStamp := DateTimeToTimeStamp(ADateTime);
  Result := LTimeStamp.Date;
  Result := (Result * MSecsPerDay) + LTimeStamp.Time;
end;  

function IncMilliSecond(const AValue: TDateTime;
  const ANumberOfMilliSeconds: Int64 = 1): TDateTime;
var
  TS: TTimeStamp;
  TempTime: Comp;
begin
  TS := DateTimeToTimeStamp(AValue);
  TempTime := TimeStampToMSecs(TS);
  TempTime := TempTime + ANumberOfMilliSeconds;
  TS := MSecsToTimeStamp(TempTime);
  Result := TimeStampToDateTime(TS);
end;

function IncSecond(const AValue: TDateTime;
  const ANumberOfSeconds: Int64 = 1): TDateTime;
begin
  Result := IncMilliSecond(Avalue, ANumberOfSeconds * MSecsPerSec);
end;

function SecondsBetween(const ANow, AThen: TDateTime): Int64;
begin
  Result := Abs(DateTimeToMilliseconds(ANow) - DateTimeToMilliseconds(AThen))
    div (MSecsPerSec);
end;

procedure ShowMassEmailToTaxPreparers;
var FMassEmailToTaxPreparers: TMassEmailToTaxPreparers;
begin
  FMassEmailToTaxPreparers := TMassEmailToTaxPreparers.Create(Screen.ActiveForm);
  try
    FMassEmailToTaxPreparers.ShowModal;
  finally
    FMassEmailToTaxPreparers.Free;
  end;
end;

{ TMassEmailToTaxPreparers }

procedure TMassEmailToTaxPreparers.btnRegisterClick(Sender: TObject);
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
      ShowMessage('There is no clients to register');
      Exit;
    end;
    if FCurrentWording = '' then
    begin
      ShowMessage('Email wording is empty');
      Exit;
    end;
    if edSubject.Text = '' then
    begin
      ShowMessage('Email Subject is empty');
      Exit;
    end;
    if MessageDlg('Program will sent emails to all offices from the list.'+ Chr(13)+'Are you sure ?',
            mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    QOffices.First;
    FThread := TMassRegisterThread.Create(Self);
    ThreadStarted;
  end; 
end;

procedure TMassEmailToTaxPreparers.btnShowColumnsClick(Sender: TObject);
  function CalcTextHeight(AFont: TFont; AText: string; AWidth: integer): integer;
  var
    B: TBitmap;
    R: TRect;
    L: TStringList;
    cNewStr, cWord: string;
    I, J, nEnd: integer;
  begin
    B := TBitmap.Create;
    L := TStringList.Create;
    try
      B.Width := 300;
      B.Height := 300;
      B.Canvas.Font.Assign(AFont);
      B.Canvas.Font.Style := [];
      cNewStr := '';
      L.Text := StringReplace(AText, ' ', #13#10, [rfReplaceAll]);
      for I := 0 to L.Count - 1 do
      begin
        cWord := L.Strings[I];
        while True do
        begin
          if B.Canvas.TextWidth(cWord) > AWidth then
          begin
            nEnd := Length(cWord);
            for J := 1 to Length(cWord) do
              if B.Canvas.TextWidth(Copy(cWord, 1, J)) > AWidth then
              begin
                nEnd := J - 1;
                break;
              end;
            if cNewStr <> '' then
              cNewStr := cNewStr + ' ';
            cNewStr := cNewStr + Copy(cWord, 1, nEnd);
            cWord := Copy(cWord, nEnd + 1, Length(cWord));
          end
          else
            break;
        end;
        if cNewStr <> '' then
          cNewStr := cNewStr + ' ';
        cNewStr := cNewStr + cWord;
      end;

      R := Rect(0, 0, AWidth, 0);
      DrawText(B.Canvas.Handle, PChar(cNewStr), Length(cNewStr), R, DT_CENTER or DT_WORDBREAK or DT_CALCRECT);

      Result := R.Bottom - R.Top;
    finally
      B.Free;
      L.Free;
    end;
  end;

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

procedure TMassEmailToTaxPreparers.btnEditClick(Sender: TObject);
var FHTML, cFile: string;
begin
  FHTML := '';
  if cbMassEmailWording.Text <> '' then
  begin
    cFile := FWordingFolder + cbMassEmailWording.Text;
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

procedure TMassEmailToTaxPreparers.btnNewClick(Sender: TObject);
var FHTML, cFile: string;
begin
  FHTML := '';
  if RunEditHTML(FHTML, SaveWording) then
  begin
    InitWordings;
    RefreshPreview;
  end;
end;

procedure TMassEmailToTaxPreparers.btnGetTaxPreparersClick(Sender: TObject);
begin
  LoadTaxOffices;
end;

procedure TMassEmailToTaxPreparers.cbMassEmailWordingChange(
  Sender: TObject);
begin
  RefreshPreview;
end;

procedure TMassEmailToTaxPreparers.FormCreate(Sender: TObject);
begin
  GridRefreshing := false;
  FSkipLinkIntercept := false;
end;

procedure TMassEmailToTaxPreparers.FormShow(Sender: TObject);
begin
  InitTempTable;
  FWordingFolder := ExtractFilePath(Application.ExeName) + 'MassEmailWordings\';
  ForceDirectories(FWordingFolder);
  InitTableColumns;
  btnShowColumns.Click;
  InitWordings;
end;

function TMassEmailToTaxPreparers.GetRecord(var AWording, AEmail: string): boolean;
begin
  Result := false;
  if QOffices.Eof then Exit;
  AWording := FCurrentWording;
  AEmail := QOffices.FieldByName('EMAIL').AsString;
  Result := true;
end;

procedure TMassEmailToTaxPreparers.grOfficesDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (gdFocused in State) then
  begin
    grOffices.Canvas.Brush.Color := clHighlight;
    grOffices.Canvas.Font.Color := clHighlightText;
  end
  else if QOffices.FieldByName('ERROR').AsBoolean then
    grOffices.Canvas.Brush.Color := Rgb(255, 128, 128)
  else if QOffices.FieldByName('RESULT').AsString = '' then
    grOffices.Canvas.Brush.Color := clWhite
  else
    grOffices.Canvas.Brush.Color := Rgb(198, 255, 198);
  grOffices.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TMassEmailToTaxPreparers.InitTableColumns;
var I: integer;
    cColumns: string;
begin
  QClients.Close;
  QClients.SQL.Text := 'Select * from Clients where 1 = 0';
  QClients.Prepare;
  QClients.Open;
  cColumns := '';
  for I := 0 to QClients.FieldCount - 1 do
  begin
    if cColumns <> '' then
      cColumns := cColumns + ', ';
    cColumns := cColumns + QClients.Fields[I].FieldName; 
  end;
  meColumns.Text := cColumns;
  QClients.Close;
end;

procedure TMassEmailToTaxPreparers.InitWordings;
var cSaveCurrWording: string;
    bRestore: boolean;
    searchResult: TSearchRec;
begin
  cSaveCurrWording := cbMassEmailWording.Text;
  cbMassEmailWording.Text := '';
  cbMassEmailWording.Items.Clear;
  if FindFirst(FWordingFolder+'\*.txt', faAnyFile, searchResult) = 0 then
  begin
    try
      repeat
        if (searchResult.Attr and faDirectory) = 0 then
        begin
          cbMassEmailWording.Items.Add(searchResult.Name);
          if SameText(cSaveCurrWording, searchResult.Name) then
            bRestore := true;
        end;
      until FindNext(searchResult) <> 0
    finally
      SysUtils.FindClose(searchResult);
    end;
  end; 
  cbMassEmailWording.ItemIndex := cbMassEmailWording.Items.IndexOf(cSaveCurrWording);
end;

procedure TMassEmailToTaxPreparers.LoadTaxOffices;
var cWhere: string;
begin
  QOffices.DisableControls;
  GridRefreshing := true;
  try
    QOffices.Close;
    QOffices.SQL.Text := 'DELETE FROM TEMP';
    QOffices.ExecSQL;
    QOffices.Close;
    QOffices.SQL.Text := 'SELECT * FROM TEMP';
    QOffices.Open;
    QClients.Close;
    QClients.SQL.Clear;
    QClients.SQL.Add('Select * from Clients');
    cWhere := Trim(edWhere.Text);
    if cWhere <> '' then
    begin
      if LowerCase(Copy(cWhere, 1, 6)) <> 'where ' then
        cWhere := 'where ' + cWhere;
      QClients.SQL.Add(cWhere);
    end;
    QClients.SQL.Add( 'ORDER BY Name');
    QClients.Prepare;
    QClients.Open;
    while not QClients.Eof do
    begin
      if QClients.FieldByName('Email').AsString <> '' then
      begin
        QOffices.Append;
        QOffices.FieldByName('NAME').Value := QClients.FieldByName('Name').AsString;
        QOffices.FieldByName('EMAIL').Value := QClients.FieldByName('Email').AsString;
        QOffices.FieldByName('RESULT').Value := '';
        QOffices.FieldByName('ERROR').Value := false;
        QOffices.Post;
      end;
      QClients.Next;
    end;
    QClients.Close;
  finally
    QOffices.First;
    QOffices.EnableControls;
    GridRefreshing := false;
    QOfficesAfterScroll(nil);
  end;
end;

procedure TMassEmailToTaxPreparers.QOfficesAfterScroll(DataSet: TDataSet);
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

procedure TMassEmailToTaxPreparers.RefreshPreview;
var FHTML, FName: string; 
    Doc: Variant;
    cFile: string;
begin
  if not QOffices.Active then Exit;
  if QOffices.RecordCount = 0 then Exit;
  if GridRefreshing then Exit;
  FHTML := '';
  if cbMassEmailWording.Text <> '' then
  begin
    cFile := FWordingFolder + cbMassEmailWording.Text;
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

  FName := '';
  if QOffices.RecordCount > 0 then
    FName := QOffices.FieldByName('NAME').AsString;
  FHTML := StringReplace(FHTML, '[DATE]', formatdatetime('yyyy-mm-dd', Date), [rfReplaceAll]);
  FHTML := StringReplace(FHTML, '[COMPANY_NAME]', FName, [rfReplaceAll]);

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

procedure TMassEmailToTaxPreparers.ThreadFinished;
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

procedure TMassEmailToTaxPreparers.ThreadStarted;
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

procedure TMassEmailToTaxPreparers.ThreadTimerTimer(Sender: TObject);
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

procedure TMassEmailToTaxPreparers.wbPreviewBeforeNavigate2(
  Sender: TObject; const pDisp: IDispatch; var URL, Flags, TargetFrameName,
  PostData, Headers: OleVariant; var Cancel: WordBool);

  function ConnectToWeb(const Url: string): Boolean;
  var
    h: THandle;
  begin
    Result := True;
    Screen.Cursor := crHourGlass;
    h := ShellExecute(Application.MainForm.Handle, 'open', Pchar('' + Url), nil, nil, Sw_Show);
    Screen.Cursor := crDefault;
    if H <= 32 then
    begin ShowMessage('Connection failed');
      Result := False;
    end;
  end;

begin
  if FSkipLinkIntercept then Exit;
  Cancel := true;
  ConnectToWeb(URL);
end;

procedure TMassEmailToTaxPreparers.wbPreviewCommandStateChange(ASender: TObject;
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

procedure TMassEmailToTaxPreparers.SaveRecordAndNext(AResult: string;
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

function TMassEmailToTaxPreparers.SaveWording( //20210205 Igor
  ATemplate: string): boolean;
var cFile: string;
begin
  Result := false;
  cFile := cbMassEmailWording.Text;
  SaveWordingDialog.InitialDir := FWordingFolder;
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

procedure TMassEmailToTaxPreparers.InitTempTable;
var FTable: TTable;
begin
  if FileExists('TEMP.DBF') then
    DeleteFile('TEMP.DBF');
  FTable := TTable.Create(nil);
  try
    with FTable do
    begin
      Active := False;
      TableType := ttDBase;
      TableName := 'TEMP';
      FieldDefs.Clear;
      with FieldDefs do
      begin
        with AddFieldDef do
        begin
          Name := 'NAME';
          DataType := ftString;
          Size := 255;
        end;
        with AddFieldDef do
        begin
          Name := 'EMAIL';
          DataType := ftString;
          Size := 255;
        end;
        with AddFieldDef do
        begin
          Name := 'RESULT';
          DataType := ftString;
          Size := 255;
        end;
        with AddFieldDef do
        begin
          Name := 'ERROR';
          DataType := ftBoolean;
        end;
        CreateTable;
      end;
    end;
  finally
    FTable.Free;
  end;
end;

{ TMassRegisterThread }

constructor TMassRegisterThread.Create(AForm: TMassEmailToTaxPreparers);
begin
  FForm := AForm;
  inherited Create(false);
end;

procedure TMassRegisterThread.GetSubject;
begin
  cSubject := FForm.edSubject.Text;
end;

procedure TMassRegisterThread.GetRecord;
begin
  bResult := FForm.GetRecord(cWording, cEmail);
end;

procedure TMassRegisterThread.Finish;
begin
  FForm.ThreadTimer.Enabled := false;
  ShowMessage('Mass Email was successfully finished');
end;

procedure TMassRegisterThread.SaveRecordAndNext;
begin
  FForm.SaveRecordAndNext(cResult, bError);
end;

procedure TMassRegisterThread.ThreadFinished;
begin
  FForm.ThreadFinished;
end;

procedure TMassRegisterThread.ShowError;
begin
  FForm.ThreadTimer.Enabled := false;
  ShowMessage(cErrorMessage);
  FForm.ThreadFinished;
end;

procedure TMassRegisterThread.Execute;
var FHTTP: TNMHTTP;
    FURL: TNMURL;
    cParams, cFile, cResponse: string;
    PostData: TStringList;

    procedure AddParam(AParam, AValue: string);
    begin
      if cParams <> '' then
        cParams := cParams + '&';
      FUrl.InputString := AValue;
      cParams := cParams + AParam + '=' + FUrl.Encode;
    end;

    function GetNodeValue(ANode, AText: string): string;
    var nStart, nEnd: integer;
    begin
      Result := '';
      nStart := Pos('<' + ANode + '>', AText);
      if nStart = -1 then Exit;
      nStart := nStart + Length(ANode) + 2;
      nEnd := Pos('</' + ANode + '>', AText);
      if nEnd = -1 then Exit;
      Result := Copy(AText, nStart, nEnd - nStart);
    end;
begin
  try
    Synchronize(GetSubject);
    FHTTP := TNMHTTP.Create(nil);
    FURL := TNMURL.Create(nil);
    PostData := TStringList.Create;
    cFile := 'mass_email.txt';
    try
      FHTTP.Host := HOST;
      FHTTP.OutputFileMode := true;
      while not Terminated do
      begin
        cEmail := '';
        cResult := '';
        bResult := false;
        bError := false;

        Synchronize(GetRecord);
        if not bResult then
        begin
          Synchronize(Finish);
          Terminate;
        end
        else
        begin
          try
            cParams := '';
            AddParam('action', 'SEND_MASS_EMAIL');
            AddParam('Microsophic', 'Igor');
            AddParam('MassEmailToTaxPreparers', 'true');
            AddParam('response_type', 'xml');
            AddParam('Email', cEmail);
            AddParam('Subject', cSubject);
            AddParam('Wording', cWording);
            PostData.Text := cParams;
            PostData.SaveToFile(cFile);
            FHTTP.Post(HOST, cFile);
            cResponse := FHTTP.Body;
            if LowerCase(GetNodeValue('success', cResponse)) = 'true' then
            begin
              cResult := 'Sent';
              bError := false;
            end
            else
            begin
              cResult := GetNodeValue('error_message', cResponse);
              bError := true;
            end;

          except on E: Exception do
            begin
              cResult := E.Message;
              bError := true;
            end;
          end;
          Synchronize(SaveRecordAndNext);
        end;
      end;
      Synchronize(ThreadFinished);
    finally
      FHTTP.Free;
      FURL.Free;
      PostData.Free;
    end;
  except on E: Exception do
    begin
      cErrorMessage := E.Message;
      Synchronize(ShowError);
    end;
  end;
end;

end.
