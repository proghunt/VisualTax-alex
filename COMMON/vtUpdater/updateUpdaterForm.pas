unit updateUpdaterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, vtLabel, jpeg, ExtCtrls,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  ExtActns,
  ShellAPI, Vcl.Grids, Vcl.Buttons, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, System.Actions, Vcl.ActnList,
  System.UITypes, IdSSLOpenSSL; //20160819 Igor //20191210 Igor

type
  TMyApp = Record
    AppTitle,
    AppRelease,
    AppDate,
    AppCurrentDate,
    AppStatus,
    SetupURL,
    SetupLocalFile: String;
  End;
  TMyAppArr = Array of TMyApp;

  TUpdateThread = class; //20200311 Igor
  TupdateUpdater = class(TForm)
    Image1: TImage;
    Cancel: TButton;
    infolbl: TLabel;
    ProgressBar1: TProgressBar;
    XMLDoc: TXMLDocument;
    sgAppList: TStringGrid;
    btnDownload: TBitBtn;
    btnInstall: TBitBtn;
    ChkReDownloadAll: TCheckBox;
    chkReInstallAll: TCheckBox;
    ActionList1: TActionList;
    btnFullUpdate: TButton; //20160819 Igor
    procedure FormCreate(Sender: TObject);
    function getParams():boolean;
    procedure CancelClick(Sender: TObject);
    function getLocalFileVersionAsString(const Filename: string; var localUpdateVersion: string): Boolean;
    function getServerUpdateVersion(): Boolean;
    function DownloadURLFile(const xmlFileLocation, downloadedxmlFile : TFileName;
      out AError: String) : boolean;
    procedure openUpdater(p:string);
    procedure CheckUpdater();
    procedure sgAppListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnInstallClick(Sender: TObject);
    procedure sgAppListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure btnFullUpdateClick(Sender: TObject); //20160819 Igor
    procedure FormClose(Sender: TObject; var Action: TCloseAction); //20200311 Igor
  private
    { Private declarations }
    MyAppArr: TMyAppArr;
    FFullRefresh: Boolean;  //20160819 Igor
    FFullSetupFile: String; //20170210 Igor
    //20190917 Igor >>>
    IsVtClient: boolean; //20210119 Igor
    FTaxModulesSetupFile, FUtilitiesSetupFile: String;
    FTaxModulesUrl, FUtilitiesUrl: String;
    {FFullUpdate, }FTaxModulesUpdate, FUtilitiesUpdate: boolean; //20191007 Igor
    //20190917 Igor <<<
    FUpdateThread: TUpdateThread; //20200311 Igor
    function DoInstall(AFileName: String): Boolean;
    procedure RunMainProgramm;
    function WaitUntilCloseProgram: Boolean;//20160705 Igor
    function SetupFullPath: String; //20161220 Igor
  public
    { Public declarations }
  end;

  TUpdateThread = class(TThread) //20200311 Igor
  private
    FUpdater: TupdateUpdater;
    procedure IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
  protected
    constructor Create(AUpdater: TupdateUpdater);
    procedure Execute; override;
  end;

var
  updateUpdater: TupdateUpdater;
  Products: String;

  productName,
  localDate,
  localVersion,
  tempDefaultDownloadPath,
  unzipTo,
  xmlFileLocation : string;
  localUpdateVersion,serverUpdateVersion:string;
  {updaterPath,}appPath, MainProgram, TaxYear:string; //20160526 Igor //20160705 Igor //20240212 Igor
  vtUpdaterLocation:string;
  cancelDownloading:Boolean;

implementation

{$R *.dfm}

function MyStrToDate(S: String): TDateTime; //20190917 Igor
var
  Y,M,D: Word;
Begin
  Y := StrToIntDef(copy(S,1,4),1990);
  M := StrToIntDef(copy(S,6,2),1);
  D := StrToIntDef(copy(S,9,2),1);
  Result := EncodeDate(Y,M,D);
End;

function GetSetupFileName(S:String):String;
Begin
  while pos('/',S)>0 do
    Delete(S,1,pos('/',S));
  Result := S;
End;


procedure TupdateUpdater.FormClose(Sender: TObject; var Action: TCloseAction); //20200311 Igor
begin
  if Assigned(FUpdateThread) then
  begin
    ShowMessage('Wait for update process to finish!');
    Action := caNone;
  end;
end;

