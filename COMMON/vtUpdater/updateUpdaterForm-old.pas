unit updateUpdaterForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, vtLabel, jpeg, ExtCtrls,
  xmldom, XMLIntf, msxmldom, XMLDoc,
  ExtActns,
  ShellAPI, Vcl.Grids, Vcl.Buttons, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, System.Actions, Vcl.ActnList,
  System.UITypes; //20160819 Igor

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
  private
    { Private declarations }
    MyAppArr: TMyAppArr;
    FFullRefresh: Boolean;  //20160819 Igor
    function DoInstall(AFileName: String): Boolean;
    procedure RunMainProgramm;
    function WaitUntilCloseProgram: Boolean;//20160705 Igor
    function SetupFullPath: String; //20161220 Igor
  public
    { Public declarations }
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
  {updaterPath,}appPath, MainProgram:string; //20160526 Igor //20160705 Igor
  vtUpdaterLocation:string;
  cancelDownloading:Boolean;

implementation

{$R *.dfm}

function MyStrToDate(S: String): TDateTime;
var
  Y,M,D: Word;
Begin
  Y := StrToInt(copy(S,1,4));
  M := StrToInt(copy(S,6,2));
  D := StrToInt(copy(S,9,2));
  Result := EncodeDate(Y,M,D);
End;

function GetSetupFileName(S:String):String;
Begin
  while pos('/',S)>0 do
    Delete(S,1,pos('/',S));
  Result := S;
End;


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
    sgAppList.Cells[2,0] := 'You version';
    sgAppList.Cells[3,0] := 'Last version';
    sgAppList.Cells[4,0] := 'Status';

    I := 1;
    SetLength(MyAppArr,I);
    while products > '' do
    Begin
      sgAppList.Cells[0,I] := Copy(products,1,pos('>>',Products)-1);
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
  SetupParams := ' /VERYSILENT /SP- /DIR="'+unzipTo+'" /NOICONS';
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

function TupdateUpdater.SetupFullPath: String; //20161220 Igor
begin
  if SameText(ExtractFileName(MainProgram), 'vt2015.exe') then
    //20161221 CON Name on the web changed from vtsetupfull to Vt2015SetupFull.exe
    Result := 'http://www.visualtax.com/Downloads/vt2015SetupFull.exe'
  else
  if SameText(ExtractFileName(MainProgram), 'vt2016.exe') then
    Result := 'http://www.visualtax.com/Downloads/VT2016SetupFull.exe'
  else
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
        MessageDlg('Can not automatically close the program "vt2015".'+#13+
                   'Please close all vt2015 copy of the program and continue by pressing the "Install" button.',
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
  SetupFile : String;
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
        SetupFile := tempDefaultDownloadPath+GetSetupFileName(MyAppArr[I].SetupURL);
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
    SetupFile := tempDefaultDownloadPath+'vtSetupFull.exe';
    if DoInstall(SetupFile) then
    Begin
      infolbl.Caption := SetupFile + ' Installed';
      Application.ProcessMessages;
    End;
  end; //20160819 Igor <<<
  Cancel.Caption := 'Close';
  if MessageDlg('Update successfull.'+#13+  //20160713 Igor
                'Press "Ok" button for run "vt2015"',
                mtInformation, [mbOk, mbCancel], 0) = mrOk then
  begin
    Close;
    RunMainProgramm;
  end;
end;

procedure TupdateUpdater.btnFullUpdateClick(Sender: TObject); //20160819 Igor
var
  SetupFile : String;
  Err: String;
  HaveErr: Boolean;
begin
  FFullRefresh := True;
  Screen.Cursor := crHourGlass;
  try
    btnInstall.Tag := 0;
    btnInstall.Enabled := False;
    btnDownload.Enabled := False;

    if not ForceDirectories(tempDefaultDownloadPath) then
    Begin
      ShowMessage('Can''t create temp dir');
      exit;
    End;
    HaveErr := False;
    SetupFile := tempDefaultDownloadPath+'VTsetupFull.exe';
    if not DownloadURLFile(SetupFullPath, SetupFile, Err) then //20161220 Igor
    Begin
      MessageDlg(Err, mtError, [mbOk], 0);
      infolbl.Caption := Err;
      HaveErr := True;
    End;
    if not HaveErr then
    Begin
      btnInstallClick(btnInstall);
    End;
  finally
    Screen.Cursor := crDefault;
    btnDownload.Enabled := True;
  end;
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
begin
  result := False;
  btnDownload.Enabled := false;
  btnDownload.Tag := 0;
  downloadedxmlFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'vt2015Versions.xml';

  Screen.Cursor:=crHourglass;
  try
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
      ShowMessage('Invalid file format');
      exit;
    End;
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
          MyAppArr[J-1].AppStatus := 'Need download';
          sgAppList.Cells[4, sgAppList.Cols[0].IndexOf(MyAppArr[J-1].AppTitle)] := MyAppArr[J-1].AppStatus;
          btnDownload.Tag := btnDownload.Tag + 1;
        End;
      End;
    End;
    result := true;
    btnDownload.Enabled := true;
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
  out AError: String) : boolean;
var
  Http: TIdHTTP;
  MS: TMemoryStream;
begin
  Result:=True;
  AError := '';
  //20160606 Igor >>>
  Http := TIdHTTP.Create(nil);
  try
    MS := TMemoryStream.Create;
    try
      Http.HandleRedirects := True;
      Http.OnWork:= IdHTTP1Work;
      try
        Http.Get(xmlFileLocation, MS);
        MS.SaveToFile(downloadedxmlFile);
      except ON E: Exception DO
        begin
          Result:=False;
          AError := E.Message;
        end;
      end;
    finally
      MS.Free;
    end;
  finally
    Http.Free;
  end;
  //20160606 Igor <<<
end;


function TupdateUpdater.getParams():boolean;
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
//   xmlFileLocation := 'http://localhost/vt2015Versions.xml';
  end;
end;

end.
