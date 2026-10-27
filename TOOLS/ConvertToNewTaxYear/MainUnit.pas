unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ComCtrls,
  {$WARN UNIT_PLATFORM OFF}
  FileCtrl,
  {$WARN UNIT_PLATFORM ON}
  System.IOUtils, System.Types, System.UITypes, StrUtils;

type
  TOnLog = procedure(AMessage: string) of object;
  TOnFinish = procedure of object;

type
  TConvertThread = class(TThread)
  private
    FFolder: string;
    FYear: integer;
    FPrevYear: integer;
    FProgressBar: TProgressBar;

    FOnLog: TOnLog;
    FOnStatus: TOnLog;
    FOnFinish: TOnFinish;
    procedure Convert;
    procedure DoLog(AMessage: string);
    procedure DoStatus(AMessage: string);
    procedure DoFinish;
    procedure InitProgress(AMax: integer);
    procedure IncProgress;
  protected
    procedure Execute; override;

    property Folder: string read FFolder write FFolder;
    property Year: integer read FYear write FYear;
    property PrevYear: integer read FPrevYear write FPrevYear;
    property OnLog: TOnLog read FOnLog write FOnLog;
    property OnStatus: TOnLog read FOnStatus write FOnStatus;
    property OnFinish: TOnFinish read FOnFinish write FOnFinish;
    property ProgressBar: TProgressBar read FProgressBar write FProgressBar;
  end;


