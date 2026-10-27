unit T1_2026DataExtract;

interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,

  vtMulti, vteditbox, vtFileStorage,

  Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls, Vcl.CheckLst, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.ComCtrls, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, Data.DB, uADCompClient, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, Vcl.ImgList, Vcl.Menus,
  vtReportBuilderExport, vtReportBuilderFilter, vtScrollBox, vtDragAndDrop,
  vtCashedData,
  System.Generics.Collections, System.Generics.Defaults;

type
  TForClose = record
    aRecNo: integer;
    Dir: string;
    Name: string;
  end;
  TfrmDataExtract = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnClose: TBitBtn;
    conClients: TADConnection;
    tblClients: TADTable;
    rgExportMode: TRadioGroup;
    btnSelectDir: TButton;
    Label1: TLabel;
    edtExportDir: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edtImport: TEdit;
    btnOpenImportDir: TButton;
    cbImportSelect: TCheckListBox;
    Label3: TLabel;
    btnSelectCurrent: TButton;
    btSelectOpened: TButton;
    btnSelectAll: TButton;
    btnImportnotOpen: TButton;
    btnImportOpen: TButton;
    sbMain: TStatusBar;
    btnAbort: TBitBtn;
    pgMain: TPageControl;
    tsExport: TTabSheet;
    tsImport: TTabSheet;
    btnRefresh: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectDirClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnOpenImportDirClick(Sender: TObject);
    procedure btnSelectCurrentClick(Sender: TObject);
    procedure btSelectOpenedClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
    procedure btnImportnotOpenClick(Sender: TObject);
    procedure btnImportOpenClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    errStr: string;
    FLastError: TStringList;
    FRetNoForClose: TList<TForClose>;
    FAbort: boolean;
    pgrbar: TProgressBar;
    FApp: TApp;
    FCashedReturns: TCashedReturns;
    FSSQLite: TSQLiteStorage;
    FS: TFileStorage;
    FCalculated: boolean;
    FLocalRetList: TStringList;
    function ReadFirstData(aFrom: string): string;
    function ReadSecondData(aFrom: string): string;
    procedure UpdateData(isOpen: boolean);
    function PrepareUpdateData(isOpen: boolean): boolean;
    procedure InitImportData;
  public
    { Public declarations }
  end;

procedure DataExtract(AApp: TApp);

implementation

uses
  {$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON}, vtDataBase, vtShared, vtTrimStr, vtCommon,//20170811 Igor
  Xml.XMLIntf, Xml.XMLDoc, ComObj, ActiveX,
  T1_2026TrimStr, System.IOUtils, T1_2026, T1_2026common2, T1_2026Common, System.StrUtils,
  vtChild, vtMain;
{$R *.dfm}

procedure DataExtract(AApp: TApp);
begin
  with TfrmDataExtract.Create(Application) do
  begin
    try
       FApp := AApp;
       ShowModal;
    finally
      free;
    end;
  end;
end;

{ TfrmDataExtract }

procedure TfrmDataExtract.btnAbortClick(Sender: TObject);
begin
  FAbort := True;
end;

procedure TfrmDataExtract.btnImportnotOpenClick(Sender: TObject);
var
  i: Integer;
begin
  UpdateData(False);
end;

procedure TfrmDataExtract.btnImportOpenClick(Sender: TObject);
begin
  UpdateData(True);
end;

procedure TfrmDataExtract.btnOpenImportDirClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edtImport.Text;
  if FileCtrl.SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
    edtImport.Text := Dir;
  InitImportData;
end;

procedure TfrmDataExtract.btnRefreshClick(Sender: TObject);
begin
  InitImportData;
end;

procedure TfrmDataExtract.btnSelectDirClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edtExportDir.Text;
  if FileCtrl.SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt], 0) then
    edtExportDir.Text := Dir;
end;

procedure TfrmDataExtract.btnStartClick(Sender: TObject);
var
  Total: Integer;