procedure TupdateUpdater.FormCreate(Sender: TObject);
  procedure FillAppList;
  var
    I: Integer;
  Begin
    products := products + '>>';
    sgAppList.RowCount := 2;
    I := 0;
    sgAppList.ColWidths[0] := sgAppList.Width  div 4;
    I := I + sgAppList.ColWidths[0];
    sgAppList.ColWidths[1] := sgAppList.Width  div 6;
    I := I + sgAppList.ColWidths[1];
    sgAppList.ColWidths[2] := sgAppList.Width  div 6;
    I := I + sgAppList.ColWidths[2];
    sgAppList.ColWidths[3] := sgAppList.Width  div 6;
    I := I + sgAppList.ColWidths[3];
    sgAppList.ColWidths[4] := sgAppList.Width - I - 24;  //20160527 Igor
    sgAppList.Cells[0,0] := 'Tax Module';
    sgAppList.Cells[1,0] := 'Release';
    sgAppList.Cells[2,0] := 'Your version'; //20190917 Igor
    sgAppList.Cells[3,0] := 'Last version';
    sgAppList.Cells[4,0] := 'Status';

    I := 1;
    SetLength(MyAppArr,I);
    while products > '' do
    Begin
      sgAppList.Cells[0,I] := String(Copy(products,1,pos('>>',Products)-1)).Replace('DEBUG', '', [rfIgnoreCase]); //20190917 Igor
      MyAppArr[I-1].AppTitle := sgAppList.Cells[0,I];
      Delete(Products,1,pos('>>',Products)+1);
      sgAppList.Cells[2,I] := Copy(products,1,pos('>>',Products)-1);
      MyAppArr[I-1].AppDate := sgAppList.Cells[2,I];
      Delete(Products,1,pos('>>',Products)+1);
      sgAppList.Cells[1,I] := Copy(products,1,pos('>>',Products)-1);
      MyAppArr[I-1].AppRelease := sgAppList.Cells[1,I];
      Delete(Products,1,pos('>>',Products)+1);
      if Products <> '' then
      Begin
        I := I+1;
        sgAppList.RowCount := sgAppList.RowCount + 1;
        SetLength(MyAppArr,I);
      End;
    End;
  End;
begin
    updateUpdater.Visible := False;
    //20190917 Igor >>>
    //FFullUpdate := false; //20191007 Igor
    FTaxModulesUpdate := false;
    FUtilitiesUpdate := false;
    //20190917 Igor <<<
    if not getParams() then
    begin
      application.terminate;
      exit;
    end;
    //mainTitle.Caption := productName +' Instant Web Updater';
    FillAppList;
    appPath := ExtractFilePath(ParamStr(0));
//    updaterPath := appPath + 'vtupdater.exe';  //20160527 Igor
    Application.ProcessMessages;
    updateUpdater.Visible := true;
    CheckUpdater();
end;

procedure TupdateUpdater.CheckUpdater();
begin
  if not getServerUpdateVersion() then exit;
end;

function TupdateUpdater.DoInstall(AFileName: String): Boolean;
var
  SetupParams: String;
  ProcessInfo: TProcessInformation;
  StartUpInfo: TStartUpInfo;
  Rlst: LongBool;
  ExitCode: Cardinal;