type
  TMainForm = class(TForm)
    Label1: TLabel;
    edFolder: TEdit;
    btnSelectFolder: TSpeedButton;
    Label2: TLabel;
    edYear: TEdit;
    meLog: TMemo;
    pbMain: TProgressBar;
    btnStart: TButton;
    lblNote: TLabel;
    lblStatus: TLabel;
    procedure btnSelectFolderClick(Sender: TObject);
    procedure edFolderChange(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    { Private declarations }
    FYear: Integer;
    FThread: TConvertThread;
    procedure Log(AMessage: string);
    procedure Status(AMessage: string);
    procedure Finish;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btnSelectFolderClick(Sender: TObject);
var cFolder: string;
begin
  cFolder := edFolder.Text;
  if cFolder.IsEmpty then
    cFolder := ExtractFilePath(Application.ExeName);
  if not SelectDirectory('Choose new tax year folder', 'C:\', cFolder) then Exit;
  edFolder.Text := cFolder;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
begin
  if Assigned(FThread) then
  begin
    if MessageDlg('Are you sure you want to cancel ?', mtWarning, mbYesNo, 0) <> mrYes then Exit;
    btnStart.Enabled := false;
    FThread.Terminate;
  end
  else
  begin
    btnStart.Caption := 'Cancel';
    btnSelectFolder.Enabled := false;
    FThread := TConvertThread.Create(true);
    FThread.Folder := edFolder.Text;
    FThread.Year := FYear;
    FThread.PrevYear := FYear - 1;

    FThread.OnLog := Log;
    FThread.OnStatus := Status;
    FThread.OnFinish := Finish;

    FThread.ProgressBar := pbMain;

    FThread.FreeOnTerminate := true;
    FThread.Start;
  end;
end;

procedure TMainForm.edFolderChange(Sender: TObject);
var cTemp: string;
begin
  cTemp := ExtractFileName(edFolder.Text);
  FYear := StrToIntDef(cTemp, 0);
  if FYear > 0 then
  begin
    edYear.Text := FYear.ToString;
    lblNote.Caption := 'Program will scan selected directory and replace '+
                        (FYear - 1).ToString + ' ('+ FYear.ToString +' for T2 and FP) with '+
                        FYear.ToString + ' ('+ (FYear + 1).ToString +' for T2 and FP)'
  end
  else
  begin
    edYear.Text := '';
    lblNote.Caption := '';
  end;
  btnStart.Enabled := FYear > 0;
end;

procedure TMainForm.Finish;
begin
  btnStart.Caption := 'Start';
  btnStart.Enabled := true;
  btnSelectFolder.Enabled := true;
  FThread := nil;
end;

procedure TMainForm.Log(AMessage: string);
begin
  meLog.Lines.Add(DateTimeToStr(Now) + ' - ' + AMessage);
end;

procedure TMainForm.Status(AMessage: string);
begin
  lblStatus.Caption := AMessage;
end;

{ TConvertThread }

procedure TConvertThread.Convert;

  function IgnoreFolder(AFolder: string): boolean;
  var lName: string;
  begin
    AFolder := AFolder.ToUpper;
    lName := ExtractFileName(AFolder);
    Result := (Pos('CHROMIUM', AFolder) > 0)
              or
              (Pos('T1FORMS', AFolder) > 0)
              or
              (Pos('T2FORMS', AFolder) > 0)
              or
              (Pos('T3FORMS', AFolder) > 0)
              or
              (Pos('T4T5FORMS', AFolder) > 0)
              or
              (Pos('TFFORMS', AFolder) > 0)
              or
              (Pos('FPFORMS', AFolder) > 0)
              or
              (Pos('/COMMON/', AFolder) > 0)
              or
              (Pos('NOA', AFolder) > 0)
              or
              (Pos('LList[I]', AFolder) > 0);
  end;

  function Convert(AText: string): string;
  begin
    Result := AText;
    Result := ReplaceText(Result, 'T1-' + PrevYear.ToString, 'T1-' + Year.ToString);
    Result := ReplaceText(Result, 'S1-' + PrevYear.ToString, 'S1-' + Year.ToString);
    Result := ReplaceText(Result, 'T2-' + (PrevYear + 1).ToString, 'T2-' + (Year + 1).ToString);
    Result := ReplaceText(Result, 'S2-' + PrevYear.ToString, 'S2-' + Year.ToString);
    Result := ReplaceText(Result, 'T3-' + PrevYear.ToString, 'T3-' + Year.ToString);
    Result := ReplaceText(Result, 'T4T5-' + PrevYear.ToString, 'T4T5-' + Year.ToString);
    Result := ReplaceText(Result, 'TF-' + PrevYear.ToString, 'TF-' + Year.ToString);
    Result := ReplaceText(Result, 'FP-' + (PrevYear + 1).ToString, 'FP-' + (Year + 1).ToString);
    Result := ReplaceText(Result, 'TR-' + PrevYear.ToString, 'TR-' + Year.ToString);

    Result := ReplaceText(Result, 'T1_' + PrevYear.ToString, 'T1_' + Year.ToString);
    Result := ReplaceText(Result, 'T2_' + (PrevYear + 1).ToString, 'T2_' + (Year + 1).ToString);
    Result := ReplaceText(Result, 'T3_' + PrevYear.ToString, 'T3_' + Year.ToString);
    Result := ReplaceText(Result, 'T4T5_' + PrevYear.ToString, 'T4T5_' + Year.ToString);
    Result := ReplaceText(Result, 'TF_' + PrevYear.ToString, 'TF_' + Year.ToString);
    Result := ReplaceText(Result, 'FP_' + (PrevYear + 1).ToString, 'FP_' + (Year + 1).ToString);
    Result := ReplaceText(Result, 'TR_' + PrevYear.ToString, 'TR_' + Year.ToString);

    Result := ReplaceText(Result, 'T1F' + PrevYear.ToString, 'T1F' + Year.ToString);
    Result := ReplaceText(Result, 'S1F' + PrevYear.ToString, 'S1F' + Year.ToString);
    Result := ReplaceText(Result, 'T2F2_' + (PrevYear + 1).ToString, 'T2F2_' + (Year + 1).ToString);
    Result := ReplaceText(Result, 'S2F2_' + (PrevYear + 1).ToString, 'S2F2_' + (Year + 1).ToString);
    Result := ReplaceText(Result, 'T3F' + PrevYear.ToString, 'T3F' + Year.ToString);
    Result := ReplaceText(Result, 'T4T5F' + PrevYear.ToString, 'T4T5F' + Year.ToString);
    Result := ReplaceText(Result, 'TFF' + PrevYear.ToString, 'TFF' + Year.ToString);
    Result := ReplaceText(Result, 'FPF2_' + (PrevYear + 1).ToString, 'FPF2_' + (Year + 1).ToString);
    Result := ReplaceText(Result, 'TRF2_' + PrevYear.ToString, 'TRF2_' + Year.ToString);

    Result := ReplaceText(Result, 'VTDebug' + PrevYear.ToString, 'VTDebug' + Year.ToString);
    Result := ReplaceText(Result, 'vtProjectGroup_' + PrevYear.ToString, 'vtProjectGroup_' + Year.ToString);
    Result := ReplaceText(Result, 'vtViewer' + PrevYear.ToString, 'vtViewer' + Year.ToString);
    Result := ReplaceText(Result, 'vtClient' + PrevYear.ToString, 'vtClient' + Year.ToString);
    Result := ReplaceText(Result, 'VT-' + PrevYear.ToString, 'VT-' + Year.ToString);
    Result := ReplaceText(Result, 'VT' + PrevYear.ToString, 'VT' + Year.ToString);
    Result := ReplaceText(Result, 'TR' + PrevYear.ToString, 'TR' + Year.ToString);
    Result := ReplaceText(Result, 'MkVTClient-' + PrevYear.ToString, 'MkVTClient-' + Year.ToString);
    Result := ReplaceText(Result, 'T2Test-' + PrevYear.ToString, 'T2Test-' + Year.ToString);
  end;

  procedure RenameFolders(ADir: string);
  var
    FolderPredicate: TDirectory.TFilterPredicate;
    LList: TStringDynArray;
    I: Integer;
    LName, LNewName: string;
  begin
    FolderPredicate := function(const Path: string; const SearchRec: TSearchRec): Boolean
                       begin
                         {$WARN SYMBOL_PLATFORM OFF}
                         Result := ((SearchRec.Attr and faDirectory) = faDirectory) and
                                   ((SearchRec.Attr and faHidden) = 0);
                         {$WARN SYMBOL_PLATFORM ON}
                       end;

    if not TDirectory.Exists(ADir) then Exit;
    LList := TDirectory.GetDirectories(ADir, '*.*', TSearchOption.soAllDirectories, FolderPredicate);

    InitProgress(Length(LList));
    for I := Length(LList) - 1 downto 0 do
    begin
      try
        if Terminated then
          break;
        if IgnoreFolder(LList[I]) then continue;
        LName := ExtractFileName(LList[I]);
        LNewName := Convert(LName);
        if not SameText(LName, LNewName) then
        begin
          DoLog('Renaming '+ LList[I]);
          TDirectory.Move(LList[I], TPath.Combine(ExtractFilePath(LList[I]), LNewName));
        end;
      finally
        IncProgress;
      end;
    end;
  end;

  procedure RenameFiles(ADir: string);
  var
    FilePredicate: TDirectory.TFilterPredicate;
    LList: TStringDynArray;
    I: Integer;
    LName, LNewName: string;
  begin
    FilePredicate := function(const Path: string; const SearchRec: TSearchRec): Boolean
                     begin
                       {$WARN SYMBOL_PLATFORM OFF}
                       Result := ((SearchRec.Attr and faDirectory) <> faDirectory) and
                                 ((SearchRec.Attr and faHidden) = 0);
                       {$WARN SYMBOL_PLATFORM ON}
                     end;

    if not TDirectory.Exists(ADir) then Exit;
    LList := TDirectory.GetFiles(ADir, '*.*', TSearchOption.soAllDirectories, FilePredicate);

    InitProgress(Length(LList));
    for I := 0 to Length(LList) - 1 do
    begin
      try
        if Terminated then
          break;
        if IgnoreFolder(ExtractFilePath(LList[I])) then continue;
        LName := ExtractFileName(LList[I]);
        LNewName := Convert(LName);
        if not SameText(LName, LNewName) then
        begin
          DoLog('Renaming '+ LList[I]);
          TFile.Move(LList[I], TPath.Combine(ExtractFilePath(LList[I]), LNewName));
        end;
      finally
        IncProgress;
      end;
    end;
  end;

  procedure ProcessFiles(ADir: string);
  var
    FilePredicate: TDirectory.TFilterPredicate;
    LList: TStringDynArray;
    I: Integer;
    LFile: TStringList;
    LOldText: string;
  begin
    FilePredicate :=  function(const Path: string; const SearchRec: TSearchRec): Boolean
                      var LExt: string;
                      begin
                        {$WARN SYMBOL_PLATFORM OFF}
                        Result := ((SearchRec.Attr and faDirectory) <> faDirectory) and
                                  ((SearchRec.Attr and faHidden) = 0);
                        if Result then
                        begin
                          LExt := ExtractFileExt(SearchRec.Name);
                          Result := SameText(LExt, '.pas')
                                    or
                                    SameText(LExt, '.dfm')
                                    or
                                    SameText(LExt, '.txt')
                                    or
                                    SameText(LExt, '.dpk')
                                    or
                                    SameText(LExt, '.dpr')
                                    or
                                    SameText(LExt, '.dproj')
                                    or
                                    SameText(LExt, '.groupproj')
                                    or
                                    SameText(LExt, '.iss')
                                    or
                                    SameText(LExt, '.d');
                        end;
                        {$WARN SYMBOL_PLATFORM ON}
                      end;

    if not TDirectory.Exists(ADir) then Exit;
    LList := TDirectory.GetFiles(ADir, '*.*', TSearchOption.soAllDirectories, FilePredicate);

    InitProgress(Length(LList));
    for I := 0 to Length(LList) - 1 do
    begin
      try
        if Terminated then
          break;
        if IgnoreFolder(ExtractFilePath(LList[I])) then continue;
        LFile := TStringList.Create;
        try
          LFile.LoadFromFile(LList[I]);
          LOldText := LFile.Text;
          LFile.Text := Convert(LFile.Text);
          if not SameText(LOldText, LFile.Text) then
          begin
            DoLog('Updating '+ LList[I]);
            LFile.SaveToFile(LList[I]);
          end;
        finally
          LFile.Free;
        end;
      finally
        IncProgress;
      end;
    end;
  end;

begin
  DoLog('Start to convert from '+ PrevYear.ToString + ' to ' + Year.ToString);

  if not Terminated then
  begin
    DoStatus('Renaming folders');
    RenameFolders(Folder);
  end;
  if not Terminated then
  begin
    DoStatus('Renaming files');
    RenameFiles(Folder);
  end;
  if not Terminated then
  begin
    DoStatus('Updating files');
    ProcessFiles(Folder);
  end;
  if Terminated then
    DoLog('Terminated by user')
  else
    DoLog('Convert is finished successfully');
end;

procedure TConvertThread.DoFinish;
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnFinish) then
        OnFinish;
    end);
