unit T1_2026BackupFrm;  //20200217 Igor

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl, Vcl.ComCtrls,
  ShellApi;  //20200428

type
  TBackupThread = class;

  TBackupFrmT1_2026 = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    Labelx: TLabel;
    LastBackupDirBox: TEdit;
    Label3: TLabel;
    LastDateTakenBox: TEdit;
    NewBackupDirBox: TEdit;
    OkBtn: TBitBtn;
    Exit: TBitBtn;
    Label7: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    BackupToCloudBtn: TBitBtn;
    Label9: TLabel;
    UserLoginNameBox: TEdit;
    Label10: TLabel;
    LocalDataFolder: TEdit;
    Label11: TLabel;
    CloudDataFolder: TEdit;
    BackupProgressBar: TProgressBar;
    //20200218 Igor >>>
    ProgressInfoLabel: TLabel;
    rbFast: TRadioButton;
    rbSlow: TRadioButton;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    BackUpClientDocs: TBitBtn;
    BackUpPermDocs: TBitBtn;
    NewClientDocsDirBox: TEdit;
    NewPermanentDocsDirBox: TEdit;
    Label2: TLabel;
    VerifyBtn: TButton;
    //20200218 Igor <<<
    procedure ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure BackupToCloudBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BackUpClientDocsClick(Sender: TObject);
    procedure BackUpPermDocsClick(Sender: TObject);
    procedure VerifyBtnClick(Sender: TObject); //20200206 Igor
  private
    { Private declarations }
    FBackupThread: TBackupThread;
    CloseAfterFinish: boolean;
    procedure BackupThreadFinish(AMessage, AError: string);
    procedure BackupThreadStart;
  public
    { Public declarations }
  end;

 TBackupThread = class(TThread)
  private
    BackupDir: string;
    BackupForm: TBackupFrmT1_2026;
    RenameFiles: boolean; //20200218 Igor
  protected
    procedure Execute; override;
    constructor Create(AForm: TBackupFrmT1_2026);
end;

var
  BackupFrm: TBackupFrmT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026TrimStr,T1_2026Declare,vtTrimStr,vtShared,
  T1_2026Common,T1_2026Common2, vtHelperManager, vtMulti;  //20200206 Igor

procedure TBackupFrmT1_2026.BackupThreadFinish(AMessage, AError: string);
begin
  Screen.Cursor := crDefault;
  if not AMessage.IsEmpty then
    ShowMessage(AMessage)
  else if not AError.IsEmpty then
    MessageDlg(AError, mtError, [mbOk], 0);
  OkBtn.Enabled := true;
  BackupToCloudBtn.Caption := 'Backup To Cloud';
  BackupToCloudBtn.Enabled := true;
  //20200218 Igor >>>
  rbFast.Enabled := true;
  rbSlow.Enabled := true;
  ProgressInfoLabel.Caption := '';
  //20200218 Igor <<<
  FBackupThread := nil;
  if CloseAfterFinish then
    Close;
end;

procedure TBackupFrmT1_2026.BackupThreadStart;
begin
  Screen.Cursor := crDefault;
  OkBtn.Enabled := false;
  //20200218 Igor >>>
  rbFast.Enabled := false;
  rbSlow.Enabled := false;
  ProgressInfoLabel.Caption := '';
  //20200218 Igor <<<
  BackupToCloudBtn.Caption := 'Cancel';
  BackupToCloudBtn.Enabled := true;
end;