procedure DataExtract(aApp: TRetData; aRet: TCashedReturn);
  function GetValue(RetNo: integer; FName: string; ElmNo: integer): string;
  begin
    if Assigned(aApp) then
      Result := FetchElm(RetNo, FName, ElmNo)
    else
      Result := aRet.GetValue(FName, ['O','D','M'], ElmNo);
  end;
  function ExpandData(s: string): string;
  begin
    Result := s;
    if Length(s) > 5 then
      Result := Result + ' '
    else
      while Length(Result) < 5 do
        Result := Result + ' ';
  end;
var
  aSL, aOutSL: TStringList;
  i, num: integer;
  s: string;
  CurrentForm: string;
  RetNo: integer;
begin
  if Assigned(aApp) then begin
    if aApp.MyApp.AppId <> 'T1-2017' then
      Exit;
    RetNo := aApp.RetNo;
  end else
    RetNo := 0;
  aSL := TStringList.Create;
  aOutSL := TStringList.Create;
  CurrentForm := '';
  try
    aSL.LoadFromFile(FApp.AppDir +'\dataextr.d');
    for I := 0 to aSL.Count - 1 do
    begin
      num := -1;
      s := ReadFirstData(aSL[i]);
      if trim(s) = 'SIN' then
        aOutSL.Add(ExpandData(s) + GetValue(RetNo,'INFO',3))
      else
      if LowerCase(Trim(s)) = 'form' then
      begin
        CurrentForm := ReadSecondData(aSL[i]);
        aOutSL.Add(aSL[i]);
      end
      else
      if not TryStrToInt(trim(s), num) then
        aOutSL.Add(aSL[i])
      else
      begin
        if (num <> -1) and (CurrentForm <> '') then
          aOutSL.Add(ExpandData(s) + GetValue(RetNo, CurrentForm, num))
      end;
    end;
    aOutSL.SaveToFile(edtExportDir.Text + '\' + GetValue(RetNo,'INFO',3) + 'ExtractedVtData.txt');
    inc(Total);
  finally
    aSL.Free;
    aOutSL.Free;
  end;
end;
var
  i: integer;
  cret: TCashedReturn;
begin
  FAbort := False;
  edtExportDir.Text := trim(edtExportDir.Text);
  if edtExportDir.Text = '' then
  begin
    ShowMessage('Select export directory please.');
    Exit;
  end;
  if not ForceDirectories(edtExportDir.Text) then
  begin
    MessageDlg(SysErrorMessage(GetLastError), mtError, [mbOk], 0);
    Exit;
  end;
  Total := 0;
  btnAbort.Visible := True;
  try
    case rgExportMode.ItemIndex of
      0: begin
           if GetCurrentRetNo < 1 then
           begin
             ShowMessage('You must open a return first');
             Exit;
           end;
           DataExtract(RetList[GetCurrentRetNo], nil);
         end;
      1: begin
           pgrbar.Max := RetList.Count - 1;
           for I := 1 to RetList.Count - 1 do
           begin
             if Assigned(RetList[I]) and (not RetList[I].Destroying) then
             begin
               pgrbar.Position := i;
               DataExtract(RetList[i], nil);
               Application.ProcessMessages;
               if FAbort and (MessageDlg('Stop process?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
                 Exit
               else
                 FAbort := False;
             end;
           end;
         end;
      2: begin
          if not SetTableName(conClients, tblClients, IncludeTrailingPathDelimiter(FApp.Dir_Cur) + FApp.ClientsDBLite,
            ClientsTableLite, '', false) then
          begin
            tblClients.Close;
            Exit;
          end;
          pgrbar.Max := tblClients.RecordCount;
          pgrbar.Position := 0;
          tblClients.First;
          FSSQLite := nil;
          FS := nil;
          while not tblClients.Eof do
          begin
            pgrbar.Position := pgrbar.Position + 1;
            if FileExists(IncludeTrailingPathDelimiter(FApp.Dir_Cur) + tblClients.FieldByName('FILE_NAME').AsString) then
            begin
              FSSQLite := TSQLiteStorage.Create(FApp.Dir_Cur, tblClients.FieldByName('FILE_NAME').AsString, fsRead, FApp.SQLLitePassword.PassRFArray);
              if FSSQLite.LastError <> '' then
              begin
                FreeAndNil(FSSQLite);
                try
                  FS := TFileStorage.Create(FApp.Dir_Cur, tblClients.FieldByName('FILE_NAME').AsString, fsRead);
                except
                  FreeAndNil(FS);
                end;
              end;
            end;
            try
              if (Assigned(FSSQLite) or Assigned(FS)) then
              begin
                cret := FCashedReturns.AddCashedReturn(tblClients.FieldByName('FILE_NAME').AsString);
                CashReturn(cret, FSSQLite, FS);
                DataExtract(nil, cret);
                Application.ProcessMessages;
                if FAbort and (MessageDlg('Stop process?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
                  Exit
                else
                  FAbort := False;
              end;
            finally
              FreeAndNil(FSSQLite);
              FreeAndNil(FS);
            end;
            tblClients.Next;
          end;
          FCashedReturns.Clear;
      end;
    end;
    MessageDlg('Done!' + #13#10 +
               IntToStr(Total) + ' file(s) exported.', mtInformation, [mbOk], 0);
  finally
    pgrbar.Position := 0;
    btnAbort.Visible := False;
  end;
end;

procedure TfrmDataExtract.btnSelectCurrentClick(Sender: TObject);
var
  i: integer;
  SIN: integer;
begin
  if GetCurrentRetNo < 1 then
  begin
    ShowMessage('You must open a return first');
    Exit;
  end;
  if not TryStrToInt(FetchElm(GetCurrentRetNo, 'INFO', 3), SIN) then
  begin
    ShowMessage('Wrong SIN in current return');
    Exit;
  end;

  for I := 0 to cbImportSelect.Items.Count - 1 do
    cbImportSelect.Checked[i] := cbImportSelect.Items.Objects[i] = TObject(SIN);
end;

procedure TfrmDataExtract.btSelectOpenedClick(Sender: TObject);
var
  i, l: integer;
  SIN: integer;
begin
  for I := 0 to cbImportSelect.Items.Count - 1 do
    cbImportSelect.Checked[i] := False;

  for l := 1 to RetList.Count - 1 do
  begin
    if Assigned(RetList[l]) and (not RetList[l].Destroying) then
    begin
      if TryStrToInt(FetchElm(RetList[l].RetNo, 'INFO', 3), SIN) then
        for I := 0 to cbImportSelect.Items.Count - 1 do
          if cbImportSelect.Items.Objects[i] = TObject(SIN) then
          begin
            cbImportSelect.Checked[i] := True;
            break;
          end;
    end;
  end;
end;

procedure TfrmDataExtract.btnSelectAllClick(Sender: TObject);
var
  i: integer;
  cret: TCashedReturn;
  SIN: integer;
begin
  for I := 0 to cbImportSelect.Items.Count - 1 do
    cbImportSelect.Checked[i] := False;
  if not SetTableName(conClients, tblClients, IncludeTrailingPathDelimiter(FApp.Dir_Cur) + FApp.ClientsDBLite,
    ClientsTableLite, '', false) then
  begin
    tblClients.Close;
    Exit;
  end;

  tblClients.First;
  FSSQLite := nil;
  FS := nil;
  while not tblClients.Eof do
  begin
    if FileExists(IncludeTrailingPathDelimiter(FApp.Dir_Cur) + tblClients.FieldByName('FILE_NAME').AsString) then
    begin
      FSSQLite := TSQLiteStorage.Create(FApp.Dir_Cur, tblClients.FieldByName('FILE_NAME').AsString, fsRead, FApp.SQLLitePassword.PassRFArray);
      if FSSQLite.LastError <> '' then
      begin
        FreeAndNil(FSSQLite);
        try
          FS := TFileStorage.Create(FApp.Dir_Cur, tblClients.FieldByName('FILE_NAME').AsString, fsRead);
        except
          FreeAndNil(FS);
        end;
      end;
    end;
    try
      if (Assigned(FSSQLite) or Assigned(FS)) then
      begin
        cret := FCashedReturns.AddCashedReturn(tblClients.FieldByName('FILE_NAME').AsString);
        CashReturn(cret, FSSQLite, FS);
        if TryStrToInt(cret.GetValue('INFO', ['O','D','M'], 3), SIN) then
          for I := 0 to cbImportSelect.Items.Count - 1 do
            if cbImportSelect.Items.Objects[i] = TObject(SIN) then
            begin
              cbImportSelect.Checked[i] := True;
              break;
            end;
      end;
    finally
      FreeAndNil(FSSQLite);
      FreeAndNil(FS);
    end;
    tblClients.Next;
  end;
  FCashedReturns.Clear;
end;

procedure TfrmDataExtract.FormCreate(Sender: TObject);
begin
  FCashedReturns := TCashedReturns.Create;
  FLocalRetList := TStringList.Create;
  FLastError := TStringList.Create;
  FRetNoForClose := TList<TForClose>.Create;
  FCalculated := False;
  pgrbar := TProgressBar.Create(sbMain);
  try
    pgrbar.Parent := sbMain;
    pgrbar.Min := 0;
    pgrbar.Max := 100;
    pgrbar.Position := 0;
    pgrbar.top := 0;     //y position in the Statusbar
    pgrbar.left := 0;   // x position in the Statusbar
    pgrbar.Width := sbMain.Width;
  finally
  end;
end;

procedure TfrmDataExtract.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCashedReturns);
  FreeAndNil(FLocalRetList);
  FreeAndNil(FLastError);
  FreeAndNil(FRetNoForClose);
end;

procedure TfrmDataExtract.FormShow(Sender: TObject);
begin
  if not FCalculated then
  begin
    FCalculated := True;
    pgMain.ActivePage := tsExport;
    edtExportDir.Text := IncludeTrailingPathDelimiter(OptRec.Dir_Cur) + 'ExportedData';
    edtImport.Text := edtExportDir.Text;
    InitImportData;
    RetList.GetListOfLoadedReturns(FLocalRetList, FApp);
    TRadioButton(rgExportMode.Controls[0]).Enabled := (GetCurrentRetNo > 0) and
      (RetList[GetCurrentRetNo].MyApp = FApp);
    TRadioButton(rgExportMode.Controls[1]).Enabled := FLocalRetList.Count > 0;
    btnSelectCurrent.Enabled := TRadioButton(rgExportMode.Controls[0]).Enabled;
    btSelectOpened.Enabled := TRadioButton(rgExportMode.Controls[1]).Enabled;
  end;
end;

procedure TfrmDataExtract.InitImportData;
var
  Path: string;
  Sin: integer;
  aSL: TStringList;
begin
  if not DirectoryExists(edtImport.Text) then
    Exit;
  cbImportSelect.Items.Clear;
  aSL := TStringList.Create;
  try
    for Path in TDirectory.GetFiles(edtImport.Text, '*ExtractedVtData.txt')  do
    begin
      aSL.Clear;
      aSL.LoadFromFile(Path);
      if (aSL.Count > 0) and (TryStrToInt(copy(aSL[0], 5, Length(aSL[0])), Sin)) then
        cbImportSelect.Items.AddObject(Path, TObject(Sin));
    end;
  finally
    aSL.Free;
  end;
end;

function TfrmDataExtract.PrepareUpdateData(isOpen: boolean): boolean;
var
  tmpSL, NotFoundForm, NotFoundNum, NotFoundFile: TStringList;


  function SetData(const aFileName: string; const aRetNo: integer; const aRetEl: TRetData): Boolean;
  var
    aSL: TStringList;
    i, num: integer;
    s, valu: string;
    CurrentForm: string;
    aFormList: TStringList;
  begin
    Result := False;
    aSL := TStringList.Create;
    aFormList := TStringList.Create;
    try
      if not FileExists(aFileName) then
      begin
        NotFoundFile.Add(aFileName);
        Exit;
      end;
      aSL.LoadFromFile(aFileName);
      for I := 0 to aSL.Count - 1 do
      begin
        num := -1;
        s := ReadFirstData(aSL[i]);
        valu := ReadSecondData(aSL[i]);
        if LowerCase(Trim(s)) = 'form' then
        begin
          CurrentForm := Trim(valu);
          if aRetEl.GetFormNo(CurrentForm) <= 0 then
            begin
              NotFoundForm.Add(aFileName);
              Exit;
            end;
        end
        else
        if TryStrToInt(trim(s), num) then
        begin
          if (num = -1) or (CurrentForm = '') or
            ((aRetEl.GetFrm(aRetEl.GetFormNo(CurrentForm)).Count < num) and not (num > ArrayMul))  then
            begin
              NotFoundNum.Add(aFileName);
              Exit;
            end;
        end;
      end;
    finally
      aSL.Free;
    end;
    Result := True;
  end;

function FindAndSetData(const aRetEl: TRetData): Boolean;
var
  l: integer;
  SIN, RetSIN: string;
begin
  Result := False;
  if aRetEl.MyApp = FApp then
    for l := tmpSL.Count - 1 downto 0 do
    begin
      SIN := IntToStr(Integer(tmpSL.Objects[l]));
      RetSIN := aRetEl.GetSIN;
      if RetSIN <> '' then
        RetSIN := IntToStr(StrToInt(RetSIN));
      if RetSIN = SIN then
      begin
        pgrbar.Position := pgrbar.Position + 1;
        Result := SetData(tmpSL[l], aRetEl.RetNo, aRetEl);
        tmpSL.Delete(l);
        break;
      end;
    end;
end;
var
  i, RetNo, l: integer;
  isNeedClose: boolean;
  rec: TForClose;
  RetSIN, SIN: string;
begin
  Result := True;
  errStr := '';
  pgrbar.Position := 0;
  tmpSL := TStringList.Create;
  NotFoundForm := TStringList.Create;
  NotFoundNum := TStringList.Create;
  NotFoundFile := TStringList.Create;
  btnAbort.Visible := True;
  try
    for I := 0 to cbImportSelect.Items.Count - 1 do
      if cbImportSelect.Checked[i] then
        tmpSL.AddObject(cbImportSelect.Items[i], cbImportSelect.Items.Objects[i]);
    if tmpSL.Count = 0 then
    begin
      ShowMessage('Nothing to do');
      Result := False;
      Exit;
    end;
    pgrbar.Max := cbImportSelect.Items.Count - 1;
    //First - search SIN in opened returns
    for i := 1 to RetList.Count - 1 do
    begin
      if Assigned(RetList[I]) and (not RetList[I].Destroying) then
      begin
        FindAndSetData(RetList[i]);
        Application.ProcessMessages;
        if FAbort and (MessageDlg('Stop process?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
          Exit
        else
          FAbort := False;
      end;
    end;
    if not SetTableName(conClients, tblClients, IncludeTrailingPathDelimiter(FApp.Dir_Cur) + FApp.ClientsDBLite,
      ClientsTableLite, '', false) then
    begin
      tblClients.Close;
      Exit;
    end;

    tblClients.First;
    FSSQLite := nil;
    FS := nil;
    while not tblClients.Eof do
    begin
      for l := tmpSL.Count - 1 downto 0 do
      begin
        SIN := IntToStr(Integer(tmpSL.Objects[l]));
        RetSIN := tblClients.FieldByName('SIN').AsString;
        if RetSIN <> '' then
          RetSIN := IntToStr(StrToInt(RetSIN));
        if (RetSIN = SIN) and (FileExists(IncludeTrailingPathDelimiter(FApp.Dir_Cur) + tblClients.FieldByName('FILE_NAME').AsString)) then
        begin
          RetNo := OpenReturnCoupled(FApp.Dir_Cur,
            tblClients.FieldByName('FILE_NAME').AsString, False);
          if RetNo > 0 then
          begin
            if (not FindAndSetData(RetList[RetNo])) or (not isOpen) then
            begin
              rec.aRecNo := RetNo;
              rec.Dir := IncludeTrailingPathDelimiter(FApp.Dir_Cur);
              rec.Name := tblClients.FieldByName('FILE_NAME').AsString;
              FRetNoForClose.Add(rec);
            end;
            Application.ProcessMessages;
            if FAbort and (MessageDlg('Stop process?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
              Exit
            else
              FAbort := False;
          end;
        end;
      end;
      tblClients.Next;
    end;
  finally
    btnAbort.Visible := False;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
    for i := 0 to tmpSL.Count - 1 do
      errStr := errStr + IfThen(errStr = '', 'Not imported ' + tmpSL[i] + ' file. Don`t found SIN.',
        #13#10 + 'Not imported ' + tmpSL[i] + ' file. Don`t found SIN.');
    for i := 0 to NotFoundForm.Count - 1 do
      errStr := errStr + IfThen(errStr = '', 'Not imported ' + NotFoundForm[i] + ' file. Don`t found FORM name.',
        #13#10 + 'Not imported ' + NotFoundForm[i] + ' file. Don`t found FORM name.');
    for i := 0 to NotFoundNum.Count - 1 do
      errStr := errStr + IfThen(errStr = '', 'Not imported ' + NotFoundNum[i] + ' file. Don`t found param number.',
        #13#10 + 'Not imported ' + NotFoundNum[i] + ' file. Don`t found param number.');
    for i := 0 to NotFoundFile.Count - 1 do
      errStr := errStr + IfThen(errStr = '', 'Not imported ' + NotFoundFile[i] + ' file. Don`t found file.',
        #13#10 + 'Not imported ' + NotFoundFile[i] + ' file. Don`t found file.');
    FLastError.Clear;
    for I := 0 to tmpSL.Count - 1 do
      FLastError.Add(tmpSL[i]);
    for I := 0 to NotFoundForm.Count - 1 do
      FLastError.Add(NotFoundForm[i]);
    for I := 0 to NotFoundNum.Count - 1 do
      FLastError.Add(NotFoundNum[i]);
    for I := 0 to NotFoundFile.Count - 1 do
      FLastError.Add(NotFoundFile[i]);
    tmpSL.Free;
    NotFoundForm.Free;
    NotFoundNum.Free;
    NotFoundFile.Free;
  end;
end;

function TfrmDataExtract.ReadFirstData(aFrom: string): string;
var
  c: char;
  i: integer;
begin
  Result := '';
  for I := 1 to Length(aFrom) do
  begin
    c := aFrom[i];
    if (ord(c) = 9) or (ord(c) = 32) then
      Exit;
    Result := Result + c;
  end;
end;

function TfrmDataExtract.ReadSecondData(aFrom: string): string;
var
  c: char;
  i: integer;
  isFounded: boolean;
begin
  isFounded := False;
  Result := '';
  for I := 1 to Length(aFrom) do
  begin
    c := aFrom[i];
    if (ord(c) = 9) or (ord(c) = 32) then
      isFounded := True;
    if (ord(c) <> 9) and (ord(c) <> 32) and isFounded then
    begin
      Result := Copy(aFrom, i, Length(aFrom));
      Exit;
    end;
  end;
end;

procedure TfrmDataExtract.UpdateData(isOpen: boolean);
var
  tmpSL: TStringList;
  Total: integer;

  procedure SetData(const aFileName: string; const aRetNo: integer; const aRetEl: TRetData);
  var
    aSL: TStringList;
    i, num: integer;
    s, valu: string;
    CurrentForm: string;
    aFormList: TStringList;
    MyChild: TMyChild;
    MyForm: TvtScrollBox;
  begin
    aSL := TStringList.Create;
    aFormList := TStringList.Create;
    try
      aSL.LoadFromFile(aFileName);
      for I := 0 to aSL.Count - 1 do
      begin
        num := -1;
        s := ReadFirstData(aSL[i]);
        valu := ReadSecondData(aSL[i]);
        if LowerCase(Trim(s)) = 'form' then
        begin
          CurrentForm := Trim(valu);
          if isOpen and (aFormList.IndexOf(CurrentForm) < 0) then
          begin
            if aRetEl.GetFormNo(CurrentForm) > 0 then
            begin
              OpenForm(aRetNo,CurrentForm,0);
              aRetEl.FormHasData[CurrentForm] := True;
              aFormList.Add(CurrentForm);
            end;
          end;
        end
        else
        if TryStrToInt(trim(s), num) then
        begin
          if (num <> -1) and (CurrentForm <> '') then
            StoreElm(aRetNo, CurrentForm, num, valu);
        end;
      end;
    finally
      aSL.Free;
    end;
    aRetEl.Changed := True;
    CalcAll(aRetNo);
    MyChild := vtMulti.RetList[aRetNo].MyChild;
    MyForm := MyChild.ActiveForm;
    if MyForm <> nil then
      vtMulti.RetList[aRetNo].MyChild.ActiveForm.PopulateFormWithData;
  end;

function FindAndSetData(const aRetEl: TRetData): boolean;
var
  l: integer;
  SIN, RetSIN: string;
begin
  Result := False;
  if aRetEl.MyApp = FApp then
    for l := tmpSL.Count - 1 downto 0 do
    begin
      SIN := IntToStr(Integer(tmpSL.Objects[l]));
      RetSIN := aRetEl.GetSIN;
      if RetSIN <> '' then
        RetSIN := IntToStr(StrToInt(RetSIN));
      if RetSIN = SIN then
      begin
        pgrbar.Position := pgrbar.Position + 1;
        SetData(tmpSL[l], aRetEl.RetNo, aRetEl);
        tmpSL.Delete(l);
        Result := True;
        inc(Total);
        break;
      end;
    end;
end;
var
  i, RetNo: integer;
  isNeedClose: boolean;
begin
  Total := 0;
  FRetNoForClose.Clear;
  if not PrepareUpdateData(isOpen) then
    Exit;
  if errStr <> '' then
  begin
    if MessageDlg(errStr + #13#10 + 'Clean check from bad files and continue or Abort?', mtConfirmation, [mbYes, mbAbort], 0) = mrYes then
    begin
      for I := 0 to FLastError.Count - 1 do
        cbImportSelect.Checked[cbImportSelect.Items.IndexOf(FLastError[i])] := False;
    end
    else begin
      for I := 0 to FRetNoForClose.Count - 1 do
      begin
        SaveReturn(FRetNoForClose[i].aRecNo, FRetNoForClose[i].Dir, FRetNoForClose[i].Name,
                true, false);
        RetList[FRetNoForClose[i].aRecNo].Close(True);
      end;
      Exit;
    end;
  end;

  pgrbar.Position := 0;
  tmpSL := TStringList.Create;
  btnAbort.Visible := True;
  try
    for I := 0 to cbImportSelect.Items.Count - 1 do
      if cbImportSelect.Checked[i] then
        tmpSL.AddObject(cbImportSelect.Items[i], cbImportSelect.Items.Objects[i]);
    if tmpSL.Count = 0 then
    begin
      ShowMessage('Nothing to do');
      Exit;
    end;
    pgrbar.Max := cbImportSelect.Items.Count - 1;

    //First - search SIN in opened returns
    for i := 1 to RetList.Count - 1 do
    begin
      if Assigned(RetList[I]) and (not RetList[I].Destroying) then
      begin
        FindAndSetData(RetList[i]);
        Application.ProcessMessages;
        if FAbort and (MessageDlg('Stop process?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
          Exit
        else
          FAbort := False;
      end;
    end;
  finally
    pgrbar.Position := 0;
    btnAbort.Visible := False;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
    for I := 0 to FRetNoForClose.Count - 1 do
    begin
      SaveReturn(FRetNoForClose[i].aRecNo, FRetNoForClose[i].Dir, FRetNoForClose[i].Name,
              true, false);
      RetList[FRetNoForClose[i].aRecNo].Close(True);
    end;
    tmpSL.Free;
  end;
  if Application.MainForm.MDIChildCount > 0 then
    MainForm.GuiCommand(gcRefreshAuditPanel);
  MessageDlg('Done!' + #13#10 +
             IntToStr(Total) + ' file(s) imported.', mtInformation, [mbOk], 0);
end;

end.