end;

procedure TConvertThread.DoLog(AMessage: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnLog) then
        OnLog(AMessage);
    end);
end;

procedure TConvertThread.DoStatus(AMessage: string);
begin
  Synchronize(
    procedure
    begin
      if Assigned(OnStatus) then
        OnStatus(AMessage);
    end);
end;

procedure TConvertThread.Execute;
begin
  inherited;
  try
    try
      Convert;
    except on E: Exception do
      DoLog(E.Message);
    end;
  finally
    DoFinish;
  end;
end;

procedure TConvertThread.IncProgress;
begin
  Synchronize(
    procedure
    begin
      if Assigned(ProgressBar) then
      begin
        // it is a workaround for progressbar glithes, it does not refresh immediately after position increment
        if ProgressBar.Position + 1 >= ProgressBar.Max then
        begin
          ProgressBar.Max := ProgressBar.Max + 1;
          ProgressBar.Position := ProgressBar.Position + 2;
          ProgressBar.Max := ProgressBar.Max - 1;
        end
        else
        begin
          ProgressBar.Position := ProgressBar.Position + 2;
          ProgressBar.Position := ProgressBar.Position - 1;
        end;
      end;
    end);
end;

procedure TConvertThread.InitProgress(AMax: integer);
begin
  Synchronize(
    procedure
    begin
      if Assigned(ProgressBar) then
      begin
        ProgressBar.Position := 0;
        ProgressBar.Max := AMax;
      end;
    end);
end;

end.