procedure TBackupFrmT1_2026.BackupToCloudBtnClick(Sender: TObject);
begin
  if Assigned(FBackupThread) then
  begin
    if MessageDlg('Are you sure you want to cancel Backup to Cloud?', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      BackupToCloudBtn.Enabled := false;
      FBackupThread.Terminate;
    end;
  end
  else
  begin
    BackupToCloudBtn.Enabled := false;
    FBackupThread := TBackupThread.Create(Self);
  end;
end;

procedure TBackupFrmT1_2026.BackUpClientDocsClick(Sender: TObject);
Var FromDir,ToDir:String;
begin
 Try
  FromDir:=OptRec.Dir_ClientDocs;
  ToDir:=NewClientDocsDirBox.Text; //OptRec.BackUpDir+'/ClientDocs'+'-'+FormatDateTime('yyyy-mm-dd "Time" hh mm ss',Now);
  CopyDir(fromDir, toDir);
 Finally
  ShowMessage('Done');
 end;
 //WinExec('Xcopy '+Pchar(FromDir)+' '+PChar(ToDir)+' '+'/e /i /h'; // SW_SHOWNORMAL);
end;

procedure TBackupFrmT1_2026.BackUpPermDocsClick(Sender: TObject);
Var FromDir,ToDir:String;
begin
 Try
 FromDir:=OptRec.Dir_PermanentDocs;
 ToDir:=NewPermanentDocsDirBox.text; //OptRec.BackUpDir+'/PermanentDocs'+'-'+FormatDateTime('yyyy-mm-dd "Time" hh mm ss',Now);
 CopyDir(fromDir, toDir);
 Finally
    ShowMessage('Done');
 end;
end;


procedure TBackupFrmT1_2026.ExitClick(Sender: TObject);
begin
Close;
end;

procedure TBackupFrmT1_2026.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FBackupThread) then
  begin
    if MessageDlg('Are you sure you want to cancel Backup to Cloud?', mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      FBackupThread.Terminate;
      CloseAfterFinish := true;
    end;
    Action := caNone;
  end
end;

procedure TBackupFrmT1_2026.FormCreate(Sender: TObject);
Var LastBackup:String; intFileAge: LongInt;
    iCloud: integer;
    HelperClassName: String;
begin
 LastBackUp:=optRec.LastBackUpDir;
 LastBackUpDirBox.Text:=LastBackUp;
 for iCloud := 0 to HelperManager.HelperClassList.Count - 1 do
 begin
   if not HelperManager.AllowSend(iCloud) then continue;
   HelperClassName := HelperManager.HelperClassList.Keys.ToArray[iCloud].ClassName;
   UserLoginNameBox.Text := HelperManager.Config(HelperClassName, AppT1_2026.AppId, User.UserName).UserName;
   CloudDataFolder.Text := HelperManager.Config(HelperClassName, AppT1_2026.AppId, User.UserName).FullPath;
   break;
 end;
 LocalDataFolder.Text := OptRec.Dir_Cur;
 CloseAfterFinish := false;


 NewBackupDirBox.Text:=OptRec.BackUpDir+'TaxReturns-'+FormatDateTime('yyyy-mm-dd "Time" hh nn ss',Now); //20200428
   //IncrementlastBackUpDir(LastBackUp, OptRec.BackUpDir);

 //20200428
 NewClientDocsDirBox.text:=OptRec.BackUpDir+'/ClientDocs'+'-'+FormatDateTime('yyyy-mm-dd "Time" hh mm ss',Now);
 NewPermanentDocsDirBox.text:=OptRec.BackUpDir+'/PermanentDocs'+'-'+FormatDateTime('yyyy-mm-dd "Time" hh mm ss',Now);

 intFileAge := FileAge(LastBackUp);
 if intFileAge = -1 then
   LastDateTakenBox.Text:=''
  else
   LastDateTakenBox.Text:= DateToStr(FileDateToDateTime(intFileAge));
end;

procedure TBackupFrmT1_2026.OkBtnClick(Sender: TObject);
var
   Err: String;
begin

  if BackUpData(OptRec.Dir_Cur, NewBackupDirBox.Text, Err) then //20160615 Igor
  Begin
    SaveSingleOption('LastBackUpDir',NewBackupDirBox.Text); //20160805 Igor
    LoadOptionsFileToMem;
    ShowMessage('Backup was successfully created as '+NewBackupDirBox.Text); //20160805 Igor
  End
  else
    ShowMessage('Backup failed! Error: '+Err); //20160615 Igor
end;

procedure TBackupFrmT1_2026.VerifyBtnClick(Sender: TObject);
begin
  //ShellExecute(Application.Handle, 'open', PChar(OptRec.BackupDir), nil, nil, SW_SHOWNORMAL) ;
end;

{ TBackupThread }

constructor TBackupThread.Create(AForm: TBackupFrmT1_2026);
begin
  if not Assigned(AForm) then
    raise Exception.Create('Backup form is not specified in thread constructor');
  BackupForm := AForm;
  //20200218 Igor >>>
  BackupDir := AForm.LocalDataFolder.Text;
  RenameFiles := AForm.rbSlow.Checked;
  //20200218 Igor <<<
  inherited Create(false);
end;

procedure TBackupThread.Execute;
Var
  i, lRetNo, iCloud, iCount: Integer;
  TempList: TstringList;
  HelperID: Integer;
  HelperClassName: String;
  CloudPath: String;
  ClientID: String;
  Token: String;
  bSaved: boolean;
  cMessage, cError: string;

  procedure UpdateProgressInfo(AMessage: string); //20200218 Igor
  begin
    Synchronize(procedure
                begin
                  BackupForm.ProgressInfoLabel.Caption := AMessage;
                end);
  end;
begin
  inherited;
  cMessage := '';
  cError := '';
  Synchronize(procedure
              begin
                BackupForm.BackupThreadStart;
              end);
  try
    try
      if not DirectoryExists(BackupDir) then
      begin
        cError := 'Source directory "' + BackupDir + '" does not exist';
        Exit;
      end;

      If Not ForceDirectories(BackupDir) then
      begin
        cError := 'Cannot create destination directory "' + BackupDir + '"'+ #13 + SysErrorMessage(GetLastError);
        Exit;
      end;

      TempList:=TstringList.Create;
      StartSilentRead;
      iCount := 0;
      try
        //20200218 Igor >>>
        UpdateProgressInfo('Retrieving File List');
        GetFileList(IncludeTrailingPathDelimiter(BackupDir), '*.*', TempList);
        Synchronize(procedure
            begin
              BackupForm.BackupProgressBar.Position := 0;
              BackupForm.BackupProgressBar.Max := Templist.count;
            end);
        For i := 0 to templist.count - 1 do
        begin
          if Terminated then
          begin
            Synchronize(procedure
              begin
                BackupForm.BackupProgressBar.Position := 0;
              end);
            Exit;
          end;
          if not SameText(ExtractFileName(TempList[i]), 'CLIENTS_T1.db') then
          begin
            if RenameFiles then
            begin
              bSaved := false;
              try
                UpdateProgressInfo('Opening '+ ExtractFileName(TempList[i]));
                lRetNo := OpenReturn(BackupDir, ExtractFileName(TempList[i]), False, False, False, True); //20200207 Igor
                Screen.Cursor := crDefault;
                if lRetNo > 0 then
                try
                  for iCloud := 0 to HelperManager.HelperClassList.Count - 1 do
                  begin
                    if not HelperManager.AllowSend(iCloud) then continue;
                    UpdateProgressInfo('Uploading '+ Ret[lRetNo].GetCloudFileName);
                    HelperClassName := HelperManager.HelperClassList.Keys.ToArray[iCloud].ClassName;
                    CloudPath := HelperManager.Config(HelperClassName, AppT1_2026.AppId, User.UserName).Path; //20170112 Igor
                    ClientID := HelperManager.Config(HelperClassName).ClientID;
                    Token := HelperManager.Config(iCloud, AppT1_2026.AppId, User.UserName).Token; //20170112 Igor
                    HelperManager.Send(iCloud,
                        TempList[i],
                        CloudPath,
                        Ret[lRetNo].GetCloudFileName,
                        ClientID,
                        Token);
                    bSaved := true;
                    break;
                  end;
                  if bSaved then
                    inc(iCount);
                finally
                   CloseReturn(lRetNo,true);
                end;
              except
              end;
            end
            else
            begin
              for iCloud := 0 to HelperManager.HelperClassList.Count - 1 do
              begin
                if not HelperManager.AllowSend(iCloud) then continue;
                UpdateProgressInfo('Uploading '+ ExtractFileName(TempList[i]));
                HelperClassName := HelperManager.HelperClassList.Keys.ToArray[iCloud].ClassName;
                CloudPath := HelperManager.Config(HelperClassName, AppT1_2026.AppId, User.UserName).Path;
                ClientID := HelperManager.Config(HelperClassName).ClientID;
                Token := HelperManager.Config(iCloud, AppT1_2026.AppId, User.UserName).Token;
                HelperManager.Send(iCloud,
                    TempList[i],
                    CloudPath,
                    ExtractFileName(TempList[i]),
                    ClientID,
                    Token);
                bSaved := true;
                break;
              end;
              if bSaved then
                inc(iCount);
            end;
          end;
          Synchronize(procedure
            begin
              BackupForm.BackupProgressBar.Position := i + 1;
              Screen.Cursor := crDefault;
            end);
        end;
        //20200218 Igor <<<
      finally
        EndSilentRead;
        TempList.Free;
      end;
      if iCount = 0 then
        cMessage := 'No returns found in source directory'
      else if iCount = 1 then
        cMessage := '1 return successfully uploaded to Cloud'
      else
        cMessage := IntToStr(iCount) + ' returns successfully uploaded to Cloud';
    except on E: Exception do
      cError := 'Backup to Cloud failed! Error: '+ E.Message;
    end;
  finally
    Synchronize(procedure
                begin
                  BackupForm.BackupThreadFinish(cMessage, cError);
                end);
  end;
end;

end.