begin
  result := true;
  SetupParams := ' /NOCLOSEAPPLICATIONS /SILENT /SP- /DIR="'+unzipTo+'" /NOICONS'; //20200311 Igor //20210119 Igor
  try
    FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
    with StartUpInfo do
    begin
      cb := SizeOf(TStartUpInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
      wShowWindow := SW_HIDE;
    end;
    Rlst:= CreateProcess(PChar(AFileName), PChar(SetupParams),
      nil, nil, false, NORMAL_PRIORITY_CLASS,
      nil, nil, StartUpInfo, ProcessInfo);
//    shellExecute(Handle, 'open', PChar(AFileName), PChar(SetupParams), nil, SW_HIDE);
    if Rlst then
      with ProcessInfo do
      begin
        WaitForInputIdle(hProcess, INFINITE);
        WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
        GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
        CloseHandle(hThread);
        CloseHandle(hProcess);
      end
    else
    begin
      Result := False;
    end;
  except ON E: Exception DO
    result := false;
  end;
end;

procedure TupdateUpdater.openUpdater(p:string);
var
paramsToSend,spaceDelimiter,quotes:string;
begin
  spaceDelimiter := ' ';
  quotes := '"';
  paramsToSend := spaceDelimiter+quotes+ParamStr(1)+quotes
                 +spaceDelimiter+quotes+ParamStr(2)+quotes
                 +spaceDelimiter+quotes+ParamStr(3)+quotes
                 +spaceDelimiter+quotes+ParamStr(4)+quotes
                 +spaceDelimiter+quotes+ParamStr(5)+quotes
                 +spaceDelimiter+quotes+ParamStr(6)+quotes;

  if fileExists(p) then
  begin
    shellExecute(Handle, 'open', PChar(p), PChar(paramsToSend), nil, SW_SHOWNORMAL);
  end
  else
    showmessage(p + ' not found.');
end;


procedure TupdateUpdater.RunMainProgramm;//20160705 Igor
begin
  ShellExecute(Handle, PWideChar('open'), PWideChar(MainProgram), '', PWideChar(ExtractFileDir(MainProgram)), SW_NORMAL);
end;

function TupdateUpdater.SetupFullPath: String; //20161220 Igor //20240212 Igor
begin
  if SameText(ExtractFileName(MainProgram), 'vt'+ TaxYear +'.exe') or
     SameText(ExtractFileName(MainProgram), 'vtDebug'+ TaxYear +'.exe') then
    Result := 'http://www.visualtax.com/downloads/vt'+ TaxYear +'setupfull.exe'
  else
  if SameText(ExtractFileName(MainProgram), 'vtClient'+ TaxYear +'.exe') then
    Result := 'http://www.visualtax.com/downloads/vtclient'+ TaxYear +'setupfull.exe'
  //20230814 Igor <<<
  else
  //20171201 Igor<<<
    raise Exception.Create('Can not identify the update file for the current program!');
end;

procedure TupdateUpdater.sgAppListDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (ACol <> 4) then exit; //20160704 Igor
  if ARow = 0 then exit;
  if sgAppList.Cells[ACol,ARow] = '' then exit;
  if sgAppList.Cells[2,ARow] = '' then exit;
  //20160612 Igor >>>
  if MyStrToDate(sgAppList.Cells[3,ARow]) > MyStrToDate(sgAppList.Cells[2,ARow]) then //20160704 Igor
  Begin
    sgAppList.Canvas.Brush.Color := clRed;
    sgAppList.Canvas.Font.Color := clWhite;
  End
  else
  Begin
    sgAppList.Canvas.Font.Color := clGreen;
  End;
  sgAppList.Canvas.FillRect(Rect);
  sgAppList.Canvas.TextOut(Rect.Left+2, Rect.Top+2, sgAppList.Cells[ACol,ARow]);
  //20160612 Igor <<<

end;

procedure TupdateUpdater.sgAppListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Col, Row: Integer;
begin
  sgAppList.MouseToCell(X, Y, Col, Row);
  if (Col >= 0) and (Col < sgAppList.ColCount) AND (Row >= 0) and (Row < sgAppList.RowCount) then
    sgAppList.Hint := sgAppList.Cells[Col,Row]
  else
    sgAppList.Hint := '';
end;

procedure TupdateUpdater.btnDownloadClick(Sender: TObject);
var
  I: Integer;
  SetupFile : String;
  Err: String;
  HaveErr: Boolean; //20160705 Igor
begin
  FFullRefresh := False; //20160819 Igor
  Screen.Cursor := crHourGlass;
  try
    btnInstall.Tag := 0;
    btnInstall.Enabled := False;
    if not ForceDirectories(tempDefaultDownloadPath) then
    Begin
      ShowMessage('Can''t create temp dir');
      exit;
    End;
    HaveErr := False; //20160705 Igor
    for I := 0 to length(MyAppArr) - 1 do
    Begin
      if (MyAppArr[I].SetupURL <> '')
         AND
         (ChkReDownloadAll.Checked or (MyStrToDate(MyAppArr[I].AppDate) < MyStrToDate(MyAppArr[I].AppCurrentDate))) then
      begin
        SetupFile := tempDefaultDownloadPath+GetSetupFileName(MyAppArr[I].SetupURL);
        if DownloadURLFile(MyAppArr[I].SetupURL, SetupFile, Err) then
        Begin
          MyAppArr[I].SetupLocalFile := SetupFile;
          MyAppArr[I].AppStatus := 'Downloaded';
          sgAppList.Cells[4, sgAppList.Cols[0].IndexOf(MyAppArr[I].AppTitle)] := MyAppArr[I].AppStatus;
          infolbl.Caption := MyAppArr[I].SetupLocalFile + ' saved';
          btnInstall.Tag := btnInstall.Tag + 1;
        End
        else
        Begin
          MyAppArr[I].AppStatus := Err;
          sgAppList.Cells[4, sgAppList.Cols[0].IndexOf(MyAppArr[I].AppTitle)] := MyAppArr[I].AppStatus;
          infolbl.Caption := Err;
          HaveErr := True;
        End;
      end;
    End;
    //20160717 Igor >>>
    if (btnInstall.Tag = 0) and not HaveErr then
    begin
      MessageDlg('Nothing to download', mtInformation, [mbOk], 0);
      exit;
    end;
    //20160717 Igor <<<
    if btnInstall.Tag > 0 then
      btnInstall.Enabled := true;
    if not HaveErr then
    Begin
      MessageDlg('The updates have been downloaded successfully.'+#13+
                 'Now click any key to close the program and it will open again automatically.',
                 mtInformation, [mbOk], 0);
      btnInstallClick(btnInstall);
    End;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TupdateUpdater.WaitUntilCloseProgram: Boolean; //20160819 igor
var
  H: HWND;
  closeAttempts: Integer;
const
  maxCloseAttempts = 7;
begin
  closeAttempts := 0;
  Repeat
    H := FindWindow('Tvtnosplash', nil);
    If H <> 0 then
    begin
      if closeAttempts = maxCloseAttempts  then
      begin
        MessageDlg('Can not automatically close the VT program.'+#13+
                   'Please close all VT copies of the program and continue by pressing the "Install" button.',

        //MessageDlg('Can not automatically close the program "vt2015".'+#13+
        //           'Please close all vt2015 copies of the program and continue by pressing the "Install" button.',
                   mtWarning, [mbOk], 0);
        result := False;
        exit;
      end;
      inc(closeAttempts,1);
      PostMessage(H, WM_QUIT, 0, 0);
      Application.ProcessMessages;
      sleep(1500);
    end;
  Until H = 0;
  result := H = 0;
end;

procedure TupdateUpdater.btnInstallClick(Sender: TObject);
var
  I: Integer;
  //SetupFile : String;  //20170210 igor
begin
  if not WaitUntilCloseProgram then exit; //20160819 Igor
  if not FFullRefresh then  //20160819 Igor
  begin
    for I := 0 to length(MyAppArr) - 1 do
    Begin
      if (MyAppArr[I].SetupLocalFile <> '')
         AND
         (chkReInstallAll.Checked or (MyStrToDate(MyAppArr[I].AppDate) < MyStrToDate(MyAppArr[I].AppCurrentDate)))  then
      begin
//        SetupFile := tempDefaultDownloadPath+GetSetupFileName(MyAppArr[I].SetupURL); //20170210 Igor
        if DoInstall(MyAppArr[I].SetupLocalFile) then
        Begin
          MyAppArr[I].AppStatus := 'Installed';
          sgAppList.Cells[4, sgAppList.Cols[0].IndexOf(MyAppArr[I].AppTitle)] := MyAppArr[I].AppStatus;
          infolbl.Caption := MyAppArr[I].AppTitle + ' Installed';
          Application.ProcessMessages;
        End;
      end;
    End;
  end
  else  //20160819 Igor >>> full update
  begin
    //SetupFile := tempDefaultDownloadPath+'vtSetupFull.exe'; //20170210 Igor
    //20190917 Igor >>>
    //20191007 Igor >>>
    {if FFullUpdate then
      if DoInstall(FFullSetupFile) then //20170210 Igor
      Begin
        infolbl.Caption := FFullSetupFile + ' Installed'; //20170210 Igor
        Application.ProcessMessages;
      End;}
    //20191007 Igor <<<
    if FTaxModulesUpdate then
      if DoInstall(FTaxModulesSetupFile) then
      Begin
        infolbl.Caption := FTaxModulesSetupFile + ' Installed';
        Application.ProcessMessages;
      End;
    if FUtilitiesUpdate then
      if DoInstall(FUtilitiesSetupFile) then
      Begin
        infolbl.Caption := FUtilitiesSetupFile + ' Installed';
        Application.ProcessMessages;
      End;
    //20190917 Igor <<<
  end; //20160819 Igor <<<
  Cancel.Caption := 'Close';
  if MessageDlg('Update successfull.'+#13+  //20160713 Igor
                'Press "Ok" button to run the program again',   //"vt2015"', //20170208
                mtInformation, [mbOk, mbCancel], 0) = mrOk then
  begin
    Close;
    RunMainProgramm;
  end;
end;

procedure TupdateUpdater.btnFullUpdateClick(Sender: TObject); //20160819 Igor //20200311 Igor
begin
  if Assigned(FUpdateThread) then Exit;
  FFullRefresh := True;
  btnInstall.Tag := 0;
  btnInstall.Enabled := False;
  btnDownload.Enabled := False;

  if not ForceDirectories(tempDefaultDownloadPath) then
  Begin
    Screen.Cursor := crDefault; //20180420 Igor
    ShowMessage('Can''t create temp dir');
    exit;
  End;
  IsVtClient := false; //20210119 Igor
  //20170209 CON

  //20240212 Igor >>>
  //20230814 Igor >>>
  if SameText(ExtractFileName(MainProgram), 'vt'+ TaxYear +'.exe') or
     SameText(ExtractFileName(MainProgram), 'vtDebug'+ TaxYear +'.exe') then
    FFullSetupFile := tempDefaultDownloadPath+'vt'+ TaxYear +'setupfull.exe'
  else if SameText(ExtractFileName(MainProgram), 'vtclient'+ TaxYear +'.exe') then
  begin
    FFullSetupFile := tempDefaultDownloadPath+'vtclient'+ TaxYear +'setupfull.exe';
    IsVtClient := true;
  end;
  //20240212 Igor <<<
  //20230814 Igor <<<
  // SetupFile := tempDefaultDownloadPath+'VTsetupFull.exe';

  //20190917 Igor >>>
  FTaxModulesSetupFile := '';
  FTaxModulesUrl := '';
  FUtilitiesSetupFile := '';
  FUtilitiesUrl := '';
  //20191007 Igor >>>

  //20210119 Igor >>>
  if IsVtClient then
  begin
    FTaxModulesUpdate := false;
    FUtilitiesUpdate := false;
  end
  else
  begin
    //20240408 Igor >>>
    FTaxModulesUpdate := true;
    FUtilitiesUpdate := false;
//    if not FTaxModulesUpdate and not FUtilitiesUpdate then
//    begin
//      FTaxModulesUpdate := true;
//      FUtilitiesUpdate := true;
//    end;
    //20240408 Igor <<<

    //20191007 Igor <<<
    if FTaxModulesUpdate then
    begin
      FTaxModulesSetupFile := FFullSetupFile.Replace('setupFull.exe', 'taxmodulesupdate.exe', [rfIgnoreCase]);
      FTaxModulesUrl := SetupFullPath.Replace('setupFull.exe', 'taxmodulesupdate.exe', [rfIgnoreCase]);
    end;
    if FUtilitiesUpdate then
    begin
      FUtilitiesSetupFile := FFullSetupFile.Replace('setupFull.exe', 'utilitiesupdate.exe', [rfIgnoreCase]);
      FUtilitiesUrl := SetupFullPath.Replace('setupFull.exe', 'utilitiesupdate.exe', [rfIgnoreCase]);
    end;
  end;
  //20210119 Igor <<<
  FUpdateThread := TUpdateThread.Create(Self);
  FUpdateThread.Resume;
end;

procedure TupdateUpdater.CancelClick(Sender: TObject);
begin
 cancelDownloading := true;
 close;
end;

function TupdateUpdater.getLocalFileVersionAsString(const Filename: string; var localUpdateVersion: string): Boolean;
var
  VerBlk: VS_FIXEDFILEINFO;
  InfoSize,puLen : DWord;
  Pt,InfoPtr : Pointer;
begin
  localUpdateVersion := '';

  InfoSize := GetFileVersionInfoSize(PChar(Filename), puLen);
  FillChar(VerBlk, SizeOf(VS_FIXEDFILEINFO),0);

  if InfoSize > 0 then
  begin
    GetMem(Pt, InfoSize);
    GetFileVersionInfo(PChar(Filename), 0, InfoSize, Pt);
    VerQueryValue(Pt, '\', InfoPtr, puLen);
    move(InfoPtr^, VerBlk, SizeOf(VS_FIXEDFILEINFO));
    localUpdateVersion := Format('%d.%d.%d.%d',[VerBlk.dwFileVersionMS shr 16,
      VerBlk.dwFileVersionMS and 65535,
      VerBlk.dwFileVersionLS shr 16,
      VerBlk.dwFileVersionLS and 65535]);
    FreeMem(Pt);

    Result := True;
  end else
    Result := False;
end;

function TupdateUpdater.getServerUpdateVersion(): Boolean;
var
  downloadedxmlFile : TFileName;

  RootNode : IXMLNode;
  ANode : IXMLNode;
  I, J: Integer;
  AppTitle, AppRelease, AppDate, AppFile, Err: String;
  HasUtilitySection: boolean; //20190917 Igor
begin
  result := False;
  btnDownload.Enabled := false;
  btnDownload.Tag := 0;

  //20240212 Igor >>>
  downloadedxmlFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'vt'+ TaxYear +'Versions.xml';
  //20240212 Igor <<<
     //20230814 Igor <<<
  Screen.Cursor:=crHourglass;
  try
    infolbl.Caption := 'Downloading information';
    if not DownloadURLFile(xmlFileLocation, downloadedxmlFile, Err)  then
    begin
      Screen.Cursor:=crDefault;
      infolbl.Caption := Err+' Press "Cancel"';
      Raise Exception.CreateFmt(Err,[]);
      Application.Terminate;
    end;
    if not FileExists(downloadedxmlFile) then
    begin
      Screen.Cursor:=crDefault;
      infolbl.Caption := 'Cannot locate the ' + downloadedxmlFile + ' file. Press "Cancel"';
      raise exception.Create('Cannot locate the ' + downloadedxmlFile + ' file.');
      Application.Terminate;
    end;

    XMLDoc.FileName := downloadedxmlFile;
    XMLDoc.Active:=True;

    RootNode:=XMLDoc.ChildNodes.FindNode('UPDATE');
    if not Assigned(RootNode) then
    Begin
      Screen.Cursor:=crDefault; //20180420 Igor
      ShowMessage('Invalid file format');
      exit;
    End;
    HasUtilitySection := false; //20190917 Igor
    for I := 0 to RootNode.ChildNodes.Count - 1 do
    Begin
      ANode := RootNode.ChildNodes.Get(I);
      AppTitle := ANode.ChildNodes.FindNode('NAME').NodeValue;
      AppRelease := ANode.ChildNodes.FindNode('RELEASE').NodeValue;
      AppDate := ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue;
      AppFile := ANode.ChildNodes.FindNode('FILE').NodeValue;
      J := sgAppList.Cols[0].IndexOf(AppTitle);
      if (J >= 0) then
      Begin
        sgAppList.Cells[3,J] := AppDate;
        MyAppArr[J-1].AppCurrentDate := AppDate;
        MyAppArr[J-1].SetupURL := AppFile;
        if MyStrToDate(sgAppList.Cells[3,J]) > MyStrToDate(sgAppList.Cells[2,J]) then
        Begin
          //20190917 Igor >>>
          if SameText(AppTitle, 'Utilities') then
          begin
            FUtilitiesUpdate := true;
            HasUtilitySection := true;
          end
          //20191007 Igor >>>
//          else if I = 0 then
//            FFullUpdate := true
          //20191007 Igor <<<
          else
            FTaxModulesUpdate := true;
          //20190917 Igor <<<
          MyAppArr[J-1].AppStatus := 'Need download';
          sgAppList.Cells[4, sgAppList.Cols[0].IndexOf(MyAppArr[J-1].AppTitle)] := MyAppArr[J-1].AppStatus;
          btnDownload.Tag := btnDownload.Tag + 1;
        End;
      End;
    End;
    //20190917 Igor >>>
    //20191007 Igor >>>
//    if not HasUtilitySection then
//      FFullUpdate := FTaxModulesUpdate;
//    if not FTaxModulesUpdate and not FUtilitiesUpdate then
//      FFullUpdate := true;
    //20191007 Igor <<<
    //20190917 Igor <<<
    result := true;
    btnDownload.Enabled := true;
    infolbl.Caption := 'Click the button Download / Refresh to proceed'; //20180518 Igor
    if btnDownload.Tag = 0 then
      btnDownload.Caption := 'Download again'
    else
      btnDownload.Caption := 'Download';
  finally
    DeleteFile(downloadedxmlFile);
    Screen.Cursor:=crDefault;
  end;
end;

procedure TupdateUpdater.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64); //20160606 Igor
var
  Http: TIdHTTP;
  ContentLength: Int64;
  Percent: Integer;
begin
  Http := TIdHTTP(ASender);
  ContentLength := Http.Response.ContentLength;

  if (Pos('chunked', LowerCase(Http.Response.TransferEncoding)) = 0) and
     (ContentLength > 0) then
  begin
    Percent := 100*AWorkCount div ContentLength;
    ProgressBar1.Position := Percent;
  end;
end;

function TupdateUpdater.DownloadURLFile(const xmlFileLocation, downloadedxmlFile : TFileName;
  out AError: String) : boolean; //20191210 Igor
var
  Http: TIdHTTP;
  MS: TMemoryStream;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result:=True;
  AError := '';
  //20160606 Igor >>>
  Http := TIdHTTP.Create(nil);
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    MS := TMemoryStream.Create;
    try
      IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
      HTTP.IOHandler := IdSSLIOHandlerSocket;
      Http.HandleRedirects := True;
      Http.OnWork:= IdHTTP1Work;
      try
        Http.Get(xmlFileLocation, MS);
        MS.SaveToFile(downloadedxmlFile);
      except ON E: Exception DO
        begin
          Result:=False;
          AError := E.Message + #13 + xmlFileLocation; //20190917 Igor
        end;
      end;
    finally
      MS.Free;
    end;
  finally
    IdSSLIOHandlerSocket.Free;
    Http.Free;
  end;
  //20160606 Igor <<<
end;


function TupdateUpdater.getParams():boolean;

  function ExtractDigits(const inputStr: string): string; //20240212 Igor
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to Length(inputStr) do
    begin
      if inputStr[i] in ['0'..'9'] then
        Result := Result + inputStr[i];
    end;
  end;

begin
  //showmessage(inttostr(ParamCount));
  result:=true;
  if (ParamCount < 4) then //20160705 Igor
  begin
    showmessage('Parameters not sent. Please contact the vendor');
    infolbl.Caption := 'Parameters not sent. Press "Cancel" and contact the vendor.';
    result := false;
  end
  else
  begin
   Products := ParamStr(1);
   tempDefaultDownloadPath := ParamStr(2) + '\Update\';
   unzipTo := ParamStr(2)+ '\';
   xmlFileLocation := ParamStr(3);
   MainProgram := ParamStr(4); //20160705 Igor
   TaxYear := ExtractDigits(ExtractFileName(MainProgram)); //20240212 Igor
//   xmlFileLocation := 'http://localhost/vt2015Versions.xml';
  end;
end;

{ TUpdateThread }

constructor TUpdateThread.Create(AUpdater: TupdateUpdater); //20200311 Igor
begin
  FUpdater := AUpdater;
  inherited Create(false);
end;

procedure TUpdateThread.Execute; //20200311 Igor
var
  Err: string;
  HaveErr: Boolean;

  procedure UpdateInfoLabel(AText: string; AError: boolean = false);
  begin
    Synchronize(
      procedure
      begin
        FUpdater.infolbl.Caption := AText;
        if AError then
        begin
          Screen.Cursor := crDefault; //20200312 Igor
          MessageDlg(AText, mtError, [mbOk], 0);
        end;
      end);
  end;

  function DownloadURLFile(const xmlFileLocation, downloadedxmlFile : TFileName;
    out AError: String) : boolean;
  var
    Http: TIdHTTP;
    MS: TMemoryStream;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  begin
    Result:=True;
    AError := '';
    Http := TIdHTTP.Create(nil);
    IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      MS := TMemoryStream.Create;
      try
        IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
        HTTP.IOHandler := IdSSLIOHandlerSocket;
        Http.HandleRedirects := True;
        Http.OnWork:= IdHTTPWork;
        try
          Http.Get(xmlFileLocation, MS);
          MS.SaveToFile(downloadedxmlFile);
        except on E: Exception do
          begin
            Result := False;
            AError := E.Message + #13 + xmlFileLocation;
          end;
        end;
      finally
        MS.Free;
      end;
    finally
      IdSSLIOHandlerSocket.Free;
      Http.Free;
    end;
  end;

  function WaitUntilCloseProgram: Boolean;
  var
    H: HWND;
    closeAttempts: Integer;
  const
    maxCloseAttempts = 7;
  begin
    closeAttempts := 0;
    Repeat
      H := FindWindow('Tvtnosplash', nil);
      If H <> 0 then
      begin
        if closeAttempts = maxCloseAttempts  then
        begin
          Synchronize(
            procedure
            begin
              Screen.Cursor := crDefault; //20200312 Igor
              MessageDlg('Can not automatically close the VT program.'+#13+
                         'Please close all VT copies of the program and continue by pressing the "Install" button.',
                         mtWarning, [mbOk], 0);
            end);
          result := False;
          exit;
        end;
        inc(closeAttempts,1);
        PostMessage(H, WM_QUIT, 0, 0);
        sleep(1500);
      end;
    Until H = 0;
    result := H = 0;
  end;

  function DoInstall(AFileName: String): Boolean; //20210119 Igor
  var
    SetupParams: String;
    ProcessInfo: TProcessInformation;
    StartUpInfo: TStartUpInfo;
    Rlst: LongBool;
    ExitCode: Cardinal;
  begin
    result := true;
    SetupParams := ' /NOCLOSEAPPLICATIONS /SILENT /SP- /DIR="'+unzipTo+'" /NOICONS'; //20200311 Igor  //20210119 Igor
    try
      FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
      with StartUpInfo do
      begin
        cb := SizeOf(TStartUpInfo);
        dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
        wShowWindow := SW_HIDE;
      end;
      Rlst:= CreateProcess(PChar(AFileName), PChar(SetupParams),
        nil, nil, false, NORMAL_PRIORITY_CLASS,
        nil, nil, StartUpInfo, ProcessInfo);
  //    shellExecute(Handle, 'open', PChar(AFileName), PChar(SetupParams), nil, SW_HIDE);
      if Rlst then
        with ProcessInfo do
        begin
          WaitForInputIdle(hProcess, INFINITE);
          WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
          GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
          CloseHandle(hThread);
          CloseHandle(hProcess);
        end
      else
      begin
        Result := False;
      end;
    except ON E: Exception DO
      result := false;
    end;
  end;

begin
  inherited;
  Synchronize(
    procedure
    begin
      FUpdater.btnFullUpdate.Enabled := false;
      FUpdater.Cancel.Enabled := false;
      Screen.Cursor := crHourGlass; //20200312 Igor
    end);
  try
    HaveErr := False;

    //20210119 Igor >>>
    if FUpdater.IsVtClient then
    begin
      UpdateInfoLabel('Downloading '+ ExtractFileName(FUpdater.FFullSetupFile) +'. Please wait ..'); //20200312 Igor
      if not DownloadURLFile(FUpdater.SetupFullPath, FUpdater.FFullSetupFile, Err) then
      Begin
        UpdateInfoLabel(Err, true);
        HaveErr := True;
      End;
    end
    else
    begin
      if {not HaveErr and} FUpdater.FTaxModulesUpdate then
      begin
        UpdateInfoLabel('Downloading '+ ExtractFileName(FUpdater.FTaxModulesSetupFile) +'. Please wait ..'); //20200312 Igor //20230220 Igor
        if not DownloadURLFile(FUpdater.FTaxModulesUrl, FUpdater.FTaxModulesSetupFile, Err) then
        Begin
          UpdateInfoLabel(Err, true);
          HaveErr := True;
        End;
      end;
      if not Terminated and not HaveErr and FUpdater.FUtilitiesUpdate then
      begin
        UpdateInfoLabel('Downloading '+ ExtractFileName(FUpdater.FUtilitiesSetupFile) +'. Please wait ..'); //20200312 Igor
        if not DownloadURLFile(FUpdater.FUtilitiesUrl, FUpdater.FUtilitiesSetupFile, Err) then
        Begin
          UpdateInfoLabel(Err, true);
          HaveErr := True;
        End;
      end;
    end;
    //20210119 Igor <<<
    if not Terminated and not HaveErr then
    Begin
      UpdateInfoLabel('Closing Application..');
      if not WaitUntilCloseProgram then exit;

      //20210119 Igor >>>
      if FUpdater.IsVtClient then
      begin
        if not Terminated and not HaveErr then
        begin
          UpdateInfoLabel('Download completed. Now Installing the vtClient update. Please wait...');
          if DoInstall(FUpdater.FFullSetupFile) then
            UpdateInfoLabel(FUpdater.FFullSetupFile + ' Installed')
          else
            HaveErr := True;
        end;
      end
      else
      begin
        if not Terminated and not HaveErr and FUpdater.FTaxModulesUpdate then
        begin
          UpdateInfoLabel('Download completed. Now Installing the Tax Modules update. Please wait...'); //20200312 Igor
          if DoInstall(FUpdater.FTaxModulesSetupFile) then
            UpdateInfoLabel(FUpdater.FTaxModulesSetupFile + ' Installed')
          else
            HaveErr := True;
        end;
        if not Terminated and not HaveErr and FUpdater.FUtilitiesUpdate then
        begin
          UpdateInfoLabel('Download completed. Now Installing the Utilities update. Please wait...'); //20200312 Igor
          if DoInstall(FUpdater.FUtilitiesSetupFile) then
            UpdateInfoLabel(FUpdater.FUtilitiesSetupFile + ' Installed')
          else
            HaveErr := true;
        end;
      end;
      //20210119 Igor <<<
      //20200312 Igor >>>
      if not Terminated and not HaveErr then
        UpdateInfoLabel('Install completed. Now restarting the program. Please wait...');
      //20200312 Igor <<<
    End;
  finally
    Synchronize(
      procedure
      begin
        FUpdater.btnFullUpdate.Enabled := true;
        FUpdater.Cancel.Enabled := true;
        FUpdater.FUpdateThread := nil;
        Screen.Cursor := crDefault; //20200312 Igor
        if not Terminated and not HaveErr then
        begin
          FUpdater.Cancel.Caption := 'Close';
          if MessageDlg('Update successfull.'+#13+  //20160713 Igor
                        'Press "Ok" button to run the program again',   //"vt2015"', //20170208
                        mtInformation, [mbOk, mbCancel], 0) = mrOk then
          begin
            FUpdater.Close;
            FUpdater.RunMainProgramm;
          end;
        end;
      end);
  end;
end;

procedure TUpdateThread.IdHTTPWork(ASender: TObject; AWorkMode: TWorkMode; //20200311 Igor
  AWorkCount: Int64);
var
  Http: TIdHTTP;
  ContentLength: Int64;
  Percent: Integer;
begin
  Http := TIdHTTP(ASender);
  ContentLength := Http.Response.ContentLength;

  if (Pos('chunked', LowerCase(Http.Response.TransferEncoding)) = 0) and
     (ContentLength > 0) then
  begin
    Percent := 100*AWorkCount div ContentLength;
    Synchronize(
      procedure
      begin
        FUpdater.ProgressBar1.Position := Percent;
      end);
  end;

end;

end.
